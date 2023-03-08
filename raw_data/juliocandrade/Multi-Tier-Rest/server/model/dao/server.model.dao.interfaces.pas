unit server.model.dao.interfaces;

interface

uses
  server.model.entity.pessoa,
  server.model.entity.endereco,
  server.model.entity.endereco.integracao,
  System.Generics.Collections,
  server.model.resource.interfaces,
  server.utils.generic.iterator;
type

  iDAOPessoa = interface
    ['{1B2A6E29-0718-48A5-BBC5-61BD5CD04E34}']
    function ListarTodos : iDaoPessoa;
    function ListarPorID(aPessoa : TModelPessoa) : iDAOPessoa;
    function Inserir(aPessoa : TModelPessoa) : iDaoPessoa;
    function Excluir(ID : Int64) : iDaoPessoa;
    function Alterar(aPessoa : TModelPessoa) : iDaoPessoa;
    function List : TObjectList<TModelPessoa>;
    function IsEmpty : Boolean;
  end;

  iDAOPessoaLote = interface
    ['{4068650C-595F-4715-996F-E82CEFCE3430}']
    function Inserir : iDaoPessoaLote;
  end;

  iDAOEndereco = interface
    ['{A3BFA938-5529-4FDE-883C-2D9DFC5B2458}']
    function ListarNaoAtualizados : iDAOEndereco;
    function List : iGenericIterator<TModelEndereco>;
    function Inserir : iDAOEndereco; overload;
    function Inserir(aConexao : iConexao) : iDAOEndereco; overload;
    function Alterar : iDAOEndereco; overload;
    function Alterar(aConexao : iConexao) : iDAOEndereco; overload;
    function DatasetToEntity(AEndereco : TModelEndereco; aQuery : iQuery) : iDAOEndereco;
  end;

  iDAOEnderecoIntegracao = interface
    ['{E5170CAD-75BF-44D4-9F74-56B626DE0973}']
    function Inserir : iDAOEnderecoIntegracao; overload;
    function Inserir(aConexao : iConexao) : iDAOEnderecoIntegracao; overload;
    function Alterar : iDAOEnderecoIntegracao; overload;
    function Alterar(aConexao : iConexao) : iDAOEnderecoIntegracao; overload;
    function DatasetToEntity(AEnderecoIntegracao : TModelEnderecoIntegracao; aQuery : iQuery) : iDAOEnderecoIntegracao;
  end;

  iDAOFactory = interface
    ['{FB58FEB4-2A3B-433C-BEE6-79DBB164C19C}']
    function Pessoa : iDAOPessoa;
    function PessoaLote(aList : TObjectList<TModelPessoa>) : iDAOPessoaLote;
    function Endereco(aEndereco : TModelEndereco) : iDAOEndereco;
    function EnderecoIntegracao(aEnderecoIntegracao : TModelEnderecoIntegracao) : iDAOEnderecoIntegracao;
  end;
implementation

end.

