//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Ajout_Dm;

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
    IB_Components,
    variants;

TYPE
    TDm_Ajout = CLASS(TDataModule)
        Grd_Que: TGroupDataRv;
        Genbases: TIBOQuery;
        Genparambase: TIBOQuery;
        GenparambasePAR_NOM: TStringField;
        GenparambasePAR_STRING: TStringField;
        GenparambasePAR_FLOAT: TIBOFloatField;
        UilPerm: TIBOQuery;
        UilPermPER_ID: TIntegerField;
        UilPermPER_PERMISSION: TStringField;
        UilPermPER_VISIBLE: TIntegerField;
        UilPermPER_MAGASIN: TIntegerField;
        UilGroupAccess: TIBOQuery;
        UilGroupAccessGRA_ID: TIntegerField;
        UilGroupAccessGRA_GROUPNAME: TStringField;
        UilGroupAccessGRA_PERMISSION: TStringField;
        IbC_User: TIB_Cursor;
        Que_Gendossier: TIBOQuery;
        Que_GendossierDOS_ID: TIntegerField;
        Que_GendossierDOS_NOM: TStringField;
        Que_GendossierDOS_STRING: TStringField;
        Que_GendossierDOS_FLOAT: TIBOFloatField;
        Que_User0: TIBOQuery;
        Que_User0USR_ID: TIntegerField;
        Que_User0USR_USERNAME: TStringField;
        Que_User0USR_FULLNAME: TStringField;
        Que_User0USR_PASSWORD: TStringField;
        Que_User0USR_LASTACCESSDATE: TDateTimeField;
        Que_User0USR_LASTACCESSTIME: TDateTimeField;
        Que_User0USR_ACCESSCOUNT: TIntegerField;
        Que_User0USR_CREATEDATE: TDateTimeField;
        Que_User0USR_CREATETIME: TDateTimeField;
        Que_User0USR_ENABLED: TIntegerField;
        Que_User0USR_MAGASIN: TIntegerField;
        Que_GroupMemberShip: TIBOQuery;
        Que_GroupMemberShipGRM_ID: TIntegerField;
        Que_GroupMemberShipGRM_USERNAME: TStringField;
        Que_GroupMemberShipGRM_GROUPNAME: TStringField;
        PROCEDURE DataModuleCreate(Sender: TObject);
        PROCEDURE DataModuleDestroy(Sender: TObject);
        PROCEDURE UilPermAfterPost(DataSet: TDataSet);
        PROCEDURE UilPermBeforeDelete(DataSet: TDataSet);
        PROCEDURE UilPermBeforeEdit(DataSet: TDataSet);
        PROCEDURE UilPermNewRecord(DataSet: TDataSet);
        PROCEDURE UilPermUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE UilGroupAccessAfterPost(DataSet: TDataSet);
        PROCEDURE UilGroupAccessBeforeDelete(DataSet: TDataSet);
        PROCEDURE UilGroupAccessBeforeEdit(DataSet: TDataSet);
        PROCEDURE UilGroupAccessNewRecord(DataSet: TDataSet);
        PROCEDURE UilGroupAccessUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_GendossierAfterPost(DataSet: TDataSet);
        PROCEDURE Que_GendossierBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_GendossierBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_GendossierNewRecord(DataSet: TDataSet);
        PROCEDURE Que_GendossierUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_User0AfterPost(DataSet: TDataSet);
        PROCEDURE Que_User0BeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_User0BeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_User0UpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Que_GroupMemberShipAfterPost(DataSet: TDataSet);
        PROCEDURE Que_GroupMemberShipBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_GroupMemberShipBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_GroupMemberShipNewRecord(DataSet: TDataSet);
        PROCEDURE Que_GroupMemberShipUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
        PROCEDURE Refresh;
        PROCEDURE CreerPermissions;
        PROCEDURE CreerPermissionsGroup;
        PROCEDURE User0;
        PROCEDURE AddPermission(PER: STRING; MAG: Integer);
        PROCEDURE AddGroup(PER, GRP: STRING);
    END;

