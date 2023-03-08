unit uFTPFiles;

interface

uses
  uGestionBDD, uCreateCSV, DB, Contnrs, Classes, uFTPUtils, uMonitoring, uLog;

type
  TSendFileLastVersionType = (sflvtTable, sflvtLame);

  TFileLastVersion = Record
    id: integer;
    lvType: TSendFileLastVersionType;
    version: Int64;
    date: TDateTime;
  end;

  TCustomFTPFile = class
  private
    FConnection: TMyConnection;
    FQuery: TMyQuery;

    FDefaultFileName: string;
    FFTPLogEvent: TFTPLogEvent;
    FOnAddMonitoringEvent: TAddMonitoringEvent;
    FASSID: integer;

  protected
    FMonitoringAppType: TMonitoringAppType;
    FMagId: integer;

    function LoadQuery: boolean; virtual;

    function getFileName: string; virtual;

    function getDataSet: TDataSet;

    function GetNewQuery: TMyQuery;
    procedure AddLog(ALogMessage: string; ALogLevel: TFTPLogLevel = ftpllInfo);
  public
    constructor Create(Const AConnection: TMyConnection; Const AFileName: string;
                       Const AMonitoringAppType: TMonitoringAppType); overload; virtual;

    property ASSID: integer read FASSID write FASSID;
    property MagId: integer read FMagId write FMagId;
    property DefaultFileName: string read FDefaultFileName;

    property FileName: string read getFileName;

    property OnLog: TFTPLogEvent read FFTPLogEvent write FFTPLogEvent;
    property OnAddMonitoring: TAddMonitoringEvent read FOnAddMonitoringEvent
      write FOnAddMonitoringEvent;
  end;

  TCustomFTPFileClass = class of TCustomFTPFile;

  TCustomFTPSendFile = class(TCustomFTPFile)
  private
    FUniqueField: string;
    FExcludeExportFields: string;

    FStarted: boolean;

    procedure InitHeaderOL(Const AWriteHeaderToCSV: Boolean);
    function GetWriteHeader: Boolean;
  protected
    FHeaderOL: TExportHeaderOL;

    FVersions: Array of TFileLastVersion;
    FCurrentVersionLame, FCurrentVersionBase: Int64;
    FInitMode: boolean;
    FCurrentFileName: string;
    FByPassGestionK: Boolean;
    FExtension: String;

    procedure startWrite(AInitMode: boolean; ACurrentVersionBase, ACurrentVersionLame: Int64);
    function DoWrite(APath: string): boolean; virtual;
    procedure endWrite;

    procedure RefreshFileName; virtual;

    procedure LoadQueryParams(AQuery: TMyQuery); virtual;

    function getQuery: string; virtual; abstract;
    function getInitQuery: string; virtual; abstract;

    function LoadQuery: boolean; override;

    function getFileName: string; override;

    procedure setVersion(AType: TSendFileLastVersionType; ANewVersion: Int64);
    function getVersion(AType: TSendFileLastVersionType): integer;
    function getTableVersion: integer;
    function getLameVersion: integer;

    function CanExecute(AInitMode: Boolean): boolean;
  public
    constructor Create(Const AConnection: TMyConnection; Const AFileName: string;
                       Const AMonitoringAppType: TMonitoringAppType;
                       Const AUniqueField: string = ''; Const AExcludeExportFields: string = '';
                       Const AByPassGestionK: Boolean = False;
                       Const AWriteHeaderToCSV: Boolean = True;
                       Const AExtension: String = 'TXT'); overload;

    destructor Destroy;

    procedure UpdateVersions(ABaseVersion, ALameVersion: Int64; AAssId: integer);

    function Execute(APath: string; AInitMode: boolean; ACurrentVersionBase,
      ACurrentVersionLame: Int64): boolean;

    function addVersion(AMagId: integer; AId: integer; AVersion: Int64;
      ADate: TDateTime): boolean;

    property WriteHeader: Boolean read GetWriteHeader;
  end;

  TCustomFTPSendFileClass = class of TCustomFTPSendFile;

  TCustomFTPSendFileList = class(TObjectList)
  private
    function GetItem(Index: Integer): TCustomFTPSendFile;
    procedure SetItem(Index: Integer; const Value: TCustomFTPSendFile);
  published
  public
    function IndexOf(AFileName: string): integer;
    property Items[Index: Integer]: TCustomFTPSendFile read GetItem write SetItem; default;
  end;

  TCustomFTPGetFile = class(TCustomFTPFile)
  private
    FFilePath: string;
  protected
    FStringList: TStringList;

    function LoadQuery: boolean; override;

    function GetQueryText: string; virtual; abstract;
    function DoRead: TLogLevel; virtual;
    procedure DoUpdateBDD; virtual;

    //Verifie la structure du fichier
    function isFileValid: boolean;
    function CheckFileEntete: boolean; virtual; abstract;

    function getFilePath: string;
    function getFileName: string; override;

    function GetQuery: TMyQuery;

    function getFileLineValues(ALine: string): TStringList;
  public
    constructor Create(Const AConnection: TMyConnection; Const AFileName: string;
                       Const AMonitoringAppType: TMonitoringAppType); overload;
    destructor Destroy; override;

    function Execute(APath: string): boolean;
  end;

  TCustomFTPGetFileClass = class of TCustomFTPGetFile;

