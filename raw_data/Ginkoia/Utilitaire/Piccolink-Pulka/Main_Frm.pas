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
    // *****************************************
    fcStatusBar,
    ehsHelpRouter,
    ehsBase,
    ehsWhatsThis,
    RzStatus,
    Db,
    Grids,
    Wwdbigrd,
    Wwdbgrid,
    wwDBGridRv,
    StdCtrls,
    RzLabel,
    dxCntner,
    dxEditor,
    dxEdLib,
    dxDBELib,
    dxDBEditRv,
    LMDCustomControl,
    LMDCustomPanel,
    LMDCustomBevelPanel,
    LMDBaseEdit,
    LMDCustomEdit,
    LMDEdit,
    LMDEditRv,
    LMDControl,
    LMDBaseControl,
    LMDBaseGraphicButton,
    LMDCustomSpeedButton,
    LMDSpeedButton,
    StdUtils,
    OleCtrls,
    PLSERVERLib_TLB,
    DBTables,
    Wwtable,
    Wwquery,
    ExtCtrls,
    RzPanel,
    RzPanelRv,
    ActionRv,
    ComCtrls,
    vgCtrls,
    vgPageControlRv,
    dxTL,
    dxDBCtrl,
    dxDBGrid,
    dxDBGridRv,
    LMDIniCtrl,
    Mask,
    wwdbedit,
    wwDBEditRv;

TYPE
    TFrm_Main = CLASS ( TAlgolStdFrm )
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
        WIS_Main: TWhatsThis;
        HRout_Main: THelpRouter;
        Dxb_IndexHelp: TdxBarButton;
        Stat_Bar: TfcStatusBar;
        Clk_Status: TRzClockStatus;
        Ds_Vrac: TDataSource;
        Que_VisuSortie: TwwQuery;
        Que_Client: TwwQuery;
        Clientclec006: TStringField;
        Clientnom1: TStringField;
        Clientvid: TStringField;
        Clientpre: TStringField;
        Que_Article: TwwQuery;
        Tbl_Sortie: TwwTable;
        RzPanelRv1: TRzPanelRv;
        PLServer1: TPLServer;
        DejVrac: TwwQuery;
        Grd_Close: TGroupDataRv;
        AG: TActionGroupRv;
        GD: TGroupDataRv;
        DejLoc: TwwQuery;
        Que_Retour: TwwQuery;
        DejLoccleo004: TStringField;
        Corres: TwwQuery;
        Correscleo005: TStringField;
        Tbl_Retour: TwwTable;
        Ds_Retour: TDataSource;
        Que_VisuRetour: TwwQuery;
        Tim_Refresh: TTimer;
        Que_VisuSortieMq: TStringField;
        Que_VisuSortiecode: TStringField;
        Que_VisuSortieClient: TStringField;
        Que_VisuSortiechrono: TStringField;
        Que_VisuSortieArticle: TStringField;
        Que_VisuSortieFixa: TStringField;
        Que_VisuSortieDate: TStringField;
        Que_VisuSortieHeure: TStringField;
        Que_VisuSortiePseudo: TStringField;
        Que_VisuSortiePicolink: TStringField;
        Que_VisuSortiecleo017: TStringField;
        RzPanelRv2: TRzPanelRv;
        Pgc_Picco: TvgPageControlRv;
        Tab_Sortie: TTabSheet;
        Dbg_Sorties: TdxDBGridRv;
        Dbg_SortiesMq: TdxDBGridMaskColumn;
        Dbg_Sortiescode: TdxDBGridMaskColumn;
        Dbg_SortiesClient: TdxDBGridMaskColumn;
        Dbg_Sortieschrono: TdxDBGridMaskColumn;
        Dbg_SortiesArticle: TdxDBGridMaskColumn;
        Dbg_SortiesFixa: TdxDBGridMaskColumn;
        Dbg_SortiesPseudo: TdxDBGridMaskColumn;
        Dbg_SortiesDate: TdxDBGridMaskColumn;
        Dbg_SortiesHeure: TdxDBGridMaskColumn;
        Dbg_SortiesPicolink: TdxDBGridMaskColumn;
        Dbg_Sortiescleo017: TdxDBGridMaskColumn;
        RzPanelRv3: TRzPanelRv;
        LMDSpeedButton1: TLMDSpeedButton;
        SBtn_Quitter: TLMDSpeedButton;
        TabSheet1: TTabSheet;
        TabSheet2: TTabSheet;
        Dbg_Retour: TdxDBGridRv;
        Que_VisuRetourcleo022: TStringField;
        Que_VisuRetourcode: TStringField;
        Que_VisuRetourClient: TStringField;
        Que_VisuRetourchrono: TStringField;
        Que_VisuRetourArticle: TStringField;
        Que_VisuRetourDate: TStringField;
        Que_VisuRetourHeure: TStringField;
        Que_VisuRetourPiccolink: TStringField;
        Dbg_Retourcleo022: TdxDBGridMaskColumn;
        Dbg_Retourcode: TdxDBGridMaskColumn;
        Dbg_RetourClient: TdxDBGridMaskColumn;
        Dbg_Retourchrono: TdxDBGridMaskColumn;
        Dbg_RetourArticle: TdxDBGridMaskColumn;
        Dbg_RetourDate: TdxDBGridMaskColumn;
        Dbg_RetourHeure: TdxDBGridMaskColumn;
        Dbg_RetourPiccolink: TdxDBGridMaskColumn;
        Tbl_Ech: TwwTable;
        Ds_Ech: TDataSource;
        Que_VisuEch: TwwQuery;
        Que_VisuEchCode: TStringField;
        Que_VisuEchClient: TStringField;
        Que_VisuEchRendu: TStringField;
        Que_VisuEchArticle: TStringField;
        Que_VisuEchSorti: TStringField;
        Que_VisuEchArticle_1: TStringField;
        Que_VisuEchFix: TStringField;
        Que_VisuEchPseudo: TStringField;
        Que_VisuEchDate: TStringField;
        Que_VisuEchHeure: TStringField;
        Que_VisuEchPiccolink: TStringField;
        Dbg_Ech: TdxDBGridRv;
        Que_VisuEchcleo023: TStringField;
        Dbg_Echcleo023: TdxDBGridMaskColumn;
        Dbg_EchCode: TdxDBGridMaskColumn;
        Dbg_EchClient: TdxDBGridMaskColumn;
        Dbg_EchRendu: TdxDBGridMaskColumn;
        Dbg_EchArticle: TdxDBGridMaskColumn;
        Dbg_EchSorti: TdxDBGridMaskColumn;
        Dbg_EchArticle_1: TdxDBGridMaskColumn;
        Dbg_EchFix: TdxDBGridMaskColumn;
        Dbg_EchPseudo: TdxDBGridMaskColumn;
        Dbg_EchDate: TdxDBGridMaskColumn;
        Dbg_EchHeure: TdxDBGridMaskColumn;
        Dbg_EchPiccolink: TdxDBGridMaskColumn;
        Que_VisuEchDeg: TStringField;
        Dbg_EchDeg: TdxDBGridMaskColumn;
        Que_DejEch: TwwQuery;
        Que_ClientPreSuite: TStringField;
        Que_Categ: TwwQuery;
        Que_Articlecleo003: TStringField;
        Que_Articlecateg: TStringField;
        Que_Articletitre: TStringField;
        Que_Articlea_typ: TStringField;
        Que_Categcleo001: TStringField;
        Que_CategRegFix: TStringField;
        IniCtrl: TLMDIniCtrl;
        Que_CB: TwwQuery;
        Que_CBfcb_art: TStringField;
        Que_CBCLEO024: TStringField;
        PROCEDURE AlgolStdFrmCreate ( Sender: TObject ) ;
        PROCEDURE AlgolStdFrmShow ( Sender: TObject ) ;
        PROCEDURE Dxb_QuitClick ( Sender: TObject ) ;
        PROCEDURE Dxb_HelpClick ( Sender: TObject ) ;
        PROCEDURE Dxb_calcClick ( Sender: TObject ) ;
        PROCEDURE Dxb_CalendClick ( Sender: TObject ) ;
        PROCEDURE Dxb_AboutClick ( Sender: TObject ) ;
        PROCEDURE Dxb_TipClick ( Sender: TObject ) ;
        PROCEDURE WIS_MainHelp ( Sender, HelpItem: TObject; IsMenu: Boolean;
            HContext: THelpContext; X, Y: Integer; VAR CallHelp: Boolean ) ;
        PROCEDURE Dxb_IndexHelpClick ( Sender: TObject ) ;
        PROCEDURE Bm_MainClickItem ( Sender: TdxBarManager;
            ClickedItem: TdxBarItem ) ;
        PROCEDURE AlgolStdFrmCloseQuery ( Sender: TObject;
            VAR CanClose: Boolean ) ;
        PROCEDURE AlgolStdFrmActivate ( Sender: TObject ) ;
        PROCEDURE PLServer1DataArrived ( Sender: TObject; id: Integer;
            frameid: Smallint ) ;
        PROCEDURE SBtn_RefreshClick ( Sender: TObject ) ;
        PROCEDURE Tim_RefreshTimer ( Sender: TObject ) ;
        PROCEDURE LMDSpeedButton1Click ( Sender: TObject ) ;
        PROCEDURE SBtn_QuitterClick ( Sender: TObject ) ;
    Private
    { Private declarations }
        OldNumClient, OldNumArticle, OldNomClient, OldDesiArticle: STRING;
        NumArticle, DesiArticle, ReglageFix, CodeReel, lastCleo017, Categ: ARRAY[1..20, 1..2] OF STRING;
        Regfix, ChpCodReel: ARRAY[1..20, 1..2] OF boolean;
        Annul, OldInit, Degressivite: ARRAY[1..20] OF boolean;
        NumClient, NomClient, Initiale, OldInitiale, LastCleo022, LastCleo023: ARRAY[1..20] OF STRING;
        Degress: ARRAY[1..20] OF STRING;
        ordre: integer;
        IdPico: ARRAY[1..20] OF integer;
        i1, i2: integer;
        alphabet: STRING;
        fid: integer;
        initial_num: integer; //Compteur des initailes
        PROCEDURE InitTableau ( id: integer ) ;

        FUNCTION Tclient ( typ: integer; id: integer ) : boolean;

        FUNCTION Test_Article ( ordre: integer; id: integer; VAR pseudo: boolean ) : integer;
        FUNCTION Test_Retour ( id: integer ) : integer;

        PROCEDURE Traitement_retour ( id: integer ) ;
        PROCEDURE Traitement_Sortie ( id: integer ) ;
        PROCEDURE Traitement_Echange ( id: integer ) ;

        FUNCTION PicoId ( IdPCL: integer ) : integer;
        FUNCTION InitialeAuto: STRING;
        PROCEDURE EcranDegressivite ( id: integer ) ;

        PROCEDURE EcranMenu ( id: integer ) ;
        PROCEDURE EcranSortie ( id: integer ) ;
        PROCEDURE EcranRetour ( id: integer ) ;
        PROCEDURE EcranEchange ( id: integer ) ;
    Protected
    { Protected declarations }
    Public
    { Public declarations }
    Published
    { Published declarations }
    END;

