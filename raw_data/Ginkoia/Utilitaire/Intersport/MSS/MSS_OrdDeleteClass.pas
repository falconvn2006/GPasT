unit MSS_OrdDeleteClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type;


type
  TOrdDeleteClass = Class(TMainClass)
  public
    procedure Import;override;
    function DoMajTable (ADoMaj : Boolean) : Boolean;override;
End;

implementation

{ TOrdDeleteClass }

function TOrdDeleteClass.DoMajTable(ADoMaj: Boolean): Boolean;
begin
  Result := True;

  First;
  while not Eof do
  begin
    try
      With FIboQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select CDE_NUMERO From MSS_DELCOMBCDE(:ORDERNUMBER)');
        ParamCheck := True;
        ParamByName('ORDERNUMBER').AsString := FCds.FieldByName('OrderNumber').AsString;
        Open;

        if FieldByName('CDE_NUMERO').AsString <> '' then
          FActionLogs.Add('Commande : ' + FCds.FieldByName('OrderNumber').AsString + ' - Chrono : ' + FieldByName('CDE_NUMERO').AsString + ' supprimée')
        else
          // Le "!" permet de monitorer le message en tant qu'avertissement...
          FActionLogs.Add('!Commande : ' + FCds.FieldByName('OrderNumber').AsString + ' non trouvée');
      end;

//      with FStpQuery do
//      begin
//        Close;
//        StoredProcName := 'MSS_DELCOMBCDE';
//        ParamCheck := True;
//        ParamByName('IMPNUM').AsInteger := CIMPNUM;
//        ParamByName('IMPKTBID').AsInteger := CKTBID_COMBCDE;
//        ParamByName('ORDERNUMBER').AsString := FCds.FieldByName('OrderNumber').AsString;
//        Open;
//
//        if FieldByName('CDE_NUMERO').AsString <> '' then
//          FActionLogs.Add('Commande : ' + FCds.FieldByName('OrderNumber').AsString + ' - Chrono : ' + FieldByName('CDE_NUMERO').AsString + ' supprimée')
//        else
//          FActionLogs.Add('Commande : ' + FCds.FieldByName('OrderNumber').AsString + ' non trouvé');
//      end;
    Except on E:Exception do
      FErrLogs.Add('OrderDelete error -> ' + E.Message);
    end;
    Next;
  end;
end;

procedure TOrdDeleteClass.Import;
var
  Xml : IXMLDocument;
  nXmlBase : IXMLNode;
  eOrderListNode, eOrderNode : IXMLNode;
  OrderNumber : TFieldCFG;
  i : integer;
begin
  // Définition des champs du dataset
  OrderNumber.FieldName := 'OrderNumber';
  OrderNumber.FieldType := ftString;

  CreateField(OrderNumber);

    // Gestion du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      if not FileExists(FPath + FTitle + '_ORDDELETE.Xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '_ORDDELETE.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '_ORDDELETE.Xml');
      nXmlBase := Xml.DocumentElement;
      eOrderListNode := nXmlBase.ChildNodes.FindNode('ORDERLIST');
      eOrderNode := eOrderListNode.ChildNodes['ORDERNUMBER'];
      While eOrderNode <> nil do
      begin
        With FCds do
        begin
          Append;
          FieldByName('OrderNumber').AsString := XmlStrToStr(eOrderNode.NodeValue);
          Post;
        end;
        eOrderNode := eOrderNode.NextSibling;
      end;
    Except on E:Exception do
      raise Exception.Create('Import Delete ' + FTitle + ' -> ' + E.Message);
    end;
  finally
    Xml := nil;
    TXMLDocument(Xml).Free;
  end;


end;

end.
