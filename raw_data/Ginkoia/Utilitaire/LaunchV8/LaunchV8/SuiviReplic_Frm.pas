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

   NE PAS OUBLIER qu'il existe aussi une propriété STDSTR qui peut servir...

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
   EVENTS STANDARDS NON EXECUTES par les Pages du composant dockpage de LMD.
   DONC A NE PAS UTILISER ou à des fins personnelles et qui donc doivent explicitement
   être appelées

   1. Form Deactivate
   2. Form Activate
   3. Form Close
   4. Form KeyDown
   *************************************************************************** }

UNIT SuiviReplic_Frm;

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
    RzLabel, RzStatus, fcStatusBar, dxPSCore, dxPSdxTLLnk, dxPSdxDBCtrlLnk,
    dxPSdxDBGrLnk, Db, IBCustomDataSet, IBQuery, IBDatabase,
    dxComponentPrinterHP, Boxes, PanBtnDbgHP, dxCntner, dxTL, dxDBCtrl,
    dxDBGrid, dxDBGridHP, dxDBTLCl, dxGrClms, dxPSGlbl, dxPSUtl, dxPSEngn,
  dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
  dxPSEdgePatterns, LMDBaseGraphicControl;

TYPE
    TFrm_SuiviReplic = CLASS(TAlgolStdFrm)
        Pan_Page: TRzPanel;
        Nbt_Quit: TLMDSpeedButton;
        Stat_Bar: TfcStatusBar;
        Clk_Status: TRzClockStatus;
        DBG_Replic: TdxDBGridHP;
        Pan_Replic: TPanelDbg;
        DxPrt_Replic: TdxComponentPrinterHP;
        IBQue_Replic: TIBQuery;
        Ds_Replic: TDataSource;
        DxPrt_ReplicdxImp_Consomation: TdxDBGridReportLink;
        IBQue_ReplicMois: TStringField;
        IBQue_ReplicHEV_TYPE: TIntegerField;
        IBQue_ReplicHEV_RESULT: TIntegerField;
        IBQue_ReplicLETEMPS: TTimeField;
        IBQue_ReplicLEMOIS: TSmallintField;
        IBQue_ReplicLANNEE: TSmallintField;
        IBQue_ReplicHEV_ID: TIntegerField;
        IBQue_ReplicEtat: TStringField;
        IBQue_ReplicBAS_NOM: TIBStringField;
        IBQue_ReplicReplic: TStringField;
        IBQue_ReplicLEJOUR: TSmallintField;
        IBQue_ReplicRep1: TStringField;
        IBQue_ReplicRep2: TStringField;
        IBQue_ListeRepli: TIBQuery;
        IBQue_ListeRepliDATEREPLI: TDateField;
        IBQue_ListeRepliOKREPLI: TIntegerField;
        IBQue_ListeRepliTPSREPLI: TTimeField;
        IBQue_ListeRepliBASID: TIntegerField;
        IBQue_ListeRepliLETYPE: TIntegerField;
        IBQue_ListeRepliOKPUSH: TIntegerField;
        IBQue_ListeRepliTPSPUSH: TTimeField;
        IBQue_ListeRepliNUMBASE: TIntegerField;
        IBQue_ListeRepliOKREPLIBASE: TIntegerField;
        IBQue_ListeRepliTPSREPLIBASE: TTimeField;
        IBQue_ListeRepliDETTYPE: TIntegerField;
        IBQue_ListeRepliDETOK: TIntegerField;
        IBQue_ListeRepliDETTPS: TTimeField;
        IBQue_ListeRepliHEV_ID: TIntegerField;
        IBQue_ListeRepliHEVID2: TIntegerField;
        IBQue_ListeRepliID: TIntegerField;
        DBG_ReplicDATEREPLI: TdxDBGridColumn;
        DBG_ReplicOKREPLI: TdxDBGridColumn;
        DBG_ReplicTPSREPLI: TdxDBGridColumn;
        DBG_ReplicBASID: TdxDBGridColumn;
        DBG_ReplicLETYPE: TdxDBGridColumn;
        DBG_ReplicOKPUSH: TdxDBGridColumn;
        DBG_ReplicTPSPUSH: TdxDBGridColumn;
        DBG_ReplicNUMBASE: TdxDBGridColumn;
        DBG_ReplicOKREPLIBASE: TdxDBGridColumn;
        DBG_ReplicTPSREPLIBASE: TdxDBGridColumn;
        DBG_ReplicDETTYPE: TdxDBGridColumn;
        DBG_ReplicDETOK: TdxDBGridColumn;
        DBG_ReplicDETTPS: TdxDBGridColumn;
        DBG_ReplicHEV_ID: TdxDBGridColumn;
        DBG_ReplicHEVID2: TdxDBGridColumn;
        PROCEDURE Nbt_QuitClick(Sender: TObject);
        PROCEDURE AlgolStdFrmShow(Sender: TObject);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
        PROCEDURE IBQue_ReplicCalcFields(DataSet: TDataSet);
        PROCEDURE DBG_ReplicMoisGetText(Sender: TObject;
            ANode: TdxTreeListNode; VAR AText: STRING);
    PRIVATE
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
        PROCEDURE OuvreQuery(basid: Integer);
        PROCEDURE FermeQuery;
    PUBLISHED
    { Published declarations }
    END;

