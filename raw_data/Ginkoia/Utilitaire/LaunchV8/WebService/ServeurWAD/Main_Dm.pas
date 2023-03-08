unit Main_Dm;

interface

uses
  SysUtils,
  Classes,
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
  TDm_Main = class(TWebModule)
    HTTPSoapDispatcher1: THTTPSoapDispatcher;
    HTTPSoapPascalInvoker1: THTTPSoapPascalInvoker;
    WSDLHTMLPublish1: TWSDLHTMLPublish;
    procedure Dm_MainDefaultHandlerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure Dm_MainPingAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Dm_Main: TComponentClass = TDm_Main;

implementation

{$R *.dfm}

procedure TDm_Main.Dm_MainDefaultHandlerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  WSDLHTMLPublish1.ServiceInfo(Sender, Request, Response, Handled);
end;

procedure TDm_Main.Dm_MainPingAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content:= 'Pong';
end;

end.
