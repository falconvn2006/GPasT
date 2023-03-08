unit uRepriseCCGlobalPOSDBUtils;

interface

uses
  uGestionBDD, Data.DB, System.Classes, ulog, StrUtils, System.DateUtils ;

type
  GenParamValueType = (gpvtInteger, gpvtString, gpvtFloat);

  TMagasin = record
    FId: integer;
    FName: string;
  end;

  TMagasinArray = array of TMagasin;

  TRepriseCCGlobalPOSDBUtils = class
  private
    FDataBaseFile: string;
    FConnection: TMyConnection;
    FTransaction: TMyTransaction;
    FOnLog: TLogEvent;

    function getConnection: TMyConnection;
    function getTransaction: TMyTransaction;

    function getGenParamValue(AType, ACode, AMagId: integer; AReturnType: GenParamValueType): Variant;

    function NewK(ATableName: string): integer;
    procedure UpdateK(AId: integer; AType: integer = 0);

    procedure AddLog(ALogMessage: string; ALogLevel: TLogLevel = logTrace);
    procedure SetOnLog(const Value: TLogEvent);
  public
    constructor Create(ADataBaseFile: string); overload;

    procedure closeConnection;

    procedure UpdateCKDO(ACKDOID: integer; aWSValue: Integer);
    procedure CreateCKDO(ACKDORIGIN: TDataSet; AcodeRetour: Integer);
    procedure UpdateCKDOWithoutTicket;

    function getGenBaseBasCodeTiersValue(AMagId: integer): string;
    function getGenParamValueString(AType, ACode, AMagId: integer): string;
    function getGenParamValueInteger(AType, ACode, AMagId: integer): integer;

    function getDisconnectCKDOQuery(AMAGId: integer; ListForMails: Boolean = False): TDataSet;
    function getCKDOKO: TDataSet;

    function ModuleCCGlobalPOSEnabled(AMagId: Integer): boolean;
    function ListMagasins(AWithCCGlobalPOSEnabled: boolean = False): TMagasinArray;

    function getGUID(AMagId: integer): string;
    function getURL(AMagId: integer): string;

    property DataBaseFile: string read FDataBaseFile write FDataBaseFile;

    property OnLog: TLogEvent read FOnLog write SetOnLog;
  end;

var
  FRepriseCCGlobalPOSDBUtils: TRepriseCCGlobalPOSDBUtils;

implementation

uses
  System.SysUtils;

{ TRepriseCCGlobalPOSDBUtils }

function TRepriseCCGlobalPOSDBUtils.getConnection: TMyConnection;
begin
  if not Assigned(FConnection) then
  begin
    FConnection := GetNewConnexion(DataBaseFile, CST_GINKOIA_LOGIN, CST_GINKOIA_PASSWORD, False);
    try
      FConnection.Open;
    except
      on E: Exception do
      begin
        AddLog('Impossible de se connecter à la base: "' + DataBaseFile + ' : ' + E.Message, logError);

        Raise;
      end;
    end;
  end;

  result := FConnection;
end;

function TRepriseCCGlobalPOSDBUtils.getTransaction: TMyTransaction;
begin
//  if not Assigned(FTransaction) then
//    FTransaction := GetNewTransaction(getConnection);

//  result := FTransaction;
  result := nil;
end;

function TRepriseCCGlobalPOSDBUtils.getURL(AMagId: integer): string;
begin
  result := getGenParamValueString(13, 15, AMagId);
  if RightStr(result,1)<>'/' then
    result := result + '/';
end;

function TRepriseCCGlobalPOSDBUtils.getGUID(AMagId: integer): string;
begin
  result := getGenParamValueString(13, 25, AMagId);
end;


function TRepriseCCGlobalPOSDBUtils.ListMagasins(AWithCCGlobalPOSEnabled: boolean = False): TMagasinArray;
var
  query: TMyQuery;
