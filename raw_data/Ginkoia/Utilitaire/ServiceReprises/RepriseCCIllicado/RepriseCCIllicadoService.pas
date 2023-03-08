unit RepriseCCIllicadoService;

interface

uses
  System.Classes, System.SysUtils,
  uRepriseCCIllicadoUtils, uRepriseCCIllicadoDBUtils, ulog, ulogs;

type
  TRepriseCCIllicadoService = class(TThread)
  private
    FLogs: TLogs;

    FDelais: integer;
    FRCCUtils: TRepriseCCIllicadoUtils;
    FRCCDBUtils: TRepriseCCIllicadoDBUtils;

    procedure InitLogs;
    procedure RefreshLogFileName;
    procedure InitDelais;
    procedure AddLog(ALogMessage: string; ALogLevel: TLogLevel = logTrace); overload;
    procedure AddLog(ALogItem: TLogItem); overload;
    procedure RepriseCCIllicadoLog(Sender: TObject; ALogItem: TLogItem);
  protected
    procedure Execute; override;

    procedure RecoverCKDs;
    procedure RCCCanContinue(Sender: TObject; var ACanContinue: Boolean);
  public
    constructor Create(ADataBaseFile: string); overload;
    destructor Destroy; override;

    function CanExecute: Boolean;
  end;

implementation

uses
  ShellAPI, Vcl.SvcMgr, ActiveX;

{ TRepriseCCGlobalPOS }

procedure TRepriseCCIllicadoService.AddLog(ALogMessage: string; ALogLevel: TLogLevel);
var
  tmplog: TLogItem;
begin
  tmplog.key := 'Status';
  tmplog.mag := '';
  tmplog.val := ALogMessage;
  tmplog.lvl := ALogLevel;

  AddLog(tmplog);
end;

procedure TRepriseCCIllicadoService.AddLog(ALogItem: TLogItem);
begin
  log.Log('CCIllicado', log.Ref, ALogItem.mag, ALogItem.key, ALogItem.val, ALogItem.lvl, True, FDelais * 2 + 10);
  FLogs.AddToLogs(ALogItem.val);
end;

function TRepriseCCIllicadoService.CanExecute: Boolean;
begin
  try
    Result := Length(FRCCDBUtils.ListMagasins(True)) > 0;
  finally
    FRCCDBUtils.closeConnection;
  end;
end;

constructor TRepriseCCIllicadoService.Create(ADataBaseFile: string);
begin
  InitLogs;

  FRCCUtils := TRepriseCCIllicadoUtils.Create(ADataBaseFile);
  FRCCUtils.OnCanContinue := RCCCanContinue;
  FRCCUtils.OnLog := RepriseCCIllicadoLog;

  FRCCDBUtils := TRepriseCCIllicadoDBUtils.Create(ADataBaseFile);
  FRCCDBUtils.OnLog := RepriseCCIllicadoLog;

  FDelais := 0;

  FreeOnTerminate := False;

  inherited Create(True);
end;

destructor TRepriseCCIllicadoService.Destroy;
begin
  FreeAndNil(FRCCUtils);
  FreeAndNil(FRCCDBUtils);
  FreeAndNil(FLogs);

  inherited;
end;

procedure TRepriseCCIllicadoService.Execute;
var
  count: integer;
begin
  //Initialisation des objects COM pour pouvoir lire les XML retourné par le service web
  CoInitialize(nil);

  //InitDelais; commenté pour commencer le premier traitement instantanémment.

  try
    count := 0;
    AddLog(Format('Demarrage du service "Reprise cartes cadeaux Illicado" (délai %d minutes)', [Trunc(FDelais / 60)]));
    AddLog('Demarré', logInfo);
    while not Terminated do
    begin
      try
        inc(Count);
        if Count >= FDelais then
        begin
          count := 0;
          try
            RecoverCKDs;
            InitDelais;
          finally
            FRCCUtils.closeConnection;
          end;
        end;
        Sleep(1000);
      except
        on E: Exception do
          AddLog(Format('Erreur : %s', [E.Message]), logError);
      end;
    end;
  finally
    AddLog(Format('Arrêt du service "Reprise cartes cadeaux Illicado"', [FDelais]));
    AddLog('Arrêté', logInfo);
    CoUninitialize;
  end;
end;

procedure TRepriseCCIllicadoService.InitDelais;
var
  i, magDelais: integer;
  magasins: TMagasinArray;

  newdelais: integer;
begin
  try
    newdelais := FRCCDBUtils.getGenParamValueInteger(13, 124, 0);

    if newdelais = 0 then
    begin
      AddLog('Impossible de récupérer le "délai" par le "GENBASES.BAS_MAGID". Tentative par la liste des magasins');
      magasins := FRCCDBUtils.ListMagasins(True);

      for i := 0 to length(magasins) - 1 do
      begin
        AddLog('  ' + magasins[i].FName);
        magDelais := FRCCDBUtils.getGenParamValueInteger(3,  134, magasins[i].FId);
        if (newdelais = 0) or (magDelais < newdelais) then
          newdelais := magDelais;
      end;
    end;

    if newdelais = 0 then
    begin
      newdelais := 15;
      AddLog(Format('Impossible de récupérer le "délai" dans la base de donnée. ' +
        'Utilisation de la valeur par défaut (%d minutes)', [newdelais]));
    end;

    newdelais := newdelais * 60; // "x60" pour la passer en seconde

    if newdelais <> FDelais then
    begin
      FDelais := newdelais;
      AddLog(Format('Chargement du délai = %d minutes', [Trunc(FDelais / 60)]));
    end;
  finally
    FRCCDBUtils.closeConnection;
  end;
end;

procedure TRepriseCCIllicadoService.InitLogs;
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

procedure TRepriseCCIllicadoService.RCCCanContinue(Sender: TObject;
  var ACanContinue: Boolean);
begin
  ACanContinue := Not Terminated;
end;

procedure TRepriseCCIllicadoService.RecoverCKDs;
begin
  RefreshLogFileName;
  AddLog('Lancement de la "Reprise cartes cadeaux Illicado"', logNotice);
  FRCCUtils.RecoverBaseCKDOs;
  AddLog('Fin du traitement pour la "Reprise cartes cadeaux Illicado"', logInfo);
end;

procedure TRepriseCCIllicadoService.RefreshLogFileName;
var
  sdate: string;
begin
  DateTimeToString(sdate, 'yyyymmdd', Now());
  FLogs.FileName := Format('repriseCCIllicadoservicelogs_%s.txt', [sdate]);
end;

procedure TRepriseCCIllicadoService.RepriseCCIllicadoLog(Sender: TObject;
  ALogItem: TLogItem);
begin
  AddLog(ALogItem);
end;

end.
