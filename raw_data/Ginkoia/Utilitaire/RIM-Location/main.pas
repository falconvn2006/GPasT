unit main ;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ReservationResStr, dmReservation, ReservationType_Defs,
  strUtils, ReservationSport2k_Defs, uLOgfile, ReservationSkimium_Defs, ReservationTwinner_Defs,
  ReservationGenerique_Defs, ReservationInterSport_Defs, Main_dm,
  IdMessage, IdAttachment, stdutils, R2D2, StdCtrls, RzLabel, Progbr3d,
  LMDControl, LMDBaseControl, LMDBaseGraphicButton, LMDCustomSpeedButton,
  LMDSpeedButton, ExtCtrls, RzPanel, messagebox_frm, IdBaseComponent, IdCoder,
  IdCoder3to4, IdCoderMIME, Shellapi, IdAntiFreezeBase, IdAntiFreeze, ImgList, uImap4, DB;

type
  TFmain = class(TForm)
    Pan_Fond: TRzPanel;
    Pan_Btn: TRzPanel;
    Gge_A: ProgressBar3D;
    Pan_Text: TRzPanel;
    Memo_Mess: TRzLabel;
    IdAntiFreeze: TIdAntiFreeze;
    Lim_lstimage: TImageList;
    TrayIcon1: TTrayIcon;
    procedure ExecuteTraitementReservation ;
    Procedure ArchivMail(MaCentrale : TGENTYPEMAIL;MaCFG : TCFGMail);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    
  private
    { Déclarations privées }
    procedure FindeSessionWindows(var aMsg : Tmessage); message WM_ENDSESSION ;
  public
    { Déclarations publiques }
  oLogfile : Tlogfile ;
  Fdatabase : string ;
  FAuto : boolean  ; // mode auto = true mode ginkoia = false
  FPostid, Fmagid : integer ; 
  FAlgol : boolean ;
  Ferrorconnect : boolean ; // pour distinguer l'erreur de connexion de l'erreur de traitement
  
  procedure SetDatabase(sDatabase : string) ;    
  procedure InitGauge(sMessage : string ;MaxValue : integer) ;
  procedure UpdateGauge ;
  procedure ResetGauge ;

  procedure ShowmessageRS(sMessage, sTitle : string) ;
  end;

var
  Fmain: TFmain;

implementation

{$R *.dfm}

procedure TFmain.FindeSessionWindows(var aMsg: TMessage);
var oMsg : Tform ;
begin
  Try
   oMsg := CreateMessageDialog('Le module d''intégration des réservations est en cours d''exécution',mtWarning,[mbOk]) ;
   oMsg.ShowModal ;
  Finally
    oMsg.Release ;
    oMsg := nil ;
  End;
end;



Procedure TFmain.SetDatabase(sDatabase : string);
var sflog : string ; // nom du fichier log
    bLaunch : boolean ;
begin
  if paramstr(1) = '/M' then
   ologfile.Addtext(RS_RESERVATION_START+' Ginkoia') else
   begin
    ologfile.Addtext(RS_RESERVATION_START+' Automatique');
    FAuto := True ;
   end;


   if paramstr(5) = '1' then
      FAlgol := True else FAlgol := False ;
    
  Fdatabase :=  sDatabase ;

  if dm_main.InitDatabase(Fdatabase, 'ginkoia', 'ginkoia') then
   begin
    Try
      //if paramstr(1) = '/M' then visible := True ;
      Visible := True ; // visible dans tous les cas
      application.ProcessMessages ;
      
      Try
       ExecuteTraitementReservation ;
       dm_main.Database.CloseTransactions ;
       dm_main.Database.close ;
      Except
      End;
      Sendmessage(handle, WM_CLose, 0, 0) ;
    Finally
       oLogfile.Addtext( RS_RESERVATION_END );
       bLaunch := oLogfile.Count > 2 ;
       sFlog := IncludeTrailingPathDelimiter(Extractfilepath(paramstr(0)))+'LOG_RIM\' ;
       ologfile.SaveToFile(sflog);  // passe le chemin d'enregistrement
       if blaunch then
        begin
         sFlog := oLogfile.fichierlog ;
         Shellexecute(handle, 'open', 'Notepad.exe', pchar(sFlog), nil, SW_NORMAL) ;
        end;
    End;
   end else
   begin
      ologfile.Addtext(RS_ERR_RESMAN_DATABASE);
   end;
   oLOgfile.Free ;
   oLOgfile := nil ;
   application.terminate ;
