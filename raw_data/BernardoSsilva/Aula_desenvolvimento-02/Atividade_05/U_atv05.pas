unit U_atv05;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfmr_principal = class(TForm)
    Label1: TLabel;
    lb_parcelas: TLabel;
    lb_sal: TLabel;
    txt_valEmp: TEdit;
    txt_parc: TEdit;
    txt_sal: TEdit;
    btn_aprov: TButton;
    procedure btn_aprovClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmr_principal: Tfmr_principal;
  sal, valemp, valParc: double;


implementation

{$R *.dfm}

procedure Tfmr_principal.btn_aprovClick(Sender: TObject);
begin
  sal:= strtofloat(txt_sal.Text);
  valemp := strtofloat(txt_valEmp.Text);
  valParc := valemp / strtoint(txt_parc.Text);
  if valParc > (sal * 0.3) then
  begin
    showmessage('O valor da parcela exede 30% de seu salario'+#13+'Emprestimo negado')
  end
  else
    showmessage('Emprestimo aprovado')


end;

end.
