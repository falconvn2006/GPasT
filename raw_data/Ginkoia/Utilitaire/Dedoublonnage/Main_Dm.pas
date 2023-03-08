//------------------------------------------------------------------------------
// Nom de l'unité : Main_Dm
// Rôle           : Gestion des accés à une base de donnée Interbase
// Auteur         : Sylvain GHEROLD
// Historique     :
// 15/05/2001 - Hervé Pulluard  - v 5.0.2 : Gestion des Sur-transactions
// 13/03/2001 - Sylvain GHEROLD - v 5.0.1 : Modif condition AllowEdit/AllowDelete
// 07/03/2001 - Hervé Pulluard  - v 5.0.0 : Chemin de la base dans INI Prgm
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
//

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
    IBODataset,
   // StrHlder,
    rxStrHlder,
    Variants;
TYPE
    TGestion_K_Version = (tKNone, tKV32, tKV64);

    TDm_Main = CLASS(TDataModule)
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
        IbT_Lk: TIB_Transaction;
        IbT_MajLk: TIB_Transaction;
        IbC_InsertKLK: TIB_Cursor;
        IbC_UpdateKLK: TIB_Cursor;
        IbC_DeleteKLK: TIB_Cursor;
        IbC_MajCuLK: TIB_Cursor;
        IbC_ScriptLk: TIB_Cursor;
        Str_Base: TStrHolder;
        Str_NomBases: TStrHolder;
        Str_Postes: TStrHolder;
        Str_Mags: TStrHolder;
    IBQ_Next_VERSION_ID: TIBOQuery;
        PROCEDURE DataModuleDestroy(Sender: TObject);
        PROCEDURE IbC_MajCuError(Sender: TObject; CONST ERRCODE: Integer;
            ErrorMessage, ErrorCodes: TStringList; CONST SQLCODE: Integer;
            SQLMessage, SQL: TStringList; VAR RaiseException: Boolean);

    PRIVATE
        FVideCache: Boolean;
        FVersionSys: integer;
        FKActive: Boolean;
        FTransactionCount: Integer;
        FTransactionCountLk: Integer;
        FGestion_K_VERSION : TGestion_K_Version;

        PROCEDURE Initialize;
        PROCEDURE GetTableFields(TableName: STRING);

        PROCEDURE IBOCacheUpdateI(TableName: STRING; DataSet: TIBODataSet);
        PROCEDURE IBOCacheUpdateU(TableName: STRING; DataSet: TIBODataSet);
        PROCEDURE IBOCacheUpdateD(TableName: STRING; DataSet: TIBODataSet);

        PROCEDURE IB_CacheUpdateI(TableName: STRING; DataSet: TIB_BDataSet);
        PROCEDURE IB_CacheUpdateU(TableName: STRING; DataSet: TIB_BDataSet);
        PROCEDURE IB_CacheUpdateD(TableName: STRING; DataSet: TIB_BDataSet);

        PROCEDURE InsertK(K_ID, KTB_ID, KRH_ID, KSE_Owner, KSE_Insert: STRING);
        PROCEDURE UpdateK(K_ID, KSE_Update: STRING);
        PROCEDURE DeleteK(K_ID, KSE_Delete: STRING);

        PROCEDURE InsertKLk(K_ID, KTB_ID, KRH_ID, KSE_Owner, KSE_Insert: STRING);
        PROCEDURE UpdateKLk(K_ID, KSE_Update: STRING);
        PROCEDURE DeleteKLk(K_ID, KSE_Delete: STRING);

        PROCEDURE ErrorGestionnaire(Sender: TObject; E: Exception);
        procedure Check_Mode_K_VERSION;
        function GetGestion_K_VERSION: TGestion_K_Version;
    function Get_Next_Version_ID: string;
    PUBLIC

        CONSTRUCTOR Create(AOwner: TComponent); OVERRIDE;
        PROCEDURE StartTransaction;
        PROCEDURE StartTransactionLk;
        PROCEDURE StartSurTransaction;
        PROCEDURE Commit;
        PROCEDURE CommitLk;
        PROCEDURE CommitUSER;
        PROCEDURE Rollback;
        PROCEDURE RollbackLk;
        PROCEDURE RollbackUser;
        PROCEDURE ControlCache(DataSet: TIBODataSet);

        FUNCTION GenID: STRING;
        FUNCTION GenVersion: STRING;

        FUNCTION IBOMajPkKey(DataSet: TIBODataSet; LeChamp: STRING): Boolean;
        FUNCTION IBOUpdPending(DataSet: TIBODataSet): boolean;
        PROCEDURE IBOCancelCache(DataSet: TIBOQuery);
        PROCEDURE IBOCommitCache(DataSet: TIBOQuery);
        PROCEDURE IBOUpDateCache(DataSet: TIBOQuery);

        FUNCTION IB_MajPkKey(DataSet: TIB_BDataSet; LeChamp: STRING): Boolean;
        FUNCTION IB_UpdPending(DataSet: TIB_BDataSet): Boolean;
        PROCEDURE IB_CancelCache(DataSet: TIB_BDataSet);
        PROCEDURE IB_CommitCache(DataSet: TIB_BDataSet);
        PROCEDURE IB_UpDateCache(DataSet: TIB_BDataSet);

        PROCEDURE IBOUpdateRecord(TableName: STRING; DataSet: TIBODataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);

//        PROCEDURE IB_UpdateRecord(TableName: STRING; DataSet: TIB_BDataSet;
//            UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction);

        PROCEDURE SetVersionSys(Version: Integer);
        PROCEDURE DesableKManagement;
        FUNCTION IsKManagementActive: Boolean;

        PROCEDURE SetNewGeneratorKey(ProcName: STRING);
        PROCEDURE SetNewGeneratorVerKey(ProcName: STRING);

        PROCEDURE ShowMonitor;

        PROCEDURE PrepareScript(SQL: STRING);
        PROCEDURE PrepareScriptLk(SQL: STRING);
        // obsolete
        {PROCEDURE PrepareScriptMultiKUpDate(SQL: STRING);
        PROCEDURE PrepareScriptMultiKUpDateLk(SQL: STRING);
        PROCEDURE PrepareScriptMultiKDelete(SQL: STRING);
        PROCEDURE PrepareScriptMultiKDeleteLk(SQL: STRING);}

        PROCEDURE SetScriptParameterValue(ParamName, ParamValue: STRING);
        PROCEDURE SetScriptParameterValueLk(ParamName, ParamValue: STRING);
        PROCEDURE ExecuteScript;
        PROCEDURE ExecuteScriptLk;
        PROCEDURE ExecuteInsertK(TableName, KeyValue: STRING);
        PROCEDURE ExecuteInsertKLk(TableName, KeyValue: STRING);

        FUNCTION CheckAllowDelete(TableName, KeyValue: STRING;
            ShowErrorMessage: Boolean): Boolean;
        FUNCTION CheckAllowEdit(TableName, KeyValue: STRING;
            ShowErrorMessage: Boolean): boolean;

        FUNCTION TransactionUpdPending: boolean;
        FUNCTION TransactionUpdPendingLk: boolean;

        FUNCTION CheckOneIntegrity(LkUpTableName, LkPkFieldName, LkUpFieldName,
            KeyValue: STRING; ShowErrorMessage: Boolean): Boolean;

        property Gestion_K_VERSION: TGestion_K_Version read GetGestion_K_VERSION;
    END;

VAR
    Dm_Main: TDm_Main;

IMPLEMENTATION

USES
    ConstStd,
    StdUtils,
    ChxBase_Frm;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

CONSTRUCTOR TDm_Main.Create(AOwner: TComponent);
BEGIN
    INHERITED;
    Application.OnException := ErrorGestionnaire;
    Initialize;
END;

PROCEDURE TDm_Main.Initialize;
VAR
    def, ch, UserName, PassWord: STRING;
    ActiveBase, i, DialectSQL: Integer;
    flagKit: Boolean;
BEGIN
    FTransactionCount := 0;
    FTransactionCountLk := 0;
    FlagKit := False;

    str_base.clear;
    str_NomBases.Clear;
    str_mags.clear;

    WITH StdConst DO
    BEGIN
        ch := UpperCase(iniCtrl.readString('DATABASE', 'PATH', ''));
        IF trim(ch) <> '' THEN
        BEGIN
            str_base.strings.add(ch);
            ch := UpperCase(iniCtrl.readString('NOMBASES', 'ITEM', ch));
            IF trim(ch) <> '' THEN str_Nombases.strings.add(ch);
            ch := UpperCase(iniCtrl.readString('NOMPOSTE', 'POSTE', ''));
            IF trim(ch) <> '' THEN str_Postes.strings.add(ch);
            ch := UpperCase(iniCtrl.readString('NOMMAGS', 'MAG', ''));
            IF trim(ch) <> '' THEN str_Mags.strings.add(ch);
        END;

        FOR i := 0 TO 9 DO
        BEGIN
            ch := UpperCase(iniCtrl.readString('DATABASE', 'PATH' + intToStr(i), ''));
            IF trim(ch) <> '' THEN
            BEGIN
                str_base.strings.add(ch);

                // par défaut ch contient encore ici le path base
                ch := UpperCase(iniCtrl.readString('NOMBASES', 'ITEM' + intToStr(i), ch));
                str_NomBases.Strings.add(ch);

                ch := UpperCase(iniCtrl.readString('NOMPOSTE', 'POSTE' + intToStr(i), ''));
                str_Postes.strings.add(ch);

                ch := UpperCase(iniCtrl.readString('NOMMAGS', 'MAG' + intToStr(i), ''));
                str_Mags.strings.add(ch);
            END;
        END;

        UserName := iniCtrl.readString('DATABASE', 'USERNAME', 'ginkoia');
        PassWord := iniCtrl.readString('DATABASE', 'PASSWORD', 'ginkoia');
        DialectSQL := iniCtrl.ReadInteger('DATABASE', 'DIALECTSQL', 3);
        ActiveBase := iniCtrl.ReadInteger('DATABASE', 'ACTIVEBASE', 0);

        IF (str_Base.Strings.count = 0) OR
            (UserName = '') OR
            (PassWord = '') THEN
        BEGIN
            ERRMess(ErrLectINI, '');
            tag := 1;
            Application.Terminate;
        END;

        CASE str_base.strings.count OF
            1:
                BEGIN
                    PathBase := str_base.strings[0];
                    NomPoste := str_Postes.Strings[0];
                    NomDuMag := str_Mags.Strings[0];
                END;
        ELSE
            BEGIN
                i := ChoixBase(Str_NomBases.Strings, ActiveBase);
                IF i = -1 THEN
                BEGIN
                    FlagKit := True;
                END
                ELSE
                BEGIN
                    PathBase := str_Base.Strings[i];
                    NomPoste := str_Postes.Strings[i];
                    NomDuMag := str_Mags.Strings[i];
                END;
            END;
        END; // du case
    END;

    IF NOT flagKit THEN
    BEGIN
        TRY
          // Paramétrage de la database
            Database.Database := StdConst.PathBase;
            Database.Params.Values['USER NAME'] := UserName;
            Database.Params.Values['PASSWORD'] := PassWord;
            Database.SQLDialect := DialectSQL;

          // Ouverture de la database et de la transaction principale
            Database.Connected := True;

          // Désactivation du mode Système
            SetVersionSys(0);
          // Active le fonctionnement de K
            FKActive := True;
        EXCEPT
            ERRMess(ErrConnect, '');
            tag := 1;
            Application.Terminate;
        END;
    END
    ELSE BEGIN
        tag := 1;
        Application.Terminate;
    END;

