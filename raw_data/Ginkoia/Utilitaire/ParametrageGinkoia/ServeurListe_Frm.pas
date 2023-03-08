//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           : Page standard d'une application "Page"
// Auteur         :
// Historique     :
// 20/08/2000 - Hervé PULLUARD - v 1.0.0 : Création
//------------------------------------------------------------------------------

{***************************************************************
   CTRL+TAB pour passer d'un onglet à l'autre.
   Contrôle du changement de page :
       Les formes de chaque page au standard TAlgolstdFrm ont une propriété "StdTag"
       qui est utilisé ici.
       Si StdTag de la page courante est >= 0 le changement de page est interdit
       Il nous suffit donc d'agir sur cette propriété pour contrôler...
       Rem : cela ne sert que dans une forme utilisée comme "page" ailleurs
       StdTag est aussi utilisé de la même façon pour inhiber les boutons de menus.

       Exception : la MainForm d'un projet page utilise StdTag pour contrôler
       le nombre de pages Maximum autorisé. Cela n'a aucune incidence puisque
       dans ce contexte la MainForm n'est jamais la forme active
       (au plus bas niveau c'est l'écran de contrôle qui est actif).

   ATTENTION : lorsque "StdTag" de la forme est >= 0 les "boutons de menu"
       dont le tag est >= 0 sont inhibés.
       Nota :
           1. StdTag par defaut = -1 c'est pourquoi je considère une valeur >= 0
           2. Par défaut tout nouveau bouton menu posé est inhibé car son Tag = 0.
              (Les boutons de menu des projets "modèles" ont tous leur tag mis
              à = -1 sauf quitter. Ils restent ainsi toujours actifs 'aide, tip ...etc.
           3. Cette solution nous permet de continuer à utiliser des valeurs absolues
              significatives pour les Tags et donc d'effectuer nos tests sur celle-ci.
              Cela nous évite aussi de mémoriser des valeurs de Tags pour les restituer
              en fin de traitement. Il suffit de d'inverser le signe du Tag momentanément
              pour obtenir le résultat souhaité

   ON NE PEUT PAS NON PLUS QUITTER une application "page" tant qu'il y a encore
   des pages ouvertes hors écran de contrôle.

   INTERDIRE L'OUVERTURE DE PLUSIEURS OCCURRENCES D'UNE PAGE :
   (seulement pour les TAlgolStdFrm)
   Mettre la propriété "OnlyOneInstance" à TRUE

   Numérotation des pages automatique sur les instances d'un même module

   Nota : le système fonctionne sans que les pages aient à déclarer la MainForm
   dans sa clause Uses. Toutefois il est évident que cela pourra être nécessaire
   pour d'autres motifs.

   Les Events Key des pages n'interceptent pas les touches système (flêches par exemple)

   On peut aussi utiliser le composant WindowList de LMD pour gérer les pages
   Une fenêtre pour changer (c'est automatique)
   Une fenêtre pour détruire (en sortie si execute on tue la page sélectée)

   **************************************************************************

   ATTENTION :
   *********
    PROCEDURES NON PRISES EN CHARGE par le composant Pages de LMD.
    NE PAS UTILISER

   1. procedure Form Deactivate
   2. procedure Form Activate
   3. procedure Form Close

   *************************************************************************** }

UNIT ServeurListe_Frm;

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
    AlgolStdFrm,
    LMDControl,
    LMDBaseControl,
    LMDBaseGraphicButton,
    LMDCustomSpeedButton,
    LMDSpeedButton,
    ExtCtrls,
    RzPanel,
    StdCtrls,
    LMDCustomScrollBox,
    LMDScrollBox,
    LMDCustomButton,
    LMDButton,
    RzLabel,
    RzStatus,
    fcStatusBar,
    dxCntner,
    dxTL,
    dxDBCtrl,
    dxDBGrid,
    dxDBGridRv,
    RzPanelRv,
    Db,
    IBoDataset,
    ActionRv,
    Buttons,
    DBSBtn,
    IB_Components,
    RzDBLbl,
    RzDBLabelRv,
    RzBorder, IB_StoredProc;

TYPE
    TFrm_ServeurListe = CLASS(TAlgolStdFrm)
        Pan_Page: TRzPanel;
        SBtn_Quit: TLMDSpeedButton;
        Lab_Caption: TRzLabel;
        Stat_Bar: TfcStatusBar;
        Clk_Status: TRzClockStatus;
        Tim_Focus: TTimer;
        Pan_FondForm: TRzPanelRv;
        Grd_Que: TGroupDataRv;
        Pan_Navserveur: TRzPanelRv;
        Pan_Nav: TRzPanel;
        Nbt_Insert: TDBSpeedButton;
        Nbt_Delete: TDBSpeedButton;
        Nbt_Edit: TDBSpeedButton;
        Nbt_Post: TDBSpeedButton;
        Nbt_Cancel: TDBSpeedButton;
        Nbt_Refresh: TDBSpeedButton;
        Dbg_Bases: TdxDBGridRv;
        Que_Bases: TIBOQuery;
        Que_Ident: TIBOQuery;
        Que_Nom: TIBOQuery;
        Ds_Bases: TDataSource;
        Dbg_BasesBAS_NOM: TdxDBGridColumn;
        Dbg_BasesBAS_IDENT: TdxDBGridColumn;
        Dbg_BasesBAS_JETON: TdxDBGridColumn;
        Dbg_BasesBAS_PLAGE: TdxDBGridColumn;
        RzPanelRv1: TRzPanelRv;
        Que_BasesBAS_ID: TIntegerField;
        Que_BasesBAS_NOM: TStringField;
        Que_BasesBAS_IDENT: TStringField;
        Que_BasesBAS_JETON: TIntegerField;
        Que_BasesBAS_PLAGE: TStringField;
        SBtn_ConfigBase: TLMDSpeedButton;
        RzLabel1: TRzLabel;
        RzLabel2: TRzLabel;
        RzLabel3: TRzLabel;
        RzLabel4: TRzLabel;
        Lab_Chemin: TRzLabel;
        Chp_Ident: TRzDBLabelRv;
        Chp_Nom: TRzDBLabelRv;
        Ds_ParamBase: TDataSource;
        Que_ParamBase: TIBOQuery;
        Que_Base: TIBOQuery;
        Ds_Base: TDataSource;
        RzLabel5: TRzLabel;
        RzLabel6: TRzLabel;
        Chp_Version: TRzDBLabelRv;
        RzDBLabelRv2: TRzDBLabelRv;
        Que_ParamBaseV: TIBOQuery;
        Ds_ParamBaseV: TDataSource;
        RzBorder1: TRzBorder;
    Nbt_Database: TLMDSpeedButton;
        Que_ParamBaseGEN_ID: TLargeintField;
        Que_ParamBasePAR_NOM: TStringField;
        Que_ParamBasePAR_STRING: TStringField;
        Que_ParamBasePAR_FLOAT: TIBOFloatField;
        Que_Dossier: TIBOQuery;
        Que_DossierDOS_ID: TIntegerField;
        Que_DossierDOS_NOM: TStringField;
        Que_DossierDOS_STRING: TStringField;
        Que_DossierDOS_FLOAT: TIBOFloatField;
    Que_Databse: TIBOQuery;
    Que_DatabseDOS_ID: TIntegerField;
    Que_DatabseDOS_NOM: TStringField;
    Que_DatabseDOS_STRING: TStringField;
    Que_DatabseDOS_FLOAT: TIBOFloatField;
    Que_DatabseDOS_CODE: TStringField;
    Que_BasesBAS_SENDER: TStringField;
    Que_BasesBAS_GUID: TStringField;
    Que_DossierDOS_CODE: TStringField;
    Que_ParamRepli: TIBOQuery;
    Que_ParamRepliPANTIN: TStringField;
    Que_ParamRepliSITE: TStringField;
    IbStProc_Initbase: TIB_StoredProc;
        PROCEDURE SBtn_QuitClick(Sender: TObject);
        PROCEDURE AlgolStdFrmShow(Sender: TObject);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
        PROCEDURE AlgolStdFrmCloseQuery(Sender: TObject;
            VAR CanClose: Boolean);
        PROCEDURE Tim_FocusTimer(Sender: TObject);
        PROCEDURE Que_BasesAfterPost(DataSet: TDataSet);
        PROCEDURE Que_BasesBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_BasesBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_BasesNewRecord(DataSet: TDataSet);
        PROCEDURE Que_BasesUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE SBtn_ConfigBaseClick(Sender: TObject);
        PROCEDURE Que_BasesBeforePost(DataSet: TDataSet);
        PROCEDURE Que_BasesBeforeInsert(DataSet: TDataSet);
        PROCEDURE Que_DossierAfterPost(DataSet: TDataSet);
        PROCEDURE Que_DossierBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_DossierBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_DossierNewRecord(DataSet: TDataSet);
        PROCEDURE Que_DossierUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    procedure Nbt_DatabaseClick(Sender: TObject);
    procedure GenerikAfterCancel(DataSet: TDataSet);
    procedure GenerikAfterPost(DataSet: TDataSet);
    procedure GenerikBeforeDelete(DataSet: TDataSet);
    procedure GenerikNewRecord(DataSet: TDataSet);
    procedure GenerikUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
    PRIVATE
    { Private declarations }
        Etat: Integer;
        BaseOld: STRING;
        FUNCTION IdentSuivant: STRING;
        FUNCTION TestNom(Name: STRING): Boolean;
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED
    { Published declarations }
    END;

VAR
    Frm_ServeurListe: TFrm_ServeurListe;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
RESOURCESTRING
    ErrNomServ = ' Le nom du serveur doit être composé d' + #39 + ' au moins un caractère';
    NomBaseExiste = ' Le site §0 existe déjà !';
    NomBaseVide = ' Le site doit avoir un nom !';

IMPLEMENTATION

USES GinkoiaStd,
    GinkoiaResStr,
    Main_Dm,
    InputChaine_Frm;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

FUNCTION TFrm_ServeurListe.IdentSuivant: STRING;
VAR cpt: Integer;
BEGIN
    Result := '';
    cpt := -1;
    Que_Ident.Open;
    WHILE NOT Que_Ident.eof DO
    BEGIN
        IF (Que_Ident.FieldByName('BAS_IDENT').asInteger > cpt) THEN
            cpt := Que_Ident.FieldByName('BAS_IDENT').asInteger;
        Que_Ident.next;
    END;
    Inc(cpt);
    Result := IntToStr(cpt);
    Que_Ident.Close;
END;

FUNCTION TFrm_ServeurListe.TestNom(Name: STRING): Boolean;
BEGIN
    //Result := True;
    Que_Nom.ParamByName('NOM').asString := Name;
    Que_Nom.Open;
    Result := Que_Nom.IsEmpty;
    Que_Nom.Close;
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TFrm_ServeurListe.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    Lab_caption.caption := Caption;

//  Positionner le contrôle ayant le focus au démarrage
//    CurCtrl := ;
//    Tim_Focus.Enabled := True;
    Grd_Que.open;
    Que_ParamBaseV.Last;

    Que_ParamBase.open;
    IF (Que_ParamBasePAR_STRING.asstring = '0') then
    begin
        Que_Databse.Open;
        IF not (Que_Databse.IsEmpty) then
        begin
             Nbt_Database.caption := Que_DatabseDOS_STRING.asString;
             Nbt_Database.Font.Color := clMaroon;
             Nbt_Database.Font.Style := [fsBold];
        END
    end
    else Nbt_Database.Enabled:=False;
    
END;

PROCEDURE TFrm_ServeurListe.SBtn_QuitClick(Sender: TObject);
VAR
    CanClose: Boolean;
BEGIN
    CanClose := True;
    AlgolStdFrmCloseQuery(Sender, CanClose);
    IF CanClose THEN BEGIN
        Grd_Que.close;
        KillAction.Execute;
    END;
END;

PROCEDURE TFrm_ServeurListe.AlgolStdFrmCloseQuery(Sender: TObject;
    VAR CanClose: Boolean);
BEGIN
    { Ici le code de contrôle de sortie. Cette procédure n'est pas exécutée
      par le composant Page de LMD lorsqu'il tue la forme mais je l'ai associée au
      bouton de fermeture qui sert à fermer l'onglet. L'utiliser donc normalement !

      Le code ci-dessous est une proposition standard, le modifier en fonction du
      cas particulier de l'application.
      CtrlCanClose retourne 0 si tout ok
                            1 si onglet courant à son stdTag mis
                            2 si outBar et que une page à son stdTag mis }

    CanClose := False;
    CASE CtrlCanClose OF
        0: CanClose := True;
        1: INFMESS(ErrPgTab, '');
        2:
            BEGIN
                INFMESS(ErrPgfc, '');
                ActiveFirstTagedFcPage; // active la page fc avec stdTag
            END;
    END;
    IF CanClose THEN Que_Databse.Close;
END;

PROCEDURE TFrm_ServeurListe.AlgolStdFrmShow(Sender: TObject);
BEGIN
    Tim_Focus.Enabled := True;
{ Remarque importante :
  Ici ne pas toucher à l'aspect visuel des composants de la forme car cela
  perturbe l'affichage. Le maximized au interne du composant ne se fait plus ... }
END;

PROCEDURE TFrm_ServeurListe.Tim_FocusTimer(Sender: TObject);
BEGIN
    Tim_Focus.Enabled := False;
    SetFocus;
    TRY
        IF CurCtrl <> NIL THEN
            CurCtrl.SetFocus;
    EXCEPT
    END;
    CurCtrl := NIL;
    Lab_Chemin.caption := StdGinkoia.iniCtrl.readString('DATABASE', 'PATH', '');

END;

PROCEDURE TFrm_ServeurListe.Que_BasesAfterPost(DataSet: TDataSet);
BEGIN
    // Noter que la base REPLIC
    Que_Dossier.Open;
    IF Que_Dossier.IsEmpty THEN
    BEGIN
        Que_Dossier.Insert;
        Que_DossierDOS_NOM.asString := 'REPLICATION';
        Que_DossierDOS_STRING.asString := 'OUI';
        Que_DossierDOS_FLOAT.asFloat := 1;
        Que_DossierDOS_CODE.asInteger := 2;
        Que_Dossier.Post;
    END
    ELSE IF (Que_DossierDOS_STRING.asString = 'NON') THEN
         BEGIN
            Que_Dossier.Edit;
            Que_DossierDOS_STRING.asString := 'OUI';
            Que_DossierDOS_FLOAT.asFloat := 1;
            Que_Dossier.Post;
         END;

    TRY Dm_Main.StartTransaction;
        Dm_Main.IBOUpDateCache(Que_Bases);
        Dm_Main.IBOUpDateCache(Que_Dossier);
        Dm_Main.Commit;
    EXCEPT
        Dm_Main.Rollback;
        Dm_Main.IBOCancelCache(Que_Bases);
        Dm_Main.IBOCancelCache(Que_Dossier);
    END;
    Dm_Main.IBOCommitCache(Que_Bases);
    Dm_Main.IBOCommitCache(Que_Dossier);
    Etat := 0;
    Que_Dossier.Close;


    IF (Que_BasesBAS_IDENT.asString <> '0') Then
    begin
        Que_ParamRepli.open;
        Dm_Main.StartTransaction;
        try
           IbStProc_Initbase.Close;
           IbStProc_Initbase.Prepare;
           IbStProc_Initbase.ParamByName('BAS_ID').asInteger := Que_BasesBAS_ID.asInteger;
           IbStProc_Initbase.ParamByName('PANTIN').asString := Que_ParamRepliPANTIN.asString;
           IbStProc_Initbase.ParamByName('LAVERSION').asString := Que_ParamRepliSITE.asString;
           IbStProc_Initbase.execSql;
           Dm_Main.Commit;
           IbStProc_Initbase.Unprepare;
           IbStProc_Initbase.Close;
        except
           Dm_Main.Rollback;
        END;
        Que_ParamRepli.close;
    END;

END;

PROCEDURE TFrm_ServeurListe.Que_BasesBeforeDelete(DataSet: TDataSet);
BEGIN
    Etat := 3;
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
    BaseOld := Que_Bases.FieldByName('BAS_NOM').AsString;
END;

PROCEDURE TFrm_ServeurListe.Que_BasesBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
    BaseOld := Que_Bases.FieldByName('BAS_NOM').AsString;
END;

PROCEDURE TFrm_ServeurListe.Que_BasesNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
    Que_Bases.FieldByName('BAS_IDENT').asString := IdentSuivant;
    Que_Bases.FieldByName('BAS_JETON').asInteger := 1;
//    Que_Bases.FieldByName('BAS_PLAGE').asString := '[0M_0M]';
END;

PROCEDURE TFrm_ServeurListe.Que_BasesUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_ServeurListe.SBtn_ConfigBaseClick(Sender: TObject);
BEGIN
     // configure la base sur la quelle on est connectée
     // pour qu'elle corresponde à la base séléctionnée dans la grille
    IF (Dbg_Bases.FocusedNode <> NIL) THEN
    BEGIN
        Dm_Main.PrepareScript('UPDATE GENPARAMBASE SET PAR_STRING=:STR WHERE PAR_NOM=:NOM');
        Dm_Main.SetScriptParameterValue('STR', Que_Bases.FieldByname('BAS_IDENT').asString);
        Dm_Main.SetScriptParameterValue('NOM', 'IDGENERATEUR');
        Dm_Main.ExecuteScript;
    END;
     // Peux-tu envisager de paramétrer la palge !!! c'est dangeureux
    Que_ParamBase.Close;
    Que_ParamBase.Open;
    Que_ParamBaseV.Close;
    Que_ParamBaseV.Open;
    Que_ParamBaseV.Last;

    Que_Base.Close;
    Que_Base.Open;
END;

PROCEDURE TFrm_ServeurListe.Que_BasesBeforePost(DataSet: TDataSet);
BEGIN
    Que_Bases.FieldByname('BAS_NOM').asString := Trim(Que_Bases.FieldByname('BAS_NOM').asString);
    // Tester sur Replic2 base de monitoring que le sender est UNIQUE ==> à faire
    Que_Bases.FieldByName('BAS_SENDER').asString := Que_Bases.FieldByName('BAS_NOM').asString;
    IF Etat <> 3 Then
    begin
        IF DataSet.State IN [dsEdit] THEN
           Etat := 2
        ELSE Etat := 1;
    END;

    IF (Que_Bases.FieldByname('BAS_NOM').asString <> '') THEN
    BEGIN
        IF Etat = 1 THEN
            IF NOT TestNom(Que_Bases.FieldByname('BAS_NOM').asString) THEN
            BEGIN
                ErrMess(NomBaseExiste, Que_Bases.FieldByname('BAS_NOM').asString);
                Abort;
            END;
    END
    ELSE BEGIN
        ErrMess(NomBaseVide, '');
        Abort;
    END;

    // Créer l aréplication pour cette base

END;

PROCEDURE TFrm_ServeurListe.Que_BasesBeforeInsert(DataSet: TDataSet);
BEGIN
    BaseOld := '';
END;

PROCEDURE TFrm_ServeurListe.Que_DossierAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_ServeurListe.Que_DossierBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TFrm_ServeurListe.Que_DossierBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TFrm_ServeurListe.Que_DossierNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN ABORT;
END;

PROCEDURE TFrm_ServeurListe.Que_DossierUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

procedure TFrm_ServeurListe.Nbt_DatabaseClick(Sender: TObject);
var chaine: String;
begin
   IF (Que_Databse.IsEmpty) then
   begin
        Chaine := '';
        InputChaine(Chaine,'Nom de la Database cible', 'Replication - paramétrage',32,TRUE);
        // Tester sur Replic2 base de monitoring que le Database est UNIQUE ==> à faire
        IF (Chaine <> '') then
        begin
           Que_Databse.Insert;
           Que_DatabseDOS_CODE.asInteger := 1;
           Que_DatabseDOS_NOM.asString := 'Database';
           Que_DatabseDOS_STRING.asString := Chaine;
           Que_Databse.Post;
           Nbt_Database.caption := Chaine;
           Nbt_Database.Font.Color := clMaroon;
           Nbt_Database.Font.Style := [fsBold];
        END;
   END
   else
   begin
      Chaine :=Que_DatabseDOS_STRING.asString;
      InputChaine(Chaine,'Nom de la Database cible', 'Replication - paramétrage',32,TRUE);
      // Tester sur Replic2 base de monitoring que le Database est UNIQUE ==> à faire
      IF (Chaine <> '') then
      begin
        Que_Databse.Edit;
        Que_DatabseDOS_STRING.asString := Chaine;
        Que_Databse.Post;
        Nbt_Database.caption := Chaine;
        Nbt_Database.Font.Color := clMaroon;
        Nbt_Database.Font.Style := [fsBold];
      END;
   END;
END;

procedure TFrm_ServeurListe.GenerikAfterCancel(DataSet: TDataSet);
begin
  Dm_Main.IBOCancelCache ( DataSet As TIBOQuery) ;
end;

procedure TFrm_ServeurListe.GenerikAfterPost(DataSet: TDataSet);
begin
  Dm_Main.IBOUpDateCache ( DataSet As TIBOQuery) ;
end;

procedure TFrm_ServeurListe.GenerikBeforeDelete(DataSet: TDataSet);
begin
{ A achever ...
    IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
    BEGIN
        StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
        ABORT;
    END;
}
end;

procedure TFrm_ServeurListe.GenerikNewRecord(DataSet: TDataSet);
begin
  if not Dm_Main.IBOMajPkKey ( ( DataSet As TIBODataSet),
  ( DataSet As TIBODataSet).KeyLinks.IndexNames[0] ) then Abort;
end;

procedure TFrm_ServeurListe.GenerikUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; var UpdateAction: TUpdateAction);
begin
  Dm_Main.IBOUpdateRecord ( ( DataSet As TIBODataSet).KeyRelation,
                          ( DataSet As TIBODataSet),UpdateKind, UpdateAction );
end;


END.

