unit UBddMaitre;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.IBBase,
  FireDAC.Phys.IB, FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util, FireDAC.Comp.Script,
  vcl.forms, System.Classes, System.Generics.Collections,System.SysUtils,
  Datasnap.DBClient, System.StrUtils, System.IOUtils,
  UBdd;

type
  TBddMaitre = class(TBdd)
    private
    public
      constructor Create(pCheminBase: string); reintroduce;
      destructor Destroy; reintroduce;
      function FindARTIDbyEAN(pCodeEAN: string): integer;
      function FindARTIDbyMarque(pCodeMarque: string; pNomMarque: string): integer;
      function CreerModele(pNom, pRefMarque, pNomMarque, pDetail, pComposition, pTauxTVA, pRAY, pFAM, pSSF,
                      pPrevente, pPreventeQte, pDelai, pGenre, pNomGrille, pCodeGrille, pCollection,
                      pClassement1, pClassement2, pClassement3, pClassement4, pClassement5 : string; pACTID, pASSCODE: integer): integer;
      function CreerArticle(pCodeEAN, pTaille, pCodeTaille, pCouleur, pCouleurCode, pCouleurStat, pPrixVente, pPrixAchat: string; pModeleId: integer): integer;
      procedure UpdateArticle(pCodeEAN, pPrix, pPrixN, pPump, pCouleurStat: string);
      procedure GetListeDomaine(var Liste :TStringList);
      procedure GetListeSiteWeb(var Liste :TStringList);
      procedure MAJCodeBarre(pCodeBarre: string; pCodeEAN: string; pEtatData: string);
      procedure MAJTransporteur(pTransporteur: string; pCodeTransporteur: string; pEtatData: string);
      procedure MAJArtNkWeb(pCodeEAN, pSSFNOM, pFAMNOM, pRAYNOM, pEtatData: string; pACTID: integer);
      function FindOCTIDbyRef(pOCT_NOM, pOCTCOMM: string): integer;
      function CreerOC(pID: integer; pNom, pComment: string; pDebut, pFin: string; pType: integer; pCodeEan, pPrix: string; pEtatData: integer): integer;
  end;



implementation

{ TGestBddMaitre }


{ TBddMaitre }

constructor TBddMaitre.Create(pCheminBase: string);
begin
  inherited Create(pCheminBase);
end;

function TBddMaitre.CreerArticle(pCodeEAN, pTaille, pCodeTaille, pCouleur, pCouleurCode, pCouleurStat,
  pPrixVente, pPrixAchat : string; pModeleId: integer): integer;
var
  lQuery: TFDQuery;
begin
  (*CODEEAN varchar(64),
    TGFNOM varchar(64),
    TGFCODE varchar(64),
    COUNOM varchar(64),
    COUCODE varchar(64),
    COUSTATNOM varchar(64),
    PXVENTE float,
    PXACHAT float,
    ART_ID integer*)
  Result := 0;
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  try
    lQuery.SQL.Add('SELECT * FROM INTEGCHAM3S_CREERARTICLE('+QuotedStr(pCodeEAN)+','+QuotedStr(pTaille)+','+QuotedStr(pCodeTaille)
                +','+QuotedStr(pCouleur)+','+QuotedStr(pCouleurCode)+','+QuotedStr(pCouleurStat)+','+FormatData(pPrixVente,10)
                +','+FormatData(pPrixAchat,10)+','+IntToStr(pModeleID)+')');
    lQuery.Open;
  finally
    lQuery.Free;
  end;
end;

function TBddMaitre.CreerModele(pNom, pRefMarque, pNomMarque, pDetail, pComposition, pTauxTVA, pRAY, pFAM, pSSF,
   pPrevente, pPreventeQte, pDelai, pGenre, pNomGrille, pCodeGrille, pCollection,
   pClassement1, pClassement2, pClassement3, pClassement4, pClassement5 : string; pACTID, pASSCODE: integer): integer;
var
  lQuery: TFDQuery;
