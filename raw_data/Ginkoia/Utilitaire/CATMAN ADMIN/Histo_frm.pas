//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Histo_frm;

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
    LMDFormShadow, Db, ADODB, dxCntner, dxTL, dxDBCtrl, dxDBGrid,
  dxDBGridHP, dxDBTLCl, dxGrClms;

TYPE
    TFrm_Histo = CLASS(TAlgolStdFrm)
        Pan_Btn: TRzPanel;
        Nbt_Cancel: TLMDSpeedButton;
        Nbt_Post: TLMDSpeedButton;
    Ds_Histo: TDataSource;
    dxDBGridHP1: TdxDBGridHP;
    dxDBGridHP1mhi_datedeb: TdxDBGridDateColumn;
    dxDBGridHP1mhi_datefin: TdxDBGridDateColumn;
    dxDBGridHP1COLUMN1: TdxDBGridDateColumn;
    dxDBGridHP1mhi_kdeb: TdxDBGridMaskColumn;
    dxDBGridHP1mhi_kfin: TdxDBGridMaskColumn;
    dxDBGridHP1mhi_ok: TdxDBGridCheckColumn;
    dxDBGridHP1mhi_info: TdxDBGridMaskColumn;
        PROCEDURE Nbt_PostClick(Sender: TObject);
        PROCEDURE Nbt_CancelClick(Sender: TObject);
        PROCEDURE AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE AlgolStdFrmCreate(Sender: TObject);
    procedure Pan_BtnEnter(Sender: TObject);
    procedure Pan_BtnExit(Sender: TObject);
    PRIVATE
        UserCanModify, UserVisuMags: Boolean;
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED

    END;

FUNCTION ExecuteHisto(query:tdataset): Boolean;

IMPLEMENTATION
{$R *.DFM}
USES
    StdUtils,
    GinkoiaStd,
    GinkoiaResStr;

FUNCTION Executehisto(query:tdataset): Boolean;

VAR Frm_histo: TFrm_histo;
BEGIN
    Result := False;
    Application.createform(TFrm_histo, Frm_histo);
    WITH Frm_histo DO
    BEGIN
        TRY
            ds_histo.DATASET:=query;
            IF Showmodal = mrOk THEN
            BEGIN
                Result := True;
            END;
        FINALLY
            release;
        END;
    END;
END;

PROCEDURE TFrm_Histo.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    TRY
        screen.Cursor := crSQLWait;
        Hint := Caption;
        StdGinkoia.AffecteHintEtBmp(self);
    FINALLY
        screen.Cursor := crDefault;
    END;
END;

PROCEDURE TFrm_Histo.AlgolMainFrmKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
BEGIN
    CASE key OF
        VK_ESCAPE: Nbt_CancelClick(Sender);
        VK_F12: Nbt_PostClick(Sender);
        VK_RETURN : IF Pan_Btn.Focused THEN Nbt_PostClick(Sender);
    END;
END;

PROCEDURE TFrm_Histo.Nbt_PostClick(Sender: TObject);
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE TFrm_Histo.Nbt_CancelClick(Sender: TObject);
BEGIN
    ModalResult := mrCancel;
END;

procedure TFrm_Histo.Pan_BtnEnter(Sender: TObject);
begin
     Nbt_Post.Font.style := [fsBold];
end;

procedure TFrm_Histo.Pan_BtnExit(Sender: TObject);
begin
     Nbt_Post.Font.style := [];
end;

END.

