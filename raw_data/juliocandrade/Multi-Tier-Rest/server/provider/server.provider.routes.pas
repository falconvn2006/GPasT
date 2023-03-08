unit server.provider.routes;

interface
uses
  System.Generics.Collections,
  Web.HTTPApp,
  server.provider.interfaces,
  server.provider.action;
type
  TProviderRoutes = class(TInterfacedObject, iProviderRoutes)
    private
      FRoutesList : TDictionary<TMethodType, iProviderRouteAction>;
      procedure addRoute(aMethod : TMethodType; aPath: string; aAction : TProviderActionRequestResponse);
      procedure ActionInternal(aMethod : TMethodType; aPath: string; var aAction: TProviderActionRequestResponse);
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iProviderRoutes;
      function Get(aPath : string; aAction : TProviderActionRequestResponse) : iProviderRoutes;
      function Post(aPath : string; aAction : TProviderActionRequestResponse) : iProviderRoutes;
      function Put(aPath : string; aAction : TProviderActionRequestResponse) : iProviderRoutes;
      function Delete(aPath : string; aAction : TProviderActionRequestResponse) : iProviderRoutes;
      procedure ActionGet(aPath: string; var aAction: TProviderActionRequestResponse);
      procedure ActionPost(aPath: string; var aAction: TProviderActionRequestResponse);
      procedure ActionDelete(aPath: string; var aAction: TProviderActionRequestResponse);
      procedure ActionPut(aPath: string; var aAction: TProviderActionRequestResponse);
  end;
implementation

uses
  server.model.exceptions,
  server.utils,
  server.provider.route.action;

{ TProviderRoutes }

procedure TProviderRoutes.addRoute(aMethod : TMethodType; aPath: string;
  aAction : TProviderActionRequestResponse);
var
  LProviderRouteAction : iProviderRouteAction;
begin
  aPath := TServerUtils.DecodeURI(aPath);
  if not FRoutesList.TryGetValue(aMethod, LProviderRouteAction) then
  begin
    LProviderRouteAction := TProviderRouteAction.New;
    FRoutesList.add(aMethod, LProviderRouteAction);
  end;
  LProviderRouteAction.RegisterRouter(aPath, aAction);
end;

procedure TProviderRoutes.ActionInternal(aMethod: TMethodType;
  aPath: string; var aAction: TProviderActionRequestResponse);
var
  LProviderRouteAction : iProviderRouteAction;
begin
  if not FRoutesList.TryGetValue(aMethod, LProviderRouteAction) then
    raise EProviderException.New.Status(404).Error('Not Found');
  if not LProviderRouteAction.GetRoute(aPath, aAction) then
    raise EProviderException.New.Status(404).Error('Not Found');
end;

procedure TProviderRoutes.ActionDelete(aPath: string;
  var aAction: TProviderActionRequestResponse);
begin
  ActionInternal(mtDelete, aPath, aAction);
end;

procedure TProviderRoutes.ActionPost(aPath: string;
  var aAction: TProviderActionRequestResponse);
begin
  ActionInternal(mtPost, aPath, aAction);
end;

procedure TProviderRoutes.ActionPut(aPath: string;
  var aAction: TProviderActionRequestResponse);
begin
  ActionInternal(mtPut, aPath, aAction);
end;

procedure TProviderRoutes.ActionGet(aPath: string;
  var aAction: TProviderActionRequestResponse);
begin
  ActionInternal(mtGet, aPath, aAction);
end;

constructor TProviderRoutes.Create;
begin
  FRoutesList := TDictionary<TMethodType, iProviderRouteAction>.Create;
end;

function TProviderRoutes.Delete(aPath: string;
  aAction: TProviderActionRequestResponse): iProviderRoutes;
begin
  Result := Self;
  addRoute(mtDelete, aPath, aAction);
end;

destructor TProviderRoutes.Destroy;
begin
  FRoutesList.Free;
  inherited;
end;

function TProviderRoutes.Get(aPath: string;
  aAction: TProviderActionRequestResponse): iProviderRoutes;
begin
  Result := Self;
  addRoute(mtGet, aPath, aAction);
end;

class function TProviderRoutes.New: iProviderRoutes;
begin
  Result := Self.Create;
end;

function TProviderRoutes.Post(aPath: string;
  aAction: TProviderActionRequestResponse): iProviderRoutes;
begin
  Result := Self;
  addRoute(mtPost, aPath, aAction);
end;

function TProviderRoutes.Put(aPath: string;
  aAction: TProviderActionRequestResponse): iProviderRoutes;
begin
  Result := Self;
  addRoute(mtPut, aPath, aAction);

end;

end.
