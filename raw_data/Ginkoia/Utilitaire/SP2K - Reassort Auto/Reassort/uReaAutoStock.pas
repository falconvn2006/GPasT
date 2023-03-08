unit uReaAutoStock;

interface

  uses ReaAutoMain_DM, uHeaderCsv, SysUtils, uDefs, Variants, Forms, Classes,uLog;

const
  CFILESTRUCT_S2K = 'INVRPT_%s_SPORT2000_%s_%s.dat';
  CFILESTRUCT_ISF = 'Inventaire%s.txt';

function DoTraitementSTK_S2K(AOnlyOneMag : Boolean = False; AMAG_ID : Integer = 0; ASaveInDB : Boolean = True; ASendToFTP : Boolean = True; AList : TStrings = nil) : Boolean;
function DoMemStockToCsv_S2K(sFileName : String) : Boolean;
function DoTraitementSTK_ISF(AOnlyOneMag : Boolean = False; AMAG_ID : Integer = 0; ASaveInDB : Boolean = True; ASendToFTP : Boolean = True; AList : TStrings = nil) : Boolean;
function DoMemStockToCsv_ISF(sFileName : String) : Boolean;

implementation

function DoMemStockToCsv_S2K(sFileName : String) : Boolean;
var
  Header : TExportHeaderOL;
begin
  With DM_ReaAuto do
  begin
    //if MemD_StockTemp.RecordCount > 0 then
    //begin
      Header := TExportHeaderOL.Create;
      try
        try
          Header.bWriteHeader := True;
          Header.Separator := ';';
          Header.bAlign := False;
          Header.Add('IdMagasin',6,alLeft,fmInteger);
          Header.Add('Date',0,alLeft,fmDate,'YYYYMMDD');
          Header.Add('NomMagasin',35);
          Header.Add('NomMarque',35);
          Header.Add('NomFournisseur',35);
          Header.Add('CodeArticle',35);
          Header.Add('Quantite',0,alLeft,fmInteger);
          if Header.ConvertToCsv(MemD_StockTemp_S2K,sFileName)=1 then
            AddToMemo('Création du fichier réussit : ' + sFileName)
          else if Header.ConvertToCsv(MemD_StockTemp_S2K,sFileName)=0 then
            AddToMemo('Aucune données à exporter dans le fichier : ' + sFileName)
          else
            AddToMemo('Echec de création du fichier : ' + sFileName);

        Except on E:Exception do
          raise Exception.Create('DoMemStockToCsv -> ' + E.Message);
        end;
      finally
        Header.Free;
      end; // try
    //end // if
    //else begin
    //  AddToMemo('Aucune données à exporter dans le fichier : ' + sFileName)
    //end;

  end; // with
end;

function DoTraitementSTK_S2K(AOnlyOneMag : Boolean = False; AMAG_ID : Integer = 0; ASaveInDB : Boolean = True; ASendToFTP : Boolean = True; AList : TStrings = nil) : Boolean;
var
  OldDir : String;
  MAG_ID, MRK_ID : Integer;
  FOU_NOM : String;
  dDateTraitement : TDateTime;
  sFileName : String;
  iEtat : Integer;
  iCountError : Integer;
  tmp : integer;
  GUID: String;
