program ej2;
type
  ArchivodeEnteros = file of integer;


procedure mostrar(var Enteros:ArchivodeEnteros);
var
  aux:integer;
begin
  writeln('-Muestro numeros-');
  reset(Enteros);
  while not eof(Enteros) do begin
    read(Enteros,aux);
    writeln('Numero: ',aux);
  end;
  close(Enteros);
end;

procedure MayoresYPromedio(var Enteros:ArchivodeEnteros;var prom:double;var mayores:integer);
var
  aux,total,cant:integer;
begin
  total:=0;
  cant:=0;
  mayores:=0;
  reset(Enteros);
  while not eof(Enteros) do begin
    read(Enteros,aux);
    total:=total+aux;
    cant:=cant+1;
    if (aux>1500) then
       mayores:=mayores+1;
  end;
  prom:=total/cant;
  close(Enteros);
end;

var
  Enteros: ArchivodeEnteros;
  archivoAProcesar: String[12];
  num,mayores: integer;
  prom:double;
begin
  writeln('Ingresar el nombre del archivo a procesar');
  readln(archivoAProcesar);
  assign(Enteros,archivoAProcesar); {anlace entre nombre logico y nombre fisico}
  reset(Enteros); {apertura del archivo para la creacion}
  mostrar(Enteros);
  MayoresYPromedio(Enteros,prom,mayores);
  writeln('Promedio: ',prom);
  writeln('Mayores a 1500: ',mayores);
  readln();
  close(Enteros);
end.
