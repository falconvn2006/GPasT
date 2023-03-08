UNIT UVerifVersion;

INTERFACE

USES
    Upost,
    registry,
    inifiles,
    UmakePatch,
    Ping_thread,
    CstLaunch,
    RASAPI,
    filectrl,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Db, IBCustomDataSet, IBQuery, IBDatabase, StdCtrls, ComCtrls, IpUtils,
    IpSock, IpHttp, IpHttpClientGinkoia, IpCache;

TYPE
    TFrm_VerifVersion = CLASS(TForm)
        data: TIBDatabase;
        tran: TIBTransaction;
        Que_Version: TIBQuery;
        Que_VersionVER_VERSION: TIBStringField;
        Pb: TProgressBar;
        Pb2: TProgressBar;
        Label1: TLabel;
        Lab_etat: TLabel;
        IBQue_Connexion: TIBQuery;
        IBQue_ConnexionCON_TYPE: TIntegerField;
        IBQue_ConnexionCON_NOM: TIBStringField;
        IBQue_ConnexionCON_TEL: TIBStringField;
        IBQue_Base: TIBQuery;
        IBQue_BaseBAS_NOM: TIBStringField;
        Http1: TIpHttpClientGinkoia;
        Cache: TIpCache;
        IBQue_NextVersion: TIBQuery;
        IBQue_NextVersionPRM_ID: TIntegerField;
        IBQue_NextVersionPRM_CODE: TIntegerField;
        IBQue_NextVersionPRM_INTEGER: TIntegerField;
        IBQue_NextVersionPRM_FLOAT: TFloatField;
        IBQue_NextVersionPRM_STRING: TIBStringField;
        IBQue_NextVersionPRM_TYPE: TIntegerField;
        IBQue_NextVersionPRM_MAGID: TIntegerField;
        IBQue_NextVersionPRM_INFO: TIBStringField;
        IBQue_NextVersionPRM_POS: TIntegerField;
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormActivate(Sender: TObject);
        PROCEDURE Http1Progress(Sender: TObject; Actuel, Maximum: Integer);
    PRIVATE
        Connectionencours: Integer;
        FUNCTION ConnexionModem(Nom, Tel: STRING): Boolean;
        FUNCTION Connexion(Tsl: TstringList): Boolean;
        PROCEDURE DeconnexionModem;
        PROCEDURE Deconnexion(tsl: tstringlist);
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        First: Boolean;
    END;

VAR
    Frm_VerifVersion: TFrm_VerifVersion;

IMPLEMENTATION

{$R *.DFM}
VAR
    Lapplication: STRING;
    AppliArret: Boolean;
CONST
    launcher = 'LE LAUNCHER';
    ginkoia = 'GINKOIA';
    Caisse = 'CAISSEGINKOIA';
    TPE = 'SERVEUR DE TPE';
    PICCO = 'PICCOLINK';

FUNCTION Enumerate(hwnd: HWND; Param: LPARAM): Boolean; STDCALL; FAR;
VAR
    lpClassName: ARRAY[0..999] OF Char;
    lpClassName2: ARRAY[0..999] OF Char;
    Handle: DWORD;
BEGIN
    result := true;
    Windows.GetClassName(hWnd, lpClassName, 500);
    IF Uppercase(StrPas(lpClassName)) = 'TAPPLICATION' THEN
    BEGIN
        Windows.GetWindowText(hWnd, lpClassName2, 500);
        IF Uppercase(StrPas(lpClassName2)) = Lapplication THEN
        BEGIN
            GetWindowThreadProcessId(hWnd, @Handle);
            TerminateProcess(OpenProcess(PROCESS_ALL_ACCESS, False, Handle), 0);
            AppliArret := true;
            result := False;
        END;
    END;
END;

PROCEDURE TFrm_VerifVersion.FormCreate(Sender: TObject);
BEGIN
    First := true;
END;

FUNCTION TFrm_VerifVersion.Connexion(Tsl: TstringList): Boolean;
VAR
    i: Integer;
    reg: tregistry;
    S: STRING;
