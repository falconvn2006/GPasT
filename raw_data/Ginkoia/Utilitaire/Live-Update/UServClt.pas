UNIT UServClt;

INTERFACE

USES
    UCltNom,
    iniFiles,
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    StdCtrls,
    VCLUnZip,
    VCLZip,
    Psock,
    NMFtp,
    psvDialogs;

TYPE
    TFrm_GestClients = CLASS(TForm)
        Lb_Clt: TListBox;
        Label1: TLabel;
        Button1: TButton;
        Lb_Mag: TListBox;
        Label2: TLabel;
        Button2: TButton;
        Lb_Log: TListBox;
        Label3: TLabel;
        Label4: TLabel;
        Lb_Ver: TListBox;
        Button3: TButton;
        Button4: TButton;
        Button5: TButton;
        Button6: TButton;
        Button7: TButton;
        Button8: TButton;
        Button9: TButton;
        DiaDir: TpsvBrowseFolderDialog;
        OD: TOpenDialog;
        OD_SQL: TOpenDialog;
        ZIP: TVCLZip;
        ftp: TNMFTP;
        Button10: TButton;
        Button11: TButton;
        OD_Exe: TOpenDialog;
        OD_zip: TOpenDialog;
        PROCEDURE Button8Click(Sender: TObject);
        PROCEDURE Button9Click(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE Lb_VerKeyUp(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
        PROCEDURE FormDestroy(Sender: TObject);
        PROCEDURE Lb_CltClick(Sender: TObject);
        PROCEDURE Lb_MagClick(Sender: TObject);
        PROCEDURE Button3Click(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
        PROCEDURE Button4Click(Sender: TObject);
        PROCEDURE Button5Click(Sender: TObject);
        PROCEDURE Button6Click(Sender: TObject);
        PROCEDURE Button7Click(Sender: TObject);
        PROCEDURE Button10Click(Sender: TObject);
        PROCEDURE Button11Click(Sender: TObject);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        ftpserveur,
            portserveur,
            CheminFtp,
            PathVersion: STRING;
        LesClients: TstringList;
    END;

VAR
    Frm_GestClients: TFrm_GestClients;

IMPLEMENTATION

{$R *.DFM}

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

PROCEDURE TFrm_GestClients.Button8Click(Sender: TObject);
BEGIN
    Close;
END;

PROCEDURE TFrm_GestClients.Button9Click(Sender: TObject);
VAR
    S, s1: STRING;
    f: tsearchRec;
    ttsl,
        tsl: tstringList;
    i, j: integer;
    ini: tinifile;
BEGIN
    diadir.Caption := 'Rèpertoire de Live Update';
    IF diadir.execute THEN
    BEGIN
        PathVersion := DiaDir.FolderName;
        ini := tinifile.create(ChangeFileExt(application.exename, '.ini'));
        TRY
            ini.Writestring('Version', 'Path', PathVersion);
        FINALLY
            ini.free;
        END;
        tsl := tstringList.Create;
        TRY
            tsl.loadfromfile(extractfilePath(application.exename) + 'Version.txt');
        EXCEPT
        END;
        TRY
            S := DiaDir.FolderName;
            IF findfirst(IncludeTrailingBackslash(S) + '*.*', FaDirectory, F) = 0 THEN
            BEGIN
                REPEAT
                    IF (f.name <> '.') AND (f.name <> '..') AND (F.Attr AND FaDirectory = FaDirectory) THEN
                    BEGIN
                        S := Uppercase(F.Name);
                        IF copy(S, 1, 1) = 'V' THEN
                        BEGIN
                            j := -1;
                            FOR i := 0 TO tsl.count - 1 DO
                                IF copy(tsl[i], 1, pos(';', tsl[i]) - 1) = uppercase(S) THEN
                                BEGIN
                                    j := i;
                                    break;
                                END;
                            IF j = -1 THEN
                            BEGIN
                                ttsl := tstringList.Create;
                                ttsl.LoadFromFile(IncludeTrailingBackslash(DiaDir.FolderName) + IncludeTrailingBackslash(S) + 'Script.scr');
                                i := ttsl.count - 1;
                                WHILE Copy(ttsl[i], 1, 9) <> '<RELEASE>' DO
                                    dec(i);
                                s1 := ttsl[i];
                                ttsl.free;
                                delete(s1, 1, 9);
                                tsl.add(uppercase(s) + ';' + s1);
                            END;
                        END;
                    END;
                UNTIL findnext(f) <> 0;
            END;
            findclose(f);
            tsl.SaveTofile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Version.txt');
            Lb_Ver.Items.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Version.txt');
        FINALLY
            tsl.free;
        END;
    END;
END;

PROCEDURE TFrm_GestClients.FormCreate(Sender: TObject);
VAR
    i: integer;
BEGIN
    TRY
        Lb_Ver.Items.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Version.txt');
    EXCEPT END;
    LesClients := TstringList.create;
    TRY LesClients.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'LesClients.txt');
    EXCEPT END;
    lb_clt.items.clear;
    FOR i := 0 TO LesClients.count - 1 DO
        lb_clt.items.Add(copy(LesClients[i], 1, Pos(';', LesClients[i]) - 1));
END;

PROCEDURE TFrm_GestClients.Lb_VerKeyUp(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
BEGIN
    IF key = vk_delete THEN
    BEGIN
        Lb_Ver.Items.delete(Lb_Ver.ItemIndex);
        Lb_Ver.Items.SavetoFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Version.txt');
    END;
END;

PROCEDURE TFrm_GestClients.FormClose(Sender: TObject;
    VAR Action: TCloseAction);
BEGIN
    Action := Cafree;
END;

PROCEDURE TFrm_GestClients.FormDestroy(Sender: TObject);
BEGIN
    LesClients.free;
END;

PROCEDURE TFrm_GestClients.Lb_CltClick(Sender: TObject);
VAR
    s: STRING;
BEGIN
    IF lb_clt.itemIndex >= 0 THEN
    BEGIN
        Lb_Ver.itemindex := -1;
        S := LesClients[lb_clt.itemIndex];
        delete(s, 1, pos(';', S));
        Lb_Mag.items.clear;
        WHILE pos(';', S) > 0 DO
        BEGIN
            Lb_Mag.items.Add(copy(S, 1, Pos(';', S) - 1));
            delete(s, 1, pos(';', S));
        END;
        Lb_Mag.items.Add(s);
    END;
END;

PROCEDURE TFrm_GestClients.Lb_MagClick(Sender: TObject);
VAR
    tsl: TStringList;
    j: integer;
    i: integer;
    s1: STRING;
    s: STRING;
BEGIN
    Lb_Log.items.clear;
    IF Lb_Mag.ItemIndex >= 0 THEN
    BEGIN
        Lb_Ver.itemindex := -1;
        tsl := TStringList.create;
        TRY
            TRY tsl.loadfromfile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'clients.txt'); EXCEPT END;
            FOR i := 0 TO tsl.count - 1 DO
            BEGIN
                S := tsl[i];
                IF pos(';', S) > 0 THEN
                BEGIN
                    S := Copy(S, 1, pos(';', S) - 1);
                    IF S = Lb_MAG.Items[Lb_Mag.ItemIndex] THEN
                    BEGIN
                        S := tsl[i];
                        Delete(S, 1, Pos(';', S)); // num version
                        S := Copy(S, 1, pos(';', S) - 1); // enleve la date
                        FOR j := 0 TO Lb_Ver.Items.Count - 1 DO
                        BEGIN
                            s1 := Lb_Ver.Items[j];
                            delete(s1, 1, pos(';', S1));
                            IF s = s1 THEN
                            BEGIN
                                Lb_Ver.ItemIndex := j;
                                break;
                            END;
                        END;
                        break;
                    END;
                END;
            END;

            TRY tsl.loadfromfile(ChangeFileExt(application.exename, '.LOG'))EXCEPT END;
            FOR i := 0 TO tsl.count - 1 DO
            BEGIN
                IF copy(tsl[i], 1, pos(';', tsl[i]) - 1) = Lb_Mag.Items[Lb_Mag.ItemIndex] THEN
                    lb_log.items.add(tsl[i]);
            END;
        FINALLY
            tsl.free;
        END;
    END;
END;

PROCEDURE TFrm_GestClients.Button3Click(Sender: TObject);
VAR
    S: STRING;
    mag: STRING;
    tsl: TStringList;
    bcl_mag: integer;
    i: integer;
    j: integer;
    lesmag: STRING;
    LeMag: STRING;
    Ajouter: boolean;
    pass: STRING;
    A, B, C, D: Integer;
    Suite: Int64;
    Valeur: Int64;
BEGIN
    IF (Lb_Ver.ItemIndex >= 0) AND (Lb_Clt.SelCount > 0) THEN
    BEGIN
        Application.CreateForm(TDial_Cltnom, Dial_Cltnom);
        TRY
            Dial_Cltnom.Caption := 'Date de MAJ';
            Dial_Cltnom.Edit1.Text := FormatDateTime('dd/mm/yyyy', date);
            IF Dial_Cltnom.ShowModal = MrOk THEN
            BEGIN
                FOR bcl_mag := 0 TO Lb_Clt.Items.Count - 1 DO
                BEGIN
                    IF Lb_Clt.Selected[bcl_mag] THEN
                    BEGIN
                        lesmag := LesClients[bcl_mag];
                        delete(lesmag, 1, pos(';', lesmag));
                        WHILE LesMag <> '' DO
                        BEGIN
                            IF pos(';', LesMag) > 0 THEN
                            BEGIN
                                lemag := Copy(LesMag, 1, pos(';', LesMag) - 1);
                                delete(LesMag, 1, pos(';', LesMag));
                            END
                            ELSE
                            BEGIN
                                LeMag := LesMag;
                                LesMag := '';
                            END;
                            Ajouter := true;
                            S := Lb_Ver.Items[Lb_Ver.ItemIndex];
                            delete(s, 1, pos(';', S));
                            Pass := S;
                            A := Strtoint(Copy(Pass, 1, pos('.', Pass) - 1)); delete(pass, 1, pos('.', Pass));
                            B := Strtoint(Copy(Pass, 1, pos('.', Pass) - 1)); delete(pass, 1, pos('.', Pass));
                            C := Strtoint(Copy(Pass, 1, pos('.', Pass) - 1)); delete(pass, 1, pos('.', Pass));
                            D := Strtoint(Pass); delete(pass, 1, pos('.', Pass));
                            Valeur := A; Valeur := Valeur * 100;
                            Valeur := Valeur + B; Valeur := Valeur * 1000;
                            Valeur := Valeur + C; Valeur := Valeur * 10000;
                            Valeur := Valeur + D;
                            tsl := tstringList.create;
                            TRY
                                TRY tsl.loadfromfile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'clients.txt'); EXCEPT END;
                                FOR i := 0 TO Lb_Mag.items.count - 1 DO
                                BEGIN
                                    j := 0;
                                    WHILE j < tsl.count DO
                                    BEGIN
                                        mag := tsl[j];
                                        IF pos(';', mag) < 1 THEN
                                            tsl.delete(j)
                                        ELSE
                                        BEGIN
                                            delete(mag, pos(';', mag), 255);
                                            IF mag = LeMag THEN
                                            BEGIN
                                                Pass := Tsl[j];
                                                delete(pass, 1, pos(';', Pass));
                                                Pass := Copy(Pass, 1, pos(';', Pass) - 1);
                                                A := Strtoint(Copy(Pass, 1, pos('.', Pass) - 1)); delete(pass, 1, pos('.', Pass));
                                                B := Strtoint(Copy(Pass, 1, pos('.', Pass) - 1)); delete(pass, 1, pos('.', Pass));
                                                C := Strtoint(Copy(Pass, 1, pos('.', Pass) - 1)); delete(pass, 1, pos('.', Pass));
                                                D := Strtoint(Pass); delete(pass, 1, pos('.', Pass));
                                                Suite := A; Suite := Suite * 100;
                                                Suite := Suite + B; Suite := Suite * 1000;
                                                Suite := Suite + C; Suite := Suite * 10000;
                                                Suite := Suite + D;
                                                IF suite <= Valeur THEN
                                                    tsl.delete(j)
                                                ELSE
                                                BEGIN
                                                    Ajouter := false;
                                                    inc(j);
                                                END;
                                            END
                                            ELSE
                                                inc(j);
                                        END;
                                    END;
                                    IF ajouter THEN
                                        tsl.add(LeMag + ';' + S + ';' + Dial_Cltnom.Edit1.text);
                                END;
                                tsl.Savetofile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'clients.txt');
                            FINALLY
                                tsl.free;
                            END;
                        END;
                    END;
                END;
            END;
        FINALLY
            Dial_Cltnom.release;
        END;
    END;
