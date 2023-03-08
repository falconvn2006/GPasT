unit Providers.Cadastro;

interface

uses
  System.SysUtils, System.Classes, Providers.Connection, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.JSON, FireDAC.VCLUI.Wait, Horse;

type
  TProvidersCadastro = class(TProvidersConnection)
    vQryPesquisa: TFDQuery;
    vQryRecords: TFDQuery;
    vQryCadastro: TFDQuery;
    vQryRecordsCOUNT: TLargeintField;
  private
    { Private declarations }
  public
    constructor Create; reintroduce;
    function Append(const AJson: TJSONObject): boolean; virtual;
    function Update(const AJson: TJSONObject): boolean; virtual;
    function Delete: boolean; virtual;
    function ListAll(const AParams: THorseCoreParam): TFDQuery; virtual;
    function GetById(const AId: string): TFDQuery; virtual;
    function GetRecordCount: Int64; virtual;
  end;

var
  ProvidersCadastro: TProvidersCadastro;

implementation

uses
  DataSet.Serialize;

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

{ TProvidersCadastro }

function TProvidersCadastro.Append(const AJson: TJSONObject): boolean;
begin
  vQryCadastro.SQL.Add(' WHERE 1 <> 1 ');
  vQryCadastro.Open();
  vQryCadastro.LoadFromJSON(AJson, False);
  Result := vQryCadastro.ApplyUpdates(0) = 0;
end;

constructor TProvidersCadastro.Create;
begin
  inherited Create(nil);
end;

function TProvidersCadastro.Delete: boolean;
begin
  vQryCadastro.Delete;
  Result := vQryCadastro.ApplyUpdates(0) = 0;
end;

function TProvidersCadastro.GetById(const AId: string): TFDQuery;
begin
  vQryCadastro.SQL.Add(' WHERE id = :id ');
  vQryCadastro.ParamByName('id').AsLargeInt := AId.ToInt64;
  vQryCadastro.Open();
  Result := vQryCadastro;
end;

function TProvidersCadastro.GetRecordCount: Int64;
begin
  vQryRecords.Open();
  Result := vQryRecordsCOUNT.AsLargeInt;
end;

function TProvidersCadastro.ListAll(
  const AParams: THorseCoreParam): TFDQuery;
begin
  if AParams.ContainsKey('limit') then
  begin
    vQryPesquisa.FetchOptions.RecsMax    := StrToIntDef(AParams.Items['limit'], 50);
    vQryPesquisa.FetchOptions.RowsetSize := StrToIntDef(AParams.Items['limit'], 50);
  end;
  if AParams.ContainsKey('offset') then
    vQryPesquisa.FetchOptions.RecsSkip := StrToIntDef(AParams.Items['offset'], 50);

  vQryPesquisa.Open();
  Result := vQryPesquisa;
end;

function TProvidersCadastro.Update(const AJson: TJSONObject): boolean;
begin
  vQryCadastro.MergeFromJSONObject(AJson, False);
  Result := vQryCadastro.ApplyUpdates(0) = 0;
end;

end.
