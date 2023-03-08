//------------------------------------------------------------------------------
// Nom de l'unité : CScreen_Frm
// Rôle           : Ecran de contrôle
// Auteur         : Hervé PULLUARD
// Historique     :
// 20/08/2000 - Hervé PULLUARD - v 1.0.0 : Création
//------------------------------------------------------------------------------

{ **************************************************************************
 ATTENTION :
 *********
  PROCEDURES NON PRISES EN CHARGE par le composant Pages de LMD.
  NE PAS UTILISER

 1. procedure Form Deactivate
    (Se Servir de SBx_Page Exit (Sortie du ScrollBox))

 2. procedure Form Activate
    (Se Servir de SBx_Page Enter (entrée dans le ScrollBox))

 3. procedure On Close Query

 4. procedure Form Close

 *************************************************************************** }

UNIT CScreen_Frm;

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
    ArtLabel,
    LMDCustomScrollBox,
    LMDScrollBox,
    ExtCtrls,
    RzPanel,
    RzStatus,
    fcStatusBar,
    DFClasses,
    Jpeg,
    fcImager,
    dxorgchr,
    RzPanelRv,
    LMDControl,
    LMDBaseControl,
    LMDBaseGraphicButton,
    LMDCustomSpeedButton,
    LMDSpeedButton;

TYPE
    TFrm_CScreen = CLASS(TAlgolStdFrm)
        Pan_Ctrl: TRzPanel;
        SBx_Ctrl: TLMDScrollBox;
        Stat_Bar: TfcStatusBar;
        Clk_Status: TRzClockStatus;
        Img_Ginkoia: TfcImager;
        Tim_Orga: TTimer;
        PROCEDURE AlgolStdFrmShow(Sender: TObject);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
        PROCEDURE Tim_OrgaTimer(Sender: TObject);
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
    Frm_CScreen: TFrm_CScreen;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
// RESOURCESTRING

IMPLEMENTATION

USES ginkoiastd,
    GinkoiaResStr,
    Main_Frm;

{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TFrm_CScreen.AlgolStdFrmShow(Sender: TObject);
BEGIN
{ Remarque importante :
  Ici ne pas toucher à l'aspect visuel des composants de la forme car cela
  perturbe l'affichage. Le maximized au interne du composant ne se fait plus ... }
END;

PROCEDURE TFrm_CScreen.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    TRY
        IF FileExists(StdGinkoia.PathApp + 'Image\FondCs.Bmp') THEN
            Img_Ginkoia.Picture.LoadFromFile(StdGinkoia.PathApp + 'Image\FondCs.Bmp')
        ELSE IF FileExists(StdGinkoia.PathApp + 'Image\FondCs.jpg') THEN
            Img_Ginkoia.Picture.LoadFromFile(StdGinkoia.PathApp + 'Image\FondCs.Jpg')
    EXCEPT
    END;
END;

PROCEDURE TFrm_CScreen.Tim_OrgaTimer(Sender: TObject);
BEGIN
    Tim_Orga.enabled := False;
END;

END.
