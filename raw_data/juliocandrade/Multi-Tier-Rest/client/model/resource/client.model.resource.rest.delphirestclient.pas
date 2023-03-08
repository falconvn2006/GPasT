unit client.model.resource.rest.delphirestclient;


interface

uses
  client.model.resource.interfaces,
  REST.Types,
  REST.Client,
  Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TDelphiRestClient = class(TInterfacedObject, iRest)
  private
    FRESTClient: TRestClient;
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRestRequest;
    FParams : iRestParams;
    FContent : String;
    procedure DoJoinComponents;
    procedure TratarStatusResposta;
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iRest;

    function Content : string;
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
  client.model.resource.rest.Params,
  System.JSON;

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
  FParams := TClientRestParams.New(Self);
  FParams.Accept(CONTENTTYPE_APPLICATION_JSON + ', ' + CONTENTTYPE_TEXT_PLAIN + '; q=0.9, ' + CONTENTTYPE_TEXT_HTML + ';q=0.8,');
  DoJoinComponents;

end;

function TDelphiRestClient.Delete: iRest;
begin
  FRestClient.BaseURL := FParams.BaseURL;
  FRestRequest.Method := rmDELETE;
  FRestRequest.Resource := FParams.EndPoint;
  FRestRequest.Accept := CONTENTTYPE_APPLICATION_JSON + ', ' + CONTENTTYPE_TEXT_PLAIN + '; q=0.9, ' + CONTENTTYPE_TEXT_HTML + ';q=0.8,';
  FRestRequest.AcceptCharset := 'utf-8, *;q=0.8';
  TratarStatusResposta;
  FRestRequest.Execute;
  FContent := FRestResponse.Content;

end;

destructor TDelphiRestClient.Destroy;
begin
  FreeAndNil(FRESTClient);
  FreeAndNil(FRESTResponse);
  FreeAndNil(FRESTRequest);
  inherited;
end;

procedure TDelphiRestClient.TratarStatusResposta;
var
  LJSONError : TJSONObject;
  LMensagemErro : String;
begin
  if FRESTResponse.StatusCode > 399 then
  begin
    LJSONError := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
    try
      if LJSONError.TryGetValue<string>('error', LMensagemErro) then
        raise Exception.Create(LMensagemErro)
      else
        raise Exception.Create(FRESTResponse.Content);
    finally
      LJSONError.Free;
    end;
  end;
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
  TratarStatusResposta;
  FContent := FRestResponse.Content;
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
  FRestClient.BaseURL := FParams.BaseURL;
  FRestRequest.Method := rmPOST;
  FRestRequest.Resource := FParams.EndPoint;
  FRestRequest.Accept := FParams.Accept;
  FRestRequest.AcceptCharset := 'utf-8, *;q=0.8';
  FRESTRequest.AddBody(FParams.Body, TRESTContentType.ctAPPLICATION_JSON);
  FRestRequest.Execute;
  TratarStatusResposta;
  FContent := FRestResponse.Content;
end;

function TDelphiRestClient.Put: iRest;
begin
  FRestClient.BaseURL := FParams.BaseURL;
  FRestRequest.Method := rmPUT;
  FRestRequest.Resource := FParams.EndPoint;
  FRestRequest.Accept := FParams.Accept;
  FRestRequest.AcceptCharset := 'utf-8, *;q=0.8';
  FRESTRequest.AddBody(FParams.Body, TRESTContentType.ctAPPLICATION_JSON);
  FRestRequest.Execute;
  TratarStatusResposta;
  FContent := FRestResponse.Content;
end;

end.
