// 6. Escreva um algoritmo para ler uma temperatura em graus Celsius,
// calcular e escrever o valor correspondente em graus Fahrenheit:
// F = C * 9 / 5 + 32


unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormTemperaturaF = class(TForm)
    EditCF: TEdit;
    converterF: TButton;
    Convertido: TLabel;
    procedure converterFClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTemperaturaF: TFormTemperaturaF;

implementation

{$R *.dfm}

procedure TFormTemperaturaF.converterFClick(Sender: TObject);
var
  temperaturaEmFahrenheit: double;
  temperaturaEmCelsius: double;

begin
  temperaturaEmCelsius := StrToFloat(EditCF.Text);
  temperaturaEmFahrenheit :=   temperaturaEmCelsius * 9 / 5 + 32;
  Convertido.Caption := FloatToStr(temperaturaEmFahrenheit);

end;

end.
