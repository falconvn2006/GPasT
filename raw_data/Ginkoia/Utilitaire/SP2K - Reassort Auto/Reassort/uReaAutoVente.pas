unit uReaAutoVente;

interface

  uses ReaAutoMain_DM, uHeaderCsv, SysUtils, uDefs, Variants, forms, Classes,uLog;

const
  CFILESTRUCT_S2K = 'SLSRPT_%s_SPORT2000_%s_%s.dat';
  CFILESTRUCT_ISF = 'VenteJour%s.txt';

function DoTraitementVTE_S2K(AOnlyOneMag : Boolean = False; AMAG_ID : Integer = 0; ASaveInDB : Boolean = True; ASendToFTP : Boolean = True; AList : TStrings = nil) : Boolean;
function DoMemVenteToCsv_S2K(sFileName : String) : Boolean;
function DoTraitementVTE_ISF(AOnlyOneMag : Boolean = False; AMAG_ID : Integer = 0; ASaveInDB : Boolean = True; ASendToFTP : Boolean = True; AList : TStrings = nil) : Boolean;
function DoMemVenteToCsv_ISF(sFileName : String) : Boolean;


implementation

function DoTraitementVTE_S2K(AOnlyOneMag : Boolean = False; AMAG_ID : Integer = 0; ASaveInDB : Boolean = True; ASendToFTP : Boolean = True; AList : TStrings = nil) : Boolean;
var
  dDateTraitement : TDateTime;
  OldDir, sFileName : String;
  MAG_ID, MRK_ID : Integer;
  KId : TKVersion;
  KIdLast : Integer;
  iCountError : Integer;
  dTimeStart, dTimeToTalStart : TDateTime;
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
      AddToMemo('---------------------');
      AddToMemo('Traitement des ventes');
      AddToMemo('---------------------');

      iCountError := 0;
      while not EOF do
      begin
        Try
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

          // Récupération des données de la marque
          aQue_lstMarque_S2K.Close;
          aQue_lstMarque_S2K.ParamCheck := True;
          aQue_lstMarque_S2K.Parameters.ParamByName('PMRKID').Value := FieldByName('REM_MRKID').AsInteger;
          aQue_lstMarque_S2K.Open;

          // A-t-on un marque à traiter ayant RAM_VTE à 1 ?
          if aQue_lstMarque_S2K.FieldByName('RAM_VTE').AsInteger = 1 then
          begin
            // Est ce que le chemin vers la base de données n'est pas vide ?
            if Trim(FieldByName('MAG_CHEMINBASE').AsString) <> '' then
            begin
              Log.Log('Main', 'Status', FieldByName('MAG_NOM').AsString + ' : Traitement des ventes' , logNotice, False) ;


              // Est ce que le chemin en court est différent de l'ancien chemin ?
              if Trim(OldDir) <> Trim(FieldByName('MAG_CHEMINBASE').AsString) then
              begin
                 AddToMemo('-------------------------------------------------------------');
                 AddToMemo('Base de données : ' + FieldByName('MAG_CHEMINBASE').AsString);
                 AddToMemo('Magasin : ' + FieldByName('MAG_CODE').AsString);
                // On ouvre la base de données que si le dernier chemin est différent
                dTimeToTalStart := Now;
                InitGinkoiaDB(FieldByName('MAG_CHEMINBASE').AsString,mVente);
                AddToMemo('  - Temps de connexion : ' + FormatDateTime('hh:mm:ss',Now - dTimeToTalStart));

                // Réinitialisation du compteur d'erreur car on a reussit à ce sonnecter à la base de données
                iCountError := 0;

                KidLast := GetLastGenID;
              end;

              try
                // récupération de l'ID magasin
                MAG_ID := FindMagID(FieldByName('MAG_CODE').AsString);
                // récupération de l'Id Marque
                MRK_ID := FindMrkId(aQue_lstMarque_S2K.FieldByName('MRK_NOM').AsString);
                AddToMemo(' -> Marque : ' + aQue_lstMarque_S2K.FieldByName('MRK_NOM').AsString);

                AddtoLabMag(FieldByName('MAG_CODE').AsString + ' - ' + FieldByName('MAG_NOM').AsString);
                AddToLabMrk(aQue_lstMarque_S2K.FieldByName('MRK_NOM').AsString);

                // Réinitialisation de la table des ventes temporaire
                MemD_VenteTemp_S2K.Close;
                MemD_VenteTemp_S2K.Open;

                // si on a trouvé la marque
                if MRK_ID <> -1 then
                begin
                  // Récupération du GUID;
                  GUID := FindGUID( MAG_ID );

                  if Trim(GUID) <> '' then
                    Log.Log('', 'VENTE', 'SPORT2000', GUID {ref}, IntToStr(MAG_ID) {mag}, 'Traitement', 'En cours', logNotice, True, -1, ltServer);

