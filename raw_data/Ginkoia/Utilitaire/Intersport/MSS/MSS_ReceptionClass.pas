unit MSS_ReceptionClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type,
     MSS_SuppliersClass, MSS_BrandsClass, MSS_UniversCriteriaClass, MSS_SizesClass,
     Math, Types, MSS_PeriodsClass, MSS_CollectionsClass, HTTPApp, Windows, StrUtils,
     Dialogs, MSS_FedasClass, MSS_ArticleClass;

Type
  TRECAUTO = Record
    BLA_ID : Integer;
    Etat   : Integer;
  end;

  TRECAUTOP = Record
    BLP_ID : Integer;
    Etat : Integer;
  end;

  TReceptionClass = Class(TMainClass)
  private
    FPackages,
    FPkModel,
    FPkColor,
    FPkItem,
    FUnKnown,
    FUkItem : TMainClass;

    FDs_Package,
    FDs_PkModel,
    FDs_PkColor,
    FDs_PkItem : TDataSource;

    FSupplierKey: String;
    FSupplierName : String;
    FReferenceNumber: String;
    FBranchNumber: String;
    FTotalweight: Single;
    FTotalnumberofpackages: Integer;
    FDeliverydate: TDate;
    FDeliverynotenumber: String;
    FTotalnumberofitems: Integer;
    FTotalnumberofpallets: Integer;
    FFournTable: TIboQuery;
    FMarqueTable: TIboQuery;
    FMAG_ID: Integer;
    FShipCompName: String;
    FComment: String;

    FReceptionPackages,
    FReceptionLignes,
    FReceptionInfos,
    FReceptionUkLignes,
    FRecepStockLignes : TMainClass;

    FArticle : TArticleClass;
    FTVATable: TIboQuery;

    FNewArtList,
    FRecepList : TStringList;
  public
    constructor Create;override;
    Destructor Destroy;override;

    procedure Import;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;

    // fonction permettant de créer/mettre à jour RECAUTO
    function SetRecAuto(BLA_NUMERO : String; BLA_DATE : TDate; BLA_FOUID : Integer; BLA_TRANS : String;
                        BLA_MAGID : Integer; BLA_COMENT : String;
                        BLA_ETAT, BLA_NBPAL, BLA_NBPAQ, BLA_NBART : Integer) : TRECAUTO;

    // fonction permettant de créer/mettre à jour RECAUTOP
    function SetRecAutoP(BLP_BLAID : Integer; BLP_NUMERO, BLP_PALETTE : String; BLP_QTE : Integer;
                         BLP_UNIVERS : String; BLP_ETAT : Integer) : TRECAUTOP;

    // fonction permettant de créer/mettre à jour RECAUTOL
    function SetRecAutoL(LPA_BLPID, LPA_ARTID, LPA_TGFID, LPA_COUID, LPA_CDLID, LPA_QTE, LPA_PREETIK : Integer;
                         LPA_COMENT : String;LPA_PA, LPA_PV : Currency; LPA_INCONU : Integer; LPA_EAN : String; AIsCumul : Boolean) : Integer;

    // fonction permettant de créer RECAUTOU
    function SetRecAutoU(LPU_PAQUET, ORDERNO, BRAND, MODNUMBER, LPU_EAN : String;LPU_QTE : Integer;LPU_COMMENT : String; LPU_BLAID : integer; LPU_ARTNOM : String) : Integer;

    // fonction permettant de récupérer l'ID fournisseur
    function GetFournId(Suppliers : TSuppliers;AERPCODE, ACODE : String) : Integer;

    // Permet de créer un CB (Retourne le CBI_ID)
    function SetARTCodeBarre(ACBI_ARFID, ACBI_TGFID, ACBI_COUID,ACBI_TYPE : Integer;ACBI_CB : String) : Integer;



  published
    property SupplierKey : String read FSupplierKey;
    property ReferenceNumber : String read FReferenceNumber;
    property BranchNumber : String read FBranchNumber;
    property Deliverynotenumber : String read FDeliverynotenumber;
    property Deliverydate : TDate read FDeliverydate;
    property Totalnumberofpallets : Integer read FTotalnumberofpallets;
    property Totalnumberofpackages : Integer read FTotalnumberofpackages;
    property Totalnumberofitems : Integer read FTotalnumberofitems;
    property Totalweight : Single read FTotalweight;
    property ShipCompName : String read FShipCompName;
    property Comment      : String read FComment;

    Property MarqueTable     : TIboQuery   read FMarqueTable write FMarqueTable;
    Property FournTable      : TIboQuery   read FFournTable  write FFournTable;
    Property TVATable        : TIboQuery   read FTVATable    write FTVATable;

    property CodeMag;
    Property MAG_ID;

    property NewArtList : TStringList read FNewArtList;
    property RecepList  : TStringList read FRecepList;
  End;

implementation

{ TReceptionClass }

constructor TReceptionClass.Create;
begin
  inherited Create;

  FPackages := TMainClass.Create;
  FPkModel  := TMainClass.Create;
  FPkColor  := TMainClass.Create;
  FPkItem   := TMainClass.Create;
  FUnKnown  := TMainClass.Create;
  FUkItem   := TMainClass.Create;

  FDs_Package := TDataSource.Create(nil);
  FDs_Package.DataSet := FPackages.ClientDataSet;
  FDs_PkModel  := TDataSource.Create(nil);
  FDs_PkModel.DataSet := FPkModel.ClientDataSet;
  FDs_PkColor  := TDataSource.Create(nil);
  FDs_PkColor.DataSet := FPkColor.ClientDataSet;
  FDs_PkItem   := TDataSource.Create(nil);
  FDs_PkItem.DataSet := FPkItem.ClientDataSet;

  FReceptionPackages := TMainClass.Create;
  FReceptionLignes := TMainClass.Create;
  FReceptionInfos := TMainClass.Create;
  FReceptionUkLignes := TMainClass.Create;
  FRecepStockLignes := TMainClass.Create;

  FArticle := TArticleClass.Create;
  FArticle.Mode := maReception;
  FArticle.CreateReceptionField;

  FNewArtList := TStringList.Create;
  FRecepList  := TStringList.Create;

  FCODEMAG := '';
end;

destructor TReceptionClass.Destroy;
begin
  FNewArtList.Free;
  FRecepList.Free;

  FArticle.Free;

  FDs_Package.Free;
  FDs_PkModel.Free;
  FDs_PkColor.Free;
  FDs_PkItem.Free;

  FPackages.Free;
  FPkModel.Free;
  FPkColor.Free;
  FPkItem.Free;
  FUnKnown.Free;
  FUkItem .Free;
  FReceptionPackages.Free;
  FReceptionLignes.Free;
  FReceptionInfos.Free;
  FReceptionUkLignes.Free;
  FRecepStockLignes.Free;
  inherited;
end;

function TReceptionClass.DoMajTable(ADoMaj: Boolean): Boolean;
Var
  i, BLA_ID, FOU_ID, BLP_ID, LPA_ARTID, LPA_TGFID, LPA_COUID,
  LPA_CDLID, LPA_ID, LPU_ID, iCas : Integer;
  QteTmp, QteEnCours, QteTraitee : Integer;
  LPA_COMENT : String;
  RecAuto : TRECAUTO;
  RecAutoP : TRECAUTOP;
  Suppliers : TSuppliers;
  sError : String;

  bIsCumul : Boolean;
  BookM : TBookmark;
begin
  Try
    {$REGION 'Initialisation'}
    FArticle.IboQuery := FIboQuery;
    FArticle.StpQuery := FStpQuery;
    FArticle.MarqueTable := FMarqueTable;
    FArticle.FournTable  := FFournTable;
    FArticle.TVATable    := FTVATable;


    for i := Low(MasterData) to High(MasterData) do
    begin
      if MasterData[i].MainData.InheritsFrom(TSuppliers) then
        Suppliers := TSuppliers(MasterData[i].MainData);

