// 10. Escreva um algoritmo para ler um valor e Escreva se é POSITIVO ou NEGATIVO.
// Considere o valor zero como positivo.
unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
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
  value: double;
begin
  value := StrToFloat(Edit1.Text);

  if(value < 0) then
    begin
      Label1.Caption := 'NEGATIVO';
    end
  else
    begin
      Label1.Caption := 'POSITIVO';
    end;

end;

end.
