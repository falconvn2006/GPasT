unit DAO.EntidadeFactory;

interface

uses
  DAO.Conexao, DAO.Entidade;

type
  TEntidadesFactory = class(TInterfacedObject,IEntidadeFactory)
  private
    FPessoa: IEntidade;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IEntidadeFactory;
    function Pessoa: IEntidade;
  end;


implementation

{ TEntidadesFactory }

constructor TEntidadesFactory.Create;
begin

end;

destructor TEntidadesFactory.Destroy;
begin
  inherited;
end;

class function TEntidadesFactory.New: iEntidadeFactory;
begin
  Result := Self.Create;
end;

function TEntidadesFactory.Pessoa: iEntidade;
begin
  if not Assigned(FPessoa) then
    FPessoa := TEntidadePessoa.New;
  Result := FPessoa;
end;

end.
