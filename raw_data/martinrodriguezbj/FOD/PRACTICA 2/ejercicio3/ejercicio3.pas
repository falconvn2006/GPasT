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
    writeln('Ingresar codigo'); read(p.cod);
    while (p.cod<>00) do begin
      writeln('Ingresar cantidad vendida'); read(p.cantVendida);
      write(archivo[i],p);
      writeln('Ingresar codigo'); read(p.cod);
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
  for i:=1 to 3 do begin    //reset de todos los archivos detalles y los leo la primer posicoin
    reset(det1[i]);
    read(det1[i],reg_det[i]);
  end;
  reset(mae1);
  read(mae1,regm);           //reset del archivo maestro y leo su primer posicion
  minimo(reg_det,min,det1);
  writeln('Realizando actualzacion de archivo maestro');
  while(min.cod<>valorAlto)do begin
    codprod:=min.cod;
    cantotal:=0;
    while (codprod=min.cod) do begin
      cantotal:=cantotal+min.cantVendida;  //calculo el total de productos vendidos de un mismo producto
      minimo(reg_det,min,det1);
    end;
    while(regm.cod<>codprod)do begin       //busco el producto en el archivo maestro
      read(mae1,regm);
    end;
    seek(mae1,filepos(mae1)-1);            //vuelvo una posicion hacia atras en el archiov maestro
    regm.stockDisp:=regm.stockDisp-cantotal;        //resto los productos vendidos al archivo maestro
    write(mae1,regm);                         //lo escribo en el archivo maestro
  end;
  close(mae1);                                  //cierro archivo maestro
  for i:=1 to 3 do begin                      //cierro archivos detalles
   close(det1[i]);
  end;
  writeln('Archivo maestro actualizado correctamente');
  mostrar(mae1);
  readln();
end.

