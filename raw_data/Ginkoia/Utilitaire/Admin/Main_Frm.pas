//------------------------------------------------------------------------------
// Nom de l'unité : Admin_Dm
// Rôle           : Form principale pour Admin
// Auteur         : Sylvain GHEROLD
// Historique     :
//------------------------------------------------------------------------------

UNIT Main_Frm;

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
    Calend,
    wwDialog, wwidlg, wwLookupDialogRv, 
  IB_Components, LMDCustomHint, LMDCustomShapeHint, LMDShapeHint, Wwintl,
  vgStndrt, LMDCustomComponent, LMDContainerComponent, LMDBaseDialog,
  LMDAboutDlg, ActnList, RxCalc, dxBar, StdCtrls, RzLabel, IB_Grid,
  LMDControl, LMDBaseControl, LMDBaseGraphicButton, LMDCustomSpeedButton,
  LMDSpeedButton, IB_UpdateBar, Grids, ExtCtrls, RzPanel,
  LMDCustomScrollBox, LMDScrollBox, fcStatusBar, Mask, wwdbedit, wwDBEditRv;

TYPE
    TFrm_Main = CLASS( TAlgolStdFrm )
        fcStatusBar1: TfcStatusBar;
        Bm_Main: TdxBarManager;
        Dxb_Quit: TdxBarButton;
        Dxb_calc: TdxBarButton;
        Dxb_Calend: TdxBarButton;
        Dxb_Help: TdxBarButton;
        Dxb_About: TdxBarButton;
        Dxb_Apropos: TdxBarSubItem;
        Dxb_Tip: TdxBarButton;
        Calc_Main: TRxCalculator;
        ActionList1: TActionList;
        AboutDlg_Main: TLMDAboutDlg;
        CurSto_Main: TCurrencyStorage;
        TimeSto_Main: TDateTimeStorage;
        IPLang_Main: TwwIntl;
        Hint_Main: TLMDShapeHint;
        Calend_Main: TCalend;
        LMDScrollBox1: TLMDScrollBox;
        Ids_FieldRef: TIB_DataSource;
        Ids_FieldType: TIB_DataSource;
        RzPanel1: TRzPanel;
        dxB_Database: TdxBarSubItem;
        dxB_Extract: TdxBarButton;
        dxB_NullValues: TdxBarButton;
        RzPanel2: TRzPanel;
        IB_Grid1: TIB_Grid;
        RzPanel3: TRzPanel;
        IbG_Table: TIB_Grid;
        RzPanel4: TRzPanel;
        IB_Grid3: TIB_Grid;
        IbLkup_FieldType: TIB_LookupCombo;
        IbLkup_FieldRef: TIB_LookupCombo;
        RzPanel5: TRzPanel;
        Nav_UdpField: TIB_UpdateBar;
        RzPanel6: TRzPanel;
        Nav_UdpTable: TIB_UpdateBar;
        RzPanel7: TRzPanel;
        IbNav_UpdModule: TIB_UpdateBar;
        DbLkDlg_Tables: TwwLookupDialogRv;
        SBtn_AjoutTable: TLMDSpeedButton;
        SBtn_AjoutChamp: TLMDSpeedButton;
        SBtn_Commit: TLMDSpeedButton;
        SBtn_Rollback: TLMDSpeedButton;
        SBtn_Refresh: TLMDSpeedButton;
        Ids_Module: TIB_DataSource;
        Ids_Table: TIB_DataSource;
        Ids_Field: TIB_DataSource;
        dxB_ExtractTab: TdxBarButton;
        SBtn_ChangeReplType: TLMDSpeedButton;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    Chp_Version: TwwDBEditRv;
    Chp_Release: TwwDBEditRv;
        PROCEDURE AlgolStdFrmShow( Sender: TObject );
        PROCEDURE Dxb_QuitClick( Sender: TObject );
        PROCEDURE Dxb_calcClick( Sender: TObject );
        PROCEDURE Dxb_CalendClick( Sender: TObject );
        PROCEDURE Dxb_AboutClick( Sender: TObject );
        PROCEDURE Dxb_TipClick( Sender: TObject );



        PROCEDURE dxB_ExtractClick( Sender: TObject );
        PROCEDURE dxB_NullValuesClick( Sender: TObject );
        PROCEDURE SBtn_CommitClick( Sender: TObject );
        PROCEDURE DbLkDlg_TablesCloseDialog( Dialog: TwwLookupDlg );
        PROCEDURE SBtn_AjoutTableClick( Sender: TObject );
        PROCEDURE SBtn_AjoutChampClick( Sender: TObject );
        PROCEDURE SBtn_RollbackClick( Sender: TObject );
        PROCEDURE SBtn_RefreshClick( Sender: TObject );
        PROCEDURE Bm_MainClickItem( Sender: TdxBarManager;
            ClickedItem: TdxBarItem );
        PROCEDURE AlgolStdFrmCloseQuery( Sender: TObject;
            VAR CanClose: Boolean );
        PROCEDURE dxB_ExtractTabClick( Sender: TObject );
        PROCEDURE SBtn_ChangeReplTypeClick( Sender: TObject );
        PROCEDURE Ids_FieldStateChanged( Sender: TIB_DataSource;
            ADataset: TIB_Dataset );
    procedure Chp_VersionExit(Sender: TObject);
    procedure Chp_ReleaseExit(Sender: TObject);

    private
    { Private declarations }
        LeMag :String;
        PROCEDURE InfoSysteme;
    protected
    { Protected declarations }
    public
    { Public declarations }
    published
    { Published declarations }
    END;

