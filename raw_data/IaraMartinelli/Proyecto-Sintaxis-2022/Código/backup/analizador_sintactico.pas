unit Analizador_sintactico;

interface

uses base,analizador_lexico,arbol,pila,crt,classes,sysutils;
type
  est=(enproceso,exito,errorsintactico);
procedure inicializar_TAS(var TAS:t_matriz);
procedure cargar_TAS (var tas:t_matriz);
function terminal (x:tsimbgram):boolean;
function variable (x:tsimbgram):boolean;
procedure alg_de_reconocimiento (var arch:t_arch; var raiz:t_arbol);
procedure apilar_cargararbol (var pila:t_pila; tas:t_matriz; x,a:tsimbgram);
procedure analizador_sintactico1(var arch:t_arch; var arbol:t_arbol);
procedure cargar_archivo( var archarbol:text; var raiz:t_arbol);

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
 new(tas[vasignacion,tid]);
 tas[vasignacion,tid]^.elem[1]:=tid;
 tas[vasignacion,tid]^.elem[2]:=tasig;
 tas[vasignacion,tid]^.elem[3]:=vexparit1;
 tas[vasignacion,tid]^.cant:=3;

 new(tas[vexparit1, tmenos]);
 tas[vexparit1,tmenos]^.elem[1]:=vexparit2;
 tas[vexparit1,tmenos]^.elem[2]:=vh;
 tas[vexparit1,tmenos]^.cant:=2;

 new(tas[vexparit1, traiz]);
 tas[vexparit1,traiz]^.elem[1]:=vexparit2;
 tas[vexparit1,traiz]^.elem[2]:=vh;
 tas[vexparit1,traiz]^.cant:=2;

 new(tas[vexparit1, tconstreal]);
 tas[vexparit1,tconstreal]^.elem[1]:=vexparit2;
 tas[vexparit1,tconstreal]^.elem[2]:=vh;
 tas[vexparit1,tconstreal]^.cant:=2;

 new(tas[vexparit1, tid]);
 tas[vexparit1,tid]^.elem[1]:=vexparit2;
 tas[vexparit1,tid]^.elem[2]:=vh;
 tas[vexparit1,tid]^.cant:=2;

 new(tas[vexparit1, tparentesisabre]);
 tas[vexparit1,tparentesisabre]^.elem[1]:=vexparit2;
 tas[vexparit1,tparentesisabre]^.elem[2]:=vh;
 tas[vexparit1,tparentesisabre]^.cant:=2;

 new(tas[vh, tmas]);
 tas[vh,tmas]^.elem[1]:=Tmas;
 tas[vh,tmas]^.elem[2]:=vexparit2;
 tas[vh,tmas]^.elem[3]:=vh;
 tas[vh,tmas]^.cant:=3;

 new(tas[vh, tmenos]);
 tas[vh,tmenos]^.elem[1]:=Tmenos;
 tas[vh,tmenos]^.elem[2]:=vexparit2;
 tas[vh,tmenos]^.elem[3]:=vh;
 tas[vh,tmenos]^.cant:=3;

 new(tas[vh,tor]);
 tas[vh,tor]^.cant:=0;

 new(tas[vh,tand]);
 tas[vh,tand]^.cant:=0;

 new(tas[vh,tentonces]);
 tas[vh,tentonces]^.cant:=0;

 new(tas[vh,tcorchetec]);
 tas[vh,tcorchetec]^.cant:=0;

 new(tas[vh,thacer]);
 tas[vh,thacer]^.cant:=0;

 new(tas[vh,tpunto]);
 tas[vh,tpunto]^.cant:=0;

 new(tas[vh,tparentesiscierra]);
 tas[vh,tparentesiscierra]^.cant:=0;

 new(tas[vh,toprel]);
 tas[vh,toprel]^.cant:=0;

 new(tas[vexparit2,tmenos]);
 tas[vexparit2,tmenos]^.elem[1]:=vexparit3;
 tas[vexparit2,tmenos]^.elem[2]:=vj;
 tas[vexparit2,tmenos]^.cant:=2;

 new(tas[vexparit2,traiz]);
 tas[vexparit2,traiz]^.elem[1]:=vexparit3;
 tas[vexparit2,traiz]^.elem[2]:=vj;
 tas[vexparit2,traiz]^.cant:=2;

 new(tas[vexparit2,tconstreal]);
 tas[vexparit2,tconstreal]^.elem[1]:=vexparit3;
 tas[vexparit2,tconstreal]^.elem[2]:=vj;
 tas[vexparit2,tconstreal]^.cant:=2;

 new(tas[vexparit2,tid]);
 tas[vexparit2,tid]^.elem[1]:=vexparit3;
 tas[vexparit2,tid]^.elem[2]:=vj;
 tas[vexparit2,tid]^.cant:=2;

 new(tas[vexparit2,tparentesisabre]);
 tas[vexparit2,tparentesisabre]^.elem[1]:=vexparit3;
 tas[vexparit2,tparentesisabre]^.elem[2]:=vj;
 tas[vexparit2,tparentesisabre]^.cant:=2;

 new(tas[vj,tpor]);
 tas[vj,tpor]^.elem[1]:=tpor;
 tas[vj,tpor]^.elem[2]:=vexparit3;
 tas[vj,tpor]^.elem[3]:=vj;
 tas[vj,tpor]^.cant:=3;

 new(tas[vj,tdividir]);
 tas[vj,tdividir]^.elem[1]:=tdividir;
 tas[vj,tdividir]^.elem[2]:=vexparit3;
 tas[vj,tdividir]^.elem[3]:=vj;
 tas[vj,tdividir]^.cant:=3;

 new(tas[vj,tmas]);
 tas[vj,tmas]^.cant:=0;

 new(tas[vj,tmenos]);
 tas[vj,tmenos]^.cant:=0;

 new(tas[vj,tpunto]);
 tas[vj,tpunto]^.cant:=0;

 new(tas[vj,tparentesiscierra]);
 tas[vj,tparentesiscierra]^.cant:=0;

 new(tas[vj,toprel]);
 tas[vj,toprel]^.cant:=0;

 new(tas[vj,tor]);
 tas[vj,tor]^.cant:=0;

 new(tas[vj,tand]);
 tas[vj,tand]^.cant:=0;

 new(tas[vj,tentonces]);
 tas[vj,tentonces]^.cant:=0;

 new(tas[vj,tcorchetec]);
 tas[vj,tcorchetec]^.cant:=0;

 new(tas[vj,thacer]);
 tas[vj,thacer]^.cant:=0;

 new(tas[vexparit3,traiz]);
 tas[vexparit3,traiz]^.elem[1]:=traiz;
 tas[vexparit3,traiz]^.elem[2]:=tparentesisabre;
 tas[vexparit3,traiz]^.elem[3]:=vexparit3;
 tas[vexparit3,traiz]^.elem[4]:=tparentesiscierra;
 tas[vexparit3,traiz]^.elem[5]:=vl;
 tas[vexparit3,traiz]^.cant:=5;

 new(tas[vexparit3,tconstreal]);
 tas[vexparit3,tconstreal]^.elem[1]:=tconstreal;
 tas[vexparit3,tconstreal]^.elem[2]:=vl;
 tas[vexparit3,tconstreal]^.cant:=2;

 new(tas[vexparit3,tid]);
 tas[vexparit3,tid]^.elem[1]:=tid;
 tas[vexparit3,tid]^.elem[2]:=vl;
 tas[vexparit3,tid]^.cant:=2;

 new(tas[vexparit3,tparentesisabre]);
 tas[vexparit3,tparentesisabre]^.elem[1]:=tparentesisabre;
 tas[vexparit3,tparentesisabre]^.elem[2]:=vexparit1;
 tas[vexparit3,tparentesisabre]^.elem[3]:=tparentesiscierra;
 tas[vexparit3,tparentesisabre]^.elem[4]:=vl;
 tas[vexparit3,tparentesisabre]^.cant:=4;

 new(tas[vl,tpotencia]);
 tas[vl,tpotencia]^.elem[1]:=tpotencia;
 tas[vl,tpotencia]^.elem[2]:=vexparit3;
 tas[vl,tpotencia]^.elem[3]:=vl;
 tas[vl,tpotencia]^.cant:=3;

 new(tas[vl,tpor]);
 tas[vl,tpor]^.cant:=0;

 new(tas[vl,tdividir]);
 tas[vl,tdividir]^.cant:=0;

 new(tas[vl,tmas]);
 tas[vl,tmas]^.cant:=0;

 new(tas[vl,tmenos]);
 tas[vl,tmenos]^.cant:=0;

 new(tas[vl,tpunto]);
 tas[vl,tpunto]^.cant:=0;

 new(tas[vl,tparentesiscierra]);
 tas[vl,tparentesiscierra]^.cant:=0;

 new(tas[vl,toprel]);
 tas[vl,toprel]^.cant:=0;

 new(tas[vl,tor]);
 tas[vl,tor]^.cant:=0;

 new(tas[vl,tand]);
 tas[vl,tand]^.cant:=0;

 new(tas[vl,tentonces]);
 tas[vl,tentonces]^.cant:=0;

 new(tas[vl,tcorchetec]);
 tas[vl,tcorchetec]^.cant:=0;

 new(tas[vl,thacer]);
 tas[vl,thacer]^.cant:=0;

 new(tas[vcond,tnot]);
 tas[vcond,tnot]^.elem[1]:=vexplog2;
 tas[vcond,tnot]^.elem[2]:=vk;
 tas[vcond,tnot]^.cant:=2;

 new(tas[vcond,tcorchetea]);
 tas[vcond,tcorchetea]^.elem[1]:=vexplog2;
 tas[vcond,tcorchetea]^.elem[2]:=vk;
 tas[vcond,tcorchetea]^.cant:=2;

 new(tas[vcond,traiz]);
 tas[vcond,traiz]^.elem[1]:=vexplog2;
 tas[vcond,traiz]^.elem[2]:=vk;
 tas[vcond,traiz]^.cant:=2;

 new(tas[vcond,tconstreal]);
 tas[vcond,tconstreal]^.elem[1]:=vexplog2;
 tas[vcond,tconstreal]^.elem[2]:=vk;
 tas[vcond,tconstreal]^.cant:=2;

 new(tas[vcond,tid]);
 tas[vcond,tid]^.elem[1]:=vexplog2;
 tas[vcond,tid]^.elem[2]:=vk;
 tas[vcond,tid]^.cant:=2;

 new(tas[vcond,tparentesisabre]);
 tas[vcond,tparentesisabre]^.elem[1]:=vexplog2;
 tas[vcond,tparentesisabre]^.elem[2]:=vk;
 tas[vcond,tparentesisabre]^.cant:=2;

 new(tas[vk,tand]);
 tas[vk,tand]^.elem[1]:=tand;
 tas[vk,tand]^.elem[2]:=vexplog2;
 tas[vk,tand]^.elem[3]:=vk;
 tas[vk,tand]^.cant:=3;

 new(tas[vk,thacer]);
 tas[vk,thacer]^.cant:=0;

 new(tas[vk,tentonces]);
 tas[vk,tentonces]^.cant:=0;

 new(tas[vk,tcorchetec]);
 tas[vk,tcorchetec]^.cant:=0;

 new(tas[vexplog2,tnot]);
 tas[vexplog2,tnot]^.elem[1]:=vexplog3;
 tas[vexplog2,tnot]^.elem[2]:=vm;
 tas[vexplog2,tnot]^.cant:=2;

 new(tas[vexplog2,tmenos]);
 tas[vexplog2,tmenos]^.elem[1]:=vexplog3;
 tas[vexplog2,tmenos]^.elem[2]:=vm;
 tas[vexplog2,tmenos]^.cant:=2;

 new(tas[vexplog2,traiz]);
 tas[vexplog2,traiz]^.elem[1]:=vexplog3;
 tas[vexplog2,traiz]^.elem[2]:=vm;
 tas[vexplog2,traiz]^.cant:=2;

 new(tas[vexplog2,tconstreal]);
 tas[vexplog2,tconstreal]^.elem[1]:=vexplog3;
 tas[vexplog2,tconstreal]^.elem[2]:=vm;
 tas[vexplog2,tconstreal]^.cant:=2;

 new(tas[vexplog2,tid]);
 tas[vexplog2,tid]^.elem[1]:=vexplog3;
 tas[vexplog2,tid]^.elem[2]:=vm;
 tas[vexplog2,tid]^.cant:=2;

 new(tas[vexplog2,tparentesisabre]);
 tas[vexplog2,tparentesisabre]^.elem[1]:=vexplog3;
 tas[vexplog2,tparentesisabre]^.elem[2]:=vm;
 tas[vexplog2,tparentesisabre]^.cant:=2;

 new(tas[vexplog2,tcorchetea]);
 tas[vexplog2,tcorchetea]^.elem[1]:=vexplog3;
 tas[vexplog2,tcorchetea]^.elem[2]:=vm;
 tas[vexplog2,tcorchetea]^.cant:=2;

 new(tas[vm,tor]);
 tas[vm,tor]^.elem[1]:=tor;
 tas[vm,tor]^.elem[2]:=vexplog3;
 tas[vm,tor]^.elem[3]:=vm;
 tas[vm,tor]^.cant:=3;

 new(tas[vm,tand]);
 tas[vm,tand]^.cant:=0;

 new(tas[vm,thacer]);
 tas[vm,thacer]^.cant:=0;

 new(tas[vm,tentonces]);
 tas[vm,tentonces]^.cant:=0;

 new(tas[vm,tcorchetec]);
 tas[vm,tcorchetec]^.cant:=0;

 new(tas[vexplog3,tnot]);
 tas[vexplog3,tnot]^.elem[1]:=tnot;
 tas[vexplog3,tnot]^.elem[2]:=vexplog3;
 tas[vexplog3,tnot]^.cant:=2;

 new(tas[vexplog3,tmenos]);
 tas[vexplog3,tmenos]^.elem[1]:=vexprel;
 tas[vexplog3,tmenos]^.cant:=1;

 new(tas[vexplog3,traiz]);
 tas[vexplog3,traiz]^.elem[1]:=vexprel;
 tas[vexplog3,traiz]^.cant:=1;

 new(tas[vexplog3,tconstreal]);
 tas[vexplog3,tconstreal]^.elem[1]:=vexprel;
 tas[vexplog3,tconstreal]^.cant:=1;

 new(tas[vexplog3,tid]);
 tas[vexplog3,tid]^.elem[1]:=vexprel;
 tas[vexplog3,tid]^.cant:=1;

 new(tas[vexplog3,tparentesisabre]);
 tas[vexplog3,tparentesisabre]^.elem[1]:=vexprel;
 tas[vexplog3,tparentesisabre]^.cant:=1;

 new(tas[vexplog3,tcorchetea]);
 tas[vexplog3,tcorchetea]^.elem[1]:=vexprel;
 tas[vexplog3,tcorchetea]^.cant:=1;

 new(tas[vexprel,tmenos]);
 tas[vexprel,tmenos]^.elem[1]:=vexparit1;
 tas[vexprel,tmenos]^.elem[2]:=toprel;
 tas[vexprel,tmenos]^.elem[3]:=vexparit1;
 tas[vexprel,tmenos]^.cant:=3;

 new(tas[vexprel,traiz]);
 tas[vexprel,traiz]^.elem[1]:=vexparit1;
 tas[vexprel,traiz]^.elem[2]:=toprel;
 tas[vexprel,traiz]^.elem[3]:=vexparit1;
 tas[vexprel,traiz]^.cant:=3;

 new(tas[vexprel,tconstreal]);
 tas[vexprel,tconstreal]^.elem[1]:=vexparit1;
 tas[vexprel,tconstreal]^.elem[2]:=toprel;
 tas[vexprel,tconstreal]^.elem[3]:=vexparit1;
 tas[vexprel,tconstreal]^.cant:=3;

 new(tas[vexprel,tid]);
 tas[vexprel,tid]^.elem[1]:=vexparit1;
 tas[vexprel,tid]^.elem[2]:=toprel;
 tas[vexprel,tid]^.elem[3]:=vexparit1;
 tas[vexprel,tid]^.cant:=3;

 new(tas[vexprel,tparentesisabre]);
 tas[vexprel,tparentesisabre]^.elem[1]:=vexparit1;
 tas[vexprel,tparentesisabre]^.elem[2]:=toprel;
 tas[vexprel,tparentesisabre]^.elem[3]:=vexparit1;
 tas[vexprel,tparentesisabre]^.cant:=3;

 new(tas[vexprel,tcorchetea]);
 tas[vexprel,tcorchetea]^.elem[1]:=tcorchetea;
 tas[vexprel,tcorchetea]^.elem[2]:=vcond;
 tas[vexprel,tcorchetea]^.elem[3]:=tcorchetec;
 tas[vexprel,tcorchetea]^.cant:=3;

 new(tas[vprograma,tbarra]);
   tas[vprograma,tbarra]^.elem[1]:=tbarra;
   tas[vprograma,tbarra]^.elem[2]:=tid;
   tas[vprograma,tbarra]^.elem[3]:=tbarra;
   tas[vprograma,tbarra]^.elem[4]:=vcuerpo;
   tas[vprograma,tbarra]^.elem[5]:=tpunto;
   tas[vprograma,tbarra]^.cant:=5;

