unit uGetWindowsList;

interface

uses
  Windows,
  TLHelp32,
  Generics.Collections;

type
  TSessionInfo = packed record
    SID : DWORD;
    Name : string;
    class function Initialize(SID : DWORD; Name : string) : TSessionInfo; static;
  end;

  TProcessInfo = packed record
    PID : DWORD;
    Name : string;
    Cmd : string;
    class function Initialize(PID : DWORD; Name, Cmd : string) : TProcessInfo; static;
  end;

  TThreadInfo = packed record
    TID : DWORD;
    PID : DWORD;
    class function Initialize(TID, PID : DWORD) : TThreadInfo; static;
  end;

  TWindowsInfo = packed record
    HWND : THANDLE;
    PID : DWORD;
    TID : DWORD;
    Name : string;
    Classe : string;
    class function Initialize(HWND : THANDLE; TID, PID : DWORD; Name, Classe : string) : TWindowsInfo; static;
  end;

// recup des liste !
function GetSessionsList(var Liste : TList<TSessionInfo>) : DWORD;
function GetStationsList(var Liste : TList<string>) : DWORD;
function GetDesktopsList(var Liste : TList<string>) : DWORD;
function GetProcessList(var Liste : TList<TProcessInfo>) : DWORD;
function GetThreadsList(var Liste : TList<TThreadInfo>) : DWORD; overload;
function GetThreadsList(ProcessId : DWORD; var Liste : TList<TThreadInfo>) : DWORD; overload;
function GetWindowsList(var Liste : TList<TWindowsInfo>) : DWORD; overload;
function GetWindowsList(ThreadId : DWORD; var Liste : TList<TWindowsInfo>) : DWORD; overload;
function GetWindowsList(ProcessId : DWORD; var ThreadListe : TList<TThreadInfo>; var WindowsListe : TList<TWindowsInfo>) : DWORD; overload;
// fonction de recherche !
function FindProcess(ProcessName : string) : TProcessInfo;
function FindWindowsByName(ProcessID : DWORD; WndName : string) : TWindowsInfo;
function FindWindowsByClass(ProcessID : DWORD; ClsName : string) : TWindowsInfo;

implementation

uses
  PSAPI,
  SysUtils;

{ TSessionInfo }

class function TSessionInfo.Initialize(SID : DWORD; Name : string) : TSessionInfo;
begin
  Result.SID := SID;
  Result.Name := Name;
end;

{ TProcessInfo }

class function TProcessInfo.Initialize(PID : DWORD; Name, Cmd : string) : TProcessInfo;
begin
  Result.PID := PID;
  Result.Name := Name;
  Result.Cmd := Cmd;
end;

{ TThreadInfo }

class function TThreadInfo.Initialize(TID, PID : DWORD) : TThreadInfo;
begin
  Result.TID := TID;
  Result.PID := PID;
end;

{ TWindowsInfo }

class function TWindowsInfo.Initialize(HWND : THANDLE; TID, PID : DWORD; Name, Classe : string) : TWindowsInfo;
begin
  Result.HWND := HWND;
  Result.TID := TID;
  Result.PID := PID;
  Result.Name := Name;
  Result.Classe := Classe;
end;

// eurf...

type
  TWtsConnectStateClass = (WTSActive, WTSConnected, WTSConnectQuery, WTSShadow, WTSDisconnected, WTSIdle, WTSListen, WTSReset, WTSDown, WTSInit);
  TWtsSessionInfo = record
                      SessionId : DWORD;
                      pWinStationName : LPTSTR;
                      State : TWtsConnectStateClass;
                    end;
  pTWtsSessionInfo = ^TWtsSessionInfo;

// Fonction externe !

function WTSEnumerateSessionsW(hServer : THandle; Reserved : DWORD; Version : DWORD; out pSessionInfo : pTWtsSessionInfo; out Count : DWORD): BOOL; stdcall; external 'WTSAPI32.DLL';
procedure WTSFreeMemory(pMemory : Pointer); stdcall; external 'WTSAPI32.DLL';

