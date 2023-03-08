UNIT ULogClient;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ExtCtrls;

TYPE
    TFrm_LogClient = CLASS(TForm)
        Panel1: TPanel;
        Button1: TButton;
        Button2: TButton;
        Button3: TButton;
        Button4: TButton;
        Lb: TListBox;
        Panel2: TPanel;
        Button5: TButton;
        Button6: TButton;
        Button7: TButton;
        Sd: TSaveDialog;
        PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
        PROCEDURE Button6Click(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormDestroy(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
        PROCEDURE Button3Click(Sender: TObject);
        PROCEDURE Button4Click(Sender: TObject);
        PROCEDURE Button5Click(Sender: TObject);
        PROCEDURE Button7Click(Sender: TObject);
    PRIVATE
        FUNCTION ChercheVersion(Num: STRING): STRING;
        PROCEDURE ErreurExport(Tsl: TstringList);
        PROCEDURE MAJExport(tsl: TstringList);
        PROCEDURE ScriptExport(Tsl: TstringList);
        PROCEDURE ConnexionExport(Tsl: TStringList);
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        ListClient: TstringList;
        Logs: TstringList;
        MAJ: TStringList;
        Specif: TStringList;
        Version: TStringList;
    END;

VAR
    Frm_LogClient: TFrm_LogClient;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TFrm_LogClient.FormClose(Sender: TObject;
    VAR Action: TCloseAction);
BEGIN
    Action := CaFree;
END;

PROCEDURE TFrm_LogClient.Button6Click(Sender: TObject);
BEGIN
    Close;
END;

PROCEDURE TFrm_LogClient.FormCreate(Sender: TObject);
BEGIN
    ListClient := TstringList.Create;
    Logs := TstringList.Create;
    MAJ := TStringList.Create;
    Specif := TStringList.Create;
    version := TStringList.Create;
    TRY ListClient.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename))+'LesClients.txt')EXCEPT END;
    TRY Logs.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename))+'LiveUpServeur.Log')EXCEPT END;
    TRY MAJ.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename))+'Clients.txt')EXCEPT END;
    TRY Specif.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename))+'SpeClients.txt')EXCEPT END;
    TRY version.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename))+'version.txt')EXCEPT END;
    Logs.Sort;
END;

PROCEDURE TFrm_LogClient.FormDestroy(Sender: TObject);
BEGIN
    ListClient.free;
    Logs.free;
    MAJ.free;
    Specif.free;
    version.free;
END;

FUNCTION ChaineSuivante(VAR s: STRING): STRING;
BEGIN
    IF pos(';', S) > 0 THEN
    BEGIN
        result := Copy(S, 1, pos(';', S) - 1);
        delete(s, 1, pos(';', s));
    END
    ELSE
    BEGIN
        result := s;
        s := '';
    END;
END;

FUNCTION formatstr(S: STRING; Taille: integer): STRING;
BEGIN
    result := copy(s, 1, taille);
    WHILE length(result) < taille DO
        result := result + ' ';
END;

FUNCTION TFrm_LogClient.ChercheVersion(Num: STRING): STRING;
VAR
    i: integer;
    s,
        pass: STRING;
    s1, s2, s3, s4: Integer;
    A1, A2, A3, A4: Integer;
BEGIN
    IF (num = '') OR (Pos('.', Num) = 0) THEN
        result := '???'
    ELSE
    BEGIN
        S1 := Strtoint(trim(Copy(Num, 1, pos('.', Num) - 1))); delete(num, 1, Pos('.', Num));
        S2 := Strtoint(trim(Copy(Num, 1, pos('.', Num) - 1))); delete(num, 1, Pos('.', Num));
        S3 := Strtoint(trim(Copy(Num, 1, pos('.', Num) - 1))); delete(num, 1, Pos('.', Num));
        S4 := Strtoint(trim(Num));
        result := 'Mauvaise version';
        FOR i := 0 TO version.count - 1 DO
        BEGIN
            s := version[i];
            Pass := ChaineSuivante(S);
            A1 := Strtoint(trim(Copy(S, 1, pos('.', S) - 1))); delete(S, 1, Pos('.', S));
            A2 := Strtoint(trim(Copy(S, 1, pos('.', S) - 1))); delete(S, 1, Pos('.', S));
            A3 := Strtoint(trim(Copy(S, 1, pos('.', S) - 1))); delete(S, 1, Pos('.', S));
            A4 := Strtoint(trim(S));
            IF (S1 = A1) AND (s2 = a2) AND (s3 = a3) AND (s4 = a4) THEN
            BEGIN
                result := Pass;
                break;
            END;
        END;
    END;
