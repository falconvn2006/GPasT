unit MSS_SizesClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type;

type
  TSizes = Class(TMainClass)
  private
    FPLXTYPEGT,
    FPLXGTF,
    FPLXTAILLEGF : TMainClass;
    // fonctions permettant de retourner les informations de l'enregistrement en cours
    function GetPlxTypeGT : Integer;
    function GetPlxGtf(TGT_ID, TGT_ID_JA : Integer) : Integer;
    function GetPlxTaillesGF (GTF_ID : Integer) : Integer;
  public
    // fonction qui retourne le TGT_ID de l'enregistrement en cours (Les cds doivent être correctement positionnés)
    function GetMainSizes : Integer;
    // fonction qui retourne le GTF_ID de l'enregistrement en cours (Les cds doivent être correctement positionnés)
    function GetSubRange : Integer;
    // Retourne le TGF_ID de l'enregistrement en cours (Les cds doivent être correctement positionnés)
    function GetSizes : Integer;

    procedure Import;override;
    function ClearIdField : Boolean;override;
    function DoMajTable (ADoMaj : Boolean) : Boolean;override;

    constructor Create;override;
    destructor Destroy;override;
  published
    property PLXTYPEGT : TMainClass read FPLXTYPEGT;
    property PLXGTF    : TMainClass read FPLXGTF;
    property PLXTAILLESGF : TMainClass read FPLXTAILLEGF;
  End;

implementation

{ TSizes }

function TSizes.ClearIdField: Boolean;
begin
  Result := False;
  try
    Result := FPLXTYPEGT.ClearIdField;
    Result := Result and FPLXGTF.ClearIdField;
    Result := Result and FPLXTAILLEGF.ClearIdField;
  Except on E:Exception do
    raise Exception.Create('ClearIdField ' + FTitle + ' -> ' + E.Message);
  end;
end;

constructor TSizes.Create;
begin
  inherited Create;

  FPLXTYPEGT := TMainClass.Create;
  FPLXTYPEGT.Title := 'PLXTYPEGT';
  FPLXGTF := TMainClass.Create;
  FPLXGTF.Title := 'PLXGTF';
  FPLXTAILLEGF := TMainClass.Create;
  FPLXTAILLEGF.Title := 'PLXTAILLESGF';
end;

destructor TSizes.Destroy;
begin
  FPLXTYPEGT.Free;
  FPLXGTF.Free;
  FPLXTAILLEGF.Free;
  inherited;
end;

function TSizes.DoMajTable (ADoMaj : Boolean): Boolean;
var
  TGT_ID, GTF_ID, TGT_ID_JA, TGF_ID, TGF_ORDREAFF : Integer;
  IMP_REFSTR, IdTmp : String;
  iAjout, iMaj : Integer;
begin
  Inherited DoMajTable(ADoMaj);

  // Traitement de FPLXGT
  FPLXTYPEGT.First;
  while not FPLXTYPEGT.Eof do
  begin
    Try
      With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_SIZES_PLXTYPEGT';
        ParamCheck := True;
        ParamByName('ID').AsString := FPLXTYPEGT.FieldByName('ID').AsString;
        ParamByName('Denotation').AsString := FPLXTYPEGT.FieldByName('Denotation').AsString;
        Open;
        if RecordCount > 0 then
        begin
          TGT_ID := FieldByName('TGT_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retournée');
      end;
      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);
      FPLXTYPEGT.ClientDataSet.Edit;
      FPLXTYPEGT.ClientDataSet.FieldByName('TGT_ID').AsInteger := TGT_ID;
      FPLXTYPEGT.ClientDataSet.Post;
    Except on E:Exception do
      FErrLogs.Add('PLXTYPEGT - ' + FPLXTYPEGT.FieldByName('ID').AsString + ' / ' + FPLXTYPEGT.FieldByName('Denotation').AsString + ' : ' + E.Message);
    End;

    FPLXTYPEGT.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FPLXTYPEGT.ClientDataSet.RecNo * 100 Div FPLXTYPEGT.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;

  // traitement de PLXGTF
  TGT_ID_JA := GetIDFromTable('PLXTYPEGT','TGT_NOM','REFERENCEMENT INTERSPORT','TGT_ID');
  FPLXGTF.ClientDataSet.First;
  while Not FPLXGTF.ClientDataSet.Eof do
  begin
   // if (FPLXGTF.FieldByName('Active').AsInteger = 1) then
    Try
      if FPLXTYPEGT.FieldByName('ID').AsString <> FPLXGTF.ClientDataSet.FieldByName('MSRID').AsString then
      begin
        FPLXTYPEGT.ClientDataSet.First;
        if FPLXTYPEGT.ClientDataSet.Locate('ID',FPLXGTF.ClientDataSet.FieldByName('MSRID').AsString,[locaseInsensitive]) then
        begin
          TGT_ID := FPLXTYPEGT.ClientDataSet.FieldByName('TGT_ID').AsInteger;
          if (TGT_ID = -1) then
            raise Exception.Create('PLXGTF -> Id PLXTYPEGT incorrect : ' + FPLXGTF.ClientDataSet.FieldByName('MSRID').AsString);
        end
        else
          raise Exception.Create('MSRID non trouvé');
      end
      else
        TGT_ID := FPLXTYPEGT.ClientDataSet.FieldByName('TGT_ID').AsInteger;

