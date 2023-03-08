unit U.IMC;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tfrm_IMC = class(TForm)
    lb_titulo1: TLabel;
    txt_peso: TEdit;
    lb_titulo2: TLabel;
    txt_altura: TEdit;
    btn_calcular: TButton;
    procedure btn_calcularClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_IMC: Tfrm_IMC;
  peso,altura,resultado:double;

implementation

{$R *.dfm}

procedure Tfrm_IMC.btn_calcularClick(Sender: TObject);
begin
 peso:=StrToFloat(txt_peso.Text);
 altura:=StrToFloat(txt_altura.Text);
 resultado:= peso / (altura*altura);
 if (resultado<16) then
 showmessage('Magreza Grave: '+FloatToStr(resultado) )
 else
  if (resultado>16) and (resultado<17)then
 showmessage('Magreza Moderada: '+FloatToStr(resultado) )
 else
  if (resultado>17) and (resultado<18.5)then
 showmessage('Magreza Leve: '+FloatToStr(resultado) )
 else
  if (resultado>18.5) and (resultado<25)then
 showmessage('Sa�davel: '+FloatToStr(resultado) )
 else
  if (resultado>25) and (resultado<30)then
 showmessage('Sobrepeso: '+FloatToStr(resultado) )
 else
  if (resultado>30) and (resultado<35)then
 showmessage('Obesidade Grau I: '+FloatToStr(resultado) )
 else
  if (resultado>35) and (resultado<40)then
 showmessage('Obesidade Grau II(severa): '+FloatToStr(resultado) )
 else
 if  (resultado >=40)then
 showmessage('Obesidade Grau III(m�rbida): '+FloatToStr(resultado) );



 end;

end.
