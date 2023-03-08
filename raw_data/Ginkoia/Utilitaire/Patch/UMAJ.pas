//$Log:
// 3    Utilitaires1.2         25/01/2006 14:59:02    pascal         
//      corrections divers sur les probl?mes relev?s
// 2    Utilitaires1.1         30/05/2005 08:57:04    pascal          Divers
//      modification de "Look" suite aux demandes de Herv?.A
// 1    Utilitaires1.0         27/04/2005 10:41:28    pascal          
//$
//$NoKeywords$
//
UNIT UMAJ;

INTERFACE

USES
    WinSvc,
    registry, Windows, SysUtils,
    Forms, 
    VCLZip, VCLUnZip, Classes;

TYPE
    TFrm_MAJGinko = CLASS(TForm)
        UnZip: TVCLUnZip;
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormShow(Sender: TObject);
    PRIVATE
    { Déclarations privées }
        // Labase: STRING;
        Ginkoia: STRING;
//        VersionEnCours: STRING;

//        AncVersion: STRING;
//        AncNumero: STRING;
//        NvlVersion: STRING;
//        NvlNumero: STRING;
    procedure Attente_IB;
    PUBLIC
    { Déclarations publiques }
        first: Boolean;
    END;

VAR
    Frm_MAJGinko: TFrm_MAJGinko;

IMPLEMENTATION
{$R *.DFM}

CONST
    CSTTaille: STRING = 'TAILLE EXE';
    TailleEXE: STRING = '0000000000';
    CSTTaille2: STRING = 'TAILLE EXE';

FUNCTION traiteversion(S: STRING): STRING;
VAR
    S1: STRING;
BEGIN
    result := '';
    WHILE pos('.', S) > 0 DO
    BEGIN
        S1 := Copy(S, 1, pos('.', S));
        delete(S, 1, pos('.', S));
        WHILE (Length(S1) > 2) AND (S1[1] = '0') DO delete(S1, 1, 1);
        result := result + S1;
    END;
    S1 := S;
    WHILE (Length(S1) > 1) AND (S1[1] = '0') DO delete(S1, 1, 1);
    result := result + S1;
END;

FUNCTION ReadString(TS: TStream): STRING;
VAR
    B: Byte;
BEGIN
    ts.read(b, sizeof(b));
    SetLength(Result, B);
    TS.Read(Pointer(Result)^, B);
END;

PROCEDURE TFrm_MAJGinko.FormCreate(Sender: TObject);
BEGIN
    First := true;
END;

PROCEDURE TFrm_MAJGinko.Attente_IB;
VAR
    hSCManager: SC_HANDLE;
    hService: SC_HANDLE;
    Statut: TServiceStatus;
    tempMini: DWORD;
    CheckPoint: DWORD;
    NbBcl: Integer;
BEGIN
    hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
    hService := OpenService(hSCManager, 'InterBaseGuardian', SERVICE_QUERY_STATUS);
    IF hService <> 0 THEN
    BEGIN // Service non installé
        QueryServiceStatus(hService, Statut);
        CheckPoint := 0;
        NbBcl := 0;
        WHILE (statut.dwCurrentState <> SERVICE_RUNNING) AND
            (CheckPoint <> Statut.dwCheckPoint) DO
        BEGIN
            CheckPoint := Statut.dwCheckPoint;
            tempMini := Statut.dwWaitHint + 1000;
            Sleep(tempMini);
            QueryServiceStatus(hService, Statut);
            Inc(nbBcl);
            IF NbBcl > 300 THEN BREAK;
        END;
        IF NbBcl < 300 THEN
        BEGIN
            CloseServiceHandle(hService);
            hService := OpenService(hSCManager, 'InterBaseServer', SERVICE_QUERY_STATUS);
            IF hService <> 0 THEN
            BEGIN // Service non installé
                QueryServiceStatus(hService, Statut);
                CheckPoint := 0;
                NbBcl := 0;
                WHILE (statut.dwCurrentState <> SERVICE_RUNNING) AND
                    (CheckPoint <> Statut.dwCheckPoint) DO
                BEGIN
                    CheckPoint := Statut.dwCheckPoint;
                    tempMini := Statut.dwWaitHint + 1000;
                    Sleep(tempMini);
                    QueryServiceStatus(hService, Statut);
                    Inc(nbBcl);
                    IF NbBcl > 300 THEN BREAK;
                END;
            END;
        END;
    END;
    CloseServiceHandle(hService);
    CloseServiceHandle(hSCManager);
