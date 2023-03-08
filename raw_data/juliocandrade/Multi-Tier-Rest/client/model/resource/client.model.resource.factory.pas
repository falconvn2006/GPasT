unit client.model.resource.factory;

interface

uses
  client.model.resource.interfaces;
type
  TResourceFactory = class(TInterfacedObject, iServiceFactory)
  private
  public
    class function New : iServiceFactory;
    function Rest : iRest;
  end;
implementation

uses
  client.model.resource.rest.delphirestclient,
  client.model.principal;

{ TResourceFactory }

class function TResourceFactory.New: iServiceFactory;
begin
  Result := Self.Create;
end;

function TResourceFactory.Rest: iRest;
begin
  Result := TDelphiRestClient.New.Params.BaseURL(dmPrincipal.ServerURL).&End;
end;

end.