VAR
    Frm_Main: TFrm_Main;

IMPLEMENTATION

USES ConstStd,
    Loc_dm;

{$R *.DFM}

TYPE
    TmyCustomdxBarControl = CLASS ( TCustomdxBarControl ) ;

//--------------------------------------------------------------------------------
//Auto Générées
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//Système FORM
//--------------------------------------------------------------------------------

//******************* TFrm_Main.AlgolMainFrmCreate *************************

PROCEDURE TFrm_Main.AlgolStdFrmCreate ( Sender: TObject ) ;
VAR
    i: integer;
BEGIN
    gd.open;

    //Ouverture relle de la query
    Que_article.Locate ( 'cleo003', '000000', [loCaseInsensitive] ) ;
    que_cb.locate ( 'CLEO024', ' 0', [] ) ;

    alphabet := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    FOR i := 1 TO 20 DO
    BEGIN
        ChpCodReel[i, 1] := false;
        ChpCodReel[i, 2] := false;
        Annul[i] := false;
        OldInit[i] := false;
        Degressivite[i] := false;
    END;

END;

//******************* TFrm_Main.AlgolStdFrmCloseQuery *************************
// Contrôle de sortie de la Forme ...

PROCEDURE TFrm_Main.AlgolStdFrmCloseQuery ( Sender: TObject;
    VAR CanClose: Boolean ) ;
BEGIN
    Canclose := StdTag < 0;
    IF NOT Canclose THEN
    BEGIN
        INFMESS ( ErrItemMenu, '' ) ;
        Abort;
    END;

    grd_close.close;

END;

//******************* TFrm_Main.AlgolMainFrmShow *************************

PROCEDURE TFrm_Main.AlgolStdFrmShow ( Sender: TObject ) ;
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
        IF StdConst.Tip_Main.ShowAtStartup THEN ExecTip;
    END;
END;

//--------------------------------------------------------------------------------
// Boutons du Menu
//--------------------------------------------------------------------------------

//******************* TFrm_Main.Bm_MainClickItem *************************
// Contrôle de la disponibilité des boutons des menus ...

PROCEDURE TFrm_Main.Bm_MainClickItem ( Sender: TdxBarManager;
    ClickedItem: TdxBarItem ) ;
VAR
    Cancel: Boolean;
BEGIN
    // StdTag de la forme sert
    // de témoin pour autoriser l'accès aux boutons de menus
    // si stdTag >= 0 le boutons de menus dont le Tag est >= 0 sont inhibés

    Cancel := False;
    IF ( ClickedItem IS TdxBarButton ) THEN
        IF clickedItem.Tag >= 0 THEN
            Cancel := StdTag >= 0;

    IF cancel THEN
    BEGIN
        INFMESS ( ErrItemMenu, '' ) ;
        Abort;
    END;

END;

//******************* TFrm_Main.Dxb_QuitClick *************************
// Bouton Quitter

PROCEDURE TFrm_Main.Dxb_QuitClick ( Sender: TObject ) ;
BEGIN
    Close;
END;

//--------------------------------------------------------------------------------
//Gestion de l'aide
//--------------------------------------------------------------------------------

//******************* TFrm_Main.WhatsThis1Help *************************
// Activation de l'aide pour ExpressBar

PROCEDURE TFrm_Main.WIS_MainHelp ( Sender, HelpItem: TObject;
    IsMenu: Boolean; HContext: THelpContext; X, Y: Integer;
    VAR CallHelp: Boolean ) ;
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
            WITH TmyCustomdxBarControl ( HelpItem ) DO
            BEGIN
                P.x := x;
                p.y := y;
                ABarItem := ItemAtPos ( ScreenToClient ( P ) ) ;
                IF NOT ( ( ABarItem = NIL ) OR ( ABarItem IS TdxBarSubItemControl ) ) THEN
                    HContext := ABarItem.Item.HelpContext;
                Application.HelpCommand ( HELP_CONTEXTPOPUP, HContext ) ;
                CallHelp := False;
            END;
        END;
    END;

END;

//******************* TFrm_Main.Dxb_HelpClick *************************

PROCEDURE TFrm_Main.Dxb_HelpClick ( Sender: TObject ) ;
BEGIN
    Wis_main.ContextHelp;
END;

//******************* TFrm_Main.Dxb_IndexHelpClick *************************
// Chaine sur l'indes de l'aide (didacticiel)

PROCEDURE TFrm_Main.Dxb_IndexHelpClick ( Sender: TObject ) ;
BEGIN
    IF application.Helpfile = '' THEN Exit;
    HRout_main.HelpContent;
END;

//--------------------------------------------------------------------------------
//Outils accessoires
//--------------------------------------------------------------------------------

//******************* TFrm_Main.Dxb_calcClick *************************
// Calculatrice

PROCEDURE TFrm_Main.Dxb_calcClick ( Sender: TObject ) ;
BEGIN
    ExecCalc;
END;

//******************* TFrm_Main.Dxb_TipClick *************************
// Bouton Tip du menu

PROCEDURE TFrm_Main.Dxb_TipClick ( Sender: TObject ) ;
BEGIN
    ExecTip;
END;

//******************* TFrm_Main.Dxb_AboutClick *************************
// Boite About

PROCEDURE TFrm_Main.Dxb_AboutClick ( Sender: TObject ) ;
BEGIN
    AboutDlg_Main.Execute;
END;

//******************* TFrm_Main.Dxb_CalendClick *************************
// Calendrier

PROCEDURE TFrm_Main.Dxb_CalendClick ( Sender: TObject ) ;
BEGIN
    Calend_Main.execute;
END;

PROCEDURE TFrm_Main.Traitement_Sortie ( id: integer ) ;
VAR
    IdVrac: integer;
    dix: STRING;
    vrac_heure, vrac_date: STRING;

BEGIN
    IdVrac := 0;
    tbl_sortie.first;
    WHILE NOT tbl_sortie.eof DO
    BEGIN
        IF tbl_sortie.fieldbyname ( 'cleo017' ) .asinteger > IdVrac THEN
            IdVrac := tbl_sortie.fieldbyname ( 'cleo017' ) .asinteger;
        tbl_sortie.next;
    END;

    DateTimeToString ( Vrac_date, 'dd/mm/yy', date ) ;
    DateTimeToString ( Vrac_heure, 'hh:nn', time ) ;

    //Initiales calculées automatiquement ou reprise sur la dernière saisie
    IF NOT oldinit[picoid ( id ) ] THEN
        Initiale[picoid ( id ) ] := InitialeAuto
    ELSE
        Initiale[picoid ( id ) ] := oldInitiale[picoid ( id ) ];

    //1ere location
    IF NumArticle[picoid ( id ) , 1] <> '' THEN
    BEGIN
        inc ( idVrac ) ;
        dix := inttostr ( idvrac ) ;
        dix := AlignLeft ( dix, '0', 10 ) ;

        tbl_sortie.insert;
        tbl_sortie.fieldbyname ( 'cleo017' ) .asstring := dix;
        tbl_sortie.fieldbyname ( 'client' ) .asstring := NumClient[picoid ( id ) ];
        tbl_sortie.fieldbyname ( 'v_arti' ) .asstring := NumArticle[picoid ( id ) , 1];
        tbl_sortie.fieldbyname ( 'v_RegFix' ) .asstring := ReglageFix[picoid ( id ) , 1];
        tbl_sortie.fieldbyname ( 'v_init' ) .asstring := Initiale[picoid ( id ) ];
        tbl_sortie.fieldbyname ( 'v_date' ) .asstring := vrac_date;
        tbl_sortie.fieldbyname ( 'v_heure' ) .asstring := vrac_heure;
        tbl_sortie.fieldbyname ( 'v_picco' ) .asinteger := id;
        tbl_sortie.fieldbyname ( 'v_codrel' ) .asstring := CodeReel[picoid ( id ) , 1];

        tbl_sortie.post;
    END;

    //2eme Location
    IF NumArticle[picoid ( id ) , 2] <> '' THEN
    BEGIN
        inc ( idVrac ) ;
        dix := inttostr ( idvrac ) ;
        dix := AlignLeft ( dix, '0', 10 ) ;

        tbl_sortie.insert;
        tbl_sortie.fieldbyname ( 'cleo017' ) .asstring := dix;
        tbl_sortie.fieldbyname ( 'client' ) .asstring := NumClient[picoid ( id ) ];
        tbl_sortie.fieldbyname ( 'v_arti' ) .asstring := NumArticle[picoid ( id ) , 2];
        tbl_sortie.fieldbyname ( 'v_RegFix' ) .asstring := ReglageFix[picoid ( id ) , 2];
        tbl_sortie.fieldbyname ( 'v_init' ) .asstring := Initiale[picoid ( id ) ];
        tbl_sortie.fieldbyname ( 'v_date' ) .asstring := vrac_date;
        tbl_sortie.fieldbyname ( 'v_heure' ) .asstring := vrac_heure;
        tbl_sortie.fieldbyname ( 'v_picco' ) .asinteger := id;
        tbl_sortie.fieldbyname ( 'v_codrel' ) .asstring := CodeReel[picoid ( id ) , 2];
        tbl_sortie.post;
    END;

    //Refresh de la grille
    que_visusortie.DisableControls;
    que_visusortie.close;
    que_visusortie.open;
    que_visusortie.last;
    que_visusortie.EnableControls;

    OldInitiale[picoid ( id ) ] := Initiale[picoid ( id ) ];

    NumClient[picoid ( id ) ] := '';
    Initiale[picoid ( id ) ] := '';
    oldinit[picoid ( id ) ] := false;

    NumArticle[picoid ( id ) , 1] := '';
    DesiArticle[picoid ( id ) , 1] := '';
    ReglageFix[picoid ( id ) , 1] := '';
    CodeReel[picoid ( id ) , 1] := '';
    RegFix[picoid ( id ) , 1] := false;

    NumArticle[picoid ( id ) , 2] := '';
    DesiArticle[picoid ( id ) , 2] := '';
    ReglageFix[picoid ( id ) , 2] := '';
    CodeReel[picoid ( id ) , 2] := '';
    RegFix[picoid ( id ) , 2] := false;

    IF ChpCodReel[picoid ( id ) , 1] THEN
    BEGIN
        plserver1.fieldcmd ( ID, 90, 1 ) ;
        ChpCodReel[picoid ( id ) , 1] := false;
    END;

    IF ChpCodReel[picoid ( id ) , 2] THEN
    BEGIN
        plserver1.fieldcmd ( ID, 150, 1 ) ;
        ChpCodReel[picoid ( id ) , 2] := false;
    END;

    plserver1.text ( id, 80, '                    ' ) ;
    plserver1.text ( id, 140, '                    ' ) ;
