// 4. Escreva um algoritmo para ler o salário mensal e o percentual de reajuste.
// Calcular e escrever o valor do novo salário.

unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Button1: TButton;
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
    salario: double;
    percentualReajuste: double;
    novoSalario: double;

begin
  salario := StrToFloat(Edit1.Text);
  percentualReajuste := StrToFloat(Edit2.Text);
  novoSalario := salario * (percentualReajuste / 100);
  Label1.Caption := FloatToStr(salario + novoSalario);
end;

end.