END;

// GESTIONNAIRE D'EXCEPTIONS

PROCEDURE TDm_Main.ErrorGestionnaire(Sender: TObject; E: Exception);
BEGIN
    ERRMess(E.message, '');
END;

// GESTION DES TRANSACTIONS

PROCEDURE TDm_Main.StartTransaction;
BEGIN
    IF FTransactionCount = 0 THEN
    BEGIN
        IbT_Maj.StartTransaction;
    END;
    Inc(FTransactionCount);
END;

PROCEDURE TDm_Main.StartTransactionLK;
BEGIN
    IF FTransactionCountLk = 0 THEN
    BEGIN
        IbT_MajLk.StartTransaction;
    END;
    Inc(FTransactionCountLk);
END;

PROCEDURE TDm_Main.StartSurTransaction;
BEGIN
    IF FTransactionCount <> 0 THEN Exit;
    // --------- > y'a que ça de plus à une transac classique
    IF FTransactionCount = 0 THEN
    BEGIN
        IbT_Maj.StartTransaction;
    END;
    Inc(FTransactionCount);

{ Hervé's Comment :
  Dans notre modus oprendi de modules comme gestion des tailles et des couleurs
  l'utilisateur peut appeler plusieurs fois ces modules dans la même session
  de travail sur une fiche ( c'est à dire avabt d'avoir validé ou abandonné )
  Le principe c'est de n'ouvrir qu'une seule "sur-transaction".
  Deux solutions :
  1. On agit dans le module maître au moment de la mise en édition ou de l'insertion
     mais dans ce cas on a toujours une surtransaction ouverte
  2. On agit dans les modules enfants auquel cas la surtransaction ne doit être
     ouverte qu'une seule fois.
     Je préfère cette méthode car elle permet de garder la gestion des transactions
     toujours au même endroit à savoir la gestion du cache.
  C'est l'objet de cette procédure qu'y n'ouvre une transaction que si le compteur
  est à 0 ce qui correspond bien à la sur-transaction de départ !
  Cette façon de faire permet en plus de ne rien changer d'autre au code habituel
  de la gestion de nos procédures de mise à jour de cache...
}
END;

PROCEDURE TDm_Main.ControlCache(DataSet: TIBODataSet);
BEGIN
    IF Dataset.IB_Transaction = Ibt_Select THEN
    BEGIN
        IF FTransactionCount = 0 THEN
            IF Dataset.UpdatesPending THEN Dataset.CancelUpdates;
    END;
    IF Dataset.IB_Transaction = Ibt_Lk THEN
    BEGIN
        IF FTransactionCountLk = 0 THEN
            IF Dataset.UpdatesPending THEN Dataset.CancelUpdates;
    END;

{ Hervé's Comment :
  L'avantage avec les IBO c'est que le cache n'est pas détruit même après un close
  de la query. Cela facilte énormément le travail car sinon il faudrait toujours
  avoir les requêtes ouvertes jusqu'au commit de la transaction globale.
  Avec cette manière de faire les requêtes peuvent être fermées et si on revient
  dans le module avant la validation finale l'affichage des données reflête bien
  l'état actuel désiré puisqu'il s'appuie sur justement le cache.
  Cela induit cependant un effet de bord : Puisque nos Dm par la force des choses
  ne doivent pas être détruits car sinon le cache l'est avec et on perd tout le
  bénéfice... lorsqu'on revient après mise à jour de la transaction globale
  le cache reste toujours dans l'état si l'utilisateur n'a pas changé d'article.
  Dans les cas de validation cela ne pose aucun problème c'est bien les données
  logiques mais parcontre après un cancel global du maiître si les données sur
  le serveur sont bien propres ce n'est hélas plus le cas de l'affichage.
  La solution pour concilier les deux est simple.
  Dan les modules enfant, avant l'ouverture des tables concernées par des mises à
  jour de données il suffit d'appeler cette procédure.
  Si le compteur de transaction est à 0, on est dans un contexte de nouvelle
  transaction à venir, il faut donc vider le cache. Dans tous les autres cas
  rien ne se passe et le cache est préservé
}
END;

PROCEDURE TDm_Main.Commit;
BEGIN
    Dec(FTransactionCount);
    IF FTransactionCount = 0 THEN
    BEGIN
        TRY
            IbT_Maj.Commit;
        EXCEPT
            Inc(FTransactionCount);
            RAISE Exception.Create(ErrBD); // Erreur grave !
        END;
    END
    ELSE IF FTransactionCount < 0 THEN
    BEGIN
        IbT_Maj.RollBack;
        FTransactionCount := 0;
        ERRMESS(ErrNegativeTransac, '');
         // le compteur ne doit jamais passer à 0 car sinon cela fout le
         // bordel dans toute l'application. Cela ne devrait jamais se
         // produire sauf si erreur de codage ... d'où la nécessité de ce
         // message d'erreur pour nous prévenir ...
    END;

END;

PROCEDURE TDm_Main.CommitLk;
BEGIN
    Dec(FTransactionCountLk);
    IF FTransactionCountLk = 0 THEN
    BEGIN
        TRY
            IbT_MajLk.Commit;
        EXCEPT
            Inc(FTransactionCountLk);
            RAISE Exception.Create(ErrBD); // Erreur grave !
        END;
    END
    ELSE IF FTransactionCountLk < 0 THEN
    BEGIN
        IbT_MajLk.RollBack;
        FTransactionCountLk := 0;
        ERRMESS(ErrNegativeTransac, '');
         // le compteur ne doit jamais passer à 0 car sinon cela fout le
         // bordel dans toute l'application. Cela ne devrait jamais se
         // produire sauf si erreur de codage ... d'où la nécessité de ce
         // message d'erreur pour nous prévenir ...
    END;

END;

PROCEDURE TDm_Main.Rollback;
BEGIN
    Dec(FTransactionCount);
    IF FTransactionCount = 0 THEN
    BEGIN
        TRY
            IbT_Maj.Rollback;
            ERRMess(ErrMajDB, '');
        EXCEPT
            Inc(FTransactionCount);
            RAISE Exception.Create(ErrBD); // Erreur grave !
        END;
    END
    ELSE IF FTransactionCount < 0 THEN
    BEGIN
        IbT_Maj.Rollback;
        FtransactionCount := 0;
        ERRMESS(ErrNegativeTransac, '');
         // le compteur ne doit jamais passer à 0 car sinon cela fout le
         // bordel dans toute l'application. Cela ne devrait jamais se
         // produire sauf si erreur de codage ... d'où la nécessité de ce
         // message d'erreur pour nous prévenir ...
    END;

END;

PROCEDURE TDm_Main.RollbackLk;
BEGIN
    Dec(FTransactionCountLk);
    IF FTransactionCountLk = 0 THEN
    BEGIN
        TRY
            IbT_MajLk.Rollback;
            ERRMess(ErrMajDB, '');
        EXCEPT
            Inc(FTransactionCountLk);
            RAISE Exception.Create(ErrBD); // Erreur grave !
        END;
    END
    ELSE IF FTransactionCountLk < 0 THEN
    BEGIN
        IbT_MajLk.Rollback;
        FtransactionCountLk := 0;
        ERRMESS(ErrNegativeTransac, '');
         // le compteur ne doit jamais passer à 0 car sinon cela fout le
         // bordel dans toute l'application. Cela ne devrait jamais se
         // produire sauf si erreur de codage ... d'où la nécessité de ce
         // message d'erreur pour nous prévenir ...
    END;

END;

// idem PROCEDURE TDm_Main.Rollback mais sans le message d'erreur

PROCEDURE TDm_Main.RollbackUser;
BEGIN
    IF FTransactionCount = 1 THEN
    BEGIN
        Dec(FTransactionCount);
        IF FTransactionCount = 0 THEN
        TRY
            IbT_Maj.Rollback;
        EXCEPT
            Inc(FTransactionCount);
            RAISE Exception.Create(ErrBD); // Erreur grave !
        END;
    END
    ELSE IF FTransactionCount > 1 THEN
    BEGIN
        IbT_Maj.Rollback;
        FtransactionCount := 0;
        ERRMESS(ErrToMuchTransac, '');
    END;

