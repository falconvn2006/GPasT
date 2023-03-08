unit MSS_CorrespSizesClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type;

type
  TCorrespSizes = Class(TMainClass)
  private
    FPLXTYPEGT,
    FPLXGTS,
    FPLXTAILLESGS : TMainClass;
  public
    procedure Import;override;
    function ClearIdField : Boolean;override;
    function DoMajTable (ADoMaj : Boolean) : Boolean;override;

    constructor Create;override;
    destructor Destroy;override;

  published
    Property PLXTYPEGT    : TMainClass read FPLXTYPEGT    write FPLXTYPEGT;
    Property PLXGTS       : TMainClass read FPLXGTS       write FPLXGTS;
    Property PLXTAILLESGS : TMainClass read FPLXTAILLESGS write FPLXTAILLESGS;
  End;


implementation

{ TCorrespSizes }

function TCorrespSizes.ClearIdField: Boolean;
begin

end;

constructor TCorrespSizes.Create;
begin
  inherited Create;

  FPLXTYPEGT          := TMainClass.Create;
  FPLXTYPEGT.Title    := 'PLXTYPEGT';
  FPLXGTS             := TMainClass.Create;
  FPLXGTS.Title       := 'PLXGTS';
  FPLXTAILLESGS       := TMainClass.Create;
  FPLXTAILLESGS.Title := 'PLXTAILLESGS';

end;

destructor TCorrespSizes.Destroy;
begin
  FPLXTYPEGT.Free;
  FPLXGTS.Free;
  FPLXTAILLESGS.Free;

  inherited;
end;

function TCorrespSizes.DoMajTable(ADoMaj: Boolean): Boolean;
var
  TGT_ID, GTS_ID, TGS_ID : Integer;
  iAjout, iMaj : Integer;
  sTmpValue : String;
begin
  Inherited DoMajTable(ADoMaj);

  // traitement des données PLXTYPEGT
  FPLXTYPEGT.First;
  while not FPLXTYPEGT.EOF do
  begin
    Try
      With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_CORRESPSIZE_PLXTYPEGT';
        ParamCheck := True;
        ParamByName('ID').AsString := FPLXTYPEGT.FieldByName('ID').AsString;
        ParamByName('DENOTATION').AsString := '[IS] ' + FPLXTYPEGT.FieldByName('Denotation').AsString;
        Open;

        if Recordcount > 0 then
        begin
          TGT_ID := FieldByName('TGT_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retourné');
      end;
      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);
      FPLXTYPEGT.ClientDataSet.Edit;
      FPLXTYPEGT.ClientDataSet.FieldByName('TGT_ID').AsInteger := TGT_ID;
      FPLXTYPEGT.ClientDataSet.Post;
    Except on E:Exception do
      FErrLogs.Add('PLXTYPEGT - ' + FPLXTYPEGT.ClientDataSet.FieldByName('ID').AsString + ' / ' + FPLXTYPEGT.ClientDataSet.FieldByName('Denotation').AsString + ' : ' + E.Message);
    End;

    FPLXTYPEGT.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FPLXTYPEGT.ClientDataSet.RecNo * 100 Div FPLXTYPEGT.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end; // while


  // traitement des données PLXGTS
  FPLXGTS.First;
  while not FPLXGTS.EOF do
  begin
    Try
      if FPLXTYPEGT.FieldByName('ID').AsString <> FPLXGTS.FieldByName('MSR_ID').AsString then
      begin
        if FPLXTYPEGT.ClientDataSet.Locate('ID',FPLXGTS.FieldByName('MSR_ID').AsString,[loCaseInsensitive]) then
        begin
          TGT_ID := FPLXTYPEGT.FieldByName('TGT_ID').AsInteger;
          if TGT_ID = -1 then
            raise Exception.Create('PLXGTS -> Id PLXTYPEGT incorrect : ' + FPLXGTS.FieldByName('MSR_ID').AsString);
        end
        else
          raise Exception.Create('MSRID non trouvé');
      end
      else
        TGT_ID := FPLXTYPEGT.FieldByName('TGT_ID').AsInteger;

      With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_CORRESPSIZE_PLXGTS';
        ParamCheck := True;
        ParamByName('ID').AsString := FPLXGTS.FieldByName('ID').AsString;
        ParamByName('DENOTATION').AsString := FPLXGTS.FieldByName('Denotation').AsString;
        ParamByName('TGT_ID').AsInteger    := TGT_ID;
        ParamByName('GTS_ACTIVE').AsInteger := FPLXGTS.FieldByName('Active').AsInteger;
        sTmpValue := FPLXGTS.FieldByName('ID').AsString;
        ParamByName('GTS_ORDREAFF').AsInteger := StrToInt(Copy(sTmpValue,Pos('.',sTmpValue) + 1,Length(sTmpValue)));
        Open;
        if RecordCount > 0 then
        begin
          GTS_ID := FieldByName('GTS_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retournée');
      end;
      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);

      FPLXGTS.ClientDataSet.Edit;
      FPLXGTS.ClientDataSet.FieldByName('GTS_ID').AsInteger := GTS_ID;
      FPLXGTS.ClientDataSet.Post;
      
    Except on E:Exception do
      FErrLogs.Add('PLXGTS - ' + FPLXGTS.ClientDataSet.FieldByName('ID').AsString + ' / ' + FPLXGTS.ClientDataSet.FieldByName('Denotation').AsString + ' : ' + E.Message);
    End;

    FPLXGTS.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FPLXGTS.ClientDataSet.RecNo * 100 Div FPLXGTS.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end; // while

  FPLXTAILLESGS.First;
  while not FPLXTAILLESGS.EOF do
  begin
    Try
      if FPLXGTS.FieldByName('ID').AsString <> FPLXTAILLESGS.FieldByName('SR_ID').AsString then
      begin
        if FPLXGTS.ClientDataSet.Locate('ID',FPLXTAILLESGS.FieldByName('SR_ID').AsString,[loCaseInsensitive]) then
        begin
          GTS_ID := FPLXGTS.FieldByName('GTS_ID').AsInteger;
          if GTS_ID = -1 then
            raise Exception.Create('FPLXTAILLESGS -> Id FPLXGTS incorrect : ' + FPLXTAILLESGS.FieldByName('SR_ID').AsString);
        end
        else
          raise Exception.Create('SR_ID non trouvé');        
        
      end
      else
        GTS_ID := FPLXGTS.FieldByName('GTS_ID').AsInteger;
    
      With FStpQuery do
      begin
        Close;       
        StoredProcName := 'MSS_CORRESPSIZE_PLXTAILLESGS';
        ParamCheck := True;
        ParamByName('ID').AsString := FPLXTAILLESGS.FieldByName('Idx').AsString;
        ParamByName('DENOTATION').AsString := FPLXTAILLESGS.FieldByName('Denotation').AsString;
        ParamByName('GTS_ID').AsInteger    := GTS_ID;
        ParamByName('TGS_ACTIVE').AsInteger   := FPLXTAILLESGS.FieldByName('Active').AsInteger;
        if FPLXTAILLESGS.FieldByName('PositionGrille').IsNull then
          ParamByName('TGS_INDICE').AsString := FPLXTAILLESGS.FieldByName('Columnx').AsString
        else
          ParamByName('TGS_INDICE').AsString := FPLXTAILLESGS.FieldByName('PositionGrille').AsString;
        ParamByName('TGS_COLUMNX').AsString := FPLXTAILLESGS.FieldByName('Columnx').AsString;
        Open;                    

        if RecordCount > 0 then
        begin
          TGS_ID := FieldByName('TGS_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retournée');
      end;
      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);

      FPLXTAILLESGS.ClientDataSet.Edit;
      FPLXTAILLESGS.ClientDataSet.FieldByName('TGS_ID').AsInteger := TGS_ID;
      FPLXTAILLESGS.ClientDataSet.Post;

    Except on E:Exception do
      FErrLogs.Add('PLXTAILLESGS - ' + FPLXTAILLESGS.ClientDataSet.FieldByName('Idx').AsString + ' / ' + FPLXTAILLESGS.ClientDataSet.FieldByName('Denotation').AsString + ' : ' + E.Message);
    End;
  
    FPLXTAILLESGS.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FPLXTAILLESGS.ClientDataSet.RecNo * 100 Div FPLXTAILLESGS.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;
  