END;

PROCEDURE TFrm_GestClients.Button2Click(Sender: TObject);
{
VAR
    mag: STRING;
    S: STRING;
    Tsl: TStringList;
    i: integer;
}
BEGIN
{
    IF Lb_Clt.itemIndex >= 0 THEN
    BEGIN
        IF OD.Execute THEN
        BEGIN
            data.databasename := od.filename;
            data.open;
            qry.open;
            qry.first;
            s := '';
            WHILE NOT qry.eof DO
            BEGIN
                S := S + ';' + Qry.fields[0].AsString;
                qry.next;
            END;
            data.close;
            mag := Lb_Clt.Items[Lb_Clt.itemIndex];
            S := Mag + S;
            Tsl := TstringList.create;
            TRY
                TRY tsl.loadFromFile(extractfilePath(application.exename) + '\LesClients.txt');
                EXCEPT END;
                FOR i := 0 TO tsl.count - 1 DO
                BEGIN
                    IF copy(tsl[i], 1, pos(';', tsl[i]) - 1) = mag THEN
                    BEGIN
                        tsl[i] := S;
                        Break;
                    END;
                END;
                tsl.SavetoFile(extractfilePath(application.exename) + '\LesClients.txt');
            FINALLY
                tsl.free;
            END;

        END;
    END;
    }
