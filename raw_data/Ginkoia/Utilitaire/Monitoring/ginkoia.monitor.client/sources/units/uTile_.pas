unit uTile;

interface

uses
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Entropy.TPanel.Paint;

type
  TTileUid = type String;
  TTileTag = type String;

  TTileColorInt = type ShortInt;
  TTileColor = (None, Debug, Trace, Info, Notice, Warning, Error, Critical, Emergency, DLL, DoubleDLL );
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
    constructor Create(const TileColorInt: TTileColorInt); overload;
    case SmallInt of
      0: ( TileColor: TTileColor );
  end;
  TTileValueInt = type Integer;
  TTileValueInt64 = type Int64;
  TTileValueString = type String;
  TTileValueStringArray = TArray< String >;

  TTile = class;
  TTileClass = class of TTile;

  TTileRequest = class
    FTyp: TTileType;
    FUid: TTileUid;
    FTag: TTileTag;
    constructor Create(const &Type: TTileType ; const Uid: TTileUid;
      const Tag: TTileTag); reintroduce;
  end;

  TTileResponse = class
  public
    procedure Processing(const Tile: TTile); virtual; abstract;
  end;

  TTileResponseColored = class( TTileResponse )
    FTag: TTileTag;
    FColor: TTileColorInt;
    constructor Create(const Tag: TTileTag;
      const Color: TTileColorInt); reintroduce;
    procedure Processing(const Tile: TTile); override;
  end;

  TTileResponseProgressive = class( TTileResponseColored )
    FMin, FMax, FValue: TTileValueInt;
    constructor Create(const Tag: TTileTag; const Color: TTileColorInt;
      const Min, Max, Value: TTileValueInt); reintroduce;
    procedure Processing(const Tile: TTile); override;
  end;

  TTileResponseValued = class( TTileResponseColored )
    FValues: TTileValueStringArray;
    constructor Create(const Tag: TTileTag; const Color: TTileColorInt;
      const Values: TTileValueStringArray); reintroduce;
  end;

  TTileDetailLogid = type String;
  TTileDetailHostname = type String;
  TTileDetailApplication = type String;
  TTileDetailInstance = type String;
  TTileDetailServer = type String;
  TTileDetailModule = type String;
  TTileDetailDossier = type String;
  TTileDetailReference = type String;
  TTileDetailKey = type String;
  TTileDetailValue = type String;
  TTileDetailLevel = type String;

  TTileResponseDetail = class( TTileResponse )
    FLogid: TTileDetailLogid;
    FHost: TTileDetailHostname;
    FApp: TTileDetailApplication;
    FInst: TTileDetailInstance;
    FSrv: TTileDetailServer;
    FMdl: TTileDetailModule;
    FDos: TTileDetailDossier;
    FRef: TTileDetailReference;
    FKey: TTileDetailKey;
    FVal: TTileDetailValue;
    FLvl: TTileDetailLevel;
    constructor Create(const Logid: TTileDetailLogid;
      const Hostname: TTileDetailHostname;
      const Application: TTileDetailApplication;
      const Instance: TTileDetailInstance; const Server: TTileDetailServer;
      const Module: TTileDetailModule; const Dossier: TTileDetailDossier;
      const Reference: TTileDetailReference; const Key: TTileDetailKey;
      const Value: TTileDetailValue;
      const Level: TTileDetailLevel); reintroduce;
  end;

//  TTileResponseDetails = class( TTileResponse )
//    HiddenField: TArray< TTileResponseDetail >;
//  end;

  TTile = class( TPanel )
  private const
    cUrl = '/index.php';
    function GetBgColor: TTileColor;
    function GetTag: TTileTag;
  private
    FType: TTileType;
    FTag: TLabel;
    FColor: TTileColor;
    procedure SetBgColor(const Value: TTileColor);
    procedure SetTag(const Value: TTileTag);
    procedure SetType(const Value: TTileType);
  protected
    procedure Processing(const Response: TTileResponse);
  public
    { constructor / destructor }
    constructor Create(const Tag: TTileTag;
      const &Type: TTileType = TTileTypeRec.MasterColored); reintroduce;
    { methods }
    procedure Update(const Uid: TTileUid);
    { properties }
    property &Type: TTileType read FType write SetType;
    property Tag: TTileTag read GetTag write SetTag;
    property BgColor: TTileColor read GetBgColor write SetBgColor;
  end;

