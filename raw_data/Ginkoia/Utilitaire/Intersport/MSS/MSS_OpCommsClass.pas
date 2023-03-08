unit MSS_OpCommsClass;

interface

uses MSS_MainClass, DBClient, MidasLib, Db, Classes, SysUtils, xmldom, XMLIntf,
     msxmldom, XMLDoc, Variants, DateUtils, IBODataset, Forms, ComCtrls, MSS_Type;

type
  TOpCommsStruct = packed record
    case Integer of
      0: (ItemNo : String[25]);
      1: (
        LenAdr : Byte;
        Modele : array[0..16] of Ansichar;
        Marque : array[0..2] of Ansichar;
        Couleur : array[0..2] of Ansichar;
        Columnx : array[0..1] of Ansichar;
      );
  end;

  TOpComms = Class(TMainClass)
  private
    FItemListOpCode : TMainClass;
    FItemListOpDepliant : TMainClass;
    FOCLIGNE,
    FOCDETAIL : TMainClass;

    FNewOC : TStringList;
  public
    procedure Import;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;

    constructor Create;override;
    destructor destroy;override;
  published
    property ItemListOpCode : TMainClass read FItemListOpCode;
    property ItemListOpDepliant : TMainClass read FItemListOpDepliant;

    property NewOC : TStringList read FNewOC;
  End;


implementation

{ TOpComms }

constructor TOpComms.Create;
begin
  inherited Create;

  FItemListOpCode := TMainClass.Create;
  FItemListOpCode.Title := 'ItemListOpCode';
  FItemListOpDepliant := TMainClass.Create;
  FItemListOpDepliant.Title := 'ItemListOpDepliant';

  FOCLIGNE := TMainClass.Create;
  FOCDETAIL := TMainClass.Create;

  FNewOC := TStringList.Create;
end;

destructor TOpComms.destroy;
begin
  FNewOC.Free;
  FItemListOpCode.Free;
  FItemListOpDepliant.Free;
  FOCLIGNE.Free;
  FOCDETAIL.Free;
  inherited;
end;

function TOpComms.DoMajTable(ADoMaj: Boolean): Boolean;
var
  TYP_ID, FAjout, FMaj, OCT_ID, OCD_ID, OCL_ID : Integer;
  OpComm : TOpCommsStruct;
  ART_ID, MRK_ID, COU_ID, TGF_ID : Integer;
  PVte : Currency;
