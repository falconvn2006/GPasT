unit GestionEMail;

interface

uses
  Classes;

type
  SecuriteMail = (tsm_Aucun, tsm_TLS, tsm_SSL);

function SendMail(serveur : string; port : Integer; Login, Password : string; Securite : SecuriteMail;
                  expediteur, destinataires, titre, text : string;
                  PiecesJointes : TStrings) : Boolean;

implementation

uses
  IdGlobal, IdSMTP, IdIOHandler, IdMessage, IdAttachmentFile,
  IdExplicitTLSClientServerBase, IdSSL, IdSSLOpenSSL,
  SysUtils;

function SendMail(serveur : string; port : Integer; Login, Password : string; Securite : SecuriteMail;
                  expediteur, destinataires, titre, text : string;
                  PiecesJointes : TStrings) : Boolean;
var
  SMTP : TIdSMTP;
  IOHandler : TIdSSLIOHandlerSocketOpenSSL;
  Mesg : TIdMessage;
  i : Integer;
begin
   try
     SMTP := TIdSmtp.Create(nil);
     Mesg := TIdMessage.Create(SMTP);

     SMTP.Host := serveur;
     SMTP.Port := port;
     if not ((Trim(Login) = '') or (Trim(Password) = '')) then
     begin
       SMTP.AuthType := satDefault;
       SMTP.Username := Login;
       SMTP.Password := Password;
     end
     else
       SMTP.AuthType := satNone;
     case Securite of
       tsm_TLS :
         begin
           IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create();
           IOHandler.Destination := serveur + ':' + IntToStr(Port);
           IOHandler.Host := serveur;
           IOHandler.Port := port;
           IOHandler.SSLOptions.Method := sslvTLSv1;
           SMTP.IOHandler := IOHandler;
           SMTP.UseTLS := utUseExplicitTLS;
         end;
       tsm_SSL :
         begin
           IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create();
           IOHandler.Destination := serveur + ':' + IntToStr(Port);
           IOHandler.Host := serveur;
           IOHandler.Port := port;
           IOHandler.SSLOptions.Method := sslvSSLv23;
           SMTP.IOHandler := IOHandler;
           SMTP.UseTLS := utUseImplicitTLS;
         end;
       else
         begin
           SMTP.UseTLS := utNoTLSSupport;
         end;
     end;

     Mesg.From.Name := expediteur;
     Mesg.From.Address := expediteur;
     Mesg.Recipients.EMailAddresses := destinataires;

     Mesg.Subject := titre;
     Mesg.Body.Text := text;

     if Assigned(PiecesJointes) then
       for i := 0 to PiecesJointes.Count -1 do
         if FileExists(PiecesJointes[i]) then
           TIdAttachmentFile.Create(Mesg.MessageParts, PiecesJointes[i]);

     try
       SMTP.Connect();
       SMTP.Send(Mesg, expediteur);
       SMTP.Disconnect();
       Result := True;
     except
       Result := False;
     end;
   finally
     FreeAndNil(Mesg);
     FreeAndNil(SMTP);
   end;
end;

end.

