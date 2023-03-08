UNIT Queue;
INTERFACE
PROCEDURE EmptyQ;
PROCEDURE AddQ(VAR Elt: CHAR); {Ставим Elt в очередь}
PROCEDURE DelQ; {Удалить первого в очереди}
PROCEDURE HeadQ(VAR Elt: CHAR); {Кто первый в очереди?}
PROCEDURE WriteQ;
IMPLEMENTATION
VAR
  Q, Temp: TEXT;

PROCEDURE CopyOpen(VAR F1, F2 :TEXT);
 {Копирует строку из F1 в F2 без RESET или REWRITE;
  таким образом F1 должен быть готов для чтения,а F2 для записи,
  но прошлые строки у этих файлов могут быть не пусты }
VAR
  Ch: CHAR;
BEGIN {CopyOpen}
  WHILE NOT EOLN(F1)
  DO
    BEGIN
      READ(F1, Ch);
      WRITE(F2, Ch)
    END
END; {CopyOpen}

PROCEDURE EmptyQ;
{Q := <,/,R>}
BEGIN {EmptyQ}
  REWRITE(Q);
  WRITELN(Q);
  RESET(Q)
END; {EmptyQ}

PROCEDURE AddQ(VAR Elt: CHAR);
  {Q = <,x/,R>,где x строка И Elt = a -->
   Q = <,xa/,R> }
BEGIN {AddQ}
  REWRITE(Temp);
  RESET(Q);
  CopyOpen(Q, Temp);
  WRITELN(Temp, Elt);
  REWRITE(Q);
  RESET(Temp)
  CopyOpen(Temp, Q);
  RESET(Temp);
  REWRITE(Q);
  CopyOpen(Temp, Q);
  WRITELN(Q);
  RESET(Q)
END; {AddQ}

PROCEDURE DelQ;
  {(Q = <,/,R> -->)|
   (Q = <,ax/,R>,где a символ и x строка  -->
     Q:= <,x/,R> }
VAR
  Ch: CHAR;
BEGIN {DelQ}
  {удаляем первый элемент из Q};
  READ(Q, Ch);
  IF NOT EOF(Q)
  THEN {не пустой}
    BEGIN
      REWRITE(Temp);
      RESET(Q);
      CopyOpen(Q, Temp);
      WRITELN(Temp);
      {копируем Temp в Q}
      RESET(Temp);
      REWRITE(Q);
      CopyOpen(Temp, Q);
      WRITELN(Q)
    END;
  RESET(Q)
END {DelQ};

PROCEDURE HeadQ(VAR Elt: CHAR);
  {(Q = <,/,R> --> Elt := '#')|
   (Q = <,ax/,R>,где a символ и x строка  -->
     Elt:= 'a' }
BEGIN  {HeadQ}
  IF NOT EOLN(Q)
  THEN
    READ(Q, Elt)
  ELSE
    Elt := '#';
  RESET(Q)
END; {HeadQ}

PROCEDURE WriteQ;
  { (Q = <,x/,R> и OUTPUT =<y,,W>,где y и x строка  -->
     OUTPUT := <y&x/,,W> }
BEGIN {WriteQ}
  RESET(Q);
  CopyOpen(Q, OUTPUT);
  WRITELN(OUTPUT);
  RESET(Q)
END; {WriteQ}

BEGIN
END.

