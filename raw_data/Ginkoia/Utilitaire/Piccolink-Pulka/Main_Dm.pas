//------------------------------------------------------------------------------
// Nom de l'unité : Main_Dm
// Rôle           : Gestion des accés à une base de donnée Interbase
// Auteur         : Sylvain GHEROLD
// Historique     :
// 24/01/2001 - Sylvain GHEROLD - v 4.0.2 : Param. de la base en f° ligne cmde
// 18/01/2001 - Sylvain GHEROLD - v 4.0.1 : Modif CheckIntegrity pour Arbre
// 26/12/2000 - Sylvain GHEROLD - v 4.0.0 : Séparation en 3 Dm (Main,Rap,Uil)
// 15/12/2000 - Sylvain GHEROLD - v 3.1.6 : modif gestion script avec RPM
// 14/12/2000 - Sylvain GHEROLD - v 3.1.5 : modif UIL avec RPM
// 11/12/2000 - Sylvain GHEROLD - v 3.1.4 : ajout gestion paramètre RAP+CrossTab
// 21/11/2000 - Sandrine MEDEIROS - v 3.1.3 : ajout RollBackUser
// 16/11/2000 - Sylvain GHEROLD - v 3.1.2 : modif K pour utilisation triggers
// 12/10/2000 - Sylvain GHEROLD - v 3.1.1 : ajout UdpPending + chg nom fonction
// 22/09/2000 - Sylvain GHEROLD - v 3.1.0 : ajt gestion script + gestion erreur
// 10/08/2000 - Sylvain GHEROLD - v 3.0.0 : version CU + IBO
// 19/06/2000 - Sylvain GHEROLD - v 2.0.0 : version IBO
// 05/07/2000 - Sylvain GHEROLD - v 2.1.0 : intégration RAP + UIL
//------------------------------------------------------------------------------

unit Main_Dm;

interface

uses
  Classes,
  SysUtils,
  Forms,
  Db,
  FileCtrl,
  IB_Components,
  IB_SessionProps,
  IB_Dialogs,
  IB_StoredProc,
  IBDataset;
type
  TDm_Main = class( TDataModule )
    Database: TIB_Connection;
    SessionProps: TIB_SessionProps;
    IbT_Maj: TIB_Transaction;
    IbT_Select: TIB_Transaction;
    Monitor: TIB_MonitorDialog;
    IbStProc_NewKey: TIB_StoredProc;
    IbStProc_NewVerKey: TIB_StoredProc;
    IbQ_TableField: TIB_Query;
    IbQ_TablePkKey: TIB_Query;
    IbQ_FieldFkField: TIB_Query;
    IbC_InsertK: TIB_Cursor;
    IbC_UpDateK: TIB_Cursor;
    IbC_DeleteK: TIB_Cursor;
    IbC_Integritychk: TIB_Cursor;
    IbC_MajCu: TIB_Cursor;
    IbC_Script: TIB_Cursor;
    procedure DataModuleDestroy( Sender: TObject );
    procedure IbC_MajCuError( Sender: TObject; const ERRCODE: Integer;
      ErrorMessage, ErrorCodes: TStringList; const SQLCODE: Integer;
      SQLMessage, SQL: TStringList; var RaiseException: Boolean );

  private
    FVideCache: Boolean;
    FVersionSys: integer;
    FKActive: Boolean;
    FTransactionCount: Integer;
    procedure Initialize;
    procedure GetTableFields( TableName: string );

    procedure IBOCacheUpdateI( TableName: string; DataSet: TIBODataSet );
    procedure IBOCacheUpdateU( TableName: string; DataSet: TIBODataSet );
    procedure IBOCacheUpdateD( TableName: string; DataSet: TIBODataSet );

    procedure IB_CacheUpdateI( TableName: string; DataSet: TIB_BDataSet );
    procedure IB_CacheUpdateU( TableName: string; DataSet: TIB_BDataSet );
    procedure IB_CacheUpdateD( TableName: string; DataSet: TIB_BDataSet );

    procedure InsertK( K_ID, KTB_ID, KRH_ID, KSE_Owner, KSE_Insert: string );
    procedure UpdateK( K_ID, KSE_Update: string );
    procedure DeleteK( K_ID, KSE_Delete: string );

    procedure ErrorGestionnaire( Sender: TObject; E: Exception );

  public

    constructor Create( AOwner: TComponent ); override;
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
    procedure RollbackUser;

    function GenID: string;
    function GenVersion: string;

    function IBOMajPkKey( DataSet: TIBODataSet; LeChamp: string ): Boolean;
    function IBOUpdPending( DataSet: TIBODataSet ): boolean;
    procedure IBOCancelCache( DataSet: TIBOQuery );
    procedure IBOCommitCache( DataSet: TIBOQuery );
    procedure IBOUpDateCache( DataSet: TIBOQuery );

    function IB_MajPkKey( DataSet: TIB_BDataSet; LeChamp: string ): Boolean;
    function IB_UpdPending( DataSet: TIB_BDataSet ): Boolean;
    procedure IB_CancelCache( DataSet: TIB_BDataSet );
    procedure IB_CommitCache( DataSet: TIB_BDataSet );
    procedure IB_UpDateCache( DataSet: TIB_BDataSet );

    procedure IBOUpdateRecord( TableName: string; DataSet: TIBODataSet;
      UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );

    procedure IB_UpdateRecord( TableName: string; DataSet: TIB_BDataSet;
      UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction );

    procedure SetVersionSys( Version: Integer );
    procedure DesableKManagement;
    procedure SetNewGenerator( ProcName: string );
    function IsKManagementActive: Boolean;

    procedure ShowMonitor;

    procedure PrepareScript( SQL: string );
    procedure PrepareScriptMultiKUpDate( SQL: string );
    procedure PrepareScriptMultiKDelete( SQL: string );

    procedure SetScriptParameterValue( ParamName, ParamValue: string );
    procedure ExecuteScript;
    procedure ExecuteInsertK( TableName, KeyValue: string );

    function CheckAllowDelete( TableName, KeyValue: string;
      ShowErrorMessage: Boolean ): Boolean;
    function CheckAllowEdit( TableName, KeyValue: string;
      ShowErrorMessage: Boolean ): boolean;

    function TransactionUpdPending: boolean;

    function CheckOneIntegrity( LkUpTableName, LkPkFieldName, LkUpFieldName,
      KeyValue: string; ShowErrorMessage: Boolean ): Boolean;

  end;

