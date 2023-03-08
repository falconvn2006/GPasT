unit uArticle;

interface

uses SysUtils, uSynchroObjBDD, uGestionBDD, uModele, uTaille, uCouleur;

type
  {$M+}
  TArticle = class(TMyObject)
  private
    FModele: TModele;
    FTaille: TTaille;
    FCouleur: TCouleur;

  public
    constructor Create(const nArtID, nTgfID, nCouID: Integer; aQuery: TMyQuery);   overload;
    constructor Create(Modele: TModele; Taille: TTaille; Couleur: TCouleur);   overload;
    function IsValid(aQuery: TMyQuery): Boolean;
    destructor Destroy;   override;

  published
    property Modele: TModele read FModele write FModele;
    property Taille: TTaille read FTaille write FTaille;
    property Couleur: TCouleur read FCouleur write FCouleur;
  end;
  {$M-}

implementation

{ TArticle }

constructor TArticle.Create(const nArtID, nTgfID, nCouID: Integer; aQuery: TMyQuery);
begin
  FModele := TModele.Create;
  FModele.Id := nArtID;
  FModele.doLoad(aQuery);

  FTaille := TTaille.Create;
  FTaille.Id := nTgfID;
  FTaille.doLoad(aQuery);

  FCouleur := TCouleur.Create;
  FCouleur.Id := nCouID;
  FCouleur.doLoad(aQuery);
end;

constructor TArticle.Create(Modele: TModele; Taille: TTaille; Couleur: TCouleur);
begin
  if not Assigned(Modele) then
    raise Exception.Create('Erreur :  pas de TModele !');
  FModele := Modele;

  if not Assigned(Taille) then
    raise Exception.Create('Erreur :  pas de TTaille !');
  FTaille := Taille;

  if not Assigned(Couleur) then
    raise Exception.Create('Erreur :  pas de TCouleur !');
  FCouleur := Couleur;
end;

function TArticle.IsValid(aQuery: TMyQuery): Boolean;
begin
  Result := False;

  // Recherche de l'article.
  aQuery.Close;
  aQuery.SQL.Clear;
  aQuery.SQL.Add('select ART_ID');
  aQuery.SQL.Add('from ARTARTICLE join K on (K_ID = ART_ID and K_ENABLED = 1)');
  aQuery.SQL.Add('join PLXTAILLESTRAV on (TTV_ARTID = ART_ID) join K on (K_ID = TTV_ID and K_ENABLED = 1)');
  aQuery.SQL.Add('join PLXTAILLESGF on (TGF_ID = TTV_TGFID) join K on (K_ID = TGF_ID and K_ENABLED = 1)');
  aQuery.SQL.Add('join PLXCOULEUR on (COU_ARTID = ART_ID) join K on (K_ID = COU_ID and K_ENABLED = 1)');
  aQuery.SQL.Add('where ART_ID = :ARTID');
  aQuery.SQL.Add('and TGF_ID = :TGFID');
  aQuery.SQL.Add('and COU_ID = :COUID');
  try
    aQuery.ParamByName('ARTID').AsInteger := FModele.Id;
    aQuery.ParamByName('TGFID').AsInteger := FTaille.Id;
    aQuery.ParamByName('COUID').AsInteger := FCouleur.Id;
    aQuery.Open;
  except
    on E: Exception do
    begin

      Exit;
    end;
  end;
  Result := (not aQuery.IsEmpty);
end;

destructor TArticle.Destroy;
begin
  if Assigned(FModele) then
    FModele.Free;
  if Assigned(FTaille) then
    FTaille.Free;
  if Assigned(FCouleur) then
    FCouleur.Free;

  inherited;
end;

end.

