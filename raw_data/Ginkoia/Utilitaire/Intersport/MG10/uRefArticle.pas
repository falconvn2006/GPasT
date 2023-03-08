unit uRefArticle;

interface

uses
  Windows, SysUtils, Classes, DB, DBClient, StrUtils, uCommon, Main_Dm, Dialogs,
  IBODataset, Load_Frm, GinkoiaStyle_Dm, IBSQL, IBStoredProc, DateUtils, uLog;

type
  TRefArticle = Class(TThread)
    private
      bEnabledProcessold : Boolean;

      bRetirePtVirg: boolean;

      sPathFourn              : string;
      sPathMarque             : string;
      sPathFoumarque          : string;
      sPathGrTaille           : string;
      sPathGrTailleLig        : string;
      sPathDomaine            : string;
      sPathAxe                : string;
      sPathAxeNiveau1         : string;
      sPathAxeNiveau2         : string;
      sPathAxeNiveau3         : string;
      sPathAxeNiveau4         : string;
      sPathCollection         : string;
      sPathGenre              : string;
      sPathArticle            : string;
      sPathArticleAxe         : string;
      sPathArticleCollection  : string;
      sPathCouleur            : string;
      sPathCodeBarre          : string;
      sPathAchatPrix          : string;
      sPathVentePrix          : string;
      sPathVenteIndicatifPrix : string;
      sPathModeleDeprecie     : string;
      sPathFouContact         : string;
      sPathFouCondition       : string;
      sPathArtIdeal           : string;
      sPathOcTete             : string;
      sPathOcMag              : string;
      sPathOcLignes           : string;
      sPathOcDetail           : string;

      sError: string;
      iMaxProgress: integer;
      iProgress: integer;
      iTraitement: integer;
      NbTraitement: integer;

      LigneLecture: string;

      cds_Magasin             : TClientDataSet;
      cds_TypeVen             : TClientDataSet;

      cds_Fourn               : TStringList;
      cds_Marque              : TStringList;
      cds_Foumarque           : TStringList;
      cds_GrTaille            : TStringList;
      cds_GrTailleLig         : TStringList;
      cds_Domaine             : TStringList;
      cds_Axe                 : TStringList;
      cds_AxeNiveau1          : TStringList;
      cds_AxeNiveau2          : TStringList;
      cds_AxeNiveau3          : TStringList;
      cds_AxeNiveau4          : TStringList;
      cds_Collection          : TStringList;
      cds_Genre               : TStringList;
      cds_Article             : TStringList;
      cds_ArticleAxe          : TStringList;
      cds_ArticleCollection   : TStringList;
      cds_Couleur             : TStringList;
      cds_CodeBarre           : TStringList;
      cds_PrixAchat           : TStringList;
      cds_PrixVente           : TStringList;
      cds_PrixVenteIndicatif  : TStringList;
      cds_ModeleDeprecie      : TStringList;
      cds_FouContact          : TStringList;
      cds_FouCondition        : TStringList;
      cds_ArtIdeal            : TStringList;
      cds_OcTete              : TStringList;
      cds_OcMag               : TStringList;
      cds_OcLignes            : TStringList;
      cds_OcDetail            : TStringList;
      cds_AllCB               : TStringList;

      StProc_Fourn              : TIBSQL;
      StProc_Marque             : TIBSQL;
      StProc_FouMarque          : TIBSQL;
      StProc_Gr_Taille          : TIBSQL;
      StProc_Gr_Taille_Lig      : TIBSQL;
      StProc_Domaine            : TIBSQL;
      StProc_Axe                : TIBSQL;
      StProc_AxeNiveau1         : TIBSQL;
      StProc_AxeNiveau2         : TIBSQL;
      StProc_AxeNiveau3         : TIBSQL;
      StProc_AxeNiveau4         : TIBSQL;
      StProc_Collection         : TIBSQL;
      StProc_Genre              : TIBSQL;
      StProc_Article            : TIBSQL;
      StProc_ArticleAxe         : TIBSQL;
      StProc_ArticleCollection  : TIBSQL;
      StProc_Couleur            : TIBSQL;
      StProc_CodeBarre          : TIBSQL;
      StProc_CodeBarre2         : TIBSQL;
      StProc_CorrigeCodeBarre   : TIBSQL;
      StProc_PrixAchat          : TIBSQL;
      StProc_PrixVente_Bascule  : TIBSQL;
      StProc_PrixVente          : TIBSQL;
      StProc_ModeleDeprecie     : TIBSQL;
      StProc_FouContact         : TIBSQL;
      StProc_FouCondition       : TIBSQL;
      StProc_VerruFouMarque     : TIBSQL;
      StProc_ArtIdeal           : TIBSQL;
      StProc_OcTete             : TIBSQL;
      StProc_OcMag              : TIBSQL;
      StProc_OcLignes           : TIBSQL;
      StProc_OcDetail           : TIBSQL;

      StProc_VenPrecoTarPreco  : TIBSQL;
      StProc_VenPrecoTarValid  : TIBSQL;
      StProc_VenPrecoMajEtat   : TIBSQL;

      procedure DoLog(const sVal: String; const aLvl: TLogLevel);
      function LoadFile:Boolean;

      function GetValueFournImp(AChamp: string): string;
      function GetValueMarqueImp(AChamp: string): string;
      function GetValueFouMarqueImp(AChamp: string): string;
      function GetValueGrTailleImp(AChamp: string): string;
      function GetValueGrTailleLigImp(AChamp: string): string;
      function GetValueDomaineImp(AChamp: string): string;
      function GetValueAxeImp(AChamp: string): string;
      function GetValueAxeNiv1Imp(AChamp: string): string;
      function GetValueAxeNiv2Imp(AChamp: string): string;
      function GetValueAxeNiv3Imp(AChamp: string): string;
      function GetValueAxeNiv4Imp(AChamp: string): string;
      function GetValueCollectionImp(AChamp: string): string;
      function GetValueGenreImp(AChamp: string): string;
      function GetValueArticleImp(AChamp: string): string;
      function GetValueArticleAxeImp(AChamp: string): string;
      function GetValueArticleCollectionImp(AChamp: string): string;
      function GetValueCouleurImp(AChamp: string): string;
      function GetValueCodeBarreImp(AChamp: string): string;
      function GetValuePrixAchatImp(AChamp: string): string;
      function GetValuePrixVenteImp(AChamp: string): string;
      function GetValuePrixVenteIndicatifImp(AChamp: string): string;
      function GetValueArticleDeprecieImp(AChamp: string): string;
      function GetValueFouContactImp(AChamp: string): string;
      function GetValueFouConditionImp(AChamp: string): string;
      function GetValueArtIdealImp(AChamp: string): string;
      function GetValueOcTeteImp(AChamp: string): string;
      function GetValueOcMagImp(AChamp: string): string;
      function GetValueOcLignesImp(AChamp: string): string;
      function GetValueOcDetailImp(AChamp: string): string;
      function GetValueAllCBImp(AChamp: string): string;

      procedure AjoutInfoLigne(ALigne: string; ADefColonne: array of string);

      function TraiterFourn               : Boolean;    // fournisseur
      function TraiterMarque              : Boolean;    // marque
      function TraiterFouMarque           : Boolean;    // relation fournisseur <--> marque
      function TraiterGr_Taille           : Boolean;    // grille de taille (+ categorie de taille)
      function TraiterGr_Taille_Lig       : Boolean;    // ligne de taille
      function TraiterDomaine             : boolean;    // domaine d'activite
      function TraiterAxe                 : boolean;    // Axe
      function TraiterAxeNiveau1          : boolean;    // Niveau 1 (secteur)
      function TraiterAxeNiveau2          : boolean;    // Niveau 2 (rayon)
      function TraiterAxeNiveau3          : boolean;    // Niveau 3 (famille)
      function TraiterAxeNiveau4          : boolean;    // Niveau 4 (S/famille)
      function TraiterCollection          : boolean;    // Collection
      function TraiterGenre               : boolean;    // Genre
      function TraiterArticle             : boolean;    // Article
      function TraiterArticleAxe          : boolean;    // Article Axe (SsfID)
      function TraiterArticleCollection   : boolean;    // Relation Article <--> Collection
      function TraiterCouleur             : boolean;    // Couleur
      function TraiterCodeBarre           : boolean;    // Code barre
      function TraiterPrixAchat           : boolean;    // Prix d'achat
      function TraiterPrixVente           : boolean;    // Prix de vente
      function TraiterPrixVenteIndicatif  : boolean;    // Prix de vente indicatif
      function TraiterModeleDeprecie      : boolean;    // Article déprecié
      function TraiterFouContact          : boolean;    // Contact Fournisseur
      function TraiterFouCondition        : boolean;    // Condition fournisseur
      function TraiterBackupRestore       : boolean;    // backup restore de la base
      function TraiterVerruFourMarque     : boolean;    // verru relation fournisseur<-->marque intersys
      function TraiterArtIdeal            : boolean;    // Article Idéal
      function TraiterTOC                 : boolean;    // Oppération Commercial

      //Mise à jour de la fenêtre d'attente
      procedure InitFrm;          // initilisation
      procedure InitExecute;      // début execution
      procedure UpdateFrm;        // Mise à jour
      procedure ErrorFrm;         // traitement des erreurs
      procedure EndFrm;           // fin du traitement
      procedure InitProgressFrm ; // initialisation progression
      procedure UpdProgressFrm ;  // maj progression

      //*********************************//
    public
      bError: boolean;
      sEtat1: string;
      sEtat2: string;
      procedure UpdateEtat2;        // Mise à jour
      constructor Create(aCreateSuspended, aEnabledProcess:boolean);
      destructor Destroy; override;
      procedure InitThread(ARetirePtVirg: boolean; aPathFourn, aPathMarque,
        aPathFoumarque, aPathGrTaille, aPathGrTailleLig, aPathDomaine, aPathAxe,
        aPathAxeNiveau1, aPathAxeNiveau2, aPathAxeNiveau3, aPathAxeNiveau4,
        aPathCollection, aPathGenre, aPathArticle, aPathArticleAxe,
        aPathArticleCollection, aPathCouleur, aPathCodeBarre, aPathAchatPrix,
        aPathVentePrix, aPathVenteIndicatifPrix, aPathModeleDeprecie,
        aPathFouContact, aPathFouCondition, aPathArtIdeal, aPathOcTete,
        aPathOcMag, aPathOcLignes, aPathOcDetail : string);

    protected
      procedure Execute; override;

  End;

implementation

uses
  Graphics, uDefs, IBQuery, Variants, Main_Frm;

var
  ArtSoiMeme: TRefArticle;

{ TRefArticle }

procedure TRefArticle.AjoutInfoLigne(ALigne: string; ADefColonne: array of string);
var
  sLigne: string;
  NBre: integer;
begin
  LigneLecture := ALigne;
  sLigne := ALigne;
  if (bRetirePtVirg) and (sLigne<>'') and (sLigne[Length(sLigne)]=';') then
    sLigne := Copy(sLigne, 1, Length(sLigne)-1);

  if (sLigne<>'') and (sLigne[1]='"') then
  begin
    Nbre := 1;
    while Pos('";"', sLigne)>0 do
    begin
      sLigne := Copy(sLigne, Pos('";"', sLigne)+2, Length(sLigne));
      Inc(Nbre);
    end;
  end
  else
  begin
    Nbre := 1;
    while Pos(';', sLigne)>0 do
    begin
      sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
      Inc(Nbre);
    end;
  end;

  if High(ADefColonne)<>(Nbre-1) then
    Raise Exception.Create('Nombre de champs invalide par rapport à l''entête:'+#13#10+
                           '  - Moins de champ: surement un retour chariot dans la ligne'+#13#10+
                           '  - Plus de champ: surement un ; ou un " de trop dans la ligne');
end;

constructor TRefArticle.Create(aCreateSuspended, aEnabledProcess:boolean);
var
  InfoErreur: string;
