var pI: ^integer;
begin
  new(pI);
  pI^ := 2;
  writeln('Адрес  ='  , pI); 
  writeln('Значение = ', pI^); 
end.