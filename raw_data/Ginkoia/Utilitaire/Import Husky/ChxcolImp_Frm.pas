//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT ChxcolImp_Frm;

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
    RzPanel,
    RzRadGrp,
    RzRadioGroupRv,
    LMDControl,
    LMDBaseControl,
    LMDBaseGraphicButton,
    LMDCustomSpeedButton,
    LMDSpeedButton,
    ExtCtrls,
    RzBorder,
    StdCtrls,
    RzLabel,
    RzButton,
    RzRadChk,
    RzCheckBoxRv,
    RzPanelRv;

TYPE
    TFrm_ChxColImp = CLASS ( TAlgolStdFrm )
        Pan_Btn: TRzPanel;
        SBtn_Cancel: TLMDSpeedButton;
        SBtn_Ok: TLMDSpeedButton;
        Bev_Dlg: TRzBorder;
        Rgr_ColImp: TRzRadioGroupRv;
        Rgr_Sens: TRzRadioGroupRv;
        Lab_Prev: TRzLabel;
        Chk_Direct: TRzCheckBoxRv;
        Chk_Printer: TRzCheckBoxRv;
        Pan_Mess: TRzPanelRv;
        PROCEDURE SBtn_OkClick ( Sender: TObject ) ;
        PROCEDURE SBtn_CancelClick ( Sender: TObject ) ;
        PROCEDURE AlgolMainFrmKeyDown ( Sender: TObject; VAR Key: Word;
            Shift: TShiftState ) ;
    Private
    { Private declarations }
    Protected
    { Protected declarations }
    Public
    { Public declarations }
    Published

    END;

VAR
    Frm_ChxColImp: TFrm_ChxColImp;
//FUNCTION ChoixColImp ( Mode: Integer ) : Integer;
//FUNCTION ChoixColImpSens ( Mode: Integer; Var Sens : Integer ) : Integer;
FUNCTION ChoixColImpFull ( Mode: Integer; VAR Sens: Integer; VAR Direct, ChxImp: Boolean ) : Integer;
//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

IMPLEMENTATION
{$R *.DFM}
USES GinkoiaStd,
    GinkoiaResStr;

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

//FUNCTION ChoixColImp ( Mode: Integer ) : Integer;
//BEGIN
//    Result := -1;
//    Frm_ChxColImp := TFrm_ChxColImp.Create ( Application ) ;
//    WITH Frm_chxColImp DO
//    BEGIN
//        Lab_Prev.Visible := True;
//        Chk_Direct.Visible := False;
//        Rgr_Sens.Visible := False;
//        Chk_Printer.Visible := False;
//        Height := 200;
//        TRY
//            IF ( Mode < 0 ) OR ( Mode > 2 ) THEN Mode := 0;
//            rgr_colImp.ItemIndex := Mode;
//            IF Showmodal = mrOk THEN
//                Result := rgr_colImp.ItemIndex;
//        FINALLY
//            Free;
//        END;
//    END;
//END;

//FUNCTION ChoixColImpSens ( Mode: Integer; Var Sens : Integer ) : Integer;
//BEGIN
//    Result := -1;
//    Frm_ChxColImp := TFrm_ChxColImp.Create ( Application ) ;
//    WITH Frm_chxColImp DO
//    BEGIN
//        Lab_Prev.Visible := True;
//        Chk_Direct.Visible := False;
//        Chk_Printer.Visible := False;
//        Rgr_Sens.Visible := True;
//        Height := 264;
//        TRY
//            IF ( Mode < 0 ) OR ( Mode > 2 ) THEN Mode := 0;
//            rgr_colImp.ItemIndex := Mode;
//            Rgr_Sens.ItemIndex := Sens;
//            IF Showmodal = mrOk THEN
//            Begin
//                Result := rgr_colImp.ItemIndex;
//                Sens := Rgr_Sens.ItemIndex;
//            End;
//        FINALLY
//            Free;
//        END;
//    END;
//END;

FUNCTION ChoixColImpFull ( Mode: Integer; VAR Sens: Integer; VAR Direct, ChxImp: Boolean ) : Integer;
BEGIN
    Result := -1;
    Frm_ChxColImp := TFrm_ChxColImp.Create ( Application ) ;
    WITH Frm_chxColImp DO
    BEGIN
        Lab_Prev.Visible := False;
        Rgr_Sens.Visible := True;
        Chk_Direct.Visible := True;
        Chk_Printer.Visible := True;
        Height := 305;
        TRY
            IF ( Mode < 0 ) OR ( Mode > 2 ) THEN Mode := 0;
            rgr_colImp.ItemIndex := Mode;
            Rgr_Sens.ItemIndex := Sens;
            Chk_Direct.Checked := Direct;
            Chk_Printer.Checked := ChxImp;
            IF Showmodal = mrOk THEN
            BEGIN
                Result := rgr_colImp.ItemIndex;
                Sens := Rgr_Sens.ItemIndex;
                Direct := Chk_Direct.Checked;
                ChxImp := Chk_Printer.Checked;
            END;
        FINALLY
            Free;
        END;
    END;
END;

PROCEDURE TFrm_ChxColImp.AlgolMainFrmKeyDown ( Sender: TObject;
    VAR Key: Word; Shift: TShiftState ) ;
BEGIN
    CASE key OF
        VK_ESCAPE: SBtn_CancelClick ( Sender ) ;
        VK_F12, VK_RETURN: SBtn_OkClick ( Sender ) ;
    END;
END;

PROCEDURE TFrm_ChxColImp.SBtn_OkClick ( Sender: TObject ) ;
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE TFrm_ChxColImp.SBtn_CancelClick ( Sender: TObject ) ;
BEGIN
    ModalResult := mrCancel;
END;

END.
