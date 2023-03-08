unit Lista;

{$modc objfpc}{$H+}

interface
uses base;
procedure cargar(var L:T_ts; c:T_Dato);
procedure Iniciar_lista(var L:T_ts);
procedure recuperar(L:T_ts; var c:T_dato);
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
procedure Iniciar_lista(var L:T_ts);
 begin
   L.tam:=0;
   L.cab:=nil;
 end;
procedure recuperar(L:T_ts; var c:T_dato);
  begin
    c:=L.Act^.Info;
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


