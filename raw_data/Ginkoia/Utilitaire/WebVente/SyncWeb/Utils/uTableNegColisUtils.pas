unit uTableNegColisUtils;

interface

uses
  uGestionBDD,
  Classes,
  SysUtils;

type
  ETransporteurNotExistError = class(Exception);
  EBlNotExistError = class(Exception);

  TActionType = (atToDo = 1, atSend = 3);

  TTableNegColisUtils = class
  private
    FConnection: TMyConnection;
    FMyTransaction: TMyTransaction;

    function GetNegAction(AActionType: TActionType): integer;

    procedure UpdateNegColisDatas(ADataSet: TMyQuery; ABprId: integer; ANumColis: string;
      AIdTrans: integer; ACodeProduit, AMagasinRetrait, ACodeRelais: string);

  protected
    function GetQuery: TMyQuery;

    function FindBLENUMERO(ABleId: integer): string;

    { Si AQte = -1 on incremente le nombre de colis dans la table NEGBONPREPA }
    function UpsertBPRId(ABleId: integer; ABleNumero: string; AQte: integer; AActionType: TActionType): integer;
    function CreateNegListeAct(ABprID: integer; AArtId: integer; AActionType: TActionType): integer;
    function CreateNegBonPrepa(ABleId: integer; ABleNum: string; AQte: integer): integer;
    function CreateNegColis(ABprId: integer; ANumColis: string; AIdTrans: integer;
      ACodeProduit: string; AMagasinRetrait: string; ACodeRelais: string): integer;

    function UpdateNegColis(ABprId: integer; ANumColis: string;
      AIdTrans: integer; ACodeProduit: string; AMagasinRetrait: string;
      ACodeRelais: string): integer;

    function GetNEGBLArticles(ABleId: integer): TStrings;
  public
    constructor Create(AConnection: TMyConnection);
    destructor Destroy; override;

    function AddColis(ACommandeId: integer; AColisNumero, ACodeTransporteur,
      ATransporteur, ACodeProduit, AMagasinRetrait,
      ACodeRelais: String): integer; overload;

    function AddColis(ABLEId: integer; AColisNumero: string; AColisQte,
      ACodeTransporteur: integer; ACodeProduit: string;
      AMagasinRetrait: string; ACodeRelais: String): integer; overload;

    ///<summary> Pour spécifier que le colis à été envoyé</sumary>
    function FinishColis(ABLEId: integer; AColisNumero: string; AColisNumber,
      ACodeTransporteur: integer): integer;

    function FindBLE(ABleWebId: integer): integer;
    function FindTRA(ATraCode: integer): integer;

    function CBPNumExist(ACBPNum: string): boolean;

    property Transaction: TMyTransaction read FMyTransaction write FMyTransaction;
  end;

var
  FTableNegColisUtils: TTableNegColisUtils;

implementation

uses
  uGenerique;

{ TTableNegColisUtils }

function TTableNegColisUtils.AddColis(ACommandeId: integer; AColisNumero,
  ACodeTransporteur, ATransporteur, ACodeProduit,
  AMagasinRetrait, ACodeRelais: String): integer;
var
  bleid: integer;
  bprid: integer;
  traid: integer;
  blenumero: string;
begin
  bleid := FindBLE(ACommandeId);

  if bleid <> -1 then
  begin
    traid := FindTRA( StrToIntDef(ACodeTransporteur, -1) );
    blenumero := FindBLENUMERO(bleid);
    bprid := UpsertBPRId(bleid, blenumero, 1, atToDo);
    Result := CreateNegColis(bprid, AColisNumero, traid, ACodeProduit, AMagasinRetrait, ACodeRelais);
  end;
end;

function TTableNegColisUtils.AddColis(ABLEId: integer; AColisNumero: string;
  AColisQte, ACodeTransporteur: integer; ACodeProduit, AMagasinRetrait,
  ACodeRelais: String): integer;
var
  bprid: integer;
  blenumero: string;
begin
  bprid := UpsertBPRId(ABLEId, blenumero, AColisQte, atToDo);
  Result := CreateNegColis(bprid, AColisNumero, ACodeTransporteur, ACodeProduit,
    AMagasinRetrait, ACodeRelais);
end;

function TTableNegColisUtils.CBPNumExist(ACBPNum: string): boolean;
var
  query: TMyQuery;