END;

PROCEDURE TFrm_Main.AlgolStdFrmActivate ( Sender: TObject ) ;
VAR
    com: STRING;
BEGIN
    pgc_picco.activepageindex := 0;
    TabSheet2.caption := 'Echanges';

    com := iniCtrl.readString ( 'PICCOLINK', 'COM', '' ) ;
    IF com = '' THEN
    BEGIN
        iniCtrl.writeString ( 'PICCOLINK', 'COM', '2' ) ;
        com := '2';
    END;

    plserver1.connect ( strtoint ( com ) ) ;
    dbg_sorties.fullexpand;
    dbg_retour.fullexpand;
    dbg_ech.fullexpand;
END;

PROCEDURE TFrm_Main.PLServer1DataArrived ( Sender: TObject; id: Integer;
    frameid: Smallint ) ;
VAR

    text, lib: STRING;
    qte: integer;
    qte_string: STRING;
    pseudo: boolean;

BEGIN

    //Gestion des touches de fonctions
    IF plserver1.getdata ( ID, 0 ) = 'F1' THEN
    BEGIN
        EcranMenu ( id ) ;
        Exit;
    END;
    IF plserver1.getdata ( ID, 0 ) = 'F2' THEN
    BEGIN
        EcranSORTIE ( id ) ;
        exit;
    END;
    IF plserver1.getdata ( ID, 0 ) = 'F3' THEN
    BEGIN
        EcranRetour ( id ) ;
        Exit;
    END;

    //CASE frameid OF
    //    -1:
    CASE plserver1.GetFormID ( ID ) OF
        0:          //Init du Piccolink
            BEGIN
                InitTableau ( id ) ;
                EcranMenu ( id ) ;
                exit;
            END;

        1:
            BEGIN   // Choix dans le menu principal

                IF plserver1.isdata ( ID, 40 ) THEN
                BEGIN
                    EcranSortie ( id ) ;
                    InitTableau ( id ) ;
                    exit;
                END;

                IF plserver1.isdata ( ID, 60 ) THEN
                BEGIN

                    EcranRetour ( id ) ;
                    InitTableau ( id ) ;
                    exit;
                END;

                IF plserver1.isdata ( ID, 80 ) THEN
                BEGIN

                    EcranEchange ( id ) ;
                    InitTableau ( id ) ;
                    exit;
                END;

            END;

        2:
            BEGIN   //--Module SORTIE

                IF ( plserver1.isdata ( ID, 11 ) ) THEN //Les info arrive de la postion 10
                                               //C'est le code barre Client
                BEGIN

                    IF NOT Annul[picoid ( id ) ] THEN
                    BEGIN

                        NumClient[picoid ( id ) ] := plserver1.getdata ( ID, 11 ) ;
                        IF Tclient ( 0, id ) THEN
                        BEGIN
                            plserver1.fldtxt ( ID, 11, NumClient[picoid ( id ) ] ) ;
                            plserver1.text ( ID, 22, '                  ' ) ;
                            plserver1.text ( ID, 22, copy ( NomClient[picoid ( id ) ], 1, 18 ) ) ;

                        //Menage Ecran...
                            plserver1.text ( ID, 62, '                  ' ) ;
                            plserver1.text ( ID, 122, '                  ' ) ;
                            plserver1.text ( ID, 80, '                  ' ) ;
                            plserver1.text ( ID, 140, '                    ' ) ;
                            plserver1.fieldcmd ( ID, 44, 2 ) ;
                            plserver1.fieldcmd ( ID, 56, 2 ) ;
                            plserver1.fieldcmd ( ID, 104, 2 ) ;
                            plserver1.fieldcmd ( ID, 116, 2 ) ;

                            IF ChpCodReel[picoid ( id ) , 1] THEN
                            BEGIN
                                plserver1.fieldcmd ( ID, 90, 1 ) ;
                                ChpCodReel[picoid ( id ) , 1] := false;
                            END;
                            IF ChpCodReel[picoid ( id ) , 2] THEN
                            BEGIN
                                plserver1.fieldcmd ( ID, 150, 1 ) ;
                                ChpCodReel[picoid ( id ) , 2] := false;
                            END;

                        END
                        ELSE
                        BEGIN
                            plserver1.bell ( id ) ;
                            plserver1.bell ( id ) ;
                            plserver1.text ( ID, 22, '*INEXISTANT*      ' ) ;
                            plserver1.bell ( id ) ;
                            plserver1.bell ( id ) ;

                            plserver1.fieldcmd ( ID, 11, 2 + 128 ) ;
                        END;

                    END
                    ELSE
                    BEGIN
                        //----------------------------------
                        //Attention c'est une annulation
                        //----------------------------------
                        numarticle[picoid ( id ) , 1] := plserver1.getdata ( ID, 11 ) ;
                        CASE Test_Retour ( id ) OF

                            10: //Annulation OK
                                BEGIN
                                    plserver1.text ( ID, 62, copy ( desiarticle[picoid ( id ) , 1], 1, 18 ) ) ;
                                    plserver1.text ( ID, 122, copy ( desiarticle[picoid ( id ) , 2], 1, 18 ) ) ;
                                    plserver1.text ( id, 22, copy ( nomclient[picoid ( id ) ], 1, 18 ) ) ;

                                    plserver1.fldtxt ( id, 44, numarticle[picoid ( id ) , 1] ) ;
                                    plserver1.fldtxt ( id, 104, numarticle[picoid ( id ) , 2] ) ;

                                    plserver1.fieldcmd ( ID, 11, 2 + 8 ) ;
                                    plserver1.text ( ID, 140, '                    ' ) ;
                                    plserver1.text ( ID, 140, 'ANNULATION' ) ;

                                    plserver1.newfield ( ID, 152, 3, 1 + 8 ) ;
                                    plserver1.fldtxt ( id, 152, 'NON' ) ;

                                    plserver1.newfield ( ID, 157, 3, 1 + 8 + 128 ) ;
                                    plserver1.fldtxt ( id, 157, 'OUI' ) ;

                                    plserver1.fieldcmd ( ID, 157, 2 + 128 ) ;
                                END;

                            11: //Annulation impossible
                                BEGIN
                                    plserver1.bell ( id ) ;
                                    plserver1.bell ( id ) ;
                                    plserver1.text ( ID, 22, 'ANNUL IMPOSSIBLE' ) ;
                                    plserver1.text ( ID, 140, '                    ' ) ;
                                    Annul[picoid ( id ) ] := false;
                                    plserver1.fieldcmd ( ID, 11, 2 + 128 ) ;
                                END;
                        END;

                    END;

                END;

                //---------------------CODE ARTICLE 1--------------------------------------------------

                IF ( plserver1.isdata ( ID, 44 ) ) AND ( NOT Annul[picoid ( id ) ] ) AND ( NumClient[picoid ( id ) ] <> '' ) THEN  //Les info arrive de la postion 44
                                               //C'est le code barre Article
                BEGIN
                    ordre := 1;
                    numarticle[picoid ( id ) , ordre] := plserver1.getdata ( ID, 44 ) ;
                    CASE Test_Article ( ordre, id, pseudo ) OF
                        1:
                            BEGIN
                                plserver1.fldtxt ( ID, 44, numarticle[picoid ( id ) , ordre] ) ;
                                plserver1.text ( ID, 62, copy ( DesiArticle[picoid ( id ) , ordre], 1, 18 ) ) ;
                                IF pseudo THEN
                                BEGIN
                                    plserver1.text ( ID, 80, 'Code Reel: ' ) ;
                                    plserver1.newfield ( ID, 90, 8, 1 + 16 + 128 ) ; //Code reel
                                    ChpCodReel[picoid ( id ) , 1] := true;
                                END
                                ELSE
                                BEGIN
                                    ChpCodReel[picoid ( id ) , 1] := false;
                                    IF RegFix[picoid ( id ) , ordre] THEN
                                        plserver1.fieldcmd ( ID, 56, 2 + 128 ) //Reglage Fixation
                                    ELSE
                                        plserver1.fieldcmd ( ID, 104, 2 + 128 ) ; //Code suivant
                                END;
                            END;
                        0:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 62, '*INEXISTANT*' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 44, 2 + 128 ) ;
                            END;
                        2:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 62, '*DEJA LOUE*' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 44, 2 + 128 ) ;
                            END;

                    END;

                END;

                //------------------------REG FIXATION 1-------------------------------------------------
                IF ( plserver1.isdata ( ID, 56 ) ) AND ( NOT Annul[picoid ( id ) ] ) AND ( NumClient[picoid ( id ) ] <> '' ) THEN  //Les info arrive du reglage fixation
                BEGIN
                    ReglageFix[picoid ( id ) , 1] := plserver1.getdata ( ID, 56 ) ;
                    plserver1.fieldcmd ( ID, 104, 2 + 128 ) ; //Code suivant

                END;

                //------------------------CODE REEL APRES PSEUDO-------------------------------------------------
                IF ( plserver1.isdata ( ID, 90 ) ) AND ( NOT Annul[picoid ( id ) ] ) AND ( NumClient[picoid ( id ) ] <> '' ) THEN
                BEGIN
                    CodeReel[picoid ( id ) , 1] := plserver1.getdata ( ID, 90 ) ;
                    IF regfix[picoid ( id ) , 1] THEN
                        plserver1.fieldcmd ( ID, 56, 2 + 128 ) //Code suivant Reglage Fix
                    ELSE
                        plserver1.fieldcmd ( ID, 104, 2 + 128 ) ; //Code suivant Code article 2

                END;

                //--------------------------CODE ARTICLE 2---------------------------------------------
                IF ( plserver1.isdata ( ID, 104 ) ) AND ( NOT Annul[picoid ( id ) ] ) AND ( NumClient[picoid ( id ) ] <> '' ) THEN  //Les info arrive de la postion 104
                                               //C'est le code barre Article
                BEGIN
                    ordre := 2;
                    numarticle[picoid ( id ) , ordre] := plserver1.getdata ( ID, 104 ) ;
                    CASE Test_Article ( ordre, id, pseudo ) OF
                        1:
                            BEGIN
                                plserver1.Fldtxt ( ID, 104, numarticle[picoid ( id ) , ordre] ) ;
                                plserver1.text ( ID, 122, copy ( DesiArticle[picoid ( id ) , ordre], 1, 18 ) ) ;
                                IF pseudo THEN
                                BEGIN
                                    plserver1.text ( ID, 140, 'Code Reel:          ' ) ;
                                    plserver1.newfield ( ID, 150, 8, 1 + 16 + 128 ) ; //Code reel
                                    ChpCodReel[picoid ( id ) , 2] := true;
                                END
                                ELSE
                                BEGIN
                                    ChpCodReel[picoid ( id ) , 2] := false;
                                    IF RegFix[picoid ( id ) , ordre] THEN
                                        plserver1.fieldcmd ( ID, 116, 2 + 128 ) //Reglage Fixation
                                    ELSE
                                    BEGIN
                                        plserver1.fieldcmd ( ID, 11, 2 + 128 ) ; //Code suivant
                                        Traitement_Sortie ( id ) ; //Validation de la locaction
                                    END;
                                END;

                            END;
                        0:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 122, '*INEXISTANT*' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 104, 2 + 128 ) ;
                            END;
                        2:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 122, '*DEJA LOUE*' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 104, 2 + 128 ) ;
                            END;
                    END;

                END;

                //------------------------REG FIXATION 2-------------------------------------------------
                IF ( plserver1.isdata ( ID, 116 ) ) AND ( NOT Annul[picoid ( id ) ] ) AND ( NumClient[picoid ( id ) ] <> '' ) THEN  //Les info arrive du reglage fixation
                BEGIN
                    ReglageFix[picoid ( id ) , 2] := plserver1.getdata ( ID, 116 ) ;
                    plserver1.fieldcmd ( ID, 11, 2 + 128 ) ; //Code Client
                    Traitement_Sortie ( id ) ; //Validation de la locaction

                END;

                //------------------------CODE REEL APRES PSEUDO-------------------------------------------------
                IF ( plserver1.isdata ( ID, 150 ) ) AND ( NOT Annul[picoid ( id ) ] ) AND ( NumClient[picoid ( id ) ] <> '' ) THEN
                BEGIN
                    CodeReel[picoid ( id ) , 2] := plserver1.getdata ( ID, 150 ) ;
                    IF regfix[picoid ( id ) , 2] THEN
                        plserver1.fieldcmd ( ID, 116, 2 + 128 ) //Code suivant Reglage Fix
                    ELSE
                    BEGIN
                        plserver1.fieldcmd ( ID, 11, 2 + 128 ) ; //Code Client
                        Traitement_Sortie ( id ) ; //Validation de la locaction
                    END;

                END;

                 //-------------------Reprise des initialles precedentes-----------
                IF plserver1.getdata ( ID, 0 ) = 'F4' THEN
                BEGIN
                    IF numclient[picoid ( id ) ] <> '' THEN
                    BEGIN
                        IF oldInitiale[picoid ( id ) ] <> '' THEN
                        BEGIN
                            OldInit[picoid ( id ) ] := true;
                            plserver1.text ( id, 140, 'Initiales identiques' ) ;
                        END;
                    END;

                END;

                //-----------------------Annulation----------------------
                IF plserver1.getdata ( ID, 0 ) = 'F5' THEN
                BEGIN
                    IF numclient[picoid ( id ) ] = '' THEN
                    BEGIN
                        //Menage Ecran...
                        plserver1.text ( ID, 22, '                  ' ) ;
                        plserver1.text ( ID, 62, '                  ' ) ;
                        plserver1.text ( ID, 122, '                  ' ) ;
                        plserver1.text ( ID, 80, '                  ' ) ;
                        plserver1.text ( ID, 140, '                    ' ) ;
                        plserver1.fieldcmd ( ID, 44, 2 ) ;
                        plserver1.fieldcmd ( ID, 56, 2 ) ;
                        plserver1.fieldcmd ( ID, 104, 2 ) ;
                        plserver1.fieldcmd ( ID, 116, 2 ) ;

                        plserver1.text ( ID, 0, 'SORTIE Art:' ) ;

                        IF Annul[picoid ( id ) ] = false THEN
                        BEGIN
                            plserver1.text ( ID, 140, '**** ANNULATION ****' ) ;
                            Annul[picoid ( id ) ] := true;
                        END
                        ELSE
                        BEGIN
                            plserver1.text ( ID, 140, '                    ' ) ;
                            Annul[picoid ( id ) ] := false;
                        END;

                    END;

                END;

                //------------------------Confirmation de l'annulation------------------------------------------------
                IF ( plserver1.isdata ( ID, 157 ) ) AND ( Annul[picoid ( id ) ] ) THEN
                BEGIN
                    Annul[picoid ( id ) ] := false;
                    EcranSortie ( id ) ; //Raz Ecran

                    tbl_sortie.first;
                    WHILE NOT tbl_sortie.eof DO
                    BEGIN
                        IF ( Tbl_sortie.fieldbyname ( 'client' ) .asstring = LastCleo017[picoid ( id ) , 1] ) AND
                        ( Tbl_sortie.fieldbyname ( 'v_init' ) .asstring = LastCleo017[picoid ( id ) , 2] ) THEN
                            tbl_sortie.delete
                        ELSE
                            tbl_sortie.next;
                    END;
                    tbl_sortie.last;
                    InitTableau ( id ) ;

                    que_visusortie.close;
                    que_visusortie.open;
                END;

                //------------------------Annulation de l'annulation------------------------------------------------
                IF ( plserver1.isdata ( ID, 152 ) ) AND ( Annul[picoid ( id ) ] ) THEN
                BEGIN
                    Annul[picoid ( id ) ] := false;
                    EcranSortie ( id ) ; //Raz Ecran
                    InitTableau ( id ) ;
                END;

                plserver1.send ( ID, 2 ) ;
            END;

        3:          //---------------------------------------------------------------
            BEGIN   //--Module RETOUR------------------------------------------------

                IF plserver1.isdata ( ID, 11 ) THEN
                BEGIN
                    numarticle[picoid ( id ) , 1] := plserver1.getdata ( ID, 11 ) ;
                    CASE Test_Retour ( id ) OF
                        1:
                            BEGIN
                                plserver1.text ( ID, 22, NumArticle[picoid ( id ) , 1] + ' ' + copy ( desiarticle[picoid ( id ) , 1], 1, 11 ) ) ;
                                plserver1.text ( id, 69, numclient[picoid ( id ) ] ) ;
                                plserver1.text ( id, 82, copy ( nomclient[picoid ( id ) ], 1, 18 ) ) ;
                                Traitement_Retour ( id ) ;
                                plserver1.fieldcmd ( ID, 11, 2 + 128 ) ;
                            END;
                        0:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 22, '*INEXISTANT*     ' ) ;
                                plserver1.text ( ID, 69, '      ' ) ;
                                plserver1.text ( ID, 82, '                 ' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 11, 2 + 128 ) ;
                            END;
                        2:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 22, '*PAS EN LOCATION* ' ) ;
                                plserver1.text ( ID, 69, '      ' ) ;
                                plserver1.text ( ID, 82, '                 ' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 11, 2 + 128 ) ;
                            END;
                        3:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 22, '   *DEJA RENDU*  ' ) ;
                                plserver1.text ( ID, 69, '      ' ) ;
                                plserver1.text ( ID, 82, '                 ' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 11, 2 + 128 ) ;
                            END;

                        4:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 22, '* CODE PSEUDO * ' ) ;
                                plserver1.text ( ID, 69, '      ' ) ;
                                plserver1.text ( ID, 82, '                 ' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 11, 2 + 128 ) ;
                            END;

                        10: //Annulation OK
                            BEGIN
                                plserver1.text ( ID, 22, NumArticle[picoid ( id ) , 1] + ' ' + copy ( desiarticle[picoid ( id ) , 1], 1, 11 ) ) ;
                                plserver1.text ( id, 69, numclient[picoid ( id ) ] ) ;
                                plserver1.text ( id, 82, copy ( nomclient[picoid ( id ) ], 1, 18 ) ) ;

                                plserver1.fieldcmd ( ID, 11, 2 + 8 ) ;
                                plserver1.text ( ID, 140, '                    ' ) ;
                                plserver1.text ( ID, 140, 'ANNULATION' ) ;

                                plserver1.newfield ( ID, 152, 3, 1 + 8 ) ;
                                plserver1.fldtxt ( id, 152, 'NON' ) ;

                                plserver1.newfield ( ID, 157, 3, 1 + 8 + 128 ) ;
                                plserver1.fldtxt ( id, 157, 'OUI' ) ;

                                plserver1.fieldcmd ( ID, 157, 2 + 128 ) ;
                            END;

                        11: //Annulation impossible
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 22, 'ANNUL IMPOSSIBLE' ) ;
                                plserver1.text ( ID, 140, '                    ' ) ;
                                Annul[picoid ( id ) ] := false;
                                plserver1.fieldcmd ( ID, 11, 2 + 128 ) ;
                            END;
                    END;
                END;

                //-----------------------Annulation----------------------
                IF plserver1.getdata ( ID, 0 ) = 'F5' THEN
                BEGIN

                    plserver1.text ( ID, 20, '                    ' ) ;
                    plserver1.text ( ID, 69, '      ' ) ;
                    plserver1.text ( ID, 80, '                    ' ) ;

                    IF Annul[picoid ( id ) ] = false THEN
                    BEGIN
                        plserver1.text ( ID, 140, '**** ANNULATION ****' ) ;
                        Annul[picoid ( id ) ] := true;
                    END
                    ELSE
                    BEGIN
                        plserver1.text ( ID, 140, '                    ' ) ;
                        Annul[picoid ( id ) ] := false;
                    END;
                    plserver1.fieldcmd ( ID, 11, 2 + 128 ) ;
                END;

                //------------------------Confirmation de l'annulation------------------------------------------------
                IF ( plserver1.isdata ( ID, 157 ) ) AND ( Annul[picoid ( id ) ] ) THEN
                BEGIN
                    Annul[picoid ( id ) ] := false;
                    EcranRetour ( id ) ; //Raz Ecran
                    IF tbl_retour.Locate ( 'cleo022', LastCleo022[picoid ( id ) ], [] ) THEN
                        tbl_retour.delete;
                    InitTableau ( id ) ;
                    que_visuretour.close;
                    que_visuretour.open;
                END;

                //------------------------Annulation de l'annulation------------------------------------------------
                IF ( plserver1.isdata ( ID, 152 ) ) AND ( Annul[picoid ( id ) ] ) THEN
                BEGIN
                    Annul[picoid ( id ) ] := false;
                    LastCleo022[picoid ( id ) ] := ''; //Pour eviter les erreurs...
                    EcranRetour ( id ) ; //Raz Ecran
                    InitTableau ( id ) ;
                END;

                plserver1.send ( ID, 3 ) ;
            END;

        4:          //---------------------------------------------------------------
            BEGIN   //--Module Echange
                    //---------------------------------------------------------------

                //------------Article Rendu-----------------
                IF ( plserver1.isdata ( ID, 26 ) ) AND ( NOT degressivite[picoid ( id ) ] ) THEN
                BEGIN
                    numarticle[picoid ( id ) , 1] := plserver1.getdata ( ID, 26 ) ;
                    CASE Test_Retour ( id ) OF
                        1:
                            BEGIN
                                //Ménage Ecran
                                plserver1.text ( ID, 42, '                  ' ) ;
                                plserver1.text ( ID, 82, '                  ' ) ;
                                plserver1.text ( ID, 100, '                    ' ) ;
                                plserver1.text ( ID, 122, '                  ' ) ;
                                plserver1.text ( ID, 140, '                    ' ) ;
                                plserver1.fieldcmd ( ID, 66, 2 ) ;
                                plserver1.fieldcmd ( ID, 110, 1 ) ;
                                plserver1.text ( ID, 42, NumArticle[picoid ( id ) , 1] + ' ' + copy ( desiarticle[picoid ( id ) , 1], 1, 11 ) ) ;
                                plserver1.text ( id, 122, copy ( nomclient[picoid ( id ) ], 1, 18 ) ) ;
                                plserver1.fieldcmd ( ID, 66, 2 + 128 ) ;
                            END;
                        0:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 42, '*INEXISTANT*     ' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 26, 2 + 128 ) ;
                            END;
                        2:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 42, '*PAS EN LOCATION* ' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 26, 2 + 128 ) ;
                            END;
                        3:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 42, '   *DEJA RENDU*  ' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 26, 2 + 128 ) ;
                            END;
                        4:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 42, '   *CODE PSEUDO*  ' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 26, 2 + 128 ) ;
                            END;

                        10: //Annulation OK
                            BEGIN
                                plserver1.text ( ID, 42, NumArticle[picoid ( id ) , 1] + ' ' + copy ( desiarticle[picoid ( id ) , 1], 1, 11 ) ) ;
                                plserver1.text ( ID, 82, NumArticle[picoid ( id ) , 2] + ' ' + copy ( desiarticle[picoid ( id ) , 2], 1, 11 ) ) ;
                                plserver1.text ( id, 122, copy ( nomclient[picoid ( id ) ], 1, 18 ) ) ;

                                plserver1.fieldcmd ( ID, 26, 2 + 8 ) ;
                                plserver1.fieldcmd ( ID, 66, 2 + 8 ) ;

                                plserver1.text ( ID, 140, '                    ' ) ;
                                plserver1.text ( ID, 140, 'ANNULATION' ) ;

                                plserver1.newfield ( ID, 152, 3, 1 + 8 ) ;
                                plserver1.fldtxt ( id, 152, 'NON' ) ;

                                plserver1.newfield ( ID, 157, 3, 1 + 8 + 128 ) ;
                                plserver1.fldtxt ( id, 157, 'OUI' ) ;

                                plserver1.fieldcmd ( ID, 157, 2 + 128 ) ;
                            END;

                        11: //Annulation impossible
                            BEGIN
                                EcranEchange ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 42, 'ANNUL IMPOSSIBLE' ) ;
                                plserver1.text ( ID, 140, '                    ' ) ;
                                Annul[picoid ( id ) ] := false;
                                plserver1.fieldcmd ( ID, 26, 2 + 128 ) ;
                            END;

                    END;

                END;

                //-------------Article sorti------------------------------------

                IF ( plserver1.isdata ( ID, 66 ) ) AND ( NOT Annul[picoid ( id ) ] ) AND ( NOT degressivite[picoid ( id ) ] ) THEN
                BEGIN
                    numarticle[picoid ( id ) , 2] := plserver1.getdata ( ID, 66 ) ;
                    CASE Test_Article ( 2, id, pseudo ) OF
                        1:
                            BEGIN
                                plserver1.Fldtxt ( ID, 66, numarticle[picoid ( id ) , 2] ) ;
                                plserver1.text ( ID, 82, copy ( DesiArticle[picoid ( id ) , 2], 1, 18 ) ) ;
                                IF pseudo THEN
                                BEGIN
                                    plserver1.text ( ID, 100, 'Code Reel:          ' ) ;
                                    plserver1.newfield ( ID, 110, 8, 1 + 16 + 128 ) ; //Code reel
                                    ChpCodReel[picoid ( id ) , 2] := true;
                                END
                                ELSE
                                BEGIN
                                    ChpCodReel[picoid ( id ) , 2] := false;
                                    IF RegFix[picoid ( id ) , 2] THEN
                                    BEGIN
                                        plserver1.text ( ID, 131, ' Fix:' ) ;
                                        plserver1.newfield ( ID, 136, 4, 1 + 16 + 128 ) ; //Reglage Fixation
                                    END
                                    ELSE
                                    BEGIN
                                        EcranDegressivite ( id ) ; //Validation de l'echange
                                    END;
                                END;

                            END;
                        0:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 82, '*INEXISTANT*' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 66, 2 + 128 ) ;
                            END;
                        2:
                            BEGIN
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.text ( ID, 82, '*DEJA LOUE*' ) ;
                                plserver1.bell ( id ) ;
                                plserver1.bell ( id ) ;
                                plserver1.fieldcmd ( ID, 66, 2 + 128 ) ;
                            END;
                    END;

                END;

                //-------------Code reel------------------------------------
                IF ( plserver1.isdata ( ID, 110 ) ) AND ( NOT Annul[picoid ( id ) ] ) AND ( NOT degressivite[picoid ( id ) ] ) THEN
                BEGIN
                    CodeReel[picoid ( id ) , 2] := plserver1.getdata ( ID, 110 ) ;
                    IF regfix[picoid ( id ) , 2] THEN
                    BEGIN
                        plserver1.text ( ID, 131, ' Fix:' ) ;
                        plserver1.newfield ( ID, 136, 4, 1 + 16 + 128 ) ; //Reglage Fixation
                    END
                    ELSE
                    BEGIN
                        EcranDegressivite ( id ) ;
                    END;
                END;

                //------------------------REG FIXATION -------------------------------------------------
                IF ( plserver1.isdata ( ID, 136 ) ) AND ( NOT Annul[picoid ( id ) ] ) AND ( NOT degressivite[picoid ( id ) ] ) THEN
                BEGIN
                    ReglageFix[picoid ( id ) , 2] := plserver1.getdata ( ID, 136 ) ;
                    EcranDegressivite ( id ) ; //Validation de la locaction
                END;

                //-----------------------Annulation----------------------
                IF plserver1.getdata ( ID, 0 ) = 'F5' THEN
                BEGIN

                    plserver1.text ( ID, 40, '                    ' ) ;
                    plserver1.text ( ID, 80, '                    ' ) ;
                    plserver1.text ( ID, 120, '                    ' ) ;
                    plserver1.fieldcmd ( ID, 66, 2 ) ;

                    IF Annul[picoid ( id ) ] = false THEN
                    BEGIN
                        plserver1.text ( ID, 140, '**** ANNULATION ****' ) ;
                        Annul[picoid ( id ) ] := true;
                    END
                    ELSE
                    BEGIN
                        plserver1.text ( ID, 140, '                    ' ) ;
                        Annul[picoid ( id ) ] := false;
                    END;
                    plserver1.fieldcmd ( ID, 26, 2 + 128 ) ;
                END;

                //------------------------Confirmation de l'annulation------------------------------------------------
                IF ( plserver1.isdata ( ID, 157 ) ) AND ( Annul[picoid ( id ) ] ) THEN
                BEGIN
                    Annul[picoid ( id ) ] := false;
                    EcranEchange ( id ) ; //Raz Ecran
                    IF tbl_ech.Locate ( 'cleo023', LastCleo023[picoid ( id ) ], [] ) THEN
                        tbl_ech.delete;
                    InitTableau ( id ) ;
                    que_visuech.close;
                    que_visuech.open;
                END;

                //------------------------Annulation de l'annulation------------------------------------------------
                IF ( plserver1.isdata ( ID, 152 ) ) AND ( Annul[picoid ( id ) ] ) THEN
                BEGIN
                    Annul[picoid ( id ) ] := false;
                    LastCleo023[picoid ( id ) ] := ''; //Pour eviter les erreurs...
                    EcranEchange ( id ) ; //Raz Ecran
                    InitTableau ( id ) ;
                END;

                //------------------------Reponse à la degressivite----------------------------------
                IF ( plserver1.isdata ( ID, 153 ) ) AND ( degressivite[picoid ( id ) ] ) THEN
                BEGIN
                    degress[picoid ( id ) ] := 'N';
                    plserver1.fieldcmd ( id, 153, 1 ) ;
                    plserver1.fieldcmd ( id, 157, 1 ) ;
                    degressivite[picoid ( id ) ] := false;
                    plserver1.fieldcmd ( ID, 26, 2 + 128 ) ; //Code Rendu
                    plserver1.text ( id, 140, '            ' ) ;
                    Traitement_Echange ( id ) ;
                END;

                //------------------------Reponse à la degressivite----------------------------------
                IF ( plserver1.isdata ( ID, 157 ) ) AND ( degressivite[picoid ( id ) ] ) THEN
                BEGIN
                    degress[picoid ( id ) ] := 'O';
                    plserver1.fieldcmd ( id, 153, 1 ) ;
                    plserver1.fieldcmd ( id, 157, 1 ) ;
                    degressivite[picoid ( id ) ] := false;
                    plserver1.fieldcmd ( ID, 26, 2 + 128 ) ; //Code Rendu
                    plserver1.text ( id, 140, '            ' ) ;
                    Traitement_Echange ( id ) ;
                END;

                plserver1.send ( ID, 4 ) ;

            END;
    END;
