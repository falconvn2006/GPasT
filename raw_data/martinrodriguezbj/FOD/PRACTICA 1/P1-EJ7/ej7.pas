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

procedure editarNovela(var archivo:archivo_novelas);
var
  cod,opcion:Integer;
  encontre:boolean;
  n:novelas;
begin
  writeln('Ingrese el codigo de la novela que quiera editar'); readln(cod);
  reset(archivo);
  encontre:=false;
  while (not eof(archivo)) and (encontre=false)do begin
    read(archivo,n);
    if (n.cod=cod) then begin
      encontre:=true;
      writeln('Que desea modifica: 1-codigo, 2-precio, 3-genero, 4-nombre'); readln(opcion);
      case(opcion)of
        1:begin
          writeln('Ingresar codigo'); readln(n.cod);
        end;
        2:begin
          writeln('Ingresar precio'); readln(n.precio);
        end;
        3:begin
          writeln('Ingresar genero'); readln(n.genero);
        end;
        4:begin
          writeln('Ingresar nombre'); readln(n.nombre);
        end;
      end;
     seek(archivo,filepos(archivo)-1);
     write(archivo,n);
    end;
  end;
  close(archivo);
end;

var
  archivo:archivo_novelas;
  opcion:integer;
begin
  crearArchivo(archivo);
  while(opcion<>3)do begin
  writeln('Si desea ingrar una nueva novela presione 1');
  writeln('Si desea editar una novela presione 2');
  writeln('Si desea salir presione 3');
  readln(opcion);
  case(opcion)of
  1:agregarNovela(archivo);
  2:editarNovela(archivo);
  end;
  end;
end.

