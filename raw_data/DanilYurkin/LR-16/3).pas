var x,y: integer;
function stepen (a,b: integer):integer;
var xx:real;
begin
  if y>=1 then begin
  xx:=x**y;
  y:=y-1;
  writeln(xx);
  stepen(x,y);
  end;
end;
begin
  writeln('число?');
  readln(x);
  writeln('степень?');
  readln(y);
  writeln(stepen(x,y));
end.