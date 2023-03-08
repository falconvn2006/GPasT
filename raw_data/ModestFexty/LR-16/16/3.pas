var x,y: integer;
function stepen (a,b: integer):integer;
begin
  if b = 0 then  stepen:=1
  else stepen:= stepen(a,b-1)*a;
  end;
begin
  writeln('число?');
  readln(x);
  writeln('степень?');
  readln(y);
  writeln(stepen(x,y));
end.