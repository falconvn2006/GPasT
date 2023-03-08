unit U_atv11;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfmr_principal = class(TForm)
    lb_idade: TLabel;
    lb_valor: TLabel;
    txt_valor: TEdit;
    txt_idade: TEdit;
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
idade : integer;
begin
idade:= strtoint(txt_idade.Text);

if idade <= 10 then
  txt_valor.Text := 'R$ 30,00'
  else
    if (29 >= idade) and (idade > 10) then
    txt_valor.Text := 'R$ 60,00'
    else
      if (idade <= 45) and (idade > 29) then
      txt_valor.Text := 'R$ 120,00'
        else
          if (idade <= 59) and (idade > 45) then
          txt_valor.Text := 'R$ 150,00'
            else
              if (idade > 59) then
              txt_valor.Text := 'R$ 300,00'

end;

end.
