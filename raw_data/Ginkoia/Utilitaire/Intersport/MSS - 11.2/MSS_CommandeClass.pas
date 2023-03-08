unit MSS_CommandeClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type,
     MSS_SuppliersClass, MSS_BrandsClass, MSS_UniversCriteriaClass, MSS_SizesClass,
     Math, Types, MSS_PeriodsClass, MSS_CollectionsClass, HTTPApp, Windows, StrUtils;

 type
  TArtArticle = record
    ART_ID ,
    ARF_ID ,
    FAjout ,
    FMaj   : Integer;
    Chrono : String;
  end;

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
    FPositionList ,
    FItemList,
    FCatalogList,
    FModelList,
    FColorList,
    FColorItemList    : TMainClass;

    DS_CatalogList ,
    DS_ModelList   ,
    DS_ColorList   : TDatasource;

    FNewArticleList ,
    FNewCmdList,
    FRejectCmdList  : TStringlist;
    FArtInscount, FArtMajCount : Integer;
    FCmdInsCount : Integer;
    FCmdMajCount : Integer;
    FCdsArt: TClientDataSet;
    FTVATable: TIboQuery;
    FMarqueTable: TIboQuery;
    FFournTable: TIboQuery;

    function GetMaxDelivery: TDateTime;
    function GetMinDelivery: TDateTime;
    function GetOrderDate: TDateTime;
  public
    constructor Create;override;
    Destructor Destroy;override;

    procedure Import;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;

    procedure CreateDataSet;

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
                        ART_CODE, ART_FEDAS : String; ART_PXETIQU : Integer) : TArtArticle;

    // Permet de récupérer un CB depuis ART_CB
    function GetNewCB : String;
    // Permet de créer un CB (Retourne le CBI_ID)
    function SetARTCodeBarre(ACBI_ARFID, ACBI_TGFID, ACBI_COUID,ACBI_TYPE : Integer;ACBI_CB : String) : Integer;
    // fonction qui génère les prix d'achat des articles
    function SetArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID : Integer;CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE : Single;CLG_PRINCIPAL : integer) : Integer;
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
               CDL_REMISE1, CDL_REMISE2,CDL_PXACHAT, CDL_TVA, CDL_PXVENTE : Extended; CDL_LIVRAISON : TDateTime; CDL_COLID : Integer) : TLigneStruct;
    // Permet de rechercher les conditions de paiement
    function GetCPAID(AFOU_ID : Integer) : Integer;
    // Création de la relation/Article Taille
    function SetTailleTrav(TTV_ARTID,TTV_TGFID : Integer) : Integer;
    // fonction qui génère les prix de vente des articles
    function SetArtPrixVente(PVT_TVTID,PVT_ARTID,PVT_TGFID : Integer;PVT_PX : single) : Integer;
    // fonction qui génère les prix de vente des articles à la taille / couleur
    function SetArtPrixVente_Tmp(PVT_TVTID,PVT_ARTID,PVT_TGFID, PVT_COUID : Integer;PVT_PX : single) : Integer;
    // fonction de liaison le larticle avec la collection
    function SetArtColArt(ART_ID, COL_ID : integer) : integer;
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
  CreateDataSet;
  FNewArticleList := TStringList.Create;
  FNewCmdList     := TStringList.Create;
  FRejectCmdList  := TStringList.Create;

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
  OrderType, OrderCollection, OrderPeriode, OrderMemo, MemberCode : TFieldCFG;

  // Info Model
  PositionNumber, Code, SizeRange, DeliveryDate, DeliveryEarly, DeliveryLatest,
  PurchasePrice, REBATE1, REBATE2 : TFieldCFG;

  // ItemList
  EAN, ColNo, Columnx,Quantity, Coll : TFieldCFG;
  // Catalog
  {SupplierKey,} CatalogKey, CatalogDenotation : TFieldCFG;

  // Model
  ModelNumber, {BrandNumber,} Denotation, DenotationLong, Fedas, Vat, {SizeRange,}
  RecommendedSalesPrice, ARTID, ARFID : TFieldCFG;

  // color
  ColorNumber, ColorDenotation, COU_ID : TFieldCFG;

  // Item
  {EAN , Columnx, PurchasePrice,} Smu, TDSC, SizeLabel, RetailPrice,
   ARF_ICLID3, ARF_ICLID4 : TFieldCFG;

begin
  // Commun
  OrderNumber.FieldName := 'OrderNumber';
  OrderNumber.FieldType := ftString;
  PositionNumber.FieldName := 'PositionNumber';
  PositionNumber.FieldType := ftInteger;

  SupplierKey.FieldName := 'SupplierKey';
  SupplierKey.FieldType := ftString;

  // Commande Fields
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

  CreateField([SupplierKey, BrandNumber, OrderNumber, OrderDate, OrderDenotation,
  OrderType, OrderCollection, OrderPeriode, OrderMemo, MemberCode]);

  // PositionField
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

  // ItemField
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

  // Catalog
  CatalogKey.FieldName := 'CatalogKey';
  CatalogKey.FieldType := ftString;
  CatalogDenotation.FieldName := 'CatalogDenotation';
  CatalogDenotation.FieldType := ftString;

  FCatalogList.CreateField([SupplierKey, CatalogKey, CatalogDenotation]);

  // Model
  ModelNumber.FieldName := 'ModelNumber';
  ModelNumber.FieldType := ftString;
  Denotation.FieldName  := 'Denotation';
  Denotation.FieldType  := ftString;
  DenotationLong.FieldName := 'DenotationLong';
  DenotationLong.FieldType := ftString;
  Fedas.FieldName := 'FEDAS';
  Fedas.FieldType := ftString;
  Vat.FieldName := 'VAT';
  Vat.FieldType := ftSingle;
  RecommendedSalesPrice.FieldName := 'RecommendedSalesPrice';
  RecommendedSalesPrice.FieldType := ftSingle;
  ARTID.FieldName                 := 'ART_ID';
  ARTID.FieldType                 := ftInteger;
  ARFID.FieldName                 := 'ARF_ID';
  ARFID.FieldType                 := ftInteger;

  FModelList.CreateField([SupplierKey, ModelNumber, BrandNumber, Denotation, DenotationLong, Fedas, Vat, SizeRange,
  RecommendedSalesPrice,ARTID,ARFID]);
  FModelList.ClientDataset.MasterSource := DS_CatalogList;
  FModelList.ClientDataset.MasterFields := 'SupplierKey';

  // color
  ColorNumber.FieldName := 'ColorNumber';
  ColorNumber.FieldType := ftString;
  ColorDenotation.FieldName := 'ColorDenotation';
  ColorDenotation.FieldType := ftString;
  COU_ID.FieldName          := 'COU_ID';
  COU_ID.FieldType          := ftInteger;

  FColorList.CreateField([ModelNumber,ColorNumber, ColorDenotation, COU_ID]);
  FColorList.ClientDataSet.MasterSource := DS_ModelList;
  FColorList.ClientDataSet.MasterFields := 'ModelNumber';

  // Item
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

  FColorItemList.CreateField([ModelNumber, ColorNumber, EAN , Columnx, SizeLabel, PurchasePrice, RetailPrice, Smu, TDSC, ARF_ICLID3, ARF_ICLID4]);
  FColorItemList.ClientDataSet.MasterSource := DS_ColorList;
  FColorItemList.ClientDataSet.MasterFields := 'ModelNumber;ColorNumber';
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

  DS_ModelList.Free;
  DS_ColorList.Free;
  inherited;
