UNIT BackRest_Frm;

INTERFACE

USES
  WinSvc, Controls, StdCtrls, Classes, inifiles, registry, Windows, SysUtils, Forms, Generics.Collections, Generics.Defaults, DateUtils, StrUtils,
  //début uses perso
  ShellAPI,
  Tlhelp32,
  UMapping,
  uTools,
  BackRest_Dm,
  // fin uses persp
  LMDFileCtrl, ScktComp, ExtCtrls, IBServices, uBackup, uKillApp, uZipVersion,
  uServicesManager, uVersion, uServiceControler,  uToolsXE;

type
  TServiceState  = (ssNone, ssError, ssStopped, ssPaused, ssStarted) ;

  TFrm_BackRest = class(TForm)
    Btn_Backup: TButton;
    Timer1: TTimer;
    lab: TLabel;
    Client: TClientSocket;
    lbPhase: TLabel;
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Btn_BackupClick(Sender: TObject);
    PROCEDURE Timer1Timer(Sender: TObject);
    PROCEDURE ClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; VAR ErrorCode: Integer);
    PROCEDURE ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    PROCEDURE ClientRead(Sender: TObject; Socket: TCustomWinSocket);
    PROCEDURE ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
  PRIVATE
    { Déclarations privées }
    ServiceRepl,
    ServiceDist,
    bFirst,
    bCanClose     : Boolean;

    iniTimeout  : Integer;

    myTools : TTools;

    FKeepGBKOnFailure : boolean ;
    SrvManager : TServicesManager;
    procedure StopService;
    procedure StartService;

    procedure DemandeArretService;
    procedure DemandeDemareService;

    procedure StartLauncher(aChemin : String);        //Redémarrer le Launcher si besoin
    procedure StartSyncWeb;         //Redémarrer le SyncWeb si besoin

    procedure StartProcess;         //Démarrer le traitement (param AUTO et RECUP)

    PROCEDURE Attente_IB;

    procedure AddLog(aLigne:string);
    procedure AddLogDBG(aLigne:string);
    function GetValidate(aDataBase: string):Boolean;
    function LanceAppliAttenteFin(aNomFichier:string; aTimeOut:integer):boolean;
    //lab effectue une copie d'un fichier et le vérife
    //Recommence trials fois si la copie n'est pas bonne
    //retourne vrai si la copie est bonne
    FUNCTION copyFichier(strSource, strDestination: STRING; trials: Integer): Boolean;
    function checkService(aServiceName : string) : TServiceState;
    procedure Phase(aMessage: string);
    //procedure analyserBase(aDirData: string);
    //FUNCTION executerProcess(cmdLine: STRING; timeout: integer; exeName: STRING): boolean;
    //FUNCTION GetProcessId(ProgName: STRING): cardinal;
    function StopEasy():boolean;
    procedure StartLauncherEasy();
    procedure onLog(Sender: TObject; aMsg: string);
    function isEasy : boolean;
  PUBLIC
    { Déclarations publiques }
    bValidate,
    FaireGenerateur,
    NewBase,
    Interbase7        : Boolean;

    sPathBase0,
    sPathBorlBin,
    sPathDirData,
    sPathDataBase,
    sPathExe        : string;

    NbBckup,
    TailleBaseMoy,
    TmpsMoy,
    taille,
    EnCours         : Integer;

    TpsDem  : DWord;

    Log : TstringList;
    LogDbg : TStringList;

    function waitForInterbase : boolean ;

    FUNCTION MarqueLesTables(PDataBase: STRING): Boolean;

    procedure StopBase(aDirData, aDataBase: string);
    procedure StartBase(aDirData, aDataBase: string);

    function Rollback(aDirData, aDataBase: string):Boolean;
    function Statistical(aDirData, aDataBase: string):Boolean;
    function Validate(aDirData, aDataBase: string):Boolean;
//    function Backup(aDirData, aDataBase: string): Boolean;
//    function Restore(aDirData, aDataBase: string): Boolean;
    function ReBuildIndex(aDirData, aDataBase: string): Boolean;

    function RenomeBase(aDataBase, aShadow: string ; aRetry : Integer = 5): Boolean;

    function VerifBase(base: string): Boolean;

    procedure ValideNvBck(aDirData, aPathEai, aDataBase, aShadow: String; const iNbRepSave: Integer);
    procedure recupAncBase(Pbase, PDataBase, Shadow: STRING);
    //PROCEDURE OptimiseBase(Pbase, PdataBase: STRING);

    FUNCTION Run: Boolean;
    function NouvelleSauvegarde(const sBase: String; const iNbRepSave: Integer): String;

    // 0 : Pas de problème
    // 1 : Pas de renomme
    // 2 : restore ok mais base mauvaise
    // 3 : Pas de restore
    // 4 : Pas de backup
    // 5 : Pas la place
    procedure marqueBase(OK: Boolean; tipe: Integer; PDataBase: STRING);
    function PrefixDebug : String;
    //Procedure DeleteLogFile(PBase: string; Num: Integer);
  END;

VAR
  Frm_BackRest: TFrm_BackRest;

IMPLEMENTATION

{$R *.DFM}

CONST
  ginkoia     = 'ginkoia.exe';
  Caisse      = 'CaisseGinkoia.exe';
  Script      = 'Script.exe';
  PICCO       = 'Piccolink.exe';
  LauncherV7  = 'LaunchV7.exe';
  SyncWeb     = 'SyncWeb.exe';
  ibGuard     = 'ibguard.exe';
  ibServer    = 'ibserver.exe';
  ibScheduler = 'ibscheduler.exe';
  GinkoiaMobiliteSvr = 'GinkoiaMobiliteSvr' ;
  LauncherEasy = 'LaunchEASY.exe';

VAR
  Lapplication  : STRING;
  ArretLaunch   : Boolean;
  ArretSyncWeb  : Boolean;

procedure TFrm_BackRest.StartLauncherEasy();
begin
  if not(IsProcessInMemory(LauncherEasy)) and FileExists(sPathExe + LauncherEasy) then
  begin
    ShellExecute(0,'Open',PChar(sPathExe+LauncherEasy),nil,nil,SW_SHOWDEFAULT);
  end;
end;

function TFrm_BackRest.LanceAppliAttenteFin(aNomFichier:string; aTimeOut:integer):boolean;
var
  StartInfo           : TStartupInfo;
  ProcessInformation  : TProcessInformation;
  dResu,
  dTpsTimeOut         : DWord;
  bTimeOk             : Boolean;
begin
  ZeroMemory(@StartInfo, SizeOf(TStartupInfo));
  StartInfo.cb          := SizeOf(TStartupInfo);
  StartInfo.dwFlags     := STARTF_USESHOWWINDOW;
  StartInfo.wShowWindow := SW_HIDE;

  aTimeOut := (aTimeOut * 60000);   //TimeOut en minute

  if CreateProcess(nil,PChar(aNomFichier),nil,nil,true,0,nil,nil,StartInfo,ProcessInformation) then
  begin
    dTpsTimeOut := GetTickCount;
    bTimeOk     := true;
    repeat
      application.processmessages;
      sleep(30000);
      GetExitCodeProcess(ProcessInformation.hprocess,dResu);
      if Integer(GetTickCount - dTpsTimeOut) > aTimeOut then
      begin
        bTimeOk := false;
        AddLog(DateTimeToStr(Now) + '  Erreur de TimeOut.');
        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
      end;
    until (dResu<>STILL_ACTIVE) or not(bTimeOk);
    Result:=bTimeOk;
    CloseHandle(ProcessInformation.hThread);
    CloseHandle(ProcessInformation.hProcess);
  end
  else
  begin
    result:=false;
  end;
end;

procedure Pause(aTps : DWORD = 5000);
var
  vStart : DWORD;
begin
    vStart := GetTickCount;

    while GetTickCount-vStart < aTps do
    begin
      sleep(50) ;
      Application.ProcessMessages;
    end;
end;

Function KillProcess(const ProcessName : string) : boolean;
var
  ProcessEntry32  : TProcessEntry32;
  HSnapShot,
  HProcess        : THandle;
begin

  Result := False;

  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then exit;

  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  if Process32First(HSnapShot, ProcessEntry32) then
  repeat
    if CompareText(ProcessEntry32.szExeFile, ProcessName) = 0 then
    begin
      HProcess := OpenProcess(PROCESS_TERMINATE, False, ProcessEntry32.th32ProcessID);
      if HProcess <> 0 then
      begin
        if ProcessName = LauncherV7 THEN
          ArretLaunch := true
        else
          if ProcessName = SyncWeb then
            ArretSyncWeb := true;

        Result := TerminateProcess(HProcess, 0);
        CloseHandle(HProcess);
      end;
      Break;
    end;
  until not Process32Next(HSnapShot, ProcessEntry32);

  CloseHandle(HSnapshot);
end;

procedure TFrm_BackRest.DemandeDemareService;
VAR
  s   : STRING;
  ini : tinifile;
BEGIN
  TRY
    IF NOT Interbase7 THEN EXIT;
    IF NOT ServiceDist THEN EXIT;
    Dm_BackRest.DataBase.Close;
    Dm_BackRest.DataBase.DataBaseName := sPathBase0;
    Dm_BackRest.DataBase.Open;

    ini := tinifile.create(ChangeFileExt(application.exename, '.ini'));
    S := ini.readString('SERVEUR', 'NOM', '');
    IF S <> '' THEN
      Client.Host := S;
    EnCours := 0;
    Client.Open;
    WHILE encours = 0 DO
    BEGIN
      sleep(10);
      application.processmessages;
    END;
    IF encours = 1 THEN
    BEGIN
      Client.Socket.SendText('DEMARRE');
      WHILE encours = 1 DO
      BEGIN
        sleep(10);
        application.processmessages;
      END;
      IF encours = 2 THEN
      BEGIN
      END;
    END;
    Client.close;
  EXCEPT ON E: Exception DO
    BEGIN
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    END;
  END;
END;

procedure TFrm_BackRest.DemandeArretService;
VAR
  s   : STRING;
  ini : tinifile;
BEGIN
  TRY
    IF NOT Interbase7 THEN EXIT;
    ServiceDist := false;
    Dm_BackRest.DataBase.Close;
    Dm_BackRest.DataBase.DataBaseName := sPathDataBase; //sPathBase0;  Correction SR 10/04/2012
    Dm_BackRest.DataBase.Open;
    Dm_BackRest.Qry.Sql.Clear;
    Dm_BackRest.Qry.Sql.Add('Select BAS_ID,BAS_NOM');
    Dm_BackRest.Qry.Sql.Add('  from  genbases Join k on (K_ID=BAS_ID And K_Enabled=1)');
    Dm_BackRest.Qry.Sql.Add('                 Join GenParamBase on (BAS_IDENT = PAR_STRING)');
    Dm_BackRest.Qry.Sql.Add('Where PAR_NOM = ''IDGENERATEUR''');
    Dm_BackRest.Qry.Open;
    S := Dm_BackRest.Qry.FieldByName('BAS_NOM').AsString;

    Dm_BackRest.Qry.Close;
    Dm_BackRest.Qry.Sql.Clear;
    Dm_BackRest.DataBase.Close;
    S := Uppercase(copy(S, Length(S) - 3, 4));
    IF S = '_SEC' THEN
    BEGIN
      ini := tinifile.create(ChangeFileExt(application.exename, '.ini'));
      S := ini.readString('SERVEUR', 'NOM', '');
      IF S <> '' THEN
        Client.Host := S;
      ini.free;
      EnCours := 0;
      // vérification de l'adresse pour éviter les plantage
      Client.ClientType := CtBlocking;
      TRY
        Client.Open;
      EXCEPT ON E: Exception DO
        BEGIN
          AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
          Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
          encours := -99;
        END;
      END;
      IF encours <> -99 THEN
      BEGIN
        Client.close;
        application.processmessages;
        sleep(100);
        application.processmessages;
        encours := 0;
        // on repasse en non bloquand
        Client.ClientType := CtNonBlocking;
        Client.Open;
        WHILE encours = 0 DO
        BEGIN
          sleep(10);
          application.processmessages;
        END;
        IF encours = 1 THEN
        BEGIN
          Client.Socket.SendText('ARRET');
          WHILE encours = 1 DO
          BEGIN
            sleep(10);
            application.processmessages;
          END;
          IF encours = 2 THEN
          BEGIN
            ServiceDist := true;
          END;
        END;
      END;
      Client.close;
    END;
  EXCEPT ON E: Exception DO
    BEGIN
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    END;

  END;
END;

procedure TFrm_BackRest.StartService;
VAR
  hSCManager,
  hService    : SC_HANDLE;
  Statut      : TServiceStatus;
  tempMini,
  CheckPoint  : DWORD;
BEGIN
  TRY
    IF NOT Interbase7 THEN EXIT;
    IF ServiceRepl THEN // ne redemarer le service que si on la arrété
    BEGIN
      hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
      hService := OpenService(hSCManager, 'IBRepl', SERVICE_QUERY_STATUS OR SERVICE_START OR SERVICE_STOP OR SERVICE_PAUSE_CONTINUE);
      IF hService <> 0 THEN
      BEGIN // Service non installé
        QueryServiceStatus(hService, Statut);
        tempMini := Statut.dwWaitHint + 10;
        ControlService(hService, SERVICE_CONTROL_CONTINUE, Statut);
        REPEAT
          CheckPoint := Statut.dwCheckPoint;
          Sleep(tempMini);
          QueryServiceStatus(hService, Statut);
        UNTIL (CheckPoint = Statut.dwCheckPoint) AND
          (statut.dwCurrentState = SERVICE_RUNNING);
        // si CheckPoint = Statut.dwCheckPoint Alors le service est dans les choux
      END;
      CloseServiceHandle(hService);
      CloseServiceHandle(hSCManager);
    END;
  EXCEPT ON E: Exception DO
    BEGIN
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    END;

  END;
END;

procedure TFrm_BackRest.StartSyncWeb;
var
  reg   : TRegistry;
  Sync  : string;
begin
  //On relance le syncweb si besoin
  if ArretSyncWeb then
  begin
    Sync := '';
    try
      reg := TRegistry.Create(KEY_READ);
      try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
        Sync := reg.ReadString('GinkoSyncWeb');
      finally
        reg.free;
      end;
    except on E: Exception do
      begin
        AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
      end;
    end;
    if Sync <> '' then
    begin
      if pos(' AUTO',Sync)<>0 then
      begin
        delete(Sync,pos(' AUTO',Sync),length(' AUTO'));
        ShellExecute(0,'Open',PChar(Sync),'AUTO',nil,SW_SHOWDEFAULT);
      end
      else
      begin
        ShellExecute(0,'Open',PChar(Sync),nil,nil,SW_SHOWDEFAULT);
      end;
    end;
  end;
end;

function TFrm_BackRest.Statistical(aDirData, aDataBase: string): Boolean;
//-------------------------------//
//- Sylvain Rosset - 13/06/2012 -//
//- Fonction pour réaliser une  -//
//- Statistique sur une base.   -//
//-------------------------------//
var
  tslLog        : TStringList;
  ibStatistical : TIBStatisticalService;
begin
  Result := True;

  tslLog := TStringList.Create;
  try
    ibStatistical := TIBStatisticalService.Create(Self);
    try
      if FileExists(aDirData + 'Statistical.log') then
      begin
        if not DeleteFile(aDirData + 'Statistical.log') then
          AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + aDirData + 'Statistical.log]: ' + SysErrorMessage(GetLastError));
      end;

      tslLog.Add('Lancement du Statistical.');
      tslLog.SaveToFile(aDirData + 'Statistical.log');

      ibStatistical.DatabaseName := aDataBase;
      ibStatistical.LoginPrompt := False;
      ibStatistical.Params.Clear;
      ibStatistical.Params.Add('user_name=sysdba');
      ibStatistical.Params.Add('password=masterkey');
      ibStatistical.Active := True;
      try
        ibStatistical.Options := [IndexPages,DataPages,DbLog];
        ibStatistical.ServiceStart;

        while not ibStatistical.Eof do
        begin
          tslLog.Add(ibStatistical.GetNextLine);
          Application.ProcessMessages;
        end;
      finally
        ibStatistical.Active := False;
      end;

      AddLog(DateTimeToStr(Now) + '  Statistical() terminé.');
    finally
      tslLog.SaveToFile(aDirData + 'Statistical.log');
      tslLog.Free;
      Log.SaveToFile(aDirData + 'BackupRestor.Log');
      FreeAndNil(ibStatistical);
    end;
  except on E: Exception do
    begin
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(aDirData + 'BackupRestor.Log');
      Result := false;
    end;
  end;
end;