//  TCustomFTPGetCSVFile = class(TCustomFTPGetFile);
{
    Déclaration par défaut d'une nouvelle class WMSSendFile
    TWMS<New>File = class(TCustomFTPSendFile)
  protected
    procedure LoadQueryParams(AQuery: TMyQuery); override;

    function getQuerySQLSelect: string; override;
    function getQuerySQLFromClause: string; override;
    function getQuerySQLWhereClause: string; override;
    function getQuerySQLOrderByClause: string; override;
  public

  end;
}

implementation

uses
  SBUtils, SysUtils, uGenerique, UCommon_dm;

{ TCustomFTPSendFile }

function TCustomFTPSendFile.addVersion(AMagId: integer; AId: integer;
  AVersion: Int64; ADate: TDateTime): boolean;
var
  index: integer;
begin
  index:= Length(FVersions);
  SetLength(FVersions, index + 1);
  if AMagId = 0 then
    FVersions[index].lvType := sflvtLame
  else if AMagId > 0 then
  begin
    FVersions[index].lvType :=  sflvtTable;
    FMagId := AMagId;
  end;

  FVersions[index].id := AId;
  FVersions[index].version := AVersion;
end;

function TCustomFTPSendFile.CanExecute(AInitMode: Boolean): boolean;
var
  i: integer;
begin
  if AInitMode then
    Result := True
  else
  begin // On verifie qu'on a les versions de K pour la gestion du "delta"
    Result := False;
    for i := 0 to length(FVersions) - 1 do
    begin
      Result := FVersions[i].version > 0;
    end;
  end;
end;

constructor TCustomFTPSendFile.Create(Const AConnection: TMyConnection; Const AFileName: string;
  Const AMonitoringAppType: TMonitoringAppType; Const AUniqueField: string;
  Const AExcludeExportFields: string; Const AByPassGestionK: Boolean;
  Const AWriteHeaderToCSV: Boolean; Const AExtension: String);
begin
  inherited Create(AConnection, AFileName, AMonitoringAppType);

  SetLength(FVersions, 0);

  FUniqueField := AUniqueField;
  FExcludeExportFields := AExcludeExportFields;
  FByPassGestionK:= AByPassGestionK;
  FExtension:= AExtension;

  InitHeaderOL(AWriteHeaderToCSV);
end;

destructor TCustomFTPSendFile.Destroy;
begin
  FQuery.Close;
  FreeAndNil(FQuery);

  SetLength(FVersions, 0);

  inherited;
end;

function TCustomFTPSendFile.Execute(APath: string; AInitMode: boolean;
  ACurrentVersionBase, ACurrentVersionLame: Int64): boolean;
begin
  try
    if (FByPassGestionK) or (CanExecute(AInitMode)) then
    begin
      startWrite(AInitMode, ACurrentVersionBase, ACurrentVersionLame);
      DoWrite(APath);
      endWrite;
      Result := True;
    end
    else
    begin
      AddLog(Format('Impossible de traiter le fichier "%s" si son initialisation ' +
        'n''à pas été faite', [FdefaultfileName]), ftpllWarning);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      AddLog('Erreur lors de la génération du fichier : ' +
        ExtractFileName(APath), ftpllError);
      AddLog(E.Message, ftpllError);
      Result := False;

      raise TMonitoringException.Create('Erreur lors de la génération du fichier : ' +
        ExtractFileName(APath), logError, FMonitoringAppType, mdltExport);
    end;
  end;
end;

function TCustomFTPSendFile.DoWrite(APath: string): boolean;
var
  i: integer;
