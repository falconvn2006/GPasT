unit uTPEGinkoiaProtocolManager;

interface

uses
  vcl.Dialogs, SysUtils, System.Win.ScktComp;

type
  TTPEGinkoiaProtocolReceivedCmdEvent = procedure(Sender: TObject;
    ACmd: string; AValue: string) of object;
  TTPEGinkoiaProtocolSendCmdEvent = procedure(Sender: TObject;
    ASocket: TCustomWinSocket; AText: string) of object;

  TTPEGinkoiaProtocolManager = class
  private
    FCurrentSocket: TCustomWinSocket;

    FOnCHQPayment: TTPEGinkoiaProtocolReceivedCmdEvent;
    FOnCheckConnection: TTPEGinkoiaProtocolReceivedCmdEvent;
    FOnCancel: TTPEGinkoiaProtocolReceivedCmdEvent;
    FOnCBPayment: TTPEGinkoiaProtocolReceivedCmdEvent;
    FonSendCmdEvent: TTPEGinkoiaProtocolSendCmdEvent;

    function getUsedSocket(AForceSocket: TCustomWinSocket): TCustomWinSocket;

  public
    constructor Create;

    procedure ParseTPEGinkoiaCommand(ASocket: TCustomWinSocket; ACommand: string);

    procedure SendBusy(AForceSocket: TCustomWinSocket = nil);
    procedure SendTimeOut(AForceSocket: TCustomWinSocket = nil);
    procedure SendNAK(AForceSocket: TCustomWinSocket = nil);
    procedure SendCheckConnectionFailed(AForceSocket: TCustomWinSocket = nil);
    procedure SendCheckConnectionSucced(AForceSocket: TCustomWinSocket = nil);
    procedure SendPaymentSucced(ACB: string; AForceSocket: TCustomWinSocket = nil);
    procedure SendPaymentFailed(AForceSocket: TCustomWinSocket = nil);
    procedure SendIntermediateStatus(ACode, ADescr: string;
      AForceSocket: TCustomWinSocket = nil);

    property OnCancel: TTPEGinkoiaProtocolReceivedCmdEvent read FOnCancel write FOnCancel;
    property OnCBPayment: TTPEGinkoiaProtocolReceivedCmdEvent read FOnCBPayment
      write FOnCBPayment;
    property OnCHQPayment: TTPEGinkoiaProtocolReceivedCmdEvent read FOnCHQPayment
      write FOnCHQPayment;
    property OnCheckConnection: TTPEGinkoiaProtocolReceivedCmdEvent read FOnCheckConnection
      write FOnCheckConnection;

    property onSendCmdEvent: TTPEGinkoiaProtocolSendCmdEvent read FonSendCmdEvent
      write FonSendCmdEvent;
  end;

implementation

{ TTPEGinkoiaProtocolManager }

procedure TTPEGinkoiaProtocolManager.SendCheckConnectionFailed(
  AForceSocket: TCustomWinSocket);
begin
  if Assigned(FonSendCmdEvent) then
    FonSendCmdEvent(Self, getUsedSocket(AForceSocket), 'ERR;PRESENCE');
end;

procedure TTPEGinkoiaProtocolManager.SendCheckConnectionSucced(
  AForceSocket: TCustomWinSocket);
begin
  if Assigned(FonSendCmdEvent) then
    FonSendCmdEvent(Self, getUsedSocket(AForceSocket), 'OK;PRESENCE');
end;

procedure TTPEGinkoiaProtocolManager.SendIntermediateStatus(ACode,
  ADescr: string; AForceSocket: TCustomWinSocket);
begin
  if Assigned(FonSendCmdEvent) and (ACode <> '') then
    FonSendCmdEvent(Self, getUsedSocket(AForceSocket),
      Format('ENCOURS;ZVT;%s;%s', [ACode, ADescr]));
end;

constructor TTPEGinkoiaProtocolManager.Create;
begin
  FCurrentSocket := nil;
end;

function TTPEGinkoiaProtocolManager.getUsedSocket(
  AForceSocket: TCustomWinSocket): TCustomWinSocket;
begin
  if Assigned(AForceSocket) then
    Result := AForceSocket
  else
    Result := FCurrentSocket;
end;

procedure TTPEGinkoiaProtocolManager.ParseTPEGinkoiaCommand(ASocket: TCustomWinSocket;
  ACommand: string);
var
  cmd: string;
  value: string;
begin
  FCurrentSocket := ASocket;
  if ACommand = '!CANCEL' then
  begin
    if Assigned(FOnCancel) then
      FOnCancel(self, ACommand, '');
  end
  else if ACommand = '!' then
  begin
    ShowMessage('//TODO manage "!" command (not used yet)');
  end
  else if ACommand = '>TPE' then
  begin
    if Assigned(FOnCheckConnection) then
      FOnCheckConnection(self, ACommand, '');
  end
  else if Pos(';', Acommand) <> 0 then
  begin
    cmd := Copy(ACommand, 0, Pos(';', ACommand) - 1);
    value := Copy(ACommand, Pos(';', ACommand) + 1 , length(ACommand));
    if cmd = '>MT' then
    begin
      if Assigned(FOnCBPayment) then
        FOnCBPayment(self, cmd, value);
    end
    else if cmd = '>CHQ' then
    begin
      if Assigned(FOnCHQPayment) then
        FOnCHQPayment(self, cmd, value);
    end
    else
      raise Exception.Create(Format('Unknown command "%s" (%s %s)', [ACommand, cmd, value]));
  end
  else
    raise Exception.Create(Format('Unknown command "%s"', [ACommand]));
end;

procedure TTPEGinkoiaProtocolManager.SendBusy(AForceSocket: TCustomWinSocket);
begin
  if Assigned(FonSendCmdEvent) then
    FonSendCmdEvent(Self, getUsedSocket(AForceSocket), 'OCCUPE');
end;

procedure TTPEGinkoiaProtocolManager.SendNAK(AForceSocket: TCustomWinSocket);
begin
  if Assigned(FonSendCmdEvent) then
    FonSendCmdEvent(Self, getUsedSocket(AForceSocket), 'NACK');
end;

procedure TTPEGinkoiaProtocolManager.SendPaymentFailed(
  AForceSocket: TCustomWinSocket);
begin
  if Assigned(FonSendCmdEvent) then
    FonSendCmdEvent(Self, getUsedSocket(AForceSocket), 'REFUS');
end;

procedure TTPEGinkoiaProtocolManager.SendPaymentSucced(ACB: string;
  AForceSocket: TCustomWinSocket);
begin
  if Assigned(FonSendCmdEvent) then
    FonSendCmdEvent(Self, getUsedSocket(AForceSocket), 'OK;B;' + ACB);
end;

procedure TTPEGinkoiaProtocolManager.SendTimeOut(
  AForceSocket: TCustomWinSocket);
begin
  if Assigned(FonSendCmdEvent) then
    FonSendCmdEvent(Self, getUsedSocket(AForceSocket), 'TIMEOUT');
end;

end.
