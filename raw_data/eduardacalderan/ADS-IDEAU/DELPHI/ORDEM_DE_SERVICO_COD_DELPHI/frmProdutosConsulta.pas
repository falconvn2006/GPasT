unit frmProdutosConsulta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmConsulta, Data.DB, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TformProdutosConsulta = class(TformConsulta)
    NomeProdutos: TLabel;
    editNomeProduto: TEdit;
    ValorProdutos: TLabel;
    EditValorProduto: TEdit;
    ButtonProcurar: TButton;
    procedure ButtonProcurarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formProdutosConsulta: TformProdutosConsulta;

implementation

{$R *.dfm}

uses frmProdutosCadastro, dmProdutos;



procedure TformProdutosConsulta.ButtonProcurarClick(Sender: TObject);
var
  sql: string;
  condicao: boolean;
begin
  inherited;
   sql := 'select * from produtos';
  condicao := false;
  if trim(editNomeProduto.Text) <> '' then
  begin
    sql := sql + ' where upper(nome) like ' + QuotedStr(UpperCase('%' + editNomeProduto.Text + '%'));
    condicao := true;
  end;
  if trim(editValorProduto.Text) <> '' then
  begin
    if not condicao then
      sql := sql + ' where '
    else
      sql := sql + ' and ';
    sql := sql + ' upper(cpf) like ' + QuotedStr(UpperCase('%' + editValorProduto.Text + '%'));
  end;
  sql := sql + ' order by nome';
  dtmProdutos.sqlProcura(sql);
end;

end.
