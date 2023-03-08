unit UUtils;

interface

uses
  System.Classes;

function ComputerName: string;

function GetFileSizeEx(const FileName: string): Int64;

procedure GetFileInfo(const FileName: string; Infos: TStrings);

function GetProcessInfo(ExeFileName: string; out PId: Cardinal): Boolean;

function GetPathFromPID(const PID: cardinal): string;
function GetPathFromServiceExecutable(MachineName, ServiceName: string): string;

function GetExeFileVersion(const ExeFileName: string): string;

function GetInterbaseVersion: string;

function ArretSystem(TypeArret: Cardinal): Boolean;

implementation

uses
  System.Types, Winapi.Windows, System.SysUtils, Winapi.TlHelp32, Winapi.PsAPI,
  System.Win.Registry, WinSvc,
  UConstants;


function ComputerName: string;
var
  Buffer: array[0..MAX_COMPUTERNAME_LENGTH] of Char;
  Size: DWORD;
begin
  Size:= Length(Buffer);
  if GetComputerName(Buffer, Size) then
    Result := Buffer
  else
    Result := '';
end;


function GetFileSizeEx(const FileName: string): Int64;
var
  SRec: TSearchrec;
  converter: packed record
  case Boolean Of
    False: (n: Int64);
    True: (low, high: DWORD);
  end;
begin
  Result := -1;
  if FindFirst(FileName, faAnyfile, SRec) = 0 then
  begin
    converter.Low := SRec.FindData.nFileSizeLow;
    converter.High := SRec.FindData.nFileSizeHigh;
    Result := converter.n;
    FindClose(SRec);
  end;
end;


procedure GetFileInfo(const FileName: string; Infos: TStrings);
const
  VersionInfo: array [1..8] of string
      = ('FileDescription', 'CompanyName', 'FileVersion', 'InternalName',
         'LegalCopyRight', 'OriginalFileName', 'ProductName', 'ProductVersion');
var
  Handle   : DWord;
  Info     : Pointer;
  InfoData : Pointer;
  InfoSize : LongInt;
  DataLen  : Cardinal;
  LangPtr  : Pointer;
  InfoType : string;
  i        : integer;
begin
  { Demande de la taille nécessaire pour stocker les infos de Version}
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Handle);
  if InfoSize > 0 then
  begin
    { Réservation de la mémoire nécessaire}
    GetMem(Info, InfoSize);

    try
      if GetFileVersionInfo(PChar(FileName), Handle, InfoSize, Info) then
      begin
        for i := 1 to 8 do
        begin
          InfoType := VersionInfo[i];
          if VerQueryValue(Info, '\VarFileInfo\Translation', LangPtr, DataLen) then
            InfoType := Format('\StringFileInfo\%0.4x%0.4x\%s'#0, [LoWord(LongInt(LangPtr^)), HiWord(LongInt(LangPtr^)), InfoType]);
          if VerQueryValue(Info, @InfoType[1], InfoData, Datalen) then
            Infos.Add(VersionInfo[i] + ' : ' + StrPas(PWideChar(InfoData)));
        end;
      end;
    finally
      FreeMem(Info, InfoSize);
    end;
  end;
end;


function GetProcessInfo(ExeFileName: string; out PId: Cardinal): Boolean;
var
  PsExist: Boolean;
  SnHandle: THandle;
  PsEntry: TProcessEntry32;
begin
  Result := False;
  PId := 0;
  SnHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    PsEntry.dwSize := SizeOf(TProcessEntry32);
    PsExist := Process32First(SnHandle, PsEntry);
    while PsExist do
    begin
      if UpperCase(ExtractFileName(PsEntry.szExeFile)) = UpperCase(ExeFileName) then
      begin
        PId := PsEntry.th32ProcessID;
        Result := True;
        Exit;
      end;
      PsExist := Process32Next(SnHandle, PsEntry);
    end;
  finally
    CloseHandle(SnHandle);
  end;
end;


function GetPathFromPID(const PID: cardinal): string;
var
  PsHdle: THandle;
  path: array[0..MAX_PATH - 1] of char;
begin
  PsHdle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, false, PID);
  if PsHdle <> 0 then
    try
      if GetModuleFileNameEx(PsHdle, 0, path, MAX_PATH) = 0 then
        RaiseLastOSError;
      Result := path;
    finally
      CloseHandle(PsHdle)
    end
  else
    RaiseLastOSError;
