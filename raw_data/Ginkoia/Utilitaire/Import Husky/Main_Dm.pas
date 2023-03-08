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

UNIT Main_Dm;

INTERFACE

USES
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
TYPE
    TDm_Main = CLASS ( TDataModule )
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
        PROCEDURE DataModuleDestroy ( Sender: TObject ) ;
        PROCEDURE IbC_MajCuError ( Sender: TObject; CONST ERRCODE: Integer;
            ErrorMessage, ErrorCodes: TStringList; CONST SQLCODE: Integer;
            SQLMessage, SQL: TStringList; VAR RaiseException: Boolean ) ;

    Private
        FVideCache: Boolean;
        FVersionSys: integer;
        FKActive: Boolean;
        FTransactionCount: Integer;
        PROCEDURE Initialize;
        PROCEDURE GetTableFields ( TableName: STRING ) ;

        PROCEDURE IBOCacheUpdateI ( TableName: STRING; DataSet: TIBODataSet ) ;
        PROCEDURE IBOCacheUpdateU ( TableName: STRING; DataSet: TIBODataSet ) ;
        PROCEDURE IBOCacheUpdateD ( TableName: STRING; DataSet: TIBODataSet ) ;

        PROCEDURE IB_CacheUpdateI ( TableName: STRING; DataSet: TIB_BDataSet ) ;
        PROCEDURE IB_CacheUpdateU ( TableName: STRING; DataSet: TIB_BDataSet ) ;
        PROCEDURE IB_CacheUpdateD ( TableName: STRING; DataSet: TIB_BDataSet ) ;

        PROCEDURE UpdateK ( K_ID, KSE_Update: STRING ) ;
        PROCEDURE DeleteK ( K_ID, KSE_Delete: STRING ) ;

        PROCEDURE ErrorGestionnaire ( Sender: TObject; E: Exception ) ;

    Public

        CONSTRUCTOR Create ( AOwner: TComponent ) ; Override;
        PROCEDURE InsertK ( K_ID, KTB_ID, KRH_ID, KSE_Owner, KSE_Insert: STRING ) ;
        PROCEDURE StartTransaction;
        PROCEDURE Commit;
        PROCEDURE Rollback;
        PROCEDURE RollbackUser;

        FUNCTION GenID: STRING;
        FUNCTION GenVersion: STRING;

        FUNCTION IBOMajPkKey ( DataSet: TIBODataSet; LeChamp: STRING ) : Boolean;
        FUNCTION IBOUpdPending ( DataSet: TIBODataSet ) : boolean;
        PROCEDURE IBOCancelCache ( DataSet: TIBOQuery ) ;
        PROCEDURE IBOCommitCache ( DataSet: TIBOQuery ) ;
        PROCEDURE IBOUpDateCache ( DataSet: TIBOQuery ) ;

        FUNCTION IB_MajPkKey ( DataSet: TIB_BDataSet; LeChamp: STRING ) : Boolean;
        FUNCTION IB_UpdPending ( DataSet: TIB_BDataSet ) : Boolean;
        PROCEDURE IB_CancelCache ( DataSet: TIB_BDataSet ) ;
        PROCEDURE IB_CommitCache ( DataSet: TIB_BDataSet ) ;
        PROCEDURE IB_UpDateCache ( DataSet: TIB_BDataSet ) ;

        PROCEDURE IBOUpdateRecord ( TableName: STRING; DataSet: TIBODataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;

        PROCEDURE IB_UpdateRecord ( TableName: STRING; DataSet: TIB_BDataSet;
            UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction ) ;

        PROCEDURE SetVersionSys ( Version: Integer ) ;
        PROCEDURE DesableKManagement;
        PROCEDURE SetNewGenerator ( ProcName: STRING ) ;
        FUNCTION IsKManagementActive: Boolean;

        PROCEDURE ShowMonitor;

        PROCEDURE PrepareScript ( SQL: STRING ) ;
        PROCEDURE PrepareScriptMultiKUpDate ( SQL: STRING ) ;
        PROCEDURE PrepareScriptMultiKDelete ( SQL: STRING ) ;

        PROCEDURE SetScriptParameterValue ( ParamName, ParamValue: STRING ) ;
        PROCEDURE ExecuteScript;
        PROCEDURE ExecuteInsertK ( TableName, KeyValue: STRING ) ;

        FUNCTION CheckAllowDelete ( TableName, KeyValue: STRING;
            ShowErrorMessage: Boolean ) : Boolean;
        FUNCTION CheckAllowEdit ( TableName, KeyValue: STRING;
            ShowErrorMessage: Boolean ) : boolean;

        FUNCTION TransactionUpdPending: boolean;

        FUNCTION CheckOneIntegrity ( LkUpTableName, LkPkFieldName, LkUpFieldName,
            KeyValue: STRING; ShowErrorMessage: Boolean ) : Boolean;

    END;

VAR
    Dm_Main: TDm_Main;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

IMPLEMENTATION

USES
    ginkoiastd,
    StdUtils,
    ginkoiaresstr;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

CONSTRUCTOR TDm_Main.Create ( AOwner: TComponent ) ;
BEGIN
    INHERITED;
    Application.OnException := ErrorGestionnaire;
    Initialize;
END;

PROCEDURE TDm_Main.Initialize;
VAR
    PathBase, UserName, PassWord: STRING;
    DialectSQL: Integer;
BEGIN

    Database.Connected := False;
 // ::  WITH StdConst DO
 //   BEGIN
        BEGIN
      // Paramétrage de la base en fonction du fichier INI
            PathBase := stdginkoia.iniCtrl.readString ( 'DATABASE', 'PATH', '' ) ;
            UserName := stdginkoia.iniCtrl.readString ( 'DATABASE', 'USERNAME', '' ) ;
            PassWord := stdginkoia.iniCtrl.readString ( 'DATABASE', 'PASSWORD', '' ) ;
            DialectSQL := stdginkoia.iniCtrl.ReadInteger ( 'DATABASE', 'DIALECTSQL', 3 ) ;
        END;

        IF ( PathBase = '' ) OR
            ( UserName = '' ) OR
            ( PassWord = '' ) THEN
            BEGIN
            ERRMess ( ErrLectINI, '' ) ;
            Application.Terminate;
        END;

        TRY
      // Paramétrage de la database
            Database.Database := PathBase;
            Database.Params.Values['USER NAME'] := UserName;
            Database.Params.Values['PASSWORD'] := PassWord;
            Database.SQLDialect := DialectSQL;

      // Ouverture de la database et de la transaction principale
            Database.Connected := True;

      // Désactivation du mode Système
            SetVersionSys ( 0 ) ;
      // Active le fonctionnement de K
            FKActive := True;

        EXCEPT
            ERRMess ( ErrConnect, '' ) ;
            Application.Terminate;
        END;
  //  END;
END;

// GESTIONNAIRE D'EXCEPTIONS

PROCEDURE TDm_Main.ErrorGestionnaire ( Sender: TObject; E: Exception ) ;
BEGIN
    ERRMess ( E.message, '' ) ;
END;

// GESTION DES TRANSACTIONS

PROCEDURE TDm_Main.StartTransaction;
BEGIN
    IF FTransactionCount = 0 THEN
    BEGIN
        IbT_Maj.StartTransaction;
    END;
    Inc ( FTransactionCount ) ;
END;

PROCEDURE TDm_Main.Commit;
BEGIN
    Dec ( FTransactionCount ) ;
    IF FTransactionCount = 0 THEN
    TRY
        IbT_Maj.Commit;
    EXCEPT
        Inc ( FTransactionCount ) ;
        RAISE Exception.Create ( ErrBD ) ; // Erreur grave !
    END;
END;

PROCEDURE TDm_Main.Rollback;
BEGIN
    Dec ( FTransactionCount ) ;
    IF FTransactionCount = 0 THEN
    TRY
        IbT_Maj.Rollback;
        ERRMess ( ErrMajDB, '' ) ;
    EXCEPT
        Inc ( FTransactionCount ) ;
        RAISE Exception.Create ( ErrBD ) ; // Erreur grave !
    END;
END;

// idem PROCEDURE TDm_Main.Rollback mais sans le message d'erreur

PROCEDURE TDm_Main.RollbackUser;
BEGIN
    Dec ( FTransactionCount ) ;
    IF FTransactionCount = 0 THEN
    TRY
        IbT_Maj.Rollback;
    EXCEPT
        Inc ( FTransactionCount ) ;
        RAISE Exception.Create ( ErrBD ) ; // Erreur grave !
    END;
END;

// GESTION DES GENERATORS

FUNCTION TDm_Main.GenID: STRING;
BEGIN
    IbStProc_NewKey.ExecProc;
    result := IbStProc_NewKey.Fields[0].AsString
END;

FUNCTION TDm_Main.GenVersion: STRING;
BEGIN
    IbStProc_NewVerKey.ExecProc;
    result := IbStProc_NewVerKey.Fields[0].AsString
END;

FUNCTION TDm_Main.IBOMajPkKey ( DataSet: TIBODataSet; LeChamp: STRING ) :
    Boolean;
// Alimentation de la cle primaire d'un DataSet
BEGIN
    Result := True;
    TRY
        DataSet.FieldByName ( LeChamp ) .AsString := GenID;
    EXCEPT
        ErrMess ( ErrGenId, '' ) ;
        DataSet.Cancel;
        Result := False;
    END;
END;

FUNCTION TDm_Main.IB_MajPkKey ( DataSet: TIB_BDataSet; LeChamp: STRING ) :
    Boolean;
// Alimentation de la cle primaire d'un DataSet
BEGIN
    Result := True;
    TRY
        DataSet.FieldByName ( LeChamp ) .AsString := GenID;
    EXCEPT
        ErrMess ( ErrGenId, '' ) ;
        DataSet.Cancel;
        Result := False;
    END;
END;

// GESTION DES MISES A JOUR DU CACHE

PROCEDURE TDm_Main.IBOCancelCache ( DataSet: TIBOQuery ) ;
BEGIN
    IF DataSet.Active THEN
        DataSet.CancelUpdates;
END;

PROCEDURE TDm_Main.IBOCommitCache ( DataSet: TIBOQuery ) ;
BEGIN
    IF DataSet.Active AND ( FTransactionCount = 0 ) THEN
    BEGIN
        FVideCache := True;
        DataSet.ApplyUpdates;
        DataSet.CommitUpdates;
    END;
END;

PROCEDURE TDm_Main.IBOUpDateCache ( DataSet: TIBOQuery ) ;
BEGIN
    IF DataSet.Active THEN
    BEGIN
        TRY
            Dm_Main.StartTransaction;
            FVideCache := False;
            DataSet.ApplyUpdates;
            Dm_Main.Commit;
        EXCEPT
            Dm_Main.Rollback;
            Dm_Main.IBOCancelCache ( DataSet ) ;
            IF ( FTransactionCount <> 0 ) THEN RAISE;
        END;
        Dm_Main.IBOCommitCache ( DataSet ) ;
    END;
END;

PROCEDURE TDm_Main.IB_CancelCache ( DataSet: TIB_BDataSet ) ;
BEGIN
    IF DataSet.Active THEN
        DataSet.CancelUpdates;
END;

PROCEDURE TDm_Main.IB_CommitCache ( DataSet: TIB_BDataSet ) ;
BEGIN
    IF DataSet.Active AND ( FTransactionCount = 0 ) THEN
    BEGIN
        FVideCache := True;
        DataSet.ApplyUpdates;
        DataSet.CommitUpdates;
    END;
END;

PROCEDURE TDm_Main.IB_UpDateCache ( DataSet: TIB_BDataSet ) ;
BEGIN
    IF DataSet.Active THEN
    BEGIN
        TRY
            Dm_Main.StartTransaction;
            FVideCache := False;
            DataSet.ApplyUpdates;
            Dm_Main.Commit;
        EXCEPT
            Dm_Main.Rollback;
            Dm_Main.IB_CancelCache ( DataSet ) ;
            IF ( FTransactionCount <> 0 ) THEN RAISE;
        END;
        Dm_Main.IB_CommitCache ( DataSet ) ;
    END;
END;

PROCEDURE TDm_Main.IBOUpdateRecord ( TableName: STRING; DataSet: TIBODataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction ) ;
BEGIN
    IF FVideCache THEN
        UpdateAction := uaApplied
    ELSE
    BEGIN
        IF UpdateKind = ukInsert THEN
        BEGIN
            IBOCacheUpdateI ( TableName, DataSet ) ;
        END;
        IF UpdateKind = ukModify THEN
        BEGIN
            IBOCacheUpdateU ( TableName, DataSet ) ;
        END;
        IF UpdateKind = ukDelete THEN
        BEGIN
            IBOCacheUpdateD ( TableName, DataSet ) ;
        END;
    END;
END;

PROCEDURE TDm_Main.IB_UpdateRecord ( TableName: STRING; DataSet: TIB_BDataSet;
    UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction ) ;
BEGIN
    IF FVideCache THEN
        UpdateAction := uacApplied
    ELSE
    BEGIN
        IF UpdateKind = ukiInsert THEN
        BEGIN
            IB_CacheUpdateI ( TableName, DataSet ) ;
        END;
        IF UpdateKind = ukiModify THEN
        BEGIN
            IB_CacheUpdateU ( TableName, DataSet ) ;
        END;
        IF UpdateKind = ukiDelete THEN
        BEGIN
            IB_CacheUpdateD ( TableName, DataSet ) ;
        END;
    END;
END;

PROCEDURE TDm_Main.GetTableFields ( TableName: STRING ) ;
BEGIN
    IF IbQ_TableField.ParamByName ( 'TABLENAME' ) .AsString <> TableName THEN
        IbQ_TableField.ParamByName ( 'TABLENAME' ) .AsString := TableName;
    IF NOT IbQ_TableField.Active THEN IbQ_TableField.Open;

    IbQ_TableField.First;
    IF IbQ_TableField.Eof THEN
        RAISE Exception.Create ( ParamsStr ( ErrNoFieldDef, TableName ) ) ;

    IF IbQ_TablePkKey.ParamByName ( 'TABLENAME' ) .AsString <> TableName THEN
        IbQ_TablePkKey.ParamByName ( 'TABLENAME' ) .AsString := TableName;
    IF NOT IbQ_TablePkKey.Active THEN IbQ_TablePkKey.Open;

    IbQ_TablePkKey.First;
    IF IbQ_TablePkKey.Eof THEN
        RAISE Exception.Create ( ParamsStr ( ErrNoPkFieldDef, TableName ) ) ;
END;

PROCEDURE TDm_Main.IBOCacheUpdateI ( TableName: STRING; DataSet: TIBODataSet ) ;
BEGIN

    GetTableFields ( TableName ) ;

    ibc_majcu.SQL.Clear;
    ibc_majcu.SQL.Add ( 'INSERT INTO ' + TableName + '(' ) ;

    IF DataSet.FindField ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString )
        = NIL THEN
        RAISE Exception.Create ( ParamsStr ( ErrNoPkFieldFound,
            IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) ) ;

    WHILE NOT IbQ_TableField.Eof DO
    BEGIN
        ibc_majcu.SQL.Add ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString ) ;
        ibc_majcu.SQL.Add ( ',' ) ;
        IbQ_TableField.Next;
    END;
    ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ') VALUES (';
    IbQ_TableField.First;
    WHILE NOT IbQ_TableField.Eof DO
    BEGIN
        ibc_majcu.SQL.Add ( ':' + IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
            ) ;
        ibc_majcu.SQL.Add ( ',' ) ;
        IbQ_TableField.Next;
    END;
    ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ')';
    ibc_majcu.Prepare;

    IbQ_TableField.First;
    WHILE NOT IbQ_TableField.Eof DO
    BEGIN
        IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'INTEGER' THEN
        BEGIN
            IF ( DataSet.FindField ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
                ) <> NIL ) AND
                NOT VarIsNull ( DataSet.FieldByName ( IbQ_TableField.FieldByName (
                'KFLD_NAME' ) .AsString ) .NewValue ) THEN
                CASE DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString ) .DataType OF
                    ftBoolean:
                        IF DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                            ) .AsString ) .AsBoolean THEN
                            ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                                ) .AsString ) .AsInteger := 1
                        ELSE
                            ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                                ) .AsString ) .AsInteger := 0;
                    ftInteger:
                        ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                            ) .AsString ) .AsInteger :=
                            DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                            ) .AsString ) .NewValue;
                END
            ELSE
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsInteger := 0;
        END;

        IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'VARCHAR' THEN
        BEGIN
            IF ( DataSet.FindField ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
                ) <> NIL ) AND
                NOT VarIsNull ( DataSet.FieldByName ( IbQ_TableField.FieldByName (
                'KFLD_NAME' ) .AsString ) .NewValue ) THEN
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsString :=
                    DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .NewValue
            ELSE
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsString := '';
        END;

        IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'DATE' THEN
        BEGIN
            IF ( DataSet.FindField ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
                ) <> NIL ) AND
                NOT VarIsNull ( DataSet.FieldByName ( IbQ_TableField.FieldByName (
                'KFLD_NAME' ) .AsString ) .NewValue ) THEN
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsDateTime :=
                    DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .NewValue
            ELSE
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsDateTime := 0;
        END;

        IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'FLOAT' THEN
        BEGIN
            IF ( DataSet.FindField ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
                ) <> NIL ) AND
                NOT VarIsNull ( DataSet.FieldByName ( IbQ_TableField.FieldByName (
                'KFLD_NAME' ) .AsString ) .NewValue ) THEN
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsFloat :=
                    DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .NewValue
            ELSE
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsFloat := 0;
        END;

        IbQ_TableField.Next;
    END;

    IF IsKManagementActive THEN
        InsertK ( DataSet.FieldByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME'
            ) .AsString ) .NewValue,
            IbQ_TablePkKey.FieldByName ( 'KTB_ID' ) .AsString,
            '-101', '-1', '-1' ) ;

    ibc_majcu.Execute;