procedure TFrm_BackRest.StopService;
VAR
  hSCManager,
  hService    : SC_HANDLE;
  Statut      : TServiceStatus;
  tempMini,
  CheckPoint  : DWORD;
BEGIN
  TRY
    IF NOT Interbase7 THEN EXIT;

    AddLog(DateTimeToStr(Now) + '  Arrêt du service IBRepl...');

    hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
    hService := OpenService(hSCManager, 'IBRepl', SERVICE_QUERY_STATUS OR SERVICE_START OR SERVICE_STOP OR SERVICE_PAUSE_CONTINUE);
    IF hService = 0 THEN
    BEGIN // Service non installé
      ServiceRepl := False;
    END
    ELSE
    BEGIN
      QueryServiceStatus(hService, Statut);
      IF statut.dwCurrentState = SERVICE_RUNNING THEN
      BEGIN
        ServiceRepl := true;
        tempMini := Statut.dwWaitHint + 10;
        ControlService(hService, SERVICE_CONTROL_PAUSE, Statut);
        REPEAT
          CheckPoint := Statut.dwCheckPoint;
          Sleep(tempMini);
          QueryServiceStatus(hService, Statut);
        UNTIL (CheckPoint = Statut.dwCheckPoint) AND
          (statut.dwCurrentState = SERVICE_PAUSED);
        // si CheckPoint = Statut.dwCheckPoint Alors le service est dans les choux
      END
      ELSE
      BEGIN
        ServiceRepl := False;
      END;
    END;
    CloseServiceHandle(hService);
    CloseServiceHandle(hSCManager);
    AddLog(DateTimeToStr(Now) + '  Arrêt du service IBRepl terminé.');
  EXCEPT ON E: Exception DO
    BEGIN
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    END;

  END;
END;

procedure TFrm_BackRest.FormActivate(Sender: TObject);
begin
  if bFirst then
  begin
    bFirst := false;
    Application.ProcessMessages;

    if (ParamCount > 0) and ((uppercase(paramstr(1)) = 'AUTO') OR (uppercase(paramstr(1)) = 'RECUP')) then
    begin

      StartProcess;
    end
    else AddLogDBG(DateTimeToStr(Now) + 'Not StartProcess');
  end;
end;

procedure TFrm_BackRest.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LogDbg.savetofile(sPathDirData + 'BackupRestor_DBG.Log');
  FreeAndNil(LogDbg);
  FreeAndNil(myTools);
  FreeAndNil(Log);
end;

procedure TFrm_BackRest.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not bCanClose then
  begin
    CanClose := False;
    Application.Minimize;
  end;
end;

procedure TFrm_BackRest.FormCreate(Sender: TObject);
VAR
  Ini                 : TIniFile;
  reg                 : TRegistry;
  sServerVersion      : string;
  i                   : Integer;
  ibServerProperties  : TIBServerProperties;
BEGIN
  try

    LogDbg := TStringList.Create;

    bCanClose := True;
    bFirst    := True;

    sPathExe  := '';

    myTools := TTools.Create;

    reg := TRegistry.Create(KEY_READ);
    try
      reg.RootKey := HKEY_LOCAL_MACHINE;
      reg.OpenKey('Software\Algol\Ginkoia', False);
      sPathBase0 := reg.ReadString('Base0');
    finally
      reg.free;
    end;


    if sPathBase0 <> '' then
    begin
      sPathExe := ExtractFileDrive(sPathBase0);
      if fileexists(sPathExe + '\Ginkoia\Ginkoia.exe') then
      begin
        sPathExe := sPathExe + '\Ginkoia\';
      end;
    end;

    if sPathExe = '' then
    begin
      if fileexists('C:\Ginkoia\Ginkoia.exe') then
      begin
        sPathExe := 'C:\Ginkoia\';
      end
      else
      begin
        if fileexists('D:\Ginkoia\Ginkoia.exe') then
        begin
          sPathExe := 'D:\Ginkoia\';
        end;
      end;
    end;

    if sPathBase0 <> '' then
    begin
      sPathDataBase := sPathBase0;
      NewBase := True;
    end
    else
    begin
      NewBase := False;
      ini := tinifile.create(sPathExe + 'Ginkoia.Ini');
      try
        sPathDataBase := ini.readString('DATABASE', 'PATH0', '');
        i := 1;
        while (Copy(sPathDataBase, 2, 1) <> ':') and (i < 10) do
        begin
          sPathDataBase := ini.readString('DATABASE', 'PATH'+IntToStr(i), '');
          inc(i);
        end;
            //Correction SR - 15/06/2012
            //      IF Copy(sPathDataBase, 2, 1) <> ':' THEN
            //        sPathDataBase := ini.readString('DATABASE', 'PATH1', '');
            //      IF Copy(sPathDataBase, 2, 1) <> ':' THEN
            //        sPathDataBase := ini.readString('DATABASE', 'PATH2', '');
            //      IF Copy(sPathDataBase, 2, 1) <> ':' THEN
            //        sPathDataBase := ini.readString('DATABASE', 'PATH3', '');
      finally
        ini.free;
      end;
    end;

    sPathDirData := ExtractFilePath(sPathDataBase);

    Dm_BackRest.Database.DatabaseName := sPathDataBase;

    Log := TstringList.Create;
    try
      if fileexists(sPathDirData + 'BackupRestor.Log') then
        Log.LoadFromFile(sPathDirData + 'BackupRestor.Log');
      AddLog('--------------------------------------------------------------');
      {$IFDEF DEBUG}
        AddLog(DateTimeToStr(Now) + ' Démarrage de BackRest v.'+GetNumVersionSoft+' DEBUG');
      {$ELSE}
        AddLog(DateTimeToStr(Now) + ' Démarrage de BackRest v.'+GetNumVersionSoft);
      {$ENDIF}
    except on E: Exception do
      begin
        AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
      end;
    end;

    Ini := TIniFile.Create(changefileext(application.exename, '.ini'));
    try
      NbBckup := ini.readinteger('TPS', 'NB', 0);
      TailleBaseMoy := ini.readinteger('TPS', 'TB', 0);
      TmpsMoy := ini.readinteger('TPS', 'TPS', 0);

      FKeepGBKOnFailure := Ini.ReadBool('Debug', 'KeepGBKOnFailure', false) ;
      Ini.WriteBool('Debug', 'KeepGBKOnFailure', FKeepGBKOnFailure) ;
    finally
      ini.free;
    end;

    Phase('Attente du serveur Interbase ...') ;
    AddLog(DateTimeToStr(Now) + '  Attente du service Interbase ...');
    Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

    if not waitForInterbase then
    begin
      AddLog(DateTimeToStr(Now) + '  Le service Interbase est inaccessible. Abandon.');
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
      bCanClose := true ;
      Exit ;
    end;

    AddLog(DateTimeToStr(Now) + '  le service Interbase est démarré');
    Phase('Le serveur Interbase a répondu') ;
    Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

    if not((ParamCount > 0) and (uppercase(paramstr(1)) = 'RECUP')) then    //En mode RECUP cette partie ne sert pas
    begin
      bValidate := GetValidate(sPathDataBase);

      ibServerProperties := TIBServerProperties.Create(Self);
      try
        ibServerProperties.ServerName := 'localhost';
        ibServerProperties.Options := [Version];
        ibServerProperties.Params.Add('user_name=sysdba');
        ibServerProperties.Params.Add('password=masterkey');
        ibServerProperties.LoginPrompt := False;
        ibServerProperties.Active := True;
        ibServerProperties.FetchVersionInfo;
        ibServerProperties.FetchConfigParams;
        sServerVersion  := ibServerProperties.VersionInfo.ServerVersion;
        sPathBorlBin    := ibServerProperties.ConfigParams.BaseLocation;
        if Copy(sPathBorlBin, Length(sPathBorlBin), 1) = '/' then
        begin
          Delete(sPathBorlBin, Length(sPathBorlBin), 1);
        end;
        sPathBorlBin  := sPathBorlBin + 'bin\';
        Interbase7      := ((Copy(sServerVersion, 1, 5) = 'WI-V7') or (Copy(sServerVersion, 1, 6) = 'WI-V10'));
      finally
        AddLog(DateTimeToStr(Now) + '  Récupération des informations du serveur.');
        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
        ibServerProperties.Free;
      end;
    end;


    SrvManager := TServicesManager.create(onLog, ExtractFilePath(Application.ExeName) + 'Services.ini');
    SrvManager.Application := ChangeFileExt(ExtractFileName(Application.ExeName), '');
    //SrvManager.onLog := onLog;


  except on E: Exception do
    begin
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    end;
  end;
end;

function TFrm_BackRest.MarqueLesTables(PDataBase: string): Boolean;
var
  S   : string;
  li  : Integer;
  vMajorVersion : Word ;
begin
  Result := True;
  try
    Dm_BackRest.DataBase.Close;

    GetDBVersionMajor( PDatabase, vMajorVersion );

    Dm_BackRest.DataBase.DataBaseName := PDataBase;
    Dm_BackRest.DataBase.Open;

    // Récupération du paramétrages des bases
    Dm_BackRest.BAS_ID      := Dm_BackRest.GetBasID;
    Dm_BackRest.BuffersVal  := Dm_BackRest.GetGenParamInt(22,1,Dm_BackRest.BAS_ID);
    Dm_BackRest.PageSizeVal := Dm_BackRest.GetGenParamInt(22,2,Dm_BackRest.BAS_ID);
    Dm_BackRest.SweepVal    := Dm_BackRest.GetGenParamInt(22,3,Dm_BackRest.BAS_ID);
    Dm_BackRest.iNbRepSave := Dm_BackRest.GetGenParamInt(22, 4, Dm_BackRest.BAS_ID);      // Nombre de sauvegardes maximum.
    if Dm_BackRest.iNbRepSave = -1 then
      Dm_BackRest.iNbRepSave := 4;

    Dm_BackRest.Tran.active := True;

    //lab rollback des transactions au cas ou un poste distant accède à TMPBACKUPRESTORE
    Rollback(sPathDirData,sPathDataBase);
    //executerProcess('cmd "' + sPathBorlBin + 'gfix.exe" -rollback all "' + PDataBase + '" -user sysdba -password masterkey ', 10000, 'gfix.exe');


    Dm_BackRest.qry.Close;
    Dm_BackRest.qry.SQL.Clear;
    Dm_BackRest.qry.SQL.Add('select count(1)');
    Dm_BackRest.qry.SQL.Add('from RDB$RELATIONS');
    Dm_BackRest.qry.SQL.Add('where upper(RDB$RELATION_NAME) = ''TMPMAGASIN''');
    try
      Dm_BackRest.qry.Open;
    except
      on E: Exception do
      begin
        AddLog(DateTimeToStr(Now) + '  Échec de la recherche de la table ''TMPMAGASIN'': ' + E.Message);
      end;
    end;
    if Dm_BackRest.qry.Fields[0].AsInteger = 1 then
    begin
      Dm_BackRest.qry.Close;
      Dm_BackRest.qry.SQL.Clear;
      Dm_BackRest.qry.SQL.Add('delete from TMPMAGASIN');
      Dm_BackRest.qry.SQL.Add('where TMP_ID <> 0');
      try
        Dm_BackRest.qry.ExecSQL;
        AddLog(DateTimeToStr(Now) + '  delete from TMPMAGASIN');
      except
        on E: Exception do
        begin
          AddLog(DateTimeToStr(Now) + '  Échec de la suppression du contenu de la table ''TMPMAGASIN'': ' + E.Message);
        end;
      end;
    end;

    Dm_BackRest.qry.Close;
    Dm_BackRest.qry.SQL.Clear;
    Dm_BackRest.qry.SQL.Add('select count(1)');
    Dm_BackRest.qry.SQL.Add('from RDB$RELATIONS');
    Dm_BackRest.qry.SQL.Add('where upper(RDB$RELATION_NAME) = ''TMPTBLBORD''');
    try
      Dm_BackRest.qry.Open;
    except
      on E: Exception do
      begin
        AddLog(DateTimeToStr(Now) + '  Échec de la recherche de la table ''TMPTBLBORD'': ' + E.Message);
      end;
    end;
    if Dm_BackRest.qry.Fields[0].AsInteger = 1 then
    begin
      Dm_BackRest.qry.Close;
      Dm_BackRest.qry.SQL.Clear;
      Dm_BackRest.qry.SQL.Add('delete from TMPTBLBORD');
      Dm_BackRest.qry.SQL.Add('where TMP_ID <> 0');
      try
        Dm_BackRest.qry.ExecSQL;
        AddLog(DateTimeToStr(Now) + '  delete from TMPTBLBORD');
      except
        on E: Exception do
        begin
          AddLog(DateTimeToStr(Now) + '  Échec de la suppression du contenu de la table ''TMPTBLBORD'': ' + E.Message);
        end;
      end;
    end;


    AddLog(DateTimeToStr(Now) + '  DELETE FROM TMPBACKUPRESTORE / TMPSTAT');
    Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    try
      Dm_BackRest.qry.SQL.clear;

      if vMajorVersion > 13 then
        Dm_BackRest.qry.SQL.Add('DELETE FROM TMPBACKUPRESTORE')
      else
        Dm_BackRest.qry.SQL.Add('DELETE FROM TMPSTAT') ;

      Dm_BackRest.qry.ExecSQL;
      Dm_BackRest.qry_tables.Open;
      Dm_BackRest.qry_tables.first;
      li := 0;
      while not Dm_BackRest.qry_tables.eof do
      begin
        Dm_BackRest.qry.SQL.text := 'Select count(*) from ' + Dm_BackRest.qry_tables.Fields[0].AsString;
        Dm_BackRest.Qry.Open;
        S := Dm_BackRest.Qry.Fields[0].AsString;
        Dm_BackRest.Qry.Close;

        if vMajorVersion > 13
          then Dm_BackRest.Qry.SQL.Text := Format( 'Insert into TMPBACKUPRESTORE (TBR_ID, TBR_FIELDSCOUNT) Values ( %d, %s )', [ Li, s ] )
          else Dm_BackRest.Qry.SQL.text := 'Insert into TMPSTAT (TMP_ID, TMP_ARTID, TMP_MAGID) Values (0,' + s + ',' + Inttostr(Li) + ') ' ;

        inc(li);
        Dm_BackRest.Qry.execSql;
        //Log.Add(DateTimeToStr(Now) + '  Marquage de la table ' + qry_tables.Fields[0].AsString + '/ ligne : ' + Inttostr(Li) + ' / Nb record : ' + s);
        //Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
        Dm_BackRest.qry_tables.next;
      end;
      Dm_BackRest.qry_tables.Close;
    except on e: Exception do
      begin
        AddLog(DateTimeToStr(Now) + '  Exception 1:' + e.message);
        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
        Result := False;
      end;
    end;
    try
      AddLog(DateTimeToStr(Now) + '  Déconnection de la base');
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
      Dm_BackRest.qry_tables.Close;
      Dm_BackRest.database.Connected := false;
    except on e: Exception do
      begin
        AddLog(DateTimeToStr(Now) + '  Exception 2:' + e.message);
        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
        Result := False;
      end;
    end;
    if Result then
    begin
      AddLog(DateTimeToStr(Now) + '  Marquage des tables ok');
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    end
    else
    begin
      AddLog(DateTimeToStr(Now) + '  Marquage des tables ko');
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    end;
  except on E: Exception do
    begin
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
      Result := False;
    end;
  end;
end;