end;

function TCommandeClass.DoMajTable(ADoMaj: Boolean): Boolean;
var
  i : Integer;

  cTypeFedas, cGenreFedas : AnsiChar;
  GRE_ID, GREHomme, GREFemme, GREEnfant, GREBaby, GREUnisexe : Integer;

  FOU_ID, MRK_ID, FMK_ID, SSF_ID, GTF_ID : Integer;
  CLA_ID3, CLA_ID4, CLA_ID5 : Integer;
  ICL_ID3, ICL_ID4, ICL_ID5 : Integer;
  TVA_ID, COU_ID, TGF_ID, CBI_ID, CLG_ID, TCT_ID : Integer;
  CDE_ID, TYP_ID, EXE_ID, CDL_ID, USR_ID, COL_ID, CPA_ID : Integer;
  CBI_CB, ModelNumber : String;
  CDL_COLID : Integer;

  MinDate : TDateTime;

  bFound : Boolean;
  iFound : Integer;

  Suppliers : TSuppliers;
  Brands : TBrands;
  Univers : TUniversCriteria;
  Sizes : TSizes;
  Periods : TPeriods;
  PeriodsLib : String;
  Collections : TCollections;
  CollectionLib :String;

  Article : TArtArticle;
  Commande : TCmdStruct;
  bContinue : Boolean;
  LigneCmd : TLigneStruct;

  Begintime, endtime,TickPerSec : int64;
  iTmp, iTmp2, iTmp3 : Int64;
begin

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
  end;

  // récupération des codes de classement
//  CLA_ID3 := SetArtClassement('TDSC','ART',3);
//  CLA_ID4 := SetArtClassement('SMU','ART',4);
//  CLA_ID5 := SetArtClassement('Catalog. INTERSPORT','ART',5);
  // Récupération des code genre
//  GetGenParam(12,15,GREHomme);
//  GetGenParam(12,16,GREFemme);
//  GetGenParam(12,17,GREEnfant);
//  GetGenParam(12,19,GREBaby);
//  GetGenParam(12,18,GREUnisexe);
  // Type comptable
  GetGenParam(12,3,TCT_ID);
{$ENDREGION}

  try
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
//      QueryPerformanceCounter(BeginTime);
      if FournTable.Locate('FOU_CODE',FCatalogList.FieldByName('SupplierKey').AsString,[]) then
      begin
        FOU_ID := FournTable.FieldByName('FOU_ID').AsInteger;
//        QueryPerformanceCounter(EndTime);
//        QueryPerformanceFrequency(TickPerSec);
//        iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//        FErrLogs.Add(Format('Fournisseur : Rech Int %d',[iTmp]));
      end
      else begin
        FOU_ID := Suppliers.GetSuppliers(FCatalogList.FieldByName('SupplierKey').AsString);
//        QueryPerformanceCounter(EndTime);
//        QueryPerformanceFrequency(TickPerSec);
//        iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//        FErrLogs.Add(Format('Fournisseur : Rech Base %d',[iTmp]));
      end;
      {$ENDREGION}

      FModelList.First;
      while not FModelList.Eof do
      begin
        // Dans le cas où l''on a plusieurs noeuds dans CatalogList
        if FCatalogList.FieldByName('SupplierKey').AsString = FModelList.FieldByName('SupplierKey').AsString then
        begin
//          QueryPerformanceCounter(BeginTime);
          {$REGION 'Recherche du brands (Marque)'}
          if Brands.ClientDataSet.Locate('CodeMarque',FModelList.FieldByName('BrandNumber').AsString,[loCaseInsensitive]) then
          begin
//            QueryPerformanceCounter(EndTime);
//            QueryPerformanceFrequency(TickPerSec);
//            iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//            iTmp2 := -1;
//            iTmp3 := -1;

            MRK_ID := Brands.FieldByName('MRK_ID').AsInteger;
            if MRK_ID <= 0 then
            begin
//              QueryPerformanceCounter(BeginTime);
              if FMarqueTable.Locate('MRK_CODE',FModelList.FieldByName('BrandNumber').AsString,[]) then
              begin
                MRK_ID := FMarqueTable.FieldByName('MRK_ID').AsInteger;
//                QueryPerformanceCounter(EndTime);
//                QueryPerformanceFrequency(TickPerSec);
//                iTmp2 := Round((EndTime - BeginTime) / TickPerSec * 1000);
              end
              else begin
                MRK_ID := Brands.GetBrands;
//                QueryPerformanceCounter(EndTime);
//                QueryPerformanceFrequency(TickPerSec);
//                iTmp3 := Round((EndTime - BeginTime) / TickPerSec * 1000);
              end;
            end;
          end
          else
            raise Exception.Create('BrandNumber inéxistant : ' + FModelList.FieldByName('BrandNumber').AsString);
          {$ENDREGION}
//          FErrLogs.Add(Format('Marque : %d / %d , Rech Base %d',[iTmp,iTmp2,iTmp3]));

          {$REGION 'Traitement de la liaison de la marque avec le fournisseur'}
//          QueryPerformanceCounter(BeginTime);
          FMK_ID := SetMrkFourn(FOU_ID,MRK_ID);
//          QueryPerformanceCounter(EndTime);
//          QueryPerformanceFrequency(TickPerSec);
//          iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//          FErrLogs.Add(Format('SetMrkFourn : %d',[iTmp]));
          {$ENDREGION}

          {$REGION 'Recherche de la sousfamille via la FEDAS'}
//          SSF_ID := IsInGenImport(CIMPNUM_FEDAS,FModelList.ClientDataSet.FieldByName('FEDAS').AsString);
//          if SSF_ID = -1 then
//          begin
            // recherche par l'universcritéria
//            QueryPerformanceCounter(BeginTime);
            if Univers.Fedas.ClientDataSet.Locate('Aggregationlevelfourigiic',FModelList.FieldByName('FEDAS').AsString,[loCaseInsensitive]) then
            begin
              With Univers.Fedas.ClientDataSet do
                if Univers.NKLSSfamille.ClientDataSet.Locate('LVL1ID;LVL2ID;LVL3ID;Aggregationlevelfourid',
                   VarArrayOf([FieldByName('LVL1ID').AsString,FieldByName('LVL2ID').AsString,
                               FieldByName('LVL3ID').AsString,FieldByName('LVL4ID').AsString]),[loCaseInsensitive]) then
                begin
//                  QueryPerformanceCounter(EndTime);
//                  QueryPerformanceFrequency(TickPerSec);
//                  iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                  iTmp2 := -1;
//                  iTmp3 := -1;

//                  QueryPerformanceCounter(BeginTime);
                  SSF_ID := Univers.NKLSSFamille.FieldByName('SSF_ID').AsInteger;
                  if SSF_ID <= 0 then
                  begin
                    // repositionnement des autres clientdataset
//                    QueryPerformanceCounter(BeginTime);
                    Univers.NKLFamille.ClientDataSet.Locate('LVL1ID;LVL2ID;Aggregationlevelthreeid',
                                       VarArrayOf([FieldByName('LVL1ID').AsString,FieldByName('LVL2ID').AsString,
                                                   FieldByName('LVL3ID').AsString]),[loCaseInsensitive]);

                    Univers.NKLRayon.ClientDataSet.Locate('LVL1ID;Aggregationleveltwoid',
                                       VarArrayOf([FieldByName('LVL1ID').AsString,FieldByName('LVL2ID').AsString]),[loCaseInsensitive]);

                    Univers.NKLSecteur.ClientDataSet.Locate('Aggregationleveloneid',FieldByName('LVL1ID').AsString,[loCaseInsensitive]);
