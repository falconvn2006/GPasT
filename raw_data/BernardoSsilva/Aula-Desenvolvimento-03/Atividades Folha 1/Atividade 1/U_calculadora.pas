unit U_calculadora;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  Tfmr_principal = class(TForm)
    lb_primnum: TLabel;
    txt_primNum: TEdit;
    txt_segnum: TEdit;
    Lb_segnum: TLabel;
    rg_operacao: TRadioGroup;
    lb_resultado: TLabel;
    btn_calcular: TButton;
    procedure btn_calcularClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmr_principal: Tfmr_principal;

implementation

{$R *.dfm}

procedure Tfmr_principal.btn_calcularClick(Sender: TObject);
var
num1, num2, result : real;
begin
  num1:= strtofloat(txt_primNum.Text);
  num2 := strtofloat(txt_segNum.Text);
  if rg_operacao.ItemIndex = 0 then
  begin
    result := num1 + num2;
    lb_resultado.Caption := floattostr(num1)+' + ' +floattostr(num2)+' = '+floattostr(result)
  end
  else
  if rg_operacao.ItemIndex = 1 then
  begin
    result := num1 - num2;
    lb_resultado.Caption := floattostr(num1)+' - ' +floattostr(num2)+' = '+floattostr(result)
  end
  else
  if rg_operacao.ItemIndex = 2 then
  begin
    result := num1 * num2;
    lb_resultado.Caption := floattostr(num1)+' x ' +floattostr(num2)+' = '+floattostr(result)
  end
  else
  begin
     result := num1 / num2;
    lb_resultado.Caption := floattostr(num1)+' / ' +floattostr(num2)+' = '+floattostr(result);
  end;

  lb_resultado.Visible := true


end;

end.
