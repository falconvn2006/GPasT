program OFFICIAL;

USES
    CRT;

TYPE


TSubrango5 = 1..5;
TSubrango6 = 1..6;
TSubrango7 = 1..7;

T1 = RECORD
    original : integer;
    calculos : integer;
    colores : integer;
end;

T2 = RECORD
    color : integer;
    sumatorio : integer;
end;

Ttipo = RECORD
    nombre : string [40];
    puntuacion : integer;
END;

TRanking = ARRAY [1..60] OF Ttipo;
tfichero = FILE OF Ttipo;

TTablero1 = array [TSubrango5,TSubrango5] OF T1;
TBordesH1 = array [TSubrango5] OF T2;
TBordesV1 = array [TSubrango5] OF T2;

TTablero2 = array [TSubrango6,TSubrango6] OF T1;
TBordesH2 = array [TSubrango6] OF T2;
TBordesV2 = array [TSubrango6] OF T2;

TTablero3 = array [TSubrango7,TSubrango7] OF T1;
TBordesH3 = array [TSubrango7] OF T2;
TBordesV3 = array [TSubrango7] OF T2;

CONST
CINCO = 5;
SEIS = 6;
SIETE = 7;

VAR
tablero1:TTablero1;
bordeshorizontal1:TBordesH1;
bordesverticales1:TBordesV1;

tablero2:TTablero2;
bordeshorizontal2:TBordesH2;
bordesverticales2:TBordesV2;

tablero3:TTablero3;
bordeshorizontal3:TBordesH3;
bordesverticales3:TBordesV3;

x,y,salir,salir1,i,j,contador:integer;

Ranking:TRanking;

F : tfichero;

PROCEDURE RellenarNumeros (y,x:integer; VAR tablero1:TTablero1; VAR horizonal1:TBordesH1; VAR vertical1:TBordesV1;
VAR tablero2:TTablero2;VAR horizonal2:TBordesH2;VAR vertical2:TBordesV2;
VAR tablero3:TTablero3;VAR horizonal3:TBordesH3;VAR vertical3:TBordesV3);

CONST
RANGOMIN = 1;
OPCION1 = 9;
OPCION2 = 19;
VAR
i,j,aux,aux1,aux2,aux3: integer;