begin
  query := GetQuery;

  try
    query.SQL.Text := 'SELECT CBP_ID FROM NEGCOLIS WHERE CBP_NUM = :CBPNUM';
    query.Params.ParamByName('CBPNUM').AsString := ACBPNum;
    query.Open;
    Result := not query.IsEmpty;
  finally
    query.Close;
    query.Free;
  end;
end;

constructor TTableNegColisUtils.Create(AConnection: TMyConnection);
begin
  FConnection := AConnection;
end;

function TTableNegColisUtils.CreateNegBonPrepa(ABleId: integer; ABleNum: string; AQte: integer): integer;
var
  query: TMyQuery;
begin
  try
    query := GetQuery;
    query.SQL.Clear;
    query.SQL.Text :=
      'INSERT INTO ' +
      '  NEGBONPREPA(BPR_ID, BPR_BLEID, BPR_NUM, BPR_ACTID, BPR_NBCOLIS, BPR_FINI, BPR_ARCHIVE) ' +
      '  VALUES (:ID, :BLEID, :NUM, :ACTID, :NBCOLIS, :FINI, :ARCHIVE)';

    Result := NewK('NEGBONPREPA');
    query.Params.ParamByName('ID').AsInteger := Result;
    query.Params.ParamByName('BLEID').AsInteger := ABleId;
    query.Params.ParamByName('NUM').AsString:= ABleNum;
    query.Params.ParamByName('ACTID').AsInteger := GetNegAction(atToDo);
    query.Params.ParamByName('NBCOLIS').AsInteger := AQte;
    query.Params.ParamByName('FINI').AsInteger := 1;
    query.Params.ParamByName('ARCHIVE').AsInteger := 0;

    query.ExecSQL;
  finally
    query.Close;
    query.Free;
  end;
end;

function TTableNegColisUtils.CreateNegColis(ABprId: integer; ANumColis: string;
  AIdTrans: integer; ACodeProduit: string; AMagasinRetrait: string;
  ACodeRelais: string): integer;
var
  query: TMyQuery;
begin
  Result := -1;
  query := GetQuery;

  try
    query.SQL.Clear;
    query.SQL.Text := 'SELECT * FROM NEGCOLIS';
    query.Open;

    query.Insert;
    Result := NewK('NEGCOLIS');
    query.FieldByName('CBP_ID').AsInteger := Result;
    UpdateNegColisDatas(query, ABprId, ANumColis, AIdTrans, ACodeProduit, AMagasinRetrait, ACodeRelais);

    query.Post;
  finally
    query.Close;
    query.Free;
  end;
end;

function TTableNegColisUtils.CreateNegListeAct(ABprID,
  AArtId: integer; AActionType: TActionType): integer;
var
  query: TMyQuery;
begin
  //Si le ArtId est 0 on insert pas d'enregistrement dans le table NegListAct
  if AArtId <> 0 then
  begin
    try
      query := GetQuery;
      query.SQL.Clear;
      query.SQL.Text :=
        'INSERT INTO ' +
        '  NEGLISTEACT(LAC_ID, LAC_BPRID, LAC_ARTID, LAC_ACTID, LAC_FAIT, LAC_DATE, LAC_USRID) ' +
        '  VALUES (:ID, :BPRID, :ARTID, :ACTID, :FAIT, :DATE, 0)';

      Result := NewK('NEGLISTEACT');
      query.Params.ParamByName('ID').AsInteger := Result;
      query.Params.ParamByName('BPRID').AsInteger := ABprId;
      query.Params.ParamByName('ARTID').AsInteger:= AArtId;
      query.Params.ParamByName('ACTID').AsInteger := GetNegAction(AActionType);
      query.Params.ParamByName('FAIT').AsInteger := 0;
      query.Params.ParamByName('DATE').AsDateTime := Now();

      query.ExecSQL;
    finally
      query.Close;
      query.Free;
    end;
  end;
end;

destructor TTableNegColisUtils.Destroy;
begin

  inherited;
end;

function TTableNegColisUtils.FindBLE(ABleWebId: integer): integer;
var
  query: TMyQuery;
begin
  query := GetQuery;

  try
    query.SQL.Clear;
    query.SQL.Text := 'SELECT BLE_ID FROM NEGBL WHERE BLE_IDWEB = :IDWEB';
    query.Params.ParamByName('IDWEB').AsInteger := ABleWebId;
    query.Open;

    if not query.IsEmpty then
      Result := query.FieldByName('BLE_ID').AsInteger
    else
      Raise EBlNotExistError.Create(Format('Unknown BL with IDWEB "%d"', [ABleWebId]));
  finally
    query.Close;
    query.Free;
  end;