VAR
    Frm_Main: TFrm_Main;

//------------------------------------------------------------------------------
// Ressources strings
//------------------------------------------------------------------------------
//ResourceString

IMPLEMENTATION

USES ConstStd,
    Admin_Dm,
    Main_Dm,
    SelectDB_Frm,
    StdUtils,
    SelectRepl_Frm;

{$R *.DFM}

//------------------------------------------------------------------------------
// Procédures et fonctions internes
//------------------------------------------------------------------------------

PROCEDURE TFrm_Main.InfoSysteme;
BEGIN
    INFMess( 'Attention, les enregistrements crées depuis Admin '#13 + #10 +
        'sont tous des enregistrements "system" ( ID < 0 )', '' );
END;

//------------------------------------------------------------------------------
// Gestionnaires d'événements
//------------------------------------------------------------------------------

PROCEDURE TFrm_Main.AlgolStdFrmShow( Sender: TObject );
BEGIN
    IF NOT Init THEN
    BEGIN
        IF StdConst.Tip_Main.ShowAtStartup THEN ExecTip;
    END;
    chp_version.text:='2.0.0';
    chp_release.text:='0000';
    dm_main.version:=chp_version.text;
    dm_main.release:=chp_release.text;
END;

PROCEDURE TFrm_Main.Dxb_QuitClick( Sender: TObject );
BEGIN
    Close;
END;

PROCEDURE TFrm_Main.Dxb_calcClick( Sender: TObject );
BEGIN
    ExecCalc;
END;

PROCEDURE TFrm_Main.Dxb_TipClick( Sender: TObject );
BEGIN
    ExecTip;
END;

PROCEDURE TFrm_Main.Dxb_AboutClick( Sender: TObject );
BEGIN
    AboutDlg_Main.Execute;
END;

PROCEDURE TFrm_Main.Dxb_CalendClick( Sender: TObject );
BEGIN
    Calend_Main.execute;
END;


PROCEDURE TFrm_Main.dxB_ExtractClick( Sender: TObject );
BEGIN
    Dm_Admin.GetStructureModule;
END;

PROCEDURE TFrm_Main.dxB_ExtractTabClick( Sender: TObject );
BEGIN
    Dm_Admin.GetStructureTable;
END;

PROCEDURE TFrm_Main.dxB_NullValuesClick( Sender: TObject );
BEGIN
    Dm_Admin.GetNullValues;
END;

PROCEDURE TFrm_Main.SBtn_CommitClick( Sender: TObject );
BEGIN
    IF CNFMess( 'Enregistrer les modifications effectuées ?...   ', '', 0 ) = MrYes THEN
    BEGIN
        Dm_Admin.Commit;
        Dm_Admin.Refresh;
        stdTag := -1;
        sbtn_Commit.Enabled := False;
        sbtn_Rollback.Enabled := False;
        sbtn_Refresh.Enabled := True;
        SBtn_ChangeReplType.Enabled := True;
        dm_main.ScriptGinkoia('F');
    END;
END;

PROCEDURE TFrm_Main.DbLkDlg_TablesCloseDialog( Dialog: TwwLookupDlg );
VAR
    i: Integer;
BEGIN
    IF Dialog.ModalResult = mrOk THEN
    BEGIN
        WITH Dialog.wwdbgrid1, Dm_Admin DO
        BEGIN
            FOR i := 0 TO selectedList.Count - 1 DO
            BEGIN
                MemD_Tables.gotoBookmark( selectedList[ i ] );
                AddTAbles;
                MemD_Tables.freeBookmark( selectedlist[ i ] );
            END;
            selectedList.Clear;
        END;
    END;
