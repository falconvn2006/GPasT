PROGRAM SortMonth(INPUT, OUTPUT);
USES DateIO;
VAR
  M1, M2: Month;
BEGIN
  ReadMonth(INPUT, M1);
  WriteMonth(OUTPUT, M1)
END.