//                    QueryPerformanceCounter(EndTime);
//                    QueryPerformanceFrequency(TickPerSec);
//                    iTmp2 := Round((EndTime - BeginTime) / TickPerSec * 1000);

//                    QueryPerformanceCounter(BeginTime);
                    SSF_ID := Univers.GetSSFamille;
                    if SSF_ID = -1 then
                      raise Exception.Create('Code Fedas non attribué : ' + FModelList.FieldByName('FEDAS').AsString);
//                    QueryPerformanceCounter(EndTime);
//                    QueryPerformanceFrequency(TickPerSec);
//                    iTmp3 := Round((EndTime - BeginTime) / TickPerSec * 1000);
                  end; // if
//                  FErrLogs.Add(Format('Recherche SSF FEDAS : Rech Int %d / %d - Rech Base %d',[iTmp, iTmp2, iTmp3]));

                end;  // if
            end; // if
//          end; // if
          {$ENDREGION}

          {$REGION 'Récupération du genre de l''article'}
          GRE_ID := 0; // on ne gere pas le genre
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
//          GTF_ID := Sizes.PLXGTF.IsInGenImport(CIMPNUM,FModelList.ClientDataSet.FieldByName('SizeRange').AsString);
//          if GTF_ID = -1 then
//          begin
            // récupération dans les tables en mémoire
//            QueryPerformanceCounter(BeginTime);
            if Sizes.PLXGTF.ClientDataSet.Locate('ID',FModelList.FieldByName('SizeRange').AsString,[loCaseInsensitive]) then
            begin
//            QueryPerformanceCounter(EndTime);
//            QueryPerformanceFrequency(TickPerSec);
//            iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//            iTmp2 := -1;
//            iTmp3 := -1;

              GTF_ID := Sizes.PLXGTF.FieldByName('GTF_ID').AsInteger;
              if GTF_ID <= 0 then
              begin
//                QueryPerformanceCounter(BeginTime);
                // positionnement de l'enregistrement
                Sizes.PLXTYPEGT.ClientDataSet.Locate('ID',Sizes.PLXGTF.FieldByName('MSRID').AsString,[loCaseInsensitive]);
//                QueryPerformanceCounter(EndTime);
//                QueryPerformanceFrequency(TickPerSec);
//                iTmp2 := Round((EndTime - BeginTime) / TickPerSec * 1000);

//                QueryPerformanceCounter(BeginTime);
                GTF_ID := Sizes.GetSubRange;
//                QueryPerformanceCounter(EndTime);
//                QueryPerformanceFrequency(TickPerSec);
//                iTmp3 := Round((EndTime - BeginTime) / TickPerSec * 1000);
                if GTF_ID = -1 then
                  raise Exception.Create('Sizerange inéxistant : ' + FModelList.FieldByName('SizeRange').AsString);
              end;
            end
            else
              raise Exception.Create('Sizerange inéxistant : ' + FModelList.FieldByName('SizeRange').AsString);
//            FErrLogs.Add(Format('Grille de taille : Rech Int -> %d / %d - Rech Base %d',[iTmp,iTmp2,iTmp3]));
//          end; //if
          {$ENDREGION}

          {$REGION 'Récupération de la TVA'}
//          QueryPerformanceCounter(BeginTime);
          TVA_ID := GetTVAId(FModelList.FieldByName('VAT').AsSingle,'');
//          QueryPerformanceCounter(EndTime);
//          QueryPerformanceFrequency(TickPerSec);
//          iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//          FErrLogs.Add(Format('TVA : %d',[iTmp]));
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
          Article := SetArticle(
            FModelList.FieldByName('MODELNUMBER').AsString, // ART_REFMRK
            MRK_ID, // ART_MRKID,
            GRE_ID, // ART_GREID: INTEGER;
            FModelList.FieldByName('DENOTATION').AsString, // ART_NOM,
            FModelList.FieldByName('DENOTATIONLONG').AsString, // ART_DESCRIPTION,
            FModelList.FieldByName('FEDAS').AsString, // ART_COMMENT5: String;
            SSF_ID, // ART_SSFID,
            GTF_ID, // ART_GTFID,
            0, // ART_GARID,
            TVA_ID, // ARF_TVAID,
            0,//FColorItemList.FieldByName('ARF_ICLID3').AsInteger, //ARF_ICLID3,
            0, //FColorItemList.FieldByName('ARF_ICLID4' ).AsInteger, //ARF_ICLID4,
            ICL_ID5, // ARF_ICLID5,
            0, // ARF_CATID,
            TCT_ID, // ARF_TCTID: INTEGER
            FModelList.FieldByName('MODELNUMBER').AsString + FModelList.FieldByName('BRANDNUMBER').AsString, // ART_CODE
            FModelList.FieldByName('FEDAS').AsString, // ART_FEDAS
            0 // ART_PXETIQU
          );
//          QueryPerformanceCounter(EndTime);
//          QueryPerformanceFrequency(TickPerSec);
//          iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//          FErrLogs.Add(Format('Article %s : %d',[Article.Chrono, iTmp]));
          {$ENDREGION}

          FColorList.First;
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
//                  QueryPerformanceCounter(BeginTime);
                  {$REGION 'récupération de la taille'}
                  if Sizes.PLXGTF.ClientDataSet.Locate('ID',FModelList.FieldByName('SizeRange').AsString,[loCaseInsensitive]) then
                  begin
                    if Sizes.PLXTYPEGT.ClientDataSet.Locate('ID',Sizes.PLXGTF.FieldByName('MSRID').AsString,[loCaseInsensitive]) then
                    begin
                      if Sizes.PLXTAILLESGF.ClientDataSet.Locate('SRID;Columnx',VarArrayof([FModelList.FieldByName('SizeRange').AsString,FColorItemList.FieldByName('Columnx').AsString]),[loCaseInsensitive]) then
                      begin
                        TGF_ID := Sizes.PLXTAILLESGF.FieldByName('TGF_ID').AsInteger;
//                        QueryPerformanceCounter(EndTime);
//                        QueryPerformanceFrequency(TickPerSec);
//                        iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                        iTmp2 := -1;
                        if TGF_ID <= 0 then
                        begin
//                          TGF_ID := Sizes.IsInGenImport(CIMPNUM,Sizes.PLXTAILLESGF.FieldByName('Idx').AsString);
//                          if TGF_ID = -1 then
//                          begin
//                            QueryPerformanceCounter(BeginTime);
                            TGF_ID := Sizes.GetSizes;
//                            QueryPerformanceCounter(EndTime);
//                            QueryPerformanceFrequency(TickPerSec);
//                            iTmp2 := Round((EndTime - BeginTime) / TickPerSec * 1000);
                            if TGF_ID = -1 then
                              raise Exception.Create('Taille inéxistante : ' +
                                                     FColorItemList.FieldByName('ColumnX').AsString + ' - ' +
                                                     FColorItemList.FieldByName('SizeLabel').AsString);
                        //  end;
                        end;
                      end
                      else
                        raise Exception.Create('Taille inéxistante : ' + FColorItemList.FieldByName('ColumnX').AsString + ' - ' +
                                                                     FColorItemList.FieldByName('SizeLabel').AsString);
                    end;
                  end;
                  {$ENDREGION}
