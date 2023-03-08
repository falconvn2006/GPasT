unit UTraitement_Thread;

interface

uses
  System.Classes, System.SysUtils, FireDAC.Stan.Intf, FireDac.Stan.Def,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IBBase, FireDAC.Phys.IB;

type
  TRepareBasesThreadMessageEvent = procedure(Sender: TObject; const AMessage: String) of object;
  TRepareBasesThreadCopyProgressEvent = procedure(Sender: TObject; const APercent: Integer) of object;

  TRepareBaseOption = (rbStopPs, rbInfo, rbShutDown, rbCopy, rbBackup, rbRestore,
                       rbValidate, rbMend, rbOnline, rbStartPs);
  TRepareBaseOptions = set of TRepareBaseOption;

  TRepareBaseThread = class(TThread)
  private
    FDriver: TFDPhysIBDriverLink;
    FOptions: TRepareBaseOptions;
    FDbFileName: string;
    FDBCopyFileName: string;
    FBackupFileName: string;
    FRestoreFileName: string;
    FLogFileName: string;
    FProcess: string;
    FLauncherStopped: Boolean;
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
    procedure DoChange;
    procedure DoError;
    procedure DoProgress;
    procedure DoStepProgress;
    procedure DoCopyProgress;
    procedure FDIBSvcError(ASender: TObject; const AInitiator: IFDStanObject; var AException: Exception);
    procedure FDIBSvcProgress(ASender: TFDPhysDriverService; const AMessage: String);
    procedure SetStatus(const Value: string);
    procedure SetStep(const Value: TRepareBaseOption);
  public
    constructor Create;
    function DbInfos: Boolean;
    function DbShutDown: Boolean;
    function DbCopy: Boolean;
    function DbValidate: Boolean;
    function DbRepair: Boolean;
    function DbBackup: Boolean;
    function DbRestore: Boolean;
    function DbOnline: Boolean;
    function StartPs: Boolean;
    function StopPs: Boolean;
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
    property LauncherStopped: Boolean read FLauncherStopped;
    property Step: TRepareBaseOption read FStep write SetStep;
    property Status: string read FStatus write SetStatus;
  end;


implementation

uses
  System.StrUtils, Winapi.Windows, Winapi.ShellAPI,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client,
  FireDAC.Phys.IBWrapper,
  UConstants, UParams, UUtils;

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
  //
  FDriver := TFDPhysIBDriverLink.Create(nil);
  //
  FProcess := SRepareBase.LauncherName;
  // Paramètres par défaut
  FOptions := [];
  FStatus := '';
end;


function TRepareBaseThread.DbBackup: Boolean;
var
  FDIBBackup: TFDIBBackup;
begin
  Result := False;
  Step := rbBackup;
  Status := OP_BACKUP_STARTED;

  //
  if not CheckParams then
  begin
    Status := OP_BACKUP_CANCELED;
    Exit;
  end;

  FDIBBackup := TFDIBBackup.Create(nil);
  try
    FDIBBackup.Database := FDbFileName;
    FDIBBackup.UserName := SRepareBase.DBUser;
    FDIBBackup.Password := SRepareBase.DBPassWord;
    FDIBBackup.Host := SRepareBase.Host;
    FDIBBackup.Protocol := ipTCPIP;
    FDIBBackup.DriverLink := FDriver;
    //
    FDIBBackup.BackupFiles.Add(FBackupFileName);
    FDIBBackup.Verbose := True;
    FDIBBackup.OnProgress := FDIBSvcProgress;
    //
    FDIBBackup.Backup;
  finally
    FDIBBackup.Free;
  end;
  //
  Status := OP_BACKUP_FINISHED;
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
    if not RBThread.Terminated then
    begin
      Result := PROGRESS_CONTINUE;
      RBThread.FCopyProgress := TotalBytesTransferred * 100 div TotalFileSize;
      RBThread.Synchronize(RBThread.DoCopyProgress);
    end
    else
    begin
      Result := PROGRESS_CANCEL;
    end;
  end;
