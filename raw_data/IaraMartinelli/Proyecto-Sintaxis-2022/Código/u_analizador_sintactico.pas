unit u_Analizador_sintactico;

interface

uses base,analizador_lexico,arbol,pila,crt,classes,sysutils;
type
  est=(enproceso,exito,errorsintactico);
procedure inicializar_TAS(var TAS:t_matriz);
procedure cargar_TAS (var tas:t_matriz);
procedure apilar_cargararbol (var pila:t_pila; tas:t_matriz; x,a:tsimbgram; padre:t_arbol);
procedure analizador_sintactico(var arch:t_arch; var arbol:t_arbol; var estado:est);
procedure cargar_archivo( var archarbol:text; var raiz:t_arbol; desplazamiento:word);

implementation
procedure inicializar_TAS(var TAS:t_matriz);
var i,j:tsimbgram;
begin
   for i:=vprograma to vcad do
     for j:=tid to tpotencia do
     tas[i,j]:=nil;
   end;
procedure cargar_TAS (var tas:t_matriz);
begin
 New(TAS[vPrograma,tBarra]);
TAS[vPrograma,tBarra]^.elem[1]:=tBarra;
TAS[vPrograma,tBarra]^.elem[2]:=tid;
TAS[vPrograma,tBarra]^.elem[3]:=tBarra;
TAS[vPrograma,tBarra]^.elem[4]:=vCuerpo;
TAS[vPrograma,tBarra]^.elem[5]:=tPunto;
TAS[vPrograma,tBarra]^.cant:=5;

New(TAS[vDefinir,tDefine]);
TAS[vDefinir,tDefine]^.elem[1]:=tDefine;
TAS[vDefinir,tDefine]^.elem[2]:=tDosPuntos;
TAS[vDefinir,tDefine]^.elem[3]:=vVariables;
TAS[vDefinir,tDefine]^.cant:=3;

New(TAS[vVariables,tid]);
TAS[vVariables,tid]^.elem[1]:=tid;
TAS[vVariables,tid]^.elem[2]:=vV;
TAS[vVariables,tid]^.cant:=2;

New(TAS[vV,tComa]);
TAS[vV,tComa]^.elem[1]:=tComa;
TAS[vV,tComa]^.elem[2]:=tid;
TAS[vV,tComa]^.elem[3]:=vV;
TAS[vV,tComa]^.cant:=3;

New(TAS[vV,tPunto]);
TAS[vV,tPunto]^.cant:=0;

New(TAS[vCuerpo,tComienzo]);
TAS[vCuerpo,tComienzo]^.elem[1]:=tComienzo;
TAS[vCuerpo,tComienzo]^.elem[2]:=vSecSent;
TAS[vCuerpo,tComienzo]^.elem[3]:=tFinal;
TAS[vCuerpo,tComienzo]^.cant:=3;

New(TAS[vSecSent,tid]);
TAS[vSecSent,tid]^.elem[1]:=vSentencia;
TAS[vSecSent,tid]^.elem[2]:=tPunto;
TAS[vSecSent,tid]^.elem[3]:=vSecSent;
TAS[vSecSent,tid]^.cant:=3;

New(TAS[vSecSent,tmientras]);
TAS[vSecSent,tmientras]^.elem[1]:=vSentencia;
TAS[vSecSent,tmientras]^.elem[2]:=tPunto;
TAS[vSecSent,tmientras]^.elem[3]:=vSecSent;
TAS[vSecSent,tmientras]^.cant:=3;

New(TAS[vSecSent,tSi]);
TAS[vSecSent,tSi]^.elem[1]:=vSentencia;
TAS[vSecSent,tSi]^.elem[2]:=tPunto;
TAS[vSecSent,tSi]^.elem[3]:=vSecSent;
TAS[vSecSent,tSi]^.cant:=3;

New(TAS[vSecSent,tcadena]);
TAS[vSecSent,tcadena]^.elem[1]:=vSentencia;
TAS[vSecSent,tcadena]^.elem[2]:=tPunto;
TAS[vSecSent,tcadena]^.elem[3]:=vSecSent;
TAS[vSecSent,tcadena]^.cant:=3;

New(TAS[vSecSent,timprimir]);
TAS[vSecSent,timprimir]^.elem[1]:=vSentencia;
TAS[vSecSent,timprimir]^.elem[2]:=tPunto;
TAS[vSecSent,timprimir]^.elem[3]:=vSecSent;
TAS[vSecSent,timprimir]^.cant:=3;