BEGIN
randomize;
case y of

    1 : BEGIN

        case x OF

            1: BEGIN
                    FOR i:=RANGOMIN TO CINCO DO
                        FOR j:=RANGOMIN TO CINCO DO begin
                            tablero1[i,j].original := (random(OPCION1) + RANGOMIN);
                            tablero1[i,j].calculos := tablero1[i,j].original;
                            tablero1[i,j].colores  := 1;
                            end;

                        if (random(2) = 1) THEN begin
                            FOR aux := RANGOMIN TO CINCO DO begin
                            tablero1[aux,aux].calculos := 0;
                            end;
                        end else BEGIN
                            FOR aux := RANGOMIN TO CINCO DO
                        tablero1[aux,6-aux].calculos := 0;
                            end;

                            FOR i := RANGOMIN TO CINCO DO begin
                        aux3:= 0;

                        repeat

                        aux := 0;
                        aux1:=0;
                        aux2:=0;
                        repeat
                            aux := aux + 1;
                            aux1 := (tablero1[i,aux].calculos + aux1);
                        until (aux = CINCO);

                        aux := 0;

                        repeat
                            aux := aux + 1;
                            aux2 := (tablero1[aux,i].calculos + aux2);
                        until (aux = CINCO);

                        if ((aux1 > 10) AND (aux2 > 10)) THEN BEGIN
                            REPEAT
                            aux := (random(CINCO)+1);
                            until (tablero1[aux,i].calculos > 0);
                            tablero1[aux,i].calculos := 0;
                            aux3 := aux3 + 1;
                        end
                            else
                        aux3 := 1;
                            until (aux3 = 1);
                    end; //for

                    FOR i := RANGOMIN TO CINCO DO begin
                        aux := 0;
                        repeat
                            aux := aux + 1;
                            vertical1[i].sumatorio := (tablero1[i,aux].calculos + vertical1[i].sumatorio);
                        until (aux = CINCO);
                        vertical1[i].color := 0;
                    end;

                    FOR i := RANGOMIN TO CINCO DO begin
                        aux := 0;
                        repeat
                            aux := aux + 1;
                            horizonal1[i].sumatorio := (tablero1[aux,i].calculos + horizonal1[i].sumatorio);
                        until (aux = CINCO);
                        horizonal1[i].color := 0;
                    end; //for
                end; //1

            2: BEGIN
                    FOR i:=RANGOMIN TO SEIS DO
                        FOR j:=RANGOMIN TO SEIS DO begin
                            tablero2[i,j].original := (random(OPCION1) + RANGOMIN);
                            tablero2[i,j].calculos := tablero2[i,j].original ;
                            tablero2[i,j].colores := 1;
                            end;

                             if (random(2) = 1) THEN begin
                            FOR aux := RANGOMIN TO SEIS DO begin
                            tablero2[aux,aux].calculos := 0;
                            end;
                        end else BEGIN
                            FOR aux := RANGOMIN TO SEIS DO
                        tablero2[aux,7-aux].calculos := 0;
                            end;



                            FOR i := RANGOMIN TO SEIS DO begin
                        aux3:= 0;

                        repeat

                        aux := 0;
                        aux1:=0;
                        aux2:=0;
                        repeat
                            aux := aux + 1;
                            aux1 := (tablero2[i,aux].calculos + aux1);
                        until (aux = SEIS);

                        aux := 0;

                        repeat
                            aux := aux + 1;
                            aux2 := (tablero2[aux,i].calculos + aux2);
                        until (aux = SEIS);

                        if ((aux1 > 10) AND (aux2 > 10)) THEN BEGIN
                            REPEAT
                            aux := (random(SEIS)+1);
                            until (tablero2[aux,i].calculos > 0);
                            tablero2[aux,i].calculos := 0;
                            aux3 := aux3 + 1;
                        end
                            else
                        aux3 := 1;

                        until (aux3 = 1);
                    end; //for

                       FOR i := RANGOMIN TO SEIS DO begin
                        aux := 0;
                        repeat
                            aux := aux + 1;
                            vertical2[i].sumatorio := (tablero2[i,aux].calculos + vertical2[i].sumatorio);
                        until (aux = 6);
                        vertical2[i].color := 0;
                        end; //for

                    FOR i := RANGOMIN TO SEIS DO begin
                        aux := 0;
                        repeat
                            aux := aux + 1;
                            horizonal2[i].sumatorio := (tablero2[aux,i].calculos + horizonal2[i].sumatorio);
                        until (aux = 6);
                        horizonal2[i].color := 0;
                        end;//for
                 end; //2

            3: BEGIN
                    FOR i:=RANGOMIN TO SIETE DO
                        FOR j:=RANGOMIN TO SIETE DO BEGIN
                            tablero3[i,j].original := (random(OPCION1) + RANGOMIN);
                            tablero3[i,j].calculos := tablero3[i,j].original;
                            tablero3[i,j].colores := 1;
                            end;

                          if (random(2) = 1) THEN begin
                            FOR aux := RANGOMIN TO SIETE DO begin
                            tablero3[aux,aux].calculos := 0;
                            end;
                        end else BEGIN
                            FOR aux := RANGOMIN TO SIETE DO
                        tablero3[aux,8-aux].calculos := 0;
                            end;

                        FOR i := RANGOMIN TO SIETE DO begin
                        aux3:= 0;

                        repeat

                        aux := 0;
                        aux1:=0;
                        aux2:=0;
                        repeat
                            aux := aux + 1;
                            aux1 := (tablero3[i,aux].calculos + aux1);
                        until (aux = SIETE);

                        aux := 0;

                        repeat
                            aux := aux + 1;
                            aux2 := (tablero3[aux,i].calculos + aux2);
                        until (aux = SIETE);

                        if ((aux1 > 10) AND (aux2 > 10)) THEN BEGIN
                            REPEAT
                            aux := (random(SIETE)+1);
                            until (tablero3[aux,i].calculos > 0);
                            tablero3[aux,i].calculos := 0;
                            aux3 := aux3 + 1;
                        end
                            else
                        aux3 := 1;

                        until (aux3 = 1);
                    end; //for

                    FOR i := RANGOMIN TO SIETE DO begin
                        aux := 0;
                        repeat
                            aux := aux + 1;
                            vertical3[i].sumatorio := (tablero3[i,aux].calculos + vertical3[i].sumatorio);
                        until (aux = 7);
                        vertical3[i].color := 0;
                        end; //for

                    FOR i := RANGOMIN TO SIETE DO begin
                        aux := 0;
                        repeat
                            aux := aux + 1;
                            horizonal3[i].sumatorio := (tablero3[aux,i].calculos + horizonal3[i].sumatorio);
                        until (aux = 7);
                        horizonal3[i].color := 0;
                end;
            end;
        end;
    END;

    2 : BEGIN

    CASE x OF

            1: BEGIN
                    FOR i:=RANGOMIN TO CINCO DO
                        FOR j:=RANGOMIN TO CINCO DO BEGIN
                            tablero1[i,j].original := (random(OPCION2) + RANGOMIN);
                            tablero1[i,j].calculos := tablero1[i,j].original ;
                            tablero1[i,j].colores := 1;
                            end;


                        if (random(2) = 1) THEN begin
                            FOR aux := RANGOMIN TO CINCO DO begin
                            tablero1[aux,aux].calculos := 0;
                            end;
                        end else BEGIN
                            FOR aux := RANGOMIN TO CINCO DO
                        tablero1[aux,6-aux].calculos := 0;
                            end;


                    FOR i := RANGOMIN TO CINCO DO begin
                        aux3:= 0;

                        repeat

                        aux := 0;
                        aux1:=0;
                        aux2:=0;

                        repeat
                            aux := aux + 1;
                            aux1 := (tablero1[i,aux].calculos + aux1);
                        until (aux = CINCO);

                        aux := 0;

                        repeat
                            aux := aux + 1;
                            aux2 := (tablero1[aux,i].calculos + aux2);
                        until (aux = CINCO);

                        if ((aux1 > 20) AND (aux2 > 20)) THEN BEGIN
                            REPEAT
                            aux := (random(CINCO)+1);
                            until (tablero1[aux,i].calculos > 0);
                            tablero1[aux,i].calculos := 0;
                            aux3 := aux3 + 1;
                        end
                            else
                        aux3 := 1;

                        until (aux3 = 1);
                    end; //for


                    FOR i := RANGOMIN TO CINCO DO begin
                        aux := 0;
                        repeat
                            aux := aux + 1;
                            vertical1[i].sumatorio := (tablero1[i,aux].calculos + vertical1[i].sumatorio);
                        until (aux = 5);
                        vertical1[i].color := 0;
                        end;

                    FOR i := RANGOMIN TO CINCO DO begin
                        aux := 0;
                        repeat
                            aux := aux + 1;
                            horizonal1[i].sumatorio := (tablero1[aux,i].calculos + horizonal1[i].sumatorio);
                        until (aux = 5);
                        horizonal1[i].color := 0;
                    end; //for
                end;//1

            2: BEGIN
                     FOR i:=RANGOMIN TO SEIS DO
                        FOR j:=RANGOMIN TO SEIS DO BEGIN
                            tablero2[i,j].original := (random(OPCION2) + RANGOMIN);
                            tablero2[i,j].calculos := tablero2[i,j].original ;
                            tablero2[i,j].colores := 1;
                            end;

                                   if (random(2) = 1) THEN begin
                            FOR aux := RANGOMIN TO SEIS DO begin
                            tablero2[aux,aux].calculos := 0;
                            end;
                        end else BEGIN
                            FOR aux := RANGOMIN TO SEIS DO
                        tablero2[aux,7-aux].calculos := 0;
                            end;

                      FOR i := RANGOMIN TO SEIS DO begin
                        aux3:= 0;
                            repeat
                        aux := 0;
                        aux1:=0;
                        aux2:=0;
                        repeat
                            aux := aux + 1;
                            aux1 := (tablero2[i,aux].calculos + aux1);
                        until (aux = SEIS);
                        aux := 0;
                        repeat
                            aux := aux + 1;
                            aux2 := (tablero2[aux,i].calculos + aux2);
                        until (aux = SEIS);

                        if ((aux1 > 20) AND (aux2 > 20)) THEN BEGIN
                            REPEAT
                            aux := (random(SEIS)+1);
                            until (tablero2[aux,i].calculos > 0);
                            tablero2[aux,i].calculos := 0;
                            aux3 := aux3 + 1;
                        end
                            else
                        aux3 := 1;

                        until (aux3 = 1);
                    end; //for

                    FOR i := RANGOMIN TO SEIS DO begin
                        aux := 0;
                        repeat
                            aux := aux + 1;
                            vertical2[i].sumatorio := (tablero2[i,aux].calculos + vertical2[i].sumatorio);
                        until (aux = 6);
                        vertical2[i].color := 0;
                    end;//for
                        FOR i := RANGOMIN TO SEIS DO begin
                        aux := 0;
                        repeat
                            aux := aux + 1;
                            horizonal2[i].sumatorio := (tablero2[aux,i].calculos + horizonal2[i].sumatorio);
                        until (aux = 6);
                    horizonal2[i].color := 0;
                    end; //for
                end; //2

            3: BEGIN
                     FOR i:=RANGOMIN TO SIETE DO  begin
                        FOR j:=RANGOMIN TO SIETE DO BEGIN
                            tablero3[i,j].original := (random(OPCION2) + RANGOMIN);
                            tablero3[i,j].calculos := tablero3[i,j].original;
                            tablero3[i,j].colores := 1;
                            end;
                        end;

                          if (random(2) = 1) THEN begin
                            FOR aux := RANGOMIN TO SIETE DO begin
                            tablero3[aux,aux].calculos := 0;
                            end;
                        end else BEGIN
                            FOR aux := RANGOMIN TO SIETE DO
                        tablero3[aux,8-aux].calculos := 0;
                            end;

                        FOR i := RANGOMIN TO SIETE DO begin
                        aux3:= 0;

                        repeat

                        aux := 0;
                        aux1:=0;
                        aux2:=0;
                        repeat
                            aux := aux + 1;
                            aux1 := (tablero3[i,aux].calculos + aux1);
                        until (aux = SIETE);

                        aux := 0;

                        repeat
                            aux := aux + 1;
                            aux2 := (tablero3[aux,i].calculos + aux2);
                        until (aux = SIETE);

                        if ((aux1 > 20) AND (aux2 > 20)) THEN BEGIN
                            REPEAT
                            aux := (random(SIETE)+1);
                            until (tablero3[aux,i].calculos > 0);
                            tablero3[aux,i].calculos := 0;
                            aux3 := aux3 + 1;
                        end
                            else
                        aux3 := 1;
                        until (aux3 = 1);
                    end; //for

                    FOR i := RANGOMIN TO SIETE DO begin
                        aux := 0;
                            repeat
                                aux := aux + 1;
                                vertical3[i].sumatorio := (tablero3[i,aux].calculos + vertical3[i].sumatorio);
                            until (aux = 7);
                    vertical3[i].color := 0;
                    end;//for

                    FOR i := RANGOMIN TO SIETE DO begin
                        aux := 0;
                        repeat
                            aux := aux + 1;
                            horizonal3[i].sumatorio := (tablero3[aux,i].calculos + horizonal3[i].sumatorio);
                        until (aux = 7);
                        horizonal3[i].color := 0;
                    end; //for
                end;//3
            end; //case of
        end; //2 PRINCIPAL
    end; //case of grande
end; //procedure



PROCEDURE MostrarTablero (x:integer;
tablero1:TTablero1;horizonal1:TBordesH1;vertical1:TBordesV1;
tablero2:TTablero2;horizonal2:TBordesH2;vertical2:TBordesV2;
tablero3:TTablero3;horizonal3:TBordesH3;vertical3:TBordesV3);

CONST
RANGOMIN = 1;

VAR
i,j: integer;

