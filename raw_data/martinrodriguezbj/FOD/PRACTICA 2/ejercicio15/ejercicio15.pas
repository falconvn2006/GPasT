program ejercicio15;
Uses sysutils;
const
    dimF=2;
    valorAlto=32000;
type
    datos = record
        dni_alumno:integer;
        codigo_carrera:integer;
        monto_total_pagado:integer;
    end;

    rapiPago = record
        dni_alumno:integer;
        codigo_carrera:integer;
        monto_cuota:integer;
    end;

    maestro=file of datos;
    detalle=file of rapiPago;
    arch_det=array[1..dimF]of file of rapiPago;
    reg_det=array[1..dimF]of rapiPago;

procedure inicioDetalles(var det:arch_det);
var
    i:integer;
begin
  for i:=1 to dimF do begin
    assign(det[i],'detalle'+intToStr(i)+'.dat');
    reset(det[i]);
  end; 
end;

procedure leer (var archivo:detalle;var datos:rapiPago);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.dni_alumno:=valorAlto;
end;

procedure minimo(var regd:reg_det;var min:rapiPago;var det:arch_det);
var
  i,est:integer;
begin
 est:=0;
 min.dni_alumno:=valorAlto;
 min.codigo_carrera:=valorAlto;
 for i:=1 to dimF do begin
      if (regd[i].dni_alumno<min.dni_alumno) or ((regd[i].dni_alumno=min.dni_alumno) and (regd[i].codigo_carrera<min.codigo_carrera)) then begin
         min:=regd[i];
         est:=i;
      end;
   end;
   leer(det[est],regd[est]);
end; 

procedure actualizarMaestro(var mae:maestro;var det:arch_det);
var
    regD:reg_det;
    min:rapiPago;
    regM:datos;
    dni,codCa,montoTotal,i:integer;
begin
  for i:=1 to 2 do begin
    leer(det[i],regD[i]);
  end;
  read(mae,regM);
  minimo(regD,min,det);
  while (min.dni_alumno<>valorAlto)do begin
    dni:=min.dni_alumno;
    codCa:=min.codigo_carrera;
    montoTotal:=0;
    while (min.dni_alumno=dni) and (min.codigo_carrera=codCa)do begin
      montoTotal:=montoTotal+min.monto_cuota;
      //writeln('dniMin: ',min.dni_alumno,' codCarreraMin: ',min.codigo_carrera);
      minimo(regD,min,det);
    end;
    while(regM.dni_alumno<>dni) or (regM.codigo_carrera<>codCa)do begin
      read(mae,regM);
      //writeln('dniMae: ',regM.dni_alumno,' codCarreraMae: ',regM.codigo_carrera);
    end;
    seek(mae,FilePos(mae)-1);
    regM.monto_total_pagado:=regM.monto_total_pagado+montoTotal;
    write(mae,regM);
  end;
  close(mae); close(det[1]); close(det[2]);
end;

procedure informe(var mae:maestro);
var
    regM:datos;
    informe:text;
begin
  reset(mae);
  Assign(informe,'informe.txt'); Rewrite(informe);
  while not eof(mae)do begin
    read(mae,regM);
    if (regM.monto_total_pagado=0) then
      writeln(informe,regM.dni_alumno,' ',regM.codigo_carrera,' ','alumno moroso');
  end;
  close(mae);
  close(informe);
end;

var
    mae:maestro;
    det:arch_det;
begin
  Assign(mae,'maestro.dat'); reset(mae);
  inicioDetalles(det);
  actualizarMaestro(mae,det);
  informe(mae);
end.