unit uLog;

interface

uses Classes, System.SysUtils, System.StrUtils, system.UITypes, Windows, Winsock, Contnrs, SyncObjs, iniFiles, idTCPClient, fmx.Graphics ;

//==============================================================================
const
    LogLevelTri   : array[0..8] of string = ('   ', 'DGB', 'TRA', 'INF', 'NOT', 'WAR', 'ERR', 'CRI', 'EMG') ;
    LogLevelStr   : array[0..8] of string = ('', 'Debug', 'Trace', 'Info', 'Notice', 'Warning', 'Error', 'Critical', 'Emergency') ;
    LogLevelColor : Array[0..8] of TColor = ($00000000, $00C0C0C0, $00A0A0A0, $0000A000, $00C0A000, $0000A0C0, $000000C0, $000000FF, $000000FF) ;
    LogVersion  : integer = 2 ;

type
    TLogElement = (elDate, elHost, elApp, elInst, elSrv, elMdl, elDos, elRef, elKey, elValue, elLevel, elNb, elData) ;
    TLogElements = set of TLogElement ;
    TLogLevel = (logNone, logDebug, logTrace, logInfo, logNotice, logWarning, logError, logCritical, logEmergency) ;
    TLogSendState = (sendNone, sendWait, sendDo, sendDone) ;
    TLogType = (ltNone, ltLocal, ltServer, ltBoth) ;

const
    elAll : TLogElements = [elDate, elHost, elApp, elInst, elSrv, elMdl, elDos, elRef, elKey, elValue, elLevel, elNb, elData] ;
    elDefault : TLogElements = [elDate, elSrv, elMdl, elDos, elRef, elKey, elValue, elLevel, elNb] ;
type
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
        host : string[15] ;
        app  : string[20] ;
        inst : string[4] ;
        srv  : string[31] ;
        mdl  : string[20] ;
        dos  : string[63] ;
        ref  : string[63] ;
        key  : string[90] ;
        val  : string[255] ;
        data : PAnsiChar ;
        size : Int64 ;
        lvl  : TLogLevel ;
        ovl  : boolean ;
        freq : integer;
        nb   : word ;
        store : boolean ;
        send  : TLogSendState ;
    end;
//------------------------------------------------------------------------------
    TLogEvent = procedure(aSender : TObject ; aLog : TLogItem) of object ;
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
        fSrv    : string ;
        fDoss   : string ;

        fFreq   : integer;

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

        fOnLog  : TLogEvent ;
        fOnLogItem : TLogItem ;

        FSynchronized : boolean ;
        SendBuffer : AnsiString ;
        FLastError: string;
        FFileLogFormat: TLogElements;
        fDeboublonage : boolean;

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

        procedure doOnLog ;
		    procedure InternalError(aMsg : string) ;
    protected
        procedure Execute ; override ;

    public
        constructor Create ; reintroduce ;
        destructor Destroy ; override ;

        procedure Open ;
        procedure Close ;

        procedure readIni(aFileName : string = '') ;
        procedure saveIni(aFileName : string = '') ;

        procedure Log(aSrv, aMdl, aDos, aRef, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = 0 ; aSend : TLogType = ltBoth) ; overload ;
        procedure Log(aSrv, aMdl, aDos, aRef, aKey : string ; aVal : Int64 ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = 0) ; overload ;
        procedure Log(aSrv, aMdl, aDos, aRef, aKey : string ; aVal : Extended ; aLvl : TLogLevel ; aOvl : boolean = false;aFreq : integer = 0) ; overload ;

        procedure Log(aSrv, aMdl, aDos, aRef, aKey : string ; aVal : Boolean ; aLvl : TLogLevel ; aOvl : boolean = false;aFreq : integer = 0) ; overload ;
        procedure Log(aMdl, aRef, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = 0 ; aSend : TLogType = ltBoth) ; overload ;
        procedure LogDT(adate:TDateTime;aSrv, aMdl, aDos, aRef, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean);

        class function LogLevelToStr(aLogLevel : TLogLevel) : string ;
        class function StrToLogLevel(aLevel : string) : TLogLevel ;
        class function FormatLogItem(aLogItem : TLogitem ; aElements : TLogElements) : string ;

        function ItemToJSON(aItem : TLogItem) : string ;
        class function JSONEscapeValue(aStr : string) : AnsiString ;
    published
        property Host : string read fHost write fHost ;
        property App  : string read fApp  write fApp ;
        property Inst : string read fInst write fInst ;
        property Srv  : string read fSrv  write fSrv ;
        property Doss : string read fDoss write fDoss ;

        property Opened : boolean read fOpened ;

        property OnLog : TLogEvent  read FOnLog       write FOnLog ;
        property Synchronized : boolean  read FSynchronized write FSynchronized ;
        property LastError : string   read FLastError ;

        // Valeur des propriété par defaut
        property FileLogLevel : TLogLevel read fMinLogLevel write fMinLogLevel;
        property SendLogLevel : TLogLevel read fMinSendLevel write fMinSendLevel;
        property FileLogFormat : TLogElements read FFileLogFormat  write FFileLogFormat ;
        property Frequence : integer read fFreq write fFreq;
        property LogKeepDays : integer read fLogKeepDays write fLogKeepDays;
        property MaxItems : word read fMaxNewItems write fMaxNewItems;
        property Deboublonage : boolean read fDeboublonage write fDeboublonage;
    end;

