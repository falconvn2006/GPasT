unit Utils;

interface

uses Math;

const CODE_PRECISION_NORMAL = 10;
const CODE_PRECISION_EXTRA  = 11;
const LATITUDE_MAX = 90;
const LONGITUDE_MAX = 180;

type
  TCodeArea = class
    private
      latitudeLo: Double;
      longitudeLo: Double;
      latitudeHi: Double;
      longitudeHi: Double;
      codeLength: Double;
    published
      constructor Create(latitudeLo, longitudeLo, latitudeHi, longitudeHi, codeLength: Double);
    public
      latitudeCenter: Double;
      longitudeCenter: Double;
      function getLatitudeHeight():Double;
      function getLongitudeWidth():Double;
  end;


implementation

{ TCodeArea }

constructor TCodeArea.Create(latitudeLo, longitudeLo, latitudeHi, longitudeHi, codeLength: Double);
begin
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

end.
