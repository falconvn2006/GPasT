UNIT UServeur;

INTERFACE

USES
    UCrc32,
    UChxVersion,
    UServClt,
    UCltNom,
    ULogClient,
    inifiles,
    FileCtrl,
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    ULiveUpCst,
    ScktComp,
    ExtCtrls,
    //psvDialogs,
    StdCtrls,
    VCLUnZip,
    VCLZip,
    Psock,
    NMFtp,
    Menus;

TYPE
    TUneConnection = CLASS
        LastConnect: TDateTime;
        Etat: TEnCours;
        Magasin: STRING;
        LesFichiers: TstringList;
        CONSTRUCTOR Create;
        DESTRUCTOR Destroy; OVERRIDE;
    END;

    TFrm_Serveur = CLASS(TForm)
        Serveur: TServerSocket;
        LeTimer: TTimer;
        ZIP: TVCLZip;
        ftp: TNMFTP;
        Panel1: TPanel;
        Label1: TLabel;
        Label2: TLabel;
        Button2: TButton;
        MainMenu1: TMainMenu;
        Configurer1: TMenuItem;
        FTPduserveur1: TMenuItem;
        Portduftpserveur1: TMenuItem;
        ftpduclient1: TMenuItem;
        Portduftpclient1: TMenuItem;
        Button1: TButton;
        Portenlistening1: TMenuItem;
        Creer_version: TTimer;
        Button3: TButton;
        Cheminduftp1: TMenuItem;
        UserduFTPserveur1: TMenuItem;
        PasswordduftpServeur1: TMenuItem;
        PROCEDURE ServeurClientRead(Sender: TObject; Socket: TCustomWinSocket);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormDestroy(Sender: TObject);
        PROCEDURE ServeurClientConnect(Sender: TObject; Socket: TCustomWinSocket);
        PROCEDURE LeTimerTimer(Sender: TObject);
        PROCEDURE ServeurClientDisconnect(Sender: TObject;
            Socket: TCustomWinSocket);
        PROCEDURE ftpPacketSent(Sender: TObject);
        PROCEDURE ZIPTotalPercentDone(Sender: TObject; Percent: Integer);
        PROCEDURE Button2Click(Sender: TObject);
        PROCEDURE ServeurClientError(Sender: TObject; Socket: TCustomWinSocket;
            ErrorEvent: TErrorEvent; VAR ErrorCode: Integer);
        PROCEDURE FTPduserveur1Click(Sender: TObject);
        PROCEDURE Portduftpserveur1Click(Sender: TObject);
        PROCEDURE ftpduclient1Click(Sender: TObject);
        PROCEDURE Portduftpclient1Click(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE Portenlistening1Click(Sender: TObject);
        PROCEDURE Creer_versionTimer(Sender: TObject);
        PROCEDURE Button3Click(Sender: TObject);
        PROCEDURE Cheminduftp1Click(Sender: TObject);
        PROCEDURE UserduFTPserveur1Click(Sender: TObject);
        PROCEDURE PasswordduftpServeur1Click(Sender: TObject);
        PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PRIVATE
        FUNCTION VerifieMagasin(Magasin: STRING): Boolean;
        { Déclarations privées }
    PUBLIC
        { Déclarations publiques }
        ListeClient: TStringList;
        PathVersion: STRING;
        LeLog: STRING;
        Fich: TextFile;
        CheminFtp: STRING;
        ftpserveur: STRING;
        ftpclient: STRING;
        portserveur: STRING;
        portclient: STRING;
        PortListening: STRING;
        UserFtp: STRING;
        PasswordFtp: STRING;
        ReleaseEnCours: Boolean;
        LaVerDem, LaVerArrive: STRING;
        PROCEDURE tslclear;
        FUNCTION FabriqueVersion(VerDem, VerArrive: STRING): STRING;
        FUNCTION VersionExiste(VerDem, VerArrive: STRING): Boolean;
    END;

VAR
    Frm_Serveur: TFrm_Serveur;

IMPLEMENTATION
{$R *.DFM}
CONST
    Granulosite = 16;
    version = '2';

PROCEDURE TFrm_Serveur.FormCreate(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    ListeClient := TStringList.Create;
    ReleaseEnCours := False;
    ini := tinifile.create(ChangeFileExt(application.exename, '.ini'));
    TRY
        PathVersion := ini.readstring('Version', 'Path', '');
        ftpserveur := ini.readstring('FTP', 'SERVEUR', '');
        ftpclient := ini.readstring('FTP', 'CLIENT', '');
        portserveur := ini.readstring('FTP', 'PortServeur', '');
        portclient := ini.readstring('FTP', 'PortClient', '');
        PortListening := ini.ReadString('TPCIP', 'PortListening', '31415');
        CheminFtp := ini.ReadString('FTP', 'CHEMIN', '');
        UserFtp := ini.ReadString('FTP', 'USER', 'Algol/pascalr');
        PasswordFtp := ini.ReadString('FTP', 'PASSWORD', '');

    FINALLY
        ini.free;
    END;
    Serveur.Port := StrToInt(PortListening);
    Serveur.Active := true;
    LeLog := ChangeFileExt(Application.ExeName, '.Log');
    AssignFile(fich, LeLog);
    IF NOT fileexists(LeLog) THEN
    BEGIN
        rewrite(Fich);
        CloseFile(Fich);
    END;
END;

PROCEDURE TFrm_Serveur.FormDestroy(Sender: TObject);
BEGIN
    tslclear;
    ListeClient.free;
END;

PROCEDURE TFrm_Serveur.ServeurClientConnect(Sender: TObject;
    Socket: TCustomWinSocket);
VAR
    s: STRING;
    i: integer;
    TUC: TUneConnection;
BEGIN
    s := Socket.RemoteAddress;
    i := ListeClient.indexOf(s);
    IF i < 0 THEN
        i := ListeClient.addObject(S, TUneConnection.Create);
    tuc := TUneConnection(ListeClient.Objects[i]);
    tuc.LastConnect := Now;
    Label1.Caption := tuc.Magasin + ' Connexion';
    Label1.Update;
END;

PROCEDURE TFrm_Serveur.tslclear;
VAR
    i: integer;
BEGIN
    FOR i := 0 TO ListeClient.count - 1 DO
        TUneConnection(ListeClient.Objects[i]).free;
    ListeClient.clear;
END;

{ TUneConnection }

CONSTRUCTOR TUneConnection.Create;
BEGIN
    INHERITED create;
    etat := Ecrs_Identification;
    LesFichiers := TstringList.create;
END;

PROCEDURE TFrm_Serveur.LeTimerTimer(Sender: TObject);
VAR
    i: Integer;
    tuc: TUneConnection;
    tsl: tstringList;
    k: integer;
    j: Integer;
    l: integer;
    s: STRING;
BEGIN
    IF Serveur.Socket.ActiveConnections = 0 THEN
    BEGIN
        FOR i := 0 TO ListeClient.count - 1 DO
        BEGIN
            tuc := TUneConnection(ListeClient.Objects[i]);
            ListeClient.Objects[i] := NIL;
            tuc.free;
        END;
        ListeClient.Clear;
    END;
    IF Serveur.Socket.ActiveConnections = 0 THEN
    BEGIN
        tsl := tstringlist.create;
        TRY
            tsl.loadFromFile(LeLog);
            i := 0;
            WHILE i < tsl.count DO
            BEGIN
                S := tsl[i];
                delete(s, 1, pos(';', s));
                delete(s, pos(';', s), 255);
                IF Copy(tsl[i], 1, 1) = '@' THEN
                    inc(i)
                ELSE
                BEGIN
                    j := i + 1;
                    k := i;
                    S := Copy(tsl[i], 1, Pos(';', tsl[i])) + S + ';';
                    l := length(s);
                    WHILE j < tsl.count DO
                    BEGIN
                        IF Copy(tsl[j], 1, l) = S THEN
                        BEGIN
                            tsl[k] := '@' + tsl[k];
                            K := J;
                        END;
                        Inc(j);
                    END;
                    inc(i);
                END
            END;
            i := 0;
            WHILE i < tsl.count DO
            BEGIN
                IF Copy(Tsl[i], 1, 1) = '@' THEN
                    tsl.delete(i)
                ELSE
                    inc(i);
            END;
            IF Serveur.Socket.ActiveConnections = 0 THEN
                tsl.SavetoFile(LeLog);
        FINALLY
            tsl.free;
        END;
    END;
END;

PROCEDURE TFrm_Serveur.ServeurClientDisconnect(Sender: TObject;
    Socket: TCustomWinSocket);
VAR
    s: STRING;
    i: integer;
    TUC: TUneConnection;
BEGIN
    s := Socket.RemoteAddress;
    i := ListeClient.indexOf(s);
    IF i >= 0 THEN
    BEGIN
        tuc := TUneConnection(ListeClient.Objects[i]);
        Label1.Caption := tuc.Magasin + ' Deconnexion';
        Label1.Update;
        tuc.free;
        ListeClient.delete(i);
    END;
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

FUNCTION TFrm_Serveur.VerifieMagasin(Magasin: STRING): Boolean;
VAR
    tsl: TstringList;
    s1: STRING;
    s: STRING;
    i: integer;
BEGIN
    result := false;
    tsl := TstringList.Create;
    TRY
        TRY tsl.loadfromfile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'LesClients.txt')EXCEPT END;
        FOR i := 0 TO tsl.count - 1 DO
        BEGIN
            S := tsl[i];
            IF trim(S) <> '' THEN
            BEGIN
                S1 := ChaineSuivante(s);
                REPEAT
                    S1 := ChaineSuivante(s);
                    IF (s1 <> '') AND (S1 = Magasin) THEN
                    BEGIN
                        result := true;
                        Exit;
                    END
                UNTIL S1 = '';
            END;
        END;
    FINALLY
        tsl.free;
    END;
END;

PROCEDURE TFrm_Serveur.ServeurClientRead(Sender: TObject;
    Socket: TCustomWinSocket);
VAR
    TUC: TUneConnection;
    S, s1: STRING;
    PlTuc: Integer;
    tsl: tstringList;
    i, j: integer;
    verd, verf: STRING;
    ladate: STRING;
    tmpFileName: ARRAY[0..MAX_PATH] OF char;

    FUNCTION TraiteMag(LesMags, LeNom: STRING): STRING;
    VAR
        tsl: tstringList;
        i: integer;
        s: STRING;
        PassMags: STRING;
        NomMag: STRING;
        Poste: STRING;
        go: boolean;
        ok: Boolean;
        Numero: integer;
    BEGIN
        Ok := false;
        tsl := tstringList.Create;
        TRY
            NomMag := LeNom;
            Numero := 0;
            TRY tsl.LoadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'LesClients.txt')EXCEPT END;
            FOR i := 0 TO tsl.count - 1 DO
            BEGIN
                S := Tsl[i];
                IF trim(S) <> '' THEN
                BEGIN
                    IF S[length(S)] = ';' THEN
                        Tsl[i] := Copy(Tsl[i], 1, Length(Tsl[i]) - 1);
                    NomMag := ChaineSuivante(S);
                    WHILE (S <> '') DO
                    BEGIN
                        Poste := ChaineSuivante(S);
                        PassMags := LesMags;
                        WHILE PassMags <> '' DO
                        BEGIN
                            IF poste = ChaineSuivante(PassMags) THEN
                            BEGIN
                                ok := true;
                                Numero := i;
                                BREAK;
                            END;
                        END;
                        IF ok THEN BREAK;
                    END;
                    IF ok THEN BREAK;
                END;
            END;
            IF Ok THEN
            BEGIN
                Ok := false;
                result := NomMag;
                // trouver si un poste manque
                S := Tsl[Numero];
                IF S[length(S)] = ';' THEN
                    Tsl[i] := Copy(Tsl[i], 1, Length(Tsl[i]) - 1);
                PassMags := LesMags;
                WHILE PassMags <> '' DO
                BEGIN
                    Poste := ChaineSuivante(PassMags);
                    S := Tsl[Numero];
                    ChaineSuivante(S);
                    Go := True;
                    WHILE s <> '' DO
                    BEGIN
                        IF Poste = ChaineSuivante(S) THEN
                        BEGIN
                            go := false;
                            BREAK;
                        END;
                    END;
                    IF go THEN
                    BEGIN
                        Tsl[i] := Tsl[i] + ';' + Poste;
                        ok := true;
                    END;
                END;
                IF ok THEN
                BEGIN
                    TRY
                        tsl.SavetoFile(extractfilePath(application.exename) + '\LesClients.txt')
                    EXCEPT END;
                END;
            END
            ELSE
            BEGIN
                // Ajouter les postes
                result := LeNom;
                tsl.Add(LeNom + ';' + LesMags);
                TRY tsl.SavetoFile(extractfilePath(application.exename) + '\LesClients.txt')EXCEPT END;
            END;
        FINALLY
            tsl.free;
        END;
    END;

    FUNCTION MajVersion(Version: STRING): Integer;
    VAR
        a1, b1, c1, d1: integer;
        a, b, c, d: integer;
        j, i: integer;
        tsl: tstringlist;
        s: STRING;
    BEGIN
        S := version;
        Append(Fich);
        Writeln(fich, tuc.Magasin + ';VER;' + Version + ';' + DateTimeToStr(now));
        CloseFile(Fich);
        A := StrToInt(Copy(S, 1, Pos('.', S) - 1)); delete(s, 1, pos('.', s));
        B := StrToInt(Copy(S, 1, Pos('.', S) - 1)); delete(s, 1, pos('.', s));
        C := StrToInt(Copy(S, 1, Pos('.', S) - 1)); delete(s, 1, pos('.', s));
        D := StrToInt(trim(S));
        tsl := tstringList.create;
        TRY
            tsl.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Version.txt');
            j := -1;
            FOR i := 0 TO tsl.count - 1 DO
            BEGIN
                s := tsl[i]; delete(s, 1, pos(';', S));
                A1 := StrToInt(Copy(S, 1, Pos('.', S) - 1)); delete(s, 1, pos('.', s));
                B1 := StrToInt(Copy(S, 1, Pos('.', S) - 1)); delete(s, 1, pos('.', s));
                C1 := StrToInt(Copy(S, 1, Pos('.', S) - 1)); delete(s, 1, pos('.', s));
                D1 := StrToInt(trim(S));
                IF (a = a1) AND (b = b1) AND (c = c1) AND (d = d1) THEN
                BEGIN
                    j := i;
                    s := tsl[i];
                    verd := Copy(S, 1, pos(';', s) - 1);
                    delete(s, 1, pos(';', S));
                    S1 := S;
                    break;
                END;
            END;
            tsl.clear;
            IF j = -1 THEN
            BEGIN
                result := -1; // Mauvaise Version
            END
            ELSE
            BEGIN
                tsl.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Clients.txt');
                j := -1;
                FOR i := 0 TO tsl.count - 1 DO
                BEGIN
                    IF Copy(tsl[i], 1, pos(';', tsl[i]) - 1) = tuc.magasin THEN
                    BEGIN
                        j := i;
                        break;
                    END;
                END;
                IF j = -1 THEN
                    result := 0 // Pas de version à générer
                ELSE
                BEGIN
                    S := tsl[i]; delete(s, 1, pos(';', S));
                    A1 := StrToInt(Copy(S, 1, Pos('.', S) - 1)); delete(s, 1, pos('.', s));
                    B1 := StrToInt(Copy(S, 1, Pos('.', S) - 1)); delete(s, 1, pos('.', s));
                    C1 := StrToInt(Copy(S, 1, Pos('.', S) - 1)); delete(s, 1, pos('.', s));
                    D1 := StrToInt(Copy(S, 1, Pos(';', S) - 1)); delete(s, 1, pos(';', s));
                    IF (a = a1) AND (b = b1) AND (c = c1) AND (d = d1) THEN
                        result := 2 // déjà à jour
                    ELSE IF (a > a1) OR
                        ((a >= a1) AND (b > b1)) OR
                        ((a >= a1) AND (b >= b1) AND (c > c1)) OR
                        ((a >= a1) AND (b >= b1) AND (c >= c1) AND (d > d1)) THEN
                    BEGIN
                        result := -2; // Prob de version
                    END
                    ELSE
                    BEGIN
                        result := 1; // Une version à générer
                        S := tsl[i]; delete(s, 1, pos(';', S));
                        ladate := Copy(S, Pos(';', S) + 1, 255);
                        S := Copy(S, 1, Pos(';', S) - 1);
                        tsl.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Version.txt');
                        FOR i := 0 TO tsl.count - 1 DO
                            IF Copy(Tsl[i], Pos(';', Tsl[i]) + 1, 255) = S THEN
                            BEGIN
                                verf := Copy(Tsl[i], 1, pos(';', Tsl[i]) - 1);
                                Break;
                            END;
                    END;
                END;
            END;
        FINALLY
            tsl.free;
        END;
    END;

