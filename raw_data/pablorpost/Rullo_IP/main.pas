PROGRAM Rullo;

USES
	CRT;

CONST
	MAXS = 8;
	
	EXITTXT    = 'EXIT';
	MOSTRARTXT = 'MOSTRAR';
	
	HELPC   = 'H';
	GAMEC   = 'G';
	RECORDC = 'R';
	EXITC   = 'X';

	RANKBIN = 'partidas.bin';

TYPE
	TCelda = RECORD
		visible, sumable: integer;
		activado: boolean;
	END;
	TCeldaSum = RECORD
		visible, obtenido: integer;
		activado: boolean;
	END;
	TTabla = ARRAY [1..MAXS, 1..MAXS] OF TCelda;
	TSum = ARRAY [1..MAXS] OF TCeldaSum;
	TString = string [40];
    TPlayer = RECORD
        nombre: TString;
        puntuacion: longint;
        tipo: char;
    END;
    TFichNum = FILE OF TPlayer;
    TAllRecords = ARRAY [1..MAXINT] OF TPlayer;
    TRecords = RECORD
        lista: TAllRecords;
        longitud: integer;
    END;

FUNCTION Existe (VAR f: TFichNum): boolean;
    BEGIN
        {$I-}
        RESET (f);
        {$I+}
        Existe := IORESULT = 0;
    END;

PROCEDURE CrearFichero (VAR f: TFichNum);
     BEGIN
        ASSIGN(f, RANKBIN);
        IF NOT Existe(f) THEN
            REWRITE(f);
        CLOSE (f);
     END;

PROCEDURE WriteColor(i, j, k: integer);
	BEGIN
		TextBackGround(j);
		TextColor(k);
		Write(i:3);
		TextColor(WHITE);
		TextBackGround(BLACK);
	END;

PROCEDURE WriteColorStr(s: string; j, k: integer);
	BEGIN
		TextBackGround(j);
		TextColor(k);
		Write(s);
		TextColor(WHITE);
		TextBackGround(BLACK);
	END;

PROCEDURE RellenarFichero (VAR f: TFichNum; n: TString; int: integer; t: char);
    VAR
        a: TPlayer;
    BEGIN
        ASSIGN(f, RANKBIN);
        IF NOT Existe (f) THEN
            CrearFichero(f);
        RESET(f);
        SEEK(f, FILESIZE(f));
        WITH a DO BEGIN
            nombre := n;
            puntuacion := int;
            tipo := t;
        END;
        Write(f, a);
        CLOSE(f);
    END;

PROCEDURE RellenarArray (VAR n: TRecords; VAR f: TFichNum; tip: char);
    VAR
        aux: TPlayer;
    BEGIN
        ASSIGN(f, RANKBIN);
        RESET(f);
        WITH n DO BEGIN
            WHILE NOT EOF(f) DO BEGIN
                Read(f, aux);
                IF aux.tipo = tip THEN BEGIN
                    lista[longitud] := aux;
                    longitud := longitud + 1;
                END;
            END;
        END;
        CLOSE (f);
    END;

PROCEDURE OrdenarArray (VAR n: TRecords);
    VAR
        i, j: integer;
        aux: TPlayer;
    BEGIN
        WITH n DO BEGIN
            FOR i := 1 TO longitud - 1 DO
                FOR j := 1 TO longitud - i - 1 DO
                    IF (lista[j].puntuacion > lista[j + 1].puntuacion) THEN BEGIN
                        aux := lista[j + 1];
                        lista[j + 1] := lista[j];
                        lista[j] := aux;
                    END;
        END;
    END;

PROCEDURE PrintList (n: TRecords);
    VAR
        i, j, l, c1, c2, lenMax: integer;
    BEGIN
        WITH n DO BEGIN
            lenMax := 0;
            FOR i := 1 TO longitud - 1 DO
                if lenMax < length(lista[i].nombre) THEN
                    lenMax := length(lista[i].nombre);
            IF longitud > 10 THEN
                l := 10
            ELSE
                l := longitud - 1;
            FOR i := 1 TO l DO BEGIN
                IF ODD(i) THEN BEGIN
                    c1 := Black;
                    c2 := White;
                END ELSE BEGIN
                    c1 := White;
                    c2 := Black;
                END;
                WriteColorStr(lista[i].nombre, c1, c2);
                FOR j := length(lista[i].nombre) TO lenMax DO
                    WriteColorStr(' ', c1, c2);
                WriteColorStr(' ==> ', c1, c2);
                Writecolor(lista[i].puntuacion, c1, c2);
                Writeln;
            END;
        END;
    END;

