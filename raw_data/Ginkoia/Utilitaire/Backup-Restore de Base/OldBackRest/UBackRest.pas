UNIT UBackRest;

INTERFACE

USES
  WinSvc,
  UMapping,
  inifiles,
  registry,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  IBSQL,
  Db,
  IBCustomDataSet,
  IBQuery,
  IBDatabase,
  ExtCtrls,
  ScktComp,
  LMDCustomComponent,
  LMDFileCtrl,
  UCrc,
  FileCtrl,
  IBServices,
  //début uses perso
  ShellAPI,
  Tlhelp32,
  UTools,
  UVersion,
  // fin uses perso
  LMDOneInstance,
  LMDIniCtrl,
  IBDatabaseInfo;

TYPE
  TFrm_Sauve = CLASS(TForm)
    Button1: TButton;
    Database: TIBDatabase;
    Qry: TIBQuery;
    tran: TIBTransaction;
    qry_tables: TIBQuery;
    Timer1: TTimer;
    lab: TLabel;
    Button2: TButton;
    Ib_LesBases: TIBQuery;
    Ib_LesBasesREP_PLACEEAI: TIBStringField;
    Ib_LesBasesREP_PLACEBASE: TIBStringField;
    FileCtrl_Ini: TLMDFileCtrl;
    Que_ParamSynchro: TIBQuery;
    Que_ParamSynchroPRM_STRING: TIBStringField;
    Que_ParamSynchroPRM_INTEGER: TIntegerField;
    Que_ParamSynchroPRM_ID: TIntegerField;
    Que_ParamSynchroPRM_FLOAT: TFloatField;
    Que_BasesSynchro: TIBQuery;
    Que_BasesSynchroBAS_NOM: TIBStringField;
    Que_BasesSynchroPRM_STRING: TIBStringField;
    LMDOneInstance: TLMDOneInstance;
    IBCS_StartBase: TIBConfigService;
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Button1Click(Sender: TObject);
    PROCEDURE Timer1Timer(Sender: TObject);
    PROCEDURE FormPaint(Sender: TObject);
    PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
  PRIVATE
    { Déclarations privées }
    ServiceRepl: Boolean;
    ServiceDist: boolean;
    iniTimeout: Integer;
    iniAnalyser: boolean;
    PROCEDURE StopService; // Stop le service de réplication Shadow
    PROCEDURE StartService; // Start le service de réplication Shadow

    PROCEDURE Attente_IB;

    //lab effectue une copie d'un fichier et le vérife
    //Recommence x fois (Trials) si la copie n'est pas bonne
    //retourne vrai si la copie est bonne
    FUNCTION copyFichier(strSource, strDestination: STRING; trials: Integer): Boolean;
    PROCEDURE analyserBase(PDataBase: STRING);
    FUNCTION executerProcess(cmdLine: STRING; timeout: integer; exeName: STRING): boolean;
    FUNCTION GetProcessId(ProgName: STRING): cardinal;

    PROCEDURE LogAjoute(ALogMess : string);

  PUBLIC
    { Déclarations publiques }
    EnCours: Integer;
    Labase0: STRING;
    PathBorlBin: STRING;
    PathBase: STRING; // Dossier data qui contient les bases
    PathDataBase: STRING; // Chemin vers la base de donnée (Base0)
    Pathexe: STRING;
    NbBckup: Integer;
    TailleBaseMoy: Integer;
    TmpsMoy: Integer;
    TpsDem: DWord;
    taille: integer;
    Log: TStringList;

    FaireGenerateur: Boolean;
    Un, Deux, trois: STRING;

    First: Boolean;
    NewBase: Boolean;

    Interbase7: Boolean;
    //    WindowsXP: Boolean;
    FUNCTION MarqueLesTables(PDataBase: STRING): Boolean;
    PROCEDURE ArretBase(Pbase, base: STRING);
    FUNCTION Backup(PBase, PDataBase: STRING): Boolean;
    FUNCTION RenomeBase(PDataBase, Shadow: STRING): Boolean;

    FUNCTION Restore(Pbase, base: STRING): boolean;
    PROCEDURE DemareBase(Pbase, base: STRING);
    FUNCTION VerifBase(base: STRING): Boolean;

    PROCEDURE ValideNvBck(PathBase: STRING; PathEai: STRING; PathDataBase, Shadow: STRING);
    //PROCEDURE recupAncBase(Pbase, PDataBase, Shadow: STRING);

    FUNCTION run: Boolean;
    FUNCTION NouvelleSauvegarde(PBase: STRING): STRING;

    // 0 : Pas de problème
    // 1 : Pas de renomme
    // 2 : restore ok mais base mauvaise
    // 3 : Pas de restore
    // 4 : Pas de backup
    // 5 : Pas la place
    PROCEDURE marqueBase(OK: Boolean; tipe: Integer; PDataBase: STRING);

    PROCEDURE DeleteUn(PBase: STRING);
    PROCEDURE DeleteDeux(PBase: STRING);
    PROCEDURE DeleteTrois(PBase: STRING);
  END;

FUNCTION KillProcess(CONST ProcessName: STRING): boolean;
PROCEDURE PauseEnSec(aTps: DWORD = 5);
PROCEDURE Pause(aTps: DWORD = 5000);

VAR
  Frm_Sauve: TFrm_Sauve;

IMPLEMENTATION

USES uProcessUtils;
{$R *.DFM}

CONST
  ginkoia = 'ginkoia.exe';
  Caisse = 'CaisseGinkoia.exe';
  Script = 'Script.exe';
  PICCO = 'Piccolink.exe';
  LauncherV7 = 'LaunchV7.exe';
  SyncWeb = 'SyncWeb.exe';
  //  ibGuard     = 'ibguard.exe';  // Pour plus tard
  //  ibServer    = 'ibserver.exe';
  ibScheduler = 'ibscheduler.exe'; // Srv Sec

VAR
  Lapplication: STRING;
  ArretLaunch: Boolean;
  ArretSyncWeb: Boolean;

PROCEDURE PauseEnSec(aTps: DWORD = 5);
BEGIN
  Pause(ATps * 1000);
END;

PROCEDURE Pause(aTps: DWORD = 5000);
VAR
  dDelai: DWORD;
  dPasse: DWORD;
BEGIN
  dDelai := GetTickCount;
  WHILE GetTickCount - dDelai < aTps DO // 5sec et...
  BEGIN
    dPasse := GetTickCount - dDelai;
    IF (dPasse MOD 300) = 0 THEN
      Application.ProcessMessages;
  END;
END;

FUNCTION KillProcess(CONST ProcessName: STRING): boolean;
VAR
  ProcessEntry32: TProcessEntry32;
  HSnapShot: THandle;
  HProcess: THandle;
BEGIN
  Result := False;

  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  IF HSnapShot = 0 THEN exit;

  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  IF Process32First(HSnapShot, ProcessEntry32) THEN
    REPEAT
      IF CompareText(ProcessEntry32.szExeFile, ProcessName) = 0 THEN
      BEGIN
        HProcess := OpenProcess(PROCESS_TERMINATE, False, ProcessEntry32.th32ProcessID);
        IF HProcess <> 0 THEN
        BEGIN
          IF ProcessName = LauncherV7 THEN
          BEGIN
            ArretLaunch := True;
          END
          ELSE BEGIN
            IF ProcessName = SyncWeb THEN
            BEGIN
              ArretSyncWeb := True;
            END;
          END;

          Result := TerminateProcess(HProcess, 0);
          CloseHandle(HProcess);
        END;
        Break;
      END;
    UNTIL NOT Process32Next(HSnapShot, ProcessEntry32);

  CloseHandle(HSnapshot);
END;

FUNCTION PlaceDeInterbase: STRING;
VAR
  Reg: Tregistry;
BEGIN
  reg := Tregistry.Create;
  TRY
    reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
    IF trim(result) = '' THEN
    BEGIN
      Reg.OpenKey('\Software\Borland\Interbase\Servers\gds_db', False);
      result := Reg.ReadString('ServerDirectory');
    END;
    result := IncludeTrailingPathDelimiter(Reg.ReadString('ServerDirectory'));
  FINALLY
    reg.free;
  END;
