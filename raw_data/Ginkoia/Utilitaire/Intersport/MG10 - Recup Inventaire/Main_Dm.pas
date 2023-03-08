unit Main_Dm;

interface

uses
  SysUtils, Classes, DB, IBODataset, IB_Components, IB_Access, MidasLib,
  DBClient;

const
  // liste des noms des fichiers des ID
  ClientsID = 'ClientsID.ID';
  ComptesID = 'ComptesID.ID';

  FournID = 'FournID.ID';
  FournCodeIS = 'FournCode.ID';
  MarqueID = 'MarqueID.ID';
  MarqueCodeIS = 'MarqueCode.ID';
  GrTailleID = 'GrTailleID.ID';
  GrTailleLigID = 'GrTailleLigID.ID';
  DomaineID = 'DomaineID.ID';
  AxeID = 'AxeID.ID';
  AxeNiveau1ID = 'AxeNiveau1ID.ID';
  AxeNiveau2ID = 'AxeNiveau2ID.ID';
  AxeNiveau3ID = 'AxeNiveau3ID.ID';
  AxeNiveau4ID = 'AxeNiveau4ID.ID';
  CollectionID = 'CollectionID.ID';
  CollectionCodeIS = 'CollectionCodeIS.ID';
  GenreID = 'GenreID.ID';
  ArticleID = 'ArticleID.ID';
  ArticleAxeID = 'ArticleAxeID.ID';
  ArticleCollectionID = 'ArticleCollectionID.ID';
  ArticleTailleTravID = 'ArticleTailleTravID.ID';
  CouleurID = 'CouleurID.ID';
  CodeBarreID = 'CodeBarreID.ID';
  PrixAchatID = 'PrixAchatID.ID';
  PrixVenteID = 'PrixVenteID.ID';
  PrixVenteIndicatifID = 'PrixVenteIndicatifID.ID';
  ArticleDeprecieID = 'ArticleDeprecieID.ID';
  FouContactID = 'FouContactID.ID';
  FouConditionID = 'FouConditionID.ID';

  CaisseID = 'CaisseID.ID';
  ReceptionID = 'ReceptionID.ID';
  ConsodivID = 'ConsodivID.ID';
  TransfertID = 'TransfertID.ID';
  CommandesID = 'CommandesID.ID';
  RetourFouID = 'RetourFouID.ID';

