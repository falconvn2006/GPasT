//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT ChxBase_Frm;

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
    RXCtrls;

TYPE
    TFrm_ChxBase = CLASS ( TAlgolStdFrm )
        Stat_Dlg: TfcStatusBar;
        Pan_Btn: TRzPanel;
        SBtn_Cancel: TLMDSpeedButton;
        SBtn_Ok: TLMDSpeedButton;
        Bev_Dlg: TRzBorder;
        Chk_Base: TRxCheckListBox;
        PROCEDURE SBtn_OkClick ( Sender: TObject ) ;
        PROCEDURE SBtn_CancelClick ( Sender: TObject ) ;
        PROCEDURE AlgolMainFrmKeyDown ( Sender: TObject; VAR Key: Word;
            Shift: TShiftState ) ;
        PROCEDURE Chk_BaseDblClick ( Sender: TObject ) ;
        PROCEDURE Chk_BaseMouseUp ( Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer ) ;
    procedure Chk_BaseClick(Sender: TObject);
    procedure Chk_BaseMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Private
        it: Integer;
    { Private declarations }
    Protected
    { Protected declarations }
    Public
    { Public declarations }
    Published

    END;

VAR
    Frm_ChxBase: TFrm_ChxBase;

FUNCTION ChoixBase ( Ts: TStrings; Item: Integer ) : Integer;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

IMPLEMENTATION
{$R *.DFM}
USES ConstStd;

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

FUNCTION ChoixBase ( Ts: TStrings; Item: Integer ) : Integer;
BEGIN
    Result := -1;
    TRY
        Frm_ChxBase := TFrm_ChxBase.Create ( Application ) ;
        Frm_ChxBase.Chk_Base.Items := Ts;
        Frm_ChxBase.Chk_Base.Selected[item] := True;
        Frm_ChxBase.Chk_Base.CheckedIndex := Item;
        IF Frm_ChxBase.showmodal = mrOk THEN
            Result := Frm_ChxBase.Chk_Base.CheckedIndex;
    FINALLY
        Frm_ChxBase.Free;
    END;
END;

PROCEDURE TFrm_ChxBase.AlgolMainFrmKeyDown ( Sender: TObject;
    VAR Key: Word; Shift: TShiftState ) ;
BEGIN
    CASE key OF
        VK_ESCAPE: SBtn_CancelClick ( Sender ) ;
        VK_F12, VK_RETURN: SBtn_OkClick ( Sender ) ;
    END;
END;

PROCEDURE TFrm_ChxBase.SBtn_OkClick ( Sender: TObject ) ;
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE TFrm_ChxBase.SBtn_CancelClick ( Sender: TObject ) ;
BEGIN
    ModalResult := mrCancel;
END;

PROCEDURE TFrm_ChxBase.Chk_BaseDblClick ( Sender: TObject ) ;
BEGIN
    IF it <> -1 THEN
    Begin
        chk_base.CheckedIndex := it;
        SBtn_OkClick ( Sender );
    End;
END;

PROCEDURE TFrm_ChxBase.Chk_BaseMouseUp ( Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer ) ;
VAR
    t: Tpoint;
BEGIN
    t.x := x;
    t.y := y;
    it := chk_Base.ItemAtPos ( t, True ) ;
END;

procedure TFrm_ChxBase.Chk_BaseClick(Sender: TObject);
begin
    IF it <> -1 THEN
       chk_base.CheckedIndex := it;
end;

procedure TFrm_ChxBase.Chk_BaseMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
VAR
    t: Tpoint;
BEGIN
    t.x := x;
    t.y := y;
    it := chk_Base.ItemAtPos ( t, True ) ;
END;



END.