begin
  Result := False;
  Step := rbCopy;
  Status := OP_COPY_STARTED;
  //
  if not CheckParams then
  begin
    Status := OP_COPY_CANCELED;
    Exit;
  end;
  //
  Canceled := False;
  SetLastError(ERROR_SUCCESS);
  FMessage := OP_RUNNING;
  Synchronize(DoProgress);
  if CopyFileEx(PChar(FDbFileName), PChar(FDBCopyFileName), @CopyProgress, Self, PBool(Canceled), 0) then
    FMessage := FDBCopyFileName + #13#10 + OP_FINISHED
  else
    FMessage := OP_CANCELED + #13#10 + SysErrorMessage(GetLastError);
  Synchronize(DoProgress);
  //
  Status := OP_COPY_FINISHED;
  Result := True;
end;

function TRepareBaseThread.DbInfos: Boolean;
var
  FDCnx: TFDConnection;
  IBDatabase: TIBDatabase;
  Memory: TMemoryStatusEx;

begin
  Result := False;
  Step := rbInfo;
  Status := OP_INFO_STARTED;

  if not CheckParams then
  begin
    Status := OP_INFO_CANCELED;
    Exit;
  end;

  //
  Memory.dwLength := SizeOf(Memory);
  GlobalMemoryStatusEx(Memory);

  // Informations systèmes
  FMessage := 'Système d''exploitation : ' + TOSVersion.ToString + #13#10 +
              'Mémoire : ' + IntToStr(Memory.ullAvailPhys div 1024 div 1024) + ' Mo disponibles sur ' +
              IntToStr(Memory.ullTotalPhys div 1024 div 1024) + ' Mo total'#13#10#13#10 +
  // Taille du fichier de base de données
              'Base de données : "' + FDbFileName + '"'#13#10 +
              'Taille de la base de données : ' + IntToStr(GetFileSizeEx(FDbFileName) div 1024) + ' Ko.'#13#10;
  Synchronize(DoProgress);

  //
  FDCnx := TFDConnection.Create(nil);
  try
    FDCnx.Params.Add('DriverID=IB');
    FDCnx.Params.Add('Protocol=' + SRepareBase.Protocol);
    FDCnx.Params.Add('Server=' + SRepareBase.Host);
    FDCnx.Params.Add('Port=' + IntToStr(SRepareBase.Port));
    FDCnx.Params.Add('Database=' + FDbFileName);
    FDCnx.Params.Add('User_Name=' + SRepareBase.DBUser);
    FDCnx.Params.Add('Password=' + SRepareBase.DBPassWord);

    FDCnx.Connected := True;
    try
      // Statistiques sur la base de données
      IBDatabase := TIBDatabase(FDCnx.CliObj);

      FMessage :=
        'Statistiques sur la base de données :'#13#10 +
        'Server Version : ' + IBDatabase.isc_version.Strings[0] + #13#10 +
        'ODS Version : ' + IntToStr(IBDatabase.ods_version) + '.' + IntToStr(IBDatabase.ods_minor_version) + #13#10 +
        IBDatabase.db_id.Text + #13#10 +
        'Transactions en cours : '  + IntToStr(IBDatabase.active_transactions.Count) + #13#10 +
        IBDatabase.active_transactions.Text + #13#10 +
        'Utilisateurs en cours de connexion : ' + IntToStr(IBDatabase.user_names.Count) + #13#10 +
        IBDatabase.user_names.Text + #13#10 +
        'Page size : ' + IntToStr(IBDatabase.page_size) + #13#10 +
        'DB size in pages : ' + IntToStr(IBDatabase.db_size_in_pages) + #13#10 +
        'Oldest transaction : ' + IntToStr(IBDatabase.oldest_transaction) + #13#10 +
        'Oldest active : ' + IntToStr(IBDatabase.oldest_active) + #13#10 +
        'Oldest snapshot : ' + IntToStr(IBDatabase.oldest_snapshot) + #13#10 +
        'Next transaction : ' + IntToStr(IBDatabase.next_transaction) + #13#10 +
        'Sweep interval : ' + IntToStr(IBDatabase.sweep_interval) + #13#10 +
        'Implementation ID : ' + IntToStr(IBDatabase.implementation_) + #13#10 +
        'Database dialect : ' + IntToStr(IBDatabase.db_sql_dialect) + #13#10 +
        'Lecture seule : ' + IFThen(IBDatabase.db_read_only, 'Oui', 'Non') + #13#10 +
        //  'Shutdown : ???' + #13#10 +
        'Limbo : ' + IntToStr(IBDatabase.limbo.Count);

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
      Synchronize(DoProgress);
    finally
      FDCnx.Connected := False;
    end;
  finally
    FDCnx.Free;
  end;

  //
  Status := OP_INFO_FINISHED;
  Result := True;
