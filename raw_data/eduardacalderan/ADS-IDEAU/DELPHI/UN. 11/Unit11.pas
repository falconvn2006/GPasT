// 16. Escreva um algoritmo para ler 3 valores e escreva a soma dos 2 maiores.
// Considere que o usuário não informará valores iguais.
unit Unit11;

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
  soma1e2: double;
  soma1e3: double;
  soma2e3: double;

begin
  value1 := StrToFloat(Edit1.Text);
  value2 := StrToFloat(Edit2.Text);
  value3 := StrToFloat(Edit3.Text);
  soma1e2 := value1 + value2;
  soma1e3 := value1 + value3;
  soma2e3 := value2 + value3;

  if(value1 > value3) and (value2 > value3) then
    begin
      Label1.Caption := 'Soma dos dois maiores: ' + FloatToStr(soma1e2);
    end
  else if (value3 > value2) and (value1 > value2) then
    begin
      Label1.Caption := 'Soma dos dois maiores: ' + FloatToStr(soma1e3);
    end
  else if (value2 > value1) and (value3 > value1) then
    begin
       Label1.Caption := 'Soma dos dois maiores: ' + FloatToStr(soma2e3);
    end;

end;

end.
