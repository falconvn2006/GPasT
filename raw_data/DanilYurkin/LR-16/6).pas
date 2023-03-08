var f1,f2,f3,n:integer;
procedure fib (i,k: integer);
  begin
       writeln (f3,' ');
       if n<=10 then begin
         f3:=f2+f1;
         f1:=f2;
         f2:=f3;
       n:=n+1;
           fib(f1,f2);
           end;
  end;
begin
  f1:=0;
  f2:=1;
  f3:=1;
  n:=1;
  fib(f1,f2);
end.