begin
  With DM_ReaAuto do
  Try
    // Init
    MemD_FTPToSend.Close;
    MemD_FTPToSend.Open;

    // Récupération de la liste des magasins à traiter
    With aQue_LstMag do
    begin
      First;
      OldDir := '';
      dDateTraitement := now;
      iCountError := 0;

      AddToMemo('---------------------');
      AddToMemo('Traitement des stocks');
      AddToMemo('---------------------');

      while not EOF do
      begin
        try
          // Mode pour exécuter 1 seul magasin
          if AOnlyOneMag then
          begin
            if AMAG_ID <> FieldByName('REM_MAGID').AsInteger then
            begin
              Next;
              Continue;
            end;
          end
          else
            // Limitation au chemin de la liste
            if Assigned(AList) then
              if not IsPathInList(FieldByName('MAG_CHEMINBASE').AsString,AList) then
              begin
                Next;
                Continue;
              end;

          // récupération des données de la marque
          aQue_lstMarque_S2K.Close;
          aQue_lstMarque_S2K.ParamCheck := True;
          aQue_lstMarque_S2K.Parameters.ParamByName('PMRKID').Value := FieldByName('REM_MRKID').AsInteger;
          aQue_lstMarque_S2K.Open;

          // A-t-on un marque à traiter ayant RAM_STK à 1 ?
          if aQue_lstMarque_S2K.FieldByName('RAM_STK').AsInteger = 1 then
          begin
            // Est ce que le chemin vers la base de données n'est pas vide ?
            if Trim(FieldByName('MAG_CHEMINBASE').AsString) <> '' then
            begin

              Log.Log('Main', 'Status', FieldByName('MAG_NOM').AsString + ' : Traitement des stocks' , logNotice, False) ;

              // Est ce que le chemin est court est différent de l'ancien chemin ?
              if Trim(OldDir) <> Trim(FieldByName('MAG_CHEMINBASE').AsString) then
              begin
                 AddToMemo('Base de données : ' + FieldByName('MAG_CHEMINBASE').AsString);
                 AddToMemo('Code Magasin : '+ FieldByName('MAG_CODE').AsString);

                // On ouvre la base de données que si le dernier chemin est différent
                InitGinkoiaDB(FieldByName('MAG_CHEMINBASE').AsString,mStock);
                iCountError := 0;
              end;

              try
                // Suppression de la procedure de recalcul des stocks
                //DeletePsStock;
                // Création de la procédure stockée de recalcul des stocks
                //CreatePSStock;

                // récupération de l'ID magasin
                MAG_ID := FindMagID(FieldByName('MAG_CODE').AsString);
                // récupération de l'Id Marque
                MRK_ID := FindMrkId(aQue_lstMarque_S2K.FieldByName('MRK_NOM').AsString);

                AddtoLabMag(FieldByName('MAG_CODE').AsString + ' - ' + FieldByName('MAG_NOM').AsString);
                AddToLabMrk(aQue_lstMarque_S2K.FieldByName('MRK_NOM').AsString);

                // On vide la table temporaire
                MemD_StockTemp_S2K.Close;
                MemD_StockTemp_S2K.Open;

                // si on a trouvé la marque
                if MRK_ID <> -1 then
                begin
                  // Récupération du GUID;
                  GUID := FindGUID( MAG_ID );

                  if Trim(GUID) <> '' then
                    Log.Log('', 'STOCK', 'SPORT2000', GUID {ref}, IntToStr(MAG_ID) {mag}, 'Traitement', 'En cours', logNotice, True, -1, ltServer);

