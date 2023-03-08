unit u_evaluador;

interface
uses
  crt,math,sysutils,base;
const
  maxvariables=100;
type
  t_var=record
    variable:string;
    valor:real;
  end;

  t_estado=record
    elem: array [1..maxvariables] of t_var;
    cant: word;
  end;

 Procedure inicializar_estado(var estado:t_estado);
 Procedure EstadoAgregarVariable(var e:t_estado;var lexemaid:string);
 Function estadobuscarvariable (var estado:t_estado; var lexema:string):word;
 Procedure EstadoAsignarValor(var Estado:t_estado;lexema:string; valor:real);
 Procedure estadodevolvervalor (var Estado:t_estado;lexema:string; var valor:real; var mensajeerror:string);
 Procedure evaluador(var arbol:t_arbol);


 Procedure evaluaprograma(var Arbol:t_arbol; var Estado:t_estado);
 Procedure evaluasentencia(var Arbol:t_arbol; var Estado:t_estado);
 Procedure evaluasecsent(var Arbol:t_arbol; var Estado:t_estado);
 Procedure evaluacuerpo(var Arbol:t_arbol; var Estado:t_estado);
 Procedure evaluaexparit4(var Arbol:t_arbol;var Estado:t_estado;var Resultado:real);
 Procedure evalual(var Arbol:t_arbol;var Estado:t_estado;var primeroperando:real;var Resultado:real);
 Procedure evaluaexparit3(var Arbol:t_arbol;var Estado:t_estado;var Resultado:real);
 Procedure evaluaj(var Arbol:t_arbol;var Estado:t_estado; var primeroperando:real;var Resultado:real);
 Procedure evaluaexparit2(var Arbol:t_arbol;var Estado:t_estado;var Resultado:real);
 Procedure evaluah(var Arbol:t_arbol; var Estado:t_estado;primeroperando:real;var Resultado:real);
 Procedure evaluaexparit1 (var Arbol:t_arbol; var Estado:t_estado; var resultado:real);
 Procedure evaluaasignacion(var Arbol:t_arbol; var Estado:t_estado);
 Procedure evaluaexprel(var Arbol:t_arbol;var estado:t_estado;var resultado:boolean);
 Procedure evaluaexplog3(var Arbol:t_arbol;var Estado:t_estado;var resultado:boolean);
 Procedure evaluam(var Arbol:t_arbol;var Estado:t_estado;var resultado1:boolean;var resultado:boolean);
 Procedure evaluaexplog2(var Arbol:t_arbol;var estado:t_estado;var resultado:boolean);
 Procedure evaluak(var Arbol:t_arbol;var Estado:t_estado;var resultado1:boolean;var resultado:boolean);
 Procedure evaluacond(var Arbol:t_arbol;var estado:t_estado; var resultado:boolean);
 Procedure evaluaa(var Arbol:t_arbol; var estado:t_estado);
 Procedure evaluaq(var Arbol:t_arbol;var estado:t_estado);
 Procedure evaluacondicional(var Arbol:t_arbol;var estado:t_estado);
 Procedure evaluaciclo(var Arbol:t_arbol;var estado:t_estado);
 Procedure evaluacad(var Arbol:t_arbol;var estado:t_estado);
 Procedure evaluaW(var Arbol:t_arbol; var estado:t_estado;var resultado:real);
 Procedure evaluaR(var Arbol:t_arbol;var estado:t_estado;var resultado:real);
 Procedure evaluaEscritura(var Arbol:t_arbol;var estado:t_estado);
 Procedure evalualectura(var arbol:t_arbol;var estado:t_estado);
 Procedure evaluaV(var Arbol:t_arbol;var Estado:t_estado);
 Procedure evaluaVariables(var Arbol:t_arbol;var Estado:t_estado);
 Procedure evaluaDefinir(var arbol:t_arbol;var Estado:t_estado);

implementation
Procedure inicializar_estado(var estado:t_estado);
begin
  estado.cant:=0;
end;
Procedure EstadoAgregarVariable(var e:t_estado; var lexemaid:string);
Begin
  E.cant:= e.cant+1;
  E.elem[e.cant].variable:=lexemaid;
  E.elem[e.cant].valor:=0;
End;
function estadobuscarvariable (var estado:t_estado; var lexema:string):word;
var i:word;
begin
  i:=1;
  while (i<=estado.cant) and (upcase(estado.elem[i].variable)<>upcase(lexema)) do
   i:=i+1;
  if i<=estado.cant then estadobuscarvariable:=i
  else estadobuscarvariable:=0;
end;

Procedure EstadoAsignarValor(var Estado:t_estado;lexema:string; valor:real);
var p:word;
begin
  p:=estadobuscarvariable(estado,lexema);
  if p>0 then estado.elem[p].valor:=valor
  else
    WriteLn ('Variable '+lexema+' no declarada');
