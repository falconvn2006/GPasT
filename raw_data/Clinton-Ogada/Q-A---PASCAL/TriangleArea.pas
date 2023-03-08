Program TriangleArea(input,output);
{*This program calculates the area of a triangle with the points (x1,y1),(x2,y2),(x3,y3) as vertices where A, B, C are the lengths of the sides of the trianlge and S is the semi-perimeter*}
{*area=sqrt(S(S-A)(S-B)(S-C))*}
{*S=1/2(A+B+C)*}
{*Alt Area=1\2 | (x1y2-x2y1) + (x2y3-x3y2) + (x2y1-x1y3)|*}
{*Written by Clinton Ogada*}
var
  x1, y1, x2, y2, x3, y3, a, b, c, s, area: real;
begin
  writeln('enter the cordinates of A:');
  readln(x1, y1);
   writeln('enter the cordinates of B:');
  readln(x2, y2);
   writeln('enter the cordinates of C:');
  readln(x3, y3);
  a := sqrt(sqr(x2 - x1)  + sqr(y2 - y1));
  b := sqrt(sqr(x3 - x2)  + sqr(y3 - y2));
  c := sqrt(sqr(x1 - x3)  + sqr(y1 - y3));
  s := (a + b + c) / 2;
  area := sqrt(s * (s - a) * (s - b) * (s - c));
  writeln('The area of the triangle is: ', area:0:2);
  readln
end.
