unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,Winapi.ShellApi,
  Pattern.SingletonConecta,
  BO.AtualizaVersao;

Type
  TfrmPrincipal = class(TForm)
    btnAtualizarVersao: TButton;
    lbVersaoAtual: TLabel;
    procedure btnAtualizarVersaoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure habilitaControles(condicao: Boolean);
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.habilitaControles(condicao: Boolean);
begin
  btnAtualizarVersao.Enabled := condicao;
end;


procedure TfrmPrincipal.btnAtualizarVersaoClick(Sender: TObject);
begin
  habilitaControles(False);
  If boArquivos.arquivosDiretoriosSaoValidos then
    boArquivos.executaAtualizacaoDaVersao;
  habilitaControles(True);
  lbVersaoAtual.Caption := 'Versão Atual: '+Instancia.versaoAtualSistema;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  TConfiguracoes.ObterInstancia;
  lbVersaoAtual.Caption := 'Versão Atual: '+Instancia.versaoAtualSistema;
end;

end.