END;

FUNCTION VersionInt64(Pass: STRING): Int64;
VAR
    A, B, C, D: Integer;
BEGIN
    A := Strtoint(Copy(Pass, 1, pos('.', Pass) - 1)); delete(pass, 1, pos('.', Pass));
    B := Strtoint(Copy(Pass, 1, pos('.', Pass) - 1)); delete(pass, 1, pos('.', Pass));
    C := Strtoint(Copy(Pass, 1, pos('.', Pass) - 1)); delete(pass, 1, pos('.', Pass));
    D := Strtoint(Pass);
    Result := A; Result := Result * 100;
    Result := Result + B; Result := Result * 1000;
    Result := Result + C; Result := Result * 10000;
    Result := Result + D;
END;

PROCEDURE TFrm_LogClient.ConnexionExport(Tsl: TStringList);
VAR
    i, j: integer;
    ip: STRING;
    LaDate: STRING;
    mag: STRING;
    Clt: STRING;
    pass: STRING;
    s: STRING;
    VER: STRING;
    toto: STRING;
BEGIN
    FOR i := 0 TO ListClient.count - 1 DO
    BEGIN
        S := ListClient[i];
        Clt := ChaineSuivante(S);
        WHILE s <> '' DO
        BEGIN
            Mag := ChaineSuivante(S);
            LaDate := '01/01/2000';
            IP := ''; VER := '';
            FOR j := 0 TO Logs.Count - 1 DO
            BEGIN
                IF Copy(logs[j], 1, Pos(';', logs[j]) - 1) = Mag THEN
                BEGIN
                    Pass := logs[j];
                    ChaineSuivante(Pass);
                    IF copy(pass, 1, 3) = 'IP;' THEN
                    BEGIN
                        ChaineSuivante(Pass);
                        IF StrToDateTime(LaDate) < StrToDateTime(copy(pass, Pos(';', pass) + 1, 255)) THEN
                        BEGIN
                            IP := ChaineSuivante(Pass);
                            LaDate := ChaineSuivante(Pass);
                        END;
                    END
                    ELSE IF (Copy(PASS, 1, 4) = 'MAJ;') OR (Copy(PASS, 1, 4) = 'VER;') THEN
                    BEGIN
                        ChaineSuivante(Pass);
                        toto := ChaineSuivante(Pass);
                        IF ver = '' THEN
                            ver := toto
                        ELSE
                        BEGIN
                            IF VersionInt64(toto) > VersionInt64(Ver) THEN
                                VER := toto;
                        END;
                    END;
                END;
            END;
            IF IP <> '' THEN
            BEGIN
                LaDate := FormatDatetime('DD/MM/YYYY HH:MM', StrToDateTime(LaDate));
                tsl.add(CLT + ';' + MAG + ';' + LaDate + ';' + IP + ';' + ChercheVersion(VER));
            END
            ELSE
            BEGIN
                tsl.add(CLT + ';' + MAG + ';' + 'Pas de connexion');
            END;
        END;
    END;
END;

PROCEDURE TFrm_LogClient.Button1Click(Sender: TObject);
VAR
    i, j: integer;
    ip: STRING;
    LaDate: STRING;
    mag: STRING;
    Clt: STRING;
    pass: STRING;
    s: STRING;
    VER: STRING;
    toto: STRING;
BEGIN
    Button5.Tag := 1;
    Lb.Items.Clear;
    FOR i := 0 TO ListClient.count - 1 DO
    BEGIN
        S := ListClient[i];
        Clt := ChaineSuivante(S);
        WHILE s <> '' DO
        BEGIN
            Mag := ChaineSuivante(S);
            LaDate := '01/01/2000';
            IP := ''; VER := '';
            FOR j := 0 TO Logs.Count - 1 DO
            BEGIN
                IF Copy(logs[j], 1, Pos(';', logs[j]) - 1) = Mag THEN
                BEGIN
                    Pass := logs[j];
                    ChaineSuivante(Pass);
                    IF copy(pass, 1, 3) = 'IP;' THEN
                    BEGIN
                        ChaineSuivante(Pass);
                        IF StrToDateTime(LaDate) < StrToDateTime(copy(pass, Pos(';', pass) + 1, 255)) THEN
                        BEGIN
                            IP := ChaineSuivante(Pass);
                            LaDate := ChaineSuivante(Pass);
                        END;
                    END
                    ELSE IF (Copy(PASS, 1, 4) = 'MAJ;') OR (Copy(PASS, 1, 4) = 'VER;') THEN
                    BEGIN
                        ChaineSuivante(Pass);
                        toto := ChaineSuivante(Pass);
                        IF ver = '' THEN
                            ver := toto
                        ELSE
                        BEGIN
                            IF VersionInt64(toto) > VersionInt64(Ver) THEN
                                VER := toto;
                        END;
                    END;
                END;
            END;
            IF IP <> '' THEN
            BEGIN
                LaDate := FormatDatetime('DD/MM/YYYY HH:MM', StrToDateTime(LaDate));
                Lb.Items.AddObject(formatstr(CLT, 10) + formatstr(MAG, 20) + formatstr(LaDate, 17) + '-> ' + IP + '||' + ChercheVersion(VER), Pointer(-2));
            END
            ELSE
                Lb.Items.AddObject(formatstr(CLT, 10) + formatstr(MAG, 20) + 'Pas de connexion', Pointer(-2));
        END;
    END;
