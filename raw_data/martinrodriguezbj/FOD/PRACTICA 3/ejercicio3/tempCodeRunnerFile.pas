reset(mae);
    while not eof(mae)do begin
      read(mae,n);
      writeln('cod: ',n.cod);
    end;