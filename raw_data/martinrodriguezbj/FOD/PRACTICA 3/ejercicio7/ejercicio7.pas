program ejercicio7;
const
  valorAlto=32000;
type
  ave = record
    cod:integer;
    nombre:string[30];
    familia:string[30];
    descripcion:string[50];
    zona:string[50];
  end;
  maestro = file of ave;

procedure leer (var archivo:maestro;var datos:ave);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.cod:=valorAlto;
end;

procedure inicioMaestro(var mae:maestro);
begin
  assign(mae,'maestro.dat');
end;

procedure marcarBorrados(var mae:maestro);
var
  cod:integer;
  regm:ave;
  ok:boolean;
begin
  writeln('Ingresar codigo del ave a borrar'); readln(cod);
  reset(mae);
  while (cod<>5000)do begin
   leer(mae,regm); ok:=false;
    while (regm.cod<>valorAlto) and not ok do begin
      if(regm.cod=cod)then begin
        regm.cod:=regm.cod*-1;
        seek(mae,FilePos(mae)-1);
        write(mae,regm);
        ok:=true;
      end;
      leer(mae,regm);
    end;
    writeln('Ingresar codigo del ave a borrar'); readln(cod);  
    seek(mae,0);
  end;
end;


procedure ultimaPos(var mae:maestro;var regU:ave;var posUltima:integer;var auxPos:Integer);
begin
  seek(mae,posUltima);
  leer(mae,regU);  // 1 -2 3 -4 -5 6 EOF
                  //  1  6 3 
  while (regU.cod<0) and (auxPos<posUltima) do begin
    posUltima:=posUltima-1;
    seek(mae,posUltima);
    leer(mae,regU);
  end;
end;



procedure compactarArchivo(var mae:maestro);
var
  regm,regU:ave;
  posUltima,auxPos:integer;
begin
  leer(mae,regm);
  posUltima:=FileSize(mae)-1;
  while (regm.cod<>valorAlto) and (FilePos(mae)<posUltima) do begin
    if (regm.cod<0)then begin
      auxPos:=filePos(mae)-1;
      ultimaPos(mae,regU,posUltima,auxPos);
      if (regU.cod>0)then begin
        seek(mae,auxPos);
        write(mae,regU);
        posUltima:=posUltima-1;
        end;
    end;
    leer(mae,regm);
    writeln('os: ',FilePos(mae));
  end;
  writeln('POsicion: ',FilePos(mae));
  seek(mae,filePos(mae)+1);
  truncate(mae);
  close(mae);
end;

{
procedure compactarArchivo(var mae:maestro);
var
  a,aveUlt:ave;
  actual,pos_ult:integer;
begin
  reset(mae);
  pos_ult:=FileSize(mae)-1;
  while(FilePos(mae)<pos_ult)do begin
    read(mae,a);
    if(a.cod<0)then begin
      actual:=FilePos(mae)-1;
      seek(mae,pos_ult);
      read(mae,aveUlt);
      while(aveUlt.cod<0)and(actual<pos_ult)do begin
        pos_ult:=pos_ult-1;
        seek(mae,pos_ult);
        read(mae,aveUlt);
      end;
      if (aveUlt.cod>1)then begin
        seek(mae,actual);
        write(mae,aveUlt);
        pos_ult:=pos_ult-1;
      end;
    end;
    writeln('procesando');
  end;
  Seek(mae,pos_ult+1);
  truncate(mae);
  close(mae);
end;
}


procedure borrarAves(var mae:maestro);
begin
  marcarBorrados(mae);
  compactarArchivo(mae);
end;

var
    mae:maestro;
    regm:ave;
begin
    inicioMaestro(mae);
    reset(mae);
    while not eof(mae)do begin
      read(mae,regm);
      writeln('Ave: ',regm.nombre,'-cod: ',regm.cod);
    end;
    borrarAves(mae);
    reset(mae);
    while not eof(mae)do begin
      read(mae,regm);
      writeln('Ave: ',regm.nombre,'-cod: ',regm.cod);
    end;
end.