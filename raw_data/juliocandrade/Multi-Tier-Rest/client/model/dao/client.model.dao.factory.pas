unit client.model.dao.factory;

interface

uses
  client.model.dao.Interfaces,
  client.model.entity.pessoa,
  System.Generics.Collections;
type
  TDAOFactory = class(TInterfacedObject, iDAOFactory)
  private
  public
    class function New : iDAOFactory;
    function Pessoa : IDAOPessoa;
  end;
implementation

uses
  client.model.dao.pessoa;

{ TDAOFactory }

class function TDAOFactory.New : iDAOFactory;
begin
  Result := Self.Create;
end;

function TDAOFactory.Pessoa : IDAOPessoa;
begin
  Result := TDAOPessoa.New;
end;

end.