//                  FErrLogs.Add(Format('Taille : Int %d / Base %d',[iTmp, iTmp2]));

                  // Gestion de la relation Taille/Article
                  if Article.FAjout > 1 then
                  begin
//                    QueryPerformanceCounter(BeginTime);
                    SetTailleTrav(Article.ART_ID,TGF_ID);
//                    QueryPerformanceCounter(EndTime);
//                    QueryPerformanceFrequency(TickPerSec);
//                    iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                    FErrLogs.Add(Format('SetTailleTrav : %d',[iTmp]));
                  end;

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
//                  iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                  FErrLogs.Add(Format('Couleur : %d',[iTmp]));
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
//                  iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                  FErrLogs.Add(Format('CB : %d',[iTmp]));
                  {$ENDREGION}

//                  QueryPerformanceCounter(BeginTime);
                  {$REGION 'Gestion des Tarifs'}
                  if Article.FAjout > 0 then
                  begin
                    CLG_ID := SetArtPrixAchat(Article.ART_ID,FOU_ID,0,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,0,0,0,0,1);
                    SetArtPrixVente(0,Article.ART_ID,0,FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency);
                  end;
                  CLG_ID := SetArtPrixAchat(Article.ART_ID,FOU_ID,TGF_ID,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,0,0,0,0,1);
                  SetArtPrixVente(0,Article.ART_ID,TGF_ID,FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency);

                  // Gestion des tarif à la taille / couleur
                  SetArtPrixAchat_Tmp(Article.ART_ID,FOU_ID,TGF_ID,COU_ID,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,FColorItemList.FieldByName('PURCHASEPRICE').AsCurrency,FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency);
                  SetArtPrixVente_Tmp(0,Article.ART_ID,TGF_ID,COU_ID,FModelList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency);
                  // TODO a faire prix de vente
                  {$ENDREGION}
//                  QueryPerformanceCounter(EndTime);
//                  QueryPerformanceFrequency(TickPerSec);
//                  iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                  FErrLogs.Add(Format('Tarifs : %d',[iTmp]));

                  // Génération du logs pour le mail
                  if Article.FAjout > 0 then
                  begin
                    FNewArticleList.Add('<tr>');
                    FNewArticleList.Add('<td id="Lgn100px">' + Article.Chrono + '</td>');
                    FNewArticleList.Add('<td id="LgnArtNom">' + HTMLEncode(FModelList.FieldByName('DENOTATION').AsString) + '</td>');
                    FNewArticleList.Add('</tr>');
                  end;
                end; // if MODELNUMBER
                FColorItemList.Next;
              end; // while

              {$REGION 'Vérification et création des codes barres des tailles/couleurs manquante de type 1'}
              With FIboQuery do
              begin
                Close;
                SQL.Clear;
                SQL.Add('Select TTV_TGFID from PLXTAILLESTRAV');
                SQL.Add('  Join K on K_ID = TTV_ID and K_Enabled = 1');
                SQL.Add('Where TTV_ARTID = :PARTID');
                ParamCheck := True;
                ParamByName('PARTID').AsInteger := Article.ART_ID;
                Open;

                if RecordCount > 0 then
                begin
                  while not EOF do
                  begin
                    SetARTCodeBarre(Article.ARF_ID,FieldByName('TTV_TGFID').AsInteger,COU_ID,1,'-1');
                    Next;
                  end;
                end;
              end;
              {$ENDREGION}

            end; // if MODELNUMBER
            FColorList.Next;
          end; //while
        end; // if
        FModelList.Next;
      end; // WHILE
      FCatalogList.Next;
    end;

    //-----------------------
    // Création des commandes
    //-----------------------
    SetLength(TVALignes,5);
    FCds.First;
    while not FCDS.Eof do
    begin
      // Récupération du fournisseur
      FOU_ID := Suppliers.GetSuppliers(FCds.FieldByName('SupplierKey').AsString);

      {$REGION 'Calcul du tableau de TVA + Récupération de la date de livraison (MinDate)'}
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
                      CDE_TVAHT := CDE_TVAHT + FitemList.FieldByName('PURCHASEPRICE').AsCurrency * FitemList.FieldByName('Quantity').AsCurrency;
                      CDE_TVA   := CDE_TVA + (FitemList.FieldByName('PURCHASEPRICE').AsCurrency * FitemList.FieldByName('Quantity').AsCurrency) * CDE_TVATAUX / 100;
                    end; // with
                  end else
                  begin
                    bFound := False;
                    for i := 0 to Length(TVALignes) do
                      if not bFound and (TVALignes[i].CDE_TVATAUX = 0)  then
                      begin
                        With TVALignes[iFound] do
                        begin
                          CDE_TVATAUX := FModelList.FieldByName('VAT').AsCurrency;
                          CDE_TVAHT := FitemList.FieldByName('PURCHASEPRICE').AsCurrency * FitemList.FieldByName('Quantity').AsCurrency;
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
      GetGenParam(12,8,FMAGID, USR_ID);

      // Récupération des CDV
      // TODO:
//      if FCDs.FieldByName('ORDERTYPE').AsString = '' then
        TYP_ID  := GetGenTypCDV(1,101);
//      else
//        TYP_ID := SetGenTypCDV
      {$REGION 'Récupération de le collection de la commande'}
      if Trim(FCds.FieldByName('OrderCollection').AsString) = '' then
      begin
        // Si vide on cherche une collection se rapprochant via la date.
        Try
          COL_ID := Collections.GetCollection(FCds.FieldByName('ORDERDATE').AsDateTime);
          CollectionLib := Collections.FieldByName('Denotation').AsString;
        Except on E:Exception do
          begin
            // La collection n'a pas été trouvé alors on prend la collection par défaut configurer dans ginkoia
            GetGenParam(2,24,COL_ID,False);
            With FIboQuery do
            begin
              Close;
              SQL.Clear;
              SQL.Add('Select COL_NOM from ARTCOLLECTION');
              SQL.Add('Where COL_ID = :PCOLID');
              ParamCheck := True;
              ParamByName('PCOLID').AsInteger := COL_ID;
              Open;
              CollectionLib := FieldByName('COL_NOM').AsString;
            end;
          end;
        End;
      end
      else begin
        if Collections.ClientDataSet.Locate('Code',FCds.FieldByName('OrderCollection').AsString,[loCaseInsensitive]) then
        begin
          COL_ID := Collections.FieldByName('COL_ID').AsInteger;
          if COL_ID <= 0 then
            COL_ID := Collections.GetCollectionID;
          CollectionLib := Collections.FieldByName('Denotation').AsString
        end
        else begin
          Try
            COL_ID := Collections.GetCollection(FCds.FieldByName('ORDERDATE').AsDateTime);
            CollectionLib := Collections.FieldByName('Denotation').AsString;
          Except on E:Exception do
            begin
              // La collection n'a pas été trouvé alors on prend la collection par défaut configurer dans ginkoia
              GetGenParam(2,24,COL_ID,False);
              With FIboQuery do
              begin
                Close;
                SQL.Clear;
                SQL.Add('Select COL_NOM from ARTCOLLECTION');
                SQL.Add('Where COL_ID = :PCOLID');
                ParamCheck := True;
                ParamByName('PCOLID').AsInteger := COL_ID;
                Open;
                CollectionLib := FieldByName('COL_NOM').AsString;
              end;
            end;
          End;
        end;
      end;
      {$ENDREGION}


      // Recherche des conditions de paiement
      CPA_ID := GetCPAID(FOU_ID);

      // Exercice
      if trim(FCds.FieldByName('ORDERPERIODE').AsString) <> '' then
      begin
        EXE_ID := Periods.GetPeriods(FCds.FieldByName('ORDERPERIODE').AsDateTime);
        PeriodsLib := FCds.FieldByName('ORDERPERIODE').AsString;
      end
      else begin
        EXE_ID := Periods.GetPeriods(MinDate);
        PeriodsLib := Periods.FieldByName('Year').AsString
      end;
      if EXE_ID <= 0 then
      begin
        GetGenParam(12,4,EXE_ID);
        With FIboQuery do
        Begin
          Close;
          SQL.Clear;
          SQL.Add('Select EXE_NOM from GENEXERCICECOMMERCIAL');
          SQL.Add('Where EXE_ID = :PEXEID');
          ParamCheck := True;
          ParamByName('PEXEID').AsInteger := EXE_ID;
          Open;
          PeriodsLib := FieldByName('EXE_NOM').AsString;
        End;
      end;

