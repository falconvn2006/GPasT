unit MSS_CommandeClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type,
     MSS_SuppliersClass, MSS_BrandsClass, MSS_UniversCriteriaClass, MSS_SizesClass,
     Math, Types, MSS_PeriodsClass, MSS_CollectionsClass, HTTPApp, Windows, StrUtils,
     Dialogs, MSS_FedasClass;

 type
  TCmdStruct = record
    CDE_ID ,
    FAjout ,
    FMaj   : Integer;
    Chrono : String;
  end;

  TLigneStruct = record
    CDL_ID,
    FAJOUT,
    FMAJ : Integer;
  end;

  TCommandeClass = Class(TMainClass)
  private
    FPositionList   ,
    FItemList       ,
    FCatalogList    ,
    FModelList      ,
    FColorList      ,
    FColorItemList  ,
    FCommandeLignes ,
    FTARCLGFOUNR    ,
    FTARPRIXVENTE   ,
    FTARVALID       ,
    FTAILLETRAV     ,
    FCOULEUR        : TMainClass;

    DS_Fcds,
    DS_PositionList,
    DS_CatalogList ,
    DS_ModelList   ,
    DS_ColorList   : TDatasource;

    FNewArticleList ,
    FNewCmdList,
    FRejectCmdList  : TStringlist;
    FArtInscount, FArtMajCount : Integer;
    FCmdInsCount : Integer;
    FCmdMajCount : Integer;
//    FCdsArt: TClientDataSet;
    FTVATable: TIboQuery;
    FMarqueTable: TIboQuery;
    FFournTable: TIboQuery;

    FSupplierName : String;

    function GetMaxDelivery: TDateTime;
    function GetMinDelivery: TDateTime;
    function GetOrderDate: TDateTime;
  public
    constructor Create;override;
    Destructor Destroy;override;

    procedure Import;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;

    procedure CreateDataSet;

    // fonction permettant de récupérer l'ID fournisseur
    function GetFournId(Suppliers : TSuppliers;AERPCODE, ACODE : String) : Integer;

    // Permet de lié la marque au fournisseur
    function SetMrkFourn(AFOUID, AMRKID : Integer) : integer;
    // Permet de créer les classements (Retourne le CLA_ID)
    function SetArtClassement(ACLA_NOM, ACLA_TYPE : String;  ACLA_NUM : Integer) : Integer;
    // Permet la création de la valeur du classement (Retourne le CLI_ID);
    function SetArtItemC(AICL_NOM : String) : Integer;
    // Permet la liaison entre le classement et sa valeur (Retourne le CIT_ID)
    function SetArtClaItem(ACIT_CLAID, ACIT_ICLID : Integer) : Integer;
    // Retourne l'idTVA
    function GetTVAId(TVA_TAUX : single;TVA_CODE : String = '') : integer;
    // Permet la création de la couleur (Retourne le COU_ID)
    function SetColor(ACOU_ARTID : Integer; ACOU_CODE, ACOU_NOM : String; COU_SMU, COU_TDSC : Integer) : Integer;

    // Permet la création de l'article (Retourne ART_ID et ARF_ID)
    function SetArticle(ART_REFMRK: String; ART_MRKID, ART_GREID : INTEGER;ART_NOM, ART_DESCRIPTION,ART_COMMENT5: String;
                        ART_SSFID, ART_GTFID, ART_GARID, ARF_TVAID, ARF_ICLID3, ARF_ICLID4, ARF_ICLID5, ARF_CATID, ARF_TCTID : INTEGER;
                        ART_CODE, ART_FEDAS : String; ART_PXETIQU, ART_ACTID, ART_CENTRALE, ART_PUB : Integer) : TArtArticle;

    // Permet de récupérer un CB depuis ART_CB
    function GetNewCB : String;
    // Permet de créer un CB (Retourne le CBI_ID)
    function SetARTCodeBarre(ACBI_ARFID, ACBI_TGFID, ACBI_COUID,ACBI_TYPE : Integer;ACBI_CB : String) : Integer;

    // Procedure qui créé le prix d'achat de base d'un article (et le met à jour s'il existe) Retourne Principal
    function SetArtPrixAchat_Base(CLG_ARTID, CLG_FOUID : Integer;CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE : Single;CLG_CENTRALE : Integer) : Integer;
    // Procedure/fonction qui génèrent les prix d'achat des articles (TAILLE COULEUR)
    function SetArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID : Integer;CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE : Single;CLG_PRINCIPAL, CLG_CENTRALE : integer) : Integer;
    function UpdArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID : Integer;CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE : Single;CLG_PRINCIPAL, CLG_CENTRALE : integer) : Integer;

    // Fonction de gestion des tarifs d'achat
    function DoTarifAchat(AArticle : TArtArticle; AFOU_ID, ATGF_ID, ACOU_ID : Integer; var ATarifBase : Currency; AIsFirstTime : Boolean = false) : Boolean;
    // Fonction de gestion des tarifs de vente
    function DoTarifVente(AArticle : TArtArticle; ATGF_ID, ACOU_ID, ATPO_ID : Integer; ATPO_DT : TDate) : Boolean;
    // Permettant de mettre en mémoire les tarifs d'un article
    function DoGetTarifAchat(AArticle : TArtArticle; AFOU_ID : Integer; ADoEmptyDataSet : Boolean = True) : Boolean;
    function DoGetTarifVente(AArticle : TArtArticle) : Boolean;
    function DoGetTarifPrecoSpe(ATPO_ID : Integer) : Boolean;

    // Fonction qui générer les prix d'achat des articles avec gestion à la taille couleur
    function SetArtPrixAchat_Tmp(CLG_ARTID2, CLG_FOUID2, CLG_TGFID2, CLG_COUID2 : Integer; CLG_PX2,CLG_PXNEGO2,CLG_PXVI2 : Single) : Integer;
    // fonction qui permet de créer l'entete de commande (Retourne le CDE_ID
    function SetCOMBCDE(ACDE_SAISON, ACDE_EXEID, ACDE_CPAID, ACDE_MAGID,
                        ACDE_FOUID : Integer; ACDE_NUMFOURN : String; ACDE_DATE : TDateTime; ACDE_TVAHT1,
                        ACDE_TVATAUX1, ACDE_TVA1, ACDE_TVAHT2, ACDE_TVATAUX2, ACDE_TVA2, ACDE_TVAHT3,
                        ACDE_TVATAUX3, ACDE_TVA3, ACDE_TVAHT4, ACDE_TVATAUX4, ACDE_TVA4, ACDE_TVAHT5,
                        ACDE_TVATAUX5, ACDE_TVA5 : Extended; ACDE_LIVRAISON : TDatetime; ACDE_TYPID,
                        ACDE_USRID : Integer; ACDE_COMENT : String; ACDE_COLID, ACDE_OFFSET : Integer) : TCmdStruct;
    // fonction qui permet de créer les lignes d'une commande
    function SetCOMCDEL(CDL_CDEID, CDL_ARTID, CDL_TGFID, CDL_COUID : Integer; CDL_QTE, CDL_PXCTLG,
               CDL_REMISE1, CDL_REMISE2,CDL_PXACHAT, CDL_TVA, CDL_PXVENTE : Extended; CDL_LIVRAISON : TDateTime; CDL_COLID : Integer; ACreateMode : Boolean) : TLigneStruct;
    // Permet de rechercher les conditions de paiement
    function GetCPAID(AFOU_ID, AMAG_ID : Integer) : Integer;
    // Création de la relation/Article Taille
    function SetTailleTrav(TTV_ARTID,TTV_TGFID : Integer) : Integer;

    // Procedure qui génére le prix de vente de base et le met à jour s'il existe
    Procedure SetArtPrixVente_Base(PVT_ARTID : Integer;PVT_PX : single;PVT_CENTRALE : Integer);
    // fonction qui génère les prix de vente des articles
    function SetArtPrixVente(PVT_ARTID,PVT_TGFID, PVT_COUID, PVT_TVTID : Integer;PVT_PX : single;PVT_CENTRALE : Integer) : Integer;
    // fonction qui génère les prix de vente des articles à la taille / couleur
    function SetArtPrixVente_Tmp(PVT_TVTID,PVT_ARTID,PVT_TGFID, PVT_COUID : Integer;PVT_PX : single) : Integer;

    // fonction de liaison le larticle avec la collection
    function SetArtColArt(ART_ID, COL_ID : integer) : integer;
    // fonction de liaison de l'article avec une nomenclature secondaire
    function SetARTRelationAxe(ART_ID, SSF_ID : Integer) : integer;
    // Fonction de gestion des prrix recommandés à date
    function SetTarPreco(TPO_ARTID : Integer; TPO_DT : TDate; TPO_PX : Single; TPO_ETAT : Integer) : Integer;
    // fonctions de gestion des prix spécifique recommandé (TARVALID)
    function SetTarValid(ATVD_TPOID, ATVD_TVTID, ATVD_ARTID, ATVD_TGFID, ATVD_COUID : Integer; ATVD_PX : Currency; ATVD_DT : TDate; ATVD_ETAT : Integer) : Integer;
    function UpdTarValid(ATVD_ID : Integer; ATVD_DT : TDate; ATVD_PX : Currency) : Integer;

    // fonction permettant de retourner les informations de tarifs d'achat d'un modèle
    function GetTarifAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID, CLG_CENTRALE : Integer) : TTarifAchat;
  published

    property PositionList    : TMainClass  read FPositionList;
    property ItemList        : TMainClass  read FItemList;
    property CatalogList     : TMainClass  read FCatalogList;
    property ModelList       : TMainClass  read FModelList;
    property ColorList       : TMainCLass  read FColorList;
    property ColorItemList   : TMainClass  read FColorItemList;
    property ArtInsCount     : Integer     read FArtInscount;
    property ArtMajCount     : Integer     read FArtMajCount;
    property CmdInsCount     : Integer     read FCmdInsCount;
    property CmdMajCount     : Integer     read FCmdMajCount;

    property NewArtList      : TStringList read FNewArticleList;
    property NewCmdList      : TStringList read FNewCmdList;
    property RejectCmdList   : TStringList read FRejectCmdList;

    Property MinDeliveryDate : TDateTime   read GetMinDelivery;
    Property MaxDeliveryDate : TDateTime   read GetMaxDelivery;
    Property OrderDate       : TDateTime   read GetOrderDate;

    Property TVATable        : TIboQuery   read FTVATable    write FTVATable;
    Property MarqueTable     : TIboQuery   read FMarqueTable write FMarqueTable;
    Property FournTable      : TIboQuery   read FFournTable  write FFournTable;

    property CodeMag;
    property MAG_ID;
    property TVT_ID;
  End;

implementation

{ TCommandeClass }

constructor TCommandeClass.Create;
begin
  inherited Create;

  FPositionList  := TMainClass.Create;
  FItemList      := TMainClass.Create;
  FCatalogList   := TMainClass.Create;
  FModelList     := TMainClass.Create;
  FColorList     := TMainClass.Create;
  FColorItemList := TMainClass.Create;
  FCommandeLignes := TMainClass.Create;
  FTARCLGFOUNR    := TMainClass.Create;
  FTARPRIXVENTE   := TMainClass.Create;
  FTARVALID       := TMainClass.Create;
  FTAILLETRAV     := TMainClass.Create;
  FCOULEUR        := TMainClass.Create;


  CreateDataSet;

  FNewArticleList := TStringList.Create;
  FNewCmdList     := TStringList.Create;
  FRejectCmdList  := TStringList.Create;

  DS_Fcds := TDataSource.Create(nil);
  DS_Fcds.DataSet := Fcds;
  DS_PositionList := TDataSource.Create(nil);
  DS_PositionList.DataSet := FPositionList.ClientDataSet;

  DS_CatalogList := TDataSource.Create(nil);
  DS_CatalogList.Dataset := FCatalogList.ClientDataset;

  DS_ModelList := TDataSource.Create(nil);
  DS_ModelList.DataSet := FModelList.ClientDataSet;

  DS_ColorList := TDataSource.Create(nil);
  DS_ColorList.DataSet := FColorList.ClientDataSet;

  FMAGID := -1;
  FCODEMAG := '';
end;

procedure TCommandeClass.CreateDataSet;
var
  //Info Commande
  SupplierKey, BrandNumber, OrderNumber, OrderDate, OrderDenotation,
  OrderType, OrderCollection, OrderPeriode, OrderMemo, MemberCode, ERPNO : TFieldCFG;

  // Info Model
  PositionNumber, Code, SizeRange, DeliveryDate, DeliveryEarly, DeliveryLatest,
  PurchasePrice, REBATE1, REBATE2 : TFieldCFG;

  // ItemList
  EAN, ColNo, Columnx,Quantity, Coll : TFieldCFG;
  // Catalog
  {SupplierKey,} CatalogKey, CatalogDenotation, AddSupplierKey, AddSupplierERP : TFieldCFG;

  // Model
  ModelNumber, {BrandNumber,} Denotation, DenotationLong, Fedas, Vat, {SizeRange,} ModelType,
  RecommendedSalesPrice,RecommandedDate, Supplier2Key, Supplier2ERP, Supplier2Denotation, Pub,  ARTID, ARFID : TFieldCFG;

  // color
  ColorNumber, ColorDenotation, COU_ID : TFieldCFG;

  // Item
  {EAN , Columnx, PurchasePrice,} Smu, TDSC, SizeLabel, RetailPrice,
   ARF_ICLID3, ARF_ICLID4, TGF_ID : TFieldCFG;

  // CommandeLignes
  CDL_ID, CDL_ARTID, CDL_TGFID,CDL_COUID,CDL_QTE,CDL_PXCTLG, CDL_REMISE1,CDL_REMISE2,CDL_PXACHAT,
  CDL_TVA, CDL_PXVENTE,CDL_LIVRAISON,CDL_COLID, RAL_QTE, ART_FUSARTID, Reception, Updated, Deleted : TFieldCfg;

  // Table TARCLGFOURN
  CLG_ID, CLG_FOUID, CLG_ARTID, CLG_TGFID, CLG_COUID, CLG_PX, CLG_PRINCIPAL : TFieldCfg;

  // Table TARPRIXVENTE
  PVT_ID, PVT_TVTID, PVT_ARTID, PVT_TGFID, PVT_COUID, PVT_PX : TFieldCfg;

  // Table TARVALID
  TVD_ID, TVD_TVTID, TVD_COUID, TVD_TGFID, TVD_DT, TVD_PX, TVD_ETAT : TFieldCfg;

  // Table PLXTAILLETRAV
  TTV_TGFID : TFieldCfg;
begin
  // Commun
  OrderNumber.FieldName := 'OrderNumber';
  OrderNumber.FieldType := ftString;
  PositionNumber.FieldName := 'PositionNumber';
  PositionNumber.FieldType := ftInteger;

  SupplierKey.FieldName := 'SupplierKey';
  SupplierKey.FieldType := ftString;

  // Fichier ORD
  {$REGION 'Commande Fields'}
  BrandNumber.FieldName := 'BrandNumber';
  BrandNumber.FieldType := ftString;
  OrderDate.FieldName   := 'OrderDate';
  OrderDate.FieldType   := ftDate;
  OrderDenotation.FieldName := 'OrderDenotation';
  OrderDenotation.FieldType := ftString;
  OrderType.FieldName := 'OrderType';
  OrderType.FieldType := ftString;
  OrderCollection.FieldName := 'OrderCollection';
  OrderCollection.FieldType := ftString;
  OrderPeriode.FieldName := 'OrderPeriode';
  OrderPeriode.FieldType := ftString;
  OrderMemo.FieldName := 'OrderMemo';
  OrderMemo.FieldType := ftString;
  MemberCode.FieldName := 'MemberCode';
  MemberCode.FieldType := ftString;
  ERPNO.FieldName      := 'ErpNo';
  ERPNO.FieldType      := ftString;

  CreateField([SupplierKey, BrandNumber, OrderNumber, OrderDate, OrderDenotation,
  OrderType, OrderCollection, OrderPeriode, OrderMemo, MemberCode, ERPNO]);
  FCds.AddIndex('Idx','OrderNumber',[]);
  FCds.IndexName := 'Idx';
  {$ENDREGION}

  {$REGION 'PositionField'}
  Code.FieldName := 'Code';
  Code.FieldType := ftString;
  SizeRange.FieldName := 'SizeRange';
  SizeRange.FieldType := ftString;
  DeliveryDate.FieldName := 'DeliveryDate';
  DeliveryDate.FieldType := ftDate;
  DeliveryEarly.FieldName := 'DeliveryEarly';
  DeliveryEarly.FieldType := ftDate;
  DeliveryLatest.FieldName := 'DeliveryLatest';
  DeliveryLatest.FieldType := ftDate;
  PurchasePrice.FieldName := 'PurchasePrice';
  PurchasePrice.FieldType := ftSingle;
  REBATE1.FieldName       := 'REBATE1';
  REBATE1.FieldType       := ftSingle;
  REBATE2.FieldName       := 'REBATE2';
  REBATE2.FieldType       := ftSingle;

  FPositionList.CreateField([OrderNumber, PositionNumber, Code, SizeRange, DeliveryDate, DeliveryEarly, DeliveryLatest,
  PurchasePrice, REBATE1, REBATE2]);
  FPositionList.ClientDataSet.AddIndex('Idx','OrderNumber;PositionNumber',[]);
  FPositionList.ClientDataSet.IndexName := 'Idx';
  FPositionList.ClientDataSet.MasterFields := 'OrderNumber';
  FPositionList.ClientDataSet.MasterSource := DS_Fcds;
  {$ENDREGION}

  {$REGION 'ItemField'}
  EAN.FieldName := 'EAN';
  EAN.FieldType := ftString;
  ColNo.FieldName := 'ColNo';
  ColNo.FieldType := ftString;
  Columnx.FieldName := 'Columnx';
  Columnx.FieldType := ftString;
  Quantity.FieldName := 'Quantity';
  Quantity.FieldType := ftInteger;
  Coll.FieldName := 'COLL';
  Coll.FieldType := ftString;

  FItemList.CreateField([OrderNumber, PositionNumber,EAN, ColNo, Columnx,Quantity, PurchasePrice, Coll]);
  FItemList.ClientDataSet.AddIndex('Idx','OrderNumber;PositionNumber;ColNo;Columnx',[]);
  FItemList.ClientDataSet.IndexName := 'Idx';
  FItemList.ClientDataSet.MasterFields := 'OrderNumber;PositionNumber';
  FItemList.ClientDataSet.MasterSource := DS_PositionList;
  {$ENDREGION}

  // fichier SD
  {$REGION 'Catalog'}
  CatalogKey.FieldName := 'CatalogKey';
  CatalogKey.FieldType := ftString;
  CatalogDenotation.FieldName := 'CatalogDenotation';
  CatalogDenotation.FieldType := ftString;
  AddSupplierKey.FieldName := 'AddSupplierKey';
  AddSupplierKey.FieldType := ftString;
  AddSupplierERP.FieldName := 'AddSupplierERP';
  AddSupplierERP.FieldType := ftString;

  FCatalogList.CreateField([SupplierKey, CatalogKey, CatalogDenotation, AddSupplierKey, AddSupplierERP]);
  FCatalogList.ClientDataSet.AddIndex('Idx','SupplierKey',[]);
  FCatalogList.ClientDataSet.IndexName := 'Idx';
  {$ENDREGION}

  {$REGION 'Model'}
  ModelNumber.FieldName           := 'ModelNumber';
  ModelNumber.FieldType           := ftString;
  Denotation.FieldName            := 'Denotation';
  Denotation.FieldType            := ftString;
  DenotationLong.FieldName        := 'DenotationLong';
  DenotationLong.FieldType        := ftString;
  Fedas.FieldName                 := 'FEDAS';
  Fedas.FieldType                 := ftString;
  Vat.FieldName                   := 'VAT';
  Vat.FieldType                   := ftSingle;
  ModelType.FieldName             := 'ModelType';
  ModelType.FieldType             := ftInteger;
  RecommendedSalesPrice.FieldName := 'RecommendedSalesPrice';
  RecommendedSalesPrice.FieldType := ftSingle;
  RecommandedDate.FieldName       := 'RecommandedDate';
  RecommandedDate.FieldType       := ftDate;
  ARTID.FieldName                 := 'ART_ID';
  ARTID.FieldType                 := ftInteger;
  ARFID.FieldName                 := 'ARF_ID';
  ARFID.FieldType                 := ftInteger;
  Supplier2Key.FieldName          := 'Supplier2Key';
  Supplier2Key.FieldType          := ftString;
  Supplier2ERP.FieldName          := 'Supplier2ERP';
  Supplier2ERP.FieldType          := ftString;
  Supplier2Denotation.FieldName   := 'Supplier2Denotation';
  Supplier2Denotation.FieldType   := ftString;
  Pub.FieldName                   := 'PUB';
  Pub.FieldType                   := ftInteger;

  FModelList.CreateField([SupplierKey, ModelNumber, BrandNumber, Denotation, DenotationLong, Fedas, Vat, SizeRange, ModelType,
  RecommendedSalesPrice, RecommandedDate, Supplier2Key, Supplier2ERP,Supplier2Denotation,Pub, ARTID, ARFID]);
  FModelList.ClientDataSet.AddIndex('Idx','ModelNumber',[]);
  FModelList.ClientDataSet.IndexName := 'Idx';
  FModelList.ClientDataset.MasterSource := DS_CatalogList;
  FModelList.ClientDataset.MasterFields := 'SupplierKey';
  {$ENDREGION}

  {$REGION 'color'}
  ColorNumber.FieldName := 'ColorNumber';
  ColorNumber.FieldType := ftString;
  ColorDenotation.FieldName := 'ColorDenotation';
  ColorDenotation.FieldType := ftString;
  COU_ID.FieldName          := 'COU_ID';
  COU_ID.FieldType          := ftInteger;

  FColorList.CreateField([ModelNumber,ColorNumber, ColorDenotation, COU_ID]);
  FColorList.ClientDataSet.AddIndex('Idx','ModelNumber;ColorNumber',[]);
  FColorList.ClientDataSet.IndexName := 'Idx';
  FColorList.ClientDataSet.MasterSource := DS_ModelList;
  FColorList.ClientDataSet.MasterFields := 'ModelNumber';
  {$ENDREGION}

  {$REGION 'Item'}
  Smu.FieldName := 'SMU';
  Smu.FieldType := ftInteger;
  TDSC.FieldName := 'TDSC';
  TDSC.FieldType := ftInteger;
  SizeLabel.FieldName := 'SizeLabel';
  SizeLabel.FieldType := ftString;
  RetailPrice.FieldName := 'RetailPrice';
  RetailPrice.FieldType := ftSingle;
  ARF_ICLID3.FieldName := 'ARF_ICLID3';
  ARF_ICLID3.FieldType := ftInteger;
  ARF_ICLID4.FieldName := 'ARF_ICLID4';
  ARF_ICLID4.FieldType := ftInteger;
  TGF_ID.FieldName     := 'TGF_ID';
  TGF_ID.FieldType     := ftInteger;

  FColorItemList.CreateField([ModelNumber, ColorNumber, EAN , Columnx, SizeLabel, PurchasePrice, RetailPrice, Smu, TDSC, ARF_ICLID3, ARF_ICLID4, TGF_ID]);
  FColorItemList.ClientDataSet.AddIndex('Idx','ModelNumber;ColorNumber;Columnx',[]);
  FColorItemList.ClientDataSet.IndexName := 'Idx';
  FColorItemList.ClientDataSet.MasterSource := DS_ColorList;
  FColorItemList.ClientDataSet.MasterFields := 'ModelNumber;ColorNumber';
  {$ENDREGION}

  {$REGION 'Table ligne de commande temporaire'}
  CDL_ID.FieldName        := 'CDL_ID';
  CDL_ID.FieldType        := ftInteger;
  CDL_ARTID.FieldName     := 'CDL_ARTID';
  CDL_ARTID.FieldType     := ftInteger;
  CDL_TGFID.FieldName     := 'CDL_TGFID';
  CDL_TGFID.FieldType     := ftInteger;
  CDL_COUID.FieldName     := 'CDL_COUID';
  CDL_COUID.FieldType     := ftInteger;
  CDL_QTE.FieldName       := 'CDL_QTE';
  CDL_QTE.FieldType       := ftInteger;
  CDL_PXCTLG.FieldName    := 'CDL_PXCTLG';
  CDL_PXCTLG.FieldType    := ftCurrency;
  CDL_REMISE1.FieldName   := 'CDL_REMISE1';
  CDL_REMISE1.FieldType   := ftCurrency;
  CDL_REMISE2.FieldName   := 'CDL_REMISE2';
  CDL_REMISE2.FieldType   := ftCurrency;
  CDL_PXACHAT.FieldName   := 'CDL_PXACHAT';
  CDL_PXACHAT.FieldType   := ftCurrency ;
  CDL_TVA.FieldName       := 'CDL_TVA';
  CDL_TVA.FieldType       := ftCurrency;
  CDL_PXVENTE.FieldName   := 'CDL_PXVENTE';
  CDL_PXVENTE.FieldType   := ftCurrency;
  CDL_LIVRAISON.FieldName := 'CDL_LIVRAISON';
  CDL_LIVRAISON.FieldType := ftDateTime;
  CDL_COLID.FieldName     := 'CDL_COLID';
  CDL_COLID.FieldType     := ftInteger;
  RAL_QTE.FieldName       := 'RAL_QTE';
  RAL_QTE.FieldType       := ftInteger;
  ART_FUSARTID.FieldName  := 'ART_FUSARTID';
  ART_FUSARTID.FieldType  := ftInteger;
  Reception.FieldName     := 'Reception';
  Reception.FieldType     := ftBoolean;
  Updated.FieldName       := 'Updated';
  Updated.FieldType       := ftInteger;
  Deleted.FieldName       := 'Deleted';
  Deleted.FieldType       := ftInteger;

  FCommandeLignes.CreateField([ CDL_ID, CDL_ARTID, CDL_TGFID,CDL_COUID,CDL_QTE,
                                CDL_PXCTLG, CDL_REMISE1,CDL_REMISE2,CDL_PXACHAT,
                                CDL_TVA, CDL_PXVENTE,CDL_LIVRAISON,CDL_COLID, RAL_QTE,
                                ART_FUSARTID, Reception, Updated, Deleted]);
  FCommandeLignes.ClientDataset.AddIndex('Idx','CDL_ARTID;CDL_ARTID;CDL_COUID',[]);
  FCommandeLignes.ClientDataset.IndexName := 'Idx';
  {$ENDREGION}

  {$REGION 'Table TARCLGFOURN'}
  CLG_ID.FieldName := 'CLG_ID';
  CLG_ID.FieldType := ftInteger;
  CLG_FOUID.FieldName := 'CLG_FOUID';
  CLG_FOUID.FieldType := ftInteger;
  CLG_ARTID.FieldName := 'CLG_ARTID';
  CLG_ARTID.FieldType := ftInteger;
  CLG_TGFID.FieldName := 'CLG_TGFID';
  CLG_TGFID.FieldType := ftInteger;
  CLG_COUID.FieldName := 'CLG_COUID';
  CLG_COUID.FieldType := ftInteger;
  CLG_PX.FieldName := 'CLG_PX';
  CLG_PX.FieldType := ftCurrency;
  CLG_PRINCIPAL.FieldName := 'CLG_PRINCIPAL';
  CLG_PRINCIPAL.FieldType := ftInteger;

  FTARCLGFOUNR.CreateField([CLG_ID, CLG_FOUID, CLG_ARTID, CLG_TGFID, CLG_COUID, CLG_PX, CLG_PRINCIPAL]);
  {$ENDREGION}

  {$REGION 'Table TARPRIXVENTE'}
  PVT_ID.FieldName := 'PVT_ID';
  PVT_ID.FieldType := ftInteger;
  PVT_TVTID.FieldName := 'PVT_TVTID';
  PVT_TVTID.FieldType := ftInteger;
  PVT_ARTID.FieldName := 'PVT_ARTID';
  PVT_ARTID.FieldType := ftInteger;
  PVT_TGFID.FieldName := 'PVT_TGFID';
  PVT_TGFID.FieldType := ftInteger;
  PVT_COUID.FieldName := 'PVT_COUID';
  PVT_COUID.FieldType := ftInteger;
  PVT_PX.FieldName := 'PVT_PX';
  PVT_PX.FieldType := ftCurrency;

  FTARPRIXVENTE.CreateField([PVT_ID, PVT_TVTID, PVT_ARTID, PVT_TGFID, PVT_COUID, PVT_PX]);
  {$ENDREGION}

  {$REGION 'Table TARVALID'}
  TVD_ID.FieldName := 'TVD_ID';
  TVD_ID.FieldType := ftInteger;
  TVD_TVTID.FieldName := 'TVD_TVTID';
  TVD_TVTID.FieldType := ftInteger;
  TVD_COUID.FieldName := 'TVD_COUID';
  TVD_COUID.FieldType := ftInteger;
  TVD_TGFID.FieldName := 'TVD_TGFID';
  TVD_TGFID.FieldType := ftInteger;
  TVD_DT.FieldName := 'TVD_DT';
  TVD_DT.FieldType := ftDate;
  TVD_PX.FieldName := 'TVD_PX';
  TVD_PX.FieldType := ftCurrency;
  TVD_ETAT.FieldName := 'TVD_ETAT';
  TVD_ETAT.FieldType := ftInteger;

  FTARVALID.CreateField([TVD_ID, TVD_TVTID, TVD_COUID, TVD_TGFID, TVD_DT, TVD_PX, TVD_ETAT]);
  {$ENDREGION}

  {$REGION 'Table TAILLETRAVAILLEE & table couleur'}
  TTV_TGFID.FieldName := 'TTV_TGFID';
  TTV_TGFID.FieldType := ftInteger;
  FTAILLETRAV.CreateField([TTV_TGFID]);

  COU_ID.FieldName := 'COU_ID';
  COU_ID.FieldType := ftInteger;

  FCOULEUR.CreateField([COU_ID]);
  {$ENDREGION}


