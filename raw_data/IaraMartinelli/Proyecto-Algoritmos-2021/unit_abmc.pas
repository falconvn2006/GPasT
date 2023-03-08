unit Unit_ABMC;

{$codepage UTF8}
interface
uses
  CRT,unit_manejo_archivos_personas,unit_manejo_archivos_atenciones,unit_usa_arbol,unit_principal,unit_listas,unit_herramientas,sysutils;

/////////////// ALTA, BAJA, MODIFICACION, CONSULTA PERSONAS ////////////////////
procedure Alta_persona(var ar1: t_archivo_personas; Var raiz_nombre,raiz_dni:t_punt);
Procedure Baja_persona(Var ar1:t_archivo_personas;pos:integer);
Procedure Modificar_persona(var ar1 : t_archivo_personas;pos:integer);
Procedure Consultar_persona(var ar1 : t_archivo_personas; pos:integer);
///////////////// MODIFICACION, CONSULTA, BAJA ATENCIONES //////////////////////
Procedure Alta_atenciones(Var ar2:t_archivo_atenciones;raiz_dni:t_punt;dni:string;fecha:t_fecha);
Procedure Baja_atenciones(Var ar2:t_archivo_atenciones;pos:integer);
Procedure Consulta_atencion(var ar2:t_archivo_atenciones;pos:integer);
Procedure Modificar_atencion(var ar2 : t_archivo_atenciones;pos:integer);
////////////////////// INGRESAR DATOS ABMC ATENCIONES //////////////////////////
Procedure buscar_atencion(Var ar2:t_archivo_Atenciones;var ar1:t_archivo_personas;Var pos:integer;var dni:shortstring;var r:t_fecha);
//////////////////////////// CONSULTA DE DATOS /////////////////////////////////
Procedure Muestra_personayatencion(Var ar1:t_archivo_personas;Var ar2:t_archivo_atenciones;pos:integer;dni:string);
Function pos_dni(dni:string;raiz_dni:t_punt):integer;
Procedure Consultar_datos(Var ar1:t_archivo_personas;Var ar2:t_archivo_atenciones;raiz_dni:t_punt);

Procedure inicializar_arboles(Var ar1:t_archivo_personas;Var raiz_nombre,raiz_dni:t_punt);

implementation
/////////////// ALTA, BAJA, MODIFICACION, CONSULTA PERSONAS ////////////////////

Procedure Alta_persona(var ar1: t_archivo_personas;Var raiz_nombre,raiz_dni:t_punt);
var
l:t_dato_personas;
pos:cardinal;
i:t_dato;
begin
  clrscr;
  abrir_personas(ar1);
  begin
  Cargar_persona(ar1,l);
  pos:=filesize(ar1)-1;
  i.campo:=l.nombre_apellido;
  i.pos:=pos;
  agregar(raiz_nombre,i);
  i.campo:=l.dni;
  agregar(raiz_dni,i);
  end;
  cerrar_persona(ar1);
end;

Procedure Baja_persona(Var ar1:t_archivo_personas;pos:integer);
Var
    aux:t_dato_personas;
    resp:char;
Begin
clrscr;
abrir_personas(ar1);
lee_registro_personas(ar1,pos,aux);
Muestra_registro_personas(aux);
WriteLn('¿Desea dar de baja? s/n');
ReadLn (resp);
If resp='s' then
Begin
aux.estado_baja_logica:=false;
guarda_registro_personas(ar1,pos,aux);
WriteLn('Baja exitosa.');
End;
cerrar_persona(ar1);
readkey;
End;

Procedure Modificar_persona(var ar1 : t_archivo_personas;pos:integer);
Var
  l:t_dato_personas;
  opcion:0..9;
  Nombre_Apellido: string[50];
  Direccion: string[50];
  Ciudad: string[40];
  DNI: string[8];
  fecha: t_fecha;
  Telefono: string[12];
  Nombre_Obra_Social: string[20];
  Numero_afiliado: byte;
Begin
abrir_personas(ar1);
clrscr;
lee_registro_personas(ar1,pos,l);
Muestra_registro_personas(l);
WriteLn;
Repeat
writeln('Elija campo a modificar: ');
WRITELN('1- Nombre y apellido.');
WRITELN('2- Ciudad.');
WRITELN('3- Dirección.');
WRITELN('4- Número de documento.');
WRITELN('5- Fecha de nacimiento.');
WRITELN('6- Número de teléfono.');
WRITELN('7- Nombre de obra social.');
WRITELN('8- Número de afiliado.');
WRITELN('0- Salir');
READLN(OPCION);

