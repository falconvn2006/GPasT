procedure row(n:integer);
begin
     if n >=0 then begin
        write (n, ' ');
        row(n-2)
     end;
     if n <0 then write (0);
end;
begin
    row(25);
end.