//                  if not SameText( GUID, SysUtils.EmptyStr ) then
//                    TLogEngine.Notice( 'STOCK', 'SPORT2000', GUID, 'Traitement' );

                  // Récupération de la liste d'article à traiter pour cette marque
                  aQue_LstArt.Close;
                  aQue_LstArt.ParamCheck := True;
                  aQue_LstArt.Parameters.ParamByName('PMRKID').Value := aQue_lstMarque_S2K.FieldByName('MRK_ID').AsInteger;
                  aQue_LstArt.Open;

                  // Recalcul le stock et permet de continuer si l'article existe bien dans la base de données
                  While not aQue_LstArt.EOF do
                  begin
                    if ExecutePSStock(aQue_LstArt.FieldByName('REA_EAN').AsString,3) then
                    Begin
                      // Récupération de la quantité en stock
                      With Que_Tmp do
                      begin
                        Que_Tmp.Close;
                        Que_Tmp.SQL.Clear;
                        Que_Tmp.SQL.Add('Select * from TF_GETSTOCKFROMEANANDMRK(:PEAN,:PMRKID,:PMAGID,:PDATEHISTO)');
                        Que_Tmp.ParamCheck := True;
                        Que_Tmp.ParamByName('PEAN').AsString := aQue_LstArt.FieldByName('REA_EAN').AsString;
                        Que_Tmp.ParamByName('PMAGID').AsInteger := MAG_ID;
                        Que_Tmp.ParamByName('PMRKID').AsInteger := MRK_ID;
                        Que_Tmp.ParamByName('PDATEHISTO').AsDate := dDateTraitement;
                        Que_Tmp.Open;

                        while not EOF do
                        begin
                          If MemD_StockTemp_S2K.Locate('CodeArticle',aQue_LstArt.FieldByName('REA_EAN').AsString,[]) then
                          begin
                            MemD_StockTemp_S2K.Edit;
                            MemD_StockTemp_S2K.FieldByName('Quantite').AsInteger := MemD_StockTemp_S2K.FieldByName('Quantite').AsInteger +
                                                                                Que_Tmp.FieldByName('HST_QTE').AsInteger;
                          end
                          else begin
                            MemD_StockTemp_S2K.Append;
                            MemD_StockTemp_S2K.FieldByName('IDMagasin').AsString := aQue_LstMag.FieldByName('MAG_CODE').AsString;
                            MemD_StockTemp_S2K.FieldByName('DATE').AsDateTime := dDateTraitement;
                            MemD_StockTemp_S2K.FieldByName('NomMagasin').AsString := aQue_LstMag.FieldByName('MAG_NOM').AsString;
                            MemD_StockTemp_S2K.FieldByName('NomFournisseur').AsString := FindFourNom(MRK_ID);
                            MemD_StockTemp_S2K.FieldByName('NomMarque').AsString  := aQue_lstMarque_S2K.FieldByName('MRK_NOM').AsString;
                            MemD_StockTemp_S2K.FieldbyName('CodeArticle').AsString   := aQue_LstArt.FieldByName('REA_EAN').AsString;
                            MemD_StockTemp_S2K.FieldByName('Quantite').AsInteger := Que_Tmp.FieldByName('HST_QTE').AsInteger;
                          end;
                          MemD_StockTemp_S2K.Post;

                          Next;
                        end; // while

      //                  // Suppression des lignes avec 0 en quantité
      //                  MemD_StockTemp.First;
      //                  while not MemD_StockTemp.EOF do
      //                  begin
      //                    if MemD_StockTemp.FieldByName('Quantite').AsInteger = 0 then
      //                      MemD_StockTemp.Delete
      //                    else
      //                      MemD_StockTemp.Next;
      //                  end;
                      end;  //with
                    end;    //if
                    aQue_LstArt.Next;
                    if Assigned(ProgressMrk) then
                      ProgressMrk.Position := aQue_LstArt.RecNo * 100 Div aQue_LstArt.RecordCount;
                    Application.ProcessMessages;
                  end; // while

                  // Sauvegarde en CSV des données
                  sFileName := GDIRTOSEND + Format(CFILESTRUCT_S2K,[aQue_lstMarque_S2K.FieldByName('RAM_TRIGRAM').AsString,aQue_LstMag.FieldByName('MAG_CODE').AsString,FormatDateTime('YYYYMMDD_hhmmss',dDateTraitement)]);
                  DoMemStockToCsv_S2K(sFileName);

                  // Ajout à la liste de traitement FTP
                  //if MemD_StockTemp.RecordCount > 0 then
                  if ASendToFTP then
                    With MemD_FTPToSend do
                    begin
                      Append;
                      FieldByName('MAG_ID').AsInteger := aQue_LstMag.FieldByName('REM_MAGID').AsInteger;
                      FieldByName('MRK_ID').AsInteger := aQue_lstMarque_S2K.FieldByName('MRK_ID').AsInteger;
                      FieldByName('MAG_CODE').AsString := aQue_LstMag.FieldByName('MAG_CODE').AsString;
                      FieldByName('RAM_TRIGRAM').AsString := aQue_lstMarque_S2K.FieldByName('RAM_TRIGRAM').AsString;
                      FieldByName('FileName').AsString := sFileName;
                      FieldByName('FTPDir').AsString := aQue_lstMarque_S2K.FieldByName('RAM_REPFTP').AsString;
                      Post;
                      AddToTrace(FieldByName('MAG_ID').AsInteger,FieldByName('MRK_ID').AsInteger,ExtractFileName(sFileName),dDateTraitement);
                    end;

                  if ASaveInDB then
                    AddtoHisto(aQue_LstMag.FieldByName('REM_MAGID').AsInteger, aQue_lstMarque_S2K.FieldByName('MRK_ID').AsInteger,dDateTraitement,CETATOK,CTYPESTK,0,0,0);

                  if Trim(GUID) <> '' then
                    Log.Log('', 'STOCK', 'SPORT2000', GUID {ref}, IntToStr(MAG_ID) {mag}, 'Traitement', 'Terminé', logInfo, False, -1, ltServer);

