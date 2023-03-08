unit U_atv04;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFmr_principal = class(TForm)
    lb_salario: TLabel;
    lb_tempo: TLabel;
    txt_salario: TEdit;
    txt_tempo: TEdit;
    btn_acrescimo: TButton;
    procedure btn_acrescimoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fmr_principal: TFmr_principal;
  salarioFim : real;

implementation

{$R *.dfm}

procedure TFmr_principal.btn_acrescimoClick(Sender: TObject);
begin
  if strtoint(txt_tempo.text) >= 5 then
  begin
    salarioFim := strtofloat(txt_salario.text) + (strtofloat(txt_salario.text) * 0.2)
  end
  else
    salarioFim := strtofloat(txt_salario.text) + (strtofloat(txt_salario.text) * 0.1);

  showmessage('O salario final do funcionario sera de: R$'+ floattostr(salarioFim));
end;

end.
