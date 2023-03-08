unit MSS_SuppliersClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type;

type
  TSuppliers = Class(TMainClass)
  private
  public
    procedure Import;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;

    // Permet de récupérer le FOU_ID de l'enregistrement courant
    function GetSuppliers(ASuppliersKey : String) : Integer;
  published
  End;

implementation

{ TSuppliers }

function TSuppliers.DoMajTable (ADoMaj : Boolean): Boolean;
var
  PAY_ID, VIL_ID, ADR_ID, FOU_ID : Integer;
  FOU_CODE : String;
  iAjout, iMaj : Integer;
begin
  // Pour l'initialisation
  inherited DoMajTable(ADoMaj);

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
          ParamByName('CodeFourn').AsString := FCDS.FieldByName('CodeFourn').AsString + '/' + FCds.FieldByName('ERPNo').AsString;
          ParamByName('Denotation').AsString := Fcds.FieldByName('Denotation').AsString;
          ParamByName('Country').AsString    := FCds.FieldByName('Country').AsString;
          ParamByName('City').AsString       := FCds.FieldByName('City').AsString;
          ParamByName('ZipCode').AsString    := FCds.FieldByName('ZipCode').AsString;
          ParamByName('Street').AsString     := FCds.FieldByName('Street').AsString;
          ParamByName('Phone').AsString      := FCds.FieldByName('Phone').AsString;
          ParamByName('Fax').AsString        := FCds.FieldByName('Fax').AsString;
          ParamByName('Email').AsString      := FCds.FieldByName('Email').AsString;
          ParamByName('FOU_ACTIVE').AsInteger   := FCds.FieldByName('Active').AsInteger;
          ParamByName('FOU_ERPNO').AsString := FCds.FieldByName('ErpNo').AsString;
          ParamByName('FOU_ILN').AsString   := FCds.FieldByName('ILN').AsString;
          Open;

          iAjout := 0;
          iMaj := 0;
          if RecordCount > 0 then
          begin
            FOU_ID := FieldByName('FOU_ID').AsInteger;
            iAjout := FieldByName('FAjout').AsInteger;
            iMaj   := FieldByName('FMaj').AsInteger;
          end
          else
            raise Exception.Create('Aucune donnée retournée');

        end;
        if iAjout > 0 then
        Inc(FInsertCount,iAjout);
        Inc(FMajCount,iMaj);

        Fcds.Edit;
        FCds.FieldByName('FOU_ID').AsInteger := FOU_ID;
        FCds.Post;
//      end;
    Except on E:Exception do
      FErrLogs.Add(Fcds.FieldByName('CodeFourn').AsString + ' ' + FCds.FieldByName('Denotation').AsString + ' - ' + E.Message);
    End;

    FCds.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FCds.RecNo * 100 Div FCds.RecordCount;
    Application.ProcessMessages;
  end;

end;

function TSuppliers.GetSuppliers(ASuppliersKey : String): Integer;
var
  FOU_ID : Integer;
begin
  Try
    if FCDS.Locate('CodeFourn',  ASuppliersKey,[loCaseInsensitive]) then
    begin
      FOU_ID := FCDS.FieldByName('FOU_ID').AsInteger;
      if FOU_ID <= 0 then
      begin

        With FStpQuery do
        begin
          Close;
          StoredProcName := 'MSS_SUPPLIERS';
          ParamCheck := True;
          ParamByName('CodeFourn').AsString := FCDS.FieldByName('CodeFourn').AsString + '/' + FCds.FieldByName('ERPNo').AsString;
          ParamByName('Denotation').AsString := Fcds.FieldByName('Denotation').AsString;
          ParamByName('Country').AsString    := FCds.FieldByName('Country').AsString;
          ParamByName('City').AsString       := FCds.FieldByName('City').AsString;
          ParamByName('ZipCode').AsString    := FCds.FieldByName('ZipCode').AsString;
          ParamByName('Street').AsString     := FCds.FieldByName('Street').AsString;
          ParamByName('Phone').AsString      := FCds.FieldByName('Phone').AsString;
          ParamByName('Fax').AsString        := FCds.FieldByName('Fax').AsString;
          ParamByName('Email').AsString      := FCds.FieldByName('Email').AsString;
          ParamByName('FOU_ACTIVE').AsInteger   := FCds.FieldByName('Active').AsInteger;
          ParamByName('FOU_ERPNO').AsString := FCds.FieldByName('ErpNo').AsString;
          ParamByName('FOU_ILN').AsString   := FCds.FieldByName('ILN').AsString;
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
      raise Exception.Create('SuppliersKey inéxistant : ' + ASuppliersKey);

    Result := FOU_ID;
  Except on E:Exception do
    raise Exception.Create('GetSuppliers -> ' + E.Message);
  End;