BEGIN
    write ('     ');
    case x of

        1: BEGIN

            FOR i := RANGOMIN TO 5 DO BEGIN

                if (horizonal1[i].color = 1) THEN BEGIN
                    if (horizonal1[i].sumatorio < 10) THEN BEGIN
                        TextBackground(yellow);
                        write ('0',horizonal1[i].sumatorio);
                        TextBackground(black);
                        write(' ');
                                END
                            ELSE BEGIN
                            TextBackground(yellow);
                            write (horizonal1[i].sumatorio);
                            TextBackground(black);
                            write(' ');
                            END;
                        END; //IF COLOR

                    if (horizonal1[i].color = 0) THEN BEGIN
                if (horizonal1[i].sumatorio < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',horizonal1[i].sumatorio,' ');
                            END
                                ELSE
                                    write (horizonal1[i].sumatorio,' ');
                                end;
                        END;//FOR

                writeln('');
                writeln('     -- -- -- -- --');


            FOR i := RANGOMIN TO 5 DO BEGIN

                if (vertical1[i].color = 1) THEN BEGIN
                    if (vertical1[i].sumatorio < 10) THEN BEGIN
                        TextBackground(yellow);
                        write ('0',vertical1[i].sumatorio);
                        TextBackground(black);
                        write(' ');
                                END
                            ELSE BEGIN
                            TextBackground(yellow);
                            write (vertical1[i].sumatorio);
                            TextBackground(black);
                            write(' ');
                            END;
                        END; //IF COLOR

                    if (vertical1[i].color = 0) THEN BEGIN
                if (vertical1[i].sumatorio < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',vertical1[i].sumatorio,' ');
                            END
                                ELSE
                                    write (vertical1[i].sumatorio,' ');
                                end;
                         write('| ');

                        FOR j := RANGOMIN TO 5 DO BEGIN
                             if (tablero1[i,j].colores = 1) THEN BEGIN
                    if (tablero1[i,j].original < 10) THEN BEGIN
                        TextBackground(red);
                        write ('0',tablero1[i,j].original);
                        TextBackground(black);
                        write(' ');
                                END
                            ELSE BEGIN
                                TextBackground(red);
                                write (tablero1[i,j].original);
                                TextBackground(black);
                                write(' ');
                            END;
                        END; //IF COLOR

                    if (tablero1[i,j].colores = 0) THEN BEGIN
                if (tablero1[i,j].original < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',tablero1[i,j].original,' ');
                            END
                                ELSE
                                    write (tablero1[i,j].original,' ');
                                end;

                        end; //for amarillo rojo amarillo


                 write('| ');

                if (vertical1[i].color = 1) THEN BEGIN
                    if (vertical1[i].sumatorio < 10) THEN BEGIN
                        TextBackground(yellow);
                        write ('0',vertical1[i].sumatorio);
                        TextBackground(black);
                        write(' ');
                                END
                            ELSE BEGIN
                            TextBackground(yellow);
                            write (vertical1[i].sumatorio);
                            TextBackground(black);
                            write(' ');
                            END;
                        END; //IF COLOR

                    if (vertical1[i].color = 0) THEN BEGIN
                if (vertical1[i].sumatorio < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',vertical1[i].sumatorio,' ');
                            END
                                ELSE
                                    write (vertical1[i].sumatorio,' ');
                                end;
                writeln('');
            END;//FOR


                writeln('     -- -- -- -- --');
                write ('     ');
             FOR i := RANGOMIN TO 5 DO BEGIN


             if (horizonal1[i].color = 1) THEN BEGIN
                    if (horizonal1[i].sumatorio < 10) THEN BEGIN
                        TextBackground(yellow);
                        write ('0',horizonal1[i].sumatorio);
                        TextBackground(black);
                        write(' ');
                                END
                            ELSE BEGIN
                            TextBackground(yellow);
                            write (horizonal1[i].sumatorio);
                            TextBackground(black);
                            write(' ');
                            END;
                        END; //IF COLOR

                    if (horizonal1[i].color = 0) THEN BEGIN
                if (horizonal1[i].sumatorio < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',horizonal1[i].sumatorio,' ');
                            END
                                ELSE
                                    write (horizonal1[i].sumatorio,' ');
                                end;
            END;//FOR PRINCIPAL
        END;//BEGIN


        2: BEGIN

            FOR i := RANGOMIN TO SEIS DO BEGIN
                if (horizonal2[i].color = 1) THEN BEGIN
                    if (horizonal2[i].sumatorio < 10) THEN BEGIN
                        TextBackground(yellow);
                        write ('0',horizonal2[i].sumatorio);
                        TextBackground(black);
                        write(' ');
                                END
                            ELSE BEGIN
                            TextBackground(yellow);
                            write (horizonal2[i].sumatorio);
                            TextBackground(black);
                            write(' ');
                            END;
                        END; //IF COLOR
                    if (horizonal2[i].color = 0) THEN BEGIN
                if (horizonal2[i].sumatorio < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',horizonal2[i].sumatorio,' ');
                            END
                                ELSE
                                    write (horizonal2[i].sumatorio,' ');
                                end;
                        END;//FOR
                writeln('');
                writeln('     -- -- -- -- -- --');
            FOR i := RANGOMIN TO SEIS DO BEGIN
                if (vertical2[i].color = 1) THEN BEGIN
                    if (vertical2[i].sumatorio < 10) THEN BEGIN
                        TextBackground(yellow);
                        write ('0',vertical2[i].sumatorio);
                        TextBackground(black);
                        write(' ');
                        END
                            ELSE BEGIN
                            TextBackground(yellow);
                            write (vertical2[i].sumatorio);
                            TextBackground(black);
                            write(' ');
                            END;
                        END; //IF COLOR
                    if (vertical2[i].color = 0) THEN BEGIN
                if (vertical2[i].sumatorio < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',vertical2[i].sumatorio,' ');
                            END
                                ELSE
                                    write (vertical2[i].sumatorio,' ');
                                end;
                         write('| ');
                    FOR j := RANGOMIN TO SEIS DO BEGIN
                             if (tablero2[i,j].colores = 1) THEN BEGIN
                    if (tablero2[i,j].original < 10) THEN BEGIN
                        TextBackground(red);
                        write ('0',tablero2[i,j].original);
                        TextBackground(black);
                        write(' ');
                                END
                            ELSE BEGIN
                                TextBackground(red);
                                write (tablero2[i,j].original);
                                TextBackground(black);
                                write(' ');
                            END;
                        END; //IF COLOR
                    if (tablero2[i,j].colores = 0) THEN BEGIN
                if (tablero2[i,j].original < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',tablero2[i,j].original,' ');
                            END
                                ELSE
                                    write (tablero2[i,j].original,' ');
                                end;
                            end; //for amarillo rojo amarillo
                write('| ');
                if (vertical2[i].color = 1) THEN BEGIN
                    if (vertical2[i].sumatorio < 10) THEN BEGIN
                        TextBackground(yellow);
                        write ('0',vertical2[i].sumatorio);
                        TextBackground(black);
                        write(' ');
                        END
                            ELSE BEGIN
                            TextBackground(yellow);
                            write (vertical2[i].sumatorio);
                            TextBackground(black);
                            write(' ');
                            END;
                        END; //IF COLOR
                    if (vertical2[i].color = 0) THEN BEGIN
                if (vertical2[i].sumatorio < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',vertical2[i].sumatorio,' ');
                            END
                                ELSE
                                    write (vertical2[i].sumatorio,' ');
                                end;
                writeln('');
            END;//FOR
                writeln('     -- -- -- -- -- --');
                write ('     ');
             FOR i := RANGOMIN TO SEIS DO BEGIN
        if (horizonal2[i].color = 1) THEN BEGIN
                    if (horizonal2[i].sumatorio < 10) THEN BEGIN
                        TextBackground(yellow);
                        write ('0',horizonal2[i].sumatorio);
                        TextBackground(black);
                        write(' ');
                        END
                            ELSE BEGIN
                            TextBackground(yellow);
                            write (horizonal2[i].sumatorio);
                            TextBackground(black);
                            write(' ');
                            END;
                        END; //IF COLOR
                    if (horizonal2[i].color = 0) THEN BEGIN
                if (horizonal2[i].sumatorio < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',horizonal2[i].sumatorio,' ');
                            END
                                ELSE
                                    write (horizonal2[i].sumatorio,' ');
                end;
            END;//FOR PRINCIPAL
        END;//BEGIN


        3: BEGIN

            FOR i := RANGOMIN TO SIETE DO BEGIN
                if (horizonal3[i].color = 1) THEN BEGIN
                    if (horizonal3[i].sumatorio < 10) THEN BEGIN
                        TextBackground(yellow);
                        write ('0',horizonal3[i].sumatorio);
                        TextBackground(black);
                        write(' ');
                                END
                            ELSE BEGIN
                            TextBackground(yellow);
                            write (horizonal3[i].sumatorio);
                            TextBackground(black);
                            write(' ');
                            END;
                        END; //IF COLOR
                    if (horizonal3[i].color = 0) THEN BEGIN
                if (horizonal3[i].sumatorio < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',horizonal3[i].sumatorio,' ');
                            END
                                ELSE
                                    write (horizonal3[i].sumatorio,' ');
                                end;
                        END;//FOR
                writeln('');
                writeln('     -- -- -- -- -- -- --');
            FOR i := RANGOMIN TO SIETE DO BEGIN
                if (vertical3[i].color = 1) THEN BEGIN
                    if (vertical3[i].sumatorio < 10) THEN BEGIN
                        TextBackground(yellow);
                        write ('0',vertical3[i].sumatorio);
                        TextBackground(black);
                        write(' ');
                                END
                            ELSE BEGIN
                            TextBackground(yellow);
                            write (vertical3[i].sumatorio);
                            TextBackground(black);
                            write(' ');
                            END;
                        END; //IF COLOR
                    if (vertical3[i].color = 0) THEN BEGIN
                if (vertical3[i].sumatorio < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',vertical3[i].sumatorio,' ');
                            END
                                ELSE
                                    write (vertical3[i].sumatorio,' ');
                                end;
                         write('| ');

                        FOR j := RANGOMIN TO SIETE DO BEGIN
                             if (tablero3[i,j].colores = 1) THEN BEGIN
                    if (tablero3[i,j].original < 10) THEN BEGIN
                        TextBackground(red);
                        write ('0',tablero3[i,j].original);
                        TextBackground(black);
                        write(' ');
                                END
                            ELSE BEGIN
                                TextBackground(red);
                                write (tablero3[i,j].original);
                                TextBackground(black);
                                write(' ');
                            END;
                        END; //IF COLOR
                    if (tablero3[i,j].colores = 0) THEN BEGIN
                if (tablero3[i,j].original < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',tablero3[i,j].original,' ');
                            END
                                ELSE
                                    write (tablero3[i,j].original,' ');
                                end;
                        end; //for amarillo rojo amarillo
                        write('| ');
                        if (vertical3[i].color = 1) THEN BEGIN
                    if (vertical3[i].sumatorio < 10) THEN BEGIN
                        TextBackground(yellow);
                        write ('0',vertical3[i].sumatorio);
                        TextBackground(black);
                        write(' ');
                                END
                            ELSE BEGIN
                            TextBackground(yellow);
                            write (vertical3[i].sumatorio);
                            TextBackground(black);
                            write(' ');
                            END;
                        END; //IF COLOR
                        if (vertical3[i].color = 0) THEN BEGIN
                if (vertical3[i].sumatorio < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',vertical3[i].sumatorio,' ');
                            END
                                ELSE
                                    write (vertical3[i].sumatorio,' ');
                                end;
                writeln('');
            END;//FOR
                writeln('     -- -- -- -- -- -- --');
                write ('     ');
             FOR i := RANGOMIN TO SIETE DO BEGIN
                if (horizonal3[i].color = 1) THEN BEGIN
                    if (horizonal3[i].sumatorio < 10) THEN BEGIN
                        TextBackground(yellow);
                        write ('0',horizonal3[i].sumatorio);
                        TextBackground(black);
                        write(' ');
                                END
                            ELSE BEGIN
                            TextBackground(yellow);
                            write (horizonal3[i].sumatorio);
                            TextBackground(black);
                            write(' ');
                            END;
                        END; //IF COLOR

                    if (horizonal3[i].color = 0) THEN BEGIN
                if (horizonal3[i].sumatorio < 10) THEN BEGIN
                    TextBackground(black);
                        write ('0',horizonal3[i].sumatorio,' ');
                            END
                                ELSE
                                    write (horizonal3[i].sumatorio,' ');
                                end;
            END;//FOR PRINCIPAL
        END;//BEGIN
    END; //CASE OF
END;//FINAL PROCEDURE


PROCEDURE Movimiento (x:integer;VAR salir:integer;VAR contador:integer;VAR
tablero1:TTablero1;VAR horizonal1:TBordesH1;VAR vertical1:TBordesV1;
VAR tablero2:TTablero2;VAR horizonal2:TBordesH2;VAR vertical2:TBordesV2;
VAR tablero3:TTablero3;VAR horizonal3:TBordesH3;VAR vertical3:TBordesV3);

VAR
fila,columna,aux1,aux,i:integer;

BEGIN
writeln ('');


if (x = 1) THEN begin
        repeat
        CLRSCR;
        write ('Introduce el numero de fila -->'); readln(fila);
        until ((fila > 0) AND (fila <= 5));
        contador := contador + 1;
    end
        else if (x = 2) THEN begin
        repeat
        CLRSCR;
        write ('Introduce el numero de fila -->'); readln(fila);
        until ((fila > 0) AND (fila <= 6));
        contador := contador + 1;
            end
            else if (x = 3) THEN begin
                repeat
                CLRSCR;
                write ('Introduce el numero de fila -->'); readln(fila);
                until ((fila > 0) AND (fila <= 7));
                contador := contador + 1;
            end;

writeln ('');

if (x = 1) THEN begin
        repeat
        write ('Introduce el numero de columna -->'); readln(columna);
        CLRSCR;
        until ((columna > 0) AND (columna <= 5));

    end
    else if (x = 2) THEN begin
        repeat
        write ('Introduce el numero de columna -->'); readln(columna);
        CLRSCR;
        until ((columna > 0) AND (columna <= 6));

            end
            else if (x = 3) THEN begin
                repeat
                write ('Introduce el numero de columna -->'); readln(columna);
                CLRSCR;
                until ((columna > 0) AND (columna <= 7));

                    end;

    CLRSCR;
    write('Si desea salir del juego introduce "0",de lo contrario presione otra tecla  --> '); readln(salir);

    case x of

        1:  begin
            if (tablero1[fila,columna].colores = 1) THEN begin
                tablero1[fila,columna].colores := 0
            end else
                tablero1[fila,columna].colores := 1;

            aux1:= 0;
            aux := 0;

            FOR i := 1 TO 5 DO begin
                aux1 := 0;
                aux := 0;
                repeat
                    aux1 := aux1 + 1;
                    if (tablero1[i,aux1].colores = 1) THEN BEGIN
                    aux := tablero1[i,aux1].original + aux;
                    end;
                until(aux1 = 5);
                    CLRSCR;



                if (vertical1[i].sumatorio = aux) THEN
                    vertical1[i].color := 1
                    else
                        vertical1[i].color := 0;
                end; //for i

            FOR i := 1 TO 5 DO begin
                aux1 := 0;
                aux := 0;
                repeat
                    aux1 := aux1 + 1;
                    if (tablero1[aux1,i].colores = 1) THEN BEGIN
                    aux := tablero1[aux1,i].original + aux;
                    end;
                until(aux1 = 5);
                    CLRSCR;

            if (horizonal1[i].sumatorio = aux) THEN
                    horizonal1[i].color := 1
                    else
                        horizonal1[i].color := 0;
            end; //for i
        end; //1

        2: begin
        if (tablero2[fila,columna].colores = 1) THEN
                            tablero2[fila,columna].colores := 0
                        else
                            tablero2[fila,columna].colores := 1;
                aux1:= 0;
            aux := 0;

            FOR i := 1 TO 6 DO begin
                aux1 := 0;
                aux := 0;
                repeat
                    aux1 := aux1 + 1;
                    if (tablero2[i,aux1].colores = 1) THEN BEGIN
                    aux := tablero2[i,aux1].original + aux;
                    end;
                until(aux1 = 6);
                    CLRSCR;



                if (vertical2[i].sumatorio = aux) THEN
                    vertical2[i].color := 1
                    else
                        vertical2[i].color := 0;
            end; //for i

            FOR i := 1 TO 6 DO begin
                aux1 := 0;
                aux := 0;
                repeat
                    aux1 := aux1 + 1;
                    if (tablero2[aux1,i].colores = 1) THEN BEGIN
                    aux := tablero2[aux1,i].original + aux;
                    end;
                until(aux1 = 6);
                    CLRSCR;

                if (horizonal2[i].sumatorio = aux) THEN
                    horizonal2[i].color := 1
                    else
                        horizonal2[i].color := 0;
            end; //for i
        end; //2

        3: begin
        if (tablero3[fila,columna].colores = 1) THEN
                                    tablero3[fila,columna].colores := 0
                                else
                                    tablero3[fila,columna].colores := 1;

          aux1:= 0;
            aux := 0;

            FOR i := 1 TO 7 DO begin
                aux1 := 0;
                aux := 0;
                repeat
                    aux1 := aux1 + 1;
                    if (tablero3[i,aux1].colores = 1) THEN BEGIN
                    aux := tablero3[i,aux1].original + aux;
                    end;
                until(aux1 = 7);
                    CLRSCR;



                if (vertical3[i].sumatorio = aux) THEN
                    vertical3[i].color := 1
                    else
                        vertical3[i].color := 0;
            end; //for i

            FOR i := 1 TO 7 DO begin
                aux1 := 0;
                aux := 0;
                repeat
                    aux1 := aux1 + 1;
                    if (tablero3[aux1,i].colores = 1) THEN BEGIN
                    aux := tablero3[aux1,i].original + aux;
                    end;
                until(aux1 = 7);
                    CLRSCR;

                if (horizonal3[i].sumatorio = aux) THEN
                    horizonal3[i].color := 1
                    else
                        horizonal3[i].color := 0;
            end; //for i
        end; //3
    end; //case of
END; //procedure


FUNCTION Verificar (horizonal1:TBordesH1;vertical1:TBordesV1;horizonal2:TBordesH2;vertical2:TBordesV2;horizonal3:TBordesH3;vertical3:TBordesV3):boolean;

VAR
aux1,aux2,aux3,i:integer;
begin
aux1:=1;
aux2:=1;
aux3:=1;

i := 0;
repeat
    i := i + 1;
    aux1 := horizonal1[i].color * vertical1[i].color * aux1;
until (i = 5);
i := 0;
repeat
    i := i + 1;
    aux2 := horizonal2[i].color * vertical2[i].color * aux2;
until (i = 6);
i := 0;
repeat
    i := i +1;
    aux3 := horizonal3[i].color * vertical3[i].color * aux3;
until(i = 7);

if ((aux1 + aux2 + aux3) = 1) THEN
    Verificar := TRUE
    ELSE
        Verificar := FALSE;
end;//funcion

Procedure Tutorial;
begin
  ClrScr;writeln('Hola, bienvenid@s al tutorial del Rullo!');  writeln('Soy tu asistente virtual SVEN y en este tutorial voy a enseniarte');  write('de la manera mas simple como interpretar y usar la interfaz del ');  TextBackground(cyan);  write('R');  Textcolor(black);  write('u'); Textcolor(yellow);  write('l');  Textcolor(red);  write('l');
  textcolor(magenta);  write('o');  textcolor(lightgray);  writeln('!');  TextBackground(black);  writeln;  writeln;
  write('Presione cualquier tecla para pasar el texto durante el tutorial');  readkey;  ClrScr;  writeln('Primeramente, la parte mas simple de la interfaz es el menu!');
  write('Aunque ya lo habras visto para llegar aqui! hehehe ');  textbackground(yellow);  writeln(';)');  readkey;  textbackground(black);
  writeln('Veras que al meterte al programa se te mostrara una lista de opciones');  writeln('Algo parecido a esto resaltado en blanco!');  textcolor(white);  writeln;  writeln('1:------------------------------------------');
  writeln('2:------------------------------------------');  writeln('3:------------------------------------------');  writeln('4:------------------------------------------');  textcolor(lightgray);  writeln;  write('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;  writeln('Esta opcion te permite meterte al tutorial. :P');  writeln;
  write('1:------------------------------------------');  textcolor(yellow);  writeln('   <-----------------------');  textcolor(lightgray);  writeln('2:------------------------------------------');  writeln('3:------------------------------------------');
  writeln('4:------------------------------------------');  writeln;  write('Presione cualquier tecla para pasar el texto');  Readkey;  ClrScr;  writeln('Esta opcion permite elegir las caractericas de tu rullo (que despues explicare)');  writeln;  writeln('1:------------------------------------------');
  write('2:------------------------------------------');  textcolor(yellow);  writeln('   <-----------------------');  textcolor(lightgray);  writeln('3:------------------------------------------');
  writeln('4:------------------------------------------');  writeln;
  write('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;  write('Esta opcion te mostrara el numero total de jugadores que han ganado y su '); textcolor(yellow);  write('ranking');  textcolor(lightgray);  write('!');  writeln;  writeln('1:------------------------------------------');
  writeln('2:------------------------------------------');  write('3:------------------------------------------');  textcolor(yellow);
  writeln('   <-----------------------');  textcolor(lightgray);  writeln('4:------------------------------------------');  writeln;
  write('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;  writeln('Y esta opcion final es simplemente el boton para salir del juego!'); writeln;  writeln('1:------------------------------------------');  writeln('2:------------------------------------------');
  writeln('3:------------------------------------------');  write('4:------------------------------------------');  textcolor(yellow);  writeln('   <-----------------------');  textcolor(lightgray); writeln;  write('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;
  writeln('Dicho esto pasamos a explicar como customizar tu Rullo si presionaste la opcion 3!');  writeln;
  write('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;  writeln('Una vez seleccionada la opcion 3 te saldra otro menu parecido a este! (resaltado en blanco)');
  writeln('Sera el menu en el que elijas las dimensiones de tu tablero de juego');  writeln;  textcolor(white);  writeln('1: 5x5');  writeln('2: 6x6');  writeln('3: 7x7');  writeln('4: Salir');  textcolor(lightgray);  writeln;
  writeln('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;  write('Ya sea un ');  textcolor(yellow);  writeln('5x5');  textcolor(lightgray);  writeln;  write('1: 5x5');  textcolor(yellow);
  writeln('   <-----------------------');  textcolor(lightgray);  writeln('2: 6x6');  writeln('3: 7x7');  writeln('3: Salir');  writeln;  writeln('Presione cualquier tecla para pasar el texto');
  readkey;  ClrScr;  write('Sea un ');  textcolor(yellow);  writeln('6x6');  textcolor(lightgray);  writeln;  writeln('1: 5x5');  write('2: 6x6');  textcolor(yellow);
  writeln('   <-----------------------');  textcolor(lightgray);  writeln('3: 7x7');  writeln('4: Salir');  writeln;
  writeln('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;    write('O un ');  textcolor(yellow);  writeln('7x7');  textcolor(lightgray);  writeln;  writeln('1: 5x5');  writeln('2: 6x6');  write('3: 7x7');  textcolor(yellow);
  writeln('   <-----------------------');  textcolor(lightgray);  writeln('4: Salir');  writeln;  writeln('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;
  writeln('Una vez te hayas decidido con el tamanio de tu tablero');  writeln('Pasaremos a elegir el rango de aleatoriedad de los numeros del mismo');  writeln('Que no es nada mas que elegir de que numero a que numero iran los numero aleatorios');  writeln;
  writeln('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;  writeln('Algo como esto!(resaltado en blanco)');
  writeln;  textcolor(white);  writeln('1: 1-9');  writeln('2: 1-19');  writeln('3: Salir');  textcolor(lightgray);  writeln;
  writeln('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;  writeln('Para numeros del 1 al 9 usaremos esta!');  writeln;  write('1: 1-9');  textcolor(yellow);  writeln('   <-----------------------');  textcolor(lightgray);  writeln('2: 1-19');  writeln('3: Salir');  writeln;
  writeln('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;  writeln('Y para numeros del 1 al 19 usaremos esta!');
  writeln;  writeln('1: 1-9');  write('2: 1-19');  textcolor(yellow);  writeln('   <-----------------------');  textcolor(lightgray);  writeln('3: Salir');  writeln;  writeln('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;  writeln('Ya casi estamos en el final de el tutorial!');
  write('Ahora te voy a explicar las simples reglas del ');  TextBackground(cyan);  write('R');  Textcolor(black);  write('u');  Textcolor(yellow);  write('l');  Textcolor(red);  write('l');  textcolor(magenta);  write('o');  textcolor(lightgray);  writeln('!');  TextBackground(black);  writeln;
  writeln('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;  writeln('Las reglas son muy simples!');  writeln('Se te mostrara por pantalla una matriz de las dimesiones seleccionadas');  writeln('Ademas de estar rellenada con el rango de numeros que tambien tu elegiste');
  writeln('Si por ejemplo elegiste un 5x5 con numeros del 1 al 19');  writeln;  writeln('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;
  writeln('Tendras algo asi:');  writeln('');  write('    '); textbackground(yellow);  writeln('15 14 14 15 15');  textbackground(black);  write('    ');  writeln('-- -- -- -- --');  textbackground(yellow);  write('10 ');{fila 1}  textbackground(black);  write('|');  textbackground(red);
  write('03 01 05 04 06');  textbackground(black);  write('|');  textbackground(yellow);  writeln(' 10');{/fila 1}  textbackground(yellow); write('18 ');{fila 2}  textbackground(black);  write('|');  textbackground(red);  write('08 09 06 06 04');  textbackground(black);  write('|');
  textbackground(yellow);  writeln(' 18'); {/fila 2}  textbackground(yellow);  write('11 ');{fila 3}  textbackground(black);  write('|');  textbackground(red);  write('03 07 09 05 06');  textbackground(black);  write('|');
  textbackground(yellow);  writeln(' 11');{/fila 3}  textbackground(yellow);  write('13 ');{fila 4}  textbackground(black);  write('|');  textbackground(red);  write('01 07 05 01 09');  textbackground(black);  write('|');
  textbackground(yellow);  writeln(' 13');{/fila 4}  textbackground(yellow);  write('21 ');{fila 5 }  textbackground(black);  write('|');  textbackground(red);  write('06 06 04 08 05');  textbackground(black);  write('|');
  textbackground(yellow);  writeln(' 21'); {/fila 5}  textbackground(black);  write('    ');  writeln('-- -- -- -- --');  write('    ');  textbackground(yellow);  writeln('15 14 14 15 15');  textbackground(black);  writeln('');
  writeln('Los numeros amarillos son los sumatorios que tienes de obtener mediante el apagado de los numeros que tu selecciones.');
  writeln('Los numeros rojo son los numeros que tendras que apagar o encender individualmente hasta que todos los sumatorios se cumplan.');
  writeln('Los numeros que tu selecciones en la tabla se apagaran y dejaran de aportar valor a su columna y fila.');
  writeln;writeln;    writeln('Presione cualquier tecla para pasar el texto');  readkey;  ClrScr;  writeln('Se te pediria la posicion primero por filas y luego columnas');  writeln('Si por ejemplo quisieses apagar el numero 4,5');
  writeln('Verias esto:');writeln('');  write('    ');  textbackground(yellow);  writeln('15 14 14 15 15');  textbackground(black);  write('    ');  writeln('-- -- -- -- --');  textbackground(yellow);
  write('10 ');{fila 1}  textbackground(black);  write('|');  textbackground(red);  write('03 01 05 04 06');  textbackground(black);  write('|');  textbackground(yellow);  writeln(' 10');{/fila 1}
  textbackground(yellow);  write('18 ');{fila 2}  textbackground(black);  write('|');  textbackground(red);  write('08 09 06 06 04');  textbackground(black);  write('|');
  textbackground(yellow);  writeln(' 18'); {/fila 2}  textbackground(yellow);  write('11 ');{fila 3}  textbackground(black);  write('|');
  textbackground(red);  write('03 07 09 05 06');  textbackground(black);  write('|');
  textbackground(yellow);  writeln(' 11');{/fila 3}  textbackground(yellow);  write('13 ');{fila 4}  textbackground(black);  write('|');  textbackground(red);  write('01 07 05 01 ');
  textbackground(black);  write('05');  write('|');  textbackground(yellow);  writeln(' 13');{/fila 4}
  textbackground(yellow);  write('21 ');{fila 5 }  textbackground(black);  write('|');  textbackground(red);  write('06 06 04 08 05');
  textbackground(black);  write('|');  textbackground(yellow);  writeln(' 21'); {/fila 5}  textbackground(black);  write('    ');  writeln('-- -- -- -- --');
  write('    ');  textbackground(yellow);  writeln('15 14 14 15 15');  textbackground(black);
  writeln('Una vez eligas la combinacion que permite que se den todos los sumatorios, ganaras!');
  write('Y se te pedira que introduzcas un nombre para que se guarde en la base de datos de ganadores, el ');
  textcolor(yellow);  writeln('ranking');  textcolor(white);  writeln('!');  writeln;  writeln;  writeln('Presione cualquier tecla para terminar el tutorial !');  readkey;  ClrScr;
end;


PROCEDURE MENUNUMEROS (VAR y: integer);

VAR
VALORMENU3 : INTEGER;

BEGIN
y := 0;

REPEAT
    REPEAT
        TextBackground(black);
  CLRSCR;
  WRITELN ('---------------------------------------------------------------------');
  WRITELN ('---------------------------------------------------------------------');
  WRITELN ('-------------------------BIENVENIDO AL RULLO-------------------------');
  WRITELN ('---------------------------------------------------------------------');
  WRITELN ('---------------------------------------------------------------------');
  WRITELN ('');
  TextColor (Blue);
  TextBackground(BLACK);
  WRITELN ('                   RANGO DE NUMEROS DEL TABLERO ');
  WRITELN ('                   ----------------------------- ');
  WRITELN (' ');

  TextColor (LightBlue);
  WRITELN ('--> 1. [1 TO 9]');
  TextColor(yellow);
  WRITELN ('--> 2. [1 TO 19]');
  TextColor(lightred);
  WRITELN ('--> 3. SALIR');
  TextColor (WHITE);
  WRITELN ('');
  WRITE ('SELECCIONA UNA OPCION --> ');
  READLN (VALORMENU3);

 UNTIL ((VALORMENU3 = 1) OR (VALORMENU3 = 2) OR (VALORMENU3 = 3));
   CASE VALORMENU3 OF
  1:BEGIN
    y := 1;
    VALORMENU3 := 3;

    END;
  2: BEGIN
    y := 2;
    VALORMENU3 := 3;
    END;

    END;
 UNTIL (VALORMENU3 = 3);

END;

PROCEDURE MENUTABLERO ( VAR x,y: INTEGER);
VAR
VALORMENU2: integer;
BEGIN

  x := 0;
REPEAT
REPEAT
  TextBackground(black);
  CLRSCR;
  WRITELN ('---------------------------------------------------------------------');
  WRITELN ('---------------------------------------------------------------------');
  WRITELN ('-------------------------BIENVENIDO AL RULLO-------------------------');
  WRITELN ('---------------------------------------------------------------------');
  WRITELN ('---------------------------------------------------------------------');
  WRITELN ('');
  TextColor (Blue);
  TextBackground(BLACK);
  WRITELN ('                   SELECCIONA EL TIPO DE TABLERO ');
  WRITELN ('                   ----------------------------- ');
  WRITELN (' ');
TextColor (LightBlue);
  WRITELN ('--> 1. 5X5');
 TextColor (yellow);
  WRITELN ('--> 2. 6X6');
 TextColor (lightgreen);
  WRITELN ('--> 3. 7X7');
  TextColor (lightred);
  WRITELN ('--> 4. SALIR');
  TextColor (white);
  WRITELN ('');
  WRITE ('SELECCIONA UNA OPCION --> ');
  READLN (VALORMENU2);

 UNTIL ((VALORMENU2 = 1) OR (VALORMENU2 = 2) OR (VALORMENU2 = 3) OR (VALORMENU2 = 4));
   CASE VALORMENU2 OF
  1:BEGIN
    x := 1;
    MENUNUMEROS (y);
    VALORMENU2 := 4;
    END;
  2: BEGIN
    x := 2;
    MENUNUMEROS (y);
    VALORMENU2 := 4;
    END;
  3: BEGIN
    x := 3;
    MENUNUMEROS (y);
    VALORMENU2 := 4;
    END;
  END;
 UNTIL (VALORMENU2 = 4);
END;

PROCEDURE MENU (VAR salir1,x,y:integer);
VAR
VALORMENU1: INTEGER;
aux :char;
BEGIN

CLRSCR;
REPEAT
    REPEAT

  TextBackground(black);
  WRITELN ('---------------------------------------------------------------------');
  WRITELN ('---------------------------------------------------------------------');
  WRITELN ('-------------------------BIENVENIDO AL RULLO-------------------------');
  WRITELN ('---------------------------------------------------------------------');
  WRITELN ('---------------------------------------------------------------------');
  WRITELN ('');
  TextColor (Blue);
  TextBackground(BLACK);
  WRITELN ('                           MENU DEL JUEGO ');
  WRITELN ('                          ---------------- ');
  WRITELN('');
  TextColor (lightgreen);
   WRITELN ('--> 1. TUTORIAL');
  TextColor (LightBlue);
  WRITELN ('--> 2. JUGAR');
  TextColor (yellow);
  WRITELN ('--> 3. RANKING');
  TextColor (lightred);
  WRITELN ('--> 4. SALIR');
  TextColor (white);
  WRITELN('');
  WRITE ('SELECCIONE UNA OPCION --> ');
  READLN (VALORMENU1);
  UNTIL ((VALORMENU1 = 1) OR (VALORMENU1 = 2) OR (VALORMENU1 = 3) OR (VALORMENU1 = 4) OR (VALORMENU1 = 5));

  CASE VALORMENU1 OF

  1: begin
  TUTORIAL;
  end;

  2: BEGIN
  MENUTABLERO (x,y);
  if ((x > 0) AND (y > 0))THEN begin
  VALORMENU1 :=5;
  salir :=1;
  end

  ELSE
    MENU(salir1,x,y);
  CLRSCR;

  END;

  3: BEGIN
   clrscr;
  repeat
  writeln('Que categoria quiere ver:');
   writeln('A. 5x5 rango 1-9');
    writeln('B. 6x6 rango 1-9');
     writeln('C. 7x7 rango 1-9');
      writeln('D. 5x5 rango 1-19');
       writeln('E. 6x6 rango 1-19');
        writeln('F. 7x7 rango 1-19');
      write ('-->'); readln(aux);
      aux := UPCASE(aux);
        until ((aux = 'A') OR (aux = 'B') OR (aux = 'C') OR (aux = 'D') OR (aux = 'E') OR (aux = 'F'));

        if (aux = 'A') THEN BEGIN
          x := 1;
          Y := 1;
       end
         ELSE if (aux = 'B') THEN BEGIN
            x := 2;
            Y := 1;
         end
           ELSE if (aux = 'C') THEN BEGIN
              x := 3;
              Y := 1;
           end
             ELSE if (aux = 'D') THEN BEGIN
                x := 1;
                Y := 2;
             end
               ELSE if (aux = 'E') THEN BEGIN
                  x := 2;
                  Y := 2;
               end
                 ELSE if (aux = 'F') THEN BEGIN
                    x := 3;
                    Y := 2;
                 end;
    salir := 100;
   VALORMENU1 := 5;
        end;

  4: begin
  VALORMENU1 := 5;
  salir1:=0;
  salir := 1;
  end;
 end;
UNTIL (VALORMENU1 = 5);
END; //procedure


PROCEDURE RankingMODE (VAR x,y,contador:integer; VAR Ranking:TRanking);
 VAR
 aux,i: integer;
 nombre1:string[40];
BEGIN

case y of


1: BEGIN
         CASE x OF

                1: BEGIN

                    aux := 1;
                    repeat


                    if (contador >= (Ranking[aux].puntuacion)) THEN begin


                     for i := 10 DOWNTO aux do BEGIN

                        Ranking[i].puntuacion := Ranking[i-1].puntuacion;
                        Ranking[i].nombre := Ranking[i-1].nombre;
                         ;
                    END; //for

                    CLRSCR;
                    Writeln('Has ganado con un contador impresionante por ello dinos tu nombre para poder guardarlo en el ranking de jugadores');
                    Write('--> ');
                    readln(nombre1);
                    Ranking[aux].nombre := nombre1;
                    Ranking[aux].puntuacion := contador;

                    aux := 11;

                    end
                    else
                    aux := SUCC(aux);

               until (aux = 11);

                END; //1

                2:BEGIN
                aux := 11;
                    repeat

                    if (contador >= (Ranking[aux].puntuacion)) THEN begin

                     for i := 20 DOWNTO aux do BEGIN

                        Ranking[i].puntuacion := Ranking[i-1].puntuacion;
                        Ranking[i].nombre := Ranking[i-1].nombre;
                         ;
                    END; //for

                    CLRSCR;
                    Writeln('Has ganado con un contador impresionante por ello dinos tu nombre para poder guardarlo en el ranking de jugadores');
                    Writeln('--> ');
                    readln(nombre1);
                    Ranking[aux].nombre := nombre1;
                    Ranking[aux].puntuacion := contador;

                    aux := 21;

                    end
                    else
                    aux := SUCC(aux);
                 until (aux = 21);

                END;//2

                3:BEGIN
                aux := 21;
                    repeat

                    if (contador >= (Ranking[aux].puntuacion)) THEN begin

                     for i := 30 DOWNTO aux do BEGIN

                        Ranking[i].puntuacion := Ranking[i-1].puntuacion;
                        Ranking[i].nombre := Ranking[i-1].nombre;
                         ;
                    END; //for

                    CLRSCR;
                    Writeln('Has ganado con un contador impresionante por ello dinos tu nombre para poder guardarlo en el ranking de jugadores');
                    Writeln('--> ');
                    readln(nombre1);
                    Ranking[aux].nombre := nombre1;
                    Ranking[aux].puntuacion := contador;

                    aux := 31;

                    end
                    else
                    aux := SUCC(aux);
                     until (aux = 31);
                END; //3
           end ; //CASE OF X1
       END; //1

2:BEGIN
        CASE x OF

        1: BEGIN
            aux := 31;
                    repeat


                    if (contador >= (Ranking[aux].puntuacion)) THEN begin


                     for i := 40 DOWNTO aux do BEGIN

                        Ranking[i].puntuacion := Ranking[i-1].puntuacion;
                        Ranking[i].nombre := Ranking[i-1].nombre;
                         ;
                    END; //for

                    CLRSCR;
                    Writeln('Has ganado con un contador impresionante por ello dinos tu nombre para poder guardarlo en el ranking de jugadores');
                    Writeln('--> ');
                    readln(nombre1);
                    Ranking[aux].nombre := nombre1;
                    Ranking[aux].puntuacion := contador;

                    aux := 41;
                     end
                    else
                    aux := SUCC(aux);
                     until (aux = 41);
        END;//1

        2:BEGIN
        aux := 41;
                    repeat

                    if (contador >= (Ranking[aux].puntuacion)) THEN begin

                     for i := 50 DOWNTO aux do BEGIN

                        Ranking[i].puntuacion := Ranking[i-1].puntuacion;
                        Ranking[i].nombre := Ranking[i-1].nombre;
                         ;
                    END; //for

                    CLRSCR;
                    Writeln('Has ganado con un contador impresionante por ello dinos tu nombre para poder guardarlo en el ranking de jugadores');
                    Writeln('--> ');
                    readln(nombre1);
                    Ranking[aux].nombre := nombre1;
                    Ranking[aux].puntuacion := contador;

                    aux := 51;
                    //llamar a exportador

                    end
                    else
                    aux := SUCC(aux);
                     until (aux = 51);

        END;//2

        3:BEGIN
        aux := 51;
                    repeat


                    if (contador >= (Ranking[aux].puntuacion)) THEN begin


                     for i := 60 DOWNTO aux do BEGIN

                        Ranking[i].puntuacion := Ranking[i-1].puntuacion;
                        Ranking[i].nombre := Ranking[i-1].nombre;
                         ;
                    END; //for

                    CLRSCR;
                    Writeln('Has ganado con un contador impresionante por ello dinos tu nombre para poder guardarlo en el ranking de jugadores');
                    Writeln('--> ');
                    readln(nombre1);
                    Ranking[aux].nombre := nombre1;
                    Ranking[aux].puntuacion := contador;

                    aux := 61;
                  end
                    else
                    aux := SUCC(aux);
                     until (aux = 61);

        END;//2
    end; //x2
END; //2


    end; //case xx
END; //PROCEDURE

PROCEDURE Importar (VAR archivo:tfichero;VAR a: TRanking);

VAR
    pagina: Ttipo;
    aux :integer;

BEGIN
{$I-}
 RESET (archivo);
{$I+}

if IORESULT = 0 THEN BEGIN
    aux := 0;

 repeat
        aux := aux + 1;
        SEEK(archivo,aux - 1);
        read(archivo,pagina);
        a[aux].nombre := pagina.nombre;
        a[aux].puntuacion := pagina.puntuacion;
 until (aux = 60);
close (archivo);
 END
         ELSE
             rewrite (archivo);


end;     //PROCEDURE


PROCEDURE Exportar (VAR archivo:tfichero;a: TRanking);

VAR
    pagina: Ttipo;
    aux :integer;

BEGIN
{$I-}
 RESET (archivo);
{$I+}
if IORESULT = 0 THEN BEGIN
    aux := 0;

 repeat
        aux := aux + 1;
        SEEK(archivo,aux - 1);
        pagina.nombre := a[aux].nombre ;
        pagina.puntuacion := a[aux].puntuacion ;
        write(archivo,pagina);
        until (aux = 60);
    close(archivo);
 END


end;     //PROCEDURE

PROCEDURE MostrarRanking (x,y :integer; ranking:TRanking);
    VAR
        aux : integer;

begin
case y of
 1:begin
    case x of
     1:begin
       clrscr;
       writeln('Esta es la categoria 5x5 rango 1-9');
       writeln(' ');
        aux := 0;
          repeat
                aux := aux +1;
                writeln (11-aux,'. ',ranking[aux].nombre);
                writeln ('--> ',ranking[aux].puntuacion);
          until (aux = 10) ;
     end;

     2: begin
         clrscr;
       writeln('Esta es la categoria 6x6 rango 1-9');
       writeln(' ');
       aux := 10;
          repeat
                aux := aux +1;
                writeln (21 - aux,'. ',ranking[aux].nombre);
                writeln ('--> ',ranking[aux].puntuacion);
          until (aux = 20) ;
     end;

     3: begin
           clrscr;
       writeln('Esta es la categoria 7x7 rango 1-9');
       writeln(' ');
       aux := 20;
          repeat
                aux := aux + 1;
                writeln (31 -aux,'. ',ranking[aux].nombre);
                writeln ('--> ',ranking[aux].puntuacion);
          until (aux = 30) ;
         end;
         end; //case of x

    end;


 2: begin
    case x of
     1 : begin

         clrscr;
       writeln('Esta es la categoria 5x5 rango 1-19');
       writeln(' ');
        aux := 30;
          repeat
                aux := aux +1;
                writeln (41 -aux, '. ',ranking[aux].nombre);
                writeln ('--> ',ranking[aux].puntuacion);
          until (aux = 40) ;
     end;

      2 : begin


          clrscr;
       writeln('Esta es la categoria 6x6 rango 1-19');
       writeln(' ');
        aux := 40;
          repeat
                aux := aux +1;
                writeln (51 -aux,'. ',ranking[aux].nombre);
                writeln ('--> ',ranking[aux].puntuacion);
          until (aux = 50) ;
      end;

       3 : begin
          clrscr;
       writeln('Esta es la categoria 7x7 rango 1-19');
       writeln(' ');
        aux := 50;
          repeat
                aux := aux +1;
                writeln (61 -aux,'. ',ranking[aux].nombre);
                writeln ('--> ',ranking[aux].puntuacion);
          until (aux = 60) ;
       end;

    end;

 end;


end;  //case of y
end;//procedure


BEGIN

x:= 0;
y:=0;



ASSIGN (F,'E:\partidas.dat');
FOr i:= 1 to 60 do
   begin
   Ranking[i].nombre := ' ';
   Ranking[i].puntuacion := 0;
   end;
 Importar(F,Ranking);
contador := 18;

repeat

salir1:=1;
ClrScr;

x :=0;
y:=0;
repeat
    Menu(salir1,X,Y);
    if (salir = 100) THEN begin
    MostrarRanking(x,y,ranking);
    writeln('');
    writeln('PULSE UNA TECLA PARA SALIR');
    x := 0;
    y := 0;
    readkey;
      end;

    until (salir = 1);
FOR i:=1 TO CINCO DO
                        FOR j:=1 TO CINCO DO begin
                            tablero1[i,j].original := 0;
                            tablero1[i,j].calculos := 0;
                            tablero1[i,j].colores  := 1;
                            end;

    FOR i:=1 TO CINCO DO begin
                            bordesverticales1[i].sumatorio := 0;
                            bordesverticales1[i].color := 0;
                                                        end;

    FOR i:=1 TO CINCO DO begin
                        bordeshorizontal1[i].sumatorio := 0;
                        bordeshorizontal1[i].color := 0;
                            end;


    FOR i:=1 TO SEIS DO
                        FOR j:=1 TO SEIS DO begin
                            tablero2[i,j].original := 0;
                            tablero2[i,j].calculos := 0;
                            tablero2[i,j].colores  := 1;
                            end;

    FOR i:=1 TO SEIS DO begin
                            bordesverticales2[i].sumatorio := 0;
                            bordesverticales2[i].color := 0;
                                                        end;

    FOR i:=1 TO SEIS DO begin
                        bordeshorizontal2[i].sumatorio := 0;
                        bordeshorizontal2[i].color := 0;
                            end;

    FOR i:=1 TO SIETE DO
                        FOR j:=1 TO SIETE DO begin
                            tablero3[i,j].original := 0;
                            tablero3[i,j].calculos := 0;
                            tablero3[i,j].colores  := 1;
                            end;

    FOR i:=1 TO SIETE DO begin
                            bordesverticales3[i].sumatorio := 0;
                            bordesverticales3[i].color := 0;
                                                        end;

    FOR i:=1 TO SIETE DO begin
                        bordeshorizontal3[i].sumatorio := 0;
                        bordeshorizontal3[i].color := 0;
                            end;

ClrScr;

salir:=1;
if (salir1 <> 0) THEN BEGIN
RellenarNumeros(y,x,tablero1,bordeshorizontal1,bordesverticales1,
tablero2,bordeshorizontal2,bordesverticales2,
tablero3,bordeshorizontal3,bordesverticales3);
repeat
WRITE('El numero de movimiento es: ',contador);
WRITELN('');
WRITELN('');

MostrarTablero(x,tablero1,bordeshorizontal1,bordesverticales1,
    tablero2,bordeshorizontal2,bordesverticales2,
    tablero3,bordeshorizontal3,bordesverticales3);
    WRITELN('');
    WRITELN('');
WRITELN('        PULSE CUALQUIER TECLA PARA CONTINUAR');
readkey;
Movimiento(x,salir,contador,tablero1,bordeshorizontal1,bordesverticales1,
tablero2,bordeshorizontal2,bordesverticales2,
tablero3,bordeshorizontal3,bordesverticales3);
until ((salir = 0) OR (Verificar(bordeshorizontal1,bordesverticales1,bordeshorizontal2,bordesverticales2,
    bordeshorizontal3,bordesverticales3) = TRUE));

if (salir = 0) THEN BEGIN
    ClrScr;

FOR i:=1 TO CINCO DO
    FOR j:=1 TO CINCO DO begin
                            tablero1[i,j].original := 0;
                            tablero1[i,j].calculos := 0;
                            tablero1[i,j].colores  := 1;
                            end;

    FOR i:=1 TO CINCO DO begin
                            bordesverticales1[i].sumatorio := 0;
                            bordesverticales1[i].color := 0;
                                                        end;

    FOR i:=1 TO CINCO DO begin
                        bordeshorizontal1[i].sumatorio := 0;
                        bordeshorizontal1[i].color := 0;
                            end;

    FOR i:=1 TO SEIS DO
                        FOR j:=1 TO SEIS DO begin
                            tablero2[i,j].original := 0;
                            tablero2[i,j].calculos := 0;
                            tablero2[i,j].colores  := 1;
                            end;

    FOR i:=1 TO SEIS DO begin
                            bordesverticales2[i].sumatorio := 0;
                            bordesverticales2[i].color := 0;
                                                        end;

    FOR i:=1 TO SEIS DO begin
                        bordeshorizontal2[i].sumatorio := 0;
                        bordeshorizontal2[i].color := 0;
                            end;

    FOR i:=1 TO SIETE DO
                        FOR j:=1 TO SIETE DO begin
                            tablero3[i,j].original := 0;
                            tablero3[i,j].calculos := 0;
                            tablero3[i,j].colores  := 1;
                            end;

    FOR i:=1 TO SIETE DO begin
                            bordesverticales3[i].sumatorio := 0;
                            bordesverticales3[i].color := 0;
                                                        end;

    FOR i:=1 TO SIETE DO begin
                        bordeshorizontal3[i].sumatorio := 0;
                        bordeshorizontal3[i].color := 0;
                            end;

    salir1:=1;
    contador:=0;
    end

ELSE BEGIN

    ClrScr;
         MostrarTablero(x,tablero1,bordeshorizontal1,bordesverticales1,
    tablero2,bordeshorizontal2,bordesverticales2,
    tablero3,bordeshorizontal3,bordesverticales3);

    IF (Verificar(bordeshorizontal1,bordesverticales1,bordeshorizontal2,bordesverticales2,
    bordeshorizontal3,bordesverticales3) = TRUE) THEN begin
    readkey;
      Importar(F,Ranking);
      RankingMODE (x,y,contador,ranking);
      Exportar(F,Ranking);


end;//if

    END;// else
    END //if principal
    ELSE

until(salir1 = 0);

end.
