Program CalculateDistance(input,output);
{*This program to calculates the distance between two given points on the earth's surface*}
uses math;
const
  EarthRadius = 6371.0; // Earth's radius in km
var
  lat1, lon1, lat2, lon2, dLat, dLon, a, c, distance: real;

function ToRadians(degrees: real): real;
begin
  ToRadians := degrees * PI / 180.0;
end;

begin
  // Input latitude and longitude of point 1
  write('Enter latitude of point 1 in degrees: ');
  readln(lat1);
  write('Enter longitude of point 1 in degrees: ');
  readln(lon1);

  // Input latitude and longitude of point 2
  write('Enter latitude of point 2 in degrees: ');
  readln(lat2);
  write('Enter longitude of point 2 in degrees: ');
  readln(lon2);

  // Convert latitude and longitude to radians
  lat1 := ToRadians(lat1);
  lon1 := ToRadians(lon1);
  lat2 := ToRadians(lat2);
  lon2 := ToRadians(lon2);

  // Calculate the differences in latitude and longitude
  dLat := lat2 - lat1;
  dLon := lon2 - lon1;

  // Calculate the Haversine formula
  a := power(sin(dLat/2), 2) + cos(lat1) * cos(lat2) * power(sin(dLon/2), 2);
  c := 2 * arctan2(sqrt(a), sqrt(1-a));
  distance := EarthRadius * c;

  // Output the distance in km
  writeln('The distance between the two points is ', distance:0:2, ' km.');
end.
