unit Controle.Caixa.Controller.Manager;

interface

uses
  Controle.Caixa.Controller.Manager.Interfaces,
  DTO.Caixa,
  DTO.Usuario,
  Manager.Caixa,
  Manager.Usuario,
  Manager.Interfaces;

type
  TControllerManager = class(TInterfacedObject, iControllerManager)
  private
    FManagerCaixa: iManager<TCaixa>;
    FManagerUsuario: iManager<TUsuario>;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iControllerManager;
    function Caixa: iManager<TCaixa>;
    function Usuario: iManager<TUsuario>;
  end;

implementation

{ TControllerManager }

function TControllerManager.Caixa: iManager<TCaixa>;
begin
  if not Assigned(FManagerCaixa) then
    FManagerCaixa := TManagerCaixa.New;
  Result := FManagerCaixa;
end;

constructor TControllerManager.Create;
begin

end;

destructor TControllerManager.Destroy;
begin

  inherited;
end;

class function TControllerManager.New: iControllerManager;
begin
  Result := Self.Create;
end;

function TControllerManager.Usuario: iManager<TUsuario>;
begin
  if not Assigned(FManagerUsuario) then
    FManagerUsuario := TManagerUsuario.New;
  Result := FManagerUsuario;
end;

end.
