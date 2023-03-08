//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Unit1;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls,
    Forms, Dialogs, AlgolStdFrm, LMDControl, LMDBaseControl,
    LMDBaseGraphicButton, LMDCustomSpeedButton, LMDSpeedButton, StdCtrls,
    Mask, wwdbedit, wwDBEditRv, LMDCustomComponent, LMDSysInfo;

TYPE
    TFrmBase = CLASS(TAlgolStdFrm)
        ed: TwwDBEditRv;
        Memo1: TMemo;
        Button1: TButton;
        Memo2: TMemo;
        PROCEDURE Button1Click(Sender: TObject);
    PRIVATE
        PROCEDURE Cherche(path: STRING);
        FUNCTION trouve(Quoi, Ou: STRING): Boolean;
        PROCEDURE Analyse;
        { Private declarations }
    PROTECTED
        { Protected declarations }
    PUBLIC
        { Public declarations }
    PUBLISHED
        { Published declarations }
    END;

VAR
    FrmBase: TFrmBase;

    //------------------------------------------------------------------------------
    // Ressources strings
    //------------------------------------------------------------------------------
    //ResourceString

IMPLEMENTATION

//USES ConstStd;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TFrmBase.Cherche(path: STRING);
VAR
    f: tsearchRec;
BEGIN
    IF FindFirst(Path + '*.*', faanyfile, F) = 0 THEN
    BEGIN
        REPEAT
            IF (f.name <> '.') AND (f.name <> '..') THEN
            BEGIN
                IF f.attr AND fadirectory = fadirectory THEN
                    Cherche(Path + f.name + '\')
                ELSE
                BEGIN
                    IF Uppercase(extractfileext(f.name)) = '.DPK' THEN
                    BEGIN
                        Memo1.lines.add(Path + f.name);
                    END;
                END;
            END;
        UNTIL findnext(f) <> 0;
    END;
    FindClose(F);
END;

FUNCTION TFrmBase.trouve(Quoi, Ou: STRING): Boolean;
VAR
    Tsl: TstringList;
BEGIN
    Quoi := Uppercase(Quoi);
    tsl := TstringList.Create;
    tsl.loadfromfile(ou);
    IF pos(quoi, uppercase(tsl.text)) > 0 THEN
        result := true
    ELSE
        result := false;
    tsl.free;
END;

PROCEDURE TFrmBase.Analyse;
VAR
    Tsl: TstringList;
    i: integer;
    j: integer;
    S: STRING;

    DejaFait: TStringList;
    LesBpl: TStringList;
    LesFichiers: TStringList;

    PROCEDURE Analyse(Fichier: STRING);
    VAR
        Atraiter: TstringList;
        Tsl: TstringList;
        S: STRING;
        pass: STRING;
        LeFichier: STRING;
        i: integer;
        j: integer;
        ok: boolean;
    BEGIN
        DejaFait.Add(Uppercase(fichier));
        Memo1.Lines.Add(extractFileName(Fichier));
        Memo1.Update;
        Atraiter := TstringList.Create;
        TRY
            tsl := TstringList.Create;
            TRY
                tsl.loadFromFile(Fichier);
                S := Tsl.Text;
                WHILE (Pos('(*', S) > 0) OR (Pos('{', S) > 0) DO
                BEGIN
                    i := Pos('(*', S);
                    j := Pos('{', S);
                    IF i < 1 THEN i := 2147483640;
                    IF j < 1 THEN j := 2147483640;
                    IF i < j THEN
                    BEGIN
                        Pass := Copy(S, 1, Pos('(*', S) - 1);
                        delete(S, 1, Pos('(*', S));
                        delete(S, 1, Pos('*)', S) + 1);
                        S := Pass + S;
                    END
                    ELSE
                    BEGIN
                        Pass := Copy(S, 1, Pos('{', S) - 1);
                        delete(S, 1, Pos('{', S));
                        delete(S, 1, Pos('}', S));
                        S := Pass + S;
                    END;
                END;
                Tsl.Text := S;
                WHILE Tsl.Count > 0 DO
                BEGIN
                    IF Copy(trim(Tsl[0]), 1, 2) = '//' THEN
                        tsl.delete(0)
                    ELSE IF Copy(uppercase(trim(Tsl[0])), 1, 4) <> 'USES' THEN
                        tsl.delete(0)
                    ELSE
                    BEGIN
                        // analyse de la clause uses ;
                        S := trim(Tsl[0]);
                        delete(s, 1, 4); S := trim(S);
                        REPEAT
                            WHILE S <> '' DO
                            BEGIN
                                IF pos(',', S) > 0 THEN
                                BEGIN
                                    LeFichier := trim(uppercase(Copy(S, 1, pos(',', S) - 1)));
                                    delete(S, 1, pos(',', S));
                                END
                                ELSE IF pos(';', S) > 0 THEN
                                BEGIN
                                    LeFichier := trim(uppercase(Copy(S, 1, pos(';', S) - 1)));
                                    delete(S, 1, pos(';', S));
                                END
                                ELSE
                                BEGIN
                                    LeFichier := trim(uppercase(S));
                                    S := '';
                                END;
                                IF Pos(' IN ', LeFichier) > 0 THEN
                                BEGIN
                                    pass := Copy(LeFichier, Pos(' IN ', LeFichier) + 4, 255);
                                    LeFichier := trim(Copy(LeFichier, 1, Pos(' IN ', LeFichier) - 1));
                                END
                                ELSE
                                    Pass := '';
                                IF Copy(LeFichier, 1, 2) <> '//' THEN
                                BEGIN
                                    IF LesFichiers.IndexOf(LeFichier) = -1 THEN
                                    BEGIN
                                        ok := true;
                                        FOR i := 0 TO lesbpl.count - 1 DO
                                        BEGIN
                                            IF Copy(lesbpl[i], 1, pos(';', lesbpl[i])) = LeFichier + ';' THEN
                                            BEGIN
                                                ok := false;
                                                BREAK;
                                            END;
                                        END;
                                        IF ok THEN
                                        BEGIN
                                            memo2.lines.add(LeFichier + '  ' + Fichier);
                                            memo2.Update;
                                        END
                                        ELSE
                                            LesFichiers.Add(LeFichier);

                                        IF Pass <> '' THEN
                                        BEGIN
                                            IF Pos('{', Pass) > 0 THEN
                                                Pass := trim(Copy(Pass, 1, Pos('{', Pass) - 1));
                                            IF Pos(',', Pass) > 0 THEN
                                                Pass := trim(Copy(Pass, 1, Pos(',', Pass) - 1));
                                            IF Pos(';', Pass) > 0 THEN
                                                Pass := trim(Copy(Pass, 1, Pos(';', Pass) - 1));
                                            delete(Pass, 1, 1);
                                            delete(Pass, Length(Pass), 1);
                                            IF Pos('\', Pass) > 0 THEN
                                            BEGIN
                                                WHILE Pass[Length(pass)] <> '\' DO
                                                    delete(Pass, Length(pass), 1);
                                                IF fileexists('C:\Developpement\Ginkoia\source\' + Pass + LeFichier + '.Pas') THEN
                                                    Atraiter.Add('C:\Developpement\Ginkoia\source\' + Pass + LeFichier + '.Pas');
                                            END
                                            ELSE
                                            BEGIN
                                                IF fileexists('C:\Developpement\Ginkoia\source\' + LeFichier + '.Pas') THEN
                                                    Atraiter.Add('C:\Developpement\Ginkoia\source\' + LeFichier + '.Pas');
                                            END;
                                        END
                                        ELSE
                                        BEGIN
                                            IF fileexists('C:\Developpement\Ginkoia\source\' + LeFichier + '.Pas') THEN
                                                Atraiter.Add('C:\Developpement\Ginkoia\source\' + LeFichier + '.Pas');
                                        END;
                                    END;
                                END;
                                S := trim(S);
                            END;
                            IF pos(';', tsl[0]) > 0 THEN
                                BREAK;
                            tsl.delete(0);
                            S := trim(Tsl[0]);
                        UNTIL False;
                        tsl.delete(0);
                    END;
                END;
            FINALLY
                tsl.free;
            END;
            FOR i := 0 TO Atraiter.Count - 1 DO
            BEGIN
                IF DejaFait.IndexOf(Uppercase(Atraiter[i])) < 0 THEN
                    Analyse(Atraiter[i]);
            END;
        FINALLY
            Atraiter.free;
        END;
    END;

BEGIN
    LesBpl := TStringList.Create;
    LesFichiers := TStringList.Create;
    DejaFait := TStringList.Create;
    TRY
        tsl := tstringlist.create;
        TRY
            FOR i := 0 TO memo1.lines.count - 1 DO
            BEGIN
                tsl.loadfromfile(memo1.lines[i]);
                WHILE tsl.count > 0 DO
                BEGIN
                    IF tsl[0] <> 'contains' THEN
                        tsl.delete(0)
                    ELSE
                        BREAK;
                END;
                tsl.delete(0);
                WHILE (tsl.count > 0) AND (uppercase(trim(tsl[0])) <> 'END.') DO
                BEGIN
                    S := Tsl[0];
                    IF trim(s) <> '' THEN
                    BEGIN
                        J := Pos(' IN ', Uppercase(S));
                        IF j > 0 THEN
                        BEGIN
                            S := trim(Copy(S, 1, j - 1));
                        END
                        ELSE
                        BEGIN
                            IF pos(',', S) > 0 THEN
                                S := trim(Copy(S, 1, pos(',', S) - 1));
                            IF pos(';', S) > 0 THEN
                                S := trim(Copy(S, 1, pos(';', S) - 1));

                        END;
                        IF Pos('.', S) > 0 THEN
                            S := Copy(S, 1, Pos('.', S) - 1);
                        LesBpl.Add(Uppercase(S) + ';' + ExtractFileName(memo1.lines[i]));
                    END;
                    tsl.delete(0);
                END;
            END;
        FINALLY
            tsl.free;
        END;
        Memo1.Lines.Clear;
        LesBpl.Sort;
        Analyse('C:\Developpement\Ginkoia\source\Ginkoia.dpr');
        Analyse('C:\Developpement\Ginkoia\source\CaisseGinkoia.dpr');
    FINALLY
        LesFichiers.free;
        LesBpl.SaveToFile('C:\BPL.TXT');
        LesBpl.free;
        DejaFait.free;
    END;
END;

PROCEDURE TFrmBase.Button1Click(Sender: TObject);
VAR
    i: Integer;
BEGIN
    Memo1.lines.Clear;
    Memo2.lines.Clear;
    Cherche('C:\Developpement\Paquets standards\');
    Cherche('C:\Developpement\GINKOIA\source\');
    IF ed.text <> '' THEN
    BEGIN
        FOR i := 0 TO memo1.lines.count - 1 DO
        BEGIN
            IF trouve(ed.text, memo1.lines[i]) THEN
                memo2.lines.add(Extractfilepath(memo1.lines[i]));
        END;
    END
    ELSE
    BEGIN
        analyse;
    END;
END;

END.

