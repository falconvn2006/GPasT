unit UBaseThread;

interface

uses
  System.Classes,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  FireDAC.Phys,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.IBWrapper,
  uCreateProcess;

const
  URL_SERVEUR_MAJ = 'http://lame2.ginkoia.eu';
  CST_EXENAME_GINKOIA = 'Ginkoia.exe';
  CST_SCRIPT_NAME = 'Script.scr';

type
  TAskReply = (ear_Unknown, ear_Yes, ear_No);

type
  TNiveauLog = (enl_Noise, enl_Info, enl_Phase, enl_Warning, enl_Error);

type
  TBaseThread = class(TThread)
  strict private
    // Logs
    FFileLog : string;
    FLogs : TStringList;
    // communication via std in/out/err
    FStdStream : TStdStream;
  protected
    // affichage de progression
    FProgress : TProgressBar;
    FStepLbl : TLabel;
    FMaxProgress, FCurProgress, FPrcProgress : integer;
    FStyleProgress : TProgressBarStyle;
    FStepProgress : string;
    // ajout dans les logs
    procedure DoLog(Msg : string; Niveau : TNiveauLog = enl_Noise); overload;
    procedure DoLog(Msgs : TStringList; Niveau : TNiveauLog = enl_Noise); overload;
    // Téléchargement de fichier !
    function DownloadHTTP(const AUrl, FileName : string; MaxTry : integer = 3; Tempo : integer = 5000) : boolean; virtual;
    // Zip et dezip
    function Do7Zip(FileNames : TStringList; ZipName : string) : boolean; virtual;
    function DoUn7Zip(DestPath, ZipName : string) : boolean; overload; virtual;
    function DoUn7Zip(DestPath, ZipName : string; CLSID : TGUID) : boolean; overload; virtual;
    // Ajout dans le log
    procedure LogDriverMessage(ASender: TFDPhysDriverService; const AMessage: String);
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog : string; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
    destructor Destroy(); override;
    // gestion des bar de progression
    // Attention a bien faire dans un Synchronize !!
    procedure ProgressInit(); overload;
    procedure ProgressInit(NbStep : integer; Style : TProgressBarStyle = pbstNormal); overload; // overload pour gestion de la synchro
    procedure ProgressStyle(); overload;
    procedure ProgressStyle(Style : TProgressBarStyle); overload; // overload pour gestion de la synchro
    procedure ProgressStepLbl(); overload;
    procedure ProgressStepLbl(StepTxt : string); overload; // overload pour gestion de la synchro
    // Celle ci non, poste de message pas besoin de synchronize !!
    procedure ProgressStepIt();
    // recuperation deu libelle d'erreur
    function GetErrorLibelle(ret : integer) : string; virtual; abstract;
    // Sauvegarde du fichier de log !
    procedure SaveLog();
    // retour ?
    property ReturnValue;
    // fichier de log ?
    property FileLog : string read FFileLog;
  end;

  TBaseIBThread = class(TBaseThread)
  protected
    // connexion BDD
    FServeur : string;
    FDataBase : string;
    FPort : integer;
    // Fonctions de "controle" de base
    function DoActivation(Online : boolean) : boolean; virtual;
    function DoValidate(FileBase : string) : boolean; virtual;
    function DoGFix(FileBase : string; PageBuffers : cardinal = 4096) : boolean; virtual;
    // Fonctions de backup/retore
    function DoBackup(FileBase, FileSave : string; Options : TIBBackupOptions = []) : boolean; virtual;
    function DoRestore(FileBase, FileSave : string; Options : TIBRestoreOptions = [roReplace, roValidate]; PageBuffers : cardinal = 4096; PageSize : cardinal = 4096) : boolean; virtual;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
  end;

implementation

uses
  Winapi.Windows,
  Winapi.CommCtrl,
  System.SysUtils,
  System.Math,
  FireDAC.Comp.Client,
  IdURI,
  IdHTTP,
  IdCompressorZLib,
  uSevenZip,
  uDownloadHTTP,
  uGestionBDD;

{ TBaseThread }

procedure TBaseThread.DoLog(Msg : string; Niveau : TNiveauLog);
begin
  FLogs.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now()) + ' - ' + Msg);
  if Assigned(FStdStream) then
  begin
    case Niveau of
//      enl_Noise   : FStdStream.StdErr.Writeln(Msg);
//      enl_Info    : FStdStream.StdErr.Writeln(Msg);
      enl_Phase   : FStdStream.StdErr.Writeln('PHASE ' + Msg);
      enl_Warning : FStdStream.StdErr.Writeln('WARNING ' + Msg);
      enl_Error   : FStdStream.StdErr.Writeln('ERROR ' + Msg);
    end;
  end;