{ Hervé's Comment : dans le maître, lorsque sa propre mise à jour du cache
  est terminé, si sur_transaction il y a eu il faut la terminer pour que le
  serveur soit validé. Dans ce contexte il faut donc à  la fin appeler
  RollbackUser qui si une sur-transaction est active (compteur à 1)
  fait le boulot. Si aucune sur-transaction le compteur est à "0" il ne se passe
  rien.
  Si ici transaction est > 1 c'est qu'il y a un problème de code il faut le
  signaler ...
}
END;

PROCEDURE TDm_Main.CommitUSER;
BEGIN

    IF FTransactionCount = 1 THEN
    BEGIN
        Dec(FTransactionCount);
        IF FTransactionCount = 0 THEN
        TRY
            IbT_Maj.Commit;
        EXCEPT
            inc(FTransactionCount);
            RAISE Exception.Create(ErrBD); // Erreur grave !
        END;
    END
    ELSE IF FTransactionCount > 1 THEN
    BEGIN
        IbT_Maj.Rollback;
        FtransactionCount := 0;
        Inc(FTransactionCount);
        ERRMESS(ErrToMuchTransac, '');
    END;

{ Hervé's Comment : dans le maître, lorsque sa propre mise à jour du cache
  est terminé, si sur_transaction il y a eu il faut la terminer pour que le
  serveur soit validé. Dans ce contexte il faut donc à  la fin appeler
  CommitUser qui si une sur-transaction est active (compteur à 1)
  fait le boulot. Si aucune sur-transaction le compteur est à "0" il ne se passe
  rien.
  Si ici transaction est > 1 c'est qu'il y a un problème de code il faut le
  signaler ...
}

END;

// GESTION DES GENERATORS

FUNCTION TDm_Main.GenID: STRING;
BEGIN
    IbStProc_NewKey.Close;
    IbStProc_NewKey.Prepared := True;
    IbStProc_NewKey.ExecProc;
    result := IbStProc_NewKey.Fields[0].AsString;
    IbStProc_NewKey.Close;
    IbStProc_NewKey.Unprepare;
END;

FUNCTION TDm_Main.GenVersion: STRING;
BEGIN
    IbStProc_NewVerKey.Close;
    IbStProc_NewVerKey.Prepared := true;
    IbStProc_NewVerKey.ExecProc;
    result := IbStProc_NewVerKey.Fields[0].AsString;
    IbStProc_NewVerKey.Close;
    IbStProc_NewVerKey.Unprepare;
END;

FUNCTION TDm_Main.IBOMajPkKey(DataSet: TIBODataSet; LeChamp: STRING):
    Boolean;
// Alimentation de la cle primaire d'un DataSet
BEGIN
    Result := True;
    TRY
        DataSet.FieldByName(LeChamp).AsString := GenID;
    EXCEPT
        ErrMess(ErrGenId, '');
        DataSet.Cancel;
        Result := False;
    END;
END;

FUNCTION TDm_Main.IB_MajPkKey(DataSet: TIB_BDataSet; LeChamp: STRING):
    Boolean;
// Alimentation de la cle primaire d'un DataSet
BEGIN
    Result := True;
    TRY
        DataSet.FieldByName(LeChamp).AsString := GenID;
    EXCEPT
        ErrMess(ErrGenId, '');
        DataSet.Cancel;
        Result := False;
    END;
END;

// GESTION DES MISES A JOUR DU CACHE

PROCEDURE TDm_Main.IBOCancelCache(DataSet: TIBOQuery);
BEGIN
    IF DataSet.Active THEN
        DataSet.CancelUpdates;
END;

PROCEDURE TDm_Main.IBOCommitCache(DataSet: TIBOQuery);
BEGIN
    IF NOT DataSet.Active THEN Exit;

    IF Dataset.IB_Transaction = Ibt_Select THEN
    BEGIN
        IF DataSet.Active AND (FTransactionCount = 0) THEN
        BEGIN
            FVideCache := True;
            DataSet.ApplyUpdates;
            DataSet.CommitUpdates;
        END;
    END;
    IF Dataset.IB_Transaction = Ibt_Lk THEN
    BEGIN
        IF DataSet.Active AND (FTransactionCountLk = 0) THEN
        BEGIN
            FVideCache := True;
            DataSet.ApplyUpdates;
            DataSet.CommitUpdates;
        END;
    END;

END;

PROCEDURE TDm_Main.IBOUpDateCache(DataSet: TIBOQuery);
BEGIN
    IF NOT DataSet.Active THEN Exit;

    IF Dataset.IB_Transaction = Ibt_Select THEN
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
                Dm_Main.IBOCancelCache(DataSet);
                IF (FTransactionCount <> 0) THEN RAISE;
            END;
            Dm_Main.IBOCommitCache(DataSet);
        END;
    END;
    IF Dataset.IB_Transaction = Ibt_Lk THEN
    BEGIN
        IF DataSet.Active THEN
        BEGIN
            TRY
                Dm_Main.StartTransactionLk;
                FVideCache := False;
                DataSet.ApplyUpdates;
                Dm_Main.CommitLk;
            EXCEPT
                Dm_Main.RollbackLk;
                Dm_Main.IBOCancelCache(DataSet);
                IF (FTransactionCountLk <> 0) THEN RAISE;
            END;
            Dm_Main.IBOCommitCache(DataSet);
        END;
    END;

END;

procedure TDm_Main.Check_Mode_K_VERSION;
var
  QueTmp: TIBOQuery;
  vK_ENABLED: string;
  vVERSION_ID: boolean;
  vDependance_VERSION_ID: boolean;
begin
  if (FGestion_K_VERSION = TKNone) then
  begin
    vK_ENABLED := 'int32';
    vVERSION_ID := false;
    vDependance_VERSION_ID := false;
    QueTmp := TIBOQuery.Create(Self);
    try
      QueTmp.DatabaseName := Dm_Main.Database.DatabaseName;
        //----------------------------------------------
      QueTmp.close;
      QueTmp.SQL.Clear;
      QueTmp.SQL.Add('SELECT r.RDB$RELATION_NAME,  ');
      QueTmp.SQL.Add('     r.RDB$FIELD_NAME,       ');
      QueTmp.SQL.Add('     f.RDB$FIELD_TYPE,       ');
      QueTmp.SQL.Add('     f.RDB$FIELD_SUB_TYPE,   ');
      QueTmp.SQL.Add('     f.RDB$FIELD_LENGTH      ');
      QueTmp.SQL.Add(' FROM RDB$RELATION_FIELDS r  ');
      QueTmp.SQL.Add(' JOIN RDB$FIELDS f ON r.RDB$FIELD_SOURCE = f.RDB$FIELD_NAME         ');
      QueTmp.SQL.Add(' WHERE r.RDB$RELATION_NAME=''K'' AND r.RDB$FIELD_NAME=''K_VERSION'' ');
      QueTmp.open();
      if not (QueTmp.eof) then
      begin
        if QueTmp.FieldByName('RDB$FIELD_TYPE').asinteger = 16 then
          vK_ENABLED := 'int64'
        else
        begin
          FGestion_K_VERSION := TKV32;
          exit;
        end;
      end;
      QueTmp.close();

      QueTmp.close;
      QueTmp.SQL.Clear;
      QueTmp.SQL.Add('SELECT * FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME=''VERSION_ID'' ');
      QueTmp.open();
      if not (QueTmp.eof) then
        vVERSION_ID := true
      else
        exit;

      QueTmp.close;
      QueTmp.SQL.Clear;
      if (vVERSION_ID) then
      begin
        QueTmp.close;
        QueTmp.SQL.Clear;
        QueTmp.SQL.Add('SELECT * FROM RDB$DEPENDENCIES WHERE RDB$DEPENDED_ON_NAME=''VERSION_ID'' AND RDB$DEPENDENT_NAME=''PR_UPDATEK'' ');
        QueTmp.open();
        if not (QueTmp.eof) then
          vDependance_VERSION_ID := true
        else
          exit;
      end;
    
        // On peut également controler qu'il est dans sa tranche etc...
      QueTmp.close;
    finally
      if (vK_ENABLED = 'int64') and (vVERSION_ID) and (vDependance_VERSION_ID) then
        FGestion_K_VERSION := TKV64;

      QueTmp.Free;
    end;
  end;
end;

PROCEDURE TDm_Main.IB_CancelCache(DataSet: TIB_BDataSet);
BEGIN
    IF DataSet.Active THEN
        DataSet.CancelUpdates;
END;

PROCEDURE TDm_Main.IB_CommitCache(DataSet: TIB_BDataSet);
BEGIN
    IF NOT DataSet.Active THEN Exit;

    IF Dataset.IB_Transaction = Ibt_Select THEN
    BEGIN
        IF DataSet.Active AND (FTransactionCount = 0) THEN
        BEGIN
            FVideCache := True;
            DataSet.ApplyUpdates;
            DataSet.CommitUpdates;
        END;
    END;
    IF Dataset.IB_Transaction = Ibt_Lk THEN
    BEGIN
        IF DataSet.Active AND (FTransactionCountLk = 0) THEN
        BEGIN
            FVideCache := True;
            DataSet.ApplyUpdates;
            DataSet.CommitUpdates;
        END;
    END;

END;

PROCEDURE TDm_Main.IB_UpDateCache(DataSet: TIB_BDataSet);
BEGIN
    IF NOT DataSet.Active THEN Exit;

    IF Dataset.IB_Transaction = Ibt_Select THEN
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
                Dm_Main.IB_CancelCache(DataSet);
                IF (FTransactionCount <> 0) THEN RAISE;
            END;
            Dm_Main.IB_CommitCache(DataSet);
        END;
    END;
    IF Dataset.IB_Transaction = Ibt_lk THEN
    BEGIN
        IF DataSet.Active THEN
        BEGIN
            TRY
                Dm_Main.StartTransactionLk;
                FVideCache := False;
                DataSet.ApplyUpdates;
                Dm_Main.Commit;
            EXCEPT
                Dm_Main.RollbackLk;
                Dm_Main.IB_CancelCache(DataSet);
                IF (FTransactionCountLk <> 0) THEN RAISE;
            END;
            Dm_Main.IB_CommitCache(DataSet);
        END;
    END;

