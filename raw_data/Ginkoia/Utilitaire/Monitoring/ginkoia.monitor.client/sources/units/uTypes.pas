unit uTypes;

interface

uses
  System.UITypes;

type
  { Configuration }
  TFilename = type String;

  TUid = type String;
  TLogin = type String;
  TPassword = type String;

  TLogid = type String;
  THostname = type String;
  TApplication = type String;
  TInstance = type String;
  TServer = type String;
  TModule = type String;
  TDossier = type String;
  TReference = type String;
  TKey = type String;
  TTag = type String;
  TValue = type String;
  TFrequency = type Cardinal;
  TSubscriptionStatus = ( NOK, OK );

  TLevel = type String;
  TDateString = type String;
  TCount = type Cardinal;


  THostnames = TArray< THostname >;
  TApplications = TArray< TApplication >;
  TInstances = TArray< TInstance >;
  TServers = TArray< TServer >;
  TModules = TArray< TModule >;
  TDossiers = TArray< TDossier >;
  TReferences = TArray< TReference >;
  TKeys = TArray< TKey >;

  TTileTypeString = type String;
  TTileType = ( mc, mv, mp, detail );
  TTileTypeRec = record
  const
    MasterColored = TTileType.mc;
    MasterValued = TTileType.mv;
    MasterProgressive = TTileType.mp;
    Detail = TTileType.detail;
  end;

  TTileColorIndex = type ShortInt;
  TTileColorString = type String;
  TTileColor = ( None, Debug, Trace, Info, Notice, Warning, Error, Critical,
    Emergency, DLL, DoubleDLL );
  TTileColorRec = record
  const
    None = TTileColor( 0 );
    Debug = TTileColor( 1 );
    Trace = TTileColor( 2 );
    Info = TTileColor( 3 );
    Notice = TTileColor( 4 );
    Warning = TTileColor( 5 );
    Error = TTileColor( 6 );
    Critical = TTileColor( 7 );
    Emergency = TTileColor( 8 );
    DLL = TTileColor( 9 );
    DoubleDLL = TTileColor( 10 );
    constructor Create(const TileColor: TTileColor); overload;
    constructor Create(const TileColorIndex: TTileColorIndex); overload;
    case SmallInt of
      0: ( TileColor: TTileColor );
  end;

  TTileColors = class
    FDebug: TColor;
    FTrace: TColor;
    FInfo: TColor;
    FNotice: TColor;
    FWarning: TColor;
    FError: TColor;
    FCritical: TColor;
    FEmergency: TColor;
    FDLL: TColor;
    FDoubleDLL: TColor;
    constructor Create(const Debug, Trace, Info, Notice, Warning, Error,
      Critical, Emergency, DLL, DoubleDLL: TColor); reintroduce;
  end;

  TTileValueInt = type Integer;
  TTileValueInt64 = type Int64;
  TTileValueString = type String;
  TTileValueStrings = TArray< TTileValueString >;

  TInterval = type Cardinal; //Int64;

//  TRequest = class( TObject );
//  TResponse = class( TObject );

function TileColorIndexToTileColor(const TileColorIndex: TTileColorIndex): TTileColor;
function TileColorToString(const TileColor: TTileColor): TTileColorString;
function TileColorToTileColorIndex(const TileColor: TTileColor): TTileColorIndex;
function TileColorToColor(const TileColor: TTileColor): TColor; overload;

function TileTypeToString(const TileType: TTileType): TTileTypeString;
function StrToTileType(const S: TTileTypeString): TTileType;

implementation

uses
  uConfiguration,
  System.SysUtils;

function TileColorIndexToTileColor(const TileColorIndex: TTileColorIndex): TTileColor;
var
  TileColor: TTileColor;
  Index: ShortInt;
begin
  Result := TTileColorRec.None;
  Index := 0;
  for TileColor := Low( TTileColor ) to High( TTileColor ) do begin
    if Index = TileColorIndex then
      Exit( TileColor );
    Inc( Index );
  end;
end;