var
  Dm_Main           : TDm_Main;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

implementation

uses
  ConstStd,
  StdUtils;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

constructor TDm_Main.Create( AOwner: TComponent );
begin
  inherited;
  Application.OnException := ErrorGestionnaire;
  Initialize;
end;

procedure TDm_Main.Initialize;
var
  PathBase, UserName, PassWord: string;
  DialectSQL        : Integer;
begin

  Database.Connected := False;
  with StdConst do begin
    if ParamCount <> 0 then begin
      // Paramétrage de la base en fonction des paramètres de commande
      PathBase := ParamStr(1);
      UserName := 'SYSDBA';
      PassWord := 'masterkey';
      DialectSQL := 3;
    end else begin
      // Paramétrage de la base en fonction du fichier INI
      PathBase := iniCtrl.readString( 'DATABASE', 'PATH', '' );
      UserName := iniCtrl.readString( 'DATABASE', 'USERNAME', '' );
      PassWord := iniCtrl.readString( 'DATABASE', 'PASSWORD', '' );
      DialectSQL := iniCtrl.ReadInteger ( 'DATABASE', 'DIALECTSQL', 3 ) ;
    end;

    if ( PathBase = '' ) or
      ( UserName = '' ) or
      ( PassWord = '' ) then begin
      ERRMess( ErrLectINI, '' );
      Application.Terminate;
    end;

    try
      // Paramétrage de la database
      Database.Database := PathBase;
      Database.Params.Values[ 'USER NAME' ] := UserName;
      Database.Params.Values[ 'PASSWORD' ] := PassWord;
      Database.SQLDialect := DialectSQL;

      // Ouverture de la database et de la transaction principale
      Database.Connected := True;

      // Désactivation du mode Système
      SetVersionSys( 0 );
      // Active le fonctionnement de K
      FKActive := True;

    except
      ERRMess( ErrConnect, '' );
      Application.Terminate;
    end;
  end;
end;

// GESTIONNAIRE D'EXCEPTIONS

procedure TDm_Main.ErrorGestionnaire( Sender: TObject; E: Exception );
begin
  ERRMess( E.message, '' );
end;

// GESTION DES TRANSACTIONS

procedure TDm_Main.StartTransaction;
begin
  if FTransactionCount = 0 then begin
    IbT_Maj.StartTransaction;
  end;
  Inc( FTransactionCount );
end;

procedure TDm_Main.Commit;
begin
  Dec( FTransactionCount );
  if FTransactionCount = 0 then try
    IbT_Maj.Commit;
  except
    Inc( FTransactionCount );
    raise Exception.Create( ErrBD );    // Erreur grave !
  end;
end;

procedure TDm_Main.Rollback;
begin
  Dec( FTransactionCount );
  if FTransactionCount = 0 then try
    IbT_Maj.Rollback;
    ERRMess( ErrMajDB, '' );
  except
    Inc( FTransactionCount );
    raise Exception.Create( ErrBD );    // Erreur grave !
  end;
end;

// idem PROCEDURE TDm_Main.Rollback mais sans le message d'erreur

procedure TDm_Main.RollbackUser;
begin
  Dec( FTransactionCount );
  if FTransactionCount = 0 then try
    IbT_Maj.Rollback;
  except
    Inc( FTransactionCount );
    raise Exception.Create( ErrBD );    // Erreur grave !
  end;
end;

// GESTION DES GENERATORS

function TDm_Main.GenID: string;
begin
  IbStProc_NewKey.ExecProc;
  result := IbStProc_NewKey.Fields[ 0 ].AsString
