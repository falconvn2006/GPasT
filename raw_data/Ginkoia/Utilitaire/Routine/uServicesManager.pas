unit uServicesManager;

interface

uses
  Windows, SysUtils, Variants, Classes, StdCtrls, Contnrs, IniFiles,
  uServiceControler, TlHelp32, ShellAPI, WinSvc;

type
  TEtat = (teError, teSTOPPED, teSTART_PENDING, teSTOP_PENDING, teRUNNING, teCONTINUE_PENDING, tePAUSE_PENDING, tePAUSED);
  TLogEvent = procedure (Sender: TObject; aMsg: string) of object;
  {*** Return Values: ***}
  {*** -1 = Error opening service ***}
  {*** 1 = SERVICE_STOPPED ***}
  {*** 2 = SERVICE_START_PENDING ***}
  {*** 3 = SERVICE_STOP_PENDING ***}
  {*** 4 = SERVICE_RUNNING ***}
  {*** 5 = SERVICE_CONTINUE_PENDING ***}
  {*** 6 = SERVICE_PAUSE_PENDING ***}
  {*** 7 = SERVICE_PAUSED ***}

  TServiceStartup = (ssAutomatic,
                     ssManual,
                     ssDisabled);

  TServiceItem = class(TObject)
    private
      FNom: string;
      FInstall: boolean;
      FEtat: TEtat;
      FApplications: TStringList;
      FStart: boolean;
      FDescription: string;
      FTimeOut: Integer;
      FPath: string;
      FLog: TLogEvent;
      FNoKill: boolean;
      FError: boolean;

      FLock : SC_LOCK;
      FHandle: SC_HANDLE;
      FManager: SC_HANDLE;
      FStopAutoLaunch: boolean;

      function RefreshState : boolean;
      procedure AddLog(aMsg : string);
      function _Install : boolean;
      function _Uninstall : boolean;
      function _Start : boolean;
      function _Stop : boolean;
      function isEasy : boolean;
      function canKill : boolean;

      procedure Lock;
      procedure Unlock;
      procedure GetHandle(Access: DWORD);
      procedure CleanupHandle;
      procedure SetActive(const Value: Boolean);
    public
      constructor Create(onLog : TLogEvent);
      destructor Destroy;
      function doInstall : boolean;
      function doUninstall : boolean;
      function doStart : boolean;
      function doStop : boolean;
      procedure doRefreshState;
      function doSetStartType(const Value: TServiceStartup) : boolean;
    published
      property Nom : string read FNom write FNom;
      property Path : string read FPath write FPath;
      property Description : string read FDescription write FDescription;
      property Install : boolean read FInstall write FInstall;
      property Start : boolean read FStart write FStart;
      property Etat : TEtat read FEtat write FEtat;
      property TimeOut : Integer read FTimeOut write FTimeOut;
      property Applications : TStringList read FApplications write FApplications;
      property onLog : TLogEvent read FLog write FLog;
      property NoKill : boolean read FNoKill write FNoKill;
      property Error : boolean read FError write FError;
      property StopAutoLaunch : boolean read FStopAutoLaunch write FStopAutoLaunch;
  end;


  TServicesManager = class(TObject)
  private
    FFileName: string;
    FApplication: string;
    FList : TObjectList;
    canWork: boolean;
    FLog: TLogEvent;
    FCanReboot: boolean;
    procedure AddLog(aSrv, aMsg : string);
    procedure loadServices;
  public
    constructor Create(onLog : TLogEvent; aFileName : string; aCanReboot : boolean);
    destructor Destroy;
    function restartServices : boolean;
    function stopServices : boolean;
    function getNbError : integer;
    function getServiceByName(aServiceName : String) : TServiceItem;
  published
    property FileName : string read FFileName write FFileName;
    property Application : string read FApplication write FApplication;
    property List : TObjectList read FList write FList;
    property onLog : TLogEvent read FLog write FLog;
  end;


  function KillTask(ExeFileName: string): Integer;
  function doWithService(aParam : String; aPath : string) : integer;

implementation

{ TServicesManager }

procedure TServicesManager.AddLog(aSrv, aMsg: string);
var
  Msg : String;
