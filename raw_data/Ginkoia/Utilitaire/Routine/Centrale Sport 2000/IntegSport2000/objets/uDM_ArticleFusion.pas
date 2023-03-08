unit uDM_ArticleFusion;

interface

uses SysUtils, uGestionBDD, uArticle, uCodeBarre;

type
  TDM_Article = class
  private
    FQuery: TMyQuery;

  public
    constructor Create(aQuery: TMyQuery);
    function GetArticleDestination(Article: TArticle): TArticle;
    function GetArticleDestinationFinale(Article: TArticle): TArticle;
    function IsArticleHasFusion(Article: TArticle): Boolean;
    function GetArticle(CB: TCodeBarre): TArticle;
  end;    

implementation

{ TDM_Article }

constructor TDM_Article.Create(aQuery: TMyQuery);
begin
  if not Assigned(aQuery) then
    raise Exception.Create('Erreur :  pas de query !');
  FQuery := aQuery;
end;

function TDM_Article.GetArticleDestination(Article: TArticle): TArticle;
begin
  Result := nil;

  // Recherche de l'article destination de la fusion.
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select AFL_NEWARTID, AFL_NEWTGFID, AFL_NEWCOUID');
  FQuery.SQL.Add('from ARTFUSIONLIGNE');
  FQuery.SQL.Add('join K on (K_ID = AFL_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('where AFL_OLDARTID = :ARTID');
  FQuery.SQL.Add('and AFL_OLDTGFID = :TGFID');
  FQuery.SQL.Add('and AFL_OLDCOUID = :COUID');
  try
    FQuery.ParamByName('ARTID').AsInteger := Article.Modele.Id;
    FQuery.ParamByName('TGFID').AsInteger := Article.Taille.Id;
    FQuery.ParamByName('COUID').AsInteger := Article.Couleur.Id;
    FQuery.Open;
  except
    on E: Exception do
    begin

      Exit;
    end;
  end;
  if not FQuery.IsEmpty then
    Result := TArticle.Create(FQuery.FieldByName('AFL_NEWARTID').AsInteger, FQuery.FieldByName('AFL_NEWTGFID').AsInteger, FQuery.FieldByName('AFL_NEWCOUID').AsInteger, FQuery);
end;

function TDM_Article.GetArticleDestinationFinale(Article: TArticle): TArticle;
var
  Tmp: TArticle;
begin
  Result := nil;
  Tmp := Article;
  while Assigned(Tmp) do
  begin
    if Assigned(Result) then
      Result.Free;

    Result := Tmp;
    Tmp := GetArticleDestination(Tmp);
  end;
end;

function TDM_Article.IsArticleHasFusion(Article: TArticle): Boolean;
begin
  Result := False;

  // Recherche si article source de fusion.
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select AFL_NEWARTID');
  FQuery.SQL.Add('from ARTFUSIONLIGNE');
  FQuery.SQL.Add('join K on (K_ID = AFL_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('where AFL_OLDARTID = :ARTID');
  FQuery.SQL.Add('and AFL_OLDTGFID = :TGFID');
  FQuery.SQL.Add('and AFL_OLDCOUID = :COUID');
  FQuery.SQL.Add('and AFL_OLDARTID <> 0');
  try
    FQuery.ParamByName('ARTID').AsInteger := Article.Modele.Id;
    FQuery.ParamByName('TGFID').AsInteger := Article.Taille.Id;
    FQuery.ParamByName('COUID').AsInteger := Article.Couleur.Id;
    FQuery.Open;
  except
    on E: Exception do
    begin

      Exit;
    end;
  end;
  Result := (not FQuery.IsEmpty);
end;

function TDM_Article.GetArticle(CB: TCodeBarre): TArticle;
begin
  Result := nil;

  // Recherche article du CB.
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select ARF_ARTID, CBI_TGFID, CBI_COUID,');
  FQuery.SQL.Add('case');
  FQuery.SQL.Add('   when ART_FUSARTID > 0 then 0');
  FQuery.SQL.Add('   else 1');
  FQuery.SQL.Add('end as FUSION');
  FQuery.SQL.Add('from ARTCODEBARRE join K on (K_ID = CBI_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('join ARTREFERENCE on (ARF_ID = CBI_ARFID) join K on (K_ID = ARF_ID and K_ENABLED = 1)');
  FQuery.SQL.Add('join ARTARTICLE on (ART_ID = ARF_ARTID)');
  FQuery.SQL.Add('where CBI_TYPE = 3');
  FQuery.SQL.Add('and CBI_CB = :CB');
  FQuery.SQL.Add('and ART_ID <> 0');
  FQuery.SQL.Add('order by ARF_ARCHIVER, FUSION, CBI_PRIN desc, ARF_CREE desc');
  FQuery.SQL.Add('rows 1');   
  try
    FQuery.ParamByName('CB').AsString := CB.CB;
    FQuery.Open;
  except
    on E: Exception do
    begin

      Exit;
    end;
  end;
  if not FQuery.IsEmpty then
    Result := GetArticleDestinationFinale(TArticle.Create(FQuery.FieldByName('ARF_ARTID').AsInteger, FQuery.FieldByName('CBI_TGFID').AsInteger, FQuery.FieldByName('CBI_COUID').AsInteger, FQuery));
end;

end.