end;

function TDm_Main.GenVersion: string;
begin
  IbStProc_NewVerKey.ExecProc;
  result := IbStProc_NewVerKey.Fields[ 0 ].AsString
end;

function TDm_Main.IBOMajPkKey( DataSet: TIBODataSet; LeChamp: string ):
  Boolean;
// Alimentation de la cle primaire d'un DataSet
begin
  Result := True;
  try
    DataSet.FieldByName( LeChamp ).AsString := GenID;
  except
    ErrMess( ErrGenId, '' );
    DataSet.Cancel;
    Result := False;
  end;
end;

function TDm_Main.IB_MajPkKey( DataSet: TIB_BDataSet; LeChamp: string ):
  Boolean;
// Alimentation de la cle primaire d'un DataSet
begin
  Result := True;
  try
    DataSet.FieldByName( LeChamp ).AsString := GenID;
  except
    ErrMess( ErrGenId, '' );
    DataSet.Cancel;
    Result := False;
  end;
end;

// GESTION DES MISES A JOUR DU CACHE

procedure TDm_Main.IBOCancelCache( DataSet: TIBOQuery );
begin
  if DataSet.Active then
    DataSet.CancelUpdates;
end;

procedure TDm_Main.IBOCommitCache( DataSet: TIBOQuery );
begin
  if DataSet.Active and ( FTransactionCount = 0 ) then begin
    FVideCache := True;
    DataSet.ApplyUpdates;
    DataSet.CommitUpdates;
  end;
end;

procedure TDm_Main.IBOUpDateCache( DataSet: TIBOQuery );
begin
  if DataSet.Active then begin
    try
      Dm_Main.StartTransaction;
      FVideCache := False;
      DataSet.ApplyUpdates;
      Dm_Main.Commit;
    except
      Dm_Main.Rollback;
      Dm_Main.IBOCancelCache( DataSet );
      if ( FTransactionCount <> 0 ) then raise;
    end;
    Dm_Main.IBOCommitCache( DataSet );
  end;
end;

procedure TDm_Main.IB_CancelCache( DataSet: TIB_BDataSet );
begin
  if DataSet.Active then
    DataSet.CancelUpdates;
end;

procedure TDm_Main.IB_CommitCache( DataSet: TIB_BDataSet );
begin
  if DataSet.Active and ( FTransactionCount = 0 ) then begin
    FVideCache := True;
    DataSet.ApplyUpdates;
    DataSet.CommitUpdates;
  end;
end;

procedure TDm_Main.IB_UpDateCache( DataSet: TIB_BDataSet );
begin
  if DataSet.Active then begin
    try
      Dm_Main.StartTransaction;
      FVideCache := False;
      DataSet.ApplyUpdates;
      Dm_Main.Commit;
    except
      Dm_Main.Rollback;
      Dm_Main.IB_CancelCache( DataSet );
      if ( FTransactionCount <> 0 ) then raise;
    end;
    Dm_Main.IB_CommitCache( DataSet );
  end;
end;

procedure TDm_Main.IBOUpdateRecord( TableName: string; DataSet: TIBODataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction );
begin
  if FVideCache then
    UpdateAction := uaApplied
  else begin
    if UpdateKind = ukInsert then begin
      IBOCacheUpdateI( TableName, DataSet );
    end;
    if UpdateKind = ukModify then begin
      IBOCacheUpdateU( TableName, DataSet );
    end;
    if UpdateKind = ukDelete then begin
      IBOCacheUpdateD( TableName, DataSet );
    end;
  end;
end;

procedure TDm_Main.IB_UpdateRecord( TableName: string; DataSet: TIB_BDataSet;
  UpdateKind: TIB_UpdateKind; var UpdateAction: TIB_UpdateAction );
begin
  if FVideCache then
    UpdateAction := uacApplied
  else begin
    if UpdateKind = ukiInsert then begin
      IB_CacheUpdateI( TableName, DataSet );
    end;
    if UpdateKind = ukiModify then begin
      IB_CacheUpdateU( TableName, DataSet );
    end;
    if UpdateKind = ukiDelete then begin
      IB_CacheUpdateD( TableName, DataSet );
    end;
  end;
end;

procedure TDm_Main.GetTableFields( TableName: string );
begin
  if IbQ_TableField.ParamByName( 'TABLENAME' ).AsString <> TableName then
    IbQ_TableField.ParamByName( 'TABLENAME' ).AsString := TableName;
  if not IbQ_TableField.Active then IbQ_TableField.Open;

  IbQ_TableField.First;
  if IbQ_TableField.Eof then
    raise Exception.Create( ParamsStr( ErrNoFieldDef, TableName ) );

  if IbQ_TablePkKey.ParamByName( 'TABLENAME' ).AsString <> TableName then
    IbQ_TablePkKey.ParamByName( 'TABLENAME' ).AsString := TableName;
  if not IbQ_TablePkKey.Active then IbQ_TablePkKey.Open;

  IbQ_TablePkKey.First;
  if IbQ_TablePkKey.Eof then
    raise Exception.Create( ParamsStr( ErrNoPkFieldDef, TableName ) );
