UNIT admin_frm;

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
  Db,
  ADODB,
  ComCtrls,
 // vgCtrls,
  vgPageControlRv,
  LMDControl,
  LMDBaseControl,
  LMDBaseGraphicButton,
  LMDCustomSpeedButton,
  LMDSpeedButton,
  IBODataset,
  wwDialog,
  wwidlg,
  wwLookupDialogRv,
  dxmdaset,
  LMDCustomComponent,
  LMDIniCtrl,
  IB_Components,
  ActionRv,
  dxDBGrid,
  dxGrClEx,
  dxDBTLCl,
  dxGrClms,
  Buttons,
  DBSBtn,
  dxTL,
  dxDBCtrl,
  dxCntner,
  dxDBGridHP,
  ExtCtrls,
  RzPanel,
  RzPanelRv,
  StdCtrls,
  RzLabel,
  DateUtils,
  ListBitMap,

  IBDatabase,
  IBCustomDataSet,
  IBQuery,

  IBSQL,
  IBTable,

  Grids,
  DBGrids,
  Boxes,
  PanBtnDbgHP,
  variants, LMDCustomButton, LMDButton, LMDBaseGraphicControl, AlgolDialogForms,
  AdvGlowButton, GinkoiaStyle_Dm, IniCfg_Frm, uVersion;

