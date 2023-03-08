program ejercicio1;
type
  empleados = record
    num:integer;
    apellido:string[20];
    nombre:string[20];
    edad:integer;
    dni:integer;
  end;

  archivodeEmpleados= file of empleados;

procedure mostrar(var empleados:archivodeEmpleados);
var
  emp:empleados;
begin
  writeln('-Muestro empleados-');
  reset(empleados);
  while not eof(empleados) do begin
    read(empleados,emp);
    writeln('nombre: ',emp.nombre);
    writeln('apellido: ',emp.apellido);
    writeln('num: ',emp.num);
    writeln('Ingrear edad: ',emp.edad);
    writeln('Ingresar dni: ',emp.dni);
    writeln('-------------');
  end;
  close(empleados);
end;

procedure mayores(var empleados:archivodeEmpleados);
var
  emp:empleados;
begin
  writeln('-Muestro empleados mayores a 70-');
  reset(empleados);
  while not eof(empleados) do begin
    read(empleados,emp);
    if (emp.edad>70) then begin
      writeln('nombre: ',emp.nombre);
      writeln('apellido: ',emp.apellido);
      writeln('num: ',emp.num);
      writeln('Ingrear edad: ',emp.edad);
      writeln('Ingresar dni: ',emp.dni);
      writeln('-------------');
    end;
  end;
  close(empleados);
end;

var
  Empleado: archivodeEmpleados;
  emp,emp2: empleados;
  ape,nombreArchivo:string;
  opcion,edad,num:integer;
  txt,faltaDNIEmpleado:text;

begin
  writeln('Ingrese el nombre del archivo a trabajar');
  readln(nombreArchivo);
  assign (Empleado,nombreArchivo); {hago la asignacion de el nombre logico con el fisico}
  opcion:=1;
  while(opcion<>0) do begin
  writeln('MENU DE ARCHIVOS');
  writeln('Ingrese 1 si desea crear un nuevo archivo');
  writeln('Ingrese 2 si desea listar en pantalla los datos de empleados que tengan un apellido determinado');
  writeln('Ingrese 3 si desea listar en pantalla los empleados de a uno por linea');
  writeln('Ingrese 4 si desea listar en pantalla los empleados mayores a 70 años');
  writeln('Ingrese 5 si desea añadir uno o mas empleados al final del archivo');
  writeln('Ingrese 6 si desea modificar la edad a uno o mas empleados');
  writeln('Ingrese 7 si desea Exportar el contenido del archivo a otro');
  writeln('Ingrese 8 si desea exportar a un archivo los empleados que no tienen documento');
  writeln('Ingrese 9 si desea realizar la baja fisica de un empleado');
  readln(opcion);

  case(opcion)of
  1:begin
      rewrite(Empleado);
      writeln('ingresar apellido del empleado'); readln(emp.apellido);
      while (emp.apellido<>'fin') do begin
            writeln('Ingresar nombre'); readln(emp.nombre);
            writeln('Ingresar num'); readln(emp.num);
            writeln('Ingrear edad'); readln(emp.edad);
            writeln('Ingresar dni'); readln(emp.dni);
            write(Empleado,emp);
            writeln('ingresar apellido del empleado'); readln(emp.apellido);
      end;
      close(Empleado);
    end;
  2:begin
      reset(Empleado);
      writeln('Ingresar el apellido de un empleado a buscar'); readln(ape);
      while not eof (Empleado) do begin
          read(Empleado,emp);
          if (emp.apellido=ape) then begin
             writeln('nombre: ',emp.nombre);
             writeln('apellido: ',emp.apellido);
             writeln('num: ',emp.num);
             writeln('edad: ',emp.edad);
             writeln('dni: ',emp.dni);
          end;
      end;
      close(Empleado);
    end;
  3:begin
    mostrar(Empleado);
    end;
  4:begin
    mayores(Empleado);
    end;
  5:begin
      reset(Empleado);
      seek(Empleado,filesize(Empleado));
      writeln('ingresar apellido del empleado'); readln(emp.apellido);
      while (emp.apellido<>'fin') do begin
            writeln('Ingresar nombre'); readln(emp.nombre);
            writeln('Ingresar num'); readln(emp.num);
            writeln('Ingrear edad'); readln(emp.edad);
            writeln('Ingresar dni'); readln(emp.dni);
            write(Empleado,emp);
            writeln('ingresar apellido del empleado'); readln(emp.apellido);
      end;
      close(Empleado);
    end;
  6:begin
      writeln('Ingrese el numero del empleado al que se le cambiara la edad'); readln(num);
      reset(Empleado);
      while not eof(Empleado) do begin
          read(Empleado,emp);
          if (emp.num=num) then begin
             writeln('Ingrese la edad a editarle'); readln(edad);
             emp.edad:=edad;
             seek(Empleado,filepos(Empleado)-1);
             write(Empleado,emp);
          end;
      end;
      close(Empleado);
    end;
  7:begin
      writeln('COMENZANDO A EXPORTAR');
      assign(txt,'todos_empleados.txt');
      rewrite(txt);
      reset(Empleado);
      while not eof(Empleado) do begin
          writeln('ENTRE');
          read(Empleado,emp);
          write(txt,emp.apellido);
          write(txt,emp.dni);
          write(txt,emp.edad);
          write(txt,emp.nombre);
          write(txt,emp.num);
      end;
      writeln('EXPOTACION REALIZADA CORRECTAMENTE');
      close(Empleado);
      close(txt);
    end;
  8:begin
      writeln('COMENZANDO A EXPORTAR');
      reset(Empleado);
      assign(faltaDNIEmpleado,'faltaDNIEmpleado.txt');
      rewrite(faltaDNIEmpleado);
      while not eof(Empleado)do begin
            read(Empleado,emp);
            if (emp.dni=00) then begin
               write(faltaDNIEmpleado,emp.apellido);
               write(faltaDNIEmpleado,emp.dni);
               write(faltaDNIEmpleado,emp.edad);
               write(faltaDNIEmpleado,emp.nombre);
               write(faltaDNIEmpleado,emp.num);
            end;
      end;
      writeln('EXPOTACION REALIZADA CORRECTAMENTE');
      close(Empleado);
      close(faltaDNIEmpleado); 
    end;
   9:begin
         writeln('Ingresar numero del empleado a eliminar'); readln(num);
         reset(Empleado);
         seek(Empleado,FileSize(Empleado)-1);
         read(Empleado,emp);

         seek(Empleado,0);
         read(Empleado,emp2);
         while(emp2.num<>num) do begin
             read(Empleado,emp2);
         end;
         seek(Empleado,FilePos(Empleado)-1);
         write(Empleado,emp);
         seek(Empleado,FileSize(Empleado)-1);
         Truncate(Empleado);
         writeln('Baja realizada exitosamente');
     end;
  end;
 end;
  readln();
end.