unit ReservationTwinner_Defs;

interface

uses Windows,Classes, SysUtils, IdMessage, IdAttachment,  IdText,
     DateUtils, xml_unit, IcXmlParser, 
     dmReservation, ReservationType_Defs, R2D2, uIMAP4, ReservationResStr,StdUtils;
  const
    CTWINNER    = 'RESERVATION TWINNER';
    CGOSPORT    = 'RESERVATION GOSPORT';
    CTWINWORDDETECT = 'RESERVATION GINKOIA';

  // Récupère les mails pour savoir s'il vont être traité ou non.
  function GenerateTwinnerMailList(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;
  // Vérifie que les mails sont bien valide.
  procedure CheckTwinnerMail;
  // Fonction principale de traitement des mails
  function ExecuteTwinnerDoTraitement(MaCentrale : TGENTYPEMAIL) : Boolean;

implementation
uses Main ;


function GenerateTwinnerMailList(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;
const
  Retry = 3;
var
  Count : integer ; // pour tester les essais
  Account : Taccount ;
  IdPop  : Tpop3Client ;
  IdMess : TIdMessage;
  i, iNbMess, j, iDeb, iFin : integer;
  sIdMag,sIdResa : String;
  sFileName : String;
  lst : TStringList;
  bResaExist : Boolean;

  IMAP4 : IMAP4Class;
  lstRep : TStringList;
begin

  //PDB
  Try
  Try

  Result := False;
  Dm_Reservation.MemD_Mail.Close;
  Dm_Reservation.MemD_Mail.Open;

  if MaCfg.PBT_ADRPRINC = '' then
  begin
    Fmain.ologfile.Addtext('Veuillez configurer la partie @mail de Twinner');
    //InfoMessHP('Veuillez configurer la partie @mail de Twinner',True,0,0,'Erreur');

    Fmain.showmessagers('Veuillez configurer la partie @mail de Twinner', 'Erreur') ;
    Fmain.trclog('TLa partie e-mail de "Twinner" n''est pas configurée.');
//    Fmain.trclog('Q-');
    Exit;
  end;

  IMAP4 := IMAP4Class.Create(Macfg.PBT_SERVEUR,Macfg.PBT_ADRPRINC,Macfg.PBT_PASSW,Macfg.PBT_PORT,True);
  IMAP4.PGStatus3D := Fmain.Gge_A;
  lstRep := TStringList.Create;
  lst := TStringList.Create;
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
//            Fmain.trclog('Q-');

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

    // Récupéraiotn de la liste des magasins à traiter
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
              // Positionnement dans le répertoire (On passe à la suite s'il n'existe pas) 
              if not IMAP4.SelectMailBox('Reservation/' + Trim(lstRep[i])) then
              begin
                scodeadh := Trim(lstRep[i]);
//                Fmain.trclog('GPas de correspondance du code adhérent '+Trim(lstRep[i])+' - Pas de boîte mail "Reservation/' + Trim(lstRep[i])+'"');
                Fmain.trclog('GPas de réservation pour le magasin '+dm_reservation.Que_TmpLoc.FieldByName('MAG_NOM').asstring+ '(Code adhérent '+Trim(lstRep[i])+')');
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
                    // 3- L'id Reservation
                    sIdMag  := Strings[2];
                    sIdResa := Strings[3];
                  finally
                    Free;
                  end; // try

                  // On va stocker les informations temporairement dans un TdxMemData pour la suite du traitement
                  //sFilename := IdMess.MessageParts.Items[j].FileName ;
                  //sFilename := GPATHMAILTMP + sFilename ;
                  if R2D2.DecodeMessage(IMAP4.MsgList[j], GPATHMAILTMP, 2, sFileName) = True then
                  Begin
                    Append;
                    FieldByName('MailId').AsInteger        := j + 1;
                    FieldByName('MailSubject').AsString    := IMAP4.MsgList[j].Subject;
                    FieldByName('MailAttachName').AsString := sFileName;
                    FieldByName('MailIdMag').AsString      := sIdMag;
                    FieldByName('MailIdResa').AsString     := sIdResa;
                    FieldByName('MailDate').AsDateTime     := IMAP4.MsgList[j].Date;
                    FieldByName('bTraiter').AsBoolean      := True;
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

                      lst.LoadFromFile(GPATHMAILTMP + sFileName);
                      lst.text := Trim(lst.text); // suppression du 1er LF au debut
                      iFin := Pos('<fiche>',lst.text) - 1;
                      if iFin > 0 then
                      begin
                        lst.Text := StringReplace(lst.text,Copy(lst.text,1,iFin),Trim(Copy(lst.Text,1,iFin)),[]);
                        lst.SaveToFile(GPATHMAILTMP + sFileName);
                      end;

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
        Fmain.trclog('TGenerateTwinnerMailList-MemD_Mail.recordcount='+inttostr(Dm_Reservation.MemD_Mail.recordcount));
      end
      else begin
        Fmain.trclog('TPas de répertoire à traiter');
        exit; // pas de répertoire à traiter
      end;
    end;
    Result := True;
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans GenerateTwinnerMailList : '+e.message);
  end;
  //
  Finally
    lst.Free;
    Fmain.ResetGauge ;
    IMAP4.Free;
    LstRep.Free;
  End;

//          // On récupère un maximum d'information du mail + récupération de la pièce jointe
//          {$REGION '<---- cliquez sur le + et lire avant de modifier le code ci dessous'}
//            // La sauvegarde du fichier sur le disc dur + le traitement ne doivent pas être modifiés
//            // car les mails transmis par twinner ont des soucis de format qui sont corrigés
//            // Par l'utilisation de la sauvegarde tempporaire + nettoyage du mail.
//          {$ENDREGION}
//          IdMess.NoEncode := True;
//          IdMess.NoDecode := True;
//          IdPop.Pop3.Retrieve(i,IdMess);
//
//          IdMess.SaveToFile(GPATHMAILTMP + 'Tmp.txt');
//
//          lst.LoadFromFile(GPATHMAILTMP + 'Tmp.txt');
//          lst.Text := StringReplace(lst.Text,#13#13#10,#13#10,[rfReplaceAll]);
//          lst.SaveToFile(GPATHMAILTMP + 'Tmpb.txt');
//
//          IdMess.NoEncode := False;
//          IdMess.NoDecode := False;
//          IdMess.LoadFromFile(GPATHMAILTMP + 'Tmpb.txt');
//
//  Finally
//
//    if FileExists(GPATHMAILTMP + 'Tmp.txt') then
//      DeleteFile(GPATHMAILTMP + 'Tmp.txt');
//    if FileExists(GPATHMAILTMP + 'Tmpb.txt') then
//      DeleteFile(GPATHMAILTMP + 'Tmpb.txt');
//
//  End;
end;

function ExecuteTwinnerDoTraitement(MaCentrale : TGENTYPEMAIL) : Boolean;
begin
  // Vérification que les mails sont bien valide
  CheckTwinnerMail;

  // Vérification de la partie OC des mails
  Result := Dm_Reservation.CheckOC(MaCentrale);
end;

procedure CheckTwinnerMail;
var
  lst : TStringList;
begin
  lst := TStringLisT.Create;
  With Dm_Reservation do
  //PDB
  try
  try
    With MemD_Mail do
    begin
      First;
      while not EOF do
      begin
        if FieldByName('bTraiter').asBoolean then
        begin
          try

            lst.LoadFromFile(GPATHMAILTMP + FieldByName('MailAttachName').AsString);

            // On vérifie que le fichier possède au moins une des balises attendu
            Edit;
            // On met à jour le Dxmemdata pour indiquer que le fichier sera à traiter ou non.
            if Pos('</fiche>',lst.text) > 1 then
              FieldByName('bTraiter').AsBoolean := True
            else
              FieldByName('bTraiter').AsBoolean := False;
            Post;

          except
            on e:exception do begin
              Edit;
              FieldByName('bTraiter').AsBoolean    := False;
              Post;
              Fmain.trclog('XErreur dans CheckTwinnerMail-1 : '+e.message);
            end;
          end;

        end;
        Next;
      end; // while
    end; // with
  //PDB
  except
    on e:exception do Fmain.trclog('XErreur dans CheckTwinnerMail-2 : '+e.message);
  end;
  //
  finally
    lst.Free;
    lst := nil ;
  end; // with / try
end;

end.
