unit client.model.service.pessoa;

interface
uses
  client.model.service.interfaces,
  client.model.dao.interfaces,
  client.model.entity.pessoa, System.Generics.Collections;
type
  TServicePessoa = class(TInterfacedObject, iServicePessoa)
  private
    FEntity : TModelPessoa;
    FDAOPessoa : iDAOPessoa;
    FList : TList<TModelPessoa>;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iServicePessoa;
    function Inserir : iServicePessoa;
    function Excluir : iServicePessoa;
    function Alterar : iServicePessoa;
    function Entity(aPessoa : TModelPessoa) : iServicePessoa;
    function List(aList : TEnumerable<TModelPessoa>) : iServicePessoa;
    function InserirLote : iServicePessoa;
  end;
implementation

uses
  client.model.dao.Factory;

{ TServicePessoa }

function TServicePessoa.Alterar: iServicePessoa;
begin
  Result := Self;
  FDAOPessoa.Alterar(FEntity);
end;

constructor TServicePessoa.Create;
begin
  FDAOPessoa := TDAOFactory.New.Pessoa;
end;

destructor TServicePessoa.Destroy;
begin
  if Assigned(Flist) then
    FList.Free;
  inherited;
end;

function TServicePessoa.Entity(aPessoa: TModelPessoa): iServicePessoa;
begin
  Result := Self;
  FEntity := aPessoa;
end;

function TServicePessoa.Excluir: iServicePessoa;
begin
  Result := Self;
  FDAOPessoa.Excluir(FEntity.ID);
end;

function TServicePessoa.Inserir: iServicePessoa;
begin
  Result := Self;
  FDAOPessoa.Inserir(FEntity);
end;

function TServicePessoa.InserirLote: iServicePessoa;
begin
  Result := Self;
  FList.Sort;
  FDAOPessoa.InserirLote(FList);
end;

function TServicePessoa.List(aList: TEnumerable<TModelPessoa>): iServicePessoa;
begin
  Result := Self;
  FList := TList<TModelPessoa>.Create(aList);
end;

class function TServicePessoa.New: iServicePessoa;
begin
  Result := Self.Create;
end;

end.
