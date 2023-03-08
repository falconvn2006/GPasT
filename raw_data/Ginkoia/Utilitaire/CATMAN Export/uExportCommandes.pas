unit uExportCommandes;

interface

uses CMELMain_DM, uDefs, Sysutils, Variants, Db, Forms, uHeaderCsv, Math, Types, IdSMTP, IdMessage,
     IdAttachmentFile, IdText;

  function GenerateExportCMD : Boolean;

  function ExecuteExportCMD (BasePath,MAG_CODE,MAG_NOM : String;MAG_ID : Integer;dFile : TDateTime) : Boolean;

  function GetPxVente(MAG_ID,ART_ID,TGF_ID : integer) : Currency;
  function GetPxAchat(ART_ID,TGF_ID, FOU_ID : Integer) : Currency;

  function SendMail(GK_CHRONO,MAG_CODE,MAG_NOM : String;GK_MAGID : Integer) : Boolean;

implementation

function GenerateExportCMD : Boolean;
var
  dFile : TDateTime;
  sFileName : String;
begin
  dFile := Now;
  sFileName := 'ORDERS_SPORT2000_' + FormatDateTime('YYYYMMDD_hhmmss',dFile) + '.dat';
  With DM_CMEL do
  begin
    With aQue_MagList do
    begin
      First;
      try
        if MainCFG.Debug then
        begin
          Locate('MAG_CODE',MainCFG.DebugMagCode,[]);
//          while not EOF do
//          begin
//            if FieldByName('MAG_CMDLEVIS').AsInteger = 1 then
//            begin
              ExecuteExportCMD(GBASEPATHDEBUG,MainCFG.DebugMagCode,FieldByName('MAG_NOM').AsString,MainCFG.DebugMagID,dFile);
//            end;
//            Next;
//            ProgBarClient.Position := RecNo * 100 Div RecordCount;
//            Application.ProcessMessages;
//          end;
          SaveMemo(FieldByName('MAG_CODE').AsString,MODECMD);
          Exit;
        end;

        while not EOF do
        begin
    //      if FieldByName('MAG_CMDLEVIS').AsInteger = 1 then
            ExecuteExportCMD(FieldByName('MAG_CHEMINBASE').AsString,FieldByName('MAG_CODE').AsString,FieldByName('MAG_NOM').AsString,FieldByName('MAG_ID').AsInteger,dFile);
          Next;
          ProgBarClient.Position := RecNo * 100 Div RecordCount;
          Application.ProcessMessages;
        end;

        if FileExists(GPATHSAVE + sFileName) then
        Try
          AddToMemo('Transfert du fichier sur FTP');

          if SendFileToFTP(GPATHSAVE + sFileName) then
          begin
            AddToMemo('Transfert OK');

            if ArchiveFile(GPATHSAVE + sFileName) then
              AddToMemo('Archivage du fichier OK');
          end;
        Except on E:Exception do
          AddToMemo('GenerateExportCMD -> ' + E.Message);
        End;
      finally
        SaveMemo(FieldByName('MAG_CODE').AsString,MODECMD);
      end;
    end;
  end;
end;


function ExecuteExportCMD (BasePath,MAG_CODE,MAG_NOM : String;MAG_ID : Integer;dFile : TDateTime) : Boolean;
var
  Header         : TExportHeaderOL;
  i              : integer;
  iEtat, iLength : Integer;
  sFileName      : String;
  Kv             : TKVersion;
  GK_CHRONO      : String;
  GK_MAGID       ,
  GK_IDCMD       ,
  GK_FOUID       ,
  GK_EXEID       : integer;
  TVA            : TTVALignes;
  bAddTVA        : Boolean;

  IdMess         : TIdMessage;
  sMail          : String;
  GEN_ID         : integer;
  fTotalCde      : double;

begin
  Header := TExportHeaderOL.Create;
  With DM_CMEL do
  try
    // Paramètrage de l'entête du fichier csv
    Header.Add('CONST',37);
