unit MSS_ArticleClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type,
     MSS_SuppliersClass, MSS_BrandsClass, MSS_UniversCriteriaClass, MSS_SizesClass,
     Math, Types, MSS_PeriodsClass, MSS_CollectionsClass, HTTPApp, Windows, StrUtils,
     Dialogs, MSS_FedasClass;

Type
  TModeArticle = (maCommande, maSDUpdate, maReception);

  TArticleClass = Class(TMainClass)
  private
    // Query
    FFournTable  ,
    FMarqueTable : TIboQuery;

    // Type
    FMode: TModeArticle;

    // MainClass
    FModelList,
    FColorList,
    FItemList ,
    FTARCLGFOUNR    ,
    FTARPRIXVENTE   ,
    FTARVALID,
    FTAILLETRAV     : TMainClass;

    // Datasource
    DS_ColorList ,
    DS_ModelList : TDataSource;
    FTVATable: TIboQuery;

    // autres
    FArtInscount, FArtMajCount : Integer;
    FArticleMailList : TStringList;

  public
    constructor Create;override;
    Destructor Destroy;override;

    // Creation des champs
    procedure CreateReceptionField;

    // fonction permettant de récupérer l'ID fournisseur
    function GetFournId(Suppliers : TSuppliers;AERPCODE, ACODE : String) : Integer;
    // Permet de récupérer l'ID de la TVA
    function GetTVAId(TVA_TAUX : single;TVA_CODE : String = '') : integer;
    // Permet de lié la marque au fournisseur
    function SetMrkFourn(AFOUID, AMRKID : Integer) : integer;
    // Permet la création de l'article (Retourne ART_ID et ARF_ID)
    function SetArticle(ART_REFMRK: String; ART_MRKID, ART_GREID : INTEGER;ART_NOM, ART_DESCRIPTION,ART_COMMENT5: String;
                        ART_SSFID, ART_GTFID, ART_GARID, ARF_TVAID, ARF_ICLID3, ARF_ICLID4, ARF_ICLID5, ARF_CATID, ARF_TCTID : INTEGER;
                        ART_CODE, ART_FEDAS : String; ART_PXETIQU, ART_ACTID, ART_CENTRALE, ART_PUB : Integer) : TArtArticle;
    // fonction de liaison de l'article avec une nomenclature secondaire
    function SetARTRelationAxe(ART_ID, SSF_ID : Integer) : integer;
    // Création de la relation/Article Taille
    function SetTailleTrav(TTV_ARTID,TTV_TGFID : Integer) : Integer;
    // Permet la création de la couleur (Retourne le COU_ID)
    function SetColor(ACOU_ARTID : Integer; ACOU_CODE, ACOU_NOM : String; COU_SMU, COU_TDSC : Integer) : Integer;
    // Permet de créer un CB (Retourne le CBI_ID)
    function SetARTCodeBarre(ACBI_ARFID, ACBI_TGFID, ACBI_COUID,ACBI_TYPE : Integer;ACBI_CB : String) : Integer;

    // fonction permettant de retourner les informations de tarifs d'achat d'un modèle
    function GetTarifAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID, CLG_CENTRALE : Integer) : TTarifAchat;
    // Procedure qui créé le prix d'achat de base d'un article (et le met à jour s'il existe) Retounr Principal
    function SetArtPrixAchat_Base(CLG_ARTID, CLG_FOUID : Integer;CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE : Single;CLG_CENTRALE : Integer) : Integer;
    // Procedure/fonction qui génèrent les prix d'achat des articles (TAILLE COULEUR)
    function SetArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID : Integer;CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE : Single;CLG_PRINCIPAL, CLG_CENTRALE : integer) : Integer;
    function UpdArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID : Integer;CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE : Single;CLG_PRINCIPAL, CLG_CENTRALE : integer) : Integer;

    // Procedure qui génére le prix de vente de base et le met à jour s'il existe
    Procedure SetArtPrixVente_Base(PVT_ARTID : Integer;PVT_PX : single;PVT_CENTRALE : Integer);
    // Permettant de mettre en mémoire les tarifs d'un article
    function DoGetTarifAchat(AArticle : TArtArticle; AFOU_ID : Integer; ADoEmptyDataSet : Boolean = True) : Boolean;
    function DoGetTarifVente(AArticle : TArtArticle) : Boolean;
    function DoGetTarifPrecoSpe(ATPO_ID : Integer) : Boolean;

    // Fonction de gestion des tarifs d'achat
    function DoTarifAchat(AArticle : TArtArticle; AFOU_ID, ATGF_ID, ACOU_ID : Integer; var ATarifBase : Currency; AIsFirstTime : Boolean = false) : Boolean;
    // Fonction de gestion des tarifs de vente
    function DoTarifVente(AArticle : TArtArticle; ATGF_ID, ACOU_ID, ATPO_ID : Integer; ATPO_DT : TDate; var APrixBase : Currency) : Boolean;
    // fonction qui génère les prix de vente des articles
    function SetArtPrixVente(PVT_ARTID,PVT_TGFID, PVT_COUID : Integer;PVT_PX : single;PVT_CENTRALE : Integer) : Integer;


    procedure Import;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;
  published
    Property MarqueTable     : TIboQuery    read FMarqueTable write FMarqueTable;
    Property FournTable      : TIboQuery    read FFournTable  write FFournTable;
    Property TVATable        : TIboQuery    read FTVATable    write FTVATable;

    property Mode            : TModeArticle read FMode        write FMode;

    Property Model           : TMainClass   read FModelList;
    Property Color           : TMainClass   read FColorList;
    Property Item            : TMainClass   read FItemList;

    property ArtInsCount     : Integer     read FArtInscount;
    property ArtMajCount     : Integer     read FArtMajCount;

    property ArticleMailList : TStringList read FArticleMailList;

  End;

implementation

{ TArticleClass }

