// 11. Escreva um algoritmo para ler 2 valores
// (considere que não serão informados valores iguais)
// e escreva o maior deles.

unit Unit7;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
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

begin
  value1 := StrToFloat(Edit1.Text);
  value2 := StrToFloat(Edit2.Text);

  if(value1 > value2) then
    begin
      Label1.Caption := FloatToStr(value1) + ' é maior que ' + FloatToStr(value2);
    end
  else
    begin
      Label1.Caption := FloatToStr(value2) + ' é maior que ' + FloatToStr(value1);
    end;
end;

end.