END;

PROCEDURE TFrm_Sauve.StartService;
VAR
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  tempMini: DWORD;
  CheckPoint: DWORD;
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
      LogAjoute('StartService()       Exception : ' + E.Message);
    END;         

  END;
END;

// Stop le service de réplication Shadow

PROCEDURE TFrm_Sauve.StopService;
VAR
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  tempMini: DWORD;
  CheckPoint: DWORD;
BEGIN
  TRY
    IF NOT Interbase7 THEN EXIT;
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
  EXCEPT ON E: Exception DO
    BEGIN
      LogAjoute('StopService()        Exception : ' + E.Message);
    END;         

  END;
END;

PROCEDURE TFrm_Sauve.FormClose(Sender: TObject; VAR Action: TCloseAction);
BEGIN
  TRY
    uProcessUtils.ProcessStart('wuauserv');

    IF Log <> NIL THEN
    BEGIN
      LogAjoute('-----------------------------------------------------------------');
      FreeAndNil(Log);
    END;
  FINALLY

  END;
END;

PROCEDURE TFrm_Sauve.FormCreate(Sender: TObject);
VAR
  Ini: TIniFile;
  reg: TRegistry;
  S: STRING;
BEGIN
  Log := TstringList.Create;

  PathBorlBin := PlaceDeInterbase;
  First := true;
  reg := Tregistry.Create;
  TRY
    reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
    S := Reg.ReadString('Version');
    IF s = '' THEN
    BEGIN
      Reg.OpenKey('\Software\Borland\Interbase\Servers', False);
      S := Reg.ReadString('Version');
    END;
    IF s = '' THEN
    BEGIN
      Reg.OpenKey('\Software\Borland\Interbase\Servers\gds_db', False);
      S := Reg.ReadString('Version');
    END;
  FINALLY
    reg.free;
  END;
  Interbase7 := ((Copy(S, 1, 5) = 'WI-V7') OR (Copy(S, 1, 6) = 'WI-V10'));

  reg := TRegistry.Create(KEY_READ);
  TRY
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('Software\Algol\Ginkoia', False);
    Labase0 := reg.ReadString('Base0');
  FINALLY
    reg.free;
  END;

  Pathexe := '';
  IF Labase0 <> '' THEN
  BEGIN
    PathExe := ExtractFileDrive(Labase0);
    IF fileexists(PathExe + '\Ginkoia\Ginkoia.exe') THEN
      PathExe := PathExe + '\Ginkoia\Ginkoia.exe';
  END;

  IF PathExe = '' THEN
  BEGIN
    IF fileexists('C:\Ginkoia\Ginkoia.exe') THEN
      PathExe := 'C:\Ginkoia\Ginkoia.exe'
    ELSE IF fileexists('D:\Ginkoia\Ginkoia.exe') THEN
      PathExe := 'D:\Ginkoia\Ginkoia.exe';
  END;

  IF Labase0 <> '' THEN
  BEGIN
    PathDataBase := Labase0;
    NewBase := true;
  END
  ELSE
  BEGIN
    NewBase := False;
    ini := tinifile.create(Pathexe + 'Ginkoia.Ini');
    //ini := tinifile.create(ExtractFilePath(Pathexe) + 'Ginkoia.Ini'); //lab correction
    TRY
      PathDataBase := ini.readString('DATABASE', 'PATH0', '');
      IF Copy(PathDataBase, 2, 1) <> ':' THEN
        PathDataBase := ini.readString('DATABASE', 'PATH1', '');
      IF Copy(PathDataBase, 2, 1) <> ':' THEN
        PathDataBase := ini.readString('DATABASE', 'PATH2', '');
      IF Copy(PathDataBase, 2, 1) <> ':' THEN
        PathDataBase := ini.readString('DATABASE', 'PATH3', '');
    FINALLY
      ini.free;
    END;
  END;

  PathBase := IncludeTrailingBackslash(ExtractFilePath(PathDataBase));

  // Init du log
  TRY
    IF FileExists(PathBase + 'BackupRestor.Log') THEN
      Log.LoadFromFile(PathBase + 'BackupRestor.Log');
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('FormCreate()         Exception récup du fichier : ' + E.message);
    END;
  END;

  WHILE Log.Count > 500 DO // Augmente le nombre d'historique de log
  begin
    Log.Delete(0);
  end;

  LogAjoute('-----------------------------------------------------------------');
  LogAjoute('Version de Backrest : ' + Version);    //SR - 02072012 - Ajout de la version dans le log

  Database.DatabaseName := PathDataBase;

  Ini := TIniFile.Create(changefileext(application.exename, '.ini'));
  TRY
    NbBckup := ini.readinteger('TPS', 'NB', 0);
    TailleBaseMoy := ini.readinteger('TPS', 'TB', 0);
    TmpsMoy := ini.readinteger('TPS', 'TPS', 0);
  FINALLY
    ini.free;
  END;
             
  LogAjoute('FormCreate()         Début arrêt mise à jour windows.');
  uProcessUtils.ProcessStop('wuauserv');
  LogAjoute('FormCreate()         Fin arrêt mise à jour windows.');
END;

FUNCTION TFrm_Sauve.MarqueLesTables(PDataBase: STRING): Boolean;
VAR
  S: STRING;
  li: Integer;
BEGIN
  TRY
    DataBase.Close;
    DataBase.DataBaseName := PDataBase;
    DataBase.Open;
    Tran.active := true;
    result := true;

    //lab rollback des transactions au cas ou un poste distant accède à tmpstat
    executerProcess('cmd "' + PathBorlBin + 'gfix.exe" -rollback all "' + PDataBase + '" -user sysdba -password masterkey ', 10000, 'gfix.exe');
               
    LogAjoute('MarqueLesTables()    DELETE FROM TMPSTAT');
    TRY
      qry.SQL.clear;
      qry.SQL.Add('DELETE FROM TMPSTAT');
      qry.ExecSQL;
      qry_tables.Open;
      qry_tables.first;
      li := 0;
      WHILE NOT qry_tables.eof DO
      BEGIN
        qry.SQL.text := 'Select count(*) from ' + qry_tables.Fields[0].AsString;
        Qry.Open;
        S := Qry.Fields[0].AsString;
        Qry.Close;
        Qry.SQL.text := 'Insert into TMPSTAT (TMP_ID, TMP_ARTID, TMP_MAGID) Values (0,' + s + ',' + Inttostr(Li) + ') ';
        inc(li);
        Qry.execSql;
        qry_tables.next;
      END;
      qry_tables.Close;
    EXCEPT ON E: Exception DO
      BEGIN
        LogAjoute('MarqueLesTables()    Exception 1:' + E.Message);
        result := false;
      END;
    END;
    TRY
      LogAjoute('MarqueLesTables()    Déconnection de la base');
      qry_tables.Close;
      database.Connected := false;
    EXCEPT ON E: Exception DO
      BEGIN
        LogAjoute('MarqueLesTables()    Exception 2:' + E.Message);
        result := false;
      END;
    END;
    IF result THEN
    BEGIN
      LogAjoute('MarqueLesTables()    Marquage des tables OK');
    END
    ELSE
    BEGIN
      LogAjoute('MarqueLesTables()    Marquage des tables Erreur');
    END;
  EXCEPT ON E: Exception DO
    BEGIN
      LogAjoute('MarqueLesTables()    Exception : ' + E.Message);
    END;
  END;
END;

