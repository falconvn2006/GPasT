// 12. Escreva um algoritmo que verifique a validade de uma senha fornecida
// pelo usuário. A senha válida é o número 1234.
// Deve ser impresso as seguintes mensagens:
// ACESSO PERMITIDO caso a senha seja válida
// ACESSO NEGADO caso a senha seja inválida.

unit Unit8;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
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
  senha: string;
  senhaDigitada: string;

begin
   senha := '1234';
   senhaDigitada := Edit1.Text;

  if(senhaDigitada <> senha) then
    begin
      Label1.Caption := 'ACESSO NEGADO';
    end
  else
    begin
      Label1.Caption :=  'ACESSO PERMITIDO';
    end;

end;

end.
