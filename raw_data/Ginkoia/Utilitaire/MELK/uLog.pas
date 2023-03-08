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
  system.dateutils,
  System.StrUtils,
  Winapi.Windows,
  Winapi.Winsock,
  System.Contnrs,
  System.SyncObjs,
  System.Win.Registry,
  System.iniFiles,
  idTCPClient, IdHTTP, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdSSLOpenSSLHeaders,
  IdCoder, IdCoderMIME,
  System.Math ;
{$ELSE}
  Classes,
  SysUtils,
  StrUtils,
  dateutils,
  Windows,
  Winsock,
  Contnrs,
  SyncObjs,
  Registry,
  iniFiles,
  idTCPClient, IdHTTP, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdSSLOpenSSLHeaders,
  IdCoder, IdCoderMIME,
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
    TLogItemParams = (ipDate, ipHost, ipApp, ipInst, ipSrv, ipMdl, ipDos, ipRef, ipMag, ipKey, ipVal, ipData, ipSize, ipLvl, ipOvl, ipFreq, ipNb, ipStore, ipSend, ipExecutionTime);

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

{$IFDEF WIN32}
    cKeyGinkoia = 'SOFTWARE\Algol\Ginkoia';
    cKeyLogs:string = 'SOFTWARE\Algol\Ginkoia\Logs';
{$ENDIF}
{$IFDEF WIN64}
    cKeyGinkoia = 'SOFTWARE\Wow6432Node\Algol\Ginkoia';
    cKeyLogs = 'SOFTWARE\Wow6432Node\Algol\Ginkoia\Logs';
{$ENDIF}
    // Clé Ginkoia
    cFieldHostEnvironment = 'HostEnvironment';
    // Clé Logs
    cFieldMinLogLevel = 'MinLogLevel';
    cFieldMinSendLevel = 'MinSendLevel';
    cFieldMaxNewItems = 'MaxNewItems';
    cFieldMaxLogItems = 'MaxLogItems';
    cFieldLogKeepDays = 'LogKeepDays';
    cFieldLogFileName = 'LogFileName';
    cFieldRef = 'Ref';
    cFieldMag = 'Mag';
    cFieldDoss = 'Doss';
    cFieldFreq = 'Freq';
    cFieldFirstLaunch = 'FirstLaunch_';

    // Infos Prod
    cPrdServerName = 'prod-proxy-melk';
    cPrdServerHost = 'prod-proxy-melk.ginkoia.net';
    cPrdDataStream = 'melk_log_datastream';
    cPrdPipeline = 'melk_log_pipeline';
    cPrdServerPort = 443;
    // Infos Pre-Prod
    cPpdServerName = 'preprod-proxy-melk';
    cPpdServerHost = 'preprod-proxy-melk.ginkoia.net';
    cPpdDataStream = 'melk_log_datastream_ppd';
    cPpdPipeline = 'melk_log_pipeline_ppd';
    cPpdServerPort = 443;

    LogVersion  : integer = 4 ;
    LOG_SECTION = 'Log' ;
    LOG_SEPARATOR = #160+'|'+#160;

    MELK_LOGIN = 'sender_melk_log';
    MELK_PWD_PPD = 'to9_0prtYuu7';
    MELK_PWD_PRD = 'QKpo09_treQ';

    DEFAULT_FINAL_SEND_DELAY = 5;

    SEND_LOG_BEFORE_TERMINATE = 25;

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
        host : String ;
        app  : String ;
        inst : String ;
        srv  : String ;
        mdl  : String ;
        dos  : String ;
        ref  : String ;
        mag  : String ;
        key  : String ;
        val  : String ;
        data : PAnsiChar ;
        dataStr : AnsiString; // Doit remplacer 'data' (et peut 'size' avec).
        size : Int64 ;
        lvl  : TLogLevel ;
        ovl  : boolean ; // DÉPRÉCIÉ sur MELK
        freq : integer;  // DÉPRÉCIÉ sur MELK
        nb   : word ;
        store : boolean ;
        send  : TLogSendState ;
        executiontime : integer;
    end;
//------------------------------------------------------------------------------
    TLogEvent = procedure(aSender : TObject ; aLog : TLogItem) of object ;