function TFrm_BackRest.NouvelleSauvegarde(const sBase: String; const iNbRepSave: Integer): String;
{$REGION 'NouvelleSauvegarde'}
  function GetDateFichierGBK(const szRepertoireSave: String): TDateTime;
  var
    sr: TSearchRec;
  begin
    Result := 0;
    if SysUtils.FindFirst(IncludeTrailingPathDelimiter(szRepertoireSave) + 'sv.gbk', faAnyFile, sr) = 0 then
    begin
      Result := sr.TimeStamp;
      FindClose(sr);
    end;
  end;

  procedure NettoyerZip;
  {$REGION 'NettoyerZip'}
    procedure GestionException(const sFichier: String);
    begin
      AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + sFichier + ']: ' + SysErrorMessage(GetLastError));
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
      Result := '';
    end;
  {$ENDREGION}
  begin
    // Afin de nettoyer l'ancien système.
    if FileExists(IncludeTrailingPathDelimiter(sBase) + 'Sauve1.zip') then
    begin
      if not DeleteFile(IncludeTrailingPathDelimiter(sBase) + 'Sauve1.zip') then
        GestionException(IncludeTrailingPathDelimiter(sBase) + 'Sauve1.zip');
    end;
    if FileExists(IncludeTrailingPathDelimiter(sBase) + 'Sauve2.zip') then
    begin
      if not DeleteFile(IncludeTrailingPathDelimiter(sBase) + 'Sauve2.zip') then
        GestionException(IncludeTrailingPathDelimiter(sBase) + 'Sauve2.zip');
    end;
    if FileExists(IncludeTrailingPathDelimiter(sBase) + 'Sauve3.zip') then
    begin
      if not DeleteFile(IncludeTrailingPathDelimiter(sBase) + 'Sauve3.zip') then
        GestionException(IncludeTrailingPathDelimiter(sBase) + 'Sauve3.zip');
    end;
    if FileExists(IncludeTrailingPathDelimiter(sBase) + 'Sauve4.zip') then
    begin
      if not DeleteFile(IncludeTrailingPathDelimiter(sBase) + 'Sauve4.zip') then
        GestionException(IncludeTrailingPathDelimiter(sBase) + 'Sauve4.zip');
    end;
  end;

  function SupprimerRepertoire(const sRepertoire: String): Boolean;
  var
    SHFileOpStruct: TSHFileOpStruct;
  begin
    Result := False;
    if SysUtils.DirectoryExists(sRepertoire) then
    begin
      ZeroMemory(@SHFileOpStruct, SizeOf(SHFileOpStruct));
      SHFileOpStruct.wFunc := FO_DELETE;
      SHFileOpStruct.fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
      SHFileOpStruct.pFrom := PChar(sRepertoire + #0);
      Result := (0 = ShFileOperation(SHFileOpStruct));
    end;
  end;

  function SetDateModification(const sFichier: String; const DateModifiaction: TDateTime): Boolean;
    function DTtoFT(dt: TDateTime): TFiletime;
    var
      dwft: DWORD;
      ft: TFiletime;
    begin
      dwft := DateTimeToFileDate(dt);
      DosDateTimeToFileTime(LongRec(dwft).Hi, LongRec(dwft).Lo, ft);
      LocalFileTimeToFileTime(ft, Result);
    end;
  var
    nDebut: Cardinal;
    hDir: THandle;
    ftDateModifiaction: TFileTime;
  begin
    Result := False;
    nDebut := GetTickCount;
    repeat
      Pause(2000);
      hDir := CreateFile(PChar(sFichier), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, 0);
    until((hDir <> INVALID_HANDLE_VALUE) or ((GetTickCount - nDebut) > 15000));

    if hDir <> INVALID_HANDLE_VALUE then
    begin
      try
        ftDateModifiaction := DTtoFT(DateModifiaction);
        Result := SetFileTime(hDir, nil, nil, @ftDateModifiaction);
      finally
        CloseHandle(hDir);
      end;
    end;
  end;
{$ENDREGION}
type
  TRepertoire = TPair<String, TDateTime>;
var
  ListeRepertoires: TList<TRepertoire>;
  sr: TSearchRec;
  iNbListe, i: Integer;
begin
  Result := '';
  ListeRepertoires := TList<TRepertoire>.Create(TDelegatedComparer<TRepertoire>.Create(function(const Rep1, Rep2: TRepertoire): Integer
                                                                                       begin
                                                                                          Result := (CompareStr(Rep1.Key, Rep2.Key) * -1);
                                                                                       end));
  try
    try
      // Chargement des répertoires de sauvegarde.
      if SysUtils.FindFirst(IncludeTrailingPathDelimiter(sBase) + '*.*', faAnyFile, sr) = 0 then
      begin
        repeat
          if(sr.Attr and faDirectory) = faDirectory then
          begin
            if(sr.Name <> '.') and (sr.Name <> '..') and (LowerCase(LeftStr(sr.Name, 4)) = 'save') then
              ListeRepertoires.Add(TRepertoire.Create(IncludeTrailingPathDelimiter(sBase) + sr.Name, GetDateFichierGBK(IncludeTrailingPathDelimiter(sBase) + sr.Name)));
          end;
        until FindNext(sr) <> 0;
        FindClose(sr);
      end;

      ListeRepertoires.Sort;
      iNbListe := ListeRepertoires.Count;
      for i:=0 to Pred(ListeRepertoires.Count) do
      begin
        if i <= (iNbListe - iNbRepSave) then
        begin
          // Suppression des répertoires au-delà du nombre maximum de sauvegarde.
          SupprimerRepertoire(ListeRepertoires[i].Key);
          AddLog(DateTimeToStr(Now) + '  Suppression répertoire [' + ListeRepertoires[i].Key + '].');
        end
        else
        begin
          // Décrémente le nom des répertoires de sauvegarde.
          if RenameFile(ListeRepertoires[i].Key, ExtractFilePath(ListeRepertoires[i].Key) + 'Save' + IntToStr(iNbListe - i + 1)) then
            AddLog(DateTimeToStr(Now) + '  Renommage répertoire [' + ListeRepertoires[i].Key + ' >> ' + ExtractFilePath(ListeRepertoires[i].Key) + 'Save' + IntToStr(iNbListe - i + 1) + '].')
          else
            AddLog(DateTimeToStr(Now) + '  # Erreur :  échec du renommage du répertoire [' + ListeRepertoires[i].Key + ' >> ' + ExtractFilePath(ListeRepertoires[i].Key) + 'Save' + IntToStr(iNbListe - i + 1) + ']: ' + SysErrorMessage(GetLastError));

          //.Applique la date du SV.gbk à son répertoire.
          if SetDateModification(ExtractFilePath(ListeRepertoires[i].Key) + 'Save' + IntToStr(iNbListe - i + 1), ListeRepertoires[i].Value) then
            AddLog(DateTimeToStr(Now) + '  Modification date du répertoire [' + ExtractFilePath(ListeRepertoires[i].Key) + 'Save' + IntToStr(iNbListe - i + 1) + ']: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', ListeRepertoires[i].Value))
          else
            AddLog(DateTimeToStr(Now) + '  # Erreur :  échec modification date du répertoire [' + ExtractFilePath(ListeRepertoires[i].Key) + 'Save' + IntToStr(iNbListe - i + 1) + ']: ' + SysErrorMessage(GetLastError));
        end;
      end;
      NettoyerZip;
      Pause;

      // Création du répertoire de sauvegarde courant.
      if CreateDir(IncludeTrailingPathDelimiter(sBase) + 'Save1') then
        AddLog(DateTimeToStr(Now) + '  Création du répertoire [' + IncludeTrailingPathDelimiter(sBase) + 'Save1].')
      else
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la création du répertoire [' + IncludeTrailingPathDelimiter(sBase) + 'Save1]: ' + SysErrorMessage(GetLastError));
      Pause;
      Result := IncludeTrailingPathDelimiter(sBase) + 'Save1\';
    except
      on E: Exception do
      begin
        AddLog(DateTimeToStr(Now) + '  # Exception : ' + E.message);
        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
      end;
    end;
  finally
    ListeRepertoires.Free;
    AddLog(DateTimeToStr(Now) + '  Récupération du chemin de la sauvegarde.');
    Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
  end;
end;

procedure TFrm_BackRest.onLog(Sender: TObject; aMsg: string);
begin
  AddLog('[' +DateTimeToStr(Now) + '] ' + aMsg);
end;

function TFrm_BackRest.ReBuildIndex(aDirData, aDataBase: string): Boolean;
begin
  //select * from RDB$INDICES where RDB$SYSTEM_FLAG is Null
  Result := False;
end;

//Function TFrm_BackRest.Backup(aDirData, aDataBase: string): Boolean;
////-------------------------------//
////- Sylvain Rosset - 13/06/2012 -//
////- Fonction pour réaliser un   -//
////- backup d'une base.          -//
////-------------------------------//
//var
//  tslLog    : TStringList;
//  ibBackup  : TIBBackupService;
//  sLigne    : string;
//begin
//  Result := True;
//
//  tslLog := TStringList.Create;
//  try
//    ibBackup := TIBBackupService.Create(Self);
//    try
//      DeleteFile(aDirData + 'Backup.log');
//
//      tslLog.Add('Lancement du Backup.');
//      tslLog.SaveToFile(aDirData + 'Backup.log');
//
//      ibBackup.ServerName := 'LocalHost';
//      ibBackup.Protocol   := Local;
//      ibBackup.LoginPrompt  := False;
//      ibBackup.Params.Add('user_name=sysdba');
//      ibBackup.Params.Add('password=masterkey');
//      ibBackup.BackupFile.Add(aDirData + 'SV.GBK');
//      ibBackup.DatabaseName := aDataBase;
//      ibBackup.BufferSize := 32000;
//      ibBackup.Verbose    := True;
//
//      ibBackup.Active := True;
//      try
//        ibBackup.ServiceStart;
//
//        while ibBackup.IsServiceRunning do
//        begin
//          sLigne := ibBackup.GetNextLine;
//          if Pos('gbak: ERROR', sLigne)>0 then
//            Result := false;
//          tslLog.Add(sLigne);
//          Application.ProcessMessages;
//        end;
//      finally
//        ibBackup.Active := False;
//      end;
//
//      AddLog(DateTimeToStr(Now) + '  Backup() terminé.');
//    finally
//      tslLog.SaveToFile(aDirData + 'Backup.log');
//      tslLog.Free;
//      Log.SaveToFile(aDirData + 'BackupRestor.Log');
//      FreeAndNil(ibBackup);
//    end;
//  except on e: exception do
//    begin
//      AddLog(DateTimeToStr(Now) + '  exception : ' + e.message);
//      Log.SaveToFile(aDirData + 'BackupRestor.Log');
//      Result := False;
//    end;
//  end;
//end;

//procedure TFrm_Sauve.analyserBase(aDirData : string);
//var
//  //cmdLine,
//  sFileName,
//  sDirName  : string;
//begin
//  //lancer quelques analyses sur la base grace notamment à Gstat
//  //elles seront stockées dans un répertoire StatBase, un fichier par exécution du back up.
//  //Le fichier doit être créé avant l'exécution de Gstat.exe sinon il ne sauve rien
//  sDirName := aDirData + 'StatBase\';//IncludeTrailingBackslash(ExtractFilePath(PDataBase)) + 'StatBase\';
//  ForceDirectories(sDirName);
//  //créer le nom du ficher de destination de la stat
//  sFileName := sDirName + 'STAT_' + FormatDAteTime('MM_DD__HH''H''MM', now) + '.txt';
//  //créer le ficher
//  with TStringList.create do
//  try
//    SaveToFile(sFilename);
//  finally
//    Free;
//  end;
//  //création la ligne de commande
//  //cmdLine := 'cmd /K ""' + IncludeTrailingBackslash(sPathBorlBin) + 'gstat.exe" -u SYSDBA -p masterkey "' + PdataBase + '" >"' + sfilename + '""';
//  //lancer l'execution avec timeout à 60 secondes
//  //executerProcess(cmdLine, iniTimeOut, 'gstat.exe');
//  Statistical(sPathDirData,sPathDataBase);
//end;

procedure TFrm_BackRest.StopBase(aDirData, aDataBase: string);
var
  ibService : TIBConfigService;
begin
  ibService := TIBConfigService.Create(Self);
  try
    try
      ibService.DatabaseName := aDataBase;
      ibService.LoginPrompt := False;
      ibService.Params.Clear;
      ibService.Params.Add('user_name=sysdba');
      ibService.Params.Add('password=masterkey');
      ibService.Active := True;
      ibService.ShutdownDatabase(Forced, 5);
      ibService.Active := False;
      Pause;
      AddLog(DateTimeToStr(Now) + '  ArretBase() terminé.');
    finally
      ibService.Active := False;
      FreeAndNil(ibService);
      Log.SaveToFile(aDirData + 'BackupRestor.Log');
    end;
  except on E: Exception do
    begin
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(aDirData + 'BackupRestor.Log');
    end;
  end;
end;

function TFrm_BackRest.RenomeBase(aDataBase, aShadow: string ; aRetry : Integer = 5): Boolean;
var
  vTry : integer ;
  vOk  : boolean ;
begin
  Result := False;

  try
    if FileExists(aDataBase) then
    begin
      if FileExists(ChangeFileExt(aDataBase, '.toto')) then
      begin
        if not DeleteFile(ChangeFileExt(aDataBase, '.toto')) then
          AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + ChangeFileExt(aDataBase, '.toto') + ']: ' + SysErrorMessage(GetLastError));
      end;

      vTry := 0 ;
      repeat
        vOk := RenameFile(aDataBase, ChangeFileExt(aDataBase, '.toto'));
        if not vOk then
        begin
          Inc(vTry) ;
          AddLog(DateTimeToStr(Now) + ' # Impossible de renommer la base actuelle :  ' + SysErrorMessage(GetLastError) + ' (' + IntToStr(vTry) + '/'+IntToStr(aRetry) + ')');
          Pause(30000) ;
        end;
      until ((vOk = true) or (vTry >= aRetry)) ;

      if vOk and (aShadow <> '') then
      begin
        if FileExists(aShadow) then
        begin
          if FileExists(ChangeFileExt(aShadow, '.toto')) then
          begin
            if not DeleteFile(ChangeFileExt(aShadow, '.toto')) then
              AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + ChangeFileExt(aShadow, '.toto') + ']: ' + SysErrorMessage(GetLastError));
          end;

          vTry := 0 ;
          repeat
            vOk := RenameFile(aShadow, ChangeFileExt(aShadow, '.toto'));
            if not vOk then
            begin
              Inc(vTry) ;
              AddLog(DateTimeToStr(Now) + ' # Impossible de renommer la base shadow :  ' + SysErrorMessage(GetLastError) + ' (' + IntToStr(vTry) + '/' + IntToStr(aRetry) + ')');
              Pause(30000) ;
            end;
          until ((vOk = true) or (vTry >= aRetry)) ;
        end
      end;

      Result := vOk ;
    end;
  except on E: Exception do
    begin
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    end;
  end;
end;

//Function TFrm_BackRest.Restore(aDirData, aDataBase: string): Boolean;
////-------------------------------//
////- Sylvain Rosset - 13/06/2012 -//
////- Fonction pour réaliser un   -//
////- restore d'une base.         -//
////-------------------------------//
//var
//  tslLog    : TStringList;
//  //sLigne    : string;
//  //ibRestore : TIBRestoreService;
//begin
//  Result := True;
//  tslLog := tstringList.create;
//  try
//    try
//      DeleteFile(aDirData + 'GO.BAT');
//      DeleteFile(aDirData + 'Restore.log');
//      DeleteFile(aDirData + 'tmp.log');
//
//      tslLog.Add('"' + sPathBorlBin + '\gbak.exe " "' + aDirData + 'SV.GBK" "' + aDataBase +
//        '" -user sysdba -password masterkey -C -BU 4096 -P 4096 -V -Y "' + aDirData + 'Restore.log' + '"');
//      tslLog.Add('Copy "' + aDirData + 'Restore.log' + '" "' + aDirData + 'tmp.log"');
//      tslLog.Add('exit');
//      tslLog.savetofile(aDirData + 'GO.BAT');
//
//      if not LanceAppliAttenteFin(aDirData + 'GO.BAT',300) then
//      begin
//        Result := False;
//        AddLog(DateTimeToStr(Now) + '  Sortie LanceAppliAttenteFin Erreur.');
//      end
//      else begin
//        AddLog(DateTimeToStr(Now) + '  Sortie LanceAppliAttenteFin Ok.');
//        tslLog.loadfromfile(aDirData + 'tmp.log');
//        while tslLog.count > 0 do
//        begin
//          if Pos('GBAK: ERROR', tslLog[0])>0 then
//          begin
//            Result := False;
//            AddLog(DateTimeToStr(Now) + '  GBAK ERROR.');
//            BREAK;                                  //Ici je sors en cas d'erreur
//          end
//          else
//          begin
//            tslLog.delete(0);
//          end;
//        end;
//
////  tslLog := TStringList.Create;
////  try
////    ibRestore := TIBRestoreService.Create(self);
////    try
////      DeleteFile(aDirData + 'Restore.log');
////
////      tslLog.Add('Lancement du Restore.');
////      tslLog.SaveToFile(aDirData + 'Restore.log');
////
////      ibRestore.ServerName  := 'LocalHost';
////      ibRestore.Protocol    := Local;
////      ibRestore.LoginPrompt := False;
////      ibRestore.Params.Add('user_name=sysdba');
////      ibRestore.Params.Add('password=masterkey');
////      ibRestore.BackupFile.Clear;
////      ibRestore.DatabaseName.Clear;
////      ibRestore.Active  := True;
////      try
////        ibRestore.Verbose     := True;
////        ibRestore.Options := [CreateNewDB];
////        ibRestore.PageBuffers := 4096; //SR - 15/06/2012
////        ibRestore.PageSize    := 4096;
////        ibRestore.DatabaseName.Add(aDataBase);
////        ibRestore.BackupFile.Add(aDirData + 'SV.GBK');
////
////        ibRestore.ServiceStart;
////
////        while not ibRestore.Eof do
////        begin
////          sLigne := ibRestore.GetNextLine;
////          if Pos('GBAK: ERROR', sLigne)>0 then
////            Result := false;
////          tslLog.Add(sLigne);
////          Application.ProcessMessages;
////        end;
////      finally
////        ibRestore.Active := False;
////      end;
//
//        if Result then
//        begin
//          AddLog(DateTimeToStr(Now) + '  Restore() terminé.');
//        end
//        else
//        begin
//          AddLog(DateTimeToStr(Now) + '  Fin Restore() Erreur.');
//        end;
//      end;
//    finally
//      //tslLog.SaveToFile(aDirData + 'Restore.log');
//      tslLog.Free;
//      DeleteFile(aDirData + 'tmp.log');
//      Log.SaveToFile(aDirData + 'BackupRestor.Log');
//      //FreeAndNil(ibRestore);
//    end;
//  except on e: exception do
//    begin
//      AddLog(DateTimeToStr(Now) + '  exception : ' + e.message);
//      Log.SaveToFile(aDirData + 'BackupRestor.Log');
//      Result := False;
//    end;
//  end;
//end;

