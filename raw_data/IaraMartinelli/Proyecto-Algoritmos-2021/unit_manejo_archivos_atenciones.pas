unit Unit_manejo_archivos_atenciones;

interface
uses unit_manejo_archivos_personas,unit_listas;
const
   ruta_atenciones='C:\Proyecto final Algoritmos\Ruta\aten.DAT';
type
T_dato_atenciones= RECORD
            DNI: string[8];
            Fecha: t_fecha;
            Tratamiento: T_lista_tratamiento;
            estado_atencion:boolean;
            End;

T_archivo_atenciones= file of t_dato_atenciones;
Procedure crear_atenciones(Var ar2:t_archivo_atenciones);
Procedure abrir_atenciones(Var ar2:t_archivo_atenciones);
procedure Cerrar_atenciones(var ar2 :t_archivo_atenciones);

implementation
Procedure crear_atenciones(Var ar2:t_archivo_atenciones);
 Begin
   Assign(ar2,ruta_atenciones);
   Rewrite(ar2);
 End;

Procedure abrir_atenciones(Var ar2:t_archivo_atenciones);
 Begin
 assign(ar2,ruta_atenciones);
 {$I-}
 Reset(ar2);
 {$I+}
 If IoResult<>0 then rewrite(ar2);
 End;

procedure Cerrar_atenciones(var ar2 :t_archivo_atenciones);
begin
close (ar2);
end;
end.