begin
 //  exit; // FTH Pour le moment en attendant les réponses de Intersport

  // Récupération de l'ID vente promo
  TYP_ID := GetGenTypCDV(5,3);

  FCDs.First;
  while not FCDs.EOF do
  begin
    OCT_ID := -1;
    // Création de l'entête
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * from MSS_OCTETE(:POCTNOM, :POCTCOMMENT, :POCTDEBUT, :POCTFIN, :POCTTYPID, :POCTCENTRALE, :POCTCODE)');
      ParamCheck := True;
      ParamByName('POCTNOM').AsString     := FCds.FieldByName('Denotation').AsString;
      ParamByName('POCTCOMMENT').AsString := '';
      ParamByName('POCTDEBUT').AsDate     := FCds.FieldByName('DateFrom').AsDateTime;
      ParamByName('POCTFIN').AsDate       := FCds.FieldByName('Dateto').AsDateTime;
      ParamByName('POCTTYPID').AsInteger  := TYP_ID;
      ParamByName('POCTCENTRALE').AsInteger  := 1;
      ParamByName('POCTCODE').AsString       := FCds.FieldByName('Code').AsString + FCds.FieldByName('OpDepliantCode').AsString;
      Open;

      if RecordCount > 0 then
      begin
        FAjout := FieldByName('FAjout').AsInteger;
        FMaj := FieldByName('FMaj').AsInteger;
        OCT_ID := FieldByName('OCT_ID').AsInteger;
        Inc(FInsertCount,FAjout);

        if FAjout > 0 then
        begin
          FNewOC.Add('<tr>');
          FNewOC.Add('<td class="OC-LG">' + FCds.FieldByName('Denotation').AsString + '</td>');
          FNewOC.Add('</tr>');
        end;
      end;
    end; // with
    FCds.Edit;
    FCds.FieldByName('OCT_ID').AsInteger := OCT_ID;
    FCDs.Post;

    {$REGION 'Récupération des Informations concernant une OC'}
    With FIboQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select OCL_ID, OCD_ID from OCLIGNES');
      SQL.Add('  Join K on K_ID = OCL_ID and K_Enabled = 1');
      SQL.Add('  join OCDETAIL on OCL_ID = OCD_OCLID');
      SQL.Add('  join K on K_ID = OCD_ID and K_Enabled = 1');
      SQL.Add('Where OCL_OCTID = :POCTID');
      ParamCheck := true;
      ParamByName('POCTID').AsInteger := OCT_ID;
      Open;

      FOCLIGNE.ClientDataSet.EmptyDataSet;
      FOCDETAIL.ClientDataSet.EmptyDataSet;
      while not EOF do
      begin
        if not FOCLIGNE.ClientDataSet.Locate('OCL_ID',FieldByName('OCL_ID').AsInteger,[]) then
        begin
          FOCLIGNE.ClientDataSet.Append;
          FOCLIGNE.FieldByName('OCL_ID').AsInteger := FieldByName('OCL_ID').AsInteger;
          FOCLIGNE.FieldByName('Deleted').AsInteger := 1;
          FOCLIGNE.ClientDataSet.Post;
        end;

        FOCDETAIL.ClientDataSet.Append;
        FOCDETAIL.FieldByName('OCL_ID').AsInteger := FieldByName('OCL_ID').AsInteger;
        FOCDETAIL.FieldByName('OCD_ID').AsInteger := FieldByName('OCD_ID').AsInteger;
        FOCDETAIL.FieldByName('Deleted').AsInteger := 1;
        FOCDETAIL.ClientDataSet.Post;

        Next;
      end;
    end;
    {$ENDREGION}

    // Création des lignes
