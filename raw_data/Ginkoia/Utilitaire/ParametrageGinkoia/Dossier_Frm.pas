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

UNIT Dossier_Frm;

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
    EuCombSimple,
    wwDialog,
    wwidlg,
    wwLookupDialogRv,
    Db,
    IBODataset,
    RzRadGrp,
    RzRadioGroupRv,
    Mask,
    DBCtrls,
    RzDBEdit,
    RzDBBnEd,
    RzDBButtonEditRv,
    LMDCustomControl,
    LMDCustomPanel,
    LMDCustomBevelPanel,
    LMDBaseEdit,
    LMDCustomEdit,
    LMDCustomMaskEdit,
    LMDCustomExtSpinEdit,
    LMDExtSpinEdit,
    LMDExtSpinEditRv,
    RzStatus,
    fcStatusBar,
    RzLabel,
    FormFill,
    RzButton,
    RzRadChk,
    IB_Components, RzEdit;

TYPE
    TFrm_Dossier = CLASS(TAlgolStdFrm)
        Pan_Page: TRzPanel;
        SBtn_Quit: TLMDSpeedButton;
        Stat_Bar: TfcStatusBar;
        Clk_Status: TRzClockStatus;
        Tim_Focus: TTimer;
        RzLabel2: TRzLabel;
        RzLabel3: TRzLabel;
        EdSpi_Histo: TLMDExtSpinEditRv;
        RzLabel4: TRzLabel;
        RzLabel5: TRzLabel;
        EdSpi_Offset: TLMDExtSpinEditRv;
        RzLabel6: TRzLabel;
        RzLabel7: TRzLabel;
        Que_Tva: TIBOQuery;
        Que_TvaTVA_TAUX: TIBOFloatField;
        Que_TvaTVA_ID: TIntegerField;
        Que_TvaTVA_CODE: TStringField;
        Ds_TVA: TDataSource;
        LK_TVA: TwwLookupDialogRV;
        RzLabel8: TRzLabel;
        Chp_Tva: TRzDBButtonEditRv;
        Que_Univ: TIBOQuery;
        Ds_Univ: TDataSource;
        LK_Univ: TwwLookupDialogRV;
        RzLabel9: TRzLabel;
        Chp_Univ: TRzDBButtonEditRv;
        RzLabel10: TRzLabel;
        RzLabel12: TRzLabel;
        RzLabel11: TRzLabel;
        RzLabel1: TRzLabel;
        Fill_: TDCFormFill;
        Lab_Caption: TRzLabel;
        RzLabel13: TRzLabel;
        RzLabel14: TRzLabel;
        Chp_Ref: TEuCombSimple;
        Chp_Cib: TEuCombSimple;
        GRb_TailleFourn: TRzRadioGroupRv;
        GRb_Maj: TRzRadioGroupRv;
        Chk_PxVente: TRzCheckBox;
        Chk_PxMin: TRzCheckBox;
        GRb_MonTravail: TRzRadioGroupRv;
        Lab_Digital: TRzLabel;
        Chk_Digital: TRzCheckBox;
        Que_GenDossier: TIBOQuery;
        Que_UnivUNI_ID: TIntegerField;
        Que_UnivUNI_IDREF: TIntegerField;
        Que_UnivUNI_NOM: TStringField;
        Que_UnivUNI_NIVEAU: TIntegerField;
        Que_UnivUNI_ORIGINE: TIntegerField;
        Que_GenDossierDOS_ID: TIntegerField;
        Que_GenDossierDOS_NOM: TStringField;
        Que_GenDossierDOS_STRING: TStringField;
        Que_GenDossierDOS_FLOAT: TIBOFloatField;
        Que_TestDigital: TIBOQuery;
        IbC_K: TIB_Cursor;
        Que_TestDigitalDOS_ID: TIntegerField;
        Que_TestDigitalDOS_NOM: TStringField;
        Que_TestDigitalDOS_STRING: TStringField;
        Que_TestDigitalDOS_FLOAT: TIBOFloatField;
        RzLabel15: TRzLabel;
        Chk_HT: TRzCheckBox;
        Que_HT: TIBOQuery;
        Que_HTDOS_ID: TIntegerField;
        Que_HTDOS_NOM: TStringField;
        Que_HTDOS_STRING: TStringField;
        Que_HTDOS_FLOAT: TIBOFloatField;
        PROCEDURE SBtn_QuitClick(Sender: TObject);
        PROCEDURE AlgolStdFrmShow(Sender: TObject);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
        PROCEDURE AlgolStdFrmCloseQuery(Sender: TObject;
            VAR CanClose: Boolean);
        PROCEDURE Tim_FocusTimer(Sender: TObject);
        PROCEDURE EdSpi_HistoClick(Sender: TObject);
        PROCEDURE EdSpi_OffsetClick(Sender: TObject);
        PROCEDURE LK_TVACloseDialog(Dialog: TwwLookupDlg);
        PROCEDURE LK_UnivCloseDialog(Dialog: TwwLookupDlg);
        PROCEDURE Chp_RefChange(Sender: TObject);
        PROCEDURE Chp_CibChange(Sender: TObject);
        PROCEDURE GRb_TailleFournClick(Sender: TObject);
        PROCEDURE GRb_MajClick(Sender: TObject);
        PROCEDURE Chk_PxVenteClick(Sender: TObject);
        PROCEDURE Chk_PxMinClick(Sender: TObject);
        PROCEDURE GRb_MonTravailClick(Sender: TObject);
        PROCEDURE Que_GenDossierAfterPost(DataSet: TDataSet);
        PROCEDURE Que_GenDossierBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_GenDossierBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_GenDossierNewRecord(DataSet: TDataSet);
        PROCEDURE Que_GenDossierUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Chk_DigitalClick(Sender: TObject);
        PROCEDURE Que_HTAfterPost(DataSet: TDataSet);
        PROCEDURE Que_HTBeforeDelete(DataSet: TDataSet);
        PROCEDURE Que_HTBeforeEdit(DataSet: TDataSet);
        PROCEDURE Que_HTNewRecord(DataSet: TDataSet);
        PROCEDURE Que_HTUpdateRecord(DataSet: TDataSet;
            UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
        PROCEDURE Chk_HTClick(Sender: TObject);
    PRIVATE
    { Private declarations }
        Mon_T, // Etiq_Mag, Etiq_Px,
            Etiq_Taille, Etiq_PxVte, Etiq_Maj, Etiq_Pxmin, Histo, Offset: Integer;
        Mon_R, Mon_C: STRING;
        tva: Extended;
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED
    { Published declarations }
    END;

VAR
    Frm_Dossier: TFrm_Dossier;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

IMPLEMENTATION

USES GinKoiaStd,
    ginkoiaresstr,
    Main_Dm;
{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TFrm_Dossier.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    Lab_caption.caption := Caption;
END;

PROCEDURE TFrm_Dossier.SBtn_QuitClick(Sender: TObject);
VAR
    CanClose: Boolean;
BEGIN
    CanClose := True;
    AlgolStdFrmCloseQuery(Sender, CanClose);
    IF CanClose THEN KillAction.Execute;
END;

PROCEDURE TFrm_Dossier.AlgolStdFrmCloseQuery(Sender: TObject;
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

END;

PROCEDURE TFrm_Dossier.AlgolStdFrmShow(Sender: TObject);
BEGIN
    Tim_Focus.Enabled := True;
{ Remarque importante :
  Ici ne pas toucher à l'aspect visuel des composants de la forme car cela
  perturbe l'affichage. Le maximized au interne du composant ne se fait plus ... }
END;

PROCEDURE TFrm_Dossier.Tim_FocusTimer(Sender: TObject);
VAR ch: STRING;
BEGIN
    Tim_Focus.Enabled := False;
    SetFocus;
    TRY
        IF CurCtrl <> NIL THEN
            CurCtrl.SetFocus;
    EXCEPT
    END;
    CurCtrl := NIL;

   // Paramètrage
    ch := StdGinkoia.GetStringParamValue('MONNAIE_REFERENCE');
    IF ch = '' THEN
    BEGIN
        Mon_R := 'EUR';
        StdGinkoia.PutStringParamValue('MONNAIE_REFERENCE', 'EUR');
    END
    ELSE
        Mon_R := ch;
    Chp_Ref.ItemIndex := Chp_Ref.Items.IndexOf(Mon_R);

    ch := StdGinkoia.GetStringParamValue('MONNAIE_CIBLE');
    IF ch = '' THEN
    BEGIN
        Mon_C := 'FRF';
        StdGinkoia.PutStringParamValue('MONNAIE_CIBLE', 'FRF');
    END
    ELSE
        Mon_C := ch;
    Chp_Cib.ItemIndex := Chp_Cib.Items.IndexOf(Mon_C);

    ch := StdGinkoia.GetStringParamValue('MONNAIE_TRAVAIL');
    IF ch = '' THEN
    BEGIN
        Mon_T := 0;
        StdGinkoia.PutStringParamValue('MONNAIE_TRAVAIL', '0');
    END
    ELSE
        Mon_T := StrToInt(ch);
    GRb_MonTravail.ItemIndex := Mon_T;

    ch := StdGinkoia.GetStringParamValue('HISTO_DUREE');
    IF ch = '' THEN
    BEGIN
        Histo := 6;
        StdGinkoia.PutStringParamValue('HISTO_DUREE', '6');
    END
    ELSE Histo := StrToInt(ch);
    EdSpi_Histo.Value := Histo;

    ch := StdGinkoia.GetStringParamValue('OFFSET');
    IF ch = '' THEN
    BEGIN
        Offset := 30;
        StdGinkoia.PutStringParamValue('OFFSET', '30');
    END
    ELSE Offset := StrToInt(ch);
    EdSpi_Offset.Value := Offset;

    Que_TVA.Open;
    tva := StdGinkoia.GetFloatParamValue('TVA');
    IF (tva = 0) THEN
        Que_TVA.close
    ELSE IF NOT Que_TVA.Locate('TVA_TAUX', tva, []) THEN
        Que_TVA.close;

    Que_HT.open;
    IF Que_HT.IsEmpty THEN
    BEGIN
        Que_HT.Insert;
        Que_HT.Post;
    END
    ELSE IF Que_HTDOS_STRING.asString = '1' THEN
        Chk_HT.State := cbChecked;

    Que_Univ.open;
    IF NOT Que_Univ.Locate('UNI_NOM', StdGinkoia.GetStringParamValue('UNIVERS_REF'), []) THEN
        Que_Univ.close;

     // si l'univers est uni-dimensionnel possibilité d'activé Groupe Digital
    IF (Que_UnivUNI_ORIGINE.asInteger = 2) THEN
    BEGIN
        Lab_Digital.Visible := True;
        Que_GenDossier.Open;
        IF NOT Que_GenDossier.IsEmpty THEN
            Chk_Digital.State := cbChecked;
        Que_GenDossier.Close;
        Chk_Digital.Visible := True;
    END;

    ch := StdGinkoia.GetStringParamValue('ETIQ_TAILLEFOUR');
    IF ch = '' THEN
    BEGIN
        Etiq_Taille := 0;
        StdGinkoia.PutStringParamValue('ETIQ_TAILLEFOUR', '0');
    END
    ELSE Etiq_Taille := StrToInt(ch);
    GRb_TailleFourn.ItemIndex := Etiq_Taille;

    ch := StdGinkoia.GetStringParamValue('ETIQ_MAJ');
    IF ch = '' THEN
    BEGIN
        Etiq_Maj := 0;
        StdGinkoia.PutStringParamValue('ETIQ_MAJ', '0');
    END
    ELSE Etiq_Maj := StrToInt(ch);
    GRb_Maj.ItemIndex := Etiq_Maj;

    ch := StdGinkoia.GetStringParamValue('ETIQ_PXMIN');
    IF ch = '' THEN
    BEGIN
        Etiq_PxMin := 1;
        StdGinkoia.PutStringParamValue('ETIQ_PXMIN', '1');
    END
    ELSE Etiq_PxMin := StrToInt(ch);
    ChK_PxMin.checked := (Etiq_PxMin = 1);

    ch := StdGinkoia.GetStringParamValue('ETIQ_PXVTE');
    IF ch = '' THEN
    BEGIN
        Etiq_PxVte := 1;
        StdGinkoia.PutStringParamValue('ETIQ_PXVTE', '1');
    END
    ELSE Etiq_PxVte := StrToInt(ch);
    ChK_PxVente.checked := (Etiq_PxVte = 1);

END;

PROCEDURE TFrm_Dossier.EdSpi_HistoClick(Sender: TObject);
BEGIN
    IF (Histo <> StrToInt(EdSpi_Histo.Text)) THEN
    BEGIN
        Histo := StrToInt(EdSpi_Histo.Text);
        StdGinkoia.PutStringParamValue('HISTO_DUREE', IntToStr(Histo));
    END;
END;

PROCEDURE TFrm_Dossier.EdSpi_OffsetClick(Sender: TObject);
BEGIN
    IF (Offset <> StrToInt(EdSpi_Offset.Text)) THEN
    BEGIN
        Offset := StrToInt(EdSpi_Offset.Text);
        StdGinkoia.PutStringParamValue('OFFSET', IntToStr(Offset));
    END;
END;

PROCEDURE TFrm_Dossier.LK_TVACloseDialog(Dialog: TwwLookupDlg);
BEGIN
    IF Dialog.ModalResult = mrOk THEN
        StdGinkoia.PutFloatParamValue('TVA', Que_TVA.FieldByName('TVA_TAUX').asFloat)
    ELSE IF NOT Que_TVA.Locate('TVA_TAUX', StdGinkoia.GetFloatParamValue('TVA'), []) THEN
        Que_TVA.close;
END;

PROCEDURE TFrm_Dossier.LK_UnivCloseDialog(Dialog: TwwLookupDlg);
BEGIN
    IF Dialog.ModalResult = mrOk THEN
    BEGIN
        StdGinkoia.PutStringParamValue('UNIVERS_REF', Que_Univ.FieldByName('UNI_NOM').asString);
         // si l'univers est uni-dimensionnel possibilité d'activé Groupe Digital
        IF (Que_UnivUNI_ORIGINE.asInteger = 2) THEN
        BEGIN
            Lab_Digital.Visible := True;
            Que_GenDossier.Open;
            IF NOT Que_GenDossier.IsEmpty THEN
                Chk_Digital.Checked := True;
            Que_GenDossier.Close;
            Chk_Digital.Visible := True;
        END;
    END
    ELSE IF NOT Que_Univ.Locate('UNI_NOM', StdGinkoia.GetStringParamValue('UNIVERS_REF'), []) THEN
    BEGIN
        Que_Univ.close;
        Lab_Digital.Visible := False;
        Chk_Digital.Visible := False;
    END;
END;

PROCEDURE TFrm_Dossier.Chp_RefChange(Sender: TObject);
BEGIN
    IF Mon_R <> Chp_Ref.Items[Chp_Ref.ItemIndex] THEN
    BEGIN
        Mon_R := Chp_Ref.Items[Chp_Ref.ItemIndex];
        StdGinkoia.PutStringParamValue('MONNAIE_REFERENCE', Mon_R);
    END;
END;

PROCEDURE TFrm_Dossier.Chp_CibChange(Sender: TObject);
BEGIN
    IF Mon_C <> Chp_Cib.Items[Chp_Cib.ItemIndex] THEN
    BEGIN
        Mon_C := Chp_Cib.Items[Chp_Cib.ItemIndex];
        StdGinkoia.PutStringParamValue('MONNAIE_CIBLE', Mon_C);
    END;
END;

PROCEDURE TFrm_Dossier.GRb_TailleFournClick(Sender: TObject);
BEGIN
    IF (Etiq_Taille <> GRb_TailleFourn.ItemIndex) THEN
    BEGIN
        Etiq_Taille := GRb_TailleFourn.ItemIndex;
        StdGinkoia.PutStringParamValue('ETIQ_TAILLEFOUR', IntToStr(Etiq_Taille));
    END;
END;

PROCEDURE TFrm_Dossier.GRb_MajClick(Sender: TObject);
BEGIN
    IF (Etiq_Maj <> GRb_Maj.ItemIndex) THEN
    BEGIN
        Etiq_Maj := GRb_Maj.ItemIndex;
        StdGinkoia.PutStringParamValue('ETIQ_MAJ', IntToStr(Etiq_Maj));
    END;
END;

PROCEDURE TFrm_Dossier.Chk_PxVenteClick(Sender: TObject);
BEGIN
    IF Chk_PxVente.Checked AND (Etiq_PxVte = 0) THEN
    BEGIN
        Etiq_PxVte := 1;
        StdGinkoia.PutStringParamValue('ETIQ_PXVTE', IntToStr(Etiq_PxVte));
        Chk_PxMin.Checked := True;
        GRb_Maj.enabled := True;
    END;
    IF (NOT Chk_PxVente.Checked) AND (Etiq_PxVte = 1) THEN
    BEGIN
        Etiq_PxVte := 0;
        StdGinkoia.PutStringParamValue('ETIQ_PXVTE', IntToStr(Etiq_PxVte));
        Chk_PxMin.Checked := False;
        GRb_Maj.enabled := False;
    END;
END;

PROCEDURE TFrm_Dossier.Chk_PxMinClick(Sender: TObject);
BEGIN
    IF Chk_PxMin.Checked AND (Etiq_PxMin = 0) THEN
    BEGIN
        Etiq_PxMin := 1;
        StdGinkoia.PutStringParamValue('ETIQ_PXMIN', IntToStr(Etiq_PxMin));
    END;
    IF (NOT Chk_PxMin.Checked) AND (Etiq_PxMin = 1) THEN
    BEGIN
        Etiq_PxMin := 0;
        StdGinkoia.PutStringParamValue('ETIQ_PXMIN', IntToStr(Etiq_PxMin));
    END;
END;

PROCEDURE TFrm_Dossier.GRb_MonTravailClick(Sender: TObject);
BEGIN
    IF (Mon_T <> GRb_MonTravail.ItemIndex) THEN
    BEGIN
        Mon_T := GRb_MonTravail.ItemIndex;
        StdGinkoia.PutStringParamValue('MONNAIE_TRAVAIL', IntToStr(Mon_T));
    END;
END;

PROCEDURE TFrm_Dossier.Que_GenDossierAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_Dossier.Que_GenDossierBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TFrm_Dossier.Que_GenDossierBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TFrm_Dossier.Que_GenDossierNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
    Que_GenDossierDOS_NOM.asString := 'GROUPEDIGITAL';
    Que_GenDossierDOS_STRING.asString := 'DIGITAL';
    Que_GenDossierDOS_FLOAT.asFloat := 0;
END;

PROCEDURE TFrm_Dossier.Que_GenDossierUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_Dossier.Chk_DigitalClick(Sender: TObject);
BEGIN
    Que_TestDigital.Open;
    IF Chk_Digital.Checked THEN
    BEGIN
      // si n'existe pas => tout créer
        IF Que_TestDigital.IsEmpty THEN
        BEGIN
            Que_GenDossier.Open;
            Que_GenDossier.Insert;
            Que_GenDossier.Post;
            Que_GenDossier.Close;
        END
        ELSE // sinon => ré-activer K
        BEGIN
            IbC_K.SQL[0] := 'UPDATE K SET K_VERSION=:VER, K_ENABLED=1 WHERE K_ID = :KID';
            IbC_K.Prepared := True;

            If Dm_Main.Gestion_K_VERSION=TKV64 then
              IbC_K.ParamByName('VER').AsString := Dm_Main.Get_Next_VERSION_ID
            else
              IbC_K.ParamByName('VER').asInteger := StrToInt(Dm_Main.GenID);
            IbC_K.ParamByName('KID').asInteger := Que_TestDigitalDOS_ID.asInteger;
            IbC_K.Execute;
            IbC_K.IB_Transaction.Commit;
        END;
    END
    ELSE
    BEGIN
      // désactiver K
        IbC_K.SQL[0] := 'UPDATE K SET K_VERSION=:VER, K_ENABLED=0 WHERE K_ID = :KID';
        IbC_K.Prepared := True;

        If Dm_Main.Gestion_K_VERSION=TKV64 then
          IbC_K.ParamByName('VER').AsString := Dm_Main.Get_Next_VERSION_ID
        else
          IbC_K.ParamByName('VER').asInteger := StrToInt(Dm_Main.GenID);

        IbC_K.ParamByName('KID').asInteger := Que_TestDigitalDOS_ID.asInteger;
        IbC_K.Execute;
        IbC_K.IB_Transaction.Commit;
    END;
    Que_TestDigital.Close;
END;

PROCEDURE TFrm_Dossier.Que_HTAfterPost(DataSet: TDataSet);
BEGIN
    Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_Dossier.Que_HTBeforeDelete(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowDelete((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TFrm_Dossier.Que_HTBeforeEdit(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.CheckAllowEdit((DataSet AS TIBODataSet).KeyRelation,
        DataSet.FieldByName((DataSet AS TIBODataSet).KeyLinks.IndexNames[0]).AsString,
        True) THEN Abort;
END;

PROCEDURE TFrm_Dossier.Que_HTNewRecord(DataSet: TDataSet);
BEGIN
    IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
        (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
    Que_HTDOS_NOM.asString := 'HT';
    Que_HTDOS_STRING.asString := '0';
    Que_HTDOS_FLOAT.asFloat := 0;
END;

PROCEDURE TFrm_Dossier.Que_HTUpdateRecord(DataSet: TDataSet;
    UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
    Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
        (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_Dossier.Chk_HTClick(Sender: TObject);
BEGIN
    Que_HT.open;
    IF Chk_HT.Checked THEN
    BEGIN
        Que_HT.Edit;
        Que_HTDOS_STRING.asString := '1';
        Que_HT.Post;
    END
    ELSE
    BEGIN
        Que_HT.Edit;
        Que_HTDOS_STRING.asString := '0';
        Que_HT.Post;
    END;
    Que_HT.close;
END;

END.