//      if IsInGenImport(CIMPNUM,Fcds.FieldByName('ORDERNUMBER').AsString) = -1 then
//      begin
        // Création de l'entete de la commande
//        QueryPerformanceCounter(BeginTime);
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
//        QueryPerformanceCounter(EndTime);
//        QueryPerformanceFrequency(TickPerSec);
//        iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//        FErrLogs.Add(Format('Entete : %d',[iTmp]));

        {$REGION 'Création des lignes de la commande'}
        FPositionList.First;
        // On ajoute les lignes que si l'entête de commande est différent de -1
        // si -1 c'est que la commande est déjà en réception
        if Commande.CDE_ID <> -1 then
        begin
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
                  if Sizes.PLXGTF.ClientDataSet.Locate('ID',FPositionList.FieldByName('SizeRange').AsString,[loCaseInsensitive]) then
                    // positionnement des deux autres dataset
                    if Sizes.PLXTYPEGT.ClientDataSet.Locate('ID',Sizes.PLXGTF.FieldByName('MSRID').AsString,[loCaseInsensitive]) then
                      if Sizes.PLXTAILLESGF.ClientDataSet.Locate('SRID;Columnx',VarArrayOf([Sizes.PLXGTF.FieldByName('ID').AsString,FItemList.FieldByName('Columnx').AsString]),[loCaseInsensitive]) then
                        TGF_ID := Sizes.GetSizes;

//                  if FModelList.ClientDataSet.Locate('MODELNUMBER',ModelNumber,[loCaseInsensitive]) then
//                  begin
//                    if FColorList.ClientDataSet.Locate('ModelNumber;ColorNumber',VarArrayOf([ModelNumber,FItemList.FieldByName('ColNo').AsString]),[loCaseInsensitive]) then
//                    begin
//                      if FColorItemList.ClientDataSet.Locate('ModelNumber;ColorNumber;Columnx',VarArrayOf([ModelNumber,FItemList.FieldByName('ColNo').AsString,FItemList.FieldByName('Columnx').AsString]),[loCaseInsensitive]) then
//                      begin
//                        // Récupération de la collection de la ligne
//                        CDL_COLID := COL_ID;
//                        if Trim(FItemList.FieldByName('COLL').AsString) <> '' then
//                        begin
//                          if Collections.ClientDataSet.Locate('Code',FItemList.FieldByName('COLL').AsString,[loCaseInsensitive]) then
//                          begin
//                            CDL_COLID := Collections.FieldByName('COL_ID').AsInteger;
//                            if CDL_COLID <= 0 then
//                              CDL_COLID := Collections.GetCollectionID;
//                            CollectionLib := Collections.FieldByName('Denotation').AsString
//                          end;
//                        end;
                  bContinue := True;
                  if FModelList.FieldByName('MODELNUMBER').AsString <> ModelNumber then
                    bContinue := FModelList.ClientDataSet.Locate('MODELNUMBER',ModelNumber,[loCaseInsensitive]);

                  if bContinue then
                    if (FColorList.FieldByName('ModelNumber').AsString <> ModelNumber) or
                       (FColorList.FieldByName('ColorNumber').AsString <> FItemList.FieldByName('ColNo').AsString) then
                      bContinue := FColorList.ClientDataSet.Locate('ModelNumber;ColorNumber',VarArrayOf([ModelNumber,FItemList.FieldByName('ColNo').AsString]),[loCaseInsensitive]);

//                    if FColorList.ClientDataSet.Locate('ModelNumber;ColorNumber',VarArrayOf([ModelNumber,FItemList.FieldByName('ColNo').AsString]),[loCaseInsensitive]) then
//                    begin
                  if bContinue then
                    if (FColorItemList.FieldByName('ModelNumber').AsString <> ModelNumber) or
                       (FColorItemList.FieldByName('ColorNumber').AsString <> FItemList.FieldByName('ColNo').AsString) or
                       (FColorItemList.FieldByName('Columnx').AsString <> FItemList.FieldByName('Columnx').AsString) then
                    begin
                         bContinue := FColorItemList.ClientDataSet.Locate('ModelNumber;ColorNumber;Columnx',VarArrayOf([ModelNumber,FItemList.FieldByName('ColNo').AsString,FItemList.FieldByName('Columnx').AsString]),[loCaseInsensitive]);
                        // Récupération de la collection de la ligne
                        CDL_COLID := COL_ID;
                        if Trim(FItemList.FieldByName('COLL').AsString) <> '' then
                        begin
                          if Collections.FieldByName('Code').AsString <> FItemList.FieldByName('COLL').AsString then
                            if Collections.ClientDataSet.Locate('Code',FItemList.FieldByName('COLL').AsString,[loCaseInsensitive]) then
                            begin
                              CDL_COLID := Collections.FieldByName('COL_ID').AsInteger;
                              if CDL_COLID <= 0 then
                                CDL_COLID := Collections.GetCollectionID;
                              CollectionLib := Collections.FieldByName('Denotation').AsString
                            end;
                        end;
                    end;

                    if bContinue then
                    begin
                        // création de la ligne de commande
//                        QueryPerformanceCounter(BeginTime);
                        LigneCmd := SetCOMCDEL(Commande.CDE_ID, // CDL_CDEID,
                                       FModelList.FieldByName('ART_ID').AsInteger, // CDL_ARTID,
                                       TGF_ID, // CDL_TGFID,
                                       FColorList.FieldByName('COU_ID').AsInteger, // CDL_COUID: Integer;
                                       FItemList.FieldByName('Quantity').AsInteger, // CDL_QTE,
                                       FItemList.FieldByName('PURCHASEPRICE').AsCurrency, // CDL_PXCTLG, // FPositionList
                                       FPositionList.FieldByName('REBATE1').AsCurrency, // CDL_REMISE1,
                                       FPositionList.FieldByName('REBATE2').AsCurrency, // CDL_REMISE2,
                                       FItemList.FieldByName('PURCHASEPRICE').AsCurrency, // CDL_PXACHAT,  // FColorItemList
                                       FModelList.FieldByName('VAT').AsCurrency, // CDL_TVA,
                                       FColorItemList.FieldByName('RETAILPRICE').AsCurrency, // CDL_PXVENTE: Extended;
                                       FPositionList.FieldByName('DELIVERYDATE').AsDateTime, //CDL_LIVRAISON: TDateTime
                                       CDL_COLID // CDL_COLID : Integer
                                      );
