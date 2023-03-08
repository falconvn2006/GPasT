unit MainCMB_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, CMBDefs, IdMessage,
  IdSMTPBase, IdSMTP, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdPOP3, Spin, DateUtils, IniFiles;

type
  Tfrm_MainCMB = class(TForm)
    Gbx_Memo: TGroupBox;
    Pan_Logs: TPanel;
    mmLogs: TMemo;
    ProgressBar1: TProgressBar;
    IdPOP: TIdPOP3;
    IdSMTP: TIdSMTP;
    IdMessage: TIdMessage;
    Pan_Mail: TPanel;
    Pan_Action: TPanel;
    Gbx_Actions: TGroupBox;
    Date: TLabel;
    dtpErase: TDateTimePicker;
    Nbt_SuppMail: TBitBtn;
    Pan_MailLeft: TPanel;
    Pan_MailRight: TPanel;
    Gbx_Mail: TGroupBox;
    Gbx_MailDest: TGroupBox;
    Lab_AdrDest: TLabel;
    Lab_AdrSource: TLabel;
    Lab_PortPop: TLabel;
    Lab_POP3: TLabel;
    Lab_PassWord: TLabel;
    edt_Username: TEdit;
    edt_Pop3: TEdit;
    edt_Password: TEdit;
    Chp_Port: TSpinEdit;
    edt_Dest: TEdit;
    Lab_SMTP: TLabel;
    edt_SMTP: TEdit;
    Lab_PortSMTP: TLabel;
    Chp_PortSMTP: TSpinEdit;
    Lab_PCent: TLabel;
    Chk_Twinner: TCheckBox;
    Nbt_Test: TBitBtn;
    Nbt_SuppWithoutArch: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_SuppMailClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_TestClick(Sender: TObject);
    procedure Nbt_SuppWithoutArchClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure AddToMemo(sText : String);
  end;

var
  frm_MainCMB: Tfrm_MainCMB;

implementation

{$R *.dfm}

procedure Tfrm_MainCMB.AddToMemo(sText: String);
begin

  while mmLogs.Lines.Count > 10000 do
    mmLogs.Lines.Delete(0);

  mmLogs.Lines.Add(FormatDateTime('[DD/MM/YYYY hh:mm:ss] => ',Now) + sText);

end;

procedure Tfrm_MainCMB.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    WriteString('MAILSOURCE','USER',edt_Username.Text);
    WriteString('MAILSOURCE','POP',edt_Pop3.Text);
    WriteString('MAILSOURCE','PW',edt_Password.Text);
    WriteString('MAILSOURCE','SMTP',edt_SMTP.Text);
    WriteInteger('MAILSOURCE','PORTPOP',Chp_Port.Value);
    WriteInteger('MAILSOURCE','PORTSMTP',Chp_PortSMTP.Value);

    WriteString('MAILDEST','DEST', edt_Dest.Text);
  finally
    free;
  end;

end;

procedure Tfrm_MainCMB.FormCreate(Sender: TObject);
begin
  Caption := CVERSION;
  GAPPPATH := ExtractFilePath(Application.ExeName);

  With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    edt_Username.Text  := ReadString('MAILSOURCE','USER','');
    edt_Pop3.Text      := ReadString('MAILSOURCE','POP','');
    edt_Password.Text  := ReadString('MAILSOURCE','PW','');
    edt_SMTP.Text      := ReadString('MAILSOURCE','SMTP','');
    Chp_Port.Value     := ReadInteger('MAILSOURCE','PORTPOP',110);
    Chp_PortSMTP.Value := ReadInteger('MAILSOURCE','PORTSMTP',25);

    edt_Dest.Text      := ReadString('MAILDEST','DEST','');
  finally
    free;
  end;

end;

procedure Tfrm_MainCMB.Nbt_SuppMailClick(Sender: TObject);
var
  iNbMail, i, iNbTraite : Integer;
  sTmp : String;
  lst : TStringList;
