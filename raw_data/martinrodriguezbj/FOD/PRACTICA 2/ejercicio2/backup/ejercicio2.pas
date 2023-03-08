program ejercicio2;
Uses crt, sysutils;
const
  valorAlto=32000;
type
  alumno = record
    cod:integer;
    apellido:string[20];
    nombre:string[20];
    cantCursadas:integer;
    cantFinales:integer;
  end;

  alumnoDet = record
    cod:integer;
    mat:string[20];
    estado:string[20];
  end;

  maestro = file of alumno;
  detalle = file of alumnoDet;

procedure crearMaestro(var mae1:maestro);
var
alumnos:text;
a:alumno;
begin
 assign(alumnos,'alumnos.txt');
 reset(alumnos);
 rewrite(mae1);
 while not eof(alumnos) do begin
   readln(alumnos,a.cod,a.apellido);
   a.apellido:=Trim(a.apellido);
   readln(alumnos,a.cantCursadas,a.cantFinales,a.nombre);
   a.nombre:=Trim(a.nombre);
   write(mae1,a);
end;
 close(alumnos);
 close(mae1);
 writeln('Archivo maestro creado exitosamente');
end;

procedure crearDetalle(var det1:detalle);
var
detalle:text;
a:alumnoDet;
begin
 assign(detalle,'detalle.txt');
 reset(detalle);
 rewrite(det1);
 while not eof(detalle) do begin
   readln(detalle,a.cod,a.mat);
   a.mat:=Trim(a.mat);
   readln(detalle,a.estado);
   a.estado:=Trim(a.estado);
   write(det1,a);
end;
 close(detalle);
 close(det1);
 writeln('Archivo detalle creado exitosamente');
end;

procedure listarMaestro(var mae1:maestro);
var
 reporteAlumnos:text;
 a:alumno;
begin
 reset(mae1);
 assign(reporteAlumnos,'reporteAlumnos.txt');
 rewrite(reporteAlumnos);
 while not eof(mae1) do begin
   read(mae1,a);
   writeln(reporteAlumnos,a.cod,' ',a.apellido);
   writeln(reporteAlumnos,a.cantCursadas,' ',a.cantFinales,' ',a.nombre);
 end;
 close(mae1);
 close(reporteAlumnos);
 writeln('Listado de archivo maestro creado exitosamente');
end;

procedure listarDetalle(var det1:detalle);
var
 reporteDetalle:text;
 a:alumnoDet;
begin
 reset(det1);
 assign(reporteDetalle,'reporteDetalle.txt');
 rewrite(reporteDetalle);
 while not eof(det1) do begin
   read(det1,a);
   writeln(reporteDetalle,a.cod,' ',a.mat);
   writeln(reporteDetalle,a.estado);
 end;
 close(det1);
 close(reporteDetalle);
 writeln('Listado de archivo detalle creado exitosamente');
end;

procedure leer(var archivo:detalle;var dato:alumnoDet);
begin
 if not eof(archivo) then
    read(archivo,dato)
 else
     dato.cod:=valorAlto;
end;

procedure actualizarMaestro(var mae1:maestro;var det1:detalle);
var
 regm:alumno;
 regd:alumnoDet;
 aux,cantCursadas,cantFinales:integer;
begin
  reset(mae1);
  reset(det1);
  read(mae1,regm);
  leer(det1,regd);
  while(regd.cod<>valorAlto) do begin
     aux:=regd.cod;
     cantCursadas:=0;
     cantFinales:=0;
     while (aux=regd.cod) do begin
        if (regd.estado='cursada') then begin
           cantCursadas:=cantCursadas+1;
           end;
        if (regd.mat='final') then
           cantFinales:=cantFinales+1;
        leer(det1,regd);
        end;
     while (regm.cod<>aux) do
       read(mae1,regm);

     regm.cantCursadas:=regm.cantCursadas+cantCursadas;
     regm.cantFinales:=regm.cantFinales+cantFinales;

     seek(mae1,filepos(mae1)-1);
     write(mae1,regm);
    end;
  close(mae1);
  close(det1);
  writeln('Actualizacion realizada con exito');
end;

procedure listAlumAdeudante(var mae1:maestro);
var
 a:alumno;
 aux:integer;
 adeudantes:text;
begin
 assign(adeudantes,'adeudantes.txt');
 rewrite(adeudantes);
 reset(mae1);
 while not eof(mae1) do begin
    read(mae1,a);
    aux:=a.cantCursadas-a.cantFinales;
    if (aux>4) then begin
          writeln(adeudantes,a.cod,' ',a.apellido);
          writeln(adeudantes,a.cantCursadas,' ',a.cantFinales,' ',a.nombre);
    end;
 end;
 close(adeudantes);
 close(mae1);
 writeln('Lista creada de manera exitosa');
end;

var
  regm:alumno;
  regd:detalle;
  mae1:maestro;
  det1:detalle;
  opcion:integer;
begin
  opcion:=1;
  while (opcion<>0) do begin
  writeln('--------');
  writeln('1-Crear archivo maestro');
  writeln('2-Crear archivo detalle');
  writeln('3-Listar el contenido del archivo maestro en un archivo de texto llamado reporteAlumnos.txt');
  writeln('4-Listar el contenido del archivo detalle en un archivo de texto llamado reporteDetalle.txt');
  writeln('5-Actualizar el archivo maestro con los archivos detalles');
  writeln('6-Listar en un archivo de texto los alumnos que tengan más de cuatro materias con cursada aprobada pero no aprobaron el final');
  writeln('--------');
  readln(opcion);
  case (opcion) of
  1:begin
    assign(mae1,'maestro');
    crearMaestro(mae1);
    end;
  2:begin
    assign(det1,'detalle');
    crearDetalle(det1);
  end;
  3:begin
    listarMaestro(mae1);
    end;
  4:begin
    listarDetalle(det1);
    end;
  5:begin
    actualizarMaestro(mae1,det1);
    end;
  6:begin
    listAlumAdeudante(mae1);
    end;
  end;
  end;
  readln();
end.