New(TAS[vSecSent,tDefine]);
TAS[vSecSent,tDefine]^.elem[1]:=vSentencia;
TAS[vSecSent,tDefine]^.elem[2]:=tPunto;
TAS[vSecSent,tDefine]^.elem[3]:=vSecSent;
TAS[vSecSent,tDefine]^.cant:=3;

New(TAS[vsecsent,tFinal]);
TAS[vsecsent,tFinal]^.cant:=0;

New(TAS[vsecsent,tBarra]);
TAS[vsecsent,tBarra]^.cant:=0;

New(TAS[vSentencia,tid]);
TAS[vSentencia,tid]^.elem[1]:=vasignacion;
TAS[vSentencia,tid]^.cant:=1;

New(TAS[vSentencia,tmientras]);
TAS[vSentencia,tmientras]^.elem[1]:=vciclo;
TAS[vSentencia,tmientras]^.cant:=1;

New(TAS[vSentencia,tSi]);
TAS[vSentencia,tSi]^.elem[1]:=vCondicional;
TAS[vSentencia,tSi]^.cant:=1;

New(TAS[vSentencia,tcadena]);
TAS[vSentencia,tcadena]^.elem[1]:=vLectura;
TAS[vSentencia,tcadena]^.cant:=1;

New(TAS[vSentencia,timprimir]);
TAS[vSentencia,timprimir]^.elem[1]:=vescritura;
TAS[vSentencia,timprimir]^.cant:=1;

New(TAS[vSentencia,tDefine]);
TAS[vSentencia,tDefine]^.elem[1]:=vDefinir;
TAS[vSentencia,tDefine]^.cant:=1;

New(TAS[vasignacion,tid]);
TAS[vasignacion,tid]^.elem[1]:=tid;
TAS[vasignacion,tid]^.elem[2]:=TASig;
TAS[vasignacion,tid]^.elem[3]:=vExpArit1;
TAS[vasignacion,tid]^.cant:=3;

New(TAS[vexparit1,tMenos]);
TAS[vexparit1,tMenos]^.elem[1]:=vExpArit2;
TAS[vexparit1,tMenos]^.elem[2]:=vh;
TAS[vexparit1,tMenos]^.cant:=2;

New(TAS[vexparit1,tRaiz]);
TAS[vexparit1,tRaiz]^.elem[1]:=vExpArit2;
TAS[vexparit1,tRaiz]^.elem[2]:=vh;
TAS[vexparit1,tRaiz]^.cant:=2;

New(TAS[vexparit1,tConstReal]);
TAS[vexparit1,tConstReal]^.elem[1]:=vExpArit2;
TAS[vexparit1,tConstReal]^.elem[2]:=vh;
TAS[vexparit1,tConstReal]^.cant:=2;

New(TAS[vexparit1,tid]);
TAS[vexparit1,tid]^.elem[1]:=vExpArit2;
TAS[vexparit1,tid]^.elem[2]:=vh;
TAS[vexparit1,tid]^.cant:=2;

New(TAS[vexparit1,tParentesisAbre]);
TAS[vexparit1,tParentesisAbre]^.elem[1]:=vExpArit2;
TAS[vexparit1,tParentesisAbre]^.elem[2]:=vh;
TAS[vexparit1,tParentesisAbre]^.cant:=2;

New(TAS[vh,tMas]);
TAS[vh,tMas]^.elem[1]:=tMas;//
TAS[vh,tMas]^.elem[2]:=vExpArit2;
TAS[vh,tMas]^.elem[3]:=vh;
TAS[vh,tMas]^.cant:=3;

New(TAS[vh,tMenos]);
TAS[vh,tMenos]^.elem[1]:=tMenos;//
TAS[vh,tMenos]^.elem[2]:=vExpArit2;
TAS[vh,tMenos]^.elem[3]:=vh;
TAS[vh,tMenos]^.cant:=3;

New(TAS[vh,tOr]);
TAS[vh,tOr]^.cant:=0;

New(TAS[vh,tOpRel]);
TAS[vh,tOpRel]^.cant:=0;

New(TAS[vh,tAnd]);
TAS[vh,tAnd]^.cant:=0;

New(TAS[vh,tEntonces]);
TAS[vh,tEntonces]^.cant:=0;

New(TAS[vh,tcorchetec]);
TAS[vh,tcorchetec]^.cant:=0;

New(TAS[vh,thacer]);
TAS[vh,thacer]^.cant:=0;

