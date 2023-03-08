//  Функция, которая посчитает стоимость сбора мусора в пункте index  = 65, а также массы слева и справа от пункат сбора
function CostInPoint(A : array of integer; ind : integer) : int64;
begin
  Result := 0;
  for var i := 0 to A.High do
    Result += 3 * a[i] * min(abs(ind - i), A.Length - abs(ind - i));
end;

begin
  var A := readalltext('107_27_B.txt').ToIntegers[1:]; 
  
  var minCost := int64.MaxValue;

  for var i := 0 to A.High do
    begin
      if i mod 10000 = 100 then
        begin
          var tm := real(A.Length) * MilliSeconds / i / 1000 / 60;
          println(Round(i / A.Length * 100, 2) + '% ; Прогноз : ' + Round(tm/60, 2)+ ' часов');
        end;
      var mn := CostInPoint(A, i);
      if minCost > mn then 
         minCost := mn;
    end;

  println('Ответ :', minCost);
  println('Время :', Round(Milliseconds/1000/60,2), 'минут');
  readln;
end.
{
471228, 49113954961677.
60 минут
}