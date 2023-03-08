unit form_alterar_senha;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, Buttons, ExtCtrls, DB, IBCustomDataSet,
  IBUpdateSQL, IBQuery;

type
  Talterar_senha = class(TForm)
    Panel1: TPanel;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    btn_ok: TSpeedButton;
    btn_sair: TSpeedButton;
    edtSenhaAtual: TEdit;
    edtNovaSenha: TEdit;
    edtConfirmacao: TEdit;
    dtsUSUARIO: TDataSource;
    qryUSUARIO: TIBQuery;
    udpUsuario: TIBUpdateSQL;
    qryUSUARIOCODIGO: TIntegerField;
    qryUSUARIOSENHA: TIBStringField;
    procedure btn_sairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure qryUSUARIOAfterPost(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  alterar_senha: Talterar_senha;

implementation

uses form_principal, untDados, funcao;

Const
  cCaption = 'ALTERAR SENHA';

{$R *.dfm}

procedure Talterar_senha.btn_okClick(Sender: TObject);
begin
  if edtSenhaAtual.Text = qryUSUARIOSENHA.Text then
  begin
    if edtNovaSenha.Text = edtConfirmacao.Text then
    begin
      qryUSUARIO.Edit;
        qryUSUARIOSENHA.Text := edtNovaSenha.Text;
      qryUSUARIO.Post;
      application.messagebox('Senha Alterada com Sucesso','Terminado',MB_OK+MB_ICONEXCLAMATION);
      Close;
    end
    else
    begin
      application.messagebox('Nova Senha não confere com a Confirmação.','Acesso',MB_OK+MB_ICONERROR);
      edtConfirmacao.SetFocus;
    end;
  end
  else
  begin
    application.messagebox('Senha Atual Invalida.','Acesso',MB_OK+MB_ICONERROR);
    edtSenhaAtual.SetFocus;
  end;
end;

procedure Talterar_senha.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Talterar_senha.FormCreate(Sender: TObject);
begin
   Caption := CaptionTela(cCaption);
end;

procedure Talterar_senha.FormShow(Sender: TObject);
begin
  try
    qryUsuario.Close;
    qryUSUARIO.SQL.Strings[1] := ' where codigo = ' + IntToStr(untDados.CodigoUsuarioCorrente);
    edtSenhaAtual.Text := '';
    edtNovaSenha.Text := '';
    edtConfirmacao.Text := '';
    qryUsuario.Open;
  except
    application.MessageBox('Erro ao abrir consulta com banco de dados','ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Talterar_senha.qryUSUARIOAfterPost(DataSet: TDataSet);
begin
  dados.IBTransaction.CommitRetaining;
end;

end.
