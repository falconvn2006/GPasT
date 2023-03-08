unit uLauncherApi;

interface

uses
  Windows, TLHelp32, Generics.Collections, Messages, PsAPI, SysUtils;

const
  WM_FORCE_REPLIC = WM_APP + 1;
  WM_FORCE_PUSH = WM_APP + 2;
  WM_FORCE_PULL = WM_APP + 3;
  EXE_NAME = 'LaunchV7.exe';
  WINDOW_CLASS_NAME = 'TFrm_LaunchV7';

type
  TProcessInfo = packed record
    PID: DWORD;
    Name: string;
    Cmd: string;
    class function Initialize(PID: DWORD; Name, Cmd: string): TProcessInfo; static;
  end;

  TWindowsInfo = packed record
    HWND: THANDLE;
    PID: DWORD;
    TID: DWORD;
    Name: string;
    Classe: string;
    class function Initialize(HWND: THANDLE; TID, PID: DWORD; Name, Classe: string): TWindowsInfo; static;
  end;

  TThreadInfo = packed record
    TID: DWORD;
    PID: DWORD;
    class function Initialize(TID, PID: DWORD): TThreadInfo; static;
  end;

// fonctions de recherche
function GetProcessList(var Liste: TList<TProcessInfo>): DWORD;

function GetThreadsList(ProcessId: DWORD; var Liste: TList<TThreadInfo>): DWORD;

function FindProcess(ProcessName: string): TProcessInfo;

function FindWindowsByClass(ProcessID: DWORD; ClsName: string): TWindowsInfo;

function GetWindowsList(ThreadId: DWORD; var Liste: TList<TWindowsInfo>): DWORD;


// procédures du launcher
procedure LauncherForcePushPull();

procedure LauncherForcePush();

procedure LauncherForcePull();

procedure DoAction(const aConst: Integer);

implementation

{ TProcessInfo }
class function TProcessInfo.Initialize(PID: DWORD; Name, Cmd: string): TProcessInfo;
begin
  Result.PID := PID;
  Result.Name := Name;
  Result.Cmd := Cmd;
end;

{ TWindowsInfo }
class function TWindowsInfo.Initialize(HWND: THANDLE; TID, PID: DWORD; Name, Classe: string): TWindowsInfo;
begin
  Result.HWND := HWND;
  Result.TID := TID;
  Result.PID := PID;
  Result.Name := Name;
  Result.Classe := Classe;
end;

{ TThreadInfo }
class function TThreadInfo.Initialize(TID, PID: DWORD): TThreadInfo;
begin
  Result.TID := TID;
  Result.PID := PID;
end;

{ Callback}
function EnumWindows_CallBack(Handle: HWND; List: TList<TWindowsInfo>): BOOL; stdcall;
var
  TID, PID: DWORD;
  WndName, ClsName: string;
begin
  TID := GetWindowThreadProcessId(Handle, PID);
  SetLength(ClsName, 255);
  SetLength(ClsName, GetClassName(Handle, PChar(ClsName), Length(ClsName)));
  SetLength(WndName, 255);
  SetLength(WndName, GetWindowText(Handle, PChar(WndName), Length(WndName)));
  List.Add(TWindowsInfo.Initialize(Handle, TID, PID, WndName, ClsName));
  Result := true;
end;

// fonctions de recherche
function GetProcessInfos(PID: DWORD; out Name, Command: string): boolean;
var
  ProcessHandle: Cardinal;
  buffer: array[0..MAX_PATH - 1] of Char;
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

function GetProcessList(var Liste: TList<TProcessInfo>): DWORD;
var
  i: cardinal;
  lstProcess: array of DWORD;
  ReturnedBytes: cardinal;
  Name, Command: string;
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
        for i := 0 to Length(lstProcess) - 1 do
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

function FindWindowsByClass(ProcessID: DWORD; ClsName: string): TWindowsInfo;
var
  ThreadListe: TList<TThreadInfo>;
  WindowsListe: TList<TWindowsInfo>;
  i, j: integer;
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
      for i := 0 to ThreadListe.Count - 1 do
      begin
        try
          if GetWindowsList(ThreadListe[i].TID, WindowsListe) = 0 then
            for j := 0 to WindowsListe.Count - 1 do
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

function GetThreadsList(ProcessId: DWORD; var Liste: TList<TThreadInfo>): DWORD;
var
  snapshot: THandle;
  ThreadEntry: TThreadEntry32;
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

function FindProcess(ProcessName: string): TProcessInfo;
var
  ProcessListe: TList<TProcessInfo>;
  i: integer;
begin
  Result.PID := 0;
  Result.Name := ProcessName;
  ProcessListe := nil;
  try
    if GetProcessList(ProcessListe) = 0 then
      for i := 0 to ProcessListe.Count - 1 do
        if ProcessListe[i].Name = ProcessName then
        begin
          Result := ProcessListe[i];
          Break;
        end;
  finally
    FreeAndNil(ProcessListe);
  end;
end;

function GetWindowsList(ThreadId: DWORD; var Liste: TList<TWindowsInfo>): DWORD;
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


{ procedures de réplications }
procedure LauncherForcePushPull();
begin
  DoAction(WM_FORCE_REPLIC);
end;

procedure LauncherForcePush();
begin
  DoAction(WM_FORCE_PUSH);
end;

procedure LauncherForcePull();
begin
  DoAction(WM_FORCE_PULL);
end;

procedure DoAction(const aConst: integer);
var
  processLauncher: TProcessInfo;
  WinInfo: TWindowsInfo;
begin
  processLauncher := FindProcess(EXE_NAME);

  if (processLauncher.PID = 0) then
  begin
    raise Exception.Create('Impossible de trouver le process : ' + EXE_NAME);

  end
  else
  begin
    WinInfo := FindWindowsByClass(processLauncher.PID, WINDOW_CLASS_NAME);

    if WinInfo.HWND = 0 then
      raise Exception.Create('Impossible de trouver la fenêtre de classe : ' + WINDOW_CLASS_NAME)
    else
    begin
      if not PostMessage(WinInfo.HWND, aConst, 0, 0) then
        raise Exception.Create('Erreur lors du PostMessage : ' + SysErrorMessage(GetLastError()));
    end;
  end;
end;

end.

