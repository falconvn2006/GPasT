program aula03; // função quadrática com código inteligente vs3.0

var
    a, b, c, x1, x2, delta: real;
    
function getDelta(a, b, c: real): real; // delta
    begin
        getDelta:= b*b-4*a*c;
    end;

function  getX1(a, b, delta: real): real; // bhaskara
    begin
        getX1:= (-b + sqrt(delta))/(2*a);
    end;

function  getX2(a, b, delta: real): real; // bhaskara
    begin
        getX2:= (-b - sqrt(delta))/(2*a);
    end;

begin // início do programa
    write('Entre com o "a": ');
    readln(a);

    while a <> 0 do
    begin
        write('Entre com o "b": ');
        readln(b);
        write('Entre com o "c": ');
        readln(c);
        writeln;

        delta:= getDelta(a, b, c);
        
        if delta >= 0 then
            begin
                x1:= getX1 (a, b, delta);
                x2:= getX2 (a, b, delta);

                writeln(#9 + 'X1 = ', x1:0:2);
                writeln(#9 + 'X2 = ', x2:0:2);
            end;
        
        writeln(#9 + 'Delta = ', delta:0:2);
        writeln;
        
        writeln('Para sair digite 0.'+ #9);
        writeln;
        
        write('Entre com o "a": ');
        readln(a);
    end; 

    writeln('Fim.');
end.