PROCEDURE MostrarFichero (VAR f: TFichNum; tipo: char);
    VAR
        list: TRecords;
    BEGIN
        ASSIGN(f, RANKBIN);
        list.longitud := 1;
        IF Existe(f) THEN
            RellenarArray(list, f, tipo);
        IF list.longitud <> 1 THEN BEGIN
            OrdenarArray(list);
            PrintList(list);
        END ELSE
            Writeln('Lo siento, no hay records registrados aun.');
    END;

PROCEDURE WriteMatrix(tab: TTabla; s: integer; sumFila, sumColumna: TSum; most: boolean);
    VAR
        i, j: integer;
    BEGIN
    	ClrScr;
        Write('     ');
        FOR i := 1 TO s DO BEGIN
            IF sumColumna[i].activado THEN
                WriteColor(sumColumna[i].visible, Yellow, White)
            ELSE
               	WriteColor(sumColumna[i].visible, Black, Yellow);
            Write('   ');
            END;
        Writeln;
        Writeln;
        FOR i := 1 TO s DO BEGIN
            IF sumFila[i].activado THEN
                WriteColor(sumFila[i].visible, Yellow, White)
            ELSE
               	WriteColor(sumFila[i].visible, Black, Yellow);
            Write('   ');
            FOR j := 1 TO s DO BEGIN
                IF tab[i, j].activado THEN
                    WriteColor(tab[i, j].visible, Cyan, White)
               	ELSE
                    WriteColor(tab[i, j].visible, Black, Cyan);
				Write('   ');
            END;
            IF sumFila[i].activado THEN
                WriteColor(sumFila[i].visible, Yellow, White)
            ELSE
               	WriteColor(sumFila[i].visible, Black, Yellow);
            Write('   ');
            IF most THEN
                WriteColor(sumFila[i].obtenido, Black, DarkGray);
            WriteLn;
            WriteLn;
        END;
        Write('     ');
        FOR i := 1 TO s DO BEGIN
            IF sumColumna[i].activado THEN
                WriteColor(sumColumna[i].visible, Yellow, White)
            ELSE
               	WriteColor(sumColumna[i].visible, Black, Yellow);
            Write('   ');
        END;
        Writeln;
        Writeln;
        IF most THEN BEGIN
            Write('     ');
            FOR i := 1 TO s DO BEGIN
                WriteColor(sumColumna[i].obtenido, Black, DarkGray);
                Write('   ');
            END;
        END;
    END;

PROCEDURE RanNumsT (VAR tab: TTabla; s, maxPosNum: integer);
    VAR
        i, j, aux: integer;
    BEGIN
        FOR i := 1 TO s DO
            FOR j := 1 TO s DO
                with tab[i, j] DO BEGIN
                    aux := random(maxPosNum) + 1;
                    visible := aux;
                    sumable := aux;
                    activado := true;
                END;
    END;

FUNCTION SumaFilaColumna (tab: TTabla; s, pos: integer; fila: boolean): integer;
    VAR
        i, cont: integer;
    BEGIN
        cont := 0;
        FOR i := 1 TO s DO
            IF fila THEN
                cont := cont + tab[pos, i].sumable
            ELSE
                cont := cont + tab[i, pos].sumable;
        SumaFilaColumna := cont;
    END;

PROCEDURE ActualizarFilaColumna (tab: TTabla; s: integer; VAR sumFila, sumColumna: TSum; posFila, posColumna: integer);
    BEGIN
        sumFila[posFila].obtenido := SumaFilaColumna(tab, s, posFila, True);
        sumFila[posFila].activado := sumFila[posFila].visible = sumFila[posFila].obtenido;
        sumColumna[posColumna].obtenido := SumaFilaColumna(tab, s, posColumna, False);
        sumColumna[posColumna].activado := sumColumna[posColumna].visible = sumColumna[posColumna].obtenido;
    END;

