unit uStatusInfoCmd;

interface

uses
  SysUtils,
  uCommand;

type
  TIntermediateStatusInfoCmd = class(TPTCommand)
  private
    FStatus: string;

  public
    constructor Create(ABytes: TBytes); override;
    destructor Destroy; override;

    function asString: string; override;
    function CmdResultCode: string; override;
    function CmdResultDescr: string; override;

    function getResponseCmd: TCommand; override;
  end;

  TStatusInfoCmd = class(TPTBMPCommand)
  private
  public
    constructor Create(ABytes: TBytes); override;

    function Clone: TPTCommand; override;
    function getResponseCmd: TCommand; override;
    function getCardNumber: string;
  end;

implementation

uses
  uZVTProtocolUtils, uAcknowledgementCmd, uZVTProtocolManager, uBMPs;

{ TIntermediateStatusInfoCmd }

function TIntermediateStatusInfoCmd.asString: string;
begin
  Result := 'Intermediate Status : ' + CmdResultDescr;
end;

function TIntermediateStatusInfoCmd.CmdResultCode: string;
begin
  Result := FStatus;
end;

function TIntermediateStatusInfoCmd.CmdResultDescr: string;
begin
  Result := ZVTStatusMessage(FStatus);
end;

constructor TIntermediateStatusInfoCmd.Create(ABytes: TBytes);
begin
  inherited Create(ABytes);

  FSendResponse := True;
  FStatus := IntToHex(FBytes[5], 2);
end;

destructor TIntermediateStatusInfoCmd.Destroy;
begin
  FStatus := '';

  inherited;
end;

function TIntermediateStatusInfoCmd.getResponseCmd: TCommand;
begin
  Result := TECRAcknowledgementCmd.Create;
end;

{ TStatusInfoCmd }

function TStatusInfoCmd.Clone: TPTCommand;
begin
  Result := TStatusInfoCmd.Create(FBytes);

//  Result.FBytes := FBytes;
end;

constructor TStatusInfoCmd.Create(ABytes: TBytes);
begin
  inherited Create(ABytes);

  FSendResponse := True;
  FCmdType := ptcmdtResult;
end;

function TStatusInfoCmd.getCardNumber: string;
var
  bmp: TBMPBCD;
begin
  bmp := getBMP('22');
  if Assigned(bmp) then
    Result := bmp.FormatedValue
  else
    Result := 'Not Defined';
end;

function TStatusInfoCmd.getResponseCmd: TCommand;
begin
  Result := TECRAcknowledgementCmd.Create;
end;

initialization

  TDefaultZVTProtocolManager.RegisterKnownPTCommand('04', 'FF', TIntermediateStatusInfoCmd);
  TDefaultZVTProtocolManager.RegisterKnownPTCommand('04', '0F', TStatusInfoCmd);

end.
