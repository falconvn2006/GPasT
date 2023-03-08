unit uCompletionCmd;

interface

uses
  SysUtils,
  uCommand;

type
  TCompletionCmd = class(TPTBMPCommand)
  public
    constructor Create(ABytes: TBytes); override;

    function asString: string; override;
    function getResponseCmd: TCommand; override;
  end;

implementation

uses
  uZVTProtocolManager, uAcknowledgementCmd, uBMPs;

{ TCompletionCmd }

function TCompletionCmd.asString: string;
begin
  Result := 'Completion : ' + Inherited asString;
end;

constructor TCompletionCmd.Create(ABytes: TBytes);
begin
  inherited Create(ABytes);

  FCmdType := ptcmdtSucces;
  FSendResponse := True;
end;

function TCompletionCmd.getResponseCmd: TCommand;
begin
  Result := TECRAcknowledgementCmd.Create;
end;

initialization

  TDefaultZVTProtocolManager.RegisterKnownPTCommand('06', '0F', TCompletionCmd);

end.