//      IMP_REFSTR := {FPLXGTF.ClientDataSet.FieldByName('MSRID').AsString + '/' +} FPLXGTF.ClientDataSet.FieldByName('ID').AsString;
      With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_SIZES_PLXGTF';
        ParamCheck := True;
        ParamByName('TGT_ID').AsInteger := TGT_ID;
        ParamByName('TGT_ID_JA').AsInteger := TGT_ID_JA;
        ParamByName('ID').AsString         := FPLXGTF.ClientDataSet.FieldByName('ID').AsString;
        ParamByName('Denotation').AsString := FPLXGTF.FieldByName('Denotation').AsString;
        ParamByName('GTF_ACTIVE').AsInteger := FPLXGTF.FieldByName('Active').AsInteger;
        IdTmp := FPLXGTF.ClientDataSet.FieldByName('ID').AsString;
        ParamByName('GTF_ORDREAFF').AsInteger := StrToInt(Copy(IdTmp,Pos('.',IdTmp) + 1,Length(IdTmp)));
        Open;
        if RecordCount > 0 then
        begin
          GTF_ID := FieldByName('GTF_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retournée');
      end;
      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);

      FPLXGTF.ClientDataSet.Edit;
      FPLXGTF.ClientDataSet.FieldByName('GTF_ID').AsInteger := GTF_ID;
      FPLXGTF.ClientDataSet.Post;
    Except on E:Exception do
      FErrLogs.Add('PLXGTF - ' + FPLXTYPEGT.ClientDataSet.FieldByName('ID').AsString + ' / ' + FPLXTYPEGT.ClientDataSet.FieldByName('Denotation').AsString + ' : ' + E.Message);
    End;
    FPLXGTF.ClientDataSet.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FPLXGTF.ClientDataSet.RecNo * 100 Div FPLXGTF.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;

  // traitement de FPLXTAILLEGF
  FPLXTAILLEGF.First;
  while not FPLXTAILLEGF.Eof do
  begin
    Try
