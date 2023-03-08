unit MSS_FedasClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type,
     StrUtils;

type
  TFedas = Class(TMainClass)
  private
    FNKLSecteur,
    FNKLRayon,
    FNKLFamille,
    FNKLSSfamille : TMainClass;
    FType : String;
  public
    procedure Import;override;
    function ClearIdField : Boolean;override;
    function DoMajTable (ADoMaj : Boolean) : Boolean;override;

    constructor Create;override;
    destructor Destroy;override;

  published
    property NKLSecteur : TMainClass read FNKLSecteur;
    property NKLRayon    : TMainClass read FNKLRayon;
    property NKLFamille : TMainClass read FNKLFamille;
    property NKLSSFamille : TMainClass read FNKLSSFamille;
  End;


implementation

{ TFedas }

function TFedas.ClearIdField: Boolean;
begin
  Result := False;
  try
    Result := FNKLSecteur.ClearIdField;
    Result := Result and FNKLRayon.ClearIdField;
    Result := Result and FNKLFamille.ClearIdField;
    Result := Result and FNKLSSFamille.ClearIdField;
  Except on E:Exception do
    raise Exception.Create('ClearIdField ' + FTitle + ' -> ' + E.Message);
  end;
end;

constructor TFedas.Create;
begin
  inherited Create;

  FNKLSecteur := TMainClass.Create;
  FNKLSecteur.Title := 'Secteur';
  FNKLRayon   := TMainClass.Create;
  FNKLRayon.Title := 'Rayon';
  FNKLFamille := TMainClass.Create;
  FNKLFamille.Title := 'Famille';
  FNKLSSfamille := TMainClass.Create;
  FNKLSSfamille.Title := 'SSFamille';
end;

destructor TFedas.Destroy;
begin
  FNKLSSfamille.Free;
  FNKLFamille.Free;
  FNKLRayon.Free;
  FNKLSecteur.Free;
  inherited;
end;

function TFedas.DoMajTable(ADoMaj: Boolean): Boolean;
var
  ACT_ID, UNI_ID, SEC_ID, RAY_ID, FAM_ID, SSF_ID, TCT_ID, TVA_ID : Integer;
  IMP_REFSTR : String;
  iAjout, iMaj : Integer;
begin

  {$REGION 'Récupération du domaine'}
  ACT_ID := 0;
//  ACT_ID := GetIDFromTable('NKLACTIVITE','ACT_CODE','MAG','ACT_ID');
//  if ACT_ID = -1 then
//    ACT_ID := SetDomaine('Magasin','MAG',0,0);
  {$ENDREGION}

  // Gestion de l'univers FEDAS
  UNI_ID := GetIDFromTable('NKLUNIVERS','UNI_IDREF',99,'UNI_ID');
  if UNI_ID = -1 then
  begin
    With FIboQuery do
    begin
      UNI_ID := GetNewKID('NKLUNIVERS');
      Close;
      SQL.CLear;
      SQL.Add('insert into NKLUNIVERS(UNI_ID, UNI_IDREF, UNI_NOM,UNI_NIVEAU, UNI_ORIGINE, UNI_CODE, UNI_CENTRALE, UNI_OBLIGATOIRE, UNI_ACTID)');
      SQL.Add('Values(:PUNIID,99,:PUNINOM,4,1, :PUNICODE, 1,1, :PACTID)');
      ParamCheck := True;
      ParamByName('PUNIID').AsInteger  := UNI_ID;
      ParamByName('PUNINOM').AsString  := '[MSS] FEDAS INTERSPORT';
      ParamByName('PUNICODE').AsString := FType;
      ParamByName('PACTID').AsInteger  := ACT_ID;
      ExecSQL;
    end;
  end;

  // Type comptable
  GetGenParam(12,3,TCT_ID);
  // TVA par defaut
  GetGenParam(12,1,TVA_ID);


  // Gestion du secteur
  FNKLSecteur.ClientDataSet.First;
  while not FNKLSecteur.ClientDataSet.Eof do
  begin
    Try
      With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_UNIVERSCRITERIA_SECTEUR';
        ParamCheck := True;
        ParamByName('UNI_ID').AsInteger       := UNI_ID;
        ParamByName('ID').AsString            := FNKLSecteur.FieldByName('Id').AsString;
        ParamByName('SEC_NOM').AsString       := FNKLSecteur.FieldByName('Denotation').AsString;
        ParamByName('SEC_IDREF').AsInteger    := StrToInt(FNKLSecteur.FieldByName('Id').AsString);
        ParamByName('SEC_ORDREAFF').AsInteger := StrToInt(FNKLSecteur.FieldByName('Id').AsString);
        ParamByName('SEC_VISIBLE').AsInteger := 1;
        Open;

        if RecordCount > 0 then
        begin
          SEC_ID := FieldByName('SEC_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retournée');
      end;

      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);
      FNKLSecteur.ClientDataSet.Edit;
      FNKLSecteur.ClientDataSet.FieldByName('SEC_ID').AsInteger := SEC_ID;
      FNKLSecteur.ClientDataSet.Post;

    Except on E:Exception do
      FErrLogs.Add(FNKLSecteur.FieldByName('Id').AsString + ' ' +
                   FNKLSecteur.FieldByName('Denotation').AsString + ' - ' + E.Message);
    End;
    FNKLSecteur.ClientDataSet.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FNKLSecteur.ClientDataSet.RecNo * 100 Div FNKLSecteur.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;

  // Gestion du Rayon
  FNKLRayon.First;
  while not FNKLRayon.Eof do
  begin
    Try