VAR
    Dm_Ajout: TDm_Ajout;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

IMPLEMENTATION
USES GinkoiaSTd,
    GinkoiaResStr,
    Main_Dm;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

PROCEDURE TDm_Ajout.Refresh;
BEGIN
    Grd_Que.Refresh;
END;

PROCEDURE TDm_Ajout.User0;
BEGIN
    IF IbC_User.RecordCount = 0 THEN
    BEGIN
        Que_User0.Open;
        Que_User0.Insert;
        Que_User0USR_ID.asInteger := 0;
        Que_User0USR_USERNAME.AsString := '.';
        Que_User0USR_CREATEDATE.AsDateTime := now;
        Que_User0USR_ENABLED.asInteger := 1;
        Que_User0USR_MAGASIN.asInteger := 0;
        Que_User0.Post;
        Que_User0.Close;
    END;

    IF NOT Que_GroupMemberShip.Locate('GRM_USERNAME;GRM_GROUPNAME', vararrayof(['algol', 'PATRON']), []) THEN
    BEGIN
        Que_GroupMemberShip.Insert;
        Que_GroupMemberShipGRM_USERNAME.asString := 'algol';
        Que_GroupMemberShipGRM_GROUPNAME.asSTring := 'PATRON';
        Que_GroupMemberShip.Post;
    END;
    IF NOT Que_GroupMemberShip.Locate('GRM_USERNAME;GRM_GROUPNAME', vararrayof(['algol', 'CHEF RAYON']), []) THEN
    BEGIN
        Que_GroupMemberShip.Insert;
        Que_GroupMemberShipGRM_USERNAME.asString := 'algol';
        Que_GroupMemberShipGRM_GROUPNAME.asSTring := 'CHEF RAYON';
        Que_GroupMemberShip.Post;
    END;
    IF NOT Que_GroupMemberShip.Locate('GRM_USERNAME;GRM_GROUPNAME', vararrayof(['algol', 'VENDEUR']), []) THEN
    BEGIN
        Que_GroupMemberShip.Insert;
        Que_GroupMemberShipGRM_USERNAME.asString := 'algol';
        Que_GroupMemberShipGRM_GROUPNAME.asSTring := 'VENDEUR';
        Que_GroupMemberShip.Post;
    END;
    IF NOT Que_GroupMemberShip.Locate('GRM_USERNAME;GRM_GROUPNAME', vararrayof(['algol', 'CAISSIER']), []) THEN
    BEGIN
        Que_GroupMemberShip.Insert;
        Que_GroupMemberShipGRM_USERNAME.asString := 'algol';
        Que_GroupMemberShipGRM_GROUPNAME.asSTring := 'CAISSIER';
        Que_GroupMemberShip.Post;
    END;

    IF NOT Que_GroupMemberShip.Locate('GRM_USERNAME;GRM_GROUPNAME', vararrayof(['util', 'PATRON']), []) THEN
    BEGIN
        Que_GroupMemberShip.Insert;
        Que_GroupMemberShipGRM_USERNAME.asString := 'util';
        Que_GroupMemberShipGRM_GROUPNAME.asSTring := 'PATRON';
        Que_GroupMemberShip.Post;
    END;
    IF NOT Que_GroupMemberShip.Locate('GRM_USERNAME;GRM_GROUPNAME', vararrayof(['util', 'CHEF RAYON']), []) THEN
    BEGIN
        Que_GroupMemberShip.Insert;
        Que_GroupMemberShipGRM_USERNAME.asString := 'util';
        Que_GroupMemberShipGRM_GROUPNAME.asSTring := 'CHEF RAYON';
        Que_GroupMemberShip.Post;
    END;
    IF NOT Que_GroupMemberShip.Locate('GRM_USERNAME;GRM_GROUPNAME', vararrayof(['util', 'VENDEUR']), []) THEN
    BEGIN
        Que_GroupMemberShip.Insert;
        Que_GroupMemberShipGRM_USERNAME.asString := 'util';
        Que_GroupMemberShipGRM_GROUPNAME.asSTring := 'VENDEUR';
        Que_GroupMemberShip.Post;
    END;
    IF NOT Que_GroupMemberShip.Locate('GRM_USERNAME;GRM_GROUPNAME', vararrayof(['util', 'CAISSIER']), []) THEN
    BEGIN
        Que_GroupMemberShip.Insert;
        Que_GroupMemberShipGRM_USERNAME.asString := 'util';
        Que_GroupMemberShipGRM_GROUPNAME.asSTring := 'CAISSIER';
        Que_GroupMemberShip.Post;
    END;

