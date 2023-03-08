unit U_atv03;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfrm_principal = class(TForm)
    lb_numero1: TLabel;
    txt_num1: TEdit;
    txt_num2: TEdit;
    lb_num2: TLabel;
    lb_num3: TLabel;
    txt_num3: TEdit;
    btn_maior: TButton;
    procedure btn_maiorClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_principal: Tfrm_principal;

implementation

{$R *.dfm}

procedure Tfrm_principal.btn_maiorClick(Sender: TObject);
var
num1, num2, num3: real;
begin
num1 := strtofloat(txt_num1.text);
num2 := strtofloat(txt_num2.text);
num3 := strtofloat(txt_num3.text);
  if (num1 > num2) and (num1 > num3)  then
    showmessage('O primeiro numero é maior')
    else
      if (num2 > num1) and (num2 > num3) then
        showmessage('O segundo numero é maior')
      else
        showmessage('O terceiro numero é maior  ')

end;

end.
