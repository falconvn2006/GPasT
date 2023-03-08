unit server.provider.route.action;

interface

uses
  System.Generics.Collections,
  server.provider.interfaces,
  server.provider.action;
type
  TProviderRouteAction = class(TInterfacedObject, iProviderRouteAction)
    private
      FRouteActionList : TDictionary<string, TProviderActionRequestResponse>;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iProviderRouteAction;
      procedure RegisterRouter(aPath : string; aAction : TProviderActionRequestResponse);
      function GetRoute(aPath : string; var aAction : TProviderActionRequestResponse) : boolean;
  end;
implementation

{ TProviderRouteAction }

constructor TProviderRouteAction.Create;
begin
  FRouteActionList := TDictionary<string, TProviderActionRequestResponse>.Create;
end;

destructor TProviderRouteAction.Destroy;
begin
  FRouteActionList.Free;
  inherited;
end;

class function TProviderRouteAction.New: iProviderRouteAction;
begin
  Result := Self.Create;
end;

procedure TProviderRouteAction.RegisterRouter(aPath: string;
  aAction: TProviderActionRequestResponse);
begin
  FRouteActionList.Add(aPath, aAction);
end;

function TProviderRouteAction.GetRoute(aPath: string;
  var aAction: TProviderActionRequestResponse): boolean;
begin
  Result := FRouteActionList.TryGetValue(aPath, aAction);
end;

end.
