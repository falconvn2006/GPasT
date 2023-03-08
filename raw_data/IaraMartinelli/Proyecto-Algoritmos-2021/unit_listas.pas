unit Unit_listas;

interface
uses
crt;

type
T_dato_tratamiento= RECORD
  		Codigo:string[10];
  		Descripcion:string[100];
  End;
T_lista_tratamiento= RECORD
                        Cab,act: byte;
                        elem: array [1..10] of t_dato_tratamiento;
		        tam: byte;
                       End;
T_dato_contador= RECORD
                    anio:string[4];
                    mes:array[1..12] of cardinal;
                    end;

T_lista_contador= RECORD
             Cab,act: byte;
             elem: array [1..10] of t_dato_contador;
             tam: byte;
end;

  Procedure Crear_lista (var L:T_lista_tratamiento);
  Function Tam(Var L:T_lista_tratamiento):byte;
  Procedure Desplazar_atras(Var L:T_lista_tratamiento; pos:byte);
  Procedure Agregar_lista(Var L:T_lista_tratamiento; x:T_Dato_tratamiento);
  Procedure Crear_lista_contador (var L:T_lista_contador);
  Function Tam_contador(Var L:T_lista_contador):byte;
  Procedure Desplazar_atras_contador(Var L:T_lista_contador; pos:byte);
  Procedure Agregar_lista_contador(Var L:T_lista_contador; x:T_Dato_contador);

implementation
Procedure Crear_lista (var L:T_lista_tratamiento);
  Begin
    L.cab:=0;
    L.tam:=0;
  end;

  Function Tam(Var L:T_lista_tratamiento):byte;
  Begin
    //L.tam:=N;
    tam:=L.tam;
  end;

  Procedure Desplazar_atras(Var L:T_lista_tratamiento; pos:byte);
  Var i:byte;
  Begin
    For i:=tam(L) downto pos do
    L.elem[i+1]:=L.elem[i];
  End;

  Procedure Agregar_lista(Var L:T_lista_tratamiento; x:T_Dato_tratamiento);
  Begin
    If (L.Cab=0) Then
      Begin
         Inc(L.Cab);
         L.ELEM[L.Cab]:=x;
      end
   Else
     If (L.elem[L.Cab].codigo > x.codigo) THEN
       Begin
         Desplazar_atras(L, 1);
         L.Cab:=1;
         L.Elem[L.Cab]:=x;
       End
     Else
     Begin
      L.act:= L.cab+1;
      While (L.act <= tam(L)) and (L.elem[L.act].codigo < x.codigo) do
         Begin
            inc(L.act);
         end;
      If L.act < tam(L) then
      Desplazar_atras(L,L.act);
      L.elem[L.act]:=x;
     end;
    Inc(L.tam);
  End;

  Procedure Crear_lista_contador (var L:T_lista_contador);
  Begin
    L.cab:=0;
    L.tam:=0;
  end;

  Function Tam_contador(Var L:T_lista_contador):byte;
  Begin
    tam_contador:=L.tam;
  end;

  Procedure Desplazar_atras_contador(Var L:T_lista_contador; pos:byte);
  Var i:byte;
  Begin
    For i:=tam_contador(L) downto pos do
    L.elem[i+1]:=L.elem[i];
  End;

  Procedure Agregar_lista_contador(Var L:T_lista_contador; x:T_Dato_contador);
  Begin
    If (L.Cab=0) Then
      Begin
         Inc(L.Cab);
         L.ELEM[L.Cab]:=x;
      end
   Else
     If (L.elem[L.Cab].anio > x.anio) THEN
       Begin
         Desplazar_atras_contador(L, 1);
         L.Cab:=1;
         L.Elem[L.Cab]:=x;
       End
     Else
     Begin
      L.act:= L.cab+1;
      While (L.act <= tam_contador(L)) and (L.elem[L.act].anio < x.anio) do
         Begin
            inc(L.act);
         end;
      If L.act < tam_contador(L) then
      Desplazar_atras_contador(L,L.act);
      L.elem[L.act]:=x;
     end;
    Inc(L.tam);
  End;

end.