//                  if not SameText( GUID, SysUtils.EmptyStr ) then
//                    TLogEngine.Notice( 'VENTE', 'SPORT2000', GUID, 'Traitement' );

                  // Récupération des K
                  dTimeStart := Now;
                  KId := GetLastHisto(aQue_LstMag.FieldByName('REM_MAGID').AsInteger,aQue_lstMarque_S2K.FieldByName('MRK_ID').AsInteger,CTYPEVTE);
                  AddToMemo('  - Temps : ' + FormatDateTime('hh:mm:ss', Now - dTimeStart));

                  // Si la date d'intégration est supérieur à la date en cours on ne fait rien
                  if KId.K_DATE <= Now then
                  begin
                    // Dans le cas où tous les ID sont à 0, on va les chercher dans la base de données GK
                    if (KId.iKVERSION_TCK = 0) and (KID.iKVERSION_NEGBL = 0) and (KId.iKVERSION_NEGFCT = 0) then
                    begin
                      KId.iKVERSION_TCK    := GetMaxKVersion(CTBCODETCK,KId.K_DATE) - 1;
                      KId.iKVERSION_NEGBL  := GetMaxKVersion(CTBCODEBL,KId.K_DATE) - 1;
                      KId.iKVERSION_NEGFCT := GetMaxKVersion(CTBCODEFCT,KId.K_DATE) - 1;
                    end;
                    // Récupération de la liste d'article à traiter pour cette marque
                    aQue_LstArt.Close;
                    aQue_LstArt.ParamCheck := True;
                    aQue_LstArt.Parameters.ParamByName('PMRKID').Value := aQue_lstMarque_S2K.FieldByName('MRK_ID').AsInteger;
                    aQue_LstArt.Open;

                    dTimeToTalStart := Now;
                    While not aQue_LstArt.EOF do
                    Begin
                      dTimeStart := Now;
                      // traitement des articles pour récupération des données ventes
                      With Que_Ventes do
                      begin
                        Close;
                        ParamCheck := True;
                        ParamByName('PCB1').AsString := aQue_LstArt.FieldByName('REA_EAN').AsString;
                        ParamByName('PMAGID1').AsInteger := MAG_ID;
                        ParamByName('PMRKID1').AsInteger := MRK_ID;
                        ParamByName('PKVE1Debut').AsInteger := KId.iKVERSION_TCK;
                        ParamByName('PKVE1Fin').AsInteger := KidLast;

                        ParamByName('PCB2').AsString := aQue_LstArt.FieldByName('REA_EAN').AsString;
                        ParamByName('PMAGID2').AsInteger := MAG_ID;
                        ParamByName('PMRKID2').AsInteger := MRK_ID;
                        ParamByName('PKVE2Debut').AsInteger := KId.iKVERSION_NEGBL;
                        ParamByName('PKVE2Fin').AsInteger := KidLast;

                        ParamByName('PCB3').AsString := aQue_LstArt.FieldByName('REA_EAN').AsString;
                        ParamByName('PMAGID3').AsInteger := MAG_ID;
                        ParamByName('PMRKID3').AsInteger := MRK_ID;
                        ParamByName('PKVE3Debut').AsInteger := KId.iKVERSION_NEGFCT;
                        ParamByName('PKVE3Fin').AsInteger := KidLast;
                        Open;
                      end; // with

                      if Que_Ventes.RecordCount > 0 then
                      begin
                        With MemD_VenteTemp_S2K do
                        begin
                          Que_Ventes.First;
                          while not Que_Ventes.Eof do
                          begin
                            Append;
                            FieldByName('IdMagasin').AsString := aQue_LstMag.FieldByName('MAG_CODE').AsString;
                            FieldByName('NomMagasin').AsString := aQue_LstMag.FieldByName('MAG_NOM').AsString;
                            FieldByName('DATE').AsDateTime     := Que_Ventes.FieldByName('DATECOM').AsDateTime;
                            FieldByName('NomMarque').AsString := aQue_lstMarque_S2K.FieldByName('MRK_NOM').AsString;
                            FieldByName('Nomfournisseur').AsString := FindFourNom(MRK_ID);
                            FieldByName('CodeArticle').AsString := aQue_LstArt.FieldByName('REA_EAN').AsString;
                            FieldByName('ValeurMonetaire').AsCurrency := Abs(Que_Ventes.FieldByName('ValMonetaire').AsCurrency);
                            FieldByName('Prix1').AsCurrency := Abs(Que_Ventes.FieldByName('Prix1').AsCurrency);
                            FieldByName('Prix2').AsCurrency := Abs(Que_Ventes.FieldByName('Prix2').AsCurrency);
                            if Que_Ventes.FieldByName('QTE').AsInteger >= 0 then
                            begin
                              FieldByName('Quantitevendue').AsInteger :=Abs(Que_Ventes.FieldByName('QTE').AsInteger);
                              FieldByName('Quantiteretournee').AsInteger := 0;
                            end
                            else begin
                              FieldByName('Quantitevendue').AsInteger :=0;
                              FieldByName('Quantiteretournee').AsInteger := Abs(Que_Ventes.FieldByName('QTE').AsInteger);
                            end;
                            Post;
                            Que_Ventes.Next;
                          end;
                        end; // with
                      end;
                      AddToMemo(Format('  - Article %s : %d/%d - Temps %s',[aQue_LstArt.FieldByName('REA_EAN').AsString,aQue_LstArt.RecNo, aQue_LstArt.Recordcount,FormatDateTime('hh:mm:ss',Now - dTimeStart)]));
                      aQue_LstArt.Next;
                      if Assigned(ProgressMrk) then
                      begin
                        ProgressMrk.Position := aQue_LstArt.RecNo * 100 Div aQue_LstArt.RecordCount;
                      end;
                      Application.ProcessMessages;
                    end; // while
                  end; // if K_DATE
                  AddToMemo('  - Temps Total : ' + FormatDateTime('hh:mm:ss',Now - dTimeToTalStart));

                  // Sauvegarde en CSV des données
                  dTimeStart := Now;
                  sFileName := GDIRTOSEND + Format(CFILESTRUCT_S2K,[aQue_lstMarque_S2K.FieldByName('RAM_TRIGRAM').AsString,aQue_LstMag.FieldByName('MAG_CODE').AsString,FormatDateTime('YYYYMMDD_hhmmss',dDateTraitement)]);
                  DoMemVenteToCsv_S2K(sFileName);
                  AddToMemo('  - Temps de génération du Csv : ' + FormatDateTime('hh:mm:ss',Now - dTimeStart));

                  // Ajout à la liste de traitement FTP
                  //if MemD_VenteTemp.RecordCount > 0 then
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
  //                AddtoHisto(aQue_LstMag.FieldByName('REM_MAGID').AsInteger, aQue_lstMarque.FieldByName('MRK_ID').AsInteger,dDateTraitement,CETATOK,CTYPEVTE,KId.iKVERSION_TCK,KId.iKVERSION_NEGBL,KId.iKVERSION_NEGFCT);
                  if ASaveInDB then
                    AddtoHisto(aQue_LstMag.FieldByName('REM_MAGID').AsInteger, aQue_lstMarque_S2K.FieldByName('MRK_ID').AsInteger,dDateTraitement,CETATOK,CTYPEVTE,KidLast,KidLast,KidLast);

                  if Trim(GUID) <> '' then
                    Log.Log('', 'VENTE', 'SPORT2000', GUID {ref}, IntToStr(MAG_ID) {mag}, 'Traitement', 'Terminé', logInfo, False, -1, ltServer);