end;

destructor TCommandeClass.Destroy;
begin
  FPositionList.Free;
  FItemList.Free;
  FCatalogList.Free;
  FModelList.Free;
  FColorList.Free;
  FColorItemList.Free;
  FNewArticleList.Free;
  FNewCmdList.Free;
  FRejectCmdList.Free;
  FCommandeLignes.Free;
  FTARCLGFOUNR.Free;
  FTARPRIXVENTE.Free;
  FTARVALID.Free;
  FTAILLETRAV.Free;
  FCOULEUR.Free;

  DS_ModelList.Free;
  DS_ColorList.Free;

  DS_Fcds.Free;
  DS_PositionList.Free;
  DS_CatalogList.Free;

  inherited;
end;

function TCommandeClass.DoGetTarifAchat(AArticle: TArtArticle;
  AFOU_ID: Integer; ADoEmptyDataSet: Boolean): Boolean;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from TARCLGFOURN');
    SQL.Add('  join K on K_ID = CLG_ID and K_Enabled = 1');
    SQL.Add('Where CLG_ARTID = :PARTID');
    SQL.Add('  and CLG_FOUID = :PFOUID');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := AArticle.ART_ID;
    ParamByName('PFOUID').AsInteger := AFOU_ID;
    Open;

    if ADoEmptyDataSet then
      FTARCLGFOUNR.ClientDataSet.EmptyDataSet;

    while not EOF do
    begin
      FTARCLGFOUNR.Append;
      FTARCLGFOUNR.FieldByName('CLG_ID').AsInteger        := FieldByName('CLG_ID').AsInteger;
      FTARCLGFOUNR.FieldByName('CLG_FOUID').AsInteger     := FieldByName('CLG_FOUID').AsInteger;
      FTARCLGFOUNR.FieldByName('CLG_TGFID').AsInteger     := FieldByName('CLG_TGFID').AsInteger;
      FTARCLGFOUNR.FieldByName('CLG_COUID').AsInteger     := FieldByName('CLG_COUID').AsInteger;
      FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency       := FieldByName('CLG_PX').AsCurrency;
      FTARCLGFOUNR.FieldByName('CLG_PRINCIPAL').AsInteger := FieldByName('CLG_PRINCIPAL').AsInteger;
      FTARCLGFOUNR.Post;

      Next;
    end;
  Except on E:Exception do
    raise Exception.Create('DoGetTarifAchat -> ' + E.Message);
  end;
end;

function TCommandeClass.DoGetTarifPrecoSpe(ATPO_ID : Integer): Boolean;
begin
  Result := False;
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from TARVALID');
    SQL.Add('  join K on K_ID = TVD_ID and K_Enabled = 1');
    SQL.Add('Where TVD_TPOID = :PTPOID');
    ParamCheck := True;
    ParamByName('PTPOID').AsInteger := ATPO_ID;
    Open;

    FTARVALID.ClientDataSet.EmptyDataSet;
    while not EOF do
    begin
      FTARVALID.Append;
      FTARVALID.FieldByName('TVD_ID').AsInteger := FieldByName('TVD_ID').AsInteger;
      FTARVALID.FieldByName('TVD_TVTID').AsInteger := FieldByName('TVD_TVTID').AsInteger;
      FTARVALID.FieldByName('TVD_TGFID').AsInteger := FieldByName('TVD_TGFID').AsInteger;
      FTARVALID.FieldByName('TVD_COUID').AsInteger := FieldByName('TVD_COUID').AsInteger;
      FTARVALID.FieldByName('TVD_DT').AsDateTime := FieldByName('TVD_DT').AsDateTime;
      FTARVALID.FieldByName('TVD_PX').AsCurrency := FieldByName('TVD_PX').AsCurrency;
      FTARVALID.FieldByName('TVD_ETAT').AsInteger := FieldByName('TVD_ETAT').AsInteger;
      FTARVALID.Post;

      Next;
    end;
    Result := True;

  Except on E:Exception do
    raise Exception.Create('DoGetTarifPrecoSpe -> ' + E.Message);
  end;
end;

function TCommandeClass.DoGetTarifVente(AArticle: TArtArticle): Boolean;
begin
  Result := False;
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from TARPRIXVENTE');
    SQL.Add('  Join K on K_ID = PVT_ID and K_Enabled = 1');
    SQL.Add('Where PVT_ARTID = :PARTID');
//    SQL.Add('  and PVT_TVTID = 0');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := AArticle.ART_ID;
    Open;

    FTARPRIXVENTE.ClientDataSet.EmptyDataSet;
    while not EOF do
    begin
      FTARPRIXVENTE.Append;
      FTARPRIXVENTE.FieldByName('PVT_ID').AsInteger := FieldByName('PVT_ID').AsInteger;
      FTARPRIXVENTE.FieldByName('PVT_TVTID').AsInteger := FieldByName('PVT_TVTID').AsInteger;
      FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := FieldByName('PVT_TGFID').AsInteger;
      FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := FieldByName('PVT_COUID').AsInteger;
      FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := FieldByName('PVT_PX').AsCurrency;
      FTARPRIXVENTE.Post;
      Next;
    end;
  Except on E:Exception do
    raise Exception.Create('DoGetTarifVente -> ' + E.Message);
  end;
end;

function TCommandeClass.DoMajTable(ADoMaj: Boolean): Boolean;
var
  i,j, iCount : Integer;

//  cTypeFedas, cGenreFedas : AnsiChar;
  GRE_ID, GREHomme, GREFemme, GREEnfant, GREBaby, GREUnisexe : Integer;

  FOU_ID, FOU_ID_SECONDAIRE, FMK_ID, SSF_ID_UNIC, SSF_ID_FEDAS : Integer;
  CLA_ID3, CLA_ID4, CLA_ID5 : Integer;
  ICL_ID3, ICL_ID4, ICL_ID5 : Integer;
  TVA_ID, COU_ID, TGF_ID, CBI_ID, CLG_ID, TCT_ID : Integer;
  CDE_ID, TYP_ID, EXE_ID, CDL_ID, USR_ID, COL_ID, CPA_ID : Integer;
  CBI_CB, ModelNumber : String;
  CDL_COLID, ACT_ID  : Integer;
  CDL_PXCLG : Currency;
  TPO_ID : Integer;
  TPO_DT : TDate;
  ArtFusion : TARTFUSION;

  MinDate : TDateTime;
  bFound : Boolean;
  iFound : Integer;

  Suppliers : TSuppliers;
  bDoFindSupplierTbTmp, bFindMode, bFoundFOUID, bCheckFOU2 : Boolean;
  sLocateSupplierField ,
  sLocateTbTmpField    ,
  sLocateValue         : String;
  iPass : Integer;

  Brands : TBrands;
  bDoFindBrandTbTmp : Boolean;

  Univers : TUniversCriteria;
  Fedas   : TFedas;
  bFoundSSFUNIC, bFoundSSFFEDAS : Boolean;

  Sizes : TSizes;
  Periods : TPeriods;
  PeriodsLib : String;
  Collections : TCollections;
  CollectionLib :String;

  Article : TArtArticle;
  bDoTarifBase : Boolean;
  TarifAchat : TTarifAchat;
  MRK_NOM : String;

  Commande : TCmdStruct;
  bContinue : Boolean;
  ART_ID, ART_FUSARTID : Integer;
  CDL_QTE, CDL_QTE_Ligne : Integer;
  sError, sOrderCollection : String;

  LigneCmd : TLigneStruct;
  iTmpTGFID, iTmpCOUID : Integer;

  BookM, BookMPosList, BookMItemList : TBookmark;
  bDoMaj, bIsFusion : Boolean;

  TVALignesVerif : Array of TTVA;

  bFirstTarifAchat ,
  bFirstTarifVente ,
  bDoMajAchat      : Boolean;
  TarifAchatBase ,
  TarifVenteBase : Currency;



//  Begintime, endtime,TickPerSec : int64;
//  BegintimeTotal, EndtimeTotal : Int64;
//  iTmp, iTmp2, iTmp3 : Int64;
//
//  iTmpTotal : Int64;
//
//  iTmpInit, iTmpMrkBrands, iTmpMrkTable, iTmpMrkBase,
//  iTmpMrkFourn, iTmpFedasInt, iTmpFedasBase,
//  iTmpGTInt, iTmpGTBase, iTmpGTNew, iTmpTVA,
//  iTmpArt, iTmpArtTarif, iTmpArtRel,
//  iTmpRecoDate, iTmpTailleInt, iTmpTailleBase, iTmpTailleNew,
//  iTmpTailleTrav, iTmpColor, iTmpCB,
//  iTmpAchat1, iTmpAchat2, iTmpVente1,
//  iTmpAchatCrea1, iTmpAchatCrea2, iTmpVenteCrea1 : Int64;
//
//  iTmpColl, iTmpCMD, iTmpLng, iTmpCPA, iTmpEXE, iCount : Int64;
begin
  Try
//    iTmpInit := 0;
//    iCount := 0;
//    QueryPerformanceCounter(BeginTimeTotal);
//
//    QueryPerformanceCounter(BeginTime);

    {$REGION 'Initialisation'}
    for i := Low(MasterData) to High(MasterData) do
    begin
      if MasterData[i].MainData.InheritsFrom(TSuppliers) then
        Suppliers := TSuppliers(MasterData[i].MainData);

      if MasterData[i].MainData.InheritsFrom(TBrands) then
        Brands := TBrands(MasterData[i].MainData);

      if MasterData[i].MainData.InheritsFrom(TUniversCriteria) then
        Univers := TUniversCriteria(MasterData[i].MainData);

      if MasterData[i].MainData.InheritsFrom(TSizes) then
        Sizes := TSizes(MasterData[i].MainData);

      if MasterData[i].MainData.InheritsFrom(TPeriods) then
        Periods := TPeriods(MasterData[i].MainData);

      if MasterData[i].MainData.InheritsFrom(TCollections) then
        Collections := TCollections(MasterData[i].MainData);

      if MasterData[i].MainData.InheritsFrom(TFedas) then
        Fedas := TFedas(MasterData[i].MainData);
    end;
    // Type comptable
    Try
      GetGenParam(12,3,TCT_ID);
    Except
      on ENOTFIND do raise Exception.Create('Type comptable non trouvé');
      on ECFGERROR do raise Exception.Create('Type comptable : configuration incorrecte (valeur 0)');
      on E:Exception do raise Exception.Create(E.Message);
    End;
    // Domaine
    Try
      GetGenParam(12,15,ACT_ID);
    Except
      on ENOTFIND do raise Exception.Create('Domaine non trouvé');
      on ECFGERROR do raise Exception.Create('Domaine : configuration incorrecte (valeur 0)');
      on E:Exception do raise Exception.Create(E.Message);
    End;
    {$ENDREGION}

//    QueryPerformanceCounter(EndTime);
//    QueryPerformanceFrequency(TickPerSec);
//    iTmpInit := Round((EndTime - BeginTime) / TickPerSec * 1000);
//    FErrLogs.Add(Format(' - Initialisation %d',[iTmpInit]));

    //-----------------------
    // Création des articles
    //-----------------------
    FCatalogList.First;
    while not FCatalogList.EOF do
    begin

      {$REGION 'Création du classement 5'}
//      if FCatalogList.FieldByName('CATALOGKEY').AsString <> '' then
//      begin
//        ICL_ID5 := SetArtItemC(FCatalogList.FieldByName('CATALOGKEY').AsString);
//        SetArtClaItem(CLA_ID5,ICL_ID5);
//      end;
      ICL_ID5 := 0;
    {$ENDREGION}

      {$REGION 'Recherche du suppliers'}
//      iTmp  := 0;
//      iTmp2 := 0;
//      iTmp3 := 0;

      bFoundFOUID := False;
      FOU_ID_SECONDAIRE := -1;
      iPass := 0;
      while not bFoundFOUID do
      begin
        while not bFoundFOUID do
        begin
          case iPass of
            0: begin // ERP
              bFindMode := Trim(FCatalogList.FieldByName('AddSupplierERP').AsString) <> '';
              sLocateSupplierField := 'ErpNo';
              sLocateTbTmpField    := 'FOU_ERPNO';
              sLocateValue         := FCatalogList.FieldByName('AddSupplierERP').AsString;
              Suppliers.ClientDataSet.IndexName := 'IdxERP';
            end;
            1: begin // Code
              bFindMode := True;
              sLocateSupplierField := 'CodeFourn';
              sLocateTbTmpField    := 'FOU_CODE';
              if trim(FCatalogList.FieldByName('AddSupplierKey').AsString) <> '' then
                sLocateValue       := FCatalogList.FieldByName('AddSupplierKey').AsString
              else
                sLocateValue       := FCatalogList.FieldByName('SupplierKey').AsString;
              Suppliers.ClientDataSet.IndexName := 'IdxCODE';
            end;
            2: begin // ERP fournisseur 2
              bFindMode := Trim(FModelList.FieldByName('Supplier2ERP').AsString) <> '';
              sLocateSupplierField := 'ErpNo';
              sLocateTbTmpField    := 'FOU_ERPNO';
              sLocateValue         := FModelList.FieldByName('Supplier2ERP').AsString;
              Suppliers.ClientDataSet.IndexName := 'IdxERP';
            end;
            3: begin // Code Fournisseur 2
              bFindMode := True;
              sLocateSupplierField := 'CodeFourn';
              sLocateTbTmpField    := 'FOU_CODE';
              if trim(FModelList.FieldByName('Supplier2Key').AsString) <> '' then
                sLocateValue       := FModelList.FieldByName('Supplier2Key').AsString;
              Suppliers.ClientDataSet.IndexName := 'IdxCODE';
            end;
            else begin
              raise Exception.Create(Format('Fournisseur non trouvé: ERP %s / ASK %s / SK %s',[FCatalogList.FieldByName('AddSupplierERP').AsString,FCatalogList.FieldByName('AddSupplierKey').AsString, FCatalogList.FieldByName('SupplierKey').AsString]));
            end;
          end;

          if bFindMode then
          begin
            bDoFindSupplierTbTmp := False;
//            QueryPerformanceCounter(BeginTime);
//            iTmp  := -1;
//            iTmp2 := -1;
//            iTmp3 := -1;
            if Suppliers.IsUpdated then
            begin
              if Suppliers.ClientDataSet.Locate(sLocateSupplierField,sLocateValue,[]) then
              begin
//                QueryPerformanceCounter(EndTime);
//                QueryPerformanceFrequency(TickPerSec);
//                iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                iTmpTotal := iTmpTotal + iTmp;

                case iPass of
                  0,1: begin
                    FOU_ID := Suppliers.FieldByName('FOU_ID').AsInteger;
                    if FOU_ID <= 0 then
                      bDoFindSupplierTbTmp := True
                    else
                      bFoundFOUID := True;
                  end;
                  2,3 : begin
                    FOU_ID_SECONDAIRE := Suppliers.FieldByName('FOU_ID').AsInteger;
                    if FOU_ID_SECONDAIRE <= 0 then
                      bDoFindSupplierTbTmp := True
                    else
                      bFoundFOUID := True;
                  end;
                end; // case
              end
              else
                bDoFindSupplierTbTmp := True;
            end
            else
              bDoFindSupplierTbTmp := True;

            if bDoFindSupplierTbTmp then
            begin
              if FournTable.Locate(sLocateTbTmpField,sLocateValue,[]) then
              begin
                case iPass of
                  0,1: FOU_ID := FournTable.FieldByName('FOU_ID').AsInteger;
                  2,3: FOU_ID_SECONDAIRE := FournTable.FieldByName('FOU_ID').AsInteger;
                end; /// case
                bFoundFOUID := True;
//                QueryPerformanceCounter(EndTime);
//                QueryPerformanceFrequency(TickPerSec);
//                iTmp2 := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                iTmpTotal := iTmpTotal + iTmp2;
              end
              else begin
                case iPass of
                  0,1: FOU_ID := Suppliers.GetSuppliers(sLocateSupplierField,sLocateValue);
                  2,3: FOU_ID_SECONDAIRE := Suppliers.GetSuppliers(sLocateSupplierField,sLocateValue);
                end;
                bFoundFOUID := True;
//                QueryPerformanceCounter(EndTime);
//                QueryPerformanceFrequency(TickPerSec);
//                iTmp3 := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                iTmpTotal := iTmpTotal + iTmp3;
              end;
            end;
          end;

//          FErrLogs.Add(Format(' - Pass : %s = %d, Fournisseur : Brands %d / FFOUTABLE %d / Base %d',[sLocateSupplierField,iPass, iTmp,iTmp2,iTmp3]));
          Inc(iPass);
        end; // while iPass

        // Vérification que le fournisseur et le fournisseur secondaire sont identiques
        // Si non alors on refait une (ou deux ) passe afin de récupérer le FOU_ID_SECONDAIRE
        bFoundFOUID := ((FCatalogList.FieldByName('AddSupplierERP').AsString = FModelList.FieldByName('Supplier2ERP').AsString) and
                       (FCatalogList.FieldByName('AddSupplierKey').AsString = FModelList.FieldByName('Supplier2Key').AsString)) or
                       ((FModelList.FieldByName('Supplier2ERP').AsString = '') and (FModelList.FieldByName('Supplier2Key').AsString = '')) or
                       (iPass >= 2);
        iPass := 2;
      end; // while
      {$ENDREGION}

      FModelList.First;
      while not FModelList.Eof do
      begin
        // Dans le cas où l''on a plusieurs noeuds dans CatalogList
        if FCatalogList.FieldByName('SupplierKey').AsString = FModelList.FieldByName('SupplierKey').AsString then
        begin

          {$REGION 'Recherche du brands (Marque)'}
          bDoFindBrandTbTmp := False;
//          iTmpMrkBrands := 0;
//          iTmpMrkTable := 0;
//          iTmpMrkBase := 0;

          // Si il y a eu mise à jour du des brands alors on utilise la table d'import temporaire
          if Brands.IsUpdated then
          begin
//            QueryPerformanceCounter(BeginTime);
            if (Brands.FieldByName('CodeMarque').AsString = FModelList.FieldByName('BrandNumber').AsString) and
               (Brands.FieldByName('MRK_ID').AsInteger > 0) then
            begin
              Article.MRK_ID := Brands.FieldByName('MRK_ID').AsInteger;
              MRK_NOM := Brands.FieldByName('Denotation').AsString;
            end
            else begin
              if Brands.ClientDataSet.Locate('CodeMarque',FModelList.FieldByName('BrandNumber').AsString,[loCaseInsensitive]) then
              begin
//                QueryPerformanceCounter(EndTime);
//                QueryPerformanceFrequency(TickPerSec);
//                iTmpMrkBrands := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                iTmpTotal := iTmpTotal + iTmpMrkBrands;

                Article.MRK_ID := Brands.FieldByName('MRK_ID').AsInteger;
                MRK_NOM := Brands.FieldByName('Denotation').AsString;
                if Article.MRK_ID <= 0 then
                  // Si on ne trouve pas les infos (ce qui ne devrait pas arriver) alors on cherche dans la table en mémoire
                  bDoFindBrandTbTmp := True;
              end
              else
                raise Exception.Create('BrandNumber inéxistant : ' + FModelList.FieldByName('BrandNumber').AsString);
            end;
          end else
            bDoFindBrandTbTmp := True;
          if bDoFindBrandTbTmp then
          begin
            // Recherche dans la table en mémoire
//            QueryPerformanceCounter(BeginTime);
            if (FMarqueTable.FieldByName('MRK_CODE').AsString = FModelList.FieldByName('BrandNumber').AsString) and
               (FMarqueTable.FieldByName('MRK_ID').AsInteger > 0) then
              Article.MRK_ID := FMarqueTable.FieldByName('MRK_ID').AsInteger
            else begin
              if FMarqueTable.Locate('MRK_CODE',FModelList.FieldByName('BrandNumber').AsString,[]) then
              begin
                Article.MRK_ID := FMarqueTable.FieldByName('MRK_ID').AsInteger;
                MRK_NOM := FMArqueTable.FieldByName('MRK_NOM').AsString;
//                QueryPerformanceCounter(EndTime);
//                QueryPerformanceFrequency(TickPerSec);
//                iTmpMrkTable := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                iTmpTotal := iTmpTotal + iTmpMrkTable;
              end
              else begin
                if Brands.ClientDataSet.Locate('CodeMarque',FModelList.FieldByName('BrandNumber').AsString,[loCaseInsensitive]) then
                begin
                  // On recherche dans la base et on créé au cas où
                  Article.MRK_ID := Brands.GetBrands;
                  MRK_NOM := Brands.FieldByName('Denotation').AsString;
                end
                else
                  raise Exception.Create('BrandNumber inéxistant : ' + FModelList.FieldByName('BrandNumber').AsString);
//                QueryPerformanceCounter(EndTime);
//                QueryPerformanceFrequency(TickPerSec);
//                iTmpMrkBase := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                iTmpTotal := iTmpTotal + iTmpMrkBase;
              end;
            end;
          end;
          {$ENDREGION}

          {$REGION 'Traitement de la liaison de la marque avec le fournisseur'}
//          QueryPerformanceCounter(BeginTime);
          FMK_ID := SetMrkFourn(FOU_ID,Article.MRK_ID);
//          QueryPerformanceCounter(EndTime);
//          QueryPerformanceFrequency(TickPerSec);
//          iTmpMrkFourn := Round((EndTime - BeginTime) / TickPerSec * 1000);
//          iTmpTotal := iTmpTotal + iTmpMrkFourn;

          // Gestion 2em fournisseur
          if FOU_ID_SECONDAIRE <> -1 then
          begin
//            QueryPerformanceCounter(BeginTime);
            SetMrkFourn(FOU_ID_SECONDAIRE,Article.MRK_ID);
//            QueryPerformanceCounter(EndTime);
//            QueryPerformanceFrequency(TickPerSec);
//            iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
          end;
          {$ENDREGION}

          {$REGION 'Recherche de la sousfamille via la FEDAS'}
            // recherche par l'universcritéria
