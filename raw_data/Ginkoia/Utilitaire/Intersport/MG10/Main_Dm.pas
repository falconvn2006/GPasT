unit Main_Dm;

interface

uses
  SysUtils, Classes, IB_Components, IB_Access, IBODataset, DB, ADODB, IBDatabase,
  IBSQL, Forms, DBClient, IBCustomDataSet, IBStoredProc, IBQuery, IBServices,
  IniFiles, Variants, Dialogs;

const
  // liste des noms des fichiers des ID
  ClientsID = 'ClientsID.ID';
  LienClientsID = 'LienClientsID.ID';
  ComptesID = 'ComptesID.ID';
  FideliteID = 'FideliteID.ID';
  BonAchatsID = 'BonAchatsID.ID';

  FournID = 'FournID.ID';
  FournCodeIS = 'FournCode.ID';
  MarqueID = 'MarqueID.ID';
  FouMrkID = 'FouMrkID.ID';
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
  ArtIdealID = 'ArtIdealID.ID';
  OcTeteID = 'OcTeteID.ID';
  OcLignesID = 'OcLignesID.ID';

  CaisseID = 'CaisseID.ID';
  ReceptionID = 'ReceptionID.ID';
  ReceptionLigneID = 'ReceptionLigneID.ID';
  ConsodivID = 'ConsodivID.ID';
  TransfertID = 'TransfertID.ID';
  CommandesID = 'CommandesID.ID';
  RetourFouID = 'RetourFouID.ID';
  RetourFouLigneID = 'RetourFouLigneID.ID';
  AvoirID = 'AvoirID.ID';
  BonLivraisonID = 'BonLivraisonID.ID';
  BonLivraisonLID = 'BonLivraisonLID.ID';
  BonLivraisonHistoID = 'BonLivraisonHistoID.ID';

  BonRapprochementID = 'BonRapprochementID.ID';
  BonRapprochementLienID = 'BonRapprochementLienID.ID';
  BonRapprochementTVAID = 'BonRapprochementTVAID.ID';
  BonRapprochementLigneReceptionID = 'BonRapprochementLigneReceptionID.ID';
  BonRapprochementLigneRetourID = 'BonRapprochementLigneRetourID.ID';

  SavTauxHID = 'SavTauxHID.ID';
  SavForfaitID = 'SavForfaitID.ID';
  SavForfaitLID = 'SavForfaitLID.ID';
  SavPt1ID = 'SavPt1ID.ID';
  SavPt2ID = 'SavPt2ID.ID';
  SavTypMatID = 'SavTypMatID.ID';
  SavTypeID = 'SavTypeID.ID';
  SavMatID = 'SavMatID.ID';
  SavCbID = 'SavCbID.ID';
  SavFicheeID = 'SavFicheeID.ID';
  SavFicheLID = 'SavFicheLID.ID';
  SavFicheArtID = 'SavFicheArtID.ID';

type
  TImportProvenance = ( ipUnderterminate, ipGinkoia, ipInterSys, ipOldGoSport, ipDataMag, ipNosymag, ipExotiqueISF, ipLocalBase, ipGoSport );

  TProcLogBackRest = procedure (ALigneLog: string);

  TDm_Main = class(TDataModule)
    Database: TIBDatabase;
    Transaction: TIBTransaction;
    Que_ListeMag: TIBQuery;
    ds_ListeMag: TDataSource;
    TransacArt: TIBTransaction;
    TransacCli: TIBTransaction;
    TransacHis: TIBTransaction;
    GrpPump: TClientDataSet;
    GrpPumpMPU_MAGID: TIntegerField;
    GrpPumpMPU_GCPID: TIntegerField;
    TARCLGFOURN: TClientDataSet;
    TARCLGFOURNCLG_ARTID: TIntegerField;
    TARCLGFOURNCLG_TGFID: TIntegerField;
    TARCLGFOURNCLG_COUID: TIntegerField;
    TARCLGFOURNACHAT: TFloatField;
    TARCLGFOURNCLG_PXNEGO: TFloatField;
    TARCLGFOURNCLG_TAXE: TFloatField;
    TARCLGFOURNCLG_RA1: TFloatField;
    TARCLGFOURNCLG_RA2: TFloatField;
    TARCLGFOURNCLG_RA3: TFloatField;
    TARACHATCOUR: TClientDataSet;
    TARACHATCOURPAC_ARTID: TIntegerField;
    TARACHATCOURPAC_TGFID: TIntegerField;
    TARACHATCOURPAC_COUID: TIntegerField;
    TARACHATCOURPAC_PX: TFloatField;
    TARACHATCOURPAC_PXN: TFloatField;
    TARACHATCOURPAC_PXNN: TFloatField;
    TARACHATCOURPAC_DATE: TDateTimeField;
    AgrHistoStk: TClientDataSet;
    AgrHistoStkRecNo: TIntegerField;
    AgrHistoStkMAGID: TIntegerField;
    AgrHistoStkTGFID: TIntegerField;
    AgrHistoStkCOUID: TIntegerField;
    AgrHistoStkDATEMVT: TDateTimeField;
    AgrHistoStkARTID: TIntegerField;
    AgrHistoStkDATEFIN: TDateTimeField;
    AgrHistoStkTYPETBL: TIntegerField;
    AgrHistoStkQTEMVT: TIntegerField;
    AgrHistoStkQTEFIN: TIntegerField;
    AgrHistoStkPUMP: TFloatField;
    AgrHistoStkPUMPTOT: TFloatField;
    AgrStockFin: TClientDataSet;
    AgrStockFinRecNo: TIntegerField;
    AgrStockFinMAGID: TIntegerField;
    AgrStockFinTGFID: TIntegerField;
    AgrStockFinCOUID: TIntegerField;
    AgrStockFinDATEMVT: TDateTimeField;
    AgrStockFinDATEFIN: TDateTimeField;
    AgrStockFinQTEMVT: TIntegerField;
    AgrStockFinQTEFIN: TIntegerField;
    AgrStockFinTSTHSTQTE: TIntegerField;
    AgrStockFinPUMP: TFloatField;
    AgrStockFinTSTHSTPUMP: TFloatField;
    AgrStockFinOLDQTE: TIntegerField;
    AgrStockFinOLDPUMP: TFloatField;
    AgrStockFinTSTOLDQTE: TIntegerField;
    AgrStockFinTSTOLDPUMP: TFloatField;
    CUMUMPUMP: TClientDataSet;
    CUMUMPUMPGCPID: TIntegerField;
    CUMUMPUMPMAGID: TIntegerField;
    CUMUMPUMPTGFID: TIntegerField;
    CUMUMPUMPCOUID: TIntegerField;
    CUMUMPUMPDATEMVT: TDateTimeField;
    CUMUMPUMPDATEFIN: TDateTimeField;
    CUMUMPUMPQTE_E: TIntegerField;
    CUMUMPUMPQTE_S: TIntegerField;
    CUMUMPUMPQTE_FIN: TIntegerField;
    CUMUMPUMPCUMPUMP: TFloatField;
    CUMUMPUMPPUMP: TFloatField;
    AgrStockCourt: TClientDataSet;
    AgrStockCourtMAGID: TIntegerField;
    AgrStockCourtTGFID: TIntegerField;
    AgrStockCourtCOUID: TIntegerField;
    AgrStockCourtQTE: TIntegerField;
    AgrStockCourtPUMP: TFloatField;
    AgrStockCourtBVALID: TBooleanField;
    ISFMVTBI: TClientDataSet;
    ISFMVTBIIMB_MAGID: TIntegerField;
    ISFMVTBIIMB_TGFID: TIntegerField;
    ISFMVTBIIMB_COUID: TIntegerField;
    ISFMVTBIIMB_DATE: TDateTimeField;
    Que_TarVente: TIBQuery;
    Que_GENTRIGGER: TIBQuery;
    Que_Tmp: TIBQuery;
    IBSql_Couleur: TIBSQL;
    AgrStockFinINITIAL: TIntegerField;
    TransacBonR: TIBTransaction;
    TransacAtelier: TIBTransaction;
    DatabaseSysdba: TIBDatabase;
    TransactionSysdba: TIBTransaction;

    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);

  private
    iMagID  : Integer;
    NivSend : Integer;     // Quel niveau d'envoi.
    MailLst : string;      // liste des destinataires des mails de transpo.
    Subject : string;      // Sujet du mail le nom du client.

  public
    ReperBase: string;    // repertoire de base du prog
    ReperSavID: string;   // repertoire de sauvegarde des ID généré par raport au code

    // principe des liste des ID
    // code d'import en premier de longueur fixe de 32 caractère
    // puis liste des Id séparé généré par des ;
    ListeIDClient             : TStringList;  // liste Client
    ListeIDLienClient         : TStringList;  // liste LienClient
    ListeIDComptes            : TStringList;  // liste Comptes
    ListeIDFidelite           : TStringList;  // liste Fidélité
    ListeIDBonAchats          : TStringList;  // liste Bon Achats
    ListeIDFourn              : TStringList;  // liste Fournisseur
    ListeCodeISFourn          : TStringList;  // liste Fournisseur par code IS
    ListeIDMarque             : TStringList;  // liste Marque
    ListeIDFouMrk             : TStringList;  // Liste Fournisseur Marque
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
    ListeIDArtIdeal           : TStringList;  // Liste ArtIdeal
    ListeIDOcTete             : TStringList;  // Liste OcTete
    ListeIDOcLignes           : TStringList;  // Liste OcLignes
    ListeIDCaisse             : TStringList;  // Liste Caisse
    ListeIDReception          : TStringList;  // Liste Réception
    ListeIDLigneReception     : TStringList;  // Liste Ligne réception
    ListeIDConsodiv           : TStringList;  // Liste Consodiv
    ListeIDTransfert          : TStringList;  // Liste Transfert
    ListeIDCommandes          : TStringList;  // Liste Commandes
    ListeIDRetourfou          : TStringList;  // Liste RetourFournisseur
    ListeIDLigneRetourfou     : TStringList;  // Liste Ligne retour fournisseur
    ListeIDAvoir              : TStringList;  // Liste Avoir
    ListeIDBonLivraison       : TStringList;  // Liste BonLivraison
    ListeIDBonLivraisonL      : TStringList;  // Liste BonLivraisonL
    ListeIDBonLivraisonHisto  : TStringList;  // Liste BonLivraisonHisto
    ListeIDBonRapprochement: TStringList;   // Liste bons rapprochement.
    ListeIDBonRapprochementLien: TStringList;   // Liste liens bons rapprochement.
    ListeIDBonRapprochementTVA: TStringList;   // Liste TVA bons rapprochement.
    ListeIDBonRapprochementLigneReception: TStringList;   // Liste lignes réception bons rapprochement.
    ListeIDBonRapprochementLigneRetour: TStringList;   // Liste lignes retour bons rapprochement.
    ListeIDSavTauxH: TStringList;   // Liste de SavTauxH
    ListeIDSavForfait: TStringList; // Liste de SavForfait
    ListeIDSavForfaitL: TStringList;    // Liste de SavForfaitL
    ListeIDSavPt1: TStringList; // Liste de SavPt1
    ListeIDSavPt2: TStringList; // Liste de SavPt2
    ListeIDSavTypMat: TStringList;  // Liste de SavTypMat
    ListeIDSavType: TStringList;    // Liste de SavType
    ListeIDSavMat: TStringList; // Liste de SavMat
    ListeIDSavCb: TStringList;  // Liste de SavCb
    ListeIDSavFichee: TStringList;  // Liste de SavFichee
    ListeIDSavFicheL: TStringList;  // Liste de SavFicheL
    ListeIDSavFicheArt: TStringList;    // Liste de SavFicheArt

    Provenance: TImportProvenance;
    OkTousMag: Boolean;
    OkDeGinkoia: Boolean;
    MagCodeAdh: string;
    TvtID: Integer;
    NePasFaireLeStock: Boolean;
    SecondImport: Boolean;

    PathBase: string;

    property MagID : Integer  Read iMagID Write iMagID;

    // Init Mail
    procedure InitMail;
    function GetMailLst:string;
    function GetDoMail(aNiv:Integer):Boolean;
    procedure SetNivSend(aNiv:Integer);
    procedure SetSubjectMail(aSubject:string);
    function GetSubjectMail:string;

    // Ouverture de la base de données IB
    function OpenIBDatabase(ABasePath : String) : Boolean;
    function CloseIBDatabase : Boolean;

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

    // LienClients
    procedure LoadListeLienClientID;
    procedure SaveListeLienClientID;
    function RechercheLienClientID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeLienClientID(ACode: string; APRMID: integer): integer;

    // Comptes
    procedure LoadListeComptesID;
    procedure SaveListeComptesID;
    function RechercheComptesID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeComptesID(ACode: string; ACptID: integer): integer;
    function GetComptesID(ACode: string): integer;

    // Fidélité
    procedure LoadListeFideliteID;
    procedure SaveListeFideliteID;
    function RechercheFideliteID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeFideliteID(ACode: string; AFidID: integer): integer;
    function GetFideliteID(ACode: string): integer;

    // Bon d'achats
    procedure LoadListeBonAchatsID;
    procedure SaveListeBonAchatsID;
    function RechercheBonAchatsID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeBonAchatsID(ACode: string; ABacID: integer): integer;
    function GetBonAchatsID(ACode: string): integer;

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

    // Relation Marque Fournisseur
    procedure LoadListeFouMrkID;
    procedure SaveListeFouMrkID;
    function RechercheFouMrkID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeFouMrkID(ACode: string; AFmkID: integer): integer;


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
    function GetCaisseID(ACode: String): Integer;

    // Reception
    procedure LoadListeReceptionID;
    procedure SaveListeReceptionID;
    function RechercheReceptionID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeReceptionID(ACode: string; AID: integer): integer;
    function GetReceptionID(ACode: string): integer;

    // Ligne réception.
    procedure LoadListeLigneReceptionID;
    procedure SaveListeLigneReceptionID;
    function RechercheLigneReceptionID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeLigneReceptionID(ACode: String; AID: Integer): Integer;
    function GetLigneReceptionID(ACode: String): Integer;

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

    // Ligne retour fournisseur
    procedure LoadListeLigneRetourFouID;
    procedure SaveListeLigneRetourFouID;
    function RechercheLigneRetourFouID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeLigneRetourFouID(ACode: String; AID: Integer): Integer;
    function GetLigneRetourFouID(ACode: String): Integer;

    // Avoir
    procedure LoadListeAvoirID;
    procedure SaveListeAvoirID;
    function RechercheAvoirID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeAvoirID(ACode: string; AID: integer): integer;
    function GetAvoirID(ACode: string): integer;

    // BonLivraison
    procedure LoadListeBonLivraisonID;
    procedure SaveListeBonLivraisonID;
    function RechercheBonLivraisonID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeBonLivraisonID(ACode: string; AID: integer): integer;
    function GetBonLivraisonID(ACode: string): integer;

    // BonLivraisonL
    procedure LoadListeBonLivraisonLID;
    procedure SaveListeBonLivraisonLID;
    function RechercheBonLivraisonLID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeBonLivraisonLID(ACode: string; AID: integer): integer;
    function GetBonLivraisonLID(ACode: string): integer;

    // BonLivraisonHisto
    procedure LoadListeBonLivraisonHistoID;
    procedure SaveListeBonLivraisonHistoID;
    function RechercheBonLivraisonHistoID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeBonLivraisonHistoID(ACode: string; AID: integer): integer;
    function GetBonLivraisonHistoID(ACode: string): integer;

    // ArtIdeal
    procedure LoadListeArtIdealID;
    procedure SaveListeArtIdealID;
    function RechercheArtIdealID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeArtIdealID(ACode: string; AArtIdealID: integer): integer;
    function GetArtIdealID(ACode: string): integer;

    // OcTete
    procedure LoadListeOcTeteID;
    procedure SaveListeOcTeteID;
    function RechercheOcTeteID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeOcTeteID(ACode: string; AOcTeteID: integer): integer;
    function GetOcTeteID(ACode: string): integer;

    // OcLignes
    procedure LoadListeOcLignesID;
    procedure SaveListeOcLignesID;
    function RechercheOcLignesID(ACode: string; const ACount: integer = -1): integer;
    function AjoutInListeOcLignesID(ACode: string; AOcLignesID: integer): integer;
    function GetOcLignesID(ACode: string): integer;

    // Bon rapprochement.
    procedure LoadListeBonRapprochementID;
    procedure SaveListeBonRapprochementID;
    function RechercheBonRapprochementID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeBonRapprochementID(ACode: String; ABonRapprochementID: Integer): Integer;
    function GetBonRapprochementID(ACode: String): Integer;

    // Bon rapprochement lien.
    procedure LoadListeBonRapprochementLienID;
    procedure SaveListeBonRapprochementLienID;
    function RechercheBonRapprochementLienID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeBonRapprochementLienID(ACode: String; ABonRapprochementLienID: Integer): Integer;
    function GetBonRapprochementLienID(ACode: String): Integer;

    // Bon rapprochement TVA.
    procedure LoadListeBonRapprochementTVAID;
    procedure SaveListeBonRapprochementTVAID;
    function RechercheBonRapprochementTVAID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeBonRapprochementTVAID(ACode: String; ABonRapprochementTVAID: Integer): Integer;
    function GetBonRapprochementTVAID(ACode: String): Integer;

    // Bon rapprochement ligne réception.
    procedure LoadListeBonRapprochementLigneReceptionID;
    procedure SaveListeBonRapprochementLigneReceptionID;
    function RechercheBonRapprochementLigneReceptionID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeBonRapprochementLigneReceptionID(ACode: String; ABonRapprochementLigneReceptionID: Integer): Integer;
    function GetBonRapprochementLigneReceptionID(ACode: String): Integer;

    // Bon rapprochement ligne retour.
    procedure LoadListeBonRapprochementLigneRetourID;
    procedure SaveListeBonRapprochementLigneRetourID;
    function RechercheBonRapprochementLigneRetourID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeBonRapprochementLigneRetourID(ACode: String; ABonRapprochementLigneRetourID: Integer): Integer;
    function GetBonRapprochementLigneRetourID(ACode: String): Integer;

    // SavTauxH.
    procedure LoadListeSavTauxHID;
    procedure SaveListeSavTauxHID;
    function RechercheSavTauxHID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeSavTauxHID(ACode: String; ASavTauxHID: Integer): Integer;
    function GetSavTauxHID(ACode: String): Integer;

    // SavForfait.
    procedure LoadListeSavForfaitID;
    procedure SaveListeSavForfaitID;
    function RechercheSavForfaitID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeSavForfaitID(ACode: String; ASavForfaitID: Integer): Integer;
    function GetSavForfaitID(ACode: String): Integer;

    // SavForfaitL.
    procedure LoadListeSavForfaitLID;
    procedure SaveListeSavForfaitLID;
    function RechercheSavForfaitLID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeSavForfaitLID(ACode: String; ASavForfaitLID: Integer): Integer;
    function GetSavForfaitLID(ACode: String): Integer;

    // SavPt1.
    procedure LoadListeSavPt1ID;
    procedure SaveListeSavPt1ID;
    function RechercheSavPt1ID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeSavPt1ID(ACode: String; ASavPt1ID: Integer): Integer;
    function GetSavPt1ID(ACode: String): Integer;

    // SavPt2.
    procedure LoadListeSavPt2ID;
    procedure SaveListeSavPt2ID;
    function RechercheSavPt2ID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeSavPt2ID(ACode: String; ASavPt2ID: Integer): Integer;
    function GetSavPt2ID(ACode: String): Integer;

    // SavTypMat.
    procedure LoadListeSavTypMatID;
    procedure SaveListeSavTypMatID;
    function RechercheSavTypMatID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeSavTypMatID(ACode: String; ASavTypMatID: Integer): Integer;
    function GetSavTypMatID(ACode: String): Integer;

    // SavType.
    procedure LoadListeSavTypeID;
    procedure SaveListeSavTypeID;
    function RechercheSavTypeID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeSavTypeID(ACode: String; ASavTypeID: Integer): Integer;
    function GetSavTypeID(ACode: String): Integer;

    // SavMat.
    procedure LoadListeSavMatID;
    procedure SaveListeSavMatID;
    function RechercheSavMatID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeSavMatID(ACode: String; ASavMatID: Integer): Integer;
    function GetSavMatID(ACode: String): Integer;

    // SavCb.
    procedure LoadListeSavCbID;
    procedure SaveListeSavCbID;
    function RechercheSavCbID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeSavCbID(ACode: String; ASavCbID: Integer): Integer;
    function GetSavCbID(ACode: String): Integer;

    // SavFichee.
    procedure LoadListeSavFicheeID;
    procedure SaveListeSavFicheeID;
    function RechercheSavFicheeID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeSavFicheeID(ACode: String; ASavFicheeID: Integer): Integer;
    function GetSavFicheeID(ACode: String): Integer;

    // SavFicheL.
    procedure LoadListeSavFicheLID;
    procedure SaveListeSavFicheLID;
    function RechercheSavFicheLID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeSavFicheLID(ACode: String; ASavFicheLID: Integer): Integer;
    function GetSavFicheLID(ACode: String): Integer;

    // SavFicheArt.
    procedure LoadListeSavFicheArtID;
    procedure SaveListeSavFicheArtID;
    function RechercheSavFicheArtID(ACode: String; const ACount: Integer = -1): Integer;
    function AjoutInListeSavFicheArtID(ACode: String; ASavFicheArtID: Integer): Integer;
    function GetSavFicheArtID(ACode: String): Integer;

    // backup-restore
    function ArretBase(AFileBase: string): boolean;
    function Backup(AFileBase, AFileBack, AFileLog: string; ALogProc: TProcLogBackRest): boolean; overload;
    function Backup(AFileBase, AFileBack: string; ALogProc: TProcLogBackRest): boolean; overload;
    function Restore(AFileBase, AFileBack, AFileLog: string; ALogProc: TProcLogBackRest): boolean; overload;
    function Restore(AFileBase, AFileBack: string; ALogProc: TProcLogBackRest): boolean; overload;

    // Genparam
    function GetGenParamFloat(ACode, AType : Integer):Double;

    // recalcul du stock
    procedure DoRecalculStock(AArtID: integer; bOkBI: boolean);

    function DoDstGrpPump: boolean;
  end;

