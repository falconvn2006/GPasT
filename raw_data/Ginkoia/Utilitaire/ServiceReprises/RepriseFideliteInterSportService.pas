unit RepriseFideliteInterSportService;

interface

uses
  System.Classes, System.SysUtils, uGestionBDD, uMaxxing, ulog, ulogs;

type
  TRepriseFideliteInterSportService = class(TThread)
  private
    FLogs: TLogs;
    FDelai: integer;
    FDataBaseFile: string;

    FMaxxingManager: TMaxxingManager;

    function GetConnection: TMyConnection;

    procedure InitMaxxingManager;

    procedure InitDelai;
    procedure InitLogs;
    procedure RefreshLogFileName;
    procedure AddLog(ALogMessage: string; ALogLevel: TLogLevel = logTrace); overload;
    procedure AddLog(ALogItem: TLogItem); overload;
    procedure RepriseFideliteInterSportLog(Sender: TObject; ALogItem: TLogItem);
  protected
    procedure Execute; override;
  public
    constructor Create(ADataBaseFile: string); overload;
    destructor Destroy; override;

    function CanExecute: boolean;
  end;

implementation

uses
  ActiveX;

{ TRepriseFideliteInterSportService }

procedure TRepriseFideliteInterSportService.AddLog(ALogMessage: string; ALogLevel: TLogLevel);
var
  tmplog: TLogItem;
begin
  tmplog.key := 'Status';
  tmplog.mag := '';
  tmplog.val := ShortString(ALogMessage);
  tmplog.lvl := ALogLevel;

  AddLog(tmplog);
end;

procedure TRepriseFideliteInterSportService.AddLog(ALogItem: TLogItem);
begin
  log.Log('FIDISF', log.Ref, ALogItem.mag, ALogItem.key, ALogItem.val, ALogItem.lvl, True, FDelai * 2 + 10);
  FLogs.AddToLogs(ALogItem.val);
end;

function TRepriseFideliteInterSportService.CanExecute: boolean;
var
  vCnx: TMyConnection;
begin
  vCnx := GetConnection;
  FMaxxingManager.setConnection(vCnx);
  try
    Result := length(FMaxxingManager.ListMagasins(True)) > 0;
  finally
    vCnx.Close;
    FreeAndNil(vCnx);
  end;
end;

constructor TRepriseFideliteInterSportService.Create(ADataBaseFile: string);
begin
  FDataBaseFile := ADataBaseFile;
  InitLogs;
  InitMaxxingManager;
  FreeOnTerminate := False;

  inherited Create(True);
end;

destructor TRepriseFideliteInterSportService.Destroy;
begin
  FreeAndNil(FLogs);
  FreeAndNil(FMaxxingManager);

  inherited;
end;

procedure TRepriseFideliteInterSportService.Execute;
var
  count: integer;
  vCnx: TMyConnection;
  sav_decimalseparator: Char;
begin
  //Initialisation des objects COM pour pouvoir lire les XML retourné par le service web
  CoInitialize(nil);

  try
    count := 0;
    AddLog(Format('Démarrage du service "Reprise fidélité INTERSPORT Maxxing" (délai %d minutes)', [Trunc(FDelai / 60)]));
    AddLog('"Reprise fidélité INTERSPORT Maxxing" démarré', logInfo);
    while not Terminated do
    begin
      try
        inc(Count);
        if Count >= FDelai then
        begin
          vCnx := GetConnection;
          sav_decimalseparator := FormatSettings.DecimalSeparator;
          try
            FormatSettings.DecimalSeparator := '.';
            FMaxxingManager.setConnection(vCnx);
            Count := 0;
            RefreshLogFileName;
            FMaxxingManager.Recover;
            FMaxxingManager.PurgeLogs;
            InitDelai;
          finally
            vCnx.Close;
            vCnx.DisposeOf;
            FormatSettings.DecimalSeparator := sav_decimalseparator;
          end;
        end;
        Sleep(1000);
      except
        on E: Exception do
        begin
          AddLog(Format('Erreur : %s', [E.Message]), logError);
        end;
      end;
    end;
  finally
    AddLog('Arrêt du service "Reprise fidélité INTERSPORT Maxxing"');
    AddLog('Arrêté', logInfo);
    CoUninitialize;
  end;
end;

function TRepriseFideliteInterSportService.GetConnection: TMyConnection;
var
  database: string;
begin
  database := FDataBaseFile;

  try
    Result := GetNewConnexion(DataBase, CST_GINKOIA_LOGIN, CST_GINKOIA_PASSWORD, False);
    Result.Open;
  except
    on E: Exception do
    begin
      AddLog('Impossible de se connecter à la base: "' + DataBase);
      AddLog(E.Message);

      Raise;
    end;
  end;
end;

procedure TRepriseFideliteInterSportService.InitDelai;
begin
  FDelai := FMaxxingManager.RepriseDelai;
  FDelai := FDelai * 60;
end;

procedure TRepriseFideliteInterSportService.InitLogs;
var
  path: string;
begin
  path := ExtractFilePath(ParamStr(0)) + '\logs\';
  if not DirectoryExists(path) then
  begin
    ForceDirectories(path);
  end;

  FLogs := TLogs.Create;
  FLogs.Path := path;

  RefreshLogFileName;
end;

procedure TRepriseFideliteInterSportService.InitMaxxingManager;
var
  aCnx: TMyConnection;
begin
  aCnx := GetConnection;

  try
    FMaxxingManager := TMaxxingManager.Create(aCnx);
    FMaxxingManager.OnLog := RepriseFideliteInterSportLog;

    InitDelai;
  finally
    aCnx.Close;
    aCnx.DisposeOf;
  end;
end;

procedure TRepriseFideliteInterSportService.RefreshLogFileName;
var
  sdate: string;
begin
  DateTimeToString(sdate, 'yyyymmdd', Now());
  FLogs.FileName := Format('reprisefideliteintersportlogs_%s.txt', [sdate]);
end;

procedure TRepriseFideliteInterSportService.RepriseFideliteInterSportLog(Sender: TObject; ALogItem: TLogItem);
begin
  AddLog(ALogItem);
end;

end.