END;

PROCEDURE TFrm_GestClients.Button4Click(Sender: TObject);
VAR
    Tsl: TstringList;
    S: STRING;
    i: integer;
BEGIN
    IF Lb_Mag.itemindex >= 0 THEN
    BEGIN
        IF OD_SQL.execute THEN
        BEGIN
            S := IncludeTrailingBackslash(PathVersion) + extractFileName(OD_SQL.FileName);
            IF NOT fileexists(ChangeFileExt(S, '.zip')) THEN
            BEGIN
                CopyFile(pchar(OD_SQL.FileName), Pchar(S), False);
                FileSetAttr(Pchar(S), 0);
                Zip.FilesList.Clear;
                Zip.FilesList.ADD(s);

                S := ChangeFileExt(IncludeTrailingBackslash(PathVersion) + extractFileName(OD_SQL.FileName), '.ZIP');
                Zip.ZipName := S;
                Zip.Zip;
                Zip.FilesList.Clear;
                IF trim(CheminFtp) <> '' THEN
                BEGIN
                    CopyFile(Pchar(S), Pchar(CheminFtp + ChangeFileExt(extractFileName(OD_SQL.FileName), '.ZIP')), False);
                END
                ELSE
                BEGIN
                    ftp.Host := ftpserveur;
                    ftp.port := strtoint(portserveur);
                    ftp.Connect;
                    ftp.UpLoad(S, ExtractFileName(S));
                    ftp.Disconnect;
                END;
                S := IncludeTrailingBackslash(PathVersion) + extractFileName(OD_SQL.FileName);
                deletefile(s);
            END;
            Tsl := TstringList.create;
            S := Lb_Mag.Items[Lb_Mag.ItemIndex] + ';' + ExtractFileName(S);
            TRY
                TRY tsl.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt');
                EXCEPT END;
                i := 0;
                WHILE i < tsl.count DO
                BEGIN
                    IF copy(tsl[i], 1, Length(S)) = S THEN
                        tsl.delete(i)
                    ELSE
                        inc(i);
                END;
                tsl.Add(S);
                tsl.SavetoFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt');
            FINALLY
                tsl.free;
            END;
        END;
    END;