//                  if not SameText( GUID, SysUtils.EmptyStr ) then
//                    TLogEngine.Info( 'STOCK', 'SPORT2000', GUID, 'Traitement' );
                end else
                  AddToMemo('--Marque Inexistante : ' + aQue_lstMarque_S2K.FieldByName('MRK_NOM').AsString);
              Except on E:Exception do
                begin
                  if Trim(GUID) <> '' then
                    Log.Log('', 'STOCK', 'SPORT2000', GUID {ref}, IntToStr(MAG_ID) {mag}, 'Traitement',E.Message, logError, False, -1, ltServer);

//                  if not SameText( GUID, SysUtils.EmptyStr ) then
//                    TLogEngine.Error( 'STOCK', 'SPORT2000', GUID, 'Traitement', E.Message );
                  if ASaveInDB then
                    AddtoHisto(aQue_LstMag.FieldByName('REM_MAGID').AsInteger, aQue_lstMarque_S2K.FieldByName('MRK_ID').AsInteger,dDateTraitement,CETATKO,CTYPESTK,0,0,0);
                  AddToMemo('-- ' + aQue_LstMag.FieldByName('MAG_CODE').AsString + '/' +
                            aQue_lstMarque_S2K.FieldByName('RAM_TRIGRAM').AsString + ' Erreur de traitement : ' + E.Message);
                end;
              end;

              OldDir := FieldByName('MAG_CHEMINBASE').AsString;
            end else
              AddTOMemo('--Chemin vers la base de données vide : ' + FieldByName('MAG_NOM').AsString);
          end;

        Except on E:Exception do
          begin
            Log.Log('Main', 'Status', FieldByName('MAG_NOM').AsString + ' : ' + E.Message , logError, False) ;
            AddToMemo('-- Erreur : ' + E.Message);
            inc(icountError);
          end;
        end;

        Next;

        if Assigned(ProgressMag) then
          ProgressMag.Position := RecNo * 100 Div RecordCount;
        Application.ProcessMessages;
      end; // while

      AddToMemo('Traitement terminé');
      AddToMemo('-------------------------------------------------------------');
    end;
  Except on E:Exception do
    raise Exception.Create('DoTraitementSTK -> ' + E.Message);
  end;
end;

function DoMemStockToCsv_ISF(sFileName : String) : Boolean;
var
  Header : TExportHeaderOL;