begin
  Result := True;

  try
    if FileExists(APath) then
      DeleteFile(PChar(APath));

    FHeaderOL.Clear;
    // Si champ unique spécifie quel champ doit être unique
    FHeaderOL.sChampUnique := FUniqueField;

    // On ajoute la liste des champs que l'on va devoir traiter pour le CSV
    for i := 0 to getDataSet.Fields.Count - 1 do
    begin
      //TODO regarder comment exlure certain champs du résulat
      if Pos(getDataSet.Fields[i].FieldName, FExcludeExportFields) = 0 then
      begin
        FHeaderOL.Add(getDataSet.Fields[i].FieldName);
      end;
    end;

    // On génère le CSV avec la source de données
    FHeaderOL.ConvertToCsv(getDataSet, APath + FileName);

    if FHeaderOL.bErreurUnicite then
    begin
      //TODO voir si le code spécifique au problème d'unicité est géré dans CheckHeaderOLUnicity ou autre fonction
      // genre ManageHeaderOLUnicity
    end;
  finally
    FHeaderOL.Clear;
  end;
end;

procedure TCustomFTPSendFile.endWrite;
begin
  FQuery.Close;
  FQuery.IB_Transaction.Commit;
  FQuery.SQL.Clear;
  FStarted := False;
end;

function TCustomFTPSendFile.getFileName: string;
begin
  Result := FCurrentFileName;
end;

function TCustomFTPSendFile.getLameVersion: integer;
begin
  Result := GetVersion(sflvtLame);
end;

function TCustomFTPSendFile.getTableVersion: integer;
begin
  Result := GetVersion(sflvtTable);
end;

function TCustomFTPSendFile.getVersion(AType: TSendFileLastVersionType): integer;
var
  i: integer;
begin
  Result := 0;
  i := 0;

  while (i < Length(FVersions)) and (Result = 0) do
  begin
    if FVersions[i].lvType = AType then
      Result := FVersions[i].version;
    inc(i);
  end;
end;

function TCustomFTPSendFile.GetWriteHeader: Boolean;
begin
  Result:= False;

  if FHeaderOL <> nil then
    Result:= FHeaderOL.bWriteHeader;
end;

procedure TCustomFTPSendFile.InitHeaderOL(Const AWriteHeaderToCSV: Boolean);
begin
  FHeaderOL := TExportHeaderOL.Create;
  FHeaderOL.bAlign := False; // Pas de gestion de la taille des champs
  FHeaderOL.bWriteHeader := AWriteHeaderToCSV;

  FHeaderOL.Separator := ';'; // séparateur de champs

  //Comme le separator du csv est ";" on s'assure qu'il n'y a pas de ";" dans
  // les données qu'on envoi en les rempacement par ","
  FHeaderOL.OldStr := ';';
  FHeaderOL.NewStr := ',';
end;

function TCustomFTPSendFile.LoadQuery: boolean;
begin
  FQuery.Close;
  FQuery.SQL.Clear;
  if FInitMode then
    FQuery.SQL.Text := getInitQuery
  else
    FQuery.SQL.Text := getQuery;

  LoadQueryParams(FQuery);

  FQuery.Open;

  OnAddMonitoring(Self, 'Nombre d''enregistrement trouvé à exporter : ' + IntToStr(FQuery.RecordCount),
                  logNotice, mdltExport, FMonitoringAppType, FMagId, False, -1);
end;

procedure TCustomFTPSendFile.LoadQueryParams(AQuery: TMyQuery);
begin
  if not FInitMode then
  begin
    if Assigned(AQuery.Params.FindParam('LAST_VERSION')) then
      AQuery.Params.ParamByName('LAST_VERSION').AsLargeInt := getTableVersion;
    if Assigned(AQuery.Params.FindParam('LAST_VERSION_LAME')) then
      AQuery.Params.ParamByName('LAST_VERSION_LAME').AsLargeInt := getLameVersion;

    if Assigned(AQuery.Params.FindParam('CURRENT_VERSION')) then
      AQuery.Params.ParamByName('CURRENT_VERSION').AsLargeInt := FCurrentVersionBase;
    if Assigned(AQuery.Params.FindParam('CURRENT_VERSION_LAME')) then
      AQuery.Params.ParamByName('CURRENT_VERSION_LAME').AsLargeInt := FCurrentVersionLame;

    if Assigned(AQuery.Params.FindParam('DEBUT_PLAGE_BASE')) then
      AQuery.Params.ParamByName('DEBUT_PLAGE_BASE').AsLargeInt := Dm_Common.PlageBase.Debut;
    if Assigned(AQuery.Params.FindParam('FIN_PLAGE_BASE')) then
      AQuery.Params.ParamByName('FIN_PLAGE_BASE').AsLargeInt := Dm_Common.PlageBase.Fin;
  end;