END;

PROCEDURE TFrm_GestClients.Button5Click(Sender: TObject);
VAR
    Tsl: TstringList;
    pass: STRING;
    S: STRING;
    bcl: integer;
    i: integer;
BEGIN
    IF Lb_Clt.itemindex >= 0 THEN
    BEGIN
        IF OD_SQL.execute THEN
        BEGIN
            S := IncludeTrailingBackslash(PathVersion) + extractFileName(OD_SQL.FileName);
            IF NOT fileexists(ChangeFileExt(S, '.zip')) THEN
            BEGIN
                CopyFile(pchar(OD_SQL.FileName), Pchar(S), False);
                FileSetAttr(Pchar(S), 0);
                Zip.FilesList.Clear;
                Zip.FilesList.ADD(s);

                S := ChangeFileExt(IncludeTrailingBackslash(PathVersion) + extractFileName(OD_SQL.FileName), '.ZIP');
                Zip.ZipName := S;
                Zip.Zip;
                Zip.FilesList.Clear;
                IF trim(CheminFtp) <> '' THEN
                BEGIN
                    CopyFile(Pchar(S), Pchar(CheminFtp + ChangeFileExt(extractFileName(OD_SQL.FileName), '.ZIP')), False);
                END
                ELSE
                BEGIN
                    ftp.Host := ftpserveur;
                    ftp.port := strtoint(portserveur);
                    ftp.Connect;
                    ftp.UpLoad(S, ExtractFileName(S));
                    ftp.Disconnect;
                END;
                S := IncludeTrailingBackslash(PathVersion) + extractFileName(OD_SQL.FileName);
                deletefile(s);
            END;
            Tsl := TstringList.create;
            TRY
                TRY tsl.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt');
                EXCEPT END;
                FOR bcl := 0 TO Lb_Mag.items.count - 1 DO
                BEGIN
                    Pass := Lb_Mag.Items[Bcl] + ';' + ExtractFileName(S);
                    i := 0;
                    WHILE i < tsl.count DO
                    BEGIN
                        IF copy(tsl[i], 1, Length(Pass)) = Pass THEN
                            tsl.delete(i)
                        ELSE
                            inc(i);
                    END;
                    tsl.Add(Pass);
                END;
                tsl.SavetoFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt');
            FINALLY
                tsl.free;
            END;
        END;
    END;
