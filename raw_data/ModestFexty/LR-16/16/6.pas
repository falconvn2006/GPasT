procedure fib(i,n:integer);
begin
  write(i,' ');
  if i >= 21 then Exit;
  
  fib(i+n,i);
end;
 
begin
  fib(1,1);
end.