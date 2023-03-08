//------------------------------------------------------------------------------
// Nom de l'unité : Admin_Dm
// Rôle           : Gestion accès base de donnée pour Admin
// Auteur         : Sylvain GHEROLD
// Historique     :
//------------------------------------------------------------------------------

UNIT Admin_Dm;

INTERFACE

USES
    Windows,
    Math,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs, IBDataset, Db, dxmdaset, StrHlder, LMDCustomComponent,
  LMDContainerComponent, LMDBaseDialog, LMDTextEditDlg, IB_Components;


TYPE
    TDm_Admin = CLASS( TDataModule )
        IbQ_Module: TIB_Query;
        Ids_Module: TIB_DataSource;
        Ids_Table: TIB_DataSource;
        IbQ_Table: TIB_Query;
        IbQ_Field: TIB_Query;
        Ids_Field: TIB_DataSource;
        IbQ_FieldType: TIB_Query;
        IbQ_FieldRef: TIB_Query;
        IbC_ChkExistField: TIB_Cursor;
        IbQ_TableField: TIB_Query;
        IbQ_FieldFkField: TIB_Query;
        IbQ_TablePkKey: TIB_Query;
        TxtEd_Script: TLMDTextEditDlg;
        IbQ_Field2: TIB_Query;
        IbQ_NoSQL: TIB_Query;
        IbQ_Chps: TIB_Query;
        Str_Chps: TStrHolder;
        Str_Fields: TStrHolder;
        IbQ_Type: TIB_Query;
        MemD_Tables: TdxMemData;
        MemD_TablesTable: TStringField;
        CtrlTable: TIB_Cursor;
        IbC_NewKTBID: TIB_Cursor;
        IbC_ChkExistKTBID: TIB_Cursor;
        PROCEDURE DataModuleCreate( Sender: TObject );
        PROCEDURE DataModuleDestroy( Sender: TObject );
        PROCEDURE IbQ_ModuleUpdateRecord( DataSet: TComponent;
            UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction );
        PROCEDURE IbQ_ModuleNewRecord( IB_Dataset: TIB_Dataset );
        PROCEDURE IbQ_TableNewRecord( IB_Dataset: TIB_Dataset );
        PROCEDURE IbQ_TableUpdateRecord( DataSet: TComponent;
            UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction );
        PROCEDURE IbQ_FieldNewRecord( IB_Dataset: TIB_Dataset );
        PROCEDURE IbQ_FieldUpdateRecord( DataSet: TComponent;
            UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction );
        PROCEDURE IbQ_TableBeforeDelete( IB_Dataset: TIB_Dataset );
        PROCEDURE IbQ_ModuleBeforeDelete( IB_Dataset: TIB_Dataset );
        PROCEDURE IbQ_FieldAfterPost( IB_Dataset: TIB_Dataset );
        PROCEDURE IbQ_FieldRefUpdateRecord( DataSet: TComponent;
            UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction );
        PROCEDURE IbQ_FieldRefAfterPost( IB_Dataset: TIB_Dataset );
        PROCEDURE IbQ_FieldTypeUpdateRecord( DataSet: TComponent;
            UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction );
        PROCEDURE IbQ_FieldTypeAfterPost( IB_Dataset: TIB_Dataset );
        PROCEDURE IbQ_TableCalculateField( Sender: TIB_Statement; ARow: TIB_Row;
            AField: TIB_Column );
    private
    { Déclarations privées }
        OkTables: Boolean;
        KTBID_Count: integer;
        FUNCTION GetReplLibelle( KTBID: integer ): STRING;
    public
    { Déclarations publiques }
        PROCEDURE Commit;
        PROCEDURE Rollback;
        PROCEDURE Refresh;
        FUNCTION UpdPending: boolean;
        PROCEDURE GetTableFields( TableName: STRING );
        PROCEDURE TraceRecord( TableName: STRING; DataSet: TIB_Query );
        PROCEDURE GetStructureModule;
        PROCEDURE GetStructureTable;
        PROCEDURE GetNullValues;
        PROCEDURE GetChamps;
        PROCEDURE GetTables;
        FUNCTION TablesOk: Boolean;
        PROCEDURE AddTables;
        FUNCTION ModuleOk( VAR Titre: STRING ): Boolean;
        FUNCTION GetNewKTBID( ReplicationType: STRING ): STRING;
        FUNCTION GetTableName: STRING;
        FUNCTION ValidKTBID( KTBID: integer ): boolean;
        PROCEDURE ChangeKTBID( KTBID: integer );
    END;