//                  if not SameText( GUID, SysUtils.EmptyStr ) then
//                    TLogEngine.Info( 'VENTE', 'SPORT2000', GUID, 'Traitement' );
                end else
                  AddToMemo('--Marque Inexistante : ' + aQue_lstMarque_S2K.FieldByName('MRK_NOM').AsString);

              Except on E:Exception do
                begin
                  if Trim(GUID) <> '' then
                    Log.Log('', 'VENTE', 'SPORT2000', GUID {ref}, IntToStr(MAG_ID) {mag}, 'Traitement',E.Message, logError, False, -1, ltServer);

//                  if not SameText( GUID, SysUtils.EmptyStr ) then
//                    TLogEngine.Error( 'VENTE', 'SPORT2000', GUID, 'Traitement', E.Message );
                  if ASaveInDB then
                    AddtoHisto(aQue_LstMag.FieldByName('REM_MAGID').AsInteger, aQue_lstMarque_S2K.FieldByName('MRK_ID').AsInteger,dDateTraitement,CETATKO,CTYPEVTE,KId.iKVERSION_TCK,KId.iKVERSION_NEGBL,KId.iKVERSION_NEGFCT);
                  AddToMemo('-- ' + aQue_LstMag.FieldByName('MAG_CODE').AsString + '/' +
                            aQue_lstMarque_S2K.FieldByName('RAM_TRIGRAM').AsString + ' Erreur de traitement : ' + E.Message);
                end;
              end;

              OldDir := FieldByName('MAG_CHEMINBASE').AsString;
            end else
              AddTOMemo('--Chemin vers la base de données vide :' + FieldByName('MAG_NOM').AsString);
          end;

        Except on E:Exception Do
          begin
            Log.Log('Main', 'Status', FieldByName('MAG_NOM').AsString + ' : ' + E.Message , logError, False) ;
            Inc(icountError);
            AddToMemo('-- Erreur : ' + E.Message);
          end;
        End;

        Next;

        if Assigned(ProgressMag) then
          ProgressMag.Position := RecNo * 100 Div RecordCount;
        Application.ProcessMessages;
      end; // while

      AddToMemo('Traitement terminé');
      AddToMemo('-------------------------------------------------------------');
     end;
  Except on E:Exception do
    raise Exception.Create('DoTraitementVTE -> ' + E.Message);
  end;