END;

FUNCTION Tfrm_main.Test_Article ( ordre: integer; id: integer; VAR pseudo: boolean ) : integer;
VAR
    i, j: integer;
    catego: STRING;
BEGIN
    result := 1;
    regfix[picoid ( id ) , ordre] := false;
    pseudo := false;

    IF Que_CB.Locate ( 'fcb_art', numarticle[picoid ( id ) , ordre], [loCaseInsensitive] ) THEN
    BEGIN
        numarticle[picoid ( id ) , ordre] := copy ( Que_CBCLEO024.asstring, 2, 6 ) ;
    END;

    IF ( length ( numarticle[picoid ( id ) , ordre] ) = 8 ) AND ( copy ( numarticle[picoid ( id ) , ordre], 1, 1 ) = '3' ) THEN
        numarticle[picoid ( id ) , ordre] := copy ( numarticle[picoid ( id ) , ordre], 2, 6 ) ;

    IF numarticle[picoid ( id ) , ordre] <> '' THEN numarticle[picoid ( id ) , ordre] := AlignLeft ( numarticle[picoid ( id ) , ordre], '0', 6 ) ;

    DesiArticle[picoid ( id ) , ordre] := '';

    IF Que_article.Locate ( 'cleo003', numarticle[picoid ( id ) , ordre], [loCaseInsensitive] ) THEN
    BEGIN
        catego := 'CATE' + que_article.fieldbyname ( 'categ' ) .asstring;
        IF Que_categ.Locate ( 'cleo001', catego, [loCaseInsensitive] ) THEN
        BEGIN

        //Article ok mais test si deja en location
            dejvrac.close;
            dejvrac.parambyname ( 'article' ) .asstring := numarticle[picoid ( id ) , ordre];
            dejvrac.open;
            IF ( NOT dejvrac.eof ) AND ( que_article.fieldbyname ( 'a_typ' ) .asstring = 'N' ) THEN
            BEGIN
            // Article présent dans la file d'attente du Vrac
                dejvrac.close;
                numarticle[picoid ( id ) , ordre] := '';
                result := 2;
            END
            ELSE
            BEGIN
                dejvrac.close;
            //Article ok mais test si deja en location
                que_dejech.close;
                que_dejech.parambyname ( 'article' ) .asstring := numarticle[picoid ( id ) , ordre];
                que_dejech.open;
                IF ( NOT que_dejech.eof ) AND ( que_article.fieldbyname ( 'a_typ' ) .asstring = 'N' ) THEN
                BEGIN
                // Article présent dans la file d'attente du Vrac Echange
                    que_dejech.close;
                    numarticle[picoid ( id ) , ordre] := '';
                    result := 2;
                END
                ELSE
                BEGIN

                //Article non présent dans vrac mais test si déja en loc dans Flbon
                    que_dejech.close;
                    dejloc.close;
                    dejloc.parambyname ( 'article' ) .asstring := numarticle[picoid ( id ) , ordre];
                    dejloc.open;
                    IF ( NOT dejloc.eof ) AND ( que_article.fieldbyname ( 'a_typ' ) .asstring = 'N' ) THEN
                    BEGIN
                        dejloc.close;
                        numarticle[picoid ( id ) , ordre] := '';
                        result := 2;
                    END
                    ELSE
                    BEGIN
                        dejloc.close;
                        IF que_article.fieldbyname ( 'a_typ' ) .asstring = 'N' THEN
                        BEGIN
                    //Un dernier test pour voir si pas en cours d'enreg dans un picolink
                            FOR i := 1 TO 20 DO
                            BEGIN
                                FOR j := 1 TO 2 DO
                                BEGIN
                                    IF NOT ( ( i = picoid ( id ) ) AND ( j = ordre ) ) THEN
                                    BEGIN
                                        IF numarticle[i, j] = numarticle[picoid ( id ) , ordre] THEN
                                        BEGIN
                                            numarticle[picoid ( id ) , ordre] := '';
                                            result := 2;
                                            break;
                                        END;
                                    END;
                                END;
                            END;
                        END;

                        IF result = 1 THEN
                        BEGIN
                         // --Article OK--
                            DesiArticle[picoid ( id ) , ordre] := Que_article.fieldbyname ( 'titre' ) .asstring + '                    ';
                            categ[picoid ( id ) , ordre] := Que_article.fieldbyname ( 'categ' ) .asstring;
                        //Test si saisie de la categorie
                            IF uppercase ( Que_categ.fieldbyname ( 'RegFix' ) .asstring ) = 'O' THEN
                                RegFix[picoid ( id ) , ordre] := true;
                        //Test si Pseudo
                            IF que_article.fieldbyname ( 'a_typ' ) .asstring = 'P' THEN Pseudo := true;
                        END;
                    END;
                END;
            END;
        END
        ELSE
        BEGIN
            IF numarticle[picoid ( id ) , ordre] <> '' THEN
            BEGIN
                numarticle[picoid ( id ) , ordre] := '';
                result := 0;
            END;

        END;
    END
    ELSE
    BEGIN
        IF numarticle[picoid ( id ) , ordre] <> '' THEN
        BEGIN
            numarticle[picoid ( id ) , ordre] := '';
            result := 0;
        END;
    END;