IMPLEMENTATION

USES
    GinkoiaResStr, LaunchV7_Dm, CstLaunch;
{$R *.DFM}

// VAR PageDeBase_Frm: TPageDeBase_Frm;

PROCEDURE TFrm_SuiviReplic.OuvreQuery(basid: Integer);
VAR ind: Integer;
BEGIN
    IBQue_ListeRepli.open ;
    
    TRY
        DBG_Replic.BeginUpdate;
        IBQue_Replic.Close;
        ind := IBQue_Replic.SQL.IndexOf('/*BALISE1*/');
        IF (basid = 0) THEN
        BEGIN
            IBQue_Replic.SQL[ind] := '';
            IBQue_Replic.open;
        END
        ELSE
        BEGIN
            IBQue_Replic.SQL[ind] := 'and HEV_BASID=' + IntToStr(basid);
            IBQue_Replic.open;
        END;
    FINALLY
        DBG_Replic.EndUpdate;
    END;
    DBG_Replic.FullCollapse;
    DBG_Replic.GotoFirstDetail;
END;

PROCEDURE TFrm_SuiviReplic.FermeQuery;
BEGIN
    IBQue_Replic.Close;
END;

PROCEDURE TFrm_SuiviReplic.AlgolStdFrmCreate(Sender: TObject);
BEGIN

    TRY
        screen.Cursor := crSQLWait;
        // pour si des fois qu'init longue car ouverture de tables ...etc

        // CurCtrl := xxx;
        // contôle qui doit avoir le focus en entrée

        Hint := Caption;
        Dm_LaunchV7.AffecteHintEtBmp(self);

    FINALLY
        screen.Cursor := crDefault;
    END;
END;

PROCEDURE TFrm_SuiviReplic.Nbt_QuitClick(Sender: TObject);
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE TFrm_SuiviReplic.AlgolStdFrmShow(Sender: TObject);
BEGIN

{ Important :
  Ici ne pas toucher à l'aspect visuel des composants visuels de la forme car cela
  perturbe l'affichage -> Le maximized interne et nécessaire de la page dockée ne se
  fait fait plus ...

  Ici à la création de la forme et jusqu'au 1er show la propriété INit de la forme
  est toujours à False ! C'est aprés le "DoSwow" qu'elle est automatiquement mise à
  True ... Donc le 2ème entrée ici INit est théoriquement à False.
  Cette propriété est visible et gérable dans l'inspecteur d'objets.
  A noter que si la propriété InitTrueOnShow est mise à False ce qui est dit
  précèdemment n'est plus de rigueur...
}

    IF Init THEN
    BEGIN
        { Ne passe donc pas ici lors de la création !}

        {
        A mettre impérativement si bouton de convertor
        Nbt_Convert.ControlConvertor;
        }

        { Attention ici faut peut être chaîner sur
          un traitement spécifique si on veut gérer
          les cas de "surConnection"
        UserVisuMags := StdGinkoia.UserVisuMags;
        UserCanModify := StdGinkoia.UserCanModify('xxx');
        }
    END;

END;