end;

function DoMemVenteToCsv_S2K(sFileName : String) : Boolean;
var
  Header : TExportHeaderOL;
begin
  Header := TExportHeaderOL.Create;
  With DM_ReaAuto do
  Try
    Try
      Header.Separator := ';';
      Header.bWriteHeader := True;
      Header.bAlign := False;
      Header.Add('IdMagasin',6,alLeft,fmInteger);
      Header.Add('NomMagasin',35);
      Header.Add('Date',0,alLeft,fmDate,'YYYYMMDD');
      Header.Add('NomMarque',35);
      Header.Add('NomFournisseur',35);
      Header.Add('CodeArticle',35);
      Header.Add('ValeurMonetaire',18,alLeft,fmFloat,'0.00','.');
      Header.Add('Prix1',15,alLeft,fmFloat,'0.00','.');
      Header.Add('Prix2',15,alLeft,fmFloat,'0.00','.');
      Header.add('QuantiteVendue',0,alLeft,fmInteger);
      Header.Add('QuantiteRetournee',0,alLeft,fmInteger);
      if Header.ConvertToCsv(MemD_VenteTemp_S2K,sFileName)=1 then
        AddToMemo('Création du fichier réussit : ' + sFileName)
      else if Header.ConvertToCsv(MemD_VenteTemp_S2K,sFileName)=0 then
        AddToMemo('Aucune données à exporter dans le fichier : ' + sFileName)
      else
        AddToMemo('Echec de création du fichier : ' + sFileName);


    Except on E:Exception do
      Raise Exception.Create('DoMemVenteToCsv -> ' + E.Message);
    End;

  Finally
    Header.Free;
  End;

end;

function DoTraitementVTE_ISF(AOnlyOneMag : Boolean = False; AMAG_ID : Integer = 0; ASaveInDB : Boolean = True; ASendToFTP : Boolean = True; AList : TStrings = nil) : Boolean;
var
  dDateTraitement   : TDateTime;
  OldDir, sFileName : String;
  MAG_ID, MRK_ID : Integer;
  KId : TKVersion;
  KIdLast : Integer;
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
      AddToMemo('---------------------');
      AddToMemo('Traitement des ventes');
      AddToMemo('---------------------');

      iCountError := 0;
      iCountLigne := 0;

      while not EOF do
      begin
        Try

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