begin
  try
    query := GetNewQuery(getConnection, getTransaction,
      'SELECT ' +
      '   MAG_ID, MAG_NOM ' +
      'FROM ' +
      '   GENMAGASIN ' +
      '   JOIN GENBASES ON (GENBASES.bas_id = GENMAGASIN.mag_basid) ' +
      '   JOIN GENPARAMBASE ON GENPARAMBASE.PAR_STRING = GENBASES.BAS_IDENT AND ' +
      '     GENPARAMBASE.PAR_NOM = ''IDGENERATEUR'' ' +
      '   JOIN K ON K.K_ID = GENMAGASIN.MAG_ID AND K.K_ENABLED = 1'
      );
    query.Open;

    while not query.Eof do
    begin
      if not AWithCCGlobalPOSEnabled or (AWithCCGlobalPOSEnabled
        and ModuleCCGlobalPOSEnabled(query.FieldByName('MAG_ID').AsInteger)) then
      begin
        SetLength(Result, Length(Result) + 1);
        Result[Length(Result) - 1].FId := query.FieldByName('MAG_ID').AsInteger;
        Result[Length(Result) - 1].FName := query.FieldByName('MAG_NOM').AsString;
      end;
      query.Next;
    end;
  finally
    query.Close;
    query.Free;
  end;
end;

function TRepriseCCGlobalPOSDBUtils.ModuleCCGlobalPOSEnabled(
  AMagId: Integer): boolean;
var
  query: TMyQuery;
begin
  Result := False;

  query := GetNewQuery(getConnection, getTransaction,
    'SELECT ' +
    '   UGM_DATE ' +
    'FROM ' +
    '   UILGRPGINKOIAMAG ' +
    '   JOIN K ON K.K_ID = UILGRPGINKOIAMAG.UGM_ID ' +
    '   JOIN UILGRPGINKOIA ON UILGRPGINKOIA.UGG_ID = UILGRPGINKOIAMAG.UGM_UGGID AND ' +
    '     UILGRPGINKOIA.UGG_NOM = :MODULENAME ' +
    'WHERE ' +
    '   UILGRPGINKOIAMAG.UGM_MAGID = :MAGID');
  query.ParamByName('MODULENAME').AsString := 'CARTECADEAU_GLOBALPOS';
  query.ParamByName('MAGID').AsInteger := AMagId;
  try
    query.Open;

    Result := (query.RecordCount = 1)
      and (query.FieldByName('UGM_DATE').AsDateTime >= Now());
  finally
    query.Close;
    query.Free;
  end;
end;

procedure TRepriseCCGlobalPOSDBUtils.UpdateCKDO(ACKDOID: integer; aWSValue: Integer);
var
  query: TMyQuery;
begin
  try
    query := GetNewQuery(getConnection, getTransaction,
      'UPDATE ' +
      ' CSHCARTEKDO ' +
      'SET ' +
      ' KDO_APPELWS = :WSVALUE ' +
      'WHERE ' +
      ' KDO_ID = :KDOID');

    query.Params.ParamByName('WSVALUE').AsInteger := aWSValue;
    query.Params.ParamByName('KDOID').AsInteger := ACKDOID;

    query.ExecSQL;
    UpdateK(ACKDOID);
  finally
    query.Close;
  end;
end;

procedure TRepriseCCGlobalPOSDBUtils.UpdateCKDOWithoutTicket();
var
  query, queryU: TMyQuery;

begin
  // mise à jours des lignes qui ne sont pas liées à un ticket existant
  try
    queryU := GetNewQuery(getConnection, getTransaction);

    query := GetNewQuery(getConnection, getTransaction,
      'SELECT KDO_ID FROM CSHCARTEKDO ' +
      'WHERE NOT EXISTS (SELECT TKE_ID FROM CSHTICKET WHERE TKE_ID = CSHCARTEKDO.KDO_TKEID) ' +
      'AND KDO_TKEID <> 0 AND ((KDO_CARDTYPE IS NULL) OR (KDO_CARDTYPE <> 4))');
    query.Open;

    while not query.Eof do
    begin
      queryU.SQL.Text :=
      'UPDATE ' +
      'CSHCARTEKDO ' +
      'SET ' +
      'KDO_TKEID = 0 ' +
      'WHERE ' +
      'KDO_ID = :KDOID';

      queryU.Params.ParamByName('KDOID').AsInteger := query.FieldByName('KDO_ID').AsInteger;
      queryU.ExecSQL;

      UpdateK(query.FieldByName('KDO_ID').AsInteger);

      query.Next;
    end;
  finally
    query.Close;
    query.Free;
    queryU.Close;
    queryU.Free;
  end;

end;

