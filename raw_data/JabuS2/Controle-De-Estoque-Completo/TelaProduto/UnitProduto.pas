unit UnitProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Data.DB, Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids;

type
  TfmrProduto = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    dbedtCodigo: TDBEdit;
    lbl3: TLabel;
    dbedtDescricao: TDBEdit;
    lbl4: TLabel;
    dbedtQuantidade: TDBEdit;
    lbl5: TLabel;
    dbedtPrecoCompra: TDBEdit;
    lbl6: TLabel;
    dbedtPrecoVenda: TDBEdit;
    lbl7: TLabel;
    dbcbFornecedor: TDBComboBox;
    btnCadastrar: TButton;
    btnSalvar: TButton;
    btnCancelar: TButton;
    Shape1: TShape;
    GroupBox1: TGroupBox;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    ADOQuery1id_produto: TAutoIncField;
    ADOQuery1cod_produto: TIntegerField;
    ADOQuery1desc_produto: TStringField;
    ADOQuery1marca: TStringField;
    ADOQuery1quantidade: TIntegerField;
    ADOQuery1preco_compra: TFloatField;
    ADOQuery1preco_venda: TFloatField;
    ADOQuery1fornecedor: TStringField;
    ADOQuery2: TADOQuery;
    ADOQuery2nome_fantasia: TStringField;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    procedure dbcbFornecedorDropDown(Sender: TObject);
    procedure btnCadastrarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
  procedure botoes;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmrProduto: TfmrProduto;

implementation

{$R *.dfm}

procedure tfmrproduto.botoes;
begin
if btnCadastrar.Focused then
  begin
  //botoes
  btncadastrar.Enabled:=false;
  btnsalvar.Enabled:=true;
  btncancelar.Enabled:=true;
  //grid
  dbedtCodigo.Enabled:=true;
  dbedtDescricao.Enabled:=true;
  dbedtQuantidade.Enabled:=true;
  dbedtPrecoCompra.enabled:=true;
  dbedtPrecoVenda.Enabled:=true;
  dbcbFornecedor.Enabled:=true;
  dbedtCodigo.SetFocus;
  end
else if (btnSalvar.Focused) or (btnCancelar.Focused) then
  begin
  //botoes
  btncadastrar.Enabled:=true;
  btnsalvar.Enabled:=false;
  btncancelar.Enabled:=false;
  //grid
  dbedtCodigo.Enabled:=false;
  dbedtDescricao.Enabled:=false;
  dbedtQuantidade.Enabled:=false;
  dbedtPrecoCompra.enabled:=false;
  dbedtPrecoVenda.Enabled:=false;
  dbcbFornecedor.Enabled:=false;
  end;

end;

procedure TfmrProduto.btnCadastrarClick(Sender: TObject);
begin
    adoquery1.Append;
    botoes;
end;

procedure TfmrProduto.btnCancelarClick(Sender: TObject);
begin
  ADOQuery1.sql.clear;
  ADOQuery1.SQL.Add('select * from produto for update');
  ADOQuery1.Open;
  botoes;
end;

procedure TfmrProduto.btnSalvarClick(Sender: TObject);
begin
  adoquery1.Post;
  showmessage('Salvo com sucesso!');
  ADOQuery1.sql.clear;
  ADOQuery1.SQL.Add('select * from produto for update');
  ADOQuery1.Open;
  botoes;
end;

procedure TfmrProduto.dbcbFornecedorDropDown(Sender: TObject);
begin
  ADOQuery2.sql.clear;
  ADOQuery2.SQL.Add('select * from fornecedores for update');
  ADOQuery2.Open;
  dbcbFornecedor.Items.Clear;
  var
  contador:integer;
  contador:=0;
  while contador< adoquery2.RecordCount do
  begin
  dbcbFornecedor.Items.Add(adoquery2['nome_fantasia']);
  adoquery2.next;
  contador:=contador+1;
  end;

  {while not adoquery2.eof do
  begin
  dbcbFornecedor.Items.Add(adoquery2['nome_fantasia']);
  adoquery2.next;
  end;}
end;

end.
