unit uHistorical;

interface

uses
  uTypes;

type
  THistorical = class;
  THistoricalDetail = class;
  THistoricalDetails = TArray< THistoricalDetail >;

  THistoricalDetail = class
    FDate: TDateString;
    FVal: TValue;
    FLvl: TLevel;
  end;

  THistorical = class
  private const
    cUrl = '/histo.php';
  private type
    TRequest = class
      FUid: TUid;
      FLogid: TLogid;
      constructor Create(const Uid: TUid; const Logid: TLogid); reintroduce;
    end;
    TResponse = class
      FCount: TCount;
      FValues: THistoricalDetails;
    end;
  private
    FLogid: TLogid;
    FCount: TCount;
    FValues: THistoricalDetails;
  public
    { constructor/destructor }
    constructor Create(const Logid: TLogid; const Count: TCount;
      const Values: THistoricalDetails); reintroduce;
    destructor Destroy; override;
    { events }
    class function Get(const Uid: TUid;
      const Logid: TLogid): THistorical; overload;
    { properties }
    property Logid: TLogid read FLogid write FLogid;
    property Count: TCount read FCount write FCount;
    property Values: THistoricalDetails read FValues write FValues;
  end;

implementation

{ THistorical }

uses
  uHttp;

constructor THistorical.Create(const Logid: TLogid; const Count: TCount;
  const Values: THistoricalDetails);
begin
  FLogid := Logid;
  FCount := Count;
  FValues := Values;
end;

destructor THistorical.Destroy;
var
  HistoricalDetail: THistoricalDetail;
begin
  for HistoricalDetail in FValues do
    HistoricalDetail.Free;
  SetLength( FValues, 0 );
  Initialize( FValues[ 0 ] );
  inherited;
end;

class function THistorical.Get(const Uid: TUid;
  const Logid: TLogid): THistorical;
var
  Response: TResponse;
  Request: TRequest;
begin
  try
    Request := TRequest.Create( Uid, Logid );
    try
      try
        Response := THttp.Query< TResponse, TRequest >( Request, cUrl );
        if Assigned( Response ) then
          Exit( THistorical.Create( Logid, Response.FCount, Response.FValues ) )
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

{ THistorical.TRequest }

constructor THistorical.TRequest.Create(const Uid: TUid; const Logid: TLogid);
begin
  FUid := Uid;
  FLogid := Logid;
end;

end.

//{ THistorical.TResponse }
//
//destructor THistorical.TResponse.Destroy;
//var
//  i: Integer;
//begin
//  for i := High( FValues ) downto Low( FValues ) do
//    FValues[ i ].Free;
//  inherited;
//end;
