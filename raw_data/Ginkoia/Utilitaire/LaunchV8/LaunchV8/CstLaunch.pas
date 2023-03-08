//$Log:
// 9    Utilitaires1.8         02/01/2020 11:39:01    Antoine JOLY    Launcher
//      V14.3.3.4 : Int?gration uPasswordManager et changement mot de passe par
//      d?faut
// 8    Utilitaires1.7         16/02/2017 14:46:35    Antoine JOLY    Recalcul
//      des triggers en H1 avec r?cup?ration des K oubli?s par le launcher chez
//      Rihouet
// 7    Utilitaires1.6         11/12/2013 14:45:37    Thierry Fleisch Version
//      13.1.0.24 :
//      - Effacement de l'affichage lors d'une r?plication r?ussie
//      - Nettoyage des icones Delos restants dans la zone de Trayicon 
//      - Ajout de la gestion du site Web dans l'envoi des factures Stockit
//      - Modification pour la lib?ration du jeton
//      - Correction des probl?mes de R?plication en cours alors que l'on vient
//      d'ex?cuter le logciiel.
//      - Correction du probl?me de mouvement du K dans les param?trages des
//      providers/Subscribers
// 6    Utilitaires1.5         26/06/2013 15:09:55    Thierry Fleisch Ajout du
//      syst?me de gestion de l'ex?cution d'un logiciel externe
// 5    Utilitaires1.4         28/09/2012 09:42:33    Florent CHEVILLON Ajout
//      Verison, modif Synchro
// 4    Utilitaires1.3         05/07/2012 10:49:15    Florent CHEVILLON Maj
// 3    Utilitaires1.2         16/05/2012 15:10:56    Florent CHEVILLON Maj FC
//      pour ?craser rendu foireux SR
// 2    Utilitaires1.1         16/05/2012 15:05:36    Sylvain ROSSET  Ajout
//      Param
// 1    Utilitaires1.0         06/04/2012 17:42:07    Florent CHEVILLON 
//$
//$NoKeywords$
//
UNIT CstLaunch;

INTERFACE
USES
    Classes,
    Forms,
    Windows,
    Commctrl,
    ShellApi,
    idHttp,
    SysUtils;


type Tray = record
    hwnd : Cardinal; //handle de la fenêtre
    uID : Integer; //id de l//icone
    uCallbackMessage : Cardinal; //message envoyé à la fenêtre
    Unknown1 : Cardinal; //interprétation inconnue
    Unknown2 : Cardinal; //interprétation inconnue
    hIcon : Cardinal; //handle de l//icone affichée
    Unknown3 : Cardinal; //interprétation inconnue
    Unknown4 : Cardinal; //interprétation inconnue
    Unknown5 : Cardinal; //interprétation inconnue
    uniPath: string; //chemin et nom du fichier du processus qui a cette icone dans le tray
    sTip: string; //ToolTip de l//icone
    iBitmap : Cardinal; //index de l//icone affichée
    idCommand : Integer; //id de la commande
    fsState: byte; //état de l//icone
    fsStyle: byte; //style de l//icone (TBSTYLE_BUTTON)
    dwData : Cardinal; //pointeur vers les données du tray
    iString : Cardinal; //pointeur vers le Tip
end;


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
        NbEssai : integer;
        bReplicJour : boolean;
        ExeFinReplic: string;

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
        Plateforme: Integer;
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
    CstPassword = 'ch@mon1x';
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
procedure NettoieBarreDesTaches;

IMPLEMENTATION
{ TLesConnexion }

// Netttoyage de la barre des taches  : Modifié le 16/02/2017 par AJ pour que ça fonctionne avec toutes les version de windows
procedure NettoieBarreDesTaches;
var
    hwnd,hwnd2 : Cardinal; //handle

    procedure RefreshTrayArea(handle : cardinal);
    var
      rec:TRect;
      x,y:integer;
    begin
      GetClientRect(handle,rec);
      x:=0;
      while x<=rec.Right do
      begin
        y:=0;
        while y<=rec.Bottom do
        begin
          SendMessage(handle,512,0,(y shl 16)+x);  //WM_MOUSEMOVE = 512
          inc(y,5);
        end;
        inc(x,5);
      end;
    end;

begin
  hwnd := FindWindow('Shell_TrayWnd', 0);
  hwnd := FindWindowEx(hwnd, 0, 'TrayNotifyWnd', 0);
  hwnd := FindWindowEx(hwnd, 0, 'SysPager', 0);
  hwnd:=  FindWindowEx(hwnd,0,'ToolbarWindow32',0);
  RefreshTrayArea(hwnd);

  hwnd2 := FindWindow('NotifyIconOverflowWindow', 0);
  hwnd2:=  FindWindowEx(hwnd2,0,'ToolbarWindow32',0);
  RefreshTrayArea(hwnd2);
end;

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
    NbEssai := 0;
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

