program ejercicio16;
Uses sysutils;
const
    dimF=3;
    valorAlto=32000;
type
    fech = record
        dia:integer;
        mes:integer;
        anio:integer;
    end;
    seminario = record
        fecha:fech;
        cod:integer;
        nom:string[30];
        desc:string[30];
        prec:integer;
        tot:integer;
        totVend:integer;
    end;
    seminarioDet = record
        fecha:fech;
        cod:integer;
        totVend:integer;
    end;
    maestro=file of seminario;
    detalle=file of seminarioDet;
    arch_detalle=array [1..dimF]of file of seminarioDet;
    reg_det=array [1..dimF]of seminarioDet;

procedure asignoMaestroYleo(var mae:maestro;var regM:seminario);
begin
  assign(mae,'maestro.dat'); 
  reset(mae);
  read(mae,regM)
end;

procedure asignoDetalleYleo(var det:arch_detalle;var regD:reg_det);
var 
    i:integer;
begin
  for i:=1 to dimF do begin
    assign(det[i],'detalle'+intToStr(i)+'.dat'); 
    reset(det[i]);
    read(det[i],regD[i]);
  end;
end;

procedure leer (var archivo:detalle;var datos:seminarioDet);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.cod:=valorAlto;
end;

procedure minimo(var regd:reg_det;var min:seminarioDet;var det:arch_detalle);
var
  i,est:integer;
begin
 est:=0;
 min.fecha.dia:=valorAlto; min.fecha.mes:=valorAlto; min.fecha.anio:=valorAlto;
 min.cod:=valorAlto;
 for i:=1 to dimF do begin
      if (regd[i].fecha.anio<min.fecha.anio) or ((regd[i].fecha.anio=min.fecha.anio) and (regd[i].fecha.mes<min.fecha.mes)) 
         or ((regd[i].fecha.anio=min.fecha.anio) and (regd[i].fecha.mes=min.fecha.mes) and (regd[i].fecha.dia<min.fecha.dia) 
         or ((regd[i].fecha.anio=min.fecha.anio) and (regd[i].fecha.mes=min.fecha.mes) and (regd[i].fecha.dia=min.fecha.dia) and (regd[i].cod<min.cod))) then begin
         min:=regd[i];
         est:=i;
      end;
   end;
   leer(det[est],regd[est]);
end; 

procedure actualizarMaestro(var mae:maestro;var det:arch_detalle;regM:seminario;regD:reg_det);
var
    mayorVentas,menorVentas:seminario;
    min:seminarioDet;
    cod,totalVendido,i,masVendido,menosVendido:integer;
    ok:boolean;
begin
  masVendido:=-32000; menosVendido:=32000;
  ok:=false;
  minimo(regD,min,det);
  while(min.cod<>valorAlto)do begin
    cod:=min.cod;
    totalVendido:=0;
    while (min.cod=cod)do begin
      totalVendido:=totalVendido+min.totVend;
     // writeln('vendido: ',min.totVend);
      minimo(regD,min,det);
    end;
    while (regM.cod<>cod)do begin
      read(mae,regM);
    end;
 //   writeln('Total vendido: ',totalVendido,'-total disp: ',regM.tot);
    if (regM.tot>totalVendido)then begin
      ok:=true;
      regM.tot:=regM.tot-totalVendido;
      regM.totVend:=regM.totVend+totalVendido;
      if(totalVendido>masVendido)then begin
        masVendido:=totalVendido;
        mayorVentas:=regM;
      end;
      if(totalVendido<menosVendido)then begin
        menosVendido:=totalVendido;
        menorVentas:=regM;
      end;
      seek(mae,FilePos(mae)-1);
      write(mae,regM);
    end;
  end;
  if (ok)then begin
  WriteLn('cod seminario con mas ventas: ',mayorVentas.cod,'-ano: ',mayorVentas.fecha.anio,'-mes: ',mayorVentas.fecha.mes,'-dia: ',mayorVentas.fecha.dia);
  WriteLn('cod seminario con menos ventas: ',menorVentas.cod,'-ano: ',menorVentas.fecha.anio,'-mes: ',menorVentas.fecha.mes,'-dia: ',menorVentas.fecha.dia);
  end;
  close(mae);
  for i:=1 to dimF do begin
    close(det[i]);
  end;
end;

var
    mae:maestro;
    det:arch_detalle;
    regM:seminario;
    regD:reg_det;
begin
    asignoMaestroYleo(mae,regM);
    asignoDetalleYleo(det,regD);
    actualizarMaestro(mae,det,regM,regD);
  // reset(mae);
  // while not eof(mae)do begin
   //  read(mae,regM);
   //  writeln('Nombre:',regM.nom,'-cantidad disponible: ',regM.tot,'-cantidad vendida: ',regM.totVend,'precio: ',regM.prec);
  //end;
end.