begin
  if Assigned(onLog) then
  begin
    Msg := '';

    if aSrv <> '' then
      Msg := aMsg + ' (' + aSrv + ')'
    else
      Msg := aMsg;

    onLog(Self, Msg);
  end;
end;

constructor TServicesManager.Create(onLog : TLogEvent; aFileName: string; aCanReboot : boolean);
begin
  inherited Create;
  FFileName := aFileName;
  canWork := FileExists(FileName);
  FList := nil;
  FLog := nil;
  FCanReboot := aCanReboot;
  if Assigned(onLog) then
    FLog := onLog;

  if canWork then
    loadServices
  else
    AddLog('', 'TServicesManager.Unavailable File : ' + FileName );
end;

destructor TServicesManager.Destroy;
begin
  FList.free;
  inherited Destroy;
end;

function TServicesManager.getNbError: integer;
var
  i : integer;
begin
  result := 0;
  for i := 0 to List.Count -1 do
    if (TServiceItem(List[i]).canKill and TServiceItem(List[i]).Error) then
      inc(result);
end;

function TServicesManager.getServiceByName(aServiceName: String): TServiceItem;
var
  i : integer;
begin
  result := nil;
  for i := 0 to List.Count -1 do
  begin
    if (TServiceItem(List[i]).FNom = aServiceName) then
    begin
      result := TServiceItem(List[i]);
      break;
    end;
  end;
end;

procedure TServicesManager.loadServices;
var
  Ini : TIniFile;
  Section, Key : TStringList;
  KeyVal : string;
  i, y : integer;
  ServiceItem : TServiceItem;
  Etat : DWORD;
begin
  if canWork then
  begin
    FList := TObjectList.create;
    Ini := TIniFile.Create(FFileName);
    try
      Section := TStringList.Create;
      try
        Ini.ReadSections(Section);
        AddLog('', 'Loading Services ...');
        // on parcours les sections/nom du service
        For i := 0 to Section.Count-1 do
        begin
          Key := TStringList.create;
          try
            Ini.ReadSectionValues(Section[i], Key);
            ServiceItem := TServiceItem.create(FLog);
            ServiceItem.FNom := Section[i];
            Etat := ServiceGetStatus('', ServiceItem.Nom);
            ServiceItem.FInstall := (Etat > 0);
            ServiceItem.FStart := (Etat = 4);
            ServiceItem.FStopAutoLaunch := FCanReboot;
            // car ils ont fait -1,1,2,3 et pas 0,1,2,3 ....... dans ServiceControler
            if Etat = -1 then Etat := 0;
            ServiceItem.FEtat := TEtat(Etat);
            for y := 0 to Key.Count - 1 do
            begin
              KeyVal := Copy(Key.strings[y], 0, Pos('=', Key.strings[y]) - 1);
              AddLog('', '          ' + KeyVal + '=' + ini.ReadString(Section[i], KeyVal, ''));
              if LowerCase(KeyVal) = 'description' then
                ServiceItem.FDescription := ini.ReadString(Section[i], KeyVal, '')
              else if LowerCase(KeyVal) = 'timeout' then
                ServiceItem.FTimeOut := ini.ReadInteger(Section[i], KeyVal, 0)
              else if LowerCase(KeyVal) = 'nokill' then
                ServiceItem.FNoKill := (ini.ReadInteger(Section[i], KeyVal, 0) = 1)
              else if LowerCase(KeyVal) = 'executable' then
              begin
                if ini.ReadString(Section[i], KeyVal, '') <> '' then
                  ServiceItem.FPath := ExtractFilePath(FFileName) + ini.ReadString(Section[i], KeyVal, '');
              end
              else if (LowerCase(KeyVal) <> 'GinVer') then // GinVer n'est pas une application
              begin
                if ini.ReadInteger(Section[i], KeyVal, 0) = 1 then
                  ServiceItem.FApplications.Add(KeyVal);
              end;
            end;
          finally
            Key.Free;
          end;
          FList.Add(ServiceItem);
        end;
        AddLog('', 'Services Loaded (' + inttostr(FList.Count) + ')');
      finally
        Section.Free;
      end;
    finally
      Ini.Free;
    end;
  end;
end;

function TServicesManager.restartServices : boolean;
var
  i : Integer;
  sFic : String;