CONST

    REPL_UPDOWN = 'UP & DOWN';
    REPL_UPDOWN_MIN = -11111999;
    REPL_UPDOWN_MAX = -11111000;

    REPL_DOWN = 'DOWN';
    REPL_DOWN_MIN = -11112999;
    REPL_DOWN_MAX = -11112000;

    REPL_SYSTEM = 'SYSTEM';
    REPL_SYSTEM_MIN = -11113999;
    REPL_SYSTEM_MAX = -11113000;

    REPL_UP = 'UP';
    REPL_UP_MIN = -11114999;
    REPL_UP_MAX = -11114000;

    REPL_INVALIDE = 'INVALIDE';

VAR
    Dm_Admin: TDm_Admin;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

IMPLEMENTATION

USES Main_Dm,
    ConstStd,
    StdUtils;

{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

FUNCTION TDm_Admin.ModuleOk( VAR Titre: STRING ): Boolean;
BEGIN
    Titre := '';
    Result := NOT Ibq_Module.IsEmpty;
    IF Result THEN Titre := Ibq_Module.FieldByName( 'KKW_NAME' ).asstring;
END;

FUNCTION TDm_Admin.TablesOk: Boolean;
BEGIN
    Result := OkTables;
END;

PROCEDURE TDm_Admin.AddTables;
BEGIN
    Ibq_Table.Insert;
    Ibq_Table.FieldByName( 'KTB_NAME' ).asstring := MemD_TablesTable.asstring;
    Ibq_Table.FieldByName( 'KMDL_ID' ).asInteger := Ibq_Module.FieldByName( 'KKW_ID' ).AsInteger;
    Ibq_Table.Post;
END;

PROCEDURE TDm_Admin.GetTables;
VAR
    i: Integer;
BEGIN
    OkTables := False;
    MemD_tables.close;
    MemD_Tables.Open;
    MemD_Tables.SortedField := 'Table';
    WITH Dm_Main.Database.SchemaCache.TableNames DO
    BEGIN
        FOR i := 0 TO Count - 1 DO
        BEGIN
            CtrlTable.close;
            CtrlTable.ParamByName( 'Latable' ).asstring := Strings[ i ];
            CtrlTable.Open;
            IF CtrlTable.Eof THEN
            BEGIN
                memD_Tables.Insert;
                memD_TablesTable.asString := Strings[ i ];
                memD_Tables.Post;
                OkTables := True;
            END;
        END;
        MemD_Tables.First;
    END;
    CtrlTable.close;
END;

PROCEDURE TDm_Admin.GetChamps;
VAR
    i: Integer;
    ch: STRING;
    flag: boolean;
BEGIN
    flag := False;
    IF Trim( Ibq_Table.FieldByname( 'KTB_NAME' ).asstring ) = '' THEN
    BEGIN
        Errmess( 'Aucune table sélectionnée ...       ', '' );
        Exit;
    END;

    str_chps.Clear;
    str_fields.clear;
    ibq_chps.close;
    ibq_chps.Sql.clear;
    TRY
        ibq_chps.Sql.add( 'SELECT * FROM ' + Ibq_Table.FieldByname( 'KTB_NAME' ).asstring );

        ibq_chps.open;
        ibq_chps.GetFieldNamesList( str_chps.Strings );
    EXCEPT
        ibq_Chps.close;
        ErrMess( 'Table non trouvée dans la base de données     ', '' );
        Exit
    END;

    str_chps.strings.Delete( str_chps.strings.count - 1 );
    // supprime le champ DB_KEY réceptionné en fin

    ibq_field.DisableControls;
    FOR i := 0 TO str_chps.Strings.Count - 1 DO
        str_chps.strings[ i ] := uppercase( str_chps.strings[ i ] );
    ibq_field.first;
    WHILE NOT ibq_Field.eof DO
    BEGIN
        ch := ibq_field.fieldByName( 'KFLD_NAME' ).asstring;
        IF str_chps.strings.IndexOf( ch ) = -1 THEN
            ibq_field.Delete
        ELSE
        BEGIN
            str_fields.strings.add( uppercase( ibq_field.fieldByName( 'KFLD_NAME' ).asstring ) );
            ibq_Field.Next;
        END;
    END;
    ibq_field.EnableControls;
    FOR i := 0 TO str_chps.Strings.Count - 1 DO
        IF str_fields.strings.IndexOf( str_chps.strings[ i ] ) = -1 THEN
        BEGIN
            flag := True;
            ibq_Field.Insert;
            ibq_Field.fieldByName( 'KFLD_NAME' ).asstring := str_chps.strings[ i ];
            ibq_Type.close;
            ibq_type.paramByName( 'TIP' ).asstring := '';
            ch := ibq_chps.fieldByName( str_chps.strings[ i ] ).SQLTypeSource;

            IF pos( 'INTEGER', ch ) <> 0 THEN
            BEGIN
                ibq_type.paramByName( 'TIP' ).asstring := 'INTEGER';
                IF ( Uppercase( RightStr( str_chps.strings[ i ], 3 ) ) = '_ID' ) OR ( Uppercase( RightStr(
                    str_chps.strings[ i ], 4 ) ) = '_KEY' ) THEN
                    ibq_Field.fieldByName( 'KFLD_PK' ).asInteger := 1
            END;
            IF pos( 'NUMERIC', ch ) <> 0 THEN
                ibq_type.paramByName( 'TIP' ).asstring := 'FLOAT';
            IF pos( 'DECIMAL', ch ) <> 0 THEN
                ibq_type.paramByName( 'TIP' ).asstring := 'FLOAT';
            IF pos( 'VARCHAR', ch ) <> 0 THEN
                ibq_type.paramByName( 'TIP' ).asstring := 'VARCHAR';
            IF pos( 'BLOB', ch ) <> 0 THEN
                ibq_type.paramByName( 'TIP' ).asstring := 'VARCHAR';
            IF pos( 'DATE', ch ) <> 0 THEN
                ibq_type.paramByName( 'TIP' ).asstring := 'DATE';
            IF pos( 'TIMESTAMP', ch ) <> 0 THEN
                ibq_type.paramByName( 'TIP' ).asstring := 'DATE';

            IF ibq_type.paramByName( 'TIP' ).asstring <> '' THEN
            BEGIN
                ibq_Type.Open;
                IF NOT ibq_Type.IsEmpty THEN
                BEGIN
                    ibq_Field.fieldByName( 'KFLDKND_ID' ).asInteger := ibq_Type.fieldByName( 'KKW_ID'
                        ).asInteger;
                    ibq_Field.fieldByName( 'FIELDTYPE' ).asstring := ibq_type.paramByName( 'TIP' ).asstring;
                END;
            END;
            ibq_Field.Post;
        END;
    ibq_chps.close;
    ibq_Type.close;
    IF NOT flag THEN INFMess( 'Aucune mise à jour nécessaire ...    ', '' );
END;

PROCEDURE TDm_Admin.Commit;
BEGIN
    IF IbQ_Field.State IN [ dssInsert, dssEdit, dssDelete ] THEN IbQ_Field.Post;
    IF IbQ_Table.State IN [ dssInsert, dssEdit, dssDelete ] THEN IbQ_Table.Post;
    IF IbQ_Module.State IN [ dssInsert, dssEdit, dssDelete ] THEN IbQ_Module.Post;
    TRY
        Dm_Main.StartTransaction;
        Dm_Main.IB_UpDateCache( IbQ_Module );
        Dm_Main.IB_UpDateCache( IbQ_Table );
        Dm_Main.IB_UpDateCache( IbQ_Field );
        Dm_Main.Commit;
    EXCEPT
        Dm_Main.Rollback;
        Dm_Main.IB_CancelCache( IbQ_Module );
        Dm_Main.IB_CancelCache( IbQ_Table );
        Dm_Main.IB_CancelCache( IbQ_Field );
    END;
    Dm_Main.IB_CommitCache( IbQ_Module );
    Dm_Main.IB_CommitCache( IbQ_Table );
    Dm_Main.IB_CommitCache( IbQ_Field );
    KTBID_Count := 1;
END;

PROCEDURE TDm_Admin.Rollback;
BEGIN
    Dm_Main.IB_CancelCache( IbQ_Module );
    Dm_Main.IB_CancelCache( IbQ_Table );
    Dm_Main.IB_CancelCache( IbQ_Field );
    KTBID_Count := 1;
END;

FUNCTION TDm_Admin.UpdPending: boolean;
BEGIN
    Result := ( IbQ_Module.State <> dssBrowse ) OR
        ( IbQ_Table.State <> dssBrowse ) OR
        ( IbQ_Field.State <> dssBrowse ) OR
        Dm_Main.IB_UpdPending( IbQ_Module ) OR
        Dm_Main.IB_UpdPending( IbQ_Table ) OR
        Dm_Main.IB_UpdPending( IbQ_Field );
END;

PROCEDURE TDm_Admin.Refresh;
BEGIN
    IbQ_FieldRef.DisableControls;
    IbQ_FieldRef.KeySource := NIL;
    IbQ_FieldRef.Refresh;
    IbQ_FieldRef.Insert;
    IbQ_FieldRef.FieldByName( 'KFLD_ID' ).AsInteger := 0;
    IbQ_FieldRef.Post;
    IbQ_FieldRef.KeySource := Ids_Field;
    IbQ_FieldRef.EnableControls;

    IbQ_Table.Refresh;
    IbQ_Field.Refresh;
END;

FUNCTION TDm_Admin.GetNewKTBID( ReplicationType: STRING ): STRING;
BEGIN
    IbC_NewKTBID.Close;
    IbC_NewKTBID.Prepare;

    IF ReplicationType = REPL_UPDOWN THEN
    BEGIN
        IbC_NewKTBID.ParamByName( 'MINI' ).AsInteger := REPL_UPDOWN_MIN;
        IbC_NewKTBID.ParamByName( 'MAXI' ).AsInteger := REPL_UPDOWN_MAX;
        IbC_NewKTBID.Open;
        Result := IntToStr( Min( IbC_NewKTBID.FieldByName( 'RESULTAT' ).AsInteger, -11111000 ) - KTBID_Count
            );
    END;
    IF ReplicationType = REPL_DOWN THEN
    BEGIN
        IbC_NewKTBID.ParamByName( 'MINI' ).AsInteger := REPL_DOWN_MIN;
        IbC_NewKTBID.ParamByName( 'MAXI' ).AsInteger := REPL_DOWN_MAX;
        IbC_NewKTBID.Open;
        Result := IntToStr( Min( IbC_NewKTBID.FieldByName( 'RESULTAT' ).AsInteger, -11112000 ) - KTBID_Count
            );
    END;
    IF ReplicationType = REPL_SYSTEM THEN
    BEGIN
        IbC_NewKTBID.ParamByName( 'MINI' ).AsInteger := REPL_SYSTEM_MIN;
        IbC_NewKTBID.ParamByName( 'MAXI' ).AsInteger := REPL_SYSTEM_MAX;
        IbC_NewKTBID.Open;
        Result := IntToStr( Min( IbC_NewKTBID.FieldByName( 'RESULTAT' ).AsInteger, -11113000 ) - KTBID_Count
            );
    END;
    IF ReplicationType = REPL_UP THEN
    BEGIN
        IbC_NewKTBID.ParamByName( 'MINI' ).AsInteger := REPL_UP_MIN;
        IbC_NewKTBID.ParamByName( 'MAXI' ).AsInteger := REPL_UP_MAX;
        IbC_NewKTBID.Open;
        Result := IntToStr( Min( IbC_NewKTBID.FieldByName( 'RESULTAT' ).AsInteger, -11114000 ) - KTBID_Count
            );
    END;
    KTBID_Count := KTBID_Count + 1;
END;

FUNCTION TDm_Admin.GetTableName: STRING;
BEGIN
    Result := IbQ_Table.fieldByName( 'KTB_NAME' ).AsString;
END;

FUNCTION TDm_Admin.GetReplLibelle( KTBID: integer ): STRING;
BEGIN
    IF ( KTBID <= REPL_UPDOWN_MAX ) AND
        ( KTBID >= REPL_UPDOWN_MIN ) THEN
        Result := REPL_UPDOWN
    ELSE
        IF ( KTBID <= REPL_DOWN_MAX ) AND
        ( KTBID >= REPL_DOWN_MIN ) THEN
            Result := REPL_DOWN
        ELSE
            IF ( KTBID <= REPL_SYSTEM_MAX ) AND
            ( KTBID >= REPL_SYSTEM_MIN ) THEN
                Result := REPL_SYSTEM
            ELSE
                IF ( KTBID <= REPL_UP_MAX ) AND
                ( KTBID >= REPL_UP_MIN ) THEN
                    Result := REPL_UP
                ELSE
                    Result := 'INVALIDE';
END;

FUNCTION TDm_Admin.ValidKTBID( KTBID: integer ): boolean;
BEGIN
    Result := True;
    IF ( GetReplLibelle( KTBID ) = REPL_INVALIDE ) THEN
    BEGIN
        Errmess( 'Ordre de réplication invalide', '' );
        Result := False;
    END;

    IF Result THEN
    BEGIN
        IbC_ChkExistKTBID.Close;
        IbC_ChkExistKTBID.Prepare;
        IbC_ChkExistKTBID.ParamByName( 'KTB_ID' ).AsInteger := KTBID;
        IbC_ChkExistKTBID.Open;
        IF NOT IbC_ChkExistKTBID.Eof THEN
        BEGIN
            IF ( IbC_ChkExistKTBID.FieldByName( 'K_ENABLED' ).AsInteger = 1 ) THEN
                Errmess( 'Ordre de réplication déjà utilisé par la table §0',
                    IbC_ChkExistKTBID.FieldByName( 'KTB_NAME' ).AsString )
            ELSE
                Errmess( 'Ordre de réplication déjà utilisé par une table effacée', '' );
            Result := False;
        END;
    END;
END;

PROCEDURE TDm_Admin.ChangeKTBID( KTBID: integer );
VAR
    OldKTBID: STRING;
BEGIN
    OldKTBID := IbQ_Table.FieldByName( 'KTB_ID' ).AsString;

    TRY
        Dm_Main.StartTransaction;

        Dm_Main.PrepareScript( 'UPDATE KTB SET KTB_ID=:NEW_KTB_ID WHERE KTB_ID=:OLD_KTB_ID' );
        Dm_Main.SetScriptParameterValue( 'NEW_KTB_ID', IntToStr( KTBID ) );
        Dm_Main.SetScriptParameterValue( 'OLD_KTB_ID', OldKTBID );
        Dm_Main.ExecuteScript;

        Dm_Main.PrepareScript( 'UPDATE K2 SET K_ID1=:NEW_KTB_ID WHERE K_ID1=:OLD_KTB_ID' );
        Dm_Main.SetScriptParameterValue( 'NEW_KTB_ID', IntToStr( KTBID ) );
        Dm_Main.SetScriptParameterValue( 'OLD_KTB_ID', OldKTBID );
        Dm_Main.ExecuteScript;

        Dm_Main.PrepareScript( 'UPDATE K SET K_ID=:NEW_KTB_ID WHERE K_ID=:OLD_KTB_ID' );
        Dm_Main.SetScriptParameterValue( 'NEW_KTB_ID', IntToStr( KTBID ) );
        Dm_Main.SetScriptParameterValue( 'OLD_KTB_ID', OldKTBID );
        Dm_Main.ExecuteScript;

        Dm_Main.Commit;
    EXCEPT
        Dm_Main.Rollback;
    END;
END;

PROCEDURE TDm_Admin.GetTableFields( TableName: STRING );
BEGIN
    IF IbQ_TableField.ParamByName( 'TABLENAME' ).AsString <> TableName THEN
        IbQ_TableField.ParamByName( 'TABLENAME' ).AsString := TableName;
    IF NOT IbQ_TableField.Active THEN IbQ_TableField.Open;

    IbQ_TableField.First;
    IF IbQ_TableField.Eof THEN RAISE Exception.Create( ParamsStr( ErrNoFieldDef, TableName ) );

    IF IbQ_TablePkKey.ParamByName( 'TABLENAME' ).AsString <> TableName THEN
        IbQ_TablePkKey.ParamByName( 'TABLENAME' ).AsString := TableName;
    IF NOT IbQ_TablePkKey.Active THEN IbQ_TablePkKey.Open;

    IbQ_TablePkKey.First;
    IF IbQ_TablePkKey.Eof THEN RAISE Exception.Create( ParamsStr( ErrNoPkFieldDef, TableName ) );
END;

PROCEDURE TDm_Admin.TraceRecord( TableName: STRING; DataSet: TIB_Query );
VAR
    Statement: STRING;
    Value: STRING;
BEGIN

    GetTableFields( TableName );
    Statement := 'INSERT INTO ' + TableName + ' (';

    IF DataSet.FindField( IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString ) = NIL THEN
        RAISE Exception.Create( ParamsStr( ErrNoPkFieldFound, IbQ_TablePkKey.FieldByName( 'KFLD_NAME'
            ).AsString ) );

    WHILE NOT IbQ_TableField.Eof DO
    BEGIN
        Statement := Statement + IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString;
        Statement := Statement + ',';
        IbQ_TableField.Next;
    END;
    Statement := Copy( Statement, 1, Length( Statement ) - 1 );
    Statement := Statement + ') VALUES (';
    IbQ_TableField.First;
    WHILE NOT IbQ_TableField.Eof DO
    BEGIN
        IF IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'INTEGER' THEN
        BEGIN
            IF DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString ) <> NIL THEN
                Statement := Statement +
                    DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString ).AsString
            ELSE
                Statement := Statement + '0';
        END;

        IF IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'VARCHAR' THEN
        BEGIN
            IF DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString ) <> NIL THEN
                Statement := Statement +
                    FormateStr( 'STRSQL', DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME'
                        ).AsString ).AsString )
            ELSE
                Statement := Statement + 'null';
        END;

        IF IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'DATE' THEN
        BEGIN
            IF DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString ) <> NIL THEN
            BEGIN
                DateTimeToString( Value, 'mm/dd/yyyy', DataSet.FieldByName( IbQ_TableField.FieldByName(
                    'KFLD_NAME' ).AsString ).AsDateTime );
                Statement := Statement + FormateStr( 'STRSQL', Value );
            END
            ELSE
                Statement := Statement + FormateStr( 'STRSQL', '12/30/1899' );
        END;

        IF IbQ_TableField.FieldByName( 'KKW_NAME' ).AsString = 'FLOAT' THEN
        BEGIN
            IF DataSet.FindField( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString ) <> NIL THEN
            BEGIN
                Value := ReplaceStr( DataSet.FieldByName( IbQ_TableField.FieldByName( 'KFLD_NAME' ).AsString
                    ).AsString, ',', '.', False );
                Statement := Statement + FormateStr( 'STRSQL', Value );
            END
            ELSE
                Statement := Statement + FormateStr( 'STRSQL', '0' );
        END;

        Statement := Statement + ',';
        IbQ_TableField.Next;

    END;
    Statement := Copy( Statement, 1, Length( Statement ) - 1 );
    Statement := Statement + ');';
    TxtEd_Script.Lines.Add( Statement );
