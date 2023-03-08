unit mainpurge;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, R2d2, datamodule, ReservationResStr, ExtCtrls,
  IdBaseComponent, IdMessage, IdAntiFreezeBase, IdAntiFreeze,
  IdIntercept, IdLogBase, dateutils, Xml_Unit,IcXMLParser, uLogfile;


CONST 
 WM_PURGENOW = WM_USER+101 ;
 RETRY = 3 ;

 // pour la statusbar
 CENTRALECOUNT= 0 ;  
 DELAY   =      1 ;
 
type
  TFmain = class(TForm)
    Statusbar: TStatusBar;
    Pan_log: TPanel;
    Mglobal: TMemo;
    Splitter1: TSplitter;
    Pan_main: TPanel;
    Pan_reservation: TPanel;
    Splitter2: TSplitter;
    Pan_archive: TPanel;
    Lab_reservation: TLabel;
    Lab_archive: TLabel;
    Mlogres: TMemo;
    Mlogarc: TMemo;
    IdMessage: TIdMessage;
    IdAntiFreeze: TIdAntiFreeze;
    Pan_top: TPanel;
    Lab_centrale: TLabel;
    Pan_right: TPanel;
    Btn_stop: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Purgenow(var aMsg : Tmessage); message WM_PURGENOW ;
    procedure FormCreate(Sender: TObject);
    procedure Btn_stopClick(Sender: TObject);
    // pour archivage Intersport
    procedure ArchiveIS(iD, Delay : integer; var Archived : integer);
    procedure ArchivMail(iD, Delay : integer; var Archived : integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
    Frunning, Fstop, Falgol, FerrorConnect : boolean ;
    sCentrale, sPcentrale : string ;  // sPcentrale centrale demandée par paramètre cf oncreate
    Pop3R : Tpop3Client ;
    Pop3A : Tpop3Client ;
    Smtp : TSmtpClient ;
    oLogfile : Tlogfile ;
  public
    { Déclarations publiques }
  end;

var
  Fmain: TFmain;
  GPATHMAILTMP : String;
implementation

{$R *.dfm}

procedure TFmain.Btn_stopClick(Sender: TObject);
begin
  Btn_stop.Enabled := False ;
  Fstop := True ;
  application.ProcessMessages ;
end;

procedure TFmain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if Assigned(oLogfile) then
  begin
    oLogfile.Free ;
    oLogfile := nil ;
  end;
end;

procedure TFmain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Canclose := (Frunning = false) ;
end;

procedure TFmain.FormCreate(Sender: TObject);
var sFolder, sP1, sP2 : string ;
begin
  sPcentrale := '';
  FAlgol := False ;
  // pas de paramétres  = toutes les centrales en réel
  if paramcount = 1 then
   begin
     // 1 seul paramétre 
     sP1 := paramstr(1) ;
     if length(sP1) = 1 then  // le paramétre est un simple chiffre 
       begin
         // en mode algol = simulation de toutes les centrales
          Falgol := Paramstr(1) = '1' ;
       end else
       begin
        // le paramétre est préfixé d'un '/' on traite la centrale en mode réel
        if sP1 = '/0' then sPcentrale := 'SP2000' else
         if sP1 = '/1' then sPcentrale := 'SKIMIUM' else
          if sP1 = '/2' then sPcentrale :=  'TWINNER' else
           if sP1 = '/3' then sPcentrale :=  'INTERSPORT' ;       
       end;
   end;
  if paramcount > 1 then
    begin
      sP1 := paramstr(1) ;
      if length(Sp1) = 1 then
       begin
         // le premier paramètre est le mode simulation Algol  
         Falgol := Paramstr(1) = '1' ;
       end else
       begin
        if sP1 = '/0' then sPcentrale := 'SP2000' else
        if sP1 = '/1' then sPcentrale := 'SKIMIUM' else
         if sP1 = '/2' then sPcentrale :=  'TWINNER' else
          if sP1 = '/3' then sPcentrale :=  'INTERSPORT' ;
       end ;
      
      sP2 := paramstr(2) ;  
      if length(sP2) = 1 then
       begin
          Falgol := Paramstr(2) = '1' ;
       end else
       begin
         if sP2 = '/0' then sPcentrale := 'SP2000' else
          if sP2 = '/1' then sPcentrale := 'SKIMIUM' else
           if sP2 = '/2' then sPcentrale :=  'TWINNER' else
            if sP2 = '/3' then sPcentrale :=  'INTERSPORT' ;
       end;
    end;
   if Falgol then
    Caption := Caption+' [Mode Algol]' ; 
  GPATHMAILTMP := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'MailImportTmp\';
  ForceDirectories(GPATHMAILTMP) ;
  sFolder :=  IncludeTrailingPathDelimiter(Extractfilepath(Paramstr(0)))+'LOG RESERVATION' ;
  ForceDirectories(sFolder) ;
  oLogfile := Tlogfile.Create(False);
end;

procedure TFmain.FormShow(Sender: TObject);
begin
  Mglobal.lines.Clear ;
  Mlogres.Lines.Clear ;
  Mlogarc.lines.Clear ;
  // pas de centrale définie
  if XLMDataModule.DSCentrale.RecordCount = 0 then
    begin
       oLogfile.Addtext(RS_NO_CENTRALE);
       Showmessage(RS_NO_CENTRALE) ;
       Application.terminate ;
    end;
    Statusbar.Panels[CENTRALECOUNT].Text := IntTostr(XLMDataModule.DSCentrale.RecordCount) ;
    Postmessage(handle, WM_PURGENOW, 0, 0) ;
end;






procedure TFmain.PurgeNow(var aMsg :Tmessage);
var 
  AccountR, AccountA, AccountS : TAccount ;
  Count : integer ; // pour les tentatives
  dDate, Mdate : Tdate ;
  K,K2, nArchived,i, delay : integer ; // nombre de messages ;
  bContinue : boolean ; // traitement si connexions
  sFile,s, sn : string ;//nom du fichier log
  lSearchRecord  : TSearchRec; 
  nTmA : integer ; // nombre total de messages archivés ou à archiver
begin
 Try
   Btn_stop.Enabled := True ;
   application.processmessages ;
   Frunning := True ;
   oLogfile.Addtext(RES_LOG_DEM);
   nTmA := 0 ; // pour compter les messages archivés
   With XLMDataModule.DSCentrale do
    begin
       First ;
       while Eof = false do
       begin
        if Fstop = True then break ;
        sCentrale := uppercase(Fieldbyname('CENTRALE').AsString) ;  // pour tester l'archivage ;
        Mlogres.lines.clear ;
        Mlogarc.lines.clear ;
        if (sPcentrale = '') or (sCentrale = sPcentrale) then
        begin
        if Fieldbyname('DELAY').AsInteger > 0 then  // pour éviter un désastre
        begin
          delay := Fieldbyname('DELAY').AsInteger ;
          nArchived := 0 ;
          sCentrale := Fieldbyname('CENTRALE').AsString ;  // pour tester l'archivage
          oLogfile.Addtext(sCentrale);
          Mglobal.Lines.Insert(0, sCentrale );
          // affichage info
          Lab_centrale.Caption := Fieldbyname('CENTRALE').AsString ;
          Lab_centrale.Update ;
          Lab_reservation.caption := Fieldbyname('EMAIL').AsString ;
          Lab_reservation.update ;
          Lab_archive.Caption := Fieldbyname('ARCHIVE').AsString ;
          Lab_archive.update ;
          Statusbar.Panels[DELAY].Text := Inttostr(Fieldbyname('DELAY').AsInteger) ;
          Try
          // création du compte réservation
          AccountR := Taccount.Create(Fieldbyname('EMAIL').AsString, Fieldbyname('MDP').Asstring,'');
          AccountR.Host := Fieldbyname('POP3').AsString ;
          AccountR.Port := Fieldbyname('POP3PORT').AsInteger;
          // création du client Pop3 réservation
          Pop3R := Tpop3Client.Create(AccountR, Fieldbyname('SSL').AsBoolean );
          Pop3R.PrepareUserPass ; 
          // création du compte archive
          AccountA := Taccount.Create(Fieldbyname('ARCHIVE').AsString, Fieldbyname('AMDP').Asstring,'');
          AccountR.Host := Fieldbyname('POP3').AsString ;
          AccountR.Port := Fieldbyname('POP3PORT').AsInteger;
          // création du client Pop3 archive
          Pop3A := Tpop3Client.Create(AccountA, Fieldbyname('SSL').AsBoolean );
          Pop3A.PrepareUserPass ;  
          // création du compte smtp
          AccountS := Taccount.Create(Fieldbyname('EMAIL').AsString, Fieldbyname('MDP').Asstring,'');
          AccountS.Host := Fieldbyname('SMTP').AsString ;
          AccountS.Port := Fieldbyname('SMTPPORT').AsInteger;
          // création du client SMTP
          Smtp := TSmtpClient.Create(Accounts);
          // étblir les connexions
          Count := 0 ;

          if Fstop = True then break ;

          
          bContinue := True ;
          Repeat
          Try
            inc(Count) ;
            Mglobal.Lines.Insert(0, RES_R_TENTATIVE+inttostr(Count));
            Pop3R.Connect ;
            Mglobal.Lines.Insert(0, RES_R_CONNECTE);
            break ;
          Except
            ON E:EXCEPTION DO
            begin
              if Count = RETRY then
               begin
                 bContinue := False ;
                 ologfile.Addtext(e.Message);
                 Mglobal.Lines.Insert(0, e.Message);
               end else
                 if Fstop = True then break ;
            end;
          End;
          Until Count = RETRY ;
          if bContinue then
           begin
             // compte archive
            Count := 0 ;
            Repeat
            Try
              inc(Count) ;
              Mglobal.Lines.Insert(0, RES_A_TENTATIVE+inttostr(Count));
              Pop3A.Connect ;
              Mglobal.Lines.Insert(0, RES_A_CONNECTE );
              break ;
            Except
              ON E:EXCEPTION DO
              begin
                if Count = RETRY then
                 begin
                   bContinue := False ;
                   ologfile.Addtext(e.Message);
                   Mglobal.Lines.Insert(0, e.Message);
                 end else 
                   if Fstop = True then break ;
              end;
            
            End;
            Until Count = RETRY ;  
              if bContinue then
               begin
                 // compte Smtp
                 Count := 0 ;
                Repeat
                Try
                  Inc(Count) ;
                  Mglobal.Lines.Insert(0, RES_S_TENTATIVE+inttostr(Count));
                  Smtp.Connect ;
                  Mglobal.Lines.Insert(0, RES_S_CONNECTE);
                  break ;
                Except
                  ON E:EXCEPTION DO
                  begin
                    if Count = RETRY then
                     begin
                       bContinue := False ;
                       ologfile.Addtext(e.Message);
                       Mglobal.Lines.Insert(0, e.Message);
                     end else
                       if Fstop = True then break ;
                  end;
            
                End;
                Until Count = RETRY ;  
              end;  // bcontinue  smtp
           end;  // bcontinue archive
           if bContinue = false then
             Mglobal.Lines.insert(0, RES_NOCENTRALE) else
             begin
               if Fstop = True then  break ;
               

               k2 := POP3A.Checkmessages ;
               k := Pop3R.Checkmessages ;
               if k2 > 0 then
               begin
                Mlogarc.Lines.insert(0, Inttostr(k2)+RES_A_MSG) ;
                ologfile.Addtext(Inttostr(k2)+RES_A_MSG);
               end ; 
               if k > 0 then
                begin
                  ologfile.Addtext(inttostr(k)+RES_MSG);
                  Mglobal.lines.Insert(0, inttostr(k)+RES_MSG);
                  for i := K downto 1 do
                    begin
                      if Fstop = True then break ;
                      application.ProcessMessages ;
                      Try
                        if ((uppercase(sCentrale) = 'INTERSPORT') and (sPcentrale ='')) OR
                            (uppercase(sPcentrale) = 'INTERSPORT')  then
                         begin
                          ArchiveIS(i, delay, nArchived) ;  
                         end else
                         begin
                          if ((uppercase(sCentrale) = 'TWINNER') and (sPcentrale ='')) OR
                            (uppercase(sPcentrale) =  'TWINNER')  then
                          begin
                           ArchivMail(i, delay, nArchived) ;
                          end else
                          begin
                            if ((uppercase(sCentrale) = 'SKIMIUM') and (sPcentrale ='')) OR
                            (uppercase(sPcentrale) = 'SKIMIUM')  then
                             begin
                               ArchivMail(i, delay, nArchived) ;   
                             end else
                             begin
                               if  ((uppercase(sCentrale) = 'SP2000') and (sPcentrale ='')) OR
                               (uppercase(sPcentrale) = 'SP2000')  then 
                                begin
                                  ArchivMail(i, delay, nArchived) ;  
                                end;
                             end;
                          end;
                        end;

                      Except
                       ON E : Exception do
                        begin
                          Mglobal.Lines.Insert(0, e.message);
                         end;
                      End;    
                        if Fstop = True then break  ;
                     end;
                    
                end else
                  Mglobal.Lines.insert(0, RES_NORES) ;
               
             end;
           if nArchived > 0 then
            begin
             if FAlgol = false then
              begin
               Mglobal.lines.Insert(0, inttostr(nArchived)+RES_MSG_ARCHIVE);
               ologfile.Addtext(inttostr(nArchived)+RES_MSG_ARCHIVE);
              end else
              begin
               Mglobal.lines.Insert(0, inttostr(nArchived)+RES_MSG_ARCHIVER);
               ologfile.Addtext(inttostr(nArchived)+RES_MSG_ARCHIVER);
              end;
              nTmA := nTmA+nArchived ;
            end;
            
           Mglobal.Lines.Insert(0, '') ;
          Finally
            Try
            Smtp.free ;
            Pop3A.Free ;
            Pop3R.Free ;
            AccountS.Free ;
            AccountA.free ;
            AccountR.free ;
            Smtp := nil ;
            Pop3A := nil ;
            Pop3R := nil ;
            AccountS := nil ;
            AccountA := nil ;
            AccountR := nil ;
            Except
            End;
          End;
        End else
        begin
          // délai à 0 centrale non traitée
          ologfile.Addtext(RES_DELAI_A_ZERO );
          Mglobal.Lines.Insert(0,RES_DELAI_A_ZERO ) ;
        end;
       end; // spcentrale...
        Next ;
       end;
    end;
   
 Finally
   oLogfile.Addtext(RES_LOG_FIN);
   if Assigned(Pop3A) then Pop3A.free ;
   if Assigned(Pop3R) then Pop3R.Free ;
   if Assigned(Smtp) then Smtp.Free ;
   if Assigned(AccountR) then AccountR.Free ;
   if Assigned(AccountA) then AccountA.Free ;   
   if Assigned(AccountS) then AccountS.Free ;
   
   
   if Mglobal.Lines.Count > 0 then
    begin

     sFile :=  IncludeTrailingPathDelimiter(Extractfilepath(Paramstr(0)))+'LOG RESERVATION\' ;

     if Fstop = True then
      begin
         ologfile.Addtext(RES_LOG_STOP);
         Mglobal.lines.Insert(0,RES_LOG_STOP) ;
         Mglobal.lines.Insert(0,'') ;
      end;
     
     if nTmA > 0 then
      begin
       if Falgol then
        ologfile.Addtext(inttostr(nTmA)+RES_MSG_ARCHIVER) else
         oLogfile.Addtext(inttostr(nTma)+RES_MSG_ARCHIVE) ;
      end ;
        

     ologfile.SaveToFile(sFile);
     ologfile.Free ;
    end;


  // suppression des messages temporaires
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

   
   Frunning := False ;


   
   application.Terminate ;
 End;

end;



// archivage du message  Intersport
procedure TFmain.ArchiveIS(iD, Delay: Integer; var Archived : integer)   ;
var sFilename, sFullname, dDf, sSubject : string ;
    lst : Tstringlist ;
    TFin, dDatelimit : Tdate ;
begin
Try
   // récupération du header du mail (plus rapide pour un traitement en surface)
  lst := Tstringlist.Create ;
  repeat
    sFileName := 'IS-' + FormatDateTime('YYYYMMDDhhmmssnn',Now);
  until not FileExists(GPATHMAILTMP + sFilename);
  sFullname :=  GPATHMAILTMP + sFilename;
  if Pop3R.Pop3.Retrieve(id,IdMessage) = True then
   begin
    if Uppercase(idMessage.Subject) <> 'TEST' then
    begin
      Mlogres.Lines.Insert(0, inttostr(iD)+' '+idmessage.Subject);
      IdMessage.Body.SaveToFile(sFullname);
  

    // Récupération du fichier
    lst.LoadFromFile(GPATHMAILTMP + sFileName);
    // suppression des caractères spéciaux et blanc devant et derriere le texte
    lst.Text := Trim(lst.Text);
    // Découpage des données
    lst.Text := StringReplace(lst.Text, ';', #13#10,[rfReplaceAll]);
    try
     dDf :=   lst[12] ;
     TFin :=  StrToDate(dDf) ;
     // on incrémente la date de fin de location du nombre de jours du délai
     dDatelimit := IncDay(Tfin, Delay) ;
     if Date > dDatelimit then
      begin
        // la date limite de conservation a été dépassée
        sSubject := IdMessage.Subject ;
        if FAlgol = True then
         begin
            oLogfile.Addtext(sSubject+RS_MESSAGE_A_ARCHIVER);
            Mlogarc.lines.Add(sSubject+RS_MESSAGE_A_ARCHIVER) ;
            inc(Archived) ;
         end else
         begin
           Mlogarc.Lines.Add( RS_MESSAGE_ARCHIVAGE+' '+sSubject) ;
            With SMTP do
            begin
                try
                  if Connected = False then
                   begin
                    Connect;
                   end;
                Except on E:Exception do
                  begin
                    oLogfile.Addtext(e.Message);
                    Fmain.Ferrorconnect := True ;
                    Mglobal.Lines.Insert(0, e.Message);
                    Exit;
                   end;
                  end;
                end; // except
            end; // with
              try
              // changement de l'adresse de destinataire  et du sender
                IdMessage.Sender.Address := Smtp.Smtp.Username ;
                IdMessage.Recipients.EMailAddresses := Pop3A.Pop3.Username ;
                idMessage.From.Address := Smtp.Smtp.Username ;
                // transfert du mail
                if Falgol = False then
                 begin
                  SMTP.Smtp.Send(IdMessage);
                  ologfile.Addtext(RES_LOG_ARCHIVE + idMessage.Subject);
                  inc(Archived) ;
                 end;
               Except on E:Exception do
                begin
                  Fmain.Ferrorconnect := True ;
                  oLogfile.Addtext(e.Message);
                  Mglobal.Lines.Insert(0, e.Message);
                  Exit;
                end;
              end;

               // Si l'envoi se passe bien alors on va supprimer le mail dans la boite reservation.xxx@ginkoia.fr
                if not Pop3R.Pop3.Delete(id) then
                begin
                     ologfile.Addtext( RS_MESSAGE_NOTDELETED + idMessage.Subject);
                     Mglobal.Lines.Insert(0, RS_MESSAGE_NOTDELETED);
                     Fmain.Ferrorconnect := True ;
                    Exit;
                end ;

           
         end;

        
     


          
    Except
    end;
    
     end else
     begin
        // message de test à supprimer
        Pop3R.Pop3.Delete(id);  
        
     end ;
    end;

Finally
  lst.Clear ;
  lst.free ;
  lst := nil ;

End;  


end;



Procedure  TFmain.ArchivMail(iD, Delay : integer; var Archived : integer)  ;
var
  iNbMess : Integer;
  lst : TStringList;
  s : string ;
  sFilename : string ;
  Resa : integer ; // pour fonction decode
  bArchiveit : boolean ;
  FSetting :  TFormatSettings;
function Checkit : boolean ;
var MonXml : TmonXML;
    i, nb : integer ;
    sDdebut , sNbr, sDate : string ;
    nReservationXml : TIcXMLElement;    
    dDate, dLimit : Tdatetime ;
begin
Try
   result := false ;
   MonXml := TmonXML.Create;
   MonXml.LoadFromFile(GPATHMAILTMP +sFilename);
   nReservationXml := MonXml.find('/fiche/reservation/dates_duree') ;
   if Assigned(nReservationXml) then
    begin
       sDdebut := MonXml.ValueTag(nReservationXml,'date_debut') ; 
       sNbr :=  MonXml.ValueTag(nReservationXml,'nb_jours') ;
      Try
       dDate :=  StrToDate(sdDebut,FSetting);
       nb := StrtoInt(sNbr) ;
       dLimit := IncDay(dDate, nb) ;
       result :=  (Date > dLimit);
      Except
      End;
      
    end;
   
Finally
  Monxml.Free ;
  MonXml := nil ;
End;
end;
  
begin
Try
 // récupère le format date heure local
  GetLocaleFormatSettings(SysLocale.DefaultLCID,FSetting);
  // On le modifie pour qu'il soit compatible avec le format demandé dans les fichiers
  FSetting.ShortDateFormat := 'YYYY-MM-DD';
  FSetting.DateSeparator := '-';



      Lst := Tstringlist.Create ;
      bArchiveit := false ;
      // récupération du header du mail (plus rapide pour un traitement en surface)
      Pop3R.Pop3.RetrieveHeader(id,IdMessage);
      if Uppercase(idMessage.Subject) <> 'TEST' then
       begin
            Mlogres.Lines.Insert(0, inttostr(iD)+' '+idmessage.Subject);
           // Récupération du mail en entier
           // Gestion de Twinner spécifique
           if uppercase(sCentrale) = 'TWINNER' then
           begin
            {$REGION '<---- cliquez sur le + et lire avant de modifier le code ci dessous'}
            // La sauvegarde du fichier sur le disc dur + le traitement ne doivent pas être modifiés
            // car les mails transmis par twinner ont des soucis de format qui sont corrigés
            // Par l'utilisation de la sauvegarde tempporaire + nettoyage du mail.
            {$ENDREGION}
            IdMessage.NoEncode := True;
            IdMessage.NoDecode := True;
            Pop3R.Pop3.Retrieve(id,IdMessage);

            IdMessage.SaveToFile(GPATHMAILTMP + 'ArchTmp.txt');

            lst.LoadFromFile(GPATHMAILTMP + 'ArchTmp.txt');
            lst.Text := StringReplace(lst.Text,#13#13#10,#13#10,[rfReplaceAll]);
            lst.SaveToFile(GPATHMAILTMP + 'ArchTmpb.txt');

            IdMessage.NoEncode := False;
            IdMessage.NoDecode := False;
            IdMessage.LoadFromFile(GPATHMAILTMP + 'ArchTmpb.txt');
            Resa := 2 ;
            if DecodeMessage(idMessage, GPATHMAILTMP, Resa ,sFileName) then
              begin
                bArchiveit := Checkit ;
              end else
              begin
                Mlogarc.lines.Add(RES_LOG_NOTDECODE+idMessage.Subject);
                ologfile.Addtext(RES_LOG_NOTDECODE+idMessage.Subject);
              end ;
            
           end else
           begin
             Pop3R.Pop3.Retrieve(id,IdMessage);
                // 0 = sport2000
               // 1 = skimium
               // 2 = twinner
             if Uppercase(sCentrale) = 'SP2000' then
               begin
                 Resa := 0 ;
               end;
             if Uppercase(sCentrale)= 'SKIMIUM' then
               begin
                 Resa := 1 ;
               end ;
               
             
               if DecodeMessage(idMessage, GPATHMAILTMP, Resa ,sFileName) then
                begin
                   bArchiveit :=  Checkit ;
                end else
                begin
                 Mlogarc.lines.Add(RES_LOG_NOTDECODE+idMessage.Subject);
                 ologfile.Addtext(RES_LOG_NOTDECODE+idMessage.Subject);
                end ;
             
           end;


          if bArchiveit then
           begin
             if Falgol then
               begin
                  Mlogarc.lines.Add(IdMessage.Subject+' '+RS_MESSAGE_A_ARCHIVER) ;
                  ologfile.Addtext(IdMessage.Subject+' '+RS_MESSAGE_A_ARCHIVER);
                  Inc(Archived) ;
               end else
               begin
                   Mlogarc.Lines.Add( RS_MESSAGE_ARCHIVAGE+' '+ idMessage.Subject) ;
               end ;    
            try
              // changement de l'adresse de l'envoyeyr et du destinataire
              idMessage.Sender.Address := Smtp.Smtp.Username ; 
              IdMessage.Recipients.EMailAddresses := Pop3A.Pop3.username ;
              IdMessage.From.Address :=   Smtp.Smtp.Username ;
              // transfert du mail- en mode algol non
              if FAlgol = false then
               begin
                SMTP.Send(IdMessage);
                Inc(Archived) ;
               end ; 
            Except on E:Exception do
              begin
                  ologfile.Addtext(e.Message);
                  Fmain.Ferrorconnect := True ;
                  Mglobal.Lines.Insert(0, e.Message);
                  Exit;              
              end;                                
            end;
             // Si l'envoi se passe bien alors on va supprimer le mail dans la boite reservation.xxx@ginkoia.fr
             // en mode algol on ne supprime pas le message
             if FAlgol = False then
              begin
                if not Pop3R.Pop3.Delete(id) then
                begin
                   Exit;
                end;
              end;
           end;
       end  else  // if ..TEST
       begin
       // message de test à supprimer
        Pop3R.Pop3.Delete(id);  
       end ;   
  finally
    lst.Free ;
    lst := nil ;


  end;
end;


end.
