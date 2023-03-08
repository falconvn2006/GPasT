//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT p_Frm;

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
//    PSCMonthsBox,
    Db, dxmdaset, dxDBCtrl, dxDBGrid, dxTL,
    dxCntner, dxDBGridHP, RzPanelRv, StdCtrls, Mask, wwdbedit, wwDBEditRv,
    Buttons, DBSBtn, RzLabel, IB_Components, DBCtrls, RzDBEdit, RzDBBnEd,
    RzDBButtonEditRv, wwDialog, wwidlg, wwLookupDialogRv,
//    IBDataset,
    IBODataset,
  RzEdit, LMDBaseGraphicControl;

TYPE
    Tfrm_P = CLASS(TAlgolStdFrm)
        Pan_Btn: TRzPanel;
        Nbt_quit: TLMDSpeedButton;
        MemD_Mag: TdxMemData;
        MemD_MagNUMERO: TStringField;
        MemD_MagCLIENT: TStringField;
        MemD_MagNOMFICHIER: TStringField;
        MemD_MagCHEMIN: TStringField;
        MemD_MagMAGASIN: TStringField;
        MemD_MagCENTRALE: TStringField;
        RzPanelRv1: TRzPanelRv;
        RzPanelRv2: TRzPanelRv;
        dxDBGridHP1: TdxDBGridHP;
        Ds_Mag: TDataSource;
        dxDBGridHP1RecId: TdxDBGridColumn;
        dxDBGridHP1NUMERO: TdxDBGridMaskColumn;
        dxDBGridHP1CLIENT: TdxDBGridMaskColumn;
        dxDBGridHP1NOMFICHIER: TdxDBGridMaskColumn;
        dxDBGridHP1CHEMIN: TdxDBGridMaskColumn;
        dxDBGridHP1MAGASIN: TdxDBGridMaskColumn;
        dxDBGridHP1CENTRALE: TdxDBGridMaskColumn;
        RzLabel1: TRzLabel;
        RzLabel2: TRzLabel;
        RzLabel3: TRzLabel;
        RzLabel4: TRzLabel;
        RzLabel5: TRzLabel;
        RzLabel6: TRzLabel;
        Pan_Navig: TRzPanel;
        Nbt_Insert: TDBSpeedButton;
        Nbt_Delete: TDBSpeedButton;
        Nbt_Edit: TDBSpeedButton;
        dbSBtnSave: TDBSpeedButton;
        dbSBtnCancel: TDBSpeedButton;
        wwDBEditRv1: TwwDBEditRv;
        wwDBEditRv2: TwwDBEditRv;
        wwDBEditRv3: TwwDBEditRv;
        RzDBButtonEditRv2: TRzDBButtonEditRv;
        Nbt_Connect: TLMDSpeedButton;
        Database: TIB_Connection;
        Que_Mag: TIBOQuery;
        LK_Mag: TwwLookupDialogRV;
        wwDBEditRv4: TwwDBEditRv;
        Chp_chemin: TwwDBEditRv;
        LMDSpeedButton1: TLMDSpeedButton;
        OD: TOpenDialog;
        PROCEDURE SBtn_OkClick(Sender: TObject);
        PROCEDURE SBtn_CancelClick(Sender: TObject);
        PROCEDURE AlgolMainFrmKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE Mois_ChxChangeDate(Sender: TObject);
        PROCEDURE Nbt_quitClick(Sender: TObject);
        PROCEDURE Nbt_CancelClick(Sender: TObject);
        PROCEDURE Nbt_ConnectClick(Sender: TObject);
        PROCEDURE AlgolStdFrmActivate(Sender: TObject);
        PROCEDURE Nbt_PrintFicheClick(Sender: TObject);
        PROCEDURE dbSBtnSaveAfterAction(Sender: TObject; VAR Error: Boolean);
        PROCEDURE MemD_MagAfterScroll(DataSet: TDataSet);
        PROCEDURE RzDBButtonEditRv2ButtonClick(Sender: TObject);
        PROCEDURE LMDSpeedButton1Click(Sender: TObject);
    PRIVATE
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED

    END;

VAR
    frm_P: Tfrm_P;
FUNCTION Param: Boolean;

IMPLEMENTATION
{$R *.DFM}

FUNCTION Param: Boolean;
BEGIN
    Result := False;
    Application.createform(TFrm_p, Frm_p);
    WITH Frm_p DO
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

