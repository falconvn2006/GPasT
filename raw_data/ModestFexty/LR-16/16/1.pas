procedure abc (n : integer);
  begin
  
  if n >= 0 then begin 
  write(n,' ');
  abc(n - 2);
  end;
  end;
begin
abc(25);
write(0);
end.