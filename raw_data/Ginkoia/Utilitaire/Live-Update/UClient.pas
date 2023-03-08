UNIT UClient;

INTERFACE

USES
    Connexion_Dm,
//    ULaVersion,
    UCRC32,
    UMapping,
    fileCtrl,
    registry,
    inifiles,
    IBSQL,
    IBDatabase,
    Db,
    IBCustomDataSet,
    Forms,
    ULiveUpCst,
    Windows,
    sysutils,
    IBQuery,
    ExtCtrls,
    Psock,
    NMFtp,
    ScktComp,
    Controls,
    StdCtrls,
    Classes, VCLUnZip, VCLZip;

TYPE
    TFrm_Client = CLASS(TForm)
        Client: TClientSocket;
        Button1: TButton;
        FTP: TNMFTP;
        Tim_Ftp: TTimer;
        Label1: TLabel;
        Label2: TLabel;
        data: TIBDatabase;
        qry: TIBQuery;
        IBTransaction1: TIBTransaction;
        Tim_Close: TTimer;
        QryBase: TIBQuery;
        UnZip: TVCLUnZip;
        Tim_Deconnect: TTimer;
        TIM_Reconnect: TTimer;
        TIM_PROB: TTimer;
        Zip: TVCLZip;
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE ServeurClientConnect(Sender: TObject;
            Socket: TCustomWinSocket);
        PROCEDURE ClientRead(Sender: TObject; Socket: TCustomWinSocket);
        PROCEDURE ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
        PROCEDURE Tim_FtpTimer(Sender: TObject);
        PROCEDURE FTPConnect(Sender: TObject);
        PROCEDURE FTPConnectionFailed(Sender: TObject);
        PROCEDURE FTPSuccess(Trans_Type: TCmdType);
        PROCEDURE FTPFailure(VAR Handled: Boolean; Trans_Type: TCmdType);
        PROCEDURE FTPTransactionStop(Sender: TObject);
        PROCEDURE FormDestroy(Sender: TObject);
        PROCEDURE FTPListItem(Listing: STRING);
        PROCEDURE FTPTransactionStart(Sender: TObject);
        PROCEDURE FTPPacketRecvd(Sender: TObject);
        PROCEDURE Tim_CloseTimer(Sender: TObject);
        PROCEDURE FormPaint(Sender: TObject);
        PROCEDURE ClientError(Sender: TObject; Socket: TCustomWinSocket;
            ErrorEvent: TErrorEvent; VAR ErrorCode: Integer);
        PROCEDURE ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
        PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
        PROCEDURE Tim_DeconnectTimer(Sender: TObject);
        PROCEDURE TIM_ReconnectTimer(Sender: TObject);
        PROCEDURE TIM_PROBTimer(Sender: TObject);
        PROCEDURE ZipBadCRC(Sender: TObject; CalcCRC, StoredCRC,
            FileIndex: Integer);
        PROCEDURE UnZipBadCRC(Sender: TObject; CalcCRC, StoredCRC,
            FileIndex: Integer);
        PROCEDURE FormKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
    PRIVATE
        { Déclarations privées }
        prem: boolean;
        LesFichiers: TstringList;
        Log: TstringList;
        PROCEDURE EnvoiServeur(S: STRING);
        PROCEDURE traiteFichierProblem;
        PROCEDURE AjouteRepZip(Path: STRING);
        PROCEDURE recupVersion(De, Vers: STRING);
    PUBLIC
        { Déclarations publiques }
        Dm_Connexion: TDm_Connexion;

        ZIPProb: STRING;
        EnCours: TEncours;
        Magasin,
            Societe,
            LaVersion,
            version: STRING;
        path: STRING;
        versionMAJ: STRING;

        EnvoieAck: STRING;

        OuEstFTP: Integer;
        Arecup: TstringList;
        ListeFichier: TStringList;
        FaitLaMAJ: Boolean;
        ToutEstOk: Boolean;

        VeuVersionSpe: STRING;

    END;

VAR
    Frm_Client: TFrm_Client;

IMPLEMENTATION

USES ULaVersion;
VAR
    Lapplication: STRING;
CONST
    launcher = 'LE LAUNCHER';
    ginkoia = 'GINKOIA';
    Caisse = 'CAISSEGINKOIA';
    TPE = 'SERVEUR DE TPE';
    PICCO = 'PICCOLINK';

{$R *.DFM}

FUNCTION Enumerate(hwnd: HWND; Param: LPARAM): Boolean; STDCALL; FAR;
VAR
    lpClassName: ARRAY[0..999] OF Char;
    lpClassName2: ARRAY[0..999] OF Char;
    Handle: DWORD;
    // lpdwProcessId: Pointer;
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
            result := False;
        END;
    END;
END;

PROCEDURE Detruit(src: STRING);
VAR
    f: tsearchrec;
BEGIN
    IF src[length(src)] <> '\' THEN
        src := src + '\';
    IF findfirst(src + '*.*', faanyfile, f) = 0 THEN
    BEGIN
        REPEAT
            IF (f.name <> '.') AND (f.name <> '..') THEN
            BEGIN
                IF f.Attr AND faDirectory = 0 THEN
                BEGIN
                    fileSetAttr(src + f.Name, 0);
                    deletefile(src + f.Name);
                END
                ELSE
                    Detruit(Src + f.name);
            END;
        UNTIL findnext(f) <> 0;
    END;
    findclose(f);
    RemoveDir(Src);
END;

