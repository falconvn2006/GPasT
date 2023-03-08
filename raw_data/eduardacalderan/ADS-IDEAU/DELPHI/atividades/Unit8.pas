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
  TFormSenha = class(TForm)
    EditSenha: TEdit;
    ok3: TButton;
    LabelSenha: TLabel;
    procedure ok3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSenha: TFormSenha;

implementation

{$R *.dfm}

procedure TFormSenha.ok3Click(Sender: TObject);
var
  senha: string;
  senhaDigitada: string;

begin
   senha := '1234';
   senhaDigitada := EditSenha.Text;

  if(senhaDigitada <> senha) then
    begin
     LabelSenha.Caption := 'ACESSO NEGADO';
    end
  else
    begin
      LabelSenha.Caption :=  'ACESSO PERMITIDO';
    end;

end;

end.
