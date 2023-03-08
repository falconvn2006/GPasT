unit Gin.Com.Log;

interface

uses Classes, SysUtils, StrUtils, Windows, Winsock, Contnrs, SyncObjs, iniFiles, idTCPClient ;

//==============================================================================
const
    LogLevelTri : array[0..8] of string = ('   ', 'DGB', 'TRA', 'INF', 'NOT', 'WAR', 'ERR', 'CRI', 'EMG') ;
    LogLevelStr : array[0..8] of string = ('', 'Debug', 'Trace', 'Info', 'Notice', 'Warning', 'Error', 'Critical', 'Emergency') ;
    LogVersion  : integer = 1 ;
type
    TLogLevel = (logNone, logDebug, logTrace, logInfo, logNotice, logWarning, logError, logCritical, logEmergency) ;
    TLogSendState = (sendNone, sendWait, sendDo, sendDone) ;
//------------------------------------------------------------------------------
    TLogServer = record
        name : string ;
        host : string ;
        port : Word ;
    end;
//------------------------------------------------------------------------------
    PLogItem = ^TLogItem ;
    TLogItem = record
        date : TDateTime ;
        host : string[64] ;
        app  : string[64] ;
        inst : string[64] ;
        mdl  : string[64] ;
        ref  : string[64] ;
        key  : string[64] ;
        val  : string[255] ;
        lvl  : TLogLevel ;
        ovl  : boolean ;
        nb   : word ;
        store : boolean ;
        send  : TLogSendState ;
    end;
//------------------------------------------------------------------------------
    TLog = class(TThread)
    private
        newItems  : TList ;
        logItems  : TList ;
        sendItems : TList ;
        lckNew   : TRTLCriticalSection ;
        lckLog   : TRTLCriticalSection ;
        lckSend  : TRTLCriticalSection ;

        Servers : array of TLogServer ;
        CurrentServer : integer ;

        fHost   : string ;
        fApp    : string ;
        fInst   : string ;

        fMinLogLevel  : TLogLevel ;
        fMinSendLevel : TLogLevel ;
        fLogKeepDays  : integer ;
        fMaxNewItems  : word ;
        fMaxLogItems  : word ;
        fLogFileName  : string ;

        fDefaultConfigFileName  : string ;
        fDefaultStorageFileName : string ;

        fConfigured : boolean ;
        fOpened : boolean ;

        SendBuffer : AnsiString ;

        function getNewItems : boolean ;
        procedure storeItems ;
        procedure loadItems ;
        procedure logToFile ;
        procedure sendToServer ;

        procedure clearNewItems ;
        procedure clearLogItems ;
        procedure clearSendItems ;
        procedure clearItem(aItem : PLogItem) ;
        procedure disposeItem(aItem : PLogItem) ;

        procedure cleanSendItems ;

        function isEqual(aItem, bItem : PLogItem) : boolean ;
        function sendItemToServer(aItem: PLogItem) : boolean ;
        function sendBufferToServer : boolean ;

        procedure cleanupLogFiles ;
    protected
        procedure Execute ; override ;

    public
        constructor Create ; reintroduce ;
        destructor Destroy ; override ;

        procedure Open ;
        procedure Close ;

        procedure readIni(aFileName : string = '') ;
        procedure saveIni(aFileName : string = '') ;

        procedure Log(aMdl, aRef, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false) ; overload ;
        procedure Log(aMdl, aRef, aKey : string ; aVal : Int64 ; aLvl : TLogLevel ; aOvl : boolean = false) ; overload ;
        procedure Log(aMdl, aRef, aKey : string ; aVal : Extended ; aLvl : TLogLevel ; aOvl : boolean = false) ; overload ;
        procedure Log(aMdl, aRef, aKey : string ; aVal : Boolean ; aLvl : TLogLevel ; aOvl : boolean = false) ; overload ;

        class function LogLevelToStr(aLogLevel : TLogLevel) : string ;
        class function StrToLogLevel(aLevel : string) : TLogLevel ;

        function ItemToJSON(aItem : TLogItem) : string ;
        class function JSONEscapeValue(aStr : string) : AnsiString ;
    published
        property Host : string read fHost write fHost ;
        property App  : string read fApp  write fApp ;
        property Inst : string read fInst write fInst ;

        property Opened : boolean read fOpened ;
    end;