constructor TArticleClass.Create;
begin
  inherited Create;

  FModelList    := TMainClass.Create;
  FColorList    := TMainClass.Create;
  FItemList     := TMainClass.Create;
  FTARCLGFOUNR  := TMainClass.Create;
  FTARPRIXVENTE := TMainClass.Create;
  FTARVALID     := TMainClass.Create;
  FTAILLETRAV   := TMainClass.Create;

  DS_ColorList         := TDataSource.Create(nil);
  DS_ColorList.DataSet := FColorList.ClientDataSet;
  DS_ModelList         := TDataSource.Create(nil);
  DS_ModelList.DataSet := FModelList.ClientDataSet;

  FArticleMailList     := TStringList.Create;

end;

procedure TArticleClass.CreateReceptionField;
var
  // ModelList
  Supplierkey, Suppliername, Modnumber, Moddenotation, Brandnumber, Branddenotation,
  Sizerange, FEDAS, VAT, ART_ID, ARF_ID : TFieldCFG;
  // ColorList
  Colornumber, Colordenotation, COU_ID : TFieldCfg;
  // ItemList
  ColumnX, Sizelabel, EAN, Salesprice, Purchaseprice, SizeIdx, TGF_ID : TFieldCfg;

  // Table TARCLGFOURN
  CLG_ID, CLG_FOUID, CLG_ARTID, CLG_TGFID, CLG_COUID, CLG_PX, CLG_PRINCIPAL : TFieldCfg;

  // Table TARPRIXVENTE
  PVT_ID, PVT_TVTID, PVT_ARTID, PVT_TGFID, PVT_COUID, PVT_PX : TFieldCfg;

  // Table TARVALID
  TVD_ID, TVD_TVTID, TVD_COUID, TVD_TGFID, TVD_DT, TVD_PX, TVD_ETAT : TFieldCfg;

  // Table FTAILLETRAV
  TTV_TGFID : TFieldCFG;

begin
  {$REGION 'ModelList'}
  Supplierkey.FieldName     := 'Supplierkey';
  Supplierkey.FieldType     := ftString;
  Suppliername.FieldName    := 'Suppliername';
  Suppliername.FieldType    := ftString;
  Modnumber.FieldName       := 'Modnumber';
  Modnumber.FieldType       := ftString;
  Moddenotation.FieldName   := 'Moddenotation';
  Moddenotation.FieldType   := ftString;
  Brandnumber.FieldName     := 'Brandnumber';
  Brandnumber.FieldType     := ftString;
  Branddenotation.FieldName := 'Branddenotation';
  Branddenotation.FieldType := ftString;
  Sizerange.FieldName       := 'Sizerange';
  Sizerange.FieldType       := ftString;
  FEDAS.FieldName           := 'FEDAS';
  FEDAS.FieldType           := ftString;
  VAT.FieldName             := 'VAT';
  VAT.FieldType             := ftCurrency;
  ART_ID.FieldName          := 'ART_ID';
  ART_ID.FieldType          := ftInteger;
  ARF_ID.FieldName          := 'ARF_ID';
  ARF_ID.FieldType          := ftInteger;

  FModelList.CreateField([Supplierkey, Suppliername, Modnumber, Moddenotation,
                          Brandnumber, Branddenotation, Sizerange, FEDAS, VAT, ART_ID, ARF_ID]);
  FModelList.ClientDataSet.AddIndex('Idx','Modnumber;Brandnumber;Sizerange',[]);
  FModelList.ClientDataSet.IndexName := 'Idx';
  {$ENDREGION}

  {$REGION 'ColorList'}
  Colornumber.FieldName     := 'Colornumber';
  Colornumber.FieldType     := ftString;
  Colordenotation.FieldName := 'Colordenotation';
  Colordenotation.FieldType := ftString;
  COU_ID.FieldName          := 'COU_ID';
  COU_ID.FieldType          := ftInteger;

  FColorList.CreateField([Modnumber,Brandnumber,Sizerange,Colornumber, Colordenotation, COU_ID]);
  FColorList.ClientDataSet.AddIndex('Idx','Modnumber;Brandnumber;Sizerange;Colornumber',[]);
  FColorList.ClientDataSet.IndexName := 'Idx';
  FColorList.ClientDataSet.MasterSource := DS_ModelList;
  FColorList.ClientDataSet.MasterFields := 'Modnumber;Brandnumber;Sizerange';
  {$ENDREGION}

  {$REGION 'ItemList'}
  ColumnX.FieldName       := 'ColumnX';
  ColumnX.FieldType       := ftString;
  Sizelabel.FieldName     := 'Sizelabel';
  Sizelabel.FieldType     := ftString;
  EAN.FieldName           := 'EAN';
  EAN.FieldType           := ftString;
  Salesprice.FieldName    := 'Salesprice';
  Salesprice.FieldType    := ftCurrency;
  Purchaseprice.FieldName := 'Purchaseprice';
  Purchaseprice.FieldType := ftCurrency;
  SizeIdx.FieldName       := 'SizeIdx';
  SizeIdx.FieldType       := ftInteger;
  TGF_ID.FieldName        := 'TGF_ID';
  TGF_ID.FieldType        := ftInteger;

  FItemList.CreateField([Modnumber,Brandnumber,Sizerange,Colornumber,ColumnX,Sizelabel,
                         EAN,Salesprice,Purchaseprice,SizeIdx,TGF_ID]);
  FItemList.ClientDataSet.AddIndex('Idx','Modnumber;Brandnumber;Sizerange;Colornumber;ColumnX',[]);
   FItemList.ClientDataSet.IndexName := 'Idx';
  FItemList.ClientDataSet.MasterSource := DS_ColorList;
  FItemList.ClientDataSet.MasterFields := 'Modnumber;Brandnumber;Sizerange;Colornumber';
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
  PVT_ARTID.FieldName := 'PVT_ARTID';
  PVT_ARTID.FieldType := ftInteger;
  PVT_TGFID.FieldName := 'PVT_TGFID';
  PVT_TGFID.FieldType := ftInteger;
  PVT_COUID.FieldName := 'PVT_COUID';
  PVT_COUID.FieldType := ftInteger;
  PVT_PX.FieldName := 'PVT_PX';
  PVT_PX.FieldType := ftCurrency;

  FTARPRIXVENTE.CreateField([PVT_ID, PVT_ARTID, PVT_TGFID, PVT_COUID, PVT_PX]);
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

  {$REGION 'Table FTAILLETRAV'}
  TTV_TGFID.FieldName := 'TTV_TGFID';
  TTV_TGFID.FieldType := ftInteger;

  FTAILLETRAV.CreateField([TTV_TGFID]);
  {$ENDREGION}
