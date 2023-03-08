UNIT connexion_dm;

INTERFACE

USES
    RASAPI,
    registry,
    inifiles,
    CstLaunch,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Db, IBCustomDataSet, IBQuery, IBDatabase;

TYPE
    TDm_Connexion = CLASS(TDataModule)
        Base: TIBDatabase;
        Tran: TIBTransaction;
        IB_LaBase: TIBQuery;
        IB_LaBaseBAS_ID: TIntegerField;
        IB_LaBaseBAS_NOM: TIBStringField;
        Ib_Horraire: TIBQuery;
        Ib_HorraireLAU_ID: TIntegerField;
        Ib_HorraireLAU_BASID: TIntegerField;
        Ib_HorraireLAU_HEURE1: TDateTimeField;
        Ib_HorraireLAU_H1: TIntegerField;
        Ib_HorraireLAU_HEURE2: TDateTimeField;
        Ib_HorraireLAU_H2: TIntegerField;
        Ib_HorraireLAU_AUTORUN: TIntegerField;
        Ib_HorraireLAU_BACK: TIntegerField;
        Ib_HorraireLAU_BACKTIME: TDateTimeField;
        IB_Connexion: TIBQuery;
        IB_ConnexionCON_ID: TIntegerField;
        IB_ConnexionCON_LAUID: TIntegerField;
        IB_ConnexionCON_NOM: TIBStringField;
        IB_ConnexionCON_TEL: TIBStringField;
        IB_ConnexionCON_TYPE: TIntegerField;
        IB_ConnexionCON_ORDRE: TIntegerField;
        Ib_Replication: TIBQuery;
        Ib_ReplicationREP_ID: TIntegerField;
        Ib_ReplicationREP_LAUID: TIntegerField;
        Ib_ReplicationREP_PING: TIBStringField;
        Ib_ReplicationREP_PUSH: TIBStringField;
        Ib_ReplicationREP_PULL: TIBStringField;
        Ib_ReplicationREP_USER: TIBStringField;
        Ib_ReplicationREP_PWD: TIBStringField;
        Ib_ReplicationREP_ORDRE: TIntegerField;
        Ib_ReplicationREP_URLLOCAL: TIBStringField;
        Ib_ReplicationREP_URLDISTANT: TIBStringField;
        Ib_ReplicationREP_PLACEEAI: TIBStringField;
        Ib_ReplicationREP_PLACEBASE: TIBStringField;
        PROCEDURE DataModuleCreate(Sender: TObject);
        PROCEDURE DataModuleDestroy(Sender: TObject);
    PRIVATE
    { Déclarations privées }
        FUNCTION ConnexionModem(Nom, Tel: STRING): Boolean;
    PUBLIC
    { Déclarations publiques }
        LesEai: TstringList;
        ListeConnexion: Tlist;
        Connectionencours: TLesConnexion;
        FUNCTION connexion: boolean;
        PROCEDURE deconnexion;
        PROCEDURE deconnexionModem;
    END;

VAR
    Dm_Connexion: TDm_Connexion;

IMPLEMENTATION

{$R *.DFM}

FUNCTION TDm_Connexion.connexion: boolean;
VAR
    i: integer;
BEGIN
    i := 0;
    Connectionencours := NIL;
    result := false;
    WHILE i < ListeConnexion.Count DO
    BEGIN
        Connectionencours := TLesConnexion(ListeConnexion[i]);
        IF Connectionencours.LeType = 1 THEN // Routeur : Juste un Ping
        BEGIN
            IF UnPing('http://replic3.algol.fr/EssaiBin/DelosQPMAgent.dll/ping') THEN
            BEGIN
                result := true;
                BREAK;
            END;
        END
        ELSE
        BEGIN // Connexion sur modem
            IF ConnexionModem(Connectionencours.Nom, Connectionencours.TEL) THEN
            BEGIN
                result := true;
                BREAK;
            END
        END;
        Inc(i);
    END;
    IF NOT result THEN
        Connectionencours := NIL;
END;

FUNCTION TDm_Connexion.ConnexionModem(Nom, Tel: STRING): Boolean;
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

        err := rasdial(NIL, NIL, @tp, $FFFFFFFF, Application.MainForm.Handle, RasConn);
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

PROCEDURE TDm_Connexion.DataModuleCreate(Sender: TObject);
VAR
    reg: TRegistry;
    S: STRING;
    IdBase: Integer;
    LAUID: Integer;
    i: Integer;
    connex: TLesConnexion;
    ini: Tinifile;
    s1: STRING;
