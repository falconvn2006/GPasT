Program ProjectileDistance(input,output);
{*This program calculates the distance that a projectile will travel when fired at velocity V at an angle of elevation of a degrees*}
{*Written by Clinton Ogada v1*}
uses math;
const
  g = 9.81; // Acceleration due to gravity in m/s^2
var
  V, alpha, distance: real;
function ToRadians(degrees: real): real;
begin
  ToRadians := degrees * PI / 180.0;
end;
begin
  // Input velocity and angle of elevation
  write('Enter velocity in m/s: ');
  readln(V);
  write('Enter angle of elevation in degrees: ');
  readln(alpha);
  // Convert angle of elevation to radians
  alpha := ToRadians(alpha);

  // Calculate distance using the formula
  distance := (power(V, 2) * sin(2*alpha)) / g;
  // Output the distance in meters
  writeln('The projectile will travel a distance of ', distance:0:2, ' meters.');
end.