END;

PROCEDURE TFrm_MAJGinko.FormShow(Sender: TObject);
VAR
    reg: tregistry;
    s: STRING;
    FSize: Integer;
    Taille: Integer;
    Handle: Integer;
    p: PChar;
    hToken, hProcess: THandle;
    tp, prev_tp: TTokenPrivileges;
    Len: DWORD;
    i:integer ;
BEGIN
    IF first THEN
    BEGIN
        // initialisation
        first := false;

        reg := TRegistry.Create;
        Attente_IB ;
        TRY
            reg.access := Key_Read;
            Reg.RootKey := HKEY_LOCAL_MACHINE;
            s := '';
            reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
            S := reg.ReadString('Base0');
        FINALLY
            reg.free;
        END;
        IF (S = '') OR NOT (fileexists(s)) THEN
        BEGIN
            Application.messageBox('L''application Ginkoia est mal installée', 'Impossible de continuer', Mb_OK);
            Close;
            EXIT;
        END;

        IF (PARAMCount > 0) AND (Uppercase(ParamStr(1)) = 'REBOOT') THEN
        BEGIN
            reg := tregistry.Create(KEY_ALL_ACCESS);
            reg.RootKey := HKEY_LOCAL_MACHINE;
            reg.OpenKey('SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon', False);
            S := reg.readString('AutoAdminLogon');
            reg.free;
            IF S = '1' THEN
            BEGIN
                reg := tregistry.Create(KEY_ALL_ACCESS);
                reg.RootKey := HKEY_LOCAL_MACHINE;
                reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce', true);
                reg.WriteString('Install', Application.exename );
                reg.free;

                hProcess := OpenProcess(PROCESS_ALL_ACCESS, True, GetCurrentProcessID);
                IF OpenProcessToken(hProcess, TOKEN_ADJUST_PRIVILEGES OR TOKEN_QUERY, hToken) THEN
                BEGIN
                    CloseHandle(hProcess);
                    IF LookupPrivilegeValue('', 'SeShutdownPrivilege', tp.Privileges[0].Luid) THEN
                    BEGIN
                        tp.PrivilegeCount := 1;
                        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
                        IF AdjustTokenPrivileges(hToken, False, tp, SizeOf(prev_tp), prev_tp, Len) THEN
                        BEGIN
                            CloseHandle(hToken);

                            ExitWindowsEx(EWX_FORCE OR EWX_REBOOT, 0);
                            Application.MessageBox('Redémarrage du serveur en cours...', 'Attention', Mb_Ok);
                            HALT;
                        END;
                    END;
                END;
            END;
        END;

        // Labase := S;
        S := ExcludetrailingBackSlash(ExtractFilePath(S));
        WHILE s[length(S)] <> '\' DO
            delete(S, length(S), 1);
        Ginkoia := S;

        // on dézip le patch (plus tard)
        S := TailleEXE;
        IF S <> '0000000000' THEN
        BEGIN
            Deletefile(Ginkoia + 'LiveUpdate\ALGOL.ALG');
            Deletefile(Ginkoia + 'LiveUpdate\Patch.GIN');
            Deletefile(Ginkoia + 'LiveUpdate\Patch.ZIP');
            Deletefile(Ginkoia + 'LiveUpdate\Patch.EXE');
            Taille := StrToInt(trim(s));
            Handle := FileOpen(Application.exename, fmOpenRead + fmShareDenyNone);
            FSize := FileSeek(Handle, 0, 2);
            FileSeek(Handle, Taille, 0);
            GetMem(p, FSize - Taille + 10);
            FileRead(Handle, P[0], FSize - Taille);
            FileClose(Handle);
            Handle := FileCreate(Ginkoia + 'LiveUpdate\Patch.ZIP');
            FileWrite(Handle, P[0], FSize - Taille);
            FileClose(Handle);
            FreeMem(p, FSize - Taille + 10);
            UnZip.ZipName := Ginkoia + 'LiveUpdate\Patch.ZIP';
            UnZip.DestDir := Ginkoia + 'LiveUpdate\';
            Unzip.DoAll := true;
            UnZip.UnZip;
        END;

        IF NOT fileexists(Ginkoia + 'LiveUpdate\Patch.GIN') THEN
        BEGIN
            Application.messageBox('Problème de patch, le fichier est incorecte', 'Impossible de continuer', Mb_OK);
            Deletefile(Ginkoia + 'LiveUpdate\Patch.GIN');
            Deletefile(Ginkoia + 'LiveUpdate\Patch.ZIP');
            Deletefile(Ginkoia + 'LiveUpdate\Patch.EXE');
            Close;
            EXIT;
        END;
        // Recup de la version
        {
        data.dataBaseName := LaBase;
        Que_Version.Open;
        VersionEnCours := Que_VersionVER_VERSION.AsString;
        Que_Version.Close;

        tsl := tstringlist.Create;
        IBQue_EAI.Open;
        IBQue_EAI.first;
        WHILE NOT IBQue_EAI.eof DO
        BEGIN
            tsl.Add(IBQue_EAIREP_PLACEEAI.AsString);
            IBQue_EAI.next;
        END;
        IBQue_EAI.close;
        tsl.savetofile(Ginkoia + 'LiveUpdate\LESEAI.TXT');
        tsl.free;
        data.Close;
        {
        VersionEnCours := traiteversion(VersionEnCours);

        // Vérification que le patch conviens a la version
        Patch := TFileStream.Create(Ginkoia + 'LiveUpdate\Patch.GIN', fmOpenRead);
        AncVersion := ReadString(Patch);
        AncNumero := ReadString(Patch);
        NvlVersion := ReadString(Patch);
        NvlNumero := ReadString(Patch);
        Patch.free;
        }
        IF (paramCount > 0) AND (Uppercase(paramstr(1)) = 'RETOUR') THEN
        BEGIN
            IF NOT (fileexists(Ginkoia + 'LiveUpdate\Patch.EXE')) THEN
            BEGIN
                Application.messageBox('Le patch à un problème, veuillez contacter la société GINKOIA', 'Impossible de continuer', Mb_OK);
                Deletefile(Ginkoia + 'LiveUpdate\Patch.GIN');
                Deletefile(Ginkoia + 'LiveUpdate\Patch.ZIP');
                Deletefile(Ginkoia + 'LiveUpdate\Patch.EXE');
                Close;
                EXIT;
            END;
        END
        ELSE
        BEGIN
            {
            IF VersionEnCours <> AncNumero THEN
            BEGIN
                Application.messageBox(PChar('Le patch que vous voulez passer ne correspond pas à votre version de Ginkoia'#10#13 +
                    'Ce patch concerne la version ' + AncVersion), 'Impossible de continuer', Mb_OK);
                Deletefile(Ginkoia + 'LiveUpdate\Patch.GIN');
                Deletefile(Ginkoia + 'LiveUpdate\Patch.ZIP');
                Deletefile(Ginkoia + 'LiveUpdate\Patch.EXE');
                Close;
                EXIT;
            END;
            }
            IF NOT (fileexists(Ginkoia + 'LiveUpdate\Patch.EXE')) THEN
            BEGIN
                Application.messageBox('Le patch à un problème, veuillez contacter la société GINKOIA', 'Impossible de continuer', Mb_OK);
                Deletefile(Ginkoia + 'LiveUpdate\Patch.GIN');
                Deletefile(Ginkoia + 'LiveUpdate\Patch.ZIP');
                Deletefile(Ginkoia + 'LiveUpdate\Patch.EXE');
                Close;
                EXIT;
            END;
        END;
        S := '' ;
        for i := 1 to paramcount do
           S := S+' '+paramstr(i) ;
        Winexec(Pchar(Ginkoia + 'LiveUpdate\Patch.EXE'+S), 0);
        Close;
    END;
END;

END.