begin
  case MessageDlg('Attention, suppression des mails inférieurs au ' + FormatDateTime('DD/MM/YYYY',dtpErase.Date) + ' (Inclus)',mtConfirmation,mbYesNo,0) of
     mrYes : begin
       // ouverture du SMTP pour l'envoi du mail
       With IdSMTP do
       begin
         IdSMTP.Disconnect;
         IdSMTP.Username := edt_Username.Text;
         IdSMTP.Host     := edt_SMTP.Text;
         IdSMTP.Password := edt_Password.Text;
         IdSMTP.Port     := Chp_PortSMTP.Value;
         try
           IdSMTP.Connect;
         Except on E:Exception do
           begin
             AddToMemo('SMTP Error : ' + E.Message);
             Exit;
           end;
         end;
       end;

       // Ouverture du pop3
       With IdPop do
       try
         Disconnect;
         Username := edt_Username.Text;
         Host     := edt_Pop3.Text;
         Password := edt_Password.Text;
         Port     := Chp_Port.Value;

         lst := TStringList.Create;
         try
           Connect;

           // récupération du nombre de mail de la boite
           iNbMail := CheckMessages;
           AddToMemo('Nombre mail : ' + IntToStr(iNbMail));
           iNbTraite := 0;
           for i := iNbMail downto 1 do
           begin
             sTmp := '';
             RetrieveHeader(i,IdMessage);
             // récupération du mail
             if DateOf(IdMessage.Date) <= DateOf(dtpErase.Date) then
             begin
               sTmp := 'Archivage de : ' + IdMessage.Subject;
               sTmp := sTmp + '; Date Mail : ' + FormatDateTime('DD/MM/YYYY hh:mm:ss',IdMessage.date);

               if chk_Twinner.checked then
               begin
                  IdMessage.NoEncode := True;
                  IdMessage.NoDecode := True;
                  Retrieve(i,IdMessage);

                  IdMessage.SaveToFile(GAPPPATH + 'ArchTmp.txt');

                  lst.LoadFromFile(GAPPPATH + 'ArchTmp.txt');
                  lst.Text := StringReplace(lst.Text,#13#13#10,#13#10,[rfReplaceAll]);
                  lst.SaveToFile(GAPPPATH + 'ArchTmpb.txt');

                  IdMessage.NoEncode := False;
                  IdMessage.NoDecode := False;
                  IdMessage.LoadFromFile(GAPPPATH + 'ArchTmpb.txt');
               end
               else
                 Retrieve(i,IdMessage);

               IdMEssage.FromList.Clear;
               IdMessage.From.Address := edt_Dest.Text;
               IdMessage.Recipients.EMailAddresses := edt_Dest.Text;
               IdMessage.CCList.Clear;
               IdMessage.BccList.Clear;

               sTmp := sTmp + '; Transfert : OK';
               try
                 IdSMTP.Send(IdMessage);

                 if Delete(i) then
                 begin
                   sTmp := sTmp + '; Suppression : Ok';
                   inc(iNbTraite);
                 end
                 else
                   sTmp := sTmp + '; Suppression : Ko';
                AddTomemo(sTmp);
               Except on E:Exception do
                 AddToMemo('Erreur : ' + E.Message);
               end;
             end;

             ProgressBar1.Position := (iNbMail - i) * 100 Div iNbMail;
             lab_Pcent.Caption := IntToStr(iNbMail - i) + ' / ' + IntToStr(iNbMail);
             Application.ProcessMessages;

           end;
           AddToMemo('Nombre de mails archivés : ' + IntTostr(iNbTraite));
           Disconnect;

         Except on E:Exception do
           begin
             AddToMemo('Pop3 erreur : ' + E.Message);
             Exit;
           end;
         end;
       finally
         lst.Free;
       end; // with

     end;
  end;
end;

procedure Tfrm_MainCMB.Nbt_SuppWithoutArchClick(Sender: TObject);
var
  iNbMail, i, iNbTraite : Integer;
  sTmp : String;
  lst : TStringList;
begin
  case MessageDlg('Attention, suppression des mails inférieurs au ' + FormatDateTime('DD/MM/YYYY',dtpErase.Date) + ' (Inclus)',mtConfirmation,mbYesNo,0) of
     mrYes : begin
       // Ouverture du pop3
       With IdPop do
       begin
         Disconnect;
         Username := edt_Username.Text;
         Host     := edt_Pop3.Text;
         Password := edt_Password.Text;
         Port     := Chp_Port.Value;

         try
           Connect;

           // récupération du nombre de mail de la boite
           iNbMail := CheckMessages;
           AddToMemo('Nombre mail : ' + IntToStr(iNbMail));
           iNbTraite := 0;

           for i := iNbMail downto 1 do
           begin
             try

               sTmp := '';
               RetrieveHeader(i,IdMessage);
               // récupération du mail
               if DateOf(IdMessage.Date) <= DateOf(dtpErase.Date) then
               begin
                 sTmp := IntToStr(iNbMail - i) + '- Suppression de : ' + IdMessage.Subject;
                 sTmp := sTmp + '; Date Mail : ' + FormatDateTime('DD/MM/YYYY hh:mm:ss',IdMessage.date);
                   if Delete(i) then
                   begin
                     sTmp := sTmp + '; Suppression : Ok';
                     inc(iNbTraite);
                   end
                   else
                     sTmp := sTmp + '; Suppression : Ko';

                   // tout les 100 on deconnecte reconnect pour que les mails soient supprimés.
                   if (i Mod 100) = 0 then
                   begin
                     Disconnect;
                     Connect;
                   end;

                  AddTomemo(sTmp);
               end;
               Except on E:Exception do
               AddToMemo('Erreur : ' + E.Message);
             end;

             ProgressBar1.Position := (iNbMail - i) * 100 Div iNbMail;
             lab_Pcent.Caption := IntToStr(iNbMail - i) + ' / ' + IntToStr(iNbMail);
             Application.ProcessMessages;

           end;
           AddToMemo('Nombre de mails supprimés : ' + IntTostr(iNbTraite));
           Disconnect;

         Except on E:Exception do
           begin
             AddToMemo('Pop3 erreur : ' + E.Message);
             Exit;
           end;
         end;
       end; // with

     end;
  end;
end;

procedure Tfrm_MainCMB.Nbt_TestClick(Sender: TObject);
var
  lst : TStringList;
  i, iNbMail, iNbTraite : Integer;
  sTmp : String;
begin
       With IdPop do
       try
         Disconnect;
         Username := edt_Username.Text;
         Host     := edt_Pop3.Text;
         Password := edt_Password.Text;
         Port     := Chp_Port.Value;

         lst := TStringList.Create;
         try
           Connect;

           // récupération du nombre de mail de la boite
           iNbMail := CheckMessages;
           AddToMemo('Nombre mail : ' + IntToStr(iNbMail));
           iNbTraite := 0;
           for i := iNbMail downto 1 do
           begin
             try
               RetrieveHeader(i,IdMessage);

               if DateOf(IdMessage.Date) <= DateOf(dtpErase.Date) then
                 sTmp := IntToStr(iNbMail - i) + ' - Suppression de : ' + IdMessage.Subject
               else
                 sTmp := IntToStr(iNbMail - i) + ' - Pas d''action sur : ' + IdMessage.Subject;
               sTmp := sTmp + '; Date Mail : ' + FormatDateTime('DD/MM/YYYY hh:mm:ss',IdMessage.date);

               AddToMemo(sTmp);
               ProgressBar1.Position := (iNbMail - i) * 100 Div iNbMail;
               lab_Pcent.Caption := IntToStr(iNbMail - i) + ' / ' + IntToStr(iNbMail);
               Application.ProcessMessages;
             Except on E:Exception do
               AddTOMemo('Erreur : ' + E.Message);
             end;

           end;
           Disconnect;

         Except on E:Exception do
           begin
             AddToMemo('Pop3 erreur : ' + E.Message);
             Exit;
           end;
         end;
       finally
         lst.Free;
       end; // with

end;

end.
