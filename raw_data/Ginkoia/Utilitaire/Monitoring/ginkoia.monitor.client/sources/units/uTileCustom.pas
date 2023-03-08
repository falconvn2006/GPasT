unit uTileCustom;

interface

uses
  uTypes, System.SysUtils, uHttp, REST.Json, System.Classes;

type
  TTileCustom = class;
  TTileDetail = class;

  {$REGION 'Declaration: TResponse[|Colored|Progressive|Valued|Detail]'}
  TResponse = class
  end;

  TResponseColored = class( TResponse )
  private
    function GetColor: TTileColor;
  public
    FTag: TTag;
    FColor: TTileColorIndex;
    property Color: TTileColor read GetColor;
  end;

  TResponseProgressive = class( TResponseColored )
    FMin, FMax, FValue: TTileValueInt64;
  end;

  TResponseValued = class( TResponseColored )
    FValues: TTileValueStrings;
  end;

  TResponseDetail = class( TResponse )
    FValues: TArray< TTileDetail >;
    destructor Destroy; override;
  end;
  {$ENDREGION 'Declaration: TResponse[|Colored|Progressive|Valued|Detail]'}

  TTileDetail = class
  private
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
    FColor: TTileColorIndex;
    function GetColor: TTileColor;
  public
    property Logid: TLogid read FLogid write FLogid;
    property Hostname: THostname read FHost write FHost;
    property Application: TApplication read FApp write FApp;
    property Instance: TInstance read FInst write FInst;
    property Server: TServer read FSrv write FSrv;
    property Module: TModule read FMdl write FMdl;
    property Dossier: TDossier read FDos write FDos;
    property Reference: TReference read FRef write FRef;
    property Key: TKey read FKey write FKey;
    property Value: TValue read FVal write FVal;
    property Color: TTileColor read GetColor;
  end;

  TTileNotify = procedure(const Tile: TTileCustom) of object;
  TTileEvent = procedure(const Tile: TTileCustom; const Response: TResponse) of object;

  TTileCustom = class
  private const
    cUrl = '/index.php';
    cDefaultForceUpdate = True;
    cDefaultEnabled = True;
    cDefaultThreaded = True;
  private type
    TRequest = class
      FTag: TTag;
      FTyp: TTileType;
      FUid: TUid;
      constructor Create(const Tag: TTag; const &Type: TTileType;
        const Uid: TUid); reintroduce;
    end;
  strict private
    FEnabled: Boolean;
    FInterval: TInterval;
    FIntervalMax: TInterval;
    procedure SetInterval(const Value: TInterval);
    procedure SetIntervalMax(const Value: TInterval);
  private
    { members }
    FTag: TTag;
    FType: TTileType;
    FUid: TUid;
    FResponse: TResponse;
    { events }
    FOnChange: TTileEvent;
    FOnColorChange: TTileEvent;
    FOnMaxChange: TTileEvent;
    FOnMinChange: TTileEvent;
    FOnTagChange: TTileEvent;
    FOnTypeChange: TTileEvent;
    FOnValueChange: TTileEvent;
    FOnValuesChange: TTileEvent;
    FOnDetailChange: TTileEvent;
    { methods }
    procedure DoUpdate(Response: TResponse);
    function Get<T: class, constructor>(const Uid: TUid; const Tag: TTag;
      const &Type: TTileType): T;
    procedure SetEnabled(const Value: Boolean);
  protected
    procedure DoChange(const Tile: TTileCustom; const Response: TResponse); virtual;
    procedure DoColorChange(const Tile: TTileCustom; const Response: TResponse); virtual;
    procedure DoMaxChange(const Tile: TTileCustom; const Response: TResponse); virtual;
    procedure DoMinChange(const Tile: TTileCustom; const Response: TResponse); virtual;
    procedure DoTagChange(const Tile: TTileCustom; const Response: TResponse); virtual;
    procedure DoTypeChange(const Tile: TTileCustom; const Response: TResponse); virtual;
    procedure DoValueChange(const Tile: TTileCustom; const Response: TResponse); virtual;
    procedure DoValuesChange(const Tile: TTileCustom; const Response: TResponse); virtual;
    procedure DoDetailChange(const Tile: TTileCustom; const Response: TResponse); virtual;
  public
    { constructor / destructor }
    constructor Create(const Tag: TTag; const &Type: TTileType; const Uid: TUid;
      const Interval: TInterval); reintroduce;
    destructor Destroy; override;
    { methods }
    procedure Synchronize; virtual;{ TODO : virer le virtual }
    procedure Update;
    procedure ForceUpdate;
    { properties }
    property Tag: TTag read FTag write FTag;
    property &Type: TTileType read FType write FType;
    property Uid: TUid read FUid write FUid;
    property Response: TResponse read FResponse;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Interval: TInterval read FInterval write SetInterval;
    property IntervalMax: TInterval read FIntervalMax write SetIntervalMax;
    { events }
    property OnChange: TTileEvent read FOnChange write FOnChange;
    property OnColorChange: TTileEvent read FOnColorChange write FOnColorChange;
    property OnMaxChange: TTileEvent read FOnMaxChange write FOnMaxChange;
    property OnMinChange: TTileEvent read FOnMinChange write FOnMinChange;
    property OnTagChange: TTileEvent read FOnTagChange write FOnTagChange;
    property OnTypeChange: TTileEvent read FOnTypeChange write FOnTypeChange;
    property OnValueChange: TTileEvent read FOnValueChange write FOnValueChange;
    property OnValuesChange: TTileEvent read FOnValuesChange write FOnValuesChange;
    property OnDetailChange: TTileEvent read FOnDetailChange write FOnDetailChange;
  end;

