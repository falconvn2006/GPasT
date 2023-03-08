unit uZVTProtocolManager;

interface

uses
  SysUtils, VaComm,
  uCommand, Vcl.ExtCtrls;

Type
  TZVTLogEvent = procedure(Sender: TObject; ALog: string) of object;

  TUnknownCmdException = class(Exception)
  private
  public
    constructor Create(AcmdClass, AcmdInstr: string); overload;
  end;

  TECRNotMasterException = class(Exception)
  private
  public
  end;

  KnownPTCommand = Record
    cmdClass: string;
    cmdInstr: string;
    cmdObject: TPTCommandClass;
  End;

  { Les statuts possibles du ZVTManager
    - zvtmsECRMaster : le ECR est Master (on peut envoyer des ECR commandes master)
    - zvtmsPTMaster : le PT est Master
    - zvtmsWaitPTDatas : En attente de donnée pour compléter le block structure en cours d'envoi par le PT
    - zvtmsWaitForACK : Toutes commandes ECR envoyés demandes un ACK du PT
    - zvtmsTimeOut : le PT n'a pas répondu dans les temps (3 secondes)
  }
  TZVTManagerStatus = (zvtmsECRMaster, zvtmsPTMaster, zvtmsWaitPTDatas,
    zvtmsWaitForACK, zvtmsTimeOut);

  { Les types de réponses possibles du PT
    - zvtptrSuccess : Succes
    - zvtptrError : Erreur
    - zvtptrTimeOut : le PT n'a pas répondu dans les temps (3 secondes)
  }
  TZVTPTResponse = (zvtptrSuccess, zvtptrError, zvtptrTimeOut);


  TZVTManagerStatusChangeEvent = procedure(Sender: TObject; ALastStatus,
    ANewStatus: TZVTManagerStatus) of object;
  TZVTManagerPTSendResponseEvent = procedure(Sender: TObject; AResponse: TZVTPTResponse;
    AResponseCode: string; AResponseDescription: string; AResultCmd: TPTCommand) of object;

  TDefaultZVTProtocolManager = class
  private
    FStatus: TZVTManagerStatus;
    FOnStatusChange: TZVTManagerStatusChangeEvent;
    FonPTSendReponse: TZVTManagerPTSendResponseEvent;

    class var FKnownPTCommands: array of KnownPTCommand;
    class function GetKnownPTCommand(AcmdClass, AcmdInstr: string): TPTCommandClass;
  protected
    FGlobalTimeOutTimer: TTimer;
    FTimeOutTimer: TTimer;

    procedure TimeOutTimerTimer(Sender: TObject);
    procedure ChangeStatus(ANewStatus: TZVTManagerStatus);
    procedure SendPTResponse(AResponseCmd: TPTCommand; AResultCmd: TPTCommand);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    class function RegisterKnownPTCommand(AClass, AInstr: string; AObject: TPTCommandClass): boolean;

    property Status: TZVTManagerStatus read FStatus;
    property OnStatusChange: TZVTManagerStatusChangeEvent read FOnStatusChange write FOnStatusChange;

    property onPTSendReponse: TZVTManagerPTSendResponseEvent read FonPTSendReponse
      write FonPTSendReponse;
  end;

  TZVTProtocolManager = class(TDefaultZVTProtocolManager)
  private
    FBeforeForceStatus: TZVTManagerStatus;

    FSentCmd: TECRCommand;
    FReceivedCmd: TPTCommand;
    FResultCmd: TPTCommand;

    FOnReceivedCmd: TZVTReceivedCmdEvent;
    FOnSendCmd: TZVTSendCmdEvent;
    FOnSendIntermediateCmd: TZVTSendCmdEvent;
    FOnReceivedIntermediateCmd: TZVTReceivedCmdEvent;

    function getPTCommand(AcmdClass, AcmdInstr: string; ABytes: TBytes): TPTCommand;
    function InternalSendCommand(ACmd: TECRCommand; AForce: boolean): boolean;

  protected
    procedure ManageReceivedCommand(ACmd: TPTCommand);

    procedure WriteText(ACmd: TECRCommand); virtual; abstract;
    procedure WriteChar(AChar: AnsiChar); virtual; abstract;

    // Lecture des informations envoyées par le PT
    procedure parsePTDatas(ABytes: TBytes);
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Registration;
    procedure Authorization(AAmount: Double);

    property onSendCmd: TZVTSendCmdEvent read FOnSendCmd write FOnSendCmd;
    property onSendIntermediateCmd: TZVTSendCmdEvent read FOnSendIntermediateCmd
      write FOnSendIntermediateCmd;
    property onReceivedCmd: TZVTReceivedCmdEvent read FOnReceivedCmd
      write FOnReceivedCmd;
    property onReceivedIntermediateCmd: TZVTReceivedCmdEvent
      read FOnReceivedIntermediateCmd write FOnReceivedIntermediateCmd;
  end;

  TVaCommZVTProtocolManager = class(TZVTProtocolManager)
  private
    FVaComm: TVaComm;
    FOnLogRxCharEvent: TZVTLogEvent;
    FOnLogVaCommWriteEvent: TZVTLogEvent;

    procedure InitVaComm;

    procedure VaCommRxChar(Sender: TObject; Count: Integer);

    function getVaCommBaudrate: TVaBaudrate;
    function getVaCommDatabits: TVaDatabits;
    function getVaCommParity: TVaParity;
    function getVaCommPortNum: integer;
    function getVaCommStopbits: TVaStopbits;

    procedure setVaCommBaudrate(const Value: TVaBaudrate);
    procedure setVaCommDatabits(const Value: TVaDatabits);
    procedure setVaCommParity(const Value: TVaParity);
    procedure setVaCommPortNum(const Value: integer);
    procedure setVaCommStopbits(const Value: TVaStopbits);

    procedure LogRxChar(ABytes: TBytes);
  protected
    procedure WriteText(ACmd: TECRCommand); override;
    procedure WriteChar(AChar: AnsiChar); override;

  public
    constructor Create; override;
    destructor Destroy; override;

    procedure OpenPort;
    procedure ClosePort;

    function PortActive: boolean;

    property VaCommBaudrate: TVaBaudrate read getVaCommBaudrate write setVaCommBaudrate;
    property VaCommDatabits: TVaDatabits read getVaCommDatabits write setVaCommDatabits;
    property VaCommParity: TVaParity read getVaCommParity write setVaCommParity;
    property VaCommStopbits: TVaStopbits read getVaCommStopbits write setVaCommStopbits;
    property VaCommPortNum: integer read getVaCommPortNum write setVaCommPortNum;

    property onLogRxCharEvent: TZVTLogEvent read FOnLogRxCharEvent write FOnLogRxCharEvent;
    property OnLogVaCommWriteEvent: TZVTLogEvent read FOnLogVaCommWriteEvent write FOnLogVaCommWriteEvent;
  end;