//------------------------------------------------------------------------------
    TLog = class(TThread)
    private
        newItems  : TList ;
        logItems  : TList ;
        sendItems : TList ;
        sendBuffers : array of AnsiString ;
        lckNew   : TRTLCriticalSection ;
        lckLog   : TRTLCriticalSection ;
        lckSend  : TRTLCriticalSection ;

        fServerHost : String;
        fMelkDataStream : String;
        fMelkPipeline : String;
        fMelkPassword : String;

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
        fHTTPS: TIdHTTP;
        fIOHandler : TIdSSLIOHandlerSocketOpenSSL;

        fOnLog  : TLogEvent ;
        fOnLogItem : TLogItem ;
        FOnInternalError : TNotifyEvent ; 

        FSynchronized : boolean ;

        FLastError: string;
        FFileLogFormat: TLogElements;
        fDeboublonage : boolean;
        fSendOnClose : boolean;
        fFinalSendDelay: Integer;
        ///<summary>
        ///  Pour savoir si on supprime le fichier log.tmp au démarrage de l'application.
        ///  Par défaut a False.
        ///  ATTENTION : Lors du passage au MELK il est définit a TRUE pour que le fichier log.tmp soit toujours supprimé.
        ///</summary>
        fRemoveLogTmpFileAtStart: boolean;

        function getNewItems : boolean ;
        procedure storeItems ;
        procedure loadItems ;
        procedure logToFile ;
        function sendToServer : boolean ;

        function EncodeTmpFileStringValue(aString: string): string;
        function DecodeTmpFileStringValue(aString: string): string;

        procedure clearNewItems ;
        procedure clearLogItems ;
        procedure clearSendItems ;
        procedure clearSendBuffers ;
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

        procedure CleanIni(aFileName : string = '') ;
        procedure readIni(aFileName : string = '') ;
        procedure saveIni(aFileName : string = '') ;

        ///<summary>
        ///  Final Log call. Contain all the values send to MELK.
        ///</summary>
        ///  <param name="aApp"> Application name </param>
        ///  <param name="aInst"> Application "instance". Used if an application can be executed more than once.</param>
        ///  <param name="aSrv"> The server sending the logs. The machine where the IB base is installed.</param>
        ///  <param name="aMdl"> Module inside application. </param>
        ///  <param name="aDos"> The ginkoia client name. (Known as "Dossier" in Ginkoia frensh language). Usually GENBASES.BAS_NOMPOURNOUS </param>
        ///  <param name="aRef"> The current Ginkoia base ref. Usually GENBASES.BAS_GUID </param>
        ///  <param name="aMag"> The current store name (Known as "Magasin" in Ginkoia frensh language). Usually GENMAGASIN.MAG_NOM </param>
        ///  <param name="aKey"> The log Key.</param>
        ///  <param name="aVal"> The value of the log. </param>
        ///  <param name="aLvl"> The level of the log. (Voir <see cref="uLog.TLogLevel" />). Send as en integer in MELK </param>
        ///  <param name="aOvl"> To overload the aVal of aKey in monitoring. Default False. Deprecated avec MELK. </param>
        ///  <param name="aFreq"> Deprecated avec MELK </param>
        ///  <param name="aSend">
        ///     Where the log will be saved (server, local, both). (See <see cref="uLog.TLogType" />).
        ///     Default Both.
        ///  </param>
        ///  <param name="aExecutionTime"> To spécified an execusion time (If needed). Default -1 </param>
        procedure Log(aApp, aInst, aSrv, aMdl, aDos, aRef, aMag, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = -1 ; aSend : TLogType = ltBoth; aExecutionTime: integer = -1) ; overload ;
        procedure Log(aSrv, aMdl, aDos, aRef, aMag, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = -1 ; aSend : TLogType = ltBoth) ; overload ;
        procedure Log(aSrv, aMdl, aDos, aRef, aMag, aKey : string ; aVal : Int64 ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = -1) ; overload ;
        procedure Log(aSrv, aMdl, aDos, aRef, aMag, aKey : string ; aVal : Extended ; aLvl : TLogLevel ; aOvl : boolean = false;aFreq : integer = -1) ; overload ;
        procedure Log(aSrv, aMdl, aDos, aRef, aMag, aKey : string ; aVal : Boolean ; aLvl : TLogLevel ; aOvl : boolean = false;aFreq : integer = -1) ; overload ;
        procedure Log(aMdl, aRef, aMag, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = -1 ; aSend : TLogType = ltBoth) ; overload ;
        procedure Log(aMdl, aRef, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = -1 ; aSend : TLogType = ltBoth) ; overload ;
        procedure Log(aMdl, aKey : string ; aVal : string ; aLvl : TLogLevel ; aOvl : boolean = false; aFreq : integer = -1 ; aSend : TLogType = ltServer) ; overload ;
        ///<summary>
        ///  [25/02/2022] New Log call with ExecutionTime for MELK
        ///</summary>
        ///  <param name="aMdl"> Module inside application. </param>
        ///  <param name="aRef"> The current Ginkoia base ref. Usually GENBASES.BAS_GUID </param>
        ///  <param name="aKey"> The log Key.</param>
        ///  <param name="aVal"> The value of the log. </param>
        ///  <param name="aLvl"> The level of the log. (Voir <see cref="uLog.TLogLevel" />). Send as en integer in MELK </param>
        ///  <param name="aExecutionTime"> To spécified an execusion time (If needed). Default -1 </param>
        ///  <param name="aSend">
        ///     Where the log will be saved (server, local, both). (See <see cref="uLog.TLogType" />).
        ///     Default Both.
        ///  </param>
        ///  <remarks>
        ///  Some values must be set before using this log procedure
        ///    - TLog.app : Application name
        ///    - TLog.Inst : [optional] Application "instance". Used if an application can be executed more than once.
        ///    - TLog.Srv : The server sending the logs. The machine where the IB base is installed.
        ///    - TLog.Dos : The ginkoia client name. (Known as "Dossier" in Ginkoia frensh language). Usually GENBASES.BAS_NOMPOURNOUS
        ///    - TLog.Mag : The current store name (Known as "Magasin" in Ginkoia frensh language). Usually GENMAGASIN.MAG_NOM
        ///  </remarks>
        procedure Log(aMdl, aRef, aKey : string ; aVal : string ; aLvl : TLogLevel ; aExecutionTime: integer ; aSend : TLogType = ltBoth) ; overload ;
        ///<summary>
        ///  [25/02/2022] New Log call with ExecutionTime for MELK
        ///</summary>
        ///  <param name="aMdl"> Module inside application. </param>
        ///  <param name="aKey"> The log Key.</param>
        ///  <param name="aVal"> The value of the log. </param>
        ///  <param name="aLvl"> The level of the log. (Voir <see cref="uLog.TLogLevel" />). Send as en integer in MELK </param>
        ///  <param name="aExecutionTime"> To spécified an execusion time (If needed). Default -1 </param>
        ///  <param name="aSend">
        ///     Where the log will be saved (server, local, both). (See <see cref="uLog.TLogType" />).
        ///     Default Both.
        ///  </param>
        ///  <remarks>
        ///  Some values must be set before using this log procedure
        ///    - TLog.app : Application name
        ///    - TLog.Inst : [optional] Application "instance". Used if an application can be executed more than once.
        ///    - TLog.Srv : The server sending the logs. The machine where the IB base is installed.
        ///    - TLog.Dos : The ginkoia client name. (Known as "Dossier" in Ginkoia frensh language). Usually GENBASES.BAS_NOMPOURNOUS
        ///    - TLog.Ref : The current Ginkoia base ref. Usually GENBASES.BAS_GUID
        ///    - TLog.Mag : The current store name (Known as "Magasin" in Ginkoia frensh language). Usually GENMAGASIN.MAG_NOM
        ///  </remarks>
        procedure Log(aMdl, aKey : string ; aVal : string ; aLvl : TLogLevel ; aExecutionTime: integer ; aSend : TLogType = ltServer) ; overload ;

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
function DateTimeOffset : Integer ;
function DateTimeToIso8601(aDte : TDateTIme) : string ;
function Iso8601ToDateTime(aISO : String): TDateTime ;

