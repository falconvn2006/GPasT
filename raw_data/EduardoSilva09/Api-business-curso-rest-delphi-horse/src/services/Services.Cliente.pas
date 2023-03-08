unit Services.Cliente;

interface

uses
  System.SysUtils, System.Classes, Providers.Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Horse.Core.Param;

type
  TServiceCliente = class(TProvidersCadastro)
    vQryPesquisaid: TLargeintField;
    vQryPesquisanome: TWideStringField;
    vQryPesquisastatus: TSmallintField;
    vQryCadastroid: TLargeintField;
    vQryCadastronome: TWideStringField;
    vQryCadastrostatus: TSmallintField;
  private
    { Private declarations }
  public
    function ListAll(const AParams: THorseCoreParam): TFDQuery; override;
  end;

var
  ServiceCliente: TServiceCliente;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}


{ TServiceCliente }

function TServiceCliente.ListAll(const AParams: THorseCoreParam): TFDQuery;
begin
  if AParams.ContainsKey('nome') then
  begin
    vQryPesquisa.SQL.Add('and lower(nome) like :nome');
    vQryPesquisa.ParamByName('nome').AsString := '%' + AParams.Items['nome']
      .ToLower + '%';

    vQryRecords.SQL.Add('and lower(nome) like :nome');
    vQryRecords.ParamByName('nome').AsString := '%' + AParams.Items['nome']
      .ToLower + '%';
  end;

  if AParams.ContainsKey('status') then
  begin
    vQryPesquisa.SQL.Add('and status = :status');
    vQryPesquisa.ParamByName('status').AsSmallInt := AParams.Items['status']
      .ToInteger;

    vQryRecords.SQL.Add('and status = :status');
    vQryRecords.ParamByName('status').AsSmallInt := AParams.Items['status']
      .ToInteger;
  end;

  vQryCadastro.SQL.Add(' order by id ');
  Result := inherited ListAll(AParams);
end;

end.
