program ejercicio2;
type
    fech = record
        a:integer;
        m:integer;
        d:integer;
    end;
    empleados = record
        cod:integer;
        apellido:string[30];
        nombre:string[20];
        dni:string[20];
      {  dire:string[20];
        tel:string[20];
        fecha:fech; }
    end;
    maestro = file of empleados;

procedure crearMaestro(var mae:maestro);
var
    regm:empleados;
begin
  assign(mae,'maestro'); Rewrite(mae);
  writeln('Ingresar cod empleado');  readln(regm.cod);
  while (regm.cod<>00)do begin
    writeln('Ingresar apellido del empleado'); readln(regm.apellido);
    writeln('Ingresar nombre del empleado'); readln(regm.nombre);
    writeln('Ingresar dni del empleado'); readln(regm.dni);
    write(mae,regm);
    writeln('Ingresar cod empleado');  readln(regm.cod);
  end;
  close(mae);
end;

procedure bajaLogica(var mae:maestro);
var
    regm:empleados;
begin
    reset(mae);
    while not eof(mae) do begin
        read(mae,regm);
            if (regm.dni<'8000000')then begin
                regm.nombre:='*'+regm.nombre;
                seek(mae,FilePos(mae)-1);
                write(mae,regm);
            end;
    end;
    close(mae);
end;

var
    mae:maestro;
    regm:empleados;
begin
  //crearMaestro(mae);
  assign(mae,'maestro');
  //bajaLogica(mae);
  reset(mae);
  while not eof(mae)do begin
    read(mae,regm);
    if (regm.nombre[1]<>'*')then
        writeln('cod: ',regm.cod,'-nombre: ',regm.nombre);
  end;
end.