CASE OPCION OF
1: Begin
WriteLn('Ingrese nombre y apellido modificado: ');
ReadLn (nombre_apellido);
l.nombre_apellido:=nombre_apellido;
Guarda_Registro_personas(ar1,pos,l);
Writeln('Modificación realizada con éxito.');
End;
2: begin
writeln ('Ingrese ciudad modificada: ');
readln(ciudad);
l.ciudad:=ciudad;
Guarda_Registro_personas(ar1,pos,l);
Writeln('Modificación realizada con éxito.');
end;
3: Begin
WriteLn('Ingrese dirección: modificada: ');
ReadLn (direccion);
l.direccion:=direccion;
Guarda_Registro_personas(ar1,pos,l);
Writeln('Modificación realizada con éxito.');
End;
4: Begin
WRITELN('Ingese numero de documento modificado');
readln(dni);
l.DNI:=dni;
Guarda_Registro_personas(ar1,pos,l);
Writeln('Modificación realizada con éxito.');
end;
5:Begin
writeln('Ingrese fecha de nacimiento modificada');
writeln('Dia:');
readln(fecha.dia);
l.Fecha_nacimiento.dia:=fecha.dia;
writeln('Mes:');
readln(fecha.mes);
l.Fecha_nacimiento.mes:=fecha.mes;
writeln('Año:');
readln(fecha.anio);
l.Fecha_nacimiento.anio:=fecha.anio;
Guarda_Registro_personas(ar1,pos,l);
Writeln('Modificación realizada con éxito.');
end;
6: Begin
writeln('Ingrese número de teléfono modificado: ');
readln(telefono);
l.Telefono:=telefono;
Guarda_Registro_personas(ar1,pos,l);
Writeln('Modificación realizada con éxito.');
end;
7: Begin
writeln('Ingrese nombre de obra social modificada: ');
readln(nombre_obra_social);
l.Nombre_Obra_Social:=nombre_obra_social;
Guarda_Registro_personas(ar1,pos,l);
Writeln('Modificación realizada con éxito.');
end;
8:Begin
writeln('Ingrese número de afiliado modificado:');
readln(numero_afiliado);
l.numero_afiliado:=numero_afiliado;
Guarda_Registro_personas(ar1,pos,l);
Writeln('Modificación realizada con éxito.');
end;
end;
Until opcion=0;
cerrar_persona(ar1);
readkey;
end;

Procedure Consultar_persona(var ar1 : t_archivo_personas; pos:integer);
var
aux:t_dato_personas;
BEGIN
clrscr;
abrir_personas(ar1);
lee_registro_personas(ar1,pos,aux);
muestra_registro_personas(aux);
cerrar_persona(ar1);
readkey;
END;

///////////////// MODIFICACION, CONSULTA, BAJA ATENCIONES //////////////////////

Procedure Alta_atenciones(Var ar2:t_archivo_atenciones;raiz_dni:t_punt;dni:string;fecha:t_fecha);
Var
  Reg:t_dato_atenciones;
Begin
clrscr;
If pos_dni(dni,raiz_dni)<>-1 then cargar_datos_atenciones(ar2,reg,dni,fecha)
Else Pantalla_error_cargar_atenciones();
End;

Procedure Baja_atenciones(Var ar2:t_archivo_atenciones;pos:integer);
Var
    aux:t_dato_atenciones;
    resp:char;
    j:cardinal;
Begin
j:=0;
clrscr;
abrir_Atenciones(ar2);
lee_registro_atenciones(ar2,pos,aux);
Muestra_registro_atenciones(aux,j);
Repeat
WriteLn('¿Desea dar de baja? s/n');
ReadLn (resp);
If Upcase(resp)='S' then
Begin
aux.estado_atencion:=false;
guarda_registro_atenciones(ar2,pos,aux);
WriteLn('Baja exitosa.');
End;
until ((Upcase(resp)='S') or (Upcase(resp)='N'));
cerrar_atenciones(ar2);
readkey;
End;

Procedure Consulta_atencion(var ar2:t_archivo_atenciones;pos:integer);
Var elem:t_dato_atenciones;
    j:cardinal;
Begin
j:=0;
clrscr;
abrir_atenciones(ar2);
seek(ar2,pos);
read(ar2,elem);
muestra_registro_atenciones(elem,j);
cerrar_atenciones(ar2);
readkey;
End;

Procedure Modificar_atencion(var ar2 : t_archivo_atenciones;pos:integer);
Var
  reg:t_dato_atenciones;
  opcion:0..4;
  dni: string[8];
  Fecha: t_fecha;
  aux:t_dato_tratamiento;
  i,m:cardinal;
Begin
m:=0;
clrscr;
abrir_atenciones(ar2);
lee_registro_atenciones(ar2,pos,reg);
Muestra_registro_atenciones(reg,m);
WriteLn;
Repeat
WriteLn('Elija campo a modificar: ');
WriteLn('1- DNI.');
WriteLn('2- Fecha de atencion.');
WriteLn('3- Código de tratamiento.');
WriteLn('4- Código de descripción.');
writeln('0- Salir. ');
ReadLn(Opcion);

Case opcion of
1: Begin
WriteLn('Ingrese DNI modificado: ');
ReadLn (dni);
reg.dni:=dni;
Guarda_Registro_atenciones(ar2,pos,reg);
Writeln('Modificación realizada con éxito.');
End;