function TileColorToString(const TileColor: TTileColor): TTileColorString;
begin
  case TileColor of
    None: Exit( 'none' );
    Debug: Exit( 'debug' );
    Trace: Exit( 'trace' );
    Info: Exit( 'info' );
    Notice: Exit( 'notice' );
    Warning: Exit( 'warning' );
    Error: Exit( 'error' );
    Critical: Exit( 'critical' );
    Emergency: Exit( 'emergency' );
    DLL: Exit( 'DLL' );
    DoubleDLL: Exit( 'DoubleDLL' );
  else
    Exit( 'unknown' );
  end;
end;

function TileColorToTileColorIndex(const TileColor: TTileColor): TTileColorIndex;
begin
  Exit( Ord( TileColor ) );
end;

function TileColorToColor(const TileColor: TTileColor): TColor;
begin

  case TileColor of
    None: Exit( TColorRec.Null );
    Debug:
      if Assigned( TConfiguration.Colors ) then
        Exit( TConfiguration.Colors.FDebug )
      else
        Exit( $C16A00 { $006AC1{TColorRec.Red} );
    Trace:
      if Assigned( TConfiguration.Colors ) then
        Exit( TConfiguration.Colors.FTrace )
      else
        Exit( $878200{TColorRec.Blue} );
    Info:
      if Assigned( TConfiguration.Colors ) then
        Exit( TConfiguration.Colors.FInfo )
      else
        Exit( $009919{TColorRec.Lime} );
    Notice:
      if Assigned( TConfiguration.Colors ) then
        Exit( TConfiguration.Colors.FNotice)
      else
        Exit( $3FC100{TColorRec.Lightblue} );
    Warning:
      if Assigned( TConfiguration.Colors ) then
        Exit( TConfiguration.Colors.FWarning )
      else
        Exit( $1D98FF{TColorRec.Yellow} );
    Error:
      if Assigned( TConfiguration.Colors ) then
        Exit( TConfiguration.Colors.FError )
      else
        Exit( $122EFF{TColorRec.Magenta} );
    Critical:
      if Assigned( TConfiguration.Colors ) then
        Exit( TConfiguration.Colors.FCritical )
      else
        Exit( $771DFF{TColorRec.Fuchsia} );
    Emergency:
      if Assigned( TConfiguration.Colors ) then
        Exit( TConfiguration.Colors.FEmergency )
      else
        Exit( $FF40AA{TColorRec.Gainsboro} );
    DLL:
      if Assigned( TConfiguration.Colors ) then
        Exit( TConfiguration.Colors.FDLL )
      else
        Exit( $FFAE1F{TColorRec.Gold} );
    DoubleDLL:
      if Assigned( TConfiguration.Colors ) then
        Exit( TConfiguration.Colors.FDoubleDLL )
      else
        Exit( $FFC556{TColorRec.Royalblue} );
  end;
end;

function TileTypeToString(const TileType: TTileType): TTileTypeString;
begin
  case TileType of
    TTileTypeRec.MasterColored: Exit( 'Colored' );
    TTileTypeRec.MasterValued: Exit( 'Valued' );
    TTileTypeRec.MasterProgressive: Exit( 'Progressive' );
    TTileTypeRec.Detail: Exit( 'Detail' );
  end;
end;

function StrToTileType(const S: TTileTypeString): TTileType;
var
  TileType: TTileType;
begin
  Result := TTileTypeRec.MasterColored;
  for TileType := Low( TTileType ) to High( TTileType ) do begin
    if SameText( S, TileTypeToString( TileType ) ) then
      Exit( TileType );
  end;
end;

{ TTileColorRec }

constructor TTileColorRec.Create(const TileColor: TTileColor);
begin
  Self := TTileColorRec( TileColor );
end;

constructor TTileColorRec.Create(const TileColorIndex: TTileColorIndex);
begin
  Self := TTileColorRec( TTileColor( TileColorIndex ) );
end;

{ TTileColors }

constructor TTileColors.Create(const Debug, Trace, Info, Notice, Warning, Error,
  Critical, Emergency, DLL, DoubleDLL: TColor);
begin
  FDebug := Debug;
  FTrace := Trace;
  FInfo := Info;
  FNotice := Notice;
  FWarning := Warning;
  FError := Error;
  FCritical := Critical;
  FEmergency := Emergency;
  FDLL := DLL;
  FDoubleDLL := DoubleDLL;
end;

end.
