program dkr66;

const
MAX_SIZE = 10;

type
QueueArray = array[1..MAX_SIZE] of integer;

var
 queue: QueueArray;
 front, rear: integer;
 choice, value: integer;

procedure InitializeQueue();
 begin
  front := 0;
  rear := 0;
 end;

function IsEmpty(): boolean;
 begin
  if front = rear then
   IsEmpty := true
  else
   IsEmpty := false;
  end;

function IsFull(): boolean;
 begin
  if rear = MAX_SIZE then
   IsFull := true
  else
   IsFull := false;
  end;

procedure Enqueue(value: integer);
 begin
  if IsFull() then
   writeln('Очередь заполнена.')
  else
    begin
     rear := rear + 1;
     queue[rear] := value;
    end;
  end;

procedure Dequeue();
 begin
  if IsEmpty() then
   writeln('Очередь пуста.')
  else
    begin
     front := front + 1;
    end;
  end;

procedure DisplayQueue();
 var
  i: integer;
   begin
    if IsEmpty() then
     writeln('Очередь пуста.')
    else
      begin
        writeln('Содержимое очереди: ');
      for i := front + 1 to rear do
       begin
        write(queue[i], ' ');
        end;
    writeln();
       end;
      end;

begin
 InitializeQueue();
repeat
writeln('1 - Добавить элементы в очередь');
writeln('2 - Удаление элементов из очереди');
writeln('3 - Показать содержимое очереди');
writeln('4 - Выход');
writeln('Введите что вам необходимо:');
readln(choice);

 case choice of
 1:
  begin
   writeln('Введите значение очереди:');
   readln(value);
   Enqueue(value);
  end;
 2:
  Dequeue();
 3:
  DisplayQueue();
 4:
  writeln('Bye! Bye!');
  end;
 until choice = 4;
end.