new(tas[vciclo,tmientras]);
tas[vciclo,tmientras]^.elem[1]:=tmientras;
tas[vciclo,tmientras]^.elem[2]:=vcond;
tas[vciclo,tmientras]^.elem[3]:=thacer;
tas[vciclo,tmientras]^.elem[4]:=tbarra;
tas[vciclo,tmientras]^.elem[5]:=vsecsent;
tas[vciclo,tmientras]^.elem[6]:=tbarra;
tas[vciclo,tmientras]^.cant:=6;

new(tas[vcondicional,tsi]);
tas[vcondicional,tsi]^.elem[1]:=tsi;
tas[vcondicional,tsi]^.elem[2]:=vQ;
tas[vcondicional,tsi]^.cant:=2;

new(tas[vq,tnot]);
tas[vq,tnot]^.elem[1]:=vcond;
tas[vq,tnot]^.elem[2]:=tentonces;
tas[vq,tnot]^.elem[3]:=tbarra;
tas[vq,tnot]^.elem[4]:=vsecsent;
tas[vq,tnot]^.elem[5]:=tbarra;
tas[vq,tnot]^.elem[6]:=va;
tas[vq,tnot]^.cant:=6;

new(tas[vq,tmenos]);
tas[vq,tmenos]^.elem[1]:=vcond;
tas[vq,tmenos]^.elem[2]:=tentonces;
tas[vq,tmenos]^.elem[3]:=tbarra;
tas[vq,tmenos]^.elem[4]:=vsecsent;
tas[vq,tmenos]^.elem[5]:=tbarra;
tas[vq,tmenos]^.elem[6]:=va;
tas[vq,tmenos]^.cant:=6;

