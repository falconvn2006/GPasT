unit U_atv14;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  Tfmr_principal = class(TForm)
    rg_tc: TRadioGroup;
    lbCap: TLabel;
    txt_capacidade: TEdit;
    btnCalcular: TButton;
    procedure btnCalcularClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmr_principal: Tfmr_principal;
  preco: double;

implementation

{$R *.dfm}

procedure Tfmr_principal.btnCalcularClick(Sender: TObject);
begin
   if rg_tc.ItemIndex = 0 then
    begin
      preco := 1.80 * strtoint(txt_capacidade.Text);
    end
    else
      preco := 1.00 * strtoint(txt_capacidade.Text);

      showmessage('Serão nescessarios R$'+floattostr(preco)+' para encher o tanque do carro')
end;

end.
