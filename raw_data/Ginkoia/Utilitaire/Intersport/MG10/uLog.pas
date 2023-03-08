unit uLog;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

{
  SCO 31/03/2020 On désactive des warnings de compilations qui ne seront jamais corrigé dans ce fichier :
    W1057 : IMPLICIT_STRING_CAST
    W1058 : IMPLICIT_STRING_CAST_LOSS
  Cette désactivation est effective uniquement dans le fichier courant
  Si vous pendez que ça pose problème merci de me contacter.
}
{$IF CompilerVersion >= 23.0} //23.0 = Delphi Seattle
  {$WARN IMPLICIT_STRING_CAST OFF}
  {$WARN IMPLICIT_STRING_CAST_LOSS OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
{$IFEND}

interface

uses
{$IF CompilerVersion > 27}
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  Winapi.Windows,
  Winapi.Winsock,
  System.Contnrs,
  System.SyncObjs,
  System.iniFiles,
  idTCPClient,
  System.Math ;
{$ELSE}
  Classes,
  SysUtils,
  StrUtils,
  Windows,
  Winsock,
  Contnrs,
  SyncObjs,
  iniFiles,
  idTCPClient,
  Math ;
{$IFEND}

{$M+}

//==============================================================================
type
    PColor = ^TColor;
    TColor = -$7FFFFFFF-1..$7FFFFFFF;

    TLogElement = (elDate, elHost, elApp, elInst, elSrv, elMdl, elDos, elRef, elMag, elKey, elValue, elLevel, elNb, elData) ;
    TLogElements = set of TLogElement ;
    TLogLevel = (logNone, logDebug, logTrace, logInfo, logNotice, logWarning, logError, logCritical, logEmergency) ;
    TLogSendState = (sendNone, sendWait, sendDo, sendDone) ;
    TLogType = (ltNone, ltLocal, ltServer, ltBoth) ;

const
    elAll : TLogElements = [elDate, elHost, elApp, elInst, elSrv, elMdl, elDos, elRef, elMag, elKey, elValue, elLevel, elNb, elData] ;
    elDefault : TLogElements = [elDate, elSrv, elMdl, elDos, elRef, elMag, elKey, elValue, elLevel, elNb] ;
    LogLevelTri   : array[0..8] of string = ('   ', 'DGB', 'TRA', 'INF', 'NOT', 'WAR', 'ERR', 'CRI', 'EMG') ;
    LogLevelStr   : array[0..8] of string = ('', 'Debug', 'Trace', 'Info', 'Notice', 'Warning', 'Error', 'Critical', 'Emergency') ;
{$IFDEF LogsPastelColors}
    LogLevelColor : Array[0..8] of TColor = ($00000000, $00C0C0C0, $00A0A0A0, $0059b100, $00DBAE00, $003577f3, $004111d1, $004111d1, $004111d1) ;
{$ELSE}
    LogLevelColor : Array[0..8] of TColor = ($00000000, $00C0C0C0, $00A0A0A0, $0000A000, $00C0A000, $0000A0C0, $000000C0, $000000FF, $000000FF) ;
{$ENDIF}

    LogVersion  : integer = 4 ;
    LOG_SECTION = 'Log' ;
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
        mag  : string[31];
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
        fRef    : string ; 
        fMag    : string ; 

        fFreq   : integer;

        fMinLogLevel  : TLogLevel ;
        fMinSendLevel : TLogLevel ;
        fLogKeepDays  : integer ;
        fMaxNewItems  : word ;
        fMaxLogItems  : word ;

        fRelativPath : boolean;
        fLogFilePath  : string ;
        fLogFileName  : string ;

        fDefaultConfigFileName  : string ;
        fDefaultStorageFileName : string ;

        fConfigured : boolean ;
        fOpened : boolean ;

        fOnLog  : TLogEvent ;
        fOnLogItem : TLogItem ;
        FOnInternalError : TNotifyEvent ; 

        FSynchronized : boolean ;

        SendBuffer : AnsiString ;
        FLastError: string;
        FFileLogFormat: TLogElements;
        fDeboublonage : boolean;
        fSendOnClose : boolean;
        fFinalSendDelay: Integer;

        function getNewItems : boolean ;
        procedure storeItems ;
        procedure loadItems ;
        procedure logToFile ;
        function sendToServer : boolean ;

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
        procedure doOnInternalError ; 
    protected
        procedure Execute ; override ;

    public
        constructor Create ; reintroduce ;
        destructor Destroy ; override ;

        procedure Open ;
        procedure Close ;

        procedure readIni(aFileName : string = '') ;
        procedure saveIni(aFileName : string = '') ;

        procedure Log(aApp, aInst, aSrv, aMdl, aDos, aRef, aMag, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = -1 ; aSend : TLogType = ltBoth) ; overload ;
        procedure Log(aSrv, aMdl, aDos, aRef, aMag, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = -1 ; aSend : TLogType = ltBoth) ; overload ;
        procedure Log(aSrv, aMdl, aDos, aRef, aMag, aKey : string ; aVal : Int64 ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = -1) ; overload ;
        procedure Log(aSrv, aMdl, aDos, aRef, aMag, aKey : string ; aVal : Extended ; aLvl : TLogLevel ; aOvl : boolean = false;aFreq : integer = -1) ; overload ;
        procedure Log(aSrv, aMdl, aDos, aRef, aMag, aKey : string ; aVal : Boolean ; aLvl : TLogLevel ; aOvl : boolean = false;aFreq : integer = -1) ; overload ;
        procedure Log(aMdl, aRef, aMag, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = -1 ; aSend : TLogType = ltBoth) ; overload ;
        procedure Log(aMdl, aRef, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = -1 ; aSend : TLogType = ltBoth) ; overload ;
        procedure Log(aMdl, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = -1 ; aSend : TLogType = ltServer) ; overload ;

        procedure LogDT(adate:TDateTime;aSrv, aMdl, aDos, aRef, aMag, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean);

        class function LogLevelToStr(aLogLevel : TLogLevel) : string ;
        class function LogLevelToString(aLogLevel: TLogLevel): string;
        class function StrToLogLevel(aLevel : string) : TLogLevel ;
        class function FormatLogItem(aLogItem : TLogitem ; aElements : TLogElements) : string ;

        function ItemToJSON(aItem : TLogItem) : string ;
        class function JSONEscapeValue(aStr : string) : AnsiString ;
        class function JSEscape(aStr : string) : AnsiString ;
    published
        property Host : string read fHost write fHost ;
        property App  : string read fApp  write fApp ;
        property Inst : string read fInst write fInst ;
        property Srv  : string read fSrv  write fSrv ;
        property Doss : string read fDoss write fDoss ;
        property Ref  : string read fRef  write fRef ;
        property Mag  : string read fMag  write fMag ;

        property Opened : boolean read fOpened ;

        property OnLog : TLogEvent  read FOnLog       write FOnLog ;
        property OnInternalError : TNotifyEvent read FOnInternalError write FOnInternalError ;

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
        property SendOnClose : boolean read fSendOnClose write fSendOnClose;
        property finalSendDelay : Integer read fFinalSendDelay write fFinalSendDelay ;

        property LogFilePath : string read fLogFilePath write fLogFilePath;
    end;

//------------------------------------------------------------------------------
    var
        Log : TLog ;
        WSAData : TWSAData ;

//------------------------------------------------------------------------------

function ReadFileVersion(Fichier : string; Precision : Integer)  : String;
function strLPad(aStr : string ; aLen : integer ; aChar : char = ' ') : string ;
function getMachineName : string ;
function getApplicationFileName : string ;
procedure raiseLogLevel(var aLevel : TLogLevel ; aNewLevel : TLogLevel) ;
function getSrvFromPathIB(aStr : string):string;
function DateTimeToIso8601(aDte : TDateTIme) : string ;

//==============================================================================

implementation
//==============================================================================
function ReadFileVersion(Fichier : string; Precision : Integer)  : String;
var
  Dummy : DWORD;
  Info : Pointer;
  InfoSize : Cardinal;
  VerValue : PVSFixedFileInfo;
  InfoDataSize : Cardinal;
begin
  Result := '';

  if Trim(Fichier) = '' then
    Fichier := ParamStr(0);
  if FileExists(Fichier) then
  begin
    try
      InfoSize := GetFileVersionInfoSize(PChar(Fichier), Dummy);
      GetMem(Info, InfoSize);
      try
        if not GetFileVersionInfo(PChar(Fichier), Dummy, InfoSize, Info) then
          RaiseLastOSError();
        if not VerQueryValue(Info, '\', Pointer(VerValue), InfoDataSize) then
          RaiseLastOSError();
        with VerValue^ do
        begin
          if Precision > 0 then
            Result := IntToStr(VerValue^.dwFileVersionMS shr 16);
          if Precision > 1 then
            Result := Result + '.' + IntToStr(VerValue^.dwFileVersionMS and $FFFF);
          if Precision > 2 then
            Result := Result + '.' + IntToStr(VerValue^.dwFileVersionLS shr 16);
          if Precision > 3 then
            Result := Result + '.' + IntToStr(VerValue^.dwFileVersionLS and $FFFF);
        end;
      finally
        FreeMem(Info, InfoSize);
      end;
    except
      on e : exception do
      begin
        Result := '';
      end;
    end;
  end;
end;
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

{$IF CompilerVersion > 27}
     if Winapi.Winsock.gethostname(pAnsiChar(HName), sizeof(Name)) = 0 then
{$ELSE}
     if Winsock.gethostname(pAnsiChar(HName), sizeof(Name)) = 0 then
{$IFEND}
     begin
          Result := StrPas(HName^) ;
     end ;

     Dispose(HName) ;
end ;
//------------------------------------------------------------------------------
function DateTimeToIso8601(aDte : TDateTIme) : string ;
var
  aTz : TTimeZoneInformation ;
  aIsoDte : string ;
  aOffset : integer;
  aTzCurr : Cardinal ;
begin
  aTzCurr := GetTimeZoneInformation(aTz) ;
  aIsoDte := FormatDateTime('yyyy-mm-dd', aDte) + 'T' + FormatDateTime('hh:nn:ss.zzz', aDte) ;

  if aTzCurr = TIME_ZONE_ID_DAYLIGHT
    then aOffset := (aTz.Bias + aTz.DaylightBias) div -60
    else aOffset := (aTz.Bias + aTz.StandardBias) div -60 ;

  if aOffset >= 0
    then aIsoDte := aIsoDte + '+' ;

  aIsoDte := aIsoDte + Format('%.2d', [aOffset]) ;

  Result := aIsoDte ;
end;
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

    fRelativPath  := false;
    fLogFilePath  := IncludeTrailingPathDelimiter(ExtractFilePath(getApplicationFileName) + 'logs');
    fLogFileName  := 'log_{%APP}_{%INST}_{%DATE}.log' ;
    fMinLogLevel  := logInfo ;
    fMinSendLevel := logInfo ;
    fLogKeepDays  := 7 ;            // Les logs fichier sont gardés 1 semaine
    fMaxNewItems  := 1000  ;        // On ne garde pas plus de 1000 items en tampon
    fMaxLogItems  := 10000 ;        // On ne garde pas plus de 10000 items en memoire

    fHost := getMachineName ;
    fApp  := ChangeFileExt(ExtractFileName(getApplicationFileName),'') ;
    fInst := '' ;
    fRef  := '' ;
    fMag  := '' ;
    fDoss := '' ;

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

    fDeboublonage   := true;
    fSendOnClose    := false;
    fFinalSendDelay := 5 ;      // Tenter d'envoyer pendant 5 seconde à la fin

    FOnInternalError := nil ;

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
	sendTC  : DWord ;
	currTC  : DWord ;
	sendDelay : DWord ;
begin
    inherited ;

    nextTC := getTickCount ;
    slowTC := getTickCount ;
	  sendTC := getTickCount ;
	  sendDelay := 1000 ;

    while not Terminated do
    begin
        try
          FLastError := 'Running' ;
          while ((getTickCount < nextTC) and (not Terminated)) do
          begin
            sleep(50) ;
          end ;

		      currTC := getTickCount ;
          nextTC := currTC + 1000 ;

          if getNewItems then
          begin
            FLastError := 'New Items' ;
            storeItems ;
          end;


          logToFile ;

          if ((sendTC < currTC) and (not Terminated)) then
          begin
      			if sendToServer
			      	then sendDelay := 1000
      				else sendDelay := Min(sendDelay * 2, 64000) ;

			      sendTC := currTC + sendDelay ;
    		  end ;

          cleanSendItems ;

          if ((slowTC < currTC) and (not Terminated)) then
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
    begin
        logToFile ;
    end;

    if fSendOnClose then
    begin
        currTC := GetTickCount ;
        sendTC := currTC + (fFinalSendDelay * 1000) ;
        FLastError := 'Send on close' ;

        while (sendItems.Count > 0) and (currTC < sendTC) do                // Boucler pendant fFinalDelay millisecondes tant qu'il y a encore qqchose à envoyer
        begin


          sendToServer ;
          cleanSendItems ;

          if sendItems.Count > 0
            then sleep(1000) ;

          currTC := GetTickCount ;
        end;

    end;

    FLastError := 'storeItems' ;
    storeItems ;                                                                // Stockage de ce qui n'a pas pu être envoyé

    FLastError := 'Terminated' ;
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

    if Assigned(FOnInternalError) then
    begin
        if FSynchronized
            then Synchronize(doOnInternalError)
            else doOnInternalError ; 
    end ; 
end;
//------------------------------------------------------------------------------
procedure TLog.doOnInternalError ; 
begin
    if Assigned(FOnInternalError) then 
    begin
        try
            FOnInternalError(Self) ; 
        except
        end ; 
    end ; 
end ; 
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
//    ia  : integer ;
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
//    ia        : integer ;
begin
    if logItems.Count < 1 then Exit ;

    try
        if fRelativPath then
          sFilename := ExpandFileName(ExtractFilePath(getApplicationFileName) + fLogFilePath + fLogFileName)
        else
          sFilename := fLogFilePath + fLogFileName;

        sFilename := stringreplace(sFilename, '{%DATE}', FormatDateTime('yyyy-mm-dd', now), [rfReplaceAll]) ;
        sFilename := stringreplace(sFilename, '{%APP}', fApp, [rfReplaceAll]) ;
        sFilename := stringreplace(sFilename, '{%INST}', fInst, [rfReplaceAll]) ;
        sFilename := stringreplace(sFilename, '{%DOSS}', fDoss, [rfReplaceAll]) ;

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

  if elKey in aElements then
    sa := sa + StrLPad(aLogItem.key, 32) + ' | ' ;

  if elNb in aElements then
    sa := sa + StrLPad(IntToStr(aLogItem.nb), 3) + ' | ' ;

  if elValue in aElements then
    sa := sa + StrLPad( StringReplace( aLogItem.val, #13#10, ' ', [ rfReplaceAll ] ), 255) + ' | ' ;

  if elSrv in aElements then
    sa := sa + StrLPad(aLogItem.srv, 31) + ' | ' ;

  if elMdl in aElements then
    sa := sa + StrLPad(aLogItem.mdl, 63) + ' | ' ;

  if elDos in aElements then
    sa := sa + StrLPad(aLogItem.dos, 63) + ' | ' ;

  if elHost in aElements then
    sa := sa + StrLPad(aLogItem.host, 16) + ' | ' ;

  if elApp in aElements then
    sa := sa + StrLPad(aLogItem.app, 20) + ' | ' ;

  if elRef in aElements then
    sa := sa + StrLPad(aLogItem.ref, 64) + ' | ' ;

  if elMag in aElements then
    sa := sa + StrLPad(aLogItem.mag, 32) + ' | ' ;

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
    Result := true ;  sa := '' ;

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
                    TCPClient.Connect ;
                except
                    on E:Exception do 
                        InternalError('sendBufferToServer : Connect : '+E.Message) ;
                end;

                if TCPClient.Connected then
                begin
                    try
                        try
                          TCPClient.IOHandler.ReadTimeout := 30000 ;

                          TCPClient.IOHandler.WriteBufferOpen ;
                          TCPClient.IOHandler.WriteLn('POST /monitor/monitor.php?act=log HTTP/1.1') ;
                          TCPClient.IOHandler.WriteLn('Host: ' + Servers[ia].host) ;
                          TCPClient.IOHandler.WriteLn('Content-Type: application/json') ;
                          TCPClient.IOHandler.WriteLn('Content-Length: ' + IntToStr(Length(sendBuffer)+3)) ;
                          TCPClient.IOHandler.WriteLn(#13#10) ;
                          TCPClient.IOHandler.WriteLn(SendBuffer) ;
                          TCPClient.IOHandler.WriteBufferFlush ;

                          sa := Trim(TCPClient.IOHandler.ReadLn) ;
                        finally
                          TCPClient.Disconnect ;
                        end;

                        if (sa = 'HTTP/1.1 200 OK') then
                        begin
                          bSent := true ;
                          CurrentServer := ia ;
                          Break ;
                        end ;

                    except
                        on E:Exception do
                            InternalError('sendBufferToServer : Send : '+E.Message) ; 
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
//var
//    ia : integer ;
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
function TLog.sendToServer : boolean ;
var
    ia: Integer;
    aItem : PLogItem ;
//    sa : AnsiString ;
begin
	Result := false ;

    if sendItems.Count < 1 then
    begin
      Result := true ;
      Exit ;
    end;

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

            Result := sendBufferToServer ;
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
        if aItem^.mag  <> bItem^.mag  then Exit ;
        if aItem^.key  <> bItem^.key  then Exit ;
        if aItem^.val  <> bItem^.val  then Exit ;
        if aItem^.lvl  <> bItem^.lvl  then Exit ;

        Result := true ;
    except
    end;
end;

//------------------------------------------------------------------------------
procedure TLog.LogDT(adate:TDateTime;aSrv, aMdl, aDos, aRef, aMag, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean);
var
//    ia    : integer ;
    aItem : PLogItem ;
//    bItem : PLogItem ;
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
        aItem^.mag  := aMag ;
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
procedure TLog.Log(aApp, aInst, aSrv, aMdl, aDos, aRef, aMag, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean = false ; aFreq:integer = -1 ; aSend : TLogType = ltBoth);
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
        aItem^.app  := aApp ;
        aItem^.inst := aInst ;
        aItem^.srv  := aSrv ;
        aItem^.mdl  := aMdl ;
        aItem^.dos  := aDos ;
        aItem^.ref  := aRef ;
        aItem^.mag  := aMag;
        aItem^.key  := aKey ;
        aItem^.val  := aVal ;
        aItem^.lvl  := aLvl ;
        aItem^.ovl  := aOvl ;
        aItem^.size := 0 ;
        aItem^.data := nil ;

        if aFreq < 0 then
          aItem^.freq := fFreq // 86400 (default)
        else
          aItem^.freq := aFreq; // user defined ( 0=Infinite )

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
                if aItem^.size > 1 then
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
procedure TLog.Log(aSrv, aMdl, aDos, aRef, aMag, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean = false ; aFreq:integer = -1 ; aSend : TLogType = ltBoth);
begin
  Log(FApp, fInst, aSrv, aMdl, aDos, aRef, aMag, aKey, aVal, aLvl, aOvl, aFreq, aSend);
end;
//------------------------------------------------------------------------------
procedure TLog.Log(aSrv,aMdl, aDos, aRef, aMag, aKey: string; aVal: Int64; aLvl: TLogLevel; aOvl: boolean; aFreq:integer);
begin
    Log(aSrv, aMdl, aDos, aRef, aMag, aKey, IntToStr(aVal), aLvl, aOvl, aFreq);
end;
//------------------------------------------------------------------------------
procedure TLog.Log(aSrv,aMdl, aDos, aRef, aMag, aKey: string; aVal: Boolean; aLvl: TLogLevel; aOvl: boolean;aFreq:integer);
begin
    if aVal
        then Log(aSrv,aMdl, aDos, aRef, aMag, aKey, '1', aLvl, aOvl, aFreq)
        else Log(aSrv,aMdl, aDos, aRef, aMag, aKey, '0', aLvl, aOvl, aFreq) ;
end;
//------------------------------------------------------------------------------
procedure TLog.Log(aSrv,aMdl, aDos, aRef, aMag, aKey: string; aVal: Extended; aLvl: TLogLevel; aOvl: boolean;aFreq:integer);
begin
    Log(aSrv,aMdl, aDos, aRef, aMag, aKey, FloatToStr(aVal), aLvl, aOvl, aFreq) ;
end;
//------------------------------------------------------------------------------
procedure TLog.Log(aMdl, aRef, aMag, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean = false ; aFreq: integer  = -1 ; aSend : TLogType = ltBoth);
begin
  Log(fSrv, aMdl, fDoss, aRef, aMag, aKey, aVal, aLvl, aOvl, aFreq, aSend) ;
end;
//------------------------------------------------------------------------------
procedure TLog.Log(aMdl, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = -1 ; aSend : TLogType = ltServer) ;
begin
	Log(fSrv, aMdl, fDoss, fRef, fMag, aKey, aVal, aLvl, aOvl, aFreq, aSend) ;
end ;
//------------------------------------------------------------------------------
procedure TLog.Log(aMdl, aRef, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean; aFreq: integer; aSend: TLogType);
begin
	Log(fSrv, aMdl, fDoss, aRef, fMag, aKey, aVal, aLvl, aOvl, aFreq, aSend) ;
end;
//------------------------------------------------------------------------------
class function TLog.LogLevelToStr(aLogLevel: TLogLevel): string;
var
    ia : integer ;
begin
    ia := Ord(aLogLevel) ;

    if (ia < Ord( Low( TLogLevel ) ) ) or (ia > Ord( High( TLogLevel ) ) ) then
    begin
        Result := '   ' ;
        Exit ;
    end;

    Result := LogLevelTri[ia] ;
end;
class function TLog.LogLevelToString(aLogLevel: TLogLevel): string;
var
    ia : integer ;
begin
    ia := Ord(aLogLevel) ;

    if (ia < Ord( Low( TLogLevel ) ) ) or (ia > Ord( High( TLogLevel ) ) ) then
    begin
        Result := '' ;
        Exit ;
    end;

    Result := LogLevelStr[ia] ;
end;

//------------------------------------------------------------------------------
class function TLog.StrToLogLevel(aLevel : string) : TLogLevel ;
var
    ia : integer ;
begin
    Result := logNone ;

    aLevel := uppercase(aLevel) ;

    for ia := Ord( Low( TLogLevel ) ) to Ord( High( TLogLevel ) ) do
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
    tmpFileName : string ;
begin
    if (aFilename = '')
        then aFilename := fDefaultConfigFileName ;

    iniFile := TIniFile.Create(aFileName) ;

    try

        fHost := iniFile.ReadString(LOG_SECTION, 'host', GetMachineName) ;

        // Servers List
        iNbSrv := iniFile.ReadInteger(LOG_SECTION, 'nbServers', 1) ;
        setlength(Servers, iNbSrv) ;

        for ia := 1 to iNbSrv do
        begin
            Servers[ia-1].name := iniFile.ReadString(LOG_SECTION, 'serverName_' + IntToStr(ia), 'logs') ;
            Servers[ia-1].host := iniFile.ReadString(LOG_SECTION, 'serverHost_' + IntToStr(ia), 'logs.ginkoia.eu') ;
            Servers[ia-1].port := iniFile.ReadInteger(LOG_SECTION, 'serverPort_' + IntToStr(ia), 8080) ;
        end;

        fMinLogLevel  := TLogLevel(iniFile.ReadInteger(LOG_SECTION, 'minLogLevel', Ord(fMinLogLevel))) ;
        fMinSendLevel := TLogLevel(iniFile.ReadInteger(LOG_SECTION, 'minSendLevel', Ord(fMinSendLevel))) ;
        fMaxNewItems  := iniFile.ReadInteger(LOG_SECTION, 'maxNewItems', fMaxNewItems) ;
        fMaxLogItems  := iniFile.ReadInteger(LOG_SECTION, 'maxLogItems', fMaxLogItems) ;
        fLogKeepDays  := iniFile.ReadInteger(LOG_SECTION, 'logKeepDays', fLogKeepDays) ;
        tmpFileName   := iniFile.ReadString(LOG_SECTION, 'logFileName', fLogFilePath + fLogFileName) ;

        if ExpandFileName(tmpFileName) = tmpFileName then
        begin
          fRelativPath := false;
          fLogFilePath := ExtractFilePath(tmpFileName);
          fLogFileName := ExtractFileName(tmpFileName);
        end
        else
        begin
          fRelativPath := true;
          fLogFilePath := ExtractRelativePath(ExtractFilePath(getApplicationFileName), ExtractFilePath(ExpandFileName(ExtractFilePath(getApplicationFileName) + tmpFileName)));
          fLogFileName := ExtractFileName(ExpandFileName(tmpFileName));
          if (Length(fLogFilePath) = 0) or (not (fLogFilePath[1] = '.')) then
            fLogFilePath := '.' + PathDelim + fLogFilePath;
        end;

        fRef          := iniFile.ReadString(LOG_SECTION, 'Ref', fRef) ;
        fMag          := iniFile.ReadString(LOG_SECTION, 'Mag', fMag) ;
        fFreq         := iniFile.ReadInteger(LOG_SECTION, 'frequence', fFreq) ;
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
        iniFile.WriteInteger(LOG_SECTION, 'nbServers', Length(Servers));

        for ia := 1 to Length(Servers) do
        begin
            iniFile.WriteString(LOG_SECTION, 'serverName_' + IntToStr(ia), Servers[ia-1].name);
            iniFile.WriteString(LOG_SECTION, 'serverHost_' + IntToStr(ia), Servers[ia-1].host);
            iniFile.WriteInteger(LOG_SECTION, 'serverPort_' + IntToStr(ia), Servers[ia-1].port);
        end;

        iniFile.WriteInteger(LOG_SECTION, 'minLogLevel', Ord(fMinLogLevel)) ;
        iniFile.WriteInteger(LOG_SECTION, 'minSendLevel', Ord(fMinSendLevel)) ;
        iniFile.WriteInteger(LOG_SECTION, 'maxNewItems', fMaxNewItems) ;
        iniFile.WriteInteger(LOG_SECTION, 'maxLogItems', fMaxLogItems) ;
        iniFile.WriteInteger(LOG_SECTION, 'logKeepDays', fLogKeepDays) ;
        iniFile.WriteString(LOG_SECTION, 'logFileName', fLogFilePath + fLogFileName) ;

        iniFile.WriteInteger(LOG_SECTION, 'frequence', fFreq) ;

        iniFile.WriteString(LOG_SECTION, 'Ref', fRef) ;
        iniFile.WriteString(LOG_SECTION, 'Mag', fMag) ;
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

        if (aItem.mag <> '')
            then sa := sa + '"mag":"'  + JSONEscapeValue(aItem.mag) + '",' ;

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
class function TLog.JSEscape(aStr: string): AnsiString;
var
    sa : AnsiString ;
    ca : Char ;
begin
    sa := '' ;
    try
        for ca in aStr do
        begin
            case ca of
        				'''' : sa := sa + '\''' ;
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
        if fRelativPath then
          sSearch := ExpandFileName(ExtractFilePath(getApplicationFileName) + fLogFilePath + fLogFileName)
        else
          sSearch := fLogFilePath + fLogFileName;
        sSearch := stringreplace(sSearch, '{%DATE}', '????-??-??', [rfReplaceAll]) ;
        sSearch := stringreplace(sSearch, '{%APP}', fApp, [rfReplaceAll]) ;
        sSearch := stringreplace(sSearch, '{%INST}', fInst, [rfReplaceAll]) ;
        sSearch := stringreplace(sSearch, '{%DOSS}', fDoss, [rfReplaceAll]) ;

        if FindFirst(sSearch, (faAnyFile and not faDirectory), srSearch) = 0 then
        begin
            repeat
                sFileName := ExtractFilePath(sSearch) + srSearch.Name ;
                if ( FileDateToDateTime(srSearch.Time) < (now - fLogKeepDays) ) then
                begin
{$IF CompilerVersion > 27}
                    System.SysUtils.DeleteFile(  sFileName ) ;
{$ELSE}
                    SysUtils.DeleteFile(  sFileName ) ;
{$IFEND}
                end;
            until FindNext(srSearch) <> 0 ;
        end;
    except
		on E:Exception do InternalError('cleanupLogFiles : ' + e.message);
    end;
end;
//==============================================================================

initialization
{$IF CompilerVersion > 27}
    Winapi.Winsock.WSAStartup(MakeWord(2,2), WSAData) ;
{$ELSE}
    Winsock.WSAStartup(MakeWord(2,2), WSAData) ;
{$IFEND}
    Log := TLog.Create ;
//------------------------------------------------------------------------------
finalization
  {$IFNDEF DLL}
   Log.Free ;
   WSACleanup ;
   {$ENDIF}

//==============================================================================
end.