END;

PROCEDURE TDm_Admin.GetStructureModule;
BEGIN
    TxtEd_Script.Lines.Clear;
    TxtEd_Script.Lines.Add( '/*-----------' );
    TxtEd_Script.Lines.Add( 'STANDARDS ALGOL' );
    TxtEd_Script.Lines.Add( 'STRUCTURE DE BASE DE DONNEES' );
    TxtEd_Script.Lines.Add( 'NOM DU MODULE     : ' + IbQ_Module.FieldByName( 'KKW_NAME' ).AsString );
    TxtEd_Script.Lines.Add( 'DATE              : ' + DateToStr( Now ) );
    TxtEd_Script.Lines.Add( '-----------*/' );

 //Module
    TraceRecord( 'KKW', IbQ_Module );
    TraceRecord( 'K', IbQ_Module );
    TraceRecord( 'K2', IbQ_Module );

 // Tables
    IbQ_Table.First;
    WHILE NOT IbQ_Table.eof DO
    BEGIN
        TraceRecord( 'KTB', IbQ_Table );
        TraceRecord( 'K', IbQ_Table );

    // Champs
        IbQ_Field.First;
        IbQ_Field2.Close;
        IbQ_Field2.Open;
        IbQ_Field2.First;
        WHILE NOT IbQ_Field.eof DO
        BEGIN
            TraceRecord( 'KFLD', IbQ_Field );
            TraceRecord( 'K', IbQ_Field );
            TraceRecord( 'K2', IbQ_Field2 );
            TraceRecord( 'K', IbQ_Field2 );
            IbQ_Field.Next;
            IbQ_Field2.Next;
        END;
        IbQ_Field2.Close;

        IbQ_Table.Next;
    END;

    TxtEd_Script.Lines.Add( '' );
    TxtEd_Script.Lines.Add( 'COMMIT WORK;' );
    TxtEd_Script.Lines.Add( '' );

    TxtEd_Script.Text := TxtEd_Script.Lines.Text;
    TxtEd_Script.Execute;