BEGIN
    reg := tregistry.create(KEY_WRITE);
    TRY
        reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\', False);
        reg.WriteInteger('GlobalUserOffline', 0);
    FINALLY
        reg.closekey;
        reg.free;
    END;
    result := false;
    i := 0;
    Connectionencours := -1;
    WHILE i < Tsl.Count DO
    BEGIN
        Connectionencours := i;
        IF Copy(Tsl[i], 1, pos(';', Tsl[i]) - 1) = '1' THEN // Routeur : Juste un Ping
        BEGIN
            IF UnPing('http://replic3.algol.fr/EssaiBin/DelosQPMAgent.dll/Ping') THEN
            BEGIN
                result := true;
                BREAK;
            END;
        END
        ELSE
        BEGIN // Connexion sur modem
            S := Tsl[i];
            Delete(s, 1, pos(';', S));
            IF ConnexionModem(Copy(S, 1, pos(';', S) - 1), Copy(S, pos(';', S) + 1, 255)) THEN
            BEGIN
                result := true;
                BREAK;
            END;
        END;
        Inc(i);
    END;
    IF NOT result THEN
        Connectionencours := -1;
END;

FUNCTION trfVerInt64(S: STRING): Int64;
VAR
    S4, s3, s2, s1: STRING;
    i: Integer;
BEGIN
    S4 := Copy(S, 1, pos('.', S) - 1); delete(S, 1, pos('.', S));
    S3 := Copy(S, 1, pos('.', S) - 1); delete(S, 1, pos('.', S));
    S2 := Copy(S, 1, pos('.', S) - 1); delete(S, 1, pos('.', S));
    S1 := S;
    I := StrtoInt(S4); result := Int64(i);
    I := StrtoInt(S3); result := Int64(10000) * result + Int64(i);
    I := StrtoInt(S2); result := Int64(10000) * result + Int64(i);
    I := StrtoInt(S1); result := Int64(10000) * result + Int64(i);
END;

PROCEDURE TFrm_VerifVersion.FormActivate(Sender: TObject);
VAR
    reg: tregistry;
    VersionEnCours: STRING;
    s: STRING;
    Tsl: TstringList;
    i: Integer;
    S1, S2: STRING;
    Ginkoia: STRING;
    Arret: Boolean;
    LeLauncher: Boolean;
    LesConnexions: TstringList;
    ok: boolean;
    Arecup: boolean;
    ParServeur: STRING;
    VersSuiv: Int64;
    VerCoursInt: Int64;
    DateMaj: TDate;
    Ini: TIniFile;
    MAJST: STRING;
    MAJNUM: STRING;