END;

FUNCTION Tfrm_main.TClient ( typ: integer; id: integer ) : boolean;
BEGIN
    result := true;

    IF ( length ( NumClient[picoid ( id ) ] ) = 8 ) AND ( copy ( NumClient[picoid ( id ) ], 1, 1 ) = '1' ) THEN
        NumClient[picoid ( id ) ] := copy ( NumClient[picoid ( id ) ], 2, 6 ) ;

    IF NumClient[picoid ( id ) ] <> '' THEN NumClient[picoid ( id ) ] := AlignLeft ( NumClient[picoid ( id ) ], '0', 6 ) ;

    //IF Que_client.Locate ( 'clec006', NumClient[picoid ( id ) ], [loCaseInsensitive] ) THEN
    //que_client.close;
    que_client.parambyname ( 'Numero' ) .asstring := NumClient[picoid ( id ) ];
    que_client.open;
    IF NOT que_client.eof THEN
        NomClient[picoid ( id ) ] := Que_Client.fieldbyname ( 'nom1' ) .asstring +
            Que_Client.fieldbyname ( 'vid' ) .asstring + ' ' +
            Que_Client.fieldbyname ( 'pre' ) .asstring +
            Que_Client.fieldbyname ( 'PreSuite' ) .asstring + '                    '
    ELSE
    BEGIN

        NumClient[picoid ( id ) ] := '';
        result := false;

    END;
    que_client.close;

