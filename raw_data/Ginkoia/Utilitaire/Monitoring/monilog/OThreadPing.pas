unit ULogModule_ICMP;

interface

uses
   Classes, IdIcmpClient, Math, UlogModule;

type
   TDatas = record
      Min:integer;
      Max:integer;
      Avg:integer;
   end;
   TTLogModule_ICMP = class(TLogModule)
   private
     FDatas : TDatas;
     FIcmpClient: TIdIcmpClient;
     FRunning: boolean;
     FOnAfterTest: TNotifyEvent;
     FHost: string;
   protected
    procedure DoTest; override;
   public
     constructor Create(Host: string; ANotifyEvent: TNotifyEvent);
     destructor Destroy; override;
     property Running: boolean read FRunning write FRunning;
     property Datas: TDatas read FDatas write FDatas;
   end;

implementation

uses
   SyncObjs;

{ TPingThread }

constructor TTLogModule_ICMP.Create(Host: string; ANotifyEvent: TNotifyEvent);
begin
   inherited;
   FHost := Host;
   FModule := 'ICMP';
   FIcmpClient := TIdIcmpClient.Create(nil);
   FIcmpClient.Host := Host;
   FIcmpClient.PacketSize:=24;
   FIcmpClient.ReceiveTimeout := 1000;
   FRunning := false;
   FDatas.Min:=FIcmpClient.ReceiveTimeout;
   FDatas.Max:=0;
   FDatas.Avg:=FIcmpClient.ReceiveTimeout;
end;

destructor TTLogModule_ICMP.Destroy;
begin
   FIcmpClient.DisposeOf;
   inherited;
end;

procedure TTLogModule_ICMP.DoTest;
var doesPing: boolean;
    nbPing: integer;
    somme:cardinal;
    ABuffer: String;
begin
   try
   FStatus := 'Running';
   doesPing := true;
   nbPing := 0;
   FRunning := true;
   somme:=0;
   ABuffer := FHost + StringOfChar(' ', 255);
   FIcmpClient.Ping(ABuffer);
   Inc(nbPing);
   FDatas.Min:=Min(FDatas.Min,FIcmpClient.ReplyStatus.MsRoundTripTime);
   FDatas.Max:=Max(FDatas.Max,FIcmpClient.ReplyStatus.MsRoundTripTime);
   somme:=somme + FIcmpClient.ReplyStatus.MsRoundTripTime;
   if { (FIcmpClient.Host = FIcmpClient.ReplyStatus.FromIpAddress) and }
      (FIcmpClient.ReplyStatus.BytesReceived > 0) then
        doesPing := false;
    if (not doesPing) or (nbPing > 5) then
       begin
            if (NbPing<>0) then
              FDatas.Avg:=Round(somme/NbPing);
            exit;
       end;
   finally
     FStatus := 'Running';
     FRunning := false;
   end;
end;

end.
