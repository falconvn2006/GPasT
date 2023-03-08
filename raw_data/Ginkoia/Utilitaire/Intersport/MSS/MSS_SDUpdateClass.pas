unit MSS_SDUpdateClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type,
     MSS_SuppliersClass, MSS_BrandsClass, windows, Math, Types, MSS_SizesClass,
     MSS_UniversCriteriaClass, MSS_FedasClass, HttpApp, MSS_CollectionsClass;

type
  TUpdateMode = (umInsert, umUpdate);

  TSDUpdate = Class(TMainClass)
  private
    FCatalogList ,
    FModelList   ,
    FModelRecDateList ,
    FColorList   ,
    FItemList    ,
    FEanList     ,
    FTARCLGFOUNR    ,
    FTARPRIXVENTE   ,
    FTARVALID       ,
    FTAILLETRAV     ,
    FCOULEUR        : TMainClass;


    FDs_CatalogList ,
    FDs_ModelList   ,
    FDs_ModelRecDate ,
    FDs_ColorList   ,
    FDs_ItemList    : TDataSource;

    FMode: TUpdateMode;
    FTVATable: TIboQuery;
    FFournTable: TIboQuery;
    FMarqueTable: TIboQuery;

    FNewArticleList : TStringList;

  public
    procedure Import;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;

    constructor Create;override;
    destructor Destroy;override;

    // fonction de récupération des informations de l'article
    function GetArtInfo(ART_CODE, GTF_CODE, ART_NOM, ART_DESCRIPTION, ART_FEDAS : String; ARF_TVAID, CENTRALE, ART_PUB : Integer) : TArtArticle;
    // fonction permettant de récupérer l'ID fournisseur
    function GetFournId(Suppliers : TSuppliers;AERPCODE, ACODE : String) : Integer;
    // Permet de vérifier que le fournisseur est lié à un modèle
    function CheckFourExistForModel(ART_ID, FOU_ID : Integer) : Boolean;
    // Permet de récupérer l'ID de la TVA
    function GetTVAId(TVA_TAUX : single;TVA_CODE : String = '') : integer;
    // Permet de changer le fournisseur principal à un modèle
    function ChangeFourByModel(ART_ID, OLD_FOUID, NEW_FOUID : Integer) : Boolean;
    // Fonction de gestion des prrix recommandés à date
    function SetTarPreco(TPO_ARTID : Integer; TPO_DT : TDate; TPO_PX : Single; TPO_ETAT : Integer) : Integer;
    // Permet la création de la couleur (Retourne le COU_ID)
    function SetColor(ACOU_ARTID : Integer; ACOU_CODE, ACOU_NOM : String; COU_SMU, COU_TDSC : Integer) : Integer;
    // Création de la relation/Article Taille
    function SetTailleTrav(TTV_ARTID,TTV_TGFID : Integer) : Integer;
    // Procedure qui génére le prix de vente de base et le met à jour s'il existe
    Procedure SetArtPrixVente_Base(PVT_ARTID : Integer;PVT_PX : single;PVT_CENTRALE : Integer);
    // fonction qui génère les prix de vente des articles
    function SetArtPrixVente(PVT_ARTID,PVT_TGFID, PVT_COUID : Integer;PVT_PX : single;PVT_CENTRALE : Integer) : Integer;
    // Permet de créer un CB (Retourne le CBI_ID)
    function SetARTCodeBarre(ACBI_ARFID, ACBI_TGFID, ACBI_COUID,ACBI_TYPE : Integer;ACBI_CB : String) : Integer;
    // Permet de lié la marque au fournisseur
    function SetMrkFourn(AFOUID, AMRKID : Integer) : integer;
    // Permet la création de l'article (Retourne ART_ID et ARF_ID)
    function SetArticle(ART_REFMRK: String; ART_MRKID, ART_GREID : INTEGER;ART_NOM, ART_DESCRIPTION,ART_COMMENT5: String;
                        ART_SSFID, ART_GTFID, ART_GARID, ARF_TVAID, ARF_ICLID3, ARF_ICLID4, ARF_ICLID5, ARF_CATID, ARF_TCTID : INTEGER;
                        ART_CODE, ART_FEDAS : String; ART_PXETIQU, ART_ACTID, ART_CENTRALE, ART_PUB : Integer) : TArtArticle;
    // fonction de liaison le larticle avec la collection
    function SetArtColArt(ART_ID, COL_ID : integer) : integer;
    // fonction de liaison de l'article avec une nomenclature secondaire
    function SetARTRelationAxe(ART_ID, SSF_ID : Integer) : integer;


    // Procedure qui créé le prix d'achat de base d'un article (et le met à jour s'il existe) Retourne Principal
    function SetArtPrixAchat_Base(CLG_ARTID, CLG_FOUID : Integer;CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE : Single;CLG_CENTRALE : Integer) : Integer;
    // Permettant de mettre en mémoire les tarifs d'un article
    function DoGetTarifAchat(AArticle : TArtArticle; AFOU_ID : Integer; ADoEmptyDataSet : Boolean = True) : Boolean;
    function DoGetTarifVente(AArticle : TArtArticle) : Boolean;
    function DoGetTarifPrecoSpe(ATPO_ID : Integer) : Boolean;

    // Fonction de gestion des tarifs d'achat
    function DoTarifAchat(AArticle : TArtArticle; AFOU_ID, ATGF_ID, ACOU_ID : Integer; var ATarifBase : Currency;ARecommandedSalePrice : Currency; AIsFirstTime : Boolean = false) : Boolean;
    // Fonction de gestion des tarifs de vente
    function DoTarifVente(AArticle : TArtArticle; ATGF_ID, ACOU_ID, ATPO_ID : Integer; ATPO_DT : TDate; APrixBase : Currency) : Boolean;
    // Procedure/fonction qui génèrent les prix d'achat des articles (TAILLE COULEUR)
    function SetArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID : Integer;CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE : Single;CLG_PRINCIPAL, CLG_CENTRALE : integer) : Integer;
    function UpdArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID : Integer;CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE : Single;CLG_PRINCIPAL, CLG_CENTRALE : integer) : Integer;
    // fonctions de gestion des prix spécifique recommandé (TARVALID)
    function SetTarValid(ATVD_TPOID, ATVD_TVTID, ATVD_ARTID, ATVD_TGFID, ATVD_COUID : Integer; ATVD_PX : Currency; ATVD_DT : TDate; ATVD_ETAT : Integer) : Integer;
    function UpdTarValid(ATVD_ID : Integer; ATVD_DT : TDate; ATVD_PX : Currency) : Integer;



    // -------------
    // Obsolète : A supprimer les procédures stockées associées quand la modif sera faite dans les commandes
    // -------------
    // Procedure qui créé le prix d'achat de base d'un article (et le met à jour s'il existe) Retounr Principal
//    function SetArtPrixAchat_Base(CLG_ARTID, CLG_FOUID : Integer;CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE : Single;CLG_CENTRALE : Integer) : Integer;
    // Procedure/fonction qui génèrent les prix d'achat des articles (TAILLE COULEUR)
//    function SetArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID : Integer;CLG_PX,CLG_PXNEGO,CLG_PXVI,CLG_RA1,CLG_RA2,CLG_RA3,CLG_TAXE : Single;CLG_PRINCIPAL, CLG_CENTRALE : integer) : Integer;
//    Procedure SetTAchatPxVI(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID, CLG_CENTRALE : Integer;CLG_PXVI : Currency);
    // fonction permettant de retourner les informations de tarifs d'achat d'un modèle
//    function GetTarifAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID, CLG_CENTRALE : Integer) : TTarifAchat;

  published
    property Mode : TUpdateMode read FMode;

    property CatalogList : TMainClass read FCatalogList;
    property ModelList   : TMainClass read FModelList;
    property ColorList   : TMainClass read FColorList;
    property ItemList    : TMainClass read FItemList;
    property EanList     : TMainClass read FEanList;

   Property TVATable        : TIboQuery   read FTVATable    write FTVATable;
   Property MarqueTable     : TIboQuery   read FMarqueTable write FMarqueTable;
   Property FournTable      : TIboQuery   read FFournTable  write FFournTable;

   property NewArtList      : TStringList read FNewArticleList;

  End;

implementation

{ TSDUpdate }

function TSDUpdate.ChangeFourByModel(ART_ID, OLD_FOUID,
  NEW_FOUID: Integer): Boolean;
begin
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * FROM MSS_SDCHANGEFOURPRINC(:ART_ID, :OLD_FOUID, :NEW_FOUID)');
    ParamCheck := True;
    ParamByName('ART_ID').AsInteger := ART_ID;
    ParamByName('OLD_FOUID').AsInteger := OLD_FOUID;
    ParamByName('NEW_FOUID').AsInteger := NEW_FOUID;
    Open;

    Inc(FMajCount,FieldByName('FMAJ').AsInteger);
  end;
end;

function TSDUpdate.CheckFourExistForModel(ART_ID, FOU_ID: Integer): Boolean;
begin
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select count(*) as Resultat from TARCLGFOURN');
    SQL.Add('  join K on K_ID = CLG_ID and K_Enabled = 1');
    SQL.Add('Where CLG_ARTID = :PARTID');
    SQL.Add('  and CLG_FOUID = :PFOUID');
    ParamCheck := True;

    ParamByName('PARTID').AsInteger := ART_ID;
    ParamByName('PFOUID').AsInteger := FOU_ID;
    Open;

    Result := FieldByName('Resultat').AsInteger > 0;
  end;
end;

constructor TSDUpdate.Create;
begin
  inherited Create;
  FCatalogList := TMainClass.Create;
  FCatalogList.Title := 'CatalogList';
  FModelList   := TMainClass.Create;
  FModelList.Title := 'ModelList';
  FModelRecDateList := TMainClass.Create;
  FModelRecDateList.Title := 'ModelRecDate';
  FColorList   := TMainClass.Create;
  FColorList.Title := 'ColorList';
  FItemList    := TMainClass.Create;
  FItemList.Title := 'ItemList';
  FEanList := TMainClass.Create;
  FEanList.Title := 'EanList';
  FTARCLGFOUNR    := TMainClass.Create;
  FTARPRIXVENTE   := TMainClass.Create;
  FTARVALID       := TMainClass.Create;
  FTAILLETRAV     := TMainClass.Create;
  FCOULEUR        := TMainClass.Create;

  FNewArticleList := TStringList.Create;

  FDs_CatalogList := TDataSource.Create(nil);
  FDs_CatalogList.DataSet := FCatalogList.ClientDataSet;

  FDs_ModelList := TDataSource.Create(nil);
  FDs_ModelList.DataSet := FModelList.ClientDataSet;

  FDs_ModelRecDate := TDataSource.Create(nil);
  FDs_ModelRecDate.DataSet := FModelRecDateList.ClientDataSet;

  FDs_ColorList := TDataSource.Create(nil);
  FDs_ColorList.DataSet := FColorList.ClientDataSet;

  FDs_ItemList := TDataSource.Create(nil);
  FDs_ItemList.DataSet := FItemList.ClientDataSet;