//      IMP_REFSTR := {FPLXTAILLEGF.ClientDataSet.FieldByName('SRID').AsString + '/' +} FPLXTAILLEGF.FieldByName('Idx').AsString;

      if FPLXGTF.fieldByName('ID').AsString <> FPLXTAILLEGF.FieldByName('SRID').AsString then
      begin
        FPLXGTF.ClientDataSet.First;
        if FPLXGTF.ClientDataSet.Locate('ID',FPLXTAILLEGF.FieldByName('SRID').AsString,[loCaseInsensitive]) then
          GTF_ID := FPLXGTF.FieldByName('GTF_ID').AsInteger
        else
          raise Exception.Create('SRID non trouvé');
      end
      else
       GTF_ID := FPLXGTF.FieldByName('GTF_ID').AsInteger;

      if GTF_ID <> -1 then
      begin
        With FStpQuery do
        begin
          Close;
          StoredProcName := 'MSS_SIZES_PLXTAILLESGF';
          ParamCheck := True;
          ParamByName('GTF_ID').AsInteger := GTF_ID;
          ParamByName('ID').AsString      := FPLXTAILLEGF.FieldByName('Idx').AsString;
          ParamByName('Denotation').AsString := FPLXTAILLEGF.FieldByName('Denotation').AsString;
          if FPLXTAILLEGF.FieldByName('PositionGrille').AsInteger <> 0 then
            ParamByName('ORDREAFF').AsInteger := FPLXTAILLEGF.FieldByName('PositionGrille').AsInteger
          else
            ParamByName('ORDREAFF').AsInteger := FPLXTAILLEGF.FieldByName('Columnx').AsInteger;
          ParamByName('TGF_COLUMNX').AsString := FPLXTAILLEGF.FieldByName('Columnx').AsString;
          ParamByName('TGF_ACTIVE').AsInteger := FPLXTAILLEGF.FieldByName('Active').AsInteger;
          if Trim(FPLXTAILLEGF.FieldByName('IndexRefFrance').AsString) = '' then
            ParamByName('IndexRefFrance').Clear
          else
            ParamByName('IndexRefFrance').AsString := Trim(FPLXTAILLEGF.FieldByName('IndexRefFrance').AsString);

          Open;
          if RecordCount > 0 then
          begin
            TGF_ID := FieldByName('TGF_ID').AsInteger;
            iAjout := FieldbyName('FAJOUT').AsInteger;
            iMaj   := FieldByName('FMAJ').AsInteger;
          end
          else
            raise Exception.Create('Aucune donnée retournée');
        end;
        Inc(FInsertCount,iAjout);
        Inc(FMajCount,iMaj);
        FPLXTAILLEGF.ClientDataSet.Edit;
        FPLXTAILLEGF.ClientDataSet.FieldByName('TGF_ID').AsInteger := TGF_ID;
        FPLXTAILLEGF.ClientDataSet.Post;
      end;
    Except on E:Exception do
      FErrLogs.Add('PLXTAILLESGF - ' + FPLXGTF.FieldByName('Denotation').AsString + ' - ' +
                    FPLXTAILLEGF.FieldByName('Idx').AsString + ' / ' + FPLXTAILLEGF.FieldByName('Denotation').AsString + ' : ' + E.Message);
    End;

    FPLXTAILLEGF.ClientDataSet.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FPLXTAILLEGF.ClientDataSet.RecNo * 100 Div FPLXTAILLEGF.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;

end;

function TSizes.GetPlxGtf (TGT_ID, TGT_ID_JA : Integer): Integer;
var
  IMP_REFSTR, IdTmp : String;
begin
  Result := -1;
  try
//    IMP_REFSTR := {FPLXGTF.ClientDataSet.FieldByName('MSRID').AsString + '/' +} FPLXGTF.FieldByName('ID').AsString;
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_SIZES_PLXGTF';
      ParamCheck := True;
      ParamByName('TGT_ID').AsInteger := TGT_ID;
      ParamByName('TGT_ID_JA').AsInteger := TGT_ID_JA;
      ParamByName('ID').AsString         := FPLXGTF.FieldByName('ID').AsString;
      ParamByName('Denotation').AsString := FPLXGTF.FieldByName('Denotation').AsString;
      ParamByName('GTF_ACTIVE').AsInteger := FPLXGTF.FieldByName('Active').AsInteger;
      IdTmp := FPLXGTF.ClientDataSet.FieldByName('ID').AsString;
      ParamByName('GTF_ORDREAFF').AsInteger := StrToInt(Copy(IdTmp,Pos('.',IdTmp) + 1,Length(IdTmp)));
      Open;
      if RecordCount > 0 then
      begin
        Result := FieldByName('GTF_ID').AsInteger;
      end
      else
        raise Exception.Create('Aucune donnée retournée');
    end;

    FPLXGTF.ClientDataSet.Edit;
    FPLXGTF.ClientDataSet.FieldByName('GTF_ID').AsInteger := Result;
    FPLXGTF.ClientDataSet.Post;
  Except on E:Exception do
    raise Exception.Create('GetPlxGtf - ' + FPLXGTF.FieldByName('Id').AsString + ' / ' + FPLXGTF.FieldByName('Denotation').AsString + ' : ' + E.Message);
  end;
