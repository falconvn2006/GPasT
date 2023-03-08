// 5. Escreva um algoritmo para ler uma temperatura em graus Fahrenheit,
// calcular e escrever o valor correspondente em graus Celsius:
// C = ((F – 32)*5)/9

unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormTemperatura = class(TForm)
    EditFC: TEdit;
    converterC: TButton;
    ConvertidoC: TLabel;
    procedure converterCClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTemperatura: TFormTemperatura;

implementation

{$R *.dfm}

procedure TFormTemperatura.converterCClick(Sender: TObject);
var
  temperaturaEmFahrenheit: double;
  temperaturaEmCelsius: double;

begin
  temperaturaEmFahrenheit := StrToFloat(EditFC.Text);
  temperaturaEmCelsius :=  ((temperaturaEmFahrenheit - 32) * 5 ) / 9;
  ConvertidoC.Caption := FloatToStr(temperaturaEmCelsius);

end;

end.