END;

PROCEDURE TFrm_Main.SBtn_AjoutTableClick( Sender: TObject );
VAR
    Titre: STRING;
BEGIN
    IF Dm_Admin.ModuleOk( Titre ) THEN
    BEGIN
        Dm_Admin.GetTables;
        IF Dm_admin.TablesOk THEN
        BEGIN
            DblkDlg_Tables.Caption := Titre + ' : Ajouter les tables ...' + Titre;
            DbLkDlg_Tables.Execute;
        END
        ELSE
            ErrMess( 'La liste des tables est vide ...    ', '' );
    END
    ELSE
        ErrMess( 'Aucun module pointé ...     ', '' );

END;

PROCEDURE TFrm_Main.SBtn_AjoutChampClick( Sender: TObject );
BEGIN
    Dm_Admin.GetChamps;
END;

PROCEDURE TFrm_Main.SBtn_RollbackClick( Sender: TObject );
BEGIN
    IF CNFMess( 'Abandonner les modifications effectuées ?...   ', '', 1 ) = mrYes THEN
    BEGIN
        Dm_Admin.Rollback;
        Dm_Admin.Refresh;
        StdTag := -1;
        sbtn_Commit.Enabled := False;
        sbtn_Rollback.Enabled := False;
        sbtn_Refresh.Enabled := True;
        SBtn_ChangeReplType.Enabled := True;
    END;

END;

PROCEDURE TFrm_Main.SBtn_RefreshClick( Sender: TObject );
BEGIN
    Dm_Admin.Refresh;
END;

PROCEDURE TFrm_Main.Bm_MainClickItem( Sender: TdxBarManager;
    ClickedItem: TdxBarItem );
VAR
    Cancel: boolean;
BEGIN
    // StdTag de la forme sert
    // de témoin pour autoriser l'accès aux boutons de menus
    // si stdTag >= 0 le boutons de menus dont le Tag est >= 0 sont inhibés

    Cancel := False;
    IF ( ClickedItem IS TdxBarButton ) THEN
        IF clickedItem.Tag >= 0 THEN
            Cancel := StdTag >= 0;

    IF cancel THEN
    BEGIN
        INFMESS( ErrItemMenu, '' );
        Abort;
    END;

END;

PROCEDURE TFrm_Main.AlgolStdFrmCloseQuery( Sender: TObject;
    VAR CanClose: Boolean );
BEGIN

    Canclose := StdTag < 0;
    IF NOT Canclose OR Dm_Main.TransactionUpdPending THEN
    BEGIN
        INFMESS( ErrItemMenu, '' );
        Abort;
    END;
END;

PROCEDURE TFrm_Main.SBtn_ChangeReplTypeClick( Sender: TObject );
VAR
    NewKTBID: integer;
BEGIN
    IF IbG_Table.DataSource.Dataset.RecordCount <> 0 THEN
    BEGIN
        NewKTBID := Frm_SelectRepl.Execute( Dm_Admin.GetTableName );
        IF ( NewKTBID <> 0 ) THEN
        BEGIN
      // Lancer la proc de maj
            Dm_Admin.ChangeKTBID( NewKTBID );
            Dm_Admin.Refresh;
        END;
    END;
END;

PROCEDURE TFrm_Main.Ids_FieldStateChanged( Sender: TIB_DataSource;
    ADataset: TIB_Dataset );
BEGIN
    IF Dm_Admin.UpdPending THEN
    BEGIN
        stdTag := 0;
        sbtn_Commit.Enabled := True;
        sbtn_Rollback.Enabled := True;
        sbtn_Refresh.Enabled := False;
        SBtn_ChangeReplType.Enabled := False;
    END
    ELSE
    BEGIN
        sbtn_Commit.Enabled := False;
        sbtn_Rollback.Enabled := False;
        sbtn_Refresh.Enabled := True;
        SBtn_ChangeReplType.Enabled := True;
        stdTag := -1;
        Dm_Admin.Rollback; // juste pour réinitialiser le compteur sur KTBID...
    END;
END;

procedure TFrm_Main.Chp_VersionExit(Sender: TObject);
begin
dm_main.version:=chp_version.text;
end;

procedure TFrm_Main.Chp_ReleaseExit(Sender: TObject);
begin
dm_main.release:=chp_release.text;
end;

END.