end;

function TSizes.GetPlxTaillesGF (GTF_ID : Integer): Integer;
var
  IMP_REFSTR : String;
begin
  Result := -1;
  Try
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_SIZES_PLXTAILLESGF';
      ParamCheck := True;
      ParamByName('GTF_ID').AsInteger := GTF_ID;
      ParamByName('ID').AsString      := FPLXTAILLEGF.FieldByName('Idx').AsString;
      ParamByName('Denotation').AsString := FPLXTAILLEGF.FieldByName('Denotation').AsString;
      if FPLXTAILLEGF.ClientDataSet.FieldByName('PositionGrille').AsInteger <> 0 then
        ParamByName('ORDREAFF').AsInteger := FPLXTAILLEGF.FieldByName('PositionGrille').AsInteger
      else
        ParamByName('ORDREAFF').AsInteger := FPLXTAILLEGF.FieldByName('Columnx').AsInteger;
      ParamByName('TGF_COLUMNX').AsString := FPLXTAILLEGF.FieldByName('Columnx').AsString;
      ParamByName('TGF_ACTIVE').AsInteger := FPLXTAILLEGF.FieldByName('Active').AsInteger;
      ParamByName('IndexRefFrance').AsString := Trim(FPLXTAILLEGF.FieldByName('IndexRefFrance').AsString);
      Open;
      if RecordCount > 0 then
      begin
        Result := FieldByName('TGF_ID').AsInteger;
      end
      else
        raise Exception.Create('Aucune donnée retournée');
    end;
    FPLXTAILLEGF.ClientDataSet.Edit;
    FPLXTAILLEGF.ClientDataSet.FieldByName('TGF_ID').AsInteger := Result;
    FPLXTAILLEGF.ClientDataSet.Post;
  Except on E:Exception do
    raise Exception.Create('GetPlxTaillesGF - ' + FPLXTAILLEGF.ClientDataSet.FieldByName('Idx').AsString + ' / ' + FPLXTAILLEGF.ClientDataSet.FieldByName('Denotation').AsString + ' : ' + E.Message);
  End;
end;

function TSizes.GetPlxTypeGT: Integer;
begin
  Result := -1;
  try
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_SIZES_PLXTYPEGT';
      ParamCheck := True;
      ParamByName('ID').AsString := FPLXTYPEGT.FieldByName('ID').AsString;
      ParamByName('Denotation').AsString := FPLXTYPEGT.FieldByName('Denotation').AsString;
      Open;
      if RecordCount > 0 then
      begin
        Result := FieldByName('TGT_ID').AsInteger;
      end
      else
        raise Exception.Create('Aucune donnée retournée');
    end;
    FPLXTYPEGT.ClientDataSet.Edit;
    FPLXTYPEGT.ClientDataSet.FieldByName('TGT_ID').AsInteger := Result;
    FPLXTYPEGT.ClientDataSet.Post;
  Except on E:Exception do
    raise Exception.Create('GetPlxTypeGT - ' + FPLXTYPEGT.FieldByName('Id').AsString + ' / ' + FPLXTYPEGT.FieldByName('Denotation').AsString + ' : ' + E.Message);
  end;
end;

function TSizes.GetMainSizes: Integer;
var
  TGT_ID  : Integer;
begin
  Try
    TGT_ID := GetPlxTypeGT;

    Result := TGT_ID;
  Except on E:Exception do
    raise Exception.Create(E.Message);
  End;
end;

function TSizes.GetSubRange: Integer;
var
  TGT_ID, TGT_ID_JA , GTF_ID : Integer;
begin
  Try
    TGT_ID := GetPlxTypeGT;
    TGT_ID_JA := 0; // GetIDFromTable('PLXTYPEGT','TGT_NOM','REFERENCEMENT INTERSPORT','TGT_ID');
    GTF_ID := GetPlxGtf(TGT_ID,TGT_ID_JA);

    Result := GTF_ID;
  Except on E:Exception do
    raise Exception.Create(E.Message);
  End;
end;

function TSizes.GetSizes: Integer;
var
  TGT_ID, TGT_ID_JA , GTF_ID, TGF_ID : Integer;
