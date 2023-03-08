program RockScissorsPaper;

uses crt;

const
  Rock = 1;
  Scissors = 2;
  Paper = 3;

var
  PlayerChoice, ComputerChoice: integer;
// функция дающая выбрать игроку
function GetPlayerChoice: integer;
var
  Choice: char;
begin
  repeat
    writeln('Выберите (К)амень(1), (Н)ожницы(2), или (Б)умагу(3) : ');
    readln(Choice);
  until UpCase(Choice) in ['К', 'Н', 'Б'];
  
  case UpCase(Choice) of
    'К': Result := Rock;
    'Н': Result := Scissors;
    'Б': Result := Paper;
  end;
end;
// функция генерирующая случайное число
function GetComputerChoice: integer;
begin
  Randomize;
  Result := Random(3) + 1;
end;
// функция определяющая кто победил
function GetWinner(PlayerChoice, ComputerChoice: integer): string;
begin
  case PlayerChoice of
    Rock:
      case ComputerChoice of
        Rock : Result := 'Ничья';
        Paper: Result := 'Победил Компьютер!';
        Scissors: Result := 'Победил Игрок!';
      end;
    Scissors:
      case ComputerChoice of
        Rock: Result := 'Победил Компьютер!';
        Paper: Result := 'Победил Игрок!';
        Scissors: Result := 'Ничья';
      end;
    Paper:
      case ComputerChoice of
        Rock : Result := 'Победил Игрок!';
        Paper: Result := 'Ничья';
        Scissors: Result := 'Победил Компьютер!';
      end;
  end;
end;

procedure PlayGame;
var
  Winner: string;
begin
  clrscr;
  writeln('|------------------------------------|');
  writeln('|       Камень, Ножницы, Бумага      |');
  writeln('|------------------------------------|');
  PlayerChoice := GetPlayerChoice;
  ComputerChoice := GetComputerChoice;
  Winner := GetWinner(PlayerChoice, ComputerChoice);
  writeln('|________________________|');
  writeln('|Игрок: ', PlayerChoice,'                |');
  writeln('|________________________|');
  writeln('|Компьютер: ', ComputerChoice,'            |');
  writeln('|________________________|');
  if Winner = 'Победил Компьютер!' then
     writeln('|Итог: Победил Компьютер!|')
  else
     if winner = 'Победил Игрок!' then
      writeln('|Итог: Победил Игрок!    |')
     else
       writeln('|Итог: Ничья             |');
  writeln('|________________________|');
  writeln;
end;
begin
  repeat
    PlayGame;
    writeln('Сыграть снова? Нажмите "Д" : ');

  until UpCase(readkey) <> 'Д';
end.