END;

PROCEDURE TDm_Main.IBOUpdateRecord(TableName: STRING; DataSet: TIBODataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    IF FVideCache THEN
        UpdateAction := uaApplied
    ELSE
    BEGIN
        IF UpdateKind = ukInsert THEN
        BEGIN
            IBOCacheUpdateI(TableName, DataSet);
        END;
        IF UpdateKind = ukModify THEN
        BEGIN
            IBOCacheUpdateU(TableName, DataSet);
        END;
        IF UpdateKind = ukDelete THEN
        BEGIN
            IBOCacheUpdateD(TableName, DataSet);
        END;

    END;
END;

//PROCEDURE TDm_Main.IB_UpdateRecord(TableName: STRING; DataSet: TIB_BDataSet;
//    UpdateKind: TIB_UpdateKind; VAR UpdateAction: TIB_UpdateAction);
//BEGIN
//    IF FVideCache THEN
//        UpdateAction := uacApplied
//    ELSE
//    BEGIN
//        IF UpdateKind = ukiInsert THEN
//        BEGIN
//            IB_CacheUpdateI(TableName, DataSet);
//        END;
//        IF UpdateKind = ukiModify THEN
//        BEGIN
//            IB_CacheUpdateU(TableName, DataSet);
//        END;
//        IF UpdateKind = ukiDelete THEN
//        BEGIN
//            IB_CacheUpdateD(TableName, DataSet);
//        END;
//    END;
//END;

function TDm_Main.GetGestion_K_VERSION: TGestion_K_Version;
begin
  if (FGestion_K_VERSION = TKNone) then
    Check_Mode_K_VERSION();

  Result := FGestion_K_VERSION;
end;

PROCEDURE TDm_Main.GetTableFields(TableName: STRING);
BEGIN
    IF IbQ_TableField.ParamByName('TABLENAME').AsString <> TableName THEN
        IbQ_TableField.ParamByName('TABLENAME').AsString := TableName;
    IF NOT IbQ_TableField.Active THEN IbQ_TableField.Open;

    IbQ_TableField.First;
    IF IbQ_TableField.Eof THEN
        RAISE Exception.Create(ParamsStr(ErrNoFieldDef, TableName));

    IF IbQ_TablePkKey.ParamByName('TABLENAME').AsString <> TableName THEN
        IbQ_TablePkKey.ParamByName('TABLENAME').AsString := TableName;
    IF NOT IbQ_TablePkKey.Active THEN IbQ_TablePkKey.Open;

    IbQ_TablePkKey.First;
    IF IbQ_TablePkKey.Eof THEN
        RAISE Exception.Create(ParamsStr(ErrNoPkFieldDef, TableName));
END;

PROCEDURE TDm_Main.IBOCacheUpdateI(TableName: STRING; DataSet: TIBODataSet);
BEGIN

    GetTableFields(TableName);

    IF Dataset.IB_Transaction = Ibt_Select THEN
    BEGIN

        ibc_majcu.SQL.Clear;
        ibc_majcu.SQL.Add('INSERT INTO ' + TableName + '(');

        IF DataSet.FindField(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString)
            = NIL THEN
            RAISE Exception.Create(ParamsStr(ErrNoPkFieldFound,
                IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString));

        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            ibc_majcu.SQL.Add(IbQ_TableField.FieldByName('KFLD_NAME').AsString);
            ibc_majcu.SQL.Add(',');
            IbQ_TableField.Next;
        END;
        ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ') VALUES (';
        IbQ_TableField.First;
        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            ibc_majcu.SQL.Add(':' + IbQ_TableField.FieldByName('KFLD_NAME').AsString
                );
            ibc_majcu.SQL.Add(',');
            IbQ_TableField.Next;
        END;
        ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ')';
        ibc_majcu.Prepare;

        IbQ_TableField.First;
        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'INTEGER' THEN
            BEGIN
                IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ) <> NIL) AND
                    NOT VarIsNull(DataSet.FieldByName(IbQ_TableField.FieldByName(
                    'KFLD_NAME').AsString).NewValue) THEN
                    CASE DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString).DataType OF
                        ftBoolean:
                            IF DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                ).AsString).AsBoolean THEN
                                ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                    ).AsString).AsInteger := 1
                            ELSE
                                ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                    ).AsString).AsInteger := 0;
                        ftInteger:
                            ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                ).AsString).AsInteger :=
                                DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                ).AsString).NewValue;
                    END
                ELSE
                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsInteger := 0;
            END;

            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'VARCHAR' THEN
            BEGIN
                IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ) <> NIL) AND
                    NOT VarIsNull(DataSet.FieldByName(IbQ_TableField.FieldByName(
                    'KFLD_NAME').AsString).NewValue) THEN
                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsString :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).NewValue
                ELSE
                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsString := '';
            END;

            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'DATE' THEN
            BEGIN
                IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ) <> NIL) AND
                    NOT VarIsNull(DataSet.FieldByName(IbQ_TableField.FieldByName(
                    'KFLD_NAME').AsString).NewValue) THEN
                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsDateTime :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).NewValue
//                ELSE
//                    ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
//                        ) .AsString
//                        ) .AsDateTime := 0;
            END;

            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'FLOAT' THEN
            BEGIN
                IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ) <> NIL) AND
                    NOT VarIsNull(DataSet.FieldByName(IbQ_TableField.FieldByName(
                    'KFLD_NAME').AsString).NewValue) THEN
                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsFloat :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).NewValue
                ELSE
                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsFloat := 0;
            END;

            IbQ_TableField.Next;
        END;

        IF IsKManagementActive THEN
            InsertK(DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME'
                ).AsString).NewValue,
                IbQ_TablePkKey.FieldByName('KTB_ID').AsString,
                '-101', '-1', '-1');

        ibc_majcu.Execute;
    END;

    IF Dataset.IB_Transaction = Ibt_Lk THEN
    BEGIN
        ibc_majculk.SQL.Clear;
        ibc_majculk.SQL.Add('INSERT INTO ' + TableName + '(');

        IF DataSet.FindField(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString)
            = NIL THEN
            RAISE Exception.Create(ParamsStr(ErrNoPkFieldFound,
                IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString));

        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            ibc_majcuLk.SQL.Add(IbQ_TableField.FieldByName('KFLD_NAME').AsString);
            ibc_majcuLk.SQL.Add(',');
            IbQ_TableField.Next;
        END;
        ibc_majcuLk.SQL[ibc_majcuLk.SQL.Count - 1] := ') VALUES (';
        IbQ_TableField.First;
        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            ibc_majcuLK.SQL.Add(':' + IbQ_TableField.FieldByName('KFLD_NAME').AsString
                );
            ibc_majcuLk.SQL.Add(',');
            IbQ_TableField.Next;
        END;
        ibc_majcuLk.SQL[ibc_majcuLk.SQL.Count - 1] := ')';
        ibc_majcuLk.Prepare;

        IbQ_TableField.First;
        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'INTEGER' THEN
            BEGIN
                IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ) <> NIL) AND
                    NOT VarIsNull(DataSet.FieldByName(IbQ_TableField.FieldByName(
                    'KFLD_NAME').AsString).NewValue) THEN
                    CASE DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString).DataType OF
                        ftBoolean:
                            IF DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                ).AsString).AsBoolean THEN
                                ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                    ).AsString).AsInteger := 1
                            ELSE
                                ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                    ).AsString).AsInteger := 0;
                        ftInteger:
                            ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                ).AsString).AsInteger :=
                                DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                ).AsString).NewValue;
                    END
                ELSE
                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsInteger := 0;
            END;

            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'VARCHAR' THEN
            BEGIN
                IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ) <> NIL) AND
                    NOT VarIsNull(DataSet.FieldByName(IbQ_TableField.FieldByName(
                    'KFLD_NAME').AsString).NewValue) THEN
                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsString :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).NewValue
                ELSE
                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsString := '';
            END;

            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'DATE' THEN
            BEGIN
                IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ) <> NIL) AND
                    NOT VarIsNull(DataSet.FieldByName(IbQ_TableField.FieldByName(
                    'KFLD_NAME').AsString).NewValue) THEN
                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsDateTime :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).NewValue
//                ELSE
//                    ibc_majcuLk.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
//                        ) .AsString
//                        ) .AsDateTime := 0;
            END;

            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'FLOAT' THEN
            BEGIN
                IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ) <> NIL) AND
                    NOT VarIsNull(DataSet.FieldByName(IbQ_TableField.FieldByName(
                    'KFLD_NAME').AsString).NewValue) THEN
                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsFloat :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).NewValue
                ELSE
                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsFloat := 0;
            END;

            IbQ_TableField.Next;
        END;

        IF IsKManagementActive THEN
            InsertKLk(DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME'
                ).AsString).NewValue,
                IbQ_TablePkKey.FieldByName('KTB_ID').AsString,
                '-101', '-1', '-1');

        ibc_majcuLk.Execute;
    END;

END;

PROCEDURE TDm_Main.IBOCacheUpdateU(TableName: STRING; DataSet: TIBODataSet);
VAR
    FoundModified: Boolean;
