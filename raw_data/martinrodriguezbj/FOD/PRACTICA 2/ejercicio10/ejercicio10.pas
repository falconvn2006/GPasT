program ejercicio10;
Uses sysutils;
const
    valorAlto='ZZZ';
type
    empleados = record
        departamento:string[20];
        division:integer;
        numEmp:integer;
        categ:integer;
        horasExtra:integer;
    end;

    maestro=file of empleados;
    sueldoCategoria=array[1..15]of integer;

procedure cargarMaestro(var mae:maestro);
var
    carga:text;
    regM:empleados;
begin
    Assign(mae,'maestro');
    Rewrite(mae);
    Assign(carga,'carga.txt');
    reset(carga);
    while not eof(carga)do begin
        read(carga,regM.division,regM.numEmp,regM.categ,regM.horasExtra,regM.departamento);
        regM.departamento:=trim(regM.departamento);
        Write(mae,regM);
    end;
    close(mae);
    close(carga);
end;

procedure cargarArreglo(var v:sueldoCategoria);
var
    sueldoCategoria:text;
    cat,sueldo,i:integer;
begin
    i:=1;
    assign(sueldoCategoria,'sueldoCategoria.txt');
    reset(sueldoCategoria);
    while not eof(sueldoCategoria)do begin
      read(sueldoCategoria,cat,sueldo);
      v[i]:=sueldo; i:=i+1;
    end;
    close(sueldoCategoria);
end;

procedure leer (var archivo:maestro;var datos:empleados);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.departamento:=valorAlto;
end;

var
    mae:maestro;
    regM:empleados;
    v:sueldoCategoria;
    i,division,totHorasDiv,totMontoDiv,totHorasDep,totMontoDep,aux:Integer;
    departamento:string;
begin
    cargarMaestro(mae);
    cargarArreglo(v); //cargo el arreglo con el sueldo de categoria por hora
    reset(mae);
    leer(mae,regM);
    while (regM.departamento<>valorAlto)do begin
      writeln('DEPARTAMENTO: ',regM.departamento);
      departamento:=regM.departamento;
      totHorasDep:=0;
      totMontoDep:=0;
      while (regM.departamento=departamento) do begin
        writeln('DIVISION: ',regM.division);
        division:=regM.division;
        totHorasDiv:=0;
        totMontoDiv:=0;
        while (regM.departamento=departamento) and (regM.division=division) do begin
          writeln('Numero de empleado        Total de Hs        Importe a cobrar');
          aux:=regM.horasExtra*v[regM.categ];
          writeln('                 ',regM.numEmp,'                 ',regM.horasExtra,'                 ',aux);
          totHorasDiv:=totHorasDiv+regM.horasExtra;
          totMontoDiv:=totMontoDiv+aux;
          leer(mae,regM);
        end;
        writeln('Total de horas division: ',totHorasDiv);
        writeln('Monto total division: ',totMontoDiv);
        totHorasDep:=totHorasDep+totHorasDiv;
        totMontoDep:=totMontoDep+totMontoDiv;
      end;
      writeln('Total de horas departamento: ',totHorasDep);
      writeln('Monto total departamento: ',totMontoDep);
      writeln('---------------------------------');
    end;
end.
    
    //for i:=1 to 15 do begin
     // writeln('Precio categoria: ',i,': ',v[i]);
    //end;
    