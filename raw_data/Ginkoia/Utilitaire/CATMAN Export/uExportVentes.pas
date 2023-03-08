unit uExportVentes;

interface

uses CMELMain_DM, uDefs, Sysutils, Variants, Db, Forms, uHeaderCsv;

  function GenerateExportVente : Boolean;

  function ExecuteExportVente (BasePath,MAG_CODE,MAG_NOM : String;MAG_ID : Integer) : Boolean;

  function AddToMemVente(SourceSystemCode,SourceSystemStoreId,EANCode : String;dDate : TDateTime;Quantity, Amount,VAT : single) : Boolean;

implementation

function GenerateExportVente : Boolean;
begin
  With DM_CMEL do
    with aQue_MagList do
    begin
      First;

      if MainCFG.Debug then
      begin
        ExecuteExportVente(GBASEPATHDEBUG,MainCFG.DebugMagCode,FieldByName('MAG_NOM').AsString,MainCFG.DebugMagID);
        Exit;
      end;

      while not EOF do
      begin
        ExecuteExportVente(FieldByName('MAG_CHEMINBASE').AsString,FieldByName('MAG_CODE').AsString,FieldByName('MAG_NOM').AsString,FieldByName('MAG_ID').AsInteger);
        Next;
        ProgBarClient.Position := RecNo * 100 Div RecordCount;
        Application.ProcessMessages;
      end;
    end;
end;

function AddToMemVente(SourceSystemCode,SourceSystemStoreId,EANCode : String;dDate : TDateTime; Quantity, Amount,VAT : single) : Boolean;
var
  iType : integer;
begin
  With DM_CMEL do
  begin
    if Amount < 0 then
      iType := 2
    else
      iType := 1;

    if MemD_Ventes.Locate('Date;EANCode;Type',VarArrayOf([FormatDateTime('DDMMYYYY',dDate),EANCode,iType]),[loCaseInsensitive]) then
    begin
      MemD_Ventes.Edit;
      MemD_Ventes.FieldByName('Quantity').AsFloat := MemD_Ventes.FieldByName('Quantity').AsFloat + Quantity;
      MemD_Ventes.FieldByName('Amount').AsFloat   := MemD_Ventes.FieldByName('Amount').AsFloat + (Quantity * Amount);
      MemD_Ventes.FieldByName('VAT').AsFloat      := MemD_Ventes.FieldByName('VAT').AsFloat + (Amount *  VAT / 100);
    end
    else begin
      MemD_Ventes.Append;
      MemD_Ventes.FieldByName('SourceSystemCode').AsString    := SourceSystemCode;
      MemD_Ventes.FieldByName('SourceSystemStoreId').AsString := SourceSystemStoreId;
      MemD_Ventes.FieldByName('Date').AsString                := FormatDateTime('DDMMYYYY',dDate);
      MemD_Ventes.FieldByName('Type').AsInteger               := iType;
      MemD_Ventes.FieldByName('EANCode').AsString             := EANCode;
      MemD_Ventes.FieldByName('Quantity').AsFloat             := Quantity;
      MemD_Ventes.FieldByName('Amount').AsFloat               := (Quantity * Amount);
      MemD_Ventes.FieldByName('VAT').AsFloat                  := Amount *  VAT / 100;
    end;
    MemD_Ventes.Post;
  end;
end;


function ExecuteExportVente (BasePath,MAG_CODE,MAG_NOM : String;MAG_ID : Integer) : Boolean;
var
  Header : TExportHeaderOL;
  iEtat  : Integer;
  dDateTraitement : TDateTime;
  sFileName : String;
  Kv : TKVersion;
  Gen_ID : Integer;
  iMagID : Integer;