END;

FUNCTION Tfrm_main.Test_Retour ( id: integer ) : integer;
VAR
    i, j, ind: integer;
BEGIN

    result := 1;
    IF NumArticle[picoid ( id ) , 1] = '' THEN
    BEGIN
        result := -1;
        exit;
    END;

    IF Que_CB.Locate ( 'fcb_art', numarticle[picoid ( id ) , 1], [loCaseInsensitive] ) THEN
    BEGIN
        numarticle[picoid ( id ) , 1] := copy ( Que_CBCLEO024.asstring, 2, 6 ) ;
    END;

    IF ( length ( NumArticle[picoid ( id ) , 1] ) = 8 ) THEN
    BEGIN
        IF ( copy ( NumArticle[picoid ( id ) , 1], 1, 1 ) = '3' ) THEN
            NumArticle[picoid ( id ) , 1] := copy ( NumArticle[picoid ( id ) , 1], 2, 6 )
        ELSE
        BEGIN
            NumArticle[picoid ( id ) , 1] := '';
            result := 0;
            exit;
        END;
    END;

    IF ( length ( NumArticle[picoid ( id ) , 1] ) > 6 ) THEN
    BEGIN
        NumArticle[picoid ( id ) , 1] := '';
        result := 0;
        exit;
    END;

    IF NumArticle[picoid ( id ) , 1] <> '' THEN NumArticle[picoid ( id ) , 1] := AlignLeft ( NumArticle[picoid ( id ) , 1], '0', 6 ) ;

    IF NOT Annul[picoid ( id ) ] THEN
    BEGIN           //Traitement normal

        IF Que_article.Locate ( 'cleo003', NumArticle[picoid ( id ) , 1], [loCaseInsensitive] ) THEN
        BEGIN
            IF que_article.fieldbyname ( 'a_typ' ) .asstring = 'P' THEN
            BEGIN
                NumArticle[picoid ( id ) , 1] := '';
                result := 4;
            END
            ELSE
            BEGIN

        //Article ok mais test si deja en location
                que_retour.close;
                que_retour.parambyname ( 'article' ) .asstring := NumArticle[picoid ( id ) , 1];
                que_retour.open;
                IF que_retour.eof THEN
                BEGIN
            // Article non présent dans la file d'attente des retours
            // Test si Article en cours vrac echange
                    que_retour.close;
                    que_DejEch.close;
                    que_DejEch.parambyname ( 'article' ) .asstring := NumArticle[picoid ( id ) , 1];
                    que_DejEch.open;
                    IF NOT que_DejEch.eof THEN
                    BEGIN
                        que_DejEch.close;
                        NumArticle[picoid ( id ) , 1] := '';
                        result := 2;
                    END
                    ELSE
                    BEGIN
                        que_dejech.close;
                // Test si article en cours le location
                        dejloc.close;
                        dejloc.parambyname ( 'article' ) .asstring := NumArticle[picoid ( id ) , 1];
                        dejloc.open;
                        IF dejloc.eof THEN
                        BEGIN
                            dejloc.close;
                            NumArticle[picoid ( id ) , 1] := '';
                            result := 2;
                        END
                        ELSE
                        BEGIN
                    // Article en cours de location
                    //--Retrouver la corres avec le client
                            corres.close;
                            corres.parambyname ( 'corres' ) .asstring := copy ( dejloc.fieldbyname ( 'cleo004' ) .asstring, 1, 15 ) ;
                            dejloc.close;
                            corres.open;
                            IF corres.eof THEN
                            BEGIN
                                NumArticle[picoid ( id ) , 1] := '';
                                result := 2;
                                corres.close;
                            END
                            ELSE
                            BEGIN

                    //Un dernier test pour voir si pas en cours d'enreg dans un picolink
                                FOR i := 1 TO 20 DO
                                BEGIN
                                    FOR j := 1 TO 2 DO
                                    BEGIN
                                        IF NOT ( ( i = picoid ( id ) ) AND ( j = 1 ) ) THEN
                                        BEGIN
                                            IF numarticle[i, j] = numarticle[picoid ( id ) , 1] THEN
                                            BEGIN
                                                numarticle[picoid ( id ) , ordre] := '';
                                                result := 3;
                                                corres.close;
                                                break;
                                            END;
                                        END;
                                    END;
                                END;

                                IF result = 1 THEN
                                BEGIN
                                    NumClient[picoid ( id ) ] := corres.fieldbyname ( 'cleo005' ) .asstring;
                                    corres.close;
                                //IF Que_client.Locate ( 'clec006', NumClient[picoid ( id ) ], [loCaseInsensitive] ) THEN
                                //que_client.close;
                                    que_client.parambyname ( 'Numero' ) .asstring := NumClient[picoid ( id ) ];
                                    que_client.open;
                                    IF NOT que_client.eof THEN
                                    BEGIN
                            // C'est tout bon Article et Client
                                        DesiArticle[picoid ( id ) , 1] := Que_article.fieldbyname ( 'titre' ) .asstring;

                                        categ[picoid ( id ) , 1] := Que_article.fieldbyname ( 'categ' ) .asstring;
                                        NomClient[picoid ( id ) ] := Que_Client.fieldbyname ( 'nom1' ) .asstring +
                                            Que_Client.fieldbyname ( 'vid' ) .asstring + ' ' +
                                            Que_Client.fieldbyname ( 'pre' ) .asstring +
                                            Que_Client.fieldbyname ( 'PreSuite' ) .asstring + '                    '
                                    END;
                                    que_client.close;
                                END
                                ELSE
                                BEGIN
                                    corres.close;
                                END;
                            END;
                        END;
                    END;
                END
                ELSE
                BEGIN
                    result := 3; //Lu 2 fois rien à faire
                    que_retour.close;
                END;
            END;
        END
        ELSE
        BEGIN

            IF NumArticle[picoid ( id ) , 1] <> '' THEN
            BEGIN
                NumArticle[picoid ( id ) , 1] := '';
                result := 0;
            END;
        END;
    END
    ELSE
    BEGIN

        //Annulation du retour
        CASE plserver1.GetFormID ( ID ) OF

            2:      // Module des sorties
                BEGIN
                    IF NumArticle[picoid ( id ) , 1] <> '' THEN
                        NumArticle[picoid ( id ) , 1] := AlignLeft ( NumArticle[picoid ( id ) , 1], '0', 6 ) ;

                    IF ( Que_article.Locate ( 'cleo003', NumArticle[picoid ( id ) , 1], [] ) ) AND
                    ( que_article.fieldbyname ( 'a_typ' ) .asstring = 'P' ) THEN
                    BEGIN
                        NumArticle[picoid ( id ) , 1] := '';
                        result := 4;
                    END
                    ELSE
                    BEGIN
                        IF tbl_sortie.locate ( 'v_arti', NumArticle[picoid ( id ) , 1], [] ) THEN
                        BEGIN
                            que_client.parambyname ( 'Numero' ) .asstring := Tbl_sortie.fieldbyname ( 'client' ) .asstring;
                            que_client.open;
                            Numclient[picoid ( id ) ] := Tbl_sortie.fieldbyname ( 'client' ) .asstring;
                            NomClient[picoid ( id ) ] := Que_Client.fieldbyname ( 'nom1' ) .asstring +
                                Que_Client.fieldbyname ( 'vid' ) .asstring + ' ' +
                                Que_Client.fieldbyname ( 'pre' ) .asstring +
                                Que_Client.fieldbyname ( 'PreSuite' ) .asstring + '                    ';
                            que_client.close;

                            LastCleo017[picoid ( id ) , 1] := Numclient[picoid ( id ) ];
                            LastCleo017[picoid ( id ) , 2] := Tbl_sortie.fieldbyname ( 'v_init' ) .asstring;

                            tbl_sortie.first;
                            ind := 1;
                            WHILE NOT tbl_sortie.eof DO
                            BEGIN
                                IF ( Tbl_sortie.fieldbyname ( 'client' ) .asstring = LastCleo017[picoid ( id ) , 1] ) AND
                                ( Tbl_sortie.fieldbyname ( 'v_init' ) .asstring = LastCleo017[picoid ( id ) , 2] ) THEN
                                BEGIN
                                    NumArticle[picoid ( id ) , ind] := tbl_sortie.fieldbyname ( 'v_arti' ) .asstring;
                                    Que_article.Locate ( 'cleo003', NumArticle[picoid ( id ) , ind], [] ) ;
                                    DesiArticle[picoid ( id ) , ind] := Que_article.fieldbyname ( 'titre' ) .asstring;
                                    inc ( ind ) ;
                                    IF ind = 3 THEN break;
                                END;
                                tbl_sortie.next;
                            END;
                            tbl_sortie.last;
                            result := 10;
                        END
                        ELSE
                            result := 11;
                    END;
                END;

            3:      //Module Retour Article
                BEGIN
                    IF NumArticle[picoid ( id ) , 1] <> '' THEN
                        NumArticle[picoid ( id ) , 1] := AlignLeft ( NumArticle[picoid ( id ) , 1], '0', 6 ) ;

                    Que_article.Locate ( 'cleo003', NumArticle[picoid ( id ) , 1], [] ) ;
                    IF que_article.fieldbyname ( 'a_typ' ) .asstring = 'P' THEN
                    BEGIN
                        NumArticle[picoid ( id ) , 1] := '';
                        result := 4;
                    END

                    ELSE
                    BEGIN
                        IF tbl_retour.Locate ( 'rvc_chro', NumArticle[picoid ( id ) , 1], [] ) THEN
                        BEGIN
                            Que_article.Locate ( 'cleo003', NumArticle[picoid ( id ) , 1], [] ) ;
                            que_client.parambyname ( 'Numero' ) .asstring := Tbl_retour.fieldbyname ( 'rvc_cli' ) .asstring;
                            que_client.open;
                            DesiArticle[picoid ( id ) , 1] := Que_article.fieldbyname ( 'titre' ) .asstring;
                            Numclient[picoid ( id ) ] := Tbl_retour.fieldbyname ( 'rvc_cli' ) .asstring;
                            NomClient[picoid ( id ) ] := Que_Client.fieldbyname ( 'nom1' ) .asstring +
                                Que_Client.fieldbyname ( 'vid' ) .asstring + ' ' +
                                Que_Client.fieldbyname ( 'pre' ) .asstring +
                                Que_Client.fieldbyname ( 'PreSuite' ) .asstring + '                    ';
                            que_client.close;
                            result := 10;
                            LastCleo022[picoid ( id ) ] := Tbl_retour.fieldbyname ( 'cleo022' ) .asstring;
                        END
                        ELSE
                            result := 11;
                    END;
                END;

            4:      // Module des echanges
                BEGIN
                    IF NumArticle[picoid ( id ) , 1] <> '' THEN
                        NumArticle[picoid ( id ) , 1] := AlignLeft ( NumArticle[picoid ( id ) , 1], '0', 6 ) ;

                    IF ( Que_article.Locate ( 'cleo003', NumArticle[picoid ( id ) , 1], [] ) ) AND
                    ( que_article.fieldbyname ( 'a_typ' ) .asstring = 'P' ) THEN
                    BEGIN
                        NumArticle[picoid ( id ) , 1] := '';
                        result := 4;
                    END
                    ELSE
                    BEGIN
                        IF tbl_ech.Locate ( 'e_rendu', NumArticle[picoid ( id ) , 1], [] ) OR
                        tbl_ech.Locate ( 'e_sorti', NumArticle[picoid ( id ) , 1], [] ) THEN
                        BEGIN
                            NumArticle[picoid ( id ) , 1] := Tbl_ech.fieldbyname ( 'e_rendu' ) .asstring;
                            Que_article.Locate ( 'cleo003', NumArticle[picoid ( id ) , 1], [] ) ;
                            DesiArticle[picoid ( id ) , 1] := Que_article.fieldbyname ( 'titre' ) .asstring;

                            NumArticle[picoid ( id ) , 2] := Tbl_ech.fieldbyname ( 'e_sorti' ) .asstring;
                            Que_article.Locate ( 'cleo003', NumArticle[picoid ( id ) , 2], [] ) ;
                            DesiArticle[picoid ( id ) , 2] := Que_article.fieldbyname ( 'titre' ) .asstring;

                            que_client.parambyname ( 'Numero' ) .asstring := Tbl_ech.fieldbyname ( 'e_cli' ) .asstring;
                            que_client.open;
                            Numclient[picoid ( id ) ] := Tbl_ech.fieldbyname ( 'e_cli' ) .asstring;
                            NomClient[picoid ( id ) ] := Que_Client.fieldbyname ( 'nom1' ) .asstring +
                                Que_Client.fieldbyname ( 'vid' ) .asstring + ' ' +
                                Que_Client.fieldbyname ( 'pre' ) .asstring +
                                Que_Client.fieldbyname ( 'PreSuite' ) .asstring + '                    ';
                            que_client.close;
                            result := 10;
                            LastCleo023[picoid ( id ) ] := Tbl_Ech.fieldbyname ( 'cleo023' ) .asstring;
                        END
                        ELSE
                            result := 11;
                    END;
                END;
        END;
    END;
