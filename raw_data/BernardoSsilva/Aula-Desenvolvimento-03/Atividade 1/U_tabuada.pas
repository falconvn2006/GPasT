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
i : integer;
begin
  num := strtoint(txt_numero.Text);
  for i := 0 to 10 do
  begin
    LB_tabuada.Items[i] :=(floattostr(num)+' X '+inttostr(i)+' = '+ floattostr(num*i));
  end;


end;

end.
