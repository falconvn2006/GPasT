unit UThreadMail;

interface

uses
  System.Classes, System.SysUtils, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  IdBaseComponent, IdMailBox, IdMessage, IdAttachmentFile, IdSSLOpenSSL,
  UConstantes;

type
  TThreadMail = class(TThread)
  private
    FListeEmails: TStringList;
    FListeFichiers: TStringList;
    FSmtp: TIDSMTP;
    FMessage: TIDMessage;
    FIOHandler: TIdSSLIOHandlerSocketOpenSSL;
    FOnMessage: TMessageEvent;
    FEnCours: boolean;
    procedure DoOnMessageEvent(pText: string);
  protected
    procedure Execute; override;
  public
    constructor Create(ListeEmails: TStringList; FichiersJoints: TStringList; Params: TParamMail);
    destructor Destroy;
    property OnMessage: TMessageEvent read FOnMessage write FOnMessage;
    property EnCours: boolean read FEnCours;
  end;

implementation

constructor TThreadMail.Create(ListeEmails: TStringList; FichiersJoints: TStringList; Params: TParamMail);
begin
  inherited Create(true);
  FMessage := TIdMessage.Create(nil);
  FMessage.Subject := 'NbArticlesWebParDossier';
  FMessage.From.Address := Params.FromAddress;

  FSmtp := TIdSMTP.Create(nil);
  FSmtp.Port := params.SmtpPort;
  FSmtp.Host := params.SmtpHost;
  FSmtp.Username := params.SmtpUsername;
  FSmtp.Password := params.SmtpPassword;

  FIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create();
  FIOHandler.Destination := FSmtp.Host + ':' + IntToStr(FSmtp.Port);
  FIOHandler.Host := FSmtp.Host;
  FIOHandler.Port := FSmtp.Port;
  FIOHandler.SSLOptions.Method := Params.SSLVersion;
  FSmtp.IOHandler := FIOHandler;
  FSmtp.UseTLS := Params.SmtpUseTLS;

  FListeEmails := TStringList.Create;
  FListeEmails.Assign(ListeEmails);
  FListeFichiers := TStringList.Create;
  FListeFichiers.Assign(FichiersJoints);

end;

destructor TThreadMail.Destroy;
begin
  FListeEmails.Free;
  FMessage.Free;
  FIOHandler.Free;
  FSmtp.Free;
  inherited Destroy;
end;

procedure TThreadMail.DoOnMessageEvent(pText: string);
begin
  Synchronize(
    procedure
    begin
      if Assigned(FOnMessage) then
        FOnMessage(self,pText);
    end
  );
end;

procedure TThreadMail.Execute;
var
  iEmail: integer;
  iJoint: integer;
begin
  FEnCours := true;
  try
    if FListeEmails.Count > 0 then
    begin
      DoOnMessageEvent('Création des pièces jointes');
      for iJoint := 0 to FListeFichiers.Count -1 do
      begin
        if Terminated then
        begin
          DoOnMessageEvent('Arret utilisateur en cours');
          Break;
        end;
        try
          TIdAttachmentFile.Create(FMessage.MessageParts,FListeFichiers[iJoint]);
        except
          on E:Exception do
            DoOnMessageEvent('Impossible d''ajouter le fichier '+FListeFichiers[iJoint]+' : '+E.Message);
        end;
      end;
      DoOnMessageEvent('Connexion au serveur '+FSmtp.Host);
      try
        FSmtp.Connect;
        for iEmail := 0 to FListeEmails.Count -1 do
        begin
          if Terminated then
          begin
            DoOnMessageEvent('Arret utilisateur en cours');
            Break;
          end;
          if FListeEmails[iEmail] <> '' then
          begin
            FMessage.Recipients.EMailAddresses := FListeEmails[iEmail];
            try
              FSmtp.Send(FMessage);
              DoOnMessageEvent('Message envoyé à '+FMessage.Recipients.EMailAddresses);
            except
              on E:Exception do
                DoOnMessageEvent('Erreur envoi à '+FMessage.Recipients.EMailAddresses+' : '+E.Message);
            end;
          end;
        end;
      except
        on E:Exception do
          DoOnMessageEvent('Erreur connexion : '+E.Message);
      end;
      FSmtp.Disconnect;

    end
    else
      DoOnMessageEvent('Aucun destinataire renseigné');
  finally
    FEnCours := false;
  end;
end;

end.