END;

PROCEDURE Tfrm_main.Traitement_retour ( id: integer ) ;
VAR
    rvc_date, rvc_heure: STRING;
BEGIN

    DateTimeToString ( rvc_date, 'dd/mm/yy', date ) ;
    DateTimeToString ( rvc_heure, 'hh:nn', time ) ;

    Tbl_retour.insert;
    Tbl_retour.fieldbyname ( 'cleo022' ) .asstring := NumClient[picoid ( id ) ] + NumArticle[picoid ( id ) , 1];
    Tbl_retour.fieldbyname ( 'rvc_cli' ) .asstring := NumClient[picoid ( id ) ];
    Tbl_retour.fieldbyname ( 'rvc_chro' ) .asstring := NumArticle[picoid ( id ) , 1];
    Tbl_retour.fieldbyname ( 'rvc_date' ) .asstring := rvc_date;
    Tbl_retour.fieldbyname ( 'rvc_heur' ) .asstring := rvc_heure;
    Tbl_retour.fieldbyname ( 'rvc_pico' ) .asinteger := id;
    Tbl_retour.post;

    LastCleo022[picoid ( id ) ] := NumClient[picoid ( id ) ] + NumArticle[picoid ( id ) , 1];
    NumClient[picoid ( id ) ] := '';
    NumArticle[picoid ( id ) , 1] := '';
    DesiArticle[picoid ( id ) , 1] := '';
    NomClient[picoid ( id ) ] := '';

    que_visuretour.close;
    que_visuretour.open;
    dbg_retour.fullexpand;

END;

PROCEDURE TFrm_Main.SBtn_RefreshClick ( Sender: TObject ) ;
BEGIN
    que_visusortie.close;
    que_visusortie.open;

    que_visuretour.close;
    que_visuretour.open;

    que_visuech.close;
    que_visuech.open;
END;

PROCEDURE TFrm_Main.Tim_RefreshTimer ( Sender: TObject ) ;
BEGIN
     //Refresh des grilles toutes les minutes
    SBtn_RefreshClick ( Sender ) ;
    dbg_sorties.fullExpand;
    dbg_retour.fullexpand;
    dbg_ech.fullexpand;
END;

FUNCTION Tfrm_main.PicoId ( IdPCL: integer ) : integer;
VAR
    i: integer;
BEGIN
    result := 0;
    FOR i := 1 TO 20 DO
    BEGIN
        IF IdPico[i] = 0 THEN
        BEGIN
               //Le pico n'est pas en core référencé
            result := i;
            IdPico[i] := IdPCL;
            break;
        END;

        IF IdPico[i] = IdPCL THEN
        BEGIN
               //Ok on a trouvé le pico
            result := i;
            break;
        END;
    END;
END;

FUNCTION Tfrm_main.InitialeAuto: STRING;
VAR
    l1, l2: STRING;
BEGIN
//    inc ( i1 ) ;
//    IF i1 > 26 THEN
//    BEGIN
//        i1 := 1;
//        inc ( i2 ) ;
//        IF i2 > 26 THEN i2 := 1;
//    END;
//
//    l1 := copy ( alphabet, i1, 1 ) ;
//    l2 := copy ( alphabet, i2, 1 ) ;
//    result := l2 + l1
    inc ( initial_num ) ;
    result := inttostr ( initial_num ) ;
    IF length ( result ) = 1 THEN result := '0' + result;

END;

PROCEDURE TFrm_Main.LMDSpeedButton1Click ( Sender: TObject ) ;
VAR
    cleo017, cleo022, cleo023: STRING;
    i: integer;