function TFrm_BackRest.Rollback(aDirData, aDataBase: string): Boolean;
//-------------------------------//
//- Sylvain Rosset - 13/06/2012 -//
//- Fonction pour réaliser un   -//
//- rollbackall sur base.       -//
//-------------------------------//
var
  i             : Integer;
  tslLog        : TStringList;
  ibValidation  : TIBValidationService;
begin
  Result := True;

  tslLog := TStringList.Create;
  try
    ibValidation := TIBValidationService.Create(Self);
    try
      if FileExists(aDirData + 'Rollback.log') then
      begin
        if not DeleteFile(aDirData + 'Rollback.log') then
          AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + aDirData + 'Rollback.log]: ' + SysErrorMessage(GetLastError));
      end;

      tslLog.Add('Lancement du Rollback.');
      tslLog.SaveToFile(aDirData + 'Rollback.log');

      ibValidation.ServerName   := 'LocalHost';
      ibValidation.Protocol     := Local;
      ibValidation.DatabaseName := aDataBase;
      ibValidation.LoginPrompt := False;
      ibValidation.Params.Clear;
      ibValidation.Params.Add('user_name=sysdba');
      ibValidation.Params.Add('password=masterkey');
      ibValidation.Options := [LimboTransactions];
      ibValidation.GlobalAction := RollbackGlobal;
      ibValidation.Active := True;
      try
        ibValidation.ServiceStart;
        ibValidation.FetchLimboTransactionInfo;
        while not ibValidation.Eof do
        begin
          tslLog.Add(ibValidation.GetNextLine);
        end;

        for i := 0 to ibValidation.LimboTransactionInfoCount - 1 do
        begin
          with ibValidation.LimboTransactionInfo[i] do
          begin
            tslLog.Add('Transaction ID: ' + IntToStr(ID));
            tslLog.Add('Host Site: ' + HostSite);
            tslLog.Add('Remote Site: ' + RemoteSite);
            tslLog.Add('Remote Database Path: ' + RemoteDatabasePath);
            tslLog.Add('-----------------------------------');
          end;
        end;
        Application.ProcessMessages;
      finally
        ibValidation.Active := False;
      end;

      AddLog(DateTimeToStr(Now) + '  Rollback() terminé.');
    finally
      tslLog.SaveToFile(aDirData + 'Rollback.log');
      tslLog.Free;
      Log.SaveToFile(aDirData + 'BackupRestor.Log');
      FreeAndNil(ibValidation);
    end;
  except on E: Exception do
    begin
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(aDirData + 'BackupRestor.Log');
      Result := false;
    end;
  end;
end;

procedure TFrm_BackRest.StartBase(aDirData, aDataBase: string);
var
  reg       : TRegistry;
  hToken,
  hProcess  : THandle;
  tp,
  prev_tp   : TTokenPrivileges;
  Len       : DWORD;
  ibService : TIBConfigService;
begin
  ibService := TIBConfigService.Create(Self);
  try
    try
      ibService.DatabaseName := aDataBase;
      ibService.LoginPrompt := False;
      ibService.Params.Clear;
      ibService.Params.Add('user_name=sysdba');
      ibService.Params.Add('password=masterkey');
      ibService.Active := True;
      Pause;
      ibService.BringDatabaseOnline;
      Pause;
      AddLog(DateTimeToStr(Now) + '  DemareBase() terminé.');
    finally
      ibService.Active := False;
      FreeAndNil(ibService);
      Log.SaveToFile(aDirData + 'BackupRestor.Log');
    end;
  except on E: Exception do
    begin
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(aDirData + 'BackupRestor.Log');
      if (paramCount > 0) and (paramstr(1) = 'RECUP') then
      begin
        Application.messagebox('Probleme important sur votre base, appeler la sociétée GINKOIA', ' Probleme', MB_OK);
        Halt;
      end
      else
      begin
        AddLog(DateTimeToStr(Now) + '  Obligation de rebooter le serveur ');
        Log.SaveToFile(aDirData + 'BackupRestor.Log');
        reg := TRegistry.Create(KEY_ALL_ACCESS);
        try
          reg.RootKey := HKEY_LOCAL_MACHINE;
          reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce', true);
          reg.WriteString('BACKUP', Application.exename + ' RECUP');
        finally
          reg.free;
        end;

        hProcess := OpenProcess(PROCESS_ALL_ACCESS, True, GetCurrentProcessID);
        if OpenProcessToken(hProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
        begin
          CloseHandle(hProcess);
          if LookupPrivilegeValue('', 'SeShutdownPrivilege', tp.Privileges[0].Luid) then
          begin
            tp.PrivilegeCount := 1;
            tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
            if AdjustTokenPrivileges(hToken, False, tp, SizeOf(prev_tp), prev_tp, Len) then
            begin
              CloseHandle(hToken);

              ExitWindowsEx(EWX_FORCE or EWX_REBOOT, 0);
              Application.MessageBox('Redémarrage du serveur en cours...', 'Attention', Mb_Ok);
              HALT;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TFrm_BackRest.StartLauncher(aChemin : String);
var
  reg     : TRegistry;
  Launch  : string;
  iError : Integer;
begin
  // on relance le launcher si besoin
  AddLogDBG(DateTimeToStr(Now) + 'Try StartLauncher');
  try
    if ArretLaunch then
    begin
      AddLogDBG(DateTimeToStr(Now) + 'Do StartLauncher');

      Launch := aChemin;
      if Launch='' then
      begin
        try
          reg := TRegistry.Create(KEY_READ);
          try
            reg.RootKey := HKEY_LOCAL_MACHINE;
            reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
            Launch := reg.ReadString('Launch_Replication');
          finally
            reg.free;
          end;
        except on E: Exception do
          begin
            AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
            Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
          end;
        end;
      end;
      AddLogDBG(DateTimeToStr(Now) + 'Exec StartLauncher:"'+Launch+'"');
      if Launch <> '' then
      begin
        iError := ShellExecute(0,'Open',PChar(Launch),nil,nil,SW_SHOWDEFAULT);
        case iError of
          2:AddLogDBG(DateTimeToStr(Now) + 'file not found');
          3:AddLogDBG(DateTimeToStr(Now) + 'path not found');
          5:AddLogDBG(DateTimeToStr(Now) + 'access denied');
          8:AddLogDBG(DateTimeToStr(Now) + 'not enough memory');
          32:AddLogDBG(DateTimeToStr(Now) + 'dynamic-link library not found');
          26:AddLogDBG(DateTimeToStr(Now) + 'sharing violation');
          27:AddLogDBG(DateTimeToStr(Now) + 'filename association incomplete or invalid');
          28:AddLogDBG(DateTimeToStr(Now) + 'DDE request timed out');
          29:AddLogDBG(DateTimeToStr(Now) + 'DDE transaction failed');
          30:AddLogDBG(DateTimeToStr(Now) + 'DDE busy');
          31:AddLogDBG(DateTimeToStr(Now) + 'no application associated with the given filename extension');
        else AddLogDBG(DateTimeToStr(Now) + 'OK :' + inttostr(iError));
        end;
      end
      else
      begin
        Launch := ExtractFilePath(Application.ExeName) + LauncherV7;
        AddLogDBG(DateTimeToStr(Now) + 'on détermine le chemin plutôt que de chercher dans le registre:"' + Launch + '", Force Start');
        StartLauncher(Launch);
      end;
    end
    else
    begin
      AddLogDBG(DateTimeToStr(Now) + 'Pas Stop donc pas ReStart !');
      ArretLaunch := true;
      AddLogDBG(DateTimeToStr(Now) + 'Force Start');
      StartLauncher('');
    end;
  finally
    Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
  end;
end;

procedure TFrm_BackRest.StartProcess;
var
  i : Integer;
begin
  AddLogDBG(DateTimeToStr(Now) + 'Try StartProcess');
  try
    if (uppercase(paramstr(1)) = 'AUTO') then      //En cas de lancement automatique
    begin
      if FileExists(ChangeFileExt(sPathDataBase, '.Old')) then
      begin
        Application.MessageBox(Pchar('Impossible de backuper si le fichier ' + ChangeFileExt(sPathDataBase, '.Old') + ' existe !'), 'Attention', Mb_Ok);
        EXIT;
      end;

//      if (Time > EncodeTime(6,0,0,0)) and (Time < EncodeTime(19,0,0,0)) then
//      begin
//        AddLog('Opération impossible en AUTO dans les horaires 6h - 19h');
//        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
//        Exit ;
//      end;

      if fileExists(sPathDataBase) then   //Lance de la procédure de Backup
      begin
        Run;
      end;
    end
    else
    begin
      if (uppercase(paramstr(1)) = 'RECUP') then   //En cas de lancement après un plantage.
      begin
        // Clôture du launcher
        AddLogDBG(DateTimeToStr(Now) + 'StartProcess Try KillProcess:'+LauncherV7);
        try
          if KillProcess(LauncherV7)
            then AddLogDBG(DateTimeToStr(Now) + 'StartProcess Ok KillProcess:' + LauncherV7)
            else AddLogDBG(DateTimeToStr(Now) + 'StartProcess Nok KillProcess:' + LauncherV7)
        except
          on e:exception do
            AddLogDBG(DateTimeToStr(Now) + 'StartProcess Error KillProcess:'+e.Message);
        end;

        AddLog(DateTimeToStr(Now) + '  Arrêt du Launcher.');

        // Clôture du SyncWeb
        KillProcess(SyncWeb);
        AddLog(DateTimeToStr(Now) + '  Arrêt du SyncWeb.');

        {$REGION 'Arret des applications externe via le fichier KLaunch.app'}
        KillApp.Load;
        for i := 0 to KillApp.Count - 1 do
          KillProcess(KillApp.List[i]);
        {$ENDREGION}

        Attente_IB;
        StartBase(sPathDirData, sPathDataBase);
      end
    end;

  finally
    StartSyncWeb;
    if isEasy
      then StartLauncherEasy
      else StartLauncher('');
    close;
  end;
end;

//Procedure TFrm_Sauve.OptimiseBase(Pbase, PdataBase: string);
//var
//  tsl   : TStringList;
//  i     : Integer;
//  debut : TDateTime;
//begin
//  try
//    tsl := TStringList.Create;
//    try
//      DeleteLogFile(Pbase, 2);
//      DeleteLogFile(Pbase, 1);
//
//      tsl.add('"' + sPathBorlBin + 'gfix.exe" -Buffers 4096 -user sysdba -password masterkey "' + PDataBase + '" ');
//      tsl.add('Dir c:\*.* > "' + sUn + '"');
//      tsl.add('exit ');
//      tsl.savetofile(PBase + 'GO.BAT');
//
//      if not LanceAppliAttenteFin(PBase + 'GO.BAT', iTimeOutOptiBase) then
//      begin
//        Log.Add(DateTimeToStr(Now) + '  Problème lors de OptimiseBase().');
//        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
//        Exit;
//      end;
//      Log.Add(DateTimeToStr(Now) + '  OptimiseBase() terminé.');
//    finally
//      tsl.Free;
//      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
//    end;
//  except on e: exception do
//    begin
//      Log.Add(DateTimeToStr(Now) + '  exception : ' + e.message);
//      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
//    end;
//  end;
//end;

function TFrm_BackRest.VerifBase(Base: string): Boolean;
var
  li, lli: Integer;
  vMajorVersion : Word ;
begin
  result := true;
  try
    Dm_BackRest.database.Close;

    GetDBVersionMajor( Base , vMajorVersion );

    Dm_BackRest.database.DatabaseName := Base;
    Dm_BackRest.qry_tables.open;
    Dm_BackRest.qry_tables.first;
    li := 0;
    while not Dm_BackRest.qry_tables.eof do
    begin
      Dm_BackRest.Qry.sql.text := 'Select count(*) from ' + Dm_BackRest.qry_tables.Fields[0].AsString;
      Dm_BackRest.Qry.Open;
      lli := Dm_BackRest.Qry.Fields[0].AsInteger;
      Dm_BackRest.Qry.Close;

      if vMajorVersion > 13
        then Dm_BackRest.Qry.sql.Text := Format( 'Select TBR_FIELDSCOUNT from TMPBACKUPRESTORE where TBR_ID = %d', [ li ] )
        else Dm_BackRest.Qry.sql.text := 'Select TMP_ARTID from TMPSTAT WHERE TMP_ID=0 and TMP_MAGID=' + Inttostr(li);

      Dm_BackRest.Qry.Open;
      if lli <> Dm_BackRest.Qry.fields[0].AsInteger then
      begin
        AddLog(DateTimeToStr(Now) + '  Table ' + Dm_BackRest.qry_tables.Fields[0].AsString + ' Diff ');
        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
        Dm_BackRest.database.Connected := false;
        result := false;
        Break;
      end;
      Dm_BackRest.Qry.Close;
      inc(li);
      Dm_BackRest.qry_tables.next;
    end;
  except on E: Exception do
    begin
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
      result := false;
    end;
  end;
  try
    Dm_BackRest.database.Close;
  except on E: Exception do
    begin
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    end;
  end;
end;

function TFrm_BackRest.waitForInterbase : boolean ;
var
  timeStart : Cardinal ;
  vState    : TServiceState ;
  ia        : integer ;
begin
  timeStart := GetTickCount ;

  while getTickCount - timeStart < (5 * 60 * 1000) do
  begin
    vState := ssNone ;
    vState := checkService('IBS_gds_db') ;
    if vState = ssNone then
    begin
      // On ne trouve pas le service a tester. On considere que Interbase est démarré par compatibilité ascendante.

      Result := true ;
      Exit ;
    end;

    if vState = ssStarted then
    begin
      Result := true ;
      Exit ;
    end;


    for ia:= 1 to 1000 do
    begin
        Application.ProcessMessages ;
        sleep(10) ;
    end;
  end;
end;

function TFrm_BackRest.checkService(aServiceName : string) : TServiceState ;
var
  hSCManager,
  hService    : SC_HANDLE;
  Statut      : TServiceStatus;
begin
  try
    hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
    hService := OpenService(hSCManager, PChar(aServiceName), SERVICE_QUERY_STATUS);
    try
      if hService = 0 THEN
      begin
        Result := ssNone ;
        Exit ;
      end;

      QueryServiceStatus(hService, Statut);
      IF statut.dwCurrentState = SERVICE_RUNNING
        then Result := ssStarted ;

      IF statut.dwCurrentState = SERVICE_PAUSED
        then Result := ssPaused ;

      IF statut.dwCurrentState = SERVICE_STOPPED
        then Result := ssStopped ;

    finally
      CloseServiceHandle(hService);
      CloseServiceHandle(hSCManager);
    end ;
  except
    on e : Exception do
    begin
      Result := ssError ;
    end;
  end;
end;

PROCEDURE TFrm_BackRest.recupAncBase(Pbase, PDataBase, Shadow: STRING);
BEGIN
  TRY
    IF FileExists(ChangeFileExt(PDataBase, '.Old')) THEN
    BEGIN
      if FileExists(PBase + 'SV.GBK') then
      begin
        if not DeleteFile(PBase + 'SV.GBK') then
          AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + PBase + 'SV.GBK]: ' + SysErrorMessage(GetLastError));
      end;
      if FileExists(PDataBase) then
      begin
        if not DeleteFile(PDataBase) then
          AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + PDataBase + ']: ' + SysErrorMessage(GetLastError));
      end;
      if not RenameFile(ChangeFileExt(PDataBase, '.Old'), PDataBase) then
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec du renommage [' + ChangeFileExt(PDataBase, '.Old') + ' >> ' + PDataBase + ']: ' + SysErrorMessage(GetLastError));

      IF shadow <> '' THEN
      BEGIN
        if FileExists(shadow) then
        begin
          if not DeleteFile(shadow) then
            AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + shadow + ']: ' + SysErrorMessage(GetLastError));
        end;
        if not RenameFile(ChangeFileExt(Shadow, '.Old'), Shadow) then
          AddLog(DateTimeToStr(Now) + '  # Erreur :  échec du renommage [' + ChangeFileExt(Shadow, '.Old') + ' >> ' + Shadow + ']: ' + SysErrorMessage(GetLastError));
      END;
    END
  EXCEPT ON E: Exception DO
    BEGIN
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    END;
  END;