end;

destructor TSDUpdate.Destroy;
begin
  FCatalogList.Free;
  FModelList.Free;
  FModelRecDateList.Free;
  FColorList.Free;
  FItemList.Free;
  FEanList.Free;
  FTARCLGFOUNR.Free;
  FTARPRIXVENTE.Free;
  FTARVALID.Free;
  FTAILLETRAV.Free;
  FCOULEUR.Free;

  FNewArticleList.Free;

  FDs_CatalogList.Free;
  FDs_ModelList.Free;
  FDs_ModelRecDate.Free;
  FDs_ColorList.Free;
  FDs_ItemList.Free;

  inherited;
end;

function TSDUpdate.DoGetTarifAchat(AArticle: TArtArticle; AFOU_ID: Integer;
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

function TSDUpdate.DoGetTarifPrecoSpe(ATPO_ID: Integer): Boolean;
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

function TSDUpdate.DoGetTarifVente(AArticle: TArtArticle): Boolean;
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

function TSDUpdate.DoMajTable(ADoMaj: Boolean): Boolean;
var
  bContinue, bFound : Boolean;
  FOU_ID,
  FOU_ID_PRINCIPAL,
  SSF_ID_UNIC, SSF_ID_FEDAS,
  FOU_ID_SECONDAIRE, TVA_ID, COU_ID, TGF_ID, TCT_ID, ACT_ID, COL_ID : Integer;
  iPrincipal : Integer;
  DoChangeFournPrinc : Boolean;
  i : Integer;

  Univers : TUniversCriteria;
  Fedas : TFedas;
  Suppliers : TSuppliers;
  Collections : TCollections;

  Brands : TBrands;
  Sizes : TSizes;
  Article : TArtArticle;
  DoMode : TUpdateMode;
  MRK_NOM, sError : String;

  bFouAlreadyExist, bDoTarifBase : Boolean;
  bFoundSSFUNIC, bFoundSSFFEDAS : Boolean;
  bDoFindBrandTbTmp : Boolean;

  TarifAchat : TTarifAchat;

  Begintime, endtime,TickPerSec : int64;
  iTmp, iTmp2, iTmp3 : Int64;

  bAsRecommanded : Boolean;
  dRecommandedDate : TDate;
  cGetTAchatBase ,
  cGetTVenteBase ,
  cRecommendedPrice : Currency;
  TPO_ID : Integer;
  bFirstTarifAchat ,
  bFirstTarifVente : Boolean;
begin

  {$REGION 'Initialisation'}
  IsCreated := False;
  IsUpdated := False;

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

    if MasterData[i].MainData.InheritsFrom(TFedas) then
      Fedas := TFedas( MasterData[i].MainData);
//    if MasterData[i].MainData.InheritsFrom(TPeriods) then
//      Periods := TPeriods(MasterData[i].MainData);
//
    if MasterData[i].MainData.InheritsFrom(TCollections) then
      Collections := TCollections(MasterData[i].MainData);
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

//  case FMode of
//    umInsert: FErrLogs.Add('Mode Insert');
//    umUpdate: FErrLogs.Add('Mode Update');
//  end;

  FCatalogList.First;
  while not FCatalogList.EOF do
  begin
    Try
      {$REGION 'Recherche du fournisseur'}
      FOU_ID := GetFournId(Suppliers,FCatalogList.FieldByName('AddSupplierERP').AsString,FCatalogList.FieldByName('AddSupplierKey').AsString);
      {$ENDREGION}

      FModelList.First;
      while not FModelList.EOF do
      begin
        Try
          DoChangeFournPrinc := False;
          bContinue := True;
          DoMode := FMode;

          TVA_ID := GetTVAID(FModelList.FieldByName('VAT').AsSingle,'');

          // Recherche du model
          With FModelList do
          begin
            Article := GetArtInfo(FieldByName('MODELNUMBER').AsString + FieldByName('BRANDNUMBER').AsString,
                                  FieldByName('SIZERANGE').AsString,
                                  FieldByName('DENOTATION').AsString,
                                  FieldByName('DENOTATIONLONG').AsString,
                                  FieldByName('FEDAS').AsString,
                                  TVA_ID,
                                  1,
                                  FModelList.FieldByName('PUB').AsInteger);

            if Brands.ClientDataSet.Locate('CodeMarque',FieldByName('BRANDNUMBER').AsString,[loCaseInsensitive]) then
              MRK_NOM := Brands.FieldByName('Denotation').asString;

            if (DoMode = umUpdate) and (Article.ART_ID = -1) then
              raise Exception.Create('Fichier en mode mise à jour - article non trouvé');

          end;
          bDoTarifBase := True;



          {$REGION 'Recherche de la sousfamille via la FEDAS'}
            // recherche par l'universcritéria
//            QueryPerformanceCounter(BeginTime);
//            iTmp  := -1;
//            iTmp2 := -1;
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
//                    iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//                    iTmp2 := -1;
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
                SQL.Add('  join NKLAXEAXE on (AXX_SSFID2 = SSF_ID or AXX_SSFID1 = SSF_ID)');
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
//              iTmp2 := Round((EndTime - BeginTime) / TickPerSec * 1000);
            end;
          {$ENDREGION}

          // gestion de l'insertion
          if DoMode = umInsert then
          begin
            if Article.ART_ID = -1 then
            begin

              {$REGION 'Recherche du brands (Marque)'}
              bDoFindBrandTbTmp := False;
    //          iTmp  := -1;
    //          iTmp2 := -1;
    //          iTmp3 := -1;

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
    //                iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);

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
                begin
                  Article.MRK_ID := FMarqueTable.FieldByName('MRK_ID').AsInteger;
                  MRK_NOM := FMarqueTable.FieldByName('MRK_NOM').AsString;
                end
                else begin
                  if FMarqueTable.Locate('MRK_CODE',FModelList.FieldByName('BrandNumber').AsString,[]) then
                  begin
                    Article.MRK_ID := FMarqueTable.FieldByName('MRK_ID').AsInteger;
                    MRK_NOM := FMarqueTable.FieldByName('MRK_NOM').AsString;
    //                QueryPerformanceCounter(EndTime);
    //                QueryPerformanceFrequency(TickPerSec);
    //                iTmp2 := Round((EndTime - BeginTime) / TickPerSec * 1000);
                  end
                  else begin
                    if Brands.ClientDataSet.Locate('CodeMarque',FModelList.FieldByName('BrandNumber').AsString,[loCaseInsensitive]) then
                    begin
                      // On recherche dans la base et on créé au cas où
                      Article.MRK_ID := Brands.GetBrands;
                      MRK_NOM := Brands.FieldByName('denotation').AsString;
                    end
                    else
                      raise Exception.Create('BrandNumber inéxistant : ' + FModelList.FieldByName('BrandNumber').AsString);
    //                QueryPerformanceCounter(EndTime);
    //                QueryPerformanceFrequency(TickPerSec);
    //                iTmp3 := Round((EndTime - BeginTime) / TickPerSec * 1000);
                  end;
                end;
              end;
              {$ENDREGION}

              {$REGION 'Traitement de la liaison de la marque avec le fournisseur'}
               SetMrkFourn(FOU_ID,Article.MRK_ID);
              {$ENDREGION}

              {$REGION 'Récupération de la grille de taille de l''article'}
              // récupération dans les tables en mémoire
    //          QueryPerformanceCounter(BeginTime);
    //          iTmp := -1;
    //          iTmp2 := -1;
    //          iTmp3 := -1;
              bFound := False;
              if Sizes.IsUpdated then
              begin
                if (Sizes.PLXGTF.FieldByName('ID').AsString = FModelList.FieldByName('SizeRange').AsString) and
                   (Sizes.PLXGTF.FieldByName('GTF_ID').AsInteger > 0) then
                  Article.GTF_ID := Sizes.PLXGTF.FieldByName('GTF_ID').AsInteger
                else begin
                  if Sizes.PLXGTF.ClientDataSet.Locate('ID',FModelList.FieldByName('SizeRange').AsString,[loCaseInsensitive]) then
                  begin
    //                QueryPerformanceCounter(EndTime);
    //                QueryPerformanceFrequency(TickPerSec);
    //                iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
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
    //              iTmp2 := Round((EndTime - BeginTime) / TickPerSec * 1000);
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
    //                iTmp3 := Round((EndTime - BeginTime) / TickPerSec * 1000);

                    if not bFound then
                      raise Exception.Create(Format('Grille de taille Inéxistante %s',[FModelList.FieldByName('SizeRange').AsString]));
                  end;
                end;
              end;
              {$ENDREGION}

              {$REGION 'Génération de l''article'}
    //          QueryPerformanceCounter(BeginTime);
              Article := SetArticle(
                FModelList.FieldByName('MODELNUMBER').AsString, // ART_REFMRK
                Article.MRK_ID, // ART_MRKID,
                0, // ART_GREID: INTEGER;
                FModelList.FieldByName('DENOTATION').AsString, // ART_NOM,
                FModelList.FieldByName('DENOTATIONLONG').AsString, // ART_DESCRIPTION,
                FModelList.FieldByName('FEDAS').AsString, // ART_COMMENT5: String;
                SSF_ID_FEDAS, // ART_SSFID,
                Article.GTF_ID, // ART_GTFID,
                0, // ART_GARID,
                TVA_ID, // ARF_TVAID,
                0,//FColorItemList.FieldByName('ARF_ICLID3').AsInteger, //ARF_ICLID3,
                0, //FColorItemList.FieldByName('ARF_ICLID4' ).AsInteger, //ARF_ICLID4,
                0, // ARF_ICLID5,
                0, // ARF_CATID,
                TCT_ID, // ARF_TCTID: INTEGER
                FModelList.FieldByName('MODELNUMBER').AsString + FModelList.FieldByName('BRANDNUMBER').AsString, // ART_CODE
                FModelList.FieldByName('FEDAS').AsString, // ART_FEDAS
                0, // ART_PXETIQU
                ACT_ID, // ART_ACTID
                FModelList.FieldByName('MODELTYPE').AsInteger,
                FModelList.FieldByName('PUB').AsInteger
              );

              // Assignation du fournisseur principal
              FOU_ID_PRINCIPAL := FOU_ID;
              {$ENDREGION}
            end
            else
              DoMode := umUpdate;
          end;

          SetARTRelationAxe(Article.ART_ID,SSF_ID_UNIC);

          // Gestion de l'update
          if DoMode = umUpdate then
          begin
              if Article.ART_ID <> -1 then
              begin
                // est ce que le fournisseur principal a changé ?
                FOU_ID_PRINCIPAL := Article.FOU_ID;
                if FOU_ID_PRINCIPAL <> FOU_ID then
                begin
                  // est ce que le founisseur est déjà lié au le modèle ?
                  bFouAlreadyExist := CheckFourExistForModel(Article.ART_ID,FOU_ID);
                  if not bFouAlreadyExist then
                    SetMrkFourn(FOU_ID,Article.MRK_ID);
                  DoChangeFournPrinc := True;
                  FOU_ID_PRINCIPAL := FOU_ID;
                end;
              end
              else begin
                With FModelList do
                  raise Exception.Create('Modèle non trouvé : Grille ' + FieldByName('SIZERANGE').AsString);
              end;
          end;

          {$REGION 'Gestion du fournisseur secondaire'}
          FOU_ID_SECONDAIRE := -1;
          if (FModelList.FieldByName('SUPPLIER2ERP').AsString <> FCatalogList.FieldByName('AddSupplierERP').AsString) and
             (FModelList.FieldByName('SUPPLIER2KEY').AsString <> FCatalogList.FieldByName('AddSupplierKey').AsString) then
            FOU_ID_SECONDAIRE := GetFournId(Suppliers,FModelList.FieldByName('SUPPLIER2ERP').AsString,FModelList.FieldByName('SUPPLIER2KEY').AsString);
              // Gestion 2em fournisseur
          if FOU_ID_SECONDAIRE <> -1 then
          begin
//            QueryPerformanceCounter(BeginTime);
            SetMrkFourn(FOU_ID_SECONDAIRE,Article.MRK_ID);
//            QueryPerformanceCounter(EndTime);
//            QueryPerformanceFrequency(TickPerSec);
//            iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
//            FErrLogs.Add(Format('SetMrkFourn 2em : %d',[iTmp]));
          end;
          {$ENDREGION}

          {$REGION 'Récupération du tarif d''achat de base'}
//          if Article.FAjout = 0 then
//          begin
//            With FIboQuery do
//            begin
//              Close;
//              SQL.Clear;
//              SQL.Add('Select CLG_PX, CLG_PRINCIPAL from TARCLGFOURN');
//              SQL.Add('  join K on K_ID = CLG_ID and K_Enabled = 1');
//              SQL.Add('Where CLG_ARTID = :PARTID');
//              SQL.Add('  and CLG_FOUID = :PFOUID');
//              SQL.Add('  and CLG_TGFID = 0 and CLG_COUID = 0');
//              ParamCheck := True;
//              ParamByName('PARTID').AsInteger := Article.ART_ID;
//              ParamByName('PFOUID').AsInteger := FOU_ID_PRINCIPAL;
//              Open;
//
//              if RecordCount > 0 then
//              begin
//                cGetTAchatBase := FieldByName('CLG_PX').AsCurrency;
//                iPrincipal := FieldByName('CLG_PRINCIPAL').AsInteger;
//              end
//              else
//                bDoTarifBase := True;
//            end;
//          end;
          {$ENDREGION}

          {$REGION 'Gestion de la FEDAS'}
          if Article.FMaj >= 1 then
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

          {$REGION 'Récupération du plus petit prix de vente'}
          FColorList.First;
          cGetTVenteBase := FItemList.FieldByName('RETAILPRICE').AsCurrency;
          while Not FColorList.EOF do
          begin
            if bDoTarifBase then
            begin
              FItemList.first;
              while not FItemLisT.EOF do
              begin
                if (cGetTVenteBase > FItemList.FieldByName('RETAILPRICE').AsCurrency) and
                   (FItemList.FieldByName('RETAILPRICE').AsCurrency <> 0) then
                  cGetTVenteBase := FItemList.FieldByName('RETAILPRICE').AsCurrency;
                FItemList.Next;
              end;
            end;
            FColorList.Next;
          end;
          {$ENDREGION}

          {$REGION 'Gestion Prix recommandé à date'}
          // On ne gère les prix recommandés que s'il n'y a pas d'ajout d'article
          // On ne traite que les dates recommandées supérieures à la date du jour
          bAsRecommanded := False;
          FModelRecDateList.First;
          while not FModelRecDateList.EOF do
          begin
            if (FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime > Now) and
               ((Article.FAjout = 0) or (CompareValue(FModelRecDateList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,cGetTVenteBase,0.001) <> EqualsValue)) then
            begin
              TPO_ID := SetTarPreco(Article.ART_ID, FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime,FModelRecDateList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency,0);
              bAsRecommanded := True;
              FModelRecDateList.ClientDataSet.Edit;
              FModelRecDateList.FieldByName('TPO_ID').AsInteger := TPO_ID;
              FModelRecDateList.Post;
            end;
            FModelRecDateList.Next;
          end; // while

          if bAsRecommanded then
          begin
            // On cherche le prix recommandé le plus proche de la date du jour
            // afin de déterminer le prix de base du modèle
            FModelRecDateList.ClientDataSet.Filtered := False;
            FModelRecDateList.ClientDataSet.Filter := 'TPO_ID <> 0';
            FModelRecDateList.ClientDataSet.Filtered := True;
            FModelRecDateList.First;
            dRecommandedDate := FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime;
            while not FModelRecDateList.EOF do
            begin
              if CompareDate(dRecommandedDate,FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime) < GreaterThanValue then
              begin
                TPO_ID := FModelRecDateList.FieldByName('TPO_ID').AsInteger;
                dRecommandedDate := FModelRecDateList.FieldByName('RECOMMENDEDSALESDATE').AsDateTime;
                cRecommendedPrice := FModelRecDateList.FieldByName('RECOMMENDEDSALESPRICE').AsCurrency;
              end;
              FModelRecDateList.Next;
            end;

          end;
          {$ENDREGION}

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

          FColorList.First;
          while Not FColorList.EOF do
          begin
            FItemList.First;
            while not FItemList.EOF do
            begin

              {$REGION 'Création/Modification de la couleur'}
//              QueryPerformanceCounter(BeginTime);
              if FColorList.FieldByName('COU_ID').AsInteger <= 0 then
              begin
                COU_ID := SetColor(Article.ART_ID,
                                   FColorList.FieldByName('COLORNUMBER').AsString,
                                   FColorList.FieldByName('COLORDENOTATION').AsString,
                                   FItemList.FieldByName('SMU').AsInteger,
                                   FItemList.FieldByName('TDSC').AsInteger);

                FColorList.ClientDataSet.Edit;
                FColorList.FieldByName('COU_ID').AsInteger := COU_ID;
                FColorList.ClientDataSet.Post;
              end
              else
                COU_ID := FColorList.FieldByName('COU_ID').AsInteger;
//              QueryPerformanceCounter(EndTime);
//              QueryPerformanceFrequency(TickPerSec);
//              iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
              {$ENDREGION}

              {$REGION 'Récupération de la taille'}
              bFound := False;
//              QueryPerformanceCounter(BeginTime);
//              iTmp := -1;
//              iTmp2 := -1;
//              iTmp3 := -1;
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
//                          QueryPerformanceCounter(EndTime);
//                          QueryPerformanceFrequency(TickPerSec);
//                          iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
                    bFound := not (TGF_ID <= 0);
                  end;
                end;
              end;

              if not bFound then
              begin
//                QueryPerformanceCounter(BeginTime);
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
                  ParamByName('PCOLUMNX').AsString := FItemList.FieldByName('Columnx').AsString;
                  Open;
//                        QueryPerformanceCounter(EndTime);
//                        QueryPerformanceFrequency(TickPerSec);
//                        iTmp2 := Round((EndTime - BeginTime) / TickPerSec * 1000);

                  if RecordCount > 0 then
                    TGF_ID := FieldByName('TGF_ID').AsInteger
                  else begin
                    bFound := False;
//                    QueryPerformanceCounter(BeginTime);
                    if Sizes.PLXGTF.ClientDataSet.Locate('ID',FModelList.FieldByName('SizeRange').AsString,[loCaseInsensitive]) then
                      if Sizes.PLXTYPEGT.ClientDataSet.Locate('ID',Sizes.PLXGTF.FieldByName('MSRID').AsString,[loCaseInsensitive]) then
                        if Sizes.PLXTAILLESGF.ClientDataSet.Locate('SRID;Columnx',VarArrayof([FModelList.FieldByName('SizeRange').AsString,FItemList.FieldByName('Columnx').AsString]),[loCaseInsensitive]) then
                        begin
                          TGF_ID := Sizes.GetSizes;
                          bFound := True;
                        end;
//                      QueryPerformanceCounter(EndTime);
//                      QueryPerformanceFrequency(TickPerSec);
//                      iTmp3 := Round((EndTime - BeginTime) / TickPerSec * 1000);

                    if not bFound then
                      raise Exception.Create(Format('Taille Inéxistante : Grille %s / Taille %s',[FModelList.FieldByName('SizeRange').AsString,FItemList.FieldByName('Columnx').AsString]));
                  end;
                end;
              end;
              {$ENDREGION}

              {$REGION 'Gestion de la relation Taille/Article'}
              if Article.FAjout > 0 then
              begin
                SetTailleTrav(Article.ART_ID,TGF_ID);
              end;
              {$ENDREGION}

              {$REGION 'Gestion des tarifs de vente'}
              // On ne gère les tarifs de vente que s'il y a un tarif recommandé
              if bAsRecommanded or (Article.FAjout > 0) then
              begin
                if not bFirstTarifVente then
                begin
                  cGetTVenteBase := FItemList.FieldByName('RETAILPRICE').AsCurrency;
                  DoTarifVente(Article,TGF_ID, COU_ID, TPO_ID, dRecommandedDate, cGetTVenteBase);
                  bFirstTarifVente := True;
                end
                else
                  DoTarifVente(Article,TGF_ID, COU_ID, TPO_ID, dRecommandedDate, cGetTVenteBase);
              end;
              {$ENDREGION}

              {$REGION 'Gestion des tarifs d''achat'}
              // Cas du premier tarif d'achat de la liste
              if bAsRecommanded or (Article.FAjout > 0) then
              begin
                // On ne gère les tarifs d'achat que s'il y a un tarif recommandé
                if not bFirstTarifAchat then
                begin
                  cGetTAchatBase := FItemList.FieldByName('PURCHASEPRICE').AsCurrency;
                  DoTarifAchat(Article,FOU_ID,TGF_ID,COU_ID,cGetTAchatBase,cGetTVenteBase, True);
                  if (FOU_ID_SECONDAIRE <> -1) and (FOU_ID <> FOU_ID_SECONDAIRE) then
                    DoTarifAchat(Article,FOU_ID_SECONDAIRE,TGF_ID,COU_ID,cGetTAchatBase,cGetTVenteBase,True);

                  bFirstTarifAchat := True;
                end
                else begin
                  DoTarifAchat(Article,FOU_ID,TGF_ID,COU_ID,cGetTAchatBase,cGetTVenteBase);
                  if (FOU_ID_SECONDAIRE <> -1) and (FOU_ID <> FOU_ID_SECONDAIRE) then
                    DoTarifAchat(Article,FOU_ID_SECONDAIRE,TGF_ID,COU_ID,cGetTAchatBase,cGetTVenteBase);
                end;
              end;
              {$ENDREGION}

              {$REGION 'Gestion des CB'}
              i := 0;
//              QueryPerformanceCounter(BeginTime);
              // Création du CB Ginkoia
              // -1 sur le CBI_CB pour indiquer qu'il faut générer le CB (Utile que pour le type 1 ici)
              SetARTCodeBarre(Article.ARF_ID,TGF_ID,COU_ID,1,'-1');
              Inc(i);
              // Création du CB
              if FItemList.FieldByName('EAN').AsString <> '' then
              begin
                SetARTCodeBarre(Article.ARF_ID,TGF_ID,COU_ID,3,FItemList.FieldByName('EAN').AsString);
                Inc(i);
              end;

              // Gestion de la liste des EAN
              FEanList.First;
              while not FEanList.Eof do
              begin
                if Trim(FEanList.FieldByName('EANLIST').AsString) <> '' then
                begin
                  SetARTCodeBarre(Article.ARF_ID,TGF_ID,COU_ID,3,FEanList.FieldByName('EANLIST').AsString);
                  Inc(i);
                end;
                FEanList.Next;
              end;
//              QueryPerformanceCounter(EndTime);
//              QueryPerformanceFrequency(TickPerSec);
//              iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
              {$ENDREGION}

              {$REGION 'Gestion de la collection'}
              If Collections.ClientDataSet.Locate('code',FItemList.FieldByName('CODECOLL').AsString,[]) then
              begin
                COL_ID := Collections.GetCollectionID;
                SetArtColArt(Article.ART_ID,COL_ID);
              end;
              {$ENDREGION}

              FItemList.Next;
            end; // while Itemlist

            FColorList.Next;
          end; // while    colorlist

        Except on E:Exception do
          begin
            FErrLogs.Add(FModelList.FieldByName('MODELNUMBER').AsString + FModelList.FieldByName('BRANDNUMBER').AsString + ' => ' + E.MEssage);
            IsOnError := True;
          end;
        End;

        if DoChangeFournPrinc then
        begin
          // On change le fournisseur principal
          ChangeFourByModel(Article.ART_ID, Article.FOU_ID, FOU_ID_PRINCIPAL);
        end;

        if IsCreated or IsUpdated or IsOnError then
        begin
          if IsOnError then
            sError := 'ERROR'
          else
            sError := '';

          FNewArticleList.Add('<tr>');
          FNewArticleList.Add(Format('<td class="CODEART-LG%s">%s</td>',[sError,FModelList.FieldByName('MODELNUMBER').AsString]));
          FNewArticleList.Add(Format('<td class="CHRONO-LG%s">%s</td>',[sError, Article.Chrono]));
          FNewArticleList.Add(Format('<td class="ARTNOM-LG%s">%s</td>',[sError, FModelList.FieldByName('DENOTATION').AsString]));
          FNewArticleList.Add(Format('<td class="MARQUE-LG%s">%s</td>',[sError,MRK_NOM]));
          if IsCreated then
            FNewArticleList.Add(Format('<td class="ETAT-LG%s">Création</td>',[sError]))
          else
            FNewArticleList.Add(Format('<td class="ETAT-LG%s">Mise à jour</td>',[sError]));
          FNewArticleList.Add('</tr>');

          IsOnError := False;
        end;

        {$REGION 'Vérification et création des codes barres des tailles/couleurs manquante de type 1'}
        With FIboQuery do
        begin
          // récupération des tailles travaillé du modèle
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

          // Récupéation des couleurs du modèle
          Close;
          SQL.Clear;
          SQL.Add('Select COU_ID FROM PLXCOULEUR');
          SQL.Add('  Join K on K_ID = COU_ID and K_Enabled = 1');
          SQL.Add('Where COU_ARTID = :PARTID');
          ParamCheck := True;
          ParamByName('PARTID').AsInteger := Article.ART_ID;
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
              SetARTCodeBarre(Article.ARF_ID,FTAILLETRAV.FieldByName('TTV_TGFID').AsInteger,FCOULEUR.FieldByName('COU_ID').AsInteger,1,'-1');
              FTAILLETRAV.Next;
            end;
            FCOULEUR.Next;
          end;
        end;
        {$ENDREGION}

        FModelList.Next;

      end; // While ModelList
    Except on E:Exception do
      begin
        FErrLogs.Add(E.Message);
        IsOnError := True;
      end;
    end; // While Cataloglist


    FCatalogList.Next;
  end;
end;

function TSDUpdate.DoTarifAchat(AArticle: TArtArticle; AFOU_ID, ATGF_ID,
  ACOU_ID: Integer; var ATarifBase: Currency;ARecommandedSalePrice : Currency; AIsFirstTime: Boolean): Boolean;
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
                              ARecommandedSalePrice, // CLG_PXVI,
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
                                  ARecommandedSalePrice, // CLG_PXVI,
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
        // Création du tarif de base
        iPRINCIPAL := SetArtPrixAchat_Base(
                              AArticle.ART_ID,                                             // CLG_ARTID
                              AFOU_ID,                                                     // CLG_FOUID : Integer;
                              FItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PX,
                              FItemList.FieldByName('PURCHASEPRICE').AsCurrency,     // CLG_PXNEGO,
                              ARecommandedSalePrice, // CLG_PXVI,
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
            CLG_ID := UpdArtPrixAchat(AArticle.ART_ID,AFOU_ID,ATGF_ID,ACOU_ID,FitemList.FieldByName('PURCHASEPRICE').AsCurrency,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,ARecommandedSalePrice,0,0,0,0,iPRINCIPAL,1);
            // et on met à jour la table en mémoire
            FTARCLGFOUNR.ClientDataSet.Edit;
            FTARCLGFOUNR.FieldByName('CLG_PX').AsCurrency := FItemList.FieldByName('PURCHASEPRICE').AsCurrency;
            FTARCLGFOUNR.Post;
           end;
          end
          else begin
            // Non, alors on créé le tarif spécifique
            CLG_ID := SetArtPrixAchat(AArticle.ART_ID,AFOU_ID,ATGF_ID,ACOU_ID,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,ARecommandedSalePrice,0,0,0,0,iPRINCIPAL,1);
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
            CLG_ID := UpdArtPrixAchat(AArticle.ART_ID,AFOU_ID,ATGF_ID,ACOU_ID,CompareTarif,CompareTarif,ARecommandedSalePrice,0,0,0,0,iPRINCIPAL,1);
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
              CLG_ID := SetArtPrixAchat(AArticle.ART_ID,AFOU_ID,ATGF_ID,ACOU_ID,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,FItemList.FieldByName('PURCHASEPRICE').AsCurrency,ARecommandedSalePrice,0,0,0,0,iPRINCIPAL,1);
        end;
      end;
    end;
    Result := True;
  Except on E:Exception do
    raise Exception.Create('DoTarifAchat -> ' + E.Message);
  end;

end;

function TSDUpdate.DoTarifVente(AArticle: TArtArticle; ATGF_ID, ACOU_ID,
  ATPO_ID: Integer; ATPO_DT: TDate; APrixBase : Currency): Boolean;
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
      if CompareValue(APrixBase,FItemList.FieldByName('RETAILPRICE').AsCurrency) <> EqualsValue then
      begin
        // Oui alors on crée un tarif spécifique
        SetArtPrixVente(AArticle.ART_ID,ATGF_ID, ACOU_ID,FItemList.FieldByName('RETAILPRICE').AsCurrency,1);

        // Ajout au CSD
        FTARPRIXVENTE.Append;
        FTARPRIXVENTE.FieldByName('PVT_TGFID').AsInteger := ATGF_ID;
        FTARPRIXVENTE.FieldByName('PVT_COUID').AsInteger := ACOU_ID;
        FTARPRIXVENTE.FieldByName('PVT_PX').AsCurrency := FItemList.FieldByName('RETAILPRICE').AsCurrency;
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
      if CompareValue(APrixBase,FItemList.FieldByName('RETAILPRICE').AsCurrency) <> EqualsValue then
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

        // Y a-t-il un tarif Preco spécifique pour cette taille couleur ?
        if ATPO_ID <> 0 then
        begin
          if FTARVALID.ClientDataSet.Locate('TVD_TGFID;TVD_COUID',VarArrayOf([ATGF_ID,ACOU_ID]),[]) then
          begin
            // Mise à jour
            if CompareValue(FTARVALID.fieldByName('TVD_PX').AsCurrency,FItemList.FieldByName('RETAILPRICE').AsCurrency,0.001) <> EqualsValue then
              UpdTarValid(
                           FTARVALID.FieldByName('TVD_ID').AsInteger,           //  ATVD_ID: Integer;
                           ATPO_DT,                                             //  ATVD_DT: TDate;
                           FItemList.FieldByName('RETAILPRICE').AsCurrency //  ATVD_PX: Currency
                         );
          end
          else
            // Création
            SetTarValid(
                         ATPO_ID,                                              // ATVD_TPOID,
                         0,                                                    // ATVD_TVTID,
                         AArticle.ART_ID,                                      // ATVD_ARTID,
                         ATGF_ID,                                              // ATVD_TGFID,
                         ACOU_ID,                                              // ATVD_COUID : Integer;
                         FItemList.FieldByName('RETAILPRICE').AsCurrency, // ATVD_PX : Currency;
                         ATPO_DT,                                              // ATVD_DT : TDate;
                         0                                                     // ATVD_ETAT : Integer
                       );
        end;
      end;
    end;
  Except on E:Exception do
    raise Exception.Create('DoTarifVente -> ' + E.Message);
  end;
end;

function TSDUpdate.GetArtInfo(ART_CODE, GTF_CODE, ART_NOM,
  ART_DESCRIPTION, ART_FEDAS : String; ARF_TVAID, CENTRALE, ART_PUB: Integer): TArtArticle;
begin
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_SDUGETARTINFO(:ART_CODE, :GTF_CODE, :ART_NOM, :ART_DESCRIPTION, :ART_FEDAS, :ARF_TVAID, :CENTRALE, :ART_PUB)');
    ParamCheck := True;
    ParamByName('ART_CODE').AsString := ART_CODE;
    ParamByName('GTF_CODE').AsString := GTF_CODE;
    ParamByName('ART_NOM').AsString  := ART_NOM;
    ParamByName('ART_DESCRIPTION').AsString := ART_DESCRIPTION;
    ParamByName('ART_FEDAS').AsString       := ART_FEDAS;
    ParamByName('ARF_TVAID').AsInteger := ARF_TVAID;

    case CENTRALE of
      1: ParamByName('CENTRALE').AsInteger := 1;
      2: ParamByName('CENTRALE').AsInteger := 5;
      3: ParamByName('CENTRALE').AsInteger := 0;
      else
        raise Exception.Create(Format('Model Type non géré %d',[CENTRALE]));
    end;
    ParamByName('ART_PUB').AsInteger := ART_PUB;
    Open;

    Result.ART_ID := FieldByName('ART_ID').AsInteger;
    Result.ARF_ID := FieldByName('ARF_ID').AsInteger;
    Result.GTF_ID := FieldByName('GTF_ID').AsInteger;
    Result.MRK_ID := FieldByName('MRK_ID').AsInteger;
    Result.SSF_ID := FieldByName('SSF_ID').AsInteger;
    Result.ACT_ID := FieldByName('ACT_ID').AsInteger;
    Result.FOU_ID := FieldByName('FOU_ID').AsInteger;
    Result.FAjout := FieldByName('FAJOUT').AsInteger;
    Result.FMaj   := FieldByName('FMAJ').AsInteger;
    Result.Chrono := FieldByName('CHRONO').AsString;

    Inc(FMajCount,FieldByName('FMAJ').AsInteger);
  end;
end;

function TSDUpdate.GetFournId(Suppliers : TSuppliers;AERPCODE, ACODE: String): Integer;
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
//      QueryPerformanceCounter(BeginTime);
//      iTmp  := -1;
//      iTmp2 := -1;
//      iTmp3 := -1;
      if Suppliers.IsUpdated then
      begin
        if Suppliers.ClientDataSet.Locate(sLocateSupplierField,sLocateValue,[]) then
        begin
//          QueryPerformanceCounter(EndTime);
//          QueryPerformanceFrequency(TickPerSec);
//          iTmp := Round((EndTime - BeginTime) / TickPerSec * 1000);
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
//          QueryPerformanceCounter(EndTime);
//          QueryPerformanceFrequency(TickPerSec);
//          iTmp2 := Round((EndTime - BeginTime) / TickPerSec * 1000);
        end
        else begin
          Result := Suppliers.GetSuppliers(sLocateSupplierField,sLocateValue);
          bFoundFOUID := True;
//          QueryPerformanceCounter(EndTime);
//          QueryPerformanceFrequency(TickPerSec);
//          iTmp3 := Round((EndTime - BeginTime) / TickPerSec * 1000);
        end;
      end;
    end;
    Inc(iPass);
  end;
end;

//function TSDUpdate.GetTarifAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID,
//  CLG_CENTRALE: Integer): TTarifAchat;
//begin
//  With FIboQuery do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Add('Select CLG_PX, CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3, CLG_TAXE, CLG_PRINCIPAL, CLG_CENTRALE from TARCLGFOURN');
//    SQL.Add('  join K on K_ID = CLG_ID and K_Enabled = 1');
//    SQL.Add('Where CLG_ARTID = :PARTID');
//    SQL.Add('  and CLG_FOUID = :PFOUID');
//    SQL.Add('  and CLG_TGFID = :PTGFID and CLG_COUID = :PCOUID');
//    if CLG_CENTRALE <> -1 then
//      SQL.Add('  and CLG_CENTRALE = :PCLGCENTRALE');
//    ParamCheck := True;
//    ParamByName('PARTID').AsInteger := CLG_ARTID;
//    ParamByName('PFOUID').AsInteger := CLG_FOUID;
//    ParamByName('PTGFID').AsInteger := CLG_TGFID;
//    ParamByName('PCOUID').AsInteger := CLG_COUID;
//    if CLG_CENTRALE <> -1 then
//      ParamByName('PCLGCENTRALE').AsInteger := CLG_CENTRALE;
//    Open;
//
//    Result.bFound := False;
//    if RecordCount > 0 then
//    begin
//      Result.bFound        := True;
//      Result.CLG_PX        := FieldByName('CLG_PX').AsCurrency;
//      Result.CLG_PXNEGO    := FieldByName('CLG_PXNEGO').AsCurrency;
//      Result.CLG_PXVI      := FieldByName('CLG_PXVI').AsCurrency;
//      Result.CLG_RA1       := FieldByName('CLG_RA1').AsCurrency;
//      Result.CLG_RA2       := FieldByName('CLG_RA2').AsCurrency;
//      Result.CLG_RA3       := FieldByName('CLG_RA3').AsCurrency;
//      Result.CLG_TAXE      := FieldByName('CLG_TAXE').AsCurrency;
//      Result.CLG_PRINCIPAL := FieldByName('CLG_PRINCIPAL').AsInteger;
//      Result.CLG_CENTRALE  := FieldByName('CLG_CENTRALE').AsInteger;
//    end;
//  end;
//end;

function TSDUpdate.GetTVAId(TVA_TAUX: single; TVA_CODE: String): integer;
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
  except on E:Exception do
    raise Exception.Create('GetTvaId -> ' + E.Message);
  end;

end;

procedure TSDUpdate.Import;
var
  Xml : IXMLDocument;
  nXmlBase,
  eCatalogListNode,
  eCatalogNode,
  eCatalogAdditionnalNode,
  eCatalogCatAddNode,
  eModelListNode,
  eModelNode,
  eModelAdditionnalNode,
  eModelModAddNode,
  eModelRecomdPriceNode,
  eModelSalesPriceNode,
  eColorListNode,
  eColorNode,
  eColorAdditionnalNode,
  eItemListNode,
  eItemNode,
  eItemAdditionnalNode,
  eItemEanListNode : IXMLNode;

  // Cataloglist
  IndexKey, SupplierKey, SupplierDenotation, CatalogKey, CatalogDenotation,
  Add_SupplierKey, Add_SupplierErp, Add_SupplierDenotation, FOUID : TFieldCFG;

  // ModelList
  {IndexKey, CatalogKey,} ModelNumber, BrandNumber, Fedas, SizeRange, VAT, Denotation,
  DenotationLong, RecommendedSalesPrice, RecommendedSalesDate, Add_Pub, Add_Supplier2Key,
  Add_Supplier2Erp, Add_Supplier2Denotation, ARTID, ARFID, ModelType : TFieldCFG;

  // ColorList
  {IndexKey, CatalogKey , ModelNumber, BrandNumber,} ColorNumber, ColorDenotation, COUID : TFieldCFG;

  // ItemList
  {IndexKey, CatalogKey , ModelNumber, BrandNumber, ColorNumber,} EAN, Columnx, SizeLabel,
  ItemDenotation, PurchasePrice, RetailPrice, SMU, TDSC, CodeColl : TFieldCFG;

  // EanList
  {EAN ,} EanList, CBIID : TFieldCFG;

  // Recommandé à date
  TPO_ID : TFieldCFG;

  // Table TARCLGFOURN
  CLG_ID, CLG_FOUID, CLG_ARTID, CLG_TGFID, CLG_COUID, CLG_PX, CLG_PRINCIPAL : TFieldCfg;

  // Table TARPRIXVENTE
  PVT_ID, PVT_TVTID, PVT_ARTID, PVT_TGFID, PVT_COUID, PVT_PX : TFieldCfg;

  // Table TARVALID
  TVD_ID, TVD_TVTID, TVD_COUID, TVD_TGFID, TVD_DT, TVD_PX, TVD_ETAT : TFieldCfg;

  // Table PLXTAILLETRAV
  TTV_TGFID, COU_ID : TFieldCfg;

  i, iCount : Integer;
begin

  {$REGION 'CatalogList'}
  IndexKey.FieldName               := 'INDEXKEY';
  IndexKey.FieldType               := ftInteger;
  SupplierKey.FieldName            := 'SUPPLIERKEY';
  SupplierKey.FieldType            := ftString;
  SupplierDenotation.FieldName     := 'SUPPLIERDENOTATION';
  SupplierDenotation.FieldType     := ftString;
  CatalogKey.FieldName             := 'CATALOGKEY';
  CatalogKey.FieldType             := ftString;
  CatalogDenotation.FieldName      := 'CATALOGDENOTATION';
  CatalogDenotation.FieldType      := ftString;
  Add_SupplierKey.FieldName        := 'ADDSUPPLIERKEY';
  Add_SupplierKey.FieldType        := ftString;
  Add_SupplierErp.FieldName        := 'ADDSUPPLIERERP';
  Add_SupplierErp.FieldType        := ftString;
  Add_SupplierDenotation.FieldName := 'ADDSUPPLIERDENOTATION';
  Add_SupplierDenotation.FieldType := ftString;
  FOUID.FieldName                  := 'FOU_ID';
  FOUID.FieldType                  := ftInteger;

  FCatalogList.CreateField([IndexKey, SupplierKey, SupplierDenotation, CatalogKey, CatalogDenotation,
                             Add_SupplierKey, Add_SupplierErp, Add_SupplierDenotation, FOUID]);
  FCatalogList.IboQuery := FIboQuery;
  FCatalogList.StpQuery := FStpQuery;
  // Index de la table en mémoire
  FCatalogList.ClientDataSet.AddIndex('Idx','INDEXKEY;CATALOGKEY',[]);
  FCatalogList.ClientDataSet.IndexName := 'Idx';
  {$ENDREGION}

  {$REGION 'ModelList'}
  {IndexKey, CatalogKey,}
  ModelNumber.FieldName             := 'MODELNUMBER';
  ModelNumber.FieldType             := ftString;
  ModelType.FieldName               := 'MODELTYPE';
  ModelType.FieldType               := ftInteger;
  BrandNumber.FieldName             := 'BRANDNUMBER';
  BrandNumber.FieldType             := ftString;
  Fedas.FieldName                   := 'FEDAS';
  Fedas.FieldType                   := ftString;
  SizeRange.FieldName               := 'SIZERANGE';
  SizeRange.FieldType               := ftString;
  VAT.FieldName                     := 'VAT';
  VAT.FieldType                     := ftCurrency;
  Denotation.FieldName              := 'DENOTATION';
  Denotation.FieldType              := ftString;
  DenotationLong.FieldName          := 'DENOTATIONLONG';
  DenotationLong.FieldType          := ftString;
{  RecommendedSalesPrice.FieldName   := 'RECOMMENDEDSALESPRICE';
  RecommendedSalesPrice.FieldType   := ftCurrency;
  RecommendedSalesDate.FieldName    := 'RECOMMENDEDSALESDATE';
  RecommendedSalesDate.FieldType    := ftDate;}
  Add_Pub.FieldName                 := 'PUB';
  Add_Pub.FieldType                 := ftInteger;
  Add_Supplier2Key.FieldName        := 'SUPPLIER2KEY';
  Add_Supplier2Key.FieldType        := ftString;
  Add_Supplier2Erp.FieldName        := 'SUPPLIER2ERP';
  Add_Supplier2Erp.FieldType        := ftString;
  Add_Supplier2Denotation.FieldName := 'SUPPLIER2DENOTATION';
  Add_Supplier2Denotation.FieldType := ftString;
  ARTID.FieldName                   := 'ART_ID';
  ARTID.FieldType                   := ftInteger;
  ARFID.FieldName                   := 'ARF_ID';
  ARFID.FieldType                   := ftInteger;

  FModelList.CreateField([ IndexKey, CatalogKey, ModelNumber, BrandNumber, Fedas,
                           SizeRange, VAT, Denotation, Denotationlong, {RecommendedSalesPrice,
                           RecommendedSalesDate,} Add_Pub, Add_Supplier2Key, Add_Supplier2Erp,
                           Add_Supplier2Denotation, ARTID, ARFID, ModelType]);
  FModelList.IboQuery := FIboQuery;
  FModelList.StpQuery := FStpQuery;
  // Index de la table en mémoire
  FModelList.ClientDataSet.AddIndex('Idx','INDEXKEY;CatalogKey;ModelNumber;BrandNumber',[]);
  FModelList.ClientDataSet.IndexName := 'Idx';
  // Relation maitre détail avec la table Catalog
  FModelList.ClientDataSet.MasterSource := FDs_CatalogList;
  FModelList.ClientDataSet.MasterFields := 'INDEXKEY';
  {$ENDREGION}

  {$REGION 'Gestion des prix recommandés à date'}
  RecommendedSalesPrice.FieldName   := 'RECOMMENDEDSALESPRICE';
  RecommendedSalesPrice.FieldType   := ftCurrency;
  RecommendedSalesDate.FieldName    := 'RECOMMENDEDSALESDATE';
  RecommendedSalesDate.FieldType    := ftDate;
  TPO_ID.FieldName := 'TPO_ID';
  TPO_ID.FieldType := ftInteger;

  FModelRecDateList.CreateField([IndexKey,CatalogKey, ModelNumber, BrandNumber,RecommendedSalesPrice,RecommendedSalesDate, TPO_ID]);
  FModelRecDateList.IboQuery := FIboQuery;
  FModelRecDateList.StpQuery := FStpQuery;
  FModelRecDateList.ClientDataSet.AddIndex('Idx','INDEXKEY;CatalogKey;ModelNumber;BrandNumber',[]);
  FModelRecDateList.ClientDataSet.IndexName := 'Idx';
  // Relation maitre détail avec la table Model
  FModelRecDateList.ClientDataSet.MasterSource := FDs_ModelList;
  FModelRecDateList.ClientDataSet.MasterFields := 'INDEXKEY;CatalogKey;ModelNumber;BrandNumber';
  {$ENDREGION}

  {$REGION 'ColorList'}
  {IndexKey, CatalogKey , ModelNumber, BrandNumber,}
  ColorNumber.FieldName     := 'COLORNUMBER';
  ColorNumber.FieldType     := ftString;
  ColorDenotation.FieldName := 'COLORDENOTATION';
  ColorDenotation.FieldType := ftString;
  COUID.FieldName           := 'COU_ID';
  COUID.FieldType           := ftInteger;

  FColorList.CreateField([IndexKey, CatalogKey , ModelNumber, BrandNumber, ColorNumber, ColorDenotation, COUID]);
  FColorList.IboQuery := FIboQuery;
  FColorList.StpQuery := FStpQuery;
  // Index de la table en mémoire
  FColorList.ClientDataSet.AddIndex('Idx','INDEXKEY;CatalogKey;ModelNumber;BrandNumber;ColorNumber',[]);
  FColorList.ClientDataSet.IndexName := 'Idx';
  // Relation maitre détail avec la table Model
  FColorList.ClientDataSet.MasterSource := FDs_ModelList;
  FColorList.ClientDataSet.MasterFields := 'INDEXKEY;CatalogKey;ModelNumber;BrandNumber';
  {$ENDREGION}

  {$REGION 'ItemList'}
  {IndexKey, CatalogKey , ModelNumber, BrandNumber,ColorNumber,}
  EAN.FieldName            := 'EAN';
  EAN.FieldType            := ftString;
  Columnx.FieldName        := 'COLUMNX';
  Columnx.FieldType        := ftString;
  SizeLabel.FieldName      := 'SIZELABEL';
  SizeLabel.FieldType      := ftString;
  ItemDenotation.FieldName := 'ITEMDENOTATION';
  ItemDenotation.FieldType := ftString;
  PurchasePrice.FieldName  := 'PURCHASEPRICE';
  PurchasePrice.FieldType  := ftCurrency;
  RetailPrice.FieldName    := 'RETAILPRICE';
  RetailPrice.FieldType    := ftCurrency;
  SMU.FieldName            := 'SMU';
  SMU.FieldType            := ftInteger;
  TDSC.FieldName           := 'TDSC';
  TDSC.FieldType           := ftInteger;
  CodeColl.FieldName       := 'CODECOLL';
  CodeColl.FieldType       := ftString;

  FItemList.CreateField([IndexKey, CatalogKey , ModelNumber, BrandNumber, ColorNumber, EAN, Columnx, SizeLabel,
                         ItemDenotation, PurchasePrice, RetailPrice, SMU, TDSC, CodeColl]);
  FItemList.IboQuery := FIboQuery;
  FItemList.StpQuery := FStpQuery;
  // Index de la table en mémoire
  FItemList.ClientDataSet.AddIndex('Idx','INDEXKEY;CatalogKey;ModelNumber;BrandNumber;ColorNumber;EAN',[]);
  FItemList.ClientDataSet.IndexName := 'Idx';
  // Relation maitre détail avec la table Color
  FItemList.ClientDataSet.MasterSource := FDs_ColorList;
  FItemList.ClientDataSet.MasterFields := 'INDEXKEY;CatalogKey;ModelNumber;BrandNumber;ColorNumber';
  {$ENDREGION}

  {$REGION 'EanList'}
  {EAN ,}
  EanList.FieldName := 'EANLIST';
  EanList.FieldType := ftString;
  CBIID.FieldName   := 'CBI_ID';
  CBIID.FieldType   := ftInteger;

  FEanList.CreateField([IndexKey, CatalogKey , ModelNumber, BrandNumber, ColorNumber, EAN, EanList, CBIID]);
  FEanList.IboQuery := FIboQuery;
  FEanList.StpQuery := FStpQuery;
  // Index de la table en mémoire
  FEanList.ClientDataSet.AddIndex('Idx','INDEXKEY;CatalogKey;ModelNumber;BrandNumber;ColorNumber;EAN',[]);
  FEanList.ClientDataSet.IndexName := 'Idx';
  // Relation maitre détail avec la table Item
  FEanList.ClientDataSet.MasterSource := FDs_ItemList;
  FEanList.ClientDataSet.MasterFields := 'INDEXKEY;CatalogKey;ModelNumber;BrandNumber;ColorNumber;EAN';
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

  {$REGION 'Table TAILLETRAVAILLEE & table couleur'}
  TTV_TGFID.FieldName := 'TTV_TGFID';
  TTV_TGFID.FieldType := ftInteger;
  FTAILLETRAV.CreateField([TTV_TGFID]);

  COU_ID.FieldName := 'COU_ID';
  COU_ID.FieldType := ftInteger;

  FCOULEUR.CreateField([COU_ID]);
  {$ENDREGION}


  // geston du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      if not FileExists(FPath + FTitle + '.Xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;

{$REGION 'Récupération du mode de traitement du fichier'}
      case XmlStrToInt(nXmlBase.ChildValues['ALLOWINSERTS']) of
        0: FMode := umUpdate;
        1: FMode := umInsert;
      end;
{$ENDREGION}

      eCatalogListNode := nXmlBase.ChildNodes.FindNode('CATALOGLIST');
      eCatalogNode     := eCatalogListNode.ChildNodes['CATALOG'];

      iCount := 0; // Sert pour générer un index unique car catalogkey et supplierkey peuvent ête vide
      While eCatalogNode <> nil do
      begin
        With FCatalogList.ClientDataSet do
        begin
          Inc(iCount);
          Append;
          FieldByName('INDEXKEY').AsInteger          := iCount;
          FieldByName('SUPPLIERKEY').AsString        := XmlStrToStr(eCatalogNode.ChildValues['SUPPLIERKEY']);
          FieldByName('SUPPLIERDENOTATION').AsString := XmlStrToStr(eCatalogNode.ChildValues['SUPPLIERDENOTATION']);
          FieldByName('CATALOGKEY').AsString         := XmlStrToStr(eCatalogNode.ChildValues['CATALOGKEY']);
          FieldByName('CATALOGDENOTATION').AsString  := XmlStrToStr(eCatalogNode.ChildValues['CATALOGDENOTATION']);

          eCatalogAdditionnalNode := eCatalogNode.ChildNodes['CATALOGADDITIONAL'];
          eCatalogCatAddNode      := eCatalogAdditionnalNode.ChildNodes['ADDITIONAL'];
          if eCatalogCatAddNode <> nil then
          begin
            FieldByName('ADDSUPPLIERKEY').AsString := XmlStrToStr(eCatalogCatAddNode.ChildValues['SUPPLIERKEY']);
            FieldByName('ADDSUPPLIERERP').AsString := XmlStrToStr(eCatalogCatAddNode.ChildValues['SUPPLIERERP']);
            FieldByName('ADDSUPPLIERDENOTATION').AsString := XmlStrToStr(eCatalogCatAddNode.ChildValues['SUPPLIERDENOTATION']);
          end;
          FieldByName('FOU_ID').AsInteger := -1;
          Post;
        end; // with

        eModelListNode := eCatalogNode.ChildNodes['MODELLIST'];
        eModelNode     := eModelListNode.ChildNodes['MODEL'];

        while eModelNode <> nil do
        begin
          eModelRecomdPriceNode := eModelNode.ChildNodes['RECOMMENDEDSALESPRICE'];
          eModelSalesPriceNode := nil;
          if eModelRecomdPriceNode <> nil then
            eModelSalesPriceNode  := eModelRecomdPriceNode.ChildNodes['SALESPRICE'];

          With FModelList.ClientDataSet do
          begin
            Append;
            FieldByName('INDEXKEY').AsInteger      := iCount;
            FieldByName('CATALOGKEY').AsString     := XmlStrToStr(eCatalogNode.ChildValues['CATALOGKEY']);
            FieldByName('MODELNUMBER').AsString    := XmlStrToStr(eModelNode.ChildValues['MODELNUMBER']);
            FieldByName('MODELTYPE').AsInteger     := XmlStrToInt(eModelNode.ChildValues['MODELTYPE']);
            FieldByName('BRANDNUMBER').AsString    := XmlStrToStr(eModelNode.ChildValues['BRANDNUMBER']);
            FieldByName('FEDAS').AsString          := XmlStrToStr(eModelNode.ChildValues['FEDAS']);
            FieldByName('SIZERANGE').AsString      := XmlStrToStr(eModelNode.ChildValues['SIZERANGE']);
            FieldByName('VAT').AsCurrency          := XmlStrToFloat(eModelNode.ChildValues['VAT']);
            FieldByName('DENOTATION').AsString     := XmlStrToStr(eModelNode.ChildValues['DENOTATION']);
            FieldByName('DENOTATIONLONG').AsString := XmlStrToStr(eModelNode.ChildValues['DENOTATIONLONG']);

            eModelAdditionnalNode := eModelNode.ChildNodes['MODELADDITIONAL'];
            eModelModAddNode :=  eModelAdditionnalNode.ChildNodes['ADDITIONAL'];
            if eModelModAddNode <> nil then
            begin
              FieldByName('PUB').AsInteger   := XmlStrToInt(eModelModAddNode.ChildValues['PUB']);
              FieldByName('SUPPLIER2KEY').AsString := XmlStrToStr(eModelModAddNode.ChildValues['SUPPLIER2KEY']);
              FieldByName('SUPPLIER2ERP').AsString := XmlStrToStr(eModelModAddNode.ChildValues['SUPPLIER2ERP']);
              FieldByName('SUPPLIER2DENOTATION').AsString := XmlStrToStr(eModelModAddNode.ChildValues['SUPPLIER2DENOTATION']);
            end;
            FieldByName('ART_ID').AsInteger := -1;
            FieldByName('ARF_ID').AsInteger := -1;
            Post;
          end; // with

          // Prix recommandés à date
          With FModelRecDateList.ClientDataSet do
          begin
            while eModelSalesPriceNode <> nil do
            begin
              Append;
              FieldByName('INDEXKEY').AsInteger      := iCount;
              FieldByName('CATALOGKEY').AsString     := XmlStrToStr(eCatalogNode.ChildValues['CATALOGKEY']);
              FieldByName('MODELNUMBER').AsString    := XmlStrToStr(eModelNode.ChildValues['MODELNUMBER']);
              FieldByName('BRANDNUMBER').AsString    := XmlStrToStr(eModelNode.ChildValues['BRANDNUMBER']);
              FieldByName('RECOMMENDEDSALESPRICE').AsCurrency := XmlStrToFloat(eModelSalesPriceNode.ChildValues['PRICE']);
              FieldByName('RECOMMENDEDSALESDATE').AsDateTime := XmlStrToDate(eModelSalesPriceNode.ChildValues['DATE']);
              FieldByName('TPO_ID').AsInteger := 0;
              Post;

              eModelSalesPriceNode := eModelSalesPriceNode.NextSibling;
            end;
          end;


          eColorListNode := eModelNode.ChildNodes['COLORLIST'];
          eColorNode     := eColorListNode.ChildNodes['COLOR'];

          while eColorNode <> nil do
          begin

            With FColorList.ClientDataSet do
            begin
              Append;
              FieldByName('INDEXKEY').AsInteger   := iCount;
              FieldbyName('CATALOGKEY').AsString  := XmlStrToStr(eCatalogNode.ChildValues['CATALOGKEY']);
              FieldByName('MODELNUMBER').AsString := XmlStrToStr(eModelNode.ChildValues['MODELNUMBER']);
              FieldByName('BRANDNUMBER').AsString := XmlStrToStr(eModelNode.ChildValues['BRANDNUMBER']);
              FieldbyName('COLORNUMBER').AsString := XmlStrToStr(eColorNode.ChildValues['COLORNUMBER']);
              FieldbyName('COLORDENOTATION').AsString := XmlStrToStr(eColorNode.ChildValues['COLORDENOTATION']);


              eColorAdditionnalNode := eColorNode.ChildNodes['COLORADDITIONAL'].ChildNodes['ADDITIONAL'];
              if eColorAdditionnalNode <> nil then
              begin
                // Rien pour l'instant mais mis en place pour des modifications futures
              end;

              Post;
            end; // with

            eItemListNode := eColorNode.ChildNodes['ITEMLIST'];
            eItemNode     := eItemListNode.ChildNodes['ITEM'];

            while eItemNode <> nil do
            begin
              eItemEanListNode := eItemNode.ChildNodes['EANLIST'];
              eItemAdditionnalNode := eItemNode.ChildNodes['ITEMADDITIONAL'].ChildNodes['ADDITIONAL'];

              With FItemList.ClientDataSet do
              begin
                Append;
                FieldByName('INDEXKEY').AsInteger       := iCount;
                FieldbyName('CATALOGKEY').AsString      := XmlStrToStr(eCatalogNode.ChildValues['CATALOGKEY']);
                FieldByName('MODELNUMBER').AsString     := XmlStrToStr(eModelNode.ChildValues['MODELNUMBER']);
                FieldByName('BRANDNUMBER').AsString     := XmlStrToStr(eModelNode.ChildValues['BRANDNUMBER']);
                FieldbyName('COLORNUMBER').AsString     := XmlStrToStr(eColorNode.ChildValues['COLORNUMBER']);
                FieldByName('EAN').AsString             := XmlStrToStr(eItemNode.ChildValues['EAN']);
                FieldByName('COLUMNX').AsString         := XmlStrToStr(eItemNode.ChildValues['COLUMNX']);
                FieldByName('SIZELABEL').AsString       := XmlStrToStr(eItemNode.ChildValues['SIZELABEL']);
                FieldByName('ITEMDENOTATION').AsString  := XmlStrToStr(eItemNode.ChildValues['ITEMDENOTATION']);
                FieldByName('PURCHASEPRICE').AsCurrency := XmlStrToFloat(eItemNode.ChildValues['PURCHASEPRICE']);
                FieldByName('RETAILPRICE').AsCurrency   := XmlStrToFloat(eItemNode.ChildValues['RETAILPRICE']);
                FieldByName('SMU').AsInteger            := XmlStrToInt(eItemNode.ChildValues['SMU']);
                FieldByName('TDSC').AsInteger           := XmlStrToInt(eItemNode.ChildValues['TDSC']);


                if eItemAdditionnalNode <> nil then
                  FieldByName('CODECOLL').AsString := XmlStrToStr(eItemAdditionnalNode.ChildValues['CODECOLL']);
                Post;
              end; // with


//              while eItemEanListNode <> nil do
              for i := 0 to eItemEanListNode.childNodes.Count -1 do
              begin
          //      If eItemEanListNode.childNodes.Count > 0 then
                With FEanList.ClientDataSet do
                begin
                  Append;
                  FieldByName('INDEXKEY').AsInteger   := iCount;
                  FieldbyName('CATALOGKEY').AsString  := XmlStrToStr(eCatalogNode.ChildValues['CATALOGKEY']);
                  FieldByName('MODELNUMBER').AsString := XmlStrToStr(eModelNode.ChildValues['MODELNUMBER']);
                  FieldByName('BRANDNUMBER').AsString := XmlStrToStr(eModelNode.ChildValues['BRANDNUMBER']);
                  FieldbyName('COLORNUMBER').AsString := XmlStrToStr(eColorNode.ChildValues['COLORNUMBER']);
                  FieldByName('EAN').AsString := XmlStrToStr(eItemNode.ChildValues['EAN']);
                  FieldByName('EANLIST').AsString := XmlStrToStr( eItemEanListNode.ChildNodes.Get(i).NodeValue); //eItemEanListNode.ChildValues['EAN']);

                  Post;
                end;
           //     eItemEanListNode := eItemEanListNode.NextSibling;
              end; // while

              eItemNode := eItemNode.NextSibling;
            end;  // while eItemNode

            eColorNode := eColorNode.NextSibling;
          end; // while eColorNode

          eModelNode := eModelNode.NextSibling;
        end; // while eModelNode

        eCatalogNode := eCatalogNode.NextSibling;
      end; // while eCatalogNode
    Except on E:Exception do
      raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
    end;
  finally
    Xml := Nil;
    TXMLDocument(Xml).Free;
  end;

end;

function TSDUpdate.SetARTCodeBarre(ACBI_ARFID, ACBI_TGFID, ACBI_COUID,
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
    Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
    Inc(FMajCount, FieldByName('FMAJ').AsInteger);
    IsUpdated := IsUpdated Or
                 (FieldByName('FAJOUT').AsInteger > 0) Or
                 (FieldByName('FMAJ').AsInteger > 0);


  Except on E:Exception Do
    raise Exception.Create('SetARTCodeBarre -> ' + E.Message);
  end;
end;

function TSDUpdate.SetArtColArt(ART_ID, COL_ID: integer): integer;
begin
  With FStpQuery do
  try
    Close;
    StoredProcName := 'MSS_SETARTCOLART';
    ParamCheck := True;
    ParamByName('ART_ID').AsInteger := ART_ID;
    ParamByName('COL_ID').AsInteger := COL_ID;
    Open;

    Result := FieldByName('CAR_ID').AsInteger;
    Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
    IsUpdated := IsUpdated Or
                 (FieldByName('FAJOUT').AsInteger > 0);

  Except on E:Exception do
    raise Exception.Create('SetArtColArt -> ' + E.Message);
  end;
end;

function TSDUpdate.SetArticle(ART_REFMRK: String; ART_MRKID, ART_GREID: INTEGER;
  ART_NOM, ART_DESCRIPTION, ART_COMMENT5: String; ART_SSFID, ART_GTFID,
  ART_GARID, ARF_TVAID, ARF_ICLID3, ARF_ICLID4, ARF_ICLID5, ARF_CATID,
  ARF_TCTID: INTEGER; ART_CODE, ART_FEDAS: String; ART_PXETIQU,
  ART_ACTID, ART_CENTRALE, ART_PUB : Integer): TArtArticle;
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
    ParamByName('ARTCENTRALE').AsInteger   := ART_CENTRALE;
    ParamByName('ARTPUB').AsInteger        := ART_PUB;
    Open;

    Result.ART_ID := FieldByName('ART_ID').AsInteger;
    Result.ARF_ID := FieldByName('ARF_ID').AsInteger;
    Result.FAjout := FieldByName('FAJOUT').AsInteger;
    Result.FMaj   := FieldByName('FMAJ').AsInteger;
    Result.Chrono := FieldByName('ARF_CHRONO').AsString;

//    FModelList.ClientDataSet.Edit;
//    FModelList.ClientDataSet.FieldByName('ART_ID').AsInteger := Result.ART_ID;
//    FModelList.ClientDataSet.FieldByName('ARF_ID').AsInteger := Result.ARF_ID;
//    FModelList.ClientDataSet.Post;

    Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
    Inc(FMajCount,FieldByName('FMAJ').AsInteger);
    IsCreated := (FieldByName('FAJOUT').AsInteger > 0);
    IsUpdated := (FieldByName('FMAJ').AsInteger > 0);
  Except on E:Exception do
    raise Exception.Create('SetArticle -> ' + E.Message);
  end;
end;

//function TSDUpdate.SetArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID,
//  CLG_COUID: Integer; CLG_PX, CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3,
//  CLG_TAXE: Single; CLG_PRINCIPAL, CLG_CENTRALE: integer): Integer;
//begin
//  Try
//    With FStpQuery do
//    begin
//      Close;
//      StoredProcName := 'MSS_TACHAT_CREATE';
//      ParamCheck := True;
//      ParamByName('CLG_ARTID').AsInteger := CLG_ARTID;
//      ParamByName('CLG_FOUID').AsInteger := CLG_FOUID;
//      ParamByName('CLG_TGFID').AsInteger := CLG_TGFID;
//      ParamByName('CLG_COUID').AsInteger := CLG_COUID;
//      ParamByName('CLG_PX').AsCurrency := CLG_PX;
//      ParamByName('CLG_PXNEGO').AsCurrency := CLG_PXNEGO;
//      ParamByName('CLG_PXVI').AsCurrency := CLG_PXVI;
//      ParamByName('CLG_RA1').AsCurrency :=  CLG_RA1;
//      ParamByName('CLG_RA2').AsCurrency :=  CLG_RA2;
//      ParamByName('CLG_RA3').AsCurrency :=  CLG_RA3;
//      ParamByName('CLG_TAXE').AsCurrency := CLG_TAXE;
//      ParamByName('CLG_PRINCIPAL').AsInteger := CLG_PRINCIPAL;
//      ParamByName('CLG_CENTRALE').AsInteger := CLG_CENTRALE;
//      Open;
//
//      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
//    end;
//
//  Except on E:Exception do
//    Raise Exception.Create('SetArtPrixAchat -> ' + E.Message);
//  End;
//
//end;

//function TSDUpdate.SetArtPrixAchat_Base(CLG_ARTID, CLG_FOUID: Integer; CLG_PX,
//  CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3, CLG_TAXE: Single;
//  CLG_CENTRALE: Integer): Integer;
//begin
//  try
//    With FStpQuery do
//    begin
//      Close;
//      StoredProcName := 'MSS_TACHATBASE_CREATEORMAJ';
//      ParamCheck := True;
//      ParamByName('CLG_ARTID').AsInteger := CLG_ARTID;
//      ParamByName('CLG_FOUID').AsInteger := CLG_FOUID;
//      ParamByName('CLG_PX').AsCurrency:= CLG_PX;
//      ParamByName('CLG_PXNEGO').AsCurrency:= CLG_PXNEGO;
//      ParamByName('CLG_PXVI').AsCurrency:= CLG_PXVI;
//      ParamByName('CLG_RA1').AsCurrency:= CLG_RA1;
//      ParamByName('CLG_RA2').AsCurrency:= CLG_RA2;
//      ParamByName('CLG_RA3').AsCurrency:= CLG_RA3;
//      ParamByName('CLG_TAXE').AsCurrency:= CLG_TAXE;
//      ParamByName('CLG_CENTRALE').AsInteger := CLG_CENTRALE;
//      Open;
//
//      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
//      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
//      Result := FieldByName('PRINCIPAL').AsInteger;
//    end;
//  Except on E:Exception do
//    Raise Exception.Create('SetArtPrixAchat_Base -> ' + E.Message);
//  End;
//end;

function TSDUpdate.SetArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID,
  CLG_COUID: Integer; CLG_PX, CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3,
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
      case CLG_CENTRALE of
        1: ParamByName('CLG_CENTRALE').AsInteger := 1;
        2: ParamByName('CLG_CENTRALE').AsInteger := 5;
        3: ParamByName('CLG_CENTRALE').AsInteger := 0;
        else
        raise Exception.Create(Format('Model Type non géré %d',[FModelList.FieldByName('MODELTYPE').AsInteger]));
      end;

      ParamByName('CLG_CENTRALE').AsInteger  := CLG_CENTRALE;
      Open;

      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Close;
    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixAchat -> ' + E.Message);
  End;
end;

function TSDUpdate.SetArtPrixAchat_Base(CLG_ARTID, CLG_FOUID: Integer; CLG_PX,
  CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3, CLG_TAXE: Single;
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
      case CLG_CENTRALE of
        1: ParamByName('CLG_CENTRALE').AsInteger := 1;
        2: ParamByName('CLG_CENTRALE').AsInteger := 5;
        3: ParamByName('CLG_CENTRALE').AsInteger := 0;
        else
        raise Exception.Create(Format('Model Type non géré %d',[FModelList.FieldByName('MODELTYPE').AsInteger]));
      end;
      Open;

      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      Result := FieldByName('PRINCIPAL').AsInteger;
    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixAchat_Base -> ' + E.Message);
  End;
end;

function TSDUpdate.SetArtPrixVente(PVT_ARTID, PVT_TGFID, PVT_COUID: Integer;
  PVT_PX: single; PVT_CENTRALE: Integer): Integer;
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
      case PVT_CENTRALE of
        1: ParamByName('PVT_CENTRALE').AsInteger := 1;
        2: ParamByName('PVT_CENTRALE').AsInteger := 5;
        3: ParamByName('PVT_CENTRALE').AsInteger := 0;
        else
        raise Exception.Create(Format('Model Type non géré %d',[FModelList.FieldByName('MODELTYPE').AsInteger]));
      end;
      Open;

      Inc(FInsertCount, FieldByName('FAJOUT').AsInteger);
    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixVente -> ' + E.Message);
  End;

end;

procedure TSDUpdate.SetArtPrixVente_Base(PVT_ARTID: Integer; PVT_PX: single;
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

      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      inc(FMajCount, FieldByName('FMAJ').AsInteger);
      IsUpdated := IsUpdated Or
                   (FieldByName('FAJOUT').AsInteger > 0) Or
                   (FieldByName('FMAJ').AsInteger > 0);

    end;
  Except on E:Exception do
    Raise Exception.Create('SetArtPrixVente_Base -> ' + E.Message);
  End;
end;

function TSDUpdate.SetARTRelationAxe(ART_ID, SSF_ID: Integer): integer;
begin
  With FStpQuery do
  begin
    Close;
    StoredProcName := 'MSS_SETARTRELATIONAXE';
    ParamCheck := True;
    ParamByName('ART_ID').AsInteger := ART_ID;
    ParamByName('SSF_ID').AsInteger := SSF_ID;
    Open;

    Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
    IsUpdated := IsUpdated or (FieldByName('FAJOUT').AsInteger > 0);
  end;
end;

function TSDUpdate.SetColor(ACOU_ARTID: Integer; ACOU_CODE, ACOU_NOM: String;
  COU_SMU, COU_TDSC: Integer): Integer;
begin
  With FStpQuery do
  try
    Result := -1;
    Close;
    StoredProcName := 'MSS_PLXCOULEUR_SDUPD';
    ParamCheck := True;
    ParamByName('COUARTID').AsInteger := ACOU_ARTID;
    ParamByName('COUCODE').AsString   := ACOU_CODE;
    ParamByName('COUNOM').AsString    := ACOU_NOM;
    ParamByName('COUSMU').AsInteger   := COU_SMU;
    ParamByName('COUTDSC').AsInteger  := COU_TDSC;
    Open;
    Result := FieldByName('COU_ID').AsInteger;
    IsUpdated := IsUpdated Or
                 (FieldByName('FMAJ').AsInteger > 0) or
                 (FieldByName('FAJOUT').AsInteger > 0);

  Except on E:Exception Do
    raise Exception.Create('SetColor -> ' + E.Message);
  end;
end;

function TSDUpdate.SetMrkFourn(AFOUID, AMRKID: Integer): integer;
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

//procedure TSDUpdate.SetTAchatPxVI(CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_COUID,
//  CLG_CENTRALE: Integer; CLG_PXVI: Currency);
//var
//  TarifAchat : TTarifAchat;
//begin
//  // Y a t il un prix spécifique ?
//  TarifAchat := GetTarifAchat(CLG_ARTID,CLG_FOUID,CLG_TGFID,CLG_COUID,CLG_CENTRALE);
//  if TarifAchat.bFound then
//  begin
//    // Mise à jour du tarif négo
//    if CompareValue(TarifAchat.CLG_PXVI,CLG_PXVI, 0.001) <> EqualsValue then
//      With FIboQuery do
//      begin
//        Close;
//        SQL.Clear;
//        SQL.Add('Select * from MSS_UPDTACHATPXVI(:PARTID, :PFOUID, :PTGFID, :PCOUID, :CENTRALE, :PPXVI)');
//        ParamCheck := True;
//        ParamByName('PARTID').AsInteger := CLG_ARTID;
//        ParamByName('PFOUID').AsInteger := CLG_FOUID;
//        ParamByName('PTGFID').AsInteger := CLG_TGFID;
//        ParamByName('PCOUID').AsInteger := CLG_COUID;
//        ParamByName('CENTRALE').AsInteger := CLG_CENTRALE;
//        ParamByName('PPXVI').AsCurrency := CLG_PXVI;
//        Open;
//
//        if Recordcount > 0 then
//          Inc(FMajCount,FieldByName('FMAJ').AsInteger);
//      end; // with
//  end;
//
//end;

function TSDUpdate.SetTailleTrav(TTV_ARTID, TTV_TGFID: Integer): Integer;
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
  except on E:Exception do
    raise Exception.Create('SetTailleTrav -> ' + E.Message);
  end;
end;

function TSDUpdate.SetTarPreco(TPO_ARTID: Integer; TPO_DT: TDate;
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
    Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
    Inc(FMajCount,FieldByName('FMAJ').AsInteger);
    IsUpdated := IsUpdated or
                (FieldByName('FAJOUT').AsInteger > 0) or
                (FieldByName('FMAJ').AsInteger > 0);

  Except on E:Exception do
    raise Exception.Create('SetTarPreco -> ' + E.Message);
  end;
end;

function TSDUpdate.SetTarValid(ATVD_TPOID, ATVD_TVTID, ATVD_ARTID, ATVD_TGFID,
  ATVD_COUID: Integer; ATVD_PX: Currency; ATVD_DT: TDate;
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

function TSDUpdate.UpdArtPrixAchat(CLG_ARTID, CLG_FOUID, CLG_TGFID,
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
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
    end;
  Except on E:Exception do
    Raise Exception.Create('UpdArtPrixAchat -> ' + E.Message);
  End;
end;

function TSDUpdate.UpdTarValid(ATVD_ID: Integer; ATVD_DT: TDate;
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
