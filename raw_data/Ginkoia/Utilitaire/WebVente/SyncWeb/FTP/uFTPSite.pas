unit uFTPSite;

interface

uses
  DB, uGestionBDD, uCommon_Type, uCreateCSV, uFTPFiles, uCustomFTPManager,
  extCtrls, uFTPUtils, uMonitoring, uLog, Classes, uFTPCtrl;

type
  TSiteStatut = (stWaiting, stInitialize, stExecuting, stExportError,
                 stImportError, stFTPError);

  TFTPSite = Class
  private
    FParent: TCustomFTPManager;
    FConnection: TMyConnection;

    FModuleName: String;
    FPRM_TYPE: String;
    FGENPATH: String;
    FGENLOGPATH: String;

    FFTPLogEvent: TFTPLogEvent;
    FOnAddMonitoringEvent: TAddMonitoringEvent;
    FMonitoringAppType: TMonitoringAppType;
    FExtension: String;

    FSiteStatut: TSiteStatut;
    FFiles: TCustomFTPSendFileList;

    FId: integer;
    FMagId: integer;
    FUserId: integer;
    FNegProjectId: integer;
    FNom: string;

    FInitializationDate: TDateTime;
    FStart, FEnd: TDateTime;
    FDelai: integer;
    FIsOneShotCycleTime: Boolean;
    FCptCycleTime: integer;

    FFTPSendData, FFTPGetData: TFTPData;
    FSMTPData: TSMTPData;

    FCurrentVersionBase: Int64;
    FCurrentVersionLame: Int64;

    FSiteTimer: TTimer;
    FInitializationTimer: TTimer;
    FLogFilePath: string;
    FHasErrors: boolean;
    FOnGetData: TNotifyEvent;

    procedure Init;
    procedure Refresh;

    procedure RefreshTimers;
    procedure RefreshSiteTimer;
    procedure RefreshInitializationTimer;

    procedure SiteTimerTimer(Sender: TObject);
    procedure InitializationTimerTimer(Sender: TObject);

    function IsModule(aModule : String) : Boolean;
  protected
    procedure LoadFTPParams;
    procedure LoadSMTPParams;
    procedure LoadGENPARAMs;
    procedure LoadFiles;

    procedure Refresh_K_Versions;

    procedure AddLog(ALogMessage: string; ALogLevel: TFTPLogLevel = ftpllInfo);
    procedure AddMonitoring(AMessage: string; ALogLevel: TLogLevel;
      AMdlType: TMonitoringMdlType; AForceStatus: boolean = False; AFrequency: integer = -1);

    function TestFTP: boolean;

    procedure WriteFiles(AInitMode: Boolean);
    procedure UploadFiles;

    procedure DownLoadFiles;
    procedure ReadFiles;

    function WriteFile(AFile: TCustomFTPSendFile; AInitMode: Boolean): boolean;
    function UpdateVersionFile(AFile: TCustomFTPSendFile): boolean;
    function RemoveEmptyFile(AFilePAth: string; Const AHeaderExist: Boolean): boolean;
    function SendMail: boolean;

    procedure StartTimers;
    procedure StopTimers;

    procedure FilesLog(Sender: TObject; ALog: string; AFTPLogLvl: TFTPLogLevel);

    procedure ArchiveFile(AFilePath: string; AError: boolean = False);
    procedure PurgeArchives;

    procedure ExecuteExport;
    procedure ExecuteImport;

    Procedure DoOnGetData;
  public
    constructor Create(Const AParent: TCustomFTPManager; Const AConnection: TMyConnection;
                       Const ADataSet: TDataSet; Const AMonitoringAppType: TMonitoringAppType;
                       Const AModuleName: String; Const APRM_TYPE: String;
                       Const AGENPATH, AGENLOGPATH: String;
                       Const AOnAddMonitoring: TAddMonitoringEvent;
                       Const AExtension: String;
                       Const AIsOneShotCycleTime: Boolean);

    destructor Destroy; override;

    procedure Execute;
    procedure Initialize;

    procedure ForceUpload;
    procedure TestFTPConnection;

    procedure Start;
    procedure Stop;

    procedure RefreshDefaultMonitoringValues;

    function Enabled: boolean;

    property FTPGetData: TFTPData read FFTPGetData;

    property OnGetData: TNotifyEvent read FOnGetData write FOnGetData;

    property OnLog: TFTPLogEvent read FFTPLogEvent write FFTPLogEvent;
    property OnAddMonitoring: TAddMonitoringEvent read FOnAddMonitoringEvent write FOnAddMonitoringEvent;
    property LogFilePath: string read FLogFilePath;

    property HasErrors: boolean read FHasErrors write FHasErrors;
  end;

implementation

uses
  Windows, SyncWebResStr, uCommon_DM, uGenerique, SysUtils, StrUtils, uCommon,
  DateUtils, ShellApi;

{ TFTPSite }

procedure TFTPSite.AddLog(ALogMessage: string; ALogLevel: TFTPLogLevel);
begin
  if Assigned(FFTPLogEvent) then
    FFTPLogEvent(Self, ALogMessage, ALogLevel);
end;

procedure TFTPSite.AddMonitoring(AMessage: string; ALogLevel: TLogLevel;
  AMdlType: TMonitoringMdlType; AForceStatus: boolean; AFrequency: integer);
