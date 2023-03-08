program tema2;
type
    rango_anio=2000..2022;
    rango_notas=1..10;
    vector=array[1..10]of integer;
    alumno=record
        dni:integer;
        nombre:string;
        ingreso:rango_anio;
        nota:vector;
    end;
    lista=^nodo;
        nodo=record
            dato:alumno;
            sig:lista;
        end;
procedure leerDato(var d:alumno);
    var
     i:integer;aux:string;
    begin
        write('ingrese el dni del alumno:');
        readln(d.dni);
        write('ingrese el nombre del alumno:');
        readln(d.nombre);
        write('ingrese el año de ingreso a la facultad:');
        readln(d.ingreso);
        for i:=1 to 10 do begin
            writeln('indique si ha realizado la autoevaluacion numero',i ,'con si o no ');
                read(aux);
            if(aux='si')then begin
                write('ingrese la nota obtenida en la autoevaluacion numero ',i);
                readln(d.nota[i]) end
            else
                d.nota[i]:=-1;
        end
    end;
procedure agregar(var l:lista;d:alumno);
    var
        nue:lista;
    begin
        new(nue);
        nue^.dato:=d;
        nue^.sig:=l;
        l:=nue;
    end;
procedure cargarLista(var l:lista);
    var
        d:alumno;
    begin
        repeat
            leerDato(d);
            agregar(l,d);
        until (d.dni<>33016244);
    end;
function cumpleCondicion(aux:vector):boolean;
    var
        p,x,h:integer;
    begin
        x:=0;h:=0;
        for p:=1 to 10 do begin
            if(aux[p]<>-1)then begin 
                h:=h+1;
                if(aux[p]>=6)then
                    x:=x+1;
            end;
        end;
        if(h>=8)and(x>=4)then
            cumpleCondicion:=true
    end  ;
function todasPresetes(aux:vector):boolean;
    var i,c:integer;
    begin
        c:=0;
        for i:=1 to 10 do begin
            if(aux[i]<>-1)then
                c:=c+1;
        end;
        if(c=10)then
        todasPresetes:=true;
    
    end;
procedure moduloB(l:lista);
    var aux:vector;
        contador,z:integer;
        porcentaje,total:real;
        digitos,resto,par:integer;
    begin
        contador:=0;z:=0;
        while(l<>nil)do begin
            aux:=l^.dato.nota;
            z:=z+1;
            if(cumpleCondicion(aux))then
                write('el alumno con dni: ',l^.dato.dni,' puede rendir');
            if(l^.dato.ingreso=2020)then begin
                if(todasPresetes(aux))then
                    contador:=contador+1;
            end;
            digitos:=l^.dato.dni;
            par:=0;
            while(digitos<>0)do begin
                resto:=digitos mod 10 ;
                par:=par+resto;
            if(par mod 2 = 0)then
                write('el alumno con dni ',l^.dato.dni,' y nombre ', l^.dato.nombre,' tiene un dni cuya suma de sus digitos es par');
            end;    
        end;
        porcentaje:=100*contador;
        porcentaje:=porcentaje/z;
        write('el porcentaje de alumnos inscriptos en el 2020 que se presentaron a todas las autoevaluaciones es: ', porcentaje);
    end;
    
var
    l:lista;
begin
    l:=nil;
    cargarLista(l);{inciso A}
    moduloB(l);
end.