end;

destructor TArticleClass.Destroy;
begin
  DS_ColorList.Free;
  DS_ModelList.Free;

  FTARCLGFOUNR.Free;
  FTARPRIXVENTE.Free;
  FTARVALID.Free;
  FTAILLETRAV.Free;

  FItemList.Free;
  FColorList.Free;
  FModelList.Free;

  FArticleMailList.Free;

  inherited;
end;

function TArticleClass.DoGetTarifAchat(AArticle: TArtArticle; AFOU_ID: Integer;
  ADoEmptyDataSet: Boolean): Boolean;
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

function TArticleClass.DoGetTarifPrecoSpe(ATPO_ID: Integer): Boolean;
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

function TArticleClass.DoGetTarifVente(AArticle: TArtArticle): Boolean;
begin
  Result := False;
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from TARPRIXVENTE');
    SQL.Add('  Join K on K_ID = PVT_ID and K_Enabled = 1');
    SQL.Add('Where PVT_ARTID = :PARTID');
    SQL.Add('  and PVT_TVTID = 0');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := AArticle.ART_ID;
    Open;

    FTARPRIXVENTE.ClientDataSet.EmptyDataSet;
    while not EOF do
    begin
      FTARPRIXVENTE.Append;
      FTARPRIXVENTE.FieldByName('PVT_ID').AsInteger := FieldByName('PVT_ID').AsInteger;
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

function TArticleClass.DoMajTable(ADoMaj: Boolean): Boolean;
var
  Suppliers   : TSuppliers;
  Brands      : TBrands;
  Univers     : TUniversCriteria;
  Sizes       : TSizes;
  Periods     : TPeriods;
  Collections : TCollections;
  Fedas       : TFedas;

  i, TCT_ID, ACT_ID, ICL_ID5, FOU_ID, MRK_ID, TVA_ID, FMK_ID,
  SSF_ID_UNIC, SSF_ID_FEDAS, GTF_ID, TGF_ID, COU_ID, CBI_ID,
  CLG_ID, GRE_ID : Integer;
  bDoFindBrandTbTmp, bFound, bFoundSSFUNIC, bFoundSSFFEDAS, bDoTarifBase : Boolean;

  Article : TArtArticle;
  TarifAchat : TTarifAchat;

  ART_REFMRK, ART_NOM, ART_DESCRIPTION, ART_COMMENT5, ART_CODE, ART_FEDAS : string;
  ART_CENTRALE, ART_GREID, ART_PUB : Integer;

  bDoAction : Boolean;

  sError : String;

  bFirstTarifAchat ,
  bFirstTarifVente : Boolean;

  TarifAchatBase ,
  TarifVenteBase : Currency;
