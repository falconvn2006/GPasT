unit server.model.dao.factory;

interface

uses
  server.model.dao.interfaces,
  server.model.entity.pessoa,
  System.Generics.Collections,
  server.model.entity.endereco,
  server.model.entity.endereco.integracao;
type
  TDAOFactory = class (TInterfacedObject, iDAOFactory)
  private
  public
    class function New : iDAOFactory;
    function Pessoa : iDAOPessoa;
    function PessoaLote(aList : TObjectList<TModelPessoa>) : iDAOPessoaLote;
    function Endereco(aEndereco : TModelEndereco) : iDAOEndereco;
    function EnderecoIntegracao(aEnderecoIntegracao : TModelEnderecoIntegracao) : iDAOEnderecoIntegracao;
  end;
implementation

uses
  server.model.dao.endereco,
  server.model.dao.endereco.integracao,
  server.model.dao.pessoa,
  server.model.dao.pessoa.lote;

{ TDAOFactory }

function TDAOFactory.Endereco(aEndereco : TModelEndereco) : iDAOEndereco;
begin
  Result := TDAOEndereco.New(aEndereco)
end;

function TDAOFactory.EnderecoIntegracao(aEnderecoIntegracao : TModelEnderecoIntegracao) : iDAOEnderecoIntegracao;
begin
  Result := TDAOEnderecoIntegracao.New(aEnderecoIntegracao);
end;

class function TDAOFactory.New: iDAOFactory;
begin
  Result := Self.Create;
end;

function TDAOFactory.Pessoa : iDAOPessoa;
begin
  Result := TDAOPessoa.New;
end;

function TDAOFactory.PessoaLote(aList : TObjectList<TModelPessoa>) : iDAOPessoaLote;
begin
  Result := TDAOPessoaLote.New(aList);
end;

end.