PROCEDURE Tfrm_P.AlgolMainFrmKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
BEGIN
    CASE key OF
        VK_ESCAPE: SBtn_CancelClick(Sender);
        VK_F12: SBtn_OkClick(Sender);
    END;
END;

PROCEDURE Tfrm_P.SBtn_OkClick(Sender: TObject);
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE Tfrm_P.SBtn_CancelClick(Sender: TObject);
BEGIN
    ModalResult := mrCancel;
END;

PROCEDURE Tfrm_P.Mois_ChxChangeDate(Sender: TObject);
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE Tfrm_P.Nbt_quitClick(Sender: TObject);
BEGIN
    ModalResult := mrOk;
END;

PROCEDURE Tfrm_P.Nbt_CancelClick(Sender: TObject);
BEGIN
    ModalResult := mrcancel;
END;

PROCEDURE Tfrm_P.Nbt_ConnectClick(Sender: TObject);
VAR i: integer;
    txt: STRING;
BEGIN
    screen.cursor := crsqlwait;
    TRY
        database.connected := false;
        database.databasename := chp_chemin.text;
        database.connected := true;
        screen.cursor := crdefault;
        MessageDlg('Chemin de base valide !', mtInformation, [], 0);
    EXCEPT
        screen.cursor := crdefault;
        MessageDlg('Chemin de base non valide', mtWarning, [], 0);
    END;

//
//
//
//     memd_mag.DelimiterChar := ';';
//     memd_mag.loadfromtextfile('C:\Documents and Settings\Brunon\Mes documents\Ginkoia\NPD\magasin.csv');
//
//     memd_mag.first;
//     WHILE not memd_mag.eof do
//     begin
//         i:=pos('=',MemD_MagCLIENT.asstring);
//         memd_mag.edit;
//
//         txt:=MemD_MagCLIENT.asstring;
//         delete(txt,1,i);
//         MemD_MagCLIENT.asstring:=txt;
//
//         txt:=MemD_MagNOMFICHIER.asstring;
//         delete(txt,1,i);
//         MemD_MagNOMFICHIER.asstring:=txt;
//
//         txt:=MemD_MagCHEMIN.asstring;
//         delete(txt,1,i);
//         MemD_MagCHEMIN.asstring:=txt;
//
//         txt:=MemD_MagMAGASIN.asstring;
//         delete(txt,1,i);
//         MemD_MagMAGASIN.asstring:=txt;
//
//         txt:=MemD_MagCENTRALE.asstring;
//         delete(txt,1,i);
//         MemD_MagCENTRALE.asstring:=txt;
//
//         memd_mag.post;
//         memd_mag.next;
//     end ;
//     memd_mag.savetotextfile('C:\Documents and Settings\Brunon\Mes documents\Ginkoia\NPD\magasin.csv');

END;

PROCEDURE Tfrm_P.AlgolStdFrmActivate(Sender: TObject);
BEGIN
    memd_mag.DelimiterChar := ';';
    memd_mag.loadfromtextfile(ExtractFilePath(application.exename) + 'magasin.csv');

END;

PROCEDURE Tfrm_P.Nbt_PrintFicheClick(Sender: TObject);
BEGIN
     // Inprime la forme ...
    Print;
END;

PROCEDURE Tfrm_P.dbSBtnSaveAfterAction(Sender: TObject;
    VAR Error: Boolean);
BEGIN
    memd_mag.savetotextfile(ExtractFilePath(application.exename) + 'magasin.csv');

END;

PROCEDURE Tfrm_P.MemD_MagAfterScroll(DataSet: TDataSet);
BEGIN
    database.connected := false;
END;

PROCEDURE Tfrm_P.RzDBButtonEditRv2ButtonClick(Sender: TObject);
BEGIN

    screen.cursor := crsqlwait;
    TRY
        database.connected := false;
        database.databasename := chp_chemin.text;
        database.connected := true;
        screen.cursor := crdefault;
        lk_mag.execute;
    EXCEPT
        screen.cursor := crdefault;
        MessageDlg('Impossible, la base n' + #39 + 'est pas connecté!', mtWarning, [], 0)
    END;

END;

PROCEDURE Tfrm_P.LMDSpeedButton1Click(Sender: TObject);
BEGIN
    IF memd_mag.state IN [dsedit, dsinsert] THEN
    BEGIN
        IF od.execute THEN
        BEGIN
            MemD_MagCHEMIN.asstring := od.filename;
        END;
    END;
END;

END.