PROCEDURE TFrm_Client.recupVersion(De, Vers: STRING);
VAR
    S: STRING;
    i: integer;
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
    Lapplication := launcher;
    EnumWindows(@Enumerate, 0);
    sleep(5000);
    S := '';
    FOR i := 0 TO Dm_Connexion.LesEai.Count - 1 DO
        S := S + ' ' + Dm_Connexion.LesEai[i];
    FileSetAttr(Pchar(Path + 'RecupMAJ.EXE'), 0);
    CopyFile(Pchar(De + 'RecupMAJ.EXE'), Pchar(Path + 'RecupMAJ.EXE'), False);

    WinExec(PChar(Path + 'RecupMAJ.EXE RECUP ' + De + ' ' + Vers + S), 0);
    ToutEstOk := false;
    Halt;

    {
    IF FindFirst(De + '*.*', FaAnyFile, f) = 0 THEN
    BEGIN
        REPEAT
            IF (f.name <> '.') AND (F.Name <> '..') THEN
            BEGIN
                IF F.attr AND FaDirectory = 0 THEN
                BEGIN
                    IF Uppercase(F.name) <> 'LIVEUPCLIENT.EXE' THEN
                    BEGIN
                        IF (Uppercase(extractfileext(f.Name)) = '.EXE') OR
                            (Uppercase(extractfileext(f.Name)) = '.IT') OR
                            (Uppercase(extractfileext(f.Name)) = '.SCR') THEN
                        BEGIN
                            label1.caption := Vers + f.Name; Label1.Update;
                            fileSetAttr(Vers + f.Name, 0);
                            CopyFile(PChar(De + F.name), PChar(vers + f.name), False);
                        END;
                    END;
                END;
            END;
        UNTIL findNext(f) <> 0;
    END;
    findclose(f);
    IF FindFirst(De + 'BPL\*.*', FaAnyFile, f) = 0 THEN
    BEGIN
        REPEAT
            IF (f.name <> '.') AND (F.Name <> '..') THEN
            BEGIN
                IF F.attr AND FaDirectory = 0 THEN
                BEGIN
                    label1.caption := Vers + 'BPL\' + f.Name; Label1.Update;
                    fileSetAttr(Vers + 'BPL\' + f.Name, 0);
                    CopyFile(PChar(De + 'BPL\' + F.name), PChar(vers + 'BPL\' + f.name), False);
                END;
            END;
        UNTIL findNext(f) <> 0;
    END;
    findclose(f);
    IF FindFirst(De + 'EAI\XML\*.*', FaAnyFile, f) = 0 THEN
    BEGIN
        REPEAT
            IF (f.name <> '.') AND (F.Name <> '..') THEN
            BEGIN
                IF F.attr AND FaDirectory = 0 THEN
                BEGIN
                    IF Uppercase(extractfileext(f.Name)) = '.XMLGRAM' THEN
                    BEGIN
                        label1.caption := Vers + 'EAI\XML\' + f.Name; Label1.Update;
                        fileSetAttr(Vers + 'EAI\XML\' + f.Name, 0);
                        CopyFile(PChar(De + 'EAI\XML\' + F.name), PChar(vers + 'EAI\XML\' + f.name), False);
                    END;
                END;
            END;
        UNTIL findNext(f) <> 0;
    END;
    findclose(f);
    }

END;

PROCEDURE TFrm_Client.Button1Click(Sender: TObject);
VAR
    reg: TRegistry;
    ini: tinifile;
    s: STRING;
    ok: Boolean;
    PathExeServeur: STRING;
    Tsl: TstringList;
    VersionServeur: STRING;
    VersionPoste: STRING;
    Temps: Dword;
BEGIN
    Log.Add('Démarage LiveUpdate ' + DateTimeToStr(Now));
    Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
    Temps := GetTickCount;
    IF MapGinkoia.Backup THEN
    BEGIN
        Log.Add('Attente Backup Fini ' + DateTimeToStr(Now));
        Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
        WHILE MapGinkoia.Backup DO
        BEGIN
            Sleep(10000);
            IF (GetTickCount - temps) > 14400000 THEN
            BEGIN
                ToutEstOk := False;
                Tim_Close.Enabled := true;
                Log.Add('PLus de 4h Arret ' + DateTimeToStr(Now));
                Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
                EXIT;
            END;
        END;
        Log.Add('Backup fini ' + DateTimeToStr(Now));
        Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
    END;

    ZIPProb := '';
    ToutEstOk := true;
    TRY
        Button1.Enabled := false;
        MapGinkoia.LiveUpdate := true;

        Arecup.Clear;
        FaitLaMAJ := false;
        Path := IncludeTrailingBackslash(ExtractfilePath(Application.exename));
        IF NOT fileexists(Path + 'Ginkoia.ini') THEN
            Path := 'C:\Ginkoia\';
        IF NOT fileexists(Path + 'Ginkoia.ini') THEN
            Path := 'D:\Ginkoia\';
        IF (paramcount = 0) THEN
        BEGIN
            ok := false;

            S := Path + 'Ginkoia.Ini';
            ini := tinifile.create(S);

            S := ini.readString('DATABASE', 'PATH0', '');
            IF (S <> '') AND (Pos(':', S) > 2) THEN
                ok := true
            ELSE
            BEGIN
                S := ini.readString('DATABASE', 'PATH1', '');
                IF (S <> '') AND (Pos(':', S) > 2) THEN
                    ok := true
                ELSE
                BEGIN
                    S := ini.readString('DATABASE', 'PATH2', '');
                    IF (S <> '') AND (Pos(':', S) > 2) THEN
                        ok := true
                    ELSE
                    BEGIN
                        S := ini.readString('DATABASE', 'PATH3', '');
                        IF (S <> '') AND (Pos(':', S) > 2) THEN
                            ok := true
                        ELSE
                        BEGIN
                            S := ini.readString('DATABASE', 'PATH4', '');
                            IF (S <> '') AND (Pos(':', S) > 2) THEN
                                ok := true
                            ELSE
                            BEGIN
                                S := ini.readString('DATABASE', 'PATH5', '');
                                IF (S <> '') AND (Pos(':', S) > 2) THEN
                                    ok := true;
                            END;
                        END;
                    END;
                END;
            END;

            IF ok THEN
            BEGIN // Connexion sur un serveur
                Log.Add('Connexion direct au serveur ' + DateTimeToStr(Now));
                Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
                S := '\\' + S;
                S[pos(':', S)] := '\';
                delete(S, pos(':', S), 1);
                S := extractFilePath(S);
                IF s[Length(S)] = '\' THEN
                    Delete(S, length(s), 1);
                WHILE s[Length(S)] <> '\' DO
                    Delete(S, length(s), 1);
                PathExeServeur := S;
                IF fileexists(PathExeServeur + 'Script.scr') AND
                    fileexists(Path + 'Script.scr') THEN
                BEGIN
                    tsl := TstringList.Create;
                    TRY
                        tsl.loadFromFile(PathExeServeur + 'Script.scr');
                        WHILE Copy(tsl[tsl.count - 1], 1, 9) <> '<RELEASE>' DO
                            tsl.delete(tsl.count - 1);
                        VersionServeur := trim(Copy(tsl[tsl.count - 1], 10, 255));
                        tsl.loadFromFile(Path + 'Script.scr');
                        WHILE Copy(tsl[tsl.count - 1], 1, 9) <> '<RELEASE>' DO
                            tsl.delete(tsl.count - 1);
                        VersionPoste := trim(Copy(tsl[tsl.count - 1], 10, 255));
                    FINALLY
                        tsl.free;
                    END;
                    IF VersionServeur <> VersionPoste THEN
                    BEGIN
                        IF Application.MessageBox('Votre version n''est pas à jour par rapport au serveur'#10#13 +
                            'Voulez vous lancer la mise à jour ?', 'Attention', Mb_YESNO OR MB_DEFBUTTON1) = IDYES THEN
                        BEGIN
                            Log.Add('Pas de MAJ par le serveur ' + DateTimeToStr(Now));
                            Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
                            recupVersion(PathExeServeur, Path);
                            WinExec(Pchar(Path + 'Script.exe AUTO'), 0);
                            Sleep(1000);
                            MapGinkoia.LiveUpdate := false;
                            ToutEstOk := False;
                            Tim_Close.Enabled := true;
                            //CLOSE;
                            EXIT;
                        END
                        ELSE IF Application.MessageBox('Voulez vous lancer la mise à jour par internet ?',
                            'Attention', Mb_YESNO OR MB_DEFBUTTON2) = IDNO THEN
                        BEGIN
                            Log.Add('Pas de MAJ ni serveur ni internet ' + DateTimeToStr(Now));
                            Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
                            MapGinkoia.LiveUpdate := false;
                            ToutEstOk := False;
                            Tim_Close.Enabled := true;
                            //CLOSE;
                            EXIT;
                        END;
                    END
                    ELSE
                    BEGIN
                        IF Application.MessageBox('Votre version est à jour par rapport au serveur'#10#13 +
                            'Voulez vous lancer la mise à jour par internet ?',
                            'Attention', Mb_YESNO OR MB_DEFBUTTON2) = IDNO THEN
                        BEGIN
                            Log.Add('Pas de MAJ par internet ' + DateTimeToStr(Now));
                            Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
                            MapGinkoia.LiveUpdate := false;
                            ToutEstOk := False;
                            Tim_Close.Enabled := true;
                            //CLOSE;
                            EXIT;
                        END;
                    END;
                END;
            END;
        END;

        Log.Add('Connexion à internet ' + DateTimeToStr(Now));
        Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
        IF NOT Dm_Connexion.Connexion THEN
        BEGIN
            Log.Add('Pas de Connexion à internet ' + DateTimeToStr(Now));
            Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
            MapGinkoia.LiveUpdate := false;
            ToutEstOk := False;
            Tim_Close.Enabled := true;
                //CLOSE;
            EXIT;
        END;

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
        Path := IncludeTrailingBackslash(Path);

        IF s = '' THEN
        BEGIN
            S := Path + 'Ginkoia.Ini';
            ini := tinifile.create(S);
            S := ini.readString('DATABASE', 'PATH0', '');
            ini.free;
        END;
        Data.DatabaseName := S;
        Log.Add('Vérification version actuelle ' + DateTimeToStr(Now));
        Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
        QryBase.Open;
        Magasin := QryBase.Fields[0].AsString;
        societe := QryBase.Fields[1].AsString;
        QryBase.Close;
        Qry.Open;
        LaVersion := qry.fields[0].asstring;
        data.Connected := false;
        EnCours := Ecrs_Identification;
        Client.Open;
    EXCEPT
        Log.Add('Problème Sortie ' + DateTimeToStr(Now));
        Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
        MapGinkoia.LiveUpdate := false;
        ToutEstOk := False;
        Tim_Close.Enabled := true;
        //CLOSE;
    END;
END;

PROCEDURE TFrm_Client.FormCreate(Sender: TObject);
VAR
    Ini: TIniFile;
BEGIN
    VeuVersionSpe := '';
    Application.CreateForm(TDm_Connexion, Dm_Connexion);
    Log := TstringList.Create;
    Log.Add('Démarage ' + DateTimeToStr(Now));
    Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
    ToutEstOk := False;
    Arecup := tstringList.create;
    prem := true;
    EnCours := Ecrs_Rien;
    ListeFichier := TstringList.Create;
    ini := TIniFile.Create(ChangeFileExt(Application.exename, '.ini'));
    TRY
        IF ini.readString('ADRESSE', 'HOST', '') <> '' THEN
        BEGIN
            client.Address := '';
            Client.Host := ini.readString('ADRESSE', 'HOST', '');
        END
        ELSE
            IF ini.readString('ADRESSE', 'IP', '') <> '' THEN
            BEGIN
                client.Address := ini.readString('ADRESSE', 'IP', '');
                Client.Host := '';
            END;
        IF (client.Address = '') AND (Client.Host = '') THEN
            Client.Host := 'LiveUpdate.Algol.Fr';
        Client.Port := StrToInt(ini.ReadString('TPCIP', 'PortListening', '31415'));
    EXCEPT
        Log.Add('Problème lecture ini ' + DateTimeToStr(Now));
        Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
        TRY
            Client.Address := '';
            Client.Host := 'liveupdate.algol.fr';
            client.Port := 31415
        EXCEPT
            Log.Add('Problème affectation client TCP/IP' + DateTimeToStr(Now));
            Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
        END;
    END;
    ini.free;
    LesFichiers := TstringList.Create;
END;

PROCEDURE TFrm_Client.ServeurClientConnect(Sender: TObject;
    Socket: TCustomWinSocket);
BEGIN
    CASE EnCours OF
        Ecrs_Rien: Socket.Close;
    END
END;

PROCEDURE TFrm_Client.ClientRead(Sender: TObject;
    Socket: TCustomWinSocket);
VAR
    S: STRING;
    s1: STRING;
    ini: TIniFile;
BEGIN
    TIM_PROB.Enabled := false;
    S := Socket.ReceiveText;
    Log.Add('Réception de ' + S + '  ' + DateTimeToStr(Now));
    Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
    IF S = 'Plus Tard' THEN
    BEGIN
        Caption := 'Deconnexion du serveur';
        Client.Socket.SendText('Deconnexion');
        Client.Close;
        Tim_Deconnect.Enabled := true;
        EXIT;
    END;
    CASE EnCours OF
        Ecrs_EnvoiACK:
            BEGIN
                Caption := 'Deconnexion du serveur';
                Client.Socket.SendText('Deconnexion');
                Client.Close;
                Tim_Ftp.enabled := true;
                //
            END;
        Ecrs_Identification:
            BEGIN
                IF Copy(S, 1, 4) = 'NON;' THEN // NON;HOST;IP;PORT
                BEGIN
                    Caption := 'Le serveur à changé de site';
                    EnCours := Ecrs_Rien;
                    Client.Close;
                    delete(S, 1, pos(';', S));

                    ini := TIniFile.Create(ChangeFileExt(Application.exename, '.ini'));
                    IF pos(';', S) = 1 THEN
                        ini.WriteString('ADRESSE', 'HOST', '')
                    ELSE
                        ini.WriteString('ADRESSE', 'HOST', Copy(S, 1, Pos(';', S) - 1));
                    delete(S, 1, pos(';', S));
                    IF pos(';', S) = 1 THEN
                        ini.WriteString('ADRESSE', 'IP', '')
                    ELSE
                        ini.WriteString('ADRESSE', 'IP', Copy(S, 1, Pos(';', S) - 1));
                    delete(S, 1, pos(';', S));
                    ini.WriteString('TPCIP', 'PortListening', S);
                    IF ini.readString('ADRESSE', 'HOST', '') <> '' THEN
                    BEGIN
                        client.Address := '';
                        Client.Host := ini.readString('ADRESSE', 'HOST', '');
                    END
                    ELSE
                        IF ini.readString('ADRESSE', 'IP', '') <> '' THEN
                        BEGIN
                            client.Address := ini.readString('ADRESSE', 'IP', '');
                            Client.Host := '';
                        END;
                    IF (client.Address = '') AND (Client.Host = '') THEN
                        Client.Host := 'liveUpdate.algol.FR';
                    Client.Port := StrToInt(ini.ReadString('TPCIP', 'PortListening', '31415'));
                    ini.free;
                    EnCours := Ecrs_Identification;
                    Client.Open;
                END
                ELSE
                BEGIN
                    IF ZIPProb <> '' THEN
                    BEGIN
                        Client.Socket.SendText('ZIP;' + ZIPProb);
                        Client.Socket.Close;
                        ToutEstOk := false;
                        Tim_Close.enabled := true;
                    END
                    ELSE IF LesFichiers.count > 0 THEN
                    BEGIN
                        // certain des fichiers ne sont pas bon
                        EnCours := ECRS_Fichiers;
                        S := LesFichiers[0];
                        S1 := Copy(S, 1, Pos(';', S) - 1);
                        delete(s, 1, pos(';', s));
                        delete(s1, 1, 3);
                        delete(s1, 1, pos('\', S1));
                        delete(S, Length(S) - 1, 2);
                        S := S + '\' + S1;
                        EnvoiServeur('Wanna;' + S);
                    END
                    ELSE
                    BEGIN
                        Caption := 'Recherche d''une nouvelle version';
                        EnCours := ECRS_LastVersion;
                        EnvoiServeur('LastVersion;' + LaVersion);
                    END;
                END;
            END;
        ECRS_LastVersion:
            BEGIN
                IF Pos(';', S) = 0 THEN
                BEGIN // Pas de version
                    Caption := 'Recherche de MAJ';
                    IF VeuVersionSpe <> '' THEN
                    BEGIN
                        Caption := 'Deconnexion du serveur';
                        Client.Socket.SendText('Deconnexion');
                        Client.Close;
                        Tim_Ftp.enabled := true;
                    END
                    ELSE
                    BEGIN
                        EnCours := ECRS_QuelqueChose;
                        EnvoiServeur('YaQuelqueChose');
                    END;
                END
                ELSE
                BEGIN
                    Caption := 'Recherche de MAJ';
                    IF VeuVersionSpe <> '' THEN
                    BEGIN
                        Arecup.Add('MAJ;' + S + '01/01/1980');
                        Caption := 'Deconnexion du serveur';
                        Client.Socket.SendText('Deconnexion');
                        Client.Close;
                        Tim_Ftp.enabled := true;
                    END
                    ELSE
                    BEGIN
                        Arecup.Add('MAJ;' + S);
                        EnCours := ECRS_QuelqueChose;
                        EnvoiServeur('YaQuelqueChose');
                    END;
                END;
            END;
        ECRS_QuelqueChose:
            BEGIN
                IF S = 'Rien' THEN
                BEGIN
                    Caption := 'Deconnexion du serveur';
                    Client.Socket.SendText('Deconnexion');
                    Client.Close;
                    Tim_Ftp.enabled := true;
                END
                ELSE
                BEGIN
                    Arecup.Add('SCR;' + S);
                    EnvoiServeur('YaQuelqueChose');
                END;
            END;
        ECRS_Fichiers:
            BEGIN
                IF LesFichiers.count = 0 THEN
                BEGIN
                    IF copy(S, 1, 4) = 'FIC;' THEN
                    BEGIN
                        Arecup.Add(S);
                        Caption := 'Deconnexion du serveur';
                        Client.Socket.SendText('Deconnexion');
                        Client.Close;
                        Tim_Ftp.enabled := true;
                    END
                    ELSE
                    BEGIN
                        ToutEstOk := false;
                        Tim_Close.enabled := true;
                    END;
                END
                ELSE IF Copy(S, 1, 2) = 'OK' THEN
                BEGIN
                    LesFichiers.Delete(0);
                    IF LesFichiers.count > 0 THEN
                    BEGIN
                        S := LesFichiers[0];
                        S1 := Copy(S, 1, Pos(';', S) - 1);
                        delete(s, 1, pos(';', s));
                        delete(s1, 1, 3);
                        delete(s1, 1, pos('\', S1));
                        delete(S, Length(S) - 1, 2);
                        S := S + '\' + S1;
                        EnvoiServeur('Wanna;' + S);
                    END
                    ELSE
                    BEGIN
                        EnvoiServeur('Gotya');
                    END;
                END
                ELSE
                BEGIN
                    ToutEstOk := false;
                    Tim_Close.enabled := true;
                END;
            END;
    END;
END;

PROCEDURE TFrm_Client.ClientConnect(Sender: TObject;
    Socket: TCustomWinSocket);
BEGIN
    Log.Add('Connexion au serveur internet ' + DateTimeToStr(Now));
    Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
    Caption := 'Identification auprès du serveur';
    IF VeuVersionSpe <> '' THEN
    BEGIN
        EnCours := ECRS_LastVersion;
    END;
    CASE EnCours OF
        ECRS_LastVersion: EnvoiServeur('@@;' + VeuVersionSpe);
        Ecrs_Identification,
            ECRS_ApresRelease:
            BEGIN
                EnvoiServeur('Bonjour;' + Magasin + ';' + Societe);
            END;
        Ecrs_EnvoiACK: EnvoiServeur('Suivi;' + Magasin + ';' + Societe + ';' + EnvoieAck);
    END;
END;

PROCEDURE Copie(Src, Dst: STRING);
VAR
    F: TsearchRec;
BEGIN
    IF src[length(src)] <> '\' THEN src := src + '\';
    IF dst[length(dst)] <> '\' THEN dst := dst + '\';
    forcedirectories(dst);
    IF FindFirst(Src + '*.*', faAnyFile, f) = 0 THEN
    BEGIN
        REPEAT
            IF (f.name <> '.') AND (f.name <> '..') THEN
            BEGIN
                IF f.Attr AND faDirectory = 0 THEN
                BEGIN
                    // Copie
                    FileSetAttr(Dst + f.name, 0);
                    CopyFile(PChar(src + f.name), Pchar(Dst + f.name), False);
                    FileSetAttr(Src + f.name, 0);
                END
                ELSE
                    Copie(src + f.name + '\', Dst + f.name + '\');
            END;
        UNTIL findnext(f) <> 0;
    END;
    findClose(f);
END;

PROCEDURE TFrm_Client.AjouteRepZip(Path: STRING);
VAR
    f: tsearchrec;
BEGIN
    IF findfirst(Path + '*.*', faanyfile, f) = 0 THEN
    BEGIN
        REPEAT
            IF (f.name <> '.') AND (f.name <> '..') THEN
            BEGIN
                IF f.Attr AND faDirectory = 0 THEN
                BEGIN
                    Zip.FilesList.Add(Path + f.name);
                END
                ELSE
                    AjouteRepZip(Path + f.name + '\');
            END;
        UNTIL findnext(f) <> 0;
    END;
    findclose(f);
END;

PROCEDURE TFrm_Client.Tim_FtpTimer(Sender: TObject);
VAR
    TTSL,
        Tsl: TstringList;
    j: integer;
    pli: Integer;
    Place: STRING;
    Pass: STRING;
    s: STRING;
    IP: STRING;
    port: STRING;
    LaDate: STRING;
    crc: LongWord;

    NomDuZip: STRING;
    DirUp: STRING;
    dir: STRING;
    Asupr: STRING;

    PROCEDURE copier(Dir, Dirup: STRING; Tsl: tstringList);
    VAR
        f: tsearchrec;
        pass: STRING;
        i: integer;
    BEGIN
        IF dir[length(dir)] <> '\' THEN dir := dir + '\';
        IF dirUp[length(dirUp)] <> '\' THEN dirUp := dirUp + '\';
        IF findfirst(Dir + '*.*', FaAnyFile, F) = 0 THEN
        BEGIN
            REPEAT
                IF (f.name <> '.') AND (f.name <> '..') THEN
                BEGIN
                    IF f.Attr AND faDirectory = 0 THEN
                    BEGIN
                        FileSetAttr(Dir + F.Name, 0);
                        FileSetAttr(DirUp + F.Name, 0);
                        CopyFile(PChar(Dir + F.Name), Pchar(DirUp + F.Name), False);
                        pass := DirUp + F.Name;
                        delete(Pass, 1, pos('LiveUpdate\', Pass));
                        Caption := 'Recherche ' + Pass;
                        FOR i := 0 TO tsl.count - 1 DO
                        BEGIN
                            IF pos(Uppercase(Pass), Uppercase(tsl[i])) > 0 THEN
                            BEGIN
                                IF copy(tsl[i], 1, 2) = '1;' THEN
                                BEGIN
                                    pass := tsl[i];
                                    pass := '-' + Pass;
                                    WHILE Pass[length(Pass)] <> ';' DO
                                        delete(pass, length(Pass), 1);
                                    delete(pass, length(Pass), 1);
                                    tsl[i] := Pass;
                                END;
                                BREAK;
                            END;
                        END;
                    END
                    ELSE
                        Copier(Dir + f.name, DirUp + f.name, Tsl);
                END;
            UNTIL findnext(f) <> 0;
        END;
        findclose(f);
    END;

BEGIN
    Tim_Ftp.Enabled := false;
    Client.close;

    Log.Add('Récupération par FTP ' + DateTimeToStr(Now));
    Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
    ForceDirectories(Path + 'LiveUpdate');
    WHILE Arecup.Count > 0 DO
    BEGIN
        S := Arecup[0];
        IF copy(S, 1, 4) = 'MAJ;' THEN
        BEGIN
            FaitLaMAJ := true;
            delete(s, 1, 4);
            Ip := Copy(S, 1, pos(';', S) - 1);
            delete(s, 1, pos(';', s));
            Ftp.Host := Ip;
            port := Copy(S, 1, pos(';', S) - 1);
            delete(s, 1, pos(';', s));
            Ftp.Port := Strtoint(Port);
            versionMAJ := Copy(S, 1, pos(';', S) - 1);
            delete(s, 1, pos(';', s));
            LaDate := Copy(S, Pos(';', S) + 1, 255);
            version := Copy(S, 1, Pos(';', S) - 1);
            IF (NOT FileExists(Path + 'LiveUpdate\' + Version)) THEN
            BEGIN
                OuEstFTP := 0;
                TRY
                    ftp.Connect;
                    TRY
                        WHILE OuEstFTP = 0 DO ;
                        IF OuEstFTP AND 1 <> 1 THEN
                        BEGIN
                            MapGinkoia.LiveUpdate := false;
                            ToutEstOk := False;
                            Tim_Close.Enabled := true;
                            //Close;
                            exit;
                        END;
                        OuEstFTP := 0;
                        TRY
                            ftp.Download(Version, Path + 'LiveUpdate\' + Version);
                            (**)
                            IF VeuVersionSpe <> '' THEN
                            BEGIN
                              // on saute le suivi
                                VeuVersionSpe := '';
                                Tim_Ftp.enabled := true;
                                EXIT;
                            END
                            ELSE
                            BEGIN
                                EnvoieAck := Version;
                                EnCours := Ecrs_EnvoiACK;
                                Client.Open;
                                EXIT;
                            END;
                            (**)
                        EXCEPT
                            Log.Add('Problème sur FTP' + DateTimeToStr(Now));
                            Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
                            DeleteFile(Path + 'LiveUpdate\' + Version);
                            MapGinkoia.LiveUpdate := false;
                            ToutEstOk := False;
                            Tim_Close.Enabled := true;
                            //Close;
                            exit;
                        END;
                    FINALLY
                        ftp.Disconnect;
                    END;
                EXCEPT
                END;
            END;
            IF FileExists(Path + 'LiveUpdate\' + Version) THEN
            BEGIN
                Log.Add('Début MAJ Version' + DateTimeToStr(Now));
                Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));

                tsl := TStringList.create;
                TRY
                    TRY
                        tsl.loadFromFile(Path + 'LiveUpdate\Afaire.txt');
                    EXCEPT
                    END;
                    j := 0;
                    WHILE j < tsl.count DO
                    BEGIN
                        IF trim(tsl[j]) = '' THEN
                            tsl.delete(j)
                        ELSE IF copy(tsl[j], 1, 4) = 'MAJ;' THEN
                        BEGIN
                            tsl.delete(j);
                        END
                        ELSE inc(j);
                    END;
                    UnZip.ZipName := Path + 'LiveUpdate\' + Version;
                    UnZip.DestDir := Path;
                    Unzip.DoAll := False;
                    UnZip.ReadZip;
                    Place := Unzip.Pathname[0];
                    delete(Place, 1, Pos('\', Place));
                    IF pos('\', Place) > 0 THEN
                        delete(Place, Pos('\', Place), 2550);
                    S := 'liveupdate\' + Place + '\lesfichiers.lup';
                    UnZip.filesList.Add(S);
                    S := Path + 'liveupdate\' + Place + '\lesfichiers.lup';
                    UnZip.UnZip;
                    IF zipprob <> '' THEN EXIT;
                    TTSl := TstringList.create;
                    TRY
                        TTSl.LoadFromFile(S);
                        FOR pli := 0 TO ttsl.count - 1 DO
                        BEGIN
                            TRY
                                Pass := TTsl[pli];
                                Pass := Copy(Pass, 1, Pos(';', Pass) - 1);
                                IF Pass = '1' THEN
                                BEGIN
                                    Pass := TTsl[pli];
                                    Delete(Pass, 1, 2 + Length('C:\LiveUpdate\'));
                                    Delete(Pass, 1, length(Place) + 1);
                                    S := Path + Pass;
                                    Delete(S, Pos(';', S), 255);
                                    delete(pass, 1, Pos(';', Pass));
                                    IF uppercase(S) <> Uppercase(Application.ExeName) THEN
                                    BEGIN
                                        IF fileexists(S) THEN
                                        BEGIN
                                            Caption := 'CRC ' + S;
                                            crc := FileCRC32(S);
                                            IF Pass <> Inttostr(crc) THEN
                                                LesFichiers.Add(S + ';' + Place);
                                        END
                                        ELSE
                                            LesFichiers.Add(S + ';' + Place);
                                    END;
                                END;
                            EXCEPT
                                ToutEstOk := False;
                                Tim_Close.Enabled := true;
                                //CLOSE;
                                EXIT;
                            END;
                        END;
                    FINALLY
                        TTSL.Free;
                    END;
                    Detruit(Path + 'liveupdate\' + Place);
                    tsl.Add('MAJ;' + versionMAJ + ';' + Path + 'LiveUpdate\' + Version + ';' + LaDate);
                    tsl.SaveToFile(Path + 'LiveUpdate\Afaire.txt');
                FINALLY
                    tsl.Free;
                END;
            END;
        END ELSE IF copy(S, 1, 4) = 'SCR;' THEN
        BEGIN
            Log.Add('Début Script ' + DateTimeToStr(Now));
            Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
            FaitLaMAJ := true;
            delete(s, 1, 4);
            Ip := Copy(S, 1, pos(';', S) - 1);
            delete(s, 1, pos(';', s));
            Ftp.Host := Ip;
            port := Copy(S, 1, pos(';', S) - 1);
            delete(s, 1, pos(';', s));
            Ftp.Port := Strtoint(Port);
            versionMAJ := Copy(S, 1, pos(';', S) - 1);
            delete(s, 1, pos(';', s));
            version := S;
            OuEstFTP := 0;
            TRY
                ftp.Connect;
                TRY
                    WHILE OuEstFTP = 0 DO ;
                    IF OuEstFTP AND 1 <> 1 THEN exit;
                    OuEstFTP := 0;
                    ftp.Download(Version, Path + 'LiveUpdate\' + Version);
                    EnvoieAck := Version;
                    EnCours := Ecrs_EnvoiACK;
                    Client.Open;
                FINALLY
                    ftp.Disconnect;
                END;
                tsl := TStringList.create;
                TRY
                    tsl.loadFromFile(Path + 'LiveUpdate\Afaire.txt');
                EXCEPT
                END;
                tsl.Add('SCRIPT;' + versionMAJ + ';' + Path + 'LiveUpdate\' + Version);
                tsl.SaveToFile(Path + 'LiveUpdate\Afaire.txt');
                tsl.Free;
            EXCEPT
            END;
        END ELSE IF copy(S, 1, 4) = 'FIC;' THEN
        BEGIN // récupération des fichiers mauvais
            Log.Add('récupération des fichiers mauvais ' + DateTimeToStr(Now));
            Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
            FaitLaMAJ := true; // FIC;IP;PORT;VERSION;FICHIER
            delete(s, 1, 4);
            Ip := Copy(S, 1, pos(';', S) - 1);
            delete(s, 1, pos(';', s));
            Ftp.Host := Ip;
            port := Copy(S, 1, pos(';', S) - 1);
            delete(s, 1, pos(';', s));
            Ftp.Port := Strtoint(Port);
            version := Copy(S, 1, Pos(';', S) - 1);
            delete(s, 1, pos(';', s));

            OuEstFTP := 0;
            TRY
                ftp.Connect;
                TRY
                    WHILE OuEstFTP = 0 DO ;
                    IF OuEstFTP AND 1 <> 1 THEN
                    BEGIN
                        MapGinkoia.LiveUpdate := false;
                        ToutEstOk := False;
                        Tim_Close.Enabled := true;
                        //Close;
                        exit;
                    END;
                    OuEstFTP := 0;
                    TRY
                        ftp.Download(S, Path + 'LiveUpdate\' + S);
                        EnvoieAck := Version;
                        EnCours := Ecrs_EnvoiACK;
                        Client.Open;
                    EXCEPT
                        DeleteFile(Path + 'LiveUpdate\' + S);
                        MapGinkoia.LiveUpdate := false;
                        ToutEstOk := False;
                        Tim_Close.Enabled := true;
                        //Close;
                        exit;
                    END;
                FINALLY
                    TRY
                        ftp.Delete(S);
                    EXCEPT
                    END;
                    ftp.Disconnect;
                END;
            EXCEPT
            END;

            tsl := TStringList.create;
            TRY
                tsl.loadFromFile(Path + 'LiveUpdate\Afaire.txt');
                j := 0;
                WHILE j < tsl.count DO
                BEGIN
                    IF copy(tsl[j], 1, 4) = 'MAJ;' THEN
                    BEGIN
                        Pass := tsl[j];
                        BREAK;
                    END
                    ELSE inc(j);
                END;
            FINALLY
                tsl.free;
            END;

            delete(Pass, 1, 4);
            delete(Pass, 1, pos(';', Pass));
            Pass := Copy(Pass, 1, Pos(';', Pass) - 1);
            NomDuZip := Pass;
            Unzip.ZipName := Pass;
            Unzip.DoAll := true;
            Unzip.DestDir := Path;
            Unzip.unzip;
            IF zipprob <> '' THEN EXIT;

            Dir := Unzip.Pathname[0];
            delete(Dir, 1, Pos('\', Dir));
            IF pos('\', Dir) > 0 THEN
                delete(Dir, Pos('\', Dir), 2550);
            DirUp := Path + 'LiveUpdate\' + Dir;

            Unzip.ZipName := Path + 'LiveUpdate\' + S;
            Asupr := Path + 'LiveUpdate\' + S;
            Unzip.DestDir := Path;
            Unzip.unzip;
            IF zipprob <> '' THEN EXIT;

            Dir := Unzip.Pathname[0];
            delete(Dir, 1, Pos('\', Dir));
            IF pos('\', Dir) > 0 THEN
                delete(Dir, Pos('\', Dir), 2550);
            Dir := Path + 'LiveUpdate\' + Dir;

            tsl := tstringList.create;
            TRY
                tsl.LoadFromFile(DirUp + '\lesfichiers.lup');
                Copier(Dir, Dirup, tsl);
                tsl.SavetoFile(DirUp + '\lesfichiers.lup');
                Zip.Fileslist.clear;
                AjouteRepZip(DirUp + '\');
                zip.zipname := NomDuZip;
                zip.relativePaths := true;
                zip.rootDir := Path;
                zip.zip;
                detruit(dir);
                detruit(dirUp);
                fileSetAttr(Asupr, 0);
                deletefile(Asupr);
            FINALLY
                tsl.free;
            END;
        END;
        Arecup.delete(0);
    END;
    IF LesFichiers.Count > 0 THEN
        traiteFichierProblem
    ELSE
        Tim_Close.enabled := true;
END;

PROCEDURE TFrm_Client.FTPConnect(Sender: TObject);
BEGIN
    OuEstFTP := OuEstFTP OR 1;
END;

PROCEDURE TFrm_Client.FTPConnectionFailed(Sender: TObject);
BEGIN
    OuEstFTP := OuEstFTP OR 2;
END;

PROCEDURE TFrm_Client.FTPSuccess(Trans_Type: TCmdType);
BEGIN
    OuEstFTP := OuEstFTP OR 4;
END;

PROCEDURE TFrm_Client.FTPFailure(VAR Handled: Boolean;
    Trans_Type: TCmdType);
BEGIN
    OuEstFTP := OuEstFTP OR 8;
END;

PROCEDURE TFrm_Client.FTPTransactionStop(Sender: TObject);
BEGIN
    Label1.Caption := '';
    Label2.Caption := '';
    OuEstFTP := OuEstFTP OR 16;
END;

PROCEDURE TFrm_Client.FormDestroy(Sender: TObject);
BEGIN
    //Dm_Connexion.free;
    Log.Add('Fin du liveUpdate ' + DateTimeToStr(Now));
    Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
    TRY
        Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
    EXCEPT
    END;
    Log.free;
    LesFichiers.free;
    ListeFichier.free;
    Arecup.free;
END;

PROCEDURE TFrm_Client.FTPListItem(Listing: STRING);
VAR
    S: STRING;
    S1: STRING;
BEGIN
    ListeFichier.Add(Listing);
    S := trim(Copy(Listing, 1, 17));
    S1 := Copy(S, 4, 2) + '/' + Copy(S, 1, 2) + '/' + Copy(S, 7, 2) + Copy(S, 9, 17);
    ftp.FTPDirectoryList.ModifDate.add(S1);
    ftp.FTPDirectoryList.size.Add(trim(Copy(Listing, 18, 21)));
    ftp.FTPDirectoryList.name.Add(trim(Copy(Listing, 40, 21)));
END;

PROCEDURE TFrm_Client.FTPTransactionStart(Sender: TObject);
BEGIN
    Caption := 'récupération en cours';
    Label1.Caption := 'Début du transfert';
END;

PROCEDURE TFrm_Client.FTPPacketRecvd(Sender: TObject);
BEGIN
    Label2.Caption := IntToStr(Ftp.BytesRecvd) + ' / ' + IntToStr(Ftp.BytesTotal);
END;

PROCEDURE TFrm_Client.Tim_CloseTimer(Sender: TObject);
VAR
    Path: STRING;
BEGIN
    Tim_Close.Enabled := False;
    IF ToutEstOk THEN
    BEGIN
        Log.Add('Lancement de MAJ ' + DateTimeToStr(Now));
        Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
        Path := ExtractFilePath(Application.exename);
        IF path[length(path)] <> '\' THEN
            Path := path + '\';
        Winexec(Pchar(Path + 'MAJAuto.exe AUTO'), 0);
        ToutEstOk := False;
    END;
    close;
END;

PROCEDURE TFrm_Client.FormPaint(Sender: TObject);
BEGIN
    IF prem THEN
    BEGIN
        prem := false;
        IF (paramcount > 0) AND (uppercase(paramstr(1)) = 'AUTO') THEN
        BEGIN
            Log.Add('Automatique ' + DateTimeToStr(Now));
            Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
            caption := caption + '  -  En Cours... ';
            Button1Click(NIL);
        END;
        IF (paramcount > 0) AND (uppercase(paramstr(1)) = 'SUITE') THEN
        BEGIN
            WinExec(Pchar(Path + 'Script.exe AUTO'), 0);
            Sleep(1000);
            MapGinkoia.LiveUpdate := false;
            ToutEstOk := False;
            Tim_Close.Enabled := true;
            //CLOSE;
            EXIT;
        END;
    END;
END;

PROCEDURE TFrm_Client.ClientError(Sender: TObject;
    Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
    VAR ErrorCode: Integer);
BEGIN
    Log.Add('Erreur Client TCP/IP ' + DateTimeToStr(Now));
    Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
    errorcode := 0;
    ToutEstOk := False;
    Tim_Close.Enabled := true;
    // close;
END;

PROCEDURE TFrm_Client.ClientDisconnect(Sender: TObject;
    Socket: TCustomWinSocket);
BEGIN
    IF EnCours = Ecrs_Identification THEN
    BEGIN
        Log.Add('Deconnexion du serveur TCP/IP ' + DateTimeToStr(Now));
        Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
        Caption := 'Deconnecter par le serveur';
        MapGinkoia.LiveUpdate := False;
        ToutEstOk := False;
        Tim_Close.Enabled := true;
        // close;
    END;
END;

PROCEDURE TFrm_Client.FormClose(Sender: TObject; VAR Action: TCloseAction);
BEGIN
    MapGinkoia.LiveUpdate := false;
    Dm_Connexion.Deconnexion;
END;

PROCEDURE TFrm_Client.Tim_DeconnectTimer(Sender: TObject);
BEGIN
    Tim_Deconnect.Enabled := false;
    MapGinkoia.LiveUpdate := false;
    Dm_Connexion.Deconnexion;
    IF (paramcount > 0) AND (uppercase(paramstr(1)) = 'AUTO') THEN
    BEGIN
        Log.Add('Serveur occupé  ' + DateTimeToStr(Now));
        Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
        Caption := 'Serveur occupé, Attente de disponibilité';
        // TIM_Reconnect.Interval := 10000;
        TIM_Reconnect.Enabled := true;
    END
    ELSE
    BEGIN
        Log.Add('Serveur occupé  ' + DateTimeToStr(Now));
        Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
        Caption := 'Serveur occupé, Attente de disponibilité';
        Button1.Enabled := True;
        Application.MessageBox('Le serveur est occupé, reconnectez vous plus tard', 'Attention', Mb_OK);
    END;
END;

PROCEDURE TFrm_Client.TIM_ReconnectTimer(Sender: TObject);
BEGIN
    TIM_Reconnect.enabled := false;
    Button1Click(NIL);
END;

PROCEDURE TFrm_Client.TIM_PROBTimer(Sender: TObject);
BEGIN
    Log.Add('Problème (trop de temps) ' + DateTimeToStr(Now));
    Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
    TIM_PROB.Enabled := False;
    Caption := 'Deconnexion du serveur';
    Client.Close;
    toutestok := false;
    Tim_Deconnect.Enabled := true;
END;

PROCEDURE TFrm_Client.EnvoiServeur(S: STRING);
BEGIN
    TIM_PROB.Enabled := True;
    Client.Socket.SendText(S);
END;

PROCEDURE TFrm_Client.traiteFichierProblem;
VAR
    I: Integer;
    j: Integer;
    S1: STRING;
    S: STRING;
    ok: Boolean;
    LeFichier: STRING;
BEGIN
    Log.Add('Traitement des fichiers à problème ' + DateTimeToStr(Now));
    Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
    // La liste des fichiers à récupérer
    i := 0;
    WHILE i < LesFichiers.count DO
    BEGIN
        S := LesFichiers[i];
        S1 := Copy(S, Pos(';', S) + 1, Length(S));
        Delete(S, Pos(';', S), Length(S));
        // S C'est le fichier  S1 C'est le .zip
        IF fileExists(Path + 'LiveUpdate\' + S1 + '.ZIP') THEN
        BEGIN
            UnZip.ZipName := Path + 'LiveUpdate\' + S1 + '.ZIP';
            UnZip.DestDir := Path;
            UnZip.ReadZip;
            Ok := False;
            FOR j := 0 TO Unzip.Count - 1 DO
            BEGIN
                LeFichier := Unzip.Filename[J];
                IF Uppercase(S) = Uppercase(LeFichier) THEN
                BEGIN
                    Ok := true;
                    BREAK;
                END;
            END;
            IF ok THEN
                LesFichiers.Delete(i)
            ELSE
                Inc(i);
        END
        ELSE
            Inc(i);
    END;
    IF LesFichiers.count > 0 THEN
    BEGIN
        IF NOT Dm_Connexion.Connexion THEN
        BEGIN
            MapGinkoia.LiveUpdate := false;
            ToutEstOk := False;
            Tim_Close.Enabled := true;
                //CLOSE;
            EXIT;
        END;
        EnCours := Ecrs_Identification;
        Client.Open;
    END
    ELSE
        Tim_Close.enabled := true;
END;

PROCEDURE TFrm_Client.ZipBadCRC(Sender: TObject; CalcCRC, StoredCRC,
    FileIndex: Integer);
BEGIN
    Log.Add('Problème sur le ZIP (Bad CRC) ' + DateTimeToStr(Now));
    Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
    // problème sur le zip
    EnCours := Ecrs_Identification;
    ZIPProb := Zip.ZipNAme;
    Client.Open;
END;

PROCEDURE TFrm_Client.UnZipBadCRC(Sender: TObject; CalcCRC, StoredCRC,
    FileIndex: Integer);
BEGIN
    Log.Add('Problème sur le UnZIP (Bad CRC) ' + DateTimeToStr(Now));
    Log.SaveToFile(ChangeFileExt(Application.exename, '.LOG'));
    EnCours := Ecrs_Identification;
    ZIPProb := UnZip.ZipNAme;
    Client.Open;
END;

{ TLesConnexion }

PROCEDURE TFrm_Client.FormKeyDown(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
VAR
    lv: TTLaVersion;
BEGIN
    IF (ssShift IN shift) AND (ssCtrl IN shift) AND (key = Ord('M')) THEN
    BEGIN
        application.createform(TTLaVersion, lv);
        TRY
            IF lv.showmodal = MrOk THEN
            BEGIN
                VeuVersionSpe := uppercase(Lv.edit1.text);
                IF length(VeuVersionSpe) > 0 THEN
                BEGIN
                    IF copy(VeuVersionSpe, 1, 1) <> 'V' THEN
                        VeuVersionSpe := 'V' + VeuVersionSpe;
                    Button1Click(NIL);
                END;
            END;
        FINALLY
            lv.release;
        END;
    END;
END;

END.