begin
  Result := False;
  sFic := '';
  try
    if canWork then
    begin
      for i := 0 to List.Count -1 do
      begin
        sFic := TServiceItem(List[i]).FNom;
        if TServiceItem(List[i]).FApplications.IndexOf(Application) > -1 then
        begin
          if TServiceItem(List[i]).RefreshState
            then AddLog(sFic, 'Refresh State (1) : Ok')
            else AddLog(sFic, 'Refresh State (1) : Fail');
          if TServiceItem(List[i]).Install then
          begin
            if ((not TServiceItem(List[i]).Start) and (TServiceItem(List[i]).Etat = teSTOPPED)) then
            begin
              AddLog(sFic, 'Try Restart');
              result := TServiceItem(List[i]).doStart;

              if TServiceItem(List[i]).RefreshState
                then AddLog(sFic, 'Refresh State (2) : Ok')
                else AddLog(sFic, 'Refresh State (2) : Fail');
            end
            else
              AddLog(sFic, 'Not Stopped');
          end
          else
            AddLog(sFic, 'Not Installed');
        end
        else
          AddLog(sFic, 'Not Managed');
      end;
    end;
  except
    on e:exception do
    begin
      AddLog(sFic, 'Exception:' + e.message);
      Result := False;
    end;
  end;
end;

function TServicesManager.stopServices : boolean;
var
  i, iErr : Integer;
  sFic : String;
begin
  Result := False;
  iErr := 0;
  sFic := '';
  try
    if canWork then
    begin
      for i := 0 to List.Count -1 do
      begin
        sFic := TServiceItem(List[i]).FNom;
        if TServiceItem(List[i]).FApplications.IndexOf(Application) > -1 then
        begin
          if TServiceItem(List[i]).RefreshState then
            AddLog(sFic, 'Refresh State (1) : Ok')
          else
          begin
            inc(iErr);
            AddLog(sFic, 'Refresh State (1) : Fail');
          end;
          if TServiceItem(List[i]).Install then
          begin
            if ((TServiceItem(List[i]).Start) and (TServiceItem(List[i]).Etat = teRUNNING)) then
            begin
              TServiceItem(List[i]).doStop;
              if TServiceItem(List[i]).RefreshState then
                AddLog(sFic, 'Refresh State (2) : Ok')
              else
              begin
                Inc(iErr);
                AddLog(sFic, 'Refresh State (2) : Fail');
              end;
            end
            else
              AddLog(sFic, 'Not Started');
          end
          else
            AddLog(sFic, 'Not Installed');
        end
        else
          AddLog(sFic, 'Not Managed');
      end;
    end;
    result := (iErr = 0);
  except
    on e:exception do
    begin
      AddLog(sFic, 'Exception:' + e.message);
      Result := False;
    end;
  end;
end;

{ TServiceItem }

procedure TServiceItem.AddLog(aMsg: string);
var
  Msg : String;
begin
  if Assigned(onLog) then
  begin
    Msg := '';

    if Nom <> '' then
      Msg := aMsg + ' (' + Nom + ')'
    else
      Msg := aMsg;

    onLog(Self, Msg);
  end;
end;

function TServiceItem.canKill: boolean;
begin
  result := isEasy or (not FNoKill);
end;

procedure TServiceItem.CleanupHandle;
begin
  if FHandle = 0 then Exit;
  CloseServiceHandle(FHandle);
  FHandle := 0;
end;

constructor TServiceItem.Create(onLog : TLogEvent);
begin
  inherited Create;
  FLog := nil;
  FError := false;
  FPath := '';
  if Assigned(onLog) then
    FLog := onLog;
  FApplications := TStringList.create;
  try
    SetActive(true);
  except
    on e:exception do
      AddLog(e.ClassName + ':' + e.Message);
  end;
end;

destructor TServiceItem.Destroy;
begin
  try
    SetActive(false);
  except
    on e:exception do
      AddLog(e.ClassName + ':' + e.Message);
  end;
  FApplications.free;
  inherited;
end;

procedure TServiceItem.doRefreshState;
var
  lEtat : DWord;
begin
  lEtat := ServiceGetStatus('', Nom);
  FInstall := (lEtat > 0);
  FStart := (lEtat = 4);
  // car ils ont fait -1,1,2,3 et pas 0,1,2,3 ....... dans ServiceControler
  if lEtat = -1 then lEtat := 0;
  FEtat := TEtat(lEtat);
