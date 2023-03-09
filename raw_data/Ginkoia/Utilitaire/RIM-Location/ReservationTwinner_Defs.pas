unit ReservationTwinner_Defs;

interface

uses Windows,Classes, SysUtils, IdMessage, IdAttachment,  IdText,
     DateUtils, xml_unit, IcXmlParser, 
     dmReservation, ReservationType_Defs, R2D2, uIMAP4, ReservationResStr;
  const
    CTWINNER    = 'RESERVATION TWINNER';
    CTWINWORDDETECT = 'RESERVATION GINKOIA';

  // R�cup�re les mails pour savoir s'il vont �tre trait� ou non.
  function GenerateTwinnerMailList(MaCentrale : TGENTYPEMAIL;MaCfg : TCFGMAIL) : Boolean;
  // V�rifie que les mails sont bien valide.
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

  Result := False;
  Dm_Reservation.MemD_Mail.Close;
  Dm_Reservation.MemD_Mail.Open;

  if MaCfg.PBT_ADRPRINC = '' then
  begin
    Fmain.ologfile.Addtext('Veuillez configurer la partie @mail de Twinner');
    //InfoMessHP('Veuillez configurer la partie @mail de Twinner',True,0,0,'Erreur');

    Fmain.showmessagers('Veuillez configurer la partie @mail de Twinner', 'Erreur') ;

    Exit;
  end;


  IMAP4 := IMAP4Class.Create(Macfg.PBT_SERVEUR,Macfg.PBT_ADRPRINC,Macfg.PBT_PASSW,Macfg.PBT_PORT,True);
  IMAP4.PGStatus3D := Fmain.Gge_A;
  lstRep := TStringList.Create;
  lst := TStringList.Create;
  Try

    {$REGION 'Tentative de connexion}
    Count := 0;
    Repeat
      try
        Inc(Count) ;
        IMAP4.Connect;
        Fmain.oLogfile.Addtext(Format(RS_CONNEXION_OK_LOG, [MaCentrale.MTY_NOM]));
        break ;
      Except on E:Exception do
        begin
          if Count = Retry then
          begin
            Fmain.Ferrorconnect := True ;
            Fmain.oLogfile.Addtext(Format(RS_ERREUR_CONNEXION_LOG, [MaCentrale.MTY_NOM, Count, Retry, E.ClassName, E.Message]));
            Fmain.ShowmessageRS(Format(RS_ERREUR_CONNEXION_DLG, [MaCentrale.MTY_NOM, E.ClassName, E.Message]), 'Erreur');
            Exit;
          end
          else begin
            Sleep(Dm_Reservation.DelaisEssais);
          end;
        end;
      end;
    Until Retry=Count;
    {$ENDREGION}

    // R�cup�raiotn de la liste des magasins � traiter
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
            lstRep.Text := StringReplace(Trim(FieldByName('IDM_PRESTA').AsString),';',#13#10,[rfReplaceAll]);
            for i := 0 to lstRep.Count - 1 do
            begin
              Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'R�cup�ration des mails',[MaCentrale.MTY_NOM,RecNo,Recordcount,i + 1, lstRep.Count]),100);
              // Positionnement dans le r�pertoire (On passe � la suite s'il n'existe pas) 
              if not IMAP4.SelectMailBox('Reservation/' + Trim(lstRep[i])) then
                Continue;

              // R�cup�ration des mails du r�pertoire
              IMAP4.LoadAllMailBoxMsg;

              Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Sauvegarde des mails',[MaCentrale.MTY_NOM,RecNo,Recordcount, i+1, lstRep.Count]),100);
              for j := 0 to IMAP4.MsgList.Count - 1 do
              begin
                // On r�cup�re un maximum d'information du mail + r�cup�ration de la pi�ce jointe
                With Dm_Reservation,MemD_Mail do
                begin
                  // d�coupe le sujet pour r�cup�rer l'id magasin et le num�ro de r�servation
                  With TStringList.Create do
                  try
                    Text    := StringReplace(Trim(IMAP4.MsgList[j].Subject),' ',#13#10,[rfReplaceAll]);
                    // Apr�s stringreplace on a dans la stringlist
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

                    Try
                      Post;
                      // Sauvegarde de la pi�ce jointe;  sauveagrd� par R2D2;
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
      else
        exit; // pas de r�pertoire � traiter
    end;
    Result := True;
  Finally
    lst.Free;
    Fmain.ResetGauge ;
    IMAP4.Free;
    LstRep.Free;
  End;

//          // On r�cup�re un maximum d'information du mail + r�cup�ration de la pi�ce jointe
//          {$REGION '<---- cliquez sur le + et lire avant de modifier le code ci dessous'}
//            // La sauvegarde du fichier sur le disc dur + le traitement ne doivent pas �tre modifi�s
//            // car les mails transmis par twinner ont des soucis de format qui sont corrig�s
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
  // V�rification que les mails sont bien valide
  CheckTwinnerMail;

  // V�rification de la partie OC des mails
  Result := Dm_Reservation.CheckOC(MaCentrale);
end;

procedure CheckTwinnerMail;
var
  lst : TStringList;
begin
  lst := TStringLisT.Create;
  With Dm_Reservation do
  try
    With MemD_Mail do
    begin
      First;
      while not EOF do
      begin
        if FieldByName('bTraiter').asBoolean then
        begin
          lst.LoadFromFile(GPATHMAILTMP + FieldByName('MailAttachName').AsString);
          // On v�rifie que le fichier poss�de au moins une des balises attendu
          Edit;
          // On met � jour le Dxmemdata pour indiquer que le fichier sera � traiter ou non.
          if Pos('</fiche>',lst.text) > 1 then
            FieldByName('bTraiter').AsBoolean := True
          else
            FieldByName('bTraiter').AsBoolean := False;
          Post;
        end;
        Next;
      end; // while
    end; // with
  finally
    lst.Free;
    lst := nil ;
  end; // with / try
end;

end.