procedure TRepriseCCGlobalPOSDBUtils.closeConnection;
begin
  if Assigned(FConnection) then
  begin
    FConnection.Close;
    FConnection.DisposeOf;
    FConnection := nil;
  end;
end;

constructor TRepriseCCGlobalPOSDBUtils.Create(ADataBaseFile: string);
begin
  inherited Create;

  FDataBaseFile := ADataBaseFile;
end;

procedure TRepriseCCGlobalPOSDBUtils.AddLog(ALogMessage: string;  ALogLevel: TLogLevel);
var
  tmplog: TLogItem;
begin
  if Assigned(FOnLog) then
  begin
    tmplog.val := ALogMessage;
    tmplog.lvl := ALogLevel;
    FOnLog(self, tmplog);
  end;
end;

procedure TRepriseCCGlobalPOSDBUtils.CreateCKDO(ACKDORIGIN: TDataSet; AcodeRetour: Integer);
var
  query: TMyQuery;
  NewID: Integer;
  sql: String;
begin
  try
    NewID := NewK('CSHCARTEKDO');

    query := GetNewQuery(getConnection, nil,
      'INSERT INTO ' +
      ' CSHCARTEKDO ( ' +
      '   KDO_ID, ' +
      '   KDO_NUMCARTE, ' +
      '   KDO_NUMTRANS, ' +
      '   KDO_MONTANT, ' +
      '   KDO_TYPE, ' +
      '   KDO_TKEID, ' +
      '   KDO_APPELWS, ' +
      '   KDO_DATE, ' +
      '   KDO_CARDTYPE) ' +
      'VALUES ( ' +
      ' :KDOID, ' +
      ' :KDONUMCARTE, ' +
      ' :KDONUMTRANS, ' +
      ' :KDOMONTANT, ' +
      ' :KDOTYPE, ' +
      ' :KDOTKEID, ' +
      ' :KDOAPPELWS, ' +
      ' :KDODATE, ' +
      ' 2)');
    query.Params.ParamByName('KDOID').AsInteger := NewID;
    query.Params.ParamByName('KDONUMCARTE').AsString := ACKDORIGIN.FieldByName('KDO_NUMCARTE').AsString;
    query.Params.ParamByName('KDONUMTRANS').AsString := ACKDORIGIN.FieldByName('KDO_NUMTRANS').AsString;
    query.Params.ParamByName('KDOMONTANT').AsFloat := ACKDORIGIN.FieldByName('KDO_MONTANT').AsFloat;
    query.Params.ParamByName('KDOTYPE').AsString := ACKDORIGIN.FieldByName('KDO_TYPE').AsString;
    query.Params.ParamByName('KDOTKEID').AsInteger := ACKDORIGIN.FieldByName('KDO_TKEID').AsInteger;
    query.Params.ParamByName('KDOAPPELWS').AsInteger := AcodeRetour;
    query.Params.ParamByName('KDODATE').AsDateTime := Now();

    query.ExecSQL;
  finally
    query.Close;
  end;
end;






procedure TRepriseCCGlobalPOSDBUtils.SetOnLog(const Value: TLogEvent);
begin
  FOnLog := Value;
end;

function TRepriseCCGlobalPOSDBUtils.getGenBaseBasCodeTiersValue(AMagId: integer): string;
var
  query: TMyQuery;
  vVersion : string;