end;




Procedure TFmain.ExecuteTraitementReservation;
var FListCentrale  : TListGENTYPEMAIL;
    i : integer ;
    MaCFG          : TCFGMAIL;
    bAutorisation, bDoreservation, bDotraitement, bResaok : boolean ;
    bAnnulok : boolean ;
    lSearchRecord  : TSearchRec;
    s : string ;
begin
  // fonction récupérée de Ginkoia

  With Dm_Reservation do
  Begin
    MemD_Rap.Close;
    MemD_Rap.Open;

  // répertoire temporaire pour récupérer les fichiers
   GPATHMAILTMP := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'MailImportTmp\';
   ForceDirectories(GPATHMAILTMP);

   FListCentrale := dm_reservation.GetListCentrale ;

      for I := 0 to FlistCentrale.Count-1  do
       begin
          dm_reservation.PosID := FPostid;
          case FListCentrale.Items[i].MTY_MULTI of
            // poste référant uniquement
            0: bAutorisation := (FPostID = GetPostReferantId);
            // magasin uniquement
            1: bAutorisation := IsMagAutorisation(FListCentrale.Items[i].MTY_ID,FMagID, FPostID);
          end;
         if bAutorisation then
          begin
           MaCFG := dm_reservation.GetMailCFG(FListCentrale.Items[i]);
           // 2- Vérification des mails de la centrale en cours
           // Cxxxxx correspondent à des constantes qui sont l'identique du nom dans la base de données
           // De la table GENTYPEMAIL
           case AnsiIndexStr(FListCentrale.Items[i].MTY_NOM,[CTWINNER,CINTERSPORT,CSKIMIUM,CSPORT2K,CGENE1,CGENE2,CGENE3]) of
             0: begin
                  bDoReservation := GenerateTwinnerMailList(FListCentrale.Items[i],MaCFG); // Twinner
                end ;
             1: begin
                  bDoReservation := GenerateISMailList(FListCentrale.Items[i],MaCFG); // Intersport
                end ;
             2: begin
                 bDoReservation := GenerateSkmMailList(FListCentrale.Items[i],MaCFG); // Skimium
                end ;
             3: begin
                  bDoReservation := GenerateSport2kMailList(FListCentrale.Items[i],MaCFG); // Sport2000
                end ;
             4,5,6 : bDoReservation := GenerateGENMailList(FListCentrale.Items[i],MaCFG); // Gen1, Gen2,Gen3
             else
               // 'Aucune centrale trouvée', 'Erreur'
               ologfile.Addtext(RS_ERR_RESMAN_NOCENTRALE);
                   // affichage message
               ShowmessageRS('Aucune centrale trouvée', 'Erreur');

               Exit;
           end;   // encase

           // Si il n'y a pas eu de soucis avec la validation des mails de la centrale on passe à la suite
           if bDoReservation then
           begin
             // 3- Traitement des réservations de la centrale en cours
             case AnsiIndexStr(FListCentrale.Items[i].MTY_NOM,[CTWINNER,CINTERSPORT,CSKIMIUM,CSPORT2K,CGENE1,CGENE2,CGENE3]) of
               0: bDoTraitement := ExecuteTwinnerDoTraitement(FListCentrale.Items[i]); // Twinner
               1: bDoTraitement := True; // Intersport - Sera vérifié et traité en même temps que l'intégration
               2: bDoTraitement := ExecuteSkmDoTraitement(FListCentrale.Items[i],MaCFG); // Skimium
               3: bDoTraitement := ExecuteSport2KDoTraitement(FListCentrale.Items[i],MaCFG); // Sport2000
               4,5,6: bDoTraitement := ExecuteGENDoTraitement(FListCentrale.Items[i],MaCFG); // Gen1, Gen2,Gen3
             end;

             // Si le traitement des réservations c'est bien passé alors on va les intégrer
             if bDoTraitement then
             begin
               // 4- Intégration des Réservations dans la base de données
               case AnsiIndexStr(FListCentrale.Items[i].MTY_NOM,[CTWINNER,CINTERSPORT,CSKIMIUM,CSPORT2K,CGENE1,CGENE2,CGENE3]) of
                 0,2,3,4,5,6: bResaOk := CreateResa(FListCentrale.Items[i]); //Twinner, Skimium, Sport2k, Gen1,Gen2, Gen3
                 1: bResaOk := DoCreateReservationIS(FListCentrale.Items[i],MaCFG); // Intersport
               end;

               // 5- Traitement des annulations
               case AnsiIndexStr(FListCentrale.Items[i].MTY_NOM,[CTWINNER,CINTERSPORT,CSKIMIUM,CSPORT2K,CGENE1,CGENE2,CGENE3]) of
                 2,3,4,5,6: bAnnulOk := AnnulResa; // Sport2000, Skimium, Gen1, Gen2, Gen3
                 else
                   bAnnulOk := True;
               end; // case annulation

               // 6- Archivage des mails
               // Archivage si l'intégration et/ou l'annulation des réservations c'est bien faite et si on a une adresse d'archivage
               if bResaOk and bAnnulOk and (MaCFG.PBT_ADRARCH <> '') then
               begin
                 // traitement des mails à archiver
                  case AnsiIndexStr(FListCentrale.Items[i].MTY_NOM,[CTWINNER,CINTERSPORT,CSKIMIUM,CSPORT2K,CGENE1,CGENE2,CGENE3]) of
                    1: ArchiveMailIS(FListCentrale.Items[i],MaCFG); // intersport
                    else begin
                      ArchivMail(FListCentrale.Items[i],MaCFG);
                    end;
                   end ;
                end; // bresaok...
               end;// bDotraitement
             end  // bDoreservation
             else begin
              // ' : De nouvelles offres commerciales ont été créées, veuillez les mettre à jour', 'Informations'
            //  InfoMessHP(ParamsStr(RS_TXT_RESMAN_NEWOFFRE, FListCentrale.Items[i].MTY_NOM),True,0,0,RS_TXT_RESMAN_INFO);
            if fmain.Ferrorconnect = False then
             begin
              // ce n'est pas une erreur de connexition
              s := ParamsStr(RS_TXT_RESMAN_NEWOFFRE, FListCentrale.Items[i].MTY_NOM) ;
              fmain.ologfile.Addtext(s) ;
                  // affichage message
              ShowmessageRS(ParamsStr(RS_TXT_RESMAN_NEWOFFRE, FListCentrale.Items[i].MTY_NOM),RS_TXT_RESMAN_INFO );
             end;
              Exit;
             end; // else
          end ; // if bAutorisation
       end; // for
       // 7- Suppression des fichiers du répertoire temporaire

       i := FindFirst(GPATHMAILTMP + '*.*',faAnyFile,lSearchRecord);
       try
         while i = 0  do
         begin
           DeleteFile(GPATHMAILTMP + ExtractFileName(lSearchRecord.Name));
           i := FindNext(lSearchRecord);
         end;
       finally
         FindClose(lSearchRecord);
       end;

       // Affichage du rapport
              
      //   if Dm_Reservation.MemD_Rap.RecordCount > 0 then
        //          Dm_Reservation.LK_Rap.Execute  
       
       //else
      // begin  
         // 'Pas de nouvelle réservation' , 'Informations'
        // InfoMessHP(RS_TXT_RESMAN_NONEWRESA,True,0,0,RS_TXT_RESMAN_INFO);
        // ologfile.Addtext(RS_TXT_RESMAN_NONEWRESA );
       //  ShowmessageRS(RS_TXT_RESMAN_NONEWRESA ,RS_TXT_RESMAN_INFO);
      // end ;  
       
  end; // fin de with..do
