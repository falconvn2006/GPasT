unit uManageCodeBarreType1;

interface

Type

  RArticleTaille = Record
    FTgfId: integer;
    FItemId: string;
    FTaille: string;
    FTavail: integer;
    FCodeTaille: string;
    procedure SetValues(ATgfId: integer; AItemId: string; ATaille: string;
      ATavail: integer; ACodeTaille: string);
  End;
  TArticleTailleArray = array of RArticleTaille;

  RArticleCouleur = Record
    FCouId: integer;
    FColorisId: string;
    FColorisCode: string;
    FDescriptif: string;
    FItemId: string;
    FValide: integer;
    procedure SetValues(ACouId: integer; AColorisId: string; AColorisCode: string;
      ADescriptif: string; AItemId: string; AValide: integer);
  End;
  TArticleCouleurArray = array of RArticleCouleur;

  RArticleCodeBarreType1 = Record
    ArfId: integer;
    TgfId: integer;
    CouId: Integer;
    CBType1Exist: boolean;
    CBType1: string;
    procedure SetValues(AArfId: integer; ATgfId: integer; ACouId: integer);
  End;
  TArticleCodeBarreType1Array = array of RArticleCodeBarreType1;

  TArticle = Class
  private
    FArtId: integer;
    FArfId: integer;
    FTailleArray: TArticleTailleArray;
    FCouleurArray: TArticleCouleurArray;

    FCBType1Array: TArticleCodeBarreType1Array;

    procedure Init;
    procedure InitTaille;
    procedure InitCouleur;

    procedure InitCBType1Array;
    procedure UpdateCBType1Values;

    function TailleExist(ATgfId: integer): boolean;
    function CouleurExist(ACouId: integer): boolean;
  public
    constructor Create(ArtId, ArfId: integer);
    destructor Destroy;

    procedure AddTaille(TgfId: integer; ItemId: string; Taille: string;
      Tavail: integer; CodeTaille: string);

    procedure AddCouleur(CouId: integer; ColorisId: string; ColorisCode: string;
      Descriptif: string; ItemId: string; Valide: integer);

    function MissingType1CB: TArticleCodeBarreType1Array;
  End;

implementation

uses
  IBQuery, IntNikePrin_FRM;

{ TArticle }

procedure TArticle.AddCouleur(CouId: integer; ColorisId, ColorisCode,
  Descriptif, ItemId: string; Valide: integer);
var
  couleur: RArticleCouleur;
begin
  if not CouleurExist(CouId) then
  begin
    couleur.SetValues(CouId, ColorisId, ColorisCode, Descriptif, ItemId, Valide);
    SetLength(FCouleurArray, Length(FCouleurArray) + 1);
    FCouleurArray[length(FCouleurArray) - 1] := couleur;
  end;
end;

procedure TArticle.AddTaille(TgfId: integer; ItemId, Taille: string;
  Tavail: integer; CodeTaille: string);
var
  tailleRec: RArticleTaille;
begin
  if not TailleExist(TgfId) then
  begin
    tailleRec.SetValues(tgfid, itemid, taille, tavail, codetaille);
    SetLength(FTailleArray, Length(FTailleArray) + 1);
    FTailleArray[length(FTailleArray) - 1] := taillerec;
  end;
end;

function TArticle.CouleurExist(ACouId: integer): boolean;
var
  i: integer;
begin
  Result := False;
  i := 0;
  while Not Result and (i < Length(FCouleurArray)) do
  begin
    Result := FCouleurArray[i].FCouId = ACouId;       
    inc(i);
  end;
end;

constructor TArticle.Create(ArtId, ArfId: integer);
begin
  FArtId := ArtId;
  FArfId := ArfId;

  SetLength(FTailleArray, 0);
  SetLEngth(FCouleurArray, 0);
  SetLength(FCBType1Array, 0);

  Init;
end;

destructor TArticle.Destroy;
begin
  SetLength(FTailleArray, 0);
  SetLEngth(FCouleurArray, 0);
  SetLength(FCBType1Array, 0);
end;

procedure TArticle.Init;
begin
  InitCouleur;
  InitTaille;
end;

procedure TArticle.InitCBType1Array;
var
  i, j: integer;
  cbtype1: RArticleCodeBarreType1;
begin
  SetLength(FCBType1Array, 0);

  for i := 0 to Length(FCouleurArray) - 1 do
  begin
    for j := 0 to Length(FTailleArray) - 1 do
    begin
      cbtype1.SetValues(
        FArfId, FTailleArray[j].FTgfId, FCouleurArray[i].FCouId);

      SetLength(FCBType1Array, Length(FCBType1Array) + 1);
      FCBType1Array[Length(FCBType1Array) - 1] := cbtype1;
    end;
  end;
end;

procedure TArticle.InitCouleur;
var
  query: TIBQuery;   
