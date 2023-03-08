//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT DlgMemo_Frm;

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
    dxCntner,
    dxEditor,
    dxExEdtr,
    dxEdLib,
    RzPanelRv,
    LMDTxtPrinter,
    LMDCustomComponent;

TYPE
    TFrm_DlgMemo = CLASS ( TAlgolStdFrm )
        Pan_Btn: TRzPanel;
        SBtn_Cancel: TLMDSpeedButton;
        SBtn_Ok: TLMDSpeedButton;
        Pan_Fond: TRzPanelRv;
        Memo_Dlg: TdxMemo;
        Nbt_Fermer: TLMDSpeedButton;
        PrtT_Memo: TLMDTxtPrinter;
        Nbt_Print: TLMDSpeedButton;
        PROCEDURE SBtn_OkClick ( Sender: TObject ) ;
        PROCEDURE SBtn_CancelClick ( Sender: TObject ) ;
        PROCEDURE AlgolMainFrmKeyDown ( Sender: TObject; VAR Key: Word;
            Shift: TShiftState ) ;
        PROCEDURE Nbt_PrintClick ( Sender: TObject ) ;
    Private
    { Private declarations }
    Protected
    { Protected declarations }
    Public
    { Public declarations }
    Published

    END;

VAR
    Frm_DlgMemo: TFrm_DlgMemo;
FUNCTION ExecuteDlgMemo ( Titre: STRING; ReadOnly: Boolean; Max: Integer; VAR Txt: STRING ) : Boolean;

IMPLEMENTATION

USES GinkoiaResStr;
{$R *.DFM}

FUNCTION ExecuteDlgMemo ( Titre: STRING; ReadOnly: Boolean; Max: Integer; VAR Txt: STRING ) : Boolean;
BEGIN
    Result := False;
    Application.createform ( TFrm_DlgMemo, Frm_DlgMemo ) ;
    WITH Frm_DlgMemo DO
    BEGIN
        TRY
            Nbt_Fermer.Visible := ReadOnly;
            Sbtn_Ok.Visible := NOT ReadOnly;
            Sbtn_Cancel.Visible := NOT ReadOnly;
            Caption := ' ' + Titre;
            IF ReadOnly THEN
                Caption := Caption + ' [' + TxTEnLS + ']';

            memo_Dlg.ReadOnly := ReadOnly;
            memo_Dlg.MaxLength := Max;

            memo_Dlg.Lines.Text := Txt;
            IF Showmodal = mrOk THEN
            BEGIN
                Txt := memo_dlg.lines.Text;
                Result := True;
            END;
        FINALLY
            release;
        END;
    END;
END;

PROCEDURE TFrm_DlgMemo.AlgolMainFrmKeyDown ( Sender: TObject;
    VAR Key: Word; Shift: TShiftState ) ;
BEGIN
    CASE key OF
        VK_ESCAPE: SBtn_CancelClick ( Sender ) ;
        VK_F12: IF SBtn_OK.Visible AND Sbtn_Ok.Enabled THEN SBtn_OkClick ( Sender ) ;
    END;
END;

PROCEDURE TFrm_DlgMemo.SBtn_OkClick ( Sender: TObject ) ;
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE TFrm_DlgMemo.SBtn_CancelClick ( Sender: TObject ) ;
BEGIN
    ModalResult := mrCancel;
END;

PROCEDURE TFrm_DlgMemo.Nbt_PrintClick ( Sender: TObject ) ;
VAR
    Mts: TStrings;
BEGIN
    Mts := TStringList.Create;
    TRY

        Mts.Assign ( Memo_Dlg.Lines ) ;
        IF Trim ( Caption ) <> '' THEN
        BEGIN
            MTs.Insert ( 0, '' ) ;
            MTs.Insert ( 0, Caption ) ;
            MTs.Insert ( 0, '' ) ;
            MTs.Insert ( 0, '' ) ;
            MTs.Insert ( 0, '' ) ;
        END
        ELSE
        BEGIN
            MTs.Insert ( 0, '' ) ;
            MTs.Insert ( 0, '' ) ;
            MTs.Insert ( 0, '' ) ;
        END;

        PrtT_memo.PrintText ( MTS.Text ) ;
    FINALLY
        Mts.Free;
    END;
END;

END.