end;


procedure TFmain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  canclose := false ; 
  windowstate := wsMinimized ;
  application.processmessages ;
end;

procedure TFmain.FormCreate(Sender: TObject);
var sId : string ;
begin

    Decimalseparator := '.' ;
    Ferrorconnect := false ;
    Memo_Mess.Caption := RS_VERIF_MAIL ;
    FAuto := false ; 
    if oLogfile = nil then
      oLogfile := Tlogfile.Create(False);

    // transforme params en integer 
    sId := Paramstr(3) ;
    Try
     FPostid := StrToInt(sid) ;
    Except
     Fpostid := 0 ;
    End;

    sId := Paramstr(4) ;
    Try
     FMagid := StrToInt(sid) ;
    Except
     FMagid := 0 ;
    End;

    if Paramstr(1) = '/A' then
     begin
       WindowState := wsMinimized ;
     end;
    
end;

Procedure  TFmain.ArchivMail(MaCentrale : TGENTYPEMAIL;MaCFG : TCFGMail);
const
  Retry = 3;
var
  Count : integer ; // pour tester les essais
  iNbMess, i, j : Integer;
  IdSMTP : TSmtpClient ;
  lstRep, lstMailBox : TStringList;
  s : string ;
  IMAP4 : IMAP4Class;
begin
  // On sort quand on est en algol
  if FAlgol then
    Exit;

  IMAP4 := IMAP4Class.Create(MaCfg.PBT_SERVEUR,MaCfg.PBT_ADRPRINC,MaCfg.PBT_PASSW,MaCfg.PBT_PORT,True);
  IMAP4.PGStatus3D := Fmain.Gge_A;
  lstRep := TStringList.Create;
  lstMailBox := TStringList.Create;
  With Dm_Reservation do
  Try

    {$REGION 'Tentative de connexion'}
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

   lstMailBox := IMAP4.MailboxList;
   With Que_IdentMagExist do
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
              Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Analyse des mails pour archivage',[MaCentrale.MTY_NOM,RecNo,Recordcount,i + 1, lstRep.Count]),100);
              // Positionnement dans le répertoire (On passe à la suite s'il n'existe pas
              if not IMAP4.SelectMailBox('Reservation/' + Trim(lstRep[i])) then
                Continue;

              // Récupération des mails du répertoire
              IMAP4.LoadAllMailBoxMsg;

              Fmain.InitGauge(Format('%s %d sur %d : Code %d/%d'#13#10'Archivage des mails en cours',[MaCentrale.MTY_NOM,RecNo,Recordcount, i+1, lstRep.Count]),100);
              for j := 0 to IMAP4.MsgList.Count - 1 do
              begin
                // recherche si le mail est à traiter
                if MemD_Mail.Locate('MailSubject;MailDate',VarArrayOf([IMAP4.MsgList[j].Subject,IMAP4.MsgList[j].Date]),[loCaseInsensitive]) then
                begin
                  // Doit on archiver le mail ?
                  if MemD_Mail.FieldByName('bArchive').AsBoolean then
                  begin
                    if lstMailBox.IndexOf('Archive/' + Trim(lstRep[i])) = -1 then
                    begin
                      IMAP4.CreateMailBox('Archive/' + Trim(lstRep[i]));
                      lstMailBox.Add('Archive/' + Trim(lstRep[i]));
                    end;

                    IMAP4.MoveMsg(j + 1,'Archive/' + Trim(lstRep[i]));
                  end;
                end;

                Fmain.Gge_A.Progress := (j + 1) * 100 DIV (IMAP4.MsgList.Count);
                FMain.Refresh;
              end; // for j
              IMAP4.ValidMoveMsg;
            end; // for i
          end; // if
         Next;
       end; // while
     end; // if
   end; // With
  Finally
    lstMailBox.Free;
    lstRep.Free;
    IMAP4.Free;
  End;



//  Account := TAccount.Create(MaCfg.PBT_ADRPRINC,MaCfg.PBT_PASSW,'');
//  With Account do
//   begin
//     Port := MaCfg.PBT_PORT ;
//     Host := MaCfg.PBT_SERVEUR
//   end;
//
//  IdPop := Tpop3Client.Create(Account, True); // connection True = avec SSL
//
//  SMTPAccount := TAccount.Create(MaCfg.PBT_ADRPRINC,MaCfg.PBT_PASSW,'');
//  With SMTPAccount do
//   begin
//     Port := MaCfg.PBT_PORTSMTP ;
//     Host := MaCFG.PBT_SMTP ;
//   end;
//
//  IdSMTP := TSmtpClient.Create(SMTPAccount);
//  Count := 0 ;
//  Repeat
//    Try
//     inc(Count) ;
//     IdSMTP.Connect ;
//     Break ;
//    Except on E:Exception do
//     begin
//     if Count=Retry then
//        begin
//        // ' : Erreur lors de la connexion avec le serveur de mail', 'Erreur POP3'
//       // InfoMessHP(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM) + #13#10 + E.Message,True,0,0,RS_ERR_RESMAN_ERRORPOP3);
//        ologfile.Addtext(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM)+' '+E.Message);
//        Fmain.ShowmessageRS(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM) + #13#10 + E.Message,RS_ERR_RESMAN_ERRORPOP3 );
//        Exit;
//        end;
//     end;
//    End;
//  Until Retry=Count ;
//
//  
//  IdMess := TIdMessage.Create(Dm_Reservation);
//  lst := TStringList.Create;
//
//
//
//
//  With Dm_Reservation do
//  try
//    With IdPop do
//    begin
//      PrepareUserPass ;// connection SSL en mode user pass
//      Count := 0 ;
//      Repeat
//      try
//        Inc(Count) ;
//        if Connected = False then
//           Connect;
//        break ;
//      Except on E:Exception do
//        begin
//         if Count=Retry then
//          begin
//          // ' : Erreur lors de la connexion avec le serveur de mail', 'Erreur POP3'
//         // InfoMessHP(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM) + #13#10 + E.Message,True,0,0,RS_ERR_RESMAN_ERRORPOP3);
//          ologfile.Addtext(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM)+' '+E.Message);
//          ShowmessageRS(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM) + #13#10 + E.Message,RS_ERR_RESMAN_ERRORPOP3 );
//          Exit;
//          end;
//        end;
//      end; // with idpop
//      Until  Retry=Count  ;
//    end;  // with
//
//    iNbMess := Idpop.CheckMessages;
//    // ' : Vérification des mails pour Archivage'
//    //InitGaugeMessHP (ParamsStr(RS_TXT_RESMAN_VERIFMAILARCHIV,MaCentrale.MTY_NOM), iNbMess + 1, true, 0, 0, '', false) ;
//
//    InitGauge(ParamsStr(RS_TXT_RESMAN_VERIFMAILARCHIV,MaCentrale.MTY_NOM),  iNbMess+1);
//    for i := iNbMess downto 1  do
//    begin
//       UpdateGauge ;
//      // récupération du header du mail (plus rapide pour un traitement en surface)
//      IdPop.Pop3.RetrieveHeader(i,IdMess);
//      // Est ce que le mail se trouve dans la liste des mails à traiter
//      if MemD_Mail.Locate('MailSubject',IdMess.Subject,[])  then
//      begin
//        // doit on archiver le mail ?
//        if MemD_Mail.FieldByName('bArchive').AsBoolean then
//        begin
//          With IdSMTP do
//          begin
//            Count := 0 ;
//            Repeat
//              Try
//                 Inc(Count) ;
//                 if Connected = false then
//                   Connect;
//                 break ;
//              Except on E:Exception do
//                begin
//                 if Retry=Count then
//                  begin
//                   // ' : Erreur lors de la connexion avec le serveur de mail', 'Erreur SMTP'
//                   // InfoMessHP(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM) + #13#10 + E.Message,True,0,0,RS_TXT_RESMAN_ERRORSMTP);
//                   ologfile.Addtext(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM)+' '+E.message);
//                      ShowmessageRS(ParamsStr(RS_ERR_RESCMN_CNXMAILERROR, MaCentrale.MTY_NOM) + #13#10 + E.Message, RS_TXT_RESMAN_ERRORSMTP);
//
//                   Exit;
//                  end;
//                end;
//              end;
//            Until Retry=Count ;
//           end;
//
//           // Récupération du mail en entier
//           // Gestion de Twinner spécifique
//           if MaCentrale.MTY_CODE = 'RTW' then
//           begin
//            {$REGION '<---- cliquez sur le + et lire avant de modifier le code ci dessous'}
//            // La sauvegarde du fichier sur le disc dur + le traitement ne doivent pas être modifiés
//            // car les mails transmis par twinner ont des soucis de format qui sont corrigés
//            // Par l'utilisation de la sauvegarde tempporaire + nettoyage du mail.
//            {$ENDREGION}
//            IdMess.NoEncode := True;
//            IdMess.NoDecode := True;
//            IdPop.Pop3.Retrieve(i,IdMess);
//
//            IdMess.SaveToFile(GPATHMAILTMP + 'ArchTmp.txt');
//
//            lst.LoadFromFile(GPATHMAILTMP + 'ArchTmp.txt');
//            lst.Text := StringReplace(lst.Text,#13#13#10,#13#10,[rfReplaceAll]);
//            lst.SaveToFile(GPATHMAILTMP + 'ArchTmpb.txt');
//
//            IdMess.NoEncode := False;
//            IdMess.NoDecode := False;
//            IdMess.LoadFromFile(GPATHMAILTMP + 'ArchTmpb.txt');
//           end else
//            IdPop.Pop3.Retrieve(i,IdMess);
//            Count := 0 ;
//            Repeat
//            try
//              // changement de l'adresse de l'envoyeyr et du destinataire
//              Inc(Count) ;
//              idMess.Sender.Address := idSmtp.Smtp.Username ;
//              IdMess.Recipients.EMailAddresses := MaCFG.PBT_ADRARCH;
//              IdMess.From.Address :=   idSmtp.Smtp.Username ;
//              // transfert du mail- en mode algol non
//              if FAlgol = false then
//                IdSMTP.Send(IdMess);
//              Break ;
//            Except on E:Exception do
//              begin
//                if Retry = Count then
//                begin
//                // ' : Erreur lors du transfert d''un mail', 'Erreur SMTP'
//                //InfoMessHP(ParamsStr(RS_ERR_RESMAN_MAILTRANSERROR,MaCentrale.MTY_NOM) + #13#10 + E.Message,True,0,0,RS_TXT_RESMAN_ERRORSMTP);
//                ologfile.Addtext(ParamsStr(RS_ERR_RESMAN_MAILTRANSERROR,MaCentrale.MTY_NOM)+' '+E.Message) ;
//                ShowmessageRS(ParamsStr(RS_ERR_RESMAN_MAILTRANSERROR,MaCentrale.MTY_NOM)+#13#10 + E.Message,RS_TXT_RESMAN_ERRORSMTP );
//                 Exit;
//                end;
//              end;
//            end;
//            Until Retry = Count;
//             // Si l'envoi se passe bien alors on va supprimer le mail dans la boite reservation.xxx@ginkoia.fr
//             // en mode algol on ne supprime pas le message
//             if FAlgol = False then
//              begin
//                if not IdPop.Pop3.Delete(i) then
//                begin
//                  // 'Impossible de supprimer un mail', 'Erreur Pop3'
//                  //InfoMessHP(RS_ERR_RESMAN_DELERROR,True,0,0,RS_ERR_RESMAN_ERRORPOP3);
//                  ologfile.Addtext(RS_ERR_RESMAN_DELERROR+' '+idMess.Subject);
//                  ShowmessageRS(RS_ERR_RESMAN_DELERROR,RS_ERR_RESMAN_ERRORPOP3);
//                   Exit;
//                end;
//              end;
//          end; // with
//        end;
//      end;
//      // resert de la gauge
//      ResetGauge ;
//  finally
//    IdPop.Free;
//    IdMess.Free;
//    IdSMTP.Free;
//    lst.free;
//    IdPop := nil ;
//    IdMess := nil ;
//    IdSmtp := nil ;
//    lst := nil ;
//  end;
end;


// kes fonction de gestion de la barre de progression et des messages ne sont
// exécutées qu'en mode manuel

procedure TFmain.UpdateGauge;
begin
//  if Fauto = True then exit ;
  Gge_A.Progress := Gge_A.Progress+1 ;
  application.processmessages ;
end;

Procedure TFmain.InitGauge(sMessage : string ;MaxValue: Integer);
begin
//    if Fauto = True then exit ;
    Memo_Mess.caption := sMessage ;
    Memo_Mess.Update ;
    Gge_A.MaxValue := MaxValue;
    Gge_A.Progress := 0 ;
    Gge_A.Update ;
    Application.ProcessMessages;
end;

procedure TFmain.ResetGauge;
begin
  //  if Fauto = True then exit ;
    Gge_A.Progress := 0 ;
    Gge_A.MaxValue := 0 ;
    Gge_A.Update ;
end;


procedure TFmain.ShowmessageRS(sMessage, sTitle: string);
var bNeedToDisplay : boolean;
begin
 //if Fauto = True then exit ;

 Try
   bNeedtoDisplay := visible ;
   if visible then Hide ;
   Application.CreateForm(TFmessagebox, Fmessagebox);
   Fmessagebox.Caption := sTitle ;
   Fmessagebox.Memo_Mess.Caption := sMessage ;
   Fmessagebox.ShowModal ;
 Finally
   if bNeedToDisplay then Show;
   Fmessagebox.Release ;
   Fmessagebox := nil ;
 End;
   
end;







end.