begin
  query := GetNewQuery(
  // Recup de la version
  getConnection, getTransaction,'SELECT * FROM GENVERSION ORDER BY VER_DATE DESC ROWS 1');
  try
    query.Open();
    if query.RecordCount = 1 then
          begin
            vVersion := query.FieldByName('VER_VERSION').AsString;
          end;
    query.Close;
    // Avant la V18.2
    if vVersion<='18.1.0.9999' then
        begin
          query.SQL.Clear;
          query.SQL.Add('SELECT                                                  ');
          query.SQL.Add('GENBASES.bas_codetiers                                  ');
          query.SQL.Add(' FROM                                                   ');
          query.SQL.Add(' GENBASES join K ON K.k_id = GENBASES.bas_id AND K.k_enabled = 1 ');
          query.SQL.Add(' JOIN GENPARAMBASE ON GENPARAMBASE.PAR_STRING = GENBASES.BAS_IDENT AND ');
          query.SQL.Add(' GENPARAMBASE.PAR_NOM = ''IDGENERATEUR''                  ');
          query.Open();
          if query.RecordCount = 1 then
            begin
            Result := query.Fields[0].AsString;
          end
          else if query.RecordCount = 0 then
          begin
            AddLog('Impossible de trouver le BAS_CODETIERS dans GENBASE');
          end
          else if query.RecordCount > 1 then
          begin
            AddLog('Plusieurs BASE_CODETIERS trouvé dans GENBASE');
          end;
        end
    else
      begin
          query.SQL.Clear;
          query.SQL.Add('SELECT                                 ');
          query.SQL.Add('GENMAGASIN.MAG_CODETIERS               ');
          query.SQL.Add(' FROM GENMAGASIN                       ');
          query.SQL.Add(' JOIN K ON K_ID=MAG_ID AND K_ENABLED=1 ');
          query.SQL.Add('WHERE MAG_ID = :MAGID                  ');
          query.ParamByName('MAGID').Asinteger := AMagId;
          query.Open();
          if query.RecordCount = 1 then
              begin
                Result := query.Fields[0].AsString;
              end
          else if query.RecordCount = 0 then
              begin
                AddLog('Impossible de trouver le MAG_CODETIERS dans GENMAGASIN');
              end
          else if query.RecordCount > 1 then
              begin
                AddLog('Plusieurs MAG_CODETIERS trouvé dans GENMAGASIN');
              end;
      end;
   finally
     query.DisposeOf;
   end;
end;

function TRepriseCCGlobalPOSDBUtils.getGenParamValue(AType, ACode, AMagId: integer;
  AReturnType: GenParamValueType): Variant;
var
  sql: string;
  returnfield: string;
  query: TMyQuery;
begin
  case AReturnType of
    gpvtInteger:  returnfield := 'PRM_INTEGER';
    gpvtString:   returnfield := 'PRM_STRING';
    gpvtFloat:    returnfield := 'PRM_FLOAT';
  end;

  try
    sql :=
      'SELECT ' +
      '  GENPARAM.' + returnfield + ' ' +
      'FROM ' +
      '  GENPARAM ' +
      'WHERE ' +
      '  GENPARAM.PRM_TYPE = :TYPE AND  ' +
      '  GENPARAM.PRM_CODE = :CODE ';

    if AMagId <> 0 then
      sql := sql +
      '  AND GENPARAM.PRM_MAGID = :MAGID'
    else
      sql := sql +
      '  AND GENPARAM.PRM_MAGID = ( ' +
      '     SELECT GENBASES.BAS_MAGID ' +
      '     FROM GENBASES ' +
      '     WHERE GENBASES.BAS_IDENT = ( ' +
      '         SELECT PAR_STRING ' +
      '         FROM GENPARAMBASE ' +
      '         WHERE PAR_NOM = ''IDGENERATEUR'') ' +
      '     )';

    query := GetNewQuery(getConnection, getTransaction, sql);
    query.Params.ParamByName('TYPE').AsInteger := AType;
    query.Params.ParamByName('CODE').AsInteger := ACode;

    if AMagId <> 0 then
      query.Params.ParamByName('MAGID').AsInteger := AMagId;

    query.Open();
    if query.RecordCount = 1 then
    begin
      Result := query.Fields[0].AsVariant;
    end
    else if query.RecordCount = 0 then
    begin
      AddLog(Format('Impossible de trouver le PRM_TYPE %d PRM_CODE %d dans GENPARAM pour le magasins %d', [AType, ACode, AMagId]));
      Result := 0;
    end
    else if query.RecordCount > 1 then
    begin
      AddLog(Format('Plusieurs PRM_TYPE %d PRM_CODE %d dans GENPARAM pour le magasins %d', [AType, ACode, AMagId]));
      Result := 0;
    end;
  finally
    query.Close;
  end;
end;

function TRepriseCCGlobalPOSDBUtils.getGenParamValueInteger(AType, ACode, AMagId: integer): integer;
begin
  Result := getGenParamValue(AType, ACode, AMagId, gpvtInteger);
end;

function TRepriseCCGlobalPOSDBUtils.getGenParamValueString(AType, ACode, AMagId: integer): string;
begin
  Result := getGenParamValue(AType, ACode, AMagId, gpvtString);
end;

function TRepriseCCGlobalPOSDBUtils.getDisconnectCKDOQuery(AMAGId: integer; ListForMails: Boolean = False): TDataSet;
var
  sql: string;
  query: TMyQuery;
