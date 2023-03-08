program ejercicio13;
const
    valorAlto=32000;
type
  logMail=record
    nro_usuario:integer;
    nombreUsuario:string[20];
  //  nombre:string[20];
  //  apellido:string[30];
    cantMailEnviados:integer;
  end;

  LogDetalle=record
    nro_usuario:integer;
    cuentaDestino:integer;
    cuerpoMensaje:string[100];
  end;

  maestro=file of logMail;
  detalle=file of LogDetalle;

procedure cargarMaestro(var mae:maestro);
var
    carga:text;
    regM:logMail;
begin
    Assign(carga,'carga.txt'); reset(carga);
    Assign(mae,'var/log/logmail.dat'); Rewrite(mae);
    while not eof(carga) do begin
      read(carga,regM.nro_usuario,regM.cantMailEnviados,regM.nombreUsuario);
      write(mae,regM);
    end;
    close(carga);
    close(mae);
end;

procedure cargarDetalle(var det:detalle);
var
    cargaDet:text;
    regD:LogDetalle;
begin
    Assign(cargaDet,'cargaDet.txt'); reset(cargaDet);
    Assign(det,'detalle.dat'); Rewrite(det);
    while not eof(cargaDet) do begin
      read(cargaDet,regD.nro_usuario,regD.cuentaDestino,regD.cuerpoMensaje);
      write(det,regD);
    end;
    close(cargaDet);
    close(det);
end;

procedure leer (var archivo:detalle;var datos:LogDetalle);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.nro_usuario:=valorAlto;
end;

procedure leerM (var archivo:maestro;var datos:logMail);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.nro_usuario:=valorAlto;
end;

procedure informarUsuarios(var mae:maestro;var det:detalle);
var
    informe:text;
    regM:logMail;
    regD:LogDetalle;
    totMensajes,user:integer;
begin
    Assign(informe,'informe.txt'); Rewrite(informe);
    reset(mae); reset(det);
    leer(det,regD);
    leerM(mae,regM);
    while (regM.nro_usuario<>valorAlto) do begin
      if (regM.nro_usuario=regD.nro_usuario)then begin
        user:=regD.nro_usuario;
        totMensajes:=0;
        while (user=regD.nro_usuario)do begin
          totMensajes:=totMensajes+1;
          leer(det,regD);
        end;
        writeln(informe,user,'  ',totMensajes);
        leerM(mae,regM);
      end
      else begin
        writeln(informe,regM.nro_usuario,'  ','0');
        leerM(mae,regM);
      end;
    end;
    close(mae);
    close(det);
    close(informe);
end;

var
    mae:maestro;
    regM:logMail;
    det:detalle;
    regD:LogDetalle;
    user,totMensajes:Integer;
begin
    cargarMaestro(mae);
    cargarDetalle(det);
    reset(det); reset(mae);
    leer(det,regD);
    read(mae,regM);
    while (regD.nro_usuario<>valorAlto)do begin
      user:=regD.nro_usuario;
      totMensajes:=0;
      while (user=regD.nro_usuario)do begin
        totMensajes:=totMensajes+1;
        leer(det,regD);
      end;
      while (regM.nro_usuario<>user)do begin
        read(mae,regM);
      end;
      regM.cantMailEnviados:=regM.cantMailEnviados+totMensajes;
      seek(mae,FilePos(mae)-1);
      write(mae,regM);
    end;
    close(mae); close(det);
    informarUsuarios(mae,det);
end.