//      if MasterData[i].MainData.InheritsFrom(TBrands) then
//        Brands := TBrands(MasterData[i].MainData);
//
//      if MasterData[i].MainData.InheritsFrom(TUniversCriteria) then
//        Univers := TUniversCriteria(MasterData[i].MainData);
//
//      if MasterData[i].MainData.InheritsFrom(TSizes) then
//        Sizes := TSizes(MasterData[i].MainData);
//
//      if MasterData[i].MainData.InheritsFrom(TPeriods) then
//        Periods := TPeriods(MasterData[i].MainData);
//
//      if MasterData[i].MainData.InheritsFrom(TCollections) then
//        Collections := TCollections(MasterData[i].MainData);
//
//      if MasterData[i].MainData.InheritsFrom(TFedas) then
//        Fedas := TFedas(MasterData[i].MainData);
    end;
    {$ENDREGION}


    // Génération de l'entête RECAUTO
    FOU_ID := GetFournId(Suppliers,FSupplierKey,FSupplierKey);

    RecAuto := SetRecAuto(
                          Deliverynotenumber,    // BLA_NUMERO : String;
                          Deliverydate,          // BLA_DATE: TDate;
                          FOU_ID,                // BLA_FOUID: Integer;
                          ShipCompName,          // BLA_TRANS: String;
                          MAG_ID,                // BLA_MAGID: Integer;
                          Comment,               // BLA_COMENT: String;
                          0,                     // BLA_ETAT: Integer;
                          Totalnumberofpallets,  // BLA_NBPAL,
                          Totalnumberofpackages, // BLA_NBPAQ,
                          Totalnumberofitems     // BLA_NBART: Integer
                      );

    {$REGION 'Récupération des lignes de Packages'}
    With FIboQuery do
    Begin
      Close;
      SQL.Clear;
      SQL.Add('Select BLP_ID from RECAUTOP');
      SQL.Add('  Join K on K_ID = BLP_ID and K_Enabled = 1');
      SQL.Add('Where BLP_BLAID = :PBLAID');
      ParamCheck := True;
      ParamByName('PBLAID').AsInteger := RecAuto.BLA_ID;
      Open;

      FReceptionPackages.ClientDataSet.EmptyDataSet;
      while not EOF do
      begin
        FReceptionPackages.ClientDataSet.Append;
        FReceptionPackages.FieldByName('BLP_ID').AsInteger := FieldByName('BLP_ID').AsInteger;
        FReceptionPackages.FieldByName('Deleted').AsInteger := 1;
        FReceptionPackages.ClientDataSet.Post;

        Next;
      end;
    End;
    {$ENDREGION}

    // Traitement de la partie Package
    FPackages.First;
    if RecAuto.Etat = 0 then
    begin
      while not FPackages.EOF do
      begin
        // Génération des lignes RECAUTOP
        RecAutoP := SetRecAutoP(
                              RecAuto.BLA_ID,                                        // BLP_BLAID: Integer;
                              FPackages.FieldByName('PackageCode').AsString,         // BLP_NUMERO,
                              FPackages.FieldByName('PalletNumber').AsString,        // BLP_PALETTE: String;
                              FPackages.FieldByName('Totalnumberofitems').AsInteger, // BLP_QTE: Integer;
                              FPackages.FieldByName('UniversDenotation').AsString,   // BLP_UNIVERS: String;
                              0                                                      // BLP_ETAT Integer
                             );

        {$REGION 'Récupération des lignes du Packages'}
        With FIboQuery do
        begin
          Close;
          SQL.Clear;
          SQL.Add('SELECT LPA_ID, LPA_ARTID, LPA_TGFID, LPA_COUID, LPA_CDLID, LPA_QTE, ART_FUSARTID from RECAUTOL');
          SQL.Add('  Join K on K_ID = LPA_ID and K_Enabled = 1');
          SQL.Add('  Join ARTARTICLE on ART_ID = LPA_ARTID');
          SQL.Add('Where LPA_BLPID = :PBLPID');
          ParamCheck := True;
          ParamByName('PBLPID').AsInteger := RecAutoP.BLP_ID;
          Open;
          FReceptionLignes.ClientDataSet.EmptyDataSet;
          while not EOF do
          begin
            FReceptionLignes.ClientDataSet.Append;
            FReceptionLignes.FieldByName('LPA_ID').AsInteger       := FieldByName('LPA_ID').AsInteger;
            FReceptionLignes.FieldByName('LPA_ARTID').AsInteger    := FieldByName('LPA_ARTID').AsInteger;
            FReceptionLignes.FieldByName('LPA_TGFID').AsInteger    := FieldByName('LPA_TGFID').AsInteger;
            FReceptionLignes.FieldByName('LPA_COUID').AsInteger    := FieldByName('LPA_COUID').AsInteger;
            FReceptionLignes.FieldByName('LPA_CDLID').AsInteger    := FieldByName('LPA_CDLID').AsInteger;
            FReceptionLignes.FieldByName('LPA_QTE').AsInteger      := FieldByName('LPA_QTE').AsInteger;
            FReceptionLignes.FieldByName('ART_FUSARTID').AsInteger := FieldByName('ART_FUSARTID').AsInteger;
            FReceptionLignes.FieldByName('Updated').AsInteger      := 0;
            FReceptionLignes.FieldByName('Deleted').AsInteger      := 1;
            FReceptionLignes.ClientDataSet.Post;
            Next;
          end;
        end;
        {$ENDREGION}

        FPkModel.First;
        if RecAutoP.Etat = 0 then
          while not FPkModel.EOF do
          begin
            FPkColor.First;
            while not FPkColor.EOF do
            begin
              FPkItem.First;
              while not FPkItem.EOF do
              begin
                // Gestion des cadences
                QteTmp := FPkItem.FieldByName('Qty').AsInteger;

                {$REGION 'Récupération des informations relatives aux informations de commandes et d''articles'}
                With FIboQuery do
                begin
                  try
                  Close;
                  SQL.Clear;
                  SQL.Add('Select * from MSS_RECEP_GETINFOLIGNE_PK');
                  SQL.Add('(:PMODEL, :PBRAND, :PSIZERANGE, :PCOLOR, :PCOLUMNX, :PCDENUMFOURN, :PCBICB)');
                  ParamCheck := True;
                  ParamByName('PMODEL').AsString     := FPkModel.FieldByName('ModNumber').AsString;
                  ParamByName('PBRAND').AsString     := FPkModel.FieldByName('BrandNumber').AsString;
                  ParamByName('PSIZERANGE').AsString := FPkModel.FieldByName('SizeRange').AsString;
                  ParamByName('PCOLOR').AsString     := FPkColor.FieldByName('ColorNumber').AsString;
                  ParamByName('PCOLUMNX').AsString   := FPkItem.FieldByName('ColumnX').AsString;
                  ParamByName('PCDENUMFOURN').AsString := FPkItem.FieldByName('OrderNo').AsString;
                  ParamByName('PCBICB').AsString     := FPkItem.FieldByName('EAN').AsString;
                  Open;

                  except on E:exception do
                    raise Exception.Create(Format('GETINFOLIGNE -> Mod Number %s - EAN %s - %s',[FPkModel.FieldByName('ModNumber').AsString,FPkItem.FieldByName('EAN').AsString, E.Message]));
                  end;

                  // Sauvegarde des informations dans un TMainClass
                  FReceptionInfos.ClientDataSet.EmptyDataSet;
                  while not EOF do
                  begin
                    // Vérification que la ligne n'a pas déjà été traité ultérieurmeent afin d'ajuster le RAL
                    if FRecepStockLignes.ClientDataSet.Locate('LPA_CDLID;LPA_ARTID;LPA_TGFID;LPA_COUID',
                                                       VarArrayOf([FieldByName('CDL_ID').AsInteger,
                                                                   FieldByName('ART_ID').AsInteger,
                                                                   FieldByName('TGF_ID').AsInteger,
                                                                   FieldByName('COU_ID').AsInteger]),[]) then
                    begin
                      QteTraitee := FRecepStockLignes.FieldByName('LPA_QTE').AsInteger;
                    end
                    else
                      QteTraitee := 0;

                    FReceptionInfos.ClientDataSet.Append;
                    FReceptionInfos.FieldByName('CDL_ID').AsInteger     := FieldByName('CDL_ID').AsInteger;
                    FReceptionInfos.FieldByName('ART_ID').AsInteger     := FieldByName('ART_ID').AsInteger;
                    FReceptionInfos.FieldByName('ARF_ID').AsInteger     := FieldByName('ARF_ID').AsInteger;
                    FReceptionInfos.FieldByName('TGF_ID').AsInteger     := FieldByName('TGF_ID').AsInteger;
                    FReceptionInfos.FieldByName('COU_ID').AsInteger     := FieldByName('COU_ID').AsInteger;
                    FReceptionInfos.FieldByName('RAL_QTE').AsInteger    := FieldByName('RAL_QTE').AsInteger - QteTraitee;
                    FReceptionInfos.FieldByName('FUSARTID').AsInteger   := FieldByName('FUSARTID').AsInteger;
                    FReceptionInfos.FieldByName('FUSTGFID').AsInteger   := FieldByName('FUSTGFID').AsInteger;
                    FReceptionInfos.FieldByName('FUSCOUID').AsInteger   := FieldByName('FUSCOUID').AsInteger;
                    FReceptionInfos.FieldByName('ModNumber').AsString   := FPkModel.FieldByName('ModNumber').AsString;
                    FReceptionInfos.FieldByName('BrandNumber').AsString := FPkModel.FieldByName('BrandNumber').AsString;
                    FReceptionInfos.FieldByName('SizeRange').AsString   := FPkModel.FieldByName('SizeRange').AsString;
                    FReceptionInfos.FieldByName('ColorNumber').AsString := FPkColor.FieldByName('ColorNumber').AsString;
                    FReceptionInfos.FieldByName('ColumnX').AsString     := FPkItem.FieldByName('ColumnX').AsString;
                    FReceptionInfos.FieldByName('CBI_CB').AsString      := FPkItem.FieldByName('EAN').AsString;
                    FReceptionInfos.ClientDataSet.Post;
                    Next;
                  end;
                end; // with
                {$ENDREGION}

                {$REGION 'Génération des articles si nécessaire'}
                while not FReceptionInfos.EOF do
                begin

                    if (FReceptionInfos.FieldByName('ART_ID').AsInteger = -1) OR
                       (FReceptionInfos.FieldByName('TGF_ID').AsInteger = -1) OR
                       (FReceptionInfos.FieldByName('COU_ID').AsInteger = -1) then
                    begin
                      if (Trim(FPkModel.FieldByName('ModNumber').AsString) <> '') and
                         (Trim(FPkModel.FieldByName('BrandNumber').AsString) <> '') and
                         (Trim(FPkModel.FieldByName('SizeRange').AsString) <> '') then
                        if FArticle.Model.ClientDataSet.Locate('Modnumber;Brandnumber;Sizerange',
                                          VarArrayOf([FReceptionInfos.FieldByName('ModNumber').AsString,
                                                      FReceptionInfos.FieldByName('BrandNumber').AsString,
                                                      FReceptionInfos.FieldByName('SizeRange').AsString]),
                                          [loCaseInsensitive]) then
                        begin
                          Try
                            FArticle.DoMajTable(False);
                            if FArticle.IsOnError then
                              raise Exception.Create('Article création erreur');
                          Except on E:Exception do
                            begin
                              IsOnError := True;
                              for i := 0 to FArticle.ErrLogs.Count -1 do
                                FErrLogs.Add('Article -> ' + FArticle.ErrLogs[i]);
                              raise;
                            end;
                          End;

                            FReceptionInfos.ClientDataSet.Edit;
                            FReceptionInfos.FieldByName('ART_ID').AsInteger := FArticle.Model.FieldByName('ART_ID').AsInteger;
                            IF FArticle.Color.ClientDataSet.Locate('ColorNumber',FReceptionInfos.FieldByName('ColorNumber').AsString,[loCaseInsensitive]) then
                              FReceptionInfos.FieldByName('COU_ID').AsInteger := FArticle.Color.FieldByName('COU_ID').AsInteger
                            else
                              raise Exception.Create('Article -> Couleur non trouvée');

                            if FArticle.Item.ClientDataSet.Locate('ColumnX',FReceptionInfos.FieldByName('ColumnX').AsString,[loCaseInsensitive]) then
                              FReceptionInfos.FieldByName('TGF_ID').AsInteger := FArticle.Item.FieldByName('TGF_ID').AsInteger
                            else
                              raise Exception.Create('Article -> Taille non trouvé');
                            FReceptionInfos.Post;

                        end
                        else
                          raise Exception.Create(Format('Article non trouvé %s - %s - %s',
                                                 [FPkModel.FieldByName('ModNumber').AsString,
                                                  FPkModel.FieldByName('BrandNumber').AsString,
                                                  FPkModel.FieldByName('SizeRange').AsString]));
                    end;
                    FReceptionInfos.Next;
                end;
                {$ENDREGION}

                {$REGION 'Gestion des CB'}
                FReceptionInfos.First;
                while not FReceptionInfos.EOF do
                begin
                  // Si le ARF_ID = -1 c'est qu'on a du créer l'article plus tot avec ces CB
                  if (FReceptionInfos.FieldByName('ARF_ID').AsInteger <> -1) then
                  begin
                    SetARTCodeBarre(
                                    FReceptionInfos.FieldByName('ARF_ID').AsInteger,
                                    FReceptionInfos.FieldByName('TGF_ID').AsInteger,
                                    FReceptionInfos.FieldByName('COU_ID').AsInteger,
                                    1,
                                    '-1'
                                   );
                    SetARTCodeBarre(
                                    FReceptionInfos.FieldByName('ARF_ID').AsInteger,
                                    FReceptionInfos.FieldByName('TGF_ID').AsInteger,
                                    FReceptionInfos.FieldByName('COU_ID').AsInteger,
                                    3,
                                    FReceptionInfos.FieldByName('CBI_CB').AsString
                                   );
                  end;

                  FReceptionInfos.Next;
                end;
                {$ENDREGION}

                // Gestion du commentaire + N° de commande
                if trim(FPkItem.FieldByName('ORDERNO').AsString) <> '' then
                  LPA_COMENT := '[' + FPkItem.FieldByName('ORDERNO').AsString + '] ' + FPkItem.FieldByName('Comment').AsString
                else
                  LPA_COMENT := FPkItem.FieldByName('Comment').AsString;


                FReceptionInfos.First;

                while not FReceptionInfos.EOF do
                begin
                  if (FReceptionInfos.FieldByName('FUSARTID').AsInteger > 0) THEN
                  begin
                    // Article fusionné
                    LPA_ARTID := FReceptionInfos.FieldByName('FUSARTID').AsInteger;
                    LPA_TGFID := FReceptionInfos.FieldByName('FUSTGFID').AsInteger;
                    LPA_COUID := FReceptionInfos.FieldByName('FUSCOUID').AsInteger;

                    if (LPA_TGFID < 1) then
                    begin
                      FErrLogs.Add('Article -> Taille fusionnée non trouvée. (EAN : ' + FPkItem.FieldByName('EAN').AsString + ' Taille : ' + FPkModel.FieldByName('SizeRange').AsString + ')')
                    end;

                    if (LPA_COUID < 1) then
                    begin
                      FErrLogs.Add('Article -> Couleur fusionnée non trouvée. (EAN : ' + FPkItem.FieldByName('EAN').AsString + ' Couleur : ' + FPkColor.FieldByName('ColorNumber').AsString + ')')
                    end;
                  end
                  else begin
                    // Gestion des articles non fusionnées
                    LPA_ARTID := FReceptionInfos.FieldByName('ART_ID').AsInteger;
                    LPA_TGFID := FReceptionInfos.FieldByName('TGF_ID').AsInteger;
                    LPA_COUID := FReceptionInfos.FieldByName('COU_ID').AsInteger;
                  end;

                  // Désarchivage de l'article
                  DesarchiveArticle(LPA_ARTID);

                  // Si la ligne est déjà présente il faut faire un cumul
                  bIsCumul := FRecepStockLignes.ClientDataSet.Locate('LPA_CDLID;LPA_ARTID;LPA_TGFID;LPA_COUID;LPA_COMENT',
                                                                     VarArrayOf([FReceptionInfos.FieldByName('CDL_ID').AsInteger,LPA_ARTID,LPA_TGFID,LPA_COUID,LPA_COMENT]),[]);

                  // Gestion du RAL par cadence
                  if QteTmp > 0 then
                  begin
                    case CompareValue(QteTmp,FReceptionInfos.FieldByName('RAL_QTE').AsInteger,0.001) of
                      EqualsValue,
                      LessThanValue: begin
                        QteEnCours := QteTmp;
                        QteTmp := 0;
                      end;
                      GreaterThanValue: begin
                        QteEnCours := FReceptionInfos.FieldByName('RAL_QTE').AsInteger;
                        QteTmp := QteTmp - FReceptionInfos.FieldByName('RAL_QTE').AsInteger;
                      end;
                    end;

                    LPA_ID := SetRecAutoL(
                                 RecAutoP.BLP_ID,                                 // LPA_BLPID,
                                 LPA_ARTID, // LPA_ARTID,
                                 LPA_TGFID, // LPA_TGFID,
                                 LPA_COUID, // LPA_COUID,
                                 FReceptionInfos.FieldByName('CDL_ID').AsInteger, // LPA_CDLID,
                                 QteEnCours,                                      // LPA_QTE,
                                 FPkItem.FieldByName('Printlabel').AsInteger,     // LPA_PREETIK: Integer;
                                 LPA_COMENT,                                      // LPA_COMENT : String;
                                 FPkItem.FieldByName('Purchaseprice').AsCurrency, // LPA_PA,
                                 FPkItem.FieldByName('Salesprice').AsCurrency,    // LPA_PV: Currency;
                                 0,                                               // LPA_INCONU: Integer
                                 FPkItem.FieldByName('EAN').AsString,             // LPA_EAN : String
                                 bIsCumul                                         // AIsCumul : Booean
                               );

                    if FReceptionLignes.ClientDataSet.Locate('LPA_ID',LPA_ID,[]) then
                    begin
                      FReceptionLignes.ClientDataSet.Edit;
                      FReceptionLignes.FieldByName('Deleted').AsInteger := 0;
                      FReceptionLignes.ClientDataSet.Post;
                    end;

                    // Mise en mémoire des lignes rempli afin de pouvoir traiter l'ajout et la mise à jour des quantités des lignes du BL
                    if FRecepStockLignes.ClientDataSet.Locate('LPA_CDLID;LPA_ARTID;LPA_TGFID;LPA_COUID;LPA_COMENT',
                                                              VarArrayOf([FReceptionInfos.FieldByName('CDL_ID').AsInteger,LPA_ARTID,LPA_TGFID,LPA_COUID,LPA_COMENT]),[]) then
                    begin
                      // On met à jour la quantité
                      FRecepStockLignes.ClientDataSet.Edit;
                      FRecepStockLignes.FieldByName('LPA_QTE').AsInteger := FRecepStockLignes.FieldByName('LPA_QTE').AsInteger + QteEnCours;
                      FRecepStockLignes.Post;
                    end
                    else begin
                      // On crée une nouvelle ligne
                      FRecepStockLignes.Append;
                      FRecepStockLignes.FieldByName('LPA_CDLID').AsInteger := FReceptionInfos.FieldByName('CDL_ID').AsInteger;
                      FRecepStockLignes.FieldByName('LPA_ARTID').AsInteger := LPA_ARTID;
                      FRecepStockLignes.FieldByName('LPA_TGFID').AsInteger := LPA_TGFID;
                      FRecepStockLignes.FieldByName('LPA_COUID').AsInteger := LPA_COUID;
                      FRecepStockLignes.FieldByName('LPA_QTE').AsInteger   := QteEnCours;
                      FRecepStockLignes.FieldByName('LPA_COMENT').AsString := LPA_COMENT;
                      FRecepStockLignes.Post;
                    end;

                    // Gestion de la relation article/taille
                    FArticle.SetTailleTrav(FReceptionInfos.FieldByName('ART_ID').AsInteger,FReceptionInfos.FieldByName('TGF_ID').AsInteger);
                  end;

                  FReceptionInfos.Next;
                end; // while

                // Cas où il y a plus de quantité que de cadence
                if QteTmp > 0 then
                begin
                  // Alors on ajoute la QteTmp au reste de la dernière ligne qui a été traité
                  LPA_ID := SetRecAutoL(
                               RecAutoP.BLP_ID,                                 // LPA_BLPID,
                               LPA_ARTID, // FReceptionInfos.FieldByName('ART_ID').AsInteger, // LPA_ARTID,
                               LPA_TGFID, // FReceptionInfos.FieldByName('TGF_ID').AsInteger, // LPA_TGFID,
                               LPA_COUID, // FReceptionInfos.FieldByName('COU_ID').AsInteger, // LPA_COUID,
                               FReceptionInfos.FieldByName('CDL_ID').AsInteger,                                               // LPA_CDLID,
                               FReceptionInfos.FieldByName('RAL_QTE').AsInteger + QteTmp,                                          // LPA_QTE,
                               FPkItem.FieldByName('Printlabel').AsInteger,     // LPA_PREETIK: Integer;
                               LPA_COMENT,                                      // LPA_COMENT : String;
                               FPkItem.FieldByName('Purchaseprice').AsCurrency, // LPA_PA,
                               FPkItem.FieldByName('Salesprice').AsCurrency,    // LPA_PV: Currency;
                               0,                                               // LPA_INCONU: Integer
                               FPkItem.FieldByName('EAN').AsString,             // LPA_EAN : String
                               bIsCumul                                         // AISCUMUL : Boolean
                             );

                  if FReceptionLignes.ClientDataSet.Locate('LPA_ID',LPA_ID,[]) then
                  begin
                    FReceptionLignes.ClientDataSet.Edit;
                    FReceptionLignes.FieldByName('Deleted').AsInteger := 0;
                    FReceptionLignes.ClientDataSet.Post;
                  end;
                end;

                FPkItem.Next;
              end;

              FPkColor.Next;
            end;

            FPkModel.Next;
          end;

        {$REGION 'suppression des lignes deleted = 1'}
        FReceptionLignes.First;
        while not FReceptionLignes.EOF do
        begin
          if FReceptionLignes.FieldByName('Deleted').AsInteger = 1 then
          begin
            UpdateKId(FReceptionLignes.FieldByName('LPA_ID').AsInteger,1);
            IsUpdated := True;
          end;
          FReceptionLignes.Next;
        end;
        {$ENDREGION}

        if FReceptionPackages.ClientDataSet.Locate('BLP_ID',RecAutoP.BLP_ID,[]) then
        begin
          FReceptionPackages.ClientDataSet.Edit;
          FReceptionPackages.FieldByName('Deleted').AsInteger := 0;
          FReceptionPackages.ClientDataSet.Post;
        end;

        FPackages.Next;
      end; // While

      {$REGION 'Suppression des lignes de packages deleted = 1'}
      FReceptionPackages.First;
      while not FReceptionPackages.EOF do
      begin
        if FReceptionPackages.FieldbyName('Deleted').AsInteger = 1 then
        begin
          UpdateKId(FReceptionPackages.FieldByName('BLP_ID').AsInteger, 1);
          IsUpdated := True;
        end;

        FReceptionPackages.Next;
      end;
      {$ENDREGION}

    end; // if


    {$REGION 'Traitement de la partie Unknown'}

    {$REGION 'Suppression des lignes unknown'}
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select LPU_ID from RECAUTOU');
      SQL.Add('  Join K on K_ID = LPU_ID and K_Enabled = 1');
      SQL.Add('Where LPU_BLAID = :PBLAID');
      ParamCheck := True;
      ParamByName('PBLAID').AsInteger := RecAuto.BLA_ID;
      Open;

      FReceptionUkLignes.ClientDataSet.EmptyDataSet;
      while not EOF do
      begin
        FReceptionUkLignes.ClientDataSet.Append;
        FReceptionUkLignes.FieldByName('LPU_ID').AsInteger := FieldByName('LPU_ID').AsInteger;
        FReceptionUkLignes.ClientDataSet.Post;
        Next;
      end;
    end;

    FReceptionUkLignes.First;
    while Not FReceptionUkLignes.Eof do
    begin
      UpdateKId(FReceptionUkLignes.FieldByName('LPU_ID').AsInteger, 1);
    FReceptionUkLignes.Next;
    end;
    {$ENDREGION}

    FUkItem.First;
    if RecAuto.Etat = 0 then
      while not FUkItem.EOF do
      begin

        LPU_ID := SetRecAutoU(FUkItem.FieldByName('PackageCode').AsString,
                      FUkItem.FieldByName('ORDERNO').AsString,
                      FUkItem.FieldByName('BRANDNUMBER').AsString,
                      FUkItem.FieldByName('MODNUMBER').AsString,
                      FUkItem.FieldByName('EAN').AsString,
                      FUkItem.FieldByName('QTY').AsInteger,
                      '[' + FUkItem.FieldByName('ORDERNO').AsString + ']' + FUkItem.FieldByName('COMMENT').AsString,
                      RecAuto.BLA_ID,
                      FUkItem.FieldByName('ItemDenotation').AsString);
        FUkItem.Next;
      end;
    {$ENDREGION}


  Except on E:Exception do
    begin
      FErrLogs.Add(FTitle + ' : ' + E.Message);
      IsOnError := True;
