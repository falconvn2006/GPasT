unit server.controller.pessoa;

interface

uses
  server.controller.interfaces,
  server.model.service.interfaces,
  server.model.entity.pessoa,
  System.JSON,
  System.Generics.Collections;
type
  TPessoa = class(TInterfacedObject, iPessoa)
  private
    FEntity : TModelPessoa;
    FList : TObjectList<TModelPessoa>;
    FServices : iServicePessoa;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iPessoa;
    function Services : iServicePessoa;
    function JsonStringToObject(Value : String) : iPessoa;
    function JsonArrayStringToList(Value : String) : iPessoa;
  end;
implementation

uses
  REST.Json, server.model.service.factory;

{ TPessoa }

constructor TPessoa.Create;
begin
  FEntity := TModelPessoa.Create;
  FList := TObjectList<TModelPessoa>.Create;
  FServices := TServiceFactory.New.Pessoa;
end;

destructor TPessoa.Destroy;
begin
  FEntity.Free;
  FList.Free;
  inherited;
end;

function TPessoa.JsonArrayStringToList(Value: String): iPessoa;
var
  LJSONArray : TJSONArray;
  I: Integer;
  LPessoa : TModelPessoa;
begin
  Result := Self;
  FList.Clear;
  LJSONArray := TJSONOBject.ParseJSONValue(Value) as TJSONArray;
  try
    for I := 0 to Pred(LJSONArray.Count) do
    begin
      LPessoa := TModelPessoa.Create;
      TJSON.JsonToObject(LPessoa, TJSONObject(LJSONArray.Items[I]));
      FList.add(LPessoa);
    end;
  finally
    LJSONArray.Free;
  end;
end;

function TPessoa.JsonStringToObject(Value : String): iPessoa;
var
  LJSONPessoa : TJSONObject;
begin
  Result := Self;
  LJSONPessoa := TJSONObject.ParseJSONValue(Value) as TJSONObject;
  try
    TJSON.JsonToObject(FEntity, LJSONPessoa);
  finally
    LJSONPessoa.Free;
  end;
end;

class function TPessoa.New: iPessoa;
begin
  Result := Self.Create;
end;

function TPessoa.Services: iServicePessoa;
begin
  Result := FServices.Entity(FEntity).List(FList);
end;

end.