END;

PROCEDURE TDm_Ajout.CreerPermissions;
BEGIN
//    MessageDlg('Lancement de la création des permissions !', mtInformation, [mbOK], 0);

//  if Genbases.Locate('BAS_IDENT','0',[]) and (GenparambasePAR_STRING.asString <> '0') then
//  begin
//       MessageDlg('Vous devez être sur le serveur de Pantin pour créer ces droits !!', mtError, [mbOK], 0);
//       exit;
//  end;
//    TRY
//        screen.Cursor := CrSQLWait;
//      // Dans tous les autre cas on créer les nouvelles permissions
//        AddPermission(UILModif_BonBcde, 0);
//        AddPermission(UILModif_BonRecep, 0);
//        AddPermission(UILModif_TrsfMM, 0);
//        AddPermission(UILModif_FicheArt, 0);
//        AddPermission(UILModif_LaNK, 0);
//        AddPermission(UILModif_Fourn, 0);
//        AddPermission(UILModif_ConsoDiv, 0);
//        AddPermission(UILModif_TarVente, 0);
//        AddPermission(UILModif_Clt, 0);
//        AddPermission(UILModif_Livr, 0);
//        AddPermission(UILModif_Devis, 0);
//        AddPermission(UILModif_Fact, 0);
//        AddPermission(UILVoir_Tarif, 0);
//        AddPermission(UILVoir_Mags, 0);
//        AddPermission(UILVoir_StockMags, 0);
//        AddPermission(UILCaisse_Cloturer, 0);
//        AddPermission(UILCaisse_SupprTik, 0);
//        AddPermission(UILCaisse_EncTikNeg, 0);
//        AddPermission(UILCaisse_AnnulTik, 0);
//        AddPermission(UILCaisse_SupprOldTik, 0);
//        AddPermission(UILCaisse_VteSoldee, 0);
//        AddPermission(UILCaisse_VtePromo, 0);
//        AddPermission(UILCaisse_VteRemise, 0);
//        AddPermission(UILCaisse_RetClient, 0);
//        AddPermission(UILCaisse_FicheClient, 0);
//        AddPermission(UILCaisse_ReajCF, 0);
//        AddPermission(UILCaisse_Training, 0);
//        AddPermission(UILCaisse_ParamModeEnc, 0);
//        AddPermission(UILCaisse_ParamBtn, 0);
//        AddPermission(UILCaisse_OngletUtil, 0);
//        AddPermission(UILCaisse_OuvManu, 0);
//        AddPermission(UILCaisse_SaisirDepense, 0);
//        AddPermission(UILCaisse_RembClt, 0);
//        AddPermission(UILMenu_ListeTik, 0);
//        AddPermission(UILMenu_RecapCaisse, 0);
//        AddPermission(UILMenu_JournalVte, 0);
//        AddPermission(UILMenu_CAHorDate, 0);
//        AddPermission(UILMenu_HitParade, 0);
//        AddPermission(UILMenu_AnalyseSynth, 0);
//        AddPermission(UILMenu_CAVend, 0);
//        AddPermission(UILMenu_CAHorVend, 0);
//        AddPermission(UILMenu_CltSolde, 0);
//        AddPermission(UILMenu_Fourn, 0);
//        AddPermission(UILMenu_Cde, 0);
//        AddPermission(UILMenu_CarnetCde, 0);
//        AddPermission(UILMenu_FicheArt, 0);
//        AddPermission(UILMenu_ConsoDiv, 0);
//        AddPermission(UILMenu_TarifVente, 0);
//        AddPermission(UILMenu_EtikDiff, 0);
//        AddPermission(UILMenu_EtatStock, 0);
//        AddPermission(UILMenu_EtatStockDate, 0);
//        AddPermission(UILMenu_EtatStockDetail, 0);
//        AddPermission(UILMenu_ListArtRef, 0);
//        AddPermission(UILMenu_ListArtRefDetail, 0);
//        AddPermission(UILMenu_ListCtlg, 0);
//        AddPermission(UILMenu_Recept, 0);
//        AddPermission(UILMenu_TrsfMM, 0);
//        AddPermission(UILMenu_Inventaire, 0);
//        AddPermission(UILMenu_Clt, 0);
//        AddPermission(UILMenu_Devis, 0);
//        AddPermission(UILMenu_Livraison, 0);
//        AddPermission(UILMenu_Facture, 0);
//        AddPermission(UILMenu_OrgEtps, 0);
//        AddPermission(UILMenu_ParamTva, 0);
//        AddPermission(UILMenu_ParamExeComm, 0);
//        AddPermission(UILMenu_ParamEtik, 0);
//        AddPermission(UILMenu_ParamNK, 0);
//        AddPermission(UILMenu_GrilleTaille, 0);
//        AddPermission(UILMenu_ParamGenre, 0);
//        AddPermission(UILMenu_ParamCF, 0);
//        AddPermission(UILMenu_ParamEncaiss, 0);
//        AddPermission(UILMenu_EditNegoce, 0);
//        AddPermission(UILMenu_PersoBarreOutil, 0);
//        AddPermission(UILMenu_DroitUtil, 0);
//    FINALLY
//        screen.Cursor := CrDefault;
//    END;
//    MessageDlg('Fin de création des permissions !!', mtInformation, [mbOK], 0);
END;

