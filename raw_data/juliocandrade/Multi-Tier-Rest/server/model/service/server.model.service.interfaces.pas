unit server.model.service.interfaces;
interface
uses
  server.model.entity.consultacep, server.model.entity.pessoa,
  System.Generics.Collections;
type
  iServiceCEP = interface
    ['{DCEEC845-D86B-43E8-BF0C-0222706FD51F}']
    function Code(aValue : String) : iServiceCEP;
    function Execute : iServiceCEP; overload;
    function Execute(aValue : TModelConsultaCEP) : iServiceCEP; overload;
    function Return : String;
  end;
  iServiceEndereco = interface
    ['{0A226BAF-1F8F-4CCE-80BD-9F005F377DB5}']
    procedure AtualizarEnderecos;
  end;
  iServicePessoa = interface
    ['{429E5690-B349-4F71-9B05-46581E943253}']
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
  iServiceFactory = interface
    ['{6C666B35-13E3-413F-B7C1-C9A2914D1000}']
    function CEP : iServiceCEP;
    function Endereco : iServiceEndereco;
    function Pessoa : iServicePessoa;
  end;
implementation
end.
