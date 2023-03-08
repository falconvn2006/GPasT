unit server.model.resource.rest.delphirestclient;
interface
uses
  server.model.resource.interfaces,
  REST.Types,
  REST.Client,
  Data.Bind.Components,
  Data.Bind.ObjectScope;
type
  TDelphiRestClient = class(TInterfacedObject, iRest)
  private
    FParams : iRestParams;
    FRESTClient: TRestClient;
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRestRequest;
    FContent : String;
    FStatusCode : Integer;
    procedure DoJoinComponents;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iRest;
    function Content : string;
    function StatusCode : Integer;
    function Delete : iRest;
    function Get : iRest;
    function Params : iRestParams;
    function Post : iRest; overload;
    function Put : iRest;
  end;
implementation
uses
  System.SysUtils,
  System.Classes,
  server.model.resource.rest.Params;
{ TDelphiRestClient }
function TDelphiRestClient.Content: string;
begin
  Result := FContent;
end;
constructor TDelphiRestClient.Create;
begin
  FRESTClient := TRestClient.Create(nil);
  FRestClient.SynchronizedEvents := False;
  FRESTResponse := TRESTResponse.Create(nil);
  FRESTRequest := TRestRequest.Create(nil);
  FRestRequest.SynchronizedEvents := False;
  FParams := TRestParams.New(Self);
  DoJoinComponents;
end;
function TDelphiRestClient.Delete: iRest;
begin
end;
destructor TDelphiRestClient.Destroy;
begin
  FreeAndNil(FRESTClient);
  FreeAndNil(FRESTResponse);
  FreeAndNil(FRESTRequest);
  inherited;
end;
procedure TDelphiRestClient.DoJoinComponents;
begin
  FRestRequest.Client := FRestClient;
  FRestRequest.Response := FRestResponse;
end;
function TDelphiRestClient.Get: iRest;
begin
  FRestClient.BaseURL := FParams.BaseURL;
  FRestRequest.Method := rmGET;
  FRestRequest.Resource := FParams.EndPoint;
  FRestRequest.Accept := CONTENTTYPE_APPLICATION_JSON + ', ' + CONTENTTYPE_TEXT_PLAIN + '; q=0.9, ' + CONTENTTYPE_TEXT_HTML + ';q=0.8,';
  FRestRequest.AcceptCharset := 'utf-8, *;q=0.8';
  FRestRequest.Execute;
  FContent := FRestResponse.Content;
  FStatusCode := FRestResponse.StatusCode;
end;
class function TDelphiRestClient.New: iRest;
begin
  Result := Self.Create;
end;
function TDelphiRestClient.Params: iRestParams;
begin
  Result := FParams;
end;
function TDelphiRestClient.Post: iRest;
begin
end;
function TDelphiRestClient.Put: iRest;
begin
end;
function TDelphiRestClient.StatusCode: Integer;
begin
  Result := FStatusCode;
end;

end.