end;

procedure TSuppliers.Import;
var
  Xml : IXMLDocument;
  nXmlBase,
  eSupplierListNode,
  eSupplierNode,
  eCityNode : IXMLNode;
  CodeFourn, ERPNo, Denotation, Street, CityZipCode, CityDenotation,
  Country,Phone, ILN,
  Fax,Email, Active,FOUID : TFieldCFG;
begin
  // Définition du champs du Dataset
  CodeFourn.FieldName      := 'CodeFourn';
  CodeFourn.FieldType      := ftString;
  ERPNo.FieldName          := 'ERPNo';
  ERPNo.FieldType          := ftString;
  Denotation.FieldName     := 'Denotation';
  Denotation.FieldType     := ftString;
  Street.FieldName         := 'Street';
  Street.FieldType         := ftString;
  CityZipCode.FieldName    := 'ZipCode';
  CityZipCode.FieldType    := ftString;
  CityDenotation.FieldName := 'City';
  CityDenotation.FieldType := ftString;
  Country.FieldName        := 'Country';
  Country.FieldType        := ftString;
  Phone.FieldName          := 'Phone';
  Phone.FieldType          := ftString;
  Fax.FieldName            := 'Fax';
  Fax.FieldType            := ftString;
  Email.FieldName          := 'Email';
  Email.FieldType          := ftString;
  Active.FieldName         := 'Active';
  Active.FieldType         := ftInteger;
  ILN.FieldName            := 'ILN';
  ILN.FieldType            := ftString;
  FOUID.FieldName          := 'FOU_ID';
  FOUID.FieldType          := ftInteger;

  // Création des champs
  FFieldNameID := 'FOU_ID';
  CreateField([CodeFourn,ERPNo,Denotation,Street,CityZipCode,CityDenotation,Country,Phone,Fax,Email,Active,ILN, FOUID]);
  FCds.AddIndex('Idx',CodeFourn.FieldName,[ixPrimary]);
  FCds.IndexName := 'Idx';

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
        FCds.Append;
        FCds.FieldByName('CodeFourn').AsString := XmlStrToStr(eSupplierNode.ChildValues['No']);
        FCds.FieldByName('ERPNo').AsString     := XmlStrToStr(eSupplierNode.ChildValues['ERPNo']);
        FCds.FieldByName('Denotation').AsString := XmlStrToStr(eSupplierNode.ChildValues['Denotation']);
        FCds.FieldByName('Street').AsString     := XmlStrToStr(eSupplierNode.ChildValues['Street']);

        eCityNode := eSupplierNode.ChildNodes['City'];
        FCds.FieldByName('ZipCode').AsString       := XmlStrToStr(eCityNode.ChildValues['Zipcode']);
        FCds.FieldByName('City').AsString       := XmlStrToStr(eCityNode.ChildValues['Denotation']);

        FCds.FieldByName('Country').AsString    := XmlStrToStr(eSupplierNode.ChildValues['Country']);
        FCds.FieldByName('Phone').AsString      := XmlStrToStr(eSupplierNode.ChildValues['Phone']);
        FCds.FieldByName('Fax').AsString        := XmlStrToStr(eSupplierNode.ChildValues['Fax']);
        FCds.FieldByName('Email').AsString      := XmlStrToStr(eSupplierNode.ChildValues['Email']);
        FCds.FieldByName('Active').AsInteger    := XmlStrToInt(eSupplierNode.ChildValues['Active']);
        FCds.FieldByName('ILN').AsString        := XmlStrToStr(eSupplierNode.ChildValues['ILN']);
        FCds.Post;
        eSupplierNode := eSupplierNode.NextSibling;
      end;
    Except on E:Exception do
      raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
    end;
  finally
    Xml := Nil;
  end;
end;


end.