PROCEDURE TFrm_SuiviReplic.IBQue_ReplicCalcFields(DataSet: TDataSet);
BEGIN
(*
    IBQue_ReplicMois.asString := IBQue_ReplicLEMOIS.asString + ' - ' + LongMonthNames[IBQue_ReplicLEMOIS.asInteger];
    CASE IBQue_ReplicHEV_TYPE.asInteger OF
//        0 :  IBQue_ReplicEtat.asString := 'Connexion Internet '; // CstConnexionGlobal = 0;
//        1 :  IBQue_ReplicEtat.asString := 'lancement de prg '; //CstLancementProgramme = 1;
//        2 :  IBQue_ReplicEtat.asString := 'fermeture de prg '; //CstFermetureProgramme = 2;
//        3 :  IBQue_ReplicEtat.asString := 'Passage en version 7 de la réplication '; //CstPassageV7 = 3;
//        4 :  IBQue_ReplicEtat.asString := 'Passage en version 4 de la réplication '; //CstPassageV4 = 4;
//        5 :  IBQue_ReplicEtat.asString := 'Initalisation de la base de donnée '; //CstInitialisationBase = 5;
//        6 :  IBQue_ReplicEtat.asString := 'Modification des paramétres en base de donnée '; //CstModifParametre = 6;
//        7 :  IBQue_ReplicEtat.asString := 'Modification des Providers '; //CstModifProvider = 7;
//        8 :  IBQue_ReplicEtat.asString := 'Modification des Subscribers '; //CstModifSubscriber = 8;
//        9 :  IBQue_ReplicEtat.asString := 'Connexion Internet par modem '; //CstConnexionModem = 9;
//        10 :  IBQue_ReplicEtat.asString := 'De-connexion du modem '; //CstDeConnexionModem = 10;
//        11 :  IBQue_ReplicEtat.asString := 'Changement des horaires de réplication '; //CstChangementhorraire = 11;
//        12 :  IBQue_ReplicEtat.asString := 'Réplication manuelle '; //CstReplicationManuel = 12;
//        13 :  IBQue_ReplicEtat.asString := 'De-connexion des triggers '; //CstDeconnexionTrigger = 13;
//        14 :  IBQue_ReplicEtat.asString := 'Re-connexion des triggers '; //CstReconnexionTrigger = 14;
//        15 :  IBQue_ReplicEtat.asString := 'Re-calcul des triggers '; //CstRecalculeTrigger = 15;
//        16 :  IBQue_ReplicEtat.asString := 'Temps de la réplication '; //CstTempsReplication = 16;
//        17 :  IBQue_ReplicEtat.asString := 'Lancement du backup/restor '; //CstLanceBackup = 17;
//        18 :  IBQue_ReplicEtat.asString := 'Lancement du liveUpdate '; //CstLanceLiveUpdate = 18;
        19: IBQue_ReplicEtat.asString := 'REPLICATION COMPLETE '; //CstUneReplication = 19;
//        20 :  IBQue_ReplicEtat.asString := '1ére réplication automatique '; //CstReplicationAutomatiqueH1 = 20;
//        21 :  IBQue_ReplicEtat.asString := '2eme réplication automatique '; //CstReplicationAutomatiqueH2 = 21;
        999: IBQue_ReplicEtat.asString := 'Envoie des données '; //CstPush = 999;
        1999: IBQue_ReplicEtat.asString := 'Reception des données '; //CstPull = 1999;
        1000..1998: IBQue_ReplicEtat.asString := 'Envoie du paquet n°' + IntToStr(IBQue_ReplicHEV_TYPE.asInteger - 999) + ' '; //CstModulePush = 1000; // A 1999
        2000..2998: IBQue_ReplicEtat.asString := 'Réception du paquet n°' + IntToStr(IBQue_ReplicHEV_TYPE.asInteger - 1999) + ' '; //CstModulePuLL = 2000; // A 1999
    END;

//    IF (IBQue_ReplicHEV_RESULT.asInteger = 1) then
//       IBQue_ReplicEtat.asString := IBQue_ReplicEtat.asString + ': Ok'
//    else
//       IBQue_ReplicEtat.asString := IBQue_ReplicEtat.asString + ': Erreur';

*)
END;

PROCEDURE TFrm_SuiviReplic.DBG_ReplicMoisGetText(Sender: TObject;
    ANode: TdxTreeListNode; VAR AText: STRING);
//VAR ch: STRING;
BEGIN
    Atext := copy(Atext, pos(' - ', Atext) + 3, length(Atext));
END;

END.