//      IMP_REFSTR := FNKLRayon.ClientDataSet.FieldByName('LVL1ID').AsString + '/' + FNKLRayon.ClientDataSet.FieldByName('Id').AsString;
//      RAY_ID := FNKLRayon.IsInGenImport(CIMPNUM_FEDAS,IMP_REFSTR);
      FNKLSecteur.First;
      if FNKLSecteur.ClientDataSet.Locate('Id',FNKLRayon.FieldByName('LVL1ID').AsInteger,[loCaseInsensitive]) then
      begin
        SEC_ID := FNKLSecteur.FieldByName('SEC_ID').AsInteger;
        if SEC_ID = -1 then
          raise Exception.Create('NKLRayon -> Id Secteur invalide');

      end
      else
        raise Exception.Create('NKLRayon -> Secteur introuvable :' + FNKLRayon.FieldByName('LVL1ID').AsString);

      With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_UNIVERSCRITERIA_RAYON';
        ParamCheck := True;
        ParamByName('SEC_ID').AsInteger       := SEC_ID;
        ParamByName('UNI_ID').AsInteger       := UNI_ID;
        ParamByName('ID').AsString            := FNKLRayon.FieldByName('Id').AsString;
        ParamByName('Denotation').AsString    := FNKLRayon.FieldByName('Denotation').AsString;
        ParamByName('RAY_IDREF').AsInteger    := 0;
        ParamByName('RAY_ORDREAFF').AsInteger := StrToInt(FNKLRayon.FieldByName('Id').AsString);
        ParamByName('RAY_CODENIV').AsString   := FNKLRayon.FieldByName('LVL1ID').AsString +
                                                 FNKLRayon.FieldByName('Id').AsString;
        Open;

        if RecordCount > 0 then
        begin
          RAY_Id := FieldByName('RAY_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retournée');
      end;

      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);

      FNKLRayon.ClientDataSet.Edit;
      FNKLRayon.ClientDataSet.FieldByName('RAY_ID').AsInteger := RAY_ID;
      FNKLRayon.ClientDataSet.Post;

    Except on E:Exception do
      FErrLogs.Add(FNKLRayon.FieldByName('Id').AsString + ' ' +
                   FNKLRayon.FieldByName('Denotation').AsString + ' - ' + E.Message);
    End;
    FNKLRayon.ClientDataSet.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FNKLRayon.ClientDataSet.RecNo * 100 Div FNKLRayon.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;

  // Gestion de la famille
  FNKLFamille.First;
  while not FNKLFamille.Eof do
  begin
    try
