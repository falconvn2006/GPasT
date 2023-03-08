unit Unit_principal;
{$Codepage UTF8}
INTERFACE
uses
crt,unit_manejo_archivos_personas,unit_manejo_archivos_atenciones,unit_usa_arbol,unit_listas,unit_herramientas,sysutils;

/// Registros ///
Procedure Lee_Registro_personas(Var ar1:t_archivo_personas; Pos:cardinal; Var reg:t_dato_personas);
Procedure Lee_Registro_atenciones(Var ar2:t_archivo_atenciones; Pos:cardinal; Var reg:t_dato_atenciones);
Procedure Guarda_Registro_personas(Var ar1:t_archivo_personas; Pos:cardinal; Reg:t_dato_personas);
Procedure Guarda_Registro_atenciones(Var ar2:t_archivo_atenciones; Pos:cardinal; Reg:t_dato_atenciones);
Procedure Cargar_persona(Var ar1:t_archivo_personas;Var reg:t_dato_personas);
Procedure Cargar_datos_atenciones(Var ar2:t_archivo_atenciones;Var reg:t_dato_atenciones;dni:string;fecha:t_fecha);
Procedure Muestra_registro_personas(var reg: t_dato_personas);
Function Estado_atencion(aux:boolean):string;
Procedure Muestra_registro_atenciones(var reg: t_dato_atenciones;j:cardinal);
Procedure Muestra_atencion(var reg: t_dato_atenciones);
Procedure ingresar_fecha_posicionado(Var fecha:t_fecha);

//////// Listados: ////////
Procedure Listado_personas(Var Ar1:T_Archivo_personas);
Procedure Listado_atenciones_fecha (Var Ar2:T_Archivo_atenciones);
Procedure Arreglo_datos_atenciones(j:cardinal;aux:t_dato_Atenciones);
Procedure Listado_ordenado_persona(Var ar2:t_archivo_atenciones);

//////// Estadísticas: ////////
//Cantidad de atenciones entre dos fechas
Procedure ingresar_dos_fechas(Var primer_fecha,seg_fecha:integer);
Procedure atenciones_en_intervalo(VAR ar2: T_archivo_atenciones; primer_fecha, seg_fecha: longint; VAR cant_atenciones:integer);
Procedure cant_atenciones_entre_fechas(Var ar2:t_archivo_atenciones);
//Cantidad de atenciones por obra social
procedure atenciones_obra_social(var ar1:t_archivo_personas; var contador_iosper,contador_sancor,contador_pami,contador_municipal:cardinal);
procedure resp_atenciones (var ar1:t_archivo_personas);
//Porcentaje de atenciones detallado por meses en el año
Procedure inicializar_vector_contador(Var vec:t_dato_contador);
Procedure buscar_anio(l:t_lista_contador;anio:string;Var pos:cardinal;Var buscado:boolean);
Procedure Cargar_elementos_lista(Var l:t_lista_contador;elem:t_dato_atenciones);
Procedure cargar_lista_contador(Var ar2:t_archivo_Atenciones;Var l:t_lista_contador);
Function mes(j:cardinal):string;
Function cont_total(elem:t_dato_contador):cardinal;
Procedure Atenciones_mes (Var ar2:t_archivo_atenciones;anio:string);
//Promedio de atenciones diarias
Procedure prom_atenciones_diarias(VAR ar2: T_archivo_atenciones);
Procedure encontrar_ciudad(Var ar1:t_archivo_personas;dni:string;Var ciudad:string);
Procedure porc_atenciones_otroslugares(Var ar1:t_archivo_personas;Var ar2:t_archivo_atenciones;var contador_vecinos,contador_total:cardinal;anio:string);
Procedure resp_porcentaje_atenciones (Var ar1:t_archivo_personas;Var ar2:t_archivo_atenciones;anio:string);
//Arboles
Procedure ArmarArbolNombre(var raiz1: t_punt; var ar1: t_archivo_personas);
Procedure ArmarArbolDni(var raiz2:t_punt; var ar1: t_archivo_personas);

Procedure ingresar_fecha(Var fecha:t_fecha;i:byte);