//      raise Exception.Create(FTitle + ' : ' + E.Message);
    end;
  End;

 // Génération des informations de mails
 if not FArticle.IsOnError then
 begin
   if FArticle.ArticleMailList.Count > 0 then
     NewArtList.Add(FArticle.ArticleMailList.Text);
 end
 else
   IsOnError := True;

 if IsCreated or IsUpdated or IsOnError then
 begin
  if IsOnError then
    sError := 'ERROR'
  else
    sError := '';

  FRecepList.Add('<tr>');
  FRecepList.Add(Format('<td class="NUMBL-LG%s">%s</td>',[sError,Deliverynotenumber]));
  FRecepList.Add(Format('<td class="SUPPLIER-LG%s">%s</td>',[sError,FSupplierName]));
  FRecepList.Add(Format('<td class="DATEBL-LG%s">%s</td>',[sError, FormatDateTime('DD/MM/YYYY',Deliverydate)]));
  if IsCreated then
    FRecepList.Add(Format('<td class="ETAT-LG%s">Création</td>',[sError]))
  else
    FRecepList.Add(Format('<td class="ETAT-LG%s">Mise à jour</td>',[sError]));
  FRecepList.Add('</tr>');
 end;


end;

function TReceptionClass.GetFournId(Suppliers: TSuppliers; AERPCODE,
  ACODE: String): Integer;