BEGIN
    LesEai := TstringList.Create;
    ListeConnexion := Tlist.Create;

    reg := TRegistry.Create(KEY_READ);
    TRY
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
        S := reg.ReadString('Base0');
    FINALLY
        reg.free;
    END;
    IF s = '' THEN
    BEGIN
        S := IncludeTrailingBackslash(ExtractFilePath(Application.exename));
        IF NOT fileexists(S + 'Ginkoia.ini') THEN
            S := 'C:\Ginkoia\';
        IF NOT fileexists(S + 'Ginkoia.ini') THEN
            S := 'D:\Ginkoia\';

        LesEai.Add(S + 'EAI');
        ini := TiniFile.Create(S + 'Ginkoia.ini');
        S := trim(ini.readString('CONNEXION', 'Nom', ''));
        s1 := trim(ini.readString('CONNEXION', 'TEL', ''));
        IF (s = '') OR (s1 = '') THEN
        BEGIN
            connex := TLesConnexion.Create;
            connex.Id := 1;
            connex.Nom := S;
            connex.TEL := '';
            connex.LeType := 1;
            ListeConnexion.Add(connex);
            S := trim(ini.readString('CONNEXION', 'Nom_2', ''));
            s1 := trim(ini.readString('CONNEXION', 'TEL_2', ''));
            IF (s <> '') AND (S1 <> '') THEN
            BEGIN
                connex := TLesConnexion.Create;
                connex.Id := 2;
                connex.Nom := S;
                connex.TEL := S1;
                connex.LeType := 0;
                ListeConnexion.Add(connex);
            END;
        END
        ELSE
        BEGIN
                // Connexion par Modem
            connex := TLesConnexion.Create;
            connex.Id := 1;
            connex.Nom := S;
            connex.TEL := S1;
            connex.LeType := 0;
            ListeConnexion.Add(connex);
            S := trim(ini.readString('CONNEXION', 'Nom_2', ''));
            s1 := trim(ini.readString('CONNEXION', 'TEL_2', ''));
            IF (S <> '') AND (S1 <> '') THEN
            BEGIN
                connex := TLesConnexion.Create;
                connex.Id := 2;
                connex.Nom := S;
                connex.TEL := S1;
                connex.LeType := 0;
                ListeConnexion.Add(connex);
            END
            ELSE
            BEGIN
                connex.Id := 2;
                connex.Nom := S;
                connex.TEL := S1;
                connex.LeType := 1;
                ListeConnexion.Add(connex);
            END;
        END;
    END
    ELSE
    BEGIN
        Base.DataBaseName := S;
        Base.Open;
        TRY
            Ib_LaBase.Open;
            IdBase := IB_LaBaseBAS_ID.Asinteger;
            Ib_LaBase.Close;
            Ib_Horraire.ParamByName('BasId').AsInteger := IdBase;
            Ib_Horraire.Open;
            LAUID := Ib_HorraireLAU_ID.AsInteger;
            Ib_Horraire.Close;

            FOR i := 0 TO ListeConnexion.Count - 1 DO
                TLesConnexion(ListeConnexion[i]).free;
            ListeConnexion.clear;
            // Lecture des connexions
            IB_Connexion.ParamByName('Lauid').AsInteger := LauId;
            IB_Connexion.Open;
            IB_Connexion.First;
            WHILE NOT IB_Connexion.Eof DO
            BEGIN
                connex := TLesConnexion.Create;
                connex.Id := IB_ConnexionCON_ID.AsInteger;
                connex.Nom := IB_ConnexionCON_NOM.AsString;
                connex.TEL := IB_ConnexionCON_TEL.AsString;
                connex.LeType := IB_ConnexionCON_TYPE.AsInteger;
                ListeConnexion.Add(connex);
                IB_Connexion.Next;
            END;
            IB_Connexion.Close;

            Ib_Replication.ParamByName('Lauid').AsInteger := LauId;
            Ib_Replication.Open;
            Ib_Replication.First;
            WHILE NOT Ib_Replication.Eof DO
            BEGIN
                LesEai.Add(Ib_ReplicationREP_PLACEEAI.AsString);
                Ib_Replication.Next;
            END;
            Ib_Replication.Close;
        FINALLY
            base.close;
        END;
    END;
END;

PROCEDURE TDm_Connexion.DataModuleDestroy(Sender: TObject);
VAR
    i: integer;
BEGIN
    LesEai.free;
    FOR i := 0 TO ListeConnexion.Count - 1 DO
        TLesConnexion(ListeConnexion[i]).free;
END;

PROCEDURE TDm_Connexion.deconnexion;
BEGIN
    IF (Connectionencours <> NIL) AND
        (Connectionencours.LeType = 0) THEN
        DeconnexionModem;
    Connectionencours := NIL;
END;

PROCEDURE TDm_Connexion.deconnexionModem;
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

END.