//    if FAjout = 1 then
//    begin
    FItemListOpDepliant.First;
    if FItemListOpDepliant.ClientDataSet.Locate('Code;OpDepliantCode',VarArrayOf([FCds.FieldByName('Code').AsString,FCds.FieldByName('OpDepliantCode').AsString]),[loCaseInsensitive]) then
      while not FItemListOpDepliant.EOF do
      begin
        if (FItemListOpDepliant.FieldByName('Code').AsString = FCds.FieldByName('Code').AsString) and
           (FItemListOpDepliant.FieldByName('OpDepliantCode').AsString = FCds.FieldByName('OpDepliantCode').AsString) then
        begin
          OpComm.ItemNo := StringOfChar(' ',SizeOf(OpComm.ItemNo) - Length(FItemListOpDepliant.FieldByName('Itemno').AsString) - 1) + FItemListOpDepliant.FieldByName('Itemno').AsString;
          try
            if not FItemListOpCode.ClientDataSet.Locate('code;Itemno',VarArrayOf([FItemListOpDepliant.FieldByName('Code').AsString,
                                                                                  FItemListOpDepliant.FieldByName('Itemno').AsString]),[loCaseInsensitive]) then
              raise Exception.Create('Tarif non trouvé : ' + Trim(OpComm.ItemNo));

            // récupération de l'ART_ID et du TGF_ID
            TGF_ID := GetIDFromTable('PLXTAILLESGF','TGF_CODE',FItemListOpCode.FieldByName('Idx').AsString,'TGF_ID');
            ART_ID := GetIDFromTable('ARTARTICLE','ART_CODE',FItemListOpCode.FieldByName('ModCode').AsString + FItemListOpCode.FieldByName('Brandno').AsString,'ART_ID');
            if (ART_ID <> -1) and (TGF_ID <> -1) then
            begin
              // Récupération du COU_ID
              With FIboQuery do
              begin
                Close;
                SQL.Clear;
                SQL.Add('Select COU_ID from PLXCOULEUR');
                SQL.Add('  join K on K_ID = COU_ID and K_Enabled = 1');
                SQL.Add('Where COU_ARTID = :PARTID');
                SQL.Add('  and Upper(COU_CODE) = Upper(:PCOUCODE)');
                ParamCheck := True;
                ParamByName('PARTID').AsInteger  := ART_ID;
                ParamByName('PCOUCODE').AsString := FItemListOpCode.FieldByName('ColorCode').AsString;
                Open;
                COU_ID := -1;
                if RecordCount > 0 then
                  COU_ID := FieldByName('COU_ID').AsInteger;
              end;

              // Récupération du Prix de vente de l'article
              With FIboQuery do
              begin
                Close;
                SQL.Clear;
                SQL.Add('Select PVT_PX from TARPRIXVENTE');
                SQL.Add('  join K on K_ID = PVT_Id and K_Enabled = 1');
                SQL.Add('Where PVT_ARTID = :PARTID');
                SQL.Add('  and PVT_TVTID = 0');
                SQL.Add('  and PVT_TGFID = 0');
                ParamCheck := True;
                ParamByName('PARTID').AsInteger := ART_ID;
                Open;

                PVTE := FieldByName('PVT_PX').AsCurrency;
              end;

              if COU_ID <> -1 then
                With FIboQuery do
                begin
                  Close;
                  SQL.Clear;
                  SQL.Add('Select * from MSS_OCLIGNE(:POCT_ID, :POCL_PXVTE, :POCD_ARTID, :POCD_TGFID, :POCD_COUID, :POCD_PRIX, :POCD_ACTIVE)');
                  ParamCheck := True;
                  ParamByName('POCT_ID').AsInteger     := OCT_ID;
                  ParamByName('POCL_PXVTE').AsCurrency := PVTE;
                  ParamByName('POCD_ARTID').AsInteger  := ART_ID;
                  ParamByName('POCD_COUID').AsInteger  := COU_ID;
                  ParamByName('POCD_TGFID').AsInteger  := TGF_ID;
                  ParamByName('POCD_PRIX').AsCurrency  := FItemListOpCode.FieldByName('Opsalprc').AsCurrency;
                  ParamByName('POCD_ACTIVE').AsInteger := 1;
                  Open;
                  if RecordCount > 0 then
                  begin
                    OCD_ID := FieldByName('OCD_ID').AsInteger;
                    OCL_ID := FieldByName('OCL_ID').AsInteger;
                    FAjout := FieldByName('FAjout').AsInteger;
                    FMaj   := FieldByName('FMAJ').AsInteger;
                    Inc(FInsertCount,FAjout);
                    Inc(FMajCount,FMaj);

                    if FOCDETAIL.ClientDataSet.Locate('OCL_ID;OCD_ID',VarArrayOf([OCL_ID,OCD_ID]),[]) then
                    begin
                      FOCDETAIL.ClientDataSet.Edit;
                      FOCDETAIL.FieldByName('Deleted').AsInteger := 0;
                      FOCDETAIL.ClientDataSet.Post;

                      if FOCLIGNE.ClientDataSet.Locate('OCL_ID;Deleted',VarArrayOf([OCL_ID,1]),[]) then
                      begin
                        FOCLIGNE.ClientDataSet.Edit;
                        FOCLIGNE.FieldByName('Deleted').AsInteger := 0;
                        FOCLIGNE.ClientDataSet.Post;
                      end;
                    end;
                  end;
                end; // with

            end; // if

          Except on E:Exception do
            FErrLogs.Add('OC -> ' + E.Message);
          end; // try
        end; // if

        FItemListOpDepliant.Next;
        Application.ProcessMessages;
      end; // while