end;

procedure TBaseThread.DoLog(Msgs : TStringList; Niveau : TNiveauLog);
var
  i : integer;
begin
  for i := 0 to Msgs.Count -1 do
    DoLog(Msgs[i], Niveau);
end;

function TBaseThread.DownloadHTTP(const AUrl, FileName : string; MaxTry : integer; Tempo : integer) : boolean;
var
  NbTry : integer;
begin
  Result := false;
  NbTry := 0;
  while not Result and (NbTry < MaxTry) do
  begin
    try
      Result := UDownloadHTTP.DownloadHTTP(AUrl, FileName);
      if not Result then
      begin
        DoLog('Erreur de téléchargement (Tentative ' + IntToStr(NbTry +1) + ' sur ' + IntToStr(MaxTry) + ')');
        Sleep(Tempo);
        Inc(NbTry);
      end;
    except
      on e : Exception do
      begin
        DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message + ' (Tentative ' + IntToStr(NbTry +1) + ' sur ' + IntToStr(MaxTry) + ')');
        Sleep(Tempo);
        Inc(NbTry);
      end;
    end;
  end;
end;

function TBaseThread.Do7Zip(FileNames : TStringList; ZipName : string) : boolean;
var
  SevenZip : I7zOutArchive;
  i : integer;
begin
  Result := false;

  try
    if FileExists(ZipName) then
      DeleteFile(ZipName);
    try
      SevenZip := CreateOutArchive(CLSID_CFormat7z);
      for i := 0 to FileNames.Count -1 do
        SevenZip.AddFiles(ExtractFilePath(FileNames[i]), '', ExtractFileName(FileNames[i]), false);
      SevenZip.SaveToFile(ZipName);
      Result := true;
    finally
      SevenZip := nil;
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TBaseThread.DoUn7Zip(DestPath, ZipName : string) : boolean;
var
  SevenZip : I7zInArchive;
begin
  Result := false;

  try
    try
      if UpperCase(ExtractFileExt(ZipName)) = '.7Z' then
        SevenZip := CreateInArchive(CLSID_CFormat7z)
      else
        SevenZip := CreateInArchive(CLSID_CFormatZip);
      SevenZip.OpenFile(ZipName);
      SevenZip.ExtractTo(DestPath);
      Result := true;
    finally
      SevenZip := nil;
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TBaseThread.DoUn7Zip(DestPath, ZipName : string; CLSID : TGUID) : boolean;
var
  SevenZip : I7zInArchive;
begin
  Result := false;

  try
    try
      SevenZip := CreateInArchive(CLSID);
      SevenZip.OpenFile(ZipName);
      SevenZip.ExtractTo(DestPath);
      Result := true;
    finally
      SevenZip := nil;
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

procedure TBaseThread.LogDriverMessage(ASender: TFDPhysDriverService; const AMessage: String);
begin
  DoLog(AMessage);
end;

constructor TBaseThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog : string; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false);
begin
  Inherited Create(CreateSuspended);
  OnTerminate := OnTerminateThread;
  FStdStream := StdStream;
  FFileLog := FileLog;
  FProgress := Progress;
  FStepLbl := StepLbl;
  FLogs := TStringList.Create();
  FreeOnTerminate := Assigned(OnTerminate);
  // bar de progression
  FStyleProgress := pbstNormal;
  FCurProgress := 0;
  FPrcProgress := 0;
  FMaxProgress := 100;
end;

destructor TBaseThread.Destroy();
begin
  FreeAndNil(FLogs);
  Inherited Destroy();
end;

procedure TBaseThread.ProgressInit();
begin
  if Assigned(FProgress) then
  begin
    // progression
    FProgress.Style := FStyleProgress;
    FProgress.Position := 0;
    FProgress.Step := 1;
    FProgress.Max := 100;
    // hint
    FProgress.Hint := '';
    FProgress.ShowHint := false;
  end;
end;

procedure TBaseThread.ProgressInit(NbStep : integer; Style : TProgressBarStyle);
begin
  FStyleProgress := Style;
  FMaxProgress := NbStep;
  FCurProgress := 0;
  FPrcProgress := 0;
  if Assigned(FProgress) then
    Synchronize(ProgressInit);
end;

procedure TBaseThread.ProgressStyle();
begin
  if Assigned(FProgress) then
    FProgress.Style := FStyleProgress;
end;

