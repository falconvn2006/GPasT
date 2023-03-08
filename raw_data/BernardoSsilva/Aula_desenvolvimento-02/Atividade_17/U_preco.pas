unit U_preco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  Tfmr_main = class(TForm)
    lb_precoI: TLabel;
    txt_preco: TEdit;
    rg_formaPag: TRadioGroup;
    btn_newPrice: TButton;
    procedure btn_newPriceClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmr_main: Tfmr_main;
  preco, novoPreco : double;

implementation

{$R *.dfm}

procedure Tfmr_main.btn_newPriceClick(Sender: TObject);
begin
  preco := strtofloat(txt_preco.Text);
  if rg_formaPag.ItemIndex = 0 then
  begin
    novoPreco := preco - (preco * 0.1);
  end
  else
  if rg_formaPag.ItemIndex = 1 then
  begin
    novoPreco := preco - (preco * 0.05);
  end
  else
  if rg_formaPag.ItemIndex = 2 then
    novoPreco := preco
  else
    novoPreco := preco + (preco * 0.1);

  showmessage('O preço que deve ser pago é: R$ '+floattostr(novoPreco));
end;

end.