end;

procedure TCustomFTPSendFile.RefreshFileName;
begin
  if FInitMode then
    FCurrentFileName := 'INIT_' + FDefaultFileName + '.' + FExtension
  else
    FCurrentFileName := Format('%s_%s.' + FExtension, [FDefaultFileName, FormatDateTime('yyyymmdd_hhnnss', Now())]);
end;

procedure TCustomFTPSendFile.setVersion(AType: TSendFileLastVersionType;
  ANewVersion: Int64);
var
  i: integer;
begin
  i := 0;

  while (i < Length(FVersions)) do
  begin
    if FVersions[i].lvType = AType then
      FVersions[i].version := ANewVersion;
    inc(i);
  end;
end;

procedure TCustomFTPSendFile.startWrite(AInitMode: boolean; ACurrentVersionBase, ACurrentVersionLame: Int64);
begin
  if not FStarted then
  begin
    FInitMode := AInitMode;
    RefreshFileName;
    FCurrentVersionBase := ACurrentVersionBase;
    FCurrentVersionLame := ACurrentVersionLame;
    FStarted := True;
  end
  else
  begin
    Raise Exception.Create('Fichier déjà en cours de traitement');
  end;
end;

procedure TCustomFTPSendFile.UpdateVersions(ABaseVersion,
  ALameVersion: Int64; AAssId: integer);
var
  i: integer;
  query: TMyQuery;

  BaseVersionUpdated, LameVersionUpdated: boolean;
