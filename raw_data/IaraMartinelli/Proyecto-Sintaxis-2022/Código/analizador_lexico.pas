unit Analizador_lexico;

interface

uses
   base,lista ;

procedure leer_caracter (var arch:t_arch; var control:longint; var caracteracter:char);
Procedure cargarPalabrasReservadas(var l:t_ts);
procedure cargar_tabla(var l:t_ts; lexema:string; var complex:tsimbgram);
function identificador (var arch:t_arch; var control:longint; var lexema:string):boolean;
function constReal (var arch:t_arch; var control:longint; var lexema:string):boolean;
Function cadena (var arch:t_arch; var control:longint; var lexema:string):boolean;
Function EsSimboloEspecial(Var arch:T_Arch;Var Control:Longint; Var CompLex:tsimbgram;Var Lexema:String):boolean;
Procedure ObtenerSigCompLex (var arch:t_arch; var lexema:STRING; var complex:tsimbgram; var control:longint; var lista:t_ts);
procedure analizador_lexico_prueba(var lista:t_ts; var arch:t_arch);

implementation
procedure leer_caracter (var arch:t_arch; var control:longint; var caracteracter:char);
begin
seek(arch,control);
if eof(arch) then
caracteracter:=#0
else
read(arch,caracteracter);
end;
Procedure cargarPalabrasReservadas(var l:t_ts);
var c:t_dato;
begin
 iniciar_lista(l);
 c.Complex:=tcomienzo;
 c.lexema:='comienzo';
 cargar(l,c);
 c.complex:=tfinal;
 c.lexema:='final';
 cargar(l,c);
 c.complex:=tmientras;
 c.lexema:='mientras';
 cargar(l,c);
 c.complex:=tentonces;
 c.lexema:='entonces';
 cargar(l,c);
 c.complex:=tsi;
 c.lexema:='si';
 cargar(l,c);
c.complex:=tsino;
c.lexema:='sino';
cargar(l,c);
c.complex:=tand;
c.LEXEMA:='and';
cargar(l,c);
c.complex:=tor;
c.lexema:='or';
cargar(l,c);
c.complex:=tnot;
c.lexema:='not';
cargar(l,c);
c.complex:=timprimir;
c.lexema:='imprimir';
cargar(l,c);
c.complex:=tingresar;
c.LEXEMA:='ingresar';
cargar(l,c);
c.complex:=thacer;
c.lexema:='hacer';
cargar(l,c);
c.complex:=tdefine;
c.LEXEMA:='define';
cargar(l,c);
end;
procedure cargar_tabla(var l:t_ts; lexema:string; var complex:tsimbgram);
var c:t_dato; encontrado:boolean;
begin
   encontrado:=false;
   primero(l);
   while not (fin(l)) and not(encontrado) do
   begin
   recuperar(l,c);
   if upcase(c.lexema)= upcase(lexema) then
   begin
   complex:=c.COMPLEX;
   encontrado:=true;
   end
   else siguiente(l);
   end;
   if encontrado=false then
   begin
   complex:=tid;
   c.lexema:=lexema;
   c.complex:=tid;
   cargar(l,c);
   end;
   end;
function identificador (var arch:t_arch; var control:longint; var lexema:string):boolean;
const
  q0=0;
  F=[3];
  type
    Q=0..3;
    Sigma=(letra,digito,gbajo,otro);
    tipodelta= array [Q,Sigma] of Q;
  var
    nuevo_control:longint;
    estadoactual:Q;
    delta:tipodelta;
    caracteracter:char;
    lexema_aux:string;

    Function caracterASimb(caracter:Char):Sigma;
Begin
  Case caracter of
    'a'..'z', 'A'..'Z':caracterASimb:=letra;
    '0'..'9' :caracterASimb:=digito;
    '_':caracterASimb:=gbajo
  else
   caracterASimb:=otro;
  End;
End;

begin
  lexema_aux:='';
  nuevo_control:=control;

  Delta[0,Letra]:=1;
  Delta[0,Digito]:=2;
  Delta[0,Otro]:=2;

  Delta[1,Letra]:=1;
  Delta[1,Digito]:=1;
  Delta[1,Otro]:=3;

  Delta[2,Letra]:=2;
  Delta[2,Digito]:=2;
  Delta[2,Otro]:=2;

  Delta[3,Letra]:=3;
  Delta[3,Digito]:=3;
  Delta[3,Otro]:=3;

  estadoactual:=q0;

  while not (Estadoactual in [2,3])do
         begin
          leer_caracter(arch,nuevo_control,caracteracter);
          EstadoActual:=Delta[EstadoActual,caracterASimb(caracteracter)];
  if Estadoactual=1 then
             begin
             lexema_aux:=lexema_aux+caracteracter;
             inc(nuevo_control);
             end;
         end;
  if (Estadoactual in F) then
     begin
      control:=nuevo_control;
      lexema:=lexema_aux;
     end;
  identificador:=Estadoactual in F;
  end;