end;

procedure TDm_Main.IBOCacheUpdateI( TableName: string; DataSet: TIBODataSet );
begin

  GetTableFields( TableName );

  ibc_majcu.SQL.Clear;
  ibc_majcu.SQL.Add( 'INSERT INTO ' + TableName + '(' );

  if DataSet.FindField( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString )
    = nil then
    raise Exception.Create( ParamsStr( ErrNoPkFieldFound,
      IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) );

  while not IbQ_TableField.Eof do begin
    ibc_majcu.SQL.Add( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString );
    ibc_majcu.SQL.Add( ',' );
    IbQ_TableField.Next;
  end;
  ibc_majcu.SQL[ ibc_majcu.SQL.Count - 1 ] := ') VALUES (';
  IbQ_TableField.First;
  while not IbQ_TableField.Eof do begin
    ibc_majcu.SQL.Add( ':' + IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
      );
    ibc_majcu.SQL.Add( ',' );
    IbQ_TableField.Next;
  end;
  ibc_majcu.SQL[ ibc_majcu.SQL.Count - 1 ] := ')';
  ibc_majcu.Prepare;

  IbQ_TableField.First;
  while not IbQ_TableField.Eof do begin
    if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'INTEGER' then begin
      if ( DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
        ) <> nil ) and
        not VarIsNull( DataSet.FieldByName( IbQ_TableField.FieldByName(
        'KFLD_NAME' ).AsString ).NewValue ) then
        case DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString ).DataType of
          ftBoolean:
            if DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
              ).AsString ).AsBoolean then
              ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
                ).AsString ).AsInteger := 1
            else
              ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
                ).AsString ).AsInteger := 0;
          ftInteger:
            ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
              ).AsString ).AsInteger :=
              DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
              ).AsString ).NewValue;
        end
      else
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsInteger := 0;
    end;

    if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'VARCHAR' then begin
      if ( DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
        ) <> nil ) and
        not VarIsNull( DataSet.FieldByName( IbQ_TableField.FieldByName(
        'KFLD_NAME' ).AsString ).NewValue ) then
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsString :=
          DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString
          ).NewValue
      else
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsString := '';
    end;

    if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'DATE' then begin
      if ( DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
        ) <> nil ) and
        not VarIsNull( DataSet.FieldByName( IbQ_TableField.FieldByName(
        'KFLD_NAME' ).AsString ).NewValue ) then
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsDateTime :=
          DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString
          ).NewValue
      else
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsDateTime := 0;
    end;

    if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'FLOAT' then begin
      if ( DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
        ) <> nil ) and
        not VarIsNull( DataSet.FieldByName( IbQ_TableField.FieldByName(
        'KFLD_NAME' ).AsString ).NewValue ) then
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsFloat :=
          DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString
          ).NewValue
      else
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsFloat := 0;
    end;

    IbQ_TableField.Next;
  end;

  if IsKManagementActive then
    InsertK( DataSet.FieldByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME'
      ).AsString ).NewValue,
      IbQ_TablePkKey.FieldByName( 'KTB_ID' ).AsString,
      '-101', '-1', '-1' );

  ibc_majcu.Execute;

end;

procedure TDm_Main.IBOCacheUpdateU( TableName: string; DataSet: TIBODataSet );
var
  FoundModified     : Boolean;
begin
  FoundModified := False;
  GetTableFields( TableName );

  ibc_majcu.SQL.Clear;
  ibc_majcu.SQL.Add( 'UPDATE ' + TableName + ' SET ' );

  if DataSet.FindField( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) =
    nil then
    raise Exception.Create( ParamsStr( ErrNoPkFieldFound,
      IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) );

  while not IbQ_TableField.Eof do begin
    if ( DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString )
      <> nil ) and
      not VarIsNull( DataSet.FieldByName( IbQ_TableField.FieldByName(
        'KFLD_NAME'
      ).AsString ).NewValue ) and
      ( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString <>
      IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString )
      and ( DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
      ).AsString ).OldValue <>
      DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
      ).NewValue ) then begin
      ibc_majcu.SQL.Add( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString +
        ' = :' + IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
        );
      ibc_majcu.SQL.Add( ',' );
      FoundModified := True;
    end;
    IbQ_TableField.Next;
  end;
  ibc_majcu.SQL[ ibc_majcu.SQL.Count - 1 ] := ' WHERE ' +
    IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
    + ' = :' + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString;

  if FoundModified then begin

    ibc_majcu.Prepare;
    IbQ_TableField.First;
    while not IbQ_TableField.Eof do begin
      if ( DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
        ) <> nil ) and
        not VarIsNull( DataSet.FieldByName( IbQ_TableField.FieldByName(
        'KFLD_NAME' ).AsString ).NewValue ) and
        ( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString <>
        IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString )
        and ( DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
        ).AsString ).OldValue <>
        DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
        ).NewValue ) then begin

        if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'INTEGER' then
          begin
          case DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).DataType of
            ftBoolean:
              if DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
                ).AsString ).AsBoolean then
                ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
                  ).AsString ).AsInteger := 1
              else
                ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
                  ).AsString ).AsInteger := 0;
            ftInteger:
              ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
                ).AsString ).AsInteger :=
                DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
                ).AsString ).NewValue
          end
        end;

        if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'VARCHAR' then
          begin
          ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).AsString :=
            DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).NewValue;
        end;

        if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'DATE' then begin
          ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).AsDateTime :=
            DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).NewValue;
        end;

        if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'FLOAT' then
          begin
          ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).AsFloat :=
            DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).NewValue;
        end;
      end;
      IbQ_TableField.Next;
    end;

    ibc_majcu.ParamByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      ).AsString :=
      DataSet.FieldByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      ).NewValue;

    if IsKManagementActive then
      UpdateK( DataSet.FieldByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME'
        ).AsString ).NewValue,
        '-1' );

    Ibc_majcu.Execute;
  end;