PROCEDURE ApagarRandom (tab: TTabla; s: integer; VAR sumFila, sumColumna: TSum);
    VAR
        i, toDel, n, m: integer;
        tApagado: TTabla;
        exit1, exit2: boolean;
    BEGIN
        tApagado := tab;
        toDel := s * 2;
        REPEAT
            n := random(s + 1) + 1;
            m := random(s + 1) + 1;
            IF tApagado[n, m].activado THEN BEGIN
                tApagado[n, m].activado := False;
                i := 1;
                exit1 := False;
                exit2 := False;
                WHILE (i <= s) AND (NOT exit1 OR NOT exit2) DO BEGIN
                    IF tApagado[i, m].activado THEN
                        exit1 := True;
                    IF tApagado[n, i].activado THEN
                        exit2 := True;
                    i := i + 1;
                END;
                IF i > s THEN
                    tApagado[n, m].activado := True
                ELSE BEGIN
                    toDel := toDel - 1;
                    tApagado[n, m].sumable := 0;
                END;
            END;
        UNTIL (toDel = 0);
        FOR i := 1 TO s DO BEGIN
            sumFila[i].visible := SumaFilaColumna(tApagado, s, i, True);
            sumColumna[i].visible := SumaFilaColumna(tApagado, s, i, False);
            ActualizarFilaColumna(tab, s, sumFila, sumColumna, i, i);
        END;
    END;

FUNCTION Win (s: integer; sumFila, sumColumna: TSum): boolean;
    VAR
        i: integer;
        aux: boolean;
    BEGIN
        aux := True;
        FOR i := 1 TO s DO
            IF NOT sumFila[i].activado OR NOT sumColumna[i].activado THEN
                aux := False;
        Win := aux;
    END;

PROCEDURE SaveRecord (intentos: integer; tipo: char);
    VAR
        nameP: TString;
        miFichero: TFichNum;
    BEGIN
        Writeln('Introduce el nombre para guardar tu record de ', intentos,' puntos:');
        Readln(nameP);
        RellenarFichero(miFichero, nameP, intentos, tipo);
    END;

PROCEDURE Main (VAR tab: TTabla; s: integer; sumFila, sumColumna: TSum; VAR intent: integer; tipo: char);
    VAR
        txt: string[10];
        i, j: integer;
        salir, mostrar: boolean;
    BEGIN
        intent := 0;
        salir := False;
        mostrar := False;
        REPEAT
            Writeln;
            REPEAT
                Writeln('Introduce las coordenadas de una casilla (p.e.: 1 2),');
                Writeln('(', EXITTXT, ') para salir o');
                Write('(', MOSTRARTXT, ') para mostrar/ocultar el sumatorio actual de filas y columnas: ');
                Readln(txt);
                txt := upcase(txt);
            UNTIL (txt = EXITTXT) OR (txt = MOSTRARTXT) OR ((((49 <= ord(txt[1])) AND (ord(txt[1]) <= s + 48)) AND 
                ((49 <= ord(txt[3])) AND (ord(txt[3]) <= s + 48))) AND (length(txt) = 3) AND (ord(txt[2]) = 32));
            IF txt = EXITTXT THEN
            	salir := True
            ELSE IF txt = MOSTRARTXT THEN
				mostrar := NOT mostrar;
            IF NOT salir THEN BEGIN
                IF txt <> MOSTRARTXT THEN BEGIN
                    i := ord(txt[1]) - 48;
                    j := ord(txt[3]) - 48;
                    IF tab[i, j].activado THEN
                        tab[i, j].sumable := 0
                    ELSE
                        tab[i, j].sumable := tab[i, j].visible;
                    tab[i, j].activado := NOT tab[i, j].activado;
                    ActualizarFilaColumna(tab, s, sumFila, sumColumna, i, j);
                    intent := intent + 1;
                END;
                WriteMatrix(tab, s, sumFila, sumColumna, mostrar);
            END;
        UNTIL Win(s, sumFila, sumColumna) OR salir;
        IF NOT salir THEN BEGIN
            Writeln;
            Writeln('Felicidades, ganaste');
            SaveRecord(intent, tipo);
        END;
    END;

PROCEDURE Game;
    VAR
        size, maxPosN, intent: integer;
        tabla: TTabla;
        sumF, sumC: TSum;
        tipo: char;
	BEGIN
        REPEAT
            Writeln('Introduce el tipo de juego (A, B, C...): ');
            Readln(tipo);
            tipo := upcase(tipo);
        UNTIL ('A' <= tipo) AND (tipo <= 'F');
        maxPosN := 9 + 10 * ((ord(tipo) - 65) div 3);
        size := 5 + ((ord(tipo) - 65) mod 3);
        RanNumsT(tabla, size, maxPosN);
        ApagarRandom (tabla, size, sumF, sumC);
        WriteMatrix(tabla, size, sumF, sumC, False);
        Main(tabla, size, sumF, sumC, intent, tipo);
	END;

