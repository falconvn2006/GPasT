procedure fib (count,v,v0:integer);
  begin
       if count=0 then Exit;
       write(v, ' ');
           fib(count-1,v+v0,v);
  end;
begin
  fib(10,1,0);
end.