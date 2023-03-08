type PNode = ^Node; 
     Node = record
       data: integer;
       next: PNode;
     end; 

procedure Push( var Head: PNode; x: integer);
var NewNode: PNode;
begin
  New(NewNode);          
  NewNode^.data := x;    
  NewNode^.next := Head; 
  Head := NewNode;
end;

function Pop ( var Head: PNode ): integer;
var q: PNode;
begin
  if Head = nil then begin
    Result := integer(255); 
    Exit;
  end;
  Result := Head^.data; 
  q := Head;             
  Head := Head^.next; 
  Dispose(q);         
end;

function Stack ( S: PNode ): Boolean;
begin
  Result := (S = nil);
end;

var S: PNode;
f,g:text;
i,j:integer;

begin
  S := nil;
  assign(f,'C:\PABCWork.NET\privet.txt');
  reset(f);
  while not eof(f)
  do begin
    read(f,i);
    Push(S,i);
  end;
  close(f);
  assign(g,'C:\PABCWork.NET\poka.txt');
  rewrite(g);
  while s <> nil do
  begin
    j:=Pop(s);
    write(g,' ');
    write(g,j);
  end;
  close(g);
end.