PROCEDURE Help;
    BEGIN
        Clrscr;
        Writeln;
        Writeln('El juego Rullo es un juego de ingenio matematico,');
        Writeln('con el fin de resolver un puzle');
        Writeln;
        Writeln('Dependiendo del modo de juego elegido, se establecerá un tamanno de tablero y');
        Writeln('un rango en los numeros mostrados:');
        Writeln('   - Si el modo elegido es A, entonces el tablero sera de 5x5 y');
        Writeln('         un rango de numeros del 1 al 9');
        Writeln('   - Si el modo elegido es B, entonces el tablero sera de 6x6 y');
        Writeln('         un rango de numeros del 1 al 9');
        Writeln('   - Si el modo elegido es C, entonces el tablero sera de 7x7 y');
        Writeln('         un rango de numeros del 1 al 9');
        Writeln('   - Si el modo elegido es D, entonces el tablero sera de 5x5 y');
        Writeln('         un rango de numeros del 1 al 19');
        Writeln('   - Si el modo elegido es E, entonces el tablero sera de 6x6 y');
        Writeln('         un rango de numeros del 1 al 19');
        Writeln('   - Si el modo elegido es F, entonces el tablero sera de 7x7 y');
        Writeln('         un rango de numeros del 1 al 19');
        Writeln;
        Writeln('- Para jugar, debe elegir la opcion de juego (', GAMEC, ') en el menu principal');
        Writeln;
        Writeln('- El objetivo del juego es desactivar o activar casillas a voluntad');
        Writeln('(las azules), para que la suma de las filas (las doradas de los laterales) y ');
        Writeln('de las columnas (las doradas de arriba y abajo) sume lo esperado.');
        Writeln;
        Writeln('- Una vez que una fila o una columna sumen lo esperado');
        Writeln('su correspondiente sumatorio se iluminara.');
        Writeln;
        Writeln('- Para activar y desactivar casillas debera introducir el numero de la fila y');
        Writeln('de la columna con el formato "1 2" para la fila 1 y la columna 2.');
        Writeln;
	    Writeln('- Si en cualquier momento desea poder visualizar el sumatorio actual y');
	    Writeln('asi ahorrarse los calculos puede escribir (', MOSTRARTXT, ')');
	    Writeln;
        Writeln('- Si en cualquier momento desea salir del juego puede escribir (', EXITTXT, ')');
        Writeln;
        Writeln('- Si desea visualizar los records registrados hasta el momento, desde el menu');
        Writeln('escoja (', RECORDC,') y podra elegir el tipo de los que quiere visualizar.');
        Writeln;
        Writeln('- Si desea salir del juego, desde el menu escoja la opcion (', EXITC,') y');
        Writeln('se cerrara el programa.');
        Writeln;
        Writeln('Espero que le haya servido de ayuda. ¡Buena suerte!...');
        Writeln;
        Writeln('Presiona ENTER para volver al menu principal');
        Readln;
    END;

PROCEDURE MostrarRecords;
    VAR
        tipo: char;
        miFichero: TFichNum;
    BEGIN
        Clrscr;
        REPEAT
            Writeln('De que tipo quieres los records (A, B, C...): ');
            Readln(tipo);
            tipo := upcase(tipo);
        UNTIL ('A' <= tipo) AND (tipo <= 'F');
        MostrarFichero(miFichero, tipo);
        Writeln('Presiona ENTER para volver al menu principal');
        Readln;
    END;

PROCEDURE MainMenu;
    VAR
        toDo: char;
        salir: boolean;
    BEGIN
        salir := False;
        REPEAT
            REPEAT
                Clrscr;
                Writeln('¡Bienvenido al juego Rullo!');
                Writeln('Puede pedir ayuda para aprender a jugar (', HELPC, ')');
                Writeln('O bien iniciar el juego (', GAMEC, ')');
                Writeln('O tambien mostrar por pantalla los records de los jugadores (', RECORDC, ')');
                Writeln('O cerrar el juego (', EXITC, ')');
                readln(toDo);
                toDo := upcase(toDo);
            UNTIL (toDo = HELPC) OR (toDo = GAMEC) OR (toDo = RECORDC) OR (toDo = EXITC);
            CASE toDo OF
                HELPC   : Help;
                GAMEC   : Game;
                RECORDC : MostrarRecords;
                EXITC   : salir := True;
            END;
        UNTIL (salir);
    END;

BEGIN
    RANDOMIZE;
	MainMenu;
END.


