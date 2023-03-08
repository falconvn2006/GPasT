// 15. Escreva um algoritmo para ler 3 valores e escreva o maior deles.
// Considere que o usuário não informará valores iguais.
unit Unit10;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormMaiorTres = class(TForm)
    EditPrimeiro1: TEdit;
    EditSegundo1: TEdit;
    EditTerceiro1: TEdit;
    ok5: TButton;
    LabelMaiorTres: TLabel;
    procedure ok5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMaiorTres: TFormMaiorTres;

implementation

{$R *.dfm}

procedure TFormMaiorTres.ok5Click(Sender: TObject);
var
  value1: double;
  value2: double;
  value3: double;

begin
  value1 := StrToFloat(EditPrimeiro1.Text);
  value2 := StrToFloat(EditSegundo1.Text);
  value3 := StrToFloat(EditTerceiro1.Text);

  if(value1 > value2) and (value1 > value3) then
    begin
      LabelMaiorTres.Caption := FloatToStr(value1) + ' é o maior número';
    end
  else if (value2 > value1) and (value2 > value3) then
    begin
      LabelMaiorTres.Caption := FloatToStr(value2) + ' é o maior número';
    end
  else
    begin
      LabelMaiorTres.Caption := FloatToStr(value3) + ' é o maior número';
    end;
end;

end.
