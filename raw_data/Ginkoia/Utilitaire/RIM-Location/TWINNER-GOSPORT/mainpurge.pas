unit mainpurge;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, R2d2, datamodule, ReservationResStr, ExtCtrls,
  dateutils, IdBaseComponent, IdMessage, IdAntiFreezeBase, IdAntiFreeze;


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
  private
    { Déclarations privées }
    Frunning, Fstop : boolean ;
  public
    { Déclarations publiques }
  end;

var
  Fmain: TFmain;

implementation

{$R *.dfm}

procedure TFmain.Btn_stopClick(Sender: TObject);
begin
  Btn_stop.Enabled := False ;
  Fstop := True ;
  application.ProcessMessages ;
end;

procedure TFmain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Canclose := (Frunning = false) ;
end;

procedure TFmain.FormCreate(Sender: TObject);
var sFolder : string ;
begin
  sFolder :=  IncludeTrailingPathDelimiter(Extractfilepath(Paramstr(0)))+'LOG RESERVATION' ;
  ForceDirectories(sFolder) ;
end;

procedure TFmain.FormShow(Sender: TObject);
begin
  Mglobal.lines.Clear ;
  Mlogres.Lines.Clear ;
  Mlogarc.lines.Clear ;
  // pas de centrale définie
  if XLMDataModule.DSCentrale.RecordCount = 0 then
    begin
       Showmessage(RS_NO_CENTRALE) ;
       Application.terminate ;
    
    end;
    Statusbar.Panels[CENTRALECOUNT].Text := IntTostr(XLMDataModule.DSCentrale.RecordCount) ;
    Postmessage(handle, WM_PURGENOW, 0, 0) ;
end;






procedure TFmain.PurgeNow(var aMsg :Tmessage);

var 
  AccountR, AccountA, AccountS : TAccount ;
  Pop3R : Tpop3Client ;
  Pop3A : Tpop3Client ;
  Smtp : TSmtpClient ;
  Count : integer ; // pour les tentatives
  dDate, Mdate : Tdate ;
  K,K2, nArchived,i : integer ; // nombre de messages ;
  bContinue : boolean ; // traitement si connexions
  sFile,s, sn : string ;//nom du fichier log