implementation

{ TTileCustom }

constructor TTileCustom.Create(const Tag: TTag; const &Type: TTileType;
  const Uid: TUid; const Interval: TInterval);
begin
  inherited Create;
  FTag := Tag;
  FType := &Type;
  FUid := Uid;
  FEnabled := cDefaultEnabled;
  FResponse := nil;
  SetIntervalMax( Interval );
end;

procedure TTileCustom.Update;
begin
  if FEnabled then
    ForceUpdate;
end;

destructor TTileCustom.Destroy;
begin
  FResponse.Free;
  inherited;
end;

procedure TTileCustom.DoChange(const Tile: TTileCustom; const Response: TResponse);
begin
  if Assigned( FOnChange ) then
    FOnChange( Tile, Response );
end;

procedure TTileCustom.DoColorChange(const Tile: TTileCustom; const Response: TResponse);
begin
  if Assigned( FOnColorChange ) then
    FOnColorChange( Tile, Response );
end;

procedure TTileCustom.DoDetailChange(const Tile: TTileCustom;
  const Response: TResponse);
begin
  if Assigned( FOnDetailChange ) then
    FOnDetailChange( Tile, Response );
end;

procedure TTileCustom.DoMaxChange(const Tile: TTileCustom; const Response: TResponse);
begin
  if Assigned( FOnMaxChange ) then
    FOnMaxChange( Tile, Response );
end;

procedure TTileCustom.DoMinChange(const Tile: TTileCustom; const Response: TResponse);
begin
  if Assigned( FOnMinChange ) then
    FOnMinChange( Tile, Response );
end;

procedure TTileCustom.DoTagChange(const Tile: TTileCustom; const Response: TResponse);
begin
  if Assigned( FOnTagChange ) then
    FOnTagChange( Tile, Response );
end;

procedure TTileCustom.DoTypeChange(const Tile: TTileCustom; const Response: TResponse);
begin
  if Assigned( FOnTypeChange ) then
    FOnTypeChange( Tile, Response );
end;

procedure TTileCustom.DoUpdate(Response: TResponse);
  function SameValues(const a, b: TResponseDetail): Boolean;
  begin
    try
      Exit( SameText( TJson.ObjectToJsonString( a ), TJson.ObjectToJsonString( b ) ) );
    finally
    end;
  end;
var
  SomethingChanged: Boolean;
begin
  SomethingChanged := False;

  if not Assigned( Response ) then
    Exit;

  { TResponse }