var
  Dm_Main: TDm_Main;

implementation

{$R *.dfm}

{ TDataModule1 }

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

function TDm_Main.DoDstGrpPump: boolean;
var
  sTmp: string;
  QueTmp: TIBQuery;
begin
  if not(Dm_Main.Database.Connected) then
  begin
    Result := false;
    exit;
  end;

  Result := true;
  sTmp := '';
  QueTmp := TIBQuery.Create(Self);
  try
    QueTmp.Database := Database;
    QueTmp.Transaction := Transaction;
    // test sur les groupe de pump
    with QueTmp, SQL do
    begin
      Close;
      Clear;
      Add('select GCP_ID from GENGESTIONPUMP');
      Add('  join k on k_id=gcp_id and k_enabled=1');
      Add(' where GCP_ID<>0');
      try
        Open;
        Result := (RecordCount>0);
        if RecordCount=0 then
          sTmp := 'Pas de groupe de Pump défini.';
        Close;
      except
        Result := false;
        sTmp   := 'Impossible de tester le groupe de Pump.';
      end;
    end;
    // test sur l'affection des magasins à un groupe de pump
    if Result then
    begin
      try
        with QueTmp, SQL do
        begin
          Close;
          Clear;
          Add('select MAG_ID, MAG_ENSEIGNE, MPU_ID from GENMAGASIN');
          Add('  join k on k_id=mag_id and k_enabled=1');
          Add('  left join GENMAGGESTIONPUMP on MPU_MAGID=MAG_ID');
          Add(' where MAG_ID<>0');
          Open;
          while not(eof) do
          begin
            if (FieldByName('MPU_ID').IsNull) or (FieldByName('MPU_ID').AsInteger=0) then
            begin
              sTmp   := 'Au moins un magasin n''est pas affecté à un groupe de Pump.';
              Result := false;
            end;
            Next;
          end;
          Close;
        end;
      except
        Result := false;
        sTmp   := 'Impossible de tester les magasins aux groupes de Pump.';
      end;
    end;
  finally
    QueTmp.Close;
    FreeAndNil(QueTmp);
  end;

  if not Result then  //Test KO
  begin
    MessageDlg('Attention: ' + sTmp, mtWarning, [mbok], 0);
  end;
end;

procedure TDm_Main.DoRecalculStock(AArtID: integer; bOkBI: boolean);
var
  Sel_SQL: TIBQuery;
  Sel_SQL2: TIBQuery;
  Sel_SQL3: TIBQuery;
  Que_Upd: TIBQuery;
  iMagID: integer;
  iArtID: integer;
  iTgfId: integer;
  iCouId: integer;
  dMvt: TDateTime;
  Qte: integer;
  PmpTot: Double;
  Px, PxN, PxNN: Double;
  ListeID: TStringList;
  ListeMagID: TStringList;
  iGcpId: integer;
  sTmp: string;
  i: integer;
  Sql_PxAchat: TIBQuery;
  IdStkFin: integer;
  IdHstStk: integer;
  iRecNoHstStk: integer;
  iRecNoStkFin: integer;
  dDate: TDateTime;
  iOldStock: integer;
  vOldPump: Double;
  iQte_S: integer;
  iQte_E: integer;
  vValeur: double;
  iNewStockPump: integer;
  vNewPump: double;
  iHstId: integer;
  iStcId: integer;
  iPacId: integer;
  Jour, Mois, Annee: Word;

  function ConvertInterFloat(AValeur: Double): string;
  begin
    Result := FloatToStr(AValeur);
    if Pos(',', Result)>0 then
      Result[Pos(',', Result)] := '.';
    Result := QuotedStr(Result);
  end;

  function GetPxAchat(ATgfId, ACouId: integer): Double;
  var
    TmpTgfId: integer;
    TmpCouId: integer;
  begin
    Result := 0.0;
    TmpTgfId := ATgfId;
    TmpCouId := ACouId;
    if Sql_PxAchat.Locate('CLG_TGFID;CLG_COUID', VarArrayOf([TmpTgfId, TmpCouId]), []) then
    begin
      Result := Sql_PxAchat.fieldbyname('CLG_PXNEGO').AsFloat
                +Sql_PxAchat.fieldbyname('CLG_TAXE').AsFloat
                -Sql_PxAchat.fieldbyname('CLG_RA1').AsFloat
                -Sql_PxAchat.fieldbyname('CLG_RA2').AsFloat
                -Sql_PxAchat.fieldbyname('CLG_RA3').AsFloat;
      exit;
    end;
    TmpCouId := 0;
    if Sql_PxAchat.Locate('CLG_TGFID;CLG_COUID', VarArrayOf([TmpTgfId, TmpCouId]), []) then
    begin
      Result := Sql_PxAchat.fieldbyname('CLG_PXNEGO').AsFloat
                +Sql_PxAchat.fieldbyname('CLG_TAXE').AsFloat
                -Sql_PxAchat.fieldbyname('CLG_RA1').AsFloat
                -Sql_PxAchat.fieldbyname('CLG_RA2').AsFloat
                -Sql_PxAchat.fieldbyname('CLG_RA3').AsFloat;
      exit;
    end;
    TmpTgfId := 0;
    if Sql_PxAchat.Locate('CLG_TGFID;CLG_COUID', VarArrayOf([TmpTgfId, TmpCouId]), []) then
    begin
      Result := Sql_PxAchat.fieldbyname('CLG_PXNEGO').AsFloat
                +Sql_PxAchat.fieldbyname('CLG_TAXE').AsFloat
                -Sql_PxAchat.fieldbyname('CLG_RA1').AsFloat
                -Sql_PxAchat.fieldbyname('CLG_RA2').AsFloat
                -Sql_PxAchat.fieldbyname('CLG_RA3').AsFloat;
      exit;
    end;
  end;

  function GetPXNNAchatCour(ATgfId, ACouId: integer): Double;
  var
    TmpTgfId: integer;
    TmpCouId: integer;
  begin
    // Suite à une decision prise le 15/03/2012 le dernier prix d'achat courant
    // et le prix négocié de la fiche article. Cette décision a été prise suite
    // au modification de calcul du PUMP par sandrine et bruno
    Result := 0.0;
    TmpTgfId := ATgfId;
    TmpCouId := ACouId;
    if Sql_PxAchat.Locate('CLG_TGFID;CLG_COUID', VarArrayOf([TmpTgfId, TmpCouId]), []) then
    begin
      Result := Sql_PxAchat.fieldbyname('CLG_PXNEGO').AsFloat;
      exit;
    end;
    TmpCouId := 0;
    if Sql_PxAchat.Locate('CLG_TGFID;CLG_COUID', VarArrayOf([TmpTgfId, TmpCouId]), []) then
    begin
      Result := Sql_PxAchat.fieldbyname('CLG_PXNEGO').AsFloat;
      exit;
    end;
    TmpTgfId := 0;
    if Sql_PxAchat.Locate('CLG_TGFID;CLG_COUID', VarArrayOf([TmpTgfId, TmpCouId]), []) then
    begin
      Result := Sql_PxAchat.fieldbyname('CLG_PXNEGO').AsFloat;
      exit;
    end;
  end;

  procedure  Last_PumpGrpHisto(AGcpId, ATgfId, ACouId: integer; AdMvt: TDateTime; var R_QTE: integer; var R_PUMP: Double);
  var
    bOkPump: boolean;
    //iSavId: integer;
    dLgh_Date: TDateTime;
    bOk: boolean;
  begin
    R_QTE  := 0;
    R_PUMP := 0.0;
    dLgh_Date := Trunc(AdMvt)-1;

    bOkPump := false;
    if CUMUMPUMP.Locate('GCPID;TGFID;COUID', VarArrayOf([AGcpId, ATgfId, ACouId]), []) then
    begin
      bOk := true;
      while not(CUMUMPUMP.Eof) and bOk and not(bOkPump) do
      begin
        if (AGcpId<>CUMUMPUMP.FieldByName('GCPID').AsInteger)
            or (ATgfId<>CUMUMPUMP.FieldByName('TGFID').AsInteger)
            or (ACouId<>CUMUMPUMP.FieldByName('COUID').AsInteger) then
          bOk := false;
        if bOk and (CUMUMPUMP.FieldByName('DATEMVT').AsDateTime<=dLgh_Date)
            and (CUMUMPUMP.FieldByName('DATEFIN').AsDateTime>=dLgh_Date)
            and not(CUMUMPUMP.FieldByName('PUMP').IsNull) then
        begin
          bOkPump := true;
          R_QTE := CUMUMPUMP.FieldByName('QTE_FIN').AsInteger;
          R_PUMP := CUMUMPUMP.FieldByName('PUMP').AsFloat;
        end;
        CUMUMPUMP.Next;
      end;
    end;
    // Si on a trouvé des lignes alors c'est fini
    if bOkPump then
      exit;

    R_PUMP := GetPxAchat(ATgfId, ACouId);

  end;

  function GetQteSortieParGrp(AGcpId, ATgfId, ACouId: integer; AdMvt: TDateTime): integer;
  begin
    Result := 0;
    if CUMUMPUMP.Locate('GCPID;TGFID;COUID;DATEMVT', VarArrayOf([AGcpId, ATgfId, ACouId, AdMvt]), []) then
      Result := CUMUMPUMP.FieldByName('QTE_S').AsInteger;
  end;

  procedure GetQteEntreeParGrp(AGcpId, ATgfId, ACouId: integer; AdMvt: TDateTime; var R_QTE: integer; var R_PUMP: Double);
  begin
    R_QTE := 0;
    R_PUMP := 0.0;
    if CUMUMPUMP.Locate('GCPID;TGFID;COUID;DATEMVT', VarArrayOf([AGcpId, ATgfId, ACouId, AdMvt]), []) then
    begin
      R_QTE := CUMUMPUMP.FieldByName('QTE_E').AsInteger;
      R_PUMP := CUMUMPUMP.FieldByName('CUMPUMP').AsFloat;
    end;
  end;

//  procedure IsfMvtBI_Add_Mvt(AMagId, ATgfId, ACouId: integer; AdMvt: TDateTime);
//  begin
//    if ISFMVTBI.Locate('IMB_MAGID;IMB_TGFID;IMB_COUID', VarArrayOf([AMagId, ATgfId, ACouId]), []) then
//    begin
//      if Trunc(ISFMVTBI.FieldByName('IMB_DATE').AsDateTime)>Trunc(AdMvt) then
//      begin
//        ISFMVTBI.Edit;
//        ISFMVTBI.FieldByName('IMB_DATE').AsDateTime := Trunc(AdMvt);
//        ISFMVTBI.Post;
//      end
//    end
//    else
//    begin
//      ISFMVTBI.Append;
//      ISFMVTBI.FieldByName('IMB_MAGID').AsInteger := AMagId;
//      ISFMVTBI.FieldByName('IMB_TGFID').AsInteger := ATgfId;
//      ISFMVTBI.FieldByName('IMB_COUID').AsInteger := ACouId;
//      ISFMVTBI.FieldByName('IMB_DATE').AsDateTime := Trunc(AdMvt);
//      ISFMVTBI.Post;
//    end;
//  end;

begin
  iArtID := AArtID;
  TARCLGFOURN.Close;
  TARCLGFOURN.DisableControls;
  TARCLGFOURN.IndexFieldNames := '';
  TARCLGFOURN.Open;
  TARCLGFOURN.LogChanges := False;
  TARCLGFOURN.EmptyDataSet;

//  TARACHATCOUR.Close;
//  TARACHATCOUR.DisableControls;
//  TARACHATCOUR.IndexFieldNames := '';
//  TARACHATCOUR.Open;
//  TARACHATCOUR.EmptyDataSet;

  IdHstStk := 0;
  AgrHistoStk.Close;
  AgrHistoStk.DisableControls;
  AgrHistoStk.IndexFieldNames := '';
  AgrHistoStk.Open;
  AgrHistoStk.LogChanges := False;
  AgrHistoStk.EmptyDataSet;

  IdStkFin := 0;
  AgrStockFin.Close;
  AgrStockFin.DisableControls;
  AgrStockFin.IndexFieldNames := '';
  AgrStockFin.Open;
  AgrStockFin.LogChanges := False;
  AgrStockFin.EmptyDataSet;

  AgrStockCourt.Close;
  AgrStockCourt.DisableControls;
  AgrStockCourt.IndexFieldNames := '';
  AgrStockCourt.Open;
  AgrStockCourt.LogChanges := False;
  AgrStockCourt.EmptyDataSet;

  CUMUMPUMP.Close;
  CUMUMPUMP.DisableControls;
  CUMUMPUMP.IndexFieldNames := '';
  CUMUMPUMP.Open;
  CUMUMPUMP.LogChanges := False;
  CUMUMPUMP.EmptyDataSet;

  GrpPump.Close;
  GrpPump.DisableControls;
  GrpPump.IndexFieldNames := '';
  GrpPump.Open;
  GrpPump.LogChanges := False;
  GrpPump.EmptyDataSet;

