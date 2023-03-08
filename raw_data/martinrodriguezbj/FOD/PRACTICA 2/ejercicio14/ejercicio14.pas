program ejercicio14;
Uses sysutils;
const
    valorAlto='ZZZ';
type
    fecha=record
        ano:integer;
        mes:integer;
        dia:Integer
    end;
    datos=record
        destino:string[20];
        fech:fecha;
        horaSalida:integer;
        asientosDisp:integer;
    end;

    datosDet=record
        destino:string[20];
        fech:fecha;
        horaSalida:integer;
        asientosComp:integer;
    end;

    maestro=file of datos;
    detalle=file of datosDet;

procedure cargarMaestro(var mae:maestro);
var
    carga:text;
    regM:datos;
begin
    Assign(carga,'carga.txt'); reset(carga);
    Assign(mae,'maestro.dat'); Rewrite(mae);
    while not eof(carga) do begin
      read(carga,regM.fech.ano,regM.fech.mes,regM.fech.dia,regM.horaSalida,regM.asientosDisp,regM.destino);
      regM.destino:=Trim(regM.destino);
      write(mae,regM);
    end;
    close(carga);
    close(mae);
end;

procedure crearDetalle2(var det:detalle);
var
    cargaDet:text;
    regD:datosDet;
begin
    Assign(cargaDet,'cargaDet.txt'); reset(cargaDet);
    Assign(det,'detalle.dat'); Rewrite(det);
    while not eof(cargaDet) do begin
      read(cargaDet,regD.fech.ano,regD.fech.mes,regD.fech.dia,regD.horaSalida,regD.asientosComp,regD.destino);
      regD.destino:=Trim(regD.destino);
      write(det,regD);
    end;
    close(cargaDet);
    close(det);
end;

procedure crearDetalle(var det:detalle);
var
    cargaDet2:text;
    regD:datosDet;
begin
    Assign(cargaDet2,'cargaDet2.txt'); reset(cargaDet2);
    Assign(det,'detalle2.dat'); Rewrite(det);
    while not eof(cargaDet2) do begin
      read(cargaDet2,regD.fech.ano,regD.fech.mes,regD.fech.dia,regD.horaSalida,regD.asientosComp,regD.destino);
      regD.destino:=Trim(regD.destino);
      write(det,regD);
    end;
    close(cargaDet2);
    close(det);
end;

procedure leer (var archivo:detalle;var datos:datosDet);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.destino:=valorAlto;
end;


procedure minimo(var det,det2:detalle;var regD,regD2,min:datosDet);
begin
  if (regD.destino<regD2.destino) or ((regD.destino=regD2.destino) and (regD.fech.ano<regD2.fech.ano) and (regD.fech.mes<regD2.fech.mes) and (regD.fech.mes<regD2.fech.mes) and (regD.horaSalida<regD2.horaSalida)) then begin
    min:=regD;
    leer(det,regD);
  end
    else begin
      min:=regD2;
      leer(det2,regD2);
    end;
end;

var
    mae:maestro;
    regM:datos;
    det,det2:detalle;
    regD,regD2,min:datosDet;
    destino:string;
    ano,mes,dia,hora,totVendido,cant:integer;
    lista:text;
begin
  cargarMaestro(mae);
  crearDetalle(det); crearDetalle2(det2);
  Assign(lista,'lista.txt'); rewrite(lista);
  reset(mae); reset(det); reset(det2);
  leer(det,regD); leer(det2,regD2);
  minimo(det,det2,regD,regD2,min);
  read(mae,regM);
  writeln('Ingrese el numero de asientos'); readln(cant);
  while(min.destino<>valorAlto)do begin
    ano:=min.fech.ano;
    mes:=min.fech.mes;
    dia:=min.fech.dia;
    destino:=min.destino;
    hora:=min.horaSalida;
    totVendido:=0;
    while (destino=min.destino) and (ano=min.fech.ano) and (mes=min.fech.mes) and (dia=min.fech.dia) and (hora=min.horaSalida) do begin
      totVendido:=totVendido+min.asientosComp;
      minimo(det,det2,regD,regD2,min);
    end;
    while(regM.destino<>destino) OR (regM.fech.ano<>ano) OR (regM.fech.mes<>mes) OR (regM.fech.dia<>dia) OR (regM.horaSalida<>hora) do begin
      read(mae,regM);
    end;
    regM.asientosDisp:=regM.asientosDisp-totVendido;
    if (regM.asientosDisp<cant) then begin
      writeln(lista,regM.fech.ano,' ',regM.fech.mes,' ',regM.fech.dia,' ',regM.horaSalida,' ',regM.asientosDisp,' ',regM.destino);
    end;
    Seek(mae,FilePos(mae)-1);
    write(mae,regM);
  end;
  close(mae); close(lista);
end.