END;

PROCEDURE TDm_Main.IBOCacheUpdateU ( TableName: STRING; DataSet: TIBODataSet ) ;
VAR
    FoundModified: Boolean;
BEGIN
    FoundModified := False;
    GetTableFields ( TableName ) ;

    ibc_majcu.SQL.Clear;
    ibc_majcu.SQL.Add ( 'UPDATE ' + TableName + ' SET ' ) ;

    IF DataSet.FindField ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) =
        NIL THEN
        RAISE Exception.Create ( ParamsStr ( ErrNoPkFieldFound,
            IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) ) ;

    WHILE NOT IbQ_TableField.Eof DO
    BEGIN
        IF ( DataSet.FindField ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString )
            <> NIL ) AND
            NOT VarIsNull ( DataSet.FieldByName ( IbQ_TableField.FieldByName (
            'KFLD_NAME'
            ) .AsString ) .NewValue ) AND
            ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString <>
            IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString )
            AND ( DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
            ) .AsString ) .OldValue <>
            DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .NewValue ) THEN
        BEGIN
            ibc_majcu.SQL.Add ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString +
                ' = :' + IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
                ) ;
            ibc_majcu.SQL.Add ( ',' ) ;
            FoundModified := True;
        END;
        IbQ_TableField.Next;
    END;
    ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ' WHERE ' +
        IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
        + ' = :' + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString;

    IF FoundModified THEN
    BEGIN

        ibc_majcu.Prepare;
        IbQ_TableField.First;
        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            IF ( DataSet.FindField ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
                ) <> NIL ) AND
                NOT VarIsNull ( DataSet.FieldByName ( IbQ_TableField.FieldByName (
                'KFLD_NAME' ) .AsString ) .NewValue ) AND
                ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString <>
                IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString )
                AND ( DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                ) .AsString ) .OldValue <>
                DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
                ) .NewValue ) THEN
            BEGIN

                IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'INTEGER' THEN
                BEGIN
                    CASE DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .DataType OF
                        ftBoolean:
                            IF DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                                ) .AsString ) .AsBoolean THEN
                                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                                    ) .AsString ) .AsInteger := 1
                            ELSE
                                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                                    ) .AsString ) .AsInteger := 0;
                        ftInteger:
                            ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                                ) .AsString ) .AsInteger :=
                                DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                                ) .AsString ) .NewValue
                    END
                END;

                IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'VARCHAR' THEN
                BEGIN
                    ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .AsString :=
                        DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .NewValue;
                END;

                IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'DATE' THEN
                BEGIN
                    ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .AsDateTime :=
                        DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .NewValue;
                END;

                IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'FLOAT' THEN
                BEGIN
                    ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .AsFloat :=
                        DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .NewValue;
                END;
            END;
            IbQ_TableField.Next;
        END;

        ibc_majcu.ParamByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .AsString :=
            DataSet.FieldByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .NewValue;

        IF IsKManagementActive THEN
            UpdateK ( DataSet.FieldByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME'
                ) .AsString ) .NewValue,
                '-1' ) ;

        Ibc_majcu.Execute;
    END;