//  GrpPump.Close;                //SR - Tiens 2 fois de suite pas utile je pense je mets en commentaire.
//  GrpPump.DisableControls;
//  GrpPump.IndexFieldNames := '';
//  GrpPump.Open;
//  GrpPump.EmptyDataSet;

//  ISFMVTBI.Close;
//  ISFMVTBI.DisableControls;
//  ISFMVTBI.IndexFieldNames := 'IMB_MAGID;IMB_TGFID;IMB_COUID';
//  ISFMVTBI.Open;
//  ISFMVTBI.EmptyDataSet;

  ListeID := TStringList.Create.Create;
  ListeMagID := TStringList.Create.Create;
  Sel_SQL := TIBQuery.Create(Self);
  Sel_SQL2 := TIBQuery.Create(Self);
  Sel_SQL3 := TIBQuery.Create(Self);
  Sql_PxAchat := TIBQuery.Create(Self);

  if AArtID = 170153042 then    //SR 04/02/2016 Pour Diag
    Sleep(1);


  Que_Upd := TIBQuery.Create(Self);
  try
    // initialisation
    Sel_SQL.Database := DataBase;
    Sel_SQL.Transaction := Transaction;
    Sel_SQL2.Database := DataBase;
    Sel_SQL2.Transaction := Transaction;
    Sel_SQL3.Database := DataBase;
    Sel_SQL3.Transaction := Transaction;
    Sql_PxAchat.Database := DataBase;
    Sql_PxAchat.Transaction := Transaction;
    Que_Upd.Database := DataBase;
    Que_Upd.Transaction := TransacHis;

    //  si c'est pseudo (virtuel) on sort
    with Sel_SQL do
    begin
      SQL.Clear;
      SQL.Add('SELECT ARF_VIRTUEL FROM ARTREFERENCE');
      SQL.Add(' where ARF_ARTID='+inttostr(iArtId));
      Open;
      if FieldByName('ARF_VIRTUEL').AsInteger=1 then
      begin
        Close;
        exit;
      end;
      Close;
    end;

    // preparation prix d'achat
    with Sql_PxAchat do
    begin
      SQL.Clear;
      SQL.Add('SELECT CLG_TGFID, CLG_COUID, '+
              'CLG_PXNEGO,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE FROM TARCLGFOURN');
      SQL.Add('  JOIN K ON (K_ID = CLG_ID AND K_ENABLED = 1)');
      SQL.Add(' WHERE CLG_ARTID='+inttostr(iArtId));
      SQL.Add('   and CLG_PRINCIPAL=1');
      Open;

      // a enlever plus tard (c juste pour les tarif)
      First;
      while not(Eof) do
      begin
        TARCLGFOURN.Append;
        TARCLGFOURN.FieldByName('CLG_ARTID').AsInteger := iArtId;
        TARCLGFOURN.FieldByName('CLG_TGFID').AsInteger := FieldByName('CLG_TGFID').AsInteger;
        TARCLGFOURN.FieldByName('CLG_COUID').AsInteger := FieldByName('CLG_COUID').AsInteger;
        TARCLGFOURN.FieldByName('ACHAT').AsFloat := fieldbyname('CLG_PXNEGO').AsFloat
                                                   +fieldbyname('CLG_TAXE').AsFloat
                                                   -fieldbyname('CLG_RA1').AsFloat
                                                   -fieldbyname('CLG_RA2').AsFloat
                                                   -fieldbyname('CLG_RA3').AsFloat;
        TARCLGFOURN.FieldByName('CLG_PXNEGO').AsFloat := FieldByName('CLG_PXNEGO').AsFloat;
        TARCLGFOURN.FieldByName('CLG_TAXE').AsFloat := FieldByName('CLG_TAXE').AsFloat;
        TARCLGFOURN.FieldByName('CLG_RA1').AsFloat := FieldByName('CLG_RA1').AsFloat;
        TARCLGFOURN.FieldByName('CLG_RA2').AsFloat := FieldByName('CLG_RA2').AsFloat;
        TARCLGFOURN.FieldByName('CLG_RA3').AsFloat := FieldByName('CLG_RA3').AsFloat;
        TARCLGFOURN.Post;
        Next;
      end;
    end;

    // préparation groupe de pump
    with Sel_SQL do
    begin
      SQL.Clear;
      SQL.Add('SELECT MPU_MAGID,MPU_GCPID FROM GENMAGGESTIONPUMP');
      SQL.Add('  JOIN K ON K_ID=MPU_ID AND K_ENABLED=1');
      SQL.Add(' where mpu_id<>0');
      Open;
      First;
      while not(Eof) do
      begin
        GrpPump.Append;
        GrpPump.FieldByName('MPU_MAGID').AsInteger := FieldByName('MPU_MAGID').AsInteger;
        GrpPump.FieldByName('MPU_GCPID').AsInteger := FieldByName('MPU_GCPID').AsInteger;
        GrpPump.Post;
        Next;
      end;
      Close;
    end;
    GrpPump.IndexFieldNames := 'MPU_MAGID';

    // construction Stock Courant
    // preparation SQL
    with Sel_SQL do  // taille
    begin
      SQL.Clear;
      SQL.Add('select TTV_TGFID');
      SQL.Add('   from  PLXTAILLESTRAV  JOIN K ON (K_ID=TTV_ID AND K_ENABLED=1)');
      SQL.Add('  where TTV_ARTID = '+inttostr(iArtID));
    end;
    with Sel_SQL2 do  // magasin
    begin
      SQL.Clear;
      SQL.Add('select MAG_ID');
      SQL.Add('  from genmagasin join k on (k_id = mag_id and k_enabled=1)');
      SQL.Add(' where mag_id<>0');
    end;
    with Sel_SQL3 do  // couleur
    begin
      SQL.Clear;
      SQL.Add('select COU_ID');
      SQL.Add('   from plxcouleur JOIN K ON(K_ID=COU_ID AND K_ENABLED=1)');
      SQL.Add(' where COU_ARTID='+inttostr(iArtID));
    end;

    // remplissage
    Sel_SQL.Open;
    Sel_SQL2.Open;
    Sel_SQL3.Open;
    Sel_SQL.First;
    while not(Sel_SQL.Eof) do
    begin
      Sel_SQL2.First;
      while not(Sel_SQL2.Eof) do
      begin
        Sel_SQL3.First;
        while not(Sel_SQL3.Eof) do
        begin
          AgrStockCourt.Append;
          AgrStockCourt.FieldByName('MAGID').AsInteger := Sel_SQL2.FieldByName('MAG_ID').AsInteger;
          AgrStockCourt.FieldByName('TGFID').AsInteger := Sel_SQL.FieldByName('TTV_TGFID').AsInteger;
          AgrStockCourt.FieldByName('COUID').AsInteger := Sel_SQL3.FieldByName('COU_ID').AsInteger;
          AgrStockCourt.FieldByName('QTE').AsInteger := 0;
          AgrStockCourt.FieldByName('PUMP').AsFloat := 0.0;
          AgrStockCourt.FieldByName('BVALID').AsBoolean := false;
          AgrStockCourt.Post;
          Sel_SQL3.Next;
        end;
        Sel_SQL2.Next;
      end;
      Sel_SQL.Next;
    end;

    // Recuperation des stock initial d'archivage !


    // reception   type =1
    with Sel_SQL do
    begin
      SQL.Clear;
      SQL.Add('select BRE_ID, BRE_MAGID, BRE_DATE, BRL_TGFID, BRL_COUID, SUM(BRL_QTE) as QTE, '+
                      'SUM(BRL_QTE*BRL_PXCTLG) as CTLG, '+
                      'SUM(BRL_QTE*BRL_PXACHAT) as ACHAT, '+
                      'SUM(BRL_QTE*BRL_PXNN) as VALEUR ');
      SQL.Add('  from RECBR join k on (k_id=BRE_ID and K_ENABLED=1)');
      SQL.Add('  Join RECBRL join k on (k_id=BRL_ID and K_ENABLED=1)');
      SQL.Add('    on (BRl_breid = BRE_ID)');
      SQL.Add('  Where BRL_ARTID = '+inttostr(iArtID));
      SQL.Add('  group by BRE_ID, BRE_MAGID, BRE_DATE, BRL_TGFID, BRL_COUID');
      Open;
      First;
      While not(Eof) do
      begin
        if (FieldByName('QTE').AsInteger<>0) then
        begin
          iMagId := FieldByName('BRE_MAGID').AsInteger;
          iTgfId := FieldByName('BRL_TGFID').AsInteger;
          iCouId := FieldByName('BRL_COUID').AsInteger;
          dMvt   := FieldByName('BRE_DATE').AsDatetime;
          inc(IdHstStk);
          AgrHistoStk.Append;
          AgrHistoStk.FieldByName('RecNo').AsInteger := IdHstStk;
          AgrHistoStk.FieldByName('MAGID').AsInteger := iMagId;
          AgrHistoStk.FieldByName('TGFID').AsInteger := iTgfId;
          AgrHistoStk.FieldByName('COUID').AsInteger := iCouId;
          AgrHistoStk.FieldByName('DATEMVT').AsDateTime := dMvt;
          AgrHistoStk.FieldByName('ARTID').AsInteger := iArtID;
          AgrHistoStk.FieldByName('TYPETBL').AsInteger := 1;
          AgrHistoStk.FieldByName('QTEMVT').AsInteger := FieldByName('QTE').AsInteger;
          AgrHistoStk.FieldByName('PUMPTOT').AsFloat := FieldByName('VALEUR').AsFloat;
          PmpTot := 0;
          if Abs(FieldByName('VALEUR').AsFloat)>=0.01 then
            PmpTot := FieldByName('VALEUR').AsFloat/FieldByName('QTE').AsInteger;
          AgrHistoStk.FieldByName('PUMP').AsFloat := PmpTot;

          AgrHistoStk.Post;

//          // Pour Export BI
//          if bOkBI then
//            IsfMvtBI_Add_Mvt(iMagId, iTgfId, iCouId, dMvt);

          // affectation à agrhistostock pour le groupe de pump
          GrpPump.Locate('MPU_MAGID', iMagId, []);
          iGcpId := GrpPump.FieldByName('MPU_GCPID').AsInteger;
          GrpPump.First;
          while not(GrpPump.Eof) do
          begin
            if (GrpPump.FieldByName('MPU_GCPID').AsInteger=iGcpId) then
            begin
              if not(AgrStockFin.Locate('MAGID;TGFID;COUID;DATEMVT',
                       VarArrayOf([GrpPump.FieldByName('MPU_MAGID').AsInteger, iTgfId, iCouId, dMvt]), [])) then
              begin
                inc(IdStkFin);
                AgrStockFin.Append;
                AgrStockFin.FieldByName('RecNo').AsInteger := IdStkFin;
                AgrStockFin.FieldByName('MAGID').AsInteger := GrpPump.FieldByName('MPU_MAGID').AsInteger;
                AgrStockFin.FieldByName('TGFID').AsInteger := iTgfId;
                AgrStockFin.FieldByName('COUID').AsInteger := iCouId;
                AgrStockFin.FieldByName('DATEMVT').AsDateTime := dMvt;
                AgrStockFin.FieldByName('QTEMVT').AsInteger := 0;
                AgrStockFin.FieldByName('INITIAL').AsInteger := 0;
                AgrStockFin.Post;
              end;
            end;
            GrpPump.Next;
          end;

          // cumul de pump
          if CUMUMPUMP.Locate('GCPID;TGFID;COUID;DATEMVT', VarArrayOf([iGcpId, iTgfId, iCouId, dMvt]), []) then
          begin
            CUMUMPUMP.Edit;
            CUMUMPUMP.FieldByName('QTE_E').AsInteger := CUMUMPUMP.FieldByName('QTE_E').AsInteger+
                                                        FieldByName('QTE').AsInteger;
            CUMUMPUMP.FieldByName('CUMPUMP').AsFloat := CUMUMPUMP.FieldByName('CUMPUMP').AsFloat+
                                                        FieldByName('VALEUR').AsFloat;
            CUMUMPUMP.Post;
          end
          else
          begin
            CUMUMPUMP.Append;
            CUMUMPUMP.FieldByName('GCPID').AsInteger := iGcpId;
            CUMUMPUMP.FieldByName('TGFID').AsInteger := iTgfId;
            CUMUMPUMP.FieldByName('COUID').AsInteger := iCouId;
            CUMUMPUMP.FieldByName('DATEMVT').AsDateTime := dMvt;
            CUMUMPUMP.FieldByName('QTE_E').AsInteger := FieldByName('QTE').AsInteger;
            CUMUMPUMP.FieldByName('CUMPUMP').AsFloat := FieldByName('VALEUR').AsFloat;
            CUMUMPUMP.Post;
          end;

          // TARACHATCOUR
  //        Px := 0;
  //        if Abs(FieldByName('CTLG').AsFloat)>=0.01 then
  //          Px := FieldByName('CTLG').AsFloat/FieldByName('QTE').AsInteger;
  //        PxN := 0;
  //        if Abs(FieldByName('ACHAT').AsFloat)>=0.01 then
  //          PxN := FieldByName('ACHAT').AsFloat/FieldByName('QTE').AsInteger;
  //        PxNN := PmpTot;
  //        if not(TARACHATCOUR.Locate('PAC_ARTID;PAC_TGFID;PAC_COUID',
  //                       VarArrayOf([iArtId, FieldByName('BRL_TGFID').AsInteger,
  //                                   FieldByName('BRL_COUID').AsInteger]), [])) then
  //        begin
  //          TARACHATCOUR.Append;
  //          TARACHATCOUR.FieldByName('PAC_ARTID').AsInteger := iArtId;
  //          TARACHATCOUR.FieldByName('PAC_TGFID').AsInteger := FieldByName('BRL_TGFID').AsInteger;
  //          TARACHATCOUR.FieldByName('PAC_COUID').AsInteger := FieldByName('BRL_COUID').AsInteger;
  //          TARACHATCOUR.FieldByName('PAC_PX').AsFloat := Px;
  //          TARACHATCOUR.FieldByName('PAC_PXN').AsFloat := PxN;
  //          TARACHATCOUR.FieldByName('PAC_PXNN').AsFloat := PxNN;
  //          TARACHATCOUR.FieldByName('PAC_DATE').AsDateTime := Trunc(FieldByName('BRE_DATE').AsDateTime);
  //          TARACHATCOUR.Post;
  //        end
  //        else
  //        begin
  //          if TARACHATCOUR.FieldByName('PAC_DATE').AsDateTime <= Trunc(FieldByName('BRE_DATE').AsDateTime) then
  //          begin
  //            TARACHATCOUR.Edit;
  //            TARACHATCOUR.FieldByName('PAC_PX').AsFloat := Px;
  //            TARACHATCOUR.FieldByName('PAC_PXN').AsFloat := PxN;
  //            TARACHATCOUR.FieldByName('PAC_PXNN').AsFloat := PxNN;
  //            TARACHATCOUR.FieldByName('PAC_DATE').AsDateTime := Trunc(FieldByName('BRE_DATE').AsDateTime);
  //            TARACHATCOUR.Post;
  //          end;
  //        end;
        end;

        Next;
      end;
      Close;
    end;

    // transfert intermag type = 2: entrée ; type = 3: sortie
    with Sel_SQL do
    begin
      SQL.Clear;
      SQL.Add('Select IMA_MAGOID, IMA_MAGDID, IMA_DATE, IML_TGFID, IML_COUID, SUM(IML_QTE) as QTE,SUM(IML_QTE*IML_PXNN) as VALEUR');
      SQL.Add('from transfertim Join K on (K_ID = IMA_ID and K_ENABLED=1)');
      SQL.Add('  join transfertiml Join K on (K_ID = IMl_ID and K_ENABLED=1)');
      SQL.Add('     on (IML_IMAID = IMA_ID)');
      SQL.Add('  join TRANSFERTIMETAT ON (IMA_IMEID=IME_ID)');
      SQL.Add('Where IML_ARTID = '+inttostr(iArtID));
      SQL.Add('  and IME_TRANSIT=0');
      SQL.Add('group by IMA_MAGOID, IMA_MAGDID, IMA_DATE, IML_TGFID, IML_COUID');
      Open;
      First;
      While not(Eof) do
      begin
        if (FieldByName('QTE').AsInteger<>0) then
        begin
          iMagId := FieldByName('IMA_MAGDID').AsInteger;
          iTgfId := FieldByName('IML_TGFID').AsInteger;
          iCouId := FieldByName('IML_COUID').AsInteger;
          dMvt   := FieldByName('IMA_DATE').AsDatetime;
          // entree type = 2
          inc(IdHstStk);
          AgrHistoStk.Append;
          AgrHistoStk.FieldByName('RecNo').AsInteger := IdHstStk;
          AgrHistoStk.FieldByName('MAGID').AsInteger := iMagId;
          AgrHistoStk.FieldByName('TGFID').AsInteger := iTgfId;
          AgrHistoStk.FieldByName('COUID').AsInteger := iCouId;
          AgrHistoStk.FieldByName('DATEMVT').AsDateTime := dMvt;
          AgrHistoStk.FieldByName('ARTID').AsInteger := iArtID;
          AgrHistoStk.FieldByName('TYPETBL').AsInteger := 2;
          AgrHistoStk.FieldByName('QTEMVT').AsInteger := FieldByName('QTE').AsInteger;
          AgrHistoStk.FieldByName('PUMPTOT').AsFloat := FieldByName('VALEUR').AsFloat;
          PmpTot := 0;
          if FieldByName('VALEUR').AsFloat<>0 then
            PmpTot := FieldByName('VALEUR').AsFloat/FieldByName('QTE').AsInteger;
          AgrHistoStk.FieldByName('PUMP').AsFloat := PmpTot;
          AgrHistoStk.Post;

