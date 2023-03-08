{***************************************************************
 *
 * Unit Name: ParamSoc_Frm
 * Purpose  :
 * Author   :
 * History  :
 *
 ****************************************************************}

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

UNIT ParamSoc_Frm;

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
    wwDialog,
    wwidlg,
    wwLookupDialogRv,
    Db,
    ParamSoc_Dm,
    DBCtrls,
    RzDBEdit,
    RzDBBnEd,
    RzDBButtonEditRv,
    dxCntner,
    dxExEdtr,
    dxEdLib,
    dxDBELib,
    dxDBCheckEditRv,
    RzRadGrp,
    RzDBRGrp,
    RzDBRadioGroupRv,
    Buttons,
    DBSBtn,
    wwdbdatetimepicker,
    wwDBDateTimePickerRv,
    Mask,
    wwdbedit,
    wwDBEditRv,
    RzPanelRv,
    ComCtrls,
    vgCtrls,
    vgPageControlRv,
    dxTL,
    dxDBCtrl,
    dxDBGrid,
    dxDBGridRv,
    dxMasterView,
    dxMasterViewRv,
    dxMasterViewColumns, Wwdotdot, Wwdbcomb, wwDBComboBoxRv, RzBorder,
    IBoDataset,variants;

TYPE
    TFrm_ParamSoc = CLASS(TAlgolStdFrm)
        Pan_Page: TRzPanel;
        SBtn_Quit: TLMDSpeedButton;
        Lab_Caption: TRzLabel;
        Stat_Bar: TfcStatusBar;
        Clk_Status: TRzClockStatus;
        Tim_Focus: TTimer;
        Ds_Societe: TDataSource;
        Ds_Mag: TDataSource;
        Ds_Poste: TDataSource;
        Pan_Orga: TRzPanelRv;
        Pan_Info: TRzPanelRv;
        Pan_Societe: TRzPanelRv;
        Pan_Magasin: TRzPanelRv;
        Pan_Poste: TRzPanelRv;
        Pan_Nav: TRzPanel;
        Nbt_Insert: TDBSpeedButton;
        Nbt_Delete: TDBSpeedButton;
        Nbt_Edit: TDBSpeedButton;
        Nbt_Post: TDBSpeedButton;
        Nbt_Cancel: TDBSpeedButton;
        RzLabel1: TRzLabel;
        RzLabel2: TRzLabel;
        RzLabel3: TRzLabel;
        Lab_NomSoc: TRzLabel;
        Chp_NomSoc: TwwDBEditRv;
        Lab_Cloture: TRzLabel;
        Chp_Cloture: TwwDBDateTimePickerRv;
        Lab_NomMag: TRzLabel;
        Chp_NomMag: TwwDBEditRv;
        Lab_IdentMag: TRzLabel;
        Chp_IdentMag: TwwDBEditRv;
        Chp_Nature: TRzDBRadioGroupRv;
        Lab_NomPoste: TRzLabel;
        Chp_NomPoste: TwwDBEditRv;
        Chp_SS: TdxDBCheckEditRv;
        dxM_Etp: TdxMasterViewRv;
        dxML_Societe: TdxMasterViewLevel;
        dxML_Magasin: TdxMasterViewLevel;
        dxML_Poste: TdxMasterViewLevel;
        dxML_SocieteColumn1: TdxMasterViewColumn;
        dxML_MagasinColumn1: TdxMasterViewColumn;
        dxML_PosteColumn1: TdxMasterViewColumn;
        DataSource1: TDataSource;
        DxmS_Soc: TdxMasterViewStyle;
        DxmS_Mag: TdxMasterViewStyle;
        DxmS_Poste: TdxMasterViewStyle;
        dxML_MagasinColumn2: TdxMasterViewCheckColumn;
        Chp_Loc: TdxDBCheckEditRv;
        DBCmb_Niveau: TwwDBComboBoxRv;
        RzLabel4: TRzLabel;
        RzBorder1: TRzBorder;
        Nbt_Web: TLMDSpeedButton;
        DBSpeedButton1: TDBSpeedButton;
        Que_Societe: TIBOQuery;
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
        LK_Societe: TwwLookupDialogRV;
    Nbt_Dtjourn: TLMDSpeedButton;
        PROCEDURE SBtn_QuitClick(Sender: TObject);
        PROCEDURE AlgolStdFrmShow(Sender: TObject);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
        PROCEDURE AlgolStdFrmCloseQuery(Sender: TObject;
            VAR CanClose: Boolean);
        PROCEDURE Tim_FocusTimer(Sender: TObject);
        PROCEDURE AlgolStdFrmClose(Sender: TObject; VAR Action: TCloseAction);
        PROCEDURE dxM_EtpFocusNode(Sender: TdxMasterView; PrevNode,
            CurNode: TdxMasterViewNode);
        PROCEDURE dxM_EtpKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE Chp_NomSocKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE Pan_SocieteEnter(Sender: TObject);
        PROCEDURE Pan_MagasinEnter(Sender: TObject);
        PROCEDURE Pan_PosteEnter(Sender: TObject);
        PROCEDURE Nbt_DeleteAfterAction(Sender: TObject; VAR Error: Boolean);
        PROCEDURE Nbt_WebClick(Sender: TObject);
        PROCEDURE LK_SocieteCloseDialog(Dialog: TwwLookupDlg);
        PROCEDURE Nbt_PostAfterAction(Sender: TObject; VAR Error: Boolean);
        PROCEDURE DBSpeedButton1Click(Sender: TObject);
    procedure Nbt_DtjournClick(Sender: TObject);
    PRIVATE
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED
    { Published declarations }
    END;

