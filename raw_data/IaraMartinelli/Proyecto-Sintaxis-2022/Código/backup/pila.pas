unit Pila;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils,Base;


PROCEDURE CREARPILA(VAR P:t_pila);
PROCEDURE APILAR (VAR P:t_pila; X:t_dato_pila);
FUNCTION PILA_LLENA (VAR P:t_pila): BOOLEAN;
FUNCTION PILA_VACIA (VAR P:t_pila): BOOLEAN;
PROCEDURE DESAPILAR (VAR P:t_pila;VAR X:t_dato_pila);
Procedure ApilarTodos(var Celda:t_produccion; var padre:t_arbol; var pila: t_pila);


implementation
PROCEDURE CREARPILA(VAR P:t_pila);
BEGIN
P.TAM:=0;
P.TOPE:=NIL;
END;
PROCEDURE APILAR (VAR P:t_pila; X:t_dato_pila);
VAR DIR:T_PUNT_pila;
BEGIN
NEW (DIR);
DIR^.INFO:= X;
DIR^.SIG:= P.TOPE;
P. TOPE:=DIR;
INC(P.TAM)
END;
PROCEDURE DESAPILAR (VAR P:t_pila;VAR X:t_dato_pila);
VAR dir:t_punt_pila;
BEGIN
X:= P.TOPE^.INFO;
dir:=P.TOPE;
P.TOPE:=P.TOPE^.sig;
DISPOSE (dir);
DEC(P.TAM)
END;

Procedure ApilarTodos(var Celda:t_produccion; var padre:t_arbol; var pila: t_pila);
var
dir: t_punt;
i:byte;
x:t_dato_pila;
A:tsimbgram;
begin
for i:= celda.cant downto 1 do
  begin
  x.simb:=celda.elem[i];
  x.nodo:=padre^.Hijos[i];
  apilar(pila,x);
  end;
end;

end.