end;

procedure TDm_Main.IBOCacheUpdateD( TableName: string; DataSet: TIBODataSet );
begin
  GetTableFields( TableName );

  if DataSet.FindField( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) =
    nil then
    raise Exception.Create( ParamsStr( ErrNoPkFieldFound,
      IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) );

  if not IsKManagementActive then begin
    ibc_majcu.SQL.Clear;
    ibc_majcu.SQL.Add( 'DELETE FROM ' + TableName + ' WHERE '
      + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      + ' = :' + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString );
    ibc_majcu.Prepare;
    ibc_majcu.ParamByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      ).AsString :=
      DataSet.FieldByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      ).OldValue;
    ibc_majcu.Execute;
  end;

  if IsKManagementActive then begin
    DeleteK( DataSet.FieldByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME'
      ).AsString ).Oldvalue,
      '-1' );

        // Simulation de modification pour activation des triggers
    ibc_majcu.SQL.Clear;
    ibc_majcu.SQL.Add( 'UPDATE ' + TableName + ' SET '
      + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      + ' = :' + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      + ' WHERE '
      + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      + ' = :' + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString );

    ibc_majcu.Prepare;
    ibc_majcu.ParamByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      ).AsString :=
      DataSet.FieldByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      ).OldValue;
    ibc_majcu.Execute;

  end;

end;

procedure TDm_Main.IB_CacheUpdateI( TableName: string; DataSet: TIB_BDataSet );
begin

  GetTableFields( TableName );

  ibc_majcu.SQL.Clear;
  ibc_majcu.SQL.Add( 'INSERT INTO ' + TableName + '(' );

  if DataSet.FindField( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) =
    nil then
    raise Exception.Create( ParamsStr( ErrNoPkFieldFound,
      IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) );

  while not IbQ_TableField.Eof do begin
    ibc_majcu.SQL.Add( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString );
    ibc_majcu.SQL.Add( ',' );
    IbQ_TableField.Next;
  end;
  ibc_majcu.SQL[ ibc_majcu.SQL.Count - 1 ] := ') VALUES (';
  IbQ_TableField.First;
  while not IbQ_TableField.Eof do begin
    ibc_majcu.SQL.Add( ':' + IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
      );
    ibc_majcu.SQL.Add( ',' );
    IbQ_TableField.Next;
  end;
  ibc_majcu.SQL[ ibc_majcu.SQL.Count - 1 ] := ')';
  ibc_majcu.Prepare;

  IbQ_TableField.First;
  while not IbQ_TableField.Eof do begin
    if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'INTEGER' then begin
      if DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString )
        <> nil then
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsInteger :=
          DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString
          ).AsInteger
      else
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsInteger := 0;
    end;

    if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'VARCHAR' then begin
      if DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString )
        <> nil then
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsString :=
          DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString
          ).AsString
      else
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsString := '';
    end;

    if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'DATE' then begin
      if DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString )
        <> nil then
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsDateTime :=
          DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString
          ).AsDateTime
      else
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsDateTime := 0;
    end;

    if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'FLOAT' then begin
      if DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString )
        <> nil then
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsFloat :=
          DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString
          ).AsFloat
      else
        ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
          ).AsFloat := 0;
    end;

    IbQ_TableField.Next;
  end;

  if IsKManagementActive then
    InsertK( DataSet.FieldByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME'
      ).AsString ).AsString,
      IbQ_TablePkKey.FieldByName( 'KTB_ID' ).AsString,
      '-101', '-1', '-1' );

  Ibc_majcu.Execute;

end;

procedure TDm_Main.IB_CacheUpdateU( TableName: string; DataSet: TIB_BDataSet );
var
  FoundModified     : Boolean;