new(tas[vq,traiz]);
tas[vq,traiz]^.elem[1]:=vcond;
tas[vq,traiz]^.elem[2]:=tentonces;
tas[vq,traiz]^.elem[3]:=tbarra;
tas[vq,traiz]^.elem[4]:=vsecsent;
tas[vq,traiz]^.elem[5]:=tbarra;
tas[vq,traiz]^.elem[6]:=va;
tas[vq,traiz]^.cant:=6;

new(tas[VQ,tConstReal]);
tas[VQ,tConstReal]^.elem[1]:=vcond;
tas[VQ,tConstReal]^.elem[2]:=tentonces;
tas[VQ,tConstReal]^.elem[3]:=tbarra;
tas[VQ,tConstReal]^.elem[4]:=vsecsent;
tas[VQ,tConstReal]^.elem[5]:=tbarra;
tas[VQ,tConstReal]^.elem[6]:=va;
tas[VQ,tConstReal]^.cant:=6;

new(tas[vq,tid]);
tas[vq,tid]^.elem[1]:=vcond;
tas[vq,tid]^.elem[2]:=tentonces;
tas[vq,tid]^.elem[3]:=tbarra;
tas[vq,tid]^.elem[4]:=vsecsent;
tas[vq,tid]^.elem[5]:=tbarra;
tas[vq,tid]^.elem[6]:=va;
tas[vq,tid]^.cant:=6;

