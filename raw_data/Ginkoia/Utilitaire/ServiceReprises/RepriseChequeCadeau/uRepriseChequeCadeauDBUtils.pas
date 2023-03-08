unit uRepriseChequeCadeauDBUtils;

interface

uses
  uGestionBDD, Data.DB, System.Classes, ulog,StrUtils ;

type
  wsCallType = (wsctInsert, wsctCancel, wsctForce);
  GenParamValueType = (gpvtInteger, gpvtString, gpvtFloat);

  TMagasin = record
    FId: integer;
    FName: string;
  end;

  TMagasinArray = array of TMagasin;

  TRepriseChequeCadeauDBUtils = class
  private
    FDataBaseFile: string;
    FConnection: TMyConnection;
    FTransaction: TMyTransaction;
    FOnLog: TLogEvent;

    function getConnection: TMyConnection;
    function getTransaction: TMyTransaction;

    { Permet de savoir si la session de caisse est toujours ouverte }
    function SessionOpened(ACKDID: integer): boolean;

    function getGenParamValue(AType, ACode, AMagId: integer; AReturnType: GenParamValueType): Variant;

    function NewK(ATableName: string): integer;
    procedure UpdateK(AId: integer; AType: integer = 0);

    procedure AddLog(ALogMessage: string; ALogLevel: TLogLevel = logTrace);
    procedure SetOnLog(const Value: TLogEvent);
  public
    constructor Create(ADataBaseFile: string); overload;

    procedure closeConnection;

    procedure UpdateCKD(ACKDID: integer; AEmetteur, ATitre: string; AMontant: Double);
    procedure CreateCKT(AMode: wsCallType; ACKDID: integer; wsCalledDate: TDateTime;
      wsId: string; wsErrorCode: integer; wsMessage: string; ACKTANNUL: string; NeedRetry: boolean);
    procedure UpdateCKTTraite(ACKTID: integer; ATraite: string = '1');
    function CountCKTTentative(aCKDID, ACodeError: Integer): Integer;

    function getGenBaseBasCodeTiersValue(AMagId: integer): string;
    function getGenParamValueString(AType, ACode, AMagId: integer): string;
    function getGenParamValueInteger(AType, ACode, AMagId: integer): integer;

    function getDisconnectCKDQuery(AMAGId: integer): TDataSet;
    function getNUMTRANS(ACKDId: integer): string;

    function ModuleDematChequeCadeauEnabled(AMagId: Integer): boolean;
    function ListMagasins(AWithDematChequeCadeauEnabled: boolean = False): TMagasinArray;

    procedure UpdateCSHEncaissement(ACKDID, ACKDENCID: integer; AEmetteur: string;
      AMagId: integer);

    function getGUID(AMagId: integer): string;
    function getURL(AMagId: integer): string;

    property DataBaseFile: string read FDataBaseFile write FDataBaseFile;

    property OnLog: TLogEvent read FOnLog write SetOnLog;
  end;

var
  FRepriseChequeCadeauDBUtils: TRepriseChequeCadeauDBUtils;

implementation

uses
  System.SysUtils;

{ TRepriseChequeCadeauDBUtils }

function TRepriseChequeCadeauDBUtils.getConnection: TMyConnection;
begin
  if not Assigned(FConnection) then
  begin
    FConnection := GetNewConnexion(DataBaseFile, CST_GINKOIA_LOGIN, CST_GINKOIA_PASSWORD, False);
    try
      FConnection.Open;
    except
      on E: Exception do
      begin
        AddLog('Impossible de se connecter à la base: "' + DataBaseFile);
        AddLog(E.Message);

        Raise;
      end;
    end;
  end;

  result := FConnection;
end;

function TRepriseChequeCadeauDBUtils.getTransaction: TMyTransaction;
begin
//  if not Assigned(FTransaction) then
//    FTransaction := GetNewTransaction(getConnection);

//  result := FTransaction;
  result := nil;
end;

function TRepriseChequeCadeauDBUtils.getURL(AMagId: integer): string;
begin
  result := getGenParamValueString(3, 131, AMagId);
  if RightStr(result,1)<>'/' then
    result := result + '/';
end;

function TRepriseChequeCadeauDBUtils.getGUID(AMagId: integer): string;
begin
  result := getGenParamValueString(3, 132, AMagId);
end;

function TRepriseChequeCadeauDBUtils.getNUMTRANS(ACKDId: integer): string;
var
  query: TMyQuery;