begin
  FoundModified := False;
  GetTableFields( TableName );

  ibc_majcu.SQL.Clear;
  ibc_majcu.SQL.Add( 'UPDATE ' + TableName + ' SET ' );

  if DataSet.FindField( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) =
    nil then
    raise Exception.Create( ParamsStr( ErrNoPkFieldFound,
      IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) );

  while not IbQ_TableField.Eof do begin
    if ( DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString )
      <> nil ) and
      ( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString <>
      IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) and
      ( DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
      ).AsString <>
      DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
      ).OldAsString ) then begin
      ibc_majcu.SQL.Add( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString +
        ' = :' + IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
        );
      ibc_majcu.SQL.Add( ',' );
      FoundModified := True;
    end;
    IbQ_TableField.Next;
  end;
  ibc_majcu.SQL[ ibc_majcu.SQL.Count - 1 ] := ' WHERE ' +
    IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
    + ' = :' + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString;

  if FoundModified then begin

    ibc_majcu.Prepare;
    IbQ_TableField.First;
    while not IbQ_TableField.Eof do begin
      if ( DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
        ) <> nil ) and
        ( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString <>
        IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) and
        ( DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
          ).AsString
        ).AsString <>
        DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
        ).OldAsString ) then begin

        if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'INTEGER' then
          begin
          ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).AsInteger :=
            DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).AsInteger
        end;

        if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'VARCHAR' then
          begin
          ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).AsString :=
            DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).AsString;
        end;

        if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'DATE' then begin
          ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).AsDateTime :=
            DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).AsDateTime;
        end;

        if IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'FLOAT' then
          begin
          ibc_majcu.ParamByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).AsFloat :=
            DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
            ).AsString ).AsFloat;
        end;
      end;
      IbQ_TableField.Next;
    end;

    ibc_majcu.ParamByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      ).AsString :=
      DataSet.FieldByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      ).AsString;

    if IsKManagementActive then
      UpdateK( DataSet.FieldByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME'
        ).AsString ).AsString,
        '-1' );

    Ibc_majcu.Execute;

  end;
end;

procedure TDm_Main.IB_CacheUpdateD( TableName: string; DataSet: TIB_BDataSet );
begin
  GetTableFields( TableName );
  if IbQ_TablePkKey.Eof then
    raise Exception.Create( ParamsStr( ErrNoPkFieldDef, TableName ) );

  if DataSet.FindField( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) =
    nil then
    raise Exception.Create( ParamsStr( ErrNoPkFieldFound,
      IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) );

  if not IsKManagementActive then begin
    ibc_majcu.SQL.Clear;
    ibc_majcu.SQL.Add( 'DELETE FROM ' + TableName + ' WHERE '
      + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      + ' = :' + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString );
    ibc_majcu.Prepare;
    ibc_majcu.ParamByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      ).AsString :=
      DataSet.FieldByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      ).OldAsString;
    ibc_majcu.Execute;
  end;

  if IsKManagementActive then begin
    DeleteK( DataSet.FieldByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME'
      ).AsString ).OldAsString,
      '-1' );

        // Simulation de modification pour activation des triggers
    ibc_majcu.SQL.Clear;
    ibc_majcu.SQL.Add( 'UPDATE ' + TableName + ' SET '
      + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      + ' = :' + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      + ' WHERE '
      + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      + ' = :' + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString );

    ibc_majcu.Prepare;
    ibc_majcu.ParamByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      ).AsString :=
      DataSet.FieldByName( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString
      ).OldAsString;
    ibc_majcu.Execute;

  end;
end;

// GESTION DE LA TABLE K

procedure TDm_Main.InsertK( K_ID, KTB_ID, KRH_ID, KSE_Owner, KSE_Insert: string
  );
var
  S1, S2            : string;
begin
  S1 := DateTimeToStr( Now );
  S2 := DateTimeToStr( 0 );
  if not IbC_InsertK.Prepared then
    IbC_InsertK.Prepare;
  IbC_InsertK.ParamByName( 'K_ID' ).AsString := K_ID;
  if FVersionSys = 0 then
    IbC_InsertK.ParamByName( 'K_VERSION' ).AsString := GenVersion
  else
    IbC_InsertK.ParamByName( 'K_VERSION' ).AsInteger := FVersionSys;

  IbC_InsertK.ParamByName( 'KRH_ID' ).AsString := KRH_ID;
  IbC_InsertK.ParamByName( 'KTB_ID' ).AsString := KTB_ID;
  IbC_InsertK.ParamByName( 'KSE_OWNER_ID' ).AsString := KSE_Owner;
  IbC_InsertK.ParamByName( 'KSE_INSERT_ID' ).AsString := KSE_Insert;
  IbC_InsertK.ParamByName( 'KSE_UPDATE_ID' ).AsString := '0';
  IbC_InsertK.ParamByName( 'KSE_DELETE_ID' ).AsString := '0';
  IbC_InsertK.ParamByName( 'K_INSERTED' ).AsString := S1;
  IbC_InsertK.ParamByName( 'K_UPDATED' ).AsString := S1;
  IbC_InsertK.ParamByName( 'K_DELETED' ).AsString := S2;
  IbC_InsertK.ParamByName( 'KSE_LOCK_ID' ).AsString := '0';
  IbC_InsertK.ParamByName( 'KMA_LOCK_ID' ).AsString := '0';
  IbC_InsertK.Execute;
