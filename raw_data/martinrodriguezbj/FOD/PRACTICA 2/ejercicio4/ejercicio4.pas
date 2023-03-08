program ejercicio4;
const
  dimF=3;
  valorAlto=32000;
type
  logM = record
    cod:integer;
    fecha:integer;
    tiempo_total_de_sesiones_abiertas:integer;
    end;

  log = record
    cod:integer;
    fecha:integer;
    tiempo:integer;
    end;

    detalle= file of log;
    maestro= file of logM;
    arch_detalle=array[1..dimF] of file of log;
    reg_detalle=array[1..dimF] of log;

procedure leer(var archivo:detalle;var dato:log);
begin
  if not eof(archivo) then
     read(archivo,dato)
  else
      dato.cod:=valorAlto;
end;

procedure crearDetalles(var archivo:arch_detalle);
var
  i:integer;
  l:log;
begin
  i:=1;
  assign(archivo[1],'log1');
  assign(archivo[2],'log2');
  assign(archivo[3],'log3');
  while (i<=3) do begin
    writeln('-Creando detalle ',i,'-');
    rewrite(archivo[i]);
    writeln('Ingresar codigo'); read(l.cod);
    while (l.cod<>00) do begin
      writeln('Ingresar fecha'); read(l.fecha);
      writeln('Ingresar tiempo'); read(l.tiempo);
      write(archivo[i],l);
      writeln('Ingresar codigo'); read(l.cod);
    end;
    close(archivo[i]);
    i:=i+1;
end;
WriteLn('Carga de detalles realizada exitosamente');
end;

procedure minimo(var reg_det:reg_detalle;var min:log;var deta:arch_detalle);
var
  i,est:integer;
begin
 est:=0;
 min.cod:=valorAlto;
 min.fecha:=32;
 for i:=1 to 3 do begin
      if (reg_det[i].cod<min.cod) or ((reg_det[i].cod = min.cod) and (reg_det[i].fecha < min.fecha)) then begin
         min:=reg_det[i];
         est:=i;
      end;
   end;
 if (min.cod<>valorAlto) then begin
   leer(deta[est],reg_det[est]);
   end;
end; 

var
 det1:arch_detalle;
 regd:reg_detalle;
 min:log;
 mae1:maestro;
 regm:logM;
 i:integer;
begin
WriteLn('Realizar la carga de los archivos detalles');
crearDetalles(det1);
Assign(mae1,'C:\Users\Diego\Desktop\FACULTAD\TERCER SEMESTRE\FOD\EJERCICIOS PASCAL\PRACTICA 2\ejercicio4\var\log');
Rewrite(mae1);
for i:=1 to 3 do begin
  reset(det1[i]);
  read(det1[i],regd[i]);
end;
minimo(regd,min,det1);
while (min.cod<>valorAlto)do begin
  regm.cod:=min.cod;
  while ((min.cod<>valorAlto ) and (regm.cod=min.cod)) do begin
    regm.fecha:=min.fecha;
    regm.tiempo_total_de_sesiones_abiertas:=0;
    while ((min.cod<>valorAlto ) and (regm.cod=min.cod) and (regm.fecha=min.fecha)) do begin
      regm.tiempo_total_de_sesiones_abiertas:=regm.tiempo_total_de_sesiones_abiertas+min.tiempo;
      writeln('Codigo minimo: ',min.cod);
      WriteLn('Fecha: ',min.fecha);
      minimo(regd,min,det1);
    end;
    write(mae1,regm);
    regm.cod:=min.cod;
  end;
end;
for i:=1 to 3 do begin
  close(det1[i]);
end;
reset(mae1);
while not eof (mae1) do begin
  read(mae1,regm);
  writeln('Codigo: ',regm.cod,'-Fecha: ',regm.fecha,'-Total: ',regm.tiempo_total_de_sesiones_abiertas);
end;
close(mae1);
end.    