end;

function TServiceItem.RefreshState : boolean;
var
  lEtat : DWORD;
begin
  Result := False;
  try
    lEtat := ServiceGetStatus('', Nom);
    FInstall := (lEtat > 0);
    FStart := (lEtat = 4);
    if lEtat = -1 then lEtat := 0;
    FEtat := TEtat(lEtat);
    Result := True;
  except
    Result := False;
  end;
end;

procedure TServiceItem.SetActive(const Value: Boolean);
var
  VersionInfo: TOSVersionInfo;
  DesiredAccess: DWORD;
begin
  if Value then
  begin
    if FManager <> 0 then Exit;
    // Check that we are NT, 2000, XP or above...
    VersionInfo.dwOSVersionInfoSize := sizeof(VersionInfo);
    if not Windows.GetVersionEx(VersionInfo) then RaiseLastOSError;
    if VersionInfo.dwPlatformId <> VER_PLATFORM_WIN32_NT    then begin
      raise Exception.Create('This program only works on Windows NT, 2000 or XP');
    end;
    // Open service manager
    DesiredAccess := SC_MANAGER_CONNECT or SC_MANAGER_ENUMERATE_SERVICE;
    Inc(DesiredAccess, SC_MANAGER_LOCK);
    FManager := OpenSCManager(PChar(''),nil,DesiredAccess);
    if FManager = 0 then RaiseLastOSError;
  end
  else
  begin
    if FManager = 0 then Exit;
    // Close service manager
    if Assigned(FLock) then Unlock;
    CloseServiceHandle(FManager);
    FManager := 0;
  end;
end;

function TServiceItem.doSetStartType(const Value: TServiceStartup) : boolean;
const
  NewStartTypes: array [TServiceStartup] of DWORD =
    (SERVICE_AUTO_START, SERVICE_DEMAND_START, SERVICE_DISABLED);
begin
  result := true;
  try
    Lock;
    try
      GetHandle(SERVICE_CHANGE_CONFIG);
      try
        if not ChangeServiceConfig(FHandle, SERVICE_NO_CHANGE, NewStartTypes[Value], SERVICE_NO_CHANGE,
                                   nil,nil,nil,nil,nil,nil,nil) then
        begin
          result := false;
          RaiseLastOSError;
        end;
      finally
        CleanupHandle;
      end;
    finally
      Unlock;
    end;
  except
    on e:exception do
      AddLog(e.ClassName + ':' + e.Message);
  end;
end;

procedure TServiceItem.Unlock;
begin
  if FLock = nil then Exit;
  if not UnlockServiceDatabase(FLock) then RaiseLastOSError;
  FLock := nil;
end;

function TServiceItem._Install: boolean;
var
  Count, iError : integer;
begin
  result := false;
  try
    Count := 0;
    if isEasy then
    begin
      iError := doWithService('install', FPath);
      if iError <= 32 then AddLog(SysErrorMessage(iError));
    end
    else InstallService(extractfilepath(FPath), extractfilename(FPath));

    doRefreshState;
    while ((not FInstall) and (Count < FTimeOut)) do
    begin
      doRefreshState;
      Sleep(1000);
      inc(Count);
    end;
    result := Count < FTimeOut;
  except
    result := false;
  end;
end;

function TServiceItem._Start: boolean;
begin
  result := ServiceWaitStart('', FNom, FTimeOut);
end;

function TServiceItem._Stop: boolean;
begin
  result := ServiceWaitStop('', FNom, FTimeOut);
end;

function TServiceItem._Uninstall: boolean;
var
  Count, iError : integer;
begin
  result := false;
  try
    Count := 0;
    if isEasy then
    begin
      iError := doWithService('uninstall', FPath);
      if iError <= 32 then AddLog(SysErrorMessage(iError));
    end
    else UninstallService(extractfilepath(FPath), extractfilename(FPath));

    doRefreshState;
    while ((FInstall) and (Count < FTimeOut)) do
    begin
      doRefreshState;
      Sleep(1000);
      inc(Count);
    end;
    result := Count < FTimeOut;
  except
    result := false;
  end;
