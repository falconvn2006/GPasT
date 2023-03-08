UNIT TPEServ_FRM;

INTERFACE

USES
    inifiles,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    CPort, ExtCtrls, StdCtrls, ScktComp, Menus, LMDCustomComponent,
    LMDWndProcComponent, LMDTrayIcon;

TYPE
    TUnClient = CLASS
        Resultat: Integer;
        R_Caisse: STRING;
        R_TransactionOk: Boolean;
        R_Montant: Double;
        R_Type: Integer;
        R_NUMCB: STRING;
        R_NUMCHQ: STRING;
        R_COMP: STRING;
        R_MODE: Char;
        R_DEV: STRING;
    END;

    Tfrm_TPEServ = CLASS(TForm)
        Com1: TComPort;
        Tim: TTimer;
        Label1: TLabel;
        Label2: TLabel;
        Lab_Ent: TLabel;
        Lab_TPE: TLabel;
        Serveur: TServerSocket;
        Dem: TTimer;
        MainMenu1: TMainMenu;
        Menu1: TMenuItem;
        Paramtrage1: TMenuItem;
        Tray: TLMDTrayIcon;
        Pop_Tray: TPopupMenu;
        Afficher1: TMenuItem;
        Paramtres1: TMenuItem;
        N1: TMenuItem;
        Quiter1: TMenuItem;
        PROCEDURE Com1RxChar(Sender: TObject; Count: Integer);
        PROCEDURE TimTimer(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE ServeurClientError(Sender: TObject; Socket: TCustomWinSocket;
            ErrorEvent: TErrorEvent; VAR ErrorCode: Integer);
        PROCEDURE ServeurClientRead(Sender: TObject; Socket: TCustomWinSocket);
        PROCEDURE DemTimer(Sender: TObject);
        PROCEDURE FormDestroy(Sender: TObject);
        PROCEDURE Paramtrage1Click(Sender: TObject);
        PROCEDURE TrayDblClick(Sender: TObject);
        PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
        PROCEDURE Quiter1Click(Sender: TObject);
        PROCEDURE ServeurClientConnect(Sender: TObject;
            Socket: TCustomWinSocket);
    PRIVATE
    { Déclarations privées }
    PROTECTED
        MessageEnCours: STRING;
        LesClient: TstringList;
        CltEnCours: TUnClient;
        LePortCom: Integer;
        FUNCTION CheckSum(Mess: STRING): Char;
        PROCEDURE Envoi_Message(Mess: STRING);
        PROCEDURE Delay(tps: dword);
        PROCEDURE Envoie(CONST Buf; BufSize: Integer; TimeOut: Boolean; Etat: Integer; New: Boolean);
        PROCEDURE EnvoieStr(CONST Buf: STRING; TimeOut: Boolean; Etat: Integer; New: Boolean);
        PROCEDURE Ouvre;
        PROCEDURE ferme;
        FUNCTION TPE_Connect: Boolean;
        PROCEDURE Init_Conv;
        PROCEDURE decodeMessage;
    PUBLIC
    { Déclarations publiques }

        Short: Boolean;

        State: Integer;
        N: Integer;
        Montant: Double;
        RecuOk: Boolean;
        recu: STRING;
        Fini: boolean;

        R_Caisse: STRING;
        R_PHONIQUE: Boolean;
        R_TransactionOk: Boolean;
        R_Montant: Double;
        R_Type: Integer;
        R_NUMCB: STRING;
        R_NUMCHQ: STRING;
        R_COMP: STRING;
        R_MODE: Char;
        R_DEV: STRING;

        Occupe: boolean;
        FUNCTION TPE_Present: Boolean;
        FUNCTION Encaisse(Montant: Double): Boolean;
    END;

VAR
    frm_TPEServ: Tfrm_TPEServ;

IMPLEMENTATION
USES
    GinkoiaResStr,
    ChxCom_FRM;
CONST
    STX: Char = #$02;
    ETX: Char = #$03;
    EOT: Char = #$04;
    ENQ: Char = #$05;
    ACK: Char = #$06;
    NAK: Char = #$15;

{$R *.DFM}

// Principe
// ENQ      STX Message ETX LRC       EOT
//      ACK                      ACK

PROCEDURE Tfrm_TPEServ.Init_Conv;
BEGIN
    Lab_TPE.Caption := CstTPETrfInf; Lab_Tpe.Update;
    n := 0;
    State := 2;
    Com1.ClearBuffer(true, true);
    Com1.Write(ENQ, Sizeof(ENQ));
    tim.enabled := true;
END;

FUNCTION Tfrm_TPEServ.CheckSum(Mess: STRING): Char;
VAR
    i: integer;
BEGIN
    Lab_TPE.Caption := CstTPETrfChkSum; Lab_Tpe.Update;
    result := #00;
    FOR i := 1 TO length(mess) DO
        result := chr(ord(result) XOR ord(Mess[i]));
END;

FUNCTION Tfrm_TPEServ.TPE_Present: Boolean;
BEGIN
    occupe := true;
    TRY
        Ouvre;
        Lab_TPE.Caption := CstTPETrfAcce; Lab_Tpe.Update;
        Envoie(ENQ, Sizeof(ENQ), True, 99, true);
        WHILE state > 0 DO
        BEGIN
            Sleep(100);
            application.processmessages;
        END;
        Com1.Write(EOT, Sizeof(EOT));
        application.processmessages;
        Ferme;
        Lab_TPE.Caption := CstTPETrfDecon; Lab_Tpe.Update;
        result := state = 0;
    FINALLY
        occupe := false;
    END;
END;

PROCEDURE Tfrm_TPEServ.Delay(tps: dword);
BEGIN
    tps := gettickcount + tps;
    WHILE tps > gettickcount DO
    BEGIN
        Sleep(100);
        application.processMessages;
    END;
END;

PROCEDURE Tfrm_TPEServ.Envoie(CONST Buf; BufSize: Integer; TimeOut: Boolean; Etat: Integer; New: Boolean);
BEGIN
    State := Etat;
    IF New THEN
        n := 0;
    IF timeout THEN
        tim.enabled := true;
    com1.write(Buf, BufSize);
END;

PROCEDURE Tfrm_TPEServ.ferme;
BEGIN
    Com1.ClearBuffer(true, true);
    Com1.Close;
    Lab_TPE.Caption := CstTPETrfFermPort; Lab_Tpe.Update;
END;

PROCEDURE Tfrm_TPEServ.Ouvre;
BEGIN
    Com1.Port := 'COM' + Inttostr(leportcom);
    Lab_TPE.Caption := CstTPETrfOuvPort; Lab_Tpe.Update;
    Com1.Open;
    Com1.ClearBuffer(true, true);
    Fini := false;
END;

FUNCTION Tfrm_TPEServ.Encaisse(Montant: Double): Boolean;
VAR
    Mess: STRING;
BEGIN
    occupe := true;
    TRY
        result := false;
        // Vérifie que le tpe est la
        Ouvre;
        IF TPE_Connect THEN
        BEGIN
            Mess := Inttostr(round(montant * 100));
            WHILE length(mess) < 8 DO mess := '0' + mess;
            IF Short THEN
            BEGIN
                MESS := '01' + mess + '1' + ETX;
            END
            ELSE
            BEGIN
                MESS := '01' + mess + '100978          ' + ETX;
            END;

            // Demande de transaction
            Envoi_Message(mess);

            // Attente de 0 (ACK), -1 (NACK) ou -99 (TimeOut)
            WHILE state > 0 DO
            BEGIN
                sleep(100);
                Application.processmessages;
            END;
            // Si State<>TimeOu envoie de EOT
            IF state > -99 THEN
            BEGIN
                Com1.Write(EOT, Sizeof(EOT));
                IF state = 0 THEN
                BEGIN
                    // Attente de la réception de la réponses du TPE
                    State := 97;
                    WHILE state > 0 DO
                    BEGIN
                        sleep(100);
                        Application.processmessages;
                    END;
                    IF state = 0 THEN
                    BEGIN
                        // décodageMessage ;
                        decodeMessage;
                        result := R_TransactionOk;
                    END;
                END;
            END;
        END;
        ferme;
        Lab_TPE.Caption := CstTPETrfDecon; Lab_Tpe.Update;
    FINALLY
        occupe := false;
    END;
END;

PROCEDURE Tfrm_TPEServ.Envoi_Message(Mess: STRING);
BEGIN
    Lab_TPE.Caption := CstTPETrfEnvMess; Lab_Tpe.Update;
    MessageEnCours := STX + mess + CheckSum(mess);
    EnvoieStr(MessageEnCours, true, 98, true);
END;

PROCEDURE Tfrm_TPEServ.EnvoieStr(CONST Buf: STRING; TimeOut: Boolean;
    Etat: Integer; New: Boolean);
BEGIN
    State := Etat;
    IF New THEN
        n := 0;
    IF timeout THEN
        tim.enabled := true;
    com1.WriteStr(Buf);
END;

PROCEDURE Tfrm_TPEServ.Com1RxChar(Sender: TObject; Count: Integer);
VAR
    tc: Char;
    enabledtimer: Boolean;
BEGIN
    tim.enabled := false;
    enabledtimer := false;
    WHILE (Count > 0) DO
    BEGIN
        dec(count);
        Com1.Read(tc, 1);
        // 99 Présence du TPE ?
        // 98 Attenbte validation message
        // 97 Attente de l'accusé de réception du TPE (ENQ)
        // 96 Attente de STX
        // 95 Lecture du message
        // 94 attente checkSum du message ;
        // 93 Attente de la cloture
        IF State = 93 THEN
        BEGIN
            Lab_TPE.Caption := CstTPETrfRecClot; Lab_Tpe.Update;
            IF recuOk THEN
                State := 0
            ELSE
                State := -1;
        END
        ELSE IF State = 94 THEN
        BEGIN
            RecuOk := CheckSum(recu) = tc;
            IF RecuOk THEN
                Lab_TPE.Caption := CstTPETrfRecChk + ' OK'
            ELSE
                Lab_TPE.Caption := CstTPETrfRecChk + ' NOK';
            Lab_Tpe.Update;
            IF RecuOk THEN
            BEGIN
                Com1.Write(ACK, Sizeof(ACK));
                State := 0;
                // Envoie(ACK, Sizeof(ACK), true, 93, true)
            END
            ELSE
                Envoie(NAK, Sizeof(NAK), true, 96, true);
        END
        ELSE IF State = 95 THEN
        BEGIN
            Lab_TPE.Caption := CstTPETrfRecMess; Lab_Tpe.Update;
            recu := recu + tc;
            IF TC = ETX THEN
                State := 94;
            enabledtimer := true;
        END
        ELSE IF (State = 96) THEN
        BEGIN
            Lab_TPE.Caption := CstTPETrfRecStx; Lab_Tpe.Update;
            IF tc = EOT THEN
                State := 97
            ELSE IF TC = STX THEN
            BEGIN
                Recu := '';
                State := 95;
                enabledtimer := true;
            END
            ELSE
            BEGIN
                Envoie(NAK, SizeOf(NAK), True, 96, true);
            END
        END
        ELSE IF (State = 97) THEN
        BEGIN
            Lab_TPE.Caption := CstTPETrfRecENQ; Lab_Tpe.Update;
            IF Tc = ENQ THEN
                Envoie(ACK, SizeOf(ACK), True, 96, true);
        END
        ELSE IF (State IN [98, 99]) THEN
        BEGIN
            Lab_TPE.Caption := CstTPETrfRecAck; Lab_Tpe.Update;
            IF tc = ACK THEN
            BEGIN
                state := 0;
            END
            ELSE IF tc = NAK THEN
            BEGIN
                state := -1;
            END;
        END

    END;
    IF enabledtimer THEN
        tim.enabled := true;
END;

PROCEDURE Tfrm_TPEServ.TimTimer(Sender: TObject);
BEGIN
    tim.enabled := False;
    Lab_TPE.Caption := CstTPETrfTimeOut; Lab_Tpe.Update;
    IF State = 93 THEN
    BEGIN
        IF recuOk THEN
            State := 0
        ELSE
            State := -1;
    END
    ELSE IF state IN [94, 95] THEN
    BEGIN
        Envoie(NAK, Sizeof(NAK), true, 96, False);
    END
    ELSE IF state = 96 THEN
    BEGIN
        State := 97;
    END
    ELSE IF State IN [98, 99] THEN
    BEGIN
        N := N + 1;
        IF N < 3 THEN
        BEGIN
            Com1.ClearBuffer(true, true);
            IF state = 99 THEN
            BEGIN
                Com1.Write(EOT, Sizeof(EOT));
                Delay(500);
                Envoie(ENQ, Sizeof(ENQ), true, 99, false);
            END
            ELSE IF state = 98 THEN
            BEGIN
                EnvoieStr(MessageEnCours, true, 98, false);
            END;
        END
        ELSE
            State := -99;
    END;
END;

PROCEDURE Tfrm_TPEServ.decodeMessage;
VAR
    S: STRING;
    Tsl : TstringList ;
BEGIN
    Lab_TPE.Caption := CstTPETrfDecRep; Lab_Tpe.Update;
    R_NUMCHQ := '';
    R_COMP := '';
    R_NUMCB := '';
    R_DEV := '978';
    IF length(recu) > 70 THEN
    BEGIN
    // message complet
        R_Caisse := Copy(recu, 1, 2);
        R_TransactionOk := (recu[3] = '0') or (recu[3] = '1');
        IF not R_TransactionOk then
        Begin
          Tsl := TstringList.create ;
          try
            Tsl.LoadfromFile(changefileext(application.ExeName,'.txt')) ;
          except
          END ;
          tsl.add (datetimetostr(now)) ;
          tsl.add (recu) ;
          Tsl.SavetoFile(changefileext(application.ExeName,'.txt')) ;
          tsl.free ;
        END ;
        R_PHONIQUE := recu[3] = '2';

        S := Copy(recu, 4, 8);
        R_Montant := StrToInt(S) / 100;
        delete(recu, 1, 11);
        R_MODE := recu[1];
        delete(recu, 1, 1);
        IF r_mode = 'C' THEN
        BEGIN
            R_NUMCHQ := copy(recu, 1, 35);
            delete(recu, 1, 35);
            R_COMP := copy(recu, 1, 20);
        END
        ELSE
        BEGIN
            R_NUMCB := copy(recu, 1, 19);
            delete(recu, 1, 55);
        END;
        R_DEV := copy(recu, 1, 3);
    END
    ELSE
    BEGIN
        R_Caisse := Copy(recu, 1, 2);
        R_TransactionOk := (recu[3] = '0') or (recu[3] = '1');
        IF not R_TransactionOk then
        Begin
          Tsl := TstringList.create ;
          try
            Tsl.LoadfromFile(changefileext(application.ExeName,'.txt')) ;
          except
          END ;
          tsl.add (datetimetostr(now)) ;
          tsl.add (recu) ;
          Tsl.SavetoFile(changefileext(application.ExeName,'.txt')) ;
          tsl.free ;
        END ;

        R_PHONIQUE := recu[3] = '2';
        S := Copy(recu, 4, 8);
        R_Montant := StrToInt(S) / 100;
        delete(recu, 1, 11);
        R_Type := Ord(recu[1]) - ord('0');
        delete(recu, 1, 1);
        IF length(recu) > 35 THEN
        BEGIN
            R_NUMCHQ := copy(recu, 1, 35);
            delete(recu, 1, 35);
            R_COMP := recu;
            r_mode := 'C';
        END
        ELSE
        BEGIN
            R_NUMCB := recu;
            r_mode := '1';
        END;
    END;
END;

PROCEDURE Tfrm_TPEServ.FormCreate(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    LesClient := tstringList.create;
    ini := tinifile.create(changefileext(application.exename, '.ini'));
    LePortCom := ini.ReadInteger('PORT', 'COM', 1);
    ini.free;
    TRY
        Serveur.Active := true;
    EXCEPT
        halt;
    END;
    Short := false;
    Occupe := false;
END;

FUNCTION Tfrm_TPEServ.TPE_Connect: Boolean;
BEGIN
    Lab_TPE.Caption := CstTPETrfAcce; Lab_Tpe.Update;
    Envoie(ENQ, Sizeof(ENQ), True, 99, true);
    WHILE state > 0 DO
    BEGIN
        Sleep(100);
        application.processmessages;
    END;
    result := state = 0;
END;

PROCEDURE Tfrm_TPEServ.ServeurClientError(Sender: TObject;
    Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
    VAR ErrorCode: Integer);
BEGIN
    errorcode := 0;
END;

PROCEDURE Tfrm_TPEServ.ServeurClientRead(Sender: TObject;
    Socket: TCustomWinSocket);
VAR
    S: STRING;
    Ad: STRING;
    PlTuc: Integer;
BEGIN
    s := Socket.RemoteAddress;
    Ad := S;
    PlTuc := LesClient.indexOf(s);
    IF PlTuc = -1 THEN
    BEGIN
        PlTuc := LesClient.AddObject(S, TUnClient.Create);
    END;
    S := Socket.ReceiveText;
    IF copy(S, 1, 1) = '?' THEN
    BEGIN
        IF occupe THEN
            socket.SendText('OCCUPE')
        ELSE
        BEGIN
            CltEnCours := TUnClient(LesClient.Objects[PlTuc]);
            socket.SendText('OK');
            IF S = '?TPE' THEN
            BEGIN
                Lab_Ent.Caption := CstTPETrfTpePres + Ad;
                dem.tag := 1;
                dem.enabled := true;
            END
            ELSE
            BEGIN
                Lab_Ent.Caption := CstTPETrfTpeUtil + Ad;
                delete(S, 1, Pos(';', S));
                IF pos('.', S) > 0 THEN
                    DecimalSeparator := '.'
                ELSE
                    DecimalSeparator := ',';
                Montant := StrToFloat(S);
                dem.tag := 2;
                dem.enabled := true;
            END;
        END;
    END
    ELSE IF copy(S, 1, 1) = '!' THEN
    BEGIN
        IF (S = '!CANCEL') AND (TUnClient(LesClient.Objects[PlTuc]).Resultat = 99) THEN
        BEGIN
            com1.write(EOT, SizeOf(EOT));
            com1.write(NAK, SizeOf(NAK));
        END
        ELSE
        BEGIN
            Lab_Ent.Caption := CstTPETrfTpeEtat + Ad;
            IF TUnClient(LesClient.Objects[PlTuc]).Resultat = 99 THEN
            BEGIN
                socket.SendText('ENCOURS;' + Inttostr(State));
            END
            ELSE IF TUnClient(LesClient.Objects[PlTuc]).Resultat = 1 THEN
            BEGIN
                IF TUnClient(LesClient.Objects[PlTuc]).r_mode = 'C' THEN
                BEGIN
                    S := 'OK;C;' + TUnClient(LesClient.Objects[PlTuc]).R_NUMCHQ;
                END
                ELSE
                BEGIN
                    S := 'OK;B;' + TUnClient(LesClient.Objects[PlTuc]).R_NUMCB;
                END;
                socket.SendText(S);
            END
            ELSE IF TUnClient(LesClient.Objects[PlTuc]).Resultat = -1 THEN
                socket.SendText('TIMEOUT')
            ELSE
                socket.SendText('NACK');
        END;
    END
    ELSE
    BEGIN
        socket.SendText('NACK');
    END;
END;

PROCEDURE Tfrm_TPEServ.DemTimer(Sender: TObject);
BEGIN
    dem.enabled := false;
    CltEnCours.Resultat := 99;
    IF dem.tag = 1 THEN
    BEGIN
        IF TPE_Present THEN
            CltEnCours.resultat := 1
        ELSE IF state = -99 THEN
            CltEnCours.resultat := -1
        ELSE
            CltEnCours.resultat := 0;
    END
    ELSE
    BEGIN
        IF Encaisse(Montant) THEN
        BEGIN
            CltEnCours.resultat := 1;
        END
        ELSE IF state = -99 THEN
            CltEnCours.resultat := -1
        ELSE
            CltEnCours.resultat := 0;
        CltEnCours.R_Caisse := R_Caisse;
        CltEnCours.R_TransactionOk := R_TransactionOk;
        CltEnCours.R_Montant := R_Montant;
        CltEnCours.R_Type := R_Type;
        CltEnCours.R_NUMCB := R_NUMCB;
        CltEnCours.R_NUMCHQ := R_NUMCHQ;
        CltEnCours.R_COMP := R_COMP;
        CltEnCours.R_MODE := R_MODE;
        CltEnCours.R_DEV := R_DEV;
    END;
END;

PROCEDURE Tfrm_TPEServ.FormDestroy(Sender: TObject);
VAR
    i: integer;
BEGIN
    FOR i := 0 TO LesClient.count - 1 DO
        TUnClient(LesClient.Objects[i]).free;
    LesClient.free;
END;

PROCEDURE Tfrm_TPEServ.Paramtrage1Click(Sender: TObject);
VAR
    FRM_ChxCom: TFRM_ChxCom;
    ini: tinifile;
BEGIN
    Application.CreateForm(TFRM_ChxCom, FRM_ChxCom);
    TRY
        LePortCom := FRM_ChxCom.execute(LePortCom);
    FINALLY
        FRM_ChxCom.release;
    END;
    ini := tinifile.create(changefileext(application.exename, '.ini'));
    ini.writeInteger('PORT', 'COM', LePortCom);
    ini.free;
END;

PROCEDURE Tfrm_TPEServ.TrayDblClick(Sender: TObject);
BEGIN
    show;
    FormStyle := FsStayOnTop;
    Application.processmessages;
    FormStyle := FsNormal;
END;

PROCEDURE Tfrm_TPEServ.FormClose(Sender: TObject;
    VAR Action: TCloseAction);
BEGIN
    IF Tray.NoClose THEN
    BEGIN
        Hide;
        Action := CaNone;
    END;
END;

PROCEDURE Tfrm_TPEServ.Quiter1Click(Sender: TObject);
BEGIN
    Tray.NoClose := False;
    Close;
END;

PROCEDURE Tfrm_TPEServ.ServeurClientConnect(Sender: TObject;
    Socket: TCustomWinSocket);
VAR
    S: STRING;
    PlTuc: Integer;
BEGIN
    s := Socket.RemoteAddress;
    Lab_Ent.Caption := CstTPETrfConnexion + S;
    PlTuc := LesClient.indexOf(s);
    IF PlTuc = -1 THEN
    BEGIN
        LesClient.AddObject(S, TUnClient.Create);
    END;
END;

END.