//      IMP_REFSTR := FNKLFamille.ClientDataSet.FieldByName('LVL1ID').AsString + '/' +
//                    FNKLFamille.ClientDataSet.FieldByName('LVL2ID').AsString + '/' +
//                    FNKLFamille.ClientDataSet.FieldByName('Id').AsString;
//      FAM_ID := FNKLFamille.IsInGenImport(CIMPNUM_FEDAS,IMP_REFSTR);
      FNKLRayon.First;
      if FNKLRayon.ClientDataSet.Locate('LVL1ID;Id',
                                         VarArrayOf([FNKLFamille.FieldByName('LVL1ID').AsInteger,
                                         FNKLFamille.FieldByName('LVL2ID').AsInteger]),
                                         [loCaseInsensitive]) then
      begin
        RAY_ID := FNKLRayon.FieldByName('RAY_ID').AsInteger;
        if RAY_ID = -1 then
          raise Exception.Create('NKLRayon -> Id rayon incorrect');
      end
      else
        raise Exception.Create('NKLRayon -> Rayon non trouvé : ' + FNKLFamille.FieldByName('LVL1ID').AsString + '/' +
                                                                   FNKLFamille.FieldByName('LVL2ID').AsString);
      With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_UNIVERSCRITERIA_FAMILLE';
        ParamCheck := True;
        ParamByName('RAY_ID').AsInteger       := RAY_ID;
        ParamByName('ID').AsString            := FNKLFamille.FieldByName('Id').AsString;
        ParamByName('Denotation').AsString    := FNKLFamille.FieldByName('Denotation').AsString;
        ParamByName('FAM_IDREF').AsInteger    := 0;
        ParamByName('FAM_ORDREAFF').AsInteger := StrToInt(FNKLFamille.FieldByName('Id').AsString);
        ParamByName('FAM_CODENIV').AsString   := FNKLFamille.FieldByName('LVL1ID').AsString +
                                                 FNKLFamille.FieldByName('LVL2ID').AsString +
                                                 FNKLFamille.FieldByName('Id').AsString;
        Open;

        if RecordCount > 0 then
        begin
          FAM_ID := FieldByName('FAM_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retournée');
      end;

      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);

      FNKLFamille.ClientDataSet.Edit;
      FNKLFamille.ClientDataSet.FieldByName('FAM_ID').AsInteger := FAM_ID;
      FNKLFamille.ClientDataSet.Post;
    Except on E:Exception do
      FErrLogs.Add(FNKLFamille.FieldByName('Id').AsString + ' ' +
                   FNKLFamille.FieldByName('Denotation').AsString + ' - ' + E.Message);
    End;
    FNKLFamille.ClientDataSet.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FNKLFamille.ClientDataSet.RecNo * 100 Div FNKLFamille.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;

  // Gestion de la sousfamille
  FNKLSSfamille.First;
  while not FNKLSSfamille.Eof do
  begin
    try
//      IMP_REFSTR := FNKLSSFamille.ClientDataSet.FieldByName('LVL1ID').AsString + '/' +
//                    FNKLSSFamille.ClientDataSet.FieldByName('LVL2ID').AsString + '/' +
//                    FNKLSSFamille.ClientDataSet.FieldByName('LVL3ID').AsString + '/' +
//                    FNKLSSfamille.ClientDataSet.FieldByName('CODE').AsString;

