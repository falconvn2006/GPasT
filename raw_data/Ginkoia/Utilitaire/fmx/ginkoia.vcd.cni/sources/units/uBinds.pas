unit uBinds;

interface

uses
  System.Generics.Collections,
  FMX.Controls;

type
  TBindAction = type System.Cardinal;
  TBindActionRec = record
  const
    None = TBindAction( $000000 );
    Prior = TBindAction( $000001 );
    Next = TBindAction( $000002 );
    Capture = TBindAction( $000003 );
    Uncapture = TBindAction( $000004 );
    ToggleCapture = TBindAction( $000005 );
    Close = TBindAction( $000006 );
    Save = TBindAction( $000007 );
    Permissions = TBindAction( $000008 );
  public
    BindAction: TBindAction;
    constructor Create(const BindAction: TBindAction);
  end;

  TBindControl = class sealed
  private
    FControl: FMX.Controls.TControl;
    function GetEnabled: Boolean;
    procedure SetEnabled(const Value: Boolean);
  public
    constructor Create(const Control: FMX.Controls.TControl ); reintroduce;
    { properties }
    property Control: FMX.Controls.TControl read FControl write FControl;
    property Enabled: Boolean read GetEnabled write SetEnabled;
  end;

  TBindActionNotify = procedure(const BindControl: TBindControl;
    const BindAction: TBindAction) of object;

  TBind = class sealed
  private
    FBindControl: TBindControl;
    FBindAction: TBindAction;
    FOnClick: TBindActionNotify;
    procedure DoClick(Sender: TObject);
  public
    constructor Create(const BindControl: TBindControl;
      const BindAction: TBindAction);
    destructor Destroy; override;
    { properties }
    property Control: TBindControl read FBindControl write FBindControl;
    property Action: TBindAction read FBindAction write FBindAction;
    { events }
    property OnClick: TBindActionNotify read FOnClick write FOnClick;
  end;

  TBinds = class sealed( TObjectList< TBind > )
  private
    FOnClick: TBindActionNotify;
    procedure DoClick(const BindControl: TBindControl;
      const BindAction: TBindAction);
    function GetEnabled(const BindAction: TBindAction): Boolean;
    procedure SetEnabled(const BindAction: TBindAction; const Value: Boolean);
  public
    constructor Create; reintroduce; overload;
    constructor Create(const Binds: array of TBind); overload;
    function Add(const Value: TBind): Integer; reintroduce;
    procedure AddRange(const Values: array of TBind); reintroduce;
    { properties }
    property Enabled[const BindAction: TBindAction]: Boolean read GetEnabled write SetEnabled;
    { events }
    property OnClick: TBindActionNotify read FOnClick write FOnClick;
  end;

implementation

{ TBindActionRec }

constructor TBindActionRec.Create(const BindAction: TBindAction);
begin
  Self := TBindActionRec( BindAction );
end;

{ TBind }

constructor TBind.Create(const BindControl: TBindControl;
  const BindAction: TBindAction);
begin
  inherited Create;
  FBindAction := BindAction;
  FBindControl := BindControl;
  FBindControl.Control.OnClick := DoClick;
end;

destructor TBind.Destroy;
begin
  FBindControl.Free;
  inherited;
end;

procedure TBind.DoClick(Sender: TObject);
begin
  if Assigned( FOnClick ) then
    FOnClick( Control, Action );
end;

{ TBindControl }

constructor TBindControl.Create(const Control: FMX.Controls.TControl);
begin
  inherited Create;
  FControl := Control;
end;

function TBindControl.GetEnabled: Boolean;
begin
  Result := FControl.Enabled;
end;

procedure TBindControl.SetEnabled(const Value: Boolean);
begin
  FControl.Enabled := Value;
end;

{ TBinds }

function TBinds.Add(const Value: TBind): Integer;
begin
  Value.OnClick := DoClick;
  Result := inherited Add( Value );
end;

constructor TBinds.Create;
begin
  inherited Create( True );
end;

procedure TBinds.AddRange(const Values: array of TBind);
var
  i: Integer;
begin
  for i := Low( Values ) to High( Values ) do
    Add( Values[ i ] );
end;

constructor TBinds.Create(const Binds: array of TBind);
begin
  Create;
  AddRange( Binds );
end;

procedure TBinds.DoClick(const BindControl: TBindControl;
  const BindAction: TBindAction);
begin
  if Assigned( FOnClick ) then
    FOnClick( BindControl, BindAction );
end;

function TBinds.GetEnabled(const BindAction: TBindAction): Boolean;
var
  Bind: TBind;
begin
  { TODO -cFix : Fix }
  Result := True;
  for Bind in Self do
    if Bind.Action = BindAction then
      Result := Result and Bind.Control.Enabled;
end;

procedure TBinds.SetEnabled(const BindAction: TBindAction;
  const Value: Boolean);
var
  Bind: TBind;
begin
  for Bind in Self do
    if Bind.Action = BindAction then
      Bind.Control.Enabled := Value;
end;

end.
