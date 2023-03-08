// 2. Leia o denominador e o numerador, resolva o cálculo com os
// valores informados.

unit Unit12;

interface

uses
 Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormDenNum = class(TForm)
    EditDenominador: TEdit;
    EditNumerador: TEdit;
    Button1: TButton;
    LabelDN2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDenNum: TFormDenNum;

implementation

{$R *.dfm}

procedure TFormDenNum.Button1Click(Sender: TObject);
var
  denominador: double;
  numerador: double;
  calculo: double;

begin
  denominador := StrToFloat(EditDenominador.Text);
  numerador := StrToFloat(EditNumerador.Text);
  calculo := numerador / denominador;

 LabelDN2.Caption := FloatToStr(calculo);

end;

end.