//------------------------------------------------------------------------------
    var
        Log : TLog ;
        WSAData : TWSAData ;

//------------------------------------------------------------------------------

function strLPad(aStr : string ; aLen : integer ; aChar : char = ' ') : string ;
function getMachineName : string ;
function getApplicationFileName : string ;
procedure raiseLogLevel(var aLevel : TLogLevel ; aNewLevel : TLogLevel) ;
function getSrvFromPathIB(aStr : string):string;

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
//------------------------------------------------------------------------------
procedure raiseLogLevel(var aLevel : TLogLevel ; aNewLevel : TLogLevel) ;
begin
  if aNewLevel > aLevel
    then aLevel := aNewLevel ;
end;
//------------------------------------------------------------------------------
function getSrvFromPathIB(aStr : string):string;
var i:integer;
begin
     result:=getMachineName;
     i:=Pos(':',aStr);
     if i>2 then
     begin
         result:=Copy(aStr,1,i-1);
     end;
end ;


//==============================================================================
constructor TLog.Create;
begin
    inherited Create(true) ;

    // Default values
    fDefaultConfigFileName  := ChangeFileExt(getApplicationFileName, '.ini') ;
    // Log_Write(fDefaultConfigFileName);
    fDefaultStorageFileName := ChangeFileExt(getApplicationFileName, '.log.tmp') ;

    fLogFileName  := ExtractFilePath(getApplicationFileName) + 'logs'+ PathDelim +'log_{%APP}_{%INST}_{%DATE}.log' ;
    fMinLogLevel  := logInfo ;
    fMinSendLevel := logInfo ;
    fLogKeepDays  := 1 ;            // Les logs sont gardés 1 semaine
    fMaxNewItems  := 1000  ;        // On ne garde pas plus de 1000 items en tampon
    fMaxLogItems  := 10000 ;        // On ne garde pas plus de 10000 items en memoire

    fHost := getMachineName ;
    fApp  := ChangeFileExt(ExtractFileName(getApplicationFileName),'') ;
    fInst := '' ;

    fFreq := 86400;
    FFileLogFormat := elDefault ;

    fOpened := false ;
    fConfigured := false ;

    InitializeCriticalSection(lckNew) ;
    InitializeCriticalSection(lckLog) ;
    InitializeCriticalSection(lckSend) ;

    newItems  := TList.Create ;
    logItems  := TList.Create ;
    sendItems := TList.Create ;

    SendBuffer := '' ;
    FLastError := 'Ok' ;

    CurrentServer := 0 ;
    FSynchronized := true ;

    fDeboublonage := true;

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
        try
          FLastError := 'Running' ;
          while ((getTickCount < nextTC) and (not Terminated)) do
              sleep(50) ;

          nextTC := getTickCount + 1000 ;

          if getNewItems then
          begin
            FLastError := 'New Items' ;
            storeItems ;
          end;

          logToFile ;
          sendToServer ;
          cleanSendItems ;

          if ((slowTC < getTickCount) and (not Terminated)) then
          begin

              slowTC := getTickCount + (1000*60) ;
              cleanupLogFiles ;
          end ;


          if ((not fOpened) and (not Terminated)) then Suspend ;
        except
          on E:Exception do InternalError('Execute : ' + e.message);
        end;
    end ;

    if getNewItems then
        logToFile ;
    storeItems ;
