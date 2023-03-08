uses Crt;

const
MAX_NODES = 100;

type
TNode = record
data: integer;
next: integer;
prev: integer;
end;

var
head, tail: integer;
nodeArray: array [1..MAX_NODES] of TNode;
nodeCounter: integer;

procedure InsertNode(var head, tail: integer; data: integer);
var
node: integer;
begin
Inc(nodeCounter);
node := nodeCounter;

nodeArray[node].data := data;
nodeArray[node].next := 0;
nodeArray[node].prev := 0;

if head = 0 then
begin
head := node;
tail := node;
end
else
begin
nodeArray[tail].next := node;
nodeArray[node].prev := tail;
tail := node;
end;
end;

procedure DeleteNode(var head, tail: integer; data: integer);
var
node, prevNode, nextNode: integer;
begin
node := head;

while (node <> 0) and (nodeArray[node].data <> data) do
begin
node := nodeArray[node].next;
end;

if node <> 0 then
begin
prevNode := nodeArray[node].prev;
nextNode := nodeArray[node].next;

if prevNode <> 0 then
begin
  nodeArray[prevNode].next := nextNode;
end
else
begin
  head := nextNode;
end;

if nextNode <> 0 then
begin
  nodeArray[nextNode].prev := prevNode;
end
else
begin
  tail := prevNode;
end;

Dec(nodeCounter);
end;
end;

procedure PrintList(head: integer);
var
node: integer;
begin
node := head;

while node <> 0 do
begin
Write(nodeArray[node].data, ' ');
node := nodeArray[node].next;
end;

Writeln;
end;

var
choice: integer;
data: integer;

begin
head := 0;
tail := 0;
nodeCounter := 0;

repeat
Writeln('Введите число: ');
Writeln('1. Ввод данных');
Writeln('2. Удалить данные');
Writeln('3. Напечатать список данных');
Writeln('4. Выход из меню');
Readln(choice);

    case choice of
      1: begin
           Write('Введите данные: ');
           Readln(data);
           InsertNode(head, tail, data);
         end;
      2: begin
           Write('Введите данные: ');
           Readln(data);
           DeleteNode(head, tail, data);
         end;
      3: begin
           Writeln('Список данных:');
           PrintList(head);
         end;
    end;
  until (choice = 4);
end.