begin
  Try
    TGT_ID := GetPlxTypeGT;
    TGT_ID_JA := GetIDFromTable('PLXTYPEGT','TGT_NOM','REFERENCEMENT INTERSPORT','TGT_ID');
    GTF_ID := GetPlxGtf(TGT_ID,TGT_ID_JA);
    TGF_ID := GetPlxTaillesGF(GTF_ID);

    Result := TGF_ID;
  Except on E:Exception do
    raise Exception.Create(E.Message);
  End;
end;

procedure TSizes.Import;
var
  Xml : IXMLDocument;
  nXmlBase,
  eSizeListNode,
  eMainSizeRangeNode,
  eSizeRangeNode,
  eSizeRangeSizeListNode,
  eSizeNode : IXMLNode;

  MainSizeRangeId, MainSizeRangeDenotation,  TGTID : TFieldCFG;
  SizeRangeMSRId, SizeRangeId, SizeRangeDenotation,Active, GTFID : TFieldCFG;
  SizeSRID, SizeIdx, SizeColumnx, SizeDenotation, SizeIndexRefFrance, SizePositionGrille, TGFID : TFieldCFG;

begin
  // -----------------------------------------------
  // Fcds n'est pas utilisé FPLXGT, PLXGTF et
  // PLXTAILLESGF seront utilisés à la place
  // -----------------------------------------------

  // Définition du champs des Dataset

  MainSizeRangeID.FieldName         := 'ID';
  MainSizeRangeID.FieldType         := ftString;
  MainSizeRangeDenotation.FieldName := 'Denotation';
  MainSizeRangeDenotation.FieldType := ftString;
  TGTID.FieldName                   := 'TGT_ID';
  TGTID.FieldType                   := ftInteger;

  SizeRangeMSRId.FieldName      := 'MSRID';
  SizeRangeMSRId.FieldType      := ftString;
  SizeRangeId.FieldName         := 'ID';
  SizeRangeId.FieldType         := ftString;
  SizeRangeDenotation.FieldName := 'Denotation';
  SizeRangeDenotation.FieldType := ftString;
  Active.FieldName              := 'Active';
  Active.FieldType              := ftInteger;
  GTFID.FieldName               := 'GTF_ID';
  GTFID.FieldType               := ftInteger;

  SizeSRID.FieldName            := 'SRID';
  SizeSRID.FieldType            := ftString;
  SizeIdx.FieldName             := 'Idx';
  SizeIdx.FieldType             := ftString;
  SizeColumnx.FieldName         := 'Columnx';
  SizeColumnx.FieldType         := ftString;
  SizeDenotation.FieldName      := 'Denotation';
  SizeDenotation.FieldType      := ftString;
  SizeIndexRefFrance.FieldName  := 'IndexRefFrance';
  SizeIndexRefFrance.FieldType  := ftString;
  SizePositionGrille.FieldName  := 'PositionGrille';
  SizePositionGrille.FieldType  := ftInteger;
  TGFID.FieldName               := 'TGF_ID';
  TGFID.FieldType               := ftInteger;

  // Création des champs
  FPLXTYPEGT.FieldNameID := 'TGT_ID';
  FPLXTYPEGT.CreateField([MainSizeRangeID,MainSizeRangeDenotation,TGTID]);
  FPLXTYPEGT.ClientDataSet.AddIndex('Idx',MainSizeRangeID.FieldName,[ixPrimary]);
  FPLXTYPEGT.ClientDataSet.IndexName := 'Idx';
  FPLXTYPEGT.KTB_ID := CKTBID_PLXTYPEGT;
  FPLXTYPEGT.IboQuery := FIboQuery;
  FPLXTYPEGT.StpQuery := FStpQuery;

  FPLXGTF.FieldNameID := 'GTF_ID';
  FPLXGTF.CreateField([SizeRangeMSRId,SizeRangeId,SizeRangeDenotation,Active,GTFID]);
  FPLXGTF.ClientDataSet.AddIndex('Idx',SizeRangeMSRId.FieldName + ';' + SizeRangeId.FieldName,[ixPrimary]);
  FPLXGTF.ClientDataSet.IndexName := 'Idx';
  FPLXGTF.KTB_ID := CKTBID_PLXGTF;
  FPLXGTF.IboQuery := FIboQuery;
  FPLXGTF.StpQuery := FStpQuery;

  FPLXTAILLEGF.FieldNameID := 'TGF_ID';
  FPLXTAILLEGF.CreateField([SizeSRID,SizeIdx,SizeColumnx,SizeDenotation,SizeIndexRefFrance,SizePositionGrille, Active,TGFID]);
  FPLXTAILLEGF.ClientDataSet.AddIndex('Idx',SizeSRID.FieldName + ';' + SizeIdx.FieldName + ';' + SizeColumnx.FieldName,[ixPrimary]);
  FPLXTAILLEGF.ClientDataSet.IndexName := 'Idx';
  FPLXTAILLEGF.KTB_ID := CKTBID_PLXTAILLESGF;
  FPLXTAILLEGF.IboQuery := FIboQuery;
  FPLXTAILLEGF.StpQuery := FStpQuery;

  // geston du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      if not FileExists(FPath + FTitle + '.Xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;
      eSizeListNode := nXmlBase.ChildNodes.FindNode('Sizeslist');
      eMainSizeRangeNode := eSizeListNode.ChildNodes['Mainsizerange'];

      while eMainSizeRangeNode <> nil do
      begin
        With FPLXTYPEGT.ClientDataSet do
        begin
          Append;
          FieldByName('ID').AsString         := XmlStrToStr(eMainSizeRangeNode.ChildValues['Id']);
          FieldByName('Denotation').AsString := XmlStrToStr(eMainSizeRangeNode.ChildValues['Denotation']);
          FieldByName('TGT_ID').AsInteger    := -1;
          Post;
        end;

        eSizeRangeNode := eMainSizeRangeNode.ChildNodes.FindNode('Sizerange');
        while eSizeRangeNode <> nil do
        begin