// Callback !!

function EnumWindowStations_CallBack(StationName : PChar; List : TList<string>) : BOOL; stdcall;
begin
  List.Add(StationName);
  Result := true;
end;

function EnumDesktops_CallBack(DesktopName : PChar; List : TList<string>) : BOOL; stdcall;
begin
  List.Add(DesktopName);
  Result := true;
end;

function EnumWindows_CallBack(Handle : HWND; List : TList<TWindowsInfo>) : BOOL; stdcall;
var
  TID, PID : DWORD;
  WndName, ClsName : string;
begin
  TID := GetWindowThreadProcessId(Handle, PID);
  SetLength(ClsName, 255);
  SetLength(ClsName, GetClassName(Handle, PChar(ClsName), Length(ClsName)));
  SetLength(WndName, 255);
  SetLength(WndName, GetWindowText(Handle, PChar(WndName), Length(WndName)));
  List.Add(TWindowsInfo.Initialize(Handle, TID, PID, WndName, ClsName));
  Result := true;
end;

// process

function GetProcessInfos(PID: DWORD; out Name, Command : string) : boolean;
var
  ProcessHandle : Cardinal;
  buffer : array[0..MAX_PATH - 1] of Char;
begin
  Result := false;
  Zeromemory(@buffer, sizeof(buffer));
  ProcessHandle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, FALSE, PID);
  if ProcessHandle <> 0 then
  begin
    try
      GetModulebaseName(ProcessHandle, 0, buffer, sizeof(buffer));
      Name := (string(buffer));
      GetModuleFilenameEx(ProcessHandle, 0, buffer, sizeof(buffer));
      Command := (string(buffer));
      Result := true;
    finally
      CloseHandle(ProcessHandle);
    end;
  end;
end;

// fonction de l'unité

function GetSessionsList(var Liste : TList<TSessionInfo>) : DWORD;
var
  pSessionInfo : pTWtsSessionInfo;
  SessionsInfo : Array of TWtsSessionInfo;
  NbSession, i : DWORD;
begin
  Result := 0;
  if not Assigned(Liste) then
    Liste := TList<TSessionInfo>.Create();
  try
    try
      if WTSEnumerateSessionsW(0, 0, 1, pSessionInfo, NbSession) then
      begin
        SetLength(SessionsInfo, NbSession);
        Move(pSessionInfo^, SessionsInfo[0], NbSession * SizeOf(TWtsSessionInfo));
        for i := 0 to NbSession -1 do
          Liste.Add(TSessionInfo.Initialize(SessionsInfo[i].SessionID, SessionsInfo[i].pWinStationName));
      end
      else
        Result := GetLastError();
    finally
      WTSFreeMemory(pSessionInfo);
    end;
  except
    on E: Exception do
      Result := High(DWORD);
  end;
end;

function GetStationsList(var Liste : TList<string>) : DWORD;
begin
  Result := 0;
  if not Assigned(Liste) then
    Liste := TList<string>.Create();
  try
    if not EnumWindowStations(@EnumWindowStations_CallBack, LPARAM(Liste)) then
      Result := GetLastError();
  except
    on E: Exception do
      Result := High(DWORD);
  end;
end;

function GetDesktopsList(var Liste : TList<string>) : DWORD;
begin
  Result := 0;
  if not Assigned(Liste) then
    Liste := TList<string>.Create();
  try
    if not EnumDesktops(0, @EnumDesktops_CallBack, LPARAM(Liste)) then
      Result := GetLastError();
  except
    on E: Exception do
      Result := High(DWORD);
  end;
end;

function GetProcessList(var Liste : TList<TProcessInfo>) : DWORD;
var
  i : cardinal;
  lstProcess : array of DWORD;
  ReturnedBytes : cardinal;
  Name, Command : string;
