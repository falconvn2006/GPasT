// 5. Escreva um algoritmo para ler uma temperatura em graus Fahrenheit,
// calcular e escrever o valor correspondente em graus Celsius:
// C = ((F – 32)*5)/9

unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  temperaturaEmFahrenheit: double;
  temperaturaEmCelsius: double;

begin
  temperaturaEmFahrenheit := StrToFloat(Edit1.Text);
  temperaturaEmCelsius :=  ((temperaturaEmFahrenheit - 32) * 5 ) / 9;
  Label1.Caption := FloatToStr(temperaturaEmCelsius);

end;

end.