end;

Procedure estadodevolvervalor (var Estado:t_estado;lexema:string; var valor:real; var mensajeerror:string);
var p:word;
begin
   mensajeerror:='';
  p:=estadobuscarvariable(estado,lexema);
  if p>0 then valor:=estado.elem[p].valor
  else mensajeerror:='variable '+lexema+' no declarada';
end;
Procedure evaluador(var arbol:t_arbol);
 var estado:t_estado;
begin
  inicializar_estado(estado);
  evaluaprograma(arbol,estado);
end;
//V → ,idV | e
Procedure evaluaV(var Arbol:t_arbol;var Estado:t_estado);
Begin
	If arbol^.chijos>0 then
        begin
	Estadoagregarvariable(Estado,Arbol^.Hijos[2]^.lexema);
	Evaluav(Arbol^.hijos[3],Estado);
        end;
End;
//Variables → idV
Procedure evaluaVariables(var Arbol:t_arbol;var Estado:t_estado);
Begin
	EstadoAgregarVariable(Estado,Arbol^.hijos[1]^.lexema);
	Evaluav(Arbol^.hijos[2],estado);
End;
//Definir → Define : Variables
Procedure evaluaDefinir(var arbol:t_arbol;var Estado:t_estado);
Begin
Evaluavariables(Arbol^.hijos[3],Estado);
End;
//Sentencia → Asignación | Ciclo | Condicional | Lectura | Escritura | Definir
Procedure evaluasentencia(var Arbol:t_arbol; var Estado:t_estado);
Begin
  Case arbol^.hijos[1]^.simb of
	Vasignacion:evaluaasignacion(Arbol^.hijos[1],Estado);
	Vciclo:evaluaciclo(Arbol^.hijos[1],Estado);
	Vcondicional:evaluacondicional(Arbol^.hijos[1],Estado);
	Vlectura:evalualectura(Arbol^.hijos[1],Estado);
	Vescritura:evaluaescritura(Arbol^.hijos[1],Estado);
	Vdefinir:evaluadefinir(Arbol^.hijos[1],Estado);
  End;
End;
//SecSent → Sentencia. SecSent | ɛ
Procedure evaluasecsent(var Arbol:t_arbol; var Estado:t_estado);
Begin
	If Arbol^.chijos>0 then
                Begin
		Evaluasentencia(Arbol^.Hijos[1],Estado);
		Evaluasecsent(Arbol^.hijos[3],Estado);
                End;
End;
//Cuerpo → Comienzo SecSent Final
Procedure evaluacuerpo(var Arbol:t_arbol; var Estado:t_estado);
Begin
	Evaluasecsent(Arbol^.Hijos[2],Estado);
End;
//Programa → ‘|’ id ‘|’ Cuerpo.
Procedure evaluaprograma(var Arbol:t_arbol; var Estado:t_estado);
Begin
        Evaluacuerpo(Arbol^.hijos[4],Estado);
End;

//ExpArit4→ -ExpArit4 | raiz(ExpArit1) | ConstReal | id | (ExpArit1)
Procedure evaluaexparit4(var Arbol:t_arbol;var Estado:t_estado; var Resultado:real);
Var primeroperando,aux:real;  mensaje:string;
Begin
  Case arbol^.hijos[1]^.simb of
  Tmenos:begin
           Evaluaexparit4(Arbol^.hijos[2],Estado,primeroperando);
	resultado:=(-1)*primeroperando;
        End;
  Traiz:begin
             Evaluaexparit1(Arbol^.hijos[3],Estado,primeroperando);
             resultado:= sqrt(primeroperando);
           End;
  Tconstreal:    resultado:= strtofloat(Arbol^.hijos[1]^.Lexema);

  Tid:Estadodevolvervalor(Estado,Arbol^.hijos[1]^.lexema,Resultado,mensaje);

  Tparentesisabre:evaluaexparit1(Arbol^.hijos[2],Estado,Resultado)
End;
  End;

//L → ^ExpArit4L | e
Procedure evalual(var Arbol:t_arbol;var Estado:t_estado;var primeroperando:real;var Resultado:real);
Var
  Segundooperando,calc:real;
Begin
     If arbol^.Chijos>0 then
        Begin
        Evaluaexparit4(Arbol^.hijos[2],Estado,segundooperando);
        Calc:= power(primeroperando,segundooperando);
        Evalual(Arbol^.hijos[3],estado,Calc,resultado);
        end
     Else
	Resultado:= primeroperando;
End;

