unit UDM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSAcc,
  FireDAC.Phys.MSAccDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.PG, FireDAC.Phys.PGDef, Data.DB,
  Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  Tdm = class(TForm)
    ConnectionBalanca: TFDConnection;
    ConnectionPostgres: TFDConnection;
    DtProduto: TFDTable;
    DtProdutocod_produto: TFMTBCDField;
    DtProdutocod_balanca: TFMTBCDField;
    DtProdutonome: TWideStringField;
    DtProdutopreco: TBCDField;
    DtProdutoquantidade: TBCDField;
    DtProdutodescricao: TWideStringField;
    DtEntidade: TFDTable;
    DtEntidadecod_entidade: TFMTBCDField;
    DtEntidadenome: TWideStringField;
    DtEntidadecpf_cnpj: TWideStringField;
    DtEntidadeflg_cliente: TWideStringField;
    DtEntidadeflg_fornecedor: TWideStringField;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    DtProdutotp_unidade_medida: TWideStringField;
    DtProdutocod_barra: TWideStringField;
    DtProdutocod_barra_caixa: TWideStringField;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{$R *.dfm}

procedure Tdm.FormCreate(Sender: TObject);
begin
  ConnectionPostgres.Open;
  DtProduto.Open;
end;

end.
