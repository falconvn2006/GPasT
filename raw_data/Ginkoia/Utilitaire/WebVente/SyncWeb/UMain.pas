UNIT UMain;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  // Uses perso
  IniFiles,
  WinSvc,
  IdException,
  uFTPUtils,
  // Fin uses perso
  vgPageControlRv, wwLookupDialogRv, wwDBDateTimePickerRv,
  wwCheckBoxRV, wwDBSpinEditRv, wwDBEditRv, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, AppEvnts, RzDBEdit, LMDBaseGraphicControl, wwdbedit,
  LMDCustomButton, LMDButton, RzPanelRv, RzPanel, RzLabel, LMDBaseControl,
  LMDBaseGraphicButton, LMDCustomSpeedButton, LMDSpeedButton, ComCtrls,
  cxControls, LMDCustomComponent, LMDWndProcComponent, LMDTrayIcon, dxmdaset,
  ExtCtrls, ImgList, wwdbdatetimepicker, dxDBTLCl, dxGrClms, dxDBGrid, RzBtnEdt,
  cxPC, dxTL, dxDBCtrl, dxCntner, dxDBGridHP, StdCtrls, wwclearbuttongroup,
  wwradiogroup, wwcheckbox, RzEdit, Wwdbspin, Mask, DB, ActionRv, wwDialog,
  wwidlg, Menus, Dialogs, Buttons, ShellAPI,
  uFTPManager, uMonitoring, ulog, uFTPCtrl;

Const
  cMdl_WEBVENTE = 'WEB VENTE';
  cMdl_EXPORT_TEMPSDESCERISES = 'EXPORT_TEMPSDESCERISES';
  cMdl_EXPORT_FTP = 'EXPORT_FTP';
  cMdl_WMS = 'WMS';