end;


function TRepareBaseThread.DbOnline: Boolean;
var
  FDIBConfig: TFDIBConfig;
begin
  Result := False;
  Step := rbOnline;
  Status := OP_ONLINE_STARTED;

  if not CheckParams then
  begin
    Status := OP_ONLINE_CANCELED;
    Exit;
  end;

  FDIBConfig := TFDIBConfig.Create(nil);
  try
    FDIBConfig.Database := FDbFileName;
    FDIBConfig.UserName := SRepareBase.DBUser;
    FDIBConfig.Password := SRepareBase.DBPassWord;
    FDIBConfig.Host := SRepareBase.Host;
    FDIBConfig.Protocol := ipTCPIP;
    FDIBConfig.DriverLink := FDriver;
    //
    FDIBConfig.OnProgress := FDIBSvcProgress;
    FDIBConfig.OnError := FDIBSvcError;
    //
    FDIBConfig.OnlineDB;
  finally
    FDIBConfig.Free;
  end;
  //
  Status := OP_ONLINE_FINISHED;
  Result := True;
end;

function TRepareBaseThread.DbRepair: Boolean;
var
  FDIBValidate: TFDIBValidate;
begin
  Result := False;
  Step := rbMend;
  Status := OP_MEND_STARTED;

  //
  if not CheckParams then
  begin
    Status := OP_MEND_CANCELED;
    Exit;
  end;

  FDIBValidate := TFDIBValidate.Create(nil);
  try
    FDIBValidate.Database := FDbFileName;
    FDIBValidate.UserName := SRepareBase.DBUser;
    FDIBValidate.Password := SRepareBase.DBPassWord;
    FDIBValidate.Host := SRepareBase.Host;
    FDIBValidate.Protocol := ipTCPIP;
    FDIBValidate.DriverLink := FDriver;
    //
    FDIBValidate.Options := [roValidateFull];
    FDIBValidate.OnProgress := FDIBSvcProgress;
    //
    FDIBValidate.Repair;
  finally
    FDIBValidate.Free;
  end;
  //
  Status := OP_MEND_FINISHED;
  Result := True;
end;

function TRepareBaseThread.DbRestore: Boolean;
var
  FDIBRestore: TFDIBRestore;
begin
  Result := False;
  Step := rbRestore;
  Status := OP_RESTORE_STARTED;

  //
  if not CheckParams then
  begin
    Status := OP_RESTORE_CANCELED;
    Exit;
  end;

  FDIBRestore := TFDIBRestore.Create(nil);
  try
    FDIBRestore.Database := FRestoreFileName;
    FDIBRestore.UserName := SRepareBase.DBUser;
    FDIBRestore.Password := SRepareBase.DBPassWord;
    FDIBRestore.Host := SRepareBase.Host;
    FDIBRestore.Protocol := ipTCPIP;
    FDIBRestore.DriverLink := FDriver;
    //
    FDIBRestore.Options := [roReplace];
    FDIBRestore.BackupFiles.Add(FBackupFileName);
    FDIBRestore.Verbose := True;
    FDIBRestore.OnProgress := FDIBSvcProgress;
    //
    FDIBRestore.Restore();
  finally
    FDIBRestore.Free;
  end;
  //
  Status := OP_RESTORE_FINISHED;
  Result := True;
end;

function TRepareBaseThread.DbShutDown: Boolean;
var
  FDIBConfig: TFDIBConfig;
