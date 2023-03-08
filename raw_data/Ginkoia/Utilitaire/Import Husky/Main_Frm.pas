 {***************************************************************
 *
 * Unit Name: Main_Frm
 * Purpose  :
 * Author   :
 * History  :
 *
 
 ****************************************************************}

//*********************************************************************************
//*                                                                               *
//*  Unit Description : Forme principale standard                                 *
//*                                                                               *
//*  Author/Developer : Hervé                                                     *
//*                                                                               *
//*  Copyright (c) Algol                                                          *
//*  All Rights reserved.                                                         *
//*                                                                               *
//*  20/08/2000 22:19:51                                                          *
//*                                                                               *
//*  Modèle de forme principale standard                                          *
//*                                                                               *
//*                                                                               *
//*                                                                               *
//*********************************************************************************

{***************************************************************
 Remarques :

   IMPORTANT
   *********
   LE DM_MAIN est déclaré dans le projet mais laissé dans la partie "Non crée"
   en automatique du projet.
   Aprés création de la base, il suffit de le basculer de l'autre côté depuis
   la boite des options de projet
   NOTA : aucune forme ne déclare le DM_Main qui est donc à rajouter dans la clause
   Uses des formes pour lesquelles c'est nécessaire...

   NE PAS HERITER DE CE MODELE car problèmes à cause des composants Système
   COPIER : Crée une copie
   UTILISER : Travaille sur les originaux mais attention toute modif
   est répercutée dans les autres programmes qui "utilisent"

   Nota : En cas de non nécessité de la ScrollBox dans la fiche de base, supprimer
   le composant et les 2 lignes des unités correspondantes en fin de la clause Uses ...

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

   ****************************************************************************
   ATTENTION : FICHIER D'AIDE
   1. Par défaut le fichier d'aide est déconnecté dans l'évènement Create de StsConst
      Il est mis à vide pour éviter les erreurs tant que le fichier d'aide nest pas
      généré. Lorsque celui-ci existe, il suffit de supprimer ou de mettre en commentaire
      cette ligne.
   2. Le fichier d'aide par défaut de l'application est "nom du projet".HLP et doit se
      trouver dans le sous répertoire Help du répertoire de l'application
   ****************************************************************}

UNIT Main_Frm;

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
    Calend,
    LMDCustomHint,
    LMDCustomShapeHint,
    LMDShapeHint,
    Wwintl,
    vgStndrt,
    LMDCustomComponent,
    LMDContainerComponent,
    LMDBaseDialog,
    LMDAboutDlg,
    ActnList,
    RxCalc,
    dxBar,
    // Ici unités corresponadant à la scrollBox
    LMDCustomScrollBox,
    LMDScrollBox,
    ehsHelpRouter,
    ehsBase,
    ehsWhatsThis,
    RzStatus,
    fcStatusBar,
    StdCtrls,
    Mask,
    wwdbedit,
    wwDBEditRv,
    ExtCtrls,
    Progbr3d,
    LMDCustomControl,
    LMDCustomPanel,
    LMDCustomBevelPanel,
    LMDBaseEdit,
    LMDCustomEdit,
    LMDEdit,
    LMDEditRv,
    RzLabel,
    LMDControl,
    LMDBaseControl,
    LMDBaseGraphicButton,
    LMDCustomSpeedButton,
    LMDSpeedButton, UserDlg, Db, Grids, Wwdbigrd, Wwdbgrid, wwDBGridRv,
  ActionRv;
    // *****************************************
//    fcStatusBar,
//    ehsHelpRouter,
//    ehsBase,
//    ehsWhatsThis,
//    RzStatus,
//    Db,
//    Grids,
//    Wwdbigrd,
//    Wwdbgrid,
//    wwDBGridRv,
//    LMDControl,
//    LMDBaseControl,
//    LMDBaseGraphicButton,
//    LMDCustomSpeedButton,
//    LMDSpeedButton,
//    ExtCtrls,
//    Progbr3d,
//    LMDCustomControl,
//    LMDCustomPanel,
//    LMDCustomBevelPanel,
//    LMDBaseEdit,
//    LMDCustomEdit,
//    LMDEdit,
//    LMDEditRv,
//    StdCtrls,
//    RzLabel, wwDBEditRv, Mask, wwdbedit, CusEditRv, EuroEditRv,
//  CustomDBEuroEditRv;