begin
  // Si on n'a pas rencontré d'erreur on monitor en info pour indiquer que tout c'est bien passé
//  if Assigned(FOnAddMonitoringEvent) and ( ((ALogLevel = logInfo)
//    and (FSiteStatut in [stWaiting, stExecuting, stInitialize])) or (ALogLevel <> logInfo) ) then
//  begin
    FOnAddMonitoringEvent(self, AMessage, ALogLevel, AMdlType, FMonitoringAppType, FMagId, AForceStatus, AFrequency);
//  end;

  case ALogLevel of
    logError, logWarning:
    begin
      case AMdlType of
        mdltFTP:    FSiteStatut := stFTPError;
        mdltImport: FSiteStatut := stImportError;
        mdltExport: FSiteStatut := stExportError;
      end;
    end;
  end;
end;

procedure TFTPSite.ArchiveFile(AFilePath: string; AError: boolean);
var
  archivepath: string;
  sdate: string;
begin
  if AError then
  begin
    archivepath := ExtractFilePath(AFilePath)+ '\Erreur\';
  end
  else
  begin
    archivepath := format('%s\%.4d\%.2d\%.2d\', [ExtractFilePath(AFilePath), YearOf(Now), MonthOf(Now),
      DayOf(Now)]);
  end;

  if not DirectoryExists(archivepath) then
    ForceDirectories(archivepath);

  DateTimeToString(sdate, 'YYYYMMDDHHMMSS', Now);
  MoveFile(PChar(AFilePath), PChar(Format('%s\%s_%s', [archivepath, sdate, ExtractFileName(AFilePAth)])));
end;

constructor TFTPSite.Create(Const AParent: TCustomFTPManager;
  Const AConnection: TMyConnection; Const ADataSet: TDataSet;
  Const AMonitoringAppType: TMonitoringAppType;
  Const AModuleName: String; Const APRM_TYPE: String;
  Const AGENPATH, AGENLOGPATH: String;
  Const AOnAddMonitoring: TAddMonitoringEvent;
  Const AExtension: String;
  Const AIsOneShotCycleTime: Boolean);
begin
  FParent := AParent;
  FConnection := AConnection;
  FMonitoringAppType:= AMonitoringAppType;
  FModuleName:= AModuleName;
  FPRM_TYPE:= APRM_TYPE;
  FGENPATH:= AGENPATH;
  FGENLOGPATH:= AGENLOGPATH;
  FOnAddMonitoringEvent:= AOnAddMonitoring;
  FExtension:= AExtension;
  FIsOneShotCycleTime:= AIsOneShotCycleTime;
  FCptCycleTime:= 0;

  FSiteStatut := stWaiting;

  FFiles := TCustomFTPSendFileList.Create;

  FId := ADataSet.FieldByName('ASS_ID').AsInteger;
  FMagId := ADataSet.FieldByName('ASS_CODE').AsInteger;
  FUserId := ADataSet.FieldByName('ASS_USRID').AsInteger;
  FNegProjectId := ADataSet.FieldByName('ASS_NPJID').AsInteger;
  FNom := ADataSet.FieldByName('ASS_NOM').AsString;

  FSiteTimer := TTimer.Create(nil);
  FSiteTimer.Enabled := False;
  FSiteTimer.OnTimer := SiteTimerTimer;

  FInitializationTimer := TTimer.Create(nil);
  FInitializationTimer.Enabled := False;
  FInitializationTimer.OnTimer := InitializationTimerTimer;

  FLogFilePath := Format('%s\%s_' + FModuleName + '_%s.log', [FGENLOGPATH,
    FormatDateTime('yyyy_mm_dd', Date), FNom]);

  Init;
end;

destructor TFTPSite.Destroy;
begin
  Stop;

  FSiteTimer.Enabled := False;
  FreeAndNil(FSiteTimer);

  FInitializationTimer.Enabled := False;
  FreeAndNil(FInitializationTimer);

  FreeAndNil(FFiles);
end;

procedure TFTPSite.DoOnGetData;
begin
  if Assigned(FOnGetData) then
    FOnGetData(Self);
end;

procedure TFTPSite.DownLoadFiles;
var
  i: integer;
begin
  AddLog(Format('Début téléchargement : site %s', [FNom]), ftpllInfo);
  AddMonitoring('Début téléchargement fichiers', logNotice, mdltFTP, True);
  try
    try
      if not(FFTPGetData.SFTP) then
      begin
        if GenFTPConnection(FFTPGetData) then
        begin
          if GenFTPDownloadFile(FFTPGetData) then
          begin
            if (FFTPGetData.FileList.Count = 0) then
            begin
              AddLog('Aucun fichier à downloader', ftpllInfo);
            end
            else
            begin
              for i := 0 to FFTPGetData.FileList.Count - 1 do
              begin
                AddLog(Format('Téléchargement du fichier : "%s"', [FFTPGetData.FileList[i]]),
                  ftpllInfo);
              end;
            end;
          end;
        end;
      end
      else
      begin
        if GenSFTPConnection(FFTPGetData) then
        begin
          if GenSFTPDownloadFile(FFTPGetData) then
          begin
            if (FFTPGetData.FileList.Count = 0) then
            begin
              AddLog('Aucun fichier à downloader', ftpllInfo);
            end
            else
            begin
              for i := 0 to FFTPGetData.FileList.Count - 1 do
              begin
                AddLog(Format('Téléchargement du fichier : "%s"', [FFTPGetData.FileList[i]]),
                  ftpllInfo);
              end;
            end;
          end;
        end;
      end;
    except
      On E: Exception do
      begin
        AddMonitoring(E.Message, logError, mdltFTP);
        AddLog(E.Message, ftpllError);
      end;
    end;
  finally
    GenFTPClose;
  end;
  AddMonitoring('Fin téléchargement fichiers', logInfo, mdltFTP);
  AddLog(Format('Fin téléchargement : site %s', [FNom]), ftpllInfo);
