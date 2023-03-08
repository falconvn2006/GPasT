unit client.controller.factory;

interface

uses
  client.controller.interfaces;
type
  TController = class(TInterfacedObject, iController)
  private
    FPessoa : iPessoa;
  public
    class function New : iController;
    function Pessoa : iPessoa;
  end;
implementation

uses
  client.controller.pessoa;

{ TController }

class function TController.New: iController;
begin
  Result := Self.Create;
end;

function TController.Pessoa: iPessoa;
begin
  if not Assigned(FPessoa) then
    FPessoa := TPessoa.New;
  Result := FPessoa;
end;

end.
