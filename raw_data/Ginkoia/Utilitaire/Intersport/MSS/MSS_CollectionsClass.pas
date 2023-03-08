unit MSS_CollectionsClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type, Types,
     MSS_PeriodsClass;

type
  TCollections = Class(TMainClass)
  private
    FPeriods : TPeriods;
  public
    procedure Import;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;
    // retourne l'ID de l'enregistrement en cours
    function GetCollectionID : Integer;
    function GetCollection(ADate : TDateTime) : Integer;

    Constructor Create;override;
  published
  End;

implementation

{ TCollections }

constructor TCollections.Create;
var
  i : Integer;
begin
  inherited Create;
end;

function TCollections.DoMajTable (ADoMaj : Boolean): Boolean;
var
  COL_ID, EXE_ID, COL_EXEID, IsActive : Integer;
  i : integer;
  DateFrom, DateTo : TDateTime;
begin
  // Pour l'initialisation
  inherited DoMajTable(ADoMaj);
  Result := False;

//  for i := Low(MasterData) to High(MasterData) do
//    if MasterData[i].MainData.PRM_CODE = CPRMCODE_PERIODS then
//      FPeriods := TPeriods(MasterData[i].MainData);

  While not FCds.Eof do
  begin
    try
//      // Vérification que la collection n'existe pas encore
//      EXE_ID := 0;
//      if ((FCds.FieldByName('CodePeriod').AsString <> '') and (not FCds.FieldByName('CodePeriod').IsNull)) then
//        EXE_ID := FPeriods.GetPeriods(FCds.FieldByName('CodePeriod').AsString,FCds.FieldByName('YearPeriod').AsInteger);
//
//      With FIboQuery do
//      begin
//        Close;
//        SQL.Clear;
//        SQL.Add('Select COL_ID, COL_NOM, COL_ACTIVE, COL_DTDEB, COL_DTFIN, COL_EXEID from ARTCOLLECTION');
//        SQL.Add('  join K on K_Id = COL_ID and K_enabled = 1');
//        SQL.Add('Where Upper(COL_CODE) = Upper(:PCOLCODE)');
//     //   SQL.Add('  and COL_EXEID = :PEXEID');
//        ParamCheck := true;
//        ParamByName('PCOLCODE').AsString := FCds.FieldByName('Code').AsString;
//      //  ParamByName('PEXEID').AsInteger  := EXE_ID;
//        Open;
//
//        COL_ID := -1;
//        if RecordCount > 0 then
//        begin
//          COL_ID   := FieldByName('COL_ID').AsInteger;
//          IsActive := FieldByName('COL_ACTIVE').AsInteger;
//          DateFrom := FieldByName('COL_DTDEB').AsDateTime;
//          DateTo   := FieldByName('COL_DTFIN').AsDateTime;
//          COL_EXEID := FieldByName('COL_EXEID').AsInteger;
//        end;
//      end;
//
//      if ADoMaj and (COL_ID  = -1) then
//      begin
//         // Si non alors on vérifie qu'elle n'existe pas encore dans la table
//         With FIboQuery do
//         begin
//           COL_ID := GetNewKID('ARTCOLLECTION');
//           Close;
//           SQL.Clear;
//           SQL.Add('Insert Into ARTCOLLECTION(COL_ID, COL_NOM, COL_NOVISIBLE, COL_CODE, COL_ACTIVE, COL_DTDEB, COL_DTFIN, COL_EXEID, COL_CENTRALE)');
//           SQL.Add('Values(:PCOLID,:PCOLNOM,:PCOLNOVISIBLE, :PCOLCODE, :PCOLACTIVE, :PCOLDTDEB, :PCOLDTFIN, :PCOLEXEID, 1)');
//           ParamCheck := True;
//           ParamByName('PCOLID').AsInteger := COL_ID;
//           ParamByName('PCOLNOM').AsString := UpperCase(FCds.FieldByName('Denotation').AsString);
//           ParamByName('PCOLNOVISIBLE').AsInteger := 0;
//           ParamByName('PCOLCODE').AsString := FCds.FieldByName('Code').AsString;
//           ParamByName('PCOLACTIVE').AsInteger := FCds.FieldByName('Active').AsInteger;
//           ParamByName('PCOLDTDEB').AsDateTime := FCds.FieldByName('datefrom').AsDateTime;
//           ParamByName('PCOLDTFIN').AsDateTime := FCds.FieldByName('DateTo').AsDateTime;
//           ParamByName('PCOLEXEID').AsInteger  := EXE_ID;
//           ExecSQL;
//
//           Inc(FInsertCount);
//         end;
//      end
//      else begin
//        // Est ce que la collection doit être mise à jour
//        if ADoMaj then
//          With FIboQuery do
//          begin
//
//            if (IsActive <> FCds.FieldByName('Active').AsInteger) or
//               (CompareText(FieldByName('COL_NOM').AsString,FCds.FieldByName('Denotation').AsString) <> 0) OR
//               (CompareDate(DateFrom, FCds.FieldByName('Datefrom').AsDateTime) <> EqualsValue) OR
//               (CompareDate(DateTo, FCds.FieldByName('DateTo').AsDateTime) <> EqualsValue) OR
//               (EXE_ID <> COL_EXEID)
//            then
//            begin
//              Close;
//              SQL.Clear;
//              SQL.Add('Update ARTCOLLECTION set');
//              SQL.Add(' COL_NOM = :PCOLNOM,');
//              SQL.Add(' COL_ACTIVE = :PCOLACTIVE,');
//              SQL.Add(' COL_DTDEB  = :PCOLDTDEB,');
//              SQL.Add(' COL_DTFIN  = :PCOLDTFIN,');
//              SQL.Add(' COL_EXEID = :PEXEID');
//              SQL.Add('Where COL_ID = :PCOLID');
//              ParamCheck := True;
//              ParamByName('PCOLNOM').AsString := UpperCase(FCds.FieldByName('Denotation').AsString);
//              ParamByName('PCOLACTIVE').AsInteger := FCds.FieldByName('Active').AsInteger;
//              ParamByName('PCOLDTDEB').AsDateTime := FCds.FieldByName('datefrom').AsDateTime;
//              ParamByName('PCOLDTFIN').AsDateTime := FCds.FieldByName('DateTo').AsDateTime;
//              ParamByName('PCOLID').AsInteger := COL_ID;
//              ParamByName('PEXEID').AsInteger := EXE_ID;
//              ExecSQL;
//
//              UpdateKId(COL_ID);
//
//              Inc(FMajcount);
//            end;
//          end; // with
//      end;
//
//      // Mise en mémoire du COL_ID pour utilisation ultérieure
//      FCDs.Edit;
//      FCds.FieldByName('COL_ID').AsInteger := COL_ID;
//      FCds.Post;
      GetCollectionID;
    Except on E:Exception do
      FErrLogs.Add(Fcds.FieldByName('Code').AsString + ' ' + FCds.FieldByName('Denotation').AsString + ' - ' + E.Message);
    End;

    Fcds.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FCds.RecNo * 100 Div FCds.RecordCount;
    Application.ProcessMessages;
  end;
  Result := True;