implementation

{ TTileColorRec }

uses
  uHttp, System.UITypes;

constructor TTileColorRec.Create(const TileColor: TTileColor);
begin
  Self := TTileColorRec( TileColor );
end;

constructor TTileColorRec.Create(const TileColorInt: TTileColorInt);
begin
  Self := TTileColorRec( TileColorInt );
end;

{ TTileRequest }

constructor TTileRequest.Create(const &Type: TTileType; const Uid: TTileUid;
  const Tag: TTileTag);
begin
  FTyp := &Type;
  FUid := Uid;
  FTag := Tag;
end;

{ TTile }

constructor TTile.Create(const Tag: TTileTag; const &Type: TTileType);
begin
  FTag := Tag;
  FType := &Type;
end;

function TTile.GetBgColor: TTileColor;
begin
  s
end;

function TTile.GetTag: TTileTag;
begin

end;

procedure TTile.Processing(const Response: TTileResponse);
begin
  if Assigned( Response ) then
    Response.Processing( Self );
end;

procedure TTile.SetBgColor(const Value: TTileColor);
begin
  Color := TColors.Red;
end;

procedure TTile.SetTag(const Value: TTileTag);
begin
//  F
end;

procedure TTile.SetType(const Value: TTileType);
begin
  FType := Value;
end;

procedure TTile.Update(const Uid: TTileUid);
var
  Request: TTileRequest;
  Response: TTileResponse;
begin
  try
    Request := TTileRequest.Create( Ftype, Uid, FTag );
    try
      case FType of
        TTileTypeRec.MasterColored:
          Response := THttp.Query< TTileResponseColored, TTileRequest >( Request, cUrl );
        TTileTypeRec.MasterValued:
          Response := THttp.Query< TTileResponseValued, TTileRequest >( Request, cUrl );
        TTileTypeRec.MasterProgressive:
          Response := THttp.Query< TTileResponseProgressive, TTileRequest >( Request, cUrl );
//        TTileTypeRec.Detail:
//          Response := THttp.Query< TTileResponseDetails, TTileRequest >( Request, cUrl );
        else
          Exit;
      end;
      Processing( Response );
    finally
      Request.Free;
    end;
  except
    // Silence is golden
  end;
end;

{ TTileResponseColored }

constructor TTileResponseColored.Create(const Tag: TTileTag;
  const Color: TTileColorInt);
begin
  FTag := Tag;
  FColor := Color;
end;

procedure TTileResponseColored.Processing(const Tile: TTile);
begin
  inherited;
//  Tile.
end;

{ TTileResponseProgressive }

constructor TTileResponseProgressive.Create(const Tag: TTileTag;
  const Color: TTileColorInt; const Min, Max, Value: TTileValueInt);
begin
  inherited Create( Tag, Color );
  FMin := Min;
  FMax := Max;
  FValue := Value;
end;

procedure TTileResponseProgressive.Processing(const Tile: TTile);
begin
  inherited;

end;

{ TTileResponseValued }

constructor TTileResponseValued.Create(const Tag: TTileTag;
  const Color: TTileColorInt; const Values: TTileValueStringArray);
begin
  inherited Create( Tag, Color );
  FValues := Values;
end;

{ TTileResponseDetail }

constructor TTileResponseDetail.Create(const Logid: TTileDetailLogid;
  const Hostname: TTileDetailHostname;
  const Application: TTileDetailApplication;
  const Instance: TTileDetailInstance; const Server: TTileDetailServer;
  const Module: TTileDetailModule; const Dossier: TTileDetailDossier;
  const Reference: TTileDetailReference; const Key: TTileDetailKey;
  const Value: TTileDetailValue; const Level: TTileDetailLevel);
begin
  FLogid := Logid;
  FHost := Hostname;
  FApp := Application;
  FInst := Instance;
  FSrv := Server;
  FMdl := Module;
  FDos := Dossier;
  FRef := Reference;
  FKey := Key;
  FVal := Value;
  FLvl := Level;
end;

end.