begin
  Try
    {$REGION 'Initialisation'}
    IsCreated := False;
    IsUpdated := False;
    IsOnError := False;

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

    {$REGION 'Création du classement 5'}
    ICL_ID5 := 0;
    {$ENDREGION}

    {$REGION 'Recherche du fournisseur'}
    FOU_ID := GetFournId(Suppliers,'',FModelList.FieldByName('SupplierKey').AsString);
    {$ENDREGION}

    {$REGION 'Recherche du brands (Marque)'}
    bDoFindBrandTbTmp := False;
    // Si il y a eu mise à jour du des brands alors on utilise la table d'import temporaire
    if Brands.IsUpdated then
    begin
      if (Brands.FieldByName('CodeMarque').AsString = FModelList.FieldByName('BrandNumber').AsString) and
         (Brands.FieldByName('MRK_ID').AsInteger > 0) then
        MRK_ID := Brands.FieldByName('MRK_ID').AsInteger
      else begin
        if Brands.ClientDataSet.Locate('CodeMarque',FModelList.FieldByName('BrandNumber').AsString,[loCaseInsensitive]) then
        begin
          MRK_ID := Brands.FieldByName('MRK_ID').AsInteger;
          if MRK_ID <= 0 then
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
      if (FMarqueTable.FieldByName('MRK_CODE').AsString = FModelList.FieldByName('BrandNumber').AsString) and
         (FMarqueTable.FieldByName('MRK_ID').AsInteger > 0) then
        MRK_ID := FMarqueTable.FieldByName('MRK_ID').AsInteger
      else begin
        if FMarqueTable.Locate('MRK_CODE',FModelList.FieldByName('BrandNumber').AsString,[]) then
        begin
          MRK_ID := FMarqueTable.FieldByName('MRK_ID').AsInteger;
        end
        else begin
          if Brands.ClientDataSet.Locate('CodeMarque',FModelList.FieldByName('BrandNumber').AsString,[loCaseInsensitive]) then
          begin
            // On recherche dans la base et on créé au cas où
            MRK_ID := Brands.GetBrands;
          end
          else
            raise Exception.Create('BrandNumber inéxistant : ' + FModelList.FieldByName('BrandNumber').AsString);
        end;
      end;
    end;
    {$ENDREGION}

    {$REGION 'Traitement de la liaison de la marque avec le fournisseur'}
    FMK_ID := SetMrkFourn(FOU_ID,MRK_ID);
    {$ENDREGION}

    {$REGION 'Récupération de la TVA'}
    if CompareValue(FModelList.FieldByName('VAT').AsSingle,0, 0.001) = EqualsValue then
      raise Exception.Create('TVA à 0 pour le modèle - Intégration impossible');

    TVA_ID := GetTVAID(FModelList.FieldByName('VAT').AsSingle,'');

    {$ENDREGION}

    {$REGION 'Recherche de la sousfamille via la FEDAS'}
    // recherche par l'universcritéria
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
    end;

    if SSF_ID_FEDAS = -1 then
      raise Exception.Create(Format('Code Fedas inéxistant : %s', [FModelList.FieldByName('FEDAS').AsString]));
    if SSF_ID_UNIC = -1 then
      raise Exception.Create(Format('Pas d''univers lié au code Fedas : %s', [FModelList.FieldByName('FEDAS').AsString]));
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
        GTF_ID := Sizes.PLXGTF.FieldByName('GTF_ID').AsInteger
      else begin
        if Sizes.PLXGTF.ClientDataSet.Locate('ID',FModelList.FieldByName('SizeRange').AsString,[loCaseInsensitive]) then
        begin
          GTF_ID := Sizes.PLXGTF.FieldByName('GTF_ID').AsInteger;
          bFound := not(GTF_ID <= 0);
        end;
      end;
    end;

    if Not bFound then
    begin
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

        if RecordCount > 0 then
          GTF_ID := FieldByName('GTF_ID').AsInteger
        else begin
          // Si la taille n'exite pas en base on vérifie si on l'a en mémoire et on l'a crée
          bFound := False;
          if Sizes.PLXGTF.ClientDataSet.Locate('ID',FModelList.FieldByName('SizeRange').AsString,[loCaseInsensitive]) then
            if Sizes.PLXTYPEGT.ClientDataSet.Locate('ID',Sizes.PLXGTF.FieldByName('MSRID').AsString,[loCaseInsensitive]) then
            begin
              GTF_ID := Sizes.GetSubRange;
              bFound := True;
            end;

          if not bFound then
            raise Exception.Create(Format('Grille de taille Inéxistante %s',[FModelList.FieldByName('SizeRange').AsString]));
        end;
      end;
    end;
    {$ENDREGION}

    {$REGION 'Creation de l''Article'}
    bDoAction := False;
    case FMode of
      maCommande: ;
      maSDUpdate: ;
      maReception: begin
        ART_REFMRK := FModelList.FieldByName('Modnumber').AsString;
        ART_GREID := 0;
        ART_NOM := FModelList.FieldByName('Moddenotation').AsString;
        ART_DESCRIPTION := FModelList.FieldByName('Moddenotation').AsString;
        ART_COMMENT5 := FModelList.FieldByName('FEDAS').AsString;
        ART_CODE := FModelList.FieldByName('Modnumber').AsString + FModelList.FieldByName('Brandnumber').AsString;
        ART_FEDAS := FModelList.FieldByName('FEDAS').AsString;
        ART_CENTRALE := 1;
        ART_PUB := 0;
        bDoAction := (FModelList.FieldByName('ART_ID').AsInteger <= 0);
      end;
    end;

    if bDoAction then
    begin
      Article := SetArticle(
        ART_REFMRK,      // ART_REFMRK
        MRK_ID,          // ART_MRKID,
        ART_GREID,       // ART_GREID: INTEGER;
        ART_NOM,         // ART_NOM,
        ART_DESCRIPTION, // ART_DESCRIPTION,
        ART_COMMENT5,    // ART_COMMENT5: String;
        SSF_ID_FEDAS,    // ART_SSFID,
        GTF_ID,          // ART_GTFID,
        0,               // ART_GARID,
        TVA_ID,          // ARF_TVAID,
        0,               // ARF_ICLID3,
        0,               // ARF_ICLID4,
        ICL_ID5,         // ARF_ICLID5,
        0,               // ARF_CATID,
        TCT_ID,          // ARF_TCTID: INTEGER
        ART_CODE,        // ART_CODE
        ART_FEDAS,       // ART_FEDAS
        0,               // ART_PXETIQU
        ACT_ID,          // ART_ACTID
        ART_CENTRALE,    // ART_CENTRALE
        ART_PUB          // ART_PUB
      );

      IsCreated := (Article.FAjout > 0);
      IsUpdated := (Article.FMaj > 0);
    end
    else begin
      Article.ART_ID := FModelList.FieldByName('ART_ID').AsInteger;
      Article.FAjout := 0;
      Article.FMaj   := 0;
      With FIboQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select ARF_ID, ARF_CHRONO from ARTREFERENCE');
        SQL.Add('  join K on K_ID = ARF_ID and K_Enabled = 1');
        SQL.Add('Where ARF_ARTID = :PARTID');
        ParamCheck := True;
        ParamByName('PARTID').AsInteger := Article.ART_ID;
        Open;
        if RecordCount > 0 then
        begin
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
    end;

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


    {$REGION 'Création de la relation Article et Univers secondaire'}
    SetARTRelationAxe(Article.ART_ID,SSF_ID_UNIC);
    {$ENDREGION}


    {$REGION 'Initialisation & Récupération des données Tarifs de l''article'}
    bFirstTarifAchat := False;
    bFirstTarifVente := False;

    // Récupération des tarif d'achat
    DoGetTarifAchat(Article,FOU_ID);

    // Récupération des tarifs de vente
    DoGetTarifVente(Article);

    // Récupération des données de prix recommandé à date
