unit Unit_pantallas;
{$Codepage UTF8}
interface
uses
  crt,unit_abmc,unit_principal,unit_usa_arbol,unit_manejo_archivos_personas,unit_manejo_archivos_atenciones,unit_herramientas,unit_listas;

Procedure Pantalla_estadisticas(var ar1:t_archivo_personas; var ar2:t_archivo_atenciones);
Procedure Menu_estadisticas(var ar1:t_archivo_personas; var ar2:t_archivo_atenciones;anio:string);
Procedure Menu_Listados(var ar2:T_Archivo_atenciones; var ar1:t_archivo_personas;raiz_dni:t_punt);
procedure MenuPrincipal();
Procedure MenuBMO_ATENCION(var ar2:T_Archivo_atenciones;pos:integer;var ar1:t_archivo_personas;raiz_dni:t_punt);
Procedure MenuBMC_persona(var ar1:T_Archivo_personas;pos:cardinal);
Procedure MenuAlta_persona(Var ar1:t_archivo_personas;raiz_nombre,raiz_dni:t_punt);
Procedure MenuAlta_atenciones(Var ar2:t_archivo_atenciones;raiz_dni:t_punt;dni:string;fecha:t_fecha);

Procedure Ingresar_clave(raiz_nombre,Raiz_dni:T_Punt;Var ar1:t_Archivo_personas);
Procedure Ingresar_atencion (var ar2:t_archivo_atenciones;raiz_dni:t_punt;var ar1:t_archivo_personas);
Procedure Consulta_clave(Var ar1:t_archivo_personas;raiz_nombre,raiz_dni:T_Punt);

/////ORDEN MEDICA////
Procedure Impresion_orden(aux1:t_dato_personas;aux2:t_dato_atenciones);
Procedure Orden_medica (var ar1:t_archivo_personas; var ar2:t_archivo_atenciones;raiz_dni:t_punt;pos:integer);

implementation
Procedure Pantalla_estadisticas(var ar1:t_archivo_personas; var ar2:t_archivo_atenciones);
Var anio:string;
Begin
clrscr;
marco(6);
gotoxy(30,7);
write('Ingrese año del que quiere conocer las estadísticas: ');
ReadLn(anio);
menu_estadisticas(ar1,ar2,anio);
end;

Procedure Menu_estadisticas(var ar1:t_archivo_personas; var ar2:t_archivo_atenciones;anio:string);
var
opcion:char;
begin
repeat
clrscr;
gotoxy(55,7);
writeln('MENU ESTADISTICAS');
gotoxy(26,9);
writeln('1-CANTIDAD DE ATENCIONES ENTRE DOS FECHAS');
gotoxy(26,11);
writeln('2-CANTIDAD DE ATENCIONES POR OBRA SOCIAL');
gotoxy(26,13);
writeln('3-PORCENTAJE DE ATENCIONES DETALLADO POR MESES DEL AÑO');
gotoxy(26,15);
writeln('4-PROMEDIO DE ATENCIONES DIARIAS');
gotoxy(26,17);
writeln('5-PORCENTAJE DE ATENCIONES DE PACIENTES EN OTRA CIUDAD');
gotoxy(26,19);
writeln('0-SALIR');
gotoxy(55,21);
writeln('INGRESE OPCION:');
marco(18);
gotoxy(70,21);
readln(opcion);
case opcion of
'1':cant_atenciones_entre_fechas(ar2);
'2':resp_atenciones(ar1);
'3':atenciones_mes(ar2,anio);
'4':prom_atenciones_diarias(ar2);
'5':resp_porcentaje_atenciones(ar1,ar2,anio);
end;
until opcion='0';
end;

Procedure Menu_Listados(var ar2:T_Archivo_atenciones; var ar1:t_archivo_personas;raiz_dni:t_punt);
var
opcion:char;
begin
repeat
clrscr;
gotoxy(55,7);
writeln('MENU DE LISTADOS');
gotoxy(26,9);
writeln('1-LISTADO ORDENADO POR FECHA DE TODAS LAS ATENCIONES');
gotoxy(26,11);
writeln('2-CONSULTA DE DATOS Y ATENCIONES A UN PACIENTE');
gotoxy(26,13);
writeln('0-SALIR');
gotoxy(55,15);
writeln('INGRESAR OPCIÓN:');
marco(12);
gotoxy(71,15);
readln(opcion);
case opcion of
'1':Listado_atenciones_fecha(ar2);
'2':Consultar_datos(ar1,ar2,raiz_dni);
end;
until opcion='0';
end;

