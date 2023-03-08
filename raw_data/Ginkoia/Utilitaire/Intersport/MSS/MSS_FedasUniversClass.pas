unit MSS_FedasUniversClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type;


type
  TFedasUnivers = Class(TMainClass)
  Public
    procedure Import;override;
    constructor Create;override;
    Destructor Destroy;override;
    function ClearIdField : Boolean;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;
  published
  end;

implementation

{ TFedasUnivers }

function TFedasUnivers.ClearIdField: Boolean;
begin
  Result := True;
end;

constructor TFedasUnivers.Create;
begin
  inherited Create;

end;

destructor TFedasUnivers.Destroy;
begin

  inherited;
end;

function TFedasUnivers.DoMajTable(ADoMaj: Boolean): Boolean;
begin
  FCDs.First;
  While not FCDs.Eof do
  begin
    Try
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from MSS_SETFEDASUNIVERS(:PFEDAS, :PUNIV)');
      ParamCheck := True;
      ParamByName('PFEDAS').AsString := Fcds.FieldByName('FedasCode').AsString;
      ParamByName('PUNIV').AsString := Fcds.FieldByName('UniversCode').AsString;
      Open;

      if RecordCount > 0 then
      begin
        First;
        while not EOF do
        begin
          if Trim(FieldbyName('Error').AsString) <> '' then
            FErrLogs.Add(FieldbyName('Error').AsString);
          Next;
        end;
        Last;
        Inc(FMajCount,FieldByName('FMAJ').AsInteger);
      end;
    end;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FCDS.RecNo * 100 Div FCDS.RecordCount;
    Application.ProcessMessages;
    Except on E:Exception do
      begin
        FErrLogs.Add(Format('%s - %s : %s' ,[Fcds.FieldByName('FedasCode').AsString,Fcds.FieldByName('UniversCode').AsString, E.Message]));
      end;
    End;

    FCds.Next;
  end;

end;

procedure TFedasUnivers.Import;
var

  Xml : IXMLDocument;
  nXmlBase,
  eFUListNode,
  eLienNode : IXMLNode;

  FedasCode, Universcode : TFieldCFG;
begin
  FedasCode.FieldName   := 'Fedascode';
  FedasCode.FieldType   := ftString;
  Universcode.FieldName := 'Universcode';
  Universcode.FieldType := ftString;

  CreateField([FedasCode,Universcode]);

    // geston du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      if not FileExists(FPath + FTitle + '.Xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;

      eFUListNode := nXmlBase.ChildNodes.FindNode('fedasuniverslist');
      eLienNode := eFUListNode.ChildNodes['Lien'];

      while eLienNode <> nil do
      begin
        Fcds.Append;
        Fcds.FieldByName('Fedascode').AsString := XmlStrToStr(eLienNode.ChildValues['Fedascode']);
        Fcds.FieldByName('Universcode').AsString := XmlStrToStr(eLienNode.ChildValues['Universcode']);
        Fcds.Post;

        eLienNode := eLienNode.NextSibling;
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
