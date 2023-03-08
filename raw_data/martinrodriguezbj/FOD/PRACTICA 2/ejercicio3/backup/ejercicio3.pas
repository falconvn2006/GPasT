program ejercicio3;
const
  valorAlto=32000;
type
  producto = record
    cod:integer;
    nombre:string[20];
    descripcion:string[30];
    stockDisp:integer;
    stockMin:integer;
    precio:integer;
  end;

  productoDet = record
    cod:integer;
    cantVendida:integer;
  end;

  maestro = file of producto;
  detalle = file of productoDet;
  arch_detalle = array[1..3] of file of productoDet;
  reg_detalle=array[1..3] of productoDet;

procedure leer(var archivo:detalle;var dato:productoDet);
begin
  if not eof(archivo) then
     read(archivo,dato)
  else
      dato.cod:=valorAlto;
end;

procedure minimo(var reg_det:reg_detalle;var min:productoDet;var deta:arch_detalle);
var
  i,est:integer;
begin
 est:=0;
 min.cod:=valorAlto;
 for i:=1 to 3 do begin
      if (reg_det[i].cod<min.cod) then begin
         min:=reg_det[i];
         est:=i;
         end;
   end;
 if (min.cod<>valorAlto) then begin
   leer(deta[est],reg_det[est]);
   end;
end;

procedure crearDetalle(var archivo:arch_detalle);
var
  i:integer;
  p:productoDet;
begin
  i:=1;
  assign(archivo[1],'detalle1');
  assign(archivo[2],'detalle2');
  assign(archivo[3],'detalle3');
  while (i<=3) do begin
    writeln('-Creando detalle ',i,'-');
    rewrite(archivo[i]);
    writeln('Ingresar codigo'); readln(p.cod);
    while (p.cod<>00) do begin
      writeln('Ingresar cantidad vendida'); readln(p.cantVendida);
      write(archivo[i],p);
      writeln('Ingresar codigo'); readln(p.cod);
    end;
    close(archivo[i]);
    i:=i+1;
end;
end;

procedure crearMaestro(var archivo:maestro);
var
  regm:producto;
begin
  writeln('Ingrese codigo del producto'); readln(regm.cod);{Lectura codigo del producto}
  while (regm.cod<>0) do begin
    writeln('Ingrese nombre del producto'); readln(regm.nombre);
    writeln('Ingrese descripcion del producto'); readln(regm.descripcion);
    writeln('Ingrese stockDisp del producto'); readln(regm.stockDisp);
    writeln('Ingrese stockMin del producto'); readln(regm.stockMin);
    writeln('Ingrese Precio del producto'); readln(regm.precio);
    write(archivo,regm); {escritura del producto en el archivo}
    writeln('Ingrese codigo del producto'); readln(regm.cod);
  end;
  close(archivo);{Cierre del archivo}
end;

procedure mostrar(var archivo:maestro);
var
  p:producto;
begin
 reset(archivo);
 while not eof(archivo) do begin
   read(archivo,p);
   writeln('codigo producto: ',p.cod);
   writeln('Stock disponible: ',p.stockDisp);
 end;
 close(archivo);
end;

var
  opcion:integer;
  mae1:maestro;
  regm:producto;
  det1:arch_detalle;
  reg_det:reg_detalle;
  min:productoDet;
  codprod,cantotal:integer;
  i:integer;
begin
  i:=1;
  assign(mae1,'maestro');
  rewrite(mae1);
  writeln('Realice la carga de los productos en el archivo maestro');
  crearMaestro(mae1);
  writeln('Realice la carga de los archivos detalles');
  crearDetalle(det1);
  reset(det1[1]);
  reset(det1[2]);
  reset(det1[3]);
  for i:=1 to 3 do begin
    read(det1[i],reg_det[i]);
  end;
  reset(mae1);
  read(mae1,regm);
  minimo(reg_det,min,det1);
  writeln('Realizando actualzacion de archivo maestro');
  while(min.cod<>valorAlto)do begin
    codprod:=min.cod;
    cantotal:=0;
    writeln('Entre1');
    while (codprod=min.cod) do begin
      cantotal:=cantotal+min.cantVendida;
      minimo(reg_det,min,det1);
      writeln('Entre2');
    end;
    while(regm.cod<>codprod)do begin
      read(mae1,regm);
      writeln('Entre3');
    end;
    seek(mae1,filepos(mae1)-1);
    regm.stockDisp:=regm.stockDisp-cantotal;
    write(mae1,regm);
  end;
  close(mae1);
  for i:=1 to 3 do begin
   close(det1[i]);
  end;
  writeln('Archivo maestro actualizado correctamente');
  mostrar(mae1);
  readln();
end.