function GetGinkoiaBplPath: string;
function GetGinkoiaPlateFormDllPath: string;

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
function DateTimeOffset : Integer ;
var
  aTzCurr : Cardinal ;
  aTz : TTimeZoneInformation ;
begin
  aTzCurr := GetTimeZoneInformation(aTz) ;

  if aTzCurr = TIME_ZONE_ID_DAYLIGHT
    then Result := (aTz.Bias + aTz.DaylightBias) div -60
    else Result := (aTz.Bias + aTz.StandardBias) div -60 ;
end;
//------------------------------------------------------------------------------
function DateTimeToIso8601(aDte : TDateTIme) : string ;
var
  aIsoDte : string ;
begin
  aDte := IncHour(aDte, -DateTimeOffset) ;
  aIsoDte := FormatDateTime('yyyy-mm-dd', aDte) + 'T' + FormatDateTime('hh:nn:ss.zzz', aDte) + 'Z' ;

  Result := aIsoDte ;
end;
//------------------------------------------------------------------------------
function Iso8601ToDateTime(aISO : String) : TDateTime;
var
  vYear  : Integer;
  vMonth : Integer;
  vDay   : Integer;
  vHour  : Integer;
  vMin   : Integer;
  vSec   : Integer;
  vMSec  : Integer;
  vDate  : TDateTime;
begin
  vYear  := StrToInt(Copy(aISO, 0, 4));
  vMonth := StrToInt(Copy(aISO, 6, 2));
  vDay   := StrToInt(Copy(aISO, 9, 2));
  vHour  := StrToInt(Copy(aISO, 12, 2));
  vMin   := StrToInt(Copy(aISO, 15, 2));
  vSec   := StrToInt(Copy(aISO, 18, 2));
  vMSec  := StrToInt(Copy(aISO, 21, 3));
  vDate  := EncodeDateTime(vYear, vMonth, vDay, vHour, vMin, vSec, vMSec);

  vDate := IncHour(vDate, DateTimeOffset);
  Result := vDate;
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

function GetGinkoiaBplPath: string;
var
  i: integer;
  vPathList: TStrings;
  bFoundInPath: Boolean;
begin
  vPathList := TStringList.Create;
  try
    vPathList.StrictDelimiter := True;
    vPathList.Delimiter := Char(';');
    vPathList.DelimitedText := GetEnvironmentVariable('path');

    bFoundInPath := False;
    for i := 0 to vPathList.Count - 1 do
    begin
      if Pos('GINKOIA\BPL', UpperCase(vPathList[i])) <> 0 then
      begin
        Result := vPathList[i];
        bFoundInPath := True;
        Break;
      end;
    end;
  finally
    vPathList.Free;
  end;

  // If EnvironmentVarialbe not found we
  //  1. search environment variable "GinkoiaBplPath" (does not exist currently 25/02/2022)
  if not bFoundInPath then
  begin
    Result := GetEnvironmentVariable('GinkoiaBplPath');
  end;
