unit UProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Mask,
  Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, udm;

type
  TFProduto = class(TForm)
    DsProduto: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    FdqSequencia: TFDQuery;
    Button1: TButton;
    procedure DsProdutoStateChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FProduto: TFProduto;

implementation

{$R *.dfm}

procedure TFProduto.Button1Click(Sender: TObject);
var
  xFbQueryImport : TFDQuery;
  xFbQuerySeqProduto : TFDQuery;
  xFdQueryProdutoInsert: TFDQuery;
begin
  xFbQueryImport := TFDQuery.Create(nil);
  xFbQueryImport.Connection := dm.ConnectionBalanca;
  xFbQueryImport.SQL.Add(' SELECT *              ');
  xFbQueryImport.SQL.Add(' FROM PRODUTOS,      ');
  xFbQueryImport.SQL.Add('      LOJAPRODUTOS   ');
  xFbQueryImport.SQL.Add(' WHERE PRODUTOS.CODIGO = LOJAPRODUTOS.CODPROD ');
  xFbQueryImport.Open;

  xFdQueryProdutoInsert := TFDQuery.Create(nil);
  xFdQueryProdutoInsert.Connection := dm.ConnectionPostgres;
  xFbQuerySeqProduto := TFDQuery.Create(nil);
  xFbQuerySeqProduto.Connection := dm.ConnectionPostgres;

  while not xFbQueryImport.Eof do
  begin

    xFbQuerySeqProduto.SQL.Add(' select coalesce(max(cod_produto),0) + 1 cod_produto ');
    xFbQuerySeqProduto.SQL.Add('   from produto ');
    xFbQuerySeqProduto.Open;


    xFdQueryProdutoInsert.SQL.Add(' INSERT INTO produto( ');
    xFdQueryProdutoInsert.SQL.Add('         cod_produto, cod_balanca, nome, preco, quantidade, descricao, tp_unidade_medida) ');
    xFdQueryProdutoInsert.SQL.Add(' VALUES (:cod_produto, :cod_balanca, :nome, :preco, :quantidade, :descricao, :tp_unidade_medida) ');


    xFdQueryProdutoInsert.ParamByName('cod_produto').AsInteger := xFbQuerySeqProduto.FieldByName('cod_produto').AsInteger;
    xFdQueryProdutoInsert.ParamByName('cod_balanca').AsInteger := xFbQueryImport.FieldByName('codigo').AsInteger;
    if UpperCase(xFbQueryImport.FieldByName('DESCRICAO').AsString) <> 'XXXX' then
      xFdQueryProdutoInsert.ParamByName('nome').AsString := xFbQueryImport.FieldByName('DESCRICAO').AsString
    else
    begin
      xFdQueryProdutoInsert.ParamByName('nome').AsString := '';
    end;

    xFdQueryProdutoInsert.ParamByName('descricao').AsString := xFbQueryImport.FieldByName('DESCRICAO2').AsString;
    xFdQueryProdutoInsert.ParamByName('preco').AsFloat := xFbQueryImport.FieldByName('PRECO').AsFloat;
    xFdQueryProdutoInsert.ParamByName('quantidade').AsFloat := 1;
    xFdQueryProdutoInsert.ParamByName('tp_unidade_medida').AsString := xFbQueryImport.FieldByName('UNIDADEMEDIDA').AsString;

    xFdQueryProdutoInsert.ExecSQL;

    xFdQueryProdutoInsert.Close;
    xFdQueryProdutoInsert.SQL.Clear;

    xFbQuerySeqProduto.Close;
    xFbQuerySeqProduto.SQL.Clear;

    xFbQueryImport.Next;
  end;
  DM.DtProduto.Refresh;

  FreeAndNil(xFdQueryProdutoInsert);
  FreeAndNil(xFbQuerySeqProduto);
  FreeAndNil(xFbQueryImport);
end;

procedure TFProduto.DsProdutoStateChange(Sender: TObject);
begin
  if DsProduto.State = dsInsert then
  begin
    FdqSequencia.Open;
    dm.DtProdutocod_produto.ReadOnly := False;
    DsProduto.DataSet.FieldByName('cod_produto').AsInteger := FdqSequencia.FieldByName('cod_produto').AsInteger;
    dm.DtProdutocod_produto.ReadOnly := True;
    FdqSequencia.close;
  end;
end;

end.
