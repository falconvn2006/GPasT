unit client.model.dao.interfaces;

interface

uses
  client.model.entity.pessoa,
  System.Generics.Collections;
type
  iDAOPessoa = interface
    ['{E4655AA5-C4B1-4B5B-B466-B5D538D81A81}']
    function Inserir(aPessoa :TModelPessoa) : iDAOPessoa;
    function Excluir(aID : Int64) : iDaoPessoa;
    function Alterar(aPessoa :TModelPessoa) : iDaoPessoa;
    function InserirLote(aList: TList<TModelPessoa>) : iDAOPessoa;
  end;
  iDAOPessoaLote = interface
    ['{8C6EBDCA-A79D-48F6-B00A-E2966F61FCF5}']
    function Inserir : iDAOPessoaLote;
  end;

  iDAOFactory = interface
    ['{27E33AFD-BD5D-4AD7-87AC-98DCDFE857B9}']
    function Pessoa : IDAOPessoa;
  end;
implementation

end.
