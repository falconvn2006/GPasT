program ej7;
type
  novelas= record
    cod:integer;
    precio:integer;
    genero:string[30];
    nombre:string[30];
  end;
  archivo_novelas= file of novelas;


procedure crearArchivo(var archivo:archivo_novelas);
var
  novela:text;
  n:novelas;
  nombre:string;
begin
  assign(archivo,'archivoBinario');
  rewrite(archivo);
  assign(novela,'novelas.txt');
  reset(novela);
  while not eof(novela) do begin
    readln(novela,n.cod,n.precio,n.genero);
    readln(novela,n.nombre);
    write(archivo,n);
  end;
  writeln('Archivo creado correctamente');
  close(novela);
  close(archivo);
end;

procedure agregarNovela(var archivo:archivo_novelas);
var
  n:novelas;
begin
  reset(archivo);
  seek(archivo,filesize(archivo));
  writeln('Ingresar cod novela'); readln(n.cod);
  writeln('Ingresar precio novela'); readln(n.precio);
  writeln('Ingresar genero novela'); readln(n.genero);
  writeln('Ingresar nombre novela'); readln(n.nombre);
  write(archivo,n);
  close(archivo);
end;

var
  archivo:archivo_novelas;
  opcion:integer;
begin
  crearArchivo(archivo);
  writeln('Si desea ingrar una nueva novela presione 1');
  writeln('Si desea editar una novela presione 2');
  readln(opcion);
  case(opcion)of
  1:agregarNovela(archivo);
  end;
  readln();
end.

