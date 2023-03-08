unit uGinkoiaTools ;

interface

uses  Classes, SysUtils,
  {$IF CompilerVersion >= 27.0}WinApi.Windows,{$IFEND}
  {$IF CompilerVersion < 27.0}Windows,{$IFEND}
      Forms,
      uCreateProcess, uLog ;

type
  TGinkoiaToolsStatus = (gtsNone, gtsStopped, gtsPaused, gtsRunning, gtsFinished, gtsFailed, gtsCanceled, gtsKilled) ;

  TGinkoiaTools = class
  private
    FStdStream : TStdStream ;

    FOnStart: TNotifyEvent;
    FOnPause: TNotifyEvent;
    FOnExit: TNotifyEvent;
    FOnCancel: TNotifyEvent;
    FOnStop: TNotifyEvent;
    FOnResume: TNotifyEvent;

    FStatus    : TGinkoiaToolsStatus ;
    FStatusReq : TGinkoiaToolsStatus ;
    FStarted   : boolean ;

    function getCanceled: boolean;
    function getPaused: boolean;
    function getStarted: boolean;
    function getStopped: boolean;
    function getFinished : boolean ;

    procedure StdStream_onStdIn(aSender : TObject) ;
    procedure doStart(aManual : boolean = false);
    procedure doPause(aManual : boolean = false);
    procedure doResume(aManual: boolean = false);
    procedure doStop(aManual : boolean = false);
    procedure doCancel(aManual : boolean = false);
    procedure doExit(aManual: boolean = false);
    procedure Log(aMsg: String; aLevel: TLogLevel = logInfo);
    function getRunning: boolean;
    function getActive: boolean;
  public
    constructor Create ;
    destructor Destroy ; override ;

    procedure start;
    procedure pause;
    procedure resume;
    procedure stop;
    procedure cancel;
    procedure reset ;

    procedure ready ;
    procedure started;
    procedure paused;
    procedure stopped;
    procedure resumed;
    procedure canceled;
    procedure success;
    procedure failed;

    procedure error(aMsg: string);
    procedure warning(aMsg: string);
    procedure notice(aMsg: string);
    procedure info(aMsg: string);
    procedure phase(aPhase: string);
    procedure progress(aProgress: integer);

    procedure exit;

    function mustStop: boolean;
  published
    property Active   : boolean        read getActive ;
    property onStart  : TNotifyEvent   read FOnStart     write FOnStart ;
    property onPause  : TNotifyEvent   read FOnPause     write FOnPause ;
    property onResume : TNotifyEvent   read FOnResume    write FOnResume ;
    property onStop   : TNotifyEvent   read FOnStop      write FOnStop ;
    property onCancel : TNotifyEvent   read FOnCancel    write FOnCancel ;
    property onExit   : TNotifyEvent   read FOnExit      write FOnExit ;

    property isStarted  : boolean  read getStarted ;
    property isRunning  : boolean  read getRunning ;
    property isPaused   : boolean  read getPaused ;
    property isStopped  : boolean  read getStopped ;
    property isCanceled : boolean  read getCanceled ;

    property isFinished : boolean  read getFinished ;
  end;

implementation

{ TGinkoiaTools }

function TGinkoiaTools.mustStop: boolean;
var
  vPaused : boolean ;
begin
  Result := false ;
  vPaused := false ;

  // Gestion de la pause
  if isPaused then
  begin
    VPaused := true ;
    paused ;
  end;

  while isPaused do
  begin
    sleep(10) ;
    if GetCurrentThreadId = MainThreadID then
    begin
      Application.ProcessMessages ;
    end ;
  end;

  if ((vPaused) and (FStatusReq = gtsRunning)) then
  begin
    resumed ;
  end;

  // Gestion du cancel et du stop
  Result := (isStopped or isCanceled) ;
end;

procedure TGinkoiaTools.ready;
begin
  FStatus := gtsStopped ;
  FStdStream.StdErr.Writeln('READY') ;
  Log('Process ready') ;
end;

procedure TGinkoiaTools.reset;
begin
  FStatus := gtsStopped ;
  FStarted := false ;
