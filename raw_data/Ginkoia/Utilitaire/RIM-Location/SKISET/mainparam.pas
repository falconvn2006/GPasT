unit mainparam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, StdCtrls, Spin, ExtCtrls, DBCtrls, Provider, Mask,
  datamodule, R2D2, frmlog, Shellapi, IdBaseComponent, IdMessage;

type
  TFmain = class(TForm)
    Lab_centrale: TLabel;
    Lab_email: TLabel;
    Lab_pwd: TLabel;
    Lab_Archive: TLabel;
    Lab_Amdp: TLabel;
    Lab_Pop3: TLabel;
    Lab_Portpop3: TLabel;
    Lab_smtp: TLabel;
    Lab_smtpport: TLabel;
    Lab_delay: TLabel;
    DBNavigator1: TDBNavigator;
    edtCentrale: TDBEdit;
    edtEmail: TDBEdit;
    edtMdp: TDBEdit;
    edtArchive: TDBEdit;
    edtAmdp: TDBEdit;
    edtPop3: TDBEdit;
    edtPop3Port: TDBEdit;
    edtSmtp: TDBEdit;
    edtSmtpPort: TDBEdit;
    chkSsl: TDBCheckBox;
    edtDelay: TDBEdit;
    Ds_centrale: TDataSource;
    Btn_test: TButton;
    Lab_file: TLabel;
    Btn_script: TButton;
    dlgSavefile: TFileSaveDialog;
    IdMessage: TIdMessage;
    procedure Btn_testClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Btn_scriptClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Fmain: TFmain;

implementation

{$R *.dfm}

procedure TFmain.Btn_scriptClick(Sender: TObject);
var aL : Tstringlist ;
    s : string ;
begin
 Try
   // écriture  du script
   al := Tstringlist.create ;
   With XLMDataModule.DSCentrale do
    begin
      First ;
      while eof = false do
       begin
         al.Add('Update genmailparam') ;
         al.Add('Set')   ;
         s := '  pbt_adrarch = '+Quotedstr(Fieldbyname('ARCHIVE').AsString)+',' ;
         al.Add(s)  ;
         s := '  pbt_passw = '+Quotedstr(Fieldbyname('MDP').AsString)+',' ;
         al.Add(s) ;
         s := '  pbt_serveur = '+Quotedstr(Fieldbyname('POP3').AsString)+',';
         al.Add(s) ;
         s := '  pbt_port = '+IntTostr(FIeldbyname('POP3PORT').AsInteger)+',' ;
         al.Add(s)  ;
         s := '  pbt_smtp = '+Quotedstr(Fieldbyname('SMTP').AsString)+',';
         al.Add(s) ;
         s := '  pbt_portsmtp = '+Inttostr(Fieldbyname('SMTPPORT').AsInteger) ;
         al.add(s) ;
         s := ' Where Upper(pbt_adrprinc) = Upper('+Quotedstr(Fieldbyname('EMAIL').AsString)+');';
         al.Add(s) ;
         al.Add('<---->') ;
         al.Add('Commit;');
         al.Add('<---->') ;
       
        Next ;
       end;
     dlgSavefile.DefaultFolder := 'C:\Developpement\Ginkoia\Patch\' ;
     if dlgSavefile.Execute then
      begin
       al.SaveToFile(dlgSavefile.FileName) ;  
       Shellexecute(handle, 'open','NOTEPAD.EXE', Pchar(dlgSavefile.FileName),nil, SW_NORMAL) ; 
      end;

    
    end;

 Finally
   al.free ;
 End;

end;

procedure TFmain.Btn_testClick(Sender: TObject);
var Account : Taccount ;
    Pop3 : Tpop3Client ;
    Smtp : TSmtpClient ;
    k :integer ;
begin
Try
btn_test.Enabled := false ;