END;

function TFrm_BackRest.Validate(aDirData, aDataBase: string): Boolean;
//-------------------------------//
//- Sylvain Rosset - 13/06/2012 -//
//- Fonction pour réaliser un   -//
//- validate sur une base.      -//
//-------------------------------//
var
  tslLog        : TStringList;
  ibValidation  : TIBValidationService;
begin
  Result := True;
  if bValidate then
  begin
    tslLog := TStringList.Create;
    try
      ibValidation := TIBValidationService.Create(Self);
      try
        if FileExists(aDirData + 'Validate.log') then
        begin
          if not DeleteFile(aDirData + 'Validate.log') then
            AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + aDirData + 'Validate.log]: ' + SysErrorMessage(GetLastError));
        end;

        tslLog.Add('Lancement du Validate.');
        tslLog.SaveToFile(aDirData + 'Validate.log');

        ibValidation.DatabaseName := aDataBase;
        ibValidation.LoginPrompt := False;
        ibValidation.Params.Clear;
        ibValidation.Params.Add('user_name=sysdba');
        ibValidation.Params.Add('password=masterkey');
        ibValidation.Active := True;
        try
          ibValidation.Options := [SweepDB];
          ibValidation.ServiceStart;
          tslLog.Add('Lancement du SweepDB.');
          while not ibValidation.Eof do
          begin
            tslLog.Add(ibValidation.GetNextLine);
            Application.ProcessMessages;
          end;

          ibValidation.Options := [ValidateFull];
          ibValidation.ServiceStart;
          tslLog.Add('Lancement du ValidateFull.');
          while not ibValidation.Eof do
          begin
            tslLog.Add(ibValidation.GetNextLine);
            Application.ProcessMessages;
          end;
        finally
          ibValidation.Active := False;
        end;

        AddLog(DateTimeToStr(Now) + '  Validate() terminé.');
      finally
        tslLog.SaveToFile(aDirData + 'Validate.log');
        tslLog.Free;
        Log.SaveToFile(aDirData + 'BackupRestor.Log');
        FreeAndNil(ibValidation);
      end;
    except on E: Exception do
      begin
        AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
        Log.SaveToFile(aDirData + 'BackupRestor.Log');
        Result := false;
      end;
    end;
  end
  else
  begin
    AddLog(DateTimeToStr(Now) + '  Validate() désactivé.');
    Log.SaveToFile(aDirData + 'BackupRestor.Log');
  end;
end;

procedure TFrm_BackRest.ValideNvBck(aDirData, aPathEai, aDataBase, aShadow: String; const iNbRepSave: Integer);
var
  S,
  sSavePath : string;
begin
  try
    //créer le répertoire 'backup' s'il n'existe pas
    ForceDirectories(aDirData + 'backup\');

    AddLog(DateTimeToStr(Now) + ' Purge des anciennes sauvegardes...');
    Log.SaveToFile(aDirData + 'BackupRestor.Log');

    // Gestion des répertoires 'save'.
    sSavePath := NouvelleSauvegarde(aDirData + 'backup\', iNbRepSave);

    AddLog(DateTimeToStr(Now) + ' Sauvegarde de la base...');
    Log.SaveToFile(aDirData + 'BackupRestor.Log');

    // Copie des fichiers.
    if FileExists(aDirData + 'SV.GBK') then
    begin
      if CopyFile(PChar(aDirData + 'SV.GBK'), PChar(sSavePath + 'SV.GBK'), False) then
        AddLog(DateTimeToStr(Now) + '  Copie du fichier [' + aDirData + 'SV.GBK >> ' + sSavePath + 'SV.GBK]')
      else
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la copie du fichier [' + aDirData + 'SV.GBK >> ' + sSavePath + 'SV.GBK]: ' + SysErrorMessage(GetLastError));
    end;
    if FileExists(aDirData + 'GO.BAT') then
    begin
      if CopyFile(PChar(aDirData + 'GO.BAT'), PChar(sSavePath + 'GO.BAT'), False) then
        AddLog(DateTimeToStr(Now) + '  Copie du fichier [' + aDirData + 'GO.BAT >> ' + sSavePath + 'GO.BAT]')
      else
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la copie du fichier [' + aDirData + 'GO.BAT >> ' + sSavePath + 'GO.BAT]: ' + SysErrorMessage(GetLastError));
    end;
    if FileExists(aDirData + 'Rollback.log') then
    begin
      if CopyFile(PChar(aDirData + 'Rollback.log'), PChar(sSavePath + 'Rollback.log'), False) then
        AddLog(DateTimeToStr(Now) + '  Copie du fichier [' + aDirData + 'Rollback.log >> ' + sSavePath + 'Rollback.log]')
      else
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la copie du fichier [' + aDirData + 'Rollback.log >> ' + sSavePath + 'Rollback.log]: ' + SysErrorMessage(GetLastError));
    end;
    if FileExists(aDirData + 'Statistical.log') then
    begin
      if CopyFile(PChar(aDirData + 'Statistical.log'), PChar(sSavePath + 'Statistical.log'), False) then
        AddLog(DateTimeToStr(Now) + '  Copie du fichier [' + aDirData + 'Statistical.log >> ' + sSavePath + 'Statistical.log]')
      else
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la copie du fichier [' + aDirData + 'Statistical.log >> ' + sSavePath + 'Statistical.log]: ' + SysErrorMessage(GetLastError));
    end;
    if FileExists(aDirData + 'Validate.log') then
    begin
      if CopyFile(PChar(aDirData + 'Validate.log'), PChar(sSavePath + 'Validate.log'), False) then
        AddLog(DateTimeToStr(Now) + '  Copie du fichier [' + aDirData + 'Validate.log >> ' + sSavePath + 'Validate.log]')
      else
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la copie du fichier [' + aDirData + 'Validate.log >> ' + sSavePath + 'Validate.log]: ' + SysErrorMessage(GetLastError));
    end;
    if FileExists(aDirData + 'Backup.log') then
    begin
      if CopyFile(PChar(aDirData + 'Backup.log'), PChar(sSavePath + 'Backup.log'), False) then
        AddLog(DateTimeToStr(Now) + '  Copie du fichier [' + aDirData + 'Backup.log >> ' + sSavePath + 'Backup.log]')
      else
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la copie du fichier [' + aDirData + 'Backup.log >> ' + sSavePath + 'Backup.log]: ' + SysErrorMessage(GetLastError));
    end;
    if FileExists(aDirData + 'Restore.log') then
    begin
      if CopyFile(PChar(aDirData + 'Restore.log'), PChar(sSavePath + 'Restore.log'), False) then
        AddLog(DateTimeToStr(Now) + '  Copie du fichier [' + aDirData + 'Restore.log >> ' + sSavePath + 'Restore.log]')
      else
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la copie du fichier [' + aDirData + 'Restore.log >> ' + sSavePath + 'Restore.log]: ' + SysErrorMessage(GetLastError));
    end;
    if FileExists(aPathEAI + 'DelosQPMAgent.Providers.xml') then
    begin
      if CopyFile(PChar(aPathEAI + 'DelosQPMAgent.Providers.xml'), PChar(sSavePath + 'DelosQPMAgent.Providers.xml'), False) then
        AddLog(DateTimeToStr(Now) + '  Copie du fichier [' + aPathEAI + 'DelosQPMAgent.Providers.xml >> ' + sSavePath + 'DelosQPMAgent.Providers.xml]')
      else
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la copie du fichier [' + aPathEAI + 'DelosQPMAgent.Providers.xml >> ' + sSavePath + 'DelosQPMAgent.Providers.xml]: ' + SysErrorMessage(GetLastError));
    end;
    if FileExists(aPathEAI + 'DelosQPMAgent.Subscriptions.xml') then
    begin
      if CopyFile(PChar(aPathEAI + 'DelosQPMAgent.Subscriptions.xml'), PChar(sSavePath + 'DelosQPMAgent.Subscriptions.xml'), False) then
        AddLog(DateTimeToStr(Now) + '  Copie du fichier [' + aPathEAI + 'DelosQPMAgent.Subscriptions.xml >> ' + sSavePath + 'DelosQPMAgent.Subscriptions.xml]')
      else
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la copie du fichier [' + aPathEAI + 'DelosQPMAgent.Subscriptions.xml >> ' + sSavePath + 'DelosQPMAgent.Subscriptions.xml]: ' + SysErrorMessage(GetLastError));
    end;

    // Suppression des fichiers.
    if FileExists(aDirData + 'GO.BAT') then
    begin
      if not DeleteFile(PChar(aDirData + 'GO.BAT')) then
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + aDirData + 'GO.BAT]: ' + SysErrorMessage(GetLastError));
    end;
    if FileExists(aDirData + 'Rollback.log') then
    begin
      if not DeleteFile(PChar(aDirData + 'Rollback.log')) then
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + aDirData + 'Rollback.log]: ' + SysErrorMessage(GetLastError));
    end;
    if FileExists(aDirData + 'Statistical.log') then
    begin
      if not DeleteFile(PChar(aDirData + 'Statistical.log')) then
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + aDirData + 'Statistical.log]: ' + SysErrorMessage(GetLastError));
    end;
    if FileExists(aDirData + 'Validate.log') then
    begin
      if not DeleteFile(PChar(aDirData + 'Validate.log')) then
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + aDirData + 'Validate.log]: ' + SysErrorMessage(GetLastError));
    end;
    if FileExists(aDirData + 'Backup.log') then
    begin
      if not DeleteFile(PChar(aDirData + 'Backup.log')) then
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + aDirData + 'Backup.log]: ' + SysErrorMessage(GetLastError));
    end;
    if FileExists(aDirData + 'Restore.log') then
    begin
      if not DeleteFile(PChar(aDirData + 'Restore.log')) then
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + aDirData + 'Restore.log]: ' + SysErrorMessage(GetLastError));
    end;

    if FileExists(aDataBase) then
    begin
      S := aDirData + 'SV.GBK';
      if FileExists(S) then
      begin
        if not DeleteFile(S) then
          AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + S + ']: ' + SysErrorMessage(GetLastError));
      end;
      S := ChangeFileExt(aDataBase, '.Old');
      if FileExists(S) then
      begin
        if not DeleteFile(S) then
          AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + S + ']: ' + SysErrorMessage(GetLastError));
      end;
      if aShadow <> '' then
      begin
        S := ChangeFileExt(aShadow, '.Old');
        if FileExists(S) then
        begin
          if not DeleteFile(S) then
            AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + S + ']: ' + SysErrorMessage(GetLastError));
        end;
      end;
    end;

    AddLog(DateTimeToStr(Now) + ' Sauvegarde de la base terminée.');
    Log.SaveToFile(aDirData + 'BackupRestor.Log');

  except on E: Exception do
    begin
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(aDirData + 'BackupRestor.Log');
    end;
  end;
end;

procedure TFrm_BackRest.Phase(aMessage : string ) ;
begin
  AddLog(DateTimeToStr(Now) + '  --- ' + aMessage + ' ---');

  lbPhase.Caption := aMessage ;
  Application.ProcessMessages ;
end;

function TFrm_BackRest.PrefixDebug: String;
begin
  result := '                                                                   [DBG] '
end;

function TFrm_BackRest.StopEasy():boolean;
begin
  result:=true;
  if ServiceExist('', 'EASY') then
     begin
        AddLog(DateTimeToStr(Now) + '  Le Service EASY existe');
        If ServiceGetStatus('', 'EASY')>= 4
          then
            begin
              ServiceStop('','EASY');
              Sleep(3000);
            end;
        //--------------------------------
        If ServiceGetStatus('', 'EASY')>= 4
          then
            begin
              result:=false;
              AddLog(DateTimeToStr(Now) + '  Le Service EASY est en cours d''execution : Interdiction de Lancer un Backup/Restore');
              Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
            end;
     end;
end;

function TFrm_BackRest.Run: Boolean;
var
  ini             : TIniFile;
  tps             : Dword;
  F               : TSearchRec;
  tc              : Char;
  TailleRestante,
  taille          : int64;
  LesBases        : TStringList;
  i,
  ident           : integer;
  isParametre     : boolean;
  S,
  sDirData,
  sDataBase,
  PEAI,
  S_t,
  shadow,
  S1,
  S2,
  newRep,
  baseCopie,
  strIni          : string ;

  vZipVersionFile : string ;
  ZipVersion      : TZipVersion ;
  vBaseVersion    : string ;
  vVerificationMaj : boolean ;
  vParString      : string ;
  vParFloat       : Double ;
  vUrlSynchro     : string ;
  vNbCaisseSync   : Integer ;
  vNbNotebookSync : Integer ;
  vDebut : TDateTime ;
  vOk    : boolean ;
  vDoZipVersion : boolean ;
  vServiceMobilite : boolean ;
BEGIN
  bCanClose := False;
  btn_Backup.Enabled := false ;

  vDebut := Now ;

  if not(StopEasy) then
  begin
    bCanClose := True;
    btn_Backup.Enabled := True ;
    Exit;
  end;

  Phase('Initialisation ...') ;
  myTools.ShutDownWinUpdate;
  try
    strIni := 'FALSE'; //lab lecture du paramétrage pour l'analyse de la base avant back up
    try
      try
        DemandeArretService;
      finally
        AddLog(DateTimeToStr(Now) + '  Arrêt des services terminés.');
      end;
    except on E: Exception do
      begin
        AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
      end;
    end;
    Phase('Arrêt des services') ;
    try
      vServiceMobilite := false ;