//            QueryPerformanceCounter(BeginTime);
//            iTmpFedasInt  := 0;
//            iTmpFedasBase := 0;
            bFound := False;
            SSF_ID_UNIC := -1;
            bFoundSSFUNIC := False;
            if Univers.IsUpdated then
            begin
              if Univers.Fedas.ClientDataSet.Locate('Aggregationlevelfourigiic',FModelList.FieldByName('FEDAS').AsString,[loCaseInsensitive]) then
              begin
                With Univers.Fedas.ClientDataSet do
                  if Univers.NKLSSfamille.ClientDataSet.Locate('LVL1ID;LVL2ID;LVL3ID;Aggregationlevelfourid',
                     VarArrayOf([FieldByName('LVL1ID').AsString,FieldByName('LVL2ID').AsString,
                                 FieldByName('LVL3ID').AsString,FieldByName('LVL4ID').AsString]),[loCaseInsensitive]) then
                  begin
//                    QueryPerformanceCounter(EndTime);
//                    QueryPerformanceFrequency(TickPerSec);
//                    iTmpFedasInt := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                    iTmpTotal := iTmpTotal + iTmpFedasInt;
//                    iTmpFedasBase := 0;

                    SSF_ID_UNIC := Univers.NKLSSFamille.FieldByName('SSF_ID').AsInteger;
                    bFoundSSFUNIC := (SSF_ID_UNIC <= 0);
                  end;
              end;
            end;

            SSF_ID_FEDAS := -1;
            bFoundSSFFEDAS := False;
            if Fedas.IsUpdated then
            begin
              if Fedas.NKLSSFamille.ClientDataSet.Locate('Code',FModelList.FieldByName('FEDAS').AsString,[loCaseInsensitive]) then
              begin
                SSF_ID_FEDAS := Fedas.NKLSSFamille.FieldByName('SSF_ID').AsInteger;
                bFoundSSFFEDAS := (SSF_ID_UNIC <= 0);
              end;
            end;

            if (not bFoundSSFUNIC) or (not bFoundSSFFEDAS) then
            begin
              // recherche dans la base de données
//              QueryPerformanceCounter(BeginTime);
              With FIboQuery do
              begin
                Close;
                SQL.Clear;
                SQL.Add('Select AXX_SSFID1, AXX_SSFID2 from NKLSSFAMILLE');
                SQL.Add('  join K on K_ID = SSF_Id and K_Enabled = 1');
                SQL.Add('  join NKLAXEAXE on AXX_SSFID2 = SSF_ID');
                SQL.Add('Where SSF_CODEFINAL = :PCODEFINAL');
                SQL.Add('  and SSF_CENTRALE = 1');
                ParamCheck := True;
                ParamByName('PCODEFINAL').AsString := FModelList.FieldByName('FEDAS').AsString;
                Open;
                if RecordCount > 0 then
                begin
                  if SSF_ID_UNIC = -1 then
                    SSF_ID_UNIC := FieldByName('AXX_SSFID1').AsInteger;
                  if SSF_ID_FEDAS = -1 then
                    SSF_ID_FEDAS := FieldByName('AXX_SSFID2').AsInteger;
                end
                else
                  raise Exception.Create(Format('Sous famille non trouvé Code Fedas : %s', [FModelList.FieldByName('FEDAS').AsString]));
              end;
//              QueryPerformanceCounter(EndTime);
//              QueryPerformanceFrequency(TickPerSec);
//              iTmpFedasBase := Round((EndTime - BeginTime) / TickPerSec * 1000);
//              iTmpTotal := iTmpTotal + iTmpFedasBase;
            end;
          {$ENDREGION}

          {$REGION 'Récupération du genre de l''article'}
          GRE_ID := 0; // On ne gère plus le genre
//          cTypeFedas := AnsiChar(FModelList.FieldByName('FEDAS').AsString[1]);
//          cGenreFedas := AnsiChar(FModelList.FieldByName('FEDAS').AsString[Length(FModelList.FieldByName('FEDAS').AsString[1])]);
//          GRE_ID := GREUnisexe;
//          if cTypeFedas in ['2','3'] then
//            case cGenreFedas of
//              '1': GRE_ID := GREHomme;
//              '2': GRE_ID := GREFemme;
//              '3': GRE_ID := GREEnfant;
//              '4': GRE_ID := GREBaby;
//            end;
          {$ENDREGION}

          {$REGION 'Récupération de la grille de taille de l''article'}
          // récupération dans les tables en mémoire
          bFound := False;
          if Sizes.IsUpdated then
          begin
            if (Sizes.PLXGTF.FieldByName('ID').AsString = FModelList.FieldByName('SizeRange').AsString) and
               (Sizes.PLXGTF.FieldByName('GTF_ID').AsInteger > 0) then
              Article.GTF_ID := Sizes.PLXGTF.FieldByName('GTF_ID').AsInteger
            else begin
              if Sizes.PLXGTF.ClientDataSet.Locate('ID',FModelList.FieldByName('SizeRange').AsString,[loCaseInsensitive]) then
              begin
                Article.GTF_ID := Sizes.PLXGTF.FieldByName('GTF_ID').AsInteger;
                bFound := not(Article.GTF_ID <= 0);
              end;
            end;
          end;

          if Not bFound then
          begin
//            QueryPerformanceCounter(BeginTime);
            With FIboQuery do
            begin
              Close;
              SQL.Clear;
              SQL.Add('Select GTF_ID from PLXGTF');
              SQL.Add('  join K on K_ID = GTF_ID and K_Enabled = 1');
              SQL.Add('Where GTF_CODE = :PGTFCODE');
              ParamCheck := True;
              ParamByName('PGTFCODE').AsString := FModelList.FieldByName('SizeRange').AsString;
              Open;
//              QueryPerformanceCounter(EndTime);
//              QueryPerformanceFrequency(TickPerSec);
//              iTmpGTBase := Round((EndTime - BeginTime) / TickPerSec * 1000);
//              iTmpTotal := iTmpTotal + iTmpGTBase;

              if RecordCount > 0 then
                Article.GTF_ID := FieldByName('GTF_ID').AsInteger
              else begin
                // Si la taille n'exite pas en base on vérifie si on l'a en mémoire et on l'a crée
                bFound := False;
//                QueryPerformanceCounter(BeginTime);
                if Sizes.PLXGTF.ClientDataSet.Locate('ID',FModelList.FieldByName('SizeRange').AsString,[loCaseInsensitive]) then
                  if Sizes.PLXTYPEGT.ClientDataSet.Locate('ID',Sizes.PLXGTF.FieldByName('MSRID').AsString,[loCaseInsensitive]) then
                  begin
                    Article.GTF_ID := Sizes.GetSubRange;
                    bFound := True;
                  end;
//                QueryPerformanceCounter(EndTime);
//                QueryPerformanceFrequency(TickPerSec);
//                iTmpGTNew := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                iTmpTotal := iTmpTotal + iTmpGTNew;

                if not bFound then
                  raise Exception.Create(Format('Grille de taille Inéxistante %s',[FModelList.FieldByName('SizeRange').AsString]));
              end;
            end;
          end;
          {$ENDREGION}

          {$REGION 'Récupération de la TVA'}
//          QueryPerformanceCounter(BeginTime);
            if CompareValue(FModelList.FieldByName('VAT').AsSingle,0, 0.001) = EqualsValue then
              raise Exception.Create('TVA à 0 pour le modèle - Intégration impossible');

            TVA_ID := GetTVAId(FModelList.FieldByName('VAT').AsSingle,'');
//          QueryPerformanceCounter(EndTime);
//          QueryPerformanceFrequency(TickPerSec);
//          iTmpTVA := Round((EndTime - BeginTime) / TickPerSec * 1000);
//          iTmpTotal := iTmpTotal + iTmpTVA;
          {$ENDREGION}

          {$REGION 'Génération des classements 3 et 4'}
//          FColorItemList.First;
//          While not FColorItemList.Eof do
//          begin
//            if FColorItemList.FieldByName('TDSC').AsString = '1' then
//              ICL_ID3 := SetArtItemC('OUI')
//            else
//              ICL_ID3 := SetArtItemC('NON');
//
//            if FColorItemList.FieldByName('SMU').AsString = '1' then
//              ICL_ID4 := SetArtItemC('OUI')
//            else
//              ICL_ID4 := SetArtItemC('NON');
//
//            SetArtClaItem(CLA_ID3,ICL_ID3);
//            SetArtClaItem(CLA_ID4,ICL_ID4);
//
//            FColorItemList.ClientDataSet.Edit;
//            FColorItemList.FieldByName('ARF_ICLID3').AsInteger := ICL_ID3;
//            FColorItemList.FieldByName('ARF_ICLID4').AsInteger := ICL_ID4;
//            FColorItemList.ClientDataSet.Post;
//
//            FColorItemList.Next;
//          end;
         {$ENDREGION}

          {$REGION 'génération de l''article'}
//          QueryPerformanceCounter(BeginTime);
          if (FModelList.FieldByName('ModelType').AsInteger = 2) and
             (FModelList.FieldByName('ART_ID').AsInteger > 0) then // ART_ID initialisé à -1 lors de l'import
          begin
            // ModelType 2 : Article Ginkoia
            Article.ART_ID := FModelList.FieldByName('ART_ID').AsInteger;
            Article.FAjout := 0;
            Article.FMaj   := 0;
            With FIboQuery do
            begin
              Close;
              SQL.Clear;
              SQL.Add('Select ARF_ID, ARF_CHRONO, ART_GTFID, GTF_CODE from ARTREFERENCE');
              SQL.Add('  join K on K_ID = ARF_ID and K_Enabled = 1');
              SQL.Add('  Join ARTARTICLE on ARF_ARTID = ART_ID');
              SQL.Add('  join K on K_ID = ART_ID and K_enabled = 1');
              SQL.Add('  Join PLXGTF on ART_GTFID = GTF_ID');
              SQL.Add('Where ARF_ARTID = :PARTID');
              ParamCheck := True;
              ParamByName('PARTID').AsInteger := Article.ART_ID;
              Open;
              if RecordCount > 0 then
              begin
                if Article.GTF_ID <> FieldByName('ART_GTFID').AsInteger then
                  raise Exception.Create(Format('La grille de taille ne correspond pas :' +
                                                ' Modèle %s%s Fichier %s - Article %s',[FModelList.FieldByName('MODELNUMBER').AsString,
                                                                                        FModelList.FieldByName('BRANDNUMBER').AsString,
                                                                                        FModelList.FieldByName('SizeRange').AsString,
                                                                                        FieldbyName('GTF_CODE').AsString]));

                Article.ARF_ID := FieldByName('ARF_ID').AsInteger;
                Article.Chrono := FieldByName('ARF_CHRONO').AsString;

                FModelList.ClientDataSet.Edit;
                FModelList.ClientDataSet.FieldByName('ARF_ID').AsInteger := Article.ARF_ID;
                FModelList.ClientDataSet.Post;
              end
              else
                raise Exception.Create(Format('Modèle non trouvé : %s%s - Id Ginkoia : %d',[FModelList.FieldByName('MODELNUMBER').AsString,
                                                                                           FModelList.FieldByName('BRANDNUMBER').AsString,
                                                                                           Article.ART_ID]));
            end;
          end
          else begin
            // ModelType 1 : Article Centrale
            Article := SetArticle(
              FModelList.FieldByName('MODELNUMBER').AsString, // ART_REFMRK
              Article.MRK_ID, // ART_MRKID,
              GRE_ID, // ART_GREID: INTEGER;
              FModelList.FieldByName('DENOTATION').AsString, // ART_NOM,
              FModelList.FieldByName('DENOTATIONLONG').AsString, // ART_DESCRIPTION,
              FModelList.FieldByName('FEDAS').AsString, // ART_COMMENT5: String;
              SSF_ID_FEDAS, // ART_SSFID,
              Article.GTF_ID, // ART_GTFID,
              0, // ART_GARID,
              TVA_ID, // ARF_TVAID,
              0,//FColorItemList.FieldByName('ARF_ICLID3').AsInteger, //ARF_ICLID3,
              0, //FColorItemList.FieldByName('ARF_ICLID4' ).AsInteger, //ARF_ICLID4,
              ICL_ID5, // ARF_ICLID5,
              0, // ARF_CATID,
              TCT_ID, // ARF_TCTID: INTEGER
              FModelList.FieldByName('MODELNUMBER').AsString + FModelList.FieldByName('BRANDNUMBER').AsString, // ART_CODE
              FModelList.FieldByName('FEDAS').AsString, // ART_FEDAS
              0, // ART_PXETIQU
              ACT_ID, // ART_ACTID
              FModelList.FieldByName('ModelType').AsInteger, //ART_CENTRALE
              FModelList.FieldByName('PUB').AsInteger
            );
          end; // if
//          QueryPerformanceCounter(EndTime);
//          QueryPerformanceFrequency(TickPerSec);
//          iTmpArt := Round((EndTime - BeginTime) / TickPerSec * 1000);
//          iTmpTotal := iTmpTotal + iTmpArt;

          bDoTarifBase := True;
          if Article.FAjout = 0 then
          begin
            // Récupération du tarif d'achat de base
            TarifAchat := GetTarifAchat( Article.ART_ID,FOU_ID,0,0,-1);
          end; // if FAjout
          {$ENDREGION}

          {$REGION 'Gestion de la FEDAS'}
          if Article.FAjout = 0 then
            With FIboQuery do
            begin
              Close;
              SQL.Clear;
              SQL.Add('SELECT * FROM MSS_SDUPD_MAJFEDAS(:PARTID, :PIDFEDAS)');
              ParamCheck := True;
              ParamByName('PARTID').AsInteger := Article.ART_ID;
              ParamByName('PIDFEDAS').AsInteger:= SSF_ID_FEDAS;
              Open;

              if RecordCount > 0 then
              begin
                Inc(FMajCount,FieldbyName('FMAJ').AsInteger);
                Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
              end;
            end;
          {$ENDREGION}

          // Création de la relation Article et Univers secondaire
          if Article.FAjout > 0 then
            SetARTRelationAxe(Article.ART_ID,SSF_ID_UNIC);

          {$REGION 'Gestion Prix recommandé à date'}
          // On ne gère les prix recommandés que s'il n'y a pas d'ajout d'article
//          TPO_ID := 0;
//          TPO_DT := FModelList.FieldByName('RecommandedDate').AsDateTime;
//          if Article.FAjout = 0 then
//          begin
//            // On ne traite que les dates recommandées supérieures à la date du jour
//            if FModelList.FieldByName('RecommandedDate').AsDateTime > Now then
//              TPO_ID := SetTarPreco(Article.ART_ID, FModelList.FieldByName('RecommandedDate').AsDateTime,FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,0)
//            else begin
//              if FPositionList.ClientDataSet.Locate('CODE',FModelList.FieldByName('MODELNUMBER').AsString + FModelList.FieldByName('BRANDNUMBER').AsString,[loCaseInsensitive]) then
//                TPO_ID := SetTarPreco(Article.ART_ID, FPositionList.FieldByName('DELIVERYDATE').AsDateTime,FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,0)
//              else
//                raise Exception.Create(FModelList.FieldByName('MODELNUMBER').AsString + FModelList.FieldByName('BRANDNUMBER').AsString + ' - Article non présent dans la commande');
//              TPO_DT := FPositionList.FieldByName('DELIVERYDATE').AsDateTime;
//            end;
//          end;
          {$ENDREGION}

          {$REGION 'Déarchivation du modèle'}
          if Article.FAjout = 0 then
          begin
            DesarchiveArticle(Article.ART_ID);
          end;
          {$ENDREGION}

          // Génération des informations que l'article (Taille, couleur, tarif, etc..)
          FColorList.First;

          {$REGION 'Initialisation & Récupération des données Tarifs de l''article'}
          bFirstTarifAchat := False;
          bFirstTarifVente := False;

          // Récupération des tarif d'achat
          DoGetTarifAchat(Article,FOU_ID);
          if (FOU_ID <>  FOU_ID_SECONDAIRE) and (FOU_ID_SECONDAIRE <> -1) then
            DoGetTarifAchat(Article,FOU_ID_SECONDAIRE,False);

          // Récupération des tarifs de vente
          DoGetTarifVente(Article);

          // Récupération des données de prix recommandé à date
          DoGetTarifPrecoSpe(TPO_ID);
          {$ENDREGION}

          while not FColorList.Eof do
          begin
            // Dans le cas où il y aurait plusieurs model à gérer
            if FColorList.FieldByName('MODELNUMBER').AsString = FModelList.FieldByName('MODELNUMBER').AsString then
            begin
              FColorItemList.First;
              while not FColorItemList.Eof do
              begin
                // Dans le cas où il y ai plusieurs models
                if (FColorItemList.FieldByName('MODELNUMBER').AsString = FModelList.FieldByName('MODELNUMBER').AsString) and
                   (FColorItemList.FieldByName('COLORNUMBER').AsString = FColorList.FieldByName('COLORNUMBER').AsString) then
                begin

                  {$REGION 'Récupération de la taille'}
                  bFound := False;
//                  QueryPerformanceCounter(BeginTime);
//                  iTmpTailleInt := 0;
//                  iTmpTailleBase := 0;
//                  iTmpTailleNew := 0;

                  if Sizes.IsUpdated then
                  begin
                    if (Sizes.PLXTAILLESGF.FieldByName('SRID').AsString = FModelList.FieldByName('SizeRange').AsString) and
                       (Sizes.PLXTAILLESGF.FieldByName('Columnx').AsString = FColorItemList.FieldByName('Columnx').AsString) and
                       (Sizes.PLXTAILLESGF.FieldByName('TGF_ID').AsInteger > 0)  then
                      TGF_ID := Sizes.PLXTAILLESGF.FieldByName('TGF_ID').AsInteger
                    else begin
                      if Sizes.PLXTAILLESGF.ClientDataSet.Locate('SRID;Columnx',VarArrayof([FModelList.FieldByName('SizeRange').AsString,FColorItemList.FieldByName('Columnx').AsString]),[loCaseInsensitive]) then
                      begin
                        TGF_ID := Sizes.PLXTAILLESGF.FieldByName('TGF_ID').AsInteger;
//                        QueryPerformanceCounter(EndTime);
//                        QueryPerformanceFrequency(TickPerSec);
//                        iTmpTailleInt := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                        iTmpTotal := iTmpTotal + iTmpTailleInt;
                        bFound := not (TGF_ID <= 0);
                      end;
                    end;
                  end;

                  if not bFound then
                  begin
//                    QueryPerformanceCounter(BeginTime);
                    With FIboQuery do
                    begin
                      Close;
                      SQL.Clear;
                      SQL.Add('Select TGF_ID from PLXTAILLESGF');
                      SQL.Add('  join K on K_ID = TGF_ID and K_Enabled = 1');
                      SQL.Add('Where TGF_GTFID = :PGTFID');
                      SQL.Add('  and TGF_COLUMNX = :PCOLUMNX');
                      ParamCheck := True;
                      ParamByName('PGTFID').AsInteger := Article.GTF_ID;
                      ParamByName('PCOLUMNX').AsString := FColorItemList.FieldByName('Columnx').AsString;
                      Open;
//                      QueryPerformanceCounter(EndTime);
//                      QueryPerformanceFrequency(TickPerSec);
//                      iTmpTailleBase := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                      iTmpTotal := iTmpTotal + iTmpTailleBase;

                      if RecordCount > 0 then
                        TGF_ID := FieldByName('TGF_ID').AsInteger
                      else begin
                        bFound := False;
//                        QueryPerformanceCounter(BeginTime);
                        if Sizes.PLXGTF.ClientDataSet.Locate('ID',FModelList.FieldByName('SizeRange').AsString,[loCaseInsensitive]) then
                          if Sizes.PLXTYPEGT.ClientDataSet.Locate('ID',Sizes.PLXGTF.FieldByName('MSRID').AsString,[loCaseInsensitive]) then
                            if Sizes.PLXTAILLESGF.ClientDataSet.Locate('SRID;Columnx',VarArrayof([FModelList.FieldByName('SizeRange').AsString,FColorItemList.FieldByName('Columnx').AsString]),[loCaseInsensitive]) then
                            begin
                              TGF_ID := Sizes.GetSizes;
                              bFound := True;
                            end;
//                        QueryPerformanceCounter(EndTime);
//                        QueryPerformanceFrequency(TickPerSec);
//                        iTmpTailleNew := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                        iTmpTotal := iTmpTotal + iTmpTailleNew;

                        if not bFound then
                          raise Exception.Create(Format('Modèle %s - Taille Inéxistante -> SizeRange %s / Columnx %s',[FModelList.FieldByName('MODELNUMBER').AsString,FModelList.FieldByName('SizeRange').AsString,FColorItemList.FieldByName('Columnx').AsString]));
                      end;
                    end;
                  end;

                  if FColorItemList.FieldByName('TGF_ID').AsInteger <= 0 then
                  begin
                    FColorItemList.ClientDataSet.Edit;
                    FColorItemList.FieldByName('TGF_ID').AsInteger := TGF_ID;
                    FColorItemList.ClientDataSet.Post;
                  end;
                  {$ENDREGION}

                  {$REGION 'Gestion de la relation Taille/Article'}
//                  if (Article.FAjout > 0) then
//                  begin
                    SetTailleTrav(Article.ART_ID,TGF_ID);
//                  end;
                  {$ENDREGION}

                  {$REGION 'Création de la couleur'}
//                  QueryPerformanceCounter(BeginTime);
                  if FColorList.FieldByName('COU_ID').AsInteger <= 0 then
                  begin
                    COU_ID := SetColor(Article.ART_ID,
                                       FColorList.FieldByName('COLORNUMBER').AsString,
                                       FColorList.FieldByName('COLORDENOTATION').AsString,
                                       FColorItemList.FieldByName('SMU').AsInteger,
                                       FColorItemList.FieldByName('TDSC').AsInteger);

                    FColorList.ClientDataSet.Edit;
                    FColorList.FieldByName('COU_ID').AsInteger := COU_ID;
                    FColorList.ClientDataSet.Post;
                  end
                  else
                    COU_ID := FColorList.FieldByName('COU_ID').AsInteger;
//                  QueryPerformanceCounter(EndTime);
//                  QueryPerformanceFrequency(TickPerSec);
//                  iTmpColor := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                  iTmpTotal := iTmpTotal + iTmpColor;
                  {$ENDREGION}

                  {$REGION 'Gestion des CB'}
//                  QueryPerformanceCounter(BeginTime);
                  // Création du CB Ginkoia
                    // -1 sur le CBI_CB pour indiquer qu'il faut générer le CB (Utile que pour le type 1 ici)
                    CBI_ID := SetARTCodeBarre(Article.ARF_ID,TGF_ID,COU_ID,1,'-1');
//                  end;

                  // Création du CB
                  if FColorItemList.FieldByName('EAN').AsString <> '' then
                  begin
                    CBI_ID := SetARTCodeBarre(Article.ARF_ID,TGF_ID,COU_ID,3,FColorItemList.FieldByName('EAN').AsString);
                  end;
