unit Controle.Caixa.Controller.Manager.Interfaces;

interface

uses
  Manager.Interfaces,
  DTO.Caixa,
  DTO.Usuario;

type
  iControllerManager = Interface
    ['{B240267A-72C8-42F0-9A76-E0C88EA8743C}']
    function Caixa: iManager<TCaixa>;
    function Usuario: iManager<TUsuario>;
  End;

implementation

end.