type
  TDm_Main = class(TDataModule)
    Database: TIBODatabase;
    Transaction: TIBOTransaction;
    Que_LstInvent: TIBOQuery;
    Que_LstInventINV_ID: TIntegerField;
    Que_LstInventINV_CHRONO: TStringField;
    Que_LstInventINV_COMENT: TMemoField;
    Que_LstInventINV_DATEOUV: TDateField;
    Que_LstInventTRCCOMENT: TStringField;
    TransacRel: TIBOTransaction;
    Cds_MagLiaison: TClientDataSet;
    Cds_MagLiaisonORI_MAGID: TIntegerField;
    Cds_MagLiaisonORI_CODEADH: TStringField;
    Cds_MagLiaisonORI_MAGNOM: TStringField;
    Cds_MagLiaisonORI_MAGENSEIGNE: TStringField;
    Cds_MagLiaisonDST_MAGID: TIntegerField;
    Que_LstInventINV_MAGID: TIntegerField;
    Que_LstInventINV_CLOTURE: TIntegerField;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure Que_LstInventCalcFields(DataSet: TDataSet);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    ReperSavID: string;   // repertoire de sauvegarde des ID généré par raport au code

    // principe des liste des ID
    // code d'import en premier de longueur fixe de 32 caractère
    // puis liste des Id séparé généré par des ;
    ListeIDClient             : TStringList;  // liste Client
    ListeIDComptes            : TStringList;  // liste Comptes
    ListeIDFourn              : TStringList;  // liste Fournisseur
    ListeCodeISFourn          : TStringList;  // liste Fournisseur par code IS
    ListeIDMarque             : TStringList;  // liste Marque
    ListeCodeISMarque         : TStringList;  // liste Marque par code IS
    ListeIDGrTaille           : TStringList;  // liste grille de taille
    ListeIDGrTailleLig        : TStringList;  // liste ligne de taille
    ListeIDDomaine            : TStringList;  // liste Domaine commercial
    ListeIDAxe                : TStringList;  // liste Axe
    ListeIDAxeNiv1            : TStringList;  // liste Axe Niveau 1
    ListeIDAxeNiv2            : TStringList;  // liste Axe Niveau 2
    ListeIDAxeNiv3            : TStringList;  // liste Axe Niveau 3
    ListeIDAxeNiv4            : TStringList;  // liste Axe Niveau 4
    ListeIDCollection         : TStringList;  // Liste Collection
    ListeCodeISCollection     : TStringList;  // Liste Collection
    ListeIDGenre              : TStringList;  // Liste Genre
    ListeIDArticle            : TStringList;  // Liste Article
    ListeIDArticleAxe         : TStringList;  // Liste Article - Axe
    ListeIDTailleTrav         : TStringList;  // Liste Article - Taille Travaillé
    ListeIDArtCollection      : TStringList;  // Liste Article - Collection
    ListeIDCouleur            : TStringList;  // Liste Couleur
    ListeIDCodeBarre          : TStringList;  // Liste Code Barre
    ListeIDPrixAchat          : TStringList;  // Liste Prix d'achat
    ListeIDPrixVente          : TStringList;  // Liste Prix de vente
    ListeIDPrixVenteIndicatif : TStringList;  // Liste Prix de vente indicatif
    ListeIDArtDeprecie        : TStringList;  // Liste Article deprécié
    ListeIDFouContact         : TStringList;  // Liste Contact Fournisseur
    ListeIDFouCondition       : TStringList;  // Liste Condition Fournisseur

    ListeIDCaisse             : TStringList;  // Liste Caisse
    ListeIDReception          : TStringList;  // Liste Réception
    ListeIDConsodiv           : TStringList;  // Liste Consodiv
    ListeIDTransfert          : TStringList;  // Liste Transfert
    ListeIDCommandes          : TStringList;  // Liste Commandes
    ListeIDRetourfou          : TStringList;  // Liste RetourFournisseur

    // fonction sur les Liste ID
    procedure LoadListeID(AListe: TStrings; AFileName: string);
    procedure SaveListeID(AListe: TStrings; AFileName: string);
    function RechercheID(AListe: TStrings; ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeID(AListe: TStrings; ACode: string; AChamps: array of string): integer; overload;
    function AjoutInListeID(AListe: TStrings; ACode: string; AChamps: string): integer; overload;
    function RechercheID64(AListe: TStrings; ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeID64(AListe: TStrings; ACode: string; AChamps: array of string): integer; overload;
    function AjoutInListeID64(AListe: TStrings; ACode: string; AChamps: string): integer; overload;

    // Clients
    procedure LoadListeClientID;
    procedure SaveListeClientID;
    function RechercheClientID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeClientID(ACode: string; ACltID: integer): integer;
    function GetClientID(ACode: string): integer;

    // Comptes
    procedure LoadListeComptesID;
    procedure SaveListeComptesID;
    function RechercheComptesID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeComptesID(ACode: string; ACptID: integer): integer;
    function GetComptesID(ACode: string): integer;

    // fournisseur
    procedure LoadListeFournID;
    procedure LoadListeFournCodeIS;
    procedure SaveListeFournID;
    procedure SaveListeFournCodeIS;
    function RechercheFournID(ACode: string; const ACount: integer = -1): integer;
    function RechercheFournCodeIS(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeFournID(ACode: string; AFouID: integer): integer;
    function AjoutInListeFournCodeIS(ACode: string; AFouID: integer): integer;
    function GetFouID(ACode: string): integer;

    // Marque
    procedure LoadListeMarqueID;
    procedure LoadListeMarqueCodeIS;
    procedure SaveListeMarqueID;
    procedure SaveListeMarqueCodeIS;
    function RechercheMarqueID(ACode: string; const ACount: integer = -1): integer;
    function RechercheMarqueCodeIS(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeMarqueID(ACode: string; AMrkID: integer): integer;
    function AjoutInListeMarqueCodeIS(ACode: string; AMrkID: integer): integer;
    function GetMrkID(ACode: string): integer;

    // grille de taille
    procedure LoadListeGrTailleID;
    procedure SaveListeGrTailleID;
    function RechercheGrTailleID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeGrTailleID(ACode: string; AGtfID, ATgtID: integer): integer;
    function GetGtfID(ACode: string): integer;
    function GetTgtID(ACode: string): integer;

    // ligne de taille
    procedure LoadListeGrTailleLigID;
    procedure SaveListeGrTailleLigID;
    function RechercheGrTailleLigID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeGrTailleLigID(ACode: string; ATgfID, ATgtID: integer): integer;
    function GetTgfID(ACode: string): integer;
    function GetTgsID(ACode: string): integer;

    // Domaine Commercial
    procedure LoadListeDomaineID;
    procedure SaveListeDomaineID;
    function RechercheDomaineID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeDomaineID(ACode: string; AActID: integer): integer;
    function GetActID(ACode: string): integer;

    // Axe
    procedure LoadListeAxeID;
    procedure SaveListeAxeID;
    function RechercheAxeID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeAxeID(ACode: string; AUniID: integer): integer;
    function GetAxeUniID(ACode: string): integer;

    // Axe - Niveau1
    procedure LoadListeAxeNiveau1ID;
    procedure SaveListeAxeNiveau1ID;
    function RechercheAxeNiveau1ID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeAxeNiveau1ID(ACode: string; AUniID, ASecID: integer): integer;
    function GetNiveau1UniID(ACode: string): integer;
    function GetNiveau1SecID(ACode: string): integer;

    // Axe - Niveau2
    procedure LoadListeAxeNiveau2ID;
    procedure SaveListeAxeNiveau2ID;
    function RechercheAxeNiveau2ID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeAxeNiveau2ID(ACode: string; AUniID, ASecID, ARayId: integer): integer;
    function GetNiveau2UniID(ACode: string): integer;
    function GetNiveau2SecID(ACode: string): integer;
    function GetNiveau2RayID(ACode: string): integer;

    // Axe - Niveau3
    procedure LoadListeAxeNiveau3ID;
    procedure SaveListeAxeNiveau3ID;
    function RechercheAxeNiveau3ID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeAxeNiveau3ID(ACode: string; AUniID, ASecID, ARayId, AFamID: integer): integer;
    function GetNiveau3UniID(ACode: string): integer;
    function GetNiveau3SecID(ACode: string): integer;
    function GetNiveau3RayID(ACode: string): integer;
    function GetNiveau3FamID(ACode: string): integer;

    // Axe - Niveau4
    procedure LoadListeAxeNiveau4ID;
    procedure SaveListeAxeNiveau4ID;
    function RechercheAxeNiveau4ID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeAxeNiveau4ID(ACode: string; AUniID, ASecID, ARayId, AFamID, ASsfID: integer): integer;
    function GetNiveau4UniID(ACode: string): integer;
    function GetNiveau4SecID(ACode: string): integer;
    function GetNiveau4RayID(ACode: string): integer;
    function GetNiveau4FamID(ACode: string): integer;
    function GetNiveau4SsfID(ACode: string): integer;

    // Collection
    procedure LoadListeCollectionID;
    procedure LoadListeCollectionCodeIS;
    procedure SaveListeCollectionID;
    procedure SaveListeCollectionCodeIS;
    function RechercheCollectionID(ACode: string; const ACount: integer = -1): integer;
    function RechercheCollectionCodeIS(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeCollectionID(ACode: string; AColID: integer): integer;
    function AjoutInListeCollectionCodeIS(ACode: string; AColID: integer): integer;
    function GetColID(ACode: string): integer;

    // Genre
    procedure LoadListeGenreID;
    procedure SaveListeGenreID;
    function RechercheGenreID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeGenreID(ACode: string; AGreID: integer): integer;
    function GetGreID(ACode: string): integer;

    // Article
    procedure LoadListeArticleID;
    procedure SaveListeArticleID;
    function RechercheArticleID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeArticleID(ACode: string; AArtID, AArfID, AVirtuel: integer): integer;
    function GetArtID(ACode: string): integer;
    function GetArfID(ACode: string): integer;
    function GetArfVirtuel(ACode: string): integer;

    // Relation Article Axe
    procedure LoadListeArtAxeID;
    procedure SaveListeArtAxeID;
    function RechercheArtAxeID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeArtAxeID(ACode: string): integer;

    // Relation Article collection
    procedure LoadListeArtCollectionID;
    procedure SaveListeArtCollectionID;
    function RechercheArtCollectionID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeArtCollectionID(ACode: string): integer;

    // Relation Article taille travaillé
    procedure LoadListeTailleTravID;
    procedure SaveListeTailleTravID;
    function RechercheTailleTravID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeTailleTravID(ACode: string): integer;

    // Couleur
    procedure LoadListeCouleurID;
    procedure SaveListeCouleurID;
    function RechercheCouleurID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeCouleurID(ACode: string; ACouID, AArtID: integer): integer;
    function GetCouID(ACode: string): integer;
    function GetCouArtID(ACode: string): integer;

    // Code barre
    procedure LoadListeCBID;
    procedure SaveListeCBID;
    function RechercheCBID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeCBID(ACode: string): integer;

    // Prix d'achat
    procedure LoadListePrixAchatID;
    procedure SaveListePrixAchatID;
    function RecherchePrixAchatID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListePrixAchatID(AListe: TStrings; ACode: string): integer; overload;
    function AjoutInListePrixAchatID(ACode: string): integer; overload;

    // Prix de vente
    procedure LoadListePrixVenteID;
    procedure SaveListePrixVenteID;
    function RecherchePrixVenteID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListePrixVenteID(AListe: TStrings; ACode: string): integer; overload;
    function AjoutInListePrixVenteID(ACode: string): integer; overload;

    // Prix de vente indicatif
    procedure LoadListePrixVenteIndicatifID;
    procedure SaveListePrixVenteIndicatifID;
    function RecherchePrixVenteIndicatifID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListePrixVenteIndicatifID(AListe: TStrings; ACode: string): integer; overload;
    function AjoutInListePrixVenteIndicatifID(ACode: string): integer; overload;

    // Article deprécié
    procedure LoadListeArticleDeprecieID;
    procedure SaveListeArticleDeprecieID;
    function RechercheArticleDeprecieID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeArticleDeprecieID(ACode: string; ADepID: integer): integer;

    // Contact Fournisseur
    procedure LoadListeFouContactID;
    procedure SaveListeFouContactID;
    function RechercheFouContactID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeFouContactID(ACode: string; AConID: integer): integer;

    // Condition Fournisseur
    procedure LoadListeFouConditionID;
    procedure SaveListeFouConditionID;
    function RechercheFouConditionID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeFouConditionID(ACode: string; AFodID: integer): integer;

    // Caisse
    procedure LoadListeCaisseID;
    procedure SaveListeCaisseID;
    function RechercheCaisseID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeCaisseID(ACode: string): integer;

    // Reception
    procedure LoadListeReceptionID;
    procedure SaveListeReceptionID;
    function RechercheReceptionID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeReceptionID(ACode: string; AID: integer): integer;
    function GetReceptionID(ACode: string): integer;

    // Consodiv
    procedure LoadListeConsodivID;
    procedure SaveListeConsodivID;
    function RechercheConsodivID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeConsodivID(ACode: string): integer;

    // Transfert
    procedure LoadListeTransfertID;
    procedure SaveListeTransfertID;
    function RechercheTransfertID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeTransfertID(ACode: string): integer;

    // Commandes
    procedure LoadListeCommandesID;
    procedure SaveListeCommandesID;
    function RechercheCommandesID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeCommandesID(ACode: string; AID: integer): integer;
    function GetCommandesID(ACode: string): integer;

    // Retour Fournisseur
    procedure LoadListeRetourFouID;
    procedure SaveListeRetourFouID;
    function RechercheRetourFouID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeRetourFouID(ACode: string; AID: integer): integer;
    function GetRetourFouID(ACode: string): integer;

    procedure DoConnexion(ABase: string);
    function GetVersion: string;
  end;

var
  Dm_Main: TDm_Main;
  ReperBase: string;

implementation

{$R *.dfm}

function StrListCompareStrings(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := CompareStr(List[Index1], List[Index2]);
end;

function ResultRechercheDico(AListe: TStrings; iDebut, iFin: integer; sRech: string): integer;
var
  iMilieu: integer;
  sCode: string;
  LStrcomp: integer;
begin
  if (iDebut<=iFin) then
  begin
    iMilieu := (iDebut+iFin) div 2;
    sCode := TStringList(AListe)[iMilieu];

    LStrcomp := CompareStr(sRech, sCode);
    if LStrcomp=0 then           // sCode=sRech
      Result := iMilieu
    else
    begin
      if LStrcomp<0 then     // sRech<sCode
        Result := ResultRechercheDico(AListe, iDebut, iMilieu-1, sRech)
      else
        Result := ResultRechercheDico(AListe, iMilieu+1, iFin, sRech);
    end;
  end
  else
    Result := -1;
end;

function ResultRechercheID(AListe: TStrings; iDebut, iFin: integer; sRech: string): integer;
var
  iMilieu: integer;
  sCode: string;
  LStrcomp: integer;
begin
  if (iDebut<=iFin) then
  begin
    iMilieu := (iDebut+iFin) div 2;
    sCode := TStringList(AListe)[iMilieu];
    if Length(sCode)>32 then
      sCode := copy(sCode, 1, 32);

    LStrcomp := CompareStr(sRech, sCode);
    if LStrcomp=0 then     // sRech=sCode
      Result := iMilieu
    else
    begin
      if LStrcomp<0 then        // sRech<sCode
        Result := ResultRechercheID(AListe, iDebut, iMilieu-1, sRech)
      else
        Result := ResultRechercheID(AListe, iMilieu+1, iFin, sRech);
    end;
  end
  else
    Result := -1;
end;

function ResultRechercheID64(AListe: TStrings; iDebut, iFin: integer; sRech: string): integer;
var
  iMilieu: integer;
  sCode: string;
  LStrcomp: integer;
begin
  if (iDebut<=iFin) then
  begin
    iMilieu := (iDebut+iFin) div 2;
    sCode := TStringList(AListe)[iMilieu];
    if Length(sCode)>64 then
      sCode := copy(sCode, 1, 64);

    LStrcomp := CompareStr(sRech, sCode);
    if LStrcomp=0 then     // sRech=sCode
      Result := iMilieu
    else
    begin
      if LStrcomp<0 then        // sRech<sCode
        Result := ResultRechercheID(AListe, iDebut, iMilieu-1, sRech)
      else
        Result := ResultRechercheID(AListe, iMilieu+1, iFin, sRech);
    end;
  end
  else
    Result := -1;
end;

procedure TDm_Main.DataModuleCreate(Sender: TObject);
begin

  ListeIDClient             := TStringList.Create;
  ListeIDComptes            := TStringList.Create;

  ListeIDFourn              := TStringList.Create;
  ListeCodeISFourn          := TStringList.Create;
  ListeIDMarque             := TStringList.Create;
  ListeCodeISMarque         := TStringList.Create;
  ListeIDGrTaille           := TStringList.Create;
  ListeIDGrTailleLig        := TStringList.Create;
  ListeIDDomaine            := TStringList.Create;
  ListeIDAxe                := TStringList.Create;  // liste Axe
  ListeIDAxeNiv1            := TStringList.Create;  // liste Axe Niveau 1
  ListeIDAxeNiv2            := TStringList.Create;  // liste Axe Niveau 2
  ListeIDAxeNiv3            := TStringList.Create;  // liste Axe Niveau 3
  ListeIDAxeNiv4            := TStringList.Create;  // liste Axe Niveau 4
  ListeIDCollection         := TStringList.Create;
  ListeCodeISCollection     := TStringList.Create;
  ListeIDGenre              := TStringList.Create;
  ListeIDArticle            := TStringList.Create;
  ListeIDArticleAxe         := TStringList.Create;
  ListeIDArtCollection      := TStringList.Create;
  ListeIDTailleTrav         := TStringList.Create;  // Liste Article - Taille Travaillé
  ListeIDCouleur            := TStringList.Create;
  ListeIDCodeBarre          := TStringList.Create;
  ListeIDPrixAchat          := TStringList.Create;
  ListeIDPrixVente          := TStringList.Create;
  ListeIDPrixVenteIndicatif := TStringList.Create;  // Liste Prix de vente indicatif
  ListeIDArtDeprecie        := TStringList.Create;  // Liste Article deprécié
  ListeIDFouContact         := TStringList.Create;  // Liste Contact Fournisseur
  ListeIDFouCondition       := TStringList.Create;  // Liste Condition Fournisseur

  ListeIDCaisse             := TStringList.Create;
  ListeIDReception          := TStringList.Create;
  ListeIDConsodiv           := TStringList.Create;
  ListeIDTransfert          := TStringList.Create;
  ListeIDCommandes          := TStringList.Create;
  ListeIDRetourfou          := TStringList.Create;  // Liste RetourFournisseur

end;

procedure TDm_Main.DataModuleDestroy(Sender: TObject);
begin
  Database.Connected := false;
  FreeAndNil(ListeIDClient);
  FreeAndNil(ListeIDComptes);

  FreeAndNil(ListeIDFourn);
  FreeAndNil(ListeCodeISFourn);
  FreeAndNil(ListeIDMarque);
  FreeAndNil(ListeCodeISMarque);
  FreeAndNil(ListeIDGrTaille);
  FreeAndNil(ListeIDGrTailleLig);
  FreeAndNil(ListeIDDomaine);
  FreeAndNil(ListeIDAxe);
  FreeAndNil(ListeIDAxeNiv1);
  FreeAndNil(ListeIDAxeNiv2);
  FreeAndNil(ListeIDAxeNiv3);
  FreeAndNil(ListeIDAxeNiv4);
  FreeAndNil(ListeIDCollection);
  FreeAndNil(ListeCodeISCollection);
  FreeAndNil(ListeIDGenre);
  FreeAndNil(ListeIDArticle);
  FreeAndNil(ListeIDArticleAxe);
  FreeAndNil(ListeIDArtCollection);
  FreeAndNil(ListeIDTailleTrav);
  FreeAndNil(ListeIDCouleur);
  FreeAndNil(ListeIDCodeBarre);
  FreeAndNil(ListeIDPrixAchat);
  FreeAndNil(ListeIDPrixVente);
  FreeAndNil(ListeIDPrixVenteIndicatif);
  FreeAndNil(ListeIDArtDeprecie);
  FreeAndNil(ListeIDFouContact);
  FreeAndNil(ListeIDFouCondition);

  FreeAndNil(ListeIDCaisse);
  FreeAndNil(ListeIDReception);
  FreeAndNil(ListeIDConsodiv);
  FreeAndNil(ListeIDTransfert);
  FreeAndNil(ListeIDCommandes);
  FreeAndNil(ListeIDRetourfou);
end;

procedure TDm_Main.DoConnexion(ABase: string);
begin
  // retourne la version de la base
  Database.Connected := false;
  Database.Username := 'SYSDBA';
  Database.Password := 'masterkey';
  Database.DatabaseName := ABase;
  Database.Connected := true;
end;

function TDm_Main.GetVersion: string;
var
  QueTmp: TIBOQuery;
begin
  QueTmp := TIBOQuery.Create(Self);
  try
    QueTmp.IB_Connection := Database;
    QueTmp.IB_Transaction := Transaction;
    QueTmp.SQL.Clear;
    QueTmp.SQL.Add('select * from genversion order by ver_date');
    QueTmp.Open;
    QueTmp.Last;
    Result := QueTmp.fieldbyname('VER_VERSION').AsString;
  finally
    QueTmp.Close;
    FreeAndNil(QueTmp);
  end;
end;

// fonction sur les Liste ID
procedure TDm_Main.LoadListeID(AListe: TStrings; AFileName: string);
begin
  AListe.Clear;
  if (AFileName<>'') and (FileExists(AFileName)) then
  begin
    AListe.LoadFromFile(AFileName);
  TStringList(AListe).CustomSort(StrListCompareStrings);
  end;
end;

procedure TDm_Main.SaveListeID(AListe: TStrings; AFileName: string);
begin
  TStringList(AListe).CustomSort(StrListCompareStrings);
  AListe.SaveToFile(AFileName);
end;

function TDm_Main.RechercheID(AListe: TStrings; ACode: string;
  const ACount: integer): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;
  // le code est enregistré de façon fixe en 32 caractère
  sRech := ACode;
  while Length(sRech)<32 do
    sRech := ' '+sRech;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>AListe.Count) then
    iNbreEnre := AListe.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheID(AListe, 0, iNbreEnre-1, sRech);

end;

function TDm_Main.AjoutInListeID(AListe: TStrings; ACode: string; AChamps: array of string): integer;
var
  i: integer;
  sCode: string;
  sChamp: string;
begin
  sCode := ACode;
  while Length(sCode)<32 do
    sCode := ' '+sCode;

  sChamp := '';
  for i := 0 to High(AChamps) do
  begin
    if sChamp<>'' then
      sChamp := sChamp+';';

    sChamp := sChamp+AChamps[i];
  end;
  Result := TStringList(AListe).Add(sCode+sChamp);
end;

function TDm_Main.AjoutInListeID(AListe: TStrings; ACode: string; AChamps: string): integer;
var
  AArray: Array [0..0] of String;
begin
  AArray[0] := AChamps;
  Result := AjoutInListeID(Aliste, ACode, AArray);
end;


function TDm_Main.RechercheID64(AListe: TStrings; ACode: string;
  const ACount: integer): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;
  // le code est enregistré de façon fixe en 64 caractère
  sRech := ACode;
  while Length(sRech)<64 do
    sRech := ' '+sRech;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>AListe.Count) then
    iNbreEnre := AListe.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheID64(AListe, 0, iNbreEnre-1, sRech);

end;

function TDm_Main.AjoutInListeID64(AListe: TStrings; ACode: string; AChamps: array of string): integer;
var
  i: integer;
  sCode: string;
  sChamp: string;
begin
  sCode := ACode;
  while Length(sCode)<64 do
    sCode := ' '+sCode;

  sChamp := '';
  for i := 0 to High(AChamps) do
  begin
    if sChamp<>'' then
      sChamp := sChamp+';';

    sChamp := sChamp+AChamps[i];
  end;
  Result := TStringList(AListe).Add(sCode+sChamp);
end;

function TDm_Main.AjoutInListeID64(AListe: TStrings; ACode: string; AChamps: string): integer;
var
  AArray: Array [0..0] of String;
begin
  AArray[0] := AChamps;
  Result := AjoutInListeID64(Aliste, ACode, AArray);
end;

//********** Client **********//
procedure TDm_Main.LoadListeClientID;
begin
  LoadListeID(ListeIDClient, ReperSavID+ClientsID);
end;

procedure TDm_Main.SaveListeClientID;
begin
  SaveListeID(ListeIDClient, ReperSavID+ClientsID);
end;

function TDm_Main.RechercheClientID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDClient, ACode, ACount);
end;

function TDm_Main.AjoutInListeClientID(ACode: string; ACltID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDClient, ACode, IntToStr(ACltID));
end;

function TDm_Main.GetClientID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheClientID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDClient[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** Client **********//

//********** Comptes **********//
procedure TDm_Main.LoadListeComptesID;
begin
  LoadListeID(ListeIDComptes, ReperSavID+ComptesID);
end;

procedure TDm_Main.SaveListeComptesID;
begin
  SaveListeID(ListeIDComptes, ReperSavID+ComptesID);
end;

function TDm_Main.RechercheComptesID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDComptes, ACode, ACount);
end;

function TDm_Main.AjoutInListeComptesID(ACode: string; ACptID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDComptes, ACode, IntToStr(ACptID));
end;

function TDm_Main.GetComptesID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheComptesID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDComptes[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** Comptes **********//

//********** Fournisseur **********//
procedure TDm_Main.LoadListeFournID;
begin
  LoadListeID(ListeCodeISFourn, ReperSavID+FournCodeIS);
end;

procedure TDm_Main.LoadListeFournCodeIS;
begin
  LoadListeID(ListeIDFourn, ReperSavID+FournID);
end;

procedure TDm_Main.SaveListeFournID;
begin
  SaveListeID(ListeIDFourn, ReperSavID+FournID);
end;

procedure TDm_Main.SaveListeFournCodeIS;
begin
  SaveListeID(ListeCodeISFourn, ReperSavID+FournCodeIS);
end;

function TDm_Main.RechercheFournID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDFourn, ACode, ACount);
end;

function TDm_Main.RechercheFournCodeIS(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeCodeISFourn, ACode, ACount);
end;

function TDm_Main.AjoutInListeFournID(ACode: string; AFouID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDFourn, ACode, IntToStr(AFouID));
end;

function TDm_Main.AjoutInListeFournCodeIS(ACode: string; AFouID: integer): integer;
begin
  Result := AjoutInListeID(ListeCodeISFourn, ACode, IntToStr(AFouID));
end;

function TDm_Main.GetFouID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheFournID(ACode);
  if LPos<>-1 then
  begin
    sLigne :=  ListeIDFourn[LPos];
    if Length(sLigne)>32 then
      sLigne := Copy(sLigne, 33, Length(sLigne));

    Result := StrToIntDef(sLigne, -1);
  end
  else
  begin
    LPos := RechercheFournCodeIS(ACode);
    if LPos=-1 then
      exit;

    sLigne :=  ListeCodeISFourn[LPos];
    if Length(sLigne)>32 then
      sLigne := Copy(sLigne, 33, Length(sLigne));

    Result := StrToIntDef(sLigne, -1);
  end;
end;
//********** Fournisseur **********//

//********** Marque **********//
procedure TDm_Main.LoadListeMarqueID;
begin
  LoadListeID(ListeIDMarque, ReperSavID+MarqueID);
end;

procedure TDm_Main.LoadListeMarqueCodeIS;
begin
  LoadListeID(ListeCodeISMarque, ReperSavID+MarqueCodeIS);
end;

procedure TDm_Main.SaveListeMarqueID;
begin
  SaveListeID(ListeIDMarque, ReperSavID+MarqueID);
end;

procedure TDm_Main.SaveListeMarqueCodeIS;
begin
  SaveListeID(ListeCodeISMarque, ReperSavID+MarqueCodeIS);
end;

function TDm_Main.RechercheMarqueID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDMarque, ACode, ACount);
end;

function TDm_Main.RechercheMarqueCodeIS(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeCodeISMarque, ACode, ACount);
end;

function TDm_Main.AjoutInListeMarqueID(ACode: string; AMrkID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDMarque, ACode, IntToStr(AMrkID));
end;

function TDm_Main.AjoutInListeMarqueCodeIS(ACode: string; AMrkID: integer): integer;
begin
  Result := AjoutInListeID(ListeCodeISMarque, ACode, IntToStr(AMrkID));
end;

function TDm_Main.GetMrkID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheMarqueID(ACode);
  if LPos<>-1 then
  begin
    sLigne :=  ListeIDMarque[LPos];
    if Length(sLigne)>32 then
      sLigne := Copy(sLigne, 33, Length(sLigne));

    Result := StrToIntDef(sLigne, -1);
  end
  else
  begin
    LPos := RechercheMarqueCodeIS(ACode);
    if LPos=-1 then
      exit;

    sLigne :=  ListeCodeISMarque[LPos];
    if Length(sLigne)>32 then
      sLigne := Copy(sLigne, 33, Length(sLigne));

    Result := StrToIntDef(sLigne, -1);
  end;
end;
//********** Marque **********//

// grille de taille
procedure TDm_Main.LoadListeGrTailleID;
begin
  LoadListeID(ListeIDGrTaille, ReperSavID+GrTailleID);
end;

procedure TDm_Main.SaveListeGrTailleID;
begin
  SaveListeID(ListeIDGrTaille, ReperSavID+GrTailleID);
end;

function TDm_Main.RechercheGrTailleID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDGrTaille, ACode, ACount);
end;

function TDm_Main.AjoutInListeGrTailleID(ACode: string; AGtfID, ATgtID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDGrTaille, ACode, [IntToStr(AGtfID), IntToStr(ATgtID)]);
end;

function TDm_Main.GetGtfID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheGrTailleID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDGrTaille[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetTgtID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheGrTailleID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDGrTaille[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

// ligne de taille
procedure TDm_Main.LoadListeGrTailleLigID;
begin
  LoadListeID(ListeIDGrTailleLig, ReperSavID+GrTailleLigID);
end;

procedure TDm_Main.SaveListeGrTailleLigID;
begin
  SaveListeID(ListeIDGrTailleLig, ReperSavID+GrTailleLigID);
end;

function TDm_Main.RechercheGrTailleLigID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDGrTailleLig, ACode, ACount);
end;

function TDm_Main.AjoutInListeGrTailleLigID(ACode: string; ATgfID, ATgtID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDGrTailleLig, ACode, [IntToStr(ATgfID), IntToStr(ATgtID)]);
end;

function TDm_Main.GetTgfID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheGrTailleLigID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDGrTailleLig[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetTgsID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheGrTailleLigID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDGrTailleLig[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

// Domaine commercial
procedure TDm_Main.LoadListeDomaineID;
begin
  LoadListeID(ListeIDDomaine, ReperSavID+DomaineID);
end;

procedure TDm_Main.SaveListeDomaineID;
begin
  SaveListeID(ListeIDDomaine, ReperSavID+DomaineID);
end;

function TDm_Main.RechercheDomaineID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDDomaine, ACode, ACount);
end;

function TDm_Main.AjoutInListeDomaineID(ACode: string; AActID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDDomaine, ACode, IntToStr(AActID));
end;

function TDm_Main.GetActID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheDomaineID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDDomaine[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

// Axe
procedure TDm_Main.LoadListeAxeID;
begin
  LoadListeID(ListeIDAxe, ReperSavID+AxeID);
end;

procedure TDm_Main.SaveListeAxeID;
begin
  SaveListeID(ListeIDAxe, ReperSavID+AxeID);
end;

function TDm_Main.RechercheAxeID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDAxe, ACode, ACount);
end;

function TDm_Main.AjoutInListeAxeID(ACode: string; AUniID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDAxe, ACode, IntToStr(AUniID));
end;

function TDm_Main.GetAxeUniID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxe[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

// Axe - Niveau1
procedure TDm_Main.LoadListeAxeNiveau1ID;
begin
  LoadListeID(ListeIDAxeNiv1, ReperSavID+AxeNiveau1ID);
end;

procedure TDm_Main.SaveListeAxeNiveau1ID;
begin
  SaveListeID(ListeIDAxeNiv1, ReperSavID+AxeNiveau1ID);
end;

function TDm_Main.RechercheAxeNiveau1ID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDAxeNiv1, ACode, ACount);
end;

function TDm_Main.AjoutInListeAxeNiveau1ID(ACode: string; AUniID, ASecID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDAxeNiv1, ACode, [IntToStr(AUniID), IntToStr(ASecID)]);
end;

function TDm_Main.GetNiveau1UniID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau1ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv1[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetNiveau1SecID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau1ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv1[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

// Axe - Niveau2
procedure TDm_Main.LoadListeAxeNiveau2ID;
begin
  LoadListeID(ListeIDAxeNiv2, ReperSavID+AxeNiveau2ID);
end;

procedure TDm_Main.SaveListeAxeNiveau2ID;
begin
  SaveListeID(ListeIDAxeNiv2, ReperSavID+AxeNiveau2ID);
end;

function TDm_Main.RechercheAxeNiveau2ID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDAxeNiv2, ACode, ACount);
end;

function TDm_Main.AjoutInListeAxeNiveau2ID(ACode: string; AUniID, ASecID, ARayId: integer): integer;
begin
  Result := AjoutInListeID(ListeIDAxeNiv2, ACode, [IntToStr(AUniID), IntToStr(ASecID), IntToStr(ARayId)]);
end;

function TDm_Main.GetNiveau2UniID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau2ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv2[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetNiveau2SecID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau2ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv2[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetNiveau2RayID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau2ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv2[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);


  Result := StrToIntDef(sLigne, -1);
end;

// Axe - Niveau3
procedure TDm_Main.LoadListeAxeNiveau3ID;
begin
  LoadListeID(ListeIDAxeNiv3, ReperSavID+AxeNiveau3ID);
end;

procedure TDm_Main.SaveListeAxeNiveau3ID;
begin
  SaveListeID(ListeIDAxeNiv3, ReperSavID+AxeNiveau3ID);
end;

function TDm_Main.RechercheAxeNiveau3ID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDAxeNiv3, ACode, ACount);
end;

function TDm_Main.AjoutInListeAxeNiveau3ID(ACode: string; AUniID, ASecID, ARayId, AFamID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDAxeNiv3, ACode, [IntToStr(AUniID), IntToStr(ASecID), IntToStr(ARayId), IntToStr(AFamID)]);
end;

function TDm_Main.GetNiveau3UniID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau3ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv3[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetNiveau3SecID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau3ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv3[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetNiveau3RayID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau3ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv3[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetNiveau3FamID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau3ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv3[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

// Axe - Niveau4
procedure TDm_Main.LoadListeAxeNiveau4ID;
begin
  LoadListeID(ListeIDAxeNiv4, ReperSavID+AxeNiveau4ID);
end;

procedure TDm_Main.SaveListeAxeNiveau4ID;
begin
  SaveListeID(ListeIDAxeNiv4, ReperSavID+AxeNiveau4ID);
end;

function TDm_Main.RechercheAxeNiveau4ID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDAxeNiv4, ACode, ACount);
end;

function TDm_Main.AjoutInListeAxeNiveau4ID(ACode: string; AUniID, ASecID, ARayId, AFamID, ASsfID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDAxeNiv4, ACode, [IntToStr(AUniID), IntToStr(ASecID),
                                    IntToStr(ARayId), IntToStr(AFamID), IntToStr(ASsfID)]);
end;

function TDm_Main.GetNiveau4UniID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau4ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv4[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetNiveau4SecID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau4ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv4[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetNiveau4RayID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau4ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv4[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetNiveau4FamID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau4ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv4[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetNiveau4SsfID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAxeNiveau4ID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAxeNiv4[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

// Collection
procedure TDm_Main.LoadListeCollectionID;
begin
  LoadListeID(ListeIDCollection, ReperSavID+CollectionID);
end;

procedure TDm_Main.LoadListeCollectionCodeIS;
begin
  LoadListeID(ListeCodeISCollection, ReperSavID+CollectionCodeIS);
end;

procedure TDm_Main.SaveListeCollectionID;
begin
  SaveListeID(ListeIDCollection, ReperSavID+CollectionID);
end;

procedure TDm_Main.SaveListeCollectionCodeIS;
begin
  SaveListeID(ListeCodeISCollection, ReperSavID+CollectionCodeIS);
end;

function TDm_Main.RechercheCollectionID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDCollection, ACode, ACount);
end;

function TDm_Main.RechercheCollectionCodeIS(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeCodeISCollection, ACode, ACount);
end;

function TDm_Main.AjoutInListeCollectionID(ACode: string; AColID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDCollection, ACode, IntToStr(AColID));
end;

function TDm_Main.AjoutInListeCollectionCodeIS(ACode: string; AColID: integer): integer;
begin
  Result := AjoutInListeID(ListeCodeISCollection, ACode, IntToStr(AColID));
end;

function TDm_Main.GetColID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheCollectionID(ACode);
  if LPos<>-1 then
  begin
    sLigne :=  ListeIDCollection[LPos];
    if Length(sLigne)>32 then
      sLigne := Copy(sLigne, 33, Length(sLigne));

    Result := StrToIntDef(sLigne, -1);
  end
  else
  begin
    LPos := RechercheCollectionCodeIS(ACode);
    if LPos=-1 then
      exit;

    sLigne :=  ListeCodeISCollection[LPos];
    if Length(sLigne)>32 then
      sLigne := Copy(sLigne, 33, Length(sLigne));

    Result := StrToIntDef(sLigne, -1);
  end;
end;

// Genre
procedure TDm_Main.LoadListeGenreID;
begin
  LoadListeID(ListeIDGenre, ReperSavID+GenreID);
end;

procedure TDm_Main.SaveListeGenreID;
begin
  SaveListeID(ListeIDGenre, ReperSavID+GenreID);
end;

function TDm_Main.RechercheGenreID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDGenre, ACode, ACount);
end;

function TDm_Main.AjoutInListeGenreID(ACode: string; AGreID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDGenre, ACode, IntToStr(AGreID));
end;

function TDm_Main.GetGreID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheGenreID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDGenre[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

// Article
procedure TDm_Main.LoadListeArticleID;
begin
  LoadListeID(ListeIDArticle, ReperSavID+ArticleID);
end;

procedure TDm_Main.SaveListeArticleID;
begin
  SaveListeID(ListeIDArticle, ReperSavID+ArticleID);
end;

function TDm_Main.RechercheArticleID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDArticle, ACode, ACount);
end;

function TDm_Main.AjoutInListeArticleID(ACode: string; AArtID, AArfID, AVirtuel: integer): integer;
begin
  Result := AjoutInListeID(ListeIDArticle, ACode, [IntToStr(AArtID), IntToStr(AArfID), IntToStr(AVirtuel)]);
end;

function TDm_Main.GetArtID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheArticleID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDArticle[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetArfID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheArticleID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDArticle[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetArfVirtuel(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheArticleID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDArticle[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, 0);
end;

// Relation Article Axe
procedure TDm_Main.LoadListeArtAxeID;
begin
  LoadListeID(ListeIDArticleAxe, ReperSavID+ArticleAxeID);
end;

procedure TDm_Main.SaveListeArtAxeID;
begin
  SaveListeID(ListeIDArticleAxe, ReperSavID+ArticleAxeID);
end;

function TDm_Main.RechercheArtAxeID(ACode: string; const ACount: integer = -1): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDArticleAxe.Count) then
    iNbreEnre := ListeIDArticleAxe.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDArticleAxe, 0, iNbreEnre-1, sRech);
end;

function TDm_Main.AjoutInListeArtAxeID(ACode: string): integer;
begin
  Result := ListeIDArticleAxe.Add(ACode);
end;

// Relation Article collection
procedure TDm_Main.LoadListeArtCollectionID;
begin
  LoadListeID(ListeIDArtCollection, ReperSavID+ArticleCollectionID);
end;

procedure TDm_Main.SaveListeArtCollectionID;
begin
  SaveListeID(ListeIDArtCollection, ReperSavID+ArticleCollectionID);
end;

function TDm_Main.RechercheArtCollectionID(ACode: string; const ACount: integer = -1): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDArtCollection.Count) then
    iNbreEnre := ListeIDArtCollection.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDArtCollection, 0, iNbreEnre-1, sRech);
end;

function TDm_Main.AjoutInListeArtCollectionID(ACode: string): integer;
begin
  Result := ListeIDArtCollection.Add(ACode);
end;

// Relation Article taille travaillé
procedure TDm_Main.LoadListeTailleTravID;
begin
  LoadListeID(ListeIDTailleTrav, ReperSavID+ArticleTailleTravID);
end;

procedure TDm_Main.SaveListeTailleTravID;
begin
  SaveListeID(ListeIDTailleTrav, ReperSavID+ArticleTailleTravID);
end;

function TDm_Main.RechercheTailleTravID(ACode: string; const ACount: integer = -1): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDTailleTrav.Count) then
    iNbreEnre := ListeIDTailleTrav.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDTailleTrav, 0, iNbreEnre-1, sRech);
end;

function TDm_Main.AjoutInListeTailleTravID(ACode: string): integer;
begin
  Result := ListeIDTailleTrav.Add(ACode);
end;

// Couleur
procedure TDm_Main.LoadListeCouleurID;
begin
  LoadListeID(ListeIDCouleur, ReperSavID+CouleurID);
end;

procedure TDm_Main.SaveListeCouleurID;
begin
  SaveListeID(ListeIDCouleur, ReperSavID+CouleurID);
end;

function TDm_Main.RechercheCouleurID(ACode: string; const ACount: integer = -1): integer;
begin
  Result := RechercheID(ListeIDCouleur, ACode, ACount);
end;

function TDm_Main.AjoutInListeCouleurID(ACode: string; ACouID, AArtID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDCouleur, ACode, [IntToStr(ACouID), IntToStr(AArtID)]);
end;

function TDm_Main.GetCouID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheCouleurID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDCouleur[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);

  Result := StrToIntDef(sLigne, -1);
end;

function TDm_Main.GetCouArtID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheCouleurID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDCouleur[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  if Pos(';', sLigne)>0 then
    sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

// Code barre
procedure TDm_Main.LoadListeCBID;
begin
  LoadListeID(ListeIDCodeBarre, ReperSavID+CodeBarreID);
end;

procedure TDm_Main.SaveListeCBID;
begin
  SaveListeID(ListeIDCodeBarre, ReperSavID+CodeBarreID);
end;

function TDm_Main.RechercheCBID(ACode: string; const ACount: integer = -1): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDCodeBarre.Count) then
    iNbreEnre := ListeIDCodeBarre.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDCodeBarre, 0, iNbreEnre-1, sRech);

end;

function TDm_Main.AjoutInListeCBID(ACode: string): integer;
begin
  Result := ListeIDCodeBarre.Add(ACode);
end;

// Prix d'achat
procedure TDm_Main.LoadListePrixAchatID;
begin
  LoadListeID(ListeIDPrixAchat, ReperSavID+PrixAchatID);
end;

procedure TDm_Main.SaveListePrixAchatID;
begin
  SaveListeID(ListeIDPrixAchat, ReperSavID+PrixAchatID);
end;

function TDm_Main.RecherchePrixAchatID(ACode: string; const ACount: integer = -1): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDPrixAchat.Count) then
    iNbreEnre := ListeIDPrixAchat.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDPrixAchat, 0, iNbreEnre-1, sRech);
end;

function TDm_Main.AjoutInListePrixAchatID(AListe: TStrings; ACode: string): integer;
begin
  Result := AListe.Add(ACode);
end;

function TDm_Main.AjoutInListePrixAchatID(ACode: string): integer;
begin
  Result := AjoutInListePrixAchatID(ListeIDPrixAchat, ACode);
end;

// Prix de vente
procedure TDm_Main.LoadListePrixVenteID;
begin
  LoadListeID(ListeIDPrixVente, ReperSavID+PrixVenteID);
end;

procedure TDm_Main.SaveListePrixVenteID;
begin
  SaveListeID(ListeIDPrixVente, ReperSavID+PrixVenteID);
end;

function TDm_Main.RecherchePrixVenteID(ACode: string; const ACount: integer = -1): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDPrixVente.Count) then
    iNbreEnre := ListeIDPrixVente.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDPrixVente, 0, iNbreEnre-1, sRech);
end;

function TDm_Main.AjoutInListePrixVenteID(AListe: TStrings; ACode: string): integer;
begin
  Result := AListe.Add(ACode);
end;

function TDm_Main.AjoutInListePrixVenteID(ACode: string): integer;
begin
  Result := AjoutInListePrixVenteID(ListeIDPrixVente, ACode);
end;

// Prix de vente indicatif
procedure TDm_Main.LoadListePrixVenteIndicatifID;
begin
  LoadListeID(ListeIDPrixVenteIndicatif, ReperSavID+PrixVenteIndicatifID);
end;

procedure TDm_Main.SaveListePrixVenteIndicatifID;
begin
  SaveListeID(ListeIDPrixVenteIndicatif, ReperSavID+PrixVenteIndicatifID);
end;

function TDm_Main.RecherchePrixVenteIndicatifID(ACode: string; const ACount: integer = -1): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDPrixVenteIndicatif.Count) then
    iNbreEnre := ListeIDPrixVenteIndicatif.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDPrixVenteIndicatif, 0, iNbreEnre-1, sRech);
end;

function TDm_Main.AjoutInListePrixVenteIndicatifID(AListe: TStrings; ACode: string): integer;
begin
  Result := AListe.Add(ACode);
end;

function TDm_Main.AjoutInListePrixVenteIndicatifID(ACode: string): integer;
begin
  Result := AjoutInListePrixVenteIndicatifID(ListeIDPrixVenteIndicatif, ACode);
end;

// Article deprécié
procedure TDm_Main.LoadListeArticleDeprecieID;
begin
  LoadListeID(ListeIDArtDeprecie, ReperSavID+ArticleDeprecieID);
end;

procedure TDm_Main.SaveListeArticleDeprecieID;
begin
  SaveListeID(ListeIDArtDeprecie, ReperSavID+ArticleDeprecieID);
end;

function TDm_Main.RechercheArticleDeprecieID(ACode: string; const ACount: integer = -1): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDArtDeprecie.Count) then
    iNbreEnre := ListeIDArtDeprecie.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDArtDeprecie, 0, iNbreEnre-1, sRech);