//          // Pour Export BI
//          if bOkBI then
//            IsfMvtBI_Add_Mvt(iMagId, iTgfId, iCouId, dMvt);

          // affectation à agrhistostock pour le groupe de pump
          GrpPump.Locate('MPU_MAGID', iMagId, []);
          iGcpId := GrpPump.FieldByName('MPU_GCPID').AsInteger;
          GrpPump.First;
          while not(GrpPump.Eof) do
          begin
            if (GrpPump.FieldByName('MPU_GCPID').AsInteger=iGcpId) then
            begin
              if not(AgrStockFin.Locate('MAGID;TGFID;COUID;DATEMVT',
                       VarArrayOf([GrpPump.FieldByName('MPU_MAGID').AsInteger, iTgfId, iCouId, dMvt]), [])) then
              begin
                inc(IdStkFin);
                AgrStockFin.Append;
                AgrStockFin.FieldByName('RecNo').AsInteger := IdStkFin;
                AgrStockFin.FieldByName('MAGID').AsInteger := GrpPump.FieldByName('MPU_MAGID').AsInteger;
                AgrStockFin.FieldByName('TGFID').AsInteger := iTgfId;
                AgrStockFin.FieldByName('COUID').AsInteger := iCouId;
                AgrStockFin.FieldByName('DATEMVT').AsDateTime := dMvt;
                AgrStockFin.FieldByName('QTEMVT').AsInteger := 0;
                AgrStockFin.FieldByName('INITIAL').AsInteger := 0;
                AgrStockFin.Post;
              end;
            end;
            GrpPump.Next;
          end;
          // cumul de pump
          if CUMUMPUMP.Locate('GCPID;TGFID;COUID;DATEMVT', VarArrayOf([iGcpId, iTgfId, iCouId, dMvt]), []) then
          begin
            CUMUMPUMP.Edit;
            CUMUMPUMP.FieldByName('QTE_E').AsInteger := CUMUMPUMP.FieldByName('QTE_E').AsInteger+
                                                        FieldByName('QTE').AsInteger;
            CUMUMPUMP.FieldByName('CUMPUMP').AsFloat := CUMUMPUMP.FieldByName('CUMPUMP').AsFloat+
                                                        FieldByName('VALEUR').AsFloat;
            CUMUMPUMP.Post;
          end
          else
          begin
            CUMUMPUMP.Append;
            CUMUMPUMP.FieldByName('GCPID').AsInteger := iGcpId;
            CUMUMPUMP.FieldByName('TGFID').AsInteger := iTgfId;
            CUMUMPUMP.FieldByName('COUID').AsInteger := iCouId;
            CUMUMPUMP.FieldByName('DATEMVT').AsDateTime := dMvt;
            CUMUMPUMP.FieldByName('QTE_E').AsInteger := FieldByName('QTE').AsInteger;
            CUMUMPUMP.FieldByName('CUMPUMP').AsFloat := FieldByName('VALEUR').AsFloat;
            CUMUMPUMP.Post;
          end;

          // sortie type = 3
          inc(IdHstStk);
          AgrHistoStk.Append;
          AgrHistoStk.FieldByName('RecNo').AsInteger := IdHstStk;
          AgrHistoStk.FieldByName('MAGID').AsInteger := FieldByName('IMA_MAGOID').AsInteger;
          AgrHistoStk.FieldByName('TGFID').AsInteger := iTgfId;
          AgrHistoStk.FieldByName('COUID').AsInteger := iCouId;
          AgrHistoStk.FieldByName('DATEMVT').AsDateTime := dMvt;
          AgrHistoStk.FieldByName('ARTID').AsInteger := iArtID;
          AgrHistoStk.FieldByName('TYPETBL').AsInteger := 3;
          AgrHistoStk.FieldByName('QTEMVT').AsInteger := -FieldByName('QTE').AsInteger;
          AgrHistoStk.Post;

          // cumul de pump
          GrpPump.Locate('MPU_MAGID', iMagId, []);
          iGcpId := GrpPump.FieldByName('MPU_GCPID').AsInteger;
          if CUMUMPUMP.Locate('GCPID;TGFID;COUID;DATEMVT', VarArrayOf([iGcpId, iTgfId, iCouId, dMvt]), []) then
          begin
            CUMUMPUMP.Edit;
            CUMUMPUMP.FieldByName('QTE_S').AsInteger := CUMUMPUMP.FieldByName('QTE_S').AsInteger+
                                                        FieldByName('QTE').AsInteger;
            CUMUMPUMP.Post;
          end
          else
          begin
            CUMUMPUMP.Append;
            CUMUMPUMP.FieldByName('GCPID').AsInteger := iGcpId;
            CUMUMPUMP.FieldByName('TGFID').AsInteger := iTgfId;
            CUMUMPUMP.FieldByName('COUID').AsInteger := iCouId;
            CUMUMPUMP.FieldByName('DATEMVT').AsDateTime := dMvt;
            CUMUMPUMP.FieldByName('QTE_S').AsInteger := FieldByName('QTE').AsInteger;
            CUMUMPUMP.Post;
          end;
        end;

        Next;
      end;
      Close;
    end;

    // BL type = 4: sortie
    with Sel_SQL do
    begin
      SQL.Clear;
      SQL.Add('select BLE_MAGID, BLE_DATE, BLL_TGFID, BLL_COUID, SUM(BLL_QTE) as QTE');
      SQL.Add('  from negbl join k on (k_id=BLE_ID and K_ENABLED=1)');
      SQL.Add('       Join negbll join k on (k_id=BLL_ID and K_ENABLED=1)');
      SQL.Add('  on (Bll_bleid = BLE_ID)');
      SQL.Add(' Where BLL_ARTID = '+inttostr(iArtID));
      SQL.Add('group by BLE_MAGID, BLE_DATE, BLL_TGFID, BLL_COUID');
      Open;
      First;
      While not(Eof) do
      begin
        iMagId := FieldByName('BLE_MAGID').AsInteger;
        iTgfId := FieldByName('BLL_TGFID').AsInteger;
        iCouId := FieldByName('BLL_COUID').AsInteger;
        dMvt   := Trunc(FieldByName('BLE_DATE').AsDatetime);
        inc(IdHstStk);
        AgrHistoStk.Append;
        AgrHistoStk.FieldByName('RecNo').AsInteger := IdHstStk;
        AgrHistoStk.FieldByName('MAGID').AsInteger := iMagId;
        AgrHistoStk.FieldByName('TGFID').AsInteger := iTgfId;
        AgrHistoStk.FieldByName('COUID').AsInteger := iCouId;
        AgrHistoStk.FieldByName('DATEMVT').AsDateTime := dMvt;
        AgrHistoStk.FieldByName('ARTID').AsInteger := iArtID;
        AgrHistoStk.FieldByName('TYPETBL').AsInteger := 4;
        AgrHistoStk.FieldByName('QTEMVT').AsInteger := -FieldByName('QTE').AsInteger;        //SR - Ajout du - pour corriger le calcul de stock
        AgrHistoStk.Post;

//        // Pour Export BI
//        if bOkBI then
//          IsfMvtBI_Add_Mvt(iMagId, iTgfId, iCouId, dMvt);

        // cumul de pump
        GrpPump.Locate('MPU_MAGID', iMagId, []);
        iGcpId := GrpPump.FieldByName('MPU_GCPID').AsInteger;
        if CUMUMPUMP.Locate('GCPID;TGFID;COUID;DATEMVT', VarArrayOf([iGcpId, iTgfId, iCouId, dMvt]), []) then
        begin
          CUMUMPUMP.Edit;
          CUMUMPUMP.FieldByName('QTE_S').AsInteger := CUMUMPUMP.FieldByName('QTE_S').AsInteger+
                                                      FieldByName('QTE').AsInteger;
          CUMUMPUMP.Post;
        end
        else
        begin
          CUMUMPUMP.Append;
          CUMUMPUMP.FieldByName('GCPID').AsInteger := iGcpId;
          CUMUMPUMP.FieldByName('TGFID').AsInteger := iTgfId;
          CUMUMPUMP.FieldByName('COUID').AsInteger := iCouId;
          CUMUMPUMP.FieldByName('DATEMVT').AsDateTime := dMvt;
          CUMUMPUMP.FieldByName('QTE_S').AsInteger := FieldByName('QTE').AsInteger;
          CUMUMPUMP.Post;
        end;

        Next;
      end;
      Close;
    end;

    // ConsoDiv type = 5: sortie
    with Sel_SQL do
    begin
      SQL.Clear;
      SQL.Add('select CDV_MAGID, CDV_DATE, CDV_TGFID, CDV_COUID, SUM(CDV_QTE) as QTE');
      SQL.Add('  from consodiv Join K on (K_ID = CDV_ID and K_Enabled=1)');
      SQL.Add(' Where CDV_ARTID = '+inttostr(iArtID));
      SQL.Add(' group by CDV_MAGID, CDV_DATE, CDV_TGFID, CDV_COUID');
      Open;
      First;
      While not(Eof) do
      begin
        iMagId := FieldByName('CDV_MAGID').AsInteger;
        iTgfId := FieldByName('CDV_TGFID').AsInteger;
        iCouId := FieldByName('CDV_COUID').AsInteger;
        dMvt   := Trunc(FieldByName('CDV_DATE').AsDatetime);
        inc(IdHstStk);
        AgrHistoStk.Append;
        AgrHistoStk.FieldByName('RecNo').AsInteger := IdHstStk;
        AgrHistoStk.FieldByName('MAGID').AsInteger := iMagId;
        AgrHistoStk.FieldByName('TGFID').AsInteger := iTgfId;
        AgrHistoStk.FieldByName('COUID').AsInteger := iCouId;
        AgrHistoStk.FieldByName('DATEMVT').AsDateTime := dMvt;
        AgrHistoStk.FieldByName('ARTID').AsInteger := iArtID;
        AgrHistoStk.FieldByName('TYPETBL').AsInteger := 5;
        AgrHistoStk.FieldByName('QTEMVT').AsInteger := -FieldByName('QTE').AsInteger;
        AgrHistoStk.Post;

//        // Pour Export BI
//        if bOkBI then
//          IsfMvtBI_Add_Mvt(iMagId, iTgfId, iCouId, dMvt);

        // cumul de pump
        GrpPump.Locate('MPU_MAGID', iMagId, []);
        iGcpId := GrpPump.FieldByName('MPU_GCPID').AsInteger;
        if CUMUMPUMP.Locate('GCPID;TGFID;COUID;DATEMVT', VarArrayOf([iGcpId, iTgfId, iCouId, dMvt]), []) then
        begin
          CUMUMPUMP.Edit;
          CUMUMPUMP.FieldByName('QTE_S').AsInteger := CUMUMPUMP.FieldByName('QTE_S').AsInteger+
                                                      FieldByName('QTE').AsInteger;
          CUMUMPUMP.Post;
        end
        else
        begin
          CUMUMPUMP.Append;
          CUMUMPUMP.FieldByName('GCPID').AsInteger := iGcpId;
          CUMUMPUMP.FieldByName('TGFID').AsInteger := iTgfId;
          CUMUMPUMP.FieldByName('COUID').AsInteger := iCouId;
          CUMUMPUMP.FieldByName('DATEMVT').AsDateTime := dMvt;
          CUMUMPUMP.FieldByName('QTE_S').AsInteger := FieldByName('QTE').AsInteger;
          CUMUMPUMP.Post;
        end;

        Next;
      end;
      Close;
    end;

    // facture = 6: sortie
    with Sel_SQL do
    begin
      SQL.Clear;
      SQL.Add('select FCE_MAGID, FCE_DATE, FCL_TGFID, FCL_COUID, SUM(FCL_QTE) as QTE');
      SQL.Add('      from negfacture join k on (k_id=FCE_ID and K_ENABLED=1)');
      SQL.Add('                 Join negfactureL join k on (k_id=FCL_ID and K_ENABLED=1)');
      SQL.Add('        on (FCl_FCeid = FCE_ID)');
      SQL.Add('     Where FCL_ARTID = '+inttostr(iArtID));
      SQL.Add('       and FCL_LINETIP=0');
      SQL.Add('       and FCL_FROMBLL = 0');
      SQL.Add('       and FCE_MODELE=0');
      SQL.Add(' group by FCE_MAGID, FCE_DATE, FCL_TGFID, FCL_COUID');
      Open;
      First;
      While not(Eof) do
      begin
        iMagId := FieldByName('FCE_MAGID').AsInteger;
        iTgfId := FieldByName('FCL_TGFID').AsInteger;
        iCouId := FieldByName('FCL_COUID').AsInteger;
        dMvt   := Trunc(FieldByName('FCE_DATE').AsDatetime);
        Inc(IdHstStk);
        AgrHistoStk.Append;
        AgrHistoStk.FieldByName('RecNo').AsInteger := IdHstStk;
        AgrHistoStk.FieldByName('MAGID').AsInteger := iMagId;
        AgrHistoStk.FieldByName('TGFID').AsInteger := iTgfId;
        AgrHistoStk.FieldByName('COUID').AsInteger := iCouId;
        AgrHistoStk.FieldByName('DATEMVT').AsDateTime := dMvt;
        AgrHistoStk.FieldByName('ARTID').AsInteger := iArtID;
        AgrHistoStk.FieldByName('TYPETBL').AsInteger := 6;
        AgrHistoStk.FieldByName('QTEMVT').AsInteger := -FieldByName('QTE').AsInteger;
        AgrHistoStk.Post;

//        // Pour Export BI
//        if bOkBI then
//          IsfMvtBI_Add_Mvt(iMagId, iTgfId, iCouId, dMvt);

        // cumul de pump
        GrpPump.Locate('MPU_MAGID', iMagId, []);
        iGcpId := GrpPump.FieldByName('MPU_GCPID').AsInteger;
        if CUMUMPUMP.Locate('GCPID;TGFID;COUID;DATEMVT', VarArrayOf([iGcpId, iTgfId, iCouId, dMvt]), []) then
        begin
          CUMUMPUMP.Edit;
          CUMUMPUMP.FieldByName('QTE_S').AsInteger := CUMUMPUMP.FieldByName('QTE_S').AsInteger+
                                                      FieldByName('QTE').AsInteger;
          CUMUMPUMP.Post;
        end
        else
        begin
          CUMUMPUMP.Append;
          CUMUMPUMP.FieldByName('GCPID').AsInteger := iGcpId;
          CUMUMPUMP.FieldByName('TGFID').AsInteger := iTgfId;
          CUMUMPUMP.FieldByName('COUID').AsInteger := iCouId;
          CUMUMPUMP.FieldByName('DATEMVT').AsDateTime := dMvt;
          CUMUMPUMP.FieldByName('QTE_S').AsInteger := FieldByName('QTE').AsInteger;
          CUMUMPUMP.Post;
        end;

        Next;
      end;
      Close;
    end;

    // ticket = 7: sortie
    with Sel_SQL do
    begin
      SQL.Clear;
      SQL.Add('select POS_MAGID, TKE_DATE, TKL_TGFID, TKL_COUID, SUM(TKL_QTE) as QTE');
      SQL.Add('      from CshTicket join k on (k_id=TKE_ID and K_ENABLED=1)');
      SQL.Add('                Join CshTicketL join k on (k_id=TKL_ID and K_ENABLED=1)');
      SQL.Add('                  on (TKL_TKEid = TKE_ID)');
      SQL.Add('                Join CshSession on (SES_ID=TKE_SESID)');
      SQL.Add('                Join GenPoste on (POS_ID=SES_POSID)');
      SQL.Add('    Where TKL_ARTID =  '+inttostr(iArtID));
      SQL.Add('      and TKL_SSTOTAL=0');
      SQL.Add(' group by POS_MAGID, TKE_DATE, TKL_TGFID, TKL_COUID');
      Open;
      First;
      While not(Eof) do
      begin
        iMagId := FieldByName('POS_MAGID').AsInteger;
        iTgfId := FieldByName('TKL_TGFID').AsInteger;
        iCouId := FieldByName('TKL_COUID').AsInteger;
        dMvt   := Trunc(FieldByName('TKE_DATE').AsDatetime);
        inc(IdHstStk);
        AgrHistoStk.Append;
        AgrHistoStk.FieldByName('RecNo').AsInteger := IdHstStk;
        AgrHistoStk.FieldByName('MAGID').AsInteger := iMagId;
        AgrHistoStk.FieldByName('TGFID').AsInteger := iTgfId;
        AgrHistoStk.FieldByName('COUID').AsInteger := iCouId;
        AgrHistoStk.FieldByName('DATEMVT').AsDateTime := dMvt;
        AgrHistoStk.FieldByName('ARTID').AsInteger := iArtID;
        AgrHistoStk.FieldByName('TYPETBL').AsInteger := 7;
        AgrHistoStk.FieldByName('QTEMVT').AsInteger := -FieldByName('QTE').AsInteger;
        AgrHistoStk.Post;

