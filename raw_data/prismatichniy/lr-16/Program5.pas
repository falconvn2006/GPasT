var a,b:longint;
    f1,f2:Text;
function Nod(x,y:longint):longint;
begin
  if x<>0 then Nod:=Nod(y mod x,x) else Nod:=y;
end;
begin
read(a,b);
writeln(Nod(a,b));
end.