unit U_atv10;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfmr_principal = class(TForm)
    lb_lado1: TLabel;
    lb_lado2: TLabel;
    lb_lado3: TLabel;
    txt_lado1: TEdit;
    txt_lado2: TEdit;
    txt_lado3: TEdit;
    btn_check: TButton;
    procedure btn_checkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmr_principal: Tfmr_principal;

implementation

{$R *.dfm}

procedure Tfmr_principal.btn_checkClick(Sender: TObject);
var
l1, l2, l3: real;
begin
  l1:= strtoint(txt_lado1.Text);
  l2:= strtoint(txt_lado2.Text);
  l3:= strtoint(txt_lado3.Text);

  if (l1 < l2+l3) and (l2 < l1+l3) and (l3 < l2+l1)then
  begin
  if (l1 = l2) and (l2 = l3) then
    showmessage('Triangulo equilatero')
    else
      if ((l1 = l2) and (l2 <> l3)) or ((l1 <> l2) and (l2 = l3)) or ((l3 = l1) and (l1 <> l2)) then
        showmessage('Triangulo isoceles')
        else
        showmessage('Triangulo escaleno')
  end;

end;

end.
