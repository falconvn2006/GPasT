unit MSS_BrandsClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type;

type
  TBrands = Class(TMainClass)
  private
  public
    procedure Import;override;
    function DoMajTable (ADoMaj : Boolean) : Boolean;override;

    // permet de récupérer l'ID de la marque de l'enregistrement courant
    function GetBrands : Integer;
  published
  End;

implementation

{ TBrands }

function TBrands.DoMajTable (ADoMaj : Boolean) : Boolean;
begin
  // Pour l'initialisation
  inherited DoMajTable(ADoMaj);

  while not FCds.Eof do
  begin
    Try
      GetBrands;
    Except on E:Exception do
      FErrLogs.Add(E.Message);
    End;

    FCds.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FCds.RecNo * 100 Div FCds.RecordCount;
    Application.ProcessMessages;
  end;
end;

function TBrands.GetBrands: Integer;
var
  MRK_ID, iAjout, iMaj : Integer;
begin
  try
    if FCds.FieldByName('MRK_ID').AsInteger <= 0 then
    begin
      iAjout := 0;
      iMaj := 0;
      With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_BRANDS';
        ParamCheck := True;
        ParamByName('CodeMarque').AsString  := FCds.FieldByName('CodeMarque').AsString;
        ParamByName('Denotation').AsString  := UpperCase(FCds.FieldByName('Denotation').AsString);
        ParamByName('MRK_ACTIVE').AsInteger := FCds.FieldByName('Active').AsInteger;
        ParamByName('MRK_PROPRE').AsInteger := FCds.FieldByName('Homemade').AsInteger;
        Open;
        if RecordCount > 0 then
        begin
          MRK_ID := FieldByName('MRK_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retournée');
      end;

      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);

      // Inscription du MRK_Id en mémoire pour utilisation ultérieure (Création des articles, etc ..)
      FCds.Edit;
      FCds.FieldByName('MRK_ID').AsInteger := MRK_ID;
      FCds.Post;
    end
    else
      MRK_ID := FCds.FieldByName('MRK_ID').AsInteger;

    Result := MRK_ID;
  Except on E:Exception do
    raise Exception.Create('GetBrands -> ' + FCds.FieldByName('CodeMarque').AsString + ' ' + FCds.FieldByName('Denotation').AsString + ' - ' + E.Message);
  End;

end;

procedure TBrands.Import;
var
  Xml : IXMLDocument;
  nXmlBase : IXMLNode;
  eBrandListNode, eBrandNode : IXMLNode;
  CodeMarque, Denotation, Active, HomeMade, MRKID : TFieldCFG;
  i : integer;
begin
  // Définition des champs du dataset
  CodeMarque.FieldName := 'CodeMarque';
  CodeMarque.FieldType := ftString;
  Denotation.FieldName := 'Denotation';
  Denotation.FieldType := ftString;
  Active.FieldName     := 'Active';
  Active.FieldType     := ftInteger;
  HomeMade.FieldName   := 'Homemade';
  HomeMade.FieldType   := ftInteger;
  MRKID.FieldName      := 'MRK_ID';
  MRKID.FieldType      := ftInteger;

  // création des champs
  FFieldNameID := 'MRK_ID';
  CreateField([CodeMarque,Denotation,Active, HomeMade, MRKID]);
  Fcds.IndexDefs.Add('Idx',CodeMarque.FieldName,[ixPrimary]);
  FCds.IndexName := 'Idx';

  // Gestion du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      if not FileExists(FPath + FTitle + '.Xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '.Xml');
      nXmlBase := Xml.DocumentElement;
      eBrandListNode := nXmlBase.ChildNodes.FindNode('Brandlist');
      eBrandNode     := eBrandListNode.ChildNodes['Brand'];
      while eBrandNode <> nil do
      begin
     //   if XmlStrToInt(eBrandNode.ChildValues['Active']) = 1 then
     //   begin
          Fcds.Append;
          FCds.FieldByName('CodeMarque').AsString := XmlStrToStr(eBrandNode.ChildValues['No']);
          FCds.FieldByName('Denotation').AsString := XmlStrToStr(eBrandNode.ChildValues['Denotation']);
          Fcds.FieldByName('Active').AsInteger    := XmlStrToInt(eBrandNode.ChildValues['Active']);
          FCds.FieldByName('Homemade').AsInteger  := XmlStrToInt(eBrandNode.ChildValues['Homemade']);
          FCds.Post;
//        end;
        eBrandNode := eBrandNode.NextSibling;
      end;
    Except on E:Exception do
      raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
    end;
  finally
    Xml := nil;
  end;
end;


end.