end;

function GetGinkoiaPlateFormDllPath: string;
begin
  if GetGinkoiaBplPath <> '' then
    Result := GetGinkoiaBplPath + {$IFDEF WIN32}''{$ELSE}'dll64\'{$ENDIF};
end;

//==============================================================================
constructor TLog.Create;
begin
    inherited Create(true) ;

    fHTTPS := TIdHTTP.Create(nil);
    fHTTPS.ConnectTimeout := 2000;
    fHTTPS.Request.ContentType := 'application/json';

    {$IF CompilerVersion <> 22}
    fIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create();
    fIOHandler.SSLOptions.Method := sslvTLSv1_2;
    fIOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
    {$IFEND}
    fHTTPS.HandleRedirects := True;

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

    FLastError := 'Ok' ;

    FSynchronized := true ;

    fDeboublonage   := False;
    fSendOnClose    := false;
    fFinalSendDelay := DEFAULT_FINAL_SEND_DELAY ;      // Tenter d'envoyer pendant 5 seconde à la fin

    FOnInternalError := nil ;

    setThreadPriority(ThreadID, THREAD_PRIORITY_BELOW_NORMAL) ;
end;
//------------------------------------------------------------------------------
function TLog.DecodeTmpFileStringValue(aString: string): string;
begin
  Result := StringReplace(aString, '[\n]', sLineBreak, [rfReplaceAll]);
end;

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
    
    FreeAndNil(fHTTPS);
    
    inherited ;
end;
//------------------------------------------------------------------------------
function TLog.EncodeTmpFileStringValue(aString: string): string;
begin
  Result := StringReplace(aString, sLineBreak, '[\n]', [rfReplaceAll]);
end;

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
        if fFinalSendDelay < 0 then // En cas de valeur négative.
          fFinalSendDelay := DEFAULT_FINAL_SEND_DELAY;
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
    fileTemp : TextFile ;
    aItem : PLogItem ;
    ia  : integer ;
    vOvl, vStore : string;
begin
  AssignFile(fileTemp, fDefaultStorageFileName) ;
  try
    {$I+}
    Rewrite(fileTemp) ;
    {$I-}

    writeln(fileTemp, DateTimeToIso8601(now) + LOG_SEPARATOR {host} + LOG_SEPARATOR + 'LOGFILE' + LOG_SEPARATOR +
      {inst} LOG_SEPARATOR {srv} + LOG_SEPARATOR {mdl} + LOG_SEPARATOR {dos}+ LOG_SEPARATOR {ref}+ LOG_SEPARATOR {mag}+ LOG_SEPARATOR + 'VERSION' + LOG_SEPARATOR +
      IntToStr(LogVersion) + LOG_SEPARATOR {data}+ LOG_SEPARATOR {size}+ LOG_SEPARATOR {lvl}+ LOG_SEPARATOR {ovl}+ LOG_SEPARATOR {freq}+ LOG_SEPARATOR {nb}+ LOG_SEPARATOR +
      {store}LOG_SEPARATOR {send} + LOG_SEPARATOR {executiontime});

    EnterCriticalSection(lckSend) ;
    try
      for ia := 0 to sendItems.Count - 1 do
      begin
        aItem := sendItems[ia] ;

        if aItem.send = sendDone then
          Continue;

        if aItem.ovl
          then vOvl := 'true'
          else vOvl := 'false' ;
        if aItem.store
          then vStore := 'true'
          else vStore := 'false' ;

        writeln(fileTemp,
          DateTimeToIso8601(aItem^.date) + LOG_SEPARATOR
          + aItem^.host + LOG_SEPARATOR
          + aItem^.app + LOG_SEPARATOR
          + aItem^.inst + LOG_SEPARATOR
          + aItem^.srv + LOG_SEPARATOR
          + aItem^.mdl + LOG_SEPARATOR
          + aItem^.dos + LOG_SEPARATOR
          + aItem^.ref + LOG_SEPARATOR
          + aItem^.mag + LOG_SEPARATOR
          + aItem^.key + LOG_SEPARATOR
          + EncodeTmpFileStringValue(aItem^.val) + LOG_SEPARATOR
          + EncodeTmpFileStringValue(aItem^.data) + LOG_SEPARATOR
          + IntToStr(aItem^.size) + LOG_SEPARATOR
          + IntToStr(Ord(aItem^.lvl)) + LOG_SEPARATOR
          + vOvl + LOG_SEPARATOR
          + IntToStr(aItem^.freq) + LOG_SEPARATOR
          + IntToStr(aItem^.nb) + LOG_SEPARATOR
          + vStore + LOG_SEPARATOR
          + IntToStr(Ord(aItem^.send)) + LOG_SEPARATOR
          + IntToStr(aItem^.executiontime)
          );
      end ;
    finally
        LeaveCriticalSection(lckSend) ;
    end;
  finally
    CloseFile(fileTemp);
  end;
