program ejercicio7;
const
    valorAlto=32000;
type
    producto = record
        cod:integer;
        nombre:string[20];
        precio:integer;
        stockAct:integer;
        stockMin:integer;
    end;

    productoDet = record
        cod:integer;
        cantVend:integer;
    end;

    maestro= file of producto;
    detalle=file of productoDet;

procedure leer (var archivo:detalle;var datos:productoDet);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.cod:=valorAlto;
end;

procedure crearMaestro(var mae:maestro);
var 
   productos:text;
   regM:producto;
begin
   assign(mae,'maestro');
   rewrite(mae);
   assign(productos,'productos.txt');
   reset(productos);
   while not eof(productos) do begin
     read(productos,regM.cod,regM.precio,regM.stockAct,regM.stockMin,regM.nombre);
     write(mae,regM);
   end;
   close(mae);
   close(productos);
end;

procedure listarMaestro(var mae:maestro);
var 
   reporte:text;
   regM:producto;
begin
  reset(mae);
  Assign(reporte,'reporte.txt');
  Rewrite(reporte);
  while not eof(mae) do begin
    read(mae,regM);
    Writeln(reporte,regM.cod,' ',regM.precio,' ',regM.stockAct,' ',regM.stockMin,' ',regM.nombre);
  end;
  close(mae);
  close(reporte);
end;

procedure crearDetalle(var det:detalle);
var
   ventas:text;
   regD:productoDet;
begin
   assign(det,'detalle');
   rewrite(det);
   assign(ventas,'ventas.txt');
   reset(ventas);
   while not eof(ventas)do begin
     read(ventas,regD.cod,regD.cantVend);
     write(det,regD);
   end;
   close(det);
   close(ventas);
end;

procedure listarVentasPantalla(var det:detalle);
var
   regD:productoDet;
begin
  reset(det);
  while not eof(det)do begin
    read(det,regD);
    WriteLn(regD.cod,' ',regD.cantVend);
  end;
  close(det);
end;

procedure actualizarMaestro(var mae:maestro;var det:detalle);
var
  regM:producto;
  regD:productoDet;
  totVendido,cod:integer;
begin
  reset(mae);
  reset(det);
  read(mae,regM);
  leer(det,regD);
  while (regD.cod<>valorAlto) do begin
     totVendido:=0;
     cod:=regD.cod;
     while (regD.cod=cod)do begin
       totVendido:=totVendido+regD.cantVend;
       leer(det,regD);
     end;
     while (regM.cod<>cod)do begin
       read(mae,regM);
     end;
     regM.stockAct:=regM.stockAct-totVendido;
     Seek(mae,FilePos(mae)-1);
     write(mae,regM);
  end;
  close(mae);
  close(det);
end;

procedure listarStockMin(var mae:maestro);
var
  regM:producto;
  stock_minimo:text;
begin
  reset(mae);
  Assign(stock_minimo,'stock_minimo.txt');
  Rewrite(stock_minimo);
  while not eof(mae)do begin
    read(mae,regM);
    if (regM.stockAct<regM.stockMin)then
        Writeln(stock_minimo,regM.cod,' ',regM.precio,' ',regM.stockAct,' ',regM.stockMin,' ',regM.nombre);
  end;
  close(mae);
  close(stock_minimo);
end;

var
   mae:maestro;
   det:detalle;
   regM:producto;
   regD:detalle;
   opcion:integer;
begin
    writeln('Ingresar 1-crearMaestro 2-listarMaestro 3-crearDetalle 4-listarVentasPantalla 5-actualizarMaestro 6-listarSockMin'); readln(opcion);
    while (opcion<>0) do begin
      case (opcion) of
        1:crearMaestro(mae);
        2:listarMaestro(mae);
        3:crearDetalle(det);
        4:listarVentasPantalla(det);
        5:actualizarMaestro(mae,det);
        6:listarStockMin(mae);
       end;
       writeln('Ingresar 1-crearMaestro 2-listarMaestro 3-crearDetalle 4-listarVentasPantalla 5-actualizarMaestro 6-listarSockMin'); readln(opcion);
    end;
end.