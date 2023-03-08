// 10. Escreva um algoritmo para ler um valor e Escreva se é POSITIVO ou NEGATIVO.
// Considere o valor zero como positivo.
unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormPN = class(TForm)
    EditValue1: TEdit;
    LabelPM: TLabel;
    ok1: TButton;
    procedure ok1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPN: TFormPN;

implementation

{$R *.dfm}

procedure TFormPN.ok1Click(Sender: TObject);
var
  value: double;
begin
  value := StrToFloat(EditValue1.Text);

  if(value < 0) then
    begin
     LabelPM.Caption := 'NEGATIVO';
    end
  else
    begin
     LabelPM.Caption := 'POSITIVO';
    end;

end;

end.
