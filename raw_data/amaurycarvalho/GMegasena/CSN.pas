unit CSN;

{$MODE Delphi}
{
       Criado por Amaury Carvalho (amauryspires@gmail.com), 2019
}

interface

uses SysUtils, Classes, Math;

type
  TCSN = class
  public
    elementCount, combineCount: integer;
    combineTotal: double;
    combineData: array of integer;

    constructor Create(elemCount, combCount: integer);

    function Fatorial(n: integer): double;
    function Combine(n, r: integer): double;
    function mdc(a, b: double): double;
    //function Power(x, n: double): double;
    function GetFractionForm(a, b: double): string;

    function GetCSN(): double;
    procedure SetCSN(csn: double);
    procedure Sort();

    function GetCombination(): string;
    procedure SetCombination(s: string);

    function GetTheoreticalProbability(): double;
    function GetTheoreticalProbability(element, position: integer): double;
    function GetTheoreticalProbabilityFractionForm(
      element, position: integer): string;
    function GetTheoreticalProbabilityDelay(probability: double;
      delay: integer): double;
    function GetTheoreticalProbabilityAdvance(probability: double;
      advance: integer): double;
    function GetTheoreticalProbabilityDistribution(p_win: double;
      n_trials, k_wins: integer): double;
  end;

implementation

constructor TCSN.Create(elemCount, combCount: integer);
begin

  elementCount := elemCount;
  combineCount := combCount;
  combineTotal := Combine(elementCount, combineCount);

  SetLength(combineData, combCount + 1);
end;

function TCSN.Fatorial(n: integer): double;
var
  f: double;
  i: integer;
begin

  f := 1;
  if n > 0 then
    for i := 1 to n do
      f := f * i;

  Result := f;

end;

function TCSN.Combine(n, r: integer): double;
var
  f1, f2: double;
  i, k: integer;
  s: double;
begin
  s := 0;
  if n >= r then
  begin
    f2 := 1;
    if r > 0 then
      for i := 1 to r do
        f2 := f2 * i;
    f1 := 1;
    k := (n - r + 1);
    for i := k to n do
      f1 := f1 * i;
    s := f1 / f2;
  end;
  Result := s;
end;

function TCSN.mdc(a, b: double): double;
var
  c: double;
begin

  if (a > 1) and (b > 1) then
  begin
    while a <> b do
    begin
      if a > b then
      begin
        if b > 0 then
          c := int(a / b)
        else
          c := 1;
        c := b * c;
        if c >= a then
          a := b
        else
          a := a - c;
      end
      else
      begin
        if a > 0 then
          c := int(b / a)
        else
          c := 1;
        c := a * c;
        if c >= b then
          b := a
        else
          b := b - c;
      end;
    end;
  end
  else
    a := 1;

  Result := a;
end;

function TCSN.GetCSN(): double;
var
  x: double;
  k, i: integer;
begin
  Sort;
  x := 0;
  for i := 1 to combineCount do
  begin
    k := elementCount - combineData[combineCount - i + 1];
    if k >= i then
      x := x + combine(k, i);
  end;
  Result := combineTotal - x;
end;

procedure TCSN.SetCSN(csn: double);
var
  ncsn, x: double;
  k, i: integer;
begin
  if csn > combineTotal then
    csn := combineTotal;
  ncsn := combineTotal - csn;
  k := elementCount + 1;
  for i := combineCount downto 1 do
  begin
    repeat
      k := k - 1;
      if k >= 1 then
        x := combine(k, i)
      else
        x := 0;
    until x <= ncsn;
    ncsn := ncsn - x;
    combineData[combineCount - i + 1] := elementCount - k;
  end;
  if ncsn >= 0 then
    combineData[combineCount] := combineData[combineCount] - trunc(ncsn);
end;

procedure TCSN.Sort;
var
  i, k, s: integer;
begin
  for i := 1 to combineCount - 1 do
    for k := i + 1 to combineCount do
    begin
      if combineData[i] > combineData[k] then
      begin
        s := combineData[i];
        combineData[i] := combineData[k];
        combineData[k] := s;
      end;
    end;
end;

function TCSN.GetTheoreticalProbability(element, position: integer): double;
begin
  Result := Combine(element - 1, position - 1) * Combine(
    elementCount - element, combineCount - position) / combineTotal;
end;

function TCSN.GetFractionForm(a, b: double): string;
var
  c: double;
  s: string;
const
  million = 10000;
begin
  c := mdc(a, b);
  if c > 0 then
  begin
    a := a / c;
    b := b / c;
    if (a > million) or (b > million) then
      s := '~' + GetFractionForm(int((a / b) * million), million)
    else
      s := FloatToStr(a) + '/' + FloatToStr(b);
  end
  else
    s := '0';
  Result := s;
end;

function TCSN.GetTheoreticalProbabilityFractionForm(element, position: integer): string;
var
  a, b: double;
begin
  a := Combine(element - 1, position - 1) * Combine(elementCount -
    element, combineCount - position);
  b := combineTotal;
  Result := GetFractionForm(a, b);
end;

function TCSN.GetTheoreticalProbabilityDelay(probability: double;
  delay: integer): double;
begin
  Result := power(1 - probability, delay) * probability;
end;

function TCSN.GetTheoreticalProbabilityAdvance(probability: double;
  advance: integer): double;
begin
  Result := power(probability, advance) * (1 - probability);
end;

function TCSN.GetCombination(): string;
var
  s: string;
  i: integer;
begin
  s := '';
  for i := 1 to combineCount do
  begin
    s := s + IntToStr(combineData[i]);
    if i <> combineCount then
      s := s + ', ';
  end;
  Result := s;
end;

procedure TCSN.SetCombination(s: string);
var
  i, j, t, b: integer;
begin
  i := 0;
  b := 0;
  t := length(s);
  for j := 1 to t do
  begin
    case s[j] of
      '0': b := b * 10;
      '1': b := b * 10 + 1;
      '2': b := b * 10 + 2;
      '3': b := b * 10 + 3;
      '4': b := b * 10 + 4;
      '5': b := b * 10 + 5;
      '6': b := b * 10 + 6;
      '7': b := b * 10 + 7;
      '8': b := b * 10 + 8;
      '9': b := b * 10 + 9;
      ';',
      ',':
      begin
        if i < combineCount then
        begin
          if b <= elementCount then
          begin
            i := i + 1;
            combineData[i] := b;
          end;
          b := 0;
        end;
      end;
    end;
  end;
  if (b > 0) and (i < combineCount) then
  begin
    i := i + 1;
    combineData[i] := b;
  end;

end;

function TCSN.GetTheoreticalProbability(): double;
begin
  Result := combineCount / elementCount;
end;

{
function TCSN.Power(x, n: double): double;
begin
  result := exp(n * ln(x));
end;
}

function TCSN.GetTheoreticalProbabilityDistribution(p_win: double;
  n_trials, k_wins: integer): double;
var
  q_lost: double;
begin
  q_lost := 1 - p_win;
  Result := Combine(n_trials, k_wins) * Power(p_win, k_wins) * power(q_lost, n_trials - k_wins);
end;

end.
