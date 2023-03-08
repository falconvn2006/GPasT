unit U_atv12;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  Tfmr_principal = class(TForm)
    lb_altura: TLabel;
    txt_altura: TEdit;
    rg_sexo: TRadioGroup;
    lb_peso: TLabel;
    btn_calc: TButton;
    procedure btn_calcClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmr_principal: Tfmr_principal;

implementation

{$R *.dfm}

procedure Tfmr_principal.btn_calcClick(Sender: TObject);
var
altura: real;
begin
  altura := strtofloat(txt_altura.Text);

  if rg_sexo.ItemIndex = 0 then
    begin
      lb_peso.Caption := 'Seu peso ideal é: '+ floattostr((72.7 * altura)-58) +'KG';
    end
    else
      lb_peso.Caption := 'Seu peso ideal é: '+ floattostr((62.1 * altura)-44.7) +'KG';

end;

end.