//    Header.Add('MAG_CODE',15);
//    Header.Add('MAG_LIB',32);
    Header.Add('OrderNbr',20);
    Header.Add('OrderType',3);
    Header.Add('OrderDate',10);
    Header.Add('ReqDelivDate',10);
    Header.Add('LateDelivDate',10);
    Header.Add('EANCode',13);
    Header.Add('Quantity',4,alRight,fmInteger);
    Header.bAlign := False;
    Header.bWriteHeader := False;
    Header.Separator := #9;

    MemD_CMDTmp.Close;
    MemD_CMDTmp.Open;
    MemD_CMD.Close;
    MemD_CMD.Open;

    iEtat := CETATKO;
    try
      // Initialisation de la base ginkoia en Modecommande (Ouverture/régénération stock/Drop procedure/Create procedure)
      InitGinkoiaDB(BasePath,MODECMD);
      fTotalCde := 0;
      // récupère le dernier GENERAL_ID de la base de données en cours
      Gen_ID := GetLastGenID;
      // Récupération du dernier Id KVersion sauvegardé
      Kv := GetLastHistoLevis(MAG_ID,CTYPECMD);

      if MainCFG.Debug and (MainCFG.DebugKIdCDE <> 0) then
      begin
        KV.IdKvTicket := MainCFG.DebugKIdCDE;
        Kv.IdKvBL     := MainCFG.DebugKIdCDE;
        Kv.IdKvFact   := MainCFG.DebugKIdCDE; 
      end;

      // Récupération du MAGID du magasin
      GK_MAGID := FindMagID(MAG_CODE);
      // Récupération de l'id du fournisseur levis
      GK_FOUID  := GetfournisseurID('LEVI STRAUSS CONTINENTAL');

      // Traitement des articles LEVIS
      AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Récupération des données article');

      aQue_Levis_T2.First;
      while not aQue_Levis_T2.Eof do
      begin
        // Vérification si le CB existe dans la base de données
        With Que_Tmp Do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Select count(*) as Resultat from ARTCODEBARRE');
          SQL.ADd(' Where CBI_CB = :PCBICB');
          ParamCheck := True;
          ParamByName('PCBICB').AsString := aQue_Levis_T2.FieldByName('LEV_EAN').AsString;
          Open;
        end;

        With Que_CMD do
        begin
          Close;
          ParamCheck := True;
          ParamByName('PCB1').AsString        := aQue_Levis_T2.FieldByName('LEV_EAN').AsString;
          ParamByName('PMAGID1').AsInteger    := GK_MAGID;
          ParamByName('PKVE1Debut').AsInteger := KV.IdKvTicket;
          ParamByName('PKVE1Fin').AsInteger   := GEN_ID;
          ParamByName('PCB2').AsString        := aQue_Levis_T2.FieldByName('LEV_EAN').AsString;
          ParamByName('PMAGID2').AsInteger    := GK_MAGID;
          ParamByName('PKVE2Debut').AsInteger := KV.IdKvBL;
          ParamByName('PKVE2Fin').AsInteger   := GEN_ID;
          ParamByName('PCB3').AsString        := aQue_Levis_T2.FieldByName('LEV_EAN').AsString;
          ParamByName('PMAGID3').AsInteger    := GK_MAGID;
          ParamByName('PKVE3Debut').AsInteger := KV.IdKvFact;
          ParamByName('PKVE3Fin').AsInteger   := GEN_ID;
          Open;
  //        if MainCFG.Debug then
            if Que_Tmp.FieldByName('Resultat').AsInteger > 0 then
              AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Article : ' + aQue_Levis_T2.FieldByName('LEV_EAN').AsString + ' Lignes : ' + IntToStr(Recordcount))
            else
              AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Article : ' + aQue_Levis_T2.FieldByName('LEV_EAN').AsString + ' Lignes : [INEXISTANT]');
        end;

        // Sauvegarde des données dans le dataset temporaire
        With MemD_CMDTmp do
        begin
          Que_CMD.First;
          while not Que_CMD.EOF do
          begin
            if Locate('ARF_ARTID;TGFID;COUID',VarArrayOf([Que_CMD.FieldByName('ARF_ARTID').AsInteger,
                                                          Que_CMD.FieldByName('TGFID').AsInteger,
                                                          Que_CMD.FieldByName('COUID').AsInteger]),[loCaseInsensitive]) then
            begin
              Edit;
              FieldByName('QTE').AsFloat := FieldByName('QTE').AsFloat + Que_CMD.FieldByName('QTE').AsFloat;
            end
            else begin
              Append;
              FieldByName('ARF_ARTID').AsInteger := Que_CMD.FieldByName('ARF_ARTID').AsInteger;
              FieldByName('DATECOM').AsDateTime  := Now;//  Que_CMD.FieldByName('DATECOM').AsDateTime;
              FieldByName('QTE').AsFloat         := Que_CMD.FieldByName('QTE').AsFloat;
              FieldByName('PXNN').AsFloat        := GetPxAchat(Que_CMD.FieldByName('ARF_ARTID').AsInteger,Que_CMD.FieldByName('TGFID').AsInteger,GK_FOUID);
              FieldByName('PXVTE').AsFloat       := GetPxVente(GK_MAGID, Que_CMD.FieldByName('ARF_ARTID').AsInteger,Que_CMD.FieldByName('TGFID').AsInteger);
              FieldByName('TVA').AsFloat         := Que_CMD.FieldByName('TVA').AsFloat;
              FieldByName('TGFID').AsInteger     := Que_CMD.FieldByName('TGFID').AsInteger;
              FieldByName('COUID').AsInteger     := Que_CMD.FieldByName('COUID').AsInteger;
              FieldByName('EAN').AsString        := aQue_Levis_T2.FieldByName('LEV_EAN').AsString;
            end;

            Post;

            // gestion de la TVA
            bAddTVA := True;
            if Length(TVA) <> 0 then
            begin
              for i := Low(TVA) to high(TVA) do
              begin
                if CompareValue(TVA[i].CDE_TVATAUX,FieldbyName('TVA').AsFloat,0.01) = EqualsValue then
                begin
                  bAddTVA := False;
                  With TVA[i] do
                  begin
                    //  attention il faut absolument prendre la quantité de la requete commande et pas celle du memdata
                    // sinon on multiplera de trop pour le calcul avec la QTE du memdata qui elle augmente dans le cas d'un
                    // même article sur plusieurs lignes
                    CDE_TVAHT := CDE_TVAHT + FieldByName('PXNN').AsFloat * Que_CMD.FieldByName('QTE').AsFloat;
                    CDE_TVA   := CDE_TVA + (FieldByName('PXNN').AsFloat * Que_CMD.FieldByName('QTE').AsFloat * TVA[i].CDE_TVATAUX / 100);
                  end;
                end;
              end;
            end;

            if bAddTVA then
            begin
              SetLength(TVA,Length(TVA) + 1);
              With TVA[Length(TVA) -1] do
              begin
                //  attention il faut absolument prendre la quantité de la requete commande et pas celle du memdata
                // sinon on multiplera de trop pour le calcul avec la QTE du memdata qui elle augmente dans le cas d'un
                // même article sur plusieurs lignes
                CDE_TVAHT   := FieldByName('PXNN').AsFloat * Que_CMD.FieldByName('QTE').AsFloat;
                CDE_TVATAUX := FieldByName('TVA').AsFloat;
                CDE_TVA     := FieldByName('PXNN').AsFloat * Que_CMD.FieldByName('QTE').AsFloat * FieldByName('TVA').AsFloat / 100;
              end;
            end;

            Que_CMD.Next;
          end; // with
        end;

        aQue_Levis_T2.Next;
        ProgBarArticle.Position :=  aQue_Levis_T2.RecNo * 100 Div  aQue_Levis_T2.RecordCount;
        Application.ProcessMessages;
      end; // while

      iLength := Length(TVA);
      SetLength(TVA,5);
      for i := iLength to high(TVA) do
      begin
        With TVA[i] do
        begin
          CDE_TVAHT := 0;
          CDE_TVATAUX := 0;
          CDE_TVA := 0;
        end;
      end;

      // Calcul du total de la commande
      for i := low(TVA) to high(TVA) do
        fTotalCde := fTotalCde + TVA[i].CDE_TVAHT;

      // Création de la commande
      if MemD_CMDTmp.RecordCount > 0 then
      begin

        // Si le montant total de la commande est inférieur au montant mini de commande on quitte
        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Montant Cde : ' + FormatFloat('0.00',fTotalCde));
        if fTotalCde < MainCFG.MntMiniCde then
        begin
          AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Montant commande mini non atteint');
          Exit;
        end;

        if aQue_MagList.FieldByName('MAG_CMDLEVIS').AsInteger = 1 then
          IBOTrans.StartTransaction;
        try
          GK_CHRONO := GetNewChronoCMD;

          if aQue_MagList.FieldByName('MAG_CMDLEVIS').AsInteger = 1 then
            GK_IDCMD := SetCommande(
                                  GK_CHRONO, // CDE_NUMERO: String;
                                  0, // CDE_SAISON,
                                  GetLastEXECOM, // CDE_EXEID,
                                  GetCDTPaiement(GK_FOUID,GK_MAGID), // CDE_CPAID,
                                  GK_MAGID, // CDE_MAGID,
                                  GK_FOUID, // CDE_FOUID: Integer;
                                  '', // CDE_NUMFOURN: String;
                                  dFile, // CDE_DATE: TDateTime;
                                  0, // CDE_REMISE,
                                  TVA[0].CDE_TVAHT, TVA[0].CDE_TVATAUX, TVA[0].CDE_TVA, // CDE_TVAHT1,CDE_TVATAUX1,CDE_TVA1,
                                  TVA[1].CDE_TVAHT, TVA[1].CDE_TVATAUX, TVA[1].CDE_TVA, // CDE_TVAHT2,CDE_TVATAUX2,CDE_TVA2,
                                  TVA[2].CDE_TVAHT, TVA[2].CDE_TVATAUX, TVA[2].CDE_TVA, // CDE_TVAHT3,CDE_TVATAUX3,CDE_TVA3,
                                  TVA[3].CDE_TVAHT, TVA[3].CDE_TVATAUX, TVA[3].CDE_TVA, // CDE_TVAHT4,CDE_TVATAUX4,CDE_TVA4,
                                  TVA[4].CDE_TVAHT, TVA[4].CDE_TVATAUX, TVA[4].CDE_TVA, // CDE_TVAHT5,CDE_TVATAUX5,CDE_TVA5 : single;
                                  0, // CDE_FRANCO,
                                  0, // CDE_MODIF: Integer;
                                  dFile + 1, // CDE_LIVRAISON: TDateTime;
                                  0, // CDE_OFFSET: integer;
                                  0, // CDE_REMGLO: single;
                                  0, // CDE_ARCHIVE: integer;
                                  0, // CDE_REGLEMENT: TDateTime;
                                  -101408014, // CDE_TYPID, (Réassort categ 1)
                                  0, // CDE_NOTVA,
                                  0, // CDE_USRID: integer;
                                  '' // CDE_COMENT: String;
                                 );

          // Elimination des lignes de commande à 0 ou moins en QTE
          With memD_CMDTmp do
          begin
            First;
            while not EOF do
            begin
              if FieldByName('QTE').AsFloat <= 0 then
                Delete
              else
                Next;
            end;
          end;
            
          // création des lignes de commande
          With MemD_CMDTmp do
          begin
            First;
            while not EOF do
            begin
             if aQue_MagList.FieldByName('MAG_CMDLEVIS').AsInteger = 1 then
               SetCommandeLigneId(
                                 GK_IDCMD, // CDL_CDEID,
                                 FieldByName('ARF_ARTID').AsInteger, // CDL_ARTID,
                                 FieldByName('TGFID').AsInteger, // CDL_TGFID,
                                 FieldByName('COUID').AsInteger, // CDL_COUID : integer;
                                 FieldByName('QTE').AsFloat, // CDL_QTE,
                                 0, // CDL_PXCTLG,
                                 0, // CDL_REMISE1,
                                 0, // CDL_REMISE2,
                                 0, // CDL_REMISE3,
                                 FieldByName('PXNN').AsFloat, // CDL_PXACHAT,
                                 FieldByName('TVA').AsFloat, // CDL_TVA,
                                 FieldByName('PXVTE').AsFloat, // CDL_PXVENTE: single;
                                 0, // CDL_OFFSET: integer;
                                 dFile + 1, // CDL_LIVRAISON: TDateTime;
                                 0, // CDL_TARTAILLE: integer;
                                 0 //CDL_VALREMGLO: single
                                );

              // Remplisssage du mem data pour la génération du CSV
              if MemD_CMD.Locate('EANCODE',MemD_CMDTmp.FieldByName('EAN').AsString,[loCaseInsensitive]) then
              begin
                MemD_CMD.Edit;
                MemD_CMD.FieldByName('Quantity').AsFloat := MemD_CMD.FieldByName('Quantity').AsFloat + FieldByName('QTE').AsFloat;
              end
              else begin
                MemD_CMD.Append;
                MemD_CMD.FieldByName('CONST').AsString         := 'SPORT2000 ' + MAG_CODE + ' ' + MAG_NOM;
