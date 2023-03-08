//------------------------------------------------------------------------------
// Nom de l'unité : Uil_Dm
// Rôle           : Utilisation de Security System de Unlimited Intelligence Limited
// Auteur         : Sylvain GHEROLD
// Historique     :
// 27/12/2000 - Sylvain GHEROLD - v 1.0.0 : Création
//------------------------------------------------------------------------------

unit Uil_Dm;

interface

uses
  SysUtils,
  Classes,
  Forms,
  Db,
  IBDataset,
  uSecControl,
  uSecDlg,
  uLoginDlg,
  wwDialog,
  wwidlg,
  wwLookupDialogRv;
type
  TDm_Uil = class( TDataModule )
    Que_User: TIBOQuery;
    Que_UserAccess: TIBOQuery;
    Que_Group: TIBOQuery;
    Que_GroupAccess: TIBOQuery;
    Que_Permission: TIBOQuery;
    Que_GroupMemberShip: TIBOQuery;

    DS_User: TDataSource;
    DS_UserAccess: TDataSource;
    DS_Group: TDataSource;
    DS_GroupAccess: TDataSource;
    DS_Permission: TDataSource;
    DS_GroupMemberShip: TDataSource;

    SecurityManager: TuilSecurityManager;
    LoginDlg: TuilLoginDlg;
    SecurityDlg: TuilSecurityDlg;
    DbLkDlg_Permission: TwwLookupDialogRv;

    procedure SecurityManagerFailedLogin( Sender: TObject );
    procedure Que_UserUpdateRecord( DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );
    procedure Que_UserAfterPost( DataSet: TDataSet );
    procedure Que_UserAccessUpdateRecord( DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );
    procedure Que_PermissionUpdateRecord( DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );
    procedure Que_GroupUpdateRecord( DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );
    procedure Que_GroupAccessUpdateRecord( DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );
    procedure Que_GroupMemberShipUpdateRecord( DataSet: TDataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );
    procedure Que_UserAccessAfterPost( DataSet: TDataSet );
    procedure Que_PermissionAfterPost( DataSet: TDataSet );
    procedure Que_GroupAfterPost( DataSet: TDataSet );
    procedure Que_GroupAccessAfterPost( DataSet: TDataSet );
    procedure Que_GroupMemberShipAfterPost( DataSet: TDataSet );
    procedure Que_UserNewRecord( DataSet: TDataSet );
    procedure Que_UserAccessNewRecord( DataSet: TDataSet );
    procedure Que_PermissionNewRecord( DataSet: TDataSet );
    procedure Que_GroupNewRecord( DataSet: TDataSet );
    procedure Que_GroupAccessNewRecord( DataSet: TDataSet );
    procedure Que_GroupMemberShipNewRecord( DataSet: TDataSet );

  private
    FOveredUserName, FOveredUserPassword: string;
    procedure OpenQuery;
    function GetPassword( UserName: string ): string;

  public
    function Initialize: Boolean;
    function Login: boolean;
    procedure Logout;
    function CurrentUser: string;
    procedure NewPassword( NewPassWord: string );
    procedure UserRights;
    procedure UserGroups;
    function OverLogin: boolean;
    function BackLogin: boolean;
    function HasPermission( PermissionName: string ): boolean;
    procedure RefreshData;
    procedure ShowPermission;
  end;

var
  Dm_Uil            : TDm_Uil;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

implementation

uses
  ConstStd,
  Main_Dm;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

function TDm_Uil.Initialize: Boolean;
begin
  if ( Dm_Uil = nil ) then begin
    try
      Dm_Uil := TDm_Uil.Create( Application );
      if not Dm_Main.IsKManagementActive then
        with Dm_Uil do begin
          Que_User.Close;
          Que_User.SQL.CommaText := 'SELECT * FROM UILUSERS';
          Que_User.JoinLinks.Clear;

          Que_UserAccess.Close;
          Que_UserAccess.SQL.CommaText := 'SELECT * FROM UILUSERACCESS WHERE' +
            ' USA_USERNAME=:USR_USERNAME';
          Que_UserAccess.JoinLinks.Clear;

          Que_Permission.Close;
          Que_Permission.SQL.CommaText := 'SELECT * FROM UILPERMISSIONS';
          Que_Permission.JoinLinks.Clear;

          Que_Group.Close;
          Que_Group.SQL.CommaText := 'SELECT * FROM UILGROUPS';
          Que_Group.JoinLinks.Clear;

          Que_GroupAccess.Close;
          Que_GroupAccess.SQL.CommaText :=
            'SELECT * FROM UILGROUPACCESS WHERE GRA_GROUPNAME=:GRP_GROUPNAME';
          Que_GroupAccess.JoinLinks.Clear;

          Que_GroupMemberShip.Close;
          Que_GroupMemberShip.SQL.CommaText :=
            'SELECT * FROM UILGROUPMEMBERSHIP';
          Que_GroupMemberShip.JoinLinks.Clear;
        end;
      OpenQuery;
      Result := True;
    except
      Result := False;
      ERRMess( ErrInitUil, '' );
    end;
  end
  else
    Result := True;
