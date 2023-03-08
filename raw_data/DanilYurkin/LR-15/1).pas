type
  Node_ptr = ^Node;
  Node = record
    data: string;
    count: integer;
    Node_next: Node_ptr;
  end;

var
  Node_adr, Node_adr1, counter, Node_new, Node_place1, p: Node_ptr;

var
  F: text;

function TakeWord(F: Text): string;
var
  c: char;
begin
  Result := '';
  c := ' ';
  
  while not eof(f) and (c <= ' ') do
    read(F, c);
 
  while not eof(f) and (c > ' ') do
  begin
    Result := Result + c;
    read(F, c);
  end;
  if eof(f) then Result := Result + c;
end;

function CreateNode(NewWord: string): Node_ptr;
var
  NewNode: Node_ptr;
begin
  New(NewNode);
  NewNode^.data := NewWord;
  NewNode^.count := 1;
  NewNode^.Node_next := nil;
  Result := NewNode;
end;

function Find(Head: Node_ptr; NewWord: string): Node_ptr;
var
  pp: Node_ptr;
begin
  pp := Head;

  while (pp <> nil) and (NewWord <> pp^.data) do
    pp := pp^.Node_next;
  Result := pp;
end;

procedure AddFirst(var Head: Node_ptr; NewNode: Node_ptr);
begin
  NewNode^.Node_next := Head;
  Head := NewNode;
end;

procedure AddAfter(var Head: Node_ptr; NewNode: Node_ptr);
begin
  NewNode^.Node_next := Head^.Node_next;
  Head^.Node_next := NewNode;
end;

procedure AddBefore(var Head: Node_ptr; p, NewNode: Node_ptr);
var
  pp: Node_ptr;
begin
  pp := Head;
  if p = Head then
    AddFirst( Head, NewNode) 
  else begin
    while (pp <> nil) and (pp^.Node_next <> p) do 
      pp := pp^.Node_next;
    if pp <> nil then AddAfter( pp, NewNode);
  end;
end;

function FindPlace(Head: Node_ptr; NewWord: string): Node_ptr;
var
  pp: Node_ptr;
begin
  pp := Head;
  while (pp <> nil) and (NewWord > pp^.data) do
    pp := pp^.Node_next;
  Result := pp;
  
end;

begin
  Node_place1 := nil;
  assign(F, 'text.txt');
  var word_1: string;
  reset(F);
  while not eof(F) do
  begin
    word_1 := TakeWord(F);
    if Find(Node_place1, word_1) <> nil then Find(Node_place1, word_1)^.count := Find(Node_place1, word_1)^.count + 1
    else begin
      Node_new := CreateNode(word_1);
      Node_adr := FindPlace(Node_place1, word_1);
      AddBefore(Node_place1, Node_adr, Node_new);
      
    end;
    
  end;
  close(F);
  Node_adr1 := Node_place1;
  while Node_adr1 <> nil do
  begin
    writeln(Node_adr1^.data, Node_adr1^.count);
    Node_adr1 := Node_adr1^.Node_next;
  end;
  writeln;
end.