2: Begin
  writeln('Ingrese fecha de atención modificada: ');
  writeln('Dia:');
  readln(fecha.dia);
  reg.FECHA.dia:=fecha.dia;
  writeln('Mes:');
  readln(fecha.mes);
  reg.Fecha.mes:=fecha.mes;
  writeln('Año:');
  readln(fecha.anio);
  reg.Fecha.anio:=fecha.anio;
  Guarda_Registro_atenciones(ar2,pos,reg);
  Writeln('Modificación realizada con éxito.');
end;

3: Begin
WriteLn('Ingrese el tratamiento que quiere modificar (número): ');
ReadLn (i);
writeln('Ingrese el codigo modificado: ');
ReadLn(aux.codigo);
reg.Tratamiento.elem[i].Codigo:=aux.codigo;
Guarda_Registro_atenciones(ar2,pos,reg);
Writeln('Modificación realizada con éxito.');
End;

4:begin
WriteLn('Ingrese el número de tratamiento que quiere modificar: ');
readln(i);
writeln('Ingrese la descripción modificada: ');
ReadLn(aux.descripcion);
reg.Tratamiento.elem[i].descripcion:=aux.descripcion;
Guarda_Registro_atenciones(ar2,pos,reg);
Writeln('Modificación realizada con éxito.');
end;
end;
Until opcion=0;
cerrar_atenciones(ar2);
readkey;
End;

////////////////////// INGRESAR DATOS ABMC ATENCIONES //////////////////////////

Procedure buscar_atencion(Var ar2:t_archivo_Atenciones;var ar1:t_archivo_personas;Var pos:integer;var dni:shortstring;var r:t_fecha);
Var
    aux:t_dato_atenciones;
    fecha_buscada,fecha_archivo:integer;
    i:cardinal;
Begin
clrscr;
gotoxy(45,8);
write('INGRESAR DNI:');
gotoxy(45,10);
Write('INGRESE FECHA DESEADA(dd/mm/aa):');
marco(10);
gotoxy(59,8);
readln(dni);
ingresar_dni(dni);
ingresar_fecha_atencion(r);
fecha_buscada:=(strtoint(r.anio)*365)+(strtoint(r.mes)*30)+(strtoint(r.dia));
pos:=-1;
abrir_atenciones(ar2);
i:=0;
while not eof(ar2) do
Begin
  Seek(ar2,i);
  read(ar2,aux);
  fecha_archivo:=(strtoint(aux.fecha.anio)*365)+(strtoint(aux.fecha.mes)*30)+(strtoint(aux.fecha.dia));
  If ((fecha_archivo=fecha_buscada) and (aux.dni=dni)) then pos:=i;
  inc(i);
End;
cerrar_atenciones(ar2);
end;

//////////////////////////// CONSULTA DE DATOS /////////////////////////////////

procedure Muestra_personayatencion(Var ar1:t_archivo_personas;Var ar2:t_archivo_atenciones;pos:integer;dni:string);
Var
aux:t_dato_personas;
aux2:t_dato_atenciones;
j:cardinal;
Begin
  j:=14;
  abrir_personas(ar1);
  abrir_atenciones(ar2);
  WriteLn;
  WriteLn('• DATOS PERSONALES');
  Writeln;
  seek(ar1,0);
  Lee_Registro_personas(ar1,pos,aux);
  Muestra_registro_personas(aux);
  Writeln;
  WriteLn('• REGISTRO DE ATENCIONES');
  WriteLn;
  seek(ar2,0);
  while (not eof(ar2)) do
  begin
    read(ar2,aux2);
    if ((dni=(aux2.dni)) and (aux2.estado_atencion=true)) then
    Begin
    Arreglo_datos_atenciones(j,aux2);
    j:=2+tam(aux2.tratamiento)+j;                                                                                   //modificado
    If j>25 then
    begin
    readkey;
    clrscr;
    j:=0;
    end;
    end;
  End;
  cerrar_persona(ar1);
  cerrar_atenciones(ar2);
end;

Function pos_dni(dni:string;raiz_dni:t_punt):integer;
Var direc:t_punt;
Begin
pos_dni:=-1;
Direc:= Preorden(Raiz_dni,dni);
If direc<>NIL then Pos_dni:=Direc^.info.pos;
end;

Procedure Consultar_datos(Var ar1:t_archivo_personas;Var ar2:t_archivo_atenciones;raiz_dni:t_punt);
Var
dni:string[8];
Begin
clrscr;
Write('Ingresar el DNI de la persona a mostrar: ');
ReadLn(dni);
If pos_dni(dni,raiz_dni)<>-1 then  Muestra_personayatencion(ar1,ar2,pos_dni(dni,raiz_dni),dni)
Else WriteLn('La persona no se encuentra registrada.');
readkey;
End;

Procedure inicializar_arboles(Var ar1:t_archivo_personas;Var raiz_nombre,raiz_dni:t_punt);
Var pos:integer;
Begin
abrir_personas(ar1);
pos:=filesize(ar1);
crear_arbol(raiz_nombre);
crear_arbol(raiz_dni);
if pos<>0 then
begin
  ArmarArbolNombre(raiz_nombre,ar1);
  ArmarArbolDni(raiz_dni,ar1);
end;
Cerrar_persona(ar1);
end;


end.