//                MemD_CMD.FieldByName('MAG_CODE').AsString        := MAG_CODE;
//                MemD_CMD.FieldByName('MAG_LIB').AsString         := MAG_NOM;
                MemD_CMD.FieldByName('OrderNbr').AsString      := GK_CHRONO;
                MemD_CMD.FieldByName('OrderType').AsString     := 'RAO';
                MemD_CMD.FieldByName('OrderDate').AsString     := FormatDateTime('DD/MM/YY',dFile);
                MemD_CMD.FieldByName('ReqDelivDate').AsString  := FormatDateTime('DD/MM/YY',dFile + 1);
                MemD_CMD.FieldByName('LateDelivDate').AsString := FormatDateTime('DD/MM/YY',dFile + 1);
                MemD_CMD.FieldByName('EANCODE').AsString       := MemD_CMDTmp.FieldByName('EAN').AsString;
                MemD_CMD.FieldByName('Quantity').AsFloat       := FieldByName('QTE').AsFloat;
              end;
              MemD_CMD.Post;

              Next;
            end; // while
          end; // with
        Except on E:Exception do
          begin
            if aQue_MagList.FieldByName('MAG_CMDLEVIS').AsInteger = 1 then
              IBOTrans.Rollback;
            raise Exception.Create('CMD Creation -> ' + E.Message);
          end;
        end;

        // Envoi du mail
        if aQue_MagList.FieldByName('MAG_CMDLEVIS').AsInteger = 1 then
        begin
          if MemD_CMD.RecordCount > 0 then
          begin
            if (Trim(MainCFG.EMail.ExpMail) <> '') then
            Try
              if SendMail(GK_CHRONO,MAG_CODE,MAG_NOM,GK_MAGID) then
                AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Mail envoyé à ' + MainCFG.EMail.ExpMail);
            Except on E:Exception do
              begin
               IBOTrans.Rollback;
                raise exception.Create('Send Mail -> ' + E.Message);
              end;
            End
            else
              AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Send Mail Configuration incorrecte');
          end;
          IBOTrans.Commit;
        end;
      end; // if

      // Convertion en CSV
      if MemD_CMD.RecordCount > 0 then
      begin
        sFileName := 'ORDERS_SPORT2000_' + FormatDateTime('YYYYMMDD_hhmmss',dFile) + '.dat';

        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Génération du fichier CSV');
        Header.ConvertToCsv(MemD_CMD,GPATHSAVE + sFileName);
        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Fichier créé : ' + sFileName);
        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Nombre de lignes : ' + IntToStr(MemD_CMD.RecordCount));
      end
      else
        AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Pas de données pour le magasin');

      if MainCFG.Debug then
        iEtat := CETATKO
      else
      iEtat := CETATOK;

      Result := True;
    Except on E:Exception do
      begin
        AddToMemo(MAG_CODE + '/' + MAG_NOM + 'Export CMD -> ' + E.Message);
        iEtat := CETATKO;
      end;
    end;// with
  finally
    SaveHistoLevis(MAG_ID, CTYPECMD, iEtat, Gen_ID);
    Header.Free;
  end;
