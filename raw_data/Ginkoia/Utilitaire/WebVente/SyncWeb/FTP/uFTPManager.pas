unit uFTPManager;

interface

uses
  uFTPSite, Generics.Collections, uGestionBDD, uCustomFTPManager, uFTPUtils,
  uMonitoring, uLog, Classes, uFTPCtrl;

type
  TFTPManager = class(TCustomFTPManager)
  private
    FFTPSites: TObjectList<TFTPSite>;

    FOnLogEvent: TFTPLogEvent;
    FOnAddMonitoringEvent: TAddMonitoringEvent;
    FOnAfterStop: TNotifyEvent;
    FOnAfterStart: TNotifyEvent;
    FOnGetData: TNotifyEvent;

    FASS_TYPE: String;
    FGENPATH: String;
    FGENLOGPATH: String;

    procedure SetOnLogEvent(const Value: TFTPLogEvent);
    procedure SetOnGetData(const Value: TNotifyEvent);
  protected
    procedure LoadSites;

    procedure AddLog(ALogMessage: string; ALogLevel: TFTPLogLevel = ftpllInfo);
    procedure AddMonitoring(AMessage: string; ALogLevel: TLogLevel;
      AMdlType: TMonitoringMdlType; AAppType: TMonitoringAppType;
      ACurrentMag: integer; AForceStatus: boolean = False; AFrequency: integer = -1);
  public
    constructor Create(Const AConnection: TMyConnection;
                       Const ATransaction: TMyTransaction;
                       Const AMonitoringAppType: TMonitoringAppType;
                       Const AModuleName: String; Const APRM_TYPE, AASS_TYPE: String;
                       Const AGENPATH, AGENLOGPATH: String;
                       Const AOnAddMonitoring: TAddMonitoringEvent;
                       Const ABypassGestionK: Boolean;
                       Const AWriteHeaderToCSV: Boolean;
                       Const AExtension: String;
                       Const AIsOneShotCycleTime: Boolean); reintroduce; overload;

    destructor Destroy; override;

    procedure Start;

    procedure Execute;
    procedure Initialize;

    procedure ForceUpload;
    procedure TestFTPConnection;

    procedure RefreshDefaultMonitoringValues;

    procedure Stop;

    function Enabled : boolean;

    property OnAfterStart: TNotifyEvent read FOnAfterStart write FOnAfterStart;
    property OnAfterStop: TNotifyEvent read FOnAfterStop write FOnAfterStop;

    property OnLogEvent: TFTPLogEvent read FOnLogEvent write SetOnLogEvent;

    property OnGetData: TNotifyEvent read FOnGetData write SetOnGetData;
  end;

implementation

uses
  SysUtils, uGenerique;

{ TFTPManager }

procedure TFTPManager.AddLog(ALogMessage: string; ALogLevel: TFTPLogLevel);
begin
  if Assigned(FOnLogEvent) then
    FOnLogEvent(Self, ALogMessage, ALogLevel);
end;

procedure TFTPManager.AddMonitoring(AMessage: string; ALogLevel: TLogLevel;
  AMdlType: TMonitoringMdlType; AAppType: TMonitoringAppType;
  ACurrentMag: integer; AForceStatus: boolean; AFrequency: integer);
begin
  if Assigned(FOnAddMonitoringEvent) then
  begin
    FOnAddMonitoringEvent(self, AMessage, ALogLevel, AMdlType, AAppType,
      ACurrentMag, AForceStatus, AFrequency);
  end;
end;

constructor TFTPManager.Create(Const AConnection: TMyConnection;
  Const ATransaction: TMyTransaction;
  Const AMonitoringAppType: TMonitoringAppType;
  Const AModuleName: String; Const APRM_TYPE, AASS_TYPE: String;
  Const AGENPATH, AGENLOGPATH: String;
  Const AOnAddMonitoring: TAddMonitoringEvent;
  Const ABypassGestionK: Boolean;
  Const AWriteHeaderToCSV: Boolean;
  Const AExtension: String;
  Const AIsOneShotCycleTime: Boolean);
