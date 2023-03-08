unit client.controller.pessoa;

interface

uses
  client.controller.interfaces,
  client.model.service.interfaces,
  client.model.entity.pessoa,
  System.Generics.Collections;
type
  TPessoa = class(TInterfacedObject, iPessoa, iPessoaLista)
  private
    FEntity : TModelPessoa;

    FList : TDictionary<integer,TModelPessoa>;
    FIndiceAtual : Integer;
    procedure InternalLimparLista;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iPessoa;
    function Services : iServicePessoa;
    function Entity : iPessoaDTO<iPessoa>;
    function Lista : iPessoaLista;

    function AdicionarPessoa : integer;
    function RemoverPessoa(aIndex : Integer) : iPessoaLista;
    function LimparLista : iPessoaLista;
    function AtualizarPessoa(aIndex : Integer) : iPessoaLista;
    function &End : iPessoa;
  end;
implementation

uses
  System.SysUtils,
  client.controller.pessoa.dto,
  client.model.service.pessoa;

{ TPessoa }

function TPessoa.&End: iPessoa;
begin
  Result := Self;
end;

function TPessoa.AdicionarPessoa: integer;
begin
  Inc(FIndiceAtual);
  FList.Add(FIndiceAtual, FEntity);
  FEntity := TModelPessoa.Create;
  Result := FIndiceAtual;
end;

function TPessoa.AtualizarPessoa(aIndex: Integer): iPessoaLista;
var
  LPessoa : TModelPessoa;
begin
  if not FList.TryGetValue(aIndex, LPessoa) then
    raise Exception.Create('Índice inválido');
  FList.AddOrSetValue(aIndex, FEntity);
  LPessoa.Free;
  FEntity := TModelPessoa.Create;
end;

constructor TPessoa.Create;
begin
  FEntity := TModelPessoa.Create;
  FIndiceAtual := 0;
  FList := TObjectDictionary<integer, TModelPessoa>.Create;
end;

destructor TPessoa.Destroy;
begin
  FEntity.Free;
  LimparLista;
  FList.Free;
  inherited;
end;

function TPessoa.Entity: iPessoaDTO<iPessoa>;
begin
  Result := TPessoaDTO<iPessoa>.New(Self, FEntity);
end;

procedure TPessoa.InternalLimparLista;
var
  LPessoa : TMOdelPessoa;
begin
  for LPessoa in FList.Values do
    LPessoa.Free;
end;

function TPessoa.LimparLista: iPessoaLista;
begin
  InternalLimparLista;
  FList.Clear;
end;

function TPessoa.Lista: iPessoaLista;
begin
  Result := Self;
end;

class function TPessoa.New: iPessoa;
begin
  Result := Self.Create;
end;

function TPessoa.RemoverPessoa(aIndex: Integer): iPessoaLista;
var
  LPessoa : TModelPessoa;
begin
  Result := Self;
  if not FList.TryGetValue(aIndex, LPessoa) then
    raise Exception.Create('Índice inválido');
  FList.Remove(aIndex);
  LPessoa.Free;
end;

function TPessoa.Services: iServicePessoa;
begin
  Result := TServicePessoa.New
    .Entity(FEntity)
    .List(FList.Values);
end;

end.