//                  QueryPerformanceCounter(EndTime);
//                  QueryPerformanceFrequency(TickPerSec);
//                  iTmpCB := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                  iTmpTotal := iTmpTotal + iTmpCB;
                  {$ENDREGION}

                  {$REGION 'Gestion des tarifs d''achat'}
                  // Cas du premier tarif d'achat de la liste
                  bContinue := True;
                  if not bFirstTarifAchat then
                  begin
                    TarifAchatBase := FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency;
                    DoTarifAchat(Article,FOU_ID,TGF_ID,COU_ID,TarifAchatBase,True);
                    if (FOU_ID_SECONDAIRE <> -1) and (FOU_ID <> FOU_ID_SECONDAIRE) then
                      DoTarifAchat(Article,FOU_ID_SECONDAIRE,TGF_ID,COU_ID,TarifAchatBase,True);

                    bFirstTarifAchat := True;
                  end
                  else begin
                    DoTarifAchat(Article,FOU_ID,TGF_ID,COU_ID,TarifAchatBase);
                    if (FOU_ID_SECONDAIRE <> -1) and (FOU_ID <> FOU_ID_SECONDAIRE) then
                      DoTarifAchat(Article,FOU_ID_SECONDAIRE,TGF_ID,COU_ID,TarifAchatBase);
                  end;
                  {$ENDREGION}

                  {$REGION 'Gestion des tarifs de vente'}
                  DoTarifVente(Article,TGF_ID, COU_ID, TPO_ID, TPO_DT);
                  {$ENDREGION}
                end; // if MODELNUMBER

                FColorItemList.Next;
              end; // while

            end; // if MODELNUMBER
            FColorList.Next;
          end; //while

          // Génération du logs pour le mail
          if Article.FAjout > 0 then
          begin
            FNewArticleList.Add('<tr>');
            FNewArticleList.Add('<td class ="CODEART-LG">' + FModelList.FieldByName('MODELNUMBER').AsString + '</td>'); // code article
            FNewArticleList.Add('<td class ="CHRONO-LG">'+ Article.Chrono + '</td>'); // chrono
            FNewArticleList.Add('<td class ="ARTNOM-LG">' + FModelList.FieldByName('DENOTATION').AsString + '</td>'); // Libellé
            FNewArticleList.Add('<td class ="MARQUE-LG ">' + MRK_NOM + '</td>'); // Marque
            FNewArticleList.Add('<td class ="ETAT-LG">Création</td>'); // Etat
            FNewArticleList.Add('</tr>');
          end;
        end; // if

        FModelList.Next;
      end; // WHILE
      FCatalogList.Next;
    end;

    //    QueryPerformanceCounter(BeginTimeTotal);

    //-----------------------
    // Création des commandes
    //-----------------------
    IsCreated := False;
    IsUpdated := False;
    IsOnError := False;

    SetLength(TVALignes,5);
    SetLength(TVALignesVerif,5);
    FCds.First;
    while not FCDS.Eof do
    begin

      // Récupération du fournisseur
      FOU_ID := GetFournId(Suppliers,FCds.FieldByName('ErpNo').AsString,FCds.FieldByName('SupplierKey').AsString); // Suppliers.GetSuppliers('CodeFourn',FCds.FieldByName('SupplierKey').AsString);

      {$REGION 'Calcul du tableau de TVA + Récupération de la date de livraison (MinDate) + Récup Collection '}
      // Initialisation du tableau de TVA
      for i := 0 to Length(TVALignes) -1 do
        With TVALignes[i] do
        begin
          CDE_TVAHT := 0;
          CDE_TVATAUX := 0;
          CDE_TVA := 0;
        end;

      FPositionList.First;
      MinDate := 0;
      sOrderCollection := '';
      while not FPositionList.Eof do
      begin
        if FPositionList.FieldByName('OrderNumber').AsString = FCds.FieldByName('OrderNumber').AsString then
        begin
          // récupération du Numéro de model
          ModelNumber := Copy(Trim(FPositionList.FieldByName('CODE').AsString),1,Length(Trim(FPositionList.FieldByName('CODE').AsString)) -3);

          // Récupération de la plus petite date de livraison
          if MinDate = 0 then
            MinDate := FPositionList.FieldByName('DELIVERYDATE').AsDateTime
          else
            if CompareDateTime(FPositionList.FieldByName('DELIVERYDATE').AsDateTime,MinDate) = LessThanValue then
              MinDate := FPositionList.FieldByName('DELIVERYDATE').AsDateTime;

          FItemList.First;
          while not FItemList.Eof do
          begin
            // récupération de la collection de la première ligne
            if Trim(sOrderCollection) = '' then
              sOrderCollection := FItemList.FieldByName('Coll').AsString;

            if (FItemList.FieldByName('OrderNumber').AsString = Fcds.FieldByName('OrderNumber').AsString) and
               (FItemList.FieldByName('PositionNumber').AsString = FPositionList.FieldByName('PositionNumber').AsString) then
            begin
              // Positionnement sur le model
              if FModelList.ClientDataSet.Locate('ModelNumber',ModelNumber,[locaseInsensitive]) then
              begin
                // Positionnement sur la couleur
           //     if FColorList.ClientDataSet.Locate('ModelNumber;ColorNumber',VarArrayOf([ModelNumber,FItemList.FieldByName('ColNo').AsString]),[loCaseInsensitive]) then
                begin
                  bFound := False;
                  for i := 0 to Length(TVALignes) do
                    if CompareValue(TVALignes[i].CDE_TVATAUX,FModelList.FieldByName('VAT').AsCurrency,0.01) = EqualsValue then
                    begin
                      bFound := True;
                      iFound := i;
                    end; // if
                  if bFound then
                  begin
                    With TVALignes[iFound] do
                    begin
                      CDL_PXCLG := FItemList.FieldByName('PURCHASEPRICE').AsCurrency *
                                  (1 - FPositionList.FieldByName('REBATE1').AsCurrency / 100) *
                                  (1 - FPositionList.FieldByName('REBATE2').AsCurrency / 100);
                      CDE_TVAHT := CDE_TVAHT + CDL_PXCLG{FitemList.FieldByName('PURCHASEPRICE').AsCurrency} * FitemList.FieldByName('Quantity').AsCurrency;
                      CDE_TVA   := CDE_TVA + (CDL_PXCLG{FitemList.FieldByName('PURCHASEPRICE').AsCurrency} * FitemList.FieldByName('Quantity').AsCurrency) * CDE_TVATAUX / 100;
                    end; // with
                  end else
                  begin
                    bFound := False;
                    for i := 0 to Length(TVALignes) do
                      if not bFound and (TVALignes[i].CDE_TVATAUX = 0)  then
                      begin
                        With TVALignes[i] do
                        begin
                          CDL_PXCLG := FItemList.FieldByName('PURCHASEPRICE').AsCurrency *
                                      (1 - FPositionList.FieldByName('REBATE1').AsCurrency / 100) *
                                      (1 - FPositionList.FieldByName('REBATE2').AsCurrency / 100);
                          CDE_TVATAUX := FModelList.FieldByName('VAT').AsCurrency;
                          CDE_TVAHT := CDL_PXCLG{FitemList.FieldByName('PURCHASEPRICE').AsCurrency} * FitemList.FieldByName('Quantity').AsCurrency;
                          CDE_TVA   := CDE_TVAHT * CDE_TVATAUX / 100;
                          bFound := True;
                        end; // with
                      end; // if
                  end; // if bfound
                end; // if locate
              end; // if locate
            end; // if OrderNumber
            FItemList.Next;
          end; // while
        end;
        FPositionList.Next;
      end;
      {$ENDREGION}

      // Récupération du USRID
      Try
        GetGenParam(12,8,FMAGID, USR_ID);
      Except
        on ENOTFIND do raise Exception.Create('Utilisateur non trouvé');
        on ECFGERROR do raise Exception.Create('Utilisateur : configuration incorrecte (valeur 0)');
        on E:Exception do raise Exception.Create(E.Message);
      End;

      {$REGION 'Récupération des CDV'}
//      if FCDs.FieldByName('ORDERTYPE').AsString = '' then
//        TYP_ID  := GetGenTypCDV(1,101)
//      Else
        TYP_ID  := GetGenTypCDV(1,StrToIntDef(FCDs.FieldByName('ORDERTYPE').AsString,101));
      {$ENDREGION}

      {$REGION 'Récupération de le collection de la commande & Exercice commercial'}
      bContinue := True;
      if sOrderCollection <> '' then
      begin
        // Recherche de la collection dans la liste en mémoire
        if Collections.ClientDataSet.Locate('Code',sOrderCollection{FCds.FieldByName('OrderCollection').AsString},[loCaseInsensitive]) then
        begin
          COL_ID := Collections.FieldByName('COL_ID').AsInteger;
          if COL_ID <= 0 then
            COL_ID := Collections.GetCollectionID;
          CollectionLib := Collections.FieldByName('Denotation').AsString;
          EXE_ID := Periods.GetPeriods(Collections.FieldByName('CodePeriod').AsString,Collections.FieldByName('YearPeriod').Asinteger);
          PeriodsLib := Periods.FieldByName('Year').AsString;
          bContinue := False;
        end
      end;

      if bContinue then
      begin
        // Si on a pas trouvé la collection, on recherche via l'exercice commercial
        // et la plus petite date de livraison
        EXE_ID := Periods.GetPeriods(MinDate);
        PeriodsLib := Periods.FieldByName('Year').AsString;
        With FIboQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select COL_ID,COL_NOM from ARTCOLLECTION');
          SQL.Add('  Join K on K_ID = COL_ID and K_Enabled = 1');
          SQL.Add('  Join GENEXERCICECOMMERCIAL on COL_CODE = EXE_CODE || EXE_ANNEE');
          SQL.Add('Where EXE_ID = :PEXEID');
          ParamCheck := True;
          ParamByName('PEXEID').AsInteger := EXE_ID;
          Open;

          COL_ID := FieldByName('COL_ID').AsInteger;
          CollectionLib := FieldByName('COL_NOM').AsString;
        end;
      end;

      if (EXE_ID = 0) or (COL_ID = 0) then
        raise Exception.Create(Format('Exercice comemrcial ou collection non trouvé : %d, %d',[EXE_ID,COL_ID]));
      {$ENDREGION}

      {$REGION 'Recherche des conditions de paiement'}
//      QueryPerformanceCounter(BeginTime);
      CPA_ID := GetCPAID(FOU_ID, FMAGID);
      if CPA_ID = 0 then
        CPA_ID := GetCPAID(FOU_ID, 0);
      if CPA_ID = 0 then
        CPA_ID := GetIDFromTable('GENCDTPAIEMENT','CPA_CODE',16,'CPA_ID');
//      QueryPerformanceCounter(EndTime);
//      QueryPerformanceFrequency(TickPerSec);
//      iTmpCPA := Round((EndTime - BeginTime) / TickPerSec * 1000);
//      iTmpTotal := iTmpTotal + iTmpCPA;
      {$ENDREGION}

      {$REGION 'Création de l''entete de la commande'}
      Commande := SetCOMBCDE(0, //  ACDE_SAISON,
                           EXE_ID, // ACDE_EXEID,
                           CPA_ID, // ACDE_CPAID,
                           FMAGID, // ACDE_MAGID,
                           FOU_ID, // ACDE_FOUID: Integer;
                           Fcds.FieldByName('ORDERNUMBER').AsString, //ACDE_NUMFOURN: String;
                           FCds.FieldByName('ORDERDATE').AsDateTime, // ACDE_DATE: TDateTime;
                           TVALignes[0].CDE_TVAHT, TVALignes[0].CDE_TVATAUX, TVALignes[0].CDE_TVA, // ACDE_TVAHT1, ACDE_TVATAUX1, ACDE_TVA1,
                           TVALignes[1].CDE_TVAHT, TVALignes[1].CDE_TVATAUX, TVALignes[1].CDE_TVA, // ACDE_TVAHT2, ACDE_TVATAUX2, ACDE_TVA2,
                           TVALignes[2].CDE_TVAHT, TVALignes[2].CDE_TVATAUX, TVALignes[2].CDE_TVA, // ACDE_TVAHT3, ACDE_TVATAUX3, ACDE_TVA3,
                           TVALignes[3].CDE_TVAHT, TVALignes[3].CDE_TVATAUX, TVALignes[3].CDE_TVA, // ACDE_TVAHT4, ACDE_TVATAUX4, ACDE_TVA4,
                           TVALignes[4].CDE_TVAHT, TVALignes[4].CDE_TVATAUX, TVALignes[4].CDE_TVA, // ACDE_TVAHT5, ACDE_TVATAUX5, ACDE_TVA5: Extended;
                           MinDate, // ACDE_LIVRAISON: TDatetime;
                           TYP_ID, // ACDE_TYPID,
                           USR_ID, // ACDE_USRID: Integer;
                           FCds.FieldByName('ORDERDENOTATION').AsString + ' ' + FCds.FieldByName('ORDERMEMO').AsString, // ACDE_COMENT: String;
                           COL_ID, // ACDE_COLID,
                           Abs(DaysBetween(FPositionList.FieldByName('DELIVERYLATEST').AsDateTime,FPositionList.FieldByName('DELIVERYEARLY').AsDateTime)) // ACDE_OFFSET : Integer
                           );
      IsCreated := (Commande.FAjout > 0);
      {$ENDREGION}

      {$REGION 'Création des lignes de la commande'}
      FPositionList.First;
      // On ajoute les lignes que si l'entête de commande est différent de -1
      // si -1 c'est que la commande est déjà en réception
      if Commande.CDE_ID <> -1 then
      begin
        ART_ID := -1;

        {$REGION 'Mise en memoire des lignes d''une commande si on est dans le cas d''un repassage d''une commande'}
        if (Commande.FAjout = 0) and (Commande.FMaj >= 0) then
        begin
          FCommandeLignes.ClientDataSet.EmptyDataset;
          With FiboQuery do
          Begin
            Close;
            SQL.Clear;
            SQL.Add('Select  CDL_ID, CDL_ARTID, CDL_TGFID,CDL_COUID,CDL_QTE, RAL_QTE, ART_FUSARTID,');
            SQL.Add('        CDL_PXCTLG, CDL_REMISE1,CDL_REMISE2,CDL_PXACHAT,');
            SQL.Add('        CDL_TVA, CDL_PXVENTE,CDL_LIVRAISON,CDL_COLID From COMBCDEL');
            SQL.Add('  Join K on K_ID = CDL_ID and K_Enabled = 1');
            SQL.Add('  Join ARTARTICLE ON ART_ID = CDL_ARTID');
            SQL.Add('  Left join AGRRAL on RAL_CDLID = CDL_ID');
            SQL.Add('Where CDL_CDEID = :PCDEID');
            SQL.Add('Order By CDL_ID');
            PAramCheck := True;
            PAramByName('PCDEID').AsInteger := Commande.CDE_ID;
            Open;

            while Not EOF do
            Begin
              FCommandeLignes.ClientDataSet.Append;
              FCommandeLignes.FieldByName('CDL_ID').AsInteger               := FieldByName('CDL_ID').AsInteger;
              FCommandeLignes.FieldByName('CDL_ARTID').AsInteger            := FieldByName('CDL_ARTID').AsInteger;
              FCommandeLignes.FieldByName('CDL_TGFID').AsInteger            := FieldByName('CDL_TGFID').AsInteger;
              FCommandeLignes.FieldByName('CDL_COUID').AsInteger            := FieldByName('CDL_COUID').AsInteger;
              FCommandeLignes.FieldByName('CDL_QTE').AsInteger              := FieldByName('CDL_QTE').AsInteger;
              FCommandeLignes.FieldByName('CDL_PXCTLG').AsCurrency          := FieldByName('CDL_PXCTLG').AsCurrency;
              FCommandeLignes.FieldByName('CDL_REMISE1').AsCurrency         := FieldByName('CDL_REMISE1').AsCurrency;
              FCommandeLignes.FieldByName('CDL_REMISE2').AsCurrency         := FieldByName('CDL_REMISE2').AsCurrency;
              FCommandeLignes.FieldByName('CDL_PXACHAT').AsCurrency         := FieldByName('CDL_PXACHAT').AsCurrency;
              FCommandeLignes.FieldByName('CDL_TVA').AsCurrency             := FieldByName('CDL_TVA').AsCurrency;
              FCommandeLignes.FieldByName('CDL_PXVENTE').AsCurrency         := FieldByName('CDL_PXVENTE').AsCurrency;
              FCommandeLignes.FieldByName('CDL_LIVRAISON').AsDateTime       := FieldByName('CDL_LIVRAISON').AsDateTime;
              FCommandeLignes.FieldByName('CDL_COLID').AsInteger            := FieldByName('CDL_COLID').AsInteger;
              FCommandeLignes.FieldByName('RAL_QTE').AsInteger              := FieldByName('RAL_QTE').AsInteger;
              FCommandeLignes.FieldByName('ART_FUSARTID').AsInteger         := FieldByName('ART_FUSARTID').AsInteger;
              FCommandeLignes.FieldByName('Reception').AsBoolean            := FieldByName('CDL_QTE').AsInteger <> FieldByName('RAL_QTE').AsInteger;
              FCommandeLignes.FieldByName('Updated').AsInteger              := 0;
              FCommandeLignes.FieldByName('Deleted').AsInteger              := 1;
              FCommandeLignes.ClientDataSet.Post;
              Next;
            End;
          End;
        end;
        {$ENDREGION}

        while not FPositionList.EOF do
        begin
          if FPositionList.FieldByName('OrderNumber').AsString = FCds.FieldByName('OrderNumber').AsString then
          begin
            FItemList.First;
            while not FItemList.EOF do
            begin
              if (FItemList.FieldByName('OrderNumber').AsString = Fcds.FieldByName('OrderNumber').AsString) and
               (FItemList.FieldByName('PositionNumber').AsString = FPositionList.FieldByName('PositionNumber').AsString) then
              begin
                // récupération du Numéro de model
                ModelNumber := Copy(Trim(FPositionList.FieldByName('CODE').AsString),1,Length(Trim(FPositionList.FieldByName('CODE').AsString)) -3);

                // récupération de la taille
//                  if Sizes.PLXGTF.ClientDataSet.Locate('ID',FPositionList.FieldByName('SizeRange').AsString,[loCaseInsensitive]) then
//                    // positionnement des deux autres dataset
//                    if Sizes.PLXTYPEGT.ClientDataSet.Locate('ID',Sizes.PLXGTF.FieldByName('MSRID').AsString,[loCaseInsensitive]) then
//                      if Sizes.PLXTAILLESGF.ClientDataSet.Locate('SRID;Columnx',VarArrayOf([Sizes.PLXGTF.FieldByName('ID').AsString,FItemList.FieldByName('Columnx').AsString]),[loCaseInsensitive]) then
//                        TGF_ID := Sizes.GetSizes;

                {$REGION 'Positionnement'}
                bContinue := True;
                if FModelList.FieldByName('MODELNUMBER').AsString <> ModelNumber then
                  bContinue := FModelList.ClientDataSet.Locate('MODELNUMBER',ModelNumber,[loCaseInsensitive]);

                if bContinue then
                  if (FColorList.FieldByName('ModelNumber').AsString <> ModelNumber) or
                     (FColorList.FieldByName('ColorNumber').AsString <> FItemList.FieldByName('ColNo').AsString) then
                    bContinue := FColorList.ClientDataSet.Locate('ModelNumber;ColorNumber',VarArrayOf([ModelNumber,FItemList.FieldByName('ColNo').AsString]),[loCaseInsensitive]);

                if bContinue then
                  if (FColorItemList.FieldByName('ModelNumber').AsString <> ModelNumber) or
                     (FColorItemList.FieldByName('ColorNumber').AsString <> FItemList.FieldByName('ColNo').AsString) or
                     (FColorItemList.FieldByName('Columnx').AsString <> FItemList.FieldByName('Columnx').AsString) then
                  begin
                      bContinue := FColorItemList.ClientDataSet.Locate('ModelNumber;ColorNumber;Columnx',VarArrayOf([ModelNumber,FItemList.FieldByName('ColNo').AsString,FItemList.FieldByName('Columnx').AsString]),[loCaseInsensitive]);
                      TGF_ID := FColorItemList.FieldByName('TGF_ID').AsInteger;
                  end;
                {$ENDREGION}

//                if bContinue then
//                begin
                  {$REGION 'Gestion des tarifs'}
//                  case StrToIntDef(FCDs.FieldByName('ORDERTYPE').AsString,101) of
//                    101, 102 : begin // Présaison , Réassort
//                      If CompareValue(FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency, FItemList.FieldByName('PURCHASEPRICE').AsCurrency, 0.001) <> EqualsValue then
//                      begin
//                        // Y a t il un prix spécifique ?
//                        bFound := False;
//                        TarifAchat := GetTarifAchat(FModelList.FieldByName('ART_ID').AsInteger,FOU_ID,TGF_ID,FColorList.FieldByName('COU_ID').AsInteger,1);
//                        if TarifAchat.bFound then
//                        begin
//                          bFound := True;
//                          iTmpTGFID := TGF_ID;
//                          iTmpCOUID := FColorList.FieldByName('COU_ID').AsInteger;
//                        end;
//                        // récupération du tarif de base
//                        if not bfound then
//                        begin
//                          TarifAchat := GetTarifAchat(FModelList.FieldByName('ART_ID').AsInteger,FOU_ID,0,0,1);
//                          if TarifAchat.bFound then
//                          begin
//                            bFound := True;
//                            iTmpTGFID := 0;
//                            iTmpCOUID := 0;
//                          end;
//                        end;
//                        // Est ce que le tarif achat de base est différent
//                        if bFound then
//                          if CompareValue(TarifAchat.CLG_PX,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,0.001) <> EqualsValue then
//                          begin
//                            // Mise à jour du tarif négo
//                            With FIboQuery do
//                            begin
//                              Close;
//                              SQL.Clear;
//                              SQL.Add('Select * from MSS_UPDTACHATNEGO(:PARTID, :PFOUID, :PTGFID, :PCOUID, :CENTRALE, :PPXNEGO)');
//                              ParamCheck := True;
//                              ParamByName('PARTID').AsInteger := FModelList.FieldByName('ART_ID').AsInteger;
//                              ParamByName('PFOUID').AsInteger := FOU_ID;
//                              ParamByName('PTGFID').AsInteger := iTmpTGFID;
//                              ParamByName('PCOUID').AsInteger := iTmpCOUID;
//                              ParamByName('CENTRALE').AsInteger := 1;
//                              ParamByName('PPXNEGO').AsCurrency := FItemList.FieldByName('PURCHASEPRICE').AsCurrency;
//                              Open;
//
//                              if Recordcount > 0 then
//                                Inc(FMajCount,FieldByName('FMAJ').AsInteger);
//                            end;
//                          end;
//                      end;
//                    end;
//                    103:; // Opportunité
//                    104:; // Annulation
//                    105:; // fin de serie
//                  end; // case
                  {$ENDREGION}
//                end;

                {$REGION 'Récupération de la collection de la ligne'}
                CDL_COLID := COL_ID;
                if Trim(FItemList.FieldByName('COLL').AsString) <> '' then
                begin
                  if Collections.FieldByName('Code').AsString <> FItemList.FieldByName('COLL').AsString then
                  begin
                    if Collections.ClientDataSet.Locate('Code',FItemList.FieldByName('COLL').AsString,[loCaseInsensitive]) then
                    begin
                      CDL_COLID := Collections.FieldByName('COL_ID').AsInteger;
                      if CDL_COLID <= 0 then
                        CDL_COLID := Collections.GetCollectionID;
                      CollectionLib := Collections.FieldByName('Denotation').AsString
                    end;
                  end
                  else
                    CDL_COLID := Collections.FieldByName('COL_ID').AsInteger;
                end;
                {$ENDREGION}

                {$REGION 'Dans le cas d''un repassage de commande, on test divers chose pour savoir si on met à jour ou non'}
                With FCommandeLignes do
                  if (Commande.FAjout = 0) and (Commande.FMaj >= 0) then
                  begin
                    bContinue := not ClientDataSet.Locate('CDL_ARTID;CDL_TGFID;CDL_COUID;CDL_LIVRAISON',
                                     VarArrayOf([FModelList.FieldByName('ART_ID').AsInteger,
                                                 TGF_ID,
                                                 FColorList.FieldByName('COU_ID').AsInteger,
                                                 FPositionList.FieldByName('DELIVERYDATE').AsDateTime]),[]);
                    if not bContinue then
                    begin
                      bContinue := (FieldByName('CDL_QTE').AsInteger <> FItemList.FieldByName('Quantity').AsInteger) Or
                         (CompareValue(FieldByName('CDL_PXCTLG').AsCurrency,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,0.001) <> EqualsValue) Or
                         (CompareValue(FieldByName('CDL_REMISE1').AsCurrency,FPositionList.FieldByName('REBATE1').AsCurrency,0.001) <> EqualsValue) Or
                         (CompareValue(FieldByName('CDL_REMISE2').AsCurrency,FPositionList.FieldByName('REBATE2').AsCurrency,0.001) <> EqualsValue) Or
                         (CompareValue(FieldByName('CDL_PXACHAT').AsCurrency,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,0.001) <> EqualsValue) Or
                         (CompareValue(FieldByName('CDL_TVA').AsCurrency,FModelList.FieldByName('VAT').AsCurrency,0.001) <> EqualsValue) Or
                         (CompareValue(FieldByName('CDL_PXVENTE').AsCurrency,FColorItemList.FieldByName('RETAILPRICE').AsCurrency,0.001) <> EqualsValue) Or
                         (CompareValue(FieldByName('CDL_LIVRAISON').AsCurrency,FPositionList.FieldByName('DELIVERYDATE').AsDateTime,0.001) <> EqualsValue) Or
                         (FieldByName('CDL_COLID').AsInteger <> CDL_COLID);

                      ClientDataSet.Edit;
                      FieldByName('Deleted').AsInteger := 0;
                      // recalcul du RAL pour la suite
                      if FieldByName('ART_FUSARTID').AsInteger = 0 then
                        case CompareValue(FieldByName('CDL_QTE').AsInteger, FItemList.FieldByName('Quantity').AsInteger,0.001) of
                          GreaterThanValue : begin
                            FieldByName('RAL_QTE').AsInteger := FieldByName('RAL_QTE').AsInteger -
                                                               (FieldByName('CDL_QTE').AsInteger -
                                                                FItemList.FieldByName('Quantity').AsInteger);
                          end;
                          LessThanValue : begin
                            FieldByName('RAL_QTE').AsInteger := 0;
                          end;
                        end;
                      if FieldByName('ART_FUSARTID').AsInteger = 0 then
                        FieldByName('CDL_QTE').AsInteger := FItemList.FieldByName('Quantity').AsInteger;
                      ClientDataSet.Post;
                    end;
                  end;
                  {$ENDREGION}

                // Création de la ligne de commande
                if bContinue then
                begin

                  {$REGION 'Cas d''un article fusionné qui possède son fusionné dans la même commande'}
                  if not IsCreated then
                  begin
                    ArtFusion := GetFusionArt(FModelList.FieldByName('ART_ID').AsInteger,TGF_ID,FColorList.FieldByName('COU_ID').AsInteger);
//UNICOUL
                    if ArtFusion.ART_ID <> 0 then
//                    if ArtFusion.ART_ID > 0 then
                    begin
                      if FCommandeLignes.ClientDataSet.Locate('CDL_ARTID;CDL_TGFID;CDL_COUID;CDL_LIVRAISON',
                                                              VarArrayOf([ArtFusion.ART_ID,
                                                                          ArtFusion.TGF_ID,
                                                                          ArtFusion.COU_ID,
                                                                          FPositionList.FieldByName('DELIVERYDATE').AsDateTime]),[]) then
                      begin
                        FCommandeLignes.ClientDataSet.Edit;
                        FCommandeLignes.ClientDataSet.FieldByName('Updated').AsInteger := 1;
                        FCommandeLignes.ClientDataSet.Post;
                      end;

                      // Est ce que l'article lui même est il présent ?
                      if FCommandeLignes.ClientDataSet.Locate('CDL_ARTID;CDL_TGFID;CDL_COUID', VarArrayOf([FModelList.FieldByName('ART_ID').AsInteger,TGF_ID,FColorList.FieldByName('COU_ID').AsInteger]),[]) then
                      begin
                        FItemList.ClientDataSet.Edit;
                        FItemList.FieldByName('Quantity').AsInteger := FItemList.FieldByName('Quantity').AsInteger - FCommandeLignes.FieldByName('CDL_QTE').AsInteger;
                        FItemList.Post;
                      end;
                    end;
                  end;
                  {$ENDREGION}
                  if FCommandeLignes.ClientDataSet.Locate('CDL_ARTID;CDL_TGFID;CDL_COUID', VarArrayOf([FModelList.FieldByName('ART_ID').AsInteger,TGF_ID,FColorList.FieldByName('COU_ID').AsInteger]),[]) then
                    bIsFusion := (FCommandeLignes.FieldByName('Updated').AsInteger = 1)
                  else
                    bIsFusion := False;

                  // Calcul du prix net
                  CDL_PXCLG := FItemList.FieldByName('PURCHASEPRICE').AsCurrency *
                              (1 - FPositionList.FieldByName('REBATE1').AsCurrency / 100) *
                              (1 - FPositionList.FieldByName('REBATE2').AsCurrency / 100);

