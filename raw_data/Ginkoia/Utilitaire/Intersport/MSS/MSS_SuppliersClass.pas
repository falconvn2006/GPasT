unit MSS_SuppliersClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type;

type
  TSuppliers = Class(TMainClass)
  private
    FOU : TMainClass;
  public
    constructor Create;override;
    destructor Destroy;override;
    procedure Import;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;

    // Permet de récupérer le FOU_ID de l'enregistrement courant
    function GetSuppliers(ASupplierField, ASuppliersKey : String) : Integer;
  published
  End;

implementation

{ TSuppliers }

constructor TSuppliers.Create;
begin
  inherited;
  FOU := TMainClass.Create;
end;

destructor TSuppliers.Destroy;
begin
  FOU.Free;
  inherited;
end;

function TSuppliers.DoMajTable (ADoMaj : Boolean): Boolean;
var
  PAY_ID, VIL_ID, ADR_ID, FOU_ID, FOD_CPAID : Integer;
  FOU_CODE : String;
  iAjout, iMaj : Integer;
begin
  // Pour l'initialisation
  inherited DoMajTable(ADoMaj);

  // récupération des données FOU
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT FOU_ID, FOU_CODE, FOU_ACTIVE from ARTFOURN');
    SQL.Add(' join K on K_ID = FOU_ID and K_Enabled = 1');
    SQL.Add('Where FOU_CENTRALE = 1');
    SQL.Add('  and FOU_IDREF = 1');
    Open;

    First;
    FOU.ClientDataSet.EmptyDataSet;
    while not Eof do
    begin
      FOU.ClientDataSet.Append;
      FOU.FieldByName('FOU_ID').AsInteger     := FieldByName('FOU_ID').AsInteger;
      FOU.FieldByName('FOU_CODE').AsString    := FieldByName('FOU_CODE').AsString;
      FOU.FieldByName('FOU_ACTIVE').AsInteger := FieldByName('FOU_ACTIVE').AsInteger;
      FOU.FieldByName('Deleted').AsInteger    := 1;
      FOU.ClientDataSet.Post;
      Next;
    end; // while
  end; // with

  {$REGION 'récupération des données FOD_CPAID (45 jours fin de mois)'}
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT CPA_ID from GENCDTPAIEMENT');
    SQL.Add(' join K on K_ID = CPA_ID and K_Enabled = 1');
    SQL.Add('Where CPA_CODE = 16');
    Open;
    First;

    FOD_CPAID := FieldByName('CPA_ID').AsInteger;
  end; // with
  {$ENDREGION}

  while not FCds.Eof do
  begin
    Try
//      if FCds.FieldByName('Active').AsInteger = 1 then
//      begin
      With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_SUPPLIERS';
        ParamCheck := True;
        ParamByName('CodeFourn').AsString   := FCDS.FieldByName('CodeFourn').AsString;
        ParamByName('Denotation').AsString  := Fcds.FieldByName('Denotation').AsString;
        ParamByName('Country').AsString     := FCds.FieldByName('Country').AsString;
        ParamByName('City').AsString        := FCds.FieldByName('City').AsString;
        ParamByName('ZipCode').AsString     := FCds.FieldByName('ZipCode').AsString;
        ParamByName('Street').AsString      := FCds.FieldByName('Street').AsString;
        ParamByName('Phone').AsString       := FCds.FieldByName('Phone').AsString;
        ParamByName('Fax').AsString         := FCds.FieldByName('Fax').AsString;
        ParamByName('Email').AsString       := FCds.FieldByName('Email').AsString;
//JB
        ParamByName('FOU_RAPPAUTO').AsInteger := FCds.FieldByName('FOU_RAPPAUTO').AsInteger;
//
        ParamByName('FOU_ACTIVE').AsInteger := FCds.FieldByName('Active').AsInteger;
        ParamByName('FOU_ERPNO').AsString   := FCds.FieldByName('ErpNo').AsString;
        ParamByName('FOU_ILN').AsString     := FCds.FieldByName('ILN').AsString;
        ParamByName('FOD_CPAID').AsInteger  := FOD_CPAID;
        Open;

        iAjout := 0;
        iMaj := 0;
        if RecordCount > 0 then
        begin
          FOU_ID := FieldByName('FOU_ID').AsInteger;
          iAjout := FieldByName('FAjout').AsInteger;
          iMaj   := FieldByName('FMaj').AsInteger;

//          if iMaj > 0 then
//            FErrLogs.Add(Fcds.FieldByName('CodeFourn').AsString + ' ' + FCds.FieldByName('Denotation').AsString);
        end
        else
          raise Exception.Create('Aucune donnée retournée');

        if iAjout > 0 then
        Inc(FInsertCount,iAjout);
        Inc(FMajCount,iMaj);

        Fcds.Edit;
        FCds.FieldByName('FOU_ID').AsInteger := FOU_ID;
        FCds.Post;
