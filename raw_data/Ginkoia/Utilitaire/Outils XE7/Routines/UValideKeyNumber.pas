unit UValideKeyNumber;

interface

uses
  Vcl.StdCtrls;

procedure ValideNumericKeyPress(Edit : TCustomEdit; var Key: Char; Negatif : boolean = true; Flotant : boolean = true); overload;
procedure ValideNumericKeyPress(Edit : TCustomEdit; var Key: Char; Decimal : integer; Negatif : boolean = true; Flotant : boolean = true); overload;

function GetFloatFromEdit(Edit : TEdit) : Double;
procedure SetEditFromFloat(Edit : TEdit; Value : Double);
function GetCurrencyFromEdit(Edit : TEdit) : Currency;
procedure SetEditFromCurrency(Edit : TEdit; Value : Currency);

implementation

uses
  System.SysUtils,
  Winapi.Windows;

var
  FormatSettings :  TFormatSettings;

procedure ValideNumericKeyPress(Edit : TCustomEdit; var Key: Char; Negatif : boolean; Flotant : boolean);
begin
  ValideNumericKeyPress(Edit, Key, 0, Negatif, Flotant);
end;

procedure ValideNumericKeyPress(Edit : TCustomEdit; var Key: Char; Decimal : integer; Negatif : boolean; Flotant : boolean);
begin
  if CharInSet(Key, ['.', ',']) then
    Key := FormatSettings.DecimalSeparator;

  if not CharInSet(Key, ['0'..'9', '-', FormatSettings.DecimalSeparator, Chr(VK_BACK)]) then
    Key := #0
  else if (Key = '-') and // si - mais que pas negatif ou pas au debut ...
          not (Negatif and (Edit.SelStart = 0)) then
    Key := #0
  else if (Key = FormatSettings.DecimalSeparator) and // si virgule mais que pas an
          not (Flotant and (Pos(FormatSettings.DecimalSeparator, Edit.Text) = 0)) then
    Key := #0
  else if (Decimal > 0) and (Pos(FormatSettings.DecimalSeparator, Edit.Text) > 0) // si on
          and (Length(Edit.Text) - Pos(FormatSettings.DecimalSeparator, Edit.Text) >= Decimal) then
    Key := #0
end;

function GetFloatFromEdit(Edit : TEdit) : Double;
begin
  Result := StrToFloat(Edit.Text, FormatSettings);
end;

procedure SetEditFromFloat(Edit : TEdit; Value : Double);
begin
  Edit.Text := FloatToStr(Value, FormatSettings)
end;

function GetCurrencyFromEdit(Edit : TEdit) : Currency;
begin
  Result := StrToCurr(Edit.Text, FormatSettings);
end;

procedure SetEditFromCurrency(Edit : TEdit; Value : Currency);
begin
  Edit.Text := CurrToStr(Value, FormatSettings)
end;

initialization
  FormatSettings := TFormatSettings.Create();

end.
