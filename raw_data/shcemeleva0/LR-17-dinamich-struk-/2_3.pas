type
  node = record
    data: integer;
    next: ^node;
  end;

var
  head, current: ^node;
  max, min: integer;

begin
  new(head);
  current := head;
  current^.data := 5;
  current^.next := nil;
  
  new(current^.next);
  current := current^.next;
  current^.data := 10;
  current^.next := nil;
  
  new(current^.next);
  current := current^.next;
  current^.data := 2;
  current^.next := nil;
  
  current := head;
  max := current^.data;
  min := current^.data;
  while current <> nil do
  begin
    if current^.data > max then
      max := current^.data;
    if current^.data < min then
      min := current^.data;
    current := current^.next;
  end;
  
  writeln('Максимальный элемент в списке: ', max);
  writeln('Минимальный элемент в списке: ', min);
end.