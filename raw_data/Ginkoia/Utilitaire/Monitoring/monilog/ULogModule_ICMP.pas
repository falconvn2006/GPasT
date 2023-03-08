unit ULogModule_ICMP;

interface

uses
   Classes, IdIcmpClient, Math, UlogModule, ULog, Sysutils;

type
   TDatas = record
      Min:integer;
      Max:integer;
      Avg:integer;
   end;
   TLogModule_ICMP = class(TLogModule)
   private
     FDatas : TDatas;
     FIcmpClient: TIdIcmpClient;
     FRunning: boolean;
     FOnAfterTest: TNotifyEvent;
     FServname  : string;
     FPingHost  : string;   // Hote à pinguer
   protected
    procedure DoTest; override;
   public
     constructor Create(AServname:string; AFreq:integer; ANotifyEvent: TNotifyEvent);
     destructor Destroy; override;
     property Running  : boolean read FRunning  write FRunning;
     property PingHost : string  read FPingHost write FPingHost;
     property Datas: TDatas read FDatas write FDatas;
   end;

implementation

uses
   SyncObjs,GestionLog;

{ TLogModule_ICMP }

constructor TLogModule_ICMP.Create(AServname:string; AFreq:integer; ANotifyEvent: TNotifyEvent);
begin
   inherited;
   // On Ping toujours depuis un 'Localhost'
   FModule   := 'ICMP';
   FServname := AServname;
   FIcmpClient := TIdIcmpClient.Create(nil);
   FIcmpClient.PacketSize:=24;
   FIcmpClient.ReceiveTimeout := 1000;
   FRunning := false;
   FDatas.Min:=FIcmpClient.ReceiveTimeout;
   FDatas.Max:=0;
   FDatas.Avg:=FIcmpClient.ReceiveTimeout;
end;

destructor TLogModule_ICMP.Destroy;
begin
   FIcmpClient.DisposeOf;
   inherited;
end;

procedure TLogModule_ICMP.DoTest;
var doesPing: boolean;
    nbPing: integer;
    somme:cardinal;
    ABuffer: String;
begin
   try
    try
       FIcmpClient.Host := FPingHost;
       nbPing := 0;
       FStatus := Format('Running %d/5',[nbPing]);
       doesPing := true;
       FRunning := true;
       somme:=0;
       ABuffer := FPingHost + StringOfChar(' ', 255);
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
                Log.Log(FServname, Module,'',FPingHost,'min',datas.Min,logInfo,true);
                Log.Log(FServname, Module,'',FPingHost,'max',datas.max,logInfo,true);
                Log.Log(FServname, Module,'',FPingHost,'avg',datas.avg,logInfo,true);
                Log.Log(FServname, Module,'',FPingHost,'status','OK',logInfo,true);
                exit;
           end;
    except On E:Exception do
    begin
      Log_Write(E.Message, el_Erreur);
      Log.Log(FServname,Module,'',FPingHost,'status',E.Message,logError,true);
    end;
    end;
   finally
     FStatus := 'Not Running';
     FRunning := false;
   end;
end;

end.
