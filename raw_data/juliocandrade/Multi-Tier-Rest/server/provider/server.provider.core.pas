unit server.provider.core;
interface
uses
  System.SysUtils,
  IdBaseComponent,
  IdComponent,
  IdCustomTCPServer,
  IdCustomHTTPServer,
  IdHTTPServer,
  IdContext,
  server.provider.interfaces,
  server.provider.request,
  server.provider.response;
type
  TProviderRequest = server.provider.request.TProviderRequest;
  TProviderResponse = server.provider.response.TProviderResponse;
  TProvider = class
  private
    const DEFAULT_PORT = 3000;
    class var FHTTPServer : TIdHTTPServer;
    class var FPort : Integer;
    class var FRoutes : iProviderRoutes;
    class function GetDefaultPort : Integer;
    class procedure InternalListen;
    class procedure InternalStopListen;
    class procedure DoCommand(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    class procedure TratarException(aException : Exception; aRes : TProviderResponse);
  public
    class constructor Create;
    class destructor Finish;
    class procedure Listen(APort : integer);
    class procedure StopListen;
    class function Routes : iProviderRoutes;
  end;
implementation
uses
  System.Classes,
  System.JSON,
  IdGlobal,
  server.provider.routes,
  server.provider.action,
  server.model.exceptions,
  server.utils;
{ TProvider }
class constructor TProvider.Create;
begin
  FHTTPServer := TIdHTTPServer.Create(nil);
  FRoutes := TProviderRoutes.New;
end;
class procedure TProvider.DoCommand(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  LContentStream : TStream;
  LContentString : String;
  LMethod : THTTPCommandType;
  LProviderActionRequestResponse : TProviderActionRequestResponse;
  LReq : TProviderRequest;
  LRes : TProviderResponse;
  LPath : String;
  LURIParams : TArray<string>;
begin
  LRes := TProviderResponse.Create;
  try
    try
      LMethod := ARequestInfo.CommandType;
      LURIParams := TServerUtils.GetParamsFromURI(ARequestInfo.URI);
      LPath := TServerUtils.DecodeURI(ARequestInfo.URI);
      case LMethod of
        hcGET: FRoutes.ActionGet(LPath, LProviderActionRequestResponse);
        hcPOST: FRoutes.ActionPost(LPath, LProviderActionRequestResponse);
        hcDELETE: FRoutes.ActionDelete(LPath, LProviderActionRequestResponse);
        hcPUT: FRoutes.ActionPut(LPath, LProviderActionRequestResponse);
      else
        raise EProviderException.New.Status(404).Error('Not Found');
      end;
      LContentStream := ARequestInfo.PostStream;
      if assigned(LContentStream) then
        LContentString := ReadStringFromStream(LContentStream);
      LReq := TProviderRequest.Create(LContentString,LURIParams);
      try
        LProviderActionRequestResponse(LReq, LRes);
      finally
        LReq.Free;
      end;
    except
      on E : Exception do
      begin
        TratarException(E, LRes);
      end;
    end;
    AResponseInfo.ContentType := 'application/json';
    AResponseInfo.CharSet := 'UTF-8';
    AResponseInfo.ResponseNo := LRes.ResultStatusCode;
    AResponseInfo.ContentText := LRes.Body;
    AResponseInfo.WriteContent;
  finally
    LRes.Free;
  end;
end;
class destructor TProvider.Finish;
begin
  FreeAndNil(FHTTPServer);
end;
class function TProvider.GetDefaultPort: Integer;
begin
  Result := DEFAULT_PORT;
end;
class procedure TProvider.InternalListen;
begin
  if FPort <= 0 then
    FPort := GetDefaultPort;
  FHTTPServer.DefaultPort := FPort;
  FHTTPServer.OnCommandGet := DoCommand;
  FHTTPServer.OnCommandOther := DoCommand;
  FHTTPServer.Active := True;
  System.Writeln(Format('Servidor rodando na porta %d', [FPort]));
  System.Readln;
end;
class procedure TProvider.InternalStopListen;
begin
  FHTTPServer.StopListening;
end;
class procedure TProvider.Listen(APort: integer);
begin
  FPort := APort;
  InternalListen;
end;
class function TProvider.Routes: iProviderRoutes;
begin
  Result := FRoutes;
end;
class procedure TProvider.StopListen;
begin
  InternalStopListen;
end;
class procedure TProvider.TratarException(aException: Exception; aRes : TProviderResponse);
begin
  if aException is ECampoInvalido then
  begin
    aRes.ResultStatusCode := 400;
    aRes.Body := Format('{"error": "%s"}', [aException.Message]);
  end
  else if aException is EProviderException then
  begin
    aRes.ResultStatusCode := EProviderException(aException).Status;
    aRes.Body := EProviderException(aException).ToJSONText;
  end
  else
  begin
    aRes.ResultStatusCode := 500;
    aRes.Body := Format('{"error": "%s"}', [aException.Message]);
  end;
end;

end.

