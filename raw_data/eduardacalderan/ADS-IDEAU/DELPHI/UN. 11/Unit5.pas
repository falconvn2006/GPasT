// 6. Escreva um algoritmo para ler uma temperatura em graus Celsius,
// calcular e escrever o valor correspondente em graus Fahrenheit:
// F = C * 9 / 5 + 32


unit Unit5;

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
  temperaturaEmCelsius := StrToFloat(Edit1.Text);
  temperaturaEmFahrenheit :=   temperaturaEmCelsius * 9 / 5 + 32;
  Label1.Caption := FloatToStr(temperaturaEmFahrenheit);

end;

end.