//          // Récupération du GUID;
//          GUID := FindGUID( MAG_ID );
//          if not SameText( GUID, SysUtils.EmptyStr ) then
//            TLogEngine.Notice( 'VENTE', 'INTERSPORT', GUID, 'Traitement' );

          // récupération des données de la marque
          aQue_lstMarque_ISF.Close;
          aQue_lstMarque_ISF.ParamCheck := True;
          aQue_lstMarque_ISF.Parameters.ParamByName('PMRKID').Value := FieldByName('REM_MRKID').AsInteger;
          aQue_lstMarque_ISF.Open;

          // A-t-on un marque à traiter ayant RAM_VTE à 1 ?
          if aQue_lstMarque_ISF.FieldByName('RAM_VTE').AsInteger = 1 then
          begin
            // Est ce que le chemin vers la base de données n'est pas vide ?
            if Trim(FieldByName('MAG_CHEMINBASE').AsString) <> '' then
            begin
              Log.Log('Main', 'Status', FieldByName('MAG_NOM').AsString + ' : Traitement des ventes' , logNotice, False) ;

              // Est ce que le chemin en court est différent de l'ancien chemin ?
              if Trim(OldDir) <> Trim(FieldByName('MAG_CHEMINBASE').AsString) then
              begin
                 AddToMemo('Base de données : ' + FieldByName('MAG_CHEMINBASE').AsString);
                // On ouvre la base de données que si le dernier chemin est différent
                InitGinkoiaDB(FieldByName('MAG_CHEMINBASE').AsString,mVente);
                // Réinitialisation du compteur d'erreur car on a reussit à ce sonnecter à la base de données
                iCountError := 0;

                KidLast := GetLastGenID;
              end;

              try
                // récupération de l'ID magasin
                MAG_ID := FindMagID(FieldByName('MAG_CODE').AsString);
                // récupération de l'Id Marque
                MRK_ID := FindMrkId(aQue_lstMarque_ISF.FieldByName('MRK_NOM').AsString);

                // Réinitialisation de la table des ventes temporaire
                MemD_VenteTemp_ISF.Close;
                MemD_VenteTemp_ISF.Open;

                // si on a trouvé la marque
                if MRK_ID <> -1 then
                begin
                  // Récupération du GUID;
                  GUID := FindGUID( MAG_ID );

                  if Trim(GUID) <> '' then
                    Log.Log('', 'VENTE', 'INTERSPORT', GUID {ref}, IntToStr(MAG_ID) {mag}, 'Traitement', 'En cours', logNotice, True, -1, ltServer);

//                  if not SameText( GUID, SysUtils.EmptyStr ) then
//                    TLogEngine.Notice( 'VENTE', 'INTERSPORT', GUID, 'Traitement' );

                  // Récupération des K
                  KId := GetLastHisto(aQue_LstMag.FieldByName('REM_MAGID').AsInteger,aQue_lstMarque_ISF.FieldByName('MRK_ID').AsInteger,CTYPEVTE);

                  // Si la date d'intégration est supérieur à la date en cours on ne fait rien
                  if KId.K_DATE <= Now then
                  begin
                    // Dans le cas où tous les ID sont à 0, on va les chercher dans la base de données GK
                    if (KId.iKVERSION_TCK = 0) and (KID.iKVERSION_NEGBL = 0) and (KId.iKVERSION_NEGFCT = 0) then
                    begin
                      KId.iKVERSION_TCK    := GetMaxKVersion(CTBCODETCK,KId.K_DATE) - 1;
                      KId.iKVERSION_NEGBL  := GetMaxKVersion(CTBCODEBL,KId.K_DATE) - 1;
                      KId.iKVERSION_NEGFCT := GetMaxKVersion(CTBCODEFCT,KId.K_DATE) - 1;
                    end;
                    // Récupération de la liste d'article à traiter pour cette marque
                    aQue_LstArt.Close;
                    aQue_LstArt.ParamCheck := True;
                    aQue_LstArt.Parameters.ParamByName('PMRKID').Value := aQue_lstMarque_ISF.FieldByName('MRK_ID').AsInteger;
                    aQue_LstArt.Open;

