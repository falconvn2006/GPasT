program ejercicio6;
Uses sysutils;
const
    dimF=3;
    valorAlto=32000;
type
    productos = record
        cod:integer;
     //   nombre:string;
     //   descripcion:string;
     //   talle:string;
     //   color:string;
        stockDisp:integer;
     //   stockMin:integer;
     //   precio:integer;
    end;

    productosDet = record
        cod:integer;
        cantVendida:integer;
    end;

    maestro= file of productos;
    detalle= file of productosDet;
    arch_detalle=array[1..dimF] of file of productosDet;
    reg_detalle=array[1..dimF] of productosDet;

procedure leer(var archivo:detalle;var dato:productosDet);
begin
  if not eof(archivo) then
      read(archivo,dato)
      else
          dato.cod:=valorAlto;
end;

procedure crearDetalles(var archivo:arch_detalle);
var
  i:integer;
  p:productosDet;
begin
  i:=1;
  while (i<=3) do begin
    writeln('-Creando detalle ',i,'-');
    writeln('Ingresar codigo'); read(p.cod);
    while (p.cod<>00) do begin
      writeln('Ingresar cantidad vendida'); read(p.cantVendida);
      write(archivo[i],p);
      writeln('Ingresar codigo'); read(p.cod);
    end;
    close(archivo[i]);
    i:=i+1;
   end;
WriteLn('Carga de detalles realizada exitosamente');
end;

procedure crearMaestro(var archivo:maestro);
var
  p:productos;
begin
  writeln('Ingresar codigo producto'); readln(p.cod);
  while (p.cod<>00)do begin
     writeln('Ingresar stockDisp producto'); readln(p.stockDisp);
     write(archivo,p);
     writeln('Ingresar codigo producto'); readln(p.cod);
  end;
  WriteLn('Archivo maestro creado correctamente');
end;

procedure minimo(var regd:reg_detalle;var min:productosDet;var det:arch_detalle);
var
  i,est:integer;
begin
 est:=0;
 min.cod:=valorAlto;
 for i:=1 to 3 do begin
      if (regd[i].cod<=min.cod) then begin
         min:=regd[i];
         est:=i;
      end;
   end;
   leer(det[est],regd[est]);
end; 
    
var
  det:arch_detalle;
  min:productosDet;
  regd:reg_detalle;
  mae:maestro;
  regm:productos;
  i,totVendido,cod:integer;
  st,aux:string;
begin
  
  for i:=1 to 3 do begin  //hago las asignaciones de los detalles y creo los archivos
     assign(det[i],'detalle'+intToStr(i));
     rewrite(det[i]);
  end;
  crearDetalles(det);  //creo los detalles
  for i:=1 to 3 do begin  //reseteo los archivos y los leo
     reset(det[i]);
     read(det[i],regd[i]);
  end;

  assign(mae,'maestro');
  rewrite(mae);
  crearMaestro(mae);  //asigno y creo archivo maestro
  reset(mae); read(mae,regm);


  minimo(regd,min,det);
  while(min.cod<>valorAlto) do begin //Cuando sea valor alto es por que ya no van haber archivos con registros para leer
    totVendido:=0;
    cod:=min.cod;
    while (cod=min.cod)do begin  //mientras sea mismo codigo, acumulo el total vendido
      totVendido:=totVendido+min.cantVendida;
      minimo(regd,min,det);
    end;

    while (regm.cod<>cod) do begin  //leo el archivo maestro hasta encontrar el archivo que tenga el mismo codigo que el detalle
      read(mae,regm);
    end;
    
    regm.stockDisp:=regm.stockDisp-totVendido;
    Seek(mae,FilePos(mae)-1);
    write(mae,regm);
  end;

   for i:=1 to 3 do begin
      close(det[i]);
  end;

  reset(mae); //RESETEO Y MUESTRO EL ARCHIVO MAESTRO
  while not eof (mae) do begin
  read(mae,regm);
  writeln('Codigo: ',regm.cod,'-Stock: ',regm.stockDisp);
end;
close(mae);

  
  
  
  //WriteLn('Minimo: ',min.cod);
end.