//------------------------------------------------------------------------------
    var
        Log : TLog ;
        WSAData : TWSAData ;

//------------------------------------------------------------------------------

function strLPad(aStr : string ; aLen : integer ; aChar : char = ' ') : string ;
function getMachineName : string ;
function getApplicationFileName : string ;

//==============================================================================

implementation
//==============================================================================
function strLPad(aStr : string ; aLen : integer ; aChar : char = ' ') : string ;
var
    RestLen: Integer;
begin
    RestLen := aLen - Length(aStr);
    if (RestLen < 1) then
    begin
        Result := copy(aStr, 1 ,aLen) ;
    end else begin
        Result := aStr + StringOfChar(aChar, RestLen) ;
    end;
end;
//------------------------------------------------------------------------------
function getMachineName : string ;
type
     Name  = array[0..100] of AnsiChar ;
     PName = ^Name ;
var
     HName : PName ;
begin
     Result := '' ;

     new(HName) ;

     if Winsock.gethostname(pAnsiChar(HName), sizeof(Name)) = 0 then
     begin
          Result := StrPas(HName^) ;
     end ;

     Dispose(HName) ;
end ;
//------------------------------------------------------------------------------
function getApplicationFileName : string ;
begin
  SetLength(Result, MAX_PATH + 1); // Add 1 for the null character
  GetModuleFileName(hInstance, PChar(Result), MAX_PATH + 1);
  SetLength(Result, Length(PChar(Result)));
end;
//==============================================================================
constructor TLog.Create;
begin
    inherited Create(true) ;

    // Default values
    fDefaultConfigFileName  := ChangeFileExt(getApplicationFileName, '.ini') ;
    fDefaultStorageFileName := ChangeFileExt(getApplicationFileName, '.log.tmp') ;

    fLogFileName  := '.'+PathDelim+'logs'+PathDelim+'log_{%APP}_{%INST}_{%DATE}.log' ;
    fMinLogLevel  := logInfo ;
    fMinSendLevel := logInfo ;
    fLogKeepDays  := 7 ;            // Les logs sont gardés 1 semaine
    fMaxNewItems  := 1000  ;        // On ne garde pas plus de 1000 items en tampon
    fMaxLogItems  := 10000 ;        // On ne garde pas plus de 10000 items en memoire

    fHost := getMachineName ;
    fApp  := ChangeFileExt(ExtractFileName(paramstr(0)),'') ;
    fInst := '' ;

    fOpened := false ;
    fConfigured := false ;

    InitializeCriticalSection(lckNew) ;
    InitializeCriticalSection(lckLog) ;
    InitializeCriticalSection(lckSend) ;

    newItems  := TList.Create ;
    logItems  := TList.Create ;
    sendItems := TList.Create ;

    SendBuffer := '' ;

    CurrentServer := 0 ;

    setThreadPriority(ThreadID, THREAD_PRIORITY_BELOW_NORMAL) ;
end;
//------------------------------------------------------------------------------
destructor TLog.Destroy;
begin
    Close ;
    Terminate ; Resume ; WaitFor ;

    clearNewItems ;
    clearLogItems ;
    clearSendItems ;

    DeleteCriticalSection(lckSend) ;
    DeleteCriticalSection(lckLog) ;
    DeleteCriticalSection(lckNew) ;

    sendItems.Free ;
    logItems.Free ;
    newItems.Free ;

    inherited ;
end;
//------------------------------------------------------------------------------
procedure TLog.Execute;
var
    nextTC  : DWord ;
    slowTC  : DWord ;
begin
    inherited ;

    nextTC := getTickCount ;
    slowTC := getTickCount ;

    while not Terminated do
    begin
        while ((getTickCount < nextTC) and (not Terminated)) do
            sleep(50) ;

        nextTC := getTickCount + 1000 ;

        if getNewItems
            then storeItems ;

        logToFile ;
        sendToServer ;
        cleanSendItems ;

        if ((slowTC < getTickCount) and (not Terminated)) then
        begin
            slowTC := getTickCount + (1000*60) ;
            cleanupLogFiles ;
        end ;

        if ((not fOpened) and (not Terminated)) then Suspend ;
    end ;

    storeItems ;
