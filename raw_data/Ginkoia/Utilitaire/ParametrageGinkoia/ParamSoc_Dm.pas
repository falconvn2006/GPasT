//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT ParamSoc_Dm;

INTERFACE

USES
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    ActionRv,
    Db,
    IBoDataset, IB_Components, IB_StoredProc;

TYPE
    TDm_ParamSoc = CLASS(TDataModule)
        Grd_Que: TGroupDataRv;
        Que_Societe: TIBOQuery;
        Que_Magasin: TIBOQuery;
        Que_Poste: TIBOQuery;
        Que_MagasinMAG_ID: TIntegerField;
        Que_MagasinMAG_IDENT: TStringField;
        Que_MagasinMAG_NOM: TStringField;
        Que_MagasinMAG_SOCID: TIntegerField;
        Que_MagasinMAG_ADRID: TIntegerField;
        Que_MagasinMAG_TVTID: TIntegerField;
        Que_MagasinMAG_TEL: TStringField;
        Que_MagasinMAG_FAX: TStringField;
        Que_MagasinMAG_EMAIL: TStringField;
        Que_MagasinMAG_SIRET: TStringField;
        Que_MagasinMAG_CODEADH: TStringField;
        Que_MagasinMAG_NATURE: TIntegerField;
        Que_MagasinMAG_TRANSFERT: TIntegerField;
        Que_MagasinMAG_SS: TIntegerField;
        Que_MagasinMAG_HUSKY: TIntegerField;
        Que_MagasinMAG_IDENTCOURT: TStringField;
        Que_MagasinMAG_COMENT: TMemoField;
        Que_MagasinMAG_ARRONDI: TIntegerField;
        Que_MagasinMAG_GCLID: TIntegerField;
        Que_Adresse: TIBOQuery;
        Que_MagasinMAG_ENSEIGNE: TStringField;
        Que_MagasinMAG_FACID: TIntegerField;
        Que_MagasinMAG_LIVID: TIntegerField;
        Que_SocieteSOC_ID: TIntegerField;
        Que_SocieteSOC_NOM: TStringField;
        Que_SocieteSOC_FORME: TStringField;
        Que_SocieteSOC_APE: TStringField;
        Que_SocieteSOC_RCS: TStringField;
        Que_SocieteSOC_TVA: TStringField;
        Que_SocieteSOC_CLOTURE: TDateTimeField;
        Que_SocieteSOC_DIRIGEANT: TStringField;
        Que_SocieteSOC_SSID: TIntegerField;
        Que_SocieteSOC_FACTOR: TStringField;
        Que_SocieteSOC_CODEFOURN: TStringField;
        Que_SocieteSOC_PIEDFACTURE: TStringField;
        Que_GENPARAM: TIBOQuery;
        Que_GENPARAMPRM_ID: TIntegerField;
        Que_GENPARAMPRM_MAGID: TIntegerField;
        Que_GENPARAMPRM_STRING: TStringField;
        Que_GENPARAMPRM_CODE: TIntegerField;
        Que_GENPARAMPRM_TYPE: TIntegerField;
        Que_GENPARAMPRM_INTEGER: TIntegerField;
        Que_GENPARAMPRM_FLOAT: TIBOFloatField;
        Que_GENPARAMPRM_INFO: TStringField;
        Que_GENPARAMPRM_POS: TIntegerField;
        Que_NiveauUtilisateur: TIBOQuery;
        IntegerField1: TIntegerField;
        IntegerField2: TIntegerField;
        StringField1: TStringField;
        IntegerField3: TIntegerField;
        IntegerField4: TIntegerField;
        IntegerField5: TIntegerField;
        IBOFloatField1: TIBOFloatField;
        StringField2: TStringField;
        IntegerField6: TIntegerField;
        Que_MagasinLOCATION: TIntegerField;
        Que_MagasinNIVEAU: TIntegerField;
        ibq_Coffre: TIBOQuery;
        Ibq_Banque: TIBOQuery;
        ibq_mp: TIBOQuery;
        Grd_Close: TGroupDataRv;
        Que_CSHMODEENCDETAIL: TIBOQuery;
        Que_CSHMODEENCDETAILMED_ID: TIntegerField;
        Que_CSHMODEENCDETAILMED_MENID: TIntegerField;
        Que_CSHMODEENCDETAILMED_LIBELLE: TStringField;
        Que_CSHMODEENCDETAILMED_MONTANT: TIBOFloatField;
        Que_MagasinMAG_COULMAG: TIntegerField;
        Que_MagasinMAG_MTAID: TIntegerField;
    Que_GENPARAMSTD: TIBOQuery;
    Que_GENPARAMSTDPRM_ID: TIntegerField;
    Que_GENPARAMSTDPRM_CODE: TIntegerField;
    Que_GENPARAMSTDPRM_INTEGER: TIntegerField;
    Que_GENPARAMSTDPRM_FLOAT: TIBOFloatField;
    Que_GENPARAMSTDPRM_STRING: TStringField;
    Que_GENPARAMSTDPRM_TYPE: TIntegerField;
    Que_GENPARAMSTDPRM_MAGID: TIntegerField;
    Que_GENPARAMSTDPRM_INFO: TStringField;
    Que_GENPARAMSTDPRM_POS: TIntegerField;
    IbStProc_InitMag: TIB_StoredProc;
        PROCEDURE DataModuleCreate(Sender: TObject);
        PROCEDURE DataModuleDestroy(Sender: TObject);
        PROCEDURE Que_SocieteAfterPost(DataSet: TDataSet);
        PROCEDURE Que_SocieteBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_SocieteBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_SocieteNewRecord(DataSet: TDataSet);
        PROCEDURE Que_SocieteUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_MagasinAfterPost(DataSet: TDataSet);
        PROCEDURE Que_MagasinBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_MagasinBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_MagasinNewRecord(DataSet: TDataSet);
        PROCEDURE Que_MagasinUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_PosteAfterPost(DataSet: TDataSet);
        PROCEDURE Que_PosteBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_PosteBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_PosteNewRecord(DataSet: TDataSet);
        PROCEDURE Que_PosteUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_AdresseBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_AdresseBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_AdresseUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_MagasinBeforePost(DataSet: TDataSet);

        PROCEDURE GenerikBeforeDelete(DataSet: TDataSet);
        PROCEDURE GenerikUpdateRecord(DataSet: TDataSet; UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE GenerikAfterCancel(DataSet: TDataSet);
        PROCEDURE GenerikAfterPost(DataSet: TDataSet);
        PROCEDURE GenerikNewRecord(DataSet: TDataSet);

        PROCEDURE Que_GENPARAMBeforeEdit(DataSet: TDataSet);
    PRIVATE
    { Déclarations privées }
        Ins: boolean;
        PROCEDURE InitModeEnc(socid: integer; magid: integer);
    PUBLIC
    { Déclarations publiques }
        PROCEDURE Refresh;
        PROCEDURE CloseOpen;
    END;

VAR
    Dm_ParamSoc: TDm_ParamSoc;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

IMPLEMENTATION
USES Main_Dm,
    GinkoiaStd,
    GinkoiaResStr;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

PROCEDURE TDm_ParamSoc.GenerikBeforeDelete(DataSet: TDataSet);
BEGIN
{ A achever ...
    IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
    BEGIN
        StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
        ABORT;
    END;
}
END;

PROCEDURE TDm_ParamSoc.GenerikUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamSoc.GenerikAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamSoc.GenerikAfterCancel(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamSoc.GenerikNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_ParamSoc.Refresh;
BEGIN
    Grd_Que.Refresh;
END;

PROCEDURE TDm_ParamSoc.CloseOpen;
BEGIN
    Que_Societe.Close;
    Que_Societe.Open;

    Que_Magasin.Close;
    Que_Magasin.Open;

    Que_Poste.Close;
    Que_Poste.Open;
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TDm_ParamSoc.DataModuleCreate(Sender: TObject);
BEGIN
    Grd_Que.Open;
    Ins := false;
END;

PROCEDURE TDm_ParamSoc.DataModuleDestroy(Sender: TObject);
BEGIN
    Grd_Close.Close;
END;

PROCEDURE TDm_ParamSoc.Que_SocieteAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamSoc.Que_SocieteBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamSoc.Que_SocieteBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamSoc.Que_SocieteNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;

    que_Societe.FieldByName('SOC_NOM').asString := '';
    que_Societe.FieldByName('SOC_FORME').asString := '';
    que_Societe.FieldByName('SOC_APE').asString := '';
    que_Societe.FieldByName('SOC_RCS').asString := '';
    que_Societe.FieldByName('SOC_TVA').asString := '';
    que_Societe.FieldByName('SOC_DIRIGEANT').asString := '';
    que_Societe.FieldByName('SOC_SSID').asInteger := 0;
    que_Societe.FieldByName('SOC_FACTOR').asString := '';
    que_Societe.FieldByName('SOC_CODEFOURN').asString := '';
    que_Societe.FieldByName('SOC_PIEDFACTURE').asString := '';
END;

PROCEDURE TDm_ParamSoc.Que_SocieteUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamSoc.Que_MagasinAfterPost(DataSet: TDataSet);
BEGIN

    TRY Dm_Main.StartTransaction;
        Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
        Dm_Main.IBOUpDateCache(Que_Adresse);
        Dm_Main.IBOUpDateCache(Que_genparam);
        Dm_Main.IBOUpDateCache(Que_NiveauUtilisateur);
        Dm_Main.IBOUpDateCache(ibq_banque);
        Dm_Main.IBOUpDateCache(ibq_coffre);
        Dm_Main.IBOUpDateCache(ibq_mp);
        Dm_Main.IBOUpDateCache(Que_CSHMODEENCDETAIL);
        Dm_Main.Commit;
        IF (que_Magasin.FieldByName('MAG_SS').asInteger = 1) AND
            (que_Societe.FieldByName('SOC_SSID').asInteger <>
            que_Magasin.fieldByName('Mag_ID').asInteger) THEN
        BEGIN
            que_Societe.Edit;
            que_Societe.FieldByName('SOC_SSID').asInteger := que_Magasin.fieldByName('Mag_ID').asInteger;
            que_Societe.Post;
        END;
    EXCEPT
        Dm_Main.Rollback;
        Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
        Dm_Main.IBOCancelCache(Que_Adresse);
        Dm_Main.IBOCancelCache(Que_genparam);
        Dm_Main.IBOCancelCache(Que_NiveauUtilisateur);
        Dm_Main.IBOCancelCache(ibq_banque);
        Dm_Main.IBOCancelCache(ibq_coffre);
        Dm_Main.IBOCancelCache(ibq_mp);
        Dm_Main.IBOCancelCache(Que_CSHMODEENCDETAIL);
    END;
    Dm_Main.IBOCommitCache(DataSet AS TIBOQuery);
    Dm_Main.IBOCommitCache(Que_Adresse);
    Dm_Main.IBOCommitCache(Que_genparam);
    Dm_Main.IBOCommitCache(Que_NiveauUtilisateur);
    Dm_Main.IBOCommitCache(ibq_banque);
    Dm_Main.IBOCommitCache(ibq_coffre);
    Dm_Main.IBOCommitCache(ibq_mp);
    Dm_Main.IBOCommitCache(Que_CSHMODEENCDETAIL);

    Dm_Main.StartTransaction;
    try
       IbStProc_InitMag.Close;
       IbStProc_InitMag.Prepare;
       IbStProc_InitMag.ParamByName('MAGID').asInteger := Que_MagasinMAG_ID.asInteger;
       IbStProc_InitMag.execSql;
       Dm_Main.Commit;
       IbStProc_InitMag.Unprepare;
       IbStProc_InitMag.Close;
    except
       Dm_Main.Rollback;
    END;

END;

PROCEDURE TDm_ParamSoc.Que_MagasinBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamSoc.Que_MagasinBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamSoc.Que_MagasinNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;

    Que_Adresse.insert;
    Que_GENPARAM.Open;
    Que_GENPARAM.INSERT;
    Que_NiveauUtilisateur.Open;

    IF NOT Dm_Main.IBOMajPkKey(Que_Adresse, Que_Adresse.KeyLinks.IndexNames[0]) THEN ABORT;
    IF NOT Dm_Main.IBOMajPkKey(Que_GENPARAM, Que_GENPARAM.KeyLinks.IndexNames[0]) THEN ABORT;

    que_Magasin.FieldByName('Mag_SOCID').asInteger := que_Societe.FieldByName('SOC_ID').asInteger;
    que_Magasin.FieldByName('Mag_TVTID').asInteger := 0;
    que_Magasin.FieldByName('Mag_IDENT').asString := '';
    que_Magasin.FieldByName('Mag_ADRID').asInteger := Que_Adresse.FieldByName('ADR_ID').asInteger; ;
    que_Magasin.FieldByName('Mag_NOM').asString := '';
    que_Magasin.FieldByName('Mag_TEL').asString := '';
    que_Magasin.FieldByName('Mag_FAX').asString := '';
    que_Magasin.FieldByName('Mag_EMAIL').asString := '';
    que_Magasin.FieldByName('Mag_SIRET').asString := '';
    que_Magasin.FieldByName('Mag_CODEADH').asString := '';
    que_Magasin.FieldByName('Mag_NATURE').asInteger := 1;
    que_Magasin.FieldByName('Mag_TRANSFERT').asInteger := 0;
    que_Magasin.FieldByName('Mag_SS').asInteger := 0;
    que_Magasin.FieldByName('Mag_HUSKY').asInteger := 0;
    que_Magasin.FieldByName('Mag_IDENTCOURT').asString := '';
    que_Magasin.FieldByName('Mag_COMENT').asString := '';
    que_Magasin.FieldByName('Mag_ARRONDI').asInteger := 0;
    que_Magasin.FieldByName('Mag_GCLID').asInteger := 0;
    que_Magasin.FieldByName('Mag_FACID').asInteger := 0;
    que_Magasin.FieldByName('Mag_LIVID').asInteger := 0;
    que_Magasin.FieldByName('LOCATION').asInteger := 0;
    que_Magasin.FieldByName('NIVEAU').asInteger := 3;
    que_Magasin.FieldByName('MAG_COULMAG').asInteger := 0;
    que_Magasin.FieldByName('MAG_MTAID').asInteger := 0;
  // ******************************************************
    Que_Adresse.FieldByName('ADR_VILID').asInteger := 0;
    Que_Adresse.Post;

    Que_GENPARAM.FieldByName('PRM_TYPE').asInteger := 9;
    Que_GENPARAM.FieldByName('PRM_CODE').asInteger := 90;
    Que_GENPARAM.FieldByName('PRM_INTEGER').asInteger := 0;
    Que_GENPARAM.FieldByName('PRM_MAGID').asInteger := QUE_MAGASIN.FieldByName('MAG_ID').asInteger;
    Que_GENPARAM.FieldByName('PRM_STRING').asString := 'LOCATION';
    Que_GENPARAM.FieldByName('PRM_INFO').asString := 'LOCATION';
    Que_GENPARAM.Post;

    Que_NiveauUtilisateur.INSERT;
    IF NOT Dm_Main.IBOMajPkKey(Que_NiveauUtilisateur, Que_NiveauUtilisateur.KeyLinks.IndexNames[0]) THEN ABORT;
    Que_NiveauUtilisateur.FieldByName('PRM_TYPE').asInteger := 3;
    Que_NiveauUtilisateur.FieldByName('PRM_CODE').asInteger := 31;
    Que_NiveauUtilisateur.FieldByName('PRM_INTEGER').asInteger := 3; // niveau par défault
    Que_NiveauUtilisateur.FieldByName('PRM_MAGID').asInteger := QUE_MAGASIN.FieldByName('MAG_ID').asInteger;
    Que_NiveauUtilisateur.FieldByName('PRM_STRING').asString := 'NIVEAU VERSION UTILISATEUR';
    Que_NiveauUtilisateur.FieldByName('PRM_INFO').asString := 'NIVEAU VERSION UTILISATEUR';
    Que_NiveauUtilisateur.FieldByName('PRM_FLOAT').asFloat := 0;
    Que_NiveauUtilisateur.Post;

    Que_NiveauUtilisateur.INSERT;
    IF NOT Dm_Main.IBOMajPkKey(Que_NiveauUtilisateur, Que_NiveauUtilisateur.KeyLinks.IndexNames[0]) THEN ABORT;
    Que_NiveauUtilisateur.FieldByName('PRM_TYPE').asInteger := 9;
    Que_NiveauUtilisateur.FieldByName('PRM_CODE').asInteger := 210;
    Que_NiveauUtilisateur.FieldByName('PRM_INTEGER').asInteger := 0; // niveau par défault
    Que_NiveauUtilisateur.FieldByName('PRM_MAGID').asInteger := QUE_MAGASIN.FieldByName('MAG_ID').asInteger;
    Que_NiveauUtilisateur.FieldByName('PRM_STRING').asString := 'renseigner l adresse de votre site web';
    Que_NiveauUtilisateur.FieldByName('PRM_INFO').asString := 'connection WEB VENTE';
    Que_NiveauUtilisateur.FieldByName('PRM_FLOAT').asFloat := 0;
    Que_NiveauUtilisateur.Post;

    Que_NiveauUtilisateur.INSERT;
    IF NOT Dm_Main.IBOMajPkKey(Que_NiveauUtilisateur, Que_NiveauUtilisateur.KeyLinks.IndexNames[0]) THEN ABORT;
    Que_NiveauUtilisateur.FieldByName('PRM_TYPE').asInteger := 5;
    Que_NiveauUtilisateur.FieldByName('PRM_CODE').asInteger := 51;
    Que_NiveauUtilisateur.FieldByName('PRM_INTEGER').asInteger := 0; // niveau par défault
    Que_NiveauUtilisateur.FieldByName('PRM_MAGID').asInteger := QUE_MAGASIN.FieldByName('MAG_ID').asInteger;
    Que_NiveauUtilisateur.FieldByName('PRM_STRING').asString := 'saisir adresse site web Ref. DYNAMIQUE';
    Que_NiveauUtilisateur.FieldByName('PRM_INFO').asString := 'connection REFERENCEMENT DYNAMIQUE';
    Que_NiveauUtilisateur.FieldByName('PRM_FLOAT').asFloat := 0;
    Que_NiveauUtilisateur.Post;


END;

PROCEDURE TDm_ParamSoc.Que_MagasinUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamSoc.Que_PosteAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_ParamSoc.Que_PosteBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
    MessageDlg('ok', mtWarning, [], 0);
END;

PROCEDURE TDm_ParamSoc.Que_PosteBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamSoc.Que_PosteNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;

    que_Poste.FieldByName('POS_MAGID').asInteger := que_Magasin.FieldByName('MAG_ID').asInteger;
    que_Poste.FieldByName('POS_NOM').asString := '';
    que_Poste.FieldByName('POS_INFO').asString := '';
    que_Poste.FieldByName('POS_COMPTA').asString := '';
END;

PROCEDURE TDm_ParamSoc.Que_PosteUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamSoc.Que_AdresseBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamSoc.Que_AdresseBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_ParamSoc.Que_AdresseUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_ParamSoc.Que_MagasinBeforePost(DataSet: TDataSet);
BEGIN
    IF que_Magasin.FieldByName('MAG_ENSEIGNE').asString = '' THEN
        que_Magasin.FieldByName('MAG_ENSEIGNE').asString := que_Magasin.FieldByName('MAG_NOM').asString;

    // Correction des param inexistant
    InitModeEnc(que_Societe.FieldByName('SOC_ID').asInteger, QUE_MAGASIN.FieldByName('MAG_ID').asInteger);

    // maj
    IF NOT Que_GENPARAM.Active THEN
    BEGIN
        Que_GENPARAM.Close;
        Que_GENPARAM.ParamByName('MAGID').asInteger := Que_Magasin.FieldByName('MAG_ID').asInteger;
        Que_GENPARAM.Open;
    END;
    IF Que_GENPARAM.FieldByName('PRM_MAGID').asInteger <> Que_Magasin.FieldByName('MAG_ID').asInteger THEN
    BEGIN
        Que_GENPARAM.Close;
        Que_GENPARAM.ParamByName('MAGID').asInteger := Que_Magasin.FieldByName('MAG_ID').asInteger;
        Que_GENPARAM.Open;
    END;
    Que_GENPARAM.EDIT;
    Que_GENPARAM.FieldByName('PRM_INTEGER').asInteger := que_Magasin.FieldByName('LOCATION').asInteger;
    Que_GENPARAM.Post;

    IF NOT Que_NiveauUtilisateur.Active THEN
    BEGIN
        Que_NiveauUtilisateur.Close;
        Que_NiveauUtilisateur.ParamByName('MAGID').asInteger := Que_Magasin.FieldByName('MAG_ID').asInteger;
        Que_NiveauUtilisateur.Open;
    END;
    Que_NiveauUtilisateur.EDIT;
    Que_NiveauUtilisateur.FieldByName('PRM_INTEGER').asInteger := que_Magasin.FieldByName('NIVEAU').asInteger;
    Que_NiveauUtilisateur.Post;

END;

PROCEDURE TDm_ParamSoc.Que_GENPARAMBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN ABORT;
END;

CONST
    L: ARRAY[0..14] OF STRING = ('Billet 500 EUR', 'Billet 200 EUR', 'Billet 100 EUR', 'Billet 50 EUR', 'Billet 20 EUR', 'Billet 10 EUR', 'Billet 5 EUR',
        'Pièce 2 EUR', 'Pièce 1 EUR', 'Pièce 50 cts', 'Pièce 20 cts', 'Pièce 10 cts', 'Pièce 5 cts', 'Pièce 2 cts', 'Pièce 1 cts');
    V: ARRAY[0..14] OF double = (500, 200, 100, 50, 20, 10, 5, 2, 1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01);

PROCEDURE TDm_ParamSoc.InitModeEnc(socid: integer; magid: integer);
VAR nvbqe: Boolean;
    i: integer;
BEGIN

    //Creation banque
    ibq_banque.Close;
    ibq_banque.parambyname('socid').asinteger := socid;
    ibq_banque.open;
    nvbqe := False;

    IF ibq_banque.isEmpty THEN
    BEGIN
        ibq_banque.insert;
        ibq_banque.fieldbyname('bqe_nom').asstring := CstLaBanque;
        ibq_banque.fieldbyname('bqe_socid').asinteger := socid;
        ibq_banque.fieldbyname('bqe_compta').asstring := '';
        ibq_banque.post;
        nvbqe := True;
    END;

    //Création du coffre
    ibq_coffre.Close;
    ibq_coffre.parambyname('magid').asinteger := magid;
    ibq_coffre.open;

    IF ibq_coffre.isEmpty THEN
    BEGIN
        ibq_coffre.insert;
        ibq_coffre.fieldbyname('Cff_nom').asstring := CstLeCoffre;
        ibq_coffre.fieldbyname('cff_magid').asinteger := magid;
        ibq_coffre.fieldbyname('cff_compta').asstring := '';
        ibq_coffre.post;
        nvbqe := True;
    END;

    ibq_mp.Close;
    ibq_mp.parambyname('magid').asinteger := magid;
    ibq_mp.open;

    IF ibq_mp.IsEmpty THEN
    BEGIN
    //********ESPECE************
        ibq_mp.insert;
        ibq_mp.fieldbyname('men_magid').asinteger := magid;
        ibq_mp.fieldbyname('men_nom').asstring := CstEspece;
        ibq_mp.fieldbyname('men_ident').asstring := CstEspece;
        ibq_mp.fieldbyname('men_bqeid').asinteger := ibq_banque.fieldbyname('bqe_Id').asinteger;
        ibq_mp.fieldbyname('men_cffid').asinteger := 0;
        ibq_mp.fieldbyname('men_ouvtiroir').asinteger := 1;
        ibq_mp.fieldbyname('men_montsup').asinteger := 1;
        ibq_mp.fieldbyname('men_verif').asinteger := 1;
        ibq_mp.fieldbyname('men_fondvari').asinteger := 1; //0
        ibq_mp.fieldbyname('men_typemod').asinteger := 4;
        ibq_mp.fieldbyname('men_typetrf').asinteger := 1; //0
        ibq_mp.fieldbyname('men_rapido').asinteger := 1;
        ibq_mp.fieldbyname('men_couleur').asstring := '1';
        ibq_mp.fieldbyname('MEN_CFFCENTRAL').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('MEN_TXCHANGE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_PRECISION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DETAIL').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DATEECH').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DOC').asinteger := 0;
        ibq_mp.fieldbyname('MEN_TPE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_APPLICATION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_REMISEOTO').asinteger := 0;

        ibq_mp.post;

        Que_CSHMODEENCDETAIL.Close;
        Que_CSHMODEENCDETAIL.Open;
        FOR i := 0 TO 14 DO
        BEGIN
            Que_CSHMODEENCDETAIL.Insert;
            Que_CSHMODEENCDETAIL.fieldbyname('MED_LIBELLE').asString := L[i];
            Que_CSHMODEENCDETAIL.fieldbyname('MED_MONTANT').asFloat := V[i];
            Que_CSHMODEENCDETAIL.fieldbyname('MED_MENID').asInteger := ibq_mp.fieldbyname('men_id').asinteger;
            Que_CSHMODEENCDETAIL.Post;
        END;
        //********Chèques************
        ibq_mp.insert;
        ibq_mp.fieldbyname('men_magid').asinteger := magid;
        ibq_mp.fieldbyname('men_nom').asstring := CstCheque;
        ibq_mp.fieldbyname('men_ident').asstring := CstCheque;
        ibq_mp.fieldbyname('men_bqeid').asinteger := ibq_banque.fieldbyname('bqe_Id').asinteger;
        ibq_mp.fieldbyname('men_cffid').asinteger := 0;
        ibq_mp.fieldbyname('men_ouvtiroir').asinteger := 1;
        ibq_mp.fieldbyname('men_montsup').asinteger := 0;
        ibq_mp.fieldbyname('men_verif').asinteger := 1;
        ibq_mp.fieldbyname('men_fondvari').asinteger := 0;
        ibq_mp.fieldbyname('men_typemod').asinteger := 5;
        ibq_mp.fieldbyname('men_typetrf').asinteger := 1;
        ibq_mp.fieldbyname('men_rapido').asinteger := 1;
        ibq_mp.fieldbyname('men_couleur').asstring := '2';
        ibq_mp.fieldbyname('men_raccourci').asstring := 'CHQ';
        ibq_mp.fieldbyname('MEN_CFFCENTRAL').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('MEN_TXCHANGE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_PRECISION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DETAIL').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DATEECH').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DOC').asinteger := 0;
        ibq_mp.fieldbyname('MEN_TPE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_APPLICATION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_REMISEOTO').asinteger := 0;

        ibq_mp.post;

        //********CB************
        ibq_mp.insert;
        ibq_mp.fieldbyname('men_magid').asinteger := magid;
        ibq_mp.fieldbyname('men_nom').asstring := CstCarteBleu;
        ibq_mp.fieldbyname('men_ident').asstring := 'CB';
        ibq_mp.fieldbyname('men_bqeid').asinteger := ibq_banque.fieldbyname('bqe_Id').asinteger;
        ibq_mp.fieldbyname('men_cffid').asinteger := 0;
        ibq_mp.fieldbyname('men_ouvtiroir').asinteger := 1;
        ibq_mp.fieldbyname('men_montsup').asinteger := 0;
        ibq_mp.fieldbyname('men_verif').asinteger := 0;
        ibq_mp.fieldbyname('men_fondvari').asinteger := 0;
        ibq_mp.fieldbyname('men_typemod').asinteger := 5;
        ibq_mp.fieldbyname('men_typetrf').asinteger := 1;
        ibq_mp.fieldbyname('men_rapido').asinteger := 1;
        ibq_mp.fieldbyname('men_couleur').asstring := '3';
        ibq_mp.fieldbyname('MEN_CFFCENTRAL').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('MEN_TXCHANGE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_PRECISION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DETAIL').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DATEECH').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DOC').asinteger := 0;
        ibq_mp.fieldbyname('MEN_TPE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_APPLICATION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_REMISEOTO').asinteger := 0;

        ibq_mp.post;

      //********Bon ACHAT INTERNE************
        ibq_mp.insert;
        ibq_mp.fieldbyname('men_magid').asinteger := magid;
        ibq_mp.fieldbyname('men_nom').asstring := cstBonAchInt;
        ibq_mp.fieldbyname('men_ident').asstring := 'BA INT.';
        ibq_mp.fieldbyname('men_bqeid').asinteger := 0;
        ibq_mp.fieldbyname('men_cffid').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('men_ouvtiroir').asinteger := 1;
        ibq_mp.fieldbyname('men_montsup').asinteger := 1;
        ibq_mp.fieldbyname('men_verif').asinteger := 1;
        ibq_mp.fieldbyname('men_fondvari').asinteger := 0;
        ibq_mp.fieldbyname('men_typemod').asinteger := 3;
        ibq_mp.fieldbyname('men_typetrf').asinteger := 0;
        ibq_mp.fieldbyname('men_rapido').asinteger := 0;
        ibq_mp.fieldbyname('men_couleur').asstring := '6';
        ibq_mp.fieldbyname('MEN_CFFCENTRAL').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('MEN_TXCHANGE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_PRECISION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DETAIL').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DATEECH').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DOC').asinteger := 0;
        ibq_mp.fieldbyname('MEN_TPE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_APPLICATION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_REMISEOTO').asinteger := 0;

        ibq_mp.post;

        //********Bon ACHAT Externe************
        ibq_mp.insert;
        ibq_mp.fieldbyname('men_magid').asinteger := magid;
        ibq_mp.fieldbyname('men_nom').asstring := cstBonAchExt;
        ibq_mp.fieldbyname('men_ident').asstring := 'BA EXT.';
        ibq_mp.fieldbyname('men_bqeid').asinteger := 0;
        ibq_mp.fieldbyname('men_cffid').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('men_ouvtiroir').asinteger := 1;
        ibq_mp.fieldbyname('men_montsup').asinteger := 0;
        ibq_mp.fieldbyname('men_verif').asinteger := 1;
        ibq_mp.fieldbyname('men_fondvari').asinteger := 0;
        ibq_mp.fieldbyname('men_typemod').asinteger := 5;
        ibq_mp.fieldbyname('men_typetrf').asinteger := 0;
        ibq_mp.fieldbyname('men_rapido').asinteger := 0;
        ibq_mp.fieldbyname('men_couleur').asstring := '7';
        ibq_mp.fieldbyname('MEN_CFFCENTRAL').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('MEN_TXCHANGE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_PRECISION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DETAIL').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DATEECH').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DOC').asinteger := 0;
        ibq_mp.fieldbyname('MEN_TPE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_APPLICATION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_REMISEOTO').asinteger := 0;

        ibq_mp.post;

        //********REMISE CF************
        ibq_mp.insert;
        ibq_mp.fieldbyname('men_magid').asinteger := magid;
        ibq_mp.fieldbyname('men_nom').asstring := CstRemiseFidelite;
        ibq_mp.fieldbyname('men_ident').asstring := 'REM CF';
        ibq_mp.fieldbyname('men_bqeid').asinteger := 0;
        ibq_mp.fieldbyname('men_cffid').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('men_ouvtiroir').asinteger := 0;
        ibq_mp.fieldbyname('men_montsup').asinteger := 0;
        ibq_mp.fieldbyname('men_verif').asinteger := 0;
        ibq_mp.fieldbyname('men_fondvari').asinteger := 0;
        ibq_mp.fieldbyname('men_typemod').asinteger := 3;
        ibq_mp.fieldbyname('men_typetrf').asinteger := 0;
        ibq_mp.fieldbyname('men_rapido').asinteger := 0;
        ibq_mp.fieldbyname('men_couleur').asstring := '8';
        ibq_mp.fieldbyname('MEN_CFFCENTRAL').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('MEN_TXCHANGE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_PRECISION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DETAIL').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DATEECH').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DOC').asinteger := 0;
        ibq_mp.fieldbyname('MEN_TPE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_APPLICATION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_REMISEOTO').asinteger := 0;

        ibq_mp.post;

        //********Compte client************
        ibq_mp.insert;
        ibq_mp.fieldbyname('men_magid').asinteger := magid;
        ibq_mp.fieldbyname('men_nom').asstring := CstCompteClient;
        ibq_mp.fieldbyname('men_ident').asstring := 'CPTES CLT';
        ibq_mp.fieldbyname('men_bqeid').asinteger := 0;
        ibq_mp.fieldbyname('men_cffid').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('men_ouvtiroir').asinteger := 0;
        ibq_mp.fieldbyname('men_montsup').asinteger := 0;
        ibq_mp.fieldbyname('men_verif').asinteger := 0;
        ibq_mp.fieldbyname('men_fondvari').asinteger := 0;
        ibq_mp.fieldbyname('men_typemod').asinteger := 1;
        ibq_mp.fieldbyname('men_typetrf').asinteger := 0;
        ibq_mp.fieldbyname('men_rapido').asinteger := 0;
        ibq_mp.fieldbyname('men_couleur').asstring := '9';
        ibq_mp.fieldbyname('MEN_CFFCENTRAL').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('MEN_TXCHANGE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_PRECISION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DETAIL').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DATEECH').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DOC').asinteger := 0;
        ibq_mp.fieldbyname('MEN_TPE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_APPLICATION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_REMISEOTO').asinteger := 0;

        ibq_mp.post;

        //********Reste du************
        ibq_mp.insert;
        ibq_mp.fieldbyname('men_magid').asinteger := magid;
        ibq_mp.fieldbyname('men_nom').asstring := CstResteDu;
        ibq_mp.fieldbyname('men_ident').asstring := CstResteDu;
        ibq_mp.fieldbyname('men_bqeid').asinteger := 0;
        ibq_mp.fieldbyname('men_cffid').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('men_ouvtiroir').asinteger := 0;
        ibq_mp.fieldbyname('men_montsup').asinteger := 0;
        ibq_mp.fieldbyname('men_verif').asinteger := 0;
        ibq_mp.fieldbyname('men_fondvari').asinteger := 0;
        ibq_mp.fieldbyname('men_typemod').asinteger := 1;
        ibq_mp.fieldbyname('men_typetrf').asinteger := 0;
        ibq_mp.fieldbyname('men_rapido').asinteger := 0;
        ibq_mp.fieldbyname('men_couleur').asstring := '10';
        ibq_mp.fieldbyname('MEN_CFFCENTRAL').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('MEN_TXCHANGE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_PRECISION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DETAIL').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DATEECH').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DOC').asinteger := 0;
        ibq_mp.fieldbyname('MEN_TPE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_APPLICATION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_REMISEOTO').asinteger := 0;

        ibq_mp.post;

        //********Autre carte************
        ibq_mp.insert;
        ibq_mp.fieldbyname('men_magid').asinteger := magid;
        ibq_mp.fieldbyname('men_nom').asstring := CstAutreCarte;
        ibq_mp.fieldbyname('men_ident').asstring := 'AUT. CTES';
        ibq_mp.fieldbyname('men_bqeid').asinteger := ibq_banque.fieldbyname('bqe_Id').asinteger;
        ibq_mp.fieldbyname('men_cffid').asinteger := 0;
        ibq_mp.fieldbyname('men_ouvtiroir').asinteger := 1;
        ibq_mp.fieldbyname('men_montsup').asinteger := 0;
        ibq_mp.fieldbyname('men_verif').asinteger := 1;
        ibq_mp.fieldbyname('men_fondvari').asinteger := 0;
        ibq_mp.fieldbyname('men_typemod').asinteger := 5;
        ibq_mp.fieldbyname('men_typetrf').asinteger := 1;
        ibq_mp.fieldbyname('men_rapido').asinteger := 0;
        ibq_mp.fieldbyname('men_couleur').asstring := '11';
        ibq_mp.fieldbyname('MEN_CFFCENTRAL').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('MEN_TXCHANGE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_PRECISION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DETAIL').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DATEECH').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DOC').asinteger := 0;
        ibq_mp.fieldbyname('MEN_TPE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_APPLICATION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_REMISEOTO').asinteger := 0;

        ibq_mp.post;

     //********VIREMENT************
        ibq_mp.insert;
        ibq_mp.fieldbyname('men_magid').asinteger := magid;
        ibq_mp.fieldbyname('men_nom').asstring := CstVirement;
        ibq_mp.fieldbyname('men_ident').asstring := CstVirement;
        ibq_mp.fieldbyname('men_bqeid').asinteger := ibq_banque.fieldbyname('bqe_Id').asinteger;
        ibq_mp.fieldbyname('men_cffid').asinteger := 0;
        ibq_mp.fieldbyname('men_ouvtiroir').asinteger := 0;
        ibq_mp.fieldbyname('men_montsup').asinteger := 0;
        ibq_mp.fieldbyname('men_verif').asinteger := 0;
        ibq_mp.fieldbyname('men_fondvari').asinteger := 0;
        ibq_mp.fieldbyname('men_typemod').asinteger := 5;
        ibq_mp.fieldbyname('men_typetrf').asinteger := 1;
        ibq_mp.fieldbyname('men_rapido').asinteger := 0;
        ibq_mp.fieldbyname('men_couleur').asstring := '12';
        ibq_mp.fieldbyname('MEN_CFFCENTRAL').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('MEN_TXCHANGE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_PRECISION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DETAIL').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DATEECH').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DOC').asinteger := 0;
        ibq_mp.fieldbyname('MEN_TPE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_APPLICATION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_REMISEOTO').asinteger := 0;

        ibq_mp.post;

    //********CHEQUES VANCANCES************
        ibq_mp.insert;
        ibq_mp.fieldbyname('men_magid').asinteger := magid;
        ibq_mp.fieldbyname('men_nom').asstring := CstChequeVacance;
        ibq_mp.fieldbyname('men_ident').asstring := 'CHQ VAC.';
        ibq_mp.fieldbyname('men_bqeid').asinteger := 0;
        ibq_mp.fieldbyname('men_cffid').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('men_ouvtiroir').asinteger := 1;
        ibq_mp.fieldbyname('men_montsup').asinteger := 0;
        ibq_mp.fieldbyname('men_verif').asinteger := 1;
        ibq_mp.fieldbyname('men_fondvari').asinteger := 0;
        ibq_mp.fieldbyname('men_typemod').asinteger := 5;
        ibq_mp.fieldbyname('men_typetrf').asinteger := 0;
        ibq_mp.fieldbyname('men_rapido').asinteger := 0;
        ibq_mp.fieldbyname('men_couleur').asstring := '13';
        ibq_mp.fieldbyname('MEN_CFFCENTRAL').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
        ibq_mp.fieldbyname('MEN_TXCHANGE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_PRECISION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DETAIL').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DATEECH').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DOC').asinteger := 0;
        ibq_mp.fieldbyname('MEN_TPE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_APPLICATION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_REMISEOTO').asinteger := 0;

        ibq_mp.post;

    //********PAIEMENT VAD************
        ibq_mp.insert;
        ibq_mp.fieldbyname('men_magid').asinteger := magid;
        ibq_mp.fieldbyname('men_nom').asstring := 'VAD RESERVATION';
        ibq_mp.fieldbyname('men_ident').asstring := 'VAD';
        ibq_mp.fieldbyname('men_bqeid').asinteger := ibq_banque.fieldbyname('bqe_Id').asinteger;
        ibq_mp.fieldbyname('men_cffid').asinteger := 0;
        ibq_mp.fieldbyname('men_ouvtiroir').asinteger := 0;
        ibq_mp.fieldbyname('men_montsup').asinteger := 0;
        ibq_mp.fieldbyname('men_verif').asinteger := 1;
        ibq_mp.fieldbyname('men_fondvari').asinteger := 0;
        ibq_mp.fieldbyname('men_typemod').asinteger := 5;
        ibq_mp.fieldbyname('men_typetrf').asinteger := 1;
        ibq_mp.fieldbyname('men_rapido').asinteger := 0;
        ibq_mp.fieldbyname('MEN_CFFCENTRAL').asinteger := 0;
        ibq_mp.fieldbyname('men_couleur').asstring := '0';
        ibq_mp.fieldbyname('MEN_TXCHANGE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_PRECISION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DETAIL').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DATEECH').asinteger := 0;
        ibq_mp.fieldbyname('MEN_DOC').asinteger := 0;
        ibq_mp.fieldbyname('MEN_TPE').asinteger := 0;
        ibq_mp.fieldbyname('MEN_APPLICATION').asinteger := 0;
        ibq_mp.fieldbyname('MEN_REMISEOTO').asinteger := 0;
        ibq_mp.post;
    END
    ELSE
    BEGIN
        IF nvbqe THEN // mettre à jour la bqe dans les modes d'encaissements
        BEGIN
            ibq_mp.First;
            WHILE NOT ibq_mp.Eof DO
            BEGIN
                ibq_mp.Edit;
                ibq_mp.fieldbyname('men_bqeid').asinteger := ibq_banque.fieldbyname('bqe_Id').asinteger;
                ibq_mp.fieldbyname('men_cffid').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
                ibq_mp.fieldbyname('MEN_CFFCENTRAL').asinteger := ibq_coffre.fieldbyname('cff_id').asinteger;
                ibq_mp.Post;
                ibq_mp.Next;
            END;
        END;
    END;

    ibq_mp.close;
    ibq_coffre.close;
    ibq_banque.close;
END;

END.

