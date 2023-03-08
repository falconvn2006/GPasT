// 13. Escreva um algoritmo para ler um número inteiro
// (considere que serão lidos apenas valores positivos e inteiros)
// e Escreva se é PAR ou ÍMPAR.
unit Unit9;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormParOrIm = class(TForm)
    EditNum1: TEdit;
    ok4: TButton;
    LabelParOrIm: TLabel;
    procedure ok4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormParOrIm: TFormParOrIm;

implementation

{$R *.dfm}

procedure TFormParOrIm.ok4Click(Sender: TObject);
var
  value: integer;

begin
  value := StrToInt(EditNum1.Text);

  if(value mod 2 = 0) then
    begin
      LabelParOrIm.Caption := FloatToStr(value) + ' é par ';
    end
  else
    begin
      LabelParOrIm.Caption := FloatToStr(value) + ' é ímpar ';
    end;

end;

end.