end;

procedure TGinkoiaTools.started ;
begin
  FStatus := gtsRunning ;
  FStdStream.StdErr.Writeln('STARTED') ;
  Log('Process started') ;
end;

procedure TGinkoiaTools.resumed ;
begin
  FStatus := gtsRunning ;
  FStdStream.StdErr.Writeln('RESUMED') ;
  Log('Process resumed') ;
end;

procedure TGinkoiaTools.StdStream_onStdIn(aSender: TObject);
var
  vLine : string ;
begin
  while not FStdStream.StdIn.Empty do
  begin
    vLine := Trim(FStdStream.StdIn.readLine) ;

    if vLine = 'START'
      then doStart ;

    if vLine = 'PAUSE'
      then doPause ;

    if vLine = 'RESUME'
      then doResume ;

    if vLine = 'STOP'
      then doStop ;

    if vLine = 'CANCEL'
      then doCancel ;

    if vLine = 'EXIT'
      then doExit ;
  end;
end;

procedure TGinkoiaTools.doStart(aManual:boolean) ;
begin
  FStarted   := true ;
  FStatusReq := gtsRunning ;
  if (aManual)
    then Log('Start requested manually')
    else Log('Start requested') ;

  if (FStatus = gtsStopped) then
  begin
    Log('Starting process') ;
    if Assigned(FOnStart) then
      FOnStart(Self) ;
  end else
  if (FStatus = gtsPaused) then
  begin
    Log('Resuming process') ;
    if Assigned(FOnResume) then
      FOnResume(Self) ;
  end;
end;

procedure TGinkoiaTools.doResume(aManual:boolean) ;
begin
  FStarted   := true ;
  FStatusReq := gtsRunning ;
  if (aManual)
    then Log('Resume requested manually')
    else Log('Resume requested') ;

  if (FStatus = gtsPaused) then
  begin
    Log('Resuming process') ;
    if Assigned(FOnResume) then
      FOnResume(Self) ;
  end;
end;

procedure TGinkoiaTools.doPause(aManual:boolean) ;
begin
  FStatusReq := gtsPaused ;
  if (aManual)
    then Log('Pause requested manually')
    else Log('Pause requested') ;

  if (FStatus = gtsRunning) then
  begin
    Log('Pausing process') ;
    if Assigned(FOnPause) then
      FOnPause(Self) ;
  end;
end;

procedure TGinkoiaTools.doStop(aManual:boolean) ;
begin
  FStatusReq := gtsStopped ;
  if (aManual)
    then Log('Stop requested manually')
    else Log('Stop requested') ;

  if (FStatus = gtsRunning) then
  begin
    Log('Stopping process') ;
    if Assigned(FOnStop) then
      FOnStop(Self) ;
  end;
end;

procedure TGinkoiaTools.doCancel(aManual : Boolean) ;
begin
  FStatusReq := gtsCanceled ;
  if (aManual)
    then Log('Cancel requested manually')
    else Log('Cancel requested') ;

  if (FStatus = gtsRunning) then
  begin
    Log('Canceling process') ;
    if Assigned(FOnCancel) then
      FOnCancel(Self) ;
  end else
  if (FStatus = gtsPaused) then
  begin
    Log('Canceling process') ;
    if Assigned(FOnCancel) then
      FOnCancel(Self) ;
  end else
  if (FStatus = gtsStopped) then
  begin
    Log('Canceling process') ;
    if Assigned(FOnCancel) then
      FOnCancel(Self) ;
  end;
end;

procedure TGinkoiaTools.doExit(aManual:boolean) ;
begin
  FStatusReq := gtsStopped ;
  if (aManual)
    then Log('Exit requested manually')
    else Log('Exit requested') ;

  if (FStatus <> gtsRunning) then
  begin
    Log('Exiting process') ;
    if Assigned(FOnExit) then
      FOnExit(Self) ;
  end;
end;


procedure TGinkoiaTools.paused ;
begin
  FStatus := gtsPaused ;
  FStdStream.StdErr.Writeln('PAUSED') ;
  Log('Process paused') ;
end;

