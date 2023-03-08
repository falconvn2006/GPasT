unit uPermissions;

interface

uses
  System.Generics.Collections, System.SysUtils;

type
  { Forward class declarations }
  TPermissions = class;

  TPermission = type System.Cardinal;
  TPermissionRec = record
  const
    Creatable = TPermission( $000000 );
    Editable = TPermission( $000001 );
    Deletable = TPermission( $000002 );
    Searchable = TPermission( $000003 );
  public
    Permission: TPermission;
    constructor Create(const Permission: TPermission);
  end;

//  TBooleanArray = TArray< Boolean >;

  TPermissions = class( TList< TPermission > )
  private
  public
    constructor Create; reintroduce; overload;
    constructor Create(const Permissions: array of TPermission); overload;
    { methods }
    class function All: TPermissions;
    class function Default: TPermissions;
    class function IntToPermissions(const Value: Integer): TPermissions;
    class function PermissionsToInt(const Value: TPermissions): Integer;
    function Add(const Value: TPermission): Integer; reintroduce;
    procedure AddRange(const Values: array of TPermission); reintroduce;
    function IsPermitted(const Permission: TPermission): Boolean; overload;
    function IsPermitted(const Permissions: array of TPermission): Boolean; overload;
    procedure ProceedIfPermitted(const Permission: array of TPermission; const Proc: TProc);
  end;

  EPermissionNotPermitted = class( Exception );

implementation

{ TPermissionRec }

constructor TPermissionRec.Create(const Permission: TPermission);
begin
  Self := TPermissionRec( Permission );
end;

{ TPermissions }

function TPermissions.Add(const Value: TPermission): Integer;
begin
  Result := IndexOf( Value );
  if Result < 0 then
    Result := inherited Add( Value );
end;

constructor TPermissions.Create;
begin
  inherited;
end;

procedure TPermissions.AddRange(const Values: array of TPermission);
var
  i: Integer;
begin
  for i := Low( Values ) to High( Values ) do
    Add( Values[ i ] );
end;

class function TPermissions.All: TPermissions;
var
  i: Integer;
begin
{ TODO -cbug : fix this bug }
  Result := TPermissions.Create;
  for i := Low( TPermission ) to High( TPermission ) do
    Result.Add( TPermissionRec.Create( i ).Permission );
end;

constructor TPermissions.Create(const Permissions: array of TPermission);
begin
  Create;
  AddRange( Permissions );
end;

class function TPermissions.Default: TPermissions;
begin
  Result := TPermissions.Create( [ TPermissionRec.Creatable ] );
end;

class function TPermissions.IntToPermissions(
  const Value: Integer): TPermissions;
var
  Permission: TPermission;
begin
  Result := TPermissions.Create;
//  for Permission := Low( TPermission ) to High( TPermission ) do
  for Permission := 0 to 10 do
    if Value and ( 1 shl Ord( Permission ) ) > 0 then
      Result.Add( Permission )
end;

function TPermissions.IsPermitted(const Permission: TPermission): Boolean;
begin
  Result := IndexOf( Permission ) >= 0;
end;

function TPermissions.IsPermitted(
  const Permissions: array of TPermission): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := Low( Permissions ) to High( Permissions ) do
    Result := Result and IsPermitted( Permissions[ i ] );

//  Initialize( Result );
//  SetLength( Result, Length( Permissions ) );
//  for i := Low( Permissions ) to High( Permissions ) do
//    Result[ i + Low( Result ) ] := IsPermitted( Permissions[ i ] );
end;

class function TPermissions.PermissionsToInt(
  const Value: TPermissions): Integer;
var
  Permission: TPermission;
begin
  Result := 0;
  for Permission in Value do
    Inc( Result, 1 shl Ord( Permission ) );
end;

procedure TPermissions.ProceedIfPermitted(const Permission: array of TPermission;
  const Proc: TProc);
begin
  if IsPermitted( Permission ) then
    Proc
  else
    raise EPermissionNotPermitted.Create('non autorisé');
end;

end.