BEGIN
    IF first THEN
    BEGIN
        Arret := false;
        LeLauncher := false;
        first := false;
        Update;

        MAJST := '';
        MAJNUM := '';
        ParServeur := '';

        Tsl := TstringList.Create;
        LesConnexions := TstringList.Create;
        TRY
            reg := TRegistry.Create;
            TRY
                reg.access := Key_Read;
                Reg.RootKey := HKEY_LOCAL_MACHINE;
                s := '';
                reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
                S := reg.ReadString('Base0');
            FINALLY
                reg.free;
            END;
            data.dataBaseName := S;
            Ginkoia := S;
            WHILE Ginkoia[length(Ginkoia)] <> '\' DO
                delete(ginkoia, length(Ginkoia), 1);
            delete(ginkoia, length(Ginkoia), 1);
            WHILE Ginkoia[length(Ginkoia)] <> '\' DO
                delete(ginkoia, length(Ginkoia), 1);
            IF NOT (Fileexists(Ginkoia + 'ginkoia.ini')) THEN
                Ginkoia := 'C:\GINKOIA\';
            IF NOT (Fileexists(Ginkoia + 'ginkoia.ini')) THEN
                Ginkoia := 'D:\GINKOIA\';
            IF NOT (Fileexists(Ginkoia + 'ginkoia.ini')) THEN
                Ginkoia := IncludeTrailingBackslash(extractFilePath(application.exename));

            ForceDirectories(ginkoia + 'TEMP');
            ForceDirectories(ginkoia + 'LIVEUPDATE');
            Cache.CacheDir := ginkoia + 'TEMP';
            Que_Version.Open;
            VersionEnCours := Que_VersionVER_VERSION.AsString;
            Que_Version.Close;

            IF paramcount = 0 THEN
            BEGIN
                // lancement manuel
                // vérifier si on doit faire une MAJ
                IBQue_NextVersion.Open;
                IF NOT IBQue_NextVersion.IsEmpty THEN
                BEGIN
                    S := IBQue_NextVersionPRM_STRING.AsString;
                    VersSuiv := trfVerInt64(Copy(S, 1, Pos(';', S) - 1));
                    VerCoursInt := trfVerInt64(VersionEnCours);
                    DateMaj := IBQue_NextVersionPRM_INTEGER.AsInteger;
                    IF NOT ((DateMaj <= Date) AND (VersSuiv > VerCoursInt)) THEN
                    BEGIN
                        application.messagebox('Pas de mise à jour détectée', ' Mise à jour', Mb_Ok);
                        EXIT;
                    END;

                    MAJST := Copy(S, pos(';', S) + 1, Length(S));
                    MAJNUM := Copy(S, 1, pos(';', S) - 1);
                    // vérifier si on est sur un portable (possibilité de ce connecter sur un autre poste)
                    ini := tinifile.create(Ginkoia + 'Ginkoia.Ini');
                    S := '';
                    FOR i := 0 TO 9 DO
                    BEGIN
                        S := ini.readString('DATABASE', 'PATH0', '');
                        IF (S <> '') AND (Pos(':', S) > 2) THEN
                            BREAK;
                    END;
                    ini.free;
                    IF (S <> '') AND (Pos(':', S) > 2) THEN
                    BEGIN
                        S := '\\' + S;
                        S[pos(':', S)] := '\';
                        delete(S, pos(':', S), 1);
                        S := IncludeTrailingBackslash(extractFilePath(S));
                        IF application.messagebox('Voulez vous faire la mise à jour par l''intermédiaire du serveur', ' Mise à jour', Mb_YESNO) = MrYES THEN
                        BEGIN
                            ParServeur := S;
                        END;
                    END;
                END
                ELSE
                BEGIN
                    application.messagebox('Pas de mise à jour détectée', ' Mise à jour', Mb_Ok);
                    EXIT;
                END;
            END;

            IBQue_Connexion.Open;
            IBQue_Connexion.First;
            WHILE NOT IBQue_Connexion.Eof DO
            BEGIN
                LesConnexions.Add(IBQue_ConnexionCON_TYPE.AsString + ';' + IBQue_ConnexionCON_NOM.AsString + ';' + IBQue_ConnexionCON_TEL.AsString);
                IBQue_Connexion.Next;
            END;
            IBQue_Connexion.Close;

            data.Close;
            IF (parserveur <> '') OR Connexion(LesConnexions) THEN
            BEGIN
                TRY
                    IF (parserveur = '') THEN
                    BEGIN
                        Lab_etat.Caption := 'Récupération des CRC'; Lab_etat.Update;
                        IF parserveur <> '' THEN
                        BEGIN
                            IF fileexists(parserveur + 'TEMP/' + VersionEnCours + '.log') THEN
                                tsl.LoadFromfile(parserveur + 'TEMP/' + VersionEnCours + '.log')
                            ELSE
                                EXIT;
                        END
                        ELSE
                        BEGIN
                            IF NOT Http1.GetWaitTimeOut('http://replic2.algol.fr/maj/reference/' + VersionEnCours + '.log', 30000) THEN
                                EXIT;
                            pb2.position := 0;
                            Lab_etat.Caption := ''; Lab_etat.Update;
                            Tsl.text := Http1.AsString('http://replic2.algol.fr/maj/reference/' + VersionEnCours + '.log');
                        END;
                        IF pos('<', Tsl.Text) = 0 THEN
                        BEGIN
                            tsl.savetofile(ginkoia + 'TEMP/' + VersionEnCours + '.log');
                            Pb.Max := tsl.count;
                            FOR i := 0 TO tsl.count - 1 DO
                            BEGIN
                                Pb.Position := I;
                                S := Tsl[i];
                                S1 := Copy(S, 1, pos(';', S) - 1);
                                Delete(S, 1, pos(';', S));
                                ok := Fileexists(Ginkoia + S1);
                                IF ok THEN
                                BEGIN
                                    S2 := Inttostr(FileCRC32(Ginkoia + S1));
                                    ok := S = S2;
                                END;
                                IF NOT (ok) THEN
                                BEGIN
                                    IF NOT arret THEN
                                    BEGIN
                                        Lapplication := ginkoia;
                                        EnumWindows(@Enumerate, 0);
                                        sleep(100);
                                        Lapplication := Caisse;
                                        EnumWindows(@Enumerate, 0);
                                        sleep(100);
                                        Lapplication := PICCO;
                                        EnumWindows(@Enumerate, 0);
                                        sleep(100);
                                        Lapplication := TPE;
                                        EnumWindows(@Enumerate, 0);
                                        sleep(100);
                                        AppliArret := False;
                                        Lapplication := launcher;
                                        EnumWindows(@Enumerate, 0);
                                        LeLauncher := AppliArret;
                                        sleep(5000);
                                    END;
                                    Lab_etat.Caption := 'Récupération de ' + Extractfilename(S1); Lab_etat.Update;
                                    FileSetAttr(Ginkoia + S1, 0);
                                    ForceDirectories(extractfilepath(Ginkoia + S1));
                                    IF parserveur <> '' THEN
                                    BEGIN
                                        CopyFile(Pchar(parserveur + S1), Pchar(Ginkoia + S1), false);
                                    END
                                    ELSE
                                    BEGIN
                                        IF NOT Http1.GetWaitTimeOut('http://replic2.algol.fr/maj/' + VersionEnCours + '/' + S1, 30000) THEN
                                            EXIT;
                                        Http1.SaveToFile('http://replic2.algol.fr/maj/' + VersionEnCours + '/' + S1, Ginkoia + S1);
                                        pb2.position := 0;
                                    END;
                                    Lab_etat.Caption := ' '; Lab_etat.Update;
                                END;
                            END;
                        END;
                    END;
                    IF (ParamCount > 1) AND (paramstr(2) <> 'DEBUG') THEN
                    BEGIN
                        S := paramstr(2);
                        S := ChangeFileExt(S, '.TXT');
                        IF NOT Http1.GetWaitTimeOut('http://replic2.algol.fr/maj/' + S, 30000) THEN
                            EXIT;
                        Tsl.text := Http1.AsString('http://replic2.algol.fr/maj/' + S);
                        S1 := paramstr(1);
                        Arecup := True;
                        IF pos('<', Tsl.Text) = 0 THEN
                        BEGIN
                            S := uppercase(Tsl[0]);
                            IF S = S1 THEN
                            BEGIN
                                IF FileExists(Ginkoia + 'liveUpdate\' + paramstr(2)) THEN
                                BEGIN
                                    S1 := Tsl[1];
                                    IF S1 = Inttostr(FileCRC32(Ginkoia + 'liveUpdate\' + paramstr(2))) THEN
                                        Arecup := False;
                                END;
                                IF arecup THEN
                                BEGIN
                                    Lab_etat.Caption := 'Récupération d''une MAJ '; Lab_etat.Update;
                                    IF Http1.GetWaitTimeOut('http://replic2.algol.fr/maj/' + paramstr(2), 30000) THEN
                                        Http1.Savetofile('http://replic2.algol.fr/maj/' + paramstr(2), Ginkoia + 'liveUpdate\' + S);

                                    IF FileExists(Ginkoia + 'liveUpdate\' + paramstr(2)) THEN
                                    BEGIN
                                        S1 := Tsl[1];
                                        IF S1 <> Inttostr(FileCRC32(Ginkoia + 'liveUpdate\' + paramstr(2))) THEN
                                        BEGIN
                                            deletefile(Ginkoia + 'liveUpdate\' + paramstr(2));
                                        END;
                                    END;
                                END;
                            END;
                        END;
                    END
                    ELSE IF (parserveur = '') AND (MAJST <> '') THEN
                    BEGIN
                        S := MAJST;
                        S := ChangeFileExt(S, '.TXT');
                        IF NOT Http1.GetWaitTimeOut('http://replic2.algol.fr/maj/' + S, 30000) THEN
                            EXIT;
                        Tsl.text := Http1.AsString('http://replic2.algol.fr/maj/' + S);
                        S1 := MAJNUM;
                        Arecup := True;
                        IF pos('<', Tsl.Text) = 0 THEN
                        BEGIN
                            S := uppercase(Tsl[0]);
                            IF S = S1 THEN
                            BEGIN
                                IF FileExists(Ginkoia + 'liveUpdate\' + MAJST) THEN
                                BEGIN
                                    S1 := Tsl[1];
                                    IF S1 = Inttostr(FileCRC32(Ginkoia + 'liveUpdate\' + MAJST)) THEN
                                        Arecup := False;
                                END;
                                IF arecup THEN
                                BEGIN
                                    Lab_etat.Caption := 'Récupération d''une MAJ '; Lab_etat.Update;
                                    IF Http1.GetWaitTimeOut('http://replic2.algol.fr/maj/' + MAJST, 30000) THEN
                                        Http1.Savetofile('http://replic2.algol.fr/maj/' + MAJST, Ginkoia + 'liveUpdate\' + MAJST);
                                END;
                                IF FileExists(Ginkoia + 'liveUpdate\' + MAJST) THEN
                                BEGIN
                                    S1 := Tsl[1];
                                    IF S1 <> Inttostr(FileCRC32(Ginkoia + 'liveUpdate\' + MAJST)) THEN
                                    BEGIN
                                        deletefile(Ginkoia + 'liveUpdate\' + MAJST);
                                    END
                                    ELSE
                                        Winexec(Pchar(Ginkoia + 'LIVEUPDATE\' + MAJST), 0);
                                END;
                            END;
                        END;
                    END;

                FINALLY
                  // déconnexion
                    Deconnexion(LesConnexions);
                END;
            END;
            IF (parserveur <> '') AND (MAJST <> '') THEN
            BEGIN
                CopyFile(Pchar(parserveur + 'LIVEUPDATE\' + MAJST), Pchar(Ginkoia + 'LIVEUPDATE\' + MAJST), false);
                Winexec(Pchar(Ginkoia + 'LIVEUPDATE\' + MAJST), 0);
            END;
        FINALLY
            tsl.free;
            LesConnexions.free;
            IF arret AND LeLauncher THEN
            BEGIN
                WinExec(Pchar(Ginkoia + 'LaunchV7.exe'), 0);
            END;
            IF NOT ((ParamCount > 0) AND (Uppercase(trim(ParamStr(1))) = 'DEBUG')) THEN
                Close;
        END;
    END;
END;

FUNCTION TFrm_VerifVersion.ConnexionModem(Nom, Tel: STRING): Boolean;
VAR
    RasConn: HRasConn;
    TP: TRasDialParams;
    Pass: Bool;
    err: DWORD;
    Last: DWord;
    RasConStatus: TRasConnStatus;
    nb: DWORD;
    ok: Boolean;
BEGIN
    fillchar(tp, Sizeof(tp), #00);
    tp.Size := Sizeof(Tp);
    StrPCopy(tp.pEntryName, NOM);
    err := RasGetEntryDialParams(NIL, TP, Pass);
    Ok := false;
    IF err = 0 THEN
    BEGIN
        StrPCopy(tp.pPhoneNumber, TEL);
        RasConn := 0;

        err := rasdial(NIL, NIL, @tp, $FFFFFFFF, Handle, RasConn);
        IF err <> 0 THEN
        BEGIN
            result := false;
            EXIT;
        END;
        Application.ProcessMessages;
        Last := $FFFFFFFF;
        nb := gettickcount + 600000; // 10 min
        REPEAT
            Application.ProcessMessages;
            RasConStatus.Size := sizeof(RasConStatus);
            RasGetConnectStatus(RasConn, @RasConStatus);
            IF Last <> RasConStatus.RasConnState THEN
            BEGIN
                CASE RasConStatus.RasConnState OF
                    RASCS_Connected: ok := true;
                    RASCS_Disconnected: ok := true;
                END;
                Last := RasConStatus.RasConnState;
            END;
            LeDelay(1000);
        UNTIL OK OR (gettickcount > nb); // max 10 min
    END;
    result := Ok;
END;

PROCEDURE TFrm_VerifVersion.DeconnexionModem;
VAR
    RasCom: ARRAY[1..100] OF TRasConn;
    i, Connections: DWord;
    ok: Boolean;
    RasConStatus: TRasConnStatus;
BEGIN
    REPEAT
        i := Sizeof(RasCom);
        RasCom[1].Size := sizeof(TRasConn);
        RasEnumConnections(@RasCom, i, Connections);
        FOR i := 1 TO Connections DO RasHangUp(RasCom[i].RasConn);
        // Test si c'est bien deconnecté
        i := Sizeof(RasCom);
        RasCom[1].Size := sizeof(TRasConn);
        RasEnumConnections(@RasCom, i, Connections);
        ok := True;
        FOR i := 1 TO Connections DO
        BEGIN
            Application.ProcessMessages;
            RasConStatus.Size := sizeof(RasConStatus);
            RasGetConnectStatus(RasCom[i].RasConn, @RasConStatus);
            CASE RasConStatus.RasConnState OF
                RASCS_Connected: ok := False;
            END;
        END;
        IF NOT ok THEN
            LeDelay(5000);
    UNTIL OK;
END;

PROCEDURE TFrm_VerifVersion.Deconnexion(tsl: tstringlist);
BEGIN
    IF (Connectionencours > -1) AND
        (Copy(Tsl[Connectionencours], 1, pos(';', Tsl[Connectionencours]) - 1) = '0') THEN
        DeconnexionModem;
    Connectionencours := -1;
END;

PROCEDURE TFrm_VerifVersion.Http1Progress(Sender: TObject; Actuel,
    Maximum: Integer);
BEGIN
    pb2.Max := Maximum;
    pb2.Position := Actuel;
END;

END.