//    end; // if

      // supression des lignes d'OC n'existant plus dans les fichiers
      FOCDETAIL.First;
      while not FOCDETAIL.EOF do
      begin
        if FOCDETAIL.FieldByName('Deleted').AsInteger = 1 then
          With FIboQuery do
          begin
            Close;
            SQL.Clear;
            SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:PID,1)');
            ParamCheck := True;
            ParamByName('PID').AsInteger := FOCDETAIL.FieldByName('OCD_ID').AsInteger;
            ExecSQL;
          end;
        FOCDETAIL.Next;
      end;

      FOCLIGNE.First;
      while not FOCLIGNE.EOF do
      begin
        if FOCLIGNE.FieldByName('Deleted').AsInteger = 1 then
          With FIboQuery do
          begin
            Close;
            SQL.Clear;
            SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:PID,1)');
            ParamCheck := True;
            ParamByName('PID').AsInteger := FOCLIGNE.FieldByName('OCL_ID').AsInteger;
            ExecSQL;
          end;
        FOCLIGNE.Next;
      end;


    Next;
    if Assigned(FProgressBar) then
      FProgressBar.Position := FCds.RecNo * 100 Div FCds.RecordCount;
    Application.ProcessMessages;
  end;
end;

procedure TOpComms.Import;
var
  Xml : IXMLDocument;
  nXmlBase ,
  eOpCodeListNode,
  eOpCodeNode,
  eOpDepliantListNode,
  eOpCodeItemList,
  eOpCodeItemNode,
  eOpDepliantNode,
  eOpDepliantItemListNode,
  eOpDepliantItemNode : IXMLNode;

  Code, DateFrom, DateTo, OpDepliantCode, Denotation, OTCID : TFieldCFG;
  {code,} Itemno, Opsalprc, ModCode, BrandNo, ColorCode, Idx : TFieldCFG;
  {code,OpDepliantCode,Itemno,}Pageop : TFieldCFG;
  OCL_ID, OCD_ID, Deleted : TFieldCfg;
  bValid : Boolean;
begin
  // Définition du champs du Dataset
  Code.FieldName := 'Code';
  Code.FieldType := ftString;
  DateFrom.FieldName := 'DateFrom';
  DateFrom.FieldType := ftDate;
  DateTo.FieldName   := 'Dateto';
  DateTo.FieldType   := ftDate;
  OpDepliantCode.FieldName := 'OpDepliantCode';
  OpDepliantCode.FieldType := ftString;
  Denotation.FieldName     := 'Denotation';
  Denotation.FieldType     := ftString;
  OTCID.FieldName          := 'OCT_ID';
  OTCID.FieldType          := ftInteger;
  // Création des champs
  FFieldNameID := 'OCT_ID';
  CreateField([Code, DateFrom, DateTo, OpDepliantCode, Denotation, OTCID]);

  Itemno.FieldName := 'Itemno';
  Itemno.FieldType := ftString;
  Opsalprc.FieldName := 'Opsalprc';
  Opsalprc.FieldType := ftCurrency;
  ModCode.FieldName := 'Modcode';
  ModCode.FieldType := ftString;
  BrandNo.FieldName := 'Brandno';
  BrandNo.FieldType := ftString;
  ColorCode.FieldName := 'Colorcode';
  ColorCode.FieldType := ftString;
  Idx.FieldName       := 'Idx';
  Idx.FieldType       := ftString;
  FItemListOpCode.CreateField([Code,Itemno,Opsalprc, ModCode, BrandNo, ColorCode, Idx]);

  Pageop.FieldName := 'Pageop';
  Pageop.FieldType := ftInteger;
  FItemListOpDepliant.CreateField([code,OpDepliantCode,Itemno,Pageop]);

  // Permet la gestion des ajouts/disparition des lignes d'OC
  OCL_ID.FieldName := 'OCL_ID';
  OCL_ID.FieldType := ftInteger;
  OCD_ID.FieldName := 'OCD_ID';
  OCD_ID.FieldType := ftInteger;
  Deleted.FieldName:= 'Deleted';
  Deleted.FieldType:= ftInteger;
  FOCLIGNE.CreateField([OCL_ID, Deleted]);
  FOCDETAIL.CreateField([OCL_ID, OCD_ID, Deleted]);

  // geston du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;
      eOpCodeListNode := nXmlBase.ChildNodes.FindNode('Opcodelist');
      eOpCodeNode     := eOpCodeListNode.ChildNodes['Opcode'];

      while eOpCodeNode <> nil do
      begin
        if DateOf(XmlStrToDate(eOpCodeNode.ChildValues['Dateto'])) >= DateOf(Now) then
        begin
          eOpDepliantListNode := eOpCodeNode.ChildNodes['Opdepliantlist'];
          eOpDepliantNode     := eOpDepliantListNode.ChildNodes['Opdepliant'];
          eOpCodeItemList := eOpCodeNode.ChildNodes['Itemlist'];
          eOpCodeItemNode := eOpCodeItemList.ChildNodes['Item'];

          while (eOpDepliantNode <> nil) and (eOpCodeItemList.ChildNodes.Count > 0) do
          begin
            Fcds.Append;
            FCds.FieldByName('Code').AsString := XmlStrToStr(eOpCodeNode.ChildValues['Code']);
            FCds.FieldByName('Datefrom').AsDateTime := XmlStrToDate(eOpCodeNode.ChildValues['Datefrom']);
            FCds.FieldByName('Dateto').AsDateTime   := XmlStrToDate(eOpCodeNode.ChildValues['Dateto']);
            FCds.FieldByName('Opdepliantcode').AsString := XmlStrToStr(eOpDepliantNode.ChildValues['Opdepliantcode']);
            FCds.FieldByName('Denotation').AsString     := XmlStrToStr(eOpCodeNode.ChildValues['Denotation']) + ' - ' +
                                                           XmlStrToStr(eOpDepliantNode.ChildValues['Denotation']);
            FCds.Post;

            while eOpCodeItemNode <> nil do
            begin
              FItemListOpCode.ClientDataSet.Append;
              FItemListOpCode.FieldByName('Code').AsString := XmlStrToStr(eOpCodeNode.ChildValues['Code']);
              FItemListOpCode.FieldByName('Itemno').AsString := XmlStrToStr(eOpCodeItemNode.ChildValues['Itemno']);
              FItemListOpCode.FieldByName('Opsalprc').AsCurrency := XmlStrToFloat(eOpCodeItemNode.ChildValues['Opsalprc']);
              FItemListOpCode.FieldByName('ModCode').AsString    := XmlStrToStr(eOpCodeItemNode.ChildValues['Modcode']);
              FItemListOpCode.FieldByName('Brandno').AsString    := XmlStrToStr(eOpCodeItemNode.ChildValues['Brandno']);
              FItemListOpCode.FieldByName('Colorcode').AsString    := XmlStrToStr(eOpCodeItemNode.ChildValues['Colorcode']);
              FItemListOpCode.FieldByName('Idx').AsString    := XmlStrToStr(eOpCodeItemNode.ChildValues['Idx']);