end;

function TCollections.GetCollection(ADate: TDateTime): Integer;
var
  bFound : Boolean;
begin
  try
    Result := -1;
    // recherche de la date de la période
    FCds.First;
    bFound := False;
    while not FCds.Eof and not bFound do
    begin
      if ((CompareDate(ADate,FCDs.FieldByName('Datefrom').AsDateTime) = GreaterThanValue) and
         (CompareDate(ADate,FCds.FieldByName('DateTo').AsDateTime) = LessThanValue) or
         (CompareDate(ADate,FCds.FieldByName('DateTo').AsDateTime) = EqualsValue) or
         (CompareDate(ADate,FCDs.FieldByName('Datefrom').AsDateTime) = EqualsValue)) and
         (YearsBetween(FCDs.FieldByName('Datefrom').AsDateTime, FCds.FieldByName('DateTo').AsDateTime) <= 1) then
         bFound := True
      else
        FCds.Next;
    end; // while

    if bFound then
    begin
      if FCds.FieldByName('COL_ID').AsInteger <= 0 then
        Result := GetCollectionID
      else
        Result := FCds.FieldByName('COL_ID').AsInteger;
    end;

  if Result = -1 then
    raise Exception.Create('GetCollection -> Collection inéxistant : ' + DateTimeToStr(ADate));

  Except on E:Exception do
    raise Exception.Create('GetCollection -> ' + E.Message);
  end;