END;

PROCEDURE TDm_Main.IBOCacheUpdateD ( TableName: STRING; DataSet: TIBODataSet ) ;
BEGIN
    GetTableFields ( TableName ) ;

    IF DataSet.FindField ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) =
        NIL THEN
        RAISE Exception.Create ( ParamsStr ( ErrNoPkFieldFound,
            IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) ) ;

    IF NOT IsKManagementActive THEN
    BEGIN
        ibc_majcu.SQL.Clear;
        ibc_majcu.SQL.Add ( 'DELETE FROM ' + TableName + ' WHERE '
            + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            + ' = :' + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) ;
        ibc_majcu.Prepare;
        ibc_majcu.ParamByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .AsString :=
            DataSet.FieldByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .OldValue;
        ibc_majcu.Execute;
    END;

    IF IsKManagementActive THEN
    BEGIN
        DeleteK ( DataSet.FieldByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME'
            ) .AsString ) .Oldvalue,
            '-1' ) ;

        // Simulation de modification pour activation des triggers
        ibc_majcu.SQL.Clear;
        ibc_majcu.SQL.Add ( 'UPDATE ' + TableName + ' SET '
            + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            + ' = :' + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            + ' WHERE '
            + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            + ' = :' + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) ;

        ibc_majcu.Prepare;
        ibc_majcu.ParamByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .AsString :=
            DataSet.FieldByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .OldValue;
        ibc_majcu.Execute;

    END;