////////ORDEN MEDICA///////////
Procedure Impresion_orden(aux1:t_dato_personas;aux2:t_dato_atenciones);
var
i:byte;
Begin
clrscr;
 gotoxy(2,4);
 writeln('___________________________________________________________________________________________________________________');
 gotoxy(2,5);
 writeln('___________________________________________________________________________________________________________________');
 gotoxy(2,6);
 writeln('Fecha de Prescripción: ',aux2.fecha.dia,'/',aux2.fecha.mes,'/',aux2.fecha.anio,'              validez 30 días.     ');
 gotoxy(2,7);
 writeln('___________________________________________________________________________________________________________________');
 gotoxy(2,8);
 WriteLn('   Afiliado: ',aux1.nombre_apellido,'                                                                              ');
 gotoxy(2,9);
 WriteLn('   Obra social:',aux1.Nombre_Obra_Social,   '                       Periodo desde:',aux2.Fecha.dia,'/',aux2.Fecha.mes,'/',aux2.Fecha.anio,' ');
 Gotoxy(2,10);
 writeln('   N° de afiliado:',aux1.Numero_afiliado,'                                                                         ');
 gotoxy(2,11);
 writeln('___________________________________________________________________________________________________________________');
 gotoxy(2,12);
 writeln('                                                      AUTORIZADO                                                   ');
 gotoxy(2,13);
 writeln('___________________________________________________________________________________________________________________');
 gotoxy(2,14);
 writeln(' Código                Descripción                             Cantidad Autoriz.           % Cobertura             ');
 gotoxy(2,15);
 writeln('___________________________________________________________________________________________________________________');
 begin
 for i:=1 to tam(aux2.Tratamiento) do
 begin
  gotoxy(4,15+i);
  writeln(aux2.Tratamiento.elem[i].Codigo);
  gotoxy(30,15+i);
  writeln(aux2.Tratamiento.elem[i].Descripcion);
 end;
 end;
 gotoxy(2,(15+2*i));
 writeln('___________________________________________________________________________________________________________________');
 Readkey;
 End;

Procedure Orden_medica (var ar1:t_archivo_personas; var ar2:t_archivo_atenciones;raiz_dni:t_punt;pos:integer);
var aux1:t_dato_personas;
aux2:t_dato_atenciones;
begin
If pos<>-1 then
Begin
abrir_atenciones(ar2);
Lee_Registro_atenciones(ar2,pos,aux2);
abrir_personas(ar1);
Lee_registro_personas(ar1,pos_dni(aux2.dni,raiz_dni),aux1);
If pos<>-1 then impresion_orden(aux1,aux2);
pantalla_error_atencion(pos);
cerrar_persona(ar1);
cerrar_atenciones(ar2);
End
Else pantalla_error_atencion(pos);
end;

//////MENUS///////
Procedure MenuBMO_ATENCION(var ar2:T_Archivo_atenciones;pos:integer;var ar1:t_archivo_personas;raiz_dni:t_punt);
var
opcion:char;
begin
consulta_atencion(ar2,pos);
repeat
clrscr;
gotoxy(55,6);
writeln('MENÚ MANEJO DE ATENCIONES');
gotoxy(26,8);
writeln('1- BAJA DE ATENCION');
gotoxy(26,10);
writeln('2- MODIFICACIÓN DE DATOS');
gotoxy(26,12);
writeln('3- IMPRESION ORDEN DE LA OBRA SOCIAL');
gotoxy(26,14);
writeln('0- SALIR');
gotoxy(55,16);
writeln('INGRESAR OPCIÓN:');
marco(14);
gotoxy(72,16);
readln(opcion);
case opcion of
'1':Baja_atenciones(ar2,pos);
'2':Modificar_atencion(ar2,pos);
'3':Orden_medica(ar1,ar2,raiz_dni,pos);
end;
until opcion='0';
end;

Procedure Ingresar_atencion (var ar2:t_archivo_atenciones;raiz_dni:t_punt;var ar1:t_archivo_personas);
Var pos:integer;
  fecha:t_fecha;
  dni:shortstring;
begin
buscar_atencion(ar2,ar1,pos,dni,fecha);
If pos<>-1 then menuBMO_ATENCION(ar2,pos,ar1,raiz_dni)
Else
menuAlta_atenciones(ar2,raiz_dni,dni,fecha);
end;

