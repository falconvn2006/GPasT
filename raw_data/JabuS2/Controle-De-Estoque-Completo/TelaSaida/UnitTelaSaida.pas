unit UnitTelaSaida;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.ExtCtrls, Data.DB, Data.Win.ADODB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageBin;

type
  Tfmrsaida = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    dbCodPro: TDBEdit;
    dbQtdSaida: TDBEdit;
    edtdescpro: TEdit;
    Label2: TLabel;
    ADOConnection1: TADOConnection;
    ADOQuerysaida: TADOQuery;
    DataSourcesaida: TDataSource;
    ADOQuerysaidaid_saida: TAutoIncField;
    ADOQuerysaidacod_saidaproduto: TIntegerField;
    ADOQuerysaidaqtd_saida: TIntegerField;
    ADOQuerysaidadesc_produto: TStringField;
    ADOQuerysaidafilial: TStringField;
    Label1: TLabel;
    DBComboBox1: TDBComboBox;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Shape1: TShape;
    GroupBox1: TGroupBox;
    btncadastrar: TButton;
    btnins: TButton;
    btncan: TButton;
    btnsalvar: TButton;
    FDMemTable1: TFDMemTable;
    DataSource2: TDataSource;
    FDMemTable1id_saida: TFDAutoIncField;
    FDMemTable1cod_saidaproduto: TIntegerField;
    FDMemTable1qtd_saida: TIntegerField;
    FDMemTable1desc_produto: TStringField;
    FDMemTable1filial: TStringField;
    ADOQueryprodutoAtualiza: TADOQuery;
    ADOQueryProduto: TADOQuery;
    ADOQueryProdutoid_produto: TAutoIncField;
    ADOQueryProdutocod_produto: TIntegerField;
    ADOQueryProdutodesc_produto: TStringField;
    ADOQueryProdutomarca: TStringField;
    ADOQueryProdutoquantidade: TIntegerField;
    ADOQueryProdutopreco_compra: TFloatField;
    ADOQueryProdutopreco_venda: TFloatField;
    ADOQueryProdutofornecedor: TStringField;
    ADOQueryprodutoAtualizaid_produto: TAutoIncField;
    ADOQueryprodutoAtualizacod_produto: TIntegerField;
    ADOQueryprodutoAtualizadesc_produto: TStringField;
    ADOQueryprodutoAtualizamarca: TStringField;
    ADOQueryprodutoAtualizaquantidade: TIntegerField;
    ADOQueryprodutoAtualizapreco_compra: TFloatField;
    ADOQueryprodutoAtualizapreco_venda: TFloatField;
    ADOQueryprodutoAtualizafornecedor: TStringField;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    DBNavigator1: TDBNavigator;
    procedure dbCodProChange(Sender: TObject);
    procedure btnCadastrarClick(Sender: TObject);
    procedure btninsClick(Sender: TObject);
    procedure btncanClick(Sender: TObject);
    procedure btnsalvarClick(Sender: TObject);
    procedure dbQtdSaidaChange(Sender: TObject);
    procedure btninsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
  procedure botoes;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmrsaida: Tfmrsaida;

implementation

{$R *.dfm}

procedure Tfmrsaida.botoes;
begin
  if btnCadastrar.Focused then
  begin
  //botoes
  btncadastrar.Enabled:=false;
  btnins.Enabled:=true;
  btncan.Enabled:=true;
  btnsalvar.Enabled:=false;
  //grid
  dbCodPro.Enabled:=true;
  dbQtdSaida.Enabled:=true;
  DBComboBox1.Enabled:=true;
  dbCodPro.SetFocus;
  end
else if (btnins.Focused) or (btncan.Focused) then
  begin
    //botoes
  btncadastrar.Enabled:=true;
  btnins.Enabled:=false;
  btncan.Enabled:=false;
  btnsalvar.Enabled:=true;
  //grid
  dbCodPro.Enabled:=false;
  dbQtdSaida.Enabled:=false;
  DBComboBox1.Enabled:=false;
  end;
end;

//cadastrar
procedure Tfmrsaida.btnCadastrarClick(Sender: TObject);
begin
ADOQueryProduto.sql.clear;
ADOQueryProduto.SQL.Add('select * from produto for update');
ADOQueryProduto.Open;
botoes;
edtdescpro.Clear;
FDMemTable1.Append;
end;
//cancelar
procedure Tfmrsaida.btncanClick(Sender: TObject);
begin
FDMemTable1.EmptyDataSet;
botoes;
end;

//inserir
procedure Tfmrsaida.btninsClick(Sender: TObject);
begin
if dbCodPro.text = '' then
  begin
   showmessage('Insira o codigo do produto!');
  end
    else if dbQtdSaida.text='' then
    begin
      showmessage('Insira a quantidade!');
    end
    else if edtdescpro.text='' then
         begin
           showmessage('Produto Invalido!');
         end
            else
            begin
              botoes;
              FDMemTable1desc_produto.value := edtdescpro.text;
              FDMemTable1filial.value:=DBComboBox1.text;
              FDMemTable1.Post;
            end;
end;
procedure Tfmrsaida.btninsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if KEY = VK_TAB then

end;

//salvar
procedure Tfmrsaida.btnsalvarClick(Sender: TObject);
begin
botoes;
 FDMemTable1.First;
     if messagedlg('Confirmar Saida? ',mtConfirmation,[mbYes,mbNo],0)=mrYes then
     begin
       while not FDMemTable1.Eof do
       begin
        if ADOQueryProduto.locate('cod_produto', dbgrid2.Fields[1].value,[]) then
        begin

              ADOQueryProduto.edit;
              ADOQueryProdutoquantidade.value := ADOQueryProdutoquantidade.AsInteger - fdmemtable1qtd_saida.AsInteger;
              ADOQueryProduto.Post;

              ADOQuerysaida.Append;
              ADOQuerysaidacod_saidaproduto.value := FDMemTable1cod_saidaproduto.value;
              ADOQuerysaidaqtd_saida.value := FDMemTable1qtd_saida.value;
              ADOQuerysaidadesc_produto.value := FDMemTable1desc_produto.value;
              ADOQuerysaidafilial.value := FDMemTable1filial.value;
              ADOQuerysaida.Post;

              FDMemTable1.Next;

        end;
       end;
     end
     else
     abort;

     FDMemTable1.EmptyDataSet;
end;


procedure Tfmrsaida.dbCodProChange(Sender: TObject);
  begin
  try
  ADOQueryprodutoAtualiza.sql.clear;
  ADOQueryprodutoAtualiza.SQL.Add('select * from produto where cod_produto='''+dbCodPro.text+'''');
  //ADOQueryprodutoatualiza.sql.Add('select * from produto where cod_produto = :pcod');
  //ADOQueryprodutoatualiza.parameters.ParamByName('pcod').value := strtoint(dbCodPro.text);
  ADOQueryprodutoAtualiza.Open;

  except

  end;
  edtdescpro.Text:=ADOQueryprodutoAtualiza.FieldByName('desc_produto').AsString
end;

procedure Tfmrsaida.dbQtdSaidaChange(Sender: TObject);
begin

  if dbQtdSaida.text > ADOQueryProduto.FieldByName('quantidade').AsString then
    begin
      showmessage('Estoque Invalido');
      dbQtdSaida.text := '';
    end;

end;


end.