//                    // Récupération du GUID;
//                    GUID := FindGUID( MAG_ID );
//                    if not SameText( GUID, SysUtils.EmptyStr ) then
//                      TLogEngine.Notice( 'VENTE', 'INTERSPORT', GUID, 'Traitement' );

                    While not aQue_LstArt.EOF do
                    Begin
                      // traitement des articles pour récupération des données ventes
                      With Que_Ventes do
                      begin
                        Close;
                        ParamCheck := True;
                        ParamByName('PCB1').AsString := aQue_LstArt.FieldByName('REA_EAN').AsString;
                        ParamByName('PMAGID1').AsInteger := MAG_ID;
                        ParamByName('PMRKID1').AsInteger := MRK_ID;
                        ParamByName('PKVE1Debut').AsInteger := KId.iKVERSION_TCK;
                        ParamByName('PKVE1Fin').AsInteger := KidLast;

                        ParamByName('PCB2').AsString := aQue_LstArt.FieldByName('REA_EAN').AsString;
                        ParamByName('PMAGID2').AsInteger := MAG_ID;
                        ParamByName('PMRKID2').AsInteger := MRK_ID;
                        ParamByName('PKVE2Debut').AsInteger := KId.iKVERSION_NEGBL;
                        ParamByName('PKVE2Fin').AsInteger := KidLast;

                        ParamByName('PCB3').AsString := aQue_LstArt.FieldByName('REA_EAN').AsString;
                        ParamByName('PMAGID3').AsInteger := MAG_ID;
                        ParamByName('PMRKID3').AsInteger := MRK_ID;
                        ParamByName('PKVE3Debut').AsInteger := KId.iKVERSION_NEGFCT;
                        ParamByName('PKVE3Fin').AsInteger := KidLast;
                        Open;
                      end; // with

                      if Que_Ventes.RecordCount > 0 then
                      begin
                        With MemD_VenteTemp_ISF do
                        begin
                          Que_Ventes.First;
                          while not Que_Ventes.Eof do
                          begin
                            inc(iCountLigne);
                            Append;
                            FieldByName('Expediteur').AsString := '3025816970108';
                            FieldByName('Destinataire').AsString := aQue_lstMarque_ISF.FieldByName('MRK_ILN').AsString;
                            FieldByName('Type EDI SLSRPT').AsString := 'SLSRPT';
                            FieldByName('ID Message').AsString := 'SLS' + FormatDateTime('YYYYMMDDHHNNSS', dDateTraitement) + '00';
                            FieldByName('Type Date 1').AsInteger := 137;
                            FieldByName('Date 1').AsDateTime := dDateTraitement;
                            FieldByName('Type Date 2').AsInteger := 356;
                            FieldByName('Date 2').AsDateTime := dDateTraitement;
                            FieldByName('Type Date 3').AsString := '';
                            FieldByName('Date 3').AsString := '';
                            FieldByName('Type Partenaire 1').AsString := 'BY';
                            FieldByName('ID Partenaire 1').AsString := '3025816970108';
                            FieldByName('Nom Partenaire 1').AsString := 'INTERSPORT France';
                            FieldByName('Type Partenaire 2').AsString := 'SU';
                            FieldByName('ID Partenaire 2').AsString := aQue_lstMarque_ISF.FieldByName('MRK_ILN').AsString;  //aQue_LstMag.FieldByName('MAG_CODE').AsString
                            FieldByName('Nom Partenaire 2').AsString := aQue_lstMarque_ISF.FieldByName('MRK_NOM').AsString;
                            FieldByName('Devise').AsString := 'EUR';
                            FieldByName('Lieu : Type Lieu').AsString := '162';
                            FieldByName('Lieu : Lieu').AsString := aQue_lstMag.FieldByName('MAG_NOM').AsString;
                            FieldByName('Lieu : Ligne : ID Ligne').AsInteger := iCountLigne;
                            FieldByName('Lieu : Ligne : Code Article').AsString := aQue_LstArt.FieldByName('REA_EAN').AsString;
                            FieldByName('Lieu : Ligne : Type Reference').AsString := 'SS';
                            FieldByName('Lieu : Ligne : Reference').AsString := Que_Ventes.FieldByName('NumTicket').AsString;
                            FieldByName('Lieu : Ligne : Type Valeur Monetaire').AsString := '203';
                            FieldByName('Lieu : Ligne : Valeur Monetaire').AsString := StringReplace(FloatToStr(Abs(Que_Ventes.FieldByName('ValMonetaire').AsCurrency)), ',', '.',[rfReplaceAll]);
                            FieldByName('Lieu : Ligne : Type Prix 1').AsString := 'NTP';
                            FieldByName('Lieu : Ligne : Prix 1').AsString := StringReplace(FloatToStr(Abs(Que_Ventes.FieldByName('Prix1').AsCurrency)),',','.', [rfReplaceAll]);
                            FieldByName('Lieu : Ligne : Type Prix 2').AsString := 'RTP';
                            FieldByName('Lieu : Ligne : Prix 2').AsString := StringReplace(FloatToStr(Abs(Que_Ventes.FieldByName('Prix2').AsCurrency)),',','.', [rfReplaceAll]);
                            FieldByName('Lieu : Ligne : Type Quantite').AsString := '153';
                            FieldByName('Lieu : Ligne : Quantite').AsInteger := Que_Ventes.FieldByName('QTE').AsInteger;
                            FieldByName('Lieu : Ligne : Type Partenaire').AsString := '';
                            FieldByName('Lieu : Ligne : ID Partenaire').AsString := '';
                            FieldByName('Lieu : Ligne : Nom Partenaire').AsString := '';
                            Post;
                            Que_Ventes.Next;
                          end;
                        end; // with
                      end;
                      aQue_LstArt.Next;
                      if Assigned(ProgressMrk) then
                      begin
                        ProgressMrk.Position := aQue_LstArt.RecNo * 100 Div aQue_LstArt.RecordCount;
                      end;
                      Application.ProcessMessages;
                    end; // while
                  end; // if K_DATE

                  // Sauvegarde en CSV des données
                  sFileName := GDIRTOSEND + Format(CFILESTRUCT_ISF,[FormatDateTime('YYYYMMDDhhmmss',dDateTraitement)]);
                  DoMemVenteToCsv_ISF(sFileName);

                  // Ajout à la liste de traitement FTP
                  //if MemD_VenteTemp.RecordCount > 0 then
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
  //                AddtoHisto(aQue_LstMag.FieldByName('REM_MAGID').AsInteger, aQue_lstMarque.FieldByName('MRK_ID').AsInteger,dDateTraitement,CETATOK,CTYPEVTE,KId.iKVERSION_TCK,KId.iKVERSION_NEGBL,KId.iKVERSION_NEGFCT);
                  if ASaveInDB then
                    AddtoHisto(aQue_LstMag.FieldByName('REM_MAGID').AsInteger, aQue_lstMarque_ISF.FieldByName('MRK_ID').AsInteger,dDateTraitement,CETATOK,CTYPEVTE,KidLast,KidLast,KidLast);

                  if Trim(GUID) <> '' then
                    Log.Log('', 'VENTE', 'INTERSPORT', GUID {ref}, IntToStr(MAG_ID) {mag}, 'Traitement', 'Terminé', logInfo, False, -1, ltServer);

