unit arbol;

{$mode objfpc}{$H+}

interface

uses
  base;
procedure crear_nodo(var raiz : t_arbol; complex:tsimbgram);
Procedure agregar_hijo(var raiz:t_arbol; var hijo:t_arbol);
Procedure Mostrar_arbol (var arbol:t_arbol);

implementation
procedure crear_nodo(var raiz : t_arbol; complex:tsimbgram);
var i: integer;
 begin
        new(raiz);
        raiz^.simb:=complex;
        raiz^.lexema:= '' ;
        raiz^.chijos:= 0;
        for i:= 1 to 6 do
        raiz^.hijos[i]:=nil;

 end;
Procedure agregar_hijo(var raiz:t_arbol; var hijo:t_arbol);
begin
  If raiz^.chijos< 6 then
  begin
   inc(raiz^.chijos);
   raiz^.hijos[raiz^.chijos]:=hijo;
 end;
end;
Procedure Mostrar_arbol (var arbol:t_arbol);

var i:integer;
begin
 writeln(arbol^.simb) ;
 for i:=1 to arbol^.chijos do
   begin
      Mostrar_arbol(arbol^.hijos[i]);
   end;
end;

end.

