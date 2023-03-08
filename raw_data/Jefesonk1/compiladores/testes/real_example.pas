PROGRAM program;

TYPE
    withTypedef = RECORD
        var1, var2, var3: array [0..9] of CHAR;
        var4: CHAR;
        x, y, z: INTEGER;
    END;

    withoutTypedef = RECORD
        var1, var2, var3: array [0..9] of CHAR;
        var4: CHAR;
        x, y, z: INTEGER;
    END;

FUNCTION function1(a,b,c: INTEGER): INTEGER;
VAR
    var2: INTEGER;
BEGIN
    var2 := 7;
    function1 := x;
END;

FUNCTION function(x,y,z: INTEGER): INTEGER;
VAR
    var1, var2, var3, var4, var5: CHAR;
BEGIN
    var1 := '2';
    var2 := var3[0] + 5 * 2^(3-7/(Ord(var1)+Ord(var3[0])));
    var4 := var3[0];
    var5 := Chr(function1(Ord(var1),Ord(var2),Ord(var3[0])));

    function := 3;
END;

VAR
    var1, var2, var3, var4, var5, var6: CHAR;
    x, y, z: INTEGER;

BEGIN
    var5 := Chr(Ord(var3[0]) + 5 * 2^(3-7/(Ord(var1)+Ord(var3[0]))));

    WHILE(((3+4) > 3) AND (x <> 0) OR (y <> 0)) DO
        var5 := Chr(Ord(var3[0]) + 5 * 2^(3-7/(Ord(var1)+Ord(var3[0]))));
    ENDWHILE;

    FOR x := 3 TO 32 DO
        var5 := Chr(Ord(var3[0]) + 5 * 2^(3-7/(Ord(var1)+Ord(var3[0]))));
        WHILE(((3+4) > 3) AND (x <> 0) OR (y <> 0)) DO
            var5 := Chr(Ord(var3[0]) + 5 * 2^(3-7/(Ord(var1)+Ord(var3[0]))));
        ENDWHILE;
    END;

    IF((Ord(var1) > Ord(var2)) AND ((3+4) > 2)) THEN
        var5 := Chr(Ord(var3[0]) + 5 * 2^(3-7/(Ord(var1)+Ord(var3[0]))));
    ELSEIF ((3+4) > 2) THEN
        var5 := var3[0];
    ELSE
        WHILE(((3+4) > 3) AND (x <> 0) OR (y <> 0)) DO
            var5 := Chr(Ord(var3[0]) + 5 * 2^(3-7/(Ord(var1)+Ord(var3[0]))));
        ENDWHILE;
    ENDIF;

    CASE (((3+4) > 3) AND (x <> 0) OR (y <> 0)) OF
    5=3:
        var6 := '7';
    4<>3:
        var2 := Ord(var5);
    ELSE
        var1 := Chr(function(21, 21, 21));
    END;

    WriteLn('This is a print', var7, var3, var0[23]);
END. 
