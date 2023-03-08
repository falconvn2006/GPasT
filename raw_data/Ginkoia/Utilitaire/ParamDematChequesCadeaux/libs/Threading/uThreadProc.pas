unit uThreadProc;

{$WARN SYMBOL_DEPRECATED OFF}

interface

uses Classes, SysUtils, Forms ;

type
  TProcError = reference to procedure( aException : Exception ) ;

  {$M+}
  TThreadProc = class(TThread)
  private
    FWait       : boolean ;

    procedure doFinish ;
    procedure doError ;
    procedure doFinally;

  protected
    FFinish     : TProc ;
    FError      : TProcError ;
    FFinally    : TProc;
    FException  : Exception ;
    FRun     : TProc ;

    procedure Execute ; override ;

  public
    constructor Create ; reintroduce ;

    class function RunInThread(aProc: TProc) : TThreadProc ;
    function whenFinish(aProc: TProc) : TThreadProc ;
    function whenError(aProc : TProcError) : TThreadProc ;
    function whenFinally(aProc: TProc): TThreadProc;
    function Run : TThreadProc ;
    function RunAndWait: TThreadProc;
    class procedure Kill(var aThreadProc: TThreadProc) ;
    procedure SynchonizeProc(aProc : TThreadProcedure) ;

  published
    property Terminated ;
  end;
  {$M-}

implementation

{ TThreadProc }

constructor TThreadProc.Create;
begin
  inherited Create(true) ;
  FRun     := nil ;
  FFinish  := nil ;
  FError   := nil ;
  FFinally := nil;
  FWait    := true ;

  FreeOnTerminate := true ;
end;

procedure TThreadProc.doFinish;
begin
  if Assigned(FFinish) then
  begin
    try
      FFinish() ;
    except
    end;
  end;
end;

procedure TThreadProc.doError;
begin
  if Assigned(FError) then
  begin
    try
      FError(FException) ;
    except
    end;
  end;
end;

procedure TThreadProc.doFinally;
begin
  if Assigned(FFinally) then
  begin
    try
      FFinally;
    except
    end;
  end;
end;

procedure TThreadProc.Execute;
begin
  inherited;

  try
    try
      FRun() ;

      if not Terminated then
      begin
        if Assigned(FFinish) then
          Synchronize(doFinish) ;
      end ;
    except
      on E: Exception do
      begin
        FException := E ;
        if Assigned(FError) then
          Synchronize(doError) ;
      end;
    end;
  finally
    if Assigned(FFinally) then
      Synchronize(doFinally);

      FWait := false ;
  end;
end;

class procedure TThreadProc.Kill(var aThreadProc: TThreadProc);
begin
  aThreadProc.FreeOnTerminate := false;
  aThreadProc.Terminate;
  aThreadProc.Resume;
  aThreadProc.WaitFor;
  aThreadProc.Free;
  aThreadProc := nil;
end;

function TThreadProc.Run: TThreadProc;
begin
  if Assigned(FRun) then
    Start ;

  Result := Self ;
end;

function TThreadProc.RunAndWait: TThreadProc;
begin
  Run;
  Result := Self;

  while FWait do
  begin
    if CurrentThread.ThreadID = MainThreadID then
      Application.ProcessMessages;

    if FWait then
      Sleep(10);
  end;
end;

class function TThreadProc.RunInThread(aProc: TProc): TThreadProc;
begin
  Result := TThreadProc.Create ;
  Result.FRun := aProc ;
end;

procedure TThreadProc.SynchonizeProc(aProc: TThreadProcedure);
begin
  Synchronize(aProc);
end;

function TThreadProc.whenFinish(aProc: TProc): TThreadProc;
begin
  FFinish := aProc ;
  Result := Self ;
end;

function TThreadProc.whenError(aProc: TProcError): TThreadProc;
begin
  FError := aProc ;
  Result := Self ;
end;

function TThreadProc.whenFinally(aProc: TProc): TThreadProc;
begin
  FFinally := aProc;
  Result := Self;
end;

end.