end;
//------------------------------------------------------------------------------
function TLog.getNewItems : boolean ;
var
    aItem : PLogItem ;
begin
    Result := false ;

    EnterCriticalSection(lckNew) ;
    EnterCriticalSection(lckLog) ;
    EnterCriticalSection(lckSend) ;
    try
        while newItems.Count > 0 do
        begin
            aItem := newItems[0] ;
            newItems.Delete(0) ;

            aItem^.store := false ;
            aItem^.send  := sendNone;

            if ((aItem^.lvl >= fMinLogLevel) or (aItem^.ovl)) then
            begin
                aItem^.store := true ;
                logItems.Add(aItem) ;
            end;

            if ((aItem^.lvl >= fMinSendLevel) or (aItem^.ovl)) then
            begin
                aItem^.send := sendWait ;
                sendItems.Add(aItem) ;
            end;

            Result := true ;
        end ;
    finally
        LeaveCriticalSection(lckSend) ;
        LeaveCriticalSection(lckLog) ;
        LeaveCriticalSection(lckNew) ;
    end;

        aItem := nil ;

    EnterCriticalSection(lckLog) ;
    try
        while logItems.Count > fMaxLogItems do
        begin
            aItem := logItems[0] ;
            logItems.Delete(0) ;
            Dispose(aItem) ;
        end;
    finally
        LeaveCriticalSection(lckLog) ;
    end ;

    EnterCriticalSection(lckSend) ;
    try
        while sendItems.Count > fMaxLogItems do
        begin
            aItem := sendItems[0] ;
            sendItems.Delete(0) ;
            Dispose(aItem) ;
        end;

    finally
        LeaveCriticalSection(lckSend) ;
    end;
end;
//------------------------------------------------------------------------------
procedure TLog.storeItems;
var
    fileTemp : File of TLogItem ;
    aItem : PLogItem ;
    ia  : integer ;
begin
    try
        AssignFile(fileTemp, fDefaultStorageFileName) ;

        try
            {$I+}
            Rewrite(fileTemp) ;
            {$I-}

            // Write Header
            New(aItem) ;
            ClearItem(aItem) ;

            aItem^.date := now ;
            aItem^.app  := 'MONITOR' ;
            aItem^.key  := 'VERSION' ;
            aItem^.val  := IntToStr(LogVersion) ;

            write(fileTemp, aItem^) ;
            Dispose(aItem) ;

            EnterCriticalSection(lckSend) ;
            try
                for ia := 0 to sendItems.Count - 1 do
                begin
                    aItem := sendItems[ia] ;
                    write(fileTemp, aItem^) ;
                end ;
            finally
                LeaveCriticalSection(lckSend) ;
            end;

        finally
            CloseFile(fileTemp) ;
        end;
    except
    end;
end ;
//------------------------------------------------------------------------------
procedure TLog.loadItems;
var
    fileTemp : File of TLogItem ;
    aItem : PLogItem ;
    ia  : integer ;
    ba : boolean ;
begin
    if not FileExists(fDefaultStorageFileName) then Exit ;

    try
        AssignFile(fileTemp, fDefaultStorageFileName) ;

        try
            {$I+}
            Reset(fileTemp) ;
            {$I-}

            // Read header
            New(aItem) ;
            clearItem(aItem) ;

            try
                try
                    Read(fileTemp, aItem^) ;
                except
                end;

                if (   (aItem^.app <> 'MONITOR')
                    or (aItem^.key <> 'VERSION')
                    or (aItem^.val <> IntToStr(LogVersion)))
                    then Exit ;                               // Not a good file

            finally
                Dispose(aItem) ;
            end ;

            EnterCriticalSection(lckLog) ;
            EnterCriticalSection(lckSend) ;
            try
                while not eof(fileTemp) do
                begin
                    New(aItem) ;
                    try
                        Read(fileTemp, aItem^) ;
                    except
                        Dispose(aItem) ;
                        break ;
                    end;

                    ba := false ;

                    if (aItem^.send in [sendWait, sendDo]) then
                    begin
                        ba := true ;
                        aItem^.send := sendWait ;
                        sendItems.Add(aItem) ;
                    end;

                    if (aItem^.store) then
                    begin
                        ba := true ;
                        logItems.Add(aItem) ;
                    end;

                    if not ba
                        then Dispose(aItem) ;
                end;
            finally
                LeaveCriticalSection(lckSend) ;
                LeaveCriticalSection(lckLog) ;
            end;

        finally
            CloseFile(fileTemp) ;
        end;
    except
    end;