END;

PROCEDURE TDm_Main.IB_CacheUpdateI ( TableName: STRING; DataSet: TIB_BDataSet ) ;
BEGIN

    GetTableFields ( TableName ) ;

    ibc_majcu.SQL.Clear;
    ibc_majcu.SQL.Add ( 'INSERT INTO ' + TableName + '(' ) ;

    IF DataSet.FindField ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) =
        NIL THEN
        RAISE Exception.Create ( ParamsStr ( ErrNoPkFieldFound,
            IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) ) ;

    WHILE NOT IbQ_TableField.Eof DO
    BEGIN
        ibc_majcu.SQL.Add ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString ) ;
        ibc_majcu.SQL.Add ( ',' ) ;
        IbQ_TableField.Next;
    END;
    ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ') VALUES (';
    IbQ_TableField.First;
    WHILE NOT IbQ_TableField.Eof DO
    BEGIN
        ibc_majcu.SQL.Add ( ':' + IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
            ) ;
        ibc_majcu.SQL.Add ( ',' ) ;
        IbQ_TableField.Next;
    END;
    ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ')';
    ibc_majcu.Prepare;

    IbQ_TableField.First;
    WHILE NOT IbQ_TableField.Eof DO
    BEGIN
        IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'INTEGER' THEN
        BEGIN
            IF DataSet.FindField ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString )
                <> NIL THEN
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsInteger :=
                    DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsInteger
            ELSE
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsInteger := 0;
        END;

        IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'VARCHAR' THEN
        BEGIN
            IF DataSet.FindField ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString )
                <> NIL THEN
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsString :=
                    DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsString
            ELSE
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsString := '';
        END;

        IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'DATE' THEN
        BEGIN
            IF DataSet.FindField ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString )
                <> NIL THEN
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsDateTime :=
                    DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsDateTime
            ELSE
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsDateTime := 0;
        END;

        IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'FLOAT' THEN
        BEGIN
            IF DataSet.FindField ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString )
                <> NIL THEN
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsFloat :=
                    DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsFloat
            ELSE
                ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                    ) .AsString
                    ) .AsFloat := 0;
        END;

        IbQ_TableField.Next;
    END;

    IF IsKManagementActive THEN
        InsertK ( DataSet.FieldByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME'
            ) .AsString ) .AsString,
            IbQ_TablePkKey.FieldByName ( 'KTB_ID' ) .AsString,
            '-101', '-1', '-1' ) ;

    Ibc_majcu.Execute;

