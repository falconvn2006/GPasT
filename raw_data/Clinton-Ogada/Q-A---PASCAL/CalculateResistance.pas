Program Resistance(input,output);
{*The program is to calculate the total resistance of three resistors written by Clinton Ogada v.1 2/20/2023*}
var
R,x,r1,r2,r3: Real;
begin
  { Read in the values of the three resistors }
  writeln('Enter the values of the three resistors:');
  readln(r1, r2, r3);
   x:= 1/r1 + 1/r2 + 1/r3;
   R:= 1/x;
   writeln('The total resistance is:', R :0:2);
  readln
end.