begin
  BaseVersionUpdated := False;
  LameVersionUpdated := False;

  query := GetNewQuery;
  try
    query.SQL.Text :=
      'UPDATE ARTEXPORTWEB ' +
      'SET AWE_LASTVERSION = :version, AWE_DATEEXPORT = :date ' +
      'WHERE AWE_ID = :ID';

    for i := 0 to Length(FVersions) - 1 do
    begin
      query.Params.ParamByName('ID').AsInteger := FVersions[i].id;
      query.Params.ParamByName('date').asDateTime := Now();
      case FVersions[i].lvType of
        sflvtTable:
        begin
          query.Params.ParamByName('version').AsLargeInt := ABaseVersion;
          BaseVersionUpdated := True;
          setVersion(sflvtTable, ABaseVersion);
        end;
        sflvtLame:
        begin
          query.Params.ParamByName('version').AsLargeInt := ALameVersion;
          LameVersionUpdated := True;
          setVersion(sflvtLame, ALameVersion);
        end;
      end;

      OnAddMonitoring(Self, 'UPDATE ARTEXPORTWEB : ' +
                            'AWE_LASTVERSION = ' + IntToStr(query.Params.ParamByName('version').AsLargeInt) +
                            ', AWE_DATEEXPORT = ' + DateTimeToStr(query.Params.ParamByName('date').asDateTime) +
                            ', AWE_ID = ' + IntToStr(query.Params.ParamByName('ID').AsInteger),
                      logNotice, mdltExport, FMonitoringAppType, FMagId, False, -1);

      query.ExecSQL;
    end;

    if not BaseVersionUpdated then
    begin
      query.Close;
      query.SQL.Clear;
      query.SQL.Text :=
        'INSERT INTO ARTEXPORTWEB (AWE_ID, AWE_ASSID, AWE_FICHIER, AWE_ACTIF, AWE_DATEEXPORT, AWE_LASTVERSION, AWE_MAGID)' +
        '  VALUES(:ID, :ASSID, :FICHIER, :ACTIF, :DATEEXPORT, :LASTVERSION, :MAGID) ';

      query.Params.ParamByName('ID').AsInteger           := NewK('ARTEXPORTWEB');
      query.Params.ParamByName('ASSID').AsInteger        := AAssId;
      query.Params.ParamByName('FICHIER').AsString       := DefaultFileName;
      query.Params.ParamByName('ACTIF').AsInteger        := 1;
      query.Params.ParamByName('DATEEXPORT').AsDateTime  := Now();
      query.Params.ParamByName('LASTVERSION').AsLargeInt := ABaseVersion;
      query.Params.ParamByName('MAGID').AsInteger        := FMagId;

      addVersion(FMagId, query.Params.ParamByName('ID').AsInteger, ABaseVersion,
        query.Params.ParamByName('DATEEXPORT').AsDateTime);

      OnAddMonitoring(Self, 'INSERT INTO ARTEXPORTWEB (BaseVersion) : ' +
                            'AWE_ID = ' + IntToStr(query.Params.ParamByName('ID').AsInteger) +
                            ', AWE_ASSID = ' + IntToStr(query.Params.ParamByName('ASSID').AsInteger) +
                            ', AWE_FICHIER = ' + query.Params.ParamByName('FICHIER').AsString +
                            ', AWE_ACTIF = ' + IntToStr(query.Params.ParamByName('ID').AsInteger) +
                            ', AWE_DATEEXPORT = ' + DateTimeToStr(query.Params.ParamByName('DATEEXPORT').asDateTime) +
                            ', AWE_LASTVERSION = ' + IntToStr(query.Params.ParamByName('LASTVERSION').AsLargeInt) +
                            ' AWE_MAGID = ' + IntToStr(query.Params.ParamByName('MAGID').AsInteger),
                      logNotice, mdltExport, FMonitoringAppType, FMagId, False, -1);

      query.ExecSQL;
    end;

    if not LameVersionUpdated then
    begin
      query.Close;
      query.SQL.Clear;
      query.SQL.Text :=
        'INSERT INTO ARTEXPORTWEB (AWE_ID, AWE_ASSID, AWE_FICHIER, AWE_ACTIF, AWE_DATEEXPORT, AWE_LASTVERSION, AWE_MAGID)' +
        '  VALUES(:ID, :ASSID, :FICHIER, :ACTIF, :DATEEXPORT, :LASTVERSION, :MAGID) ';

      query.Params.ParamByName('ID').AsInteger           := NewK('ARTEXPORTWEB');
      query.Params.ParamByName('ASSID').AsInteger        := AAssId;
      query.Params.ParamByName('FICHIER').AsString       := DefaultFileName;
      query.Params.ParamByName('ACTIF').AsInteger        := 1;
      query.Params.ParamByName('DATEEXPORT').AsDateTime  := Now();
      query.Params.ParamByName('LASTVERSION').AsLargeInt  := ALameVersion;
      query.Params.ParamByName('MAGID').AsInteger        := 0;

      addVersion(0, query.Params.ParamByName('ID').AsInteger, ALameVersion,
        query.Params.ParamByName('DATEEXPORT').AsDateTime);

      OnAddMonitoring(Self, 'INSERT INTO ARTEXPORTWEB (LameVersion) : ' +
                            'AWE_ID = ' + IntToStr(query.Params.ParamByName('ID').AsInteger) +
                            ', AWE_ASSID = ' + IntToStr(query.Params.ParamByName('ASSID').AsInteger) +
                            ', AWE_FICHIER = ' + query.Params.ParamByName('FICHIER').AsString +
                            ', AWE_ACTIF = ' + IntToStr(query.Params.ParamByName('ID').AsInteger) +
                            ', AWE_DATEEXPORT = ' + DateTimeToStr(query.Params.ParamByName('DATEEXPORT').asDateTime) +
                            ', AWE_LASTVERSION = ' + IntToStr(query.Params.ParamByName('LASTVERSION').AsLargeInt) +
                            ' AWE_MAGID = ' + IntToStr(query.Params.ParamByName('MAGID').AsInteger),
                      logNotice, mdltExport, FMonitoringAppType, FMagId, False, -1);

      query.ExecSQL;
    end;

    { Le UpdateK a été isolé dans une boucle à la fin de cette procedure
      pour des raisons de pb de transaction. }
    for i:= Low(FVersions) to High(FVersions) do
      UpdateK(FVersions[i].id);

  finally
    FreeAndNil(query);
  end;

end;

{ TCustomFTPSendFileList }

function TCustomFTPSendFileList.GetItem(Index: Integer): TCustomFTPSendFile;
begin
  Result := TCustomFTPSendFile(Inherited GetItem(Index));
end;