END;

PROCEDURE TDm_Main.IB_CacheUpdateU ( TableName: STRING; DataSet: TIB_BDataSet ) ;
VAR
    FoundModified: Boolean;
BEGIN
    FoundModified := False;
    GetTableFields ( TableName ) ;

    ibc_majcu.SQL.Clear;
    ibc_majcu.SQL.Add ( 'UPDATE ' + TableName + ' SET ' ) ;

    IF DataSet.FindField ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) =
        NIL THEN
        RAISE Exception.Create ( ParamsStr ( ErrNoPkFieldFound,
            IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) ) ;

    WHILE NOT IbQ_TableField.Eof DO
    BEGIN
        IF ( DataSet.FindField ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString )
            <> NIL ) AND
            ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString <>
            IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) AND
            ( DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .AsString <>
            DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .OldAsString ) THEN
        BEGIN
            ibc_majcu.SQL.Add ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString +
                ' = :' + IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
                ) ;
            ibc_majcu.SQL.Add ( ',' ) ;
            FoundModified := True;
        END;
        IbQ_TableField.Next;
    END;
    ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ' WHERE ' +
        IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
        + ' = :' + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString;

    IF FoundModified THEN
    BEGIN

        ibc_majcu.Prepare;
        IbQ_TableField.First;
        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            IF ( DataSet.FindField ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
                ) <> NIL ) AND
                ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString <>
                IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) AND
                ( DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                ) .AsString
                ) .AsString <>
                DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME' ) .AsString
                ) .OldAsString ) THEN
            BEGIN

                IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'INTEGER' THEN
                BEGIN
                    ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .AsInteger :=
                        DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .AsInteger
                END;

                IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'VARCHAR' THEN
                BEGIN
                    ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .AsString :=
                        DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .AsString;
                END;

                IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'DATE' THEN
                BEGIN
                    ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .AsDateTime :=
                        DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .AsDateTime;
                END;

                IF IbQ_TableField.FieldByName ( 'KKW_NAME' ) .AsString = 'FLOAT' THEN
                BEGIN
                    ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .AsFloat :=
                        DataSet.FieldByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
                        ) .AsString ) .AsFloat;
                END;
            END;
            IbQ_TableField.Next;
        END;

        ibc_majcu.ParamByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .AsString :=
            DataSet.FieldByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .AsString;

        IF IsKManagementActive THEN
            UpdateK ( DataSet.FieldByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME'
                ) .AsString ) .AsString,
                '-1' ) ;

        Ibc_majcu.Execute;

    END;
