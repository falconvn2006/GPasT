program ejercicio1;
const 
valorAlto=32000;
type
  empleado = record
    cod:integer;
    nombre:string[20];
    montoComision:integer;
  end;
  archivo_empleados= file of empleado;

procedure leer (var archivo:empleados;var datos:empleado);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.cod:=valorAlto;
end;

var
  empleados,resEmpleados:archivo_empleados;
  rEmp:empleado;
  cod,totComision:integer;
begin
  assign(empleados,'empleados');
  assign(resEmpleados,'resEmpleados');
  reset(empleados);
  rewrite(resEmpleados);
  leer(empleados,rEmp);
  while(rEmp.cod<>valorAlto) do begin
     cod:=rEmp.cod;
     totComision:=0;
     while (rEmp.cod=cod) do begin
        totComision:=totComision+rEmp.montoComision;
        leer(empleados,rEmp);
  end;
  rEmp.montoComision:=totComision;
  write(resEmpleados,rEmp);
end;
close(empleados);
close(resEmpleados);
end.
end;