Function constreal (var arch:t_arch; var control:longint; var lexema:string):boolean;
Const
  Q0=0;
  F=[3];
  Type
  Q=0..5;
    Sigma=(numero,coma ,otro);
    Tipodelta= array [Q,Sigma] of Q;
   Var
    Estadoactual:Q;
    Delta:tipodelta;
    Caracteracter:char;
    Nuevo_control:longint;
    Lexema_aux:string;

    Function caracterasimb(caracter:Char):Sigma;
Begin
  Case caracter of
    '0'..'9':caracterasimb:=numero;
    ',':caracterasimb:=coma;
  Else
   Caracterasimb:=otro;
  End;
End;
  Begin
  Lexema_aux:='';

  Delta[0,numero]:=1;
  Delta[0,coma]:=5;
  Delta[0,otro]:=5;

  Delta[1,numero]:=1;
  Delta[1,coma]:=4;
  Delta[1,otro]:=3;

  Delta[2,numero]:=1;
  Delta[2,coma]:=5;
  Delta[2,otro]:=5;

  Delta[3,numero]:=3;
  Delta[3,coma]:=3;
  Delta[3,otro]:=3;

  Delta[4,numero]:=6;
  Delta[4,coma]:=5;
  Delta[4,otro]:=5;

  Delta[5,numero]:=5;
  Delta[5,coma]:=5;
  Delta[5,otro]:=5;

 Delta[6,numero]:=6;
 Delta[6,coma]:=5;
 Delta[6,otro]:=3;

  Lexema_aux:='';
  Nuevo_control:=control;
  Estadoactual:=q0;
  While not (Estadoactual in [3,5])do
        Begin
          Leer_caracter(arch,nuevo_control,caracteracter);
          Estadoactual:=Delta[Estadoactual,caracterasimb(caracteracter)];
          If (estadoactual=1) or (Estadoactual=2)  or (Estadoactual=4) then
             Begin
             Lexema_aux:=lexema_aux+caracteracter;
             Inc(nuevo_control);
             End;
          End;
  If (Estadoactual in F) then
     Begin
      Control:=nuevo_control;
      Lexema:=lexema_aux;
     End;
  Constreal:=Estadoactual in F;
End;

Function EsSimboloEspecial(Var arch:T_Arch;Var Control:Longint; Var CompLex:tsimbgram;Var Lexema:String):boolean;
 var
   caracter: char;
begin
    EsSimboloEspecial := true;
    Leer_caracter(arch,Control,caracter);
    Case caracter of
      '(' :
        begin
             Lexema:= '(';
             CompLex:= tparentesisabre;
             Control:= Control+1;
        end;
       '.' :
        begin
             Lexema:= '.';
             CompLex:= tpunto;
             Control:= Control+1;
        end;
      ')' :
        begin
             Lexema:= ')';
             CompLex:= tparentesiscierra;
             Control:= Control+1;
        end;

      '>' :
        begin
             CompLex:= toprel;
             Control:= Control+1;
             Leer_caracter(arch,Control,caracter);
             If caracter = '=' then
             begin
                  Lexema := '>=';
                  Control:= Control+1;
             end
             else
                 Lexema := '>';
        end;

      '<' :
        begin
             CompLex:= toprel;
             Control:= Control+1;
             Leer_caracter(arch,Control,caracter);
             Case caracter of
              '=':
                   begin
                        Lexema := '<=';
                        Control:= Control+1;
                   end;
              '>':
                   begin
                        Lexema := '<>';
                        Control:= Control+1;
                   end;
              '<':
                   begin
                        lexema:='<<';
                        complex:=tasig;
                        control:=control+1;
                   end;
             else
                 Lexema := '<';

             end;
        end;

     '[':
         begin
              Lexema:='[';
              CompLex:= tcorchetea;
              Control:= Control + 1;
         end;
     '=':
         begin
              Lexema:='=';
              CompLex:= toprel;
              Control:= Control + 1;
         end;
      ']':
         begin
              Lexema:=']';
              CompLex:=tcorchetec;
              Control:=Control + 1;
         end;
      '|':
         begin
              Lexema:='|';
              CompLex:= tbarra;
              Control:=Control + 1;
         end;

     ':':
         begin
             Lexema:=':';
             CompLex:=tdospuntos;
             Control:= Control + 1;
         end;
     ',':
         begin
             Lexema:=',';
             CompLex:=tcoma;
             Control:= Control + 1;
         end;
     '+':
         begin
             Lexema:='+';
             CompLex:=tmas;
             Control:= Control + 1;
         end;
     '-':
         begin
             Lexema:='-';
             CompLex:=tmenos;
             Control:= Control + 1;
         end;
     '*':
         begin
             Lexema:='*';
             CompLex:=tpor;
             Control:= Control + 1;
         end;
     '/':
         begin
             Lexema:='/';
             CompLex:=tdividir;
             Control:= Control + 1;
         end;
     '^':
         begin
             Lexema:='^';
             CompLex:=tpotencia;
             Control:= Control + 1;
             end;

      else
       EsSimboloEspecial := false;
    end;
