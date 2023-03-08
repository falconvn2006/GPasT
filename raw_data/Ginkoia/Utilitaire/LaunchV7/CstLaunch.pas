//$Log:
// 5    Utilitaires1.4         23/06/2009 16:46:30    Florent CHEVILLON Init
// 4    Utilitaires1.3         14/06/2006 09:23:23    pascal         
//      Modification pour enp?cher la r?plication si ce n'est pas la virgule
//      qui est le s?parateur d?cimale
// 3    Utilitaires1.2         09/11/2005 10:31:00    pascal         
//      Modification du mot de passe en 1082
// 2    Utilitaires1.1         21/06/2005 09:46:44    pascal         
//      Possibilit? de mettre ? jour les note book pas en r?plication
//      automatique
// 1    Utilitaires1.0         27/04/2005 10:40:47    pascal          
//$
//$NoKeywords$
//
UNIT CstLaunch;

INTERFACE
USES
    Classes,
    Forms,
    Windows,
//    SimpHTTP,
    idHttp,
    SysUtils;
TYPE
    TOnNeedHorraire = PROCEDURE(BasId: Integer; Prin: Boolean; VAR LAUID: Integer; VAR H1: STRING; VAR Valid1: Integer; VAR H2: STRING; VAR Valid2: Integer; VAR Auto: Integer; VAR LaDate: STRING; VAR Back: Integer; VAR BackTime: STRING; VAR ForcerMaj : Boolean; VAR PRM_ID : Integer) OF OBJECT;
    TUneConnexion = PROCEDURE(Nom, Tel: STRING; LeType, Ordre, ID: Integer) OF OBJECT;
    TonNeedConnexion = PROCEDURE(LAUID: Integer; Conn: TUneConnexion) OF OBJECT;
    TUneReplication = PROCEDURE(Id: Integer; Ping, Push, Pull, User, PWD, URLLocal, URLDISTANT, PlaceEai, PlaceBase: STRING; Ordre: integer) OF OBJECT;
    TOnNeedReplication = PROCEDURE(LAUID: Integer; Repli: TUneReplication) OF OBJECT;

    TLesProvider = CLASS
        ID: Integer;
        Nom: STRING;
        Ordre: Integer;
        Loop: Integer;

        Change: Boolean;
        Supp: Boolean;
        CONSTRUCTOR Create;
    END;

    TLesConnexion = CLASS
        ID: Integer;
        Nom, TEL: STRING;
        LeType: Integer;
        Ordre: Integer;
        Change: Boolean;
        CONSTRUCTOR Create;
    END;

    TLesreplication = CLASS
        ID: Integer;
        Ping: STRING;
        Push: STRING;
        Pull: STRING;
        User: STRING;
        PWD: STRING;
        URLLocal: STRING;
        URLDISTANT: STRING;
        PlaceEai: STRING;
        PlaceBase: STRING;
        Ordre: Integer;

        Change: Boolean;
        Supp: Boolean;
        ListProvider: TList;
        ListSubScriber: TList;
        FUNCTION GetProviderLoop(Value: Integer): Boolean;
        FUNCTION GetProviderNom(Value: Integer): STRING;
        CONSTRUCTOR Create;
        DESTRUCTOR Destroy; OVERRIDE;
        FUNCTION ProviderCount: Integer;
        FUNCTION SubScriberCount: Integer;
        PROPERTY ProviderNom[Value: Integer]: STRING READ GetProviderNom;
        PROPERTY ProviderLoop[Value: Integer]: Boolean READ GetProviderLoop;
    END;

    TLesReferenceLig = CLASS
        ID: Integer;
        PARAM: STRING;
        Change: Boolean;
        Supp: Boolean;
        CONSTRUCTOR Create;
    END;

    TLesReference = CLASS
    PROTECTED
        FUNCTION GetLeParam(Idx: Integer): STRING;
        PROCEDURE SetLeParam(Idx: Integer; CONST Value: STRING);
    PUBLIC
        ID: Integer;
        Position: Integer;
        Place: Integer;
        URL: STRING;
        Ordre: STRING;
        LesLig: TList;
        Change: Boolean;
        Supp: Boolean;
        CONSTRUCTOR Create;
        DESTRUCTOR Destroy; OVERRIDE;
        FUNCTION LignesCount: Integer;
        PROPERTY LeParam[Idx: Integer]: STRING READ GetLeParam WRITE SetLeParam;
    END;