end;

procedure TDm_Uil.OpenQuery;
begin
  if Dm_Uil <> nil then
    with Dm_Uil do begin
      if not Que_UserAccess.Active then Que_UserAccess.Open;
      if not Que_User.Active then Que_User.Open;
      if not Que_Group.Active then Que_Group.Open;
      if not Que_Permission.Active then Que_Permission.Open;
      if not Que_GroupAccess.Active then Que_GroupAccess.Open;
      if not Que_GroupMemberShip.Active then Que_GroupMemberShip.Open;
    end;
end;

procedure TDm_Uil.RefreshData;
begin
  if Dm_Uil <> nil then
    with Dm_Uil do begin
      if Que_UserAccess.Active then Que_UserAccess.Refresh;
      if Que_User.Active then Que_User.Refresh;
      if Que_Group.Active then Que_Group.Refresh;
      if Que_Permission.Active then Que_Permission.Refresh;
      if Que_GroupAccess.Active then Que_GroupAccess.Refresh;
      if Que_GroupMemberShip.Active then Que_GroupMemberShip.Refresh;
    end;
end;

function TDm_Uil.Login: boolean;
begin
  if not Initialize then Abort;
  with Dm_Uil do
    result := LoginDlg.Execute;
end;

procedure TDm_Uil.Logout;
begin
  if Dm_Uil <> nil then
    with Dm_Uil do
      SecurityManager.Logout;
end;

function TDm_Uil.CurrentUser: string;
begin
  if Dm_Uil <> nil then
    with Dm_Uil do
      result := SecurityManager.CurrentUser;
end;

procedure TDm_Uil.NewPassword( NewPassWord: string );
begin
  if Dm_Uil <> nil then
    Dm_Uil.SecurityManager.UserBindary.ChangePassword( NewPassword );
end;

procedure TDm_Uil.UserRights;
begin
  if not Initialize then Abort;
  with Dm_Uil do begin
    SecurityDlg.ShowGroups := False;
    Que_Permission.Filtered := True;
    SecurityDlg.Execute;
    Que_Permission.Filtered := False;
  end;
end;

procedure TDm_Uil.UserGroups;
begin
  if not Initialize then Abort;
  with Dm_Uil do begin
    SecurityDlg.ShowGroups := True;
    Que_Permission.Filtered := False;
    SecurityDlg.Execute;
  end;
end;

function TDm_Uil.OverLogin: boolean;
begin
  Result := False;
  if Dm_Uil <> nil then
    with Dm_Uil do begin
      if ( FOveredUserName <> '' ) or ( FOveredUserPassword <> '' ) then begin
        ERRMess( ErrOverLoginActive, '' );
        exit;
      end;
      FOveredUserName := SecurityManager.CurrentUser;
      FOveredUserPassword := GetPassword( FOveredUserName );
      if Login then
        Result := True
      else begin
        FOveredUserName := '';
        FOveredUserPassword := '';
      end;
    end;
end;

function TDm_Uil.GetPassword( UserName: string ): string;
begin
  Result := '';
  if Dm_Uil <> nil then
    with Dm_Uil do begin
      if Que_User.Locate( 'USR_USERNAME', UserName, [ ] ) then
        Result := Que_User.FieldByName( 'USR_PASSWORD' ).AsString;
    end;
end;

function TDm_Uil.BackLogin: boolean;
begin
  Result := False;
  if Dm_Uil <> nil then
    with Dm_Uil do begin
      if ( FOveredUserName = '' ) or ( FOveredUserPassword = '' ) then begin
        ERRMess( ErrOverLoginNotActive, '' );
        exit;
      end;
      if SecurityManager.Login( FOveredUserName, FOveredUserPassword ) then
        begin
        FOveredUserName := '';
        FOveredUserPassword := '';
        Result := True;
      end;
    end;
end;