TYPE
    TFrm_Main = CLASS(TAlgolStdFrm)
        Bm_Main: TdxBarManager;
        Dxb_Quit: TdxBarButton;
        Dxb_calc: TdxBarButton;
        Dxb_Calend: TdxBarButton;
        Dxb_Help: TdxBarButton;
        Dxb_About: TdxBarButton;
        Dxb_Apropos: TdxBarSubItem;
        Dxb_Tip: TdxBarButton;
        Calc_Main: TRxCalculator;
        ActLst_Main: TActionList;
        AboutDlg_Main: TLMDAboutDlg;
        TimeSto_Main: TDateTimeStorage;
        IPLang_Main: TwwIntl;
        Hint_Main: TLMDShapeHint;
        Calend_Main: TCalend;
        SBx_Main: TLMDScrollBox;
        WIS_Main: TWhatsThis;
        HRout_Main: THelpRouter;
        Dxb_IndexHelp: TdxBarButton;
        Stat_Bar: TfcStatusBar;
        Clk_Status: TRzClockStatus;
        LMDSpeedButton1: TLMDSpeedButton;
        LMDSpeedButton2: TLMDSpeedButton;
        LMDSpeedButton5: TLMDSpeedButton;
        LMDSpeedButton6: TLMDSpeedButton;
        LMDSpeedButton7: TLMDSpeedButton;
        LMDSpeedButton10: TLMDSpeedButton;
        RzLabel1: TRzLabel;
        Ed_IEC: TLMDEditRv;
        PrgB_Iec: ProgressBar3D;
        SBtn_Go: TLMDSpeedButton;
        LMDSpeedButton11: TLMDSpeedButton;
        LMDSpeedButton13: TLMDSpeedButton;
        LMDSpeedButton14: TLMDSpeedButton;
        LMDSpeedButton15: TLMDSpeedButton;
        LMDSpeedButton16: TLMDSpeedButton;
        LMDSpeedButton3: TLMDSpeedButton;
        Lab_Tranche3: TRzLabel;
        Lab_Tranche2: TRzLabel;
        Lab_Tranche1: TRzLabel;
        Lab_Tranche4: TRzLabel;
        TrPoint: TwwDBEditRv;
        TrPrix: TwwDBEditRv;
        Dlg_FE: TUserDlg;
        Lab_Mny: TRzLabel;
        wwDBGridRv1: TwwDBGridRv;
        DataSource1: TDataSource;
        RzLabel2: TRzLabel;
        LMDSpeedButton4: TLMDSpeedButton;
        LMDSpeedButton8: TLMDSpeedButton;
        LMDSpeedButton9: TLMDSpeedButton;
        LMDSpeedButton12: TLMDSpeedButton;
        LMDSpeedButton17: TLMDSpeedButton;
        LMDSpeedButton18: TLMDSpeedButton;
        LMDSpeedButton19: TLMDSpeedButton;
        LMDSpeedButton20: TLMDSpeedButton;
        LMDSpeedButton21: TLMDSpeedButton;
        LMDSpeedButton22: TLMDSpeedButton;
        LMDSpeedButton23: TLMDSpeedButton;
        LMDSpeedButton24: TLMDSpeedButton;
        LMDSpeedButton25: TLMDSpeedButton;
        LMDSpeedButton26: TLMDSpeedButton;
        LMDSpeedButton27: TLMDSpeedButton;
        Chk_Husky: TCheckBox;
    Chk_IC: TCheckBox;
    Gax_Btn_visible: TActionGroupRv;
    Nbt_Mode: TLMDSpeedButton;
    RadioGroup1: TRadioGroup;
    TypeA: TRadioButton;
    TypeC: TRadioButton;
    TypeB: TRadioButton;
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
        PROCEDURE AlgolStdFrmShow(Sender: TObject);
        PROCEDURE Dxb_QuitClick(Sender: TObject);
        PROCEDURE Dxb_HelpClick(Sender: TObject);
        PROCEDURE Dxb_calcClick(Sender: TObject);
        PROCEDURE Dxb_CalendClick(Sender: TObject);
        PROCEDURE Dxb_AboutClick(Sender: TObject);
        PROCEDURE Dxb_TipClick(Sender: TObject);
        PROCEDURE WIS_MainHelp(Sender, HelpItem: TObject; IsMenu: Boolean;
            HContext: THelpContext; X, Y: Integer; VAR CallHelp: Boolean);
        PROCEDURE Dxb_IndexHelpClick(Sender: TObject);
        PROCEDURE Bm_MainClickItem(Sender: TdxBarManager;
            ClickedItem: TdxBarItem);
        PROCEDURE AlgolStdFrmCloseQuery(Sender: TObject;
            VAR CanClose: Boolean);
        PROCEDURE LMDSpeedButton1Click(Sender: TObject);
        PROCEDURE LMDSpeedButton2Click(Sender: TObject);
        PROCEDURE LMDSpeedButton5Click(Sender: TObject);
        PROCEDURE LMDSpeedButton6Click(Sender: TObject);
        PROCEDURE LMDSpeedButton7Click(Sender: TObject);
        PROCEDURE LMDSpeedButton10Click(Sender: TObject);
        PROCEDURE SBtn_GoClick(Sender: TObject);
        PROCEDURE LMDSpeedButton11Click(Sender: TObject);
        PROCEDURE LMDSpeedButton12Click(Sender: TObject);
        PROCEDURE LMDSpeedButton13Click(Sender: TObject);
        PROCEDURE LMDSpeedButton14Click(Sender: TObject);
        PROCEDURE LMDSpeedButton15Click(Sender: TObject);
        PROCEDURE LMDSpeedButton16Click(Sender: TObject);
        PROCEDURE LMDSpeedButton3Click(Sender: TObject);
        PROCEDURE LMDSpeedButton4Click(Sender: TObject);
        PROCEDURE LMDSpeedButton8Click(Sender: TObject);
        PROCEDURE LMDSpeedButton9Click(Sender: TObject);
        PROCEDURE LMDSpeedButton17Click(Sender: TObject);
        PROCEDURE LMDSpeedButton18Click(Sender: TObject);
        PROCEDURE LMDSpeedButton20Click(Sender: TObject);
        PROCEDURE LMDSpeedButton21Click(Sender: TObject);
        PROCEDURE LMDSpeedButton22Click(Sender: TObject);
        PROCEDURE LMDSpeedButton19Click(Sender: TObject);
        PROCEDURE LMDSpeedButton23Click(Sender: TObject);
        PROCEDURE LMDSpeedButton24Click(Sender: TObject);
        PROCEDURE LMDSpeedButton25Click(Sender: TObject);
        PROCEDURE LMDSpeedButton26Click(Sender: TObject);
        PROCEDURE LMDSpeedButton27Click(Sender: TObject);
        PROCEDURE AlgolStdFrmPaint(Sender: TObject);
    procedure Nbt_ModeClick(Sender: TObject);
    PRIVATE
    { Private declarations }
        FUNCTION TestCF: boolean;

    PROTECTED
    { Protected declarations }
        Premier: Boolean;
    PUBLIC
    { Public declarations }
        PROCEDURE pgb_IEC;
        PROCEDURE InitPGB(Lib: STRING);

    PUBLISHED
    { Published declarations }
    END;

