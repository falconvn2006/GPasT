unit uRegistrationCmd;

interface

uses
  uCommand;

Type
  TRegistrationCmd = class(TECRCommand)
  private
    FCurrencyCode: string;
    FPassword: string;
  protected
    function getLength: string; override;
    function getDataBlock: string; override;

  public
    constructor Create; overload;
    destructor Destroy; override;

    function asString: string; override;
  end;

implementation

uses
  uZVTProtocolManager;

{ TRegistrationCmd }

function TRegistrationCmd.asString: string;
begin
  Result := 'Registration (06 00)';
end;

constructor TRegistrationCmd.Create;
begin
  inherited Create(Chr(06), Chr(00));

  FCmdType := ecrcmdtMaster;
  FCurrencyCode := Chr(09) + Chr(78);
  FPassword := Chr(00) + Chr(00) + Chr(00);
end;

destructor TRegistrationCmd.Destroy;
begin
  FCurrencyCode := '';
  FPassword := '';

  inherited;
end;

function TRegistrationCmd.getDataBlock: string;
begin
  Result := FPassword + FCurrencyCode;
end;

function TRegistrationCmd.getLength: string;
begin
  Result := Chr(05);
end;

end.