end;
//------------------------------------------------------------------------------
function TLog.getNewItems : boolean ;
var
    aItem : PLogItem ;
    ba    : boolean ;
begin
    Result := false ;

    try
      EnterCriticalSection(lckLog) ;
      EnterCriticalSection(lckSend) ;
      try
          while newItems.Count > 0 do
          begin

              EnterCriticalSection(lckNew) ;
              try
                aItem := newItems[0] ;
                newItems.Delete(0) ;

                fOnLogItem := aItem^;
              finally
                LeaveCriticalSection(lckNew) ;
              end;

              if Assigned(FOnLog) then
              begin
                if FSynchronized
                  then synchronize(doOnLog)
                  else doOnLog ;
              end;

              if ((aItem^.lvl < fMinLogLevel) and (not aItem^.ovl))
                then aItem^.store := false ;

              if ((aItem^.lvl < fMinSendLevel) and (not aItem^.ovl))
                then aItem^.send := sendNone ;

              ba := false ;

              if aItem^.store then
              begin
                ba := true ;
                logItems.Add(aItem) ;
              end;

              if (aItem^.send = sendWait) then
              begin
                ba := true ;
                sendItems.Add(aItem) ;
              end;

              if (not ba)
                then Dispose(aItem) ;

              Result := true ;
          end ;

      finally
          LeaveCriticalSection(lckSend) ;
          LeaveCriticalSection(lckLog) ;
      end;

      aItem := nil ;

      EnterCriticalSection(lckLog) ;
      try

          while logItems.Count > fMaxLogItems do
          begin

              aItem := logItems[0] ;
              logItems.Delete(0) ;
              aItem^.store := false ;

              DisposeItem(aItem) ;
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
              aItem^.send := sendNone ;
              DisposeItem(aItem) ;
          end;


      finally
          LeaveCriticalSection(lckSend) ;
      end;
    except
      on E:Exception do InternalError('getNewItems : '  + e.message);
    end;