Procedure Ingresar_clave(raiz_nombre,Raiz_dni:T_Punt;Var ar1:t_Archivo_personas);
Begin
    clrscr;
    Consulta_clave(ar1,raiz_nombre,raiz_dni);
end;

Procedure Consulta_clave(Var ar1:t_archivo_personas;raiz_nombre,raiz_dni:T_Punt);
Var
  Direc:T_PUNT;
  Clave:string[8];
  pos:cardinal;
Begin
   Pos:=0;
   clrscr;
   gotoxy(50,7);
   writeln('INGRESAR CLAVE:');
   marco(5);
   Gotoxy(65,7);
   ReadLn (Clave);
   Direc:= Preorden(Raiz_dni,Clave);     //Unit usa arbol
   If Direc=NIL then
   begin
   clrscr;
   MenuAlta_persona(ar1,raiz_nombre,raiz_dni)
   end
   Else
    Begin
    Pos:=Direc^.Info.pos;
    MenuBMC_persona(ar1,pos);
    End;
end;

Procedure MenuBMC_persona(var ar1:T_Archivo_personas;pos:cardinal);
var
opcion:char;
begin
consultar_persona(ar1,pos);
readkey;
repeat
clrscr;
gotoxy(55,6);
writeln('MENÚ ABMC PERSONAS/ATENCIONES');
gotoxy(26,8);
writeln('1- BAJA DE PERSONAS');
gotoxy(26,10);
writeln('2- MODIFICACIÓN DE DATOS');
gotoxy(26,12);
writeln('0- SALIR');
gotoxy(55,14);
writeln('INGRESAR OPCIÓN:');
marco(14);
gotoxy(72,14);
readln(opcion);
case opcion of
'1':Baja_persona(ar1,pos);
'2':Modificar_persona(ar1,pos);
end;
until opcion='0';
end;

Procedure MenuAlta_persona(Var ar1:t_archivo_personas;raiz_nombre,raiz_dni:t_punt);
Var
  resp:char;
Begin
clrscr;
Repeat
  clrscr;
  gotoxy(45,7);
  writeln('NO SE ENCUENTRA.');
  gotoxy(45,9);
  writeln('- PARA ALTA DE PERSONAS PRESIONE 1');
  gotoxy(45,11);
  writeln('- PARA SALIR PRESIONE 0: ');
  marco(10);
  Gotoxy(70,11);
  ReadLn (Resp);
  If resp='1' then alta_persona(ar1,raiz_nombre,raiz_dni);
  Until resp in ['0'..'1'];
End;

Procedure MenuAlta_atenciones(Var ar2:t_archivo_atenciones;raiz_dni:t_punt;dni:string;fecha:t_fecha);
Var
  resp:char;
Begin
  clrscr;
  gotoxy(45,7);
  writeln('NO SE ENCUENTRA.');
  gotoxy(45,9);
  writeln('- PARA ALTA DE ATENCIONES PRESIONE 1');
  gotoxy(45,11);
  writeln('- PARA SALIR PRESIONE 0: ');
  marco(10);
  Repeat
  Gotoxy(70,11);
  ReadLn (Resp);
  until ((resp='1') or (resp='0'));
  If resp='1' then alta_atenciones(ar2,raiz_dni,dni,fecha);
End;

Procedure MenuPrincipal();
var
ar1: T_Archivo_Personas;
ar2: T_Archivo_atenciones;
raiz_nombre,raiz_dni: T_punt;
opcion:char;
begin
inicializar_arboles(ar1,raiz_nombre,raiz_dni);
repeat
Borrarpantalla();
gotoxy(55,7);
writeln('MENÚ PRINCIPAL');
gotoxy(26,9);
writeln('1- GESTION PERSONAS');
gotoxy(26,11);
writeln('2- GESTION ATENCIONES');
gotoxy(26,13);
writeln('3- LISTAS ORDENADAS');
gotoxy(26,15);
writeln('4- ESTADÍSTICAS');
gotoxy(26,17);
writeln('0- SALIR');
gotoxy(55,19);
writeln('INGRESE OPCIÓN:');
marco(17);
gotoxy(72,19);
readln(opcion);
Case opcion of
'1':Ingresar_clave(raiz_nombre,raiz_dni,ar1);
'2':Ingresar_atencion(ar2,raiz_dni,ar1);
'3':Menu_Listados(ar2,ar1,raiz_dni);
'4':pantalla_estadisticas(ar1,ar2);
end;
until opcion = '0';
end;
end.