//          if XmlStrToInt(eSizeRangeNode.ChildValues['Active']) = 1 then
          begin
            With FPLXGTF.ClientDataSet do
            begin
              Append;
              FieldByName('MSRID').AsString      := XmlStrToStr(eMainSizeRangeNode.ChildValues['Id']);
              FieldByName('ID').AsString         := XmlStrToStr(eSizeRangeNode.ChildValues['Id']);
              FieldbyName('Denotation').AsString := XmlStrToStr(eSizeRangeNode.ChildValues['Denotation']);
              FieldByName('Active').AsInteger    := XmlStrToInt(eSizeRangeNode.ChildValues['Active']);
              FieldByName('GTF_ID').AsInteger    := -1;
              Post;
            end;
            eSizeRangeSizeListNode := eSizeRangeNode.ChildNodes.FindNode('Sizelist');
            eSizeNode              := eSizeRangeSizeListNode.ChildNodes['Size'];
            while eSizeNode <> nil do
            begin
              With FPLXTAILLEGF.ClientDataSet do
              begin
                Append;
                FieldByName('SRID').AsString            := XmlStrToStr(eSizeRangeNode.ChildValues['Id']);
                FieldByName('Idx').AsString             := XmlStrToStr(eSizeNode.ChildValues['Idx']);
                FieldByName('Columnx').AsString         := XmlStrToStr(eSizeNode.ChildValues['Columnx']);
                FieldByName('Denotation').AsString      := XmlStrToStr(eSizeNode.ChildValues['Denotation']);
                FieldByName('IndexRefFrance').AsString  := XmlStrToStr(eSizeNode.ChildValues['IndexRefFrance']);
                FieldByName('PositionGrille').AsInteger := XmlStrToInt(eSizeNode.ChildValues['PositionGrille']);
                FieldByName('Active').AsInteger         := 1; // Pas géré dans les fichiers pour le moment XmlStrToInt(eSizeNode.ChildValues['Active']);
                FieldByName('TGF_ID').AsInteger         := -1;
                Post;
              end;
              eSizeNode := eSizeNode.NextSibling;
            end; // while eSizeNode
          end; // if
          eSizeRangeNode := eSizeRangeNode.NextSibling;
        end;
        eMainSizeRangeNode := eMainSizeRangeNode.NextSibling;
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