END;

PROCEDURE TDm_Main.IB_CacheUpdateD ( TableName: STRING; DataSet: TIB_BDataSet ) ;
BEGIN
    GetTableFields ( TableName ) ;
    IF IbQ_TablePkKey.Eof THEN
        RAISE Exception.Create ( ParamsStr ( ErrNoPkFieldDef, TableName ) ) ;

    IF DataSet.FindField ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) =
        NIL THEN
        RAISE Exception.Create ( ParamsStr ( ErrNoPkFieldFound,
            IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) ) ;

    IF NOT IsKManagementActive THEN
    BEGIN
        ibc_majcu.SQL.Clear;
        ibc_majcu.SQL.Add ( 'DELETE FROM ' + TableName + ' WHERE '
            + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            + ' = :' + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) ;
        ibc_majcu.Prepare;
        ibc_majcu.ParamByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .AsString :=
            DataSet.FieldByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .OldAsString;
        ibc_majcu.Execute;
    END;

    IF IsKManagementActive THEN
    BEGIN
        DeleteK ( DataSet.FieldByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME'
            ) .AsString ) .OldAsString,
            '-1' ) ;

        // Simulation de modification pour activation des triggers
        ibc_majcu.SQL.Clear;
        ibc_majcu.SQL.Add ( 'UPDATE ' + TableName + ' SET '
            + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            + ' = :' + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            + ' WHERE '
            + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            + ' = :' + IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString ) ;

        ibc_majcu.Prepare;
        ibc_majcu.ParamByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .AsString :=
            DataSet.FieldByName ( IbQ_TablePkKey.FieldByName ( 'KFLD_NAME' ) .AsString
            ) .OldAsString;
        ibc_majcu.Execute;

    END;
END;

// GESTION DE LA TABLE K

PROCEDURE TDm_Main.InsertK ( K_ID, KTB_ID, KRH_ID, KSE_Owner, KSE_Insert: STRING
    ) ;
VAR
    S1, S2: STRING;
BEGIN
    S1 := DateTimeToStr ( Now ) ;
    S2 := DateTimeToStr ( 0 ) ;
    IF NOT IbC_InsertK.Prepared THEN
        IbC_InsertK.Prepare;
    IbC_InsertK.ParamByName ( 'K_ID' ) .AsString := K_ID;
    IF FVersionSys = 0 THEN
        IbC_InsertK.ParamByName ( 'K_VERSION' ) .AsString := GenVersion
    ELSE
        IbC_InsertK.ParamByName ( 'K_VERSION' ) .AsInteger := FVersionSys;

    IbC_InsertK.ParamByName ( 'KRH_ID' ) .AsString := KRH_ID;
    IbC_InsertK.ParamByName ( 'KTB_ID' ) .AsString := KTB_ID;
    IbC_InsertK.ParamByName ( 'KSE_OWNER_ID' ) .AsString := KSE_Owner;
    IbC_InsertK.ParamByName ( 'KSE_INSERT_ID' ) .AsString := KSE_Insert;
    IbC_InsertK.ParamByName ( 'KSE_UPDATE_ID' ) .AsString := '0';
    IbC_InsertK.ParamByName ( 'KSE_DELETE_ID' ) .AsString := '0';
    IbC_InsertK.ParamByName ( 'K_INSERTED' ) .AsString := S1;
    IbC_InsertK.ParamByName ( 'K_UPDATED' ) .AsString := S1;
    IbC_InsertK.ParamByName ( 'K_DELETED' ) .AsString := S2;
    IbC_InsertK.ParamByName ( 'KSE_LOCK_ID' ) .AsString := '0';
    IbC_InsertK.ParamByName ( 'KMA_LOCK_ID' ) .AsString := '0';
    IbC_InsertK.Execute;
