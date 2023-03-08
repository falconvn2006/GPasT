unit U_atv09;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfmr_principal = class(TForm)
    lb_valor: TLabel;
    lb_salario: TLabel;
    btn_calcular: TButton;
    txt_valvend: TEdit;
    txt_salario: TEdit;
    procedure btn_calcularClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmr_principal: Tfmr_principal;
  salFim, salBru, valVend: real;
implementation

{$R *.dfm}

procedure Tfmr_principal.btn_calcularClick(Sender: TObject);
begin
  salBru := strtofloat(txt_salario.text);
  valVend := strtofloat(txt_valvend.Text);

  if valVend >= 2000 then
  begin
    showmessage('O salario final do funcionario sera de: R$'+ floattostr(salBru + (valVend*0.1)));
  end
  else
    showmessage('O salario final do funcionario sera de: R$ '+floattostr(salBru))
end;

end.