//    DoGetTarifPrecoSpe(TPO_ID);
    {$ENDREGION}

    // Génération des informations que l'article (Taille, couleur, tarif, etc..)
    FColorList.First;
    while not FColorList.EOF do
    begin
      FItemList.First;
      while not FItemList.EOF do
      begin

        {$REGION 'Récupération de la taille'}
        bFound := False;
        if Sizes.IsUpdated then
        begin
          if (Sizes.PLXTAILLESGF.FieldByName('SRID').AsString = FModelList.FieldByName('SizeRange').AsString) and
             (Sizes.PLXTAILLESGF.FieldByName('Columnx').AsString = FItemList.FieldByName('Columnx').AsString) and
             (Sizes.PLXTAILLESGF.FieldByName('TGF_ID').AsInteger > 0)  then
            TGF_ID := Sizes.PLXTAILLESGF.FieldByName('TGF_ID').AsInteger
          else begin
            if Sizes.PLXTAILLESGF.ClientDataSet.Locate('SRID;Columnx',VarArrayof([FModelList.FieldByName('SizeRange').AsString,FItemList.FieldByName('Columnx').AsString]),[loCaseInsensitive]) then
            begin
              TGF_ID := Sizes.PLXTAILLESGF.FieldByName('TGF_ID').AsInteger;
              bFound := not (TGF_ID <= 0);
            end;
          end;
        end;

        if not bFound then
        begin
          With FIboQuery do
          begin
            Close;
            SQL.Clear;
            SQL.Add('Select TGF_ID from PLXTAILLESGF');
            SQL.Add('  join K on K_ID = TGF_ID and K_Enabled = 1');
            SQL.Add('Where TGF_GTFID = :PGTFID');
            SQL.Add('  and TGF_COLUMNX = :PCOLUMNX');
            ParamCheck := True;
            ParamByName('PGTFID').AsInteger := GTF_ID;
            ParamByName('PCOLUMNX').AsString := FItemList.FieldByName('Columnx').AsString;
            Open;

            if RecordCount > 0 then
              TGF_ID := FieldByName('TGF_ID').AsInteger
            else begin
              bFound := False;
              if Sizes.PLXGTF.ClientDataSet.Locate('ID',FModelList.FieldByName('SizeRange').AsString,[loCaseInsensitive]) then
                if Sizes.PLXTYPEGT.ClientDataSet.Locate('ID',Sizes.PLXGTF.FieldByName('MSRID').AsString,[loCaseInsensitive]) then
                  if Sizes.PLXTAILLESGF.ClientDataSet.Locate('SRID;Columnx',VarArrayof([FModelList.FieldByName('SizeRange').AsString,FItemList.FieldByName('Columnx').AsString]),[loCaseInsensitive]) then
                  begin
                    TGF_ID := Sizes.GetSizes;
                    bFound := True;
                  end;
              if not bFound then
                raise Exception.Create(Format('Taille Inéxistante %s / %s',[FModelList.FieldByName('SizeRange').AsString,FItemList.FieldByName('Columnx').AsString]));
            end;
          end;
        end;

        if FItemList.FieldByName('TGF_ID').AsInteger <= 0 then
        begin
          FItemList.ClientDataSet.Edit;
          FItemList.FieldByName('TGF_ID').AsInteger := TGF_ID;
          FItemList.ClientDataSet.Post;
        end;
        {$ENDREGION}

        {$REGION 'Gestion de la relation Taille/Article'}
        if (Article.FAjout > 0) then
        begin
          SetTailleTrav(Article.ART_ID,TGF_ID);
        end;
        {$ENDREGION}

        {$REGION 'Création de la couleur'}
        if FColorList.FieldByName('COU_ID').AsInteger <= 0 then
        begin
          COU_ID := SetColor(Article.ART_ID,
                             FColorList.FieldByName('COLORNUMBER').AsString,
                             FColorList.FieldByName('COLORDENOTATION').AsString,
                             0,
                             0);

          FColorList.ClientDataSet.Edit;
          FColorList.FieldByName('COU_ID').AsInteger := COU_ID;
          FColorList.ClientDataSet.Post;
        end
        else
          COU_ID := FColorList.FieldByName('COU_ID').AsInteger;
        {$ENDREGION}

        {$REGION 'Gestion des CB'}
        // Création du CB Ginkoia
        // -1 sur le CBI_CB pour indiquer qu'il faut générer le CB (Utile que pour le type 1 ici)
        CBI_ID := SetARTCodeBarre(Article.ARF_ID,TGF_ID,COU_ID,1,'-1');

        // Création du CB
        if FItemList.FieldByName('EAN').AsString <> '' then
        begin
          CBI_ID := SetARTCodeBarre(Article.ARF_ID,TGF_ID,COU_ID,3,FItemList.FieldByName('EAN').AsString);
        end;
        {$ENDREGION}

        {$REGION 'Gestion des tarifs d''achat'}
        // Si on est en réception on ne traite les tarif qu'à la création
        if (FMode = maReception) and (Article.FAjout > 0) then
        begin
          // Cas du premier tarif d'achat de la liste
          if not bFirstTarifAchat then
          begin
            TarifAchatBase := FItemList.FieldByName('PURCHASEPRICE').AsCurrency;
            DoTarifAchat(Article,FOU_ID,TGF_ID,COU_ID,TarifAchatBase,True);

            bFirstTarifAchat := True;
          end
          else begin
            DoTarifAchat(Article,FOU_ID,TGF_ID,COU_ID,TarifAchatBase);
          end;
        end;
        {$ENDREGION}

        {$REGION 'Gestion des tarifs de vente'}
        // Si on est en réception on ne traite les tarif qu'à la création
        if (FMode = maReception) and (Article.FAjout > 0) then
        begin
          If not bFirstTarifVente then
          begin
            TarifVenteBase := FItemList.FieldByName('SALESPRICE').AsCurrency;
            DoTarifVente(Article,TGF_ID, COU_ID, 0, Now, TarifVenteBase);
            bFirstTarifVente := True;
          end
          else
            DoTarifVente(Article,TGF_ID, COU_ID, 0, Now, TarifVenteBase);
        end;
        {$ENDREGION}