END;

PROCEDURE TFrm_GestClients.Button6Click(Sender: TObject);
VAR
    Tsl: TstringList;
    S: STRING;
    i: integer;
BEGIN
    IF Lb_Mag.itemindex >= 0 THEN
    BEGIN
        IF OD_EXE.execute THEN
        BEGIN
            S := IncludeTrailingBackslash(PathVersion) + extractFileName(OD_EXE.FileName);
            IF NOT fileexists(ChangeFileExt(S, '.zip')) THEN
            BEGIN
                CopyFile(pchar(OD_EXE.FileName), Pchar(S), False);
                FileSetAttr(Pchar(S), 0);
                Zip.FilesList.Clear;
                Zip.FilesList.ADD(s);

                S := ChangeFileExt(IncludeTrailingBackslash(PathVersion) + extractFileName(OD_EXE.FileName), '.ZIP');
                Zip.ZipName := S;
                Zip.Zip;
                Zip.FilesList.Clear;
                IF trim(CheminFtp) <> '' THEN
                BEGIN
                    CopyFile(Pchar(S), Pchar(CheminFtp + ChangeFileExt(extractFileName(OD_EXE.FileName), '.ZIP')), False);
                END
                ELSE
                BEGIN

                    ftp.Host := ftpserveur;
                    ftp.port := strtoint(portserveur);
                    ftp.Connect;
                    ftp.UpLoad(S, ExtractFileName(S));
                    ftp.Disconnect;
                END;
                S := IncludeTrailingBackslash(PathVersion) + extractFileName(OD_EXE.FileName);
                deletefile(s);
            END;
            Tsl := TstringList.create;
            S := Lb_Mag.Items[Lb_Mag.ItemIndex] + ';' + ExtractFileName(S);
            TRY
                TRY tsl.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt');
                EXCEPT END;
                i := 0;
                WHILE i < tsl.count DO
                BEGIN
                    IF copy(tsl[i], 1, Length(S)) = S THEN
                        tsl.delete(i)
                    ELSE
                        inc(i);
                END;
                tsl.Add(S);
                tsl.SavetoFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt');
            FINALLY
                tsl.free;
            END;
        END;
    END;