BEGIN
    FoundModified := False;
    GetTableFields(TableName);

    IF Dataset.IB_Transaction = Ibt_Select THEN
    BEGIN

        ibc_majcu.SQL.Clear;
        ibc_majcu.SQL.Add('UPDATE ' + TableName + ' SET ');

        IF DataSet.FindField(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString) =
            NIL THEN
            RAISE Exception.Create(ParamsStr(ErrNoPkFieldFound,
                IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString));

        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString)
                <> NIL) AND
                NOT VarIsNull(DataSet.FieldByName(IbQ_TableField.FieldByName(
                'KFLD_NAME'
                ).AsString).NewValue) AND
                (IbQ_TableField.FieldByName('KFLD_NAME').AsString <>
                IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString)
                AND (DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                ).AsString).OldValue <>
                DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                ).NewValue) THEN
            BEGIN
                ibc_majcu.SQL.Add(IbQ_TableField.FieldByName('KFLD_NAME').AsString +
                    ' = :' + IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    );
                ibc_majcu.SQL.Add(',');
                FoundModified := True;
            END;
            IbQ_TableField.Next;
        END;
        ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ' WHERE ' +
            IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
            + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString;

        IF FoundModified THEN
        BEGIN

            ibc_majcu.Prepare;
            IbQ_TableField.First;
            WHILE NOT IbQ_TableField.Eof DO
            BEGIN
                IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ) <> NIL) AND
                    NOT VarIsNull(DataSet.FieldByName(IbQ_TableField.FieldByName(
                    'KFLD_NAME').AsString).NewValue) AND
                    (IbQ_TableField.FieldByName('KFLD_NAME').AsString <>
                    IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString)
                    AND (DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                    ).AsString).OldValue <>
                    DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ).NewValue) THEN
                BEGIN

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'INTEGER' THEN
                    BEGIN
                        CASE DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).DataType OF
                            ftBoolean:
                                IF DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                    ).AsString).AsBoolean THEN
                                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                        ).AsString).AsInteger := 1
                                ELSE
                                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                        ).AsString).AsInteger := 0;
                            ftInteger:
                                ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                    ).AsString).AsInteger :=
                                    DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                    ).AsString).NewValue
                        END
                    END;

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'VARCHAR' THEN
                    BEGIN
                        ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsString :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).NewValue;
                    END;

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'DATE' THEN
                    BEGIN
                        ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsDateTime :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).NewValue;
                    END;

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'FLOAT' THEN
                    BEGIN
                        ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsFloat :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).NewValue;
                    END;
                END;
                IbQ_TableField.Next;
            END;

            ibc_majcu.ParamByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString :=
                DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).NewValue;

            IF IsKManagementActive THEN
                UpdateK(DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME'
                    ).AsString).NewValue,
                    '-1');

            Ibc_majcu.Execute;
        END;
    END;

    IF Dataset.IB_Transaction = Ibt_Lk THEN
    BEGIN

        ibc_majcuLk.SQL.Clear;
        ibc_majcuLk.SQL.Add('UPDATE ' + TableName + ' SET ');

        IF DataSet.FindField(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString) =
            NIL THEN
            RAISE Exception.Create(ParamsStr(ErrNoPkFieldFound,
                IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString));

        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString)
                <> NIL) AND
                NOT VarIsNull(DataSet.FieldByName(IbQ_TableField.FieldByName(
                'KFLD_NAME'
                ).AsString).NewValue) AND
                (IbQ_TableField.FieldByName('KFLD_NAME').AsString <>
                IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString)
                AND (DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                ).AsString).OldValue <>
                DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                ).NewValue) THEN
            BEGIN
                ibc_majcuLk.SQL.Add(IbQ_TableField.FieldByName('KFLD_NAME').AsString +
                    ' = :' + IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    );
                ibc_majcuLk.SQL.Add(',');
                FoundModified := True;
            END;
            IbQ_TableField.Next;
        END;
        ibc_majcuLk.SQL[ibc_majcuLk.SQL.Count - 1] := ' WHERE ' +
            IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
            + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString;

        IF FoundModified THEN
        BEGIN

            ibc_majcuLk.Prepare;
            IbQ_TableField.First;
            WHILE NOT IbQ_TableField.Eof DO
            BEGIN
                IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ) <> NIL) AND
                    NOT VarIsNull(DataSet.FieldByName(IbQ_TableField.FieldByName(
                    'KFLD_NAME').AsString).NewValue) AND
                    (IbQ_TableField.FieldByName('KFLD_NAME').AsString <>
                    IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString)
                    AND (DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                    ).AsString).OldValue <>
                    DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ).NewValue) THEN
                BEGIN

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'INTEGER' THEN
                    BEGIN
                        CASE DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).DataType OF
                            ftBoolean:
                                IF DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                    ).AsString).AsBoolean THEN
                                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                        ).AsString).AsInteger := 1
                                ELSE
                                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                        ).AsString).AsInteger := 0;
                            ftInteger:
                                ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                    ).AsString).AsInteger :=
                                    DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                                    ).AsString).NewValue
                        END
                    END;

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'VARCHAR' THEN
                    BEGIN
                        ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsString :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).NewValue;
                    END;

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'DATE' THEN
                    BEGIN
                        ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsDateTime :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).NewValue;
                    END;

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'FLOAT' THEN
                    BEGIN
                        ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsFloat :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).NewValue;
                    END;
                END;
                IbQ_TableField.Next;
            END;

            ibc_majcuLk.ParamByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString :=
                DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).NewValue;

            IF IsKManagementActive THEN
                UpdateKLk(DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME'
                    ).AsString).NewValue,
                    '-1');

            Ibc_majcuLk.Execute;
        END;
    END;

END;

PROCEDURE TDm_Main.IBOCacheUpdateD(TableName: STRING; DataSet: TIBODataSet);
BEGIN
    GetTableFields(TableName);

    IF DataSet.FindField(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString) =
        NIL THEN
        RAISE Exception.Create(ParamsStr(ErrNoPkFieldFound,
            IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString));

    IF Dataset.IB_Transaction = Ibt_Select THEN
    BEGIN

        IF NOT IsKManagementActive THEN
        BEGIN
            ibc_majcu.SQL.Clear;
            ibc_majcu.SQL.Add('DELETE FROM ' + TableName + ' WHERE '
                + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString);
            ibc_majcu.Prepare;
            ibc_majcu.ParamByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString :=
                DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).OldValue;
            ibc_majcu.Execute;
        END;

        IF IsKManagementActive THEN
        BEGIN
            DeleteK(DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME'
                ).AsString).Oldvalue,
                '-1');

            // Simulation de modification pour activation des triggers
            ibc_majcu.SQL.Clear;
            ibc_majcu.SQL.Add('UPDATE ' + TableName + ' SET '
                + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' WHERE '
                + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString);

            ibc_majcu.Prepare;
            ibc_majcu.ParamByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString :=
                DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).OldValue;
            ibc_majcu.Execute;

        END;
    END;

    IF Dataset.IB_Transaction = Ibt_Lk THEN
    BEGIN

        IF NOT IsKManagementActive THEN
        BEGIN
            ibc_majcuLk.SQL.Clear;
            ibc_majcuLk.SQL.Add('DELETE FROM ' + TableName + ' WHERE '
                + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString);
            ibc_majcuLk.Prepare;
            ibc_majcuLk.ParamByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString :=
                DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).OldValue;
            ibc_majcuLk.Execute;
        END;

        IF IsKManagementActive THEN
        BEGIN
            DeleteKLk(DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME'
                ).AsString).Oldvalue,
                '-1');

            // Simulation de modification pour activation des triggers
            ibc_majcuLk.SQL.Clear;
            ibc_majcuLk.SQL.Add('UPDATE ' + TableName + ' SET '
                + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' WHERE '
                + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString);

            ibc_majcuLk.Prepare;
            ibc_majcuLk.ParamByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString :=
                DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).OldValue;
            ibc_majcuLk.Execute;

        END;
    END;

END;

PROCEDURE TDm_Main.IB_CacheUpdateI(TableName: STRING; DataSet: TIB_BDataSet);
BEGIN

    GetTableFields(TableName);

    IF Dataset.IB_Transaction = Ibt_Select THEN
    BEGIN

        ibc_majcu.SQL.Clear;
        ibc_majcu.SQL.Add('INSERT INTO ' + TableName + '(');

        IF DataSet.FindField(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString) =
            NIL THEN
            RAISE Exception.Create(ParamsStr(ErrNoPkFieldFound,
                IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString));

        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            ibc_majcu.SQL.Add(IbQ_TableField.FieldByName('KFLD_NAME').AsString);
            ibc_majcu.SQL.Add(',');
            IbQ_TableField.Next;
        END;
        ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ') VALUES (';
        IbQ_TableField.First;
        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            ibc_majcu.SQL.Add(':' + IbQ_TableField.FieldByName('KFLD_NAME').AsString
                );
            ibc_majcu.SQL.Add(',');
            IbQ_TableField.Next;
        END;
        ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ')';
        ibc_majcu.Prepare;

        IbQ_TableField.First;
        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'INTEGER' THEN
            BEGIN
                IF DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString)
                    <> NIL THEN
                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsInteger :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsInteger
                ELSE
                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsInteger := 0;
            END;

            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'VARCHAR' THEN
            BEGIN
                IF DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString)
                    <> NIL THEN
                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsString :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsString
                ELSE
                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsString := '';
            END;

            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'DATE' THEN
            BEGIN
                IF DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString)
                    <> NIL THEN
                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsDateTime :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsDateTime
//                ELSE
//                    ibc_majcu.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
//                        ) .AsString
//                        ) .AsDateTime := 0;
            END;

            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'FLOAT' THEN
            BEGIN
                IF DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString)
                    <> NIL THEN
                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsFloat :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsFloat
                ELSE
                    ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsFloat := 0;
            END;

            IbQ_TableField.Next;
        END;

        IF IsKManagementActive THEN
            InsertK(DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME'
                ).AsString).AsString,
                IbQ_TablePkKey.FieldByName('KTB_ID').AsString,
                '-101', '-1', '-1');

        Ibc_majcu.Execute;
    END;

    IF Dataset.IB_Transaction = Ibt_Lk THEN
    BEGIN

        ibc_majcuLk.SQL.Clear;
        ibc_majcuLk.SQL.Add('INSERT INTO ' + TableName + '(');

        IF DataSet.FindField(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString) =
            NIL THEN
            RAISE Exception.Create(ParamsStr(ErrNoPkFieldFound,
                IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString));

        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            ibc_majcuLk.SQL.Add(IbQ_TableField.FieldByName('KFLD_NAME').AsString);
            ibc_majcuLk.SQL.Add(',');
            IbQ_TableField.Next;
        END;
        ibc_majcuLk.SQL[ibc_majcuLk.SQL.Count - 1] := ') VALUES (';
        IbQ_TableField.First;
        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            ibc_majcuLk.SQL.Add(':' + IbQ_TableField.FieldByName('KFLD_NAME').AsString
                );
            ibc_majcuLk.SQL.Add(',');
            IbQ_TableField.Next;
        END;
        ibc_majcuLk.SQL[ibc_majcuLk.SQL.Count - 1] := ')';
        ibc_majcuLk.Prepare;

        IbQ_TableField.First;
        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'INTEGER' THEN
            BEGIN
                IF DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString)
                    <> NIL THEN
                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsInteger :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsInteger
                ELSE
                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsInteger := 0;
            END;

            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'VARCHAR' THEN
            BEGIN
                IF DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString)
                    <> NIL THEN
                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsString :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsString
                ELSE
                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsString := '';
            END;

            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'DATE' THEN
            BEGIN
                IF DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString)
                    <> NIL THEN
                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsDateTime :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsDateTime
