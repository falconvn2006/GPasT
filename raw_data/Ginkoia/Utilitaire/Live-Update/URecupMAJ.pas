UNIT URecupMAJ;

INTERFACE

USES
    Windows,
    Umapping,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    ExtCtrls;

TYPE
    TFrm_RecupMaj = CLASS(TForm)
        Tim_MAJ: TTimer;
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE Tim_MAJTimer(Sender: TObject);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        Temps: DWord;
    END;

VAR
    Frm_RecupMaj: TFrm_RecupMaj;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TFrm_RecupMaj.FormCreate(Sender: TObject);
BEGIN
    Temps := GetTickCount;
END;

PROCEDURE TFrm_RecupMaj.Tim_MAJTimer(Sender: TObject);

    FUNCTION recherche(path, fichier: STRING): STRING;
    VAR
        f: tsearchRec;
    BEGIN
        result := '';
        IF findfirst(Path + '*.*', FaAnyFile, F) = 0 THEN
            REPEAT
                IF (f.name <> '.') AND (f.name <> '..') THEN
                BEGIN
                    IF f.Attr AND faDirectory = 0 THEN
                    BEGIN
                        IF uppercase(f.name) = uppercase(fichier) THEN
                        BEGIN
                            result := path + f.name;
                            break;
                        END;
                    END
                    ELSE
                    BEGIN
                        result := recherche(path + f.name + '\', fichier);
                        IF result <> '' THEN
                            break;
                    END;
                END;
            UNTIL findNext(f) <> 0;
        findclose(f);
    END;

VAR
    s: STRING;
    Path: STRING;
    NVPROG: STRING;
BEGIN
    IF ParamCount < 1 THEN
        Close
    ELSE IF MapGinkoia.MajAuto THEN
        EXIT
    ELSE
    BEGIN
        S := ParamStr(1);
        Path := ExtractFilePath(Application.exename);
        IF path[length(path)] <> '\' THEN
            Path := Path + '\';
        IF S = 'MAJ' THEN
        BEGIN
            IF fileexists(Path + 'BPL\Pqt_delphi.BPL1') THEN
            BEGIN
                IF CopyFile(Pchar(Path + 'BPL\Pqt_delphi.BPL1'), Pchar(Path + 'BPL\Pqt_delphi.BPL'), False) THEN
                    deletefile(Path + 'BPL\Pqt_delphi.BPL1');
            END;
            IF fileexists(Path + 'BPL\Pqt_comm.BPL1') THEN
            BEGIN
                IF CopyFile(Pchar(Path + 'BPL\Pqt_comm.BPL1'), Pchar(Path + 'BPL\Pqt_comm.BPL'), False) THEN
                    deletefile(Path + 'BPL\Pqt_comm.BPL1');
            END;
            IF fileexists(Path + 'BPL\Pqt_ibobjetct.BPL1') THEN
            BEGIN
                IF CopyFile(Pchar(Path + 'BPL\Pqt_ibobjetct.BPL1'), Pchar(Path + 'BPL\Pqt_ibobjetct.BPL'), False) THEN
                    deletefile(Path + 'BPL\Pqt_ibobjetct.BPL1');
            END;
            IF fileexists(Path + 'MajAuto.exe1') THEN
            BEGIN
                IF CopyFile(Pchar(Path + 'MajAuto.exe1'), Pchar(Path + 'MajAuto.exe'), False) THEN
                    deletefile(Path + 'BPL\MajAuto.exe1');
            END;
            Close;
        END
        ELSE
        BEGIN
            NVPROG := recherche(Path, 'MAJAUTO' + S + '.EXE');
            IF nvprog <> '' THEN
            BEGIN
                FileSetAttr(nvprog, 0);
                FileSetAttr(Path + 'MAJAUTO.EXE', 0);
                CopyFile(pchar(nvprog), Pchar(Path + 'MAJAUTO.EXE'), False);
                Winexec(PChar(Path + 'MAJAUTO.EXE AUTO'), 0);
            END;
            Close;
        END;
    END;
END;

END.