//        {$REGION 'Gestion des Tarifs'}
//        if (Article.FAjout > 0) and bDoTarifBase then
//        begin
//          TarifAchat.CLG_PX := FItemList.FieldByName('PURCHASEPRICE').AsCurrency;
//          TarifAchat.CLG_PRINCIPAL := SetArtPrixAchat_Base(Article.ART_ID,FOU_ID,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,FItemList.FieldByName('SALESPRICE').AsCurrency,0,0,0,0,1);
//
//          SetArtPrixVente_Base(Article.ART_ID,FItemList.FieldByName('SALESPRICE').AsCurrency,1);
//
//          bDoTarifBase := False;
//        end;
//
//        if CompareValue(FItemList.FieldByName('PURCHASEPRICE').AsCurrency,TarifAchat.CLG_PX,0.001) <> EqualsValue then
//        begin
//          if Article.FAjout > 0 then
//          begin
//            CLG_ID := SetArtPrixAchat(Article.ART_ID,FOU_ID,TGF_ID,COU_ID,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,FItemList.FieldByName('SALESPRICE').AsCurrency,0,0,0,0,TarifAchat.CLG_PRINCIPAL,1);
//          end
//          else begin
//            CLG_ID := SetArtPrixAchat(Article.ART_ID,FOU_ID,TGF_ID,COU_ID,TarifAchat.CLG_PX,TarifAchat.CLG_PX,FItemList.FieldByName('SALESPRICE').AsCurrency,0,0,0,0,TarifAchat.CLG_PRINCIPAL,1);
//          end;
//        end;
//        {$ENDREGION}

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
        end;

        With FTAILLETRAV.ClientDataSet do
        begin
          First;
          while not EOF do
          begin
            SetARTCodeBarre(Article.ARF_ID,FieldByName('TTV_TGFID').AsInteger,COU_ID,1,'-1');
            Next;
          end;
        end;
        {$ENDREGION}

        FItemList.Next;
      end;

      FColorList.Next;
    end;
  Except on E:Exception do
    begin
      FErrLogs.Add(FModelList.FieldByName('Modnumber').AsString + FModelList.FieldByName('Brandnumber').AsString + ' : ' + E.Message);
      IsOnError := True;
    end;
  end;

  {$REGION 'Génération des données pour le mail'}
  if IsOnError then
    sError := 'ERROR'
  else
    sError := '';

  FArticleMailList.Add('<tr>');
  FArticleMailList.Add(Format('<td class="CODEART-LG%s">%s</td>',[sError,ART_REFMRK]));
  FArticleMailList.Add(Format('<td class="CHRONO-LG%s">%s</td>',[sError,Article.Chrono]));
  FArticleMailList.Add(Format('<td class="ARTNOM-LG%s">%s</td>',[sError, ART_NOM]));
  FArticleMailList.Add(Format('<td class="MARQUE-LG%s">%s</td>',[sError,Brands.FieldByName('denotation').AsString]));
  if IsCreated then
    FArticleMailList.Add(Format('<td class="ETAT-LG%s">Création</td>',[sError]))
  else
    FArticleMailList.Add(Format('<td class="ETAT-LG%s">Mise à jour</td>',[sError]));
  FArticleMailList.Add('</tr>');
  {$ENDREGION}

  Suppliers := nil;
  Brands := nil;
  Univers := nil;
  Sizes := nil;
  Periods := nil;
  Collections := nil;
  Fedas := nil;
end;

