program ejercicio5;
Uses sysutils;
const
    dimF=50;
    valorAlto=32000;
type
    direccion = record
        calle:string[20];
        nro:integer;
        piso:integer;
        depto:string[20];
        ciudad:string[20];
    end;

    nacimientos = record
        nroPartida:integer;
        nombre:string[20];
        apellido:string[30];
        dire:direccion;
        matriculaMed:integer;
        nombreMadre:string[20];
        apellidoMadre:string[20];
        dniMadre:integer;
        nombrePadre:string[20];
        apellidoPadre:string[20];
        dniPadre:integer;
    end;

    fallecimientos = record
        nroPartida:integer;
        nombre:string[20];
        apellido:string[30];
        matriculaMedicoDec:integer;
        fecha:string[20];
        hora:integer;
        lugar:string[30];
    end;

    maestro = record
        nroPartida:integer;
        nombre:string[20];
        apellido:string[30];
        dire:direccion;
        matriculaMed:integer;
        nombreMadre:string[20];
        apellidoMadre:string[30];
        dniMadre:integer;
        nombrePadre:string[20];
        apellidoPadre:string[30];
        dniPadre:integer;
        fallecio:boolean;
        matriculaMedicoDec:integer;
        fecha:string[20];
        hora:integer;
        lugar:string[30];
    end;

    arch_nacimientos=array[1..dimF] of file of nacimientos;
    arch_fallecimientos=array[1..dimF] of file of fallecimientos;
    regN=array[1..dimF] of nacimientos;
    regF=array[1..dimF] of fallecimientos;
    arch_maestro=file of maestro;

procedure leer(var archivo:detalle;var dato:productosDet);
begin
  if not eof(archivo) then
      read(archivo,dato)
      else
          dato.cod:=valorAlto;
end;

procedure minimoN(var regd:regN;var min:nacimientos;var det:arch_nacimientos);
var
  i,est:integer;
begin
 est:=0;
 min.nroPartida:=valorAlto;
 for i:=1 to dimF do begin
      if (regd[i].nroPartida<=min.nroPartida) then begin
         min:=regd[i];
         est:=i;
      end;
   end;
 if (min.nroPartida<>valorAlto) then begin
   leer(det[est],regd[est]);
   end;
end;

procedure minimoF(var regd:regF;var min:fallecimientos;var det:arch_fallecimientos);
var
  i,est:integer;
begin
 est:=0;
 min.nroPartida:=valorAlto;
 for i:=1 to dimF do begin
      if (regd[i].nroPartida<=min.nroPartida) then begin
         min:=regd[i];
         est:=i;
      end;
   end;
 if (min.nroPartida<>valorAlto) then begin
   leer(det[est],regd[est]);
   end;
end; 

var
   detN:arch_nacimientos;
   detF:arch_fallecimientos;
   regN:regN;
   regF:regF;
   minN:nacimientos;
   minF:fallecimientos;
   mae:arch_maestro;
   regM:maestro;
   i:integer;
begin
  for i:=1 to dimF do begin
     assign(detN[i],'detalleN'+intToStr(i));
     reset(detN[i]);
     read(detN[i],regd[i]);
     assign(detF[i],'detalleF'+intToStr(i));
     reset(detF[i]);
     read(detF[i],regd[i]);
  end;
  assign(mae,'maestro');
  rewrite(mae);
  minimoN(regN,minN,detN);
  minimoF(regF,minF,detF);
  
  while (minN.nroPartida<>valorAlto) or (minF.nroPartida<>valorAlto) do begin
        if (minN.nroPartida==minF.nroPartida) then begin
            regM.nroPartida:=minN.nroPartida;
            //aca todas las cosas de nacimiento y fallecimiento
            end
            else begin
              
            end;
        

  end;
  
end.