begin
  inherited Create(aCreateSuspended);
  bError := false;

  FreeOnTerminate := true;
  Priority := tpHigher;
  bEnabledProcessold := aEnabledProcess;

  sEtat1 := '';
  sEtat2 := '';
  sError := '';
  if (Dm_Main.Provenance in [ipGinkoia, ipNosymag, ipGoSport]) then
    NbTraitement := 26
  else
    NbTraitement := 28;

  InfoErreur := 'cds_Magasin';
  // magasin en mémoire
  InfoErreur := 'cds_Magasin ';
  cds_Magasin := TClientDataSet.Create(nil);
  cds_Magasin.FieldDefs.Add('MAG_ID',ftInteger,0);
  cds_Magasin.FieldDefs.Add('MAG_CODEADH',ftString,32);
  cds_Magasin.CreateDataSet;
  cds_Magasin.LogChanges := False;
  cds_Magasin.Open;

  InfoErreur := 'cds_TypeVen';
  // type de vente en mémoire
  InfoErreur := 'cds_TypeVen ';
  cds_TypeVen := TClientDataSet.Create(nil);
  cds_TypeVen.FieldDefs.Add('TYP_COD',ftInteger,0);
  cds_TypeVen.FieldDefs.Add('TYP_ID',ftInteger,0);
  cds_TypeVen.CreateDataSet;
  cds_TypeVen.LogChanges := False;
  cds_TypeVen.Open;

  InfoErreur := 'Début article';
  try
    cds_Fourn               := TStringList.Create;
    cds_Marque              := TStringList.Create;
    cds_Foumarque           := TStringList.Create;
    cds_GrTaille            := TStringList.Create;
    cds_GrTailleLig         := TStringList.Create;
    cds_Domaine             := TStringList.Create;
    cds_Axe                 := TStringList.Create;
    cds_AxeNiveau1          := TStringList.Create;
    cds_AxeNiveau2          := TStringList.Create;
    cds_AxeNiveau3          := TStringList.Create;
    cds_AxeNiveau4          := TStringList.Create;
    cds_Collection          := TStringList.Create;
    cds_Genre               := TStringList.Create;
    cds_Article             := TStringList.Create;
    cds_ArticleAxe          := TStringList.Create;
    cds_ArticleCollection   := TStringList.Create;
    cds_Couleur             := TStringList.Create;
    cds_CodeBarre           := TStringList.Create;
    cds_PrixAchat           := TStringList.Create;
    cds_PrixVente           := TStringList.Create;
    cds_PrixVenteIndicatif  := TStringList.Create;
    cds_ModeleDeprecie      := TStringList.Create;
    cds_FouContact          := TStringList.Create;
    cds_FouCondition        := TStringList.Create;
    cds_ArtIdeal            := TStringList.Create;
    cds_OcTete              := TStringList.Create;
    cds_OcMag               := TStringList.Create;
    cds_OcLignes            := TStringList.Create;
    cds_OcDetail            := TStringList.Create;
    cds_AllCB               := TStringList.Create;

    Dm_Main.TransacArt.Active := true;

    // fournisseur
    InfoErreur := 'MG10_FOURN';
    StProc_Fourn := TIBSQL.Create(nil);
    with StProc_Fourn do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      if (Dm_Main.Provenance in [ipNosymag]) then
        SQL.Add(cSql_MG10_FOURN_2)
      else
        SQL.Add(cSql_MG10_FOURN);
      Prepare;
    end;

    // Marque
    InfoErreur := 'MG10_MARQUE';
    StProc_Marque := TIBSQL.Create(nil);
    with StProc_Marque do
    begin
      Database := Dm_Main.Database;
      ParamCheck := True;
      SQL.Add(cSql_MG10_MARQUE);
      Prepare;
    end;

    // relation fournisseur <--> marque
    InfoErreur := 'MG10_FOUMARQUE';
    StProc_FouMarque := TIBSQL.Create(nil);
    with StProc_FouMarque do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      SQL.Add(cSql_MG10_FOUMARQUE);
      Prepare;
    end;

    // grille de taille (+ categorie de taille)
    InfoErreur := 'MG10_GR_TAILLE';
    StProc_Gr_Taille := TIBSQL.Create(Nil);
    with StProc_Gr_Taille do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      SQL.Add(cSql_MG10_GR_TAILLE);
      Prepare;
    end;

    // Ligne de grille de taille
    InfoErreur := 'MG10_GR_TAILLE_LIG';
    StProc_Gr_Taille_Lig := TIBSQL.Create(Nil);
    with StProc_Gr_Taille_Lig do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      SQL.Add(cSql_MG10_GR_TAILLE_LIG);
      Prepare;
    end;

    // domaine commercial
    StProc_Domaine := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_DOMAINE';
    with StProc_Domaine do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      SQL.Add('select ACTID from MG10_DOMAINE(:ACTNOM)');
      Prepare;
    end;

    // axe
    StProc_Axe := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_AXE';
    with StProc_Axe do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      SQL.Add('SELECT UNIID FROM MG10_AXE(:AXECODEIS,');
      SQL.Add('                           :AXENIVEAU,');
      SQL.Add('                           :AXENOM,');
      SQL.Add('                           :CENTRALE,');
      SQL.Add('                           :LIBN1,');
      SQL.Add('                           :LIBN2,');
      SQL.Add('                           :LIBN3,');
      SQL.Add('                           :LIBN4,');
      SQL.Add('                           :ACTID)');
      Prepare;
    end;

    // niveau 1 (secteur)
    StProc_AxeNiveau1 := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_AXE_NIVEAU1';
    with StProc_AxeNiveau1 do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      SQL.Add('SELECT SECID FROM MG10_AXE_NIVEAU1(:UNIID,');
      SQL.Add('                                   :CODEIS,');
      SQL.Add('                                   :NOM,');
      SQL.Add('                                   :VISIBLE,');
      SQL.Add('                                   :CENTRALE,');
      SQL.Add('                                   :ORDREAFF,');
      SQL.Add('                                   :CODENIV)');
      Prepare;
    end;

    // niveau 2 (rayon)
    StProc_AxeNiveau2 := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_AXE_NIVEAU2';
    with StProc_AxeNiveau2 do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      SQL.Add('SELECT RAYID FROM MG10_AXE_NIVEAU2(:SECID,');
      SQL.Add('                                   :UNIID,');
      SQL.Add('                                   :CODEIS,');
      SQL.Add('                                   :NOM,');
      SQL.Add('                                   :VISIBLE,');
      SQL.Add('                                   :CENTRALE,');
      SQL.Add('                                   :ORDREAFF,');
      SQL.Add('                                   :CODENIV)');
      Prepare;
    end;

    // niveau 3 (famille)
    StProc_AxeNiveau3 := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_AXE_NIVEAU3';
    with StProc_AxeNiveau3 do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      SQL.Add('SELECT FAMID FROM MG10_AXE_NIVEAU3(:RAYID,');
      SQL.Add('                                   :NOM,');
      SQL.Add('                                   :CODEIS,');
      SQL.Add('                                   :VISIBLE,');
      SQL.Add('                                   :CENTRALE,');
      SQL.Add('                                   :ORDREAFF,');
      SQL.Add('                                   :CODENIV)');
      Prepare;
    end;

    // niveau 4 (s/famille)
    StProc_AxeNiveau4 := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_AXE_NIVEAU4';
    with StProc_AxeNiveau4 do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      SQL.Add('SELECT SSFID FROM MG10_AXE_NIVEAU4(:FAMID,');
      SQL.Add('                                   :NOM,');
      SQL.Add('                                   :CODEIS,');
      SQL.Add('                                   :VISIBLE,');
      SQL.Add('                                   :CENTRALE,');
      SQL.Add('                                   :ORDREAFF,');
      SQL.Add('                                   :CODENIV,');
      SQL.Add('                                   :CODEFINAL,');
      SQL.Add('                                   :TVAID,');
      SQL.Add('                                   :TCTID)');
      Prepare;
    end;
  
    // Collection
    StProc_Collection := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_COLLECTION';
    with StProc_Collection do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      SQL.Add('SELECT COLID FROM MG10_COLLECTION(:COLCODEIS,');
      SQL.Add('                                  :COLNOM,');
      SQL.Add('                                  :COLACTIVE,');
      SQL.Add('                                  :COLCENTRALE,');
      SQL.Add('                                  :COLDTDEB,');
      SQL.Add('                                  :COLDTFIN)');
      Prepare;
    end;

    // Genre
    StProc_Genre := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_GENRE';
    with StProc_Genre do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      SQL.Add('SELECT GREID FROM MG10_GENRE(:GRENOM,');
      SQL.Add('                             :GRESEXE)');
      Prepare;
    end;

    // Article
    StProc_Article := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_ARTICLE';
    with StProc_Article do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      SQL.Add('SELECT ARTID, ARFID FROM MG10_ARTICLE(:ARTMRKID,');
      SQL.Add('                                      :ARTGTFID,');
      SQL.Add('                                      :ARTNOM,');
      SQL.Add('                                      :ARTREFMRK,');
      SQL.Add('                                      :CODEIS,');
      SQL.Add('                                      :ARTFEDAS,');
      if (Dm_Main.Provenance in [ipNosymag]) then
      begin
        SQL.Add('                                    :ARTEXFEDAS,');
        SQL.Add('                                    :ARTUNI,');
        SQL.Add('                                    :ARTEXUNI,');
      end;
      SQL.Add('                                      :ARTDESCRIPTION,');
      SQL.Add('                                      :ICLCLASS1,');
      SQL.Add('                                      :ICLCLASS2,');
      SQL.Add('                                      :ICLCLASS3,');
      SQL.Add('                                      :ICLCLASS4,');
      SQL.Add('                                      :ICLCLASS5,');
      SQL.Add('                                      :ICLCLASS6,');
      SQL.Add('                                      :ARFFIDELITE,');
      SQL.Add('                                      :ARFCREE,');
      SQL.Add('                                      :ARTCOMENT1,');
      SQL.Add('                                      :ARTCOMENT2,');
      SQL.Add('                                      :ARFCHRONO,');
      SQL.Add('                                      :ARFTVAID,');
      SQL.Add('                                      :ARFVIRTUEL,');
      SQL.Add('                                      :ARFARCHIVER,');
      SQL.Add('                                      :ARTACTID,');
      SQL.Add('                                      :ARTCENTRALE,');
      SQL.Add('                                      :ARTGREID,');
      SQL.Add('                                      :ARFTCTID,');
      SQL.Add('                                      :STKIDEAL,');
      SQL.Add('                                      :ARTECOPART,');
      SQL.Add('                                      :ARTECOMOB)');
      Prepare;
    end;

    // Article Axe
    StProc_ArticleAxe := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_ARTICLE_AXE';
    with StProc_ArticleAxe do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      ParamCheck := True;
      SQL.Add('SELECT ARXID FROM MG10_ARTICLE_AXE(:ARTID,');
      SQL.Add('                                   :SSFID)');
      Prepare;
    end;

    // relation article <--> Collection
    StProc_ArticleCollection := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_ARTICLE_COLLECTION';
    with StProc_ArticleCollection do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT CARID FROM MG10_ARTICLE_COLLECTION(:ARTID,');
      SQL.Add('                                          :COLID)');
      ParamCheck := True;
      Prepare;
    end;

    // couleur
    StProc_Couleur := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_COULEUR';
    with StProc_Couleur do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT COUID, COUCODE FROM MG10_COULEUR(:ARTID,');
      SQL.Add('                                        :COUNOM,');
      SQL.Add('                                        :CODEIS,');
      SQL.Add('                                        :COUCENT,');
      SQL.Add('                                        :COUSMU,');
      SQL.Add('                                        :COUTDSC,');
      SQL.Add('                                        :OKDEGINKOIA,');
      SQL.Add('                                        :SECONDIMPORT)');
      ParamCheck := True;
      Prepare;
    end;

    // Code Barre
    StProc_CodeBarre := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_CODE_BARRE';
    with StProc_CodeBarre do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT CBIID FROM MG10_CODE_BARRE(:ARTID,');
      SQL.Add('                                  :ARFID,');
      SQL.Add('                                  :TGFID,');
      SQL.Add('                                  :COUID,');
      SQL.Add('                                  :EAN,');
      SQL.Add('                                  :TIPE,');
      SQL.Add('                                  :PRIN)');
      ParamCheck := True;
      Prepare;
    end;

    // code barre article de type 1 (pour l'import Intersys)
    StProc_CodeBarre2 := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_CODE_BARRE2';
    with StProc_CodeBarre2 do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT CBIID, EAN FROM MG10_CODE_BARRE2(:ARFID,');
      SQL.Add('                                        :TGFID,');
      SQL.Add('                                        :COUID)');
      ParamCheck := True;
      Prepare;
    end;

    //  Corrige les codes-barres manquants
    StProc_CorrigeCodeBarre := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_REPARECODBAR';
    with StProc_CorrigeCodeBarre do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('execute procedure MG10_REPARECODBAR');
      ParamCheck := True;
      Prepare;
    end;

    // Prix d'achat
    StProc_PrixAchat := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_PRIX_ACHAT';
    with StProc_PrixAchat do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT CLGID FROM MG10_PRIX_ACHAT(:ARTID,');
      SQL.Add('                                  :TGFID,');
      SQL.Add('                                  :COUID,');
      SQL.Add('                                  :FOUID,');
      SQL.Add('                                  :PXCATAL,');
      SQL.Add('                                  :PXACHAT,');
      SQL.Add('                                  :FOUPRINCIPAL,');
      SQL.Add('                                  :PXDEBASE)');
      ParamCheck := True;
      Prepare;
    end;

    // Bascule Prix de vente
    StProc_PrixVente_Bascule := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_PRIX_VENTE_BASCULE';
    with StProc_PrixVente_Bascule do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('EXECUTE PROCEDURE MG10_PRIX_VENTE_BASCULE(:BASCULETVTID,');
      SQL.Add('                                          :ARTID)');
      ParamCheck := True;
      Prepare;
    end;

    // Prix de vente
    StProc_PrixVente := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_PRIX_VENTE';
    with StProc_PrixVente do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT PVTID FROM MG10_PRIX_VENTE(:ARTID,');
      SQL.Add('                                  :TGFID,');
      SQL.Add('                                  :COUID,');
      SQL.Add('                                  :NOMTAR,');
      SQL.Add('                                  :PRIXVENTE,');
      SQL.Add('                                  :PXDEBASE)');
      ParamCheck := True;
      Prepare;
    end;

    // Prix de vente indicatif - Table TarPreco
    StProc_VenPrecoTarPreco := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_VENPRECO_TARPRECO';
    with StProc_VenPrecoTarPreco do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT TPOID FROM MG10_VENPRECO_TARPRECO(:ARTID,');
      SQL.Add('                                         :PXPRECO,');
      SQL.Add('                                         :DTPRECO)');
      ParamCheck := True;
      Prepare;
    end;
    // Prix de vente indicatif - Table TarValid
    StProc_VenPrecoTarValid := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_VENPRECO_TARVALID';
    with StProc_VenPrecoTarValid do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT TVDID FROM MG10_VENPRECO_TARVALID(:TPOID,');
      SQL.Add('                                         :ARTID,');
      SQL.Add('                                         :TGFID,');
      SQL.Add('                                         :COUID,');
      SQL.Add('                                         :NOMTAR,');
      SQL.Add('                                         :DT,');
      SQL.Add('                                         :PX)');
      ParamCheck := True;
      Prepare;
    end;
    // Prix de vente indicatif - Mise à jour Etat dans TarPreco
    StProc_VenPrecoMajEtat := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_VENPRECO_MAJETAT';
    with StProc_VenPrecoMajEtat do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT ETAT FROM MG10_VENPRECO_MAJETAT(:TPOID)');
      ParamCheck := True;
      Prepare;
    end;

    // Modèle deprecié
    StProc_ModeleDeprecie := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_ARTICLE_DEPRECIE';
    with StProc_ModeleDeprecie do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT DEPID FROM MG10_ARTICLE_DEPRECIE(:ARTID,');
      SQL.Add('                                        :DEP_DATE,');
      SQL.Add('                                        :TAUX,');
      SQL.Add('                                        :MOTIF,');
      SQL.Add('                                        :DIVERS)');
      ParamCheck := True;
      Prepare;
    end;

    // Contact Fournisseur
    StProc_FouContact := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_FOUCONTACT';
    with StProc_FouContact do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT CONID FROM MG10_FOUCONTACT(:FOUID,');
      SQL.Add('                                  :NOM,');
      SQL.Add('                                  :PRENOM,');
      SQL.Add('                                  :FONCTION,');
      SQL.Add('                                  :TELEPHONE,');
      SQL.Add('                                  :TELPORTABLE,');
      SQL.Add('                                  :EMAIL,');
      SQL.Add('                                  :COMMENT)');
      ParamCheck := True;
      Prepare;
    end;

    // Condition Fournisseur
    StProc_FouCondition := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_FOUCONDITION';
    with StProc_FouCondition do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT FODID, EXISTE FROM MG10_FOUCONDITION(:FOUID,');
      SQL.Add('                                            :CODE_MAG,');
      SQL.Add('                                            :NUMCLIENT,');
      SQL.Add('                                            :COMMENT,');
      SQL.Add('                                            :ENCOURS,');
      SQL.Add('                                            :NUMCOMPTA,');
      SQL.Add('                                            :FRANCOPORT,');
      SQL.Add('                                            :MODEREG,');
      SQL.Add('                                            :CONDREG)');
      ParamCheck := True;
      Prepare;
    end;

    // Verru relation fournisseur<-->marque InterSys
    StProc_VerruFouMarque := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_FOUMARQUE_VERRU';
    with StProc_VerruFouMarque do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('execute procedure MG10_FOUMARQUE_VERRU');
      ParamCheck := True;
      Prepare;
    end;

    //Article Idéal
    StProc_ArtIdeal := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_ARTIDEAL';
    with StProc_ArtIdeal do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT STIID FROM MG10_ARTIDEAL(:MAGID,');
      SQL.Add('                                :ARTID,');
      SQL.Add('                                :TGFID,');
      SQL.Add('                                :COUID,');
      SQL.Add('                                :QTE)');
      ParamCheck := True;
      Prepare;
    end;

    //OcTete
    StProc_OcTete := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_OCTETE';
    with StProc_OcTete do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT OCTID FROM MG10_OCTETE(:NOM,');
      SQL.Add('                              :COMMENT,');
      SQL.Add('                              :DEBUT,');
      SQL.Add('                              :FIN,');
      SQL.Add('                              :TYPID,');
      SQL.Add('                              :WEB,');
      SQL.Add('                              :CENTRALE,');
      SQL.Add('                              :CODE)');
      ParamCheck := True;
      Prepare;
    end;

    //OcMag
    StProc_OcMag := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_OCMAG';
    with StProc_OcMag do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT OCMID FROM MG10_OCMAG(:OCTID,');
      SQL.Add('                             :MAGID,');
      SQL.Add('                             :CLTID,');
      SQL.Add('                             :CLTIDPRO)');
      ParamCheck := True;
      Prepare;
    end;

    //OcLignes
    StProc_OcLignes := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_OCLIGNES';
    with StProc_OcLignes do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT OCLID FROM MG10_OCLIGNES(:OCTID,');
      SQL.Add('                                :ARTID,');
      SQL.Add('                                :PXVTE)');
      ParamCheck := True;
      Prepare;
    end;

    //OcDetail
    StProc_OcDetail := TIBSQL.Create(Nil);
    InfoErreur := 'MG10_OCDETAIL';
    with StProc_OcDetail do
    begin
      Database := Dm_Main.Database;
      Transaction := Dm_Main.TransacArt;
      SQL.Add('SELECT OCDID FROM MG10_OCDETAIL(:OCLID,');
      SQL.Add('                                :ARTID,');
      SQL.Add('                                :TGFID,');
      SQL.Add('                                :COUID,');
      SQL.Add('                                :PRIX,');
      SQL.Add('                                :ACTIVE,');
      SQL.Add('                                :CENTRALE)');
      ParamCheck := True;
      Prepare;
    end;
  except
    on E: Exception do
    begin
      MessageDlg('Erreur: '+ InfoErreur + #13#10 + E.Message, mterror, [mbok],0);
      Raise;
    end;
  end;
end;

procedure TRefArticle.DoLog(const sVal: String; const aLvl: TLogLevel);
begin
  uLog.Log.Log('uRefArticle', 'log', sVal, aLvl, False, -1, ltLocal);
end;

destructor TRefArticle.Destroy;
begin
  inherited;

  Dm_Main.TransacArt.Active := false;

  if assigned(cds_Fourn) then
    FreeAndNil(cds_Fourn);
  if assigned(cds_Marque) then
    FreeAndNil(cds_Marque);
  if assigned(cds_Foumarque) then
    FreeAndNil(cds_Foumarque);
  if assigned(cds_GrTaille) then
    FreeAndNil(cds_GrTaille);
  if assigned(cds_GrTailleLig) then
    FreeAndNil(cds_GrTailleLig);
  if assigned(cds_Domaine) then
    FreeAndNil(cds_Domaine);
  if assigned(cds_Axe) then
    FreeAndNil(cds_Axe);
  if assigned(cds_AxeNiveau1) then
    FreeAndNil(cds_AxeNiveau1);
  if assigned(cds_AxeNiveau2) then
    FreeAndNil(cds_AxeNiveau2);
  if assigned(cds_AxeNiveau3) then
    FreeAndNil(cds_AxeNiveau3);
  if assigned(cds_AxeNiveau4) then
    FreeAndNil(cds_AxeNiveau4);
  if assigned(cds_Collection) then
    FreeAndNil(cds_Collection);
  if assigned(cds_Genre) then
    FreeAndNil(cds_Genre);
  if assigned(cds_Article) then
    FreeAndNil(cds_Article);
  if assigned(cds_ArticleAxe) then
    FreeAndNil(cds_ArticleAxe);
  if assigned(cds_ArticleCollection) then
    FreeAndNil(cds_ArticleCollection);
  if assigned(cds_Couleur) then
    FreeAndNil(cds_Couleur);
  if assigned(cds_CodeBarre) then
    FreeAndNil(cds_CodeBarre);
  if assigned(cds_PrixAchat) then
    FreeAndNil(cds_PrixAchat);
  if assigned(cds_PrixVente) then
    FreeAndNil(cds_PrixVente);
  if assigned(cds_ArtIdeal) then
    FreeAndNil(cds_ArtIdeal);
  if assigned(cds_OcTete) then
    FreeAndNil(cds_OcTete);
  if assigned(cds_OcMag) then
    FreeAndNil(cds_OcMag);
  if assigned(cds_OcLignes) then
    FreeAndNil(cds_OcLignes);
  if assigned(cds_OcDetail) then
    FreeAndNil(cds_OcDetail);
  if assigned(cds_AllCB) then
    FreeAndNil(cds_AllCB);

  if assigned(StProc_VenPrecoTarPreco) then
    FreeAndNil(StProc_VenPrecoTarPreco);
  if assigned(StProc_VenPrecoTarValid) then
    FreeAndNil(StProc_VenPrecoTarValid);
  if assigned(StProc_VenPrecoMajEtat) then
    FreeAndNil(StProc_VenPrecoMajEtat);

  if assigned(cds_PrixVenteIndicatif) then
    FreeAndNil(cds_PrixVenteIndicatif);
  if assigned(cds_ModeleDeprecie) then
    FreeAndNil(cds_ModeleDeprecie);
  if assigned(cds_FouContact) then
    FreeAndNil(cds_FouContact);
  if assigned(cds_FouCondition) then
    FreeAndNil(cds_FouCondition);

  FreeAndNil(StProc_Fourn);
  FreeAndNil(StProc_Marque);
  FreeAndNil(StProc_FouMarque);
  FreeAndNil(StProc_Gr_Taille);
  FreeAndNil(StProc_Gr_Taille_Lig);
  FreeAndNil(StProc_Axe);
  FreeAndNil(StProc_AxeNiveau1);
  FreeAndNil(StProc_AxeNiveau2);
  FreeAndNil(StProc_AxeNiveau3);
  FreeAndNil(StProc_AxeNiveau4);
  FreeAndNil(StProc_Collection);
  FreeAndNil(StProc_Genre);
  FreeAndNil(StProc_Article);
  FreeAndNil(StProc_ArticleAxe);
  FreeAndNil(StProc_ArticleCollection);
  FreeAndNil(StProc_Couleur);
  FreeAndNil(StProc_CodeBarre);
  FreeAndNil(StProc_CodeBarre2);
  FreeAndNil(StProc_CorrigeCodeBarre);
  FreeAndNil(StProc_PrixAchat);
  FreeAndNil(StProc_PrixVente_Bascule);
  FreeAndNil(StProc_PrixVente);
  FreeAndNil(StProc_ModeleDeprecie);
  FreeAndNil(StProc_FouContact);
  FreeAndNil(StProc_FouCondition);
  FreeAndNil(StProc_VerruFouMarque);
  FreeAndNil(StProc_ArtIdeal);
  FreeAndNil(StProc_OcTete);
  FreeAndNil(StProc_OcMag);
  FreeAndNil(StProc_OcLignes);
  FreeAndNil(StProc_OcDetail);

  FreeAndNil(cds_Magasin);
  FreeAndNil(cds_TypeVen);
end;

procedure TRefArticle.UpdateEtat2;
begin
  Synchronize(UpdateFrm);
end;

procedure TRefArticle.UpdateFrm;
begin
  Frm_Load.Lab_EtatArt1.Caption := sEtat1;
  Frm_Load.Lab_EtatArt2.Caption := sEtat2;
  Frm_Load.Lab_EtatArt2.Hint := sEtat2;
end;

procedure TRefArticle.UpdProgressFrm;
begin
  Frm_Load.Lab_EtatArt2.Caption := sEtat2;
  Frm_Load.Lab_EtatArt2.Hint := sEtat2;
  Frm_Load.pb_EtatArt.Position := iProgress;
end;

procedure TRefArticle.EndFrm;
var
  bm: tbitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(0, bm);
    Frm_Load.img_RefArticle.Picture := nil;
    Frm_Load.img_RefArticle.Picture.Assign(bm);
    Frm_Load.img_RefArticle.Transparent := false;
    Frm_Load.img_RefArticle.Transparent := true;
  finally
    FreeAndNil(bm);
  end;
  Frm_Load.Lab_EtatArt1.Caption := 'Importation';
  Frm_Load.Lab_EtatArt2.Caption := 'Terminé';
  Frm_Load.Lab_EtatArt2.Hint := '';
end;

procedure TRefArticle.ErrorFrm;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(10, bm);
    Frm_Load.img_RefArticle.Picture := nil;
    Frm_Load.img_RefArticle.Picture.Assign(bm);
    Frm_Load.img_RefArticle.Transparent := false;
    Frm_Load.img_RefArticle.Transparent := true;
  finally
    FreeAndNil(bm);
  end;
  Frm_Load.DoErreurArt(sError);
end;

procedure TRefArticle.Execute;
var
  bContinue: boolean;
  tTot: TDateTime;
  tProc: TDateTime;
  tpListeDelai: TStringList;
begin
  inherited;

  bError := false;
  bContinue := true;
  tpListeDelai:= TStringList.Create;
  tTot := Now;
  try
    iTraitement := 0;
    Synchronize(InitExecute);


    // Chargement des fichiers;
    if bContinue then
    begin
      tProc := Now;
      bContinue := LoadFile;
      tpListeDelai.Add('  Chargement des fichiers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Chargement des fichiers: '+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // fournisseur
    if bContinue then
    begin
      tProc := Now;
      bContinue := TraiterFourn;
      tpListeDelai.Add('  Fournisseur: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Fournisseur: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Marque
    if bContinue then
    begin
      tProc := Now;
      bContinue := TraiterMarque;
      tpListeDelai.Add('  Marque: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Marque: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // relation fournisseur <--> marque
    if bContinue then
    begin
      tProc := Now;
      bContinue := TraiterFouMarque;
      tpListeDelai.Add('  relation fournisseur <-> marque: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - relation fournisseur <-> marque: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // grille de taille (+ categorie de taille)
    if bContinue then
    begin
      tProc := Now;
      bContinue := TraiterGr_Taille;
      tpListeDelai.Add('  grille de taille: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - grille de taille: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // ligne de taille
    if bContinue then
    begin
      tProc := Now;
      bContinue := TraiterGr_Taille_Lig;
      tpListeDelai.Add('  ligne grille de taille: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - ligne grille de taille: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Domaine commercial
    if bContinue then
    begin
      tProc := Now;
      bContinue := TraiterDomaine;
      tpListeDelai.Add('  Domaine commercial: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Domaine commercial: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Axe
    if bContinue then
    begin
      tProc := Now;
      bContinue := TraiterAxe;
      tpListeDelai.Add('  Axe: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Axe: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Niveau 1 (secteur)
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterAxeNiveau1;
      tpListeDelai.Add('  Niveau 1 (secteur): '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Niveau 1 (secteur): '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Niveau 2 (rayon)
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterAxeNiveau2;
      tpListeDelai.Add('  Niveau 2 (rayon): '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Niveau 2 (rayon): '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Niveau 3 (famille)
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterAxeNiveau3;
      tpListeDelai.Add('  Niveau 3 (famille): '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Niveau 3 (famille): '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Niveau 4 (s/famille)
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterAxeNiveau4;
      tpListeDelai.Add('  Niveau 4 (s/famille): '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Niveau 4 (s/famille): '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Collection
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterCollection;
      tpListeDelai.Add('  Collection: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Collection: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Genre
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterGenre;
      tpListeDelai.Add('  Genre: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Genre: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // article
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterArticle;
      tpListeDelai.Add('  Article: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Article: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // article axe
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterArticleAxe;
      tpListeDelai.Add('  Article axe: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Article axe: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Relation Article <--> Collection
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterArticleCollection;
      tpListeDelai.Add('  Relation Article <-> Collection: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Relation Article <-> Collection: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Couleur
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterCouleur;
      tpListeDelai.Add('  Couleur: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Couleur: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Code barre
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterCodeBarre;
      tpListeDelai.Add('  Code barre: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Code barre: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Prix d'achat
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterPrixAchat;
      tpListeDelai.Add('  Prix d''achat: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Prix d''achat: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Prix de vente
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterPrixVente;
      tpListeDelai.Add('  Prix de vente: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Prix de vente: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Prix de vente indicatif
    if (Dm_Main.Provenance in [ipInterSys]) and bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterPrixVenteIndicatif;
      tpListeDelai.Add('  Prix de vente indicatif: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Prix de vente indicatif: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Article déprécié
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterModeleDeprecie;
      tpListeDelai.Add('  Article déprécié: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Article déprécié: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Contact fournisseur
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterFouContact;
      tpListeDelai.Add('  Contact fournisseur: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Contact fournisseur: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Condition Fournisseur
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterFouCondition;
      tpListeDelai.Add('  Condition Fournisseur: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Condition Fournisseur: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // verru relation fournisseur<-->marque intersys
    if bContinue and (Dm_Main.Provenance in [ipInterSys, ipDataMag, ipExotiqueISF]) then
    begin
      tProc := Now;
      bContinue := TraiterVerruFourMarque;
      tpListeDelai.Add('  Relation Marque<-->Fournisseur Intersys: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Relation Marque<-->Fournisseur Intersys: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Article Idéal
    if bContinue then
    begin
      tProc := Now;
      bContinue := TraiterArtIdeal;
      tpListeDelai.Add('  Article Idéal: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Article Idéal: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Oppération Commerciale
    if bContinue then
    begin
      tProc := Now;
      bContinue := TraiterTOC;
      tpListeDelai.Add('  Oppération Commerciale: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Oppération Commerciale: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    // Backup - Restore
    if bcontinue then
    begin
      tProc := Now;
      bContinue := TraiterBackupRestore;
      tpListeDelai.Add('  Backup-Restore: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
      if Dm_Main.GetDoMail(AllMail) then
        SendEmail(Dm_Main.GetMailLst, Dm_Main.GetSubjectMail,'Article - Backup-Restore: '+#9#9+formatdatetime('hh:nn:ss:zzz', now-tProc));
    end;

    if sError<>'' then
    begin
      tpListeDelai.Add(sError);
      if Dm_Main.GetDoMail(ErreurMail) then
        SendEmail(Dm_Main.GetMailLst, '[ALERT - ERREUR] - ' + Dm_Main.GetSubjectMail,'Article - ' + sError);
    end;

    tpListeDelai.Add('');
    tpListeDelai.Add('');
    tpListeDelai.Add('Temps total: '+formatdatetime('hh:nn:ss:zzz', now-tTot));
    if Dm_Main.GetDoMail(CliArtHistBonRAtelier) then
      SendEmail(Dm_Main.GetMailLst, '[Fin Article] - ' + Dm_Main.GetSubjectMail,'Article - Temps total: '+formatdatetime('hh:nn:ss:zzz', now-tTot));

    try
      tpListeDelai.SaveToFile(Dm_Main.ReperBase + Dm_Main.GetSubjectMail + '_Delai_Import_Art_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    except
    end;


    if bContinue then
      Synchronize(EndFrm);
  finally
    bError := not(bContinue);
    FreeAndNil(tpListeDelai);
  end;
end;

function TRefArticle.GetValueFournImp(AChamp: string): string;
begin
  if (Dm_Main.Provenance in [ipNosymag, ipGoSport]) then
    Result := GetValueImp(AChamp, Fourn_2_COL, LigneLecture, bRetirePtVirg)
  else
    Result := GetValueImp(AChamp, Fourn_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueMarqueImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Marque_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueOcDetailImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, OcDetail_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueOcLignesImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, OcLignes_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueOcMagImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, OcMag_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueOcTeteImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, OcTete_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueFouMarqueImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Foumarque_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueGrTailleImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, GrTaille_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueGrTailleLigImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, GrTailleLig_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueDomaineImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, DomaineCommercial_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueAxeImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Axe_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueAxeNiv1Imp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, AxeNiveau1_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueAxeNiv2Imp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, AxeNiveau2_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueAxeNiv3Imp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, AxeNiveau3_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueAxeNiv4Imp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, AxeNiveau4_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueCollectionImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Collection_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueGenreImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Genre_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueArticleImp(AChamp: string): string;
begin
  if (Dm_Main.Provenance in [ipNosymag]) then
    Result := GetValueImp(AChamp, Article_2_COL, LigneLecture, bRetirePtVirg)
  else
    Result := GetValueImp(AChamp, Article_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueArtIdealImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, ArtIdeal_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueAllCBImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, AllCB_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueArticleAxeImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, ArticleAxe_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueArticleCollectionImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, ArticleCollection_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueCouleurImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Couleur_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueCodeBarreImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, CodeBarre_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValuePrixAchatImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Prix_Achat_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValuePrixVenteImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Prix_Vente_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValuePrixVenteIndicatifImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, Prix_Vente_Indicatif_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueArticleDeprecieImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, ModeleDeprecie_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueFouContactImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, FouContact_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.GetValueFouConditionImp(AChamp: string): string;
begin
  Result := GetValueImp(AChamp, FouCondition_COL, LigneLecture, bRetirePtVirg);
end;

function TRefArticle.LoadFile: Boolean;
var
  Que_Tmp: TIBQuery;
begin
  result := true;

  cds_Fourn.Clear;
  cds_Marque.Clear;
  cds_Foumarque.Clear;
  cds_GrTaille.Clear;
  cds_GrTailleLig.Clear;
  cds_Domaine.Clear;
  cds_Axe.Clear;
  cds_AxeNiveau1.Clear;
  cds_AxeNiveau2.Clear;
  cds_AxeNiveau3.Clear;
  cds_AxeNiveau4.Clear;
  cds_Collection.Clear;
  cds_Genre.Clear;
  cds_Article.Clear;
  cds_ArticleAxe.Clear;
  cds_ArticleCollection.Clear;
  cds_Couleur.Clear;
  cds_CodeBarre.Clear;
  cds_PrixAchat.Clear;
  cds_PrixVente.Clear;
  cds_PrixVenteIndicatif.Clear;
  cds_ModeleDeprecie.Clear;
  cds_FouContact.Clear;
  cds_FouCondition.Clear;
  cds_ArtIdeal.Clear;
  cds_OcTete.Clear;
  cds_OcMag.Clear;
  cds_OcLignes.Clear;
  cds_OcDetail.Clear;
  cds_AllCB.Clear;

  Que_Tmp := TIbQuery.Create(nil);
  try
    Que_Tmp.Database := dm_Main.Database;

    // mise en mémoire de la liste des magasins
    with Que_Tmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select MAG_ID, MAG_CODEADH from genmagasin');
      SQL.Add('  join k on k_id=mag_id and k_enabled=1');
      Open;
      First;
      While not(Eof) do
      begin
        cds_Magasin.Append;
        cds_Magasin.FieldByName('MAG_ID').AsInteger := FieldByName('MAG_ID').AsInteger;
        cds_Magasin.FieldByName('MAG_CODEADH').AsString := FieldByName('MAG_CODEADH').AsString;
        cds_Magasin.Post;
        Next;
      end;
      Close;
      cds_Magasin.IndexFieldNames := 'MAG_CODEADH';
    end;

    // mise en mémoire de la liste des type de ventes
    with Que_Tmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select TYP_COD, TYP_ID from gentypcdv');
      SQL.Add('  join k on k_id=typ_id and k_enabled=1');
      Open;
      First;
      While not(Eof) do
      begin
        cds_TypeVen.Append;
        cds_TypeVen.FieldByName('TYP_COD').AsInteger := FieldByName('TYP_COD').AsInteger;
        cds_TypeVen.FieldByName('TYP_ID').AsInteger := FieldByName('TYP_ID').AsInteger;
        cds_TypeVen.Post;
        Next;
      end;
      Close;
      cds_TypeVen.IndexFieldNames := 'TYP_COD';
    end;
  finally
    FreeAndNil(Que_Tmp);
  end;


  sEtat1 := 'Chargement:';
  // Chargement Fournisseur
  try
    sEtat2 := 'Fichier FOURN.CSV';
    Synchronize(UpdateFrm);
    cds_Fourn.LoadFromFile(sPathFourn);
    Dm_Main.LoadListeFournID;
    Dm_Main.LoadListeFournCodeIS;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement marque
  try
    sEtat2 := 'Fichier MARQUE.CSV';
    Synchronize(UpdateFrm);
    cds_Marque.LoadFromFile(sPathMarque);
    Dm_Main.LoadListeMarqueID;
    Dm_Main.LoadListeMarqueCodeIS;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement relation fournisseur <--> marque
  try
    sEtat2 := 'Fichier FOUMARQUE.CSV';
    Synchronize(UpdateFrm);
    cds_Foumarque.LoadFromFile(sPathFoumarque);
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement grille de taille (+ categorie de taille)
  try
    sEtat2 := 'Fichier GR_TAILLE.CSV';
    Synchronize(UpdateFrm);
    cds_GrTaille.LoadFromFile(sPathGrTaille);
    Dm_Main.LoadListeGrTailleID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement ligne de taille
  try
    sEtat2 := 'Fichier GR_TAILLE_LIG.CSV';
    Synchronize(UpdateFrm);
    cds_GrTailleLig.LoadFromFile(sPathGrTailleLig);
    Dm_Main.LoadListeGrTailleLigID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement Domaine commercial
  try
    sEtat2 := 'Fichier DOMAINE_COMMERCIAL.CSV';
    Synchronize(UpdateFrm);
    cds_Domaine.LoadFromFile(sPathDomaine);
    Dm_Main.LoadListeDomaineID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement Axe
  try
    sEtat2 := 'Fichier AXE.CSV';
    Synchronize(UpdateFrm);
    cds_Axe.LoadFromFile(sPathAxe);
    Dm_Main.LoadListeAxeID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement Axe ; Niveau 1
  try
    sEtat2 := 'Fichier AXE_NIVEAU1.CSV';
    Synchronize(UpdateFrm);
    cds_AxeNiveau1.LoadFromFile(sPathAxeNiveau1);
    Dm_Main.LoadListeAxeNiveau1ID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement Axe ; Niveau 2
  try
    sEtat2 := 'Fichier AXE_NIVEAU2.CSV';
    Synchronize(UpdateFrm);
    cds_AxeNiveau2.LoadFromFile(sPathAxeNiveau2);
    Dm_Main.LoadListeAxeNiveau2ID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement Axe ; Niveau 3
  try
    sEtat2 := 'Fichier AXE_NIVEAU3.CSV';
    Synchronize(UpdateFrm);
    cds_AxeNiveau3.LoadFromFile(sPathAxeNiveau3);
    Dm_Main.LoadListeAxeNiveau3ID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement Axe ; Niveau 4
  try
    sEtat2 := 'Fichier AXE_NIVEAU4.CSV';
    Synchronize(UpdateFrm);
    cds_AxeNiveau4.LoadFromFile(sPathAxeNiveau4);
    Dm_Main.LoadListeAxeNiveau4ID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement Collection
  sEtat1 := 'Chargement:';
  try
    sEtat2 := 'Fichier COLLECTION.CSV';
    Synchronize(UpdateFrm);
    cds_Collection.LoadFromFile(sPathCollection);
    Dm_Main.LoadListeCollectionID;
    Dm_Main.LoadListeCollectionCodeIS;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement Genre
  sEtat1 := 'Chargement:';
  try
    sEtat2 := 'Fichier GENRE.CSV';
    Synchronize(UpdateFrm);
    cds_Genre.LoadFromFile(sPathGenre);
    Dm_Main.LoadListeGenreID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement Article
  try
    sEtat2 := 'Fichier ARTICLE.CSV';
    Synchronize(UpdateFrm);
    cds_Article.LoadFromFile(sPathArticle);
    Dm_Main.LoadListeArticleID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement Relation Article<-->Axe
  try
    sEtat2 := 'Fichier ARTICLE_AXE.CSV';
    Synchronize(UpdateFrm);
    cds_ArticleAxe.LoadFromFile(sPathArticleAxe);
    Dm_Main.LoadListeArtAxeID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement Relation Article<-->Collection
  try
    sEtat2 := 'Fichier ARTICLE_COLLECTION.CSV';
    Synchronize(UpdateFrm);
    cds_ArticleCollection.LoadFromFile(sPathArticleCollection);
    Dm_Main.LoadListeArtCollectionID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement Couleur
  try
    sEtat2 := 'Fichier COULEUR.CSV';
    Synchronize(UpdateFrm);
    cds_Couleur.LoadFromFile(sPathCouleur);
    Dm_Main.LoadListeCouleurID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement Code barre
  try
    sEtat2 := 'Fichier CODE_BARRE.CSV';
    Synchronize(UpdateFrm);
    cds_CodeBarre.LoadFromFile(sPathCodeBarre);
    Dm_Main.LoadListeCBID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement prix d'achat
  try
    sEtat2 := 'Fichier PRIX_ACHAT.CSV';
    Synchronize(UpdateFrm);
    cds_PrixAchat.LoadFromFile(sPathAchatPrix);
    Dm_Main.LoadListePrixAchatID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement prix de vente
  try
    sEtat2 := 'Fichier PRIX_VENTE.CSV';
    Synchronize(UpdateFrm);
    cds_PrixVente.LoadFromFile(sPathVentePrix);
    Dm_Main.LoadListePrixVenteID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement prix de vente indicatif
  if (Dm_Main.Provenance in [ipInterSys]) then  // uniquement pour intersys
  begin
    try
      sEtat2 := 'Fichier PRIX_VENTE_INDICATIF.CSV';
      Synchronize(UpdateFrm);
      cds_PrixVenteIndicatif.LoadFromFile(sPathVenteIndicatifPrix);
      Dm_Main.LoadListePrixVenteIndicatifID;
    except
      on E:Exception do
      begin
        Result := false;
        sError := E.Message;
        Synchronize(ErrorFrm);
        exit;
      end;
    end;
  end;

  // Chargement article déprécié
  try
    sEtat2 := 'Fichier MODELEDEPRECIE.CSV';
    Synchronize(UpdateFrm);
    cds_ModeleDeprecie.LoadFromFile(sPathModeleDeprecie);
    Dm_Main.LoadListeArticleDeprecieID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement contact fournisseur
  try
    sEtat2 := 'Fichier FOUCONTACT.CSV';
    Synchronize(UpdateFrm);
    cds_FouContact.LoadFromFile(sPathFouContact);
    Dm_Main.LoadListeFouContactID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement condition fournisseur
  try
    sEtat2 := 'Fichier FOUCONDITION.CSV';
    Synchronize(UpdateFrm);
    cds_FouCondition.LoadFromFile(sPathFouCondition);
    Dm_Main.LoadListeFouConditionID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement ArtIdeal
  try
    sEtat2 := 'Fichier ' + ArtIdeal_CSV;
    Synchronize(UpdateFrm);
    cds_ArtIdeal.LoadFromFile(sPathArtIdeal);
    Dm_Main.LoadListeArtIdealID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement OcTete
  try
    sEtat2 := 'Fichier ' + OcTete_CSV;
    Synchronize(UpdateFrm);
    cds_OcTete.LoadFromFile(sPathOcTete);
    Dm_Main.LoadListeOcTeteID;
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement OcMag
  try
    sEtat2 := 'Fichier ' + OcMag_CSV;
    Synchronize(UpdateFrm);
    cds_OcMag.LoadFromFile(sPathOcMag);
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement OcLignes
  try
    sEtat2 := 'Fichier ' + OcLignes_CSV;
    Synchronize(UpdateFrm);
    cds_OcLignes.LoadFromFile(sPathOcLignes);
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement OcDetail
  try
    sEtat2 := 'Fichier ' + OcDetail_CSV;
    Synchronize(UpdateFrm);
    cds_OcDetail.LoadFromFile(sPathOcDetail);
  except
    on E:Exception do
    begin
      Result := false;
      sError := E.Message;
      Synchronize(ErrorFrm);
      exit;
    end;
  end;

  // Chargement AllCB
  if Dm_Main.Provenance in [ipNosymag, ipGoSport] then
  begin
    try
      sEtat2 := 'Fichier ' + AllCB_CSV;
      Synchronize(UpdateFrm);
      cds_AllCB.LoadFromFile(ExtractFilePath(sPathCodeBarre) + 'All_CB.csv');
    except
      on E:Exception do
      begin
        Result := false;
        sError := E.Message;
        Synchronize(ErrorFrm);
        exit;
      end;
    end;
  end;

end;

procedure TRefArticle.InitExecute;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(3, bm);
    Frm_Load.img_RefArticle.Picture:=nil;
    Frm_Load.img_RefArticle.Picture.Assign(bm);
    Frm_Load.img_RefArticle.Transparent := false;
    Frm_Load.img_RefArticle.Transparent := true;
  finally
    FreeAndNil(bm);
  end;
end;

procedure TRefArticle.InitFrm;
var
  bm: TBitmap;
begin
  bm := TBitmap.Create;
  try
    Dm_GinkoiaStyle.Img_Boutons.GetBitmap(11, bm);
    Frm_Load.img_RefArticle.Picture:=nil;
    Frm_Load.img_RefArticle.Picture.Assign(bm);
    Frm_Load.img_RefArticle.Transparent := false;
    Frm_Load.img_RefArticle.Transparent := true;
  finally
    FreeAndNil(bm);
  end;
  Frm_Load.Lab_EtatArt1.Caption := 'Initialisation';
  Frm_Load.Lab_EtatArt2.Caption := '';
  Frm_Load.Lab_EtatArt2.Hint := '';
end;

procedure TRefArticle.InitProgressFrm;
begin
  Frm_Load.pb_EtatArt.Position := 0;
  Frm_Load.pb_EtatArt.Max := iMaxProgress;
end;

procedure TRefArticle.InitThread(ARetirePtVirg: boolean; aPathFourn,
  aPathMarque, aPathFoumarque, aPathGrTaille, aPathGrTailleLig, aPathDomaine,
  aPathAxe, aPathAxeNiveau1, aPathAxeNiveau2, aPathAxeNiveau3, aPathAxeNiveau4,
  aPathCollection, aPathGenre, aPathArticle, aPathArticleAxe,
  aPathArticleCollection, aPathCouleur, aPathCodeBarre, aPathAchatPrix,
  aPathVentePrix, aPathVenteIndicatifPrix, aPathModeleDeprecie, aPathFouContact,
  aPathFouCondition, aPathArtIdeal, aPathOcTete, aPathOcMag, aPathOcLignes,
  aPathOcDetail : string);
begin
  Synchronize(InitFrm);
  bRetirePtVirg := ARetirePtVirg;

  sPathFourn              := aPathFourn;
  sPathMarque             := aPathMarque;
  sPathFoumarque          := aPathFoumarque;
  sPathGrTaille           := aPathGrTaille;
  sPathGrTailleLig        := aPathGrTailleLig;
  sPathDomaine            := aPathDomaine;
  sPathAxe                := aPathAxe;
  sPathAxeNiveau1         := aPathAxeNiveau1;
  sPathAxeNiveau2         := aPathAxeNiveau2;
  sPathAxeNiveau3         := aPathAxeNiveau3;
  sPathAxeNiveau4         := aPathAxeNiveau4;
  sPathCollection         := aPathCollection;
  sPathArticle            := aPathArticle;
  sPathGenre              := aPathGenre;
  sPathArticleAxe         := aPathArticleAxe;
  sPathArticleCollection  := aPathArticleCollection;
  sPathCouleur            := aPathCouleur;
  sPathCodeBarre          := aPathCodeBarre;
  sPathAchatPrix          := aPathAchatPrix;
  sPathVentePrix          := aPathVentePrix;
  sPathVenteIndicatifPrix := aPathVenteIndicatifPrix;
  sPathModeleDeprecie     := aPathModeleDeprecie;
  sPathFouContact         := aPathFouContact;
  sPathFouCondition       := aPathFouCondition;
  sPathArtIdeal           := aPathArtIdeal;
  sPathOcTete             := aPathOcTete;
  sPathOcMag              := aPathOcMag;
  sPathOcLignes           := aPathOcLignes;
  sPathOcDetail           := aPathOcDetail;
end;

function TRefArticle.TraiterFourn: Boolean;
var
  sAdresse: string;
  iFouID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
begin
  Result := true;

  iMaxProgress := cds_Fourn.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "FOURN.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDFourn.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_Fourn.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Fourn[i]<>'' then
        begin

          // ajout ligne
          if (Dm_Main.Provenance in [ipNosymag]) then
            AjoutInfoLigne(cds_Fourn[i], Fourn_2_COL)
          else
            AjoutInfoLigne(cds_Fourn[i], Fourn_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheFournID(GetValueFournImp('Code'), NbRech);

          // création si pas déjà créé
          if (LRechID=-1)
           and (GetValueFournImp('Code')<>'')
           and (GetValueFournImp('Nom')<>'') then
          begin

            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            sAdresse := GetValueFournImp('Adr1')+#13#10+
                        GetValueFournImp('Adr2')+#13#10+
                        GetValueFournImp('Adr3');

            StProc_Fourn.Close;
            StProc_Fourn.ParamByName('CODEIS').AsString    := GetValueFournImp('CodeIS');
            StProc_Fourn.ParamByName('FOUNOM').AsString    := GetValueFournImp('Nom');
            StProc_Fourn.ParamByName('ADRESSE').AsString   := sAdresse;
            StProc_Fourn.ParamByName('CP').AsString        := GetValueFournImp('CP');
            StProc_Fourn.ParamByName('VILLE').AsString     := GetValueFournImp('Ville');
            StProc_Fourn.ParamByName('PAYS').AsString      := GetValueFournImp('Pays');
            StProc_Fourn.ParamByName('TEL').AsString       := GetValueFournImp('Tel');
            StProc_Fourn.ParamByName('FAX').AsString       := GetValueFournImp('Fax');
            StProc_Fourn.ParamByName('PORTABLE').AsString  := GetValueFournImp('Portable');
            StProc_Fourn.ParamByName('EMAIL').AsString     := GetValueFournImp('email');
            StProc_Fourn.ParamByName('COMMENT').AsString   := GetValueFournImp('Commentaire');
            StProc_Fourn.ParamByName('NUMCLT').AsString    := GetValueFournImp('Num_Clt');
            StProc_Fourn.ParamByName('NUMCOMPTA').AsString := GetValueFournImp('Num_Compta');
            StProc_Fourn.ParamByName('ACTIF').AsInteger    := StrToIntDef(GetValueFournImp('Actif'), 1);
            StProc_Fourn.ParamByName('CENTRALE').AsInteger := StrToIntDef(GetValueFournImp('Centrale'), 0);
            StProc_Fourn.ParamByName('FOUILN').AsString    := GetValueFournImp('ILN');
            if (Dm_Main.Provenance in [ipNosymag]) then
              StProc_Fourn.ParamByName('FOUERPNO').AsString    := GetValueFournImp('ERPNO');
            StProc_Fourn.ExecQuery;

            // récupération du nouvel ID fournisseur
            iFouID := StProc_Fourn.FieldByName('FOUID').AsInteger;

            StProc_Fourn.Close;

            Dm_Main.TransacArt.Commit;
            Dm_Main.AjoutInListeFournID(GetValueFournImp('Code'), iFouID);
            Dm_Main.AjoutInListeFournCodeIS(GetValueFournImp('CodeIS'), iFouID);

          end;
        end;

        Inc(i);
      end;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeFournID;
    Dm_Main.SaveListeFournCodeIS;
    StProc_Fourn.Close;
  end;

end;

function TRefArticle.TraiterMarque: Boolean;
var
  iMrkID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
begin
  Result := true;

  iMaxProgress := cds_Marque.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "MARQUE.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDMarque.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_Marque.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Marque[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Marque[i], Marque_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheMarqueID(GetValueMarqueImp('Code'), NbRech);

          if (LRechID=-1) and (GetValueMarqueImp('Code')<>'')
             and (GetValueMarqueImp('Nom')<>'') then
          begin
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            StProc_Marque.Close;
            StProc_Marque.ParamByName('MRKCODEIS').AsString    := UpperCase(GetValueMarqueImp('CodeIS'));
            StProc_Marque.ParamByName('MRKNOM').AsString       := GetValueMarqueImp('Nom');
            StProc_Marque.ParamByName('MRKACTIVE').AsInteger   := StrToIntDef(GetValueMarqueImp('ACTIF'), 1);
            StProc_Marque.ParamByName('MRKPROPRE').AsInteger   := StrToIntDef(GetValueMarqueImp('PROPRE'), 0);
            StProc_Marque.ParamByName('MRKCENTRALE').AsInteger := StrToIntDef(GetValueMarqueImp('CENTRALE'), 0);
            StProc_Marque.ExecQuery;

            // récupération du nouvel ID Marque
            iMrkID := StProc_Marque.FieldByName('MRKID').AsInteger;
            Dm_Main.AjoutInListeMarqueID(GetValueMarqueImp('Code'), iMrkID);
            Dm_Main.AjoutInListeMarqueCodeIS(UpperCase(GetValueMarqueImp('CodeIS')), iMrkID);

            StProc_Marque.Close;

            Dm_Main.TransacArt.Commit;
          end;
        end;

        inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);

    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    Dm_Main.SaveListeMarqueID;
    Dm_Main.SaveListeMarqueCodeIS;
    StProc_Marque.Close;
  end;
end;

// Domaine commercial
function TRefArticle.TraiterDomaine: boolean;
var
  iActID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
begin
  Result := true;

  iMaxProgress := cds_Domaine.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "DOMAINE_COMMERCIAL.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDDomaine.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_Domaine.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Domaine[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Domaine[i], DomaineCommercial_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheDomaineID(GetValueDomaineImp('Code'), NbRech);

          if (LRechID=-1)
             and (GetValueDomaineImp('Code')<>'')
             and (GetValueDomaineImp('Nom')<>'') then
          begin
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            StProc_Domaine.Close;
            StProc_Domaine.ParamByName('ACTNOM').AsString := GetValueDomaineImp('Nom');
            StProc_Domaine.ExecQuery;

            // récupération du nouvel ID Domaine
            iActID := StProc_Domaine.FieldByName('ACTID').AsInteger;
            Dm_Main.AjoutInListeDomaineID(GetValueDomaineImp('Code'), iActID);

            StProc_Domaine.Close;

            Dm_Main.TransacArt.Commit;
          end;
        end;

        inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_Domaine.Close;
    Dm_Main.SaveListeDomaineID;
  end;
end;

// relation Fournisseur <--> marque
function TRefArticle.TraiterFouMarque: Boolean;
var
  iFmkID: integer;
  iFouID: integer;
  iMrkID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;
  //Err2FourPrin: integer;
  LstErr: TStringList;
  StProc_Temp: TIBSQL;
  bErr: boolean;

  NbRech: integer;
  LRechID: integer;
begin
  Result := true;

  iMaxProgress := cds_FouMarque.Count-1;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "FOUMARQUE.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  bErr := false;
  LstErr := TStringList.Create;
  StProc_Temp := TIBSQL.Create(nil);
  with StProc_Temp do
  begin
    Database := Dm_Main.Database;
    Transaction := Dm_Main.TransacArt;
  end;
  try
    i := 1;
    try
      NbEnre := cds_FouMarque.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_FouMarque[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_FouMarque[i], Foumarque_COL);

          bErr := false;
          if GetValueFouMarqueImp('CODE_FOU')='' then
          begin
            bErr := true;
            LstErr.Add('CODE_FOU à vide pour la ligne ('+inttostr(i)+'): '+LigneLecture);
          end;
          if GetValueFouMarqueImp('CODE_MARQUE')='' then
          begin
            bErr := true;
            LstErr.Add('CODE_MARQUE à vide pour la ligne ('+inttostr(i)+'): '+LigneLecture);
          end;

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheFouMrkID(GetValueFouMarqueImp('CODE_MARQUE')+GetValueFouMarqueImp('CODE_FOU')+GetValueFouMarqueImp('FOU_PRINC'), NbRech);

          if (LRechID=-1)
             and (GetValueFouMarqueImp('CODE_FOU')<>'')
             and (GetValueFouMarqueImp('CODE_MARQUE')<>'') then
          begin
            // recherche Id Fournisseur
            iFouID := Dm_Main.GetFouID(GetValueFouMarqueImp('CODE_FOU'));
            if iFouID<0 then
            begin
              bErr := true;
              LstErr.Add('Code fournisseur: "'+GetValueFouMarqueImp('CODE_FOU')+'" non trouvé pour la ligne ('+inttostr(i)+'): '+LigneLecture);
            end;

            // recherche Id Marque
            iMrkID := Dm_Main.GetMrkID(UpperCase(GetValueFouMarqueImp('CODE_MARQUE')));
            if iMrkID<0 then
            begin
              bErr := true;
              LstErr.Add('Code marque: "'+GetValueFouMarqueImp('CODE_MARQUE')+'" non trouvé pour la ligne ('+inttostr(i)+'): '+LigneLecture);
            end;

            // ajout
            if (iFouID<>-1) and (iMrkID<>-1) and not(bErr) then
            begin
              if not(Dm_Main.TransacArt.InTransaction) then
                Dm_Main.TransacArt.StartTransaction;

              StProc_FouMarque.Close;
              StProc_FouMarque.ParamByName('FOUID').AsInteger := iFouID;
              StProc_FouMarque.ParamByName('MRKID').AsInteger := iMrkID;
              StProc_FouMarque.ParamByName('PRINCIPAL').AsInteger := StrToIntDef(GetValueFouMarqueImp('FOU_PRINC'), 0);
              StProc_FouMarque.ExecQuery;

              // y a t'il 2 fournisseurs principale pour une même marque ?
//              Err2FourPrin := StProc_FouMarque.FieldByName('ERREUR').AsInteger;
//              if (Err2FourPrin=1) then
//              begin
//                if LstErr.IndexOf(GetValueFouMarqueImp('CODE_MARQUE'))<0 then
//                  LstErr.Add('plusieurs fournisseurs principales pour une même marque ('+
//                                       GetValueFouMarqueImp('CODE_MARQUE')+')');
//                Raise Exception.Create('plusieurs fournisseurs principales pour une même marque ('+
//                                       GetValueFouMarqueImp('CODE_MARQUE')+')');
//              end;

              iFmkID := StProc_FouMarque.FieldByName('FMKID').AsInteger;
              Dm_Main.AjoutInListeFouMrkID(GetValueFouMarqueImp('CODE_MARQUE')+GetValueFouMarqueImp('CODE_FOU')+GetValueFouMarqueImp('FOU_PRINC'), iFmkID);

              StProc_FouMarque.Close;

              Dm_Main.TransacArt.Commit;
            end;
          end;
        end;

        Inc(i);
      end;

      // met un fournisseur principale (le premier trouvé) là où il n'y en a pas
      if not(Dm_Main.TransacArt.InTransaction) then
        Dm_Main.TransacArt.StartTransaction;
      StProc_Temp.SQL.Clear;
      StProc_Temp.SQL.Add('execute procedure MG10_FOUMARQUE_DOSANSPRIN');
      StProc_Temp.ExecQuery;
      StProc_Temp.Close;
      Dm_Main.TransacArt.Commit;

    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_FouMarque.Close;
    if LstErr.Count>0 then
      LstErr.SaveToFile(Dm_Main.ReperBase+'Err_FouMarque.txt');
    FreeAndNil(LstErr);
    StProc_Temp.Close;
    FreeAndNil(StProc_Temp);
  end;
end;

// grille de taille (+ categorie de taille)
function TRefArticle.TraiterGr_Taille: Boolean;
var
  iTgtID: integer;
  iGtfID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  sTmpCode: string;
  Que_Tmp: TIBQuery;
begin
  Result := true;

  if (Dm_Main.Provenance in [ipGinkoia, ipDataMag, ipNosymag, ipGoSport, ipExotiqueISF]) then  // proviens de ginkoia
  begin
    iMaxProgress := cds_GrTaille.Count;
    iProgress := 0;
    AvancePc := Round((iMaxProgress/100)*2);
    if AvancePc<=0 then
      AvancePc := 1;
    inc(iTraitement);
    sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "GR_TAILLE.CSV":';
    sEtat2 := '0 / '+inttostr(iMaxProgress);
    Synchronize(UpdateFrm);
    Synchronize(InitProgressFrm);
    DoLog(sEtat1, logInfo);

    NbRech := Dm_Main.ListeIDGrTaille.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
    try
      i := 1;
      try
        NbEnre := cds_GrTaille.Count-1;
        while (i<=NbEnre) do
        begin
          // maj de la fenetre
          sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
          Inc(iProgress);
          if ((iProgress mod AvancePc)=0) then
            Synchronize(UpdProgressFrm);

          if cds_GrTaille[i]<>'' then
          begin
            // ajout ligne
            AjoutInfoLigne(cds_GrTaille[i], GrTaille_COL);

            // recherche si pas déjà importé
            LRechID := Dm_Main.RechercheGrTailleID(GetValueGrTailleImp('Code'), NbRech);

            if (LRechID=-1) and (GetValueGrTailleImp('CODE')<>'')
               and (GetValueGrTailleImp('NOM')<>'') then
            begin
              if not(Dm_Main.TransacArt.InTransaction) then
                Dm_Main.TransacArt.StartTransaction;

              StProc_Gr_Taille.Close;
              StProc_Gr_Taille.ParamByName('GTFCODEIS').AsString    := GetValueGrTailleImp('CODEIS');
              StProc_Gr_Taille.ParamByName('GTFNOM').AsString       := GetValueGrTailleImp('NOM');
              StProc_Gr_Taille.ParamByName('GTFCENTRALE').AsInteger := StrToIntDef(GetValueGrTailleImp('CENTRALE'), 0);
              StProc_Gr_Taille.ParamByName('TGTCODEIS').AsString    := GetValueGrTailleImp('CODEIS_TYPEGT');
              StProc_Gr_Taille.ParamByName('TGTNOM').AsString       := GetValueGrTailleImp('TYPE_GRILLE');
              StProc_Gr_Taille.ParamByName('TGTCENTRALE').AsInteger := StrToIntDef(GetValueGrTailleImp('CENTRALE_TYPEGT'),0);
              StProc_Gr_Taille.ExecQuery;

              // récupération du nouvel ID Categorie de taille et grille de taille
              iTgtID := StProc_Gr_Taille.FieldByName('TGTID').AsInteger;
              iGtfID := StProc_Gr_Taille.FieldByName('GTFID').AsInteger;
              Dm_Main.AjoutInListeGrTailleID(GetValueGrTailleImp('Code'), iGtfID, iTgtID);

              StProc_Gr_Taille.Close;

              Dm_Main.TransacArt.Commit;
            end;
          end;

          inc(i);
        end;
      except
        on E: Exception do
        begin
          if (Dm_Main.TransacArt.InTransaction) then
            Dm_Main.TransacArt.Rollback;
          Result := false;
          sError := '('+inttostr(i)+')'+#13#10+
                    'Ligne: '+LigneLecture+#13#10+
                    E.Message;
          DoLog(sError, logError);
          Synchronize(UpdProgressFrm);
          Synchronize(ErrorFrm);
        end;
      end;
    finally
      Dm_Main.SaveListeGrTailleID;
      StProc_Gr_Taille.Close;
    end;
  end
  else
  begin  // proviens d'Intersys
    inc(iTraitement);
    sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "GR_TAILLE.CSV":';
    sEtat2 := '';
    Synchronize(UpdateFrm);
    Synchronize(InitProgressFrm);
    DoLog(sEtat1, logInfo);

    NbRech := Dm_Main.ListeIDGrTaille.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
    Que_Tmp := TIBQuery.Create(nil);
    try
      try
        Que_Tmp.Database := dm_Main.Database;
        with Que_Tmp do
        begin
          SQL.Clear;
          SQL.Add('select count(*) as Nbre from plxgtf');
          SQL.Add('  join k on k_id=gtf_id and k_enabled=1');
          SQL.Add(' where gtf_id<>0 and gtf_code<>'+QuotedStr(''));
          Open;
          iMaxProgress := FieldByName('Nbre').AsInteger;
          iProgress := 0;
          AvancePc := Round((iMaxProgress/100)*2);
          if AvancePc<=0 then
            AvancePc := 1;
          sEtat2 := '0 / '+inttostr(iMaxProgress);
          Synchronize(UpdateFrm);
          Close;

          SQL.Clear;
          SQL.Add('select GTF_CODE, GTF_ID, GTF_TGTID from plxgtf');
          SQL.Add('  join k on k_id=gtf_id and k_enabled=1');
          SQL.Add(' where gtf_id<>0 and gtf_code<>'+QuotedStr(''));
          Open;
          First;
          while not(Eof) do
          begin
          // maj de la fenetre
            sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
            Inc(iProgress);
            if ((iProgress mod AvancePc)=0) then
              Synchronize(UpdProgressFrm);

            sTmpCode := StringReplace(fieldbyname('GTF_CODE').AsString, '.', '', [rfReplaceAll, rfIgnoreCase]);
            LRechID := Dm_Main.RechercheGrTailleID(sTmpCode, NbRech);
            if LRechID=-1 then
              Dm_Main.AjoutInListeGrTailleID(sTmpCode, fieldbyname('GTF_ID').AsInteger,
                                                       fieldbyname('GTF_TGTID').AsInteger);
            Next;
          end;
          Close;

        end;
      except
        on E: Exception do
        begin
          Result := false;
          sError := E.Message;
          DoLog(sError, logError);
          Synchronize(UpdProgressFrm);
          Synchronize(ErrorFrm);
        end;
      end;
    finally
      Que_Tmp.Close;
      Dm_Main.SaveListeGrTailleID;
      FreeAndNil(Que_Tmp);
    end;
  end;
end;     

// ligne de taille
function TRefArticle.TraiterGr_Taille_Lig: Boolean;
var
  iGtfID: integer;
  iTgfID: integer;
  iTgsID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  Que_Tmp: TIBQuery;
  sTmpCode: string;
begin
  Result := true;

  if (Dm_Main.Provenance in [ipGinkoia, ipDataMag, ipNosymag, ipGoSport, ipExotiqueISF]) then  // provient de ginkoia
  begin
    iMaxProgress := cds_GrTailleLig.Count;
    iProgress := 0;
    AvancePc := Round((iMaxProgress/100)*2);
    if AvancePc<=0 then
      AvancePc := 1;
    inc(iTraitement);
    sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "GR_TAILLE_LIG.CSV":';
    sEtat2 := '0 / '+inttostr(iMaxProgress);
    Synchronize(UpdateFrm);
    Synchronize(InitProgressFrm);
    DoLog(sEtat1, logInfo);

    NbRech := Dm_Main.ListeIDGrTailleLig.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
    try
      i := 1;
      try
        NbEnre := cds_GrTailleLig.Count-1;
        while (i<=NbEnre) do
        begin
          // maj de la fenetre
          sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
          Inc(iProgress);
          if ((iProgress mod AvancePc)=0) then
            Synchronize(UpdProgressFrm);

          if cds_GrTailleLig[i]<>'' then
          begin
            // ajout ligne
            AjoutInfoLigne(cds_GrTailleLig[i], GrTailleLig_COL);

            // recherche si pas déjà importé
            //if (Dm_Main.Provenance in [ipGinkoia, ipNosymag, ipGoSport, ipDataMag, ipExotiqueISF]) then
            LRechID := Dm_Main.RechercheGrTailleLigID(GetValueGrTailleLigImp('Code'), NbRech);
            //else
            //  LRechID := Dm_Main.RechercheGrTailleLigID(GetValueGrTailleLigImp('CODE_GT') + GetValueGrTailleLigImp('Code'), NbRech);

            iGtfID := -1;
            if LRechID=-1 then
            begin
              iGtfID := Dm_Main.GetGtfID(GetValueGrTailleLigImp('CODE_GT'));
              if iGtfID<0 then
                raise Exception.Create('Code grille de taille: "'+GetValueGrTailleLigImp('CODE_GT')+'" non trouvé');
            end;

            if (LRechID=-1) and (iGtfID<>-1)
               and (GetValueGrTailleLigImp('CODE_GT')<>'')
               and (GetValueGrTailleLigImp('NOM')<>'')
               and (GetValueGrTailleLigImp('CODE')<>'') then
            begin
              if not(Dm_Main.TransacArt.InTransaction) then
                Dm_Main.TransacArt.StartTransaction;

              StProc_Gr_Taille_Lig.Close;
              StProc_Gr_Taille_Lig.ParamByName('GTFID').AsInteger       := iGtfID;
              StProc_Gr_Taille_Lig.ParamByName('TGFNOM').AsString       := GetValueGrTailleLigImp('NOM');
              StProc_Gr_Taille_Lig.ParamByName('TGFCODEIS').AsString    := GetValueGrTailleLigImp('CODEIS');
              StProc_Gr_Taille_Lig.ParamByName('TGFCENTRALE').AsInteger := StrToIntDef(GetValueGrTailleLigImp('CENTRALE'), 0);
              StProc_Gr_Taille_Lig.ParamByName('CORRESPOND').AsString   := GetValueGrTailleLigImp('CORRES');
              StProc_Gr_Taille_Lig.ParamByName('TGFORDREAFF').AsDouble  := ConvertStrToFloat(GetValueGrTailleLigImp('ORDREAFF'));
              StProc_Gr_Taille_Lig.ParamByName('TGFACTIVE').AsInteger   := StrToIntDef(GetValueGrTailleLigImp('ACTIF'), 1);
              StProc_Gr_Taille_Lig.ExecQuery;

              // récupération du nouvel ID taille
              iTgfID := StProc_Gr_Taille_Lig.FieldByName('TGFID').AsInteger;
              iTgsID := StProc_Gr_Taille_Lig.FieldByName('TGSID').AsInteger;
              Dm_Main.AjoutInListeGrTailleLigID(GetValueGrTailleLigImp('CODE'), iTgfID, iTgsID);

              StProc_Gr_Taille_Lig.Close;

              Dm_Main.TransacArt.Commit;
            end;
          end;

          inc(i)
        end;
      except
        on E: Exception do
        begin
          if (Dm_Main.TransacArt.InTransaction) then
            Dm_Main.TransacArt.Rollback;
          Result := false;
          sError := '('+inttostr(i)+')'+#13#10+
                    'Ligne: '+LigneLecture+#13#10+
                    E.Message;
          DoLog(sError, logError);
          Synchronize(UpdProgressFrm);
          Synchronize(ErrorFrm);
        end;
      end;
    finally
      Dm_Main.SaveListeGrTailleLigID;
      StProc_Gr_Taille_Lig.Close;
    end;
  end
  else
  begin// proviens d'Intersys
    inc(iTraitement);
    sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "GR_TAILLE_LIG.CSV":';
    sEtat2 := '';
    Synchronize(UpdateFrm);
    Synchronize(InitProgressFrm);
    DoLog(sEtat1, logInfo);

    NbRech := Dm_Main.ListeIDGrTailleLig.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
    Que_Tmp := TIBQuery.Create(nil);
    try
      try
        Que_Tmp.Database := dm_Main.Database;
        with Que_Tmp do
        begin
          SQL.Clear;
          SQL.Add('select count(*) as Nbre');
          SQL.Add('  from plxtaillesgf');
          SQL.Add('  join k on k_id=tgf_id and k_enabled=1');
          SQL.Add('where tgf_id<>0 and tgf_code<>'+QuotedStr(''));
          Open;
          iMaxProgress := FieldByName('Nbre').AsInteger;
          iProgress := 0;
          AvancePc := Round((iMaxProgress/100)*2);
          if AvancePc<=0 then
            AvancePc := 1;
          sEtat2 := '0 / '+inttostr(iMaxProgress);
          Synchronize(UpdateFrm);
          Synchronize(InitProgressFrm);
          Close;

          SQL.Clear;
          SQL.Add('select TGF_CODE, TGF_ID, tgf_tgsid');
          SQL.Add('  from plxtaillesgf');
          SQL.Add('  join k on k_id=tgf_id and k_enabled=1');
          SQL.Add('where tgf_id<>0 and tgf_code<>'+QuotedStr(''));
          Open;
          First;
          while not(Eof) do
          begin
          // maj de la fenetre
            sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
            Inc(iProgress);
            if ((iProgress mod AvancePc)=0) then
              Synchronize(UpdProgressFrm);

            sTmpCode := fieldbyname('TGF_CODE').AsString;
            LRechID := Dm_Main.RechercheGrTailleLigID(sTmpCode, NbRech);
            if LRechID=-1 then
              Dm_Main.AjoutInListeGrTailleLigID(sTmpCode, fieldbyname('TGF_ID').AsInteger,
                                                          fieldbyname('TGF_ID').AsInteger);
            Next;
          end;
          Close;

        end;
      except
        on E: Exception do
        begin
          Result := false;
          sError := E.Message;
          DoLog(sError, logError);
          Synchronize(UpdProgressFrm);
          Synchronize(ErrorFrm);
        end;
      end;
    finally
      Que_Tmp.Close;
      Dm_Main.SaveListeGrTailleLigID;
      FreeAndNil(Que_Tmp);
    end;
  end;
end;

 // Axe
function TRefArticle.TraiterAxe: boolean;
var
  iActDefaut: integer;
  iActID: integer;
  iUniID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;

  Que_ActDefault: TIBQuery;
begin
  Result := true;

  iMaxProgress := cds_Axe.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "AXE.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDAxe.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    iActDefaut := 0;
    try
      Que_ActDefault := TIBQuery.Create(nil);
      try
        with Que_ActDefault do
        begin
          Database := Dm_Main.Database;
          Transaction := Dm_Main.TransacArt;
          ParamCheck := True;
          SQL.Add('select min(ACT_ID) as ACTID from nklactivite');
          SQL.Add('  join k on k_id=act_id and k_enabled=1');
          SQL.Add(' where act_id<>0');
          Open;
          if (RecordCount>0) then
            iActDefaut := fieldbyname('ACTID').AsInteger
        end;
      finally
        Que_ActDefault.Close;
        FreeAndNil(Que_ActDefault);
      end;

      NbEnre := cds_Axe.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Axe[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Axe[i], Axe_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheAxeID(GetValueAxeImp('Code'), NbRech);

          if (LRechID=-1)
             and (GetValueAxeImp('Code')<>'')
             and (GetValueAxeImp('Nom')<>'')
             and (StrToIntDef(GetValueAxeImp('NIVEAU'), 0) in [0..4]) then
          begin
            iActID := dm_Main.GetActID(GetValueAxeImp('ACTIVITE'));
            if iActID<0 then
              iActID := 0;

            if iActID=0 then
              iActID := iActDefaut;

            if (iActID=0) then
              raise Exception.Create('Domaine non défini pour l''axe');

            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            StProc_Axe.Close;
            StProc_Axe.ParamByName('AXECODEIS').AsString   := GetValueAxeImp('CodeIS');
            StProc_Axe.ParamByName('AXENIVEAU').AsInteger  := StrToInt(GetValueAxeImp('NIVEAU'));
            StProc_Axe.ParamByName('AXENOM').AsString      := GetValueAxeImp('Nom');
            StProc_Axe.ParamByName('CENTRALE').AsInteger   := StrToIntDef(GetValueAxeImp('CENTRALE'), 0);
            StProc_Axe.ParamByName('LIBN1').AsString       := GetValueAxeImp('LIBN1');
            StProc_Axe.ParamByName('LIBN2').AsString       := GetValueAxeImp('LIBN2');
            StProc_Axe.ParamByName('LIBN3').AsString       := GetValueAxeImp('LIBN3');
            StProc_Axe.ParamByName('LIBN4').AsString       := GetValueAxeImp('LIBN4');
            StProc_Axe.ParamByName('ACTID').AsInteger      := iActID;
            StProc_Axe.ExecQuery;

            // récupération du nouvel ID axe
            iUniID := StProc_Axe.FieldByName('UNIID').AsInteger;
            Dm_Main.AjoutInListeAxeID(GetValueAxeImp('Code'), iUniID);

            StProc_Axe.Close;

            Dm_Main.TransacArt.Commit;
          end;
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_Axe.Close;
    Dm_Main.SaveListeAxeID;
  end;

end;

// Niveau 1 (secteur)
function TRefArticle.TraiterAxeNiveau1: boolean;
var
  iUniID: integer;
  iSecID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
begin
  Result := true;

  iMaxProgress := cds_AxeNiveau1.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "AXE_NIVEAU1.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDAxeNiv1.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_AxeNiveau1.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_AxeNiveau1[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_AxeNiveau1[i], AxeNiveau1_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheAxeNiveau1ID(GetValueAxeNiv1Imp('Code'), NbRech);

          if (LRechID=-1)
             and (GetValueAxeNiv1Imp('Code')<>'')
             and (GetValueAxeNiv1Imp('Nom')<>'') then
          begin
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            iUniID := Dm_Main.GetAxeUniID(GetValueAxeNiv1Imp('CODEAXE'));
            if iUniID<0 then
              iUniID := 0;

            StProc_AxeNiveau1.Close;
            StProc_AxeNiveau1.ParamByName('UNIID').AsInteger    := iUniID;
            StProc_AxeNiveau1.ParamByName('CODEIS').AsString    := GetValueAxeNiv1Imp('CodeIS');
            StProc_AxeNiveau1.ParamByName('NOM').AsString       := GetValueAxeNiv1Imp('Nom');
            StProc_AxeNiveau1.ParamByName('VISIBLE').AsInteger  := StrToIntDef(GetValueAxeNiv1Imp('VISIBLE'), 1);
            StProc_AxeNiveau1.ParamByName('CENTRALE').AsInteger := StrToIntDef(GetValueAxeNiv1Imp('CENTRALE'), 0);
            StProc_AxeNiveau1.ParamByName('ORDREAFF').AsDouble  := ConvertStrToFloat(GetValueAxeNiv1Imp('ORDREAFF'));
            StProc_AxeNiveau1.ParamByName('CODENIV').AsString   := GetValueAxeNiv1Imp('CODENIV');
            StProc_AxeNiveau1.ExecQuery;

            // récupération du nouvel ID Niveau 1
            iSecID := StProc_AxeNiveau1.FieldByName('SECID').AsInteger;
            Dm_Main.AjoutInListeAxeNiveau1ID(GetValueAxeNiv1Imp('Code'), iUniID, iSecID);

            StProc_AxeNiveau1.Close;

            Dm_Main.TransacArt.Commit;
          end;
        end;

        Inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_AxeNiveau1.Close;
    Dm_Main.SaveListeAxeNiveau1ID;
  end;
end;

// Niveau 2 (rayon)
function TRefArticle.TraiterAxeNiveau2: boolean;
var
  iUniID: integer;
  iSecID: integer;
  iRayID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
begin
  Result := true;

  iMaxProgress := cds_AxeNiveau2.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "AXE_NIVEAU2.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDAxeNiv2.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_AxeNiveau2.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_AxeNiveau2[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_AxeNiveau2[i], AxeNiveau2_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheAxeNiveau2ID(GetValueAxeNiv2Imp('Code'), NbRech);

          if (LRechID=-1)
             and (GetValueAxeNiv2Imp('Code')<>'')
             and (GetValueAxeNiv2Imp('Nom')<>'')
             and (GetValueAxeNiv2Imp('CODEN1')<>'') then
          begin
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            iUniID := Dm_Main.GetNiveau1UniID(GetValueAxeNiv2Imp('CODEN1'));
            if iUniID<0 then
              iUniID := 0;

            iSecID := Dm_Main.GetNiveau1SecID(GetValueAxeNiv2Imp('CODEN1'));
            if iSecID<0 then
              iSecId := 0;

            StProc_AxeNiveau2.Close;
            StProc_AxeNiveau2.ParamByName('SECID').AsInteger    := iSecID;
            StProc_AxeNiveau2.ParamByName('UNIID').AsInteger    := iUniID;
            StProc_AxeNiveau2.ParamByName('CODEIS').AsString    := GetValueAxeNiv2Imp('CodeIS');
            StProc_AxeNiveau2.ParamByName('NOM').AsString       := GetValueAxeNiv2Imp('Nom');
            StProc_AxeNiveau2.ParamByName('VISIBLE').AsInteger  := StrToIntDef(GetValueAxeNiv2Imp('VISIBLE'), 1);
            StProc_AxeNiveau2.ParamByName('CENTRALE').AsInteger := StrToIntDef(GetValueAxeNiv2Imp('CENTRALE'), 0);
            StProc_AxeNiveau2.ParamByName('ORDREAFF').AsDouble  := ConvertStrToFloat(GetValueAxeNiv2Imp('ORDREAFF'));
            StProc_AxeNiveau2.ParamByName('CODENIV').AsString   := GetValueAxeNiv2Imp('CODENIV');
            StProc_AxeNiveau2.ExecQuery;

            // récupération du nouvel ID Niveau 2
            iRayID := StProc_AxeNiveau2.FieldByName('RAYID').AsInteger;
            Dm_Main.AjoutInListeAxeNiveau2ID(GetValueAxeNiv2Imp('Code'), iUniID, iSecID, iRayID);

            StProc_AxeNiveau2.Close;

            Dm_Main.TransacArt.Commit;
          end;
        end;

        inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_AxeNiveau2.Close;
    Dm_Main.SaveListeAxeNiveau2ID;
  end;
end;

// Niveau 3 (famille)
function TRefArticle.TraiterAxeNiveau3: boolean;
var
  iUniID: integer;
  iSecID: integer;
  iRayID: integer;
  iFamID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
begin
  Result := true;

  iMaxProgress := cds_AxeNiveau3.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "AXE_NIVEAU3.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDAxeNiv3.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_AxeNiveau3.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_AxeNiveau3[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_AxeNiveau3[i], AxeNiveau3_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheAxeNiveau3ID(GetValueAxeNiv3Imp('Code'), NbRech);

          if (LRechID=-1)
             and (GetValueAxeNiv3Imp('Code')<>'')
             and (GetValueAxeNiv3Imp('Nom')<>'')
             and (GetValueAxeNiv3Imp('CODEN2')<>'') then
          begin
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            iUniID := Dm_Main.GetNiveau2UniID(GetValueAxeNiv3Imp('CODEN2'));
            if iUniID<0 then
              iUniID := 0;

            iSecID := Dm_Main.GetNiveau2SecID(GetValueAxeNiv3Imp('CODEN2'));
            if iSecID<0 then
              iSecID := 0;

            iRayID :=Dm_Main. GetNiveau2RayID(GetValueAxeNiv3Imp('CODEN2'));
            if iRayID<0 then
              iRayID := 0;

            StProc_AxeNiveau3.Close;
            StProc_AxeNiveau3.ParamByName('RAYID').AsInteger    := iRayID;
            StProc_AxeNiveau3.ParamByName('NOM').AsString       := GetValueAxeNiv3Imp('Nom');
            StProc_AxeNiveau3.ParamByName('CODEIS').AsString    := GetValueAxeNiv3Imp('CodeIS');
            StProc_AxeNiveau3.ParamByName('VISIBLE').AsInteger  := StrToIntDef(GetValueAxeNiv3Imp('VISIBLE'), 1);
            StProc_AxeNiveau3.ParamByName('CENTRALE').AsInteger := StrToIntDef(GetValueAxeNiv3Imp('CENTRALE'), 0);
            StProc_AxeNiveau3.ParamByName('ORDREAFF').AsDouble  := ConvertStrToFloat(GetValueAxeNiv3Imp('ORDREAFF'));
            StProc_AxeNiveau3.ParamByName('CODENIV').AsString   := GetValueAxeNiv3Imp('CODENIV');
            StProc_AxeNiveau3.ExecQuery;

            // récupération du nouvel ID Niveau 3
            iFamID := StProc_AxeNiveau3.FieldByName('FAMID').AsInteger;
            Dm_Main.AjoutInListeAxeNiveau3ID(GetValueAxeNiv3Imp('Code'), iUniID, iSecID, iRayID, iFamID);

            StProc_AxeNiveau3.Close;

            Dm_Main.TransacArt.Commit;
          end;
        end;

        inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_AxeNiveau3.Close;
    Dm_Main.SaveListeAxeNiveau3ID;
  end;
end;

// Niveau 4 (S/famille)
function TRefArticle.TraiterAxeNiveau4: boolean;
var
  iUniID: integer;
  iSecID: integer;
  iRayID: integer;
  iFamID: integer;
  iSsfID: integer;
  iTvaID: integer;
  iTctID: integer;  // type comptable
  iTctCode: integer;
  iTctIDProduit: integer;
  iTctIDService: integer;
  cds_tva: TClientDataSet;
  vTva: Double;
  Que_Tva: TIBQuery;
  Que_Tct: TIBQuery;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  Que_Tmp: TIBQuery;
begin
  Result := true;

  iMaxProgress := cds_AxeNiveau4.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "AXE_NIVEAU4.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDAxeNiv4.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID

  Que_Tct := TIBQuery.Create(nil);
  Que_Tva := TIBQuery.Create(nil); 
  cds_tva := TClientDataSet.Create(nil);
  try
    i := 1;
    try
      // recherche ID Type comptable pour PRODUIT et SERVICE
      Que_Tct.Database := dm_Main.Database;
      with Que_Tct.SQL do
      begin
        Clear;
        Add('select * from ARTTYPECOMPTABLE');
        Add('  join k on k_id=tct_id and k_enabled=1');
        Add(' where (tct_code=1) or (tct_code=2)');
      end;
      Que_Tct.Open;

      iTctIDProduit := 0;
      iTctIDService := 0;

      // produit
      iTctCode := 1;
      if Que_Tct.Locate('TCT_CODE', iTctCode, []) then
        iTctIDProduit := Que_Tct.FieldByName('TCT_ID').AsInteger;

      // service
      iTctCode := 2;
      if Que_Tct.Locate('TCT_CODE', iTctCode, []) then
        iTctIDService := Que_Tct.FieldByName('TCT_ID').AsInteger;

      Que_Tct.Close;

      // table tva
      cds_tva.FieldDefs.Add('TVA_ID',ftInteger,0);
      cds_tva.FieldDefs.Add('TVA_TAUX',ftFloat,0);
      cds_tva.CreateDataSet;
      cds_tva.LogChanges := False;
      cds_tva.Open;
      
      Que_Tva.Database := dm_Main.Database;
      with Que_Tva.SQL do
      begin
        Clear;
        Add('select * from arttva');
        Add('  join k on k_id=tva_id and k_enabled=1');
        Add(' where tva_id<>0');
      end;
      Que_Tva.Open;
      Que_Tva.First;
      while not(Que_Tva.Eof) do
      begin
        cds_tva.Append;
        cds_tva.FieldByName('TVA_ID').AsInteger := Que_Tva.FieldByName('TVA_ID').AsInteger;
        cds_tva.FieldByName('TVA_TAUX').AsFloat := Que_Tva.FieldByName('TVA_TAUX').AsFloat;
        cds_tva.Post;
        
        Que_Tva.Next;
      end;
      Que_Tva.Close;

      NbEnre := cds_AxeNiveau4.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_AxeNiveau4[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_AxeNiveau4[i], AxeNiveau4_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheAxeNiveau4ID(GetValueAxeNiv4Imp('Code'), NbRech);

          if (LRechID=-1)
             and (GetValueAxeNiv4Imp('Code')<>'')
             and (GetValueAxeNiv4Imp('Nom')<>'')
             and (GetValueAxeNiv4Imp('CODEN3')<>'') then
          begin
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            iUniID := Dm_Main.GetNiveau3UniID(GetValueAxeNiv4Imp('CODEN3'));
            if iUniID<0 then
              iUniID := 0;

            iSecID := Dm_Main.GetNiveau3SecID(GetValueAxeNiv4Imp('CODEN3'));
            if iSecID<0 then
              iSecID := 0;

            iRayID := Dm_Main.GetNiveau3RayID(GetValueAxeNiv4Imp('CODEN3'));
            if iRayID<0 then
              iRayID := 0;

            iFamID := Dm_Main.GetNiveau3FamID(GetValueAxeNiv4Imp('CODEN3'));
            if iFamID<0 then
              iFamID := 0;

            // Recherche ID tva
            vTva := ConvertStrToFloat(GetValueAxeNiv4Imp('TVA'));
            iTvaID := 0;
            cds_tva.First;
            while (iTvaID=0) and not(cds_tva.Eof) do
            begin
              if abs(cds_tva.FieldByName('TVA_TAUX').AsFloat-vTva)<0.001 then
                iTvaID := cds_tva.FieldByName('TVA_ID').AsInteger;
              cds_tva.Next;
            end;

            //Si pas de TVA trouvé
            if (iTvaID=0) then
            begin
              if (Dm_Main.TransacArt.InTransaction) then
                Dm_Main.TransacArt.Rollback;
              Result := false;
              sError := '('+inttostr(i)+')'+#13#10+
                        'Ligne: '+LigneLecture+#13#10+
                        'Taux de TVA non trouvé dans AxeNiveau4 : ' + FloatToStr(vTva);
              Synchronize(UpdProgressFrm);
              Synchronize(ErrorFrm);

              Exit;
            end;

            // type comptable
            if UpperCase(GetValueAxeNiv4Imp('TYPECOMPTABLE'))='SERVICE' then
              iTctID := iTctIDService
            else
              iTctID := iTctIDProduit;

            StProc_AxeNiveau4.Close;
            StProc_AxeNiveau4.ParamByName('FAMID').AsInteger    := iFamID;
            StProc_AxeNiveau4.ParamByName('NOM').AsString       := GetValueAxeNiv4Imp('Nom');
            StProc_AxeNiveau4.ParamByName('CODEIS').AsString    := GetValueAxeNiv4Imp('CodeIS');
            StProc_AxeNiveau4.ParamByName('VISIBLE').AsInteger  := StrToIntDef(GetValueAxeNiv4Imp('VISIBLE'), 1);
            StProc_AxeNiveau4.ParamByName('CENTRALE').AsInteger := StrToIntDef(GetValueAxeNiv4Imp('CENTRALE'), 0);
            StProc_AxeNiveau4.ParamByName('ORDREAFF').AsDouble  := ConvertStrToFloat(GetValueAxeNiv4Imp('ORDREAFF'));
            StProc_AxeNiveau4.ParamByName('CODENIV').AsString   := GetValueAxeNiv4Imp('CODENIV');
            StProc_AxeNiveau4.ParamByName('CODEFINAL').AsString := GetValueAxeNiv4Imp('CODEFINAL');
            StProc_AxeNiveau4.ParamByName('TVAID').AsInteger    := iTvaID;
            StProc_AxeNiveau4.ParamByName('TCTID').AsInteger    := iTctID;
            StProc_AxeNiveau4.ExecQuery;

            // récupération du nouvel ID Niveau 3
            iSsfID := StProc_AxeNiveau4.FieldByName('SSFID').AsInteger;
            Dm_Main.AjoutInListeAxeNiveau4ID(GetValueAxeNiv4Imp('Code'), iUniID, iSecID, iRayID, iFamID, iSsfID);

            StProc_AxeNiveau4.Close;

            Dm_Main.TransacArt.Commit;
          end;
        end;

        inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);

      // exportation de la fedas
      if (Dm_Main.Provenance in [ipInterSys]) then
      begin
        Dm_Main.SaveListeAxeNiveau4ID;
        sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') FEDAS:';
        sEtat2 := '';
        Synchronize(UpdateFrm);
        Synchronize(InitProgressFrm);

        NbRech := Dm_Main.ListeIDGrTaille.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
        Que_Tmp := TIBQuery.Create(nil);
        try
          Que_Tmp.Database := dm_Main.Database;
          with Que_Tmp do
          begin
            SQL.Clear;
            SQL.Add('select SSF_CODEFINAL,UNI_ID, SEC_ID, RAY_ID, FAM_ID,SSF_ID from NKLSSFAMILLE');
            SQL.Add('  join k on k_id=ssf_id and k_enabled=1');
            SQL.Add('  join NKLFAMILLE on fam_id=ssf_famid');
            SQL.Add('  join NKLRAYON on ray_id=fam_rayid');
            SQL.Add('  join NKLSECTEUR on sec_id=ray_secid');
            SQL.Add('  join NKLUNIVERS on uni_id=sec_uniid');
            SQL.Add('where UPPER(UNI_CODE)='+QuotedStr('FEDAS'));
            Open;
            iMaxProgress := RecordCount;
            iProgress := 0;
            AvancePc := Round((iMaxProgress/100)*2);
            if AvancePc<=0 then
              AvancePc := 1;
            sEtat2 := '0 / '+inttostr(iMaxProgress);
            Synchronize(UpdateFrm);
            Synchronize(InitProgressFrm);

            First;
            while not(Eof) do
            begin
              LRechID := Dm_Main.RechercheAxeNiveau4ID(FieldByName('SSF_CODEFINAL').AsString, NbRech);
              if (LRechID=-1) then
              begin
                Dm_Main.AjoutInListeAxeNiveau4ID(FieldByName('SSF_CODEFINAL').AsString,
                                                 FieldByName('UNI_ID').AsInteger,
                                                 FieldByName('SEC_ID').AsInteger,
                                                 FieldByName('RAY_ID').AsInteger,
                                                 FieldByName('FAM_ID').AsInteger,
                                                 FieldByName('SSF_ID').AsInteger);
              end;
              Next;
            end;
          end;
        finally
          FreeAndNil(Que_Tmp);
        end;
      end;

    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_AxeNiveau4.Close;
    Dm_Main.SaveListeAxeNiveau4ID;
    Que_Tct.Close;
    FreeAndNil(Que_Tct);
    Que_Tva.Close;
    FreeAndNil(Que_Tva);
    FreeAndNil(cds_tva);
  end;
end;

// Collection
function TRefArticle.TraiterCollection: boolean;
var
  iColID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
begin
  Result := true;

  iMaxProgress := cds_Collection.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "COLLECTION.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDCollection.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_Collection.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Collection[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Collection[i], Collection_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheCollectionID(GetValueCollectionImp('Code'), NbRech);

          if (LRechID=-1)
             and (GetValueCollectionImp('Code')<>'')
             and (GetValueCollectionImp('Nom')<>'') then
          begin
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            StProc_Collection.Close;
            StProc_Collection.ParamByName('COLCODEIS').AsString := GetValueCollectionImp('CodeIS');
            StProc_Collection.ParamByName('COLNOM').AsString := GetValueCollectionImp('Nom');
            StProc_Collection.ParamByName('COLACTIVE').AsInteger := StrToIntDef(GetValueCollectionImp('Actif'), 1);
            StProc_Collection.ParamByName('COLCENTRALE').AsInteger := StrToIntDef(GetValueCollectionImp('Centrale'), 0);
            if ConvertStrToDate(GetValueCollectionImp('dtdeb'), 0)<>0 then
              StProc_Collection.ParamByName('COLDTDEB').AsDateTime := ConvertStrToDate(GetValueCollectionImp('dtdeb'), 0);
            if ConvertStrToDate(GetValueCollectionImp('dtfin'), 0)<>0 then
              StProc_Collection.ParamByName('COLDTFIN').AsDateTime := ConvertStrToDate(GetValueCollectionImp('dtfin'), 0);
            StProc_Collection.ExecQuery;

            // récupération du nouvel ID fournisseur
            iColID := StProc_Collection.FieldByName('COLID').AsInteger;
            Dm_Main.AjoutInListeCollectionID(GetValueCollectionImp('Code'), iColID);
            Dm_Main.AjoutInListeCollectionCodeIS(GetValueCollectionImp('CodeIS'), iColID);

            StProc_Collection.Close;

            Dm_Main.TransacArt.Commit;
          end;
        end;

        inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);

    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_Collection.Close;
    Dm_Main.SaveListeCollectionID;
    Dm_Main.SaveListeCollectionCodeIS;
  end;
end;

// Genre
function TRefArticle.TraiterGenre: boolean;
var
  iGreID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
begin
  Result := true;

  iMaxProgress := cds_Genre.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "GENRE.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDGenre.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_Genre.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Genre[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Genre[i], Genre_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheGenreID(GetValueGenreImp('Code'), NbRech);

          if (LRechID=-1)
             and (GetValueGenreImp('Code')<>'')
             and (GetValueGenreImp('Nom')<>'') then
          begin
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            StProc_Genre.Close;
            StProc_Genre.ParamByName('GRENOM').AsString := GetValueGenreImp('Nom');
            StProc_Genre.ParamByName('GRESEXE').AsInteger := StrToIntDef(GetValueGenreImp('CODESEXE'), 1);
            StProc_Genre.ExecQuery;

            // récupération du nouvel ID fournisseur
            iGreID := StProc_Genre.FieldByName('GREID').AsInteger;
            Dm_Main.AjoutInListeGenreID(GetValueGenreImp('Code'), iGreID);

            StProc_Genre.Close;

            Dm_Main.TransacArt.Commit;
          end;
        end;

        inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);

    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_Genre.Close;
    Dm_Main.SaveListeGenreID;
  end;
end;

function TRefArticle.TraiterArticle: boolean;    // Article
var
  iMrkID: integer;
  iGtfID: integer;
  iTvaID: integer;
  iActID: integer;
  iGreID: integer;
  iTctID: integer;
  iArtCentrale: integer;

  iArtID: integer;
  iArfID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;

  Que_Tva: TIBQuery;
  Que_Tct: TIBQuery;
  Que_TstFedas: TIBQuery;
  cds_tva: TClientDataSet;
  iTctCode: integer;
  iTctIDProduit: integer;
  iTctIDService: integer;
  iTctIDLocation: integer;
  iTctIDRefact: integer;
  sTypeComptable: string;
  vTva: Double;
  dCree: TDatetime;
  LstErreur: TStringList;
  bErr: boolean;
  sNom: string;
  sFedas: string;
  iChrono: Integer;
begin
  Result := true;

  iChrono := 1;

  //SR : 12/03/2014 Hack pour corriger un problème de récupération de données
  Dm_Main.CloseIBDatabase;
  if not Dm_Main.OpenIBDatabase(Dm_Main.PathBase) then
    ShowMessage('Problème de connexion à la base de données');

  iMaxProgress := cds_Article.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "ARTICLE.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDArticle.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID

  Que_Tct := TIBQuery.Create(nil);
  Que_Tva := TIBQuery.Create(nil);
  Que_TstFedas := TIBQuery.Create(nil);
  cds_tva := TClientDataSet.Create(nil);
  i := 1;
  LstErreur := TStringList.Create;
  try
    try
      // recherche ID Type comptable pour PRODUIT et SERVICE
      Que_Tct.Database := dm_Main.Database;
      with Que_Tct.SQL do
      begin
        Clear;
        Add('select * from ARTTYPECOMPTABLE');
        Add('  join k on k_id=tct_id and k_enabled=1');
        Add(' where (tct_code=1) or (tct_code=2) or (tct_code=3) or (tct_code=4)');
      end;
      Que_Tct.Open;

      iTctIDProduit := 0;
      iTctIDService := 0;
      iTctIDLocation := 0;
      iTctIDRefact := 0;

      // produit
      iTctCode := 1;
      if Que_Tct.Locate('TCT_CODE', iTctCode, []) then
        iTctIDProduit := Que_Tct.FieldByName('TCT_ID').AsInteger;

      // service
      iTctCode := 2;
      if Que_Tct.Locate('TCT_CODE', iTctCode, []) then
        iTctIDService := Que_Tct.FieldByName('TCT_ID').AsInteger;

      // Location
      iTctCode := 3;
      if Que_Tct.Locate('TCT_CODE', iTctCode, []) then
        iTctIDLocation := Que_Tct.FieldByName('TCT_ID').AsInteger;

      // Refacturation frais de port
      iTctCode :=4;
      if Que_Tct.Locate('TCT_CODE', iTctCode, []) then
        iTctIDRefact := Que_Tct.FieldByName('TCT_ID').AsInteger;

      Que_Tct.Close;

      // table tva
      cds_tva.FieldDefs.Add('TVA_ID',ftInteger,0);
      cds_tva.FieldDefs.Add('TVA_TAUX',ftFloat,0);
      cds_tva.CreateDataSet;
      cds_tva.LogChanges := False;
      cds_tva.Open;

      Que_Tva.Database := dm_Main.Database;
      with Que_Tva.SQL do
      begin
        Clear;
        Add('select * from arttva');
        Add('  join k on k_id=tva_id and k_enabled=1');
        Add(' where tva_id<>0');
      end;
      Que_Tva.Open;
      Que_Tva.First;
      while not(Que_Tva.Eof) do
      begin
        cds_tva.Append;
        cds_tva.FieldByName('TVA_ID').AsInteger := Que_Tva.FieldByName('TVA_ID').AsInteger;
        cds_tva.FieldByName('TVA_TAUX').AsFloat := Que_Tva.FieldByName('TVA_TAUX').AsFloat;
        cds_tva.Post;

        Que_Tva.Next;
      end;
      Que_Tva.Close;

      Que_TstFedas.Database := dm_Main.Database;
      with Que_TstFedas.SQL do
      begin
        Clear;
        Add('select ssf_id from nklssfamille');
        Add('  join K on K_ID=SSF_ID and K_ENABLED=1');
        Add('where ssf_id<>0 and ssf_codefinal=:ARTFEDAS');
      end;
      Que_TstFedas.ParamCheck := True;

      NbEnre := cds_Article.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Article[i]<>'' then
        begin
          // ajout ligne
          if (Dm_Main.Provenance in [ipNosymag]) then
            AjoutInfoLigne(cds_Article[i], Article_2_COL)
          else
            AjoutInfoLigne(cds_Article[i], Article_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheArticleID(GetValueArticleImp('Code'), NbRech);

          if (LRechID=-1)
             and (GetValueArticleImp('Code')<>'') then
          begin
            bErr := false;
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            if StrToIntDef(GetValueArticleImp('PSEUDO'), 0)=0 then
            begin
              iMrkID := Dm_Main.GetMrkID(UpperCase(GetValueArticleImp('CODE_MRQ')));
              if iMrkID<0 then
              begin
                iMrkID := 0;
                bErr := true;
                LstErreur.Add('Marque : "'+UpperCase(GetValueArticleImp('CODE_MRQ'))+'" non trouvé'+
                              ' pour l''article: "'+GetValueArticleImp('Code')+'"');
              end;
            end
            else
              iMrkID := 0;

            if StrToIntDef(GetValueArticleImp('PSEUDO'), 0)=0 then
            begin
              iGtfID := Dm_Main.GetGtfID(GetValueArticleImp('CODE_GT'));
              if iGtfID<0 then
              begin
                iGtfID := 0;
                begin
                  bErr := true;
                  LstErreur.Add('Taille : "'+GetValueArticleImp('CODE_GT')+'" non trouvé'+
                                ' pour l''article: "'+GetValueArticleImp('Code')+'"');
                end;
              end;
            end
            else
              iGtfID := 0;

            iActID := Dm_Main.GetActID(GetValueArticleImp('CODE_DOMAINE'));
            if iActID<0 then
                iActID := 0;

            iGreID := Dm_Main.GetGreID(GetValueArticleImp('CODE_GENRE'));
            if iGreID<0 then
              iGreID := 0;

            sNom := GetValueArticleImp('Nom');
            if (sNom='') then
            begin
              sNom := 'SANS LIBELLE';
              LstErreur.Add('Pas de Nom pour le modèle: "'+GetValueArticleImp('Code')+'", remplacement par SANS LIBELLE');
            end;

            // test fedas existante
            sFedas := Trim(GetValueArticleImp('CODEFEDAS'));
            if (sFedas<>'') then
            begin
              Que_TstFedas.Close;
              Que_TstFedas.ParamByName('ARTFEDAS').AsString := sFedas;
              Que_TstFedas.Open;
              Que_TstFedas.First;
              if Que_TstFedas.RecordCount=0 then
              begin
                bErr := true;
                LstErreur.Add('Code Fedas: "'+sFedas+'" non trouvé pour le modèle: "'+GetValueArticleImp('Code')+'"');
              end;
              Que_TstFedas.Close;
            end;

            // Recherche ID tva
            vTva := ConvertStrToFloat(GetValueArticleImp('TVA'));

            if (vTva = 0) then      //SR - 13/06/2016 - Si la TVA est à 0 on force à 20
            begin
              vTva := 20;
              LstErreur.Add('TVA de l''article "' + GetValueArticleImp('TVA')+'" est de zéro, sera forcé à 20.');
            end;

            iTvaID := 0;
            cds_tva.First;
            while (iTvaID=0) and not(cds_tva.Eof) do
            begin
              if abs(cds_tva.FieldByName('TVA_TAUX').AsFloat-vTva)<0.001 then
                iTvaID := cds_tva.FieldByName('TVA_ID').AsInteger;
              cds_tva.Next;
            end;

            //Si pas de TVA trouvé
            if (iTvaID=0) then
            begin
              if (Dm_Main.TransacArt.InTransaction) then
                Dm_Main.TransacArt.Rollback;
              Result := false;
              sError := '('+inttostr(i)+')'+#13#10+
                        'Ligne: '+LigneLecture+#13#10+
                        'Taux de TVA non trouvé dans Article : ' + FloatToStr(vTva);
              Synchronize(UpdProgressFrm);
              Synchronize(ErrorFrm);

              Exit;
            end;

            // type comptable
            sTypeComptable := UpperCase(GetValueArticleImp('TYPECOMPTABLE'));
            iTctID := 0;
            if (sTypeComptable='SERVICE') then
              iTctID := iTctIDService
            else if (sTypeComptable='PRODUIT') then
              iTctID := iTctIDProduit
            else if (sTypeComptable='LOCATION') then
              iTctID := iTctIDLocation
            else if (sTypeComptable='REFACTURATION FRAIS DE PORT') then
              iTctID := iTctIDRefact;

            if not(bErr) then
            begin
              StProc_Article.Close;
              StProc_Article.ParamByName('ARTMRKID').AsInteger := iMrkID;
              StProc_Article.ParamByName('ARTGTFID').AsInteger := iGtfID;
              StProc_Article.ParamByName('ARTNOM').AsString := sNom;
              StProc_Article.ParamByName('ARTREFMRK').AsString := GetValueArticleImp('CODE_FOURN');
              StProc_Article.ParamByName('CODEIS').AsString := GetValueArticleImp('CODEIS');
              StProc_Article.ParamByName('ARTFEDAS').AsString := GetValueArticleImp('CODEFEDAS');
              if (Dm_Main.Provenance in [ipNosymag]) then
              begin
                StProc_Article.ParamByName('ARTEXFEDAS').AsString := GetValueArticleImp('CODEEXFEDAS');
                StProc_Article.ParamByName('ARTUNI').AsString := GetValueArticleImp('CODEUNI');
                StProc_Article.ParamByName('ARTEXUNI').AsString := GetValueArticleImp('CODEEXUNI');
              end;
              StProc_Article.ParamByName('ARTDESCRIPTION').AsString := GetValueArticleImp('DESCRIPTION');
              StProc_Article.ParamByName('ICLCLASS1').AsString := GetValueArticleImp('CLASS1');
              StProc_Article.ParamByName('ICLCLASS2').AsString := GetValueArticleImp('CLASS2');
              StProc_Article.ParamByName('ICLCLASS3').AsString := GetValueArticleImp('CLASS3');
              StProc_Article.ParamByName('ICLCLASS4').AsString := GetValueArticleImp('CLASS4');
              StProc_Article.ParamByName('ICLCLASS5').AsString := GetValueArticleImp('CLASS5');
              StProc_Article.ParamByName('ICLCLASS6').AsString := GetValueArticleImp('CLASS6');
              StProc_Article.ParamByName('ARFFIDELITE').AsInteger := StrToIntDef(GetValueArticleImp('FIDELITE'), 1);

              // verru à enlever
              dCree := ConvertStrToDate(GetValueArticleImp('DATECREATION'));
              if Trunc(dCree)=0 then
                dCree := Trunc(Date)-60;
              if (Dm_Main.Provenance in [ipExotiqueISF]) then
                StProc_Article.ParamByName('ARFCREE').AsDateTime := IncDay(FloatToDateTime(Dm_Main.GetGenParamFloat(139, 3)),-1)
              else
                StProc_Article.ParamByName('ARFCREE').AsDateTime := dCree;
              StProc_Article.ParamByName('ARTCOMENT1').AsString := GetValueArticleImp('COMENT1');
              // attention, COMENT2 est une verru: c'est le chrono de l'article
              if (Dm_Main.Provenance in [ipGinkoia, ipNosymag, ipGoSport]) then
              begin
                StProc_Article.ParamByName('ARFCHRONO').AsString := GetValueArticleImp('COMENT2');
                StProc_Article.ParamByName('ARTCOMENT2').AsString := '';
              end
              else
                if (Dm_Main.Provenance in [ipExotiqueISF]) then
                begin
                  StProc_Article.ParamByName('ARFCHRONO').AsString := '99-' + IntToStr(iChrono);
                  StProc_Article.ParamByName('ARTCOMENT2').AsString := '';
                  inc(iChrono);
                end
                else
                begin
                  StProc_Article.ParamByName('ARFCHRONO').AsString := '';
                  StProc_Article.ParamByName('ARTCOMENT2').AsString := GetValueArticleImp('COMENT2');
                end;
              StProc_Article.ParamByName('ARFTVAID').AsInteger := iTvaID;
              StProc_Article.ParamByName('ARFVIRTUEL').AsInteger := StrToIntDef(GetValueArticleImp('PSEUDO'), 0);
              StProc_Article.ParamByName('ARFARCHIVER').AsInteger := StrToIntDef(GetValueArticleImp('ARCHIVER'), 0);
              StProc_Article.ParamByName('ARTACTID').AsInteger := iActID;
              case StrToIntDef(GetValueArticleImp('FLAGMODELE'), 3) of
                1: iArtCentrale := 1;
                2: iArtCentrale := 5;
                3: iArtCentrale := 0;
              else
                iArtCentrale := 0;
              end;
              StProc_Article.ParamByName('ARTCENTRALE').AsInteger := iArtCentrale;
              StProc_Article.ParamByName('ARTGREID').AsInteger := iGreID;
              StProc_Article.ParamByName('ARFTCTID').AsInteger := iTctID;
              StProc_Article.ParamByName('STKIDEAL').AsInteger := StrToIntDef(GetValueArticleImp('STKIDEAL'), 0);

              StProc_Article.ParamByName('ARTECOPART').AsString := GetValueArticleImp('ECOPART');

              if GetValueArticleImp('ECOMOB')= '' then
                StProc_Article.ParamByName('ARTECOMOB').AsCurrency := 0
              else
                StProc_Article.ParamByName('ARTECOMOB').AsCurrency := StrToCurr(GetValueArticleImp('ECOMOB'));
              StProc_Article.ExecQuery;

              // récupération du nouvel ID fournisseur
              iArtID := StProc_Article.FieldByName('ARTID').AsInteger;
              iArfID := StProc_Article.FieldByName('ARFID').AsInteger;
              Dm_Main.AjoutInListeArticleID(GetValueArticleImp('Code'), iArtID, iArfID, StrToIntDef(GetValueArticleImp('PSEUDO'), 0));

              StProc_Article.Close;
            end;

            Dm_Main.TransacArt.Commit;
          end;
        end;

        inc(i);
      end;
      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);

    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_Article.Close;
    Dm_Main.SaveListeArticleID;
    Que_Tct.Close;
    FreeAndNil(Que_Tct);
    Que_Tva.Close;
    FreeAndNil(Que_Tva);
    Que_TstFedas.Close;
    FreeAndNil(Que_TstFedas);
    FreeAndNil(cds_tva);
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_Article_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
  end;
end;

 // Article Axe (SsfID)
function TRefArticle.TraiterArticleAxe: boolean;
var
  iArtID: integer;
  iSsfID: integer;
  iActID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  LstErreur: TStringList;
  bErr: boolean;
begin
  Result := true;

  iMaxProgress := cds_ArticleAxe.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "ARTICLE_AXE.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  LstErreur := TStringList.Create;
  NbRech := Dm_Main.ListeIDArticleAxe.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_ArticleAxe.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_ArticleAxe[i]<>'' then
        begin
          bErr := false;
          // ajout ligne
          AjoutInfoLigne(cds_ArticleAxe[i], ArticleAxe_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheArtAxeID(GetValueArticleAxeImp('CODE_ART')+
                                              ';'+GetValueArticleAxeImp('CODE_N4')+
                                              ';'+GetValueArticleAxeImp('CODE_AXE'),
                                              NbRech);

          if LRechID=-1 then
          begin
            iArtID := Dm_Main.GetArtID(GetValueArticleAxeImp('CODE_ART'));
            if iArtID<=0 then
            begin
              bErr := true;
              LstErreur.Add('Code Article non trouvé: "'+GetValueArticleAxeImp('CODE_ART')+'"');
            end;
            if ((Dm_Main.Provenance in [ipExotiqueISF]) AND (GetValueArticleAxeImp('CODE_AXE') = '999')) then
            begin
              //Rapprochement ISF
              iSsfID := StrToInt(GetValueArticleAxeImp('CODE_N4'));
            end
            else
              iSsfID := Dm_Main.GetNiveau4SsfID(GetValueArticleAxeImp('CODE_N4'));

            if iSsfID<=0 then
            begin
              bErr := true;
              LstErreur.Add('SS/Famille : "'+GetValueArticleAxeImp('CODE_N4')+'" non trouvé'+
                            ' pour l''article: "'+GetValueArticleAxeImp('CODE_ART')+'"');
            end;
            iActID := Dm_Main.GetActID(GetValueArticleAxeImp('CODE_AXE'));
          end
          else
          begin
            iArtID := 0;
            iSsfID := 0;
            iActID := 0;
          end;

          if (LRechID=-1) and (iArtID>0) and (iSsfID>0) and not(bErr) then
          begin
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            StProc_ArticleAxe.Close;
            StProc_ArticleAxe.ParamByName('ARTID').AsInteger := iArtID;
            StProc_ArticleAxe.ParamByName('SSFID').AsInteger := iSsfID;
            StProc_ArticleAxe.ExecQuery;

            StProc_ArticleAxe.Close;

            Dm_Main.AjoutInListeArtAxeID(GetValueArticleAxeImp('CODE_ART')+
                                         ';'+GetValueArticleAxeImp('CODE_N4')+
                                         ';'+GetValueArticleAxeImp('CODE_AXE'));

            Dm_Main.TransacArt.Commit;
          end;
        end;

        inc(i);
      end;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_ArticleAxe.Close;
    Dm_Main.SaveListeArtAxeID;
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_ArticleAxe_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
  end;
end;

// Relation Article <--> Collection
function TRefArticle.TraiterArticleCollection : boolean;
var
  iArtID: integer;
  iColID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
  LstErreur: TStringList;
begin
  Result := true;

  iMaxProgress := cds_ArticleCollection.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "ARTICLE_COLLECTION.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  LstErreur := TStringList.Create;
  NbRech := Dm_Main.ListeIDArtCollection.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_ArticleCollection.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_ArticleCollection[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_ArticleCollection[i], ArticleCollection_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheArtCollectionID(GetValueArticleCollectionImp('CODE_ART')+
                                                      ';'+GetValueArticleCollectionImp('CODE_COLLEC'),
                                                      NbRech);

          if (LRechID=-1) then
          begin
            iArtID := Dm_Main.GetArtID(GetValueArticleCollectionImp('CODE_ART'));
            iColID := Dm_Main.GetColID(GetValueArticleCollectionImp('CODE_COLLEC'));
            if iArtID<0 then
              LstErreur.Add('Code article non trouvé: "'+GetValueArticleCollectionImp('CODE_ART')+'"');
            if iColID<0 then
              LstErreur.Add('Code collection non trouvé: "'+GetValueArticleCollectionImp('CODE_COLLEC')+'"');
          end
          else
          begin
            iArtID := 0;
            iColID := 0;
          end;

          if (LRechID=-1) and (iArtID>0) and (iColID>0) then
          begin
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            StProc_ArticleCollection.Close;
            StProc_ArticleCollection.ParamByName('ARTID').AsInteger := iArtID;
            StProc_ArticleCollection.ParamByName('COLID').AsInteger := iColID;
            StProc_ArticleCollection.ExecQuery;

            StProc_ArticleCollection.Close;

            Dm_Main.TransacArt.Commit;

            Dm_Main.AjoutInListeArtCollectionID(GetValueArticleCollectionImp('CODE_ART')+
                                                ';'+GetValueArticleCollectionImp('CODE_COLLEC'));
          end;
        end;

        inc(i);
      end;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_ArticleCollection.Close;
    Dm_Main.SaveListeArtCollectionID;
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_Article_Collection'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
  end;
end;

function TRefArticle.TraiterArtIdeal: boolean;
var
  iStiID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;

  sTmpMag   : string;
  MagCode   : String;
  iMagID    : Integer;

  iArtID    : Integer;
  iTgfID    : Integer;
  iCouID    : Integer;
begin
  Result := true;
  MagCode := '';
  iMagID  := 0;

  iMaxProgress := cds_ArtIdeal.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + ArtIdeal_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDArtIdeal.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_ArtIdeal.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_ArtIdeal[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_ArtIdeal[i], ArtIdeal_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheArtIdealID( GetValueArtIdealImp('CODE_MAG') +
                                                  GetValueArtIdealImp('CODE_ART') +
                                                  GetValueArtIdealImp('CODE_TAILLE') +
                                                  GetValueArtIdealImp('CODE_COUL') , NbRech);

          if (LRechID=-1)
             and (GetValueArtIdealImp('CODE_MAG') <> '')
             and (GetValueArtIdealImp('CODE_ART') <> '')
             and (GetValueArtIdealImp('CODE_TAILLE') <> '')
             and (GetValueArtIdealImp('CODE_COUL') <> '') then
          begin
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            // magasin
            sTmpMag := GetValueArtIdealImp('CODE_MAG');
            if sTmpMag<>MagCode then
            begin
              MagCode := sTmpMag;
              iMagID := 0;
              if cds_Magasin.Locate('MAG_CODEADH', sTmpMag, []) then
                iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
            end;
            if iMagID=0 then
              Raise Exception.Create('ArtIdeal - Magasin non trouvé pour - CODE_MAG = '+MagCode);

            iArtID := 0;
            iTgfID := 0;
            iCouID := 0;
            case Dm_Main.Provenance of
              ipGinkoia, ipNosymag, ipGoSport, ipDataMag: begin
                iArtID := Dm_Main.GetArtID(GetValueArtIdealImp('CODE_ART'));
                iTgfID := Dm_Main.GetTgfID(GetValueArtIdealImp('CODE_TAILLE'));
                iCouID := Dm_Main.GetCouID(GetValueArtIdealImp('CODE_COUL'))
              end;
              ipInterSys, ipExotiqueISF : begin
                iArtID := Dm_Main.GetArtID(GetValueArtIdealImp('CODE_ART'));
                iTgfID := Dm_Main.GetTgfID(GetValueArtIdealImp('CODE_TAILLE'));
                iCouID := Dm_Main.GetCouID(GetValueArtIdealImp('CODE_COUL')+GetValueArtIdealImp('CODE_ART'));
              end;
            end;

            //Article
            if iArtID<=0 then
              Raise Exception.Create('ArtIdeal - Article non trouvé - CODE_ART = '+GetValueArtIdealImp('CODE_ART'));

            //Taille
            if iTgfID<=0 then
              Raise Exception.Create('ArtIdeal - Taille non trouvé - CODE_TAILLE = '+GetValueArtIdealImp('CODE_TAILLE'));

            //Couleur
            if iCouID<=0 then
              Raise Exception.Create('ArtIdeal - Couleur non trouvé - CODE_COUL = '+GetValueArtIdealImp('CODE_COUL'));

            StProc_ArtIdeal.Close;
            StProc_ArtIdeal.ParamByName('MAGID').AsInteger := iMagID;
            StProc_ArtIdeal.ParamByName('ARTID').AsInteger := iArtID;
            StProc_ArtIdeal.ParamByName('TGFID').AsInteger := iTgfID;
            StProc_ArtIdeal.ParamByName('COUID').AsInteger := iCouID;
            StProc_ArtIdeal.ParamByName('QTE').AsFloat := StrToFloat(GetValueArtIdealImp('QTE'));
            StProc_ArtIdeal.ExecQuery;

            // récupération du nouvel ID fournisseur
            iStiID := StProc_ArtIdeal.FieldByName('STIID').AsInteger;
            Dm_Main.AjoutInListeArtIdealID( GetValueArtIdealImp('CODE_MAG') +
                                            GetValueArtIdealImp('CODE_ART') +
                                            GetValueArtIdealImp('CODE_TAILLE') +
                                            GetValueArtIdealImp('CODE_COUL'), iStiID);

            StProc_ArtIdeal.Close;

            Dm_Main.TransacArt.Commit;
          end;
        end;

        inc(i);
      end;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_ArtIdeal.Close;
    Dm_Main.SaveListeArtIdealID;
  end;
end;

// Relation Article <--> Taille Travaillé
//function TRefArticle.TraiterTailleTrav: boolean;
//var
//  iArtID: integer;
//  iTgfID: integer;
//  AvancePc: integer;
//  i: integer;
//  NbEnre: integer;
//
//  NbRech: integer;
//  LRechID: integer;
//begin
//  Result := true;
//
//  iMaxProgress := cds_ArticleTailleTrav.Count;
//  iProgress := 0;
//  AvancePc := Round((iMaxProgress/100)*2);
//  if AvancePc<=0 then
//    AvancePc := 1;
//  inc(iTraitement);
//  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "ARTICLE_TAILLETRAV.CSV":';
//  sEtat2 := '0 / '+inttostr(iMaxProgress);
//  Synchronize(UpdateFrm);
//  Synchronize(InitProgressFrm);
//
//  NbRech := Dm_Main.ListeIDTailleTrav.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
//  try
//    i := 1;
//    try
//      NbEnre := cds_ArticleTailleTrav.Count-1;
//      while (i<=NbEnre) do
//      begin
//        // maj de la fenetre
//        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
//        Inc(iProgress);
//        if ((iProgress mod AvancePc)=0) then
//          Synchronize(UpdProgressFrm);
//
//        if cds_ArticleTailleTrav[i]<>'' then
//        begin
//          // ajout ligne
//          AjoutInfoLigne(cds_ArticleTailleTrav[i], ArticleTailleTrav_COL);
//
//          // recherche si pas déjà importé
//          LRechID := Dm_Main.RechercheTailleTravID(GetValueArticleTailleTravImp('CODE_ART')+
//                                                   ';'+GetValueArticleTailleTravImp('CODE_GT_LIG'),
//                                                   NbRech);
//
//          if (LRechID=-1) then
//          begin
//            iArtID := Dm_Main.GetArtID(GetValueArticleTailleTravImp('CODE_ART'));
//            iTgfID := Dm_Main.GetTgfID(GetValueArticleTailleTravImp('CODE_GT_LIG'));
//          end
//          else
//          begin
//            iArtID := 0;
//            iTgfID := 0;
//          end;
//
//          if (LRechID=-1) and (iArtID>0) and (iTgfID>0) then
//          begin
//            if not(Dm_Main.TransacArt.InTransaction) then
//              Dm_Main.TransacArt.StartTransaction;
//
//            StProc_ArticleTailleTrav.Close;
//            StProc_ArticleTailleTrav.ParamByName('ARTID').AsInteger := iArtID;
//            StProc_ArticleTailleTrav.ParamByName('TGFID').AsInteger := iTgfID;
//            StProc_ArticleTailleTrav.ExecQuery;
//
//            StProc_ArticleTailleTrav.Close;
//
//            Dm_Main.AjoutInListeTailleTravID(GetValueArticleTailleTravImp('CODE_ART')+
//                                             ';'+GetValueArticleTailleTravImp('CODE_GT_LIG'));
//
//            Dm_Main.TransacArt.Commit;
//          end;
//        end;
//
//        inc(i);
//      end;
//      sEtat2 := '';
//      iProgress := 0;
//      Synchronize(UpdProgressFrm);
//
//    except
//      on E:Exception do
//      begin
//        if (Dm_Main.TransacArt.InTransaction) then
//          Dm_Main.TransacArt.Rollback;
//        Result := false;
//        sError := '('+inttostr(i)+')'+E.Message;
//        Synchronize(UpdProgressFrm);
//        Synchronize(ErrorFrm);
//      end;
//    end;
//  finally
//    StProc_ArticleTailleTrav.Close;
//    Dm_Main.SaveListeTailleTravID;
//  end;
//end;

// Couleur
function TRefArticle.TraiterCouleur: boolean;
  procedure PopulateTMPCOULEUR();
  var
    i: integer;
    NbEnre: integer;
  begin
    try
      if Dm_Main.Provenance in [ipNosymag, ipGoSport] then    //SR - 05/10/2016 - Evol du traitement pour les migrations Nosymag / Nosymag
      begin
        if not(Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.StartTransaction;

        Dm_Main.IBSql_Couleur.Close;
        Dm_Main.IBSql_Couleur.SQL.Clear;
        Dm_Main.IBSql_Couleur.SQL.Add('INSERT INTO TMPCOULEUR (TCOU_CODEART, TCOU_CODETAILLE, TCOU_CODECOUL, TCOU_EAN, TCOU_TYPE)');
        Dm_Main.IBSql_Couleur.SQL.Add('VALUES (:TCOUCODEART, :TCOUCODETAILLE, :TCOUCODECOUL, :TCOUEAN, :TCOUTYPE);');

        i := 1;

        NbEnre := cds_AllCB.Count-1;
        while (i<=NbEnre) do
        begin
          if cds_AllCB[i]<>'' then
          begin
            // ajout ligne
            AjoutInfoLigne(cds_AllCB[i], AllCB_COL);

            Dm_Main.IBSql_Couleur.ParamByName('TCOUCODEART').AsInteger := StrToInt(GetValueAllCBImp('CODE_ART'));
            Dm_Main.IBSql_Couleur.ParamByName('TCOUCODETAILLE').AsInteger := StrToInt(GetValueAllCBImp('CODE_TAILLE'));
            Dm_Main.IBSql_Couleur.ParamByName('TCOUCODECOUL').AsInteger := StrToInt(GetValueAllCBImp('CODE_COUL'));
            Dm_Main.IBSql_Couleur.ParamByName('TCOUEAN').AsString := GetValueAllCBImp('EAN');
            Dm_Main.IBSql_Couleur.ParamByName('TCOUTYPE').AsInteger := StrToInt(GetValueAllCBImp('TYPE'));
            Dm_Main.IBSql_Couleur.ExecQuery;
          end;
          inc(i);
        end;

        if Dm_Main.TransacArt.InTransaction then
        begin
          Dm_Main.TransacArt.Commit;
          Dm_Main.TransacArt.StartTransaction;
        end;
      end;
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        raise Exception.Create('PopulateTMPCOULEUR -> ' + E.Message);
      end;
    end;
  end;
var
  iCouID: Integer;
  iArtID: Integer;
  iArfID: Integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;
  sCouNomInit : string;
  sCouNom : string;
  NbRech: integer;
  LRechID: integer;
  LstErreur: TStringList;
  bNosyFind: Boolean;
  vAlreadyLoad : Boolean;
begin
  Result := true;
  vAlreadyLoad := False;

  iMaxProgress := cds_Couleur.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "COULEUR.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  LstErreur := TStringList.Create;
  NbRech := Dm_Main.ListeIDCouleur.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_Couleur.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_Couleur[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_Couleur[i], Couleur_COL);

          // recherche si pas déjà importé
          case Dm_Main.Provenance of
            ipGinkoia, ipNosymag, ipGoSport, ipDataMag :
              LRechID := Dm_Main.RechercheCouleurID(GetValueCouleurImp('COU_CODE'), NbRech);
            ipInterSys, ipExotiqueISF :
              LRechID := Dm_Main.RechercheCouleurID(GetValueCouleurImp('COU_CODE')+GetValueCouleurImp('CODE_ART'), NbRech);
          end;

          if (LRechID=-1) then
          begin
            if not vAlreadyLoad then
            begin
              PopulateTMPCOULEUR();
              vAlreadyLoad := True;
              // ajout ligne
              AjoutInfoLigne(cds_Couleur[i], Couleur_COL);
            end;

            iArtID := Dm_Main.GetArtID(GetValueCouleurImp('CODE_ART'));

            if (iArtID>0) then
            begin
              if GetValueCouleurImp('COU_CODE')<>'' then
              begin
                if Dm_Main.Provenance in [ipNosymag, ipGoSport] then    //SR - 05/10/2016 - Evol du traitement pour les migrations Nosymag / Nosymag
                begin
//                  sCouNom := GetValueCouleurImp('COU_NOM');   //SR - 06/12/2016 - Correction Init variable.
//                  Dm_Main.Que_Tmp.Close;
//                  Dm_Main.Que_Tmp.SQL.Text := 'SELECT COU_ID ' +
//                                              'FROM PLXCOULEUR ' +
//		                                          '  JOIN K ON K_ID=COU_ID AND K_ENABLED=1 ' +
//                                              'WHERE COU_ID<>0 AND COU_ARTID=:ARTID AND COU_NOM=:COUNOM '+
//		                                          'ROWS 1';
//                  Dm_Main.Que_Tmp.ParamByName('ARTID').AsInteger := iArtID;
//                  Dm_Main.Que_Tmp.ParamByName('COUNOM').AsString := sCouNom;
//                  Dm_Main.Que_Tmp.Open;

//                  bNosyFind := False;           //SR - 06/12/2016 - Correction Init variable.
//                  if Dm_Main.Que_Tmp.Eof then     //La couleur n'existe pas pour l'article. On va tester les codes barre
//                  begin
//                    iArfID := Dm_Main.GetArfID(GetValueCouleurImp('CODE_ART'));
//                    Dm_Main.Que_Tmp.Close;
//                    Dm_Main.Que_Tmp.SQL.Text := 'SELECT COU_ID, CBI_CB, COU_NOM  ' +
//                                                'FROM PLXCOULEUR ' +
//		                                            '  JOIN K ON K_ID=COU_ID AND K_ENABLED=1 ' +
//                                                '  JOIN ARTCODEBARRE ON (CBI_COUID = COU_ID) ' +
//                                                'WHERE COU_ID<>0 AND COU_ARTID=:ARTID AND CBI_ARFID = :ARFID ';
//                    Dm_Main.Que_Tmp.ParamByName('ARTID').AsInteger := iArtID;
//                    Dm_Main.Que_Tmp.ParamByName('ARFID').AsInteger := iArfID;
//                    Dm_Main.Que_Tmp.Open;
//                    Dm_Main.Que_Tmp.First;
//
//                    CodeBarre_Nosy.Filtered  := False;
//                    CodeBarre_Nosy.Filter    := 'CODE_ART = ' + QuotedStr(GetValueCouleurImp('CODE_ART')) +
//                                                ' AND CODE_COUL = ' + QuotedStr(GetValueCouleurImp('COU_CODE'));
//                    CodeBarre_Nosy.Filtered  := True;
//                    CodeBarre_Nosy.First;
//
//
//                    sCouNom := '';
//                    while not Dm_Main.Que_Tmp.Eof do
//                    begin
//
//                      if CodeBarre_Nosy.Locate('EAN',Dm_Main.Que_Tmp.FieldByName('CBI_CB').AsString,[]) then
//                      begin
//                        sCouNom := Dm_Main.Que_Tmp.FieldByName('COU_NOM').AsString;
//                        Frm_Main.AjouterLog('Match Couleur avec COU_CODE et EAN - Art_id = '+IntToStr(iArtID)+'. Cou_Nom : '+GetValueCouleurImp('COU_NOM')+' -> '+sCouNom);
//                        Dm_Main.Que_Tmp.Last;
//                        bNosyFind := True;
//                      end;
//                      Dm_Main.Que_Tmp.Next;
//                    end;
//                    if sCouNom = '' then
//                      Frm_Main.AjouterLog('Couleur non présente et pas de Match - Art_id = '+IntToStr(iArtID)+'. Cou_Nom : '+GetValueCouleurImp('COU_NOM')+' -> '+sCouNom);
//                  end
//                  else
//                    Frm_Main.AjouterLog('Couleur déjà présente et identique - Art_id = '+IntToStr(iArtID)+'. Cou_Nom : '+GetValueCouleurImp('COU_NOM')+' -> '+sCouNom);
//                end;

                  //SR 21/02:2017 - Optimisation

                  sCouNom := GetValueCouleurImp('COU_NOM');   //SR - 06/12/2016 - Correction Init variable.
                  sCouNomInit := GetValueCouleurImp('COU_NOM');
                  iArfID := Dm_Main.GetArfID(GetValueCouleurImp('CODE_ART'));

                  Dm_Main.Que_Tmp.Close;
                  Dm_Main.Que_Tmp.SQL.Text := 'SELECT CAS, NEWCOUNOM  ' +
                                              'FROM MG10_TESTCOULEUR(:ARTID, :COUNOM, :ARFID, :CODECOUL, :CODEART)';
                  Dm_Main.Que_Tmp.ParamByName('ARTID').AsInteger := iArtID;
                  Dm_Main.Que_Tmp.ParamByName('COUNOM').AsString := sCouNom;
                  Dm_Main.Que_Tmp.ParamByName('ARFID').AsInteger := iArfID;
                  Dm_Main.Que_Tmp.ParamByName('CODECOUL').AsString := GetValueCouleurImp('COU_CODE');
                  Dm_Main.Que_Tmp.ParamByName('CODEART').AsString := GetValueCouleurImp('CODE_ART');
                  Dm_Main.Que_Tmp.Open;

                  if not(Dm_Main.Que_Tmp.Eof) then
                  begin
                    sCouNom := Dm_Main.Que_Tmp.FieldByName('NEWCOUNOM').AsString;
                    case Dm_Main.Que_Tmp.FieldByName('CAS').AsInteger of
                      1 : Frm_Main.AjouterLog('Couleur déjà présente et identique - Art_id = '+IntToStr(iArtID)+'. Cou_Nom : '+ sCouNomInit +' -> '+sCouNom);
                      2 : Frm_Main.AjouterLog('Couleur non présente et pas de Match - Art_id = '+IntToStr(iArtID)+'. Cou_Nom : '+ sCouNomInit +' -> '+sCouNom);
                      3 : Frm_Main.AjouterLog('Match Couleur avec COU_CODE et EAN - Art_id = '+IntToStr(iArtID)+'. Cou_Nom : '+ sCouNomInit +' -> '+sCouNom);
                    end;
                  end
                  else
                    Frm_Main.AjouterLog('Problème dans la procédure - Art_id = '+IntToStr(iArtID));
                end;

                if not(Dm_Main.TransacArt.InTransaction) then
                  Dm_Main.TransacArt.StartTransaction;

                StProc_Couleur.Close;

                StProc_Couleur.ParamByName('ARTID').AsInteger := iArtID;
                if (Dm_Main.Provenance in [ipNosymag, ipGoSport]) then
                begin
                  if ((sCouNom <> '') AND bNosyFind) then
                    StProc_Couleur.ParamByName('COUNOM').AsString := sCouNom
                  else
                    StProc_Couleur.ParamByName('COUNOM').AsString := GetValueCouleurImp('COU_NOM');
                end
                else
                  StProc_Couleur.ParamByName('COUNOM').AsString := GetValueCouleurImp('COU_NOM');
                StProc_Couleur.ParamByName('CODEIS').AsString := GetValueCouleurImp('CodeIS');
                StProc_Couleur.ParamByName('COUCENT').AsInteger := StrToIntDef(GetValueCouleurImp('COU_CENT'), 0);
                StProc_Couleur.ParamByName('COUSMU').AsInteger := StrToIntDef(GetValueCouleurImp('COU_SMU'), 0);
                StProc_Couleur.ParamByName('COUTDSC').AsInteger := StrToIntDef(GetValueCouleurImp('COU_TDSC'), 0);
                if (Dm_Main.Provenance in [ipGinkoia]) then
                  StProc_Couleur.ParamByName('OKDEGINKOIA').AsInteger := 1
                else                                                             //ipNosymag, ipGoSport
                  StProc_Couleur.ParamByName('OKDEGINKOIA').AsInteger := 0;
                if Dm_Main.SecondImport then
                  StProc_Couleur.ParamByName('SECONDIMPORT').AsInteger := 1
                else
                  StProc_Couleur.ParamByName('SECONDIMPORT').AsInteger := 0;
                StProc_Couleur.ExecQuery;

                // récupération du nouvel ID fournisseur
                iCouID := StProc_Couleur.FieldByName('COUID').AsInteger;
                // récupération du nouveau code si second import et changement de code
                //if ((Dm_Main.SecondImport) AND (NOT Dm_Main.OkDeGinkoia)) then
                //  sCouCode := StProc_Couleur.FieldByName('COUCODE').AsString;

                case Dm_Main.Provenance of
                  ipGinkoia, ipNosymag, ipGoSport, ipDataMag :
                    Dm_Main.AjoutInListeCouleurID(GetValueCouleurImp('COU_CODE'), iCouID, iArtID);
                  ipInterSys, ipExotiqueISF :  // avec intersys le cou_code est tjrs de longueur 3
                    Dm_Main.AjoutInListeCouleurID(GetValueCouleurImp('COU_CODE')+GetValueCouleurImp('CODE_ART'), iCouID, iArtID);
                end;

                StProc_Couleur.Close;

                Dm_Main.TransacArt.Commit;
              end
              else
                LstErreur.Add('COU_CODE manquant pour l''article: "'+GetValueCouleurImp('CODE_ART')+'"');
            end
            else
              LstErreur.Add('Code article non trouvé: "'+GetValueCouleurImp('CODE_ART')+'"');
          end;
        end;

        inc(i);
      end;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_Couleur.Close;
    Dm_Main.SaveListeCouleurID;
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_Couleur_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
  end;
end;

function TRefArticle.TraiterCodeBarre: boolean;
var
  iArtID: integer;
  iArfID: integer;
  iTgfID: integer;
  iCouID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  TypeCB: integer;

  NbRech: integer;
  LRechID: integer;
  LstErreur: TStringList;

  sCodeArt,
  sCodeCoul,
  sCodeTaille,
  sEan  : string;
  iPrin : integer;
  vTryInsert : Boolean;
begin
  Result := true;

  vTryInsert := False;

  iMaxProgress := cds_CodeBarre.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100));
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "CODE_BARRE.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  LstErreur := TStringList.Create;
  NbRech := Dm_Main.ListeIDCodeBarre.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_CodeBarre.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_CodeBarre[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_CodeBarre[i], CodeBarre_COL);

          sCodeArt := GetValueCodeBarreImp('CODE_ART');
          sCodeTaille := GetValueCodeBarreImp('CODE_TAILLE');
          sCodeCoul := GetValueCodeBarreImp('CODE_COUL');
          sEan := GetValueCodeBarreImp('EAN');
          iPrin := StrToIntDef(GetValueCodeBarreImp('PRIN'), 0);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheCBID( sCodeArt + ';' +
                                            sCodeTaille + ';' +
                                            sCodeCoul + ';' +
                                            sEan, NbRech);
          if LRechID=-1 then
          begin
            iCouID := 0;

            iArtID := Dm_Main.GetArtID(sCodeArt);
            iArfID := Dm_Main.GetArfID(sCodeArt);
            iTgfID := Dm_Main.GetTgfID(sCodeTaille);
            case Dm_Main.Provenance of
              ipGinkoia, ipNosymag, ipGoSport, ipDataMag : begin
                iCouID := Dm_Main.GetCouID(sCodeCoul)
              end;
              ipInterSys, ipExotiqueISF : begin
                iCouID := Dm_Main.GetCouID(sCodeCoul+sCodeArt);
              end;
            end;

            //Article
            if (iArtID<=0) or (iArfID<=0) then
              LstErreur.Add('Code article non trouvé: "'+sCodeArt+'"');

            //Taille
            if (iTgfID<=0) then
            begin
              iTgfID := 0;
              if sCodeTaille<>'0' then
              begin
                iArtID := 0;
                LstErreur.Add('Taille non trouvé: "'+sCodeTaille+'" '+
                              'pour l''article :"'+sCodeArt+'"');
              end;
            end;

            //Couleur
            if (iCouID<=0) then
            begin
              iCouID := 0;
              if sCodeCoul<>'0' then
              begin
                iArtId := 0;
                LstErreur.Add('Couleur non trouvé: "'+sCodeCoul+'" '+
                              'pour l''article :"'+sCodeArt+'"');
              end;
            end;

            if (sEan='') then
            begin
              iArtId := 0;
              LstErreur.Add('Code EAN manquant pour l''article: "'+sCodeArt+'"');
            end;
          end
          else
          begin
            iArtID := 0;
            iArfID := 0;
            iTgfID := 0;
            iCouID := 0;
          end;

          if (LRechID=-1) and (iArtID>0) and (iArfID>0) and (iTgfID>=0) and (iCouID>=0) then
          begin
            vTryInsert := True;
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            TypeCB := StrToIntDef(GetValueCodeBarreImp('TYPE'), 1);
            if (TypeCB=0) then
              TypeCB := 3;

            StProc_CodeBarre.Close;

            StProc_CodeBarre.ParamByName('ARTID').AsInteger := iArtID;
            StProc_CodeBarre.ParamByName('ARFID').AsInteger := iArfID;
            StProc_CodeBarre.ParamByName('TGFID').AsInteger := iTgfID;
            StProc_CodeBarre.ParamByName('COUID').AsInteger := iCouID;
            StProc_CodeBarre.ParamByName('EAN').AsString := sEan;
            StProc_CodeBarre.ParamByName('TIPE').AsInteger := TypeCB;
            StProc_CodeBarre.ParamByName('PRIN').AsInteger := iPrin;
            StProc_CodeBarre.ExecQuery;

            // sauvegarde de l'ean inséré dans la base
            Dm_Main.AjoutInListeCBID( sCodeArt + ';' +
                                      sCodeTaille + ';' +
                                      sCodeCoul + ';' +
                                      sEan);

            StProc_CodeBarre.Close;

            Dm_Main.TransacArt.Commit;

            // création ean article de type 1 pour InterSys
            if (Dm_Main.Provenance in [ipInterSys, ipExotiqueISF]) then
            begin
              if not(Dm_Main.TransacArt.InTransaction) then
                Dm_Main.TransacArt.StartTransaction;

              StProc_CodeBarre2.Close;
              StProc_CodeBarre2.ParamByName('ARFID').AsInteger := iArfID;
              StProc_CodeBarre2.ParamByName('TGFID').AsInteger := iTgfID;
              StProc_CodeBarre2.ParamByName('COUID').AsInteger := iCouID;
              StProc_CodeBarre2.ExecQuery;
              StProc_CodeBarre2.Close;

              Dm_Main.TransacArt.Commit;
            end;
          end;
        end;

        inc(i);
      end;
      sEtat2 := 'Finalisation';
      iProgress := 0;
      Synchronize(UpdProgressFrm);

      if vTryInsert then
      begin
        if not(Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.StartTransaction;
        StProc_CorrigeCodeBarre.Close;
        StProc_CorrigeCodeBarre.ExecQuery;
        StProc_CorrigeCodeBarre.Close;
        Dm_Main.TransacArt.Commit;
      end;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_CodeBarre.Close;
    Dm_Main.SaveListeCBID;
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_CodeBarre_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
  end;
end;

// Prix d'achat
function TRefArticle.TraiterPrixAchat: boolean;
var
  iNoRec: integer;
  iArtID: integer;
  iTgfID: integer;
  iCouID: integer;
  iFouID: integer;
  iRuptArtID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;

  //NoUniq: integer;
  cds_Tempo: TClientDataSet;
  LstErreur: TStringList;

  sCodeArt,
  sCodeCoul,
  sCodeTaille,
  sCodeFou  : string;

  procedure EnregistrementPxAchat;
  var
    iFouIdPrincipal: integer;
    ListeFouAPb: TStringList;
    ListeASuppr: TStringList;
    //ListeBeforeCommit: TStringList;
    OkPrincipal: boolean;
    NbPxBase: integer;
    TmpCodeArt: string;
    TmpCodeFou: string;
    iRuptFouID: integer;
    OkEnre: boolean;
    iNoDeb, iNoFin: integer;
    pxCatal, PxAchat: double;
    ii: integer;
    iNoPxBase: integer;
    iTgfId: integer;
    iCouId: integer;
    iDeBase: integer;
  begin
    if cds_Tempo.RecordCount=0 then
      exit;

    iFouIdPrincipal := -1;
    ListeFouAPb := TStringList.Create; // liste des fourn non principal qui n'ont pas de prix de base
    try
      // nombre de prix d'achat de base par fournisseur (doit être = 1)
      // + test s'il il y a un fournisseur principal
      OkPrincipal := false;
      OkEnre := true;  // s'il y a au moins un enregistrement déjà enregistrer, on n'enregistre rien
      iRuptFouID := -2;
      TmpCodeArt := '';
      TmpCodeFou := '';
      NbPxBase := 0;
      cds_Tempo.First;
      while not(cds_Tempo.Eof) do
      begin
        // 1ère ligne
        if (iRuptFouID=-2) then
        begin
          iRuptFouID := cds_Tempo.FieldByName('FouID').AsInteger;
          TmpCodeArt := cds_Tempo.FieldByName('CODE_ART').AsString;
          TmpCodeFou := cds_Tempo.FieldByName('CODE_FOU').AsString;
        end;

        // Fournisseur principal ?
        if cds_Tempo.FieldByName('FouPrincipal').AsInteger = 1 then
        begin
          iFouIdPrincipal := iRuptFouID;
          OkPrincipal := true;
        end;

        // déjà enregistrer ?
        if cds_Tempo.FieldByName('RechId').AsInteger>=0 then
          OkEnre := false;

        // test s'il y a un seul prix de base
        if iRuptFouID=cds_Tempo.FieldByName('FouID').AsInteger then
        begin
          if cds_Tempo.FieldByName('PxBase').AsInteger=1 then
            Inc(NbPxBase);
        end
        else
        begin
          if NbPxBase<1 then
          begin
            if iRuptFouID=iFouIdPrincipal then
            begin
              case Dm_Main.Provenance of
                ipDataMag, ipExotiqueISF: begin
                  LstErreur.Add('Pas de prix d''achat de base pour - CODE_ART = '+TmpCodeArt+' - CODE_FOU = '+TmpCodeFou);
                end;
                else begin
                  Raise Exception.Create('Pas de prix d''achat de base pour '+#13#10+
                                         '  - CODE_ART = '+TmpCodeArt+#13#10+
                                         '  - CODE_FOU = '+TmpCodeFou);
                end;
              end;
            end
            else
            begin
              // ce fournisseur n'a pas de prix de base
              // il ne s'affiche pas dans la 11.2, donc on la supprime pour la 12.1
              ListeFouAPb.Add(inttostr(iRuptFouID));
            end;
          end;

          if NbPxBase>1 then
            Raise Exception.Create('Trop de prix d''achat de base pour '+#13#10+
                                   '  - CODE_ART = '+TmpCodeArt+#13#10+
                                   '  - CODE_FOU = '+TmpCodeFou);
          NbPxBase := 0;
          iRuptFouID := cds_Tempo.FieldByName('FouID').AsInteger;
          TmpCodeArt := cds_Tempo.FieldByName('CODE_ART').AsString;
          TmpCodeFou := cds_Tempo.FieldByName('CODE_FOU').AsString;
          if cds_Tempo.FieldByName('PxBase').AsInteger=1 then
            Inc(NbPxBase);
        end;

        cds_Tempo.Next;
      end;

      // supprime les fournisseurs non principal sans prix de base
      ListeASuppr := TStringList.Create;
      try
        cds_Tempo.First;
        while not(cds_Tempo.Eof) do
        begin
          if ListeFouAPb.IndexOf(inttostr(cds_Tempo.FieldByName('FouID').AsInteger))>0 then
            ListeASuppr.Add(inttostr(cds_Tempo.FieldByName('NoUniq').AsInteger));
          cds_Tempo.Next;
        end;
        // supprime réellement
        for ii := 1 to ListeASuppr.Count do
        begin
          if cds_Tempo.Locate('NoUniq', StrToIntDef(ListeASuppr[ii-1], -1), []) then
            cds_Tempo.Delete;
        end;
      finally
        FreeAndNil(ListeASuppr);
      end;

    finally
      FreeAndNil(ListeFouAPb);
    end;

    // met un fournisseur principal si pas trouvé (le premier possible)
    if not(OkPrincipal) then
    begin
      cds_Tempo.First;
      while not(OkPrincipal) and not(cds_Tempo.Eof) do
      begin
        if (cds_Tempo.FieldByName('TgfID').AsInteger=0)
            and (cds_Tempo.FieldByName('CouID').AsInteger=0) then
        begin
          OkPrincipal := true;
          cds_Tempo.Edit;
          cds_Tempo.FieldByName('FouPrincipal').AsInteger := 1;
          cds_Tempo.Post;
          iFouIdPrincipal := cds_Tempo.FieldByName('FouID').AsInteger;
        end;
        cds_Tempo.Next;
      end;
    end;

    if not(OkPrincipal) then
      case Dm_Main.Provenance of
        ipDataMag, ipExotiqueISF: begin
          LstErreur.Add('Il faut au moins un fournisseur principal pour l''article: '+TmpCodeArt);
        end;
        else begin
          raise Exception.Create('Il faut au moins un fournisseur principal pour l''article: '+TmpCodeArt);
        end;
      end;

    // dejà engistré
    if not(OkEnre) then
      exit;

    // supprime les enre = au prix de base
    ListeASuppr := TStringList.Create;
    try
      iRuptFouID := -2;
      iNoDeb := 0;
      iNoFin := 0;
      pxCatal := 0.0;
      PxAchat := 0.0;
      cds_Tempo.First;
      while not(cds_Tempo.Eof) do
      begin
        // 1ère ligne
        if (iRuptFouID=-2) then
        begin
          iRuptFouID := cds_Tempo.FieldByName('FouID').AsInteger;
          iNoDeb := cds_Tempo.FieldByName('NoUniq').AsInteger;
          iNoFin := cds_Tempo.FieldByName('NoUniq').AsInteger;
          pxCatal := cds_Tempo.FieldByName('PxCatalog').AsFloat;
          PxAchat := cds_Tempo.FieldByName('PxAchat').AsFloat;
        end;

        // test s'il faut supprimer les lignes = au prix de base
        if iRuptFouID=cds_Tempo.FieldByName('FouID').AsInteger then
        begin
          iNoFin := cds_Tempo.FieldByName('NoUniq').AsInteger;
          if (iNoDeb<>iNoFin)
               and (Abs(PxCatal-cds_Tempo.FieldByName('PxCatalog').AsFloat)<0.01)
               and (Abs(PxAchat-cds_Tempo.FieldByName('PxAchat').AsFloat)<0.01) then
            ListeASuppr.Add(inttostr(cds_Tempo.FieldByName('NoUniq').AsInteger));
        end
        else
        begin
          iRuptFouID := cds_Tempo.FieldByName('FouID').AsInteger;
          iNoDeb := cds_Tempo.FieldByName('NoUniq').AsInteger;
          iNoFin := cds_Tempo.FieldByName('NoUniq').AsInteger;
          pxCatal := cds_Tempo.FieldByName('PxCatalog').AsFloat;
          PxAchat := cds_Tempo.FieldByName('PxAchat').AsFloat;
        end;

        cds_Tempo.Next;
      end;

      // supprime réellement
      for ii := 1 to ListeASuppr.Count do
      begin
        if cds_Tempo.Locate('NoUniq', StrToIntDef(ListeASuppr[ii-1], -1), []) then
          cds_Tempo.Delete;
      end;
    finally
      FreeAndNil(ListeASuppr);
    end;

    // test le prix de base
    iNoPxBase := 0;  // recherche du prix de base du fournisseur principale
    iTgfId := 0;
    iCouId := 0;
    iDeBase := 1;
    cds_Tempo.First;
    if (cds_Tempo.Locate('FOUID;TGFID;COUID', VarArrayOf([iFouIdPrincipal, iTgfId, iCouId]), [])) then
    begin
      // ça doit être le prix de base avec  TgfId et CouId à 0 et les autres pas le prix de base
      iNoPxBase := cds_Tempo.FieldByName('NoUniq').AsInteger;
      cds_Tempo.Edit;
      cds_Tempo.FieldByName('PxBase').AsInteger := 1;
      cds_Tempo.Post;
    end
    else
    begin
      cds_Tempo.First;
       // je met le prix de base sur le premier que je trouve
      if (cds_Tempo.Locate('FOUID;PxBase', VarArrayOf([iFouIdPrincipal, iDeBase]), [])) then
        iNoPxBase := cds_Tempo.FieldByName('NoUniq').AsInteger
      else
      begin
        if (cds_Tempo.Locate('FOUID', iFouIdPrincipal, [])) then
          iNoPxBase := cds_Tempo.FieldByName('NoUniq').AsInteger
      end;
    end;
    // met tous les autres à non prix de base
    cds_Tempo.First;
    while not(cds_Tempo.Eof) do
    begin
      if (iNoPxBase<>cds_Tempo.FieldByName('NoUniq').AsInteger)
           and (cds_Tempo.FieldByName('FOUID').AsInteger=iFouIdPrincipal) then
      begin
        cds_Tempo.Edit;
        cds_Tempo.FieldByName('PxBase').AsInteger := 0;
        cds_Tempo.Post;
      end;
      cds_Tempo.Next;
    end;

    // enregistrement
    //ListeBeforeCommit := TStringList.Create;
//    try
    if not(Dm_Main.TransacArt.InTransaction) then
      Dm_Main.TransacArt.StartTransaction;

    cds_Tempo.First;
    while not(cds_Tempo.Eof) do
    begin
      StProc_PrixAchat.Close;
      StProc_PrixAchat.ParamByName('ARTID').AsInteger := cds_Tempo.FieldByName('ArtID').AsInteger;
      StProc_PrixAchat.ParamByName('TGFID').AsInteger := cds_Tempo.FieldByName('TgfID').AsInteger;
      StProc_PrixAchat.ParamByName('COUID').AsInteger := cds_Tempo.FieldByName('CouID').AsInteger;
      StProc_PrixAchat.ParamByName('FOUID').AsInteger := cds_Tempo.FieldByName('FouID').AsInteger;
      StProc_PrixAchat.ParamByName('PXCATAL').AsDouble := ArrondiA2(cds_Tempo.FieldByName('PxCatalog').AsFloat);
      StProc_PrixAchat.ParamByName('PXACHAT').AsDouble := ArrondiA2(cds_Tempo.FieldByName('PxAchat').AsFloat);
      StProc_PrixAchat.ParamByName('FOUPRINCIPAL').AsInteger := cds_Tempo.FieldByName('FouPrincipal').AsInteger;

      if (cds_Tempo.FieldByName('FouPrincipal').AsInteger=1)
           and (cds_Tempo.FieldByName('TgfID').AsInteger=0)
           and (cds_Tempo.FieldByName('CouID').AsInteger=0) then
        StProc_PrixAchat.ParamByName('PXDEBASE').AsInteger := 1
      else
        StProc_PrixAchat.ParamByName('PXDEBASE').AsInteger := 0;

      StProc_PrixAchat.ExecQuery;
      StProc_PrixAchat.Close;

//        Dm_Main.AjoutInListePrixAchatID(ListeBeforeCommit,
//                                        cds_Tempo.FieldByName('ArtID').AsInteger+';'+
//                                        GetValuePrixAchatImp('CODE_TAILLE')+';'+
//                                        GetValuePrixAchatImp('CODE_COUL')+';'+
//                                        GetValuePrixAchatImp('CODE_FOU'));
    cds_Tempo.Next;
    end;
    Dm_Main.TransacArt.Commit;
      // sauvegarde pour eviter de retourner dedans
//      Dm_Main.ListeIDPrixAchat.AddStrings(ListeBeforeCommit);
//      ListeBeforeCommit.Clear;
//    finally
//      FreeAndNil(ListeBeforeCommit);
//    end;
  end;

begin
  Result := true;

  iMaxProgress := cds_PrixAchat.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100));
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "PRIX_ACHAT.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  LstErreur := TStringList.Create;
  cds_Tempo := TClientDataset.Create(nil);
  NbRech := Dm_Main.ListeIDPrixAchat.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    iRuptArtID := -2;
    // creation table tempo pour gérer le bloc ArtID, FouID
    iNoRec := 1;
    cds_Tempo.FieldDefs.Add('NoUniq',ftInteger,0);
    cds_Tempo.FieldDefs.Add('RechID',ftInteger,0);
    cds_Tempo.FieldDefs.Add('CODE_ART',ftstring,32);
    cds_Tempo.FieldDefs.Add('CODE_FOU',ftString,32);
    cds_Tempo.FieldDefs.Add('ArtID',ftInteger,0);
    cds_Tempo.FieldDefs.Add('FouID',ftInteger,0);
    cds_Tempo.FieldDefs.Add('TgfID',ftInteger,0);
    cds_Tempo.FieldDefs.Add('CouID',ftInteger,0);
    cds_Tempo.FieldDefs.Add('PxCatalog',ftFloat,0);
    cds_Tempo.FieldDefs.Add('PxAchat',ftFloat,0);
    cds_Tempo.FieldDefs.Add('FouPrincipal',ftInteger,0);
    cds_Tempo.FieldDefs.Add('PxBase',ftInteger,0);
    cds_Tempo.CreateDataSet;
    cds_Tempo.LogChanges := False;

    cds_Tempo.IndexFieldNames := 'ArtID;FouID';

    cds_Tempo.Open;
    cds_Tempo.EmptyDataSet;

    i := 1;
    try
      NbEnre := cds_PrixAchat.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_PrixAchat[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_PrixAchat[i], Prix_Achat_COL);

          sCodeArt := GetValuePrixAchatImp('CODE_ART');
          sCodeTaille := GetValuePrixAchatImp('CODE_TAILLE');
          sCodeCoul := GetValuePrixAchatImp('CODE_COUL');
          sCodeFou := GetValuePrixAchatImp('CODE_FOU');

          // recherche si pas déjà importé
          LRechID := Dm_Main.RecherchePrixAchatID(sCodeArt+';'+
                                                  sCodeTaille+';'+
                                                  sCodeCoul+';'+
                                                  sCodeFou,
                                                  NbRech);

          iArtID := 0;
          iTgfID := 0;
          iCouID := 0;
          case Dm_Main.Provenance of
            ipGinkoia, ipNosymag, ipGoSport, ipDataMag: begin
              iArtID := Dm_Main.GetArtID(sCodeArt);
              iTgfID := Dm_Main.GetTgfID(sCodeTaille);
              iCouID := Dm_Main.GetCouID(sCodeCoul)
            end;
            ipInterSys, ipExotiqueISF : begin
              iArtID := Dm_Main.GetArtID(sCodeArt);
              iTgfID := Dm_Main.GetTgfID(sCodeTaille);
              iCouID := Dm_Main.GetCouID(sCodeCoul+sCodeArt);
            end;
          end;

          //Article
          if iArtID<0 then
            iArtID := 0;
          if iArtID=0 then
            LstErreur.Add('Code article non trouvé: "'+sCodeArt+'"');

          //Taille
          if iTgfID<=0 then
          begin
            iTgfID := 0;
            if sCodeTaille<>'0' then
            begin
              iArtID := 0;
              LstErreur.Add('Taille non trouvé: "'+sCodeTaille+'" '+
                            'pour l''article :"'+sCodeArt+'"');
            end;
          end;

          //Couleur
          if iCouID<=0then
          begin
            iCouID := 0;
            if sCodeCoul<>'0' then
            begin
              iArtId := 0;
              LstErreur.Add('Couleur non trouvé: "'+sCodeCoul+'" '+
                            'pour l''article :"'+sCodeArt+'"');
            end;
          end;

          iFouID := Dm_Main.GetFouID(sCodeFou);
          if iFouID=0 then
            LstErreur.Add('Code fournisseur non trouvé: "'+sCodeFou+'" '+
                          'pour l''article: "'+sCodeArt+'"');

          if (iArtID>0) and (iTgfID>=0) and (iCouID>=0) and (iFouID>0) then
          begin
            // 1ère ligne
            if iRuptArtID=-2 then
              iRuptArtID := iArtID;

            if (iRuptArtID=iArtId) then
            begin
              // ajout dans la table temporaire
              if cds_Tempo.Locate('FouID;ArtID;TgfID;CouID', VarArrayOf([iFouID, iArtID, iTgfID, iCouID]), []) then
              begin
                if StrToIntDef(GetValuePrixAchatImp('FOU_PRINCIPAL'), 0)=1 then
                begin
                  cds_Tempo.Edit;
                  cds_Tempo.FieldByName('FouPrincipal').AsInteger := 1;
                  cds_Tempo.Post;
                end;
              end
              else
              begin
                cds_Tempo.Append;
                cds_Tempo.FieldByName('NoUniq').AsInteger := iNoRec;
                cds_Tempo.FieldByName('RechID').AsInteger := LRechID;
                cds_Tempo.FieldByName('CODE_ART').AsString := sCodeArt;
                cds_Tempo.FieldByName('CODE_FOU').AsString := sCodeFou;
                cds_Tempo.FieldByName('ArtID').AsInteger := iArtId;
                cds_Tempo.FieldByName('FouID').AsInteger := iFouID;
                cds_Tempo.FieldByName('TgfID').AsInteger := iTgfID;
                cds_Tempo.FieldByName('CouID').AsInteger := iCouID;
                cds_Tempo.FieldByName('PxCatalog').AsFloat := ArrondiA2(ConvertStrToFloat(GetValuePrixAchatImp('PXCATALOGUE')));
                cds_Tempo.FieldByName('PxAchat').AsFloat := ArrondiA2(ConvertStrToFloat(GetValuePrixAchatImp('PX_ACHAT')));
                cds_Tempo.FieldByName('FouPrincipal').AsInteger := StrToIntDef(GetValuePrixAchatImp('FOU_PRINCIPAL'), 0);
                cds_Tempo.FieldByName('PxBase').AsInteger := StrToIntDef(GetValuePrixAchatImp('PXDEBASE'), 0);
                cds_Tempo.Post;

                Dm_Main.AjoutInListePrixAchatID(sCodeArt+';'+
                                                sCodeTaille+';'+
                                                sCodeCoul+';'+
                                                sCodeFou);

                inc(iNoRec);
              end;
            end
            else
            begin
              // enregistrement
              if iRuptArtID<>2 then
                EnregistrementPxAchat;
              iRuptArtID := iArtId;
              cds_Tempo.EmptyDataSet;
              iNoRec := 1;
              // ajout dans la table temporaire
              cds_Tempo.Append;
              cds_Tempo.FieldByName('NoUniq').AsInteger := iNoRec;
              cds_Tempo.FieldByName('RechID').AsInteger := LRechID;
              cds_Tempo.FieldByName('CODE_ART').AsString := sCodeArt;
              cds_Tempo.FieldByName('CODE_FOU').AsString := sCodeFou;
              cds_Tempo.FieldByName('ArtID').AsInteger := iArtId;
              cds_Tempo.FieldByName('FouID').AsInteger := iFouID;
              cds_Tempo.FieldByName('TgfID').AsInteger := iTgfID;
              cds_Tempo.FieldByName('CouID').AsInteger := iCouID;
              cds_Tempo.FieldByName('PxCatalog').AsFloat := ArrondiA2(ConvertStrToFloat(GetValuePrixAchatImp('PXCATALOGUE')));
              cds_Tempo.FieldByName('PxAchat').AsFloat := ArrondiA2(ConvertStrToFloat(GetValuePrixAchatImp('PX_ACHAT')));
              cds_Tempo.FieldByName('FouPrincipal').AsInteger := StrToIntDef(GetValuePrixAchatImp('FOU_PRINCIPAL'), 0);
              cds_Tempo.FieldByName('PxBase').AsInteger := StrToIntDef(GetValuePrixAchatImp('PXDEBASE'), 0);
              cds_Tempo.Post;

              Dm_Main.AjoutInListePrixAchatID(sCodeArt+';'+
                                              sCodeTaille+';'+
                                              sCodeCoul+';'+
                                              sCodeFou);

              inc(iNoRec);
            end;
          end
          else
            LstErreur.Add('Informations manquante pour la ligne : "'+cds_PrixAchat[i]+'"');
        end;

        inc(i);
      end;

      // enregistrement de la fin
      if iRuptArtID<>2 then
        EnregistrementPxAchat;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_PrixAchat.Close;
    Dm_Main.SaveListePrixAchatID;
    cds_Tempo.Close;
    FreeAndNil(cds_Tempo);
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_PrixAchat_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
  end;
end;

// Prix de vente
function TRefArticle.TraiterPrixVente: boolean;
var
  iRuptArtID  : Integer;
  iNoRec      : Integer;
  iArtID      : Integer;
  iTgfID      : Integer;
  iCouID      : Integer;
  AvancePc    : Integer;
  i           : Integer;
  NbEnre      : Integer;
  NbRech      : Integer;
  LRechID     : Integer;
  NbAdd       : Integer;
  dPxVente    : Double;
  bPxVenteDif : Boolean;

  cds_Tempo   : TClientDataSet;

  LstErreur   : TStringList;

  SQL_Taille  : TIBQuery;   //Query pour récupérer toutes les Tailles d'un article.
  SQL_Couleur : TIBQuery;   //Query pour récupérer toutes les Couleurs d'un article.
  SQL_TARPRIXVENTE : TIBQuery;   //Query pour récupérer le tarif général.



  procedure EnregistrementPxVente;
  var
    ListeASuppr       : TStringList;
    ListeBeforeCommit : TStringList;

    NbPxBase          : Integer;
    ij                : Integer;
    NoUniq            : Integer;
    iTempArtId        : Integer;

    OkEnre            : Boolean;
    bOkSuite          : Boolean;

    TmpCodeArt        : string;
    NomTar            : string; //Nom du tarif de référence
    sTmpNomTar        : string;

    PxBase            : Double;
    cds_LstPxGen      : TClientDataSet;    //Liste des prix au SKU pour le tarif général
    bEOF              : Boolean;

    procedure Prix_Base_Mag_TGFCOU;
    var
      ik  : Integer;
    begin
      //SR - 28/05/2013 - Correction des Tarif de vente
      //Lorsque l'on a tout les prix à la taille et couleur on prend le
      //premier et on le passe en tarif de base du magasin.
      cds_LstPxGen := TClientDataset.Create(nil);
      try
        cds_LstPxGen.FieldDefs.Add('ArtID',ftInteger,0);
        cds_LstPxGen.FieldDefs.Add('CouID',ftInteger,0);
        cds_LstPxGen.FieldDefs.Add('NomTar',ftString,64);
        cds_LstPxGen.FieldDefs.Add('PxVente',ftFloat,0);
        cds_LstPxGen.CreateDataSet;
        cds_LstPxGen.LogChanges := False;
        cds_LstPxGen.IndexFieldNames := 'ArtID';

        cds_Tempo.First;
        SQL_Taille.Close;
        SQL_Taille.ParamByName('artid').AsInteger := cds_Tempo.FieldByName('ArtID').AsInteger;
        SQL_Taille.Open;
        SQL_Taille.FetchAll;

        SQL_Couleur.Close;
        SQL_Couleur.ParamByName('artid').asInteger := cds_Tempo.FieldByName('ArtID').AsInteger;
        SQL_Couleur.Open;
        SQL_Couleur.FetchAll;

        while (Not cds_tempo.eof) do
        begin
          NbAdd       := 0;
          sTmpNomTar  := cds_Tempo.FieldByName('NomTar').AsString;
          bPxVenteDif := False;
          dPxVente    := cds_Tempo.FieldByName('PxVente').AsFloat;
          while ((Not cds_tempo.eof) and (cds_Tempo.FieldByName('NomTar').AsString = sTmpNomTar)) do
          begin
            if (abs(dPxVente-cds_Tempo.FieldByName('PxVente').AsFloat)>=0.005) then
              bPxVenteDif := True;

            cds_tempo.Next;
            Inc(NbAdd);
          end;

          bEOF := cds_tempo.eof;

          if ((SQL_Taille.RecordCount * SQL_Couleur.RecordCount = NbAdd) and
              (sTmpNomTar<>'GENERAL') and
              (not bPxVenteDif)) then
          begin
            cds_Tempo.Prior;

            //Ajout de la ligne dans les listes des prix SKU du même tarif
            cds_LstPxGen.Append;
            cds_LstPxGen.FieldByName('ArtID').AsInteger := cds_Tempo.FieldByName('ArtID').AsInteger;
            cds_LstPxGen.FieldByName('CouID').AsInteger := cds_Tempo.FieldByName('CouID').AsInteger;
            cds_LstPxGen.FieldByName('NomTar').AsString := cds_Tempo.FieldByName('NomTar').AsString;
            cds_LstPxGen.FieldByName('PxVente').AsFloat := cds_Tempo.FieldByName('PxVente').AsFloat;
            cds_LstPxGen.Post;

            cds_Tempo.Next;

            if bEOF then
              while (Not cds_tempo.eof) do
                cds_Tempo.Next;
          end;
        end;

        SQL_Taille.Close;
        SQL_Couleur.Close;

        //Création des lignes SKU du tarif général
        cds_LstPxGen.First;
        while Not cds_LstPxGen.eof do
        begin
          cds_Tempo.Append;
          cds_Tempo.FieldByName('NoUniq').AsInteger  := 0;
          cds_Tempo.FieldByName('RechID').AsInteger  := -1;
          cds_Tempo.FieldByName('CODE_ART').AsString := TmpCodeArt;
          cds_Tempo.FieldByName('NomTar').AsString   := cds_LstPxGen.FieldByName('NomTar').AsString;
          cds_Tempo.FieldByName('ArtID').AsInteger   := cds_LstPxGen.FieldByName('ArtID').AsInteger;
          cds_Tempo.FieldByName('TgfID').AsInteger   := 0;
          cds_Tempo.FieldByName('CouID').AsInteger   := 0;
          cds_Tempo.FieldByName('PxVente').AsFloat   := ArrondiA2(cds_LstPxGen.FieldByName('PxVente').AsFloat);
          cds_Tempo.FieldByName('PxBase').AsInteger  := 0;
          cds_Tempo.Post;
          cds_LstPxGen.Next;
        end;

        //Nettoyage des prix SKU identique dans les autres tarifs
        ListeASuppr.Clear;
        cds_LstPxGen.First;
        while Not cds_LstPxGen.eof do
        begin
          cds_Tempo.First;
          while not(cds_Tempo.Eof) do
          begin
            if (cds_Tempo.FieldByName('NoUniq').AsInteger<>0) and
               (cds_LstPxGen.FieldByName('NomTar').AsString=cds_Tempo.FieldByName('NomTar').AsString) and
               (cds_LstPxGen.FieldByName('ArtID').AsInteger=cds_Tempo.FieldByName('ArtID').AsInteger) then
            begin
              if (abs(cds_LstPxGen.FieldByName('PxVente').AsFloat-cds_Tempo.FieldByName('PxVente').AsFloat)<=0.005) then
                ListeASuppr.Add(inttostr(cds_Tempo.FieldByName('NoUniq').AsInteger))
            end;
            cds_Tempo.Next;
          end;
          cds_LstPxGen.Next;
        end;
        // suppression des px identiques - 2ème partie
        for ik := 1 to ListeASuppr.Count do
        begin
          NoUniq := StrToIntDef(ListeASuppr[ik-1], 0);
          if cds_Tempo.Locate('NoUniq', NoUniq, []) then
            cds_Tempo.Delete;
        end;
      finally
        FreeAndNil(cds_LstPxGen);
      end;
      //SR - 28/05/2013 - Fin de correction des Tarif de vente
    end;

  begin
    if cds_Tempo.RecordCount=0 then
      exit;

    OkEnre := true;  // s'il y a au moins un enregistrement déjà enregistrer, on n'enregistre rien

    if Dm_Main.SecondImport then    //SR 06-12-2013 : S'il s'agit de l'import d'un autre magasin
    begin
      cds_Tempo.First;

      ListeASuppr := TStringList.Create;  // pour supprimer les px identique
      try
        //Pour un tarif général.
        SQL_TARPRIXVENTE.Close;
        SQL_TARPRIXVENTE.ParamByName('ARTID').AsInteger := cds_Tempo.FieldByName('ARTID').AsInteger;
        SQL_TARPRIXVENTE.ParamByName('TGFID').AsInteger := 0;
        SQL_TARPRIXVENTE.ParamByName('COUID').AsInteger := 0;
        SQL_TARPRIXVENTE.ParamByName('TARNOM').AsString := 'GENERAL'; //cds_Tempo.FieldByName('NomTar').AsString;
        SQL_TARPRIXVENTE.Open;

        if SQL_TARPRIXVENTE.Eof then   //Si pas de tarif général. Je considère la 1ère ligne comme tarif général.
        begin
          if not(Dm_Main.TransacArt.InTransaction) then
            Dm_Main.TransacArt.StartTransaction;

          PxBase     := cds_Tempo.FieldByName('PxVente').AsFloat;
          iTempArtId := cds_Tempo.FieldByName('ArtID').AsInteger;

          StProc_PrixVente.Close;
          StProc_PrixVente.ParamByName('NOMTAR').AsString := 'GENERAL'; //cds_Tempo.FieldByName('NomTar').AsString;
          StProc_PrixVente.ParamByName('ARTID').AsInteger := iTempArtId;
          StProc_PrixVente.ParamByName('TGFID').AsInteger := 0;
          StProc_PrixVente.ParamByName('COUID').AsInteger := 0;
          StProc_PrixVente.ParamByName('PRIXVENTE').AsDouble := ArrondiA2(PxBase);
          StProc_PrixVente.ParamByName('PXDEBASE').AsInteger := 1;
          StProc_PrixVente.ExecQuery;
          StProc_PrixVente.Close;

          Dm_Main.TransacArt.Commit;
        end;

        while not(cds_Tempo.Eof) do
        begin
          //Pour un tarif général.
          SQL_TARPRIXVENTE.Close;
          SQL_TARPRIXVENTE.ParamByName('ARTID').AsInteger := cds_Tempo.FieldByName('ARTID').AsInteger;
          SQL_TARPRIXVENTE.ParamByName('TGFID').AsInteger := 0;
          SQL_TARPRIXVENTE.ParamByName('COUID').AsInteger := 0;
          SQL_TARPRIXVENTE.ParamByName('TARNOM').AsString := 'GENERAL'; //cds_Tempo.FieldByName('NomTar').AsString;
          SQL_TARPRIXVENTE.Open;

          if not(SQL_TARPRIXVENTE.Eof) AND
            (abs(SQL_TARPRIXVENTE.FieldByName('PVT_PX').AsFloat-cds_Tempo.FieldByName('PxVente').AsFloat)<=0.005) then
            //Si le prix général est trouvé et qu'il est égale on supprime la ligne
          begin
            ListeASuppr.Add(inttostr(cds_Tempo.FieldByName('NoUniq').AsInteger));
          end
          else
          begin
            //Pour un tarif général taille couleur.
            SQL_TARPRIXVENTE.Close;
            SQL_TARPRIXVENTE.ParamByName('ARTID').AsInteger := cds_Tempo.FieldByName('ARTID').AsInteger;
            SQL_TARPRIXVENTE.ParamByName('TGFID').AsInteger := cds_Tempo.FieldByName('TgfID').AsInteger;
            SQL_TARPRIXVENTE.ParamByName('COUID').AsInteger := cds_Tempo.FieldByName('CouID').AsInteger;
            SQL_TARPRIXVENTE.ParamByName('TARNOM').AsString := cds_Tempo.FieldByName('NomTar').AsString;
            SQL_TARPRIXVENTE.Open;

            if not(SQL_TARPRIXVENTE.Eof) AND
              (abs(SQL_TARPRIXVENTE.FieldByName('PVT_PX').AsFloat-cds_Tempo.FieldByName('PxVente').AsFloat)<=0.005) then
              //Si le prix général est trouvé et qu'il est égale on supprime la ligne
            begin
              ListeASuppr.Add(inttostr(cds_Tempo.FieldByName('NoUniq').AsInteger));
            end;
          end;

          cds_Tempo.Next;
        end;

        // suppression des px identiques - 1ere partie
        for ij := 1 to ListeASuppr.Count do
        begin
          NoUniq := StrToIntDef(ListeASuppr[ij-1], 0);
          if cds_Tempo.Locate('NoUniq', NoUniq, []) then
            cds_Tempo.Delete;
        end;
        ListeASuppr.Clear;

        Prix_Base_Mag_TGFCOU;

      finally
        FreeAndNil(ListeASuppr);
      end;
    end
    else
    begin

      // nombre de prix d'achat de base par fournisseur (doit être = 1)
      // + test s'il il y a un fournisseur principal
      TmpCodeArt := cds_Tempo.FieldByName('CODE_ART').AsString;
      NbPxBase := 0;
      cds_Tempo.First;
      while not(cds_Tempo.Eof) do
      begin
        // test s'il y a un seul tarif de base
        if cds_Tempo.FieldByName('PxBase').AsInteger=1 then
          Inc(NbPxBase);

        // déjà enregistrer ?
        if cds_Tempo.FieldByName('RechId').AsInteger>=0 then
          OkEnre := false;

        cds_Tempo.Next;
      end;


      if NbPxBase<=0 then
      begin
        // je considère la 1ère ligne comme prix de base
        cds_Tempo.First;
        NomTar     := cds_Tempo.FieldByName('NomTar').AsString;  //Servira de tarif de référence
        PxBase     := cds_Tempo.FieldByName('PxVente').AsFloat;
        iTempArtId := cds_Tempo.FieldByName('ArtID').AsInteger;
        cds_Tempo.Append;
        cds_Tempo.FieldByName('NoUniq').AsInteger := 0;
        cds_Tempo.FieldByName('RechID').AsInteger := -1;
        cds_Tempo.FieldByName('CODE_ART').AsString := TmpCodeArt;
        cds_Tempo.FieldByName('NomTar').AsString := 'GENERAL';
        cds_Tempo.FieldByName('ArtID').AsInteger := iTempArtId;
        cds_Tempo.FieldByName('TgfID').AsInteger := 0;
        cds_Tempo.FieldByName('CouID').AsInteger := 0;
        cds_Tempo.FieldByName('PxVente').AsFloat := ArrondiA2(PxBase);
        cds_Tempo.FieldByName('PxBase').AsInteger := 1;
        cds_Tempo.Post;

        if (Dm_Main.Provenance in [ipInterSys, ipDataMag, ipExotiqueISF]) then
        begin
          ListeASuppr := TStringList.Create;  // pour supprimer les px identique
          try
            bOkSuite := true;
            cds_Tempo.First;

            while not(cds_Tempo.Eof) do
            begin
              if (cds_Tempo.FieldByName('NoUniq').AsInteger<>0)
                  and (cds_Tempo.FieldByName('TgfID').AsInteger=0)
                  and (cds_Tempo.FieldByName('CouID').AsInteger=0) then
              begin
                if (abs(PxBase-cds_Tempo.FieldByName('PxVente').AsFloat)<=0.005) then
                  ListeASuppr.Add(inttostr(cds_Tempo.FieldByName('NoUniq').AsInteger))
                else
                  bOkSuite := false;
              end;
              cds_Tempo.Next;
            end;

            if bOkSuite then
            begin
              // suppression des px identiques - 1ere partie
              for ij := 1 to ListeASuppr.Count do
              begin
                NoUniq := StrToIntDef(ListeASuppr[ij-1], 0);
                if cds_Tempo.Locate('NoUniq', NoUniq, []) then
                  cds_Tempo.Delete;
              end;
              ListeASuppr.Clear;

              cds_Tempo.First;
              while not(cds_Tempo.Eof) do
              begin
                if (cds_Tempo.FieldByName('NoUniq').AsInteger<>0) then
                begin
                  if (abs(PxBase-cds_Tempo.FieldByName('PxVente').AsFloat)<=0.005) then
                    ListeASuppr.Add(inttostr(cds_Tempo.FieldByName('NoUniq').AsInteger))
                end;
                cds_Tempo.Next;
              end;
              // suppression des px identiques - 2ème partie
              for ij := 1 to ListeASuppr.Count do
              begin
                NoUniq := StrToIntDef(ListeASuppr[ij-1], 0);
                if cds_Tempo.Locate('NoUniq', NoUniq, []) then
                  cds_Tempo.Delete;
              end;
            end;

            //SR LG - 11/04/2013 - Début correction des Prix - Recherche de prix au SKU sur le tarif de référence
            cds_LstPxGen := TClientDataset.Create(nil);
            try
              cds_LstPxGen.FieldDefs.Add('ArtID',ftInteger,0);
              cds_LstPxGen.FieldDefs.Add('TgfID',ftInteger,0);
              cds_LstPxGen.FieldDefs.Add('CouID',ftInteger,0);
              cds_LstPxGen.FieldDefs.Add('PxVente',ftFloat,0);
              cds_LstPxGen.CreateDataSet;
              cds_LstPxGen.LogChanges := False;
              cds_LstPxGen.IndexFieldNames := 'ArtID';

              cds_Tempo.First;
              while Not cds_tempo.eof do
              begin
                if (cds_Tempo.FieldByName('NomTar').AsString = NomTar) then
                begin
                  //Ajout de la ligne dans les listes des prix SKU du tarif général
                  cds_LstPxGen.Append;
                  cds_LstPxGen.FieldByName('ArtID').AsInteger := cds_Tempo.FieldByName('ArtID').AsInteger;
                  cds_LstPxGen.FieldByName('TgfID').AsInteger := cds_Tempo.FieldByName('TgfID').AsInteger;
                  cds_LstPxGen.FieldByName('CouID').AsInteger := cds_Tempo.FieldByName('CouID').AsInteger;
                  cds_LstPxGen.FieldByName('PxVente').AsFloat := cds_Tempo.FieldByName('PxVente').AsFloat;
                  cds_LstPxGen.Post;
                end;
                cds_tempo.Next;
              end;

              //Création des lignes SKU du tarif général
              cds_LstPxGen.First;
              while Not cds_LstPxGen.eof do
              begin
                cds_Tempo.Append;
                cds_Tempo.FieldByName('NoUniq').AsInteger  := 0;
                cds_Tempo.FieldByName('RechID').AsInteger  := -1;
                cds_Tempo.FieldByName('CODE_ART').AsString := TmpCodeArt;
                cds_Tempo.FieldByName('NomTar').AsString   := 'GENERAL';
                cds_Tempo.FieldByName('ArtID').AsInteger   := cds_LstPxGen.FieldByName('ArtID').AsInteger;
                cds_Tempo.FieldByName('TgfID').AsInteger   := cds_LstPxGen.FieldByName('TgfID').AsInteger;
                cds_Tempo.FieldByName('CouID').AsInteger   := cds_LstPxGen.FieldByName('CouID').AsInteger;
                cds_Tempo.FieldByName('PxVente').AsFloat   := ArrondiA2(cds_LstPxGen.FieldByName('PxVente').AsFloat);
                cds_Tempo.FieldByName('PxBase').AsInteger  := 0;
                cds_Tempo.Post;
                cds_LstPxGen.Next;
              end;

              //Nettoyage des prix SKU identique dans les autres tarifs
              ListeASuppr.Clear;
              cds_LstPxGen.First;
              while Not cds_LstPxGen.eof do
              begin
                cds_Tempo.First;
                while not(cds_Tempo.Eof) do
                begin
                  if (cds_Tempo.FieldByName('NoUniq').AsInteger<>0) and
                     (cds_LstPxGen.FieldByName('TgfID').AsInteger=cds_Tempo.FieldByName('TgfID').AsInteger) and
                     (cds_LstPxGen.FieldByName('CouID').AsInteger=cds_Tempo.FieldByName('CouID').AsInteger) then
                  begin
                    if (abs(cds_LstPxGen.FieldByName('PxVente').AsFloat-cds_Tempo.FieldByName('PxVente').AsFloat)<=0.005) then
                      ListeASuppr.Add(inttostr(cds_Tempo.FieldByName('NoUniq').AsInteger))
                  end;
                  cds_Tempo.Next;
                end;
                cds_LstPxGen.Next;
              end;
              // suppression des px identiques - 2ème partie
              for ij := 1 to ListeASuppr.Count do
              begin
                NoUniq := StrToIntDef(ListeASuppr[ij-1], 0);
                if cds_Tempo.Locate('NoUniq', NoUniq, []) then
                  cds_Tempo.Delete;
              end;
            finally
              FreeAndNil(cds_LstPxGen);
            end;
            //SR LG - 11/04/2013 - Fin correction des Prix

            Prix_Base_Mag_TGFCOU;   //Correction Sylvain

          finally
            FreeAndNil(ListeASuppr);
          end;
        end;
      end;
    end;

    // dejà engistré
    if not(OkEnre) then
      exit;

    // enregistrement
    ListeBeforeCommit := TStringList.Create;
    try
      if not(Dm_Main.TransacArt.InTransaction) then
        Dm_Main.TransacArt.StartTransaction;

      // basculement de tarif si paramètré
      if Dm_Main.TvtID>0 then
      begin
        StProc_PrixVente_Bascule.Close;
        StProc_PrixVente_Bascule.ParamByName('BASCULETVTID').AsInteger := Dm_Main.TvtID;
        StProc_PrixVente_Bascule.ParamByName('ARTID').AsInteger := cds_Tempo.FieldByName('ArtID').AsInteger;
        StProc_PrixVente_Bascule.ExecQuery;
        StProc_PrixVente_Bascule.Close;
      end;

      cds_Tempo.First;
      while not(cds_Tempo.Eof) do
      begin
        StProc_PrixVente.Close;

        StProc_PrixVente.ParamByName('ARTID').AsInteger := cds_Tempo.FieldByName('ArtID').AsInteger;
        StProc_PrixVente.ParamByName('TGFID').AsInteger := cds_Tempo.FieldByName('TgfID').AsInteger;
        StProc_PrixVente.ParamByName('COUID').AsInteger := cds_Tempo.FieldByName('CouID').AsInteger;
        if (cds_Tempo.FieldByName('NomTar').AsString = Dm_Main.MagCodeAdh) and (Dm_Main.MagCodeAdh<>'') then
          StProc_PrixVente.ParamByName('NOMTAR').AsString := 'GENERAL'
        else
          StProc_PrixVente.ParamByName('NOMTAR').AsString := cds_Tempo.FieldByName('NomTar').AsString;
        StProc_PrixVente.ParamByName('PRIXVENTE').AsDouble := cds_Tempo.FieldByName('PxVente').AsFloat;
        StProc_PrixVente.ParamByName('PXDEBASE').AsInteger := cds_Tempo.FieldByName('PxBase').AsInteger;

        StProc_PrixVente.ExecQuery;

        StProc_PrixVente.Close;

        Dm_Main.AjoutInListePrixVenteID(ListeBeforeCommit,
                                        GetValuePrixVenteImp('CODE_ART')+';'+
                                        GetValuePrixVenteImp('CODE_TAILLE')+';'+
                                        GetValuePrixVenteImp('CODE_COUL')+';'+
                                        GetValuePrixVenteImp('NOMTAR'));
        cds_Tempo.Next;
      end;
      Dm_Main.TransacArt.Commit;
      // sauvegarde pour eviter de retourner dedans
      Dm_Main.ListeIDPrixVente.AddStrings(ListeBeforeCommit);
      ListeBeforeCommit.Clear;
    finally
      FreeAndNil(ListeBeforeCommit);
    end;
  end;

begin
  Result := true;

  iMaxProgress := cds_PrixVente.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100));
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "PRIX_VENTE.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  LstErreur := TStringList.Create;
  cds_Tempo := TClientDataset.Create(nil);
  NbRech := Dm_Main.ListeIDPrixVente.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    SQL_Taille := TIBQuery.Create(nil);
    SQL_Taille.Database := Dm_Main.DataBase;
    SQL_Taille.Transaction := Dm_Main.TransacArt;
    SQL_Taille.ParamCheck := True;
    SQL_Taille.SQL.Clear;
    SQL_Taille.SQL.Add('Select  ttv_tgfid');
    SQL_Taille.SQL.Add('From plxtaillestrav');
    SQL_Taille.SQL.Add('  join k on k_id=ttv_id and k_enabled=1');
    SQL_Taille.SQL.Add('Where ttv_artid=:artid');
    SQL_Taille.Prepare;

    SQL_Couleur := TIBQuery.Create(nil);
    SQL_Couleur.Database := Dm_Main.DataBase;
    SQL_Couleur.Transaction := Dm_Main.TransacArt;
    SQL_Couleur.ParamCheck := True;
    SQL_Couleur.SQL.Clear;
    SQL_Couleur.SQL.Add('Select cou_id');
    SQL_Couleur.SQL.Add('From plxcouleur');
    SQL_Couleur.SQL.Add('  join k on k_id=cou_id and k_enabled=1');
    SQL_Couleur.SQL.Add('Where cou_artid=:artid');
    SQL_Couleur.Prepare;

    SQL_TARPRIXVENTE := TIBQuery.Create(nil);
    SQL_TARPRIXVENTE.Database := Dm_Main.DataBase;
    SQL_TARPRIXVENTE.Transaction := Dm_Main.TransacArt;
    SQL_TARPRIXVENTE.ParamCheck := True;
    SQL_TARPRIXVENTE.SQL.Clear;
    SQL_TARPRIXVENTE.SQL.Add('SELECT PVT_ID, PVT_PX');
    SQL_TARPRIXVENTE.SQL.Add('FROM TARPRIXVENTE');
    SQL_TARPRIXVENTE.SQL.Add('  JOIN K ON K_ID=PVT_ID AND K_ENABLED=1');
    //SQL_TARPRIXVENTE.SQL.Add('WHERE PVT_TVTID=0');        //SR - 29/12/2015 - Il s'agit d'un 2eme import il faut utiliser le nom du tarif
    SQL_TARPRIXVENTE.SQL.Add('  JOIN TARVENTE ON TVT_ID=PVT_TVTID');
    SQL_TARPRIXVENTE.SQL.Add('WHERE TVT_NOM= :TARNOM');
    SQL_TARPRIXVENTE.SQL.Add('AND PVT_ARTID = :ARTID');
    SQL_TARPRIXVENTE.SQL.Add('AND PVT_TGFID = :TGFID');
    SQL_TARPRIXVENTE.SQL.Add('AND PVT_COUID = :COUID');
    SQL_TARPRIXVENTE.Prepare;

    iRuptArtID := -2;
    // creation table tempo pour gérer le bloc ArtID, FouID
    iNoRec := 1;
    cds_Tempo.FieldDefs.Add('NoUniq',ftInteger,0);
    cds_Tempo.FieldDefs.Add('RechID',ftInteger,0);
    cds_Tempo.FieldDefs.Add('CODE_ART',ftstring,32);
    cds_Tempo.FieldDefs.Add('NomTar',ftString,64);
    cds_Tempo.FieldDefs.Add('ArtID',ftInteger,0);
    cds_Tempo.FieldDefs.Add('TgfID',ftInteger,0);
    cds_Tempo.FieldDefs.Add('CouID',ftInteger,0);
    cds_Tempo.FieldDefs.Add('PxVente',ftFloat,0);
    cds_Tempo.FieldDefs.Add('PxBase',ftInteger,0);
    cds_Tempo.CreateDataSet;
    cds_Tempo.LogChanges := False;

    cds_Tempo.IndexFieldNames := 'ArtID;NomTar';

    i := 1;
    try
      NbEnre := cds_PrixVente.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_PrixVente[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_PrixVente[i], Prix_Vente_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RecherchePrixVenteID(GetValuePrixVenteImp('CODE_ART')+';'+
                                                  GetValuePrixVenteImp('CODE_TAILLE')+';'+
                                                  GetValuePrixVenteImp('CODE_COUL')+';'+
                                                  GetValuePrixVenteImp('NOMTAR'),
                                                  NbRech);
          if LRechID=-1 then
          begin
            LRechID := Dm_Main.RecherchePrixVenteID(GetValuePrixVenteImp('CODE_ART')+';'+
                                                    '0;'+
                                                    '0;'+
                                                    Dm_Main.MagCodeAdh,
                                                    NbRech);
          end;

          iArtID := 0;
          iTgfID := 0;
          iCouID := 0;
          case Dm_Main.Provenance of
            ipGinkoia, ipNosymag, ipGoSport, ipDataMag: begin
              iArtID := Dm_Main.GetArtID(GetValuePrixVenteImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValuePrixVenteImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValuePrixVenteImp('CODE_COUL'))
            end;
            ipInterSys, ipExotiqueISF : begin
              iArtID := Dm_Main.GetArtID(GetValuePrixVenteImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValuePrixVenteImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValuePrixVenteImp('CODE_COUL')+GetValuePrixVenteImp('CODE_ART'));
            end;
          end;

          //Article
          if (iArtID<0) then
            iArtID := 0;
          if (iArtID=0) then
            LstErreur.Add('Code article non trouvé: "'+GetValuePrixVenteImp('CODE_ART')+'"');

          //Taille
          if (iTgfID<=0) then
          begin
            iTgfID := 0;
            if GetValuePrixVenteImp('CODE_TAILLE')<>'0' then
            begin
              iArtID := 0;
              LstErreur.Add('Taille non trouvé: "'+GetValuePrixVenteImp('CODE_TAILLE')+'" '+
                            'pour l''article :"'+GetValuePrixVenteImp('CODE_ART')+'"');
            end;
          end;

          //Couleur
          if (iCouID<=0) then
          begin
            iCouID := 0;
            if GetValuePrixVenteImp('CODE_COUL')<>'0' then
            begin
              iArtId := 0;
              LstErreur.Add('Couleur non trouvé: "'+GetValuePrixVenteImp('CODE_COUL')+'" '+
                            'pour l''article :"'+GetValuePrixVenteImp('CODE_ART')+'"');
            end;
          end;

          if (iArtID>0) and (iTgfID>=0) and (iCouID>=0) then
          begin
            // 1ère ligne
            if iRuptArtID=-2 then
              iRuptArtID := iArtID;

            if (iRuptArtID=iArtID) then
            begin
              // ajout dans la table temporaire
              cds_Tempo.Append;
              cds_Tempo.FieldByName('NoUniq').AsInteger := iNoRec;
              cds_Tempo.FieldByName('RechID').AsInteger := LRechID;
              cds_Tempo.FieldByName('CODE_ART').AsString := GetValuePrixVenteImp('CODE_ART');
              cds_Tempo.FieldByName('NomTar').AsString := GetValuePrixVenteImp('NOMTAR');
              cds_Tempo.FieldByName('ArtID').AsInteger := iArtId;
              cds_Tempo.FieldByName('TgfID').AsInteger := iTgfID;
              cds_Tempo.FieldByName('CouID').AsInteger := iCouID;
              cds_Tempo.FieldByName('PxVente').AsFloat := ArrondiA2(ConvertStrToFloat(GetValuePrixVenteImp('PX_VENTE')));
              cds_Tempo.FieldByName('PxBase').AsInteger := StrToIntDef(GetValuePrixVenteImp('PXDEBASE'), 0);
              cds_Tempo.Post;
              inc(iNoRec);
            end
            else
            begin
              // enregistrement
              if iRuptArtID<>-2 then
                EnregistrementPxVente;
              iRuptArtID := iArtId;
              cds_Tempo.EmptyDataSet;
              iNoRec := 1;
              // ajout dans la table temporaire
              cds_Tempo.Append;
              cds_Tempo.FieldByName('NoUniq').AsInteger := iNoRec;
              cds_Tempo.FieldByName('RechID').AsInteger := LRechID;
              cds_Tempo.FieldByName('CODE_ART').AsString := GetValuePrixVenteImp('CODE_ART');
              cds_Tempo.FieldByName('NomTar').AsString := GetValuePrixVenteImp('NOMTAR');
              cds_Tempo.FieldByName('ArtID').AsInteger := iArtId;
              cds_Tempo.FieldByName('TgfID').AsInteger := iTgfID;
              cds_Tempo.FieldByName('CouID').AsInteger := iCouID;
              cds_Tempo.FieldByName('PxVente').AsFloat := ArrondiA2(ConvertStrToFloat(GetValuePrixVenteImp('PX_VENTE')));
              cds_Tempo.FieldByName('PxBase').AsInteger := StrToIntDef(GetValuePrixVenteImp('PXDEBASE'), 0);
              cds_Tempo.Post;
              inc(iNoRec);
            end;
          end
          else
            LstErreur.Add('Informations manquante pour la ligne : "'+cds_PrixVente[i]+'"');
        end;

        inc(i);
      end;

      // enregistrement
      if iRuptArtID<>-2 then
        EnregistrementPxVente;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    FreeAndNil(SQL_Taille);
    FreeAndNil(SQL_Couleur);
    FreeAndNil(SQL_TARPRIXVENTE);
    StProc_PrixVente.Close;
    Dm_Main.SaveListePrixVenteID;
    FreeAndNil(cds_Tempo);
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_PrixVente_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
  end;
end;

// Prix de vente indicatif
function TRefArticle.TraiterPrixVenteIndicatif : boolean;
var
  sRuptCodeArt: string;
  sCodeArt: string;
  iNoRec: integer;
  iArtID: integer;
  iTgfID: integer;
  iCouID: integer;
  PxPreco: Double;
  DtPreco: TDateTime;
  PxValid: Double;
  DtValid: TDateTime;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;
  bStop: boolean;

  NbRech: integer;
  LRechID: integer;
  cds_Tempo: TClientDataSet;
  cds_TempoLig: TClientDataSet;
  LstErreur: TStringList;

  sFilePath : string;
  iNumFile : Integer;


  procedure EnregistrementPxVenteIndicatif;
  var
    LstASupp: TStringList;
    ListeBeforeCommit: TStringList;
    ij: integer;
    OkEnre: boolean;
    sRupNomTar: string;
    sRupDate: string;
    sNomTar: string;
    sDate: string;
    PxVal: Double;
    sCodeArtPxVte: string;
    iArtIdPxVte: integer;
    PxVente: Double;
    OkGeneralMoins: boolean;
    PxGeneralMoins: Double;
    DtGeneralMoins: TDatetime;
    OkGeneralPlus: boolean;
    PxGeneralPlus: Double;
    DtGeneralPlus: TDatetime;
    OkAutreTarMoins: boolean;
    PxAutreTarMoins: Double;
    DtAutreTarMoins: TDatetime;
    OkAutreTarPlus: boolean;
    PxAutreTarPlus: Double;
    DtAutreTarPlus: TDatetime;
    NbRechPxVte: integer;
    LRechPxVte: integer;
    NoUniqDet: integer;
    cds_LstPxGen: TClientDataSet;    //Liste des prix au SKU pour le tarif général

    procedure EnreDetailPxVenteIndicatif;
    var
      ik: integer;
      iGeneral: integer;
      iTpoID: integer;
      iArtIdDet: integer;
      PxPrecoDet: double;
      DtPrecoDet: TDateTime;
      PxValidDet: double;
      DtValidDet: TDateTime;
      bPareil: boolean;
    begin
      if cds_TempoLig.RecordCount=0 then
        exit;

      iGeneral := -1;
      cds_TempoLig.First;
      while not(cds_TempoLig.Eof) and (iGeneral=-1) do
      begin
        if cds_TempoLig.FieldByName('NomTar').AsString='GENERAL' then
          iGeneral := cds_TempoLig.FieldByName('NoUniq').AsInteger;
        cds_TempoLig.Next;
      end;

      // si pas trouvé de tarif général, alors prendre la 1ère ligne par defaut
      if iGeneral=-1 then
      begin
        cds_TempoLig.First;
        iArtIdDet :=  cds_TempoLig.fieldbyname('ArtId').AsInteger;
        PxPrecoDet :=  cds_TempoLig.fieldbyname('PxPreco').AsFloat;
        DtPrecoDet :=  cds_TempoLig.fieldbyname('DtPreco').AsDateTime;
        PxValidDet :=  cds_TempoLig.fieldbyname('PxValid').AsFloat;
        DtValidDet :=  cds_TempoLig.fieldbyname('DtValid').AsDateTime;
        iGeneral := 0;
        cds_TempoLig.Append;
        cds_TempoLig.FieldByName('NoUniq').AsInteger := 0;
        cds_TempoLig.FieldByName('NomTar').AsString := 'GENERAL';
        cds_TempoLig.FieldByName('ArtID').AsInteger := iArtIdDet;
        cds_TempoLig.FieldByName('TgfID').AsInteger := 0;
        cds_TempoLig.FieldByName('CouID').AsInteger := 0;
        cds_TempoLig.FieldByName('PxPreco').AsFloat := PxPrecoDet;
        cds_TempoLig.FieldByName('DtPreco').AsDateTime := DtPrecoDet;
        cds_TempoLig.FieldByName('PxValid').AsFloat := PxValidDet;
        cds_TempoLig.FieldByName('DtValid').AsDateTime := DtValidDet;
        cds_TempoLig.Post;
      end;

      LstASupp := TStringList.Create;
      try
        cds_TempoLig.Locate('NoUniq', iGeneral, []);
        PxValidDet :=  cds_TempoLig.fieldbyname('PxValid').AsFloat;
        DtValidDet :=  cds_TempoLig.fieldbyname('DtValid').AsDateTime;
        if DtValidDet<>0 then
        begin
          bPareil := true;
          cds_TempoLig.First;
          while not(cds_TempoLig.Eof) and bPareil do
          begin
            if (abs(PxValidDet-cds_TempoLig.FieldByName('PxValid').AsFloat)>0.005) then
              bPareil := false;
            cds_TempoLig.Next;
          end;

          // on supprime  tou, sauf le general
          if bPareil then
          begin
            cds_TempoLig.First;
            while not(cds_TempoLig.Eof) do
            begin
              if cds_TempoLig.FieldByName('NoUniq').AsInteger<>iGeneral then
                LstASupp.Add(inttostr(cds_TempoLig.FieldByName('NoUniq').AsInteger));
              cds_TempoLig.Next;
            end;
          end;

          // suppression
          for ik := 1 to LstASupp.Count do
          begin
            if cds_TempoLig.Locate('NoUniq', StrToInt(LstASupp[ik-1]), []) then
              cds_TempoLig.Delete;
          end;

        end;
      finally
        FreeAndNil(LstASupp);
      end;

      if not(Dm_Main.TransacArt.InTransaction) then
        Dm_Main.TransacArt.StartTransaction;
      cds_TempoLig.First;
      //remplissage table TARPRECO
      StProc_VenPrecoTarPreco.Close;
      StProc_VenPrecoTarPreco.ParamByName('ARTID').AsInteger := cds_TempoLig.FieldByName('ArtID').AsInteger;
      StProc_VenPrecoTarPreco.ParamByName('PXPRECO').AsDouble := cds_TempoLig.FieldByName('PxPreco').AsFloat;
      StProc_VenPrecoTarPreco.ParamByName('DTPRECO').AsDateTime := cds_TempoLig.FieldByName('DtPreco').AsDateTime;
      StProc_VenPrecoTarPreco.ParamByName('DTPRECO').AsDateTime := cds_TempoLig.FieldByName('DtPreco').AsDateTime;
      StProc_VenPrecoTarPreco.ExecQuery;
      iTpoID := StProc_VenPrecoTarPreco.FieldByName('TPOID').AsInteger;
      StProc_VenPrecoTarPreco.Close;

      cds_TempoLig.First;
      while not(cds_TempoLig.Eof) do
      begin
        // remplissage dans TarValid si date de validation non nulle
        if Trunc(cds_TempoLig.FieldByName('DtValid').AsDateTime)<>0 then
        begin
          StProc_VenPrecoTarValid.Close;
          StProc_VenPrecoTarValid.ParamByName('TPOID').AsInteger := iTpoID;
          StProc_VenPrecoTarValid.ParamByName('ARTID').AsInteger := cds_TempoLig.FieldByName('ArtID').AsInteger;
          StProc_VenPrecoTarValid.ParamByName('TGFID').AsInteger := cds_TempoLig.FieldByName('TgfID').AsInteger;
          StProc_VenPrecoTarValid.ParamByName('COUID').AsInteger := cds_TempoLig.FieldByName('CouID').AsInteger;
          if (cds_TempoLig.FieldByName('NomTar').AsString = Dm_Main.MagCodeAdh) and (Dm_Main.MagCodeAdh<>'') then
            StProc_VenPrecoTarValid.ParamByName('NOMTAR').AsString := 'GENERAL'
          else
            StProc_VenPrecoTarValid.ParamByName('NOMTAR').AsString := cds_TempoLig.FieldByName('NomTar').AsString;
          StProc_VenPrecoTarValid.ParamByName('DT').AsDateTime :=  cds_TempoLig.FieldByName('DtValid').AsDateTime;
          StProc_VenPrecoTarValid.ParamByName('PX').AsDouble := cds_TempoLig.FieldByName('PxValid').AsFloat;
          StProc_VenPrecoTarValid.ExecQuery;
          StProc_VenPrecoTarValid.Close;
        end;
        cds_TempoLig.Next;
      end;

      // mise à jour du TarPreco précédent
      StProc_VenPrecoMajEtat.Close;
      StProc_VenPrecoMajEtat.ParamByName('TPOID').AsInteger := iTpoID;
      StProc_VenPrecoMajEtat.ExecQuery;
      StProc_VenPrecoMajEtat.Close;
      Dm_Main.TransacArt.Commit;

    end;
  begin
    // s'il y a eu déjà un enregistrement, je sors
    OkEnre := true;
    cds_Tempo.First;
    while not(cds_Tempo.Eof) do
    begin
      if cds_Tempo.FieldByName('RechID').AsInteger>=0 then
        OkEnre := false;

      cds_Tempo.Next;
    end;
    if not(OkEnre) then
      exit;

    iArtIdPxVte := cds_Tempo.FieldByName('ARTID').AsInteger;
    sCodeArtPxVte := cds_Tempo.FieldByName('CODE_ART').AsString;
    // recherche d'un px le plus proche de la date du jour avec comme priorité:
    // une date antérieur et sur le tarif general
    OkGeneralMoins  := false;
    PxGeneralMoins  := 0.0;
    DtGeneralMoins  := 0;
    OkGeneralPlus   := false;
    PxGeneralPlus   := 0.0;
    DtGeneralPlus   := 0;
    OkAutreTarMoins := false;
    PxAutreTarMoins := 0.0;
    DtAutreTarMoins := 0;
    OkAutreTarPlus  := false;
    PxAutreTarPlus  := 0.0;
    DtAutreTarPlus  := 0;
    cds_Tempo.First;
    while not(cds_Tempo.Eof) do
    begin
      // priorité au tarif general
      if UpperCase(cds_Tempo.FieldByName('NomTar').AsString)='GENERAL' then
      begin
        if Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime)<=Trunc(Date) then
        begin
          //  Prioritaire N° 1   Date antérieur la plus proche de la date du jour
          if not(OkGeneralMoins) then
          begin
            OkGeneralMoins := true;
            PxGeneralMoins := cds_Tempo.FieldByName('PxPreco').AsFloat;
            DtGeneralMoins := Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime);
          end
          else
          begin
            if Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime)>DtGeneralMoins then
            begin
              PxGeneralMoins := cds_Tempo.FieldByName('PxPreco').AsFloat;
              DtGeneralMoins := Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime);
            end;
          end;
        end
        else
        begin
          //  Prioritaire N° 2   Date supérieur la plus proche de la date du jour
          if not(OkGeneralPlus) then
          begin
            OkGeneralPlus := true;
            PxGeneralPlus := cds_Tempo.FieldByName('PxPreco').AsFloat;
            DtGeneralPlus := Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime);
          end
          else
          begin
            if Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime)<DtGeneralPlus then
            begin
              PxGeneralPlus := cds_Tempo.FieldByName('PxPreco').AsFloat;
              DtGeneralPlus := Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime);
            end;
          end;
        end;
      end
      else
      begin
        if Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime)<=Trunc(Date) then
        begin
          //  Prioritaire N° 3   Date antérieur la plus proche de la date du jour
          if not(OkAutreTarMoins) then
          begin
            OkAutreTarMoins := true;
            PxAutreTarMoins := cds_Tempo.FieldByName('PxPreco').AsFloat;
            DtAutreTarMoins := Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime);
          end
          else
          begin
            if Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime)>DtAutreTarMoins then
            begin
              PxAutreTarMoins := cds_Tempo.FieldByName('PxPreco').AsFloat;
              DtAutreTarMoins := Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime);
            end;
          end;
        end
        else
        begin
          //  Prioritaire N° 4   Date supérieur la plus proche de la date du jour
          if not(OkAutreTarPlus) then
          begin
            OkAutreTarPlus := true;
            PxAutreTarPlus := cds_Tempo.FieldByName('PxPreco').AsFloat;
            DtAutreTarPlus := Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime);
          end
          else
          begin
            if Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime)<DtAutreTarPlus then
            begin
              PxAutreTarPlus := cds_Tempo.FieldByName('PxPreco').AsFloat;
              DtAutreTarPlus := Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime);
            end;
          end;
        end;
      end;
      cds_Tempo.Next;
    end;

    PxVente := 0.0;

    if OkGeneralMoins then
    begin
      PxVente := PxGeneralMoins;
    end
    else  if OkGeneralPlus then
          begin
            PxVente := PxGeneralPlus;
          end
          else  if OkAutreTarMoins then
                begin
                  PxVente := PxAutreTarMoins;
                end
                else  if OkAutreTarPlus then
                      begin
                        PxVente := PxAutreTarPlus;
                      end;
    if Abs(PxVente)>0.01 then
    begin
      NbRechPxVte := Dm_Main.ListeIDPrixVente.Count;

      // recherche si pas déjà importé
      LRechPxVte := Dm_Main.RecherchePrixVenteID(sCodeArtPxVte+';'+
                                              '0;'+
                                              '0;'+
                                              'GENERAL',
                                              NbRechPxVte);
      if LRechPxVte=-1 then
      begin
        LRechPxVte := Dm_Main.RecherchePrixVenteID(sCodeArtPxVte+';'+
                                                '0;'+
                                                '0;'+
                                                Dm_Main.MagCodeAdh,
                                                NbRechPxVte);
      end;
      // si le prix de base n'existe, ça le crée
      if LRechPxVte=-1 then
      begin
        if not(Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.StartTransaction;
        StProc_PrixVente.Close;
        StProc_PrixVente.ParamByName('ARTID').AsInteger := iArtIdPxVte;
        StProc_PrixVente.ParamByName('TGFID').AsInteger := 0;
        StProc_PrixVente.ParamByName('COUID').AsInteger := 0;
        StProc_PrixVente.ParamByName('NOMTAR').AsString := 'GENERAL';
        StProc_PrixVente.ParamByName('PRIXVENTE').AsDouble := PxVente;
        StProc_PrixVente.ParamByName('PXDEBASE').AsInteger := 1;
        StProc_PrixVente.ExecQuery;
        StProc_PrixVente.Close;
        Dm_Main.TransacArt.Commit;
      end;
    end;

    // suppression des lignes avec des dates antérieurs à la date du jour
    LstASupp := TStringList.Create;
    try
      cds_Tempo.First;
      while not(cds_Tempo.Eof) do
      begin
        if (Trunc(cds_Tempo.FieldByName('DtValid').AsDateTime)<=Trunc(Date))
           and (Trunc(cds_Tempo.FieldByName('DtPreco').AsDateTime)<Trunc(Date)) then
          LstASupp.Add(inttostr(cds_Tempo.FieldByName('NoUniq').AsInteger));

        cds_Tempo.Next;
      end;

      // suppression
      for ij := 1 to LstASupp.Count do
      begin
        if cds_Tempo.Locate('NoUniq', StrToInt(LstASupp[ij-1]), []) then
          cds_Tempo.Delete;
      end;
      if cds_Tempo.RecordCount=0 then
        exit;

      // suppression des lignes avec le même tarif validé
      LstASupp.Clear;
      // je considère la 1ère ligne comme prix de base
      cds_Tempo.First;
      sNomTar := cds_Tempo.FieldByName('NomTar').AsString;
      sDate := FormatDateTime('dd/mm/yyyy', cds_Tempo.FieldByName('DtPreco').AsDateTime);
      PxVal := cds_Tempo.FieldByName('PxValid').AsFloat;
      cds_Tempo.Edit;
      cds_Tempo.FieldByName('TgfID').AsInteger := 0;
      cds_Tempo.FieldByName('CouID').AsInteger := 0;
      cds_Tempo.Post;
      cds_Tempo.Next;
      while not(cds_Tempo.Eof) do
      begin
        if (cds_Tempo.FieldByName('NomTar').AsString<>sNomTar)
           or (sDate<>FormatDateTime('dd/mm/yyyy', cds_Tempo.FieldByName('DtPreco').AsDateTime)) then
        begin
          sNomTar := cds_Tempo.FieldByName('NomTar').AsString;
          sDate := FormatDateTime('dd/mm/yyyy', cds_Tempo.FieldByName('DtPreco').AsDateTime);
          PxVal := cds_Tempo.FieldByName('PxValid').AsFloat;
          cds_Tempo.Edit;
          cds_Tempo.FieldByName('TgfID').AsInteger := 0;
          cds_Tempo.FieldByName('CouID').AsInteger := 0;
          cds_Tempo.Post;
        end
        else
        begin
          if (abs(PxVal-cds_Tempo.FieldByName('PxValid').AsFloat)<=0.005) then
            LstASupp.Add(inttostr(cds_Tempo.FieldByName('NoUniq').AsInteger));
        end;
        cds_Tempo.Next;
      end;

      // suppression
      for ij := 1 to LstASupp.Count do
      begin
        if cds_Tempo.Locate('NoUniq', StrToInt(LstASupp[ij-1]), []) then
          cds_Tempo.Delete;
      end;
      if cds_Tempo.RecordCount=0 then
        exit;


      //SR - 24-04-2013 - Début correction Prix indicatif
      cds_LstPxGen := TClientDataset.Create(nil);
      try
        cds_LstPxGen.FieldDefs.Add('ArtID',ftInteger,0);
        cds_LstPxGen.FieldDefs.Add('TgfID',ftInteger,0);
        cds_LstPxGen.FieldDefs.Add('CouID',ftInteger,0);
        cds_LstPxGen.FieldDefs.Add('PxPreco',ftFloat,0);
        cds_LstPxGen.FieldDefs.Add('DtPreco',ftDateTime,0);
        cds_LstPxGen.FieldDefs.Add('PxValid',ftFloat,0);
        cds_LstPxGen.FieldDefs.Add('DtValid',ftDateTime,0);
        cds_LstPxGen.CreateDataSet;
        cds_LstPxGen.LogChanges := False;
        cds_LstPxGen.IndexFieldNames := 'ArtID';

        cds_Tempo.First;
        while Not cds_tempo.eof do
        begin
          if (cds_Tempo.FieldByName('NomTar').AsString = sNomTar) then
          begin
            //Ajout de la ligne dans les listes des prix SKU du tarif général
            cds_LstPxGen.Append;
            cds_LstPxGen.FieldByName('ArtID').AsInteger := cds_Tempo.FieldByName('ArtID').AsInteger;
            cds_LstPxGen.FieldByName('TgfID').AsInteger := cds_Tempo.FieldByName('TgfID').AsInteger;
            cds_LstPxGen.FieldByName('CouID').AsInteger := cds_Tempo.FieldByName('CouID').AsInteger;
            cds_LstPxGen.FieldByName('PxPreco').AsFloat := cds_Tempo.FieldByName('PxPreco').AsFloat;
            cds_LstPxGen.Fieldbyname('DtPreco').AsDateTime := cds_Tempo.Fieldbyname('DtPreco').AsDateTime;
            cds_LstPxGen.Fieldbyname('PxValid').AsFloat := cds_Tempo.Fieldbyname('PxValid').AsFloat;
            cds_LstPxGen.Fieldbyname('DtValid').AsDateTime := cds_Tempo.Fieldbyname('DtValid').AsDateTime;
            cds_LstPxGen.Post;
          end;
          cds_tempo.Next;
        end;

        //Création des lignes SKU du tarif général
        cds_LstPxGen.First;
        while Not cds_LstPxGen.eof do
        begin
          cds_Tempo.Append;
          cds_Tempo.FieldByName('NoUniq').AsInteger   := 0;
          cds_Tempo.FieldByName('NomTar').AsString    := 'GENERAL';
          cds_Tempo.FieldByName('ArtID').AsInteger    := cds_LstPxGen.FieldByName('ArtID').AsInteger;
          cds_Tempo.FieldByName('TgfID').AsInteger    := cds_LstPxGen.FieldByName('TgfID').AsInteger;
          cds_Tempo.FieldByName('CouID').AsInteger    := cds_LstPxGen.FieldByName('CouID').AsInteger;
          cds_Tempo.FieldByName('PxPreco').AsFloat    := ArrondiA2(cds_LstPxGen.FieldByName('PxPreco').AsFloat);
          cds_Tempo.Fieldbyname('DtPreco').AsDateTime := cds_LstPxGen.Fieldbyname('DtPreco').AsDateTime;
          cds_Tempo.Fieldbyname('PxValid').AsFloat    := ArrondiA2(cds_LstPxGen.Fieldbyname('PxValid').AsFloat);
          cds_Tempo.Fieldbyname('DtValid').AsDateTime := cds_LstPxGen.Fieldbyname('DtValid').AsDateTime;
          cds_Tempo.Post;
          cds_LstPxGen.Next;
        end;

        // suppression des lignes avec le même tarif validé
        LstASupp.Clear;
        // je considère la 1ère ligne comme prix de base
        cds_Tempo.First;
        sNomTar := cds_Tempo.FieldByName('NomTar').AsString;
        sDate := FormatDateTime('dd/mm/yyyy', cds_Tempo.FieldByName('DtPreco').AsDateTime);
        PxVal := cds_Tempo.FieldByName('PxValid').AsFloat;

        cds_LstPxGen.First;
        while Not cds_LstPxGen.eof do
        begin
          cds_Tempo.First;
          while not(cds_Tempo.Eof) do
          begin
            if (cds_Tempo.FieldByName('NoUniq').AsInteger<>0) and
              (cds_LstPxGen.FieldByName('TgfID').AsInteger=cds_Tempo.FieldByName('TgfID').AsInteger) and
              (cds_LstPxGen.FieldByName('CouID').AsInteger=cds_Tempo.FieldByName('CouID').AsInteger) and
              (FormatDateTime('dd/mm/yyyy', cds_LstPxGen.FieldByName('DtPreco').AsDateTime)=FormatDateTime('dd/mm/yyyy', cds_Tempo.FieldByName('DtPreco').AsDateTime)) then
          begin
            if (abs(cds_LstPxGen.FieldByName('PxValid').AsFloat-cds_Tempo.FieldByName('PxValid').AsFloat)<=0.005) then
                LstASupp.Add(inttostr(cds_Tempo.FieldByName('NoUniq').AsInteger))
            end;
            cds_Tempo.Next;
          end;
          cds_LstPxGen.Next;
        end;

        // suppression
        for ij := 1 to LstASupp.Count do
        begin
          if cds_Tempo.Locate('NoUniq', StrToInt(LstASupp[ij-1]), []) then
            cds_Tempo.Delete;
        end;
      finally
        FreeAndNil(cds_LstPxGen);
      end;
    finally
      FreeAndNil(LstASupp);
    end;

    // enregistrement
    ListeBeforeCommit := TStringList.Create;
    try
      sRupDate := '';
      cds_Tempo.First;
      while not(cds_Tempo.Eof) do
      begin
        sDate := FormatDateTime('dd/mm/yyyy', cds_Tempo.FieldByName('DtPreco').AsDateTime);
        if (sDate<>sRupDate) then
        begin
          if sRupDate<>'' then
          begin
            EnreDetailPxVenteIndicatif;
            cds_TempoLig.EmptyDataSet;
          end;
          sRupDate := sDate;
        end;

        cds_TempoLig.Append;
        cds_TempoLig.Fieldbyname('NoUniq').AsInteger := cds_Tempo.Fieldbyname('NoUniq').AsInteger;
        cds_TempoLig.Fieldbyname('NomTar').AsString := cds_Tempo.Fieldbyname('NomTar').AsString;
        cds_TempoLig.Fieldbyname('ArtID').AsInteger := cds_Tempo.Fieldbyname('ArtID').AsInteger;
        cds_TempoLig.Fieldbyname('TgfID').AsInteger := cds_Tempo.Fieldbyname('TgfID').AsInteger;
        cds_TempoLig.Fieldbyname('CouID').AsInteger := cds_Tempo.Fieldbyname('CouID').AsInteger;
        cds_TempoLig.Fieldbyname('PxPreco').AsFloat := cds_Tempo.Fieldbyname('PxPreco').AsFloat;
        cds_TempoLig.Fieldbyname('DtPreco').AsDateTime := cds_Tempo.Fieldbyname('DtPreco').AsDateTime;
        cds_TempoLig.Fieldbyname('PxValid').AsFloat := cds_Tempo.Fieldbyname('PxValid').AsFloat;
        cds_TempoLig.Fieldbyname('DtValid').AsDateTime := cds_Tempo.Fieldbyname('DtValid').AsDateTime;
        cds_TempoLig.Post;

        if (cds_Tempo.FieldByName('TgfID').AsInteger=0) and (cds_Tempo.FieldByName('CouID').AsInteger=0) then
          Dm_Main.AjoutInListePrixVenteIndicatifID(ListeBeforeCommit,
                                                   cds_Tempo.FieldByName('CODE_ART').AsString+';0;0;'+
                                                   cds_Tempo.FieldByName('NOMTAR').AsString+';'+sDate)
        else
          Dm_Main.AjoutInListePrixVenteIndicatifID(ListeBeforeCommit,
                                                   cds_Tempo.FieldByName('CODE_ART').AsString+';'+
                                                   cds_Tempo.FieldByName('CODE_TAILLE').AsString+';'+
                                                   cds_Tempo.FieldByName('CODE_COUL').AsString+';'+
                                                   cds_Tempo.FieldByName('NOMTAR').AsString+';'+sDate);
        cds_Tempo.Next;
      end;

      if sRupDate<>'' then
      begin
        EnreDetailPxVenteIndicatif;
        cds_TempoLig.EmptyDataSet;
      end;

      // sauvegarde pour eviter de retourner dedans
      Dm_Main.ListeIDPrixVenteIndicatif.AddStrings(ListeBeforeCommit);
      ListeBeforeCommit.Clear;
    finally
      FreeAndNil(ListeBeforeCommit);
    end;

//    // enregistrement
//    ListeBeforeCommit := TStringList.Create;
//    try
//      if not(Dm_Main.TransacArt.InTransaction) then
//        Dm_Main.TransacArt.StartTransaction;
//
//      sRupNomTar := '';
//      sRupDate := '';
//      iTpoID := 0;
//      cds_Tempo.First;
//      while not(cds_Tempo.Eof) do
//      begin
//        sNomTar := cds_Tempo.FieldByName('NomTar').AsString;
//        sDate := FormatDateTime('dd/mm/yyyy', cds_Tempo.FieldByName('DtPreco').AsDateTime);
//        if (sNomTar<>sRupNomTar) or (sDate<>sRupDate) then
//        begin
//          // mise à jour du TarPreco précédent
//          if (iTpoID>0) then
//          begin
//            StProc_VenPrecoMajEtat.Close;
//            StProc_VenPrecoMajEtat.ParamByName('TPOID').AsInteger := iTpoID;
//            StProc_VenPrecoMajEtat.ExecQuery;
//            StProc_VenPrecoMajEtat.Close;
//          end;
//
//          //remplissage table TARPRECO
//          StProc_VenPrecoTarPreco.Close;
//          StProc_VenPrecoTarPreco.ParamByName('ARTID').AsInteger := cds_Tempo.FieldByName('ArtID').AsInteger;
//          StProc_VenPrecoTarPreco.ParamByName('PXPRECO').AsDouble := cds_Tempo.FieldByName('PxPreco').AsFloat;
//          StProc_VenPrecoTarPreco.ParamByName('DTPRECO').AsDateTime := cds_Tempo.FieldByName('DtPreco').AsDateTime;
//          StProc_VenPrecoTarPreco.ExecQuery;
//          iTpoID := StProc_VenPrecoTarPreco.FieldByName('TPOID').AsInteger;
//          StProc_VenPrecoTarPreco.Close;
//        end;
//
//        // remplissage dans TarValid si date de validation non nulle
//        if Trunc(cds_Tempo.FieldByName('DtValid').AsDateTime)<>0 then
//        begin
//          StProc_VenPrecoTarValid.Close;
//          StProc_VenPrecoTarValid.ParamByName('TPOID').AsInteger := iTpoID;
//          StProc_VenPrecoTarValid.ParamByName('ARTID').AsInteger := cds_Tempo.FieldByName('ArtID').AsInteger;
//          StProc_VenPrecoTarValid.ParamByName('TGFID').AsInteger := cds_Tempo.FieldByName('TgfID').AsInteger;
//          StProc_VenPrecoTarValid.ParamByName('COUID').AsInteger := cds_Tempo.FieldByName('CouID').AsInteger;
//          if (cds_Tempo.FieldByName('NomTar').AsString = Dm_Main.MagCodeAdh) and (Dm_Main.MagCodeAdh<>'') then
//            StProc_VenPrecoTarValid.ParamByName('NOMTAR').AsString := 'GENERAL'
//          else
//            StProc_VenPrecoTarValid.ParamByName('NOMTAR').AsString := cds_Tempo.FieldByName('NomTar').AsString;
//          StProc_VenPrecoTarValid.ParamByName('DT').AsDateTime :=  cds_Tempo.FieldByName('DtValid').AsDateTime;
//          StProc_VenPrecoTarValid.ParamByName('PX').AsDouble := cds_Tempo.FieldByName('PxValid').AsFloat;
//          StProc_VenPrecoTarValid.ExecQuery;
//          StProc_VenPrecoTarValid.Close;
//        end;
//
//        if (cds_Tempo.FieldByName('TgfID').AsInteger=0) and (cds_Tempo.FieldByName('CouID').AsInteger=0) then
//          Dm_Main.AjoutInListePrixVenteIndicatifID(ListeBeforeCommit,
//                                                   cds_Tempo.FieldByName('CODE_ART').AsString+';0;0;'+
//                                                   cds_Tempo.FieldByName('NOMTAR').AsString+';'+sDate)
//        else
//          Dm_Main.AjoutInListePrixVenteIndicatifID(ListeBeforeCommit,
//                                                   cds_Tempo.FieldByName('CODE_ART').AsString+';'+
//                                                   cds_Tempo.FieldByName('CODE_TAILLE').AsString+';'+
//                                                   cds_Tempo.FieldByName('CODE_COUL').AsString+';'+
//                                                   cds_Tempo.FieldByName('NOMTAR').AsString+';'+sDate);
//        cds_Tempo.Next;
//      end;
//
//      // mise à jour du dernier TarPreco
//      if (iTpoID>0) then
//      begin
//        StProc_VenPrecoMajEtat.Close;
//        StProc_VenPrecoMajEtat.ParamByName('TPOID').AsInteger := iTpoID;
//        StProc_VenPrecoMajEtat.ExecQuery;
//        StProc_VenPrecoMajEtat.Close;
//      end;
//
//      Dm_Main.TransacArt.Commit;
//      // sauvegarde pour eviter de retourner dedans
//      Dm_Main.ListeIDPrixVenteIndicatif.AddStrings(ListeBeforeCommit);
//      ListeBeforeCommit.Clear;
//    finally
//      FreeAndNil(ListeBeforeCommit);
//    end;
  end;

begin
  i := 1;
  iNumFile := 0;
  sFilePath := sPathVenteIndicatifPrix;

  result := false;

  iMaxProgress := cds_PrixVenteIndicatif.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100));
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "PRIX_VENTE_INDICATIF.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  LstErreur := TStringList.Create;
  cds_Tempo := TClientDataset.Create(nil);
  cds_TempoLig := TClientDataset.Create(nil);
  NbRech := Dm_Main.ListeIDPrixVente.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    bStop := false;
    sRuptCodeArt := '';
    // creation table tempo pour gérer le bloc ArtID, FouID
    iNoRec := 1;
    cds_Tempo.FieldDefs.Add('NoUniq',ftInteger,0);
    cds_Tempo.FieldDefs.Add('RechID',ftInteger,0);
    cds_Tempo.FieldDefs.Add('CODE_ART',ftstring,32);
    cds_Tempo.FieldDefs.Add('CODE_TAILLE',ftstring,32);
    cds_Tempo.FieldDefs.Add('CODE_COUL',ftstring,32);
    cds_Tempo.FieldDefs.Add('NomTar',ftString,64);
    cds_Tempo.FieldDefs.Add('ArtID',ftInteger,0);
    cds_Tempo.FieldDefs.Add('TgfID',ftInteger,0);
    cds_Tempo.FieldDefs.Add('CouID',ftInteger,0);
    cds_Tempo.FieldDefs.Add('PxPreco',ftFloat,0);
    cds_Tempo.FieldDefs.Add('DtPreco',ftDateTime,0);
    cds_Tempo.FieldDefs.Add('PxValid',ftFloat,0);
    cds_Tempo.FieldDefs.Add('DtValid',ftDateTime,0);
    cds_Tempo.CreateDataSet;
    cds_Tempo.LogChanges := False;

    cds_Tempo.IndexFieldNames := 'ArtID;DtPreco;NomTar';

    cds_TempoLig.FieldDefs.Add('NoUniq',ftInteger,0);
    cds_TempoLig.FieldDefs.Add('NomTar',ftString,64);
    cds_TempoLig.FieldDefs.Add('ArtID',ftInteger,0);
    cds_TempoLig.FieldDefs.Add('TgfID',ftInteger,0);
    cds_TempoLig.FieldDefs.Add('CouID',ftInteger,0);
    cds_TempoLig.FieldDefs.Add('PxPreco',ftFloat,0);
    cds_TempoLig.FieldDefs.Add('DtPreco',ftDateTime,0);
    cds_TempoLig.FieldDefs.Add('PxValid',ftFloat,0);
    cds_TempoLig.FieldDefs.Add('DtValid',ftDateTime,0);
    cds_TempoLig.CreateDataSet;
    cds_TempoLig.LogChanges := False;

    cds_TempoLig.IndexFieldNames := 'ArtID;DtPreco;NomTar';

    try
      while FileExists(sFilePath) do
      begin
        try
          cds_PrixVenteIndicatif.Clear;
          cds_PrixVenteIndicatif.LoadFromFile(sFilePath);
        except
          on E: Exception do
          begin
            sError := 'Traitement prix de vente indicatif ' + E.Message;
            DoLog(sError, logError);
            Synchronize(ErrorFrm);
            exit;
          end;
        end;

        iMaxProgress := cds_PrixVenteIndicatif.Count-1;
        iProgress := 0;
        AvancePc := Round((iMaxProgress/100)*2);
        if AvancePc<=0 then
          AvancePc := 1;
        if AvancePc>1000 then
          AvancePc := 1000;
        sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "'+ExtractFileName(sFilePath)+'":';
        sEtat2 := '0 / '+inttostr(iMaxProgress);
        Synchronize(UpdateFrm);
        Synchronize(InitProgressFrm);

        NbEnre := cds_PrixVenteIndicatif.Count-1;
        while (i<=NbEnre) do
        begin
          // maj de la fenetre
          sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
          Inc(iProgress);
          if ((iProgress mod AvancePc)=0) then
            Synchronize(UpdProgressFrm);

          if cds_PrixVenteIndicatif[i]<>'' then
          begin
            // ajout ligne
            AjoutInfoLigne(cds_PrixVenteIndicatif[i], Prix_Vente_Indicatif_COL);

            sCodeArt := GetValuePrixVenteIndicatifImp('CODE_ART');
            if sCodeArt='' then
              Raise Exception.Create('CODE_ART est vide sur cette ligne');

            PxPreco := ConvertStrToFloat(GetValuePrixVenteIndicatifImp('PX_VTE_INDIC'));
            DtPreco := ConvertStrToDate(GetValuePrixVenteIndicatifImp('PX_VTE_INDIC_DATE'));
            PxValid := ConvertStrToFloat(GetValuePrixVenteIndicatifImp('PX_VTE_AVENIR'));
            DtValid := ConvertStrToDate(GetValuePrixVenteIndicatifImp('PX_VTE_AVENIR_DATE'));

            // recherche si pas déjà importé
            LRechID := Dm_Main.RecherchePrixVenteIndicatifID(GetValuePrixVenteIndicatifImp('CODE_ART')+';'+
                                                             GetValuePrixVenteIndicatifImp('CODE_TAILLE')+';'+
                                                             GetValuePrixVenteIndicatifImp('CODE_COUL')+';'+
                                                             GetValuePrixVenteIndicatifImp('NOMTAR')+';'+
                                                             FormatDateTime('dd/mm/yyyy', DtPreco),
                                                             NbRech);
            if LRechID=-1 then
            begin
              LRechID := Dm_Main.RecherchePrixVenteIndicatifID(GetValuePrixVenteIndicatifImp('CODE_ART')+';'+
                                                               '0;'+
                                                               '0;'+
                                                               Dm_Main.MagCodeAdh+';'+
                                                               FormatDateTime('dd/mm/yyyy', DtPreco),
                                                               NbRech);
            end;

            iArtID := 0;
            iTgfID := 0;
            iCouID := 0;
            case Dm_Main.Provenance of
              ipGinkoia, ipNosymag, ipGoSport, ipDataMag: begin
                iArtID := Dm_Main.GetArtID(GetValuePrixVenteIndicatifImp('CODE_ART'));
                if (PxValid>0.001) and (Trunc(DtValid)<>0) then
                begin
                  iTgfID := Dm_Main.GetTgfID(GetValuePrixVenteIndicatifImp('CODE_TAILLE'));
                  iCouID := Dm_Main.GetCouID(GetValuePrixVenteIndicatifImp('CODE_COUL'));
                end;
              end;
              ipInterSys, ipExotiqueISF : begin
                iArtID := Dm_Main.GetArtID(GetValuePrixVenteIndicatifImp('CODE_ART'));
                if (PxValid>0.001) and (Trunc(DtValid)<>0) then
                begin
                  iTgfID := Dm_Main.GetTgfID(GetValuePrixVenteIndicatifImp('CODE_TAILLE'));
                  iCouID := Dm_Main.GetCouID(GetValuePrixVenteIndicatifImp('CODE_COUL')+GetValuePrixVenteIndicatifImp('CODE_ART'));
                end;
              end;
            end;

            //Article
            if (iArtID<0) then
              iArtID := 0;
            if (iArtID=0) then
            begin
              bStop := true;
              LstErreur.Add('Code article non trouvé: "'+GetValuePrixVenteIndicatifImp('CODE_ART')+'"');
            end;

            if (PxValid>0.001) and (Trunc(DtValid)<>0) then
            begin
              //Taille
              if (iTgfID<0) then
              begin
                iTgfID := 0;
                if GetValuePrixVenteIndicatifImp('CODE_TAILLE')<>'0' then
                begin
                  bStop := true;
                  LstErreur.Add('Code taille non trouvé: "'+GetValuePrixVenteIndicatifImp('CODE_TAILLE')+'" '+
                                'pour l''article: "'+GetValuePrixVenteIndicatifImp('CODE_ART')+'"');
                end;
              end;

              //Couleur
              if (iCouID<0) then
              begin
                iCouID := 0;
                if GetValuePrixVenteIndicatifImp('CODE_COUL')<>'0' then
                begin
                  bStop := true;
                  LstErreur.Add('Code couleur non trouvé: "'+GetValuePrixVenteIndicatifImp('CODE_COUL')+'" '+
                                'pour l''article: "'+GetValuePrixVenteIndicatifImp('CODE_ART')+'"');
                end;
              end;
            end;

            // 1ère ligne
            if sRuptCodeArt='' then
              sRuptCodeArt := sCodeArt;

            if (sRuptCodeArt<>sCodeArt) then
            begin
              // enregistrement
              if (sRuptCodeArt<>'') and not(bStop) then
                EnregistrementPxVenteIndicatif;

              bStop := false;
              sRuptCodeArt := sCodeArt;
              cds_Tempo.EmptyDataSet;
              iNoRec := 1;
            end;

            // ajout dans la table temporaire
            cds_Tempo.Append;
            cds_Tempo.FieldByName('NoUniq').AsInteger := iNoRec;
            cds_Tempo.FieldByName('RechID').AsInteger := LRechID;
            cds_Tempo.FieldByName('CODE_ART').AsString := sCodeArt;
            cds_Tempo.FieldByName('CODE_TAILLE').AsString := GetValuePrixVenteIndicatifImp('CODE_TAILLE');
            cds_Tempo.FieldByName('CODE_COUL').AsString := GetValuePrixVenteIndicatifImp('CODE_COUL');
            cds_Tempo.FieldByName('NomTar').AsString := GetValuePrixVenteIndicatifImp('NOMTAR');
            cds_Tempo.FieldByName('ArtID').AsInteger := iArtId;
            cds_Tempo.FieldByName('TgfID').AsInteger := iTgfID;
            cds_Tempo.FieldByName('CouID').AsInteger := iCouID;
            cds_Tempo.FieldByName('PxPreco').AsFloat := PxPreco;
            cds_Tempo.FieldByName('DtPreco').AsDateTime := DtPreco;
            cds_Tempo.FieldByName('PxValid').AsFloat := PxValid;
            cds_Tempo.FieldByName('DtValid').AsDateTime := DtValid;
            cds_Tempo.Post;
            inc(iNoRec);

          end;   // if cds_PrixVente[i]<>'' the

          inc(i);
        end;
        Inc(iNumFile);
        sFilePath := StringReplace(sFilePath, ExtractFileName(sFilePath), 'PRIX_VENTE_INDICATIF' + IntToStr(iNumFile) + '.csv', [rfReplaceAll, rfIgnoreCase]);
      end;

      // enregistrement
      if sRuptCodeArt<>'' then
        EnregistrementPxVenteIndicatif;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
      Result := true;
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_VenPrecoTarPreco.Close;
    StProc_VenPrecoTarValid.Close;
    StProc_VenPrecoMajEtat.Close;
    Dm_Main.SaveListePrixVenteIndicatifID;
    FreeAndNil(cds_Tempo);
    FreeAndNil(cds_TempoLig);
    if LstErreur.Count>0 then
      LstErreur.SaveToFile(Dm_Main.ReperBase+'Erreur_PrixVenteIndicatif_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    FreeAndNil(LstErreur);
  end;
end;

function TRefArticle.TraiterTOC: boolean;
var
  iOctID    : Integer;
  iOclID    : Integer;
  AvancePc  : Integer;
  i         : Integer;
  NbEnre    : Integer;

  sTmpMag   : string;
  MagCode   : String;
  iMagID    : Integer;

  iCliID    : Integer;
  sTmpCli   : string;

  iArtID    : Integer;
  iTgfID    : Integer;
  iCouID    : Integer;

  NbRechTete  : Integer;
  NbRechLigne : Integer;

  LRechID     : Integer;
begin
  Result := true;
  MagCode := '';
  iMagID  := 0;
  //OcTete
  iMaxProgress := cds_OcTete.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + OcTete_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRechTete := Dm_Main.ListeIDOcTete.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_OcTete.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_OcTete[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_OcTete[i], OcTete_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheOcTeteID(GetValueOcTeteImp('TOC_CODE'), NbRechTete);

          if (LRechID=-1) and (GetValueOcTeteImp('TOC_CODE') <> '')then
          begin
            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            StProc_OcTete.Close;
            StProc_OcTete.ParamByName('NOM').AsString := GetValueOcTeteImp('TOC_NOM');
            StProc_OcTete.ParamByName('COMMENT').AsString := GetValueOcTeteImp('TOC_COMMENT');
            StProc_OcTete.ParamByName('DEBUT').AsDateTime := StrToDateTime(GetValueOcTeteImp('TOC_DEBUT'));
            StProc_OcTete.ParamByName('FIN').AsDateTime := StrToDateTime(GetValueOcTeteImp('TOC_FIN'));
            StProc_OcTete.ParamByName('TYPID').AsInteger := StrToInt(GetValueOcTeteImp('TOC_TYPID'));
            StProc_OcTete.ParamByName('WEB').AsInteger := StrToInt(GetValueOcTeteImp('TOC_WEB'));
            StProc_OcTete.ParamByName('CENTRALE').AsInteger := StrToInt(GetValueOcTeteImp('TOC_CENTRALE'));
            StProc_OcTete.ParamByName('CODE').AsString := GetValueOcTeteImp('TOC_CODE');
            StProc_OcTete.ExecQuery;

            // récupération du nouvel ID fournisseur
            iOctID := StProc_OcTete.FieldByName('OCTID').AsInteger;
            Dm_Main.AjoutInListeOcTeteID(GetValueOcTeteImp('TOC_CODE'), iOctID);

            StProc_OcTete.Close;

            Dm_Main.TransacArt.Commit;
          end;
        end;

        inc(i);
      end;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_OcTete.Close;
    Dm_Main.SaveListeOcTeteID;
  end;

  //OcMag
  iMaxProgress := cds_OcMag.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + OcMag_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRechTete := Dm_Main.ListeIDOcTete.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_OcMag.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_OcMag[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_OcMag[i], OcMag_COL);

          // OcTete
          iOctID := Dm_Main.GetOcTeteID(GetValueOcMagImp('TOC_CODE'));
          if iOctID<=0 then
            Raise Exception.Create('OcMag - OcTete non trouvé - OctId = '+GetValueOcMagImp('TOC_CODE'));

          // magasin
          sTmpMag := GetValueOcMagImp('CODE_MAG');
          if sTmpMag<>MagCode then
          begin
            MagCode := sTmpMag;
            iMagID := 0;
            if cds_Magasin.Locate('MAG_CODEADH', sTmpMag, []) then
              iMagID := cds_Magasin.FieldByName('MAG_ID').AsInteger;
          end;
          if iMagID=0 then
            Raise Exception.Create('Magasin non trouvé pour - CODE_MAG = '+MagCode);

          //Client
          sTmpCli := GetValueOcMagImp('CODE_CLI');
          if (sTmpCli<>'0') and (sTmpCli <> '') then
            iCliID := Dm_Main.GetClientID(sTmpCli)
          else
            iCliID := 0;
          if iCliID=-1 then
            iCliID := 0;

          if not(Dm_Main.TransacArt.InTransaction) then
            Dm_Main.TransacArt.StartTransaction;

          StProc_OcMag.Close;
          StProc_OcMag.ParamByName('OCTID').AsInteger := iOctID;
          StProc_OcMag.ParamByName('MAGID').AsInteger := iMagID;
          StProc_OcMag.ParamByName('CLTID').AsInteger := iCliID;
          StProc_OcMag.ParamByName('CLTIDPRO').AsInteger := 0;
          StProc_OcMag.ExecQuery;

          Dm_Main.TransacArt.Commit;
        end;

        inc(i);
      end;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_OcMag.Close;
  end;

  //OcLignes
  iMaxProgress := cds_OcLignes.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + OcLignes_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRechLigne := Dm_Main.ListeIDOcLignes.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_OcLignes.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_OcLignes[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_OcLignes[i], OcLignes_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheOcLignesID(GetValueOcLignesImp('TOC_CODELIG'), NbRechLigne);

          if (LRechID=-1) and (GetValueOcLignesImp('TOC_CODELIG') <> '')then
          begin
            //OcTete
            iOctID := Dm_Main.GetOcTeteID(GetValueOcLignesImp('TOC_CODE'));
            if iOctID<=0 then
              Raise Exception.Create('OCLIGNES - OcTete non trouvé - OctId = '+GetValueOcLignesImp('TOC_CODE'));

            //Article
            iArtID := Dm_Main.GetArtID(GetValueOcLignesImp('CODE_ART'));
            if iArtID<=0 then
              Raise Exception.Create('OCLIGNES - Article non trouvé - ArtId = '+GetValueOcLignesImp('CODE_ART'));

            if not(Dm_Main.TransacArt.InTransaction) then
              Dm_Main.TransacArt.StartTransaction;

            StProc_OcLignes.Close;
            StProc_OcLignes.ParamByName('OCTID').AsInteger := iOctID;
            StProc_OcLignes.ParamByName('ARTID').AsInteger := iArtID;
            StProc_OcLignes.ParamByName('PXVTE').AsFloat := ConvertStrToFloat(GetValueOcLignesImp('PVTE'));
            StProc_OcLignes.ExecQuery;

            // récupération du nouvel ID fournisseur
            iOclID := StProc_OcLignes.FieldByName('OCLID').AsInteger;
            Dm_Main.AjoutInListeOcLignesID(GetValueOcLignesImp('TOC_CODELIG'), iOclID);

            StProc_OcLignes.Close;

            Dm_Main.TransacArt.Commit;
          end;
        end;

        inc(i);
      end;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_OcLignes.Close;
    Dm_Main.SaveListeOcLignesID;
  end;

  //OcDetail
  iMaxProgress := cds_OcDetail.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "' + OcDetail_CSV + '":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  try
    i := 1;
    try
      NbEnre := cds_OcDetail.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_OcDetail[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_OcDetail[i], OcDetail_COL);

          //OcLignes
          iOclID := Dm_Main.GetOcLignesID(GetValueOcDetailImp('TOC_CODELIG'));
          if iOclID<=0 then
            raise Exception.Create('OCDETAIL - OcLignes non trouvé - TOC_CODELIG = '+GetValueOcDetailImp('TOC_CODELIG'));

          iArtID := 0;
          iTgfID := 0;
          iCouID := 0;
          case Dm_Main.Provenance of
            ipGinkoia, ipNosymag, ipGoSport, ipDataMag: begin
              iArtID := Dm_Main.GetArtID(GetValueOcDetailImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValueOcDetailImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValueOcDetailImp('CODE_COUL'))
            end;
            ipInterSys, ipExotiqueISF : begin
              iArtID := Dm_Main.GetArtID(GetValueOcDetailImp('CODE_ART'));
              iTgfID := Dm_Main.GetTgfID(GetValueOcDetailImp('CODE_TAILLE'));
              iCouID := Dm_Main.GetCouID(GetValueOcDetailImp('CODE_COUL')+GetValueOcDetailImp('CODE_ART'));
            end;
          end;

          //Article
          if iArtID<=0 then
            raise Exception.Create('OCDETAIL - Article non trouvé - CODE_ART = '+GetValueOcDetailImp('CODE_ART'));

          //Taille
          if iTgfID<=0 then
            raise Exception.Create('OCDETAIL - Taille non trouvé - CODE_TAILLE = '+GetValueOcDetailImp('CODE_TAILLE'));

          //Couleur
          if iCouID<=0 then
            raise Exception.Create('OCDETAIL - Couleur non trouvé - CODE_COUL = '+GetValueOcDetailImp('CODE_COUL'));

          if not(Dm_Main.TransacArt.InTransaction) then
            Dm_Main.TransacArt.StartTransaction;

          StProc_OcDetail.Close;
          StProc_OcDetail.ParamByName('OCLID').AsInteger := iOclID;
          StProc_OcDetail.ParamByName('ARTID').AsInteger := iArtID;
          StProc_OcDetail.ParamByName('TGFID').AsInteger := iTgfID;
          StProc_OcDetail.ParamByName('COUID').AsInteger := iCouID;
          StProc_OcDetail.ParamByName('PRIX').AsFloat := ConvertStrToFloat(GetValueOcDetailImp('OCDET_PRIX'));
          StProc_OcDetail.ParamByName('ACTIVE').AsInteger := StrToInt(GetValueOcDetailImp('OCDET_ACTIVE'));
          StProc_OcDetail.ParamByName('CENTRALE').AsInteger := StrToInt(GetValueOcDetailImp('OCDET_CENTRALE'));
          StProc_OcDetail.ExecQuery;

          Dm_Main.TransacArt.Commit;
        end;

        inc(i);
      end;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_OcDetail.Close;
  end;
end;

// Article déprecié
function TRefArticle.TraiterModeleDeprecie: boolean;
var
  iArtID: integer;
  iDepID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
begin
  Result := true;

  iMaxProgress := cds_ModeleDeprecie.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "ArticleDeprecie.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDArtDeprecie.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_ModeleDeprecie.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_ModeleDeprecie[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_ModeleDeprecie[i], ModeleDeprecie_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheArticleDeprecieID(GetValueArticleDeprecieImp('CODE_ART'), NbRech);

          if (LRechID=-1)
             and (GetValueArticleDeprecieImp('CODE_ART')<>'') then
          begin
            iArtID := Dm_Main.GetArtID(GetValueArticleDeprecieImp('CODE_ART'));

            if (iArtID>0) then
            begin
              if not(Dm_Main.TransacArt.InTransaction) then
                Dm_Main.TransacArt.StartTransaction;

              StProc_ModeleDeprecie.Close;
              StProc_ModeleDeprecie.ParamByName('ARTID').AsInteger     := iArtID;
              StProc_ModeleDeprecie.ParamByName('DEP_DATE').AsDateTime := ConvertStrToDate(GetValueArticleDeprecieImp('DATE'));
              StProc_ModeleDeprecie.ParamByName('TAUX').AsDouble       := ConvertStrToFloat(GetValueArticleDeprecieImp('TAUX'));
              StProc_ModeleDeprecie.ParamByName('MOTIF').AsString      := GetValueArticleDeprecieImp('MOTIF');
              StProc_ModeleDeprecie.ParamByName('DIVERS').AsString     := GetValueArticleDeprecieImp('DIVERS');
              StProc_ModeleDeprecie.ExecQuery;

              // récupération du nouvel ID fournisseur
              iDepID := StProc_ModeleDeprecie.FieldByName('DEPID').AsInteger;
              Dm_Main.AjoutInListeArticleDeprecieID(GetValueArticleDeprecieImp('CODE_ART'), iDepID);

              StProc_ModeleDeprecie.Close;

              Dm_Main.TransacArt.Commit;
            end;
          end;
        end;

        inc(i);
      end;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_ModeleDeprecie.Close;
    Dm_Main.SaveListeArticleDeprecieID;
  end;
end;

// Contact Fournisseur
function TRefArticle.TraiterFouContact: boolean;
var
  iFouID: integer;
  iConID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
begin
  Result := true;

  iMaxProgress := cds_FouContact.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "FouContact.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDFouContact.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_FouContact.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_FouContact[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_FouContact[i], FouContact_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheFouContactID(GetValueFouContactImp('CODE_FOU'), NbRech);

          if (LRechID=-1)
             and (GetValueFouContactImp('CODE_FOU')<>'') then
          begin
            iFouID := Dm_Main.GetFouID(GetValueFouContactImp('CODE_FOU'));

            if (iFouID>0) then
            begin
              if not(Dm_Main.TransacArt.InTransaction) then
                Dm_Main.TransacArt.StartTransaction;

              StProc_FouContact.Close;
              StProc_FouContact.ParamByName('FOUID').AsInteger := iFouID;
              StProc_FouContact.ParamByName('NOM').AsString := GetValueFouContactImp('NOM');
              StProc_FouContact.ParamByName('PRENOM').AsString := GetValueFouContactImp('PRENOM');
              StProc_FouContact.ParamByName('FONCTION').AsString := GetValueFouContactImp('FONCTION');
              StProc_FouContact.ParamByName('TELEPHONE').AsString := GetValueFouContactImp('TELEPHONE');
              StProc_FouContact.ParamByName('TELPORTABLE').AsString := GetValueFouContactImp('TELPORTABLE');
              StProc_FouContact.ParamByName('EMAIL').AsString := GetValueFouContactImp('EMAIL');
              StProc_FouContact.ParamByName('COMMENT').AsString := GetValueFouContactImp('COMMENT');
              StProc_FouContact.ExecQuery;

              // récupération du nouvel ID fournisseur
              iConID := StProc_FouContact.FieldByName('CONID').AsInteger;
              Dm_Main.AjoutInListeFouContactID(GetValueFouContactImp('CODE_FOU'), iConID);

              StProc_FouContact.Close;

              Dm_Main.TransacArt.Commit;
            end;
          end;
        end;

        inc(i);
      end;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_FouContact.Close;
    Dm_Main.SaveListeFouContactID;
  end;
end;

// Condition fournisseur
function TRefArticle.TraiterFouCondition: boolean;
var
  iFouID: integer;
  iFodID: integer;
  AvancePc: integer;
  i: integer;
  NbEnre: integer;

  NbRech: integer;
  LRechID: integer;
begin
  Result := true;

  iMaxProgress := cds_FouCondition.Count;
  iProgress := 0;
  AvancePc := Round((iMaxProgress/100)*2);
  if AvancePc<=0 then
    AvancePc := 1;
  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') "FouCondition.CSV":';
  sEtat2 := '0 / '+inttostr(iMaxProgress);
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  NbRech := Dm_Main.ListeIDFouCondition.Count;  // la recherche des ID déjà fait s'arrete au ancien, pas au nouveau ID
  try
    i := 1;
    try
      NbEnre := cds_FouCondition.Count-1;
      while (i<=NbEnre) do
      begin
        // maj de la fenetre
        sEtat2 := inttostr(iProgress)+' / '+inttostr(iMaxProgress);
        Inc(iProgress);
        if ((iProgress mod AvancePc)=0) then
          Synchronize(UpdProgressFrm);

        if cds_FouCondition[i]<>'' then
        begin
          // ajout ligne
          AjoutInfoLigne(cds_FouCondition[i], FouCondition_COL);

          // recherche si pas déjà importé
          LRechID := Dm_Main.RechercheFouContactID(GetValueFouConditionImp('CODE_FOU'), NbRech);

          if (LRechID=-1)
             and (GetValueFouConditionImp('CODE_FOU')<>'') then
          begin
            iFouID := Dm_Main.GetFouID(GetValueFouConditionImp('CODE_FOU'));

            if (iFouID>0) then
            begin
              if not(Dm_Main.TransacArt.InTransaction) then
                Dm_Main.TransacArt.StartTransaction;

              StProc_FouCondition.Close;
              StProc_FouCondition.ParamByName('FOUID').AsInteger := iFouID;
              StProc_FouCondition.ParamByName('CODE_MAG').AsString := GetValueFouConditionImp('CODE_MAG');
              StProc_FouCondition.ParamByName('NUMCLIENT').AsString := GetValueFouConditionImp('NUMCLIENT');
              StProc_FouCondition.ParamByName('COMMENT').AsString := GetValueFouConditionImp('COMMENT');
              StProc_FouCondition.ParamByName('ENCOURS').AsDouble := ConvertStrToFloat(GetValueFouConditionImp('ENCOURS'));
              StProc_FouCondition.ParamByName('NUMCOMPTA').AsString := GetValueFouConditionImp('NUMCOMPTA');
              StProc_FouCondition.ParamByName('FRANCOPORT').AsDouble := ConvertStrToFloat(GetValueFouConditionImp('FRANCOPORT'));
              StProc_FouCondition.ParamByName('MODEREG').AsString := GetValueFouConditionImp('MODEREG');
              StProc_FouCondition.ParamByName('CONDREG').AsInteger := StrToIntDef(GetValueFouConditionImp('CONDREG'), 0);
              StProc_FouCondition.ExecQuery;

              // récupération du nouvel ID fournisseur
              iFodID := StProc_FouCondition.FieldByName('FODID').AsInteger;
              Dm_Main.AjoutInListeFouConditionID(GetValueFouConditionImp('CODE_FOU'), iFodID);

              StProc_FouCondition.Close;

              Dm_Main.TransacArt.Commit;
            end;
          end;
        end;

        inc(i);
      end;

      sEtat2 := '';
      iProgress := 0;
      Synchronize(UpdProgressFrm);
    except
      on E: Exception do
      begin
        if (Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := '('+inttostr(i)+')'+#13#10+
                  'Ligne: '+LigneLecture+#13#10+
                  E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_FouCondition.Close;
    Dm_Main.SaveListeFouConditionID;
  end;
end;

procedure BackupLogArt(ALigneLog: string);
begin
  ArtSoiMeme.sEtat2 := Trim(ALigneLog);
  ArtSoiMeme.UpdateEtat2;
end;

function TRefArticle.TraiterBackupRestore: boolean;    // backup restore de la base
var
  ADataBase: string;
  AFileBack: string;
  AFileRest: string;
  AFileLogBack: string;
  AFileLogRest: string;
  Delai: DWord;
  Passe: DWord;
begin
  Result := false;

  ArtSoiMeme := Self;

  iMaxProgress := 5;
  iProgress := 0;
  inc(iTraitement);
  sEtat1 := '('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') Arrêt de la base';
  sEtat2 := '';
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  ADataBase := Dm_Main.Database.DatabaseName;

  // fichier backup
  AFileBack := ChangeFileExt(AdataBase, '.ibk');
  if FileExists(AFileBack) then
    DeleteFile(AFileBack);

  // fichier log erreur backup (créé si backup plante)
  AFileLogBack := ExtractFilePath(ADatabase);
  if AFileLogBack[Length(AFileLogBack)]<>'\' then
    AFileLogBack := AFileLogBack+'\';
  AFileLogBack := AFileLogBack+'Log_Backup_'+
                  Copy(ADatabase, 1, Length(ADatabase)-Length(ExtractFileExt(ADatabase)))+'.txt';

  // fichier log erreur restore (créé si retore plante)
  AFileLogRest := ExtractFilePath(ADatabase);
  if AFileLogRest[Length(AFileLogRest)]<>'\' then
    AFileLogRest := AFileLogRest+'\';
  AFileLogRest := AFileLogRest+'Log_Restore_'+
                  Copy(ADatabase, 1, Length(ADatabase)-Length(ExtractFileExt(ADatabase)))+'.txt';

  // fichier restore avant renomage
  AFileRest := ChangeFileExt(AdataBase, '_Rest'+ExtractFileExt(AdataBase));
  if FileExists(AFileRest) then
    DeleteFile(AFileRest);

  try
    // arrêt de la base
    Dm_Main.Database.Connected := false;
    if not(Dm_Main.ArretBase(ADataBase)) then
      raise Exception.Create('Problème sur l''arrêt de la base');

    // attente virtuel de l'arret
    Delai := GetTickCount;
    while GetTickCount-Delai<5500 do  // 5sec et...
    begin
      Passe := GetTickCount-Delai;
    end;

    sEtat1 := '('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') Backup de la base';
    sEtat2 := '';
    inc(iProgress);
    Synchronize(UpdateFrm);
    Synchronize(UpdProgressFrm);
    // backup
    if not(Dm_Main.Backup(ADataBase, AFileBack, AFileLogBack, BackupLogArt)) then
      raise Exception.Create('Problème sur le backup de la base: Voir les log');

    sEtat1 := '('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') Restore de la base';
    sEtat2 := '';
    inc(iProgress);
    Synchronize(UpdateFrm);
    Synchronize(UpdProgressFrm);
    // restore
    if not(Dm_Main.Restore(AFileRest, AFileBack, AFileLogRest, BackupLogArt)) then
      raise Exception.Create('Problème sur le restore de la base: Voir les log');

    sEtat1 := '('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') Arrêt de la base';
    sEtat2 := '';
    inc(iProgress);
    Synchronize(UpdateFrm);
    Synchronize(UpdProgressFrm);
    // arrêt de la base
    if not(Dm_Main.ArretBase(ADataBase)) then
      raise Exception.Create('Problème sur l''arrêt de la base');

    // attente virtuel de l'arret
    Delai := GetTickCount;
    while GetTickCount-Delai<5500 do  // 5sec et...
    begin
      Passe := GetTickCount-Delai;
    end;

    sEtat1 := '('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') Démarrage de la base';
    sEtat2 := '';
    inc(iProgress);
    Synchronize(UpdateFrm);
    Synchronize(UpdProgressFrm);
    if FileExists(ADataBase) then
      DeleteFile(ADataBase);
    if FileExists(ADataBase) then
      Raise Exception.Create('Impossible de renommer la base');
    RenameFile(AFileRest, ADataBase);
    Dm_Main.Database.Connected := true;
    Dm_Main.TransacArt.Active := true;

    Result := true;

    sEtat2 := '';
    iProgress := 0;
    Synchronize(UpdProgressFrm);

  except
    on E: Exception do
    begin
      Result := false;
      sError := E.Message;
      DoLog(sError, logError);
      Synchronize(UpdProgressFrm);
      Synchronize(ErrorFrm);
    end;
  end;
end;

// verru relation fournisseur<-->marque intersys
function TRefArticle.TraiterVerruFourMarque: boolean;
begin
  Result := true;

  inc(iTraitement);
  sEtat1 := 'Importation ('+inttostr(iTraitement)+'/'+inttostr(NbTraitement)+') Relation Marque<-->Fournisseur Intersys:';
  sEtat2 := '';
  Synchronize(UpdateFrm);
  Synchronize(InitProgressFrm);
  DoLog(sEtat1, logInfo);

  try
    try
      if not(Dm_Main.TransacArt.InTransaction) then
        Dm_Main.TransacArt.StartTransaction;
      StProc_VerruFouMarque.Close;
      StProc_VerruFouMarque.ExecQuery;
      StProc_VerruFouMarque.Close;
      Dm_Main.TransacArt.Commit;
    except
      on E: Exception do
      begin
        if not(Dm_Main.TransacArt.InTransaction) then
          Dm_Main.TransacArt.Rollback;
        Result := false;
        sError := E.Message;
        DoLog(sError, logError);
        Synchronize(UpdProgressFrm);
        Synchronize(ErrorFrm);
      end;
    end;
  finally
    StProc_VerruFouMarque.Close;
  end;
end;

end.

