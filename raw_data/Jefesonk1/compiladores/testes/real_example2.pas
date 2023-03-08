PROGRAM hub;

TYPE
    withoutTypedef = RECORD
        var2: CHAR;
        varArray: array[1..10] of CHAR;
        var4: CHAR;
        var1: INTEGER;
        var0: INTEGER;
    END;

    withTypedef = RECORD
        varchar: CHAR;
        varint: INTEGER;
    END;

FUNCTION function(a,b,c: INTEGER): INTEGER;
VAR
    var2: INTEGER;
BEGIN
    var2 := 7;
    function := 3;
END;

FUNCTION function1(x,y,z: INTEGER): INTEGER;
VAR
    var1, var2: INTEGER;
    var3: array[1..10] of CHAR;
    var4: CHAR;
    var5: INTEGER;
BEGIN
    var1 := 2;
    var2 := var3[1] + 5 * 2^(3-7/(var1+Ord(var3[1])));
    var4 := var3[1];
    var5 := function(var1,var2,Ord(var4));

    function1 := x;
END;

BEGIN
    VAR
        var0main: CHAR;
        var1main: INTEGER;
        x, y: INTEGER;
        var5: INTEGER;

    var0main := ' ';
    var1main := 0;

    WHILE (((3+4) > 3) AND (x <> 0) OR (y <> 0)) DO
        var5 := Ord(' ') + 5 * 2^(3-7/(x+Ord(' ')));
    ENDWHILE;

    FOR x := 3 TO 32 DO
        var5 := Ord(' ') + 5 * 2^(3-7/(x+Ord(' ')));
        WHILE (((3+4) > 3) AND (x <> 0) OR (y <> 0)) DO
            var5 := Ord(' ') + 5 * 2^(3-7/(x+Ord(' ')));
        ENDWHILE;
    ENDFOR;

    IF ((var1main > Ord(' ')) AND ((3+4) > 2)) THEN
        var5 := Ord(' ') + 5 * 2^(3-7/(x+Ord(' ')));
    ELSEIF ((3+4) > 2) THEN
        var5 := Ord(' ');
    ELSE
        WHILE (((3+4) > 3) AND (x <> 0) OR (y <> 0)) DO
            var5 := Ord(' ') + 5 * 2^(3-7/(x+Ord(' ')));
        ENDWHILE;
    ENDIF;

    CASE ((3+4) > 3) AND (x <> 0) OR (y <> 0) OF
        (5=3):
            var5 := 7;
        (4<>3):
            var2 := var5;
        ELSE
            var1main := function(21,0,0);
    END;

    WRITELN('1-2 test');
    WRITELN('1-2 ', var0main, ' test ', var1main);
END.
