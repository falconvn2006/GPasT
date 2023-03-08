program exercicio03; // resolvendo uma função afim pelo valor de dois pontos

var
    a, b, x1, x2, y1, y2: real;
    info: char;

function getA(x1, x2, y1, y2:real):real;
begin
    getA:= (y2-y1)/(x2-x1); // coeficiente angular
end;

function getB(x1, x2, y1, y2:real):real;
begin
    getB:= (y1*x2-y2*x1)/(x2-x1); // coeficiente linear
end;

begin // principal
    info:= 'y';

    while (info = 'y') do
    begin
        // (x1, y1)
        write('Entre com x1: ');
        read(x1);
        write('Entre com y1: ');
        read(y1);
        // (x2, y2)
        write('Entre com x2: ');
        read(x2);
        write('Entre com y2: ');
        readln(y2);

        a:= getA(x1, x2, y1, y2); // coeficiente angular
        b:= getB(x1, x2, y1, y2); // coeficiente linear

        writeln;
        writeln(#9, 'a = ', a:0:2); // coeficiente angular
        writeln(#9, 'b = ', b:0:2); // coeficiente linear
        writeln(#9, 'f(x) = ', a:0:2,'x + ', b:0:2); // função afim y = ax + b
        writeln;

        writeln('Digite y para continuar.');
        readln(info);
        writeln;
    end;

    write('Fim.')
end.