var
  iPass : Integer;
  bFindMode, bDoFindSupplierTbTmp, bFoundFOUID : Boolean;
  sLocateSupplierField, sLocateTbTmpField, sLocateValue : String;
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
        raise Exception.Create(Format('Fournisseur non trouvé: ERP %s / Code %s',[AERPCODE,ACODE]));
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
        end
        else begin
          Try
            Result := Suppliers.GetSuppliers(sLocateSupplierField,sLocateValue);
            FSupplierName := Suppliers.FieldByName('Denotation').AsString;
            bFoundFOUID := True;
          Except
            on ENOTFIND do
              bFoundFOUID := False;
            on E:Exception do
              raise;
          End;
        end;
      end;
    end;
    Inc(iPass);
  end;
end;

procedure TReceptionClass.Import;
var
  Xml : IXMLDocument;
  nXmlBase,
  nHeaderNode,
  nPackagesNode,
  nPackageNode,
  nPkModelListNode,
  nPkModelNode,
  nPkColorListNode,
  nPkColorNode,
  nPkItemList,
  nPkItemNode,
  nUnknownNode,
  nUkItemListNode,
  nUkItemNode  : IXMLNode;

   // Noeud Packages
  PackageCode, Totalnumberofitems, Palletnumber, UniversDenotation : TFieldCFG;

  // Noeud Model
  {PackageCode,} ModNumber, BrandNumber, Sizerange, FEDAS, VAT : TFieldCFG;

  // Noeud Color
  {PackageCode, ModNumber,} Colornumber : TFieldCFG;

  // Noeud Item
  {PackageCode,} Orderno, ColumnX, Sizelabel, EAN, Qty, Purchaiseprice, Printlabel, Comment, Salesprice, SizeID : TFieldCFG;

  // Noeud Unknown
  {PackageCode, Orderno, ModNumber, EAN, Qty,Comment,} Itemdenotation : TFieldCfg;

  // ReceptionPackages
  BLP_ID, Deleted : TFieldCfg;

  // ReceptionLignes
  LPA_ID, LPA_ARTID, LPA_TGFID, LPA_COUID, LPA_CDLID, LPA_QTE, Updated, ART_FUSARTID : TFieldCfg;

  // ReceptionInfos
  CDL_ID, ART_ID, ARF_ID, TGF_ID, COU_ID, FUSARTID, FUSTGFID, FUSCOUID, RAL_QTE, CBI_CB : TFieldCFG;

  // ReceptionUkLignes
  LPU_ID : TFieldCfg;

  LPA_COMENT : TFieldCfg;