TYPE
  TFrm_Admin = CLASS(TAlgolDialogForm)
    Pgc_Catman: TvgPageControlRv;
    Tab_Mag: TTabSheet;
    Tab_Alerte: TTabSheet;
    Tab_Cat: TTabSheet;
    ADO: TADOConnection;
    Qmag: TADOQuery;
    RzPanelRv1: TRzPanelRv;
    DBG_Mag: TdxDBGridHP;
    DBG_Magmag_id: TdxDBGridMaskColumn;
    DBG_Magmag_code: TdxDBGridMaskColumn;
    DBG_Magmag_nom: TdxDBGridMaskColumn;
    DBG_Magmag_ville: TdxDBGridMaskColumn;
    DBG_Magmag_actif: TdxDBGridCheckColumn;
    Ds_Mag: TDataSource;
    Pan_Navig: TRzPanel;
    Nbt_Edit: TDBSpeedButton;
    Nbt_Post: TDBSpeedButton;
    Nbt_Cancel: TDBSpeedButton;
    Ds_PanNavRv: TDataSource;
    DBG_Magmag_cheminbase: TdxDBGridExtLookupColumn;
    OD_Bases: TOpenDialog;
    close: TGroupDataRv;
    Qmagmag_id: TAutoIncField;
    Qmagmag_actif: TIntegerField;
    Qmagmag_dateactivation: TDateTimeField;
    Qmagmag_code: TStringField;
    Qmagmag_nom: TStringField;
    Qmagmag_ville: TStringField;
    Qmagmag_cheminbase: TStringField;
    Pan_Activ: TRzPanelRv;
    RzLabel1: TRzLabel;
    Lab_Actif: TRzLabel;
    Qmagactif: TADOQuery;
    dxDBGridHP1: TdxDBGridHP;
    Ds_Alerte: TDataSource;
    QAlerte: TADOQuery;
    RzPanelRv3: TRzPanelRv;
    RzLabel2: TRzLabel;
    dxDBGridHP1mag_id: TdxDBGridMaskColumn;
    dxDBGridHP1mag_code: TdxDBGridMaskColumn;
    dxDBGridHP1mag_nom: TdxDBGridMaskColumn;
    dxDBGridHP1mag_ville: TdxDBGridMaskColumn;
    dxDBGridHP1replic: TdxDBGridDateColumn;
    dxDBGridHP1mhi_info: TdxDBGridMaskColumn;
    RzLabel3: TRzLabel;
    qhisto: TADOQuery;
    qhistomhi_datedeb: TDateTimeField;
    qhistomhi_datefin: TDateTimeField;
    qhistoCOLUMN1: TDateTimeField;
    qhistomhi_kdeb: TIntegerField;
    qhistomhi_kfin: TIntegerField;
    qhistomhi_ok: TBooleanField;
    qhistomhi_info: TStringField;
    qhistoaa: TADOStoredProc;
    Qdos: TADOQuery;
    Qmagmag_dosid: TIntegerField;
    QdosDOS_ID: TAutoIncField;
    QdosDOS_NOM: TStringField;
    QdosDOS_COMMENT: TStringField;
    QdosDOS_ENABLED: TIntegerField;
    QdosDOS_GUID: TStringField;
    tran: TIB_Transaction;
    Ginkoia: TIB_Connection;
    qbase: TIB_Cursor;
    Qcode: TIB_Cursor;
    QdosUpdate: TADOQuery;
    Qmagdos_nom: TStringField;
    DBG_MagColumn8: TdxDBGridMaskColumn;
    Pan_Mag: TPanelDbg;
    QVisucat: TADOQuery;
    RzPanelRv4: TRzPanelRv;
    ds_visucat: TDataSource;
    dxDBGridHP2: TdxDBGridHP;
    dxDBGridHP2cat_id: TdxDBGridMaskColumn;
    dxDBGridHP2cat_nom: TdxDBGridMaskColumn;
    dxDBGridHP2cat_date: TdxDBGridDateColumn;
    dxDBGridHP2nba: TdxDBGridMaskColumn;
    RzPanelRv5: TRzPanelRv;
    RzLabel4: TRzLabel;
    RzPanelRv6: TRzPanelRv;
    RzPanelRv7: TRzPanelRv;
    RzLabel5: TRzLabel;
    dxDBGridHP3: TdxDBGridHP;
    RzLabel6: TRzLabel;
    INI: TLMDIniCtrl;
    MemD_Cat: TdxMemData;
    MemD_Catnom: TStringField;
    Ds_Cat: TDataSource;
    dxDBGridHP3RecId: TdxDBGridColumn;
    dxDBGridHP3nom: TdxDBGridMaskColumn;
    Tcatal: TADOTable;
    TcatalCAT_ID: TAutoIncField;
    TcatalCAT_NOM: TStringField;
    TcatalCAT_DATE: TDateTimeField;
    MemD_GT: TdxMemData;
    MemD_GTITEMID: TStringField;
    MemD_GTGTFID: TIntegerField;
    MARQUE: TADOTable;
    MARQUEMRK_ID: TAutoIncField;
    MARQUEMRK_NOM: TStringField;
    que_fedas: TADOQuery;
    T: TADOStoredProc;
    CL: TADOStoredProc;
    TL: TADOStoredProc;
    MemD_Tai: TdxMemData;
    MemD_TaiLIBGT: TStringField;
    MemD_TaiLIBTAIL: TStringField;
    MemD_TaiTGF_ID: TIntegerField;
    MemD_Cou: TdxMemData;
    MemD_CouITEMID: TStringField;
    MemD_CouCODE: TStringField;
    MemD_CouCOU_ID: TStringField;
    CB: TADOStoredProc;
    MemD_ART: TdxMemData;
    MemD_ARTITEMID: TStringField;
    MemD_ARTGTITEMID: TStringField;
    MemD_ARTART_ID: TIntegerField;
    MemD_Pbl: TdxMemData;
    MemD_PblITEMID: TStringField;
    MemD_PblMOTIF: TStringField;
    MemD_PblIDRECHERCHE: TStringField;
    QCol: TADOQuery;
    LK_Col: TwwLookupDialogRV;
    Qcat: TADOQuery;
    lk_cat: TwwLookupDialogRV;
    QColCOL_NOM: TStringField;
    QcatCAT_NOM: TStringField;
    QcatCAT_ID: TAutoIncField;
    Collec: TADOQuery;
    QColCOL_ID: TAutoIncField;
    Tab_Divers: TTabSheet;
    ODI: TOpenDialog;
    SupInd: TADOCommand;
    MemD_INDIC: TdxMemData;
    MemD_INDICCOLLECTION: TStringField;
    MemD_INDICCATEGORIE: TStringField;
    MemD_INDICMARQUE: TStringField;
    MemD_INDICTYPE: TIntegerField;
    MemD_INDICMOIS: TStringField;
    MemD_INDICDEBUT: TFloatField;
    MemD_INDICFIN: TFloatField;
    MemD_INDICCOULEUR: TStringField;
    TInd: TADOTable;
    TIndING_COLID: TIntegerField;
    TIndING_CATID: TIntegerField;
    TIndING_MRKID: TIntegerField;
    TIndING_TYPID: TIntegerField;
    TIndING_MOIS: TStringField;
    TIndING_DEBUT: TFloatField;
    TIndING_FIN: TFloatField;
    TIndING_COUL: TWordField;
    TIndING_DELETED: TDateTimeField;
    Tcateg: TADOTable;
    QCM: TADOQuery;
    TcategCAT_ID: TAutoIncField;
    QCMmrk_id: TAutoIncField;
    TIndING_ENABLED: TSmallintField;
    TcategCAT_NOM: TStringField;
    QCMmrk_nom: TStringField;
    MemD_Mag: TdxMemData;
    MemD_MagCODE: TStringField;
    MemD_MagACHAT1: TFloatField;
    MemD_MagMARGE1: TFloatField;
    MemD_MagACHAT2: TFloatField;
    MemD_MagMARGE2: TFloatField;
    MemD_MagMARGE3: TFloatField;
    Tregion: TADOTable;
    Tmag: TADOTable;
    Tdossier: TADOTable;
    TdossierDOS_ID: TAutoIncField;
    TdossierDOS_NOM: TStringField;
    TdossierDOS_COMMENT: TStringField;
    TdossierDOS_ENABLED: TIntegerField;
    TdossierDOS_GUID: TStringField;
    TmagMAG_ID: TAutoIncField;
    TmagMAG_DOSID: TIntegerField;
    TmagMAG_REGID: TIntegerField;
    TmagMAG_CODE: TStringField;
    TmagMAG_NOM: TStringField;
    TmagMAG_DIRECTEUR: TStringField;
    TmagMAG_VILLE: TStringField;
    TmagMAG_LEARDERSHIP: TIntegerField;
    TmagMAG_ENABLED: TIntegerField;
    TmagMAG_CHEMINBASE: TStringField;
    TmagMAG_DATEACTIVATION: TDateTimeField;
    TmagMAG_ACTIF: TIntegerField;
    TmagMAG_X: TSmallintField;
    TmagMAG_Y: TSmallintField;
    TregionREG_ID: TAutoIncField;
    TregionREG_NOM: TStringField;
    TTYM: TADOTable;
    TTYMTYM_ID: TAutoIncField;
    TTYMTYM_NOM: TStringField;
    TmagMAG_TYMID: TIntegerField;
    QCC: TADOQuery;
    QCCcat_id: TAutoIncField;
    QCCcat_nom: TStringField;
    QCCmrk_id: TAutoIncField;
    QCCmrk_nom: TStringField;
    TIM: TADOTable;
    MemD_MagCOLLECTION: TStringField;
    MemD_MagNBCAT: TIntegerField;
    MemD_MagMARQUE1: TStringField;
    MemD_MagMARQUE2: TStringField;
    MemD_MagMARQUE3: TStringField;
    TIMIND_MAGID: TIntegerField;
    TIMIND_COLID: TIntegerField;
    TIMIND_CATID: TIntegerField;
    TIMIND_MRKID: TIntegerField;
    TIMIND_ACHAT: TFloatField;
    TIMIND_MARGE: TFloatField;
    MemD_MagCATEG1: TStringField;
    MemD_MagCATEG2: TStringField;
    MemD_MagCATEG3: TStringField;
    QlkCol: TADOQuery;
    DBG_Magmag_dateactivation: TdxDBGridButtonColumn;
    LK_Coldeb: TwwLookupDialogRV;
    QlkColcol_id: TAutoIncField;
    QlkColLIb: TStringField;
    QlkColcol_debut: TDateTimeField;
    IB_Kmin: TIB_Cursor;
    IbC_Plage: TIB_Cursor;
    Qinit: TADOCommand;
    IbC_Adh: TIB_Cursor;
    ado_test: TADOConnection;
    ado_Reel: TADOConnection;
    QAlertemag_id: TIntegerField;
    QAlertemag_code: TStringField;
    QAlertedos_nom: TStringField;
    QAlertemag_nom: TStringField;
    QAlertemag_ville: TStringField;
    QAlertemhi_datedeb: TDateTimeField;
    QAlertemhi_info: TStringField;
    dxDBGridHP1dosnom: TdxDBGridMaskColumn;
    Calerte: TADOCommand;
    IB_control: TIB_Cursor;
    MemD_Regul: TdxMemData;
    MemD_RegulREF: TStringField;
    MemD_RegulDesi: TStringField;
    MemD_RegulNOF: TStringField;
    MemD_RegulNomF: TStringField;
    MemD_RegulGT: TStringField;
    MemD_RegulPAN: TFloatField;
    QR: TADOQuery;
    qpx: TADOQuery;
    VIDE: TADOStoredProc;
    ado_tsl: TADOConnection;
    MemD_Tsl: TdxMemData;
    MemD_TslCODE: TStringField;
    MemD_TslLIB: TStringField;
    MemD_TslTAILLE: TStringField;
    MemD_TslEAN: TStringField;
    TSL_article: TADOQuery;
    tsl_gtf: TADOQuery;
    ado_local: TADOConnection;
    Q_EntIDref: TADOQuery;
    article: TADOStoredProc;
    IBOQryRo: TIBOQuery;
    QTREF: TADOQuery;
    Pan_Agregat: TRzPanelRv;
    Lab_Agregat: TRzLabel;
    QAg: TADOQuery;
    lab_integ: TRzLabel;
    MemD_Maga: TdxMemData;
    MemD_MagaCODE: TStringField;
    MemD_MagaDOSSIER: TStringField;
    MemD_MagaVILLE: TStringField;
    MemD_MagaNOM: TStringField;
    MemD_MagaDIRECTEUR: TStringField;
    MemD_MagaREGION: TStringField;
    RSM: TADOTable;
    RSMRSM_CODE: TStringField;
    RSMRSM_LIB: TStringField;
    RSMRSM_TAILLE: TStringField;
    RSMRSM_EAN: TStringField;
    dxMemData1: TdxMemData;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    Q_TL: TADOQuery;
    MemD_Smu: TdxMemData;
    MemD_SmuREF: TStringField;
    MemD_SmuMARQUE: TIntegerField;
    TSMU: TADOTable;
    TSMUSMU_REFMRK: TStringField;
    TSMUSMU_MRKID: TIntegerField;
    TSMUSMU_OK: TBooleanField;
    TSMUSMU_CATEG: TIntegerField;
    MemD_SmuCATEG: TIntegerField;
    MemD_MagACHAT3: TFloatField;
    MemD_MagCATEG4: TStringField;
    MemD_MagMARQUE4: TStringField;
    MemD_MagACHAT4: TFloatField;
    MemD_MagMARGE4: TFloatField;
    MemD_MagCATEG5: TStringField;
    MemD_MagMARQUE5: TStringField;
    MemD_MagACHAT5: TFloatField;
    MemD_MagMARGE5: TFloatField;
    MemD_MagCATEG6: TStringField;
    MemD_MagMARQUE6: TStringField;
    MemD_MagACHAT6: TFloatField;
    MemD_MagMARGE6: TFloatField;
    MemD_MagCATEG7: TStringField;
    MemD_MagMARQUE7: TStringField;
    MemD_MagACHAT7: TFloatField;
    MemD_MagMARGE7: TFloatField;
    MemD_MagaCHEMIN: TStringField;
    IB_sender: TIB_Connection;
    Que_Sender: TIBOQuery;
    LK_Send: TwwLookupDialogRV;
    Que_SenderSENDER_ID: TIntegerField;
    Que_SenderFLD_DATABASE: TStringField;
    Que_SenderSENDER_NAME: TStringField;
    Qmagmag_senderid: TIntegerField;
    COULEUR: TADOStoredProc;
    BdDos: TADOConnection;
    Tdoss: TADOTable;
    Tdossdos_id: TAutoIncField;
    Tdossdos_nom: TStringField;
    Tdossdos_centrale: TStringField;
    Tdossdos_code: TStringField;
    Tdossdos_magnom: TStringField;
    Tdossdos_ville: TStringField;
    Tdossdos_chemin: TStringField;
    Tab_Levis: TTabSheet;
    RzPanelRv8: TRzPanelRv;
    DBG_LEVIS: TdxDBGridHP;
    aQue_Mag: TADOQuery;
    Ds_Levis: TDataSource;
    DBG_LEVISMAG_ID: TdxDBGridMaskColumn;
    DBG_LEVISMAG_CODE: TdxDBGridMaskColumn;
    DBG_LEVISMAG_NOM: TdxDBGridMaskColumn;
    DBG_LEVISMAG_VILLE: TdxDBGridMaskColumn;
    DBG_LEVISMAG_CHEMINBASE: TdxDBGridMaskColumn;
    DBG_LEVISColumn8: TdxDBGridMaskColumn;
    DBG_LEVISMAG_LEVIS: TdxDBGridCheckColumn;
    Pan_LEVIS: TPanelDbg;
    Pan_NavLevis: TRzPanel;
    dbSBtnEdit: TDBSpeedButton;
    dbSBtnSave: TDBSpeedButton;
    dbSBtnCancel: TDBSpeedButton;
    aQue_MagMAG_ID: TAutoIncField;
    aQue_MagMAG_CODE: TStringField;
    aQue_MagMAG_NOM: TStringField;
    aQue_MagMAG_VILLE: TStringField;
    aQue_MagMAG_CHEMINBASE: TStringField;
    aQue_MagMAG_LEVIS: TWordField;
    aQue_MagMAG_DATEACTIVATIONLEVIS: TDateTimeField;
    aQue_Magdos_nom: TStringField;
    DBG_LEVISMAG_DATEACTIVATIONLEVIS: TdxDBGridButtonColumn;
    aQue_Tmp: TADOQuery;
    Que_GetVersion: TIBOQuery;
    Nbt_ModifCMD: TBitBtn;
    dtp_Date: TDateTimePicker;
    ProgressBar1: TProgressBar;
    Nbt_LastKId: TBitBtn;
    Nbt_SelMag: TBitBtn;
    LMDSpeedButton4: TAdvGlowButton;
    LMDSpeedButton6: TAdvGlowButton;
    LMDSpeedButton11: TAdvGlowButton;
    LMDSpeedButton12: TAdvGlowButton;
    Nbt_Multi: TAdvGlowButton;
    Nbt_IntegIndicGen: TAdvGlowButton;
    Nbt_IntegNewMag: TAdvGlowButton;
    Nbt_IndicMag: TAdvGlowButton;
    Nbt_ArticleRSM: TAdvGlowButton;
    Nbt_RegulPxNet: TAdvGlowButton;
    Nbt_SMU: TAdvGlowButton;
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    AdvGlowButton1: TAdvGlowButton;
    Nbt_Parametrage: TAdvGlowButton;
    PROCEDURE FormCreate(Sender: TObject);

    PROCEDURE Pgc_CatmanChange(Sender: TObject);
    PROCEDURE DBG_Magmag_cheminbaseCloseUp(Sender: TObject;
      VAR Text: STRING; VAR Accept: Boolean);
    PROCEDURE DBG_Magmag_cheminbaseEditButtonClick(Sender: TObject);
    PROCEDURE LMDSpeedButton1Click(Sender: TObject);
    PROCEDURE SBtn_QuitClick(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PROCEDURE Nbt_EditBeforeAction(Sender: TObject;
      VAR ActionIsDone: Boolean);
    PROCEDURE Nbt_CancelAfterAction(Sender: TObject; VAR Error: Boolean);
    PROCEDURE QmagAfterPost(DataSet: TDataSet);
    PROCEDURE QmagAfterCancel(DataSet: TDataSet);
    PROCEDURE QmagBeforePost(DataSet: TDataSet);
    PROCEDURE dxDBGridHP1DblClick(Sender: TObject);
    PROCEDURE DBG_MagDblClick(Sender: TObject);
    PROCEDURE qhistoFilterRecord(DataSet: TDataSet; VAR Accept: Boolean);
    PROCEDURE qhistomhi_okGetText(Sender: TField; VAR Text: STRING;
      DisplayText: Boolean);
    PROCEDURE dxDBGridHP3DblClick(Sender: TObject);
    PROCEDURE Nbt_IntegIndicGenClick(Sender: TObject);
    PROCEDURE Nbt_IntegNewMagClick(Sender: TObject);
    PROCEDURE DBG_Magmag_dateactivationButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    PROCEDURE QmagBeforeEdit(DataSet: TDataSet);
    PROCEDURE QmagBeforeInsert(DataSet: TDataSet);
    PROCEDURE LMDSpeedButton4Click(Sender: TObject);
    PROCEDURE Nbt_RegulPxNetClick(Sender: TObject);
    PROCEDURE LMDSpeedButton6Click(Sender: TObject);
    PROCEDURE Nbt_ArticleRSMClick(Sender: TObject);
    PROCEDURE Nbt_IndicMagClick(Sender: TObject);
    PROCEDURE Nbt_SMUClick(Sender: TObject);
    PROCEDURE LMDSpeedButton11Click(Sender: TObject);
    PROCEDURE LMDSpeedButton12Click(Sender: TObject);
    PROCEDURE Nbt_MultiClick(Sender: TObject);
    procedure dbSBtnEditBeforeAction(Sender: TObject;
      var ActionIsDone: Boolean);
    procedure aQue_MagBeforePost(DataSet: TDataSet);
    procedure DBG_LEVISMAG_DATEACTIVATIONLEVISButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure Nbt_ModifCMDClick(Sender: TObject);
    procedure Nbt_LastKIdClick(Sender: TObject);
    procedure Nbt_SelMagClick(Sender: TObject);
    procedure Nbt_ParametrageClick(Sender: TObject);

  PRIVATE
    { Déclarations privées }
    repcat: STRING;
    flagdate: integer;
    sendere: integer;
    PROCEDURE Integration(catal: STRING; multi: integer);
    FUNCTION InitTHisto(mag_id: integer): boolean;

    function GetMaxKVersion(KTB_ID : integer;K_INSERTED : TDateTime) : Integer;
    function GetLastGenID: Integer;

    function ConnexionDb : Boolean;

  PUBLIC
    { Déclarations publiques }
    memoactif: integer;
    PROCEDURE visuhisto(magid: integer);

    function GetCountMAGDATE(MAG_ID : Integer;MHL_DATE : TDate) : Integer;
    function InsertNewLineHisto(MHL_MAGID : Integer;MHL_DATE : TDate;MHL_TYP,MHL_KVSTK, MHL_KVNEGBL, MHL_KVNEGFCT : Integer) : Boolean;

  END;

VAR
  Frm_Admin: TFrm_Admin;

IMPLEMENTATION

USES
  DlgStd_Frm,
  Histo_frm,
  xml_unit,
  icxmlparser,
  GaugeMess_Frm;

{$R *.DFM}

PROCEDURE TFrm_Admin.FormCreate(Sender: TObject);
var
  i : integer;
BEGIN
  Caption := Caption + ' - Version : ' + GetNumVersionSoft;
  // Gestion du style des boutons
  for i := 1 to ComponentCount do
  begin
    if Components[i-1] is TAdvGlowButton then
      Dm_GinkoiaStyle.AppliqueStyleAdvGlowButton(TAdvGlowButton(Components[i-1]));
  end;

  // chargementdu fichier Ini
  IniCfg.LoadIni;
  IniCfg.AdoConnection := ado_Reel;
  IniCfg.AdoAddidasTSL := ado_tsl;
  IniCfg.AdoBaseTest := ado_test;
  IniCfg.AdoBaseLocale := ado_local;

  // Chargement de la configuration dans les composants base de données
  ConnexionDb;

  sendere := 0;
//  IF INI.readString('BASE', 'TSL', '') = 'O' THEN
//  BEGIN
//    ado.ConnectionString := ado_tsl.ConnectionString;
//    self.caption := 'ADIDAS TSL';
//  END
//  ELSE
//  BEGIN
//    IF INI.readString('BASE', 'TEST', '') = 'O' THEN
//    BEGIN
//      ado.ConnectionString := ado_test.ConnectionString;
//      self.caption := '**** BASE TEST ****';
//    END
//    ELSE
//    BEGIN
//      IF INI.readString('BASE', 'LOCAL', '') = 'O' THEN
//      BEGIN
//        ado.ConnectionString := ado_Local.ConnectionString;
//      END
//      ELSE
//      BEGIN
//        ado.ConnectionString := ado_reel.ConnectionString;
//      END
//    END
//  END;
//
//  ShowMessHPAvi('Connexion au serveur SPORT2000 en cours ...', false, 0, 0, 'Administration CATMAN');
//  TRY
//    ado.connected := true;
//  EXCEPT
//    ShowCloseHP;
//    InfoMessHP('Problème de connection avec le serveur SPORT2000,' + #10 + #13 +
//      'Réessayez ultérieurement...', true, 0, 0);
//
//    application.terminate;
//  END;
//  ShowCloseHP;
  pgc_catman.activepage := tab_alerte;
  Pgc_CatmanChange(NIL);

END;

function TFrm_Admin.GetCountMAGDATE(MAG_ID: Integer; MHL_DATE: TDate): Integer;
begin
  With aQue_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select count(*) as Resultat from MAGASINHISTOLEVIS');
    SQL.Add('Where MHL_MAGID = :PMAGID');
    SQL.Add('  and MHL_DATE  >= :PMHLDATE');
    SQL.Add('  and MHL_TYP   = 3');
    SQL.Add('  and MHL_OK    = 1');
    ParamCheck := True;
    With Parameters do
    begin
      ParamByName('PMAGID').Value := MAG_ID;
      ParamByName('PMHLDATE').Value  := DateOf(MHL_DATE);
    end;
    Open;

    Result := FieldByName('Resultat').AsInteger;
  end;
end;

function TFrm_Admin.GetLastGenID: Integer;
begin
With Que_GetVersion do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select GEN_ID(GENERAL_ID,1) as Resultat from GENBASES');
    SQL.Add('Where BAS_ID = 0');
    Open;

    Result := FieldByName('Resultat').AsInteger;
  end;
end;

function TFrm_Admin.GetMaxKVersion(KTB_ID : integer; K_INSERTED: TDateTime): Integer;
begin
  With Que_GetVersion do
  begin
    close;
    SQL.Clear;
    SQL.Add('Select max(K_VERSION) as Resultat from K');
    SQL.Add('Where K_enabled = 1');
    SQL.Add('  and K_INSERTED <= :PDate');
    SQL.Add('  and KTB_ID = :PKTBID');
    ParamCheck := True;
    ParamByName('PDate').AsDatetime := K_INSERTED;
    ParamByName('PKTBID').AsInteger := KTB_ID;
    Open;

    if Recordcount > 0 then
      Result := FieldByName('Resultat').AsInteger
    else
      Result := 0;
  end;
end;

PROCEDURE TFrm_Admin.Pgc_CatmanChange(Sender: TObject);
VAR
  Catal: STRING;
  fichier: TSearchRec;
  integ: STRING;
BEGIN
  IF pgc_catman.activepage = tab_mag THEN
  BEGIN
    IF NOT qmag.active THEN qmag.open;
    DBG_Magmag_code.readonly := true;
    DBG_Magmag_nom.readonly := true;
    DBG_Magmag_ville.readonly := true;

  END;

  IF pgc_catman.activepage = tab_alerte THEN
  BEGIN
    calerte.Execute;
    qalerte.open;
    qmagactif.close;
    qmagactif.open;
    IF qmagactif.fieldbyname('actif').asinteger <> 0 THEN
    BEGIN
      pan_activ.visible := true;
      lab_actif.caption := 'Attention, ' +
        qmagactif.fieldbyname('actif').asstring +
        ' magasin(s) ne sont pas activé(s).';
    END
    ELSE
      pan_activ.visible := false;

    IF NOT (self.caption = 'ADIDAS TSL') THEN //SAUF ADIDAS
    BEGIN

      //Info sur les agregats
      // Lecture du dernier enreg.
      qag.close;
      qag.open;

      IF now - qag.fieldbyname('hag_date').asdatetime > 1 THEN
        lab_agregat.color := clred
      ELSE
        lab_agregat.color := clBtnFace;

      Lab_agregat.caption := '  Dernier calcul agregat : ' + datetimetostr(qag.fieldbyname('hag_date').asdatetime);

      IF qag.fieldbyname('hag_result').asinteger = 0 THEN
      BEGIN
        Lab_integ.color := clBtnFace;
        Lab_Integ.caption := 'Intégrité : OK  '
      END
      ELSE
      BEGIN
        Lab_integ.color := clred;
        Lab_Integ.caption := '  Intégrité : PROBLEME  '
      END;
      qag.close;
    END;
  END;

  IF pgc_catman.activepage = tab_cat THEN
  BEGIN
//    Repcat := INI.readString('REP', 'CATA', '');
    Repcat := IncludeTrailingPathDelimiter(IniCfg.CatalogDir);
    IF repcat = '\' THEN
    BEGIN
      InfoMessHP('Répertoire des catalogues non renseigné dans .INI...', false, 0, 0);
      application.terminate;
    END;

    //Init de la liste des catal à intégrer et deja integrer
    qvisucat.close;
    qvisucat.open;
    memd_cat.close;
    memd_cat.open;
    IF FindFirst(repcat + 'ART_*.xml', faAnyFile, Fichier) = 0 THEN
    BEGIN
      Catal := fichier.name;
      delete(catal, 1, 4);
      memd_cat.append;
      MemD_Catnom.asstring := catal;
      memd_cat.post;

      WHILE FindNext(fichier) = 0 DO
      BEGIN
        catal := fichier.name;
        delete(catal, 1, 4);
        memd_cat.append;
        MemD_Catnom.asstring := catal;
        memd_cat.post;
      END;
    END;

  END;

   IF pgc_catman.activepage = Tab_Levis THEN
   begin
     if not aQue_Mag.Active then
       aQue_Mag.Open;
   end;

END;

PROCEDURE TFrm_Admin.DBG_Magmag_cheminbaseCloseUp(Sender: TObject;
  VAR Text: STRING; VAR Accept: Boolean);
BEGIN
  MessageDlg('', mtWarning, [], 0);
END;

PROCEDURE TFrm_Admin.DBG_Magmag_cheminbaseEditButtonClick(Sender: TObject);
VAR
  s: STRING;
  i: integer;
BEGIN
  IF ds_mag.dataset.state IN [dsedit] THEN
  BEGIN
    IF OD_Bases.execute THEN
    BEGIN
      S := Uppercase(OD_Bases.FileName);
      IF s[1] = '\' THEN
      BEGIN
        // Distant
        delete(s, 1, 2);
        IF pos('$', s) > 0 THEN
        BEGIN
          s[pos('$', s)] := ':';
          s[pos('\', s)] := ':';
        END
        ELSE
        BEGIN
          i := pos('\', s);
          insert(':D:', s, i);
        END;
        qmag.fieldbyname('mag_cheminbase').asstring := S;
      END
      ELSE
      BEGIN
        // local
        qmag.fieldbyname('mag_cheminbase').asstring := S;
      END;
      ginkoia.databasename := s;
      ginkoia.open;
      qcode.parambyname('code').asstring := qmag.fieldbyname('mag_code').asstring;
      qcode.open;
      IF qcode.fieldbyname('nbr').asinteger = 0 THEN
      BEGIN
        InfoMessHP('Impossible, le code adhérent ne correspond pas' + #10 + #13 +
          'aux magasins de cette base Ginkoia...', true, 0, 0);
        qmag.fieldbyname('mag_cheminbase').asstring := '';
      END;
      IF qcode.fieldbyname('nbr').asinteger > 1 THEN
      BEGIN
        InfoMessHP('Impossible, le code adhérent correspond à' + #10 + #13 +
          'plusieurs magasins de cette base Ginkoia...', true, 0, 0);
        qmag.fieldbyname('mag_cheminbase').asstring := '';
      END;
      qcode.close;
      ginkoia.close;
    END;
  END;
  ABORT;
END;

PROCEDURE TFrm_Admin.LMDSpeedButton1Click(Sender: TObject);
BEGIN
  application.terminate;
END;

PROCEDURE TFrm_Admin.SBtn_QuitClick(Sender: TObject);
BEGIN
  application.terminate;

END;

PROCEDURE TFrm_Admin.FormCloseQuery(Sender: TObject;
  VAR CanClose: Boolean);
BEGIN
  close.close;
  ado.close;
  ginkoia.close
END;

PROCEDURE TFrm_Admin.Nbt_EditBeforeAction(Sender: TObject;
  VAR ActionIsDone: Boolean);
BEGIN
  IF Qmagmag_dateactivation.asdatetime = 0 THEN
  BEGIN
    Qmagmag_dateactivation.readonly := false;
    DBG_Magmag_dateactivation.showbuttonstyle := sbdefault;
  END
  ELSE
    Qmagmag_dateactivation.readonly := true;
  memoactif := Qmagmag_actif.asinteger;
  DBG_Magmag_cheminbase.showbuttonstyle := sbdefault;
END;

procedure TFrm_Admin.Nbt_LastKIdClick(Sender: TObject);
var
  iKidBase : Integer;
begin
  {
    Permet de remettre tous les historiques des bases ayant MAG_LEVIS = 1
    sur le dernier K_ID à la date du jour du DateTimePicker
  }

  With aQue_Mag do
  begin
    First;
    ado_Reel.BeginTrans;
    try
      while Not EOF do
      begin
        if FieldByName('MAG_LEVIS').AsInteger = 1 then
        begin
            With Ginkoia do
            begin
              Close;
              DatabaseName := FieldByName('MAG_CHEMINBASE').AsString;
              //'C:\Developpement\Ginkoia\Data\SORIN-S2K\GINKOIA.IB';
              Try
                Open;
                iKidBase := GetLastGenID;
              Except on E:Exception do
                begin
                  ShowMessHP('Erreur de connexion à la base de données : ' + FieldByName('MAG_CHEMINBASE').AsString + ' ' + E.Message,True,0,0,'Connexion');
                end;
              End;
            end; // with

            InsertNewLineHisto(FieldByName('MAG_ID').AsInteger,dtp_Date.Date,1,iKidBase,iKidBase,iKidBase);
            InsertNewLineHisto(FieldByName('MAG_ID').AsInteger,dtp_Date.Date,2,iKidBase,iKidBase,iKidBase);
            InsertNewLineHisto(FieldByName('MAG_ID').AsInteger,dtp_Date.Date,3,iKidBase,iKidBase,iKidBase);
        end;
        ProgressBar1.Position := RecNo * 100 Div RecordCount;
        Next;
        Application.ProcessMessages;
      end;  // while
      ado_Reel.CommitTrans;
    Except on E:Exception do
      begin
        ado_Reel.RollbackTrans;
        ShowMessage(E.Message);
      end;
    end;
  end;
end;

procedure TFrm_Admin.Nbt_ModifCMDClick(Sender: TObject);
var
  IdKvTicket  ,
  IdKvBL      ,
  IdKvFacture : Integer;
begin
  With aQue_Mag do
  begin
    First;
    ado_Reel.BeginTrans;
    try
      while not EOF do
      begin
        if FieldByName('MAG_LEVIS').AsInteger = 1 then
        begin
          if GetCountMAGDATE(FieldByName('MAG_ID').AsInteger,dtp_Date.Date) = 0 then
          begin

            With Ginkoia do
            begin
              Close;
              DatabaseName := FieldByName('MAG_CHEMINBASE').AsString;
              //'C:\Developpement\Ginkoia\Data\SORIN-S2K\GINKOIA.IB';
              Try
                Open;

                IdKvTicket := GetMaxKVersion(-11111423,dtp_Date.Date);
                // Récupération du K_VERSION des bl (lignes)
                IdKvBL  := GetMaxKVersion(-11111425,dtp_Date.Date);
                // Récupération du K_VERSION des factures (lignes)
                IdKvFacture := GetMaxKVersion(-11111429,dtp_Date.Date);

              Except on E:Exception do
                begin
                  ShowMessHP('Erreur de connexion à la base de données : ' + FieldByName('MAG_CHEMINBASE').AsString + ' ' + E.Message,True,0,0,'Connexion');
                end;
              End;
            end; // with

            InsertNewLineHisto(FieldByName('MAG_ID').AsInteger,dtp_Date.Date,3,IdKvTicket,IdKvBL,IdKvFacture)
          end;
        end;
        ProgressBar1.Position := RecNo * 100 Div RecordCount;
        Next;
      end; // while
      ado_Reel.CommitTrans;
    Except on E:Exception do
      ado_Reel.RollbackTrans;
    end;
  end;
end;

PROCEDURE TFrm_Admin.Nbt_MultiClick(Sender: TObject);
VAR
  node: TdxTreeListNode;
  multi:integer;
BEGIN
  multi:=1;
  dxDBGridHP3.BeginUpdate;
  node := dxDBGridHP3.items[0];
  WHILE node <> NIL DO
  BEGIN
    IF node.Selected THEN
    BEGIN
      //showmessage(dxDBGridHP3.GetValueByFieldName(node, 'nom'));

      Tcatal.open;
      IF Tcatal.locate('CAT_nom', dxDBGridHP3.GetValueByFieldName(node, 'nom'), []) THEN
      BEGIN //Attention déjà intégré Question préalable

        IF OuiNonHP('Le catalogue ' + dxDBGridHP3.GetValueByFieldName(node, 'nom') + ' a déjà été intégré.' + #10 + #13 +
          'Souhaitez vous l''intégrer à nouveaux?', false, false, 0, 0) THEN
        BEGIN
          Integration(dxDBGridHP3.GetValueByFieldName(node, 'nom'), multi);
        END
        ELSE
        BEGIN //Annulation de l'intégration
          deletefile(repcat + 'ART_' + dxDBGridHP3.GetValueByFieldName(node, 'nom'));
          deletefile(repcat + 'BAR_' + dxDBGridHP3.GetValueByFieldName(node, 'nom'));
          deletefile(repcat + 'TAI_' + dxDBGridHP3.GetValueByFieldName(node, 'nom'));
          deletefile(repcat + 'FOU_' + dxDBGridHP3.GetValueByFieldName(node, 'nom'));
        END;
      END
      ELSE
        Integration(dxDBGridHP3.GetValueByFieldName(node, 'nom'), multi);

      if multi=1 then multi:=2;
      
      tcatal.close;
      Pgc_CatmanChange(NIL);

    END;

    node := node.getnext;
  END;
  dxDBGridHP3.endupdate;
END;

procedure TFrm_Admin.Nbt_ParametrageClick(Sender: TObject);
begin
if IniCfg.ShowCfgInterface = mrOk then
  ConnexionDb;
end;

procedure TFrm_Admin.Nbt_SelMagClick(Sender: TObject);
var
  iKidBase : Integer;
begin
  With aQue_Mag do
  begin
    ado_Reel.BeginTrans;
    try
      if FieldByName('MAG_LEVIS').AsInteger = 1 then
      begin
          With Ginkoia do
          begin
            Close;
            DatabaseName := FieldByName('MAG_CHEMINBASE').AsString;
            //'C:\Developpement\Ginkoia\Data\SORIN-S2K\GINKOIA.IB';
            Try
              Open;
              iKidBase := GetLastGenID;
            Except on E:Exception do
              begin
                ShowMessHP('Erreur de connexion à la base de données : ' + FieldByName('MAG_CHEMINBASE').AsString + ' ' + E.Message,True,0,0,'Connexion');
                Exit;
              end;
            End;
          end; // with

          InsertNewLineHisto(FieldByName('MAG_ID').AsInteger,dtp_Date.Date,1,iKidBase,iKidBase,iKidBase);
          InsertNewLineHisto(FieldByName('MAG_ID').AsInteger,dtp_Date.Date,2,iKidBase,iKidBase,iKidBase);
          InsertNewLineHisto(FieldByName('MAG_ID').AsInteger,dtp_Date.Date,3,iKidBase,iKidBase,iKidBase);
      end;
      ado_Reel.CommitTrans;
    Except on E:Exception do
      begin
        ado_Reel.RollbackTrans;
        ShowMessage(E.Message);
      end;
    end;
  end;

end;

PROCEDURE TFrm_Admin.Nbt_CancelAfterAction(Sender: TObject;
  VAR Error: Boolean);
BEGIN
  DBG_Magmag_dateactivation.readonly := true;
  DBG_Magmag_dateactivation.showbuttonstyle := sbnone;
  DBG_Magmag_cheminbase.showbuttonstyle := sbnone;
END;

PROCEDURE TFrm_Admin.QmagAfterPost(DataSet: TDataSet);
BEGIN
  IF sendere = 1 THEN EXIT;
  ado.CommitTrans;
  screen.cursor := crdefault;
  DBG_Magmag_dateactivation.readonly := true;
  DBG_Magmag_dateactivation.showbuttonstyle := sbnone;
  DBG_Magmag_cheminbase.showbuttonstyle := sbnone;
  Qmagmag_dateactivation.readonly := false;
END;

PROCEDURE TFrm_Admin.QmagAfterCancel(DataSet: TDataSet);
BEGIN
  DBG_Magmag_dateactivation.readonly := true;
  DBG_Magmag_dateactivation.showbuttonstyle := sbnone;
  DBG_Magmag_cheminbase.showbuttonstyle := sbnone;
  Qmagmag_dateactivation.readonly := false;
END;

PROCEDURE TFrm_Admin.QmagBeforePost(DataSet: TDataSet);
VAR
  guid: STRING;
  retour: boolean;
BEGIN
  IF sendere = 1 THEN EXIT;
  retour := true;
  IF (Qmagmag_actif.asinteger = 1) AND (Qmagmag_dateactivation.asstring = '') THEN
  BEGIN
    InfoMessHP('Validation impossible, si la case "Activation" est cochée,' + #10 + #13 +
      'la date d''activation doit être renseignée...', true, 0, 0);
    abort;
  END;

  ado.BeginTrans;
  //Confirmation
  IF flagdate = 1 THEN
  BEGIN
    IF NOT OuiNonHP('Confirmez vous la date d''activation au ' + datetostr(Qmagmag_dateactivation.asdatetime) + ' ?' + #10 + #13 +
      'Attention cette date ne sera plus modifiable!', false, true, 0, 0) THEN
    BEGIN
      ado.RollbackTrans;
      ABORT;
    END;

    screen.cursor := crsqlwait;

    //Date activation et k mini
    IF NOT InitTHisto(Qmagmag_id.asinteger) THEN
    BEGIN
      InfoMessHP('Validation impossible, K_version mini non trouvé...', true, 0, 0);
      ado.RollbackTrans;
      screen.cursor := crdefault;
      ABORT;
    END;
  END;

  //Test sur GUID
  qdos.close;
  qdos.parameters[0].value := Qmagmag_dosid.asinteger;
  qdos.open;

  IF Qmagmag_cheminbase.asstring <> '' THEN
  BEGIN
    TRY
      ginkoia.databasename := Qmagmag_cheminbase.asstring;
      ginkoia.open;

      //Test Cod adh
      ibc_adh.close;
      ibc_adh.parambyname('adh').asstring := Qmagmag_code.asstring;
      ibc_adh.open;
      IF ibc_adh.eof THEN
      BEGIN // Le code adh n'existe pas dans la base Ginkoia...
        InfoMessHP('Validation impossible, le code adhérent n''existe pas' + #10 + #13 + 'dans la base Ginkoia...', true, 0, 0);
        retour := false;
      END
      ELSE
      BEGIN
        qbase.open;
        guid := qbase.fieldbyname('bas_guid').asstring;
        IF QdosDOS_GUID.asstring <> '' THEN
        BEGIN // Test si guid compatible
          IF guid <> QdosDOS_GUID.asstring THEN
          BEGIN
            InfoMessHP('Validation impossible, GUID incompatible avec le dossier', true, 0, 0);
            retour := false;
          END
        END
        ELSE
        BEGIN
          qdosupdate.close;
          qdosupdate.parameters[0].value := guid;
          qdosupdate.parameters[1].value := Qmagmag_dosid.asinteger;
          qdosupdate.ExecSQL;
          qdosupdate.close;
        END;
      END;
    FINALLY
      ginkoia.close;
      qbase.close;
      qdos.close;
      ibc_adh.close;
    END;

  END;
  IF NOT retour THEN
  BEGIN
    ado.RollbackTrans;
    screen.cursor := crdefault;
    ABORT;
  END;
  flagdate := 0;

END;

procedure TFrm_Admin.dbSBtnEditBeforeAction(Sender: TObject;
  var ActionIsDone: Boolean);
begin
  With aQue_Mag do
  begin
    aQue_MagMAG_DATEACTIVATIONLEVIS.ReadOnly := (DBG_LEVISMAG_DATEACTIVATIONLEVIS.Field.AsDateTime <> 0);
    DBG_LEVISMAG_DATEACTIVATIONLEVIS.ShowButtonStyle := sbDefault;
  end;
end;

PROCEDURE TFrm_Admin.dxDBGridHP1DblClick(Sender: TObject);
BEGIN
  //   VisuHisto(QAlertemag_id.asinteger);
END;

PROCEDURE TFrm_Admin.visuhisto(magid: integer);
BEGIN

  qhisto.sql.clear;
  qhisto.sql.add('select mhi_datedeb,mhi_datefin,mhi_datefin-mhi_datedeb,mhi_kdeb,mhi_kfin,mhi_ok,mhi_info');
  qhisto.sql.add('from magasinhisto where mhi_magid=' + inttostr(magid));
  qhisto.sql.add('order by mhi_datefin desc');
  qhisto.open;

  IF NOT qhisto.eof THEN executehisto(qhisto);
  qhisto.close;

END;

procedure TFrm_Admin.aQue_MagBeforePost(DataSet: TDataSet);
var
  IdKvTicket  ,
  IdKvBL      ,
  IdKvFacture : Integer;
  IdHisto     : Integer;
begin
  //
  ShowMessHPAvi('Enregistrement en cours, veuillez patienter',True,0,0);
  try
    With aQue_Mag do
    begin
      if (FieldByName('MAG_LEVIS').AsInteger = 1) and (FieldByName('MAG_DATEACTIVATIONLEVIS').AsString = '') then
      begin
        InfoMessHP('Validation impossible, si la case "Activation" est cochée,' + #10 + #13 +
          'la date d''activation doit être renseignée...', true, 0, 0);
         abort;
         Exit;
      end;

      if not DBG_LEVISMAG_DATEACTIVATIONLEVIS.ReadOnly then
      begin
        IF NOT OuiNonHP('Confirmez vous la date d''activation au ' + datetostr(FieldByName('MAG_DATEACTIVATIONLEVIS').asdatetime) + ' ?' + #10 + #13 +
          'Attention cette date ne sera plus modifiable!', false, true, 0, 0) THEN
        BEGIN
          Abort;
          Exit;
        END;
      end;

      //  est ce que l'histo levis existe déjà
      With aQue_Tmp do
      begin
        Close;
        SQL.Clear;
        SQL.Add('Select * from MAGASINHISTOLEVIS');
        SQL.Add('Where MHL_MAGID = :PMAGID');
        ParamCheck := True;
        Parameters.ParamByName('PMAGID').Value := aQue_Mag.FieldByName('MAG_ID').AsInteger;
        Open;

        // si on a déja un histo on sort, il ne sert a rien de faire la suite
        IF RecordCount > 0 then
        begin
          Exit;
        end;
      end;

      // Gestion de lhisto Levis
      With Ginkoia do
      begin
        Close;
        DatabaseName := FieldByName('MAG_CHEMINBASE').AsString;
        //'C:\Developpement\Ginkoia\Data\SORIN-S2K\GINKOIA.IB';
        Try
          Open;

          // Récupération du K_VERSION des tickets (lignes)
          IdKvTicket := GetMaxKVersion(-11111423,FieldByName('MAG_DATEACTIVATIONLEVIS').AsDateTime);
          // Récupération du K_VERSION des bl (lignes)
          IdKvBL  := GetMaxKVersion(-11111425,FieldByName('MAG_DATEACTIVATIONLEVIS').AsDateTime);
          // Récupération du K_VERSION des factures (lignes)
          IdKvFacture := GetMaxKVersion(-11111429,FieldByName('MAG_DATEACTIVATIONLEVIS').AsDateTime);
        Except on E:Exception do
          begin
            ShowMessHP('Erreur de connexion à la base de données',True,0,0,'Connexion');
            Abort;
            Exit;
          end;
        End;
      end; // with

      ado_Reel.BeginTrans;
      With aQue_Tmp do
      try
        // Insertion de l'ensemble dans la table histo
        Close;
        SQL.Clear;
        SQL.Add('Insert into MAGASINHISTOLEVIS');
        SQL.Add('(MHL_MAGID,MHL_DATE,MHL_TYP,MHL_OK,MHL_KVERSIONTCK,MHL_KVERSIONNEGBL,MHL_KVERSIONNEGFCT)'); // MHL_ID
        SQL.Add('Values(:PMAGID,:PDATE,:PMHLTYP,:PMHLOK,:PKVERSIONTCK,:PKVERSIONNEGBL,:PKVERSIONNEGFCT)'); // PMHLID
        ParamCheck := True;
        With Parameters do
        begin
//          ParamByName('PMHLID').Value           := IdHisto;
          ParamByName('PMAGID').Value           := aQue_Mag.FieldByName('MAG_ID').AsInteger;
          ParamByName('PDATE').Value            := DateOf(aQue_Mag.FieldByName('MAG_DATEACTIVATIONLEVIS').AsDateTime);
          ParamByName('PMHLTYP').Value          := 0;
          ParamByName('PMHLOK').Value           := 0;
          ParamByName('PKVERSIONTCK').Value     := IdKvTicket;
          ParamByName('PKVERSIONNEGBL').Value   := IdKvBL;
          ParamByName('PKVERSIONNEGFCT').Value  := IdKvFacture;
          ExecSQL;
        end;

        ado_Reel.CommitTrans;

      Except on E:Exception do
        begin
          ado_Reel.RollbackTrans;
          Abort;
          ShowMessHP('Erreur de création de l''histo levis : ' + E.Message,True,0,0,'Insert erreur');
        end;
      end;
    end;
  finally
    ShowCloseHP;
  end;
end;

function TFrm_Admin.ConnexionDb: Boolean;
begin
  ado.Connected := False;
  ado_Reel.Connected := False;
  case IniCfg.Mode of
    0: begin
      ado.ConnectionString := IniCfg.MsSQLConnectionStringAT;
      caption := 'ADIDAS TSL';
    end;
    1: begin
      ado.ConnectionString := IniCfg.MsSQLConnectionStringBT;
      self.caption := '**** BASE TEST ****';
    end;
    2: begin
      ado.ConnectionString := IniCfg.MsSQLConnectionStringBL;
    end;
    3: begin
      ado.ConnectionString := IniCfg.MsSQLConnectionString;
    end;
  end;

  ado_reel.ConnectionString := IniCfg.MsSQLConnectionString;

  ShowMessHPAvi('Connexion au serveur SPORT2000 en cours ...', false, 0, 0, 'Administration CATMAN');
  TRY
    ado.connected := true;
    ado_Reel.Connected := True;
  EXCEPT
    ShowCloseHP;
    InfoMessHP('Problème de connection avec le serveur SPORT2000,' + #10 + #13 +
      'Veuillez vérifier la configuration ou réessayez ultérieurement...', true, 0, 0);

    Nbt_Parametrage.Click;
  END;
  ShowCloseHP;
end;

procedure TFrm_Admin.DBG_LEVISMAG_DATEACTIVATIONLEVISButtonClick(
  Sender: TObject; AbsoluteIndex: Integer);
begin
  With aQue_Mag do
  begin
    IF NOT (state IN [dsedit, dsinsert]) THEN EXIT;
    IF aQue_MagMAG_DATEACTIVATIONLEVIS.readonly THEN EXIT;
    IF lk_coldeb.execute THEN
    BEGIN
      aQue_MagMAG_DATEACTIVATIONLEVIS.asdatetime := QlkColcol_debut.asdatetime;
    END;
  end;
end;

PROCEDURE TFrm_Admin.DBG_MagDblClick(Sender: TObject);
BEGIN
  IF NOT (qmag.state IN [dsedit]) THEN
  BEGIN
    VisuHisto(Qmagmag_id.asinteger);
  END;
END;

PROCEDURE TFrm_Admin.qhistoFilterRecord(DataSet: TDataSet;
  VAR Accept: Boolean);
BEGIN
  //     accept:= Qmagmag_id.asinteger=qhistomhi_magid.asinteger;
END;

PROCEDURE TFrm_Admin.qhistomhi_okGetText(Sender: TField; VAR Text: STRING;
  DisplayText: Boolean);
BEGIN
  IF sender.asboolean THEN
    text := '1'
  ELSE
    text := '0';
END;

PROCEDURE TFrm_Admin.dxDBGridHP3DblClick(Sender: TObject);
BEGIN
  Tcatal.open;
  IF Tcatal.locate('CAT_nom', MemD_Catnom.asstring, []) THEN
  BEGIN //Attention déjà intégré Question préalable

    IF OuiNonHP('Le catalogue ' + MemD_Catnom.asstring + ' a déjà été intégré.' + #10 + #13 +
      'Souhaitez vous l''intégrer à nouveaux?', false, false, 0, 0) THEN
    BEGIN
      Integration(MemD_Catnom.asstring, 0);
    END
    ELSE
    BEGIN //Annulation de l'intégration
      deletefile(repcat + 'ART_' + MemD_Catnom.asstring);
      deletefile(repcat + 'BAR_' + MemD_Catnom.asstring);
      deletefile(repcat + 'TAI_' + MemD_Catnom.asstring);
      deletefile(repcat + 'FOU_' + MemD_Catnom.asstring);
    END;
  END
  ELSE
    Integration(MemD_Catnom.asstring, 0);
  tcatal.close;
  Pgc_CatmanChange(NIL);
END;

PROCEDURE TFrm_Admin.Integration(catal: STRING; multi: integer);
VAR
  Xml: TmonXML;
  passXML: TIcXMLElement;
  passXML2, passXML3, passXML4: TIcXMLElement;
  i: integer;
  tai, itemid, nom: STRING;
  Nb: integer;
  libmarque, cdfedas: STRING;
  flag: boolean;
  y, m, d, H, Mn, S, MS: word;
  catman, first: boolean;
  codetaille, nomtaille: STRING;
  nomet: STRING;
  pc: integer;
  gtf_id: integer;

BEGIN
  catman := true;
  //Attention question préalable pour les cataloges CATMAN
  //IF NOT OuiNonHP('Est ce que le catalogue ' + MemD_Catnom.asstring + ' appartient à CATMAN?', false, false, 0, 0) THEN
  //BEGIN
  //  IF OuiNonHP('Confirmez vous que le catalogue ' + MemD_Catnom.asstring + ' n''appartient pas à CATMAN?' + #10 + #13 +
  //    'Attenion cette opération irréversible!', false, true, 0, 0) THEN
  //    catman := false
  //  ELSE
  //    exit;
  //END;
  IF multi <> 2 THEN
  BEGIN

    catman := true;
    IF NOT lk_col.execute THEN EXIT;

    IF catman THEN
    BEGIN // C'est catalogue Catman, il faut choisir puis la collection, puis la Categ CATMAN

      IF NOT lk_cat.execute THEN EXIT;
      IF multi = 0 THEN
      BEGIN
        IF NOT OuiNonHP('Confirmez vous que le catalogue ' + MemD_Catnom.asstring + ' appartient à CATMAN?' + #10 + #13 +
          'Collection : ' + QColCOL_NOM.asstring + #10 + #13 +
          'Catégorie  : ' + QcatCAT_NOM.asstring + #10 + #13 +
          'Attention cette opération irréversible!', false, true, 0, 0) THEN EXIT;
      END
      ELSE
      BEGIN
        IF NOT OuiNonHP('Confirmez vous que les catalogues sélectionnés appartiennent à CATMAN?' + #10 + #13 +
          'Collection : ' + QColCOL_NOM.asstring + #10 + #13 +
          'Catégorie  : ' + QcatCAT_NOM.asstring + #10 + #13 +
          'Attention cette opération irréversible!', false, true, 0, 0) THEN EXIT;

      END;
    END;

  END;

  screen.cursor := crsqlwait;
  ADO.begintrans;
  TRY

    tcatal.insert;
    tcatal.fieldbyname('CAT_NOM').asstring := catal;
    tcatal.fieldbyname('CAT_DATE').asdatetime := now;
    Tcatal.post;

    //----------------------
    //Les grilles de tailles
    //----------------------

    memd_gt.open;
    memd_tai.open;

    Xml := TmonXML.Create; // création de l'objet TMonXML
    xml.LoadFromFile(repcat + 'TAI_' + catal); // chargement du fichier

    passXML := Xml.find('TAILLE.XML'); // sélection du premier nœud
    passXML2 := xml.FindTag(passxml, 'ITEM');

    //1er passage combien?
    nb := 0;
    WHILE (passXML2 <> NIL) DO
    BEGIN
      nb := nb + 1;
      passXML2 := passXML2.NextSibling;
    END;
    InitGaugeMessHP('Traitement des grilles de taille (' + inttostr(nb) + ')', nb, false, 0, 0);

    //2ieme passage
    passXML2 := xml.FindTag(passxml, 'ITEM');
    WHILE (passXML2 <> NIL) DO
    BEGIN
      IncGaugeMessHP(0);

      //Memorise ITEMID et NOM
      itemid := xml.valuetag(passxml2, 'ITEMID');
      nom := xml.valuetag(passxml2, 'NOM');
      pc := pos('zzzz', nom);
      IF pc <> 0 THEN
      BEGIN
        delete(nom, pc, 4);
        insert('&', nom, pc);
      END;

      //Parcours des tailles
      first := true;
      passXML3 := xml.FindTag(passxml2, 'TAILLES');
      IF passXML3 <> NIL THEN
      BEGIN
        passXML4 := xml.FindTag(passxml3, 'TAILLE');
        WHILE (passXML4 <> NIL) DO
        BEGIN
          codetaille := xml.valueTag(passxml4, 'CODETAILLE');
          nomtaille := xml.valueTag(passxml4, 'NOM');

          IF first THEN
          BEGIN
            //Recherche si entete existe pour première taille
            IF NOT Q_EntIDref.active THEN Q_EntIDref.open;
            //                        Q_EntIDref.close;
            //                        Q_EntIDref.parameters.parambyname('tgf_idref').value := codetaille;
            //                        q_EntIDref.open;
            IF NOT Q_EntIDref.locate('tgf_idref', codetaille, []) THEN
            BEGIN //Faut créer l'entete de la GT
              T.parameters.parambyname('@gtf_nom').value := NOM;
              T.parameters.parambyname('@gtf_fedid').value := 0;
              T.parameters.parambyname('@gtf_idref').value := 0;
              T.parameters.parambyname('@gtf_id').value := 0;
              T.Execproc;

              //Memo du itemid
              memd_gt.insert;
              MemD_GTITEMID.asstring := ItemID;
              MemD_GTGTFID.asinteger := T.parameters[3].value;
              memd_gt.post;
            END
            ELSE
            BEGIN
              memd_gt.insert;
              MemD_GTITEMID.asstring := ItemID;
              MemD_GTGTFID.asinteger := q_EntIDref.fieldbyname('tgf_gtfid').asinteger;
              memd_gt.post;
            END;
            first := false;
          END;

          //Test si ligne existe
          IF codetaille <> '' THEN
          BEGIN
            //                        Q_TL.close;
            //                        Q_TL.parameters.parambyname('tgf_idref').value := codetaille;
            //                        q_TL.open;
            IF NOT q_tl.active THEN q_tl.open;
            IF NOT q_tl.locate('tgf_idref', codetaille, []) THEN
            BEGIN
              TL.parameters.parambyname('@tgf_gtfid').value := MemD_GTGTFID.asinteger;
              TL.parameters.parambyname('@tgf_nom').value := nomtaille;
              TL.parameters.parambyname('@tgf_ordreaff').value := 0;
              TL.parameters.parambyname('@tgf_idref').value := codetaille;
              TL.parameters.parambyname('@tgf_id').value := 0;
              TL.Execproc;
              q_tl.close;
              q_tl.open;
              Q_EntIDref.close;
              Q_EntIDref.open;
            END;
          END;

          passXML4 := passXML4.NextSibling;
        END;
      END;

      passXML2 := passXML2.NextSibling;
    END;
    CloseGaugeMessHP;
    xml.free;
    ADO.committrans;

    //On charges toutes les tailles ayant un idref dans la base
    Qtref.open;

    ADO.begintrans;

    //----------------------
    //Les articles
    //----------------------
    Xml := TmonXML.Create; // création de l'objet TMonXML
    xml.LoadFromFile(repcat + 'ART_' + catal); // chargement du fichier

    marque.open;
    memd_art.open;
    memd_cou.open;
    memd_pbl.open;

    passXML := Xml.find('ARTICLE.XML'); // sélection du premier nœud

    //1er passage combien?
    passXML2 := xml.FindTag(passxml, 'ITEM');
    nb := 0;
    WHILE (passXML2 <> NIL) DO
    BEGIN
      nb := nb + 1;
      passXML2 := passXML2.NextSibling;
    END;
    InitGaugeMessHP('Traitement des articles (' + inttostr(nb) + ')', nb, false, 0, 0);

    passXML2 := xml.FindTag(passxml, 'ITEM');
    WHILE (passXML2 <> NIL) DO
    BEGIN
      IncGaugeMessHP(0);

      IF memd_gt.locate('itemid', xml.valuetag(passxml2, 'CTAI'), []) THEN
      BEGIN
        nomet := xml.valuetag(passxml2, 'LIBFRS'); //xml.valuetag(passxml2, 'LIBELLE');
        pc := pos('zzzz', nomet);
        IF pc <> 0 THEN
        BEGIN
          delete(nomet, pc, 4);
          insert('&', nomet, pc);
        END;
        article.parameters.parambyname('@art_nom').value := nomet;

        article.parameters.parambyname('@art_description').value := '';

        article.parameters.parambyname('@art_GTFID').value := MemD_GTGTFID.asinteger;

        article.parameters.parambyname('@ART_REFMRK').value := xml.valuetag(passxml2, 'RFOU');

        libmarque := xml.valuetag(passxml2, 'MARQUE');
        libmarque := uppercase(libmarque);
        IF NOT marque.locate('mrk_nom', libmarque, []) THEN
        BEGIN
          marque.insert;
          MARQUEMRK_NOM.asstring := (libmarque);
          marque.post;
        END;

        article.parameters.parambyname('@art_MRKID').value := MARQUEMRK_ID.asinteger;

        //Fedas
        cdfedas := xml.valuetag(passxml2, 'FEDAS');
        que_fedas.close;
        que_fedas.sql.clear;
        que_fedas.sql.text := 'exec idfedas @code=' + cdfedas;
        que_fedas.open;

        article.parameters.parambyname('@art_FEDID1').value := que_fedas.fields[0].asinteger;
        article.parameters.parambyname('@art_FEDID2').value := que_fedas.fields[2].asinteger;
        article.parameters.parambyname('@art_FEDID3').value := que_fedas.fields[4].asinteger;
        article.parameters.parambyname('@art_FEDID4').value := que_fedas.fields[6].asinteger;

        que_fedas.close;
        //Fin fedas

        article.parameters.parambyname('@ART_PABRUT').value := strtofloat(xml.valuetag(passxml2, 'PA')) / 100;
        article.parameters.parambyname('@ART_PA').value := strtofloat(xml.valuetag(passxml2, 'PANET')) / 100;
        article.parameters.parambyname('@ART_PV').value := strtofloat(xml.valuetag(passxml2, 'PV')) / 100;
        article.parameters.parambyname('@ART_REASSORT').value := 0;
        article.parameters.parambyname('@ART_ARCHIVER').value := 0;
        article.parameters.parambyname('@ART_CATMAN').value := strtoint(xml.valuetag(passxml2, 'CATMAN'));
        IF catman THEN
          article.parameters.parambyname('@art_catid').value := QcatCAT_ID.asinteger
        ELSE
          article.parameters.parambyname('@art_catid').value := 0;
        article.parameters.parambyname('@art_id').value := 0;
        article.Execproc;

        memd_art.insert;
        MemD_ARTITEMID.asstring := xml.valuetag(passxml2, 'ITEMID');
        MemD_ARTART_ID.asinteger := article.parameters[17].value;
        MemD_ARTGTITEMID.asstring := xml.valuetag(passxml2, 'CTAI');
        memd_art.post;

        //Collection
        collec.parameters[0].value := article.parameters[17].value;
        collec.parameters[1].value := QColCOL_ID.asinteger;
        collec.ExecSQL;

        //Couleurs
        passXML3 := xml.FindTag(passxml2, 'COULEURS');
        IF passXML3 <> NIL THEN
        BEGIN
          passXML4 := xml.FindTag(passxml3, 'COULEUR');
          WHILE (passXML4 <> NIL) DO
          BEGIN

            COULEUR.parameters.parambyname('@COU_ARTID').value := article.parameters[17].value;
            COULEUR.parameters.parambyname('@COU_CODE').value := xml.valueTag(passxml4, 'CODECOLORIS');
            COULEUR.parameters.parambyname('@COU_NOM').value := xml.valueTag(passxml4, 'DESCRIPTIF');
            COULEUR.parameters.parambyname('@COU_IDREF').value := xml.valueTag(passxml4, 'IDCOLORIS');
            COULEUR.parameters.parambyname('@COU_CATMAN').value := 1;
            COULEUR.parameters.parambyname('@COU_PERM').value := 0;
            COULEUR.parameters.parambyname('@COU_id').value := 0;
            couleur.Execproc;

            memd_cou.insert;
            MemD_CouCODE.asstring := xml.valueTag(passxml4, 'IDCOLORIS');
            MemD_CouCOU_ID.asinteger := couleur.parameters[4].value;
            MemD_CouITEMID.asstring := xml.valuetag(passxml2, 'ITEMID');
            memd_cou.post;
            passXML4 := passXML4.NextSibling;
          END;
        END;

        cl.parameters.parambyname('@CAL_CATID').value := TcatalCAT_ID.asinteger;
        cl.parameters.parambyname('@CAL_ARTID').value := article.parameters[17].value;
        cl.Execproc;
      END
      ELSE
      BEGIN //Article rejeté
        memd_pbl.insert;
        MemD_PblITEMID.asstring := xml.valuetag(passxml2, 'ITEMID');
        MemD_PblMOTIF.asstring := 'ARTICLE : GRILLE TAILLE NON TROUVEE';
        MemD_PblIDRECHERCHE.asstring := xml.valuetag(passxml2, 'CTAI');
        memd_pbl.post;

      END;
      passXML2 := passXML2.NextSibling;
    END;
    xml.free;
    CloseGaugeMessHP;

    //----------------------
    //Les Code barre
    //----------------------

    Xml := TmonXML.Create; // création de l'objet TMonXML
    xml.LoadFromFile(repcat + 'BAR_' + catal); // chargement du fichier
    passXML := Xml.find('BARFOU.XML'); // sélection du premier nœud

    //1er passage combien?
    passXML2 := xml.FindTag(passxml, 'ITEM');
    nb := 0;
    WHILE (passXML2 <> NIL) DO
    BEGIN
      nb := nb + 1;
      passXML2 := passXML2.NextSibling;
    END;
    InitGaugeMessHP('Traitement des codes barres (' + inttostr(nb) + ')', nb, false, 0, 0);

    passXML2 := xml.FindTag(passxml, 'ITEM');
    WHILE (passXML2 <> NIL) DO
    BEGIN
      IncGaugeMessHP(0);
      Flag := true;
      //Recherche article
      IF NOT memd_art.locate('ITEMID', xml.valuetag(passxml2, 'ARTICLEID'), []) THEN
      BEGIN
        //                memd_pbl.insert;
        //                MemD_PblITEMID.asstring := xml.valuetag(passxml2, 'ITEMID');
        //                MemD_PblMOTIF.asstring := 'CB : ARTICLE NON TROUVE';
        //                MemD_PblIDRECHERCHE.asstring := xml.valuetag(passxml2, 'ARTICLEID');
        //                memd_pbl.post;
        flag := false;
      END;

      IF flag THEN
      BEGIN
        IF (NOT memd_cou.locate('ITEMID;CODE', vararrayOF([MemD_ARTITEMID.asstring, xml.valuetag(passxml2, 'IDCOLORIS')]), [])) THEN
        BEGIN
          memd_pbl.insert;
          MemD_PblITEMID.asstring := xml.valuetag(passxml2, 'ITEMID');
          MemD_PblMOTIF.asstring := 'CB : ARTICLE / COULEUR NON TROUVE';
          MemD_PblIDRECHERCHE.asstring := MemD_ARTITEMID.asstring + ' / ' + xml.valuetag(passxml2, 'IDCOLORIS');
          memd_pbl.post;
          flag := false;
        END;
        //IF NOT memd_tai.locate('LIBGT;LIBTAIL', vararrayOF([MemD_ARTGTITEMID.asstring, xml.valuetag(passxml2, 'LTAI')]), []) THEN
        IF (NOT qtref.locate('TGF_IDREF', xml.valuetag(passxml2, 'CODETAILLE'), [])) THEN
        BEGIN
          //                    memd_pbl.insert;
          //                    MemD_PblITEMID.asstring := xml.valuetag(passxml2, 'ITEMID');
          //                    MemD_PblMOTIF.asstring := 'CB : GRILLE TAILLE / TAILLE NON TROUVE';
          //                    MemD_PblIDRECHERCHE.asstring := MemD_ARTGTITEMID.asstring + ' / ' + xml.valuetag(passxml2, 'CODETAILLE');
          //                    memd_pbl.post;
          flag := false;
        END;
        IF flag THEN
        BEGIN
          cb.parameters.parambyname('@CBI_ARTID').value := MemD_ARTART_ID.asinteger;
          cb.parameters.parambyname('@CBI_COUID').value := MemD_CouCOU_ID.asinteger;
          cb.parameters.parambyname('@CBI_TGFID').value := qtref.fieldbyname('tgf_id').asinteger; //MemD_TaiTGF_ID.asinteger;
          cb.parameters.parambyname('@CBI_CB').value := xml.valuetag(passxml2, 'BARRE');
          cb.Execproc;
        END;
      END;
      passXML2 := passXML2.NextSibling;
    END;
    xml.free;
    CloseGaugeMessHP;

    IF memd_pbl.recordcount <> 0 THEN
    BEGIN //Intégration avec PBL

      DecodeDate(now, Y, M, D);
      DecodeTime(Time, H, Mn, S, MS);
      Nom := inttostr(y) + inttostr(m) + inttostr(d) + ' ' + inttostr(H) + inttostr(Mn) + inttostr(S) + '.txt';

      memd_pbl.SaveToTextFile(repcat + 'PROBLEME\' + catal + ' ' + nom);
      InfoMessHP('Intégration du catalogue impossible.' + #10 + #13 +
        'Consultez le rapport : ' + nom, false, 0, 0);

      ADO.rollbacktrans;

      movefileex(pchar(repcat + 'ART_' + catal), pchar(repcat + 'probleme\ART_' + catal), MOVEFILE_REPLACE_EXISTING);
      movefileex(pchar(repcat + 'BAR_' + catal), pchar(repcat + 'probleme\BAR_' + catal), MOVEFILE_REPLACE_EXISTING);
      movefileex(pchar(repcat + 'TAI_' + catal), pchar(repcat + 'probleme\TAI_' + catal), MOVEFILE_REPLACE_EXISTING);
      movefileex(pchar(repcat + 'FOU_' + catal), pchar(repcat + 'probleme\FOU_' + catal), MOVEFILE_REPLACE_EXISTING);
    END
    ELSE
    BEGIN

      movefileex(pchar(repcat + 'ART_' + catal), pchar(repcat + 'integre\ART_' + catal), MOVEFILE_REPLACE_EXISTING);
      movefileex(pchar(repcat + 'BAR_' + catal), pchar(repcat + 'integre\BAR_' + catal), MOVEFILE_REPLACE_EXISTING);
      movefileex(pchar(repcat + 'TAI_' + catal), pchar(repcat + 'integre\TAI_' + catal), MOVEFILE_REPLACE_EXISTING);
      movefileex(pchar(repcat + 'FOU_' + catal), pchar(repcat + 'integre\FOU_' + catal), MOVEFILE_REPLACE_EXISTING);
      ADO.committrans;

    END;

  EXCEPT
    ADO.rollbacktrans;
    MessageDlg('Erreur', mtWarning, [], 0);
  END;
  memd_gt.close;
  memd_tai.close;
  memd_art.close;
  screen.cursor := crdefault;
  article.close;
  marque.close;
  couleur.close;
  t.close;
  tl.close;
  memd_cou.close;
  memd_art.close;
  memd_pbl.close;

END;

PROCEDURE TFrm_Admin.Nbt_IntegIndicGenClick(Sender: TObject);
VAR
  repind: STRING;
BEGIN
  IF ODI.Execute THEN
  BEGIN
    // Sélection de la collection
    IF lk_col.execute THEN
    BEGIN
      //Suppression de tous les indicateurs de la col sélectionnées
      ADO.begintrans;

      ShowMessHPAvi('Traitement des indicateurs en cours ...', false, 0, 0, 'Administration CATMAN');

      supind.commandtext := 'update indicateursgeneraux set ing_enabled=0,ing_deleted=' + #39 + datetimetostr(now) + #39 +
        ' where ing_enabled=1 and ing_colid=' + inttostr(QColCOL_ID.asinteger);
      supind.Execute;
      memd_indic.DelimiterChar := ';';
      memd_indic.LoadFromTextFile(ODI.files[0]);

      tcateg.open;
      tind.open;
      qcm.open;
      memd_indic.first;
      WHILE NOT memd_indic.eof DO
      BEGIN

        IF (tcateg.locate('CAT_NOM', uppercase(MemD_INDICCATEGORIE.asstring), [loCaseInsensitive])) OR
          (MemD_INDICCATEGORIE.asstring = 'GLOBAL') THEN
        BEGIN //Recherche de la Catégorie
          IF (qcm.locate('mrk_nom', uppercase(MemD_INDICMARQUE.asstring), [loCaseInsensitive])) OR
            (MemD_INDICMARQUE.asstring = 'GLOBAL') THEN
          BEGIN
            Tind.append;
            TIndING_COLID.asinteger := QColCOL_ID.asinteger;

            IF (uppercase(MemD_INDICCATEGORIE.asstring) = 'GLOBAL') THEN
              TIndING_CATID.asinteger := 0
            ELSE
              TIndING_CATID.asinteger := TcategCAT_ID.asinteger;

            IF (uppercase(MemD_INDICMARQUE.asstring) = 'GLOBAL') THEN
              TIndING_MRKID.asinteger := 0
            ELSE
              TIndING_MRKID.asinteger := QCMmrk_id.asinteger;

            TIndING_TYPID.asinteger := MemD_INDICTYPE.asinteger;
            TIndING_MOIS.asstring := MemD_INDICMOIS.asstring;
            TIndING_DEBUT.asfloat := MemD_INDICDEBUT.asfloat;
            TIndING_FIN.asfloat := MemD_INDICFIN.asfloat;
            TIndING_COUL.asinteger := 0;
            IF MemD_INDICCOULEUR.asstring = 'R' THEN TIndING_COUL.asinteger := 1;
            IF MemD_INDICCOULEUR.asstring = 'O' THEN TIndING_COUL.asinteger := 2;
            IF MemD_INDICCOULEUR.asstring = 'V' THEN TIndING_COUL.asinteger := 3;
            TIndING_ENABLED.asinteger := 1;
            TInd.post;
          END
          ELSE
          BEGIN
            ShowCloseHP;
            ADO.rollbacktrans;
            InfoMessHP('Intégration impossible, la marque ' + MemD_INDICMARQUE.asstring + #10 + #13 +
              'n'' est pa liée à une catégorie Catman...', false, 0, 0);
            tcateg.close;
            tind.close;
            qcm.close;
            memd_indic.close;
            EXIT;
          END;
        END
        ELSE
        BEGIN
          ShowCloseHP;
          ADO.rollbacktrans;
          InfoMessHP('Intégration impossible, la catégorie ' + MemD_INDICCATEGORIE.asstring + ' n'' existe pas...', false, 0, 0);
          tcateg.close;
          tind.close;
          qcm.close;
          memd_indic.close;
          EXIT;

        END;
        memd_indic.next;
      END;

      Ado.committrans;
      ShowCloseHP;
      tcateg.close;
      tind.close;
      qcm.close;
      memd_indic.close;
    END;
  END;
END;

PROCEDURE TFrm_Admin.Nbt_IntegNewMagClick(Sender: TObject);
VAR
  retour: boolean;
  i: integer;
BEGIN
  retour := true;
  IF ODI.Execute THEN
  BEGIN
    ShowMessHPAvi('Intégration des magasins en  cours ...', false, 0, 0, 'Administration CATMAN');
    memd_maga.DelimiterChar := ';';
    memd_maga.LoadFromTextFile(ODI.files[0]);
    ADO.begintrans;
    tregion.open;
    Tmag.open;
    tdossier.open;
    ttym.open;
    memd_maga.first;

    qcol.open;
    tim.open;
    Qcc.open;
    WHILE NOT memd_maga.eof DO
    BEGIN

      //Table Dossiers
      IF NOT tdossier.locate('dos_nom', MemD_MagaDOSSIER.asstring, [loCaseInsensitive]) THEN
      BEGIN
        tdossier.insert;
        TdossierDOS_NOM.asstring := MemD_MagaDOSSIER.asstring;
        TdossierDOS_ENABLED.asinteger := 1;
        tdossier.post;
      END;
      IF (MemD_MagaREGION.asstring <> '') AND (NOT tregion.locate('REG_NOM', uppercase(MemD_MagaREGION.asstring), [loCaseInsensitive])) THEN
      BEGIN
        InfoMessHP('Intégration impossible, la région ' + MemD_MagaREGION.asstring + ' n'' existe pas...', false, 0, 0);
        retour := false;
        BREAK;
      END;

      //Tables magasins
      IF NOT tmag.locate('MAG_CODE', MemD_MagaCODE.asstring, []) THEN
      BEGIN
        Tmag.insert;
        TmagMAG_DOSID.asinteger := TdossierDOS_ID.asinteger;
        TmagMAG_REGID.asinteger := TregionREG_ID.asinteger;
        TmagMAG_CODE.asstring := MemD_MagaCODE.asstring;
        TmagMAG_NOM.asstring := MemD_MagaNOM.asstring;
        TmagMAG_VILLE.asstring := MemD_MagaVILLE.asstring;
        TmagMAG_DIRECTEUR.asstring := memd_magaDIRECTEUR.asstring;
        TmagMAG_ENABLED.asinteger := 1;
        TmagMAG_X.asinteger := 0;
        TmagMAG_Y.asinteger := 0;
        TmagMAG_TYMID.asinteger := 1; // TTYMTYM_ID.asinteger;
        TmagMAG_CHEMINBASE.asstring := MemD_MagaCHEMIN.asstring;
        IF (self.caption = 'ADIDAS TSL') THEN //Spécial RSM
        BEGIN
          TmagMAG_DATEACTIVATION.asdatetime := now;
        END;

        Tmag.post;
      END
      ELSE
      BEGIN
        IF TmagMAG_ENABLED.asinteger = 0 THEN
        BEGIN
          tmag.edit;
          TmagMAG_ENABLED.asinteger := 1;
          IF (self.caption = 'ADIDAS TSL') THEN TmagMAG_DATEACTIVATION.asdatetime := now;
          tmag.post;
        END;
      END;
      memd_maga.next;
    END;

    IF retour THEN //Tout est OK
      Ado.committrans
    ELSE //Intégration impossible
      ADO.rollbacktrans;

    //        tregion.close;
    //        Tmag.close;
    //        tdossier.close;
    //        ttym.close;
    //        memd_mag.close;
    //        qcol.close;
    //        tim.close;
    //        Qcc.close;
    ShowCloseHP;
  END
END;

PROCEDURE TFrm_Admin.DBG_Magmag_dateactivationButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
BEGIN
  IF NOT (qmag.state IN [dsedit, dsinsert]) THEN EXIT;
  IF Qmagmag_dateactivation.readonly THEN EXIT;
  IF lk_coldeb.execute THEN
  BEGIN
    Qmagmag_dateactivation.asdatetime := QlkColcol_debut.asdatetime;
    flagdate := 1;
  END

END;

FUNCTION TFrm_Admin.InitTHisto(mag_id: integer): boolean;
VAR
  plage, kplage: STRING;
  pos, k, i: integer;

BEGIN
  result := true;
  IF Qmagmag_dateactivation.asdatetime = 0 THEN EXIT;
  IF Qmagmag_cheminbase.asstring <> '' THEN
  BEGIN
    TRY
      ginkoia.databasename := Qmagmag_cheminbase.asstring;
      ginkoia.open;
      ibc_plage.open;
      plage := ibc_plage.fieldbyname('bas_plage').asstring;
      kplage := '';
      pos := 2;
      WHILE plage[pos] <> 'M' DO
      BEGIN
        kplage := kplage + plage[pos];
        pos := pos + 1
      END;
      k := strtoint(kplage);
      k := k * 1000000;

      ShowMessHPAvi('Recherche du k_version mini...', false, 0, 0, 'Administration CATMAN');
      ib_kmin.parambyname('dtactiv').asdatetime := Qmagmag_dateactivation.asdatetime;
      ib_kmin.parambyname('kplage').asinteger := k;
      ib_kmin.open;
      ShowCloseHP;

      FOR i := 1 TO 10 DO
      BEGIN
        qinit.commandtext := 'Insert into magasinhisto values(' + Qmagmag_id.asstring + ',0,' +
          ib_kmin.fields[0].asstring + ',current_timestamp,current_timestamp,' +
          #39 + 'T' + inttostr(i) + ' Initialisation' + #39 + ',1,' + inttostr(i) + ',0)';
        qinit.Execute;
      END;

    EXCEPT
      ShowCloseHP;
      result := false;
    END;
  END
  ELSE
    result := false;

  ginkoia.close;
END;

function TFrm_Admin.InsertNewLineHisto(MHL_MAGID: Integer; MHL_DATE: TDate;
  MHL_TYP, MHL_KVSTK, MHL_KVNEGBL, MHL_KVNEGFCT: Integer): Boolean;
begin
  Result := True;
  With aQue_Tmp do
  try
    Close;
    SQL.Clear;
    SQL.Add('Insert into MAGASINHISTOLEVIS');
    SQL.Add('(MHL_MAGID,MHL_DATE,MHL_TYP,MHL_OK,MHL_KVERSIONTCK,MHL_KVERSIONNEGBL,MHL_KVERSIONNEGFCT)'); // MHL_ID
    SQL.Add('Values(:PMAGID,:PDATE,:PMHLTYP,:PMHLOK,:PKVERSIONTCK,:PKVERSIONNEGBL,:PKVERSIONNEGFCT)'); // PMHLID
    ParamCheck := True;
    With Parameters do
    begin
      ParamByName('PMAGID').Value           := MHL_MAGID;
      ParamByName('PDATE').Value            := DateOf(MHL_DATE);
      ParamByName('PMHLTYP').Value          := MHL_TYP;
      ParamByName('PMHLOK').Value           := 1;
      ParamByName('PKVERSIONTCK').Value     := MHL_KVSTK;
      ParamByName('PKVERSIONNEGBL').Value   := MHL_KVNEGBL;
      ParamByName('PKVERSIONNEGFCT').Value  := MHL_KVNEGFCT;
      ExecSQL;
    end;
  Except on E:Exception do
    Result := False;
  end;
end;

PROCEDURE TFrm_Admin.QmagBeforeEdit(DataSet: TDataSet);
BEGIN
  flagdate := 0;
END;

PROCEDURE TFrm_Admin.QmagBeforeInsert(DataSet: TDataSet);
BEGIN
  flagdate := 0;
END;

PROCEDURE TFrm_Admin.LMDSpeedButton4Click(Sender: TObject);
VAR
  text: STRING;
BEGIN
  ginkoia.databasename := Qmagmag_cheminbase.asstring;
  ginkoia.open;
  ib_control.close;
  ib_control.parambyname('codeadh').asstring := Qmagmag_code.asstring;
  ib_control.open;

  ib_control.first;
  text := '';
  WHILE NOT ib_control.eof DO
  BEGIN
    text := text + ib_control.fieldbyname('mrk').asstring + ' ' + ib_control.fieldbyname('val').asstring + #10 + #13;
    ib_control.next
  END;

  ginkoia.close;
  MessageDlg(text, mtWarning, [], 0);
END;

PROCEDURE TFrm_Admin.Nbt_RegulPxNetClick(Sender: TObject);
BEGIN
  memd_regul.DelimiterChar := ';';
  //    memd_regul.LoadFromTextFile('D:\ControleReplication\Admin CATMAN\TEMP\total.csv');   //c:\catman\tp\
  memd_regul.LoadFromTextFile('c:\catman\tp\total.csv');

  memd_regul.first;
  InitGaugeMessHP('recherche', 835, false, 0, 0);

  WHILE NOT memd_regul.eof DO
  BEGIN
    IncGaugeMessHP(0);
    qr.close;
    qr.parameters.parambyname('art_nom').value := MemD_RegulDesi.asstring;
    qr.parameters.parambyname('mrk_nom').value := MemD_RegulNomF.asstring;
    qr.parameters.parambyname('art_refmrk').value := MemD_RegulRef.asstring;
    qr.parameters.parambyname('gtf_nom').value := MemD_RegulGT.asstring;
    qr.open;

    qpx.parameters.parambyname('artid').value := qr.fieldbyname('art_id').asinteger;
    qpx.parameters.parambyname('pa').value := MemD_RegulPAN.asfloat;
    qpx.ExecSQL;
    //         IF  (qr.fieldbyname('nbr').asinteger<>1) then
    //         MessageDlg(MemD_RegulDesi.asstring+#10+#13+MemD_RegulNomF.asstring+#10+#13+MemD_RegulRef.asstring+#10+#13+MemD_RegulGT.asstring+#10+#13+inttostr(qr.fieldbyname('nbr').asinteger), mtWarning, [], 0);

    memd_regul.next;
  END;
  CloseGaugeMessHP;
END;

PROCEDURE TFrm_Admin.LMDSpeedButton6Click(Sender: TObject);
BEGIN
  IF NOT OuiNonHP('Attention cette opération dédruit l''historique du dossier en cours!!!' + #10 + #13 +
    'Validez vous la destruction des données?', false, false, 0, 0) THEN EXIT;

  IF NOT OuiNonHP('Confirmez vous la destruction des données?' + #10 + #13 +
    'Attention cette opération irréversible!', false, true, 0, 0) THEN EXIT;

  ShowMessHPAvi('Destruction des données en cours ...', false, 0, 0, 'Administration CATMAN');
  Vide.parameters.parambyname('@dosid').value := Qmagmag_dosid.asinteger;
  Vide.Execproc;
  ShowCloseHP;

END;

PROCEDURE TFrm_Admin.Nbt_ArticleRSMClick(Sender: TObject);
VAR
  art_id, gtf_id, i: integer;
BEGIN
  //    memd_tsl.DelimiterChar := ';';
  //    memd_tsl.LoadFromTextFile('c:\catman\tp\article_tsl.csv');
  //    memd_tsl.first;
  //
  //    InitGaugeMessHP('Intégration TSL', memd_tsl.recordcount, false, 0, 0);
  //    WHILE NOT memd_tsl.eof DO
  //    BEGIN
  //        IncGaugeMessHP(0);
  //
  //        //Insert article
  //        tsl_article.close;
  //        tsl_article.parameters.parambyname('ARTCODE').value := MemD_TslART_CODE.asstring;
  //        tsl_article.open;
  //
  //        IF tsl_article.eof THEN
  //        BEGIN
  //            i := 1;
  //            //Création de l'entete GT
  //            T.parameters.parambyname('@gtf_nom').value := MemD_TslART_CODE.asstring;
  //            T.parameters.parambyname('@gtf_fedid').value := 0;
  //            T.parameters.parambyname('@gtf_idref').value := 0;
  //            T.parameters.parambyname('@gtf_id').value := 0;
  //            T.Execproc;
  //            gtf_id := T.parameters[3].value;
  //
  //            //Création de la fiche article
  //            article.parameters.parambyname('@art_nom').value := MemD_TslART_NOM.asstring;
  //            article.parameters.parambyname('@art_description').value := '';
  //            article.parameters.parambyname('@art_GTFID').value := T.parameters[3].value;
  //            article.parameters.parambyname('@ART_REFMRK').value := MemD_TslART_CODE.asstring;
  //            article.parameters.parambyname('@art_MRKID').value := 3189;
  //            article.parameters.parambyname('@art_FEDID1').value := 0;
  //            article.parameters.parambyname('@art_FEDID2').value := 0;
  //            article.parameters.parambyname('@art_FEDID3').value := 0;
  //            article.parameters.parambyname('@art_FEDID4').value := 0;
  //            article.parameters.parambyname('@ART_PABRUT').value := 0;
  //            article.parameters.parambyname('@ART_PA').value := 0;
  //            article.parameters.parambyname('@ART_PV').value := 0;
  //            article.parameters.parambyname('@ART_REASSORT').value := 0;
  //            article.parameters.parambyname('@ART_ARCHIVER').value := 0;
  //            article.parameters.parambyname('@ART_CATMAN').value := 0;
  //            article.parameters.parambyname('@art_catid').value := 0;
  //            article.parameters.parambyname('@art_id').value := 0;
  //            article.Execproc;
  //            art_id := article.parameters[17].value;
  //        END
  //        ELSE
  //        BEGIN
  //            tsl_gtf.close;
  //            tsl_gtf.parameters.parambyname('GTFNOM').value := MemD_TslART_CODE.asstring;
  //            tsl_gtf.open;
  //            gtf_id := tsl_gtf.fieldbyname('gtf_id').asinteger;
  //            art_id := tsl_article.fieldbyname('art_id').asinteger;
  //        END;
  //
  //        //Insert taille ligne
  //        TL.parameters.parambyname('@TGF_GTFID').value := gtf_id;
  //        TL.parameters.parambyname('@TGF_NOM').value := MemD_TslTGF_NOM.asstring;
  //        TL.parameters.parambyname('@TGF_ORDREAFF').value := i * 100;
  //        TL.parameters.parambyname('@TGF_IDREF').value := 0;
  //        TL.parameters.parambyname('@TGF_id').value := 0;
  //        TL.Execproc;
  //
  //        //Insert artcollec
  //        collec.parameters[0].value := art_id;
  //        collec.parameters[1].value := 2;
  //        collec.ExecSQL;
  //
  //        //Insert codebarre
  //        cb.parameters.parambyname('@CBI_ARTID').value := art_id;
  //        cb.parameters.parambyname('@CBI_COUID').value := 0;
  //        cb.parameters.parambyname('@CBI_TGFID').value := tl.parameters[4].value;
  //        cb.parameters.parambyname('@CBI_CB').value := MemD_TslCBI_CB.asstring;
  //        cb.Execproc;
  //
  //        memd_tsl.next;
  //    END;
  //    CloseGaugeMessHP;

  IF NOT ODI.Execute THEN EXIT;

  memd_tsl.DelimiterChar := ';';
  memd_tsl.LoadFromTextFile(ODI.files[0]);
  memd_tsl.first;

  InitGaugeMessHP('Intégration TSL', memd_tsl.recordcount, false, 0, 0);

  rsm.open;
  WHILE NOT memd_tsl.eof DO
  BEGIN
    IncGaugeMessHP(0);
    rsm.append;
    RSMRSM_CODE.asstring := MemD_TslCODE.asstring;
    RSMRSM_LIB.asstring := MemD_TslLIB.asstring;
    RSMRSM_TAILLE.asstring := MemD_TslTAILLE.asstring;
    RSMRSM_EAN.asstring := MemD_TslEAN.asstring;
    rsm.post;
    memd_tsl.next;
  END;
  rsm.close;
  CloseGaugeMessHP;

END;

PROCEDURE TFrm_Admin.Nbt_IndicMagClick(Sender: TObject);

VAR
  retour: boolean;
  i: integer;
BEGIN
  retour := true;
  IF ODI.Execute THEN
  BEGIN
    ShowMessHPAvi('Intégration des Indicateurs magasins en  cours ...', false, 0, 0, 'Administration CATMAN');
    memd_mag.DelimiterChar := ';';
    memd_mag.LoadFromTextFile(ODI.files[0]);
    ADO.begintrans;
    Tmag.open;

    memd_mag.first;

    qcol.open;
    tim.open;
    Qcc.open;
    WHILE NOT memd_mag.eof DO
    BEGIN

      //Locate du bon magasin
      IF tmag.locate('mag_code', MemD_MagCODE.asstring, []) THEN
      BEGIN

        //Table Indicateur magasin
        IF NOT qcol.locate('COL_NOM', MemD_MagCOLLECTION.asstring, [loCaseInsensitive]) THEN
        BEGIN
          InfoMessHP('Intégration impossible, la collection ' + MemD_MagCOLLECTION.asstring + ' n'' existe pas...', false, 0, 0);
          retour := false;
          BREAK;
        END;

        //Couple categ marque
        FOR i := 1 TO MemD_MagNBCAT.asinteger DO
        BEGIN
          IF NOT qcc.locate('mrk_nom;cat_nom', vararrayOF([memd_mag.fieldbyname('MARQUE' + inttostr(i)).asstring, memd_mag.fieldbyname('CATEG' + inttostr(i)).asstring]), []) THEN
          BEGIN
            InfoMessHP('Intégration impossible, la MARQUE ' + memd_mag.fieldbyname('MARQUE' + inttostr(i)).asstring + ' ou' + #10 + #13 +
              'la catégorie ' + memd_mag.fieldbyname('CATEG' + inttostr(i)).asstring + ' n'' existe pas...', false, 0, 0);
            retour := false;
            BREAK;
          END;

          tim.insert;
          TIMIND_MAGID.asinteger := TmagMAG_ID.asinteger;
          TIMIND_COLID.asinteger := QColCOL_ID.asinteger;
          TIMIND_CATID.asinteger := QCCcat_id.asinteger;
          TIMIND_MRKID.asinteger := QCCmrk_id.asinteger;
          TIMIND_ACHAT.asfloat := memd_mag.fieldbyname('ACHAT' + inttostr(i)).asfloat;
          TIMIND_MARGE.asfloat := memd_mag.fieldbyname('MARGE' + inttostr(i)).asfloat;

          tim.post;
        END;
      END
      ELSE
        MessageDlg('Magasin inexistant : ' + MemD_MagCODE.asstring, mtWarning, [], 0);
      ;
      memd_mag.next;
    END;

    IF retour THEN //Tout est OK
      Ado.committrans
    ELSE //Intégration impossible
      ADO.rollbacktrans;

    Tmag.close;

    memd_mag.close;
    qcol.close;
    tim.close;
    Qcc.close;
    ShowCloseHP;
  END
END;

PROCEDURE TFrm_Admin.Nbt_SMUClick(Sender: TObject);
BEGIN
  IF ODI.Execute THEN
  BEGIN
    memd_smu.DelimiterChar := ';';
    memd_smu.LoadFromTextFile(ODI.files[0]);

    Tsmu.open;
    memd_smu.first;
    WHILE NOT memd_smu.eof DO
    BEGIN
      //Tsmu.insert;
      //TSMUSMU_REFMRK.asstring:=MemD_SmuREF.asstring;
      //TSMUSMU_MRKID.asinteger:=MemD_smuMARQUE.asinteger;
      IF TSMU.locate('smu_refmrk', MemD_SmuREF.asstring, []) THEN
      BEGIN
        tsmu.edit;
        TSMUSMU_CATEG.asinteger := MemD_SmuCATEG.asinteger;
        Tsmu.post;
      END;
      memd_smu.next;
    END;

  END;
  tsmu.close;
  memd_smu.close;

END;

PROCEDURE TFrm_Admin.LMDSpeedButton11Click(Sender: TObject);
BEGIN
  sendere := 1;
  IF NOT ib_sender.connected THEN
  BEGIN
//    ib_sender.databasename := INI.readString('BASE', 'SENDER', '');
    ib_sender.databasename := IniCfg.SenderRSM;
    ib_sender.open;
  END;
  IF lk_send.execute THEN
  BEGIN
    qmag.edit;
    Qmagmag_senderid.asinteger := Que_SenderSENDER_ID.asinteger;
    qmag.post;
  END;
  sendere := 0;

END;

PROCEDURE TFrm_Admin.LMDSpeedButton12Click(Sender: TObject);
VAR
  s: STRING;
  i: integer;
BEGIN

  IF bddos.connected = false THEN
  BEGIN
    bddos.connected := true;
    tdoss.open;
  END;

  IF ds_mag.state IN [dsinsert, dsedit] THEN
  BEGIN
    IF tdoss.locate('dos_code', Qmagmag_code.asstring, []) THEN
    BEGIN
      qmag.edit;
      Qmagmag_cheminbase.asstring := Tdossdos_chemin.asstring;
      //Test de validité

      S := Tdossdos_chemin.asstring;
      qmag.fieldbyname('mag_cheminbase').asstring := S;

      ginkoia.databasename := s;
      ginkoia.open;
      qcode.parambyname('code').asstring := qmag.fieldbyname('mag_code').asstring;
      qcode.open;
      IF qcode.fieldbyname('nbr').asinteger = 0 THEN
      BEGIN
        InfoMessHP('Impossible, le code adhérent ne correspond pas' + #10 + #13 +
          'aux magasins de cette base Ginkoia...', true, 0, 0);
        qmag.fieldbyname('mag_cheminbase').asstring := '';
      END;
      IF qcode.fieldbyname('nbr').asinteger > 1 THEN
      BEGIN
        InfoMessHP('Impossible, le code adhérent correspond à' + #10 + #13 +
          'plusieurs magasins de cette base Ginkoia...', true, 0, 0);
        qmag.fieldbyname('mag_cheminbase').asstring := '';
      END;

      IF Qmagmag_ville.asstring = '' THEN Qmagmag_ville.asstring := Tdossdos_ville.asstring;

    END
    ELSE
      InfoMessHP('Pas de magasin pour ce code...', false, 0, 0);

    Ginkoia.close;

  END;
END;

END.

