unit UThreadEnvoiCourriel;

interface

uses
  Classes, SysUtils, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP, IdMessage, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, Windows;

type
  TThreadEnvoiCourriel = class(TThread)
  strict private
    { Déclarations privées }
    IdSMTP                      : TIdSMTP;
    IdMessage                   : TIdMessage;
    IdSSLIOHandlerSocketOpenSSL : TIdSSLIOHandlerSocketOpenSSL;
  protected
    procedure Execute(); override;
  public
    { Déclarations publiques }
    Erreur        : Boolean;
    MessageErreur : String;
    Hote          : String;
    Utilisateur   : String;
    MotPasse      : String;
    Port          : Word;
    TLS           : Boolean;
    Expediteur    : String;
    Destinataires : String;
    Objet         : String;
    Contenu       : String;
  end;

implementation

{ TThreadEnvoiCourriel }

procedure TThreadEnvoiCourriel.Execute();
begin
  Erreur                      := True;
  IdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  IdMessage                   := TIdMessage.Create(nil);
  IdSMTP                      := TIdSMTP.Create(nil);
  try
    try
      IdSSLIOHandlerSocketOpenSSL.Destination   := ':25';
      IdSSLIOHandlerSocketOpenSSL.Port          := 25;
      IdSSLIOHandlerSocketOpenSSL.DefaultPort   := 0;
      IdMessage.AttachmentEncoding              := 'UUE';
      IdMessage.ContentType                     := 'text';
      IdMessage.ContentTransferEncoding         := 'quoted-printable';
      IdMessage.Encoding                        := meDefault;
      IdSMTP.HeloName                           := 'RecalStock';
      IdSMTP.IOHandler                          := IdSSLIOHandlerSocketOpenSSL;

      IdSMTP.Host                               := Self.Hote;
      IdSMTP.Username                           := Self.Utilisateur;
      IdSMTP.Password                           := Self.MotPasse;
      IdSMTP.Port                               := Self.Port;
      if Self.TLS then
        IdSMTP.UseTLS                           := utUseRequireTLS
      else
        IdSMTP.UseTLS                           := utNoTLSSupport;
      IdMessage.From.Address                    := Self.Expediteur;
      IdMessage.Recipients.EMailAddresses       := Self.Destinataires;

      IdMessage.Subject                         := UTF8Encode(Self.Objet);
      IdMessage.Body.Text                       := UTF8Encode(Self.Contenu);

      try
        IdSMTP.Connect();
        IdSMTP.Send(IdMessage);
        Erreur := False;
      finally
        IdSMTP.Disconnect();
      end;
    except
      on E: Exception do
      begin
        MessageErreur := Format('%s : %s', [E.ClassName, E.Message]);
        OutputDebugString(PChar(MessageErreur));
      end;
    end;
  finally
    IdSMTP.Free();
    IdMessage.Free();
    IdSSLIOHandlerSocketOpenSSL.Free();
  end;
end;

end.