VAR
    Frm_ParamSoc: TFrm_ParamSoc;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
RESOURCESTRING
    Ins = 'Créer une nouvelle fiche ';
    Del = 'Supprimer la fiche sélectionnée : ';
    Edt = 'Modifier la fiche ';
    Soc = 'Société';
    Mag = 'Magasin';
    Pos = 'Poste';

IMPLEMENTATION

USES GinkoiaStd,
    GinkoiaResStr, Main_Dm;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TFrm_ParamSoc.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    Dm_ParamSoc := TDm_ParamSoc.Create(Application);
    Dm_ParamSoc.Que_GENPARAMSTD.Open;

    Dm_ParamSoc.Que_GENPARAMSTD.Locate('PRM_CODE;PRM_TYPE', VarArrayOf([95, 9]), []);
    IF (Dm_ParamSoc.Que_GENPARAMSTDPRM_CODE.AsInteger = 95) AND
        (Dm_ParamSoc.Que_GENPARAMSTDPRM_TYPE.AsInteger = 9) THEN
    BEGIN
        Nbt_Web.Enabled := True;
        IF Dm_ParamSoc.Que_GENPARAMSTDPRM_FLOAT.ASINTEGER = 1 THEN
            Nbt_Web.Caption := 'DESACTIVER  LOCATION WEB'
        ELSE
        begin
            Nbt_Web.Caption := 'activer LOCATION WEB';
            Nbt_Web.Font.Style := [fsBold];
        END;
    END
    ELSE
        Nbt_Web.Enabled := False;

    Dm_ParamSoc.Que_GENPARAMSTD.Locate('PRM_CODE;PRM_TYPE', VarArrayOf([199, 9]), []);
    IF (Dm_ParamSoc.Que_GENPARAMSTDPRM_CODE.AsInteger = 199) AND
        (Dm_ParamSoc.Que_GENPARAMSTDPRM_TYPE.AsInteger = 9) THEN
    BEGIN
        Nbt_Dtjourn.Enabled := True;
        IF Dm_ParamSoc.Que_GENPARAMSTDPRM_INTEGER.ASINTEGER = 1 THEN
            Nbt_Dtjourn.Caption := 'Pas Date sur Jrn'
        ELSE
        begin
            Nbt_Dtjourn.Caption := 'Date sur Jrn';
            Nbt_Dtjourn.Font.Style := [fsBold];
        END;
    END
    ELSE
        Nbt_Dtjourn.Enabled := False;

    Lab_caption.caption := Caption;

//  Positionner le contrôle ayant le focus au démarrage
    CurCtrl := dxM_Etp;
    Tim_Focus.Enabled := True;
END;

PROCEDURE TFrm_ParamSoc.SBtn_QuitClick(Sender: TObject);
VAR
    CanClose: Boolean;
BEGIN
    CanClose := True;
    AlgolStdFrmCloseQuery(Sender, CanClose);
    IF CanClose THEN KillAction.Execute;
END;