begin
 (* ARTNOM varchar(64),
    REFMRK varchar(64),
    MRKNOM varchar(64),
    ARWDETAIL varchar(512),
    ARWCOMPOSITION varchar(512),
    TAUXTVA float,
    RAY_NOM varchar(64),
    FAM_NOM varchar(64),
    SSF_NOM varchar(64),
    PREVENTE integer,
    PREVENTE_QTE integer,
    DLW_LIBELLE varchar(64),
    GRE_NOM varchar(64),
    TGF_NOMGRILLE varchar(64),
    TGF_CODEGRILLE varchar(64),
    COL_NOM varchar(32),
    ACT_ID integer *)
  Result := 0;
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  try
    lQuery.SQL.Add('SELECT ART_ID FROM INTEGCHAM3S_CREERMODELE('+QuotedStr(pNom)+','+QuotedStr(pRefMarque)
                +','+QuotedStr(pNomMarque)+','+QuotedStr(pDetail)+','+QuotedStr(pComposition)+','+FormatData(pTauxTVA,10)
                +','+QuotedStr(pRAY)+','+QuotedStr(pFAM)+','+QuotedStr(pSSF)+','+pPrevente+','+pPreventeQte
                +','+QuotedStr(pDelai)+','+QuotedStr(pGenre)+','+QuotedStr(pNomGrille)+','+QuotedStr(pCodeGrille)
                +','+QuotedStr(pCollection)+','+QuotedStr(pClassement1)+','+QuotedStr(pClassement2)+','+QuotedStr(pClassement3)
                +','+QuotedStr(pClassement4)+','+QuotedStr(pClassement5)
                +','+IntToStr(pACTID)+','+IntToStr(pASSCODE)+')');
    lQuery.Open;
    //FConnection.Commit;
    if lQuery.RecordCount > 0 then
      Result := lQuery.FieldByName('ART_ID').AsInteger;
  finally
    lQuery.Free;
  end;
end;

function TBddMaitre.CreerOC(pID: integer; pNom, pComment: string; pDebut, pFin: string; pType: integer; pCodeEan, pPrix: string; pEtatData: integer): integer;
var
  lQuery: TFDQuery;
begin
(*OCT_ID integer,
  OCT_NOM varchar(64),
  OCT_COMMENT varchar(255),
  OCT_DEBUT timestamp,
  OCT_FIN timestamp,
  OCT_TYPE integer,
  CODE_EAN varchar(64),
  PRIX float)
  returns (
  OCTID integer)*)

  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  try
    lQuery.SQL.Add('SELECT OCTID FROM INTEGCHAM3S_MAJOC('+IntToStr(pID)+','+QuotedStr(pNom)+','+QuotedStr(pComment)+',');
    lQuery.SQL.Add(FormatData(pDebut,35)+','+FormatData(pFin,35)+','+IntToStr(pType)+',');
    lQuery.SQL.Add(QuotedStr(pCodeEan)+','+FormatData(pPrix,10)+','+IntToStr(pEtatData)+')');
    lQuery.Open;
    Result := lQuery.FieldByName('OCTID').AsInteger;
  finally
    lQuery.Free;
  end;
end;

destructor TBddMaitre.Destroy;
begin
  inherited Destroy;
end;

function TBddMaitre.FindARTIDbyEAN(pCodeEAN: string): integer;
var
  lQuery: TFDQuery;
begin
  Result := 0;
  if pCodeEAN <> '' then
  begin
    lQuery := TFDQuery.Create(nil);
    lQuery.Connection := FConnection;
    try
      lQuery.SQL.Add('SELECT ARF_ARTID FROM ARTREFERENCE JOIN ARTCODEBARRE on CBI_ARFID = ARF_ID JOIN K on K_ID=CBI_ID AND K_ENABLED=1');
      lQuery.SQL.Add('WHERE CBI_CB='+FormatData(pCodeEAN,37)+' AND CBI_TYPE=3 AND CBI_PRIN=1');
      lQuery.Open;
      if lQuery.RecordCount > 0 then
        Result := lQuery.FieldByName('ARF_ARTID').AsInteger;
    finally
      lQuery.Free;
    end;
  end;
end;

function TBddMaitre.FindARTIDbyMarque(pCodeMarque: string; pNomMarque: string): integer;
var
  lQuery: TFDQuery;
begin
  Result := 0;
  if (Trim(pCodeMarque) <> '') and (pCodeMarque <> 'NON DEFINI') then
  begin
    lQuery := TFDQuery.Create(nil);
    lQuery.Connection := FConnection;
    try
      lQuery.SQL.Add('SELECT ART_ID FROM ARTARTICLE');
      lQuery.SQL.Add('JOIN ARTMARQUE ON ART_MRKID = MRK_ID');
      lQuery.SQL.Add('WHERE ART_REFMRK='+QuotedStr(pCodeMarque)+' AND MRK_NOM='+QuotedStr(pNomMarque));
      lQuery.Open;
      if lQuery.RecordCount > 0 then
        Result := lQuery.FieldByName('ART_ID').AsInteger;
    finally
      lQuery.Free;
    end;
  end;
