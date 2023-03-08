unit UnitLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.StdCtrls, Data.DB, Data.Win.ADODB;

type
  TfmrLogin = class(TForm)
    imgLogo: TImage;
    Shape1: TShape;
    edtUsuario: TEdit;
    imgUsuario: TImage;
    edtSenha: TEdit;
    imgSenha: TImage;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    btnEntrar: TButton;
    ADOQuery1id_usuario: TAutoIncField;
    ADOQuery1nome: TStringField;
    ADOQuery1senha: TIntegerField;
    ADOQuery1nivel: TStringField;
    procedure btnEntrarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmrLogin: TfmrLogin;

implementation

{$R *.dfm}

uses UnitPrincipal;
//Botao entrar
procedure TfmrLogin.btnEntrarClick(Sender: TObject);
begin
  try
    begin
    ADOQuery1.sql.clear;
    ADOQuery1.SQL.Add('select * from usuario where nome='''+edtUsuario.text+''' and senha='''+edtSenha.text+'''');
    ADOQuery1.Open;
    end;
    except
  end;
//if para verificar se os campos estao vazios
if (edtUsuario.text = '') and (edtSenha.text = '') then
  begin
    showmessage('Digite seu Usuario e Senha');
  end
    else
    //if para verificar se o que tem nos campos sao igual ao banco
      if (edtUsuario.text = ADOQuery1nome.text) and (edtSenha.text =ADOQuery1senha.text)then
        begin
          showmessage('Bem Vindo '+edtUsuario.text);
          if (adoquery1.FieldByName('nivel').AsString) = 'USUARIO' then
          BEGIN
          fmrprincipal.mmCadUsuario.Enabled:=false;
          END;

          fmrLogin.hide;
          fmrPrincipal.showmodal;
          fmrLogin.Close;
        end
          else
          //if para verificar se o que tem nos campos e diferente do banco
            if (edtusuario.text <> ADOQuery1nome.text) and (edtsenha.text <> ADOQuery1senha.text) or (edtusuario.text = '') or (edtsenha.text = '') then
              begin
                showmessage('Usuario ou Senha invalidos');
                edtusuario.text:=('');
                edtsenha.Text:=('');
                edtusuario.SetFocus;
              end;
end;

end.
