unit server.model.service.pessoa;

interface
uses
  server.model.service.interfaces, server.model.entity.pessoa,
  server.model.dao.interfaces, System.Generics.Collections;

type
  TServicePessoa = class(TInterfacedObject, iServicePessoa)
  private
    FEntity : TModelPessoa;
    FDAOPessoa : iDAOPessoa;
    FList : TObjectList<TModelPessoa>;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iServicePessoa;
    function ListarTodos : iservicePessoa;
    function ListarPorID(ID : Int64) : iservicePessoa;
    function Inserir : iServicePessoa;
    function Excluir : iServicePessoa;
    function Alterar : iServicePessoa;
    function Entity(aPessoa : TModelPessoa) : iServicePessoa;
    function List(aList : TObjectList<TModelPessoa>) : iServicePessoa;
    function InserirLote : iServicePessoa;
    function ListAsJSONArray : String;
    function EntityAsJSONObject : string;
    function IsEmpty : Boolean;

  end;
implementation

uses
  server.model.dao.factory, REST.Json, System.JSON;

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

  inherited;
end;

function TServicePessoa.Entity(aPessoa: TModelPessoa): iServicePessoa;
begin
  Result := Self;
  FEntity := aPessoa;
end;

function TServicePessoa.EntityAsJSONObject: string;
begin
  Result := TJSON.ObjectToJsonString(FDAOPessoa.List.Items[0], [joIndentCaseLower]);
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
  TDAOFactory.New.PessoaLote(FList).Inserir;
end;

function TServicePessoa.IsEmpty: Boolean;
begin
  Result := FDAOPessoa.isEmpty;
end;

function TServicePessoa.List(aList: TObjectList<TModelPessoa>): iServicePessoa;
begin
  Result := Self;
  FList := aList;
end;

function TServicePessoa.ListarPorID(ID: Int64): iservicePessoa;
begin
  Result := Self;
  FEntity.ID := ID;
  FDAOPessoa.ListarPorID(FEntity);
end;

function TServicePessoa.ListarTodos: iservicePessoa;
begin
  Result := Self;
  FDAOPessoa.ListarTodos;
end;

function TServicePessoa.ListAsJSONArray: String;
var
  LJSONArray : TJSONArray;
  LJSONObject : TJSONObject;
begin
  Result := '[]';
  LJSONObject := TJson.ObjectToJsonObject(FDAOPessoa.List, [joIndentCaseLower]);
  try
    LJSONArray := LJSONObject.GetValue<TJSONArray>('listhelper');
    Result := TJSON.JsonEncode(LJSONArray);
  finally
    LJSONObject.Free;
  end;
end;

class function TServicePessoa.New: iServicePessoa;
begin
  Result := Self.Create;
end;

end.