begin
  With DM_ReaAuto do
  begin
    Header := TExportHeaderOL.Create;
    try
      try
        Header.bWriteHeader := True;
        Header.Separator := ';';
        Header.bAlign := False;
        Header.Add('Expediteur',13);
        Header.Add('Destinataire',16);
        Header.Add('Type EDI INVRPT',6);
        Header.Add('ID Message',35);
        Header.Add('Type Date 1',3,alLeft,fmInteger);
        Header.Add('Date 1',0,alLeft,fmDate,'YYYYMMDD');
        Header.Add('Type Date 2',3,alLeft,fmInteger);
        Header.Add('Date 2',0,alLeft,fmDate,'YYYYMMDD');
        Header.Add('Type Date 3',3,alLeft,fmInteger);
        Header.Add('Date 3',0,alLeft,fmDate,'YYYYMMDD');
        Header.Add('Type Date 4',3,alLeft,fmInteger);
        Header.Add('Date 4',0,alLeft,fmDate,'YYYYMMDD');
        Header.Add('Type Partenaire 1',2);
        Header.Add('ID Partenaire 1',35);
        Header.Add('Nom Partenaire 1',35);
        Header.Add('Type Partenaire 2',2);
        Header.Add('ID Partenaire 2',35);
        Header.Add('Nom Partenaire 2',35);
        Header.Add('Ligne : ID Ligne',6,alLeft,fmInteger);
        Header.Add('Ligne : Code Article',35);
        Header.Add('Ligne : Quantite : Type Quantite',0,alLeft,fmInteger);
        Header.Add('Ligne : Quantite : Quantite',0,alLeft,fmInteger);
        Header.Add('Ligne : Quantite : ID Acheteur',35);
        Header.Add('Ligne : Quantite : Nom Acheteur',35);
        Header.Add('Ligne : Quantite : Type Lieu',3);
        Header.Add('Ligne : Quantite : Lieu',35);
        if Header.ConvertToCsv(MemD_StockTemp_ISF,sFileName)=1 then
          AddToMemo('Création du fichier réussit : ' + sFileName)
        else if Header.ConvertToCsv(MemD_StockTemp_ISF,sFileName)=0 then
          AddToMemo('Aucune données à exporter dans le fichier : ' + sFileName)
        else
          AddToMemo('Echec de création du fichier : ' + sFileName);

      Except on E:Exception do
        raise Exception.Create('DoMemStockToCsv -> ' + E.Message);
      end;
    finally
      Header.Free;
    end; // try
  end; // with
end;

function DoTraitementSTK_ISF(AOnlyOneMag : Boolean = False; AMAG_ID : Integer = 0; ASaveInDB : Boolean = True; ASendToFTP : Boolean = True; AList : TStrings = nil) : Boolean;
var
  OldDir : String;
  MAG_ID, MRK_ID : Integer;
  FOU_NOM : String;
  dDateTraitement : TDateTime;
  sFileName : String;
  iEtat : Integer;
  iCountError : Integer;
  iCountLigne : Integer;
  GUID: String;
begin
  With DM_ReaAuto do
  Try
    // Init
    MemD_FTPToSend.Close;
    MemD_FTPToSend.Open;

    // Récupération de la liste des magasins à traiter
    With aQue_LstMag do
    begin
      First;
      OldDir := '';
      dDateTraitement := now;
      iCountError := 0;
      iCountLigne := 0;

      AddToMemo('---------------------');
      AddToMemo('Traitement des stocks');
      AddToMemo('---------------------');

      while not EOF do
      begin
        try

          // Mode pour exécuter 1 seul magasin
          if AOnlyOneMag then
          begin
            if AMAG_ID <> FieldByName('REM_MAGID').AsInteger then
            begin
              Next;
              Continue;
            end;
          end
          else
            // Limitation au chemin de la liste
            if Assigned(AList) then
              if not IsPathInList(FieldByName('MAG_CHEMINBASE').AsString,AList) then
              begin
                Next;
                Continue;
              end;

          // récupération des données de la marque
          aQue_lstMarque_ISF.Close;
          aQue_lstMarque_ISF.ParamCheck := True;
          aQue_lstMarque_ISF.Parameters.ParamByName('PMRKID').Value := FieldByName('REM_MRKID').AsInteger;
          aQue_lstMarque_ISF.Open;

          // A-t-on un marque à traiter ayant RAM_STK à 1 ?
          if aQue_lstMarque_ISF.FieldByName('RAM_STK').AsInteger = 1 then
          begin
            // Est ce que le chemin vers la base de données n'est pas vide ?
            if Trim(FieldByName('MAG_CHEMINBASE').AsString) <> '' then
            begin

              Log.Log('Main', 'Status', FieldByName('MAG_NOM').AsString + ' : Traitement des stocks' , logNotice, False) ;

              // Est ce que le chemin est court est différent de l'ancien chemin ?
              if Trim(OldDir) <> Trim(FieldByName('MAG_CHEMINBASE').AsString) then
              begin
                 AddToMemo('Base de données : ' + FieldByName('MAG_CHEMINBASE').AsString);
                // On ouvre la base de données que si le dernier chemin est différent
                InitGinkoiaDB(FieldByName('MAG_CHEMINBASE').AsString,mStock);
                iCountError := 0;
              end;

              try
                // Suppression de la procedure de recalcul des stocks
                //DeletePsStock;
                // Création de la procédure stockée de recalcul des stocks
                //CreatePSStock;

                // récupération de l'ID magasin
                MAG_ID := FindMagID(FieldByName('MAG_CODE').AsString);
                // récupération de l'Id Marque
                MRK_ID := FindMrkId(aQue_lstMarque_ISF.FieldByName('MRK_NOM').AsString);
                // On vide la table temporaire
                MemD_StockTemp_ISF.Close;
                MemD_StockTemp_ISF.Open;

                // si on a trouvé la marque
                if MRK_ID <> -1 then
                begin
                  // Récupération du GUID;
                  GUID := FindGUID( MAG_ID );

                  if Trim(GUID) <> '' then
                    Log.Log('', 'STOCK', 'INTERSPORT', GUID {ref}, IntToStr(MAG_ID) {mag}, 'Traitement', 'En cours', logNotice, True, -1, ltServer);
