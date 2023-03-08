unit Services.Pedido;

interface

uses
  System.SysUtils, System.Classes, Providers.Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Horse;

type
  TServicePedido = class(TProvidersCadastro)
    vQryPesquisaid: TLargeintField;
    vQryPesquisaid_cliente: TLargeintField;
    vQryPesquisadata: TSQLTimeStampField;
    vQryPesquisanome_cliente: TWideStringField;
    vQryPesquisaid_usuario: TLargeintField;
    vQryCadastroid: TLargeintField;
    vQryCadastroid_cliente: TLargeintField;
    vQryCadastrodata: TSQLTimeStampField;
    vQryCadastronome_cliente: TWideStringField;
    vQryCadastroid_usuario: TLargeintField;
    procedure vQryCadastroAfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
  public
    function GetById(const AId: string): TFDQuery; override;
    function ListAll(const AParams: THorseCoreParam): TFDQuery; override;
  end;

var
  ServicePedido: TServicePedido;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TServicePedido }

function TServicePedido.GetById(const AId: string): TFDQuery;
begin
  vQryCadastro.SQL.Add(' WHERE p.id = :id ');
  vQryCadastro.ParamByName('id').AsLargeInt := AId.ToInt64;
  vQryCadastro.Open();
  Result := vQryCadastro;
end;

function TServicePedido.ListAll(const AParams: THorseCoreParam): TFDQuery;
begin
  if AParams.ContainsKey('id') then
  begin
    vQryPesquisa.SQL.Add('and p.id = :id');
    vQryPesquisa.ParamByName('id').AsLargeInt := AParams.Items['id'].ToInt64;
    vQryRecords.SQL.Add('and p.id = :id');
    vQryRecords.ParamByName('id').AsLargeInt := AParams.Items['id'].ToInt64;
  end;

  if AParams.ContainsKey('idCliente') then
  begin
    vQryPesquisa.SQL.Add('and p.id_cliente = :idCliente');
    vQryPesquisa.ParamByName('idCliente').AsLargeInt := AParams.Items['idCliente'].ToInt64;
    vQryRecords.SQL.Add('and p.id_cliente = :idCliente');
    vQryRecords.ParamByName('idCliente').AsLargeInt := AParams.Items['idCliente'].ToInt64;
  end;

  if AParams.ContainsKey('idUsuario') then
  begin
    vQryPesquisa.SQL.Add('and p.id_usuario = :idUsuario');
    vQryPesquisa.ParamByName('idUsuario').AsLargeInt := AParams.Items['idUsuario'].ToInt64;
    vQryRecords.SQL.Add('and p.id_usuario = :idUsuario');
    vQryRecords.ParamByName('idUsuario').AsLargeInt := AParams.Items['idUsuario'].ToInt64;
  end;

  if AParams.ContainsKey('nome') then
  begin
    vQryPesquisa.SQL.Add('and lower(c.nome) like :nome');
    vQryPesquisa.ParamByName('nome').AsString := '%' + AParams.Items['nome']
      .ToLower + '%';

    vQryRecords.SQL.Add('and lower(c.nome) like :nome');
    vQryRecords.ParamByName('nome').AsString := '%' + AParams.Items['nome']
      .ToLower + '%';
  end;

  vQryCadastro.SQL.Add(' order by id ');
  Result := inherited ListAll(AParams);
end;

procedure TServicePedido.vQryCadastroAfterInsert(DataSet: TDataSet);
begin
  inherited;
  vQryCadastrodata.AsDateTime := Now;
end;

end.