New(TAS[vh,tPunto]);
TAS[vh,tPunto]^.cant:=0;

New(TAS[vh,tParentesisCierra]);
TAS[vh,tParentesisCierra]^.cant:=0;

New(TAS[vExpArit2,tMenos]);
TAS[vExpArit2,tMenos]^.elem[1]:=vExpArit3;
TAS[vExpArit2,tMenos]^.elem[2]:=vJ;
TAS[vExpArit2,tMenos]^.cant:=2;

New(TAS[vExpArit2,tRaiz]);
TAS[vExpArit2,tRaiz]^.elem[1]:=vExpArit3;
TAS[vExpArit2,tRaiz]^.elem[2]:=vJ;
TAS[vExpArit2,tRaiz]^.cant:=2;

New(TAS[vExpArit2,tConstReal]);
TAS[vExpArit2,tConstReal]^.elem[1]:=vExpArit3;
TAS[vExpArit2,tConstReal]^.elem[2]:=vJ;
TAS[vExpArit2,tConstReal]^.cant:=2;

New(TAS[vExpArit2,tid]);
TAS[vExpArit2,tid]^.elem[1]:=vExpArit3;
TAS[vExpArit2,tid]^.elem[2]:=vJ;
TAS[vExpArit2,tid]^.cant:=2;

New(TAS[vExpArit2,tParentesisAbre]);
TAS[vExpArit2,tParentesisAbre]^.elem[1]:=vExpArit3;
TAS[vExpArit2,tParentesisAbre]^.elem[2]:=vJ;
TAS[vExpArit2,tParentesisAbre]^.cant:=2;

New(TAS[vJ,tPor]);
TAS[vJ,tPor]^.elem[1]:=tPor;
TAS[vJ,tPor]^.elem[2]:=vExpArit3;
TAS[vJ,tPor]^.elem[3]:=vJ;
TAS[vJ,tPor]^.cant:=3;

New(TAS[vJ,tDividir]);
TAS[vJ,tDividir]^.elem[1]:=tDividir;
TAS[vJ,tDividir]^.elem[2]:=vExpArit3;
TAS[vJ,tDividir]^.elem[3]:=vJ;
TAS[vJ,tDividir]^.cant:=3;

New(TAS[vJ,tMas]);
TAS[vJ,tMas]^.cant:=0;

New(TAS[vJ,tMenos]);
TAS[vJ,tMenos]^.cant:=0;

New(TAS[vJ,tPunto]);
TAS[vJ,tPunto]^.cant:=0;

New(TAS[vJ,tParentesisCierra]);
TAS[vJ,tParentesisCierra]^.cant:=0;

New(TAS[vJ,tOpRel]);
TAS[vJ,tOpRel]^.cant:=0;

New(TAS[vJ,tOr]);
TAS[vJ,tOr]^.cant:=0;

New(TAS[vJ,tAnd]);
TAS[vJ,tAnd]^.cant:=0;

New(TAS[vJ,thacer]);
TAS[vJ,thacer]^.cant:=0;

New(TAS[vJ,tEntonces]);
TAS[vJ,tEntonces]^.cant:=0;

New(TAS[vJ,tcorchetec]);
TAS[vJ,tcorchetec]^.cant:=0;

New(TAS[vExpArit3,tmenos]);
TAS[vExpArit3,tmenos]^.elem[1]:=vExpArit4;
TAS[vExpArit3,tmenos]^.elem[2]:=vL;
Tas[vExpArit3,tmenos]^.cant:=2;

New(TAS[vExpArit3,tConstReal]);
TAS[vExpArit3, tConstReal]^.elem[1]:=vExpArit4;
TAS[vExpArit3, tConstReal]^.elem[2]:=vL;
Tas[vExpArit3, tConstReal]^.cant:=2;

New(TAS[vExpArit3,tid]);
TAS[vExpArit3, tid]^.elem[1]:=vExpArit4;
TAS[vExpArit3, tid]^.elem[2]:=vL;
Tas[vExpArit3, tid]^.cant:=2;

New(TAS[vExpArit3,tparentesisabre]);
TAS[vExpArit3, tparentesisabre]^.elem[1]:=vExpArit4;
TAS[vExpArit3, tparentesisabre]^.elem[2]:=vL;
Tas[vExpArit3, tparentesisabre]^.cant:=2;

