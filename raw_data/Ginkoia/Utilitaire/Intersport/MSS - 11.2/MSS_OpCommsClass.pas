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
  public
    procedure Import;override;
    function DoMajTable(ADoMaj : Boolean) : Boolean;override;

    constructor Create;override;
    destructor destroy;override;
  published
    property ItemListOpCode : TMainClass read FItemListOpCode;
    property ItemListOpDepliant : TMainClass read FItemListOpDepliant;
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
end;

destructor TOpComms.destroy;
begin
  FItemListOpCode.Free;
  FItemListOpDepliant.Free;
  inherited;
end;

function TOpComms.DoMajTable(ADoMaj: Boolean): Boolean;
var
  TYP_ID, FAjout, FMaj, OCT_ID : Integer;
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
    With FStpQuery do
    begin
      Close;
      StoredProcName := 'MSS_OCTETE';
      ParamCheck := True;
      ParamByName('OCTNOM').AsString     := FCds.FieldByName('Denotation').AsString;
      ParamByName('OCTCOMMENT').AsString := '';
      ParamByName('OCTDEBUT').AsDate     := FCds.FieldByName('DateFrom').AsDateTime;
      ParamByName('OCTFIN').AsDate       := FCds.FieldByName('Dateto').AsDateTime;
      ParamByName('OCTTYPID').AsInteger  := TYP_ID;
      ParamByName('OCTCENTRALE').AsInteger  := 1;
      ParamByName('OCTCODE').AsString       := FCds.FieldByName('Code').AsString + FCds.FieldByName('OpDepliantCode').AsString;
      Open;

      if RecordCount > 0 then
      begin
        FAjout := FieldByName('FAjout').AsInteger;
        FMaj := FieldByName('FMaj').AsInteger;
        OCT_ID := FieldByName('OCT_ID').AsInteger;
        Inc(FInsertCount,FAjout);
      end;
    end; // with
    FCds.Edit;
    FCds.FieldByName('OCT_ID').AsInteger := OCT_ID;
    FCDs.Post;

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
                With FStpQuery do
                begin
                  Close;
                  StoredProcName := 'MSS_OCLIGNE';
                  ParamCheck := True;
                  ParamByName('OCT_ID').AsInteger     := OCT_ID;
                  ParamByName('OCL_PXVTE').AsCurrency := PVTE;
                  ParamByName('OCD_ARTID').AsInteger  := ART_ID;
                  ParamByName('OCD_COUID').AsInteger  := COU_ID;
                  ParamByName('OCD_TGFID').AsInteger  := TGF_ID;
                  ParamByName('OCD_PRIX').AsCurrency  := FItemListOpCode.FieldByName('Opsalprc').AsCurrency;
                  ParamByName('OCD_ACTIVE').AsInteger := 1;
                  Open;
                  if RecordCount > 0 then
                  begin
                    FAjout := FieldByName('FAjout').AsInteger;
                    FMaj   := FieldByName('FMAJ').AsInteger;
                    Inc(FInsertCount,FAjout);
                    Inc(FMajCount,FMaj);
                  end;
                end; // with

            end; // if

          Except on E:Exception do
            FErrLogs.Add('OC -> ' + E.Message);
          end; // try
        end; // if

        FItemListOpDepliant.Next;
      end; // while
//    end; // if

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
  Idx.FieldType       := ftInteger;
  FItemListOpCode.CreateField([Code,Itemno,Opsalprc, ModCode, BrandNo, ColorCode, Idx]);

  Pageop.FieldName := 'Pageop';
  Pageop.FieldType := ftInteger;
  FItemListOpDepliant.CreateField([code,OpDepliantCode,Itemno,Pageop]);

  // geston du Xml
  Xml := TXMLDocument.Create(nil);
  try
    try
      Xml.LoadFromFile(FPath + FTitle + '.xml');
      nXmlBase := Xml.DocumentElement;
      eOpCodeListNode := nXmlBase.ChildNodes.FindNode('Opcodelist');
      eOpCodeNode     := eOpCodeListNode.ChildNodes.FindNode('Opcode');

      while eOpCodeNode <> nil do
      begin
        if DateOf(XmlStrToDate(eOpCodeNode.ChildValues['Dateto'])) >= DateOf(Now) then
        begin
          eOpDepliantListNode := eOpCodeNode.ChildNodes.FindNode('Opdepliantlist');
          eOpDepliantNode     := eOpDepliantListNode.ChildNodes.FindNode('Opdepliant');
          eOpCodeItemList := eOpCodeNode.ChildNodes.FindNode('Itemlist');
          eOpCodeItemNode := eOpCodeItemList.ChildNodes.FindNode('Item');

          while (eOpDepliantNode <> nil) and (eOpCodeItemList.ChildNodes.Count > 0) do
          begin
            Fcds.Append;
            FCds.FieldByName('Code').AsString := XmlStrToStr(eOpCodeNode.ChildValues['Code']);
            FCds.FieldByName('Datefrom').AsDateTime := XmlStrToDate(eOpCodeNode.ChildValues['Datefrom']);
            FCds.FieldByName('Dateto').AsDateTime   := XmlStrToDate(eOpCodeNode.ChildValues['Dateto']);
            FCds.FieldByName('Opdepliantcode').AsString := XmlStrToStr(eOpDepliantNode.ChildValues['Opdepliantcode']);
            FCds.FieldByName('Denotation').AsString     := XmlStrToStr(eOpDepliantNode.ChildValues['Denotation']);
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
              FItemListOpCode.FieldByName('Idx').AsInteger    := XmlStrToInt(eOpCodeItemNode.ChildValues['Idx']);
              FItemListOpCode.ClientDataSet.Post;
              eOpCodeItemNode := eOpCodeItemNode.NextSibling;
            end;

            eOpDepliantItemListNode := eOpDepliantNode.ChildNodes['Itemlist'];
            if eOpDepliantItemListNode <> nil then
              eOpDepliantItemNode := eOpDepliantItemListNode.ChildNodes.FindNode('Item');
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
  end;
end;


end.
