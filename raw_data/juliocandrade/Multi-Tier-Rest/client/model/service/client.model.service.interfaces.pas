unit client.model.service.interfaces;

interface

uses
  client.model.entity.pessoa,
  System.Generics.Collections;
type
  iServicePessoa = interface
    ['{237B82CF-84E6-4D00-B2E3-82166E1A9973}']
    function Inserir : iServicePessoa;
    function Excluir : iServicePessoa;
    function Alterar : iServicePessoa;
    function Entity(aPessoa : TModelPessoa) : iServicePessoa;
    function List(aList : TEnumerable<TModelPessoa>) : iServicePessoa;
    function InserirLote : iServicePessoa;
  end;
implementation

end.
