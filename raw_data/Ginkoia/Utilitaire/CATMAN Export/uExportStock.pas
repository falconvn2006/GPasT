unit uExportStock;

interface

uses CMELMain_DM, uDefs, Sysutils, Variants, Db, Forms,uHeaderCsv;

  function GenerateExportStock : Boolean;

  function ExecuteExportStock (BasePath,MAG_CODE, MAG_NOM : String;MAG_ID : Integer) : Boolean;

implementation


function ExecuteExportStock (BasePath,MAG_CODE, MAG_NOM : String;MAG_ID : Integer) : Boolean;
var
  Header : TExportHeaderOL;
  iEtat  : Integer;
  dDateTraitement : TDateTime;
  sFileName : String;
  iMagId : Integer;
  GEN_ID : Integer;
begin
  Result := False;
  dDateTraitement := Now;
  Header := TExportHeaderOL.Create;
  With DM_CMEL do
  try
    Memo.Clear;
    Header.Add('SourceSystemCode',8);
    Header.Add('SourceSystemStoreId',15);
    Header.Add('Date',8);
    Header.Add('EANCode',13);
    Header.Add('Quantity',4,alRight,fmInteger);
    // On veut que les données soit aligner par rapport aux tailles définies
    Header.bAlign := True;

    MemD_Stock.Close;
    MemD_Stock.Open;

    try
      // Initialisation de la base ginkoia en ModeStock (Ouverture/régénération stock/Drop procedure/Create procedure)
      InitGinkoiaDB(BasePath,MODESTOCK);

      // récupère le dernier GENERAL_ID de la base de données en cours
      Gen_ID := GetLastGenID;

      iMagId := FindMagID(MAG_CODE);
      // Traitement des articles LEVIS
      AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Récupération des données article');

      aQue_Levis_T1.First;
      while not aQue_Levis_T1.EOF do
      begin
        // exécution de la procédure stockée
        With Que_Stock do
        begin
          Close;
          ParamCheck := True;
          ParamByName('PEAN').AsString    := aQue_Levis_T1.FieldByName('LEV_EAN').AsString;
          ParamByName('PMAGID').AsInteger := iMagId;
          ParamByName('PDATE').AsDate     := dDateTraitement;
          Open;
          // transfert des données dans le MemData
          if RecordCount > 0 then
          begin
            while not EOF do
            begin
              if MemD_Stock.Locate('SourceSystemStoreId;EANCode',VarArrayOf([MAG_CODE,aQue_Levis_T1.FieldByName('LEV_EAN').AsString]),[loCaseInsensitive]) then
              begin
                MemD_Stock.Edit;
                MemD_Stock.FieldByName('Quantity').AsFloat := MemD_Stock.FieldByName('Quantity').AsFloat + FieldByName('HST_QTE').AsFloat;
              end
              else begin
                MemD_Stock.Append;
                MemD_Stock.FieldByName('SourceSystemCode').AsString    := 'LC';
                MemD_Stock.FieldByName('SourceSystemStoreId').AsString := MAG_CODE;
                MemD_Stock.FieldByName('Date').AsString                := FormatDateTime('DDMMYYYY',Now); // FieldByName('HST_DATE').AsDateTime);
                MemD_Stock.FieldByName('EANCode').AsString             := aQue_Levis_T1.FieldByName('LEV_EAN').AsString;
                MemD_Stock.FieldByName('Quantity').AsFloat             := FieldByName('HST_QTE').AsFloat;
              end;
              MemD_Stock.Post;
              Next;
            end; // while
          end; // if
        end; // with
        aQue_Levis_T1.Next;
        ProgBarArticle.Position :=  aQue_Levis_T1.RecNo * 100 Div  aQue_Levis_T1.RecordCount;
        Application.ProcessMessages;
      end; // while

      // suppression des lignes avec une Qte à 0
      With MemD_Stock do
      begin
        First;
        while not EOF do
          if FieldByName('Quantity').AsFloat = 0 then
            Delete
          else
            Next;
      end;

      // Convertion en CSV
      iEtat := CETATOK;
      if MemD_Stock.RecordCount > 0 then
      begin
        sFileName := 'INVRPT_SPORT2000_' + MAG_CODE + FormatDateTime('_YYYYMMDD_hhmmss',dDateTraitement) + '.dat';

        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Génération du fichier CSV');
        Header.ConvertToCsv(MemD_Stock,GPATHSAVE + sFileName);
        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Fichier créé : ' + sFileName);
        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Nombre de lignes : ' + IntToStr(MemD_Stock.RecordCount));

        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Transfert du fichier sur FTP');
        if SendFileToFTP(GPATHSAVE + sFileName) then
        begin
          AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Transfert OK');

//          if not MainCFG.Debug then
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
        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Export Stock -> ' + E.Message);
        iEtat := CETATKO;
      end;
    end;// with
  finally
    SaveHistoLevis(MAG_ID,CTYPESTOCK,iEtat,GEN_ID);
    SaveMemo(MAG_CODE,MODESTOCK);
    Header.Free;
  end;
end;

function GenerateExportStock : Boolean;
begin
  With DM_CMEL do
    with aQue_MagList do
    begin
      First;

      if MainCFG.Debug then
      begin
        ExecuteExportStock(GBASEPATHDEBUG,MainCFG.DebugMagCode,FieldByName('MAG_NOM').AsString,MainCFG.DebugMagID);
        Exit;
      end;

      while not EOF do
      begin
        ExecuteExportStock(FieldByName('MAG_CHEMINBASE').AsString,FieldByName('MAG_CODE').AsString,FieldByName('MAG_NOM').AsString,FieldByName('MAG_ID').AsInteger);
        Next;
        ProgBarClient.Position := RecNo * 100 Div RecordCount;
        Application.ProcessMessages;
      end;
    end;
end;


end.
