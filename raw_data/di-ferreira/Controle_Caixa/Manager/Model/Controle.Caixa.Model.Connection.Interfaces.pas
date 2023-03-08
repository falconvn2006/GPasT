unit Controle.Caixa.Model.Connection.Interfaces;

interface

uses
  Data.DB,
  FireDAC.Comp.Client;

type
  iConnection = interface
    ['{42864D76-D1E7-4698-A0AA-40FCF17D60FC}']
    function Connection: TFDConnection;
  end;

implementation

end.