end;

function TFTPSite.Enabled: boolean;
var
  query: TMyQuery;
begin
  query := GetNewQuery(FConnection);
  query.SQL.Text :=
    'SELECT UGG_ID ' +
    'FROM ' +
    '   uilgrpginkoiamag JOIN k ON (k_id=UGM_ID and K_enabled=1) ' +
    '   join uilgrpginkoia Join k on (k_id=UGG_ID and K_enabled=1) on (UGG_ID = UGM_UGGID) ' +
    'WHERE UGG_ID<>0 And UGG_NOM = :MODULENAME And UGM_MAGID= :MAGID';
  query.Params.ParamByName('MODULENAME').AsString := FModuleName;
  query.Params.ParamByName('MAGID').AsInteger := FMagId;
  query.Open;

  Result := not query.IsEmpty;

  query.Close;
end;

procedure TFTPSite.Execute;
begin
  if FSiteStatut = stWaiting then
  begin
    AddMonitoring('Début traitement', logNotice, mdltMain, True);
    AddLog(Format('%s : DEBUT TRAITEMENT', [FNom]), ftpllInfo);

    FSiteStatut := stExecuting;

    ExecuteExport;
    ExecuteImport;

    SendMail;

    AddMonitoring('Fin traitement', logInfo, mdltMain, False, Trunc(FSiteTimer.Interval/1000));

    FSiteStatut := stWaiting;

    AddLog(Format('%s : FIN TRAITEMENT', [FNom]), ftpllInfo);

    Refresh;
  end;
end;

procedure TFTPSite.ExecuteExport;
begin
  AddMonitoring('Début export', logNotice, mdltExport, True);
  WriteFiles(False);
  UploadFiles;
  Inc(FCptCycleTime);
  AddMonitoring('Fin export', logInfo, mdltExport);
end;

procedure TFTPSite.ExecuteImport;
begin
  AddMonitoring('Début import', logNotice, mdltImport);
  DownLoadFiles;
  GetFileListFromDir(FTPGetData.FileList, FTPGetData.SavePath, '*.TXT');
  ReadFiles;
  Inc(FCptCycleTime);
  AddMonitoring('Fin import', logInfo, mdltImport);
end;

procedure TFTPSite.ForceUpload;
begin
  if FSiteStatut = stWaiting then
    UploadFiles;
end;

function TFTPSite.WriteFile(AFile: TCustomFTPSendFile; AInitMode: Boolean): boolean;
begin
  AddLog(Format(MessCreationFichier, [AFile.DefaultFileName]), ftpllInfo);

  if AFile.Execute(FFTPSendData.SavePath, AInitMode, FCurrentVersionBase, FCurrentVersionLame) then
  begin
    if not RemoveEmptyFile(FFTPSendData.SavePath + AFile.FileName, AFile.WriteHeader) then
      AddLog(Format(MessFichierCree, [AFile.FileName]), ftpllInfo)
    else if AFile.FileName <> '' then
      AddLog(Format(MessFichierNonCree, [AFile.FileName]), ftpllInfo);
    UpdateVersionFile(AFile);
  end;
end;

procedure TFTPSite.Initialize;
begin
  if FSiteStatut = stWaiting then
  begin
    AddLog(Format('%s : DEBUT INITIALISATION', [FNom]), ftpllInfo);
    AddMonitoring('Début initialisation', logNotice, mdltMain);

    FSiteStatut := stInitialize;

    WriteFiles(True);
    UploadFiles;

    FSiteStatut := stWaiting;

    AddMonitoring('Fin initialisation', logInfo, mdltMain);
    AddLog(Format('%s : FIN INITIALISATION', [FNom]), ftpllInfo);

    Refresh;
  end;
end;

procedure TFTPSite.ReadFiles;
var
  i: integer;
  tmp_getfile: TCustomFTPGetFile;
