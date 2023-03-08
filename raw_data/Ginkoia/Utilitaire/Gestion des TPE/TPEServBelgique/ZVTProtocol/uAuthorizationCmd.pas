unit uAuthorizationCmd;

interface

uses
  uCommand, System.SysUtils;

type
  TAuthorizationCmd = class(TECRCommand)
  private
    FAmount: Integer;
    procedure setAmount(const Value: integer);

    function getAmountAsPTString: string;
  protected
    function getLength: string; override;
    function getDataBlock: string; override;

  public
    constructor Create(AAmount: integer); overload;

    property Amount: integer read FAmount write setAmount;

    function asString: string; override;
  end;

implementation

{ TAuthorizationCmd }

function TAuthorizationCmd.asString: string;
begin
  Result := 'Authorisation (06 01) [' + IntToStr(Amount) + ']';
end;

constructor TAuthorizationCmd.Create(AAmount: integer);
begin
  inherited Create(Chr(06), Chr(01));

  FCmdType := ecrcmdtMaster;
  Amount := AAmount;
end;

function TAuthorizationCmd.getAmountAsPTString: string;
var
  vMnt: string;
begin
  vMnt := Format('%.12d', [Amount]);
  // Le montant est un paramètre de type BMP dont le code est 4 (voir uBMPs.pas)
  Result := Chr(04) + strAsPTString(vMnt);
end;

function TAuthorizationCmd.getDataBlock: string;
begin
  Result := getAmountAsPTString;
end;

function TAuthorizationCmd.getLength: string;
begin
  // Longueur du type BMP montant (voir uBMPs.pas)
  Result := Chr(07);
end;

procedure TAuthorizationCmd.setAmount(const Value: Integer);
begin
  FAmount := Value;
end;

end.
