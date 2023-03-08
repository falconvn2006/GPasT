unit uMonitoring;

interface

uses
  uLog, SysUtils;

type
  TMonitoringMdlType = (mdltMain, mdltFTP, mdltImport, mdltExport);
  TMonitoringAppType = (apptSyncWeb, apptWMS, apptExportFTP);

  TAddMonitoringEvent = procedure(Sender: TObject; AMessage: string; ALogLevel: TLogLevel;
    AMdlType: TMonitoringMdlType; AAppType: TMonitoringAppType;
    ACurrentMag: integer; AForceStatus: boolean; AFrequency: integer) of object;

  TMonitoringException = class(Exception)
  private
    FMdlType: TMonitoringMdlType;
    FAppType: TMonitoringAppType;
    FLogLevel: TLogLevel;
    procedure SetAppType(const Value: TMonitoringAppType);
    procedure SetMdlType(const Value: TMonitoringMdlType);
    procedure SetLogLevel(const Value: TLogLevel);

  public
    constructor Create(AMessage: string; ALogLevel: TLogLevel; AAppType: TMonitoringAppType; AMdlType: TMonitoringMdlType);

    property LogLevel: TLogLevel read FLogLevel write SetLogLevel;
    property AppType: TMonitoringAppType read FAppType write SetAppType;
    property MdlType: TMonitoringMdlType read FMdlType write SetMdlType;
  end;

  function GetBaseGuid: string;

  procedure InitMonitoring;
  procedure CloseMonitoring;
  procedure AddMonitoring(AMessage: String; ALogLevel: TLogLevel; AMdlType: TMonitoringMdlType; AAppType: TMonitoringAppType; ACurrentMag: Integer; AForceStatus: Boolean = False; AFrequency: Integer = -1);   overload;

var
  SyncWebLog, WMSLog, ExportFtp: TLog;

implementation

uses UCommon_Dm;

function GetBaseGuid: string;
begin
  Dm_Common.Que_Tmp.Close;
  Dm_Common.Que_Tmp.SQL.Clear;
  Dm_Common.Que_Tmp.SQL.Text :=
    'SELECT BAS_GUID ' +
    'FROM ' +
    '   GENBASES ' +
    '   JOIN GENPARAMBASE ON GENPARAMBASE.PAR_STRING = GENBASES.BAS_IDENT AND ' +
    '     GENPARAMBASE.PAR_NOM = ''IDGENERATEUR'' ' +
    '   JOIN K ON K.K_ID = GENBASES.BAS_ID AND K.K_ENABLED = 1';
  Dm_Common.Que_Tmp.Open;

  if not Dm_Common.Que_Tmp.IsEmpty then
  begin
    Result := Dm_Common.Que_Tmp.FieldByName('BAS_GUID').AsString;
  end;

  Dm_Common.Que_Tmp.Close;
  Dm_Common.Que_Tmp.SQL.Clear;
end;

procedure InitMonitoring;
begin
  SyncWebLog := TLog.Create;
  SyncWebLog.ReadIni;
  SyncWebLog.App := 'SyncWeb';
  SyncWebLog.Ref := GetBaseGuid;
  SyncWebLog.Open;
  SyncWebLog.saveIni;

  WMSLog := TLog.Create;
  WMSlog.ReadIni;
  WMSLog.App := 'WMS';
  WMSlog.Ref := GetBaseGuid;
  WMSlog.Open;
  wMSlog.saveIni;

  ExportFtp := TLog.Create;
  ExportFtp.ReadIni;
  ExportFtp.App := 'SyncWeb_ExportFTP';
  ExportFtp.Ref := GetBaseGuid;
  ExportFtp.Open;
  ExportFtp.saveIni;
end;

procedure CloseMonitoring;
begin
  SyncWebLog.Free;
  WMSLog.Free;
  ExportFtp.Free;
end;

procedure AddMonitoring(AMessage: String; ALogLevel: TLogLevel; AMdlType: TMonitoringMdlType; AAppType: TMonitoringAppType; ACurrentMag: Integer; AForceStatus: Boolean; AFrequency: Integer);
var
  tmp_mdl: String;
  monitormessage: Boolean;
begin
  case AMdlType of
    mdltMain: tmp_mdl := 'Main';
    mdltFTP: tmp_mdl := 'FTP';
    mdltImport: tmp_mdl := 'Import';
    mdltExport: tmp_mdl := 'Export';
  end;

  if AFrequency <> -1 then
    Inc(AFrequency, 5 * 60 * 1000); // On ajout 5 minutes à la fréquence pour être sur

  monitormessage := True;
  case AAppType of
    apptSyncWeb:
      begin
        case ALogLevel of
          logError, logWarning: Dm_Common.MySiteParams.FMonitoringError := True;
          logInfo: monitormessage := not Dm_Common.MySiteParams.FMonitoringError;
        end;

        if monitormessage then
          SyncWeblog.Log(tmp_mdl, SyncWebLog.Ref, IntToStr(ACurrentMag), 'Status', AMessage, ALogLevel, AForceStatus, AFrequency, ltBoth);
      end;

    apptWMS:
      begin
        WMSlog.Log(tmp_mdl, WMSLog.Ref, IntToStr(ACurrentMag), 'Status', AMessage, ALogLevel, AForceStatus, AFrequency, ltBoth);
      end;

    apptExportFTP:
      begin
        ExportFtp.Log(tmp_mdl, ExportFtp.Ref, IntToStr(ACurrentMag), 'Status', AMessage, ALogLevel, AForceStatus, AFrequency, ltBoth);
      end;
  end;
end;

{ TMonitoringException }

constructor TMonitoringException.Create(AMessage: string; ALogLevel: TLogLevel; AAppType: TMonitoringAppType; AMdlType: TMonitoringMdlType);
begin
  Message := AMessage;
  LogLevel := ALogLevel;
  AppType := AAppType;
  MdlType := AMdlType;
end;

procedure TMonitoringException.SetAppType(const Value: TMonitoringAppType);
begin
  FAppType := Value;
end;

procedure TMonitoringException.SetLogLevel(const Value: TLogLevel);
begin
  FLogLevel := Value;
end;

procedure TMonitoringException.SetMdlType(const Value: TMonitoringMdlType);
begin
  FMdlType := Value;
end;

end.

