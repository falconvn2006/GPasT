program ejercicio17;
const
    valorAlto=32000;
type
    vehiculo = record
        cod:integer;
        nom:string[20];
        des:string[20];
        model:string[20];
        stock:integer;
    end;

    fech = record
        a:integer;
        m:integer;
        d:integer;
    end;

    vehiculoDet = record
        cod:integer;
        precio:integer;
        fecha:fech;
    end;

    maestro=file of vehiculo;
    detalle=file of vehiculoDet;

procedure leer (var archivo:detalle;var datos:vehiculoDet);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.cod:=valorAlto;
end;

procedure asignoMaestroYleo(var mae:maestro;var regM:vehiculo);
begin
  assign(mae,'maestro.dat');
  reset(mae);
  read(mae,regM);
end;

procedure asignoDetalleYleo(var det1,det2:detalle;var regd1,regd2:vehiculoDet);
begin
  assign(det1,'detalle1.dat'); reset(det1); read(det1,regd1);
  Assign(det2,'detalle2.dat'); reset(det2); read(det2,regd2);
end;

procedure minimo(var det1,det2:detalle;var regd1,regd2,min:vehiculoDet);
begin
  if (regd1.cod<regd2.cod)then begin
    min:=regd1;
    leer(det1,regd1);
  end
    else begin
      min:=regd2;
      leer(det2,regd2);
    end;
end;

procedure actualizarMaestro(var mae:maestro;var det1,det2:detalle;var regm:vehiculo;var regd1,regd2:vehiculoDet);
var
    min:vehiculoDet;
    cod,totVendido,masVendido,codMasVendido:integer;
begin
    minimo(det1,det2,regd1,regd2,min);
    masVendido:=0;
    while (min.cod<>valorAlto)do begin
        cod:=min.cod;
        totVendido:=0;
        while(min.cod=cod) do begin
            totVendido:=totVendido+1;
            minimo(det1,det2,regd1,regd2,min);
        end;
        if (totVendido>masVendido)then begin
            masVendido:=totVendido;
            codMasVendido:=cod;
        end;
        while(regm.cod<>cod)do begin
          read(mae,regm);
        end;
        regm.stock:=regm.stock-totVendido;
        Seek(mae,FilePos(mae)-1);
        write(mae,regm);
    end;
    writeln('El codigo del vehiculo mas vendido es: ',codMasVendido);
    close(mae); close(det1); close(det2);
end;

procedure recorroMaestro(var mae:maestro);
var
    regm:vehiculo;
begin
  reset(mae);
  while not eof(mae) do begin
    read(mae,regm);
    writeln('codigo: ',regm.cod,'-stock: ',regm.stock);
  end;
  close(mae);
end;

var
    mae:maestro;
    det1,det2:detalle;
    regm:vehiculo;
    regd1,regd2:vehiculoDet;
begin
  asignoMaestroYleo(mae,regm);
  asignoDetalleYleo(det1,det2,regd1,regd2);
  actualizarMaestro(mae,det1,det2,regm,regd1,regd2);
  recorroMaestro(mae);
end.
 