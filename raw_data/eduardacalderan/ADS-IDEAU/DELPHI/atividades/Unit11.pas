// 16. Escreva um algoritmo para ler 3 valores e escreva a soma dos 2 maiores.
// Considere que o usuário não informará valores iguais.
unit Unit11;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormMaioresTres = class(TForm)
    EditPrimeiro2: TEdit;
    EditSegundo2: TEdit;
    EditTerceiro2: TEdit;
    ok6: TButton;
    LabelMaioresTres: TLabel;
    procedure ok6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMaioresTres: TFormMaioresTres;

implementation

{$R *.dfm}

procedure TFormMaioresTres.ok6Click(Sender: TObject);
var
  value1: double;
  value2: double;
  value3: double;
  soma1e2: double;
  soma1e3: double;
  soma2e3: double;

begin
  value1 := StrToFloat(EditPrimeiro2.Text);
  value2 := StrToFloat(EditSegundo2.Text);
  value3 := StrToFloat(EditTerceiro2.Text);
  soma1e2 := value1 + value2;
  soma1e3 := value1 + value3;
  soma2e3 := value2 + value3;

  if(value1 > value3) and (value2 > value3) then
    begin
      LabelMaioresTres.Caption := 'Soma dos dois maiores: ' + FloatToStr(soma1e2);
    end
  else if (value3 > value2) and (value1 > value2) then
    begin
      LabelMaioresTres.Caption := 'Soma dos dois maiores: ' + FloatToStr(soma1e3);
    end
  else if (value2 > value1) and (value3 > value1) then
    begin
      LabelMaioresTres.Caption := 'Soma dos dois maiores: ' + FloatToStr(soma2e3);
    end;

end;

end.