PROCEDURE TFrm_ParamSoc.AlgolStdFrmCloseQuery(Sender: TObject;
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
    Canclose :=
        (NOT (Ds_Societe.State IN [dsInsert, dsEdit])) AND
        (NOT (Ds_Mag.State IN [dsInsert, dsEdit])) AND
        (NOT (Ds_Poste.State IN [dsInsert, dsEdit]));
END;

PROCEDURE TFrm_ParamSoc.AlgolStdFrmShow(Sender: TObject);
BEGIN
    dxM_Etp.FullExpand;
    Tim_Focus.Enabled := True;

{ Remarque importante :
  Ici ne pas toucher à l'aspect visuel des composants de la forme car cela
  perturbe l'affichage. Le maximized au interne du composant ne se fait plus ... }
END;

PROCEDURE TFrm_ParamSoc.Tim_FocusTimer(Sender: TObject);
BEGIN
    Tim_Focus.Enabled := False;
    SetFocus;
    TRY
        IF CurCtrl <> NIL THEN
            CurCtrl.SetFocus;
    EXCEPT
    END;
    CurCtrl := NIL;
END;

PROCEDURE TFrm_ParamSoc.AlgolStdFrmClose(Sender: TObject;
    VAR Action: TCloseAction);
BEGIN
    Dm_ParamSoc.free;
END;

PROCEDURE TFrm_ParamSoc.dxM_EtpFocusNode(Sender: TdxMasterView; PrevNode,
    CurNode: TdxMasterViewNode);
BEGIN
    IF NOT (Nbt_Post.Enabled OR Nbt_Delete.Enabled) THEN
    BEGIN
        Pan_Societe.Color := $00DEE3E4;
        Pan_Magasin.Color := $00DEE3E4;
        Chp_Nature.Color := $00DEE3E4;
        Pan_Poste.Color := $00DEE3E4;

        IF (PrevNode <> NIL)
            AND (PrevNode.Level.AbsoluteIndex <> CurNode.Level.AbsoluteIndex) THEN
        BEGIN
            Nbt_Insert.DataSource := NIL;
            Nbt_Delete.DataSource := NIL;
            Nbt_Edit.DataSource := NIL;
            Nbt_Post.DataSource := NIL;
            Nbt_Cancel.DataSource := NIL;
        END;
        Pan_Poste.Visible := false;
        Pan_Magasin.Visible := false;
        CASE CurNode.Level.AbsoluteIndex OF
      // 0: le panel de la soc n'est jamais caché
            1: Pan_Magasin.Visible := True;
            2: BEGIN
                    Pan_Magasin.Visible := True;
                    Pan_Poste.Visible := True;
                END;
        END;
    END;
END;

PROCEDURE TFrm_ParamSoc.dxM_EtpKeyDown(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
VAR DS: TDataSource;
BEGIN
    // DS := NIL;

    IF NOT Nbt_Post.Enabled THEN
    BEGIN
        IF dxM_Etp.FocusedNode <> NIL THEN
        BEGIN
            CASE Key OF
                VK_INSERT:
                    CASE dxM_Etp.FocusedNode.Level.AbsoluteIndex OF
                        0: BEGIN
                                IF ssCtrl IN Shift THEN
                                BEGIN
                                    Pan_Magasin.Visible := True;
                                    DS := Ds_Mag;
                                    Chp_NomMag.SetFocus;
                                END
                                ELSE
                                BEGIN
                                    DS := Ds_Societe;
                                    Chp_NomSoc.SetFocus;
                                END;
                                DS.DataSet.Insert;
                            END;
                        1: BEGIN
                                IF ssCtrl IN Shift THEN
                                BEGIN
                                    Pan_Poste.Visible := True;
                                    DS := Ds_Poste;
                                    Chp_NomPoste.SetFocus;
                                END
                                ELSE
                                BEGIN
                                    DS := Ds_Mag;
                                    Chp_NomMag.SetFocus;
                                END;
                                DS.DataSet.Insert;
                            END;
                        2: BEGIN
                                DS := Ds_Poste;
                                Chp_NomPoste.SetFocus;
                                DS.DataSet.Insert;
                            END;
                    END;
                VK_F2: CASE dxM_Etp.FocusedNode.Level.AbsoluteIndex OF
                        0: BEGIN
                                Chp_NomSoc.SetFocus;
                                DS := Ds_Societe;
                                DS.DataSet.edit;
                            END;
                        1: BEGIN
                                Chp_NomMag.SetFocus;
                                DS := Ds_Mag;
                                DS.DataSet.edit;
                            END;
                        2: BEGIN
                                Chp_NomPoste.SetFocus;
                                DS := Ds_Poste;
                                DS.DataSet.edit;
                            END;
                    END;
                VK_DELETE:
                    CASE dxM_Etp.FocusedNode.Level.AbsoluteIndex OF
                        0: Ds_Societe.DataSet.Delete;
                        1: Ds_Mag.DataSet.Delete;
                        2: Ds_Poste.DataSet.Delete;
                    END;

            END;
        END
        ELSE
        BEGIN
            Chp_NomSoc.SetFocus;
            DS := Ds_Societe;
            DS.DataSet.Insert;
        END;
    END;
END;

PROCEDURE TFrm_ParamSoc.Chp_NomSocKeyDown(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
BEGIN
    CASE Key OF
        VK_F12: IF Nbt_Post.Enabled THEN Nbt_Post.Click;
        VK_ESCAPE: IF Nbt_Cancel.Enabled THEN Nbt_Cancel.Click;
        VK_DELETE: IF Nbt_Delete.Enabled THEN Nbt_Delete.Click;
        VK_F2: IF Nbt_Edit.Enabled THEN Nbt_Edit.Click;
    END;
END;

PROCEDURE TFrm_ParamSoc.Pan_SocieteEnter(Sender: TObject);
VAR DS: TDataSource;
BEGIN
    IF ((Nbt_Insert.DataSource <> NIL) AND (NOT Nbt_Post.Enabled))
        OR (Nbt_Insert.DataSource = NIL) THEN
    BEGIN
        Pan_Societe.Color := $00DEE3E4;
        Pan_Magasin.Color := $00DEE3E4;
        Chp_Nature.Color := $00DEE3E4;
        Pan_Poste.Color := $00DEE3E4;

        DS := Ds_Societe;
        Pan_Societe.Color := $00E8FFFF;

        Nbt_Insert.Hint := Ins + Soc;
        Nbt_Delete.Hint := Del + Soc;
        Nbt_Edit.Hint := Edt + Soc;

        Nbt_Insert.DataSource := DS;
        Nbt_Delete.DataSource := DS;
        Nbt_Edit.DataSource := DS;
        Nbt_Post.DataSource := DS;
        Nbt_Cancel.DataSource := DS;
    END;
END;

PROCEDURE TFrm_ParamSoc.Pan_MagasinEnter(Sender: TObject);
VAR DS: TDataSource;
BEGIN
    IF ((Nbt_Insert.DataSource <> NIL) AND (NOT Nbt_Post.Enabled))
        OR (Nbt_Insert.DataSource = NIL) THEN
    BEGIN
        Pan_Societe.Color := $00DEE3E4;
        Pan_Magasin.Color := $00DEE3E4;
        Chp_Nature.Color := $00DEE3E4;
        Pan_Poste.Color := $00DEE3E4;

        DS := Ds_Mag;
        Pan_Magasin.Color := $00E8FFFF;
        Chp_Nature.Color := $00E8FFFF;

        Nbt_Insert.Hint := Ins + Mag;
        Nbt_Delete.Hint := Del + Mag;
        Nbt_Edit.Hint := Edt + Mag;

        Nbt_Insert.DataSource := DS;
        Nbt_Delete.DataSource := DS;
        Nbt_Edit.DataSource := DS;
        Nbt_Post.DataSource := DS;
        Nbt_Cancel.DataSource := DS;
    END;
END;

PROCEDURE TFrm_ParamSoc.Pan_PosteEnter(Sender: TObject);
VAR DS: TDataSource;
BEGIN
    IF ((Nbt_Insert.DataSource <> NIL) AND (NOT Nbt_Post.Enabled))
        OR (Nbt_Insert.DataSource = NIL) THEN
    BEGIN
        Pan_Societe.Color := $00DEE3E4;
        Pan_Magasin.Color := $00DEE3E4;
        Chp_Nature.Color := $00DEE3E4;
        Pan_Poste.Color := $00DEE3E4;

        DS := Ds_Poste;
        Pan_Poste.Color := $00E8FFFF;

        Nbt_Insert.Hint := Ins + Pos;
        Nbt_Delete.Hint := Del + Pos;
        Nbt_Edit.Hint := Edt + Pos;

        Nbt_Insert.DataSource := DS;
        Nbt_Delete.DataSource := DS;
        Nbt_Edit.DataSource := DS;
        Nbt_Post.DataSource := DS;
        Nbt_Cancel.DataSource := DS;
    END;
END;

PROCEDURE TFrm_ParamSoc.Nbt_DeleteAfterAction(Sender: TObject;
    VAR Error: Boolean);
BEGIN
// cacher le panel
    Nbt_Insert.DataSource := NIL;
    Nbt_Delete.DataSource := NIL;
    Nbt_Edit.DataSource := NIL;
    Nbt_Post.DataSource := NIL;
    Nbt_Cancel.DataSource := NIL;
    Pan_Poste.Visible := false;
    Pan_Magasin.Visible := false;
    dxM_Etp.FocusNode(dxM_Etp.AbsoluteItems[0], False);
END;

PROCEDURE TFrm_ParamSoc.Nbt_WebClick(Sender: TObject);
BEGIN
    Dm_ParamSoc.Que_GENPARAMSTD.Locate('PRM_CODE;PRM_TYPE', VarArrayOf([95, 9]), []);
    IF (Dm_ParamSoc.Que_GENPARAMSTDPRM_CODE.AsInteger = 95) AND
        (Dm_ParamSoc.Que_GENPARAMSTDPRM_TYPE.AsInteger = 9) THEN
    BEGIN
        Dm_ParamSoc.Que_GENPARAMSTD.EDIT;
        Nbt_Web.Enabled := True;
        IF Dm_ParamSoc.Que_GENPARAMSTDPRM_FLOAT.ASINTEGER = 1 THEN
        BEGIN
            Dm_ParamSoc.Que_GENPARAMSTDPRM_FLOAT.ASINTEGER := 0;
            Nbt_Web.Caption := 'activer LOCATION WEB';
            Nbt_Web.Font.Style := [fsBold];
            // crée le param de replication correspondant !

//http://replic3.algol.fr/Web-MESIEREBin/DelosQPMAgent.dll/
//Push
//Provider=PARAM_LOC_MESIERE
//Database=MESIERE

        END
        ELSE
        BEGIN
            Dm_ParamSoc.Que_GENPARAMSTDPRM_FLOAT.ASINTEGER := 1;
            Nbt_Web.Caption := 'desactiver LOCATION WEB';
            Nbt_Web.Font.Style := [];
        END;
        Dm_ParamSoc.Que_GENPARAMSTD.Post;
        Dm_Main.IBOUpDateCache(Dm_ParamSoc.Que_genparamSTD);
        Dm_Main.IBOCommitCache(Dm_ParamSoc.Que_genparamSTD);
    END
    ELSE
        Nbt_Web.Enabled := False;
END;

PROCEDURE TFrm_ParamSoc.LK_SocieteCloseDialog(Dialog: TwwLookupDlg);
BEGIN
    IF dialog.Modalresult = mrok THEN
    BEGIN
        Nbt_Post.Datasource.dataset.FieldByName ('MAG_SOCID').AsInteger := Que_SocieteSOC_ID.AsInteger;
        // de temps en temps et je ne sais pas pourquoi le
        // Nbt_Post.Datasource.dataset est en dsedit alors que
        // Dm_ParamSoc.Que_MagasinMAG_SOCID est en dsbrowsed alors qu'ils pointent sur la même query ?!?
        // Dm_ParamSoc.Que_MagasinMAG_SOCID.AsInteger := Que_SocieteSOC_ID.AsInteger;
    END;
END;

PROCEDURE TFrm_ParamSoc.Nbt_PostAfterAction(Sender: TObject;
    VAR Error: Boolean);
BEGIN
    dxM_Etp.Update;
END;

PROCEDURE TFrm_ParamSoc.DBSpeedButton1Click(Sender: TObject);
BEGIN
    LK_Societe.execute;
END;

procedure TFrm_ParamSoc.Nbt_DtjournClick(Sender: TObject);
begin
    Dm_ParamSoc.Que_GENPARAMSTD.Locate('PRM_CODE;PRM_TYPE', VarArrayOf(['199', '9']), [loCaseInsensitive]);
    IF (Dm_ParamSoc.Que_GENPARAMSTDPRM_CODE.AsInteger = 199) AND
        (Dm_ParamSoc.Que_GENPARAMSTDPRM_TYPE.AsInteger = 9) THEN
    BEGIN
        Dm_ParamSoc.Que_GENPARAMSTD.EDIT;
        Nbt_Dtjourn.Enabled := True;
        IF Dm_ParamSoc.Que_GENPARAMSTDPRM_INTEGER.ASINTEGER = 1 THEN
        BEGIN
            Dm_ParamSoc.Que_GENPARAMSTDPRM_INTEGER.ASINTEGER := 0;
            Nbt_Dtjourn.Caption := 'Date sur Jrn';
            Nbt_Dtjourn.Font.Style := [fsBold];
        END
        ELSE
        BEGIN
            Dm_ParamSoc.Que_GENPARAMSTDPRM_INTEGER.ASINTEGER := 1;
            Nbt_Dtjourn.Caption := 'Pas Date sur Jrn';
            Nbt_Dtjourn.Font.Style := [];
        END;
        Dm_ParamSoc.Que_GENPARAMSTD.Post;
        Dm_Main.IBOUpDateCache(Dm_ParamSoc.Que_genparamSTD);
        Dm_Main.IBOCommitCache(Dm_ParamSoc.Que_genparamSTD);
    END
    ELSE
        Nbt_Dtjourn.Enabled := False;
end;

END.