END;

PROCEDURE TDm_Admin.GetStructureTable;
VAR
    AStrings: TStrings;
    i: integer;

BEGIN
    AStrings := NIL;

    TxtEd_Script.Lines.Clear;
    TxtEd_Script.Lines.Add( '/*-----------' );
    TxtEd_Script.Lines.Add( 'STANDARDS ALGOL' );
    TxtEd_Script.Lines.Add( 'STRUCTURE DE BASE DE DONNEES' );
    TxtEd_Script.Lines.Add( 'NOM DU MODULE     : ' + IbQ_Module.FieldByName( 'KKW_NAME' ).AsString );
    TxtEd_Script.Lines.Add( 'DATE              : ' + DateToStr( Now ) );
    TxtEd_Script.Lines.Add( '-----------*/' );
    TxtEd_Script.Lines.Add( '' );

    TRY
        AStrings := TStringList.Create;
        IbQ_Table.SelectedBookmarks( AStrings );
        FOR i := 0 TO AStrings.Count - 1 DO
        BEGIN
            IbQ_Table.Bookmark := AStrings[ i ];

        // Tables
            TraceRecord( 'KTB', IbQ_Table );
            TraceRecord( 'K', IbQ_Table );

        // Champs
            IbQ_Field.First;
            IbQ_Field2.Close;
            IbQ_Field2.Open;
            IbQ_Field2.First;
            WHILE NOT IbQ_Field.eof DO
            BEGIN
                TraceRecord( 'KFLD', IbQ_Field );
                TraceRecord( 'K', IbQ_Field );
                TraceRecord( 'K2', IbQ_Field2 );
                TraceRecord( 'K', IbQ_Field2 );
                IbQ_Field.Next;
                IbQ_Field2.Next;
            END;
            IbQ_Field2.Close;
        END;
    FINALLY
        AStrings.free;
    END;

    TxtEd_Script.Lines.Add( '' );
    TxtEd_Script.Lines.Add( 'COMMIT WORK;' );
    TxtEd_Script.Lines.Add( '' );

    TxtEd_Script.Text := TxtEd_Script.Lines.Text;
    TxtEd_Script.Execute;