end;

function TServiceItem.doInstall : boolean;
begin
  result := true;
  if not Install then
  begin
      if FileExists(FPath) then
      begin
        if _Install then
          AddLog('TServiceItem.doInstall - Install Ok')
        else
        begin
          AddLog('TServiceItem.doInstall - Install Fail');
          result := false;
        end;
      end
      else AddLog('TServiceItem.doInstall - File not exist ('+FPath+')');
  end
  else AddLog('TServiceItem.doInstall - Already Install');
end;

function TServiceItem.doStart : boolean;
begin
  result := true;
  if not Start then
  begin
    if _Start then
    begin
      AddLog('TServiceItem.doStart - Start Ok');
      if FStopAutoLaunch then
      begin
        if doSetStartType(ssAutomatic) then
          AddLog('TServiceItem.doStart - doSetStartType Auto Ok')
        else
          AddLog('TServiceItem.doStart - doSetStartType Auto Fail');
      end;
    end
    else
    begin
      AddLog('TServiceItem.doStart - Start Fail');
      result := false;
    end;
  end
  else AddLog('TServiceItem.doStart - Already Start');
end;

function TServiceItem.doStop : boolean;
begin
  result := true;
  if Start then
  begin
    if _Stop then
    begin
      AddLog('TServiceItem.doStop - Stop Ok');
      if FStopAutoLaunch then
      begin
        if doSetStartType(ssManual) then
          AddLog('TServiceItem.doStart - doSetStartType Manuel Ok')
        else
          AddLog('TServiceItem.doStart - doSetStartType Manuel Fail');
      end;
    end
    else
    begin
      if FPath <> '' then
      begin
        AddLog('TServiceItem.doStop - Stop Fail > Kill : ' + ExtractFileName(FPath));
        try
          if canKill then
          begin
            AddLog('Stop : Kill : Interdit');
            FError := true;
          end
          else
            if KillTask(ExtractFileName(FPath)) <> 0
              then AddLog('Stop : Fail > Kill : Ok')
              else AddLog('Stop : Fail > Kill : Fail')
        except
          AddLog('TServiceItem.doStop - Stop : Fail > Kill : Fail');
        end;
      end
      else AddLog('TServiceItem.doStop - Stop Fail');
      result := false;
    end;
  end
  else AddLog('TServiceItem.doStop - Already Stop');
end;

function TServiceItem.doUninstall : boolean;
begin
  result := true;
  if Install then
  begin
    if FileExists(Path) then
    begin
      if Start then
      begin
        if _Stop
          then AddLog('TServiceItem.doUninstall - Stop Ok')
          else AddLog('TServiceItem.doUninstall - Stop fail');
      end
      else
        AddLog('TServiceItem.doUninstall - Already Stop');
      if _Uninstall
        then AddLog('TServiceItem.doUninstall - Uninstall Ok')
        else
        begin
          AddLog('TServiceItem.doUninstall - Uninstall Fail');
          result := false;
        end;
    end
    else AddLog('TServiceItem.doUninstall - File not exist ('+Path+')');
  end
  else AddLog('TServiceItem.doUninstall - Not Install');
end;

procedure TServiceItem.GetHandle(Access: DWORD);
begin
  if FHandle <> 0 then Exit;
  FHandle := OpenService(FManager, PChar(FNom), Access);
  if FHandle = 0 then RaiseLastOSError;
end;

function TServiceItem.isEasy: boolean;
begin
  result := ((ExtractFileExt(FPath) = '.bat') and (FNom = 'EASY'));
end;

procedure TServiceItem.Lock;
begin
  FLock := LockServiceDatabase(FManager);
  if FLock = nil then RaiseLastOSError;
end;

function KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: Thandle;
  FProcessEntry32: TProcessentry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((Uppercase(ExtractFileName(FProcessEntry32.szExeFile)) = Uppercase(ExeFileName))
        or (Uppercase(FProcessEntry32.szExeFile) = Uppercase(ExeFileName))) then
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0));

    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function doWithService(aParam : String; aPath : string) : integer;
begin
  result := ShellExecute(0, 'open', PChar(IncludeTrailingPathDelimiter(aPath)),
               PChar(aParam), PChar(aPath), SW_HIDE);
end;

end.

