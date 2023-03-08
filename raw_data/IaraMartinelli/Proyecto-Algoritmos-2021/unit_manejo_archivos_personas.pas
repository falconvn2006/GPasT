unit Unit_manejo_archivos_personas;

{$codepage utf8}
INTERFACE
uses
crt,unit_listas;
const
  ruta_personas='C:\Proyecto final Algoritmos\Ruta\pers.DAT';

Type
// Datos
T_fecha=record
        dia:string[2];
        mes:string[2];
        anio:string[4];
     end;
T_dato_personas = RECORD
            Nombre_Apellido: string[50];
            Direccion: string[40];
            Ciudad: string[40];
            DNI:string[8];
            Fecha_nacimiento: t_fecha;
            Telefono: string[12];
            Nombre_Obra_Social: string[20];
            Numero_afiliado: byte;
            Estado_baja_logica: boolean;
            end;

// Archivos
T_archivo_personas= file of t_dato_personas;

  Procedure crear_personas(Var ar1:t_archivo_personas);
  Procedure abrir_personas(Var ar1:t_archivo_personas);
  procedure Cerrar_Persona(var ar1:t_archivo_personas);
  IMPLEMENTATION

  Procedure crear_personas(Var ar1:t_archivo_personas);
  Begin
    Assign(ar1,ruta_personas);
    Rewrite(ar1);
  End;


  Procedure abrir_personas(Var ar1:t_archivo_personas);
  Begin
    assign(ar1,ruta_personas);
  {$I-}
  Reset(ar1);
  {$I+}
  If IoResult<>0 then rewrite(ar1);
  End;


  procedure Cerrar_Persona(var ar1:t_archivo_personas);
  begin
  close(ar1);
  end;
  end.
