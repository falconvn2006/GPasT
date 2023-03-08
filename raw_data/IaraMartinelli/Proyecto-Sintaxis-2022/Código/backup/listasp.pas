unit listasp;

{$mode objfpc}{$H+}

interface

uses
  base;
PROCEDURE RECUPERAR2 (VAR L:t_produccion; POSICION: integer; VAR X:tsimbgram);
FUNCTION LISTA_LLENA (VAR L:t_produccion): BOOLEAN;
FUNCTION LISTA_VACIA (VAR L:t_produccion): BOOLEAN;
FUNCTION TAMANIO (VAR L:t_produccion):BYTE;

implementation
{PROCEDURE CREAR (VAR L:t_produccion);
BEGIN
L.cant:= 0;
END;}
PROCEDURE RECUPERAR2 (VAR L:elem; POSICION: integer; VAR X:tsimbgram);
BEGIN
X:= L.ELEM[POSICION]
END;
{PROCEDURE AGREGAR (VAR L:t_produccion; X:tsimbgram);
BEGIN
INC(L.cant);
L.ELEM[L.TAM]:= X;
END;    }
FUNCTION LISTA_LLENA (VAR L:t_produccion): BOOLEAN;
BEGIN
LISTA_LLENA:= L.cant = 6;
END;
FUNCTION LISTA_VACIA (VAR L:t_produccion): BOOLEAN;
BEGIN
LISTA_VACIA:= L.cant = 0;
END;
FUNCTION TAMANIO (VAR L:t_produccion):BYTE;
BEGIN
TAMANIO:= L.cant;
END;
{
PROCEDURE DESPLAZAR (VAR L:t_produccion; POSICION:BYTE);
VAR
I:BYTE;
BEGIN
FOR I:= POSICION TO L.TAM - 1 DO
L.ELEM[I] := L.ELEM[I+1];
END;
PROCEDURE ELIMINAR (VAR L:t_produccion; POSICION:BYTE; VAR X:tsimbgram);
BEGIN
X:= L.ELEM[POSICION];
IF POSICION <> TAMANIO(L) THEN DESPLAZAR(L,POSICION); //SI EL ELEMENTO QUE SE ELIMINÓ ESTÁ AL PRINCIPIO O AL MEDIO
DEC(L.TAM);
END;
PROCEDURE MODIFICA (VAR L:t_produccion; POSICION:BYTE; Z:tsimbgram);
BEGIN
L.ELEM[POSICION]:= Z;
END;      }

end.