procedure TBaseThread.ProgressStyle(Style : TProgressBarStyle);
begin
  FStyleProgress := Style;
  if Assigned(FProgress) then
    Synchronize(ProgressStyle);
end;

procedure TBaseThread.ProgressStepLbl();
begin
  if Assigned(FStepLbl) then
  begin
    FStepLbl.Caption := FStepProgress;
    FStepLbl.Update();
  end;
end;

procedure TBaseThread.ProgressStepLbl(StepTxt : string);
begin
  FStepProgress := StepTxt;
  DoLog(FStepProgress);
  if Assigned(FStepLbl) then
    Synchronize(ProgressStepLbl);
end;

procedure TBaseThread.ProgressStepIt();
begin
  // position actuelle
  FCurProgress := Min(FCurProgress +1, FMaxProgress);
  // pourcentage de progression
  if FPrcProgress <> Round(FCurProgress * 100.0 / FMaxProgress) then
  begin
    FPrcProgress := Round(FCurProgress * 100.0 / FMaxProgress);
    // gestion de la progress
    if Assigned(FProgress) then
    begin
      if FStyleProgress = pbstMarquee then
        PostMessage(FProgress.Handle, PBM_STEPIT, 0, 0)
      else
        PostMessage(FProgress.Handle, PBM_SETPOS, FPrcProgress, 0);
    end;
    // gestion du STDERR
    if Assigned(FStdStream) then
      FStdStream.StdErr.Writeln('PROGRESS ' + IntToStr(FPrcProgress));
  end;
end;

procedure TBaseThread.SaveLog();
begin
  ForceDirectories(ExtractFileDir(FFileLog));
  FLogs.SaveToFile(FFileLog);
end;

{ TBaseIBThread }

function TBaseIBThread.DoActivation(Online : boolean) : boolean;
var
  DriverLink : TFDPhysIBBaseDriverLink;
  Config : TFDIBConfig;
begin
  Result := false;

  try
    try
      DriverLink := TFDPhysIBBaseDriverLink.Create(nil);
      DriverLink.DriverID := 'IB';
      Config := TFDIBConfig.Create(nil);
      Config.DriverLink := DriverLink;
      Config.Protocol := ipTCPIP;
      Config.Host := FServeur;
      Config.Database := FDataBase;
      Config.UserName := CST_BASE_LOGIN;
      Config.Password := CST_BASE_PASSWORD;
      if FPort <> CST_BASE_PORT then
        Config.Port := FPort;
      Config.OnProgress := LogDriverMessage;

      if Online then
        Config.OnlineDB()
      else
        Config.ShutdownDB(smForce, 5);
      Result := true;
    finally
      FreeAndNil(Config);
      FreeAndNil(DriverLink);
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TBaseIBThread.DoValidate(FileBase : string) : boolean;
var
  DriverLink : TFDPhysIBBaseDriverLink;
  Validate : TFDIBValidate;
begin
  Result := false;

  try
    try
      DriverLink := TFDPhysIBBaseDriverLink.Create(nil);
      DriverLink.DriverID := 'IB';
      Validate := TFDIBValidate.Create(nil);
      Validate.DriverLink := DriverLink;
      Validate.Options := [roValidateFull];
      Validate.Protocol := ipTCPIP;
      Validate.Host := FServeur;
      Validate.Database := FileBase;
      Validate.UserName := CST_BASE_LOGIN;
      Validate.Password := CST_BASE_PASSWORD;
      if FPort <> CST_BASE_PORT then
        Validate.Port := FPort;
      Validate.OnProgress := LogDriverMessage;

      Validate.Sweep();
      Validate.Repair();
      Result := true;
    finally
      FreeAndNil(Validate);
      FreeAndNil(DriverLink);
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TBaseIBThread.DoGFix(FileBase : string; PageBuffers : cardinal) : boolean;
var
  DriverLink : TFDPhysIBBaseDriverLink;
  Config : TFDIBConfig;
begin
  Result := false;

  try
    try
      DriverLink := TFDPhysIBBaseDriverLink.Create(nil);
      DriverLink.DriverID := 'IB';

      Config := TFDIBConfig.Create(nil);
      Config.DriverLink := DriverLink;
      Config.Protocol := ipTCPIP;
      Config.Host := FServeur;
      Config.Database := FileBase;
      Config.UserName := CST_BASE_LOGIN;
      Config.Password := CST_BASE_PASSWORD;
      if FPort <> CST_BASE_PORT then
        Config.Port := FPort;
      Config.OnProgress := LogDriverMessage;
      Config.SetPageBuffers(PageBuffers);
      Config.SetSweepInterval(0);
      Config.SetWriteMode(wmAsync);
      Config.SetAccessMode(amReadWrite);

      Result := true;
    finally
      FreeAndNil(Config);
      FreeAndNil(DriverLink);
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TBaseIBThread.DoBackup(FileBase, FileSave : string; Options : TIBBackupOptions) : boolean;
var
  DriverLink : TFDPhysIBBaseDriverLink;
  Backup : TFDIBBackup;
