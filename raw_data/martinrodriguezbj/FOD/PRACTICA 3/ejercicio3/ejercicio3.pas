program ejercicio3;
const
    valorAlto=32000;
type
    novela = record
        cod:integer;
        genero:string[20];
        nombre:string[20];
        duracion:integer;
        director:string[30];
        precio:integer;
    end;

    maestro= file of novela;

procedure leer (var archivo:maestro;var datos:novela);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.cod:=valorAlto;
end;

procedure crearArchivo(var mae:maestro);
var
    n:novela;
begin
  Assign(mae,'maestro');
  Rewrite(mae);
  n.cod:=0; n.genero:=''; n.nombre:=''; n.duracion:=0; n.director:=''; n.precio:=0;
  write(mae,n);
  writeln('Ingresar codigo de novela'); readln(n.cod);
  while (n.cod<>00)do begin
      writeln('Ingresar genero de novela'); readln(n.genero);  
      writeln('Ingresar nombre de novela'); readln(n.nombre);
      writeln('Ingresar duracion de novela'); readln(n.duracion);
      writeln('Ingresar director de novela'); readln(n.director);
      writeln('Ingresar precio de novela'); readln(n.precio);
      write(mae,n);
      writeln('Ingresar codigo de novela'); readln(n.cod);
  end;
  close(mae);
end;

procedure altaNovela(var mae:maestro);
var
    n,nAux,regm:novela;
    pos:integer;
begin
  writeln('Ingresar codigo de novela'); readln(regm.cod);
  writeln('Ingresar genero de novela'); readln(regm.genero);  
  writeln('Ingresar nombre de novela'); readln(regm.nombre);
  writeln('Ingresar duracion de novela'); readln(regm.duracion);
  writeln('Ingresar director de novela'); readln(regm.director);
  writeln('Ingresar precio de novela'); readln(regm.precio);
  reset(mae);
  read(mae,n);
  pos:=n.cod*-1;
  if (n.cod<>0)then begin
     seek(mae,pos);
     read(mae,n);
     seek(mae,pos);
     write(mae,regm);
     seek(mae,0);
     write(mae,n);
  end
    else begin
        seek(mae,filesize(mae));
        write(mae,regm);
    end;
  close(mae);
end;

procedure eliminarNovela(var mae:maestro);
var
    cod,pos:integer;
    n,nAux:novela;
begin
  writeln('Ingresar el codigo de la novela a borrar'); readln(cod);
  reset(mae);
  read(mae,nAux);
  leer(mae,n);
  while (n.cod<>valorAlto) and (n.cod<>cod)do begin
    leer(mae,n);
  end;
  if (n.cod<>valorAlto)then begin
    seek(mae,FilePos(mae)-1);
    pos:=FilePos(mae)*-1;
    write(mae,nAux);
    seek(mae,0);
    nAux.cod:=pos;
    write(mae,nAux);
  end;
  close(mae);
end;

procedure modificarNovela(var mae:maestro);
var 
    cod:integer;
    n:novela;
begin
  writeln('Ingrese el codigo de la novela a modificar'); readln(cod);
  reset(mae);
  while not eof(mae)and(n.cod<>cod)do begin
    read(mae,n);
  end;
  if (n.cod=cod)then begin
      writeln('Ingresar genero de novela'); readln(n.genero);  
      writeln('Ingresar nombre de novela'); readln(n.nombre);
      writeln('Ingresar duracion de novela'); readln(n.duracion);
      writeln('Ingresar director de novela'); readln(n.director);
      writeln('Ingresar precio de novela'); readln(n.precio);
      seek(mae,FilePos(mae)-1);
      write(mae,n);
  end;

end;

procedure mantenimiento(var mae:maestro);
var
opcion:integer;
begin
  writeln('Ingrese 1 si desea dar de alta una novela leyendo la informacion desde teclado'); 
  writeln('Ingrese 2 si desea modificar una novela'); 
  writeln('Ingrese 3 si desea eliminar una novela');
  readln(opcion);
  case (opcion) of
     1:altaNovela(mae);
     2:modificarNovela(mae);
     3:eliminarNovela(mae);
  end;
end;

procedure imprimirArchivo(var mae:maestro);
var
    n:novela;
begin
    reset(mae);
    leer(mae,n);
    while (n.cod<>valorAlto) do begin
        writeln('cod: ',n.cod,'-nombre: ',n.nombre);
        leer(mae,n);
    end;
    close(mae);
end;

procedure listarArchivo(var mae:maestro);
var
    n:novela;
    t:text;
begin
  Assign(t,'lista.txt'); Rewrite(t);
  reset(mae);
  while not eof(mae) do begin
    read(mae,n);
    writeln(t,n.cod,' ',n.genero,' ',n.nombre,' ',n.duracion,' ',n.director,' ',n.precio);
  end;
  close(mae);
  close(t);
end;

var
    opcion:integer;
    mae:maestro;
    n:novela;
begin
    Assign(mae,'maestro');
    WriteLn('Ingrese 1 si desea crear un archivo y cargarlo a partir de datos ingresados por teclado'); 
    WriteLn('Ingrese 2 si desea realizar el mantenimiento del archivo'); 
    writeln('Ingrese 3 si desea listar las novelas en un archivo de texto');
    WriteLn('Ingrese 4 si desea imprimir el archivo'); 
    readln(opcion);
    while (opcion<>0) do begin
        case (opcion) of 
            1:crearArchivo(mae);
            2:mantenimiento(mae);
            3:listarArchivo(mae);
            4:imprimirArchivo(mae);
        end;
        WriteLn('Ingrese 1 si desea crear un archivo y cargarlo a partir de datos ingresados por teclado'); 
        WriteLn('Ingrese 2 si desea realizar el mantenimiento del archivo');
        writeln('Ingrese 3 si desea listar las novelas en un archivo de texto');
        WriteLn('Ingrese 4 si desea imprimir el archivo');
        readln(opcion);
    end;
end.