END;

PROCEDURE TFrm_GestClients.Button7Click(Sender: TObject);
VAR
    Tsl: TstringList;
    pass: STRING;
    S: STRING;
    bcl: integer;
    i: integer;
BEGIN
    IF Lb_Clt.itemindex >= 0 THEN
    BEGIN
        IF OD_exe.execute THEN
        BEGIN
            S := IncludeTrailingBackslash(PathVersion) + extractFileName(OD_exe.FileName);
            IF NOT fileexists(ChangeFileExt(S, '.zip')) THEN
            BEGIN
                CopyFile(pchar(OD_exe.FileName), Pchar(S), False);
                FileSetAttr(Pchar(S), 0);
                Zip.FilesList.Clear;
                Zip.FilesList.ADD(s);

                S := ChangeFileExt(IncludeTrailingBackslash(PathVersion) + extractFileName(OD_exe.FileName), '.ZIP');
                Zip.ZipName := S;
                Zip.Zip;
                Zip.FilesList.Clear;
                IF trim(CheminFtp) <> '' THEN
                BEGIN
                    CopyFile(Pchar(S), Pchar(CheminFtp + ChangeFileExt(extractFileName(OD_exe.FileName), '.ZIP')), False);
                END
                ELSE
                BEGIN

                    ftp.Host := ftpserveur;
                    ftp.port := strtoint(portserveur);
                    ftp.Connect;
                    ftp.UpLoad(S, ExtractFileName(S));
                    ftp.Disconnect;
                END;
                S := IncludeTrailingBackslash(PathVersion) + extractFileName(OD_exe.FileName);
                deletefile(s);
            END;
            Tsl := TstringList.create;
            TRY
                TRY tsl.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt');
                EXCEPT END;
                FOR bcl := 0 TO Lb_Mag.items.count - 1 DO
                BEGIN
                    Pass := Lb_Mag.Items[Bcl] + ';' + ExtractFileName(S);
                    i := 0;
                    WHILE i < tsl.count DO
                    BEGIN
                        IF copy(tsl[i], 1, Length(Pass)) = Pass THEN
                            tsl.delete(i)
                        ELSE
                            inc(i);
                    END;
                    tsl.Add(Pass);
                END;
                tsl.SavetoFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt');
            FINALLY
                tsl.free;
            END;
        END;
    END;
END;

PROCEDURE TFrm_GestClients.Button10Click(Sender: TObject);
VAR
    Tsl: TstringList;
    S: STRING;
    i: integer;
BEGIN
    IF Lb_Mag.itemindex >= 0 THEN
    BEGIN
        IF OD_zip.execute THEN
        BEGIN
            S := IncludeTrailingBackslash(PathVersion) + extractFileName(OD_zip.FileName);
            IF NOT fileexists(S) THEN
            BEGIN
                CopyFile(pchar(OD_zip.FileName), Pchar(S), False);
                FileSetAttr(Pchar(S), 0);
                IF trim(CheminFtp) <> '' THEN
                BEGIN
                    CopyFile(Pchar(S), Pchar(CheminFtp + extractFileName(OD_zip.FileName)), False);
                END
                ELSE
                BEGIN
                    ftp.Host := ftpserveur;
                    ftp.port := strtoint(portserveur);
                    ftp.Connect;
                    ftp.UpLoad(S, ExtractFileName(S));
                    ftp.Disconnect;
                END;
            END;
            Tsl := TstringList.create;
            S := Lb_Mag.Items[Lb_Mag.ItemIndex] + ';' + ExtractFileName(S);
            TRY
                TRY tsl.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt');
                EXCEPT END;
                i := 0;
                WHILE i < tsl.count DO
                BEGIN
                    IF copy(tsl[i], 1, Length(S)) = S THEN
                        tsl.delete(i)
                    ELSE
                        inc(i);
                END;
                tsl.Add(S);
                tsl.SavetoFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt');
            FINALLY
                tsl.free;
            END;
        END;
    END;
END;