end;

function TCollections.GetCollectionID: Integer;
var
  COL_ID, EXE_ID, COL_EXEID, IsActive : Integer;
  i : integer;
  DateFrom, DateTo : TDateTime;
begin
  // Initialitation
  if not Assigned(FPeriods) then
    for i := Low(MasterData) to High(MasterData) do
      if MasterData[i].MainData.PRM_CODE = CPRMCODE_PERIODS then
        FPeriods := TPeriods(MasterData[i].MainData);

  Result := FCds.FieldByName('COL_ID').AsInteger;
  if Result <= 0 then
  begin
    EXE_ID := 0;
    if ((FCds.FieldByName('CodePeriod').AsString <> '') and (not FCds.FieldByName('CodePeriod').IsNull)) then
      EXE_ID := FPeriods.GetPeriods(FCds.FieldByName('CodePeriod').AsString,FCds.FieldByName('YearPeriod').AsInteger);

    With FIboQuery do
    begin

      Close;
      SQL.Clear;
      SQL.Add('Select * from ARTCOLLECTION');
      SQL.Add('  join K on K_Id = COL_ID and K_Enabled = 1');
      SQL.Add('Where COL_CODE = :PCOLCODE');
      ParamCheck := True;
      ParamByName('PCOLCODE').AsString := UpperCase(FCds.FieldByName('Code').AsString);
      Open;

      if Recordcount <= 0 then
      begin
        // N'existe pas donc on va la créer
        Result := GetNewKID('ARTCOLLECTION');
        Close;
        SQL.Clear;
        SQL.Add('Insert Into ARTCOLLECTION(COL_ID, COL_NOM, COL_NOVISIBLE, COL_CODE, COL_ACTIVE, COL_DTDEB, COL_DTFIN, COL_EXEID, COL_CENTRALE)');
        SQL.Add('Values(:PCOLID,:PCOLNOM,:PCOLNOVISIBLE, :PCOLCODE, :PCOLACTIVE, :PCOLDTDEB, :PCOLDTFIN, :PCOLEXEID, 1)');
        ParamCheck := True;
        ParamByName('PCOLID').AsInteger := Result;
        ParamByName('PCOLNOM').AsString := UpperCase(FCds.FieldByName('Denotation').AsString);
        ParamByName('PCOLNOVISIBLE').AsInteger := 0;
        ParamByName('PCOLCODE').AsString := FCds.FieldByName('Code').AsString;
        ParamByName('PCOLACTIVE').AsInteger := FCds.FieldByName('Active').AsInteger;
        ParamByName('PCOLDTDEB').AsDateTime := FCds.FieldByName('datefrom').AsDateTime;
        ParamByName('PCOLDTFIN').AsDateTime := FCds.FieldByName('DateTo').AsDateTime;
        ParamByName('PCOLEXEID').AsInteger  := EXE_ID;
        ExecSQL;

        Inc(FInsertCount);

      end else
      begin
        COL_ID   := FieldByName('COL_ID').AsInteger;
        IsActive := FieldByName('COL_ACTIVE').AsInteger;
        DateFrom := FieldByName('COL_DTDEB').AsDateTime;
        DateTo   := FieldByName('COL_DTFIN').AsDateTime;
        COL_EXEID := FieldByName('COL_EXEID').AsInteger;

        // Mise à jour à faire ?
        if (IsActive <> FCds.FieldByName('Active').AsInteger) or
           (CompareText(FieldByName('COL_NOM').AsString,FCds.FieldByName('Denotation').AsString) <> 0) OR
           (CompareDate(DateFrom, FCds.FieldByName('Datefrom').AsDateTime) <> EqualsValue) OR
           (CompareDate(DateTo, FCds.FieldByName('DateTo').AsDateTime) <> EqualsValue) OR
           (EXE_ID <> COL_EXEID)
        then
        begin
          Close;
          SQL.Clear;
          SQL.Add('Update ARTCOLLECTION set');
          SQL.Add(' COL_NOM = :PCOLNOM,');
          SQL.Add(' COL_ACTIVE = :PCOLACTIVE,');
          SQL.Add(' COL_DTDEB  = :PCOLDTDEB,');
          SQL.Add(' COL_DTFIN  = :PCOLDTFIN,');
          SQL.Add(' COL_EXEID = :PEXEID');
          SQL.Add('Where COL_ID = :PCOLID');
          ParamCheck := True;
          ParamByName('PCOLNOM').AsString := UpperCase(FCds.FieldByName('Denotation').AsString);
          ParamByName('PCOLACTIVE').AsInteger := FCds.FieldByName('Active').AsInteger;
          ParamByName('PCOLDTDEB').AsDateTime := FCds.FieldByName('datefrom').AsDateTime;
          ParamByName('PCOLDTFIN').AsDateTime := FCds.FieldByName('DateTo').AsDateTime;
          ParamByName('PCOLID').AsInteger := COL_ID;
          ParamByName('PEXEID').AsInteger := EXE_ID;
          ExecSQL;

          UpdateKId(COL_ID);

          Inc(FMajcount);
        end;

        Result := COL_ID;
      end; // with
    end;

    // Mise en mémoire du COL_ID pour utilisation ultérieure
    FCDs.Edit;
    FCds.FieldByName('COL_ID').AsInteger := Result;
    FCds.Post;
  end; // if