BEGIN

    CASE pgc_picco.activepageindex OF
        0:          //Sortie
            BEGIN

                IF CNFMess ( 'Confirmez vous l''annulation des lignes ? ', '', 1 ) = mrYes THEN
                BEGIN

                    TRY
                        FOR i := 0 TO dbg_sorties.SelectedCount - 1 DO
                        BEGIN
                            cleo017 := dbg_sorties.SelectedNodes[i].Strings[10];
                            IF tbl_sortie.Locate ( 'cleo017', cleo017, [] ) THEN
                                tbl_sortie.delete;
                        END;
                    EXCEPT
                    END;
                    que_visusortie.close;
                    que_visusortie.open;
                    dbg_sorties.fullexpand;
                END;
            END;
        1:          //Retours
            BEGIN

                IF CNFMess ( 'Confirmez vous l''annulation des lignes ? ', '', 1 ) = mrYes THEN
                BEGIN

                    TRY
                        FOR i := 0 TO dbg_retour.SelectedCount - 1 DO
                        BEGIN
                            cleo022 := dbg_retour.SelectedNodes[i].Strings[0];
                            IF tbl_retour.Locate ( 'cleo022', cleo022, [] ) THEN
                                tbl_retour.delete;
                        END;
                    EXCEPT
                    END;
                    que_visuretour.close;
                    que_visuretour.open;
                    dbg_retour.fullexpand;
                END;
            END;

        2:          //Echanges
            BEGIN

                IF CNFMess ( 'Confirmez vous l''annulation des lignes ? ', '', 1 ) = mrYes THEN
                BEGIN

                    TRY
                        FOR i := 0 TO dbg_ech.SelectedCount - 1 DO
                        BEGIN
                            cleo023 := dbg_ech.SelectedNodes[i].Strings[0];
                            IF tbl_ech.Locate ( 'cleo023', cleo023, [] ) THEN
                                tbl_ech.delete;
                        END;
                    EXCEPT
                    END;
                    que_visuech.close;
                    que_visuech.open;
                    dbg_ech.fullexpand;
                END;
            END;
    END;
END;

PROCEDURE TFrm_Main.EcranMenu ( id: integer ) ;
BEGIN
 // --Dessin du  Menu Principal--
    plserver1.clearform ( id ) ;
    plserver1.text ( ID, 0, ' PULKA - PICCOLINK ' ) ;
    plserver1.text ( ID, 20, 'Choix de la fonction' ) ;
    plserver1.button ( id, 40, '      SORTIE        ' ) ;
    plserver1.button ( id, 60, '      RETOUR        ' ) ;
    plserver1.button ( id, 80, '     ECHANGES       ' ) ;
    plserver1.setformid ( ID, 1 ) ;
    plserver1.send ( ID, 1 ) ;
END;

PROCEDURE TFrm_Main.EcranSortie ( id: integer ) ;
BEGIN
//---Dessin ECRAN DES SORTIES---
    plserver1.clearform ( id ) ;

    plserver1.text ( ID, 0, 'SORTIE Clt:' ) ;
    plserver1.text ( ID, 40, 'Art:' ) ;
    plserver1.text ( ID, 52, '  Fx' ) ;
    plserver1.text ( ID, 100, 'Art:' ) ;
    plserver1.text ( ID, 112, '  Fx' ) ;

    plserver1.newfield ( ID, 11, 8, 1 + 16 + 32 + 128 ) ; //Code Client

    plserver1.newfield ( ID, 44, 10, 1 + 16 + 32 ) ; //Code article 1
    plserver1.newfield ( ID, 56, 4, 1 + 16 ) ; //Reg Fix 1
    plserver1.newfield ( ID, 104, 10, 1 + 16 + 32 ) ; //Code Article 2
    plserver1.newfield ( ID, 116, 4, 1 + 16 ) ; //Reg Fix 2
    plserver1.setformid ( ID, 2 ) ;
    plserver1.send ( ID, 2 ) ;
END;

PROCEDURE TFrm_Main.EcranRetour ( id: integer ) ;
BEGIN
 //---Dessin ECRAN DES RETOURS---
    plserver1.clearform ( id ) ;
    plserver1.text ( ID, 0, 'RETOUR Art:' ) ;
    plserver1.text ( ID, 60, 'Client:' ) ;

    plserver1.newfield ( ID, 11, 10, 1 + 16 + 32 + 128 ) ;
    plserver1.setformid ( ID, 3 ) ;
    plserver1.send ( ID, 3 ) ;
END;

PROCEDURE TFrm_Main.EcranEchange ( id: integer ) ;
BEGIN
 //---Dessin ECRAN DES ECHANGES---
    plserver1.clearform ( id ) ;
    plserver1.text ( ID, 0, 'ECHANGES' ) ;
    plserver1.text ( ID, 20, 'Rendu:' ) ;
    plserver1.text ( ID, 60, 'Sorti:' ) ;

    plserver1.newfield ( ID, 26, 10, 1 + 16 + 32 + 128 ) ;
    plserver1.newfield ( ID, 66, 10, 1 + 16 + 32 ) ;
    plserver1.setformid ( ID, 4 ) ;
    plserver1.send ( ID, 4 ) ;
END;

PROCEDURE TFrm_Main.SBtn_QuitterClick ( Sender: TObject ) ;
BEGIN
    close;
END;

PROCEDURE Tfrm_main.Traitement_Echange ( id: integer ) ;

VAR
    rvc_date, rvc_heure: STRING;
BEGIN

    DateTimeToString ( rvc_date, 'dd/mm/yy', date ) ;
    DateTimeToString ( rvc_heure, 'hh:nn', time ) ;

    Tbl_ech.insert;
    Tbl_ech.fieldbyname ( 'cleo023' ) .asstring := NumClient[picoid ( id ) ] + NumArticle[picoid ( id ) , 1] + NumArticle[picoid ( id ) , 2];
    Tbl_ech.fieldbyname ( 'e_cli' ) .asstring := NumClient[picoid ( id ) ];
    Tbl_ech.fieldbyname ( 'e_rendu' ) .asstring := NumArticle[picoid ( id ) , 1];
    Tbl_ech.fieldbyname ( 'e_sorti' ) .asstring := NumArticle[picoid ( id ) , 2];
    tbl_ech.fieldbyname ( 'e_codrel' ) .asstring := CodeReel[picoid ( id ) , 2];
    tbl_ech.fieldbyname ( 'e_RegFix' ) .asstring := ReglageFix[picoid ( id ) , 2];
    Tbl_ech.fieldbyname ( 'e_date' ) .asstring := rvc_date;
    Tbl_ech.fieldbyname ( 'e_heure' ) .asstring := rvc_heure;
    Tbl_ech.fieldbyname ( 'e_pico' ) .asinteger := id;
    Tbl_ech.fieldbyname ( 'e_deg' ) .asstring := Degress[picoid ( id ) ];
    Tbl_ech.post;

    LastCleo023[picoid ( id ) ] := NumClient[picoid ( id ) ] + NumArticle[picoid ( id ) , 1] + NumArticle[picoid ( id ) , 2];

   //Mise à jour de l'écran

    IF RegFix[picoid ( id ) , 2] THEN
    BEGIN
        plserver1.fieldcmd ( id, 136, 1 ) ;
        plserver1.text ( ID, 131, '     ' ) ;
    END;

    IF ChpCodReel[picoid ( id ) , 2] THEN
    BEGIN
        plserver1.fieldcmd ( id, 110, 1 ) ;
        plserver1.text ( ID, 100, '          ' ) ;
    END;

    NumClient[picoid ( id ) ] := '';
    Initiale[picoid ( id ) ] := '';
    oldinit[picoid ( id ) ] := false;
    Degressivite[picoid ( id ) ] := false;

    NumArticle[picoid ( id ) , 1] := '';
    DesiArticle[picoid ( id ) , 1] := '';
    ReglageFix[picoid ( id ) , 1] := '';
    CodeReel[picoid ( id ) , 1] := '';
    RegFix[picoid ( id ) , 1] := false;
    categ[picoid ( id ) , 1] := '';

    NumArticle[picoid ( id ) , 2] := '';
    DesiArticle[picoid ( id ) , 2] := '';
    ReglageFix[picoid ( id ) , 2] := '';
    CodeReel[picoid ( id ) , 2] := '';
    RegFix[picoid ( id ) , 2] := false;
    categ[picoid ( id ) , 2] := '';

    que_visuech.close;
    que_visuech.open;
    dbg_ech.fullexpand;

END;

PROCEDURE Tfrm_main.InitTableau ( id: integer ) ;
BEGIN
    NumClient[picoid ( id ) ] := '';
    Initiale[picoid ( id ) ] := '';
    oldinit[picoid ( id ) ] := false;
    LastCleo022[picoid ( id ) ] := '';
    LastCleo023[picoid ( id ) ] := '';
    OldInitiale[picoid ( id ) ] := '';
    NomClient[picoid ( id ) ] := '';
    Degress[picoid ( id ) ] := '';
    Degressivite[picoid ( id ) ] := false;
    Annul[picoid ( id ) ] := false;

    NumArticle[picoid ( id ) , 1] := '';
    DesiArticle[picoid ( id ) , 1] := '';
    ReglageFix[picoid ( id ) , 1] := '';
    CodeReel[picoid ( id ) , 1] := '';
    RegFix[picoid ( id ) , 1] := false;
    LastCleo017[picoid ( id ) , 1] := '';

    ChpCodReel[picoid ( id ) , 1] := false;
    Categ[picoid ( id ) , 1] := '';

    NumArticle[picoid ( id ) , 2] := '';
    DesiArticle[picoid ( id ) , 2] := '';
    ReglageFix[picoid ( id ) , 2] := '';
    CodeReel[picoid ( id ) , 2] := '';
    RegFix[picoid ( id ) , 2] := false;
    LastCleo017[picoid ( id ) , 2] := '';
    ChpCodReel[picoid ( id ) , 2] := false;
    Categ[picoid ( id ) , 2] := '';

END;

PROCEDURE Tfrm_Main.EcranDegressivite ( id: integer ) ;
BEGIN

   //Tous les champs sont lock
    plserver1.fieldcmd ( ID, 26, 8 ) ;
    plserver1.fieldcmd ( ID, 66, 8 ) ;
    plserver1.fieldcmd ( ID, 110, 8 ) ;

    plserver1.text ( ID, 140, 'DEGRESSIVITE' ) ;

    IF categ[picoid ( id ) , 1] <> categ[picoid ( id ) , 2] THEN
    BEGIN           //Categ différente
        plserver1.newfield ( ID, 157, 3, 1 + 8 ) ;
        plserver1.fldtxt ( id, 157, 'OUI' ) ;

        plserver1.newfield ( ID, 153, 3, 1 + 8 + 128 ) ;
        plserver1.fldtxt ( id, 153, 'NON' ) ;
    END
    ELSE
    BEGIN           //Categ Identique
        plserver1.newfield ( ID, 153, 3, 1 + 8 ) ;
        plserver1.fldtxt ( id, 153, 'NON' ) ;

        plserver1.newfield ( ID, 157, 3, 1 + 8 + 128 ) ;
        plserver1.fldtxt ( id, 157, 'OUI' ) ;
    END;

    Degressivite[picoid ( id ) ] := true;
END;
END.

