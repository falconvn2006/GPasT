unit uThreadLinkLame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Vcl.ExtCtrls, System.IniFiles, Winapi.WinSvc, System.RegularExpressionsCore, uLog, IdURI, Math,
  IdIcmpClient,IdTCPClient;

Type

  TThreadLinkLame = class(TThread)
  private
    { Déclarations privées }
    FPingReply : boolean;
    FPingTime  : double;
    FProtocol  : string;
    FURL       : string;
    FHOST      : string;
    FPort      : String;
    FTCPOpen   : Boolean;
    FErrorMsg  : string;
    procedure ParseRegistrationURL();
    procedure PingHost(const ATimes: integer);
    function PortTCPIsOpen() : boolean;
  public
    procedure Execute; override;
    constructor Create(CreateSuspended: boolean; const aURL:string; const AEvent: TNotifyEvent = nil); reintroduce;

  property PingReply : Boolean  Read FPingreply;
  property PingTime  : double   read FPingTime;
  property TCPOpen   : Boolean  read FTCPOpen;
  property ErrorMsg  : string   read FErrorMsg;

    { Déclarations publiques }
  end;

implementation

Uses uMainForm;

function TThreadLinkLame.PortTCPIsOpen() : boolean;
var vTCPClient: TIdTCPClient;
begin
 result := false;
 vTCPClient := TIdTCPClient.Create(nil);
 try
    try
      vTCPClient.Host := FHost;
      vTCPClient.Port := StrToIntDef(FPort,0);
      vTCPClient.ConnectTimeout := 3000;
      vTCPClient.Connect;
      result := true;
    Except
      result := false;
    end;
  finally
   vTCPClient.Free;
  end
end;

procedure TThreadLinkLame.PingHost(const ATimes: integer);
var R: array of Cardinal;
    i: integer;
begin
  FPingReply := True;
  FPingTime  := 0;
  if ATimes>0 then
    with TIdIcmpClient.Create(nil) do
    try
      Host := FHost;
      ReceiveTimeout := 999;
      SetLength(R, ATimes);
      for i := 0 to Pred(ATimes) do
      begin
        try
          Ping();
          R[i] := ReplyStatus.MsRoundTripTime;
        except
          FPingReply := False;
          Exit;
        end;
        if ReplyStatus.ReplyStatusType <> rsEcho then FPingReply := False;
      end;
      for i := Low(R) to High(R) do
      begin
        FPingTime := FPingTime + R[i];
      end;
      FPingTime := FPingTime / High(R);
    finally
      Free;
    end;
end;


constructor TThreadLinkLame.Create(CreateSuspended: boolean;  const aURL:string;  Const AEvent: TNotifyEvent = nil);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := true;
  FURL := aURL;
  FPingReply := false;
  FPingTime  := -1;
  FTCPOpen   := false;
  FErrorMsg   := '';
  OnTerminate := AEvent;
end;

procedure TThreadLinkLame.Execute;
var vPort:word;
begin
  try
    try
      ParseRegistrationURL();
      PingHost(3);
      FTCPOpen := PortTCPIsOpen();
    Except
      on E:Exception do
        begin
          FErrorMsg := E.Message;
        end;
    end;
  finally
    //
  end;
end;


procedure TThreadLinkLame.ParseRegistrationURL();
var URI: TIdURI;
begin
  if FURL <> '' then
  begin
    URI := TIdURI.Create(FURL);
    try
      FProtocol := URI.Protocol;
      FHost := URI.Host;
      FPort := URI.Port;
    finally
      URI.Free;
    end;
  end;
end;


end.
