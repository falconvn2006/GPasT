unit server.provider.action;

interface
uses
  server.provider.response,
  server.provider.request;
type
   TProviderActionRequestResponse = procedure(AReq: TProviderRequest; ARes: TProviderResponse);

implementation

end.
