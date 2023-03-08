unit uTile__;

interface

uses
  uTypes, System.SysUtils;

type
  TTile = class;
  TTileDetail = class;
  TTileDetails = TArray< TTileDetail >;

  //************************************************************************//

  TResponse = class( uTypes.TResponse );

  TResponseColored = class( TResponse )
    FTag: TTag;
    FColor: TTileColorInt;
  end;

  TResponseProgressive = class( TResponseColored )
    FMin, FMax, FValue: TTileValueInt64;
  end;

  TResponseValued = class( TResponseColored )
    FValues: TTileValueStrings;
  end;

  TResponseDetail = class( TResponse )
    FValues: TTileDetails;
  end;

  //************************************************************************//

  TTileEvent = procedure(const Tile: TTile; const Response: TResponse) of object;

  TTileDetail = class
    FLogid: TLogid;
    FHost: THostname;
    FApp: TApplication;
    FInst: TInstance;
    FSrv: TServer;
    FMdl: TModule;
    FDos: TDossier;
    FRef: TReference;
    FKey: TKey;
    FVal: TValue;
    FColor: TTileColorInt;
  end;

  //************************************************************************//

  TTile = class
  private const
    cUrl = '/index.php';
    cDefaultIntervalMax = 10000;
    cDefaultForceUpdate = True;
  private type
    TRequest = class
      FTyp: TTileType;
      FUid: TUid;
      FTag: TTag;
      constructor Create(const &Type: TTileType; const Uid: TUid;
        const Tag: TTag); reintroduce;
    end;
  strict private
    FEnabled: Boolean;
    FInterval: TInterval;
    FIntervalMax: TInterval;
    procedure SetIntervalMax(const Value: TInterval);
  private
    FTag: TTag;
    FType: TTileType;
    FUid: TUid;
    //
    FContent: TResponse;
    //
    procedure SetTag(const Value: TTag);
    procedure SetType(const Value: TTileType);
  protected
    FOnUpdate: TTileEvent;
    FOnTypeChange: TTileEvent;
    FOnTagChange: TTileEvent;
    FOnColorChange: TTileEvent;
    FOnMinChange: TTileEvent;
    FOnMaxChange: TTileEvent;
    FOnValueChange: TTileEvent;
    FOnValuesChange: TTileEvent;
    FOnChange: TTileEvent;
    function Get<T: class, constructor>(const Uid: TUid; const Tag: TTag;
      const &Type: TTileType): T;
    procedure DoUpdate(Response: TResponse);
    procedure DoForceUpdate<T: TResponse, constructor>;
    procedure DoTagChange;
    procedure DoColorChange;
    procedure DoMinChange;
    procedure DoMaxChange;
    procedure DoValueChange;
    procedure DoValuesChange;
  public
    { constructor / destructor }
    constructor Create(const Uid: TUid; const Tag: TTag; const &Type: TTileType;
      const Interval: TInterval = cDefaultIntervalMax); reintroduce;
    { methods }
    procedure Synchronize;
    procedure Update;
    procedure ForceUpdate;
    { properties }
    property Enabled: Boolean read FEnabled write FEnabled;
    property Tag: TTag read FTag write SetTag;
    property &Type: TTileType read FType write SetType;
    property Interval: TInterval read FIntervalMax write SetIntervalMax;
    property Uid: TUid read FUid write FUid;
    { events }
    property OnUpdate: TTileEvent read FOnUpdate write FOnUpdate;
    property OnTypeChange: TTileEvent read FOnTypeChange write FOnTypeChange;
    property OnTagChange: TTileEvent read FOnTagChange write FOnTagChange;
    property OnColorChange: TTileEvent read FOnColorChange write FOnColorChange;
    property OnMinChange: TTileEvent read FOnMinChange write FOnMinChange;
    property OnMaxChange: TTileEvent read FOnMaxChange write FOnMaxChange;
    property OnValueChange: TTileEvent read FOnValueChange write FOnValueChange;
    property OnValuesChange: TTileEvent read FOnValuesChange write FOnValuesChange;
    property OnChange: TTileEvent read FOnChange write FOnChange;
  end;

implementation

uses
  System.Math, Vcl.Dialogs, uHttp, System.TypInfo;

{ TTile }

constructor TTile.Create(const Uid: TUid; const Tag: TTag;
  const &Type: TTileType; const Interval: TInterval);
begin
  FEnabled := True;

  FUid := Uid;
  FTag := Tag;
  FType := &Type;

  SetIntervalMax( Interval );
  FContent := nil;
