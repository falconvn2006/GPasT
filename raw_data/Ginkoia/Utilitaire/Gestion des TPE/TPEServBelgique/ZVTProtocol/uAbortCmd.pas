unit uAbortCmd;

interface

uses
  SysUtils,
  uCommand;

type
  TPTAbortCmd = class(TPTCommand)
  private
    FStatus: string;
  public
    constructor Create(ABytes: TBytes); override;

    function asString: string; override;
    function getResponseCmd: TCommand; override;

    function CmdResultCode: string; override;
    function CmdResultDescr: string; override;
  end;

  TECRAbortCmd = class(TECRCommand)
  protected
    function getLength: string; override;
    function getDataBlock: string; override;

  public
    constructor Create; overload;
  end;

implementation

uses
  uZVTProtocolUtils, uAcknowledgementCmd, uZVTProtocolManager;

{ TPTAbortCmd }

function TPTAbortCmd.asString: string;
begin
  Result := 'Abort : ' + ZVTErrorMessage(FStatus);
end;

function TPTAbortCmd.CmdResultCode: string;
begin
  Result := FStatus;
end;

function TPTAbortCmd.CmdResultDescr: string;
begin
  Result := ZVTErrorMessage(FStatus);
end;

constructor TPTAbortCmd.Create(ABytes: TBytes);
begin
  inherited Create(ABytes);

  FCmdType := ptcmdtError;
  FStatus := IntToHex(ABytes[5], 2);
  FSendResponse := True;
end;

function TPTAbortCmd.getResponseCmd: TCommand;
begin
  Result := TECRAcknowledgementCmd.Create;
end;

{ TECRAbortCmd }

constructor TECRAbortCmd.Create;
begin
  inherited Create(Chr(06), AnsiChar(StrToInt('$B0')));

  //TODO vérifier que la commande ECR Abort est bien "Master" (donne les droits master au PT)
  FCmdType := ecrcmdtMaster;
end;

function TECRAbortCmd.getDataBlock: string;
begin
  Result := '';
end;

function TECRAbortCmd.getLength: string;
begin
  Result := Chr(00);
end;

initialization

  TDefaultZVTProtocolManager.RegisterKnownPTCommand('06', '1E', TPTAbortCmd);

end.