//                        QueryPerformanceCounter(EndTime);
//                        QueryPerformanceFrequency(TickPerSec);
//                        iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                        FErrLogs.Add(Format('Ligne : %d',[iTmp]));

                        // Génération des informations pour le mail
                        if Commande.FAjout = 0 then
                        begin
                          if (LigneCmd.FAJOUT = 1) or (LigneCmd.FMAJ = 1) then
                          begin
                            FRejectCmdList.Add('<tr>');
                            FRejectCmdList.Add('<td id="Lgn100px">' + Fcds.FieldByName('ORDERNUMBER').AsString + '</td>');
                            FRejectCmdList.Add('<td id="Lgn100px">' + Commande.Chrono + '</td>');
                            FRejectCmdList.Add('<td id="Lgn100px">' + FColorList.FieldByName('ModelNumber').AsString + '</td>');
                            if LigneCmd.FAJOUT = 1 then
                              FRejectCmdList.Add('<td id="LgnFourn">Nouvelle ligne</td>');
                            if LigneCmd.FMAJ = 1 then
                              FRejectCmdList.Add('<td id="LgnFourn">Ligne modifiée</td>');
                            FRejectCmdList.Add('</tr>');
                          end;
                        end;
                        // Liaison de la collection avec l'article
                        SetArtColArt(FModelList.FieldByName('ART_ID').AsInteger,CDL_COLID);
                        // Mise de la taille en taille travaillé pour l'article
                        SetTailleTrav(FModelList.FieldByName('ART_ID').AsInteger,TGF_ID);
                      end;
                    end;
//                     end; // if
//                  end; // if
//                end; // if
                FItemList.Next;
              end; // while
            end; // if
            FPositionList.Next;
          end; //while Fpos
//        end
//        else begin
//          FRejectCmdList.Add('<tr>');
//          FRejectCmdList.Add('<td id="Lgn100px">' + Fcds.FieldByName('ORDERNUMBER').AsString + '</td>');
//          FRejectCmdList.Add('<td id="Lgn100px">' + Commande.Chrono + '</td>');
//          FRejectCmdList.Add('<td id="Lgn100px">' + HTMLEncode(Suppliers.FieldByName('Denotation').AsString) + '</td>');
//          FRejectCmdList.Add('<td id="LgnFourn">Commande déjà en réception, modification impossible</td>');
//          FRejectCmdList.Add('</tr>');
        end;
        {$ENDREGION}

        // Génération pour le mail
        if (Commande.Fajout = 1) and (Commande.CDE_ID <> -1) then
        begin
          FNewCmdList.Add('<tr>');
          FNewCmdList.Add('<td id="Lgn100px">' + Fcds.FieldByName('ORDERNUMBER').AsString + '</td>');
          FNewCmdList.Add('<td id="Lgn100px">' + Commande.Chrono + '</td>');
          FNewCmdList.Add('<td id="Lgn100px">' + FormatFloat('0.00',(TVALignes[0].CDE_TVAHT + TVALignes[1].CDE_TVAHT + TVALignes[2].CDE_TVAHT + TVALignes[3].CDE_TVAHT + TVALignes[4].CDE_TVAHT)) + '</td>');
          FNewCmdList.Add('<td id="LgnFourn">' + HTMLEncode(Suppliers.FieldByName('Denotation').AsString) + '</td>');
          FNewCmdList.Add('<td id="Lgn100px">' + HTMLEncode(PeriodsLib) + '</td>');
          FNewCmdList.Add('<td id="Lgn200px">' + HTMLEncode(CollectionLib) + '</td>');
          FNewCmdList.Add('</tr>');
        end;

//      end; // isingenimport

      FCds.Next;
    end;

  Except on E:Exception do
    FErrLogs.Add(FTitle + ' : ' + E.Message);
  end;
end;

function TCommandeClass.GetCPAID(AFOU_ID: Integer): Integer;
begin
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select FOD_CPAID from ARTFOURNDETAIL');
    SQL.Add('  join ARTFOURN on FOU_ID = FOD_FOUID');
    SQL.Add('  join K on K_ID = FOD_ID and K_Enabled = 1');
    SQL.Add('Where FOU_ID = :PFOUID');
    ParamCheck := True;
    ParamByName('PFOUID').AsInteger := AFOU_ID;
    Open;

    Result := FieldbyName('FOD_CPAID').AsInteger;
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
  eModelListNode,
  eModelMode,
  eColorListNode,
  eColorNode : IXMLNode;

  bValid : Boolean;

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

          eOrderHeaderNode := eOrderNode.ChildNodes.FindNode('ORDERHEADER');
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
            Post;
          end;

          if FCODEMAG = '' then
          begin
            FCODEMAG := XmlStrToStr(eOrderHeaderNode.ChildValues['BRANCHNUMBER']);
            if Trim(FCODEMAG) = '' then
              FCODEMAG := LeftStr(FTitle,Pos('_',FTitle) -1);
          end;

          ePositionListNode := eOrderNode.ChildNodes.FindNode('POSITIONLIST');
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

              eItemListNode := ePositionNode.ChildNodes.FindNode('ITEMLIST');
              while eItemListNode <> nil do
              begin
                eItemNode := eItemListNode.ChildNodes['ITEM'];
                while eItemNode <> nil do
                begin
                  eItemItemAddNode := eItemNode.ChildNodes.FindNode('ITEMADDTIONAL');
                  eItemAddNode := nil;
                  if eItemItemAddNode <> nil then
                    eItemAddNode := eItemItemAddNode.ChildNodes.FindNode('ADDITIONAL');

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
      while eCatalogListNode <> nil do
      begin
        eCatalogNode := eCatalogListNode.ChildNodes['CATALOG'];
        while eCatalogNode <> nil do
        begin
           With FCatalogList.ClientDataSet do
           begin
             Append;
             FieldByName('SupplierKey').AsString       := XmlStrToStr(eCatalogNode.ChildValues['SUPPLIERKEY']);
             FieldByName('CatalogKey').AsString        := XmlStrToStr(eCatalogNode.ChildValues['CATALOGKEY']);
             FieldByName('CatalogDenotation').AsString := XmlStrToStr(eCatalogNode.ChildValues['CATALOGDENOTATION']);
             Post;
           end;

           eModelListNode := eCatalogNode.ChildNodes.FindNode('MODELLIST');
           while eModelListNode <> nil do
           begin
             eModelMode := eModelListNode.ChildNodes['MODEL'];
             while eModelMode <> nil do
             begin
               With FModelList.ClientDataSet do
               begin
                 Append;
                 FieldByName('SupplierKey').AsString             := XmlStrToStr(eCatalogNode.ChildValues['SUPPLIERKEY']);
                 FieldByName('ModelNumber').AsString             := XmlStrToStr(eModelMode.ChildValues['MODELNUMBER']);
                 FieldByName('BrandNumber').AsString             := XmlStrToStr(eModelMode.ChildValues['BRANDNUMBER']);
                 FieldByName('Denotation').AsString              := XmlStrToStr(eModelMode.ChildValues['DENOTATION']);
                 FieldByName('DenotationLong').AsString          := XmlStrToStr(eModelMode.ChildValues['DENOTATIONLONG']);
                 FieldByName('Fedas').AsString                   := XmlStrToStr(eModelMode.ChildValues['FEDAS']);
                 FieldByName('Vat').AsExtended                   := XmlStrToFloat(eModelMode.ChildValues['VAT']);
                 FieldByName('SizeRange').AsString               := XmlStrToStr(eModelMode.ChildValues['SIZERANGE']);
                 FieldByName('RecommendedSalesPrice').AsExtended := XmlStrToFloat(eModelMode.ChildValues['RECOMMENDEDSALESPRICE']);
                 Post;
               end;

               eColorListNode := eModelMode.ChildNodes.FindNode('COLORLIST');
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
                     Post;
                   end;

                   eItemListNode := eColorNode.ChildNodes.FindNode('ITEMLIST');
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
        eCatalogListNode := eCatalogListNode.NextSibling;
      end; // while eCatalogListNode