//                  QueryPerformanceCounter(BeginTime);
                  try
                    LigneCmd := SetCOMCDEL(Commande.CDE_ID,                              // CDL_CDEID,
                                   FModelList.FieldByName('ART_ID').AsInteger,           // CDL_ARTID,
                                   TGF_ID,                                               // CDL_TGFID,
                                   FColorList.FieldByName('COU_ID').AsInteger,           // CDL_COUID: Integer;
                                   FItemList.FieldByName('Quantity').AsInteger,          // CDL_QTE,
                                   FItemList.FieldByName('PURCHASEPRICE').AsCurrency,    // CDL_PXCTLG, // FPositionList
                                   FPositionList.FieldByName('REBATE1').AsCurrency,      // CDL_REMISE1,
                                   FPositionList.FieldByName('REBATE2').AsCurrency,      // CDL_REMISE2,
                                   CDL_PXCLG,                                            // CDL_PXACHAT,  // FColorItemList
                                   FModelList.FieldByName('VAT').AsCurrency,             // CDL_TVA,
                                   FColorItemList.FieldByName('RETAILPRICE').AsCurrency, // CDL_PXVENTE: Extended;
                                   FPositionList.FieldByName('DELIVERYDATE').AsDateTime, // CDL_LIVRAISON: TDateTime
                                   CDL_COLID,                                            // CDL_COLID : Integer
                                   (IsCreated or bIsFusion )                             // CreateMode : Boolean
                                  );
                  Except on E:Exception do
                    raise EMODELERROR.Create(Format(' - Couleur : %s - Taille : %s - Erreur %s',[FColorList.FieldByName('ColorDenotation').AsString,FItemList.FieldByName('Columnx').AsString,e.Message]));
                  end;

                  IsUpdated := IsUpdated or (LigneCmd.FMAJ > 0);
                  if FCommandeLignes.ClientDataSet.Locate('CDL_ID',LigneCmd.CDL_ID,[]) then
                  begin
                    FCommandeLignes.ClientDataSet.Edit;
                    FCommandeLignes.FieldByName('Deleted').AsInteger := 0;
//                    if LigneCmd.FMAJ > 0 then
//                      FCommandeLignes.FieldByName('Updated').AsInteger := 1;
                    FCommandeLignes.ClientDataSet.Post;
                  end;

                  // Liaison de la collection avec l'article
                  if ART_ID <>  FModelList.FieldByName('ART_ID').AsInteger then
                  begin
                    SetArtColArt(FModelList.FieldByName('ART_ID').AsInteger,CDL_COLID);
                    ART_ID := FModelList.FieldByName('ART_ID').AsInteger;
                  end;

                  // Mise de la taille en taille travaillé pour l'article
                  SetTailleTrav(FModelList.FieldByName('ART_ID').AsInteger,TGF_ID);

                  // Créaton du CB de type 1 s'il n'existe pas
                  SetARTCodeBarre(FModelList.FieldByName('ARF_ID').AsInteger,TGF_ID,FColorList.FieldByName('COU_ID').AsInteger,1,'-1');

                end;
//                FErrLogs.Add(Format('  |-> Ligne : %d | ColArt %d | TaiTrv %d',[iTmpLng, iTmp, iTmp2]));
              end; // if

              FItemList.Next;
            end; // while
          end; // if
          FPositionList.Next;
        end; //while Fpos

        {$REGION 'Suppression des lignes'}
        if (Commande.FAjout = 0) or (Commande.FMaj > 0) then
        begin
          FCommandeLignes.First;
          // Premier passage pour supprimer ce qui est sur de ne pas rester
          while not FCommandeLignes.EOF do
          begin
            if (FCommandeLignes.FieldByName('Deleted').AsInteger = 1) and not FCommandeLignes.FieldByName('Reception').AsBoolean and
               (FCommandeLignes.FieldByName('CDL_QTE').AsInteger = FCommandeLignes.FieldByName('RAL_QTE').AsInteger) then
            With FIboQuery do
            begin
              UpdateKId(FCommandeLignes.FieldByName('CDL_ID').AsInteger,1);

              Close;
              SQL.Clear;
              SQL.Add('EXECUTE PROCEDURE RECALCRAL(:PCDLID)');
              ParamCheck := True;
              ParamByName('PCDLID').AsInteger := FCommandeLignes.FieldByName('CDL_ID').AsInteger;
              ExecSQL;
              IsUpdated := True;
              FCommandeLignes.ClientDataSet.Delete;
            end  // With
            else
              FCommandeLignes.Next;
          end;
          {$ENDREGION}

        {$REGION '2em passage où l''on gère les recalculs'}
          FCommandeLignes.First;
          while not FCommandeLignes.EOF do
          begin
            if (FCommandeLignes.FieldByName('Deleted').AsInteger = 1) and
               (FCommandeLignes.FieldByName('Reception').AsBoolean) {or
               (FCommandeLignes.FieldByName('ART_FUSARTID').AsInteger <> 0)} then
            begin
              if (FCommandeLignes.FieldByName('RAL_QTE').AsInteger <> 0) or
                 (FCommandeLignes.FieldByName('deleted').AsInteger = 1){ or
                 (FCommandeLignes.FieldByName('ART_FUSARTID').AsInteger <> 0)} then
              begin
                With FIboQuery do
                begin
                  if (FCommandeLignes.FieldByName('RAL_QTE').AsInteger <> 0) and
                     ((FCommandeLignes.FieldByName('Updated').AsInteger = 1) or
                      (FCommandeLignes.FieldByName('deleted').AsInteger = 1)) then
                  begin
                    Close;
                    SQL.Clear;
                    SQL.Add('UPDATE COMBCDEL SET');
                    SQL.Add('  CDL_QTE = :PQTE');
                    SQL.Add('Where CDL_ID = :PCDLID');
                    ParamCheck := True;
                    if FCommandeLignes.FieldByName('CDL_QTE').AsInteger -
                       FCommandeLignes.FieldByName('RAL_QTE').AsInteger < 0 then
                      ParamByName('PQTE').AsInteger := 0
                    else
                      ParamByName('PQTE').AsInteger := FCommandeLignes.FieldByName('CDL_QTE').AsInteger -
                                                       FCommandeLignes.FieldByName('RAL_QTE').AsInteger;
                    ParamByName('PCDLID').AsInteger := FCommandeLignes.FieldByName('CDL_ID').AsInteger;
                    ExecSQL;

                    // Update du K
                    UpdateKId(FCommandeLignes.FieldByName('CDL_ID').AsInteger);
                  end;
                  // Mise à jour des Autres lignes de commandes
                  Close;
                  SQL.Clear;
                  SQL.Add('Select * from MSS_UPDCOMBCDEL_CALCRAL(:PCDEID, :PCDLID,:PARTID, :PTGFID, :PCOUID, :PQTE)');
                  ParamCheck := True;
                  ParamByName('PCDEID').AsInteger := Commande.CDE_ID;
                  ParamByName('PCDLID').AsInteger := FCommandeLignes.FieldByName('CDL_ID').AsInteger;
                  ParamByName('PARTID').AsInteger := FCommandeLignes.FieldByName('CDL_ARTID').AsInteger;
                  ParamByName('PTGFID').AsInteger := FCommandeLignes.FieldByName('CDL_TGFID').AsInteger;
                  ParamByName('PCOUID').AsInteger := FCommandeLignes.FieldByName('CDL_COUID').AsInteger;
                  if FCommandeLignes.FieldByName('CDL_QTE').AsInteger -
                     FCommandeLignes.FieldByName('RAL_QTE').AsInteger < 0 then
                    ParamByName('PQTE').AsInteger := 0
                  else
                    ParamByName('PQTE').AsInteger := FCommandeLignes.FieldByName('CDL_QTE').AsInteger -
                                                     FCommandeLignes.FieldByName('RAL_QTE').AsInteger;
                  Open;

                  if Recordcount > 0 then
                  begin
                    Inc(FMajCount,FieldbyName('FMAJ').AsInteger);

                    First;
