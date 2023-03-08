unit UPincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  UProduto, UEntidade, UMovimentoEntrada, UMovimentoVenda;

type
  TFPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    Movimento1: TMenuItem;
    Entidade1: TMenuItem;
    Produto1: TMenuItem;
    Compra1: TMenuItem;
    Venda1: TMenuItem;
    PTarefa: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Produto1Click(Sender: TObject);
    procedure Entidade1Click(Sender: TObject);
    procedure Compra1Click(Sender: TObject);
    procedure Venda1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TCadProduto : TFProduto;
    TCadEntidade : TFEntidade;
    TMovimentoEntrada : TFMovimentoEntrada;
    TMovimentoVenda : TFMovimentoVenda;
  end;

var
  FPrincipal: TFPrincipal;

implementation

{$R *.dfm}

procedure TFPrincipal.Compra1Click(Sender: TObject);
begin
  TMovimentoEntrada.Show;
end;

procedure TFPrincipal.Entidade1Click(Sender: TObject);
begin
  TCadEntidade.Show;
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  TCadProduto := TFProduto.create(nil);
  TCadProduto.Parent := PTarefa;
  TCadEntidade := TFEntidade.Create(nil);
  TCadEntidade.parent := PTarefa;
  TMovimentoEntrada := TFMovimentoEntrada.create(nil);
  TMovimentoEntrada.parent := PTarefa;
  TMovimentoVenda := TFMovimentoVenda.create(nil);
  TMovimentoVenda.parent := PTarefa;
end;

procedure TFPrincipal.FormDestroy(Sender: TObject);
begin
  FreeAndNil(TCadProduto);
  FreeAndNil(TCadEntidade);
  FreeAndNil(TMovimentoEntrada);
  FreeAndNil(TMovimentoVenda);
end;

procedure TFPrincipal.Produto1Click(Sender: TObject);
begin
  TCadProduto.show;
end;

procedure TFPrincipal.Venda1Click(Sender: TObject);
begin
  TMovimentoVenda.Show;
end;

end.
