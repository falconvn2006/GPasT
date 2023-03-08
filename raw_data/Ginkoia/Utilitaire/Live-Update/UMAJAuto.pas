UNIT UMAJAuto;

INTERFACE

USES
    Connexion_Dm,
    CstLaunch,
    XMLCursor,
    StdXML_TLB,
    MSXML2_TLB,
    UMapping,
    fileCtrl,
    registry,
    inifiles,
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    StdCtrls,
    IBDatabase,
    IBSQL,
    Db,
    IBCustomDataSet,
    IBQuery,
    VCLUnZip,
    ExtCtrls,
    ScktComp,
    IB_Components,
    IB_Process,
    IB_Script,
    IBDataset;

TYPE
    TMonXML = CLASS(TXMLCursor)
    END;

    TForm1 = CLASS(TForm)
        Button1: TButton;
        UnZip: TVCLUnZip;
        Client: TClientSocket;
        tim_close: TTimer;
        IBScript: TIB_Script;
        data: TIB_Database;
        Tran: TIB_Transaction;
        qry: TIB_Query;
        QryVersion: TIB_Query;
        QryBase: TIBOQuery;
        Label1: TLabel;
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormPaint(Sender: TObject);
        PROCEDURE ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
        PROCEDURE ClientRead(Sender: TObject; Socket: TCustomWinSocket);
        PROCEDURE ClientError(Sender: TObject; Socket: TCustomWinSocket;
            ErrorEvent: TErrorEvent; VAR ErrorCode: Integer);
        PROCEDURE tim_closeTimer(Sender: TObject);
        PROCEDURE FormDestroy(Sender: TObject);
        PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
        PROCEDURE UnZipBadCRC(Sender: TObject; CalcCRC, StoredCRC,
            FileIndex: Integer);
        PROCEDURE ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    PRIVATE
        prem: boolean;
        Log: TstringList;
        PROCEDURE Traitement;
        FUNCTION Traitement_BATCH(LeFichier: STRING): boolean;
        PROCEDURE Copie(Src, Dst: STRING);
        { Déclarations privées }
        PROCEDURE AjouteNoeud(Xml: TMonXML; Noeud: STRING; Place: Integer; Valeur: STRING);
        FUNCTION ChercheVal(Noeuds: IXMLDOMNodeList; TAG: STRING): STRING;
        PROCEDURE RemplaceVal(Noeuds: IXMLDOMNodeList; TAG: STRING; Valeur: STRING);
        // PROCEDURE RemplaceVals(Noeuds: IXMLDOMNodeList; NoeudFils: STRING; TAG: STRING; Valeur: STRING);
        FUNCTION ChercheMinVal(Noeuds: IXMLDOMNodeList; NoeudFils: STRING; TAG: STRING): STRING;
        // FUNCTION ChercheMinValInt(Noeuds: IXMLDOMNodeList; NoeudFils: STRING; TAG: STRING): Integer;
        FUNCTION ChercheMaxVal(Noeuds: IXMLDOMNodeList; NoeudFils: STRING; TAG: STRING): STRING;
        // FUNCTION ChercheMaxValInt(Noeuds: IXMLDOMNodeList; NoeudFils: STRING; TAG: STRING): Integer;
        FUNCTION Existe(Noeuds: IXMLDOMNodeList; TAG: STRING; Valeur: STRING): Boolean;
        FUNCTION Existes(Noeuds: IXMLDOMNodeList; NoeudFils: STRING; TAG: STRING; Valeur: STRING): Integer;
    PUBLIC
        { Déclarations publiques }
        magasin: STRING;
        LaVersion: STRING;
        lesscript: tstringList;
        Path: STRING;
        ProbZip: STRING;

        Arecup: Boolean;
        Dm_Connexion: TDm_Connexion;
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION

{$R *.DFM}
VAR
    Lapplication: STRING;
    ok: Boolean;
CONST
    launcher = 'LE LAUNCHER';
    ginkoia = 'GINKOIA';
    Caisse = 'CAISSEGINKOIA';
    Script = 'SCRIPT';
    PICCO = 'PICCOLINK';
    Version = '2';
    TPE = 'SERVEUR DE TPE';

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

FUNCTION Enumerate2(hwnd: HWND; Param: LPARAM): Boolean; STDCALL; FAR;
VAR
    lpClassName: ARRAY[0..999] OF Char;
    lpClassName2: ARRAY[0..999] OF Char;
    //Handle: DWORD;
   // lpdwProcessId: Pointer;
BEGIN
    result := true;
    Windows.GetClassName(hWnd, lpClassName, 500);
    IF Uppercase(StrPas(lpClassName)) = 'TAPPLICATION' THEN
    BEGIN
        Windows.GetWindowText(hWnd, lpClassName2, 500);
        IF Uppercase(StrPas(lpClassName2)) = Lapplication THEN
        BEGIN
            OK := True;
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

PROCEDURE traite(src, dst, dest1: STRING);
VAR
    tms: TmemoryStream;
    tmd: TmemoryStream;
    tmRes: TmemoryStream;
    A: Longint;
    B: LongInt;
    C: Longint;
    i: Longint;
    tc: char;
BEGIN
    TmS := TmemoryStream.Create;
    TmD := TmemoryStream.Create;
    TmRes := TmemoryStream.Create;
    TRY
        TmS.LoadFromFile(src);
        TmD.LoadFromFile(dst);
        tmS.Seek(0, soFromBeginning);
        tmD.Seek(0, soFromBeginning);
        WHILE tms.Position < tms.size DO
        BEGIN
            tms.read(A, sizeof(A));
            IF A AND $10000000 = $10000000 THEN // Copie
            BEGIN
                A := A AND $0FFFFFFF;
                FOR i := 1 TO A DO
                BEGIN
                    tmd.read(tc, 1);
                    TmRes.Write(tc, 1);
                END;
            END
            ELSE IF A AND $20000000 = $20000000 THEN // Sauvegardé
            BEGIN
                A := A AND $0FFFFFFF;
                FOR i := 1 TO A DO
                BEGIN
                    tms.read(tc, 1);
                    TmRes.Write(tc, 1);
                    tmd.read(tc, 1);
                END;
            END
            ELSE IF A AND $40000000 = $40000000 THEN // ailleur
            BEGIN
                C := tmd.Position;
                A := A AND $0FFFFFFF;
                tms.read(B, sizeof(B));
                tmd.seek(B, soFromBeginning);
                FOR i := 1 TO A DO
                BEGIN
                    tmd.read(tc, 1);
                    TmRes.Write(tc, 1);
                END;
                tmd.seek(C, soFromBeginning);
            END
            ELSE
            BEGIN
                Application.MessageBox('problème', 'problème', Mb_Ok);
            END;
        END;
        TmRes.SaveToFile(dest1);
    FINALLY
        tms.free;
        tmd.free;
        tmRes.free;
    END;
END;

PROCEDURE TForm1.Copie(Src, Dst: STRING);
VAR
    Tsl: TStringList;
    i: Integer;
    j: integer;
    RepPass: STRING;
    Pass: STRING;
    s: STRING;
    quoi: integer;

    repdest: STRING;
    IEai: Integer;
