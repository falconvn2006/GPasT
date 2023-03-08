var a, b, c, d: integer;
function NOD(m, n: integer): integer;
var gunther: integer;
begin
gunther := m mod n;
if gunther = 0 then
NOD := n
else
NOD := NOD (n, gunther)
end;
begin
write('Введите числа: ');
readln(a, b);
d := NOD(a, b);
writeln('НОД Евклида = ', d);
end.