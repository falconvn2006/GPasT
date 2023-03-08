Program simultaneous(input,output);
{This program calculates the values x and y given a1, b1,c1, a2, b2 and c2 as inputs*}
{*c1 = a1x + b1y*}
{*c2 = a2x + b2y*}
{*Written by Clinton Ogada*}
var
  a1, b1, c1, a2, b2, c2, x, y, determinant: real;
begin
  writeln('Enter the coefficients and constants of the equations:');
  readln(a1, b1, c1);
  readln(a2, b2, c2);
  determinant := a1 * b2 - a2 * b1;
     x := ((- b1 * c2) + (b2 * c1 )) / determinant;
    y := ((- a2 * c1) + (a1 * c2)) / determinant;
    writeln('The solution is: x = ', x:0:2, ', y = ', y:0:2);
    readln;
end.