BEGIN
    s := Socket.RemoteAddress;
    PlTuc := ListeClient.indexOf(s);
    IF PlTuc < 0 THEN
        Tuc := NIL
    ELSE
        tuc := TUneConnection(ListeClient.Objects[PlTuc]);
    TRY
        S := Socket.ReceiveText;
        IF tuc <> NIL THEN
        BEGIN
            tuc.LastConnect := Now;
            IF Copy(S, 1, 3) = '@@;' THEN
            BEGIN
                delete(s, 1, 3);
                verd := '';
                verf := s;
                IF (ReleaseEnCours) OR (Creer_Version.enabled) THEN
                BEGIN
                    Socket.SendText('Plus Tard');
                END
                ELSE IF NOT VersionExiste(verd, verf) THEN
                BEGIN
                    Socket.SendText('Plus Tard');
                    LaVerDem := verd;
                    LaVerArrive := verf;
                    Creer_Version.enabled := true;
                END
                ELSE
                BEGIN
                    S := FabriqueVersion(verd, verf);
                    IF S = 'NOK' THEN
                        Socket.SendText('Pas de Version')
                    ELSE
                        // Nom du serveur FTP, PORT, Version de MAJ, Nom du fichier, Date de MAJ
                        Socket.SendText(ftpclient + ';' + portclient + ';' + Version + ';' + S + ';' + LaDate);
                END;
            END
            ELSE IF Copy(S, 1, 4) = '@@@;' THEN
            BEGIN // reception d'une demande PANTIN
                IF (ReleaseEnCours) OR (Creer_Version.enabled) THEN
                BEGIN
                    Socket.SendText('OK');
                    Socket.Close;
                    EXIT;
                END
                ELSE
                BEGIN
                    delete(S, 1, 4);
                    S := TraiteMag(Copy(S, 1, pos('\', S) - 1), Copy(S, Pos('\', S) + 1, 255));
                    Socket.SendText(S);
                    Socket.Close;
                    EXIT;
                END;
            END;
            IF S = 'Deconnexion' THEN // Deconnexion du client
            BEGIN
                Label1.Caption := tuc.Magasin + 'deconnexion';
                Label1.Update;
                Tuc.Free;
                ListeClient.Delete(PlTuc);
                socket.close;
                EXIT;
            END;
            IF Copy(S, 1, 4) = 'ZIP;' THEN // Problème dans le ZIP
            BEGIN
                Label1.Caption := tuc.Magasin + 'deconnexion';
                Label1.Update;
                Append(Fich);
                Writeln(fich, 'PROBZIP;' + tuc.Magasin + ';' + S);
                CloseFile(Fich);
                Tuc.Free;
                ListeClient.Delete(PlTuc);
                socket.close;
                EXIT;
            END;
            CASE tuc.Etat OF
                Ecrs_Identification: // Identification
                    BEGIN // doit contenir Bonjour;Nom Mag
                        Label1.Caption := tuc.Magasin + ' Identification';
                        Label1.Update;
                        IF copy(S, 1, Pos(';', s)) = 'SALUT;' THEN
                        BEGIN
                            // demande du launcher
                            // SALUT;Magasin;Societe;LaVersion ;
                            delete(s, 1, Pos(';', s));
                            IF pos(';', S) > 0 THEN
                                tuc.Magasin := Copy(S, 1, Pos(';', s) - 1)
                            ELSE
                                tuc.Magasin := S;
                            IF VerifieMagasin(tuc.Magasin) THEN
                            BEGIN
                                Append(Fich);
                                Writeln(fich, tuc.Magasin + ';Launch;' + S + ';' + DateTimeToStr(now));
                                CloseFile(Fich);
                                WHILE Pos(';', S) > 0 DO
                                    delete(S, 1, Pos(';', S));
                                IF MajVersion(S) = 1 THEN
                                    Socket.SendText('YES')
                                ELSE
                                BEGIN
                                    // vérification si un exe tous seul
                                    tsl := tstringList.create;
                                    TRY
                                        TRY tsl.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt'); EXCEPT END;
                                        j := -1;
                                        FOR i := 0 TO tsl.count - 1 DO
                                        BEGIN
                                            S := tsl[i];
                                            IF Copy(S, 1, pos(';', tsl[i]) - 1) = tuc.magasin THEN
                                            BEGIN
                                                j := i;
                                                break;
                                            END;
                                        END;
                                        IF j = -1 THEN
                                            Socket.SendText('NO')
                                        ELSE
                                            Socket.SendText('YES');
                                    FINALLY
                                        tsl.free;
                                    END;
                                END
                            END
                            ELSE
                            BEGIN // Pas d'identification
                                Append(Fich);
                                Writeln(fich, 'NOGOOD;' + S + ';IP;' + Socket.RemoteAddress + ';' + DateTimeToStr(now));
                                CloseFile(Fich);
                                Tuc.Free;
                                ListeClient.Delete(PlTuc);
                                Socket.Close;
                            END;
                        END
                        ELSE IF copy(S, 1, Pos(';', s)) = 'Suivi;' THEN
                        BEGIN
                            delete(s, 1, Pos(';', s));
                            IF pos(';', S) > 0 THEN
                                tuc.Magasin := Copy(S, 1, Pos(';', s) - 1)
                            ELSE
                                tuc.Magasin := S;
                            IF VerifieMagasin(tuc.Magasin) THEN
                            BEGIN
                                WHILE Pos(';', S) > 0 DO
                                    delete(S, 1, Pos(';', S));
                                Append(Fich);
                                Writeln(fich, tuc.Magasin + ';SUIVI;' + S + ';' + DateTimeToStr(now));
                                CloseFile(Fich);
                                Socket.SendText('OK');
                            END
                            ELSE
                            BEGIN // Pas d'identification
                                Append(Fich);
                                Writeln(fich, 'NOGOOD;' + S + ';IP;' + Socket.RemoteAddress + ';' + DateTimeToStr(now));
                                CloseFile(Fich);
                                Tuc.Free;
                                ListeClient.Delete(PlTuc);
                                Socket.Close;
                            END;
                        END
                        ELSE IF copy(S, 1, Pos(';', s)) = 'Bonjour;' THEN
                        BEGIN
                            delete(s, 1, Pos(';', s));
                            IF pos(';', S) > 0 THEN
                                tuc.Magasin := Copy(S, 1, Pos(';', s) - 1)
                            ELSE
                                tuc.Magasin := S;
                            IF VerifieMagasin(tuc.Magasin) THEN
                            BEGIN
                                tuc.Etat := Ecrs_AttenteQuestion;
                                Append(Fich);
                                Writeln(fich, tuc.Magasin + ';IP;' + Socket.RemoteAddress + ';' + DateTimeToStr(now));
                                CloseFile(Fich);
                                Socket.SendText('OK');
                            END
                            ELSE
                            BEGIN // Pas d'identification
                                Append(Fich);
                                Writeln(fich, 'NOGOOD;' + S + ';IP;' + Socket.RemoteAddress + ';' + DateTimeToStr(now));
                                CloseFile(Fich);
                                Tuc.Free;
                                ListeClient.Delete(PlTuc);
                                Socket.Close;
                            END;
                        END
                        ELSE
                        BEGIN // Pas d'identification
                            Tuc.Free;
                            ListeClient.Delete(PlTuc);
                            Socket.Close;
                        END;
                    END;
                Ecrs_AttenteQuestion: // Attente d'un evenement client
                    BEGIN
                        IF copy(S, 1, 5) = 'Gotya' THEN
                        BEGIN
                            GetTempFileName(Pchar(PathVersion + '\'), Pchar('tmp'), 0, tmpFileName);
                            S := Strpas(tmpFileName);
                            deletefile(S);
                            s := Changefileext(Strpas(tmpFileName), '.zip');
                            Zip.ZipName := S;
                            Zip.FilesList := tuc.LesFichiers;
                            zip.Zip;
                            IF trim(CheminFtp) <> '' THEN
                            BEGIN
                                CopyFile(Pchar(S), Pchar(CheminFtp + ExtractFileName(S)), False);
                                DeleteFile(S);
                            END
                            ELSE
                            BEGIN

                                TRY
                                    ftp.Host := ftpserveur;
                                    ftp.port := strtoint(portserveur);
                                    ftp.UserId := UserFtp;
                                    ftp.Password := PasswordFtp;
                                    ftp.Connect;
                                    ftp.UpLoad(S, ExtractfileName(S));
                                    ftp.Disconnect;
                                    DeleteFile(S);
                                EXCEPT
                                    ftp.Disconnect;
                                END;
                            END;
                            Socket.SendText('FIC;' + ftpclient + ';' + portclient + ';' + Version + ';' + ExtractfileName(S));
                        END
                        ELSE IF Copy(S, 1, 6) = 'Wanna;' THEN
                        BEGIN
                            delete(S, 1, 6);
                            tuc.LesFichiers.add(PathVersion + '\' + S);
                            Socket.SendText('OK');
                        END
                        ELSE IF Copy(S, 1, 12) = 'LastVersion;' THEN
                        BEGIN
                            Label1.Caption := tuc.Magasin + ' Version';
                            Label1.Update;
                            delete(s, 1, 12);

                            Append(Fich);
                            Writeln(fich, tuc.Magasin + ';VER;' + S + ';' + DateTimeToStr(now));
                            CloseFile(Fich);

                            I := MajVersion(S);
                            IF i = -2 THEN
                            BEGIN
                                Socket.SendText('Problème ');
                                Append(Fich);
                                Writeln(fich, tuc.Magasin + ';ERREUR VER;' + verd + ';' + DateTimeToStr(now));
                                CloseFile(Fich);
                            END
                            ELSE IF i = -1 THEN
                            BEGIN
                                Socket.SendText('Mauvaise Version');
                                Append(Fich);
                                Writeln(fich, tuc.Magasin + ';ERREUR VER;' + S + ';' + DateTimeToStr(now));
                                CloseFile(Fich);
                            END
                            ELSE IF i = 0 THEN
                            BEGIN
                                Socket.SendText('Pas de Version');
                            END
                            ELSE IF i = 2 THEN
                            BEGIN
                                Socket.SendText('A jour');
                            END
                            ELSE
                            BEGIN // I=1
                                IF NOT VersionExiste(verd, verf) THEN
                                BEGIN
                                    Socket.SendText('Pas de Version')
                                END
                                ELSE
                                BEGIN
                                    S := FabriqueVersion(verd, verf);
                                    IF S = 'NOK' THEN
                                        Socket.SendText('Pas de Version')
                                    ELSE
                                        // Nom du serveur FTP, PORT, Version de MAJ, Nom du fichier, Date de MAJ
                                        Socket.SendText(ftpclient + ';' + portclient + ';' + Version + ';' + S + ';' + LaDate);
                                END;
                            END;
                        END
                        ELSE IF S = 'YaQuelqueChose' THEN
                        BEGIN
                            tsl := tstringList.create;
                            TRY
                                TRY tsl.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt'); EXCEPT END;
                                j := -1;
                                FOR i := 0 TO tsl.count - 1 DO
                                BEGIN
                                    S := tsl[i];
                                    IF Copy(S, 1, pos(';', tsl[i]) - 1) = tuc.magasin THEN
                                    BEGIN
                                        Delete(S, 1, Pos(';', S));
                                        IF Pos(';', S) > 0 THEN
                                        BEGIN
                                            delete(S, 1, Pos(';', S));
                                            IF (Now - StrToDateTime(S)) > 0.5 THEN // à renvoyer
                                            BEGIN
                                                S := tsl[i];
                                                WHILE S[length(S)] <> ';' DO
                                                    delete(s, length(s), 1);
                                                delete(s, length(s), 1);
                                                tsl[i] := S;
                                                j := i;
                                                break;
                                            END;
                                        END
                                        ELSE
                                        BEGIN
                                            j := i;
                                            break;
                                        END;
                                    END;
                                END;
                                IF j = -1 THEN
                                    Socket.SendText('Rien')
                                ELSE
                                BEGIN
                                    S := tsl[i]; delete(s, 1, pos(';', S));
                                    // Nom du serveur FTP, Version de MAJ, Nom du fichier
                                    Socket.SendText(ftpclient + ';' + portclient + ';' + Version + ';' + S);
                                    tsl[i] := tsl[i] + ';' + DateTimeToStr(now);
                                    tsl.SavetoFile(extractfilePath(application.exename) + 'SpeClients.txt');
                                END;
                            FINALLY
                                tsl.free;
                            END;
                        END ELSE IF Copy(S, 1, 11) = 'MajVersion;' THEN
                        BEGIN
                            delete(S, 1, 11);
                            Append(Fich);
                            Writeln(fich, tuc.Magasin + ';MAJ;' + S + ';' + DateTimeToStr(now));
                            CloseFile(Fich);
                            Socket.SendText('OK');
                        END
                        ELSE IF Copy(S, 1, 10) = 'MajScript;' THEN
                        BEGIN
                            delete(S, 1, 10);
                            IF (pos(';', S) > 0) AND (Copy(S, pos(';', S), 5) = ';PROB') THEN
                            BEGIN
                                delete(S, pos(';', S), 255);
                                S := ExtractFileName(S);
                                Append(Fich);
                                Writeln(fich, tuc.Magasin + ';ERR SCRIPT;' + S + ';' + DateTimeToStr(now));
                                CloseFile(Fich);
                            END
                            ELSE
                            BEGIN
                                Append(Fich);
                                Writeln(fich, tuc.Magasin + ';SCRIPT;' + S + ';' + DateTimeToStr(now));
                                CloseFile(Fich);
                                tsl := tstringList.create;
                                TRY
                                    TRY tsl.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'SpeClients.txt'); EXCEPT END;
                                    i := 0;
                                    WHILE i < tsl.count DO
                                    BEGIN
                                        IF copy(tsl[i], 1, pos(';', tsl[i]) - 1) = tuc.Magasin THEN
                                        BEGIN
                                            S1 := tsl[i];
                                            delete(s1, 1, pos(';', S1));
                                            IF pos(';', S1) > 0 THEN
                                                S1 := Copy(S1, 1, pos(';', S1) - 1);
                                            IF Uppercase(extractfileName(S)) = Uppercase(extractfilename(s1)) THEN
                                                tsl.delete(i)
                                            ELSE
                                                inc(i);
                                        END
                                        ELSE
                                            inc(i);
                                    END;
                                    tsl.SavetoFile(extractfilePath(application.exename) + 'SpeClients.txt');
                                FINALLY
                                    tsl.free;
                                END;
                            END;
                            Socket.SendText('OK');
                        END;
                    END;
            END;
        END
        ELSE
            Socket.Close;
    EXCEPT // perte de connexion
        IF tuc <> NIL THEN
        BEGIN
            i := ListeClient.IndexOfObject(tuc);
            IF i >= 0 THEN
            BEGIN
                ListeClient.delete(i);
                tuc.free;
            END;
        END;
    END;
END;

FUNCTION ModifFichier(FichierS, FichierD, FichierRes: STRING): integer;
VAR
    Path: STRING;
    TmS: TmemoryStream;
    TmD: TmemoryStream;
    TmRes: TmemoryStream;
    plD: LongInt;
    B: LongInt;
    A: LongInt;
    PtS: PChar;
    PtD: PChar;
    pos: LongInt;
    Taille: LongInt;
    titre: STRING;
    LastMessage: DWord;

    FUNCTION trouveChar(P1: Pointer; VAR P2; LeChar1: DWord; Length: Integer): Integer; ASSEMBLER;
    ASM
                PUSH    ESI
                PUSH    EDI
                PUSH    EBX         // Sauvegarde de la pile

                MOV     EBX,0
                PUSH    EBX

                MOV     EBX,LeCHAR1 // Stocker la valeur

                MOV     ESI,P1      // Adresse de P1
                MOV     EDI,P2      // Adresse de P2

                XOR     ECX,ECX     // Passage de ECX à Zéro
                MOV     EDX, Length // Taille Maxi

        @@1:    LODSD

                CMP     EAX,EBX     // Teste si OK
                JE      @@3

        @@5:    CMP     EDX,ECX     // teste si maxi
                JE      @@4

                INC     ECX         // Augmente la place
                JMP     @@1         // Boucle

        @@3:    MOV     EAX,ECX     // Stockage de la place
                STOSD
                POP     EAX
                INC     EAX
                PUSH    EAX
                CMP     EAX,10000
                JE      @@4
                JMP     @@5         // Boucle

        @@4:    POP     EAX
                MOV     EAX,-1       // retour de -1
                STOSD

                POP     EBX         // Restore la boucle
                POP     EDI
                POP     ESI
    END;

    FUNCTION CompareMemLen(P1, P2: Pointer; Length: Integer): Integer; ASSEMBLER;
    ASM
                PUSH    ESI
                PUSH    EDI         // Sauvegarde de la pile

                MOV     ESI,P1      // Adresse P1
                MOV     EDI,P2      // Adresse P2

                MOV     EAX,Length  // Stockage de longueur (retour)
                REPE    CMPSD       // Compare jusqu'a ECX (length) tant que égal ou fini
                                    // Sur des double mots (4 Octets)
                JNE     @@3         // si Pas EGAL
                JMP     @@1         // si égal toute la longeur
        @@3:    INC     ECX         // Le dernier est pas bon on Inc
                SUB     EAX,ECX     // moins le reste de CX
        @@1:    POP     EDI
                POP     ESI         // Restore la pile
    END;

    FUNCTION Nombre_similaire(pls, pld: Integer): LongWord;
    VAR
        _PtS: PChar;
        _PtD: PChar;
    BEGIN
        // Result := 0;
        _PtS := PtS; Inc(_pts, pls); _PtD := PtD; Inc(_ptD, pld);
        taille := TmS.size - pls;
        IF Tmd.size - pld < taille THEN
            taille := Tmd.size - pld;
        Taille := taille DIV 4;
        Result := CompareMemLen(_PTS, _ptD, taille);
    END;

    FUNCTION RechercheSimilaire(pld: Integer; VAR pos: integer; VAR Taille: Integer): Boolean;
    VAR
        PtRech: DWord;
        A: LongInt;
        X: LongInt;
        jj: Longint;
        II: longint;
        tot: Longint;

        PassA: Longint;
        PassX: Longint;
        _Pass: PCHAR;

        Leresultat: ARRAY[0..10000] OF integer;

    BEGIN
        _Pass := Ptd;
        Inc(_Pass, pld);
        Move(_pass^, PtRech, 4);
        PassA := -1; PassX := 0;
        ii := tms.size DIV 4;
        tot := 0;
        REPEAT
            _Pass := Pts;
            inc(_Pass, tot);
            trouveChar(_Pass, Leresultat, PtRech, ii);
            jj := 0;
            WHILE Leresultat[jj] <> -1 DO
            BEGIN
                X := Leresultat[jj];
                A := Nombre_Similaire(X * 4, pld);
                IF A > PassA THEN
                BEGIN
                    PassA := A;
                    PassX := X;
                END;
                inc(jj);
            END;
            IF jj = 10000 THEN
            BEGIN
                IF PassA > 128 THEN
                    BREAK;
                X := Leresultat[jj - 1];
                tot := tot + X * 4;
                dec(ii, X);
            END;
        UNTIL jj <> 10000;
        IF PassA > 4 THEN
        BEGIN
            result := true;
            Pos := PassX * 4;
            Taille := PassA * 4;
        END
        ELSE
        BEGIN
            result := false;
            IF PassA < 0 THEN
            BEGIN
                Pos := 0;
                Taille := 0;
            END
            ELSE
            BEGIN
                Pos := PassX * 4;
                Taille := PassA * 4;
            END;
        END;
    END;

BEGIN
    Path := ExtractFilePath(FichierRes);
    IF path[length(path)] <> '\' THEN Path := Path + '\';
    Forcedirectories(Path);
    TmS := TmemoryStream.Create;
    TmD := TmemoryStream.Create;
    TmRes := TmemoryStream.Create;
    titre := ExtractFileName(FichierS);
    LastMessage := GetTickCount;
    TRY
        TmS.LoadFromFile(FichierS);
        TmD.LoadFromFile(FichierD);
        tmS.Seek(0, soFromBeginning);
        tmD.Seek(0, soFromBeginning);
        ptd := tmd.memory;
        Pts := tms.memory;
        // faire sauter si même taille
        IF tms.size = tmd.size THEN
        BEGIN
            IF comparemem(ptd, pts, tmd.size) THEN
            BEGIN
                result := 0;
                EXIT;
            END;
        END;
        plD := 0;
        REPEAT
            IF NOT RechercheSimilaire(pld, pos, taille) THEN
            BEGIN
                A := Taille;
                B := 0;
                REPEAT
                    IF RechercheSimilaire(pld + A, pos, taille) THEN
                    BEGIN
                        // Sauvegarder précédent
                        IF Pld + A > tmd.size THEN
                            A := tmd.size - Pld;
                        B := A OR $20000000;
                        TmRes.Write(B, Sizeof(B));
                        tmd.seek(pld, soFromBeginning);
                        TmRes.CopyFrom(tmd, A);
                        B := -1;
                        BREAK;
                    END
                    ELSE A := A + Granulosite;
                UNTIL (Pld + A > tmd.size);
                IF B = 0 THEN
                BEGIN
                    // Sauvegarder précédent
                    IF Pld + A > tmd.size THEN
                        A := tmd.size - Pld;
                    B := A OR $20000000;
                    TmRes.Write(B, Sizeof(B));
                    tmd.seek(pld, soFromBeginning);
                    TmRes.CopyFrom(tmd, A);
                END;
            END
            ELSE
            BEGIN
                A := Taille;
                IF Pld + A > tmd.size THEN
                    A := tmd.size - Pld;
                B := A OR $40000000;
                TmRes.Write(B, Sizeof(B));
                B := Pos;
                TmRes.Write(B, Sizeof(B));
            END;
            pld := pld + A;
            Frm_Serveur.Label2.Caption := Titre + '  ' + Inttostr(Pld) + ' / ' + Inttostr(tmd.size);
            Frm_Serveur.Label2.Update;
            IF GetTickCount > LastMessage + 10000 THEN
            BEGIN
                Application.ProcessMessages;
                LastMessage := GetTickCount;
            END;
        UNTIL (pld >= Tmd.Size);
        IF tmres.size > Tmd.Size THEN
        BEGIN
            result := -1;
            TmD.SaveToFile(FichierRes);
            ///TmRes.SaveToFile(FichierRes);
        END
        ELSE
        BEGIN
            result := 1;
            TmRes.SaveToFile(FichierRes);
        END;
    FINALLY
        tms.free;
        tmd.free;
        tmRes.free;
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

FUNCTION TFrm_Serveur.FabriqueVersion(VerDem, VerArrive: STRING): STRING;
VAR
    Fich_release: STRING;
    ListFic: tstringList;
    ttsl: tstringList;
    tsl: tstringList;
    i, j: integer;
    S: STRING;
    crc: LongWord;

    VerS: STRING;
    D1, D2, D3, D4: Integer;
    A1, A2, A3, A4: Integer;

    PROCEDURE Recherche(rep, dest, resulta: STRING);
    VAR
        f: tsearchrec;
        A: Integer;
    BEGIN
        IF findfirst(rep + '*.*', faanyfile, f) = 0 THEN
        BEGIN
            REPEAT
                Application.ProcessMessages;
                IF Uppercase(f.name) = 'SCRIPT.SCR' THEN
                    continue;
                IF (f.name <> '.') AND (f.name <> '..') THEN
                BEGIN
                    IF f.Attr AND faDirectory = 0 THEN
                    BEGIN
                        IF dest = '' THEN
                        BEGIN
                            ListFic.Add('-1;' + resulta + f.name);
                            ForceDirectories(resulta);
                            CopyFile(Pchar(Rep + f.Name), Pchar(resulta + f.name), False);
                            FileSetAttr(resulta + f.name, 0);
                            Zip.FilesList.add(resulta + f.name);
                        END
                        ELSE
                        BEGIN
                            IF (fileexists(dest + f.Name)) AND (uppercase(f.Name) <> 'LIVEUPCLIENT.EXE')
                              And (Copy(uppercase(f.Name),1,7) <> 'MAJAUTO')
                              And (Uppercase(extractFileext(f.Name))<>'.ALG')
                              And (Uppercase(extractFileext(f.Name))<>'.ZIP') THEN
                            BEGIN
                                A := ModifFichier(Dest + f.Name, Rep + f.Name, resulta + f.name);
                                IF A <> 0 THEN
                                BEGIN
                                    IF A > 0 THEN
                                    BEGIN
                                        crc := FileCRC32(Dest + f.Name);
                                        ListFic.Add(Inttostr(A) + ';' + resulta + f.name + ';' + Inttostr(crc));
                                    END
                                    ELSE
                                        ListFic.Add(Inttostr(A) + ';' + resulta + f.name);
                                    Zip.FilesList.ADD(resulta + f.name);
                                END;
                            END
                            ELSE
                            BEGIN
                                ListFic.Add('-1;' + resulta + f.name);
                                ForceDirectories(resulta);
                                CopyFile(Pchar(Rep + f.Name), Pchar(resulta + f.name), False);
                                FileSetAttr(resulta + f.name, 0);
                                Zip.FilesList.add(resulta + f.name);
                            END;
                        END;
                    END
                    ELSE
                        recherche(Rep + f.name + '\', dest + f.name + '\', resulta + f.name + '\');
                END;
            UNTIL findnext(f) <> 0;
        END;
        findclose(f);
    END;

BEGIN
    //
    ReleaseEnCours := true;
    TRY
        VerDem := trim(Uppercase(verdem));
        VerArrive := trim(Uppercase(VerArrive));
        IF Verdem <> '' THEN
            Fich_release := Verdem + '-' + VerArrive + '.zip'
        ELSE
            Fich_release := VerArrive + '.zip';

        result := Fich_release;
        S := ExtractFilePath(Application.exename) + Fich_release;
        IF NOT fileexists(S) THEN
        BEGIN
            Label1.Caption := 'Version ' + Fich_release;
            Label1.Update;
            Zip.FilesList.Clear;
            ListFic := TstringList.Create;
            IF VerDem = '' THEN
            BEGIN
                IF (NOT fileexists(PathVersion + '\' + VerArrive + '\Script.scr')) THEN
                BEGIN
                    Label2.Caption := 'Pas ' + PathVersion + '\' + VerArrive + '\Script.scr ';
                    Label2.Update;
                    result := 'NOK';
                    EXIT;
                END;
            END
            ELSE IF (NOT fileexists(PathVersion + '\' + VerArrive + '\Script.scr')) OR
                (NOT fileexists(PathVersion + '\' + Verdem + '\Script.scr')) THEN
            BEGIN
                Label2.Caption := 'Pas ' + PathVersion + '\' + VerArrive + '\Script.scr ou' + PathVersion + '\' + Verdem + '\Script.scr';
                Label2.Update;
                result := 'NOK';
                EXIT;
            END;

            IF VerDem <> '' THEN
                Recherche(PathVersion + '\' + VerArrive + '\', PathVersion + '\' + Verdem + '\', PathVersion + '\' + VerArrive + 'UP\')
            ELSE
                Recherche(PathVersion + '\' + VerArrive + '\', '', PathVersion + '\' + VerArrive + 'UP\');

            ListFic.Savetofile(PathVersion + '\' + VerArrive + 'UP\LesFichiers.LUP');
            Zip.FilesList.Add(PathVersion + '\' + VerArrive + 'UP\LesFichiers.LUP');

            IF VerDem <> '' THEN
            BEGIN
                tsl := TstringList.Create;
                tsl.LoadFromFile(PathVersion + '\' + Verdem + '\SCRIPT.SCR');
                i := tsl.count - 1;
                WHILE Copy(tsl[i], 1, 9) <> '<RELEASE>' DO
                    dec(i);
                S := Tsl[i];
                // dernière version du script de démarage
                VerS := S;
                delete(vers, 1, 9);
                D1 := strtoint(Copy(Vers, 1, pos('.', Vers) - 1)); delete(vers, 1, pos('.', vers));
                D2 := strtoint(Copy(Vers, 1, pos('.', Vers) - 1)); delete(vers, 1, pos('.', vers));
                D3 := strtoint(Copy(Vers, 1, pos('.', Vers) - 1)); delete(vers, 1, pos('.', vers));
                D4 := strtoint(trim(Vers));
                tsl.LoadFromFile(PathVersion + '\' + VerArrive + '\SCRIPT.SCR');
                A1 := 0;
                A2 := 0;
                A3 := 0;
                A4 := 0;
                i := tsl.count - 1;
                REPEAT
                    IF Copy(tsl[i], 1, 9) = '<RELEASE>' THEN
                    BEGIN
                        VerS := Tsl[i];
                        delete(vers, 1, 9);
                        A1 := strtoint(Copy(Vers, 1, pos('.', Vers) - 1)); delete(vers, 1, pos('.', vers));
                        A2 := strtoint(Copy(Vers, 1, pos('.', Vers) - 1)); delete(vers, 1, pos('.', vers));
                        A3 := strtoint(Copy(Vers, 1, pos('.', Vers) - 1)); delete(vers, 1, pos('.', vers));
                        A4 := strtoint(trim(Vers));
                        IF (A1 < D1) OR
                            ((A1 <= D1) AND (A2 < D2)) OR
                            ((A1 <= D1) AND (A2 <= D2) AND (A3 < D3)) OR
                            ((A1 <= D1) AND (A2 <= D2) AND (A3 <= D3) AND (A4 < D4)) OR
                            ((A1 <= D1) AND (A2 <= D2) AND (A3 <= D3) AND (A4 <= D4)) THEN
                            BREAK;
                    END;
                    dec(i)
                UNTIL i < 0;
                IF (A1 <= D1) AND (A2 <= D2) AND (A3 <= D3) AND (A4 <= D4) THEN
                BEGIN
                    REPEAT
                        Inc(i);
                    UNTIL (i >= tsl.count - 1) OR (copy(tsl[i], 1, 9) = '<RELEASE>');
                END;
                ttsl := tstringList.Create;
                FOR j := i TO tsl.count - 1 DO
                    ttsl.add(tsl[j]);
                tsl.free;
                ttsl.SaveToFile(PathVersion + '\' + VerArrive + 'UP\LESCRIPT.SCR');
            END
            ELSE
            BEGIN
                tsl := TstringList.Create;
                tsl.LoadFromFile(PathVersion + '\' + VerArrive + '\SCRIPT.SCR');
                tsl.SaveToFile(PathVersion + '\' + VerArrive + 'UP\LESCRIPT.SCR');
                tsl.free;
            END;
            Zip.FilesList.Add(PathVersion + '\' + VerArrive + 'UP\LESCRIPT.SCR');
            Zip.ZipName := ExtractFilePath(Application.exename) + Fich_release;
            Label1.Caption := ' Zip version ';
            Label1.Update;
            zip.Zip;
            Label1.Caption := ' Envoie version ';
            Label1.Update;
            IF trim(CheminFtp) <> '' THEN
            BEGIN
                IF NOT CopyFile(Pchar(ExtractFilePath(Application.exename) + Fich_release),
                    Pchar(CheminFtp + Fich_release), False) THEN
                BEGIN
                    result := 'NOK';
                    renamefile(ExtractFilePath(Application.exename) + Fich_release,
                        ChangeFileExt(ExtractFilePath(Application.exename) + Fich_release, '.OLD'));
                END;
            END
            ELSE
            BEGIN
                TRY
                    ftp.Host := ftpserveur;
                    ftp.port := strtoint(portserveur);
                    ftp.UserId := UserFtp;
                    ftp.Password := PasswordFtp;
                    ftp.Connect;
                    ftp.UpLoad(ExtractFilePath(Application.exename) + Fich_release, Fich_release);
                    ftp.Disconnect;
                EXCEPT
                    ftp.Disconnect;
                    result := 'NOK';
                    renamefile(ExtractFilePath(Application.exename) + Fich_release,
                        ChangeFileExt(ExtractFilePath(Application.exename) + Fich_release, '.OLD'));
                END;
            END;
            Label1.Caption := ' Fini Envoie version ';
            Label1.Update;
            detruit(PathVersion + '\' + VerArrive + 'UP\');
        END;
    FINALLY
        ReleaseEnCours := False;
    END;
END;

PROCEDURE TFrm_Serveur.ftpPacketSent(Sender: TObject);
BEGIN
    Label2.Caption := IntToStr(Ftp.BytesSent) + ' / ' + IntToStr(Ftp.BytesTotal);
END;

PROCEDURE TFrm_Serveur.ZIPTotalPercentDone(Sender: TObject;
    Percent: Integer);
BEGIN
    Label2.caption := 'Zipping ' + Inttostr(Percent);
END;

PROCEDURE TFrm_Serveur.Button2Click(Sender: TObject);
BEGIN
    Application.CreateForm(TFrm_GestClients, Frm_GestClients);
    Frm_GestClients.PathVersion := PathVersion;
    Frm_GestClients.ftpserveur := ftpserveur;
    Frm_GestClients.portserveur := portserveur;
    Frm_GestClients.CheminFtp := CheminFtp;
    Frm_GestClients.Show;
END;

PROCEDURE TFrm_Serveur.ServeurClientError(Sender: TObject;
    Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
    VAR ErrorCode: Integer);
BEGIN
    errorcode := 0;
END;

PROCEDURE TFrm_Serveur.FTPduserveur1Click(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    application.createform(TDial_Cltnom, Dial_Cltnom);
    TRY
        Dial_Cltnom.Caption := 'FTP DU SERVEUR';
        Dial_Cltnom.edit1.text := ftpserveur;
        IF Dial_Cltnom.ShowModal = MrOk THEN
        BEGIN
            ftpserveur := Dial_Cltnom.edit1.text;
            ini := tinifile.create(ChangeFileExt(application.exename, '.ini'));
            TRY
                ini.Writestring('FTP', 'SERVEUR', ftpserveur);
            FINALLY
                ini.free;
            END;
        END;
    FINALLY
        Dial_Cltnom.release;
    END;
END;

PROCEDURE TFrm_Serveur.Portduftpserveur1Click(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    application.createform(TDial_Cltnom, Dial_Cltnom);
    TRY
        Dial_Cltnom.Caption := 'Port DU SERVEUR';
        Dial_Cltnom.edit1.text := portserveur;
        IF Dial_Cltnom.ShowModal = MrOk THEN
        BEGIN
            portserveur := Dial_Cltnom.edit1.text;
            ini := tinifile.create(ChangeFileExt(application.exename, '.ini'));
            TRY
                ini.Writestring('FTP', 'portserveur', portserveur);
            FINALLY
                ini.free;
            END;
        END;
    FINALLY
        Dial_Cltnom.release;
    END;
END;

PROCEDURE TFrm_Serveur.ftpduclient1Click(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    application.createform(TDial_Cltnom, Dial_Cltnom);
    TRY
        Dial_Cltnom.Caption := 'FTP DU CLIENT';
        Dial_Cltnom.edit1.text := ftpclient;
        IF Dial_Cltnom.ShowModal = MrOk THEN
        BEGIN
            ftpclient := Dial_Cltnom.edit1.text;
            ini := tinifile.create(ChangeFileExt(application.exename, '.ini'));
            TRY
                ini.Writestring('FTP', 'CLIENT', ftpclient);
            FINALLY
                ini.free;
            END;
        END;
    FINALLY
        Dial_Cltnom.release;
    END;
END;

PROCEDURE TFrm_Serveur.Portduftpclient1Click(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    application.createform(TDial_Cltnom, Dial_Cltnom);
    TRY
        Dial_Cltnom.Caption := 'Port DU CLIENT';
        Dial_Cltnom.edit1.text := portclient;
        IF Dial_Cltnom.ShowModal = MrOk THEN
        BEGIN
            portclient := Dial_Cltnom.edit1.text;
            ini := tinifile.create(ChangeFileExt(application.exename, '.ini'));
            TRY
                ini.Writestring('FTP', 'PortClient', portclient);
            FINALLY
                ini.free;
            END;
        END;
    FINALLY
        Dial_Cltnom.release;
    END;
END;

PROCEDURE TFrm_Serveur.Button1Click(Sender: TObject);
BEGIN
    //
    Application.createForm(TFrm_LogClient, Frm_LogClient);
    Frm_LogClient.show;
    Frm_LogClient.Button3Click(NIL);
END;

PROCEDURE TFrm_Serveur.Portenlistening1Click(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    application.createform(TDial_Cltnom, Dial_Cltnom);
    TRY
        Dial_Cltnom.Caption := 'Port en listening';
        Dial_Cltnom.edit1.text := PortListening;
        IF Dial_Cltnom.ShowModal = MrOk THEN
        BEGIN
            PortListening := Dial_Cltnom.edit1.text;
            ini := tinifile.create(ChangeFileExt(application.exename, '.ini'));
            TRY
                ini.Writestring('TPCIP', 'PortListening', PortListening);
            FINALLY
                ini.free;
            END;
        END;
    FINALLY
        Dial_Cltnom.release;
    END;
    Serveur.Active := false;
    Serveur.Port := StrToInt(PortListening);
    Serveur.Active := true;
END;

FUNCTION TFrm_Serveur.VersionExiste(VerDem, VerArrive: STRING): Boolean;
BEGIN
    VerDem := trim(verdem);
    VerArrive := trim(VerArrive);
    IF verdem = '' THEN
        result := fileexists(VerArrive + '.zip')
    ELSE
        result := fileexists(Verdem + '-' + VerArrive + '.zip');
END;

PROCEDURE TFrm_Serveur.Creer_versionTimer(Sender: TObject);
BEGIN
    Creer_version.Enabled := false;
    FabriqueVersion(LaVerDem, LaVerArrive);
END;

PROCEDURE TFrm_Serveur.Button3Click(Sender: TObject);
VAR
    Dial_Versions: TDial_Versions;
    TslActu: TstringList;
    tslClt: TstringList;
    TslVer: TstringList;
    i: Integer;
    j: integer;
    Clt: STRING;
    Ver: STRING;
    S: STRING;
    Vver: STRING;
    LastVer: STRING;
    A1, B1, C1, D1: Integer;
    A, B, C, D: Integer;
    VDem: STRING;
    Varr: STRING;
BEGIN
    //recherche des versions à fabriquer
    TslVer := TstringList.Create;
    TRY
        tslClt := TstringList.Create;
        TslActu := TstringList.Create;
        TRY
            TRY tslClt.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Clients.txt'); EXCEPT END;
            TRY TslActu.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'LiveUpServeur.Log'); EXCEPT END;
            FOR i := 0 TO tslClt.Count - 1 DO
            BEGIN
                S := tslClt[i];
                IF trim(S) <> '' THEN
                BEGIN
                    Clt := Copy(S, 1, Pos(';', S) - 1);
                    delete(S, 1, pos(';', s));
                    Ver := Copy(S, 1, Pos(';', S) - 1);
                    LastVer := '';
                    FOR j := 0 TO TslActu.count - 1 DO
                    BEGIN
                        S := tslActu[j];
                        IF (pos(';MAJ;', S) > 0) OR
                            (pos(';VER;', S) > 0) THEN
                        BEGIN
                            IF copy(S, 1, Length(Clt) + 1) = Clt + ';' THEN
                            BEGIN
                                delete(S, 1, pos(';', S));
                                delete(S, 1, pos(';', S));
                                Delete(S, Pos(';', S), 255);
                                IF LastVer = '' THEN
                                    LastVer := S
                                ELSE
                                BEGIN
                                    Vver := LastVer;
                                    A := StrtoInt(Copy(Vver, 1, Pos('.', Vver) - 1)); delete(vver, 1, pos('.', vver));
                                    B := StrtoInt(Copy(Vver, 1, Pos('.', Vver) - 1)); delete(vver, 1, pos('.', vver));
                                    C := StrtoInt(Copy(Vver, 1, Pos('.', Vver) - 1)); delete(vver, 1, pos('.', vver));
                                    D := StrtoInt(trim(VVer));

                                    Vver := S;
                                    A1 := StrtoInt(Copy(Vver, 1, Pos('.', Vver) - 1)); delete(vver, 1, pos('.', vver));
                                    B1 := StrtoInt(Copy(Vver, 1, Pos('.', Vver) - 1)); delete(vver, 1, pos('.', vver));
                                    C1 := StrtoInt(Copy(Vver, 1, Pos('.', Vver) - 1)); delete(vver, 1, pos('.', vver));
                                    D1 := StrtoInt(trim(VVer));

                                    IF (A1 > A) OR ((A1 >= A) AND (B1 > B)) OR
                                        ((A1 >= A) AND (B1 >= B) AND (C1 > C)) OR
                                        ((A1 >= A) AND (B1 >= B) AND (C1 >= C) AND (D1 > D)) THEN
                                    BEGIN
                                        LastVer := S;
                                    END;
                                END;
                            END;
                        END;
                    END;
                    IF (LastVer <> '') AND (Ver <> LastVer) THEN
                    BEGIN
                        IF TslVer.IndexOf(LastVer + ';' + Ver) < 0 THEN
                            TslVer.Add(LastVer + ';' + Ver);
                    END;
                END;
            END;
            TslActu.Clear;
            TRY TslActu.loadFromFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Version.txt'); EXCEPT END;
            FOR i := 0 TO TslVer.Count - 1 DO
            BEGIN
                S := TslVer[i];
                Vdem := Copy(S, 1, Pos(';', S) - 1);
                VArr := Copy(S, Pos(';', S) + 1, 255);
                FOR j := 0 TO TslActu.Count - 1 DO
                BEGIN
                    S := tslActu[j];
                    Delete(S, 1, pos(';', S));
                    IF vdem = S THEN
                        Vdem := Copy(tslActu[j], 1, Pos(';', tslActu[j]) - 1);
                    IF vArr = S THEN
                        vArr := Copy(tslActu[j], 1, Pos(';', tslActu[j]) - 1);
                END;
                IF VersionExiste(Vdem, Varr) THEN
                    tslver[i] := ''
                ELSE
                    tslver[i] := Vdem + ';' + Varr;
            END;
            i := 0;
            WHILE i < tslver.Count DO
            BEGIN
                IF tslver[i] = '' THEN
                    tslver.delete(i)
                ELSE
                    inc(i);
            END;
        FINALLY
            TslClt.free;
            TslActu.free;
        END;
        IF TslVer.count > 0 THEN
        BEGIN
            i := TslVer.count;
            IF Application.MessageBox(Pchar(Inttostr(i) + ' Versions sont à fabriquer, Le faire ?'), 'Version', MB_YESNO) = IDYES THEN
            BEGIN
                FOR i := 0 TO Tslver.count - 1 DO
                BEGIN
                    S := TslVer[i];
                    Vdem := Copy(S, 1, Pos(';', S) - 1);
                    VArr := Copy(S, Pos(';', S) + 1, 255);
                    IF FabriqueVersion(Vdem, Varr) = 'NOK' THEN
                        Application.MessageBox(Pchar('Problème de fabrication sur la version ' + Vdem + ' ' + Varr), 'Version', MB_OK);
                END;
            END;
        END;
    FINALLY
        TslVer.free;
    END;
    Application.CreateForm(TDial_Versions, Dial_Versions);
    IF Dial_Versions.showModal = Mrok THEN
    BEGIN
        FabriqueVersion(Dial_Versions.Depart.text, Dial_Versions.Arrive.text);
    END;
    Dial_Versions.Release;
END;

DESTRUCTOR TUneConnection.Destroy;
BEGIN
    LesFichiers.clear;
    INHERITED;
END;

PROCEDURE TFrm_Serveur.Cheminduftp1Click(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    application.createform(TDial_Cltnom, Dial_Cltnom);
    TRY
        Dial_Cltnom.Caption := 'CHEMIN DU FTP';
        Dial_Cltnom.edit1.text := CheminFtp;
        IF Dial_Cltnom.ShowModal = MrOk THEN
        BEGIN
            CheminFtp := Dial_Cltnom.edit1.text;
            ini := tinifile.create(ChangeFileExt(application.exename, '.ini'));
            TRY
                ini.WriteString('FTP', 'CHEMIN', CheminFtp);
            FINALLY
                ini.free;
            END;
        END;
    FINALLY
        Dial_Cltnom.release;
    END;
END;

PROCEDURE TFrm_Serveur.UserduFTPserveur1Click(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    application.createform(TDial_Cltnom, Dial_Cltnom);
    TRY
        Dial_Cltnom.Caption := 'USER DU SERVEUR';
        Dial_Cltnom.edit1.text := UserFtp;
        IF Dial_Cltnom.ShowModal = MrOk THEN
        BEGIN
            UserFtp := Dial_Cltnom.edit1.text;
            ini := tinifile.create(ChangeFileExt(application.exename, '.ini'));
            TRY
                ini.Writestring('FTP', 'USER', UserFtp);
            FINALLY
                ini.free;
            END;
        END;
    FINALLY
        Dial_Cltnom.release;
    END;
END;

PROCEDURE TFrm_Serveur.PasswordduftpServeur1Click(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    application.createform(TDial_Cltnom, Dial_Cltnom);
    TRY
        Dial_Cltnom.Caption := 'Password DU SERVEUR';
        Dial_Cltnom.edit1.text := PasswordFtp;
        IF Dial_Cltnom.ShowModal = MrOk THEN
        BEGIN
            PasswordFtp := Dial_Cltnom.edit1.text;
            ini := tinifile.create(ChangeFileExt(application.exename, '.ini'));
            TRY
                ini.Writestring('FTP', 'PASSWORD', PasswordFtp);
            FINALLY
                ini.free;
            END;
        END;
    FINALLY
        Dial_Cltnom.release;
    END;
END;

PROCEDURE TFrm_Serveur.FormCloseQuery(Sender: TObject;
    VAR CanClose: Boolean);
BEGIN
    CanClose := Application.MessageBox(' Vous êtes sur de vouloir fermer ', ' Question ', MB_YESNO OR MB_DEFBUTTON2) = ID_YES;
END;

END.

