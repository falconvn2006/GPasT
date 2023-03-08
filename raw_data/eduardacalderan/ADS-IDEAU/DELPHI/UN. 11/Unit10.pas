// 15. Escreva um algoritmo para ler 3 valores e escreva o maior deles.
// Considere que o usuário não informará valores iguais.
unit Unit10;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
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
  value1: double;
  value2: double;
  value3: double;

begin
  value1 := StrToFloat(Edit1.Text);
  value2 := StrToFloat(Edit2.Text);
  value3 := StrToFloat(Edit3.Text);

  if(value1 > value2) and (value1 > value3) then
    begin
      Label1.Caption := FloatToStr(value1) + ' é o maior número';
    end
  else if (value2 > value1) and (value2 > value3) then
    begin
      Label1.Caption := FloatToStr(value2) + ' é o maior número';
    end
  else
    begin
      Label1.Caption := FloatToStr(value3) + ' é o maior número';
    end;
end;

end.
