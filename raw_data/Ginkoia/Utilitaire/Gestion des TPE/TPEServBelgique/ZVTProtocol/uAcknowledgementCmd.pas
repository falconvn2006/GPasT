unit uAcknowledgementCmd;

interface

uses
  uCommand, SysUtils;

type
  TECRAcknowledgementCmd = class(TECRCommand)
  protected
    function getLength: string; override;
    function getDataBlock: string; override;

  public
    constructor Create; overload;
    destructor Destroy; override;

    function asString: string; override;
  end;

  TPTAcknowledgementCmd = class(TPTCommand)
  public
    function asString: string; override;
    function CmdResultCode: string; override;
    function CmdResultDescr: string; override;
  end;

  TPTNegativeAcknowledgementCmd = class(TPTCommand)
  private
    FErrorCode: string;
  public
    constructor Create(ABytes: TBytes); override;

    function asString: string; override;
    function CmdResultCode: string; override;
    function CmdResultDescr: string; override;
  end;

implementation

uses
  uZVTProtocolUtils, uZVTProtocolManager;

{ TECRAcknowledgementCmd }

function TECRAcknowledgementCmd.asString: string;
begin
  Result := 'Acknowledgement (80 00)';
end;

constructor TECRAcknowledgementCmd.Create;
begin
  inherited Create(AnsiChar(128), AnsiChar(00));
end;

destructor TECRAcknowledgementCmd.Destroy;
begin

  inherited;
end;

function TECRAcknowledgementCmd.getDataBlock: string;
begin
  Result := '';
end;

function TECRAcknowledgementCmd.getLength: string;
begin
  Result := Chr(00);
end;

{ TPTAcknowledgementCmd }

function TPTAcknowledgementCmd.asString: string;
begin
  Result := 'Acknowledgement (80 00)';
end;

function TPTAcknowledgementCmd.CmdResultCode: string;
begin
  Result := '00';
end;

function TPTAcknowledgementCmd.CmdResultDescr: string;
begin
  Result := '';
end;

{ TPTNegativeAcknowledgementCmd }

function TPTNegativeAcknowledgementCmd.asString: string;
begin
  Result := Format('Negative Acknowledgement (84 %s) : %s', [CmdResultCode,
    CmdResultDescr]);
end;

function TPTNegativeAcknowledgementCmd.CmdResultCode: string;
begin
  Result := IntToHex(Ord(cmdInstr), 2);
end;

function TPTNegativeAcknowledgementCmd.CmdResultDescr: string;
begin
  Result := ZVTErrorMessage(CmdResultCode);
end;

constructor TPTNegativeAcknowledgementCmd.Create(ABytes: TBytes);
begin
  inherited Create(ABytes);

  FCmdType := ptcmdtError;
end;

initialization

  TDefaultZVTProtocolManager.RegisterKnownPTCommand('80', '00', TPTAcknowledgementCmd);
  TDefaultZVTProtocolManager.RegisterKnownPTCommand('84', 'xx', TPTNegativeAcknowledgementCmd);

end.