if edtCentrale.text <> '' then
  begin
  Application.CreateForm(TFlog, Flog);
  Flog.Fcanclose := False ;
  Flog.Memo.Lines.Clear ;
  Flog.memo.Lines.Add('Connection centrale->'+edtCentrale.Text) ;
  Flog.Memo.lines.Add('') ;
  Flog.Memo.lines.Add('') ;
  Flog.Show ;
  Account := TAccount.Create(edtEmail.Text, edtMdp.Text,'');
  Account.Host := edtpop3.Text ;
  Try
  Account.Port := StrToInt(edtPop3Port.Text) ;
  Except
  End;
  Flog.Memo.Lines.Add('Connexion au compte POP3 de réservation')  ;
  Pop3 := Tpop3Client.Create(Account, chkssl.Checked);
  if Pop3.PrepareUserPass then
   begin
    Flog.Memo.Lines.Add('Initialisation en mode USER PASS OK')  ; 
    Flog.Memo.lines.Add('') ;
    Flog.Memo.lines.Add('') ;  
    Try
      PoP3.Connect ;
      Flog.Memo.Lines.Add('Connexion OK')  ; 
      k := Pop3.Checkmessages ;
      if k > 0 then
       begin
         Flog.Memo.Lines.Add('Il y a actuellement '+inttostr(k)+' messages')  ;        
       end;
      
      Pop3.Disconnect ;
    Except
     ON E: Exception do
      begin
        Flog.Memo.Lines.Add(E.Message) ;
      end;
    End;
    Flog.Memo.lines.Add('') ;
    Flog.Memo.lines.Add('') ;  
   end else
   begin
    Flog.Memo.lines.Add('L''initialisation en mode USER PASS a échoué') ;
    Flog.Memo.lines.Add('') ;
    Flog.Memo.lines.Add('') ;    
   end;
   Pop3.Free ;
   Account.Username := edtArchive.Text ;
   Account.Password := edtAmdp.Text ;
  Flog.Memo.Lines.Add('Connexion au compte POP3 d''archivage')  ;
  Pop3 := Tpop3Client.Create(Account, chkssl.Checked);
  if Pop3.PrepareUserPass then
   begin
    Flog.Memo.Lines.Add('Initialisation en mode USER PASS OK')  ; 
    Flog.Memo.lines.Add('') ;
    Flog.Memo.lines.Add('') ;  
    Try
      PoP3.Connect ;
      Flog.Memo.Lines.Add('Connexion OK')  ; 
      k := Pop3.Checkmessages ;
      if k > 0 then
       begin
         Flog.Memo.Lines.Add('Il y a actuellement '+inttostr(k)+' messages')  ;        
       end;      
      Pop3.Disconnect ;
    Except
     ON E: Exception do
      begin
        Flog.Memo.Lines.Add(E.Message) ;
      end;
    End;
    Flog.Memo.lines.Add('') ;
    Flog.Memo.lines.Add('') ;  
   end else
   begin
    Flog.Memo.lines.Add('L''initialisation en mode USER PASS a échoué') ;
    Flog.Memo.lines.Add('') ;
    Flog.Memo.lines.Add('') ;    
   end;
   Pop3.Free ;   
   Account.Username := edtEmail.Text ;
   Account.Password := edtMdp.Text ;
   Account.Host := edtSmtp.Text ;
   Try
    Account.Port := StrToInt(edtSmtpPort.Text) ;
   Except
   End;   
   Flog.Memo.Lines.Add('Connexion au serveur SMTP en mode réservation')  ;
   Flog.Memo.lines.Add('') ;
   Flog.Memo.lines.Add('') ; 
   Smtp := TSmtpClient.Create(Account);
   Try
     Flog.memo.lines.Add('Compte : '+Account.username) ;
     Flog.memo.lines.Add('Host : '+Account.host) ;
     Flog.memo.lines.Add('Password : '+Account.Password) ;
     Smtp.Connect ;
     Flog.Memo.Lines.Add('Connexion OK');
     Flog.Memo.Lines.Add('Sender : '+Account.Username)  ;
     IdMessage.Sender.Address := Account.Username ;
     Flog.Memo.Lines.Add('Recipient : '+edtArchive.Text) ;
     IdMessage.Recipients.EMailAddresses := edtArchive.Text ;
     iDmessage.Subject := 'TEST' ;
     idMessage.Body.Add('Envoi du proramme de paramétrage Pprs') ;
     Smtp.Send(idMessage);
     Flog.Memo.Lines.Add('Envoi message Ok') ;
   Except
     On E : Exception do
      begin
         Flog.Memo.Lines.Add(E.Message) ;
      end;
   End;
   smtp.free ;
   Flog.Memo.lines.Add('') ;
   Flog.Memo.lines.Add('') ;   
   Account.Username := edtArchive.Text ;
   Account.Password := edtAMdp.Text ;
   Flog.Memo.Lines.Add('Connexion au serveur SMTP en mode archivage')  ;
   Flog.Memo.lines.Add('') ;
   Flog.Memo.lines.Add('') ; 
   Smtp := TSmtpClient.Create(Account);
   Try
     Smtp.Connect ;
     Flog.Memo.Lines.Add('Connexion OK');
   Except
     On E : Exception do
      begin
         Flog.Memo.Lines.Add(E.Message) ;
      end;
   End;
   smtp.free ;
   Flog.Memo.lines.Add('') ;
   Flog.Memo.lines.Add('') ;   
   Flog.Memo.Lines.Add('**********'+'C''est fini'+'**********')


  end else
  begin
    Beep ;
  end;
Finally
   btn_test.Enabled := True ;
   Flog.Fcanclose := True ;
End;
  
end;

procedure TFmain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  XLMDataModule.DSCentrale.SaveToFile(lab_file.Caption);
end;

procedure TFmain.FormShow(Sender: TObject);
begin
 Lab_file.caption :=
  XLMDataModule.DSCentrale.FileName ;
end;

end.