end;

function GetPxVente(MAG_ID,ART_ID,TGF_ID : integer) : Currency;
begin
  With DM_CMEL, Que_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select R_PRIX from GETPRIXDEVENTE(:PMAGID,:PARTID,:PTGFID)');
    ParamCheck := True;
    ParamByName('PMAGID').AsInteger := MAG_ID;
    ParamByName('PARTID').AsInteger := ART_ID;
    ParamByName('PTGFID').AsInteger := TGF_ID;
    Open;

    Result := FieldByName('R_PRIX').AsCurrency;
  end;
end;

function GetPxAchat(ART_ID,TGF_ID, FOU_ID : Integer) : Currency;
begin
  Result := 0;
  With DM_CMEL, Que_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select CLG_PX,CLG_PXNEGO from TARCLGFOURN');
    SQL.Add('Where CLG_ARTID = :PARTID');
    SQL.Add('  and CLG_FOUID = :PFOUID');
    SQL.Add('  and CLG_TGFID = :PTGFID');
    ParamCheck := True;
    ParamByName('PARTID').AsInteger := ART_ID;
    ParamByName('PFOUID').AsInteger := FOU_ID;
    ParamByName('PTGFID').AsInteger := TGF_ID;
    Open;

    if RecordCount <= 0 then
    begin
      Close;
      ParamByName('PARTID').AsInteger := ART_ID;
      ParamByName('PFOUID').AsInteger := FOU_ID;
      ParamByName('PTGFID').AsInteger := 0;
      Open;

      if Recordcount <= 0 then
        Exit;
    end;


    if FieldByName('CLG_PXNEGO').AsCurrency <> 0 then
      Result := FieldByName('CLG_PXNEGO').AsCurrency
    else
      Result := FieldByName('CLG_PX').AsCurrency;
  end;
