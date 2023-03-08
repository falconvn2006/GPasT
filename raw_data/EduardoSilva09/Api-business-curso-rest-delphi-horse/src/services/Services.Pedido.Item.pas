unit Services.Pedido.Item;

interface

uses
  System.SysUtils, System.Classes, Providers.Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.JSON, FireDAC.VCLUI.Wait,
  Horse;

type
  TServicePedidoItem = class(TProvidersCadastro)
    vQryPesquisaid: TLargeintField;
    vQryPesquisaid_produto: TLargeintField;
    vQryPesquisaquantidade: TFMTBCDField;
    vQryPesquisavalor: TFMTBCDField;
    vQryPesquisanome_produto: TWideStringField;
    vQryCadastroid: TLargeintField;
    vQryCadastroid_pedido: TLargeintField;
    vQryCadastroid_produto: TLargeintField;
    vQryCadastroquantidade: TFMTBCDField;
    vQryCadastrovalor: TFMTBCDField;
    vQryCadastronome_produto: TWideStringField;
  private
    { Private declarations }
  public
    function ListAllByIdPedido(const AParams: THorseCoreParam; const AIdPedido: string): TFDQuery;
    function Append(const AJson: TJSONObject): boolean; override;
    function GetByPedido(const AIdPedido, AIdItem: string): TFDQuery;
  end;

var
  ServicePedidoItem: TServicePedidoItem;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TServicePedidoItem }

function TServicePedidoItem.Append(const AJson: TJSONObject): boolean;
begin
  Result := inherited Append(AJson);
  vQryCadastroid_pedido.Visible := False;
end;

function TServicePedidoItem.GetByPedido(const AIdPedido, AIdItem: string): TFDQuery;
begin
  vQryCadastroid_pedido.Visible := False;
  vQryCadastro.SQL.Add('WHERE i.id = :id');
  vQryCadastro.SQL.Add(' AND i.id_pedido = :id_pedido');
  vQryCadastro.ParamByName('id').AsLargeInt := AIdItem.ToInt64;
  vQryCadastro.ParamByName('id_pedido').AsLargeInt := AIdPedido.ToInt64;
  vQryCadastro.Open();
  Result := vQryCadastro;
end;

function TServicePedidoItem.ListAllByIdPedido(const AParams: THorseCoreParam;
  const AIdPedido: string): TFDQuery;
begin
  vQryPesquisa.ParamByName('id_pedido').AsLargeInt := AIdPedido.ToInt64;
  vQryRecords.ParamByName('id_pedido').AsLargeInt := AIdPedido.ToInt64;

  Result := inherited ListAll(AParams);
end;

end.
