program exercicio01; // resolvendo funções afim vs1.0

var
    a, b, x: real;

function getX(a, b: real): real; // f(x)= ax + b = 0 -> x = -b / a
begin
    getX:= -b/a;
end;

begin // início do programa
    write('Entre com o a: '); //coeficiente angular
    readln(a);
 
    while a <> 0 do
    begin
        write('Entre com o b: '); // coeficiente linear
        readln(b);

        x:= getX(a, b);
        writeln;

        writeln(#9 + 'x = ', x:0:2);
        writeln;

        writeln('Para sair digite 0.');
        writeln;
        
        write('Entre com o a: '); //coeficiente angular
        readln(a);
    end;

    write(#9 + 'Fim.');
end.