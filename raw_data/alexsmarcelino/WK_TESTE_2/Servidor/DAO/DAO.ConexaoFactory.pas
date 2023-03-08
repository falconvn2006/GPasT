unit DAO.ConexaoFactory;

interface

uses
  DAO.Conexao, DAO.ConFiredDAC, DAO.Query;

type
  TConexaoFactory = class(TInterfacedObject,IConexaoFactory)
  private
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IConexaoFactory;
    function Conexao: IConexao;
    function Query: IQuery;
  end;

implementation

{ TConexaoFactory }

function TConexaoFactory.Conexao: IConexao;
begin
  Result := TFireDacConexao.New;
end;

constructor TConexaoFactory.Create;
begin

end;

destructor TConexaoFactory.Destroy;
begin
  inherited;
end;

class function TConexaoFactory.New: IConexaoFactory;
begin
  Result := Self.Create;
end;

function TConexaoFactory.Query: IQuery;
begin
  Result := TFireDacQuery.New(Self.Conexao);
end;

end.
