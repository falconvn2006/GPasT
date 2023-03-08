unit uThreadProc;

interface

uses Classes, SysUtils, Forms;

type
  TProcError = reference to procedure( aException : Exception ) ;

  TThreadProc = class(TThread)
  private
    FFinish     : TProc ;
    FError      : TProcError ;
    FException  : Exception ;
    procedure doError ;
    procedure doFinish ;
  protected
    FRun     : TProc ;
    procedure Execute ; override ;
  public
    constructor Create ; reintroduce ;

    class function RunInThread(aProc: TProc) : TThreadProc ;
    function whenFinish(aProc: TProc) : TThreadProc ;
    function whenError(aProc : TProcError) : TThreadProc ;
    function Run : TThreadProc ;
    function RunAndWait: TThreadProc;

    procedure SynchonizeProc(aProc : TThreadProcedure) ;
  published
    property Terminated ;
  end;

implementation

{ TThreadProc }

constructor TThreadProc.Create;
begin
  inherited Create(true) ;
  FRun     := nil ;
  FError   := nil ;
  FFinish  := nil ;

  FreeOnTerminate := true ;
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

procedure TThreadProc.Execute;
begin
  inherited ;

  try
    FRun() ;

    if not Terminated then
    begin
      if Assigned(FFinish) then
        Synchronize(doFinish);
      Terminate;
    end ;
  except
    on E:Exception do
    begin
      FException := E ;
      if Assigned(FError) then
        Synchronize(doError);
      Terminate;
    end;
  end;
end;

function TThreadProc.Run: TThreadProc;
begin
  if Assigned(FRun) then
    Start ;

  Result := Self ;
end;

function TThreadProc.RunAndWait: TThreadProc;
begin
  if Assigned(FRun) then
    Start;

  while not Terminated do
  begin
    Application.ProcessMessages;
    Sleep(20);
  end;

  Result := Self;
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

function TThreadProc.whenError(aProc: TProcError): TThreadProc;
begin
  FError := aProc ;
  Result := Self ;
end;

function TThreadProc.whenFinish(aProc: TProc): TThreadProc;
begin
  FFinish := aProc ;
  Result := Self ;
end;

end.

