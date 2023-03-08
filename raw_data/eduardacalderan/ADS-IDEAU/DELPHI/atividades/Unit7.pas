// 11. Escreva um algoritmo para ler 2 valores
// (considere que não serão informados valores iguais)
// e escreva o maior deles.

unit Unit7;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormMaior = class(TForm)
    EditValue2: TEdit;
    EditValue3: TEdit;
    ok2: TButton;
    LabelMaior: TLabel;
    procedure ok2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMaior: TFormMaior;

implementation

{$R *.dfm}

procedure TFormMaior.ok2Click(Sender: TObject);
var
  value1: double;
  value2: double;

begin
  value1 := StrToFloat(EditValue2.Text);
  value2 := StrToFloat(EditValue3.Text);

  if(value1 > value2) then
    begin
      LabelMaior.Caption := FloatToStr(value1) + ' é maior que ' + FloatToStr(value2);
    end
  else
    begin
     LabelMaior.Caption := FloatToStr(value2) + ' é maior que ' + FloatToStr(value1);
    end;
end;

end.