begin
  AddLog(Format('%s : DEBUT : Traitement fichier téléchargé', [FNom]), ftpllInfo);

  DoOnGetData;

  for i := 0 to FFTPGetData.FileList.Count - 1 do
  begin
    tmp_getfile := FParent.getGetFile(FFTPGetData.FileList[i]);
    if Assigned(tmp_getfile) then
    begin
      try
        tmp_getfile.MagId := FMagId;
        tmp_getfile.OnLog := FilesLog;
        tmp_getfile.OnAddMonitoring := OnAddMonitoring;

        // La transaction c'est pour gérer les traitements sur K fait via l'unité
        // uGenerique et les fonctions NewK() et UpdateK()
        if Assigned(FParent.Transaction) then
          FParent.Transaction.StartTransaction;
        tmp_getfile.Execute( FFTPGetData.SavePath );
        if Assigned(FParent.Transaction) then
          FParent.Transaction.Commit;

        ArchiveFile( FFTPGetData.SavePath + tmp_getfile.FileName );
      except
        on E: TMonitoringException do
        begin
          if Assigned(FParent.Transaction) then
            FParent.Transaction.RollBack;

          AddMonitoring(E.Message, E.LogLevel, E.MdlType);
          ArchiveFile( FFTPGetData.SavePath + tmp_getfile.FileName, True );
        end;
        on E: Exception do
        begin
          if Assigned(FParent.Transaction) then
            FParent.Transaction.RollBack;

          AddMonitoring(E.Message, logError, mdltImport);
          AddLog(E.Message, ftpllError);
          ArchiveFile( FFTPGetData.SavePath + tmp_getfile.FileName, True );
        end;
      end;
      FreeAndNil(tmp_getfile);
    end
    else
    begin
      AddLog(Format('Type de fichier inconnu "%s"', [FFTPGetData.FileList[i]]), ftpllWarning);

      AddMonitoring(Format('Type de fichier inconnu "%s"', [FFTPGetData.FileList[i]]),
        logWarning, mdltImport);
    end;
  end;

  AddLog(Format('%s: FIN: Traitement fichier téléchargé', [FNom]), ftpllInfo);
end;

function TFTPSite.RemoveEmptyFile(AFilePath: string; Const AHeaderExist: Boolean): boolean;
var
  countline: integer;
  FLNC: TextFile;
begin
  Result:= False;
  countline := 0;

  if FileExists(AFilePath) then
  begin
    AssignFile(FLNC, AFilePath);
    Reset(FLNC);
    try
      while not Eof(FLNC) and (countline <= 1) do
      begin
        Inc(countline);
        Readln(FLNC);
      end;
    finally
      CloseFile(FLNC);
    end;

    if (countline = 0) or ((AHeaderExist) and (countline = 1)) then
    begin
      DeleteFileW(PWideChar(AFilePath));

      Result := True;
    end;
  end;
end;

function TFTPSite.SendMail: boolean;
begin
  if HasErrors  THEN
  begin
    if dm_Common.SendMail(FSMTPData, LogFilePath) then
    begin
      uCommon.DelFile(LogFilePath);
      HasErrors := False;
    end;
  end;
end;

procedure TFTPSite.StartTimers;
begin
  RefreshTimers;
end;

procedure TFTPSite.Stop;
begin
  AddMonitoring('Fermeture du module', logWarning, mdltMain);
  StopTimers;
end;

procedure TFTPSite.StopTimers;
begin
  FSiteTimer.Enabled := False;
  FInitializationTimer.Enabled := False;
end;

function TFTPSite.TestFTP: boolean;
begin
  if not(FFTPSendData.SFTP) then
    Result := GenFTPConnection(FFTPSendData)
  else
    Result := GenSFTPConnection(FFTPSendData);
end;

procedure TFTPSite.TestFTPConnection;
begin
  if FSiteStatut = stWaiting then
  begin
    try
      if not FFTPSendData.SFTP then
      begin
        try
          if GenFTPConnection(FFTPSendData) then
            AddLog(Format('%s : Test de connection FTP réussi', [FNom]), ftpllInfo);
        finally
          GenFTPClose;
        end;
      end
      else
      begin
        try
          if GenSFTPConnection(FFTPSendData) then
            AddLog(Format('%s : Test de connection SFTP réussi', [FNom]), ftpllInfo);
        finally
          GenSFTPClose;
        end;
      end;
    except
      on E: Exception do
      begin
        AddLog(E.Message, ftpllError);
      end;
    end;
  end;
end;

procedure TFTPSite.UploadFiles;
begin
  AddLog(Format('Debut : Upload site %s', [FNom]), ftpllInfo);
  AddMonitoring('Début upload', logNotice, mdltFTP, True);
  try
    try
      if not(FFTPSendData.SFTP) then
      begin
        AddLog('----- Transfert des fichiers CSV vers le FTP -----', ftpllInfo);
        if GenFTPConnection(FFTPSendData) then
        try
          GenFTPUploadFile(FFTPSendData);
        finally
          GenFTPClose;
        end;
      end
      else
      begin
        AddLog('----- Transfert des fichiers CSV vers le SFTP -----', ftpllInfo);
        if GenSFTPConnection(FFTPSendData) then
        try
          GenSFTPUploadFile(FFTPSendData);
        finally
          GenSFTPClose();
        end;
      end;
    except
      On E: Exception do
      begin
        AddMonitoring(E.Message, logError, mdltFTP);
        AddLog(E.Message, ftpllError);
      end;
    end;
  finally
    GenFTPClose;
  end;
  AddMonitoring('Fin upload', logInfo, mdltFTP);
  AddLog(Format('Fin : Upload site %s', [FNom]), ftpllInfo);
end;

