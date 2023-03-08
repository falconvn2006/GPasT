type
Node = record
value: Integer;
next: ^Node;
end;
List = ^Node;

var
head: List;
min, max: Integer;

procedure CreateList(var head: List);
var
inputValue: Integer;
lastNode, newNode: List;
begin
head := nil;
lastNode := nil;
write('Введите числа: (Введите 0 чтобы остановиться): ');
 read(inputValue);
 while (inputValue <> 0) do
begin
new(newNode);
newNode^.value := inputValue;
newNode^.next := nil;
if (head = nil) then begin
head := newNode;
end else begin
lastNode^.next := newNode;
end;
lastNode := newNode;
read(inputValue);
end;
end;

procedure FindMinMax(head: List; var minValue: Integer; var maxValue: Integer);
var
current: List;
begin
current := head;
min := current^.value;
max := current^.value;
current := current^.next;
while (current <> nil) do begin
if (current^.value < min) then begin
min := current^.value;
end;
if (current^.value > max) then begin
max := current^.value;
end;
current := current^.next;
end;
end;

begin
CreateList(head);
FindMinMax(head, min, max);
writeln('MIN: ', min);
writeln('MAX: ', max);
end.