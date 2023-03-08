unit UTraitement_Thread_UIB;

interface

uses
  System.Classes, System.SysUtils, uib;

type
  TRepareBasesThreadMessageEvent = procedure(Sender: TObject; const AMessage: String) of object;
  TRepareBasesThreadCopyProgressEvent = procedure(Sender: TObject; const APercent: Integer) of object;

  TRepareBaseOption = (rbInfo, rbShutDown, rbCopy, rbBackup, rbRestore, rbValidate, rbMend, rbOnline);
  TRepareBaseOptions = set of TRepareBaseOption;

  TRepareBaseThread = class(TThread)
  private
    FOptions: TRepareBaseOptions;
    FDbFileName: string;
    FDBCopyFileName: string;
    FBackupFileName: string;
    FRestoreFileName: string;
    FLogFileName: string;
    FErrorMessage: string;
    FStep: TRepareBaseOption;
    FStatus: string;
    FMessage: string;
    FCopyProgress: Integer;
    FOnChange: TNotifyEvent;
    FOnProgress: TRepareBasesThreadMessageEvent;
    FOnError: TRepareBasesThreadMessageEvent;
    FOnStepProgress: TNotifyEvent;
    FOnCopyProgress: TRepareBasesThreadCopyProgressEvent;
    function CheckParams: Boolean;
    function GetProtocol(Protocol: String): TUIBProtocol;
    procedure DoChange;
    procedure DoError;
    procedure DoCopyProgress;
    procedure DoProgress;
    procedure DoStepProgress;
    procedure SetStatus(const Value: string);
    procedure SetStep(const Value: TRepareBaseOption);
    procedure UIBSvcVerbose(Sender: TObject; Message: string);
  public
    constructor Create;
    function DbInfos: Boolean;
    function DbShutDown: Boolean;
    function DbCopy: Boolean;
    function DbOnline: Boolean;
    function DbValidate: Boolean;
    function DbRepair: Boolean;
    function DbBackup: Boolean;
    function DbRestore: Boolean;
    procedure Execute; override;
    property DBFileName: string read FDBFileName write FDBFileName;
    property DBCopyFileName: string read FDBCopyFileName write FDBCopyFileName;
    property BackupFileName: string read FBackupFileName write FBackupFileName;
    property RestoreFileName: string read FRestoreFileName write FRestoreFileName;
    property LogFileName: string read FLogFileName write FLogFileName;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnCopyProgress: TRepareBasesThreadCopyProgressEvent read FOnCopyProgress write FOnCopyProgress;
    property OnError: TRepareBasesThreadMessageEvent read FOnError write FOnError;
    property OnProgress: TRepareBasesThreadMessageEvent read FOnProgress write FOnProgress;
    property OnStepProgress: TNotifyEvent read FOnStepProgress write FOnStepProgress;
    property Options: TRepareBaseOptions read FOptions write FOptions;
    property Step: TRepareBaseOption read FStep write SetStep;
    property Status: string read FStatus write SetStatus;
  end;


implementation

uses
  System.StrUtils, Winapi.Windows,
  UParams, UUtils;

{ TRepareBaseThread }

function TRepareBaseThread.CheckParams: Boolean;
begin
  //
  Result := (TrimRight(FDbFileName) <> '') and
            FileExists(FDbFileName);
end;

constructor TRepareBaseThread.Create();
begin
  inherited Create(True);
  // Paramètres par défaut
  FOptions := [];

  FStatus := '';
end;


function TRepareBaseThread.DbBackup: Boolean;
var
  UIBBackup: TUIBBackup;
begin
  Result := False;
  Step := rbBackup;
  Status := 'Sauvegarde de la base de données démarrée';

  //
  if not CheckParams then
    Exit;

  UIBBackup := TUIBBackup.Create(nil);
  try
    UIBBackup.Database := FDbFileName;
    UIBBackup.UserName := SRepareBase.DBUser;
    UIBBackup.PassWord := SRepareBase.DBPassWord;
    UIBBackup.Host := SRepareBase.Host;
    UIBBackup.Protocol := proLocalHost;
    UIBBackup.LibraryName := SRepareBase.LibraryName;
    //
    UIBBackup.BackupFiles.Add(FBackupFileName);
    UIBBackup.Verbose := True;
    UIBBackup.OnVerbose := UIBSvcVerbose;
    //
    UIBBackup.Run;
  finally
    UIBBackup.Free;
  end;
  //
  Status := 'Sauvegarde de la base de données terminée';
  Result := True;
end;