//    Except on E:Exception do
//      raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
//    end;
    finally //on E:Exception do
      //raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
      Xml := Nil;
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
  With FStpQuery do
  try
    Close;
    StoredProcName := 'MSS_SETARTCODEBARRE';
    ParamCheck := True;
    ParamByName('CBIARFID').AsInteger := ACBI_ARFID;
    ParamByName('CBITGFID').AsInteger := ACBI_TGFID;
    ParamByName('CBICOUID').AsInteger := ACBI_COUID;
    ParamByName('CBITYPE').AsInteger  := ACBI_TYPE;
    ParamByName('CBICB').AsString     := ACBI_CB;
    Open;

    Result := FieldByName('CBI_ID').AsInteger;

  Except on E:Exception Do
    raise Exception.Create('SetARTCodeBarre -> ' + E.Message);
  end;
end;

function TCommandeClass.SetArtColArt(ART_ID, COL_ID: integer): integer;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select CAR_ID from ARTCOLART');
    SQL.Add('  join K on K_ID = CAR_ID and K_enabled = 1');
    SQL.Add('Where CAR_ARTID = :PARTID');
    SQL.Add('  and CAR_COLID = :PCOLID');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := ART_ID;
    ParamByName('PCOLID').AsInteger := COL_ID;
    Open;

    if Recordcount <= 0 then
    begin
      Result := GetNewKID('ARTCOLART');
      Close;
      SQL.Clear;
      SQL.Add('Insert into ARTCOLART(CAR_ID, CAR_ARTID, CAR_COLID)');
      SQL.Add('Values(:PCARID, :PARTID, :PCOLID)');
      ParamCheck := True;
      ParamByName('PCARID').AsInteger := Result;
      ParamByName('PARTID').AsInteger := ART_ID;
      ParamByName('PCOLID').AsInteger := COL_ID;
      ExecSQL;
    end
    else
      Result := FieldByName('CAR_ID').AsInteger;
  Except on E:Exception do
    raise Exception.Create('SetArtColArt -> ' + E.Message);
  end;
end;

function TCommandeClass.SetArticle(ART_REFMRK: String; ART_MRKID,
  ART_GREID: INTEGER; ART_NOM, ART_DESCRIPTION, ART_COMMENT5: String; ART_SSFID,
  ART_GTFID, ART_GARID, ARF_TVAID, ARF_ICLID3, ARF_ICLID4, ARF_ICLID5,
  ARF_CATID, ARF_TCTID: INTEGER; ART_CODE, ART_FEDAS : String; ART_PXETIQU : Integer ): TArtArticle;
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

//    FCdsArt.Append;
//    FCdsArt.FieldByName('ART_CODE').AsString := ART_CODE;
//    FCdsArt.FieldByName('ART_GTFID').AsInteger := ART_GTFID;
//    FCdsArt.FieldByName('ART_ID').AsInteger := Result.ART_ID;
//    FCdsArt.FieldByName('ARF_ID').AsInteger := Result.ARF_ID;
//    FCdsArt.Post;

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
  CLG_TGFID: Integer; CLG_PX, CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3,
  CLG_TAXE: Single; CLG_PRINCIPAL: integer): Integer;
var
  iCLGId : integer;
  bPrincipal : Boolean;
  bIsPrincipal : Boolean;
begin
  Try
    With FIboQuery do
    begin
      // Vérifier que l'article a un tarif principal
      Close;
      SQL.Clear;
      SQL.Add('Select count(*) as Resultat from TARCLGFOURN');
      SQL.Add('  join K on K_ID = CLG_ID and K_enabled = 1');
      SQL.Add('Where CLG_ARTID = :PARTID');
      SQL.Add('  and CLG_PRINCIPAL = 1');
      ParamCheck := True;
      ParamByName('PARTID').AsInteger := CLG_ARTID;
      Open;
      bPrincipal := (FieldByName('Resultat').AsInteger > 0);

      // Est ce que l'ARTID + FOUID est principal
      Close;
      SQL.Clear;
      SQL.Add('Select count(*) as Resultat from TARCLGFOURN');
      SQL.Add('  join K on K_ID = CLG_ID and K_enabled = 1');
      SQL.Add('Where CLG_ARTID = :PARTID');
      SQL.Add('  and CLG_FOUID = :PFOUID');
      SQL.Add('  and CLG_PRINCIPAL = 1');
      ParamCheck := True;
      ParamByName('PARTID').AsInteger := CLG_ARTID;
      ParamByName('PFOUID').AsInteger := CLG_FOUID;
      Open;
      bIsPrincipal := (FieldByName('Resultat').AsInteger > 0);

      Close;
      SQL.Clear;
      SQL.Add('Select CLG_ID,CLG_PX from TARCLGFOURN');
      SQL.Add(' join k on K_ID = CLG_ID and k_enabled = 1');
      SQL.Add('Where CLG_ARTID = :PARTID');
      SQL.Add('  and CLG_FOUID = :PFOUID');
      SQL.Add('  and CLG_TGFID = :PTGFID');
      ParamCheck := True;

      // est ce que le tarif de base est différent ?
      if CLG_TGFID <> 0  then
      begin
        ParambyName('PARTID').AsInteger := CLG_ARTID;
        ParamByName('PFOUID').AsInteger := CLG_FOUID;
        ParamByName('PTGFID').AsInteger  := 0;
        Open;
        if RecordCount > 0 then
        begin
          // Si le tarif est identique a celui de base, inutile de continuer
          if CompareValue(FieldByName('CLG_PX').AsFloat,CLG_PX,0.001) = EqualsValue then
          begin
            iCLGId := FieldByName('CLG_ID').AsInteger;
            Result := iCLGID;
            Exit;
          end;
        end;
        Close;
      end;

      ParamByName('PARTID').AsInteger := CLG_ARTID;
      ParamByName('PFOUID').AsInteger := CLG_FOUID;
      ParamByName('PTGFID').AsInteger := CLG_TGFID;
      Open;

      if RecordCount <= 0 then
      begin
        iCLGId := GetNewKId('TARCLGFOURN');
        Close;
        SQL.Clear;
        SQL.Add('Insert into TARCLGFOURN');
        SQL.Add('(CLG_ID,CLG_ARTID,CLG_FOUID,CLG_TGFID,CLG_PX,CLG_PXNEGO,CLG_PXVI,');
        SQL.Add('CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE,CLG_PRINCIPAL, CLG_CENTRALE)');
        SQL.Add('Values(:PCLGID,:PCLGARTID,:PCLGFOUID,:PCLGTGFID,:PCLGPX,:PCLGPXNEGO,:PCLGPXVI,');
        SQL.Add(':PCLGRA1,:PCLGRA2,:PCLGRA3,:PCLGTAXE,:PCLGPRINCIPAL, 1)');
        ParamCheck := True;
        ParamByName('PCLGID').AsInteger        := iCLGId;
        ParamByName('PCLGARTID').AsInteger     := CLG_ARTID;
        ParamByName('PCLGFOUID').AsInteger     := CLG_FOUID;
        ParamByName('PCLGTGFID').AsInteger     := CLG_TGFID;
        ParamByName('PCLGPX').AsCurrency       := CLG_PX;
        ParamByName('PCLGPXNEGO').AsCurrency   := CLG_PXNEGO;
        ParamByName('PCLGPXVI').AsFloat        := CLG_PXVI;
        ParamByName('PCLGRA1').AsFloat         := CLG_RA1;
        ParamByName('PCLGRA2').AsFloat         := CLG_RA2;
        ParamByName('PCLGRA3').AsFloat         := CLG_RA3;
        ParamByName('PCLGTAXE').AsFloat        := CLG_TAXE;
        if not bPrincipal or bIsPrincipal then
          ParamByName('PCLGPRINCIPAL').AsInteger := 1
        else
          ParamByName('PCLGPRINCIPAL').AsInteger := CLG_PRINCIPAL;
        ExecSQL;
      end
      else begin
        iCLGId := FieldByName('CLG_ID').AsInteger;
        // Si le prix est différent on met à jours juste le prix nego

        if CompareValue(FieldByName('CLG_PX').AsFloat,CLG_PX) = GreaterThanValue then
        begin
          Close;
          SQL.Clear;
          SQL.Add('Update TARCLGFOURN set');
          SQL.Add('  CLG_PXNEGO = :PCLGPXNEGO');
          SQL.Add('Where CLG_ID = :PCLGID');
          ParamCheck := True;
          ParamByName('PCLGPXNEGO').AsCurrency := CLG_PX;
          ParamByName('PCLGID').AsInteger      := iCLGId;
          ExecSQL;
        end;
      end;

      Result := iCLGId;
    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixAchat -> ' + E.Message);
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