end;

function TDm_Main.AjoutInListeArticleDeprecieID(ACode: string; ADepID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDArtDeprecie, ACode, inttostr(ADepID));
end;

// Contact Fournisseur
procedure TDm_Main.LoadListeFouContactID;
begin
  LoadListeID(ListeIDFouContact, ReperSavID+FouContactID);
end;

procedure TDm_Main.SaveListeFouContactID;
begin
  SaveListeID(ListeIDFouContact, ReperSavID+FouContactID);
end;

function TDm_Main.RechercheFouContactID(ACode: string; const ACount: integer = -1): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDFouContact.Count) then
    iNbreEnre := ListeIDFouContact.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDFouContact, 0, iNbreEnre-1, sRech);
end;

function TDm_Main.AjoutInListeFouContactID(ACode: string; AConID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDFouContact, ACode, inttostr(AConID));
end;

// Condition Fournisseur
procedure TDm_Main.LoadListeFouConditionID;
begin
  LoadListeID(ListeIDFouCondition, ReperSavID+FouConditionID);
end;

procedure TDm_Main.SaveListeFouConditionID;
begin
  SaveListeID(ListeIDFouCondition, ReperSavID+FouConditionID);
end;

function TDm_Main.RechercheFouConditionID(ACode: string; const ACount: integer = -1): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDFouCondition.Count) then
    iNbreEnre := ListeIDFouCondition.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDFouCondition, 0, iNbreEnre-1, sRech);
