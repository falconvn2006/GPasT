unit CodeArea;

interface

uses Math;

const CODE_PRECISION_NORMAL = 10;
const CODE_PRECISION_EXTRA  = 11;
const LATITUDE_MAX = 90;
const LONGITUDE_MAX = 180;

type
  TCodeArea = class
    private

    FlatitudeHi: Double;
    FlatitudeLo: Double;
    FlongitudeHi: Double;
    FlongitudeLo: Double;
    FcodeLength: Double;
    procedure SetlatitudeHi(const Value: Double);
    procedure SetlatitudeLo(const Value: Double);
    procedure SetlongitudeHi(const Value: Double);
    procedure SetlongitudeLo(const Value: Double);
    procedure SetcodeLength(const Value: Double);
    published
      constructor Create(latitudeLo, longitudeLo, latitudeHi, longitudeHi, codeLength: Double);
    public
      latitudeCenter: Double;
      longitudeCenter: Double;
      function getLatitudeHeight():Double;
      function getLongitudeWidth():Double;
      property latitudeLo : Double read FlatitudeLo write SetlatitudeLo;
      property longitudeLo: Double read FlongitudeLo write SetlongitudeLo;
      property latitudeHi : Double read FlatitudeHi write SetlatitudeHi;
      property longitudeHi: Double read FlongitudeHi write SetlongitudeHi;
      property codeLength: Double read FcodeLength write SetcodeLength;
  end;


implementation

{ TCodeArea }

constructor TCodeArea.Create(latitudeLo, longitudeLo, latitudeHi, longitudeHi, codeLength: Double);
begin
   FlatitudeLo := latitudeLo;
   FlongitudeLo:= longitudeLo;
   FlatitudeHi := latitudeHi;
   FlongitudeHi:= longitudeHi;
   FcodeLength := codeLength;
   latitudeCenter  := Math.min(latitudeLo + (latitudeHi - latitudeLo) / 2, LATITUDE_MAX);
   longitudeCenter := Math.min(longitudeLo + (longitudeHi - longitudeLo) / 2, LONGITUDE_MAX);
end;

function TCodeArea.getLatitudeHeight: Double;
begin
   Result := latitudeHi - latitudeLo;
end;

function TCodeArea.getLongitudeWidth: Double;
begin
   Result := longitudeHi - longitudeLo;
end;

procedure TCodeArea.SetcodeLength(const Value: Double);
begin
  FcodeLength := Value;
end;

procedure TCodeArea.SetlatitudeHi(const Value: Double);
begin
  FlatitudeHi := Value;
end;

procedure TCodeArea.SetlatitudeLo(const Value: Double);
begin
  FlatitudeLo := Value;
end;

procedure TCodeArea.SetlongitudeHi(const Value: Double);
begin
  FlongitudeHi := Value;
end;

procedure TCodeArea.SetlongitudeLo(const Value: Double);
begin
  FlongitudeLo := Value;
end;

end.