New(TAS[vExpArit4,tMenos]);
TAS[vExpArit4,tMenos]^.elem[1]:=tMenos;
TAS[vExpArit4,tMenos]^.elem[2]:=vExpArit4;
TAS[vExpArit4,tMenos]^.cant:=2;

New(TAS[vExpArit4,tRaiz]);
TAS[vExpArit4,tRaiz]^.elem[1]:=tRaiz;
TAS[vExpArit4,tRaiz]^.elem[2]:=tParentesisAbre;
TAS[vExpArit4,tRaiz]^.elem[3]:=vExpArit4;
TAS[vExpArit4,tRaiz]^.elem[4]:=tparentesiscierra;
TAS[vExpArit4,tRaiz]^.cant:=4;

New(TAS[vExpArit4,tConstReal]);
TAS[vExpArit4,tConstReal]^.elem[1]:=tConstReal;
TAS[vExpArit4,tConstReal]^.cant:=1;

New(TAS[vExpArit4,tid]);
TAS[vExpArit4,tid]^.elem[1]:=tid;
TAS[vExpArit4,tid]^.cant:=1;

New(TAS[vExpArit4,tParentesisAbre]);
TAS[vExpArit4,tParentesisAbre]^.elem[1]:=tParentesisAbre;
TAS[vExpArit4,tParentesisAbre]^.elem[2]:=vexparit1;
TAS[vExpArit4,tParentesisAbre]^.elem[3]:=tparentesiscierra;
TAS[vExpArit4,tParentesisAbre]^.cant:=3;


New(TAS[vL,tPotencia]);
TAS[vL,tPotencia]^.elem[1]:=tPotencia;
TAS[vL,tPotencia]^.elem[2]:=vExpArit4;
TAS[vL,tPotencia]^.elem[3]:=vL;
TAS[vL,tPotencia]^.cant:=3;

New(TAS[vL,tPor]);
TAS[vL,tPor]^.cant:=0;

New(TAS[vL,tDividir]);
TAS[vL,tDividir]^.cant:=0;

New(TAS[vL,tMas]);
TAS[vL,tMas]^.cant:=0;

New(TAS[vL,tMenos]);
TAS[vL,tMenos]^.cant:=0;

New(TAS[vL,tPunto]);
TAS[vL,tPunto]^.cant:=0;

New(TAS[vL,tPunto]);
TAS[vL,tPunto]^.cant:=0;

New(TAS[vL,tparentesiscierra]);
TAS[vL,tparentesiscierra]^.cant:=0;

New(TAS[vL,tOpRel]);
TAS[vL,tOpRel]^.cant:=0;

New(TAS[vL,tOr]);
TAS[vL,tOr]^.cant:=0;

New(TAS[vL,tAnd]);
TAS[vL,tAnd]^.cant:=0;

New(TAS[vL,thacer]);
TAS[vL,thacer]^.cant:=0;

New(TAS[vL,tEntonces]);
TAS[vL,tEntonces]^.cant:=0;

New(TAS[vL,tcorchetec]);
TAS[vL,tcorchetec]^.cant:=0;

New(TAS[vciclo,tmientras]);
TAS[vciclo,tmientras]^.elem[1]:=tmientras;
TAS[vciclo,tmientras]^.elem[2]:=vCond;
TAS[vciclo,tmientras]^.elem[3]:=thacer;
TAS[vciclo,tmientras]^.elem[4]:=tBarra;
TAS[vciclo,tmientras]^.elem[5]:=vsecsent;
TAS[vciclo,tmientras]^.elem[6]:=tBarra;
TAS[vciclo,tmientras]^.cant:=6;

New(TAS[vCondicional,tSi]);
TAS[vCondicional,tSi]^.elem[1]:=tSi;
TAS[vCondicional,tSi]^.elem[2]:=vQ;
TAS[vCondicional,tSi]^.cant:=2;

New(TAS[vQ,tNot]);
TAS[vQ,tNot]^.elem[1]:=vCond;
TAS[vQ,tNot]^.elem[2]:=tEntonces;
TAS[vQ,tNot]^.elem[3]:=tBarra;
TAS[vQ,tNot]^.elem[4]:=vsecsent;
TAS[vQ,tNot]^.elem[5]:=tBarra;
TAS[vQ,tNot]^.elem[6]:=vA;
TAS[vQ,tNot]^.cant:=6;