//              FItemListOpCode.FieldByName('Idx').AsInteger    := XmlStrToInt(eOpCodeItemNode.ChildValues['Idx']);
              FItemListOpCode.ClientDataSet.Post;
              eOpCodeItemNode := eOpCodeItemNode.NextSibling;
            end;

            eOpDepliantItemListNode := eOpDepliantNode.ChildNodes['Itemlist'];
            if eOpDepliantItemListNode <> nil then
              eOpDepliantItemNode := eOpDepliantItemListNode.ChildNodes['Item'];
            while eOpDepliantItemNode <> nil do
            begin
              FItemListOpDepliant.ClientDataSet.Append;
              FItemListOpDepliant.FieldByName('Code').AsString := XmlStrToStr(eOpCodeNode.ChildValues['Code']);
              FItemListOpDepliant.FieldByName('Opdepliantcode').AsString := XmlStrToStr(eOpDepliantNode.ChildValues['Opdepliantcode']);
              FItemListOpDepliant.FieldByName('Itemno').AsString := XmlStrToStr(eOpDepliantItemNode.ChildValues['Itemno']);
              FItemListOpDepliant.FieldByName('Pageop').AsInteger := XmlStrToInt(eOpDepliantItemNode.ChildValues['Pageop']);
              FItemListOpDepliant.ClientDataSet.Post;
              eOpDepliantItemNode := eOpDepliantItemNode.NextSibling;
            end;

            eOpDepliantNode := eOpDepliantNode.NextSibling;
          end;
        end;
        eOpCodeNode := eOpCodeNode.NextSibling;
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
