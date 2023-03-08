program ejercicio11;
Uses sysutils;
const
    valorAlto='ZZZ';
type
    datos = record
        nomProv:string[20];
        cantAlfab:integer;
        totalEncuestados:integer;
    end;

    datosDet = record
        nomProv:string[20];
        codLoc:integer;
        cantAlfab:integer;
        cantEncuestados:integer;
    end;

    detalle= file of datosDet;
    maestro= file of datos;

procedure cargarDetalles(var det1,det2:detalle);
var
    carga1,carga2:text;
    regD:datosDet;
begin
  assign(det1,'det1'); Rewrite(det1);
  assign(det2,'det2'); Rewrite(det2);
  Assign(carga1,'carga1.txt'); reset(carga1);
  Assign(carga2,'carga2.txt'); reset(carga2);
  while not eof(carga1) do begin
    read(carga1,regD.codLoc,regD.cantAlfab,regD.cantEncuestados,regD.nomProv);
    regD.nomProv:=Trim(regD.nomProv);
    write(det1,regD);
  end;
  while not eof(carga2) do begin
    read(carga2,regD.codLoc,regD.cantAlfab,regD.cantEncuestados,regD.nomProv);
    regD.nomProv:=Trim(regD.nomProv);
    write(det2,regD);
  end;
  close(det1); close(det2); close(carga1); close(carga2);
end;

procedure cargarMaestro(var mae:maestro);
var
    regM:datos;
    cargaMae:text;
begin
    Assign(cargaMae,'cargarMae.txt'); reset(cargaMae);
    Assign(mae,'mae'); Rewrite(mae);
    while not eof(cargaMae)do begin
      read(cargaMae,regM.cantAlfab,regM.totalEncuestados,regM.nomProv);
      regM.nomProv:=Trim(regM.nomProv);
      write(mae,regM);
    end;
    close(cargaMae);
    close(mae);
end;

procedure leer (var archivo:detalle;var datos:datosDet);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.nomProv:=valorAlto;
end;

procedure minimo(var r1,r2,min:datosDet;var det1,det2:detalle);
begin
  if (r1.nomProv<r2.nomProv)then begin
    min:=r1;
    leer(det1,r1);
  end
    else begin
      min:=r2;
      leer(det2,r2);
    end;
end;

var
    det1,det2:detalle;
    regD1,regD2,min:datosDet;
    mae:maestro;
    regM:datos;
    prov:string;
    totAlfab,totEncuest:integer;
begin
    cargarDetalles(det1,det2);
    cargarMaestro(mae);
    reset(det1); reset(det2); reset(mae);
    leer(det1,regD1);
    leer(det2,regD2);
    read(mae,regM);
    minimo(regD1,regD2,min,det1,det2);
    
    while (min.nomProv<>valorAlto)do begin
      prov:=min.nomProv;
      totAlfab:=0;
      totEncuest:=0;
      while (min.nomProv=prov)do begin
        totAlfab:=totAlfab+min.cantAlfab;
        totEncuest:=totEncuest+min.cantEncuestados;
        minimo(regD1,regD2,min,det1,det2);
      end;
      while (prov<>regM.nomProv)do begin
        read(mae,regM);
      end;
      seek(mae,FilePos(mae)-1);
      regM.cantAlfab:=totAlfab;
      regM.totalEncuestados:=totEncuest;
      write(mae,regM);
    end;

    reset(mae);
    while not eof(mae)do begin
      read(mae,regM);
      writeln('prov: ',regM.nomProv,'-cantidad alfabetizados: ',regM.cantAlfab,'-cantidad encuestados: ',regM.totalEncuestados);
    end;
end.