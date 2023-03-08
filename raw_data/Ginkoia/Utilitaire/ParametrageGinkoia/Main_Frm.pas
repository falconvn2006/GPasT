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

   ****************************************************************************

   Si l'application ne doit pas pouvoir s'exécuter plusieurs fois ajouter un
   composant "OnlyOne" de chez LMD

   Quelques utilitaires :
       Fonctions Caps et NumLock
       Fonction délai
       Composant pour gérer les fichiers Ini
       Composant pour sauver les propriétés dans Ini (utilisé par Tip of Day)
       Affectation automatique du nom du fichier Ini [NomProject.Ini] recherché
       dans le répertoire d'éxécution
       Idem pour le fichier d'aide (à "décommenter")
       Hints particularisés
       WWRéférence Français
       Format Nomres et Dates
       StatusBar
       Une calculatrice
       Un calendrier
       Un "Tip of the day" alimenté par un fichier de type ini mais dont le nom
       est : [nom du projet].Tip et dont le format interne est
           [TIPS]
           Items0=Premier Tip
           Items1=Deuxième Tip
           ... etc.
       Un boite "A propos" à maintenir.

 Utilisation :

   La gestion des pages est automatisée.
   Nota : Marche avec tous types de Formes mais est beaucoup plus puissant avec
   les formes de TYpe TAlgolFrmSTd

   L'écran de contrôle est incontournablepour que cela marche simplement. Il est
   automatiquement crée et ne peut et ne doit pas être détruit.

   Pour ajouter une forme : FormManager ( Type de la Forme ) ;
   Nota : ne pas maximizer les formes crées car elles le sont automatiquement
   par l'outil LMD pagecontrol
   Ne PAS OUBLIER de mettre le libellé de l'onglet (module) dans la propriété
   "caption" de la forme

   Pour tuer une Forme : Elles se tuent depuis elles mêmes avec le bouton Quitter
   (Si nécessaire en dehors de ce standard utiliser la procedure "FermerPage"
   NOTA : Comme l'évent on close query n'est pas pris en charge par le composant
   page LMD je l'utilise à des fins personnelles depuis le bouton quitter. De ce
   fait on peut continuer à utiliser cet évent normalement pour les contrôles de
   sortie. (Rappel : les events close, Activate et DeActivite ne sont pas pris non
   plus en charge par le composant page de LMD)

   Le nombre de pages Maximum est donné dans la propriété "StdTag" de la MainForm
   (par défaut 10)

   Les pages ont un "ScrollBox" en vue des éventuels écrans 800*600 nous on ne se
   préoccupe de rien on construit des écrans normaux.

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

 Solution adoptée :
   Pour déclencher le "delete" depuis la page elle même j'ai :
   1. Déclaré dans le formes standard algol une propriété publiée de type TBasicAction
      appelée KillAction.
   2. Dans la MainForm j'ai un ActionList (ActLst_Fd) avec une action que j'ai
      appelé Ax_Delete et qui se charge de tuer la page.
   3. Lorsque je crée une nouvelle page j'affecte la propriété "KillAction" de la page
      à l'action Ax_delete. C'est pourquoi les pages n'ont pas besoin de voir la
      MainForm
   4. L'astuce du mécanisme c'est que la seule chose que fait cette action est de
      lancer "FermerPage" dont le rôle est de lancer un "Timer" (100 ms)
      est de provoquer le changement de page (je vais sur la précédente et cela
      marche !) ...
      Le Timer quant à lui prend en charge la destruction de la page qui à déclenché
      l'action. 100ms de deali semblent largement suffisants pour que la procédure
      lancée depuis la page à trucider soit achevée... (augmanter le delai si nécessaire)
      Nota : sans timer cela génère une erreur !

   Rems : le plus dur à été de faire réafficher correctement une page "du milieu" des
   pages existantes, comme toujours... là encore une astuce idiote, aprés le Kill
   je force la page suivante et reviens, et là aussi ça marche !
   Tout ceci génère peu de code et est grandement facilité du fait de la présence
   de "l'écran de contrôle".

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
    Dialogs, IBSQL, DB,
  IBCustomDataSet, IBStoredProc, IBDatabase, IB_Components, IB_StoredProc,
  wwDialog, wwidlg, wwLookupDialogRv, ImgList, ehsHelpRouter, ehsBase,
  ehsWhatsThis, ExtCtrls, Calend, Wwintl, vgStndrt, LMDCustomComponent,
  LMDContainerComponent, LMDBaseDialog, LMDAboutDlg, ActnList, dxBar, cxClasses,
  ComCtrls, LMDFormTabControl, StdCtrls, algolStdFrm, dxSkinsCore,
  dxSkinsdxBarPainter, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkSide, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSilver,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue;

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
        ActLst_Fd: TActionList;
        AboutDlg_Main: TLMDAboutDlg;
        TimeSto_Main: TDateTimeStorage;
        IPLang_Main: TwwIntl;
        Calend_Main: TCalend;
        Fd_Main: TLMDFormTabControl;
        Ax_Delete: TAction;
        Timer_Fd: TTimer;
        Ax_Next: TAction;
        WIS_Main: TWhatsThis;
        HRout_Main: THelpRouter;
        Dxb_IndexHelp: TdxBarButton;
        IbC_TestConnection: TIB_Connection;
        dxB_Mag: TdxBarSubItem;
        dxB_User: TdxBarSubItem;
        dxB_Admin: TdxBarSubItem;
        dxB_MagMagasin: TdxBarButton;
        dxB_MagPermission: TdxBarButton;
        dxB_UserUtil: TdxBarButton;
        dxB_UserGroup: TdxBarButton;
        dxB_UserPerm: TdxBarButton;
        dxB_Param: TdxBarSubItem;
        dxB_Organisation: TdxBarSubItem;
        dxB_Import: TdxBarSubItem;
        dxB_Dossier: TdxBarButton;
        dxB_Classement: TdxBarButton;
        dxB_Genre: TdxBarButton;
        dxB_Serveur: TdxBarButton;
        dxB_Etp: TdxBarButton;
        dxB_NK: TdxBarButton;
        dxB_Taille: TdxBarButton;
        dxB_typeCpt: TdxBarButton;
        dxB_TVA: TdxBarButton;
        dxB_CdtPaie: TdxBarButton;
        dxB_Civilite: TdxBarButton;
        dxB_ModeR: TdxBarButton;
        dxB_CptVente: TdxBarButton;
        ImageList1: TImageList;
        dxB_Conso: TdxBarButton;
        dxB_ExeCom: TdxBarButton;
        dxB_Trait: TdxBarSubItem;
        dxBTypeCDV: TdxBarButton;
        LK_TYPECDV: TwwLookupDialogRV;
        dxB_NegParam: TdxBarButton;
        LK_NEGOCE: TwwLookupDialogRV;
        OD_NK: TOpenDialog;
        dxB_Fedas: TdxBarButton;
        OD_PrepaImportFEDAS: TOpenDialog;
        dxB_AddNK: TdxBarButton;
        dxB_CB: TdxBarButton;
        dxB_CptClient: TdxBarButton;
        dxB_MultiTarif: TdxBarButton;
        dxB_MouliTCT: TdxBarButton;
        dxB_CDV: TdxBarButton;
        Lab_VersionBase: TLabel;
        dxB_MrkFourn: TdxBarButton;
        IbStProc_MrkFourn: TIB_StoredProc;
        dxB_CalcTrigger: TdxBarButton;
        Data: TIBDatabase;
        Tran: TIBTransaction;
        IBStProc_TriggerDiffere: TIBStoredProc;
        IBSql_Trigger: TIBSQL;
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
        PROCEDURE AlgolStdFrmShow(Sender: TObject);
        PROCEDURE Dxb_QuitClick(Sender: TObject);
        PROCEDURE Dxb_HelpClick(Sender: TObject);
        PROCEDURE Dxb_calcClick(Sender: TObject);
        PROCEDURE Dxb_CalendClick(Sender: TObject);
        PROCEDURE Dxb_AboutClick(Sender: TObject);
        PROCEDURE Dxb_TipClick(Sender: TObject);
        PROCEDURE Ax_DeleteExecute(Sender: TObject);
        PROCEDURE AlgolStdFrmCloseQuery(Sender: TObject;
            VAR CanClose: Boolean);
        PROCEDURE Timer_FdTimer(Sender: TObject);
        PROCEDURE Ax_NextExecute(Sender: TObject);
        PROCEDURE Fd_MainChanging(Sender: TObject; NewForm: TCustomForm;
            VAR Cancel: Boolean);
        PROCEDURE WIS_MainHelp(Sender, HelpItem: TObject; IsMenu: Boolean;
            HContext: THelpContext; X, Y: Integer; VAR CallHelp: Boolean);
        PROCEDURE Dxb_IndexHelpClick(Sender: TObject);
        PROCEDURE Bm_MainClickItem(Sender: TdxBarManager;
            ClickedItem: TdxBarItem);
        PROCEDURE dxB_MagMagasinClick(Sender: TObject);
        PROCEDURE dxB_MagPermissionClick(Sender: TObject);
        PROCEDURE dxB_UserUtilClick(Sender: TObject);
        PROCEDURE dxB_UserGroupClick(Sender: TObject);
        PROCEDURE dxB_UserPermClick(Sender: TObject);
        PROCEDURE AlgolStdFrmClose(Sender: TObject; VAR Action: TCloseAction);
        PROCEDURE dxB_DossierClick(Sender: TObject);
        PROCEDURE dxB_GenreClick(Sender: TObject);
        PROCEDURE dxB_NKClick(Sender: TObject);
        PROCEDURE dxB_TailleClick(Sender: TObject);
        PROCEDURE dxB_EtpClick(Sender: TObject);
        PROCEDURE dxB_ServeurClick(Sender: TObject);
        PROCEDURE dxB_ConsoClick(Sender: TObject);
        PROCEDURE dxB_ExeComClick(Sender: TObject);
        PROCEDURE dxBTypeCDVClick(Sender: TObject);
        PROCEDURE dxB_NegParamClick(Sender: TObject);
        PROCEDURE dxB_FedasClick(Sender: TObject);
        PROCEDURE dxB_AddNKClick(Sender: TObject);
        PROCEDURE dxB_CBClick(Sender: TObject);
        PROCEDURE dxB_CptClientClick(Sender: TObject);
        PROCEDURE dxB_MultiTarifClick(Sender: TObject);
        PROCEDURE dxB_MouliTCTClick(Sender: TObject);
        PROCEDURE dxB_CDVClick(Sender: TObject);
        PROCEDURE dxB_MrkFournClick(Sender: TObject);
        PROCEDURE dxB_CalcTriggerClick(Sender: TObject);
    PRIVATE
    { Private declarations }
        FcheminFicInit, FCheminFicImport: STRING;
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
        BtClic: Integer;
        PROCEDURE ActiveTab(Value: Integer);
        PROCEDURE FormManager(Aclass: TFormClass);
        PROCEDURE FermePage(Value: Integer);
        FUNCTION CtrlChgtOnglet(OkMess: Boolean): Boolean;
    PUBLISHED
    { Published declarations }
        PROPERTY cheminFicInit: STRING READ FcheminFicInit WRITE FcheminFicInit;
        PROPERTY CheminFicImport: STRING READ FCheminFicImport WRITE FCheminFicImport;

    END;

RESOURCESTRING
    TitrePrint = 'Titre du rapport';
    TitreNom = 'Nom : ';
    ErrCheminInitialiser = 'Impossible de trouver le chemin pour initialiser les données de la base !';
    ErrCheminImport = 'Impossible de trouver le chemin pour réaliser les imports !';
    NKok = 'Export de la nomenclature terminé';
    GTFok = 'Export des Grille de Taille Fournisseur terminé';
    GTSok = 'Export des Grille de Taille Stat. terminé';
    PrepaFEDASno = 'Erreur lors de la création du fichier temporaire "FEDAS_TEMP.csv"';
    PrepaFEDASok = 'Préparation de l' + #39 + 'import de la nomenclature FEDAS terminée';
    CSVtoTXTno = 'Erreur lors de la transformation du CSV en txt !';
    FinTraite = 'Fin du traitement';

VAR
    Frm_Main: TFrm_Main;

IMPLEMENTATION

USES
    StdUtils,
    GinkoiaResStr,
    SelectDB_Frm, //Rap_Dm,
    Uil_Dm,
    Main_Dm,
    GinKoiaStd,
    ParamInit_Frm,
    CScreen_Frm,
    Dossier_Frm,
    NK_DM,
    ParamSoc_Frm,
    ServeurListe_Frm,
    ParamInit_Dm,
    Correction_Dm,
    Ajout_Dm,
    PrepaImportFEDAS_Dm,
    MouliCB_frm,
    MouliCdv_frm,
    MouliTCT_Frm,
    RepareCltFact_Frm,
    RepareMultiPx_Frm;

{$R *.DFM}

TYPE
    TmyCustomdxBarControl = CLASS(TCustomdxBarControl);

//--------------------------------------------------------------------------------
// Fonctions propriétaires
//--------------------------------------------------------------------------------

// Gestion page à Onglet ...

//****************** Routine de contrôle de chgt d'onglet ***********

FUNCTION TFrm_Main.CtrlChgtOnglet(OkMess: Boolean): Boolean;
VAR
    i: Integer;
BEGIN
    Result := True;

    IF (NOT CanChangeOnglet) AND
        (fd_main.ActiveFormIndex <> -1) AND
        (fd_main.Forms[fd_main.ActiveFormIndex] IS TAlgolStdFrm) THEN
    BEGIN
        // Remarque : propriété CanChangeOnglet
        // --------
        // Si on autorise le changement d'onglet dans tous les cas si cet onglet
        // contient une outBar l'état des pages de ce composant importe peu et le chgt est autorisé

        Result := NOT ((fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).StdTag >= 0);
        IF (NOT Result) AND OkMess THEN INFMESS(ErrPgTab, '');

        IF Result THEN
        BEGIN
            // ok pour onglet, Contrôle alors OutBar car alors ne doit pas pouvoir
            // changer d'onglet si l'une des pages outbar à son stdTag mis
            // Dans le cas d'onglet contenant une outBar le contrôle est déporté de
            // l'onglet conteneur sur l'ensemble des pages...

            IF (fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).FcOutLookBar <> NIL THEN
                 // If Not ( fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm ).CanChangeFcPage THEN
                 // ic rien à voir avec le chgt de page FcOutBar

                IF (fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).FcTagedPages.Count > 0 THEN
                    Result := False
                ELSE
                    IF (fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).FormDisplay.Form <> NIL
                        THEN
                        Result := NOT (((fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm
                            ).FormDisplay.Form AS TAlgolStdFrm).StdTag >= 0);

            IF (NOT Result) AND OkMess THEN INFMESS(ErrPgFc, '');
            IF (NOT Result) THEN (fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).ActiveFirstTagedFcPage;
        END;

    END;

    IF Result THEN
        IF (fd_main.ActiveFormIndex <> -1) THEN
            IF (fd_main.Forms[fd_main.ActiveFormIndex] IS TAlgolStdFrm) THEN
                // si result mémorise le composant actif pour pouvoir le restituer au retour ...
                IF ((fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).FcOutlookBar <> NIL) AND
                    ((fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).FormDisplay.Form <> NIL) THEN
                BEGIN
                    IF ((fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).FormDisplay.Form IS TAlgolStdFrm) THEN
                    BEGIN
                        FOR i := 0 TO (fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).FormDisplay.Form.ComponentCount - 1 DO
                            IF ((fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).FormDisplay.Form.Components[i] IS TWinControl) THEN
                                IF ((fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).FormDisplay.Form.Components[i] AS TWinControl).Focused THEN BEGIN
                                    ((fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).FormDisplay.Form AS TAlgolStdFrm).CurCtrl := ((fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).FormDisplay.Form.Components[i] AS TWinControl);
                                    break;
                                END;
                    END;
                END
                ELSE BEGIN
                    FOR i := 0 TO (fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).ComponentCount - 1 DO
                        IF ((fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).Components[i] IS TWinControl) THEN
                            IF ((fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).Components[i] AS TWinControl).Focused THEN BEGIN
                                (fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).CurCtrl := ((fd_main.Forms[fd_main.ActiveFormIndex] AS TAlgolStdFrm).Components[i] AS TWinControl);
                                break;
                            END;
                END;
END;

//******************* TFrm_Main.FormManager *************************
// Création des pages sauf pour les OnlyOne pages ou le fait de tenter
// de la recréer ouvre dessus

PROCEDURE TFrm_Main.FormManager(Aclass: TFormClass);
VAR
    Full, Unik: Boolean;
    n, i, cpt: Integer;
    FrmIndices: ARRAY[0..20] OF Boolean;
BEGIN

    // Contrôle d'abord si le changement de page n'est pas interdit
    IF NOT CtrlChgtOnglet(True) THEN Exit;

    Unik := False;
    Full := fd_main.FormCount >= StdTag;

    Cpt := -1;
    FOR i := 0 TO 20 DO
        FrmIndices[i] := False;
    // tableau des indices des libellés des pages

    n := -1;
    FOR i := 0 TO fd_main.formCount - 1 DO
        IF (fd_main.Forms[i] IS Aclass) THEN n := i;

    IF n <> -1 THEN
        IF (fd_main.Forms[n] IS TAlgolStdFrm) THEN
            IF (fd_main.Forms[n] AS TAlgolStdFrm).OnlyOneInstance THEN Unik := True;
    // Le contrôle d'unicité ne peut être effectué que sur les pages TAlgolFrmStd

    IF Unik THEN
        ActiveTab(n)
    ELSE
    BEGIN
        IF (n <> 1) AND Full THEN
            INFMESS(ErrFullPages, '')
        ELSE
        BEGIN

            IF n <> -1 THEN
            BEGIN
                FOR i := 0 TO fd_main.formCount - 1 DO
                    IF (fd_main.Forms[i] IS Aclass) THEN Frmindices[Fd_main.Forms[i].Tag] := True;
            END;
            FOR i := 0 TO 20 DO
                IF NOT Frmindices[i] THEN
                BEGIN
                    cpt := i;
                    Break;
                END;
            // Numérotation auto des libellés des onglets et Captions des formes

            i := Fd_main.AddFormClass(Aclass, True);
            // Création

            IF (fd_main.Forms[i] IS TAlgolStdFrm) THEN
            BEGIN
                IF (fd_main.Forms[i] AS TAlgolStdFrm).OnlyOneInstance THEN Cpt := -1;
                (fd_main.Forms[i] AS TAlgolStdFrm).KillAction := Ax_Delete;
                // Si de type TAlgolFrmStd affection l'action de destruction
            END;

            IF Cpt <> -1 THEN
            BEGIN
                fd_main.Forms[i].Tag := Cpt;
                fd_main.Forms[i].caption := fd_main.Forms[i].Caption + ' (' + IntToStr(Cpt + 1) + ')';
                Fd_main.Tabs[i] := fd_main.Forms[i].Caption;
                // Affecte les libellés
            END;
            fd_main.TabIndex := i;
        END;
    END;
END;

//--------------------------------------------------------------------------------
//Système FORM
//--------------------------------------------------------------------------------

//******************* TFrm_Main.AlgolMainFrmCreate *************************
// Création de la forme principale

PROCEDURE TFrm_Main.AlgolStdFrmCreate(Sender: TObject);
VAR
    flag: Boolean;
BEGIN
    Flag := False;
    REPEAT
        IF NOT Tfrm_SelectDBExecute THEN Break;

        // Test de la connection à la base
        IbC_TestConnection.Databasename := StdGinkoia.iniCtrl.readString('DATABASE', 'PATH', '');
        IbC_TestConnection.USERNAME := StdGinkoia.iniCtrl.readString('DATABASE',
            'USERNAME', 'GINKOIA');
        IbC_TestConnection.PASSWORD := StdGinkoia.iniCtrl.readString('DATABASE',
            'PASSWORD',
            'ginkoia');
        IbC_TestConnection.SQLDialect := StdGinkoia.iniCtrl.ReadInteger('DATABASE', 'SQLDIALECT', 3);
        TRY
            IbC_TestConnection.Connected := True;
            Flag := True;
        EXCEPT
            ErrMess('Base de données non trouvée ...     ', '');
        END;
        IbC_TestConnection.Connected := False;

    UNTIL Flag;
    IF NOT Flag THEN Application.terminate;

    TRY
        Dm_Main := TDm_Main.Create(Application);
       //StdGinKoia := TStdGinKoia.Create( Application);
    EXCEPT
        Application.Terminate;
    END;

    IF NOT Dm_UIL.Login THEN
        Application.Terminate
    ELSE IF Dm_Uil.ExisteUser AND NOT Dm_UIL.DroitAlgol THEN
    BEGIN
        ErrMess('Il faut les droits ALGOL pour entrer dans ce programme ...     ', '');
        Application.Terminate;
    END;
    formManager(TFrm_CScreen);

    IF Lab_VersionBase.Caption <> '' THEN
    BEGIN
        Dm_Main.IbC_Script.Sql.Clear;
        Dm_Main.IbC_Script.Sql.Add('select Ver_version');
        Dm_Main.IbC_Script.Sql.Add('from genversion');
        Dm_Main.IbC_Script.Sql.Add('where ver_date = (select max(ver_date) from genversion)');
        Dm_Main.IbC_Script.Open;
        IF Dm_Main.IbC_Script.Fields[0].AsString <> Lab_VersionBase.Caption THEN
        BEGIN
            Application.MessageBox(Pchar(CstProbVersion), Pchar(CstAttention), MB_OK);
            IF StdGinkoia.IniCtrl.ReadInteger('ALGOL', 'VERSION', 0) = 0 THEN
                Application.Terminate;
        END;
    END;

    StdGinkoia.LoadSmallBmp('CalcJaune', dxB_CalcTrigger);
END;

//******************* TFrm_Main.AlgolMainFrmShow *************************
//

PROCEDURE TFrm_Main.AlgolStdFrmShow(Sender: TObject);
VAR ch: STRING;
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
        IF StdGinkoia.Tip_Main.ShowAtStartup THEN ExecTip;
    END;

    FcheminFicInit := StdGinkoia.iniCtrl.readString('INITIALISER', 'PATH', '');
    ch := '';
    IF FcheminFicInit = '' THEN
    BEGIN
        ERRMess(ErrCheminInitialiser, '');
        ch := StdGinkoia.iniCtrl.readString('DATABASE', 'PATH', '');
        ch := copy(ch,1,LastDelimiter('\', ch));
        FcheminFicInit := ch + 'Initialiser\';
        StdGinkoia.iniCtrl.WriteString('INITIALISER', 'PATH', FcheminFicInit);
    END
    ELSE
    BEGIN
        ch := copy(FcheminFicInit, length(FcheminFicInit), length(FcheminFicInit));
        IF ch <> '\' THEN FcheminFicInit := FcheminFicInit + '\';
    END;

    FcheminFicImport := StdGinkoia.iniCtrl.readString('IMPORT', 'PATH', '');
    ch := '';
    IF FcheminFicImport = '' THEN
    begin
        ERRMess(ErrCheminImport, '');
        ch := StdGinkoia.iniCtrl.readString('DATABASE', 'PATH', '');
        ch := copy(ch,1,LastDelimiter('\', ch));
        FcheminFicInit := ch + 'import\';
        StdGinkoia.iniCtrl.WriteString('IMPORT', 'PATH', FcheminFicInit);
    end
    ELSE
    BEGIN
        ch := copy(FcheminFicImport, length(FcheminFicImport), length(FcheminFicImport));
        IF ch <> '\' THEN FcheminFicImport := FcheminFicImport + '\';
    END;

END;

//******************* TFrm_Main.AlgolStdFrmCloseQuery *************************
// Contrôle de fermeture : impossible si pages existantes

PROCEDURE TFrm_Main.AlgolStdFrmCloseQuery(Sender: TObject;
    VAR CanClose: Boolean);
BEGIN
    IF fd_main.FormCount > 1 THEN
    BEGIN
        INFMESS(ErrTacheOpen, '');
        Canclose := False;
    END;
END;

//******************* TFrm_Main.Timer_FdTimer *************************
// Timer associé à la destruction

PROCEDURE TFrm_Main.Timer_FdTimer(Sender: TObject);
BEGIN
    Timer_Fd.Enabled := False;
    fd_main.RemoveForm(fd_main.Forms[Timer_Fd.Tag], True);
    fd_main.SelectNextForm(False);
    fd_main.SelectNextForm(True);
END;

//******************* TFrm_Main.Ax_DeleteExecute *************************
// Action de destruction

PROCEDURE TFrm_Main.Ax_DeleteExecute(Sender: TObject);
BEGIN
    FermePage(fd_main.ActiveFormIndex);
END;

//******************* TFrm_Main.Ax_NextExecute *************************
// Action page suivante

PROCEDURE TFrm_Main.Ax_NextExecute(Sender: TObject);
BEGIN
    // Pour les pages au standard algol on la propriété StdTag de la forme sert
    // de témoin pour autoriser le changement de page
    // si stdTag >= 0 interdit...
    // Il suffit donc de gérer au travers de cette propriété !

    IF fd_main.ActiveFormIndex = -1 THEN Exit;

    IF CtrlChgtOnglet(True) THEN
    BEGIN
        IF fd_main.ActiveFormIndex = fd_main.FormCount - 1 THEN
            ActiveTab(0)
        ELSE
            ActiveTab(fd_main.ActiveFormIndex + 1);
    END;

END;

//******************* TFrm_Main.Fd_MainChanging *************************
// Contrôle du changement de page

PROCEDURE TFrm_Main.Fd_MainChanging(Sender: TObject; NewForm: TCustomForm;
    VAR Cancel: Boolean);
BEGIN
    // CtrlChgt d'onglet retourne True si peut changer donc ...
    Cancel := NOT CtrlChgtOnglet(True);

END;

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
            Cancel := NOT CtrlChgtOnglet(False);

    IF cancel THEN
    BEGIN
        INFMESS(ErrItemMenu, '');
        Abort;
    END;
END;

//******************* TFrm_Main.ActiveTab *************************
// Va sur la page index Value et l'affiche

PROCEDURE TFrm_Main.ActiveTab(Value: Integer);
BEGIN
    { Attention : cette procedure est publiée à toutes fins utiles. En interne
      lorsque je l'appelle j'effectue les contrôles nécessaires au préalable
      avec CtrlChgtOnglet. Si on l'appelle depuis l'appli les contrôles sont
      à la charge de l'appli qui peut elle aussi utiliser CtrlChgtOnglet ... }

    fd_main.ActiveFormIndex := Value;
    fd_main.TabIndex := Value;
END;

//******************* Tfrm_Main.FermePage *************************
// Destruction de la page

PROCEDURE Tfrm_Main.FermePage(Value: Integer);
BEGIN
    { Attention : cette procedure est publiée à toutes fins utiles. En interne
      lorsque je l'appelle j'effectue les contrôles nécessaires au préalable
      avec CtrlChgtOnglet. Si on l'appelle depuis l'appli les contrôles sont
      à la charge de l'appli qui peut elle aussi utiliser CtrlChgtOnglet ... }

    Timer_Fd.Tag := Value;
    Timer_Fd.Enabled := True;
    Fd_main.SelectNextForm(True);
END;

//--------------------------------------------------------------------------------
// Boutons du Menu
//--------------------------------------------------------------------------------

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

PROCEDURE TFrm_Main.dxB_MagMagasinClick(Sender: TObject);
BEGIN
    Dm_Uil.UserMagRights;
END;

PROCEDURE TFrm_Main.dxB_MagPermissionClick(Sender: TObject);
BEGIN
    Dm_Uil.ShowMagPermission;
END;

PROCEDURE TFrm_Main.dxB_UserUtilClick(Sender: TObject);
BEGIN
    Dm_Uil.UserGroups;
END;

PROCEDURE TFrm_Main.dxB_UserGroupClick(Sender: TObject);
BEGIN
    Dm_Uil.ShowGroup;
END;

PROCEDURE TFrm_Main.dxB_UserPermClick(Sender: TObject);
BEGIN
    Dm_Uil.ShowPermission;
END;

PROCEDURE TFrm_Main.AlgolStdFrmClose(Sender: TObject;
    VAR Action: TCloseAction);
BEGIN
    Dm_Main.Free;
END;

PROCEDURE TFrm_Main.dxB_DossierClick(Sender: TObject);
BEGIN
    FormManager(TFrm_Dossier);
END;

PROCEDURE TFrm_Main.dxB_GenreClick(Sender: TObject);
VAR n, i: Integer;
BEGIN
    BtClic := (Sender AS TdxBarButton).Tag;
    n := -1;
    FOR i := 0 TO fd_main.formCount - 1 DO
        IF (fd_main.Forms[i] IS TFrm_ParamInit) THEN n := i;
    IF n > 0 THEN
        ActiveTab(0);
    FormManager(TFrm_ParamInit);
    (Sender AS TdxBarButton).ImageIndex := 0;
END;

PROCEDURE TFrm_Main.dxB_NKClick(Sender: TObject);
BEGIN
    OD_NK.InitialDir := FCheminFicImport;
//    IF OD_NK.Execute THEN
//    BEGIN
//        Dm_Nk := TDm_NK.Create(Application);
//        TRY
//            IF Dm_NK.ChargeFichier(OD_NK.FileName) THEN
//            BEGIN
//                IF Dm_NK.Univers THEN
//                    IF Dm_NK.NKRay THEN
//                        IF Dm_NK.NKfam THEN
//                            IF Dm_NK.NKssfam THEN
//                                InfMess(NKok, '');
//            END;
//        FINALLY
//            Dm_Nk.Free;
//        END;
//         // mémoriser le chemin de l'import
//        ch := ExtractFilePath(OD_NK.FileName);
//        IF (ch <> FcheminFicImport) THEN
//        BEGIN
//            FcheminFicImport := ch;
//            StdGinkoia.iniCtrl.WriteString('IMPORT', 'PATH', FcheminFicImport);
//        END;
//    END;
END;

PROCEDURE TFrm_Main.dxB_TailleClick(Sender: TObject);
BEGIN
    Dm_Nk := TDm_NK.Create(Application);
    TRY
        IF Dm_NK.TypeGT THEN
        BEGIN
            IF Dm_NK.GTF THEN
                IF Dm_NK.TGF THEN
                    InfMess(GTFok, '');
            IF Dm_NK.GTS THEN
                IF Dm_NK.TGS THEN
                    IF Dm_NK.ITS THEN
                        InfMess(GTSok, '');
        END;
    FINALLY
        Dm_Nk.Free;
    END;
END;

PROCEDURE TFrm_Main.dxB_EtpClick(Sender: TObject);
BEGIN
    FormManager(TFrm_ParamSoc);
END;

PROCEDURE TFrm_Main.dxB_ServeurClick(Sender: TObject);
BEGIN
    FormManager(TFrm_ServeurListe);
END;

PROCEDURE TFrm_Main.dxB_ConsoClick(Sender: TObject);
VAR n, i: Integer;
BEGIN
    BtClic := (Sender AS TdxBarButton).Tag;
    n := -1;
    FOR i := 0 TO fd_main.formCount - 1 DO
        IF (fd_main.Forms[i] IS TFrm_ParamInit) THEN n := i;
    IF n > 0 THEN
        ActiveTab(0);
    FormManager(TFrm_ParamInit);
    (Sender AS TdxBarButton).ImageIndex := 0;
END;

PROCEDURE TFrm_Main.dxB_ExeComClick(Sender: TObject);
VAR n, i: Integer;
BEGIN
    BtClic := (Sender AS TdxBarButton).Tag;
    n := -1;
    FOR i := 0 TO fd_main.formCount - 1 DO
        IF (fd_main.Forms[i] IS TFrm_ParamInit) THEN n := i;
    IF n > 0 THEN
        ActiveTab(0);
    FormManager(TFrm_ParamInit);
    (Sender AS TdxBarButton).ImageIndex := 0;
END;

PROCEDURE TFrm_Main.dxBTypeCDVClick(Sender: TObject);
VAR Dm_: TDm_Correction;
BEGIN
    // application de correctif
    TRY
        Application.createForm(TDm_Correction, Dm_);
//       Dm_.LesTypesCDV;
        LK_TYPECDV.LookupTable := Dm_.Que_TYPCDV;
        LK_TYPECDV.Execute;
    FINALLY
        Dm_.free;
    END;
    (Sender AS TdxBarButton).ImageIndex := 0;
END;

PROCEDURE TFrm_Main.dxB_NegParamClick(Sender: TObject);
VAR Dm_: TDm_Correction;
BEGIN
    // application de correctif
    TRY
        Application.createForm(TDm_Correction, Dm_);
//       Dm_.LesTypesNegoce;
        LK_NEGOCE.LookupTable := Dm_.Que_NegParam;
        LK_NEGOCE.Execute;
    FINALLY
        Dm_.free;
    END;
    (Sender AS TdxBarButton).ImageIndex := 0;
END;

PROCEDURE TFrm_Main.dxB_FedasClick(Sender: TObject);
BEGIN
    OD_PrepaImportFEDAS.InitialDir := FCheminFicImport;
    IF OD_PrepaImportFEDAS.Execute THEN
    BEGIN
        Dm_PrepaImportFEDAS := TDm_PrepaImportFEDAS.Create(Application);
        TRY
            IF Dm_PrepaImportFEDAS.TransformeCSV(OD_PrepaImportFEDAS.FileName) THEN
            BEGIN
                IF Dm_PrepaImportFEDAS.CSVtoTXT(ExtractFilePath(OD_PrepaImportFEDAS.FileName)) THEN
                    InfMess(PrepaFEDASok, '')
                ELSE ERRMess(CSVtoTXTno, '');
            END
            ELSE ERRMess(PrepaFEDASno, '');
        FINALLY
            Dm_PrepaImportFEDAS.Free;
        END;
    END;
END;

PROCEDURE TFrm_Main.dxB_AddNKClick(Sender: TObject);
VAR ch: STRING;
BEGIN
    OD_NK.InitialDir := FCheminFicImport;
    IF OD_NK.Execute THEN
    BEGIN
        Dm_Nk := TDm_NK.Create(Application);
        TRY
            IF Dm_NK.ChargeFichier(OD_NK.FileName) THEN
            BEGIN
                Dm_NK.RenomeAncienSecteur;
                IF StdGinkoia.OuiNon('Re-init des ID-REF','Faut-il ré-initialiser les ID_REF des anciens rayons ?', False) THEN
                   Dm_NK.RenomeAncienRayon(1)
                else
                   Dm_NK.RenomeAncienRayon(0);

                IF Dm_NK.AddNKRay THEN
                    IF Dm_NK.AddNKfam THEN
                        IF Dm_NK.AddNKssfam THEN
                            InfMess(NKok, '');
            END;
        FINALLY
            Dm_Nk.Free;
        END;
         // mémoriser le chemin de l'import
        ch := ExtractFilePath(OD_NK.FileName);
        IF (ch <> FcheminFicImport) THEN
        BEGIN
            FcheminFicImport := ch;
            StdGinkoia.iniCtrl.WriteString('IMPORT', 'PATH', FcheminFicImport);
        END;
    END;
END;

PROCEDURE TFrm_Main.dxB_CBClick(Sender: TObject);
BEGIN
    InitLesCB;
END;

PROCEDURE TFrm_Main.dxB_CptClientClick(Sender: TObject);
BEGIN
    REPARECptCltFact;
END;

PROCEDURE TFrm_Main.dxB_MultiTarifClick(Sender: TObject);
BEGIN
    REPAREMultiPx;
END;

PROCEDURE TFrm_Main.dxB_MouliTCTClick(Sender: TObject);
BEGIN
    TCTEXECUTE;
END;

PROCEDURE TFrm_Main.dxB_CDVClick(Sender: TObject);
BEGIN
    MOULICDV;
END;

PROCEDURE TFrm_Main.dxB_MrkFournClick(Sender: TObject);
BEGIN
    TRY
        Dm_Main.StartTransaction;
        IbStProc_MrkFourn.Execute;
        Dm_Main.Commit;
        InfMess(FinTraite, '');
    EXCEPT
        Dm_Main.Rollback;
    END;
END;

PROCEDURE TFrm_Main.dxB_CalcTriggerClick(Sender: TObject);
VAR res: Integer;
    num, Id, Id_Dos, ch: STRING;
BEGIN
    ch := 'Recalcule en cours !';
    StdGinkoia.DelayMess(ch, 5);
    // attention tt que la procedure renvoie 1 c'est que le travail n'est pas fini
    // donc relancer
    IF NOT Data.Connected THEN
    BEGIN
        Data.DatabaseName := Dm_Main.Database.DatabaseName;
        Data.Open;
        tran.Active := true;
    END;

    IBSql_Trigger.sql.Clear;
    IBSql_Trigger.sql.Add('execute procedure BN_ACTIVETRIGGER(1);');
    IBSql_Trigger.ExecQuery;

    IF tran.Active AND tran.InTransaction THEN
        tran.Commit;
    tran.Active := true;

    IBSql_Trigger.Sql.Clear;
    IBSql_Trigger.Sql.Add('select Cast(PAR_STRING as Integer) Numero');
    IBSql_Trigger.Sql.Add('from genparambase');
    IBSql_Trigger.Sql.Add('Where PAR_NOM=''IDGENERATEUR''');
    IBSql_Trigger.ExecQuery;
    num := IBSql_Trigger.Fields[0].AsString;
    IBSql_Trigger.Close;
    IBSql_Trigger.Sql.Clear;
    IBSql_Trigger.Sql.Add('select Bas_ID');
    IBSql_Trigger.Sql.Add('from GenBases');
    IBSql_Trigger.Sql.Add('where BAS_ID<>0');
    IBSql_Trigger.Sql.Add('AND BAS_IDENT=' + #39 + Num + #39);
    IBSql_Trigger.ExecQuery;
    num := IBSql_Trigger.Fields[0].AsString;

    IBSql_Trigger.Close;
    IBSql_Trigger.Sql.Clear;
    IBSql_Trigger.Sql.Add('Select NewKey ');
    IBSql_Trigger.Sql.Add('From PROC_NEWKEY');
    IBSql_Trigger.ExecQuery;
    Id := IBSql_Trigger.Fields[0].AsString;
    IBSql_Trigger.Close;

    IBSql_Trigger.Close;
    IBSql_Trigger.Sql.Clear;
    IBSql_Trigger.Sql.Add('Select DOS_ID ');
    IBSql_Trigger.Sql.Add('From GenDossier');
    IBSql_Trigger.Sql.Add('Where DOS_NOM =' + #39 + 'T-' + Num + #39);
    IBSql_Trigger.ExecQuery;
    Id_Dos := IBSql_Trigger.Fields[0].AsString;
    IBSql_Trigger.Close;

    TRY
        //res := 0;
        REPEAT
            ch := ch + '.';
            StdGinkoia.DelayMess(ch, 2);
            IBStProc_TriggerDiffere.ExecProc;
            res := IBStProc_TriggerDiffere.ParamByName('RETOUR').asInteger;
            tran.Commit;
            tran.ACTIVE := True;
        UNTIL res = 0;
        IF ID_DOS = '0' THEN
        BEGIN
            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Insert Into GenDossier');
            IBSql_Trigger.Sql.Add('(DOS_ID, DOS_NOM, DOS_STRING,DOS_FLOAT)');
            IBSql_Trigger.Sql.Add('VALUES (');
            IBSql_Trigger.Sql.Add(Id + ',' + #39 + 'T-' + Num + #39 + ', ' + #39 + DateToStr(Date) + #39 + ', 1');
            IBSql_Trigger.Sql.Add(')');
            IBSql_Trigger.ExecQuery;

            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Insert Into K');
            IBSql_Trigger.Sql.Add('(K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,');
            IBSql_Trigger.Sql.Add(' KSE_DELETE_ID,K_DELETED, KSE_UPDATE_ID, K_UPDATED,KSE_LOCK_ID, KMA_LOCK_ID )');
            IBSql_Trigger.Sql.Add('VALUES (');
            IBSql_Trigger.Sql.Add(ID + ',-101,-11111338,' + Id + ',1,-1,-1,Current_date,0,Current_date,-1,Current_date,0,0 )');
            IBSql_Trigger.ExecQuery;
        END
        ELSE
        BEGIN
            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Update GenDossier');
            IBSql_Trigger.Sql.Add('Set DOS_STRING =' + #39 + DateToStr(Date) + #39 + ', DOS_FLOAT=1');
            IBSql_Trigger.Sql.Add('Where DOS_ID = ' + Id_Dos);
            IBSql_Trigger.ExecQuery;

            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Update K');
            IBSql_Trigger.Sql.Add('Set K_VERSION = ' + Id);
            IBSql_Trigger.Sql.Add('Where K_ID = ' + Id_Dos);
            IBSql_Trigger.ExecQuery;
        END;
        IF IBSql_Trigger.Transaction.InTransaction THEN
            IBSql_Trigger.Transaction.commit;
    EXCEPT
        errMess('Recalcule erreur !', '');
        Tran.Rollback;
        Tran.ACTIVE := True;
        // Noter dans la base dans Gendossier
        IF ID_DOS = 'O' THEN
        BEGIN
            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Insert Into GenDossier');
            IBSql_Trigger.Sql.Add('(DOS_ID, DOS_NOM, DOS_STRING,DOS_FLOAT)');
            IBSql_Trigger.Sql.Add('VALUES (');
            IBSql_Trigger.Sql.Add(Id + ',' + 'T-' + Num + ', ' + DateToStr(Date) + ', 0');
            IBSql_Trigger.Sql.Add(')');
            IBSql_Trigger.ExecQuery;

            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Insert Into K');
            IBSql_Trigger.Sql.Add('(K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,');
            IBSql_Trigger.Sql.Add(' KSE_DELETE_ID,K_DELETED, KSE_UPDATE_ID, K_UPDATED,KSE_LOCK_ID, KMA_LOCK_ID )');
            IBSql_Trigger.Sql.Add('VALUES (');
            IBSql_Trigger.Sql.Add(ID + ',-101,-11111338,' + Id + ',1,-1,-1,Current_date,0,Current_date,-1,Current_date,0,0 )');
            IBSql_Trigger.ExecQuery;
        END
        ELSE
        BEGIN
            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Update GenDossier');
            IBSql_Trigger.Sql.Add('Set DOS_STRING =' + #39 + DateToStr(Date) + #39 + ', DOS_FLOAT=0');
            IBSql_Trigger.Sql.Add('Where DOS_ID = ' + Id_Dos);
            IBSql_Trigger.ExecQuery;

            IBSql_Trigger.Sql.Clear;
            IBSql_Trigger.Sql.Add('Update K');
            IBSql_Trigger.Sql.Add('Set K_VERSION = ' + Id);
            IBSql_Trigger.Sql.Add('Where K_ID = ' + Id_Dos);
            IBSql_Trigger.ExecQuery;
        END;
        IF IBSql_Trigger.Transaction.InTransaction THEN
            IBSql_Trigger.Transaction.commit;
    END;
    INFMess('Recalcule fini !', '');
    IF tran.InTransaction THEN
        tran.Commit;
    Data.Close;
    Tran.Active := False;
END;

END.