function TFTPSite.UpdateVersionFile(AFile: TCustomFTPSendFile): boolean;
begin
  try
    AFile.UpdateVersions(FCurrentVersionBase, FCurrentVersionLame, FId);
    AddLog(Format('Mise à jour des versions pour le fichier %s', [AFile.DefaultFileName]), ftpllInfo);
  except
    on E: exception do
      Raise TMonitoringException.Create(
        Format('Impossible de mettre à jour les versions pour le fichier %s ()',
          [AFile.DefaultFileName, E.Message]), logError, FMonitoringAppType, mdltExport);
  end;
end;

procedure TFTPSite.WriteFiles(AInitMode: Boolean);
var
  i: integer;
begin
  AddLog(Format('Début : Ecriture site %s', [FNom]), ftpllInfo);
  AddMonitoring('Début écriture des fichiers', logNotice, mdltExport);

  if not Fparent.BypassGestionK then
    Refresh_K_Versions;

  if not DirectoryExists(FFTPSendData.SavePath) then
    ForceDirectories(FFTPSendData.SavePath);

  for i := 0 to FFiles.Count - 1 do
  begin
    try
      WriteFile(FFiles[i], AInitMode);
    except
      on E: TMonitoringException do
      begin
        AddMonitoring(E.Message, E.LogLevel, E.MdlType);
      end;
    end;
  end;

  AddMonitoring('Fin écriture des fichiers', logInfo, mdltExport);
  AddLog(Format('Fin : Ecriture site %s', [FNom]), ftpllInfo);
end;

procedure TFTPSite.Init;
begin
  LoadFTPParams;
  LoadSMTPParams;
  LoadGENPARAMs;
  LoadFiles;
end;

procedure TFTPSite.InitializationTimerTimer(Sender: TObject);
begin
  FInitializationTimer.Enabled := False;
  Initialize;
  Refresh;
  RefreshTimers;
end;

function TFTPSite.IsModule(aModule: String): Boolean;
var
  query: TMyQuery;
begin
  query := GetNewQuery(FConnection);
  query.SQL.Text :=
    'SELECT UGG_ID ' +
    'FROM ' +
    '   uilgrpginkoiamag JOIN k ON (k_id=UGM_ID and K_enabled=1) ' +
    '   join uilgrpginkoia Join k on (k_id=UGG_ID and K_enabled=1) on (UGG_ID = UGM_UGGID) ' +
    'WHERE UGG_ID<>0 And UGG_NOM = :MODULENAME And UGM_MAGID= :MAGID';
  query.Params.ParamByName('MODULENAME').AsString := aModule;
  query.Params.ParamByName('MAGID').AsInteger := FMagId;
  query.Open;

  Result := not query.IsEmpty;

  query.Close;
end;

procedure TFTPSite.Refresh;
begin
  FFiles.Clear;
  Init;
end;

procedure TFTPSite.RefreshDefaultMonitoringValues;
begin
  AddMonitoring('OK', logInfo, mdltMain, True);

  try
    if TestFTP then
      AddMonitoring('OK', logInfo, mdltFTP, True);
  except
    on E: Exception do
    begin
      AddMonitoring('Exception : ' + E.Message, logInfo, mdltFTP);
    end;
  end;
end;

procedure TFTPSite.RefreshInitializationTimer;
VAR
  hNextPeriode: TDateTime;
  iNextPeriodeMS: Integer;
begin
  if (FInitializationDate >= Now) and ( (FInitializationDate - Now) < 1 ) then
  begin
    hNextPeriode := FInitializationDate - Now;
    // On transforme en millisecondes
    iNextPeriodeMS := Trunc(hNextPeriode * 24 * 60 * 60 * 1000);

    FInitializationTimer.Interval := iNextPeriodeMS;
    FInitializationTimer.Enabled := True;

    AddLog('Prochaine Initialisation du ' + FModuleName + ' dans (ms) : ' + IntToStr(FInitializationTimer.Interval) +
      ' (' + FormatDateTime('HH:MM:SS', Now() + (FInitializationTimer.Interval /
      (24 * 60 * 60 * 1000))) + ')', ftpllInfo);
  end;
end;

procedure TFTPSite.RefreshSiteTimer;
VAR
  hNextPeriode: TDateTime;
  iNextPeriodeMS: Integer;