PROCEDURE TDm_Ajout.CreerPermissionsGroup;
BEGIN
//    MessageDlg('Lancement de la création des droits aux groupes !', mtInformation, [mbOK], 0);
////  if Genbases.Locate('BAS_IDENT','0',[]) and (GenparambasePAR_STRING.asString <> '0') then
////  begin
//  //  AddGroup('FOURNISSEUR - MODIFICATION', 'ALGOL');
//    TRY
//        screen.Cursor := CrSQLWait;
//  // Dans tous les autre cas on créer les nouvelles permissions
//        AddGroup(UILModif_BonBcde, 'CHEF RAYON');
//        AddGroup(UILModif_BonBcde, 'VENDEUR');
//        AddGroup(UILModif_BonRecep, 'CHEF RAYON');
//        AddGroup(UILModif_BonRecep, 'VENDEUR');
//        AddGroup(UILModif_TrsfMM, 'CHEF RAYON');
//        AddGroup(UILModif_FicheArt, 'CHEF RAYON');
//        AddGroup(UILModif_LaNK, 'PATRON');
//        AddGroup(UILModif_Fourn, 'CHEF RAYON');
//        AddGroup(UILModif_ConsoDiv, 'PATRON');
//        AddGroup(UILModif_TarVente, 'CHEF RAYON');
//        AddGroup(UILModif_Clt, 'VENDEUR');
//        AddGroup(UILModif_Livr, 'VENDEUR');
//        AddGroup(UILModif_Livr, 'CAISSIER');
//        AddGroup(UILModif_Devis, 'VENDEUR');
//        AddGroup(UILModif_Devis, 'CAISSIER');
//        AddGroup(UILModif_Fact, 'VENDEUR');
//        AddGroup(UILModif_Fact, 'CAISSIER');
//        AddGroup(UILVoir_Tarif, 'CHEF RAYON');
//        AddGroup(UILVoir_Mags, 'PATRON');
//        AddGroup(UILVoir_StockMags, 'PATRON');
//        AddGroup(UILCaisse_Cloturer, 'VENDEUR');
//        AddGroup(UILCaisse_Cloturer, 'CAISSIER');
//        AddGroup(UILCaisse_SupprTik, 'VENDEUR');
//        AddGroup(UILCaisse_SupprTik, 'CAISSIER');
//        AddGroup(UILCaisse_EncTikNeg, 'VENDEUR');
//        AddGroup(UILCaisse_EncTikNeg, 'CAISSIER');
//        AddGroup(UILCaisse_AnnulTik, 'VENDEUR');
//        AddGroup(UILCaisse_AnnulTik, 'CAISSIER');
//        AddGroup(UILCaisse_SupprOldTik, 'PATRON');
//        AddGroup(UILCaisse_VteSoldee, 'VENDEUR');
//        AddGroup(UILCaisse_VteSoldee, 'CAISSIER');
//        AddGroup(UILCaisse_VtePromo, 'VENDEUR');
//        AddGroup(UILCaisse_VtePromo, 'CAISSIER');
//        AddGroup(UILCaisse_VteRemise, 'VENDEUR');
//        AddGroup(UILCaisse_VteRemise, 'CAISSIER');
//        AddGroup(UILCaisse_RetClient, 'VENDEUR');
//        AddGroup(UILCaisse_RetClient, 'CAISSIER');
//        AddGroup(UILCaisse_FicheClient, 'VENDEUR');
//        AddGroup(UILCaisse_FicheClient, 'CAISSIER');
//        AddGroup(UILCaisse_ReajCF, 'PATRON');
//        AddGroup(UILCaisse_Training, 'PATRON');
//        AddGroup(UILCaisse_ParamModeEnc, 'PATRON');
//        AddGroup(UILCaisse_ParamBtn, 'PATRON');
//        AddGroup(UILCaisse_OngletUtil, 'PATRON');
//        AddGroup(UILCaisse_OuvManu, 'VENDEUR');
//        AddGroup(UILCaisse_OuvManu, 'CAISSIER');
//        AddGroup(UILCaisse_SaisirDepense, 'PATRON');
//        AddGroup(UILCaisse_RembClt, 'PATRON');
//        AddGroup(UILMenu_ListeTik, 'VENDEUR');
//        AddGroup(UILMenu_ListeTik, 'CAISSIER');
//        AddGroup(UILMenu_RecapCaisse, 'VENDEUR');
//        AddGroup(UILMenu_RecapCaisse, 'CAISSIER');
//        AddGroup(UILMenu_JournalVte, 'CHEF RAYON');
//        AddGroup(UILMenu_CAHorDate, 'PATRON');
//        AddGroup(UILMenu_HitParade, 'CHEF RAYON');
//        AddGroup(UILMenu_AnalyseSynth, 'CHEF RAYON');
//        AddGroup(UILMenu_CAVend, 'PATRON');
//        AddGroup(UILMenu_CAHorVend, 'PATRON');
//        AddGroup(UILMenu_CltSolde, 'VENDEUR');
//        AddGroup(UILMenu_Fourn, 'CHEF RAYON');
//        AddGroup(UILMenu_Cde, 'CHEF RAYON');
//        AddGroup(UILMenu_CarnetCde, 'CHEF RAYON');
//        AddGroup(UILMenu_FicheArt, 'CHEF RAYON');
//        AddGroup(UILMenu_ConsoDiv, 'PATRON');
//        AddGroup(UILMenu_TarifVente, 'PATRON');
//        AddGroup(UILMenu_EtikDiff, 'CHEF RAYON');
//        AddGroup(UILMenu_EtatStock, 'CHEF RAYON');
//        AddGroup(UILMenu_EtatStockDate, 'CHEF RAYON');
//        AddGroup(UILMenu_EtatStockDetail, 'CHEF RAYON');
//        AddGroup(UILMenu_ListArtRef, 'CHEF RAYON');
//        AddGroup(UILMenu_ListArtRefDetail, 'CHEF RAYON');
//        AddGroup(UILMenu_ListCtlg, 'CHEF RAYON');
//        AddGroup(UILMenu_Recept, 'CHEF RAYON');
//        AddGroup(UILMenu_TrsfMM, 'CHEF RAYON');
//        AddGroup(UILMenu_Inventaire, 'CHEF RAYON');
//        AddGroup(UILMenu_Clt, 'VENDEUR');
//        AddGroup(UILMenu_Devis, 'VENDEUR');
//        AddGroup(UILMenu_Livraison, 'VENDEUR');
//        AddGroup(UILMenu_Facture, 'VENDEUR');
//        AddGroup(UILMenu_OrgEtps, 'PATRON');
//        AddGroup(UILMenu_ParamTva, 'PATRON');
//        AddGroup(UILMenu_ParamExeComm, 'PATRON');
//        AddGroup(UILMenu_ParamEtik, 'CHEF RAYON');
//        AddGroup(UILMenu_ParamNK, 'PATRON');
//        AddGroup(UILMenu_GrilleTaille, 'PATRON');
//        AddGroup(UILMenu_ParamGenre, 'PATRON');
//        AddGroup(UILMenu_ParamCF, 'PATRON');
//        AddGroup(UILMenu_ParamEncaiss, 'PATRON');
//        AddGroup(UILMenu_EditNegoce, 'CHEF RAYON');
//        AddGroup(UILMenu_PersoBarreOutil, 'PATRON');
//        AddGroup(UILMenu_DroitUtil, 'PATRON');
//    FINALLY
//        screen.Cursor := CrDefault;
//    END;
//
//    MessageDlg('Fin de création des droits aux groupes !!', mtInformation, [mbOK], 0);
////  end
////  else MessageDlg('Vous ne devez pas être sur le serveur de Pantin pour créer les droits des groupes !!', mtError, [mbOK], 0);
END;