procedure TGinkoiaTools.stopped ;
begin
  FStatus := gtsStopped ;
  FStdStream.StdErr.Writeln('STOPPED') ;
  Log('Process stopped') ;
end;

procedure TGinkoiaTools.start ;
begin
  doStart(true) ;
end;

procedure TGinkoiaTools.cancel;
begin
  doCancel(true);
end;

procedure TGinkoiaTools.resume;
begin
  doResume(true);
end;

procedure TGinkoiaTools.stop;
begin
  doStop(true) ;
end;

procedure TGinkoiaTools.pause;
begin
  doPause(true);
end;


procedure TGinkoiaTools.canceled ;
begin
  FStatus := gtsCanceled ;
  FStdStream.StdErr.Writeln('CANCELED') ;
  Log('Process canceled', logWarning) ;
end;

procedure TGinkoiaTools.success ;
begin
  FStatus := gtsFinished ;
  FStdStream.StdErr.Writeln('SUCCESS') ;
  Log('Process finished') ;
end;

procedure TGinkoiaTools.failed ;
begin
  FStatus := gtsFailed ;
  FStdStream.StdErr.Writeln('FAILED') ;
  Log('Process failed', logError) ;
end;

procedure TGinkoiaTools.error(aMsg : string) ;
begin
  FStdStream.StdErr.Writeln('ERROR ' + aMsg) ;
  Log('Error : ' + aMsg, logError) ;
end;

procedure TGinkoiaTools.warning(aMsg : string) ;
begin
  FStdStream.StdErr.Writeln('WARNING ' + aMsg) ;
  Log('Warning : ' + aMsg, logWarning) ;
end;

procedure TGinkoiaTools.notice(aMsg : string) ;
begin
  FStdStream.StdErr.Writeln('NOTICE ' + aMsg) ;
  Log('Notice : ' + aMsg, logNotice) ;
end;

procedure TGinkoiaTools.info(aMsg : string) ;
begin
  FStdStream.StdErr.Writeln('INFO ' + aMsg) ;
  Log('Info : ' + aMsg, logInfo) ;
end;

procedure TGinkoiaTools.phase(aPhase : string) ;
begin
  FStdStream.StdErr.Writeln('PHASE ' + aPhase) ;
end;

procedure TGinkoiaTools.progress(aProgress : integer) ;
begin
  if aProgress < 0
    then aProgress := 0 ;
  if aProgress > 100
    then aProgress := 100 ;

  FStdStream.StdErr.Writeln('PROGRESS ' + IntToStr(aProgress)) ;
end;

procedure TGinkoiaTools.exit ;
begin
  doExit(true);
end;

constructor TGinkoiaTools.Create;
begin
  inherited ;

  FStatus := gtsNone ;
  FStatusReq := gtsNone ;
  FStarted   := false ;
  
  FStdStream := TStdStream.Create ;
  FStdStream.OnStdIn := StdStream_onStdIn ;
end;

destructor TGinkoiaTools.Destroy;
begin
  FreeAndNil(FStdStream) ;

  inherited;
end;

function TGinkoiaTools.getActive: boolean;
begin
  Result := FStdStream.StdInHandle > 0 ;
end;

function TGinkoiaTools.getCanceled: boolean;
begin
  Result := (FStatusReq = gtsCanceled) ;
end;

function TGinkoiaTools.getFinished: boolean;
begin
  Result := (FStatus = gtsFinished) ;
end;

function TGinkoiaTools.getPaused: boolean;
begin
  Result := (FStatusReq = gtsPaused) ;
end;

function TGinkoiaTools.getRunning: boolean;
begin
  Result := (FStatus = gtsRunning) ;
end;

function TGinkoiaTools.getStarted: boolean;
begin
  Result := FStarted ;
end;

function TGinkoiaTools.getStopped: boolean;
begin
  Result := (FStatusReq = gtsStopped) ;
end;

procedure TGinkoiaTools.Log(aMsg : String ; aLevel : TLogLevel) ;
begin
  uLog.Log.Log('GinkoiaTools', 'Log', aMsg, aLevel, true, -1, ltLocal);
end;

end.
