unit SasieFloat_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFrm_SasieFloat = class(TForm)
    lblMontant: TLabel;
    edtMontant: TEdit;
    btnValider: TBitBtn;
    btnCancel: TBitBtn;
    procedure edtMontantKeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
    function GetMontant() : Double;
    procedure SetMontant(Value : Double);
  public
    { Déclarations publiques }
  published
    { Déclarations publiées }
    property Montant : Double read GetMontant write SetMontant;
  end;

function InputMontant(var Montant : Double) : Boolean;

implementation

{$R *.dfm}

procedure TFrm_SasieFloat.edtMontantKeyPress(Sender: TObject; var Key: Char);
begin
  if CharInSet(Key, ['.', ',']) then
    Key := FormatSettings.DecimalSeparator;

  if not CharInSet(Key, ['0'..'9', '-', FormatSettings.DecimalSeparator, Chr(VK_BACK)]) then
    Key := #0
  else if (Key = '-') and not (edtMontant.SelStart = 0) then
    Key := #0
  else if (Key = FormatSettings.DecimalSeparator) and (Pos(FormatSettings.DecimalSeparator,edtMontant.Text) > 0) then
    Key := #0;
end;

function TFrm_SasieFloat.GetMontant() : Double;
begin
  Result := StrToFloatDef(edtMontant.Text, 0);
end;

procedure TFrm_SasieFloat.SetMontant(Value : Double);
begin
  edtMontant.Text := FloatToStr(Value);
end;

function InputMontant(var Montant : Double) : Boolean;
var
  Saisie : TFrm_SasieFloat;
begin
  Result := False;
  Saisie := TFrm_SasieFloat.Create(Application);
  try
    Saisie.Montant := Montant;
    if Saisie.ShowModal() = mrOk then
    begin
      Montant := Saisie.Montant;
      Result := True;
    end;
  finally
    FreeAndNil(Saisie);
  end;
end;

end.
