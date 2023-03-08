program Aula1;

uses crt;

var baskaraplus,baskaraminus,baskara,a,b,c,delta:real;

var l:real;

var radius, pi:real;

var distance, gas:real;

var width, height:real;



procedure areaSquare;
begin
writeln('Write the squares side measure');
readln(l);
writeln('the area is:');
writeln(round(l*l));
readkey;
end;



procedure circunferencePerimeter;
begin
writeln('Write the radius of the circunference');
readln(radius);
writeln('Write the pi');
readln(pi);
writeln('the perimeter is:');
writeln(round(radius*2*pi));
readkey;
end;





procedure KmPerL;
begin
writeln('Type the distance (in KM):');
readln(distance);
writeln('Type how much gas you have spent:');
readln(gas);
write('You spent ');
write(round(distance/gas));
write('L per kilometer.');

end;





procedure paintPots;
begin
writeln('Type the witdh of the wall:');
readln(width);
writeln('Type the height of the wall:');
readln(height);
write('It willbe necessary to use ');
write(round((width * height)/3));
write(' pots of paint');
end;






procedure square;
begin
writeln(' ******************* ');
writeln(' ******************* ');
writeln(' ******************* ');
writeln(' ******************* ');
writeln(' ******************* ');
writeln(' ******************* ');
writeln(' ******************* ');
writeln(' ******************* ');
writeln(' ******************* ');
readkey;
end;




procedure triangle;
begin
writeln(' * ');
writeln(' *** ');
writeln(' ***** ');
writeln(' ******* ');
writeln(' ********* ');
writeln(' *********** ');
writeln(' ************* ');
writeln(' *************** ');
writeln(' ***************** ');

readkey;

end;




procedure baskaraFormula;
begin
writeln('type the value for a');

readln(a);

writeln('type the value for b');

readln(b);

writeln('type the value for c');

readln(c);

delta := b*b*a*c;

baskaraplus := (-b + sqrt(delta))/(2*a);

baskaraminus := (-b - sqrt(delta))/(2*a);

writeln('delta is: ');

writeln(round(delta));

writeln('x1 is: ');

writeln(round(baskaraplus));

writeln('x2 is: ');

write(round(baskaraminus));

readkey;
end;


begin
paintPots;
KmPerL;
areaSquare;
circunferencePerimeter;

end.