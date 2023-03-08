program ejercicio4;
Uses sysutils;
const
    valorAlto='ZZZZ';
type
    tTitulo=string[50];

    tArchRevistas=file of tTitulo;

procedure leer (var archivo:tArchRevistas;var datos:tTitulo);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos:=valorAlto;
end;

procedure inicioArchivo(var mae:tArchRevistas);
var
    titulo:tTitulo;
begin
  
  Assign(mae,'maestro'); 
  Rewrite(mae);
  titulo:='0';
  write(mae,titulo);
  close(mae);
end;

procedure agregar(var mae:tArchRevistas;titulo:string);
var
    pos:integer;
    t:tTitulo;
begin
    reset(mae);
    read(mae,t);
    pos:=StrtoInt(t)*-1;
    if (pos<>0)then begin
        seek(mae,pos);
        read(mae,t);
        seek(mae,pos);
        write(mae,titulo);
        seek(mae,0);
        write(mae,t);
    end
        else begin
            seek(mae,filesize(mae));
            write(mae,titulo);
        end;
  close(mae);
end;

procedure eliminar(var mae:tArchRevistas;titulo:string);
var
    t,tAux:tTitulo;
    pos:integer;
begin
    reset(mae);
    read(mae,tAux);
    leer(mae,t);
    while (t<>valorAlto) and (t<>titulo)do begin
    leer(mae,t);
    end;
    if (t<>valorAlto)then begin
      seek(mae,FilePos(mae)-1);
      pos:=FilePos(mae)*-1;
      write(mae,tAux);
      seek(mae,0);
      t:=intToStr(pos);
      write(mae,t);
  end;
  close(mae);
end;

procedure mostrar(var mae:tArchRevistas);
var
    t:tTitulo;
begin
  reset(mae);
  while not eof(mae)do begin
    read(mae,t);
    writeln('Nombre: ',t);
  end;
end;

procedure informarArchivo(var mae:tArchRevistas);
var
    t:tTitulo;
    v,cod:integer;
begin
  reset(mae);
  while not eof(mae)do begin
    read(mae,t);
    Val(t,v,cod);
    if (cod<>0)then
      writeln('Nombre: ',t);
  end;
  close(mae);
end;

var
    mae:tArchRevistas;
    titulo:string;
begin
  //inicioArchivo(mae);
  assign(mae,'maestro');
  mostrar(mae);
  writeln('---------');
  //writeln('Ingresar el nombre de la novela a agregar'); readln(titulo);
  //agregar(mae,titulo);
  writeln('Ingresar el nombre de la novela a eliminar'); readln(titulo);
  eliminar(mae,titulo);
  informarArchivo(mae);
end.