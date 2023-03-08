//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :                                           
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Launch_Frm;

INTERFACE

USES
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    registry,
    SimpHTTP, // Pour Push - Pull  Cogisoft
    inifiles,
    Forms,
    Dialogs,
    AlgolStdFrm,
    LMDIniCtrl,
    LMDInputDlg,
    ImgList,
    dxBar,
    LMDContainerComponent,
    LMDBaseDialog,
    LMDAboutDlg,
    Db,
    dxmdaset,
    LMDFileGrep,
    LMDOneInstance,
    ExtCtrls,
    Menus,
    RxMenus,
    LMDCustomComponent,
    LMDWndProcComponent,
    LMDTrayIcon,
    StdCtrls,
    RzPanel,
    RzPanelRv,
    RzLabel,
    RzBorder,
    IBDatabase,
    IBCustomDataSet,
    IBQuery,
    IBSQL, IBStoredProc;

TYPE
    TFrm_Launch = CLASS(TAlgolStdFrm)
        Tray_Launch: TLMDTrayIcon;
        PopM_Launch: TRxPopupMenu;
        Pop_Exit: TMenuItem;
        Pop_Launch: TMenuItem;
        N1: TMenuItem;
        Tim_Launch: TTimer;
        Bev_Param: TRzBorder;
        OnlyInst_OOne_Launch: TLMDOneInstance;
        FileGrep_EAI: TLMDFileGrep;
        Pop_Journal: TMenuItem;
        Pan_Memo: TRzPanelRv;
        RzLabel2: TRzLabel;
        MemD_Rapport: TdxMemData;
        MemD_RapportidDate: TDateTimeField;
        MemD_Rapportdate: TDateField;
        MemD_RapportHeure: TTimeField;
        MemD_RapportType: TStringField;
        MemD_RapportModule: TStringField;
        Memo1: TMemo;
        MemD_Conso: TdxMemData;
        DateTimeField1: TDateTimeField;
        MemD_ConsoDate: TDateField;
        TimeField1: TTimeField;
        StringField1: TStringField;
        MemD_ConsoMois: TStringField;
        MemD_ConsoTemps: TTimeField;
        Lab_Version: TRzLabel;
        AboutDlg_Main: TLMDAboutDlg;
        Bm_Launch: TdxBarManager;
        dxB_Forcer: TdxBarButton;
        dxB_Journal: TdxBarButton;
        dxB_Info: TdxBarSubItem;
        dxB_Conso: TdxBarButton;
        dxB_PP: TdxBarSubItem;
        dxB_Push: TdxBarButton;
        dxB_Pull: TdxBarButton;
        dxB_Param: TdxBarSubItem;
        dxB_Horaire: TdxBarButton;
        dxB_lance: TdxBarButton;
        dxB_Reduire: TdxBarButton;
        Lab_Horaire: TRzLabel;
        ImageList1: TImageList;
        Lab_LanceAuto: TRzLabel;
        LogDlg_Pwd: TLMDInputDlg;
        IniCtrl: TLMDIniCtrl;
        Tim_Launch2: TTimer;
        Tran: TIBTransaction;
        Data: TIBDatabase;
    Tim_BackupRestor: TTimer;
    Correct_BN_TRIGGERDIFFERE: TIBSQL;
    IBQue_ParamBase: TIBQuery;
    IBQue_ParamBasePAR_NOM: TIBStringField;
    IBQue_ParamBasePAR_STRING: TIBStringField;
    IBQue_ParamBasePAR_FLOAT: TFloatField;
    IBStProc_TriggerDiffere: TIBStoredProc;
    IBSql_Trigger: TIBSQL;
    dxB_Recalc: TdxBarButton;
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
        PROCEDURE AlgolStdFrmShow(Sender: TObject);
        PROCEDURE Pop_LaunchClick(Sender: TObject);
        PROCEDURE Pop_ExitClick(Sender: TObject);
        PROCEDURE Tim_LaunchTimer(Sender: TObject);
        PROCEDURE Pop_JournalClick(Sender: TObject);
        PROCEDURE AlgolStdFrmClose(Sender: TObject; VAR Action: TCloseAction);
        PROCEDURE dxB_ForcerClick(Sender: TObject);
        PROCEDURE dxB_JournalClick(Sender: TObject);
        PROCEDURE dxB_PushClick(Sender: TObject);
        PROCEDURE dxB_PullClick(Sender: TObject);
        PROCEDURE dxB_ConsoClick(Sender: TObject);
        PROCEDURE dxB_ReduireClick(Sender: TObject);
        PROCEDURE dxB_lanceClick(Sender: TObject);
        PROCEDURE dxB_HoraireClick(Sender: TObject);
        PROCEDURE Tray_LaunchDblClick(Sender: TObject);
    procedure dxB_RecalcClick(Sender: TObject);
    procedure Tim_BackupRestorTimer(Sender: TObject);
    PRIVATE
    { Private declarations }
        heure, heure2, HConnexion: TTime;
        VHeure1, VHeure2: Boolean;
        temps: TTime;
        Path, PathBase: STRING;
        CasConnexion: Integer;

        HeureBackup: TTime;
        EtatBackup: Integer; // -1 pas de backup,
        //  1 après la 1° réplication
        //  2 après la 2° réplication
        //  3 à 23 heure HeureBackup
        //  4 à 22 heure HeureBackup
        //  5 à la 1er Heures(non automatique) si rien à 23h HeureBackup

        PROCEDURE Memo(LeType, LeModule: STRING);
        PROCEDURE MemoConso;
        PROCEDURE EpurerRapport;

        FUNCTION Connexion(ConnexionN, ConnexionT: STRING; LeCasConnexion: Integer): Boolean;
        FUNCTION ConnexionModem(ConnexionN, ConnexionT: STRING): Boolean;
        FUNCTION DeConnexion(LeCasConnexion: Integer): Boolean;
        FUNCTION SeConnecter: boolean;
        PROCEDURE CouperConnexion(Cas: Integer);

        FUNCTION Ping(cas: Integer): STRING;
        PROCEDURE VidePort;
        PROCEDURE ReglageHeure(LIni: TiniFile);
        PROCEDURE ReglageHeureBackup;

        PROCEDURE LeDelay(nb: Integer);

        PROCEDURE DesactiveTrigger;
        PROCEDURE ReactiveTrigger;
        PROCEDURE LanceCalculeTrigger;

        PROCEDURE ChangeTrigger;

    PROTECTED
    { Protected declarations }
        FHTTPAgent: TSimpleHTTP;
        FHTTPPing: TSimpleHTTP;
        FUNCTION HTTPPost(CONST URL, UserName, Password: STRING; Provider: STRING): STRING;
        
    // Pour Push - Pull  Cogisoft
    PUBLIC
    { Public declarations }
        CONSTRUCTOR Create(AOwner: TComponent); OVERRIDE; // Pour Push - Pull  Cogisoft
        FUNCTION Push(ExeEAI, LePushURL, LePushUSER, LePushPASS: STRING; LePushPROV: TStrings): integer;
        FUNCTION Pull(ExeEAI, LePullURL, LePullUSER, LePullPASS: STRING; LePullPROV: TStrings): integer;
        FUNCTION Replication(ExeEAI, LePushURL, LePushUSER, LePushPASS, LePullURL, LePullUSER, LePullPASS: STRING; LePushPROV, LePullPROV: TStrings; cas: Integer): Integer;
        FUNCTION ReplicationPush(ExeEAI, LePushURL, LePushUSER, LePushPASS: STRING; LePushPROV: TStrings; cas: Integer): Integer;
        FUNCTION ReplicationPull(ExeEAI, LePullURL, LePullUSER, LePullPASS: STRING; LePullPROV: TStrings; cas: Integer): Integer;
    PUBLISHED
    { Published declarations }
    END;

VAR
    Frm_Launch: TFrm_Launch;
    ExeEAI1, PathEAI1, ExeEAI2, PathEAI2, PushURL, PushUSER, PushPASS, PullURL, PullUSER, PullPASS: STRING;
    PushURL2, PushUSER2, PushPASS2, PullURL2, PullUSER2, PullPASS2: STRING;
    ExePing, PathPing, URLPing, URLPing2, URLPingLocal, URLPingLocal2: STRING;
    ConnexionNom, ConnexionTel, ConnexionNom_2, ConnexionTel_2: STRING;
    PushPROV, PullPROV, PushPROV2, PullPROV2: TStrings;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
RESOURCESTRING
    ErrEAI = 'Une erreur à eu lieu lors de la réplication de vos données !';
    ErrPush = 'Erreur lors de ENVOI du module : ';
    ErrPull = 'Erreur lors de la RECEPTION du module : ';
    Donnee = ' - Données "';
    DonneeEnvFin = '" envoyées !';
    DonneeRecFin = '" reçues !';
    Fin1 = 'Envoi terminé avec succés';
    Fin = 'Récéption terminé avec succés';
    ErrFin1 = 'Echec lors de l' + #39 + 'envoi de vos données';
    ErrFin = 'Echec lors de la récéption de vos données';
    TitreLaunch = 'Lancement automatique de votre réplication !';
    ConnexOk = 'Connexion Internet établie !';
    ConnexFin = 'Connexion Internet terminée !';

