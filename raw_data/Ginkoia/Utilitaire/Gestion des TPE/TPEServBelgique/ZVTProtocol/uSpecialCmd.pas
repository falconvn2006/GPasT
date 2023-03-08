unit uSpecialCmd;

interface

uses
  uCommand;

type
  TPTTimeOutCmd = class(TPTCommand)
  private
  protected
  public
    constructor Create; overload;

    function CmdResultCode: string; override;
    function CmdResultDescr: string; override;
  end;

implementation

{ TPTTimeOutCmd }

function TPTTimeOutCmd.CmdResultCode: string;
begin
  Result := 'TO';
end;

function TPTTimeOutCmd.CmdResultDescr: string;
begin
  Result := 'TimeOut : Le terminal de payement n''a pas répondu dans le délai imparti';
end;

constructor TPTTimeOutCmd.Create;
begin
  FCmdType := ptcmdtTimeOut;
end;

end.
