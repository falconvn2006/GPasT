//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Rapport_Frm;

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
    LMDFormShadow, dxPSCore, dxPSdxTLLnk, dxPSdxDBCtrlLnk, dxPSdxDBGrLnk,
  dxDBTLCl, dxGrClms, dxTL, dxDBCtrl, dxDBGrid, dxCntner, dxDBGridRv, Db;

TYPE
    TFrm_Rapport = CLASS ( TAlgolStdFrm )
        Pan_Btn: TRzPanel;
        SBtn_Cancel: TLMDSpeedButton;
        Bev_Dlg: TRzBorder;
    Ds_Rapport: TDataSource;
    dxDBGridRv1: TdxDBGridRv;
    dxDBGridRv1Ref: TdxDBGridMaskColumn;
    dxDBGridRv1Marque: TdxDBGridMaskColumn;
    dxDBGridRv1PA: TdxDBGridCheckColumn;
    dxDBGridRv1Rem: TdxDBGridCheckColumn;
    dxDBGridRv1PVte: TdxDBGridCheckColumn;
    LMDSpeedButton1: TLMDSpeedButton;
    dxComponentPrinter1: TdxComponentPrinter;
    dxImp_Rap: TdxDBGridReportLink;
        PROCEDURE SBtn_CancelClick ( Sender: TObject ) ;
        PROCEDURE AlgolMainFrmKeyDown ( Sender: TObject; VAR Key: Word;
            Shift: TShiftState ) ;
    procedure LMDSpeedButton1Click(Sender: TObject);
    Private
    { Private declarations }
    Protected
    { Protected declarations }
    Public
    { Public declarations }
       // FUNCTION Execute: TModalResult;
    Published

    END;

VAR
    Frm_Rapport: TFrm_Rapport;
    Procedure RapExecute;

IMPLEMENTATION
{$R *.DFM}
USES
//ConstStd,
Cst_Dm;


Procedure RapExecute;
BEGIN
    Frm_Rapport:= TFrm_Rapport.Create(Application);
    With Frm_Rapport Do
    BEGIN
        TRY
            Showmodal;
        FINALLY
            Free;
        END;
    END;
END;

PROCEDURE TFrm_Rapport.AlgolMainFrmKeyDown ( Sender: TObject;
    VAR Key: Word; Shift: TShiftState ) ;
BEGIN
    CASE key OF
        VK_ESCAPE: SBtn_CancelClick ( Sender );
    END;
END;

PROCEDURE TFrm_Rapport.SBtn_CancelClick ( Sender: TObject ) ;
BEGIN
    ModalResult := mrCancel;
END;

procedure TFrm_Rapport.LMDSpeedButton1Click(Sender: TObject);
begin
     dxImp_Rap.Preview (True);
end;

END.

