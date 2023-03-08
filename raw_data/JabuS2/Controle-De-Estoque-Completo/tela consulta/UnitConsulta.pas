unit UnitConsulta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Data.Win.ADODB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.StorageBin,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  Tfmrconsulta = class(TForm)
    Shape1: TShape;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    Label2: TLabel;
    edtbusca: TEdit;
    btnbusca: TButton;
    DataSourceBProduto: TDataSource;
    ADOConnection1: TADOConnection;
    Edit1: TEdit;
    Label3: TLabel;
    ADOQueryBProduto: TADOQuery;
    ADOQueryBProdutoid_produto: TAutoIncField;
    ADOQueryBProdutocod_produto: TIntegerField;
    ADOQueryBProdutodesc_produto: TStringField;
    ADOQueryBProdutomarca: TStringField;
    ADOQueryBProdutoquantidade: TIntegerField;
    ADOQueryBProdutopreco_compra: TFloatField;
    ADOQueryBProdutopreco_venda: TFloatField;
    ADOQueryBProdutofornecedor: TStringField;
    procedure btnbuscaClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmrconsulta: Tfmrconsulta;

implementation

{$R *.dfm}

procedure Tfmrconsulta.btnbuscaClick(Sender: TObject);

  begin
      with ADOQueryBProduto do
      begin
        try
        close;
        sql.clear;
        SQL.Add('select * from produto where cod_produto ='''+edit1.Text+'''');
        //ADOQueryBProduto.sql.Add('select * from produto where cod_produto = :pcod');
        //parameters.ParamByName('pcod').value := strtoint(edtbusca.Text);
        open;
        except
          close;
          sql.clear;
          SQL.Add('select * from produto where desc_produto LIKE ''%'+edtbusca.Text+'%''');

          open;
        end;
        if edtbusca.Text <> '' then
          begin
          close;
          sql.clear;
          SQL.Add('select * from produto where desc_produto LIKE ''%'+edtbusca.Text+'%''');

          open;
          end;
      end;
  end;


end.