END;

PROCEDURE TDm_Admin.GetNullValues;
BEGIN
    TxtEd_Script.Lines.Clear;
    TxtEd_Script.Lines.Add( '/*-----------' );
    TxtEd_Script.Lines.Add( 'STANDARDS ALGOL' );
    TxtEd_Script.Lines.Add( 'VALEURS NULLES DE BASE DE DONNEES' );
    TxtEd_Script.Lines.Add( 'NOM DU MODULE     : ' + IbQ_Module.FieldByName( 'KKW_NAME' ).AsString );
    TxtEd_Script.Lines.Add( 'DATE              : ' + DateToStr( Now ) );
    TxtEd_Script.Lines.Add( '-----------*/' );

 // Tables
    IbQ_Table.First;
    WHILE NOT IbQ_Table.eof DO
    BEGIN
        IbQ_NoSQL.Close;
        GetTableFields( IbQ_Table.FieldByName( 'KTB_NAME' ).AsString );
        IbQ_NoSQL.SQL.Clear;
        IbQ_NoSQL.SQL.Add( 'Select * from ' + IbQ_Table.FieldByName( 'KTB_NAME' ).AsString +
            ' where ' + IbQ_TablePkKey.FieldByName( 'KFLD_NAME' ).AsString +
            ' <=0' );
        IbQ_NoSQL.Open;
        IF NOT IbQ_NoSQL.Eof THEN
            TraceRecord( IbQ_Table.FieldByName( 'KTB_NAME' ).AsString, IbQ_NoSQL );
        IbQ_Table.Next;
    END;

    TxtEd_Script.Lines.Add( '' );
    TxtEd_Script.Lines.Add( 'COMMIT WORK;' );
    TxtEd_Script.Lines.Add( '' );

    TxtEd_Script.Text := TxtEd_Script.Lines.Text;
    TxtEd_Script.Execute;
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TDm_Admin.DataModuleCreate( Sender: TObject );
BEGIN
    Dm_Main.SetVersionSys( 500000001 );
    Dm_Main.SetNewGeneratorKey( 'PROC_NEWSYSKEY' );
    KTBID_Count := 1;
    IbQ_Module.Open;
    IbQ_Table.Open;
    IbQ_Field.Open;

    IbQ_FieldType.Open;
    IbQ_FieldType.Insert;
    IbQ_FieldType.FieldByName( 'KKW_ID' ).AsInteger := 0;
    IbQ_FieldType.Post;
    IbQ_FieldType.KeySource := Ids_Field;

    IbQ_FieldRef.Open;
    IbQ_FieldRef.Insert;
    IbQ_FieldRef.FieldByName( 'KFLD_ID' ).AsInteger := 0;
    IbQ_FieldRef.Post;
    IbQ_FieldRef.KeySource := Ids_Field;