new(tas[vq,tcorchetea]);
tas[vq,tcorchetea]^.elem[1]:=vcond;
tas[vq,tcorchetea]^.elem[2]:=tentonces;
tas[vq,tcorchetea]^.elem[3]:=tbarra;
tas[vq,tcorchetea]^.elem[4]:=vsecsent;
tas[vq,tcorchetea]^.elem[5]:=tbarra;
tas[vq,tcorchetea]^.elem[6]:=va;
tas[vq,tcorchetea]^.cant:=6;

new(tas[vq,tparentesisabre]);
tas[vq,tparentesisabre]^.elem[1]:=vcond;
tas[vq,tparentesisabre]^.elem[2]:=tentonces;
tas[vq,tparentesisabre]^.elem[3]:=tbarra;
tas[vq,tparentesisabre]^.elem[4]:=vsecsent;
tas[vq,tparentesisabre]^.elem[5]:=tbarra;
tas[vq,tparentesisabre]^.elem[6]:=va;
tas[vq,tparentesisabre]^.cant:=6;

new(tas[va,tsino]);
tas[va,tsino]^.elem[1]:=tsino;
tas[va,tsino]^.elem[2]:=tbarra;
tas[va,tsino]^.elem[3]:=vsecsent;
tas[va,tsino]^.elem[4]:=tbarra;
tas[va,tsino]^.cant:=4;