begin
 Try
   Btn_stop.Enabled := True ;
   application.processmessages ;
   Frunning := True ;
   With XLMDataModule.DSCentrale do
    begin
       First ;
       while Eof = false do
       begin
        if Fstop = True then break ;

        Mlogres.lines.clear ;
        Mlogarc.lines.clear ;
        if Fieldbyname('DELAY').AsInteger > 0 then  // pour éviter un désastre
        begin
          nArchived := 0 ;
          Mglobal.Lines.Insert(0, Fieldbyname('CENTRALE').AsString );
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
          // calcul de la date limite
          dDate := IncDay(Date, -(Fieldbyname('DELAY').AsInteger)) ;
          // étblir les connexions
          Count := 0 ;

          if Fstop = True then break ;

          
          bContinue := True ;
          Repeat
          Try
            inc(Count) ;
            Mglobal.Lines.Insert(0, 'Connexion au compte Réservation tentative '+inttostr(Count));
            Pop3R.Connect ;
            Mglobal.Lines.Insert(0, 'Connexion au compte Réservation activée');
            break ;
          Except
            ON E:EXCEPTION DO
            begin
              if Count = RETRY then
               begin
                 bContinue := False ;
                 Mglobal.Lines.Insert(0, e.Message);
               end;
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
              Mglobal.Lines.Insert(0, 'Connexion au compte Archive tentative '+inttostr(Count));
              Pop3A.Connect ;
              Mglobal.Lines.Insert(0, 'Connexion au compte Archive activée');
              break ;
            Except
              ON E:EXCEPTION DO
              begin
                if Count = RETRY then
                 begin
                   bContinue := False ;
                   Mglobal.Lines.Insert(0, e.Message);
                 end;
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
                  Mglobal.Lines.Insert(0, 'Connexion au compte Smtp tentative '+inttostr(Count));
                  Smtp.Connect ;
                  Mglobal.Lines.Insert(0, 'Connexion au compte Smtp activée');
                  break ;
                Except
                  ON E:EXCEPTION DO
                  begin
                    if Count = RETRY then
                     begin
                       bContinue := False ;
                       Mglobal.Lines.Insert(0, e.Message);
                     end;
                  end;
            
                End;
                Until Count = RETRY ;  
              end;  // bcontinue  smtp
           end;  // bcontinue archive
           if bContinue = false then
             Mglobal.Lines.insert(0, 'Centrale non traitée') else
             begin
               if Fstop = True then  break ;
               

               k2 := POP3A.Checkmessages ;
               k := Pop3R.Checkmessages ;
               if k2 > 0 then
               begin
                Mlogarc.Lines.insert(0, Inttostr(k2)+' messages') ;
               end ; 
               if k > 0 then
                begin
                  Mglobal.lines.Insert(0, inttostr(k)+' messages');
                  for i := K downto 1 do
                    begin
                      if Fstop = True then break ;
                      Try
                      if Pop3R.Pop3.RetrieveHeader(i, idMessage) then
                       begin
                         Mdate := Trunc(idMessage.Date) ;
                         Mlogres.Lines.Insert(0, inttostr(i)+' '+idmessage.Subject);
                         if (Mdate <= dDate)  then
                         begin
                           Count := 0 ;
                           Repeat
                           Try
                            Mlogarc.Lines.Insert(0, ' Archivage message '+inttostr(i));
                            Pop3R.Pop3.Retrieve(i, idMessage) ;
                            // pour test
                            idMessage.Subject := 'TEST '+idMessage.Subject ;
                            // pour test fin
                            idMessage.Recipients.Clear ;
                            idMessage.Sender.Address := Fieldbyname('EMAIL').Asstring ;
                            IdMessage.Recipients.EMailAddresses  := Fieldbyname('ARCHIVE').AsString ;
                            if smtp.Connected = false then
                              Smtp.Connect ;
                          //   smtp.Send(idMessage);   // à activer pour la version finale
                             // le message a été envoyé
                           // Pop3R.Pop3.Delete(i) ;       // à activer pour la version finale
                           inc(nArchived) ;
                            break ;
                           Except
                             ON E: Exception do
                              begin
                                if Count = RETRY then
                                 begin
                                   Mglobal.Lines.Insert(0, e.Message);
                                   Mglobal.Lines.Insert(0, idMessage.Subject+' non archivé');
                                 end;
                              end;

                           End;
                           Until Count = RETRY;
                         end;
                         
                       end;
                      Except
                        ON E : Exception do
                         begin
                           Mglobal.Lines.Insert(0, e.message);
                         end;
                      End;
                    end; // for i
                    if Fstop = True then break  ;
                    
                end else
                  Mglobal.Lines.insert(0, 'Aucune réservation') ;
               
             end;
           if nArchived > 0 then
            begin
            Mglobal.lines.Insert(0, inttostr(nArchived)+' messages archivé(s)');
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
          Mglobal.Lines.Insert(0, 'DELAI DE RETENTION A 0 CENTRALE NON TRAITEE') ;
        end;
        Next ;
       end;
    end;
   
 Finally
   if Assigned(Pop3A) then Pop3A.free ;
   if Assigned(Pop3R) then Pop3R.Free ;
   if Assigned(Smtp) then Smtp.Free ;
   if Assigned(AccountR) then AccountR.Free ;
   if Assigned(AccountA) then AccountA.Free ;   
   if Assigned(AccountS) then AccountS.Free ;
   
   
   if Mglobal.Lines.Count > 0 then
    begin
     sFile :=  IncludeTrailingPathDelimiter(Extractfilepath(Paramstr(0)))+'LOG RESERVATION\' ;
     sFile := sFile+Inttostr(yearof(date))+'-'+Inttostr(Monthof(date))+'-'+Inttostr(Dayof(date)); 
     s := '-Purge' ;
     i := 0 ;
     // pour éviter d'écraser le fichier d'un même jour 
     repeat
       sn := sfile+s ;
       if i >0 then
        begin
          sn := sn+' ('+inttostr(i)+').log' ;
        end;
       inc(i) ; 
     until Fileexists(sn)= False ;
     if Fstop = True then
      begin
         Mglobal.lines.Insert(0,'...Traitement interrompu par l''utilisateur') ;
         Mglobal.lines.Insert(0,'') ;
      end;
     
     
     Mglobal.lines.Insert(0,'['+DateTimeTostr(now)+']') ;
     Mglobal.lines.SaveToFile(sn);
    end;
   
   Frunning := False ;
   application.Terminate ;
 End;

end;

end.