Implementation

  /// Registros ////
  Procedure Lee_Registro_personas(Var ar1:t_archivo_personas; Pos:cardinal; Var reg:t_dato_personas);
  Begin
   Seek(ar1,pos);
   Read(ar1,reg);
  end;

  Procedure Lee_Registro_atenciones(Var ar2:t_archivo_atenciones; Pos:cardinal; Var reg:t_dato_atenciones);
  Begin
   Seek(ar2,pos);
   Read(ar2,reg);
  end;

  Procedure Guarda_Registro_personas(Var ar1:t_archivo_personas; Pos:cardinal; Reg:t_dato_personas);
  Begin
   Seek(ar1,pos);
   Write(ar1,reg);
  end;

  Procedure Guarda_Registro_atenciones(Var ar2:t_archivo_atenciones; Pos:cardinal; Reg:t_dato_atenciones);
  Begin
   Seek(ar2,pos);
   Write(ar2,reg);
  end;

  Procedure Cargar_persona(Var ar1:t_archivo_personas;Var reg:t_dato_personas);
  Var
    i:cardinal;
    resp:string[2];
  Begin
    I:=Filesize(Ar1);
    write('DNI: ');
    readln(reg.dni);
    respuesta_validacion_dni(reg.dni);
    If not Validacion_existencia_Dni(ar1,reg.dni) then
    Begin
    write('Nombre y apellido: ');
    readln(reg.Nombre_Apellido);
    write('Dirección: ');
    readln(reg.direccion);
    write('Ciudad: ');
    readln(reg.ciudad);
    writeln('Fecha de nacimiento: ');
    ingresar_fecha_posicionado(reg.fecha_nacimiento);
    write('Teléfono: ');
    readln(reg.telefono);
    respuesta_validacion_telefono(reg.telefono);
    write('Nombre de obra social (Iosper, Sancor, Municipal, Pami): ');
    readln(reg.Nombre_Obra_Social);
    write('Número de afiliado: ');
    readln(reg.Numero_afiliado);
    reg.estado_baja_logica:= true;
    writeln('Confima los datos ingresados? Verifique. Responda s/n');
    readln(resp);
    if (upcase(resp))='S' then
    Guarda_Registro_personas(Ar1,i,Reg);
    End
    Else WriteLn('La persona de DNI ',reg.dni,' ya se encuentra registrada en el archivo.');
  END;

  Procedure Cargar_datos_atenciones(Var ar2:t_archivo_atenciones;Var reg:t_dato_atenciones;dni:string;fecha:t_fecha);
  Var j,i:cardinal;
      N:byte;
      aux:t_dato_tratamiento;
  begin
    abrir_atenciones(ar2);
    j:=Filesize(Ar2);
    reg.dni:=dni;
    writeln('DNI: ',dni);
    reg.fecha.mes:=fecha.mes;
    reg.fecha.dia:=fecha.dia;
    reg.fecha.anio:=fecha.anio;
    writeln('Facha de la atencion: ',fecha.dia,'/',fecha.mes,'/',fecha.anio);
    writeln('Ingrese cantidad de atenciones realizadas : ');
    readln(N);
    crear_lista(reg.tratamiento);
    for i:=1 to N do
    begin
    WriteLn('-------------------------');
    writeln('Código: ');
    readln(aux.Codigo);
    writeln('Descripción: ');
    readln(aux.descripcion);
    agregar_lista(reg.tratamiento,aux);
    end;
    reg.estado_atencion:=true;
    Guarda_Registro_atenciones(Ar2,j,Reg);
    cerrar_atenciones(ar2);
    WriteLn('Atención registrada exitosamente.');
    readkey;
  end;

  Procedure Muestra_registro_personas(var reg: t_dato_personas);
  begin
    writeln('Nombre y apellido: ',reg.nombre_apellido);
    writeln('Direccion: ',reg.direccion );
    writeln('Ciudad: ',reg.ciudad);
    writeln('DNI: ',reg.dni);
    writeln('Fecha de nacimiento: ',reg.fecha_nacimiento.Dia,'/',reg.fecha_nacimiento.mes,'/',reg.fecha_nacimiento.anio);
    writeln('Teléfono: ',reg.telefono);
    writeln('Nombre de obra social: ',reg.nombre_obra_social);
    writeln('Numero de afiliado: ',reg.numero_afiliado);
    If reg.estado_baja_logica=FALSE then writeln('Estado de baja lógica: ',reg.estado_baja_logica);
  end;

  Function Estado_atencion(aux:boolean):string;
  Begin
    If aux then estado_atencion:='Activo'
    ELse estado_atencion:='Finalizado/Cancelado'
  End;

  Procedure Muestra_atencion(var reg: t_dato_atenciones);
  var
    i:byte;
  begin
  WriteLn('- - - - - - - - - - - - - - - - - - - - - - - - -');
  writeln('Atención del día: ',reg.fecha.dia,'/',reg.fecha.mes,'/',reg.fecha.anio);
  WriteLn('Estado del tratamiento: ',estado_atencion(reg.estado_atencion));
  for i:= 1 to tam(reg.tratamiento) do
  Begin
  WriteLn('-------------------------');
  writeln('Código: ',reg.tratamiento.elem[i].codigo);
  writeln('Tratamiento: ',reg.tratamiento.elem[i].descripcion);
  End;
  WriteLn('-------------------------');
  readkey;
  end;

  Procedure ingresar_fecha_posicionado(Var fecha:t_fecha);
   Begin
  write('Año: ');
  readln(fecha.anio);
  while not validacion_anio(fecha.anio) do
  begin
    gotoxy(1,6);
    clreol;
    gotoxy(1,6);
    write('Ingrese un año valido: ');
    readln(fecha.anio);
  end;
  write('Mes: ');
  readln(fecha.mes);
  While not validacion_mes(fecha.mes) do
  Begin
    gotoxy(1,7);
    clreol;
    gotoxy(1,7);
    Write('Ingrese un mes válido: ');
    readln(fecha.mes);
  End;
  write('Día: ');
  readln(fecha.dia);
  While not validacion_dia(fecha.dia) do
  Begin
    gotoxy(1,8);
    clreol;
    gotoxy(1,8);
    Write('Ingrese un día válido: ');
    readln(fecha.dia);
  End;
  end;

  Procedure ingresar_fecha(Var fecha:t_fecha;i:byte);
   Begin
  write('Año: ');
  readln(fecha.anio);
  while not validacion_anio(fecha.anio) do
  begin
    gotoxy(1,2+i);
    clreol;
    gotoxy(1,2+i);
    write('Ingrese un año valido: ');
    readln(fecha.anio);
  end;
  write('Mes: ');
  readln(fecha.mes);
  While not validacion_mes(fecha.mes) do
  Begin
    gotoxy(1,3+i);
    clreol;
    gotoxy(1,3+i);
    Write('Ingrese un mes válido: ');
    readln(fecha.mes);
  End;
  write('Día: ');
  readln(fecha.dia);
  While not validacion_dia(fecha.dia) do
  Begin
    gotoxy(1,4+i);
    clreol;
    gotoxy(1,4+i);
    Write('Ingrese un día válido: ');
    readln(fecha.dia);
  End;
  end;

  //////// Listados: ////////
  Procedure Listado_personas(Var Ar1:T_Archivo_personas);
  Var
   Reg:t_dato_personas;
   I:Byte;
  Begin
    abrir_personas(ar1);
    i:=0;
    While not eof(ar1) do
     Begin
       lee_registro_personas(ar1,i,reg);
       if reg.estado_baja_logica = True then
       Muestra_Registro_personas(Reg);
       inc(i);
     End;
    cerrar_persona(ar1);
    Readkey;
  End;

  Procedure Muestra_registro_atenciones(var reg: t_dato_atenciones;j:cardinal);
  var
    i:byte;
  begin
    gotoxy(1,3+j);
    writeln('DNI');
    gotoxy(15,3+j);
    writeln('FECHA');
    gotoxy(30,3+j);
    writeln('ESTADO');
    gotoxy(55,3+j);
    writeln('CÓDIGO');
    gotoxy(65,3+j);
    writeln('DESCRIPCIÓN');
    gotoxy(1,4+j);
    write(reg.DNI);
    gotoxy(15,4+j);
    write(reg.fecha.dia,'/',reg.fecha.mes,'/',reg.fecha.anio);
    gotoxy(30,4+j);
    Write(estado_atencion(reg.estado_atencion));
    for i:= 1 to tam(reg.tratamiento) do
    Begin
    gotoxy(55,3+i+j);
    write(reg.tratamiento.elem[i].codigo);
    gotoxy(65,3+i+j);
    write(reg.tratamiento.elem[i].descripcion);
    end;
  end;

  Procedure Listado_atenciones_fecha (Var Ar2:T_Archivo_atenciones);
  Var
   Reg:t_dato_atenciones;
   I,j:Byte;
  Begin
  abrir_atenciones(ar2);
    i:=0;
    j:=0;
    clrscr;
    writeln('_________________________________________________________________________________');
    for i:=0 to filesize(ar2)-1 do
     begin
       lee_registro_atenciones(ar2,i,reg);
       Muestra_Registro_atenciones(Reg,j);
       j:=2+tam(reg.tratamiento)+j;
       if j>=25 then
       begin
       readkey;
       clrscr;
       j:=0;
       end;
       End;
    gotoxy(1,3+tam(reg.tratamiento)+j);
    writeln('_________________________________________________________________________________');
    cerrar_atenciones(ar2);
    Readkey;
  End;

  Procedure Arreglo_datos_atenciones(j:cardinal;aux:t_dato_Atenciones);
  Begin
    gotoxy(1,3+j);
  writeln('DNI');
  gotoxy(15,3+j);
  writeln('FECHA');
  gotoxy(30,3+j);
  writeln('ESTADO DE TRATAMIENTO');
  gotoxy(55,3+j);
  writeln('CÓDIGO');
  gotoxy(65,3+j);
  writeln('DESCRIPCIÓN');
  Muestra_registro_atenciones(aux,j);
  End;

  Procedure Listado_ordenado_persona(Var ar2:t_archivo_atenciones);
  Var
  dni:string[8];
  aux:t_dato_atenciones;
  estado:boolean;
  j:cardinal;
  Begin
  clrscr;
  WriteLn('Ingresar el DNI de la persona a mostrar: ');
  ReadLn(dni);
  abrir_atenciones(ar2);
  Seek(ar2,0);
  estado:=false;
  j:=0;
  clrscr;
  While not EOF(ar2) do
  Begin
    read(ar2,aux);
    If (aux.dni=dni) then
    Begin

  {  If j>20 then
    begin
    readkey;
    clrscr;
    j:=0;
    end;}

    Arreglo_datos_atenciones(j,aux);
    estado:=true;
    j:=2+tam(aux.tratamiento)+j;

    end;
  End;
  If not estado then WriteLn('No se encontraron atenciones de dicho paciente.');
  cerrar_atenciones(ar2);
  readkey;
  end;

  //////// Estadísticas: ////////
  //Cantidad de atenciones entre dos fechas

  Procedure Ingresar_dos_fechas(Var primer_fecha,seg_fecha:integer);
  Var aux1,aux2:t_fecha;
  Begin
  clrscr;
  Writeln('Ingrese la primer fecha: ');
 { write('Dia: ');
  readln(aux1.dia);
  write('Mes: ');
  readln(aux1.mes);
  write('Año: ');
  readln(aux1.anio); }
  ingresar_fecha(aux1,0);
  primer_fecha:=(strtoint(aux1.anio)*365)+(strtoint(aux1.mes)*30)+(strtoint(aux1.dia));
  Writeln ('Ingrese segunda fecha: ');
  {write('Dia: ');
  readln(aux2.dia);
  write('Mes: ');
  readln(aux2.mes);
  write('Año: ');
  readln(aux2.anio);}
  ingresar_fecha(aux2,1);
  seg_fecha:=(strtoint(aux2.anio)*365)+(strtoint(aux2.mes)*30)+(strtoint(aux2.dia));
  End;

  Procedure atenciones_en_intervalo(VAR ar2: T_archivo_atenciones; primer_fecha, seg_fecha: longint; VAR cant_atenciones:integer);
  VAR
     fecha_archivo: integer;
     r: T_dato_atenciones;
  Begin
  Seek(ar2,0);
  While not EOF(ar2) do
  Begin
  read(ar2,r);
  fecha_archivo:=(strtoint(r.fecha.dia))+(strtoint(r.fecha.mes)*30)+(strtoint(r.fecha.anio)*365);
  If ((fecha_archivo>=primer_fecha) and (fecha_archivo<=seg_fecha)) then cant_atenciones:=cant_atenciones+1;
  end;
  end;

  Procedure cant_atenciones_entre_fechas(Var ar2:t_archivo_atenciones);
  Var cant_atenciones,primer_fecha,seg_fecha:integer;
  Begin
  abrir_atenciones(ar2);
  ingresar_dos_fechas(primer_fecha,seg_fecha);
  atenciones_en_intervalo(ar2,primer_fecha,seg_fecha,cant_atenciones);
  WriteLn('La cantidad de atenciones entre las fechas ingresadas es de: ',cant_atenciones);
  cerrar_atenciones(ar2);
  readkey;
  end;

  //Cantidad de atenciones por obra social
  procedure atenciones_obra_social(var ar1:t_archivo_personas; var contador_iosper,contador_sancor,contador_pami,contador_municipal:cardinal);
  var
    aux:t_dato_personas;
    i:cardinal;
  Begin
  contador_iosper:=0;
  contador_sancor:=0;
  contador_municipal:=0;
  contador_pami:=0;
  for i:=0 to filesize(ar1)-1 do
  Begin
  lee_registro_personas(ar1,i,aux);
  case upcase(aux.nombre_obra_social) of
  'IOSPER':contador_iosper:=contador_iosper+1;
  'SANCOR':contador_sancor:=contador_sancor+1;
  'MUNICIPAL':contador_municipal:=contador_municipal+1;
  'PAMI':contador_pami:=contador_pami+1;
  end;
  end;
  end;

  procedure resp_atenciones (var ar1:t_archivo_personas);
  var
  contador_iosper,contador_sancor,contador_pami,contador_municipal:cardinal;
  Begin
  abrir_personas(ar1);
  atenciones_obra_social(ar1,contador_iosper,contador_sancor,contador_pami,contador_municipal);
  writeln('Las atenciones por obra social son: ');
  writeln('IOSPER: ',contador_iosper);
  writeln('SanCor: ',contador_sancor);
  writeln('Municipal: ',contador_municipal);
  writeln('PAMI: ',contador_pami);
  readkey;
  cerrar_persona(ar1);
  end;

  //Porcentaje de atenciones por meses en el año
  Procedure Inicializar_vector_contador(Var vec:t_dato_contador);
  Var j:cardinal;
  Begin
  For j:=1 to 12 do
    Begin
      vec.mes[j]:=0;
    End;
  End;

  Procedure Buscar_anio(l:t_lista_contador;anio:string;Var pos:cardinal;Var buscado:boolean);
  Var i:cardinal;
  Begin
  buscado:=false;
  For i:=1 to tam_contador(l) do
  Begin
    If l.elem[i].anio=anio then
    Begin
    buscado:=true;
    pos:=i;
    end;
  End;
  End;

  Procedure Cargar_elementos_lista(Var l:t_lista_contador;elem:t_dato_atenciones);
  Var aux:t_dato_contador;
      pos:cardinal;
      buscado:boolean;
      t:1..12;
  Begin
  buscar_anio(l,elem.fecha.anio,pos,buscado);
  t:=strtoint(elem.fecha.mes);

  If buscado then
  Begin
  l.elem[pos].mes[t]:=l.elem[pos].mes[t]+1;
  End;

  If ((tam_contador(l)=0) or (not buscado)) then
  Begin
  aux.anio:=elem.fecha.anio;
  inicializar_vector_contador(aux);
  aux.mes[t]:=1;
  Agregar_lista_contador(l,aux);
  End;

  End;

  Procedure Cargar_lista_contador(Var ar2:t_archivo_Atenciones;Var l:t_lista_contador);
  Var i:cardinal;
     elem:t_dato_atenciones;
  Begin
  Crear_lista_contador(l);
  For i:=0 to Filesize(ar2)-1 do
  Begin
    seek(ar2,i);
    Read(ar2, elem);
    Cargar_elementos_lista(l,elem);
  End;
  End;

  Function Mes(j:cardinal):string;
  Begin
  Case j of
  1:mes:='ENERO';
  2:mes:='FEBRERO';
  3:mes:='MARZO';
  4:mes:='ABRIL';
  5:mes:='MAYO';
  6:mes:='JUNIO';
  7:mes:='JULIO';
  8:mes:='AGOSTO';
  9:mes:='SEPTIEMBRE';
  10:mes:='OCTUBRE';
  11:mes:='NOVIEMBRE';
  12:mes:='DICIEMBRE';
  end;
  end;

  Function Cont_total(elem:t_dato_contador):cardinal;
  Var i:1..12;
  Begin
  cont_total:=0;
  For i:=1 to 12 do
  Begin
  cont_total:=cont_total+elem.mes[i];
  End;
  If cont_total=0 then cont_total:=1;
  end;

  Procedure Atenciones_mes (Var ar2:t_archivo_atenciones;anio:string);
  Var
     pos:integer;
     i:cardinal;
     j:1..12;
     l:t_lista_contador;
  Begin
     abrir_atenciones(ar2);
     cargar_lista_contador(ar2,l);
     clrscr;
     pos:=-1;
     For i:=1 to tam_contador(l) do
     Begin
       If l.elem[i].anio=anio then pos:=i;
     end;
     clrscr;
     If pos<>-1 then
     Begin
       WriteLn('PORCENTAJE DE ATENCIONES: ');
       For j:=1 to 12 do
       Begin
       writeln(mes(J),': ',((l.elem[pos].mes[j]*100)/cont_total(l.elem[pos])):2:2,'%');
       End;
     End
     Else WriteLn('No se encontraron registros de atenciones en la fecha ingresada.');
     readkey;
     cerrar_atenciones(ar2);
  End;

  //Promedio de atenciones diarias
  Procedure prom_atenciones_diarias(VAR ar2: T_archivo_atenciones);
  Var
  primer_fecha, seg_fecha: longint;
  promedio_consultas: real;
  cant_atenciones:integer;
  Begin
   clrscr;
   abrir_atenciones(ar2);
   Ingresar_dos_fechas(primer_fecha,seg_fecha);
   atenciones_en_intervalo(ar2, primer_fecha, seg_fecha,cant_atenciones);
   if (seg_fecha-primer_fecha)<> 0 then
   Begin
   promedio_consultas := (cant_atenciones/(seg_fecha-primer_fecha));
   writeln('El promedio de consultas diarias es de: ',promedio_consultas:4:2);
   end
   else
   writeln('No es posible realizar el calculo, ingrese otro rango de fechas');
   cerrar_atenciones(ar2);
   readkey;
  End;

  //Porcentaje de atenciones de pacientes de otra ciudad
  Procedure encontrar_ciudad(Var ar1:t_archivo_personas;dni:string;Var ciudad:string);
  Var elem:t_dato_personas;
  Begin
  seek(ar1,0);
  While not EOF(ar1) do
  Begin
  read(ar1,elem);
  If elem.dni=dni then ciudad:=elem.ciudad
  End;
  End;

  Procedure porc_atenciones_otroslugares(Var ar1:t_archivo_personas;Var ar2:t_archivo_atenciones;var contador_vecinos,contador_total:cardinal;anio:string);
  var
  aux:t_dato_atenciones;
  ciudad:string;
  Begin
  contador_vecinos:=0;
  contador_total:=0;
  seek(ar2,0);
  Begin
  While not EOF(ar2) do
  Begin
  read (ar2,aux);

  If aux.Fecha.anio=anio then
  Begin
  contador_total:=(contador_total)+1;
  encontrar_ciudad(ar1,aux.dni,ciudad);
  if ((upcase(ciudad) <> ('CONCEPCION DEL URUGUAY')) AND (upcase(ciudad)<> ('CONCEPCIÓN DEL URUGUAY'))) then
  contador_vecinos:=contador_vecinos+1;
  End;
  end;
  end;
  end;

  Procedure resp_porcentaje_atenciones (Var ar1:t_archivo_personas;Var ar2:t_archivo_atenciones;anio:string);
  var
  contador_vecinos,contador_total:cardinal;
  Begin
  clrscr;
  abrir_personas(ar1);
  abrir_atenciones(ar2);
  porc_atenciones_otroslugares(ar1,ar2,contador_vecinos,contador_total,anio);
  If contador_total<>0 then WriteLn('El porcentaje de atenciones de pacientes de otra ciudad es del: ', contador_vecinos*100/contador_total:4:2,'%')
  Else
    WriteLn('No hay atenciones registradas de pacientes.');
  Readkey;
  cerrar_persona(ar1);
  cerrar_atenciones(ar2);
  End;

  Procedure ArmarArbolNombre(var raiz1: t_punt; var ar1: t_archivo_personas);
var aux : t_dato;
r:t_dato_personas;
i:integer;
Begin
seek(ar1,0);
For i:=0 to filesize(ar1)-1 do
Begin
(lee_registro_personas(ar1,i,r));
aux.campo:=(r.nombre_apellido);
agregar(raiz1,aux);
end;
end;

Procedure ArmarArbolDni(var raiz2:t_punt; var ar1: t_archivo_personas);
var aux : t_dato;
r:t_dato_personas;
i:integer;
begin
seek(ar1,0);
for i:=0 to filesize(ar1)-1 do
begin
(lee_registro_personas(ar1,i,r));
aux.campo:=(r.dni);
aux.pos:=i;
agregar(raiz2,aux);
end;
end;
end.