end;

procedure TCollections.Import;
var
  Xml : IXMLDocument;
  nXmlBase,
  eCollectionListNode,
  eCollectionNode : IXMLNode;

  Code, Denotation, DateFrom, DateTo, COLID, CodePeriod, YearPeriod, Active : TFieldCFG;
begin
  // Définition du champs du Dataset
  Code.FieldName := 'Code';
  Code.FieldType := ftString;
  Denotation.FieldName := 'Denotation';
  Denotation.FieldType := ftString;
  Datefrom.FieldName   := 'Datefrom';
  Datefrom.FieldType   := ftDate;
  Dateto.FieldName     := 'Dateto';
  Dateto.FieldType     := ftDate;
  CodePeriod.FieldName := 'Codeperiod';
  CodePeriod.FieldType := ftString;
  YearPeriod.FieldName := 'Yearperiod';
  YearPeriod.FieldType := ftInteger;
  Active.FieldName     := 'Active';
  Active.FieldType     := ftInteger;
  COLID.FieldName      := 'COL_ID';
  COLID.FieldType      := ftInteger;

  // Création des champs
  FFieldNameID := 'COL_ID';
  CreateField([Code, Denotation, Datefrom, Dateto, CodePeriod, YearPeriod, Active, COLID]);

  // geston du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      if not FileExists(FPath + FTitle + '.Xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;
      eCollectionListNode := nXmlBase.ChildNodes.FindNode('Collectionlist');
      eCollectionNode     := eCollectionListNode.ChildNodes['Collection'];

      while eCollectionNode <> nil do
      begin
    //    if XmlStrToInt(eCollectionNode.ChildValues['Active']) = 1 then
        begin
          FCds.Append;
          FCds.FieldByName('Code').AsString := XmlStrToStr(eCollectionNode.ChildValues['Code']);
          FCds.FieldByName('Denotation').AsString := XmlStrToStr(eCollectionNode.ChildValues['Denotation']);
          FCDs.FieldByName('DateFrom').AsDateTime := XmlStrToDate(eCollectionNode.ChildValues['Datefrom']);
          FCDs.FieldByName('DateTo').AsDateTime := XmlStrToDate(eCollectionNode.ChildValues['Dateto']);
          FCds.FieldByName('Codeperiod').AsString  := XmlStrToStr(eCollectionNode.ChildValues['Codeperiod']);
          FCds.FieldByName('Yearperiod').AsInteger := XmlStrToInt(eCollectionNode.ChildValues['Yearperiod']);
          FCds.FieldByName('Active').AsInteger     := XmlStrToInt(eCollectionNode.ChildValues['Active']);
          FCds.Post;
        end;

        eCollectionNode := eCollectionNode.NextSibling;
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
