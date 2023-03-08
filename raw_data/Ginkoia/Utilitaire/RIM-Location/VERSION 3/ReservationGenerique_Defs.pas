unit ReservationGenerique_Defs;

interface

uses Classes, SysUtils,  IdMessage, IdAttachment,  IdText,
     DateUtils, xml_unit, IcXmlParser, 
     IdMessageClient,
     dmReservation, ReservationType_Defs, ReservationResStr, StdUtils,
     uLogfile, R2D2, uIMAP4, dbugintf;

const
  CGENE1 = 'RESERVATION GENERIQUE - 1';
  CGENE2 = 'RESERVATION GENERIQUE - 2';
  CGENE3 = 'RESERVATION GENERIQUE - 3';
  CGENEWORDDETECT = 'RESERVATION GENERIQUE';


  // Récupère les mails pour savoir s'il vont être traité ou non.
  function GenerateGENMailList(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;
    // Vérifie que les mails sont bien valide.
  procedure CheckGENMail(MaCentrale : TGENTYPEMAIL; MaCfg : TCFGMAIL);
  // Fonction principale de traitement des mails
  function ExecuteGENDoTraitement(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;


implementation


Uses Main ;



function GenerateGENMailList(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;
const
  Retry = 3;
var
  Account : TAccount ;
  Count : integer ; // pour tester les essais
  IdPop  : Tpop3Client ;
  IdMess : TIdMessage;
  i, iNbMess, j : integer;
  sIdMag,sIdResa : String;
  sFileName : String;
  IMAP4 : IMAP4Class;
  lstRep : TStringList;
begin

  try
  try

  Result := False;
  Dm_Reservation.MemD_Mail.Close;
  Dm_Reservation.MemD_Mail.Open;

  if MaCfg.PBT_ADRPRINC = '' then
  begin
    // 'Veuillez configurer la partie @mail de §0','Erreur'
    //InfoMessHP(ParamsStr(RS_ERR_RESCMN_CFGMAIL,MaCentrale.MTY_NOM),True,0,0,RS_TXT_RESCMN_ERREUR);
    Fmain.ologfile.Addtext(ParamsStr(RS_ERR_RESCMN_CFGMAIL,MaCentrale.MTY_NOM));
    Fmain.Showmessagers(ParamsStr(RS_ERR_RESCMN_CFGMAIL,MaCentrale.MTY_NOM), RS_TXT_RESCMN_ERREUR);
    Fmain.trclog('T'+ParamsStr(RS_ERR_RESCMN_CFGMAIL_TRC,MaCentrale.MTY_NOM));
    Fmain.trclog('Q-');

    Fmain.p_maj_etat('Erreur d''intégration'+ ' : '+formatdatetime('dd/mm/yyyy hh:nn',vdebut_exec) );

    Exit;
  end;

  IMAP4 := IMAP4Class.Create(Macfg.PBT_SERVEUR,Macfg.PBT_ADRPRINC,Macfg.PBT_PASSW,Macfg.PBT_PORT,True);
  IMAP4.PGStatus3D := Fmain.Gge_A;
  lstRep := TStringList.Create;
  //Try //PDB

    {$REGION 'Tentative de connexion}
    Count := 0;
    Repeat
      try
        Inc(Count) ;
        IMAP4.Connect;  
        //Fmain.oLogfile.Addtext(Format(RS_CONNEXION_OK_LOG, [MaCentrale.MTY_NOM]));
        break ;
      Except on E:Exception do
        begin
          if Count = Retry then
          begin
            Fmain.Ferrorconnect := True ;
            Fmain.oLogfile.Addtext(Format(RS_ERREUR_CONNEXION_LOG, [MaCentrale.MTY_NOM, Count, Retry, E.ClassName, E.Message]));
            Fmain.ShowmessageRS(Format(RS_ERREUR_CONNEXION_DLG, [MaCentrale.MTY_NOM, E.ClassName, E.Message]), 'Erreur');
            Fmain.trclog('T'+RS_ERREUR_CONNEXION_DLG_TRC+': '+E.Message);
            Fmain.trclog('Q-');

            Fmain.p_maj_etat('Erreur d''intégration'+ ' : '+formatdatetime('dd/mm/yyyy hh:nn',vdebut_exec) );

            Exit;
          end
          else begin
            Sleep(Dm_Reservation.DelaisEssais);
          end;
        end;
      end;
    Until Retry=Count;
    {$ENDREGION}


    // Récupération de la liste des magasins à traiter
    Fmain.trclog('T**Récupération de la liste des magasins à traiter');
    With dm_reservation.Que_IdentMagExist do
    begin
      Close;
      ParamCheck := True;
      ParamByName('PMtyId').AsInteger := MaCfg.PBT_MTYID;
      Open;

      if (Recordcount > 0) then
      begin
        while not EOF do
        begin
          if ((MaCentrale.MTY_MULTI <> 0) and (dm_reservation.POSID = FieldByName('IDM_POSID').AsInteger)) Or
             (MaCentrale.MTY_MULTI = 0) then
          begin

            dm_reservation.Que_TmpLoc.Close;
            dm_reservation.Que_TmpLoc.SQL.Clear;
            dm_reservation.Que_TmpLoc.SQL.Add('Select MAG_NOM');
            dm_reservation.Que_TmpLoc.SQL.Add(' FROM GENMAGASIN');
            dm_reservation.Que_TmpLoc.SQL.Add(' WHERE MAG_ID='+inttostr(FieldByName('IDM_MAGID').asinteger));
            dm_reservation.Que_TmpLoc.ExecSQL;
            Fmain.trclog('T*Magasin : '+dm_reservation.Que_TmpLoc.FieldByName('MAG_NOM').asstring);

            lstRep.Text := StringReplace(Trim(FieldByName('IDM_PRESTA').AsString),';',#13#10,[rfReplaceAll]);

            if lstRep.Count=0 then begin

              //Uniquement mentionner ce cas dans le tracing, et pas dans le diagnostic
              Fmain.trclog('TAucun identifiant/code adhérent n''est défini pour le magasin '+dm_reservation.Que_TmpLoc.FieldByName('MAG_NOM').asstring);

            end;

            for i := 0 to lstRep.Count - 1 do
            begin
              Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Récupération des mails',[MaCentrale.MTY_NOM,RecNo,Recordcount,i + 1, lstRep.Count]),100);
              Fmain.trclog('T'+Format('%s %d sur %d : Code %d/%d'#13#10'Récupération des mails',[MaCentrale.MTY_NOM,RecNo,Recordcount,i + 1, lstRep.Count]));
              main.scodeadh:= Trim(lstRep[i]);
              // Positionnement dans le répertoire (On passe à la suite s'il n'existe pas
              if not IMAP4.SelectMailBox('Reservation/' + Trim(lstRep[i])) then
              begin
                scodeadh := Trim(lstRep[i]);
                Fmain.trclog('GPas de correspondance du code adhérent '+Trim(lstRep[i])+' - Pas de boîte mail "Reservation/' + Trim(lstRep[i])+'"');
                main.berreur_codeadh := true;
                Continue;
              end;

              // Récupération des mails du répertoire
              IMAP4.LoadAllMailBoxMsg;

              Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Sauvegarde des mails',[MaCentrale.MTY_NOM,RecNo,Recordcount, i+1, lstRep.Count]),100);
              Fmain.trclog('T'+Format('%s %d sur %d : Code %d/%d'#13#10'Sauvegarde des mails',[MaCentrale.MTY_NOM,RecNo,Recordcount, i+1, lstRep.Count]));
              for j := 0 to IMAP4.MsgList.Count - 1 do
              begin
                // On récupère un maximum d'information du mail + récupération de la pièce jointe
                With Dm_Reservation,MemD_Mail do
                begin
                  // découpe le sujet pour récupèrer l'id magasin et le numéro de réservation
                  With TStringList.Create do
                  try
                    Text    := StringReplace(Trim(IMAP4.MsgList[j].Subject),' ',#13#10,[rfReplaceAll]);
                    // Après stringreplace on a dans la stringlist
                    // 0- Reservation
                    // 1- GINKOIA
                    // 2- L'id Magasin
                    // 3- NUMERO
                    // 4- L'id Reservation
                    sIdMag  := Strings[2];
                    sIdResa := Strings[4];
                  finally
                    Free;
                  end; // try

                  // On va stocker les informations temporairement dans un TdxMemData pour la suite du traitement
                  //sFilename := IdMess.MessageParts.Items[j].FileName ;
                  //sFilename := GPATHMAILTMP + sFilename ;
                  if R2D2.DecodeMessage(IMAP4.MsgList[j], GPATHMAILTMP, 3, sFileName) = True then
                  Begin
                    Append;
                    FieldByName('MailId').AsInteger        := j + 1;
                    FieldByName('MailSubject').AsString    := IMAP4.MsgList[j].Subject;
                    FieldByName('MailAttachName').AsString := sFileName;
                    FieldByName('MailIdMag').AsString      := sIdMag;
                    FieldByName('MailIdResa').AsString     := sIdResa;
                    FieldByName('MailDate').AsDateTime     := IMAP4.MsgList[j].Date;
                    FieldByName('bTraiter').AsBoolean      := False;
                    FieldByName('bArchive').AsBoolean      := False ;
                    if Fmain.Falgol = False then
                      FieldByName('bArchive').AsBoolean      :=  True; // on archive dans tous les cas   //(Abs(DaysBetween(Now,GetDateFromK(sIdResa))) >= MaCfg.PBT_ARCHIVAGE);
                    FieldByName('bAnnulation').AsBoolean   := False;
                    FieldByName('bVoucher').AsBoolean      := False;

                    FieldByName('scodeadh').AsString := main.scodeadh;

                    Try
                      Post;
                      // Sauvegarde de la pièce jointe;  sauveagrdé par R2D2;
                      //TIdAttachment(IdMess.MessageParts.Items[j]).SaveToFile(GPATHMAILTMP + sFileName);
                    Except on E:Exception do
                      begin
                        // A voir selon
                        //PDB
                        Fmain.trclog('X'+ParamsStr(RS_ERR_RESCMN_SAVEMAIL_TRC,MaCentrale.MTY_NOM)+e.message);
                      end;
                    End; // try
                  end; // if R2D2 ;
                end; // with


                Fmain.Gge_A.Progress := (j + 1) * 100 DIV (IMAP4.MsgList.Count);
                FMain.Refresh;
              end; // for j
            end; // for i

          end;
          Next;
        end;
      end
      else begin
        Fmain.trclog('TPas de répertoire à traiter');
        exit; // pas de répertoire à traiter
      end;
    end;
    Result := True;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans GenerateGENMailList : '+e.message);
  end;
  Finally
    Fmain.ResetGauge ;
    IMAP4.Free;
    LstRep.Free;
  End;

end;

procedure CheckGENMail(MaCentrale : TGENTYPEMAIL; MaCfg : TCFGMAIL);
var
  lst : TStringList;
  MonXml : TmonXML;
  nReservationXml : TIcXMLElement;
  bAnnulation : Boolean;
  bVoucher    : Boolean;
  iPosition   : Integer;
  sIdResa     : String;
begin
  lst := TStringList.Create;
  MonXml := TmonXML.Create;

  try
  try

  With Dm_Reservation do
  begin

    With MemD_Mail do
    begin

      First;
      while not EOF do
      begin
        lst.LoadFromFile(GPATHMAILTMP + FieldByName('MailAttachName').AsString);
        // On vérifie que le fichier possède au moins une des balises attendu
        if Pos('</fiche>',lst.text) > 1 then
        begin
          try

            // On charge le fichier pour vérifié si c'est une annulation
            //PDB
            try
              MonXml.loadfromstring(lst.text);
            Except
              //on E:Exception do Fmain.trclog('FErreur XML : '+e.message);
            end;

            nReservationXml := MonXml.find('/fiche/reservation');
            // si c'est une annulation on ne traitera pas le fichier
            bAnnulation := (MonXml.ValueTag(nReservationXml,'annulation') = 'O');
            bVoucher    := (MonXml.ValueTag(nReservationXml,'voucher') = 'O');

                if not bAnnulation
                  then senddebug('>>>Ce n''est pas une annulation')
                  else senddebug('>>>C''est une annulation');

            // On met à jour le Dxmemdata.
            Edit;
            if bAnnulation then
            begin
              FieldByName('bAnnulation').AsBoolean := true;
              // Si c'est une annulation, est ce que la reservation existe encore ?
              if Dm_Reservation.IsReservationExist(FieldByName('MailIdResa').AsString)
              then begin
                senddebug('+++Annulation + résa existe -> annulation normale');
                FieldByName('bTraiter').AsBoolean    := true
              end
              else begin
                senddebug('+++Annulation d''une résa inexistante');
                FieldByName('bTraiter').AsBoolean    := false;
              end;
            end else
            begin
              FieldByName('bAnnulation').AsBoolean := false;
              // On vérifie que la réservation n'a pas déjà été traité
              //if not Dm_Reservation.IsReservationExist(FieldByName('MailIdResa').AsString)
              //PDB...en tenant compte de la Centrale
              if not Dm_Reservation.IsReservationExistMulti(FieldByName('MailIdResa').AsString,-1,MaCentrale.MTY_ID)
                then begin
                  senddebug('+++Création normale d''une résa');
                  FieldByName('bTraiter').AsBoolean    := True;
                end
                else begin
                  senddebug('+++Résa déjà existante');
                  FieldByName('bTraiter').AsBoolean    := False;
                end;
            end;

            FieldByName('bVoucher').AsBoolean    := bVoucher;
            Post;

           if bAnnulation and dm_reservation.ReservationInMemory(MemD_Mail, FieldByName('MailIdResa').AsString) then
           begin
             Edit;
             FieldByName('bTraiter').AsBoolean    := False;
             FieldByName('bArchive').AsBoolean    := False;
              FieldByName('bAnnulation').AsBoolean := True;
             Post;
           end;


          Except on E:Exception do
            begin
              Edit;
              FieldByName('bTraiter').AsBoolean    := False;
              Post;
              Fmain.trclog('XErreur dans CheckGENMail-1 : '+e.message);
            end;

          end;

        end;
        Next;

      end; // while
    end; // with

  end;

  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans CheckGENMail-2 : '+e.message);
  end;

  finally
    lst.Free;
    MonXml.Free;
    lst := nil ;
    MonXml := nil ;
  end;

end;

function ExecuteGENDoTraitement(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;
begin
  // Vérification que les mails sont bien valide
  CheckGENMail(MaCentrale, MaCfg);

  // Vérification de la partie OC des mails
  Result := Dm_Reservation.CheckOC(MaCentrale);
end;


end.
