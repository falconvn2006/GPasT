unit U_tabuada;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfmr_principal = class(TForm)
    LB_tabuada: TListBox;
    lb_numero: TLabel;
    txt_numero: TEdit;
    btn_calcular: TButton;
    lb_inicio: TLabel;
    txt_inicio: TEdit;
    lb_fim: TLabel;
    txt_fim: TEdit;
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
num : real;
i, f, c : integer;
begin
  num := strtoint(txt_numero.Text);
  i := strtoint(txt_inicio.Text);
  f := strtoint(txt_fim.Text);
  for c := i to f do
  begin
    LB_tabuada.Items[c] :=(floattostr(num)+' X '+inttostr(c)+' = '+ floattostr(num*c));
  end;


end;

end.
