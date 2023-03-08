unit UXmlUtils;

interface

uses
  Xml.XMLIntf,
  Xml.XMLDoc,
  Data.DB;

function GetNodeFromName(Name : string; Parent : IXMLNode) : IXMLNode;
function GetRootNodeFromName(Name : string; DocXML : IXMLDocument) : IXMLNode;

procedure ExportTObjectToXML(Obj : TObject; FileName : string); overload;
function ExportTobjectToXML(Obj : Tobject; ParentNode : IXmlNode) : IXmlNode; overload;
procedure ExportTDatasetToXML(DataSet : TDataset; FileName : string); overload;
procedure ExportTDatasetToXML(DataSet : TDataset; ParentNode : IXmlNode); overload;

implementation

uses
  System.TypInfo,
  System.SysUtils;

function GetNodeFromName(Name : string; Parent : IXMLNode) : IXMLNode;
var
  i : integer;
begin
  Result := nil;
  for i := 0 to Parent.ChildNodes.Count -1 do
  begin
    if Parent.ChildNodes[i].NodeName = Name then
    begin
      Result := Parent.ChildNodes[i];
      break;
    end;
  end;
end;

function GetRootNodeFromName(Name : string; DocXML : IXMLDocument) : IXMLNode;
begin
  Result := GetNodeFromName(Name, DocXML.DocumentElement);
end;

procedure ExportTObjectToXML(Obj : TObject; FileName : string);
var
  XmlDoc : IXMLDocument;
begin
  XmlDoc := TXMLDocument.Create(nil);
  XmlDoc.Active := true;
  XmlDoc.Options := XmlDoc.Options + [doNodeAutoIndent];
  XMLDoc.DocumentElement := XMLDoc.CreateNode('Root');
  ExportTObjectToXML(Obj, XMLDoc.DocumentElement);
  XmlDoc.SaveToFile(FileName);
end;

function ExportTobjectToXML(Obj : Tobject; ParentNode : IXmlNode) : IXmlNode;
var
  i, nbProps : integer;
  ListProps : TPropList;
  TmpObj : Tobject;
begin
  Result := ParentNode.AddChild('Class');
  Result.Attributes['ClassName'] := Obj.ClassName;
  nbProps := GetPropList(Obj.ClassInfo, tkAny, @ListProps, false);
  for i := 0 to nbProps -1 do
  begin
    if ListProps[i]^.PropType^.Kind = tkClass then
    begin
      tmpObj := GetObjectProp(Obj, string(ListProps[i]^.Name));
      if Assigned(tmpObj) then
        if tmpObj is TDataSet then
        else
          ExportTobjectToXML(TmpObj, Result)
      else
        Result.Attributes[string(ListProps[i]^.Name)] := 'null';
    end
    else
      Result.Attributes[string(ListProps[i]^.Name)] := GetPropValue(Obj, string(ListProps[i]^.Name));
  end;
  if Obj is TDataSet then
    ExportTDatasetToXML(TDataset(Obj), Result);
end;

procedure ExportTDatasetToXML(DataSet : TDataset; FileName : string);
var
  XmlDoc : IXMLDocument;
begin
  XmlDoc := TXMLDocument.Create(nil);
  XmlDoc.Active := true;
  XmlDoc.Options := XmlDoc.Options + [doNodeAutoIndent];
  XMLDoc.DocumentElement := XMLDoc.CreateNode(DataSet.Name);
  ExportTDatasetToXML(DataSet, XMLDoc.DocumentElement);
  XmlDoc.SaveToFile(FileName);
end;

procedure ExportTDatasetToXML(DataSet : TDataset; ParentNode : IXmlNode);
var
  Bmk : TBookmark;
  NodeEnreg, NodeField : IXmlNode;
  i : integer;
begin
  Bmk := DataSet.GetBookmark();
  try
    DataSet.DisableControls();

    DataSet.First();
    while not DataSet.Eof do
    begin
      NodeEnreg := ParentNode.AddChild('Line');
      NodeEnreg.Attributes['Num'] := DataSet.RecNo;
      for i := 0 to DataSet.Fields.Count -1 do
      begin
        NodeField := ExportTobjectToXML(DataSet.Fields[i], NodeEnreg);
        NodeField.NodeValue := DataSet.Fields[i].Value;
      end;
      DataSet.Next();
    end;
  finally
    DataSet.GotoBookmark(Bmk);
    DataSet.FreeBookmark(Bmk);
    DataSet.EnableControls();
  end;
end;


end.