//ExpArit3 → ExpArit4L
Procedure evaluaexparit3(var Arbol:t_arbol;var Estado:t_estado;var Resultado:real);
var resultado1:real;
Begin
          Evaluaexparit4(Arbol^.hijos[1],Estado,Resultado1);
          Evalual(Arbol^.hijos[2],Estado,Resultado1,Resultado);
End;

//J → * ExpArit3J | / ExpArit3J | e
Procedure evaluaj(var Arbol:t_arbol;var Estado:t_estado; var primeroperando:real;var Resultado:real);
Var
  Segundooperando:real;
  Calc:real;
Begin
  If arbol^.chijos=0 then
     	Resultado:=primeroperando
        Else
          Begin
          Case arbol^.Hijos[1]^.simb of
          Tpor:begin
                Evaluaexparit3(Arbol^.hijos[2],Estado,segundooperando);
		Calc:= primeroperando * segundooperando;
		Evaluaj(Arbol^.hijos[3],Estado,Calc,Resultado);
               End;
          Tdividir:begin
                Evaluaexparit3(Arbol^.hijos[2],Estado,segundooperando);
		Calc:= primeroperando / segundooperando;
		Evaluaj(Arbol^.hijos[3],Estado,Calc,Resultado);
                End;
                End;
                End;
End;

//ExpArit2 → ExpArit3 J
Procedure evaluaexparit2(var Arbol:t_arbol;var Estado:t_estado;var Resultado:real);
Var primeroperando:real;
Begin
          Evaluaexparit3(Arbol^.hijos[1],Estado,primeroperando);
          Evaluaj(Arbol^.hijos[2],Estado,primeroperando,Resultado);
End;

//H → + ExpArit2 H | - ExpArit2 H | e
Procedure evaluah(var Arbol:t_arbol; var Estado:t_estado;primeroperando:real;var Resultado:real);
Var
  Segundooperando:real;
  Calc:real;
Begin
  If arbol^.chijos=0 then      //osea que H->epsilon
  Resultado:=primeroperando
                      Else
                        Begin
                        Case arbol^.hijos[1]^.simb of
                        Tmas:begin
                             Evaluaexparit2(Arbol^.hijos[2],Estado,segundooperando);
                             Calc:= primeroperando + segundooperando;
	                     Evaluah(Arbol^.hijos[3],Estado,Calc,Resultado);
                        End;
                        Tmenos:begin
                             Evaluaexparit2(Arbol^.hijos[2],estado,segundooperando);
	                     Calc:= primeroperando - segundooperando;
	                     Evaluah(Arbol^.hijos[3],Estado,Calc,Resultado);
                        End;
                        End;
                        End;
End;

//ExpArit1 → ExpArit2 H
Procedure evaluaexparit1 (var Arbol:t_arbol; var Estado:t_estado; var resultado:real);
Var Resultado1:real;
Begin
	Evaluaexparit2(Arbol^.hijos[1],Estado,Resultado1);
	Evaluah(Arbol^.hijos[2],Estado,Resultado1,Resultado);
End;

//Asignación → id << ExpArit1
Procedure evaluaasignacion(var Arbol:t_arbol; var Estado:t_estado);
var resultado:real;
Begin
	Evaluaexparit1(Arbol^.hijos[3],Estado, resultado);
	EstadoAsignarValor(Estado,Arbol^.hijos[1]^.Lexema,Resultado);
End;

//ExpRel → ExpArit1 opRel ExpArit1 | [Cond]
Procedure evaluaexprel(var Arbol:t_arbol;var estado:t_estado;var resultado:boolean);
Var primeroperando,segundooperando:real;
Begin

        	If arbol^.hijos[1]^.simb= vexparit1 then
                Begin
        	Evaluaexparit1(Arbol^.hijos[1],estado,primeroperando);
                Evaluaexparit1(Arbol^.hijos[3],estado,segundooperando);
Case arbol^.Hijos[2]^.lexema of
     '<':resultado:=primeroperando<segundooperando;
     '>':resultado:=primeroperando>segundooperando;
     '=':resultado:=primeroperando=segundooperando;
     '<=':resultado:=primeroperando<=segundooperando;
     '>=':resultado:=primeroperando>=segundooperando;
     '<>':resultado:=primeroperando<>segundooperando;
     End
End
        Else
        Evaluacond(Arbol^.hijos[2],estado,resultado);
End;

//ExpLog3 → not ExpLog3 | ExpRel
Procedure evaluaexplog3(var Arbol:t_arbol;var Estado:t_estado; var resultado:boolean);
Begin
        	If arbol^.hijos[1]^.simb=tnot then
        		Evaluaexplog3(Arbol^.hijos[2],estado,resultado)
        	Else
        		Evaluaexprel(Arbol^.hijos[1],estado,resultado);
End;