New(TAS[vQ,tmenos]);
TAS[VQ,tmenos]^.elem[1]:=vCond;
TAS[VQ,tmenos]^.elem[2]:=tEntonces;
TAS[VQ,tmenos]^.elem[3]:=tBarra;
TAS[VQ,tmenos]^.elem[4]:=vsecsent;
TAS[VQ,tmenos]^.elem[5]:=tBarra;
TAS[VQ,tmenos]^.elem[6]:=VA;
TAS[VQ,tmenos]^.cant:=6;

New(TAS[VQ,tRaiz]);
TAS[VQ,tRaiz]^.elem[1]:=vCond;
TAS[VQ,tRaiz]^.elem[2]:=tEntonces;
TAS[VQ,tRaiz]^.elem[3]:=tBarra;
TAS[VQ,tRaiz]^.elem[4]:=vsecsent;
TAS[VQ,tRaiz]^.elem[5]:=tBarra;
TAS[VQ,tRaiz]^.elem[6]:=VA;
TAS[VQ,tRaiz]^.cant:=6;

New(TAS[VQ,tConstReal]);
TAS[VQ,tConstReal]^.elem[1]:=vCond;
TAS[VQ,tConstReal]^.elem[2]:=tEntonces;
TAS[VQ,tConstReal]^.elem[3]:=tBarra;
TAS[VQ,tConstReal]^.elem[4]:=vsecsent;
TAS[VQ,tConstReal]^.elem[5]:=tBarra;
TAS[VQ,tConstReal]^.elem[6]:=VA;
TAS[VQ,tConstReal]^.cant:=6;

New(TAS[VQ,tid]);
TAS[VQ,tid]^.elem[1]:=vCond;
TAS[VQ,tid]^.elem[2]:=tEntonces;
TAS[VQ,tid]^.elem[3]:=tBarra;
TAS[VQ,tid]^.elem[4]:=vsecsent;
TAS[VQ,tid]^.elem[5]:=tBarra;
TAS[VQ,tid]^.elem[6]:=VA;
TAS[VQ,tid]^.cant:=6;

New(TAS[VQ,tcorchetea]);
TAS[VQ,tcorchetea]^.elem[1]:=vCond;
TAS[VQ,tcorchetea]^.elem[2]:=tEntonces;
TAS[VQ,tcorchetea]^.elem[3]:=tBarra;
TAS[VQ,tcorchetea]^.elem[4]:=vsecsent;
TAS[VQ,tcorchetea]^.elem[5]:=tBarra;
TAS[VQ,tcorchetea]^.elem[6]:=VA;
TAS[VQ,tcorchetea]^.cant:=6;

New(TAS[VQ,tParentesisAbre]);
TAS[VQ,tParentesisAbre]^.elem[1]:=vCond;
TAS[VQ,tParentesisAbre]^.elem[2]:=tEntonces;
TAS[VQ,tParentesisAbre]^.elem[3]:=tBarra;
TAS[VQ,tParentesisAbre]^.elem[4]:=vsecsent;
TAS[VQ,tParentesisAbre]^.elem[5]:=tBarra;
TAS[VQ,tParentesisAbre]^.elem[6]:=VA;
TAS[VQ,tParentesisAbre]^.cant:=6;

New(TAS[VA,tSino]);
TAS[VA,tSino]^.elem[1]:=tSino;
TAS[VA,tSino]^.elem[2]:=tBarra;
TAS[VA,tSino]^.elem[3]:=vsecsent;
TAS[VA,tSino]^.elem[4]:=tBarra;
TAS[VA,tSino]^.cant:=4;

New(TAS[VA,tPunto]);
TAS[VA,tPunto]^.cant:=0;

New(TAS[vCond,tNot]);
TAS[vCond,tNot]^.elem[1]:=vExplog2;
TAS[vCond,tNot]^.elem[2]:=vK;
TAS[vCond,tNot]^.cant:=2;

New(TAS[vCond,tcorchetea]);
TAS[vCond,tcorchetea]^.elem[1]:=vExplog2;
TAS[vCond,tcorchetea]^.elem[2]:=vK;
TAS[vCond,tcorchetea]^.cant:=2;

New(TAS[vCond,tRaiz]);
TAS[vCond,tRaiz]^.elem[1]:=vExplog2;
TAS[vCond,tRaiz]^.elem[2]:=vK;
TAS[vCond,tRaiz]^.cant:=2;

New(TAS[vCond,tConstReal]);
TAS[vCond,tConstReal]^.elem[1]:=vExplog2;
TAS[vCond,tConstReal]^.elem[2]:=vK;
TAS[vCond,tConstReal]^.cant:=2;