//                  if not SameText( GUID, SysUtils.EmptyStr ) then
//                    TLogEngine.Info( 'VENTE', 'INTERSPORT', GUID, 'Traitement' );
                end else
                  AddToMemo('--Marque Inexistante : ' + aQue_lstMarque_ISF.FieldByName('MRK_NOM').AsString);

              Except on E:Exception do
                begin
                  if Trim(GUID) <> '' then
                    Log.Log('', 'VENTE', 'INTERSPORT', GUID {ref}, IntToStr(MAG_ID) {mag}, 'Traitement',E.Message, logError, False, -1, ltServer);

//                  if not SameText( GUID, SysUtils.EmptyStr ) then
//                    TLogEngine.Error( 'VENTE', 'INTERSPORT', GUID, 'Traitement', E.Message );
                  if ASaveInDB then
                    AddtoHisto(aQue_LstMag.FieldByName('REM_MAGID').AsInteger, aQue_lstMarque_ISF.FieldByName('MRK_ID').AsInteger,dDateTraitement,CETATKO,CTYPEVTE,KId.iKVERSION_TCK,KId.iKVERSION_NEGBL,KId.iKVERSION_NEGFCT);
                  AddToMemo('-- ' + aQue_LstMag.FieldByName('MAG_CODE').AsString + '/' +
                            aQue_lstMarque_ISF.FieldByName('RAM_TRIGRAM').AsString + ' Erreur de traitement : ' + E.Message);
                end;
              end;

              OldDir := FieldByName('MAG_CHEMINBASE').AsString;
            end else
              AddTOMemo('--Chemin vers la base de données vide');
          end;
        Except on E:Exception Do
          begin
            Log.Log('Main', 'Status', FieldByName('MAG_NOM').AsString + ' : ' + E.Message , logError, False) ;
            Inc(icountError);
            AddToMemo('-- Erreur : ' + E.Message);
          end;
        End;

        Next;

        if Assigned(ProgressMag) then
          ProgressMag.Position := RecNo * 100 Div RecordCount;
        Application.ProcessMessages;
      end; // while
    end;
  Except on E:Exception do
    raise Exception.Create('DoTraitementVTE -> ' + E.Message);
  end;