//      end;
      end;
    Except on E:Exception do
      FErrLogs.Add(Fcds.FieldByName('CodeFourn').AsString + ' ' + FCds.FieldByName('Denotation').AsString + ' - ' + E.Message);
    End;

    // Vérification que la relation n'existe pas déjà
    if FOU.ClientDataSet.Locate('FOU_ID',FCds.FieldByName('FOU_ID').AsString,[loCaseInsensitive]) then
    begin
      FOU.ClientDataSet.Edit;
      FOU.FieldByName('Deleted').AsInteger := 0;
      FOU.ClientDataSet.Post;
    end;

    FCds.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FCds.RecNo * 100 Div FCds.RecordCount;
    Application.ProcessMessages;
  end;

  // Suppression des liaisons obsolètes
  FOU.First;
  while not FOU.EOF do
  begin
    try
      if (FOU.FieldByName('Deleted').AsInteger = 1) AND (FOU.FieldByName('FOU_ACTIVE').AsInteger <> 0) then
      begin
        With FStpQuery do
        begin
          Close;
          StoredProcName := 'MSS_SUPPLIERS_DESACTIVE';
          ParamCheck := True;
          ParamByName('FOU_ID').AsInteger := FOU.FieldByName('FOU_ID').AsInteger;
          ExecSQL;
        end;
      end;
    Except on E:Exception do
      FErrLogs.Add(Format('Erreur de suppression FOU_ID %d FOU_CODE %s : %s',[FOU.FieldByName('FOU_ID').AsInteger,FOU.FieldByName('FOU_CODE').AsString, E.Message]));
    end;
    FOU.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FOU.ClientDataSet.RecNo * 100 Div FOU.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;
end;

function TSuppliers.GetSuppliers(ASupplierField, ASuppliersKey : String): Integer;
var
  FOU_ID : Integer;
begin
  Try
    if FCDS.Locate(ASupplierField,  ASuppliersKey,[loCaseInsensitive]) then
    begin
      FOU_ID := FCDS.FieldByName('FOU_ID').AsInteger;
      if FOU_ID <= 0 then
      begin

        With FStpQuery do
        begin
          Close;
          StoredProcName := 'MSS_SUPPLIERS';
          ParamCheck := True;
          ParamByName('CodeFourn').AsString   := FCDS.FieldByName('CodeFourn').AsString;
          ParamByName('Denotation').AsString  := Fcds.FieldByName('Denotation').AsString;
          ParamByName('Country').AsString     := FCds.FieldByName('Country').AsString;
          ParamByName('City').AsString        := FCds.FieldByName('City').AsString;
          ParamByName('ZipCode').AsString     := FCds.FieldByName('ZipCode').AsString;
          ParamByName('Street').AsString      := FCds.FieldByName('Street').AsString;
          ParamByName('Phone').AsString       := FCds.FieldByName('Phone').AsString;
          ParamByName('Fax').AsString         := FCds.FieldByName('Fax').AsString;
          ParamByName('Email').AsString       := FCds.FieldByName('Email').AsString;
//JB
          ParamByName('FOU_RAPPAUTO').AsInteger := FCds.FieldByName('FOU_RAPPAUTO').AsInteger;
//
          ParamByName('FOU_ACTIVE').AsInteger := FCds.FieldByName('Active').AsInteger;
          ParamByName('FOU_ERPNO').AsString   := FCds.FieldByName('ErpNo').AsString;
          ParamByName('FOU_ILN').AsString     := FCds.FieldByName('ILN').AsString;
          Open;

          if RecordCount > 0 then
          begin
            FOU_ID := FieldByName('FOU_ID').AsInteger;
          end
          else
            raise Exception.Create('Aucune donnée retournée');
        end;

        Fcds.Edit;
        FCds.FieldByName('FOU_ID').AsInteger := FOU_ID;
        FCds.Post;
      end;
    end
    else
      raise ENOTFIND.Create('SuppliersKey inéxistant : ' + ASuppliersKey);

    Result := FOU_ID;
  Except
    on E:ENOTFIND do
      raise ENOTFIND.Create(E.Message);
    on E:Exception do
    raise Exception.Create('GetSuppliers -> ' + E.Message);
  End;

end;

procedure TSuppliers.Import;
var
  AString : String;
  ABoolean : Boolean;
  Xml : IXMLDocument;
  nXmlBase,
  eSupplierListNode,
  eSupplierNode,
  eCityNode : IXMLNode;
  CodeFourn, ERPNo, Denotation, Street, CityZipCode, CityDenotation,
  Country,Phone, ILN,
  Fax,Email, FOU_RAPPAUTO, Active,FOUID, FOU_ID, FOU_CODE, FOU_ACTIVE, Deleted : TFieldCFG;
begin
  // Définition du champs du Dataset
  CodeFourn.FieldName       := 'CodeFourn';
  CodeFourn.FieldType       := ftString;
  ERPNo.FieldName           := 'ERPNo';
  ERPNo.FieldType           := ftString;
  Denotation.FieldName      := 'Denotation';
  Denotation.FieldType      := ftString;
  Street.FieldName          := 'Street';
  Street.FieldType          := ftString;
  CityZipCode.FieldName     := 'ZipCode';
  CityZipCode.FieldType     := ftString;
  CityDenotation.FieldName  := 'City';
  CityDenotation.FieldType  := ftString;
  Country.FieldName         := 'Country';
  Country.FieldType         := ftString;
  Phone.FieldName           := 'Phone';
  Phone.FieldType           := ftString;
  Fax.FieldName             := 'Fax';
  Fax.FieldType             := ftString;
  Email.FieldName           := 'Email';
  Email.FieldType           := ftString;