begin
  // selection des cartes qui sont en erreur d'appel
  sql :=
    'SELECT ' +
    'KDO_ID, ' +
    'KDO_NUMCARTE, ' +
    'KDO_NUMTRANS, ' +
    'KDO_MONTANT, ' +
    'KDO_TYPE, ' +
    'KDO_TKEID, ' +
    'KDO_APPELWS, ' +
    'KDO_DATE, ' +
    'POS_NOM, ' +
    'MAG_ENSEIGNE, ' +
    'SES_NUMERO, ' +
    'TKE_SEQUENCE ' +
    'FROM CSHCARTEKDO ' +
    'JOIN CSHTICKET ON TKE_ID = kdo_tkeid ' +
    'JOIN CSHSESSION ON TKE_SESID = SES_ID ' +
    'JOIN K ON K_ID = kdo_id and k_enabled = 1 ' +
    'JOIN GENPOSTE ON GENPOSTE.POS_ID = CSHSESSION.SES_POSID AND GENPOSTE.POS_MAGID = :MAGID '+
    'JOIN GENMAGASIN ON MAG_ID = POS_MAGID ' +
    'WHERE KDO_APPELWS = -999 ' +
    'AND ((KDO_CARDTYPE IS NULL) OR (KDO_CARDTYPE <> 4)) ' +
    'AND KDO_TYPE IN (''Annulation de ticket'', ''Annulation'', ''Suppression de ligne de compte'')'; // on ne traite que les annulations qui seraient en erreur

  // si on veut la liste de ceux qu'il faut prévenir par mail, on prend ceux qui ont plus de 24h, sinon ceux qui ont moins de 24h.
  if ListForMails then
    sql := sql + ' AND TKE_DATE < :DATE_LIMITE '
  else
    sql := sql + ' AND TKE_DATE > :DATE_LIMITE ';

  query := GetNewQuery(getConnection, sql, False);
  query.ParamByName('MAGID').AsInteger := AMagId;
  query.ParamByName('DATE_LIMITE').AsDateTime := IncDay(Now,-1);
  query.Open();
  Result := query;
end;

function TRepriseCCGlobalPOSDBUtils.getCKDOKO(): TDataSet;
var
  sql: string;
  query: TMyQuery;
begin
  // selection des cartes qui sont en erreur d'appel et non liées à un ticket
  sql := 'SELECT ' +
         'KDO_ID, ' +
         'KDO_NUMCARTE, ' +
         'KDO_NUMTRANS, ' +
         'KDO_MONTANT, ' +
         'KDO_TYPE, ' +
         'KDO_TKEID, ' +
         'KDO_APPELWS, ' +
         'KDO_DATE ' +
         'FROM CSHCARTEKDO ' +
         'JOIN K ON K_ID = kdo_id and k_enabled = 1 ' +
         'WHERE KDO_APPELWS = -999 ' +
         'AND ((KDO_CARDTYPE IS NULL) OR (KDO_CARDTYPE <> 4)) ' +
         'AND KDO_TYPE IN (''Annulation de ticket'', ''Annulation'', ''Suppression de ligne de compte'') ' +
         'AND KDO_TKEID = 0'; // on ne traite que les annulations qui seraient en erreur
  query := GetNewQuery(getConnection, sql, False);
  query.Open();
  Result := query;
end;

function TRepriseCCGlobalPOSDBUtils.NewK(ATableName: string): integer;
var
  storedproc: TMyStoredProc;
begin
  storedproc := GetNewStoredProc(getConnection, nil, 'PR_NEWK');
  storedproc.Prepare;
  storedproc.Params.ParamByName('TABLENAME').AsString := ATableName;

  storedproc.ExecProc;
  Result := storedproc.ParamByName('ID').AsInteger;
end;

procedure TRepriseCCGlobalPOSDBUtils.UpdateK(AId: integer; AType: integer);
var
  storedproc: TMyStoredProc;
begin
  storedproc := GetNewStoredProc(getConnection, nil, 'PR_UPDATEK');
  storedproc.Prepare;
  storedproc.Params.ParamByName('K_ID').AsInteger := AId;
  storedproc.Params.ParamByName('SUPRESSION').AsInteger := AType;

  storedproc.ExecProc;
end;

end.