//        // Pour Export BI
//        if bOkBI then
//          IsfMvtBI_Add_Mvt(iMagId, iTgfId, iCouId, dMvt);

        // cumul de pump
        GrpPump.Locate('MPU_MAGID', iMagId, []);
        iGcpId := GrpPump.FieldByName('MPU_GCPID').AsInteger;
        if CUMUMPUMP.Locate('GCPID;TGFID;COUID;DATEMVT', VarArrayOf([iGcpId, iTgfId, iCouId, dMvt]), []) then
        begin
          CUMUMPUMP.Edit;
          CUMUMPUMP.FieldByName('QTE_S').AsInteger := CUMUMPUMP.FieldByName('QTE_S').AsInteger+
                                                      FieldByName('QTE').AsInteger;
          CUMUMPUMP.Post;
        end
        else
        begin
          CUMUMPUMP.Append;
          CUMUMPUMP.FieldByName('GCPID').AsInteger := iGcpId;
          CUMUMPUMP.FieldByName('TGFID').AsInteger := iTgfId;
          CUMUMPUMP.FieldByName('COUID').AsInteger := iCouId;
          CUMUMPUMP.FieldByName('DATEMVT').AsDateTime := dMvt;
          CUMUMPUMP.FieldByName('QTE_S').AsInteger := FieldByName('QTE').AsInteger;
          CUMUMPUMP.Post;
        end;

        Next;
      end;
      Close;
    end;

    // retour fournisseur = 8: sortie
    with Sel_SQL do
    begin
      SQL.Clear;
      SQL.Add('select RET_MAGID, RET_DATE, REL_TGFID, REL_COUID, SUM(REL_QTE) as QTE');
      SQL.Add('  from comretour join k on (k_id=RET_ID and K_ENABLED=1)');
      SQL.Add('       Join comretourL join k on (k_id=REL_ID and K_ENABLED=1)');
      SQL.Add('         on (REL_RETid = RET_ID)');
      SQL.Add(' Where REL_ARTID =  '+inttostr(iArtID));
      SQL.Add(' group by RET_MAGID, RET_DATE, REL_TGFID, REL_COUID');
      Open;
      First;
      While not(Eof) do
      begin
        iMagId := FieldByName('RET_MAGID').AsInteger;
        iTgfId := FieldByName('REL_TGFID').AsInteger;
        iCouId := FieldByName('REL_COUID').AsInteger;
        dMvt   := Trunc(FieldByName('RET_DATE').AsDatetime);
        inc(IdHstStk);
        AgrHistoStk.Append;
        AgrHistoStk.FieldByName('RecNo').AsInteger := IdHstStk;
        AgrHistoStk.FieldByName('MAGID').AsInteger := iMagId;
        AgrHistoStk.FieldByName('TGFID').AsInteger := iTgfId;
        AgrHistoStk.FieldByName('COUID').AsInteger := iCouId;
        AgrHistoStk.FieldByName('DATEMVT').AsDateTime := dMvt;
        AgrHistoStk.FieldByName('ARTID').AsInteger := iArtID;
        AgrHistoStk.FieldByName('TYPETBL').AsInteger := 8;
        AgrHistoStk.FieldByName('QTEMVT').AsInteger := -FieldByName('QTE').AsInteger;
        AgrHistoStk.Post;

//        // Pour Export BI
//        if bOkBI then
//          IsfMvtBI_Add_Mvt(iMagId, iTgfId, iCouId, dMvt);

        // cumul de pump
        GrpPump.Locate('MPU_MAGID', iMagId, []);
        iGcpId := GrpPump.FieldByName('MPU_GCPID').AsInteger;
        if CUMUMPUMP.Locate('GCPID;TGFID;COUID;DATEMVT', VarArrayOf([iGcpId, iTgfId, iCouId, dMvt]), []) then
        begin
          CUMUMPUMP.Edit;
          CUMUMPUMP.FieldByName('QTE_S').AsInteger := CUMUMPUMP.FieldByName('QTE_S').AsInteger+
                                                      FieldByName('QTE').AsInteger;
          CUMUMPUMP.Post;
        end
        else
        begin
          CUMUMPUMP.Append;
          CUMUMPUMP.FieldByName('GCPID').AsInteger := iGcpId;
          CUMUMPUMP.FieldByName('TGFID').AsInteger := iTgfId;
          CUMUMPUMP.FieldByName('COUID').AsInteger := iCouId;
          CUMUMPUMP.FieldByName('DATEMVT').AsDateTime := dMvt;
          CUMUMPUMP.FieldByName('QTE_S').AsInteger := FieldByName('QTE').AsInteger;
          CUMUMPUMP.Post;
        end;

        Next;
      end;
      Close;
    end;

    // regroupement des mouvement
    Qte := 0;
    AgrHistoStk.First;
    while not(AgrHistoStk.Eof) do
    begin
      iMagId := AgrHistoStk.FieldByName('MAGID').AsInteger;
      iTgfId := AgrHistoStk.FieldByName('TGFID').AsInteger;
      iCouId := AgrHistoStk.FieldByName('COUID').AsInteger;
      dMvt := AgrHistoStk.FieldByName('DATEMVT').AsDatetime;
      Qte := AgrHistoStk.FieldByName('QTEMVT').AsInteger;
      if AgrStockFin.Locate('MAGID;TGFID;COUID;DATEMVT', VarArrayOf([iMagId, iTgfId, iCouId, dMvt]), []) then
      begin
        AgrStockFin.Edit;
        AgrStockFin.FieldByName('QTEMVT').AsInteger := AgrStockFin.FieldByName('QTEMVT').AsInteger+Qte;
        AgrStockFin.Post;
      end
      else
      begin
        inc(IdStkFin);
        AgrStockFin.Append;
        AgrStockFin.FieldByName('RecNo').AsInteger := IdStkFin;
        AgrStockFin.FieldByName('MAGID').AsInteger := iMagId;
        AgrStockFin.FieldByName('TGFID').AsInteger := iTgfId;
        AgrStockFin.FieldByName('COUID').AsInteger := iCouId;
        AgrStockFin.FieldByName('DATEMVT').AsDateTime := dMvt;
        AgrStockFin.FieldByName('QTEMVT').AsInteger := Qte;
        AgrStockFin.FieldByName('INITIAL').AsInteger := 0;
        AgrStockFin.Post;
      end;
      AgrHistoStk.Next;
    end;

    AgrHistoStk.IndexFieldNames := 'MAGID;TGFID;COUID;DATEMVT;TYPETBL';
    AgrStockFin.IndexFieldNames := 'MAGID;TGFID;COUID;DATEMVT';

    iMagId := 0;
    iTgfId := 0;
    iCouId := 0;
    Qte := 0;
    AgrStockFin.First;
    while not(AgrStockFin.Eof) do
    begin
      if (iMagId=0) or (iMagId <> AgrStockFin.FieldByName('MAGID').AsInteger)
          or (iTgfId <> AgrStockFin.FieldByName('TGFID').AsInteger)
          or (iCouId <> AgrStockFin.FieldByName('COUID').AsInteger) then
      begin
        Qte := 0;
        iMagId := AgrStockFin.FieldByName('MAGID').AsInteger;
        iTgfId := AgrStockFin.FieldByName('TGFID').AsInteger;
        iCouId := AgrStockFin.FieldByName('COUID').AsInteger;
      end;
      Qte := Qte + AgrStockFin.FieldByName('QTEMVT').AsInteger;
      AgrStockFin.Edit;
      AgrStockFin.FieldByName('QTEFIN').AsInteger := Qte;
      AgrStockFin.Post;
      AgrStockFin.Next;
    end;

    // mvt de fin
    iMagId := 0;
    iTgfId := 0;
    iCouId := 0;
    dMvt := StrToDate('02/01/2100');
    AgrStockFin.Last;
    while not(AgrStockFin.Bof) do
    begin
      if (iMagId=0) or (iMagId <> AgrStockFin.FieldByName('MAGID').AsInteger)
          or (iTgfId <> AgrStockFin.FieldByName('TGFID').AsInteger)
          or (iCouId <> AgrStockFin.FieldByName('COUID').AsInteger) then
      begin
        dMvt := StrToDate('02/01/2100');
        iMagId := AgrStockFin.FieldByName('MAGID').AsInteger;
        iTgfId := AgrStockFin.FieldByName('TGFID').AsInteger;
        iCouId := AgrStockFin.FieldByName('COUID').AsInteger;
      end;
      AgrStockFin.Edit;
      AgrStockFin.FieldByName('DATEFIN').AsDateTime := Trunc(dMvt)-1;
      AgrStockFin.Post;
      dMvt := AgrStockFin.FieldByName('DATEMVT').AsDateTime;
      AgrStockFin.Prior;
    end;

    CUMUMPUMP.IndexFieldNames := 'GCPID;TGFID;COUID;DATEMVT';
    CUMUMPUMP.First;
    iGcpId := CUMUMPUMP.FieldByName('GCPID').AsInteger;
    iTgfId := CUMUMPUMP.FieldByName('TGFID').AsInteger;
    iCouId := CUMUMPUMP.FieldByName('COUID').AsInteger;
    Qte    := 0;
    while not(CUMUMPUMP.Eof) do
    begin
      if (iGcpId<>CUMUMPUMP.FieldByName('GCPID').AsInteger) or
         (iTgfId<>CUMUMPUMP.FieldByName('TGFID').AsInteger) or
         (iCouId<>CUMUMPUMP.FieldByName('COUID').AsInteger) then
      begin
        iGcpId := CUMUMPUMP.FieldByName('GCPID').AsInteger;
        iTgfId := CUMUMPUMP.FieldByName('TGFID').AsInteger;
        iCouId := CUMUMPUMP.FieldByName('COUID').AsInteger;
        Qte := 0;
      end;
      Qte := Qte+CUMUMPUMP.FieldByName('QTE_E').AsInteger-CUMUMPUMP.FieldByName('QTE_S').AsInteger;
      CUMUMPUMP.Edit;
      CUMUMPUMP.FieldByName('QTE_FIN').AsInteger := Qte;
      CUMUMPUMP.Post;
      CUMUMPUMP.Next;
    end;

    // date de fin pour cumul
    iGcpId := 0;
    iTgfId := 0;
    iCouId := 0;
    dMvt := StrToDate('02/01/2100');
    CUMUMPUMP.Last;
    while not(CUMUMPUMP.Bof) do
    begin
      if (iGcpId=0) or (iGcpId <> CUMUMPUMP.FieldByName('GCPID').AsInteger)
          or (iTgfId <> CUMUMPUMP.FieldByName('TGFID').AsInteger)
          or (iCouId <> CUMUMPUMP.FieldByName('COUID').AsInteger) then
      begin
        dMvt := StrToDate('02/01/2100');
        iGcpId := CUMUMPUMP.FieldByName('GCPID').AsInteger;
        iTgfId := CUMUMPUMP.FieldByName('TGFID').AsInteger;
        iCouId := CUMUMPUMP.FieldByName('COUID').AsInteger;
      end;
      CUMUMPUMP.Edit;
      CUMUMPUMP.FieldByName('DATEFIN').AsDateTime := Trunc(dMvt)-1;
      CUMUMPUMP.Post;
      dMvt := CUMUMPUMP.FieldByName('DATEMVT').AsDateTime;
      CUMUMPUMP.Prior;
    end;

    iGcpId := -1;
    AgrStockFin.IndexFieldNames := 'DATEMVT;MAGID;TGFID;COUID';
    AgrStockFin.First;
    while not(AgrStockFin.Eof) do
    begin
      iMagId := AgrStockFin.FieldByName('MAGID').AsInteger;
      iTgfId := AgrStockFin.FieldByName('TGFID').AsInteger;
      iCouId := AgrStockFin.FieldByName('COUID').AsInteger;
      dMvt   := AgrStockFin.FieldByName('DATEMVT').AsDatetime;
      // liste des mag concernés
      GrpPump.Locate('MPU_MAGID', iMagId, []);
      if (iGcpId=-1) or (iGcpId<>GrpPump.FieldByName('MPU_GCPID').AsInteger) then
      begin
        iGcpId := GrpPump.FieldByName('MPU_GCPID').AsInteger;
        ListeMagID.Clear;
        GrpPump.First;
        while not(GrpPump.Eof) do
        begin
          if (GrpPump.FieldByName('MPU_GCPID').AsInteger=iGcpId) then
            ListeMagId.Add(inttostr(GrpPump.FieldByName('MPU_MAGID').AsInteger));
          GrpPump.Next;
        end;
      end;
      if AgrStockFin.FieldByName('PUMP').IsNull then  // si pas null, c que c déjà calculé
      begin
        // sauvegarde des positions
        iRecNoStkFin := AgrStockFin.FieldByName('RecNo').AsInteger;

        // Recherche du stock et pump en J-1
        Last_PumpGrpHisto(iGcpId, iTgfId, iCouId, dMvt, iOldStock, vOldPump);

        // Calcul des quantités sorties  en J
        iQte_S := GetQteSortieParGrp(iGcpId, iTgfId, iCouId, dMvt);

        // Calcul des quantités valorisés entrées en J
        GetQteEntreeParGrp(iGcpId, iTgfId, iCouId, dMvt, iQte_E, vValeur);

        // Calcul du stock en J
        iNewStockPump := iOldStock+iQte_E-iQte_S;
        if (iNewStockPump<=0) then
        begin
          // Si OldPump est égal à zéro il faut aller chercher le prix d'achat courant
          if (vOldPump>0.01) then  // >0
            vNewPump := vOldPump
          else
            vNewPump := GetPXNNAchatCour(iTgfId, iCouId);
        end
        else
        begin
          // Si l'ancien Stock est inférieur ou égal à zéro le pump devient le Prix unitaire livré
          if (iOldStock<=0) then
          begin
            // Test de la Division par zéro
            if (iQte_E=0) then
            begin
              // Si OldPump est égal à zéro il faut aller chercher le prix d'achat courant
              if (vOldPump>0.01) then
                vNewPump := vOldPump
              else
                vNewPump := GetPXNNAchatCour(iTgfId, iCouId);
            end
            else
            begin
              vNewPump := vValeur/iQte_E;
            end;
          end
          else
          begin
            // Tous les paramètres permettent de calculer un Pump
            // Test de la Division par zéro
            if (iOldStock+iQte_E)>0 then
            begin
              vNewPump :=  ((iOldStock*vOldPump )+vValeur)/(iOldStock+iQte_E);
            end
            else
            begin
              // Si OldPump est égal à zéro il faut aller chercher le prix d'achat courant
              if (vOldPump>0.01) then
                vNewPump := vOldPump
              else
                vNewPump := GetPXNNAchatCour(iTgfId, iCouId);
            end;
          end;
        end;

        if (vNewPump<0.01) then
        begin
          if vOldPump>0.01 then
            vNewPump := vOldPump;

          if (vNewPump<0.01) then
            vNewPump := GetPxAchat(iTgfId, iCouId);
        end;

        // Enregistrement des nouvelles valeurs de pump  en J pour le groupe de pump
        if CUMUMPUMP.Locate('GCPID;TGFID;COUID;DATEMVT', VarArrayOf([iGcpId, iTgfId, iCouId, dMvt]), []) then
        begin
          CUMUMPUMP.Edit;
          CUMUMPUMP.FieldByName('PUMP').AsFloat := vNewPump;
          CUMUMPUMP.Post;
        end;
        // Enregistrement des nouvelles valeurs de pump  en J (le stock est mis à jour plus haut)
        for i := 1 to ListeMagId.Count do
        begin
          iMagId := StrToInt(ListeMagId[i-1]);
          if AgrStockFin.Locate('MAGID;TGFID;COUID;DATEMVT', VarArrayOf([iMagId, iTgfId, iCouId, dMvt]), []) then
          begin
            AgrStockFin.Edit;
            AgrStockFin.FieldByName('PUMP').AsFloat := vNewPump;
            AgrStockFin.Post;
          end;
        end;

        // repositionnement
        AgrStockFin.Locate('RecNo', iRecNoStkFin, []);
      end;
      AgrStockFin.Next;
    end;

    // stock courant
    AgrStockFin.IndexFieldNames := 'MAGID;TGFID;COUID;DATEMVT';
    AgrStockFin.First;
    iMagId := AgrStockFin.FieldByName('MAGID').AsInteger;
    iTgfId := AgrStockFin.FieldByName('TGFID').AsInteger;
    iCouId := AgrStockFin.FieldByName('COUID').AsInteger;
    Qte := AgrStockFin.FieldByName('QTEFIN').AsInteger;
    vNewPump := AgrStockFin.FieldByName('PUMP').AsFloat;
    while not(AgrStockFin.Eof) do
    begin
      if (iMagId=0) or (iMagId<>AgrStockFin.FieldByName('MAGID').AsInteger)
             or (iTgfId<>AgrStockFin.FieldByName('TGFID').AsInteger)
              or (iCouId<>AgrStockFin.FieldByName('COUID').AsInteger) then
      begin
        if AgrStockCourt.Locate('MAGID;TGFID;COUID', VarArrayOf([iMagId, iTgfId, iCouId]), []) then
        begin
          AgrStockCourt.Edit;
          AgrStockCourt.FieldByName('QTE').AsInteger := Qte;
          AgrStockCourt.FieldByName('PUMP').AsFloat := vNewPump;
          AgrStockCourt.FieldByName('BVALID').AsBoolean := true;
          AgrStockCourt.Post;
        end;
        iMagId := AgrStockFin.FieldByName('MAGID').AsInteger;
        iTgfId := AgrStockFin.FieldByName('TGFID').AsInteger;
        iCouId := AgrStockFin.FieldByName('COUID').AsInteger;
      end;
      Qte := AgrStockFin.FieldByName('QTEFIN').AsInteger;
      vNewPump := AgrStockFin.FieldByName('PUMP').AsFloat;
      AgrStockFin.Next;
    end;
    if AgrStockCourt.Locate('MAGID;TGFID;COUID', VarArrayOf([iMagId, iTgfId, iCouId]), []) then
    begin
      AgrStockCourt.Edit;
      AgrStockCourt.FieldByName('QTE').AsInteger := Qte;
      AgrStockCourt.FieldByName('PUMP').AsFloat := vNewPump;
      AgrStockCourt.FieldByName('BVALID').AsBoolean := true;
      AgrStockCourt.Post;
    end;

    // suppression des lignes non prises en compte dans stock courant
    // liste des Id à faire
    ListeID.Clear;
    AgrStockCourt.First;
    while not(AgrStockCourt.Eof) do
    begin
      iMagId := AgrStockCourt.FieldByName('MAGID').AsInteger;
      iTgfId := AgrStockCourt.FieldByName('TGFID').AsInteger;
      iCouId := AgrStockCourt.FieldByName('COUID').AsInteger;
      sTmp := inttostr(iMagId)+'|'+inttostr(iTgfId)+'|'+inttostr(iCouId);
      if not(AgrStockCourt.FieldByName('BVALID').AsBoolean) and (ListeID.IndexOf(sTmp)<0) then
        ListeID.Add(sTmp);
      AgrStockCourt.Next;
    end;
    // Suppression des lignes non valides trouvées précédemment
    for i:= 1 to ListeID.Count do
    begin
      sTmp := ListeID[i-1];
      iMagId := StrToInt(Copy(sTmp, 1, pos('|', sTmp)-1));
      sTmp := Copy(sTmp, Pos('|', sTmp)+1, Length(sTmp));
      iTgfId := StrToInt(Copy(sTmp, 1, pos('|', sTmp)-1));
      sTmp := Copy(sTmp, Pos('|', sTmp)+1, Length(sTmp));
      iCouId := StrToInt(sTmp);
      if (AgrStockCourt.Locate('MAGID;TGFID;COUID', VarArrayOf([iMagId, iTgfID, iCouId]), [])) then
        AgrStockCourt.Delete;
    end;

    TransacHis.StartTransaction;
    try
      // mise à jour dans agrhistostock
      // effacement
      Que_Upd.Close;
      Que_Upd.SQL.Clear;
      Que_Upd.SQL.Add('delete from AGRHISTOSTOCK');
      Que_Upd.SQL.Add(' where hst_initial != 1 and HST_ARTID='+inttostr(iArtId));
      Que_Upd.ExecSQL;
      Que_Upd.Close;
      // ajout
      AgrStockFin.First;
      while not(AgrStockFin.Eof) do
      begin
        dMvt := AgrStockFin.FieldByName('DATEMVT').AsDateTime;

        DecodeDate(dMvt, Annee, Mois, Jour);
        // Id
        Que_Upd.Close;
        Que_Upd.SQL.Clear;
        Que_Upd.SQL.Add('SELECT GEN_ID(AGR_ID,1) AS NEWKEY FROM RDB$DATABASE');
        Que_Upd.Open;
        iHstId := Que_Upd.FieldByName('NEWKEY').AsInteger;
        Que_Upd.Close;
        // table
        Que_Upd.Close;
        Que_Upd.SQL.Clear;
        Que_Upd.SQL.Add('INSERT INTO AGRHISTOSTOCK(HST_ID, HST_JOUR, HST_MOIS, HST_ANNEE, HST_ARTID, HST_MAGID, '+
                                                  'HST_TGFID, HST_COUID, HST_QTE, HST_DATE, HST_DATEFIN, HST_PUMP, '+
                                                  'HST_MAGIDX, HST_DATEX, HST_DATEFINX, HST_INITIAL)');
        Que_Upd.SQL.Add('VALUES (');
        Que_Upd.SQL.Add(inttostr(iHstId)+',');                                                                       // HST_ID
        Que_Upd.SQL.Add(inttostr(Jour)+',');                                                                         // HST_JOUR
        Que_Upd.SQL.Add(inttostr(Mois)+',');                                                                         // HST_MOIS
        Que_Upd.SQL.Add(inttostr(Annee)+',');                                                                        // HST_ANNEE
        Que_Upd.SQL.Add(inttostr(iArtId)+',');                                                                       // HST_ARTID
        Que_Upd.SQL.Add(inttostr(AgrStockFin.FieldByName('MAGID').AsInteger)+',');                                   // HST_MAGID
        Que_Upd.SQL.Add(inttostr(AgrStockFin.FieldByName('TGFID').AsInteger)+',');                                   // HST_TGFID
        Que_Upd.SQL.Add(inttostr(AgrStockFin.FieldByName('COUID').AsInteger)+',');                                   // HST_COUID
        Que_Upd.SQL.Add(inttostr(AgrStockFin.FieldByName('QTEFIN').AsInteger)+',');                                  // HST_QTE
        Que_Upd.SQL.Add(QuotedStr(FormatDateTime('mm/dd/yyyy', dMvt))+',');                                          // HST_DATE
        Que_Upd.SQL.Add(QuotedStr(FormatDateTime('mm/dd/yyyy', AgrStockFin.FieldByName('DATEFIN').AsDateTime))+','); // HST_DATEFIN
        Que_Upd.SQL.Add(ConvertInterFloat(AgrStockFin.FieldByName('PUMP').AsFloat)+',');                             // HST_PUMP
        Que_Upd.SQL.Add(inttostr(AgrStockFin.FieldByName('MAGID').AsInteger)+',');                                   // HST_MAGIDX
        Que_Upd.SQL.Add(QuotedStr(FormatDateTime('mm/dd/yyyy', dMvt))+',');                                          // HST_DATEX
        Que_Upd.SQL.Add(QuotedStr(FormatDateTime('mm/dd/yyyy', AgrStockFin.FieldByName('DATEFIN').AsDateTime))+','); // HST_DATEFINX
        Que_Upd.SQL.Add(IntToStr(AgrStockFin.FieldByName('INITIAL').AsInteger) +')');                                // HST_INITIAL
        Que_Upd.ExecSQL;
        Que_Upd.Close;

        AgrStockFin.Next;
      end;

      // mise à jour dans agrstockcour
      // effacement
      Que_Upd.Close;
      Que_Upd.SQL.Clear;
      Que_Upd.SQL.Add('delete from AGRSTOCKCOUR');
      Que_Upd.SQL.Add(' where STC_ARTID='+inttostr(iArtId));
      Que_Upd.ExecSQL;
      Que_Upd.Close;
      // ajout
      AgrStockCourt.First;
      while not(AgrStockCourt.Eof) do
      begin
        // Id
        Que_Upd.Close;
        Que_Upd.SQL.Clear;
        Que_Upd.SQL.Add('SELECT GEN_ID(AGR_ID,1) AS NEWKEY FROM RDB$DATABASE');
        Que_Upd.Open;
        iStcId := Que_Upd.FieldByName('NEWKEY').AsInteger;
        Que_Upd.Close;
        // table
        Que_Upd.Close;
        Que_Upd.SQL.Clear;
        Que_Upd.SQL.Add('INSERT INTO AGRSTOCKCOUR (STC_ID, STC_ARTID, STC_MAGID, STC_TGFID, STC_COUID, STC_QTE, STC_PUMP)');
        Que_Upd.SQL.Add('VALUES (');
        Que_Upd.SQL.Add(inttostr(iStcId)+',');                                             // STC_ID,
        Que_Upd.SQL.Add(inttostr(iArtId)+',');                                             // STC_ARTID,
        Que_Upd.SQL.Add(inttostr(AgrStockCourt.FieldByName('MAGID').AsInteger)+',');       // STC_MAGID,
        Que_Upd.SQL.Add(inttostr(AgrStockCourt.FieldByName('TGFID').AsInteger)+',');       // STC_TGFID,
        Que_Upd.SQL.Add(inttostr(AgrStockCourt.FieldByName('COUID').AsInteger)+',');       // STC_COUID,
        Que_Upd.SQL.Add(inttostr(AgrStockCourt.FieldByName('QTE').AsInteger)+',');         // STC_QTE,
        Que_Upd.SQL.Add(ConvertInterFloat(AgrStockCourt.FieldByName('PUMP').AsFloat)+')'); // STC_PUMP
        Que_Upd.ExecSQL;
        Que_Upd.Close;

        AgrStockCourt.Next;
      end;

      // mise à jour dans tarachatcour
      // effacement