FUNCTION TFrm_Sauve.NouvelleSauvegarde(PBase: STRING): STRING;
VAR
  dtOldDir: TDateTime;
  sOldDir: STRING;
  i: Integer;

  PROCEDURE NetoyerZip(sDir: STRING); //Afin de netoyer l'ancien système
  BEGIN
    TRY
      deletefile(PBase + 'Sauve1.zip');
      deletefile(PBase + 'Sauve2.zip');
      deletefile(PBase + 'Sauve3.zip');
      deletefile(PBase + 'Sauve4.zip');
    EXCEPT ON e: exception DO
      BEGIN
        LogAjoute('NetoyerZip()         Exception : Erreur lors de la suppression des Zip.');
        result := '';
      END;
    END;
  END;

  FUNCTION GetDirDate(sDir: STRING): TDateTime;
  VAR
    Rec: TSearchRec;
    Found: Integer;
    Date: TDateTime;
  BEGIN
    IF sDir[Length(sDir)] = '\' THEN
      Delete(sDir, Length(sDir), 1);
    Result := 0;
    Found := FindFirst(sDir, faDirectory, Rec);
    TRY
      IF Found = 0 THEN
      BEGIN
        Date := FileDateToDateTime(Rec.Time);
        Result := Date;
      END;
    FINALLY
      FindClose(Rec);
    END;
  END;

  FUNCTION DelDir(sDir: STRING): Boolean;
  VAR
    iIndex: Integer;
    SearchRec: TSearchRec;
    sFileName: STRING;
  BEGIN
    //Result := False;
    sDir := sDir + '*.*';
    iIndex := FindFirst(sDir, faAnyFile, SearchRec);
    WHILE iIndex = 0 DO
    BEGIN
      sFileName := ExtractFileDir(sDir) + '\' + SearchRec.Name;
      IF SearchRec.Attr = faDirectory THEN
      BEGIN
        IF (SearchRec.Name <> '') AND (SearchRec.Name <> '.') AND (SearchRec.Name <> '..') THEN
          DelDir(sFileName);
      END
      ELSE
      BEGIN
        IF SearchRec.Attr <> 32 THEN
          FileSetAttr(sFileName, 32);
        DeleteFile(sFileName);
      END;
      iIndex := FindNext(SearchRec);
    END;
    FindClose(SearchRec);
    RemoveDir(ExtractFileDir(sDir));
    Result := True;
  END;