begin
  query := TIBQuery.Create(nil);
  query.Database := Frm_IntNikePrin.Data;

  query.SQL.Text :=
    'SELECT ' +
    '  PLXCOULEUR.COU_ID, PLXCOULEUR.COU_CODE, PLXCOULEUR.COU_NOM ' +
    'FROM ' +
    ' PLXCOULEUR JOIN K ON K.K_ID = PLXCOULEUR.COU_ID AND K.K_ENABLED = 1 ' +
    'WHERE ' +
    '  COU_ARTID = :ARTID';
  query.ParamByName('ARTID').AsInteger := FArtId;

  query.Open;
  while not query.eof do
  begin
    AddCouleur(query.FieldByName('COU_ID').AsInteger, '',
      query.FieldByName('COU_CODE').AsString, query.FieldByName('COU_NOM').AsString,
      '', -1);
    query.next;
  end;
  query.Close;
  query.Free;
end;

procedure TArticle.InitTaille;
var
  query: TIBQuery;
begin
  query := TIBQuery.Create(nil);
  query.Database := Frm_IntNikePrin.Data;

  query.SQL.Text :=
    'SELECT ' +
    '  PLXTAILLESGF.TGF_ID, PLXTAILLESGF.TGF_NOM ' +
    'FROM ' +
    '  PLXTAILLESGF JOIN K ON K.K_ID = PLXTAILLESGF.TGF_ID AND K.K_ENABLED = 1 ' +
    '  JOIN PLXTAILLESTRAV ON PLXTAILLESTRAV.TTV_TGFID = PLXTAILLESGF.TGF_ID ' +
    '    JOIN K ON K.K_ID = PLXTAILLESTRAV.TTV_ID AND K.K_ENABLED = 1 ' +
    'WHERE ' +
    '  TTV_ARTID = :ARTID';
  query.ParamByName('ARTID').AsInteger := FArtId;

  query.Open;
  while not query.eof do
  begin
    AddTaille(query.FieldByName('TGF_ID').AsInteger, '',
      query.FieldByName('TGF_NOM').AsString, -1, '');
    query.next;
  end;
  query.Close;
  query.Free;
end;

function TArticle.MissingType1CB: TArticleCodeBarreType1Array;
var
  i: integer;
begin
  InitCBType1Array;
  UpdateCBType1Values;

  SetLength(Result, 0);
  for i := 0 to Length(FCBType1Array) - 1 do
  begin
    if not FCBType1Array[i].CBType1Exist then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := FCBType1Array[i];
    end;
  end;
end;

function TArticle.TailleExist(ATgfId: integer): boolean;
var
  i: integer;
begin
  Result := False;
  i := 0;
  while Not Result and (i < Length(FTailleArray)) do
  begin
    Result := FTailleArray[i].FTgfId = ATgfId;       
    inc(i);
  end;
end;

procedure TArticle.UpdateCBType1Values;
var
  i: integer;
  updated: boolean;
  query: TIBQuery;
begin
  query := TIBQuery.Create(nil);
  query.Database := Frm_IntNikePrin.Data;
  query.SQL.Text :=
    'SELECT ' +
    '  ARTCODEBARRE.CBI_ID, ARTCODEBARRE.CBI_ARFID, ARTCODEBARRE.CBI_TGFID, ARTCODEBARRE.CBI_COUID, ARTCODEBARRE.CBI_CB ' +
    'FROM ' +
    '  ARTCODEBARRE JOIN K ON K.K_ID = ARTCODEBARRE.CBI_ID ' +
    'WHERE ' +
    '  artcodebarre.cbi_arfid = :ARFID AND ' +
    '  artcodebarre.cbi_type = 1';
  query.ParamByName('ARFID').AsInteger := FArfId;
  query.Open;

  while not query.Eof do
  begin
    i := 0;
    updated := False;
    while not updated and (i < Length(FCBType1Array)) do
    begin
      if (FCBType1Array[i].TgfId = query.FieldByName('CBI_TGFID').AsInteger) and
        (FCBType1Array[i].CouId = query.FieldByName('CBI_COUID').AsInteger) then
      begin
        FCBType1Array[i].CBType1Exist := True;
        FCBType1Array[i].CBType1 := query.FieldByName('CBI_CB').AsString;
        updated := True;
      end;
      inc(i);
    end;
    query.Next;
  end;
  query.Close;
  query.Free;
end;

{ RArticleCouleur }

procedure RArticleCouleur.SetValues(ACouId: integer; AColorisId, AColorisCode,
  ADescriptif, AItemId: string; AValide: integer);
begin
  FCouId := ACouId;
  FColorisId := AColorisId;
  FDescriptif := ADescriptif;
  FItemId := AItemId;
  FValide := AValide;     
end;

{ RArticleTaille }

procedure RArticleTaille.SetValues(ATgfId: integer; AItemId, ATaille: string;
  ATavail: integer; ACodeTaille: string);
begin
  FTgfId := ATgfId;
  FItemId := AItemId;
  FTaille := ATaille;
  FTavail := ATavail;
  FCodeTaille := ACodeTaille;     
end;

{ RArticleCodeBarreType1 }

procedure RArticleCodeBarreType1.SetValues(AArfId, ATgfId, ACouId: integer);
begin
  ArfId := AArfId;
  TgfId := ATgfId;
  CouId := ACouId;
  CBType1Exist := False;
  CBType1 := '';
end;

end.