//      Que_Upd.Close;
//      Que_Upd.SQL.Clear;
//      Que_Upd.SQL.Add('delete from TARACHATCOUR');
//      Que_Upd.SQL.Add(' where PAC_ARTID='+inttostr(iArtId));
//      Que_Upd.ExecSQL;
//      Que_Upd.Close;
//      // ajout
//      TARACHATCOUR.First;
//      while not(TARACHATCOUR.Eof) do
//      begin
//        dMvt := TARACHATCOUR.FieldByName('PAC_DATE').AsDateTime;
//        // Id
//        Que_Upd.Close;
//        Que_Upd.SQL.Clear;
//        Que_Upd.SQL.Add('SELECT NEWKEY FROM PROC_NEWKEY');
//        Que_Upd.Open;
//        iPacId := Que_Upd.FieldByName('NEWKEY').AsInteger;
//        Que_Upd.Close;
//        // table
//        Que_Upd.Close;
//        Que_Upd.SQL.Clear;
//        Que_Upd.SQL.Add('INSERT INTO TARACHATCOUR (PAC_ID, PAC_ARTID, PAC_TGFID, PAC_PX, PAC_PXN, PAC_PXNN, PAC_DATE, PAC_COUID)');
//        Que_Upd.SQL.Add('VALUES (');
//        Que_Upd.SQL.Add(inttostr(iPacId)+',');  // PAC_ID
//        Que_Upd.SQL.Add(inttostr(iArtId)+',');  // PAC_ARTID
//        Que_Upd.SQL.Add(inttostr(TARACHATCOUR.FieldByName('PAC_TGFID').AsInteger)+',');       // PAC_TGFID
//        Que_Upd.SQL.Add(ConvertInterFloat(TARACHATCOUR.FieldByName('PAC_PX').AsFloat)+',');   // PAC_PX
//        Que_Upd.SQL.Add(ConvertInterFloat(TARACHATCOUR.FieldByName('PAC_PXN').AsFloat)+',');  // PAC_PXN
//        Que_Upd.SQL.Add(ConvertInterFloat(TARACHATCOUR.FieldByName('PAC_PXNN').AsFloat)+','); // PAC_PXNN
//        Que_Upd.SQL.Add(QuotedStr(FormatDateTime('mm/dd/yyyy', dMvt))+',');                   // PAC_DATE
//        Que_Upd.SQL.Add(inttostr(TARACHATCOUR.FieldByName('PAC_COUID').AsInteger)+')');       // PAC_COUID
//        Que_Upd.ExecSQL;
//        Que_Upd.Close;
//
//        TARACHATCOUR.Next;
//      end;

//      // mise à jour dans ISFMVTBI
//      // effacement
//      Que_Upd.Close;
//      Que_Upd.SQL.Clear;
//      Que_Upd.SQL.Add('delete from ISFMVTBI');
//      Que_Upd.SQL.Add(' where IMB_ARTID='+inttostr(iArtId));
//      Que_Upd.ExecSQL;
//      Que_Upd.Close;
//      // ajout
//      ISFMVTBI.First;
//      while not(ISFMVTBI.Eof) do
//      begin
//        dMvt := ISFMVTBI.FieldByName('IMB_DATE').AsDateTime;
//        // table
//        Que_Upd.Close;
//        Que_Upd.SQL.Clear;
//        Que_Upd.SQL.Add('insert into isfmvtbi (imb_magid, imb_artid, imb_tgfid, imb_couid, imb_date)');
//        Que_Upd.SQL.Add('  values (');
//        Que_Upd.SQL.Add(inttostr(ISFMVTBI.FieldByName('IMB_MAGID').AsInteger)+',');    // imb_magid
//        Que_Upd.SQL.Add(inttostr(iArtId)+',');                                         // imb_artid
//        Que_Upd.SQL.Add(inttostr(ISFMVTBI.FieldByName('IMB_TGFID').AsInteger)+',');    // imb_tgfid
//        Que_Upd.SQL.Add(inttostr(ISFMVTBI.FieldByName('IMB_COUID').AsInteger)+',');    // imb_couid
//        Que_Upd.SQL.Add(QuotedStr(FormatDateTime('mm/dd/yyyy', dMvt))+')');            // imb_date
//        Que_Upd.ExecSQL;
//        Que_Upd.Close;
//
//        ISFMVTBI.Next;
//      end;

      TransacHis.Commit;
    except
      TransacHis.Rollback;
      Raise;
    end;

  finally
//    TARACHATCOUR.First;
//    TARACHATCOUR.EnableControls;

    TARCLGFOURN.First;
    TARCLGFOURN.EnableControls;

    AgrHistoStk.First;
    AgrHistoStk.EnableControls;

    AgrStockFin.First;
    AgrStockFin.EnableControls;

    AgrStockCourt.First;
    AgrStockCourt.EnableControls;

    CUMUMPUMP.First;
    CUMUMPUMP.EnableControls;

//    ISFMVTBI.First;
//    ISFMVTBI.EnableControls;

    Sql_PxAchat.Close;
    FreeAndNil(Sql_PxAchat);
    Sel_SQL.Close;
    FreeAndNil(Sel_SQL);
    Sel_SQL2.Close;
    FreeAndNil(Sel_SQL2);
    Sel_SQL3.Close;
    FreeAndNil(Sel_SQL3);
    Que_Upd.Close;
    FreeAndNil(Que_Upd);
    FreeAndNil(ListeID);
    FreeAndNil(ListeMagID);

  end;
end;

procedure TDm_Main.DataModuleCreate(Sender: TObject);
begin
  ReperBase := ExtractFilePath(ParamStr(0));
  if ReperBase[Length(ReperBase)]<>'\' then
    ReperBase := ReperBase +'\';

  TvtID := 0;

  OkTousMag := False;
  OkDeGinkoia := True;
  NePasFaireLeStock := False;

  ListeIDClient             := TStringList.Create;
  ListeIDLienClient         := TStringList.Create;
  ListeIDComptes            := TStringList.Create;
  ListeIDFidelite           := TStringList.Create;
  ListeIDBonAchats          := TStringList.Create;

  ListeIDFourn              := TStringList.Create;
  ListeCodeISFourn          := TStringList.Create;
  ListeIDMarque             := TStringList.Create;
  ListeIDFouMrk             := TStringList.Create;
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
  ListeIDArtIdeal           := TStringList.Create;
  ListeIDOcTete             := TStringList.Create;
  ListeIDOcLignes           := TStringList.Create;

  ListeIDCaisse             := TStringList.Create;
  ListeIDReception          := TStringList.Create;
  ListeIDLigneReception     := TStringList.Create;
  ListeIDConsodiv           := TStringList.Create;
  ListeIDTransfert          := TStringList.Create;
  ListeIDCommandes          := TStringList.Create;
  ListeIDRetourfou          := TStringList.Create;  // Liste RetourFournisseur
  ListeIDLigneRetourfou     := TStringList.Create;
  ListeIDAvoir              := TStringList.Create;
  ListeIDBonLivraison       := TStringList.Create;
  ListeIDBonLivraisonL      := TStringList.Create;
  ListeIDBonLivraisonHisto  := TStringList.Create;

  ListeIDBonRapprochement := TStringList.Create;
  ListeIDBonRapprochementLien := TStringList.Create;
  ListeIDBonRapprochementTVA := TStringList.Create;
  ListeIDBonRapprochementLigneReception := TStringList.Create;
  ListeIDBonRapprochementLigneRetour := TStringList.Create;

  ListeIDSavTauxH := TStringList.Create;
  ListeIDSavForfait := TStringList.Create;
  ListeIDSavForfaitL := TStringList.Create;
  ListeIDSavPt1 := TStringList.Create;
  ListeIDSavPt2 := TStringList.Create;
  ListeIDSavTypMat := TStringList.Create;
  ListeIDSavType := TStringList.Create;
  ListeIDSavMat := TStringList.Create;
  ListeIDSavCb := TStringList.Create;
  ListeIDSavFichee := TStringList.Create;
  ListeIDSavFicheL := TStringList.Create;
  ListeIDSavFicheArt := TStringList.Create;
end;

