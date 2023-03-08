unit uImap4;

interface

uses IdIMAP4, IdExplicitTLSClientServerBase, IdSSL, IdSSLOpenSSL, IdMessageCollection,
     SysUtils, Classes, StdCtrls, ComCtrls, IdComponent, Forms, IdLogEvent;

Type
  IMAP4Class = Class
  private
    FIDIMAP4 : TIDIMAP4;
    FIDSSL  : TIdSSLIOHandlerSocketOpenSSL;
    FIdLogEvent  : TIdLogEvent;
    FIdMessageCollection : TIdMessageCollection;
    FUseTLS: TIdUseTLS;
    FSSLMethod: TIdSSLVersion;

    FMailBoxList : TStringList;
    FLabel: TLabel;
    FPGStatus: TProgressBar;
    FWorkCountMax : Int64;

    procedure SetUseTLS(const Value: TIdUseTLS);
    procedure SetSSLMethod(const Value: TIdSSLVersion);
    function GetIDSSL: TIdSSLIOHandlerSocketOpenSSL;
    function GetCurrentMailBoxName : String;
    function GetCurrentMailBoxcount: Integer;
    function GetMailBoxList: TStringList;

    procedure IMAPStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    procedure IMAPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure IMAPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);

    procedure IdLogEventReceived(ASender: TComponent; const AText, AData: string);


  public
    // Permet de créer la le composant IMAP avec les informations de connection
    constructor Create(AHost, AUser, APassWord : String; APort : Integer; ASSL : Boolean = False);
    destructor Destroy;

    // déconnecte le composant IMAP
    procedure Disconnect;
    // connect le composant IMAP
    procedure Connect;
    // Positione le composant IMAP sur le répetoire ABoxName de la boite mail
    function SelectMailBox(ABoxName : String) : Boolean;
    // Permet de copier un message vers le répertoire ABoxName de la boite mail
    function CopyMsg(AIdMessage : Integer; ABoxName : String) : Boolean;
    // Permet de déplacer un messge vers le répertoire ABoxName de la boite mail
    function MoveMsg(AIdMessage : Integer; ABoxName : String) : Boolean;
    // Permet de valider la suppression des messages déplacés avec MoveMsg
    function ValidMoveMsg : Boolean;
    // Permet de charger dans FIdMessageCollection les Headers des mails du répertoire courant
    procedure LoadAllMailBoxMsgHeader;
    // permet de charger dans FIdMessageCollection les mails du répertoire courant
    procedure LoadAllMailBoxMsg;
    // Permet de créer un répertoire (XXXX/AAA créera un sous répertoire AAA dans XXXX)
    function CreateMailBox(ABoxName : String) : Boolean;
  published
    // Peremt d'avoir changer le mode de connexion ImplicitTLS, etc ...
    property UseTLS : TIdUseTLS read FUseTLS write SetUseTLS;
    // Peremt de changer la Methode SSL (SSLVer1, etc ...)
    property SSLMethod : TIdSSLVersion read FSSLMethod write SetSSLMethod;

    // Permet d'avoir accès au composant IMAP utilise dans cette classe
    property IDIMAP4 : TIdIMAP4 read FIDIMAP4;
    // Permet d'avoir accès au composant SSL utilisé dans cette classe
    property IDSSL : TIdSSLIOHandlerSocketOpenSSL read GetIDSSL;

    // retourne le nom du répertoire en cours
    property CurrentMailBoxName : String read GetCurrentMailBoxName;
    // retourne le nombre de mail présent dans répertoire en cours
    property CurrentMailBoxcount : Integer read GetCurrentMailBoxcount;

    // Retourne la liste de tous les répertoires présent dans la boite mail
    property MailboxList : TStringList read GetMailBoxList;
    // Permet d'avoir accès à la liste des mails récupérer avec procedure LoadAllxxxxx
    property MsgList : TIdMessageCollection read FIdMessageCollection;

    // Permet de gérer l'affichage d'un label passé en paramètre
    property LabStatus : TLabel read FLabel write FLabel;
    // Permet de gérer la progression lors de la récupération des mails avec LoadAllxxxx
    property PGStatus : TProgressBar read FPGStatus write FPGStatus;
  End;

implementation

{ IMAP4Class }

procedure IMAP4Class.Connect;
begin
  if FIDIMAP4.Connected then
    FIDIMAP4.Disconnect;

  try
    FIDIMAP4.Connect;
  Except on E:Exception do
    raise Exception.Create('Connexion erreur : ' + E.Message);
  end;
end;

function IMAP4Class.CopyMsg(AIdMessage: Integer; ABoxName: String): Boolean;
begin
  Result := FIDIMAP4.CopyMsg(AIdMessage,ABoxName);
end;

constructor IMAP4Class.Create(AHost, AUser, APassWord: String; APort: Integer;
  ASSL: Boolean);
