program ejercicio6;
const
    valorAlto=32000;
type
    prendas = record
        cod_prenda:Integer;
        descripcion:string[50];
        colores:string[50];
        tipo_prenda:string[30];
        stock:integer;
        precio_unitario:integer;
    end;

    cod_prendas=integer;

    maestro= file of prendas;
    detalle= file of cod_prendas;

procedure leer (var archivo:detalle;var datos:cod_prendas);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos:=valorAlto;
end;

procedure iniciarMaestro(var mae:maestro);
begin
  Assign(mae,'maestro.dat');
  reset(mae);
  close(mae);
end;

procedure iniciarDetalle(var det:detalle);
begin
  Assign(det,'detalle.dat');
  reset(det);
  close(det);
end;

procedure actualizarMaestro(var mae:maestro;var det:detalle);
var
    regm:prendas;
    regd:cod_prendas;
begin
  reset(mae); reset(det);
  read(mae,regm);
  leer(det,regd);
  while (regd<>valorAlto)do begin
     while (not eof(mae)) and (regm.cod_prenda<>regd) do begin
       read(mae,regm);
     end;
     if (regm.cod_prenda=regd) then begin
        seek(mae,FilePos(mae)-1);
        regm.stock:=regm.stock*-1;
        write(mae,regm);
     end;
     seek(mae,0);
     leer(det,regd);
  end;
  close(mae);
  close(det);
end;

procedure compactoArchivo(var mae:maestro);
var
    regm:prendas;
    nuevoMae:maestro;
begin
  reset(mae);
  Assign(nuevoMae,'nuevoMaestro.dat'); Rewrite(nuevoMae);
  while not eof(mae)do begin
    read(mae,regm);
    if(regm.stock>0)then
      write(nuevoMae,regm);
  end;
  close(mae);
  close(nuevoMae);
  Erase(mae);
  Assign(mae,'nuevoMaestro.dat');
  Rename(mae,'maestro.dat');
end;

procedure mostrarArchivo(var mae:maestro);
var
    regm:prendas;
begin
  reset(mae);
  while not eof(mae)do begin
    read(mae,regm);
    writeln('cod: ',regm.cod_prenda,'-stock: ',regm.stock);
  end;
  close(mae);
end;

var
    mae:maestro;
    det:detalle;
    regm:prendas;
    regd:cod_prendas;
begin
    iniciarMaestro(mae);
    iniciarDetalle(det);
    actualizarMaestro(mae,det);
    writeln('Muestro archivo con la actualizacion');
    mostrarArchivo(mae);
    compactoArchivo(mae);
    writeln('Muestro archivo compactado: ');
    mostrarArchivo(mae);
end.