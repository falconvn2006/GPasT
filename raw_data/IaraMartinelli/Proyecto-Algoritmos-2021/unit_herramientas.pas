unit Unit_herramientas;

{$codepage utf8}
interface
uses
  Crt,unit_manejo_archivos_personas,unit_manejo_archivos_atenciones,sysutils;


Procedure marco(n:cardinal);
Procedure Pantalla_error_cargar_atenciones();
Procedure Pantalla_error_atencion(pos:integer);
Procedure ingresar_fecha_atencion(Var r:t_fecha);

//VALIDACION//
Function Validacion_existencia_Dni(Var ar1:t_archivo_personas;dni:shortstring):boolean;
Function validacion_numeros(entrada:shortstring):boolean;
Procedure respuesta_validacion_dni(Var dni:shortstring);
Procedure respuesta_validacion_telefono(Var telefono:shortstring);
Function validacion_mes(mes:shortstring):boolean;
Function validacion_dia(dia:shortstring):boolean;
Function validacion_anio(anio:string):boolean;
procedure BorrarPantalla();
procedure ingresar_dni(var dni:shortstring);

implementation

Procedure marco(n:cardinal);
var
i:cardinal;
  Begin
  gotoxy(25,3);
  write(' _______________________________________________________________________');
  gotoxy(70,4);
  write('Bogado, Gómez, Martinelli');
  for i:=1 to n do
  begin
  gotoxy(25,3+i);
  write('|');
  gotoxy(97,3+i);
  write('|');
  end;
  gotoxy(25,4+i);
  write('|_______________________________________________________________________|');
  End;

Procedure Pantalla_error_cargar_atenciones();
Begin
clrscr;
gotoxy(40,7);
writeln('LA PERSONA DEBE ESTAR PREVIAMENTE REGISTRADA');
gotoxy(40,9);
WriteLn('PARA INGRESAR UNA ATENCIÓN');
marco(7);
readkey;
clrscr;
end;

Procedure Pantalla_error_atencion(pos:integer);
Begin
If pos=-1 then
Begin
clrscr;
 gotoxy(30,7);
 write('NO SE HA ENCONTRADO A LA PERSONA CON EL DNI INGRESADO');
 gotoxy(30,9);
 Write('       O LA FECHA DE ATENCIÓN ES INCORRECTA');
 gotoxy(30,11);
 Write('     VERIFIQUE QUE LOS DATOS SEAN LOS CORRECTOS');
 MARCO(9);
 Readkey;
End;
end;

Procedure ingresar_fecha_atencion(Var r:t_fecha);

 begin
  gotoxy(78,10);
  readln(r.dia);
  While not validacion_dia(r.dia) do
  Begin
    gotoxy(78,10);
    clreol;
    gotoxy(47,12);
    Write('Ingrese un día válido. ');
    gotoxy(78,10);
    readln(r.dia);
    if validacion_dia(r.dia) then
    begin
    gotoxy(47,12);
    clreol;
    end;
  End;
gotoxy(80,10);
write('/');
 gotoxy(81,10);
  readln(r.mes);
  While not validacion_mes(r.mes) do
  Begin
    gotoxy(81,10);
    clreol;
    gotoxy(47,12);
    Write('Ingrese un mes válido. ');
    gotoxy(81,10);
    readln(r.mes);
    if validacion_mes(r.mes) then
    begin
    gotoxy(47,12);
    clreol;
    end;
  End;
gotoxy(83,10);
write('/');
gotoxy(84,10);
  readln(r.anio);
  While not validacion_anio(r.anio) do
  Begin
    gotoxy(84,10);
    clreol;
    gotoxy(47,12);
    Write('Ingrese un año válido. ');
    gotoxy(84,10);
    readln(r.anio);
    if validacion_anio(r.anio) then
    begin
    gotoxy(47,12);
    clreol;
    end;
  End;
 end;

//VALIDACIONES//
Function Validacion_existencia_Dni(Var ar1:t_archivo_personas;dni:shortstring):boolean;
  Var aux:t_dato_personas;
  Begin
  Validacion_existencia_Dni:=false;
  Seek(ar1,0);
  While not EOF(ar1) do
  Begin
    Read(ar1,aux);
If aux.dni=dni then Validacion_existencia_Dni:=true;
  End;
  End;

procedure ingresar_dni(var dni:shortstring);
begin
  While not validacion_numeros(dni) do
  Begin
    gotoxy(59,8);
    clreol;
    gotoxy(47,12);
    Write('Ingrese un DNI válido o existente. ');
    gotoxy(59,8);
    readln(dni);
    if validacion_numeros(dni) then
    begin
    gotoxy(47,12);
    clreol;
    end;
  End;
end;

Function validacion_numeros(entrada:shortstring):boolean;
  Var i:byte;
  Begin
  validacion_numeros:=true;
  for i:=1 to length(entrada) do
  Begin
    If not (upcase(entrada[i]) in ['0'..'9']) then validacion_numeros:=false;
  End;
  end;

Procedure respuesta_validacion_dni(Var dni:shortstring);
  Begin
   If validacion_numeros(dni)=false then
   Begin
     repeat
      gotoxy(1,3);
  clreol;
  gotoxy(1,3);
     Write('Ingrese un DNI válido: ');
     ReadLn(dni);
     until validacion_numeros(dni)=true;
   End;
  End;

Procedure respuesta_validacion_telefono(Var telefono:shortstring);
  Begin
   If validacion_numeros(telefono)=false then
   Begin
     repeat
     gotoxy(1,11);
     clreol;
     gotoxy(1,11);
     Write('Ingrese un teléfono válido: ');
     ReadLn(telefono);
     until validacion_numeros(telefono)=true;
   End;
  End;

Function validacion_anio(anio:string):boolean;
 var
 cont:byte;
 i:byte;
Begin
validacion_anio:=false;
Cont:=0;
For i:=1 to length(anio) do
Begin
If anio[i] in ['0'..'9'] then cont:=cont+1;
End;
If cont=4 then validacion_anio:=true;
end;

Function validacion_mes(mes:shortstring):boolean;
Var
cont,i:byte;
Begin
validacion_mes:=false;
Begin
Cont:=0;
For i:=1 to length(mes) do
Begin
If mes[i] in ['0'..'9'] then cont:=cont+1;
End;
If ((cont=length(mes)) and (strtoint(mes) in [1..12])) then validacion_mes:=true;
end;
end;

Function validacion_dia(dia:shortstring):boolean;
Var
cont,i:byte;
Begin
validacion_dia:=false;
Begin
Cont:=0;
For i:=1 to length(dia) do
Begin
If dia[i] in ['0'..'9'] then cont:=cont+1;
End;
If ((cont=length(dia)) and (strtoint(dia) in [1..31])) then validacion_dia:=true;
end;
end;

Procedure BorrarPantalla();
 Begin
  TextBackground(White);
  Textcolor(Blue);
  clrscr;
  end;

end.