//M→or ExpLog3M  | e
Procedure evaluam(var Arbol:t_arbol;var Estado:t_estado;var resultado1:boolean;var resultado:boolean);
Var resultado2:boolean; aux:boolean;
Begin
  If arbol^.chijos>0 then
  Begin
     Evaluaexplog3(Arbol^.hijos[2],estado,resultado2);
     Aux:=resultado1 or resultado2;
     Evaluam(Arbol^.hijos[3],estado,aux,resultado);
     End
Else
        Resultado:=resultado1;
End;

//ExpLog2→ExpLog3M
Procedure evaluaexplog2(var Arbol:t_arbol;var estado:t_estado;var resultado:boolean);
Var resultado1:boolean;
Begin
        	Evaluaexplog3(Arbol^.hijos[1],estado,resultado1);
        	Evaluam(Arbol^.hijos[2],estado,resultado1,resultado);
End;

//K→and ExpLog2K | e
Procedure evaluak(var Arbol:t_arbol;var Estado:t_estado;var resultado1:boolean;var resultado:boolean);
Var
  Resultado2:boolean;
  Aux:boolean;
Begin
  If arbol^.chijos>0 then
  Begin
        Evaluaexplog2(Arbol^.hijos[2],estado,resultado2);
        Aux:=resultado1 and resultado2;
        Evaluak(Arbol^.hijos[3],estado,aux,resultado);
  End
  Else
        Resultado:=resultado1;
End;

//Cond→ExpLog2K
Procedure evaluacond(var Arbol:t_arbol;var estado:t_estado; var resultado:boolean);
Var
  primeroperando:boolean;
Begin
	Evaluaexplog2(Arbol^.hijos[1],estado,primeroperando);
	Evaluak(Arbol^.hijos[2],estado,primeroperando,resultado);
End;

//A->Sino ‘|’SecSent ‘|’ | e
Procedure evaluaa(var Arbol:t_arbol; var estado:t_estado);
Begin
	If arbol^.chijos>0 then
	Evaluasecsent(Arbol^.hijos[3],estado);
End;

//Q → Cond entonces ‘|’ SecSent ‘|’ A
Procedure evaluaq(var Arbol:t_arbol;var estado:t_estado);
var resultado:boolean;
Begin
	Evaluacond(Arbol^.hijos[1],estado,resultado);
		If resultado then
		Evaluasecsent(Arbol^.hijos[4],estado) //si el if es verdadero, evalua secsent, sino hace el "sino" que es A
                Else
		Evaluaa(Arbol^.hijos[6],estado);//es el sino
End;

//Condicional → Si Q
Procedure evaluacondicional(var Arbol:t_arbol;var estado:t_estado);
Begin
	Evaluaq(Arbol^.hijos[2],estado);
End;

//Ciclo → Mientras Cond hacer ‘|’ SecSent ‘|’
Procedure evaluaciclo(var Arbol:t_arbol;var estado:t_estado);
Var resultado:boolean;
Begin
	Evaluacond(Arbol^.hijos[2],estado,resultado);
		While resultado do
                Begin
	Evaluasecsent(Arbol^.hijos[5],estado);
	Evaluacond(Arbol^.hijos[2],estado,resultado)
        End;
End;

//CAD → , cadena CAD | ɛ
Procedure evaluacad(var Arbol:t_arbol;var estado:t_estado);
Begin
        	If arbol^.Chijos>0 then
                begin
                 writeln(arbol^.hijos[2]^.lexema);
        	Evaluacad(Arbol^.hijos[3],estado);
                end;
End;

//W->ExpArit1)| cadenaCAD)
Procedure evaluaW(var Arbol:t_arbol; var estado:t_estado;var resultado:real);
Begin
        If arbol^.hijos[1]^.simb  = vexparit1 then
        begin
        Evaluaexparit1(Arbol^.hijos[1],estado,resultado);
        writeln(resultadO:9:2);
        end
        Else
        begin
                writeln(arbol^.hijos[1]^.lexema);
        	Evaluacad(Arbol^.hijos[2],estado);
        end;
End;

//R→(W
Procedure evaluaR(var Arbol:t_arbol;var estado:t_estado;var resultado:real);
Begin
        	Evaluaw(Arbol^.hijos[2],estado,resultado)
End;

//Escritura → ImprimirR
Procedure evaluaEscritura(var Arbol:t_arbol;var estado:t_estado);
Var resultado:real;
  Begin
        	EvaluaR(Arbol^.hijos[2],estado,resultado);
  End;

//Lectura → cadena, Ingresar(id)
Procedure evalualectura(var arbol:t_arbol;var estado:t_estado);
Var
  aux:real;
Begin
        Write(Arbol^.hijos[1]^.lexema);
        Readln(aux);
        Estadoasignarvalor(estado,Arbol^.hijos[5]^.lexema,aux);
End;



end.
