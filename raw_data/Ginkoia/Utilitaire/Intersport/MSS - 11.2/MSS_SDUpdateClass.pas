unit MSS_SDUpdateClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type,
     MSS_SuppliersClass, MSS_BrandsClass;

type
  TSDUpdate = Class(TMainClass)
  private
    FCatalogList ,
    FModelList   ,
    FColorList   ,
    FItemList    ,
    FEanList     : TMainClass;
  public
    procedure Import;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;

    constructor Create;override;
    destructor Destroy;override;

  End;

implementation

{ TSDUpdate }

constructor TSDUpdate.Create;
begin
  inherited Create;
  FCatalogList := TMainClass.Create;
  FCatalogList.Title := 'CatalogList';
  FModelList   := TMainClass.Create;
  FModelList.Title := 'ModelList';
  FColorList   := TMainClass.Create;
  FColorList.Title := 'ColorList';
  FItemList    := TMainClass.Create;
  FItemList.Title := 'ItemList';
  FEanList := TMainClass.Create;
  FEanList.Title := 'EanList';
end;

destructor TSDUpdate.Destroy;
begin
  FCatalogList.Free;
  FModelList.Free;
  FColorList.Free;
  FItemList.Free;
  FEanList.Free;
  inherited;
end;

function TSDUpdate.DoMajTable(ADoMaj: Boolean): Boolean;
var
  FOU_ID : Integer;
  i : Integer;
  Suppliers : TSuppliers;
  Brands : TBrands;
begin

  for i := Low(MasterData) to High(MasterData) do
  begin
    if MasterData[i].MainData.InheritsFrom(TSuppliers) then
      Suppliers := TSuppliers(MasterData[i].MainData);

    if MasterData[i].MainData.InheritsFrom(TBrands) then
      Brands := TBrands(MasterData[i].MainData);

//    if MasterData[i].MainData.InheritsFrom(TUniversCriteria) then
//      Univers := TUniversCriteria(MasterData[i].MainData);
//
//    if MasterData[i].MainData.InheritsFrom(TSizes) then
//      Sizes := TSizes(MasterData[i].MainData);
//
//    if MasterData[i].MainData.InheritsFrom(TPeriods) then
//      Periods := TPeriods(MasterData[i].MainData);
//
//    if MasterData[i].MainData.InheritsFrom(TCollections) then
//      Collections := TCollections(MasterData[i].MainData);
  end;

  FCatalogList.First;
  while not FCatalogList.EOF do
  begin
    Try
      // récupération de l'ID supplier
      FOU_ID := Suppliers.GetSuppliers(FCatalogList.FieldByName('SUPPLIERKEY').AsString);
    Except on E:Exception do
      FErrLogs.Add(FCatalogList.FieldByName('SUPPLIERKEY').AsString + ' ' +
                   FCatalogList.FieldByName('SUPPLIERDENOTATION').AsString + ' - ' + E.Message);
    End;

    if FModelList.ClientDataSet.Locate('SUPPLIERKEY',FCatalogList.FieldByName('SUPPLIERKEY').AsString,[loCaseInsensitive]) Then
    begin
      while (Not FModelList.EOF) and (FCatalogList.FieldByName('SUPPLIERKEY').AsString = FModelList.FieldByName('SUPPLIERKEY').AsString) do
      begin

        if FColorList.ClientDataSet.Locate('SUPPLIERKEY;MODELNUMBER;BRANDNUMBER',
                      VarArrayOf([FCatalogList.FieldByName('SUPPLIERKEY').AsString,
                                  FModelList.FieldByName('MODELNUMBER').AsString,
                                  FModelList.FieldByName('BRANDNUMBER').AsString
                                 ]),[loCaseInsensitive]) then
        begin

        end;

        FModelList.Next;
      end;

    end;


    FCatalogList.Next;
  end;

end;