//                ELSE
//                    ibc_majcuLk.ParamByName ( IbQ_TableField.FieldByName ( 'KFLD_NAME'
//                        ) .AsString
//                        ) .AsDateTime := 0;
            END;

            IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'FLOAT' THEN
            BEGIN
                IF DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString)
                    <> NIL THEN
                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsFloat :=
                        DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsFloat
                ELSE
                    ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                        ).AsString
                        ).AsFloat := 0;
            END;

            IbQ_TableField.Next;
        END;

        IF IsKManagementActive THEN
            InsertKLk(DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME'
                ).AsString).AsString,
                IbQ_TablePkKey.FieldByName('KTB_ID').AsString,
                '-101', '-1', '-1');

        Ibc_majcuLk.Execute;
    END;

END;

PROCEDURE TDm_Main.IB_CacheUpdateU(TableName: STRING; DataSet: TIB_BDataSet);
VAR
    FoundModified: Boolean;
BEGIN
    FoundModified := False;
    GetTableFields(TableName);

    IF Dataset.IB_Transaction = Ibt_Select THEN
    BEGIN

        ibc_majcu.SQL.Clear;
        ibc_majcu.SQL.Add('UPDATE ' + TableName + ' SET ');

        IF DataSet.FindField(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString) =
            NIL THEN
            RAISE Exception.Create(ParamsStr(ErrNoPkFieldFound,
                IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString));

        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString)
                <> NIL) AND
                (IbQ_TableField.FieldByName('KFLD_NAME').AsString <>
                IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString) AND
                (DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                ).AsString <>
                DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                ).OldAsString) THEN
            BEGIN
                ibc_majcu.SQL.Add(IbQ_TableField.FieldByName('KFLD_NAME').AsString +
                    ' = :' + IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    );
                ibc_majcu.SQL.Add(',');
                FoundModified := True;
            END;
            IbQ_TableField.Next;
        END;
        ibc_majcu.SQL[ibc_majcu.SQL.Count - 1] := ' WHERE ' +
            IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
            + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString;

        IF FoundModified THEN
        BEGIN

            ibc_majcu.Prepare;
            IbQ_TableField.First;
            WHILE NOT IbQ_TableField.Eof DO
            BEGIN
                IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ) <> NIL) AND
                    (IbQ_TableField.FieldByName('KFLD_NAME').AsString <>
                    IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString) AND
                    (DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                    ).AsString
                    ).AsString <>
                    DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ).OldAsString) THEN
                BEGIN

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'INTEGER' THEN
                    BEGIN
                        ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsInteger :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsInteger
                    END;

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'VARCHAR' THEN
                    BEGIN
                        ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsString :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsString;
                    END;

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'DATE' THEN
                    BEGIN
                        ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsDateTime :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsDateTime;
                    END;

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'FLOAT' THEN
                    BEGIN
                        ibc_majcu.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsFloat :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsFloat;
                    END;
                END;
                IbQ_TableField.Next;
            END;

            ibc_majcu.ParamByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString :=
                DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString;

            IF IsKManagementActive THEN
                UpdateK(DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME'
                    ).AsString).AsString,
                    '-1');

            Ibc_majcu.Execute;

        END;
    END;

    IF Dataset.IB_Transaction = Ibt_Lk THEN
    BEGIN

        ibc_majcuLk.SQL.Clear;
        ibc_majcuLk.SQL.Add('UPDATE ' + TableName + ' SET ');

        IF DataSet.FindField(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString) =
            NIL THEN
            RAISE Exception.Create(ParamsStr(ErrNoPkFieldFound,
                IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString));

        WHILE NOT IbQ_TableField.Eof DO
        BEGIN
            IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString)
                <> NIL) AND
                (IbQ_TableField.FieldByName('KFLD_NAME').AsString <>
                IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString) AND
                (DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                ).AsString <>
                DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                ).OldAsString) THEN
            BEGIN
                ibc_majcuLk.SQL.Add(IbQ_TableField.FieldByName('KFLD_NAME').AsString +
                    ' = :' + IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    );
                ibc_majcuLk.SQL.Add(',');
                FoundModified := True;
            END;
            IbQ_TableField.Next;
        END;
        ibc_majcuLk.SQL[ibc_majcuLk.SQL.Count - 1] := ' WHERE ' +
            IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
            + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString;

        IF FoundModified THEN
        BEGIN

            ibc_majcuLk.Prepare;
            IbQ_TableField.First;
            WHILE NOT IbQ_TableField.Eof DO
            BEGIN
                IF (DataSet.FindField(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ) <> NIL) AND
                    (IbQ_TableField.FieldByName('KFLD_NAME').AsString <>
                    IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString) AND
                    (DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                    ).AsString
                    ).AsString <>
                    DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME').AsString
                    ).OldAsString) THEN
                BEGIN

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'INTEGER' THEN
                    BEGIN
                        ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsInteger :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsInteger
                    END;

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'VARCHAR' THEN
                    BEGIN
                        ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsString :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsString;
                    END;

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'DATE' THEN
                    BEGIN
                        ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsDateTime :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsDateTime;
                    END;

                    IF IbQ_TableField.FieldByName('KKW_NAME').AsString = 'FLOAT' THEN
                    BEGIN
                        ibc_majcuLk.ParamByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsFloat :=
                            DataSet.FieldByName(IbQ_TableField.FieldByName('KFLD_NAME'
                            ).AsString).AsFloat;
                    END;
                END;
                IbQ_TableField.Next;
            END;

            ibc_majcuLk.ParamByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString :=
                DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString;

            IF IsKManagementActive THEN
                UpdateKLk(DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME'
                    ).AsString).AsString,
                    '-1');

            Ibc_majcuLk.Execute;

        END;
    END;

END;

PROCEDURE TDm_Main.IB_CacheUpdateD(TableName: STRING; DataSet: TIB_BDataSet);
BEGIN
    GetTableFields(TableName);
    IF IbQ_TablePkKey.Eof THEN
        RAISE Exception.Create(ParamsStr(ErrNoPkFieldDef, TableName));

    IF DataSet.FindField(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString) =
        NIL THEN
        RAISE Exception.Create(ParamsStr(ErrNoPkFieldFound,
            IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString));

    IF Dataset.IB_Transaction = Ibt_Select THEN
    BEGIN

        IF NOT IsKManagementActive THEN
        BEGIN
            ibc_majcu.SQL.Clear;
            ibc_majcu.SQL.Add('DELETE FROM ' + TableName + ' WHERE '
                + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString);
            ibc_majcu.Prepare;
            ibc_majcu.ParamByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString :=
                DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).OldAsString;
            ibc_majcu.Execute;
        END;

        IF IsKManagementActive THEN
        BEGIN
            DeleteK(DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME'
                ).AsString).OldAsString,
                '-1');

            // Simulation de modification pour activation des triggers
            ibc_majcu.SQL.Clear;
            ibc_majcu.SQL.Add('UPDATE ' + TableName + ' SET '
                + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' WHERE '
                + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString);

            ibc_majcu.Prepare;
            ibc_majcu.ParamByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString :=
                DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).OldAsString;
            ibc_majcu.Execute;

        END;
    END;

    IF Dataset.IB_Transaction = Ibt_Lk THEN
    BEGIN

        IF NOT IsKManagementActive THEN
        BEGIN
            ibc_majcuLk.SQL.Clear;
            ibc_majcuLk.SQL.Add('DELETE FROM ' + TableName + ' WHERE '
                + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString);
            ibc_majcuLk.Prepare;
            ibc_majcuLk.ParamByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString :=
                DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).OldAsString;
            ibc_majcuLk.Execute;
        END;

        IF IsKManagementActive THEN
        BEGIN
            DeleteKLk(DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME'
                ).AsString).OldAsString,
                '-1');

            // Simulation de modification pour activation des triggers
            ibc_majcuLk.SQL.Clear;
            ibc_majcuLk.SQL.Add('UPDATE ' + TableName + ' SET '
                + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' WHERE '
                + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                + ' = :' + IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString);

            ibc_majcuLk.Prepare;
            ibc_majcuLk.ParamByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).AsString :=
                DataSet.FieldByName(IbQ_TablePkKey.FieldByName('KFLD_NAME').AsString
                ).OldAsString;
            ibc_majcuLk.Execute;

        END;
    END;

END;

// GESTION DE LA TABLE K

function TDm_Main.Get_Next_Version_ID: string;
begin
  try
    IBQ_Next_VERSION_ID.Close;
    IBQ_Next_VERSION_ID.open;
    result := IBQ_Next_VERSION_ID.Fields[0].asstring;
    IBQ_Next_VERSION_ID.Close;
  except
    on E : Exception do
    begin
      ErrorGestionnaire(nil, E);
    end;
  end;
end;

PROCEDURE TDm_Main.InsertK(K_ID, KTB_ID, KRH_ID, KSE_Owner, KSE_Insert: STRING
    );
VAR
    S1, S2: STRING;
