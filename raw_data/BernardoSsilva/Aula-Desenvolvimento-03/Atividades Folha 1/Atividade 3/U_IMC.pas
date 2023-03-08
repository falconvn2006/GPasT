unit U_IMC;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfmr_principal = class(TForm)
    lb_peso: TLabel;
    txt_peso: TEdit;
    txt_altura: TEdit;
    lb_altura: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmr_principal: Tfmr_principal;
  imc : real;

implementation

{$R *.dfm}

procedure Tfmr_principal.Button1Click(Sender: TObject);
begin
   imc:= (strtofloat(txt_peso.Text))/ (strtofloat(txt_altura.Text)* strtofloat(txt_altura.Text));
   if imc < 16 then
    showmessage('IMC: '+floattostr(imc)+#13+'Magreza grave')
    else
    if (imc >= 16) and (imc < 17) then
    showmessage('IMC: '+floattostr(imc)+#13+'Magreza moderada')
     else
    if (imc >= 17) and (imc < 18.5) then
    showmessage('IMC: '+floattostr(imc)+#13+'Magreza leve')
    else
    if (imc >= 18.5) and (imc < 25) then
    showmessage('IMC: '+floattostr(imc)+#13+'saudavel')
    else
    if (imc >= 25) and (imc < 30) then
    showmessage('IMC: '+floattostr(imc)+#13+'sobrepeso')
    else
    if (imc >= 30) and (imc < 35) then
    showmessage('IMC: '+floattostr(imc)+#13+'Obesidade grau 1')
    else
    if (imc >= 35) and (imc < 40) then
    showmessage('IMC: '+floattostr(imc)+#13+'Obesidade grau 2')
    else
    if (imc >= 40) then
    showmessage('IMC: '+floattostr(imc)+#13+'Obesidade grau 3')

end;

end.