end;

procedure TTile.DoColorChange;
begin
 if Assigned( FOnColorChange ) then
   FOnColorChange( Self, FContent );
end;

procedure TTile.DoForceUpdate<T>;
var
  Response: T;
begin
  Response := Get< T >( FUid, FTag, FType );
  try
    DoUpdate( Response );
    FContent := Response;
  finally
//    Response.Free;
  end;
end;

procedure TTile.DoMaxChange;
begin
 if Assigned( FOnMaxChange ) then
   FOnMaxChange( Self, FContent );
end;

procedure TTile.DoMinChange;
begin
 if Assigned( FOnMinChange ) then
   FOnMinChange( Self, FContent );
end;

procedure TTile.DoTagChange;
begin
 if Assigned( FOnTagChange ) then
   FOnTagChange( Self, FContent );
end;

procedure TTile.DoUpdate(Response: TResponse);
var
  SomethingChanged: Boolean;
begin
  if not Assigned( Response ) then
    Exit;

  if not Assigned( FContent ) then
    FOnUpdate( Self, Response );

  if FContent.ClassName = Response.ClassName then begin
    // Same FType
    if Response.InheritsFrom( TResponseColored ) then begin
      if TResponseColored( FContent ).FTag <> TResponseColored( Response ).FTag then
        DoTagChange;
      if TResponseColored( FContent ).FColor <> TResponseColored( Response ).FColor then
        DoColorChange;
    end;
    if Response.InheritsFrom( TResponseProgressive ) then begin
      if TResponseProgressive( FContent ).FMin <> TResponseProgressive( Response ).FMin then
        DoMinChange;
      if TResponseProgressive( FContent ).FMax <> TResponseProgressive( Response ).FMax then
        DoMaxChange;
      if TResponseProgressive( FContent ).FValue <> TResponseProgressive( Response ).FValue then
        DoValueChange;
    end;
    if Response.InheritsFrom( TResponseValued ) then begin
      if TResponseValued( FContent ).FValues <> TResponseValued( Response ).FValues then
        DoValuesChange;
    end;
    if Response.InheritsFrom( TResponseDetail ) then begin
      if TResponseDetail( FContent ).FValues <> TResponseDetail( Response ).FValues then
        DoValuesChange;
    end;
  end
  else begin
    // Different FType
  end;
end;

procedure TTile.DoValueChange;
begin
 if Assigned( FOnValueChange ) then
   FOnValueChange( Self, FContent );
end;

procedure TTile.DoValuesChange;
begin
 if Assigned( FOnValuesChange ) then
   FOnValuesChange( Self, FContent );
end;

procedure TTile.ForceUpdate;
var
  Response: TResponse;
begin
  case FType of
    TTileTypeRec.MasterColored: DoForceUpdate< TResponseColored >;
    TTileTypeRec.MasterValued: DoForceUpdate< TResponseValued >;
    TTileTypeRec.MasterProgressive: DoForceUpdate< TResponseProgressive >;
    TTileTypeRec.Detail: DoForceUpdate< TResponseDetail >;
  end;
end;

function TTile.Get<T>(const Uid: TUid; const Tag: TTag;
  const &Type: TTileType): T;
var
  Request: TRequest;
  Response: T;
begin
  try
    Request := TRequest.Create( &Type, Uid, Tag );
    try
      try
        Response := THttp.Query< T, TRequest >( Request, cUrl );
        if Assigned( Response ) then
          Exit( Response )
        else
          Exit( nil );
      finally
//        Response.Free;
      end;
    finally
      Request.Free;
    end;
  except
    Exit( nil );
  end;
end;

procedure TTile.SetIntervalMax(const Value: TInterval);
begin
  FIntervalMax := Value;
  Update;
end;

procedure TTile.SetTag(const Value: TTag);
begin
  FTag := Value;
  Update;
end;

procedure TTile.SetType(const Value: TTileType);
begin
  FType := Value;
  Update;
end;

procedure TTile.Synchronize;
begin
  if FInterval > 0 then
    Dec( FInterval )
  else
    Update;
end;

procedure TTile.Update;
begin
  if Enabled then
    ForceUpdate;
end;

{ TTile.TRequest }

constructor TTile.TRequest.Create(const &Type: TTileType; const Uid: TUid;
  const Tag: TTag);
begin
  FTyp := &Type;
  FUid := Uid;
  FTag := Tag;
end;

end.
