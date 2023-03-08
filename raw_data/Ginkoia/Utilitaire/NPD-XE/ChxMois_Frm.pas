//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT ChxMois_Frm;

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
    //PSCMonthsBox,
    RzPopups,
    DateUtils;

TYPE
    Tfrm_ChxMois = CLASS ( TAlgolStdFrm )
        Bev_Dlg: TRzBorder;
        PROCEDURE SBtn_OkClick ( Sender: TObject ) ;
        PROCEDURE SBtn_CancelClick ( Sender: TObject ) ;
        PROCEDURE AlgolMainFrmKeyDown ( Sender: TObject; VAR Key: Word;
            Shift: TShiftState ) ;
    procedure AlgolStdFrmActivate(Sender: TObject);
    procedure Mois_ChxChangeDate(Sender: TObject);
    Private
    { Private declarations }
    Protected
    { Protected declarations }
    Public
    { Public declarations }
    Published

    END;

VAR
    frm_ChxMois: Tfrm_ChxMois;
    FUNCTION ChxMois(var mois:word;var annee:word): Boolean;

IMPLEMENTATION
{$R *.DFM}


FUNCTION ChxMois(var mois:word;var annee:word): Boolean;
BEGIN
    Result := False;
    Application.createform ( TFrm_Chxmois, Frm_chxmois ) ;
    WITH  Frm_chxmois Do
    BEGIN
        TRY
//            frm_chxmois.Mois_chx.month:=mois;
//            frm_chxmois.Mois_chx.year:=annee;
            IF Showmodal = mrOk THEN
            BEGIN
                 Result := True;

//                 mois:= Monthof(RzCalendar1.Date);// Frm_chxmois.Mois_chx.month;
       //          annee:= YearOf(RzCalendar1.Date);// Frm_chxmois.Mois_chx.year;
            END;
        FINALLY
            release;
        END;
    END;
END;


PROCEDURE Tfrm_ChxMois.AlgolMainFrmKeyDown ( Sender: TObject;
    VAR Key: Word; Shift: TShiftState ) ;
BEGIN
    CASE key OF
        VK_ESCAPE: SBtn_CancelClick ( Sender );
        VK_F12: SBtn_OkClick ( Sender );
    END;
END;

PROCEDURE Tfrm_ChxMois.SBtn_OkClick ( Sender: TObject ) ;
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE Tfrm_ChxMois.SBtn_CancelClick ( Sender: TObject ) ;
BEGIN
    ModalResult := mrCancel;
END;

procedure Tfrm_ChxMois.AlgolStdFrmActivate(Sender: TObject);
begin

//     Mois_chx.selected:=mhtMonth;
end;

procedure Tfrm_ChxMois.Mois_ChxChangeDate(Sender: TObject);
begin
ModalResult := mrOk;
end;

END.