begin
  Result := false;

  // Options :
  // boIgnoreChecksum   : Ignores checksums during backup; Note: InterBase supports true checksums only for ODS 8 and earlier.
  // boIgnoreLimbo      : Ignores limbo transactions during backup.
  // boMetadataOnly     : Backs up metadata only, no data.
  // boNoGarbageCollect : This option instructs the server not to perform garbage collection on every record it visits. This enables the server to retrieve records faster, and to send them to the gbak client for archiving.
  // boOldDescriptions  : Backs up metadata in old-style format.
  // boNonTransportable : Creates the backup in nontransportable format.
  // boConvert          : Converts external files as internal tables.
  // boExpand           : Creates a noncompressed back up.

  try
    try
      DriverLink := TFDPhysIBBaseDriverLink.Create(nil);
      DriverLink.DriverID := 'IB';

      Backup := TFDIBBackup.Create(nil);
      Backup.InstanceName:='service_mgr';
      Backup.DriverLink := DriverLink;
      Backup.Protocol := ipTCPIP;
      Backup.Host := FServeur;
      Backup.Database := FileBase;
      Backup.UserName := CST_BASE_LOGIN;
      Backup.Password := CST_BASE_PASSWORD;
      if FPort <> CST_BASE_PORT then
        Backup.Port := FPort;

      Backup.Verbose := true;
      Backup.OnProgress := LogDriverMessage;

      Backup.Options := Options;

      Backup.BackupFiles.Add(FileSave);
      Backup.Backup();
      Result := true;
    finally
      FreeAndNil(Backup);
      FreeAndNil(DriverLink);
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

function TBaseIBThread.DoRestore(FileBase, FileSave : string; Options : TIBRestoreOptions; PageBuffers : cardinal; PageSize : cardinal) : boolean;
var
  DriverLink : TFDPhysIBBaseDriverLink;
  Restore : TFDIBRestore;
begin
  Result := false;

  // Options :
  // roDeactivateIdx  : Makes indexes inactive upon restore.
  // roNoShadow       : Does not create any shadows that were previously defined.
  // roNoValidity     : Deletes validity constraints from restored metadata; allows restoration of data that would otherwise not meet validity constraints.
  // roOneAtATime     : Restores one table at a time; useful for partial recovery if database contains corrupt data.
  // roReplace        : Restores database to new file or replaces existing file.
  // roUseAllSpace    : Restores database with 100% fill ratio on every data page. By default, space is reserved for each row on a data page to accommodate a back version of an UPDATE or DELETE. Depending on the size of the compressed rows, that could translate e to any percentage.
  // roValidate       : Use to validate the database when restoring it.
  // roFixFSSData     :
  // roFixFSSMetaData :
  // roMetaDataOnly   : Restore metadata only, no data.

  try
    try
      DriverLink := TFDPhysIBBaseDriverLink.Create(nil);
      DriverLink.DriverID := 'IB';

      Restore := TFDIBRestore.Create(nil);
      Restore.InstanceName:='service_mgr';
      Restore.DriverLink := DriverLink;
      Restore.Protocol := ipTCPIP;
      Restore.Host := FServeur;
      Restore.Database := FileBase;
      Restore.UserName := CST_BASE_LOGIN;
      Restore.Password := CST_BASE_PASSWORD;
      if FPort <> CST_BASE_PORT then
        Restore.Port := FPort;

      Restore.Verbose := true;
      Restore.OnProgress := LogDriverMessage;

      Restore.Options := Options;
      Restore.PageBuffers := PageBuffers;  // n'améliore pas les Perf
      Restore.PageSize := PageSize;

      Restore.BackupFiles.Add(FileSave);
      Restore.Restore();
      Result := true;
    finally
      FreeAndNil(Restore);
      FreeAndNil(DriverLink);
    end;
  except
    on e : Exception do
      DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
  end;
end;

constructor TBaseIBThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Progress, StepLbl, CreateSuspended);
  FServeur := Serveur;
  FDataBase := DataBase;
  FPort := Port;
end;

end.