BEGIN
    S1 := DateTimeToStr(Now);
    S2 := DateTimeToStr(0);
    IF NOT IbC_InsertK.Prepared THEN
        IbC_InsertK.Prepare;
    IbC_InsertK.ParamByName('K_ID').AsString := K_ID;
    IF FVersionSys = 0 THEN
        If Gestion_K_VERSION=TKV64 then
          IbC_InsertK.ParamByName('K_VERSION').AsString := Get_Next_VERSION_ID
        else
          IbC_InsertK.ParamByName('K_VERSION').AsString := GenVersion
    ELSE
        IbC_InsertK.ParamByName('K_VERSION').AsInteger := FVersionSys;

    IbC_InsertK.ParamByName('KRH_ID').AsString := KRH_ID;
    IbC_InsertK.ParamByName('KTB_ID').AsString := KTB_ID;
    IbC_InsertK.ParamByName('KSE_OWNER_ID').AsString := KSE_Owner;
    IbC_InsertK.ParamByName('KSE_INSERT_ID').AsString := KSE_Insert;
    IbC_InsertK.ParamByName('KSE_UPDATE_ID').AsString := '0';
    IbC_InsertK.ParamByName('KSE_DELETE_ID').AsString := '0';
    IbC_InsertK.ParamByName('K_INSERTED').AsString := S1;
    IbC_InsertK.ParamByName('K_UPDATED').AsString := S1;
    IbC_InsertK.ParamByName('K_DELETED').AsString := S2;
    IbC_InsertK.ParamByName('KSE_LOCK_ID').AsString := '0';
    IbC_InsertK.ParamByName('KMA_LOCK_ID').AsString := '0';
    IbC_InsertK.Execute;
END;

PROCEDURE TDm_Main.InsertKLk(K_ID, KTB_ID, KRH_ID, KSE_Owner, KSE_Insert: STRING
    );
VAR
    S1, S2: STRING;
BEGIN
    S1 := DateTimeToStr(Now);
    S2 := DateTimeToStr(0);
    IF NOT IbC_InsertKLk.Prepared THEN
        IbC_InsertKLk.Prepare;
    IbC_InsertKLk.ParamByName('K_ID').AsString := K_ID;
    IF FVersionSys = 0 THEN
        If Gestion_K_VERSION=TKV64 then
          IbC_InsertKLk.ParamByName('K_VERSION').AsString := Get_Next_VERSION_ID
        else
          IbC_InsertKLk.ParamByName('K_VERSION').AsString := GenVersion
    ELSE
        IbC_InsertKLk.ParamByName('K_VERSION').AsInteger := FVersionSys;

    IbC_InsertKLk.ParamByName('KRH_ID').AsString := KRH_ID;
    IbC_InsertKLk.ParamByName('KTB_ID').AsString := KTB_ID;
    IbC_InsertKLk.ParamByName('KSE_OWNER_ID').AsString := KSE_Owner;
    IbC_InsertKLk.ParamByName('KSE_INSERT_ID').AsString := KSE_Insert;
    IbC_InsertKLk.ParamByName('KSE_UPDATE_ID').AsString := '0';
    IbC_InsertKLk.ParamByName('KSE_DELETE_ID').AsString := '0';
    IbC_InsertKLk.ParamByName('K_INSERTED').AsString := S1;
    IbC_InsertKLk.ParamByName('K_UPDATED').AsString := S1;
    IbC_InsertKLk.ParamByName('K_DELETED').AsString := S2;
    IbC_InsertKLk.ParamByName('KSE_LOCK_ID').AsString := '0';
    IbC_InsertKLk.ParamByName('KMA_LOCK_ID').AsString := '0';
    IbC_InsertKLk.Execute;
END;

PROCEDURE TDm_Main.UpdateK(K_ID, KSE_Update: STRING);
VAR
    S: STRING;
BEGIN
    S := DateTimeToStr(Now);
    IF NOT IbC_UpDateK.Prepared THEN
        IbC_UpDateK.Prepare;
    IbC_UpDateK.ParamByName('K_ID').AsString := K_ID;
    IF FVersionSys = 0 THEN
        If Gestion_K_VERSION=TKV64 then
          IbC_UpDateK.ParamByName('K_VERSION').AsString := Get_Next_VERSION_ID
        else
          IbC_UpDateK.ParamByName('K_VERSION').AsString := GenVersion
    ELSE
        IbC_UpDateK.ParamByName('K_VERSION').AsString := IntToStr(FVersionSys);

    IbC_UpDateK.ParamByName('KSE_UPDATE_ID').AsString := KSE_Update;
    IbC_UpDateK.ParamByName('K_UPDATED').AsString := S;
    IbC_UpDateK.Execute;
END;

PROCEDURE TDm_Main.UpdateKLk(K_ID, KSE_Update: STRING);
VAR
    S: STRING;
BEGIN
    S := DateTimeToStr(Now);
    IF NOT IbC_UpDateKLk.Prepared THEN
        IbC_UpDateKLk.Prepare;
    IbC_UpDateKLk.ParamByName('K_ID').AsString := K_ID;
    IF FVersionSys = 0 THEN
        If Gestion_K_VERSION=TKV64 then
          IbC_UpDateKLk.ParamByName('K_VERSION').AsString := Get_Next_VERSION_ID
        else
          IbC_UpDateKLk.ParamByName('K_VERSION').AsString := GenVersion
    ELSE
        IbC_UpDateKLk.ParamByName('K_VERSION').AsString := IntToStr(FVersionSys);

    IbC_UpDateKLk.ParamByName('KSE_UPDATE_ID').AsString := KSE_Update;
    IbC_UpDateKLk.ParamByName('K_UPDATED').AsString := S;
    IbC_UpDateKLk.Execute;
END;

PROCEDURE TDm_Main.DeleteK(K_ID, KSE_Delete: STRING);
VAR
    S: STRING;
BEGIN
    S := DateTimeToStr(Now);
    IF NOT IbC_DeleteK.Prepared THEN
        IbC_DeleteK.Prepare;
    IbC_DeleteK.ParamByName('K_ID').AsString := K_ID;
    IF FVersionSys = 0 THEN
        If Gestion_K_VERSION=TKV64 then
          IbC_DeleteK.ParamByName('K_VERSION').AsString := Get_Next_VERSION_ID
        else
          IbC_DeleteK.ParamByName('K_VERSION').AsString := GenVersion
    ELSE
        IbC_DeleteK.ParamByName('K_VERSION').AsInteger := FVersionSys;

    IbC_DeleteK.ParamByName('KSE_DELETE_ID').AsString := KSE_Delete;
    IbC_DeleteK.ParamByName('K_DELETED').AsString := S;
    IbC_DeleteK.Execute;
END;

PROCEDURE TDm_Main.DeleteKLk(K_ID, KSE_Delete: STRING);
VAR
    S: STRING;
BEGIN
    S := DateTimeToStr(Now);
    IF NOT IbC_DeleteKLk.Prepared THEN
        IbC_DeleteKLk.Prepare;
    IbC_DeleteKLk.ParamByName('K_ID').AsString := K_ID;
    IF FVersionSys = 0 THEN
        If Gestion_K_VERSION=TKV64 then
          IbC_DeleteKLk.ParamByName('K_VERSION').AsString := Get_Next_VERSION_ID
        else
          IbC_DeleteKLk.ParamByName('K_VERSION').AsString := GenVersion
    ELSE
        IbC_DeleteKLk.ParamByName('K_VERSION').AsInteger := FVersionSys;

    IbC_DeleteKLk.ParamByName('KSE_DELETE_ID').AsString := KSE_Delete;
    IbC_DeleteKLk.ParamByName('K_DELETED').AsString := S;
    IbC_DeleteKLk.Execute;
END;

PROCEDURE TDm_Main.SetVersionSys(Version: Integer);
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

PROCEDURE TDm_Main.SetNewGeneratorKey(ProcName: STRING);
BEGIN
    IbStProc_NewKey.StoredProcName := ProcName;
END;

PROCEDURE TDm_Main.SetNewGeneratorVerKey(ProcName: STRING);
BEGIN
    IbStProc_NewVerKey.StoredProcName := ProcName;
END;

// GESTION DU MONITEUR SQL

PROCEDURE TDm_Main.ShowMonitor;
BEGIN
    Monitor.Show;
END;

// GESTION DE SCRIPT SQL

PROCEDURE TDm_Main.PrepareScript(SQL: STRING);
BEGIN
    IbC_Script.Close;
    IbC_Script.SQL.Clear;
    IbC_Script.SQL.Add(SQL);
    IbC_Script.Prepare;
END;

PROCEDURE TDm_Main.PrepareScriptLk(SQL: STRING);
BEGIN
    IbC_ScriptLk.Close;
    IbC_ScriptLk.SQL.Clear;
    IbC_ScriptLk.SQL.Add(SQL);
    IbC_ScriptLk.Prepare;
END;

