unit uBMPs;

interface

uses
  SysUtils,
  uZVTProtocolUtils;

Type

  bmpType = (bmpBinary, bmpBCD, bmpLLVar, bmpLLLVar, bmpTLV, bmpASCII);

  TBMPBCD = class
  private
    FCode: string;
    FName: string;
    FLength: integer;
    FDescr: string;
    FValue: string;
    FGetFormatedValueProcedure: TBMPGetFormatedValueEvent;
    function getFormatedValue: string;
  public
    constructor Create(ACode: string; AName: string; ALength: Integer;
      ADescr: string; ABytes: TBytes; AStartIndex: integer; AGetFormatedValueProcedure: TBMPGetFormatedValueEvent);

    property Code: string read FCode;
    property Name: string read FName;
    property Value: string read FValue;
    property Length: integer read FLength;

    property FormatedValue: string read getFormatedValue;
  end;

  TBMPArray = array of TBMPBCD;

  TBMPClass = class of TBMPBCD;

  TBMP = Record
    Code: string;
    Name: string;
    Length: integer;
    _type: bmpType;
    Descr: string;
    bmpObject: TBMPClass;
    getFormatedValueProcedure: TBMPGetFormatedValueEvent;
  End;

  TBMPManager = Class
  private
    FBMPs: array of TBMP;
  public
    constructor Create;
    destructor Destroy; override;

    function RegisterBMP(ACode: string; AName: string; ALength: Integer; AbmpType: bmpType;
      ADescr: string; AGetFormatedValueProcedure: TBMPGetFormatedValueEvent = nil): boolean;

    function getBMP(ACode: string): TBMP;
  End;

var
  FBMPManager: TBMPManager;

implementation

{ TBMPManager }

constructor TBMPManager.Create;
begin
  SetLength(FBMPs, 0);
end;

destructor TBMPManager.Destroy;
begin
  SetLength(FBMPs, 0);

  inherited;
end;

function TBMPManager.getBMP(ACode: string): TBMP;
var
  i: integer;
begin
  Result.Code := '';
  for i := 0 to Length(FBMPs) do
  begin
    if FBMPs[i].Code = ACode then
    begin
      Result := FBMPs[i];
      Break;
    end;
  end;
end;

function TBMPManager.RegisterBMP(ACode: string; AName: string; ALength: Integer;
  AbmpType: bmpType; ADescr: string; AGetFormatedValueProcedure: TBMPGetFormatedValueEvent): boolean;
var
  index: integer;
  bmp: TBMP;
begin
  index := Length(FBMPs);
  SetLength(FBMPs, index + 1);

  bmp.Code := ACode;
  bmp.Name := AName;
  bmp.Length := ALength;
  bmp._type := AbmpType;
  bmp.Descr := ADescr;
  bmp.bmpObject := TBMPBCD;
  bmp.getFormatedValueProcedure := AGetFormatedValueProcedure;

  FBMPs[index] := bmp;

  Result := True;
end;

{ TBMPBCD }

constructor TBMPBCD.Create(ACode, AName: string; ALength: Integer;
  ADescr: string; ABytes: TBytes; AStartIndex: integer; AGetFormatedValueProcedure: TBMPGetFormatedValueEvent);
var
  i: integer;
begin
  FCode := ACode;
  FName := AName;
  FLength := ALength;
  FDescr := ADescr;
  FGetFormatedValueProcedure := AGetFormatedValueProcedure;

  //AStartIndex + 1 parce que la position AStartIndex correspond au code BMP
  FValue := IntToHex(ABytes[AStartIndex + 1], 2);
  for i := AStartIndex + 2 to ALength + AStartIndex do
  begin
    FValue := FValue + ' ' + IntToHex(ABytes[i], 2);
  end;
end;

function TBMPBCD.getFormatedValue: string;
begin
  Result := FValue;
  if Assigned(FGetFormatedValueProcedure) then
    FGetFormatedValueProcedure(FValue, Result);
end;

initialization
  FBMPManager := TBMPManager.Create;

  FBMPManager.RegisterBMP('04', 'Amount', 6, bmpBCD, 'Montant de la transaction');

  FBMPManager.RegisterBMP('0B', 'TraceNumber', 3, bmpBCD, '');
  FBMPManager.RegisterBMP('0C', 'Time', 3, bmpBCD, 'Heure de la transaction "HHMMSS"');
  FBMPManager.RegisterBMP('0D', 'Date', 2, bmpBCD, 'Date de la transaction "DD MM"');
  FBMPManager.RegisterBMP('0E', 'ExpiryDate', 2, bmpBCD, 'Date d''expiration "YY MM"');

  FBMPManager.RegisterBMP('19', 'PaymentType', 1, bmpBinary, 'Type de paiement');

  FBMPManager.RegisterBMP('22', 'CardNumber', 8 + 2, bmpLLvar, 'Numéro de la carte', getFormatLLVarBMP);

  FBMPManager.RegisterBMP('27', 'ResultCode', 1, bmpBinary, 'Code retour d''une transaction', getFormatedZVTError);

  FBMPManager.RegisterBMP('29', 'TerminalID', 4, bmpBCD, 'ID du terminal de paiement');
  FBMPManager.RegisterBMP('2A', 'VUNumber', 15, bmpASCII, '');

  FBMPManager.RegisterBMP('3B', 'AID', 8, bmpBinary, 'Authorisation attribute');
  FBMPManager.RegisterBMP('3C', 'AdditionalText', 90 + 3, bmpLLVar, '');

  FBMPManager.RegisterBMP('49', 'Currency Code', 2, bmpBCD, 'Currency code');

  FBMPManager.RegisterBMP('87', 'ReceiptNumber', 2, bmpBCD, 'Numéro de reçu');
  FBMPManager.RegisterBMP('88', 'TurnoverRecordNumber', 3, bmpBCD, '');
  FBMPManager.RegisterBMP('8A', 'CardType', 1, bmpBinary, 'Type de carte de paiement');

finalization

  FreeAndNil(FBMPManager);

end.
