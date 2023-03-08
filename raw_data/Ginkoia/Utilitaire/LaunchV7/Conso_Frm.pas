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

UNIT Conso_Frm;

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
    LMDButton, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg, dxBkgnd, dxWrap, dxPrnDev,
  dxPSCompsProvider, dxPSFillPatterns, dxPSEdgePatterns, DB, IBCustomDataSet,
  IBQuery, dxPSCore, dxPSdxTLLnk, dxPSdxDBCtrlLnk, dxPSdxDBGrLnk,
  dxComponentPrinterHP, Boxes, PanBtnDbgHP, dxDBTLCl, dxGrClms, dxDBGrid, dxTL,
  dxDBCtrl, dxCntner, dxDBGridHP, RzStatus, fcStatusBar;

TYPE
    TFrm_Conso = CLASS(TAlgolStdFrm)
        Pan_Page: TRzPanel;
        Nbt_Quit: TLMDSpeedButton;
        Stat_Bar: TfcStatusBar;
        Clk_Status: TRzClockStatus;
        DBG_Consomation: TdxDBGridHP;
        Pan_Consomation: TPanelDbg;
        DxPrt_Consomation: TdxComponentPrinterHP;
        IBQue_Consomation: TIBQuery;
        IBQue_ConsomationHEV_ID: TIntegerField;
        IBQue_ConsomationBAS_NOM: TIBStringField;
        IBQue_ConsomationHEV_DATE: TDateTimeField;
        IBQue_ConsomationLETEMPS: TTimeField;
        IBQue_ConsomationLEMOIS: TSmallintField;
        IBQue_ConsomationLANNEE: TSmallintField;
        Ds_Consomation: TDataSource;
        dxImp_Consomation: TdxDBGridReportLink;
        DBG_ConsomationBAS_NOM: TdxDBGridMaskColumn;
        DBG_ConsomationHEV_DATE: TdxDBGridDateColumn;
        DBG_ConsomationLETEMPS: TdxDBGridTimeColumn;
        DBG_ConsomationLANNEE: TdxDBGridMaskColumn;
        IBQue_ConsomationMois: TStringField;
        DBG_ConsomationMois: TdxDBGridColumn;
        DBG_ConsomationLemois: TdxDBGridColumn;
        PROCEDURE Nbt_QuitClick(Sender: TObject);
        PROCEDURE AlgolStdFrmShow(Sender: TObject);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
        PROCEDURE IBQue_ConsomationCalcFields(DataSet: TDataSet);
        PROCEDURE DBG_ConsomationMoisGetText(Sender: TObject;
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

PROCEDURE TFrm_Conso.OuvreQuery(basid: Integer);
var ind: Integer;
BEGIN
    TRY
        DBG_Consomation.BeginUpdate;
        IBQue_Consomation.Close;
        ind := IBQue_Consomation.SQL.IndexOf('/*BALISE1*/');
        IF (basid = 0) THEN
        BEGIN
            IBQue_Consomation.SQL[ind] := '';
            IBQue_Consomation.ParamByName('ReplicOk').asInteger := CstTempsReplication;
            IBQue_Consomation.open;
        END
        ELSE
        BEGIN
            IBQue_Consomation.SQL[ind] := 'and HEV_BASID=' + IntToStr(basid);
            IBQue_Consomation.ParamByName('ReplicOk').asInteger := CstTempsReplication;
            IBQue_Consomation.open;
        END;
    FINALLY
        DBG_Consomation.EndUpdate;
    END;
        DBG_Consomation.FullCollapse;
        DBG_Consomation.GotoFirstDetail;
END;

PROCEDURE TFrm_Conso.FermeQuery;
BEGIN
    IBQue_Consomation.Close;
END;

PROCEDURE TFrm_Conso.AlgolStdFrmCreate(Sender: TObject);
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

PROCEDURE TFrm_Conso.Nbt_QuitClick(Sender: TObject);
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE TFrm_Conso.AlgolStdFrmShow(Sender: TObject);
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

PROCEDURE TFrm_Conso.IBQue_ConsomationCalcFields(DataSet: TDataSet);
BEGIN
    IBQue_ConsomationMois.asString := IBQue_ConsomationLEMOIS.asString + ' - ' + LongMonthNames[IBQue_ConsomationLEMOIS.asInteger];
END;

PROCEDURE TFrm_Conso.DBG_ConsomationMoisGetText(Sender: TObject;
    ANode: TdxTreeListNode; VAR AText: STRING);
//VAR ch: STRING;
BEGIN
    Atext := copy(Atext, pos(' - ', Atext) + 3, length(Atext));
END;

END.