end;
//------------------------------------------------------------------------------
procedure TLog.logToFile;
var
    fileLog : TFileStream ;
    sFilename : string ;
    sPath     : string ;
    aItem     : PLogItem ;
    sa        : AnsiString ;
    ia        : integer ;
begin
    if logItems.Count < 1 then Exit ;

    try
        sFilename := ExpandFileName(fLogFileName) ;
        sFilename := stringreplace(sFilename, '{%DATE}', FormatDateTime('yyyy-mm-dd', now), [rfReplaceAll]) ;
        sFilename := stringreplace(sFilename, '{%APP}', fApp, [rfReplaceAll]) ;
        sFilename := stringreplace(sFilename, '{%INST}', fInst, [rfReplaceAll]) ;

        sPath := ExtractFilePath(sFilename) ;
        ForceDirectories(sPath) ;

        if FileExists(sFilename) then
        begin
            fileLog := TFileStream.Create(sFilename, fmOpenReadWrite);
            fileLog.Seek(0,soFromEnd) ;
        end else begin
            fileLog := TFileStream.Create(sFilename, fmCreate);
        end;

        try
            EnterCriticalSection(lckLog) ;
            try
                while logItems.Count > 0 do
                begin
                    aItem := logItems[0] ;

                    sa := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzzz', aItem^.date) + ' | ' ;
                    sa := sa + LogLevelToStr(aItem^.lvl) + ' | ' ;
                    sa := sa + StrLPad(aItem^.mdl, 32) + ' | ' ;
                    sa := sa + StrLPad(aItem^.ref, 32) + ' | ' ;
                    sa := sa + StrLPad(aItem^.key, 32) + ' | ' ;
                    sa := sa + StrLPad(IntToStr(aItem^.nb), 3) + ' | ' ;
                    sa := sa + StrLPad(aItem^.val, 255) + ' | ' ;
                    sa := sa + #13#10 ;

                    fileLog.Write(sa[1], length(sa)) ;
                    aItem^.store := false ;
                    logItems.Delete(0) ;
                    disposeItem(aItem) ;
                end ;
            finally
                LeaveCriticalSection(lckLog) ;
            end;
        finally
            fileLog.Free ;
        end;
    except
    end;
end;
//------------------------------------------------------------------------------
function TLog.sendBufferToServer: boolean;
var
    ia : Integer ;
    sa : string ;
    bSent : boolean ;
    TCPClient : TidTCPClient ;