//  if Response.InheritsFrom( TResponse ) then begin
//  end;
  if ( FResponse = nil ) or ( Response.ClassName <> FResponse.ClassName ) then begin
    SomethingChanged := True;
    DoTypeChange( Self, Response );
  end;

  { TResponseColored }
  if Response.InheritsFrom( TResponseColored ) then begin
    if ( FResponse = nil ) or ( TResponseColored( Response ).FTag <> TResponseColored( FResponse ).FTag ) then begin
      SomethingChanged := True;
      DoTagChange( Self, Response );
    end;
    if ( FResponse = nil ) or ( TResponseColored( Response ).FColor <> TResponseColored( FResponse ).FColor ) then begin
      SomethingChanged := True;
      DoColorChange( Self, Response );
    end;
  end;
  { TResponseValued }
  if Response.InheritsFrom( TResponseValued ) then begin
    if ( FResponse = nil ) or ( TResponseValued( Response ).FValues <> TResponseValued( FResponse ).FValues ) then begin
      SomethingChanged := True;
      DoValuesChange( Self, Response );
    end;
  end;
  { TResponseProgressive }
  if Response.InheritsFrom( TResponseProgressive ) then begin
    if ( FResponse = nil ) or ( TResponseProgressive( Response ).FMin <> TResponseProgressive( FResponse ).FMin ) then begin
      SomethingChanged := True;
      DoMinChange( Self, Response );
    end;
    if ( FResponse = nil ) or ( TResponseProgressive( Response ).FMax <> TResponseProgressive( FResponse ).FMax ) then begin
      SomethingChanged := True;
      DoMaxChange( Self, Response );
    end;
    if ( FResponse = nil ) or ( TResponseProgressive( Response ).FValue <> TResponseProgressive( FResponse ).FValue ) then begin
      SomethingChanged := True;
      DoValueChange( Self, Response );
    end;
  end;
  { TResponseDetail }
  if Response.InheritsFrom( TResponseDetail ) then begin
    if ( FResponse = nil ) or ( not SameValues( TResponseDetail( Response ), TResponseDetail( FResponse ) ) ) then begin
      SomethingChanged := True;
      DoDetailChange( Self, Response );
    end;
  end;

  if SomethingChanged then
    DoChange( Self, Response );


  if Assigned( FResponse ) then
    FResponse.Free;
  FResponse := Response;
end;

procedure TTileCustom.DoValueChange(const Tile: TTileCustom; const Response: TResponse);
begin
  if Assigned( FOnValueChange ) then
    FOnValueChange( Tile, Response );
end;

procedure TTileCustom.DoValuesChange(const Tile: TTileCustom; const Response: TResponse);
begin
  if Assigned( FOnValuesChange ) then
    FOnValuesChange( Tile, Response );
end;

procedure TTileCustom.ForceUpdate;
var
  Response: TResponse;
begin
  try
    case FType of
      TTileTypeRec.MasterColored:
        Response := Get< TResponseColored >( FUid, FTag, FType );
      TTileTypeRec.MasterValued:
        Response := Get< TResponseValued >( FUid, FTag, FType );
      TTileTypeRec.MasterProgressive:
        Response := Get< TResponseProgressive >( FUid, FTag, FType );
      TTileTypeRec.Detail:
        Response := Get< TResponseDetail >( FUid, FTag, FType );
    end;
    DoUpdate( Response );
  finally
    SetIntervalMax( FIntervalMax );
  end;
end;

function TTileCustom.Get<T>(const Uid: TUid; const Tag: TTag;
  const &Type: TTileType): T;
var
  Request: TRequest;
  Response: T;
begin
  try
    Request := TRequest.Create( Tag, &Type, Uid );
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

procedure TTileCustom.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
  if Value then
    ForceUpdate;
end;

procedure TTileCustom.SetInterval(const Value: TInterval);
begin
  { TODO : supprimer? }
  FInterval := Value;
end;

procedure TTileCustom.SetIntervalMax(const Value: TInterval);
begin
  FIntervalMax := Value;
  FInterval := Value;
end;

procedure TTileCustom.Synchronize;
begin
  if not FEnabled then
    Exit;
  if FInterval > 0 then
    Dec( FInterval )
  else
    if cDefaultThreaded then
      TThread.Synchronize( nil, Update )
//      TThread.CreateAnonymousThread(
//        procedure
//        begin
//          TThread.Synchronize( nil,
//          procedure
//          begin
//            Update
//          end
//          );
//       end).Start
    else
      Update;
end;

{ TTileCustom.TRequest }

constructor TTileCustom.TRequest.Create(const Tag: TTag; const &Type: TTileType;
  const Uid: TUid);
begin
  FTag := Tag;
  FTyp := &Type;
  FUid := Uid;
end;

{ TResponseDetail }

destructor TResponseDetail.Destroy;
var
  i: Integer;
begin
  for i := High( FValues ) downto Low( FValues ) do
    FValues[ i ].Free;
  inherited;
end;

{ TResponseColored }

function TResponseColored.GetColor: TTileColor;
begin
  Exit( TileColorIndexToTileColor( FColor ) );
end;

{ TTileDetail }

function TTileDetail.GetColor: TTileColor;
begin
  Exit( TileColorIndexToTileColor( FColor ) );
end;

end.

