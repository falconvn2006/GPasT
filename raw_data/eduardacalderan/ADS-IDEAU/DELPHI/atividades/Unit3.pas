// 4. Escreva um algoritmo para ler o salário mensal e o percentual de reajuste.
// Calcular e escrever o valor do novo salário.

unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormSalario = class(TForm)
    EditSalario: TEdit;
    EditReajuste: TEdit;
    LabelSalario: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSalario: TFormSalario;

implementation

{$R *.dfm}

procedure TFormSalario.Button1Click(Sender: TObject);
  var
    salario: double;
    percentualReajuste: double;
    novoSalario: double;

begin
  salario := StrToFloat(EditSalario.Text);
  percentualReajuste := StrToFloat(EditReajuste.Text);
  novoSalario := salario * (percentualReajuste / 100);
  LabelSalario.Caption := FloatToStr(salario + novoSalario);
end;

end.
