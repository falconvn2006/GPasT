procedure LoopFor(s:string; i:integer; n: integer);
begin
writeln(s);
if i<n then LoopFor(s,i+1,n);
end;
var i:integer;
begin
LoopFor('Привет',1,10);
end.