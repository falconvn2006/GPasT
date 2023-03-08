unit GestionEMail;

interface

uses
  Classes, IdComponent, IdSASL,

  IdSASLPlain, IdUserPassProvider, IdSASLCollection;

type
  SecuriteMail = (tsm_Aucun, tsm_TLS, tsm_SSL);
  TLogEvent = procedure (Sender: TObject; aMsg: string) of object;

// à utiliser pour que ça fonctionne sur les lames outils + gestion des logs
  TMailManager = class(TObject)
  private
    FLog: TLogEvent;
    Ftitre: string;
    FPiecesJointes: TStrings;
    Fdestinataires: TStrings;
    FSecurite: SecuriteMail;
    Fport: Integer;
    Fexpediteur: string;
    FPassword: string;
    Ftext: string;
    FLogin: string;
    Fserveur: string;
  public
    procedure doSendEmail;
  published
    property serveur : string read Fserveur write Fserveur;
    property port : Integer read Fport write Fport;
    property Login : string read FLogin write FLogin;
    property Password : string read FPassword write FPassword;
    property Securite : SecuriteMail read FSecurite write FSecurite;
    property expediteur : string read Fexpediteur write Fexpediteur;
    property destinataires : TStrings read Fdestinataires write Fdestinataires;
    property titre : string read Ftitre write Ftitre;
    property text : string read Ftext write Ftext;
    property PiecesJointes : TStrings read FPiecesJointes write FPiecesJointes;
    property onLog : TLogEvent read FLog write FLog;
  end;
// ça ne fonctionne pas sur la lame outils
function SendMail(serveur : string; port : Integer; Login, Password : string; Securite : SecuriteMail;
                  expediteur, destinataire, titre, text : string;
                  PieceJointe : String) : Boolean; overload;

function SendMail(serveur : string; port : Integer; Login, Password : string; Securite : SecuriteMail;
                  expediteur, destinataire, titre, text : string;
                  PiecesJointes : TStrings = nil) : Boolean; overload;

function SendMail(serveur : string; port : Integer; Login, Password : string; Securite : SecuriteMail;
                  expediteur : string; destinataires : TStrings; titre, text : string;
                  PieceJointe : string) : Boolean; overload;

function SendMail(serveur : string; port : Integer; Login, Password : string; Securite : SecuriteMail;
                  expediteur : string; destinataires : TStrings; titre, text : string;
                  PiecesJointes : TStrings = nil) : Boolean; overload;

implementation

uses
  IdGlobal,
  IdSMTP,
  IdIOHandler,
  IdMessage,
  IdEMailAddress,
  IdAttachmentFile,
  IdExplicitTLSClientServerBase,
  IdSSL,
  IdSSLOpenSSL,
  SysUtils;

function SendMail(serveur : string; port : Integer; Login, Password : string; Securite : SecuriteMail;
                  expediteur, destinataire, titre, text : string;
                  PieceJointe : String) : Boolean;
var
  PiecesJointes : TStringList;
  destinataires : TStringList;
begin
  try
    PiecesJointes := TStringList.Create();
    PiecesJointes.Add(PieceJointe);
    destinataires := TStringList.Create();
    destinataires.Add(destinataire);
    Result := SendMail(serveur, port, Login, Password, Securite, expediteur, destinataires, titre, text, PiecesJointes);
  finally
    FreeAndNil(PiecesJointes);
    FreeAndNil(destinataires);
  end;
end;

function SendMail(serveur : string; port : Integer; Login, Password : string; Securite : SecuriteMail;
                  expediteur, destinataire, titre, text : string;
                  PiecesJointes : TStrings) : Boolean;
var
  destinataires : TStringList;
begin
  try
    destinataires := TStringList.Create();
    destinataires.Add(destinataire);
    Result := SendMail(serveur, port, Login, Password, Securite, expediteur, destinataires, titre, text, PiecesJointes);
  finally
    FreeAndNil(destinataires);
  end;
end;

function SendMail(serveur : string; port : Integer; Login, Password : string; Securite : SecuriteMail;
                  expediteur : string; destinataires : TStrings; titre, text : string;
                  PieceJointe : string) : Boolean; overload;
var
  PiecesJointes : TStringList;
begin
  try
    PiecesJointes := TStringList.Create();
    PiecesJointes.Add(PieceJointe);
    Result := SendMail(serveur, port, Login, Password, Securite, expediteur, destinataires, titre, text, PiecesJointes);
  finally
    FreeAndNil(PiecesJointes);
  end;