new(tas[va,tpunto]);
tas[va,tpunto]^.cant:=0;

   new(tas[vprograma,tbarra]);
   tas[vprograma,tbarra]^.elem[1]:=tbarra;
   tas[vprograma,tbarra]^.elem[2]:=tid;
   tas[vprograma,tbarra]^.elem[3]:=tbarra;
   tas[vprograma,tbarra]^.elem[4]:=vcuerpo;
   tas[vprograma,tbarra]^.elem[5]:=tpunto;
   tas[vprograma,tbarra]^.cant:=5;

   new(tas[vdefinir,tdefine]);
   tas[vdefinir,tdefine]^.elem[1]:=tdefine;
   tas[vdefinir,tdefine]^.elem[2]:=tdospuntos;
   tas[vdefinir,tdefine]^.elem[3]:=vvariables;
   tas[vdefinir,tdefine]^.cant:=3;

   new(tas[vvariables,tid]);
   tas[vvariables,tid]^.elem[1]:=tid;
   tas[vvariables,tid]^.elem[2]:=vv;
   tas[vvariables,tid]^.cant:=2;

   new(tas[vv,tcoma]);
   tas[vv,tcoma]^.elem[1]:=tcoma;
   tas[vv,tcoma]^.elem[2]:=tid;
   tas[vv,tcoma]^.elem[3]:=vv;
   tas[vv,tcoma]^.cant:=3;

   new(tas[vv,tpunto]);
   tas[vv,tpunto]^.cant:=0;

   new(tas[vcuerpo,tcomienzo]);
   tas[vcuerpo,tcomienzo]^.elem[1]:=tcomienzo;
   tas[vcuerpo,tcomienzo]^.elem[2]:=vsecsent;
   tas[vcuerpo,tcomienzo]^.elem[3]:=tfinal;
   tas[vcuerpo,tcomienzo]^.cant:=3;

   new(tas[vsecsent,tid]);
   tas[vsecsent,tid]^.elem[1]:=vt;
   tas[vsecsent,tid]^.cant:=1;

   new(tas[vsecsent,tmientras]);
   tas[vsecsent,tmientras]^.elem[1]:=vt;
   tas[vsecsent,tmientras]^.cant:=1;

   new(tas[vsecsent,tsi]);
   tas[vsecsent,tsi]^.elem[1]:=vt;
   tas[vsecsent,tsi]^.cant:=1;

   new(tas[vsecsent,tcadena]);
   tas[vsecsent,tcadena]^.elem[1]:=vt;
   tas[vsecsent,tcadena]^.cant:=1;

   new(tas[vsecsent,timprimir]);
   tas[vsecsent,timprimir]^.elem[1]:=vt;
   tas[vsecsent,timprimir]^.cant:=1;

   new(tas[vsecsent,tdefine]);
   tas[vsecsent,tdefine]^.elem[1]:=vt;
   tas[vsecsent,tdefine]^.cant:=1;

   new(tas[vt,tid]);
   tas[vt,tid]^.elem[1]:=vsentencia;
   tas[vt,tid]^.elem[2]:=tpunto;
   tas[vt,tid]^.elem[3]:=vt;
   tas[vt,tid]^.cant:=3;

   new(tas[vt,tmientras]);
   tas[vt,tmientras]^.elem[1]:=vsentencia;
   tas[vt,tmientras]^.elem[2]:=tpunto;
   tas[vt,tmientras]^.elem[3]:=vt;
   tas[vt,tmientras]^.cant:=3;

   new(tas[vt,tsi]);
   tas[vt,tsi]^.elem[1]:=vsentencia;
   tas[vt,tsi]^.elem[2]:=tpunto;
   tas[vt,tsi]^.elem[3]:=vt;
   tas[vt,tsi]^.cant:=3;

   new(tas[vt,tcadena]);
   tas[vt,tcadena]^.elem[1]:=vsentencia;
   tas[vt,tcadena]^.elem[2]:=tpunto;
   tas[vt,tcadena]^.elem[3]:=vt;
   tas[vt,tcadena]^.cant:=3;

   new(tas[vt,timprimir]);
   tas[vt,timprimir]^.elem[1]:=vsentencia;
   tas[vt,timprimir]^.elem[2]:=tpunto;
   tas[vt,timprimir]^.elem[3]:=vt;
   tas[vt,timprimir]^.cant:=3;

   new(tas[vt,tdefine]);
   tas[vt,tdefine]^.elem[1]:=vsentencia;
   tas[vt,tdefine]^.elem[2]:=tpunto;
   tas[vt,tdefine]^.elem[3]:=vt;
   tas[vt,tdefine]^.cant:=3;

   new(tas[vt,tfinal]);
   tas[vt,tfinal]^.cant:=0;

   new(tas[vt,tbarra]);
   tas[vt,tbarra]^.cant:=0;

   new(tas[vsentencia,tid]);
   tas[vsentencia,tid]^.elem[1]:=vasignacion;
   tas[vsentencia,tid]^.cant:=1;

   new(tas[vsentencia,tmientras]);
   tas[vsentencia,tmientras]^.elem[1]:=vciclo;
   tas[vsentencia,tmientras]^.cant:=1;

   new(tas[vsentencia,tsi]);
   tas[vsentencia,tsi]^.elem[1]:=vcondicional;
   tas[vsentencia,tsi]^.cant:=1;

   new(tas[vsentencia,tcadena]);
   tas[vsentencia,tcadena]^.elem[1]:=vlectura;
   tas[vsentencia,tcadena]^.cant:=1;

   new(tas[vsentencia,timprimir]);
   tas[vsentencia,timprimir]^.elem[1]:=vescritura;
   tas[vsentencia,timprimir]^.cant:=1;

   new(tas[vsentencia,tdefine]);
   tas[vsentencia,tdefine]^.elem[1]:=vdefinir;
   tas[vsentencia,tdefine]^.cant:=1;

   New(tas[vLectura,tcadena]);