begin
  Result := 0;
  if not Assigned(Liste) then
    Liste := TList<TProcessInfo>.Create();
  try
    try
      SetLength(lstProcess, 2048);
      ZeroMemory(lstProcess, Length(lstProcess) * SizeOf(DWORD));
      if EnumProcesses(PDWORD(lstProcess), Length(lstProcess) * SizeOf(DWORD), ReturnedBytes) then
      begin
        SetLength(lstProcess, ReturnedBytes div SizeOf(DWORD));
        for i := 0 to Length(lstProcess) -1 do
        begin
          if GetProcessInfos(lstProcess[i], Name, Command) then
            Liste.Add(TProcessInfo.Initialize(lstProcess[i], Name, Command))
          else
            Liste.Add(TProcessInfo.Initialize(lstProcess[i], '', ''))
        end;
      end
      else
        Result := GetLastError();
    finally
      SetLength(lstProcess, 0);
    end;
  except
    on E: Exception do
    begin
      Result := High(DWORD);
    end;
  end;
end;

function GetThreadsList(var Liste : TList<TThreadInfo>) : DWORD;
var
  snapshot : THandle;
  ThreadEntry : TThreadEntry32;
begin
  Result := 0;
  if not Assigned(Liste) then
    Liste := TList<TThreadInfo>.Create();
  try
    snapshot := CreateToolHelp32Snapshot(TH32CS_SnapThread, 0);
    if snapshot = INVALID_HANDLE_VALUE then
      Result := GetLastError()
    else
    begin
      try
        ThreadEntry.dwSize := sizeOf(ThreadEntry);
        if Thread32First(snapshot, ThreadEntry) then
        begin
          repeat
            Liste.Add(TThreadInfo.Initialize(ThreadEntry.th32ThreadID, ThreadEntry.th32OwnerProcessID));
          until not Thread32Next(snapshot, ThreadEntry);
        end
        else
          Result := GetLastError();
      finally
        CloseHandle(snapshot);
      end;
    end;
  except
    on E: Exception do
      Result := High(DWORD);
  end;
end;

function GetThreadsList(ProcessId : DWORD; var Liste : TList<TThreadInfo>) : DWORD;
var
  snapshot : THandle;
  ThreadEntry : TThreadEntry32;
begin
  Result := 0;
  if not Assigned(Liste) then
    Liste := TList<TThreadInfo>.Create();
  try
    snapshot := CreateToolHelp32Snapshot(TH32CS_SnapThread, 0);
    if snapshot = INVALID_HANDLE_VALUE then
      Result := GetLastError()
    else
    begin
      try
        ThreadEntry.dwSize := sizeOf(ThreadEntry);
        if Thread32First(snapshot, ThreadEntry) then
        begin
          repeat
            if ThreadEntry.th32OwnerProcessID = ProcessId then
              Liste.Add(TThreadInfo.Initialize(ThreadEntry.th32ThreadID, ThreadEntry.th32OwnerProcessID));
          until not Thread32Next(snapshot, ThreadEntry);
        end
        else
          Result := GetLastError();
      finally
        CloseHandle(snapshot);
      end;
    end;
  except
    on E: Exception do
      Result := High(DWORD);
  end;
end;

function GetWindowsList(var Liste : TList<TWindowsInfo>) : DWORD;
begin
  Result := 0;
  if not Assigned(Liste) then
    Liste := TList<TWindowsInfo>.Create();
  try
    if not EnumWindows(@EnumWindows_CallBack, LPARAM(Liste)) then
      Result := GetLastError();
  except
    on E: Exception do
      Result := High(DWORD);
  end;
end;

function GetWindowsList(ThreadId : DWORD; var Liste : TList<TWindowsInfo>) : DWORD;
begin
  Result := 0;
  if not Assigned(Liste) then
    Liste := TList<TWindowsInfo>.Create();
  try
    if not EnumThreadWindows(ThreadId, @EnumWindows_CallBack, LPARAM(Liste)) then
      Result := GetLastError();
  except
    on E: Exception do
      Result := High(DWORD);
  end;