//      SSF_ID := FNKLSSFamille.IsInGenImport(CIMPNUM_FEDAS, IMP_REFSTR);
      FNKLFamille.First;
      if FNKLFamille.ClientDataSet.Locate('LVL1ID;LVL2ID;Id',
                                         VarArrayOf([FNKLSSFamille.FieldByName('LVL1ID').AsInteger,
                                         FNKLSSFamille.FieldByName('LVL2ID').AsInteger,
                                         FNKLSSFamille.FieldByName('LVL3ID').AsInteger]),
                                         [loCaseInsensitive]) then
      begin
        FAM_ID := FNKLFamille.FieldByName('FAM_ID').AsInteger;
        if FAM_ID = -1 then
          raise Exception.Create('NKLFamille -> Id Famille incorrect');
      end
      else
        raise Exception.Create('NKLFamille -> Rayon non trouvé : ' + FNKLSSFamille.FieldByName('LVL1ID').AsString + '/' +
                                                                   FNKLSSFamille.FieldByName('LVL2ID').AsString);

      With FStpQuery do
      begin
        Close;
        StoredProcName := 'MSS_UNIVERSCRITERIA_SSFAMILLE';
        ParamCheck := True;
        ParamByName('FAM_ID').AsInteger       := FAM_ID;
        ParamByName('ID').AsString            := IMP_REFSTR;
        ParamByName('Denotation').AsString    := FNKLSSfamille.FieldByName('Denotation').AsString;
        ParamByName('SSFTCTID').AsInteger     := TCT_ID;
        ParamByName('SSFTVAID').AsInteger     := TVA_ID;
        ParamByName('SSF_IDREF').AsInteger    := 0;
        ParamByName('SSF_CODE').AsString      := FNKLSSfamille.FieldByName('CODE').AsString;
        ParamByName('SSF_CODENIV').AsString   := RightStr( FNKLSSfamille.FieldByName('CODE').AsString,1);
        ParamByName('SSF_CODEFINAL').AsString := FNKLSSfamille.FieldByName('CODE').AsString;
        ParamByName('SSF_ORDREAFF').AsInteger := StrToInt(FNKLSSfamille.FieldByName('CODE').AsString);
        ParamByName('SSF_VISIBLE').AsInteger  := FNKLSSfamille.FieldByName('Active').AsInteger;
        Open;

        if RecordCount > 0 then
        begin
          SSF_ID := FieldByName('SSF_ID').AsInteger;
          iAjout := FieldbyName('FAJOUT').AsInteger;
          iMaj   := FieldByName('FMAJ').AsInteger;
        end
        else
          raise Exception.Create('Aucune donnée retournée');
      end;

      Inc(FInsertCount,iAjout);
      Inc(FMajCount,iMaj);

      FNKLSSFamille.ClientDataSet.Edit;
      FNKLSSFamille.ClientDataSet.FieldByName('SSF_ID').AsInteger := SSF_ID;
      FNKLSSFamille.ClientDataSet.Post;

    Except on E:Exception do
      FErrLogs.Add(FNKLSSfamille.FieldByName('CODE').AsString + ' ' +
                   FNKLSSfamille.FieldByName('Denotation').AsString + ' - ' + E.Message);
    End;

    FNKLSSfamille.ClientDataSet.Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FNKLSSfamille.ClientDataSet.RecNo * 100 Div FNKLSSfamille.ClientDataSet.RecordCount;
    Application.ProcessMessages;
  end;
end;

procedure TFedas.Import;
var
  Xml : IXMLDocument;
  nXmlBase, eFedasListNode, eProductCategoryNode, eActivityCodeNode,
  eItemGroupNode, eFedasNode : IXMLNode;

  PCID, PCDenotation, PCSECID : TFieldCFG;
  ACLVL1ID,ACID, ACDenotation, ACRAYID : TFieldCFG;
  IGLVL1ID, IGLVL2ID, IGID, IGDenotation, IGFAMID : TFieldCFG;
  FDLVL1ID, FDLVL2ID, FDLVL3ID, FDCODE, FDMSR, FDDenotation, FDSSFID, FDActive : TFieldCFG;