Tas[vlectura,tcadena]^.elem[1]:= tcadena;
Tas[vlectura,tcadena]^.elem[2]:= tcoma;
Tas[vlectura,tcadena]^.elem[3]:= tingresar;
Tas[vlectura,tcadena]^.elem[4]:= tparentesisabre;
Tas[vlectura,tcadena]^.elem[5]:= tid;
Tas[vlectura,tcadena]^.elem[6]:= tparentesiscierra;
Tas[vlectura,tcadena]^.cant:=6;

New(tas[vescritura,timprimir]);
Tas[vescritura,timprimir]^.elem[1]:= timprimir;
Tas[vescritura,timprimir]^.elem[2]:= vr;
Tas[vescritura,timprimir]^.cant:=2;

New(tas[vr,tparentesisabre]);
Tas[vr,tparentesisabre]^.elem[1]:= tparentesisabre;
Tas[vr,tparentesisabre]^.elem[2]:= vw;
Tas[vr,tparentesisabre]^.cant:=2;

New(tas[vw,tmenos]);
Tas[vw,tmenos]^.elem[1]:= vexparit1;
Tas[vw,tmenos]^.elem[2]:= tparentesiscierra;
Tas[vw,tmenos]^.cant:=2;

New(tas[vw,traiz]);
Tas[vw,traiz]^.elem[1]:= vexparit1;
Tas[vw,traiz]^.elem[2]:= tparentesiscierra;
Tas[vw,traiz]^.cant:=2;

