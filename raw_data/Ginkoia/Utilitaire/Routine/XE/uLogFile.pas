unit uLogFile;

interface

uses Classes, Windows, SysUtils, DateUtils, Graphics ;

//==============================================================================
const
    LogLevelStr : array[0..8] of string = ('  ', 'DGB', 'TRA', 'INF', 'NOT', 'WAR', 'ERR', 'CRI', 'EMG') ;
    LogLevelColor : Array[0..8] of TColor = ($00000000, $00C0C0C0, $00A0A0A0, $0000A000, $00C0A000, $0000A0C0, $000000C0, $000000FF, $000000FF) ;
//------------------------------------------------------------------------------
type
    TLogLevel = (logNone, logDebug, logTrace, logInfo, logNotice, logWarning, logError, logCritical, logEmergency) ;
//------------------------------------------------------------------------------
    TLogFile = class(TThread)
    private
      newItems : TStringList ;
      logItems : TStringList ;
      newLock  : TRTLCriticalSection ;
      logLock  : TRTLCriticalSection ;

      fApp        : string ;
      fFilename   : string ;
      fLogLevel   : TLogLevel ;

      fLogKeepDays : Integer ;

      fDoTrim : boolean ;

      procedure getNewItems ;
      procedure writeToFile ;

      procedure cleanupLogFiles ;
    protected
      procedure Execute ; override ;
    public
      constructor Create(aFilename : string = '.' + PathDelim + 'Logs' + PathDelim + '{%APP}_{%DATE}.log'; DoTrim : boolean = True) ; reintroduce ;
      destructor Destroy ; override ;

      procedure Log(aMessage : string ; aLevel : TLogLevel = logInfo ; aModule : string = '') ;
      function LevelToStr(aLevel : TLogLevel) : string ;
    published
      property Filename : string  read fFilename write fFilename ;
      property logLevel : TLogLevel read fLogLevel write fLogLevel ;
      property logKeepDays : Integer read fLogKeepDays write fLogKeepDays ;
      property App : string          read fApp        write fApp ;
      property DoTrim : boolean      read fDoTrim     write fDoTrim ;
    end;
//==============================================================================
    function strLPad(aStr : string ; aLen : integer ; aChar : char = ' ') : string ;
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
//==============================================================================

//==============================================================================
//==============================================================================
//==============================================================================
constructor TLogFile.Create(aFilename: string; DoTrim : boolean);
begin
    inherited create(true) ;

    fFilename := aFilename ;
    fLogLevel := logInfo ;
    fLogKeepDays := 31 ;

    fApp := ChangeFileExt(ExtractFileName(ParamStr(0)), '') ;

    fDoTrim := DoTrim ;

    InitializeCriticalSection(newLock) ;
    InitializeCriticalSection(logLock) ;
    newItems := TStringList.Create ;
    logItems := TStringList.Create ;

    resume ;
end;
//------------------------------------------------------------------------------
destructor TLogFile.Destroy;
begin
    Terminate ; Resume ; WaitFor ;

    EnterCriticalSection(logLock) ;
    try
        LogItems.Clear ;
        LogItems.Free ;
    finally
        LeaveCriticalSection(logLock) ;
    end;

    DeleteCriticalSection(newLock) ;
    DeleteCriticalSection(logLock) ;

    inherited ;
end;
//------------------------------------------------------------------------------
procedure TLogFile.Execute;
var
  slowTimer : integer ;
begin
    inherited ;

    slowTimer := 0 ;

    while not Terminated do
    begin
          sleep(100) ;
          try

              getNewItems ;
              writeToFile ;

              inc(slowTimer) ;
              if (slowTimer > 100) then
              begin
                  slowTimer := 0 ;
                  cleanupLogFiles ;
              end;

          except
          end;
    end;
end;
//------------------------------------------------------------------------------
procedure TLogFile.Log(aMessage: string; aLevel: TLogLevel = logInfo ; aModule : string = '');
var
    sLog : string ;
begin
    EnterCriticalSection(newLock) ;
    try
        if not Terminated then
        begin
            if aLevel >= fLogLevel  then
            begin
                if FDoTrim then
                  aMessage := Trim(aMessage) ;
                aMessage := stringReplace(aMessage, #13#10, ' ', [rfReplaceAll]) ;
                aMessage := stringReplace(aMessage, #13, ' ', [rfReplaceAll]) ;
                aMessage := stringReplace(aMessage, #10, ' ', [rfReplaceAll]) ;

                sLog := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ' | ' ;
                sLog := sLog + StrLPad(aModule, 16) + ' | ' ;
                sLog := sLog + LevelToStr(aLevel) + ' | ' ;
                sLog := sLog + aMessage ;

                newItems.Add(sLog) ;
            end;
        end;
    finally
        LeaveCriticalSection(newLock) ;
    end;
end;
//------------------------------------------------------------------------------
function TLogFile.LevelToStr(aLevel: TLogLevel) : string ;
var
  iA : integer ;
begin
    Result := '   ' ;
    try
        ia := ord(aLevel) ;
        if ((ia < 0) or (ia > 8)) then Exit ;

        Result := LogLevelStr[ia] ;
    except
    end;
end;
//------------------------------------------------------------------------------
procedure TLogFile.getNewItems;
var
  sLogItem : string ;
begin
    EnterCriticalSection(newLock) ;
    EnterCriticalSection(logLock) ;
    try
        while newItems.Count > 0 do
        begin
            sLogItem := newItems[0] ;

            if (logItems.Count < 1000)
                then logItems.Add(sLogItem) ;

            newItems.Delete(0) ;
        end;
    finally
        leaveCriticalSection(logLock) ;
        leaveCriticalSection(newLock) ;
    end;
end;
//------------------------------------------------------------------------------
procedure TLogFile.writeToFile ;
var
    sLogItem  : string ;
    vFilename : string ;
    vPath     : string ;
    fFile     : TextFile ;
begin
    try
        vFilename := stringReplace(fFilename, '{%DATE}', FormatDateTime('yyyy-mm-dd', Now), [rfReplaceAll]) ;
        vFilename := stringReplace(vFilename, '{%APP}', ChangeFileExt(ExtractFileName(ParamStr(0)), ''), [rfReplaceAll]) ;
        vFilename := ExpandFileName(vFilename) ;

        vPath := ExtractFilePath(vFilename) ;
        if vPath = '' then Exit ;
        if not ForceDirectories(vPath) then Exit ;

        EnterCriticalSection(logLock) ;
        try
            if LogItems.Count > 0 then
            begin
                try
                    AssignFile(fFile, vFilename) ;

                    {$I-}
                    if FileExists(vFilename)
                        then Append(fFile)
                        else Rewrite(fFile) ;
                    {$I+}

                    try
                        while LogItems.Count > 0 do
                        begin
                            sLogItem := LogItems[0] ;
                            WriteLn(fFile, sLogItem) ;

                            LogItems.Delete(0) ;
                        end ;
                    finally
                        CloseFile(fFile) ;
                    end;
                except
                end;
            end ;
        finally
            LeaveCriticalSection(logLock) ;
        end;
    except
    end;
end;
//------------------------------------------------------------------------------
procedure TLogFile.cleanupLogFiles ;
var
    sSearch  : string ;
    sFilename : string ;
    srSearch : TSearchRec ;
begin
    if fLogKeepDays < 1 then Exit ;

    try
        sSearch := ExpandFileName(fFilename) ;
        sSearch := stringreplace(sSearch, '{%DATE}', '????-??-??', [rfReplaceAll]) ;
        sSearch := stringReplace(sSearch, '{%APP}', fApp, [rfReplaceAll]) ;

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
end.