END;

PROCEDURE TDm_Admin.DataModuleDestroy( Sender: TObject );
BEGIN
    IbQ_Module.Close;
    IbQ_Table.Close;
    IbQ_Field.Close;
    IbQ_FieldType.Close;
    IbQ_FieldRef.Close;

END;

PROCEDURE TDm_Admin.IbQ_ModuleUpdateRecord( DataSet: TComponent;
    UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction );
BEGIN
    Dm_Main.IB_UpdateRecord( 'KKW', IbQ_Module, UpdateKind, UpdateAction );
    Dm_Main.IB_UpdateRecord( 'K2', IbQ_Module, UpdateKind, UpdateAction );
END;

PROCEDURE TDm_Admin.IbQ_ModuleNewRecord( IB_Dataset: TIB_Dataset );
BEGIN
    IF NOT Dm_Main.IB_MajPkKey( IbQ_Module, 'KKW_ID' ) THEN abort;
    IF NOT Dm_Main.IB_MajPkKey( IbQ_Module, 'K2_ID' ) THEN abort;
    IbQ_Module.FieldByName( 'K_ID2' ).AsInteger := IbQ_Module.FieldByName( 'KKW_ID' ).AsInteger;
    IbQ_Module.FieldByName( 'K_ID1' ).AsInteger := -13202;
    IbQ_Module.FieldByName( 'K2KND_ID' ).AsInteger := -2001;
