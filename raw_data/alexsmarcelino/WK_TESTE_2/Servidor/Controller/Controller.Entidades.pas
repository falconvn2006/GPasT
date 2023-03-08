unit Controller.Entidades;

interface

uses
  Controller, DAO.Conexao, DAO.EntidadeFactory;

type
  TController = class(TInterfacedObject,IController)
  private
    FEntidades: IEntidadeFactory;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iController;
    function Entidades : IEntidadeFactory;
  end;

implementation

{ TController }

constructor TController.Create;
begin
  FEntidades := TEntidadesFactory.New;
end;

destructor TController.Destroy;
begin
  inherited;
end;

function TController.Entidades: IEntidadeFactory;
begin
  Result := FEntidades;
end;

class function TController.New: iController;
begin
  Result := Self.Create;
end;

end.