IMPLEMENTATION

USES StdUtils,
    VCLUtils,
    Rapport_Frm,
    RASAPI,
    Conso_Frm,
    Horaire_Frm,
    UMapping;
{$R *.DFM}
//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

//******************* TFrm_Launch.Create *************************

CONSTRUCTOR TFrm_Launch.Create(AOwner: TComponent);
BEGIN
    INHERITED;
    FHTTPAgent := TSimpleHTTP.Create(Self);
    FHTTPPing := TSimpleHTTP.Create(Self);
END;

//******************* TFrm_Launch.HTTPPost *************************

FUNCTION TFrm_Launch.HTTPPost(CONST URL, UserName, Password: STRING; Provider: STRING): STRING;
VAR
    ResultBody: TStringStream;
BEGIN
    ResultBody := TStringStream.Create('');
    TRY
        TRY
            FHTTPAgent.UserName := UserName;
            FHTTPAgent.Password := Password;
            FHTTPAgent.PostData.Clear;
      // requires at least one parameter

            FHTTPAgent.PostData.Values['Caller'] := Application.ExeName;
            FHTTPAgent.PostData.Values['Provider'] := Provider;
            FHTTPAgent.Post(URL, ResultBody);
            Result := ResultBody.DataString;
        EXCEPT
            Result := 'Error';
//        ON E: Exception DO
//        RAISE Exception.CreateFmt ( 'HTTPPost - Cannot invoke http action (URL=%s)', [URL] ) ;
        END;