end;

function TBddMaitre.FindOCTIDbyRef(pOCT_NOM, pOCTCOMM: string): integer;
var
  lQuery: TFDQuery;
begin
  Result := 0;
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  try
    lQuery.SQL.Add('SELECT OCT_ID FROM OCTETE');
    lQuery.SQL.Add('JOIN K ON OCT_ID = K_ID');          //SR - 15/11/2016 - Suppression du K_Enabled à 1 prise en compte réinitialisation des OC.
    lQuery.SQL.Add('WHERE OCT_NOM='+QuotedStr(pOCT_NOM)+' AND OCT_COMMENT LIKE ''%'+pOCTCOMM+'%''');
    lQuery.Open;
    if lQuery.RecordCount > 0 then
      Result := lQuery.FieldByName('OCT_ID').AsInteger;
  finally
    lQuery.Free;
  end;
end;

procedure TBddMaitre.GetListeDomaine(var Liste: TStringList);
var
  lQuery: TFDQuery;
  lBcl: integer;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  try
    lQuery.SQL.Add('SELECT * FROM NKLACTIVITE JOIN K on K_ID=ACT_ID WHERE ACT_ID<>0');
    lQuery.Open;
    Liste.Clear;
    for lBcl := 0 to lQuery.RecordCount -1 do
    begin
      Liste.Add(lQuery.FieldByName('ACT_NOM').AsString+'='+lQuery.FieldByName('ACT_ID').AsString);
    end;
  finally
    lQuery.Free;
  end;
end;

procedure TBddMaitre.GetListeSiteWeb(var Liste: TStringList);
var
  lQuery: TFDQuery;
  lBcl: integer;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  try
    lQuery.SQL.Add('SELECT * FROM ARTSITEWEB JOIN K on K_ID=ASS_ID WHERE ASS_ID<>0');
    lQuery.Open;
    Liste.Clear;
    for lBcl := 0 to lQuery.RecordCount -1 do
    begin
      Liste.Add(lQuery.FieldByName('ASS_NOM').AsString+'='+lQuery.FieldByName('ASS_CODE').AsString);
      lQuery.Next;
    end;
  finally
    lQuery.Free;
  end;
end;

procedure TBddMaitre.MAJArtNkWeb(pCodeEAN, pSSFNOM, pFAMNOM, pRAYNOM,
  pEtatData: string; pACTID: integer);
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  try
    lQuery.SQL.Add('execute procedure INTEGCHAM3S_MAJARTNKWEB('+QuotedStr(pCodeEAN)+','+QuotedStr(pSSFNOM)
                                +','+QuotedStr(pFAMNOM)+','+QuotedStr(pRAYNOM)+','+IntToStr(pACTID)+','+pEtatData+')');
    lQuery.ExecSQL;
  finally
    lQuery.Free;
  end;
end;

procedure TBddMaitre.MAJCodeBarre(pCodeBarre, pCodeEAN, pEtatData: string);
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  try
    lQuery.SQL.Add('execute procedure INTEGCHAM3S_MAJCB('+QuotedStr(pCodeBarre)+','+QuotedStr(pCodeEAN)+','+pEtatData+')');
    lQuery.ExecSQL;
  finally
    lQuery.Free;
  end;
end;

procedure TBddMaitre.MAJTransporteur(pTransporteur, pCodeTransporteur,
  pEtatData: string);
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  try
    lQuery.SQL.Add('execute procedure INTEGCHAM3S_MAJTRANSPORTEURS('+QuotedStr(pTransporteur)+','+pCodeTransporteur+','+pEtatData+')');
    lQuery.ExecSQL;
  finally
    lQuery.Free;
  end;
end;

procedure TBddMaitre.UpdateArticle(pCodeEAN, pPrix, pPrixN, pPump, pCouleurStat: string);
var
  lQuery: TFDQuery;
begin
  lQuery := TFDQuery.Create(nil);
  lQuery.Connection := FConnection;
  try
    lQuery.SQL.Add('execute procedure INTEGCHAM3S_MAJARTICLE('+QuotedStr(pCodeEAN)+','
                              +FormatData(pPrix,10)+','+FormatData(pPrixN,10)+','
                              +FormatData(pPump,10)+','+QuotedStr(pCouleurStat)+')');
    lQuery.ExecSQL;
  finally
    lQuery.Free;
  end;

end;

end.