// obsolète
{
PROCEDURE TDm_Main.PrepareScriptMultiKUpDate(SQL: STRING);
BEGIN
    IbC_Script.Close;
    IbC_Script.SQL.Clear;
    IbC_Script.SQL.Add(
        'UPDATE K SET ' +
        'K_VERSION = (SELECT NEWKEY from PROC_NEWVERKEY),' +
        'KSE_UPDATE_ID = -1,' +
        'K_UPDATED = :K_UPDATED WHERE K.K_ID IN (' +
        SQL + ' )');
    IbC_Script.Prepare;
    IbC_Script.ParamByName('K_UPDATED').AsString := DateTimeToStr(Now);
END;

PROCEDURE TDm_Main.PrepareScriptMultiKUpDateLk(SQL: STRING);
BEGIN
    IbC_ScriptLk.Close;
    IbC_ScriptLk.SQL.Clear;
    IbC_ScriptLk.SQL.Add(
        'UPDATE K SET ' +
        'K_VERSION = (SELECT NEWKEY from PROC_NEWVERKEY),' +
        'KSE_UPDATE_ID = -1,' +
        'K_UPDATED = :K_UPDATED WHERE K.K_ID IN (' +
        SQL + ' )');
    IbC_ScriptLk.Prepare;
    IbC_ScriptLk.ParamByName('K_UPDATED').AsString := DateTimeToStr(Now);
END;

PROCEDURE TDm_Main.PrepareScriptMultiKDelete(SQL: STRING);
BEGIN
    IbC_Script.Close;
    IbC_Script.SQL.Clear;
    IbC_Script.SQL.Add(
        'UPDATE K SET ' +
        'K_VERSION = (SELECT NEWKEY from PROC_NEWVERKEY),' +
        'K_ENABLED = 0,' +
        'KSE_UPDATE_ID = -1,' +
        'K_DELETED = :K_DELETED WHERE K.K_ID IN (' +
        SQL + ' )');
    IbC_Script.Prepare;
    IbC_Script.ParamByName('K_DELETED').AsString := DateTimeToStr(Now);

END;

PROCEDURE TDm_Main.PrepareScriptMultiKDeleteLk(SQL: STRING);
BEGIN
    IbC_ScriptLk.Close;
    IbC_ScriptLk.SQL.Clear;
    IbC_ScriptLk.SQL.Add(
        'UPDATE K SET ' +
        'K_VERSION = (SELECT NEWKEY from PROC_NEWVERKEY),' +
        'K_ENABLED = 0,' +
        'KSE_UPDATE_ID = -1,' +
        'K_DELETED = :K_DELETED WHERE K.K_ID IN (' +
        SQL + ' )');
    IbC_ScriptLk.Prepare;
    IbC_ScriptLk.ParamByName('K_DELETED').AsString := DateTimeToStr(Now);

END;
}

PROCEDURE TDm_Main.SetScriptParameterValue(ParamName, ParamValue: STRING);
BEGIN
    IbC_Script.ParamByName(ParamName).AsString := ParamValue;
END;

PROCEDURE TDm_Main.SetScriptParameterValueLk(ParamName, ParamValue: STRING);
BEGIN
    IbC_ScriptLk.ParamByName(ParamName).AsString := ParamValue;
END;

PROCEDURE TDm_Main.ExecuteScript;
BEGIN
    TRY
        Dm_Main.StartTransaction;
        IbC_Script.Execute;
        Dm_Main.Commit;
    EXCEPT
        Dm_Main.Rollback;
        IF (FTransactionCount <> 0) THEN RAISE;
    END;
END;

PROCEDURE TDm_Main.ExecuteScriptLk;
BEGIN
    TRY
        Dm_Main.StartTransactionLk;
        IbC_ScriptLk.Execute;
        Dm_Main.CommitLk;
    EXCEPT
        Dm_Main.RollbackLk;
        IF (FTransactionCountLk <> 0) THEN RAISE;
    END;
END;

PROCEDURE TDm_Main.ExecuteInsertK(TableName, KeyValue: STRING);
VAR
    SQLTYPE: STRING;
BEGIN
    TRY
        Dm_Main.StartTransaction;

        // Mise à jour de la Table K
        GetTableFields(TableName);

        SQLTYPE := FirstMot(IbC_Script.SQL[0]);
        IF (SQLTYPE <> 'INSERT') OR (StrToInt(KeyValue) <= 0) THEN
            RAISE Exception.Create(ErrUsingScript);

        InsertK(KeyValue, IbQ_TablePkKey.FieldByName('KTB_ID').AsString,
            '-101', '-1', '-1');

        // Lancement de la commande SQL
        IbC_Script.Execute;

        Dm_Main.Commit;
    EXCEPT
        Dm_Main.Rollback;
        IF (FTransactionCount <> 0) THEN RAISE;
    END;
END;

PROCEDURE TDm_Main.ExecuteInsertKLk(TableName, KeyValue: STRING);
VAR
    SQLTYPE: STRING;
BEGIN
    TRY
        Dm_Main.StartTransactionLk;

        // Mise à jour de la Table K
        GetTableFields(TableName);

        SQLTYPE := FirstMot(IbC_Script.SQL[0]);
        IF (SQLTYPE <> 'INSERT') OR (StrToInt(KeyValue) <= 0) THEN
            RAISE Exception.Create(ErrUsingScript);

        InsertKLk(KeyValue, IbQ_TablePkKey.FieldByName('KTB_ID').AsString,
            '-101', '-1', '-1');

        // Lancement de la commande SQL
        IbC_ScriptLk.Execute;

        Dm_Main.CommitLk;
    EXCEPT
        Dm_Main.RollbackLk;
        IF (FTransactionCountLk <> 0) THEN RAISE;
    END;
END;

// VERIFICATION DE L'INTEGRITE DE LA BASE

FUNCTION TDm_Main.CheckOneIntegrity(LkUpTableName, LkPkFieldName,
    LkUpFieldName, KeyValue: STRING; ShowErrorMessage: Boolean): Boolean;
BEGIN
    Ibc_IntegrityChk.Close;
    Ibc_IntegrityChk.SQL.Clear;
    IF IsKManagementActive THEN
        Ibc_IntegrityChk.SQL.Add('SELECT * FROM '
            + LkUpTableName
            + ',K WHERE '
            + LkUpFieldName
            + '=' + KeyValue
            + ' AND ' + LkPkFieldName // Ajout pour traiter le cas des arbres stockés
            + '<>' + KeyValue // dans une même table
            + ' AND K_ID = '
            + LkPkFieldName
            + ' AND K_ENABLED=1')
    ELSE
        Ibc_IntegrityChk.SQL.Add('SELECT * FROM '
            + LkUpTableName
            + ' WHERE '
            + LkUpFieldName
            + '=' + KeyValue
            + ' AND ' + LkPkFieldName // Ajout pour traiter le cas des arbres stockés
            + '<>' + KeyValue // dans une même table
            );
    Ibc_IntegrityChk.Open;
    Result := Ibc_IntegrityChk.Eof;

    IF NOT Result AND ShowErrorMessage THEN
    BEGIN
        ERRMESS(ErrNoDeleteIntChk, '');
    END;

END;

FUNCTION TDm_Main.CheckAllowEdit(TableName, KeyValue: STRING;
    ShowErrorMessage:
    Boolean): boolean;
BEGIN
    Result := True;
  // Si...
    IF (KeyValue <> '') AND // ID défini
        (StrToInt(KeyValue) <= 0) AND // ID négatif
        (FVersionSys = 0) THEN
    BEGIN // alors on ne peut pas modifier un enregistrement système  // Pas en mode système
        IF ShowErrorMessage THEN ERRMESS(ErrNoEditNullRec, '');
        Result := False;
    END
END;

FUNCTION TDm_Main.TransactionUpdPending: boolean;
BEGIN
    Result := IbT_Select.TransactionIsActive;
END;

FUNCTION TDm_Main.TransactionUpdPendingLk: boolean;
BEGIN
    Result := IbT_Lk.TransactionIsActive;
END;

FUNCTION TDm_Main.IBOUpdPending(DataSet: TIBODataSet): boolean;
BEGIN
    Result := DataSet.Modified OR DataSet.UpdatesPending;
END;

FUNCTION TDm_Main.IB_UpdPending(DataSet: TIB_BDataSet): boolean;
BEGIN
    Result := DataSet.Modified OR DataSet.UpdatesPending;
END;

FUNCTION TDm_Main.CheckAllowDelete(TableName, KeyValue: STRING;
    ShowErrorMessage: Boolean): boolean;
BEGIN
    Result := True;

  // Si...
    IF (KeyValue <> '') AND // ID défini
        (StrToInt(KeyValue) <= 0) AND // ID négatif
        (FVersionSys = 0) THEN
    BEGIN // alors on ne peut pas effacer un enregistrement système  // Pas en mode système
        IF ShowErrorMessage THEN ERRMESS(ErrNoDeleteNullRec, '');
        Result := False;
    END
    ELSE
    BEGIN

        GetTableFields(TableName);
        IF IbQ_TablePkKey.Eof THEN
            RAISE Exception.Create(ParamsStr(ErrNoPkFieldDef, TableName));

        IF IbQ_FieldFkField.ParamByName('KFLD_FK').AsString <>
            IbQ_TablePkKey.FieldByName('KFLD_ID').AsString THEN
            IbQ_FieldFkField.ParamByName('KFLD_FK').AsString :=
                IbQ_TablePkKey.FieldByName('KFLD_ID').AsString;

        IF NOT IbQ_FieldFkField.Active THEN IbQ_FieldFkField.Open;
        IbQ_FieldFkField.First;

        WHILE NOT IbQ_FieldFkField.Eof DO
        BEGIN
            Result := Result AND
                CheckOneIntegrity(IbQ_FieldFkField.FieldByName('KTB_NAME').AsString,
                IbQ_FieldFkField.FieldByName('PKFIELD').AsString,
                IbQ_FieldFkField.FieldByName('KFLD_NAME').AsString,
                KeyValue, False);
            IbQ_FieldFkField.Next;
        END;

        IF NOT Result AND ShowErrorMessage THEN
        BEGIN
            ERRMESS(ErrNoDeleteIntChk, '');
        END;
    END;
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TDm_Main.DataModuleDestroy(Sender: TObject);
BEGIN
    IF (NOT (csDesigning IN ComponentState)) THEN
        Database.Connected := False;
END;

PROCEDURE TDm_Main.ibc_majcuError(Sender: TObject; CONST ERRCODE: Integer;
    ErrorMessage, ErrorCodes: TStringList; CONST SQLCODE: Integer;
    SQLMessage, SQL: TStringList; VAR RaiseException: Boolean);
BEGIN
    RaiseException := False;
    CASE SQLCODE OF
        -625: RAISE Exception.Create(errSQL625);
        -803: RAISE Exception.Create(errSQL803);
    ELSE
        RAISE Exception.Create(ParamsStr(errSQL, SQLCODE));
    END;
END;

END.