procedure TDm_Main.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(ListeIDClient);
  FreeAndNil(ListeIDLienClient);
  FreeAndNil(ListeIDComptes);
  FreeAndNil(ListeIDFidelite);
  FreeAndNil(ListeIDBonAchats);

  FreeAndNil(ListeIDFourn);
  FreeAndNil(ListeCodeISFourn);
  FreeAndNil(ListeIDMarque);
  FreeAndNil(ListeIDFouMrk);
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
  FreeAndNil(ListeIDArtIdeal);
  FreeAndNil(ListeIDOcTete);
  FreeAndNil(ListeIDOcLignes);

  FreeAndNil(ListeIDCaisse);
  FreeAndNil(ListeIDReception);
  FreeAndNil(ListeIDLigneReception);
  FreeAndNil(ListeIDConsodiv);
  FreeAndNil(ListeIDTransfert);
  FreeAndNil(ListeIDCommandes);
  FreeAndNil(ListeIDLigneRetourfou);
  FreeAndNil(ListeIDRetourfou);
  FreeAndNil(ListeIDAvoir);
  FreeAndNil(ListeIDBonLivraison);
  FreeAndNil(ListeIDBonLivraisonL);
  FreeAndNil(ListeIDBonLivraisonHisto);

  FreeAndNil(ListeIDBonRapprochement);
  FreeAndNil(ListeIDBonRapprochementLien);
  FreeAndNil(ListeIDBonRapprochementTVA);
  FreeAndNil(ListeIDBonRapprochementLigneReception);
  FreeAndNil(ListeIDBonRapprochementLigneRetour);

  FreeAndNil(ListeIDSavTauxH);
  FreeAndNil(ListeIDSavForfait);
  FreeAndNil(ListeIDSavForfaitL);
  FreeAndNil(ListeIDSavPt1);
  FreeAndNil(ListeIDSavPt2);
  FreeAndNil(ListeIDSavTypMat);
  FreeAndNil(ListeIDSavType);
  FreeAndNil(ListeIDSavMat);
  FreeAndNil(ListeIDSavCb);
  FreeAndNil(ListeIDSavFichee);
  FreeAndNil(ListeIDSavFicheL);
  FreeAndNil(ListeIDSavFicheArt);
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
        Result := ResultRechercheID64(AListe, iDebut, iMilieu-1, sRech)
      else
        Result := ResultRechercheID64(AListe, iMilieu+1, iFin, sRech);
    end;
  end
  else
    Result := -1;
end;

function TDm_Main.OpenIBDatabase(ABasePath: String): Boolean;
begin
  Result := False;

  // Ouverture de la base GINKOIA
  Database.Close;
  Database.DatabaseName := ABasePath;
  PathBase := ABasePath;
  Database.Params.Add('user_name=GINKOIA');
  Database.Params.Add('password=ginkoia');
  try
    Database.Open;
  except
    on E: Exception do
    begin
      raise Exception.Create('InitGinkoiaDB -> ' + E.Message);
    end;
  end;

  DatabaseSysdba.Close;
  DatabaseSysdba.DatabaseName := ABasePath;
  try
    DatabaseSysdba.Open;
  except
    on E: Exception do
    begin
      raise Exception.Create('InitGinkoiaDB -> ' + E.Message);
    end;
  end;

  Result := True;
end;

// fonction sur les Liste ID
procedure TDm_Main.LoadListeID(AListe: TStrings; AFileName: string);
begin
  AListe.Clear;
  if (AFileName<>'') and (FileExists(AFileName)) then
  begin
    AListe.LoadFromFile(AFileName);
//    TStringList(AListe).CustomSort(StrListCompareStrings);
    TStringList(AListe).Sort();
  end;
end;

procedure TDm_Main.SaveListeID(AListe: TStrings; AFileName: string);
begin
//  TStringList(AListe).CustomSort(StrListCompareStrings);
  TStringList(AListe).Sort();
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

//********** LienClient **********//
procedure TDm_Main.LoadListeLienClientID;
begin
  LoadListeID(ListeIDLienClient, ReperSavID+LienClientsID);
end;

procedure TDm_Main.SaveListeLienClientID;
begin
  SaveListeID(ListeIDLienClient, ReperSavID+LienClientsID);
end;

function TDm_Main.RechercheLienClientID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDLienClient, ACode, ACount);
end;

function TDm_Main.AjoutInListeLienClientID(ACode: string;
  APRMID : integer): integer;
begin
  Result := AjoutInListeID(ListeIDLienClient, ACode, IntToStr(APRMID));
end;
//********** LienClient **********//

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

//********** Fidélité **********//
procedure TDm_Main.LoadListeFideliteID;
begin
  LoadListeID(ListeIDFidelite, ReperSavID+FideliteID);
end;

procedure TDm_Main.SaveListeFideliteID;
begin
  SaveListeID(ListeIDFidelite, ReperSavID+FideliteID);
end;

function TDm_Main.RechercheFideliteID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDFidelite, ACode, ACount);
end;

function TDm_Main.AjoutInListeFideliteID(ACode: string; AFidID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDFidelite, ACode, IntToStr(AFidID));
end;

function TDm_Main.GetFideliteID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheFideliteID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDFidelite[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** Fidélité **********//

//********** Bon d'achats **********//
procedure TDm_Main.LoadListeBonAchatsID;
begin
  LoadListeID(ListeIDBonAchats, ReperSavID+BonAchatsID);
end;

procedure TDm_Main.SaveListeBonAchatsID;
begin
  SaveListeID(ListeIDBonAchats, ReperSavID+BonAchatsID);
end;

function TDm_Main.RechercheBonAchatsID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDBonAchats, ACode, ACount);
end;

function TDm_Main.AjoutInListeBonAchatsID(ACode: string; ABacID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDBonAchats, ACode, IntToStr(ABacID));
end;



function TDm_Main.GetBonAchatsID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheBonAchatsID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDBonAchats[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** Bon d'achats **********//

//********** Bon de Livraison **********//
procedure TDm_Main.LoadListeBonLivraisonID;
begin
  LoadListeID(ListeIDBonLivraison, ReperSavID+BonLivraisonID);
end;

procedure TDm_Main.SaveListeBonLivraisonID;
begin
  SaveListeID(ListeIDBonLivraison, ReperSavID+BonLivraisonID);
end;

function TDm_Main.RechercheBonLivraisonID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDBonLivraison, ACode, ACount);
end;

function TDm_Main.AjoutInListeBonLivraisonID(ACode: string;
  AID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDBonLivraison, ACode, IntToStr(AID));
end;

function TDm_Main.GetBonLivraisonID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheBonLivraisonID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDBonLivraison[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** Bon de Livraison **********//

//********** Bon de Livraison Ligne **********//
procedure TDm_Main.LoadListeBonLivraisonLID;
begin
  LoadListeID(ListeIDBonLivraisonL, ReperSavID+BonLivraisonLID);
end;

procedure TDm_Main.SaveListeBonLivraisonLID;
begin
  SaveListeID(ListeIDBonLivraisonL, ReperSavID+BonLivraisonLID);
end;

function TDm_Main.RechercheBonLivraisonLID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDBonLivraisonL, ACode, ACount);
end;

function TDm_Main.AjoutInListeBonLivraisonLID(ACode: string;
  AID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDBonLivraisonL, ACode, IntToStr(AID));
end;

function TDm_Main.GetBonLivraisonLID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheBonLivraisonLID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDBonLivraisonL[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** Bon de Livraison Ligne **********//

//********** Bon de Livraison Histo **********//
procedure TDm_Main.LoadListeBonLivraisonHistoID;
begin
  LoadListeID(ListeIDBonLivraisonHisto, ReperSavID+BonLivraisonHistoID);
end;

procedure TDm_Main.SaveListeBonLivraisonHistoID;
begin
  SaveListeID(ListeIDBonLivraisonHisto, ReperSavID+BonLivraisonHistoID);
end;

function TDm_Main.RechercheBonLivraisonHistoID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDBonLivraisonHisto, ACode, ACount);
end;

function TDm_Main.AjoutInListeBonLivraisonHistoID(ACode: string;
  AID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDBonLivraisonHisto, ACode, IntToStr(AID));
end;

