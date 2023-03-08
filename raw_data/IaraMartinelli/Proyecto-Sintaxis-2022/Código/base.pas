unit Base;

interface

type
  tsimbgram=(tid,tconstreal,tparentesisabre,tdefine,tparentesiscierra,tpunto,tcomienzo,tbarra,tasig,tfinal,
  tmientras,tentonces,tsi,tsino,tand,tor,tnot,timprimir,tingresar,tmas,tmenos,tpor,tdividir,tcadena,
  toprel,thacer,tcoma,tcorchetea,tcorchetec,traiz,tdospuntos,tpotencia,error,pesos,vprograma,vdefinir,vvariables,vv
  ,vcuerpo,vsecsent,vt,vsentencia,vasignacion,vexparit1,vh,vexparit2,vj,vexparit3,vexparit4,vl,vciclo,vcondicional,vq,va,vcond,vk,
  vexplog2,vexplog3,vm,vexprel,vlectura,vescritura,vr,vw,vcad);

  tterminales=tid..tpotencia;
  tvariables=vprograma..vcad;

  //tabla de simbolos
  T_DATO=RECORD
           COMPLEX:tsimbgram;
           LEXEMA:STRING;
  end;
  t_punt=^t_nodo;
   T_Nodo=Record
      Info:T_Dato;
      Sig:T_Punt;
    end;
    T_ts=Record
      tam:integer;
      Act,Cab:T_punt;
    end;

  //arbol de derivacion
  t_arbol = ^t_nodo_arbol;

  t_nodo_arbol=record
       lexema:string;
       simb:tsimbgram;
       hijos:array [1..6] of t_arbol;
       Chijos:0..6;
       end;
  //pila
  t_dato_pila=record
       simb:tsimbgram;
       nodo:t_arbol;
       end;
  t_punt_pila=^t_nodo_pila;
    t_nodo_pila=record
      info:t_dato_pila;
      sig:t_punt_pila;
      end;
    t_pila=record
      tope:t_punt_pila;
      tam:word;
      end;
  //archivo fuente
  t_arch= file of char;

  //TAS
  t_produccion=record
        elem:array [1..6] of tsimbgram;  //producciones
        cant:byte;
       end;
 t_matriz=array [vprograma..vcad,tid..tpotencia] of ^t_produccion;

Procedure abrir(Var arch:t_arch; ruta:string);

implementation
Procedure abrir(Var arch:t_arch; ruta:string);
 Begin
 assign(arch,ruta);
 {$I-}
 Reset(arch);
 {$I+}
 If IoResult<>0 then
 rewrite(arch);
 End;

end.


