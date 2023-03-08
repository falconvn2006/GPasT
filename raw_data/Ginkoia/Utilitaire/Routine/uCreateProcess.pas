unit uCreateProcess ;

{$M+}

interface

uses
  Classes,
  SysUtils,
  Windows,
  Forms, TlHelp32 ;

const
  MaxCardinal = 4294967295;

type
  TFifo = class(TObject)
  private
    FBuffer : TBytes ;
    FLen    : Cardinal ;
    FPos    : Cardinal ;
    FLock   : TRTLCriticalSection ;
    FLineSeparator : string ;
    FLineMax : Cardinal ;
    function GetEmpty: Boolean;
  public
    constructor Create ;
    destructor Destroy ; override ;

    function Read(var aBuffer ; aCount : Cardinal) : Cardinal ;
    function readAnsiLine : Ansistring ;
    function readLine : string ;

    function Write(const aBuffer; aCount : Cardinal) : Cardinal ;
    function WriteString(aString: WideString): Cardinal; overload ;
    function WriteString(aString: AnsiString): Cardinal; overload ;
    function Writeln(aString: String): Cardinal;
  published
    property LineSeparator : string   read FLineSeparator   write FLineSeparator ;
    property LineMax : Cardinal       read FLineMax         write FLineMax ;

    property Empty: Boolean read GetEmpty;
  end;

  TCreateProcess = class(TThread)
  private
    FName  : string ;
    FCmd   : string ;
    FParam : string ;
    FPath  : string ;

    FStreamStdIn  : THandleStream ;
    FStreamStdOut : THandleStream ;
    FStreamStdErr : THandleStream ;

    FProcessInfo : TProcessInformation ;

    FStdIn  : TFifo ;
    FStdOut : TFifo ;
    FStdErr : TFifo ;

    FTimeout : Cardinal ;
    FThreaded : boolean ;
    FKilled : boolean ;
    FFinished : boolean ;
    FRunning  : boolean ;
    FError    : boolean ;

    FErrorCode  : Cardinal ;
    FErrorMessage : string ;
    FReturnCode : Cardinal ;

    FOnStdIn    : TNotifyEvent ;
    FOnStdOut   : TNotifyEvent ;
    FOnStdErr   : TNotifyEvent ;
    FOnFinished : TNotifyEvent;
    FOnError    : TNotifyEvent;
    FSynchronized: boolean;

    procedure doOnStdIn ;
    procedure doOnStdOut ;
    procedure doOnStdErr ;
    procedure doOnFinished ;
    procedure doOnError ;
  public
    constructor Create ; reintroduce ;
    destructor Destroy ; override ;
    procedure Execute ; override ;

    procedure Run ;
    function RunAndWait(aTimeout : Integer = 0) : Cardinal ;
    function Kill(aCodeRetour : Cardinal = MaxCardinal) : boolean;
  published
    property Sychronized : boolean  read FSynchronized write FSynchronized ;
    property Name : string          read FName   write FName;
    property Cmd : String           read FCmd    write FCmd ;
    property Param : string         read FParam  write FParam;
    property Path : String          read FPath   write FPath ;
    property ReturnCode : Cardinal  read FReturnCode ;
    property ErrorCode  : Cardinal  read FErrorCode ;
    property ErrorMsg   : String    Read FErrorMessage ;

    property StdIn  : TFifo    read FStdIn ;
    property StdOut : TFifo    read FStdOut ;
    property StdErr : TFifo    read FStdErr ;

    property ProcessInfo : TProcessInformation read FProcessInfo;

    property OnStdIn  : TNotifyEvent read FOnStdIn  write FOnStdIn ;
    property OnStdOut : TNotifyEvent read FOnStdOut write FOnStdOut ;
    property OnStdErr : TNotifyEvent read FOnStdErr write FOnStdErr ;

    property onFinished : TNotifyEvent read FOnFinished write FOnFinished ;
    property onError : TNotifyEvent read FOnError write FOnError ;

    property Finished : boolean     read FFinished ;
    property Running : boolean      read FRunning ;
    property Error : boolean        read FError ;
  end;

  TStdStream = class(TThread)
  private
    FStreamStdIn  : THandleStream ;
    FStreamStdOut : THandleStream ;
    FStreamStdErr : THandleStream ;

    FStdIn  : TFifo ;
    FStdOut : TFifo ;
    FStdErr : TFifo ;

    FOnStdErr: TNotifyEvent;
    FOnStdOut: TNotifyEvent;
    FOnStdIn: TNotifyEvent;

    procedure doOnStdIn ;
    procedure doOnStdOut ;
    procedure doOnStdErr ;
  public
    constructor Create ; reintroduce ;
    destructor Destroy ; override ;
    procedure Execute ; override ;
  published
    property StdIn  : TFifo    read FStdIn ;
    property StdOut : TFifo    read FStdOut ;
    property StdErr : TFifo    read FStdErr ;

    property OnStdIn  : TNotifyEvent read FOnStdIn  write FOnStdIn ;
    property OnStdOut : TNotifyEvent read FOnStdOut write FOnStdOut ;
    property OnStdErr : TNotifyEvent read FOnStdErr write FOnStdErr ;
  end;

