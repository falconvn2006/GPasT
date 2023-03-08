unit Lista;

{$modc objfpc}{$H+}

interface
uses base;
procedure cargar(var L:T_ts; c:T_Dato);
procedure eliminar(var L:T_ts; buscado:string; var c:T_dato);
procedure Iniciar_lista(var L:T_ts);
procedure recuperar(L:T_ts; var c:T_dato);
function lista_llena(L:T_ts):boolean;
function lista_vacia(L:T_ts):boolean;
procedure Primero(var L:T_ts);
function Fin(L:T_ts):boolean;
procedure Siguiente(var L:T_ts);

implementation
procedure cargar(var L:T_ts; c:T_Dato);
 var
   Dir,ant:T_punt;
  begin
    new(Dir);
    Dir^.Info:=c;
     If (L.Cab=NIL) then
       begin
         Dir^.Sig:=L.cab;
         L.Cab:=Dir;
       end
     else
      begin
        Ant:=L.Cab;
        L.Act:=L.Cab^.Sig;
         while (L.Act<>NIL) do
          begin
            Ant:=L.Act;
            L.Act:=L.Act^.Sig;
          end;
         Ant^.Sig:=Dir;
         Dir^.Sig:=L.Act;
      end;
      inc(L.tam);
  end;
procedure eliminar(var L:T_ts; buscado:string; var c:T_dato);
 var
   ant:T_punt;
  begin
    if L.Cab^.Info.Lexema=buscado then
      begin
        c:=L.Cab^.Info;
        L.Act:=L.Cab;
        L.Cab:=L.Cab^.Sig;
        dispose(L.Act);
      end
    else
     begin
        Ant:=L.Cab;
        L.Act:=L.Cab^.Sig;
         while (L.Act<>NIL) and (L.Act^.Info.Lexema<>buscado) do
          begin
             Ant:=L.Act;
             L.Act:=L.Act^.Sig;
          end;
         c:=L.Act^.Info;
         Ant^.Sig:=L.Act^.Sig;
         dispose(L.Act);
     end;
     dec(L.tam);
  end;
procedure Iniciar_lista(var L:T_ts);
 begin
   L.tam:=0;
   L.cab:=nil;
 end;

procedure recuperar(L:T_ts; var c:T_dato);
  begin
    c:=L.Act^.Info;
  end;

function lista_llena(L:T_ts):boolean;
  begin
   lista_llena:=getheapstatus.totalfree<SizeOf(T_Nodo)
  end;

function lista_vacia(L:T_ts):boolean;
  begin
   lista_vacia:=(L.tam=0);
  end;

procedure Primero(var L:T_ts);
  begin
   L.Act:=L.Cab;
  end;

function Fin(L:T_ts):boolean;
  begin
   Fin:=L.Act=NIL;
  end;

procedure Siguiente(var L:T_ts);
  begin
   L.Act:=L.Act^.Sig;
  end;

end.


