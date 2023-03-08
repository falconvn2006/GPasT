//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Correction_Dm;

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
    IBoDataset,
    IB_Components, variants;

TYPE
    TDm_Correction = CLASS(TDataModule)
        Grd_Que: TGroupDataRv;
        IbC_ChercheTYPCDV: TIB_Cursor;
        Que_TYPCDV: TIBOQuery;
        Que_TYPCDVTYP_ID: TIntegerField;
        Que_TYPCDVTYP_LIB: TStringField;
        Que_TYPCDVTYP_COD: TIntegerField;
        Que_TYPCDVTYP_CATEG: TIntegerField;
        IbC_ChercheNegParam: TIB_Cursor;
        Que_NegParam: TIBOQuery;
        Que_NegParamNPR_ID: TIntegerField;
        Que_NegParamNPR_TYPE: TIntegerField;
        Que_NegParamNPR_LIBELLE: TStringField;
        Que_NegParamNPR_CODE: TIntegerField;
        PROCEDURE DataModuleCreate(Sender: TObject);
        PROCEDURE DataModuleDestroy(Sender: TObject);
        PROCEDURE Que_TYPCDVAfterPost(DataSet: TDataSet);
        PROCEDURE Que_TYPCDVBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_TYPCDVBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_TYPCDVNewRecord(DataSet: TDataSet);
        PROCEDURE Que_TYPCDVUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_NegParamAfterPost(DataSet: TDataSet);
        PROCEDURE Que_NegParamBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_NegParamBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_NegParamNewRecord(DataSet: TDataSet);
        PROCEDURE Que_NegParamUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_NegParamNPR_TYPEGetText(Sender: TField; VAR Text: STRING;
            DisplayText: Boolean);
        PROCEDURE Que_TYPCDVTYP_CATEGGetText(Sender: TField; VAR Text: STRING;
            DisplayText: Boolean);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        PROCEDURE Refresh;
        PROCEDURE TypCdv(code, cat: Integer; Nom: STRING);
        PROCEDURE EffaceTypCdv(code, Nom: STRING);
        PROCEDURE NegoceParam(code, cat: Integer; Nom: STRING);
        PROCEDURE LesTypesCDV;
        PROCEDURE LesTypesNegoce;
    END;

VAR
    Dm_Correction: TDm_Correction;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
RESOURCESTRING
    TypCdv101_5_10 = 'Pré-saison';
    TypCdv102_6_11 = 'Réassort';
    TypCdv103_7_12 = 'Opportunité';
    TypCdv104 = 'Annulation';
    TypCdv108 = 'Autres achats';
    TypCdv109 = 'Achat inter-mag';
    TypCdv1000 = 'Transfert inter-mag';
    TypCdv1001 = 'Rétrocession externe';
    TypCdv1002 = 'Retour fournisseur';
    TypCdv113 = 'Bon de livraison';
    TypCdv114 = 'Bon de prêt';
    TypCdv115 = 'Bon de réservation';
    TypCdv116 = 'Bon de dépôt';
    TypCdv117 = 'Bon de rétrocession';
    TypCdv27 = 'Ecart d''inventaire';
    TypCdv901 = 'Facture';
    TypCdv902 = 'Facture de rétrocession';
    NegPar100 = 'Modèle';
    NegPar101 = 'à faire';
    NegPar102 = 'En cours';
    NegPar103 = 'Refusé';
    NegPar104 = 'Remplacé';
    NegPar105 = 'Accepté (à faire)';
    NegPar106 = 'Accepté (en cours)';
    NegPar107 = 'Accepté (terminé)';
    NegPar202 = 'Devis vers facture';
    NegPar203 = 'Devis vers BL';
    NegPar204 = 'Devis vers Devis';
    NegPar205 = 'BL vers facture';

IMPLEMENTATION
USES GinkoiaSTd,
    GinkoiaResStr,
    Main_Dm;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

PROCEDURE TDm_Correction.Refresh;
BEGIN
    Grd_Que.Refresh;
END;

PROCEDURE TDm_Correction.TypCdv(code, cat: Integer; Nom: STRING);
BEGIN
    IbC_ChercheTYPCDV.Close;
    IbC_ChercheTYPCDV.ParamByName('PARAM').asInteger := code;
    IbC_ChercheTYPCDV.Open;
    IF IbC_ChercheTYPCDV.Eof THEN
    BEGIN
        Que_TYPCDV.Insert;
        Que_TYPCDVTYP_LIB.asString := Nom;
        Que_TYPCDVTYP_COD.asInteger := code;
        Que_TYPCDVTYP_CATEG.asInteger := cat;
        Que_TYPCDV.Post;
    END;
END;

PROCEDURE TDm_Correction.EffaceTypCdv(code, Nom: STRING);
BEGIN
    IF Que_TYPCDV.Locate('TYP_COD;TYP_LIB', vararrayof([code, nom]), []) THEN
    BEGIN
        Que_TYPCDV.Delete;
        Que_TYPCDV.Post;
    END;