function TArticleClass.DoTarifAchat(AArticle: TArtArticle; AFOU_ID, ATGF_ID,
  ACOU_ID: Integer; var ATarifBase: Currency; AIsFirstTime: Boolean): Boolean;
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
                              FItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PX,
                              FItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PXNEGO,
                              FItemList.FieldByName('SALESPRICE').AsCurrency, // CLG_PXVI,
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
        FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency := FItemList.FieldByName('PURCHASEPRICE').AsCurrency;
        FTARCLGFOUNR.FieldByName('CLG_PRINCIPAL').AsInteger := iPRINCIPAL;
        FTARCLGFOUNR.Post;

        bContinue := False;
      end
      else begin
        // Si on est en modification , on recherche le tarif en mémoire et on le met à jour si nécessaire
        if FTARCLGFOUNR.ClientDataSet.Locate('CLG_FOUID;CLG_TGFID;CLG_COUID',VarArrayOf([AFOU_ID,0,0]),[]) Then
        begin
          if CompareValue(FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,0.001) <> EqualsValue then
          begin
            // On met le tarif à jour dans la base de données
            iPrincipal:= SetArtPrixAchat_Base(
                                  AArticle.ART_ID,                                            // CLG_ARTID
                                  AFOU_ID,                                                    // CLG_FOUID : Integer;
                                  FItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PX,
                                  FItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PXNEGO,
                                  FItemList.FieldByName('SALESPRICE').AsCurrency, // CLG_PXVI,
                                  0,                                                          // CLG_RA1,
                                  0,                                                          // CLG_RA2,
                                  0,                                                          // CLG_RA3,
                                  0,                                                          // CLG_TAXE: Single;
                                  1                                                           // CLG_CENTRALE : Integer
                                );

            FTARCLGFOUNR.ClientDataSet.Edit;
            FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency := FItemList.FieldByName('PURCHASEPRICE').AsCurrency;
            FTARCLGFOUNR.Post;
            ATarifBase := FItemList.FieldByName('PURCHASEPRICE').AsCurrency;
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
//        raise Exception.Create('Le modèle n''a pas de tarif d''achat de base');
        iPRINCIPAL := SetArtPrixAchat_Base(
                              AArticle.ART_ID,                                             // CLG_ARTID
                              AFOU_ID,                                                     // CLG_FOUID : Integer;
                              FItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PX,
                              FItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PXNEGO,
                              FItemList.FieldByName('SALESPRICE').AsCurrency, // CLG_PXVI,
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
        FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency := FItemList.FieldByName('PURCHASEPRICE').AsCurrency;
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
        if CompareValue(ATarifBase,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,0.001) <> EqualsValue then
        begin
          // Oui, est ce qu'il y a un tarif spécifique pour cet article ?
          if FTARCLGFOUNR.ClientDataSet.Locate('CLG_FOUID;CLG_TGFID;CLG_COUID',VarArrayOf([AFOU_ID,ATGF_ID,ACOU_ID]),[]) then
          begin
            // Oui, est ce que le tarif en cours et <> du tarif spécifique
           if CompareValue(FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,0.001) <> EqualsValue then
           begin
             // Oui, et on le met à jour
            CLG_ID := UpdArtPrixAchat(AArticle.ART_ID,AFOU_ID,ATGF_ID,ACOU_ID,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,FItemList.FieldByName('SALESPRICE').AsCurrency,0,0,0,0,iPRINCIPAL,1);
            // et on met à jour la table en mémoire
            FTARCLGFOUNR.ClientDataSet.Edit;
            FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency := FItemList.FieldByName('PURCHASEPRICE').AsCurrency;
            FTARCLGFOUNR.Post;
           end;
          end
          else begin
            // Non, alors on créé le tarif spécifique
            CLG_ID := SetArtPrixAchat(AArticle.ART_ID,AFOU_ID,ATGF_ID,ACOU_ID,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,FItemList.FieldByName('SALESPRICE').AsCurrency,0,0,0,0,iPRINCIPAL,1);
            // et on l'ajoute à la table en mémoire
            FTARCLGFOUNR.Append;
            FTARCLGFOUNR.FieldByName('CLG_ID').AsInteger := CLG_ID;
            FTARCLGFOUNR.FieldByName('CLG_FOUID').AsInteger := AFOU_ID;
            FTARCLGFOUNR.FieldByName('CLG_TGFID').AsInteger := ATGF_ID;
            FTARCLGFOUNR.FieldByName('CLG_COUID').AsInteger := ACOU_ID;
            FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency := FItemList.FieldByName('PURCHASEPRICE').AsCurrency;
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
            CompareTarif := FItemList.FieldByName('PURCHASEPRICE').AsCurrency;
          // Est ce que le tarif spécifique est différent du tarif de base/en cours?
          if CompareValue(FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency, CompareTarif,0.001) <> EqualsValue then
          begin
            // Oui, alors on va mettre à jour avec le tarif de base
            CLG_ID := UpdArtPrixAchat(AArticle.ART_ID,AFOU_ID,ATGF_ID,ACOU_ID,CompareTarif,CompareTarif,FItemList.FieldByName('SALESPRICE').AsCurrency,0,0,0,0,iPRINCIPAL,1);
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
            if CompareValue(ATarifBase, FItemList.FieldByName('PURCHASEPRICE').AsCurrency,0.001) <> EqualsValue then
              // Oui, alors on créé le tarif spécifique
              CLG_ID := SetArtPrixAchat(AArticle.ART_ID,AFOU_ID,ATGF_ID,ACOU_ID,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,FItemList.FieldByName('SALESPRICE').AsCurrency,0,0,0,0,iPRINCIPAL,1);
        end;
      end;
    end;
    Result := True;
  Except on E:Exception do
    raise Exception.Create('DoTarifAchat -> ' + E.Message);
  end;
end;

function TArticleClass.DoTarifVente(AArticle: TArtArticle; ATGF_ID, ACOU_ID,
  ATPO_ID: Integer; ATPO_DT: TDate; var APrixBase : Currency): Boolean;
var
  bContinue : Boolean;
  cPrixBaseActuel : Currency;
begin
  try
    if AArticle.FAjout > 0 then
    begin
      // Création
      // Y a il déjà un tarif de base ?
      if not FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID',VarArrayOf([0,0]),[]) then
      begin
        // Non alors on en crée un
        SetArtPrixVente(AArticle.ART_ID,0,0,APrixBase,1);
        // Mise à jour du CDS en mémoire
        FTARPRIXVENTE.Append;
        FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := 0;
        FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := 0;
        FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := APrixBase;
        FTARPRIXVENTE.Post;
      end;

      // Est ce que le tarif en cours <> du tarif de base ?
      if CompareValue(APrixBase,FItemList.FieldByName('SALESPRICE').AsCurrency) <> EqualsValue then
      begin
        // Oui alors on crée un tarif spécifique
        SetArtPrixVente(AArticle.ART_ID,ATGF_ID, ACOU_ID,FItemList.FieldByName('SALESPRICE').AsCurrency,1);

        // Ajout au CSD
        FTARPRIXVENTE.Append;
        FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := ATGF_ID;
        FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := ACOU_ID;
        FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := FItemList.FieldByName('SALESPRICE').AsCurrency;
        FTARPRIXVENTE.Post;
      end;
    end
    else begin
      // Mise à jour
      // y a-t-il un tarif de base ?
      if not FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID',VarArrayOf([0,0]),[]) then
         raise Exception.Create('Le modèle n''a pas de prix de vente de base');
      cPrixBaseActuel := FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency;

      // Est ce que le tarif en cours <> du tarif de base ?
      if CompareValue(APrixBase,FItemList.FieldByName('SALESPRICE').AsCurrency) <> EqualsValue then
      begin
        // Oui, est ce qu'il y aun tarif spécifique existant ?
        if not FTARPRIXVENTE.ClientDataSet.Locate('PVT_TGFID;PVT_COUID',VarArrayOf([ATGF_ID,ACOU_ID]),[]) then
        begin
          // Si non, création du tarif avec le tarif de base actuel
          SetArtPrixVente(AArticle.ART_ID,ATGF_ID, ACOU_ID,cPrixBaseActuel,1);

          // Ajout au CSD
          FTARPRIXVENTE.Append;
          FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := ATGF_ID;
          FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := ACOU_ID;
          FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := cPrixBaseActuel;
          FTARPRIXVENTE.Post;
        end;

        // Non réalisable avec les création d'article en réception auto
        // Code laissé en place pour de futures évolutions du code
        // Y a-t-il un tarif Preco spécifique pour cette taille couleur ?
//        if ATPO_ID <> 0 then
//        begin
//          if FTARVALID.ClientDataSet.Locate('TVD_TGFID;TVD_COUID',VarArrayOf([ATGF_ID,ACOU_ID]),[]) then
//          begin
//            // Mise à jour
//            if CompareValue(FTARVALID.fieldByName('TVD_PX').AsCurrency,FItemList.FieldByName('SALESPRICE').AsCurrency,0.001) <> EqualsValue then
//              UpdTarValid(
//                           FTARVALID.FieldByName('TVD_ID').AsInteger,           //  ATVD_ID: Integer;
//                           ATPO_DT,                                             //  ATVD_DT: TDate;
//                           FItemList.FieldByName('SALESPRICE').AsCurrency //  ATVD_PX: Currency
//                         );
//          end
//          else
//            // Création
//            SetTarValid(
//                         ATPO_ID,                                              // ATVD_TPOID,
//                         0,                                                    // ATVD_TVTID,
//                         AArticle.ART_ID,                                      // ATVD_ARTID,
//                         ATGF_ID,                                              // ATVD_TGFID,
//                         ACOU_ID,                                              // ATVD_COUID : Integer;
//                         FItemList.FieldByName('SALESPRICE').AsCurrency, // ATVD_PX : Currency;
//                         ATPO_DT,                                              // ATVD_DT : TDate;
//                         0                                                     // ATVD_ETAT : Integer
//                       );
//        end;
      end;
    end;
  Except on E:Exception do
    raise Exception.Create('DoTarifVente -> ' + E.Message);
  end;
end;

function TArticleClass.GetFournId(Suppliers: TSuppliers; AERPCODE,
  ACODE: String): Integer;
var
  bFoundFOUID, bFindMode, bDoFindSupplierTbTmp : Boolean;
  sLocateSupplierField, sLocateTbTmpField, sLocateValue : String;
  iPass : Integer;
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
        raise Exception.Create(Format('Fournisseur non trouvé: %s ',[FModelList.FieldByName('SupplierKey').AsString]));
      end;
    end; //case

    if bFindMode then
    begin
      bDoFindSupplierTbTmp := False;

      if Suppliers.IsUpdated then
      begin
        if Suppliers.ClientDataSet.Locate(sLocateSupplierField,sLocateValue,[]) then
        begin
          Result := Suppliers.FieldByName('FOU_ID').AsInteger;
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
          bFoundFOUID := True;
        end
        else begin
          Result := Suppliers.GetSuppliers(sLocateSupplierField,sLocateValue);
          bFoundFOUID := True;
        end;
      end;
    end;
    Inc(iPass);
  end;

end;

function TArticleClass.GetTarifAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID,
  CLG_CENTRALE: Integer): TTarifAchat;
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