//  function WTSGetActiveConsoleSessionId : LongWord; stdcall; external 'kernel32.dll';
  function WTSQueryUserToken(SessionId : LongWord; out phToken : THandle) : boolean; stdcall; external 'Wtsapi32.dll';
//  function RunInteractive(sExe : String) : boolean;
//  function getWindowsSessionId : String;
function processExists(exeName: string): Boolean;

implementation

function processExists(exeName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(exeName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(exeName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

{function getWindowsSessionId : String;
var
  hToken : THandle;
  cbBuf: Cardinal;
  ptiUser: PTokenUser;
  sid : PChar;
begin
  result := '';
  if WTSQueryUserToken(WtsGetActiveConsoleSessionID, hToken) then
  begin
    ptiUser := AllocMem(cbBuf*2);
    try
      if GetTokenInformation(hToken, TokenUser, ptiUser, cbBuf*2, cbBuf) then
        if ConvertSidToStringSid(ptiUser^.User.Sid, sid) then
          result := String(sid);
    finally
      FreeMem(ptiUser);
      CloseHandle(hToken);
    end;
  end;
end;}

{function RunInteractive(sExe: String): boolean;
var
  hToken: THandle;
  si: _STARTUPINFOW;
  pi: _PROCESS_INFORMATION;
begin
  ZeroMemory(@si, SizeOf(si));
  si.cb := SizeOf(si);
  si.lpDesktop := nil;

  if WTSQueryUserToken(WtsGetActiveConsoleSessionID, hToken) then
  begin
    result := CreateProcessAsUser(hToken, PChar(sExe), nil, nil, nil, False, 0, nil, nil, si, pi) ;
  end else begin
    result := false;
  end;
  CloseHandle(hToken);
end;}

{ TCreateProcess }

constructor TCreateProcess.Create;
begin
  inherited Create(true) ;
  FreeOnTerminate := true ;

  FCmd := '';
  FPath := '';

  FStreamStdIn := nil;
  FStreamStdOut := nil;
  FStreamStdErr := nil;

  ZeroMemory(@FProcessInfo, SizeOf(TProcessInformation));

  FStdIn  := TFifo.Create ;
  FStdOut := TFifo.Create ;
  FStdErr := TFifo.Create ;

  FTimeout := 0;
  FThreaded := false;
  FKilled := false;
  FFinished := false;
  FRunning := false;
  FError := false;

  FReturnCode := 0; FErrorCode := 0 ;

  FOnStdIn := nil;
  FOnStdOut := nil;
  FOnStdErr := nil;
  FOnFinished := nil;
  FOnError := nil;
  FSynchronized := true ;
end;

destructor TCreateProcess.Destroy;
begin
  FStdIn.Free;
  FStdOut.Free;
  FStdErr.Free;

  inherited;
end;

procedure TCreateProcess.doOnStdIn;
begin
  try
    if Assigned(FOnStdIn)
      then FOnStdIn(Self) ;
  except
  end;
end;

procedure TCreateProcess.doOnStdOut;
begin
  try
    if Assigned(FOnStdOut)
      then FOnStdOut(Self) ;
  except
  end;
end;

procedure TCreateProcess.doOnStdErr;
begin
  try
    if Assigned(FOnStdErr)
      then FOnStdErr(Self) ;
  except
  end;
end;

procedure TCreateProcess.doOnFinished;
begin
  try
    if Assigned(FOnFinished)
      then FOnFinished(Self) ;
  except
  end;
end;

procedure TCreateProcess.doOnError;
begin
  try
    if Assigned(FOnError)
      then FOnError(Self) ;
  except
  end;
end;

procedure TCreateProcess.Execute;
var
  HdlRIn, HdlWIn, HdlROut, HdlWOut, HdlRErr, HdlWErr : THandle ;
  sa : TSecurityAttributes;
  si : TStartUpInfo;

  ret : boolean;
  
  readBuffer : TBytes ;
  readCount : Cardinal ;
begin
  inherited;

  try
    setLength(readBuffer, 4096) ;

    // Params verification
    if (FCmd = '') then
    begin
      FError := true ;
      Exit ;
    end;
    // ajout de l'espace entre commande et paramètre
    if (Length(FParam) > 0) and not (FParam[1] = ' ') then
      FParam := ' ' + FParam;

    // Security Attributes
    ZeroMemory(@sa, SizeOf(TSecurityAttributes));
    sa.nlength := SizeOf(TSecurityAttributes);
    sa.lpsecuritydescriptor := nil;
    sa.binherithandle := true;

    ZeroMemory(@si, SizeOf(TStartUpInfo));
    si.cb := SizeOf(TStartUpInfo);
    si.dwFlags     := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
    si.wShowWindow := SW_SHOW ;

    CreatePipe(HdlRIn,  HdlWIn,  @sa, 0) ;
    CreatePipe(HdlROut, HdlWOut, @sa, 0) ;
    CreatePipe(HdlRErr, HdlWErr, @sa, 0) ;

    FStreamStdIn  := THandleStream.Create(HdlWIn);
    FStreamStdOut := THandleStream.Create(HdlROut);
    FStreamStdErr := THandleStream.Create(HdlRErr);

    try
      si.hStdInput := HdlRIn;
      si.hStdOutput := HdlWOut;
      si.hStdError  := HdlWErr ;

      if (FParam = '') then 
        ret := CreateProcess(nil, PChar(FCmd), @sa, @sa, true, NORMAL_PRIORITY_CLASS, nil, PChar(FPath), si, FProcessInfo)
      else
        ret := CreateProcess(PChar(FCmd), PChar(FCmd + FParam), @sa, @sa, true, NORMAL_PRIORITY_CLASS, nil, PChar(FPath), si, FProcessInfo);
      
      if ret then
      begin
        try
          FRunning := true ;

          while WaitForSingleObject(FProcessInfo.hProcess, 1) = WAIT_TIMEOUT do
          begin
            try
              readCount := FStdIn.Read(readBuffer[0], Length(readBuffer)) ;

              if readCount > 0 then
              begin
                  FStreamStdIn.Write(readBuffer[0], readCount);
                  if Assigned(OnStdIn) then
                  begin
                    if FSynchronized
                      then Synchronize(doOnStdIn)
                      else doOnStdIn ;
                  end;
              end;

            except
            end;

            try
              if FStreamStdOut.Size > 0 then
              begin
                readCount := FStreamStdOut.Read(readBuffer[0], Length(readBuffer)) ;
                FStdOut.Write(readBuffer[0], readCount) ;

                if Assigned(OnStdOut) and (readCount > 0) then
                begin
                  if FSynchronized
                    then Synchronize(doOnStdOut)
                    else doOnStdOut ;
                end;

              end;
            except
            end;

            try
              if FStreamStdErr.Size > 0 then
              begin
                readCount := FStreamStdErr.Read(readBuffer[0], Length(readBuffer)) ;
                FStdErr.Write(readBuffer[0], readCount) ;

                if Assigned(OnStdErr) and (readCount > 0) then
                begin
                  if FSynchronized
                    then Synchronize(doOnStdErr)
                    else doOnStdErr ;
                end;
              end;
            except
            end;
          end;

          FRunning := false ;
          GetExitCodeProcess(FProcessInfo.hProcess, FReturnCode) ;
        finally
          CloseHandle(FProcessInfo.hProcess);
          CloseHandle(FProcessInfo.hThread);
        end;
        FProcessInfo.hProcess := 0;
        FProcessInfo.hThread := 0;
      end
      else
      begin
        FRunning := false ;
        FErrorCode := GetLastError();
        FErrorMessage := SysErrorMessage(FErrorCode);
        FError := true ;
        if FSynchronized
          then Synchronize(doOnError)
          else doOnError ;
      end;

    finally
      CloseHandle(HdlRIn) ;
      CloseHandle(HdlWIn) ;
      CloseHandle(HdlROut) ;
      CloseHandle(HdlWOut) ;
      CloseHandle(HdlRErr) ;
      CloseHandle(HdlWErr) ;

      setLength(readBuffer, 0) ;
    end;

  finally
    FFinished := true ;

    if FSynchronized
      then Synchronize(doOnFinished)
      else doOnFinished ;
  end;
end;

procedure TCreateProcess.Run;
begin
  // reinit des variable
  ZeroMemory(@FProcessInfo, SizeOf(TProcessInformation));
  FTimeout := 0;
  FThreaded := false;
  FKilled := false;
  FFinished := false;
  FRunning := false;
  FError := false;
  FReturnCode := 0;
  FErrorCode  := 0;

  // lancement !
  Resume ;
end;

function TCreateProcess.RunAndWait(aTimeout: Integer) : Cardinal ;
begin
  // reinit des variable
  ZeroMemory(@FProcessInfo, SizeOf(TProcessInformation));
  FTimeout  := aTimeout ;
  FThreaded := (MainThreadID <> GetCurrentThreadId) ;
  FKilled := false;
  FFinished := false;
  FRunning := false;
  FError := false;
  FReturnCode := 0;
  FErrorCode  := 0;

  // lancement !
  Resume ;

  // attente
  while not FFinished do
  begin
    if not FThreaded
      then Application.ProcessMessages ;

    sleep(1) ;
  end;

  Result := ReturnCode;
end;

function TCreateProcess.Kill(aCodeRetour : Cardinal) : boolean;
begin
  if FProcessInfo.hProcess <> 0 then
    Result := TerminateProcess(FProcessInfo.hProcess, aCodeRetour)
  else
    Result := false;
end;

{ TFifo }

constructor TFifo.Create;
begin
  inherited;

  FLineSeparator := WideString(#13#10) ;
  FLineMax       := 1024 ;

  FLen := 0 ; FPos := 0 ;
  SetLength(FBuffer, FLen);

  InitializeCriticalSection(FLock);
end;

destructor TFifo.Destroy;
begin
  SetLength(FBuffer, FLen);
  FLen := 0 ; FPos := 0 ;

  DeleteCriticalSection(FLock);

  inherited;
end;

function TFifo.GetEmpty: Boolean;
begin
  Result := FLen = 0;
end;

function TFifo.Read(var aBuffer; aCount: Cardinal): Cardinal;
var
  aLen : Cardinal ;
begin
  EnterCriticalSection(FLock);
  try
    aLen := aCount ;
    if FLen < aLen
      then aLen := FLen ;

    Move(FBuffer[0], aBuffer, aLen) ;
    Move(FBuffer[aLen], FBuffer[0], FLen - aLen) ;
    Dec(FLen, aLen) ;
    setLength(FBuffer, FLen) ;

    Result := aLen ;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

function TFifo.readAnsiLine: AnsiString;
var
  i : Cardinal ;
  aLen : Cardinal ;
  aSepLen : Cardinal ;
begin
  EnterCriticalSection(FLock);
  try
    aLen := FLen ;
    aSepLen := Length(FLineSeparator) * sizeof(AnsiChar) ;

    if aLen > FLineMax
      then aLen := FLineMax ;

    i := 0 ;

    while i < aLen do
    begin
      if CompareMem(@FBuffer[i], @FLineSeparator[1], aSepLen) then
      begin
        SetLength(Result, (i + aSepLen) div sizeof(AnsiChar)) ;
        aLen := Read(Result[1], (i + aSepLen)) ;
        Exit ;
      end else begin
        Inc(i, sizeof(AnsiChar)) ;
      end;
    end;

    Result := '' ;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

function TFifo.readLine: string;
var
  j: integer;
  i : Cardinal ;
  aLen : Cardinal ;
  aSepLen : Cardinal ;
  sBuff, tmp: string;
begin
  EnterCriticalSection(FLock);
  try
    aLen := FLen ;
    aSepLen := Length(FLineSeparator) * sizeof(WideChar) ;

    if aLen > FLineMax
      then aLen := FLineMax ;

    i := 0 ;

    while i < aLen do
    begin
      sBuff := '';
      for j := i to aLen - 1 do
      begin
        SetString(tmp, PChar(@FBuffer[j]), 1);
        if tmp <> #0 then        
          sBuff := sBuff + tmp;
      end;
//      SetString(tmp, PChar(@FBuffer[i]), aLen - i);
      if sBuff = FLineSeparator then
      begin
        SetLength(Result, (i + aSepLen) div sizeof(WideChar)) ;
        aLen := Read(Result[1], (i + aSepLen)) ;
        Exit ;
      end else begin
        Inc(i, sizeof(WideChar)) ;
      end;
    end;

    Result := '' ;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

function TFifo.Write(const aBuffer; aCount: Cardinal): Cardinal;
begin
  EnterCriticalSection(FLock);
  try
    setLength(FBuffer, FLen + aCount) ;
    Move(aBuffer, FBuffer[FLen], aCount) ;
    Inc(FLen, aCount) ;

    Result := aCount ;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

function TFifo.WriteString(aString : WideString) : Cardinal ;
begin
  Result := Write(aString[1], Length(aString) * sizeof(WideChar)) ;
end;

function TFifo.WriteString(aString : AnsiString) : Cardinal ;
begin
  Result := Write(aString[1], Length(aString) * sizeof(AnsiChar)) ;
end;

function TFifo.Writeln(aString : String) : Cardinal ;
begin
  Result := WriteString(aString + FLineSeparator) ;
end;

{ TStdStream }

constructor TStdStream.Create;
begin
  inherited Create(true) ;

  FStreamStdIn  := THandleStream.Create(GetStdHandle(STD_INPUT_HANDLE));
  FStreamStdOut := THandleStream.Create(GetStdHandle(STD_OUTPUT_HANDLE));
  FStreamStdErr := THandleStream.Create(GetStdHandle(STD_ERROR_HANDLE));

  FStdIn  := TFifo.Create ;
  FStdOut := TFifo.Create ;
  FStdErr := TFifo.Create ;

  FreeOnTerminate := false ;

  Resume ;
end;

destructor TStdStream.Destroy;
begin
  Terminate ; Resume ; WaitFor ;

  FStdIn.FRee;
  FStdOut.Free;
  FStdErr.Free;

  FStreamStdIn.Free;
  FStreamStdOut.Free;
  FStreamStdErr.Free;

  inherited;
end;

procedure TStdStream.doOnStdErr;
begin
  try
    if Assigned(FOnStdErr)
      then FOnStdErr(Self) ;
  except
  end;
end;

procedure TStdStream.doOnStdIn;
begin
  try
    if Assigned(FOnStdIn)
      then FOnStdIn(Self) ;
  except
  end;
end;

procedure TStdStream.doOnStdOut;
begin
  try
    if Assigned(FOnStdOut)
      then FOnStdOut(Self) ;
  except
  end;
end;

procedure TStdStream.Execute;
var
  readCount : Cardinal ;
  readBuffer : TBytes ;
  vReaded    : boolean ;
begin
  inherited;
  setLength(readBuffer, 4096) ;

  while not Terminated do
  begin
    vReaded := false ;

    // StdOut
    if FStreamStdOut.Handle > 0 then
    begin
      try
        readCount := FStdOut.Read(readBuffer[0], Length(readBuffer)) ;

        if readCount > 0 then
        begin
            FStreamStdOut.Write(readBuffer[0], readCount);
            Synchronize(doOnStdOut);
            vReaded := true ;
        end;

      except
      end;
    end;

    // StdErr
    if FStreamStdErr.Handle > 0 then
    begin
      try
        readCount := FStdErr.Read(readBuffer[0], Length(readBuffer)) ;

        if readCount > 0 then
        begin
            FStreamStdErr.Write(readBuffer[0], readCount);
            Synchronize(doOnStdOut);
            vReaded := true ;
        end;

      except
      end;
    end;

    // StdIn
    if FStreamStdIn.Handle > 0 then
    begin
      try
        if FStreamStdIn.Size > 0 then
        begin
          readCount := FStreamStdIn.Read(readBuffer[0], Length(readBuffer)) ;
          FStdIn.Write(readBuffer[0], readCount) ;

          if readCount > 0 then
          begin
            Synchronize(doOnStdIn) ;
            vReaded := true ;
          end ;
        end;
      except
      end;
    end ;

    if not vReaded
      then sleep(10) ;
  end;

end;

end.