end;

function SendMail(serveur : string; port : Integer; Login, Password : string; Securite : SecuriteMail;
                  expediteur : string; destinataires : TStrings; titre, text : string;
                  PiecesJointes : TStrings = nil) : Boolean; overload;
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

    Mesg.From.Text := expediteur;
    for i := 0 to destinataires.Count -1 do
      with Mesg.Recipients.Add() do
        Text := destinataires[i];

    Mesg.Subject := titre;
    Mesg.Body.Text := text;

    if Assigned(PiecesJointes) then
      for i := 0 to PiecesJointes.Count -1 do
        if FileExists(PiecesJointes[i]) then
          TIdAttachmentFile.Create(Mesg.MessageParts, PiecesJointes[i]);


    try

      SMTP.Connect();
      try
        if SMTP.Authenticate then
        begin
          try
            SMTP.Send(Mesg);
            Result := True;
          except
            On E:Exception do
            begin
              raise Exception.Create('L''envoi a échoué : ' + E.Message);
            end;
          end;
        end
        else
          raise Exception.Create('L''authentification a échoué');
      finally
        SMTP.Disconnect();
      end;
    except
      Result := False;
    end;

  finally
    FreeAndNil(Mesg);
    FreeAndNil(SMTP);
  end;
end;

{ TServicesManager }

procedure TMailManager.doSendEmail;
var
  SMTP : TIdSMTP;
  SASLPlain : TIdSASLPlain;
  ListSASLPlain : TIdSASLListEntry;
  UserPassProvider : TIdUserPassProvider;
  IOHandler : TIdSSLIOHandlerSocketOpenSSL;
  Mesg : TIdMessage;
  i : Integer;
begin
  try
    SMTP := TIdSmtp.Create(nil);
    Mesg := TIdMessage.Create(SMTP);
    SASLPlain := TIdSASLPlain.Create(SMTP);
    UserPassProvider := TIdUserPassProvider.Create(SMTP);

    UserPassProvider.Username := Login;
    UserPassProvider.Password := Password;
    SASLPlain.UserPassProvider := UserPassProvider;


    ListSASLPlain := SMTP.SASLMechanisms.Add;
    ListSASLPlain.SASL := SASLPlain;


    SMTP.AuthType := satSASL;
    SMTP.Host := serveur;
    SMTP.Port := port;
    SMTP.Username := Login;
    SMTP.Password := Password;

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

    Mesg.From.Text := expediteur;
    for i := 0 to destinataires.Count -1 do
      with Mesg.Recipients.Add() do
        Text := destinataires[i];

    Mesg.Subject := titre;
    Mesg.Body.Text := text;

    if Assigned(PiecesJointes) then
      for i := 0 to PiecesJointes.Count -1 do
        if FileExists(PiecesJointes[i]) then
          TIdAttachmentFile.Create(Mesg.MessageParts, PiecesJointes[i]);


    try
      if Assigned(onLog) then
        onLog(self, 'Mail - Connect : Try');
      SMTP.Connect();
      try
        if Assigned(onLog) then
          onLog(self, 'Mail - Connect : Ok');
        if Assigned(onLog) then
          onLog(self, 'Mail - Authenticate : Try ('+Login+'/'+Password+')');
        if SMTP.Authenticate then
        begin
          if Assigned(onLog) then
            onLog(self, 'Mail - Authenticate : Ok');
          try
            if Assigned(onLog) then
              onLog(self, 'Mail - Send : Try');
            SMTP.Send(Mesg);
            if Assigned(onLog) then
              onLog(self, 'Mail - Send : Ok');
          except
            On E:Exception do
            begin
              if Assigned(onLog) then
                onLog(self, 'Mail - Send : Echec : '+e.Message);
            end;
          end;
        end
        else
          if Assigned(onLog) then
            onLog(self, 'Mail - Authenticate : Echec');
      finally
        if Assigned(onLog) then
          onLog(self, 'Mail - Disconnect : Try');
        SMTP.Disconnect();
        if Assigned(onLog) then
          onLog(self, 'Mail - Disconnect : Ok');
      end;
    except
      On E:Exception do
      begin
        if Assigned(onLog) then
          onLog(self, 'Mail - Connect : Echec : '+e.Message);
      end;
    end;

  finally
//    FreeAndNil(Mesg);
    FreeAndNil(SMTP);
  end;
end;

end.