New(TAS[vCond,tid]);
TAS[vCond,tid]^.elem[1]:=vExplog2;
TAS[vCond,tid]^.elem[2]:=vK;
TAS[vCond,tid]^.cant:=2;

New(TAS[vCond,tParentesisAbre]);
TAS[vCond,tParentesisAbre]^.elem[1]:=vExplog2;
TAS[vCond,tParentesisAbre]^.elem[2]:=vK;
TAS[vCond,tParentesisAbre]^.cant:=2;

New(TAS[vCond,tMenos]);
TAS[vCond,tMenos]^.elem[1]:=vExplog2;
TAS[vCond,tMenos]^.elem[2]:=vK;
TAS[vCond,tMenos]^.cant:=2;

New(TAS[vK,tAnd]);
TAS[vK,tAnd]^.elem[1]:=tAnd;
TAS[vK,tAnd]^.elem[2]:=vExplog2;
TAS[vK,tAnd]^.elem[3]:=vK;
TAS[vK,tAnd]^.cant:=3;

New(TAS[vK,tHacer]);
TAS[vK,tHacer]^.cant:=0;

New(TAS[vK,tEntonces]);
TAS[vK,tEntonces]^.cant:=0;

New(TAS[vK,tcorchetec]);
TAS[vK,tcorchetec]^.cant:=0;

New(TAS[vExplog2,tNot]);
TAS[vExplog2,tNot]^.elem[1]:=vExpLog3;
TAS[vExplog2,tNot]^.elem[2]:=vM;
TAS[vExplog2,tNot]^.cant:=2;

New(TAS[vExplog2,tMenos]);
TAS[vExplog2,tMenos]^.elem[1]:=vExpLog3;
TAS[vExplog2,tMenos]^.elem[2]:=vM;
TAS[vExplog2,tMenos]^.cant:=2;

New(TAS[vExplog2,tRaiz]);
TAS[vExplog2,tRaiz]^.elem[1]:=vExpLog3;
TAS[vExplog2,tRaiz]^.elem[2]:=vM;
TAS[vExplog2,tRaiz]^.cant:=2;

New(TAS[vExplog2,tConstReal]);
TAS[vExplog2,tConstReal]^.elem[1]:=vExpLog3;
TAS[vExplog2,tConstReal]^.elem[2]:=vM;
TAS[vExplog2,tConstReal]^.cant:=2;

New(TAS[vExplog2,tid]);
TAS[vExplog2,tid]^.elem[1]:=vExpLog3;
TAS[vExplog2,tid]^.elem[2]:=vM;
TAS[vExplog2,tid]^.cant:=2;

New(TAS[vExplog2,tParentesisAbre]);
TAS[vExplog2,tParentesisAbre]^.elem[1]:=vExpLog3;
TAS[vExplog2,tParentesisAbre]^.elem[2]:=vM;
TAS[vExplog2,tParentesisAbre]^.cant:=2;

New(TAS[vExplog2,tCorcheteA]);
TAS[vExplog2,tCorcheteA]^.elem[1]:=vExpLog3;
TAS[vExplog2,tCorcheteA]^.elem[2]:=vM;
TAS[vExplog2,tCorcheteA]^.cant:=2;

New(TAS[vM,tOr]);
TAS[vM,tOr]^.elem[1]:=tOr;
TAS[vM,tOr]^.elem[2]:=vExpLog3;
TAS[vM,tOr]^.elem[3]:=vM;
TAS[vM,tOr]^.cant:=3;

New(TAS[vM,tAnd]);
TAS[vM,tAnd]^.cant:=0;

New(TAS[vM,tHacer]);
TAS[vM,tHacer]^.cant:=0;

New(TAS[vM,tEntonces]);
TAS[vM,tEntonces]^.cant:=0;

New(TAS[vM,tCorcheteC]);
TAS[vM,tCorcheteC]^.cant:=0;

New(TAS[vExpLog3,tNot]);
TAS[vExpLog3,tNot]^.elem[1]:=tNot;
TAS[vExpLog3,tNot]^.elem[2]:=vExpLog3;
TAS[vExpLog3,tNot]^.cant:=2;

New(TAS[vExpLog3,tMenos]);
TAS[vExpLog3,tMenos]^.elem[1]:=vexprel;
TAS[vExpLog3,tMenos]^.cant:=1;

New(TAS[vExpLog3,tRaiz]);
TAS[vExpLog3,tRaiz]^.elem[1]:=vexprel;
TAS[vExpLog3,tRaiz]^.cant:=1;

