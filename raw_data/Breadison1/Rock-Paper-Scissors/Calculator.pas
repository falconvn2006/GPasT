program Calculator;

var
  num1, num2, result: real;
  op: char;

begin
  write('Введите первое число: ');
  readln(num1);
  
  write('Введите второе число: ');
  readln(num2);
  
  write('Введите знак (+, -, *, /): ');
  readln(x);
  
  case x of
    '+': result := num1 + num2;
    '-': result := num1 - num2;
    '*': result := num1 * num2;
    '/': result := num1 / num2;
  end;
  
  writeln('Результат: ', result:0:2);
  
  readln;
end.
