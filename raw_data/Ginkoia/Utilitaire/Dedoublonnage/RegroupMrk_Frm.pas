//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT RegroupMrk_Frm;

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
    LMDFormShadow, RzButton, RzRadChk, RzCheckBoxRv, RzPanelRv;

TYPE
    TFrm_RegroupMrk = CLASS(TAlgolStdFrm)
        Pan_Btn: TRzPanel;
        Nbt_Cancel: TLMDSpeedButton;
        Nbt_Post: TLMDSpeedButton;
    RzPanelRv1: TRzPanelRv;
    RzPanelRv2: TRzPanelRv;
    Chk_M1: TRzCheckBoxRv;
    Chk_M2: TRzCheckBoxRv;
        PROCEDURE Nbt_PostClick(Sender: TObject);
        PROCEDURE Nbt_CancelClick(Sender: TObject);
        PROCEDURE AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
    procedure Chk_M1Click(Sender: TObject);
    procedure Chk_M2Click(Sender: TObject);
    PRIVATE
        UserCanModify, UserVisuMags: Boolean;
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED

    END;

FUNCTION RegroupMrk ( Mrk1, Mrk2 : Integer) : Integer;

IMPLEMENTATION
{$R *.DFM}
USES
    ConstStd,
    StdUtils, Main_Dm;

FUNCTION RegroupMrk ( Mrk1, Mrk2 : Integer) : Integer;
VAR Frm_RegroupMrk: TFrm_RegroupMrk;
BEGIN
    Result := -1;
    Application.createform(TFrm_RegroupMrk, Frm_RegroupMrk);
    WITH Frm_RegroupMrk DO
    BEGIN
        TRY
            IF Showmodal = mrOk THEN
            BEGIN
                Result := 1;
            END;
        FINALLY
            release;
        END;
    END;
END;

PROCEDURE TFrm_RegroupMrk.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    TRY
        screen.Cursor := crSQLWait;
        Hint := Caption;
    FINALLY
        screen.Cursor := crDefault;
    END;
END;

PROCEDURE TFrm_RegroupMrk.AlgolMainFrmKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
BEGIN
    CASE key OF
        VK_ESCAPE: Nbt_CancelClick(Sender);
        VK_F12: Nbt_PostClick(Sender);
    END;
END;

PROCEDURE TFrm_RegroupMrk.Nbt_PostClick(Sender: TObject);
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE TFrm_RegroupMrk.Nbt_CancelClick(Sender: TObject);
BEGIN
    ModalResult := mrCancel;
END;

procedure TFrm_RegroupMrk.Chk_M1Click(Sender: TObject);
begin
     Chk_M2.Checked := Not ChK_M1.Checked;     
end;

procedure TFrm_RegroupMrk.Chk_M2Click(Sender: TObject);
begin
     Chk_M1.Checked := Not ChK_M2.Checked;
end;

END.

