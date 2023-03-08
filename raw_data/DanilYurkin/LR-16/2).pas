var k,c,l:integer;
procedure row(n:integer);
begin
     if k <=c then begin
       write (k, ' ');
       l:=l+1;
       K:=K+l;
        row(k)
     end;
end;
begin
  k:=1;
  l:=0;
  readln(c);
    row(c);
end.