program aula02; // resolvendo funçao quadrática vs2.0

var
    a, b, c, x1, x2, tempdelta: real;
    
begin
    write('Entre com o "a": ');
    readln(a);

    while a <> 0 do
    begin
        write('Entre com o "b": ');
        readln(b);
        write('Entre com o "c": ');
        readln(c);
        writeln;

        tempdelta:= b*b-4*a*c; // delta

        if tempdelta >= 0 then
        begin
            x1:= (-b + sqrt(tempdelta))/(2*a); // bhaskara
            x2:= (-b - sqrt(tempdelta))/(2*a); // bhaskara

            writeln(#9 + 'x1 = ', x1:0:2); // x1
            writeln(#9 + 'x2 = ', x2:0:2); // x2
        end;

        writeln(#9 + 'Delta = ', tempdelta:0:2); // delta igual a...
        writeln;
        
        writeln('Para sair digite 0.'+ #9);
        writeln;

        write('Entre com o "a": ');
        readln(a);
    end;

    writeln('Fim.')
end.