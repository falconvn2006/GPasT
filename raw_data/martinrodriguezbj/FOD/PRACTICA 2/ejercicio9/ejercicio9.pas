program ejercicio9;
const
    valorAlto=32000;
type
    votos = record
        codProv:integer;
        codLoc:integer;
        numMesa:integer;
        cantVotos:integer;
    end;
    maestro=file of votos;

procedure leer (var archivo:maestro;var datos:votos);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.codProv:=valorAlto;
end;

procedure crearMaestro(var mae:maestro);
var
  carga:text;
  regM:votos;
begin
  assign(mae,'maestro');
  Rewrite(mae);
  Assign(carga,'carga.txt');
  reset(carga);
  while not eof(carga)do begin
    read(carga,regM.codProv,regM.codLoc,regM.numMesa,regM.cantVotos);
    write(mae,regM);
  end;
  close(mae);
  close(carga);
end;

var
  mae:maestro;
  regM:votos;
  codProv,totProv,codLoc,totLoc,totVot:integer;
begin
  crearMaestro(mae);
  reset(mae);
  leer(mae,regM);
  totVot:=0;
  while (regM.codProv<>valorAlto)do begin
    WriteLn('Codigo de provincia: ',regM.codProv);
    WriteLn('Codigo de localidad        total de votos');
    codProv:=regM.codProv;
    totProv:=0;
    while(regM.codProv=codProv) do begin
      codLoc:=regM.codLoc;
      totLoc:=0;
      while(regM.codLoc=codLoc) and (regM.codProv=codProv) do begin
        totLoc:=totLoc+regM.cantVotos;
        leer(mae,regM);
      end;
      WriteLn(codLoc,'                          ',totLoc);
      totProv:=totProv+totLoc;
    end;
    WriteLn('Total de votos provincia: ',totProv);
    totVot:=totVot+totProv;
    writeln('---------------------------------------------------')
  end;
  WriteLn('Total general de votos: ',totVot);
end.