END;

PROCEDURE TFrm_LogClient.ErreurExport(Tsl: TstringList);
VAR
    i, j: integer;
    ip: STRING;
    LaDate: STRING;
    mag: STRING;
    Clt: STRING;
    Actu: STRING;
    pass: STRING;
    s: STRING;
BEGIN
    FOR j := 0 TO Logs.Count - 1 DO
    BEGIN
        Pass := logs[j];
        Actu := ChaineSuivante(Pass);
        IF actu = 'NOGOOD' THEN
        BEGIN
            Actu := ChaineSuivante(Pass);
            tsl.add('Magasin non ref;' + Actu + ';' + ChaineSuivante(Pass));
        END;
        IF ACTU = 'PROBZIP' THEN
        BEGIN
            Actu := ChaineSuivante(Pass);
            mag := ChaineSuivante(Pass);
            tsl.add('Prob sur ZIP;' + Actu + ';' + ChaineSuivante(Pass));
        END;
    END;
    FOR i := 0 TO ListClient.count - 1 DO
    BEGIN
        S := ListClient[i];
        Clt := ChaineSuivante(S);
        WHILE s <> '' DO
        BEGIN
            Mag := ChaineSuivante(S);
            LaDate := '01/01/2000';
            IP := '';
            FOR j := 0 TO Logs.Count - 1 DO
            BEGIN
                Pass := logs[j];
                Actu := ChaineSuivante(Pass);
                IF Actu = Mag THEN
                BEGIN
                    Actu := ChaineSuivante(Pass);
                    IF Actu = 'ERREUR VER' THEN
                    BEGIN
                        IP := ChaineSuivante(Pass);
                        LaDate := ChaineSuivante(Pass);
                        tsl.add(CLT + ';' + MAG + ';' + LaDate + ';' + IP);
                    END;
                    IF Actu = 'ERR SCRIPT' THEN
                    BEGIN
                        IP := ChaineSuivante(Pass);
                        LaDate := ChaineSuivante(Pass);
                        tsl.add(CLT + ';' + MAG + ';' + LaDate + ';' + IP);
                    END;
                END;
            END;
        END;
    END;
END;

PROCEDURE TFrm_LogClient.Button2Click(Sender: TObject);
VAR
    i, j: integer;
    ip: STRING;
    LaDate: STRING;
    mag: STRING;
    Clt: STRING;
    Actu: STRING;
    pass: STRING;
    s: STRING;
BEGIN
    Button5.Tag := 2;
    Lb.Items.Clear;
    FOR j := 0 TO Logs.Count - 1 DO
    BEGIN
        Pass := logs[j];
        Actu := ChaineSuivante(Pass);
        IF actu = 'NOGOOD' THEN
        BEGIN
            Actu := ChaineSuivante(Pass);
            Lb.Items.AddObject('Magasin non ref  ' + Actu + '  ' + ChaineSuivante(Pass), pointer(j));
        END;
        IF ACTU = 'PROBZIP' THEN
        BEGIN
            Actu := ChaineSuivante(Pass);
            mag := ChaineSuivante(Pass);
            Lb.Items.AddObject('Prob sur ZIP  ' + Actu + '  ' + ChaineSuivante(Pass), pointer(j));
        END;
    END;
    FOR i := 0 TO ListClient.count - 1 DO
    BEGIN
        S := ListClient[i];
        Clt := ChaineSuivante(S);
        WHILE s <> '' DO
        BEGIN
            Mag := ChaineSuivante(S);
            LaDate := '01/01/2000';
            IP := '';
            FOR j := 0 TO Logs.Count - 1 DO
            BEGIN
                Pass := logs[j];
                Actu := ChaineSuivante(Pass);
                IF Actu = Mag THEN
                BEGIN
                    Actu := ChaineSuivante(Pass);
                    IF Actu = 'ERREUR VER' THEN
                    BEGIN
                        IP := ChaineSuivante(Pass);
                        LaDate := ChaineSuivante(Pass);
                        Lb.Items.AddObject(formatstr(CLT, 15) + formatstr(MAG, 20) + formatstr(LaDate, 25) + IP, Pointer(j));
                    END;
                    IF Actu = 'ERR SCRIPT' THEN
                    BEGIN
                        IP := ChaineSuivante(Pass);
                        LaDate := ChaineSuivante(Pass);
                        Lb.Items.AddObject(formatstr(CLT, 15) + formatstr(MAG, 20) + formatstr(LaDate, 25) + IP, Pointer(j));
                    END;
                END;
            END;
        END;
    END;