END;

PROCEDURE TDm_Admin.IbQ_TableNewRecord( IB_Dataset: TIB_Dataset );
BEGIN
    IbQ_Table.FieldByName( 'KTB_ID' ).AsString := GetNewKTBID( REPL_UPDOWN );
    IbQ_Table.FieldByName( 'KTB_SORT' ).AsFloat := 10;
    IbQ_Table.FieldByName( 'KTBKND_ID' ).AsInteger := 0;
END;

PROCEDURE TDm_Admin.IbQ_TableUpdateRecord( DataSet: TComponent;
    UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction );
BEGIN
    Dm_Main.IB_UpdateRecord( 'KTB', IbQ_Table, UpdateKind, UpdateAction );
END;

PROCEDURE TDm_Admin.IbQ_FieldNewRecord( IB_Dataset: TIB_Dataset );
BEGIN
    IF NOT Dm_Main.IB_MajPkKey( IbQ_Field, 'KFLD_ID' ) THEN abort;
    IF NOT Dm_Main.IB_MajPkKey( IbQ_Field, 'K2_ID' ) THEN abort;
    IbQ_Field.FieldByName( 'KFLD_PK' ).AsInteger := 0;
    IbQ_Field.FieldByName( 'KFLDKND_ID' ).AsInteger := 0;
    IbQ_Field.FieldByName( 'K_ID2' ).AsInteger := IbQ_Field.FieldByName( 'KFLD_ID' ).AsInteger;
    IbQ_Field.FieldByName( 'K2KND_ID' ).AsInteger := -2144;
