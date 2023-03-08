unit uTilesCustom;

interface

uses
  System.Generics.Collections, { TObjectList }
  System.Classes, { TThread }
  uTile; { TTile }

type
  TTilesCustom = class( TObjectList< TTile > )
  strict private const
    cDefaultFrequency = 1000;
  strict private type
    TTimer = class( TThread )
    private
      FFrequency: Cardinal;
      FOnTimer: TNotifyEvent;
    protected
      procedure DoTimer(Sender: TObject);
      procedure Execute; override;
    public
      { constructor / destructor }
      constructor Create(const CreateSuspended: Boolean;
        const OnTimer: TNotifyEvent;
        const Frequency: Cardinal = cDefaultFrequency); reintroduce;
      destructor Destroy; override;
      { properties }
      property Frequency: Cardinal read FFrequency write FFrequency;
      { events }
      property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
    end;
  strict private
    FTimer: TTimer;
  protected
    procedure DoTimer(Sender: TObject); virtual;
  private
    FOnTimer: TNotifyEvent;
    FOnBeforeTimer: TNotifyEvent;
    FOnAfterTimer: TNotifyEvent;
    FEnabled: Boolean;
    function GetFrequency: Cardinal;
    procedure SetFrequency(const Value: Cardinal);
  public
    { constructor / destructor }
    constructor Create; reintroduce; virtual;
    destructor Destroy; override;
    { properties }
    property Enabled: Boolean read FEnabled write FEnabled;
    property Frequency: Cardinal read GetFrequency write SetFrequency;
    { events }
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
  end;

implementation

{ TTilesCustom.TTimer }

constructor TTilesCustom.TTimer.Create(const CreateSuspended: Boolean;
  const OnTimer: TNotifyEvent; const Frequency: Cardinal);
begin
  FFrequency := Frequency;
  FOnTimer := OnTimer;
  inherited Create( CreateSuspended );
end;

destructor TTilesCustom.TTimer.Destroy;
begin
  Terminate;
  WaitFor;
  inherited;
end;

procedure TTilesCustom.TTimer.DoTimer(Sender: TObject);
begin
  if Assigned( FOnTimer ) then
    FOnTimer( Self );
end;

procedure TTilesCustom.TTimer.Execute;
begin
  inherited;
  while not Terminated do begin
    DoTimer( Self );
    Sleep( FFrequency );
  end;
end;

{ TTiles }

constructor TTilesCustom.Create;
begin
  inherited Create( True );
  FEnabled := True;
  FTimer := TTimer.Create( False, DoTimer );
end;

destructor TTilesCustom.Destroy;
begin
  FTimer.Free;
  inherited;
end;

procedure TTilesCustom.DoTimer(Sender: TObject);
var
  i: Integer;
begin
  if not FEnabled then
    Exit;

  for i := 0 to Count - 1 do
    if Assigned( Items[ i ] ) then
      Items[ i ].Synchronize;
end;

function TTilesCustom.GetFrequency: Cardinal;
begin
  if Assigned( FTimer ) then
    Exit( FTimer.Frequency );
end;

procedure TTilesCustom.SetFrequency(const Value: Cardinal);
begin
  if Assigned( FTimer ) then
    FTimer.Frequency := Value;
end;

end.