New(tas[vw,tconstreal]);
Tas[vw,tconstreal]^.elem[1]:= vexparit1;
Tas[vw,tconstreal]^.elem[2]:= tparentesiscierra;
Tas[vw,tconstreal]^.cant:=2;

New(tas[vw,tid]);
Tas[vw,tid]^.elem[1]:= vexparit1;
Tas[vw,tid]^.elem[2]:= tparentesiscierra;
Tas[vw,tid]^.cant:=2;

New(tas[vw,tparentesisabre]);
Tas[vw,tparentesisabre]^.elem[1]:= vexparit1;
Tas[vw,tparentesisabre]^.elem[2]:= tparentesiscierra;
Tas[vw,tparentesisabre]^.cant:=2;

New(tas[vw,tcadena]);
Tas[vw,tcadena]^.elem[1]:=tcadena;
Tas[vw,tcadena]^.elem[2]:=vcad;
Tas[vw,tcadena]^.elem[3]:=tparentesiscierra;
Tas[vw,tcadena]^.cant:=3;

New(tas[vcad,tcoma]);
Tas[vcad,tcoma]^.elem[1]:=tcoma;
Tas[vcad,tcoma]^.elem[2]:=tcadena;
Tas[vcad,tcoma]^.elem[3]:=vcad;
Tas[vcad,tcoma]^.cant:=3;

