//  Функция, которая считает скалярное произведение 
function CostInPoint(A : array of smallint; W : array of integer; ind: integer): int64;
begin
  Result := 0;
  for var i := 0 to W.High do
    Result += A[i+ind] * W[i];
end;

begin
  assign(input, '107_27_B.txt');
  var N := ReadInteger;
  var A := ArrGen(N, i -> smallint(ReadInteger)); 
  
  //  Строим вектор расстояний от центральной точки до всех остальных
  //  Например, для 10 пунктов этот вектор будет выглядеть таким образом:
  //     4 3 2 1 0 1 2 3 4 5
  //  В предположении, что мусор свозим в 4-й пункт (в центр)
  var center := (N - 1) div 2; //  10 -> 4,  9 -> 4
  var Distances := ArrGen(N, i ->  min(abs(center - i), N - abs(center - i)));
  
  //  Удваиваем массив мусора - для того, чтобы не проверять выход за границы
  //  После этого нам надо будет лишь находить скалярное произведение массива 
  //  расстояний на подмассивы массива с мусором
  
  A := A + A;
  println('Размер входа :', N);
  println('Прогноз по количеству операций : ~', int64(N)*int64(N));
  
  var minCost := int64.MaxValue;
  var count := 0;
  
  //  Цикл распараллеливаем с помощью OpenMP
  {$omp parallel for}
  for var i := 0 to N-1 do
  begin
    var mn := CostInPoint(A, Distances, i);
    //  Это критическая секция - код не должен выполняться параллельно, иначе
    //    можем получить неверное значение минимума
    {$omp critical}
    if minCost > mn then 
      minCost := mn;
    count += 1;
    if i mod 20000 = 999 then
      begin
        var tm := real(N) * MilliSeconds / count / 1000 / 60;
        println(Round(count / N * 100, 2) + '% ; Прогноз : ' + Round(tm, 2) + ' минут');
      end;
  end;
  
  println('Ответ :', 3 * minCost);
  println('Общее время :', Round(Milliseconds / 1000 / 60, 2), 'минут');
  readln;
end.
{
471228, 49113954961677.
3.5 минуты
}