function TRepareBaseThread.DbCopy: Boolean;
var
  Canceled: Boolean;
  //
  function CopyProgress(TotalFileSize, TotalBytesTransferred, StreamSize, StreamBytesTransferred: Int64;
                        dwStreamNumber, dwCallbackReason: DWORD;
                        hSourceFile, hDestinationFile: THandle;
                        RBThread: TRepareBaseThread): DWORD; stdcall;
  begin
    Result := PROGRESS_CONTINUE;
    RBThread.FCopyProgress := TotalBytesTransferred * 100 div TotalFileSize;
    RBThread.Synchronize(RBThread.DoCopyProgress);
  end;
begin
  Result := False;
  Step := rbCopy;
  Status := 'Copie de la base de données demandée';
  //
  if not CheckParams then
    Exit;
  //
  Canceled := False;
  SetLastError(ERROR_SUCCESS);
  FMessage := 'Copie en cours...';
  Synchronize(DoProgress);
  if CopyFileEx(PChar(FDbFileName), PChar(FDBCopyFileName), @CopyProgress, Self, PBool(Canceled), 0) then
    FMessage := 'Copie terminée...'
  else
    FMessage := 'Copie annulée...'#13#10 + SysErrorMessage(GetLastError);
  Synchronize(DoProgress);
  //
  Status := 'Copie de la base de données effectuée';
  Result := True;
end;

function TRepareBaseThread.DbInfos: Boolean;
var
  UIBCnx: TUIBDatabase;
begin
  Result := False;
  Step := rbInfo;
  Status := 'Récupération des informations de la base de données demandée';

  // Informations systèmes
  FMessage := 'Système d''exploitation : ' + TOSVersion.ToString + #13#10 +
              'Mémoire : ' + '??? Mo' + #13#10 +
  // Taille du fichier de base de données
              'Base de données : "' + FDbFileName + '"'#13#10 +
              'Taille de la base de données : ' + IntToStr(GetFileSizeEx(FDbFileName) div 1024) + ' Ko.';
  Synchronize(DoProgress);

  if not CheckParams then
    Exit;

  //
  UIBCnx := TUIBDataBase.Create(nil);
  try
    UIBCnx.Params.Add('Server=' + SRepareBase.Host);
    // FDCnx.Params.Add('Protocol=TCPIP');
    UIBCnx.DatabaseName := FDbFileName;
    UIBCnx.UserName := SRepareBase.DBUser;
    UIBCnx.PassWord := SRepareBase.DBPassWord;
    UIBCnx.LibraryName := SRepareBase.LibraryName;

    UIBCnx.Connected := True;
    try
      // Statistiques sur la base de données
      FMessage := 'Database header page information :'#13#10 +
        '//Flags : ?' + #13#10 +
        '//Checksum : ?' + #13#10 +
        '//Write timestamp : ?' + #13#10 +
        'Page size : ' + IntToStr(UIBCnx.InfoPageSize) + #13#10 +
        'DB size in pages : ' + IntToStr(UIBCnx.InfoDbSizeInPages) + #13#10 +
        'Oldest transaction : ' + IntToStr(UIBCnx.InfoOldestTransaction) + #13#10 +
        'Oldest active : ' + IntToStr(UIBCnx.InfoOldestActive) + #13#10 +
        'Oldest snapshot : ' + IntToStr(UIBCnx.InfoOldestSnapshot) + #13#10 +
        'Next transaction : ' + IntToStr(UIBCnx.InfoNextTransaction) + #13#10 +
        '//Sequence number : ?' + #13#10 +
        '//Next attachment ID : ?' +#13#10 +
        'Implementation ID : ' + IntToStr(UIBCnx.InfoImplementation) + #13#10 +
        '//Shadow count : ?' +#13#10 +
        '//Page buffers : ?' +#13#10 +
        '//Next header page : ?' +#13#10 +
        'Database dialect : ' + IntToStr(UIBCnx.InfoDbSqlDialect) + #13#10 +
        '//Creation date : ?' +#13#10 +
        '//Attributes : ?' + #13#10 +
        'Variable header data :'#13#10 +
        'Sweep interval : ' + IntToStr(UIBCnx.InfoSweepInterval) + #13#10 +

        UIBCnx.InfoVersion + #13#10 +
        'ODS Version : ' + IntToStr(UIBCnx.InfoOdsVersion) + '.' + IntToStr(UIBCnx.InfoOdsMinorVersion) + #13#10 +
//        //'Srv min version : ' + IntToStr(IBDatabase.svr_min_ver) + #13#10 +
//        IBDatabase.db_id.Text + #13#10 +
        'Transactions en cours : '  + IntToStr(UIBCnx.InfoActiveTransactions) + #13#10 +
//        IBDatabase.active_transactions.Text + #13#10 +
        'Utilisateurs en cours de connexion : ' + IntToStr(UIBCnx.InfoUserNames) + #13#10 +
