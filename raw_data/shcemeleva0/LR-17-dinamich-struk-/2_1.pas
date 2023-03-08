const
  MAX_WORDS = 100000;

type
  TNode = record
    word: string;
    frequency: integer;
    next: ^TNode;
  end;
  PNode = ^TNode;

var
  head, node, prev, newNode: PNode;
  F: Text;
  word: string;
  frequency: integer;
  wordsCount: integer;

procedure CreateNode(var node: PNode; word: string; frequency: integer);
begin
  New(node);
  node^.word := word;
  node^.frequency := frequency;
  node^.next := nil;
end;

procedure AddBefore(var head, node, newNode: PNode);
begin
  if head = nil then
  begin
    head := newNode;
    node := newNode;
  end
  else
  begin
    newNode^.next := node^.next;
    node^.next := newNode;
  end;
end;

function MakePlace(var head, node, prev: PNode; word: string): boolean;
var
  found: boolean;
begin
  found := false;
  while (node <> nil) and not found do
  begin
    if node^.word = word then
    begin
      found := true;
    end
    else
    begin
      prev := node;
      node := node^.next;
    end;
  end;
  MakePlace := found;
end;

begin
  head := nil;
  wordsCount := 0;

  Assign(F, 'C:\Users\2019m\OneDrive\Рабочий стол\2 курс\мдк 05.02 разработка кода информационных систем\лабы\динамические структуры\file.txt');
  Reset(F);
  while not Eof(F) do
  begin
    ReadLn(F, word);
    Inc(wordsCount);
    node := head;
    prev := nil;
    if MakePlace(head, node, prev, word) then
    begin
      node^.frequency := node^.frequency + 1;
    end
    else
    begin
      CreateNode(newNode, word, 1);
      AddBefore(head, prev, newNode);
    end;
  end;
  Close(F);

  WriteLn('Колчиество различных слов: ', wordsCount);
end.