unit server.model.service.factory;

interface

uses
  server.model.service.interfaces;
type
  TServiceFactory = class(TInterfacedObject, iServiceFactory)
  private
  public
    class function New : iServiceFactory;
    function CEP : iServiceCEP;
    function Endereco : iServiceEndereco;
    function Pessoa : iServicePessoa;
  end;
implementation

uses
  server.model.service.cep.viacep,
  server.model.service.endereco,
  server.model.service.pessoa;

{ TServiceFactory }

function TServiceFactory.CEP: iServiceCEP;
begin
  Result := TServiceCEPViaCEP.New;
end;

function TServiceFactory.Endereco: iServiceEndereco;
begin
  Result := TServiceEndereco.New;
end;

class function TServiceFactory.New: iServiceFactory;
begin
  Result := Self.Create;
end;

function TServiceFactory.Pessoa: iServicePessoa;
begin
  Result := TServicePessoa.New;
end;

end.

