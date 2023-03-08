unit Config.Service.Interfaces;

interface

uses
  System.Classes, System.SysUtils,

  XData.Service.Common,

  Config.DTO;

type
  [ServiceContract]
  [URIPath('config')]
  IConfigService = interface(IInvokable)
    ['{7FA1A880-E068-4A41-9C21-88E25FBCF0D4}']
    [HttpGet, URIPath('emitente')]
    function Emitente: TConfigEmitenteDTO;
    [HttpGet, URIPath('ambiente')]
    function Ambiente: TConfigAmbienteDTO;
  end;

implementation

initialization
  RegisterServiceType(TypeInfo(IConfigService));

end.
