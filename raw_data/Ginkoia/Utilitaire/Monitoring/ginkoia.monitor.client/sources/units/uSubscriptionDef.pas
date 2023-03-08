unit uSubscriptionDef;

interface

uses
  uHttp, uTypes;

type
  TSubscriptionDef = class
  private const
    cUrl = '/config_abonnement.php';
  private type
    TRequest = class
      FUid: TUid;
      constructor Create(const Uid: TUid); reintroduce;
    end;
    TResponse = class
      FHost: THostnames;
      FApp: TApplications;
      FInst: TInstances;
      FSrv: TServers;
      FMdl: TModules;
      FDos: TDossiers;
      FRef: TReferences;
      FKey: TKeys;
    end;
  private
    FHostnames: THostnames;
    FApplications: TApplications;
    FInstances: TInstances;
    FServeurs: TServers;
    FModules: TModules;
    FDossiers: TDossiers;
    FReferences: TReferences;
    FKeys: TKeys;
  public
    { constructor/destructor }
    constructor Create(const Hostnames: THostnames;
      const Applications: TApplications; const Instances: TInstances;
      const Serveurs: TServers; const Modules: TModules;
      const Dossiers: TDossiers; const References: TReferences;
      const Keys: TKeys); reintroduce;
    { events }
    class function Get(const Uid: TUid): TSubscriptionDef;
    { properties }
    property Hostnames: THostnames read FHostnames write FHostnames;
    property Applications: TApplications read FApplications write FApplications;
    property Instances: TInstances read FInstances write FInstances;
    property Serveurs: TServers read FServeurs write FServeurs;
    property Modules: TModules read FModules write FModules;
    property Dossiers: TDossiers read FDossiers write FDossiers;
    property References: TReferences read FReferences write FReferences;
    property Keys: TKeys read FKeys write FKeys;
  end;

implementation

{ TSubscriptionDef }

constructor TSubscriptionDef.Create(const Hostnames: THostnames;
  const Applications: TApplications; const Instances: TInstances;
  const Serveurs: TServers; const Modules: TModules; const Dossiers: TDossiers;
  const References: TReferences; const Keys: TKeys);
begin
  FHostnames := Hostnames;
  FApplications := Applications;
  FInstances := Instances;
  FServeurs := Serveurs;
  FModules := Modules;
  FDossiers := Dossiers;
  FReferences := References;
  FKeys := Keys;
end;

class function TSubscriptionDef.Get(
  const Uid: TUid): TSubscriptionDef;
var
  Response: TResponse;
  Request: TRequest;
begin
  try
    Request := TRequest.Create( Uid );
    try
      try
        Response := THttp.Query< TResponse, TRequest >( Request, cUrl );
        if Assigned( Response ) then
          Exit( TSubscriptionDef.Create( Response.FHost, Response.FApp,
            Response.FInst, Response.FSrv, Response.FMdl, Response.FDos,
            Response.FRef, Response.FKey ) )
        else
          Exit( nil );
      finally
        Response.Free;
      end;
    finally
      Request.Free;
    end;
  except
    Exit( nil );
  end;
end;

{ TSubscriptionDef.TRequest }

constructor TSubscriptionDef.TRequest.Create(const Uid: TUid);
begin
  FUid := Uid;
end;

end.