END;

PROCEDURE TFrm_LogClient.MAJExport(tsl: TstringList);
VAR
    i, j: integer;
    ip: STRING;
    PassDate: STRING;
    LaVersion: STRING;
    lemag: STRING;
    LaDate: STRING;
    mag: STRING;
    Clt: STRING;
    actu: STRING;
    pass: STRING;
    s: STRING;
BEGIN
    FOR i := 0 TO ListClient.count - 1 DO
    BEGIN
        S := ListClient[i];
        Clt := ChaineSuivante(S);
        WHILE s <> '' DO
        BEGIN
            Mag := ChaineSuivante(S);
            LaDate := '01/01/2000';
            LaVersion := '';
            IP := '';
            FOR j := 0 TO MAJ.Count - 1 DO
            BEGIN
                Pass := Maj[j];
                LeMag := ChaineSuivante(Pass);
                IF mag = LeMag THEN
                BEGIN
                    LaVersion := ChaineSuivante(Pass);
                    Break;
                END;
            END;

            FOR j := 0 TO Logs.Count - 1 DO
            BEGIN
                Pass := logs[j];
                LeMag := ChaineSuivante(Pass);
                IF LeMag = Mag THEN
                BEGIN
                    Actu := ChaineSuivante(Pass);
                    IF (Actu = 'VER') OR (Actu = 'MAJ') THEN
                    BEGIN
                        Actu := ChaineSuivante(Pass);
                        PassDate := ChaineSuivante(Pass);
                        IF StrToDateTime(LaDate) < StrToDateTime(PassDate) THEN
                        BEGIN
                            LaDate := PassDate;
                            Ip := Actu
                        END;
                    END
                END;
            END;
            IF (LaVersion <> '') AND (ChercheVersion(LaVersion) <> ChercheVersion(Ip)) THEN
            BEGIN
                tsl.add(CLT + ';' + MAG + ';' + ChercheVersion(LaVersion) + ';' + ChercheVersion(IP));
            END;
        END;
    END;
END;

PROCEDURE TFrm_LogClient.Button3Click(Sender: TObject);
VAR
    i, j: integer;
    ip: STRING;
    PassDate: STRING;
    LaVersion: STRING;
    lemag: STRING;
    LaDate: STRING;
    mag: STRING;
    Clt: STRING;
    actu: STRING;
    pass: STRING;
    s: STRING;
BEGIN
    Button5.Tag := 3;
    Lb.Items.Clear;
    FOR i := 0 TO ListClient.count - 1 DO
    BEGIN
        S := ListClient[i];
        Clt := ChaineSuivante(S);
        WHILE s <> '' DO
        BEGIN
            Mag := ChaineSuivante(S);
            LaDate := '01/01/2000';
            LaVersion := '';
            IP := '';
            FOR j := 0 TO MAJ.Count - 1 DO
            BEGIN
                Pass := Maj[j];
                LeMag := ChaineSuivante(Pass);
                IF mag = LeMag THEN
                BEGIN
                    LaVersion := ChaineSuivante(Pass);
                    Break;
                END;
            END;

            FOR j := 0 TO Logs.Count - 1 DO
            BEGIN
                Pass := logs[j];
                LeMag := ChaineSuivante(Pass);
                IF LeMag = Mag THEN
                BEGIN
                    Actu := ChaineSuivante(Pass);
                    IF (Actu = 'VER') OR (Actu = 'MAJ') THEN
                    BEGIN
                        Actu := ChaineSuivante(Pass);
                        PassDate := ChaineSuivante(Pass);
                        IF StrToDateTime(LaDate) < StrToDateTime(PassDate) THEN
                        BEGIN
                            LaDate := PassDate;
                            Ip := Actu
                        END;
                    END
                END;
            END;
            IF (LaVersion <> '') AND (ChercheVersion(LaVersion) <> ChercheVersion(Ip)) THEN
                Lb.Items.AddObject(formatstr(CLT, 15) + formatstr(MAG, 20) + ChercheVersion(LaVersion) + '/' + ChercheVersion(IP), Pointer(-2));
        END;
    END;