end ;
//------------------------------------------------------------------------------
procedure TLog.loadItems;
var
  fileTemp : TextFile ;
  aItem : PLogItem ;
  vLine : string;
  vParams : TStrings;
  ba : boolean ;
  vPos, vCount: Integer;
  i: Integer;
  vReg: TRegistry ;
  vRegFirstLaunch: Integer ;
  vExeName: string;
begin
  ba := False;

  if not FileExists(fDefaultStorageFileName) then Exit ;
  AssignFile(fileTemp, fDefaultStorageFileName) ;
  try 
    vRegFirstLaunch := 1;
    vReg := TRegistry.Create;
    try
      try
        vReg.rootkey := HKEY_LOCAL_MACHINE;
  //      vreg.Access := KEY_WRITE or KEY_READ or KEY_CREATE_SUB_KEY;
        vExeName := getApplicationFileName;
        vExeName := ExtractFileName(vExeName);
        vExeName := Copy(vExeName, 0, (Length(vExeName)-(length(ExtractFileExt(vExeName)))));
        if vReg.keyexists(cKeyLogs) then
        begin
          vReg.OpenKey(cKeyLogs, True);
          if vReg.ValueExists(cFieldFirstLaunch + vExeName) then
            vRegFirstLaunch := vReg.readinteger(cFieldFirstLaunch + vExeName);
          vReg.CloseKey;
        end;

        if vRegFirstLaunch = 1 then // On vide le contenu du fichier et on sort si c'est le premier lancement
        begin
          vReg.OpenKey(cKeyLogs, True);
          vReg.WriteInteger(cFieldFirstLaunch + vExeName, 0); // On créé / met à jour une variable pour
          Rewrite(fileTemp);
          Exit;
        end;
      except
        on eReg: Exception do
        begin
          Self.Log('uLog', '', '', 'TLog.LoadItems -> ' + SysErrorMessage(GetLastError), logError, False, -1, ltLocal);
          Exit;
        end;
      end;
    finally
      vReg.Free;
    end;

    {$I+}
    Reset(fileTemp) ;
    {$I-}

    vparams := TStringList.Create;
    EnterCriticalSection(lckSend) ;
    try
      while not Eof(fileTemp) do
      begin
        Readln(fileTemp, vLine);
        vParams.Clear;

        vPos := 0;
        for i := 1 to Length(vLine) do
        begin
          if (vline[i] = '|') and (vline[i-1] = #160) and (vline[i+1] = #160) then  // Copie des paramètres
          begin
            if vParams.Count < 1 then
              vCount := ((i-2) - vPos)
            else
              vCount := ((i-1) - vPos);

            if vcount < 1 then
              vParams.Add('')
            else
              vParams.Add(Copy(vLine, vpos, vCount));

            vPos := i+2;
          end;
          if (vParams.Count > 0) and (i = Pred(Length(vLine))) then  // Copie du dernier paramètre
          begin
            vCount := Length(vLine)+1 - vPos;
            vParams.Add(Copy(vLine, vpos, vCount));
          end;
        end;

        if (vParams.Count = 0) then
          Continue;

        if (   (Trim(vParams[ord(ipApp)]) = 'LOGFILE')
            or (Trim(vParams[ord(ipKey)]) = 'VERSION')
            or (Trim(vParams[ord(ipVal)]) = IntToStr(LogVersion)))
          then Continue ;

        New(aItem) ;

        aItem^.date := Iso8601ToDateTime(Trim(vParams[ord(ipDate)]));
        aItem^.host := Trim(vParams[ord(ipHost)]);
        aItem^.app := Trim(vParams[ord(ipApp)]);
        aItem^.inst := Trim(vParams[ord(ipInst)]);
        aItem^.srv := Trim(vParams[ord(ipSrv)]);
        aItem^.mdl := Trim(vParams[ord(ipMdl)]);
        aItem^.dos := Trim(vParams[ord(ipDos)]);
        aItem^.ref := Trim(vParams[ord(ipRef)]);
        aItem^.mag := Trim(vParams[ord(ipMag)]);
        aItem^.key := Trim(vParams[ord(ipKey)]);
        aItem^.val := DecodeTmpFileStringValue( Trim(vParams[ord(ipVal)]) );
        aItem^.dataStr := DecodeTmpFileStringValue( Trim(vParams[ord(ipData)]) );
        aItem^.data := PAnsiChar(aItem^.dataStr);

        if (aItem^.dataStr <> '')
          then aItem^.size := Length(aItem^.dataStr)
          else aItem^.size := 0;

        if (Trim(vParams[ord(ipLvl)]) <> '')
          then aItem^.lvl := TLogLevel(StrToInt(Trim(vParams[ord(ipLvl)])))
          else aItem^.lvl := TLogLevel(0);

        if Trim(vParams[ord(ipOvl)]) = 'true'
          then aItem^.ovl := True
          else aItem^.ovl := False;

        if (Trim(vParams[ord(ipFreq)]) <> '')
          then aItem^.freq := StrToInt(Trim(vParams[ord(ipFreq)]))
          else aItem^.freq := 0;

        if (Trim(vParams[ord(ipNb)]) <> '')
          then aItem^.nb := StrToInt(Trim(vParams[ord(ipNb)]))
          else aItem^.nb := 0;

        if Trim(vParams[ord(ipStore)]) = 'true'
          then aItem^.store := True
          else aItem^.store := False;

        if (Trim(vParams[ord(ipSend)]) <> '')
          then aItem^.send := TLogSendState(StrToInt(Trim(vParams[ord(ipSend)])))
          else aItem^.send := TLogSendState(0);

        aItem^.executiontime := -1;
        //executiontime is a new value. We check if exist in file.
        if vParams.Count > Ord(ipExecutionTime) then
        begin
          if (Trim(vParams[ord(ipExecutionTime)]) <> '') then
            aItem^.executiontime := StrToInt(Trim(vParams[ord(ipExecutionTime)]));
        end;

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
      end ;
    finally
        FreeAndNil(vParams);
        LeaveCriticalSection(lckSend) ;
    end;
  finally
    CloseFile(fileTemp);
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
            fileLog := TFileStream.Create(sFilename, fmOpenReadWrite or fmShareDenyNone);
            fileLog.Seek(0,soFromEnd) ;
        end else begin
            fileLog := TFileStream.Create(sFilename, fmCreate or fmShareDenyNone);
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
  vAuth : string ;
  bSent : boolean ;
  sAsk: TStringStream;
  sRes: TStringStream;
  i: Integer;
  SendBufferDoneCount: Integer;
  TerminatedSendLogCount: Integer;
  WaitSendSomeLogBeforeTerminate: Boolean;
  vURL: string;
begin
  Result := False;
  if Length(SendBuffers) < 1 then Exit ;

  sAsk := nil;
  sRes := nil;

  {$IF CompilerVersion <> 22}
    vURL := 'https://';
    fIOHandler.Destination := vURL + fServerHost;
    fHTTPS.IOHandler := fIOHandler;
  {$ELSE}
    vURL := 'http://';
  {$IFEND}


  vAuth := TIdEncoderMIME.EncodeString(MELK_LOGIN + ':' + fMelkPassword);
  fHTTPS.Request.CustomHeaders.Clear;
  fHTTPS.Request.CustomHeaders.AddValue('Authorization', 'Basic ' + vAuth);


  WaitSendSomeLogBeforeTerminate := False;
  TerminatedSendLogCount := 0;
  SendBufferDoneCount := 0;
  bSent := True;
  for i := 0 to Pred(Length(sendBuffers)) do
  begin
    sAsk := TStringStream.Create(AnsiToUtf8(sendbuffers[i]));
    sRes := TStringStream.Create('');
    try
      try
        fHTTPS.Post(format('%s/%s/_doc?pipeline=%s', [vURL + fServerHost, fMelkDataStream, fMelkPipeline]), sAsk, sRes);
        if (fHTTPS.ResponseCode < 200) or (fHTTPS.ResponseCode >= 300) then
          raise Exception.Create(fHTTPS.ResponseText);
        SendBufferDoneCount := i + 1;
      except
        on e : EIdHTTPProtocolException do
        begin
          Self.Log('uLog', '', '', 'TLog.SendBufferToServer -> ' + e.Message + ' | JSON : ' + e.ErrorMessage, logError, False, -1, ltLocal);
          bSent := False;
          Result := False;
          Break;
        end;
        on E: Exception do
        begin
          Self.Log('uLog', '', '', 'TLog.SendBufferToServer -> ' + e.Message + ' | JSON : ' + sRes.DataString, logError, False, -1, ltLocal);
          bSent := False;
          Result := False;
          Break;
        end;
      end;
      if Terminated then
      begin
        if not WaitSendSomeLogBeforeTerminate then
          TerminatedSendLogCount := 0
        else
          inc(TerminatedSendLogCount);
        WaitSendSomeLogBeforeTerminate := True;

        if TerminatedSendLogCount > SEND_LOG_BEFORE_TERMINATE then
        begin
          bSent := False;
          Result := False;
          Break;
        end;
      end;
    finally
      FreeAndNil(sAsk);
      FreeAndNil(sRes);
    end;
  end;

  clearSendBuffers;

  if bSent then
  begin
    for ia := 0 to sendItems.Count - 1 do
    begin
      if PLogItem(sendItems[ia])^.send = sendDo then
        PLogItem(sendItems[ia])^.send := sendDone ;
    end;
    Result := true ;
  end
  else
  begin
    for ia := 0 to sendItems.Count - 1 do
    begin
      if PLogItem(sendItems[ia])^.send = sendDo then
      begin
        if (ia < SendBufferDoneCount) then
          PLogItem(sendItems[ia])^.send := sendDone
        else
          PLogItem(sendItems[ia])^.send := sendWait ;
      end;
    end;
    Result := false ;
  end;
end;
//------------------------------------------------------------------------------
function TLog.sendItemToServer(aItem: PLogItem) : boolean ;
begin
    Result := true ;
    if not Assigned(aItem) then Exit ;

    if sendBuffers = nil then
        SetLength(sendBuffers, 1)
    else
      SetLength(sendBuffers, Length(sendBuffers)+1);
    sendBuffers[Length(sendBuffers)-1] := ItemToJSON(aItem^);
    aItem^.send := sendDo ;
end;
//------------------------------------------------------------------------------
function TLog.sendToServer : boolean ;
var
    ia: Integer;
    aItem : PLogItem ;
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
procedure TLog.CleanIni(aFileName : string = '') ;
var
  iniFile : TIniFile ;
  i: integer;
  nbServer: integer;
begin
  if (aFilename = '') then
    aFilename := fDefaultConfigFileName ;

  iniFile := TIniFile.Create(aFileName) ;
  try
    nbServer := iniFile.ReadInteger('log', 'nbServers', 0);

    for i := 0 to nbServer do
    begin
      inifile.DeleteKey('log', 'serverName_' + IntToStr(i));
      inifile.DeleteKey('log', 'serverHost_' + IntToStr(i));
      inifile.DeleteKey('log', 'serverPort_' + IntToStr(i));
    end;
    inifile.DeleteKey('log', 'nbServers');
  finally
    iniFile.free;
  end;
end;

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
                disposeItem(aItem) ;
                sendItems.delete(ia) ;
            end;
        end;
    finally
        LeaveCriticalSection(lckSend) ;
    end;
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
procedure TLog.clearSendBuffers;
begin
  EnterCriticalSection(lckSend) ;
  try
    SetLength(sendBuffers, 0);
  finally
    LeaveCriticalSection(lckSend) ;
  end;
end;

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
    aItem : PLogItem ;
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
procedure TLog.Log(aApp, aInst, aSrv, aMdl, aDos, aRef, aMag, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean = false ; aFreq:integer = -1 ; aSend : TLogType = ltBoth; aExecutionTime: integer = -1);
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
        aItem^.ovl  := aOvl ;  // DÉPRÉCIÉ sur MELK
        aItem^.size := 0 ;
        aItem^.data := nil ;
        aItem^.executiontime := aExecutionTime;

        // DÉPRÉCIÉ sur MELK
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
    iniFile     : TIniFile ;
    tmpFileName : String ;
    vReg        : TRegistry ;
    vRegValue   : Integer ;
    vServerHost : string ;
    vMelkDataStream : string;
    vMelkPipeline : string;
begin
    if (aFilename = '')
        then aFilename := fDefaultConfigFileName ;

    iniFile := TIniFile.Create(aFileName) ;

    try

        fHost := iniFile.ReadString(LOG_SECTION, 'host', GetMachineName) ;

        // Récupération dans la base de registre
        vReg := TRegistry.Create;
        try
            vRegValue := 0;
            vReg.rootkey := HKEY_LOCAL_MACHINE;
            if vReg.keyexists(cKeyGinkoia) then
            begin
                vReg.OpenKeyReadOnly(cKeyGinkoia);
                if vReg.ValueExists(cFieldHostEnvironment) then
                    vRegValue := vReg.readinteger(cFieldHostEnvironment);
            end;
        finally
            vReg.Free;
        end;

        case vRegValue of
          1:
          begin
            vServerHost := cPpdServerHost;
            vMelkDataStream := cPpdDataStream;
            vMelkPipeline := cPpdPipeline;
          end
          else
          begin
            vServerHost := cPrdServerHost;
            vMelkDataStream := cPrdDataStream;
            vMelkPipeline := cPrdPipeline;
          end;
        end;

        fServerHost     := iniFile.ReadString(LOG_SECTION, 'serverHost', vServerHost);
        fMelkDataStream := iniFile.ReadString(LOG_SECTION, 'MelkDataStream', vMelkDataStream);
        fMelkPipeline   := iniFile.ReadString(LOG_SECTION, 'MelkPipeline', vMelkPipeline);

        //Pour ne pas stocker le pass dans le fichier ini
        if fServerHost = cPrdServerHost then
        begin
          fMelkPassword   := MELK_PWD_PRD
        end
        else
        begin
          fMelkPassword   := MELK_PWD_PPD;
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
        fDoss         := iniFile.ReadString(LOG_SECTION, 'Doss', fDoss) ;
        fFreq         := iniFile.ReadInteger(LOG_SECTION, 'frequence', fFreq) ;
        fDeboublonage := iniFile.ReadBool('Log', 'deboublonage', fDeboublonage) ;

        // Nouvelle valeur pour le passage au MELK.
        // Au premier lancement du nouveau uLog on supprime le fichier .log.tmp pour éviter des erreurs.
        // La valeur par défaut du fRemoveLogTmpFileAtStart sera false et gérer dans le "saveIni".
        fRemoveLogTmpFileAtStart := iniFile.ReadBool(LOG_SECTION, 'RemoveLogTmpFileAtStart', True) ;

        fConfigured := true ;
    finally
        iniFile.Free ;
    end ;
end;
//------------------------------------------------------------------------------
procedure TLog.saveIni(aFileName: string);
var
  iniFile : TIniFile ;
begin
  if (aFilename = '') then
    aFilename := fDefaultConfigFileName ;

  iniFile := TIniFile.Create(aFileName) ;

  try
    iniFile.WriteString(LOG_SECTION, 'serverHost', fServerHost);
    iniFile.WriteString(LOG_SECTION, 'MelkDataStream', fMelkDataStream);
    iniFile.WriteString(LOG_SECTION, 'MelkPipeline', fMelkPipeline);

    iniFile.WriteInteger(LOG_SECTION, 'minLogLevel', Ord(fMinLogLevel)) ;
    iniFile.WriteInteger(LOG_SECTION, 'minSendLevel', Ord(fMinSendLevel)) ;
    iniFile.WriteInteger(LOG_SECTION, 'maxNewItems', fMaxNewItems) ;
    iniFile.WriteInteger(LOG_SECTION, 'maxLogItems', fMaxLogItems) ;
    iniFile.WriteInteger(LOG_SECTION, 'logKeepDays', fLogKeepDays) ;
    iniFile.WriteString(LOG_SECTION, 'logFileName', fLogFilePath + fLogFileName) ;

    iniFile.WriteInteger(LOG_SECTION, 'frequence', fFreq) ;

    iniFile.WriteString(LOG_SECTION, 'Ref', fRef) ;
    iniFile.WriteString(LOG_SECTION, 'Mag', fMag) ;
    iniFile.WriteString(LOG_SECTION, 'Doss', fDoss) ;

    // Pour nouvelle version du uLog melk le fichier log.tmp doit être supprimé pour éviter des erreurs.
    // Du coup s'il n'est pas présent dans le fichier ini on considère que c'est le premier lancement de l'application
    // avec la nouvelle méthode d'envoi et on met sa valeur par défaut a False pour qu'au prochain lancement il ne soit pas supprimé.
    if not iniFile.ValueExists(LOG_SECTION, 'RemoveLogTmpFileAtStart') then
    begin
      fRemoveLogTmpFileAtStart := False;
    end;
    iniFile.WriteBool(LOG_SECTION, 'RemoveLogTmpFileAtStart', fRemoveLogTmpFileAtStart);

  finally
    iniFile.Free ;
  end ;
end;
//------------------------------------------------------------------------------
procedure TLog.Open;
var
    sDllPath: string;
begin
    sDllPath := GetGinkoiaPlateFormDllPath;
    if DirectoryExists(sDllPath) then
    begin
      {$IF CompilerVersion <> 22}
      IdOpenSSLSetLibPath(sDllPath);
      {$IFEND}

      LoadOpenSSLLibrary;
    end;

    clearNewItems ;
    clearLogItems ;

    CleanIni ;
    if not fConfigured then
    begin
      readIni ;
    end;

    if fRemoveLogTmpFileAtStart then
    begin
      if FileExists(fDefaultStorageFileName) then
      begin
      {$IF CompilerVersion > 27}
        System.SysUtils.DeleteFile(  fDefaultStorageFileName ) ;
      {$ELSE}
        SysUtils.DeleteFile(  fDefaultStorageFileName ) ;
      {$IFEND}
      end;
    end;

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
        if (aItem.date <> 0)
            then sa := sa + '"date":"' + DateTimeToISO8601(aItem.date) + '",' ;
        if (aItem.host <> '')
            then sa := sa + '"host":"' + JSONEscapeValue(aItem.host) + '",' ;
        if (aItem.app <> '')
            then sa := sa + '"app":"'  + JSONEscapeValue(aItem.app) + '",' ;
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
        if (aItem.key <> '')
            then sa := sa + '"key":"'  + JSONEscapeValue(aItem.key) + '",' ;

        if (aItem.val <> '')
            then sa := sa + '"val":"'  + JSONEscapeValue(aItem.val) + '",' ;

        if (aItem.nb > 1)
            then sa := sa + '"nb":' + IntTostr(aItem.nb) + ',' ;

        sa := sa + '"lvl":'   + IntToStr(Ord(aItem.lvl)) + ',' ;

        if aItem.ovl
            then sa := sa + '"ovl":true,'
            else sa := sa + '"ovl":false,' ;

        sa := sa + '"freq":'   + IntToStr(aItem.freq) + ',' ;
        sa := sa + '"executionTime":'   + IntToStr(aItem.executiontime) ;

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

procedure TLog.Log(aMdl, aRef, aKey : string ; aVal : string ; aLvl : TLogLevel ; aExecutionTime: integer ; aSend : TLogType);
begin
	Log(FApp, FInst, FSrv, aMdl, FDoss, aRef, FMag, aKey, aVal, aLvl, false, -1, aSend, aExecutionTime) ;
end;

procedure TLog.Log(aMdl, aKey, aVal: string; aLvl: TLogLevel;
  aExecutionTime: integer; aSend: TLogType);
begin
	Log(FApp, FInst, FSrv, aMdl, FDoss, FRef, FMag, aKey, aVal, aLvl, false, -1, aSend, aExecutionTime) ;
end;

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
