program TableOfPrimes;
label P2, P3, P4, P5, P6, P9, P10, P11, P12;

const
  L = 500; {The number of primes to find}
  PRINTER = 18; {Unit number of the line printer}
  BUF0 = 2000; {Memory area for BUFFER[0]}
  BUF1 = BUF0 + 25; {Memory area for BUFFER[1]}
type
  A = array[-1..L] of integer; {Memory area for table of primes}

var
  J, N, K, M: integer;
  PRIME: A;

begin
  {Start table}
  J := 1;
  N := 3;

P2:
  {N is prime}
  J := J + 1;
  PRIME[J] := N;

P3:
  {500 found?}
  if J = L then
    goto P9;

P4:
  {Advance N}
  N := N + 2;

P5:
  {K := 2}
  K := 2;

P6:
  {PRIME[K]\N?}
  while PRIME[K] * PRIME[K] <= N do
  begin
    if (N mod PRIME[K]) = 0 then
      goto P4;
    K := K + 1;
  end;

  {Otherwise N is prime}
  goto P2;

P9:
  {Print title}
  writeln('FIRST FIVE HUNDRED PRIMES');
  writeln;
  M := 0;

P10:
  {Set up line (right to left)}
  for K := 1 to 10 do
  begin
    M := M + 1;
    write(PRIME[M]:10);
    if M = J then
      goto P12;
  end;

P11:
  {Switch buffers}
  writeln;
  for K := 1 to 25 do
  begin
    PRIME[K] := PRIME[K] + 10000;
    PRIME[K] := PRIME[K] - 10000;
  end;

  {If rI5 = 0, we are done}
  if M < J then
    goto P10;

P12:
  {End of routine}
end.

