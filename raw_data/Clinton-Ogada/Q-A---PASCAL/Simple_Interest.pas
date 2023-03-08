Program Simple_Interest(input,output);
{*The program is to calculate the amount of interest on a given sum over a given period of time written by Clinton Ogada v.1 2/20/2023*}
const r = 8/100;
var
I,P,T: Real;
begin
  writeln ('Enter the principal:');
   Readln (P);
    writeln ('Enter the time in years:');
   Readln (T);
    I:= P*R*T;
   writeln('The interest is:', I :0:2);
  readln
end.