//JB
  FOU_RAPPAUTO.FieldName   := 'FOU_RAPPAUTO';
  FOU_RAPPAUTO.FieldType   := ftInteger;
//
  Active.FieldName          := 'Active';
  Active.FieldType          := ftInteger;
  ILN.FieldName             := 'ILN';
  ILN.FieldType             := ftString;
  FOUID.FieldName           := 'FOU_ID';
  FOUID.FieldType           := ftInteger;

  // Création des champs
  FFieldNameID := 'FOU_ID';
//JB
  CreateField([CodeFourn,ERPNo,Denotation,Street,CityZipCode,CityDenotation,Country,Phone,Fax,Email,FOU_RAPPAUTO,Active,ILN,FOUID]);
//
  FCds.AddIndex('IdxCODE',CodeFourn.FieldName,[ixPrimary]);
  FCds.AddIndex('IdxERP',ERPNo.FieldName,[ixPrimary]);
  FCds.IndexName := 'IdxCODE';

  // table temporaire pour la gestion des liaisons
  FOU_ID.FieldName      := 'FOU_ID';
  FOU_ID.FieldType      := ftInteger;
  FOU_CODE.FieldName    := 'FOU_CODE';
  FOU_CODE.FieldType    := ftString;
  FOU_ACTIVE.FieldName  := 'FOU_ACTIVE';
  FOU_ACTIVE.FieldType  := ftInteger;
  Deleted.FieldName     := 'Deleted';
  Deleted.FieldType     := ftInteger;

  FOU.FieldNameID := '';
  FOU.KTB_ID := 0;
  FOU.CreateField([FOU_ID, FOU_CODE, FOU_ACTIVE, Deleted]);
  FOU.IboQuery := FIboQuery;
  FOU.StpQuery := FStpQuery;

  // geston du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      if not FileExists(FPath + FTitle + '.Xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;
      eSupplierListNode := nXmlBase.ChildNodes.FindNode('Supplierlist');
      eSupplierNode     := eSupplierListNode.ChildNodes['Supplier'];

      while eSupplierNode <> nil do
      begin
//JB
        ABoolean := True;
        // valeur = 9 pour indiquer que le champ FOU_RAPPAUTO ne doit pas être modifié au moment du update
        // mais en insert le champ FOU_RAPPAUTO sera initialisé à 0
        if eSupplierNode.ChildNodes.FindNode('Rapprochement') = Nil
        then AString := '9'
        else
        begin
          AString := XmlStrToStr(eSupplierNode.ChildValues['Rapprochement']);
          if (AString <> '0') and (AString <> '1') then
          begin
            FErrLogs.Add('Erreur : Valeur de Rapprochement erronée (' +  AString + ') pour le code fournisseur = '
              + XmlStrToStr(eSupplierNode.ChildValues['No']));
            ABoolean := False;
          end;
        end;
        if ABoolean = True then
        begin
//
          FCds.Append;
          FCds.FieldByName('CodeFourn').AsString     := XmlStrToStr(eSupplierNode.ChildValues['No']);
          FCds.FieldByName('ERPNo').AsString         := XmlStrToStr(eSupplierNode.ChildValues['ERPNo']);
          FCds.FieldByName('Denotation').AsString    := XmlStrToStr(eSupplierNode.ChildValues['Denotation']);
          FCds.FieldByName('Street').AsString        := XmlStrToStr(eSupplierNode.ChildValues['Street']);

          eCityNode := eSupplierNode.ChildNodes['City'];
          FCds.FieldByName('ZipCode').AsString       := XmlStrToStr(eCityNode.ChildValues['Zipcode']);
          FCds.FieldByName('City').AsString          := XmlStrToStr(eCityNode.ChildValues['Denotation']);

          FCds.FieldByName('Country').AsString       := XmlStrToStr(eSupplierNode.ChildValues['Country']);
          FCds.FieldByName('Phone').AsString         := XmlStrToStr(eSupplierNode.ChildValues['Phone']);
          FCds.FieldByName('Fax').AsString           := XmlStrToStr(eSupplierNode.ChildValues['Fax']);
          FCds.FieldByName('Email').AsString         := XmlStrToStr(eSupplierNode.ChildValues['Email']);
//JB
          FCds.FieldByName('FOU_RAPPAUTO').AsInteger := StrToInt(AString);
//
          FCds.FieldByName('Active').AsInteger       := XmlStrToInt(eSupplierNode.ChildValues['Active']);
          FCds.FieldByName('ILN').AsString           := XmlStrToStr(eSupplierNode.ChildValues['ILN']);

          FCds.Post;
        end;
        eSupplierNode := eSupplierNode.NextSibling;
      end;
    Except on E:Exception do
      raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
    end;
  finally
    Xml := Nil;
    TXMLDocument(Xml).Free;
  end;
end;


end.