BEGIN
  TRY
    TRY
      result := '';
      IF NOT DirectoryExists(PBase + 'Save1') THEN
      BEGIN
        CreateDir(PBase + 'Save1');
        result := PBase + 'Save1\';
      END
      ELSE
      BEGIN
        IF NOT DirectoryExists(PBase + 'Save2') THEN
        BEGIN
          CreateDir(PBase + 'Save2');
          result := PBase + 'Save2\';
        END
        ELSE
        BEGIN
          IF NOT DirectoryExists(PBase + 'Save3') THEN
          BEGIN
            CreateDir(PBase + 'Save3');
            result := PBase + 'Save3\';
          END
          ELSE
          BEGIN
            IF NOT DirectoryExists(PBase + 'Save4') THEN
            BEGIN
              CreateDir(PBase + 'Save4');
              result := PBase + 'Save4\';
              NetoyerZip(PBase);
            END
            ELSE
            BEGIN
              dtOldDir := GetDirDate(PBase + 'Save1\');
              sOldDir := PBase + 'Save1\';
              i := 2;
              WHILE (i <= 4) DO
              BEGIN
                IF (dtOldDir > GetDirDate(PBase + 'Save' + IntToStr(i) + '\')) THEN
                BEGIN
                  dtOldDir := GetDirDate(PBase + 'Save' + IntToStr(i) + '\');
                  sOldDir := PBase + 'Save' + IntToStr(i) + '\';
                END;
                inc(i);
              END;

              DelDir(sOldDir);
              Pause;
              CreateDir(sOldDir);
              Pause;
              result := sOldDir;
            END;
          END;
        END;
      END;
    FINALLY
      LogAjoute('NouvelleSauvegarde() Récupération du chemin de la sauvegarde.');
    END;
  EXCEPT ON e: exception DO
    BEGIN
      LogAjoute('NouvelleSauvegarde() Exception : ' + e.message);
      result := '';
    END;
  END;
END;

FUNCTION TFrm_Sauve.Backup(PBase, PDataBase: STRING): Boolean;
VAR
  tsl: tstringlist;
  i: integer;
  debut: TDateTime;
BEGIN
  IF fileexists(PDataBase) THEN
  BEGIN
    TRY
      deletefile(PBase + 'SV.gbk');
      tsl := tstringlist.Create;
      TRY
        deletedeux(Pbase);
        deleteun(Pbase);
        deletetrois(Pbase);
        tsl.add('"' + PathBorlBin + 'gbak.exe " "' + PDataBase + '" "' + PBase + 'SV.GBK" -user sysdba -password masterkey -B -L -NT -Y "' + un + '"');
        tsl.add('Copy "' + un + '" "' + trois + '"');
        tsl.add('exit');
        tsl.SaveToFile(PBase + 'GO.BAT');

        IF Winexec(Pchar(PBase + 'GO.BAT'), 0) <= 31 THEN
        BEGIN
          result := false;
          exit;
        END;
        FOR i := 1 TO 30 DO
        BEGIN
          application.processmessages;
          sleep(100);
        END;
        debut := Now;
        WHILE NOT fileexists(trois) DO
        BEGIN
          application.processmessages;
          sleep(100);
          IF Now - debut > 0.1 THEN
          BEGIN
            result := False;
            Exit;
          END;
        END;

        FOR i := 1 TO 25 DO
        BEGIN
          application.processmessages;
          sleep(100);
        END;

        tsl.loadfromfile(trois);
        IF tsl.count > 1 THEN
        BEGIN
          result := false;
        END
        ELSE
        BEGIN
          result := true;
        END;

      FINALLY
        tsl.free;
      END;
    EXCEPT ON E: exception DO
      BEGIN
        LogAjoute('Backup()             Exception : ' + E.message);
        result := false;
      END;
    END
  END
  ELSE
  BEGIN
    result := false;
  END;
END;

PROCEDURE TFrm_Sauve.analyserBase(PDataBase: STRING);
VAR
  cmdLine: STRING;
  sFileName: STRING;
  sDirName: STRING;
BEGIN
  try
    //lancer quelques analyses sur la base grace notamment à Gstat
    //elles seront stockées dans un répertoire StatBase, un fichier par exécution du back up.
    //Le fichier doit être créé avant l'exécution de Gstat.exe sinon il ne sauve rien
    sDirName := IncludeTrailingBackslash(ExtractFilePath(PDataBase)) + 'StatBase\';
    ForceDirectories(sDirName);
    //créer le nom du ficher de destination de la stat
    sFileName := sDirName + 'STAT_' + FormatDAteTime('MM_DD__HH''H''MM', now) + '.txt';
    //créer le ficher
    WITH TStringList.create DO
    TRY
      SaveToFile(sFilename);
    FINALLY
      Free;
    END;
    //création la ligne de commande
    cmdLine := 'cmd /K ""' + IncludeTrailingBackslash(PathBorlBin) + 'gstat.exe" -u SYSDBA -p masterkey "' + PdataBase + '" >"' + sfilename + '""';
    //lancer l'execution avec timeout à 60 secondes
    executerProcess(cmdLine, iniTimeOut, 'gstat.exe');
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('AnalyserBase()       Exception : ' + E.message);
    END;
  END
END;

PROCEDURE TFrm_Sauve.ArretBase(Pbase, base: STRING);
VAR
  tsl: tstringlist;
  i: integer;
  debut: TDateTime;
BEGIN
  TRY
    tsl := tstringlist.Create;
    TRY
      deletedeux(Pbase);
      deleteun(Pbase);
      tsl.add('"' + PathBorlBin + 'gfix.exe" -rollback all "' + Base + '" -user sysdba -password masterkey ');
      tsl.add('"' + PathBorlBin + 'gfix.exe" -shut -force 0 -user sysdba -password masterkey "' + Base + '" ');
      tsl.add('Dir c:\*.* > "' + un + '"');
      tsl.add('exit ');
      tsl.savetofile(PBase + 'GO.bat');
      IF Winexec(Pchar(PBase + 'GO.BAT'), 0) <= 31 THEN
      BEGIN
        exit;
      END;
      FOR i := 1 TO 30 DO
      BEGIN
        application.processmessages;
        sleep(100);
      END;
      debut := now;
      WHILE NOT fileexists(Un) DO
      BEGIN
        IF (Now - debut) > 0.2 THEN
        BEGIN
          Exit;
        END;
        application.processmessages;
        sleep(100);
      END;

      FOR i := 1 TO 30 DO
      BEGIN
        application.processmessages;
        sleep(1000);
      END;
    FINALLY
      tsl.free;
    END;
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('ArretBase()          Exception : ' + E.message);
    END;
  END;
END;

FUNCTION TFrm_Sauve.RenomeBase(PDataBase, Shadow: STRING): Boolean;
BEGIN
  TRY
    IF fileexists(PDataBase) THEN
    BEGIN
      deletefile(ChangeFileExt(PDataBase, '.toto'));
      result := renamefile(PDataBase, ChangeFileExt(PDataBase, '.toto'));
      IF shadow <> '' THEN
      BEGIN
        IF fileexists(Shadow) THEN
        BEGIN
          deletefile(ChangeFileExt(Shadow, '.toto'));
          result := renamefile(Shadow, ChangeFileExt(Shadow, '.toto'));
        END
        ELSE
          result := false;
      END;
    END
    ELSE
      result := false;
  EXCEPT ON E: exception DO
    BEGIN        
      LogAjoute('RenomeBase()         Exception : ' + E.message);
      result := false;
    END;
  END;
END;

FUNCTION TFrm_Sauve.Restore(Pbase, base: STRING): boolean;
VAR
  tsl: tstringList;
  i: integer;
  debut: TDateTime;
BEGIN
  TRY
    tsl := tstringList.create;
    TRY
      deletetrois(Pbase);
      deletedeux(Pbase);
      deleteun(Pbase);

      tsl.Add('"' + PathBorlBin + 'gbak.exe " "' + PBase + 'SV.GBK" "' + Base +
        '" -user sysdba -password masterkey -C -O -BU 4096 -P 4096 -Y "' + Un + '"'
        );
      tsl.Add('Copy "' + Un + '" "' + trois + '"');
      tsl.Add('exit');
      tsl.savetofile(PBase + 'GO.BAT');
      IF Winexec(Pchar(PBase + 'GO.BAT'), 0) <= 31 THEN
      BEGIN
        result := false;
        exit;
      END;
      FOR i := 1 TO 25 DO
      BEGIN
        application.processmessages;
        sleep(100);
      END;
      debut := now;
      WHILE NOT fileexists(trois) DO
      BEGIN
        IF Now - debut > 0.1 THEN
        BEGIN
          result := False;
          Exit;
        END;
        application.processmessages;
        sleep(100);
      END;
      FOR i := 1 TO 25 DO
      BEGIN
        application.processmessages;
        sleep(100);
      END;
      tsl.loadfromfile(trois);
      WHILE tsl.count > 0 DO
      BEGIN
        IF trim(tsl[0]) = '' THEN
          tsl.delete(0)
        ELSE IF copy(tsl[0], 1, 14) = 'gbak: WARNING:' THEN
          tsl.delete(0)
        ELSE
          BREAK;
      END;
      IF tsl.count > 1 THEN
        result := false
      ELSE
        result := true;
    FINALLY
      tsl.free;
    END;
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('Restore()            Exception : ' + E.message);
      result := false;
    END;
  END;
END;

PROCEDURE TFrm_Sauve.DemareBase(Pbase, Base: STRING);
VAR
  reg: tregistry;
  hToken, hProcess: THandle;
  tp, prev_tp: TTokenPrivileges;
  Len: DWORD;
BEGIN

  // Relancer Interbase
  LogAjoute('DemareBase()         Début du DataBase.ForceClose.');
  DataBase.ForceClose;
  LogAjoute('DemareBase()         Fin du DataBase.ForceClose.');
  LogAjoute('DemareBase()         Début du UTools.ShutDownInterbase.');
  UTools.ShutDownInterbase;
  LogAjoute('DemareBase()         Fin du UTools.ShutDownInterbase.');
  LogAjoute('DemareBase()         Début du UTools.StartInterbase.');
  UTools.StartInterbase;
  LogAjoute('DemareBase()         Fin du UTools.StartInterbase.');

  PauseEnSec(10);

  TRY
    TRY
      TRY
        LogAjoute('DemareBase()         Début.');
      EXCEPT
      END;

      IBCS_StartBase.DataBaseName := Base;
      TRY
        LogAjoute('DemareBase()         Début de l''activation du composant StartBase.');
        IBCS_StartBase.Active := true;
        LogAjoute('DemareBase()         Fin de l''activation du composant StartBase.');

        PauseEnSec(1);

        LogAjoute('DemareBase()         Début du Online de la base.');
        IBCS_StartBase.BringDatabaseOnline;
        LogAjoute('DemareBase()         Fin du Online de la base.');
      EXCEPT
        ON E: Exception DO
        BEGIN        
          LogAjoute('DemareBase()         Exception : ' + E.Message);
          IF (paramCount > 0) AND (paramstr(1) = 'RECUP') THEN
          BEGIN
            LogAjoute('DemareBase()         Démarrage échoué en mode RECUP');
            Application.messagebox('Probleme important sur votre base, appeler la sociétée GINKOIA', ' Probleme', MB_OK);
            Application.Terminate;
          END
          ELSE BEGIN
            LogAjoute('DemareBase()         Obligation de rebooter le serveur ');
            reg := tregistry.Create(KEY_ALL_ACCESS);
            reg.RootKey := HKEY_LOCAL_MACHINE;
            reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce', true);
            reg.WriteString('BACKUP', Application.exename + ' RECUP');
            reg.free;

            hProcess := OpenProcess(PROCESS_ALL_ACCESS, True, GetCurrentProcessID);
            IF OpenProcessToken(hProcess, TOKEN_ADJUST_PRIVILEGES OR TOKEN_QUERY, hToken) THEN
            BEGIN
              CloseHandle(hProcess);
              IF LookupPrivilegeValue('', 'SeShutdownPrivilege', tp.Privileges[0].Luid) THEN
              BEGIN
                tp.PrivilegeCount := 1;
                tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
                IF AdjustTokenPrivileges(hToken, False, tp, SizeOf(prev_tp), prev_tp, Len) THEN
                BEGIN
                  CloseHandle(hToken);

                  ExitWindowsEx(EWX_FORCE OR EWX_REBOOT, 0);

                  Lab.Caption := 'Redémarrage du serveur en cours...';
                  PauseEnSec(5);

                  Application.Terminate;
                END;
              END;
            END;
          END;
        END;
      END;
      PauseEnSec(5);
      LogAjoute('DemareBase()         Terminé.');
    FINALLY
      IBCS_StartBase.Active := False;
    END;

    PauseEnSec(10);
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('DemareBase()         Exception : ' + E.message);
    END;
  END;
END;

FUNCTION TFrm_Sauve.VerifBase(Base: STRING): Boolean;
VAR
  li, lli: Integer;
BEGIN
  result := true;
  TRY
    database.Close;
    database.DatabaseName := Base;
    qry_tables.open;
    qry_tables.first;
    li := 0;
    WHILE NOT qry_tables.eof DO
    BEGIN
      Qry.sql.text := 'Select count(*) from ' + qry_tables.Fields[0].AsString;
      Qry.Open;
      lli := Qry.Fields[0].AsInteger;
      Qry.Close;
      Qry.sql.text := 'Select TMP_ARTID from TMPSTAT WHERE TMP_ID=0 and TMP_MAGID=' + Inttostr(li);
      Qry.Open;
      IF lli <> Qry.fields[0].AsInteger THEN
      BEGIN
        LogAjoute('VerifBase()          Table ' + qry_tables.Fields[0].AsString + ' Diff ');
        database.Connected := false;
        result := false;
        Break;
      END;
      Qry.Close;
      inc(li);
      qry_tables.next;
    END;
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('VerifBase()          Exception1 : ' + E.message);
      result := false;
    END;
  END;
  TRY
    database.Close;
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('VerifBase()          Exception2 : ' + E.message);
    END;
  END;
END;

//PROCEDURE TFrm_Sauve.recupAncBase(Pbase, PDataBase, Shadow: STRING);
//BEGIN
//  TRY
//    IF FileExists(ChangeFileExt(PDataBase, '.Old')) THEN
//    BEGIN
//      DeleteFile(PBase + 'SV.GBK');
//      deletefile(PDataBase);
//      renamefile(ChangeFileExt(PDataBase, '.Old'), PDataBase);
//      IF shadow <> '' THEN
//      BEGIN
//        deletefile(shadow);
//        renamefile(ChangeFileExt(Shadow, '.Old'), Shadow);
//      END;
//    END
//  EXCEPT ON stan: exception DO
//    BEGIN
//      LogAjoute('RecupAncBase() Exception : ' + stan.message);
//    END;
//  END;
//END;

PROCEDURE TFrm_Sauve.ValideNvBck(PathBase: STRING; PathEai: STRING; PathDataBase, Shadow: STRING);
VAR
  S: STRING; // Var tempo PR
  sSavePath: STRING; // Chemin de sauvegarde des fichiers
BEGIN
  TRY
    //créer le répertoire 'backup' s'il n'existe pas
    ForceDirectories(PathBase + 'backup\');

    sSavePath := NouvelleSauvegarde(PathBase + 'backup\');
    CopyFile(PChar(PathBase + 'SV.GBK'), PChar(sSavePath + 'SV.GBK'), False);
    CopyFile(PChar(PathEai + 'DelosQPMAgent.Providers.xml'), PChar(sSavePath + 'DelosQPMAgent.Providers.xml'), False);
    CopyFile(PChar(PathEai + 'DelosQPMAgent.Subscriptions.xml'), PChar(sSavePath + 'DelosQPMAgent.Subscriptions.xml'), False);

    IF fileexists(PathDatabase) THEN
    BEGIN
      S := PathBase + 'SV.GBK';
      DeleteFile(S);
      S := ChangeFileext(PathDatabase, '.Old');
      deletefile(S);
      IF Shadow <> '' THEN
      BEGIN
        S := ChangeFileext(Shadow, '.Old');
        deletefile(S);
      END;
    END;
  EXCEPT ON e: exception DO
    BEGIN        
      LogAjoute('ValideNvBck()        Exception : ' + e.message);
    END;
  END;
END;

FUNCTION TFrm_Sauve.run: Boolean;
VAR
  ini: TIniFile;
  tps: Dword;
  F: TSearchRec;
  S: STRING;
  tc: Char;
  TailleRestante: Int64;
  PBase: STRING;
  PDataBase: STRING;
  PEAI: STRING;
  LesBases: TStringList;
  i, ident: integer;
  //Lechemin: string;
  isParametre: boolean;

  S_t: STRING;

  taille: int64;
  shadow: STRING;
  S1, S2: STRING;
  newRep, baseCopie: STRING;
  strIni: STRING;
BEGIN
  strIni := 'FALSE'; //lab lecture du paramétrage pour l'analyse de la base avant back up
  TRY          
    // Clôture de ginkoia
    LogAjoute('Run()                Début arrêt de ginkoia.');
    KillProcess(ginkoia);
    LogAjoute('Run()                Fin arrêt de ginkoia.');

    // Clôture de la caisse
    LogAjoute('Run()                Début arrêt de la caisse.');
    KillProcess(Caisse);
    LogAjoute('Run()                Fin arrêt de la caisse.');

    // Clôture du piccolink
    LogAjoute('Run()                Début arrêt de Piccolink.');
    KillProcess(PICCO);
    LogAjoute('Run()                Fin arrêt de Piccolink.');

    // Clôture du launcher
    LogAjoute('Run()                Début arrêt du Launcher.');
    KillProcess(LauncherV7);
    LogAjoute('Run()                Fin arrêt du Launcher.');

    // Clôture du SyncWeb
    LogAjoute('Run()                Début arrêt du SyncWeb.');
    KillProcess(SyncWeb);
    LogAjoute('Run()                Fin arrêt du SyncWeb.');

    // Clôture du ibScheduler
    LogAjoute('Run()                Début arrêt du Scheduler.');
    KillProcess(ibScheduler);
    LogAjoute('Run()                Fin arrêt du Scheduler.');

    Taille := 0;

    MapGinkoia.Backup := true;
    StopService;
    TRY
      enabled := false;
      TRY
        result := false;
        TRY
          LesBases := TstringList.Create;
          IF NewBase THEN
          BEGIN
            // NewBase
            Ib_LesBases.Open;
            Ib_LesBases.first;
            WHILE NOT Ib_LesBases.Eof DO
            BEGIN
              PDataBase := Ib_LesBasesREP_PLACEBASE.AsString;
              PBase := ExtractFilePath(PDataBase);
              IF PBase[Length(PBase)] <> '\' THEN
                PBase := PBase + '\';
              PEAI := Ib_LesBasesREP_PLACEEAI.AsString;
              S_t := Uppercase(PBase + ';' + PDataBase + ';' + PEAI);
              IF LesBases.IndexOF(S_T) < 0 THEN
                LesBases.Add(S_T);
              Ib_LesBases.Next;
            END;
            Ib_LesBases.Close;
            Database.close;

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
            PBase := PathBase;
            PDataBase := PathDataBase;
            PEAI := Pathexe + 'EAI\';
            LesBases.Add(PBase + ';' + PDataBase + ';' + PEAI);
          END;
          TpsDem := GetTickCount;
          Timer1.Enabled := true;
          tps := GetTickCount;
          FOR i := 0 TO LesBases.Count - 1 DO
          BEGIN
            shadow := '';
            S := LesBases[i];
            PBase := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, pos(';', S));
            PDataBase := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, pos(';', S));
            PEAI := S;
            IF interbase7 THEN
            BEGIN
              // pour chaque base regarder si un fichier shadow existe
              DataBase.close;
              DataBase.DataBaseName := PDataBase;
              Qry.sql.clear;
              Qry.sql.add('select rdb$file_NAME from rdb$files');
              Qry.Open;
              IF qry.recordcount <> 0 THEN
                shadow := trim(qry.Fields[0].AsString);
              Qry.Close;
              Qry.sql.clear;
              DataBase.Close;
            END;
            IF NOT (fileexists(ChangeFileExt(PDataBase, '.Old'))) AND
              ((Shadow = '') OR NOT (fileexists(ChangeFileExt(Shadow, '.Old')))) THEN
            BEGIN
              taille := 0;
              IF findfirst(PDataBase, faanyfile, F) = 0 THEN
                taille := taille + f.Size;
              findClose(f);
              tc := PDataBase[1];
              TailleRestante := DiskFree(Ord(TC) - ORD('A') + 1);
              IF tailleRestante < Taille * 1.5 THEN
              BEGIN
                LogAjoute('Run()                Pas suffisament de place Pour le Backup');
                LogAjoute('Run()                Taille ' + Inttostr(Taille) + ' Taille restante ' + Inttostr(TailleRestante));
                marqueBase(False, 5, PDataBase);
                result := false;
              END
              ELSE
              BEGIN
                LogAjoute('Run()                Début sauvegarde ' + PDataBase);
                Caption := 'Debut de la sauvegarde ';
                //update;
                LogAjoute('Run()                Vérification du paramétre de la synchro');
                //lab verifier s'il s'agit d'un serveur dont le paramétre de la synchro est actif
                TRY
                  isParametre := false;
                  DataBase.close;
                  Que_ParamSynchro.open;
                  IF (Que_ParamSynchro.REcordCount = 1) THEN
                  BEGIN
                    IF (Que_ParamSynchroPRM_STRING.asString = '') THEN //si je ne suis pas en synchro avec une base
                    BEGIN
                      //tester si d'autres bases sont synchronisées
                      DataBase.close;
                      Que_BasesSynchro.open;
                      IF (Que_BasesSynchro.RecordCount >= 1) THEN
                      BEGIN
                        isParametre := true;
                      END;
                    END
                  END;
                FINALLY
                  Que_ParamSynchro.Close;
                  Que_BasesSynchro.close;
                  DataBase.close;
                END;
                LogAjoute('Run()                analyse des statistiques de la base');
                //si option Analyser active lancer l'analyse : récupèrer dans l'ini les params
                Ini := TIniFile.Create(changefileext(application.exename, '.ini'));
                strIni := ini.readString('STAT', 'ACTIF', '');
                IF (UpperCase(strIni) = 'TRUE') THEN
                BEGIN
                  TRY
                    strIni := ini.readString('STAT', 'TIMEOUT', '');
                    iniTimeout := StrToInt(strini);
                  EXCEPT
                    iniTimeout := 0;
                  END;
                  analyserBase(PDataBase);
                END;
                //lab déplacé pour résoudre les deadlock sur TMPStat qui empeche le marquage des tables
                LogAjoute('Run()                Arret de la base ');
                Caption := 'Arret de la Base ';
                ArretBase(PBase, PDataBase);
                LogAjoute('Run()                Début du marquage des tables ');
                IF MarqueLesTables(PDataBase) THEN
                BEGIN
                  LogAjoute('Run()                Backup de la base ');
                  Caption := 'Backup en cours ';
                  //update;
                  IF Backup(Pbase, PDataBase) THEN
                  BEGIN
                    // on renome plus
                    LogAjoute('Run()                Restauration de la base ');
                    Caption := 'Restauration en cours ';
                    //update;
                    DeleteFile(PBase + 'Gink.IB');
                    IF restore(Pbase, PBase + 'Gink.IB') THEN
                    BEGIN
                      LogAjoute('Run()                démarage de la base ');
                      Caption := 'démarage de la base ';
                      //update;
                      DemareBase(Pbase, PBase + 'Gink.IB');
                      LogAjoute('Run()                Vérification de la base ');
                      Caption := 'Vérification de la base ';
                      //update;
                      IF VerifBase(PBase + 'Gink.IB') THEN
                      BEGIN

                        LogAjoute('Run()                Backup/Restore OK ');
                        Caption := 'Backup/Restore OK';
                        //update;
                        ValideNvBck(Pbase, PEAI, PDataBase, Shadow);

                        //lab faire une copie si je suis un serveur dont le parametre synchro est actif
                        IF isParametre THEN
                        BEGIN
                          //faire la copie de la base restaurée pour le notebook
                          IF NOT copyFichier(PBase + 'Gink.IB', ExtractFilePath(PDataBase) + '\Synchro\GINKCOPY.IB', 3) THEN
                          BEGIN
                            LogAjoute('Run()                Erreur lors de la copie de la base restaurée vers le dossier SYNCHRO ');
                          END;
                        END;

                        LogAjoute('Run()                Renomage de la base ');
                        IF RenomeBase(PDataBase, Shadow) THEN
                        BEGIN
                          //créer le répertoire 'backup' s'il n'existe pas
                          newRep := IncludeTrailingBackslash(ExtractFilePath(PBase)) + 'backup\';
                          ForceDirectories(newRep);
                          IF renamefile(PBase + 'Gink.IB', PDataBase) THEN
                          BEGIN
                            LogAjoute('Run()                Tout est OK ');
                            //déplacer '.toto'
                            baseCopie := ChangeFileExt(PDataBase, '.toto');
                            //supprimer l'ancien
                            deletefile(newRep + ExtractFileName(baseCopie));
                            MoveFile(Pchar(baseCopie), PChar(newRep + ExtractFileName(baseCopie)));
                            DemareBase(Pbase, PDataBase);
                            marqueBase(true, 0, PDataBase);
                          END
                          ELSE
                          BEGIN
                            renamefile(ChangeFileExt(PDataBase, '.toto'), PDataBase);
                            LogAjoute('Run()                Impossible de Renomer la base Gink.ib en Ginkoia.ib');
                            DemareBase(Pbase, PDataBase);
                            marqueBase(true, 1, PDataBase);
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
                          LogAjoute('Run()                Impossible de Renomer la base en Ginkoia.toto');
                          DemareBase(Pbase, PDataBase);
                          marqueBase(true, 1, PDataBase);
                        END;
                        IF fileexists(PDataBase) THEN
                        BEGIN
                          deletefile(PBase + 'Gink.IB');
                          deletefile(PBase + 'SV.GBK');
                        END;
                        result := true;
                      END
                      ELSE
                      BEGIN
                        LogAjoute('Run()                Base mal restaurée ');
                        Caption := 'Base mal restaurée ';
                        //update;
                        IF fileexists(PDataBase) THEN
                        BEGIN
                          deletefile(PBase + 'Gink.IB');
                          deletefile(PBase + 'SV.GBK');
                        END;
                        DemareBase(PBase, PDataBase);
                        marqueBase(False, 2, PDataBase);
                      END;
                    END
                    ELSE
                    BEGIN
                      LogAjoute('Run()                Restauration planté ');
                      Caption := 'Restauration planté ';
                      //update;
                      IF fileexists(PDataBase) THEN
                      BEGIN
                        deletefile(PBase + 'Gink.IB');
                        deletefile(PBase + 'SV.GBK');
                      END;
                      DemareBase(PBase, PDataBase);
                      marqueBase(False, 3, PDataBase);
                    END;
                  END
                  ELSE
                  BEGIN
                    LogAjoute('Run()                Backup pas OK ');
                    Caption := 'Backup pas OK';
                    //update;
                    IF fileexists(PDataBase) THEN
                      deletefile(PBase + 'SV.GBK');
                    DemareBase(PBase, PDataBase);
                    marqueBase(False, 4, PDataBase);
                  END;
                END
                ELSE
                BEGIN
                  LogAjoute('Run()                Update 2');
                  Caption := 'Problème de base ';
                  //update;
                  LogAjoute('Run()                Ne peut même pas marquer les tables ');
                END;
              END;
            END
            ELSE
            BEGIN
              Caption := 'Problème de base ';
              //update;
              LogAjoute('Run()                Un Fichier.OLD existe déjà ');
              result := false;
            END;
          END;
          IF result THEN
          BEGIN
            TRY
              tps := GetTickCount - tps;
            EXCEPT ON E: exception DO
              BEGIN
                LogAjoute('Run()                Exception : Problème Calcule du temps. ' + E.message);
              END;
            END;
            TRY
              TailleBaseMoy := trunc((TailleBaseMoy + taille) / 2);
            EXCEPT ON E: exception DO
              BEGIN
                LogAjoute('Run()                Exception : Problème Calcule tailleBaseMoy. ' + E.message);
              END;
            END;
            TRY
              TmpsMoy := trunc((TmpsMoy + Integer(tps)) / 2);
            EXCEPT ON E: exception DO
              BEGIN
                LogAjoute('Run()                Exception : Problème Calcule TmpsMoy. ' + E.message);
              END;
            END;
            TRY
              NbBckup := NbBckup + 1;
            EXCEPT ON E: exception DO
              BEGIN
                LogAjoute('Run()                Exception : Problème Calcule NbBckup. ' + E.message);
              END;
            END;
            TRY
              //Ini := TIniFile.Create(changefileext(application.exename, '.ini'));
              TRY
                ini.Writeinteger('TPS', 'NB', NbBckup);
                ini.Writeinteger('TPS', 'TB', TailleBaseMoy);
                ini.Writeinteger('TPS', 'TPS', TmpsMoy);
              FINALLY
                ini.free;
              END;
            EXCEPT ON E: exception DO
              BEGIN
                LogAjoute('Run()                Exception : Problème ecriture dans ' + changefileext(application.exename, '.ini') + '. ' + E.message);
              END;
            END;
          END;
        EXCEPT ON E: exception DO
          BEGIN
            Caption := 'Problème de base ';
            //update;
            LogAjoute('Run()                Exception : Problème non connu. ' + E.message);
          END;
        END;
      FINALLY
        LogAjoute('Run()                Libération du mapping ');
        MapGinkoia.Backup := False;
        Timer1.Enabled := false;
        enabled := true;
      END;
    FINALLY
      StartService;
    END;
  FINALLY
  END;
END;

PROCEDURE TFrm_Sauve.Attente_IB;
VAR
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  tempMini: DWORD;
  CheckPoint: DWORD;
  NbBcl: Integer;
BEGIN
  try
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

      KillProcess(LauncherV7);
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
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('Attente_IB()         Exception : ' + E.message);
    END;
  END;
END;

PROCEDURE TFrm_Sauve.Button1Click(Sender: TObject);
VAR
  reg: TRegistry;
  S: STRING;
BEGIN
  IF ((ParamCount > 0) AND (uppercase(paramstr(1)) = 'AUTO')) Or (ParamCount = 0) THEN
  BEGIN
    IF FileExists(ChangeFileExt(PathDataBase, '.Old')) THEN
    BEGIN
      LogAjoute('Button1Click()       Impossible de backuper si le fichier ' + ChangeFileExt(PathDataBase, '.Old') + '.');
      //Application.MessageBox(Pchar('Impossible de backuper si le fichier ' + ChangeFileExt(PathDataBase, '.Old')),
      //  'Attention', Mb_Ok);
      Exit;
    END;

    if ((ParamCount > 0) AND (uppercase(paramstr(1)) = 'AUTO')) then
    begin
      LogAjoute('Button1Click()       Execution en "Mode Auto".');
      if (FormatDateTime('hh:nn', Now) > '08:00') And (FormatDateTime('hh:nn', Now) < '20:00') then   //Entre 8h00 et 20h00 aucun lancement de Backup Restore en automatique
      begin
        LogAjoute('Button1Click()       Pas de Backup Restore entre 8h00 et 20h00.');
      end
      else
      begin
        if fileExists(PathDataBase) then
        begin
          run;
        end;
      end;
    end
    else
    begin
      LogAjoute('Button1Click()       Execution en "Mode Manuel".');

      if fileExists(PathDataBase) then
      begin
        run;
      end;
    end;
  end
  else
  begin
    if (ParamCount > 0) AND (uppercase(paramstr(1)) = 'RECUP') THEN
    begin
      // Lancé si erreur et redémarrage

      LogAjoute('Button1Click()       Execution en "Mode Recup".');

      // on arrète le launcher
      LogAjoute('Button1Click()       Début arrêt du Launcher.');
      KillProcess(LauncherV7);
      LogAjoute('Button1Click()       Fin arrêt du Launcher.');

      // Clôture du SyncWeb
      LogAjoute('Button1Click()       Début arrêt du SyncWeb.');
      KillProcess(SyncWeb);
      LogAjoute('Button1Click()       Fin arrêt du SyncWeb.');

      // Tempo attente IB
      PauseEnSec(1);

      Attente_IB;

      // Redémarrage de la base
      DemareBase(IncludeTrailingBackslash(ExtractFilePath(PathDataBase)), PathDataBase);
    end;
  end;

  // on relance le launcher si besoin
  IF ArretLaunch THEN
  BEGIN
    S := '';
    TRY
      reg := TRegistry.Create(KEY_READ);
      TRY
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
        S := reg.ReadString('Launch_Replication');
      FINALLY
        reg.free;
      END;
    EXCEPT ON E: exception DO
      BEGIN
        LogAjoute('Button1Click()       Exception : ' + E.message);
      END;
    END;
    IF S <> '' THEN
    BEGIN
      Winexec(PChar(S), 0);
    END;
  END;

  // on relance le syncweb si besoin
  IF ArretSyncWeb THEN
  BEGIN
    S := '';
    TRY
      reg := TRegistry.Create(KEY_READ);
      TRY
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
        S := reg.ReadString('GinkoSyncWeb');
      FINALLY
        reg.free;
      END;
    EXCEPT ON E: exception DO
      BEGIN
        LogAjoute('Button1Click()       Exception : ' + E.message);
      END;
    END;
    IF S <> '' THEN
    BEGIN
      Winexec(PChar(S), 0);
    END;
  END;

  IF sender = NIL THEN
    close;
END;

PROCEDURE TFrm_Sauve.Timer1Timer(Sender: TObject);
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
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('Timer1Timer()        Exception : ' + E.message);
    END;
  END;
END;

PROCEDURE TFrm_Sauve.marqueBase(OK: Boolean; tipe: Integer; PDataBase: STRING);
VAR
  F: STRING;
  num: STRING;
  idVersion,
    id: STRING;
  empty: Boolean;
BEGIN
  TRY
    Database.Connected := false;
    Database.DatabaseName := PDataBase;
    IF ok THEN
      F := '1'
    ELSE
      F := '0';
    Qry.Sql.Clear;
    Qry.Sql.Add('select Cast(PAR_STRING as Integer) Numero');
    Qry.Sql.Add('from genparambase');
    Qry.Sql.Add('Where PAR_NOM=''IDGENERATEUR''');
    Qry.Open;
    num := Qry.Fields[0].AsString;
    LogAjoute('MarqueBase()         récup de l''ID ' + num);
    Qry.Close;
    Qry.Sql.Clear;
    Qry.Sql.Add('select Bas_ID');
    Qry.Sql.Add('from GenBases');
    Qry.Sql.Add('where BAS_ID<>0');
    Qry.Sql.Add('AND BAS_IDENT=''' + Num + '''');
    Qry.Open;
    num := Qry.Fields[0].AsString;
    LogAjoute('MarqueBase()         récup de Base ID ' + num);
    Qry.Close;

    Qry.Sql.Clear;
    Qry.Sql.Add('Select DOS_ID ');
    Qry.Sql.Add('from GenDossier ');
    Qry.Sql.Add('Where DOS_NOM = ''B-' + NUM + '''');
    Qry.Sql.Add('  And DOS_FLOAT = ' + f);
    Qry.Open;
    empty := Qry.IsEmpty;
    IF NOT Empty THEN
    BEGIN
      Id := Qry.Fields[0].AsString;
    END;
    Qry.Close;
    Qry.Sql.Clear;
    Qry.Sql.Add('Select NewKey ');
    Qry.Sql.Add('From PROC_NEWKEY');
    Qry.Open;
    IF empty THEN
    BEGIN
      Id := Qry.Fields[0].AsString;
      IdVersion := Id;
    END
    ELSE
      IdVersion := Qry.Fields[0].AsString;
    Qry.Close;

    IF empty THEN
    BEGIN
      LogAjoute('MarqueBase()         Création de l''enregistrement ' + Id);
      Qry.Sql.Clear;
      Qry.Sql.Add('Insert Into GenDossier');
      Qry.Sql.Add('(DOS_ID, DOS_NOM, DOS_STRING, DOS_FLOAT)');
      Qry.Sql.Add('VALUES (');
      Qry.Sql.Add(Id + ',''B-' + Num + ''',''' + DateTimeToStr(now) + ' ' + Inttostr(tipe) + ''',' + f);
      Qry.Sql.Add(')');
      Qry.ExecSQL;
      Qry.Sql.Clear;
      Qry.Sql.Add('Insert Into K');
      Qry.Sql.Add('(K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,');
      Qry.Sql.Add(' KSE_DELETE_ID,K_DELETED, KSE_UPDATE_ID, K_UPDATED, KSE_LOCK_ID, KMA_LOCK_ID )');
      Qry.Sql.Add('VALUES (');
      Qry.Sql.Add(ID + ',-101,-11111338,' + IdVersion + ',1,-1,-1,Current_date,0,Current_date,-1,Current_date,0,0 )');
      Qry.ExecSQL;
      IF Qry.Transaction.InTransaction THEN
        Qry.Transaction.commit;
    END
    ELSE
    BEGIN
      LogAjoute('MarqueBase()         Modification de l''enregistrement ' + Id);
      Qry.Sql.Clear;
      Qry.Sql.Add('Update GenDossier');
      Qry.Sql.Add('SET DOS_STRING = ''' + DateTimeToStr(now) + ' - ' + Inttostr(tipe) + ''', DOS_FLOAT=' + f);
      Qry.Sql.Add('Where DOS_ID=' + id);
      Qry.ExecSQL;
      Qry.Sql.Clear;
      Qry.Sql.Add('Update K');
      Qry.Sql.Add('SET K_Version = ' + IdVersion);
      Qry.Sql.Add('Where K_ID=' + id);
      Qry.ExecSQL;
      IF Qry.Transaction.InTransaction THEN
        Qry.Transaction.commit;
    END;
    Database.Connected := False;
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('MarqueBase()         Problème de connexion à la base. ' + E.message);
    END;         
  END;
END;

PROCEDURE TFrm_Sauve.DeleteTrois(PBase: STRING);
VAR
  i: integer;
BEGIN
  TRY
    deletefile(PBase + 'trois.txt');
    IF Fileexists(PBase + 'trois.txt') THEN
    BEGIN
      i := 0;
      REPEAT
        inc(i);
        trois := PBase + 'trois' + Inttostr(i) + '.txt';
        deletefile(trois);
      UNTIL NOT Fileexists(trois);
    END
    ELSE trois := PBase + 'trois.txt'
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('DeleteTrois()        Exception : ' + E.message);
    END;
  END;
END;

PROCEDURE TFrm_Sauve.DeleteDeux(PBase: STRING);
VAR
  i: integer;
BEGIN
  TRY
    deletefile(PBase + 'deux.txt');
    IF Fileexists(PBase + 'deux.txt') THEN
    BEGIN
      i := 0;
      REPEAT
        inc(i);
        deux := PBase + 'deux' + Inttostr(i) + '.txt';
        deletefile(deux);
      UNTIL NOT Fileexists(deux);
    END
    ELSE deux := PBase + 'deux.txt'
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('DeleteDeux()         Exception : ' + E.message);
    END;
  END;
END;

PROCEDURE TFrm_Sauve.DeleteUn(PBase: STRING);
VAR
  i: integer;
BEGIN
  TRY
    deletefile(PBase + 'Un.txt');
    IF Fileexists(PBase + 'Un.txt') THEN
    BEGIN
      i := 0;
      REPEAT
        inc(i);
        Un := PBase + 'Un' + Inttostr(i) + '.txt';
        deletefile(Un);
      UNTIL NOT Fileexists(Un);
    END
    ELSE Un := PBase + 'Un.txt'
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('DeleteUn()           Exception : ' + E.message);
    END;
  END;
END;

PROCEDURE TFrm_Sauve.FormPaint(Sender: TObject);
BEGIN
  IF first THEN
  BEGIN
    first := false;
    IF (ParamCount > 0) AND
      ((uppercase(paramstr(1)) = 'AUTO') OR (uppercase(paramstr(1)) = 'RECUP')) THEN
    BEGIN
      //update;
      Button1Click(NIL);
    END;
  END;
END;

FUNCTION TFrm_Sauve.GetProcessId(ProgName: STRING): cardinal;
VAR
  Snaph: thandle;
  Proc: Tprocessentry32;
  PId: cardinal;
BEGIN
  try
    PId := 0;
    Proc.dwSize := sizeof(Proc);
    Snaph := createtoolhelp32snapshot(TH32CS_SNAPALL, 0); //recupere un capture de process
    process32first(Snaph, Proc); //premeir process de la list
    IF Uppercase(extractfilename(Proc.szExeFile)) = Uppercase(ProgName) THEN //test pour savoir si le process correspond
      PId := Proc.th32ProcessID // recupere l'id du process
    ELSE
    BEGIN
      WHILE process32next(Snaph, Proc) DO //dans le cas contraire du test on continue à cherche le process en question
      BEGIN
        IF extractfilename(Proc.szExeFile) = ProgName THEN
          PId := Proc.th32ProcessID;
      END;
    END;
    Closehandle(Snaph);
    result := PId;
  EXCEPT ON E: exception DO
    BEGIN
      LogAjoute('GetProcessId()       Exception : ' + E.message);
    END;
  END;
END;

procedure TFrm_Sauve.LogAjoute(ALogMess: string);
begin
  TRY
    Log.Add(DateTimeToStr(Now) + '  ' + ALogMess);
    Log.SaveToFile(PathBase + 'BackupRestor.Log');
  EXCEPT
  END;
end;

FUNCTION TFrm_Sauve.copyFichier(strSource, strDestination: STRING; trials: Integer): Boolean;
VAR
  i: integer;
  FileCtrl: TLMDFileCtrl;
  boolRetour: boolean;
BEGIN
  //lab effectue une copie d'un fichier
  //Recommence trials fois si la copie n'est pas bonne
  //retourne true si ok

  //initialisation pessismiste du retour
  boolRetour := false;
  //initialiser le compteur de tentatives
  i := 0;
  TRY
    DeleteFile(strDestination);
    FileCtrl := TLMDFileCtrl.Create(Application);
    FileCtrl.Options := [ffFilesOnly, ffNoActionConfirm, ffNoMKDIRConfirm];
    //créer le répertoire s'il n'existe pas
    ForceDirectories(ExtractFilePath(strDestination));
    screen.Cursor := crHourGlass;
    //répéter la copie jusqu'à ce que le fichier copié soit valable ou que le nombre de tentatives max soit atteint
    REPEAT
      //incrémenter le compteur
      inc(i);
      IF FileCtrl.CopyFiles(strSource, strDestination) THEN
      BEGIN
        boolRetour := true;
      END;
    UNTIL ((boolRetour = true) OR (i = trials));
  EXCEPT ON E: Exception DO
    BEGIN
      LogAjoute('CopyFichier()        Exception : ' + E.message);
      boolRetour := false;
      screen.Cursor := crDefault;
      Filectrl.free;
    END;
  END;
  screen.Cursor := crDefault;

  result := boolRetour;
END;

FUNCTION TFrm_Sauve.executerProcess(cmdLine: STRING; timeout: integer; exeName: STRING): boolean;
VAR
  StartInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  fin: Boolean;
  retour: Boolean;
  Proch: thandle;
  PId: cardinal;
BEGIN
  try
    //fonction qui crée un process cmdline et attends sa fin ou celle du timeout pour rend la main et signaler le résultat
    //renvoi true si fini ok ou false si fini car timeout
    //timeout -1 signifie que l'on n'attends pas la fin de l'execution du process, mais seulement la fin de sa création
        { Mise à zéro de la structure StartInfo }
    FillChar(StartInfo, SizeOf(StartInfo), #0);
    { Seule la taille est renseignée, toutes les autres options }
    { laissées à zéro prendront les valeurs par défaut }
    StartInfo.cb := SizeOf(StartInfo);
    retour := true;
    { Lancement de la ligne de commande }
    IF CreateProcess(NIL, Pchar(cmdLine), NIL, NIL, False,
      0, NIL, NIL, StartInfo, ProcessInfo) THEN
    BEGIN
      { L'application est bien lancée, on va en attendre la fin }
      { ProcessInfo.hProcess contient le handle du process principal de l'application }
      IF timeout <> -1 THEN
      BEGIN
        REPEAT
          Fin := False;
          Application.ProcessMessages;
          CASE WaitForSingleObject(ProcessInfo.hProcess, timeout) OF
            WAIT_OBJECT_0: Fin := True;
            WAIT_TIMEOUT: //si le temps est expiré, tuer l'exe et cmd pour éviter des problèmes ensuite ( backup et restore après)
              BEGIN
                retour := false;
                Fin := True;
                Pid := GetProcessId(exeName);
                Proch := openprocess(PROCESS_ALL_ACCESS, true, PId); //handle du process
                IF terminateprocess(Proch, 0) THEN
                BEGIN
                  retour := true;
                END;
                IF terminateprocess(ProcessInfo.hProcess, 0) THEN
                BEGIN
                  retour := true;
                END;
                Closehandle(Proch);
              END;
          END;
        UNTIL fin;
      END;
    END;
    result := retour;
  EXCEPT ON E: exception DO
    BEGIN        
      LogAjoute('ExecuterProcess()    Exception : ' + E.message);
    END;
  END;
END;

INITIALIZATION
  ArretLaunch := False;
  ArretSyncWeb := False;

END.

