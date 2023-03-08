unit Unit_usa_arbol;

interface
Type
T_Dato = record
           Campo:string[50];
           Pos:integer;
         End;

T_Punt = ^T_Nodo;

T_Nodo = Record
           Info:T_Dato;
           SAI,SAD: T_Punt;
         END;

Procedure Agregar (var raiz:t_punt; x:t_dato);
Function Preorden(raiz:t_punt;buscado:string):t_punt;
Procedure Crear_arbol (var raiz:t_punt);
Function Arbol_vacio (raiz:t_punt): boolean;

Implementation

Procedure Agregar (var raiz:t_punt; x:t_dato);
Begin
 if raiz = nil then
 begin
   new (raiz);
   raiz^.info:= x;
   raiz^.sai:= nil;
   raiz^.sad:= nil;
 end
 else   if raiz^.info.campo > x.campo then agregar (raiz^.sai,x)
 else agregar (raiz^.sad,x)
 end;

Function Preorden(raiz:t_punt;buscado:string):t_punt;
Begin
    if (raiz =  nil) then  preorden := nil
     else
       if ( raiz^.info.campo  = buscado) then
          preorden:= raiz
             else if raiz^.info.campo > buscado then
                preorden := preorden(raiz^.sai,buscado)
                   else
                    preorden := preorden(raiz^.sad,buscado)
end;

Procedure Crear_arbol (var raiz:t_punt);
Begin
    raiz:= nil;
  end;

Function Arbol_vacio (raiz:t_punt): boolean;
Begin
  arbol_vacio:= raiz  = nil;
End;

end.