end;

function TDm_Main.AjoutInListeFouConditionID(ACode: string; AFodID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDFouCondition, ACode, inttostr(AFodID));
end;

//********** Caisse **********//
procedure TDm_Main.LoadListeCaisseID;
begin
  LoadListeID(ListeIDCaisse, ReperSavID+CaisseID);
end;

procedure TDm_Main.SaveListeCaisseID;
begin
  SaveListeID(ListeIDCaisse, ReperSavID+CaisseID);
end;

function TDm_Main.RechercheCaisseID(ACode: string;
  const ACount: integer): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDCaisse.Count) then
    iNbreEnre := ListeIDCaisse.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDCaisse, 0, iNbreEnre-1, sRech);
end;

function TDm_Main.AjoutInListeCaisseID(ACode: string): integer;
begin
  Result := ListeIDCaisse.Add(ACode);
end;
//********** Caisse **********//

//********** Reception **********//
procedure TDm_Main.LoadListeReceptionID;
begin
  LoadListeID(ListeIDReception, ReperSavID+ReceptionID);
end;

procedure TDm_Main.SaveListeReceptionID;
begin
  SaveListeID(ListeIDReception, ReperSavID+ReceptionID);
end;

function TDm_Main.RechercheReceptionID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID64(ListeIDReception, ACode, ACount);
end;