END;

PROCEDURE TFrm_LogClient.ScriptExport(Tsl: TstringList);
VAR
    i, j: integer;
    ip: STRING;
    LaVersion: STRING;
    lemag: STRING;
    LaDate: STRING;
    mag: STRING;
    Clt: STRING;
    pass: STRING;
    s: STRING;
BEGIN
    FOR i := 0 TO ListClient.count - 1 DO
    BEGIN
        S := ListClient[i];
        Clt := ChaineSuivante(S);
        WHILE s <> '' DO
        BEGIN
            Mag := ChaineSuivante(S);
            LaDate := '01/01/2000';
            LaVersion := '';
            IP := '';
            FOR j := 0 TO Specif.Count - 1 DO
            BEGIN
                Pass := Specif[j];
                LeMag := ChaineSuivante(Pass);
                IF mag = LeMag THEN
                BEGIN
                    LaVersion := ChaineSuivante(Pass);
                    Tsl.Add(CLT + ';' + MAG + ';' + LaVersion);
                END;
            END;
        END;
    END;
END;

PROCEDURE TFrm_LogClient.Button4Click(Sender: TObject);
VAR
    i, j: integer;
    ip: STRING;
    LaVersion: STRING;
    lemag: STRING;
    LaDate: STRING;
    mag: STRING;
    Clt: STRING;
    pass: STRING;
    s: STRING;
BEGIN
    Button5.Tag := 4;
    Lb.Items.Clear;
    FOR i := 0 TO ListClient.count - 1 DO
    BEGIN
        S := ListClient[i];
        Clt := ChaineSuivante(S);
        WHILE s <> '' DO
        BEGIN
            Mag := ChaineSuivante(S);
            LaDate := '01/01/2000';
            LaVersion := '';
            IP := '';
            FOR j := 0 TO Specif.Count - 1 DO
            BEGIN
                Pass := Specif[j];
                LeMag := ChaineSuivante(Pass);
                IF mag = LeMag THEN
                BEGIN
                    LaVersion := ChaineSuivante(Pass);
                    Lb.Items.AddObject(formatstr(CLT, 15) + formatstr(MAG, 20) + LaVersion, Pointer(-2));
                END;
            END;
        END;
    END;
END;

PROCEDURE TFrm_LogClient.Button5Click(Sender: TObject);
VAR
    I: Integer;
    s: STRING;
    tsl: tstringList;
BEGIN
    IF Lb.ItemIndex >= 0 THEN
    BEGIN
        i := Integer(Lb.Items.Objects[Lb.ItemIndex]);
        IF i > -1 THEN
        BEGIN
            S := Logs[i];
            Logs.delete(i);
            tsl := tstringList.create;
            TRY
                TRY tsl.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename))+'LiveUpServeur.Log')EXCEPT END;
                FOR i := 0 TO tsl.count - 1 DO
                BEGIN
                    IF s = tsl[i] THEN
                    BEGIN
                        tsl.delete(i);
                        BREAK;
                    END
                END;
                tsl.SaveToFile(IncludeTrailingBackslash(extractfilePath(application.exename))+'LiveUpServeur.Log')
            FINALLY
                tsl.free;
            END;
            Lb.Items.Delete(Lb.ItemIndex);
        END;
    END;
END;

PROCEDURE TFrm_LogClient.Button7Click(Sender: TObject);
VAR
    Tsl: TStringList;
BEGIN
//
    Sd.InitialDir := extractfilePath(application.exename);
    IF sd.execute THEN
    BEGIN
        tsl := tstringList.create;
        IF Button5.Tag = 1 THEN
        BEGIN
            ConnexionExport(Tsl);
        END
        ELSE IF Button5.Tag = 4 THEN
        BEGIN
            ScriptExport(Tsl);
        END
        ELSE IF Button5.Tag = 3 THEN
        BEGIN
            MAJExport(Tsl);
        END
        ELSE IF Button5.Tag = 2 THEN
        BEGIN
            ErreurExport(Tsl);
        END;
        tsl.savetofile(Sd.FileName);
        tsl.free;
    END;
END;

END.