END;

PROCEDURE TDm_Correction.NegoceParam(code, cat: Integer; Nom: STRING);
BEGIN
    IbC_ChercheNegParam.Close;
    IbC_ChercheNegParam.ParamByName('PARAM').asInteger := code;
    IbC_ChercheNegParam.Open;
    IF IbC_ChercheNegParam.Eof THEN
    BEGIN
        Que_NegParam.Insert;
        Que_NegParamNPR_LIBELLE.asString := Nom;
        Que_NegParamNPR_CODE.asInteger := code;
        Que_NegParamNPR_TYPE.asInteger := cat;
        Que_NegParam.Post;
    END;
END;

PROCEDURE TDm_Correction.LesTypesCDV;
BEGIN
    TypCdv(101, 1, TypCdv101_5_10);
    TypCdv(102, 1, TypCdv102_6_11);
    TypCdv(103, 1, TypCdv103_7_12);
    TypCdv(104, 1, TypCdv104);
    TypCdv(105, 2, TypCdv101_5_10);
    TypCdv(106, 2, TypCdv102_6_11);
    TypCdv(107, 2, TypCdv103_7_12);
    TypCdv(108, 2, TypCdv108);
    TypCdv(109, 2, TypCdv109);
    TypCdv(110, 3, TypCdv101_5_10);
    TypCdv(111, 3, TypCdv102_6_11);
    TypCdv(112, 3, TypCdv103_7_12);
    TypCdv(1000, 4, TypCdv1000);
    TypCdv(1001, 4, TypCdv1001);
    TypCdv(1002, 4, TypCdv1002);
    TypCdv(113, 6, TypCdv113);
    TypCdv(114, 6, TypCdv114);
    TypCdv(115, 6, TypCdv115);
    TypCdv(116, 6, TypCdv116);
    TypCdv(117, 6, TypCdv117);
    TypCdv(27, 7, TypCdv27);
    TypCdv(901, 9, TypCdv901);
    TypCdv(902, 9, TypCdv902);
    EffaceTypCdv('27', NegPar100);
    EffaceTypCdv('27', NegPar101);
    EffaceTypCdv('27', NegPar102);
    EffaceTypCdv('27', NegPar103);
    EffaceTypCdv('27', NegPar104);
    EffaceTypCdv('27', NegPar105);
    EffaceTypCdv('27', NegPar106);
    EffaceTypCdv('27', NegPar107);

    Que_TYPCDV.close;
    Que_TYPCDV.open;
END;

PROCEDURE TDm_Correction.LesTypesNegoce;
BEGIN
    NegoceParam(100, 1, NegPar100);
    NegoceParam(101, 1, NegPar101);
    NegoceParam(102, 1, NegPar102);
    NegoceParam(103, 1, NegPar103);
    NegoceParam(104, 1, NegPar104);
    NegoceParam(105, 1, NegPar105);
    NegoceParam(106, 1, NegPar106);
    NegoceParam(107, 1, NegPar107);

    NegoceParam(202, 2, NegPar202);
    NegoceParam(203, 2, NegPar203);
    NegoceParam(204, 2, NegPar204);
    NegoceParam(205, 2, NegPar205);

    Que_NegParam.close;
    Que_NegParam.Open;
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TDm_Correction.DataModuleCreate(Sender: TObject);
BEGIN
    Grd_Que.Open;
END;

PROCEDURE TDm_Correction.DataModuleDestroy(Sender: TObject);
BEGIN
    Grd_Que.Close;
END;

PROCEDURE TDm_Correction.Que_TYPCDVAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_Correction.Que_TYPCDVBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Correction.Que_TYPCDVBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Correction.Que_TYPCDVNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_Correction.Que_TYPCDVUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_Correction.Que_NegParamAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_Correction.Que_NegParamBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Correction.Que_NegParamBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Correction.Que_NegParamNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_Correction.Que_NegParamUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_Correction.Que_NegParamNPR_TYPEGetText(Sender: TField;
    VAR Text: STRING; DisplayText: Boolean);
BEGIN
    IF (Sender.value = 1) THEN Text := 'Devis';
    IF (Sender.value = 2) THEN Text := 'Transfert';
END;

PROCEDURE TDm_Correction.Que_TYPCDVTYP_CATEGGetText(Sender: TField;
    VAR Text: STRING; DisplayText: Boolean);
BEGIN
    IF (Sender.value = 1) THEN Text := 'Commande';
    IF (Sender.value = 2) THEN Text := 'Achats';
    IF (Sender.value = 3) THEN Text := 'R à L';
    IF (Sender.value = 4) THEN Text := 'Rétrocessions';
    IF (Sender.value = 5) THEN Text := 'Ventes';
    IF (Sender.value = 6) THEN Text := 'BL et prêts';
    IF (Sender.value = 7) THEN Text := 'Démarque';
    IF (Sender.value = 9) THEN Text := 'Facture ordinaire';
END;

END.