end;

function TTableNegColisUtils.FindBLENUMERO(ABleId: integer): string;
var
  query: TMyQuery;
begin
  query := GetQuery;

  try
    query.SQL.Clear;
    query.SQL.Text := 'SELECT BLE_NUMERO FROM NEGBL WHERE BLE_ID = :ID';
    query.Params.ParamByName('ID').AsInteger := ABleId;
    query.Open;

    if not query.IsEmpty then
      Result := query.FieldByName('BLE_NUMERO').AsString
    else
      Result := '';
  finally
    query.Close;
    query.Free;
  end;
end;

function TTableNegColisUtils.FindTRA(ATraCode: integer): integer;
var
  query: TMyQuery;
begin
  query := GetQuery;

  try
    query.SQL.Text := 'SELECT TRA_ID FROM NEGTRANSPORT WHERE TRA_CODE = :TRACODE';
    query.Params.ParamByName('TRACODE').AsInteger := ATraCode;
    query.Open;

    if not query.IsEmpty then
      Result := query.FieldByName('TRA_ID').AsInteger
    else
      Raise ETransporteurNotExistError.Create( Format('Unknown transporteur "%s"', [ATraCode]));
  finally
    query.Close;
    query.Free;
  end;
end;

function TTableNegColisUtils.FinishColis(ABLEId: integer; AColisNumero: string;
  AColisNumber, ACodeTransporteur: integer): integer;
var
  bprid: integer;
  blenumero: string;
begin
  // Récupération ou Création du Bon de prepa
  bprid := UpsertBPRId(ABLEId, blenumero, AColisNumber, atSend);
  UpdateNegColis(bprid, AColisNumero, ACodeTransporteur, '', '', '');
end;

function TTableNegColisUtils.UpsertBPRId(ABleId: integer; ABleNumero: string; AQte: integer; AActionType: TActionType): integer;
var
  query: TMyQuery;
  list: TStrings;
  i: integer;
  s: string;
begin
  query := GetQuery;

  try
    query.SQL.Clear;
    query.SQL.Text := 'SELECT BPR_ID, BPR_NBCOLIS, BPR_ACTID, BPR_FINI FROM NEGBONPREPA WHERE BPR_BLEID = :BLEID';
    query.Params.ParamByName('BLEID').AsInteger := ABleId;
    query.Open;

    if not query.IsEmpty then
    begin
      Result := query.FieldByName('BPR_ID').AsInteger;
      query.Edit;
      if AQte = -1 then
        query.FieldByName('BPR_NBCOLIS').AsInteger := query.FieldByName('BPR_NBCOLIS').AsInteger + 1
      else
        query.FieldByName('BPR_NBCOLIS').AsInteger := AQte;

      query.FieldByName('BPR_ACTID').AsInteger := GetNegAction(AActionType);
      case AActionType of
        atToDo: query.FieldByName('BPR_FINI').AsInteger := 1;
        atSend: query.FieldByName('BPR_FINI').AsInteger := 2;
      end;
      query.Post;
    end
    else
    begin
      if AQte = -1 then
        AQte := 1;
      Result := CreateNegBonPrepa(ABleId, ABleNumero, AQte);
    end;

    //Récupération des actibles du BL
    list := GetNEGBLArticles(ABleId);

    for i := 0 to List.Count - 1 do
    begin
      s := List[i];
      CreateNegListeAct(Result, StrToIntDef(s, 0), AActionType);
    end;

  finally
    query.Close;
    query.Free;
  end;
end;

function TTableNegColisUtils.GetNegAction(AActionType: TActionType): integer;
var
  query: TMyQuery;
begin
  Result := 0;
  query := GetQuery;
  try
    query.SQL.Clear;
    query.SQL.Add('SELECT ACT_ID ');
    query.SQL.Add('FROM NEGACTION ');
    query.SQL.Add('WHERE ACT_NUM = :NUM');
    query.ParamByName('NUM').AsInteger := Ord(AActionType);

    query.Open;
    if not query.IsEmpty then
    begin
      Result := query.FieldByName('ACT_ID').AsInteger;
    end;
  finally
    query.Close;
    query.Free;
  end;
