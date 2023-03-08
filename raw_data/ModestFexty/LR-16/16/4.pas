procedure FakeFor(s:string; i:integer; n: integer);
begin
writeln(s);
if i<n then FakeFor(s,i+1,n);
end;
begin
FakeFor('Привет',1,5);
end.