end;


function GetPathFromServiceExecutable(MachineName, ServiceName: string): string;
var
  SCMHdle, SCSvcHdle: SC_Handle;
  SvcConfig: PQueryServiceConfigA;
  Size, BytesNeeded: DWord;
begin
  Result := '';
  SCMHdle := OpenSCManager(PChar(MachineName), nil, SC_MANAGER_CONNECT);
  if (SCMHdle > 0) then
  try
    SCSvcHdle := OpenService(SCMHdle, PChar(ServiceName), SERVICE_QUERY_CONFIG);
    if (SCSvcHdle > 0) then
    try
      QueryServiceConfig(SCSvcHdle, nil, 0, Size);
      SvcConfig := AllocMem(Size);
      try
        if not QueryServiceConfig(SCSvcHdle, @SvcConfig, Size, BytesNeeded) then
          Exit;
        Result := SvcConfig^.lpBinaryPathName;
      finally
        Dispose(SvcConfig);
      end;
    finally
      CloseServiceHandle(SCSvcHdle);
    end;
  finally
    CloseServiceHandle(SCMHdle);
  end;
end;


function GetExeFileVersion(const ExeFileName: string): string;
var
  VInfos: TStringList;
  i: Integer;
begin
  //
  VInfos := TStringList.Create;
  try
    GetFileInfo(ExeFileName, VInfos);
    for i := 0 to VInfos.Count - 1 do
      if Pos('FileVersion', VInfos[i]) > 0 then
        Exit(StringReplace(VInfos[i], 'FileVersion :', '', []));
  finally
    VInfos.Free;
  end;
  Result := '';
end;


function GetInterbaseVersion: string;
var
  Reg: TRegistry;
  Key, ExeFileName: string;
  VInfos: TStringList;
  i: Integer;
begin
  Result := '';
  Reg := TRegistry.Create;
  try
    Reg.Access := KEY_READ;// + KEY_WOW64_32KEY;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    //
    if Reg.KeyExists(HK_INTERBASE) then
    begin
      if Reg.KeyExists(HK_IB_XE) then
         Key := HK_IB_XE // HKEY_LOCAL_MACHINE\SOFTWARE\Borland\InterBase\Servers\gds_db
      else if Reg.KeyExists(HK_IB_71) then
        Key := HK_IB_71  // HKEY_LOCAL_MACHINE\SOFTWARE\Borland\InterBase\CurrentVersion
      else
        Exit;

      if Reg.OpenKey(Key, False) then
      begin
        ExeFileName := Reg.GetDataAsString(HK_IB_VALUES);
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
  //
  VInfos := TStringList.Create;
  try
    GetFileInfo(ExeFileName + '\' + IB_EXE_NAME, VInfos);
    for i := 0 to VInfos.Count - 1 do
      if Pos('FileVersion', VInfos[i]) > 0 then
        Exit(StringReplace(VInfos[i], 'FileVersion :', 'Interbase', []));
  finally
    VInfos.Free;
  end;
end;

function ArretSystem(TypeArret: Cardinal): Boolean;
// Exemples
// EWX_LOGOFF   => Fermeture session
// EWX_POWEROFF => Arrêt
// EWX_SHUTDOWN + EWX_ FORCE = > Arrêt forcé
// EWX_REBOOT   => Redémarrage
var
  Token: THandle;
  TokenPrivilege: TTokenPrivileges;
  Outlen: Cardinal;
  Error: DWORD;
begin
   Result := False;
   // Récupère les informations de sécurité pour ce process.
   if not OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES, Token) then
     Exit;

  try
    FillChar(TokenPrivilege, SizeOf(TokenPrivilege), 0);
    // Valeur de retour
    Outlen := 0;
    // Un seul privilège à positionner
    TokenPrivilege.PrivilegeCount := 1;

    // Récupère le LUID pour le privilège 'shutdown'.
    // un Locally Unique IDentifier est une valeur générée unique jusqu'a ce
    // que le système soit redémarré
    LookupPrivilegeValue(nil, 'SeShutdownPrivilege', TokenPrivilege.Privileges[0].Luid);

    // Positionne le privilége shutdown pour ce process.
    TokenPrivilege.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    SetLastError(0);
    AdjustTokenPrivileges(Token, False, TokenPrivilege, SizeOf(TokenPrivilege), nil, OutLen);

    Error := GetLastError;
    if Error <> ERROR_SUCCESS then
      Exit;

    // Arrête le système
    if not ExitWindowsEx(TypeArret, 0) then
      Exit;
    Result := True;
  finally
    CloseHandle(Token);
  end;