end;

function SendMail(GK_CHRONO,MAG_CODE,MAG_NOM : String;GK_MAGID : Integer) : Boolean;
var
 IdMess : TIdMessage;
 sMail : String;
begin
  Result := False;
  With DM_CMEL do
  try
    With TIdSMTP.Create(nil) do
    try
      IdMess := TIdMessage.Create(nil);

    //            AuthType := atDefault;
      UserName := MainCFG.EMail.ExpMail;
      Password := MainCFG.EMail.Password;
      Host     := MainCFG.EMail.AdrSMTP;
      Port     := MainCFG.EMail.Port;

      Connect;

      IdMess.Subject := 'Nouvelle commande créée : ' + GK_CHRONO;
      tIdText(IdMess.MessageParts).ContentType := 'multipart/mixed';

      IdMess.Body.LoadFromFile(GPATHQRY + 'MailCMD.html');
      IdMess.Body.Text := StringReplace(IdMess.Body.Text,'@CMD@',GK_CHRONO,[rfReplaceAll]);

      With  TIdText.Create(IdMess.MessageParts) do
      begin
        ContentType := 'text/html';
        Body.Text := IdMess.Body.Text;
      end;

      With TIdAttachmentFile.Create(IdMess.MessageParts, GPATHIMG + 'logoCatman.png') do
      begin
        ContentType := 'image/png';
        FileIsTempFile := false;
        ContentDisposition := 'inline';
        ExtraHeaders.Values['content-id'] := 'logoCatman.png';
        DisplayName := 'logoCatman.png';
      end;

      With TIdAttachmentFile.Create(IdMess.MessageParts, GPATHIMG + 'logoGinkoia.png') do
      begin
        ContentType := 'image/png';
        FileIsTempFile := false;
        ContentDisposition := 'inline';
        ExtraHeaders.Values['content-id'] := 'logoGinkoia.png';
        DisplayName := 'logoGinkoia.png';
      end;

      sMail := GetMagMail(GK_MAGID);
      if (Trim(sMail) = '') or (MainCFG.Debug) then
        sMail  := 'thierry.fleisch@ginkoia.fr';

      IdMess.From.Text := MainCFG.EMail.ExpMail;
      IdMess.Recipients.EMailAddresses := sMail;
      Send(IdMess);
      AddToMemo(MAG_CODE + '/' + MAG_NOM + ' - Mail envoyé à ' + sMail);
    finally
      Free;
      IdMess.Free;
    end;
    Result := True;
  Except on E:Exception do
    raise Exception.Create(' SendMail -> ' + E.Message);
  end;
end;



end.
