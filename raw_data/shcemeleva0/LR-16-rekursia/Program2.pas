var x: integer;
   function sumTo (a: integer): integer;
   begin
        if (a<=1) then
          a:=1
        else
          a:=a+(sumTo(a-1));
   sumTo:=a;
end;
begin
writeln('¬ведите n');
readln(x);
writeln(sumTo(x));
end.