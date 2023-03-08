program ej4;
Uses crt, sysutils;
type
  celulares = record
    cod:integer;
    nombre:string[20];
    descripcion:string[30];
    marca:string[30];
    precio:integer;
    stockMin:integer;
    stockdisp:integer;
  end;
  archivo_celular= file of celulares;

procedure crearArchivo(var archivo:archivo_celular);
var
  carga:text;
  c:celulares;
  nombre:string;
  sacoEspacio:string;
begin
  writeln('Ingresar el nombre del archivo'); readln(nombre);
  assign(archivo,nombre);
  rewrite(archivo);
  assign(carga,'carga.txt');
  reset(carga);
  while not eof(carga) do begin
    read(carga,c.cod,c.precio,c.marca,c.nombre);
    readln(carga,c.stockdisp,c.stockmin,c.descripcion);
    c.descripcion:=Trim(c.descripcion);
    write(archivo,c);
  end;
  writeln('Archivo creado correctamente');
  close(archivo);
  close(carga);
end;

procedure menu(var archivo:archivo_celular);
var
  opcion,cod,elige:integer;
  c:celulares;
  celular,sinStock:text;
  encontre:boolean;
  cadena:string;
begin
 writeln('Bienvenido al menu');
 writeln('1-Listar en pantalla los datos de aquellos celulares que tengan un stock menor al minimo');
 writeln('2-Listar en pantalla los celulares del archivo cuya descripcion contenga una cadena de caracteres proporcionada por el usuario');
 writeln('3-Exportar el archivo a un archivo de texto denominado celular.txt con todos los celulares del mismo');
 writeln('4-Añadir uno o mas datos al final de archivo con datos ingresados desde teclado');
 writeln('5-modificar el stock de un celular dado');
 writeln('6-exportar el contenido del archivo binario a un archivo de texto denominado sinStock.txt  con aquellos celulares que tengan stock 0');  readln(opcion);
 case(opcion) of
 1:begin
   reset(archivo);
   while not eof(archivo) do begin
     read(archivo,c);
     if (c.stockdisp<c.stockMin) then begin
       writeln('Codigo:',c.cod);
       writeln('Nombre:',c.nombre);
       writeln('Descripcion:',c.descripcion);
       writeln('Marca:',c.marca);
       writeln('------------');
     end;
 end;
 end;
 2:begin
   reset(archivo);
   writeln('Ingresar cadena a buscar'); readln(cadena);
   while not eof(archivo) do begin
     read(archivo,c);
     if(pos(cadena,c.descripcion)<>0) then begin   //pos retorna la posicion en la que se encuentra la cadena, si no encuentra nada entonces devuelve 0
        writeln('Codigo:',c.cod);
        writeln('Nombre:',c.nombre);
        writeln('Descripcion:',c.descripcion);
        writeln('Marca:',c.marca);
        writeln('stockdisp:',c.stockdisp);
        writeln('stockmin:',c.stockMin);
        writeln('------------');
     end;
   end;
 end;
 3:begin
   assign(celular,'celular.txt');
   rewrite(celular);
   reset(archivo);
   while not eof(archivo)do begin
     read(archivo,c);
     writeln(celular,c.cod,c.precio,c.marca,c.nombre);
     writeln(celular,c.stockdisp,c.stockmin,c.descripcion);
   end;
   close(celular);
   writeln('Exportacion realizada con exito');
 end;
4:begin
  reset(archivo);
  seek(archivo,filesize(archivo));
  writeln('Ingresar cod celular'); readln(c.cod);
  while (c.cod<>00) do begin
  writeln('Ingresar precio'); readln(c.precio);
  writeln('Ingresar marca'); readln(c.marca);
  writeln('Ingresar nombre'); readln(c.nombre);
  writeln('Ingresar stock disponible'); readln(c.stockdisp);
  writeln('Ingresar stock minimo'); readln(c.stockmin);
  writeln('Ingresar descripcion'); readln(c.descripcion);
  write(archivo,c);
  writeln('Ingresar cod celular'); readln(c.cod);
  end;
 end;
 5:begin
   writeln('Ingrese el codigo del celular que desea editar'); readln(cod);
   reset(archivo);
   encontre:=false;
   while (not eof(archivo)) and (encontre=false) do begin
      read(archivo,c);
      if (c.cod=cod) then begin
         encontre:=true;
         writeln('Que desea modificar: 1-codigo,2-precio,3-marca,4-nombre,5-stockdisp,6-sotckmin,7-descricpion');  readln(opcion);
         case (opcion) of
           1:begin
             writeln('Ingrese el nuevo codigo'); readln(cod);
             c.cod:=cod;
           end;
         end;
         seek(archivo,filepos(archivo)-1);
         write(archivo,c);
      end;
   end;
   close(archivo);
 end;
 6:begin
    assign(sinStock,'sinStock.txt');
    rewrite(sinStock);
    reset(archivo);
    while(not eof(archivo)) do begin
       read(archivo,c);
       if (c.stockdisp=0)then begin
          writeln(sinStock,c.cod,c.precio,c.marca,c.nombre);
          writeln(sinStock,c.stockdisp,c.stockmin,c.descripcion);
       end;
   end;
   close(sinStock);
 end;
 else writeln('Opcion incorrecta');
end;
 writeln('Desea volver al menu? 1=si 2=no'); readln(elige);
 if (elige=1) then
    menu(archivo);
end;

procedure inicio(var archivo: archivo_celular);
var
  opcion:integer;
begin
  writeln('Seleccionar la opcion');
  writeln('1-Crear un archivo de celulares cargados con datos que estan contenidos en el archivo celulares.txt');
  writeln('0.Cerrar programa');

  writeln('Ingresar opcion'); readln(opcion);
  case (opcion) of
  1:begin
    crearArchivo(archivo);
    menu(archivo);
    end;
  2:
  end;
end;

var
  archivo:archivo_celular;
begin
  inicio(archivo);
  readln();
end.