function TCommandeClass.SetArtPrixVente(PVT_TVTID, PVT_ARTID,
  PVT_TGFID: Integer; PVT_PX: single): Integer;
var
  iPVTID : Integer;
begin
  Try
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.add('Select PVT_ID,PVT_PX from TARPRIXVENTE');
      SQL.Add('  join k on K_ID = PVT_ID and k_enabled = 1');
      SQL.Add('where PVT_ARTID = :PARTID');
      SQL.Add('  and PVT_TGFID = :PTGFID');
      ParamCheck := True;

      // est ce que le tarif de base est différent ?
      if PVT_TGFID <> 0  then
      begin
        ParambyName('PARTID').AsInteger := PVT_ARTID;
        ParamByName('PTGFID').AsInteger  := 0;
        Open;
        if RecordCount > 0 then
        begin
          // Si le tarif est identique a celui de base, inutile de continuer
          if CompareValue(FieldByName('PVT_PX').AsFloat,PVT_PX,0.001) = EqualsValue then
          begin
            iPVTID := FieldByName('PVT_ID').AsInteger;
            Exit;
          end;
        end;
        Close;
      end;

      // on traite le prix de la taille normalement
      ParambyName('PARTID').AsInteger := PVT_ARTID;
      ParamByName('PTGFID').AsInteger := PVT_TGFID;
      Open;

      if RecordCount <= 0 then
      begin
        iPVTID := GetNewKId('TARPRIXVENTE');
        Close;
        SQL.Clear;
        SQL.Add('Insert into TARPRIXVENTE');
        SQL.Add('(PVT_ID,PVT_TVTID,PVT_ARTID,PVT_TGFID,PVT_PX, PVT_CENTRALE)');
        SQL.Add('Values(:PPVTID,:PTVTID,:PARTID,:PTGFID,:PPVTPX, 1)');
        ParamCheck := True;
        ParamByName('PPVTID').AsInteger  := iPVTID;
        ParamByName('PTVTID').AsInteger  := PVT_TVTID;
        ParamByName('PARTID').AsInteger  := PVT_ARTID;
        ParamByName('PTGFID').AsInteger  := PVT_TGFID;
        ParamByName('PPVTPX').AsCurrency := PVT_PX;
        ExecSQL;
      end
      else begin
        iPVTID := FieldByName('PVT_ID').AsInteger;
      end;

      Result := iPVTID;
    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixVente -> ' + E.Message);
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
  CDL_LIVRAISON: TDateTime; CDL_COLID : Integer): TLigneStruct;
begin
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_SETCOMBCDEL(:CDLCDEID,:CDLARTID,:CDLTGFID,:CDLCOUID,');
    SQL.Add(':CDLQTE,:CDLPXCTLG,:CDLREMISE1,:CDLREMISE2,:CDLPXACHAT,:CDLTVA,:CDLPXVENTE,');
    SQL.Add(':CDLLIVRAISON)'); // ,:CDLCOLID
    ParamCheck := True;
//  end;
//
//  With FStpQuery do
//  begin
//    Close;
//    StoredProcName := 'MSS_SETCOMBCDEL';
//    ParamCheck := True;
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
//    ParamByName('CDLCOLID').AsInteger      := CDL_COLID;
    Open;

    Result.CDL_ID := FieldByName('CDL_ID').AsInteger;
//    Result.FAJOUT := FieldByName('FAJOUT').AsInteger;
//    Result.FMAJ   := FieldByName('FMAJ').AsInteger;
//
//    Inc(FCmdInsCount, FieldByName('FAJOUT').AsInteger);
//    Inc(FCmdMajCount, FieldByName('FMAJ').AsInteger);
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
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select TTV_ID from PLXTAILLESTRAV');
      SQL.Add('  join k on K_ID = TTV_ID and k_enabled = 1');
      SQL.Add('where TTV_ARTID = :PARTID');
      SQL.Add('  and TTV_TGFID = :PTGFID');
      ParamCheck := True;
      ParamByName('PARTID').AsInteger := TTV_ARTID;
      ParamByName('PTGFID').AsInteger := TTV_TGFID;
      Open;

      if RecordCount <= 0 then
      begin
        iTTVId := GetNewKId('PLXTAILLESTRAV');
        Close;
        SQL.Clear;
        SQL.Add('Insert into PLXTAILLESTRAV');
        SQL.Add('(TTV_ID,TTV_ARTID,TTV_TGFID)');
        SQL.Add('values(:PTTVID,:PTTVARTID,:PTTVTGFID)');
        ParamCheck := True;
        ParamByName('PTTVID').AsInteger    := iTTVId;
        ParamByName('PTTVARTID').AsInteger := TTV_ARTID;
        ParamByName('PTTVTGFID').AsInteger := TTV_TGFID;
        execSQL;
      end
      else
        iTTVId := FieldByName('TTV_ID').AsInteger;

      Result := iTTVId;
    end; // With
  except on E:Exception do
    raise Exception.Create('SetTailleTrav -> ' + E.Message);
  end;
end;

end.