begin
  inherited Create;

  FIDIMAP4 := TIdIMAP4.Create(nil);
  if ASSL then
  begin
    FIDIMAP4.OnStatus := IMAPStatus;

    FIDSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

    FIDSSL.SSLOptions.Method := sslvTLSv1_2;
    FIDSSL.ConnectTimeout := 30000;
    FIDSSL.ReadTimeout    := 30000;

    FIDIMAP4.IOHandler := FIDSSL;
  end;

  FIdLogEvent := TIdLogEvent.Create(nil);
  FIdLogEvent.OnReceived := IdLogEventReceived;
  FIDIMAP4.Intercept := FIdLogEvent;

  FIdIMAP4.Host := AHost;
  FIdIMAP4.Port := APort;
  FIdIMAP4.UseTLS := utUseImplicitTLS;
  FIdIMAP4.Username := AUser;
  FIdIMAP4.Password := APassWord;
  FIDIMAP4.ConnectTimeout := 30000;
  FIDIMAP4.ReadTimeout    := 30000;

  FMailBoxList := TStringList.Create;
  FIdMessageCollection := TIdMessageCollection.Create;

end;

function IMAP4Class.CreateMailBox(ABoxName: String): Boolean;
begin
  Result := FIDIMAP4.CreateMailBox(ABoxName);
end;

destructor IMAP4Class.Destroy;
begin
  FIdLogEvent.Free;
  FMailBoxList.Free;
  FIdMessageCollection.Free;
  if Assigned(FIDSSL) then
    FIDSSL.Free;
  FIDIMAP4.Free;
end;

procedure IMAP4Class.Disconnect;
begin
  FIDIMAP4.Disconnect;
end;

function IMAP4Class.GetCurrentMailBoxcount: Integer;
begin
  Result := FIDIMAP4.MailBox.TotalMsgs;
end;

function IMAP4Class.GetCurrentMailBoxName : String;
begin
  Result := FIDIMAP4.MailBox.Name;
end;

function IMAP4Class.GetIDSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  if Assigned(FIDSSL) then
    Result := FIDSSL
  else
   Result := nil;
end;

function IMAP4Class.GetMailBoxList: TStringList;
begin
  FIDIMAP4.ListMailBoxes(FMailBoxList);
  Result := FMailBoxList;
end;

procedure IMAP4Class.IdLogEventReceived(ASender: TComponent; const AText,
  AData: string);
begin
  if (FPGStatus <> nil) and (CurrentMailBoxcount > 0) then
    FPGStatus.Position := FIdMessageCollection.Count * 100 Div CurrentMailBoxcount;
  Application.ProcessMessages;
end;

procedure IMAP4Class.IMAPStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  if FLabel <> nil then
    FLabel.Caption := AStatusText;
  Application.ProcessMessages;
end;

procedure IMAP4Class.IMAPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  if (FPGStatus <> nil) and (FWorkCountMax > 0) then
    FPGStatus.Position := FIdMessageCollection.Count * 100 Div FWorkCountMax;
  Application.ProcessMessages;
end;

procedure IMAP4Class.IMAPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  FWorkCountMax := CurrentMailBoxcount; // AWorkCountMax;
  Application.ProcessMessages;
end;

procedure IMAP4Class.LoadAllMailBoxMsg;
begin
  FIDIMAP4.OnWork := IMAPWork;
  FIDIMAP4.OnWorkBegin := IMAPWorkBegin;

  FIdLogEvent.Active := True;
  try
    FIdMessageCollection.Clear;
    FIDIMAP4.RetrieveAllMsgs(FIdMessageCollection);
  finally
    FIDIMAP4.OnWork := Nil;
    FIDIMAP4.OnWorkBegin := Nil;
    FIdLogEvent.Active := False;
  end;
end;

procedure IMAP4Class.LoadAllMailBoxMsgHeader;
begin
  FIDIMAP4.OnWork := IMAPWork;
  FIDIMAP4.OnWorkBegin := IMAPWorkBegin;
  try
    FIdMessageCollection.Clear;
    FIDIMAP4.RetrieveAllHeaders(FIdMessageCollection);
  finally
    FIDIMAP4.OnWork := Nil;
    FIDIMAP4.OnWorkBegin := Nil;
  end;

end;

function IMAP4Class.MoveMsg(AIdMessage: Integer; ABoxName: String): Boolean;
begin
  Result := False;
  if FIDIMAP4.CopyMsg(AIdMessage,ABoxName) then
  begin
    Result := FIDIMAP4.DeleteMsgs([AIdMessage])
  end;
end;

function IMAP4Class.SelectMailBox(ABoxName: String): Boolean;
begin
  Result := FIDIMAP4.SelectMailBox(ABoxName);
end;

procedure IMAP4Class.SetSSLMethod(const Value: TIdSSLVersion);
begin
  FSSLMethod := Value;
  if Assigned(FIDSSL) then
    FIDSSL.SSLOptions.Method := Value;
end;

procedure IMAP4Class.SetUseTLS(const Value: TIdUseTLS);
begin
  FUseTLS := Value;
  FIDIMAP4.UseTLS := Value;
end;

function IMAP4Class.ValidMoveMsg: Boolean;
begin
  Result := FIDIMAP4.ExpungeMailBox;
end;

end.