New(TAS[vExpLog3,tConstReal]);
TAS[vExpLog3,tConstReal]^.elem[1]:=vexprel;
TAS[vExpLog3,tConstReal]^.cant:=1;

New(TAS[vExpLog3,tid]);
TAS[vExpLog3,tid]^.elem[1]:=vexprel;
TAS[vExpLog3,tid]^.cant:=1;

New(TAS[vExpLog3,tParentesisAbre]);
TAS[vExpLog3,tParentesisAbre]^.elem[1]:=vexprel;
TAS[vExpLog3,tParentesisAbre]^.cant:=1;

New(TAS[vExpLog3,tCorcheteA]);
TAS[vExpLog3,tCorcheteA]^.elem[1]:=vexprel;
TAS[vExpLog3,tCorcheteA]^.cant:=1;

New(TAS[vexprel,tMenos]);
TAS[vexprel,tMenos]^.elem[1]:=vexparit1;
TAS[vexprel,tMenos]^.elem[2]:=tOpRel;
TAS[vexprel,tMenos]^.elem[3]:=vexparit1;
TAS[vexprel,tMenos]^.cant:=3;

New(TAS[vexprel,tRaiz]);
TAS[vexprel,tRaiz]^.elem[1]:=vexparit1;
TAS[vexprel,tRaiz]^.elem[2]:=tOpRel;
TAS[vexprel,tRaiz]^.elem[3]:=vexparit1;
TAS[vexprel,tRaiz]^.cant:=3;

New(TAS[vexprel,tConstReal]);
TAS[vexprel,tConstReal]^.elem[1]:=vexparit1;
TAS[vexprel,tConstReal]^.elem[2]:=tOpRel;
TAS[vexprel,tConstReal]^.elem[3]:=vExpArit1;
TAS[vExpRel,tConstReal]^.cant:=3;

New(TAS[vExpRel,tid]);
TAS[vExpRel,tid]^.elem[1]:=vExpArit1;
TAS[vExpRel,tid]^.elem[2]:=tOpRel;
TAS[vExpRel,tid]^.elem[3]:=vExpArit1;
TAS[vExpRel,tid]^.cant:=3;

New(TAS[vExpRel,tParentesisAbre]);
TAS[vExpRel,tParentesisAbre]^.elem[1]:=vExpArit1;
TAS[vExpRel,tParentesisAbre]^.elem[2]:=tOpRel;
TAS[vExpRel,tParentesisAbre]^.elem[3]:=vExpArit1;
TAS[vExpRel,tParentesisAbre]^.cant:=3;

New(TAS[vExpRel,tCorcheteA]);
TAS[vExpRel,tCorcheteA]^.elem[1]:=tCorcheteA;
TAS[vExpRel,tCorcheteA]^.elem[2]:=vCond;
TAS[vExpRel,tCorcheteA]^.elem[3]:=tCorcheteC;
TAS[vExpRel,tCorcheteA]^.cant:=3;

New(TAS[vLectura,tcadena]);
TAS[vLectura,tcadena]^.elem[1]:=tCadena;
TAS[vLectura,tCadena]^.elem[2]:=tComa;
TAS[vLectura,tCadena]^.elem[3]:=tingresar;
TAS[vLectura,tCadena]^.elem[4]:=tParentesisAbre;
TAS[vLectura,tCadena]^.elem[5]:=tid;
TAS[vLectura,tCadena]^.elem[6]:=tParentesisCierra;
TAS[vLectura,tCadena]^.cant:=6;

New(TAS[vEscritura,tImprimir]);
TAS[vEscritura,tImprimir]^.elem[1]:=tImprimir;
TAS[vEscritura,tImprimir]^.elem[2]:=vR;
TAS[vEscritura,tImprimir]^.cant:=2;

New(TAS[vR,tParentesisAbre]);
TAS[vR,tParentesisAbre]^.elem[1]:=tParentesisAbre;
TAS[vR,tParentesisAbre]^.elem[2]:=vW;
TAS[vR,tParentesisAbre]^.cant:=2;

New(TAS[vW,tMenos]);
TAS[vW,tMenos]^.elem[1]:=vExpArit1;
TAS[vW,tMenos]^.elem[2]:=tParentesisCierra;
TAS[vW,tMenos]^.cant:=2;

New(TAS[vW,tRaiz]);
TAS[vW,tRaiz]^.elem[1]:=vExpArit1;
TAS[vW,tRaiz]^.elem[2]:=tParentesisCierra;
TAS[vW,tRaiz]^.cant:=2;