end;

{
function GetPathFromInterbaseService(MachineName: string): string;
const
  MaxSvcs = 4096;
type
  TSvcA = array[0..MaxSvcs] of TEnumServiceStatus;
  PSvcA = ^TSvcA;
var
  SCMHdle, SCSvcHdle: SC_Handle;
  Svcs: PSvcA;
  i : integer;
  BytesNeeded,
  SvcCount,
  ResumeHandle: DWord;
begin
  SetLastError(0);
  SCMHdle := OpenSCManager(PChar(MachineName), nil, SC_MANAGER_ENUMERATE_SERVICE);
  if SCMHdle = 0 then
    RaiseLastOSError
  else
  try
    Result := '';
    ResumeHandle := 0;

    New(Svcs);
    try
      if not EnumServicesStatus(SCMHdle, SERVICE_WIN32, SERVICE_STATE_ALL, Svcs[0], SizeOf(Svcs^), BytesNeeded, SvcCount, ResumeHandle) then
        RaiseLastOSError;
      //
      for i := 0 to SvcCount - 1 do
      begin
        if (Pos('INTERBASE', UpperCase(StrPas(Svcs[i].lpDisplayName))) > 0) and
           (Pos('GUARDIAN', UpperCase(StrPas(Svcs[i].lpDisplayName))) = 0) then
        begin
          Result := StrPas(Svcs[i].lpDisplayName);
          Break;
        end;
      end;
    finally
      // Free array of TEnumServiceStatus
      Dispose(Svcs);
    end;
  finally
    // Close service control manager handle
    CloseServiceHandle(SCMHdle);
  end;
end;

function GetInterbaseVersion: string;
var
  ExeFileName: string;
  VInfos: TStringList;
  PId: Cardinal;
  i: Integer;
begin
  ExeFileName := 'ibserver.exe';
  if GetProcessInfo(ExeFileName, PId) then
  begin
    try
      ExeFileName := GetPathFromPID(PId);
    except
      ExeFileName := GetPathFromServiceExecutable('', 'InterBase XE Server gds_db');

      ExeFileName := GetPathFromInterbaseService('');
      ExeFileName := 'C:\Embarcadero\InterBase\bin\ibserver.exe';
    end;
    VInfos := TStringList.Create;
    try
      GetFileInfo(ExeFileName, VInfos);
      for i := 0 to VInfos.Count - 1 do
        if Pos('FileVersion', VInfos[i]) > 0 then
          Exit(StringReplace(VInfos[i], 'FileVersion :', 'Interbase', []));
    finally
      VInfos.Free;
    end;
  end
  else
    Result := 'Interbase ???';
end;
}

end.



