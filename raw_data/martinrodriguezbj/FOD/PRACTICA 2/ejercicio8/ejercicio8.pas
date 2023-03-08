program ejercicio8;
const
    valorAlto=32000;
type
    cliente = record
        cod:integer;
        nombreYapellido:string[30];
        ano:integer;
        mes:integer;
        dia:integer;
        monto:integer;
    end;

    maestro=file of cliente;
    meses=array[1..12] of integer;

procedure leer (var archivo:maestro;var datos:cliente);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.cod:=valorAlto;
end;

procedure cargarMaestro(var mae:maestro);
var
  carga:text;
  regM:cliente;
begin
  Assign(mae,'maestro');
  Rewrite(mae);
  Assign(carga,'carga.txt');
  reset(carga);
  while not eof(carga)do begin
    read(carga,regM.cod,regM.ano,regM.mes,regM.dia,regM.monto,regM.nombreYapellido);
    Write(mae,regM);
  end;
  close(mae);
  close(carga);
end;

procedure inicializarMeses(var v:meses);
var
  i:integer;
begin
  for i:=1 to 15 do begin
    v[i]:=0;
  end;
end;

var
  mae:maestro;
  regM:cliente;
  cod,mes,totalMes,ano,totalAno,totalVentas,i:integer;
  v:meses;
begin
    cargarMaestro(mae);
    reset(mae);
    inicializarMeses(v);
    leer(mae,regM);
    totalVentas:=0;
    while(regM.cod<>valorAlto)do begin
      WriteLn('Nombre y apellido: ',regM.nombreYapellido);
      WriteLn('codigo cliente: ',regM.cod);
      cod:=regM.cod;
      while (regM.cod=cod) do begin
        totalAno:=0;
        ano:=regM.ano;
        while (regM.cod=cod) and (regM.ano=ano) do begin
          mes:=regM.mes;
          while (regM.cod=cod) and (regM.ano=ano) and (regM.mes=mes) do begin
            v[mes]:=v[mes]+regM.monto;
            leer(mae,regM);
          end;
          totalAno:=totalAno+v[mes];
        end;
        //muestro monto de cad mes
        for i:=1 to 12 do begin
          writeln('Monto total mes: ',i,': ',v[i]);
        end;
        WriteLn('Total ano es: ',totalAno); 
        totalVentas:=totalVentas+totalAno;
        inicializarMeses(v);
      end;
    end;
    WriteLn('Total ventas: ',totalVentas);
end.