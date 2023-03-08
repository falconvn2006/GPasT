var a,b,c:integer;
procedure row(n:integer);
begin
     if c >=1 then begin
       c:=a mod b;
        write (c, ' ');
        a:=b;
        b:=c;
        row(c)
     end;
     writeln('НОД равен ', a);
     readln
end;
begin
  readln(a,b);
  c:=1;
    row(c);
end.