BEGIN
    Lapplication := ginkoia;
    EnumWindows(@Enumerate, 0);
    sleep(100);
    Lapplication := Caisse;
    EnumWindows(@Enumerate, 0);
    sleep(100);
    Lapplication := TPE;
    EnumWindows(@Enumerate, 0);
    sleep(100);
    Lapplication := PICCO;
    EnumWindows(@Enumerate, 0);
    sleep(100);
    Lapplication := launcher;
    EnumWindows(@Enumerate, 0);
    sleep(5000);

    IF src[length(src)] <> '\' THEN src := src + '\';
    IF dst[length(dst)] <> '\' THEN dst := dst + '\';
    Tsl := TstringList.create;
    TRY
        TRY
            tsl.loadFromFile(Src + 'LesFichiers.LUP');
        EXCEPT
        END;
        RepPass := Src;
        delete(RepPass, length(RepPass), 1);
        WHILE pos('\', RepPass) > 0 DO
            delete(RepPass, 1, pos('\', RepPass));

        FOR i := 0 TO tsl.count - 1 DO
        BEGIN
            s := tsl[i];
            quoi := StrToInt(Copy(S, 1, pos(';', S) - 1));
            j := Pos(RepPass, s);
            delete(S, 1, j);
            delete(s, 1, length(RepPass));
            IF pos(';', S) > 0 THEN
                Delete(S, pos(';', S), 255);

            FileSetAttr(Dst + S, 0);
            FileSetAttr(Src + S, 0);

            Form1.Caption := S; Form1.Update;
            form1.Label1.Update;

            repdest := extractfilepath(Dst + S);
            IF repdest[length(repdest)] <> '\' THEN
                repdest[length(repdest)] := '\';

            forcedirectories(repdest);
            IF quoi = -1 THEN
            BEGIN // Copy ;
                IF (Uppercase(S) = 'MAJAUTO.EXE') OR
                    (Uppercase(S) = 'BPL\PQT_DELPHI.BPL') OR
                    (Uppercase(S) = 'BPL\PQT_COMM.BPL') OR
                    (Uppercase(S) = 'BPL\PQT_IBOBJETCT.BPL') THEN
                BEGIN
                    CopyFile(PChar(src + S), Pchar(Dst + S + '1'), False);
                    Form1.Arecup := True;
                END
                ELSE
                BEGIN
                    IF (copy(Uppercase(S), 1, 4) = 'EAI\') AND (Dm_Connexion.LesEai.Count > 0) THEN
                    BEGIN
                        // Cas particulier : copier dans tous les rep EAI
                        Pass := S;
                        delete(pass, 1, 4);
                        FOR IEai := 0 TO Dm_Connexion.LesEai.Count - 1 DO
                        BEGIN
                            CopyFile(PChar(src + S), Pchar(Dm_Connexion.LesEai[Ieai] + Pass), False);
                        END;
                    END
                    ELSE
                        CopyFile(PChar(src + S), Pchar(Dst + S), False);
                END;
            END
            ELSE IF quoi = 1 THEN
            BEGIN
                IF (Uppercase(S) = 'MAJAUTO.EXE') OR
                    (Uppercase(S) = 'BPL\PQT_DELPHI.BPL') OR
                    (Uppercase(S) = 'BPL\PQT_COMM.BPL') OR
                    (Uppercase(S) = 'BPL\PQT_IBOBJETCT.BPL') THEN
                BEGIN
                    IF Fileexists(Dst + S) THEN
                        traite(src + S, Dst + S, Dst + S + '1')
                    ELSE
                    BEGIN
                        form1.Log.Add('Le fichier ' + Dst + S + ' n''existe pas');
                        form1.Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                    END;
                    Form1.Arecup := True;
                END
                ELSE
                BEGIN
                    IF (copy(Uppercase(S), 1, 4) = 'EAI\') AND (Dm_Connexion.LesEai.Count > 0) THEN
                    BEGIN
                        // Cas particulier : copier dans tous les rep EAI
                        Pass := S;
                        delete(pass, 1, 4);
                        FOR IEai := 0 TO Dm_Connexion.LesEai.Count - 1 DO
                        BEGIN
                            IF Fileexists(Dm_Connexion.LesEai[Ieai] + Pass) THEN
                                traite(src + S, Dm_Connexion.LesEai[Ieai] + Pass, Dm_Connexion.LesEai[Ieai] + Pass)
                            ELSE
                            BEGIN
                                form1.Log.Add('Le fichier ' + Dm_Connexion.LesEai[Ieai] + Pass + ' n''existe pas');
                                form1.Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                            END;
                        END;
                    END
                    ELSE
                    BEGIN
                        IF Fileexists(Dst + S) THEN
                            traite(src + S, Dst + S, Dst + S)
                        ELSE
                        BEGIN
                            form1.Log.Add('Le fichier ' + Dst + S + ' n''existe pas');
                            form1.Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                        END;
                    END;
                END;
            END;
        END;
    FINALLY
        tsl.free;
    END;
END;

PROCEDURE TForm1.AjouteNoeud(Xml: TMonXML; Noeud: STRING; Place: Integer;
    Valeur: STRING);
VAR
    Actu: STRING;
    S: STRING;
    Node: IXMLDOMNode;
    ok: Boolean;
    NodeAjout: TMonXml;
    i: Integer;
BEGIN
    NodeAjout := TMonXml.Create;
    TRY
        NodeAjout.LoadXML(Valeur);
        NodeAjout.First;
        S := Noeud;
        IF Pos('/', S) > 0 THEN
        BEGIN
            Actu := Copy(S, 1, Pos('/', S) - 1);
            delete(S, 1, Pos('/', S));
        END
        ELSE
        BEGIN
            Actu := S;
            S := '';
        END;
        Xml.First;
        WHILE NOT Xml.EOF DO
        BEGIN
            IF Xml.Get_CurrentNode.Get_nodeName = Actu THEN
            BEGIN
                Node := xml.Get_CurrentNode;
                ok := true;
                WHILE (S <> '') AND ok DO
                BEGIN
                    IF Pos('/', S) > 0 THEN
                    BEGIN
                        Actu := Copy(S, 1, Pos('/', S) - 1);
                        delete(S, 1, Pos('/', S));
                    END
                    ELSE
                    BEGIN
                        Actu := S;
                        S := '';
                    END;
                    ok := false;
                    FOR i := 0 TO Node.childNodes.length - 1 DO
                    BEGIN
                        IF Node.childNodes.Item[i].Get_nodeName = Actu THEN
                        BEGIN
                            Ok := true;
                            Node := Node.childNodes.Item[i];
                            BREAK;
                        END;
                    END;
                END;
                IF ok THEN
                BEGIN
              // Mon Node contient le Noeud en question
                    IF Place <= 0 THEN
                    BEGIN
                        Node.insertBefore(NodeAjout.Get_CurrentNode, Node.childNodes.Item[0]);
                    END
                    ELSE IF Place >= Node.childNodes.Get_length THEN
                    BEGIN
                        Node.appendChild(NodeAjout.Get_CurrentNode);
                    END
                    ELSE
                    BEGIN
                        Node.insertBefore(NodeAjout.Get_CurrentNode, Node.childNodes.Item[Place - 1]);
                    END;
                END;
                BREAK;
            END;
            Xml.Next;
        END;
    FINALLY
        NodeAjout.free;
    END;
END;

FUNCTION TForm1.ChercheVal(Noeuds: IXMLDOMNodeList;
    TAG: STRING): STRING;
VAR
    i: integer;
BEGIN
    result := '';
    FOR i := 0 TO Noeuds.Get_length - 1 DO
    BEGIN
        IF Noeuds.item[i].Get_nodeName = Tag THEN
        BEGIN
            IF Noeuds.item[i].childNodes.Get_length < 1 THEN
                result := ''
            ELSE IF Noeuds.item[i].childNodes.item[0].Get_nodeValue <> Null THEN
                result := Noeuds.item[i].childNodes.item[0].Get_nodeValue;
            BREAK;
        END;
    END;
END;

FUNCTION TForm1.ChercheMinVal(Noeuds: IXMLDOMNodeList; NoeudFils: STRING; TAG: STRING): STRING;
VAR
    i: integer;
    S: STRING;
    code: Integer;
    D, d1: Double;
BEGIN
    result := '';
    FOR i := 0 TO Noeuds.Get_length - 1 DO
    BEGIN
        IF Noeuds.item[i].Get_nodeName = NoeudFils THEN
        BEGIN
            S := ChercheVal(Noeuds.item[i].childNodes, Tag);
            IF result = '' THEN
                result := S
            ELSE IF (S <> '') THEN
            BEGIN
                Val(S, D, Code);
                d1 := 0;
                IF code = 0 THEN
                    Val(result, D1, Code);
                IF code = 0 THEN
                BEGIN
                    IF d1 > d THEN
                        result := S;
                END
                ELSE
                BEGIN
                    IF (result > S) THEN
                        result := S;
                END;
            END;
        END;
    END;
END;

FUNCTION TForm1.ChercheMaxVal(Noeuds: IXMLDOMNodeList; NoeudFils: STRING;
    TAG: STRING): STRING;
VAR
    i: integer;
    S: STRING;
    d, d1: double;
    code: Integer;
BEGIN
    result := '';
    FOR i := 0 TO Noeuds.Get_length - 1 DO
    BEGIN
        IF Noeuds.item[i].Get_nodeName = NoeudFils THEN
        BEGIN
            S := ChercheVal(Noeuds.item[i].childNodes, Tag);
            IF result = '' THEN
                result := S
            ELSE IF (S <> '') THEN
            BEGIN
                Val(S, D, Code);
                d1 := 0;
                IF code = 0 THEN
                    Val(result, D1, Code);
                IF code = 0 THEN
                BEGIN
                    IF d1 < d THEN
                        result := S;
                END
                ELSE
                BEGIN
                    IF (result < S) THEN
                        result := S;
                END;
            END;
        END;
    END;
END;

{
FUNCTION TForm1.ChercheMaxValInt(Noeuds: IXMLDOMNodeList; NoeudFils: STRING; TAG: STRING): Integer;
VAR
    i: integer;
    S: STRING;
    Pass: Integer;
BEGIN
    result := -1;
    FOR i := 0 TO Noeuds.Get_length - 1 DO
    BEGIN
        IF Noeuds.item[i].Get_nodeName = NoeudFils THEN
        BEGIN
            S := ChercheVal(Noeuds.item[i].childNodes, Tag);
            IF S <> '' THEN
            BEGIN
                Pass := StrToInt(S);
                IF result = -1 THEN
                    result := Pass
                ELSE IF (result < Pass) THEN
                    result := Pass;
            END;
        END;
    END;
END;
}

PROCEDURE TForm1.RemplaceVal(Noeuds: IXMLDOMNodeList; TAG: STRING; Valeur: STRING);
VAR
    i: integer;
BEGIN
    FOR i := 0 TO Noeuds.Get_length - 1 DO
    BEGIN
        IF Noeuds.item[i].Get_nodeName = Tag THEN
        BEGIN
            IF Noeuds.item[i].childNodes.Get_length = 0 THEN
                Noeuds.item[i].Set_text(Valeur)
            ELSE
                Noeuds.item[i].childNodes.item[0].Set_nodeValue(Valeur);
            BREAK;
        END;
    END;
END;

{
PROCEDURE TForm1.RemplaceVals(Noeuds: IXMLDOMNodeList; NoeudFils: STRING; TAG, Valeur: STRING);
VAR
    i: integer;
BEGIN
    FOR i := 0 TO Noeuds.Get_length - 1 DO
    BEGIN
        IF Noeuds.item[i].Get_nodeName = NoeudFils THEN
        BEGIN
            RemplaceVal(Noeuds.item[i].childNodes, Tag, Valeur);
        END;
    END;
END;
}

FUNCTION TForm1.Existe(Noeuds: IXMLDOMNodeList; TAG,
    Valeur: STRING): Boolean;
VAR
    i: integer;
BEGIN
    result := false;
    FOR i := 0 TO Noeuds.Get_length - 1 DO
    BEGIN
        IF Noeuds.item[i].Get_nodeName = Tag THEN
        BEGIN
            IF Noeuds.item[i].childNodes.item[0].Get_nodeValue = Valeur THEN
                result := true;
            BREAK;
        END;
    END;
END;

FUNCTION TForm1.Existes(Noeuds: IXMLDOMNodeList; NoeudFils: STRING; TAG, Valeur: STRING): Integer;
VAR
    i: integer;
BEGIN
    result := -1;
    FOR i := 0 TO Noeuds.Get_length - 1 DO
    BEGIN
        IF Noeuds.item[i].Get_nodeName = NoeudFils THEN
        BEGIN
            IF Existe(Noeuds.item[i].childNodes, Tag, Valeur) THEN
            BEGIN
                result := I + 1;
                BREAK;
            END;
        END;
    END;
END;

FUNCTION TForm1.Traitement_BATCH(LeFichier: STRING): Boolean;
VAR
    PassTsl: TstringList;
    Tsl: TstringList;
    LesVar: TstringList;
    LesVal: TstringList;
    LaPille: TstringList;
    Ordre: STRING;
    MarqueurEai: Integer;
    EaiEnCours: Integer;
    XML: TMonXML;
//    Path: STRING;
    PathOrdre: STRING;
    PathEAI: STRING;
    i: Integer;
    S: STRING;
    LeTemps: Dword;
    Temps: Dword;
    timeout: Boolean;

    NoeudsEnCours: IXMLDOMNodeList;
    NoeudConcerne: STRING;
    ValeurEnCours: Integer;
    MarqueurNoeuds: Integer;

    FUNCTION LeTimeOut: boolean;
    BEGIN
        result := false;
        IF timeout THEN
        BEGIN
            IF GetTickCount > LeTemps THEN
            BEGIN
                result := true;
            END;
        END;
    END;

    FUNCTION remplacer(S: STRING; Cherche: STRING; Valeur: STRING): STRING;
    VAR
        j: Integer;
    BEGIN
        WHILE Pos(Cherche, S) > 0 DO
        BEGIN
            j := Pos(Cherche, S);
            IF j > 0 THEN
            BEGIN
                delete(S, j, length(cherche));
                Insert(valeur, S, J);
            END;
        END;
        result := S;
    END;

    FUNCTION Traite(S: STRING): STRING;
    VAR
        i: integer;
    BEGIN
        S := remplacer(S, '[GINKOIA]', Path);
        S := remplacer(S, '[ACTUEL]', PathOrdre);
        S := remplacer(S, '[EAI]', PathEAI);
        FOR i := 0 TO lesVar.count - 1 DO
        BEGIN
            S := remplacer(S, lesVar[i], LesVal[i]);
        END;
        result := s;
    END;

    FUNCTION PositionsurNoeuds(Placedunoeud: STRING): IXMLDOMNodeList;
    VAR
        i: Integer;
        ok: Boolean;
        SousNoeud: STRING;
    BEGIN
        Xml.First;
        result := Xml.Get_CurrentNodeList;
        WHILE (Placedunoeud <> '') DO
        BEGIN
            IF Pos('/', Placedunoeud) > 0 THEN
            BEGIN
                SousNoeud := Copy(Placedunoeud, 1, Pos('/', Placedunoeud) - 1);
                delete(Placedunoeud, 1, Pos('/', Placedunoeud));
            END
            ELSE
            BEGIN
                SousNoeud := Placedunoeud;
                Placedunoeud := '';
            END;
            i := 0;
            Ok := false;
            WHILE i < result.Get_length DO
            BEGIN
                IF result.Item[i].Get_nodeName = SousNoeud THEN
                BEGIN
                    result := result.Item[i].Get_childNodes;
                    ok := true;
                    BREAK;
                END;
                Inc(i);
            END;
            IF NOT ok THEN
            BEGIN
                Result := NIL;
                BREAK;
            END;
        END;
    END;

    FUNCTION TraiteVal(S: STRING): STRING;

    VAR
        Ordre: STRING;
        SSOrdre: STRING;
        PlaceduNoeud: STRING;
        Noeuds: IXMLDOMNodeList;
        NoeudFils: STRING;
        TAG: STRING;
        Place: STRING;
        reg: tregistry;
        Var1: STRING;
    BEGIN
        result := '';
        IF pos('=', S) > 0 THEN
        BEGIN
            Ordre := Copy(S, 1, pos('=', S) - 1);
            delete(S, 1, pos('=', S));
            IF Ordre = 'REGLIT' THEN
            BEGIN
                SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
                delete(S, 1, pos(';', S));
                reg := tregistry.Create(Key_READ);
                TRY
                    Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
                    delete(SSOrdre, 1, pos('\', SSOrdre));
                    IF Var1 = 'HKEY_LOCAL_MACHINE\' THEN
                        reg.RootKey := HKEY_LOCAL_MACHINE
                    ELSE IF Var1 = 'HKEY_CLASSES_ROOT\' THEN
                        reg.RootKey := HKEY_CLASSES_ROOT
                    ELSE IF Var1 = 'HKEY_CURRENT_USER\' THEN
                        reg.RootKey := HKEY_CURRENT_USER
                    ELSE IF Var1 = 'HKEY_USERS\' THEN
                        reg.RootKey := HKEY_USERS
                    ELSE IF Var1 = 'HKEY_CURRENT_CONFIG\' THEN
                        reg.RootKey := HKEY_CURRENT_CONFIG;
                    IF reg.OpenKey(SSOrdre, True) THEN
                    BEGIN
                        S := traite(S);
                        result := reg.ReadString(S);
                        reg.closeKey;
                    END;
                FINALLY
                    reg.free;
                END;
            END
            ELSE IF Ordre = 'POS' THEN
            BEGIN
                SSOrdre := Copy(S, 1, Pos(';', S) - 1);
                delete(S, 1, Pos(';', S));
                S := traite(S);
                SSOrdre := traite(SSOrdre);
                result := Inttostr(Pos(SSOrdre, S));
            END
            ELSE IF Ordre = 'ADD' THEN
            BEGIN
                SSOrdre := Copy(S, 1, Pos(';', S) - 1);
                delete(S, 1, Pos(';', S));
                S := traite(S);
                SSOrdre := traite(SSOrdre);
                result := Inttostr(StrToInt(S) + StrToInt(SSOrdre));
            END
            ELSE IF Ordre = 'COPY' THEN
            BEGIN
                SSOrdre := Copy(S, 1, Pos(';', S) - 1);
                delete(S, 1, Pos(';', S));
                Place := Copy(S, 1, Pos(';', S) - 1);
                delete(S, 1, Pos(';', S));
                SSOrdre := traite(SSOrdre);
                S := Traite(S);
                Place := traite(Place);
                result := Copy(SSOrdre, StrToInt(Place), StrToInt(s));
            END
            ELSE IF Ordre = 'DELETE' THEN
            BEGIN
                SSOrdre := Copy(S, 1, Pos(';', S) - 1);
                delete(S, 1, Pos(';', S));
                Place := Copy(S, 1, Pos(';', S) - 1);
                delete(S, 1, Pos(';', S));
                SSOrdre := traite(SSOrdre);
                Place := traite(Place);
                S := Traite(S);
                Delete(SSOrdre, StrToInt(Place), StrToInt(s));
                result := SSOrdre;
            END
            ELSE IF Ordre = 'CONCAT' THEN
            BEGIN
                SSOrdre := Copy(S, 1, Pos(';', S) - 1);
                delete(S, 1, Pos(';', S));
                SSOrdre := traite(SSOrdre);
                S := Traite(S);
                result := SSOrdre + S;
            END
            ELSE IF Ordre = 'XML' THEN
            BEGIN
                Xml.First;
                SSOrdre := Copy(S, 1, Pos(';', S) - 1);
                delete(S, 1, Pos(';', S));
                IF SSOrdre = 'GETVALEUR' THEN
                BEGIN
                    result := ChercheVal(NoeudsEnCours.item[ValeurEnCours].Get_childNodes, S);
                END
                ELSE IF SSOrdre = 'EXISTES' THEN
                BEGIN
                    Placedunoeud := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                    Noeuds := PositionsurNoeuds(Placedunoeud);
                    IF Noeuds <> NIL THEN
                    BEGIN
                        NoeudFils := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                        TAG := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                        result := Inttostr(Existes(Noeuds, NoeudFils, Tag, Traite(S)));
                    END;
                END
                ELSE IF SSOrdre = 'MINVALUE' THEN
                BEGIN
                    Placedunoeud := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                    Noeuds := PositionsurNoeuds(Placedunoeud);
                    IF Noeuds <> NIL THEN
                    BEGIN
                        NoeudFils := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                        result := ChercheMinVal(Noeuds, NoeudFils, S);
                    END;
                END
                ELSE IF SSOrdre = 'MAXVALUE' THEN
                BEGIN
                    Placedunoeud := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                    Noeuds := PositionsurNoeuds(Placedunoeud);
                    IF Noeuds <> NIL THEN
                    BEGIN
                        NoeudFils := Copy(S, 1, Pos(';', S) - 1); delete(S, 1, Pos(';', S));
                        result := ChercheMaxVal(Noeuds, NoeudFils, S);
                    END;
                END;
            END;
        END
        ELSE
            result := S;
    END;

    FUNCTION TraiteOrdre(Ordre: STRING; Valeur: STRING; I: Integer): Integer;
    VAR
        s: STRING;
        SSOrdre: STRING;
        j: Integer;
        Noeud: STRING;
        Place: Integer;
        Var1: STRING;
        Var2: STRING;

        MonPathExtract: STRING;

        reg: tregistry;
    BEGIN
        IF (ordre <> '') AND (Ordre[1] <> ';') THEN
        BEGIN
            S := Valeur;
            IF ORDRE = 'REGADD' THEN
            BEGIN
                SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
                delete(S, 1, pos(';', S));
                reg := tregistry.Create(Key_ALL_ACCESS);
                TRY
                    Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
                    delete(SSOrdre, 1, pos('\', SSOrdre));
                    IF Var1 = 'HKEY_LOCAL_MACHINE\' THEN
                        reg.RootKey := HKEY_LOCAL_MACHINE
                    ELSE IF Var1 = 'HKEY_CLASSES_ROOT\' THEN
                        reg.RootKey := HKEY_CLASSES_ROOT
                    ELSE IF Var1 = 'HKEY_CURRENT_USER\' THEN
                        reg.RootKey := HKEY_CURRENT_USER
                    ELSE IF Var1 = 'HKEY_USERS\' THEN
                        reg.RootKey := HKEY_USERS
                    ELSE IF Var1 = 'HKEY_CURRENT_CONFIG\' THEN
                        reg.RootKey := HKEY_CURRENT_CONFIG;
                    IF reg.OpenKey(SSOrdre, True) THEN
                    BEGIN
                        SSOrdre := traite(Copy(S, 1, Pos(';', S) - 1));
                        delete(S, 1, pos(';', S));
                        S := traite(S);
                        reg.WriteString(SSOrdre, S);
                        reg.closeKey;
                    END;
                FINALLY
                    reg.free;
                END;
                inc(i);
            END
            ELSE IF ORDRE = 'REGSUP' THEN
            BEGIN
                SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
                delete(S, 1, pos(';', S));
                reg := tregistry.Create(Key_ALL_ACCESS);
                TRY
                    Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
                    delete(SSOrdre, 1, pos('\', SSOrdre));
                    IF Var1 = 'HKEY_LOCAL_MACHINE\' THEN
                        reg.RootKey := HKEY_LOCAL_MACHINE
                    ELSE IF Var1 = 'HKEY_CLASSES_ROOT\' THEN
                        reg.RootKey := HKEY_CLASSES_ROOT
                    ELSE IF Var1 = 'HKEY_CURRENT_USER\' THEN
                        reg.RootKey := HKEY_CURRENT_USER
                    ELSE IF Var1 = 'HKEY_USERS\' THEN
                        reg.RootKey := HKEY_USERS
                    ELSE IF Var1 = 'HKEY_CURRENT_CONFIG\' THEN
                        reg.RootKey := HKEY_CURRENT_CONFIG;
                    IF reg.OpenKey(SSOrdre, True) THEN
                    BEGIN
                        S := traite(S);
                        reg.DeleteValue(S);
                        reg.closeKey;
                    END;
                FINALLY
                    reg.free;
                END;
                inc(i);
            END
            ELSE IF ORDRE = 'REGSUPCLEF' THEN
            BEGIN
                SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
                delete(S, 1, pos(';', S));
                reg := tregistry.Create(Key_ALL_ACCESS);
                TRY
                    Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
                    delete(SSOrdre, 1, pos('\', SSOrdre));
                    IF Var1 = 'HKEY_LOCAL_MACHINE\' THEN
                        reg.RootKey := HKEY_LOCAL_MACHINE
                    ELSE IF Var1 = 'HKEY_CLASSES_ROOT\' THEN
                        reg.RootKey := HKEY_CLASSES_ROOT
                    ELSE IF Var1 = 'HKEY_CURRENT_USER\' THEN
                        reg.RootKey := HKEY_CURRENT_USER
                    ELSE IF Var1 = 'HKEY_USERS\' THEN
                        reg.RootKey := HKEY_USERS
                    ELSE IF Var1 = 'HKEY_CURRENT_CONFIG\' THEN
                        reg.RootKey := HKEY_CURRENT_CONFIG;
                    S := traite(S);
                    reg.DeleteKey(S);
                FINALLY
                    reg.free;
                END;
                inc(i);
            END
            ELSE IF ORDRE = 'SUPDIR' THEN
            BEGIN
                S := traite(S);
                Detruit(S);
                inc(i);
            END
            ELSE IF ORDRE = 'UNZIP' THEN
            BEGIN
                S := traite(S);
                Unzip.ZipName := S;
                MonPathExtract := S;
                WHILE pos('\', MonPathExtract) > 0 DO
                    delete(MonPathExtract, 1, pos('\', MonPathExtract));
                MonPathExtract := Path + 'LiveUpdate\' + ChangeFileExt(MonPathExtract, '') + '\';
                Unzip.DestDir := MonPathExtract;
                Unzip.unzip;
                inc(i);
            END
            ELSE IF ORDRE = 'COMMANDE' THEN
            BEGIN
                S := traite(S);
                IF Fileexists(S) THEN
                BEGIN
                    IF NOT Traitement_BATCH(S) THEN
                    BEGIN
                        result := 99999;
                        EXIT;
                    END;
                END;
                inc(i);
            END
            ELSE IF Ordre = 'CALL' THEN
            BEGIN
                J := 0;
                WHILE (j < tsl.count) AND (tsl[j] <> 'BCL=' + S) DO
                    Inc(j);
                IF j < tsl.count THEN
                BEGIN
                    LaPille.Add(Inttostr(i));
                    i := J;
                END;
            END
            ELSE IF Ordre = 'RETURN' THEN
            BEGIN
                IF LaPille.count > 0 THEN
                BEGIN
                    S := LaPille[LaPille.Count - 1];
                    LaPille.Delete(LaPille.Count - 1);
                    I := StrToInt(S);
                END;
                inc(i);
            END
            ELSE IF ordre = 'TOUT_NOEUD' THEN
            BEGIN
                IF S = 'END' THEN
                BEGIN
                    IF NoeudsEnCours <> NIL THEN
                    BEGIN
                        inc(ValeurEnCours);
                        WHILE (ValeurEnCours < NoeudsEnCours.Get_length) AND
                            (NoeudsEnCours.item[ValeurEnCours].Get_nodeName <> NoeudConcerne) DO
                            inc(ValeurEnCours);
                        IF ValeurEnCours >= NoeudsEnCours.Get_length THEN
                            NoeudsEnCours := NIL;
                        IF NoeudsEnCours <> NIL THEN
                        BEGIN
                            i := MarqueurNoeuds;
                        END;
                    END;
                    Inc(i);
                END
                ELSE
                BEGIN
                    SSOrdre := Copy(S, 1, Pos(';', S) - 1);
                    delete(S, 1, pos(';', S));
                    NoeudsEnCours := PositionsurNoeuds(SSOrdre);
                    NoeudConcerne := S;
                    MarqueurNoeuds := i;
                    IF NoeudsEnCours <> NIL THEN
                    BEGIN
                        ValeurEnCours := 0;
                        WHILE (ValeurEnCours < NoeudsEnCours.Get_length) AND
                            (NoeudsEnCours.item[ValeurEnCours].Get_nodeName <> NoeudConcerne) DO
                            inc(ValeurEnCours);
                        IF ValeurEnCours >= NoeudsEnCours.Get_length THEN
                            NoeudsEnCours := NIL;
                    END;
                    IF NoeudsEnCours = NIL THEN
                    BEGIN
                        WHILE tsl[i] <> 'TOUT_NOEUD=END' DO
                            Inc(i);
                    END;
                    inc(i);
                END;
            END
            ELSE IF ordre = 'RENAME' THEN
            BEGIN
                SSOrdre := Copy(S, 1, Pos(';', S) - 1);
                delete(S, 1, pos(';', S));
                S := traite(S);
                SSOrdre := traite(SSOrdre);
                RenameFile(SSOrdre, S);
                Inc(i);
            END
            ELSE IF ORDRE = 'SCRIPT' THEN
            BEGIN
                S := Traite(S);
                IbScript.Sql.Loadfromfile(S);
                IF NOT tran.InTransaction THEN
                    tran.StartTransaction;
                IbScript.Execute;
                IF tran.InTransaction THEN
                    tran.commit;
                Inc(i);
            END
            ELSE IF ORDRE = 'EXECUTE' THEN
            BEGIN
                S := Traite(S);
                Winexec(PChar(S), 0);
                inc(i);
            END
            ELSE IF ORDRE = 'STOP' THEN
            BEGIN
                Lapplication := S;
                EnumWindows(@Enumerate, 0);
                Lapplication := S;
                EnumWindows(@Enumerate, 0);
                inc(i);
            END
            ELSE IF ORDRE = 'TIMEOUT' THEN
            BEGIN
                timeout := true;
                temps := StrToInt(S);
                inc(i);
            END
            ELSE IF ORDRE = 'STOPTIMEOUT' THEN
            BEGIN
                timeout := False;
                inc(i);
            END
            ELSE IF ORDRE = 'DELAY' THEN
            BEGIN
                LeTemps := StrToInt(S);
                LeTemps := GetTickCount + LeTemps;
                WHILE GetTickCount < LeTemps DO
                BEGIN
                    Sleep(1000);
                    Application.processMessages;
                END;
                inc(i);
            END
            ELSE IF ORDRE = 'SUPPRIME' THEN
            BEGIN
                S := traite(S);
                FileSetAttr(Pchar(S), 0);
                DeleteFile(S);
                Inc(i);
            END
            ELSE IF ORDRE = 'ATTENTE' THEN
            BEGIN
                SSOrdre := Copy(S, 1, Pos('=', S) - 1);
                delete(S, 1, pos('=', S));
                IF SSOrdre = 'FIN' THEN
                BEGIN
                    LeTemps := GetTickCount + Temps;
                    REPEAT
                        Ok := False;
                        Lapplication := uppercase(S);
                        EnumWindows(@Enumerate2, 0);
                        IF LeTimeOut THEN
                        BEGIN
                            result := 99999;
                            EXIT;
                        END;
                    UNTIL NOT (ok);
                END
                ELSE IF SSOrdre = 'DEBUT' THEN
                BEGIN
                    LeTemps := GetTickCount + Temps;
                    REPEAT
                        Ok := False;
                        Lapplication := uppercase(S);
                        EnumWindows(@Enumerate2, 0);
                        IF LeTimeOut THEN
                        BEGIN
                            result := 99999;
                            EXIT;
                        END;
                    UNTIL ok;
                END
                ELSE IF SSOrdre = 'FILEEXISTS' THEN
                BEGIN
                    S := traite(S);
                    LeTemps := GetTickCount + Temps;
                    WHILE NOT Fileexists(S) DO
                    BEGIN
                        sleep(1000);
                        IF LeTimeOut THEN
                        BEGIN
                            result := 99999;
                            EXIT;
                        END;
                    END;
                END
                ELSE IF SSOrdre = 'MAPSTART' THEN
                BEGIN
                    S := uppercase(s);
                    IF S = 'GINKOIA' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.Ginkoia DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'CAISSE' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.Caisse DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'LAUNCHER' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.Launcher DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'BACKUP' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.Backup DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'LIVEUPDATE' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.LiveUpdate DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'MAJAUTO' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.MajAuto DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'PARAMGINKOIA' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.ParamGinkoia DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'PING' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.Ping DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'PINGSTOP' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.PingStop DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'SCRIPT' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.Script DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'SCRIPTOK' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.ScriptOK DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END;
                END
                ELSE IF SSOrdre = 'MAPSTOP' THEN
                BEGIN
                    S := uppercase(s);
                    IF S = 'GINKOIA' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.Ginkoia DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'CAISSE' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.Caisse DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'LAUNCHER' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.Launcher DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'BACKUP' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.Backup DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'LIVEUPDATE' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.LiveUpdate DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'MAJAUTO' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.MajAuto DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'PARAMGINKOIA' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.ParamGinkoia DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'PING' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.Ping DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'PINGSTOP' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.PingStop DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'SCRIPT' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.Script DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'SCRIPTOK' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.ScriptOK DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := 99999;
                                EXIT;
                            END;
                        END;
                    END;
                END;
                Inc(i);
            END
            ELSE IF Ordre = 'TOUT_EAI' THEN
            BEGIN
                ssOrdre := S;
                IF ssOrdre = 'BEGIN' THEN
                BEGIN
                    MarqueurEai := i;
                    EaiEnCours := 0;
                    PathEAI := Dm_Connexion.LesEai[EaiEnCours];
                END
                ELSE IF ssOrdre = 'END' THEN
                BEGIN
                    inc(EaiEnCours);
                    IF EaiEnCours < Dm_Connexion.LesEai.Count THEN
                    BEGIN
                        PathEAI := Dm_Connexion.LesEai[EaiEnCours];
                        i := MarqueurEai;
                    END;
                END;
                inc(i);
            END
            ELSE IF ordre = 'XML' THEN
            BEGIN
                ssOrdre := Copy(S, 1, Pos(';', S) - 1);
                delete(S, 1, Pos(';', S));
                IF ssOrdre = 'SETVALEUR' THEN
                BEGIN
                    Noeud := Copy(S, 1, Pos(';', S) - 1);
                    delete(S, 1, Pos(';', S));
                    Noeud := traite(Noeud);
                    S := traite(S);
                    RemplaceVal(NoeudsEnCours.item[ValeurEnCours].Get_childNodes, Noeud, S);
                END
                ELSE IF ssOrdre = 'LOAD' THEN
                BEGIN
                    PassTsl := TstringList.Create;
                    Log.Add('Load XML ' + Traite(S)); Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                    PassTsl.loadFromFile(Traite(S));
                    Log.Add('Parsing de ' + Traite(S)); Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                    Xml.LoadXML(PassTsl.Text);
                    Log.Add('Parsing OK '); Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                    NoeudsEnCours := XML.Get_CurrentNodeList;
                END
                ELSE IF ssOrdre = 'SAVE' THEN
                BEGIN
                    xml.Save(traite(s));
                END
                ELSE IF ssOrdre = 'ADD' THEN
                BEGIN
                    Xml.First;
                    Noeud := Copy(S, 1, Pos(';', S) - 1);
                    delete(S, 1, Pos(';', S));
                    Place := StrtoInt(Traite(Copy(S, 1, Pos(';', S) - 1)));
                    delete(S, 1, Pos(';', S));
                    S := Traite(S);
                    AjouteNoeud(Xml, Noeud, Place, S);
                END;
                inc(i)
            END
            ELSE IF ordre = 'GOTO' THEN
            BEGIN
                j := 0;
                WHILE j < tsl.count DO
                BEGIN
                    IF Uppercase(tsl.Names[j]) = 'BCL' THEN
                    BEGIN
                        SSOrdre := Copy(tsl[j], Pos('=', tsl[j]) + 1, Length(tsl[j]));
                        IF SSOrdre = S THEN
                        BEGIN
                            I := J;
                            BREAK;
                        END;
                    END;
                    Inc(j);
                END;
                Inc(i);
            END
            ELSE IF Copy(Ordre, 1, 2) = '$$' THEN
            BEGIN
              // Variable ;
                j := LesVar.IndexOf(Ordre);
                IF j = -1 THEN
                BEGIN
                    J := LesVar.Add(Ordre);
                    LesVal.Add('');
                END;
                LesVal[j] := TraiteVal(S);
                Inc(i);
            END
            ELSE IF Ordre = 'SI' THEN
            BEGIN
                SSOrdre := Copy(S, 1, Pos(')', S));
                Delete(S, 1, Pos(')', S));
                Delete(S, 1, Pos(';', S));
                IF Copy(SSOrdre, 1, Pos('(', SSOrdre)) = 'DIFF(' THEN
                BEGIN
                    delete(SSOrdre, 1, Pos('(', SSOrdre));
                    Var1 := Copy(SSOrdre, 1, Pos(';', SSOrdre) - 1);
                    delete(SSOrdre, 1, Pos(';', SSOrdre));
                    Var2 := Copy(SSOrdre, 1, Pos(')', SSOrdre) - 1);
                    IF Copy(var1, 1, 2) = '$$' THEN
                        Var1 := Traite(Var1);
                    IF Copy(var2, 1, 2) = '$$' THEN
                        Var2 := Traite(Var1);
                    IF Var1 <> var2 THEN
                    BEGIN
                        Ordre := Copy(S, 1, pos('=', S) - 1);
                        delete(S, 1, Pos('=', S));
                        I := TraiteOrdre(Ordre, S, i);
                    END
                    ELSE
                        Inc(i);
                END
                ELSE IF Copy(SSOrdre, 1, Pos('(', SSOrdre)) = 'EGAL(' THEN
                BEGIN
                    delete(SSOrdre, 1, Pos('(', SSOrdre));
                    Var1 := Copy(SSOrdre, 1, Pos(';', SSOrdre) - 1);
                    delete(SSOrdre, 1, Pos(';', SSOrdre));
                    Var2 := Copy(SSOrdre, 1, Pos(')', SSOrdre) - 1);
                    IF Copy(var1, 1, 2) = '$$' THEN
                        Var1 := Traite(Var1);
                    IF Copy(var2, 1, 2) = '$$' THEN
                        Var2 := Traite(Var1);
                    IF Var1 = var2 THEN
                    BEGIN
                        Ordre := Copy(S, 1, pos('=', S) - 1);
                        delete(S, 1, Pos('=', S));
                        I := TraiteOrdre(Ordre, S, i);
                    END
                    ELSE
                        Inc(i);
                END;
            END
            ELSE
            BEGIN
                inc(i);
            END;
        END
        ELSE
            inc(i);
        result := i;
    END;

BEGIN
    Tsl := TstringList.Create;
    LesVar := TstringList.Create;
    LesVal := TstringList.Create;
    LaPille := TstringList.Create;
    XML := TMonXML.Create;

    Log.Add('Ouverture de ' + LeFichier); Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
    tsl.LoadFromFile(LeFichier);
    i := 0;
    TimeOut := false;
    PathOrdre := IncludeTrailingBackslash(ExtractFilePath(LeFichier));
    Temps := 0;

    MarqueurEai := -1;
    MarqueurNoeuds := -1;
    Caption := 'MAJ ' + Inttostr(i + 1) + '/' + Inttostr(tsl.count);
    WHILE i < tsl.count DO
    BEGIN
        Ordre := Uppercase(trim(tsl.Names[i]));
        Log.Add('Execute ' + tsl[i]); Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
        Caption := 'MAJ ' + Inttostr(i + 1) + '/' + Inttostr(tsl.count);
        S := trim(Copy(tsl[i], Pos('=', tsl[i]) + 1, Length(tsl[i])));
        i := TraiteOrdre(Ordre, S, i);
    END;
    Log.Add('Fin du fichier '); Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
    result := i <> 99999;
    XML.free;
    LesVar.free;
    LesVal.free;
    Tsl.free;
    LaPille.free;
END;

{
VAR
    tsl: TstringList;
    j: integer;
    i: Integer;
    PathOrdre: STRING;
    S: STRING;
    S1: STRING;
    TimeOut: Boolean;
    LeTemps: Dword;
    Temps: Dword;

    FUNCTION LeTimeOut: boolean;
    BEGIN
        result := false;
        IF timeout THEN
        BEGIN
            IF GetTickCount > LeTemps THEN
            BEGIN
                result := true;
            END;
        END;
    END;

BEGIN
    tsl := TstringList.Create;
    TRY
        tsl.loadfromfile(Ordre);
        PathOrdre := IncludeTrailingBackslash(ExtractFilePath(Ordre));
        TimeOut := false;
        Temps := 0;
        result := true;
        FOR i := 0 TO tsl.count - 1 DO
        BEGIN
            tsl[i] := trim(tsl[i]);
            IF Uppercase(tsl.Names[i]) = 'RENAME' THEN
            BEGIN
                S := Copy(tsl[i], Pos('=', tsl[i]) + 1, 600);
                WHILE Pos('[GINKOIA]', S) > 0 DO
                BEGIN
                    j := Pos('[GINKOIA]', S);
                    IF j > 0 THEN
                    BEGIN
                        delete(S, j, 9);
                        Insert(Path, S, J);
                    END;
                END;
                WHILE Pos('[ACTUEL]', S) > 0 DO
                BEGIN
                    j := Pos('[ACTUEL]', S);
                    IF j > 0 THEN
                    BEGIN
                        delete(S, j, 8);
                        Insert(PathOrdre, S, J);
                    END;
                END;
                S1 := Copy(S, 1, Pos(';', S) - 1);
                delete(S, 1, Pos(';', S));
                RenameFile(S1, S);
            END
            ELSE IF Uppercase(tsl.Names[i]) = 'SCRIPT' THEN
            BEGIN
                S := Copy(tsl[i], Pos('=', tsl[i]) + 1, 600);
                j := Pos('[GINKOIA]', S);
                IF j > 0 THEN
                BEGIN
                    delete(S, j, 9);
                    Insert(Path, S, J);
                END;
                j := Pos('[ACTUEL]', S);
                IF j > 0 THEN
                BEGIN
                    delete(S, j, 8);
                    Insert(PathOrdre, S, J);
                END;
                IbScript.Sql.Loadfromfile(S);
                IF NOT tran.InTransaction THEN
                    tran.StartTransaction;
                IbScript.Execute;
                IF tran.InTransaction THEN
                    tran.commit;
            END
            ELSE IF Uppercase(tsl.Names[i]) = 'EXECUTE' THEN
            BEGIN
                S := Copy(tsl[i], Pos('=', tsl[i]) + 1, 600);
                j := Pos('[GINKOIA]', S);
                IF j > 0 THEN
                BEGIN
                    delete(S, j, 9);
                    Insert(Path, S, J);
                END;
                j := Pos('[ACTUEL]', S);
                IF j > 0 THEN
                BEGIN
                    delete(S, j, 8);
                    Insert(PathOrdre, S, J);
                END;
                Winexec(PChar(S), 0);
            END
            ELSE IF Uppercase(tsl.Names[i]) = 'STOP' THEN
            BEGIN
                S := Copy(tsl[i], Pos('=', tsl[i]) + 1, 600);
                Lapplication := S;
                EnumWindows(@Enumerate, 0);
                Lapplication := S;
                EnumWindows(@Enumerate, 0);
            END
            ELSE IF Uppercase(tsl.Names[i]) = 'TIMEOUT' THEN
            BEGIN
                S := Copy(tsl[i], Pos('=', tsl[i]) + 1, 600);
                timeout := true;
                temps := StrToInt(S);
            END
            ELSE IF Uppercase(tsl.Names[i]) = 'STOPTIMEOUT' THEN
            BEGIN
                timeout := False;
            END
            ELSE IF Uppercase(tsl.Names[i]) = 'DELAY' THEN
            BEGIN
                S := Copy(tsl[i], Pos('=', tsl[i]) + 1, 600);
                LeTemps := StrToInt(S);
                LeTemps := GetTickCount + LeTemps;
                WHILE GetTickCount < LeTemps DO
                BEGIN
                    Sleep(1000);
                    Application.processMessages;
                END;
            END
            ELSE IF Uppercase(tsl.Names[i]) = 'SUPPRIME' THEN
            BEGIN
                S := Copy(tsl[i], Pos('=', tsl[i]) + 1, 600);
                j := Pos('[GINKOIA]', S);
                IF j > 0 THEN
                BEGIN
                    delete(S, j, 9);
                    Insert(Path, S, J);
                END;
                j := Pos('[ACTUEL]', S);
                IF j > 0 THEN
                BEGIN
                    delete(S, j, 8);
                    Insert(PathOrdre, S, J);
                END;
                FileSetAttr(Pchar(S), 0);
                DeleteFile(S);
            END
            ELSE IF Uppercase(tsl.Names[i]) = 'ATTENTE' THEN
            BEGIN
                S := Copy(tsl[i], Pos('=', tsl[i]) + 1, 600);
                S1 := Uppercase(Copy(S, 1, Pos('=', S) - 1));
                delete(S, 1, Pos('=', S));
                IF S1 = 'FIN' THEN
                BEGIN
                    LeTemps := GetTickCount + Temps;
                    REPEAT
                        Ok := False;
                        Lapplication := uppercase(S);
                        EnumWindows(@Enumerate2, 0);
                        IF LeTimeOut THEN
                        BEGIN
                            result := false;
                            EXIT;
                        END;
                    UNTIL NOT (ok);
                END
                ELSE IF S1 = 'DEBUT' THEN
                BEGIN
                    LeTemps := GetTickCount + Temps;
                    REPEAT
                        Ok := False;
                        Lapplication := uppercase(S);
                        EnumWindows(@Enumerate2, 0);
                        IF LeTimeOut THEN
                        BEGIN
                            result := false;
                            EXIT;
                        END;
                    UNTIL ok;
                END
                ELSE IF S1 = 'FILEEXISTS' THEN
                BEGIN
                    j := Pos('[GINKOIA]', S);
                    IF j > 0 THEN
                    BEGIN
                        delete(S, j, 9);
                        Insert(Path, S, J);
                    END;
                    j := Pos('[ACTUEL]', S);
                    IF j > 0 THEN
                    BEGIN
                        delete(S, j, 8);
                        Insert(PathOrdre, S, J);
                    END;
                    LeTemps := GetTickCount + Temps;
                    WHILE NOT Fileexists(S) DO
                    BEGIN
                        sleep(1000);
                        IF LeTimeOut THEN
                        BEGIN
                            result := false;
                            EXIT;
                        END;
                    END;
                END
                ELSE IF S1 = 'MAPSTART' THEN
                BEGIN
                    S := uppercase(s);
                    IF S = 'GINKOIA' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.Ginkoia DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'CAISSE' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.Caisse DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'LAUNCHER' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.Launcher DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'BACKUP' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.Backup DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'LIVEUPDATE' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.LiveUpdate DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'MAJAUTO' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.MajAuto DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'PARAMGINKOIA' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.ParamGinkoia DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'PING' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.Ping DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'PINGSTOP' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.PingStop DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'SCRIPT' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.Script DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'SCRIPTOK' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE NOT MapGinkoia.ScriptOK DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END;
                END
                ELSE IF S1 = 'MAPSTOP' THEN
                BEGIN
                    S := uppercase(s);
                    IF S = 'GINKOIA' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.Ginkoia DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'CAISSE' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.Caisse DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'LAUNCHER' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.Launcher DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'BACKUP' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.Backup DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'LIVEUPDATE' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.LiveUpdate DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'MAJAUTO' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.MajAuto DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'PARAMGINKOIA' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.ParamGinkoia DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'PING' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.Ping DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'PINGSTOP' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.PingStop DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'SCRIPT' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.Script DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END
                    ELSE IF S = 'SCRIPTOK' THEN
                    BEGIN
                        LeTemps := GetTickCount + Temps;
                        WHILE MapGinkoia.ScriptOK DO
                        BEGIN
                            sleep(1000);
                            IF LeTimeOut THEN
                            BEGIN
                                result := false;
                                EXIT;
                            END;
                        END;
                    END;
                END;
            END
        END;
    FINALLY
        tsl.free;
    END;
END;
}

PROCEDURE TForm1.Traitement;
VAR
    Lheure: TDateTime;
    // s1: STRING;
    Pass: STRING;
    s: STRING;
    _tsl: tstringlist;
    ttsl: tstringlist;
    Tsl: TstringList;
    j: integer;
    i: integer;
    MAJVERSION: Boolean;
    LaDate: STRING;
    AAjouter: STRING;
    ttps: dword;
    hhh, mmm, sss, mss: Word;
    MaDateMaj: Tdatetime;

    MonPathExtract: STRING;
BEGIN
    Log.Add('Début de la MAJ'); Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
    IF NOT fileexists(Path + 'Script.scr') THEN
    BEGIN
        Log.Add('Problème Pas de script.scr !!! ');
        Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
        EXIT;
    END;
    MAJVERSION := false;
    TRY
        Tsl := TstringList.Create;
        TRY
            tsl.loadfromFile(Path + 'LiveUpdate\AFaire.txt');
        EXCEPT
        END;

        FOR i := 0 TO tsl.count - 1 DO
        BEGIN
            S := trim(tsl[i]);
            IF copy(S, 1, pos(';', S)) = 'MAJ;' THEN
            BEGIN
                IF FileExists(Path + 'LiveUpdate\ALGOL.ALG') THEN
                BEGIN
                    filesetattr(Path + 'LiveUpdate\ALGOL.ALG', 0);
                    DeleteFile(Path + 'LiveUpdate\ALGOL.ALG');
                END;
                Log.Add('MAJ de version');
                Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                MAJVERSION := true;
                delete(S, 1, 4);
                Pass := Copy(S, 1, Pos(';', S) - 1);
                delete(S, 1, pos(';', S));
                LaDate := Copy(S, pos(';', S) + 1, 255);
                S := Copy(S, 1, Pos(';', S) - 1);
                Decodetime(Now, hhh, mmm, sss, mss);
                MaDateMaj := Date;
                IF hhh >= 18 THEN
                    MaDateMaj := MaDateMaj + 1;
                IF StrToDate(LaDate) <= MaDateMaj THEN
                BEGIN
                    Log.Add('Unzipage ');
                    Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                    Unzip.ZipName := S;
                    Unzip.DestDir := Path;
                    Unzip.unzip;
                    IF ProbZip <> '' THEN
                    BEGIN
                        Log.Add('Problème sur le ZIP ');
                        Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                        EXIT;
                    END;
                    IF Pass <> Version THEN
                    BEGIN
                        Log.Add('Récupération bonne version ');
                        Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                        Winexec(Pchar(Path + 'RECUPMAJ ' + Pass), 0);
                        Data.Close;
                        Close;
                        exit;
                    END;
                    S := Unzip.Pathname[0];
                    delete(S, 1, Pos('\', S));
                    IF pos('\', S) > 0 THEN
                        delete(S, Pos('\', S), 2550);
                    Log.Add('Copie des fichiers ');
                    Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                    Copie(Path + 'LiveUpdate\' + S, Path);

                    IF FileExists(Path + 'LiveUpdate\' + S + '\LESCRIPT.SCR') THEN
                    BEGIN
                        Log.Add('Ajout des scripts ');
                        Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                        FileSetAttr(Pchar(Path + 'Script.scr'), 0);
                        ttsl := TstringList.Create;
                        ttsl.LoadFromFile(Path + 'Script.scr');
                        _tsl := TstringList.Create;
                        _tsl.LoadFromFile(Path + 'LiveUpdate\' + S + '\LESCRIPT.SCR');
                        ttsl.AddStrings(_TSL);
                        ttsl.SavetoFile(Path + 'Script.scr');
                        _Tsl.free;
                        ttsl.free;
                        Log.Add('Execution de script.exe en AUTO1');
                        Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                        ttps := GetTickCount;
                        WinExec(Pchar(Path + 'Script.exe AUTO1'), 0);
                        WHILE NOT MapGinkoia.script DO
                        BEGIN
                            Sleep(1000);
                            IF GetTickCount - ttps > 100000 THEN
                            BEGIN
                                Log.Add('Impossible d''appeler script.exe');
                                Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                                BREAK;
                            END
                        END;
                        Lheure := Now;
                        ok := true;
                        WHILE MapGinkoia.script DO
                        BEGIN
                            sleep(10000);
                            IF Now - Lheure > 0.045 THEN
                            BEGIN
                                ok := false;
                                Log.Add('script.exe tourne depuis plus d''une heure');
                                Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                                BREAK;
                            END;
                        END;
                        Log.Add('script.exe Fini');
                        Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                        IF MapGinkoia.ScriptOK THEN
                        BEGIN
                            Log.Add(' Script OK ');
                            Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                        END
                        ELSE
                        BEGIN
                            Log.Add(' Script Pas OK ');
                            Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                            ok := False;
                        END;
                        IF ok THEN
                            caption := 'Pas de problème'
                        ELSE
                            caption := 'Gros problème';
                        Label1.Update;
                    END;
                    tsl[i] := '';
                    tsl.SaveToFile(Path + 'LiveUpdate\AFaire.txt');
                    FileSetAttr(Unzip.ZipName, 0);
                    Detruit(Path + 'LiveUpdate\' + S);
                    IF FileExists(Path + 'LiveUpdate\ALGOL.ALG') THEN
                    BEGIN
                        Log.Add('Une macro à faire');
                        Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                        Traitement_BATCH(Path + 'LiveUpdate\ALGOL.ALG');
                    END;
                END;
            END
            ELSE IF copy(S, 1, pos(';', S)) = 'SCRIPT;' THEN
            BEGIN
                Log.Add('Faire un SCRIPT'); Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                delete(S, 1, pos(';', S));
                Pass := Copy(S, 1, Pos(';', S) - 1);
                delete(S, 1, pos(';', S));
                IF Pass <> Version THEN
                BEGIN
                    Winexec(Pchar(Path + 'RECUPMAJ ' + Pass), 0);
                    Data.Close;
                    Close;
                    exit;
                END;
                AAjouter := S;
                Unzip.ZipName := S;
                MonPathExtract := S;
                WHILE pos('\', MonPathExtract) > 0 DO
                    delete(MonPathExtract, 1, pos('\', MonPathExtract));
                MonPathExtract := Path + 'LiveUpdate\' + ChangeFileExt(MonPathExtract, '') + '\';
                Unzip.DestDir := MonPathExtract;
                Log.Add('Dézippage'); Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                Unzip.unzip;
                Pass := Unzip.Pathname[0];
                TRY
                    Log.Add('Recherche du ALG'); Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                    FOR j := 0 TO Unzip.Count - 1 DO
                    BEGIN
                        S := Unzip.FullName[j];
                        delete(S, 1, Pos('\', S));
                        S := MonPathExtract + S;
                        IF uppercase(extractFileExt(S)) = '.ALG' THEN
                        BEGIN
                            Log.Add('Lancement traitement sur ' + S); Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
                            IF NOT Traitement_BATCH(S) THEN
                            BEGIN
                                RAISE exception.create('TIMEOUT');
                            END;
                            BREAK;
                        END;
                    END;
                    tsl[i] := '';
                    tsl.SaveToFile(Path + 'LiveUpdate\AFaire.txt');
                    lesscript.Add(AAjouter);
                    Detruit(MonPathExtract);
                EXCEPT
                    lesscript.Add(AAjouter + ';PROB');
                END;
            END;
        END;
        i := 0;
        WHILE i < tsl.count DO
        BEGIN
            IF tsl[i] = '' THEN
                tsl.delete(i)
            ELSE
                inc(i);
        END;
        tsl.SaveToFile(Path + 'LiveUpdate\AFaire.txt');
        tsl.free;

        Data.Close;
        Data.Open;

        IF MAJVERSION THEN
        BEGIN
            QryVersion.open;
            LaVersion := Qryversion.fields[0].AsString;
            QryVersion.Close;
        END
        ELSE
            LaVersion := '';

        Data.Close;
    EXCEPT
        Data.Close;
    END;
    IF (lesscript.count > 0) OR (LaVersion <> '') THEN
    BEGIN
        Log.Add('Appel du serveur pour valider la version');
        Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
        IF Dm_Connexion.Connexion THEN
        BEGIN
            Client.Open;
        END
        ELSE
            Close;
    END
    ELSE
        close;
END;

PROCEDURE TForm1.Button1Click(Sender: TObject);
VAR
    reg: TRegistry;
    ini: tinifile;
    s: STRING;

BEGIN
    MapGinkoia.MajAuto := true;
    ini := TIniFile.Create(ExtractfilePath(Application.exename) + 'LiveUpClient.ini');
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
    Client.Port := StrToInt(ini.ReadString('TPCIP', 'PortListening', '31415'));
    ini.free;
    Caption := 'En cours';
    Label1.Update;
    S := includeTrailingBackslash(ExtractfilePath(Application.exeName));
    IF not fileexists(S+'Ginkoia.ini') then
      S := 'C:\Ginkoia\';
    IF not fileexists(S+'Ginkoia.ini') then
      S := 'D:\Ginkoia\';

    Path := S;

    S := '';
    reg := TRegistry.Create(KEY_READ);
    TRY
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('Software\Algol\Ginkoia', False);
        S := reg.ReadString('Base0');
    FINALLY
        reg.free;
    END;
    IF trim(S) = '' THEN
    BEGIN
        S := Path + 'Ginkoia.Ini';
        ini := tinifile.create(S);
        S := ini.readString('DATABASE', 'PATH0', '');
        ini.free;
    END;
    Data.DatabaseName := S;
    WHILE MapGinkoia.Backup DO
        Sleep(10000);
    Data.Open;
    QryBase.Open;
    Magasin := QryBase.Fields[0].AsString;
    QryBase.Close;

    Traitement;
END;

PROCEDURE TForm1.FormCreate(Sender: TObject);
BEGIN
    Application.createform(TDm_Connexion, Dm_Connexion);
    Arecup := False;
    prem := true;
    lesscript := tstringList.create;
    ProbZip := '';
    Log := TstringList.Create;
END;

PROCEDURE TForm1.FormPaint(Sender: TObject);
BEGIN
    IF prem THEN
    BEGIN
        prem := false;
        IF (paramCount > 0) AND (Uppercase(paramstr(1)) = 'AUTO') THEN
        BEGIN
            Button1.visible := false;
            Button1Click(NIL);
        END;
    END;
END;

PROCEDURE TForm1.ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
BEGIN
    Client.Socket.SendText('Bonjour;' + Magasin);
END;

PROCEDURE TForm1.ClientRead(Sender: TObject; Socket: TCustomWinSocket);
VAR
    s: STRING;
BEGIN
    S := Socket.ReceiveText;
    IF ProbZip <> '' THEN
    BEGIN
        Client.Socket.SendText('ZIP;' + ProbZip);
        Client.Socket.Close;
        tim_close.enabled := true;
    END
    ELSE IF LaVersion = '' THEN
    BEGIN
        IF lesscript.Count > 0 THEN
        BEGIN
            Client.Socket.SendText('MajScript;' + lesscript[0]);
            lesscript.delete(0);
        END
        ELSE
        BEGIN
            Client.Socket.SendText('Deconnexion');
            Client.Socket.Close;
            tim_close.enabled := true;
        END;
    END
    ELSE
    BEGIN
        Client.Socket.SendText('MajVersion;' + LaVersion);
        LaVersion := '';
    END;
END;

PROCEDURE TForm1.ClientError(Sender: TObject; Socket: TCustomWinSocket;
    ErrorEvent: TErrorEvent; VAR ErrorCode: Integer);
BEGIN
    errorcode := 0;
    tim_close.enabled := true;
END;

PROCEDURE TForm1.tim_closeTimer(Sender: TObject);
BEGIN
    tim_close.enabled := false;
    Dm_Connexion.deconnexion;
    Close;
END;

PROCEDURE TForm1.FormDestroy(Sender: TObject);
BEGIN
    Log.SaveToFile(ChangeFileExt(Application.exename, '.log'));
    Log.free;
    lesscript.free;
    IF Arecup THEN
    BEGIN
        Winexec(Pchar(Path + 'RECUPMAJ.EXE MAJ'), 0);
    END;
    MapGinkoia.MajAuto := False;
END;

PROCEDURE TForm1.FormClose(Sender: TObject; VAR Action: TCloseAction);
VAR
    reg: TRegistry;
    S: STRING;
BEGIN
    Dm_Connexion.Deconnexion;
    IF NOT Arecup THEN
    BEGIN
        S := '';
        TRY
            reg := TRegistry.Create(KEY_READ);
            TRY
                reg.RootKey := HKEY_LOCAL_MACHINE;
                reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
                S := reg.ReadString('Launch_Replication');
            FINALLY
                reg.free;
            END;
        EXCEPT
        END;
        IF S <> '' THEN
        BEGIN
            ok := false;
            Lapplication := uppercase(S);
            EnumWindows(@Enumerate2, 0);
            IF NOT ok THEN
                Winexec(PChar(S), 0);
        END;
    END;
    IF ProbZip <> '' THEN
    BEGIN
        unzip.zipname := '';
        filesetattr(ProbZip, 0);
        deletefile(ProbZip);
    END;
    Action := Cafree;
END;

PROCEDURE TForm1.UnZipBadCRC(Sender: TObject; CalcCRC, StoredCRC,
    FileIndex: Integer);
BEGIN
    ProbZip := UnZip.ZipName;
    IF Dm_Connexion.Connexion THEN
        Client.Open;
END;

PROCEDURE TForm1.ClientDisconnect(Sender: TObject;
    Socket: TCustomWinSocket);
BEGIN
    tim_close.enabled := true;
END;

END.

