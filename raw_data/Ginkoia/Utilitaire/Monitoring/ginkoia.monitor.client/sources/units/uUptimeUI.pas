unit uUptimeUI;

interface

uses
  System.Classes, uUptime;

type
  TUptimeEvent = procedure(const Creation, Uptime: TDateTime) of object;

  TUptime = class( TThread )
  private const
    cSleepTime = 25;
  private
    FOnUpdate: TUptimeEvent;
  protected
    procedure Execute; override;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    property OnUpdate: TUptimeEvent read FOnUpdate write FOnUpdate;
  end;

implementation

{ TUptime }

constructor TUptime.Create;
begin
  inherited Create( True );
  FreeOnTerminate := False;
//  Start;
end;

destructor TUptime.Destroy;
begin
  Terminate;
  WaitFor;
  inherited;
end;

procedure TUptime.Execute;
begin
  inherited;
  while not Terminated do begin
    if Assigned( FOnUpdate ) then
      FOnUpdate( uUptime.TUptimeRec.CreationTime, uUptime.TUptimeRec.Uptime );
    Sleep( cSleepTime );
  end;
end;

end.