begin
    Result := true ;
    if Length(SendBuffer) < 1 then Exit ;

    bSent := true ;
    SendBuffer := SendBuffer + ']' ;

    if Length(Servers) > 0 then
    begin
        bSent := false ;
        if CurrentServer >= Length(Servers)
            then CurrentServer := 0 ;

        for ia := CurrentServer to Length(Servers) - 1 do
        begin
            TCPClient := TidTCPClient.Create ;

            try
                TCPClient.Host := Servers[ia].host ;
                TCPClient.Port := Servers[ia].port ;
                TCPClient.ConnectTimeout := 5000 ;

                try
                    TCPCLient.Connect ;
                except
                end;

                if TCPCLient.Connected then
                begin
                    try
                        TCPClient.IOHandler.ReadTimeout := 10000 ;

                        TCPClient.IOHandler.WriteBufferOpen ;
                        TCPClient.IOHandler.WriteLn('POST /monitor/monitor.php?act=log HTTP/1.1') ;
                        TCPClient.IOHandler.WriteLn('Host: ' + Servers[ia].host) ;
                        TCPClient.IOHandler.WriteLn('Content-Type: application/json') ;
                        TCPClient.IOHandler.WriteLn('Content-Length: ' + IntToStr(Length(sendBuffer)+3)) ;
                        TCPClient.IOHandler.WriteLn(#13#10) ;
                        TCPClient.IOHandler.WriteLn(SendBuffer) ;
                        TCPClient.IOHandler.WriteBufferFlush ;

                        sa := TCPClient.IOHandler.ReadLn ;
                        TCPClient.Disconnect ;

                        if (sa = 'HTTP/1.1 200 OK') then
                        begin
                            bSent := true ;
                            CurrentServer := ia ;
                            Break ;
                        end ;

                    except
                    end;
                end;
            finally
                TCPClient.Free ;
            end;
        end;
    end;

    SendBuffer := '';

    if bSent then
    begin
        for ia := 0 to sendItems.Count - 1 do
            if PLogItem(sendItems[ia])^.send = sendDo
                then PLogItem(sendItems[ia])^.send := sendDone ;
        Result := true ;
    end else begin
        CurrentServer := 0 ;

        for ia := 0 to sendItems.Count - 1 do
            if PLogItem(sendItems[ia])^.send = sendDo
                then PLogItem(sendItems[ia])^.send := sendWait ;
        Result := false ;
    end;
end;
//------------------------------------------------------------------------------
function TLog.sendItemToServer(aItem: PLogItem) : boolean ;
var
    ia : integer ;
begin
    Result := true ;
    if not Assigned(aItem) then Exit ;

    if (SendBuffer = '')
        then SendBuffer := SendBuffer + '['
        else SendBuffer := SendBuffer + ',' ;

    SendBuffer := SendBuffer + ItemToJSON(aItem^) ;
    aItem^.send := sendDo ;
end;
//------------------------------------------------------------------------------
procedure TLog.sendToServer;
var
    ia: Integer;
    aItem : PLogItem ;
    sa : AnsiString ;
begin
    if sendItems.Count < 1 then Exit ;
    try
        EnterCriticalSection(lckSend) ;
        try
            for ia := 0 to sendItems.Count - 1 do
            begin
                aItem := sendItems[ia] ;

                if aItem^.send = sendWait
                    then sendItemToServer(aItem) ;

                if length(SendBuffer) > (256 * 1024)
                    then break ;
            end ;

            sendBufferToServer ;
        finally
            LeaveCriticalSection(lckSend) ;
        end;
    except
    end;
end;
//------------------------------------------------------------------------------
procedure TLog.cleanSendItems;
var
    ia: Integer;
    aItem : PLogItem ;
begin
    EnterCriticalSection(lckSend) ;
    try
        for ia := sendItems.Count - 1 downto 0 do
        begin
            aItem := sendItems[ia] ;
            if (aItem^.send in [sendDone, sendNone]) then
            begin
                sendItems.delete(ia) ;
                disposeItem(aItem) ;
            end;
        end;
    finally
        LeaveCriticalSection(lckSend) ;
    end;
end;
//------------------------------------------------------------------------------
procedure TLog.clearItem(aItem: PLogItem);
begin
    if not Assigned(aItem) then Exit ;

    Fillchar(aItem^, sizeof(aItem^), 0) ;
end;
//------------------------------------------------------------------------------
procedure TLog.disposeItem(aItem: PLogItem);
begin
    if not Assigned(aItem)
        then Exit ;

    if ((not aItem^.store)  and  (aItem^.send in [sendNone, sendDone])) then
    begin
        Dispose(aItem) ;
    end;
end;
//------------------------------------------------------------------------------
procedure TLog.clearNewItems;
var
    aItem : PLogItem ;
begin
    EnterCriticalSection(lckNew) ;
    try
        while newItems.Count > 0 do
        begin
            aItem := newItems[0] ;
            newItems.Delete(0) ;
            Dispose(aItem) ;
        end;
    finally
        LeaveCriticalSection(lckNew) ;
    end;
end;
//------------------------------------------------------------------------------
procedure TLog.clearSendItems;
var
    aItem : PLogItem ;
begin
    EnterCriticalSection(lckSend) ;
    try
        while logItems.Count > 0 do
        begin
            aItem := logItems[0] ;
            logItems.Delete(0) ;
            Dispose(aItem) ;
        end;
    finally
        LeaveCriticalSection(lckSend) ;
    end;
end;
//------------------------------------------------------------------------------
procedure TLog.clearLogItems;
var
    aItem : PLogItem ;
begin
    EnterCriticalSection(lckLog) ;
    try
        while logItems.Count > 0 do
        begin
            aItem := logItems[0] ;
            logItems.Delete(0) ;
            Dispose(aItem) ;
        end;
    finally
        LeaveCriticalSection(lckLog) ;
    end;
end;
//------------------------------------------------------------------------------
function TLog.isEqual(aItem, bItem : PLogItem): boolean;
begin
    Result := false ;
    try
        if not Assigned(aItem) then Exit ;
        if not Assigned(bItem) then Exit ;

        if (aItem = bItem) then                     // Meme pointeur
        begin
            Result := true ;
            Exit ;
        end;

        if aItem^.host <> bItem^.host then Exit ;
        if aItem^.app  <> bItem^.app  then Exit ;
        if aItem^.inst <> bItem^.inst then Exit ;
        if aItem^.mdl  <> bItem^.mdl  then Exit ;
        if aItem^.ref  <> bItem^.ref  then Exit ;
        if aItem^.key  <> bItem^.key  then Exit ;
        if aItem^.val  <> bItem^.val  then Exit ;
        if aItem^.lvl  <> bItem^.lvl  then Exit ;

        Result := true ;
    except
    end;
end;
//------------------------------------------------------------------------------
procedure TLog.Log(aMdl, aRef, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean);
var
    ia    : integer ;
    aItem : PLogItem ;
    bItem : PLogItem ;
    bNew  : boolean ;
begin
    if not fOpened then Exit ;
    if newItems.Count > fMaxNewItems then Exit ;

    try
        bNew := true ;

        New(aItem) ;
        aItem^.date := now ;
        aItem^.host := fHost ;
        aItem^.app  := fApp ;
        aItem^.inst := fInst ;
        aItem^.mdl  := aMdl ;
        aItem^.ref  := aRef ;
        aItem^.key  := aKey ;
        aItem^.val  := aVal ;
        aItem^.lvl  := aLvl ;
        aItem^.ovl  := aOvl ;
        aItem^.nb   := 1 ;
        aItem^.store := false ;
        aItem^.send  := sendNone ;

        EnterCriticalSection(lcknew) ;
        try
            for ia := 0 to newItems.Count - 1 do
            begin
                bItem := newItems[ia] ;

                if isEqual(aItem, bItem) then
                begin
                    Dispose(aItem) ;
                    aItem := bItem ;
                    Inc(aItem^.nb) ;
                    bNew := false ;

                    break ;
                end;
            end ;

            if bNew then
            begin
                newItems.Add(aItem) ;
            end;

        finally
            LeaveCriticalSection(lckNew) ;
        end;
    except
    end;
end;
//------------------------------------------------------------------------------
procedure TLog.Log(aMdl, aRef, aKey: string; aVal: Int64; aLvl: TLogLevel; aOvl: boolean);
begin
    Log(aMdl, aRef, aKey, IntToStr(aVal), aLvl, aOvl) ;
end;
//------------------------------------------------------------------------------
procedure TLog.Log(aMdl, aRef, aKey: string; aVal: Boolean; aLvl: TLogLevel; aOvl: boolean);
begin
    if aVal
        then Log(aMdl, aRef, aKey, '1', aLvl, aOvl)
        else Log(aMdl, aRef, aKey, '0', aLvl, aOvl) ;
end;
//------------------------------------------------------------------------------
procedure TLog.Log(aMdl, aRef, aKey: string; aVal: Extended; aLvl: TLogLevel; aOvl: boolean);
begin
    Log(aMdl, aRef, aKey, FloatToStr(aVal), aLvl, aOvl) ;
end;
//------------------------------------------------------------------------------
class function TLog.LogLevelToStr(aLogLevel: TLogLevel): string;
var
    ia : integer ;
begin
    ia := Ord(aLogLevel) ;

    if (ia < 0) or (ia > 8) then
    begin
        Result := '   ' ;
        Exit ;
    end;

    Result := LogLevelTri[ia] ;
end;
//------------------------------------------------------------------------------
class function TLog.StrToLogLevel(aLevel : string) : TLogLevel ;
var
    ia : integer ;
begin
    Result := logNone ;

    aLevel := uppercase(aLevel) ;

    for ia := 0 to 8 do
    begin
        if (aLevel = LogLevelTri[ia])
            then Result := TLogLevel(ia) ;
    end;
end;
//------------------------------------------------------------------------------
procedure TLog.readIni(aFileName: string);
var
    iniFile : TIniFile ;
    ia      : integer ;
    iNbSrv  : integer ;
begin
    if (aFilename = '')
        then aFilename := fDefaultConfigFileName ;

    iniFile := TIniFile.Create(aFileName) ;

    try

    // Servers List
    iNbSrv := iniFile.ReadInteger('Log', 'nbServers', 0) ;
    setlength(Servers, iNbSrv) ;

    for ia := 1 to iNbSrv do
    begin
        Servers[ia-1].name := iniFile.ReadString('Log', 'serverName_' + IntToStr(ia), 'Serveur ' + IntToStr(ia)) ;
        Servers[ia-1].host := iniFile.ReadString('Log', 'serverHost_' + IntToStr(ia), '') ;
        Servers[ia-1].port := iniFile.ReadInteger('Log', 'serverPort_' + IntToStr(ia), 0) ;
    end;

    fMinLogLevel  := TLogLevel(iniFile.ReadInteger('Log', 'minLogLevel', Ord(fMinLogLevel))) ;
    fMinSendLevel := TLogLevel(iniFile.ReadInteger('Log', 'minSendLevel', Ord(fMinSendLevel))) ;
    fMaxNewItems  := iniFile.ReadInteger('Log', 'maxNewItems', fMaxNewItems) ;
    fMaxLogItems  := iniFile.ReadInteger('Log', 'maxLogItems', fMaxLogItems) ;
    fLogKeepDays  := iniFile.ReadInteger('Log', 'logKeepDays', fLogKeepDays) ;
    fLogFileName  := iniFile.ReadString('Log', 'logFileName', fLogFileName) ;


    fConfigured := true ;
    finally
        iniFile.Free ;
    end ;
end;
//------------------------------------------------------------------------------
procedure TLog.saveIni(aFileName: string);
var
    iniFile : TIniFile ;
  ia: Integer;
begin
    if (aFilename = '')
        then aFilename := fDefaultConfigFileName ;

    iniFile := TIniFile.Create(aFileName) ;

    try

    // Servers List
    iniFile.WriteInteger('Log', 'nbServers', Length(Servers));

    for ia := 1 to Length(Servers) do
    begin
        iniFile.WriteString('Log', 'serverName_' + IntToStr(ia), Servers[ia-1].name);
        iniFile.WriteString('Log', 'serverHost_' + IntToStr(ia), Servers[ia-1].host);
        iniFile.WriteInteger('Log', 'serverPort_' + IntToStr(ia), Servers[ia-1].port);
    end;

    iniFile.WriteInteger('Log', 'minLogLevel', Ord(fMinLogLevel)) ;
    iniFile.WriteInteger('Log', 'minSendLevel', Ord(fMinSendLevel)) ;
    iniFile.WriteInteger('Log', 'maxNewItems', fMaxNewItems) ;
    iniFile.WriteInteger('Log', 'maxLogItems', fMaxLogItems) ;
    iniFile.WriteInteger('Log', 'logKeepDays', fLogKeepDays) ;
    iniFile.WriteString('Log', 'logFileName', fLogFileName) ;

    finally
        iniFile.Free ;
    end ;
end;
//------------------------------------------------------------------------------
procedure TLog.Open;
begin
    clearNewItems ;
    clearLogItems ;

    if not fConfigured
        then readIni ;

    loadItems ;

    fOpened := true ;

    Resume ;
end;
//------------------------------------------------------------------------------
procedure TLog.Close;
begin
    fOpened := false ;
end;
//------------------------------------------------------------------------------
function TLog.ItemToJSON(aItem: TLogItem): string;
var
    sa : AnsiString ;
begin
    sa := '' ;
    try
        sa :=       '{' ;
        sa := sa + '"date":"' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzzz"Z"', aItem.date) + '",' ;
        sa := sa + '"host":"' + JSONEscapeValue(aItem.host) + '",' ;
        sa := sa + '"app":"'  + JSONEscapeValue(aItem.app) + '",' ;

        if (aItem.inst <> '')
            then sa := sa + '"inst":"' + JSONEscapeValue(aItem.inst) + '",' ;

        if (aItem.mdl <> '')
            then sa := sa + '"mdl":"'  + JSONEscapeValue(aItem.mdl) + '",' ;

        if (aItem.ref <> '')
            then sa := sa + '"ref":"'  + JSONEscapeValue(aItem.ref) + '",' ;

        sa := sa + '"key":"'  + JSONEscapeValue(aItem.key) + '",' ;
        sa := sa + '"val":"'  + JSONEscapeValue(aItem.val) + '",' ;

        if (aItem.nb > 1)
            then sa := sa + '"nb":' + IntTostr(aItem.nb) + ',' ;

        sa := sa + '"lvl":'   + IntToStr(Ord(aItem.lvl)) + ',' ;

        if aItem.ovl
            then sa := sa + '"ovl":true'
            else sa := sa + '"ovl":false' ;

        sa := sa +  '}' ;
    except
    end;

    Result := sa ;
end;
//------------------------------------------------------------------------------
class function TLog.JSONEscapeValue(aStr : string) : AnsiString ;
var
    sa : AnsiString ;
    ia : integer ;
    ca : Char ;
begin
    sa := '' ;
    try
        for ca in aStr do
        begin
            case ca of
                '"' : sa := sa + '\"' ;
                '\' : sa := sa + '\\' ;
                '/' : sa := sa + '\/' ;
                #8  : sa := sa + '\b' ;
                #9  : sa := sa + '\t' ;
                #10 : sa := sa + '\n' ;
                #12 : sa := sa + '\f' ;
                #13 : sa := sa + '\r' ;
            else
                begin
                    if ((Ord(ca) < 32) or (Ord(ca) > 126)) then
                    begin
                        sa := sa + '\u' + IntToHex(Ord(ca),4) ;
                    end else begin
                        sa := sa + ca ;
                    end;
                end;
            end;
        end;
    except
    end;
    Result := sa ;
end;
//------------------------------------------------------------------------------
procedure TLog.cleanupLogFiles ;
var
    sSearch  : string ;
    sFilename : string ;
    srSearch : TSearchRec ;
begin
    if fLogKeepDays < 1 then Exit ;

    try
        sSearch := ExpandFileName(fLogFileName) ;
        sSearch := stringreplace(sSearch, '{%DATE}', '????-??-??', [rfReplaceAll]) ;
        sSearch := stringreplace(sSearch, '{%APP}', fApp, [rfReplaceAll]) ;
        sSearch := stringreplace(sSearch, '{%INST}', fInst, [rfReplaceAll]) ;

        if FindFirst(sSearch, (faAnyFile and not faDirectory), srSearch) = 0 then
        begin
            repeat
                sFileName := ExtractFilePath(sSearch) + srSearch.Name ;
                if ( FileDateToDateTime(srSearch.Time) < (now - fLogKeepDays) ) then
                begin
                    SysUtils.DeleteFile(  sFileName ) ;
                end;
            until FindNext(srSearch) <> 0 ;
        end;
    except
    end;
end;
//==============================================================================
initialization
    Winsock.WSAStartup(MakeWord(2,2), WSAData) ;
    Log := TLog.Create ;
//------------------------------------------------------------------------------
finalization
   Log.Free ;
   WSACleanup ;

//==============================================================================
end.