VAR
    Frm_Main: TFrm_Main;

IMPLEMENTATION

USES Stdutils,
    Import_dm,
    ginkoiastd,
    ginkoiaresstr, MouliCB_frm;

{$R *.DFM}

TYPE
    TmyCustomdxBarControl = CLASS(TCustomdxBarControl);

//--------------------------------------------------------------------------------
//Auto Générées
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//Système FORM
//--------------------------------------------------------------------------------

//******************* TFrm_Main.AlgolMainFrmCreate *************************

PROCEDURE TFrm_Main.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    chk_husky.Checked := true;
    Premier := true;
END;

//******************* TFrm_Main.AlgolStdFrmCloseQuery *************************
// Contrôle de sortie de la Forme ...

PROCEDURE TFrm_Main.AlgolStdFrmCloseQuery(Sender: TObject;
    VAR CanClose: Boolean);
BEGIN
    Canclose := StdTag < 0;
    IF NOT Canclose THEN
    BEGIN
        stdginkoia.delaymess(ErrItemMenu, 3);
        Abort;
    END;
END;

//******************* TFrm_Main.AlgolMainFrmShow *************************

PROCEDURE TFrm_Main.AlgolStdFrmShow(Sender: TObject);
BEGIN
{  Maximized mis ici pour prendre en compte corrextement les "anchors"
   CanMaximize à False pour shunter la dimension DesignTime et que la form soit
   toujours minimized ou maximized
   Nota : dsSie=zeable pour la Form car sinon recouvre la TaskBar
   Dans ce contexte c'est Bill qui prend tout en charge }

    IF NOT Init THEN
    BEGIN
        windowState := wsMaximized;
        canMaximize := False;
//        IF StdConst.Tip_Main.ShowAtStartup THEN ExecTip;
    END;

//    CASE Dlg_FE.Show OF
//        0:
//            BEGIN
//                dm_import.euro := 6.55957;
//                lab_mny.caption := 'Dossier Husky en FRANCS';
//            END;
//        1:
//            BEGIN
//                dm_import.euro := 1;
//                lab_mny.caption := 'Dossier Husky en EUROS';
//            END;
//
//    END;

    dm_import.euro := 1;
    lab_mny.caption := 'Dossier Husky en EUROS';
    trprix.text := '1';
    trpoint.text := '1';
END;

//--------------------------------------------------------------------------------
// Boutons du Menu
//--------------------------------------------------------------------------------

//******************* TFrm_Main.Bm_MainClickItem *************************
// Contrôle de la disponibilité des boutons des menus ...

PROCEDURE TFrm_Main.Bm_MainClickItem(Sender: TdxBarManager;
    ClickedItem: TdxBarItem);
VAR
    Cancel: Boolean;
BEGIN
    // StdTag de la forme sert
    // de témoin pour autoriser l'accès aux boutons de menus
    // si stdTag >= 0 le boutons de menus dont le Tag est >= 0 sont inhibés

    Cancel := False;
    IF (ClickedItem IS TdxBarButton) THEN
        IF clickedItem.Tag >= 0 THEN
            Cancel := StdTag >= 0;

    IF cancel THEN
    BEGIN
        INFMESS(ErrItemMenu, '');
        Abort;
    END;

END;

//******************* TFrm_Main.Dxb_QuitClick *************************
// Bouton Quitter

PROCEDURE TFrm_Main.Dxb_QuitClick(Sender: TObject);
BEGIN
    Close;
END;

//--------------------------------------------------------------------------------
//Gestion de l'aide
//--------------------------------------------------------------------------------

//******************* TFrm_Main.WhatsThis1Help *************************
// Activation de l'aide pour ExpressBar

PROCEDURE TFrm_Main.WIS_MainHelp(Sender, HelpItem: TObject;
    IsMenu: Boolean; HContext: THelpContext; X, Y: Integer;
    VAR CallHelp: Boolean);
VAR
    ABarItem: TdxBarItemControl;
    P: TPoint;
BEGIN
    IF application.Helpfile = '' THEN
        CallHelp := False
    ELSE
    BEGIN
        IF HelpItem IS TCustomdxBarControl THEN
        BEGIN
            WITH TmyCustomdxBarControl(HelpItem) DO
            BEGIN
                P.x := x;
                p.y := y;
                ABarItem := ItemAtPos(ScreenToClient(P));
                IF NOT ((ABarItem = NIL) OR (ABarItem IS TdxBarSubItemControl)) THEN
                    HContext := ABarItem.Item.HelpContext;
                Application.HelpCommand(HELP_CONTEXTPOPUP, HContext);
                CallHelp := False;
            END;
        END;
    END;

END;

//******************* TFrm_Main.Dxb_HelpClick *************************

PROCEDURE TFrm_Main.Dxb_HelpClick(Sender: TObject);
BEGIN
    Wis_main.ContextHelp;
END;

//******************* TFrm_Main.Dxb_IndexHelpClick *************************
// Chaine sur l'indes de l'aide (didacticiel)

PROCEDURE TFrm_Main.Dxb_IndexHelpClick(Sender: TObject);
BEGIN
    IF application.Helpfile = '' THEN Exit;
    HRout_main.HelpContent;
END;

//--------------------------------------------------------------------------------
//Outils accessoires
//--------------------------------------------------------------------------------

//******************* TFrm_Main.Dxb_calcClick *************************
// Calculatrice

PROCEDURE TFrm_Main.Dxb_calcClick(Sender: TObject);
BEGIN
    ExecCalc;
END;

//******************* TFrm_Main.Dxb_TipClick *************************
// Bouton Tip du menu

PROCEDURE TFrm_Main.Dxb_TipClick(Sender: TObject);
BEGIN
    ExecTip;
END;

//******************* TFrm_Main.Dxb_AboutClick *************************
// Boite About

PROCEDURE TFrm_Main.Dxb_AboutClick(Sender: TObject);
BEGIN
    AboutDlg_Main.Execute;
END;

//******************* TFrm_Main.Dxb_CalendClick *************************
// Calendrier

PROCEDURE TFrm_Main.Dxb_CalendClick(Sender: TObject);
BEGIN
    Calend_Main.execute;
END;

//---Barre de progress

PROCEDURE Tfrm_Main.InitPGB(Lib: STRING);
BEGIN
    Prgb_Iec.progress := 0;
    Ed_Iec.text := Lib;
END;

PROCEDURE TFrm_Main.PGB_IEC;
BEGIN
    PrgB_IEC.AddProgress(1);
END;

PROCEDURE TFrm_Main.LMDSpeedButton1Click(Sender: TObject);
BEGIN
    dm_import.GT;
END;

PROCEDURE TFrm_Main.LMDSpeedButton2Click(Sender: TObject);
BEGIN
    Dm_import.Fourn;
END;

PROCEDURE TFrm_Main.LMDSpeedButton5Click(Sender: TObject);
BEGIN
    dm_import.NK(2); //On reprend la nomenclature Husky
END;

PROCEDURE TFrm_Main.LMDSpeedButton6Click(Sender: TObject);
BEGIN
    InitPGB('Fiches Articles');
    Dm_import.Article;
END;

PROCEDURE TFrm_Main.LMDSpeedButton7Click(Sender: TObject);
BEGIN
    InitPGB('Tarifs Articles');
    Dm_import.Tarifs;
END;

PROCEDURE TFrm_Main.LMDSpeedButton10Click(Sender: TObject);
BEGIN
    InitPGB('Codes barres Husky');
    dm_import.Cb; //Transfert des CB

    if not chk_husky.Checked then InitLesCB;
    

END;

PROCEDURE TFrm_Main.SBtn_GoClick(Sender: TObject);
VAR
    s: STRING;
    d: DWord;
    deb:tdatetime;
    fid:integer;
BEGIN

    deb:=now;
    IF paramCount > 2 THEN
    BEGIN
        S := ParamStr(3);
    END
    ELSE
        S := '';

    IF s='0' THEN s:='';

    IF NOT dm_import.testinitial THEN
    BEGIN
        infmess('Import impossible', '');
        EXIT;
    END;

    IF NOT testcf THEN exit;
    TRY

        InitPGB('Société & Magasin(s)');
        dm_import.magasin;

        InitPGB('Grilles de tailles HUSKY');
        dm_import.GT; //Grilles de tailles HUSKY

        InitPGB('Fournisseurs');
        Dm_import.Fourn; //Fournisseurs

        InitPGB('Nomenclature HUSKY');
        dm_import.NK(2); //Transfert de la nomenclature HUSKY

        InitPGB('Fiches Articles');
        Dm_import.Article; //Transfert des articles

        InitPGB('Tarifs Articles');
        Dm_import.Tarifs; //Transfert des tarifs

        InitPGB('Stock et Mouvements');
        dm_import.StockMvt; //Transfert du stock courant

        InitPGB('Codes barres Husky');
        dm_import.Cb; //Transfert des CB

        if not chk_husky.Checked then InitLesCB;

        InitPGB('Commandes');
        dm_import.Commandes; //Transfert des Commandes

        InitPGB('Clients');
        if typea.checked then fid:=1;
        if typeb.checked then fid:=2;
        if typec.checked then fid:=3;
        dm_import.Clients(fid); //Transfert des clients

        InitPGB('Comptes Clients');
        dm_import.Cptcli; //Transfert des clients

        InitPGB('Cartes Fidélités');
        dm_import.Fidelite;

        InitPGB('TARIFS 2 & 3');
        dm_import.TArif23;

    //Location
        InitPGB('Statuts');
        IF NOT dm_import.statut THEN EXIT;

        InitPGB('Categorie');
        dm_import.Categorie;

        InitPGB('Residence');
        dm_import.Residence;

        InitPGB('Article');
        dm_import.ArticleLoc;

        InitPGB('Organisme');
        dm_import.Organisme;

        InitPGB('Infos clients');
        dm_import.INFOLOC;

        InitPGB('Stat Location');
        dm_import.Histoloc;
    FINALLY
        IF S <> '' THEN
        BEGIN
            WinExec(Pchar(s), 0);
            d := gettickcount + 10000;
            WHILE d > gettickcount DO
            BEGIN
                Application.processmessages;
                Sleep(250);
            END;
            Caption := S;
            Close;
        END
        ELSE
        begin
            dm_import.memoDuree(now-deb);
            MessageDlg('C' + #39 + 'est fini : ' + datetimetostr(now)+'/ Durée : '+timetostr(now-deb) , mtWarning, [], 0);
        end
    END;
END;

PROCEDURE TFrm_Main.LMDSpeedButton11Click(Sender: TObject);
BEGIN

    InitPGB('Stock et Mouvements');
    dm_import.StockMvt; //Transfert du stock courant
END;

PROCEDURE TFrm_Main.LMDSpeedButton12Click(Sender: TObject);
BEGIN
    //dm_import.conso;
    InitPGB('Residence');
    dm_import.Residence;

END;

PROCEDURE TFrm_Main.LMDSpeedButton13Click(Sender: TObject);
var fid:integer;
BEGIN

    InitPGB('Clients');
    if typea.checked then fid:=1;
        if typeb.checked then fid:=2;
        if typec.checked then fid:=3;
    dm_import.Clients(fid); //Transfert des clients
END;

PROCEDURE TFrm_Main.LMDSpeedButton14Click(Sender: TObject);
BEGIN
    dm_import.magasin;
END;

PROCEDURE TFrm_Main.LMDSpeedButton15Click(Sender: TObject);
BEGIN
    InitPGB('Commandes');
    dm_import.Commandes; //Transfert des Commandes

END;

PROCEDURE TFrm_Main.LMDSpeedButton16Click(Sender: TObject);
BEGIN
    InitPGB('Comptes Clients');
    dm_import.Cptcli; //Transfert des clients
END;

PROCEDURE TFrm_Main.LMDSpeedButton3Click(Sender: TObject);
BEGIN
    IF testcf THEN
    BEGIN
        InitPGB('Cartes Fidélités');
        dm_import.Fidelite;
    END;
END;

FUNCTION tfrm_main.testcf: boolean;
BEGIN
    result := false;
    IF (trpoint.text = '') OR (strtofloat(trpoint.text) = 0) THEN
    BEGIN
        infmess('Les paramètres de la carte fidélité sont absent...', '');
        exit;
    END;
    IF (strtoint(trpoint.text) = 0) THEN
    BEGIN
        infmess('Les paramètres de la carte fidélité sont absent...', '');
        exit;
    END;
    result := true;

END;

PROCEDURE TFrm_Main.LMDSpeedButton4Click(Sender: TObject);
BEGIN
    InitPGB('TARIFS 2 & 3');
    dm_import.TArif23;

END;

PROCEDURE TFrm_Main.LMDSpeedButton8Click(Sender: TObject);
VAR toto: integer;
BEGIN
    InitPGB('Statuts');
    IF dm_import.statut THEN
        toto := 1
    ELSE
        toto := 0;

END;

PROCEDURE TFrm_Main.LMDSpeedButton9Click(Sender: TObject);
BEGIN
    InitPGB('Categorie');
    dm_import.Categorie;

END;

PROCEDURE TFrm_Main.LMDSpeedButton17Click(Sender: TObject);
BEGIN
    InitPGB('Article');
    dm_import.ArticleLoc;
END;

PROCEDURE TFrm_Main.LMDSpeedButton18Click(Sender: TObject);
BEGIN
    dm_import.classLoc;
END;

PROCEDURE TFrm_Main.LMDSpeedButton20Click(Sender: TObject);
BEGIN
    dm_import.Nk_theo;
END;

PROCEDURE TFrm_Main.LMDSpeedButton21Click(Sender: TObject);
BEGIN
    InitPGB('Organisme');
    dm_import.Organisme;
END;

PROCEDURE TFrm_Main.LMDSpeedButton22Click(Sender: TObject);
BEGIN
    InitPGB('Infos clients');
    dm_import.INFOLOC;
END;

PROCEDURE TFrm_Main.LMDSpeedButton19Click(Sender: TObject);
BEGIN
    dm_import.typecateg;
END;

PROCEDURE TFrm_Main.LMDSpeedButton23Click(Sender: TObject);
BEGIN
    InitPGB('Codes potaux français');
    dm_import.Codepostaux(1);

    InitPGB('Codes potaux suisses');
    dm_import.Codepostaux(2);
END;

PROCEDURE TFrm_Main.LMDSpeedButton24Click(Sender: TObject);
BEGIN
    InitPGB('Stat Location');
    dm_import.Histoloc;
END;

PROCEDURE TFrm_Main.LMDSpeedButton25Click(Sender: TObject);
BEGIN
    dm_import.genparam;
END;

PROCEDURE TFrm_Main.LMDSpeedButton26Click(Sender: TObject);
BEGIN
    dm_import.testinitial;
END;

PROCEDURE TFrm_Main.LMDSpeedButton27Click(Sender: TObject);
BEGIN
    IF NOT dm_import.importVide THEN
        infmess('Base Import.GDB non vide...', '');
END;

PROCEDURE TFrm_Main.AlgolStdFrmPaint(Sender: TObject);
BEGIN
    IF premier THEN
    BEGIN
        premier := false;
        update;
        IF paramcount > 0 THEN
        BEGIN
            IF uppercase(paramstr(1)) = 'AUTO' THEN
            BEGIN
                IF paramcount > 1 THEN
                BEGIN
                    IF uppercase(paramstr(2)) = 'NON' THEN
                        Chk_Husky.Checked := false;
                    IF uppercase(paramstr(2)) = 'OUI' THEN
                        Chk_Husky.Checked := True;
                END;
                SBtn_GoClick(NIL);
            END;
        END;
    END;
END;

procedure TFrm_Main.Nbt_ModeClick(Sender: TObject);
begin
     if gax_btn_visible.visible then
     begin
          gax_btn_visible.visible:=false;
          nbt_mode.caption:='Mode complet';
     end
     else
     begin
          gax_btn_visible.visible:=true;
          nbt_mode.caption:='Mode standard';
     end


end;

END.