//                    while not EOF do
//                    begin
//                      FErrLogs.Add(Format('%d - %s - Old : %d - New : %d',[FieldByName('IDLIGNE').AsInteger,
//                                                                           FieldByName('ART_NOM').AsString,
//                                                                           FieldByName('OLDQTE').AsInteger,
//                                                                           FieldByName('NEWQTE').AsInteger]));
//                      Next;
//                    end;

                    // s'il y a eu un mise à jour alors il faut faire aussi la maj en mémoire
                    if FieldbyName('FMAJ').AsInteger > 0 then
                    begin
                      Bookm := FCommandeLignes.ClientDataSet.GetBookmark;
                      CDL_ID := FCommandeLignes.FieldByName('CDL_ID').AsInteger;
                      ART_ID := FCommandeLignes.FieldByName('CDL_ARTID').AsInteger;
                      TGF_ID := FCommandeLignes.FieldByName('CDL_TGFID').AsInteger;
                      COU_ID := FCommandeLignes.FieldByName('CDL_COUID').AsInteger;
                      CDL_QTE := FCommandeLignes.FieldByName('CDL_QTE').AsInteger;

                      if FCommandeLignes.ClientDataSet.Locate('CDL_ARTID;CDL_TGFID;CDL_COUID',VarArrayOf([ART_ID,TGF_ID,COU_ID]),[]) then
                      begin
                        while not FCommandeLignes.EOF do
                        begin
                          if (FCommandeLignes.FieldByName('CDL_ID').AsInteger <> CDL_ID) and (CDL_QTE <> 0)
                              and (FCommandeLignes.FieldByName('deleted').AsInteger = 0) then
                          begin
                            if (FCommandeLignes.FieldByName('CDL_ARTID').AsInteger = ART_ID) and
                               (FCommandeLignes.FieldByName('CDL_TGFID').AsInteger = TGF_ID) and
                               (FCommandeLignes.FieldByName('CDL_COUID').AsInteger = COU_ID) Then
                            begin
                              FCommandeLignes.ClientDataSet.Edit;
                              case CompareValue(CDL_QTE,FCommandeLignes.FieldByName('CDL_QTE').AsInteger, 0.001) of
                                EqualsValue, LessThanValue: begin
                                  FCommandeLignes.FieldByName('CDL_QTE').AsInteger := FCommandeLignes.FieldByName('CDL_QTE').AsInteger - CDL_QTE;
                                  CDL_QTE := 0;
                                end; // less
                                GreaterThanValue: begin
                                  CDL_QTE := CDL_QTE - FCommandeLignes.FieldByName('CDL_QTE').AsInteger;
                                  FCommandeLignes.FieldByName('CDL_QTE').AsInteger := 0;
                                end; //greater
                              end;
                              FCommandeLignes.ClientDataSet.Post;
                            end;
                          end;
                          FCommandeLignes.Next;
                        end;
                      end;
                      FCommandeLignes.ClientDataSet.GotoBookmark(BookM);
                      FCommandeLignes.ClientDataSet.FreeBookmark(BookM);
                    end;

                  end;
                end; // with
              end; // if


            end; // if
            FCommandeLignes.Next;
          end; // while

        end; // if
        {$ENDREGION}
      end
      else
         FErrLogs.Add(FTitle + ' : Commande archivée');
      {$ENDREGION}

      {$REGION 'Recalcul de l''entête des lignes}
      if (Commande.FAjout = 0) then
      begin
        // Initialisation du tableau de TVA
        for i := 0 to Length(TVALignesVerif) -1 do
          With TVALignesVerif[i] do
          begin
            CDE_TVAHT := 0;
            CDE_TVATAUX := 0;
            CDE_TVA := 0;
          end;

        // Récupération des lignes de la commande
        With FIboQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select CDL_ID, CDL_QTE, CDL_PXACHAT, CDL_TVA from COMBCDEL');
          SQL.Add('  Join K on K_ID = CDL_ID and K_enabled = 1');
          SQL.Add('Where CDL_CDEID = :PCDEID');
          ParamCheck := True;
          ParamByName('PCDEID').AsInteger := Commande.CDE_ID;
          Open;

          while not EOF do
          begin

            bFound := False;
            for i := 0 to Length(TVALignesVerif) do
              if CompareValue(TVALignesVerif[i].CDE_TVATAUX,FieldByName('CDL_TVA').AsCurrency,0.01) = EqualsValue then
              begin
                bFound := True;
                iFound := i;
              end; // if

              if bFound then
              begin
                With TVALignesVerif[iFound] do
                begin
                  CDL_PXCLG :=FieldByName('CDL_PXACHAT').AsCurrency;
                  CDE_TVAHT := CDE_TVAHT + CDL_PXCLG * FieldByName('CDL_QTE').AsCurrency;
                  CDE_TVA   := CDE_TVA + (CDL_PXCLG * FieldByName('CDL_QTE').AsCurrency) * CDE_TVATAUX / 100;
                end; // with
              end else
              begin
                bFound := False;
                for i := 0 to Length(TVALignesVerif) do
                  if not bFound and (TVALignesVerif[i].CDE_TVATAUX = 0)  then
                  begin
                    With TVALignesVerif[i] do
                    begin
                      CDL_PXCLG := FieldByName('CDL_PXACHAT').AsCurrency;
                      CDE_TVATAUX := FieldByName('CDL_TVA').AsCurrency;
                      CDE_TVAHT := CDL_PXCLG * FieldByName('CDL_QTE').AsCurrency;
                      CDE_TVA   := CDE_TVAHT * CDE_TVATAUX / 100;
                      bFound := True;
                    end; // with
                  end; // if
              end; // if bfound
            Next;
          end; // while

          Commande := SetCOMBCDE(0, //  ACDE_SAISON,
                             EXE_ID, // ACDE_EXEID,
                             CPA_ID, // ACDE_CPAID,
                             FMAGID, // ACDE_MAGID,
                             FOU_ID, // ACDE_FOUID: Integer;
                             Fcds.FieldByName('ORDERNUMBER').AsString, //ACDE_NUMFOURN: String;
                             FCds.FieldByName('ORDERDATE').AsDateTime, // ACDE_DATE: TDateTime;
                             TVALignesVerif[0].CDE_TVAHT, TVALignesVerif[0].CDE_TVATAUX, TVALignesVerif[0].CDE_TVA, // ACDE_TVAHT1, ACDE_TVATAUX1, ACDE_TVA1,
                             TVALignesVerif[1].CDE_TVAHT, TVALignesVerif[1].CDE_TVATAUX, TVALignesVerif[1].CDE_TVA, // ACDE_TVAHT2, ACDE_TVATAUX2, ACDE_TVA2,
                             TVALignesVerif[2].CDE_TVAHT, TVALignesVerif[2].CDE_TVATAUX, TVALignesVerif[2].CDE_TVA, // ACDE_TVAHT3, ACDE_TVATAUX3, ACDE_TVA3,
                             TVALignesVerif[3].CDE_TVAHT, TVALignesVerif[3].CDE_TVATAUX, TVALignesVerif[3].CDE_TVA, // ACDE_TVAHT4, ACDE_TVATAUX4, ACDE_TVA4,
                             TVALignesVerif[4].CDE_TVAHT, TVALignesVerif[4].CDE_TVATAUX, TVALignesVerif[4].CDE_TVA, // ACDE_TVAHT5, ACDE_TVATAUX5, ACDE_TVA5: Extended;
                             MinDate, // ACDE_LIVRAISON: TDatetime;
                             TYP_ID, // ACDE_TYPID,
                             USR_ID, // ACDE_USRID: Integer;
                             FCds.FieldByName('ORDERDENOTATION').AsString + ' ' + FCds.FieldByName('ORDERMEMO').AsString, // ACDE_COMENT: String;
                             COL_ID, // ACDE_COLID,
                             Abs(DaysBetween(FPositionList.FieldByName('DELIVERYLATEST').AsDateTime,FPositionList.FieldByName('DELIVERYEARLY').AsDateTime)) // ACDE_OFFSET : Integer
                             );


        end;
      end;
      {$ENDREGION}

      {$REGION 'Vérification et création des codes barres des tailles/couleurs manquante de type 1'}
      FModelList.First;
      while not FModelList.EOF do
      begin
        With FIboQuery do
        begin
          // récupération des tailles travaillé du modèle
          Close;
          SQL.Clear;
          SQL.Add('Select TTV_TGFID from PLXTAILLESTRAV');
          SQL.Add('  Join K on K_ID = TTV_ID and K_Enabled = 1');
          SQL.Add('Where TTV_ARTID = :PARTID');
          ParamCheck := True;
          ParamByName('PARTID').AsInteger := FModelList.FieldByName('ART_ID').AsInteger;
          Open;

          FTAILLETRAV.ClientDataSet.EmptyDataSet;
          if RecordCount > 0 then
          begin
            while not EOF do
            begin
              FTAILLETRAV.Append;
              FTAILLETRAV.FieldByName('TTV_TGFID').AsInteger := FieldByName('TTV_TGFID').AsInteger;
              FTAILLETRAV.Post;
              Next;
            end;
          end;

          // Récupéation des couleurs du modèle
          Close;
          SQL.Clear;
          SQL.Add('Select COU_ID FROM PLXCOULEUR');
          SQL.Add('  Join K on K_ID = COU_ID and K_Enabled = 1');
          SQL.Add('Where COU_ARTID = :PARTID');
          ParamCheck := True;
          ParamByName('PARTID').AsInteger := FModelList.FieldByName('ART_ID').AsInteger;
          Open;

          FCOULEUR.ClientDataSet.EmptyDataSet;
          while not EOF do
          begin
            FCOULEUR.Append;
            FCOULEUR.FieldByName('COU_ID').AsInteger := FieldByName('COU_ID').AsInteger;
            FCOULEUR.Post;
            Next;
          end;

          FCOULEUR.First;
          while not FCOULEUR.EOF do
          begin
            FTAILLETRAV.First;
            while not FTAILLETRAV.EOF do
            begin
              CBI_ID := SetARTCodeBarre(FModelList.FieldByName('ARF_ID').AsInteger,FTAILLETRAV.FieldByName('TTV_TGFID').AsInteger,FCOULEUR.FieldByName('COU_ID').AsInteger,1,'-1');
  //                      FErrLogs.Add(Format('Chrono %s - CBI_ID : %d - TGF_ID : %d - COU_ID : %d',[Article.Chrono, CBI_ID,FTAILLETRAV.FieldByName('TTV_TGFID').AsInteger,FCOULEUR.FieldByName('COU_ID').AsInteger]));
              FTAILLETRAV.Next;
            end;
            FCOULEUR.Next;
          end;
        end;
        FModelList.Next;
      end;
      {$ENDREGION}

      FCds.Next;
    end; // while

    {$REGION 'Recalcul des ral différés'}
    With FIboQuery do
    begin
      Close;
      SQL.Text := 'execute procedure EAI_TRIGGER_PRETRAITE;';
      ExecSQL;

      iCount := 1;
      while iCount <> 0 do
      begin
        if not IB_Transaction.Started then
          IB_Transaction.StartTransaction;
        SQL.Text := 'select retour from EAI_TRIGGER_DIFFERE(500);';
        ParamCheck := true;
        Open;
        iCount := FIboQuery.FieldByName('retour').AsInteger;
        IB_Transaction.CommitRetaining;
      end;
      Close;
    end;
    {$ENDREGION}
  Except
    on E:EMODELERROR do
    begin
      FErrLogs.Add(FTitle + ' :' + ' - Modèle : ' + FModelList.FieldbyName('MODELNUMBER').asstring +
                                                    FModelList.FieldByName('BRANDNUMBER').AsString + ' - ' + E.Message);
      IsOnError := True;
    end;
    on E:Exception do
    begin
      FErrLogs.Add(FTitle + ' : ' + E.Message);
      IsOnError := True;
    end;
  end;

  // Génération pour le mail
  if IsCreated or IsUpdated or IsOnError then
  begin
    if FCDs.Eof then
      FCds.First;

    if IsOnError then
      sError := 'ERROR'
    else
      sError := '';

    FNewCmdList.Add('<tr>');
    FNewCmdList.Add(Format('<td class="NUMIF-LG%s">%s</td>',[sError,Fcds.FieldByName('ORDERNUMBER').AsString]));
    FNewCmdList.Add(Format('<td class="CHRONO-LG%s">%s</td>',[sError,Commande.Chrono]));

    if Assigned(TVALignes) and (High(TVALignes) > 0) then
      FNewCmdList.Add(Format('<td class="AMOUNT-LG%s">%8.2f</td>',[sError,(TVALignes[0].CDE_TVAHT + TVALignes[1].CDE_TVAHT + TVALignes[2].CDE_TVAHT + TVALignes[3].CDE_TVAHT + TVALignes[4].CDE_TVAHT)]));
    // Repositionnement pour le fournisseur
//    if Suppliers.ClientDataSet.Locate('CodeFourn;ErpNo',VarArrayOf([Fcds.FieldByName('SUPPLIERKEY').asString,FCds.FieldByName('ErpNo').AsString]),[loCaseInsensitive]) then
      FNewCmdList.Add(Format('<td class="SUPPLIER-LG%s">%s</td>',[sError,FSupplierName]));
//    else
//      FNewCmdList.Add(Format('<td class="SUPPLIER-LG%s">%s</td>',[sError,HTMLEncode('')]));

    FNewCmdList.Add(Format('<td class="EXERCICE-LG%s">%s</td>',[sError,HTMLEncode(PeriodsLib)]));
    FNewCmdList.Add(Format('<td class="COLLECTION-LG%s">%s</td>',[sError,HTMLEncode(CollectionLib)]));
    if IsCreated then
      FNewCmdList.Add(Format('<td class="ETAT-LG%s">%s</td>',[sError,'Création']))
    else
      if IsUpdated then
        FNewCmdList.Add(Format('<td class="ETAT-LG%s">%s</td>',[sError,'Mise à jour']))
      else
        FNewCmdList.Add(Format('<td class="ETAT-LG%s">%s</td>',[sError,'Erreur']));
    FNewCmdList.Add('</tr>');
  end;


  Suppliers := nil;
  Brands := nil;
  Univers := nil;
  Sizes := nil;
  Periods := nil;
  Collections := nil;
  Fedas := nil;
end;

function TCommandeClass.DoTarifAchat(AArticle : TArtArticle; AFOU_ID, ATGF_ID, ACOU_ID: Integer;
 var ATarifBase : Currency; AIsFirstTime : Boolean): Boolean;
var
  bContinue, bDoMajAchat : Boolean;
  iPRINCIPAL, CLG_ID : Integer;
  CompareTarif : Currency;
begin
  Result := False;
  try
    // Cas du premier tarif d'achat de la liste
    bContinue := True;
    if AIsFirstTime then
    begin
      if AArticle.FAjout > 0 then
      begin
        // Création du tarif de base
        iPRINCIPAL := SetArtPrixAchat_Base(
                              AArticle.ART_ID,                                             // CLG_ARTID
                              AFOU_ID,                                                     // CLG_FOUID : Integer;
                              FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PX,
                              FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PXNEGO,
                              FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency, // CLG_PXVI,
                              0,                                                          // CLG_RA1,
                              0,                                                          // CLG_RA2,
                              0,                                                          // CLG_RA3,
                              0,                                                          // CLG_TAXE: Single;
                              1                                                           // CLG_CENTRALE : Integer
                            );
        // En création on ne passe pas à la suite et on stocke le tarif en memoire
        FTARCLGFOUNR.Append;
        FTARCLGFOUNR.FieldByName('CLG_ID').AsInteger := 0;
        FTARCLGFOUNR.FieldByName('CLG_FOUID').AsInteger := AFOU_ID;
        FTARCLGFOUNR.FieldByName('CLG_TGFID').AsInteger := 0;
        FTARCLGFOUNR.FieldByName('CLG_COUID').AsInteger := 0;
        FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency := FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency;
        FTARCLGFOUNR.FieldByName('CLG_PRINCIPAL').AsInteger := iPRINCIPAL;
        FTARCLGFOUNR.Post;

        bContinue := False;
      end
      else begin
        // Si on est en modification , on recherche le tarif en mémoire et on le met à jour si nécessaire
        if FTARCLGFOUNR.ClientDataSet.Locate('CLG_FOUID;CLG_TGFID;CLG_COUID',VarArrayOf([AFOU_ID,0,0]),[]) Then
        begin
          if CompareValue(FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,0.001) <> EqualsValue then
          begin
            // On met le tarif à jour dans la base de données
            iPrincipal:= SetArtPrixAchat_Base(
                                  AArticle.ART_ID,                                            // CLG_ARTID
                                  AFOU_ID,                                                    // CLG_FOUID : Integer;
                                  FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PX,
                                  FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PXNEGO,
                                  FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency, // CLG_PXVI,
                                  0,                                                          // CLG_RA1,
                                  0,                                                          // CLG_RA2,
                                  0,                                                          // CLG_RA3,
                                  0,                                                          // CLG_TAXE: Single;
                                  1                                                           // CLG_CENTRALE : Integer
                                );

            FTARCLGFOUNR.ClientDataSet.Edit;
            FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency := FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency;
            FTARCLGFOUNR.Post;
            ATarifBase := FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency;
          end;
        end;
      end;
    end;

    if bContinue then
    begin
      bDoMajAchat := True;
      // Positionnement sur le tarif de base
      if not FTARCLGFOUNR.ClientDataSet.Locate('CLG_FOUID;CLG_TGFID;CLG_COUID',VarArrayOf([AFOU_ID,0,0]),[]) then
      begin
        // Il n'y a pas de tarif de base alors on va le créer
//        raise Exception.Create(FModelList.FieldByName('MODELNUMBER').AsString + FModelList.FieldByName('BRANDNUMBER').AsString + ' - Le modèle n''a pas de tarif d''achat de base');
        iPRINCIPAL := SetArtPrixAchat_Base(
                              AArticle.ART_ID,                                             // CLG_ARTID
                              AFOU_ID,                                                     // CLG_FOUID : Integer;
                              FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PX,
                              FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PXNEGO,
                              FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency, // CLG_PXVI,
                              0,                                                          // CLG_RA1,
                              0,                                                          // CLG_RA2,
                              0,                                                          // CLG_RA3,
                              0,                                                          // CLG_TAXE: Single;
                              1                                                           // CLG_CENTRALE : Integer
                            );
        // En création on ne passe pas à la suite et on stocke le tarif en memoire
        FTARCLGFOUNR.Append;
        FTARCLGFOUNR.FieldByName('CLG_ID').AsInteger := 0;
        FTARCLGFOUNR.FieldByName('CLG_FOUID').AsInteger := AFOU_ID;
        FTARCLGFOUNR.FieldByName('CLG_TGFID').AsInteger := 0;
        FTARCLGFOUNR.FieldByName('CLG_COUID').AsInteger := 0;
        FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency := FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency;
        FTARCLGFOUNR.FieldByName('CLG_PRINCIPAL').AsInteger := iPRINCIPAL;
        FTARCLGFOUNR.Post;

        bDoMajAchat := False;

      end;
      // On récupère l'information pour savoir si le tarif de base est principal ou non
      iPRINCIPAL := FTARCLGFOUNR.FieldByName('CLG_PRINCIPAL').AsInteger;

      if AArticle.FAjout > 0 then
      begin
        // --------
        // Création
        // --------
        // Est ce que le tarif en cours est différent du tarif de base ?
        if CompareValue(ATarifBase,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,0.001) <> EqualsValue then
        begin
          // Oui, est ce qu'il y a un tarif spécifique pour cet article ?
          if FTARCLGFOUNR.ClientDataSet.Locate('CLG_FOUID;CLG_TGFID;CLG_COUID',VarArrayOf([AFOU_ID,ATGF_ID,ACOU_ID]),[]) then
          begin
            // Oui, est ce que le tarif en cours et <> du tarif spécifique
           if CompareValue(FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,0.001) <> EqualsValue then
           begin
             // Oui, et on le met à jour
            CLG_ID := UpdArtPrixAchat(AArticle.ART_ID,AFOU_ID,ATGF_ID,ACOU_ID,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,0,0,0,0,iPRINCIPAL,1);
            // et on met à jour la table en mémoire
            FTARCLGFOUNR.ClientDataSet.Edit;
            FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency := FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency;
            FTARCLGFOUNR.Post;
           end;
          end
          else begin
            // Non, alors on créé le tarif spécifique
            CLG_ID := SetArtPrixAchat(AArticle.ART_ID,AFOU_ID,ATGF_ID,ACOU_ID,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,0,0,0,0,iPRINCIPAL,1);
            // et on l'ajoute à la table en mémoire
            FTARCLGFOUNR.Append;
            FTARCLGFOUNR.FieldByName('CLG_ID').AsInteger := CLG_ID;
            FTARCLGFOUNR.FieldByName('CLG_FOUID').AsInteger := AFOU_ID;
            FTARCLGFOUNR.FieldByName('CLG_TGFID').AsInteger := ATGF_ID;
            FTARCLGFOUNR.FieldByName('CLG_COUID').AsInteger := ACOU_ID;
            FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency := FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency;
            FTARCLGFOUNR.Post;
          end;
        end;
        bDoMajAchat := False;
      end;

      if bDoMajAchat then
      begin
        // Y a-t-il un tarif spécifique ?
        if FTARCLGFOUNR.ClientDataSet.Locate('CLG_FOUID;CLG_TGFID;CLG_COUID',VarArrayOf([AFOU_ID,ATGF_ID,ACOU_ID]),[]) then
        begin
          if AIsFirstTime then
            CompareTarif := ATarifBase
          else
            CompareTarif := FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency;
          // Est ce que le tarif spécifique est différent du tarif de base/en cours?
          if CompareValue(FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency, CompareTarif,0.001) <> EqualsValue then
          begin
            // Oui, alors on va mettre à jour avec le tarif de base
            CLG_ID := UpdArtPrixAchat(AArticle.ART_ID,AFOU_ID,ATGF_ID,ACOU_ID,CompareTarif,CompareTarif,FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,0,0,0,0,iPRINCIPAL,1);
            // et on met à jour la table en mémoire
            FTARCLGFOUNR.ClientDataSet.Edit;
            FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency := CompareTarif;
            FTARCLGFOUNR.Post;
          end;
        end
        else begin
          // est on lors du premier passage ?
          if not AIsFirstTime then
            // est ce que le tarif en cours est différent du tarif de base ?
            if CompareValue(ATarifBase, FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,0.001) <> EqualsValue then
              // Oui, alors on créé le tarif spécifique
              CLG_ID := SetArtPrixAchat(AArticle.ART_ID,AFOU_ID,ATGF_ID,ACOU_ID,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,0,0,0,0,iPRINCIPAL,1);
        end;
      end;
    end;
    Result := True;
  Except on E:Exception do
    raise Exception.Create('DoTarifAchat -> ' + E.Message);
  end;
end;

function TCommandeClass.DoTarifVente(AArticle: TArtArticle; ATGF_ID, ACOU_ID, ATPO_ID : Integer; ATPO_DT : TDate): Boolean;
var
  bContinue : Boolean;
  cPrixBase, cPrixBaseActuel : Currency;
  LocalTVT_ID, TVD_ID : Integer;

  idtmp1, idtmp2 : Integer;
  cRecommandedSalesPrice : Currency;
const
  zerovalue = 0;
begin
  try
    cRecommandedSalesPrice := FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency;
    idtmp1 := 0;
    idtmp2 := 0;
    // Etat de l'article
    if AArticle.FAjout > 0 then
    begin
      // Création
      // Y a il déjà un tarif de base ?
      if not FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;PVT_TVTID',VarArrayOf([0,0,0]),[]) then
      begin
        // Non alors on en crée un
        SetArtPrixVente(AArticle.ART_ID,0,0,0,cRecommandedSalesPrice,1);
        // Mise à jour du CDS en mémoire
        FTARPRIXVENTE.Append;
        FTARPRIXVENTE.FieldByName('PVT_TVTID').AsInteger := 0;
        FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := 0;
        FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := 0;
        FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := cRecommandedSalesPrice;
        FTARPRIXVENTE.Post;
      end;

      // Est ce que le tarif en cours <> du tarif de base ?
      if CompareValue(cRecommandedSalesPrice,FColorItemList.FieldByName('RETAILPRICE').AsCurrency) <> EqualsValue then
      begin
        // Oui alors on crée un tarif spécifique
        SetArtPrixVente(AArticle.ART_ID,ATGF_ID, ACOU_ID,0,FColorItemList.FieldByName('RETAILPRICE').AsCurrency,1);

        // Ajout au CSD
        FTARPRIXVENTE.Append;
        FTARPRIXVENTE.FieldByName('PVT_TVTID').AsInteger := 0;
        FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := ATGF_ID;
        FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := ACOU_ID;
        FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := FColorItemList.FieldByName('RETAILPRICE').AsCurrency;
        FTARPRIXVENTE.Post;
      end;
    end
    else begin
      // Modification
      // Est ce que le tarif en cours <> du tarif de base ?
      if CompareValue(cRecommandedSalesPrice,FColorItemList.FieldByName('RETAILPRICE').AsCurrency) <> EqualsValue then
      begin
        // Oui, y a-t-il un tarif spécifique existant en base ?
        if not FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;PVT_TVTID',VarArrayOf([ATGF_ID,ACOU_ID,0]),[]) then
        begin
          // Non, récupération du tarif de base de l'article
          if FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;PVT_TVTID',VarArrayOf([0,0,0]),[]) then
          begin
            // Création du tarif spécifique
            SetArtPrixVente(AArticle.ART_ID,ATGF_ID,ACOU_ID,0,FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency,1);
            cPrixBase := FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency;
            // Mise à jour du CDS en mémoire
            FTARPRIXVENTE.Append;
            FTARPRIXVENTE.FieldByName('PVT_TVTID').AsInteger := 0;
            FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := ATGF_ID;
            FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := ACOU_ID;
            FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := cPrixBase;
            FTARPRIXVENTE.Post;
          end
          else begin
            raise Exception.Create(FModelList.FieldByName('MODELNUMBER').AsString + FModelList.FieldByName('BRANDNUMBER').AsString + ' - Le modèle n''a pas de prix de vente de base');
          end;
        end;
      end;
    end;


  {  // récupération du tarif recommandé à date comme prix de base
    cPrixBase := FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency;

    if AArticle.FAjout > 0 then
    begin
      // Création
      // Y a il déjà un tarif de base ?
      if not FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;PVT_TVTID',VarArrayOf([0,0,0]),[]) then
      begin
        // Non alors on en crée un
        SetArtPrixVente(AArticle.ART_ID,0,0,0,cPrixBase,1);
        // Mise à jour du CDS en mémoire
        FTARPRIXVENTE.Append;
        FTARPRIXVENTE.FieldByName('PVT_TVTID').AsInteger := 0;
        FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := 0;
        FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := 0;
        FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := cPrixBase;
        FTARPRIXVENTE.Post;
      end;

      // Est ce que le tarif en cours <> du tarif de base ?
      if CompareValue(cPrixBase,FColorItemList.FieldByName('RETAILPRICE').AsCurrency) <> EqualsValue then
      begin
        // Oui alors on crée un tarif spécifique
        SetArtPrixVente(AArticle.ART_ID,ATGF_ID, ACOU_ID,0,FColorItemList.FieldByName('RETAILPRICE').AsCurrency,1);

        // Ajout au CSD
        FTARPRIXVENTE.Append;
        FTARPRIXVENTE.FieldByName('PVT_TVTID').AsInteger := 0;
        FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := ATGF_ID;
        FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := ACOU_ID;
        FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := FColorItemList.FieldByName('RETAILPRICE').AsCurrency;
        FTARPRIXVENTE.Post;
      end;
    end
    else begin
      // Mise à jour
      // y a-t-il un tarif de base pour le tarif magasin ?
      if not FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;PVT_TVTID',VarArrayOf([0,0, TVT_ID]),[]) then
        // Non, y a-t-il un tarif de base pour le tarif général ?
        if not FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;PVT_TVTID',VarArrayOf([0,0,0]),[]) then
          raise Exception.Create(FModelList.FieldByName('MODELNUMBER').AsString + FModelList.FieldByName('BRANDNUMBER').AsString + ' - Le modèle n''a pas de prix de vente de base');
      cPrixBaseActuel := FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency;
      LocalTVT_ID     := FTARPRIXVENTE.FieldByName('PVT_TVTID').AsInteger;

      // Est ce que le tarif en cours <> du tarif de base ?
      if CompareValue(cPrixBase,FColorItemList.FieldByName('RETAILPRICE').AsCurrency) <> EqualsValue then
      begin
        // Oui, est ce qu'il y a un tarif spécifique existant pour le tarif magasin ?
        if not FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;PVT_TVTID',VarArrayOf([ATGF_ID,ACOU_ID,TVT_ID]),[]) then
        begin
          // non, est ce qu'il y a un tarif de base pour le tarif magasin ?
          if not TVT_ID = LocalTVT_ID then
          begin
            // non, est ce qu'il y a un tarif spécifique existant pour le tarif général ?
            if not FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID;',VarArrayOf([ATGF_ID,ACOU_ID,0]),[]) then
            begin
              // Si non, création du tarif avec le tarif de base actuel
              SetArtPrixVente(AArticle.ART_ID,ATGF_ID, ACOU_ID,0, cPrixBaseActuel,1);

              // Ajout au CSD
              FTARPRIXVENTE.Append;
              FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := ATGF_ID;
              FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := ACOU_ID;
              FTARPRIXVENTE.FieldByName('PVT_TVTID').AsInteger := 0;
              FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := cPrixBaseActuel;
              FTARPRIXVENTE.Post;
            end;
          end
          else begin
              // Si Oui, création du tarif spécifique pour le tarif magasin avec le tarif de base actuel
              SetArtPrixVente(AArticle.ART_ID,ATGF_ID, ACOU_ID, TVT_ID, cPrixBaseActuel,1);

              // Ajout au CSD
              FTARPRIXVENTE.Append;
              FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := ATGF_ID;
              FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := ACOU_ID;
              FTARPRIXVENTE.FieldByName('PVT_TVTID').AsInteger := TVT_ID;
              FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := cPrixBaseActuel;
              FTARPRIXVENTE.Post;
          end;
        end;

        // Y a-t-il un tarif Preco spécifique pour cette taille couleur ?
        if ATPO_ID <> 0 then
        begin
          if FTARVALID.ClientDataSet.Locate('TVD_TGFID;TVD_COUID;TVD_TVTID',VarArrayOf([ATGF_ID,ACOU_ID,TVT_ID]),[]) then
          begin
            // Mise à jour
            if CompareValue(FTARVALID.fieldByName('TVD_PX').AsCurrency,FColorItemList.FieldByName('RETAILPRICE').AsCurrency,0.001) <> EqualsValue then
              UpdTarValid(
                           FTARVALID.FieldByName('TVD_ID').AsInteger,           //  ATVD_ID: Integer;
                           ATPO_DT,                                             //  ATVD_DT: TDate;
                           FColorItemList.FieldByName('RETAILPRICE').AsCurrency //  ATVD_PX: Currency
                         );
          end
          else begin
            // y a-t-il un tarif de base pour le tarif magasin ?
            if FTARVALID.ClientDataSet.Locate('TVD_TGFID;TVD_COUID;TVD_TVTID',VarArrayOf([0,0,TVT_ID]),[]) then
            begin
              // Mise à jour
              UpdTarValid(
                           FTARVALID.FieldByName('TVD_ID').AsInteger,           //  ATVD_ID: Integer;
                           ATPO_DT,                                             //  ATVD_DT: TDate;
                           FColorItemList.FieldByName('RETAILPRICE').AsCurrency //  ATVD_PX: Currency
                         );

              FTARVALID.ClientDataSet.Edit;
              FTARVALID.FieldByName('TVD_ID').AsInteger := TVD_ID;
              FTARVALID.FieldByName('TVD_DT').AsDateTime := ATPO_DT;
              FTARVALID.FieldByName('TVD_PX').AsCurrency := FColorItemList.FieldByName('RETAILPRICE').AsCurrency;
              FTARVALID.Post;

            end
            else begin
              // Création
              TVD_ID := SetTarValid(
                           ATPO_ID,                                              // ATVD_TPOID,
                           TVT_ID,                                           // ATVD_TVTID,
                           AArticle.ART_ID,                                      // ATVD_ARTID,
                           ATGF_ID,                                           // ATVD_TGFID,
                           ACOU_ID,                                           // ATVD_COUID : Integer;
                           FColorItemList.FieldByName('RETAILPRICE').AsCurrency, // ATVD_PX : Currency;
                           ATPO_DT,                                              // ATVD_DT : TDate;
                           0                                                     // ATVD_ETAT : Integer
                         );

              FTARVALID.Append;
              FTARVALID.FieldByName('TVD_ID').AsInteger := TVD_ID;
              FTARVALID.FieldByName('TVD_TVTID').AsInteger := TVT_ID;
              FTARVALID.FieldByName('TVD_COUID').AsInteger := ACOU_ID;
              FTARVALID.FieldByName('TVD_TGFID').AsInteger := ATGF_ID;
              FTARVALID.FieldByName('TVD_DT').AsDateTime := ATPO_DT;
              FTARVALID.FieldByName('TVD_PX').AsCurrency := FColorItemList.FieldByName('RETAILPRICE').AsCurrency;
              FTARVALID.FieldByName('TVD_ETAT').AsInteger := 0;
              FTARVALID.Post;
            end;
          end; // if
        end; // if tpo_id <> 0
      end; // if
    end; // if   }
  Except on E:Exception do
    raise Exception.Create('DoTarifVente -> ' + E.Message);
  end;
end;

function TCommandeClass.GetCPAID(AFOU_ID, AMAG_ID: Integer): Integer;
begin
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select FOD_CPAID from ARTFOURNDETAIL');
    SQL.Add('  join ARTFOURN on FOU_ID = FOD_FOUID');
    SQL.Add('  join K on K_ID = FOD_ID and K_Enabled = 1');
    SQL.Add('Where FOU_ID = :PFOUID');
    SQL.Add('  and FOD_MAGID = :PMAGID');
    ParamCheck := True;
    ParamByName('PFOUID').AsInteger := AFOU_ID;
    ParamByName('PMAGID').AsInteger := AMAG_ID;
    Open;
    if Recordcount > 0 then
      Result := FieldbyName('FOD_CPAID').AsInteger
    else
      Result := 0;
  end;
end;

function TCommandeClass.GetFournId(Suppliers: TSuppliers; AERPCODE,
  ACODE: String): Integer;
var
  iPass : Integer;
  bFindMode, bDoFindSupplierTbTmp, bFoundFOUID : Boolean;
  sLocateSupplierField, sLocateTbTmpField, sLocateValue : String;

  Begintime, endtime,TickPerSec : int64;
  iTmp, iTmp2, iTmp3 : Int64;

begin
  bFoundFOUID := False;
  while not bFoundFOUID do
  begin
    case iPass of
      0: begin // ERP
        bFindMode := Trim(AERPCODE) <> '';
        sLocateSupplierField := 'ErpNo';
        sLocateTbTmpField    := 'FOU_ERPNO';
        sLocateValue         := AERPCODE;
        Suppliers.ClientDataSet.IndexName := 'IdxERP';
      end;
      1: begin // Code
        bFindMode := True;
        sLocateSupplierField := 'CodeFourn';
        sLocateTbTmpField    := 'FOU_CODE';
        if trim(ACODE) <> '' then
          sLocateValue       := ACODE
        else
          raise Exception.Create('Fournisseur : Pas d''information');
        Suppliers.ClientDataSet.IndexName := 'IdxCODE';
      end;
      else begin
        raise Exception.Create(Format('Fournisseur non trouvé: ERP %s / ASK %s / SK %s',[FCatalogList.FieldByName('AddSupplierERP').AsString,FCatalogList.FieldByName('AddSupplierKey').AsString, FCatalogList.FieldByName('SupplierKey').AsString]));
      end;
    end; //case

    if bFindMode then
    begin
      bDoFindSupplierTbTmp := False;
      QueryPerformanceCounter(BeginTime);
      iTmp  := -1;
      iTmp2 := -1;
      iTmp3 := -1;
      if Suppliers.IsUpdated then
      begin
        if Suppliers.ClientDataSet.Locate(sLocateSupplierField,sLocateValue,[]) then
        begin
//          QueryPerformanceCounter(EndTime);
//          QueryPerformanceFrequency(TickPerSec);
//          iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
          Result := Suppliers.FieldByName('FOU_ID').AsInteger;
          FSupplierName := Suppliers.FieldByName('Denotation').AsString;
          if Result <= 0 then
            bDoFindSupplierTbTmp := True
          else
            bFoundFOUID := True;
        end
        else
          bDoFindSupplierTbTmp := True;
      end
      else
        bDoFindSupplierTbTmp := True;

      if bDoFindSupplierTbTmp then
      begin
        if FournTable.Locate(sLocateTbTmpField,sLocateValue,[]) then
        begin
          Result := FournTable.FieldByName('FOU_ID').AsInteger;
          FSupplierName := FournTable.FieldByName('FOU_NOM').AsString;
          bFoundFOUID := True;
//          QueryPerformanceCounter(EndTime);
//          QueryPerformanceFrequency(TickPerSec);
//          iTmp2 := Round((EndTime - BeginTime) / TickPerSec * 1000);
        end
        else begin
          Result := Suppliers.GetSuppliers(sLocateSupplierField,sLocateValue);
          FSupplierName := Suppliers.FieldByName('Denotation').AsString;
          bFoundFOUID := True;
//          QueryPerformanceCounter(EndTime);
//          QueryPerformanceFrequency(TickPerSec);
//          iTmp3 := Round((EndTime - BeginTime) / TickPerSec * 1000);
        end;
      end;
    end;
//    FErrLogs.Add(Format('Fourn : Int %d, Qry %d, Base %d',[iTmp,iTmp2,iTmp3]));
    Inc(iPass);
  end;
end;

function TCommandeClass.GetMaxDelivery: TDateTime;
begin
  FPositionList.First;
  Result := MinDateTime;
  while not FPositionList.EOF do
  begin
    if CompareDateTime(FPositionList.FieldByName('DELIVERYDATE').AsDateTime,Result) = GreaterThanValue then
      Result := FPositionList.FieldByName('DELIVERYDATE').AsDateTime;
    FPositionList.Next;
  end;
end;

function TCommandeClass.GetMinDelivery: TDateTime;
begin
  FPositionList.First;
  Result := MaxDateTime;
  while not FPositionList.EOF do
  begin
    if CompareDateTime(FPositionList.FieldByName('DELIVERYDATE').AsDateTime,Result) = LessThanValue then
      Result := FPositionList.FieldByName('DELIVERYDATE').AsDateTime;
    FPositionList.Next;
  end;
end;

function TCommandeClass.GetOrderDate: TDateTime;
begin
  FCds.First;
  Result := MaxDateTime;
  while not FCds.EOF do
  begin
    if CompareDateTime(FCds.FieldByName('ORDERDATE').AsDateTime,Result) = LessThanValue then
      Result := FCds.FieldByName('ORDERDATE').AsDateTime;
    FCds.Next;
  end;
end;

function TCommandeClass.GetNewCB: String;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Text := 'Select NEWNUM from ART_CB;';
    Open;
    Result := FieldByName('NEWNUM').AsString;

  except on E:Exception do
    raise Exception.Create('GetNewCB -> ' + E.Message);
  end;
end;

function TCommandeClass.GetTarifAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID,
  CLG_COUID, CLG_CENTRALE: Integer): TTarifAchat;
begin
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select CLG_PX, CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3, CLG_TAXE, CLG_PRINCIPAL, CLG_CENTRALE from TARCLGFOURN');
    SQL.Add('  join K on K_ID = CLG_ID and K_Enabled = 1');
    SQL.Add('Where CLG_ARTID = :PARTID');
    SQL.Add('  and CLG_FOUID = :PFOUID');
    SQL.Add('  and CLG_TGFID = :PTGFID and CLG_COUID = :PCOUID');
    if CLG_CENTRALE <> -1 then
      SQL.Add('  and CLG_CENTRALE = :PCLGCENTRALE');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := CLG_ARTID;
    ParamByName('PFOUID').AsInteger := CLG_FOUID;
    ParamByName('PTGFID').AsInteger := CLG_TGFID;
    ParamByName('PCOUID').AsInteger := CLG_COUID;
    if CLG_CENTRALE <> -1 then
      ParamByName('PCLGCENTRALE').AsInteger := CLG_CENTRALE;
    Open;

    Result.bFound := False;
    if RecordCount > 0 then
    begin
      Result.bFound        := True;
      Result.CLG_PX        := FieldByName('CLG_PX').AsCurrency;
      Result.CLG_PXNEGO    := FieldByName('CLG_PXNEGO').AsCurrency;
      Result.CLG_PXVI      := FieldByName('CLG_PXVI').AsCurrency;
      Result.CLG_RA1       := FieldByName('CLG_RA1').AsCurrency;
      Result.CLG_RA2       := FieldByName('CLG_RA2').AsCurrency;
      Result.CLG_RA3       := FieldByName('CLG_RA3').AsCurrency;
      Result.CLG_TAXE      := FieldByName('CLG_TAXE').AsCurrency;
      Result.CLG_PRINCIPAL := FieldByName('CLG_PRINCIPAL').AsInteger;
      Result.CLG_CENTRALE  := FieldByName('CLG_CENTRALE').AsInteger;
    end;
  end;

end;

function TCommandeClass.GetTVAId(TVA_TAUX: single; TVA_CODE: String): integer;
var
 bFound : Boolean;
begin
  try
    if not TVATable.Active then
      TVATable.Open;

    With TVATable do
    begin
      First;
      bFound := False;
      while (not EOF) and not bFound do
      begin
        if CompareValue(FieldByName('TVA_TAUX').AsCurrency,TVA_TAUX,0.001) = EqualsValue then
          bfound := True
        else
          Next;
      end;

      if not bFound then
        raise Exception.Create(Format('TVA non trouvée : %f',[TVA_TAUX]));

      Result := FieldByName('TVA_ID').AsInteger;
    end;

//    if TVATable.Locate('TVA_TAUX',TVA_TAUX,[]) then
//      Result := FieldByName('TVA_ID').AsInteger
//    else
//      raise Exception.Create(Format('TVA non trouvée : %f',[TVA_TAUX]));

//
//    With FIboQuery do
//    begin
//      Close;
//      SQL.Clear;
//      SQL.Add('select TVA_ID from ARTTVA');
//      SQL.Add('  join k on k_id = TVA_ID and k_enabled = 1');
//      SQL.Add('Where TVA_TAUX = :PTVATAUX');
//      if Trim(TVA_CODE) <> '' then
//        SQL.Add('and TVA_CODE = :PTVACODE');
//      ParamCheck := True;
//      ParamByName('PTVATAUX').AsString  := FormatFloat('0.00',TVA_TAUX);
//      if Trim(TVA_CODE) <> '' then
//        ParamByName('PTVACODE').AsString := TVA_CODE;
//      Open;
//

//    end;
  except on E:Exception do
    raise Exception.Create('GetTvaId -> ' + E.Message);
  end;

end;

procedure TCommandeClass.Import;
var
  Xml : IXMLDocument;
  nXmlBase,
  // Fichier ORD
  eOrderListNode,
  eOrderNode,
  eOrderHeaderAddNode,
  eOrderAddNode,
  eOrderHeaderNode,
  ePositionListNode,
  ePositionNode,
  eItemListNode,
  eItemNode,
  eItemItemAddNode,
  eItemAddNode : IXMLNode;

  // Fichier SD
  eCatalogListNode,
  eCatalogNode,
  eCatalogAddNode,
  eCatalogAdditionalNode,
  eModelListNode,
  eModelMode,
  eModelModelAddNode,
  eModelAdditionalNode,
  eColorListNode,
  eColorNode,
  eColorAddNode,
  eColorAdditionalNode : IXMLNode;

  bValid : Boolean;
  i : Integer;

begin
  // geston du Xml Order
  try
    Xml := TXMLDocument.Create(nil);
    try
      if not FileExists(FPath + FTitle + '_ORD.xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '_ORD.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '_ORD.xml');
      nXmlBase := Xml.DocumentElement;
      eOrderListNode := nXmlBase.ChildNodes.FindNode('ORDERLIST');
      while eOrderListNode <> nil do
      begin
        eOrderNode := eOrderListNode.ChildNodes['ORDER'];
        while eOrderNode <> nil do
        begin

          eOrderHeaderNode := eOrderNode.ChildNodes['ORDERHEADER'];
          eOrderHeaderAddNode := eOrderHeaderNode.ChildNodes['HEADERADDITIONAL'];
          if eOrderHeaderAddNode <> nil then
            eOrderAddNode       := eOrderHeaderAddNode.ChildNodes['ADDITIONAL'];

          With Fcds do
          begin
            Append;
            FieldByName('SupplierKey').AsString     := XmlStrToStr(eOrderHeaderNode.ChildValues['SUPPLIERKEY']);
            FieldByName('BrandNumber').AsString     := XmlStrToStr(eOrderHeaderNode.ChildValues['BRANDNUMBER']);
            FieldByName('OrderNumber').AsString     := XmlStrToStr(eOrderHeaderNode.ChildValues['ORDERNUMBER']);
            FieldByName('OrderDate').AsDateTime     := XmlStrToDate(eOrderHeaderNode.ChildValues['ORDERDATE']);
            FieldByName('OrderDenotation').AsString := XmlStrToStr(eOrderHeaderNode.ChildValues['ORDERDENOTATION']);
            FieldByName('OrderType').AsString       := XmlStrToStr(eOrderHeaderNode.ChildValues['ORDERTYPE']);
            FieldByName('OrderCollection').AsString := XmlStrToStr(eOrderHeaderNode.ChildValues['ORDERCOLLECTION']);
            FieldByName('OrderPeriode').AsString    := XmlStrToStr(eOrderHeaderNode.ChildValues['ORDERPERIODE']);
            FieldByName('OrderMemo').AsString       := XmlStrToStr(eOrderHeaderNode.ChildValues['ORDERMEMO']);
            FieldByName('MemberCode').AsString      := XmlStrToStr(eOrderHeaderNode.ChildValues['MEMBERCODE']);
            if eOrderAddNode <> nil then
               FieldByName('ErpNo').AsString := XmlStrToStr(eOrderAddNode.ChildValues['ERPNO'])
            else
              FieldByName('ErpNo').AsString :=  '';

            Post;
          end;

          if FCODEMAG = '' then
          begin
            FCODEMAG := XmlStrToStr(eOrderHeaderNode.ChildValues['MEMBERCODE']);
            if Trim(FCODEMAG) = '' then
              FCODEMAG := LeftStr(FTitle,Pos('_',FTitle) -1);
          end;

          ePositionListNode := eOrderNode.ChildNodes['POSITIONLIST'];
          while ePositionListNode <> nil do
          begin
            ePositionNode := ePositionListNode.ChildNodes['POSITION'];
            while ePositionNode <> nil do
            begin
              With FPositionList.ClientDataSet do
              begin
                Append;
                FieldByName('OrderNumber').AsString      := XmlStrToStr(eOrderHeaderNode.ChildValues['ORDERNUMBER']);
                FieldByName('PositionNumber').AsInteger  := XmlStrToInt(ePositionNode.ChildValues['POSITIONNUMBER']);
                FieldByName('Code').AsString             := XmlStrToStr(ePositionNode.ChildValues['CODE']);
                FieldByName('SizeRange').AsString        := XmlStrToStr(ePositionNode.ChildValues['SIZERANGE']);
                FieldByName('DeliveryDate').AsDateTime   := XmlStrToDate(ePositionNode.ChildValues['DELIVERYDATE']);
                FieldByName('DeliveryEarly').AsDateTime  := XmlStrToDate(ePositionNode.ChildValues['DELIVERYDATEEARLY']);
                FieldByName('DeliveryLatest').AsDateTime := XmlStrToDate(ePositionNode.ChildValues['DELIVERYDATELATEST']);
                FieldByName('PurchasePrice').AsFloat     := XmlStrToFloat(ePositionNode.ChildValues['PURCHASEPRICE']);
                FieldByName('REBATE1').AsFloat           := XmlStrToFloat(ePositionNode.ChildValues['REBATE1']);
                FieldByName('REBATE2').AsFloat           := XmlStrToFloat(ePositionNode.ChildValues['REBATE2']);
                Post;
              end;

              eItemListNode := ePositionNode.ChildNodes['ITEMLIST'];
              while eItemListNode <> nil do
              begin
                eItemNode := eItemListNode.ChildNodes['ITEM'];
                while eItemNode <> nil do
                begin
                  eItemItemAddNode := eItemNode.ChildNodes['ITEMADDITIONAL'];
//                  eItemNode.ChildNodes.Get(0).NodeName
//                  eItemNode.ChildNodes.Get(0).NodeValue

                  eItemAddNode := nil;
                  if eItemItemAddNode <> nil then
                    eItemAddNode := eItemItemAddNode.ChildNodes['ADDITIONAL'];

                  With FItemList.ClientDataSet do
                  begin
                    Append;
                    FieldByName('OrderNumber').AsString     := XmlStrToStr(eOrderHeaderNode.ChildValues['ORDERNUMBER']);
                    FieldByName('PositionNumber').AsInteger := XmlStrToInt(ePositionNode.ChildValues['POSITIONNUMBER']);
                    FieldByName('EAN').AsString             := XmlStrToStr(eItemNode.ChildValues['EAN']);
                    FieldByName('ColNo').AsString           := XmlStrToStr(eItemNode.ChildValues['COLNO']);
                    FieldByName('Columnx').AsString         := XmlStrToStr(eItemNode.ChildValues['COLUMNX']);
                    FieldByName('Quantity').AsInteger       := XmlStrToInt(eItemNode.ChildValues['QUANTITY']);
                    FieldByName('PurchasePrice').AsExtended := XmlStrToFloat(eItemNode.ChildValues['PURCHASEPRICE']);
                    if eItemAddNode <> nil then
                      FieldByName('Coll').AsString            := XmlStrToStr(eItemAddNode.ChildValues['COLL'])
                    else
                      FieldByName('Coll').AsString            := '';
                    Post;
                  end;
                  eItemNode := eItemNode.NextSibling;
                end; // while eItemNode
                eItemListNode := eItemListNode.NextSibling;
              end; // while eItemListNode
              ePositionNode := ePositionNode.NextSibling;
            end; // while ePositionNode
            ePositionListNode := ePositionListNode.NextSibling;
          end; // ePositionListNode
          eOrderNode := eOrderNode.NextSibling;
        end; // while eOrderNode
        eOrderListNode := eOrderListNode.NextSibling;
      end; // while eOrderListNode

      // gestion du xml SD
      if not FileExists(FPath + FTitle + '_SD.xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '_SD.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '_SD.xml');

      nXmlBase := Xml.DocumentElement;
      eCatalogListNode := nXmlBase.ChildNodes.FindNode('CATALOGLIST');
//      while eCatalogListNode <> nil do
      begin
        eCatalogNode := eCatalogListNode.ChildNodes['CATALOG'];
        while eCatalogNode <> nil do
        begin
          eCatalogAddNode := eCatalogNode.ChildNodes['CATALOGADDITIONAL'];
          if eCatalogAddNode <> nil then
            eCatalogAdditionalNode := eCatalogAddNode.ChildNodes['ADDITIONAL'];

           With FCatalogList.ClientDataSet do
           begin
             Append;
             FieldByName('SupplierKey').AsString       := XmlStrToStr(eCatalogNode.ChildValues['SUPPLIERKEY']);
             FieldByName('CatalogKey').AsString        := XmlStrToStr(eCatalogNode.ChildValues['CATALOGKEY']);
             FieldByName('CatalogDenotation').AsString := XmlStrToStr(eCatalogNode.ChildValues['CATALOGDENOTATION']);
             if eCatalogAdditionalNode <> nil then
             begin
               FieldByName('AddSupplierKey').AsString := XmlStrToStr(eCatalogAdditionalNode.ChildNodes['SUPPLIERKEY'].NodeValue);
               FieldByName('AddSupplierERP').AsString := XmlStrToStr(eCatalogAdditionalNode.ChildNodes['SUPPLIERERP'].NodeValue);
             end
             else begin
               FieldByName('AddSupplierKey').AsString := '';
               FieldByName('AddSupplierERP').AsString := '';
             end;
             Post;
           end;

           eModelListNode := eCatalogNode.ChildNodes['MODELLIST'];
           while eModelListNode <> nil do
           begin
             eModelMode := eModelListNode.ChildNodes['MODEL'];
             while eModelMode <> nil do
             begin
               eModelModelAddNode := eModelMode.ChildNodes['MODELADDITIONAL'];
               if eModelModelAddNode <> nil then
                 eModelAdditionalNode := eModelModelAddNode.ChildNodes['ADDITIONAL'];

               // Noeud MODEL
               With FModelList.ClientDataSet do
               begin
                 Append;
                 FieldByName('ModelType').AsInteger              := XmlStrToInt(eModelMode.ChildValues['MODELTYPE']);
                 FieldByName('SupplierKey').AsString             := XmlStrToStr(eCatalogNode.ChildValues['SUPPLIERKEY']);
                 FieldByName('ModelNumber').AsString             := XmlStrToStr(eModelMode.ChildValues['MODELNUMBER']);
                 FieldByName('BrandNumber').AsString             := XmlStrToStr(eModelMode.ChildValues['BRANDNUMBER']);
                 FieldByName('Denotation').AsString              := XmlStrToStr(eModelMode.ChildValues['DENOTATION']);
                 FieldByName('DenotationLong').AsString          := XmlStrToStr(eModelMode.ChildValues['DENOTATIONLONG']);
                 FieldByName('Fedas').AsString                   := XmlStrToStr(eModelMode.ChildValues['FEDAS']);
                 FieldByName('Vat').AsExtended                   := XmlStrToFloat(eModelMode.ChildValues['VAT']);
                 FieldByName('SizeRange').AsString               := XmlStrToStr(eModelMode.ChildValues['SIZERANGE']);
                 FieldByName('RecommendedSalesPrice').AsExtended := XmlStrToFloat(eModelMode.ChildValues['RECOMMENDEDSALESPRICE']);
                 FieldbyName('RecommandedDate').AsDateTime       := XmlStrToDate(eModelMode.ChildValues['RECOMMENDEDDATE']);
                 FieldByName('ART_ID').AsInteger             := -1;

                 // MODEL -> MODELADDITIONAL
                 if eModelModelAddNode <> nil then
                   if FieldByName('ModelType').AsInteger = 2 then
                     FieldByName('ART_ID').AsInteger             := XmlStrToInt(eModelModelAddNode.ChildValues['IDGINKOIA'],-1);

                 // MODEL -> MODELADDITIONAL -> ADDITIONNAL
                 if eModelAdditionalNode <> nil then
                 begin
                   FieldByName('Supplier2Key').AsString        := XmlStrToStr(eModelAdditionalNode.ChildValues['SUPPLIER2KEY']);
                   FieldByName('Supplier2ERP').AsString        := XmlStrToStr(eModelAdditionalNode.ChildValues['SUPPLIER2ERP']);
                   FieldByName('Supplier2Denotation').AsString := XmlStrToStr(eModelAdditionalNode.ChildValues['SUPPLIER2DENOTATION']);
                   FieldByName('PUB').AsInteger                := XmlStrToInt(eModelAdditionalNode.ChildValues['PUB']);
                   // Gestion de l'article
                 end;
                 Post;
               end;

               eColorListNode := eModelMode.ChildNodes.FindNode('COLORLIST');
               if eColorListNode.ChildNodes.Count = 0 then
                 raise Exception.Create('Noeud COLORLIST vide pour le modèle ' + eModelMode.ChildValues['MODELNUMBER']);

               while eColorListNode <> nil do
               begin
                 eColorNode := eColorListNode.ChildNodes['COLOR'];
                 while eColorNode <> nil do
                 begin
                   With FColorList.ClientDataSet do
                   begin
                     Append;
                     FieldByName('ModelNumber').AsString     := XmlStrToStr(eModelMode.ChildValues['MODELNUMBER']);
                     FieldByName('ColorNumber').AsString     := XmlStrToStr(eColorNode.ChildValues['COLORNUMBER']);
                     FieldByName('ColorDenotation').AsString := XmlStrToStr(eColorNode.ChildValues['COLORDENOTATION']);

                     // Gestion de l'ID ginkoia (Gérer seulement si le ModelType est à 2
                     FieldByName('COU_ID').AsInteger       := -1;
                     if (FModelList.FieldByName('ModelType').AsInteger = 2) then
                     begin
                       eColorAddNode := eColorNode.ChildNodes['COLORADDITIONAL'];

                       if eColorAddNode <> nil then
                         FieldByName('COU_ID').AsInteger       := XmlStrToInt(eColorAddNode.ChildValues['IDGINKOIA'],-1);
                     end;
                     Post;
                   end;

                   eItemListNode := eColorNode.ChildNodes.FindNode('ITEMLIST');
                   if eItemListNode.ChildNodes.Count = 0 then
                     raise Exception.Create('Noeud IITEMLIST vide pour le modèle ' + eModelMode.ChildValues['MODELNUMBER']);

                   while eItemListNode <> nil do
                   begin
                     eItemNode := eItemListNode.ChildNodes['ITEM'];
                     while eItemNode <> nil do
                     begin
                       With FColorItemList.ClientDataSet do
                       begin
                         Append;
                         FieldByName('ModelNumber').AsString     := XmlStrToStr(eModelMode.ChildValues['MODELNUMBER']);
                         FieldByName('ColorNumber').AsString     := XmlStrToStr(eColorNode.ChildValues['COLORNUMBER']);
                         FieldByName('EAN').AsString             := XmlStrToStr(eItemNode.ChildValues['EAN']);
                         FieldByName('Columnx').AsString         := XmlStrToStr(eItemNode.ChildValues['COLUMNX']);
                         FieldByName('SizeLabel').AsString       := XmlStrToStr(eItemNode.ChildValues['SIZELABEL']);
                         FieldByName('PurchasePrice').AsExtended := XmlStrToFloat(eItemNode.ChildValues['PURCHASEPRICE']);
                         FieldByName('RetailPrice').AsExtended   := XmlStrToFloat(eItemNode.ChildValues['RETAILPRICE']);
                         FieldByName('Smu').AsInteger            := XmlStrToInt(eItemNode.ChildValues['SMU']);
                         FieldByName('TDSC').AsInteger           := XmlStrToInt(eItemNode.ChildValues['TDSC']);
                         Post;
                       end;
                       eItemNode := eItemNode.NextSibling;
                     end; // while eItemNode
                     eItemListNode := eItemListNode.NextSibling;
                   end; // while eItemListNode
                   eColorNode := eColorNode.NextSibling;
                 end; // while eColorNode
                 eColorListNode := eColorListNode.NextSibling;
               end; // while eColorListNode
               eModelMode := eModelMode.NextSibling;
             end;  // eModelMode
             eModelListNode := eModelListNode.NextSibling;
           end; //while eModelListNode
          eCatalogNode := eCatalogNode.NextSibling;
        end; // while eCatalogNode
     //   eCatalogListNode := eCatalogListNode.NextSibling;
      end; // while eCatalogListNode

//    Except on E:Exception do
//      raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
//    end;
    finally //on E:Exception do
      //raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
      Xml := Nil;
      TXMLDocument(Xml).Free;
    end;
  Except on E:Exception do
    raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
  end;
end;


function TCommandeClass.SetArtClaItem(ACIT_CLAID, ACIT_ICLID: Integer): Integer;
begin
  With FStpQuery do
  try
    Result := -1;
    Close;
    StoredProcName := 'MSS_ARTCLAITEM';
    ParamCheck := True;
    ParamByName('CLAID').AsInteger := ACIT_CLAID;
    ParamByName('ICLID').AsInteger := ACIT_ICLID;
    Open;
    Result := FieldByName('CIT_ID').AsInteger;
  Except on E:Exception do
    raise Exception.Create('SetArtClaItem -> ' + E.Message);
  end;
end;

function TCommandeClass.SetArtClassement(ACLA_NOM, ACLA_TYPE: String;
  ACLA_NUM: Integer): Integer;
begin
  With FIboQuery do
//  With FStpQuery do
  Try
    Result := -1;
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_ARTCLASSEMENT(:CLANOM,:CLATYPE,:CLANUM)');
//    StoredProcName := 'MSS_ARTCLASSEMENT';
    ParamCheck := True;
    ParamByName('CLANOM').AsString  := ACLA_NOM;
    ParamByName('CLATYPE').AsString := ACLA_TYPE;
    ParamByName('CLANUM').AsInteger := ACLA_NUM;
    Open;
    Result := FieldByName('CLA_ID').AsInteger;
  Except on E:Exception do
    raise Exception.Create('SetArtClassement -> ' + E.Message);
  end;
end;

function TCommandeClass.SetARTCodeBarre(ACBI_ARFID, ACBI_TGFID, ACBI_COUID,
  ACBI_TYPE: Integer; ACBI_CB: String): Integer;
begin
//  With FStpQuery do
//  try
//    Close;
//    StoredProcName := 'MSS_SETARTCODEBARRE';
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_SETARTCODEBARRE(:CBIARFID,:CBITGFID,:CBICOUID,:CBITYPE,:CBICB)');
    ParamCheck := True;
    ParamByName('CBIARFID').AsInteger := ACBI_ARFID;
    ParamByName('CBITGFID').AsInteger := ACBI_TGFID;
    ParamByName('CBICOUID').AsInteger := ACBI_COUID;
    ParamByName('CBITYPE').AsInteger  := ACBI_TYPE;
    ParamByName('CBICB').AsString     := ACBI_CB;
    Open;

    Result := FieldByName('CBI_ID').AsInteger;
    Inc(FArtInscount,FieldByName('FAJOUT').AsInteger);
    Inc(FArtMajCount, FieldByName('FMAJ').AsInteger);

  Except on E:Exception Do
    raise EMODELERROR.Create('SetARTCodeBarre -> ' + E.Message);
  end;
end;

function TCommandeClass.SetArtColArt(ART_ID, COL_ID: integer): integer;
begin
//  With FIboQuery do
  With FStpQuery do
  try
    Close;
    StoredProcName := 'MSS_SETARTCOLART';
    ParamCheck := True;
    ParamByName('ART_ID').AsInteger := ART_ID;
    ParamByName('COL_ID').AsInteger := COL_ID;
    Open;

    Result := FieldByName('CAR_ID').AsInteger;
    Inc(FCmdInsCount,FieldByName('FAJOUT').AsInteger);

//    Close;
//    SQL.Clear;
//    SQL.Add('Select CAR_ID from ARTCOLART');
//    SQL.Add('  join K on K_ID = CAR_ID and K_enabled = 1');
//    SQL.Add('Where CAR_ARTID = :PARTID');
//    SQL.Add('  and CAR_COLID = :PCOLID');
//    ParamCheck := True;
//    ParamByName('PARTID').AsInteger := ART_ID;
//    ParamByName('PCOLID').AsInteger := COL_ID;
//    Open;
//
//    if Recordcount <= 0 then
//    begin
//      Result := GetNewKID('ARTCOLART');
//      Close;
//      SQL.Clear;
//      SQL.Add('Insert into ARTCOLART(CAR_ID, CAR_ARTID, CAR_COLID)');
//      SQL.Add('Values(:PCARID, :PARTID, :PCOLID)');
//      ParamCheck := True;
//      ParamByName('PCARID').AsInteger := Result;
//      ParamByName('PARTID').AsInteger := ART_ID;
//      ParamByName('PCOLID').AsInteger := COL_ID;
//      ExecSQL;
//    end
//    else
//      Result := FieldByName('CAR_ID').AsInteger;
  Except on E:Exception do
    raise Exception.Create('SetArtColArt -> ' + E.Message);
  end;
end;

function TCommandeClass.SetArticle(ART_REFMRK: String; ART_MRKID,
  ART_GREID: INTEGER; ART_NOM, ART_DESCRIPTION, ART_COMMENT5: String; ART_SSFID,
  ART_GTFID, ART_GARID, ARF_TVAID, ARF_ICLID3, ARF_ICLID4, ARF_ICLID5,
  ARF_CATID, ARF_TCTID: INTEGER; ART_CODE, ART_FEDAS : String; ART_PXETIQU, ART_ACTID, ART_CENTRALE, ART_PUB : Integer ): TArtArticle;
begin
//  if FCdsArt.Locate('ART_CODE;ART_GTFID',VarArrayOf([ART_CODE,ART_GTFID]),[loCaseInsensitive]) then
//  begin
//    Result.ART_ID := FCdsArt.FieldByName('ART_ID').AsInteger;
//    Result.ARF_ID := FCdsArt.FieldByName('ARF_ID').AsInteger;
//    Result.FAjout := 0;
//    Result.FMaj   := 0;
//    Exit;
//  end;

  With FStpQuery do
  try
    Close;
    StoredProcName := 'MSS_NEWARTICLE';
    ParamCheck := True;
    ParamByName('ARTREFMRK').AsString := ART_REFMRK;
    ParamByName('ARTMRKID').AsInteger := ART_MRKID;
    ParamByName('ARTGREID').AsInteger := ART_GREID;
    ParamByName('ARTNOM').AsString    := ART_NOM;
    ParamByName('ARTDESCRIPTION').AsString := ART_DESCRIPTION;
    ParamByName('ARTCOMMENT5').AsString    := ART_COMMENT5;
    ParamByName('ARTSSFID').AsInteger      := ART_SSFID;
    ParamByName('ARTGTFID').AsInteger      := ART_GTFID;
    ParamByName('ARTGARID').AsInteger      := ART_GARID;
    ParamByName('ARFTVAID').AsInteger      := ARF_TVAID;
    ParamByName('ARFICLID3').AsInteger     := ARF_ICLID3;
    ParamByName('ARFICLID4').AsInteger     := ARF_ICLID4;
    ParamByName('ARFICLID5').AsInteger     := ARF_ICLID5;
    ParamByName('ARFCATID').AsInteger      := ARF_CATID;
    ParamByName('ARFTCTID').AsInteger      := ARF_TCTID;
    ParamByName('ARTCODE').AsString        := ART_CODE;
    ParamByName('ARTFEDAS').AsString       := ART_FEDAS;
    ParamByName('ARTPXETIQU').AsInteger    := ART_PXETIQU;
    ParamByName('ARTACTID').AsInteger      := ART_ACTID;
    ParamByName('ARTPUB').AsInteger        := ART_PUB;

    case ART_CENTRALE of
      1: ParamByName('ARTCENTRALE').AsInteger := 1;
      2: ParamByName('ARTCENTRALE').AsInteger := 5;
      3: ParamByName('ARTCENTRALE').AsInteger := 0;
      else
        raise Exception.Create(Format('Model Type non géré %d',[ART_CENTRALE]));
    end;
//    ParamByName('ARTCENTRALE').AsInteger   := ART_CENTRALE;
    Open;

    Result.ART_ID := FieldByName('ART_ID').AsInteger;
    Result.ARF_ID := FieldByName('ARF_ID').AsInteger;
    Result.FAjout := FieldByName('FAJOUT').AsInteger;
    Result.FMaj   := FieldByName('FMAJ').AsInteger;
    Result.Chrono := FieldByName('ARF_CHRONO').AsString;

    FModelList.ClientDataSet.Edit;
    FModelList.ClientDataSet.FieldByName('ART_ID').AsInteger := Result.ART_ID;
    FModelList.ClientDataSet.FieldByName('ARF_ID').AsInteger := Result.ARF_ID;
    FModelList.ClientDataSet.Post;

    Inc(FArtInscount,FieldByName('FAJOUT').AsInteger);
    Inc(FArtMajCount,FieldByName('FMAJ').AsInteger);
  Except on E:Exception do
    raise Exception.Create('SetArticle -> ' + E.Message);
  end;
end;

function TCommandeClass.SetArtItemC(AICL_NOM : String): Integer;
begin
  With FStpQuery do
  Try
    Result := -1;
    Close;
    StoredProcName := 'MSS_ARTITEMC';
    ParamCheck := True;
    ParamByName('ICLNOM').AsString := AICL_NOM;
    Open;
    Result := FieldByName('ICL_ID').AsInteger;
  Except on E:Exception do
    raise Exception.Create('SetArtItemC -> ' + E.Message);
  end;
end;

function TCommandeClass.SetArtPrixAchat(CLG_ARTID, CLG_FOUID,
    CLG_TGFID, CLG_COUID : Integer; CLG_PX, CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3,
    CLG_TAXE: Single; CLG_PRINCIPAL, CLG_CENTRALE: integer): Integer;
var
  iCLGId : integer;
  bPrincipal : Boolean;
  bIsPrincipal : Boolean;
begin
  Try
//    With FIboQuery do
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_TACHAT_CREATE';
//      SQL.clear;
//      SQL.Add('Select * from MSS_TACHAT_CREATE(:CLG_ARTID, :CLG_FOUID,:CLG_TGFID,');
//      SQL.Add(' :CLG_COUID, :CLG_PX, :CLG_PXNEGO, :CLG_PXVI, :CLG_RA1, :CLG_RA2, ');
//      SQL.Add(':CLG_RA3, :CLG_TAXE, :CLG_PRINCIPAL,:CLG_CENTRALE)');
//      Params.Clear;
      ParamCheck := True;
      ParamByName('CLG_ARTID').AsInteger     := CLG_ARTID;
      ParamByName('CLG_FOUID').AsInteger     := CLG_FOUID;
      ParamByName('CLG_TGFID').AsInteger     := CLG_TGFID;
      ParamByName('CLG_COUID').AsInteger     := CLG_COUID;
      ParamByName('CLG_PX').AsCurrency       := CLG_PX;
      ParamByName('CLG_PXNEGO').AsCurrency   := CLG_PXNEGO;
      ParamByName('CLG_PXVI').AsCurrency     := CLG_PXVI;
      ParamByName('CLG_RA1').AsCurrency      := CLG_RA1;
      ParamByName('CLG_RA2').AsCurrency      := CLG_RA2;
      ParamByName('CLG_RA3').AsCurrency      := CLG_RA3;
      ParamByName('CLG_TAXE').AsCurrency     := CLG_TAXE;
      ParamByName('CLG_PRINCIPAL').AsInteger := CLG_PRINCIPAL;
      ParamByName('CLG_CENTRALE').AsInteger  := CLG_CENTRALE;
      Open;

      Inc(FArtInscount,FieldByName('FAJOUT').AsInteger);
      Close;
    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixAchat -> ' + E.Message);
  End;

end;

function TCommandeClass.SetArtPrixAchat_Base(CLG_ARTID, CLG_FOUID : Integer;
  CLG_PX, CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3, CLG_TAXE: Single;CLG_CENTRALE : Integer) : Integer;
begin
  try
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_TACHATBASE_CREATEORMAJ';
      ParamCheck := True;
      ParamByName('CLG_ARTID').AsInteger := CLG_ARTID;
      ParamByName('CLG_FOUID').AsInteger := CLG_FOUID;
      ParamByName('CLG_PX').AsCurrency:= CLG_PX;
      ParamByName('CLG_PXNEGO').AsCurrency:= CLG_PXNEGO;
      ParamByName('CLG_PXVI').AsCurrency:= CLG_PXVI;
      ParamByName('CLG_RA1').AsCurrency:= CLG_RA1;
      ParamByName('CLG_RA2').AsCurrency:= CLG_RA2;
      ParamByName('CLG_RA3').AsCurrency:= CLG_RA3;
      ParamByName('CLG_TAXE').AsCurrency:= CLG_TAXE;
      ParamByName('CLG_CENTRALE').AsInteger := CLG_CENTRALE;
      Open;

      Inc(FArtInscount,FieldByName('FAJOUT').AsInteger);
      Inc(FArtMajCount,FieldByName('FMAJ').AsInteger);
      Result := FieldByName('PRINCIPAL').AsInteger;
    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixAchat_Base -> ' + E.Message);
  End;
end;

function TCommandeClass.SetArtPrixAchat_Tmp(CLG_ARTID2, CLG_FOUID2, CLG_TGFID2,
  CLG_COUID2: Integer; CLG_PX2, CLG_PXNEGO2, CLG_PXVI2: Single): Integer;
var
  iCLGId : integer;
  bPrincipal : Boolean;
  bIsPrincipal : Boolean;
begin
  Try
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select CLG_ID2,CLG_PX2 from TARCLGFOURN_TMP');
      SQL.Add(' join k on K_ID = CLG_ID2 and k_enabled = 1');
      SQL.Add('Where CLG_ARTID2 = :PARTID');
      SQL.Add('  and CLG_FOUID2 = :PFOUID');
      SQL.Add('  and CLG_TGFID2 = :PTGFID');
      SQL.Add('  and CLG_COUID2 = :PCOUID');
      ParamCheck := True;
      ParamByName('PARTID').AsInteger := CLG_ARTID2;
      ParamByName('PFOUID').AsInteger := CLG_FOUID2;
      ParamByName('PTGFID').AsInteger := CLG_TGFID2;
      ParamByName('PCOUID').AsInteger := CLG_COUID2;
      Open;

      if RecordCount <= 0 then
      begin
        iCLGId := GetNewKId('TARCLGFOURN_TMP');
        Close;
        SQL.Clear;
        SQL.Add('Insert into TARCLGFOURN_TMP');
        SQL.Add('(CLG_ID2,CLG_ARTID2,CLG_FOUID2,CLG_TGFID2,CLG_COUID2,CLG_PX2,CLG_PXNEGO2,CLG_PXVI2)');
        SQL.Add('Values(:PCLGID,:PCLGARTID,:PCLGFOUID,:PCLGTGFID,:PCLGCOUID,:PCLGPX,:PCLGPXNEGO,:PCLGPXVI)');
        ParamCheck := True;
        ParamByName('PCLGID').AsInteger        := iCLGId;
        ParamByName('PCLGARTID').AsInteger     := CLG_ARTID2;
        ParamByName('PCLGFOUID').AsInteger     := CLG_FOUID2;
        ParamByName('PCLGTGFID').AsInteger     := CLG_TGFID2;
        ParamByName('PCLGPX').AsCurrency       := CLG_PX2;
        ParamByName('PCLGPXNEGO').AsCurrency   := CLG_PXNEGO2;
        ParamByName('PCLGPXVI').AsFloat        := CLG_PXVI2;
        ParamByName('PCLGCOUID').AsInteger     := CLG_COUID2;
        ExecSQL;
      end
      else begin
        iCLGId := FieldByName('CLG_ID2').AsInteger;
        // Si le prix est différent on met à jours juste le prix nego

        if CompareValue(FieldByName('CLG_PX2').AsFloat,CLG_PX2) = GreaterThanValue then
        begin
          Close;
          SQL.Clear;
          SQL.Add('Update TARCLGFOURN_TMP set');
          SQL.Add('  CLG_PXNEGO2 = :PCLGPXNEGO');
          SQL.Add('Where CLG_ID2 = :PCLGID');
          ParamCheck := True;
          ParamByName('PCLGPXNEGO').AsCurrency := CLG_PX2;
          ParamByName('PCLGID').AsInteger      := iCLGId;
          ExecSQL;
        end;
      end;

      Result := iCLGId;
    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixAchat_TMP -> ' + E.Message);
  End;

end;

function TCommandeClass.SetArtPrixVente(PVT_ARTID,
  PVT_TGFID, PVT_COUID, PVT_TVTID : Integer; PVT_PX: single; PVT_CENTRALE : Integer): Integer;
var
  iPVTID : Integer;
begin
  Try
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_TVENTE_CREATE';
      ParamCheck := True;
      ParamByName('PVT_ARTID').AsInteger := PVT_ARTID;
      ParamByName('PVT_TGFID').AsInteger := PVT_TGFID;
      ParamByName('PVT_COUID').AsInteger := PVT_COUID;
      ParamByName('PVT_TVTID').AsInteger := PVT_TVTID;
      ParamByName('PVT_PX').AsCurrency := PVT_PX;
      ParamByName('PVT_CENTRALE').AsInteger := PVT_CENTRALE;
      Open;

      Inc(FArtInscount, FieldByName('FAJOUT').AsInteger);
    end;

//    With FIboQuery do
//    begin
//      Close;
//      SQL.Clear;
//      SQL.add('Select PVT_ID,PVT_PX from TARPRIXVENTE');
//      SQL.Add('  join k on K_ID = PVT_ID and k_enabled = 1');
//      SQL.Add('where PVT_ARTID = :PARTID');
//      SQL.Add('  and PVT_TGFID = :PTGFID');
//      ParamCheck := True;
//
//      // est ce que le tarif de base est différent ?
//      if PVT_TGFID <> 0  then
//      begin
//        ParambyName('PARTID').AsInteger := PVT_ARTID;
//        ParamByName('PTGFID').AsInteger  := 0;
//        Open;
//        if RecordCount > 0 then
//        begin
//          // Si le tarif est identique a celui de base, inutile de continuer
//          if CompareValue(FieldByName('PVT_PX').AsFloat,PVT_PX,0.001) = EqualsValue then
//          begin
//            iPVTID := FieldByName('PVT_ID').AsInteger;
//            Exit;
//          end;
//        end;
//        Close;
//      end;
//
//      // on traite le prix de la taille normalement
//      ParambyName('PARTID').AsInteger := PVT_ARTID;
//      ParamByName('PTGFID').AsInteger := PVT_TGFID;
//      Open;
//
//      if RecordCount <= 0 then
//      begin
//        iPVTID := GetNewKId('TARPRIXVENTE');
//        Close;
//        SQL.Clear;
//        SQL.Add('Insert into TARPRIXVENTE');
//        SQL.Add('(PVT_ID,PVT_TVTID,PVT_ARTID,PVT_TGFID,PVT_PX, PVT_CENTRALE)');
//        SQL.Add('Values(:PPVTID,:PTVTID,:PARTID,:PTGFID,:PPVTPX, 1)');
//        ParamCheck := True;
//        ParamByName('PPVTID').AsInteger  := iPVTID;
//        ParamByName('PTVTID').AsInteger  := PVT_TVTID;
//        ParamByName('PARTID').AsInteger  := PVT_ARTID;
//        ParamByName('PTGFID').AsInteger  := PVT_TGFID;
//        ParamByName('PPVTPX').AsCurrency := PVT_PX;
//        ExecSQL;
//      end
//      else begin
//        iPVTID := FieldByName('PVT_ID').AsInteger;
//      end;
//
//      Result := iPVTID;
//    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixVente -> ' + E.Message);
  End;
end;

procedure TCommandeClass.SetArtPrixVente_Base(PVT_ARTID : Integer; PVT_PX: single;PVT_CENTRALE : Integer);
begin
  try
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_TVENTEBASE_CREATEORMAJ';
      ParamCheck := True;
      ParamByName('PVT_ARTID').AsInteger := PVT_ARTID;
      ParamByName('PVT_PX').AsCurrency := PVT_PX;
      ParamByName('PVT_CENTRALE').AsInteger := PVT_CENTRALE;
      Open;

      Inc(FArtInscount,FieldByName('FAJOUT').AsInteger);
      inc(FArtMajCount, FieldByName('FMAJ').AsInteger);
    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixVente_Base -> ' + E.Message);
  End;
end;

function TCommandeClass.SetArtPrixVente_Tmp(PVT_TVTID, PVT_ARTID, PVT_TGFID,
  PVT_COUID: Integer; PVT_PX: single): Integer;
var
  iPVTID : Integer;
begin
  Try
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.add('Select PVT_ID2,PVT_PX2 from TARPRIXVENTE_TMP');
      SQL.Add('  join k on K_ID = PVT_ID2 and k_enabled = 1');
      SQL.Add('where PVT_ARTID2 = :PARTID');
      SQL.Add('  and PVT_TGFID2 = :PTGFID');
      SQL.Add('  and PVT_COUID2 = :PCOUID');
      ParamCheck := True;
        // on traite le prix de la taille normalement
      ParambyName('PARTID').AsInteger := PVT_ARTID;
      ParamByName('PTGFID').AsInteger := PVT_TGFID;
      ParamByName('PCOUID').AsInteger := PVT_COUID;
      Open;

      if RecordCount <= 0 then
      begin
        iPVTID := GetNewKId('TARPRIXVENTE_TMP');
        Close;
        SQL.Clear;
        SQL.Add('Insert into TARPRIXVENTE_TMP');
        SQL.Add('(PVT_ID2,PVT_TVTID2,PVT_ARTID2,PVT_TGFID2,PVT_COUID2,PVT_PX2)');
        SQL.Add('Values(:PPVTID,:PTVTID,:PARTID,:PTGFID,:PCOUID,:PPVTPX)');
        ParamCheck := True;
        ParamByName('PPVTID').AsInteger  := iPVTID;
        ParamByName('PTVTID').AsInteger  := PVT_TVTID;
        ParamByName('PARTID').AsInteger  := PVT_ARTID;
        ParamByName('PTGFID').AsInteger  := PVT_TGFID;
        ParamByName('PCOUID').AsInteger  := PVT_COUID;
        ParamByName('PPVTPX').AsCurrency := PVT_PX;
        ExecSQL;
      end
      else begin
        iPVTID := FieldByName('PVT_ID2').AsInteger;
      end;

      Result := iPVTID;
    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixVente_Tmp -> ' + E.Message);
  End;
end;

function TCommandeClass.SetARTRelationAxe(ART_ID, SSF_ID: Integer): integer;
begin
  With FStpQuery do
  begin
    Close;
    StoredProcName := 'MSS_SETARTRELATIONAXE';
    ParamCheck := True;
    ParamByName('ART_ID').AsInteger := ART_ID;
    ParamByName('SSF_ID').AsInteger := SSF_ID;
    Open;

    Inc(FArtInscount,FieldByName('FAJOUT').AsInteger);
  end;
end;

function TCommandeClass.SetColor(ACOU_ARTID: Integer; ACOU_CODE,
  ACOU_NOM: String; COU_SMU, COU_TDSC : Integer): Integer;
begin
  With FStpQuery do
  try
    Result := -1;
    Close;
    StoredProcName := 'MSS_PLXCOULEUR';
    ParamCheck := True;
    ParamByName('COUARTID').AsInteger := ACOU_ARTID;
    ParamByName('COUCODE').AsString   := ACOU_CODE;
    ParamByName('COUNOM').AsString    := ACOU_NOM;
    ParamByName('COUSMU').AsInteger   := COU_SMU;
    ParamByName('COUTDSC').AsInteger  := COU_TDSC;
    Open;
    Result := FieldByName('COU_ID').AsInteger;
  Except on E:Exception Do
    raise Exception.Create('SetColor -> ' + E.Message);
  end;
end;

function TCommandeClass.SetCOMBCDE(ACDE_SAISON, ACDE_EXEID,
  ACDE_CPAID, ACDE_MAGID, ACDE_FOUID: Integer; ACDE_NUMFOURN: String;
  ACDE_DATE: TDateTime; ACDE_TVAHT1, ACDE_TVATAUX1, ACDE_TVA1, ACDE_TVAHT2,
  ACDE_TVATAUX2, ACDE_TVA2, ACDE_TVAHT3, ACDE_TVATAUX3, ACDE_TVA3, ACDE_TVAHT4,
  ACDE_TVATAUX4, ACDE_TVA4, ACDE_TVAHT5, ACDE_TVATAUX5, ACDE_TVA5: Extended;
  ACDE_LIVRAISON: TDatetime; ACDE_TYPID, ACDE_USRID: Integer;
  ACDE_COMENT: String; ACDE_COLID, ACDE_OFFSET: Integer): TCmdStruct;
begin
  With FStpQuery do
  try
    Close;
    StoredProcName := 'MSS_SETCOMBCDE';
    ParamCheck := True;

//    ParamByName('IMP_NUM').AsInteger := CIMPNUM;
//    ParamByName('IMP_KTBID').AsInteger := CKTBID_COMBCDE;
//    ParamByName('CDENUMERO').AsString  := ACDE_NUMERO;
    ParamByName('CDESAISON').AsInteger     := ACDE_SAISON;
    ParamByName('CDEEXEID').AsInteger      := ACDE_EXEID;
    ParamByName('CDECPAID').AsInteger      := ACDE_CPAID;
    ParamByName('CDEMAGID').AsInteger      := ACDE_MAGID;
    ParamByName('CDEFOUID').AsInteger      := ACDE_FOUID;
    ParamByName('CDENUMFOURN').AsString    := ACDE_NUMFOURN;
    ParamByName('CDEDATE').AsDateTime      := ACDE_DATE;
    ParamByName('CDETVAHT1').AsFloat       := ACDE_TVAHT1;
    ParamByName('CDETVATAUX1').AsFloat     := ACDE_TVATAUX1;
    ParamByName('CDETVA1').AsFloat         := ACDE_TVA1;
    ParamByName('CDETVAHT2').AsFloat       := ACDE_TVAHT2;
    ParamByName('CDETVATAUX2').AsFloat     := ACDE_TVATAUX2;
    ParamByName('CDETVA2').AsFloat         := ACDE_TVA2;
    ParamByName('CDETVAHT3').AsFloat       := ACDE_TVAHT3;
    ParamByName('CDETVATAUX3').AsFloat     := ACDE_TVATAUX3;
    ParamByName('CDETVA3').AsFloat         := ACDE_TVA3;
    ParamByName('CDETVAHT4').AsFloat       := ACDE_TVAHT4;
    ParamByName('CDETVATAUX4').AsFloat     := ACDE_TVATAUX4;
    ParamByName('CDETVA4').AsFloat         := ACDE_TVA4;
    ParamByName('CDETVAHT5').AsFloat       := ACDE_TVAHT5;
    ParamByName('CDETVATAUX5').AsFloat     := ACDE_TVATAUX5;
    ParamByName('CDETVA5').AsFloat         := ACDE_TVA5;
    ParamByName('CDELIVRAISON').AsDateTime := ACDE_LIVRAISON;
    ParamByName('CDETYPID').AsInteger      := ACDE_TYPID;
    ParamByName('CDEUSRID').AsInteger      := ACDE_USRID;
    ParamByName('CDECOMENT').AsString      := ACDE_COMENT;
    ParamByName('CDECOLID').AsInteger      := ACDE_COLID;
    ParamByName('CDEOFFSET').AsInteger     := ACDE_OFFSET;
    Open;

    if RecordCount > 0 then
    begin
      Result.CDE_ID := FieldByName('CDE_ID').AsInteger;
      Result.Fajout := FieldByName('FAJOUT').AsInteger;
      Result.FMaj   := FieldByName('FMAJ').AsInteger;
      Result.Chrono := FieldByName('CDE_NUMERO').AsString;
    end else
      Result.CDE_ID := -1;

  Except on E:Exception Do
    raise Exception.Create('SetCOMBCDE -> ' + E.Message);
  end;
end;

function TCommandeClass.SetCOMCDEL(CDL_CDEID, CDL_ARTID, CDL_TGFID,
  CDL_COUID: Integer; CDL_QTE, CDL_PXCTLG, CDL_REMISE1, CDL_REMISE2,
  CDL_PXACHAT, CDL_TVA, CDL_PXVENTE: Extended;
  CDL_LIVRAISON: TDateTime; CDL_COLID : Integer; ACreateMode : Boolean): TLigneStruct;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_SETCOMBCDEL(:CDLCDEID,:CDLARTID,:CDLTGFID,:CDLCOUID,');
    SQL.Add(':CDLQTE,:CDLPXCTLG,:CDLREMISE1,:CDLREMISE2,:CDLPXACHAT,:CDLTVA,:CDLPXVENTE,');
    SQL.Add(':CDLLIVRAISON,:CDLCOLID,:CreateMode)');
    ParamCheck := True;
    ParamByName('CDLCDEID').AsInteger      := CDL_CDEID;
    ParamByName('CDLARTID').AsInteger      := CDL_ARTID;
    ParamByName('CDLTGFID').AsInteger      := CDL_TGFID;
    ParamByName('CDLCOUID').AsInteger      := CDL_COUID;
    ParamByName('CDLQTE').AsFloat          := CDL_QTE;
    ParamByName('CDLPXCTLG').AsFloat       := CDL_PXCTLG;
    ParamByName('CDLREMISE1').AsFloat      := CDL_REMISE1;
    ParamByName('CDLREMISE2').AsFloat      := CDL_REMISE2;
    ParamByName('CDLPXACHAT').AsFloat      := CDL_PXACHAT;
    ParamByName('CDLTVA').AsFloat          := CDL_TVA;
    ParamByName('CDLPXVENTE').AsFloat      := CDL_PXVENTE;
    ParamByName('CDLLIVRAISON').AsDateTime := CDL_LIVRAISON;
    ParamByName('CDLCOLID').AsInteger      := CDL_COLID;
    if ACreateMode then
      ParamByName('CreateMode').AsInteger := 1
    else
      ParamByName('CreateMode').AsInteger := 0;
    Open;

    Result.CDL_ID := FieldByName('CDL_ID').AsInteger;
    Result.FAJOUT := FieldByName('FAJOUT').AsInteger;
    Result.FMAJ   := FieldByName('FMAJ').AsInteger;

    Inc(FCmdInsCount, FieldByName('FAJOUT').AsInteger);
    Inc(FCmdMajCount, FieldByName('FMAJ').AsInteger);
  Except on E:Exception do
    raise EMODELERROR.Create('SetCOMCDEL -> ' + E.Message);
  end;
end;

function TCommandeClass.SetMrkFourn(AFOUID, AMRKID: Integer) : integer;
begin
  With FStpQuery do
  try
    Result := -1;
    Close;
    StoredProcName := 'MSS_SETMRKFOURN';
    ParamCheck := True;
    ParamByName('FOU_ID').AsInteger := AFOUID;
    ParamByName('MRK_ID').AsInteger := AMRKID;
    Open;

    Result := FieldByName('FMK_ID').AsInteger;

  Except on E:Exception Do
    raise Exception.Create('SetMrkFourn -> ' + E.Message);
  end;
end;

function TCommandeClass.SetTailleTrav(TTV_ARTID, TTV_TGFID: Integer): Integer;
var
  iTTVId : Integer;
begin
  try
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_SETTAILLETRAV';
      ParamCheck := True;
      ParamByName('TTV_ARTID').AsInteger := TTV_ARTID;
      ParamByName('TTV_TGFID').AsInteger := TTV_TGFID;
      ExecProc;
    end;

//    With FIboQuery do
//    begin
//      Close;
//      SQL.Clear;
//      SQL.Add('EXECUTE PROCEDURE MSS_SETTAILLETRAV(:PARTID, :PTGFID);');
//
//      SQL.Add('Select TTV_ID from PLXTAILLESTRAV');
//      SQL.Add('  join k on K_ID = TTV_ID and k_enabled = 1');
//      SQL.Add('where TTV_ARTID = :PARTID');
//      SQL.Add('  and TTV_TGFID = :PTGFID');
//      ParamCheck := True;
//      ParamByName('PARTID').AsInteger := TTV_ARTID;
//      ParamByName('PTGFID').AsInteger := TTV_TGFID;
//      Open;
//
//      if RecordCount <= 0 then
//      begin
//        iTTVId := GetNewKId('PLXTAILLESTRAV');
//        Close;
//        SQL.Clear;
//        SQL.Add('Insert into PLXTAILLESTRAV');
//        SQL.Add('(TTV_ID,TTV_ARTID,TTV_TGFID)');
//        SQL.Add('values(:PTTVID,:PTTVARTID,:PTTVTGFID)');
//        ParamCheck := True;
//        ParamByName('PTTVID').AsInteger    := iTTVId;
//        ParamByName('PTTVARTID').AsInteger := TTV_ARTID;
//        ParamByName('PTTVTGFID').AsInteger := TTV_TGFID;
//        execSQL;
//      end
//      else
//        iTTVId := FieldByName('TTV_ID').AsInteger;
//
//      Result := iTTVId;
//    end; // With
  except on E:Exception do
    raise EMODELERROR.Create('SetTailleTrav -> ' + E.Message);
  end;
end;

function TCommandeClass.SetTarPreco(TPO_ARTID: Integer; TPO_DT: TDate;
  TPO_PX: Single; TPO_ETAT: Integer): Integer;
begin
  With StpQuery do
  Try
    Close;
    StoredProcName := 'MSS_SETTARPRECO';
    ParamByName('TPO_ARTID').AsInteger := TPO_ARTID;
    ParamByName('TPO_DT').AsDate       := TPO_DT;
    ParamByName('TPO_PX').AsCurrency   := TPO_PX;
    ParamByName('TPO_ETAT').AsInteger  := TPO_ETAT;
    Open;

    Result := FieldByName('TPO_ID').AsInteger;
    Inc(FArtInscount,FieldByName('FAJOUT').AsInteger);
    Inc(FArtMajCount,FieldByName('FMAJ').AsInteger);

  Except on E:Exception do
    raise EMODELERROR.Create('SetTarPreco -> ' + E.Message);
  end;
end;

function TCommandeClass.SetTarValid(ATVD_TPOID, ATVD_TVTID, ATVD_ARTID,
  ATVD_TGFID, ATVD_COUID: Integer; ATVD_PX: Currency; ATVD_DT: TDate;
  ATVD_ETAT: Integer): Integer;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_SETTARVALID(:PTPOID, :PTVTID, :PARTID, :PTGFID, :PCOUID, :PTVDPX, :PTVDDT, :PTVDETAT)');
    ParamCheck := True;
    ParamByName('PTPOID').AsInteger := ATVD_TPOID;
    ParamByName('PTVTID').AsInteger := ATVD_TVTID;
    ParamByName('PARTID').AsInteger := ATVD_ARTID;
    ParamByName('PTGFID').AsInteger := ATVD_TGFID;
    ParamByName('PCOUID').AsInteger := ATVD_COUID;
    ParamByName('PTVDPX').AsCurrency := ATVD_PX;
    ParamByName('PTVDDT').AsDate     := ATVD_DT;
    ParamByName('PTVDETAT').AsInteger := ATVD_ETAT;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('TVD_ID').AsInteger;
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
    end;
  Except on E:Exception do
    Raise Exception.Create('SetTarValid -> ' + E.Message);
  End;
end;

function TCommandeClass.UpdArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID,
  CLG_COUID: Integer; CLG_PX, CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3,
  CLG_TAXE: Single; CLG_PRINCIPAL, CLG_CENTRALE: integer): Integer;
begin
  Try
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_TACHAT_MAJ';
      ParamCheck := True;
      ParamByName('CLG_ARTID').AsInteger := CLG_ARTID;
      ParamByName('CLG_FOUID').AsInteger := CLG_FOUID;
      ParamByName('CLG_TGFID').AsInteger := CLG_TGFID;
      ParamByName('CLG_COUID').AsInteger := CLG_COUID;
      ParamByName('CLG_PX').AsCurrency := CLG_PX;
      ParamByName('CLG_PXNEGO').AsCurrency := CLG_PXNEGO;
      ParamByName('CLG_PXVI').AsCurrency := CLG_PXVI;
      ParamByName('CLG_RA1').AsCurrency :=  CLG_RA1;
      ParamByName('CLG_RA2').AsCurrency :=  CLG_RA2;
      ParamByName('CLG_RA3').AsCurrency :=  CLG_RA3;
      ParamByName('CLG_TAXE').AsCurrency := CLG_TAXE;
      ParamByName('CLG_PRINCIPAL').AsInteger := CLG_PRINCIPAL;
      ParamByName('CLG_CENTRALE').AsInteger := CLG_CENTRALE;
      Open;

      Result := FieldByName('CLG_ID').AsInteger;
      Inc(FArtMajCount,FieldByName('FMAJ').AsInteger);
    end;
  Except on E:Exception do
    Raise Exception.Create('UpdArtPrixAchat -> ' + E.Message);
  End;

end;

function TCommandeClass.UpdTarValid(ATVD_ID: Integer; ATVD_DT: TDate;
  ATVD_PX: Currency): Integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_UPDTARVALID(:PTVDID, :PTVDDT, :PTVDPX)');
    ParamCheck := True;
    ParamByName('PTVDID').AsInteger := ATVD_ID;
    ParamByName('PTVDDT').AsDate := ATVD_DT;
    ParamByName('PTVDPX').AsCurrency := ATVD_PX;
    Open;

    Inc(FMajCount,FieldByName('FMAJ').AsInteger);
  Except on E:Exception do
    Raise Exception.Create('UpdArtPrixAchat -> ' + E.Message);
  End;
end;

end.
