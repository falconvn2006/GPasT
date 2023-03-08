program KnuthPermute;

const
  MAXN = 100;

var
  a: array[1..MAXN] of integer;
  n, i: integer;

procedure swap(var x, y: integer);
var
  temp: integer;
begin
  temp := x;
  x := y;
  y := temp;
end;

procedure permute(l, r: integer);
var
  i, j: integer;
begin
  if l = r then
  begin
    for i := 1 to n do
      write(a[i], ' ');
    writeln;
  end
  else
  begin
    for i := l to r do
    begin
      swap(a[l], a[i]);
      permute(l+1, r);
      swap(a[l], a[i]);
    end;
  end;
end;

begin
  { read input }
  write('Enter n: ');
  readln(n);

  { initialize array }
  for i := 1 to n do
    a[i] := i;

  { generate permutations }
  permute(1, n);
end.