CONST
    CstConnexionGlobal = 0;
    CstLancementProgramme = 1;
    CstFermetureProgramme = 2;
    CstPassageV7 = 3;
    CstPassageV4 = 4;
    CstInitialisationBase = 5;
    CstModifParametre = 6;
    CstModifProvider = 7;
    CstModifSubscriber = 8;
    CstConnexionModem = 9;
    CstDeConnexionModem = 10;
    CstChangementhorraire = 11;
    CstReplicationManuel = 12;
    CstDeconnexionTrigger = 13;
    CstReconnexionTrigger = 14;
    CstRecalculeTrigger = 15;
    CstTempsReplication = 16;
    CstLanceBackup = 17;
    CstLanceLiveUpdate = 18;
    CstUneReplication = 19;
    CstReplicationAutomatiqueH1 = 20;
    CstReplicationAutomatiqueH2 = 21;
    CstPush = 999;
    CstPull = 1999;
    CstModulePush = 1000; // A 1999
    CstModulePuLL = 2000; // A 1999

    CstTblLiaiRepli = -11111493; // -11111900; //
    CstTblEvent = -11111492; // -11111901; //

    CstTblConnexion = -11111467;
    CstTblLaunch = -11111465;
    CstTblReplication = -11111468;
    CstTblProviders = -11111469;
    CstTblSubScribers = -11111470;
    CstPassword = '1082';
    CstTblChangeLaunch = -11111466;
    CstTblGENPARAM = -11111454 ;

    CstTblRRE = -11111513;
    CstTblRRL = -11111514;

FUNCTION EnStr(Value: Integer): STRING; Overload;
FUNCTION EnStr(Value: STRING): STRING; Overload;
FUNCTION EnStr(Value: Boolean): STRING; Overload;
FUNCTION ListeEnStr(value: ARRAY OF CONST): STRING;
FUNCTION UnPing(URL: STRING): Boolean;
PROCEDURE ArretDelos;
FUNCTION CalculeTemps(H, M, S: Word; Absolue: Boolean): DWord;
PROCEDURE LeDelay(nb: DWord);

IMPLEMENTATION
{ TLesConnexion }

//---------------------------------------------------------------
// Attente avec traitement des messages
//---------------------------------------------------------------

PROCEDURE LeDelay(nb: DWord);
VAR
    ii: DWORD;
BEGIN
    ii := gettickcount + nb;
    WHILE ii > gettickcount DO
    BEGIN
        application.ProcessMessages;
    END;
END;

FUNCTION CalculeTemps(H, M, S: Word; Absolue: Boolean): DWord;
VAR
    hh, mm, ss, dd: Word;
    h1, h2: Dword;
BEGIN
    Decodetime(Now, hh, mm, ss, dd);
    H1 := ss + mm * 60 + hh * 3600;
    H2 := S + M * 60 + H * 3600;
    IF absolue THEN
    BEGIN
        IF H1 > H2 THEN
            result := (h1 - h2) * 1000
        ELSE
            result := (h2 - H1) * 1000;
    END
    ELSE
    BEGIN
        IF H1 > H2 THEN
            result := (86400 + h2 - h1) * 1000
        ELSE
            result := (h2 - H1) * 1000;
    END;
END;

FUNCTION Enumerate(hwnd: HWND; Param: LPARAM): Boolean; STDCALL; FAR;
VAR
    lpClassName: ARRAY[0..999] OF Char;
    Handle: DWORD;
    S1: STRING;
    // lpdwProcessId: Pointer;
BEGIN
    result := true;
    Windows.GetClassName(hWnd, lpClassName, 500);
    S1 := StrPas(lpClassName);
    IF Uppercase(S1) = 'TFMDELOSHTTPSERVER' THEN
    BEGIN
        GetWindowThreadProcessId(hWnd, @Handle);
        TerminateProcess(OpenProcess(PROCESS_ALL_ACCESS, False, Handle), 0);
        result := False;
    END;
END;

PROCEDURE ArretDelos;
BEGIN
    EnumWindows(@Enumerate, 0);
    sleep(100);
END;

// FC 16/06/2009 : Migration, remplacement du TSimpleHTTP par TidHTTP
FUNCTION UnPing(URL: STRING): Boolean;
VAR
    httpPing : TidHTTP;
    sResult : string;
    tsSource :  TStrings;
BEGIN
    // lancer un test du ping
    TRY
        tsSource := TStringList.Create;
        httpPing := TidHTTP.Create(NIL);
        try
            tsSource.Add('Caller=TOTO');
            tsSource.Add('Provider=TATA');
// semble inutile            httpPing.Request.ContentType := 'application/x-www-form-urlencoded';
            sResult := httpPing.Post(URL, tsSource);
            IF Copy(sResult,1,4) = 'PONG' THEN
                result := true
            ELSE
                result := false
        FINALLY
            tsSource.Free;
            httpping.free;
        END;
    except 
        result := false;
    END;
end;


// FC 16/06/2009 : Migration, remplacement du TSimpleHTTP par TidHTTP
// Ancienne version supprimée
//FUNCTION UnPing(URL: STRING): Boolean;
//VAR
//    Ping: TSimpleHTTP;
//    ResultBody: TStringStream;
//
//BEGIN
//    // lancer un test du pin
//    TRY
//        ResultBody := TStringStream.Create('');
//        Ping := TidHTTP.Create(NIL);
//        TRY
//            Ping.PostData.Clear;
//            Ping.PostData.Values['Caller'] := 'TOTO';
//            Ping.PostData.Values['Provider'] := 'TATA';
//            ResultBody := Ping.Post(URL);
//            IF Copy(ResultBody,1,4) = 'PONG' THEN
//                result := true
//            ELSE
//                result := false
//        FINALLY
//            ResultBody.free;
//            ping.free;
//        END;
//    EXCEPT
//        result := false;
//    END;
//    //
//END;