END;

PROCEDURE TDm_Admin.IbQ_FieldUpdateRecord( DataSet: TComponent;
    UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction );
BEGIN
    Dm_Main.IB_UpdateRecord( 'KFLD', IbQ_Field, UpdateKind, UpdateAction );
    Dm_Main.IB_UpdateRecord( 'K2', IbQ_Field, UpdateKind, UpdateAction );
END;

PROCEDURE TDm_Admin.IbQ_TableBeforeDelete( IB_Dataset: TIB_Dataset );
BEGIN
    IbC_ChkExistField.ParamByName( 'KTB_ID' ).AsInteger := IbQ_Table.FieldByName( 'KTB_ID' ).AsInteger;
    IbC_ChkExistField.Open;
    IF NOT IbC_ChkExistField.Eof THEN
    BEGIN
        IF Ibq_Field.IsEmpty THEN
            INFMess( 'Avant de supprimer une table...    ' + #13 + #10 +
                '   il est indispensable d''avoir enregistré la suppression de ses champs.     ', '' )
        ELSE
            ErrMess( 'Impossible de supprimer une table ayant des champs définis   ', '' );
        abort;
    END;
    IbC_ChkExistField.Close;
END;

PROCEDURE TDm_Admin.IbQ_ModuleBeforeDelete( IB_Dataset: TIB_Dataset );
BEGIN
    IF NOT Dm_Main.CheckAllowdelete( 'KKW', IbQ_Module.FieldByName( 'KKW_ID' ).AsString, False ) THEN
    BEGIN
        IF Ibq_Table.IsEmpty THEN
            INFMess( 'Avant de supprimer un module...    ' + #13 + #10 +
                '   il est indispensable d''avoir enregistré la suppression de ses tables.     ', '' )
        ELSE
            ErrMess( 'Impossible de supprimer un module ayant des tables référencées    ', '' );
        abort;
    END;
END;

PROCEDURE TDm_Admin.IbQ_FieldAfterPost( IB_Dataset: TIB_Dataset );
VAR
    Data: TStrings;
    Modified: Boolean;
    i: integer;
BEGIN
    Data := NIL;
    TRY
        Modified := False;
        Data := TStringList.Create;
        Data.CommaText := IbQ_Table.FieldByName( 'KTB_DATA' ).AsString;
        IF ( IbQ_Field.FieldByName( 'KFLD_PK' ).AsInteger <> 0 ) OR
            ( IbQ_Field.FieldByName( 'KFLD_FK' ).AsInteger <> 0 ) THEN
        BEGIN
            IF Data.IndexOf( IbQ_Field.FieldByName( 'KFLD_NAME' ).AsString ) = -1 THEN
            BEGIN
                Data.Add( IbQ_Field.FieldByName( 'KFLD_NAME' ).AsString );
                Modified := True;
            END;
        END
        ELSE
        BEGIN
            i := Data.IndexOf( IbQ_Field.FieldByName( 'KFLD_NAME' ).AsString );
            IF i <> -1 THEN
            BEGIN
                Data.Delete( i );
                Modified := True;
            END;
        END;
        IF Modified THEN
        BEGIN
            IF IbQ_Table.State = dssBrowse THEN IbQ_Table.Edit;
            IbQ_Table.FieldByName( 'KTB_DATA' ).AsString := Data.CommaText;
            IbQ_Table.Post;
        END;
    FINALLY
        Data.Free;
    END;

END;

PROCEDURE TDm_Admin.IbQ_FieldRefUpdateRecord( DataSet: TComponent;
    UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction );
BEGIN
    UpdateAction := uacApplied;
END;

PROCEDURE TDm_Admin.IbQ_FieldRefAfterPost( IB_Dataset: TIB_Dataset );
BEGIN
    Dm_Main.IB_UpDateCache( IbQ_FieldRef );
END;

PROCEDURE TDm_Admin.IbQ_FieldTypeUpdateRecord( DataSet: TComponent;
    UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction );
BEGIN
    UpdateAction := uacApplied;
END;

PROCEDURE TDm_Admin.IbQ_FieldTypeAfterPost( IB_Dataset: TIB_Dataset );
BEGIN
    Dm_Main.IB_UpDateCache( IbQ_FieldType );
END;

PROCEDURE TDm_Admin.IbQ_TableCalculateField( Sender: TIB_Statement;
    ARow: TIB_Row; AField: TIB_Column );
BEGIN
    WITH AField DO
        IF FieldName = 'REPLICATION_TYPE' THEN
            AsString := GetReplLibelle( ARow.ByName( 'KTB_ID' ).AsInteger );
END;

END.

