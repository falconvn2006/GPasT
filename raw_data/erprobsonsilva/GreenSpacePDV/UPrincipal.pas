unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls,
  UProduto, UEntidade, UMovimentoEntrada, UMovimentoVenda, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, UDM, URelatorioFiltro;

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
    Relatrio1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Produto1Click(Sender: TObject);
    procedure Entidade1Click(Sender: TObject);
    procedure Compra1Click(Sender: TObject);
    procedure Venda1Click(Sender: TObject);
    procedure Relatrio1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TCadProduto : TFProduto;
    TCadEntidade : TFEntidade;
    TMovimentoEntrada : TFMovimentoEntrada;
    TMovimentoVenda : TFMovimentoVenda;
    TRelatorioFiltro : TFRelatorioFiltro;
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
  TRelatorioFiltro := TFRelatorioFiltro.Create(nil);
  TRelatorioFiltro.parent := PTarefa;
end;

procedure TFPrincipal.FormDestroy(Sender: TObject);
begin
  FreeAndNil(TCadProduto);
  FreeAndNil(TCadEntidade);
  FreeAndNil(TMovimentoEntrada);
  FreeAndNil(TMovimentoVenda);
  FreeAndNil(TRelatorioFiltro);
end;

procedure TFPrincipal.Produto1Click(Sender: TObject);
begin
  TCadProduto.show;
end;

procedure TFPrincipal.Relatrio1Click(Sender: TObject);
begin
  TRelatorioFiltro.show;
end;

procedure TFPrincipal.Venda1Click(Sender: TObject);
var
  xFbMovimentoDia, xFbInsertMovimentoDia : TFDQuery;
  ValorInicial : String;
begin
  xFbMovimentoDia := TFDQuery.Create(nil);
  xFbMovimentoDia.Connection := dm.ConnectionPostgres;
  xFbMovimentoDia.SQL.Add(' SELECT * ');
  xFbMovimentoDia.SQL.Add('   FROM MOVIMENTO_DIA ');
  xFbMovimentoDia.SQL.Add('  WHERE data_movimento = :data_movimento ');
  xFbMovimentoDia.ParamByName('data_movimento').AsDate := date;
  xFbMovimentoDia.Open;

  if xFbMovimentoDia.Eof then
  begin
    ValorInicial := InputBox('Entrada Operador','Valor de caixa','');
    try
      xFbInsertMovimentoDia := TFDQuery.Create(nil);
      xFbInsertMovimentoDia.Connection := dm.ConnectionPostgres;
      xFbInsertMovimentoDia.SQL.Add(' INSERT INTO MOVIMENTO_DIA ( ');
      xFbInsertMovimentoDia.SQL.Add('   data_movimento, valor_inicial) ');
      xFbInsertMovimentoDia.SQL.Add('  VALUES (:data_movimento, :valor_inicial) ');
      xFbInsertMovimentoDia.ParamByName('data_movimento').AsDate := date;
      xFbInsertMovimentoDia.ParamByName('valor_inicial').AsFloat := StrToFloat(ValorInicial);
      xFbInsertMovimentoDia.ExecSQL;
      TMovimentoVenda.Show;
    Except
      on E: Exception do
        ShowMessage('Favor informar um valor no formato Real, por exemplo: 333,33!')
    end;
  end
  else
    TMovimentoVenda.Show;
end;

end.
