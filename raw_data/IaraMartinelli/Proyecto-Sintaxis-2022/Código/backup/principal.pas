unit principal;

interface
uses
crt,u_evaluador, analizador_lexico, base, u_Analizador_sintactico;
const
Menu_color=black;
Color_Menu=white;
n=20;
var
arch:t_arch;
  Procedure BorrarPantalla;
  Procedure marco(n:cardinal);
  procedure Menu_Principal;
implementation
Procedure marco(n:cardinal);
var
i:cardinal;
  Begin
  gotoxy(25,3);
  write(' _________________________');
  gotoxy(60,4);
  write('Bogado, Dodera, Gómez, Martinelli');
  for i:=1 to n do
  begin
  gotoxy(25,3+i);
  write('|');
  gotoxy(97,3+i);
  write('|');
  end;
  gotoxy(25,4+i);
  write('|_________________________|');
  End;
procedure BorrarPantalla;
  begin
  TextBackground(menu_color);
  Textcolor(COLOR_MENU);
  clrscr;
  end;
procedure menu_principal;
var
  opcion:cardinal;
  arch:t_arch;
  arbol:t_arbol;
  estado:est;
  lista1:t_ts;
  listaestado:t_estado;
begin
abrir(arch,'C:\Proyecto integrador\EjemploPromedioVarianza.txt');    //Elegir alguno de los ejemplos disponibles en la carpeta
repeat
clrscr;
gotoxy(45,7);
writeln('<<|-----------MENU-----------|>>');
gotoxy(28,10);
writeln('Opcion 1- ANALIZADOR LEXICO');
gotoxy(28,13);
writeln('Opcion 2-ARBOL DE DERIVACION');
gotoxy(28,16);
writeln('Opcion 0- SALIR');
gotoxy(55,19);
writeln('INGRESE OPCION:');
marco(18);
gotoxy(70,19);
readln(opcion);
case opcion of
1: begin BorrarPantalla();
cargarPalabrasReservadas(lista1);
analizador_lexico_prueba(lista1,arch);
end;
2: begin BorrarPantalla();
Analizador_Sintactico(arch,arbol,estado);
If estado=exito then
Begin
  evaluador(arbol);
  writeln('EL PROGRAMA FINALIZO');
  readln;
End
else WriteLn('ERROR SINTÁCTICO');
end;
END;
until opcion=0;
close (arch);
end;
end.