function TArticleClass.GetTVAId(TVA_TAUX: single; TVA_CODE: String): integer;
var
 bFound : Boolean;
begin
  try
    if not FTVATable.Active then
      FTVATable.Open;

    With FTVATable do
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
  except on E:Exception do
    raise Exception.Create('GetTvaId -> ' + E.Message);
  end;
end;

procedure TArticleClass.Import;
begin
 //
end;

function TArticleClass.SetARTCodeBarre(ACBI_ARFID, ACBI_TGFID, ACBI_COUID,
  ACBI_TYPE: Integer; ACBI_CB: String): Integer;
begin
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
    IsUpdated := IsUpdated or
                 (FieldByName('FAJOUT').AsInteger > 0) or
                 (FieldByName('FMAJ').AsInteger > 0);
  Except on E:Exception Do
    raise Exception.Create('SetARTCodeBarre -> ' + E.Message);
  end;

end;

function TArticleClass.SetArticle(ART_REFMRK: String; ART_MRKID,
  ART_GREID: INTEGER; ART_NOM, ART_DESCRIPTION, ART_COMMENT5: String; ART_SSFID,
  ART_GTFID, ART_GARID, ARF_TVAID, ARF_ICLID3, ARF_ICLID4, ARF_ICLID5,
  ARF_CATID, ARF_TCTID: INTEGER; ART_CODE, ART_FEDAS: String; ART_PXETIQU,
  ART_ACTID, ART_CENTRALE, ART_PUB: Integer): TArtArticle;
begin
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

function TArticleClass.SetArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID,
  CLG_COUID: Integer; CLG_PX, CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3,
  CLG_TAXE: Single; CLG_PRINCIPAL, CLG_CENTRALE: integer): Integer;
begin
  Try
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_TACHAT_CREATE';
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

      Inc(FArtInscount,FieldByName('FAJOUT').AsInteger);
    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixAchat -> ' + E.Message);
  End;
end;

function TArticleClass.SetArtPrixAchat_Base(CLG_ARTID, CLG_FOUID: Integer;
  CLG_PX, CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3, CLG_TAXE: Single;
  CLG_CENTRALE: Integer): Integer;
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

      IsUpdated := IsUpdated or
                   (FieldByName('FAJOUT').AsInteger > 0) or
                   (FieldByName('FMAJ').AsInteger > 0);

    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixAchat_Base -> ' + E.Message);
  End;
end;

function TArticleClass.SetArtPrixVente(PVT_ARTID, PVT_TGFID, PVT_COUID: Integer;
  PVT_PX: single; PVT_CENTRALE: Integer): Integer;
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
      ParamByName('PVT_TVTID').AsInteger := 0;
      ParamByName('PVT_PX').AsCurrency := PVT_PX;
      ParamByName('PVT_CENTRALE').AsInteger := PVT_CENTRALE;
      Open;

      Inc(FArtInscount, FieldByName('FAJOUT').AsInteger);
    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixVente -> ' + E.Message);
  End;
end;

procedure TArticleClass.SetArtPrixVente_Base(PVT_ARTID: Integer; PVT_PX: single;
  PVT_CENTRALE: Integer);
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
      IsUpdated := IsUpdated or
                   (FieldByName('FAJOUT').AsInteger > 0) or
                   (FieldByName('FMAJ').AsInteger > 0);

    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixVente_Base -> ' + E.Message);
  End;
end;

function TArticleClass.SetARTRelationAxe(ART_ID, SSF_ID: Integer): integer;
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
    IsUpdated := IsUpdated or (FieldByName('FAJOUT').AsInteger > 0);
  end;
end;

function TArticleClass.SetColor(ACOU_ARTID: Integer; ACOU_CODE,
  ACOU_NOM: String; COU_SMU, COU_TDSC: Integer): Integer;
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
    IsUpdated := IsUpdated or
                 (FieldByName('FAJOUT').AsInteger > 0) or
                 (FieldByName('FMAJ').AsInteger > 0);

  Except on E:Exception Do
    raise Exception.Create('SetColor -> ' + E.Message);
  end;
end;

function TArticleClass.SetMrkFourn(AFOUID, AMRKID: Integer): integer;
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

function TArticleClass.SetTailleTrav(TTV_ARTID, TTV_TGFID: Integer): Integer;
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

      //Result := FieldByName('TTV_ID').AsInteger;
    end;
  except on E:Exception do
    raise Exception.Create('SetTailleTrav -> ' + E.Message);
  end;
end;

function TArticleClass.UpdArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID,
  CLG_COUID: Integer; CLG_PX, CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3,
  CLG_TAXE: Single; CLG_PRINCIPAL, CLG_CENTRALE: integer): Integer;
begin
  Try
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_TACHAT_MAJ';
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

      Result := FieldByName('CLG_ID').AsInteger;
      Inc(FArtMajCount,FieldByName('FMAJ').AsInteger);
    end;
  Except on E:Exception do
    Raise Exception.Create('UpdArtPrixAchat -> ' + E.Message);
  End;
end;

end.
