unit uSubscription;

interface

uses
  uHttp,
  System.Generics.Collections, uTypes;

type
  TSubscription = class;
  TSubscriptions = TArray< TSubscription >;

  TSubscription = class
  private const
    cUrl = '/abonnement.php';
  private type
    TRequest = class
      FUid: TUid;
      FHost: THostname;
      FApp: TApplication;
      FInst: TInstance;
      FSrv: TServer;
      FMdl: TModule;
      FDos: TDossier;
      FRef: TReference;
      FKey: TKey;
      FTag: TTag;
      constructor Create(const Uid: TUid; const Hostname: THostname;
        const Application: TApplication; const Instance: TInstance;
        const Server: TServer; const Module: TModule; const Dossier: TDossier;
        const Reference: TReference; const Key: TKey;
        const Tag: TTag); reintroduce;
    end;
    TResponse = class
      FStatus: TSubscriptionStatus;
    end;
  private
    FHostname: THostname;
    FApplication: TApplication;
    FInstance: TInstance;
    FModule: TModule;
    FServer: TServer;
    FReference: TReference;
    FDossier: TDossier;
    FKey: TKey;
    FTag: TTag;
    FType: TTileType;
    FFrequency: TFrequency;
  public
    { constructor/destructor }
    constructor Create(const Frequency: TFrequency; const &Type: TTileType;
      const Hostname: THostname; const Application: TApplication;
      const Instance: TInstance; const Server: TServer; const Module: TModule;
      const Dossier: TDossier; const Reference: TReference; const Key: TKey;
      const Tag: TTag); reintroduce;
    { events }
    function Get(const Uid: TUid): Boolean; overload;
    class function Get(const Uid: TUid; const Frequency: TFrequency;
      const &Type: TTileType; const Hostname: THostname;
      const Application: TApplication; const Instance: TInstance;
      const Server: TServer; const Module: TModule; const Dossier: TDossier;
      const Reference: TReference; const Key: TKey;
      const Tag: TTag): TSubscription; overload;
    { properties }
    property Hostname: THostname read FHostname write FHostname;
    property Application: TApplication read FApplication write FApplication;
    property Instance: TInstance read FInstance write FInstance;
    property Server: TServer read FServer write FServer;
    property Module: TModule read FModule write FModule;
    property Dossier: TDossier read FDossier write FDossier;
    property Reference: TReference read FReference write FReference;
    property Key: TKey read FKey write FKey;
    property Tag: TTag read FTag write FTag;
    property &Type: TTileType read FType write FType;
    property Frequency: TFrequency read FFrequency write FFrequency;
  end;

implementation

{ TSubscription }

constructor TSubscription.Create(const Frequency: TFrequency;
  const &Type: TTileType; const Hostname: THostname;
  const Application: TApplication; const Instance: TInstance;
  const Server: TServer; const Module: TModule; const Dossier: TDossier;
  const Reference: TReference; const Key: TKey; const Tag: TTag);
begin
  FHostname := Hostname;
  FApplication := Application;
  FInstance := Instance;
  FServer := Server;
  FModule := Module;
  FDossier := Dossier;
  FReference := Reference;
  FKey := Key;
  FTag := Tag;
  FFrequency := Frequency;
  FType := &Type;
end;

class function TSubscription.Get(const Uid: TUid; const Frequency: TFrequency;
  const &Type: TTileType; const Hostname: THostname;
  const Application: TApplication; const Instance: TInstance;
  const Server: TServer; const Module: TModule; const Dossier: TDossier;
  const Reference: TReference; const Key: TKey;
  const Tag: TTag): TSubscription;
var
  Response: TResponse;
  Request: TRequest;
begin
  try
    Request := TRequest.Create( Uid, Hostname, Application, Instance, Server,
      Module, Dossier, Reference, Key, Tag );
    try
      try
        Response := THttp.Query< TResponse, TRequest >( Request, cUrl );
        case Response.FStatus of
          NOK: Exit( nil );
          OK: Exit( TSubscription.Create( Frequency, &Type, Hostname,
            Application, Instance, Server, Module, Dossier, Reference, Key,
            Tag ) );
        end;
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

function TSubscription.Get(const Uid: TUid): Boolean;
var
  Subscription: TSubscription;
begin
  Subscription := TSubscription.Get( Uid, FFrequency, FType, FHostname,
    FApplication, FInstance, FServer, FModule, FDossier, FReference, FKey,
    FTag );
  try
    Exit( Assigned( Subscription ) );
  finally
    Subscription.Free;
  end;
end;

{ TSubscription.TRequest }

constructor TSubscription.TRequest.Create(const Uid: TUid;
  const Hostname: THostname; const Application: TApplication;
  const Instance: TInstance; const Server: TServer; const Module: TModule;
  const Dossier: TDossier; const Reference: TReference; const Key: TKey;
  const Tag: TTag);
begin
  FUid := UID;
  FHost := Hostname;
  FApp := Application;
  FInst := Instance;
  FSrv := Server;
  FMdl := Module;
  FDos := Dossier;
  FRef := Reference;
  FKey := Key;
  FTag := Tag;
end;

end.

