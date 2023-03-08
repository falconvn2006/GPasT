unit server.utils.thread.timer;

interface

uses
  System.Classes, System.SyncObjs, System.SysUtils;

type
  TThreadTimer = class(TThread)
  private
    FEvent : TEvent;
    FOnTimer: TProc;
    FInterval: Integer;
  protected
    procedure Execute; override;
    procedure DoTimer;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure ForceTerminate;

    function Interval(aValue : Integer) : TThreadTimer;
    function OnTimer(aValue : TProc) : TThreadTimer;
  end;
implementation

{ TThreadTimer }

procedure TThreadTimer.AfterConstruction;
begin
  inherited;
  FInterval := 1000;
  FEvent := TEvent.Create;
end;

procedure TThreadTimer.BeforeDestruction;
begin
  inherited;
  FEvent.Free;
end;

procedure TThreadTimer.DoTimer;
begin
  if Assigned(FOnTimer) then
    FOnTimer;

end;

procedure TThreadTimer.Execute;
var
  LWaitResult : TWaitResult;
begin
  inherited;
  while not Self.Terminated do
  begin
    LWaitResult := FEvent.WaitFor(FInterval);
    if LWaitResult <> TWaitResult.wrTimeout then
      Exit;
    DoTimer;
  end;
end;

procedure TThreadTimer.ForceTerminate;
begin
  FEvent.SetEvent;
end;

function TThreadTimer.Interval(aValue: Integer): TThreadTimer;
begin
  Result := Self;
  FInterval := aValue;
end;

function TThreadTimer.OnTimer(aValue: TProc): TThreadTimer;
begin
  Result := Self;
  FOnTimer := aValue;
end;

end.