function TCustomFTPSendFileList.IndexOf(AFileName: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
  begin
    if Items[i].DefaultFileName = AFileName then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TCustomFTPSendFileList.SetItem(Index: Integer;
  const Value: TCustomFTPSendFile);
begin
  Inherited SetItem(Index, Value);
end;

{ TCustomFTPFile }

procedure TCustomFTPFile.AddLog(ALogMessage: string; ALogLevel: TFTPLogLevel);
begin
  if Assigned(FFTPLogEvent) then
    FFTPLogEvent(Self, ALogMessage, ALogLevel);
end;

constructor TCustomFTPFile.Create(Const AConnection: TMyConnection;
  Const AFileName: string; Const AMonitoringAppType: TMonitoringAppType);
begin
  FConnection := AConnection;
  FQuery := GetNewQuery;
  FMonitoringAppType:= AMonitoringAppType;

  FDefaultFileName := AFileName;
end;

function TCustomFTPFile.getDataSet: TDataSet;
begin
  if not FQuery.Active then
    LoadQuery;
  Result := FQuery;
end;

function TCustomFTPFile.getFileName: string;
begin
  Result := FDefaultFileName;
end;

function TCustomFTPFile.GetNewQuery: TMyQuery;
begin
  Result := uGestionBDD.GetNewQuery(FConnection);
end;

function TCustomFTPFile.LoadQuery: boolean;
begin

end;

{ TCustomFTPGetFile }

constructor TCustomFTPGetFile.Create(Const AConnection: TMyConnection;
  Const AFileName: string; Const AMonitoringAppType: TMonitoringAppType);
begin
  inherited Create(AConnection, AFileName, AMonitoringAppType);

  FStringList := TStringList.Create;
end;

destructor TCustomFTPGetFile.Destroy;
begin
  FreeAndNil(FStringList);

  inherited;
end;

function TCustomFTPGetFile.Execute(APath: string): boolean;
begin
  FFilePath := APath;

  //Initialisation du FStringList avec les données du fichier
  FStringList.LoadFromFile( getFilePath );
  if isFileValid then
  begin
    case DoRead of
      logNone, logDebug, logTrace, logInfo, logNotice: DoUpdateBDD;
      logWarning:
      begin
        DoUpdateBDD;
        raise TMonitoringException.Create(
          Format('%s : Avertissement lors de la lecture des données (voir log pour détail)',
          [DefaultFileName]), logError, FMonitoringAppType, mdltImport);
      end;
      logError, logCritical, logEmergency:
      begin
        raise TMonitoringException.Create(
          Format('%s : Erreur lors de la lecture des données (voir log pour détail)',
          [DefaultFileName]), logError, FMonitoringAppType, mdltImport);
      end;
    end;
  end;
end;

function TCustomFTPGetFile.DoRead: TLogLevel;
begin
  Result := logNone;
end;

procedure TCustomFTPGetFile.DoUpdateBDD;
begin

end;

function TCustomFTPGetFile.getFileLineValues(ALine: string): TStringList;
var
  index: integer;
  value: string;
begin
  Result := TStringList.Create;
  index := Pos(';', ALine);
  while index <> 0 do
  begin
    Result.Add( Copy(ALine, 0, index - 1) );
    ALine := Copy(ALine, index + 1, length(ALine));
    index := Pos(';', ALine);
  end;
  Result.Add( ALine );
end;

function TCustomFTPGetFile.getFileName: string;
begin
  Result := DefaultFileName;
end;

function TCustomFTPGetFile.getFilePath: string;
begin
  Result := FFilePath + DefaultFileName;
end;

function TCustomFTPGetFile.GetQuery: TMyQuery;
begin
  Result := FQuery;
end;

function TCustomFTPGetFile.isFileValid: boolean;
begin
  Result := True;
  if FStringList.Count = 0 then
  begin
    AddLog(Format('Fichier "%s" vide', [DefaultFileName]), ftpllWarning);
    Result := False;
  end;

  if FStringList.Count > 1 then
  begin
    if not CheckFileEntete then
    begin
      AddLog(Format('Entete des colonnes du fichier "%s" incorrects',
        [DefaultFileName]), ftpllError);
      Result := False;

      Raise TMonitoringException.Create(Format('Entete des colonnes du fichier "%s" incorrects',
        [DefaultFileName]), logError, FMonitoringAppType, mdltImport);
    end;
    if FStringList.Count = 1 then
    begin
      AddLog(Format('Fichier "%s" contient une seule ligne (ligne d''entête)',
        [DefaultFileName]), ftpllWarning);
      Result := False;

      Raise TMonitoringException.Create(Format('Fichier "%s" contient une seule ligne (ligne d''entête)',
        [DefaultFileName]), logWarning, FMonitoringAppType, mdltImport);
    end;
  end;
end;

function TCustomFTPGetFile.LoadQuery: boolean;
begin
  FQuery.Close;

  FQuery.SQL.Clear;
  FQuery.SQL.Text := GetQueryText;
end;

end.



