Program FahrenHeitToCelcius(input,output);
{*The program is to input temperature in Fahrenheit and convert it to Degrees Centigrade written by Clinton Ogada v.1 2/20/2023*}
const fahrenheit = 32;
const y = 5/9;
var
x,celcius: Real;
begin
  writeln ('Enter the temperature in Fahrenheit');
   Readln (x);
   celcius:= (x - fahrenheit) * y;
   writeln('the temperature is', celcius :2:2);
  readln
end.
