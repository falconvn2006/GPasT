//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Horaire_Frm;

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
    fcStatusBar,
    RzBorder,
    LMDCustomComponent,
    LMDWndProcComponent,
    LMDFormShadow,
    RzButton,
    RzRadChk,
    RzCheckBoxRv,
    dxCntner,
    dxEditor,
    dxExEdtr,
    dxEdLib,
    StdCtrls,
    RzLabel;

TYPE
    TFrm_Horaire = CLASS(TAlgolStdFrm)
        Stat_Dlg: TfcStatusBar;
        Pan_Btn: TRzPanel;
        SBtn_Cancel: TLMDSpeedButton;
        SBtn_Ok: TLMDSpeedButton;
        Bev_Dlg: TRzBorder;
        RzLabel1: TRzLabel;
        Chp_Heure: TdxTimeEdit;
        Chk_Heure1: TRzCheckBoxRv;
        Chp_Heure2: TdxTimeEdit;
        Chk_Heure2: TRzCheckBoxRv;
        PROCEDURE SBtn_OkClick(Sender: TObject);
        PROCEDURE SBtn_CancelClick(Sender: TObject);
        PROCEDURE AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE Chp_HeureKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
    PRIVATE
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
        FUNCTION Execute(VAR H1, H2: TTime; VAR ValideH1, ValideH2: Boolean): TModalResult;
    PUBLISHED

    END;

VAR
    Frm_Horaire: TFrm_Horaire;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

IMPLEMENTATION
{$R *.DFM}
//USES ConstStd;

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

FUNCTION TFrm_Horaire.Execute(VAR H1, H2: TTime; VAR ValideH1, ValideH2: Boolean): TModalResult;
BEGIN
    Frm_Horaire := TFrm_Horaire.Create(Application);
    TRY
        Frm_Horaire.Chp_Heure.Time := H1;
        Frm_Horaire.Chp_Heure2.Time := H2;
        Frm_Horaire.Chk_Heure1.Checked := ValideH1;
        Frm_Horaire.Chk_Heure2.Checked := ValideH2;
        Result := Frm_Horaire.Showmodal;
        H1 := Frm_Horaire.Chp_Heure.Time;
        H2 := Frm_Horaire.Chp_Heure2.Time;
        ValideH1 := Frm_Horaire.Chk_Heure1.Checked;
        ValideH2 := Frm_Horaire.Chk_Heure2.Checked;
    FINALLY
        Frm_Horaire.Free;
    END;
END;

PROCEDURE TFrm_Horaire.AlgolMainFrmKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
BEGIN
    CASE key OF
        VK_ESCAPE: SBtn_CancelClick(Sender);
        VK_F12: SBtn_OkClick(Sender);
    END;
END;

PROCEDURE TFrm_Horaire.SBtn_OkClick(Sender: TObject);
BEGIN
    SelectNext(ActiveControl, True, True);
    ModalResult := mrOk;
END;

PROCEDURE TFrm_Horaire.SBtn_CancelClick(Sender: TObject);
BEGIN
    ModalResult := mrCancel;
END;

PROCEDURE TFrm_Horaire.Chp_HeureKeyDown(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
BEGIN
    CASE Key OF
        VK_RETURN: SelectNext(ActiveControl, True, True);
    END;
END;

END.