//        IBDatabase.user_names.Text + #13#10 +
        'Lecture seule : ' + IFThen(UIBCnx.InfoDbReadOnly, 'Oui', 'Non') + #13#10 +
        'Limbo : ' + IntToStr(UIBCnx.InfoLimbo) + #13#10 +
        'Read only : ' + IfThen(UIBCnx.InfoDbReadOnly, 'Oui', 'Non');

// gstat -h => Attributes

//Database "C:\Ginkoia\Data\GINKOIA.IB"
//
//Database header page information:
//        Flags                   0
//        Checksum                12345
//        Write timestamp         Dec 23, 2014 16:08:29
//        Page size               4096                      IBDatabase.page_size
//        ODS version             15.0                      IBDatabase.ods_version
//        Oldest transaction      47832                     IBDatabase.oldest_transaction
//        Oldest active           47833                     IBDatabase.oldest_active
//        Oldest snapshot         47833                     IBDatabase.oldest_snapshot
//        Next transaction        47836                     IBDatabase.next_transaction
//        Sequence number         0
//        Next attachment ID      0
//        Implementation ID       16                        IBDatabase.implementation_
//        Shadow count            0
//        Page buffers            4096
//        Next header page        0
//        Database dialect        3                         IBDatabase.db_sql_dialect
//        Creation date           Mar 14, 2014 13:32:00
//        Attributes
//
//    Variable header data:
//        Sweep interval:         0                         IBDatabase.sweep_interval
//        *END*

      //Memo1.Lines.AddStrings(IBDatabase.backout_count);
      //Memo1.Lines.AddStrings(IBDatabase.delete_count);
      //Memo1.Lines.AddStrings(IBDatabase.expunge_count);
      Synchronize(DoProgress);
    finally
      UIBCnx.Connected := False;
    end;
  finally
    UIBCnx.Free;
  end;

  //
  Status := 'Récupération des informations de la base de données effectuée';
  Result := True;
end;


function TRepareBaseThread.DbOnline: Boolean;
var
  UIBConfig: TUIBConfig;
begin
  Result := False;
  Step := rbOnline;
  Status := 'Remise en ligne de la base de données demandée';

  if not CheckParams then
    Exit;

  UIBConfig := TUIBConfig.Create(nil);
  try
    UIBConfig.DatabaseName := FDbFileName;
    UIBConfig.UserName := SRepareBase.DBUser;
    UIBConfig.Password := SRepareBase.DBPassWord;
    UIBConfig.Host := SRepareBase.Host;
    UIBConfig.Protocol := GetProtocol(SRepareBase.Protocol);
    UIBConfig.LibraryName := SRepareBase.LibraryName;
    //
    UIBConfig.BringDatabaseOnline;
  finally
    UIBConfig.Free;
  end;
  //
  Status := 'Remise en ligne de la base de données effectuée';
  Result := True;
end;

function TRepareBaseThread.DbRepair: Boolean;
var
  UIBRepair: TUIBRepair;
begin
  Result := False;
  Step := rbMend;
  Status := 'Réparation de la base de données démarrée';

  //
  if not CheckParams then
    Exit;

  UIBRepair := TUIBRepair.Create(nil);
  try
    UIBRepair.Database := FDbFileName;
    UIBRepair.UserName := SRepareBase.DBUser;
    UIBRepair.PassWord := SRepareBase.DBPassWord;
    UIBRepair.Host := SRepareBase.Host;
    UIBRepair.Protocol := GetProtocol(SRepareBase.Protocol);
    UIBRepair.LibraryName := SRepareBase.LibraryName;
    //
    UIBRepair.Options := [roMendDB];
    UIBRepair.Verbose := True;
    UIBRepair.OnVerbose := UIBSvcVerbose;
    //
    UIBRepair.Run;
  finally
    UIBRepair.Free;
  end;
  //
  Status := 'Réparation de la base de données terminée';
  Result := True;
end;

function TRepareBaseThread.DbRestore: Boolean;
var
  UIBRestore: TUIBRestore;
begin
  Result := False;
  Step := rbRestore;
  Status := 'Restauration de la base de données démarrée';

  //
  if not CheckParams then
    Exit;

  UIBRestore := TUIBRestore.Create(nil);
  try
    UIBRestore.Database := FRestoreFileName;
    UIBRestore.UserName := SRepareBase.DBUser;
    UIBRestore.PassWord := SRepareBase.DBPassWord;
    UIBRestore.Host := SRepareBase.Host;
    UIBRestore.Protocol := GetProtocol(SRepareBase.Protocol);
    UIBRestore.LibraryName := SRepareBase.LibraryName;
    //
    UIBRestore.Options := [roReplace];
    UIBRestore.BackupFiles.Add(FBackupFileName);
    UIBRestore.Verbose := True;
    UIBRestore.OnVerbose := UIBSvcVerbose;
    //
    UIBRestore.Run;
  finally
    UIBRestore.Free;
  end;
  //
  Status := 'Restauration de la base de données terminée';
  Result := True;
