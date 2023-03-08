unit DAO.Conexao;

interface

uses
  Data.DB;

type
  IQuery = interface;

  IConexao = interface
    function Connection: TObject;
  end;

  IConexaoFactory = interface
    function Conexao: IConexao;
    function Query: IQuery;
  end;

  IQuery = interface
    function Query: TObject;
    function Open(aSQL: String): IQuery;
    function ExecSQL(aSQL: String): IQuery;
  end;

  IEntidade = interface
    function DataSet(aValue: TDataSource): IEntidade;
    procedure Open;
    procedure ExecSQL(aSQL: String);
  end;

  IEntidadeFactory = interface
    function Pessoa: IEntidade;
  end;

implementation

end.