function TDm_Uil.HasPermission( PermissionName: string ): boolean;
begin
  Result := False;
  if Dm_Uil <> nil then
    with Dm_Uil do begin
      if PermissionName <> '' then
        Result := SecurityManager.HasPermission( PermissionName );
    end;
end;

procedure TDm_Uil.ShowPermission;
begin
  if Dm_Uil <> nil then
    with Dm_Uil do begin
      if DbLkDlg_Permission.Execute then begin
        if Dm_Main.IBOUpdPending( Que_Permission ) then Que_Permission.Post;
      end
      else if Dm_Main.IBOUpdPending( Que_Permission ) then
        Que_Permission.Cancel;
    end;
end;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

procedure TDm_Uil.SecurityManagerFailedLogin( Sender: TObject );
begin
  ERRMess( ErrLogin, '' );
end;

procedure TDm_Uil.Que_UserUpdateRecord( DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );
begin
  Dm_Main.IBOUpdateRecord( 'UILUSERS', Que_User, UpdateKind, UpdateAction );
end;

procedure TDm_Uil.Que_UserAccessUpdateRecord( DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );
begin
  Dm_Main.IBOUpdateRecord( 'UILUSERACCESS', Que_UserAccess, UpdateKind,
    UpdateAction );
end;

procedure TDm_Uil.Que_PermissionUpdateRecord( DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );
begin
  Dm_Main.IBOUpdateRecord( 'UILPERMISSIONS', Que_Permission, UpdateKind,
    UpdateAction );
end;

procedure TDm_Uil.Que_GroupUpdateRecord( DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );
begin
  Dm_Main.IBOUpdateRecord( 'UILGROUPS', Que_Group, UpdateKind, UpdateAction );
end;

procedure TDm_Uil.Que_GroupAccessUpdateRecord( DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );
begin
  Dm_Main.IBOUpdateRecord( 'UILGROUPACCESS', Que_GroupAccess, UpdateKind,
    UpdateAction );
end;

procedure TDm_Uil.Que_GroupMemberShipUpdateRecord( DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );
begin
  Dm_Main.IBOUpdateRecord( 'UILGROUPMEMBERSHIP', Que_GroupMemberShip,
    UpdateKind, UpdateAction );
end;

procedure TDm_Uil.Que_UserAfterPost( DataSet: TDataSet );
begin
  Dm_Main.IBOUpDateCache( Que_User );
end;

procedure TDm_Uil.Que_UserAccessAfterPost( DataSet: TDataSet );
begin
  Dm_Main.IBOUpDateCache( Que_UserAccess );
end;

procedure TDm_Uil.Que_PermissionAfterPost( DataSet: TDataSet );
begin
  Dm_Main.IBOUpDateCache( Que_Permission );
end;

procedure TDm_Uil.Que_GroupAfterPost( DataSet: TDataSet );
begin
  Dm_Main.IBOUpDateCache( Que_Group );
end;

procedure TDm_Uil.Que_GroupAccessAfterPost( DataSet: TDataSet );
begin
  Dm_Main.IBOUpDateCache( Que_GroupAccess );
end;

procedure TDm_Uil.Que_GroupMemberShipAfterPost( DataSet: TDataSet );
begin
  Dm_Main.IBOUpDateCache( Que_GroupMemberShip );
end;

procedure TDm_Uil.Que_UserNewRecord( DataSet: TDataSet );
begin
  if not Dm_Main.IBOMajPkKey( Que_User, 'USR_ID' ) then abort;
end;

procedure TDm_Uil.Que_UserAccessNewRecord( DataSet: TDataSet );
begin
  if not Dm_Main.IBOMajPkKey( Que_UserAccess, 'USA_ID' ) then abort;
end;

procedure TDm_Uil.Que_PermissionNewRecord( DataSet: TDataSet );
begin
  if not Dm_Main.IBOMajPkKey( Que_Permission, 'PER_ID' ) then abort;
end;

procedure TDm_Uil.Que_GroupNewRecord( DataSet: TDataSet );
begin
  if not Dm_Main.IBOMajPkKey( Que_Group, 'GRP_ID' ) then abort;
end;

procedure TDm_Uil.Que_GroupAccessNewRecord( DataSet: TDataSet );
begin
  if not Dm_Main.IBOMajPkKey( Que_GroupAccess, 'GRA_ID' ) then abort;
end;

procedure TDm_Uil.Que_GroupMemberShipNewRecord( DataSet: TDataSet );
begin
  if not Dm_Main.IBOMajPkKey( Que_GroupMemberShip, 'GRM_ID' ) then abort;
end;

end.