CONSTRUCTOR TLesConnexion.Create;
BEGIN
    INHERITED;
    Change := false;
END;

{ TLesreplication }

CONSTRUCTOR TLesreplication.Create;
BEGIN
    INHERITED create;
    Change := False;
    Supp := False;
    User := '';
    PWD := '';
    Ping := '';
    Push := '';
    Pull := '';
    ListProvider := TList.Create;
    ListSubScriber := TList.Create;

END;

FUNCTION EnStr(Value: Integer): STRING;
BEGIN
    Result := Inttostr(Value);
END;

FUNCTION EnStr(Value: STRING): STRING;
BEGIN
    IF Value = 'NULL' THEN
        result := 'NULL'
    ELSE
        result := QuotedStr(Value);
END;

FUNCTION EnStr(Value: Boolean): STRING; OVERLOAD;
BEGIN
    IF value THEN
        result := '1'
    ELSE
        result := '0';
END;

FUNCTION ListeEnStr(value: ARRAY OF CONST): STRING;

    FUNCTION Trform(S: STRING): STRING;
    BEGIN
        IF S = 'NULL' THEN result := 'NULL' ELSE result := QuotedStr(S);
    END;

CONST
    BoolChars: ARRAY[Boolean] OF Char = ('0', '1');
VAR
    I: Integer;
BEGIN
    Result := '';
    FOR I := 0 TO High(Value) DO
        WITH Value[I] DO
            CASE VType OF
                vtInteger: Result := Result + IntToStr(VInteger) + ',';
                vtBoolean: Result := Result + BoolChars[VBoolean] + ',';
                vtChar: Result := Result + Trform(VChar) + ',';
                vtExtended: Result := Result + FloatToStr(VExtended^) + ',';
                vtString: Result := Result + Trform(VString^) + ',';
                vtPChar: Result := Result + Trform(VPChar) + ',';
                vtObject: Result := Result + VObject.ClassName + ',';
                vtClass: Result := Result + VClass.ClassName + ',';
                vtAnsiString: Result := Result + Trform(STRING(VAnsiString)) + ',';
                vtCurrency: Result := Result + CurrToStr(VCurrency^) + ',';
                vtVariant: Result := Result + Trform(STRING(VVariant^)) + ',';
                vtInt64: Result := Result + IntToStr(VInt64^) + ',';
            END;
    Delete(result, length(result), 1);
END;

DESTRUCTOR TLesreplication.Destroy;
VAR
    i: integer;
BEGIN
    FOR i := 0 TO ListProvider.Count - 1 DO
        TLesProvider(ListProvider[i]).free;
    ListProvider.free;

    FOR i := 0 TO ListSubScriber.Count - 1 DO
        TLesProvider(ListSubScriber[i]).free;
    ListSubScriber.free;
    INHERITED;
END;

FUNCTION TLesreplication.GetProviderLoop(Value: Integer): Boolean;
BEGIN
    result := TLesProvider(ListProvider[Value]).Loop = 1;
END;

FUNCTION TLesreplication.GetProviderNom(Value: Integer): STRING;
BEGIN
    result := TLesProvider(ListProvider[Value]).Nom;
END;

FUNCTION TLesreplication.ProviderCount: Integer;
BEGIN
    result := ListProvider.Count;
END;

FUNCTION TLesreplication.SubScriberCount: Integer;
BEGIN
    result := ListSubScriber.Count;
END;

{ TLesProvider }

CONSTRUCTOR TLesProvider.Create;
BEGIN
    INHERITED;
    Change := False;
    Supp := False;
    ID := -1;
    Nom := '';
    Ordre := 0;
    Loop := 0;
END;

{ TLesReferenceLig }

CONSTRUCTOR TLesReferenceLig.Create;
BEGIN
    INHERITED;
    Change := False;
    Id := -1;
    Param := '';
    Supp := False;
END;

{ TLesReference }

CONSTRUCTOR TLesReference.Create;
BEGIN
    INHERITED;
    Change := False;
    Supp := False;
    ID := -1;
    Position := 0;
    Place := 1;
    URL := '';
    Ordre := '';
    LesLig := TList.Create;
END;

DESTRUCTOR TLesReference.Destroy;
VAR
    i: integer;
BEGIN
    FOR i := 0 TO LesLig.Count - 1 DO
        TLesReferenceLig(LesLig[i]).free;
    INHERITED;
END;

FUNCTION TLesReference.GetLeParam(Idx: Integer): STRING;
BEGIN
    result := TLesReferenceLig(LesLig[Idx]).PARAM;
END;

FUNCTION TLesReference.LignesCount: Integer;
BEGIN
    result := LesLig.Count;
END;

PROCEDURE TLesReference.SetLeParam(Idx: Integer; CONST Value: STRING);
BEGIN
    TLesReferenceLig(LesLig[Idx]).PARAM := Value;
END;

END.

