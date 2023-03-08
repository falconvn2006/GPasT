Program ApproxPi(input,output);
{*This program has a function for generating pseudo-random numbers then obtain an approximation to p *}
{*Written by Clinton Ogada v1*}
uses crt;

var
  num_attempts, num_hits, i: integer;
  x, y: real;

begin
  randomize;
  clrscr;

  writeln('Approximating pi using Monte Carlo simulation...');
  write('Enter number of attempts: ');
  readln(num_attempts);

  num_hits := 0;

  for i := 1 to num_attempts do
  begin
    x := random;
    y := random;

    if sqr(x - 0.5) + sqr(y - 0.5) <= 0.25 then
      num_hits := num_hits + 1;
  end;

  writeln('Number of hits: ', num_hits);
  writeln('Approximation of pi: ', 4 * num_hits / num_attempts:0:6);
  readln;
end.
