unit server.controller.interfaces;

interface

uses
  System.JSON,
  server.model.service.interfaces;

type
  iPessoa = interface
    ['{AB6D2D3D-A617-4A8E-B356-A94433B084BB}']
    function Services : iServicePessoa;
    function JsonStringToObject(Value : String) : iPessoa;
    function JsonArrayStringToList(Value : String) : iPessoa;
  end;

  iController = interface
    ['{9602C436-30AD-414D-B325-74DADB6131BD}']
    function Pessoa : iPessoa;
  end;
implementation

end.