end;

function TRepareBaseThread.DbShutDown: Boolean;
var
  UIBConfig: TUIBConfig;
begin
  Result := False;
  Step := rbShutDown;
  Status := 'Mise hors ligne de la base de données demandée';

  //
  if not CheckParams then
    Exit;

  UIBConfig := TUIBConfig.Create(nil);
  try
    UIBConfig.DatabaseName := FDbFileName;
    UIBConfig.UserName := SRepareBase.DBUser;
    UIBConfig.Password := SRepareBase.DBPassWord;
    UIBConfig.Host := SRepareBase.Host;
    UIBConfig.Protocol := GetProtocol(SRepareBase.Protocol);
    UIBConfig.LibraryName :=  SRepareBase.LibraryName;
    //
    UIBConfig.ShutdownDatabase(smForced, 0);
  finally
    UIBConfig.Free;
  end;
  //
  Status := 'Mise hors ligne de la base de données effectuée';
  Result := True;
end;

function TRepareBaseThread.DbValidate: Boolean;
var
  UIBValidate: TUIBRepair;
begin
  Result := False;
  Step := rbValidate;
  Status := 'Analyse de la base de données démarrée';

  //
  if not CheckParams then
    Exit;

  UIBValidate := TUIBRepair.Create(nil);
  try
    UIBValidate.Database := FDbFileName;
    UIBValidate.UserName := SRepareBase.DBUser;
    UIBValidate.PassWord := SRepareBase.DBPassWord;
    UIBValidate.Host := SRepareBase.Host;
    UIBValidate.Protocol := GetProtocol(SRepareBase.Protocol);
    UIBValidate.LibraryName := SRepareBase.LibraryName;
    //
    UIBValidate.Options := [roValidateFull];
    UIBValidate.Verbose := True;
    UIBValidate.OnVerbose := UIBSvcVerbose;
    //
    UIBValidate.Run;
  finally
    UIBValidate.Free;
  end;
  //
  Status := 'Analyse de la base de données terminée';
  Result := True;
end;

procedure TRepareBaseThread.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TRepareBaseThread.DoCopyProgress;
begin
  if Assigned(FOnCopyProgress) then
    FOnCopyProgress(Self, FCopyProgress);
end;

procedure TRepareBaseThread.DoError;
begin
  if Assigned(FOnError) then
    FOnError(Self, FMessage);
end;

procedure TRepareBaseThread.DoProgress;
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, FMessage);
end;

procedure TRepareBaseThread.DoStepProgress;
begin
  if Assigned(FOnStepProgress) then
    FOnStepProgress(Self);
end;

procedure TRepareBaseThread.Execute;
begin
  if rbInfo in FOptions then
    DbInfos;
  if Terminated then
    Exit;
  //
  if (rbCopy in FOptions) and (TrimRight(FDBCopyFileName) <> '') then
    DbCopy;
  if Terminated then
    Exit;
  //
  if rbShutDown in FOptions then
    DbShutDown;
  if Terminated then
    Exit;
  //
  if rbValidate in FOptions then
    DbValidate;
  if Terminated then
    Exit;
  //
  if rbMend in FOptions then
    DbRepair;
  if Terminated then
    Exit;
  //
  if rbBackup in FOptions then
    DbBackup;
  if Terminated then
    Exit;
  //
  if rbRestore in FOptions then
    DbRestore;
  if Terminated then
    Exit;
  //
  if rbOnline in FOptions then
    DbOnline;
end;

function TRepareBaseThread.GetProtocol(Protocol: String): TUIBProtocol;
begin
  Protocol := UpperCase(Protocol);
  if Protocol = 'TCPIP' then
    Result := proTCPIP
  else if Protocol = 'NETBEUI' then
    Result := proNetBEUI
  else  // Par défaut, on considère Protocol = 'LOCAL'
    Result := proLocalHost;
end;

//procedure TRepareBaseThread.FDIBSvcError(ASender: TObject;
//  const AInitiator: IFDStanObject; var AException: Exception);
//begin
//  FErrorMessage := AException.Message;
//  Synchronize(DoError);
//end;

procedure TRepareBaseThread.UIBSvcVerbose(Sender: TObject; Message: string);
begin
  FMessage := Message;
  Synchronize(DoProgress);
end;

procedure TRepareBaseThread.SetStatus(const Value: string);
begin
  FStatus := '['+DateTimeToStr(Now) + '] ' + Value;
  Synchronize(DoChange);
end;

procedure TRepareBaseThread.SetStep(const Value: TRepareBaseOption);
begin
  FStep := Value;
  Synchronize(DoStepProgress);
end;

end.