END;

PROCEDURE TDm_Main.UpdateK ( K_ID, KSE_Update: STRING ) ;
VAR
    S: STRING;
BEGIN
    S := DateTimeToStr ( Now ) ;
    IF NOT IbC_UpDateK.Prepared THEN
        IbC_UpDateK.Prepare;
    IbC_UpDateK.ParamByName ( 'K_ID' ) .AsString := K_ID;
    IF FVersionSys = 0 THEN
        IbC_UpDateK.ParamByName ( 'K_VERSION' ) .AsString := GenVersion
    ELSE
        IbC_UpDateK.ParamByName ( 'K_VERSION' ) .AsString := IntToStr ( FVersionSys ) ;

    IbC_UpDateK.ParamByName ( 'KSE_UPDATE_ID' ) .AsString := KSE_Update;
    IbC_UpDateK.ParamByName ( 'K_UPDATED' ) .AsString := S;
    IbC_UpDateK.Execute;
END;

PROCEDURE TDm_Main.DeleteK ( K_ID, KSE_Delete: STRING ) ;
VAR
    S: STRING;
BEGIN
    S := DateTimeToStr ( Now ) ;
    IF NOT IbC_DeleteK.Prepared THEN
        IbC_DeleteK.Prepare;
    IbC_DeleteK.ParamByName ( 'K_ID' ) .AsString := K_ID;
    IF FVersionSys = 0 THEN
        IbC_DeleteK.ParamByName ( 'K_VERSION' ) .AsString := GenVersion
    ELSE
        IbC_DeleteK.ParamByName ( 'K_VERSION' ) .AsInteger := FVersionSys;

    IbC_DeleteK.ParamByName ( 'KSE_DELETE_ID' ) .AsString := KSE_Delete;
    IbC_DeleteK.ParamByName ( 'K_DELETED' ) .AsString := S;
    IbC_DeleteK.Execute;
END;

PROCEDURE TDm_Main.SetVersionSys ( Version: Integer ) ;
BEGIN
    FVersionSys := Version;
END;

PROCEDURE TDm_Main.DesableKManagement;
BEGIN
    FKActive := False;
END;

FUNCTION TDm_Main.IsKManagementActive: Boolean;
BEGIN
    Result := FKActive;
END;

PROCEDURE TDm_Main.SetNewGenerator ( ProcName: STRING ) ;
BEGIN
    IbStProc_NewKey.StoredProcName := ProcName;
END;

// GESTION DU MONITEUR SQL

PROCEDURE TDm_Main.ShowMonitor;
BEGIN
    Monitor.Show;
END;

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
        'UPDATE K SET ' +
        'K_VERSION = (SELECT NEWKEY from PROC_NEWVERKEY),' +
        'KSE_UPDATE_ID = -1,' +
        'K_UPDATED = :K_UPDATED WHERE K.K_ID IN (' +
        SQL + ' )' ) ;
    IbC_Script.Prepare;
    IbC_Script.ParamByName ( 'K_UPDATED' ) .AsString := DateTimeToStr ( Now ) ;
END;

PROCEDURE TDm_Main.PrepareScriptMultiKDelete ( SQL: STRING ) ;
BEGIN
    IbC_Script.Close;
    IbC_Script.SQL.Clear;
    IbC_Script.SQL.Add (
        'UPDATE K SET ' +
        'K_VERSION = (SELECT NEWKEY from PROC_NEWVERKEY),' +
        'K_ENABLED = 0,' +
        'KSE_UPDATE_ID = -1,' +
        'K_DELETED = :K_DELETED WHERE K.K_ID IN (' +
        SQL + ' )' ) ;
    IbC_Script.Prepare;
    IbC_Script.ParamByName ( 'K_DELETED' ) .AsString := DateTimeToStr ( Now ) ;

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

PROCEDURE TDm_Main.ExecuteInsertK ( TableName, KeyValue: STRING ) ;
VAR
    SQLTYPE: STRING;
BEGIN
    TRY
        Dm_Main.StartTransaction;

        // Mise à jour de la Table K
        GetTableFields ( TableName ) ;

        SQLTYPE := FirstMot ( IbC_Script.SQL[0] ) ;
        IF ( SQLTYPE <> 'INSERT' ) OR ( StrToInt ( KeyValue ) <= 0 ) THEN
            RAISE Exception.Create ( ErrUsingScript ) ;

        InsertK ( KeyValue, IbQ_TablePkKey.FieldByName ( 'KTB_ID' ) .AsString,
            '-101', '-1', '-1' ) ;

        // Lancement de la commande SQL
        IbC_Script.Execute;

        Dm_Main.Commit;
    EXCEPT
        Dm_Main.Rollback;
        IF ( FTransactionCount <> 0 ) THEN RAISE;
    END;