implementation

uses
  uAuthorizationCmd, uRegistrationCmd, uSpecialCmd;

const
  ACK: Byte = Ord(#6);

{ TZVTProtocolManager }

procedure TZVTProtocolManager.Authorization(AAmount: Double);
begin
  InternalSendCommand(TAuthorizationCmd.Create( Round(AAmount * 100) ), False);
end;

constructor TZVTProtocolManager.Create;
begin
  inherited;

  FSentCmd := Nil;
  FReceivedCmd := Nil;
  FResultCmd := Nil;
  FStatus := zvtmsECRMaster;
end;

destructor TZVTProtocolManager.Destroy;
begin
  FreeAndNil(FSentCmd);
  FreeAndNil(FResultCmd);
  FreeAndNil(FReceivedCmd);

  inherited;
end;

function TZVTProtocolManager.getPTCommand(AcmdClass, AcmdInstr: string; ABytes: TBytes): TPTCommand;
var
  cmdclass: TPTCommandClass;
begin
  cmdClass := GetKnownPTCommand( AcmdClass, AcmdInstr );
  if Assigned(cmdClass) then
    Result := cmdClass.Create(ABytes)
  else
    raise TUnknownCmdException.Create(AcmdClass, AcmdInstr);
end;

function TZVTProtocolManager.InternalSendCommand(ACmd: TECRCommand;
  AForce: boolean): boolean;
begin
  // Force est utilisé quand on envoi une commande "intermediaire" qui ne nécessite pas
  // le statut ECRMaster
  if (Status = zvtmsECRMaster) or AForce then
  begin
    FGlobalTimeOutTimer.Enabled := False;
    FGlobalTimeOutTimer.Enabled := True;

    FreeAndNil(FSentCmd);
    FSentCmd := ACmd;
    ChangeStatus(zvtmsWaitForACK);

    // Demande l'envoi de la commande au PT
    WriteText(FSentCmd);

    if AForce then
    begin
      if Assigned (FOnSendIntermediateCmd) then
        FOnSendIntermediateCmd(Self, FSentCmd);
    end
    else
    begin
      if Assigned (FOnSendCmd) then
        FOnSendCmd(Self, FSentCmd);
    end;
  end
  else
    raise TECRNotMasterException.Create('Le ECR n''a pas les droits Master');
end;

procedure TZVTProtocolManager.parsePTDatas(ABytes: TBytes);
begin
  FGlobalTimeOutTimer.Enabled := False;
  FGlobalTimeOutTimer.Enabled := True;

  // Suivant le statut on gère les données envoyées par le PT différemment
  case Status of
    zvtmsECRMaster: FGlobalTimeOutTimer.Enabled := False;
    zvtmsPTMaster:
    begin
      FreeAndNil(FReceivedCmd);
      FReceivedCmd := getPTCommand(IntToHex(ABytes[2], 2), IntToHex(ABytes[3], 2), ABytes);

      if FReceivedCmd.WaitForInstruction then
      begin
        ChangeStatus(zvtmsWaitPTDatas);
      end
      else
      begin
        ManageReceivedCommand(FReceivedCmd);
      end;
    end;
    zvtmsWaitPTDatas:
    begin
      if not Assigned(FReceivedCmd) then
      begin
        raise Exception.Create('Status WaitPTDatas avec le FReceivedCmd à Nil');
      end;

      FReceivedCmd.AddBytes(ABytes);

      if not FReceivedCmd.WaitForInstruction then
      begin
        case FSentCmd.CmdType of
          ecrcmdtIntermediate: ChangeStatus(FBeforeForceStatus);
          ecrcmdtMaster: ChangeStatus(zvtmsPTMaster);
        end;
        ManageReceivedCommand(FReceivedCmd);
      end;
    end;
    zvtmsWaitForACK:
    begin
      if ABytes[0] = ACK then
      begin
        case FSentCmd.CmdType of
          ecrcmdtIntermediate: ChangeStatus(FBeforeForceStatus);
          ecrcmdtMaster: ChangeStatus(zvtmsPTMaster);
        end;
        if Assigned(FOnReceivedIntermediateCmd) then
        begin
          FOnReceivedIntermediateCmd(Self, TPTCommand.Create(ABytes));
        end;
      end
      else
      begin
        raise Exception.Create(Format('PT send NAK for %s', [FSentCmd.asString]));
      end;
    end;
  end;
end;

procedure TZVTProtocolManager.Registration;
begin
  InternalSendCommand(TRegistrationCmd.Create, False);
  FreeAndNil(FResultCmd);
end;

procedure TZVTProtocolManager.ManageReceivedCommand(ACmd: TPTCommand);
begin
  // On notifie le PT qu'on à bien reçu sa commande ( -> ACK )
  WriteChar(AnsiChar(ACK));

  case ACmd.CmdType of
    ptcmdtIntermediate:
    begin
      if Assigned(FOnReceivedIntermediateCmd) then
        FOnReceivedIntermediateCmd(self, Acmd);
    end;
    ptcmdtResult:
    begin
      if Assigned(FOnReceivedCmd) then
        FOnReceivedCmd(self, Acmd);

      FResultCmd := Acmd.Clone;
    end;
    ptcmdtSucces, ptcmdtError:
    begin
      if Assigned(FOnReceivedCmd) then
        FOnReceivedCmd(self, Acmd);

      ChangeStatus(zvtmsECRMaster);
      SendPTResponse(ACmd, FResultCmd);
      FreeAndNil(FResultCmd);
    end;
  end;

  // Si la commande reçu (quelque soit son type) demande une réponse de l'ECR
  // on l'envoi en mode forcé pour que l'eventuel statut ECRMaster ne la bloque pas
  if ACmd.SendResponse then
  begin
    FBeforeForceStatus := Status;
    InternalSendCommand((ACmd.getResponseCmd as TECRCommand), True);
  end;

end;

{ TDefaultZVTProtocolManager }

procedure TDefaultZVTProtocolManager.ChangeStatus(
  ANewStatus: TZVTManagerStatus);
var
  laststatus: TZVTManagerStatus;
begin
  if (FStatus = zvtmsECRMaster) and (ANewStatus = zvtmsWaitForACK) then
  begin
    FTimeOutTimer.Enabled := True;
  end;

  if (FStatus = zvtmsWaitForACK) and ((ANewStatus = zvtmsPTMaster) or (ANewStatus = zvtmsECRMaster)) then
  begin
    FTimeOutTimer.Enabled := False;
  end;

  if ANewStatus <> FStatus then
  begin
    laststatus := FStatus;
    FStatus := ANewStatus;

    if Assigned(FOnStatusChange) then
      FOnStatusChange(Self, laststatus, FStatus);

    if ANewStatus = zvtmsTimeOut then
    begin
      SendPTResponse( TPTTimeOutCmd.Create, nil );
      ChangeStatus(zvtmsECRMaster);
    end;
  end;
end;

constructor TDefaultZVTProtocolManager.Create;
begin
  FGlobalTimeOutTimer := TTimer.Create(nil);
  FGlobalTimeOutTimer.Enabled := False;
  FGlobalTimeOutTimer.Interval := 25500;
  FGlobalTimeOutTimer.OnTimer := TimeOutTimerTimer;

  FTimeOutTimer := TTimer.Create(nil);
  FTimeOutTimer.Enabled := False;
  FTimeOutTimer.Interval := 3000;
  FTimeOutTimer.OnTimer := TimeOutTimerTimer;
end;

destructor TDefaultZVTProtocolManager.Destroy;
begin
  FTimeOutTimer.Enabled := False;
  FreeAndNil(FTimeOutTimer);

  inherited;
end;

class function TDefaultZVTProtocolManager.GetKnownPTCommand(AcmdClass,
  AcmdInstr: string): TPTCommandClass;
var
  i: integer;
begin
  Result := Nil;
  for i := 0 to Length(FKnownPTCommands) - 1 do
  begin
    if (FKnownPTCommands[i].cmdClass = AcmdClass) and
      ((FKnownPTCommands[i].cmdInstr = AcmdInstr) or (FKnownPTCommands[i].cmdInstr = 'xx')) then
    begin
      Result := FKnownPTCommands[i].cmdObject;
      Break;
    end;
  end;
end;

class function TDefaultZVTProtocolManager.RegisterKnownPTCommand(AClass, AInstr: string;
  AObject: TPTCommandClass): boolean;
var
  index: integer;
  kcmd: KnownPTCommand;
begin
  if not Assigned(GetKnownPTCommand(AClass, AInstr)) then
  begin
    kcmd.cmdClass := AClass;
    kcmd.cmdInstr := AInstr;
    kcmd.cmdObject := AObject;

    index := Length(FKnownPTCommands);
    SetLength(FKnownPTCommands, index + 1);
    FKnownPTCommands[index] := kcmd;
  end;
end;

procedure TDefaultZVTProtocolManager.SendPTResponse(AResponseCmd,
  AResultCmd: TPTCommand);
var
  response: TZVTPTResponse;
  responseCode: string;
  responseDescription: string;
begin
  case AResponseCmd.CmdType of
    ptcmdtIntermediate: ;
    ptcmdtResult: ;
    ptcmdtSucces:
    begin
      response := zvtptrSuccess;
      if Assigned(AResultCmd) then
      begin
        responseCode := AResultCmd.CmdResultCode;
        responseDescription := AResultCmd.CmdResultDescr;
      end
      else
      begin
        responseCode := AResponseCmd.CmdResultCode;
        responseDescription := AResponseCmd.CmdResultDescr;
      end;
    end;
    ptcmdtError:
    begin
      response := zvtptrError;
      if Assigned(AResultCmd) then
      begin
        responseCode := AResultCmd.CmdResultCode;
        responseDescription := AResultCmd.CmdResultDescr;
      end
      else
      begin
        responseCode := AResponseCmd.CmdResultCode;
        responseDescription := AResponseCmd.CmdResultDescr;
      end;
    end;
    ptcmdtTimeOut:
    begin
      response := zvtptrTimeOut;
      responseCode := AResponseCmd.CmdResultCode;
      responseDescription := AResponseCmd.CmdResultDescr;
    end;
  end;

  if Assigned(FonPTSendReponse) then
    FonPTSendReponse(Self, response, responsecode, responseDescription, AResultCmd);
end;

procedure TDefaultZVTProtocolManager.TimeOutTimerTimer(Sender: TObject);
begin
  ChangeStatus(zvtmsTimeOut);
  FTimeOutTimer.Enabled := False;
  FGlobalTimeOutTimer.Enabled := False;
end;

{ TVaCommZVTProtocolManager }

procedure TVaCommZVTProtocolManager.ClosePort;
begin
  FVaComm.Close;
end;

constructor TVaCommZVTProtocolManager.Create;
begin
  inherited;

  InitVaComm;
end;

destructor TVaCommZVTProtocolManager.Destroy;
begin
  FVaComm.Close;
  FreeAndNil(FVaComm);

  inherited;
end;

function TVaCommZVTProtocolManager.getVaCommBaudrate: TVaBaudrate;
begin
  Result := FVaComm.Baudrate;
end;

function TVaCommZVTProtocolManager.getVaCommDatabits: TVaDatabits;
begin
  Result := FVaComm.Databits;
end;

function TVaCommZVTProtocolManager.getVaCommParity: TVaParity;
begin
  Result := FVaComm.Parity;
end;

function TVaCommZVTProtocolManager.getVaCommPortNum: integer;
begin
  Result := FVaComm.PortNum;
end;

function TVaCommZVTProtocolManager.getVaCommStopbits: TVaStopbits;
begin
  Result := FVaComm.Stopbits;
end;

procedure TVaCommZVTProtocolManager.InitVaComm;
begin
  FVaComm := TVaComm.Create(nil);
  FVAComm.AutoOpen := False;
  FVaComm.Baudrate := br9600;
  FVaComm.Databits := db8;
  FVaComm.Parity := paNone;
  FVaComm.Stopbits := sb2;
  FVaComm.PortNum := 1;

  FVaComm.OnRxChar := VaCommRxChar;
end;

procedure TVaCommZVTProtocolManager.LogRxChar(ABytes: TBytes);
var
  i: integer;
  log: string;
begin
  if Assigned(FOnLogRxCharEvent) then
  begin
    log := IntToHex(Ord(ABytes[0]), 2);
    for i := 1 to length(ABytes) - 1 do
    begin
      log := Format('%s %s', [log, IntToHex(Ord(ABytes[i]), 2)]);
    end;

    FOnLogRxCharEvent(self, log);
  end;
end;

procedure TVaCommZVTProtocolManager.OpenPort;
begin
  FVaComm.Open;

  FStatus := zvtmsECRMaster;
end;

function TVaCommZVTProtocolManager.PortActive: boolean;
begin
  Result := FVaComm.Active;
end;

procedure TVaCommZVTProtocolManager.setVaCommBaudrate(const Value: TVaBaudrate);
begin
  FVaComm.Baudrate := Value;
end;

procedure TVaCommZVTProtocolManager.setVaCommDatabits(const Value: TVaDatabits);
begin
  FVaComm.Databits := Value;
end;

procedure TVaCommZVTProtocolManager.setVaCommParity(const Value: TVaParity);
begin
  FVaComm.Parity := Value;
end;

procedure TVaCommZVTProtocolManager.setVaCommPortNum(const Value: integer);
begin
  FVaComm.PortNum := Value;
end;

procedure TVaCommZVTProtocolManager.setVaCommStopbits(const Value: TVaStopbits);
begin
  FVaComm.Stopbits := Value;
end;

procedure TVaCommZVTProtocolManager.VaCommRxChar(Sender: TObject;
  Count: Integer);
var
  i: integer;
  BufferRx : array[0..1024] of byte;
  cmdBuffer: TBytes;
begin

  FVaComm.ReadBuf(BufferRx, Count);
  SetLength(cmdBuffer, count);

  for i := 0 to Count - 1 do
  begin
    cmdBuffer[i] := BufferRx[i];
  end;

  LogRxChar(cmdBuffer);
  parsePTDatas(cmdBuffer);
end;

procedure TVaCommZVTProtocolManager.WriteChar(AChar: AnsiChar);
begin
  if not PortActive then
    raise Exception.Create('Le port n''est pas ouvert');

  if Assigned(FOnLogVaCommWriteEvent) then
  begin
    FOnLogVaCommWriteEvent(self, IntToHex(Ord(AChar), 2));
  end;

  FVaComm.WriteChar(AChar);
end;

procedure TVaCommZVTProtocolManager.WriteText(ACmd: TECRCommand);
var
  i: integer;
  scmd, log: string;
begin
  if not PortActive then
    raise Exception.Create('Le port n''est pas ouvert');

  if Assigned(FOnLogVaCommWriteEvent) then
  begin
    scmd := Acmd.asPTString;
    log := '';
    for i := 1 to Length(scmd) do
    begin
      log := Format('%s %.2d', [log, Ord(scmd[i])]);
    end;
    FOnLogVaCommWriteEvent(self, log);
  end;

  FVaComm.WriteText(ACmd.asPTString);
end;

{ TUnknownCmdException }

constructor TUnknownCmdException.Create(AcmdClass, AcmdInstr: string);
begin
  inherited Create(Format('Command %s %s inconnue', [AcmdClass, AcmdInstr]));
end;

end.