//
//                  if not SameText( GUID, SysUtils.EmptyStr ) then
//                    TLogEngine.Notice( 'STOCK', 'INTERSPORT', GUID, 'Traitement' );

                  // Récupération de la liste d'article à traiter pour cette marque
                  aQue_LstArt.Close;
                  aQue_LstArt.ParamCheck := True;
                  aQue_LstArt.Parameters.ParamByName('PMRKID').Value := aQue_lstMarque_ISF.FieldByName('MRK_ID').AsInteger;
                  aQue_LstArt.Open;

                  // Recalcul le stock et permet de continuer si l'article existe bien dans la base de données
                  While not aQue_LstArt.EOF do
                  begin
                    if ExecutePSStock(aQue_LstArt.FieldByName('REA_EAN').AsString,3) then
                    begin
                      // Récupération de la quantité en stock
                      With Que_Tmp do
                      begin
                        Que_Tmp.Close;
                        Que_Tmp.SQL.Clear;
                        Que_Tmp.SQL.Add('Select * from TF_GETSTOCKFROMEANANDMRK(:PEAN,:PMRKID,:PMAGID,:PDATEHISTO)');
                        Que_Tmp.ParamCheck := True;
                        Que_Tmp.ParamByName('PEAN').AsString := aQue_LstArt.FieldByName('REA_EAN').AsString;
                        Que_Tmp.ParamByName('PMAGID').AsInteger := MAG_ID;
                        Que_Tmp.ParamByName('PMRKID').AsInteger := MRK_ID;
                        Que_Tmp.ParamByName('PDATEHISTO').AsDate := dDateTraitement;
                        Que_Tmp.Open;

                        while not EOF do
                        begin
                          If MemD_StockTemp_ISF.Locate('Ligne : Code Article',aQue_LstArt.FieldByName('REA_EAN').AsString,[]) then
                          begin
                            MemD_StockTemp_ISF.Edit;
                            MemD_StockTemp_ISF.FieldByName('Ligne : Quantite : Quantite').AsInteger := MemD_StockTemp_ISF.FieldByName('Ligne : Quantite : Quantite').AsInteger +
                                                                                Que_Tmp.FieldByName('HST_QTE').AsInteger;
                          end
                          else begin
                            inc(iCountLigne);
                            MemD_StockTemp_ISF.Append;
                            MemD_StockTemp_ISF.FieldByName('Expediteur').AsString := '3025816970108';
                            MemD_StockTemp_ISF.FieldByName('Destinataire').AsString := aQue_lstMarque_ISF.FieldByName('MRK_ILN').AsString;
                            MemD_StockTemp_ISF.FieldByName('Type EDI INVRPT').AsString := 'INVRPT';
                            MemD_StockTemp_ISF.FieldByName('ID Message').AsString := 'INV' + FormatDateTime('YYYYMMDDHHNNSS', dDateTraitement) + '00';
                            MemD_StockTemp_ISF.FieldByName('Type Date 1').AsInteger := 137;
                            MemD_StockTemp_ISF.FieldByName('Date 1').AsDateTime := dDateTraitement;
                            MemD_StockTemp_ISF.FieldByName('Type Date 2').AsInteger := 366;
                            MemD_StockTemp_ISF.FieldByName('Date 2').AsDateTime := dDateTraitement;
                            MemD_StockTemp_ISF.FieldByName('Type Date 3').AsInteger := 194;
                            MemD_StockTemp_ISF.FieldByName('Date 3').AsDateTime := dDateTraitement;
                            MemD_StockTemp_ISF.FieldByName('Type Date 4').AsInteger := 206;
                            MemD_StockTemp_ISF.FieldByName('Date 4').AsDateTime := dDateTraitement;
                            MemD_StockTemp_ISF.FieldByName('Type Partenaire 1').AsString := 'SU';
                            MemD_StockTemp_ISF.FieldByName('ID Partenaire 1').AsString := aQue_lstMarque_ISF.FieldByName('MRK_ILN').AsString;  //aQue_LstMag.FieldByName('MAG_CODE').AsString;
                            MemD_StockTemp_ISF.FieldByName('Nom Partenaire 1').AsString := aQue_lstMarque_ISF.FieldByName('MRK_NOM').AsString; //aQue_lstMag.FieldByName('MAG_NOM').AsString;
                            MemD_StockTemp_ISF.FieldByName('Type Partenaire 2').AsString := 'BY';
                            MemD_StockTemp_ISF.FieldByName('ID Partenaire 2').AsString := '3025816970108';
                            MemD_StockTemp_ISF.FieldByName('Nom Partenaire 2').AsString := 'INTERSPORT France';
                            MemD_StockTemp_ISF.FieldByName('Ligne : ID Ligne').AsInteger := iCountLigne;
                            MemD_StockTemp_ISF.FieldByName('Ligne : Code Article').AsString := aQue_LstArt.FieldByName('REA_EAN').AsString;
                            MemD_StockTemp_ISF.FieldByName('Ligne : Quantite : Type Quantite').AsInteger := 145;
                            MemD_StockTemp_ISF.FieldByName('Ligne : Quantite : Quantite').AsInteger := Que_Tmp.FieldByName('HST_QTE').AsInteger;
                            MemD_StockTemp_ISF.FieldByName('Ligne : Quantite : ID Acheteur').AsString := '';
                            MemD_StockTemp_ISF.FieldByName('Ligne : Quantite : Nom Acheteur').AsString := '';
                            MemD_StockTemp_ISF.FieldByName('Ligne : Quantite : Type Lieu').AsString := '162';
                            MemD_StockTemp_ISF.FieldByName('Ligne : Quantite : Lieu').AsString := aQue_LstMag.FieldByName('MAG_NOM').AsString;
                          end;
                          MemD_StockTemp_ISF.Post;

                          Next;
                        end;  // while
      //                  // Suppression des lignes avec 0 en quantité
      //                  MemD_StockTemp.First;
      //                  while not MemD_StockTemp.EOF do
      //                  begin
      //                    if MemD_StockTemp.FieldByName('Quantite').AsInteger = 0 then
      //                      MemD_StockTemp.Delete
      //                    else
      //                      MemD_StockTemp.Next;
      //                  end;
                      end;  //with
                    end;  //if
                    aQue_LstArt.Next;
                    if Assigned(ProgressMrk) then
                      ProgressMrk.Position := aQue_LstArt.RecNo * 100 Div aQue_LstArt.RecordCount;
                    Application.ProcessMessages;
                  end;  //while

                  // Sauvegarde en CSV des données
                  sFileName := GDIRTOSEND + Format(CFILESTRUCT_ISF,[FormatDateTime('YYYYMMDDhhmmss',dDateTraitement)]);
                  DoMemStockToCsv_ISF(sFileName);

                  // Ajout à la liste de traitement FTP
                  //if MemD_StockTemp.RecordCount > 0 then
                  if ASendToFTP then
                    With MemD_FTPToSend do
                    begin
                      IF not Locate('FileName',sFileName,[]) then
                      begin
                        Append;
                        FieldByName('MAG_ID').AsInteger := aQue_LstMag.FieldByName('REM_MAGID').AsInteger;
                        FieldByName('MRK_ID').AsInteger := aQue_lstMarque_ISF.FieldByName('MRK_ID').AsInteger;
                        FieldByName('MAG_CODE').AsString := aQue_LstMag.FieldByName('MAG_CODE').AsString;
                        FieldByName('RAM_TRIGRAM').AsString := aQue_lstMarque_ISF.FieldByName('RAM_TRIGRAM').AsString;
                        FieldByName('FileName').AsString := sFileName;
                        FieldByName('FTPDir').AsString := aQue_lstMarque_ISF.FieldByName('RAM_REPFTP').AsString;
                        Post;
                        AddToTrace(FieldByName('MAG_ID').AsInteger,FieldByName('MRK_ID').AsInteger,ExtractFileName(sFileName),dDateTraitement);
                      end;
                    end;

                  if ASaveInDB then
                    AddtoHisto(aQue_LstMag.FieldByName('REM_MAGID').AsInteger, aQue_lstMarque_ISF.FieldByName('MRK_ID').AsInteger,dDateTraitement,CETATOK,CTYPESTK,0,0,0);

                  if Trim(GUID) <> '' then
                    Log.Log('', 'STOCK', 'INTERSPORT', GUID {ref}, IntToStr(MAG_ID) {mag}, 'Traitement', 'Terminé', logInfo, False, -1, ltServer);