New(tas[vcad,tparentesiscierra]);
Tas[vcad,tparentesiscierra]^.cant:=0;
end;
function terminal (x:tsimbgram):boolean;
var i:tterminales;
    terminales:array [tid..tpotencia] of tsimbgram;
    estado:boolean;
begin
 i:=tid;
 estado:=false;
 while (i<=tpotencia) and (estado=false) do
  begin
    if (x) = Terminales[i] then
    begin
    estado:=true;
    terminal:=true;
    end
    else
      begin
        estado:=false;
        inc(i);
        terminal:=false;
      end;
  end;
end;
function variable (x:tsimbgram):boolean;
var
 i:tsimbgram;
 variables:array [vprograma..vcad] of tsimbgram;
 estado:boolean;
begin
 i:=vprograma;
 estado:=false;
 while (i<=vcad) and (estado=false) do
  begin
    if (x)= variables[i] then
    begin
    estado:=true;
    variable:=true;
    end
    else
      begin
        estado:=false;
        inc(i);
      end;
  end;
end;
procedure alg_de_reconocimiento (var arch:t_arch; var raiz:t_arbol);
var variables:array[vprograma..vcad] of tsimbgram;
  x:t_dato_pila;
  i,j:tsimbgram;
  a:t_dato;
  control:longint;
  lista:t_ts;
  pila:t_pila;
  estado:(enproceso,exito,errorsintactico);
  tas:t_matriz;
  archarbol:text;
begin
 cargar_tas(tas);
 crearpila(pila);
 crear_nodo(raiz,vprograma);
 x.simb:=pesos;
 x.nodo:=nil;
 apilar(pila,x);
 x.simb:=vprograma;
 x.nodo:=raiz;
 apilar(pila,x);

 control:=0;
 estado:=enproceso;
 ObtenerSigCompLex (arch,a.lexema,a.complex,control,lista);

 while estado=enproceso do
  begin
    desapilar(pila,x);
    //writeln('Se desapilo ', x.simb);
    if x.simb=pesos then writeln ('pesos');
    if x.simb in [tid..tpotencia] then                     //terminal(x.simb) no anda
    begin
    if x.simb=a.complex then
    begin
     x.nodo^.Lexema:=a.lexema;
     ObtenerSigCompLex (arch,a.lexema,a.complex,control,lista);
     end;
     end
     else
    begin
    if x.simb in [vprograma..vcad]then                         //variable(x.simb)
    begin
    if tas[x.simb,a.complex]=nil then
    estado:=errorsintactico
    else
      begin
      apilar_cargararbol (pila,tas,x.simb,a.complex);
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
  Mostrar_arbol(raiz);
  readkey;
  assign(archarbol,'C:\Users\sofia\OneDrive\facultad\Sintaxis y Semantica\Proyecto final\archivoarbol.txt');
  rewrite(archarbol);
  cargar_archivo(archarbol,raiz);
  close(archarbol);
    end;
procedure cargar_archivo( var archarbol:text; var raiz:t_arbol);
var i:byte;
begin
writeln(archarbol,raiz^.simb,'-',raiz^.lexema);
for i:=1 to raiz^.Chijos do
 cargar_archivo(archarbol,raiz^.hijos[i]);
end;
procedure apilar_cargararbol (var pila:t_pila; tas:t_matriz; x,a:tsimbgram);
var n:integer;  aux:tsimbgram;  hijo:t_arbol;  pila_aux:t_pila;  j:t_dato_pila;
begin
 for n:=1 to tas[x,a]^.cant do
 begin
    aux:=tas[x,a]^.elem[n];
    crear_nodo(hijo,aux);
    agregar_hijo(j.nodo,hijo);
 end;
  apilartodos(tas[x,a]^,j.nodo,pila);
end;
procedure analizador_sintactico1(var arch:t_arch; var arbol:t_arbol);
var tas:t_matriz;
  estado:est;
  //i,j:tsimbgram;
  //l:integer;
begin
  inicializar_tas(tas);
  //cargar_TAS(tas);
  //for l:=1 to tas[vasignacion,tid]^.cant do
  //writeln (tas[vasignacion,tid]^.elem[l]);
  while not (estado in [exito,errorsintactico]) do
   begin
  alg_de_reconocimiento (arch,arbol);
  end;

end;
end.