end;

function TTableNegColisUtils.GetNEGBLArticles(ABleId: integer): TStrings;
var
  query: TMyQuery;
begin
  Result := TStringList.Create;

  query := GetQuery;
  try
    query.SQL.Clear;
    query.SQL.Add('SELECT BLL_ARTID ');
    query.SQL.Add('FROM NEGBLL ');
    query.SQL.Add('WHERE BLL_BLEID = :BLEID');
    query.ParamByName('BLEID').AsInteger := ABleId;

    query.Open;
    if not query.IsEmpty then
    begin
      Result.Add(query.FieldByName('BLL_ARTID').AsString);
    end;
  finally
    query.Close;
    query.Free;
  end;
end;

function TTableNegColisUtils.GetQuery: TMyQuery;
begin
  if Assigned(FMyTransaction) then
  begin
    Result := GetNewQuery(FMyTransaction)
  end
  else
  begin
    Result := GetNewQuery(FConnection);
  end;
end;

function TTableNegColisUtils.UpdateNegColis(ABprId: integer; ANumColis: string;
  AIdTrans: integer; ACodeProduit, AMagasinRetrait,
  ACodeRelais: string): integer;
var
  query: TMyQuery;
begin
  Result := -1;
  query := GetQuery;

  try
    query.SQL.Clear;
    query.SQL.Text := 'SELECT * FROM NEGCOLIS WHERE CBP_BPRID = :BPRID AND (CBP_NUM = :NUMCOLIS OR CBP_NUM = '''')';
    query.ParamByName('BPRID').AsInteger := ABprId;
    query.ParamByName('NUMCOLIS').AsString := ANumColis;
    query.Open;

    if query.IsEmpty then
    begin
      query.Insert;
      Result := NewK('NEGCOLIS');
      query.FieldByName('CBP_ID').AsInteger := Result;
    end
    else
    begin
      Result := query.FieldByName('CBP_ID').AsInteger;
      query.Edit;
    end;

    UpdateNegColisDatas(query, ABprId, ANumColis, AIdTrans, ACodeProduit, AMagasinRetrait, ACodeRelais);

    query.Post;
  finally
    query.Close;
    query.Free;
  end;
end;

procedure TTableNegColisUtils.UpdateNegColisDatas(ADataSet: TMyQuery;
  ABprId: integer; ANumColis: string; AIdTrans: integer; ACodeProduit, AMagasinRetrait, ACodeRelais: string);
begin
  ADataSet.FieldByName('CBP_BPRID').AsInteger := ABprId;
  ADataSet.FieldByName('CBP_NUM').AsString := ANumColis;
  ADataSet.FieldByName('CBP_POIDS').AsFloat:= 0;
  ADataSet.FieldByName('CBP_TYPE').AsInteger := 0;
  ADataSet.FieldByName('CBP_SAMEDI').AsInteger := 0;
  ADataSet.FieldByName('CBP_ASSUR').AsFloat:= 0;
  ADataSet.FieldByName('CBP_DOUANE').AsFloat:= 0;
  ADataSet.FieldByName('CBP_TRAID').AsInteger := AIdTrans;
  ADataSet.FieldByName('CBP_TRANSMIS').AsDateTime:= Now;
  ADataSet.FieldByName('CBP_TPRID1').AsInteger := 0;
  ADataSet.FieldByName('CBP_TPRID2').AsInteger := 0;
  ADataSet.FieldByName('CBP_TPRID3').AsInteger := 0;
  ADataSet.FieldByName('CBP_REF2').AsString:= '';

  // On vérifie la précense de certains champs pour la compatibilité version de BDD
  if Assigned(ADataSet.Fields.FindField('CBP_CODERELAIS')) and (ACodeRelais <> '') then
    ADataSet.FieldByName('CBP_CODERELAIS').AsString := ACodeRelais;

  if Assigned(ADataSet.Fields.FindField('CBP_MAGASINRETRAIT')) and (AMagasinRetrait <> '') then
    ADataSet.FieldByName('CBP_MAGASINRETRAIT').AsString := AMagasinRetrait;

  if Assigned(ADataSet.Fields.FindField('CBP_CODEPRODUIT')) and (ACodeProduit <> '') then
    ADataSet.FieldByName('CBP_CODEPRODUIT').AsString := ACodeProduit;
end;

end.
