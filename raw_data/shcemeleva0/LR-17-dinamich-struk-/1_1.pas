var
  i_ptr: ^integer;
  i: integer;
 
begin
  i := 2;
  i_ptr := @i;
  writeln(i_ptr^);
end.