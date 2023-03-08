//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT SelMag_frm;

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
    LMDFormShadow, dxDBCtrl, dxDBGrid, dxTL, dxCntner, dxDBGridRv, Db,
  dxmdaset, LMDBaseGraphicControl;

TYPE
    TFrm_SelMag = CLASS(TAlgolStdFrm)
        Pan_Btn: TRzPanel;
        Nbt_Cancel: TLMDSpeedButton;
        Nbt_Post: TLMDSpeedButton;
    Ds_Mag: TDataSource;
    Dbg_Mag: TdxDBGridRv;
    Dbg_MagRecId: TdxDBGridColumn;
    Dbg_MagNUMERO: TdxDBGridMaskColumn;
    Dbg_MagCLIENT: TdxDBGridMaskColumn;
    Dbg_MagNOMFICHIER: TdxDBGridMaskColumn;
    Dbg_MagCHEMIN: TdxDBGridMaskColumn;
    Dbg_MagMAGASIN: TdxDBGridMaskColumn;
    Dbg_MagCENTRALE: TdxDBGridMaskColumn;
    MemD_Tmp: TdxMemData;
    MemD_TmpNUMERO: TStringField;
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
VAR
    frm_Selmag: Tfrm_selmag;
    FUNCTION ExecuteSelMag: Boolean;

IMPLEMENTATION
{$R *.DFM}
USES
  Export_frm;

FUNCTION ExecuteSelMag: Boolean;
VAR Frm_SelMag: TFrm_SelMag;
BEGIN
    Result := False;
    Application.createform(TFrm_SelMag, Frm_SelMag);
    WITH Frm_SelMag DO
    BEGIN
        TRY
            IF Showmodal = mrOk THEN
            BEGIN
                Result := True;
            END;
        FINALLY
            release;
        END;
    END;
END;

PROCEDURE TFrm_SelMag.AlgolStdFrmCreate(Sender: TObject);
BEGIN
    TRY
        screen.Cursor := crSQLWait;
        Hint := Caption;


    FINALLY
        screen.Cursor := crDefault;
    END;
END;

PROCEDURE TFrm_SelMag.AlgolMainFrmKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
BEGIN
    CASE key OF
        VK_ESCAPE: Nbt_CancelClick(Sender);
        VK_F12: Nbt_PostClick(Sender);
        VK_RETURN : IF Pan_Btn.Focused THEN Nbt_PostClick(Sender);
    END;
END;

PROCEDURE TFrm_SelMag.Nbt_PostClick(Sender: TObject);
var i:integer;
BEGIN
    memd_tmp.close;
    memd_tmp.open;
    FOR i := 0 TO dbg_mag.SelectedCount - 1 DO
    begin
        memd_tmp.insert;
        MemD_TmpNUMERO.asstring:=dbg_mag.SelectedNodes[i].Strings[1];
        memd_tmp.post;
    END;


    ds_mag.dataset.first;
    WHILE not ds_mag.dataset.eof do
    begin
        IF not memd_tmp.locate('NUMERO',ds_mag.dataset.fieldbyname('NUMERO').asstring,[]) then
           ds_mag.dataset.delete
        else
           ds_mag.dataset.next;
    END;





    ModalResult := mrOk;
END;

PROCEDURE TFrm_SelMag.Nbt_CancelClick(Sender: TObject);
BEGIN
    ModalResult := mrCancel;
END;

procedure TFrm_SelMag.Pan_BtnEnter(Sender: TObject);
begin
     Nbt_Post.Font.style := [fsBold];
end;

procedure TFrm_SelMag.Pan_BtnExit(Sender: TObject);
begin
     Nbt_Post.Font.style := [];
end;

END.