{
    try
      Result := TXMLCursor.Create;
      if ResultBody.DataString = '' then
        Exit;
      Result.LoadXML(ResultBody.DataString);
    except on E: Exception do
      raise Exception.CreateFmt('HTTPPost - Cannot load result from http action (URL=%s)'#13#10'%s', [URL, ResultBody.DataString]);
    end;
}
    FINALLY
        ResultBody.Free;
    END;
END;

//******************* TFrm_Launch.Ping *************************

FUNCTION TFrm_Launch.Ping(cas: Integer): STRING;
VAR ResultBody: TStringStream;
BEGIN
    ResultBody := TStringStream.Create('');
    Result := '';
    TRY
        TRY
            FHTTPPing.PostData.Clear;
            FHTTPPing.PostData.Values['Caller'] := Application.ExeName;
            FHTTPPing.PostData.Values['Provider'] := '';
            CASE cas OF
                1: FHTTPPing.Post(URLPing, ResultBody);
                2: FHTTPPing.Post(URLPing2, ResultBody);
                3: FHTTPPing.Post(URLPingLocal, ResultBody);
                4: FHTTPPing.Post(URLPingLocal2, ResultBody);
            END;
        EXCEPT
//        ON E: Exception DO
//        // Sur une erreur on ne veut pas voir le message
//        // car l'appli se bloque en connection le nuit...
//
//            RAISE Exception.CreateFmt ( 'HTTPPost - Cannot invoke http action (URL=%s)', [URLPing] ) ;
        END;
    FINALLY
        Result := ResultBody.DataString;
        ResultBody.Free;
    END;
END;

//******************* TFrm_Launch.Memo *************************

PROCEDURE TFrm_Launch.Memo(LeType, LeModule: STRING);
BEGIN
    IF NOT MemD_Rapport.Active THEN
    BEGIN
        TRY
            MemD_Rapport.LoadFromTextFile(PathEAI1 + 'Rapport.txt');
            MemD_Rapport.Open;
        EXCEPT
            MemD_Rapport.Open;
        END;
    END;
    MemD_Rapport.Insert;
    MemD_Rapport.FieldByName('IdDate').AsDateTime := Now;
    MemD_Rapport.FieldByName('Date').AsDateTime := Date;
    MemD_Rapport.FieldByName('Heure').AsDateTime := Time;
    MemD_Rapport.FieldByName('Type').AsString := LeType;
    MemD_Rapport.FieldByName('Module').AsString := LeModule;
    MemD_Rapport.Post;
END;

//******************* TFrm_Launch.MemoConso *************************

PROCEDURE TFrm_Launch.MemoConso;
BEGIN
    MemD_Conso.Close;
    TRY
        MemD_Conso.LoadFromTextFile(PathEAI1 + 'Conso.txt');
        MemD_Conso.Open;
    EXCEPT
        MemD_Conso.Open;
    END;

    MemD_Conso.Insert;
    MemD_Conso.FieldByName('IdDate').AsDateTime := now;
    MemD_Conso.FieldByName('Date').AsDateTime := Date;
    MemD_Conso.FieldByName('Heure').AsDateTime := Time;
    MemD_Conso.FieldByName('Mois').AsString := FormatDateTime('mmmm', Date);
    CASE MemD_Conso.Tag OF
//      0: MemD_Conso.FieldByName('Type').AsString := 'Replication';
        1: MemD_Conso.FieldByName('Type').AsString := 'Envoi';
        2: MemD_Conso.FieldByName('Type').AsString := 'Reception';
        3: MemD_Conso.FieldByName('Type').AsString := 'Connexion';
        4: MemD_Conso.FieldByName('Type').AsString := 'Deconnexion';
//      5: MemD_Conso.FieldByName('Type').AsString := 'Ping';
    END;
    MemD_Conso.FieldByName('Temps').AsDateTime := now - temps;
    MemD_Conso.Post;
    temps := 0;

     // Sauve le Rapport
    MemD_Conso.Filtered := True;
    MemD_Conso.SaveToTextFile(PathEAI1 + 'Conso.txt');
END;
//******************* TFrm_Launch.EpurerRapport *************************

PROCEDURE TFrm_Launch.EpurerRapport;
VAR i: Integer;
BEGIN
    IF (PathEAI1 <> '') THEN
    BEGIN
     // le fichier des rapports
        IF NOT MemD_Rapport.Active THEN
        BEGIN
            TRY
                MemD_Rapport.LoadFromTextFile(PathEAI1 + 'Rapport.txt');
                MemD_Rapport.Open;
            EXCEPT
                MemD_Rapport.Open;
            END;
        END;

        MemD_Rapport.First;
        WHILE NOT MemD_Rapport.Eof DO
        BEGIN
          // conserver l'historique des 15 derniers jours
            IF MemD_Rapportdate.Value < (Date - 15) THEN
                MemD_Rapport.Delete
            ELSE MemD_Rapport.Next;
        END;
        MemD_Rapport.SaveToTextFile(PathEAI1 + 'Rapport.txt');

     // le fichier des conso
        IF NOT MemD_Conso.Active THEN
        BEGIN
            TRY
                MemD_Conso.LoadFromTextFile(PathEAI1 + 'Conso.txt');
                MemD_Conso.Open;
            EXCEPT
                MemD_Conso.Open;
            END;
        END;

        MemD_Conso.First;
        WHILE NOT MemD_Conso.Eof DO
        BEGIN
          // conserver l'historique des 31 derniers jours
            IF MemD_ConsoDate.Value < (Date - 31) THEN
                MemD_Conso.Delete
            ELSE MemD_Conso.Next;
        END;
        MemD_Conso.SaveToTextFile(PathEAI1 + 'Conso.txt');
    END;
END;

//******************* TFrm_Launch.Push *************************
// le result => 1 : Départ de la réplication Push
//              2 : Succès pour le Push
//              -2 : erreur dans un paquet de Push
//              -3 : erreur général dans le Push

FUNCTION TFrm_Launch.Push(ExeEAI, LePushURL, LePushUSER, LePushPASS: STRING; LePushPROV: TStrings): integer;
VAR str: STRING;
    nb, i: Integer;
BEGIN
    MapGinkoia.Launcher := True;
    Result := 1;
    TRY
        str := ' ';
   //Push
        nb := LePushPROV.Count;
        IF (nb <> 0) THEN
        BEGIN
            VidePort;

            FOR i := 0 TO nb - 1 DO
            BEGIN
                str := '';
                str := HTTPPost(LePushURL, LePushUSER, LePushPASS, LePushPROV.Strings[i]); //Remplacer les params de la fonction par les valeurs du fichier INI
                IF (PosNext(UpperCase(str), 'ERROR', 1) <> 0) THEN
                BEGIN
                    Memo1.Lines.Add(ErrPush + LePushPROV.Strings[i]);
                    Memo('Envoi', ErrPush + LePushPROV.Strings[i]);
                    Result := -2;
                    MapGinkoia.Launcher := False;
                    exit;
                END
                ELSE
                BEGIN
                    Memo1.Lines.Add(IntToStr(i + 1) + Donnee + copy(LePushPROV.Strings[i], 0, PosNext(LePushPROV.Strings[i], '[', 0) - 1) + DonneeEnvFin);
                    LeDelay(500);
                    Memo('Envoi', copy(LePushPROV.Strings[i], 0, PosNext(LePushPROV.Strings[i], '[', 0) - 1));
                END;
            END;
            Result := 2;
        END;
        MapGinkoia.Launcher := False;
    EXCEPT
        Result := -3;
        Memo('Envoi', ErrEAI);
        MapGinkoia.Launcher := False;
    END;
END;

//******************* TFrm_Launch.Pull *************************
// le result => 1 : Départ de la réplication Pull
//              4 : Succès pour le Pull
//              -4 : erreur dans un paquet de Pull
//              -3 : erreur général dans le Pull

FUNCTION TFrm_Launch.Pull(ExeEAI, LePullURL, LePullUSER, LePullPASS: STRING; LePullPROV: TStrings): integer;
VAR str: STRING;
    nb, i: Integer;
BEGIN
    MapGinkoia.Launcher := True;
    Result := 1;
    TRY
        str := ' ';
   //Pull
        nb := LePullPROV.Count;
        IF (nb <> 0) THEN
        BEGIN
            VidePort;

// Désactive trigger
            DesactiveTrigger;
            FOR i := 0 TO nb - 1 DO
            BEGIN
                str := '';
                str := HTTPPost(LePullURL, LePullUSER, LePullPASS, LePullPROV.Strings[i]); //Remplacer les params de la fonction par les valeurs du fichier INI
                IF (PosNext(UpperCase(str), 'ERROR', 1) <> 0) THEN
                BEGIN
                    Memo1.Lines.Add(ErrPull + LePullPROV.Strings[i]);
                    Memo('Reception', ErrPull + LePullPROV.Strings[i]);
                    Result := -4;
                    MapGinkoia.Launcher := False;
                    exit;
                END
                ELSE
                BEGIN
                    Memo1.Lines.Add(IntToStr(i + 1) + Donnee + copy(LePullPROV.Strings[i], 0, PosNext(LePullPROV.Strings[i], '[', 0) - 1) + DonneeRecFin);
                    LeDelay(500);
                    Memo('Reception', copy(PullPROV.Strings[i], 0, PosNext(LePullPROV.Strings[i], '[', 0) - 1));
                END;
            END;
            Result := 4;
        END;
        MapGinkoia.Launcher := False;
// Ré-active trigger
        ReactiveTrigger;
    EXCEPT
// Ré-active trigger
        ReactiveTrigger;
        Result := -3;
        Memo('Reception', ErrEAI);
        MapGinkoia.Launcher := False;
    END;
END;

//******************* TFrm_Launch.Connexion *************************

FUNCTION TFrm_Launch.Connexion(ConnexionN, ConnexionT: STRING; LeCasConnexion: Integer): Boolean;
VAR
    ii: Integer;
    nb: DWORD;
    ok: Boolean;
    str: STRING;
BEGIN
    Result := False;
    temps := now;
    MemD_Conso.Tag := 3;

    IF (ConnexionN <> '') AND (ConnexionT <> '') THEN
    BEGIN // cas d'un modem
        CasConnexion := LeCasConnexion;
        IF ConnexionModem(ConnexionN, ConnexionT) THEN
        BEGIN
            MemoConso;
            LeDelay(10000); // attendre 10 secondes pour voir si la connexion est bonne
            Memo1.Lines.Add(DateToStr(Now) + ' Succès pour la connexion ' + ConnexionNOM);
         // Ping pour tester si Pantin reponds
            nb := gettickcount + 300000;
            REPEAT
                str := '';
                LeDelay(5000);
                str := Ping(1);
                Result := (str = 'PONG');
            UNTIL Result OR (gettickcount > nb); // max 5 min
            IF NOT Result THEN
                Memo1.Lines.Add(DateToStr(Now) + ' Echec pour le ping ' + URLPing + ' sur la ' + ConnexionNOM);
        END
        ELSE Memo1.Lines.Add(DateToStr(Now) + ' Echec pour la connexion ' + ConnexionNOM);

        Ok := false;
        IF NOT Result THEN
            REPEAT
                Ok := DeConnexion(CasConnexion);
            UNTIL Ok;
    END
    ELSE // cas Routeur
    BEGIN
        CasConnexion := 0;
        Memo1.Lines.Add(DateToStr(Now) + ' Demande de connexion par le Ping');
        IF (Winexec(Pchar(ExePing), 0) > 31) THEN
        BEGIN
            nb := 0;
            REPEAT
                LeDelay(10000); // attendre 10 secondes pour voir si la connexion est bonne
                Inc(nb);
            UNTIL NOT ((NOT MapGinkoia.Ping) AND (nb < 60)); // l'essai dura 10 min max
            Result := MapGinkoia.Ping;
            IF NOT result THEN
            BEGIN
                Memo1.Lines.Add(DateToStr(Now) + ' Echec pour le ping');
                MapGinkoia.PingStop := True;
            END
            ELSE
            BEGIN
                Memo1.Lines.Add(DateToStr(Now) + ' Succès pour le ping');
                MemoConso;
            END;
        END;
    END;
    IF Result THEN temps := now;
END;

//******************* TFrm_Launch.ConnexionModem *************************

FUNCTION TFrm_Launch.ConnexionModem(ConnexionN, ConnexionT: STRING): Boolean;
VAR
    RasConn: HRasConn;
    TP: TRasDialParams;
    Pass: Bool;
    err: DWORD;
    Last: DWord;
    RasConStatus: TRasConnStatus;
    Ok: Boolean;
    nb: DWORD;
BEGIN
    Ok := False;
    fillchar(tp, Sizeof(tp), #00);
    tp.Size := Sizeof(Tp);
    StrPCopy(tp.pEntryName, ConnexionNOM);
    err := RasGetEntryDialParams(NIL, TP, Pass);
    IF err = 0 THEN
    BEGIN
        StrPCopy(tp.pPhoneNumber, ConnexionTEL);
        RasConn := 0;
        err := rasdial(NIL, NIL, @tp, $FFFFFFFF, Handle, RasConn);

        IF err <> 0 THEN Memo1.Lines.Add(DateToStr(Now) + ' Erreur de connexion')
        ELSE Memo1.Lines.Add(DateToStr(Now) + ' Tentative de connexion ' + ConnexionNOM);

        Application.ProcessMessages;
        Last := $FFFFFFFF;
        Ok := false;
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

//******************* TFrm_Launch.DeConnexion *************************
//  0 : pas de param de connexion valide
//  1 : Connexion avec les 1er param de connexion
//  2 : Connexion avec les 2eme param de connexion

FUNCTION TFrm_Launch.DeConnexion(LeCasConnexion: Integer): Boolean; // ne coupe que les connexions qu'il a lancé
VAR
    RasCom: ARRAY[1..100] OF TRasConn;
    i, Connections: DWord;

    Last: DWord;
    RasConStatus: TRasConnStatus;
    OK: Boolean;
    nb: Integer;
BEGIN
    ok := False;
    IF temps = 0 THEN temps := now;
    CASE LeCasConnexion OF
        0: BEGIN
                MapGinkoia.PingStop := True;
                ok := true;
           END;
        1: IF NOT ((ConnexionNOM <> '') AND (ConnexionTEL <> '')) THEN // cas d'un routeur
            BEGIN
                MapGinkoia.PingStop := True;
                ok := true;
            END;
        2: IF NOT ((ConnexionNOM_2 <> '') AND (ConnexionTEL_2 <> '')) THEN // cas d'un routeur
            BEGIN
                MapGinkoia.PingStop := True;
                ok := true;
            END;
    END;

    IF NOT Ok THEN
    BEGIN
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
                RASCS_Connected: ok := ok AND False;
                RASCS_Disconnected: ok := ok AND True;
            END;
        END;

    END;
    Result := Ok;
    
 // Sauvegarde du temps de connexion
    IF ok AND (temps <> 0) THEN
    BEGIN
        MemD_Conso.Tag := 4;
        MemoConso;
    END;

END;

//******************* TFrm_Launch.Replication *************************

FUNCTION TFrm_Launch.Replication(ExeEAI, LePushURL, LePushUSER, LePushPASS, LePullURL, LePullUSER, LePullPASS: STRING; LePushPROV, LePullPROV: TStrings; cas: Integer): Integer;
VAR str, LURLPing: STRING;
    ok: Boolean;
BEGIN
    result := 0;
     // Inhiber les boutons
    dxB_Forcer.Enabled := False;
    dxB_Info.Enabled := False;
    dxB_Param.Enabled := False;
    dxB_PP.Enabled := False;

     // Charger le rapport
    MemD_Rapport.Close;
    TRY
        MemD_Rapport.LoadFromTextFile(PathEAI1 + 'Rapport.txt');
        MemD_Rapport.Open;
    EXCEPT
        MemD_Rapport.Open;
    END;
    EpurerRapport;

    IF cas = 1 THEN
        Memo1.Lines.Clear;

    LURLPing := '';
    CASE cas OF
        1: LURLPing := URLPing;
        2: LURLPing := URLPing2;
    END;
    IF (LURLPing <> '') THEN
    BEGIN
         // Lancer EAI si c'est pas en ligne
        IF NOT (Winexec(Pchar(ExeEAI), 0) > 31) THEN
            RAISE Exception.create('');
        sleep(5000);

         // Ping pour tester si Edelos reponds
        str := '';
        str := Ping(cas + 2); //http://localhost:668/ServeurBase1Bin/DelosQPMAgent.dll/ping
        IF NOT (str = 'PONG') THEN
        BEGIN
            Memo('Envoi', 'Erreur : Pas de Delos_QPMAgent');
            Memo1.Lines.Add(ErrFin1);
        END
        ELSE // L'agent Local est en ligne
        BEGIN
            temps := now;
            MemD_Conso.Tag := 1;
            result := Push(ExeEAI, LePushURL, LePushUSER, LePushPASS, LePushPROV); // lance le Push
            Memo1.Lines.Clear;
            MemoConso;
            IF result = 2 THEN
            BEGIN
                Memo1.Lines.Add(DateToStr(Now) + ' ' + Fin1);
                temps := now;
                MemD_Conso.Tag := 2;
                result := Pull(ExeEAI, LePullURL, LePullUSER, LePullPASS, LePullPROV); // lance le Pull
                Memo1.Lines.Clear;
                Memo1.Lines.Add(DateToStr(Now) + ' ' + Fin1);
                MemoConso;
                IF result <> 4 THEN
                    Memo1.Lines.Add(DateToStr(Now) + ' ' + ErrFin)
                ELSE
                    Memo1.Lines.Add(DateToStr(Now) + ' ' + Fin);
            END
            ELSE Memo1.Lines.Add(DateToStr(Now) + ' ' + ErrFin1);
        END;

          // tue l'application DelosQPMAgent
        KillApp_Classe('TfmDelosHTTPServer');
        MapGinkoia.Launcher := False;
        LeDelay(5000);
    END
    ELSE // Pas de Ping sur Pantin
    BEGIN
        Memo1.Lines.Add(DateToStr(Now) + ' Erreur : le Ping est vide');
        Memo('Envoi', 'Erreur : le Ping est vide');
    END;

     // Sauve le Rapport
    MemD_Rapport.Filtered := True;
    MemD_Rapport.SaveToTextFile(PathEAI1 + 'Rapport.txt');

     // Re active les boutons
    dxB_Forcer.Enabled := True;
    dxB_Info.Enabled := True;
    dxB_Param.Enabled := True;
    dxB_PP.Enabled := True;
END;

FUNCTION TFrm_Launch.ReplicationPush(ExeEAI, LePushURL, LePushUSER, LePushPASS: STRING; LePushPROV: TStrings; cas: Integer): Integer;
VAR str, LURLPing: STRING;
    ok: Boolean;
BEGIN
    Result := 0;
     // Inhiber les boutons
    dxB_Forcer.Enabled := False;
    dxB_Info.Enabled := False;
    dxB_Param.Enabled := False;
    dxB_PP.Enabled := False;

     // Charger le rapport
    MemD_Rapport.Close;
    TRY
        MemD_Rapport.LoadFromTextFile(PathEAI1 + 'Rapport.txt');
        MemD_Rapport.Open;
    EXCEPT
        MemD_Rapport.Open;
    END;
    EpurerRapport;

    Memo1.Lines.Clear;

    LURLPing := '';
    CASE cas OF
        1: LURLPing := URLPing;
        2: LURLPing := URLPing2;
    END;
    IF (LURLPing <> '') THEN
    BEGIN
         // Lancer EAI si c'est pas en ligne
        IF NOT (Winexec(Pchar(ExeEAI), 0) > 31) THEN
            RAISE Exception.create('');
        sleep(5000);

         // Ping pour tester si Edelos reponds
        str := '';
        str := Ping(cas + 2); //http://localhost:668/ServeurBase1Bin/DelosQPMAgent.dll/ping
        IF NOT (str = 'PONG') THEN
        BEGIN
            Memo('Envoi', 'Erreur : Pas de Delos_QPMAgent');
            Memo1.Lines.Add(ErrFin1);
        END
        ELSE
        BEGIN
            temps := now;
            MemD_Conso.Tag := 1;
            result := Push(ExeEAI, LePushURL, LePushUSER, LePushPASS, LePushPROV); // lance le Push
            Memo1.Lines.Clear;
            MemoConso;
            IF result <> 2 THEN
                Memo1.Lines.Add(DateToStr(Now) + ' ' + ErrFin1)
            ELSE
                Memo1.Lines.Add(DateToStr(Now) + ' ' + Fin1);
        END;

         // tue l'application DelosQPMAgent
        KillApp_Classe('TfmDelosHTTPServer');
        MapGinkoia.Launcher := False;
        LeDelay(5000);
    END
    ELSE
    BEGIN
        Memo1.Lines.Add(DateToStr(Now) + ' Erreur : le Ping est vide');
        Memo1.Lines.Add(ErrFin1);
        Memo('Envoi', 'Erreur : le Ping est vide');
    END;

     // Sauve le Rapport
    MemD_Rapport.Filtered := True;
    MemD_Rapport.SaveToTextFile(PathEAI1 + 'Rapport.txt');

     // Re active les boutons
    dxB_Forcer.Enabled := True;
    dxB_Info.Enabled := True;
    dxB_Param.Enabled := True;
    dxB_PP.Enabled := True;
END;

FUNCTION TFrm_Launch.ReplicationPull(ExeEAI, LePullURL, LePullUSER, LePullPASS: STRING; LePullPROV: TStrings; cas: Integer): Integer;
VAR str, LURLPing: STRING;
    ok: Boolean;
BEGIN
    Result := 0;
     // Inhiber les boutons
    dxB_Forcer.Enabled := False;
    dxB_Info.Enabled := False;
    dxB_Param.Enabled := False;
    dxB_PP.Enabled := False;

     // Charger le rapport
    MemD_Rapport.Close;
    TRY
        MemD_Rapport.LoadFromTextFile(PathEAI1 + 'Rapport.txt');
        MemD_Rapport.Open;
    EXCEPT
        MemD_Rapport.Open;
    END;
    EpurerRapport;

    Memo1.Lines.Clear;

    LURLPing := '';
    CASE cas OF
        1: LURLPing := URLPing;
        2: LURLPing := URLPing2;
    END;
    IF (LURLPing <> '') THEN
    BEGIN
         // Lancer EAI si c'est pas en ligne
        IF NOT (Winexec(Pchar(ExeEAI), 0) > 31) THEN
            RAISE Exception.create('');
        sleep(5000);

         // Ping pour tester si Edelos reponds
        str := '';
        str := Ping(cas + 2); //http://localhost:668/ServeurBase1Bin/DelosQPMAgent.dll/ping
        IF NOT (str = 'PONG') THEN
        BEGIN
            Memo('reception', 'Erreur : Pas de Delos_QPMAgent');
            Memo1.Lines.Add(ErrFin);
        END
        ELSE
        BEGIN
            temps := now;
            MemD_Conso.Tag := 2;
            result := Pull(ExeEAI, LePullURL, LePullUSER, LePullPASS, LePullPROV); // lance le Pull
            Memo1.Lines.Clear;
            MemoConso;
            IF result <> 4 THEN
                Memo1.Lines.Add(DateToStr(Now) + ' ' + ErrFin)
            ELSE
                Memo1.Lines.Add(DateToStr(Now) + ' ' + Fin);
        END;

         // tue l'application DelosQPMAgent
        KillApp_Classe('TfmDelosHTTPServer');
        MapGinkoia.Launcher := False;
        LeDelay(5000);
    END
    ELSE
    BEGIN
        Memo1.Lines.Add(DateToStr(Now) + ' Erreur : le Ping est vide');
        Memo1.Lines.Add(ErrFin);
        Memo('Envoi', 'Erreur : le Ping est vide');
    END;

     // Sauve le Rapport
    MemD_Rapport.Filtered := True;
    MemD_Rapport.SaveToTextFile(PathEAI1 + 'Rapport.txt');

     // Re active les boutons
    dxB_Forcer.Enabled := True;
    dxB_Info.Enabled := True;
    dxB_Param.Enabled := True;
    dxB_PP.Enabled := True;
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TFrm_Launch.AlgolStdFrmCreate(Sender: TObject);
VAR t: TTime;
    LaTs: TStrings;
    Trouve, ok: Boolean;
    i, nb, nb_rep, cpt: Integer;
    ch, s: STRING;
    Ini: TiniFile;
    reg: TRegistry;
BEGIN
    // Timer réglé à 300 000 -> 5 mn
    Tray_Launch.active := True;
    Tray_Launch.NoClose := True;
    EtatBackup := -1;

    TRY
        reg := TRegistry.Create;
        reg.access := Key_Read;
        Reg.RootKey := HKEY_CURRENT_USER;
        s := '';
        IF Reg.OpenKey('\Software\Agol\Ginkoia\Current Version', False) THEN
            s := Reg.readString('Path');
        reg.free;
        S := ExtractfilePath(S);
        IF S[Length(S)] <> '\' THEN S := S + '\';
        Path := S;
        S := S + 'Ginkoia.Ini';
        ini := tinifile.create(S);
        cpt := 0;
        ok := False;
        WHILE (cpt <= 9) and not ok do
        BEGIN
             PathBase := ini.readString('DATABASE', 'PATH'+IntToStr(cpt), '');
             ok := (copy(PathBase,2,1) = ':');
             inc(cpt);
        END;
    EXCEPT
        MessageDlg('La clé dans la base de registre n' + #39 + 'existe pas !' + #13 + #10 + 'PREVENIR ALGOL de nombreuses applications ne fonctionneront pas !', mtError, [mbOK], 0);
        application.Terminate;
    END;

    Ini := tinifile.create(changefileext(application.exename, '.ini'));
    IF Ini.readBool('REPLIK', 'Run', False) THEN
    BEGIN
        dxB_lance.ImageIndex := 0;
        Lab_LanceAuto.visible := True;
    END;

    Lab_Version.Caption := Lab_Version.Caption + AboutDlg_Main.Version;

    ReglageHeure(Ini);
    Ini.Free;

    // Paramétrage de l'horaire du BackupRestor
    // temps du backup
    ReglageHeureBackup;

    // Paramétrage du PING
    PathPing := ExtractFilePath(application.ExeName);
    ExePing := PathPing + 'Ping.exe';

    // Paramétrage de la Réplication
    FileGrep_EAI.FileMasks := 'Delos_QPMAgent.exe';
    FileGrep_EAI.Dirs := ExtractFilePath(application.ExeName);
    FileGrep_EAI.Grep;
    ExeEAI1 := '';
    PathEAI1 := '';
    ExeEAI2 := '';
    PathEAI2 := '';
    nb := FileGrep_EAI.Found.Count - 1;
    nb_rep := 0;
    i := -1;

    IF (nb >= 0) THEN
        REPEAT
            Inc(i);
            LaTs := TStringList.Create;
            StrToTS(FileGrep_EAI.Found[i], ';', LaTS);
            IF Pos('\BCKUP', LaTS[0]) = 0 THEN
            BEGIN
                IF (nb_rep = 0) THEN
                BEGIN
                    ExeEAI1 := LaTS[0] + LaTS[1];
                    PathEAI1 := LaTS[0];
                    inc(nb_rep);
                END
                ELSE IF (nb_rep = 1) THEN
                BEGIN
                    ExeEAI2 := LaTS[0] + LaTS[1];
                    PathEAI2 := LaTS[0];
                    inc(nb_rep);
                END;
            END;
            LaTs.Free;
        UNTIL NOT ((i < nb) AND (nb_rep < 2));

    IF ExeEAI1 <> '' THEN
    BEGIN
        IniCtrl.IniFile := ExtractFilePath(application.ExeName) + 'Ginkoia.ini';
        ConnexionNom := iniCtrl.readString('CONNEXION', 'NOM', '');
        ConnexionTel := iniCtrl.readString('CONNEXION', 'TEL', '');

        ConnexionNom_2 := iniCtrl.readString('CONNEXION', 'NOM_2', '');
        ConnexionTel_2 := iniCtrl.readString('CONNEXION', 'TEL_2', '');

        URLPing := iniCtrl.readString('PING', 'URL', '');
        URLPingLocal := iniCtrl.readString('PUSH', 'URL', '');
        URLPingLocal := StringReplace(URLPingLocal, 'Push', 'Ping', [rfIgnoreCase]);
        PushURL := iniCtrl.readString('PUSH', 'URL', '');
        PushUSER := iniCtrl.readString('PUSH', 'USERNAME', '');
        PushPASS := iniCtrl.readString('PUSH', 'PASSWORD', '');
        PushPROV := TStringList.Create;
        Trouve := True;
        i := 0;
        WHILE Trouve DO
        BEGIN
            ch := iniCtrl.readString('PUSH', 'PROVIDER' + IntToStr(i), '');
            Inc(i);
            IF (ch <> '') THEN
            BEGIN
                PushPROV.Add(ch);
            END
            ELSE Trouve := False;
        END;

        PullURL := iniCtrl.readString('PULL', 'URL', '');
        PullUSER := iniCtrl.readString('PULL', 'USERNAME', '');
        PullPASS := iniCtrl.readString('PULL', 'PASSWORD', '');
        PullPROV := TStringList.Create;
        Trouve := True;
        i := 0;
        WHILE Trouve DO
        BEGIN
            ch := iniCtrl.readString('PULL', 'PROVIDER' + IntToStr(i), '');
            Inc(i);
            IF (ch <> '') THEN
            BEGIN
                PullPROV.Add(ch);
            END
            ELSE Trouve := False;
        END;
    END;

    IF ExeEAI2 <> '' THEN
    BEGIN
        URLPing2 := iniCtrl.readString('PING2', 'URL', '');
        IF URLPing2 = '' then
        begin
             ExeEAI2 := '';
        end
        else
        begin
            IniCtrl.IniFile := ExtractFilePath(application.ExeName) + 'Ginkoia.ini';
            IF (ConnexionNom = '') THEN
            BEGIN
                ConnexionNom := iniCtrl.readString('CONNEXION', 'NOM', '');
                ConnexionTel := iniCtrl.readString('CONNEXION', 'TEL', '');
            END;
            IF (ConnexionNom_2 = '') THEN
            BEGIN
                ConnexionNom_2 := iniCtrl.readString('CONNEXION', 'NOM_2', '');
                ConnexionTel_2 := iniCtrl.readString('CONNEXION', 'TEL_2', '');
            END;

            URLPingLocal2 := iniCtrl.readString('PUSH2', 'URL', '');
            URLPingLocal2 := StringReplace(URLPingLocal2, 'Push', 'Ping', [rfIgnoreCase]);
            PushURL2 := iniCtrl.readString('PUSH2', 'URL', '');
            PushUSER2 := iniCtrl.readString('PUSH2', 'USERNAME', '');
            PushPASS2 := iniCtrl.readString('PUSH2', 'PASSWORD', '');
            PushPROV2 := TStringList.Create;
            Trouve := True;
            i := 0;
            WHILE Trouve DO
            BEGIN
                ch := iniCtrl.readString('PUSH2', 'PROVIDER' + IntToStr(i), '');
                Inc(i);
                IF (ch <> '') THEN
                BEGIN
                    PushPROV2.Add(ch);
                END
                ELSE Trouve := False;
            END;

            PullURL2 := iniCtrl.readString('PULL2', 'URL', '');
            PullUSER2 := iniCtrl.readString('PULL2', 'USERNAME', '');
            PullPASS2 := iniCtrl.readString('PULL2', 'PASSWORD', '');
            PullPROV2 := TStringList.Create;
            Trouve := True;
            i := 0;
            WHILE Trouve DO
            BEGIN
                ch := iniCtrl.readString('PULL2', 'PROVIDER' + IntToStr(i), '');
                Inc(i);
                IF (ch <> '') THEN
                BEGIN
                    PullPROV2.Add(ch);
                END
                ELSE Trouve := False;
            END;
        END;
    END;
END;

PROCEDURE TFrm_Launch.ReglageHeure(LIni: TIniFile);
VAR T: TTime;
BEGIN
    // Horaire de réplication
    // si le programme est lancé aprés heure ne doit pas l'exécuter ce jour
    // mais le lendemain
    t := Time;
    Lab_Horaire.Caption := 'Horaire de réplication activé : ';
    VHeure1 := LIni.ReadBool('REPLIK', 'ValideH', False);
    Heure := LIni.ReadTime('REPLIK', 'Heure', 0);
    VHeure2 := LIni.ReadBool('REPLIK', 'ValideH2', False);
    Heure2 := LIni.ReadTime('REPLIK', 'Heure2', 0);
    IF VHeure1 THEN
    BEGIN
        Lab_Horaire.Caption := Lab_Horaire.Caption + FormatDateTime('hh:nn', Heure);
        IF t < Heure THEN
            Tim_Launch.Interval := Round((Heure - t) * 86400000)
        ELSE
            Tim_Launch.Interval := Round(((StrToTime('23:59:59') - t) + Heure) * 86400000);
        Tim_Launch.Enabled := True;
    END
    ELSE
        Tim_Launch.Enabled := False;

    IF VHeure2 THEN
    BEGIN
        IF VHeure1 THEN
            Lab_Horaire.Caption := Lab_Horaire.Caption + ' et ';
        Lab_Horaire.Caption := Lab_Horaire.Caption + FormatDateTime('hh:nn', Heure2);
        IF t < Heure2 THEN
            Tim_Launch2.Interval := Round((Heure2 - t) * 86400000)
        ELSE
            Tim_Launch2.Interval := Round(((StrToTime('23:59:59') - t) + Heure2) * 86400000);
        Tim_Launch2.Enabled := True;
    END
    ELSE
        Tim_Launch2.Enabled := False;

    EpurerRapport;
END;

PROCEDURE TFrm_Launch.ReglageHeureBackup;
var s: STRING;
    Ini: TiniFile;
    reg: TRegistry;
    i: integer;
    h: integer;
    k: integer;
    j: integer;
    Hh, Mm, Ss, Dd: Word;

BEGIN
    reg := TRegistry.Create;
    TRY
        reg.RootKey := HKEY_CURRENT_USER;
        reg.OpenKey('Software\agol\Ginkoia\Current Version', False);
        S := reg.ReadString('Path');
    FINALLY
        reg.free;
    END;
    S := extractFilePath(S);
    IF s[Length(s)] <> '\' THEN
        S := S + '\';
    S := S + 'BackRest.ini';
    ini := Tinifile.create(S);
    TRY
        i := Ini.readinteger('TPS', 'TPS', 0);
    FINALLY
        ini.free;
    END;
    IF i = 0 THEN
        i := 60 * 4
    ELSE
    BEGIN
        i := trunc((i*1.25) / 1000) DIV 60;
        IF i < 60 THEN
            i := 60;                // i : durée du Backup
    END;
    IF NOT (VHeure1) AND NOT (VHeure2) THEN
    BEGIN
        IF HEURE <> 0 then
           HeureBackup :=HEURE
        ELSE IF HEURE2 <> 0 then
                HeureBackup :=HEURE2
             ELSE HeureBackup := EncodeTime(23, 0, 0, 0);
        EtatBackup := 5; // à la 1er Heures si rien à 23h
    END
    ELSE IF VHeure1 AND NOT (VHeure2) THEN
    BEGIN
        decodeTime(HEURE, Hh, Mm, Ss, Dd);
        h := hh - 22;
        IF h < 0 THEN h := h + 24;
        j := h * 60 + mm;
        IF j + i < 9 * 60 THEN
            etatBackup := 1
        ELSE
        begin
            HeureBackup := EncodeTime(23, 0, 0, 0);
            etatBackup := 3;
        END;
    END
    ELSE
    BEGIN // VHeure2 et VHeure1
        decodeTime(HEURE2, Hh, Mm, Ss, Dd);
        h := hh - 22;
        IF h < 0 THEN h := h + 24;
        j := h * 60 + mm;
        IF J + i < 9 * 60 THEN
            etatBackup := 2
        ELSE
        BEGIN
            decodeTime(HEURE, Hh, Mm, Ss, Dd);
            h := hh - 22;
            IF h < 0 THEN h := h + 24;
            IF h > 9 THEN
            begin
                 HeureBackup := EncodeTime(23, 0, 0, 0);
                 etatBackup := 3;
            END
            ELSE
            BEGIN
             k := h * 60 + mm;
             IF k + i < j THEN
                etatBackup := 1
             ELSE IF k - i > 0 THEN
                  begin
                          HeureBackup := EncodeTime(22, 0, 0, 0);
                          etatBackup := 4;
                  END;
            END;
        END;
    END;
    Tim_BackupRestor.Tag := 0;
    Tim_BackupRestor.Interval := 1000;
    Tim_BackupRestor.Enabled := True;
END;

PROCEDURE TFrm_Launch.LeDelay(nb: Integer);
VAR ii: DWORD;
BEGIN
    ii := gettickcount + nb;
    WHILE ii > gettickcount DO
    BEGIN
        application.ProcessMessages;
    END;
END;

PROCEDURE TFrm_Launch.AlgolStdFrmShow(Sender: TObject);
BEGIN
    Tray_Launch.active := True;
END;

PROCEDURE TFrm_Launch.Pop_LaunchClick(Sender: TObject);
BEGIN
    Show;
END;

PROCEDURE TFrm_Launch.Pop_ExitClick(Sender: TObject);
BEGIN
    Close;
END;

PROCEDURE TFrm_Launch.Tim_LaunchTimer(Sender: TObject);
VAR T: TTime;
    i, ecart, liveUp, res: Integer;
    path: STRING;
BEGIN
    T := Time;
    ecart := Round(abs((Heure - T)) * 86400000); // ecart avec l'heure fatidique en ms
    IF VHeure1 AND (ecart < 300000) THEN
    BEGIN
        Tim_Launch.Interval := 86400000; // soit 24h
        Show;
        ChangeTrigger;
       // Connexion
        IF SeConnecter THEN
        BEGIN
            TRY
                res := 0;
                liveUp := 0;
               // Replication
                IF (ExeEAI1 <> '') AND (PathEAI1 <> '') THEN
                    res := Replication(ExeEAI1, PushURL, PushUSER, PushPASS, PullURL, PullUSER, PullPASS, PushPROV, PullPROV, 1);
                LeDelay(5000);
                IF (ExeEAI2 <> '') AND (PathEAI2 <> '') THEN
                  // envissager le test du resultat pour ttes les réplications !
                    Replication(ExeEAI2, PushURL2, PushUSER2, PushPASS2, PullURL2, PullUSER2, PullPASS2, PushPROV2, PullPROV2, 2);
            FINALLY
               // Couper la Connexion
                CouperConnexion(0);
                LeDelay(2000);
// Lance le recacule des triggers
                LanceCalculeTrigger;
            END;

            path := ExtractFilePath(application.ExeName);
            IF Copy(path, length(path), 1) <> '\' THEN
               path := path + '\';

            IF EtatBackup = 1 THEN // Lancer le Backup Restor après la 1er replication
            begin
                 winexec(PChar(path + 'BackRest.exe auto'), 0);
                 Memo1.Lines.Add(DateToStr(Now) + ' Lancement du BackupRestor');
            END;

            // s'il n'y a pas de deuxième horaire LiveUpDate
            IF not VHeure2 THEN
            BEGIN
                IF res >= 2 THEN
                BEGIN
                    liveUp := winexec(PChar(path + 'LiveUpClient.exe auto'), 0);
                    Memo1.Lines.Add(DateToStr(Now) + ' Lancement du LiveUpDate');
                END;
            END;
        END;
    END;

    ecart := Round(abs((Heure2 - T)) * 86400000); // ecrat avec l'heure fatidique en ms
    IF VHeure2 AND (ecart < 300000) THEN
    BEGIN
        Tim_Launch2.Interval := 86400000; // soit 24h
        Show;
       // Connexion
        IF SeConnecter THEN
        BEGIN
            res := 0;
            TRY
               // Replication
                IF (ExeEAI1 <> '') AND (PathEAI1 <> '') THEN
                    res := Replication(ExeEAI1, PushURL, PushUSER, PushPASS, PullURL, PullUSER, PullPASS, PushPROV, PullPROV, 1);
                LeDelay(5000);
                IF (ExeEAI2 <> '') AND (PathEAI2 <> '') THEN
                  // envissager le test du resultat pour ttes les réplications !
                    Replication(ExeEAI2, PushURL2, PushUSER2, PushPASS2, PullURL2, PullUSER2, PullPASS2, PushPROV2, PullPROV2, 2);
            FINALLY
               // Couper la Connexion
                CouperConnexion(0);
                LeDelay(2000);
// Lance le recacule des triggers
                LanceCalculeTrigger;
            END;

            path := ExtractFilePath(application.ExeName);
            IF Copy(path, length(path), 1) <> '\' THEN
               path := path + '\';

            IF EtatBackup = 2 THEN // Lancer le Backup Restor après la 1er replication
            begin
                 winexec(PChar(path + 'BackRest.exe auto'), 0);
                 Memo1.Lines.Add(DateToStr(Now) + ' Lancement du BackupRestor');
            END;

            IF res >= 2 THEN
            BEGIN
                liveUp := winexec(PChar(path + 'LiveUpClient.exe auto'), 0);
                Memo1.Lines.Add(DateToStr(Now) + ' Lancement du LiveUpDate');
            END;
        END;
    END;
END;

PROCEDURE TFrm_Launch.Pop_JournalClick(Sender: TObject);
BEGIN
    dxB_Journal.Click;
END;

PROCEDURE TFrm_Launch.AlgolStdFrmClose(Sender: TObject;
    VAR Action: TCloseAction);
BEGIN
    IF Tray_Launch.NoClose THEN
        Hide
    ELSE
    BEGIN
        Close;
    END;
    temps := 0;
    IF (ExeEAI1 <> '') AND (PathEAI1 <> '') THEN
        DeConnexion(CasConnexion);
    IF (ExeEAI2 <> '') AND (PathEAI2 <> '') THEN
        DeConnexion(CasConnexion);
     // tue l'application DelosQPMAgent
    KillApp_Classe('TfmDelosHTTPServer');

    MapGinkoia.Launcher := False;

    Data.Close;
    tran.Active := False;
END;

PROCEDURE TFrm_Launch.dxB_ForcerClick(Sender: TObject);
var res: Integer;
BEGIN
    ChangeTrigger;
   // Connexion
    IF SeConnecter THEN
    BEGIN
        TRY
           // Replication
            IF (ExeEAI1 <> '') AND (PathEAI1 <> '') THEN
                res := Replication(ExeEAI1, PushURL, PushUSER, PushPASS, PullURL, PullUSER, PullPASS, PushPROV, PullPROV, 1);
            LeDelay(5000);
            IF (ExeEAI2 <> '') AND (PathEAI2 <> '') THEN
                Replication(ExeEAI2, PushURL2, PushUSER2, PushPASS2, PullURL2, PullUSER2, PullPASS2, PushPROV2, PullPROV2, 2);
        FINALLY
           // Couper la connexion immédiatement
            CouperConnexion(0);
            LeDelay(2000);
// Lance le recacule des triggers
            LanceCalculeTrigger;
        END;
    END;
END;

PROCEDURE TFrm_Launch.dxB_JournalClick(Sender: TObject);
BEGIN
    Frm_Rapport.Execute;
END;

PROCEDURE TFrm_Launch.dxB_PushClick(Sender: TObject);
BEGIN
   // Connexion
    IF SeConnecter THEN
    BEGIN
        TRY
           // Replication
            IF (ExeEAI1 <> '') AND (PathEAI1 <> '') THEN
                ReplicationPush(ExeEAI1, PushURL, PushUSER, PushPASS, PushPROV, 1);
            LeDelay(5000);
            IF (ExeEAI2 <> '') AND (PathEAI2 <> '') THEN
                ReplicationPush(ExeEAI2, PushURL2, PushUSER2, PushPASS2, PushPROV2, 2);
        FINALLY
           // Couper la Connexion
            CouperConnexion(0);
        END;
    END;
END;

PROCEDURE TFrm_Launch.dxB_PullClick(Sender: TObject);
BEGIN
   // Connexion
    IF SeConnecter THEN
    BEGIN
        TRY
           // Replication
            IF (ExeEAI1 <> '') AND (PathEAI1 <> '') THEN
                ReplicationPull(ExeEAI1, PullURL, PullUSER, PullPASS, PullPROV, 1);
            LeDelay(5000);
            IF (ExeEAI2 <> '') AND (PathEAI2 <> '') THEN
                ReplicationPull(ExeEAI2, PullURL2, PullUSER2, PullPASS2, PullPROV2, 2);
        FINALLY
           // Couper la Connexion
            CouperConnexion(0);
        END;
    END;
END;

PROCEDURE TFrm_Launch.dxB_ConsoClick(Sender: TObject);
BEGIN
    Frm_RapportConso.Execute
END;

PROCEDURE TFrm_Launch.dxB_ReduireClick(Sender: TObject);
BEGIN
    IF Tray_Launch.NoClose THEN
        Hide
    ELSE
        Close;
END;

PROCEDURE TFrm_Launch.dxB_lanceClick(Sender: TObject);
VAR Ini: TiniFile;
    reg: TRegistry;
BEGIN
    Ini := tinifile.create(changefileext(application.exename, '.ini'));
    reg := tregistry.create(KEY_WRITE);
    reg.RootKey := hkey_local_machine;
    IF LogDlg_Pwd.Execute THEN
        IF (UPPERCASE(LogDlg_Pwd.Value) = 'NEBKA') THEN
        BEGIN
            IF (dxB_lance.ImageIndex = 0) THEN
            BEGIN
                TRY
                    reg.OpenKey('software\microsoft\windows\currentVersion\run', False);
                    reg.DeleteValue('Launch_Replication');
                 //WriteString('Launch_Replication',application.exename);
                FINALLY
                    reg.free;
                END;
                dxB_lance.ImageIndex := -1;
            END
            ELSE BEGIN
                TRY
                    reg.OpenKey('software\microsoft\windows\currentVersion\run', False);
                    reg.WriteString('Launch_Replication', application.exename);
                FINALLY
                    reg.free;
                END;
                dxB_lance.ImageIndex := 0;
            END;
            Lab_LanceAuto.visible := (dxB_lance.ImageIndex = 0);
            Ini.WriteBool('REPLIK', 'Run', Lab_LanceAuto.visible);
        END;
    Ini.Free;
END;

PROCEDURE TFrm_Launch.dxB_HoraireClick(Sender: TObject);
VAR H1, H2: TTime;
    VH1, VH2: Boolean;
    Ini: TiniFile;
BEGIN
    Ini := tinifile.create(changefileext(application.exename, '.ini'));
    IF LogDlg_Pwd.Execute THEN
        IF (UPPERCASE(LogDlg_Pwd.Value) = 'NEBKA') THEN
        BEGIN
            H1 := Ini.ReadTime('REPLIK', 'Heure', 0);
            H2 := Ini.ReadTime('REPLIK', 'Heure2', 0);
            VH1 := Ini.ReadBool('REPLIK', 'ValideH', False);
            VH2 := Ini.ReadBool('REPLIK', 'ValideH2', False);
            IF Frm_Horaire.Execute(H1, H2, VH1, VH2) = mrok THEN
            BEGIN
                Ini.WriteTime('REPLIK', 'Heure', H1);
                Ini.WriteTime('REPLIK', 'Heure2', H2);
                Ini.WriteBool('REPLIK', 'ValideH', VH1);
                Ini.WriteBool('REPLIK', 'ValideH2', VH2);
                ReglageHeure(Ini);
                ReglageHeureBackup;
                Tim_LaunchTimer(Sender);
            END;
        END;
    Ini.Free;
END;

PROCEDURE TFrm_Launch.VidePort;
BEGIN
    FHTTPAgent.Free;
    FHTTPPing.Free;
    FHTTPAgent := TSimpleHTTP.Create(Self);
    FHTTPPing := TSimpleHTTP.Create(Self);
END;

PROCEDURE TFrm_Launch.Tray_LaunchDblClick(Sender: TObject);
BEGIN
    Pop_LaunchClick(Sender);
END;

FUNCTION TFrm_Launch.SeConnecter: Boolean;
VAR reg: TRegistry;
BEGIN
  IF not MapGinkoia.Backup then
  begin
    Result := False;
     // Enfin la fin des travailler hors connexion !!!!
    reg := tregistry.create(KEY_WRITE);
    TRY
        reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings\', False);
        reg.WriteInteger('GlobalUserOffline', 0);
    FINALLY
        reg.free;
    END;

    CasConnexion := -1;
    IF Connexion(ConnexionNom, ConnexionTel, 1) THEN
        CasConnexion := 1
    ELSE IF ((ConnexionNom_2 <> '') AND (ConnexionTel_2 <> '')) AND Connexion(ConnexionNom_2, ConnexionTel_2, 2) THEN
        CasConnexion := 2;
    Result := (CasConnexion <> -1);
    IF NOT Result THEN
    BEGIN
        Memo('Envoi', 'Erreur : Pas de connexion');
        Memo1.Lines.Add(ErrFin1);
    END
    ELSE
    BEGIN
        Memo('Envoi', 'Connexion établie !');
        Memo1.Lines.Add(ConnexOk);
    END;
  END;
END;

PROCEDURE TFrm_Launch.CouperConnexion(Cas: Integer);
var ok: boolean;
BEGIN
    HConnexion := now;
    REPEAT
        ok := DeConnexion(CasConnexion);
    UNTIL ok;

    Memo('Reception', 'Connexion terminée !');
    Memo1.Lines.Add(ConnexFin);

    HConnexion := 0;
END;

PROCEDURE TFrm_Launch.DesactiveTrigger;
BEGIN
    IF NOT Data.Connected THEN
    BEGIN
        Data.DatabaseName := PathBase;
        Data.Open;
        tran.Active := true;
    END;

    IBSql_Trigger.sql.Clear;
    IBSql_Trigger.sql.Add('execute procedure BN_ACTIVETRIGGER(0);');
    IBSql_Trigger.ExecQuery;

    IF tran.Active AND tran.InTransaction THEN
        tran.Commit;

    Data.Close;
    tran.Active := False;
END;

PROCEDURE TFrm_Launch.ReactiveTrigger;
BEGIN
    IF NOT Data.Connected THEN
    BEGIN
        Data.DatabaseName := PathBase;
        Data.Open;
        tran.Active := true;
    END;

    IBSql_Trigger.sql.Clear;
    IBSql_Trigger.sql.Add('execute procedure BN_ACTIVETRIGGER(1);');
    IBSql_Trigger.ExecQuery;

    IF tran.Active AND tran.InTransaction THEN
        tran.Commit;

    Data.Close;
    tran.Active := False;
END;

PROCEDURE TFrm_Launch.LanceCalculeTrigger;
VAR res: Integer;
    num, Id, Id_Dos: STRING;
BEGIN
    Memo1.Lines.add('Recalcule en cours !');
     // attention tt que la procedure renvoie 1 c'est que le travail n'est pas fini
     // donc relancer
    IF NOT Data.Connected THEN
    BEGIN
        Data.DatabaseName := PathBase;
        Data.Open;
        tran.Active := true;
    END;

    IBSql_Trigger.Sql.Clear;
    IBSql_Trigger.Sql.Add('select Cast(PAR_STRING as Integer) Numero');
    IBSql_Trigger.Sql.Add('from genparambase');
    IBSql_Trigger.Sql.Add('Where PAR_NOM=''IDGENERATEUR''');
    IBSql_Trigger.ExecQuery;
    num := IBSql_Trigger.Fields[0].AsString;
    IBSql_Trigger.Close;
    IBSql_Trigger.Sql.Clear;
    IBSql_Trigger.Sql.Add('select Bas_ID');
    IBSql_Trigger.Sql.Add('from GenBases');
    IBSql_Trigger.Sql.Add('where BAS_ID<>0');
    IBSql_Trigger.Sql.Add('AND BAS_IDENT='+#39+ Num +#39);
    IBSql_Trigger.ExecQuery;
    num := IBSql_Trigger.Fields[0].AsString;

    IBSql_Trigger.Close;
    IBSql_Trigger.Sql.Clear;
    IBSql_Trigger.Sql.Add('Select NewKey ');
    IBSql_Trigger.Sql.Add('From PROC_NEWKEY');
    IBSql_Trigger.ExecQuery;
    Id := IBSql_Trigger.Fields[0].AsString;
    IBSql_Trigger.Close;

    IBSql_Trigger.Close;
    IBSql_Trigger.Sql.Clear;
    IBSql_Trigger.Sql.Add('Select DOS_ID ');
    IBSql_Trigger.Sql.Add('From GenDossier');
    IBSql_Trigger.Sql.Add('Where DOS_NOM ='+#39+'T-'+Num+#39);
    IBSql_Trigger.ExecQuery;
    Id_Dos := IBSql_Trigger.Fields[0].AsString;
    IBSql_Trigger.Close;


    TRY
        res := 0;
        REPEAT
            Memo1.Lines[Memo1.Lines.Count - 1] := Memo1.Lines[Memo1.Lines.Count - 1] + '.';
            Memo1.Update;
            IBStProc_TriggerDiffere.ExecProc;
            res := IBStProc_TriggerDiffere.ParamByName('RETOUR').asInteger;
            tran.Commit;
            tran.ACTIVE := True;
        UNTIL res = 0;
        IF ID_DOS = '0' then
        begin
            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Insert Into GenDossier');
            IBSql_Trigger.Sql.Add('(DOS_ID, DOS_NOM, DOS_STRING,DOS_FLOAT)');
            IBSql_Trigger.Sql.Add('VALUES (');
            IBSql_Trigger.Sql.Add(Id + ','+#39+'T-'+Num +#39+ ', ' +#39+ DateToStr(Date)+#39+ ', 1');
            IBSql_Trigger.Sql.Add(')');
            IBSql_Trigger.ExecQuery;

            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Insert Into K');
            IBSql_Trigger.Sql.Add('(K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,');
            IBSql_Trigger.Sql.Add(' KSE_DELETE_ID,K_DELETED, KSE_UPDATE_ID, K_UPDATED,KSE_LOCK_ID, KMA_LOCK_ID )');
            IBSql_Trigger.Sql.Add('VALUES (');
            IBSql_Trigger.Sql.Add(ID + ',-101,-11111338,' + Id + ',1,-1,-1,Current_date,0,Current_date,-1,Current_date,0,0 )');
            IBSql_Trigger.ExecQuery;
        END
        ELSE
        BEGIN
            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Update GenDossier');
            IBSql_Trigger.Sql.Add('Set DOS_STRING ='+#39+DateToStr(Date)+#39+', DOS_FLOAT=1');
            IBSql_Trigger.Sql.Add('Where DOS_ID = '+Id_Dos);
            IBSql_Trigger.ExecQuery;

            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Update K');
            IBSql_Trigger.Sql.Add('Set K_VERSION = '+Id);
            IBSql_Trigger.Sql.Add('Where K_ID = '+Id_Dos);
            IBSql_Trigger.ExecQuery;
        END;
        IF IBSql_Trigger.Transaction.InTransaction THEN
            IBSql_Trigger.Transaction.commit;
    EXCEPT
        Memo1.Lines.add('Recalcule erreur !');
        Tran.Rollback;
        Tran.ACTIVE := True;
        // Noter dans la base dans Gendossier
        IF ID_DOS = 'O' then
        begin
            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Insert Into GenDossier');
            IBSql_Trigger.Sql.Add('(DOS_ID, DOS_NOM, DOS_STRING,DOS_FLOAT)');
            IBSql_Trigger.Sql.Add('VALUES (');
            IBSql_Trigger.Sql.Add(Id + ',' + 'T-'+Num + ', ' + DateToStr(Date)+', 0');
            IBSql_Trigger.Sql.Add(')');
            IBSql_Trigger.ExecQuery;

            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Insert Into K');
            IBSql_Trigger.Sql.Add('(K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,');
            IBSql_Trigger.Sql.Add(' KSE_DELETE_ID,K_DELETED, KSE_UPDATE_ID, K_UPDATED,KSE_LOCK_ID, KMA_LOCK_ID )');
            IBSql_Trigger.Sql.Add('VALUES (');
            IBSql_Trigger.Sql.Add(ID + ',-101,-11111338,' + Id + ',1,-1,-1,Current_date,0,Current_date,-1,Current_date,0,0 )');
            IBSql_Trigger.ExecQuery;
        END
        ELSE
        BEGIN
            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Update GenDossier');
            IBSql_Trigger.Sql.Add('Set DOS_STRING ='+#39+DateToStr(Date)+#39+', DOS_FLOAT=0');
            IBSql_Trigger.Sql.Add('Where DOS_ID = '+Id_Dos);
            IBSql_Trigger.ExecQuery;

            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Update K');
            IBSql_Trigger.Sql.Add('Set K_VERSION = '+Id);
            IBSql_Trigger.Sql.Add('Where K_ID = '+Id_Dos);
            IBSql_Trigger.ExecQuery;
        END;
        IF IBSql_Trigger.Transaction.InTransaction THEN
            IBSql_Trigger.Transaction.commit;
    END;
    Memo1.Lines.add('Recalcule fini !');
    IF tran.InTransaction THEN
        tran.Commit;
    Data.Close;
    Tran.Active := False;
END;

PROCEDURE TFrm_Launch.ChangeTrigger;
VAR res: Integer;
BEGIN
  IF not MapGinkoia.Backup then
  begin
    IF NOT Data.Connected THEN
    BEGIN
        Data.DatabaseName := PathBase;
        Data.Open;
        tran.Active := true;
    END;

    // Tester s'il faut mettre en place les nv triggers
    IBQue_ParamBase.Open;
    IF IBQue_ParamBase.IsEmpty OR (IBQue_ParamBasePAR_STRING.asString <> '2') THEN
    BEGIN
        // Droppper les triggers
        IF tran.InTransaction THEN
            tran.Commit;
        Data.Close;
        tran.Active := False;
        Data.Params.Clear;
        Data.Params.Add('user_name=SYSDBA');
        Data.Params.Add('password=masterkey');
        Data.DatabaseName := PathBase;
        Data.Open;
        tran.Active := true;

        // Correction de la procedure BN_TRIGGERDIFFERE
        Correct_BN_TRIGGERDIFFERE.ExecQuery;

        IBSql_Trigger.sql.Clear;
        IBSql_Trigger.sql.Add('GRANT EXECUTE ON PROCEDURE BN_TRIGGERDIFFERE TO GINKOIA');
        IBSql_Trigger.ExecQuery;

        IF IBQue_ParamBase.IsEmpty THEN
        begin
            IBSql_Trigger.sql.Clear;
            IBSql_Trigger.sql.Add('INSERT INTO GENPARAMBASE (PAR_NOM,PAR_STRING) VALUES (''NV_TRIGGER'',''2'');');
            IBSql_Trigger.ExecQuery;
        end
        else
        begin
            IBSql_Trigger.sql.Clear;
            IBSql_Trigger.sql.Add('UPDATE GENPARAMBASE SET PAR_STRING=''2'' WHERE PAR_NOM=''NV_TRIGGER''');
            IBSql_Trigger.ExecQuery;
        END;
    END;
    IBQue_ParamBase.Close;

    IF tran.InTransaction THEN
        tran.Commit;
    Data.Close;
    tran.Active := False;
    Data.Params.Clear;
    Data.Params.Add('user_name=GINKOIA');
    Data.Params.Add('password=ginkoia');
  END;
END;



procedure TFrm_Launch.dxB_RecalcClick(Sender: TObject);
begin
// Lance le recacule des triggers
   ReactiveTrigger;
   LanceCalculeTrigger;
end;

procedure TFrm_Launch.Tim_BackupRestorTimer(Sender: TObject);
var t : TTime;
begin
   IF Tim_BackupRestor.Tag = 0 THEN // Paramétarge du timer
   BEGIN
    CASE EtatBackup OF
        // -1 pas de backup,
        //  1 après la 1° réplication
        //  2 après la 2° réplication
     -1,1,2 : Tim_BackupRestor.Enabled := False;
        //  3 à 23 heure HeureBackup
        //  4 à 22 heure HeureBackup
        //  5 à la 1er Heures(non automatique) si rien à 23h HeureBackup
      3,4,5 : BEGIN
                t := Time;
                IF t < HeureBackup THEN
                   Tim_BackupRestor.Interval := Round((HeureBackup - t) * 86400000)
                ELSE
                   Tim_BackupRestor.Interval := Round(((StrToTime('23:59:59') - t) + HeureBackup) * 86400000);
              END;
    END;
    Tim_BackupRestor.Tag := 1;
   END
   ELSE // executer le backupRestor
   BEGIN
       // Lancement du Backup-Restor uniquement à la première réplication automatique
       winexec(PChar(path + 'BackRest.exe auto'), 0);
       Memo1.Lines.Add(DateToStr(Now) + ' Lancement du BackupRestor');
       Tim_BackupRestor.Interval := 86400000; // soit 24h
   END;
end;

END.