end;

procedure TDm_Main.UpdateK( K_ID, KSE_Update: string );
var
  S                 : string;
begin
  S := DateTimeToStr( Now );
  if not IbC_UpDateK.Prepared then
    IbC_UpDateK.Prepare;
  IbC_UpDateK.ParamByName( 'K_ID' ).AsString := K_ID;
  if FVersionSys = 0 then
    IbC_UpDateK.ParamByName( 'K_VERSION' ).AsString := GenVersion
  else
    IbC_UpDateK.ParamByName( 'K_VERSION' ).AsString := IntToStr( FVersionSys );

  IbC_UpDateK.ParamByName( 'KSE_UPDATE_ID' ).AsString := KSE_Update;
  IbC_UpDateK.ParamByName( 'K_UPDATED' ).AsString := S;
  IbC_UpDateK.Execute;
end;

procedure TDm_Main.DeleteK( K_ID, KSE_Delete: string );
var
  S                 : string;
begin
  S := DateTimeToStr( Now );
  if not IbC_DeleteK.Prepared then
    IbC_DeleteK.Prepare;
  IbC_DeleteK.ParamByName( 'K_ID' ).AsString := K_ID;
  if FVersionSys = 0 then
    IbC_DeleteK.ParamByName( 'K_VERSION' ).AsString := GenVersion
  else
    IbC_DeleteK.ParamByName( 'K_VERSION' ).AsInteger := FVersionSys;

  IbC_DeleteK.ParamByName( 'KSE_DELETE_ID' ).AsString := KSE_Delete;
  IbC_DeleteK.ParamByName( 'K_DELETED' ).AsString := S;
  IbC_DeleteK.Execute;
end;

procedure TDm_Main.SetVersionSys( Version: Integer );
begin
  FVersionSys := Version;
end;

procedure TDm_Main.DesableKManagement;
begin
  FKActive := False;
end;

function TDm_Main.IsKManagementActive: Boolean;
begin
  Result := FKActive;
end;

procedure TDm_Main.SetNewGenerator( ProcName: string );
begin
  IbStProc_NewKey.StoredProcName := ProcName;
end;

// GESTION DU MONITEUR SQL

procedure TDm_Main.ShowMonitor;
begin
  Monitor.Show;
end;

// GESTION DE SCRIPT SQL

PROCEDURE TDm_Main.PrepareScript ( SQL: STRING ) ;
BEGIN
    IbC_Script.Close;
    IbC_Script.SQL.Clear;
    IbC_Script.SQL.Add ( SQL ) ;
    IbC_Script.Prepare;
END;

PROCEDURE TDm_Main.PrepareScriptMultiKUpDate ( SQL: STRING ) ;
BEGIN
    IbC_Script.Close;
    IbC_Script.SQL.Clear;
    IbC_Script.SQL.Add (
             'UPDATE K SET '+
             'K_VERSION = (SELECT NEWKEY from PROC_NEWVERKEY),'+
             'KSE_UPDATE_ID = -1,'+
             'K_UPDATED = :K_UPDATED WHERE K.K_ID IN ('+
             SQL +' )');
    IbC_Script.Prepare;
    IbC_Script.ParamByName ( 'K_UPDATED' ) .AsString := DateTimeToStr ( Now );
END;

PROCEDURE TDm_Main.PrepareScriptMultiKDelete ( SQL: STRING ) ;
BEGIN
    IbC_Script.Close;
    IbC_Script.SQL.Clear;
    IbC_Script.SQL.Add (
             'UPDATE K SET '+
             'K_VERSION = (SELECT NEWKEY from PROC_NEWVERKEY),'+
             'K_ENABLED = 0,'+
             'KSE_UPDATE_ID = -1,'+
             'K_DELETED = :K_DELETED WHERE K.K_ID IN ('+
             SQL +' )');
    IbC_Script.Prepare;
    IbC_Script.ParamByName ( 'K_DELETED' ) .AsString := DateTimeToStr ( Now );

END;

PROCEDURE TDm_Main.SetScriptParameterValue ( ParamName, ParamValue: STRING ) ;
BEGIN
    IbC_Script.ParamByName ( ParamName ) .AsString := ParamValue;
END;

PROCEDURE TDm_Main.ExecuteScript;
BEGIN
    TRY
        Dm_Main.StartTransaction;
        IbC_Script.Execute;
        Dm_Main.Commit;
    EXCEPT
        Dm_Main.Rollback;
        IF ( FTransactionCount <> 0 ) THEN RAISE;
    END;
END;

procedure TDm_Main.ExecuteInsertK( TableName, KeyValue: string );
var
  SQLTYPE           : string;