function TDm_Main.AjoutInListeReceptionID(ACode: string; AID: integer): integer;
begin
  Result := AjoutInListeID64(ListeIDReception, ACode, IntToStr(AID));
end;

function TDm_Main.GetReceptionID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheReceptionID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDReception[LPos];
  if Length(sLigne)>64 then
    sLigne := Copy(sLigne, 65, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** Reception **********//

//********** Consodiv **********//
procedure TDm_Main.LoadListeConsodivID;
begin
  LoadListeID(ListeIDConsodiv, ReperSavID+ConsodivID);
end;

procedure TDm_Main.SaveListeConsodivID;
begin
  SaveListeID(ListeIDConsodiv, ReperSavID+ConsodivID);
end;

function TDm_Main.RechercheConsodivID(ACode: string;
  const ACount: integer): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDConsodiv.Count) then
    iNbreEnre := ListeIDConsodiv.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDConsodiv, 0, iNbreEnre-1, sRech);
end;

function TDm_Main.AjoutInListeConsodivID(ACode: string): integer;
begin
  Result := ListeIDConsodiv.Add(ACode);
end;
//********** Consodiv **********//

//********** Transfert **********//
procedure TDm_Main.LoadListeTransfertID;
begin
  LoadListeID(ListeIDTransfert, ReperSavID+TransfertID);