end;

procedure TCorrespSizes.Import;
var
  Xml : IXMLDocument;

  nXmlBase,
  eSizesListNode,
  eMainSizeRangeNode,
  eSizeRangeNode,
  eSizeListNode,
  eSizeNode : IXMLNode;

  MSR_ID, MSR_DENOTATION, MSR_TGTID : TFieldCFG;
  SR_ID, SR_ACTIVE, SR_DENOTATION, SR_MSRID, SR_GTSID : TFieldCFG;
  SZ_IDX, SZ_COLUMNX, SZ_DENOTATION, SZ_POSITIONGRILLE, SZ_MSRID, SZ_SRID, SZ_TGSID, SZ_Active : TFieldCFG;
begin
  // Définition des Datasets
  MSR_ID.FieldName := 'ID';
  MSR_ID.FieldType := ftString;
  MSR_DENOTATION.FieldName := 'Denotation';
  MSR_DENOTATION.FieldType := ftString;
  MSR_TGTID.FieldName := 'TGT_ID';
  MSR_TGTID.FieldType := ftInteger;

  SR_ID.FieldName := 'ID';
  SR_ID.FieldType := ftString;
  SR_ACTIVE.FieldName := 'Active';
  SR_ACTIVE.FieldType := ftInteger;
  SR_DENOTATION.FieldName := 'Denotation';
  SR_DENOTATION.FieldType := ftString;
  SR_MSRID.FieldName := 'MSR_ID';
  SR_MSRID.FieldType := ftString;
  SR_GTSID.FieldName := 'GTS_ID';
  SR_GTSID.FieldType := ftInteger;

  SZ_IDX.FieldName := 'Idx';
  SZ_IDX.FieldType := ftInteger;
  SZ_COLUMNX.FieldName := 'Columnx';
  SZ_COLUMNX.FieldType := ftString;
  SZ_DENOTATION.FieldName := 'Denotation';
  SZ_DENOTATION.FieldType := ftString;
  SZ_POSITIONGRILLE.FieldName := 'PositionGrille';
  SZ_POSITIONGRILLE.FieldType := ftInteger;
  SZ_MSRID.FieldName := 'MSR_ID';
  SZ_MSRID.FieldType := ftString;
  SZ_SRID.FieldName := 'SR_ID';
  SZ_SRID.FieldType := ftString;
  SZ_TGSID.FieldName := 'TGS_ID';
  SZ_TGSID.FieldType := ftInteger;
  SZ_Active.Fieldname := 'Active';
  SZ_Active.FieldType := ftInteger;

  FPLXTYPEGT.CreateField([MSR_ID, MSR_DENOTATION, MSR_TGTID]);
  FPLXTYPEGT.FieldNameID := 'TGT_ID';
  FPLXTYPEGT.KTB_ID := CKTBID_PLXTYPEGT;
  FPLXTYPEGT.IboQuery := FIboQuery;
  FPLXTYPEGT.StpQuery := FStpQuery;

  FPLXGTS.CreateField([SR_ID, SR_ACTIVE, SR_DENOTATION, SR_MSRID, SR_GTSID]);
  FPLXGTS.FieldNameID := 'GTS_ID';
  FPLXGTS.KTB_ID := CKTBID_PLXGTS;
  FPLXGTS.IboQuery := FIboQuery;
  FPLXGTS.StpQuery := FStpQuery;

  FPLXTAILLESGS.CreateField([SZ_IDX, SZ_COLUMNX, SZ_DENOTATION, SZ_POSITIONGRILLE, SZ_MSRID, SZ_SRID, SZ_Active, SZ_TGSID]);
  FPLXTAILLESGS.FieldNameID := 'TGS_ID';
  FPLXTAILLESGS.KTB_ID := CKTBID_PLXTAILLESGS;
  FPLXTAILLESGS.IboQuery := FIboQuery;
  FPLXTAILLESGS.StpQuery := FStpQuery;

  // gestion du XML
  Xml := TXMLDocument.Create(nil);
  try
    try
      if not FileExists(FPath + FTitle + '.Xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;
      eSizesListNode := nXmlBase.ChildNodes.FindNode('CorrespSizeslist');
      eMainSizeRangeNode := eSizesListNode.ChildNodes.FindNode('Mainsizerange');

      while eMainSizeRangeNode <> nil do
      begin
        With FPLXTYPEGT.ClientDataSet do
        begin
          Append;
          FieldByName('Id').AsString         := XmlStrToStr(eMainSizeRangeNode.ChildValues['Id']);
          FieldByName('Denotation').AsString := XmlStrToStr(eMainSizeRangeNode.ChildValues['Denotation']);
          FieldByName('TGT_ID').AsInteger    := -1;
          Post;
        end;

        eSizeRangeNode := eMainSizeRangeNode.ChildNodes.FindNode('Sizerange');
        while eSizeRangeNode <> nil do
        begin
          With FPLXGTS.ClientDataSet do
          begin
            Append;
            FieldByName('Id').AsString         := XmlStrToStr(eSizeRangeNode.ChildValues['Id']);
            FieldByName('Active').AsInteger    := XmlStrToInt(eSizeRangeNode.ChildValues['Active']);
            FieldByName('Denotation').AsString := XmlStrToStr(eSizeRangeNode.ChildValues['Denotation']);
            FieldByName('MSR_ID').AsString     := XmlStrToStr(eMainSizeRangeNode.ChildValues['Id']);
            FieldByName('GTS_ID').AsInteger    := -1;
            Post;
          end;

          eSizeListNode := eSizeRangeNode.ChildNodes.FindNode('Sizelist');
          eSizeNode := eSizeListNode.ChildNodes.FindNode('Size');
          while eSizeNode <> nil do
          begin
            With FPLXTAILLESGS.ClientDataSet do
            begin
              Append;
              FieldByName('Idx').AsInteger           := XmlStrToInt(eSizeNode.ChildValues['Idx']);
              FieldByName('Columnx').AsString        := XmlStrToStr(eSizeNode.ChildValues['Columnx']);
              FieldByName('Denotation').AsString     := XmlStrToStr(eSizeNode.ChildValues['Denotation']);
              FieldByName('PositionGrille').AsInteger := XmlStrToInt(eSizeNode.ChildValues['PositionGrille']);
              FieldByName('MSR_ID').AsString         := XmlStrToStr(eMainSizeRangeNode.ChildValues['Id']);
              FieldByName('SR_ID').AsString          := XmlStrToStr(eSizeRangeNode.ChildValues['Id']);
              Post;
            end;

            eSizeNode := eSizeNode.NextSibling;
          end;

          eSizeRangeNode := eSizeRangeNode.NextSibling;
        end;
        eMainSizeRangeNode := eMainSizeRangeNode.NextSibling;
      end;

    Except on E:Exception do
      raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
    end;
  finally
    Xml := Nil;
  end;
end;

end.