//                  if not SameText( GUID, SysUtils.EmptyStr ) then
//                    TLogEngine.Info( 'STOCK', 'SPORT2000', GUID, 'Traitement' );
                end else
                  AddToMemo('--Marque Inexistante : ' + aQue_lstMarque_ISF.FieldByName('MRK_NOM').AsString);
              Except on E:Exception do
                begin
                  if Trim(GUID) <> '' then
                    Log.Log('', 'STOCK', 'INTERSPORT', GUID {ref}, IntToStr(MAG_ID) {mag}, 'Traitement',E.Message, logError, False, -1, ltServer);

//                  if not SameText( GUID, SysUtils.EmptyStr ) then
//                    TLogEngine.Error( 'STOCK', 'INTERSPORT', GUID, 'Traitement', E.Message );
                  if ASaveInDB then
                    AddtoHisto(aQue_LstMag.FieldByName('REM_MAGID').AsInteger, aQue_lstMarque_ISF.FieldByName('MRK_ID').AsInteger,dDateTraitement,CETATKO,CTYPESTK,0,0,0);
                  AddToMemo('-- ' + aQue_LstMag.FieldByName('MAG_CODE').AsString + '/' +
                            aQue_lstMarque_ISF.FieldByName('RAM_TRIGRAM').AsString + ' Erreur de traitement : ' + E.Message);
                end;
              end;
              OldDir := FieldByName('MAG_CHEMINBASE').AsString;
            end else
              AddTOMemo('--Chemin vers la base de données vide');
          end;
        Except on E:Exception do
          begin
            Log.Log('Main', 'Status', FieldByName('MAG_NOM').AsString + ' : ' + E.Message , logError, False) ;
            AddToMemo('-- Erreur : ' + E.Message);
            inc(icountError);
          end;
        end;

        Next;

        if Assigned(ProgressMag) then
          ProgressMag.Position := RecNo * 100 Div RecordCount;
        Application.ProcessMessages;
      end; // while
    end;
  Except on E:Exception do
    raise Exception.Create('DoTraitementSTK -> ' + E.Message);
  end;
end;

end.
