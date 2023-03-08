unit Main_Wm;

interface

uses
  SysUtils,
  Classes,
  // uses perso
  UTools,
  // Fin uses perso
  HTTPApp,
  InvokeRegistry,
  WSDLIntf,
  TypInfo,
  WebServExp,
  WSDLBind,
  XMLSchema,
  WSDLPub,
  SOAPPasInv,
  SOAPHTTPPasInv,
  SOAPHTTPDisp,
  WebBrokerSOAP,
  IB_Components;

type
  TwmMain = class(TWebModule)
    HTTPSoapDispatcher1: THTTPSoapDispatcher;
    HTTPSoapPascalInvoker1: THTTPSoapPascalInvoker;
    WSDLHTMLPublish1: TWSDLHTMLPublish;

    procedure WebModuleCreate(Sender: TObject);
    procedure wmMainDefaultHandlerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wmMainPingAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);

  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  wmMain: TComponentClass = TwmMain;

implementation

{$R *.dfm}

procedure TwmMain.WebModuleCreate(Sender: TObject);
begin
  initLogFileName(GetNiveauLog, GetIniName, 'yyyymmdd.hhnnss.zzz');

  LogAction('Init OK', 3);

  PurgeOldLogs(GetIniName, 30);
end;

procedure TwmMain.wmMainDefaultHandlerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  LogAction('wmMainDefaultHandlerAction', 3);
  WSDLHTMLPublish1.ServiceInfo(Sender, Request, Response, Handled);
end;

procedure TwmMain.wmMainPingAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := 'PONG'; //GetDatabaseFile;
end;

end.

