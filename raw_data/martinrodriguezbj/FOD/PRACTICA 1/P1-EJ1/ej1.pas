program ej1;
type
  ArchivodeEnteros = file of integer;
var
  Enteros: ArchivodeEnteros;
  nombreArchivo: String[12];
  num: integer;
begin
  writeln('Ingresar el nombre del archivo');
  readln(nombreArchivo);
  assign(Enteros,nombreArchivo); {anlace entre nombre logico y nombre fisico}
  rewrite(Enteros); {apertura del archivo para la creacion}
  writeln('Ingresar numero'); readln(num);
  while (num<>3000) do begin
     write(Enteros,num);
     writeln('Ingresar numero'); readln(num);
  end;

  close(Enteros);
end.