BEGIN
  FSiteTimer.Enabled := False;
  // Bloc de calcul de l'intervale du timer
  TRY
    // Pour ne faire qu'un seul traitement dans une plage horaire
    if (FIsOneShotCycleTime) and (FCptCycleTime >= 1) then
      begin
        hNextPeriode := ((Trunc(Now) + FStart + 1) - Now);

        // On transforme en millisecondes
        iNextPeriodeMS := Trunc(hNextPeriode * 24 * 60 * 60 * 1000);

        IF iNextPeriodeMS <= 0 THEN
          iNextPeriodeMS := 60 * 60 * 1000;

        // On set le prochain timer
        FSiteTimer.Interval := iNextPeriodeMS;
      end
    else
    // Est ce qu'on est en période de réplication
    IF (Trunc(Now) + FStart <= Now) AND (Now <= Trunc(Now) + FEnd) THEN
    BEGIN
      FSiteTimer.Interval := FDelai * 60 * 1000;
    END
    ELSE
    BEGIN
      // On set l'intervalle hors réplic
      // on calcule le prochain lancement, pour mettre l'intervalle comme il faut
        IF Trunc(Now) + FStart <= Now THEN
          hNextPeriode := ((Trunc(Now) + FStart + 1) - Now)
        ELSE
          hNextPeriode := (Trunc(Now) + FStart) - Now;

      // On transforme en millisecondes
      iNextPeriodeMS := Trunc(hNextPeriode * 24 * 60 * 60 * 1000);

      IF iNextPeriodeMS <= 0 THEN
        iNextPeriodeMS := 60 * 60 * 1000;

      // On set le prochain timer
      FSiteTimer.Interval := iNextPeriodeMS;

    END;
  EXCEPT
    ON E: Exception DO
    BEGIN
      // En cas d'exception, on relance le timer pour un intervale fixe, afin de réessayer
      FSiteTimer.Interval := FDelai * 60 * 1000;
    END;
  END;

  AddLog('Prochaine execution du ' + FModuleName + ' dans (ms) : ' + IntToStr(FSiteTimer.Interval) +
    ' (' + FormatDateTime('HH:MM:SS', Now() + (FSiteTimer.Interval /
    (24 * 60 * 60 * 1000))) + ')', ftpllInfo);

  FSiteTimer.Enabled := True;
end;

procedure TFTPSite.RefreshTimers;
begin
  RefreshSiteTimer;
  RefreshInitializationTimer;
end;

procedure TFTPSite.LoadGENPARAMs;
var
  query: TMyQuery;
begin
  query := GetNewQuery(FConnection);
  query.SQL.Text :=
    'SELECT * FROM GENPARAM ' +
    'WHERE PRM_TYPE IN (' + FPRM_TYPE + ') AND PRM_CODE IN (11, 12, 13, 14, 15) ' +
    '  AND PRM_MAGID = :MAGID';
  query.Params.ParamByName('MAGID').AsInteger := FMagId;
  query.Open;

  while not query.Eof do
  begin
    case query.FieldByName('PRM_CODE').AsInteger of
      11: FStart := StrToTime(query.FieldByName('PRM_STRING').AsString);
      12: FEnd := StrToTime(query.FieldByName('PRM_STRING').AsString);
      13: FDelai := query.FieldByName('PRM_INTEGER').AsInteger;
      14: FInitializationDate := StrToDateTime(query.FieldByName('PRM_STRING').AsString);
    end;
    query.Next;
  end;

  query.Close;
  query.Free;
end;

procedure TFTPSite.LoadSMTPParams;
var
  query: TMyQuery;
begin
  query := GetNewQuery(FConnection);
  query.SQL.Text :=
    'SELECT * ' +
    'FROM ARTSITEFTP JOIN K ON K.K_ID = ARTSITEFTP.ASF_ID AND K.K_ENABLED = 1 ' +
    'WHERE ASF_ASSID = :ASSID';
  query.Params.ParamByName('ASSID').AsInteger := FId;
  query.Open;

  if not query.IsEmpty then
  begin
    FSMTPData.Host := query.FieldByName('ASF_SMTPHOST').AsString;
    FSMTPData.Port := query.FieldByName('ASF_SMTPPORT').AsInteger;
    FSMTPData.User := query.FieldByName('ASF_SMTPUSER').AsString;
    FSMTPData.Password := query.FieldByName('ASF_SMTPPWD').AsString;
    FSMTPData.Expediteur := query.FieldByName('ASF_SMTPEXP').AsString;
    FSMTPData.Destinataires := query.FieldByName('ASF_SMTPDEST').AsString;
    FSMTPData.SecurityType := smtpTLS;
  end;

  Query.Close;
  Query.Free;
end;

