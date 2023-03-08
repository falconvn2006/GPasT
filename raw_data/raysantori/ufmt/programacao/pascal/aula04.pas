program aula04; // vetor vs1.0

var
  vetor: array[0..4] of integer; // quantidade de coordenadas/elementos do índice 
  index, max: integer;
  info: char;
  
begin // início do programa
  info:= 'y';
  
  while (info = 'y') do
  begin
    for index:= 0 to 4 do
    begin
      write('Entre com vetor[', index,']:');
      readln(vetor[index]);
    end;
  
    max:= vetor[0];
  
    for index:= 1 to 4 do // repetição de x até y
    begin
      if vetor[index] > max then
      begin
        max:= vetor[index]; // valor máximo 
      end;  
    end;
    
    writeln; writeln('Máximo = ', max,'.');
    writeln; writeln('Digite y para continuar.');
    readln(info);
    writeln;
  end; // fim do while
  
  writeln;
  writeln('Fim.');
  readln;
end.