END;

// VERIFICATION DE L'INTEGRITE DE LA BASE

FUNCTION TDm_Main.CheckOneIntegrity ( LkUpTableName, LkPkFieldName,
    LkUpFieldName, KeyValue: STRING; ShowErrorMessage: Boolean ) : Boolean;
BEGIN
    Ibc_IntegrityChk.Close;
    Ibc_IntegrityChk.SQL.Clear;
    IF IsKManagementActive THEN
        Ibc_IntegrityChk.SQL.Add ( 'SELECT * FROM '
            + LkUpTableName
            + ',K WHERE '
            + LkUpFieldName
            + '=' + KeyValue
            + ' AND ' + LkPkFieldName // Ajout pour traiter le cas des arbres stockés
            + '<>' + KeyValue // dans une même table
            + ' AND K_ID = '
            + LkPkFieldName
            + ' AND K_ENABLED=1' )
    ELSE
        Ibc_IntegrityChk.SQL.Add ( 'SELECT * FROM '
            + LkUpTableName
            + ' WHERE '
            + LkUpFieldName
            + '=' + KeyValue
            + ' AND ' + LkPkFieldName // Ajout pour traiter le cas des arbres stockés
            + '<>' + KeyValue // dans une même table
            ) ;
    Ibc_IntegrityChk.Open;
    Result := Ibc_IntegrityChk.Eof;

    IF NOT Result AND ShowErrorMessage THEN
    BEGIN
        ERRMESS ( ErrNoDeleteIntChk, '' ) ;
    END;

END;

FUNCTION TDm_Main.CheckAllowEdit ( TableName, KeyValue: STRING;
    ShowErrorMessage:
    Boolean ) : boolean;
BEGIN
    Result := True;
    IF ( KeyValue <> '' ) AND ( StrToInt ( KeyValue ) <= 0 ) THEN
    BEGIN
        IF ShowErrorMessage THEN ERRMESS ( ErrNoEditNullRec, '' ) ;
        Result := False;
    END;
END;

FUNCTION TDm_Main.TransactionUpdPending: boolean;
BEGIN
    Result := IbT_Select.TransactionIsActive;
END;

FUNCTION TDm_Main.IBOUpdPending ( DataSet: TIBODataSet ) : boolean;
BEGIN
    Result := DataSet.Modified OR DataSet.UpdatesPending;
END;

FUNCTION TDm_Main.IB_UpdPending ( DataSet: TIB_BDataSet ) : boolean;
BEGIN
    Result := DataSet.Modified OR DataSet.UpdatesPending;
END;

FUNCTION TDm_Main.CheckAllowDelete ( TableName, KeyValue: STRING;
    ShowErrorMessage: Boolean ) : boolean;
BEGIN
    Result := True;

    IF KeyValue = '0' THEN
    BEGIN
        IF ShowErrorMessage THEN ERRMESS ( ErrNoDeleteNullRec, '' ) ;
        Result := False;
    END
    ELSE
    BEGIN

        GetTableFields ( TableName ) ;
        IF IbQ_TablePkKey.Eof THEN
            RAISE Exception.Create ( ParamsStr ( ErrNoPkFieldDef, TableName ) ) ;

        IF IbQ_FieldFkField.ParamByName ( 'KFLD_FK' ) .AsString <>
            IbQ_TablePkKey.FieldByName ( 'KFLD_ID' ) .AsString THEN
            IbQ_FieldFkField.ParamByName ( 'KFLD_FK' ) .AsString :=
                IbQ_TablePkKey.FieldByName ( 'KFLD_ID' ) .AsString;

        IF NOT IbQ_FieldFkField.Active THEN IbQ_FieldFkField.Open;
        IbQ_FieldFkField.First;

        WHILE NOT IbQ_FieldFkField.Eof DO
        BEGIN
            Result := Result AND
                CheckOneIntegrity ( IbQ_FieldFkField.FieldByName ( 'KTB_NAME' ) .AsString,
                IbQ_FieldFkField.FieldByName ( 'PKFIELD' ) .AsString,
                IbQ_FieldFkField.FieldByName ( 'KFLD_NAME' ) .AsString,
                KeyValue, False ) ;
            IbQ_FieldFkField.Next;
        END;

        IF NOT Result AND ShowErrorMessage THEN
        BEGIN
            ERRMESS ( ErrNoDeleteIntChk, '' ) ;
        END;
    END;
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TDm_Main.DataModuleDestroy ( Sender: TObject ) ;
BEGIN
    Database.Connected := False;
END;

PROCEDURE TDm_Main.ibc_majcuError ( Sender: TObject; CONST ERRCODE: Integer;
    ErrorMessage, ErrorCodes: TStringList; CONST SQLCODE: Integer;
    SQLMessage, SQL: TStringList; VAR RaiseException: Boolean ) ;
BEGIN
    RaiseException := False;
    CASE SQLCODE OF
        -625: RAISE Exception.Create ( errSQL625 ) ;
        -803: RAISE Exception.Create ( errSQL803 ) ;
    ELSE
        RAISE Exception.Create ( ParamsStr ( errSQL, SQLCODE ) ) ;
    END;
END;

END.