type
  TNiveau = (Annee, Mois, Jour);

  stPrmTimer = RECORD
    dtReplicBegin: TDateTime; // Heure de début de réplication
    dtReplicEnd: TDateTime; // Heure de fin de réplic
    dtVerifHier: TDateTime; // Heure de vérif des commandes de la veille
    iIntervale: Integer; // Intervale entre deux réplic (en minutes)
  END;

  TFrm_Main = CLASS(TForm)
    OpDlg_DBPath: TOpenDialog;
    Img_Onglets: TImageList;
    Tim_DoTraitement: TTimer;
    MemD_PrmTimer: TdxMemData;
    Ds_PrmTimer: TDataSource;
    MemD_PrmTimerDEBUT: TTimeField;
    MemD_PrmTimerFIN: TTimeField;
    MemD_PrmTimerInterval: TIntegerField;
    MemD_PrmTimerVerifHier: TTimeField;
    Tray_Icon: TLMDTrayIcon;
    PopupMenu1: TPopupMenu;
    PopRestaure: TMenuItem;
    PopQuitter: TMenuItem;
    N1: TMenuItem;
    Pgc_Params: TvgPageControlRv;
    Tab_Traitement: TTabSheet;
    Pan_Traitements: TRzPanelRv;
    Pan_Boutons: TRzPanelRv;
    Nbt_SendLog: TLMDSpeedButton;
    Pan_TestResult: TRzPanelRv;
    Lab_TestResult: TRzLabel;
    Lab_CurResult: TRzLabel;
    Pan_Tests: TRzPanelRv;
    Lab_Tests: TRzLabel;
    Nbt_TestConnexion: TLMDButton;
    Nbt_ForceFTPSend: TLMDButton;
    Pan_Status: TRzPanelRv;
    Lab_Status: TRzLabel;
    Lab_CurStatus: TRzLabel;
    Pan_Center: TRzPanelRv;
    Memo_Log: TMemo;
    Tab_DB_Params: TTabSheet;
    RzLabel3: TRzLabel;
    Pan_PathDB: TRzPanelRv;
    Lab_PathDB: TRzLabel;
    RzLabel6: TRzLabel;
    Nbt_PathDB: TLMDSpeedButton;
    Chp_DBPath: TwwDBEditRv;
    Nbt_ValidDBChange: TLMDButton;
    Nbt_DBCancel: TLMDButton;
    Nbt_DBSave: TLMDButton;
    Tab_Timer: TTabSheet;
    RzLabel10: TRzLabel;
    Pan_Timer: TRzPanelRv;
    Lab_TimerInterval: TRzLabel;
    RzLabel13: TRzLabel;
    Lab_TimerDeb: TRzLabel;
    Lab_TimerFin: TRzLabel;
    Chp_TimerInterval: TwwDBSpinEditRv;
    Chp_TimerDeb: TRzDBDateTimeEdit;
    Chp_TimerFin: TRzDBDateTimeEdit;
    Nbt_TempoCancel: TLMDButton;
    Nbt_TempoSave: TLMDButton;
    Pan_Logs: TRzPanelRv;
    RzLabel11: TRzLabel;
    RzLabel12: TRzLabel;
    Lab_NivLog: TRzLabel;
    Chp_DelOldLogAge: TwwDBSpinEditRv;
    Chp_DelOldLog: TwwCheckBoxRV;
    Chp_LogErreurs: TwwRadioGroup;
    LK_SiteWeb: TwwLookupDialogRV;
    Pan_Traitement: TRzPanelRv;
    Lab_Traitements: TRzLabel;
    Nbt_ActiverModeAuto: TLMDSpeedButton;
    Nbt_DoTraitement: TLMDButton;
    MemD_Redo: TdxMemData;
    Ds_Redo: TDataSource;
    MemD_RedoDebut: TDateField;
    MemD_RedoFin: TDateField;
    Nbt_AddRegistre: TLMDButton;
    Tab_Menu: TTabSheet;
    Pan_Espace: TRzPanel;
    Nbt_Quitter: TLMDSpeedButton;
    Lab_Titre: TRzLabel;
    Pan_Trait: TRzPanel;
    Lab_Trait: TRzLabel;
    Pan_Param: TRzPanel;
    Lab_Param: TRzLabel;
    Nbt_Utilitaire: TLMDSpeedButton;
    Nbt_VentePrive: TLMDSpeedButton;
    Nbt_ConnBase: TLMDSpeedButton;
    Nbt_TempoLog: TLMDSpeedButton;
    Img_Fermer: TImage;
    Img_Quit: TImage;
    Nbt_Retour1: TLMDSpeedButton;
    Nbt_DelDemarreAuto: TLMDButton;
    Lab_VtePrive: TRzLabel;
    Lab_Traitement: TRzLabel;
    Ds_SiteVtePriv: TDataSource;
    Tab_VentePrivee: TTabSheet;
    Nbt_Retour2: TLMDSpeedButton;
    Lab_txt: TRzLabel;
    Lab_LstSiteActif: TRzLabel;
    DBG_SiteVtePriv: TdxDBGridHP;
    DBG_SiteVtePrivASS_ID: TdxDBGridMaskColumn;
    DBG_SiteVtePrivASS_NOM: TdxDBGridMaskColumn;
    Pgc_VtePriv: TcxPageControl;
    Tab_ATraiter: TcxTabSheet;
    Tab_Erreurs: TcxTabSheet;
    Lab_rep: TRzLabel;
    Chp_Rep: TRzButtonEdit;
    Tim_VtePriv: TTimer;
    DBG_ATraiterVtePriv: TdxDBGridHP;
    Ds_ATraiterVtePriv: TDataSource;
    DBG_ATraiterVtePrivRecId: TdxDBGridColumn;
    DBG_ATraiterVtePrivfichier: TdxDBGridMaskColumn;
    DBG_ATraiterVtePrivATraiter: TdxDBGridCheckColumn;
    Nbt_Cocher: TLMDSpeedButton;
    Nbt_Decocher: TLMDSpeedButton;
    Nbt_Executer: TLMDSpeedButton;
    Lab_RepInvalid: TRzLabel;
    MemD_ListeRapport: TdxMemData;
    Lab_titerrrap: TRzLabel;
    MemD_ListeRapportFichierSrc: TStringField;
    MemD_ListeRapportFichier: TStringField;
    MemD_ListeRapportJDate: TDateField;
    MemD_ListeRapportJTIME: TTimeField;
    DBG_LstRapport: TdxDBGridHP;
    Ds_ListeRapport: TDataSource;
    DBG_LstRapportRecId: TdxDBGridColumn;
    DBG_LstRapportFichierSrc: TdxDBGridMaskColumn;
    DBG_LstRapportFichier: TdxDBGridMaskColumn;
    DBG_LstRapportJDATE: TdxDBGridDateColumn;
    DBG_LstRapportJTIME: TdxDBGridTimeColumn;
    DBG_RappErr: TdxDBGridHP;
    Ds_Rapport: TDataSource;
    DBG_RappErrRecId: TdxDBGridColumn;
    DBG_RappErrNOLIGNE: TdxDBGridMaskColumn;
    DBG_RappErrFICHIER: TdxDBGridMaskColumn;
    DBG_RappErrJDATE: TdxDBGridDateColumn;
    DBG_RappErrJTIME: TdxDBGridTimeColumn;
    DBG_RappErrLIGERR: TdxDBGridMaskColumn;
    DBG_RappErrLIBERR: TdxDBGridMaskColumn;
    DBG_RappErrNUMCOM: TdxDBGridMaskColumn;
    DBG_RappErrNUMART: TdxDBGridMaskColumn;
    Tim_GetRapport: TTimer;
    Nbt_AgrandirRapport: TLMDSpeedButton;
    Nbt_SuppRapport: TLMDSpeedButton;
    Lab_ParamInvalide: TRzLabel;
    Tab_OkTraite: TcxTabSheet;
    Lab_RappTraite: TRzLabel;
    DBG_RappTraite: TdxDBGridHP;
    MemD_LstRappTraite: TdxMemData;
    Ds_LstRappTraite: TDataSource;
    MemD_LstRappTraiteFichier: TStringField;
    MemD_LstRappTraiteJDATE: TDateField;
    MemD_LstRappTraiteJTIME: TTimeField;
    Nbt_SuppRappTraite: TLMDSpeedButton;
    DBG_RappTraiteFichier: TdxDBGridMaskColumn;
    DBG_RappTraiteJDATE: TdxDBGridDateColumn;
    DBG_RappTraiteJTIME: TdxDBGridTimeColumn;
    Pan_ParamVtePriv: TRzPanelRv;
    Lab_ParamVtePriv: TRzLabel;
    MemD_LstRappTraiteFichierSrc: TStringField;
    DBG_RappTraiteFichierSrc: TdxDBGridMaskColumn;
    Lab_NbJourTraite: TRzLabel;
    Lab_NbjourErr: TRzLabel;
    Chp_NbJrsTraite: TRzEdit;
    Chp_NbJrsErreur: TRzEdit;
    Nbt_Refresh1: TLMDSpeedButton;
    Nbt_Refresh2: TLMDSpeedButton;
    Nbt_Refresh3: TLMDSpeedButton;
    Lab_contenu: TRzLabel;
    Nbt_ImpRapport: TLMDSpeedButton;
    DBG_RappErrDATECOM: TdxDBGridMaskColumn;
    DBG_RappErrLIBPROD: TdxDBGridMaskColumn;
    Nbt_CreerRaccVtePriv: TLMDButton;
    Tab_NetEven: TTabSheet;
    Pan_Memo: TRzPanel;
    Pan_Tools: TRzPanel;
    Pan_NETEVEN: TRzPanelRv;
    Lab_NETEVEN: TRzLabel;
    Lab_Du: TRzLabel;
    Lab_Au: TRzLabel;
    Nbt_TrtJour: TLMDButton;
    Chp_DateRedoFin: TwwDBDateTimePickerRv;
    Chp_RedoDateDeb: TwwDBDateTimePickerRv;
    Nbt_NetEvenRetour: TLMDSpeedButton;
    Memo_NetEven: TMemo;
    Nbt_NetEvenMenu: TLMDSpeedButton;
    Lab_NetEvenMenu: TRzLabel;
    Lab_ParamBdd: TRzLabel;
    Lab_ParamGen: TRzLabel;
    Pan_ToolsQuit: TRzPanelRv;
    Lab_ToolsQuit: TRzLabel;
    Pan_TestsNetEven: TRzPanelRv;
    Lab_TestsNetEven: TRzLabel;
    Pan_NetEvenMenu: TRzPanelRv;
    Nbt_TestNetEven: TLMDButton;
    Lab_MenuNetEven: TRzLabel;
    Gax_MenuVtePriv: TActionGroupRv;
    Lab_NetEvenNbJour: TRzLabel;
    Chp_NetEvenNbJour: TwwDBSpinEditRv;
    MemD_PrmTimerNbHier: TIntegerField;
    ApplicationEvents1: TApplicationEvents;
    Lab_ConnectTimeout: TRzLabel;
    Chp_ConnectTimeout: TRzEdit;
    Nbt_Initialisation: TLMDButton;
    Pgc_Parametres: TPageControl;
    Tab_VtePrive: TTabSheet;
    Tab_Generique: TTabSheet;
    RzPanelRv1: TRzPanelRv;
    Lab_ParamGenerique: TRzLabel;
    Chp_GeneriqueZip: TwwCheckBoxRV;
    Tab_WMS: TTabSheet;
    RzPanelRv2: TRzPanelRv;
    Nbt_WMSTab: TLMDSpeedButton;
    Lab_WMSDescr: TRzLabel;
    GridPanel1: TGridPanel;
    Memo_WMSLogs: TMemo;
    RzPanelRv4: TRzPanelRv;
    Lab_WMS: TRzLabel;
    Nbt_WMSInit: TLMDSpeedButton;
    Nbt_WMSExecute: TLMDSpeedButton;
    Nbt_WMSTabRetour: TLMDSpeedButton;
    Lab_WMSStatus: TLabel;
    RzPanelRv3: TRzPanelRv;
    Lab_WMStest: TRzLabel;
    Nbt_WMSTestConnexion: TLMDButton;
    Nbt_WMSSENDFTP: TLMDButton;
    Tim_RefreshDefaultMonitoringValues: TTimer;
    Nbt_WMSActiveModeAuto: TLMDSpeedButton;
    Nbt_ExportFTP: TLMDSpeedButton;
    Lab_ExportFTP: TRzLabel;
    Tab_ExportFTP: TTabSheet;
    RzPanelRv5: TRzPanelRv;
    GridPanel2: TGridPanel;
    Memo_ExportFTPLogs: TMemo;
    RzPanelRv6: TRzPanelRv;
    Lab_ExportFtpTraitement: TRzLabel;
    Nbt_ExportFtpExecute: TLMDSpeedButton;
    Nbt_ExportFTPActiveModeAuto: TLMDSpeedButton;
    Nbt_ExportFtpTabRetour: TLMDSpeedButton;
    Lab_ExportFtpStatus: TLabel;
    RzPanelRv7: TRzPanelRv;
    Lab_ExportFtpserveur: TRzLabel;
    Nbt_ExportFtpTestConnexion: TLMDButton;
    Nbt_ExportFtpSENDFTP: TLMDButton;
    Chp_GestAccesConcurrentielsFTP: TwwCheckBoxRV;
    PROCEDURE Nbt_TestConnexionClick(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Nbt_PathDBClick(Sender: TObject);
    PROCEDURE Nbt_ValidDBChangeClick(Sender: TObject);
    PROCEDURE BtnSaveClick(Sender: TObject);
    PROCEDURE BtnCancelClick(Sender: TObject);
    PROCEDURE Chp_FileChange(Sender: TObject);
    PROCEDURE Nbt_SendLogClick(Sender: TObject);
    PROCEDURE Nbt_ForceFTPSendClick(Sender: TObject);

    PROCEDURE InitPrmTimer();
    PROCEDURE SetTimerInterval();
    PROCEDURE MajDebFinTimer();
    FUNCTION TraitementToDo(): boolean;
    Function MappingOK(): boolean;
    FUNCTION DoTraitement(): boolean;
    function DoInitialisation: Boolean;
    PROCEDURE Tim_DoTraitementTimer(Sender: TObject);
    PROCEDURE PopQuitterClick(Sender: TObject);
    PROCEDURE PopRestaureClick(Sender: TObject);
    PROCEDURE Tray_IconDblClick(Sender: TObject);
    PROCEDURE Nbt_ActiverModeAutoClick(Sender: TObject);
    PROCEDURE Nbt_DoTraitementClick(Sender: TObject);

    PROCEDURE Initialize();
    PROCEDURE FinTraitement();
    PROCEDURE Nbt_TrtJourClick(Sender: TObject);
    PROCEDURE Nbt_AddRegistreClick(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: boolean);
    PROCEDURE Nbt_QuitterClick(Sender: TObject);
    PROCEDURE Nbt_UtilitaireClick(Sender: TObject);
    PROCEDURE Nbt_Retour1Click(Sender: TObject);
    PROCEDURE Nbt_Retour2Click(Sender: TObject);
    PROCEDURE Nbt_VentePriveClick(Sender: TObject);
    PROCEDURE Nbt_ConnBaseClick(Sender: TObject);
    PROCEDURE Nbt_TempoLogClick(Sender: TObject);
    PROCEDURE Nbt_DelDemarreAutoClick(Sender: TObject);
    PROCEDURE Ds_SiteVtePrivDataChange(Sender: TObject; Field: TField);
    PROCEDURE Tim_VtePrivTimer(Sender: TObject);
    PROCEDURE Pgc_VtePrivPageChanging(Sender: TObject; NewPage: TcxTabSheet;
      VAR AllowChange: boolean);
    PROCEDURE Nbt_CocherClick(Sender: TObject);
    PROCEDURE Nbt_DecocherClick(Sender: TObject);
    PROCEDURE DBG_ATraiterVtePrivDblClick(Sender: TObject);
    PROCEDURE Chp_RepKeyPress(Sender: TObject; VAR Key: Char);
    PROCEDURE Chp_RepButtonClick(Sender: TObject);
    PROCEDURE Nbt_ExecuterClick(Sender: TObject);
    PROCEDURE Ds_ListeRapportDataChange(Sender: TObject; Field: TField);
    PROCEDURE Tim_GetRapportTimer(Sender: TObject);
    PROCEDURE Pgc_ParamsChange(Sender: TObject);
    PROCEDURE Nbt_SuppRapportClick(Sender: TObject);
    PROCEDURE Nbt_AgrandirRapportClick(Sender: TObject);
    PROCEDURE Nbt_SuppRappTraiteClick(Sender: TObject);
    PROCEDURE Chp_NbJrsTraiteKeyPress(Sender: TObject; VAR Key: Char);
    PROCEDURE Nbt_Refresh1Click(Sender: TObject);
    PROCEDURE Nbt_ImpRapportClick(Sender: TObject);
    PROCEDURE FormActivate(Sender: TObject);
    PROCEDURE Nbt_CreerRaccVtePrivClick(Sender: TObject);
    PROCEDURE Memo_LogChange(Sender: TObject);
    PROCEDURE Nbt_NetEvenMenuClick(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure Nbt_InitialisationClick(Sender: TObject);
    procedure Nbt_WMSExecuteClick(Sender: TObject);
    procedure Nbt_WMSInitClick(Sender: TObject);
    procedure Nbt_WMSTabClick(Sender: TObject);
    procedure Nbt_WMSTabRetourClick(Sender: TObject);
    procedure Nbt_WMSSENDFTPClick(Sender: TObject);
    procedure Nbt_WMSTestConnexionClick(Sender: TObject);
    procedure Tim_RefreshDefaultMonitoringValuesTimer(Sender: TObject);
    procedure Nbt_ExportFTPClick(Sender: TObject);
    procedure Nbt_ExportFtpTestConnexionClick(Sender: TObject);
    procedure Nbt_ExportFtpSENDFTPClick(Sender: TObject);
    procedure Nbt_ExportFtpExecuteClick(Sender: TObject);
    procedure Nbt_ExportFTPActiveModeAutoClick(Sender: TObject);

  PRIVATE
    FWMSManager: TFTPManager;
    FExportFtpManager: TFTPManager;

    FListModule: TStringList;

    MyPrmTimer: stPrmTimer; // Contient les paramètres

    hDebReplic, hFinReplic: TDateTime;
    // Date et heure de début et fin de réplic pour ce jour

    // Fichier INI
    MyIniFile: TIniFile;

    bModeVtePriv: boolean;
    bModeAuto: boolean;
    EnCoursVtePriv: boolean;
    EnCoursLstRapport: boolean;
    EnCoursTraiter: boolean;
    EnCoursTraitement: boolean;
    bZipper: Boolean;
    bDateFicInit: Boolean;    //Si vrai on ajoute la date en fin de fichier Init
    bDateFic: Boolean;        //Si vrai on ajoute la date en fin de fichier
    bEnvoiInitJour: Boolean;  //Si vrai on envoi une fois par jour les fichiers Init
    bEnvoiInitStock: Boolean;      // Si vrai et si 'EnvoiInitJour' est faux, n'envoit que le stock.
    nNbJoursPurgeRepSend: Integer;

    { Déclarations privées }
    PROCEDURE DoGetRapport(CONST OkForce: boolean = false);
    PROCEDURE DoVtePrive(pTabSheet: TcxTabSheet);
    PROCEDURE ChangeBtnQuitter(OkQuit: boolean);
    PROCEDURE WMQueryEndSession(VAR M: TWMQueryEndSession);
      MESSAGE WM_QUERYENDSESSION;
    PROCEDURE WMSysCommand(VAR Msg: TWMSyscommand); MESSAGE WM_SYSCOMMAND;
    PROCEDURE InitParams();
    PROCEDURE SaveParams();
    PROCEDURE ActiveOnglet(pTabSheet: TTabSheet);
    // changement de methode: appel par nom plutot que par numero
    // PROCEDURE ActiveOnglet(CONST NumPage: Integer = 0);
    PROCEDURE ActiveTimer();
    PROCEDURE Attente_IB();
    procedure SuppressionVieuxFichiers(const sRepertoire: String; const Niveau: TNiveau = Annee; const nAnnee: Integer = 0; const nMois: Integer = 0);
    function SetTraitementEnCours(aEtat: boolean): boolean;


    // --------------- WMS --------------
    procedure InitWMS;
    procedure WMSManagerLog(Sender: TObject; ALog: string; AFTPLogLvl: TFTPLogLevel);
    procedure WMSManagerAddMonitoring(Sender: TObject; AMessage: string; ALogLevel: TLogLevel;
      AMdlType: TMonitoringMdlType; AAppType: TMonitoringAppType;
      ACurrentMag: integer; AForceStatus: boolean; AFrequency: integer = -1);
    procedure WMSManagerAfterStart(Sender: TObject);
    procedure OnWMSGetData(Sender: TObject);

    // ------------ Export FTP ----------
    procedure InitExportFtp;
    procedure ExportFtpManagerLog(Sender: TObject; ALog: string; AFTPLogLvl: TFTPLogLevel);
    procedure ExportFtpManagerAddMonitoring(Sender: TObject; AMessage: string; ALogLevel: TLogLevel;
      AMdlType: TMonitoringMdlType; AAppType: TMonitoringAppType;
      ACurrentMag: integer; AForceStatus: boolean; AFrequency: integer = -1);
    procedure ExportFtpManagerAfterStart(Sender: TObject);

    // ----------------------------------
  PUBLIC
    { Déclarations publiques }
    function ModuleIsEnabled(AModuleName: string): boolean;
  END;

VAR
  Frm_Main: TFrm_Main;

IMPLEMENTATION

USES UCommon,
  UCommon_DM,
  FileCTRL,
  UMapping,
  DateUtils,
  Registry,
  Confirmation_Frm,
  MotDePasse_Frm,
  Progression_Frm,
  RapportAgrandi_Frm,
  uCommon_Type,
  uVtePrivee,
  ComObj,
  SHLObj,
  ActiveX,
  SyncWebResStr, UVersion, uFTPSite, uTableNegColisUtils, uCustomFTPManager;

{$R *.DFM}

function SortWMSGetFiles(List: TStringList; Index1,
  Index2: Integer): Integer;
begin
  if List[Index1] = List[Index2] then
    result := 0
  else
    if List[Index1] < List[Index2] then
      result := -1
    else
      result := 1;

  if List[index1] = 'WMS_TRANSPORTEUR.TXT' then
    Result := -1;

  if List[index2] = 'WMS_TRANSPORTEUR.TXT' then
    Result := 1;
end;


// affiche le contenu du rapport d'erreur de vente privée
PROCEDURE TFrm_Main.DoGetRapport(CONST OkForce: boolean = false);
VAR
  s: STRING;
  sRep: STRING;
BEGIN
  IF EnCoursLstRapport THEN
  BEGIN
    Tim_GetRapport.Enabled := true;
    exit;
  END;
  IF (Pgc_VtePriv.ActivePage <> Tab_Erreurs) AND NOT(OkForce) THEN
    exit;
  Screen.Cursor := crHourGlass;
  EnCoursLstRapport := true;
  Application.ProcessMessages;
  TRY
    Dm_Common.MemD_Rapport.Active := false;
    Dm_Common.MemD_Rapport.DelimiterChar := ';';
    sRep := Dm_Common.Que_SitePriv.fieldbyname('ASF_LOCALFOLDERGET').AsString;
    IF sRep[Length(sRep)] <> '\' THEN
      sRep := sRep + '\';
    IF NOT(DirectoryExists(sRep)) THEN
      exit;
    sRep := sRep + 'RAPPORT\';
    IF NOT(DirectoryExists(sRep)) THEN
      exit;
    IF NOT(MemD_ListeRapport.Active) OR (MemD_ListeRapport.RecordCount = 0) THEN
      exit;
    s := MemD_ListeRapport.fieldbyname('FichierSrc').AsString;
    TRY
      Dm_Common.MemD_Rapport.LoadFromTextFile(sRep + s);
      Dm_Common.MemD_Rapport.Active := true;
    EXCEPT
    END;
  FINALLY
    Application.ProcessMessages;
    EnCoursLstRapport := false;
    Screen.Cursor := crDefault;
  END;
END;

// affiche le détail des ventes privées suivant l'onglet où l'on se trouve (A Traiter, Fichiers traités,Erreurs)

PROCEDURE TFrm_Main.DoVtePrive(pTabSheet: TcxTabSheet);
VAR
  sRep, sRepArch: STRING;
  TPListe: TStringList;
  s, sFic, sFicSrc: STRING;
  SearchRec: TSearchRec;
  i, resu: Integer;
  d: TDateTime;
  bOk: boolean;
  OkDate: STRING;

  FUNCTION CtrlDateTime(Value: STRING; VAR OkValid: boolean): STRING;
  VAR
    dd, mm, yy: word;
    hh, nn, ss, ms: word;
    TpD: TDateTime;
  BEGIN
    IF Length(Value) < 15 THEN
    BEGIN
      OkValid := false;
      exit;
    END;
    yy := StrToIntdef(Copy(Value, 1, 4), 40);
    mm := StrToIntdef(Copy(Value, 5, 2), 40);
    dd := StrToIntdef(Copy(Value, 7, 2), 40);
    IF (mm = 40) OR (dd = 40) THEN
    BEGIN
      OkValid := false;
      exit;
    END;

    hh := StrToIntdef(Copy(Value, 10, 2), 0);
    nn := StrToIntdef(Copy(Value, 12, 2), 0);
    ss := StrToIntdef(Copy(Value, 14, 2), 0);
    ms := 0;
    TRY
      TpD := EncodeDate(yy, mm, dd) + EncodeTime(hh, nn, ss, ms);
      OkValid := true;
    EXCEPT
      OkValid := false;
      exit;
    END;
    Result := DateTimeToStr(TpD);
  END;

BEGIN
  IF EnCoursVtePriv THEN
  BEGIN
    Tim_VtePriv.Enabled := true;
    exit;
  END;
  Screen.Cursor := crHourGlass;
  EnCoursVtePriv := true;
  EnCoursLstRapport := true;
  TPListe := TStringList.Create;
  Application.ProcessMessages;
  TRY
    // onglet: A TRaiter
    IF pTabSheet = Tab_ATraiter THEN
    BEGIN
      Dm_Common.MemD_ATraiterVtePriv.Active := false;
      sRep := Chp_Rep.Text;
      IF (sRep <> '') AND (sRep[Length(sRep)] <> '\') THEN
        sRep := sRep + '\';
      IF NOT(Dm_Common.Que_SitePriv.Active) OR
        (Dm_Common.Que_SitePriv.RecordCount = 0) THEN
      BEGIN
        Lab_RepInvalid.Visible := false;
        Lab_ParamInvalide.Visible := false;
        Nbt_Executer.Enabled := false;
        Nbt_Cocher.Enabled := false;
        Nbt_Decocher.Enabled := false;
        Nbt_Executer.Enabled := false;
        exit;
      END;

      // test le rép paramètré dans Ginkoia
      s := Dm_Common.Que_SitePriv.fieldbyname('ASF_LOCALFOLDERGET').AsString;
      Lab_RepInvalid.Visible := (s = '') OR NOT(DirectoryExists(s));
      Nbt_Executer.Enabled := NOT(Lab_RepInvalid.Visible);

      // test si le paramètrage Mode de règlement est valide dans Ginkoia
      WITH Dm_Common.Que_Trv DO
      BEGIN
        Active := false;
        ParamByName('ASSID').AsInteger := Dm_Common.Que_SitePriv.fieldbyname
          ('ASS_ID').AsInteger;
        Active := true;
        IF Eof THEN
        BEGIN
          Lab_ParamInvalide.Visible := true;
          Nbt_Executer.Enabled := false;
        END
        ELSE
        BEGIN
          Lab_ParamInvalide.Visible := false;
          Nbt_Executer.Enabled := NOT(Lab_RepInvalid.Visible);
        END;
        Active := false;
      END;

      IF (sRep = '') OR NOT(DirectoryExists(sRep)) THEN
      BEGIN
        Nbt_Cocher.Enabled := false;
        Nbt_Decocher.Enabled := false;
        Nbt_Executer.Enabled := false;
        exit;
      END;

      TPListe.Clear;
      resu := FindFirst(sRep + '*.csv', faAnyFile, SearchRec);
      WHILE (resu = 0) DO
      BEGIN
        s := ExtractFileName(SearchRec.Name);
        IF (s <> '.') AND (s <> '..') AND
          ((SearchRec.Attr AND faDirectory) <> faDirectory) THEN
          TPListe.Add(s);
        resu := FindNext(SearchRec);
      END;
      FindClose(SearchRec);
      TPListe.Sort;
      WITH Dm_Common.MemD_ATraiterVtePriv DO
      BEGIN
        Active := true;
        FOR i := 1 TO TPListe.Count DO
        BEGIN
          Append;
          fieldbyname('fichier').AsString := TPListe[i - 1];
          fieldbyname('ATraiter').AsInteger := 1;
          Post;
        END;
        First;
      END;
      Nbt_Cocher.Enabled := (Dm_Common.MemD_ATraiterVtePriv.RecordCount > 0);
      Nbt_Decocher.Enabled := Nbt_Cocher.Enabled;
      Nbt_Executer.Enabled := Nbt_Executer.Enabled AND Nbt_Cocher.Enabled;
    END;

    // Onglet: Fichiers Traités
    IF (pTabSheet = Tab_OkTraite) THEN
    BEGIN
      MemD_LstRappTraite.Active := false;
      MemD_LstRappTraite.Active := true;
      IF NOT(Dm_Common.Que_SitePriv.Active) OR
        (Dm_Common.Que_SitePriv.RecordCount = 0) THEN
      BEGIN
        Nbt_SuppRappTraite.Enabled := false;
        exit;
      END;
      sRep := Dm_Common.Que_SitePriv.fieldbyname('ASF_LOCALFOLDERGET').AsString;
      IF (sRep <> '') AND (sRep[Length(sRep)] <> '\') THEN
        sRep := sRep + '\';
      IF (sRep = '') OR NOT(DirectoryExists(sRep)) THEN
      BEGIN
        Nbt_SuppRappTraite.Enabled := false;
        exit;
      END;
      sRepArch := sRep + 'OK\ARCHIVE\';
      sRep := sRep + 'OK\';
      IF NOT(DirectoryExists(sRep)) THEN
      BEGIN
        Nbt_SuppRappTraite.Enabled := false;
        exit;
      END;
      ForceDirectories(sRepArch);
      TPListe.Clear;
      resu := FindFirst(sRep + '*.csv', faAnyFile, SearchRec);
      WHILE (resu = 0) DO
      BEGIN
        s := ExtractFileName(SearchRec.Name);
        IF (s <> '.') AND (s <> '..') AND
          ((SearchRec.Attr AND faDirectory) <> faDirectory) THEN
        BEGIN
          sFic := s;
          d := FileDateToDateTime(FileAge(sRep + sFic));
          s := Copy(s, 1, Length(s) - Length(ExtractFileExt(s)));
          IF Length(s) - 14 > 0 THEN
            s := Copy(s, Length(s) - 14, Length(s));
          s := CtrlDateTime(s, bOk);
          OkDate := 'N';
          IF bOk THEN
          BEGIN
            OkDate := 'O';
            d := StrToDateTime(s);
          END;
          TPListe.Add(FormatDateTime('yyyymmdd hhnnss', d) + OkDate +
            '|' + sFic);
        END;
        resu := FindNext(SearchRec);
      END;
      FindClose(SearchRec);
      TPListe.Sort;
      FOR i := TPListe.Count DOWNTO 1 DO
      BEGIN
        s := TPListe[i - 1];
        sFicSrc := Copy(s, Pos('|', s) + 1, Length(s));
        s := Copy(s, 1, Pos('|', s) - 1);
        OkDate := s[16];
        s := Copy(s, 1, Length(s) - 1);
        s := CtrlDateTime(s, bOk);
        d := StrToDateTime(s);
        IF OkDate = 'O' THEN
        BEGIN
          s := sFicSrc;
          IF Length(s) - 15 > 0 THEN
            s := Copy(s, Length(s) - 15, Length(s));
          sFic := Copy(sFicSrc, 1, Length(sFicSrc) - Length(s) -
            Length(ExtractFileExt(sFicSrc)));
          sFic := sFic + ExtractFileExt(sFicSrc);
        END
        ELSE
          sFic := sFicSrc;

        // archivation automatique si date d'intégration<date-NbJrsGardeTraite
        IF Trunc(d) <= Trunc(Date) - Dm_Common.MyIniParams.NbJrsGardeTraite THEN
          RenameFile(sRep + sFicSrc, sRepArch + sFicSrc);

        IF FileExists(sRep + sFicSrc) THEN
        BEGIN
          MemD_LstRappTraite.Append;
          MemD_LstRappTraite.fieldbyname('FichierSrc').AsString := sFicSrc;
          MemD_LstRappTraite.fieldbyname('Fichier').AsString := sFic;
          MemD_LstRappTraite.fieldbyname('JDATE').AsDateTime := Trunc(d);
          MemD_LstRappTraite.fieldbyname('JTIME').AsDateTime := Frac(d);
          MemD_LstRappTraite.Post;
        END;
      END;
      MemD_LstRappTraite.First;
      Nbt_SuppRappTraite.Enabled := (MemD_LstRappTraite.RecordCount > 0);
    END;

    // Onglet: Erreurs
    IF (pTabSheet = Tab_Erreurs) THEN
    BEGIN
      MemD_ListeRapport.Active := false;
      MemD_ListeRapport.Active := true;
      IF NOT(Dm_Common.Que_SitePriv.Active) OR
        (Dm_Common.Que_SitePriv.RecordCount = 0) THEN
      BEGIN
        Nbt_AgrandirRapport.Enabled := false;
        Nbt_SuppRapport.Enabled := false;
        Nbt_ImpRapport.Enabled := false;
        exit;
      END;
      sRep := Dm_Common.Que_SitePriv.fieldbyname('ASF_LOCALFOLDERGET').AsString;
      IF (sRep <> '') AND (sRep[Length(sRep)] <> '\') THEN
        sRep := sRep + '\';
      IF (sRep = '') OR NOT(DirectoryExists(sRep)) THEN
      BEGIN
        Nbt_AgrandirRapport.Enabled := false;
        Nbt_SuppRapport.Enabled := false;
        Nbt_ImpRapport.Enabled := false;
        exit;
      END;
      sRepArch := sRep + 'RAPPORT\ARCHIVE\';
      sRep := sRep + 'RAPPORT\';
      IF NOT(DirectoryExists(sRep)) THEN
      BEGIN
        Nbt_AgrandirRapport.Enabled := false;
        Nbt_SuppRapport.Enabled := false;
        Nbt_ImpRapport.Enabled := false;
        exit;
      END;
      TPListe.Clear;
      resu := FindFirst(sRep + 'Rapport_*.csv', faAnyFile, SearchRec);
      WHILE (resu = 0) DO
      BEGIN
        s := ExtractFileName(SearchRec.Name);
        IF (s <> '.') AND (s <> '..') AND
          ((SearchRec.Attr AND faDirectory) <> faDirectory) THEN
        BEGIN
          sFic := s;
          d := FileDateToDateTime(FileAge(sRep + sFic));
          s := Copy(s, 1, Length(s) - Length(ExtractFileExt(s)));
          IF Length(s) - 14 > 0 THEN
            s := Copy(s, Length(s) - 14, Length(s));

          s := CtrlDateTime(s, bOk);
          OkDate := 'N';
          IF bOk THEN
          BEGIN
            d := StrToDateTime(s);
            OkDate := 'O';
          END;
          TPListe.Add(FormatDateTime('yyyymmdd hhnnss', d) + OkDate +
            '|' + sFic);
        END;
        resu := FindNext(SearchRec);
      END;
      FindClose(SearchRec);
      TPListe.Sort;
      FOR i := TPListe.Count DOWNTO 1 DO
      BEGIN
        s := TPListe[i - 1];
        sFicSrc := Copy(s, Pos('|', s) + 1, Length(s));
        s := Copy(s, 1, Pos('|', s) - 1);
        OkDate := s[16];
        s := Copy(s, 1, Length(s) - 1);
        s := CtrlDateTime(s, bOk);
        d := StrToDateTime(s);
        sFic := Copy(sFicSrc, 9, Length(sFicSrc));
        IF OkDate = 'O' THEN
        BEGIN
          s := sFicSrc;
          IF Length(s) - 15 > 0 THEN
            s := Copy(s, Length(s) - 15, Length(s));

          sFic := Copy(sFic, 1, Length(sFic) - Length(s) -
            Length(ExtractFileExt(sFicSrc)));
          sFic := sFic + ExtractFileExt(sFicSrc);
        END;

        // archivation automatique si date d'intégration<date-NbJrsGardeErreur
        IF Trunc(d) <= Trunc(Date) - Dm_Common.MyIniParams.NbJrsGardeErreur THEN
          RenameFile(sRep + sFicSrc, sRepArch + sFicSrc);

        IF FileExists(sRep + sFicSrc) THEN
        BEGIN
          MemD_ListeRapport.Append;
          MemD_ListeRapport.fieldbyname('FichierSrc').AsString := sFicSrc;
          MemD_ListeRapport.fieldbyname('Fichier').AsString := sFic;
          MemD_ListeRapport.fieldbyname('JDATE').AsDateTime := Trunc(d);
          MemD_ListeRapport.fieldbyname('JTIME').AsDateTime := Frac(d);
          MemD_ListeRapport.Post;
        END;
      END;
      MemD_ListeRapport.First;
      Nbt_AgrandirRapport.Enabled := (MemD_ListeRapport.RecordCount > 0);
      Nbt_SuppRapport.Enabled := (MemD_ListeRapport.RecordCount > 0);
      Nbt_ImpRapport.Enabled := (MemD_ListeRapport.RecordCount > 0);
      DoGetRapport(true);
    END;

  FINALLY
    Application.ProcessMessages;
    TPListe.Free;
    EnCoursVtePriv := false;
    EnCoursLstRapport := false;
    Screen.Cursor := crDefault;
  END;
END;

PROCEDURE TFrm_Main.ChangeBtnQuitter(OkQuit: boolean);
BEGIN
  IF OkQuit THEN
  BEGIN
    Nbt_Quitter.Glyph.Assign(Img_Quit.Picture.Bitmap);
    Nbt_Quitter.Caption := '&Quitter';
  END
  ELSE
  BEGIN
    Nbt_Quitter.Glyph.Assign(Img_Fermer.Picture.Bitmap);
    Nbt_Quitter.Caption := '&Fermer';
  END;
END;

PROCEDURE TFrm_Main.WMQueryEndSession(VAR M: TWMQueryEndSession);
BEGIN
  (*
    //detecter arret windows delphi
    // Pour autoriser l'arrêt de Windows :
    m.Result := 1;
    // Pour annuler l'arrêt de Windows :
    m.Result := 0; *)

  M.Result := 1;
  Tray_Icon.NoClose := false;
  Close;
END;

procedure TFrm_Main.WMSManagerAddMonitoring(Sender: TObject; AMessage: string;
  ALogLevel: TLogLevel; AMdlType: TMonitoringMdlType; AAppType: TMonitoringAppType;
  ACurrentMag: integer; AForceStatus: boolean; AFrequency: integer);
begin
  AddMonitoring(AMessage, ALogLevel, AMdlType, AAppType, ACurrentMag,
    AForceStatus, AFrequency);
end;

procedure TFrm_Main.WMSManagerAfterStart(Sender: TObject);
begin
  Nbt_WMSActiveModeAuto.Enabled := False;
end;

procedure TFrm_Main.WMSManagerLog(Sender: TObject; ALog: string;
  AFTPLogLvl: TFTPLogLevel);
VAR
  F: TextFile;
BEGIN
  TRY
    IF Integer(AFTPLogLvl) <= Dm_Common.MyIniParams.iNiveauLog THEN
    BEGIN
      if (Sender is TFTPSite) then
      begin
        uFTPUtils.WriteErrorLog(TFTPSite(Sender).LogFilePath, ALog);
        TFTPSite(Sender).HasErrors := True;
      end;
    END;

    Memo_WMSLogs.Lines.Insert(0, FormatDateTime('dd/mm/yyyy hh:mm:ss', Date + Time) + ' : ' + ALog);
    Memo_WMSLogs.Update;

  EXCEPT
    On E: Exception do
      Memo_WMSLogs.Lines.Add(E.Message);
  END;
end;

PROCEDURE TFrm_Main.WMSysCommand(VAR Msg: TWMSyscommand);
BEGIN
  // intercept le minimize de la fiche
  IF NOT(bModeVtePriv) AND ((Msg.CmdType AND $FFF0) = SC_MINIMIZE) THEN
  BEGIN
    Tray_Icon.NoClose := false;
    Hide;
  END;
  INHERITED;
END;

PROCEDURE TFrm_Main.InitParams;

BEGIN
  InitPrmTimer();

  WITH Dm_Common.MyIniParams DO
  BEGIN
    // Intervalle envoi "OK" au monitoring.
    Tim_RefreshDefaultMonitoringValues.Interval := MyIniFile.ReadInteger('Monitoring', 'Intervalle', 300000);

    // Infos de connection à la BDD
    sDBPath := MyIniFile.ReadString('DATABASE', 'PATH', '');
    Chp_DBPath.Text := sDBPath;

    // Options
    bDelOldLog := MyIniFile.ReadBool('OPTIONS', 'DELOLDLOG', true);
    Chp_DelOldLog.Checked := bDelOldLog;

    iDelOldLogAge := MyIniFile.ReadInteger('OPTIONS', 'DELOLDLOGAGE', 5);
    Chp_DelOldLogAge.Text := IntToStr(iDelOldLogAge);
    iNiveauLog := MyIniFile.ReadInteger('OPTIONS', 'NIVEAU', 0);
    Chp_LogErreurs.Value := IntToStr(iNiveauLog);

    Chp_GestAccesConcurrentielsFTP.Checked:= MyIniFile.ReadBool('OPTIONS', 'ACCESCONCURRENTSFTP', False);

    nNbJoursPurgeRepSend := MyIniFile.ReadInteger('Paramètres', 'Nb jours purge rép Send', 30);

    dtHier := MyIniFile.ReadDateTime('TIMER', 'VERIFHIER',
      Trunc(Now + 4) + EncodeTime(8, 0, 0, 0));
    iNbJourHier := MyIniFile.ReadInteger('TIMER', 'NBHIER', 4);

    iMarketId := MyIniFile.ReadInteger('GENERIQUE', 'MARKETID', 999);
    InitLogFileName(Memo_Log, Lab_Status, iNiveauLog);
    bZipper := MyIniFile.ReadBool('GENERIQUE', 'ZIP', False);
    Chp_GeneriqueZip.Checked := bZipper;

    bDateFicInit := MyIniFile.ReadBool('GENERIQUE', 'DATEFICINIT', False);
    bDateFic := MyIniFile.ReadBool('GENERIQUE', 'DATEFIC', False);
    bEnvoiInitJour := MyIniFile.ReadBool('GENERIQUE', 'ENVOIINITJOUR', False);
    bEnvoiInitStock := MyIniFile.ReadBool('GENERIQUE', 'ENVOIINITSTOCK', False);

    NbJrsGardeTraite := MyIniFile.ReadInteger('GENERIQUE_SKU',
      'NbJrsGardeTraite', 120);
    NbJrsGardeErreur := MyIniFile.ReadInteger('GENERIQUE_SKU',
      'NbJrsGardeErreur', 120);
    Chp_NbJrsTraite.Text := IntToStr(NbJrsGardeTraite);
    Chp_NbJrsErreur.Text := IntToStr(NbJrsGardeErreur);

    //Timeout
    iConnect                  := MyIniFile.ReadInteger('TIMEOUT', 'Connect', 3000);
    Chp_ConnectTimeout.Text   := IntToStr(iConnect);
  END;
END;

PROCEDURE TFrm_Main.Nbt_TempoLogClick(Sender: TObject);
VAR
  bOk: boolean;
BEGIN
  Frm_MotDePasse := TFrm_MotDePasse.Create(Self);
  TRY
    bOk := (Frm_MotDePasse.ShowModal = mrOk);
    Application.ProcessMessages;
  FINALLY
    Frm_MotDePasse.Free;
    Frm_MotDePasse := NIL;
  END;
  IF bOk THEN
  begin
    ActiveOnglet(Tab_Timer);
  end;
END;

PROCEDURE TFrm_Main.Nbt_TestConnexionClick(Sender: TObject);
BEGIN
  WITH Dm_Common DO
  BEGIN
    IF DBReconnect THEN
    BEGIN
      // pour chaque site
      Que_GetSites.Close;
      Que_GetSites.Open;
      WHILE NOT Que_GetSites.Eof DO
      BEGIN
        Dm_Common.LitParams(false);

        Sablier(true, Self);
        TRY
          TestConnexions;
        FINALLY
          Sablier(false, Self);
        END;
        Que_GetSites.Next;
      END;
      Que_GetSites.Close;
      DBDisconnect;
    END;
  END;
END;

PROCEDURE TFrm_Main.Nbt_TrtJourClick(Sender: TObject);
VAR
  dtDeb, dtFin: TDateTime;
  // Variables tempo pour stocker et modifier les dates/heures
BEGIN
  IF (MemD_RedoDebut.AsDateTime <> 0) AND (MemD_RedoFin.AsDateTime <> 0) THEN
  BEGIN
    // On demande d'abord le site.
    IF LK_SiteWeb.Execute THEN
    BEGIN
      IF Dm_Common.LitParams(true) THEN
      BEGIN
        IF (Dm_Common.MySiteParams.bGet) AND
          (Dm_Common.MySiteParams.sTypeGet = 'NETEVEN') THEN
        BEGIN
          Memo_NetEven.Clear;
          Memo_NetEven.Lines.Add('Traitement manuel NetEven');
          // Refaire une journée pour NetEVEN
          dtDeb := MemD_RedoDebut.AsDateTime;
          dtFin := DateOf(MemD_RedoFin.AsDateTime) + 1;
          Dm_Common.NetEvenGet(dtDeb, dtFin);
        END;
      END;
    END;
  END;
END;

PROCEDURE TFrm_Main.Nbt_UtilitaireClick(Sender: TObject);
BEGIN
  ActiveOnglet(Tab_Traitement);
END;

PROCEDURE TFrm_Main.FormDestroy(Sender: TObject);
BEGIN
  FreeAndNil(FTableNegColisUtils);
  FreeAndNil(FWMSManager);
  FreeAndNil(FExportFtpManager);
  FreeAndNil(FListModule);
  if GFTPCtrl <> nil then
    FreeAndNil(GFTPCtrl);

  //TODO a deplacer dans un fonction
  // Monitor l'arret des SyncWeb
  Dm_Common.Que_GetSites.Close;
  Dm_Common.Que_GetSites.Open;
  while not Dm_Common.Que_GetSites.Eof do
  begin
    if Dm_Common.LitParams(true) then
      AddMonitoring('Fermeture de l''application', logWarning, mdltMain, apptSyncWeb, Dm_Common.MySiteParams.iMagID);
    Dm_Common.Que_GetSites.Next;
  end;
  Dm_Common.Que_GetSites.Close;

  MemD_Redo.Close;
  MyIniFile.Free;

  Application.ProcessMessages;
  CloseMonitoring;
END;

PROCEDURE TFrm_Main.FormCreate(Sender: TObject);
VAR
  sMess: STRING;
  Res : TResourceStream;
BEGIN
  GFTPCtrl:= TFTPCtrl.Create;
  FListModule:= TStringList.Create;

  //Affiche le numéro de version
  Frm_Main.caption := Frm_Main.Caption + ' - Version: ' + GetNumVersionSoft();

  //Initialisation
  bModeVtePriv := false;
  bModeAuto := false;

  Lab_txt.Visible := NOT(bModeVtePriv);

  Tray_Icon.Icon.Handle := Application.Icon.Handle;
  Nbt_VentePrive.Enabled := false;
  Lab_VtePrive.Enabled := false;

  Nbt_NetEvenMenu.Enabled := false;
  Lab_NetEvenMenu.Enabled := false;

  Nbt_WMSTab.Enabled := False;
  Lab_WMSDescr.Enabled := False;
  Tab_WMS.TabVisible := False;

  EnCoursVtePriv := false;
  EnCoursTraiter := false;
  EnCoursLstRapport := false;
  EnCoursTraitement := false;
  Dm_Common.Que_SitePriv.DisableControls;

  GAPPATH := ExtractFilePath(Application.ExeName);
  GGENTMPPATH := GAPPATH + 'TmpGenerique\';
  GGENPATHFACTURE := GGENTMPPATH + 'Factures\';
  GGENPATHCDE := GGENTMPPATH + 'CDE\';
  GGENPATHCSV := GGENTMPPATH + 'CSV\';
  GGENARCHCDE := GGENPATHCDE + 'Archive\';

  IF NOT DirectoryExists(GGENPATHFACTURE) THEN
    ForceDirectories(GGENPATHFACTURE);

  IF NOT DirectoryExists(GGENPATHCSV) THEN
    ForceDirectories(GGENPATHCSV);

  IF NOT DirectoryExists(GGENARCHCDE) THEN
    ForceDirectories(GGENARCHCDE);

  // Extraction de la DLL 7z
  if not FileExists(GAPPATH + '7z.dll') then
  begin
    Res := TResourceStream.Create(HInstance,'7ZDLL',RT_RCDATA);
    try
      Res.SaveToFile(GAPPATH + '7z.dll');
    finally
      Res.Free;
    end;
  end;


  // Init du log
  InitLogFileName(Memo_Log, Lab_Status, 0);

  IF ParamCount > 0 THEN
  BEGIN
    TRY
      // Si on est mode vente privée, on affichera uniquement l'onglet vente privée
      bModeVtePriv := (UpperCase(ParamStr(1)) = 'VTEPRIV');

      // Défini si on est en mode auto ou non
      bModeAuto := (UpperCase(ParamStr(1)) = 'AUTO');

    EXCEPT
      LogAction('ERREUR - Erreur de paramétrage du mode auto', 0);
      Dm_Common.SendLog(bModeAuto);
      Application.Terminate;
    END;
  END;

  sMess := '';
  ChangeBtnQuitter(true);

  IF NOT(FileExists(ChangeFileExt(Application.ExeName, '.ini'))) THEN
  BEGIN
    sMess := 'ERREUR - Fichier INI inexistant, impossible de démarrer l''application';
    LogAction(sMess, 0);
    // Si on est en mode auto, on log, et on dit rien, et on quitte l'appli
    IF bModeAuto THEN
    BEGIN
      Dm_Common.SendLog(bModeAuto);
      Application.Terminate();
    END;
  END;

  MemD_Redo.Open;
  MemD_Redo.Append;
  MemD_RedoDebut.AsDateTime := DateOf(DateUtils.IncDay(Now, -1));
  MemD_RedoFin.AsDateTime := DateOf(DateUtils.IncDay(Now, -1));

  // Création de l'objet inifile
  MyIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  IF sMess <> '' THEN
  // Ereur sur l'ini, on affiche le paramétrage automatiquement
  BEGIN
    ShowMessage(sMess);
    InitParams(); // Chargement des valeurs par défaut
    ActiveOnglet(Tab_DB_Params); // Params base de donnée
  END
  ELSE
  BEGIN // Ok, pas de pb
    Initialize();
    ActiveOnglet(Tab_Menu);

    // lancement de l'onglet vente privée
    IF bModeVtePriv THEN
    BEGIN

      IF Dm_Common.OkSiteWebNetEven THEN
      BEGIN
        Gax_MenuVtePriv.Enabled := false;
      END
      ELSE
      BEGIN
        Nbt_Retour2.Glyph.Assign(Img_Quit.Picture.Bitmap);
        Nbt_Retour2.Caption := '&Quitter';
      END;
      Tray_Icon.ShowMinimizedIcon := true;
      Tray_Icon.Active := false;
      WITH Dm_Common DO
      BEGIN
        TRY
          // Liste des sites actifs
          Que_SitePriv.Active := false;
          Que_SitePriv.Active := true;
        EXCEPT
          ON E: Exception DO
          BEGIN
            LogAction('Erreur (Vente privée): ' + E.Message, 0);
            MessageDlg('Erreur (Vente privée): ' + E.Message, mterror,
              [mbok], 0);
            exit;
          END;
        END;
        Que_SitePriv.EnableControls;
      END;
      Pgc_VtePriv.ActivePage := Tab_ATraiter;
      ActiveOnglet(Tab_VentePrivee);

    END;
  END;

  Dm_Common.ModulesToList(FListModule);

  if (not Chp_GestAccesConcurrentielsFTP.Checked) or // Débraillage de l'option dans les paramètrages (fichier .ini)
     // Si il n'y a que le module WebVente, inutile de gérer les accès concurrentiels
     ((FListModule.IndexOf(cMdl_WEBVENTE) <> -1) and //
      (FListModule.IndexOf(cMdl_EXPORT_FTP) = -1) and
      (FListModule.IndexOf(cMdl_WMS) = -1)) then
    FreeAndNil(GFTPCtrl);

  IF Dm_Common.MyIniParams.sDBPath <> '' THEN
    OpDlg_DBPath.InitialDir := ExtractFilePath(Dm_Common.MyIniParams.sDBPath)
  ELSE
    OpDlg_DBPath.InitialDir := 'C:\Ginkoia\Data';

  Lab_TestResult.Caption := '';
  Lab_Status.Caption := '';

  IF bModeAuto THEN
  BEGIN
    TRY
      LogAction('/************ DEBUT TRAITEMENT AUTO ' + DateTimeToStr(Now()) +
        ' *****************/', 3);

      if FListModule.IndexOf(cMdl_WEBVENTE) <> -1 then
        begin
          ActiveTimer();
          ActiveOnglet(Tab_Traitement);
        end;

      if FListModule.IndexOf(cMdl_EXPORT_FTP) <> -1 then
        begin
          FExportFtpManager.Start;
        end;

      if FListModule.IndexOf(cMdl_WMS) <> -1 then
        begin
          FWMSManager.Start;
        end;

      LogAction('/************ FIN TRAITEMENT AUTO ' + DateTimeToStr(Now()) +
        ' *****************/', 3);
    FINALLY

    END;
  END
  ELSE
  BEGIN
    Show;
    Tray_Icon.NoClose := false;
  END;

  // Rafraichissement initial des données de monitoring
  Tim_RefreshDefaultMonitoringValuesTimer(self);
END;

PROCEDURE TFrm_Main.Nbt_PathDBClick(Sender: TObject);
BEGIN
  IF OpDlg_DBPath.Execute THEN
  BEGIN
    Chp_DBPath.Text := OpDlg_DBPath.Filename;
    Nbt_ValidDBChange.Visible := true;
  END;
END;

PROCEDURE TFrm_Main.Nbt_QuitterClick(Sender: TObject);
BEGIN
  Close;
END;

PROCEDURE TFrm_Main.Nbt_Refresh1Click(Sender: TObject);
BEGIN
  DoVtePrive(Pgc_VtePriv.ActivePage);
END;

PROCEDURE TFrm_Main.Nbt_Retour1Click(Sender: TObject);
BEGIN
  ActiveOnglet(Tab_Menu);
END;

PROCEDURE TFrm_Main.Nbt_Retour2Click(Sender: TObject);
BEGIN
  IF (bModeVtePriv) AND NOT(Dm_Common.OkSiteWebNetEven) THEN
  BEGIN
    Close;
  END
  ELSE
  BEGIN
    ActiveOnglet(Tab_Menu);
    Dm_Common.DBDisconnect;
  END;
END;

PROCEDURE TFrm_Main.Nbt_ValidDBChangeClick(Sender: TObject);
BEGIN
  // Rend invisible le bouton
  Nbt_ValidDBChange.Visible := false;

  // Sauvegarde des données
  SaveParams();

  // Lecture des données
  InitParams();

  // Connection à la base
  IF NOT(Dm_Common.DBReconnect(true)) THEN
  BEGIN
    // Erreur de connection, on vide le champ
    Chp_DBPath.Text := 'Impossible de se connecter à la base de données';
  END;
  Nbt_VentePrive.Enabled := Dm_Common.OkSiteWebVentePriv AND NOT(bModeAuto);
  Lab_VtePrive.Enabled := Dm_Common.OkSiteWebVentePriv AND NOT(bModeAuto);

  Nbt_NetEvenMenu.Enabled := Dm_Common.OkSiteWebNetEven AND NOT(bModeAuto);
  Lab_NetEvenMenu.Enabled := Dm_Common.OkSiteWebNetEven AND NOT(bModeAuto);

  //Initialisation pour le WMS
  InitWMS;

  //Initialisation pour l'Export FTP
  InitExportFtp;
END;

PROCEDURE TFrm_Main.Nbt_VentePriveClick(Sender: TObject);
BEGIN
  IF NOT(Dm_Common.DBReconnect) THEN
  BEGIN
    LogAction('Erreur de connexion à la base de données (Vente privée)', 0);
    exit;
  END;
  WITH Dm_Common DO
  BEGIN
    TRY
      // Liste des sites actifs
      Que_SitePriv.Active := false;
      Que_SitePriv.Active := true;

      IF Que_SitePriv.RecordCount = 0 THEN
      BEGIN
        LogAction(ErrPasDeSiteVentePriv, 1);
        MessageDlg(ErrPasDeSiteVentePriv, mterror, [mbok], 0);
        exit;
      END;
    EXCEPT
      ON E: Exception DO
      BEGIN
        LogAction('Erreur (Vente privée): ' + E.Message, 0);
        MessageDlg('Erreur (Vente privée): ' + E.Message, mterror, [mbok], 0);
        exit;
      END;
    END;
    Que_SitePriv.EnableControls;
  END;
  Pgc_VtePriv.ActivePage := Tab_ATraiter;
  ActiveOnglet(Tab_VentePrivee);
END;

procedure TFrm_Main.Nbt_WMSExecuteClick(Sender: TObject);
begin
  FWMSManager.Execute;
end;

procedure TFrm_Main.Nbt_WMSInitClick(Sender: TObject);
begin
  FWMSManager.Initialize;
end;

procedure TFrm_Main.Nbt_WMSSENDFTPClick(Sender: TObject);
begin
  FWMSManager.ForceUpload;
end;

procedure TFrm_Main.Nbt_WMSTabClick(Sender: TObject);
begin
  ActiveOnglet(Tab_WMS);
end;

procedure TFrm_Main.Nbt_WMSTabRetourClick(Sender: TObject);
begin
  ActiveOnglet(Tab_Menu);
end;

procedure TFrm_Main.Nbt_WMSTestConnexionClick(Sender: TObject);
begin
  FWMSManager.TestFTPConnection;
end;

procedure TFrm_Main.OnWMSGetData(Sender: TObject);
begin
  TFTPSite(Sender).FTPGetData.FileList.CustomSort(SortWMSGetFiles);
end;

PROCEDURE TFrm_Main.SaveParams;
BEGIN
  // Infos Timer
  MyIniFile.WriteString('TIMER', 'DEBUT', MemD_PrmTimerDEBUT.AsString);
  MyIniFile.WriteString('TIMER', 'FIN', MemD_PrmTimerFIN.AsString);
  MyIniFile.WriteString('TIMER', 'INTERVAL', MemD_PrmTimerInterval.AsString);

  // Infos de connection à la BDD
  MyIniFile.WriteString('DATABASE', 'PATH', Chp_DBPath.Text);

  // Logs
  MyIniFile.WriteBool('OPTIONS', 'DELOLDLOG', Chp_DelOldLog.Checked);
  MyIniFile.WriteString('OPTIONS', 'DELOLDLOGAGE', Chp_DelOldLogAge.Text);
  MyIniFile.WriteString('OPTIONS', 'NIVEAU', Chp_LogErreurs.Value);

  MyIniFile.WriteBool('OPTIONS', 'ACCESCONCURRENTSFTP', Chp_GestAccesConcurrentielsFTP.Checked);

  // Infos NETEVEN
  MyIniFile.WriteDateTime('TIMER', 'VERIFHIER', Dm_Common.MyIniParams.dtHier);
  MyIniFile.WriteInteger('TIMER', 'NBHIER', MemD_PrmTimerNbHier.AsInteger);

  // Vente privée  (GENERIQUE_SKU)
  MyIniFile.WriteInteger('GENERIQUE_SKU', 'NbJrsGardeTraite',
    Dm_Common.MyIniParams.NbJrsGardeTraite);
  MyIniFile.WriteInteger('GENERIQUE_SKU', 'NbJrsGardeErreur',
    Dm_Common.MyIniParams.NbJrsGardeErreur);

  // Time Out FTP
  MyIniFile.WriteInteger('TIMEOUT', 'Connect', StrToInt(Chp_ConnectTimeout.Text));

  // Générique
  MyIniFile.WriteBool('GENERIQUE', 'ZIP', bZipper);
  MyIniFile.WriteBool('GENERIQUE', 'DATEFICINIT', bDateFicInit);
  MyIniFile.WriteBool('GENERIQUE', 'DATEFIC', bDateFic);
  MyIniFile.WriteBool('GENERIQUE', 'ENVOIINITJOUR', bEnvoiInitJour);
  MyIniFile.WriteBool('GENERIQUE', 'ENVOIINITSTOCK', bEnvoiInitStock);
END;

PROCEDURE TFrm_Main.BtnSaveClick(Sender: TObject);
BEGIN
  Dm_Common.MyIniParams.NbJrsGardeTraite :=
    StrToIntdef(Chp_NbJrsTraite.Text, 120);
  Dm_Common.MyIniParams.NbJrsGardeErreur :=
    StrToIntdef(Chp_NbJrsErreur.Text, 120);
  // Sauvegarde des paramètres
  SaveParams();

  // Retour à l'onglet 0
  ActiveOnglet(Tab_Menu);
END;

PROCEDURE TFrm_Main.BtnCancelClick(Sender: TObject);
BEGIN

  // Réinit des paramètres
  Initialize();

  // Retour à l'onglet 0
  ActiveOnglet(Tab_Menu);
END;

PROCEDURE TFrm_Main.ActiveOnglet(pTabSheet: TTabSheet);
VAR
  aNumPage: Integer;
  i: Integer;
  b: boolean;
BEGIN
  aNumPage := pTabSheet.PageIndex;

  FOR i := 0 TO Pgc_Params.PageCount - 1 DO
  BEGIN
    b := (i = aNumPage);

    if (Pgc_Params.Pages[i] = Tab_Traitement) then
      b := b or (pTabSheet = Tab_WMS);

    if (Pgc_Params.Pages[i] = Tab_WMS) then
      b := b or ((pTabSheet = Tab_Traitement) and Assigned(FWMSManager) and FWMSManager.Enabled);

    Pgc_Params.Pages[i].Visible := b;
    Pgc_Params.Pages[i].Enabled := b;
    Pgc_Params.Pages[i].TabVisible := b;
  END;

  Pgc_Params.ActivePage := pTabSheet;
END;

PROCEDURE TFrm_Main.Chp_FileChange(Sender: TObject);
BEGIN
  IF Sender.ClassType = TwwDBEditRv THEN
    TwwDBEditRv(Sender).Text := UpperCase(TwwDBEditRv(Sender).Text);
END;

PROCEDURE TFrm_Main.Chp_NbJrsTraiteKeyPress(Sender: TObject; VAR Key: Char);
BEGIN
  IF (Ord(Key) >= 32) AND (Pos(Key, '0123456789') = 0) THEN
    Key := chr(7);
END;

PROCEDURE TFrm_Main.Chp_RepButtonClick(Sender: TObject);
VAR
  s, sav, sDir: STRING;
BEGIN
  s := Chp_Rep.Text;
  IF (Length(s) > 3) AND (s[Length(s)] = '\') THEN
    s := Copy(s, 1, Length(s) - 1);
  sav := s;
  IF SelectDirectory('Sélection de l''emplacement des fichiers', '', s) THEN
  BEGIN
    Chp_Rep.Text := s;
    IF UpperCase(s) <> UpperCase(sav) THEN
      DoVtePrive(Pgc_VtePriv.ActivePage);
  END;
END;

PROCEDURE TFrm_Main.Chp_RepKeyPress(Sender: TObject; VAR Key: Char);
BEGIN
  Key := #0;
END;

PROCEDURE TFrm_Main.Nbt_SendLogClick(Sender: TObject);
BEGIN
  // On demande d'abord le site.
  IF LK_SiteWeb.Execute THEN
  BEGIN
    Dm_Common.LitParams(false);

    Dm_Common.SendLog(true);
  END;
END;

PROCEDURE TFrm_Main.Nbt_SuppRapportClick(Sender: TObject);
VAR
  sDest: STRING;
  sDestRAPPORT: STRING;
  sDestARCHIVE: STRING;
  s: STRING;
BEGIN
  IF NOT(Dm_Common.Que_SitePriv.Active) OR
    (Dm_Common.Que_SitePriv.RecordCount = 0) THEN
    exit;
  IF NOT(MemD_ListeRapport.Active) OR (MemD_ListeRapport.RecordCount = 0) THEN
    exit;
  IF MessageDlg('Supprimer le rapport ?', mtconfirmation, [mbyes, mbno], 0,
    mbno) <> mryes THEN
    exit;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  TRY
    sDest := Dm_Common.Que_SitePriv.fieldbyname('ASF_LOCALFOLDERGET').AsString;
    IF (sDest = '') OR NOT(DirectoryExists(sDest)) THEN
    BEGIN
      MessageDlg('Répertoire paramétré dans Ginkoia invalide !', mterror,
        [mbok], 0);
      exit;
    END;
    IF sDest[Length(sDest)] <> '\' THEN
      sDest := sDest + '\';
    sDestRAPPORT := sDest + 'RAPPORT\';
    sDestARCHIVE := sDest + 'RAPPORT\ARCHIVE\';
    ForceDirectories(sDestRAPPORT);
    ForceDirectories(sDestARCHIVE);
    s := MemD_ListeRapport.fieldbyname('FichierSrc').AsString;
    IF RenameFile(sDestRAPPORT + s, sDestARCHIVE + s) THEN
    BEGIN
      MemD_ListeRapport.Delete;
      Nbt_ImpRapport.Enabled := (MemD_ListeRapport.RecordCount > 0);
      Nbt_AgrandirRapport.Enabled := (MemD_ListeRapport.RecordCount > 0);
      Nbt_SuppRapport.Enabled := (MemD_ListeRapport.RecordCount > 0);
    END
    ELSE
      MessageDlg('Impossible de supprimer le rapport !', mterror, [mbok], 0);
  FINALLY
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  END;
END;

PROCEDURE TFrm_Main.Nbt_SuppRappTraiteClick(Sender: TObject);
VAR
  sDest: STRING;
  sDestOK: STRING;
  sDestOKARCHIVE: STRING;
  s: STRING;
BEGIN
  IF NOT(Dm_Common.Que_SitePriv.Active) OR
    (Dm_Common.Que_SitePriv.RecordCount = 0) THEN
    exit;
  IF NOT(MemD_LstRappTraite.Active) OR (MemD_LstRappTraite.RecordCount = 0) THEN
    exit;
  IF MessageDlg('Supprimer le rapport ?', mtconfirmation, [mbyes, mbno], 0,
    mbno) <> mryes THEN
    exit;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  TRY
    sDest := Dm_Common.Que_SitePriv.fieldbyname('ASF_LOCALFOLDERGET').AsString;
    IF (sDest = '') OR NOT(DirectoryExists(sDest)) THEN
    BEGIN
      MessageDlg('Répertoire paramétré dans Ginkoia invalide !', mterror,
        [mbok], 0);
      exit;
    END;
    IF sDest[Length(sDest)] <> '\' THEN
      sDest := sDest + '\';
    sDestOK := sDest + 'OK\';
    sDestOKARCHIVE := sDest + 'OK\ARCHIVE\';
    ForceDirectories(sDestOK);
    ForceDirectories(sDestOKARCHIVE);
    s := MemD_LstRappTraite.fieldbyname('FichierSrc').AsString;
    IF RenameFile(sDestOK + s, sDestOKARCHIVE + s) THEN
    BEGIN
      MemD_LstRappTraite.Delete;
      Nbt_SuppRappTraite.Enabled := (MemD_LstRappTraite.RecordCount > 0);
    END
    ELSE
      MessageDlg('Impossible de supprimer le rapport !', mterror, [mbok], 0);
  FINALLY
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  END;
END;

PROCEDURE TFrm_Main.Nbt_ForceFTPSendClick(Sender: TObject);
BEGIN
  // On demande d'abord le site.
  IF LK_SiteWeb.Execute THEN
  BEGIN
    Dm_Common.LitParams(false);

    Dm_Common.FTPFolderProcess();
  END;
END;

PROCEDURE TFrm_Main.Nbt_ImpRapportClick(Sender: TObject);
VAR
  sDest: STRING;
  sDestRAPPORT: STRING;
  sDestARCHIVE: STRING;
  s: STRING;
  sFic: STRING;
  dRapp: TDateTime;
BEGIN
  IF NOT(Dm_Common.Que_SitePriv.Active) OR
    (Dm_Common.Que_SitePriv.RecordCount = 0) THEN
    exit;
  sDest := Dm_Common.Que_SitePriv.fieldbyname('ASF_LOCALFOLDERGET').AsString;
  IF (sDest = '') OR NOT(DirectoryExists(sDest)) THEN
  BEGIN
    MessageDlg('Répertoire paramétré dans Ginkoia invalide !', mterror,
      [mbok], 0);
    exit;
  END;
  IF sDest[Length(sDest)] <> '\' THEN
    sDest := sDest + '\';
  sDestRAPPORT := sDest + 'RAPPORT\';
  sDestARCHIVE := sDest + 'RAPPORT\ARCHIVE\';
  ForceDirectories(sDestRAPPORT);
  ForceDirectories(sDestARCHIVE);
  IF NOT(MemD_ListeRapport.Active) OR (MemD_ListeRapport.RecordCount = 0) THEN
    exit;
  s := MemD_ListeRapport.fieldbyname('FichierSrc').AsString;
  sFic := MemD_ListeRapport.fieldbyname('Fichier').AsString;
  dRapp := Trunc(MemD_ListeRapport.fieldbyname('JDATE').AsDateTime) +
    Frac(MemD_ListeRapport.fieldbyname('JTIME').AsDateTime);

  Frm_RapportAgrandi := TFrm_RapportAgrandi.Create(Self);
  TRY
    Frm_RapportAgrandi.InitEcr(sDestRAPPORT + s, sFic, dRapp);
    Frm_RapportAgrandi.Pan_RappGrand.Nbt_Print.Click;
  FINALLY
    Frm_RapportAgrandi.Free;
    Frm_RapportAgrandi := NIL;
  END;
END;

procedure TFrm_Main.Nbt_InitialisationClick(Sender: TObject);
begin
  if SetTraitementEnCours(true) then
  begin
    try
      DoInitialisation;
    finally
      SetTraitementEnCours(false);
    end;
  end;
end;

PROCEDURE TFrm_Main.Nbt_NetEvenMenuClick(Sender: TObject);
BEGIN
  ActiveOnglet(Tab_NetEven);
END;

FUNCTION TFrm_Main.TraitementToDo: boolean;
BEGIN
  // Result := False;
  TRY
    // Est ce qu'on est en période de réplication ?
    IF (hDebReplic <= Now) AND (Now <= hFinReplic) THEN
    BEGIN
      Result := MappingOK;
    END
    ELSE
    BEGIN
      Result := false;
    END;
  EXCEPT
    ON E: Exception DO
    BEGIN
      Result := false;
    END;
  END;
END;

PROCEDURE TFrm_Main.Tim_DoTraitementTimer(Sender: TObject);
BEGIN
  if GFTPCtrl <> nil then
    begin
      if not GFTPCtrl.IsBusy then
        GFTPCtrl.Start(cMdl_WEBVENTE)
      else
        begin
          LogAction(Format('FTP occupé : %s - Le traitement sera effectué au prochain cycle.', [cMdl_WEBVENTE]), 2);
          Exit;
        end;
    end;

  try

    Tim_DoTraitement.Enabled := false;
    try
      if SetTraitementEnCours(true) then
      begin
        TRY
          // Initialisation
          Initialize();

          // Vérifie si on doit effectuer
          IF TraitementToDo THEN
          BEGIN
            // Fait le traitement
            DoTraitement();
          END;
        FINALLY
          // Fermeture des connexions
          FinTraitement();
          SetTraitementEnCours(false);
        END;
      end;
    except
      on e : exception do
        LogAction('Exception dans "TFrm_Main.Tim_DoTraitementTimer" : ' + e.Message, 1);
    end;

  finally
    if GFTPCtrl <> nil then
      GFTPCtrl.Finish(cMdl_WEBVENTE);

    // Réactivation du timer
    ActiveTimer();
  end;

END;

PROCEDURE TFrm_Main.Tim_GetRapportTimer(Sender: TObject);
BEGIN
  IF EnCoursLstRapport THEN
    exit;
  Tim_GetRapport.Enabled := false;
  IF Pgc_VtePriv.ActivePage = Tab_Erreurs THEN
    DoGetRapport;
END;

procedure TFrm_Main.Tim_RefreshDefaultMonitoringValuesTimer(Sender: TObject);
begin
  Dm_Common.Que_GetSites.Close;
  Dm_Common.Que_GetSites.Open;
  // Pour chaque site
  while not Dm_Common.Que_GetSites.Eof do
  begin
    if Dm_Common.LitParams(true) then
    begin
      AddMonitoring('OK', logInfo, mdltMain, apptSyncWeb, Dm_Common.MySiteParams.iMagID, True);

      if Dm_Common.TestConnexions then
        AddMonitoring('OK', logInfo, mdltFTP, apptSyncWeb, Dm_Common.MySiteParams.iMagID, True);
    end;
    Dm_Common.Que_GetSites.Next;
  end;
  Dm_Common.Que_GetSites.Close;


  FWMSManager.RefreshDefaultMonitoringValues;
end;

PROCEDURE TFrm_Main.Tim_VtePrivTimer(Sender: TObject);
BEGIN
  IF EnCoursVtePriv THEN
    exit;
  Tim_VtePriv.Enabled := false;
  DoVtePrive(Pgc_VtePriv.ActivePage);
END;

PROCEDURE TFrm_Main.SetTimerInterval;
VAR
  hNextPeriode: TDateTime;
  iNextPeriodeMS: Integer;
BEGIN
  MajDebFinTimer;

  // Bloc de calcul de l'intervale du timer
  TRY
    // Init random
    Randomize();

    // Est ce qu'on est en période de réplication (à 1h près)
    IF ((hDebReplic - (1 / 24)) <= Now) AND (Now <= hFinReplic) THEN
    BEGIN
      // On set l'intervalle avec l'interval habituel + un temps aléatoire pour etaler sur la période les magasins
      // intervale + ou - 30 secondes

      Tim_DoTraitement.Interval := MyPrmTimer.iIntervale + Trunc(Random(30000));

    END
    ELSE
    BEGIN
      // On set l'intervalle hors réplic
      // on calcule le prochain lancement, pour mettre l'intervalle comme il faut
      IF hDebReplic <= Now THEN
        hNextPeriode := ((hDebReplic + 1) - Now)
      ELSE
        hNextPeriode := hDebReplic - Now;

      // On se met 10 minutes avant le prochain lancement prévu
      hNextPeriode := hNextPeriode - (10 / (24 * 60));

      // On transforme en millisecondes et on fait - 2h pour gérer le passage à l'heure d'été
      iNextPeriodeMS := Trunc(hNextPeriode * 24 * 60 * 60 * 1000) -
        (2 * 60 * 60 * 1000);

      IF iNextPeriodeMS <= 0 THEN
        iNextPeriodeMS := 60 * 60 * 1000;

      // On set le prochain timer
      Tim_DoTraitement.Interval := iNextPeriodeMS;

    END;
  EXCEPT
    ON E: Exception DO
    BEGIN
      // En cas d'exception, on relance le timer pour un intervale fixe, afin de réessayer
      Tim_DoTraitement.Interval := MyPrmTimer.iIntervale;
    END;
  END;

  LogAction('Prochain time dans (ms) : ' + IntToStr(Tim_DoTraitement.Interval) +
    ' (' + FormatDateTime('HH:MM:SS', Now() + (Tim_DoTraitement.Interval /
    (24 * 60 * 60 * 1000))) + ')', 3);

  Tray_Icon.Hint := 'Ginkoia - Commandes WEB' + #13#10 + 'Prochain time à ' +
    FormatDateTime('HH:MM:SS', Now() + (Tim_DoTraitement.Interval /
    (24 * 60 * 60 * 1000)));

END;

function TFrm_Main.SetTraitementEnCours(aEtat: boolean): boolean;
begin
  Result := false;
  if EnCoursTraitement = not aEtat then
  begin
    EnCoursTraitement := aEtat;
//    Nbt_DoTraitement.Enabled := not aEtat;
//    Nbt_Initialisation.Enabled := not aEtat;
    Pan_Boutons.Enabled := not aEtat;
    Application.ProcessMessages;
    result := true;
  end;
end;

PROCEDURE TFrm_Main.MajDebFinTimer;
BEGIN
  InitPrmTimer;

  // Récup de l'heure de début de réplic pour aujourd'hui
  hDebReplic := Trunc(Now) + Frac(MyPrmTimer.dtReplicBegin);

  // Récup de la fin de réplic
  hFinReplic := Trunc(Now) + Frac(MyPrmTimer.dtReplicEnd);
  IF MyPrmTimer.dtReplicBegin > MyPrmTimer.dtReplicEnd THEN
  // La fin est avant le début, donc fin le lendemain
    hFinReplic := hFinReplic + 1;

END;

function TFrm_Main.MappingOK: boolean;
begin
  Result := (NOT MapGinkoia.Backup) AND (NOT MapGinkoia.Launcher) AND
    (NOT MapGinkoia.Verifencours) AND (NOT MapGinkoia.LiveUpdate);
end;

PROCEDURE TFrm_Main.Memo_LogChange(Sender: TObject);
BEGIN
  IF Dm_Common.bCopyMemoNetEven THEN
  BEGIN
    Memo_NetEven.Lines.Insert(0, Memo_Log.Lines[0]);
  END;
END;

function TFrm_Main.ModuleIsEnabled(AModuleName: string): boolean;
begin
  Result := FListModule.IndexOf(AModuleName) <> -1;
end;

PROCEDURE TFrm_Main.InitPrmTimer;
VAR
  iIntervale: Integer;
BEGIN

  // Init du memdata
  MemD_PrmTimer.Close;
  MemD_PrmTimer.Open;
  MemD_PrmTimer.Append;

  // Heure de début
  MyPrmTimer.dtReplicBegin := StrToTime(MyIniFile.ReadString('TIMER', 'DEBUT',
    '08:00'));
  MemD_PrmTimerDEBUT.AsDateTime := MyPrmTimer.dtReplicBegin;

  // Heure de fin
  MyPrmTimer.dtReplicEnd := StrToTime(MyIniFile.ReadString('TIMER', 'FIN',
    '17:00'));
  MemD_PrmTimerFIN.AsDateTime := MyPrmTimer.dtReplicEnd;

  // Intervale
  iIntervale := MyIniFile.ReadInteger('TIMER', 'INTERVAL', 300);
  MemD_PrmTimerInterval.AsInteger := iIntervale;

  MemD_PrmTimerNbHier.AsInteger := MyIniFile.ReadInteger('TIMER', 'NBHIER', 4);

  MyPrmTimer.iIntervale := iIntervale * 1000;

  MemD_PrmTimer.Post;
END;

procedure TFrm_Main.InitWMS;
var
  Buffer: String;
begin
  Buffer := GAPPATH + 'Logs\';
  IF NOT DirectoryExists(Buffer) THEN
    ForceDirectories(Buffer);

  PurgeOldLogs(Dm_Common.MyIniParams.bDelOldLog, Dm_Common.MyIniParams.iDelOldLogAge);

  FWMSManager := TFTPManager.Create(Dm_Common.Ginkoia, DM_Common.IbT_Modif, apptWMS, cMdl_WMS, '18', '2',
                                    GGENTMPPATH + 'WMS\', Buffer + 'WMS\',
                                    WMSManagerAddMonitoring, False, True, 'TXT', False);
  FWMSManager.OnLogEvent := WMSManagerLog;
  FWMSManager.OnAfterStart := WMSManagerAfterStart;
  FWMSManager.OnGetData:= OnWMSGetData;

  Nbt_WMSTab.Enabled := FWMSManager.Enabled;
  Lab_WMSDescr.Enabled := Nbt_WMSTab.Enabled;
end;

PROCEDURE TFrm_Main.Pgc_VtePrivPageChanging(Sender: TObject;
  NewPage: TcxTabSheet; VAR AllowChange: boolean);
BEGIN
  DoVtePrive(NewPage);
END;

PROCEDURE TFrm_Main.Pgc_ParamsChange(Sender: TObject);
BEGIN
  IF Pgc_Params.ActivePage <> Tab_VentePrivee THEN
    Dm_Common.Que_SitePriv.DisableControls;
END;

PROCEDURE TFrm_Main.PopQuitterClick(Sender: TObject);
VAR
  bOk: boolean;
BEGIN
  Frm_Confirmation := TFrm_Confirmation.Create(Self);
  TRY
    bOk := (Frm_Confirmation.ShowModal = mrOk);
  FINALLY
    Frm_Confirmation.Free;
    Frm_Confirmation := NIL;
  END;
  IF bOk THEN
  BEGIN
    Tray_Icon.NoClose := false;
    Close;
  END;
END;

PROCEDURE TFrm_Main.PopRestaureClick(Sender: TObject);
BEGIN
  Show;
  FormStyle := FsStayOnTop;
  Application.ProcessMessages;
  FormStyle := FsNormal;
  Screen.ActiveForm.BringToFront;
  IF bModeAuto THEN
    Tray_Icon.NoClose := true;
END;

PROCEDURE TFrm_Main.FormActivate(Sender: TObject);
BEGIN
  IF bModeVtePriv THEN
  BEGIN
    IF (Dm_Common.Que_SitePriv.RecordCount = 0) THEN
    BEGIN
      IF NOT(Dm_Common.OkSiteWebNetEven) THEN
      BEGIN
        // si on est en mode vente privée et qu'il n'ya pas de site--> on sort
        Application.ProcessMessages;
        LogAction(ErrPasDeSiteVentePriv, 1);
        MessageDlg(ErrPasDeSiteVentePriv, mterror, [mbok], 0);
        PostMessage(Handle, WM_CLOSE, 0, 0);
        // N'utilise pas le close, car marche pas dans FormActivate
      END
      ELSE
      BEGIN
        ActiveOnglet(Tab_NetEven);
      END;
    END;
  END;
END;

PROCEDURE TFrm_Main.FormCloseQuery(Sender: TObject; VAR CanClose: boolean);
BEGIN
  IF NOT(bModeVtePriv) AND Tray_Icon.NoClose THEN
  BEGIN
    Hide;
    CanClose := false;
  END;
END;

PROCEDURE TFrm_Main.Tray_IconDblClick(Sender: TObject);
BEGIN
  PopRestaure.Click;
END;

PROCEDURE TFrm_Main.ActiveTimer;
BEGIN
  Hide;
  Nbt_ActiverModeAuto.Enabled := false;
  Tray_Icon.NoClose := true;
  ChangeBtnQuitter(false);

  SetTimerInterval();

  Tim_DoTraitement.Enabled := true;
END;

procedure TFrm_Main.ApplicationEvents1Exception(Sender: TObject; E: Exception);
begin
  if not(E is EIdConnClosedGracefully) then
  begin
    try
      LogAction(E.Message, 0);
    except
      MessageDlg(E.Message, mterror, [mbok], 0);
    end;
  end;
end;

PROCEDURE TFrm_Main.DBG_ATraiterVtePrivDblClick(Sender: TObject);
BEGIN
  WITH Dm_Common.MemD_ATraiterVtePriv DO
  BEGIN
    IF NOT(Active) OR (RecordCount = 0) THEN
      exit;
    Edit;
    IF fieldbyname('ATraiter').AsInteger = 1 THEN
      fieldbyname('ATraiter').AsInteger := 0
    ELSE
      fieldbyname('ATraiter').AsInteger := 1;
    Post;
  END;
END;

procedure TFrm_Main.SuppressionVieuxFichiers(const sRepertoire: String; const Niveau: TNiveau; const nAnnee, nMois: Integer);
{$REGION 'SuppressionVieuxFichiers'}
  function RepertoireVide(const sRepertoire: String): Boolean;
  var
    sr: TSearchRec;
  begin
    Result := True;
    if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
    begin
      repeat
        if(sr.Name <> '.') and (sr.Name <> '..') then
        begin
          Result := False;
          Break;
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  end;

  function SupprimerRepertoire(const sRepertoire: String): Boolean;
  var
    SHFileOpStruct: TSHFileOpStruct;
  begin
    Result := False;
    if SysUtils.DirectoryExists(sRepertoire) then
    begin
      ZeroMemory(@SHFileOpStruct, SizeOf(SHFileOpStruct));
      SHFileOpStruct.wFunc := FO_DELETE;
      SHFileOpStruct.fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
      SHFileOpStruct.pFrom := PChar(sRepertoire + #0);
      Result := (0 = ShFileOperation(SHFileOpStruct));
    end;
  end;
{$ENDREGION}
var
  sr: TSearchRec;
  nTmp: Integer;
  DateRepertoire: TDateTime;
begin
  if Niveau = Annee then
    LogAction('Purge répertoire [' + sRepertoire + '] ...', 3);

  if FindFirst(IncludeTrailingPathDelimiter(sRepertoire) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(sr.Name <> '.') and (sr.Name <> '..') then
      begin
        // Si répertoire.
        if(sr.Attr and faDirectory) = faDirectory then
        begin
          case Niveau of
            Annee:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  SuppressionVieuxFichiers(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, Mois, nTmp);

                  // Si répertoire 'année' vide.
                  if RepertoireVide(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  begin
                    if RemoveDir(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      LogAction('Répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.', 3)
                    else
                      LogAction('# Échec suppression répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !', 1);
                  end;
                end
                else
                  LogAction('# Erreur nom répertoire année [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !', 1);
              end;

            Mois:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  SuppressionVieuxFichiers(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name, Jour, nAnnee, nTmp);

                  // Si répertoire 'mois' vide.
                  if RepertoireVide(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                  begin
                    if RemoveDir(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      LogAction('Répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.', 3)
                    else
                      LogAction('# Échec suppression répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !', 1);
                  end;
                end
                else
                  LogAction('# Erreur nom répertoire mois [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !', 1);
              end;

            Jour:
              begin
                if TryStrToInt(sr.Name, nTmp) then
                begin
                  DateRepertoire := EncodeDate(nAnnee, nMois, nTmp);

                  // Si date répertoire antérieure au nombre de jours de conservation.
                  if CompareDateTime(IncDay(DateRepertoire, nNbJoursPurgeRepSend), Now) = -1 then
                  begin
                    // Suppression du répertoire.
                    if SupprimerRepertoire(IncludeTrailingPathDelimiter(sRepertoire) + sr.Name) then
                      LogAction('Répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] supprimé.', 3)
                    else
                      LogAction('# Échec suppression répertoire [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !', 1);
                  end;
                end
                else
                  LogAction('# Erreur nom répertoire jour [' + IncludeTrailingPathDelimiter(sRepertoire) + sr.Name + '] !', 1);
              end;
          end;
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

function IfThen(const bValeur, bVrai: Boolean; const bFaux: Boolean = False): Boolean;   overload;
begin
  if bValeur then
    Result := bVrai
  else
    Result := bFaux;
end;

FUNCTION TFrm_Main.DoTraitement: boolean;
var
  dLastDateArt: TDateTime;
  dLastDateStk: TDateTime;
  dLastDateInit : TDateTime;
  dTimeDebut: Extended;
  dTimeFin: Extended;
  bInitialisation : boolean;

BEGIN
  Result := True;

  if nNbJoursPurgeRepSend > 0 then
  begin
    // Suppression des vieux fichiers.
    SuppressionVieuxFichiers(GGENPATHCSV + 'Send');
  end;

  WITH Dm_Common DO
  BEGIN
    IF NOT DBReconnect THEN
    BEGIN
      LogAction('Erreur de connexion à la base de données', 0);
      exit;
    END;

    //si auto on controle les date de dernier traitement, si manu on lance.
    if bModeAuto then
    begin
      with TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini')) do
      try
        // Récupération de la dernière heure de traitement
        dLastDateArt := ReadDateTime('GENERIQUE', 'DATETIMEART', DateOf(Now) + GetParamFloat(400));
        dLastDateStk := ReadDateTime('GENERIQUE', 'DATETIMESTK', DateOf(Now) + GetParamFloat(402));
        dTimeDebut := Chp_TimerDeb.Time;
        dTimeFin := Chp_TimerFin.Time;
        dLastDateInit := ReadDateTime('GENERIQUE', 'DATETIMEINIT', EncodeDate(1899, 12, 30));
        if bEnvoiInitJour and (CompareDateTime(DateOf(dLastDateInit), Today) < 0) then
        begin
          bInitialisation := True;
          LogAction('>> Premier envoi du jour : Passage en Initialisation', 2);
        end
        else if(not bEnvoiInitJour) and bEnvoiInitStock and (CompareDateTime(DateOf(dLastDateInit), Today) < 0) then
        begin
          bInitialisation := True;
          LogAction('>> Premier envoi du jour : Passage en Initialisation (stock)', 2);
        end;
      finally
        Free;
      end;
    end
    else
    begin
      dLastDateArt := 0;
      dLastDateStk := 0;
      dTimeDebut := 0;
      dTimeFin := 0;
      with TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini')) do
      try
        // Récupération de la dernière heure de traitement
        dLastDateInit := ReadDateTime('GENERIQUE', 'DATETIMEINIT', EncodeDate(1899, 12, 30));
        if bEnvoiInitJour and (CompareDateTime(DateOf(dLastDateInit), Today) < 0) then
        begin
          bInitialisation := true;
          LogAction('>> Premier envoi du jour : Passage en Initialisation', 2);
        end
        else if(not bEnvoiInitJour) and bEnvoiInitStock and (CompareDateTime(DateOf(dLastDateInit), Today) < 0) then
        begin
          bInitialisation := True;
          LogAction('>> Premier envoi du jour : Passage en Initialisation (stock)', 2);
        end;
      finally
        Free;
      end;
    end;
    //Récupération de la date de dernier INIT


    Que_GetSites.Close;
    Que_GetSites.Open;
    // Pour chaque site
    WHILE NOT Que_GetSites.Eof DO
    BEGIN
      LogAction('********** ' + Que_GetSitesASS_NOM.AsString + ' **********', 3);
      IF LitParams(true) THEN
      BEGIN
        AddMonitoring('Début traitement', logNotice, mdltMain, apptSyncWeb, MySiteParams.iMagID, True);
        MySiteParams.bZipper := bZipper;
        MySiteParams.bDateFicInit := bDateFicInit;
        MySiteParams.bDateFic := bDateFic;
        MySiteParams.bEnvoiInitJour := bEnvoiInitJour;
        MySiteParams.bEnvoiInitStock := bEnvoiInitStock;

        IF MySiteParams.bGet THEN
        BEGIN
          LogAction('¤¤¤¤¤¤¤¤¤¤ Début réception ¤¤¤¤¤¤¤¤¤¤', 3);
          // Phase 1 : Récupération des infos et insertion
          TRY
            DoGet(dTimeDebut, dTimeFin);

            // Au cas ou elle aie changé
            MyIniFile.WriteDateTime('TIMER', 'VERIFHIER',
              Dm_Common.MyIniParams.dtHier);
          EXCEPT
            ON E: Exception DO
            BEGIN
              LogAction('Erreur lors de la réception, site : ' +
                Que_GetSitesASS_NOM.AsString, 0);
              LogAction(E.Message, 0);

              AddMonitoring('Erreur lors de la réception, site : ' +
                Que_GetSitesASS_NOM.AsString, logError, mdltImport, apptSyncWeb, MySiteParams.iMagID);
            END;
          END;
          LogAction('¤¤¤¤¤¤¤¤¤¤ Fin réception ¤¤¤¤¤¤¤¤¤¤', 3);
        END;

        IF MySiteParams.bSend THEN
        BEGIN
          LogAction('¤¤¤¤¤¤¤¤¤¤ Début envoi ¤¤¤¤¤¤¤¤¤¤', 3);
          TRY
            if (Que_GetSites.RecNo <> Que_GetSites.RecordCount) then
              DoSend(dTimeDebut, dTimeFin, False, dLastDateArt, dLastDateStk, bInitialisation, IfThen(not bEnvoiInitJour, bEnvoiInitStock))
            else
              DoSend(dTimeDebut, dTimeFin, True, dLastDateArt, dLastDateStk, bInitialisation, IfThen(not bEnvoiInitJour, bEnvoiInitStock));
          EXCEPT
            ON E: Exception DO
            BEGIN
              LogAction('Erreur lors de l''envoi, site : ' +
                Que_GetSitesASS_NOM.AsString, 0);
              LogAction(E.Message, 0);

              AddMonitoring('Erreur lors de l''envoi, site : ' +
                Que_GetSitesASS_NOM.AsString, logError, mdltExport, apptSyncWeb, MySiteParams.iMagID);
            END;
          END;
          LogAction('¤¤¤¤¤¤¤¤¤¤ Fin Envoi ¤¤¤¤¤¤¤¤¤¤', 3);
        END;
        AddMonitoring('Fin traitement', logInfo, mdltMain, apptSyncWeb,
          MySiteParams.iMagID, False, Trunc(Tim_DoTraitement.Interval / 1000));
      END
      ELSE
      BEGIN
        LogAction(
          '/************ Erreur de paramétrage, impossible de démarrer le traitement *****************/',
          0);
        LogAction(Que_GetSitesASS_NOM.AsString, 0);
        LogAction(
          '/******************************************************************************************/',
          0);

        AddMonitoring('Erreur de paramétrage, site : ' + Que_GetSitesASS_NOM.AsString ,
          logError, mdltMain, apptSyncWeb, 0);
      END;
      LogAction('***********************************', 3);

      Que_GetSites.Next;
    END;
    Que_GetSites.Close;

    // Vérifie s'il y'a eu des erreurs, et les envoyer dans ce cas
    IF iNbLog > 0 THEN
    BEGIN
      SendLog(bModeAuto);
    END;

    // Déconnection de la DB
    DBDisconnect;
  END;
END;

function TFrm_Main.DoInitialisation: Boolean;
begin
  // Connexion à la base de données
  if not(Dm_Common.DBReconnect()) then
  begin
    LogAction('Erreur de connexion à la base de données', 0);
    Exit;
  end;

  if Dm_Common.Que_GetSites.Active then
    Dm_Common.Que_GetSites.Close();
  Dm_Common.Que_GetSites.Open();

  while not(Dm_Common.Que_GetSites.Eof) do
  begin
    LogAction(Format('********** %s **********', [Dm_Common.Que_GetSites.FieldByName('ASS_NOM').AsString]), 3);

    if Dm_Common.LitParams(True) then
    begin
      // L'initialisation ne fonctionne qu'avec les sites Générique
      Dm_Common.MySiteParams.bZipper := bZipper;
      Dm_Common.MySiteParams.bDateFicInit := bDateFicInit;
      Dm_Common.MySiteParams.bDateFic := bDateFic;
      Dm_Common.MySiteParams.bEnvoiInitJour := bEnvoiInitJour;
      Dm_Common.MySiteParams.bEnvoiInitStock := bEnvoiInitStock;

      if Dm_Common.MySiteParams.bSend and SameStr(Dm_Common.MySiteParams.sTypeSend, 'GENERIQUE') then
      begin
        LogAction('¤¤¤¤¤ Début de l''envoi de l''initialisation ¤¤¤¤¤', 3);
        try
          // init déclenché volontairement. pas de controle de date de dernier traitement
          //Dm_Common.DoSend(Chp_TimerDeb.Time, Chp_TimerFin.Time, Dm_Common.Que_GetSites.Eof, 0, 0, True);
          Dm_Common.DoSend(0, 0, Dm_Common.Que_GetSites.Eof, 0, 0, True, bEnvoiInitStock);
        except
          on E: Exception do
          begin
            LogAction(Format('Erreur lors de l''envoi pour le site'#160': %s', [Dm_Common.Que_GetSites.FieldByName('ASS_NOM').AsString]), 0);
            LogAction(Format('%s'#160': %s', [E.ClassName, E.Message]), 0);
          end;
        end;
        LogAction('¤¤¤¤¤ Fin de l''envoi de l''initialisation ¤¤¤¤¤', 3);
      end;
    end
    else
    begin
      LogAction('/************ Erreur de paramétrage, impossible de démarrer le traitement *****************/', 0);
      LogAction(Dm_Common.Que_GetSites.FieldByName('ASS_NOM').AsString, 0);
      LogAction('/******************************************************************************************/', 0);
    end;

    LogAction('***********************************', 3);
    Dm_Common.Que_GetSites.Next();
  end;
end;

PROCEDURE TFrm_Main.Ds_ListeRapportDataChange(Sender: TObject; Field: TField);
BEGIN
  IF NOT(EnCoursVtePriv) THEN
    DoGetRapport;
END;

PROCEDURE TFrm_Main.Ds_SiteVtePrivDataChange(Sender: TObject; Field: TField);
VAR
  s: STRING;
BEGIN
  IF Dm_Common.Que_SitePriv.Active AND
    (Dm_Common.Que_SitePriv.RecordCount > 0) THEN
  BEGIN
    s := Dm_Common.Que_SitePriv.fieldbyname('ASF_LOCALFOLDERGET').AsString;
    Chp_Rep.Text := s;
  END
  ELSE
  BEGIN
    Lab_RepInvalid.Visible := false;
    Chp_Rep.Text := '';
  END;
  DoVtePrive(Pgc_VtePriv.ActivePage);
END;

procedure TFrm_Main.ExportFtpManagerAddMonitoring(Sender: TObject;
  AMessage: string; ALogLevel: TLogLevel; AMdlType: TMonitoringMdlType;
  AAppType: TMonitoringAppType; ACurrentMag: integer; AForceStatus: boolean;
  AFrequency: integer);
begin
  AddMonitoring(AMessage, ALogLevel, AMdlType, AAppType, ACurrentMag,
                AForceStatus, AFrequency);
end;

procedure TFrm_Main.ExportFtpManagerAfterStart(Sender: TObject);
begin
  Nbt_ExportFTPActiveModeAuto.Enabled := False;
end;

procedure TFrm_Main.ExportFtpManagerLog(Sender: TObject; ALog: string;
  AFTPLogLvl: TFTPLogLevel);
VAR
  F: TextFile;
BEGIN
  TRY
    IF Integer(AFTPLogLvl) <= Dm_Common.MyIniParams.iNiveauLog THEN
    BEGIN
      if (Sender is TFTPSite) then
      begin
        uFTPUtils.WriteErrorLog(TFTPSite(Sender).LogFilePath, ALog);
        TFTPSite(Sender).HasErrors := True;
      end;
    END;

    Memo_ExportFTPLogs.Lines.Insert(0, FormatDateTime('dd/mm/yyyy hh:mm:ss', Date + Time) + ' : ' + ALog);
    Memo_ExportFTPLogs.Update;

  EXCEPT
    On E: Exception do
      Memo_ExportFTPLogs.Lines.Add(E.Message);
  END;
end;

PROCEDURE TFrm_Main.Nbt_ActiverModeAutoClick(Sender: TObject);
BEGIN
  IF (MappingOK()) AND (Dm_Common.DBReconnect(True)) THEN
  BEGIN
    Dm_Common.DBDisconnect;

    bModeAuto := true;

    Nbt_VentePrive.Enabled := Dm_Common.OkSiteWebVentePriv AND NOT(bModeAuto);
    Lab_VtePrive.Enabled := Dm_Common.OkSiteWebVentePriv AND NOT(bModeAuto);

    Nbt_NetEvenMenu.Enabled := Dm_Common.OkSiteWebNetEven AND NOT(bModeAuto);
    Lab_NetEvenMenu.Enabled := Dm_Common.OkSiteWebNetEven AND NOT(bModeAuto);

    ActiveTimer;

    FWMSManager.Start;
  END
  ELSE
  BEGIN
    LogAction(
      'Impossible de démarrer le mode automatique, connexion à la base impossible',
      0);
  END;

END;

PROCEDURE TFrm_Main.Nbt_AddRegistreClick(Sender: TObject);
VAR
  MyReg: TRegistry;
  TS: TStrings;
  sCurVal: STRING;
  sValue: STRING;
  i: Integer;
BEGIN
  // Lecture de la base de registre
  MyReg := TRegistry.Create;
  TRY
    try

      // Se positionne dans HKLM
      MyReg.RootKey := HKEY_LOCAL_MACHINE;

      // Ouvre la clé et la crée si elle n'existe pas
      IF MyReg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run\',
        false) THEN
      BEGIN
        // Recherche si une ancienne version est présente et la supprime
        TS := TStringList.Create;
        TRY
          MyReg.GetValueNames(TS);
          FOR i := 0 TO TS.Count - 1 DO
          BEGIN
            sCurVal := TS[i];
            IF MyReg.GetDataType(sCurVal) = rdString THEN
            BEGIN
              TRY
                sValue := UpperCase(MyReg.ReadString(sCurVal));
                IF (Pos('COMMANDESNETEVEN', sValue) > 0) OR
                  (Pos('COMMANDESWEB', sValue) > 0) THEN
                BEGIN
                  LogAction('Valeur de registre (' + sCurVal + ' -> ' + sValue +
                    ') supprimée', 0);
                  MyReg.DeleteValue(sCurVal);
                END;
              EXCEPT
                // On zappe, si c'est pas une chaine, on a pas besoin de la supprimer
              END;
            END;
          END;
        FINALLY
          TS.Free;
        END;

        // Recherche si la valeur existe déjà
        IF MyReg.ValueExists('GinkoSyncWeb') THEN
        BEGIN
          LogAction(
            'Clé de registre (GinkoSyncWeb) déjà existante, mise à jour', 0);
          // Maintenant, on crée la nouvelle valeur
          MyReg.WriteString('GinkoSyncWeb', Application.ExeName + ' AUTO');
        END
        ELSE
        BEGIN
          LogAction('Clé de registre (GinkoSyncWeb) créée', 0);
          // Maintenant, on crée la nouvelle valeur
          MyReg.WriteString('GinkoSyncWeb', Application.ExeName + ' AUTO');
        END;
        MessageDlg('Démarrage automatique du programme activé.', mtinformation,
          [mbok], 0);
      END
      ELSE
      BEGIN
        LogAction(
          'Clé de registre (Run) non trouvée, impossible d''effectuer le paramétrage',
          0);
      END;

    except
      on E: Exception do
        LogAction('Erreur dans Nbt_AddRegistreClick : ' + E.Message, 0);
    end;

  FINALLY
    MyReg.Free;
  END;

END;

PROCEDURE TFrm_Main.Nbt_AgrandirRapportClick(Sender: TObject);
VAR
  sDest: STRING;
  sDestRAPPORT: STRING;
  sDestARCHIVE: STRING;
  s: STRING;
  sFic: STRING;
  dRapp: TDateTime;
BEGIN
  IF NOT(Dm_Common.Que_SitePriv.Active) OR
    (Dm_Common.Que_SitePriv.RecordCount = 0) THEN
    exit;
  sDest := Dm_Common.Que_SitePriv.fieldbyname('ASF_LOCALFOLDERGET').AsString;
  IF (sDest = '') OR NOT(DirectoryExists(sDest)) THEN
  BEGIN
    MessageDlg('Répertoire paramétré dans Ginkoia invalide !', mterror,
      [mbok], 0);
    exit;
  END;
  IF sDest[Length(sDest)] <> '\' THEN
    sDest := sDest + '\';
  sDestRAPPORT := sDest + 'RAPPORT\';
  sDestARCHIVE := sDest + 'RAPPORT\ARCHIVE\';
  ForceDirectories(sDestRAPPORT);
  ForceDirectories(sDestARCHIVE);
  IF NOT(MemD_ListeRapport.Active) OR (MemD_ListeRapport.RecordCount = 0) THEN
    exit;
  s := MemD_ListeRapport.fieldbyname('FichierSrc').AsString;
  sFic := MemD_ListeRapport.fieldbyname('Fichier').AsString;
  dRapp := Trunc(MemD_ListeRapport.fieldbyname('JDATE').AsDateTime) +
    Frac(MemD_ListeRapport.fieldbyname('JTIME').AsDateTime);

  Frm_RapportAgrandi := TFrm_RapportAgrandi.Create(Self);
  TRY
    Frm_RapportAgrandi.InitEcr(sDestRAPPORT + s, sFic, dRapp);
    Frm_RapportAgrandi.ShowModal;
  FINALLY
    Frm_RapportAgrandi.Free;
    Frm_RapportAgrandi := NIL;
  END;

END;

PROCEDURE TFrm_Main.Nbt_CocherClick(Sender: TObject);
VAR
  savFic: STRING;
BEGIN
  WITH Dm_Common.MemD_ATraiterVtePriv DO
  BEGIN
    IF NOT(Active) OR (RecordCount = 0) THEN
      exit;
    savFic := fieldbyname('fichier').AsString;
    DisableControls;
    TRY
      First;
      WHILE NOT(Eof) DO
      BEGIN
        Edit;
        fieldbyname('ATraiter').AsInteger := 1;
        Post;
        Next;
      END;
    FINALLY
      Locate('fichier', savFic, []);
      EnableControls;
    END;
  END;
END;

PROCEDURE TFrm_Main.Nbt_ConnBaseClick(Sender: TObject);
VAR
  bOk: boolean;
BEGIN
  Frm_MotDePasse := TFrm_MotDePasse.Create(Self);
  TRY
    bOk := (Frm_MotDePasse.ShowModal = mrOk);
    Application.ProcessMessages;
  FINALLY
    Frm_MotDePasse.Free;
    Frm_MotDePasse := NIL;
  END;
  IF bOk THEN
    ActiveOnglet(Tab_DB_Params);
END;

PROCEDURE TFrm_Main.Nbt_CreerRaccVtePrivClick(Sender: TObject);
VAR
  IdList: PITEMIDLIST;
  CheminBur: ARRAY [0 .. MAX_PATH] OF Char;
  ShellLink: IShellLink;

  FichierRacc: STRING;
  FichierExe: STRING;
  ParamDuFic: STRING;
BEGIN
  IF SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, IdList)
    = NOERROR THEN
  BEGIN
    SHGetPathFromIDList(IdList, CheminBur); // Chemin du bureau de Windows

    // fichier raccourci
    FichierRacc := STRING(CheminBur);
    IF (FichierRacc <> '') AND (FichierRacc[Length(FichierRacc)] <> '\') THEN
      FichierRacc := FichierRacc + '\';
    FichierRacc := FichierRacc + 'Intégration Commande Web Vente Privée.lnk';

    // exe à lancer
    FichierExe := '"' + ParamStr(0) + '"';
    ParamDuFic := '"VTEPRIV"';

    // Création du raccourci
    ShellLink := CreateComObject(CLSID_ShellLink) AS IShellLink;
    ShellLink.SetDescription('');
    ShellLink.SetPath(PChar(FichierExe));
    ShellLink.SetArguments(PChar(ParamDuFic));
    ShellLink.SetShowCmd(SW_SHOW);
    (ShellLink AS IpersistFile).Save(StringToOleStr(FichierRacc), true);

    MessageDlg('Raccourci créé avec succès.', mtinformation, [mbok], 0);
  END;
END;

PROCEDURE TFrm_Main.Nbt_DecocherClick(Sender: TObject);
VAR
  savFic: STRING;
BEGIN
  WITH Dm_Common.MemD_ATraiterVtePriv DO
  BEGIN
    IF NOT(Active) OR (RecordCount = 0) THEN
      exit;
    savFic := fieldbyname('fichier').AsString;
    DisableControls;
    TRY
      First;
      WHILE NOT(Eof) DO
      BEGIN
        Edit;
        fieldbyname('ATraiter').AsInteger := 0;
        Post;
        Next;
      END;
    FINALLY
      Locate('fichier', savFic, []);
      EnableControls;
    END;
  END;
END;

PROCEDURE TFrm_Main.Nbt_DelDemarreAutoClick(Sender: TObject);
VAR
  MyReg: TRegistry;
  TS: TStrings;
  sCurVal: STRING;
  sValue: STRING;
  i: Integer;
BEGIN
  IF MessageDlg
    ('Etes-vous sûr de vouloir désactiver le démarrage automatique du programme ?',
    mtconfirmation, [mbyes, mbno], 0, mbno) <> mryes THEN
    exit;

  // Lecture de la base de registre
  MyReg := TRegistry.Create;
  TRY
    // Se positionne dans HKLM
    MyReg.RootKey := HKEY_LOCAL_MACHINE;

    // Ouvre la clé et la crée si elle n'existe pas
    IF MyReg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run\',
      false) THEN
    BEGIN
      // Recherche si une ancienne version est présente et la supprime
      TS := TStringList.Create;
      TRY
        MyReg.GetValueNames(TS);
        FOR i := 0 TO TS.Count - 1 DO
        BEGIN
          sCurVal := TS[i];
          IF MyReg.GetDataType(sCurVal) = rdString THEN
          BEGIN
            TRY
              sValue := UpperCase(MyReg.ReadString(sCurVal));
              IF (Pos('COMMANDESNETEVEN', sValue) > 0) OR
                (Pos('COMMANDESWEB', sValue) > 0) THEN
              BEGIN
                LogAction('Valeur de registre (' + sCurVal + ' -> ' + sValue +
                  ') supprimée', 0);
                MyReg.DeleteValue(sCurVal);
              END;
            EXCEPT
              // On zappe, si c'est pas une chaine, on a pas besoin de la supprimer
            END;
          END;
        END;
      FINALLY
        TS.Free;
      END;

      // Recherche si la valeur existe déjà, puis la supprime
      IF MyReg.ValueExists('GinkoSyncWeb') THEN
      BEGIN
        LogAction('Valeur de registre ( GinkoSyncWeb ) supprimée', 0);
        MyReg.DeleteValue('GinkoSyncWeb');
        MessageDlg('Démarrage automatique du programme désactivé.', mtWarning,
          [mbok], 0);
      END;
    END
    ELSE
    BEGIN
      LogAction(
        'Clé de registre (Run) non trouvée, impossible d''effectuer le paramétrage',
        0);
    END;

  FINALLY
    MyReg.Free;
  END;
END;

PROCEDURE TFrm_Main.Nbt_DoTraitementClick(Sender: TObject);
BEGIN
  if SetTraitementEnCours(true) then
  begin
    try
      DoTraitement;
    finally
      SetTraitementEnCours(false);
    end;
  end;
END;

PROCEDURE TFrm_Main.Nbt_ExecuterClick(Sender: TObject);
VAR
  NbOk, NbEchec: Integer;

BEGIN
  IF NOT(Dm_Common.Que_SitePriv.Active) OR
    (Dm_Common.Que_SitePriv.RecordCount = 0) THEN
    exit;
  IF NOT(Dm_Common.MemD_ATraiterVtePriv.Active) OR
    (Dm_Common.MemD_ATraiterVtePriv.RecordCount = 0) THEN
    exit;
  IF EnCoursTraiter THEN
    exit;
  NbOk := 0;
  NbEchec := 0;
  Screen.Cursor := crHourGlass;
  EnCoursTraiter := true;
  TRY
    IF NOT(TestParametreVtePriv) THEN
      exit;
    TraiterVtePriv(Chp_Rep.Text, NbOk, NbEchec);
  FINALLY
    Application.ProcessMessages;
    DoVtePrive(Tab_ATraiter);
    EnCoursTraiter := false;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  END;
  IF (NbOk > 0) OR (NbEchec > 0) THEN
    MessageDlg(IntToStr(NbOk) + ' Fichier(s) intégré(s),' + #13#10 +
      IntToStr(NbEchec) + ' Fichier(s) en erreur', mtinformation, [mbok], 0);
  IF NbEchec > 0 THEN
  BEGIN
    Pgc_VtePriv.ActivePage := Tab_Erreurs;
    IF NbEchec = 1 THEN
      Nbt_AgrandirRapportClick(Nbt_AgrandirRapport);
  END;

END;

procedure TFrm_Main.Nbt_ExportFTPActiveModeAutoClick(Sender: TObject);
begin
  IF (MappingOK()) AND (Dm_Common.DBReconnect(True)) THEN
  BEGIN
    Dm_Common.DBDisconnect;

    bModeAuto := true;

    Nbt_VentePrive.Enabled := Dm_Common.OkSiteWebVentePriv AND NOT(bModeAuto);
    Lab_VtePrive.Enabled := Dm_Common.OkSiteWebVentePriv AND NOT(bModeAuto);

    Nbt_NetEvenMenu.Enabled := Dm_Common.OkSiteWebNetEven AND NOT(bModeAuto);
    Lab_NetEvenMenu.Enabled := Dm_Common.OkSiteWebNetEven AND NOT(bModeAuto);

//    ActiveTimer;

    FExportFtpManager.Start;
  END
  ELSE
  BEGIN
    LogAction(
      'Impossible de démarrer le mode automatique, connexion à la base impossible',
      0);
  END;

end;

procedure TFrm_Main.Nbt_ExportFTPClick(Sender: TObject);
begin
  ActiveOnglet(Tab_ExportFTP);
end;

procedure TFrm_Main.Nbt_ExportFtpExecuteClick(Sender: TObject);
begin
  FExportFtpManager.Execute;
end;

procedure TFrm_Main.Nbt_ExportFtpSENDFTPClick(Sender: TObject);
begin
  FExportFtpManager.ForceUpload;
end;

procedure TFrm_Main.Nbt_ExportFtpTestConnexionClick(Sender: TObject);
begin
  FExportFtpManager.TestFTPConnection;
end;

procedure TFrm_Main.InitExportFtp;
var
  Buffer: String;
begin
  Buffer := GAPPATH + 'Logs\';
  IF NOT DirectoryExists(Buffer) THEN
    ForceDirectories(Buffer);

  PurgeOldLogs(Dm_Common.MyIniParams.bDelOldLog, Dm_Common.MyIniParams.iDelOldLogAge);

  FExportFtpManager := TFTPManager.Create(Dm_Common.Ginkoia, Dm_Common.IbT_Modif, apptExportFTP, cMdl_EXPORT_FTP, '88', '5',
                                          GGENTMPPATH + 'Export\', Buffer + 'Export\',
                                          ExportFtpManagerAddMonitoring, True, False, 'CSV', True);
  FExportFtpManager.OnLogEvent := ExportFtpManagerLog;
  FExportFtpManager.OnAfterStart := ExportFtpManagerAfterStart;

  Nbt_ExportFTP.Enabled := (FExportFtpManager.Enabled) or (DebugHook = 1);
  Lab_ExportFTP.Enabled := Nbt_ExportFTP.Enabled;
end;

PROCEDURE TFrm_Main.Initialize;
VAR
  sMess: STRING;
BEGIN
  // Lecture de l'ini
  InitParams();

  // Delete des vieux logs
  PurgeOldLogs(Dm_Common.MyIniParams.bDelOldLog,
    Dm_Common.MyIniParams.iDelOldLogAge);

  // Avant toute chose, on vérifie le mapping pour voir si on peut se connecter à la base
  if MappingOK then
  begin
    // Ensuite on attend Interbase
    LogAction('/***** Attente Interbase Server ' + DateTimeToStr(Now()) + ' *****/', 3);
    Attente_IB;

    // Connection à la BDD
    IF NOT Dm_Common.DBReconnect(true) THEN
    BEGIN
      // SI mode auto et echec, on déco
      IF bModeAuto THEN
      BEGIN
        sMess := 'ERREUR - Connection DB échouée, impossible de démarrer l''application';
        LogAction(sMess, 0);
        Dm_Common.SendLog(bModeAuto);
        // Application.Terminate();
      END
      ELSE
      BEGIN
        Nbt_DoTraitement.Enabled := false;
      END;
      // si pas mode auto, a voir... (positionnement auto dans les paramètres ?
    END;

    FTableNegColisUtils := TTableNegColisUtils.Create(Dm_Common.Ginkoia);
    //Initialisation pour le monitoring
    InitMonitoring;

    //Initialisation pour le WMS
    InitWMS;

    //Initialisation pour l'Export FTP
    InitExportFtp;

    Nbt_VentePrive.Enabled := Dm_Common.OkSiteWebVentePriv AND NOT(bModeAuto);
    Lab_VtePrive.Enabled := Dm_Common.OkSiteWebVentePriv AND NOT(bModeAuto);

    Nbt_NetEvenMenu.Enabled := Dm_Common.OkSiteWebNetEven AND NOT(bModeAuto);
    Lab_NetEvenMenu.Enabled := Dm_Common.OkSiteWebNetEven AND NOT(bModeAuto);
  end;
END;

PROCEDURE TFrm_Main.FinTraitement;
BEGIN
  try
    MemD_PrmTimer.Close;
    WITH Dm_Common DO
    BEGIN
      IF FTP.Active THEN
      BEGIN
        FTP.ABORT;
        FTP.Close;
      END;
      DBDisconnect;
    END;
  except
    on e : Exception do
      LogAction('Exception dans "TFrm_Main.FinTraitement" : ' + e.Message, 3);
  end;
END;

PROCEDURE TFrm_Main.Attente_IB;
VAR
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  tempMini: DWORD;
  CheckPoint: DWORD;
  NbBcl: Integer;
BEGIN
  hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
  hService := OpenService(hSCManager, 'InterBaseGuardian',
    SERVICE_QUERY_STATUS);
  IF hService <> 0 THEN
  BEGIN // Service non installé
    QueryServiceStatus(hService, Statut);
    CheckPoint := 0;
    NbBcl := 0;
    WHILE (Statut.dwCurrentState <> SERVICE_RUNNING) OR
      (CheckPoint <> Statut.dwCheckPoint) DO
    BEGIN
      CheckPoint := Statut.dwCheckPoint;
      tempMini := Statut.dwWaitHint + 1000;
      Sleep(tempMini);
      QueryServiceStatus(hService, Statut);
      Inc(NbBcl);
      IF NbBcl > 900 THEN
        BREAK;
    END;
    IF NbBcl < 900 THEN
    BEGIN
      CloseServiceHandle(hService);
      hService := OpenService(hSCManager, 'InterBaseServer',
        SERVICE_QUERY_STATUS);
      IF hService <> 0 THEN
      BEGIN // Service non installé
        QueryServiceStatus(hService, Statut);
        CheckPoint := 0;
        NbBcl := 0;
        WHILE (Statut.dwCurrentState <> SERVICE_RUNNING) OR
          (CheckPoint <> Statut.dwCheckPoint) DO
        BEGIN
          CheckPoint := Statut.dwCheckPoint;
          tempMini := Statut.dwWaitHint + 1000;
          Sleep(tempMini);
          QueryServiceStatus(hService, Statut);
          Inc(NbBcl);
          IF NbBcl > 900 THEN
            BREAK;
        END;
      END;
    END;
  END;
  CloseServiceHandle(hService);
  CloseServiceHandle(hSCManager);
END;

END.