function TDm_Main.GetBonLivraisonHistoID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheBonLivraisonHistoID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDBonLivraisonHisto[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** Bon de Livraison Histo **********//

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

// Mail
procedure TDm_Main.InitMail;
var
  Ini:Tinifile;
begin
  Ini := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    MailLst := Ini.ReadString('Mail', 'Dest', '');

  finally
    Ini.Free;
  end;
end;

function TDm_Main.GetMailLst: string;
begin
  Result := MailLst;
end;

procedure TDm_Main.SetNivSend(aNiv: Integer);
begin
  NivSend := aNiv;
end;

procedure TDm_Main.SetSubjectMail(aSubject: string);
begin
  Subject := aSubject;
end;

function TDm_Main.GetSubjectMail: string;
begin
  Result := Subject;
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

function TDm_Main.GetGenParamFloat(ACode, AType: Integer): Double;
var
  Que_GenParam: TIBQuery;
begin
  Que_GenParam := TIBQuery.Create( nil );
  try
    Que_GenParam.Database := Dm_Main.Database;
    Que_GenParam.Close;
    Que_GenParam.SQL.Text := 'SELECT PRM_FLOAT FROM GENPARAM WHERE PRM_TYPE = :PRMTYPE AND PRM_CODE = :PRMCODE';
    Que_GenParam.ParamByName('PRMTYPE').AsInteger  := AType;
    Que_GenParam.ParamByName('PRMCODE').AsInteger  := ACode;
    Que_GenParam.Open;

    if (not Que_GenParam.Eof) then
      Result := Que_GenParam.FieldByName('PRM_FLOAT').AsFloat
    else
      Result := 0;

    Que_GenParam.Close;
  finally
    FreeAndNil(Que_GenParam);
  end;
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

function TDm_Main.GetDoMail(aNiv: Integer): Boolean;
begin
  if aNiv <= NivSend then
    Result := True
  else
    Result := False;
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
  try
    SaveListeID(ListeIDPrixAchat, ReperSavID+PrixAchatID);
  except
    on E : Exception do
    begin
//      ShowMessage(E.Message);
    end;
  end;
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

// Lien Marque Fournisseur
procedure TDm_Main.LoadListeFouMrkID;
begin
  LoadListeID(ListeIDFouMrk, ReperSavID+FouMrkID);
end;

procedure TDm_Main.SaveListeFouMrkID;
begin
  SaveListeID(ListeIDFouMrk, ReperSavID+FouMrkID);
end;

function TDm_Main.RechercheFouMrkID(ACode: string;
  const ACount: integer): integer;
var
  sRech: string;
  iNbreEnre: integer;
begin
  Result := -1;

  sRech := ACode;

  // plage de recherche
  iNbreEnre := ACount;
  if (ACount=-1) or (ACount>ListeIDFouMrk.Count) then
    iNbreEnre := ListeIDFouMrk.Count;

  if (iNbreEnre=0) then
    exit;

  // recherche
  Result := ResultRechercheDico(ListeIDFouMrk, 0, iNbreEnre-1, sRech);
end;

function TDm_Main.AjoutInListeFouMrkID(ACode: string; AFmkID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDFouMrk, ACode, inttostr(AFmkID));
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

function TDm_Main.GetCaisseID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheCaisseID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDCaisse[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
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

//********** Ligne réception **********//
procedure TDm_Main.LoadListeLigneReceptionID;
begin
  LoadListeID(ListeIDLigneReception, ReperSavID + ReceptionLigneID);
end;

procedure TDm_Main.SaveListeLigneReceptionID;
begin
  SaveListeID(ListeIDLigneReception, ReperSavID + ReceptionLigneID);
end;

function TDm_Main.RechercheLigneReceptionID(ACode: String; const ACount: Integer): Integer;
begin
  Result := RechercheID64(ListeIDLigneReception, ACode, ACount);
end;

function TDm_Main.AjoutInListeLigneReceptionID(ACode: String; AID: Integer): Integer;
begin
  Result := AjoutInListeID64(ListeIDLigneReception, ACode, IntToStr(AID));
end;

function TDm_Main.GetLigneReceptionID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheLigneReceptionID(ACode);
  if LPos = -1 then
    Exit;

  sLigne := ListeIDLigneReception[LPos];
  if Length(sLigne) > 64 then
    sLigne := Copy(sLigne, 65, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** Ligne réception **********//

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

function TDm_Main.RechercheRetourFouID(ACode: string; const ACount: integer): integer;
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

//********** Ligne retour Fournisseur **********
procedure TDm_Main.LoadListeLigneRetourFouID;
begin
  LoadListeID(ListeIDLigneRetourfou, ReperSavID + RetourFouLigneID);
end;

procedure TDm_Main.SaveListeLigneRetourFouID;
begin
  SaveListeID(ListeIDLigneRetourfou, ReperSavID + RetourFouLigneID);
end;

function TDm_Main.RechercheLigneRetourFouID(ACode: String; const ACount: Integer): Integer;
begin
  Result := RechercheID(ListeIDLigneRetourfou, ACode, ACount);
end;

function TDm_Main.AjoutInListeLigneRetourFouID(ACode: String; AID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDLigneRetourfou, ACode, IntToStr(AID));
end;

function TDm_Main.GetLigneRetourFouID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheLigneRetourFouID(ACode);
  if LPos = -1 then
    Exit;

  sLigne := ListeIDLigneRetourfou[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** Ligne retour Fournisseur **********

//********** Avoir **********//
procedure TDm_Main.LoadListeAvoirID;
begin
  LoadListeID(ListeIDAvoir, ReperSavID+AvoirID);
end;

procedure TDm_Main.SaveListeAvoirID;
begin
  SaveListeID(ListeIDAvoir, ReperSavID+AvoirID);
end;

function TDm_Main.RechercheAvoirID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDAvoir, ACode, ACount);
end;

function TDm_Main.AjoutInListeAvoirID(ACode: string; AID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDAvoir, ACode, IntToStr(AID));
end;

function TDm_Main.GetAvoirID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheAvoirID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDAvoir[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** Avoir **********//

//********** ArtIdeal **********//
procedure TDm_Main.LoadListeArtIdealID;
begin
  LoadListeID(ListeIDArtIdeal, ReperSavID+ArtIdealID);
end;

procedure TDm_Main.SaveListeArtIdealID;
begin
  SaveListeID(ListeIDArtIdeal, ReperSavID+ArtIdealID);
end;

function TDm_Main.RechercheArtIdealID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDArtIdeal, ACode, ACount);
end;

function TDm_Main.AjoutInListeArtIdealID(ACode: string;
  AArtIdealID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDArtIdeal, ACode, IntToStr(AArtIdealID));
end;

function TDm_Main.GetArtIdealID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheArtIdealID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDArtIdeal[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** ArtIdeal **********//

//********** OcTete **********//
procedure TDm_Main.LoadListeOcTeteID;
begin
  LoadListeID(ListeIDOcTete, ReperSavID+OcTeteID);
end;

procedure TDm_Main.SaveListeOcTeteID;
begin
  SaveListeID(ListeIDOcTete, ReperSavID+OcTeteID);
end;

function TDm_Main.RechercheOcTeteID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDOcTete, ACode, ACount);
end;

function TDm_Main.AjoutInListeOcTeteID(ACode: string;
  AOcTeteID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDOcTete, ACode, IntToStr(AOcTeteID));
end;

function TDm_Main.GetOcTeteID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheOcTeteID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDOcTete[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** OcTete **********//

//********** OcLignes **********//
procedure TDm_Main.LoadListeOcLignesID;
begin
  LoadListeID(ListeIDOcLignes, ReperSavID+OcLignesID);
end;

procedure TDm_Main.SaveListeOcLignesID;
begin
  SaveListeID(ListeIDOcLignes, ReperSavID+OcLignesID);
end;

function TDm_Main.RechercheOcLignesID(ACode: string;
  const ACount: integer): integer;
begin
  Result := RechercheID(ListeIDOcLignes, ACode, ACount);
end;

function TDm_Main.AjoutInListeOcLignesID(ACode: string;
  AOcLignesID: integer): integer;
begin
  Result := AjoutInListeID(ListeIDOcLignes, ACode, IntToStr(AOcLignesID));
end;

function TDm_Main.GetOcLignesID(ACode: string): integer;
var
  LPos: integer;
  sLigne: string;
begin
  Result := -1;
  LPos := RechercheOcLignesID(ACode);
  if LPos=-1 then
    exit;

  sLigne :=  ListeIDOcLignes[LPos];
  if Length(sLigne)>32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;
//********** OcLignes **********//

//********** Bon rapprochement **********//
procedure TDm_Main.LoadListeBonRapprochementID;
begin
  LoadListeID(ListeIDBonRapprochement, ReperSavID + BonRapprochementID);
end;

procedure TDm_Main.SaveListeBonRapprochementID;
begin
  SaveListeID(ListeIDBonRapprochement, ReperSavID + BonRapprochementID);
end;

function TDm_Main.RechercheBonRapprochementID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDBonRapprochement, ACode, ACount);
end;

function TDm_Main.AjoutInListeBonRapprochementID(ACode: String; ABonRapprochementID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDBonRapprochement, ACode, IntToStr(ABonRapprochementID));
end;

function TDm_Main.GetBonRapprochementID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheBonRapprochementID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDBonRapprochement[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** Bon rapprochement lien **********//
procedure TDm_Main.LoadListeBonRapprochementLienID;
begin
  LoadListeID(ListeIDBonRapprochementLien, ReperSavID + BonRapprochementLienID);
end;

procedure TDm_Main.SaveListeBonRapprochementLienID;
begin
  SaveListeID(ListeIDBonRapprochementLien, ReperSavID + BonRapprochementLienID);
end;

function TDm_Main.RechercheBonRapprochementLienID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDBonRapprochementLien, ACode, ACount);
end;

function TDm_Main.AjoutInListeBonRapprochementLienID(ACode: String; ABonRapprochementLienID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDBonRapprochementLien, ACode, IntToStr(ABonRapprochementLienID));
end;

function TDm_Main.GetBonRapprochementLienID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheBonRapprochementLienID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDBonRapprochementLien[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** Bon rapprochement TVA **********//
procedure TDm_Main.LoadListeBonRapprochementTVAID;
begin
  LoadListeID(ListeIDBonRapprochementTVA, ReperSavID + BonRapprochementTVAID);
end;

procedure TDm_Main.SaveListeBonRapprochementTVAID;
begin
  SaveListeID(ListeIDBonRapprochementTVA, ReperSavID + BonRapprochementTVAID);
end;

function TDm_Main.RechercheBonRapprochementTVAID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDBonRapprochementTVA, ACode, ACount);
end;

function TDm_Main.AjoutInListeBonRapprochementTVAID(ACode: String; ABonRapprochementTVAID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDBonRapprochementTVA, ACode, IntToStr(ABonRapprochementTVAID));
end;

function TDm_Main.GetBonRapprochementTVAID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheBonRapprochementTVAID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDBonRapprochementTVA[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** Bon rapprochement ligne réception **********//
procedure TDm_Main.LoadListeBonRapprochementLigneReceptionID;
begin
  LoadListeID(ListeIDBonRapprochementLigneReception, ReperSavID + BonRapprochementLigneReceptionID);
end;

procedure TDm_Main.SaveListeBonRapprochementLigneReceptionID;
begin
  SaveListeID(ListeIDBonRapprochementLigneReception, ReperSavID + BonRapprochementLigneReceptionID);
end;

function TDm_Main.RechercheBonRapprochementLigneReceptionID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDBonRapprochementLigneReception, ACode, ACount);
end;

function TDm_Main.AjoutInListeBonRapprochementLigneReceptionID(ACode: String; ABonRapprochementLigneReceptionID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDBonRapprochementLigneReception, ACode, IntToStr(ABonRapprochementLigneReceptionID));
end;

function TDm_Main.GetBonRapprochementLigneReceptionID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheBonRapprochementLigneReceptionID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDBonRapprochementLigneReception[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** Bon rapprochement ligne retour **********//
procedure TDm_Main.LoadListeBonRapprochementLigneRetourID;
begin
  LoadListeID(ListeIDBonRapprochementLigneRetour, ReperSavID + BonRapprochementLigneRetourID);
end;

procedure TDm_Main.SaveListeBonRapprochementLigneRetourID;
begin
  SaveListeID(ListeIDBonRapprochementLigneRetour, ReperSavID + BonRapprochementLigneRetourID);
end;

function TDm_Main.RechercheBonRapprochementLigneRetourID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDBonRapprochementLigneRetour, ACode, ACount);
end;

function TDm_Main.AjoutInListeBonRapprochementLigneRetourID(ACode: String; ABonRapprochementLigneRetourID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDBonRapprochementLigneRetour, ACode, IntToStr(ABonRapprochementLigneRetourID));
end;

function TDm_Main.GetBonRapprochementLigneRetourID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheBonRapprochementLigneRetourID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDBonRapprochementLigneRetour[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** SavTauxH **********//
procedure TDm_Main.LoadListeSavTauxHID;
begin
  LoadListeID(ListeIDSavTauxH, ReperSavID + SavTauxHID);
end;

procedure TDm_Main.SaveListeSavTauxHID;
begin
  SaveListeID(ListeIDSavTauxH, ReperSavID + SavTauxHID);
end;

function TDm_Main.RechercheSavTauxHID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDSavTauxH, ACode, ACount);
end;

function TDm_Main.AjoutInListeSavTauxHID(ACode: String; ASavTauxHID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDSavTauxH, ACode, IntToStr(ASavTauxHID));
end;

function TDm_Main.GetSavTauxHID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheSavTauxHID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDSavTauxH[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** SavForfait **********//
procedure TDm_Main.LoadListeSavForfaitID;
begin
  LoadListeID(ListeIDSavForfait, ReperSavID + SavForfaitID);
end;

procedure TDm_Main.SaveListeSavForfaitID;
begin
  SaveListeID(ListeIDSavForfait, ReperSavID + SavForfaitID);
end;

function TDm_Main.RechercheSavForfaitID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDSavForfait, ACode, ACount);
end;

function TDm_Main.AjoutInListeSavForfaitID(ACode: String; ASavForfaitID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDSavForfait, ACode, IntToStr(ASavForfaitID));
end;

function TDm_Main.GetSavForfaitID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheSavForfaitID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDSavForfait[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** SavForfaitL **********//
procedure TDm_Main.LoadListeSavForfaitLID;
begin
  LoadListeID(ListeIDSavForfaitL, ReperSavID + SavForfaitLID);
end;

procedure TDm_Main.SaveListeSavForfaitLID;
begin
  SaveListeID(ListeIDSavForfaitL, ReperSavID + SavForfaitLID);
end;

function TDm_Main.RechercheSavForfaitLID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDSavForfaitL, ACode, ACount);
end;

function TDm_Main.AjoutInListeSavForfaitLID(ACode: String; ASavForfaitLID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDSavForfaitL, ACode, IntToStr(ASavForfaitLID));
end;

function TDm_Main.GetSavForfaitLID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheSavForfaitLID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDSavForfaitL[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** SavPt1 **********//
procedure TDm_Main.LoadListeSavPt1ID;
begin
  LoadListeID(ListeIDSavPt1, ReperSavID + SavPt1ID);
end;

procedure TDm_Main.SaveListeSavPt1ID;
begin
  SaveListeID(ListeIDSavPt1, ReperSavID + SavPt1ID);
end;

function TDm_Main.RechercheSavPt1ID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDSavPt1, ACode, ACount);
end;

function TDm_Main.AjoutInListeSavPt1ID(ACode: String; ASavPt1ID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDSavPt1, ACode, IntToStr(ASavPt1ID));
end;

function TDm_Main.GetSavPt1ID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheSavPt1ID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDSavPt1[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** SavPt2 **********//
procedure TDm_Main.LoadListeSavPt2ID;
begin
  LoadListeID(ListeIDSavPt2, ReperSavID + SavPt2ID);
end;

procedure TDm_Main.SaveListeSavPt2ID;
begin
  SaveListeID(ListeIDSavPt2, ReperSavID + SavPt2ID);
end;

function TDm_Main.RechercheSavPt2ID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDSavPt2, ACode, ACount);
end;

function TDm_Main.AjoutInListeSavPt2ID(ACode: String; ASavPt2ID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDSavPt2, ACode, IntToStr(ASavPt2ID));
end;

function TDm_Main.GetSavPt2ID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheSavPt2ID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDSavPt2[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** SavTypMat **********//
procedure TDm_Main.LoadListeSavTypMatID;
begin
  LoadListeID(ListeIDSavTypMat, ReperSavID + SavTypMatID);
end;

procedure TDm_Main.SaveListeSavTypMatID;
begin
  SaveListeID(ListeIDSavTypMat, ReperSavID + SavTypMatID);
end;

function TDm_Main.RechercheSavTypMatID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDSavTypMat, ACode, ACount);
end;

function TDm_Main.AjoutInListeSavTypMatID(ACode: String; ASavTypMatID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDSavTypMat, ACode, IntToStr(ASavTypMatID));
end;

function TDm_Main.GetSavTypMatID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheSavTypMatID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDSavTypMat[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** SavType **********//
procedure TDm_Main.LoadListeSavTypeID;
begin
  LoadListeID(ListeIDSavType, ReperSavID + SavTypeID);
end;

procedure TDm_Main.SaveListeSavTypeID;
begin
  SaveListeID(ListeIDSavType, ReperSavID + SavTypeID);
end;

function TDm_Main.RechercheSavTypeID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDSavType, ACode, ACount);
end;

function TDm_Main.AjoutInListeSavTypeID(ACode: String; ASavTypeID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDSavType, ACode, IntToStr(ASavTypeID));
end;

function TDm_Main.GetSavTypeID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheSavTypeID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDSavType[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** SavMat **********//
procedure TDm_Main.LoadListeSavMatID;
begin
  LoadListeID(ListeIDSavMat, ReperSavID + SavMatID);
end;

procedure TDm_Main.SaveListeSavMatID;
begin
  SaveListeID(ListeIDSavMat, ReperSavID + SavMatID);
end;

function TDm_Main.RechercheSavMatID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDSavMat, ACode, ACount);
end;

function TDm_Main.AjoutInListeSavMatID(ACode: String; ASavMatID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDSavMat, ACode, IntToStr(ASavMatID));
end;

function TDm_Main.GetSavMatID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheSavMatID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDSavMat[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** SavCb **********//
procedure TDm_Main.LoadListeSavCbID;
begin
  LoadListeID(ListeIDSavCb, ReperSavID + SavCbID);
end;

procedure TDm_Main.SaveListeSavCbID;
begin
  SaveListeID(ListeIDSavCb, ReperSavID + SavCbID);
end;

function TDm_Main.RechercheSavCbID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDSavCb, ACode, ACount);
end;

function TDm_Main.AjoutInListeSavCbID(ACode: String; ASavCbID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDSavCb, ACode, IntToStr(ASavCbID));
end;

function TDm_Main.GetSavCbID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheSavCbID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDSavCb[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** SavFichee **********//
procedure TDm_Main.LoadListeSavFicheeID;
begin
  LoadListeID(ListeIDSavFichee, ReperSavID + SavFicheeID);
end;

procedure TDm_Main.SaveListeSavFicheeID;
begin
  SaveListeID(ListeIDSavFichee, ReperSavID + SavFicheeID);
end;

function TDm_Main.RechercheSavFicheeID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDSavFichee, ACode, ACount);
end;

function TDm_Main.AjoutInListeSavFicheeID(ACode: String; ASavFicheeID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDSavFichee, ACode, IntToStr(ASavFicheeID));
end;

function TDm_Main.GetSavFicheeID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheSavFicheeID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDSavFichee[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** SavFicheL **********//
procedure TDm_Main.LoadListeSavFicheLID;
begin
  LoadListeID(ListeIDSavFicheL, ReperSavID + SavFicheLID);
end;

procedure TDm_Main.SaveListeSavFicheLID;
begin
  SaveListeID(ListeIDSavFicheL, ReperSavID + SavFicheLID);
end;

function TDm_Main.RechercheSavFicheLID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDSavFicheL, ACode, ACount);
end;

function TDm_Main.AjoutInListeSavFicheLID(ACode: String; ASavFicheLID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDSavFicheL, ACode, IntToStr(ASavFicheLID));
end;

function TDm_Main.GetSavFicheLID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheSavFicheLID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDSavFicheL[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

//********** SavFicheArt **********//
procedure TDm_Main.LoadListeSavFicheArtID;
begin
  LoadListeID(ListeIDSavFicheArt, ReperSavID + SavFicheArtID);
end;

procedure TDm_Main.SaveListeSavFicheArtID;
begin
  SaveListeID(ListeIDSavFicheArt, ReperSavID + SavFicheArtID);
end;

function TDm_Main.RechercheSavFicheArtID(ACode: String; const ACount: Integer = -1): Integer;
begin
  Result := RechercheID(ListeIDSavFicheArt, ACode, ACount);
end;

function TDm_Main.AjoutInListeSavFicheArtID(ACode: String; ASavFicheArtID: Integer): Integer;
begin
  Result := AjoutInListeID(ListeIDSavFicheArt, ACode, IntToStr(ASavFicheArtID));
end;

function TDm_Main.GetSavFicheArtID(ACode: String): Integer;
var
  LPos: Integer;
  sLigne: String;
begin
  Result := -1;
  LPos := RechercheSavFicheArtID(ACode);
  if LPos = -1 then
    Exit;

  sLigne :=  ListeIDSavFicheArt[LPos];
  if Length(sLigne) > 32 then
    sLigne := Copy(sLigne, 33, Length(sLigne));

  Result := StrToIntDef(sLigne, -1);
end;

// backup-restore
function TDm_Main.ArretBase(AFileBase: string): boolean;
var
  IBConfig: TIBConfigService;
begin
  IBConfig := TIBConfigService.Create(Self);
  try
    try
      IBConfig.DatabaseName := AFileBase;
      IBConfig.LoginPrompt := false;
      IBConfig.Params.Clear;
      IBConfig.Params.Add('user_name=sysdba');
      IBConfig.Params.Add('password=masterkey');
      IBConfig.Active := true;
      IBConfig.ShutdownDatabase(Forced, 5);
      IBConfig.Active := false;
      Result := true;
    finally
      IBConfig.Active := false;
      FreeAndNil(IBConfig);
    end;
  except
    Result := false;
  end;
end;

function TDm_Main.Backup(AFileBase, AFileBack, AFileLog: string; ALogProc: TProcLogBackRest): boolean;
var
  ibBackup: TIBBackupService;
  OkLog: boolean;
  sLigne: string;
  LstLog: TStringList;
begin
  Result := True;
  // OkLog := (ALogProc<>nil);
  OkLog := true;
  LstLog := TStringList.Create;
  ibBackup := TIBBackupService.Create(Self);
  try
    try
      ibBackup.Params.Clear;
      ibBackup.Params.Add('user_name=sysdba');
      ibBackup.Params.Add('password=masterkey');

      ibBackup.BackupFile.Clear;
      ibBackup.BackupFile.Add(AFileBack);

      ibBackup.DatabaseName := AFileBase;

      ibBackup.LoginPrompt := False;
      ibBackup.Verbose     := OkLog;

      ibBackup.Active := True;
      ibBackup.ServiceStart;

      if OkLog then
      begin
        while not ibBackup.Eof do
        begin
          sLigne := ibBackup.GetNextLine;
          if Pos('GBAK: ERROR', sLigne)>0 then
            Result := false;
          LstLog.Add(sLigne);
          ALogProc(sLigne);
        end;
      end;

    except
      on E: exception do
      begin
        sLigne := DateTimeToStr(Now) + '  Exception : ' + e.message;
        LstLog.Add(DateTimeToStr(Now) + '  Exception : ' + e.message);
        LstLog.Add('');
        Result := False;
      end;
    end;
  finally
    ibBackup.Active := False;
    if (AFileLog<>'') then
    begin
      try
        LstLog.SaveToFile(AFileLog);
      except
      end;
    end;
    FreeAndNil(LstLog);
    FreeAndNil(ibBackup);
  end;
end;

function TDm_Main.Backup(AFileBase, AFileBack: string; ALogProc: TProcLogBackRest): boolean;
begin
  Result := Backup(AFileBase, AFileBack, '', ALogProc);
end;

function TDm_Main.CloseIBDatabase: Boolean;
begin
  try
    Database.Close;
    Result := True;
  Except on E:Exception do
    begin
      raise Exception.Create('CloseIBDatabase -> ' + E.Message);
      Result := False;
    end;
  end;
end;

function TDm_Main.Restore(AFileBase, AFileBack, AFileLog: string; ALogProc: TProcLogBackRest): boolean;
var
  IbRestore: TIBRestoreService;
  OkLog: boolean;
  sLigne: string;
  LstLog: TStringList;
begin
  Result := True;
  // OkLog := (ALogProc<>nil);
  OkLog := true;
  LstLog := TStringList.Create;
  IbRestore := TIBRestoreService.Create(Self);
  try
    try
      IbRestore.Params.Clear;
      IbRestore.Params.Add('user_name=sysdba');
      IbRestore.Params.Add('password=masterkey');

      IbRestore.BackupFile.Clear;
      IbRestore.BackupFile.Add(AFileBack);

      ibRestore.DatabaseName.Clear;
      ibRestore.DatabaseName.Add(AFileBase);

      ibRestore.LoginPrompt := False;
      ibRestore.Verbose     := OkLog;

      ibRestore.Active := True;
      ibRestore.ServiceStart;

      if OkLog then
      begin
        while not ibRestore.Eof do
        begin
          sLigne := ibRestore.GetNextLine;
          if Pos('GBAK: ERROR', sLigne)>0 then
            Result := false;
          LstLog.Add(sLigne);
          ALogProc(sLigne);
        end;
      end;

    except
      on E: exception do
      begin
        sLigne := DateTimeToStr(Now) + '  Exception : ' + e.message;
        LstLog.Add(DateTimeToStr(Now) + '  Exception : ' + e.message);
        LstLog.Add('');
        Result := False;
      end;
    end;
  finally
    ibRestore.Active := False;
    if (AFileLog<>'') then
    begin
      try
        LstLog.SaveToFile(AFileLog);
      except
      end;
    end;
    FreeAndNil(LstLog);
    FreeAndNil(ibRestore);
  end;
end;

function TDm_Main.Restore(AFileBase, AFileBack: string; ALogProc: TProcLogBackRest): boolean;
begin
  Result := Restore(AFileBase, AFileBack, '', ALogProc);
end;

end.