//      if ServiceExist('', GinkoiaMobiliteSvr) then
//      begin
//        vServiceMobilite := (ServiceGetStatus('', GinkoiaMobiliteSvr) = SERVICE_RUNNING) ;
//        if vServiceMobilite then
//        begin
//          if ServiceWaitStop('', GinkoiaMobiliteSvr, 30000)
//            then AddLog(DateTimeToStr(Now) + '  Le service '+ GinkoiaMobiliteSvr+' a été arrêté.')
//            else AddLog(DateTimeToStr(Now) + '  Le service '+ GinkoiaMobiliteSvr+' n''a pas pu être arrêté.') ;
//        end else begin
//          AddLog(DateTimeToStr(Now) + '  Le service '+ GinkoiaMobiliteSvr+' n''est pas démarré.');
//        end;
//      end else begin
//        AddLog(DateTimeToStr(Now) + '  Le service '+ GinkoiaMobiliteSvr+' n''est pas installé.');
//      end;
      if not SrvManager.stopServices then
        onLog(self, 'Echec stopServices');
    except
      On E:Exception do
        AddLog(DateTimeToStr(Now) + '  Exception lors de l''arrêt des services : ' + E.Message);
    end;

    Phase('Arrêt des applications') ;
    TRY
      // Clôture de ginkoia
      KillProcess(ginkoia);
      AddLog(DateTimeToStr(Now) + '  Arrêt de ginkoia.');

      // Clôture de la caisse
      KillProcess(Caisse);
      AddLog(DateTimeToStr(Now) + '  Arrêt de la caisse.');

      // Clôture du piccolink
      KillProcess(PICCO);
      AddLog(DateTimeToStr(Now) + '  Arrêt de Piccolink.');

      // Clôture du launcher
        AddLogDBG(DateTimeToStr(Now) + 'Run Try KillProcess:'+LauncherV7);
        try
          if KillProcess(LauncherV7)
            then AddLogDBG(DateTimeToStr(Now) + 'Run Ok KillProcess:'+LauncherV7)
            else AddLogDBG(DateTimeToStr(Now) + 'Run Nok KillProcess:'+LauncherV7)
        except
          on e:exception do
            AddLogDBG(DateTimeToStr(Now) + 'Run Error KillProcess:'+e.Message);
        end;
      AddLog(DateTimeToStr(Now) + '  Arrêt du Launcher.');

      // Clôture du SyncWeb
      KillProcess(SyncWeb);
      AddLog(DateTimeToStr(Now) + '  Arrêt du SyncWeb.');

      // Clôture du ibScheduler
      KillProcess(ibScheduler);
      AddLog(DateTimeToStr(Now) + '  Arrêt du Scheduler.');

      AddLog(DateTimeToStr(Now) + '  Arrêt des applications externes');
      {$REGION 'Arret des applications externe via le fichier KLaunch.app'}
      KillApp.Load;
      for i := 0 to KillApp.Count - 1 do
        KillProcess(KillApp.List[i]);
      {$ENDREGION}
      AddLog(DateTimeToStr(Now) + '  Arrêt des applications terminé.');

      Taille := 0;

      MapGinkoia.Backup := true;
      StopService;

      try
        while log.count > 200 do
          log.delete(0);
        enabled := false;
        try
          result := false;
          try
            LesBases := TstringList.Create;
            if NewBase then
            begin
              AddLog(DateTimeToStr(Now) +' Mode NewBase') ;
              // NewBase algol
              Dm_BackRest.Ib_LesBases.Open;
              Dm_BackRest.Ib_LesBases.first;
              while not Dm_BackRest.Ib_LesBases.Eof do
              begin
                sDataBase := Dm_BackRest.Ib_LesBasesREP_PLACEBASE.AsString;
                sDirData := ExtractFilePath(sDataBase);
                if sDirData <> '' then
                begin
                  if sDirData[Length(sDirData)] <> '\' then
                    sDirData := sDirData + '\';
                  PEAI := Dm_BackRest.Ib_LesBasesREP_PLACEEAI.AsString;
                  S_t := Uppercase(sDirData + ';' + sDataBase + ';' + PEAI);
                  if LesBases.IndexOF(S_T) < 0 then
                    LesBases.Add(S_T);
                end;

                Dm_BackRest.Ib_LesBases.Next;
              END;
              Dm_BackRest.Ib_LesBases.Close;
              Dm_BackRest.Database.close;

              FOR i := 0 TO LesBases.Count - 1 DO
                LesBases[i] := Uppercase(LesBases[i]);
              LesBases.Sort;
              i := 0;
              S2 := '';
              WHILE i < LesBases.Count DO
              BEGIN
                S1 := LesBases[i];
                delete(S1, 1, pos(';', S1));
                S1 := Copy(S1, 1, Pos(';', S1) - 1);
                IF NOT fileexists(S1) THEN
                  LesBases.delete(i)
                ELSE
                BEGIN
                  IF S1 = S2 THEN
                    LesBases.delete(i)
                  ELSE
                    inc(i);
                END;
                S2 := S1;
              END;
            END
            ELSE
            BEGIN
              AddLog(DateTimeToStr(Now) +' Mode OldBase') ;

              sDirData := sPathDirData;
              sDataBase := sPathDataBase;
              PEAI := sPathExe + 'EAI\';
              LesBases.Add(sDirData + ';' + sDataBase + ';' + PEAI);
            END;

            TpsDem := GetTickCount;
            Timer1.Enabled := true;
            tps := GetTickCount;

            if LesBases.Count < 1 then
            begin
              Phase('Aucune base à backuper') ;
              AddLog(DateTimeToStr(Now) +' Aucune base a backuper.') ;
            end;


            FOR i := 0 TO LesBases.Count - 1 DO
            BEGIN
              shadow := '';
              S := LesBases[i];
              sDirData := Copy(S, 1, Pos(';', S) - 1);
              delete(S, 1, pos(';', S));
              sDataBase := Copy(S, 1, Pos(';', S) - 1);
              delete(S, 1, pos(';', S));
              PEAI := S;

              AddLog(DateTimeToStr(Now) +' DirData : '  + sDirData) ;
              AddLog(DateTimeToStr(Now) +' Database : ' + sDataBase) ;
              AddLog(DateTimeToStr(Now) +' EAI : ' + PEAI) ;
              Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

              IF interbase7 THEN
              BEGIN
                // pour chaque base regarder si un fichier shadow existe
                Dm_BackRest.DataBase.close;
                Dm_BackRest.DataBase.DataBaseName := sDataBase;
                Dm_BackRest.Qry.sql.clear;
                Dm_BackRest.Qry.sql.add('select rdb$file_NAME from rdb$files');
                Dm_BackRest.Qry.Open;
                IF Dm_BackRest.qry.recordcount <> 0 THEN
                  shadow := trim(Dm_BackRest.qry.Fields[0].AsString);
                Dm_BackRest.Qry.Close;
                Dm_BackRest.Qry.sql.clear;

                Dm_BackRest.BAS_ID := Dm_BackRest.GetBasID ;
                // Histo EVT
                Dm_BackRest.setHistoEvent(CBACKRESTOK, False, '', 0);
                Dm_BackRest.DataBase.Close;
              END;


              IF NOT (fileexists(ChangeFileExt(sDataBase, '.Old'))) AND
                ((Shadow = '') OR NOT (fileexists(ChangeFileExt(Shadow, '.Old')))) THEN
              BEGIN
                taille := 0;
                IF findfirst(sDataBase, faanyfile, F) = 0 THEN
                  taille := taille + f.Size;
                findClose(f);
                tc := Upcase(sDataBase[1]);
                TailleRestante := DiskFree(Ord(TC) - Ord('A') + 1);

                IF TailleRestante < Taille * 2 THEN
                BEGIN
                  AddLog(DateTimeToStr(Now) + '  # Pas suffisament de place pour le Backup sur [' + tc +':\]');
                  AddLog(DupeString(' ', 21) + 'Taille base ' + FormatFloat(',##0', Taille) + ' - Taille restante ' + FormatFloat(',##0', TailleRestante));
                  Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                  marqueBase(False, 5, sDataBase);
                  result := false;
                END
                ELSE
                BEGIN
                  AddLog(DateTimeToStr(Now) + '  Espace disque OK sur [' + tc + ':\]:');
                  AddLog(DupeString(' ', 21) + 'Taille base ' + FormatFloat(',##0', Taille) + ' - Taille restante ' + FormatFloat(',##0', TailleRestante));
                  Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

                  AddLog(DateTimeToStr(Now) + '  Début sauvegarde ' + sDataBase);
                  Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                  Phase('Sauvegarde en cours ...') ;
                  //update;
                  AddLog(DateTimeToStr(Now) + '  Vérification du paramétre de la synchro');
                  Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

                  isParametre := false;

                  //lab verifier s'il s'agit d'un serveur dont le paramétre de la synchro Notebook est actif
                  TRY
                    Dm_BackRest.DataBase.close;
                    Dm_BackRest.DataBase.DatabaseName := sDataBase ;

                    Dm_BackRest.Que_ParamSynchro.open;
                    IF (Dm_BackRest.Que_ParamSynchro.RecordCount = 1) THEN
                    BEGIN
                      vUrlSynchro := Dm_BackRest.Que_ParamSynchroPRM_STRING.asString ;
                      IF (Dm_BackRest.Que_ParamSynchroPRM_FLOAT.AsFloat = 0) THEN //si je ne suis pas en synchro avec une base
                      BEGIN
                        //tester si d'autres bases sont synchronisées
                        try
                          Dm_BackRest.Que_Tmp.Close ;
                          Dm_BackRest.Que_Tmp.SQL.Text := 'SELECT COUNT(PRM_ID) FROM GENPARAM ' +
                                             'JOIN K ON K_ID = PRM_ID AND K_ENABLED=1 ' +
                                             'WHERE PRM_TYPE=3 AND PRM_CODE=33 ' +
                                             'AND PRM_INTEGER=1 ' +
                                             'AND PRM_FLOAT = CAST((select Par_String from genparambase  where Par_nom=''IDGENERATEUR'') as INTEGER)' ;
                          Dm_BackRest.Que_Tmp.Open ;

                          vNbCaisseSync := Dm_BackRest.Que_Tmp.FieldByName('COUNT').AsInteger  ;

                          if vNbCaisseSync > 0 then
                          begin
                            isParametre := true ;
                          end;

                          Dm_BackRest.Que_Tmp.Close ;
                        except
                        end;

                        // Verification des caisses de secours synchro
                        try
                          Dm_BackRest.Que_Tmp.SQL.Text := 'SELECT COUNT(PRM_ID) FROM GENPARAM ' +
                                             'JOIN K ON K_ID = PRM_ID AND K_ENABLED=1 ' +
                                             'WHERE PRM_TYPE=11 AND PRM_CODE=50 ' +
                                             'AND PRM_INTEGER=1 AND PRM_STRING <> '''' ' ;
                          Dm_BackRest.Que_Tmp.Open ;

                          vNbCaisseSync := Dm_BackRest.Que_Tmp.FieldByName('COUNT').AsInteger  ;

                          if vNbCaisseSync > 0 then
                          begin
                            isParametre := true ;
                          end;

                          Dm_BackRest.Que_Tmp.Close ;

                        except
                        end;
                      END
                    END;
                  FINALLY
                    Dm_BackRest.Que_ParamSynchro.Close;
                    Dm_BackRest.DataBase.close;
                  END;

                  AddLog(DateTimeToStr(Now) + '  analyse des statistiques de la base');
                  Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                  //si option Analyser active lancer l'analyse : récupèrer dans l'ini les params
                  Ini := TIniFile.Create(changefileext(application.exename, '.ini'));
                  try
                    strIni := ini.readString('STAT', 'ACTIF', '');
                    if (UpperCase(strIni) = 'TRUE') then
                    begin
                      try
                        strIni := ini.readString('STAT', 'TIMEOUT', '');
                        iniTimeout := StrToInt(strini);
                      except
                        iniTimeout := 0;
                      end;
                      Statistical(sDirData,sDataBase);
                    end;
                  finally
                    FreeAndNil(Ini);
                  end;
                  //lab déplacé pour résoudre les deadlock sur TMP_BACKUPRESTORE qui empeche le marquage des tables
                  AddLog(DateTimeToStr(Now) + '  Arret de la base ');
                  Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

                  Phase('Arrêt de la base') ;

                  StopBase(sDirData, sDataBase);
                  AddLog(DateTimeToStr(Now) + '  Début du marquage des tables ');
                  Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                  IF MarqueLesTables(sDataBase) THEN
                  BEGIN
                    //lab déplacé plus pour résoudre les deadlock sur TMP_BACKUPRESTORE qui empeche le marquage des tables
    //                  Log.Add(DateTimeToStr(Now) + '  Arret de la base ');
    //                  Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    //                  Caption := 'Arret de la Base ';
                      //update;
                      //ArretBase(sDirData, sDataBase);
                      //Sandrine                  DemareBase(sDirData, sDataBase);
                    AddLog(DateTimeToStr(Now) + '  Backup de la base ');
                    Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

                    Phase('Backup en cours ...') ;
                    //update;

                    Pause;    //15/05/12 - SR - Ajout d'une pause avant Backup

                    AddLog(DateTimeToStr(Now) + '  Validate ... ');
                    Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                    if Validate(sDirData, sDataBase) then    //15/05/12 - SR - Ajout d'une pause avant Backup
                    begin
                      Pause;

                      AddLog(DateTimeToStr(Now) + '  Backup ... ');
                      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

                      try
                        vOk := false ;
                        vOk := Backup(sDataBase,sDirData + 'SV.GBK',nil,True) ;
                      except
                        on E:Exception do
                        begin
                          vOk := false ;
                          AddLog(DateTimeToStr(Now) + '  ' + E.Message);
                        end;
                      end;

                      if vOk then
                      begin
                        AddLog(DateTimeToStr(Now) + '  Backup terminé ');
                        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

                        // on renome plus
                        AddLog(DateTimeToStr(Now) + '  Restauration de la base ');
                        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

                        Phase('Restauration en cours...') ;
                        //update;
                        if FileExists(sDirData + 'Gink.IB') then
                        begin
                          if not DeleteFile(sDirData + 'Gink.IB') then
                            AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + sDirData + 'Gink.IB]: ' + SysErrorMessage(GetLastError));
                        end;

                        Pause;    //15/05/12 - SR - Ajout d'une pause avant Restore

                        IF RestoreGBak(sPathBorlBin,sDirData + 'Gink.IB', sDirData + 'SV.GBK',Dm_BackRest.PageSizeVal,Dm_BackRest.BuffersVal, Dm_BackRest.SweepVal) THEN
                        BEGIN
                          AddLog(DateTimeToStr(Now) + '  démarage de la base ');
                          Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                          Phase('Démarrage de la base');

                          //update;
                          StartBase(sDirData, sDirData + 'Gink.IB');
                          AddLog(DateTimeToStr(Now) + '  Vérification de la base ');
                          Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                          Phase('Vérification de la base');

                          //update;
                          IF VerifBase(sDirData + 'Gink.IB') THEN
                          BEGIN
                            AddLog(DateTimeToStr(Now) + '  Backup/Restore OK ');
                            Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                            Phase('Backup / Restore terminé');

                            //update;
                            AddLog(DateTimeToStr(Now) + '  Mise à jour des sauvegardes...');
                            Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

                            ValideNvBck(sDirData, PEAI, sDataBase, Shadow, Dm_BackRest.iNbRepSave);

                            AddLog(DateTimeToStr(Now) + '  Mise à jour des sauvegardes terminé');
                            Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

                            //lab faire une copie si je suis un serveur dont le parametre synchro est actif
                            IF isParametre THEN
                            BEGIN
                              Phase('Création de la base de synchro') ;
                              vBaseVersion := Dm_BackRest.GetVersion ;

                              if vBaseVersion <> ''
                                then AddLog(DateTimeToStr(Now) + '  Base v.'+ vBaseVersion )
                                else AddLog(DateTimeToStr(Now) + '  Erreur !!! Impossible d''obtenir le numéro de version de la base.') ;

                              Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

                              vDoZipVersion := false ;
                              //faire la copie de la base restaurée pour le notebook
                              IF NOT copyFichier(sDirData + 'Gink.IB', ExtractFilePath(sDataBase) + '\Synchro\GINKCOPY.IB', 3) THEN
                              BEGIN
                                AddLog(DateTimeToStr(Now) + '  Erreur lors de la copie de la base restaurée vers le dossier SYNCHRO ');
                                Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                              end else begin
                                 vDoZipVersion := true ;
                              end;

                              try
                                Dm_BackRest.Database.Close ;
                              except
                              end;
                            END;

                            AddLog(DateTimeToStr(Now) + '  Renomage de la base ');
                            Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

                            IF RenomeBase(sDataBase, Shadow) THEN
                            BEGIN
                              //créer le répertoire 'backup' s'il n'existe pas
                              newRep := sDirData + 'backup\';
                              ForceDirectories(newRep);
                              IF RenameFile(sDirData + 'Gink.IB', sDataBase) THEN
                              BEGIN
                                AddLog(DateTimeToStr(Now) + '  Tout est OK ');
                                Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                                //déplacer '.toto'
                                baseCopie := ChangeFileExt(sDataBase, '.toto');
                                //supprimer l'ancien
                                if FileExists(newRep + ExtractFileName(baseCopie)) then
                                begin
                                  if not DeleteFile(newRep + ExtractFileName(baseCopie)) then
                                    AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + newRep + ExtractFileName(baseCopie) + ']: ' + SysErrorMessage(GetLastError));
                                end;
                                if not MoveFile(Pchar(baseCopie), PChar(newRep + ExtractFileName(baseCopie))) then
                                  AddLog(DateTimeToStr(Now) + '  # Erreur :  échec du déplacement du fichier [' + baseCopie + ' >> ' + newRep + ExtractFileName(baseCopie) + ']: ' + SysErrorMessage(GetLastError));
                                StartBase(sDirData, sDataBase);
                                marqueBase(true, 0, sDataBase);

                                try
                                  Dm_BackRest.Database.DatabaseName := sDataBase ;
                                  Dm_BackRest.Database.Open ;
                                  Dm_BackRest.set_GENERATOR_NUM_TMPTB();
                                  Dm_BackRest.setHistoEvent(CBACKRESTOK, True, '', Now - vDebut);
                                  Dm_BackRest.setHistoEvent(CLASTBACKREST, True, '', Now - vDebut);

                                  if vDoZipVersion then
                                  begin
                                       AddLog(DateTimeToStr(Now) + 'Fabrication de l''archive de version');
                                       Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

                                       // Copy de la base synchro réussie, on fabrique le ZIP de version si besoin
                                       vZipVersionFile := ExtractFilePath(sDataBase) + 'Synchro\Version.zip' ;

                                       vVerificationMaj := true ;
                                       if Dm_BackRest.getGenParamBase('VERIFICATION', vParString, vParFloat)  then
                                       begin
                                         vVerificationMaj := (vParString = 'UPDATED') ;
                                       end ;

                                       if ((not FileExists(vZipVersionFile)) or (vVerificationMaj)) then
                                       begin
                                         Phase('Génération de l''archive de version ...');

                                         ZipVersion := TZipVersion.Create ;
                                         ZipVersion.BasePath := sPathExe ;
                                         ZipVersion.Version  := vBaseVersion ;
                                         if ZipVersion.BuildVersion(ExtractFilePath(sDataBase) + 'Synchro\Version.zip') then
                                         begin
                                           // Boucle d'attente. ZipVersion est Threadé.
                                           while ZipVersion.Status < vsFinished do
                                           begin
                                              Application.ProcessMessages ;
                                              sleep(100) ;
                                              Phase('Version : ' + ZipVersion.ExplainStatus(zipVersion.Status)) ;
                                           end;
                                         end;

                                         if ZipVersion.Status = vsFinished then
                                         begin
                                          AddLog(DateTimeToStr(Now) + 'Fabrication de l''archive de version : réussie');
                                          DM_BackRest.setGenParamBase('VERIFICATION', 'OK', 0) ;
                                         end else begin
                                          AddLog(DateTimeToStr(Now) + 'Fabrication de l''archive de version : ECHEC : ' + ZipVersion.Error) ;
                                         end;
                                         Log.SaveToFile(sPathDirData + 'BackupRestor.Log');

                                         ZipVersion.Free ;
                                       end ;
                                  end;

                                finally
                                  Dm_BackRest.Database.Close
                                end;

                              END
                              ELSE
                              BEGIN
                                AddLog(DateTimeToStr(Now) + '  # Erreur :  échec du renommage [' + sDirData + 'Gink.IB >> ' + sDataBase + ']: ' + SysErrorMessage(GetLastError));
                                if not RenameFile(ChangeFileExt(sDataBase, '.toto'), sDataBase) then
                                  AddLog(DateTimeToStr(Now) + '  # Erreur :  échec du renommage [' + ChangeFileExt(sDataBase, '.toto') + ' >> ' + sDataBase + ']: ' + SysErrorMessage(GetLastError));
                                Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                                StartBase(sDirData, sDataBase);
                                marqueBase(true, 1, sDataBase);
                              END;

                              //déplacer la sauvegarde zippée
      //                          IF FileExists(zip.ZipName) THEN
      //                          BEGIN
      //                            //supprimer l'ancienne
      //                            deletefile(newRep + ExtractFileName(zip.ZipName));
      //                          END;
      //                          MoveFile(Pchar(zip.ZipName), PChar(newRep + ExtractFileName(zip.ZipName)));
                            END
                            ELSE
                            BEGIN
                              AddLog(DateTimeToStr(Now) + '  # Impossible de sauvegarder la base actuelle en Ginkoia.toto :  ' + SysErrorMessage(GetLastError));
                              Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                              StartBase(sDirData, sDataBase);
                              marqueBase(true, 1, sDataBase);
                            END;

                            IF FileExists(sDataBase) THEN
                            BEGIN
                              if FileExists(sDirData + 'Gink.IB') then
                              begin
                                if not DeleteFile(sDirData + 'Gink.IB') then
                                  AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + sDirData + 'Gink.IB]: ' + SysErrorMessage(GetLastError));
                              end;
                              if FileExists(sDirData + 'SV.GBK') then
                              begin
                                if not DeleteFile(sDirData + 'SV.GBK') then
                                  AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + sDirData + 'SV.GBK]: ' + SysErrorMessage(GetLastError));
                              end;
                            END;
                            result := true;
                            Phase('Backup terminé avec succès') ;
                          END
                          ELSE
                          BEGIN
                            AddLog(DateTimeToStr(Now) + '  Base mal restaurée ');
                            Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                            Phase('Base mal restaurée ');
                            //update;
                            IF FileExists(sDataBase) THEN
                            BEGIN
                              if FileExists(sDirData + 'Gink.IB') then
                              begin
                                if not DeleteFile(sDirData + 'Gink.IB') then
                                  AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + sDirData + 'Gink.IB]: ' + SysErrorMessage(GetLastError));
                              end;
                              if FileExists(sDirData + 'SV.GBK') then
                              begin
                                if not DeleteFile(sDirData + 'SV.GBK') then
                                  AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + sDirData + 'SV.GBK]: ' + SysErrorMessage(GetLastError));
                              end;
                            END;
                            StartBase(sDirData, sDataBase);
                            marqueBase(False, 2, sDataBase);
                          END;
                        END
                        ELSE
                        BEGIN
                          AddLog(DateTimeToStr(Now) + '  Restauration planté ');
                          Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                          Phase('Restauration planté ');
                          //update;
                          IF fileexists(sDataBase) THEN
                          BEGIN
                            if FKeepGBKOnFailure then
                            begin
                              AddLog(DateTimeToStr(Now) + '  GBK gardé pour débug.');
                              Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                              ForceDirectories(sDirData + 'Debug\') ;

                              if FileExists(sDirData + 'Gink.IB') then
                              begin
                                ForceDirectories(sDirData + 'Debug\') ;

                                if FileExists(sDirData + 'Debug\Gink.ib') then
                                begin
                                  if not DeleteFile(sDirData + 'Debug\Gink.ib') then
                                    AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + sDirData + 'Debug\Gink.ib]: ' + SysErrorMessage(GetLastError));
                                end;

                                if not RenameFile(sDirData + 'Gink.IB', sDirData + 'Debug\Gink.ib') then
                                  AddLog(DateTimeToStr(Now) + '  # Erreur :  échec du renommage [' + sDirData + 'Gink.IB >> ' + sDirData + 'Debug\Gink.ib]: ' + SysErrorMessage(GetLastError));
                              end;

                              if FileExists(sDirData + 'SV.GBK') then
                              begin
                                ForceDirectories(sDirData + 'Debug\');

                                if FileExists(sDirData + 'Debug\SV.GBK') then
                                begin
                                  if not DeleteFile(sDirData + 'Debug\SV.GBK') then
                                    AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + sDirData + 'Debug\SV.GBK]: ' + SysErrorMessage(GetLastError));
                                end;

                                if not RenameFile(sDirData + 'SV.GBK', sDirData + 'Debug\SV.GBK') then
                                  AddLog(DateTimeToStr(Now) + '  # Erreur :  échec du renommage [' + sDirData + 'SV.GBK >> ' + sDirData + 'Debug\SV.GBK]: ' + SysErrorMessage(GetLastError));
                              end;
                            end
                            else
                            begin
                              if FileExists(sDirData + 'Gink.IB') then
                              begin
                                if not DeleteFile(sDirData + 'Gink.IB') then
                                  AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + sDirData + 'Gink.IB]: ' + SysErrorMessage(GetLastError));
                              end;
                              if FileExists(sDirData + 'SV.GBK') then
                              begin
                                if not DeleteFile(sDirData + 'SV.GBK') then
                                  AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + sDirData + 'SV.GBK]: ' + SysErrorMessage(GetLastError));
                              end;
                            end;

                          END;

                          StartBase(sDirData, sDataBase);
                          marqueBase(False, 3, sDataBase);
                        END;

                      END ELSE BEGIN

                        AddLog(DateTimeToStr(Now) + '  Backup pas OK ');
                        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                        Phase('Backup pas OK');

                        if FileExists(sDataBase) then
                        begin
                          if FileExists(sDirData + 'SV.GBK') then
                          begin
                            if not DeleteFile(sDirData + 'SV.GBK') then
                              AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + sDirData + 'SV.GBK]: ' + SysErrorMessage(GetLastError));
                          end;
                        end;
                        StartBase(sDirData, sDataBase);
                        marqueBase(False, 4, sDataBase);

                      END;
                    end
                    else
                    begin
                      AddLog(DateTimeToStr(Now) + '  Validate pas OK ');
                      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                      Phase('Validate pas OK');
                      StartBase(sDirData, sDataBase);
                    end;
                  END
                  ELSE
                  BEGIN
                    AddLog(DateTimeToStr(Now) + '  Update 2');
                    Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                    Phase('Problème de base ');
                    //update;
                    AddLog(DateTimeToStr(Now) + '  Ne peut même pas marquer les tables ');
                    Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                  END;
                END;
              END
              ELSE
              BEGIN
                Phase('Problème de base ');
                //update;
                AddLog(DateTimeToStr(Now) + '  Un Fichier.OLD existe déjà ');
                Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
                result := false;
              END;
            END;
            IF result THEN
            BEGIN
              TRY
                tps := GetTickCount - tps;
              EXCEPT
                AddLog(DateTimeToStr(Now) + '  Problème Calcule du temps ');
                Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
              END;
              TRY
                TailleBaseMoy := trunc((TailleBaseMoy + taille) / 2);
              EXCEPT
                AddLog(DateTimeToStr(Now) + '  Problème Calcule tailleBaseMoy ');
                Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
              END;
              TRY
                TmpsMoy := trunc((TmpsMoy + Integer(tps)) / 2);
              EXCEPT
                AddLog(DateTimeToStr(Now) + '  Problème Calcule TmpsMoy ');
                Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
              END;
              TRY
                NbBckup := NbBckup + 1;
              EXCEPT
                AddLog(DateTimeToStr(Now) + '  Problème Calcule NbBckup ');
                Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
              END;
              try
                ini := TIniFile.Create(changefileext(application.exename, '.ini'));
                try
                  ini.Writeinteger('TPS', 'NB', NbBckup);
                  ini.Writeinteger('TPS', 'TB', TailleBaseMoy);
                  ini.Writeinteger('TPS', 'TPS', TmpsMoy);
                finally
                  FreeAndNil(ini);
                end;
              except
                AddLog(DateTimeToStr(Now) + '  Problème ecriture dans ' + changefileext(application.exename, '.ini'));
                Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
              end;
            END;
          EXCEPT on E:Exception do
            begin
              Phase('Problème de base');
              //update;
              AddLog(DateTimeToStr(Now) + '  Problème non connu : ' + E.Message);
              Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
            end;
          END;
        FINALLY
          AddLog(DateTimeToStr(Now) + '  Libération du mapping ');
          Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
          MapGinkoia.Backup := False;
          Timer1.Enabled := false;
          enabled := true;
        END;
      FINALLY
        StartService;
      END;
    FINALLY
      DemandeDemareService;
    END;
  finally
    try
      AddLog(DateTimeToStr(Now) + '  Redémarrage des services') ;

//      if ServiceExist('', GinkoiaMobiliteSvr) then
//      begin
//        if vServiceMobilite then
//        begin
//          if ServiceWaitStart('', GinkoiaMobiliteSvr, 30000)
//            then AddLog(DateTimeToStr(Now) + '  Le service '+ GinkoiaMobiliteSvr+' a été redémarré.')
//            else AddLog(DateTimeToStr(Now) + '  Le service '+ GinkoiaMobiliteSvr+' n''a pas pu être redémarré.') ;
//        end else begin
//          AddLog(DateTimeToStr(Now) + '  Le service '+ GinkoiaMobiliteSvr+' n''etait pas démarré avant le Backup.');
//        end;
//      end else begin
//        AddLog(DateTimeToStr(Now) + '  Le service '+ GinkoiaMobiliteSvr+' n''est pas installé.');
//      end;
      if not SrvManager.restartServices then
        onLog(self, 'Echec restartServices');
    except
      On E:Exception do
        AddLog(DateTimeToStr(Now) + '  Exception lors du redémarrage des services : ' + E.Message);
    end;

    bCanClose := True;
    myTools.StartWinUpdate;
    Btn_Backup.Enabled := true ;

    Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
  end;
END;

procedure TFrm_BackRest.AddLog(aLigne: string);
begin
  Log.Add(aLigne);
  LogDbg.Add(aLigne);
end;

procedure TFrm_BackRest.AddLogDBG(aLigne: string);
begin
  LogDbg.Add(aLigne);
end;

PROCEDURE TFrm_BackRest.Attente_IB;
VAR
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  tempMini: DWORD;
  CheckPoint: DWORD;
  NbBcl: Integer;
BEGIN
  hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
  hService := OpenService(hSCManager, 'InterBaseGuardian', SERVICE_QUERY_STATUS);
  IF hService <> 0 THEN
  BEGIN // Service non installé
    QueryServiceStatus(hService, Statut);
    CheckPoint := 0;
    NbBcl := 0;
    WHILE (statut.dwCurrentState <> SERVICE_RUNNING) OR
      (CheckPoint <> Statut.dwCheckPoint) DO
    BEGIN
      CheckPoint := Statut.dwCheckPoint;
      tempMini := Statut.dwWaitHint + 1000;
      Sleep(tempMini);
      QueryServiceStatus(hService, Statut);
      Inc(nbBcl);
      IF NbBcl > 300 THEN BREAK;
    END;

    AddLogDBG(DateTimeToStr(Now) + 'Attente_IB Try KillProcess:'+LauncherV7);
    try
      if KillProcess(LauncherV7)
        then AddLogDBG(DateTimeToStr(Now) + 'Attente_IB Ok KillProcess:'+LauncherV7)
        else AddLogDBG(DateTimeToStr(Now) + 'Attente_IB Nok KillProcess:'+LauncherV7)
    except
      on e:exception do
        AddLogDBG(DateTimeToStr(Now) + 'Attente_IB Error KillProcess:'+e.Message);
    end;

    IF NbBcl < 300 THEN
    BEGIN
      CloseServiceHandle(hService);
      hService := OpenService(hSCManager, 'InterBaseServer', SERVICE_QUERY_STATUS);
      IF hService <> 0 THEN
      BEGIN // Service non installé
        QueryServiceStatus(hService, Statut);
        CheckPoint := 0;
        NbBcl := 0;
        WHILE (statut.dwCurrentState <> SERVICE_RUNNING) OR
          (CheckPoint <> Statut.dwCheckPoint) DO
        BEGIN
          CheckPoint := Statut.dwCheckPoint;
          tempMini := Statut.dwWaitHint + 1000;
          Sleep(tempMini);
          QueryServiceStatus(hService, Statut);
          Inc(nbBcl);
          IF NbBcl > 300 THEN BREAK;
        END;
      END;
    END;
  END;
  CloseServiceHandle(hService);
  CloseServiceHandle(hSCManager);
END;

procedure TFrm_BackRest.Btn_BackupClick(Sender: TObject);
begin
  if fileExists(sPathDataBase) then   //Lance de la procédure de Backup
  begin
    if Run then
    begin
      Phase('Backup terminé avec succès') ;
      Application.MessageBox(Pchar('Backup terminé avec success.'), 'Avertisement', Mb_Ok);
    end;

    if isEasy
      then StartLauncherEasy
      else StartLauncher('');
    StartSyncWeb;
  end;
end;

PROCEDURE TFrm_BackRest.Timer1Timer(Sender: TObject);
VAR
  tps: Dword;

  FUNCTION Int2str(t: integer): STRING;
  BEGIN
    result := Inttostr(t);
    IF length(result) < 2 THEN result := '0' + result;
  END;

  FUNCTION tpenstring(t: Dword): STRING;
  BEGIN
    IF t < 61 THEN
      result := Inttostr(t) + 's'
    ELSE
      IF t < 3601 THEN
        result := Inttostr(t DIV 60) + ':' + Int2str(t MOD 60) + ' min'
      ELSE
        result := Inttostr(t DIV 3600) + ':' + Int2str((t MOD 3600) DIV 60) + ':' + Int2str((t MOD 3600) MOD 60) + ' H';

  END;
BEGIN
  TRY
    tps := GetTickCount - TpsDem;
    Lab.caption := 'Temps   ' + tpenstring(trunc(tps / 1000));
    IF TmpsMoy > 0 THEN
    BEGIN
      Lab.caption := Lab.caption + ',    Estimé  ' + tpenstring(trunc(TmpsMoy / 1000));
    END;
    Lab.Update;
  EXCEPT ON E: Exception DO
    BEGIN
      AddLog(DateTimeToStr(Now) + '  # Exception :  ' + E.message);
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    END;
  END;
END;

PROCEDURE TFrm_BackRest.marqueBase(OK: Boolean; tipe: Integer; PDataBase: STRING);
VAR
  F: STRING;
  num: STRING;
  idVersion,
    id: STRING;
  empty: Boolean;
BEGIN
  TRY
    Dm_BackRest.Database.Connected := false;
    Dm_BackRest.Database.DatabaseName := PDataBase;
    IF ok THEN
      F := '1'
    ELSE
      F := '0';
    Dm_BackRest.Qry.Sql.Clear;
    Dm_BackRest.Qry.Sql.Add('select Cast(PAR_STRING as Integer) Numero');
    Dm_BackRest.Qry.Sql.Add('from genparambase');
    Dm_BackRest.Qry.Sql.Add('Where PAR_NOM=''IDGENERATEUR''');
    Dm_BackRest.Qry.Open;
    num := Dm_BackRest.Qry.Fields[0].AsString;
    AddLog(DateTimeToStr(Now) + ' récup de l''ID ' + num);
    Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    Dm_BackRest.Qry.Close;
    Dm_BackRest.Qry.Sql.Clear;
    Dm_BackRest.Qry.Sql.Add('select Bas_ID');
    Dm_BackRest.Qry.Sql.Add('from GenBases');
    Dm_BackRest.Qry.Sql.Add('where BAS_ID<>0');
    Dm_BackRest.Qry.Sql.Add('AND BAS_IDENT=''' + Num + '''');
    Dm_BackRest.Qry.Open;
    num := Dm_BackRest.Qry.Fields[0].AsString;
    AddLog(DateTimeToStr(Now) + ' récup de Base ID ' + num);
    Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
    Dm_BackRest.Qry.Close;

    Dm_BackRest.Qry.Sql.Clear;
    Dm_BackRest.Qry.Sql.Add('Select DOS_ID ');
    Dm_BackRest.Qry.Sql.Add('from GenDossier ');
    Dm_BackRest.Qry.Sql.Add('Where DOS_NOM = ''B-' + NUM + '''');
    Dm_BackRest.Qry.Sql.Add('  And DOS_FLOAT = ' + f);
    Dm_BackRest.Qry.Open;
    empty := Dm_BackRest.Qry.IsEmpty;
    IF NOT Empty THEN
    BEGIN
      Id := Dm_BackRest.Qry.Fields[0].AsString;
    END;
    Dm_BackRest.Qry.Close;
    Dm_BackRest.Qry.Sql.Clear;
    Dm_BackRest.Qry.Sql.Add('Select NewKey ');
    Dm_BackRest.Qry.Sql.Add('From PROC_NEWKEY');
    Dm_BackRest.Qry.Open;
    IF empty THEN
    BEGIN
      Id := Dm_BackRest.Qry.Fields[0].AsString;
      IdVersion := Id;
    END
    ELSE
      IdVersion := Dm_BackRest.Qry.Fields[0].AsString;
    Dm_BackRest.Qry.Close;

    IF empty THEN
    BEGIN
      AddLog(DateTimeToStr(Now) + ' Création de l''enregistrement ' + Id);
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
      Dm_BackRest.Qry.Sql.Clear;
      Dm_BackRest.Qry.Sql.Add('Insert Into GenDossier');
      Dm_BackRest.Qry.Sql.Add('(DOS_ID, DOS_NOM, DOS_STRING, DOS_FLOAT)');
      Dm_BackRest.Qry.Sql.Add('VALUES (');
      Dm_BackRest.Qry.Sql.Add(Id + ',''B-' + Num + ''',''' + DateTimeToStr(now) + ' ' + Inttostr(tipe) + ''',' + f);
      Dm_BackRest.Qry.Sql.Add(')');
      Dm_BackRest.Qry.ExecSQL;
      Dm_BackRest.Qry.Sql.Clear;
      Dm_BackRest.Qry.Sql.Add('Insert Into K');
      Dm_BackRest.Qry.Sql.Add('(K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,');
      Dm_BackRest.Qry.Sql.Add(' KSE_DELETE_ID,K_DELETED, KSE_UPDATE_ID, K_UPDATED, KSE_LOCK_ID, KMA_LOCK_ID )');
      Dm_BackRest.Qry.Sql.Add('VALUES (');
      Dm_BackRest.Qry.Sql.Add(ID + ',-101,-11111338,' + IdVersion + ',1,-1,-1,Current_date,0,Current_date,-1,Current_date,0,0 )');
      Dm_BackRest.Qry.ExecSQL;
      IF Dm_BackRest.Qry.Transaction.InTransaction THEN
        Dm_BackRest.Qry.Transaction.commit;
    END
    ELSE
    BEGIN
      AddLog(DateTimeToStr(Now) + ' Modification de l''enregistrement ' + Id);
      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
      Dm_BackRest.Qry.Sql.Clear;
      Dm_BackRest.Qry.Sql.Add('Update GenDossier');
      Dm_BackRest.Qry.Sql.Add('SET DOS_STRING = ''' + DateTimeToStr(now) + ' - ' + Inttostr(tipe) + ''', DOS_FLOAT=' + f);
      Dm_BackRest.Qry.Sql.Add('Where DOS_ID=' + id);
      Dm_BackRest.Qry.ExecSQL;
      Dm_BackRest.Qry.Sql.Clear;
      Dm_BackRest.Qry.Sql.Add('Update K');
      Dm_BackRest.Qry.Sql.Add('SET K_Version = ' + IdVersion);
      Dm_BackRest.Qry.Sql.Add('Where K_ID=' + id);
      Dm_BackRest.Qry.ExecSQL;
      IF Dm_BackRest.Qry.Transaction.InTransaction THEN
        Dm_BackRest.Qry.Transaction.commit;
    END;
    Dm_BackRest.Database.Connected := False;
  EXCEPT
    AddLog(DateTimeToStr(Now) + ' Problème de connexion à la base ');
    Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
  END;
END;

//Procedure TFrm_BackRest.DeleteLogFile(PBase: string; Num: Integer);
//const
//  sFileName : array [1..3] of string = ('Un', 'deux', 'trois');
//var
//  i         : Integer;
//  sFileTmp  : string;
//begin
//  try
//    deletefile(PBase + sFileName[Num] + '.txt');
//    if Fileexists(PBase + sFileName[Num] + '.txt') then
//    begin
//      i := 0;
//      repeat
//        inc(i);
//        sFileTmp := PBase + sFileName[Num] + Inttostr(i) + '.txt';
//        deletefile(sFileTmp);
//      until not Fileexists(sFileTmp);
//      case Num of
//        1 : sUn := sFileTmp;
//      end;
//    end
//    else
//    begin
//      case Num of
//        1 : sUn := PBase + sFileName[Num] + '.txt';
//      end;
//    end;
//  except on e: exception do
//    begin
//      AddLog(DateTimeToStr(Now) + '  exception dans DeleteLogFile() : ' + e.message);
//      Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
//    end;
//  end;
//end;

function TFrm_BackRest.GetValidate(aDataBase: string): Boolean;
  function Add(aDosNom: string; aEtat: Integer):Boolean;
  var
    iId,
    iIdVersion : Integer;
  begin
    try
      try
        Dm_BackRest.Qry.Close;
        Dm_BackRest.Qry.Sql.Clear;
        Dm_BackRest.Qry.Sql.Add('Select NewKey ');
        Dm_BackRest.Qry.Sql.Add('From PROC_NEWKEY');
        Dm_BackRest.Qry.Open;
        iId := Dm_BackRest.Qry.Fields[0].AsInteger;
        iIdVersion := iId;
        Dm_BackRest.Qry.Close;

        Dm_BackRest.Qry.Sql.Clear;
        Dm_BackRest.Qry.Sql.Add('Insert Into GenDossier');
        Dm_BackRest.Qry.Sql.Add('(DOS_ID, DOS_NOM, DOS_FLOAT)');
        Dm_BackRest.Qry.Sql.Add('VALUES (');
        Dm_BackRest.Qry.Sql.Add(IntToStr(iId) + ',''' + aDosNom + ''',' + IntToStr(aEtat));
        Dm_BackRest.Qry.Sql.Add(')');
        Dm_BackRest.Qry.ExecSQL;
        Dm_BackRest.Qry.Sql.Clear;
        Dm_BackRest.Qry.Sql.Add('Insert Into K');
        Dm_BackRest.Qry.Sql.Add('(K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,');
        Dm_BackRest.Qry.Sql.Add(' KSE_DELETE_ID,K_DELETED, KSE_UPDATE_ID, K_UPDATED, KSE_LOCK_ID, KMA_LOCK_ID )');
        Dm_BackRest.Qry.Sql.Add('VALUES (');
        Dm_BackRest.Qry.Sql.Add(IntToStr(iID) + ',-101 ,-11111338,' + IntToStr(iIdVersion) + ',1,-1,-1,Current_date,0,Current_date,-1,Current_date,0,0 )');
        Dm_BackRest.Qry.ExecSQL;
      finally
        Result := True;
        Dm_BackRest.Qry.Close;
      end;
    except on e: exception do
      begin
        AddLog(DateTimeToStr(Now) + '  exception dans GetValidate lors du Add() : ' + e.message);
        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
        Result := False;
      end;
    end;
  end;

  function Get(aDosNom: string):Integer;
  var
    bEmpty  : Boolean;
  begin
    try
      try
        Dm_BackRest.Qry.Close;
        Dm_BackRest.Qry.Sql.Clear;
        Dm_BackRest.Qry.Sql.Add('Select DOS_FLOAT ');
        Dm_BackRest.Qry.Sql.Add('from GenDossier ');
        Dm_BackRest.Qry.Sql.Add('Where DOS_NOM = ''' + aDosNom + '''');
        Dm_BackRest.Qry.Open;
        bEmpty := Dm_BackRest.Qry.IsEmpty;
        if bEmpty then
          Result := -1
        else
          Result := Dm_BackRest.Qry.Fields[0].AsInteger;
      finally
        Dm_BackRest.Qry.Close;
      end;
    except on e: exception do
      begin
        AddLog(DateTimeToStr(Now) + '  exception dans GetValidate lors du Get() : ' + e.message);
        Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
        Result := -1;
      end;
    end;
  end;
var
  iEtat : Integer;
begin
  try
    try
      Dm_BackRest.Database.Connected := false;
      Dm_BackRest.Database.DatabaseName := aDataBase;

      iEtat := Get('BackRest - Validate');
      if (iEtat = -1) then
      begin
        AddLog(DateTimeToStr(Now) + '  Paramètre Validate non trouvé dans GENDOSSIER. Validate par défaut.');
        // Add('BackRest - Validate', 1);         Peut doublonner par replic
        Result := True;
      end
      else
      begin
        if iEtat = 0 then
        begin
          AddLog(DateTimeToStr(Now) + '  Validate non demandé en fin de restore');
          Result := False;
        end
        else
        begin
          AddLog(DateTimeToStr(Now) + '  Validate demandé en fin de restore');
          Result := True;
        end;
      end;
    finally
      Dm_BackRest.Qry.Close;
    end;
  except on e: exception do
    begin
      AddLog(DateTimeToStr(Now) + '  exception dans GetValidate : ' + e.message);
      Result := False;
    end;
  end;

  Log.SaveToFile(sPathDirData + 'BackupRestor.Log');
end;

function TFrm_BackRest.isEasy: boolean;
begin
  result := false;
  Dm_BackRest.Qry.Close;
  try
    Dm_BackRest.Qry.SQL.Clear;
    Dm_BackRest.Qry.SQL.Text := 'select prm_string from genparam where prm_code=1 and prm_type=80';
    Dm_BackRest.Qry.Open;
    if Dm_BackRest.Qry.RecordCount > 0 then
      result := (Dm_BackRest.Qry.FieldByName('prm_string').AsString <> '');
  finally
    Dm_BackRest.Qry.Close;
    if result
      then AddLogDBG(DateTimeToStr(Now) + 'Réplic EASY')
      else AddLogDBG(DateTimeToStr(Now) + 'Réplic NORMAL');
  end;
end;

//FUNCTION TFrm_Sauve.GetProcessId(ProgName: STRING): cardinal;
//VAR
//  Snaph: thandle;
//  Proc: Tprocessentry32;
//  PId: cardinal;
//BEGIN
//  PId := 0;
//  Proc.dwSize := sizeof(Proc);
//  Snaph := createtoolhelp32snapshot(TH32CS_SNAPALL, 0); //recupere un capture de process
//  process32first(Snaph, Proc); //premeir process de la list
//  IF Uppercase(extractfilename(Proc.szExeFile)) = Uppercase(ProgName) THEN //test pour savoir si le process correspond
//    PId := Proc.th32ProcessID // recupere l'id du process
//  ELSE
//  BEGIN
//    WHILE process32next(Snaph, Proc) DO //dans le cas contraire du test on continue à cherche le process en question
//    BEGIN
//      IF extractfilename(Proc.szExeFile) = ProgName THEN
//        PId := Proc.th32ProcessID;
//    END;
//  END;
//  Closehandle(Snaph);
//  result := PId;
//END;

PROCEDURE TFrm_BackRest.ClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; VAR ErrorCode: Integer);
BEGIN
  Encours := -99;
  ErrorCode := 0
END;

PROCEDURE TFrm_BackRest.ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
BEGIN
  encours := 1;
END;

procedure TFrm_BackRest.ClientRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  if Socket.ReceiveText = 'OK' then
    inc(encours)
  else
    encours := -Encours;
end;

PROCEDURE TFrm_BackRest.ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
BEGIN
  encours := -1;
END;

function TFrm_BackRest.copyFichier(strSource, strDestination: string; trials: Integer): Boolean;
var
  i           : Integer;
  FileCtrl    : TLMDFileCtrl;
begin
  //lab effectue une copie d'un fichier
  //Recommence trials fois si la copie n'est pas bonne
  //retourne true si ok

  //initialisation pessismiste du retour
  Result := False;
  //initialiser le compteur de tentatives
  i := 0;
  try
    if FileExists(strDestination) then
    begin
      if not DeleteFile(strDestination) then
        AddLog(DateTimeToStr(Now) + '  # Erreur :  échec de la suppression du fichier [' + strDestination + ']: ' + SysErrorMessage(GetLastError));
    end;
    FileCtrl := TLMDFileCtrl.Create(Application);
    try
      FileCtrl.Options := [ffFilesOnly, ffNoActionConfirm, ffNoMKDIRConfirm];
      //créer le répertoire s'il n'existe pas
      ForceDirectories(ExtractFilePath(strDestination));
      screen.Cursor := crHourGlass;
      //répéter la copie jusqu'à ce que le fichier copié soit valable ou que le nombre de tentatives max soit atteint
      repeat
        //incrémenter le compteur
        inc(i);
        if FileCtrl.CopyFiles(strSource, strDestination) then
        begin
          Result := True;
        end;
      until ((Result = True) or (i = trials));
    finally
      screen.Cursor := crDefault;
      FreeAndNil(Filectrl);
    end;
  except on e: Exception do
    begin
      screen.Cursor := crDefault;
      Result := False;
    end;
  end;
end;

//FUNCTION TFrm_Sauve.executerProcess(cmdLine: STRING; timeout: integer; exeName: STRING): boolean;
//VAR
//  StartInfo: TStartupInfo;
//  ProcessInfo: TProcessInformation;
//  fin: Boolean;
//  retour: Boolean;
//  Proch: thandle;
//  PId: cardinal;
//BEGIN
//  //fonction qui crée un process cmdline et attends sa fin ou celle du timeout pour rend la main et signaler le résultat
//  //renvoi true si fini ok ou false si fini car timeout
//  //timeout -1 signifie que l'on n'attends pas la fin de l'execution du process, mais seulement la fin de sa création
//      { Mise à zéro de la structure StartInfo }
//  FillChar(StartInfo, SizeOf(StartInfo), #0);
//  { Seule la taille est renseignée, toutes les autres options }
//  { laissées à zéro prendront les valeurs par défaut }
//  StartInfo.cb := SizeOf(StartInfo);
//  retour := true;
//  { Lancement de la ligne de commande }
//  IF CreateProcess(NIL, Pchar(cmdLine), NIL, NIL, False,
//    0, NIL, NIL, StartInfo, ProcessInfo) THEN
//  BEGIN
//    { L'application est bien lancée, on va en attendre la fin }
//    { ProcessInfo.hProcess contient le handle du process principal de l'application }
//    IF timeout <> -1 THEN
//    BEGIN
//      REPEAT
//        Fin := False;
//        Application.ProcessMessages;
//        CASE WaitForSingleObject(ProcessInfo.hProcess, timeout) OF
//          WAIT_OBJECT_0: Fin := True;
//          WAIT_TIMEOUT: //si le temps est expiré, tuer l'exe et cmd pour éviter des problèmes ensuite ( backup et restore après)
//            BEGIN
//              retour := false;
//              Fin := True;
//              Pid := GetProcessId(exeName);
//              Proch := openprocess(PROCESS_ALL_ACCESS, true, PId); //handle du process
//              IF terminateprocess(Proch, 0) THEN
//              BEGIN
//                retour := true;
//              END;
//              IF terminateprocess(ProcessInfo.hProcess, 0) THEN
//              BEGIN
//                retour := true;
//              END;
//              Closehandle(Proch);
//            END;
//        END;
//      UNTIL fin;
//    END;
//  END;
//  result := retour;
//END;

INITIALIZATION
  ArretLaunch := False;
  ArretSyncWeb := False;
END.

