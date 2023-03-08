program aula01; // função quadrática com a, b, c definido vs1.0

uses
    crt, math; //bibliotecas

var
    a, b, c, delta, x1, x2: real;
    tempx1, tempx2, tempdelta: string;

begin
    writeln('Função quadrática');

    a:= 1;
    b:= -2;
    c:= 3;

    delta:= b*b-4*a*c; // delta

    if delta >= 0 then
    begin
        x1:= (-b + sqrt(delta))/(2*a); // bhaskara
        x2:= (-b - sqrt(delta))/(2*a); // bhaskara

        str(x1, tempx1);
        str(x2, tempx2);

        writeln('x1 = ' + tempx1);
        writeln('x1 = ' + tempx2);
    end
    else
    begin
        str(delta, tempdelta);
        writeln('Sorry! Delta = ' + tempdelta);
    end;

    writeln('Fim.');
end.