begin
  inherited Create(AConnection, ATransaction, AMonitoringAppType, AModuleName, APRM_TYPE,
                   AOnAddMonitoring, ABypassGestionK, AWriteHeaderToCSV,
                   AExtension, AIsOneShotCycleTime);
  FFTPSites := TObjectList<TFTPSite>.Create;
  FASS_TYPE:= AASS_TYPE;
  FGENPATH:= AGENPATH;
  IF (Trim(FGENPATH) <> '') and (NOT DirectoryExists(FGENPATH)) THEN
    ForceDirectories(FGENPATH);

  FGENLOGPATH:= AGENLOGPATH;
  IF (Trim(FGENLOGPATH) <> '') and (NOT DirectoryExists(FGENLOGPATH)) THEN
    ForceDirectories(FGENLOGPATH);

  LoadSites;
end;

destructor TFTPManager.Destroy;
begin
  Stop;
  FreeAndNil(FFTPSites);
end;

function TFTPManager.Enabled: boolean;
var
  i: integer;
begin
  Result := False;

  i := 0;
  while (i < FFTPSites.Count) and not Result do
  begin
    Result := FFTPSites[i].Enabled;
    inc(i);
  end;
end;

procedure TFTPManager.Execute;
var
  i: integer;
begin
  for i := 0 to FFTPSites.Count - 1 do
  begin
    FFTPSites[i].Execute;
  end;
end;

procedure TFTPManager.ForceUpload;
var
  i: integer;
begin
  for i := 0 to FFTPSites.Count - 1 do
  begin
    FFTPSites[i].ForceUpload;
  end;
end;

procedure TFTPManager.Initialize;
var
  i: integer;
begin
  for i := 0 to FFTPSites.Count - 1 do
  begin
    FFTPSites[i].Initialize;
  end;
end;

procedure TFTPManager.LoadSites;
var
  query: TMyQuery;
  tmpsite: TFTPSite;
begin
  query := GetNewQuery(FConnection);
  try
    query.SQL.Text :=
      'SELECT * ' +
      'FROM ARTSITEWEB JOIN K ON K.K_ID = ARTSITEWEB.ASS_ID AND K.K_ENABLED = 1 ' +
      'WHERE ARTSITEWEB.ASS_TYPE = ' + FASS_TYPE + ' AND ARTSITEWEB.ASS_AMAJ = 1';
    query.Open;

    while not query.Eof do
    begin
      tmpsite := TFTPSite.Create(Self, FConnection, query, FMonitoringAppType,
                                 FModuleName, FPRM_TYPE, FGENPATH, FGENLOGPATH,
                                 OnMonitoring, FExtension, FIsOneShotCycleTime);
      tmpsite.OnLog := OnLogEvent;
      tmpsite.OnAddMonitoring := OnMonitoring;
      tmpsite.OnGetData:= FOnGetData;
      FFTPSites.Add(tmpsite);
      query.Next;
    end;
  except
    On E: Exception do
    begin
      AddLog(E.Message, ftpllError);
    end;
  end;

  query.Close;
  query.Free;
end;

procedure TFTPManager.RefreshDefaultMonitoringValues;
var
  i: integer;
begin
  for i := 0 to FFTPSites.Count - 1 do
  begin
    FFTPSites[i].RefreshDefaultMonitoringValues;
  end;
end;

procedure TFTPManager.SetOnGetData(const Value: TNotifyEvent);
var
  i: integer;
begin
  FOnGetData := Value;
  for i:= 0 to FFTPSites.Count -1 do
  begin
    FFTPSites[i].OnGetData := OnGetData;
  end;
end;

procedure TFTPManager.SetOnLogEvent(const Value: TFTPLogEvent);
var
  i: integer;
begin
  FOnLogEvent := Value;
  for i:= 0 to FFTPSites.Count - 1 do
  begin
    FFTPSites[i].OnLog := OnLogEvent;
  end;
end;

procedure TFTPManager.Start;
var
  i: integer;
begin
  for i := 0 to FFTPSites.Count - 1 do
  begin
    FFTPSites[i].Start;
  end;

  if Assigned(FonAfterStart) then
    FOnAfterStart(Self);
end;

procedure TFTPManager.Stop;
var
  i: integer;
begin
  for i := 0 to FFTPSites.Count - 1 do
  begin
    FFTPSites[i].Stop;
  end;

  if Assigned(FOnAfterStop) then
    FOnAfterStop(Self);
end;

procedure TFTPManager.TestFTPConnection;
var
  i: integer;
begin
  for i := 0 to FFTPSites.Count - 1 do
  begin
    FFTPSites[i].TestFTPConnection;
  end;
end;

end.