PROCEDURE TFrm_GestClients.Button11Click(Sender: TObject);
VAR
    Tsl: TstringList;
    pass: STRING;
    S: STRING;
    bcl: integer;
    i: integer;
BEGIN
    IF Lb_Clt.itemindex >= 0 THEN
    BEGIN
        IF OD_zip.execute THEN
        BEGIN
            S := IncludeTrailingBackslash(PathVersion) + extractFileName(OD_zip.FileName);
            IF NOT fileexists(S) THEN
            BEGIN
                CopyFile(pchar(OD_zip.FileName), Pchar(S), False);
                FileSetAttr(Pchar(S), 0);
                IF trim(CheminFtp) <> '' THEN
                BEGIN
                    CopyFile(Pchar(S), Pchar(CheminFtp + extractFileName(OD_zip.FileName)), False);
                END
                ELSE
                BEGIN
                    ftp.Host := ftpserveur;
                    ftp.port := strtoint(portserveur);
                    ftp.Connect;
                    ftp.UpLoad(S, ExtractFileName(S));
                    ftp.Disconnect;
                END;
            END;
            Tsl := TstringList.create;
            TRY
                TRY tsl.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt');
                EXCEPT END;
                FOR bcl := 0 TO Lb_Mag.items.count - 1 DO
                BEGIN
                    Pass := Lb_Mag.Items[Bcl] + ';' + ExtractFileName(S);
                    i := 0;
                    WHILE i < tsl.count DO
                    BEGIN
                        IF copy(tsl[i], 1, Length(Pass)) = Pass THEN
                            tsl.delete(i)
                        ELSE
                            inc(i);
                    END;
                    tsl.Add(Pass);
                END;
                tsl.SavetoFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt');
            FINALLY
                tsl.free;
            END;
        END;
    END;
END;

PROCEDURE TFrm_GestClients.Button1Click(Sender: TObject);
{
VAR
    s1: STRING;
    S: STRING;
    Tsl: TstringList;
    LesPostes: TstringList;
    i: integer;
    ok: boolean;
   }
BEGIN
{
    LesPostes := TstringList.Create;
    TRY
        Tsl := TstringList.create;
        TRY
            TRY Tsl.Loadfromfile(extractfilePath(application.exename) + '\LesClients.txt')EXCEPT END;
            FOR i := 0 TO tsl.count - 1 DO
            BEGIN
                S := Tsl[i];
                ChaineSuivante(S);
                S1 := ChaineSuivante(S);
                WHILE s1 <> '' DO
                BEGIN
                    lespostes.add(s1);
                    S1 := ChaineSuivante(S);
                END;
            END;
        FINALLY
            tsl.free;
        END;
        lespostes.Sort;
        IF OD.Execute THEN
        BEGIN
            data.databasename := od.filename;
            data.open;
            qry.open;
            qry.first;
            s := '';
            ok := true;
            WHILE NOT qry.eof DO
            BEGIN
                IF lespostes.IndexOf(Qry.fields[0].AsString) > -1 THEN
                    ok := false;
                S := S + ';' + Qry.fields[0].AsString;
                qry.next;
            END;
            data.close;
            IF NOT ok THEN
            BEGIN
                Application.MessageBox('Un des postes que vous voulez ajouter existe déja', 'Ajout impossible', Mb_OK);
                exit;
            END;
            Application.CreateForm(TDial_Cltnom, Dial_Cltnom);
            TRY
                IF Dial_Cltnom.ShowModal = MrOk THEN
                BEGIN
                    S := Dial_Cltnom.Edit1.Text + S;
                    lb_clt.items.Add(Dial_Cltnom.Edit1.Text);
                    Tsl := TstringList.create;
                    TRY
                        TRY tsl.loadFromFile(extractfilePath(application.exename) + '\LesClients.txt');
                        EXCEPT END;
                        tsl.Add(S);
                        tsl.SavetoFile(extractfilePath(application.exename) + '\LesClients.txt');
                        LesClients.Add(S);
                    FINALLY
                        tsl.free;
                    END;
                END;
            FINALLY
                Dial_Cltnom.Release;
            END;
        END;
    FINALLY
        LesPostes.free;
    END;
    }
END;

END.

