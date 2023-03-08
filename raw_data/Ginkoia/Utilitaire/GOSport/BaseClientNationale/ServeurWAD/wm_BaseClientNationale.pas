unit wm_BaseClientNationale;

interface

uses
  SysUtils, Classes, HTTPApp, InvokeRegistry, WSDLIntf, TypInfo, WebServExp,
  WSDLBind, XMLSchema, WSDLPub, SOAPPasInv, SOAPHTTPPasInv, SOAPHTTPDisp,
  WebBrokerSOAP, WebReq, ActiveX;

type
  TwmBaseClientNationale = class(TWebModule)
    HTTPSoapDispatcher1: THTTPSoapDispatcher;
    HTTPSoapPascalInvoker1: THTTPSoapPascalInvoker;
    WSDLHTMLPublish1: TWSDLHTMLPublish;
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
    procedure wmBaseClientNationaleDefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
  public
    procedure Initialize;
  end;

var
  WebModuleClass: TComponentClass = TwmBaseClientNationale;
  wmBaseClientNationale: TwmBaseClientNationale;

implementation

uses uVar, dmdGinkoia, uWSConfig, uCtrlBaseClientNationale,
  u_i_BaseClientNationaleImpl, uLog;

{$R *.dfm}

procedure TwmBaseClientNationale.Initialize;
var
  vSL: TStringList;
begin
  CoInitialize(nil);
  vSL:= TStringList.Create;
  try
    try
      {$IFDEF WAD}
      GWSConfig.ServiceName:= 'SrvBaseClientNationale_WAD';
      {$ELSE}
      GWSConfig.ServiceName:= 'SrvBaseClientNationale';
      {$ENDIF}

      GWSConfig.Load;

      if GWSConfig.FileNameIni = '' then
        Raise Exception.Create('Le chemin du fichier de config est introuvable.');
      vSL.Append('FileNameIni : ' + GWSConfig.FileNameIni);

      if GWSConfig.FileNameDB = '' then
        Raise Exception.Create('Le data source de la connexion est introuvable.');
      vSL.Append('FileNameDB : ' + GWSConfig.FileNameDB);

      vSL.Append('LogOnStart : ' + IntToStr(Integer(GWSConfig.LogOnStart)));
      vSL.Append('LogException : ' + IntToStr(Integer(GWSConfig.LogException)));
      vSL.Append('Traceur : ' + IntToStr(Integer(GWSConfig.Traceur)));

      vSL.Append('Before Create : TdmGinkoia');
      dmGinkoia:= TdmGinkoia.Create(Self);
      vSL.Append('TdmGinkoia Create : Ok');

      vSL.Append('Before Connexion');
      dmGinkoia.ADOConnection.ConnectionString:= Format(cConnectionString, [GWSConfig.LoginDB,GWSConfig.PasswordDB,GWSConfig.InitialDb, GWSConfig.FileNameDB]);
      dmGinkoia.ADOConnection.DefaultDatabase:= GWSConfig.InitialDb;  //--> en attente...
      vSL.Append('Connexion : ' + dmGinkoia.ADOConnection.ConnectionString);
      dmGinkoia.ADOConnection.Open;
      vSL.Append('Connexion : Ok');

      vSL.Append('Before Create : Controleur');
      GBaseClientNationaleCtrl:= TBaseClientNationaleCtrl.Create;
      vSL.Append('Controleur Create : Ok');

      vSL.Append(cWSStarted);
    except
      on E: Exception do
        vSL.Append(E.Message);
    end;
  finally
    if GWSConfig.ServiceFileName <> '' then
      GWSConfig.SaveFile(GWSConfig.ServiceFileName + GWSConfig.GetTime + '.log', vSL, GWSConfig.LogOnStart)
    else
      GWSConfig.SaveFile('C:\' + GWSConfig.ServiceName + GWSConfig.GetTime + '.Except', vSL, True);
    FreeAndNil(vSL);
  end;
end;

procedure TwmBaseClientNationale.WebModuleCreate(Sender: TObject);
begin
  Log.App := 'WS Fidélité GOS';
  Log.Deboublonage := false ;
  Log.readIni ;
  Log.FileLogFormat := [elDate, elMdl, elKey, elValue, elLevel, elData] ;
  Log.Open;
  Log.saveIni;

  GWSConfig:= TWSConfig.Create(Self);
  Initialize;
end;

procedure TwmBaseClientNationale.WebModuleDestroy(Sender: TObject);
begin
  CoUnInitialize;
  FreeAndNil(GBaseClientNationaleCtrl);
  if Assigned(dmGinkoia) then
  begin
    if dmGinkoia.ADOConnection.InTransaction then
      dmGinkoia.ADOConnection.RollbackTrans;
    FreeAndNil(dmGinkoia);
  end;
end;

procedure TwmBaseClientNationale.wmBaseClientNationaleDefaultHandlerAction(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
begin
  WSDLHTMLPublish1.ServiceInfo(Sender, Request, Response, Handled);
end;

initialization
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := TwmBaseClientNationale;

end.