begin
  try
    query := GetNewQuery(getConnection, getTransaction,
      'SELECT ' +
      '   CKT_NUMTRANS  ' +
      'FROM ' +
      '   CSHCHEQUETRT JOIN K ON K.K_ID = CSHCHEQUETRT.CKT_ID AND K.K_ENABLED = 1 ' +
      'WHERE ' +
      '   CSHCHEQUETRT.CKT_CKDID = :CKDID AND CSHCHEQUETRT.CKT_NUMTRANS IS NOT NULL ' +
      '     AND CSHCHEQUETRT.CKT_NUMTRANS <> ''''');
    query.Params.ParamByName('CKDID').AsInteger := ACKDId;
    query.Open;
    if query.RecordCount > 0 then
      Result := query.FieldByName('CKT_NUMTRANS').AsString
    else
      AddLog(Format('Impossible de trouver de numtrans pour le CKDID %s', [IntToStr(ACKDID)]));
  finally
    query.Close;
    query.Free;
  end;
end;

function TRepriseChequeCadeauDBUtils.ListMagasins(AWithDematChequeCadeauEnabled: boolean = False): TMagasinArray;
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
      if not AWithDematChequeCadeauEnabled or (AWithDematChequeCadeauEnabled
        and ModuleDematChequeCadeauEnabled(query.FieldByName('MAG_ID').AsInteger)) then
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

function TRepriseChequeCadeauDBUtils.ModuleDematChequeCadeauEnabled(
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
  query.ParamByName('MODULENAME').AsString := 'DEMATCHEQUECADEAU';
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

procedure TRepriseChequeCadeauDBUtils.UpdateCKD(ACKDID: integer; AEmetteur, ATitre: string; AMontant: Double);
var
  query: TMyQuery;
begin
  try
    query := GetNewQuery(getConnection, getTransaction,
      'UPDATE ' +
      ' CSHCHEQUEKDO ' +
      'SET ' +
      ' CKD_EMETTEUR = :CKDEMETTEUR, ' +
      ' CKD_TITRE = :CKDTITRE,  ' +
      ' CKD_MONTANT = :CKDMONTANT ' +
      'WHERE ' +
      ' CKD_ID = :CKDID');

    query.Params.ParamByName('CKDID').AsInteger := ACKDID;
    query.Params.ParamByName('CKDEMETTEUR').AsString := AEmetteur;
    query.Params.ParamByName('CKDTITRE').AsString := ATitre;
    query.Params.ParamByName('CKDMONTANT').AsFloat := AMontant;

    query.ExecSQL;
    UpdateK(ACKDID);
  finally
    query.Close;
  end;
end;

procedure TRepriseChequeCadeauDBUtils.closeConnection;
begin
  if Assigned(FConnection) then
  begin
    FConnection.Close;
    FConnection.DisposeOf;
    FConnection := nil;
  end;
end;

constructor TRepriseChequeCadeauDBUtils.Create(ADataBaseFile: string);
begin
  inherited Create;

  FDataBaseFile := ADataBaseFile;
end;

procedure TRepriseChequeCadeauDBUtils.AddLog(ALogMessage: string;  ALogLevel: TLogLevel);
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

procedure TRepriseChequeCadeauDBUtils.CreateCKT(AMode: wsCallType; ACKDID: integer; wsCalledDate: TDateTime;
  wsId: string; wsErrorCode: integer; wsMessage: string; ACKTANNUL: string; NeedRetry: boolean);
var
  query: TMyQuery;
begin
  try
    query := GetNewQuery(getConnection, nil,
      'INSERT INTO ' +
      ' CSHCHEQUETRT ( ' +
      '   CKT_ID, ' +
      '   CKT_CKDID, ' +
      '   CKT_DATE, ' +
      '   CKT_TYPE, ' +
      '   CKT_ANNUL, ' +
      '   CKT_APPELWS, ' +
      '   CKT_OKTRANS, ' +
      '   CKT_RETTRANS, ' +
      '   CKT_NUMTRANS, ' +
      '   CKT_MOTIF, ' +
      '   CKT_TRAITE)' +
      'VALUES ( ' +
      ' :CKTID, ' +
      ' :CKTCKDID, ' +
      ' :CKTDATE, ' +
      ' :CKTTYPE, ' +
      ' :CKTANNUL, ' +
      ' :CKTAPPELWS, ' +
      ' :CKTOKTRANS, ' +
      ' :CKTRETTRANS, ' +
      ' :CKTNUMTRANS, ' +
      ' :CKTMOTIF, ' +
      ' :CKTTRAITE)');
    query.Params.ParamByName('CKTID').AsInteger := NewK('CSHCHEQUETRT');
    query.Params.ParamByName('CKTCKDID').AsInteger := ACKDID;
    query.Params.ParamByName('CKTDATE').AsDateTime := wsCalledDate;

    case AMode of
      wsctInsert: // Utilisation d'un cheque cadeau
      begin
        query.Params.ParamByName('CKTTYPE').AsInteger := 0;
        query.Params.ParamByName('CKTNUMTRANS').AsString := wsId;
      end;
      wsctCancel: // Annulation d'un cheque cadeau
      begin
        query.Params.ParamByName('CKTTYPE').AsInteger := 1;
        query.Params.ParamByName('CKTNUMTRANS').AsString := wsId;
      end;
      wsctForce: // Utilisation d'un cheque cadeau en mode déconnecté
      begin
        query.Params.ParamByName('CKTTYPE').AsInteger := 0;
        query.Params.ParamByName('CKTNUMTRANS').AsString := wsId;
      end;
    end;

    query.Params.ParamByName('CKTAPPELWS').AsInteger := Integer( not NeedRetry );
    query.Params.ParamByName('CKTOKTRANS').AsInteger := Integer( not NeedRetry );
    query.Params.ParamByName('CKTTRAITE').AsInteger := Integer( not NeedRetry );

    query.Params.ParamByName('CKTANNUL').AsString := ACKTANNUL;

    query.Params.ParamByName('CKTRETTRANS').AsInteger := wsErrorCode;
    query.Params.ParamByName('CKTMOTIF').AsString := wsMessage;

    query.ExecSQL;
  finally
    query.Close;
  end;
end;

procedure TRepriseChequeCadeauDBUtils.UpdateCKTTraite(ACKTID: integer; ATraite: string);
var
  query: TMyQuery;
begin
  try
    query := GetNewQuery(
      getConnection, nil,
      'UPDATE ' +
      '  CSHCHEQUETRT ' +
      'SET ' +
      '  CKT_TRAITE = :CKTTRAITE ' +
      'WHERE ' +
      '  CKT_ID = :CKTID');

    query.Params.ParamByName('CKTID').AsInteger := ACKTID;
    query.Params.ParamByName('CKTTRAITE').AsString := ATraite;
    query.ExecSQL;

    UpdateK(ACKTID);
  finally
    query.Close;
  end;
end;

function TRepriseChequeCadeauDBUtils.CountCKTTentative(aCKDID: integer; ACodeError: Integer): Integer;
var
  query: TMyQuery;
begin
  Result := 0;

  try
    try
    query := GetNewQuery(getConnection, getTransaction,
      'SELECT ' +
      '   COUNT(CKT_ID) AS nb_tentative  ' +
      'FROM ' +
      '   CSHCHEQUETRT JOIN K ON K.K_ID = CSHCHEQUETRT.CKT_ID AND K.K_ENABLED = 1 ' +
      'WHERE ' +
      '   CSHCHEQUETRT.CKT_CKDID = :CKDID AND CSHCHEQUETRT.CKT_RETTRANS = :wsCodeError ');
    query.Params.ParamByName('CKDID').AsInteger := aCKDID;
    query.Params.ParamByName('wsCodeError').AsInteger := ACodeError;
    query.Open;
    if query.RecordCount > 0 then
      Result := query.FieldByName('nb_tentative').AsInteger
    else
      AddLog(Format('Impossible de faire le Count pour pour le CKDID %s et le code d''erreur %s', [IntToStr(ACKDID), IntToStr(ACodeError)]));
  finally
    query.Close;
    query.Free;
  end;
  finally
    query.Close;
  end;
end;

procedure TRepriseChequeCadeauDBUtils.UpdateCSHEncaissement(ACKDID, ACKDENCID: integer;
  AEMetteur: string; AMagId: integer);
var
  query: TMyQuery;
begin
  if SessionOpened(ACKDID) then
  begin
    query := GetNewQuery(getConnection, getTransaction,
      'UPDATE CSHENCAISSEMENT ' +
      'SET CSHENCAISSEMENT.ENC_MENID = ( ' +
      ' SELECT ' +
      '   CSHEMETTEURENC.CKE_MENID ' +
      ' FROM ' +
      '   CSHEMETTEURENC ' +
      ' WHERE ' +
      '   CSHEMETTEURENC.CKE_CODE = :CKDEMETTEUR ' +
      '   AND CSHEMETTEURENC.CKE_MAGID = :MAGID) ' +
      'WHERE ' +
      ' CSHENCAISSEMENT.ENC_ID = :CKDENCID');
    try
      query.ParamByName('CKDEMETTEUR').AsString := AEmetteur;
      query.ParamByName('CKDENCID').AsInteger := ACKDENCID;
      query.ParamByName('MAGID').AsInteger := AMagId;

      query.ExecSQL;
      UpdateK(ACKDENCID, 0);
    finally
      query.Close;
    end;
  end;
end;

function TRepriseChequeCadeauDBUtils.SessionOpened(ACKDID: integer): boolean;
var
  query: TMyQuery;
begin
  query := GetNewQuery(getConnection, getTransaction,
    'SELECT ' +
    ' CSHSESSION.SES_FIN ' +
    'FROM ' +
    ' CSHSESSION ' +
    ' JOIN CSHCHEQUEKDO ON CSHCHEQUEKDO.CKD_SESID = CSHSESSION.SES_ID ' +
    '   AND CSHCHEQUEKDO.CKD_ID = :CKDID');

  try
    query.ParamByName('CKDID').AsInteger := ACKDID;
    query.Open;
    Result := query.FieldByName('SES_FIN').AsDateTime = 0;
  finally
    query.Close;
  end;
end;

procedure TRepriseChequeCadeauDBUtils.SetOnLog(const Value: TLogEvent);
begin
  FOnLog := Value;
end;

function TRepriseChequeCadeauDBUtils.getGenBaseBasCodeTiersValue(AMagId: integer): string;
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

function TRepriseChequeCadeauDBUtils.getGenParamValue(AType, ACode, AMagId: integer;
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
      '  JOIN K ON K.K_ID = PRM_ID AND K.K_ENABLED = 1 ' +
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

function TRepriseChequeCadeauDBUtils.getGenParamValueInteger(AType, ACode, AMagId: integer): integer;
begin
  Result := getGenParamValue(AType, ACode, AMagId, gpvtInteger);
end;

function TRepriseChequeCadeauDBUtils.getGenParamValueString(AType, ACode, AMagId: integer): string;
begin
  Result := getGenParamValue(AType, ACode, AMagId, gpvtString);
end;

function TRepriseChequeCadeauDBUtils.getDisconnectCKDQuery(AMAGId: integer): TDataSet;
var
  sql: string;
  query: TMyQuery;
begin
  sql :=
    'SELECT ' +
    ' CKT_ID AS CKTID, ' +
    ' CKT_NUMTRANS AS CKTNUMTRANS, ' +
    ' CKT_TYPE AS CKTTYPE, ' +
    ' CKD_ID AS CKDID, ' +
    ' CKD_ENCID AS ENCID, ' +
    ' CKD_SESID AS SESID, ' +
    ' CKD_CB AS CKDCB, ' +
    ' CKD_TKEID AS TKEID, ' +
    ' POS_NOM AS POSNOM ' +
    'FROM ' +
    ' CSHCHEQUETRT ' +
    ' JOIN CSHCHEQUEKDO ON CSHCHEQUEKDO.CKD_ID = CSHCHEQUETRT.CKT_CKDID ' +
    '   AND CSHCHEQUEKDO.CKD_TKEID <> 0 ' +
    ' JOIN CSHSESSION ON CSHSESSION.SES_ID = CSHCHEQUEKDO.CKD_SESID ' +
    ' JOIN GENPOSTE ON GENPOSTE.POS_ID = CSHSESSION.SES_POSID AND GENPOSTE.POS_MAGID = :MAGID ' +
    ' JOIN K ON K.K_ID = CSHCHEQUETRT.CKT_ID AND K.K_ENABLED = 1 ' +
    'WHERE ' +
    '   CSHCHEQUETRT.CKT_TRAITE = 0 ' +
    'ORDER BY ' +
    '   CSHCHEQUETRT.CKT_DATE';
  query := GetNewQuery(getConnection, sql, False);
  query.ParamByName('MAGID').AsInteger := AMagId;
  query.Open();
  Result := query;
end;

function TRepriseChequeCadeauDBUtils.NewK(ATableName: string): integer;
var
  storedproc: TMyStoredProc;
begin
  storedproc := GetNewStoredProc(getConnection, nil, 'PR_NEWK');
  storedproc.Prepare;
  storedproc.Params.ParamByName('TABLENAME').AsString := ATableName;

  storedproc.ExecProc;
  Result := storedproc.ParamByName('ID').AsInteger;
end;

procedure TRepriseChequeCadeauDBUtils.UpdateK(AId: integer; AType: integer);
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
