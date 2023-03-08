unit MSS_BrandsClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type;

type
  TBrands = Class(TMainClass)
  private
    MRK : TMainClass;
  public
    constructor Create;override;
    destructor Destroy;override;
    procedure Import;override;
    function DoMajTable (ADoMaj : Boolean) : Boolean;override;

    // permet de récupérer l'ID de la marque de l'enregistrement courant
    function GetBrands : Integer;
  published
  End;

implementation

{ TBrands }

constructor TBrands.Create;
begin
  inherited;
  MRK := TMainClass.Create;
end;

destructor TBrands.Destroy;
begin
  MRK.Free;
  inherited;
end;

function TBrands.DoMajTable (ADoMaj : Boolean) : Boolean;
var
  MRK_ID : Integer;
begin
  // Pour l'initialisation
  inherited DoMajTable(ADoMaj);

  // récupération des données MRK
  With FIboQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select MRK_ID, MRK_CODE, MRK_ACTIVE from ARTMARQUE');
    SQL.Add('  join K on K_ID = MRK_ID and K_Enabled = 1');
    SQL.Add('Where MRK_CENTRALE = 1');
    Open;

    First;
    MRK.ClientDataSet.EmptyDataSet;
    while not Eof do
    begin
      MRK.ClientDataSet.Append;
      MRK.FieldByName('MRK_ID').AsInteger     := FieldByName('MRK_ID').AsInteger;
      MRK.FieldByName('MRK_CODE').AsString    := FieldByName('MRK_CODE').AsString;
      MRK.FieldByName('MRK_ACTIVE').AsInteger := FieldByName('MRK_ACTIVE').AsInteger;
      MRK.FieldByName('Deleted').AsInteger    := 1;
      MRK.ClientDataSet.Post;
      Next;
    end; // while
  end; // with

  while not FCds.Eof do
  begin
    Try
      MRK_ID := GetBrands;
    Except on E:Exception do
      FErrLogs.Add(E.Message);
    End;

    // Vérification que la relation n'existe pas déjà
    if MRK.ClientDataSet.Locate('MRK_ID',MRK_ID,[loCaseInsensitive]) then
    begin
      MRK.ClientDataSet.Edit;
      MRK.FieldByName('Deleted').AsInteger := 0;
      MRK.ClientDataSet.Post;
    end;


    FCds.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FCds.RecNo * 100 Div FCds.RecordCount;
    Application.ProcessMessages;
  end;

  // Suppression des liaisons obsolètes
  MRK.First;
  while not MRK.EOF do
  begin
    try
      if (MRK.FieldByName('Deleted').AsInteger = 1) AND (MRK.FieldByName('MRK_ACTIVE').AsInteger <> 0) then
      begin
        With FStpQuery do
        begin
          Close;
          StoredProcName := 'MSS_BRANDS_DESACTIVE';
          ParamCheck := True;
          ParamByName('MRK_ID').AsInteger := MRK.FieldByName('MRK_ID').AsInteger;
          ExecSQL;

          Inc(FMajCount,2);
        end;
      end;
    Except on E:Exception do
      FErrLogs.Add(Format('Erreur de suppression MRK_ID %d MRK_CODE %s : %s',[MRK.FieldByName('MRK_ID').AsInteger,MRK.FieldByName('MRK_CODE').AsString, E.Message]));
    end;
    MRK.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := MRK.ClientDataSet.RecNo * 100 Div MRK.ClientDataSet.RecordCount;
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
  CodeMarque, Denotation, Active, HomeMade, MRKID, MRK_ID, MRK_CODE, MRK_ACTIVE, Deleted : TFieldCFG;
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

  // table temporaire pour la gestion des liaisons
  MRK_ID.FieldName      := 'MRK_ID';
  MRK_ID.FieldType      := ftInteger;
  MRK_CODE.FieldName    := 'MRK_CODE';
  MRK_CODE.FieldType    := ftString;
  MRK_ACTIVE.FieldName  := 'MRK_ACTIVE';
  MRK_ACTIVE.FieldType  := ftInteger;
  Deleted.FieldName     := 'Deleted';
  Deleted.FieldType     := ftInteger;

  MRK.FieldNameID := '';
  MRK.KTB_ID := 0;
  MRK.CreateField([MRK_ID, MRK_CODE, MRK_ACTIVE, Deleted]);
  MRK.IboQuery := FIboQuery;
  MRK.StpQuery := FStpQuery;

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
          if Length( XmlStrToStr( eBrandNode.ChildValues[ 'No' ] ) ) <> 3 then
          begin
            FErrLogs.Add(
              Format(
                'Erreur sur la marque: "%s" - "%s"', [
                  XmlStrToStr(eBrandNode.ChildValues['No'] ),
                  XmlStrToStr(eBrandNode.ChildValues['Denotation'] )
                ]
              )
            );
            Application.ProcessMessages;
          end
          else
          begin
            Fcds.Append;
            FCds.FieldByName('CodeMarque').AsString := XmlStrToStr(eBrandNode.ChildValues['No']);
            FCds.FieldByName('Denotation').AsString := XmlStrToStr(eBrandNode.ChildValues['Denotation']);
            Fcds.FieldByName('Active').AsInteger    := XmlStrToInt(eBrandNode.ChildValues['Active']);
            FCds.FieldByName('Homemade').AsInteger  := XmlStrToInt(eBrandNode.ChildValues['Homemade']);

            FCds.Post;
          end;
//        end;
        eBrandNode := eBrandNode.NextSibling;
      end;
    Except on E:Exception do
      raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
    end;
  finally
    Xml := nil;
    TXMLDocument(Xml).Free;
  end;
end;


end.