New(TAS[vW,tConstReal]);
TAS[vW,tConstReal]^.elem[1]:=vExpArit1;
TAS[vW,tConstReal]^.elem[2]:=tParentesisCierra;
TAS[vW,tConstReal]^.cant:=2;

New(TAS[vW,tid]);
TAS[vW,tid]^.elem[1]:=vExpArit1;
TAS[vW,tid]^.elem[2]:=tParentesisCierra;
TAS[vW,tid]^.cant:=2;

New(TAS[vW,tParentesisAbre]);
TAS[vW,tParentesisAbre]^.elem[1]:=vExpArit1;
TAS[vW,tParentesisAbre]^.elem[2]:=tParentesisCierra;
TAS[vW,tParentesisAbre]^.cant:=2;

New(TAS[vW,tCadena]);
TAS[vW,tCadena]^.elem[1]:=tCadena;
TAS[vW,tCadena]^.elem[2]:=vCAD;
TAS[vW,tCadena]^.elem[3]:=tParentesisCierra;
TAS[vW,tCadena]^.cant:=3;

New(TAS[vCAD,tComa]);
TAS[vCAD,tComa]^.elem[1]:=tComa;
TAS[vCAD,tComa]^.elem[2]:=tCadena;
TAS[vCAD,tComa]^.elem[3]:=vCAD;
TAS[vCAD,tComa]^.cant:=3;

New(TAS[vCAD,tParentesisCierra]);
TAS[vCAD,tParentesisCierra]^.cant:=0;

end;
procedure cargar_archivo( var archarbol:text; var raiz:t_arbol; desplazamiento:word);
var i:byte;
begin
writeln(archarbol,'':desplazamiento,raiz^.simb,'-',raiz^.lexema);
for i:=1 to raiz^.Chijos do
 cargar_archivo(archarbol,raiz^.hijos[i],desplazamiento+2);
end;
procedure apilar_cargararbol (var pila:t_pila; tas:t_matriz; x,a:tsimbgram; padre:t_arbol);
var n:integer;  aux:tsimbgram;  hijo:t_arbol;
begin
 for n:=1 to tas[x,a]^.cant do
 begin
    aux:=tas[x,a]^.elem[n];
    crear_nodo(hijo,aux);
    agregar_hijo(padre,hijo);
 end;
  apilartodos(tas[x,a]^,padre,pila);
end;
procedure analizador_sintactico(var arch:t_arch; var arbol:t_arbol; var estado:est);
var tas:t_matriz;
  x:t_dato_pila;
  a:t_dato;
  control:longint;
  lista:t_ts;
  pila:t_pila;
  archarbol:text;
begin
 cargarPalabrasReservadas(lista);
 inicializar_tas(tas);
 cargar_tas(tas);
 crearpila(pila);
 crear_nodo(arbol,vprograma);
 x.simb:=pesos;
 x.nodo:=nil;
 apilar(pila,x);
 x.simb:=vprograma;
 x.nodo:=arbol;
 apilar(pila,x);

 control:=0;
 estado:=enproceso;
 ObtenerSigCompLex (arch,a.lexema,a.complex,control,lista);

 while estado=enproceso do
  begin
    desapilar(pila,x);
    if x.simb in [tid..tpotencia] then
    begin
    if x.simb=a.complex then
    begin
     x.nodo^.Lexema:=a.lexema;
     ObtenerSigCompLex (arch,a.lexema,a.complex,control,lista);
     end;
     end
     else
    begin

    if x.simb in [vprograma..vcad]then
    begin
    if tas[x.simb,a.complex]=nil then
    begin
    estado:=errorsintactico;
    Writeln(x.simb,' y ',a.complex);
    end
    else
      begin
      apilar_cargararbol (pila,tas,x.simb,a.complex,x.nodo);
      estado:=enproceso;
      end;
    end
    else
    begin
    if (x.simb=pesos) and (a.complex=pesos) then
    estado:=exito;
    end;
    end;
end;
  //Mostrar_arbol(arbol);
  //readkey;
  assign(archarbol,'C:\Users\sofia\OneDrive\facultad\Sintaxis y Semantica\Proyecto integrador\Proyecto integrador\archivoarbol.txt');
  rewrite(archarbol);
  cargar_archivo(archarbol,arbol,0);
  close(archarbol);
  readkey;
    end;
end.



