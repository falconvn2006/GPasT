PROGRAM SortMonth(INPUT, OUTPUT);
USES DateIO;
VAR
  M1, M2: Month;
BEGIN
  ReadMonth(INPUT, M1);
  ReadMonth(INPUT, M2);
  IF (M1 = NoMonth) OR (M2 = NoMonth)
  THEN
    WRITELN('Некорректные данные')
  ELSE
    IF M1 = M2
    THEN
      BEGIN
        WRITELN('Месяцы одинаковые');
        WriteMonth(OUTPUT, M1)
      END
    ELSE
      BEGIN
        WriteMonth(OUTPUT, M1);
        IF M1 < M2
        THEN
          WRITE(' предшествует ')
        ELSE
          WRITE(' следует за ');
        WriteMonth(OUTPUT, M2)
      END;
  WRITELN
END.