begin
  // Définition du champs du Dataset
  PCID.FieldName := 'ID';
  PCID.FieldType := ftInteger;
  PCDenotation.FieldName := 'Denotation';
  PCDenotation.FieldType := ftString;
  PCSECID.FieldName := 'SEC_ID';
  PCSECID.FieldType := ftInteger;

  ACLVL1ID.FieldName := 'LVL1ID';
  ACLVL1ID.FieldType := ftInteger;
  ACID.FieldName     := 'ID';
  ACID.FieldType     := ftInteger;
  ACDenotation.FieldName := 'Denotation';
  ACDenotation.FieldType := ftString;
  ACRAYID.FieldName      := 'RAY_ID';
  ACRAYID.FieldType      := ftInteger;

  IGLVL1ID.FieldName := 'LVL1ID';
  IGLVL1ID.FieldType := ftInteger;
  IGLVL2ID.FieldName := 'LVL2ID';
  IGLVL2ID.FieldType := ftInteger;
  IGID.FieldName     := 'ID';
  IGID.FieldType     := ftInteger;
  IGDenotation.FieldName := 'Denotation';
  IGDenotation.FieldType := ftString;
  IGFAMID.FieldName := 'FAM_ID';
  IGFAMID.FieldType := ftInteger;

  FDLVL1ID.FieldName := 'LVL1ID';
  FDLVL1ID.FieldType := ftInteger;
  FDLVL2ID.FieldName := 'LVL2ID';
  FDLVL2ID.FieldType := ftInteger;
  FDLVL3ID.FieldName := 'LVL3ID';
  FDLVL3ID.FieldType := ftInteger;
  FDCODE.FieldName   := 'CODE';
  FDCODE.FieldType   := ftInteger;
  FDMSR.FieldName    := 'MSR';
  FDMSR.FieldType    := ftString;
  FDDenotation.FieldName := 'Denotation';
  FDDenotation.FieldType := ftString;
  FDActive.FieldName     := 'Active';
  FDActive.FieldType     := ftInteger;
  FDSSFID.FieldName := 'SSF_ID';
  FDSSFID.FieldType := ftInteger;

  // Création des champs
  FNKLSecteur.CreateField([PCID, PCDenotation, PCSECID]);
  FNKLSecteur.ClientDataSet.IndexDefs.Add('Idx',PCID.FieldName,[ixPrimary]);
  FNKLSecteur.ClientDataSet.IndexName := 'Idx';
  FNKLSecteur.FieldNameID := 'SEC_ID';
  FNKLSecteur.KTB_ID := CKTBID_NKLSECTEUR;
  FNKLSecteur.IboQuery := FIboQuery;
  FNKLSecteur.StpQuery := FStpQuery;

  FNKLRayon.CreateField([ACLVL1ID,ACID, ACDenotation, ACRAYID]);
  FNKLRayon.ClientDataSet.IndexDefs.Add('Idx',ACLVL1ID.FieldName + ';' + ACID.FieldName,[ixPrimary]);
  FNKLRayon.ClientDataSet.IndexName := 'Idx';
  FNKLRayon.FieldNameID := 'RAY_ID';
  FNKLRayon.KTB_ID := CKTBID_NKLRAYON;
  FNKLRayon.IboQuery := FIboQuery;
  FNKLRayon.StpQuery := FStpQuery;

  FNKLFamille.CreateField([IGLVL1ID, IGLVL2ID, IGID, IGDenotation, IGFAMID]);
  FNKLFamille.ClientDataSet.IndexDefs.Add('Idx',IGLVL1ID.FieldName + ';' + IGLVL2ID.FieldName + ';' + IGID.FieldName,[ixPrimary]);
  FNKLFamille.ClientDataSet.IndexName := 'Idx';
  FNKLFamille.FieldNameID := 'FAM_ID';
  FNKLFamille.KTB_ID := CKTBID_NKLFAMILLE;
  FNKLFamille.IboQuery := FIboQuery;
  FNKLFamille.StpQuery := FStpQuery;

  FNKLSSfamille.CreateField([FDLVL1ID, FDLVL2ID, FDLVL3ID, FDCODE, FDMSR, FDDenotation, FDActive, FDSSFID]);
  FNKLSSfamille.ClientDataSet.IndexDefs.Add('Idx',FDLVL1ID.FieldName + ';' + FDLVL2ID.FieldName + ';' + FDLVL3ID.FieldName + ';' + FDCODE.FieldName,[ixPrimary]);
  FNKLSSfamille.ClientDataSet.IndexName := 'Idx';
  FNKLSSfamille.FieldNameID := 'SSF_ID';
  FNKLSSfamille.KTB_ID := CKTBID_NKLSSFAMILLE;
  FNKLSSfamille.IboQuery := FIboQuery;
  FNKLSSfamille.StpQuery := FStpQuery;

  // geston du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      if not FileExists(FPath + FTitle + '.Xml') then
        raise Exception.Create('fichier ' + FPath + FTitle + '.Xml non trouvé');

      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;
      FType := XmlStrToStr(nXmlBase.ChildValues['Type']);
      eFedasListNode := nXmlBase.ChildNodes.FindNode('Fedaslist');
      eProductCategoryNode := eFedasListNode.ChildNodes.FindNode('Productcategory');
      while eProductCategoryNode <> nil do
      begin
        With FNKLSecteur.ClientDataSet do
        begin
          Append;
          FieldByName('ID').AsInteger := XmlStrToInt(eProductCategoryNode.ChildValues['Id']);
          FieldByName('Denotation').AsString := XmlStrToStr(eProductCategoryNode.ChildValues['Denotation']);
          Post;
        end;

        eActivityCodeNode := eProductCategoryNode.ChildNodes.FindNode('Activitycode');
        while eActivityCodeNode <> nil do
        begin
          With FNKLRayon.ClientDataSet do
          begin
            Append;
            FieldByName('LVL1ID').AsInteger := XmlStrToInt(eProductCategoryNode.ChildValues['Id']);
            FieldByName('ID').AsInteger := XmlStrToInt(eActivityCodeNode.ChildValues['Id']);
            FieldByName('Denotation').AsString := XmlStrToStr(eActivityCodeNode.ChildValues['Denotation']);
            Post;
          end;
          eItemGroupNode := eActivityCodeNode.ChildNodes.FindNode('Itemgroup');
          while eItemGroupNode <> nil do
          begin
            With FNKLFamille.ClientDataSet do
            begin
              Append;
              FieldByName('LVL1ID').AsInteger := XmlStrToInt(eProductCategoryNode.ChildValues['Id']);
              FieldByName('LVL2ID').AsInteger := XmlStrToInt(eActivityCodeNode.ChildValues['Id']);
              FieldByName('ID').AsInteger     := XmlStrToInt(eItemGroupNode.ChildValues['Id']);
              FieldByName('Denotation').AsString := XmlStrToStr(eItemGroupNode.ChildValues['Denotation']);
              Post;
            end;

            eFedasNode := eItemGroupNode.ChildNodes.FindNode('Fedas');
            while eFedasNode <> nil do
            begin
              With FNKLSSfamille.ClientDataSet do
              begin