begin
  // Création des CDS en mémoire

  {$REGION 'Cds Packages'}
  PackageCode.FieldName := 'Packagecode';
  PackageCode.FieldType := ftString;
  Totalnumberofitems.FieldName := 'Totalnumberofitems';
  Totalnumberofitems.FieldType := ftInteger;
  Palletnumber.FieldName := 'Palletnumber';
  Palletnumber.FieldType := ftString;
  UniversDenotation.FieldName := 'UNIVERSDENOTATION';
  UniversDenotation.FieldType :=ftString;

  FPackages.CreateField([PackageCode,Totalnumberofitems,Palletnumber,UniversDenotation]);
  FPackages.ClientDataSet.AddIndex('Idx','Packagecode',[]);
  {$ENDREGION}

  {$REGION 'Cds Model'}
  ModNumber.FieldName := 'Modnumber';
  ModNumber.FieldType := ftString;
  BrandNumber.FieldName := 'Brandnumber';
  BrandNumber.FieldType := ftString;
  Sizerange.FieldName := 'Sizerange';
  Sizerange.FieldType := ftString;
  FEDAS.FieldName := 'FEDAS';
  FEDAS.FieldType := ftString;
  VAT.FieldName := 'VAT';
  VAT.FieldType := ftCurrency;
  FPkModel.CreateField([PackageCode,ModNumber, BrandNumber, Sizerange, FEDAS, VAT]);
  FPkModel.ClientDataSet.AddIndex('Idx','PackageCode;ModNumber;BrandNumber;Sizerange',[]);
  FPkModel.ClientDataSet.IndexName := 'Idx';
  FPkModel.ClientDataSet.MasterFields := 'Packagecode';
  FPkModel.ClientDataSet.MasterSource := FDs_Package;
  {$ENDREGION}

  {$REGION 'Cds Color'}
  Colornumber.FieldName := 'Colornumber';
  Colornumber.FieldType := ftString;

  FPkColor.CreateField([PackageCode,ModNumber, BrandNumber, Sizerange,Colornumber]);
  FPkColor.ClientDataSet.AddIndex('Idx','PackageCode;ModNumber;BrandNumber;Sizerange;Colornumber',[]);
  FPkColor.ClientDataSet.IndexName := 'Idx';
  FPkColor.ClientDataSet.MasterFields := 'PackageCode;ModNumber;BrandNumber;Sizerange';
  FPkColor.ClientDataSet.MasterSource := FDs_PkModel;
  {$ENDREGION}

  {$REGION 'Cds Item'}
  Orderno.FieldName := 'Orderno';
  Orderno.FieldType := ftString;
  ColumnX.FieldName := 'ColumnX';
  ColumnX.FieldType := ftString;
  Sizelabel.FieldName := 'Sizelabel';
  Sizelabel.FieldType := ftString;
  EAN.FieldName := 'EAN';
  EAN.FieldType := ftString;
  Qty.FieldName := 'Qty';
  Qty.FieldType := ftInteger;
  Purchaiseprice.FieldName := 'Purchaseprice';
  Purchaiseprice.FieldType := ftCurrency;
  Printlabel.FieldName := 'Printlabel';
  Printlabel.FieldType := ftString;
  Comment.FieldName := 'Comment';
  Comment.FieldType := ftString;
  Salesprice.FieldName := 'Salesprice';
  Salesprice.FieldType := ftCurrency;
  SizeID.FieldName := 'SizeID';
  SizeID.FieldType := ftString;

  FPkItem.CreateField([PackageCode, ModNumber, BrandNumber, Sizerange, Colornumber,
                       Orderno, ColumnX, Sizelabel, EAN, Qty, Purchaiseprice,
                       Printlabel, Comment, Salesprice, SizeID]);
  FPkItem.ClientDataSet.AddIndex('Idx','PackageCode;ModNumber;BrandNumber;Sizerange;Colornumber;ColumnX',[]);
  FPkItem.ClientDataSet.IndexName := 'Idx';
  FPkItem.ClientDataSet.MasterFields := 'PackageCode;ModNumber;BrandNumber;Sizerange;Colornumber';
  FPkItem.ClientDataSet.MasterSource := FDs_PkColor;
  {$ENDREGION}

  {$REGION 'Cds Unknown'}
  Itemdenotation.FieldName := 'Itemdenotation';
  Itemdenotation.FieldType := ftString;

  FUkItem.CreateField([PackageCode, Orderno, ModNumber, BrandNumber, EAN, Qty,Comment, Itemdenotation]);
  {$ENDREGION}

  {$REGION 'ReceptionPackages'}
  BLP_ID.FieldName    := 'BLP_ID';
  BLP_ID.FieldType    := ftInteger;
  Deleted.FieldName   := 'Deleted';
  Deleted.FieldType   := ftInteger;

  FReceptionPackages.CreateField([BLP_ID,Deleted]);
  {$ENDREGION}

  {$REGION 'ReceptionLignes'}
  LPA_ID.FieldName       := 'LPA_ID';
  LPA_ID.FieldType       := ftInteger;
  LPA_ARTID.FieldName    := 'LPA_ARTID';
  LPA_ARTID.FieldType    := ftInteger;
  LPA_TGFID.FieldName    := 'LPA_TGFID';
  LPA_TGFID.FieldType    := ftInteger;
  LPA_COUID.FieldName    := 'LPA_COUID';
  LPA_COUID.FieldType    := ftInteger;
  LPA_CDLID.FieldName    := 'LPA_CDLID';
  LPA_CDLID.FieldType    := ftInteger;
  LPA_QTE.FieldName      := 'LPA_QTE';
  LPA_QTE.FieldType      := ftInteger;
  Updated.FieldName      := 'Updated';
  Updated.FieldType      := ftInteger;
  ART_FUSARTID.FieldName := 'ART_FUSARTID';
  ART_FUSARTID.FieldType := ftInteger;

  FReceptionLignes.CreateField([LPA_ID, LPA_ARTID, LPA_TGFID, LPA_COUID, LPA_CDLID, LPA_QTE,ART_FUSARTID, Updated, Deleted]);
  {$ENDREGION}

  {$REGION 'FRecepStockLignes'}
  LPA_COMENT.FieldName := 'LPA_COMENT';
  LPA_COMENT.FieldType := ftString;
  // Permet de stocker les données temporaires.
  FRecepStockLignes.CreateField([LPA_CDLID, LPA_ARTID,LPA_TGFID,LPA_COUID,LPA_QTE,LPA_COMENT]);
  {$ENDREGION}

  {$REGION 'ReceptionInfos'}
  CDL_ID.FieldName  := 'CDL_ID';
  CDL_ID.FieldType  := ftInteger;
  ART_ID.FieldName  := 'ART_ID';
  ART_ID.FieldType  := ftInteger;
  ARF_ID.FieldName  := 'ARF_ID';
  ARF_ID.FieldType  := ftInteger;
  TGF_ID.FieldName  := 'TGF_ID';
  TGF_ID.FieldType  := ftInteger;
  COU_ID.FieldName  := 'COU_ID';
  COU_ID.FieldType  := ftInteger;
  RAL_QTE.FieldName := 'RAL_QTE';
  RAL_QTE.FieldType := ftInteger;
  CBI_CB.FieldName  := 'CBI_CB';
  CBI_CB.FieldType  := ftString;
  FUSARTID.FieldName := 'FUSARTID';
  FUSARTID.FieldType := ftInteger;
  FUSTGFID.FieldName := 'FUSTGFID';
  FUSTGFID.FieldType := ftInteger;
  FUSCOUID.FieldName := 'FUSCOUID';
  FUSCOUID.FieldType := ftInteger;

  FReceptionInfos.CreateField([CDL_ID, ART_ID, ARF_ID, TGF_ID, COU_ID,
                               FUSARTID, FUSTGFID, FUSCOUID,
                               RAL_QTE, CBI_CB, ModNumber,
                               BrandNumber, Sizerange, Colornumber, ColumnX]);
  {$ENDREGION}

  {$REGION 'ReceptionUkLignes'}
  LPU_ID.FieldName := 'LPU_ID';
  LPU_ID.FieldType := ftInteger;

  FReceptionUkLignes.CreateField([LPU_ID, Deleted]);
  {$ENDREGION}

  // gestion du Xml de réception
  try
    Xml := TXMLDocument.Create(nil);
    try
      if not FileExists(FPath + FTitle + '.xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;
      nHeaderNode := nXmlBase.ChildNodes.FindNode('HEADER');

      if nHeaderNode <> nil then
      begin
        FSupplierKey           := XmlStrToStr(nHeaderNode.ChildValues['Supplierkey']);
        FReferenceNumber       := XmlStrToStr(nHeaderNode.ChildValues['Referencenumber']);
        FBranchNumber          := XmlStrToStr(nHeaderNode.ChildValues['Branchnumber']);
        FCodeMag               := XmlStrToStr(nHeaderNode.ChildValues['Membercode']);
        FTotalweight           := XmlStrToFloat(nHeaderNode.ChildValues['Totalweight']);
        FTotalnumberofpackages := XmlStrToInt(nHeaderNode.ChildValues['Totalnumberofpackages']);
        FDeliverydate          := XmlStrToDate(nHeaderNode.ChildValues['Deliverydate']);
        FDeliverynotenumber    := XmlStrToStr(nHeaderNode.ChildValues['Deliverynotenumber']);
        FTotalnumberofitems    := XmlStrToInt(nHeaderNode.ChildValues['Totalnumberofitems']);
        FTotalnumberofpallets  := XmlStrToInt(nHeaderNode.ChildValues['Totalnumberofpallets']);
        FShipCompName          := XmlStrToStr(nHeaderNode.ChildValues['ShipCompName']);
        FComment               := XmlStrToStr(nHeaderNode.ChildValues['Comment']);
      end;

      // Traitement du noeud Packages
      nPackagesNode := nXmlBase.ChildNodes.FindNode('PACKAGES');
      nPackageNode := nil;
      if nPackagesNode <> nil then
        nPackageNode := nPackagesNode.ChildNodes['PACKAGE'];
      while nPackageNode <> nil do
      begin
        FPackages.ClientDataSet.Append;
        FPackages.FieldByName('Packagecode').AsString := XmlStrToStr(nPackageNode.ChildValues['Packagecode']);
        FPackages.FieldByName('Totalnumberofitems').AsInteger := XmlStrToInt(nPackageNode.ChildValues['Totalnumberofitems']);
        FPackages.FieldByName('Palletnumber').AsString := XmlStrToStr(nPackageNode.ChildValues['Palletnumber']);
        FPackages.FieldByName('UniversDenotation').AsString := XmlStrToStr(nPackageNode.ChildValues['UNIVERSDENOTATION']);
        FPackages.ClientDataSet.Post;

        // Traitement du noeud Model
        nPkModelListNode := nPackageNode.ChildNodes['MODELLIST'];
        nPkModelNode := nil;
        if nPkModelListNode <> nil then
          nPkModelNode := nPkModelListNode.ChildNodes['MODEL'];
        while nPkModelNode <> nil do
        begin
          FPkModel.Append;
          FPkModel.FieldByName('PackageCode').AsString := XmlStrToStr(nPackageNode.ChildValues['Packagecode']);
          FPkModel.FieldByName('ModNumber').AsString   := XmlStrToStr(nPkModelNode.ChildValues['Modnumber']);
          FPkModel.FieldByName('BrandNumber').AsString := XmlStrToStr(nPkModelNode.ChildValues['Brandnumber']);
          FPkModel.FieldByName('Sizerange').AsString   := XmlStrToStr(nPkModelNode.ChildValues['Sizerange']);
          FPkModel.FieldByName('FEDAS').AsString       := XmlStrToStr(nPkModelNode.ChildValues['FEDAS']);
          FPkModel.FieldByName('VAT').AsCurrency       := XmlStrToFloat(nPkModelNode.ChildValues['VAT']);
          FPkModel.Post;

          // Traitement de l'article
          if Not FArticle.Model.ClientDataSet.Locate('Modnumber;Brandnumber;Sizerange',
                                VarArrayOf([FPkModel.FieldByName('ModNumber').AsString,
                                 FPkModel.FieldByName('BrandNumber').AsString,
                                 FPkModel.FieldByName('Sizerange').AsString])
                                ,[loCaseInsensitive]) then
          begin
            FArticle.Model.Append;
            FArticle.Model.FieldByName('SupplierKey').AsString     := FSupplierKey;
            FArticle.Model.FieldByName('Modnumber').AsString       := FPkModel.FieldByName('ModNumber').AsString;
            FArticle.Model.FieldByName('Brandnumber').AsString     := FPkModel.FieldByName('BrandNumber').AsString;
            FArticle.Model.FieldByName('Sizerange').AsString       := FPkModel.FieldByName('Sizerange').AsString;
            FArticle.Model.FieldByName('Moddenotation').AsString   := XmlStrToStr(nPkModelNode.ChildValues['Moddenotation']);
            FArticle.Model.FieldByName('Branddenotation').AsString := XmlStrToStr(nPkModelNode.ChildValues['Branddenotation']);
            FArticle.Model.FieldByName('FEDAS').AsString           := FPkModel.FieldByName('FEDAS').AsString;
            FArticle.Model.FieldByName('VAT').AsCurrency           := FPkModel.FieldByName('VAT').AsCurrency;
            FArticle.Model.Post;
          end;

          // Traitement du noeud Color
          nPkColorListNode := nPkModelNode.ChildNodes['COLORLIST'];
          nPkColorNode := nil;
          if nPkColorListNode <> nil then
            nPkColorNode := nPkColorListNode.ChildNodes['COLOR'];

          while nPkColorNode <> nil do
          begin
            FPkColor.ClientDataSet.Append;
            FPkColor.FieldByName('PackageCode').AsString := XmlStrToStr(nPackageNode.ChildValues['Packagecode']);
            FPkColor.FieldByName('ModNumber').AsString   := XmlStrToStr(nPkModelNode.ChildValues['Modnumber']);
            FPkColor.FieldByName('BrandNumber').AsString := XmlStrToStr(nPkModelNode.ChildValues['Brandnumber']);
            FPkColor.FieldByName('Sizerange').AsString   := XmlStrToStr(nPkModelNode.ChildValues['Sizerange']);
            FPkColor.FieldByName('Colornumber').AsString := XmlStrToStr(nPkColorNode.ChildValues['Colornumber']);
            FPkColor.ClientDataSet.Post;

            // Gestion de l'article
            if not FArticle.Color.ClientDataSet.Locate('Modnumber;Brandnumber;Sizerange;Colornumber',
                              VarArrayof([FPkColor.FieldByName('ModNumber').AsString,
                               FPkColor.FieldByName('BrandNumber').AsString,
                               FPkColor.FieldByName('Sizerange').AsString,
                               FPkColor.FieldByName('Colornumber').AsString]),
                              [loCaseInsensitive]) then
            begin
              FArticle.Color.Append;
              FArticle.Color.FieldByName('Modnumber').AsString   := FPkColor.FieldByName('ModNumber').AsString;
              FArticle.Color.FieldByName('Brandnumber').AsString   := FPkColor.FieldByName('BrandNumber').AsString;
              FArticle.Color.FieldByName('Sizerange').AsString   := FPkColor.FieldByName('Sizerange').AsString;
              FArticle.Color.FieldByName('Colornumber').AsString   := FPkColor.FieldByName('Colornumber').AsString;
              FArticle.Color.FieldByName('Colordenotation').AsString := XmlStrToStr(nPkColorNode.ChildValues['colordenotation']);
              FArticle.Color.Post;
            end;

            // Traitement du noeud Item
            nPkItemList := nPkColorNode.ChildNodes['ITEMLIST'];
            nPkItemNode := nil;
            if nPkItemList <> nil then
              nPkItemNode := nPkItemList.ChildNodes['ITEM'];

            while nPkItemNode <> nil do
            begin
              FPkItem.ClientDataSet.Append;
              FPkItem.FieldByName('PackageCode').AsString      := XmlStrToStr(nPackageNode.ChildValues['Packagecode']);
              FPkItem.FieldByName('ModNumber').AsString        := XmlStrToStr(nPkModelNode.ChildValues['Modnumber']);
              FPkItem.FieldByName('BrandNumber').AsString      := XmlStrToStr(nPkModelNode.ChildValues['Brandnumber']);
              FPkItem.FieldByName('Sizerange').AsString        := XmlStrToStr(nPkModelNode.ChildValues['Sizerange']);
              FPkItem.FieldByName('Colornumber').AsString      := XmlStrToStr(nPkColorNode.ChildValues['Colornumber']);
              FPkItem.FieldByName('Orderno').AsString          := XmlStrToStr(nPkItemNode.ChildValues['Orderno']);
              FPkItem.FieldByName('ColumnX').AsString          := XmlStrToStr(nPkItemNode.ChildValues['ColumnX']);
              FPkItem.FieldByName('Sizelabel').AsString        := XmlStrToStr(nPkItemNode.ChildValues['Sizelabel']);
              FPkItem.FieldByName('EAN').AsString              := XmlStrToStr(nPkItemNode.ChildValues['EAN']);
              FPkItem.FieldByName('Qty').AsInteger             := XmlStrToInt(nPkItemNode.ChildValues['Qty']);
              FPkItem.FieldByName('Purchaseprice').AsCurrency  := XmlStrToFloat(nPkItemNode.ChildValues['Purchaseprice']);
              FPkItem.FieldByName('Printlabel').AsString       := XmlStrToStr(nPkItemNode.ChildValues['Printlabel']);
              FPkItem.FieldByName('Comment').AsString          := XmlStrToStr(nPkItemNode.ChildValues['Comment']);
              FPkItem.FieldByName('Salesprice').AsCurrency     := XmlStrToFloat(nPkItemNode.ChildValues['Salesprice']);
              FPkItem.FieldByName('SizeID').AsString           := XmlStrToStr(nPkItemNode.ChildValues['SizeIDX']);
              FPkItem.ClientDataSet.Post;

              // Gestion de l'article
              if not FArticle.Item.ClientDataSet.Locate('Modnumber;Brandnumber;Sizerange;Colornumber;ColumnX',
                               VarArrayOf([FPkItem.FieldByName('ModNumber').AsString,
                                FPkItem.FieldByName('BrandNumber').AsString,
                                FPkItem.FieldByName('Sizerange').AsString,
                                FPkItem.FieldByName('Colornumber').AsString,
                                FPkItem.FieldByName('ColumnX').AsString]),
                               [loCaseInsensitive]) then
              begin
                FArticle.Item.Append;
                FArticle.Item.FieldByName('Modnumber').AsString       := FPkItem.FieldByName('ModNumber').AsString;
                FArticle.Item.FieldByName('Brandnumber').AsString     := FPkItem.FieldByName('BrandNumber').AsString;
                FArticle.Item.FieldByName('Sizerange').AsString       := FPkItem.FieldByName('Sizerange').AsString;
                FArticle.Item.FieldByName('Colornumber').AsString     := FPkItem.FieldByName('Colornumber').AsString;
                FArticle.Item.FieldByName('ColumnX').AsString         := FPkItem.FieldByName('ColumnX').AsString;
                FArticle.Item.FieldByName('Sizelabel').AsString       := FPkItem.FieldByName('Sizelabel').AsString;
                FArticle.Item.FieldByName('EAN').AsString             := FPkItem.FieldByName('EAN').AsString;
                FArticle.Item.FieldByName('Purchaseprice').AsCurrency := FPkItem.FieldByName('Purchaseprice').AsCurrency;
                FArticle.Item.FieldByName('Salesprice').AsCurrency    := FPkItem.FieldByName('Salesprice').AsCurrency;
                FArticle.Item.FieldByName('SizeIDX').AsString         := FPkItem.FieldByName('SizeID').AsString;
                FArticle.Item.Post;
              end;

              nPkItemNode := nPkItemNode.NextSibling;
            end;

            nPkColorNode := nPkColorNode.NextSibling;
          end;

          nPkModelNode := nPkModelNode.NextSibling;
        end;

        nPackageNode := nPackageNode.NextSibling;
      end;

      // Traitement du noeud Unknown
      nUnknownNode := nXmlBase.ChildNodes.FindNode('UNKNOWN');
      if nUnknownNode <> nil then
      begin
        nUkItemListNode := nUnknownNode.ChildNodes['ITEMLIST'];
        nUkItemNode := nil;
        if nUkItemListNode <> nil then
          nUkItemNode := nUkItemListNode.ChildNodes['ITEM'];

        while nUkItemNode <> nil do
        begin
          FUkItem.ClientDataSet.Append;
          FUkItem.FieldByName('PackageCode').AsString    := XmlStrToStr(nUkItemNode.ChildValues['Packagecode']);
          FUkItem.FieldByName('Orderno').AsString        := XmlStrToStr(nUkItemNode.ChildValues['Orderno']);
          FUkItem.FieldByName('ModNumber').AsString      := XmlStrToStr(nUkItemNode.ChildValues['Modnumber']);
          FUkItem.FieldByName('BrandNumber').AsString      := XmlStrToStr(nUkItemNode.ChildValues['Branddenotation']);
          FUkItem.FieldByName('EAN').AsString            := XmlStrToStr(nUkItemNode.ChildValues['EAN']);
          FUkItem.FieldByName('Qty').AsString            := XmlStrToStr(nUkItemNode.ChildValues['Qty']);
          FUkItem.FieldByName('Comment').AsString        := XmlStrToStr(nUkItemNode.ChildValues['Comment']);
          FUkItem.FieldByName('Itemdenotation').AsString := XmlStrToStr(nUkItemNode.ChildValues['Itemdenotation']);
          FUkItem.ClientDataSet.Post;

          nUkItemNode := nUkItemNode.NextSibling;
        end;
      end;

    finally
      Xml := Nil;
      TXMLDocument(Xml).Free;
    end;
  Except on E:Exception do
    raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
  end;
end;

function TReceptionClass.SetARTCodeBarre(ACBI_ARFID, ACBI_TGFID, ACBI_COUID,
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
    Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
    Inc(FMajCount, FieldByName('FMAJ').AsInteger);
    IsUpdated := IsUpdated or
                 (FieldByName('FAJOUT').AsInteger > 0) or
                 (FieldByName('FMAJ').AsInteger > 0);
  Except on E:Exception Do
    raise Exception.Create('SetARTCodeBarre -> ' + E.Message);
  end;
end;

function TReceptionClass.SetRecAuto(BLA_NUMERO: String; BLA_DATE: TDate;
  BLA_FOUID: Integer; BLA_TRANS: String; BLA_MAGID: Integer; BLA_COMENT: String;
  BLA_ETAT, BLA_NBPAL, BLA_NBPAQ, BLA_NBART: Integer): TRECAUTO;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_RECEP_RECAUTO(:PBLANUMERO,:PBLADATE,:PBLAFOUID,:PBLATRANS,:PBLAMAGID,');
    SQL.Add(':PBLACOMENT,:PBLAETAT,:PBLANBPAL,:PBLANBPAQ,:PBLANBART)');
    ParamCheck := True;
    ParamByName('PBLANUMERO').AsString  := BLA_NUMERO;
    ParamByName('PBLADATE').AsDate     := BLA_DATE;
    ParamByName('PBLAFOUID').AsInteger := BLA_FOUID;
    ParamByName('PBLATRANS').AsString  := BLA_TRANS;
    ParamByName('PBLAMAGID').AsInteger := BLA_MAGID;
    ParamByName('PBLACOMENT').AsString := BLA_COMENT;
    ParamByName('PBLAETAT').AsInteger  := BLA_ETAT;
    ParamByName('PBLANBPAL').AsInteger := BLA_NBPAL;
    ParamByName('PBLANBPAQ').AsInteger := BLA_NBPAQ;
    ParamByName('PBLANBART').AsInteger := BLA_NBART;
    Open;

    if RecordCount > 0 then
    begin
      Result.BLA_ID := FieldByName('BLA_ID').AsInteger;
      Result.Etat   := FieldByName('ETAT').AsInteger;
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      IsCreated := (FieldByName('FAJOUT').AsInteger > 0);
      IsUpdated := (FieldByName('FMAJ').AsInteger > 0);
    end;
  Except on E:Exception do
    raise Exception.Create('SetRecAuto -> ' + E.Message);
  end;
end;

function TReceptionClass.SetRecAutoL(LPA_BLPID, LPA_ARTID, LPA_TGFID,
  LPA_COUID, LPA_CDLID, LPA_QTE, LPA_PREETIK: Integer;
  LPA_COMENT : String;LPA_PA, LPA_PV: Currency; LPA_INCONU: Integer; LPA_EAN : String; AIsCumul : Boolean): Integer;
begin
  With FIboQuery do
  Try
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_RECEP_RECAUTOL');
    SQL.Add('(:PLPABLPID,:PLPAARTID,:PLPATGFID,:PLPACOUID,:PLPACDLID,:PLPAQTE,:PLPAPREETIK,:PLPACOMENT,:PLPAPA,:PLPAPV,:PLPAINCONU,:PLPAEAN, :ISCUMUL)');
    ParamCheck := True;
    ParamByName('PLPABLPID').AsInteger := LPA_BLPID;
    ParamByName('PLPAARTID').AsInteger := LPA_ARTID;
    ParamByName('PLPATGFID').AsInteger := LPA_TGFID;
    ParamByName('PLPACOUID').AsInteger := LPA_COUID;
    ParamByName('PLPACDLID').AsInteger := LPA_CDLID;
    ParamByName('PLPAQTE').AsInteger   := LPA_QTE;
    case LPA_PREETIK of
      0: ParamByName('PLPAPREETIK').AsInteger := 1;
      1: ParamByName('PLPAPREETIK').AsInteger := 0;
    end;
//    ParamByName('PLPAPREETIK').AsInteger  := LPA_PREETIK;
    ParamByName('PLPACOMENT').AsString    := LPA_COMENT;
    ParamByName('PLPAPA').AsCurrency      := LPA_PA;
    ParamByName('PLPAPV').AsCurrency      := LPA_PV;
    ParamByName('PLPAINCONU').AsInteger   := LPA_INCONU;
    ParamByName('PLPAEAN').AsString       := LPA_EAN;
    if AIsCumul then
      ParamByName('ISCUMUL').AsInteger := 1
    else
      ParamByName('ISCUMUL').AsInteger := 0;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('LPA_ID').AsInteger;
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);

      IsUpdated := IsUpdated or
                   (FieldByName('FMAJ').AsInteger > 0) or
                   (FieldByName('FAJOUT').AsInteger > 0);

    end;
  Except on E:Exception Do
    raise Exception.Create('SetRecAutoL -> ' + E.Message);
  end;
end;

function TReceptionClass.SetRecAutoP(BLP_BLAID: Integer; BLP_NUMERO,
  BLP_PALETTE: String; BLP_QTE: Integer; BLP_UNIVERS: String;BLP_ETAT : Integer): TRECAUTOP;
begin
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_RECEP_RECAUTOP(:PBLPBLAID,:PBLPNUMERO,:PBLPALETTE,');
    SQL.Add( ':PBLPQTE,:PBLPUNIVERS,:PBLPETAT)');
    ParamCheck := True;
    ParamByName('PBLPBLAID').AsInteger  := BLP_BLAID;
    ParamByName('PBLPNUMERO').AsString  := BLP_NUMERO;
    ParamByName('PBLPALETTE').AsString := BLP_PALETTE;
    ParamByName('PBLPQTE').AsInteger    := BLP_QTE;
    ParamByName('PBLPUNIVERS').AsString := BLP_UNIVERS;
    ParamByName('PBLPETAT').AsInteger   := BLP_ETAT;
    Open;

    if RecordCount > 0 then
    begin
      Result.BLP_ID := FieldByName('BLP_ID').AsInteger;
      Result.Etat   := FieldByName('ETAT').AsInteger;
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      IsUpdated := IsUpdated or
                   (FieldByName('FMAJ').AsInteger > 0) or
                   (FieldByName('FAJOUT').AsInteger > 0);
    end;
  Except on E:Exception do
    raise Exception.Create('SetRecAutoP -> ' + E.Message);
  end;
end;

function TReceptionClass.SetRecAutoU(LPU_PAQUET, ORDERNO, BRAND,
  MODNUMBER, LPU_EAN: String; LPU_QTE: Integer; LPU_COMMENT: String; LPU_BLAID : integer; LPU_ARTNOM : String): Integer;
begin
  Result := 0;
  With FIboQuery do
  try
    Close;
    SQL.Clear;
    SQL.Add('Select * from MSS_RECEP_RECAUTOU(:PPAQUET, :PORDERNO, :PBRAND, :PMODNUM, :PEAN, :PQTE, :PCOMENT, :PBLAID, :PARTNOM)');
    ParamCheck := True;
    ParamByName('PPAQUET').AsString  := LPU_PAQUET;
    ParamByName('PORDERNO').AsString := ORDERNO;
    ParamByName('PBRAND').AsString   := BRAND;
    ParamByName('PMODNUM').AsString  := MODNUMBER;
    ParamByName('PEAN').AsString     := LPU_EAN;
    ParamByName('PQTE').AsInteger    := LPU_QTE;
    ParamByName('PCOMENT').AsString  := LPU_COMMENT;
    ParamByName('PBLAID').AsInteger  := LPU_BLAID;
    ParamByName('PARTNOM').AsString  := LPU_ARTNOM;
    Open;

    if RecordCount > 0 then
    begin
      Result := FieldByName('LPU_ID').AsInteger;
      Inc(FInsertCount,FieldByName('FAJOUT').AsInteger);
      IsUpdated := IsUpdated or (FieldByName('FAJOUT').AsInteger > 0);
    end;
  except on E: Exception do
    raise Exception.Create('SetRecAutoU -> ' + E.Message);
  end;

end;

end.
