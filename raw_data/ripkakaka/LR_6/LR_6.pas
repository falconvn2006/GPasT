const
  StackSize = 10;
  
type
  tStack = record
    empty, full : Boolean;
    count : Integer;
    a : array [0..StackSize-1] of Integer;
  end;
  
procedure Push(n : Integer; var s : tStack);
begin
  s.a[s.count] := n; inc(s.count); s.empty := False; s.full := s.count = StackSize;
end;
 
function Pop(var s : tStack) : Integer;
begin
  dec(s.count); s.empty := s.count = 0; s.full := False; Pop := s.a[s.count];
end;   
 
procedure Init(var s : tStack);
begin
  s.empty := True; s.full := False; s.count := 0;
end;
 
var
  Stack : tStack;
  i : Integer;
begin
  Init(Stack);
  for i := 1 to 12 do
    if Not Stack.full then
      begin WriteLn('Добавляем в стек ', i); Push(i, Stack); end
    else
      WriteLn('Стек полон. Добавить ', i, ' нельзя!');
  Write('Извлекаем из стека:'); while Not Stack.empty do Write(#32, Pop(Stack)); WriteLn;
  WriteLn('Всё. Стек пуст.');
end.