end;
Function cadena (var arch:t_arch; var control:longint; var lexema:string):boolean;
const
  q0=0;
  F=[5];
  V=[1,2,3];
type
    Q=0..5;
    Sigma=(comilla,Letra,Numero,Otro);
    tipodelta= array [Q,Sigma] of Q;
var
  nuevo_control:longint;
  lexema_aux:string;
  Estadoactual:Q;
  Delta:tipodelta;
  caracter:char;

  Function caracterASimb(caracter:Char):Sigma;
Begin
  Case caracter of
    'a'..'z','A'..'Z':caracterASimb:=letra;
    '0'..'9':caracterASimb:=numero;
    '"':caracterASimb:=comilla;
  else
   caracterASimb:=otro;
  End;
End;

Begin
   delta[0,comilla]:=1;
   delta[0,letra]:=4;
   delta[0,numero]:=4;
   delta[0,otro]:=4;

   delta[1,comilla]:=3;
   delta[1,letra]:=2;
   delta[1,numero]:=2;
   delta[1,otro]:=2;

   delta[2,comilla]:=3;
   delta[2,letra]:=2;
   delta[2,numero]:=2;
   delta[2,otro]:=2;

   delta[3,comilla]:=5;
   delta[3,letra]:=5;
   delta[3,numero]:=5;
   delta[3,otro]:=5;

   delta[4,comilla]:=4;
   delta[4,letra]:=4;
   delta[4,numero]:=4;
   delta[4,otro]:=4;

   delta[5,comilla]:=4;
   delta[5,letra]:=4;
   delta[5,numero]:=4;
   delta[5,otro]:=4;

  Lexema_aux:='';
  Estadoactual:=q0;
  nuevo_control:=control;

  While not (Estadoactual in [4,5]) do
  Begin
      leer_caracter(arch,nuevo_control,caracter);
      Estadoactual:=Delta[Estadoactual,caracterASimb(caracter)];
      If (Estadoactual in V) then
      Begin
           if caracter<>'"' then
        Lexema_aux:=Lexema_aux+caracter;
        inc(nuevo_control);
      End;
  End;
  If (Estadoactual in F) then
  Begin
    Control:= nuevo_control;
    Lexema:= Lexema_aux;
    cadena:=true;
  End
  Else
  cadena:=false;
end;
Procedure ObtenerSigCompLex (var arch:t_arch; var lexema:string; var complex:tsimbgram; var control:longint; var lista:t_ts);
var
 caracter:char;
begin
leer_caracter(arch,control,caracter);
while caracter in [#1..#32] do
 begin
   control:=control+1;
   leer_caracter(arch,control,caracter);
 end;
if caracter=#0 then complex:=pesos else
begin
if identificador(arch,control,lexema) then
       cargar_tabla(lista,lexema,complex)
     else
    if constreal(arch,control,lexema) then
    begin
      complex:=tConstReal;
    end
else
  if cadena(arch,control,lexema) then
   begin
        complex:=tCadena;
     end
else
  if not essimboloespecial(arch,control,complex,lexema) then
   begin
      complex:=error;
   end;
end;
end;

procedure analizador_lexico_prueba(var lista:t_ts; var arch:t_arch);
var
 lexema:string;
 complex:tsimbgram;
 control:longint;
 estado:boolean;
begin
lexema:='';
complex:=tid;
control:=0;
while not (complex in [pesos,error]) do
begin
  obtenersigcomplex(arch,lexema,complex,control,lista);
  writeln(control:8,':',complex,' - ',lexema);
end;
readln;
end;
end.