end;

function GetWindowsList(ProcessId : DWORD; var ThreadListe : TList<TThreadInfo>; var WindowsListe : TList<TWindowsInfo>) : DWORD;
var
  InfoThread : TThreadInfo;
  InfoWindow : TWindowsInfo;
  tmpList : TList<TWindowsInfo>;
begin
  if not Assigned(WindowsListe) then
    WindowsListe := TList<TWindowsInfo>.Create();
  Result := GetThreadsList(ProcessId, ThreadListe);
  if Result = 0 then
  begin
    for InfoThread in ThreadListe do
    begin
      Result := GetWindowsList(InfoThread.TID, tmpList);
      if Result = 0 then
      begin
        for InfoWindow in tmpList do
        begin
          WindowsListe.Add(TWindowsInfo.Initialize(InfoWindow.HWND, InfoWindow.TID, InfoWindow.PID, InfoWindow.Name, InfoWindow.Classe));
        end;
        FreeAndNil(tmpList);
      end
      else
        Exit;
    end;
  end;
end;

// fonction de recherche

function FindProcess(ProcessName : string) : TProcessInfo;
var
  ProcessListe : TList<TProcessInfo>;
  i : integer;
begin
  Result.PID := 0;
  Result.Name := ProcessName;
  ProcessListe := nil;
  try
    if GetProcessList(ProcessListe) = 0 then
      for i := 0 to ProcessListe.Count -1 do
        if ProcessListe[i].Name = ProcessName then
        begin
          Result := ProcessListe[i];
          Break;
        end;
  finally
    FreeAndNil(ProcessListe);
  end;
end;

function FindWindowsByName(ProcessID : DWORD; WndName : string) : TWindowsInfo;
var
  ThreadListe : TList<TThreadInfo>;
  WindowsListe : TList<TWindowsInfo>;
  i, j : integer;
begin
  Result.HWND := 0;
  Result.PID := 0;
  Result.TID := 0;
  Result.Name := WndName;
  Result.Classe := '';

  ThreadListe := nil;
  WindowsListe := nil;
  try
    if GetThreadsList(ProcessID, ThreadListe) = 0 then
    begin
      for i := 0 to ThreadListe.Count -1 do
      begin
        try
          if GetWindowsList(ThreadListe[i].TID, WindowsListe) = 0 then
          begin
            for j := 0 to WindowsListe.Count -1 do
            begin
              if SameText(WindowsListe[j].Name, WndName) then
              begin
                Result := WindowsListe[j];
                Break;
              end;
            end;
          end;
        finally
          FreeAndNil(WindowsListe);
        end;
        if Result.HWND <> 0 then
          Break;
      end;
    end;
  finally
    FreeAndNil(ThreadListe);
  end;
end;

function FindWindowsByClass(ProcessID : DWORD; ClsName : string) : TWindowsInfo;
var
  ThreadListe : TList<TThreadInfo>;
  WindowsListe : TList<TWindowsInfo>;
  i, j : integer;
begin
  Result.HWND := 0;
  Result.PID := 0;
  Result.TID := 0;
  Result.Name := '';
  Result.Classe := ClsName;

  ThreadListe := nil;
  WindowsListe := nil;
  try
    if GetThreadsList(ProcessID, ThreadListe) = 0 then
      for i := 0 to ThreadListe.Count -1 do
      begin
        try
          if GetWindowsList(ThreadListe[i].TID, WindowsListe) = 0 then
            for j := 0 to WindowsListe.Count -1 do
              if SameText(WindowsListe[j].Classe, ClsName) then
              begin
                Result := WindowsListe[j];
                Break;
              end;
        finally
          FreeAndNil(WindowsListe);
        end;
        if Result.HWND <> 0 then
          Break;
      end;
  finally
    FreeAndNil(ThreadListe);
  end;
end;

end.