end;

function DoMemVenteToCsv_ISF(sFileName : String) : Boolean;
var
  Header : TExportHeaderOL;
begin
  Header := TExportHeaderOL.Create;
  With DM_ReaAuto do
  Try
    Try
      Header.Separator := ';';
      Header.bWriteHeader := True;
      Header.bAlign := False;
      Header.Add('Expediteur',13);
      Header.Add('Destinataire',16);
      Header.Add('Type EDI SLSRPT',6);
      Header.Add('ID Message',35);
      Header.Add('Type Date 1',3,alLeft,fmInteger);
      Header.Add('Date 1',0,alLeft,fmDate,'YYYYMMDD');
      Header.Add('Type Date 2',3,alLeft,fmInteger);
      Header.Add('Date 2',0,alLeft,fmDate,'YYYYMMDD');
      Header.Add('Type Date 3',3,alLeft,fmInteger);
      Header.Add('Date 3',1);
      Header.Add('Type Partenaire 1',2);
      Header.Add('ID Partenaire 1',35);
      Header.Add('Nom Partenaire 1',35);
      Header.Add('Type Partenaire 2',2);
      Header.Add('ID Partenaire 2',35);
      Header.Add('Nom Partenaire 2',35);
      Header.Add('Devise',3);
      Header.Add('Lieu : Type Lieu',3,alLeft,fmInteger);
      Header.Add('Lieu : Lieu',70);
      Header.Add('Lieu : Ligne : ID Ligne',0,alLeft,fmInteger);
      Header.Add('Lieu : Ligne : Code Article',35);
      Header.Add('Lieu : Ligne : Type Reference',2);
      Header.Add('Lieu : Ligne : Reference',35);
      Header.Add('Lieu : Ligne : Type Valeur Monetaire',3);
      Header.Add('Lieu : Ligne : Valeur Monetaire',18);
      Header.Add('Lieu : Ligne : Type Prix 1',3);
      Header.Add('Lieu : Ligne : Prix 1',15);
      Header.Add('Lieu : Ligne : Type Prix 2',3);
      Header.Add('Lieu : Ligne : Prix 2',15);
      Header.Add('Lieu : Ligne : Type Quantite',3);
      Header.Add('Lieu : Ligne : Quantite',0,alLeft,fmInteger);
      Header.Add('Lieu : Ligne : Type Partenaire',35);
      Header.Add('Lieu : Ligne : ID Partenaire',35);
      Header.Add('Lieu : Ligne : Nom Partenaire',35);
      if Header.ConvertToCsv(MemD_VenteTemp_ISF,sFileName)=1 then
        AddToMemo('Création du fichier réussit : ' + sFileName)
      else if Header.ConvertToCsv(MemD_VenteTemp_ISF,sFileName)=0 then
        AddToMemo('Aucune données à exporter dans le fichier : ' + sFileName)
      else
        AddToMemo('Echec de création du fichier : ' + sFileName);


    Except on E:Exception do
      Raise Exception.Create('DoMemVenteToCsv -> ' + E.Message);
    End;

  Finally
    Header.Free;
  End;

end;

end.