//                if XmlStrToInt(eFedasNode.ChildValues['Active']) <> 0 then
//                begin
                  Append;
                  FieldByName('LVL1ID').AsInteger := XmlStrToInt(eProductCategoryNode.ChildValues['Id']);
                  FieldByName('LVL2ID').AsInteger := XmlStrToInt(eActivityCodeNode.ChildValues['Id']);
                  FieldByName('LVL3ID').AsInteger := XmlStrToInt(eItemGroupNode.ChildValues['Id']);
                  FieldByName('Code').AsInteger   := XmlStrToInt(eFedasNode.ChildValues['Code']);
                  FieldByName('Msr').AsString    := XmlStrToStr(eFedasNode.ChildValues['Msr']);
                  FieldByName('Denotation').AsString := XmlStrToStr(eFedasNode.ChildValues['Denotation']);
                  FieldByName('Active').AsInteger    := XmlStrToInt(eFedasNode.ChildValues['Active']);
                  Post;
//                end;
              end;
              eFedasNode := eFedasNode.NextSibling;
            end;
            eItemGroupNode := eItemGroupNode.NextSibling;
          end;
          eActivityCodeNode := eActivityCodeNode.NextSibling;
        end;
        eProductCategoryNode := eProductCategoryNode.NextSibling;
      end;
    Except on E:Exception do
      raise Exception.Create('Import ' + FTitle + ' -> ' + E.Message);
    end;
  finally
    Xml := Nil;
  end;
end;

end.
