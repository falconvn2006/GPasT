unit tlconsul;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.ExtCtrls, Data.DB, Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  Tfmrentrada = class(TForm)
    adcpro: TLabel;
    lblcodigo: TLabel;
    lblqnt: TLabel;
    btnins: TButton;
    btncan: TButton;
    edtcod: TDBEdit;
    edtqnd: TDBEdit;
    Shape1: TShape;
    ADOConnection1: TADOConnection;
    ADOQueryentrada: TADOQuery;
    DataSourceentrada: TDataSource;
    DBGrid2: TDBGrid;
    ADOQueryprodutoatualiza: TADOQuery;
    btnCadastrar: TButton;
    btnsalvar: TButton;
    ADOQueryentradaid_entrada: TAutoIncField;
    ADOQueryentradacod_entradaproduto: TIntegerField;
    ADOQueryentradaqtd_entrada: TIntegerField;
    ADOQueryprodutoatualizaid_produto: TAutoIncField;
    ADOQueryprodutoatualizacod_produto: TIntegerField;
    ADOQueryprodutoatualizadesc_produto: TStringField;
    ADOQueryprodutoatualizamarca: TStringField;
    ADOQueryprodutoatualizaquantidade: TIntegerField;
    ADOQueryprodutoatualizapreco_compra: TFloatField;
    ADOQueryprodutoatualizapreco_venda: TFloatField;
    ADOQueryprodutoatualizafornecedor: TStringField;
    ADOQueryentradadesc_produto: TStringField;
    Label2: TLabel;
    edtdescproduto: TEdit;
    GroupBox1: TGroupBox;
    FDMemTable1: TFDMemTable;
    FDMemTable1id_entrada: TFDAutoIncField;
    FDMemTable1cod_entradaproduto: TIntegerField;
    FDMemTable1qtd_entrada: TIntegerField;
    FDMemTable1desc_produto: TStringField;
    DataSource5: TDataSource;
    DBGrid4: TDBGrid;
    ADOQueryproduto: TADOQuery;
    ADOQueryprodutoid_produto: TAutoIncField;
    ADOQueryprodutocod_produto: TIntegerField;
    ADOQueryprodutodesc_produto: TStringField;
    ADOQueryprodutomarca: TStringField;
    ADOQueryprodutoquantidade: TIntegerField;
    ADOQueryprodutopreco_compra: TFloatField;
    ADOQueryprodutopreco_venda: TFloatField;
    ADOQueryprodutofornecedor: TStringField;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    DBNavigator1: TDBNavigator;
    procedure btncanClick(Sender: TObject);
    procedure btnCadastrarClick(Sender: TObject);
    procedure edtcodChange(Sender: TObject);
    procedure btninsClick(Sender: TObject);
    procedure btnsalvarClick(Sender: TObject);
  private
    procedure botoes;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmrentrada: Tfmrentrada;

implementation

{$R *.dfm}

procedure Tfmrentrada.botoes;
begin
  if btnCadastrar.Focused then
  begin
  //botoes
  btncadastrar.Enabled:=false;
  btnins.Enabled:=true;
  btncan.Enabled:=true;
  btnsalvar.Enabled:=false;
  //grid
  edtcod.Enabled:=true;
  edtqnd.Enabled:=true;
  edtcod.SetFocus;
  end
else if (btnins.Focused) or (btncan.Focused) then
  begin
    //botoes
  btncadastrar.Enabled:=true;
  btnins.Enabled:=false;
  btncan.Enabled:=false;
  btnsalvar.Enabled:=true;
  //grid
  edtcod.Enabled:=false;
  edtqnd.Enabled:=false;
  end;
end;
//BOTAO CADASTRAR
procedure Tfmrentrada.btnCadastrarClick(Sender: TObject);
begin
ADOQueryProduto.sql.clear;
ADOQueryProduto.SQL.Add('select * from produto for update');
ADOQueryProduto.Open;

botoes;
edtdescproduto.Clear;
FDMemTable1.Append;
end;
//BOTAO CANCELAR
procedure Tfmrentrada.btncanClick(Sender: TObject);
begin
ADOQueryprodutoatualiza.sql.clear;
FDMemTable1.EmptyDataSet;
botoes;

end;
//BOTAO INSERIR
procedure Tfmrentrada.btninsClick(Sender: TObject);
begin
if edtcod.text = '' then
  begin
   showmessage('Insira o codigo do produto!');
  end
    else if edtqnd.text='' then
    begin
      showmessage('Insira a quantidade!');
    end
    else if edtdescproduto.text='' then
         begin
           showmessage('Produto Invalido!');
         end
            else
            begin
              botoes;
              FDMemTable1desc_produto.value := edtdescproduto.text;
              FDMemTable1.Post;
            end;
end;


//BOTAO SALVAR
procedure Tfmrentrada.btnsalvarClick(Sender: TObject);
begin
botoes;
 FDMemTable1.First;
 if messagedlg('Confirmar Entrada? ',mtConfirmation,[mbYes,mbNo],0)=mrYes then
 begin
   while not FDMemTable1.Eof do
   begin
    if ADOQueryproduto.locate('cod_produto', dbgrid4.Fields[1].value,[]) then

      begin
      ADOQueryproduto.edit;
      ADOQueryprodutoquantidade.value := ADOQueryprodutoquantidade.AsInteger + fdmemtable1qtd_entrada.AsInteger;
      ADOQueryproduto.Post;

      ADOQueryentrada.Append;
      ADOQueryentradacod_entradaproduto.value := FDMemTable1cod_entradaproduto.value;
      ADOQueryentradaqtd_entrada.value := FDMemTable1qtd_entrada.value;
      ADOQueryentradadesc_produto.value := FDMemTable1desc_produto.value;
      ADOQueryentrada.Post;

      FDMemTable1.Next;
      end;
   end;
 end
 else
 abort;
 FDMemTable1.EmptyDataSet;
end;

//codigo para puxar o nome do produto sozinho
procedure Tfmrentrada.edtcodChange(Sender: TObject);
begin
  try
  ADOQueryprodutoatualiza.sql.clear;
  ADOQueryprodutoatualiza.SQL.Add('select * from produto where cod_produto='''+edtcod.text+'''');
  ADOQueryprodutoatualiza.Open;

  except

  end;
  edtdescproduto.Text:=ADOQueryprodutoatualiza.FieldByName('desc_produto').AsString;
end;


end.