begin
  try
    Dm_Main.StartTransaction;

        // Mise à jour de la Table K
    GetTableFields( TableName );

    SQLTYPE := FirstMot( IbC_Script.SQL[ 0 ] );
    if ( SQLTYPE <> 'INSERT' ) or ( StrToInt( KeyValue ) <= 0 ) then
      raise Exception.Create( ErrUsingScript );

    InsertK( KeyValue, IbQ_TablePkKey.FieldByName( 'KTB_ID' ).AsString,
      '-101', '-1', '-1' );

        // Lancement de la commande SQL
    IbC_Script.Execute;

    Dm_Main.Commit;
  except
    Dm_Main.Rollback;
    if ( FTransactionCount <> 0 ) then raise;
  end;
end;

// VERIFICATION DE L'INTEGRITE DE LA BASE

function TDm_Main.CheckOneIntegrity( LkUpTableName, LkPkFieldName,
  LkUpFieldName, KeyValue: string; ShowErrorMessage: Boolean ): Boolean;
begin
  Ibc_IntegrityChk.Close;
  Ibc_IntegrityChk.SQL.Clear;
  if IsKManagementActive then
    Ibc_IntegrityChk.SQL.Add( 'SELECT * FROM '
      + LkUpTableName
      + ',K WHERE '
      + LkUpFieldName
      + '=' + KeyValue
      + ' AND ' + LkPkFieldName  // Ajout pour traiter le cas des arbres stockés
      + '<>' +  KeyValue         // dans une même table
      + ' AND K_ID = '
      + LkPkFieldName
      + ' AND K_ENABLED=1' )
  else
    Ibc_IntegrityChk.SQL.Add( 'SELECT * FROM '
      + LkUpTableName
      + ' WHERE '
      + LkUpFieldName
      + '=' + KeyValue
      + ' AND ' + LkPkFieldName  // Ajout pour traiter le cas des arbres stockés
      + '<>' +  KeyValue         // dans une même table
      );
  Ibc_IntegrityChk.Open;
  Result := Ibc_IntegrityChk.Eof;

  if not Result and ShowErrorMessage then begin
    ERRMESS( ErrNoDeleteIntChk, '' );
  end;

end;

function TDm_Main.CheckAllowEdit( TableName, KeyValue: string;
  ShowErrorMessage:
  Boolean ): boolean;
begin
  Result := True;
  if ( KeyValue <> '' ) and ( StrToInt( KeyValue ) <= 0 ) then begin
    if ShowErrorMessage then ERRMESS( ErrNoEditNullRec, '' );
    Result := False;
  end;
end;

function TDm_Main.TransactionUpdPending: boolean;
begin
  Result := IbT_Select.TransactionIsActive;
end;

function TDm_Main.IBOUpdPending( DataSet: TIBODataSet ): boolean;
begin
  Result := DataSet.Modified or DataSet.UpdatesPending;
end;

function TDm_Main.IB_UpdPending( DataSet: TIB_BDataSet ): boolean;
begin
  Result := DataSet.Modified or DataSet.UpdatesPending;
end;

function TDm_Main.CheckAllowDelete( TableName, KeyValue: string;
  ShowErrorMessage: Boolean ): boolean;
begin
  Result := True;

  if KeyValue = '0' then begin
    if ShowErrorMessage then ERRMESS( ErrNoDeleteNullRec, '' );
    Result := False;
  end
  else begin

    GetTableFields( TableName );
    if IbQ_TablePkKey.Eof then
      raise Exception.Create( ParamsStr( ErrNoPkFieldDef, TableName ) );

    if IbQ_FieldFkField.ParamByName( 'KFLD_FK' ).AsString <>
      IbQ_TablePkKey.FieldByName( 'KFLD_ID' ).AsString then
      IbQ_FieldFkField.ParamByName( 'KFLD_FK' ).AsString :=
        IbQ_TablePkKey.FieldByName( 'KFLD_ID' ).AsString;

    if not IbQ_FieldFkField.Active then IbQ_FieldFkField.Open;
    IbQ_FieldFkField.First;

    while not IbQ_FieldFkField.Eof do begin
      Result := Result and
        CheckOneIntegrity( IbQ_FieldFkField.FieldByName( 'KTB_NAME' ).AsString,
        IbQ_FieldFkField.FieldByName( 'PKFIELD' ).AsString,
        IbQ_FieldFkField.FieldByName( 'KFLD_NAME' ).AsString,
        KeyValue, False );
      IbQ_FieldFkField.Next;
    end;

    if not Result and ShowErrorMessage then begin
      ERRMESS( ErrNoDeleteIntChk, '' );
    end;
  end;
end;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

procedure TDm_Main.DataModuleDestroy( Sender: TObject );
begin
  Database.Connected := False;
end;

procedure TDm_Main.ibc_majcuError( Sender: TObject; const ERRCODE: Integer;
  ErrorMessage, ErrorCodes: TStringList; const SQLCODE: Integer;
  SQLMessage, SQL: TStringList; var RaiseException: Boolean );
begin
  RaiseException := False;
  case SQLCODE of
    -625: raise Exception.Create( errSQL625 );
    -803: raise Exception.Create( errSQL803 );
  else
    raise Exception.Create( ParamsStr( errSQL, SQLCODE ) );
  end;
end;

end.