procedure TFTPSite.PurgeArchives;
var
  current_month, current_year: word;
  del_year, del_month: word;

  S: TSearchRec;

  fos: TSHFileOpStruct;

  procedure RemoveDir(ADirPath: string; ASearchDirLength: integer;
    ACheckValue: word);
  begin
    // Recherche de la première entrée du répertoire
    If FindFirst(ADirPath + '*', faDirectory, S) = 0 Then
    Begin
      Repeat
        // Il faut absolument dans le cas d'une procédure récursive ignorer
        // les . et .. qui sont toujours placés en début de répertoire
        // Sinon la procédure va boucler sur elle-même.
        If (S.Name<>'.')And(s.Name<>'..') Then
        Begin
          If (S.Attr And faDirectory) <> 0 then
          begin
            try
              if (Length(S.Name) = ASearchDirLength) and (StrToIntDef(S.Name, -1) <> -1) then
              begin
                if StrToIntDef(S.Name, -1) < ACheckValue then
                begin
                  ZeroMemory(@fos, SizeOf(fos));
                  with fos do begin
                    wFunc := FO_DELETE;
                    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
                    pFrom := PChar(ADirPath + '\' + S.Name + #0);
                  end;
                  ShFileOperation(fos);
                end;
                if StrToIntDef(S.Name, -1) = ACheckValue then
                begin
                  if ASearchDirLength = 4 then
                    RemoveDir(ADirPath + '\' + S.Name + '\', 2, del_month)
                  else
                  begin
                    ZeroMemory(@fos, SizeOf(fos));
                    with fos do begin
                      wFunc := FO_DELETE;
                      fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
                      pFrom := PChar(ADirPath + '\' + S.Name + #0);
                    end;
                    ShFileOperation(fos);
                  end;
                end;
              end;
            except
              on E: Exception do
                AddLog(E.Message, ftpllWarning);
            end;
            //TODO regarder si il faut purger le dossier
          end;
        End;
      // Recherche du suivant
      Until FindNext(S) <> 0;
      FindClose(S);
    End
  end;
begin
  current_year := YearOf(Now);
  current_month := MonthOf(Now);

  del_year := current_year;
  del_month := current_month;

  Dec(del_month, 2);
  if del_month <= 0 then
  begin
    del_month := 12 - del_month;
    Dec(del_year, 1);
  end;

  RemoveDir(FFTPGetData.SavePath, 4, del_year);
end;

procedure TFTPSite.Refresh_K_Versions;
begin
  // Mise à jour des plages d'id de la base de données
  dm_common.PlagesBase;

  // Récupère le CURRENT_VERSION
  if Dm_Common.Gestion_K_VERSION = tKV64 then
  begin
    if Dm_Common.Que_VersionID.Active then
      Dm_Common.Que_VersionID.Close();
    Dm_Common.Que_VersionID.Open();

    FCurrentVersionBase := Dm_Common.Que_VersionID.FieldByName('CURRENT_VERSION').AsLargeInt;

    Dm_Common.Que_VersionID.Close();
  end
  else
  begin
    if Dm_Common.Que_GeneralId.Active then
      Dm_Common.Que_GeneralId.Close();
    Dm_Common.Que_GeneralId.Open();

    FCurrentVersionBase := Dm_Common.Que_GeneralId.FieldByName('CURRENT_VERSION').AsLargeInt;

    Dm_Common.Que_GeneralId.Close();
  end;

  if FCurrentVersionBase = 0 then
    // Récupère le CURRENT_VERSION le plus bas de la plage si besoin
    FCurrentVersionBase := Dm_Common.PlageBase.Debut;

  // Récupère le CURRENT_VERSION de la Lame
  try
    if Dm_Common.Que_CurrentVersionPlage.Active then
      Dm_Common.Que_CurrentVersionPlage.Close();
    Dm_Common.Que_CurrentVersionPlage.ParamByName('DEBUT_PLAGE').AsLargeInt := Dm_Common.PlageLame.Debut;
    Dm_Common.Que_CurrentVersionPlage.ParamByName('FIN_PLAGE').AsLargeInt   := Dm_Common.PlageLame.Fin;
    Dm_Common.Que_CurrentVersionPlage.Open();
    FCurrentVersionLame := Dm_Common.Que_CurrentVersionPlage.FieldByName('CURRENT_VERSION').AsLargeInt;
  finally
    Dm_Common.Que_CurrentVersionPlage.Close();
    Dm_Common.Que_CurrentVersionPlage.IB_Transaction.Commit;
  end;
end;

procedure TFTPSite.SiteTimerTimer(Sender: TObject);
begin
  { On demande au parent si le FTP est occupé. Si ce n'est pas le cas, la
    fonction va mettre le commutateur Busy à True et renvoyer False }
  if FParent.FTPIsBusy(FNom) then
    begin
      AddLog(Format('FTP occupé : site %s - Le traitement sera effectué au prochain cycle.', [FNom]), ftpllInfo);
      Exit;
    end;

  try
    try
      FSiteTimer.Enabled := False;
      Execute;
    except
      On E: Exception do
        AddLog(E.Message);
    end;
  finally
    { On informe le parent afin qu'il mette le commutateur Busy à False }
    FParent.FTPFinish(FNom);

    Refresh;
    RefreshTimers;
  end;
end;

procedure TFTPSite.Start;
begin
  if Enabled then
  begin
    AddMonitoring('Démarrage site ' + FNom + ': module ' + FModuleName, logInfo, mdltMain, True);
    PurgeArchives;
    StartTimers;
  end
  else
  begin
    AddLog(Format( 'Impossible de démarrer le site %s : Module "' + FModuleName + '" non actif',
      [FNom]), ftpllWarning);
    AddMonitoring(Format( 'Impossible de démarrer le site %s : Module "' + FModuleName + '" non actif',
      [FNom]), logWarning, mdltMain);
  end;
end;

procedure TFTPSite.FilesLog(Sender: TObject; ALog: string;
  AFTPLogLvl: TFTPLogLevel);
begin
  if Assigned(FFTPLogEvent) then
    FFTPLogEvent(self, ALog, AFTPLogLvl);
end;

procedure TFTPSite.LoadFiles;
var
  index: integer;
  query: TMyQuery;
  tmpfile: TCustomFTPSendFile;
begin
  query := GetNewQuery(FConnection);
  query.SQL.Text :=
    'SELECT * ' +
    'FROM ARTEXPORTWEB JOIN K ON K.K_ID = ARTEXPORTWEB.AWE_ID AND K.K_ENABLED = 1 ' +
    'WHERE AWE_ASSID = :ASSID AND AWE_ACTIF > 0';
  query.Params.ParamByName('ASSID').AsInteger := FId;
  query.Open;

  while not query.Eof do
  begin
    index := FFiles.IndexOf(query.FieldByName('AWE_FICHIER').AsString);
    if index = -1 then
    begin
      tmpfile := FParent.getSendFile(query.FieldByName('AWE_FICHIER').AsString);
      if Assigned(tmpfile) then
      begin
        tmpfile.ASSID:= Fid;
        tmpfile.MagId := FMagId;
        tmpfile.OnLog := FilesLog;
        tmpfile.OnAddMonitoring := OnAddMonitoring;
        index := FFiles.Add(tmpfile);
      end;
    end;

    if index <> -1 then
    begin
      FFiles[index].addVersion(query.FieldByName('AWE_MAGID').AsInteger,
        query.FieldByName('AWE_ID').AsInteger,
        query.FieldByName('AWE_LASTVERSION').AsLargeInt,
        query.FieldByName('AWE_DATEEXPORT').AsDateTime);
    end
    else
    begin
      AddLog(Format('Fichier "%s" inconnu du ' + FModuleName,
        [query.FieldByName('AWE_FICHIER').AsString]), ftpllWarning);
      AddMonitoring(Format('Fichier "%s" inconnu du ' + FModuleName,
        [query.FieldByName('AWE_FICHIER').AsString]), logWarning, mdltExport);
    end;

    query.Next;
  end;

  query.Close;
  query.Free;
end;

procedure TFTPSite.LoadFTPParams;
var
  query: TMyQuery;
  vPathSendSource, vPathGetSource: String;
  vModuleName : String;
begin
  query := GetNewQuery(FConnection);
  query.SQL.Text :=
    'SELECT * ' +
    'FROM ARTSITEFTP JOIN K ON K.K_ID = ARTSITEFTP.ASF_ID AND K.K_ENABLED = 1 ' +
    'WHERE ASF_ASSID = :ASSID';
  query.Params.ParamByName('ASSID').AsInteger := FId;
  query.Open;

  if not query.IsEmpty then
  begin
    FFTPSendData.Host := query.FieldByName('ASF_FTPHOST').AsString;
    FFTPGetData.Host := query.FieldByName('ASF_FTPHOST').AsString;

    FFTPSendData.User := query.FieldByName('ASF_FTPUSER').AsString;
    FFTPGetData.User := query.FieldByName('ASF_FTPUSER').AsString;

    FFTPSendData.Psw := query.FieldByName('ASF_FTPPWD').AsString;
    FFTPGetData.Psw := query.FieldByName('ASF_FTPPWD').AsString;

    FFTPSendData.Port := query.FieldByName('ASF_FTPPORT').AsInteger;
    FFTPGetData.Port := query.FieldByName('ASF_FTPPORT').AsInteger;

    FFTPSendData.SFTP := query.FieldByName('ASF_FTPSFTP').AsInteger = 1;
    FFTPGetData.SFTP := query.FieldByName('ASF_FTPSFTP').AsInteger = 1;

    FFTPSendData.FTPDirectory := query.FieldByName('ASF_DOSSIERFTP').AsString;
    if LeftStr(FFTPSendData.FTPDirectory, 1) <> '/' then
      FFTPSendData.FTPDirectory := '/' + FFTPSendData.FTPDirectory;
  end;

  Query.Close;
  Query.Free;

  FFTPSendData.FileFilter := '*.' + FExtension;
  FFTPGetData.FileFilter := '*.' + FExtension;

  FFTPSendData.bDeleteFile := False;
  FFTPGetData.bDeleteFile := True;

  FFTPSendData.bArchiveFile := True;
  FFTPGetData.bArchiveFile := True;

  FFTPSendData.FileList := TSTringList.Create;
  FFTPGetData.FileList := TSTringList.Create;


  if IsModule('EXPORT_TEMPSDESCERISES') then
    vModuleName := 'EXPORT_TEMPSDESCERISES'
  else
    vModuleName := FModuleName;

  vPathSendSource:= '\GIN_TO_' + vModuleName + '\';
  vPathGetSource:= '\' + vModuleName + '_TO_GIN\';

  //Mise à jour des données spécififque
  FFTPSendData.SourcePath := FGENPATH + FNom + vPathSendSource;
  FFTPGetData.SourcePath := FGENPATH + FNom + vPathGetSource;

  FFTPSendData.SavePath := FGENPATH + FNom + vPathSendSource;
  FFTPGetData.SavePath := FGENPATH + FNom + vPathGetSource;

  if not DirectoryExists(FGENPATH) then
    ForceDirectories(FGENPATH);

  if not DirectoryExists(FGENPATH + FNom) then
    ForceDirectories(FGENPATH + FNom);

  if not DirectoryExists(FGENPATH + FNom + vPathSendSource) then
    ForceDirectories(FGENPATH + FNom + vPathSendSource);

  if not DirectoryExists(FGENPATH + FNom + vPathGetSource) then
    ForceDirectories(FGENPATH + FNom + vPathGetSource);

  vPathSendSource:= FFTPSendData.FTPDirectory + '/GIN_TO_' + vModuleName + '/';
  vPathGetSource:= FFTPSendData.FTPDirectory + '/' + vModuleName + '_TO_GIN/';

  FFTPSendData.FTPDirectory := vPathSendSource;
  FFTPGetData.FTPDirectory := vPathGetSource;

end;

end.