end;
//------------------------------------------------------------------------------
procedure TLog.InternalError(aMsg: string);
begin
  FLastError := aMsg ;
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
            aItem^.app  := 'LOGFILE' ;
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
		on E:Exception do InternalError('StoreItems : ' + e.message);
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

                if (   (aItem^.app <> 'LOGFILE')
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
                        aItem^.data := nil ;
                        aItem^.size := 0 ;
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
		on E:Exception do InternalError('loadItems : ' + e.message);
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

                    sa := FormatLogItem(aItem^, FFileLogFormat) ;
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
		on E:Exception do InternalError('LogToFile : ' + e.message);
    end;
end;
//------------------------------------------------------------------------------
class function TLog.FormatLogItem(aLogItem: TLogitem ; aElements : TLogElements): string;
var
  sa : string ;
begin
  sa := '' ;
  if elDate in aElements then
    sa := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzzz', aLogItem.date) + ' | ' ;

  if elLevel in aElements then
    sa := sa + LogLevelToStr(aLogItem.lvl) + ' | ' ;

  if elSrv in aElements then
    sa := sa + StrLPad(aLogItem.srv, 31) + ' | ' ;

  if elMdl in aElements then
    sa := sa + StrLPad(aLogItem.mdl, 63) + ' | ' ;

  if elDos in aElements then
    sa := sa + StrLPad(aLogItem.dos, 63) + ' | ' ;

  if elHost in aElements then
    sa := sa + StrLPad(aLogItem.host, 32) + ' | ' ;

  if elApp in aElements then
    sa := sa + StrLPad(aLogItem.app, 32) + ' | ' ;

  if elRef in aElements then
    sa := sa + StrLPad(aLogItem.ref, 32) + ' | ' ;

  if elKey in aElements then
    sa := sa + StrLPad(aLogItem.key, 32) + ' | ' ;

  if elNb in aElements then
    sa := sa + StrLPad(IntToStr(aLogItem.nb), 3) + ' | ' ;

  if elValue in aElements then
    sa := sa + StrLPad(aLogItem.val, 255) + ' | ' ;

  if (elData in aElements) and Assigned(aLogItem.data) and (aLogItem.size > 255)  then
  begin
    sa := sa + #13#10 ;
    sa := sa + '-----------------------------------------------------------------------------------' + #13#10 ;
    sa := sa + aLogItem.data + #13#10 ;
    sa := sa + '-----------------------------------------------------------------------------------' ;
  end;

  Result := sa ;
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
    // Log_Write('sendBufferToServer_1', el_info);

    if Length(SendBuffer) < 1 then Exit ;
    // Log_Write('sendBufferToServer_2', el_info);

    bSent := true ;
    SendBuffer := SendBuffer + ']' ;

    if Length(Servers) > 0 then
    begin
        // Log_Write('sendBufferToServer_3', el_info);
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
                    // Log_Write('TCPCLient.Connect', el_Erreur);
                end;

                if TCPClient.Connected then
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
        // Log_Write('sendBufferToServer_4', el_info);
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
		on E:Exception do InternalError(e.message);
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
        if Assigned(aItem^.data) and (aItem^.size > 0)
          then FreeMem(aItem^.data, aItem^.size) ;

        Dispose(aItem) ;
    end;
end;
//------------------------------------------------------------------------------
procedure TLog.doOnLog;
begin
  if Assigned(FOnLog) then
  begin
    try
      fOnLog(Self, FOnLogItem) ;
    except
		on E:Exception do InternalError('doOnLog : ' + e.message);
    end;
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
			      aItem^.send := sendNone ;
            DisposeItem(aItem) ;
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
			aItem^.store := false ; 
            DisposeItem(aItem) ;
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
        if aItem^.srv  <> bItem^.srv  then Exit ;
        if aItem^.mdl  <> bItem^.mdl  then Exit ;
        if aItem^.dos  <> bItem^.dos  then Exit ;
        if aItem^.ref  <> bItem^.ref  then Exit ;
        if aItem^.key  <> bItem^.key  then Exit ;
        if aItem^.val  <> bItem^.val  then Exit ;
        if aItem^.lvl  <> bItem^.lvl  then Exit ;

        Result := true ;
    except
    end;
end;

//------------------------------------------------------------------------------
procedure TLog.LogDT(adate:TDateTime;aSrv, aMdl, aDos, aRef, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean);
var
    ia    : integer ;
    aItem : PLogItem ;
    bItem : PLogItem ;
    bNew  : boolean ;
begin
    if not fOpened then Exit ;
    if newItems.Count > fMaxNewItems then 
	begin
		FLastError := 'Overload' ; 
		Exit ; 
	end ; 

    try
        bNew := true ;

        New(aItem) ;
        aItem^.date := adate;
        aItem^.host := fHost ;
        aItem^.app  := fApp ;
        aItem^.inst := fInst ;
        aItem^.srv  := aSrv ;
        aItem^.mdl  := aMdl ;
        aItem^.dos  := aDos ;
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
            {
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
            }

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
procedure TLog.Log(aSrv, aMdl, aDos, aRef, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean = false ; aFreq:integer = 0 ; aSend : TLogType = ltBoth);
var
    ia    : integer ;
    aItem : PLogItem ;
    bItem : PLogItem ;
    bNew  : boolean ;
    vStr  : AnsiString ;
begin
    if not fOpened
      then Exit ;
    if newItems.Count > fMaxNewItems
      then Exit ;
    if (aLvl < FMinLogLevel) and (aLvl < FMinSendLevel)
      then Exit ;

    try
        bNew := true ;

        New(aItem) ;
        aItem^.date := now ;
        aItem^.host := fHost ;
        aItem^.app  := fApp ;
        aItem^.inst := fInst ;
        aItem^.srv  := aSrv ;
        aItem^.mdl  := aMdl ;
        aItem^.dos  := aDos ;
        aItem^.ref  := aRef ;
        aItem^.key  := aKey ;
        aItem^.val  := aVal ;
        aItem^.lvl  := aLvl ;
        aItem^.ovl  := aOvl ;
        aItem^.size := 0 ;
        aItem^.data := nil ;

        if aFreq = 0
          then aItem^.freq := fFreq
          else aItem^.freq := aFreq ;

        aItem^.nb   := 1 ;

        if aSend in [ltLocal, ltBoth]
          then aItem^.store := true
          else aItem^.store := false ;

        if aSend in [ltServer, ltBoth]
          then aItem^.send  := sendWait
          else aItem^.send  := sendNone ;




        EnterCriticalSection(lcknew) ;
        try
            if fDeboublonage then
            begin
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
            end ;

            if bNew then
            begin
                vStr := AnsiString(aVal) ;

                aItem^.size := Length(vStr) + 1 ;
                getMem(aItem^.data, aItem^.size) ;
                ZeroMemory(aItem^.data, aItem^.size) ;
                Move(vStr[1], aItem^.data^, aItem^.size - 1) ;

                newItems.Add(aItem) ;
            end;

        finally
            LeaveCriticalSection(lckNew) ;
        end;
    except
		on E:Exception do InternalError('Log : ' + e.message);
    end;
end;
//------------------------------------------------------------------------------
procedure TLog.Log(aSrv,aMdl, aDos, aRef, aKey: string; aVal: Int64; aLvl: TLogLevel; aOvl: boolean; aFreq:integer);
begin
    Log(aSrv, aMdl, aDos, aRef, aKey, IntToStr(aVal), aLvl, aOvl, aFreq);
end;
//------------------------------------------------------------------------------
procedure TLog.Log(aSrv,aMdl, aDos, aRef, aKey: string; aVal: Boolean; aLvl: TLogLevel; aOvl: boolean;aFreq:integer);
begin
    if aVal
        then Log(aSrv,aMdl, aDos, aRef, aKey, '1', aLvl, aOvl, aFreq)
        else Log(aSrv,aMdl, aDos, aRef, aKey, '0', aLvl, aOvl, aFreq) ;
end;
//------------------------------------------------------------------------------
procedure TLog.Log(aSrv,aMdl, aDos, aRef, aKey: string; aVal: Extended; aLvl: TLogLevel; aOvl: boolean;aFreq:integer);
begin
    Log(aSrv,aMdl, aDos, aRef, aKey, FloatToStr(aVal), aLvl, aOvl, aFreq) ;
end;
//------------------------------------------------------------------------------
procedure TLog.Log(aMdl, aRef, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean = false ; aFreq: integer  = 0 ; aSend : TLogType = ltBoth);
begin
  Log(fSrv, aMdl, fDoss, aRef, aKey, aVal, aLvl, aOvl, aFreq, aSend) ;
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

        fHost := iniFile.ReadString('Log', 'host', GetMachineName) ;

        // Servers List
        iNbSrv := iniFile.ReadInteger('Log', 'nbServers', 1) ;
        setlength(Servers, iNbSrv) ;

        for ia := 1 to iNbSrv do
        begin
            Servers[ia-1].name := iniFile.ReadString('Log', 'serverName_' + IntToStr(ia), 'logs') ;
            Servers[ia-1].host := iniFile.ReadString('Log', 'serverHost_' + IntToStr(ia), 'logs.ginkoia.eu') ;
            Servers[ia-1].port := iniFile.ReadInteger('Log', 'serverPort_' + IntToStr(ia), 8080) ;
        end;

        fMinLogLevel  := TLogLevel(iniFile.ReadInteger('Log', 'minLogLevel', Ord(fMinLogLevel))) ;
        fMinSendLevel := TLogLevel(iniFile.ReadInteger('Log', 'minSendLevel', Ord(fMinSendLevel))) ;
        fMaxNewItems  := iniFile.ReadInteger('Log', 'maxNewItems', fMaxNewItems) ;
        fMaxLogItems  := iniFile.ReadInteger('Log', 'maxLogItems', fMaxLogItems) ;
        fLogKeepDays  := iniFile.ReadInteger('Log', 'logKeepDays', fLogKeepDays) ;
        fLogFileName  := iniFile.ReadString('Log', 'logFileName', fLogFileName) ;

        fFreq         := iniFile.ReadInteger('Log', 'frequence', fFreq) ;
        fDeboublonage := iniFile.ReadBool('Log', 'deboublonage', fDeboublonage) ;

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

        iniFile.WriteInteger('Log', 'frequence', fFreq) ;

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
        // sa := sa + '"date":"' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzzz"Z"', aItem.date) + '",' ;
        sa := sa + '"date":"' + FormatDateTime('yyyy-mm-dd hh:nn:ss', aItem.date) + '",' ;
        sa := sa + '"host":"' + JSONEscapeValue(aItem.host) + '",' ;
        sa := sa + '"app":"'  + JSONEscapeValue(aItem.app) + '",' ;

        if (aItem.inst <> '')
            then sa := sa + '"inst":"' + JSONEscapeValue(aItem.inst) + '",' ;

        if (aItem.srv <> '')
            then sa := sa + '"srv":"'  + JSONEscapeValue(aItem.srv) + '",' ;

        if (aItem.mdl <> '')
            then sa := sa + '"mdl":"'  + JSONEscapeValue(aItem.mdl) + '",' ;

        if (aItem.dos <> '')
            then sa := sa + '"dos":"'  + JSONEscapeValue(aItem.dos) + '",' ;

        if (aItem.ref <> '')
            then sa := sa + '"ref":"'  + JSONEscapeValue(aItem.ref) + '",' ;

        sa := sa + '"key":"'  + JSONEscapeValue(aItem.key) + '",' ;
        sa := sa + '"val":"'  + JSONEscapeValue(aItem.val) + '",' ;

        if (aItem.nb > 1)
            then sa := sa + '"nb":' + IntTostr(aItem.nb) + ',' ;

        sa := sa + '"lvl":'   + IntToStr(Ord(aItem.lvl)) + ',' ;

        if aItem.ovl
            then sa := sa + '"ovl":true,'
            else sa := sa + '"ovl":false,' ;

        sa := sa + '"freq":'   + IntToStr(aItem.freq) ;

        sa := sa +  '}' ;
    except
    end;

    Result := sa ;
end;
//------------------------------------------------------------------------------
class function TLog.JSONEscapeValue(aStr : string) : AnsiString ;
var
    sa : AnsiString ;
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
                    system.SysUtils.DeleteFile(  sFileName ) ;
                end;
            until FindNext(srSearch) <> 0 ;
        end;
    except
		on E:Exception do InternalError('cleanupLogFiles : ' + e.message);
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