begin
  Result := False;
  Step := rbShutDown;
  Status := OP_SHUTDOWN_STARTED;

  //
  if not CheckParams then
  begin
    Status := OP_SHUTDOWN_CANCELED;
    Exit;
  end;

  FDIBConfig := TFDIBConfig.Create(nil);
  try
    FDIBConfig.Database := FDbFileName;
    FDIBConfig.UserName := SRepareBase.DBUser;
    FDIBConfig.Password := SRepareBase.DBPassWord;
    FDIBConfig.Host := SRepareBase.Host;
    FDIBConfig.Protocol := ipTCPIP;
    FDIBConfig.DriverLink := FDriver;
    //
    FDIBConfig.OnProgress := FDIBSvcProgress;
    //
    FDIBConfig.ShutdownDB(smForce, 0);
  finally
    FDIBConfig.Free;
  end;
  //
  Status := OP_SHUTDOWN_FINISHED;
  Result := True;
end;

function TRepareBaseThread.DbValidate: Boolean;
var
  FDIBValidate: TFDIBValidate;
begin
  Result := False;
  Step := rbValidate;
  Status := OP_VALIDATE_STARTED;

  //
  if not CheckParams then
  begin
    Status := OP_VALIDATE_CANCELED;
    Exit;
  end;

  FDIBValidate := TFDIBValidate.Create(nil);
  try
    FDIBValidate.Database := FDbFileName;
    FDIBValidate.UserName := SRepareBase.DBUser;
    FDIBValidate.Password := SRepareBase.DBPassWord;
    FDIBValidate.Host := SRepareBase.Host;
    FDIBValidate.Protocol := ipTCPIP;
    FDIBValidate.DriverLink := FDriver;
    //
    FDIBValidate.OnProgress := FDIBSvcProgress;
    //
    FDIBValidate.Analyze;
  finally
    FDIBValidate.Free;
  end;
  //
  Status := OP_VALIDATE_FINISHED;
  Result := True;
end;

function TRepareBaseThread.StartPs: Boolean;
var
  ExecInfo: TShellExecuteInfo;
begin
  // A ne relancer que si arrêté précédemment...
  if FLauncherStopped then
  begin
    Step := rbStartPs;
    Status := OP_START_LAUNCHER;

    // Launcher 'Launchv7.exe'
    FillChar(ExecInfo, SizeOf(ExecInfo), 0);
    ExecInfo.cbSize := SizeOf(TShellExecuteInfo);

    ExecInfo.fMask := SEE_MASK_NOCLOSEPROCESS;
    ExecInfo.Wnd := 0;
    ExecInfo.lpFile := PChar(FProcess);

    SetLastError(0);
    if not ShellExecuteEx(@ExecInfo) then
    begin
      Status := SysErrorMessage(GetLastError);
      Status := OP_START_LAUNCHER_KO;
      Result := False;
    end
    else
    begin
      //
      Status := OP_START_LAUNCHER_OK;
      Result := True;
    end;
  end;
end;

function TRepareBaseThread.StopPs: Boolean;
var
  PId: Cardinal;
begin
  Step := rbStopPs;
  Status := OP_STOP_LAUNCHER;
  //
  if GetProcessInfo(FProcess, PId) then
  begin
    FProcess := GetPathFromPID(PID);
    TerminateProcess(OpenProcess(PROCESS_TERMINATE, False, PID), 0);
    Status := OP_STOP_LAUNCHER_OK;
    FLauncherStopped := True;
  end
  else
  begin
    Status := OP_LAUNCHER_NOT_FOUND;
    // Terminate;
    FLauncherStopped := False;
  end;
  Result := FLauncherStopped;
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
  if rbStopPs in FOptions then
    StopPs;
  if Terminated then
    Exit;
  //
  if rbInfo in FOptions then
    DbInfos;
  if Terminated then
    Exit;
  //
  if rbShutDown in FOptions then
    DbShutDown;
  if Terminated then
    Exit;
  //
  if (rbCopy in FOptions) and (TrimRight(FDBCopyFileName) <> '') then
    DbCopy;
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
  if Terminated then
    Exit;
  //
  if (rbStartPs in FOptions) and FLauncherStopped then
    StartPs;
end;

procedure TRepareBaseThread.FDIBSvcError(ASender: TObject;
  const AInitiator: IFDStanObject; var AException: Exception);
begin
  FErrorMessage := AException.Message;
  Synchronize(DoError);
end;

procedure TRepareBaseThread.FDIBSvcProgress(ASender: TFDPhysDriverService; const AMessage: String);
begin
  FMessage := AMessage;
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