begin
  dDateTraitement := Now;
  Header := TExportHeaderOL.Create;
  With DM_CMEL do
  try
    Header.Add('SourceSystemCode',8);
    Header.Add('SourceSystemStoreId',15);
    Header.Add('Date',8);
    Header.Add('Time',4,alLeft,fmEmpty);
    Header.Add('TransactionNumber',12,alLeft,fmEmpty);
    Header.Add('TillNumber',2,alLeft,fmEmpty);
    Header.Add('Type',1);
    Header.Add('EANCode',13);
    Header.Add('Quantity',3,alRight,fmInteger);
    Header.Add('Amount',12,alRight,fmFloat,'0.00','.');
    Header.Add('VAT',12,alRight,fmFloat,'0.00','.');
    Header.add('TicketPrice',12,alRight,fmEmpty);
    Header.bAlign := True;

    MemD_Ventes.Close;
    MemD_Ventes.Open;

    try
      // Initialisation de la base ginkoia en MODEVENTE
      InitGinkoiaDB(BasePath,MODEVENTE);

      // récupère le dernier GENERAL_ID de la base de données en cours
      Gen_ID := GetLastGenID;

      Kv := GetLastHistoLevis(MAG_ID,CTYPEVENTE);
      // Récupération du magid ginkoia
      iMagID := FindMagID(MAG_CODE);
      // Traitement des articles LEVIS
      AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Récupération des données article');

      aQue_Levis_T1.First;
      while not aQue_Levis_T1.Eof do
      begin
        With Que_Ventes do
        begin
          Close;
          ParamCheck := True;
          ParamByName('PCB1').AsString        :=  aQue_Levis_T1.FieldByName('LEV_EAN').AsString;
          ParamByName('PMAGID1').AsInteger    :=  iMagID;
          ParamByName('PKVE1Debut').AsInteger := KV.IdKvTicket;
          ParamByName('PKVE1Fin').AsInteger   := Gen_ID;
          ParamByName('PCB2').AsString        :=  aQue_Levis_T1.FieldByName('LEV_EAN').AsString;
          ParamByName('PMAGID2').AsInteger    :=  iMagID;
          ParamByName('PKVE2Debut').AsInteger := KV.IdKvBL;
          ParamByName('PKVE2Fin').AsInteger   := Gen_ID;
          ParamByName('PCB3').AsString        :=  aQue_Levis_T1.FieldByName('LEV_EAN').AsString;
          ParamByName('PMAGID3').AsInteger    :=  iMagID;
          ParamByName('PKVE3Debut').AsInteger := KV.IdKvFact;
          ParamByName('PKVE3Fin').AsInteger   := Gen_ID;
          Open;

          if MainCFG.Debug then
            AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Article : ' + aQue_Levis_T1.FieldByName('LEV_EAN').AsString + ' Lignes : ' + IntToStr(Recordcount));

          while not EOF do
          begin
            AddToMemVente(
                          'LC',
                          MAG_CODE,
                          aQue_Levis_T1.FieldByName('LEV_EAN').AsString,
                          FieldByName('DATECOM').AsDateTime,
                          FieldByName('QTE').AsFloat,
                          FieldByName('PXNN').AsFloat,
                          FieldByName('TVA').AsFloat
                         );
            Next;
          end;
        end;

        aQue_Levis_T1.Next;
        ProgBarArticle.Position :=  aQue_Levis_T1.RecNo * 100 Div  aQue_Levis_T1.RecordCount;
        Application.ProcessMessages;
      end;

      // Convertion en CSV
      iEtat := CETATOK;

      if MemD_Ventes.RecordCount > 0 then
      begin
        sFileName := 'TILTRA_SPORT2000_' + MAG_CODE + FormatDateTime('_YYYYMMDD_hhmmss',dDateTraitement) + '.dat';

        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Génération du fichier CSV');
        Header.ConvertToCsv(MemD_Ventes,GPATHSAVE + sFileName);
        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Fichier créé : ' + sFileName);
        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Nombre de lignes : ' + IntToStr(MemD_Ventes.RecordCount));

        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Transfert du fichier sur FTP');
        if SendFileToFTP(GPATHSAVE + sFileName) then
        begin
          AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Transfert OK');

//        if not MainCFG.Debug then
          if ArchiveFile(GPATHSAVE + sFileName) then
            AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Archivage du fichier OK');
        end
        else
          iEtat := CETATKO;
      end
      else
        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Pas de données pour le magasin');


      Result := True;
    Except on E:Exception do
      begin
        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' Export Vente -> ' + E.Message);
        iEtat := CETATKO;
      end;
    end;// with
  finally
    AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - SaveHisto');
    SaveHistoLevis(MAG_ID,CTYPEVENTE,iEtat, GEN_ID);
    AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - SaveMemo');
    SaveMemo(MAG_CODE,MODEVENTE);
    Header.Free;
  end;
end;



end.
