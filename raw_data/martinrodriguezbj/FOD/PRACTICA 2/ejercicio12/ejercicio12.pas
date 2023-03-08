program ejercicio12;
const
    valorAlto=32000;
type
    accesos=record
        ano:integer;
        mes:integer;
        dia:integer;
        idUser:integer;
        tiempoAcceso:integer;
    end;

    maestro=file of accesos;

procedure cargarMaestro(var mae:maestro);
var
    carga:text;
    regM:accesos;
begin
    Assign(carga,'carga.txt'); reset(carga);
    Assign(mae,'maestro'); Rewrite(mae);
    while not eof(carga) do begin
      read(carga,regM.ano,regM.mes,regM.dia,regM.idUser,regM.tiempoAcceso);
      write(mae,regM);
    end;
    close(carga);
    close(mae);
end;

procedure leer (var archivo:maestro;var datos:accesos);
begin
 if (not eof(archivo)) then
   read(archivo,datos)
 else
   datos.ano:=valorAlto;
end;

procedure informePantalla(var mae:maestro);
var
    regM:accesos;
    ano,mes,dia,user,totalDiaUser,totalDiaGral,totalMes,totalAno:integer;
    ok:boolean;
begin
  reset(mae);
  ok:=false;
  writeln('Ingresar el ano sobre el cual desea realizar el informe'); readln(ano);
  leer(mae,regM);
  while(regM.ano<>valorAlto) and (not ok) do begin
    while(regM.ano<>ano) and (regM.ano<>valorAlto) do begin
      leer(mae,regM);
    end;
    if (regM.ano=ano)then begin
        WriteLn('Ano: ',regM.ano);
        totalAno:=0;
        while(regM.ano=ano)do begin
         WriteLn('  Mes: ',regM.mes);
          mes:=regM.mes;
          totalMes:=0;
          while(regM.mes=mes) and (regM.ano=ano) do begin
            WriteLn('   Dia: ',regM.dia);
            dia:=regM.dia;
            totalDiaGral:=0;
            while(regM.dia=dia) and (regM.mes=mes) and (regM.ano=ano) do begin
                user:=regM.idUser;
                totalDiaUser:=0;
                while (regM.idUser=user) and (regM.dia=dia) and (regM.mes=mes) and (regM.ano=ano) do begin
                  totalDiaUser:=totalDiaUser+regM.tiempoAcceso;
                  leer(mae,regM);
                end;
                writeln('idUsuario ',user,' Tiempo total de acceso en el dia ',dia,' mes ',mes);
                writeln(totalDiaUser);
                totalDiaGral:=totalDiaGral+totalDiaUser;
                totalDiaUser:=0;
            end;
            WriteLn('Tiempo total de acceso dia ',dia,' mes ',mes);
            writeln(totalDiaGral);
            totalMes:=totalMes+totalDiaGral;
          end;
          WriteLn('Total tiempo de acceso mes ',mes);
          writeln(totalMes);
          totalAno:=totalAno+totalMes;
        end;
        writeln('Total tiempo de acceso ano: ',totalAno);
        ok:=true;
    end
        else begin
            WriteLn('Ano no encontrado');
            ok:=true;
        end;
    end;
    close(mae);
end;

var
    mae:maestro;
    ano:integer;
begin
    cargarMaestro(mae);
    informePantalla(mae);
end.