procedure TSDUpdate.Import;
var
  Xml : IXMLDocument;
  nXmlBase,
  eCatalogListNode,
  eCatalogNode,
  eCatalogAdditionnalNode,
  eModelListNode,
  eModelNode,
  eModelAdditionnalNode,
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
  {IndexKey, CatalogKey,} ModelNumber, BrandNumber, Fedas, SizeRange, RecommendedSalesPrice,
  Add_Pub, Add_Supplier2Key, Add_Supplier2Erp, Add_Supplier2Denotation, ARTID, ARFID
 : TFieldCFG;

  // ColorList
  {IndexKey, CatalogKey , ModelNumber, BrandNumber,} ColorNumber, ColorDenotation, COUID : TFieldCFG;

  // ItemList
  {IndexKey, CatalogKey , ModelNumber, BrandNumber, ColorNumber,} EAN, Columnx, SizeLabel,
  ItemDenotation, Quantity, PurchasePrice, RetailPrice, SMU, TDSC : TFieldCFG;

  // EanList
  {EAN ,} EanList, CBIID : TFieldCFG;

  i, iCount : Integer;
begin
  // CatalogList
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
  Add_SupplierKey.FieldName        := 'ADD_SUPPLIERKEY';
  Add_SupplierKey.FieldType        := ftString;
  Add_SupplierErp.FieldName        := 'ADD_SUPPLIERERP';
  Add_SupplierErp.FieldType        := ftString;
  Add_SupplierDenotation.FieldName := 'ADD_SUPPLIERDENOTATION';
  Add_SupplierDenotation.FieldType := ftString;
  FOUID.FieldName                  := 'FOU_ID';
  FOUID.FieldType                  := ftInteger;

  // ModelList
  {IndexKey, CatalogKey,}
  ModelNumber.FieldName             := 'MODELNUMBER';
  ModelNumber.FieldType             := ftString;
  BrandNumber.FieldName             := 'BRANDNUMBER';
  BrandNumber.FieldType             := ftString;
  Fedas.FieldName                   := 'FEDAS';
  Fedas.FieldType                   := ftString;
  SizeRange.FieldName               := 'SIZERANGE';
  SizeRange.FieldType               := ftString;
  RecommendedSalesPrice.FieldName   := 'RECOMMENDEDSALESPRICE';
  RecommendedSalesPrice.FieldType   := ftCurrency;
  Add_Pub.FieldName                 := 'PUB';
  Add_Pub.FieldType                 := ftString;
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


  // ColorList
  {IndexKey, CatalogKey , ModelNumber, BrandNumber,}
  ColorNumber.FieldName     := 'COLORNUMBER';
  ColorNumber.FieldType     := ftString;
  ColorDenotation.FieldName := 'COLORDENOTATION';
  ColorDenotation.FieldType := ftString;

  // ItemList
  {IndexKey, CatalogKey , ModelNumber, BrandNumber,ColorNumber,}
  EAN.FieldName            := 'EAN';
  EAN.FieldType            := ftString;
  Columnx.FieldName        := 'COLUMNX';
  Columnx.FieldType        := ftInteger;
  SizeLabel.FieldName      := 'SIZELABEL';
  SizeLabel.FieldType      := ftString;
  ItemDenotation.FieldName := 'ITEMDENOTATION';
  ItemDenotation.FieldType := ftString;
  Quantity.FieldName       := 'QTY';
  Quantity.FieldType       := ftInteger;
  PurchasePrice.FieldName  := 'PURCHASEPRICE';
  PurchasePrice.FieldType  := ftCurrency;
  RetailPrice.FieldName    := 'RETAILPRICE';
  RetailPrice.FieldType    := ftCurrency;
  SMU.FieldName            := 'SMU';
  SMU.FieldType            := ftInteger;
  TDSC.FieldName           := 'TDSC';
  TDSC.FieldType           := ftInteger;

  // EanList
  {EAN ,}
  EanList.FieldName := 'EANLIST';
  EanList.FieldType := ftString;


  FCatalogList.CreateField([IndexKey, SupplierKey, SupplierDenotation, CatalogKey, CatalogDenotation,
                             Add_SupplierKey, Add_SupplierErp, Add_SupplierDenotation, FOUID]);
  FCatalogList.IboQuery := FIboQuery;
  FCatalogList.StpQuery := FStpQuery;

  FModelList.CreateField([ IndexKey, CatalogKey, ModelNumber, BrandNumber, Fedas, SizeRange, RecommendedSalesPrice,
                           Add_Pub, Add_Supplier2Key, Add_Supplier2Erp, Add_Supplier2Denotation, ARTID, ARFID]);
  FModelList.IboQuery := FIboQuery;
  FModelList.StpQuery := FStpQuery;


  FColorList.CreateField([IndexKey, CatalogKey , ModelNumber, BrandNumber, ColorNumber, ColorDenotation, COUID]);
  FColorList.IboQuery := FIboQuery;
  FColorList.StpQuery := FStpQuery;

  FItemList.CreateField([IndexKey, CatalogKey , ModelNumber, BrandNumber, ColorNumber, EAN, Columnx, SizeLabel,
                         ItemDenotation, Quantity, PurchasePrice, RetailPrice, SMU, TDSC]);
  FItemList.IboQuery := FIboQuery;
  FItemList.StpQuery := FStpQuery;

  FEanList.CreateField([EAN, EanList, CBIID]);
  FEanList.IboQuery := FIboQuery;
  FEanList.StpQuery := FStpQuery;

  // geston du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      if not FileExists(FPath + FTitle + '.Xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;
      eCatalogListNode := nXmlBase.ChildNodes.FindNode('CATALOGLIST');
      eCatalogNode     := eCatalogListNode.ChildNodes['CATALOG'];

      iCount := 0; // Sert pour générer un index unique car catalogkey et supplierkey peuvent ête vide
      while eCatalogNode <> nil do
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

          eCatalogAdditionnalNode := eCatalogNode.ChildNodes.FindNode('CATALOGADDITIONAL').ChildNodes.FindNode('ADDITIONAL');
          if eCatalogAdditionnalNode <> nil then
          begin
            FieldByName('ADD_SUPPLIERKEY').AsString := XmlStrToStr(eCatalogAdditionnalNode.ChildValues['SUPPLIERKEY']);
            FieldByName('ADD_SUPPLIERERP').AsString := XmlStrToStr(eCatalogAdditionnalNode.ChildValues['SUPPLIERERP']);
            FieldByName('ADD_SUPPLIERDENOTATION').AsString := XmlStrToStr(eCatalogAdditionnalNode.ChildValues['SUPPLIERDENOTATION']);
          end;
          FieldByName('FOU_ID').AsInteger := -1;
          Post;
        end; // with

        eModelListNode := eCatalogNode.ChildNodes.FindNode('MODELLIST');
        eModelNode     := eModelListNode.ChildNodes['MODEL'];

        while eModelNode <> nil do
        begin

          With FModelList.ClientDataSet do
          begin
            Append;
            FieldByName('INDEXKEY').AsInteger   := iCount;
            FieldByName('CATALOGKEY').AsString  := XmlStrToStr(eCatalogNode.ChildValues['CATALOGKEY']);
            FieldByName('MODELNUMBER').AsString := XmlStrToStr(eModelNode.ChildValues['MODELNUMBER']);
            FieldByName('BRANDNUMBER').AsString := XmlStrToStr(eModelNode.ChildValues['BRANDNUMBER']);
            FieldByName('FEDAS').AsString       := XmlStrToStr(eModelNode.ChildValues['FEDAS']);
            FieldByName('SIZERANGE').AsString   := XmlStrToStr(eModelNode.ChildValues['SIZERANGE']);
            FieldByName('RECOMMENDEDSALESPRICE').AsCurrency := XmlStrToFloat(eModelNode.ChildValues['RECOMMENDEDSALESPRICE']);

            eModelAdditionnalNode := eModelNode.ChildNodes.FindNode('MODELADDITIONAL').ChildNodes.FindNode('ADDITIONAL');
            if eModelAdditionnalNode <> nil then
            begin
              FieldByName('PUB').AsString   := XmlStrToStr(eModelAdditionnalNode.ChildValues['PUB']);
              FieldByName('SUPPLIER2KEY').AsString := XmlStrToStr(eModelAdditionnalNode.ChildValues['SUPPLIER2KEY']);
              FieldByName('SUPPLIER2ERP').AsString := XmlStrToStr(eModelAdditionnalNode.ChildValues['SUPPLIER2ERP']);
              FieldByName('SUPPLIER2DENOTATION').AsString := XmlStrToStr(eModelAdditionnalNode.ChildValues['SUPPLIER2DENOTATION']);
            end;
            FieldByName('ART_ID').AsInteger := -1;
            FieldByName('ARF_ID').AsInteger := -1;
            Post;
          end; // with

          eColorListNode := eModelNode.ChildNodes.FindNode('COLORLIST');
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

              eColorAdditionnalNode := eColorNode.ChildNodes.FindNode('COLORADDITIONAL').ChildNodes.FindNode('ADDITIONAL');
              if eColorAdditionnalNode <> nil then
              begin
                // Rien pour l'instant mais mis en place pour des modifications futures
              end;

              Post;
            end; // with

            eItemListNode := eColorNode.ChildNodes.FindNode('ITEMLIST');
            eItemNode     := eItemListNode.ChildNodes['ITEM'];

            while eItemNode <> nil do
            begin

              With FItemList.ClientDataSet do
              begin
                Append;
                FieldByName('INDEXKEY').AsInteger       := iCount;
                FieldbyName('CATALOGKEY').AsString      := XmlStrToStr(eCatalogNode.ChildValues['CATALOGKEY']);
                FieldByName('MODELNUMBER').AsString     := XmlStrToStr(eModelNode.ChildValues['MODELNUMBER']);
                FieldByName('BRANDNUMBER').AsString     := XmlStrToStr(eModelNode.ChildValues['BRANDNUMBER']);
                FieldbyName('COLORNUMBER').AsString     := XmlStrToStr(eColorNode.ChildValues['COLORNUMBER']);
                FieldByName('EAN').AsString             := XmlStrToStr(eItemNode.ChildValues['EAN']);
                FieldByName('COLUMNX').AsInteger        := XmlStrToInt(eItemNode.ChildValues['COLUMNX']);
                FieldByName('SIZELABEL').AsString       := XmlStrToStr(eItemNode.ChildValues['SIZELABEL']);
                FieldByName('ITEMDENOTATION').AsString  := XmlStrToStr(eItemNode.ChildValues['ITEMDENOTATION']);
                FieldByName('QTY').AsInteger            := XmlStrToInt(eItemNode.ChildValues['QTY']);
                FieldByName('PURCHASEPRICE').AsCurrency := XmlStrToFloat(eItemNode.ChildValues['PURCHASEPRICE']);
                FieldByName('RETAILPRICE').AsCurrency   := XmlStrToFloat(eItemNode.ChildValues['RETAILPRICE']);
                FieldByName('SMU').AsInteger            := XmlStrToInt(eItemNode.ChildValues['SMU']);
                FieldByName('TDSC').AsInteger           := XmlStrToInt(eItemNode.ChildValues['TDSC']);

                eItemAdditionnalNode := eItemNode.ChildNodes.FindNode('ITEMADDITIONAL').ChildNodes.FindNode('ADDITIONAL');
                if eItemAdditionnalNode <> nil then
                begin
                  // rien pour le moment mis en place pour des modifications futures
                end;

                Post;
              end; // with

              eItemEanListNode := eItemNode.ChildNodes.FindNode('EANLIST');
              for i := 0 to eItemEanListNode.ChildNodes.Count -1 do
              begin
                With FEanList.ClientDataSet do
                begin
                  Append;
                  FieldByName('EAN').AsString := XmlStrToStr(eItemNode.ChildValues['EAN']);
                  FieldByName('EANLIST').AsString := XmlStrToStr(eItemEanListNode.ChildNodes.Get(i).NodeValue);
                end;
              end; // for

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
  end;

end;

end.