PROCEDURE TDm_Ajout.AddPermission(PER: STRING; MAG: Integer);
BEGIN
    IF NOT UilPerm.Locate('PER_PERMISSION', PER, []) THEN
    BEGIN
        UilPerm.Insert;
        UilPermPER_PERMISSION.asString := PER;
        UilPermPER_VISIBLE.asInteger := 0;
        UilPermPER_MAGASIN.asInteger := MAG;
        UilPerm.Post;
    END;
END;

PROCEDURE TDm_Ajout.AddGroup(PER, GRP: STRING);
BEGIN
    IF NOT UilGroupAccess.Locate('GRA_PERMISSION,GRA_GROUPNAME', vararrayof([PER, GRP]), []) THEN
    BEGIN
       // Contrôle que le droit existe bien
        IF NOT UilPerm.Locate('PER_PERMISSION', PER, []) THEN
            MessageDlg('Attention le droit ' + PER + ' n''existe pas !', mtInformation, [mbOK], 0)
        ELSE
        BEGIN
            UilGroupAccess.Insert;
            UilGroupAccessGRA_GROUPNAME.asString := GRP;
            UilGroupAccessGRA_PERMISSION.asString := PER;
            UilGroupAccess.Post;
        END;
    END;
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TDm_Ajout.DataModuleCreate(Sender: TObject);
BEGIN
    Grd_Que.Open;
END;

PROCEDURE TDm_Ajout.DataModuleDestroy(Sender: TObject);
BEGIN
    Grd_Que.Close;
END;

PROCEDURE TDm_Ajout.UilPermAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_Ajout.UilPermBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Ajout.UilPermBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Ajout.UilPermNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_Ajout.UilPermUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_Ajout.UilGroupAccessAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_Ajout.UilGroupAccessBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Ajout.UilGroupAccessBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Ajout.UilGroupAccessNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_Ajout.UilGroupAccessUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_Ajout.Que_GendossierAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_Ajout.Que_GendossierBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Ajout.Que_GendossierBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Ajout.Que_GendossierNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_Ajout.Que_GendossierUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_Ajout.Que_User0AfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_Ajout.Que_User0BeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Ajout.Que_User0BeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Ajout.Que_User0UpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TDm_Ajout.Que_GroupMemberShipAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TDm_Ajout.Que_GroupMemberShipBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Ajout.Que_GroupMemberShipBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TDm_Ajout.Que_GroupMemberShipNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TDm_Ajout.Que_GroupMemberShipUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

END.