end;

procedure TDm_Main.Que_LstInventCalcFields(DataSet: TDataSet);
var
  s: string;
begin
  s := Que_LstInvent.FieldByName('INV_COMENT').AsString;
  if Length(s)>255 then
    s := Copy(s, 1, 255);
  Que_LstInvent.FieldByName('TRCCOMENT').AsString := s;
end;

procedure TDm_Main.SaveListeTransfertID;
begin
  SaveListeID(ListeIDTransfert, ReperSavID+TransfertID);
end;

function TDm_Main.RechercheTransfertID(ACode: string;
  const ACount: integer): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDTransfert.Count) then
    iNbreEnre := ListeIDTransfert.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDTransfert, 0, iNbreEnre-1, sRech);

end;

function TDm_Main.AjoutInListeTransfertID(ACode: string): integer;
begin
  Result := ListeIDTransfert.Add(ACode);
end;
//********** Transfert **********//

//********** Commandes **********//
procedure TDm_Main.LoadListeCommandesID;
begin
  LoadListeID(ListeIDCommandes, ReperSavID+CommandesID);
end;

procedure TDm_Main.SaveListeCommandesID;
begin
  SaveListeID(ListeIDCommandes, ReperSavID+CommandesID);
end;

function TDm_Main.RechercheCommandesID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDCommandes, ACode, ACount);
end;

function TDm_Main.AjoutInListeCommandesID(ACode: string; AID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDCommandes, ACode, IntToStr(AID));
end;

function TDm_Main.GetCommandesID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheCommandesID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDCommandes[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** Commandes **********//


//********** Retour Fournisseur **********//
procedure TDm_Main.LoadListeRetourFouID;
begin
  LoadListeID(ListeIDRetourFou, ReperSavID+RetourFouID);
end;

procedure TDm_Main.SaveListeRetourFouID;
begin
  SaveListeID(ListeIDRetourFou, ReperSavID+RetourFouID);
end;

function TDm_Main.RechercheRetourFouID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDRetourFou, ACode, ACount);
end;

function TDm_Main.AjoutInListeRetourFouID(ACode: string; AID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDRetourFou, ACode, IntToStr(AID));
end;

function TDm_Main.GetRetourFouID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheRetourFouID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDRetourFou[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** Retour Fournisseur **********//

end.
