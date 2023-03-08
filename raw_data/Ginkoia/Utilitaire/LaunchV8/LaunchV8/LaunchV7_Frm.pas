unit LaunchV7_Frm;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls,
  Forms,
  // Uses Perso
  IdHTTP, CstLaunch, Ping_thread, WinSvc, Registry, UMapping, IniFiles, RASAPI,
  GestionJetonLaunch, LaunchMain_Dm, LaunchEvent_Dm, GinkoiaStyle_Dm,
  // Fin uses perso
  Dialogs, DB, LMDContainerComponent, LMDBaseDialog, LMDAboutDlg, Menus,
  LMDCustomComponent, LMDWndProcComponent, LMDTrayIcon, ExtCtrls, IBStoredProc,
  IBDatabase, IBCustomDataSet, IBQuery, dxGDIPlusClasses, StdCtrls,
  AdvOfficePager, RzPanel, RzLabel, InvokeRegistry, Rio, SOAPHTTPClient,
  GinPanel, ImgList, AdvOfficePagerStylers, AdvGlowButton, RzGroupBar, AdvEdit,
  DateUtils, Types, Upost, xmldom, XMLIntf, Buttons, XMLDoc, HttpApp, uToolsXE,
  ShlObj, IBServices, uFileRestart, ShellAPI, uKillApp, Math, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, WinInet, SOAPHTTPTrans, ActiveX,
  IdIntercept, IdLogBase, IdLogFile, WaitFor_frm, LaunchProcess, uLog, ComCtrls,
  XPMan, uKRange, uNetWorkShare, ParamCaisseSync_Frm, uEventPanel, Generics.Collections,
  TlHelp32, SyncObjs, ServiceControler;

const
  PARAM_FORCE_REPLIC = 'FORCEREPLIC';
  WM_FORCE_REPLIC = WM_APP + 1;
  WM_FORCE_PUSH = WM_APP + 2;
  WM_FORCE_PULL = WM_APP + 3;
  CST_WrongVerificationVersion = '13.2.10.0';

type
  TEtatService = record
    bInstall: Boolean;
    bAutomatique: Boolean;
    bStarted: Boolean;
  end;

  TTimerEtat = (TimerOff, TimerOn);

  TTaskStatus = (tsDisabled, tsStoppped, tsWaiting, tsPaused, tsRunning);

  TTask = class
  private
    FName: string;
    FStatus: TTaskStatus;
    FEnabled: Boolean;
    FRunning: Boolean;
    FOk: Boolean;
    FError: string;
    FWarning: string;
    FLast: TDateTime;
    FLastOk: TDateTime;
    FNext: TDateTime;
    FOverTime: Integer;
    FLevel: TLogLevel;
    FEventPanel: TEventPanel;
    FSend: Boolean;
    FReference: string;
    procedure evalStatus;
    procedure setEnabled(const Value: Boolean);
    procedure setOk(const Value: Boolean);
    procedure setRunning(const Value: Boolean);
    procedure setOverTime(const Value: Integer);
    procedure setError(const Value: string);
    procedure setLast(const Value: TDateTime);
    procedure setLastOk(const Value: TDateTime);
    procedure setNext(const Value: TDateTime);
    procedure setWarning(const Value: string);
  public
    constructor Create;
    destructor Destroy;
    procedure sendLog;
  published
    property Name: string read FName write FName;
    property Reference: string read FReference write FReference;
    property Status: TTaskStatus read FStatus;
    property Enabled: Boolean read FEnabled write setEnabled;
    property Running: Boolean read FRunning write setRunning;
    property Ok: Boolean read FOk write setOk;
    property Error: string read FError write setError;
    property Warning: string read FWarning write setWarning;
    property Last: TDateTime read FLast write setLast;
    property LastOk: TDateTime read FLastOk write setLastOk;
    property Next: TDateTime read FNext write setNext;
    property OverTime: Integer read FOverTime write setOverTime;
    property Level: TLogLevel read FLevel write FLevel;
    property EventPanel: TEventPanel read FEventPanel write FEventPanel;
  end;

  TSynchroCaisse = record
    Enabled: Boolean;
    Time: TTime;
    Server: string;
  end;

  TVersion = record
    Major: Word;
    Minor: Word;
    Revision: Word;
    Build: Word;
  end;

type
  // AJ 19/04/2017 : sert pour le calcul de l'espace disque pour l'archivage
  TEspaceDisque = (tedTotal, tedLibre, tedUtilise);

  TUniteOctet = (tuoOctet, tuoKoctet, tuoMoctet, tuoGoctet, tuoToctet);

  TFrm_LaunchV7 = class(TForm)
    Od: TOpenDialog;
    IB_Connexion: TIBQuery;
    IB_ConnexionCON_ID: TIntegerField;
    IB_ConnexionCON_LAUID: TIntegerField;
    IB_ConnexionCON_NOM: TIBStringField;
    IB_ConnexionCON_TEL: TIBStringField;
    IB_ConnexionCON_TYPE: TIntegerField;
    IB_ConnexionCON_ORDRE: TIntegerField;
    Ib_Launch: TIBQuery;
    Ib_LaunchLAU_ID: TIntegerField;
    Ib_LaunchLAU_BASID: TIntegerField;
    Ib_LaunchLAU_HEURE1: TDateTimeField;
    Ib_LaunchLAU_H1: TIntegerField;
    Ib_LaunchLAU_HEURE2: TDateTimeField;
    Ib_LaunchLAU_H2: TIntegerField;
    Ib_LaunchLAU_AUTORUN: TIntegerField;
    IB_LaBase: TIBQuery;
    IB_LaBaseBAS_ID: TIntegerField;
    IB_LaBaseBAS_NOM: TIBStringField;
    Ib_LesBases: TIBQuery;
    Ib_LesBasesBAS_ID: TIntegerField;
    Ib_LesBasesBAS_NOM: TIBStringField;
    Ib_Horraire: TIBQuery;
    Ib_HorraireLAU_ID: TIntegerField;
    Ib_HorraireLAU_BASID: TIntegerField;
    Ib_HorraireLAU_HEURE1: TDateTimeField;
    Ib_HorraireLAU_H1: TIntegerField;
    Ib_HorraireLAU_HEURE2: TDateTimeField;
    Ib_HorraireLAU_H2: TIntegerField;
    Ib_HorraireLAU_AUTORUN: TIntegerField;
    Sp_NewKey: TIBStoredProc;
    IB_Divers: TIBQuery;
    Ib_Replication: TIBQuery;
    Ib_ReplicationREP_ID: TIntegerField;
    Ib_ReplicationREP_LAUID: TIntegerField;
    Ib_ReplicationREP_PING: TIBStringField;
    Ib_ReplicationREP_PUSH: TIBStringField;
    Ib_ReplicationREP_PULL: TIBStringField;
    Ib_ReplicationREP_USER: TIBStringField;
    Ib_ReplicationREP_PWD: TIBStringField;
    Ib_ReplicationREP_ORDRE: TIntegerField;
    Ib_Provider: TIBQuery;
    Ib_ProviderPRO_ID: TIntegerField;
    Ib_ProviderPRO_NOM: TIBStringField;
    Ib_ProviderPRO_ORDRE: TIntegerField;
    Ib_Subsciber: TIBQuery;
    Ib_SubsciberSUB_ID: TIntegerField;
    Ib_SubsciberSUB_NOM: TIBStringField;
    Ib_SubsciberSUB_ORDRE: TIntegerField;
    Ib_Liaison: TIBQuery;
    Ib_ProviderPRO_LOOP: TIntegerField;
    Ib_SubsciberSUB_LOOP: TIntegerField;
    Tim_LanceRepli: TTimer;
    IB_ChgLaunch: TIBQuery;
    IB_ChgLaunchCHA_ID: TIntegerField;
    IB_ChgLaunchCHA_LAUID: TIntegerField;
    IB_ChgLaunchCHA_HEURE1: TDateTimeField;
    IB_ChgLaunchCHA_H1: TIntegerField;
    IB_ChgLaunchCHA_HEURE2: TDateTimeField;
    IB_ChgLaunchCHA_H2: TIntegerField;
    IB_ChgLaunchCHA_AUTORUN: TIntegerField;
    IB_ChgLaunchCHA_ACTIVER: TDateTimeField;
    IB_ChgLaunchCHA_ACTIVE: TIntegerField;
    Ib_ProvRepli: TIBQuery;
    Ib_ProvRepliPRO_ID: TIntegerField;
    Ib_ProvRepliPRO_NOM: TIBStringField;
    Ib_ProvRepliPRO_ORDRE: TIntegerField;
    Ib_ProvRepliPRO_LOOP: TIntegerField;
    Ib_SubsRepli: TIBQuery;
    Ib_SubsRepliSUB_ID: TIntegerField;
    Ib_SubsRepliSUB_NOM: TIBStringField;
    Ib_SubsRepliSUB_ORDRE: TIntegerField;
    Ib_SubsRepliSUB_LOOP: TIntegerField;
    Ib_ReplicationREP_URLLOCAL: TIBStringField;
    Ib_ReplicationREP_URLDISTANT: TIBStringField;
    Ib_ReplicationREP_PLACEEAI: TIBStringField;
    Ib_ReplicationREP_PLACEBASE: TIBStringField;
    IB_CalculeTrigger: TIBQuery;
    IB_CalculeTriggerRETOUR: TIntegerField;
    Panel2: TRzPanel;
    Mem_Result: TMemo;
    Tray_Launch: TLMDTrayIcon;
    Men_Icon: TPopupMenu;
    AfficherleLauncher1: TMenuItem;
    N2: TMenuItem;
    QuitterleLauncher1: TMenuItem;
    Ib_TousHorraire: TIBQuery;
    Ib_TousHorraireLAU_ID: TIntegerField;
    Ib_TousHorraireLAU_BASID: TIntegerField;
    Ib_TousHorraireLAU_HEURE1: TDateTimeField;
    Ib_TousHorraireLAU_H1: TIntegerField;
    Ib_TousHorraireLAU_HEURE2: TDateTimeField;
    Ib_TousHorraireLAU_H2: TIntegerField;
    Ib_TousHorraireLAU_AUTORUN: TIntegerField;
    IB_ChgLaunchCHA_BACK: TIntegerField;
    IB_ChgLaunchCHA_BACKTIME: TDateTimeField;
    Ib_HorraireLAU_BACK: TIntegerField;
    Ib_HorraireLAU_BACKTIME: TDateTimeField;
    AboutDlg_Main: TLMDAboutDlg;
    IBQue_Reference: TIBQuery;
    IBQue_ReferenceRRE_ID: TIntegerField;
    IBQue_ReferenceRRE_POSITION: TIntegerField;
    IBQue_ReferenceRRE_PLACE: TIntegerField;
    IBQue_ReferenceRRE_URL: TIBStringField;
    IBQue_ReferenceRRE_ORDRE: TIBStringField;
    IBQue_RefLig: TIBQuery;
    IBQue_RefLigRRL_ID: TIntegerField;
    IBQue_RefLigRRL_RREID: TIntegerField;
    IBQue_RefLigRRL_PARAM: TIBStringField;
    DataPass: TIBDatabase;
    IBQue_Pass: TIBQuery;
    Tranpass: TIBTransaction;
    IB_ForceMAJ: TIBQuery;
    IB_ForceMAJPRM_ID: TIntegerField;
    IB_ForceMAJPRM_CODE: TIntegerField;
    IB_ForceMAJPRM_INTEGER: TIntegerField;
    IB_ForceMAJPRM_FLOAT: TFloatField;
    IB_ForceMAJPRM_STRING: TIBStringField;
    IB_ForceMAJPRM_TYPE: TIntegerField;
    IB_ForceMAJPRM_MAGID: TIntegerField;
    IB_ForceMAJPRM_INFO: TIBStringField;
    IB_ForceMAJPRM_POS: TIntegerField;
    Tim_ReplicWeb: TTimer;
    Ib_ReplicWeb: TIBQuery;
    Ib_ReplicWebREP_ID: TIntegerField;
    Ib_ReplicWebREP_LAUID: TIntegerField;
    Ib_ReplicWebREP_PING: TIBStringField;
    Ib_ReplicWebREP_PUSH: TIBStringField;
    Ib_ReplicWebREP_PULL: TIBStringField;
    Ib_ReplicWebREP_USER: TIBStringField;
    Ib_ReplicWebREP_PWD: TIBStringField;
    Ib_ReplicWebREP_ORDRE: TIntegerField;
    Ib_ReplicWebREP_URLLOCAL: TIBStringField;
    Ib_ReplicWebREP_URLDISTANT: TIBStringField;
    Ib_ReplicWebREP_PLACEEAI: TIBStringField;
    Ib_ReplicWebREP_PLACEBASE: TIBStringField;
    Ib_GetParamReplicWeb: TIBQuery;
    Ib_GetParamReplicWebHDEB: TFloatField;
    Ib_GetParamReplicWebHFIN: TFloatField;
    Ib_GetParamReplicWebINTERVALE: TIntegerField;
    Ib_GetParamReplicWebOK: TIntegerField;
    Que_CheminServeur: TIBQuery;
    Que_CheminServeurPRM_STRING: TIBStringField;
    Que_CheminServeurPRM_INTEGER: TIntegerField;
    Que_CheminServeurPRM_FLOAT: TFloatField;
    Que_Bases: TIBQuery;
    Que_BasesBAS_ID: TIntegerField;
    Que_BasesBAS_NOM: TIBStringField;
    Que_BasesBAS_IDENT: TIBStringField;
    Tim_SrvSecours: TTimer;
    Pan_SrvSecours: TRzPanel;
    IB_SrvSecours_Present: TIBQuery;
    Img_SrvSecours1: TImage;
    Img_SrvSecours2: TImage;
    Lab_SrvSecours: TLabel;
    IBQue_IsPlateforme: TIBQuery;
    IBQue_IsPlateformePF: TIntegerField;
    IBQue_ReferDesactive: TIBQuery;
    IBQue_ReferDesactiveCOUNT: TIntegerField;
    IBQue_PreCalculTrigger: TIBQuery;
    Pan_Fond: TRzPanel;
    Pan_Left: TRzPanel;
    Pan_Etat: TRzPanel;
    Lab_Etat1: TRzLabel;
    Lab_Etat2: TRzLabel;
    Tim_ReplicTpsReel: TTimer;
    IBQue_RefPF: TIBQuery;
    IBQue_RefPFRRE_ID: TIntegerField;
    IBQue_RefPFRRE_POSITION: TIntegerField;
    IBQue_RefPFRRE_PLACE: TIntegerField;
    IBQue_RefPFRRE_URL: TIBStringField;
    IBQue_RefPFRRE_ORDRE: TIBStringField;
    IBQue_RefPFRRE_PF: TIntegerField;
    PgC_Main: TAdvOfficePager;
    Tab_Affiche: TAdvOfficePage;
    Tab_Manuel: TAdvOfficePage;
    Pan_FondAffiche: TRzPanel;
    Mem_Affiche: TMemo;
    RioJetonLaunch: THTTPRIO;
    Pan_ManuelBottom: TRzPanel;
    PanFondPrincipal: TGinPanel;
    Lim_Launch: TImageList;
    Sty_Launcher: TAdvOfficePagerOfficeStyler;
    Pan_AffRight: TRzPanel;
    Btn_APropos: TAdvGlowButton;
    Parametrage: TAdvGlowButton;
    Btn_ReplicTpsReel: TAdvGlowButton;
    Btn_ReplicWeb: TAdvGlowButton;
    Btn_Synchroniser: TAdvGlowButton;
    Btn_Init: TAdvGlowButton;
    Pan_Param: TRzPanel;
    Que_GetParamReplicTpsReel: TIBQuery;
    Btn_Refer: TAdvGlowButton;
    Pan_Tests: TRzPanel;
    Btn_CaissesSec: TAdvGlowButton;
    Pan_Retour: TRzPanel;
    Btn_Retour: TAdvGlowButton;
    Que_GetParamReplicTpsReelPRM_INTEGER: TIntegerField;
    Que_GetParamReplicTpsReelPRM_FLOAT: TFloatField;
    Que_GetParamReplicTpsReelPRM_STRING: TIBStringField;
    Ib_ReplicationREP_JOUR: TIntegerField;
    Btn_Params: TAdvGlowButton;
    Lab_Params: TRzLabel;
    Lab_Replics: TRzLabel;
    IBQue_ReferenceRRE_PF: TIntegerField;
    Pan_Bottom: TRzPanel;
    Btn_Envoi: TAdvGlowButton;
    Btn_Recep: TAdvGlowButton;
    Btn_ReplicManuelle: TAdvGlowButton;
    Lab_Loop: TRzLabel;
    Ed_Loop: TAdvEdit;
    RecalcStock: TAdvGlowButton;
    Nbt_ForceReplicTpsReel: TAdvGlowButton;
    IBQue_CalcFusion: TIBQuery;
    Btn_DoSynchro: TAdvGlowButton;
    Nbt_Reduire: TAdvGlowButton;
    Btn_Quitter: TAdvGlowButton;
    Pan_Quitter: TRzPanel;
    IB_LaBaseBAS_IDENT: TIBStringField;
    IBQue_GetVersion: TIBQuery;
    IBQue_Tmp: TIBQuery;
    IB_LaBaseBAS_GUID: TIBStringField;
    Ib_ReplicWebREP_JOUR: TIntegerField;
    Ib_ReplicWebREP_EXEFINREPLIC: TIBStringField;
    Ib_ReplicationREP_EXEFINREPLIC: TIBStringField;
    RioJetonLaunchPF: THTTPRIO;
    IdLogFile1: TIdLogFile;
    IdHTTP1: TIdHTTP;
    IdConnectionIntercept1: TIdConnectionIntercept;
    Nbt_PingTest: TAdvGlowButton;
    Pan_KRange: TRzPanel;
    Label1: TLabel;
    pb_KRange: TProgressBar;
    Img_KRange: TImage;
    Lab_KUsed: TLabel;
    XPManifest1: TXPManifest;
    Tim_ForceReplic: TTimer;
    btReplicWeb: TAdvGlowButton;
    cbRecalculTrigger: TCheckBox;
    Btn_PrmSync: TAdvGlowButton;
    btnSynchroCaisse: TAdvGlowButton;
    btnSynchroCaisseHome: TAdvGlowButton;
    panEvents: TPanel;
    limMonitor: TImageList;
    IB_LaBaseBAS_SENDER: TIBStringField;
    IB_LaBaseBAS_NOMPOURNOUS: TIBStringField;
    panMonitor: TPanel;
    IB_LaBaseBAS_MAGID: TIntegerField;
    PopupEventMobilite: TPopupMenu;
    PopupEventServiceReprise: TPopupMenu;
    MenuStopService: TMenuItem;
    MenuStartService: TMenuItem;
    MenuReloadService: TMenuItem;
    MenuStopServiceReprise: TMenuItem;
    MenuStartServiceReprise: TMenuItem;
    MenuReloadServiceReprise: TMenuItem;
    LimEvent: TImageList;
    Btn_KOubliesReplication: TAdvGlowButton;
    btnDateBackup: TAdvGlowButton;
    PopupEventPiccobatch: TPopupMenu;
    MenuStopPiccobatch: TMenuItem;
    MenuStartPiccobatch: TMenuItem;
    Btn_InitAccueil: TAdvGlowButton;
    procedure Btn_InitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Tim_LanceRepliTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_ReplicManuelleClick(Sender: TObject);
    procedure AfficherleLauncher1Click(Sender: TObject);
    procedure QuitterleLauncher1Click(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure Cacher1Click(Sender: TObject);
    procedure Tray_LaunchDblClick(Sender: TObject);
    procedure Btn_ReferClick(Sender: TObject);
    procedure Dtb_GinkoiaBeforeConnect(Sender: TObject);
    // FC : 16/12/2008, Ajout du module réplic en journée
    procedure SetTimerIntervalReplicWeb();
    procedure MajDebFinReplicWeb();
    function DoReplicWeb(): Boolean;
    function ReplicWebToDo(): Boolean;
    procedure Tim_ReplicWebTimer(Sender: TObject);
    procedure Btn_ReplicWebClick(Sender: TObject);
    procedure DoReplicWebAndInfo();
    // Fin Ajout FC : 16/12/2008, Ajout du module réplic en journée
    procedure Btn_SynchroniserClick(Sender: TObject);
    procedure Btn_PrmSynchroClick(Sender: TObject);
    // FC : 26/06/2009, Ajout Module de surveillance du serveur de secours
    procedure Tim_SrvSecoursTimer(Sender: TObject);
    // FC : 26/06/2009, Fin

    // AJ : 10/02/2017 factorisation de la prise de jeton et notification de réplication
    function notificationReplicEnCours(var repli: TLesreplication): string;

    // FC : 02/03 : Réplic totale en journée
    procedure Tim_ReplicTpsReelTimer(Sender: TObject);
    procedure Btn_JourneeClick(Sender: TObject);
    procedure RioJetonLaunchAfterExecute(const MethodName: string; SOAPResponse: TStream);
    procedure RioJetonLaunchBeforeExecute(const MethodName: string; SOAPRequest: TStream);
    procedure DoReplicTpsReelAndInfo();
    procedure SetTimerIntervalReplicTpsReel(bReLitParam: Boolean = True);
    procedure MajParamReplicTpsReel();
    function ReplicTpsReelToDo(): Boolean;
    procedure MajHDebHFinReplicTpsReel;
    function GetParam(var IOInteger: Integer; var IOFloat: double; var IOString: string; AType, ACode, ABasID: Integer): Boolean;
    function GetParamInteger(AType, ACode, ABasID: Integer): Integer;
    function GetParamString(AType, ACode, ABasID: Integer): string;
    function GetParamFloat(AType, ACode, ABasID: Integer): double;
    procedure PanFondPrincipalBtnCloseOnClick(Sender: TObject);
    procedure Btn_JournInternetClick(Sender: TObject);
    procedure Btn_JournInternetTousMagsClick(Sender: TObject);
    procedure Btn_JournReplicClick(Sender: TObject);
    procedure Btn_AProposClick(Sender: TObject);
    procedure Btn_QuitterClick(Sender: TObject);
    procedure ParametrageClick(Sender: TObject);
    procedure ActiveOnglet(pTabSheet: TAdvOfficePage);
    procedure Btn_RetourClick(Sender: TObject);
    procedure Btn_ParamsClick(Sender: TObject);
    procedure Btn_EnvoiClick(Sender: TObject);
    procedure Btn_RecepClick(Sender: TObject);
    procedure RecalcStockClick(Sender: TObject);
    procedure Nbt_ReduireClick(Sender: TObject);
    procedure Nbt_PingTestClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Tim_ForceReplicTimer(Sender: TObject);
    procedure Btn_CaissesSecClick(Sender: TObject);
    procedure PanFondPrincipalMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnSynchroCaisseClick(Sender: TObject);
    procedure MenuStopServiceClick(Sender: TObject);
    procedure MenuStartServiceClick(Sender: TObject);
    procedure MenuReloadServiceClick(Sender: TObject);
    procedure Btn_KOubliesReplicationClick(Sender: TObject);
    procedure MenuStopServiceRepriseClick(Sender: TObject);
    procedure MenuStartServiceRepriseClick(Sender: TObject);
    procedure MenuReloadServiceRepriseClick(Sender: TObject);
    procedure btnDateBackupClick(Sender: TObject);
    procedure MenuStopPiccobatchClick(Sender: TObject);
    procedure MenuStartPiccobatchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    MyHttp: TIdHTTP; // Accès au moteur Delos
    KRange: TKRange;
    MousePos: TPoint;
    MouseInForm: TPoint;
    PasDeVerifACauseDeSynchro: Boolean;
    Interbase7: Boolean;
    ServiceRepl: Boolean;
    BaseSauvegarde, isPortableSynchro, isServeur: Boolean;

    // AJ pour savoir si on à déjà lance la cloture des grands totaux
    DateLastCloture: Integer;
    // Boolean qui dit si c'est une caisse de secours ou pas
    IsCaisseSec: Boolean;

    // AJ pour savoir si on a déjà essayé de lancer piccobatch
    hasLaunchPicco: Boolean;

    // FC : 16/12/2008, Ajout du module réplic en journée
    dtReplicBegin: TDateTime; // Heure de début de réplication
    dtReplicEnd: TDateTime; // Heure de fin de réplic
    iIntervale: Integer; // Intervale entre deux réplic (en minutes)
    iOrdre: Integer; // Ordre push/pull : 1 = Pull/Push, 2 = Push/Pull

    bReplicWebActif: Boolean;
    hNextReplicWeb: TDateTime;
    hDebReplic, hFinReplic: TDateTime;
    // Date et heure de début et fin de réplic pour ce jour
    // Fin Ajout FC : 16/12/2008, Ajout du module réplic en journée

    // FC 02/2012 : Réplic journalière
    bReplicTpsReelActif: Boolean; // Actif ou non
    iNbEssaiMax: Integer; // Nombre d'essais maxi
    iDelaiEssai: Integer; // Délai entre deux essais
    iIntervaleTpsReel: Integer; // Intervale entre deux réplic
    hDebReplicJourna: TDateTime; // Heure de début de réplication
    hFinReplicJourna: TDateTime; // Heure de fin de réplic
    hNextReplicJourna: TDateTime;
    // heure de la prochaine réplication journalière
    sAdresseWS: string;
    // Adresse du webservice (ex : /JetonLaunch.dll/soap/IJetonLaunch)
    sDatabaseWS: string; // DB pour le webservice
    sSenderWS: string; // Sender pour le WebService
    // Fin réplic journalière

    taskReplication: TTask;
    taskReplicationPF: TTask;
    taskReplicationWeb: TTask;
    taskSynchroNotebook: TTask;
    taskSynchroCaisse: TTask;
    taskBackupRestore: TTask;
    taskBI: TTask;
    taskRecalc: TTask;
    SynchroCaisse: TSynchroCaisse;
    strPathBaseServ: string; // lab notebook
    boolRecalculOk: Boolean;
    // lab signale l'erreur pour déclencher l'affichage du message d'erreur recalcul
    // synchroEnCours : Boolean;

    // FC : 26/06/2009, Ajout Module de surveillance du serveur de secours
    bSrvSecours_Present: Boolean;
    dtSrvSecours_PremiereTentative: TDateTime;
    // FC : 26/06/2009, Fin

    bReplicPlateforme: Boolean;
    // Permet de savoir si on est en mode plateforme ou non
    sUrlPlateforme: string; // Url de la plateforme
    sDatabasePlateforme: string; // Nom dans le fichier Database
    sSenderPlateforme: string;
    // Sender utilisé dans cette base pour la plateforme

    // FL : 04/03/2014 : Ajout du test de ping manuel
    PingList: TPingList;
    sLogMessage: string;
    bLogClear: Boolean;
    bLogDebug: Boolean;
    lLogLock: TRTLCriticalSection;
    bmpRange: array[0..2] of TBitmap;
    EventPanel: array[1..12] of TEventPanel;
    FLauncherStarted: Boolean;
    FDataBaseOk: Boolean;
    FDataBaseError: string;
    FKRangeStatus: TLogLevel;
    FCanClose: Boolean;
    FBasId: Int64;
    FBasSender: string;
    FBasDossier: string;
    FBasGuid: string;
    FBasMagID: string;
    FIBServerVersion: string;
    FBaseVersion: TVersion;
    FMaxVersion: Integer;
    Lastdate: TDateTime;
    DossierEasy: string;
    procedure checkLauncher;
    function GetLoop: Integer;
    function GetTIdHttp(AuserName, APassWord: string; AConnectTimeOut: Integer): TIdHTTP;
    function TrouverlabonneHeure: Boolean;
    function Connexion(repli: TLesreplication): Boolean;
    function ConnexionModem(Nom, Tel: string): Boolean;
    procedure DeconnexionModem;
    procedure Deconnexion;
    procedure connexionTriger(Base: string; bWithEvent: Boolean = True);
    procedure DeconnexionTriger(Base: string; bWithEvent: Boolean = True);
    procedure recalculeTriger(Base: string; bWithEvent: Boolean = True; bReplicIsOK: Boolean = False; AvecPas: Boolean = False);
    function ControleKVersion(Base: string): Integer;
    procedure Exec_AvantRepli(Base: string);
    function PULL(repli: TLesreplication; AForceLoop: Integer = 0; bWithEvent: Boolean = True): Boolean;
    function PUSH(repli: TLesreplication; AForceLoop: Integer = 0; bWithEvent: Boolean = True): Boolean;
    function LoopPULL(repli: TLesreplication; bWithEvent: Boolean = True): Boolean;
    function LoopPUSH(repli: TLesreplication; bWithEvent: Boolean = True): Boolean;
    procedure Ajoute(S: string; Vider: Integer = 0; AOnlyIfDebug: Boolean = False);
    procedure AjouteTC(S: string; Vider: Integer);
    procedure LogInternalError(Sender: TObject);
    procedure doLog(aMsg: string; aLevel: TLogLevel);
    procedure Info;
    procedure InitEtat;
    procedure Attente_IB;
    // FC : 26/06/2009, Ajout Module de surveillance du serveur de secours
    function SrvSecours_EtatService: TEtatService;
    procedure SrvSecours_Demarre;
    function SrvSecours_EstALancer: Boolean;
    procedure SrvSecoursAffErreur(ANum: Integer = 0; ALibelle: string = '');
    procedure CloseApplicationOnTimer(Sender: TObject);
    // FC : 26/06/2009, Fin

    procedure QuitLauncher();
    { Déclarations privées }
    function GetVersionBase: string;
    function GetVersionBaseV: TVersion;
    function GetVersionLame: string;
    function GetYellisVersion: string;
    function GFixBase(ABase: string): Boolean;
    function GetVersionThread(AUrl, ADatabase: string; AHttpRio: THTTPRIO): string;
    function GetVersionReTry(AAdresse, ADatabaseWS, AVersionEnCours: string; var bVersionError: Boolean; ANbTry: Integer = 3): Boolean;

    // fonction de gestion du jeton
    function GetJeton(AMaxEssai, ADelaiEssai: Integer; AAdresse, ADatabaseWS, ASenderWs: string; AHttpRio: THTTPRIO): string;
    function GetJetonPortable(ADelaiEssai: Integer; AAdresse, ADatabaseWS, ASenderWs: string; AHttpRio: THTTPRIO): string;
    procedure showHideLog(aShow: Boolean);
    procedure PingList_OnPingResult(Sender: TObject; AUrl: string; resultCode: Integer; resultMsg: string; resultTime: Integer);
    procedure PingList_OnFinish(Sender: TObject);
    function checkLocalSeparators: Boolean;
    function startVerification(aDownload, aInstall: Boolean): Boolean;
    function updateVerification(): Boolean;
    function checkKRange: Boolean;
    procedure WMEndSession(var Message: TWMEndSession); message WM_ENDSESSION;
    procedure OnForceReplic(var Msg: TMessage); message WM_FORCE_REPLIC;
    procedure OnForcePush(var Msg: TMessage); message WM_FORCE_PUSH;
    procedure OnForcePull(var Msg: TMessage); message WM_FORCE_PULL;
    function startSynchroPortable(ABase: string): Boolean;
    function doSynchroCaisse: Boolean;
    function getSynchroCaisse: TSynchroCaisse;
    procedure AlignementGENERATEUR_VERSION_ID();
    function isTimeSynchroCaisse: Boolean;
    procedure Init;
    procedure updateButtons;
    procedure sendStatus;
    procedure readIni;
    procedure saveIni;
    function checkPlaceBase: Boolean;
    procedure updateTasks;
    function LignesModifiees: Boolean;
    procedure SauvegardeMaxKVersion;
    procedure ModificationNomModePushSeulement;
    function GetPasTrigger: Integer;
    procedure diskSpace(bas_id: Integer);
    // AJ 19/04/2017 pour espace disque dispo pour archivage
    function EspaceDisque(disque: string; espace: TEspaceDisque; unite: TUniteOctet): extended;
    // AJ 19/04/2017 pour espace disque dispo pour archivage
    procedure checkNetworkArchivage(bas_id: Integer);
    // AJ 26/04/2017 pour droits réseau pour archivage
    function IsNewMAJ: Boolean;
    // AJ 20/09/2017 pour nouveau système de maj avec les Ginkoia tools
    procedure LaunchPiccoAuto;
    function IsBaseProd: Boolean;
    procedure CheckUpdateToEasy;
    procedure LaunchAsAdministrator;
    procedure CloseLauncherForEasy;
    procedure TimerOnOff(etat: TTimerEtat);
    function LauncherIsDoingAction: boolean;
    function ManageNotUpdatableVerificationExe: Boolean;
  protected
    encours: Integer;
    LauId: Integer;
    HEURE1: TDateTime;
    H1: Boolean;
    HEURE2: TDateTime;
    H2: Boolean;
    AUTORUN: Boolean;
    ForcerLaMaj: Boolean;
    TokenEnBoucle: TToken; // Variable pour contenir le thread
    TokenEnBouclePF: TToken; // Variable pour contenir le thread
    ListeRefPF: TList;

    // FC : 16/12/2008, Ajout du module réplic en journée
    ListeReplicWeb: TList; // Liste des réplic pour le module jour
    // Fin Ajout FC : 16/12/2008, Ajout du module réplic en journée

    ListeReplication: TList;
    ListeConnexion: TList;
    ListeReference: TList;
    Connectionencours: TLesConnexion;
    Ping: Tping;
    Path: string;
    tempsReplication: TDateTime;
    EtatBackup: Integer; // -1 pas de backup,
    // 1 après la 1° réplication
    // 2 après la 2° réplication
    // 3 à 23 H
    // 4 à 22 H
    // 5 à heure fixe
    HeureBackup: TDateTime;
    MessMAJ1: string;
    MessMAJ2: string;
    MessReplicPlateforme: string;
    ReplicOk: Boolean; // lab flag réplication ok

    PathLogRio: string;
    sVersionEnCours: string;
    // Version actuelle de la base (dernier script passé).

    procedure InsertK(Clef, Table: Integer);
    procedure ModifK(Clef: Integer);
    procedure DeleteK(Clef: Integer);
    function MotDePasse(aPassName: String): Boolean;
    procedure NeedHorraire(Basid: Integer; Prin: Boolean; var LauId: Integer; var H1: string; var Valid1: Integer; var H2: string; var Valid2: Integer; var Auto: Integer; var LaDate: string; var Back: Integer; var BackTime: string; var ForcerMaj: Boolean; var PRM_ID: Integer);
    procedure NeedConnexion(LauId: Integer; Conn: TUneConnexion);
    procedure NeedReplication(LauId: Integer; repli: TUneReplication);
    function NouvelleClef: Integer;
    procedure Commit;
    procedure InitialiseLaunch;
    function VerifChangeHorraire: Boolean;
    // LeType = 0 tous, = 1 Que l'envois, =2 que la réception, =3 que le recalcule
    function ReplicationAutomatique(Manuelle, Derniere: Boolean; LeType: Byte; LOOP: Integer; bRecalcul: Boolean = True): Boolean;
    function LancementBackup: Boolean;
    function Lancementdesreferencements(Num: Integer; Rep: TLesreplication): Boolean;
    procedure boutonSynchro(msgError: Integer);
    function SourceToURL(AUrl: string; ASource: TStrings): string;

    // FC : 02/2012 : Réplication totale en journée
    function DoReplicAutoJournee(ReplicManuelle: Boolean = False; LeType: integer = 0): Boolean;
    procedure InitTokenEnBoucle(Url, NomClient, Sender: string; Temps: DWord; ARio: THTTPRIO);
    procedure InitTokenEnBouclePF(Url, NomClient, Sender: string; Temps: DWord; ARio: THTTPRIO);
    procedure StopTokenEnBoucle;
    procedure StopTokenEnBouclePF;
    function DoPushPull(LeType: Integer; ARepli: TLesreplication): Boolean;
    function LanceDelosQPMAgent(APlaceEAI, AURLPing: string): Boolean;
    function LanceRefPF(ARepli: TLesreplication; var aSuccess: Boolean): Boolean;
  public
    procedure InitPing(Url: string; Temps: DWord);
    procedure StopPing;
    procedure MajMobilite(Status: Word);
    procedure MajServiceReprise(Status: Word);
    procedure MajPiccobatchStatut(Running: Boolean);
    procedure DoEventStatus;
    procedure SetLastDateRecup;
    // Vérifie que le module est actif pour au moins 1 magasin
    function IsModuleActif(AModuleNom: string): Boolean;
    // Vérifie si c'est le magasin Web
    function IsMagasinWeb(): Boolean;
    // Fonction de traitement des numéro de facture + sauvegade + execution logiciel extérieur
    function DoMajFacture: Boolean;
  published
    property Started: Boolean read FLauncherStarted;
  end;

  ETIMEOUTRIO = class(Exception);

  TRioThread = class(TThread)
  private
    FWaitMs: Integer;
    FHttpRio: THTTPRIO;
    FLabel: TLabel;
  public
    constructor Create(AHttpRio: THTTPRIO; ATimeMS: Integer; LabTimer: TLabel = nil);
    procedure Execute; override;
  end;

  TRioGetVersionThread = class(TThread)
  private
    FHttpRio: THTTPRIO;
    FURL: string;
    FDataBase: string;
    FResultat: string;
    FException: Exception;
    FEndOfThread: Boolean;
  public
    constructor Create(AHttpRio: THTTPRIO; AUrl, ADatabase: string);
    procedure Execute; override;
    property Resultat: string read FResultat;
    property OException: Exception read FException;
    property EndOfThread: Boolean read FEndOfThread;
  end;

  TThreadMobiliteService = class(TThread)
  private
    FStatus: Integer;
  published
    constructor Create(CreateSuspended: Boolean = True);
    destructor Destroy(); override;
    procedure Execute; override;
  public
    property Status: Integer read FStatus write FStatus;
  end;

  TThreadSrvCheckStatusMobilite = class(TThread)
  private
    FStatus: Integer;
    procedure Synchro;
  published
    constructor Create;
    destructor Destroy(); override;
    procedure Execute; override;
  public
    property Status: Integer read FStatus write FStatus;
  end;

  TThreadServiceRepriseService = class(TThread)
  private
    FStatus: Integer;
  published
    constructor Create(CreateSuspended: Boolean = True);
    destructor Destroy(); override;
    procedure Execute; override;
  public
    property Status: Integer read FStatus write FStatus;
  end;

  TThreadSrvCheckStatusServiceReprise = class(TThread)
  private
    FStatus: Integer;
    procedure Synchro;
  published
    constructor Create;
    destructor Destroy(); override;
    procedure Execute; override;
  public
    property Status: Integer read FStatus write FStatus;
  end;

  TThreadPiccobatch = class(TThread)
  private
    FLaunch: Boolean;
  published
    constructor Create(CreateSuspended: Boolean = True);
    destructor Destroy(); override;
    procedure Execute; override;
  public
    property Launch: Boolean read FLaunch write FLaunch;
  end;

  TThreadSrvCheckStatusPiccobatch = class(TThread)
  private
    FRunning: Boolean;
    procedure Synchro;
  published
    constructor Create;
    destructor Destroy(); override;
    procedure Execute; override;
  public
    property Running: Boolean read FRunning write FRunning;
  end;

var
  Frm_LaunchV7: TFrm_LaunchV7;
  TokenManager: TTokenManager;
  isRestartApplication: Boolean;
  ThreadSrvCheckStatusMobilite: TThreadSrvCheckStatusMobilite;
  ThreadSrvCheckStatusServiceReprise: TThreadSrvCheckStatusServiceReprise;
  ThreadSrvCheckStatusPiccobatch: TThreadSrvCheckStatusPiccobatch;

implementation

uses
  Reference_Frm, MotDePasse_Frm, Conso_Frm, LaunchV7_Dm, SuiviReplic_Frm,
  ParamSynchro_Frm, ListeSynchro_Frm, Param_Frm, Confirmation_Frm, uVersion,
  UnitExecNettoieGinkoia, WaitMsg,
  // JB
  RecupDocVersion,
  // Cloture des grands Totaux
  uClotureGrandsTotaux,
  // unité pour le passage de Delos Vers Easy
  uDelos2Easy,
  //unité de gestion des mots de passe
  uPasswordManager;

{$R *.DFM}

// AJ 12/05/2017 : function qui dit si un processus est lancé ou non
function processExists(exeFileName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(exeFileName)) or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(exeFileName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

// ---------------------------------------------------------------
// Initialisation de l'application
// ---------------------------------------------------------------
procedure TFrm_LaunchV7.Attente_IB;
var
  LastTick: Integer;
  I: Integer;
begin
  for I := 1 to 100 do
  begin
    Sleep(10);
    Application.ProcessMessages;
  end;

end;

// ------------------------------------------------------------------------------
procedure TFrm_LaunchV7.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FCanClose then
  begin
    Action := TCloseAction.caFree;
  end
  else
  begin
    Action := TCloseAction.caNone;
    Hide;
  end;
end;

// ------------------------------------------------------------------------------
procedure TFrm_LaunchV7.readIni;
var
  vIniFile: TIniFile;
begin
  vIniFile := TIniFile.Create(changeFileExt(ParamStr(0), '.ini'));
  try
    FBasId := vIniFile.ReadInteger('Base', 'Id', FBasId);
    FBasSender := vIniFile.ReadString('Base', 'Sender', FBasSender);
    FBasGuid := vIniFile.ReadString('Base', 'GUID', FBasGuid);
    FBasMagID := vIniFile.ReadString('Base', 'MagID', FBasMagID);
    FBasDossier := vIniFile.ReadString('Base', 'Dossier', FBasDossier);
    Lastdate := vIniFile.ReadDate('DocVersion', 'Date', 0);
    DossierEasy := vIniFile.ReadString('EASY', 'mode', '');
  finally
    vIniFile.Free;
  end;
end;

// ------------------------------------------------------------------------------
procedure TFrm_LaunchV7.saveIni;
var
  vIniFile: TIniFile;
begin
  vIniFile := TIniFile.Create(changeFileExt(ParamStr(0), '.ini'));
  try
    vIniFile.WriteInteger('Base', 'Id', FBasId);
    vIniFile.WriteString('Base', 'Sender', FBasSender);
    vIniFile.WriteString('Base', 'GUID', FBasGuid);
    vIniFile.WriteString('Base', 'MagID', FBasMagID);
    vIniFile.WriteString('Base', 'Dossier', FBasDossier);
    vIniFile.WriteDate('DocVersion', 'Date', Lastdate);
    vIniFile.WriteString('EASY', 'mode', DossierEasy);
  finally
    vIniFile.Free;
  end;
end;

// ------------------------------------------------------------------------------
procedure TFrm_LaunchV7.updateTasks;
begin
  taskReplication.Reference := FBasGuid;
  taskReplicationPF.Reference := FBasGuid;
  taskReplicationWeb.Reference := FBasGuid;
  taskSynchroNotebook.Reference := FBasGuid;
  taskSynchroCaisse.Reference := FBasGuid;
  taskBackupRestore.Reference := FBasGuid;
  taskBI.Reference := FBasGuid;

end;

// ------------------------------------------------------------------------------
procedure TFrm_LaunchV7.FormCreate(Sender: TObject);
var
  reg: TRegistry;
  bIsMainPlateforme: Boolean;
  rs: TResourceStream;
  ia: Integer;
  S: string;
  vBitmap: TBitmap;
  vVersion: string;
  vSynchroCaisse: TSynchroCaisse;
begin
  DossierEasy := '';

  Application.HintHidePause := 10000;
  Application.HintPause := 100;

  DateLastCloture := 0;
  IsCaisseSec := false;
  hasLaunchPicco := False;

  // procédure qui test si le launcher est exécuté en temps qu'administrateur et écrit la clé de registre en cas de besoin
  LaunchAsAdministrator();

  readIni;

  // si le dossier est sous easy et qu'on a trouvé l'entrée de le .INI, on affiche un message et ferme le launcher
  if DossierEasy = 'EASY' then
  begin
    CloseLauncherForEasy;
  end
  else // on initialise le log du launcher que dans le cas ou on est pas sous easy, pour ne pas venir mettre des infos parasites dans la base du monitoring
  begin
    Log.App := 'Launcher';
    Log.Inst := '';
    Log.Doss := FBasDossier;
    Log.Ref := FBasGuid;
    Log.Mag := FBasMagID;
    Log.FileLogFormat := [elDate, elMdl, elKey, elLevel, elNb, elValue];
    Log.SendOnClose := True;
    Log.OnInternalError := LogInternalError;
    Log.Open;
    Log.SendLogLevel := logTrace;

    Log.Log('Main', FBasGuid, 'Log', 'Démarrage du Launcher', logTrace, True, 0, ltLocal);
    Log.saveIni;
  end;

  FDataBaseOk := True;
  FDataBaseError := '';
  FLauncherStarted := False;
  KRange := TKRange.Create;
  FCanClose := False;
  Tray_Launch.NoClose := False;

  bmpRange[0] := TBitmap.Create;
  bmpRange[0].LoadFromResourceName(HInstance, 'ICO32_OK');
  bmpRange[1] := TBitmap.Create;
  bmpRange[1].LoadFromResourceName(HInstance, 'ICO32_WARNING');
  bmpRange[2] := TBitmap.Create;
  bmpRange[2].LoadFromResourceName(HInstance, 'ICO32_ERROR');

  for ia := 1 to 12 do
  begin
    EventPanel[ia] := TEventPanel.Create(Self);
    EventPanel[ia].Align := alLeft;
    EventPanel[ia].Level := logTrace;
    EventPanel[ia].visible := False;
  end;

  EventPanel[1].Title := 'Launcher';
  // limTask.GetIcon(5,  eventPanel[1].Icon) ;
  EventPanel[1].visible := True;
  EventPanel[1].Parent := panMonitor;

  EventPanel[2].Title := 'Réplication';
  EventPanel[2].Parent := panEvents;
  LimEvent.GetIcon(0, EventPanel[2].Icon);

  EventPanel[3].Title := 'Réplication PF';
  EventPanel[3].Parent := panEvents;
  LimEvent.GetIcon(1, EventPanel[3].Icon);

  EventPanel[4].Title := 'Replication Web';
  EventPanel[4].Parent := panEvents;
  LimEvent.GetIcon(2, EventPanel[4].Icon);

  EventPanel[5].Title := 'Synchro Port.';
  EventPanel[5].Parent := panEvents;
  LimEvent.GetIcon(3, EventPanel[5].Icon);

  EventPanel[6].Title := 'Caisse secours';
  EventPanel[6].Parent := panEvents;
  LimEvent.GetIcon(4, EventPanel[6].Icon);

  EventPanel[7].Title := 'Backup Restore';
  EventPanel[7].Parent := panMonitor;
  limMonitor.GetIcon(0, EventPanel[7].Icon);

  EventPanel[8].Title := 'BI';
  EventPanel[8].Parent := panMonitor;
  limMonitor.GetIcon(1, EventPanel[8].Icon);

  EventPanel[9].Title := 'Recalcul';
  EventPanel[9].Parent := panMonitor;
  limMonitor.GetIcon(2, EventPanel[9].Icon);

  EventPanel[10].Title := 'Mobilité';
  EventPanel[10].Parent := panMonitor;
  LimEvent.GetIcon(5, EventPanel[10].Icon);
  EventPanel[10].visible := False;
  EventPanel[10].SetPopMenu(PopupEventMobilite);

  EventPanel[11].Title := 'Service Reprise';
  EventPanel[11].Parent := panMonitor;
  LimEvent.GetIcon(7, EventPanel[11].Icon);
  EventPanel[11].visible := False;
  EventPanel[11].SetPopMenu(PopupEventServiceReprise);

  EventPanel[12].Title := 'PiccoBatch';
  EventPanel[12].Parent := panMonitor;
  LimEvent.GetIcon(8, EventPanel[12].Icon);
  EventPanel[12].visible := False;
  EventPanel[12].SetPopMenu(PopupEventPiccobatch);

  FreeAndNil(ThreadSrvCheckStatusMobilite);
  ThreadSrvCheckStatusMobilite := TThreadSrvCheckStatusMobilite.Create;
  ThreadSrvCheckStatusMobilite.Status := 1;
  ThreadSrvCheckStatusMobilite.Resume;

  FreeAndNil(ThreadSrvCheckStatusServiceReprise);
  ThreadSrvCheckStatusServiceReprise := TThreadSrvCheckStatusServiceReprise.Create;
  ThreadSrvCheckStatusServiceReprise.Status := 1;
  ThreadSrvCheckStatusServiceReprise.Resume;

  FreeAndNil(ThreadSrvCheckStatusPiccobatch);
  ThreadSrvCheckStatusPiccobatch := TThreadSrvCheckStatusPiccobatch.Create;
  ThreadSrvCheckStatusPiccobatch.Running := True;
  ThreadSrvCheckStatusPiccobatch.Resume;

  taskReplication := TTask.Create;
  taskReplication.Name := 'Replication';
  taskReplication.Reference := FBasGuid;
  taskReplication.EventPanel := EventPanel[2];
  taskReplication.OverTime := 87000;

  taskReplicationPF := TTask.Create;
  taskReplicationPF.Name := 'ReplicationPF';
  taskReplicationPF.Reference := FBasGuid;
  taskReplicationPF.EventPanel := EventPanel[3];
  taskReplication.OverTime := 87000;

  taskReplicationWeb := TTask.Create;
  taskReplicationWeb.Reference := FBasGuid;
  taskReplicationWeb.Name := 'ReplicationWeb';
  taskReplicationWeb.EventPanel := EventPanel[4];
  taskReplication.OverTime := 87000;

  taskSynchroNotebook := TTask.Create;
  taskSynchroNotebook.Name := 'SynchroNb';
  taskSynchroNotebook.Reference := FBasGuid;
  taskSynchroNotebook.EventPanel := EventPanel[5];
  taskReplication.OverTime := 0;

  taskSynchroCaisse := TTask.Create;
  taskSynchroCaisse.Name := 'SynchroCaisse';
  taskSynchroCaisse.Reference := FBasGuid;
  taskSynchroCaisse.EventPanel := EventPanel[6];
  taskReplication.OverTime := 87000;

  taskBackupRestore := TTask.Create;
  taskBackupRestore.Name := 'BackupRestore';
  taskBackupRestore.Reference := FBasGuid;
  taskBackupRestore.EventPanel := EventPanel[7];
  taskBackupRestore.OverTime := 87000;

  taskBI := TTask.Create;
  taskBI.Name := 'BI';
  taskBI.Reference := FBasGuid;
  taskBI.EventPanel := EventPanel[8];
  taskBI.OverTime := 87000;

  taskRecalc := TTask.Create;
  taskRecalc.Name := 'RecalcTrigger';
  taskRecalc.Reference := FBasGuid;
  taskRecalc.EventPanel := EventPanel[9];
  taskRecalc.OverTime := 87000;

  InitializeCriticalSection(lLogLock);

  hNextReplicJourna := 0;
  bReplicPlateforme := False;

  vVersion := GetNumVersionSoft;
  PanFondPrincipal.GinkoiaAddon.PanTop.Labels.CaptionCenter := 'Launcher V' + vVersion;

  Dm_GinkoiaStyle.AppliqueAllStyleAdvGlowButton(Self);
  ActiveOnglet(Tab_Affiche);
  showHideLog(False);

  PasDeVerifACauseDeSynchro := False;
  MessMAJ1 := '';
  MessMAJ2 := '';

  reg := TRegistry.Create;
  try
    reg.Access := KEY_READ;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
    S := reg.ReadString('Version');
  finally
    reg.Free;
  end;

  ListeReplication := NIL;
  ListeConnexion := NIL;
  ListeReference := NIL;
  ListeRefPF := Nil;
  ListeReplicWeb := NIL;

  MapGinkoia.Launcher := False;

  // Niveau de Log
  if (ParamCount > 0) and (UpperCase(ParamStr(1)) = 'DEBUG') then
    ModeDebug := True
  else
    ModeDebug := False;

  EtatBackup := -1;
  RepliEnCours := False;
  // Lecture la base de référence
  Path := extractFilePath(Application.exename);
  if Path[length(Path)] <> '\' then
    Path := Path + '\';

  if ListeReplication = NIL then
    ListeReplication := TList.Create;
  if ListeConnexion = NIL then
    ListeConnexion := TList.Create;

  if ListeReference = NIL then
    ListeReference := TList.Create;

  if ListeRefPF = NIL then
    ListeRefPF := TList.Create;

  if ListeReplicWeb = NIL then
    // FC : 16/12/2008, Ajout du module réplic en journée
    ListeReplicWeb := TList.Create;
  // FC : 16/12/2008, Ajout du module réplic en journée

  reg := TRegistry.Create(KEY_READ);
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
    LaBase0 := reg.ReadString('Base0');

    if LaBase0 = '' then
    begin
      if (ParamCount > 0) and (UpperCase(ParamStr(1)) = 'AUTOINIT') then
      begin
        Btn_Init.visible := True;
        Show;
        Btn_InitClick(NIL);
        EXIT;
      end
      else
      begin
        Application.MessageBox('L''initialisation du Launcher doit être faite', 'Attention', Mb_Ok);
        Btn_Init.visible := True;
        Btn_InitAccueil.visible := True;
        Show;
        EXIT;
      end;
    end;

  finally
    reg.closekey;
    reg.Free;
  end;

  // Affichage de la Form
  updateButtons;

  // Si on est sur easy (dans l'ini) on sort de la procédure et le programme va se fermer;
  if DossierEasy = 'EASY' then
    Exit
  else
    Show;

  Application.ProcessMessages;

  Init();
  Log.Log('Main', 'Version', vVersion, logInfo, True);
  FLauncherStarted := True;

  vSynchroCaisse := getSynchroCaisse;

  if ((isPortableSynchro) or (vSynchroCaisse.Enabled)) then
  begin
    ModificationNomModePushSeulement;
    // 2022-09-26 Controle de Version et VERSION_ID dans sa plage...
    AlignementGENERATEUR_VERSION_ID();
  end;

  // paramètre qui dit si on est sur une caisse de secours qui sert pour l'heure de lancement des grands totaux
  IsCaisseSec := vSynchroCaisse.Enabled;

  DoEventStatus;

  // Contrôle si le launcher doit passer en Easy ou pas
  CheckUpdateToEasy();

  checkLauncher;

  Dm_LaunchMain.setOuvrirEtatLauncher();
  Commit;
end;

procedure TFrm_LaunchV7.CloseApplicationOnTimer(Sender: TObject);
begin
  //Fermeture de l'application
  Application.Terminate;
end;

procedure TFrm_LaunchV7.TimerOnOff(etat: TTimerEtat);
begin
  if etat = TimerOff then
  begin
    Tim_ReplicWeb.Enabled := False;
    Tim_LanceRepli.Enabled := False;
    Tim_ForceReplic.Enabled := False;
    Tim_ReplicTpsReel.Enabled := False;
  end
  else if etat = TimerOn then
  begin
    Tim_ReplicWeb.Enabled := True;
    Tim_LanceRepli.Enabled := True;
    Tim_ForceReplic.Enabled := True;
    Tim_ReplicTpsReel.Enabled := True;
  end;
end;

function TFrm_LaunchV7.LauncherIsDoingAction: boolean;
begin
  Result := False;
  // on vérifie que rien ne tourne sinon on sort
  if (Assigned(Frm_Param) and Frm_Param.visible) or taskReplication.Running or taskSynchroCaisse.Running or taskSynchroNotebook.Running or isTimeSynchroCaisse then
    Result := true;
end;

procedure TFrm_LaunchV7.CheckUpdateToEasy();
var
  WaitBeforeClose: TTimer;
begin
  // si autre chose tourne on refait le test plus tard
  if LauncherIsDoingAction then
    Exit;

  try
    with Delos2Easy do
    begin
      // on met à jour la valeur du GENPARAM toutes les 30 min pour le cas ou le param a changé et le launcher par redémarré, et on log l'état initial
      if MinutesBetween(PARAM_80_2.DATE_PARAM, Now) > 30 then
      begin
        SetGenParam();

        // Si le GENPARAM de Delos vers easy existe en base, on remonte l'info au monitoring
        if (PARAM_80_2.PRM_ID > 0) and (PARAM_80_2.PRM_INTEGER = 0) then
          LogDelos2Easy('Pas de date prévue', logInfo);
      end;

      //ShowMessage(FloatToStr((IncDay(Now,1))));

      // les étapes sont déjà faites, on ferme le launcher
      if PARAM_80_2.PRM_INTEGER >= 1000 then
      begin
        CloseLauncherForEasy();
      end;

      // si une date de MAJ est programmée et que la date n'est pas encore atteinte, on remonte l'info au monitoring
      if (PARAM_80_2.PRM_ID > 0) and (PARAM_80_2.PRM_INTEGER = 200) and (PARAM_80_2.PRM_FLOAT > 0) and (Now < PARAM_80_2.PRM_FLOAT) then
      begin
        Delos2Easy.LogDelos2Easy('Date MAJ vers easy : ' + DateTimeToStr(TDateTime(Delos2Easy.PARAM_80_2.PRM_FLOAT)), logInfo);

        // on lance également une fois par jour le téléchargement des fichiers easy à partir du moment ou une date est programmée
        if DateDownload < Trunc(Now) then
        begin
          LaunchDelos2Easy('/download /hide');
          DateDownload := Trunc(Now);
        end;
      end;

      // Si la date est programmée, et qu'elle est atteinte ou dépassée, on arrête tous les timers du launcher et on lance la procédure
      if (Now > PARAM_80_2.PRM_FLOAT) and (PARAM_80_2.PRM_INTEGER = 200) then
      begin
        try
          // on re set le haserror à false au cas ou il soit passé à true lors de la dernière tentative
          HasError := False;
          TimerOnOff(TimerOff); // on arrête tous les timers

          // réplication en envoi uniquement
          try
            if not (isPortableSynchro) and not (BaseSauvegarde) then
            begin
              Ajoute(DateTimeToStr(Now) + '  ' + 'Réplication envoi uniquement', 0);
              LogDelos2Easy('Réplication en envoi', logNotice);

              ReplicationAutomatique(True, False, 1, 0, True);
              if (ReplicOk) and (boolRecalculOk) then
              begin
                Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication envoi Réussie', 0);
                LogDelos2Easy('Réplication en envoi réussie', logInfo);
              end
              else
              begin
                if not (ReplicOk) then
                  LogDelos2Easy('Erreur lors de la réplication en envoi', logError)
                else
                  LogDelos2Easy('Erreur lors du recalcul des triggers', logError);

                // si l'envoi à échoué on poursuit quand même le traitement à présent
                //HasError := true;
              end;

              Ajoute('', 0);
            end;
          except
            on E: Exception do
            begin
              HasError := true;
              LogDelos2Easy('Erreur lors de la réplication en envoi : ' + E.Message, logError);
              Ajoute('Erreur lors de la réplication en envoi : ' + E.Message, 0);
            end;
          end;
          if HasError then // en cas d'erreur, on remet en route les timers et on arrête le traitement car rien n'a été fait
          begin
            TimerOnOff(TimerOn);
            exit;
          end;

          // Shutdown de la base
          ShutdownDatabase();
          if HasError then // en cas d'erreur, on arrête le traitement
          begin
            exit;
          end;

          // on relance le service interbases pour être sur de bien fermer toutes les connexions
          RestartInterbaseService();
          if HasError then // en cas d'erreur, on arrête le traitement
          begin
            exit;
          end;

          // Backup de la base et renommage de la ginkoia
          BackupRenameBase();
          if HasError then // en cas d'erreur, on arrête le traitement
          begin
            exit;
          end;

          // lancement de Delos2Easy
          LaunchDelos2Easy('/install');
          if HasError then // en cas d'erreur, on arrête le traitement
          begin
            exit;
          end;

          // MAJ du genparam avec état terminé
          UpdateGenParam(1000);
          if not HasError then // en cas d'erreur, on arrête le traitement
          begin
            LogDelos2Easy('Traitement Delos2Easy du launcher terminé avec succès', logInfo);
          end;


          //Timer de 10 secondes avant la fermeture pour être sur que les logs soient tous envoyés
          WaitBeforeClose := TTimer.Create(nil);
          WaitBeforeClose.Interval := 10000;
          WaitBeforeClose.Enabled := true;
          WaitBeforeClose.OnTimer := CloseApplicationOnTimer;
        except
          on E: Exception do
          begin
            Ajoute('Erreur dans le passage de Delos vers Easy ' + E.Message, 0, False);
            Exit;
          end;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Ajoute('Erreur dans le test de Delos vers Easy ' + E.Message, 0, False);
    end;
  end;
end;

procedure TFrm_LaunchV7.CloseLauncherForEasy;
var
  WaitFrmMsg: TFrmWaitMsg;
begin
  // On affiche un message à l'utilisateur et on ferme le launcher au bout de 5 secondes
  try
    TimerOnOff(TimerOff); // on désactive les timers pour que rien ne se lance

    WaitFrmMsg := TFrmWaitMsg.Create(Frm_LaunchV7);
    WaitFrmMsg.Lab_Message.Caption := 'Le dossier est passé en easy, fermeture du launcher dans 5 secondes.';
    WaitFrmMsg.BringToFront;
    WaitFrmMsg.Position := poScreenCenter;
    WaitFrmMsg.Top := (Frm_LaunchV7.Height div 2) - (WaitFrmMsg.Height div 2);
    WaitFrmMsg.Left := (Frm_LaunchV7.Width div 2) - (WaitFrmMsg.Width div 2);
    WaitFrmMsg.Show;

    Frm_LaunchV7.Visible := false;

    Application.ProcessMessages;
    Sleep(5000);
  finally
    WaitFrmMsg.Free;
  end;

  Application.Terminate;
end;

procedure TFrm_LaunchV7.LogInternalError(Sender: TObject);
var
  sChemin, sFichierLog: string;
  F: TextFile;
begin
  sChemin := extractFilePath(Application.exename) + 'Log monitoring Launcher\';
  if not DirectoryExists(sChemin) then
  begin
    if not ForceDirectories(sChemin) then
      EXIT;
  end;
  sFichierLog := sChemin + 'Log monitoring Launcher ' + FormatDateTime('yyyy-mm-dd', Date) + '.log';
  AssignFile(F, sFichierLog);
  try
    try
      if FileExists(sFichierLog) then
        Append(F)
      else
        Rewrite(F);

      Writeln(F, '[' + FormatDateTime('dd/mm/yyyy hh:nn:ss:zzz', Now) + ']  ' + Log.LastError);
    except
    end;
  finally
    CloseFile(F);
  end;
end;
// ------------------------------------------------------------------------------

procedure TFrm_LaunchV7.ModificationNomModePushSeulement;
begin
  // Remplacer les mots « Réplication » par « Envoi»
  EventPanel[2].Title := 'Envoi';
  // Remplacer l’icône de la réplication par une fleche montante
  LimEvent.GetIcon(6, EventPanel[2].Icon);
  // Remplacer le texte du bouton « Répliquer » par « Envoyer »
  Nbt_ForceReplicTpsReel.Caption := ' Envoyer';
  // Remplacer le mot « réplication » par le mot « Synchronisation » dans le tab
  Tab_Affiche.Caption := 'Synchronisation';
end;

procedure TFrm_LaunchV7.Init();
var
  Nbessai: Integer;
  Ok: Boolean;
  vErr: string;
  S: string;
  iIdBase: Integer;
  dw: DWord;
  TpListe: TStringList;
  I: Integer;
  vBIMagId: Int64;
  sRepertoireDestination: string;
  vIBServerVersion: string;
begin
  Ok := False;
  checkLauncher;
  showHideLog(True);

  if (MapGinkoia.Backup or MapGinkoia.Verifencours) then
  begin
    if (MapGinkoia.Backup) then
      Ajoute('Attente de la fin du backup ...', 0);
    if (MapGinkoia.Verifencours) then
      Ajoute('Attente de la fin de verification ...', 0);

    while ((MapGinkoia.Backup) or (MapGinkoia.Verifencours)) do
    begin
      Application.ProcessMessages;
      Sleep(100);
    end;

    Ajoute('Backup et Verification terminés', 0);
  end;

  for Nbessai := 1 to 60 do // 1 heure
  begin
    try
      Attente_IB;

      if not Dm_LaunchV7.ConnectDataBase(LaBase0, vErr) then
      begin
        FDataBaseOk := False;
        Ajoute('Erreur : Base de donnée inaccessible : ' + vErr, 0);
        FDataBaseError := vErr;
        showHideLog(True);
        checkLauncher;
        raise Exception.Create('Base de donnée inaccessible.');
      end;

       // On créé l'objet de transfert de delos vers easy, une fois connecté à la base
      try
        Delos2Easy := TDelos2Easy.Create(LaBase0); // cet objet n'est libéré qu'à la fermeture du programme

          // si le dossier est déjà sous easy on ferme le launcher et on écrit la ligne dans l'ini pour qu'il se ferme diretement la fois suivante
        if Delos2Easy.IsEasy then
        begin
          DossierEasy := 'EASY';
          saveIni;
          CloseLauncherForEasy;
          exit;
        end;

      except
        on E: Exception do
        begin
          Ajoute(E.Message);
        end;
      end;

      VerifChangeHorraire;
      InitialiseLaunch;
      IB_LaBase.Open;
      iIdBase := IB_LaBaseBAS_ID.AsInteger;
      S := IB_LaBaseBAS_NOM.AsString;
      S := UpperCase(Copy(S, length(S) - 3, 4));
      BaseSauvegarde := S = '_SEC';

      FBasId := IB_LaBaseBAS_ID.AsLargeInt;
      FBasSender := IB_LaBaseBAS_SENDER.AsString;
      FBasDossier := IB_LaBaseBAS_NOMPOURNOUS.AsString;
      FBasGuid := IB_LaBaseBAS_GUID.AsString;
      FBasMagID := IB_LaBaseBAS_MAGID.AsString;

      FBaseVersion := GetVersionBaseV;

      saveIni;

      IB_LaBase.Close;
      Log.Doss := FBasDossier;
      Log.Mag := FBasMagID;
      Log.Ref := FBasGuid;
      updateTasks;

      // FC : 26/06/2009 : Ajout fonction lancement du serveur de secours.
      // Récupération de l'info si on attend ou non un serveur de secours
      try
        IB_SrvSecours_Present.ParamByName('BASID').AsInteger := iIdBase;
        IB_SrvSecours_Present.Open;
        bSrvSecours_Present := IB_SrvSecours_Present.FieldByName('PRM_INTEGER').AsInteger = 1;
        IB_SrvSecours_Present.Close;
      except
        bSrvSecours_Present := False;
      end;

      // Vérification si on est en mode plateforme
      try
        IBQue_IsPlateforme.Open;
        bReplicPlateforme := IBQue_IsPlateforme.FieldByName('PF').AsInteger <> 0;
        IBQue_IsPlateforme.Close;
        taskReplicationPF.Enabled := bReplicPlateforme;
      except
        bReplicPlateforme := False;
      end;

      // Désactivé pour l'instant
      // Si le serveur de secours n'est pas lancé mais devrait l'être, on envoie
      // IF SrvSecours_EstALancer THEN
      // BEGIN
      // Tim_SrvSecours.Interval := 1000; // tempo de 1 seconde
      // Tim_SrvSecours.Enabled := True;
      // END;

      // Verification du BI
      taskBI.Enabled := False;
      try
        Log.Log('LaunchV7_Frm', 'Init', 'Log', 'select GENPARAM (avant).', logDebug, True, 0, ltLocal);

        IBQue_Tmp.Close;
        IBQue_Tmp.SQL.Text := 'SELECT COUNT(prmmag.PRM_ID) NB FROM GENPARAM prmmag  ' + 'JOIN K ON K_ID = prmmag.PRM_ID AND K_ENABLED=1 ' + 'JOIN genparam prmbase on prmbase.PRM_MAGID = prmmag.PRM_MAGID ' + 'JOIN K ON K_ID = prmbase.PRM_ID AND K_ENABLED=1 ' + 'WHERE prmbase.prm_integer = :BASID ' + 'AND prmbase.PRM_TYPE=25 AND prmbase.PRM_CODE=2 ' + 'AND prmmag.PRM_TYPE=25 AND prmmag.PRM_CODE=1 ' + 'AND prmmag.PRM_INTEGER = 1';
        IBQue_Tmp.ParamByName('BASID').AsLargeInt := iIdBase;
        IBQue_Tmp.Open;

        Log.Log('LaunchV7_Frm', 'Init', 'Log', 'select GENPARAM (après).', logDebug, True, 0, ltLocal);

        if not IBQue_Tmp.IsEmpty then
        begin
          if IBQue_Tmp.FieldByName('NB').AsInteger > 0 then
            taskBI.Enabled := True;
        end;
        IBQue_Tmp.Close;
      except
      end;

      Dm_LaunchV7.ClosedataBase;
      Ok := True;
      BREAK;
    except
      dw := GetTickCount + (60000);
      while dw > GetTickCount do
      begin
        Sleep(500);
        Application.ProcessMessages;
      end;
    end;
  end;

  FIBServerVersion := Dm_LaunchV7.getIBServerVersion;

  if not Ok then
  begin
    FDataBaseOk := False;
    showHideLog(True);
    Ajoute('Attention : pas de connexion à la base - JOINDRE GINKOIA -', 0);
    EXIT;
  end;

  FDataBaseOk := True;
  FDataBaseError := '';

  // régler la visibilité du bouton et du menu synchroniser
  boutonSynchro(0);
  DoEventStatus;

  Log.Log('Main', FBasGuid, 'IBVersion', FIBServerVersion, logInfo, True, 2592000, ltServer);

  // info de la dernière réplication réussi
  if isPortableSynchro then
  begin
    S := extractFilePath(ParamStr(0));
    if S[length(S)] <> '\' then
      S := S + '\';
    S := S + 'Synchro.ok';
    if FileExists(S) then
    begin
      TpListe := TStringList.Create;
      try
        TpListe.LoadFromFile(S);
        if TpListe.Count > 0 then
        begin
          S := TpListe[0];
          Ajoute(S, 0);
        end;
      except
      end;
      FreeAndNil(TpListe);
    end;
  end;

  // Fichier de redémarrage
  FileRestart.Init;
  if FileExists(extractFilePath(Application.exename) + 'CfgRestart.ini') then
  begin
    // Chargement du fichier de configuration
    FileRestart.LoadFile;
    case FileRestart.ETAPE of
      1:
        begin // Cas du premier redémarrage
          // On vérifie si on a besoin de relancer la synchro (Oui si = 1)
          if FileRestart.RestartSynchro = 1 then
            Btn_SynchroniserClick(nil);
        end;
      2:
        begin // Cas du 2em redémarrage
          if FileRestart.RestartSynchro = 1 then
            Btn_SynchroniserClick(nil);
        end;
    end;

    if FileRestart.getBackupRestore then
    begin
      sRepertoireDestination := '';
      if GetParamInteger(11, 60, FBasId) = 1 then
        sRepertoireDestination := GetParamString(11, 60, FBasId);

      // on arrête les timers pendants le traitement puis on les relance
      try
        //TimerOnOff(TimerOff);

         // Mode normal (attente d'une heure).
        Ajoute('Début exécution NettoieGinkoia.');

        Log.Log('Main', FBasGuid, 'Log', 'Debut de execution Nettoie', logInfo, True, 0, ltLocal);

        if ExecNettoieGinkoia(3600, sRepertoireDestination, FBasDossier, FBasGuid) then
          Ajoute('Fin exécution NettoieGinkoia.')
        else
          Ajoute('Fin exécution NettoieGinkoia [processus interrompu].');

        Log.Log('Main', FBasGuid, 'Log', 'Fin de execution Nettoie', logInfo, True, 0, ltLocal);
      finally
        //TimerOnOff(TimerOn);
      end;

      LancementBackup;
    end;
  end;

  // Forcage de réplication au démarrage
  if ParamCount() > 0 then
  begin
    for I := 1 to ParamCount() do
    begin
      if UpperCase(ParamStr(I)) = PARAM_FORCE_REPLIC then
      begin
        PostMessage(Self.Handle, WM_FORCE_REPLIC, 0, 0);
        BREAK;
      end;
    end;
  end;

  showHideLog(False);

  // on met à jour l'espace disque disponible pour l'archivage et la base dans GENPARAM sur le chemin choisi
  diskSpace(FBasId);

  // uniquement dans l'init du launcher, on vérifie les droits réseau pour l'archivage AJ 26/04/2017
  checkNetworkArchivage(FBasId);
end;

procedure TFrm_LaunchV7.LaunchPiccoAuto();
var
  IBQue_Picco: TIBQuery;
  PathExe: string;
begin
  try
    // on vérifie qu'on est pas en base Test ou Archive, puis on regarde dans le GENPARAM si c'est au launcher de le lancer
    if IsBaseProd() then
    begin
      IBQue_Picco := TIBQuery.Create(nil);
      try
        IBQue_Picco.Transaction := Dm_LaunchMain.Tra_Ginkoia;

        IBQue_Picco.Close;
        IBQue_Picco.SQL.Clear;
        IBQue_Picco.SQL.Add('SELECT prm_id FROM GENPARAM ');
        IBQue_Picco.SQL.Add('JOIN K ON k_id = prm_id AND k_enabled = 1 ');
        IBQue_Picco.SQL.Add('WHERE prm_type = 9 AND prm_code = 414 ');
        IBQue_Picco.SQL.Add('AND prm_integer = -1 ');
        // si PRM_INTEGER = -1 c'est au launcher de lancer le PiccoBatch en mode automatique
        IBQue_Picco.SQL.Add('AND prm_pos = :BASID');
        IBQue_Picco.ParamByName('BASID').AsLargeInt := FBasId;
        IBQue_Picco.Open;

        // si on trouve une ligne, on vérifie que les retour et échanges sont paramétrés en automatique, et lance le PiccoBatch
        if not (IBQue_Picco.Eof) then
        begin
          IBQue_Picco.Close;
          IBQue_Picco.SQL.Clear;
          IBQue_Picco.SQL.Add('SELECT lmp_id, LMP_PICCOECH, LMP_PICCORET ');
          IBQue_Picco.SQL.Add('FROM LOCMAGPARAM ');
          IBQue_Picco.SQL.Add('JOIN cshmodeenc ON men_id = lmp_menid ');
          IBQue_Picco.SQL.Add('WHERE lmp_magid = :BAS_MAGID AND lmp_id <> 0 AND lmp_piccoech = 1 AND lmp_piccoret = 1 ');
          IBQue_Picco.ParamByName('BAS_MAGID').AsLargeInt := StrToInt(FBasMagID);
          IBQue_Picco.Open;
          if not (IBQue_Picco.Eof) then
          begin
            // c'est bien au launcher de lancer le piccobatch, et le mode auto est coché, donc on affiche la tuile
            EventPanel[12].visible := True;

            // on vérifie d'abord si le process tourne déjà, si il tourne on ne fait rien de plus
            if not (processExists('piccobatch.exe')) then
            begin
              // lancement de PiccoBatch en mode auto
              PathExe := extractFilePath(ParamStr(0)) + 'piccobatch.exe';

              ShellExecute(Handle, 'Open', PWideChar(PathExe), 'auto launcher', Nil, SW_SHOWDEFAULT);

              Log.Log('Main', FBasGuid, 'Log', 'Démarrage de PiccoBatch en mode automatique', logTrace, True, 0, ltLocal);
            end;
          end;
        end;
      finally
        IBQue_Picco.Free;
      end;
    end;
  except
    on E: Exception do
    begin
      showHideLog(True);
      Ajoute('Erreur dans le lancement automatique de PiccoBatch : ' + E.Message, 0, True);
      raise;
    end;
  end;

  hasLaunchPicco := True;
end;

// AJ 26/04/2017 : procédure qui vérifie que le chemin réseau existe pour l'archivage, et qu'il est bien partagé
procedure TFrm_LaunchV7.checkNetworkArchivage(bas_id: Integer);
var
  network: Tnetwork;
  networkName, pathArchive, diskName, nomMachine: string;
  isShared: Boolean;
  IBQue_Archive: TIBQuery;
  k_id: Integer;
  vSynchroCaisse: TSynchroCaisse;
begin
  // on récupère le chemin de l'archivage ainsi que son nom réseau, et on met à jour le genparam avec le nom machine du serveur (et on le mouvemente)
  IBQue_Archive := TIBQuery.Create(nil);
  try
    try
      vSynchroCaisse := getSynchroCaisse;

      IBQue_Archive.Transaction := Dm_LaunchMain.Tra_Ginkoia;

      IBQue_Archive.Close;
      IBQue_Archive.SQL.Text := 'SELECT PRM_STRING, PRM_FLOAT, PRM_CODE FROM GENPARAM ' + 'JOIN K ON K_ID = PRM_ID AND K_ENABLED  = 1 ' + 'WHERE prm_type=60 ' + 'AND prm_code IN (1,3) ' + 'AND prm_pos = :BASID';
      IBQue_Archive.ParamByName('BASID').AsLargeInt := bas_id;
      IBQue_Archive.Open;

      while not IBQue_Archive.Eof do
      begin
        if not IBQue_Archive.IsEmpty then
        begin
          if (IBQue_Archive.FieldByName('PRM_STRING').AsString <> '') and (IBQue_Archive.FieldByName('PRM_CODE').AsInteger = 1) then
          begin
            pathArchive := IBQue_Archive.FieldByName('PRM_STRING').AsString;
          end;

          if (IBQue_Archive.FieldByName('PRM_STRING').AsString <> '') and (IBQue_Archive.FieldByName('PRM_CODE').AsInteger = 3) then
          begin
            networkName := IBQue_Archive.FieldByName('PRM_STRING').AsString;
          end;
        end;
        IBQue_Archive.Next;
      end;

      // mise à jour du GENPARAM du nom de la machine du serveur
      IBQue_Archive.Close;
      IBQue_Archive.SQL.Clear;
      IBQue_Archive.SQL.Add('SELECT PRM_ID, PRM_STRING FROM GENPARAM ');
      IBQue_Archive.SQL.Add('JOIN K ON K_ID = PRM_ID AND K_ENABLED  = 1 ');
      IBQue_Archive.SQL.Add('WHERE prm_type = 3 ');
      IBQue_Archive.SQL.Add('AND prm_code = 36 ');
      IBQue_Archive.SQL.Add('AND prm_pos = :BASID');
      IBQue_Archive.ParamByName('BASID').AsLargeInt := bas_id;
      IBQue_Archive.Open;
      if not (IBQue_Archive.IsEmpty) then
      begin
        k_id := IBQue_Archive.FieldByName('PRM_ID').AsInteger;

        nomMachine := Log.Host;

        // si le nom de la machine à changé, on le met à jour
        if nomMachine <> IBQue_Archive.FieldByName('PRM_STRING').AsString then
        begin
          IBQue_Archive.Close;
          IBQue_Archive.SQL.Clear;
          IBQue_Archive.SQL.Add('UPDATE GENPARAM SET PRM_STRING = :nomMachine ');
          IBQue_Archive.SQL.Add('WHERE prm_type = 3 ');
          IBQue_Archive.SQL.Add('AND prm_code = 36 ');
          IBQue_Archive.SQL.Add('AND prm_pos = :BASID');
          IBQue_Archive.ParamByName('BASID').AsLargeInt := bas_id;
          IBQue_Archive.ParamByName('nomMachine').AsString := nomMachine;
          IBQue_Archive.ExecSQL;

          // on ne met à jour le nom du poste que si on est pas sur un portable de synchro / caisse de secours pour ne pas mouvementer et poser problème pour la synchro
          // car si on mouvemente, comme il n'y a qu'un push pour la synchro les données seront toujours considérées comme modifiées et la synchro ne se fera jamais
          if not (isPortableSynchro) and not (vSynchroCaisse.Enabled) then
          begin
            IBQue_Archive.Close;
            IBQue_Archive.SQL.Clear;
            IBQue_Archive.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:k_id,0)';
            IBQue_Archive.ParamByName('k_id').AsLargeInt := k_id;
            IBQue_Archive.ExecSQL;
          end;

          Commit;
        end;

        IBQue_Archive.Close;
      end;
    except
      on E: Exception do
      begin
        showHideLog(True);
        Ajoute('Impossible de récupérer le chemin de l''archivage dans la base de données : ' + E.Message, 0, True);
        raise;
      end;
    end;
  finally
    IBQue_Archive.Free;
  end;

  // on regarde si le chemin est partagé, si NON on le partage
  if (pathArchive <> '') and (networkName <> '') then
  begin
    network := Tnetwork.Create;

    try
      isShared := network.isFolderShared(pathArchive, networkName);

      if not (isShared) then
      begin
        // on regarde déjà si le disque du chemin existe, sinon on log en local qu'il n'existe pas
        diskName := ExtractFileDrive(pathArchive);
        if (getdrivetype(pchar(diskName)) = 3) then
        // 3 correspond à un disque fixe
        begin
          // Si le chemin existe, on regarde si le répertoire existe
          if not (DirectoryExists(pathArchive)) then
          begin
            Ajoute('Le chemin de l''archivage n''existe pas, création du répertoire');
            CreateDir(pathArchive);
          end;

          // on partage le chemin réseau avec le nom choisi
          try
            network.FolderShareDel(networkName);
            network.FolderShareAdd(pathArchive, networkName, 'Partage pour l''archivage GINKOIA');
            Log.Log('archivageNetwork', FBasGuid, 'Archivage', 'Partage du dossier de l''archivage sur le réseau', logTrace, True, 0, ltLocal);
          except
            on E: Exception do
              Log.Log('archivageNetwork', FBasGuid, 'Archivage', 'Echec du partage du dossier de l''archivage sur le réseau : ' + E.Message, logTrace, True, 0, ltLocal);
          end;

        end
        else
          Log.Log('archivageNetwork', FBasGuid, 'Archivage', 'Impossible de trouver le chemin du lecteur de l''archivage', logError, True, 0, ltLocal);
      end;
    finally
      network.Free;
    end;

  end;
end;

// AJ 19/04/2017 : fonction qui récupère le chemin de l'archivage et qui calcul l'espace disque restant en MO sur ce lecteur
function FileSize(fileName: wideString): Int64;
var
  sr: TSearchRec;
begin
  if FindFirst(fileName, faAnyFile, sr) = 0 then
    Result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
  else
    Result := -1;
  FindClose(sr);
end;

procedure TFrm_LaunchV7.diskSpace(bas_id: Integer);
var
  IBQue_DiskSpace: TIBQuery;
  archivageRestauration, archivageStockage: string;
  baseDisk: string;
  freeSpaceRestauration, freeSpaceBase, freeSpaceStockage, baseSize, k_id: Integer;
  vSynchroCaisse: TSynchroCaisse;
begin
  archivageRestauration := '';
  archivageStockage := '';
  freeSpaceRestauration := 0;
  freeSpaceStockage := 0;

  // on récupère les parmètres de synchro caisse pour savoir si c'est une caisse de secours
  vSynchroCaisse := getSynchroCaisse;

  baseDisk := ExtractFileDrive(LaBase0);
  baseSize := Ceil(FileSize(LaBase0) / (power(1024, 2)));
  // taille en Mo de la base, arrondi à l'entier supérieur

  // on remonte la taille de la base dans le monitoring
  Log.Log('BaseSize', FBasGuid, 'Base', IntToStr(baseSize), logInfo, True, 0, ltServer);

  IBQue_DiskSpace := TIBQuery.Create(nil);
  try
    IBQue_DiskSpace.Transaction := Dm_LaunchMain.Tra_Ginkoia;

    // Mise à jour du genparam de la taille de la base0, update K
    try
      k_id := 0;
      // on récupère l'id du genparam pour le mettre à jour ainsi que son K
      IBQue_DiskSpace.Close;
      IBQue_DiskSpace.SQL.Clear;
      IBQue_DiskSpace.SQL.Text := 'SELECT PRM_ID FROM GENPARAM ' + 'JOIN K ON K_ID = PRM_ID AND K_ENABLED  = 1 ' + 'WHERE prm_type = 60 ' + 'AND prm_code = 3 ' + 'AND prm_pos = :BASID';
      IBQue_DiskSpace.ParamByName('BASID').AsLargeInt := bas_id;
      IBQue_DiskSpace.Open;
      if not (IBQue_DiskSpace.IsEmpty) then
        k_id := IBQue_DiskSpace.FieldByName('PRM_ID').AsInteger;

      if (k_id > 0) then
      begin
        IBQue_DiskSpace.Close;
        IBQue_DiskSpace.SQL.Clear;
        IBQue_DiskSpace.SQL.Text := 'UPDATE GENPARAM SET PRM_INTEGER = :baseSize ' + 'WHERE prm_type = 60 ' + 'AND prm_code = 3 ' + 'AND prm_pos = :BASID';
        IBQue_DiskSpace.ParamByName('BASID').AsLargeInt := bas_id;
        IBQue_DiskSpace.ParamByName('baseSize').AsFloat := baseSize;
        IBQue_DiskSpace.ExecSQL;

        // on ne met à jour l'espace disque dispo que si on est pas sur un portable de synchro / caisse de secours pour ne pas mouvementer et poser problème pour la synchro
        // si on mouvemente, comme il n'y a qu'un push pour la synchro les données seront toujours considérées comme modifiées et la synchro ne se fera jamais
        if not (isPortableSynchro) and not (vSynchroCaisse.Enabled) then
        begin
          IBQue_DiskSpace.Close;
          IBQue_DiskSpace.SQL.Clear;
          IBQue_DiskSpace.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:k_id,0)';
          IBQue_DiskSpace.ParamByName('k_id').AsLargeInt := k_id;
          IBQue_DiskSpace.ExecSQL;
        end;

        Commit;
      end;
    except
      on E: Exception do
      begin
        Dm_LaunchMain.Tra_Ginkoia.Rollback;
        showHideLog(True);
        Ajoute('Impossible mettre à jour la taille de la base pour l''archivage : ' + E.Message, 0, True);
        raise;
      end;
    end;

    // ***********************************************************************
    // partie pour l'espace disque du chemin de stockage de l'archivage ******
    // ***********************************************************************
    try
      k_id := 0;

      // on récupère l'id du genparam pour le mettre à jour ainsi que son K
      IBQue_DiskSpace.Close;
      IBQue_DiskSpace.SQL.Text := 'SELECT PRM_ID, PRM_STRING, PRM_FLOAT FROM GENPARAM ' + 'JOIN K ON K_ID = PRM_ID AND K_ENABLED  = 1 ' + 'WHERE prm_type = 60 ' + 'AND prm_code = 8 ' + 'AND prm_pos = :BASID';
      IBQue_DiskSpace.ParamByName('BASID').AsLargeInt := bas_id;
      IBQue_DiskSpace.Open;

      if not IBQue_DiskSpace.IsEmpty then
      begin
        k_id := IBQue_DiskSpace.FieldByName('PRM_ID').AsInteger;
        if IBQue_DiskSpace.FieldByName('PRM_STRING').AsString <> '' then
        begin
          archivageStockage := IBQue_DiskSpace.FieldByName('PRM_STRING').AsString;
          archivageStockage := ExtractFileDrive(archivageStockage);
        end;
      end;
      IBQue_DiskSpace.Close;

      if (getdrivetype(pchar(archivageStockage)) = 2) or (getdrivetype(pchar(archivageStockage)) = 3) or (getdrivetype(pchar(archivageStockage)) = 4) then
      // drivetype = 2 -> disque removable, comme clé usb
      // drivetype = 3 -> disque dur fixe
      // drivetype = 4 -> disque réseau
      begin
        // on arrondi à l'entier inférieur pour la taille en mo
        freeSpaceStockage := Floor(EspaceDisque(archivageStockage, tedLibre, tuoMoctet));

        if (freeSpaceStockage < (baseSize)) then
          // si on a pas deux fois la taille de la base en espace disque dispo, on remonte un warning
          Log.Log('DiskSpace', FBasGuid, 'Archivage', IntToStr(freeSpaceStockage), logWarning, True, 0, ltServer)
        else
          Log.Log('DiskSpace', FBasGuid, 'Archivage', IntToStr(freeSpaceStockage), logInfo, True, 0, ltServer);
      end
      else // on ne trouve pas le chemin : on log en erreur
      begin
        Log.Log('DiskSpace', FBasGuid, 'Archivage', 'Impossible de trouver le chemin du lecteur', logError, True, 0, ltServer);
      end;

      // Mise à jour du genparam de l'espace disque de l'archivage
      try
        if (k_id > 0) then
        begin
          IBQue_DiskSpace.Close;
          IBQue_DiskSpace.SQL.Clear;
          IBQue_DiskSpace.SQL.Text := 'UPDATE GENPARAM SET PRM_FLOAT = :freeSpaceStockage ' + 'WHERE prm_type = 60 ' + 'AND prm_code = 8 ' + 'AND prm_pos = :BASID';
          IBQue_DiskSpace.ParamByName('BASID').AsLargeInt := bas_id;
          IBQue_DiskSpace.ParamByName('freeSpaceStockage').AsFloat := freeSpaceStockage;
          IBQue_DiskSpace.ExecSQL;

          // on ne met à jour l'espace disque dispo que si on est pas sur un portable de synchro / caisse de secours pour ne pas mouvementer et poser problème pour la synchro
          // si on mouvemente, comme il n'y a qu'un push pour la synchro les données seront toujours considérées comme modifiées et la synchro ne se fera jamais
          if not (isPortableSynchro) and not (vSynchroCaisse.Enabled) then
          begin
            IBQue_DiskSpace.Close;
            IBQue_DiskSpace.SQL.Clear;
            IBQue_DiskSpace.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:k_id,0)';
            IBQue_DiskSpace.ParamByName('k_id').AsLargeInt := k_id;
            IBQue_DiskSpace.ExecSQL;
          end;

          Commit;
        end;
      except
        on E: Exception do
        begin
          Dm_LaunchMain.Tra_Ginkoia.Rollback;
          showHideLog(True);
          Ajoute('Impossible mettre à jour l''espace disque disponible pour le stockage de l''archivage : ' + E.Message, 0, True);
          raise;
        end;
      end;
    except
      on E: Exception do
      begin
        showHideLog(True);
        Ajoute('Impossible de récupérer le chemin de stockage de l''archivage dans la base de données : ' + E.Message, 0, True);
        raise;
      end;
    end;

    // ***********************************************************
    // partie pour l'espace disque du chemin de RESTAURATION de l'archivage ******
    // ***********************************************************
    try
      k_id := 0;

      IBQue_DiskSpace.Close;
      IBQue_DiskSpace.SQL.Text := 'SELECT PRM_ID, PRM_STRING, PRM_FLOAT FROM GENPARAM ' + 'JOIN K ON K_ID = PRM_ID AND K_ENABLED  = 1 ' + 'WHERE prm_type = 60 ' + 'AND prm_code = 1 ' + 'AND prm_pos = :BASID';
      IBQue_DiskSpace.ParamByName('BASID').AsLargeInt := bas_id;
      IBQue_DiskSpace.Open;

      if not IBQue_DiskSpace.IsEmpty then
      begin
        k_id := IBQue_DiskSpace.FieldByName('PRM_ID').AsInteger;
        if IBQue_DiskSpace.FieldByName('PRM_STRING').AsString <> '' then
        begin
          archivageRestauration := IBQue_DiskSpace.FieldByName('PRM_STRING').AsString;
          archivageRestauration := ExtractFileDrive(archivageRestauration);
        end;
      end;
      IBQue_DiskSpace.Close;

      // on ne log plus cette partie qui devient la restauration, à la place on log le nouveau genparam pour le stockage
      if (getdrivetype(pchar(archivageRestauration)) = 3) then
      // drivetype = 3 -> disque dur fixe
      begin
        // on arrondi à l'entier inférieur pour la taille en mo
        freeSpaceRestauration := Floor(EspaceDisque(archivageRestauration, tedLibre, tuoMoctet));
      end;

      // Mise à jour du genparam de l'espace disque de l'archivage
      try
        if (k_id > 0) then
        begin
          IBQue_DiskSpace.Close;
          IBQue_DiskSpace.SQL.Clear;
          IBQue_DiskSpace.SQL.Text := 'UPDATE GENPARAM SET PRM_FLOAT = :freeSpaceRestauration ' + 'WHERE prm_type = 60 ' + 'AND prm_code = 1 ' + 'AND prm_pos = :BASID';
          IBQue_DiskSpace.ParamByName('BASID').AsLargeInt := bas_id;
          IBQue_DiskSpace.ParamByName('freeSpaceRestauration').AsFloat := freeSpaceRestauration;
          IBQue_DiskSpace.ExecSQL;

          // on ne met à jour l'espace disque dispo que si on est pas sur un portable de synchro / caisse de secours pour ne pas mouvementer et poser problème pour la synchro
          // si on mouvemente, comme il n'y a qu'un push pour la synchro les données seront toujours considérées comme modifiées et la synchro ne se fera jamais
          if not (isPortableSynchro) and not (vSynchroCaisse.Enabled) then
          begin
            IBQue_DiskSpace.Close;
            IBQue_DiskSpace.SQL.Clear;
            IBQue_DiskSpace.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:k_id,0)';
            IBQue_DiskSpace.ParamByName('k_id').AsLargeInt := k_id;
            IBQue_DiskSpace.ExecSQL;
          end;

          Commit;
        end;
      except
        on E: Exception do
        begin
          Dm_LaunchMain.Tra_Ginkoia.Rollback;
          showHideLog(True);
          Ajoute('Impossible mettre à jour la taille de l''espace disque pour la restauration de l''archivage : ' + E.Message, 0, True);
          raise;
        end;
      end;
    except
      on E: Exception do
      begin
        showHideLog(True);
        Ajoute('Impossible de récupérer le chemin de la restauration de l''archivage dans la base de données : ' + E.Message, 0, True);
        raise;
      end;
    end;

    // ***********************************************************
    // partie pour l'espace disque du chemin de la base de données
    // ***********************************************************
    try
      if (baseDisk = archivageStockage) then
      begin
        freeSpaceBase := freeSpaceStockage;
        if (freeSpaceBase < (baseSize * 2)) then
          // si on a pas deux fois la taille de la base en espace disque dispo, on remonte un warning
          Log.Log('DiskSpace', FBasGuid, 'Base', IntToStr(freeSpaceBase), logWarning, True, 0, ltServer)
        else
          Log.Log('DiskSpace', FBasGuid, 'Base', IntToStr(freeSpaceBase), logInfo, True, 0, ltServer);
      end
      else
      begin
        if (getdrivetype(pchar(baseDisk)) = 3) then
        // drivetype = 3 -> disque dur fixe
        begin
          freeSpaceBase := Floor(EspaceDisque(baseDisk, tedLibre, tuoMoctet));

          if (freeSpaceBase < (baseSize * 2)) then
            // si on a pas deux fois la taille de la base en espace disque dispo, on remonte un warning
            Log.Log('DiskSpace', FBasGuid, 'Base', IntToStr(freeSpaceBase), logWarning, True, 0, ltServer)
          else
            Log.Log('DiskSpace', FBasGuid, 'Base', IntToStr(freeSpaceBase), logInfo, True, 0, ltServer);
        end
        else
          Log.Log('DiskSpace', FBasGuid, 'Base', 'Impossible de trouver le chemin du lecteur', logError, True, 0, ltServer);
      end;
    except
      on E: Exception do
      begin
        showHideLog(True);
        Ajoute('Impossible de récupérer l''espace disque disponible sur le disque de la base0 : ' + E.Message, 0, True);
        raise;
      end;
    end;
  finally
    IBQue_DiskSpace.Free;
  end;
end;

function TFrm_LaunchV7.EspaceDisque(disque: string; espace: TEspaceDisque; unite: TUniteOctet): extended;
var
  lpFreeBytesAvailableToCaller: TLargeInteger;
  lpTotalNumberOfBytes: TLargeInteger;
  lpTotalNumberOfFreeBytes: TLargeInteger;
  taille: extended;
begin

  if GetDiskFreeSpaceEx(pchar(disque), lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, @lpTotalNumberOfFreeBytes) then
  begin
    case espace of
      tedTotal:
        taille := lpTotalNumberOfBytes;
      tedLibre:
        taille := lpTotalNumberOfFreeBytes;
      tedUtilise:
        taille := lpTotalNumberOfBytes - lpTotalNumberOfFreeBytes;
    else
      taille := lpTotalNumberOfBytes;
    end;

    case unite of
      tuoOctet:
        taille := taille;
      tuoKoctet:
        taille := taille / (power(1024, 1));
      tuoMoctet:
        taille := taille / (power(1024, 2));
      tuoGoctet:
        taille := taille / (power(1024, 3));
      tuoToctet:
        taille := taille / (power(1024, 4));
    else
      taille := taille / (power(1024, 2));
    end;
  end;

  Result := RoundTo(taille, -2);
end;

procedure TFrm_LaunchV7.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  Log.Log('Main', FBasGuid, 'Log', 'Arrêt du Launcher', logTrace, True, 0, ltLocal);
  FreeAndNil(ThreadSrvCheckStatusMobilite);
  for I := 0 to ListeReplication.Count - 1 do
    TLesreplication(ListeReplication[I]).Free;
  ListeReplication.Free;
  for I := 0 to ListeConnexion.Count - 1 do
    TLesConnexion(ListeConnexion[I]).Free;
  ListeConnexion.Free;
  for I := 0 to ListeReference.Count - 1 do
    TLesReference(ListeReference[I]).Free;
  ListeReference.Free;

  for I := 0 to ListeRefPF.Count - 1 do
    TLesReference(ListeRefPF[I]).Free;
  ListeRefPF.Free;

  // FC : 16/12/2008, Ajout du module réplic en journée
  for I := 0 to ListeReplicWeb.Count - 1 do
    TLesReference(ListeReplicWeb[I]).Free;
  ListeReplicWeb.Free;
  // Fin Ajout FC : 16/12/2008, Ajout du module réplic en journée

  // FL : 04/03/2014
  if Assigned(PingList) then
    FreeAndNil(PingList);

  DeleteCriticalSection(lLogLock);

  taskReplication.Free;
  taskReplicationPF.Free;
  taskReplicationWeb.Free;
  taskSynchroNotebook.Free;
  taskSynchroCaisse.Free;

  KRange.Free;

  bmpRange[0].Free;
  bmpRange[1].Free;
  bmpRange[2].Free;

  Log.Log('Main', FBasGuid, 'Log', 'Launcher arrêté', logTrace, True, 0, ltLocal);
  Log.Log('Main', FBasGuid, 'Status', 'Launcher arrêté', logWarning, True, 3600, ltServer);
  Log.Close;

  Delos2Easy.Free;
end;

procedure TFrm_LaunchV7.FormShow(Sender: TObject);
begin
  // on met le focus sur le bouton "reduire" après le lancement
  Nbt_Reduire.SetFocus;
end;

// ---------------------------------------------------------------
// Passage de V7 à V4
// ---------------------------------------------------------------

// ---------------------------------------------------------------
// Initialisation de La base maitre
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.Btn_InitClick(Sender: TObject);
var
  reg: TRegistry;
  vPassName: String;
begin
  if TAdvGlowButton(Sender).Name = 'Btn_InitAccueil' then
    vPassName := 'PassInit'
  else
    vPassName := 'NoNeedPassword';

  // Initialisation de la base de référence
  if (Sender = NIL) or (MotDePasse(vPassName)) then
  begin
    if Od.Execute then
    begin
      if Od.fileName <> LaBase0 then
      begin
        Btn_Init.visible := False;
        Btn_InitAccueil.Visible := False;

        LaBase0 := Od.fileName;
        try
          reg := TRegistry.Create(KEY_WRITE);
          try
            reg.RootKey := HKEY_LOCAL_MACHINE;
            reg.OpenKey('SOFTWARE\Algol\Ginkoia', True);
            reg.WriteString('Base0', LaBase0);
          finally
            reg.closekey;
            reg.Free;

            // on redémarre le launcher
            ShowMessage('Le launcher va redémarrer');
            ShellExecute(Handle, 'Open', PWideChar(application.ExeName), 'RESTART', Nil, SW_SHOWDEFAULT);
            Application.Terminate;
          end;
        except
          Application.MessageBox('Les droits Administrateur sont obligatoires pour modifier les registres', 'Attention', Mb_Ok);
        end;
        Init();
      end;
    end;
  end;
end;

// ---------------------------------------------------------------
// Lecture des données de la réplication (Base horraire etc)
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.InitEtat;
var
  D: DWord;
begin
  Lab_Etat1.Caption := '';
  if AUTORUN then
    Lab_Etat1.Caption := Lab_Etat1.Caption + 'Automatique ';
  if H1 and H2 then
    Lab_Etat1.Caption := Lab_Etat1.Caption + '2 réplications ';
  if EtatBackup = 5 then
    Lab_Etat1.Caption := Lab_Etat1.Caption + 'Backup ';

  Lab_Etat2.Caption := '';
  if ModeDebug or (GetTickCount > 3 * 24 * 60 * 60 * 1000) then
  begin
    if GetTickCount > 2 * 24 * 60 * 60 * 1000 then
    begin
      D := GetTickCount;
      D := D div 1000;
      D := D div 60;
      D := D div 60;
      D := D div 24;
      Lab_Etat2.Caption := 'Votre ordinateur n''a pas redémarré depuis plus de ' + IntToStr(D) + ' jours'
    end
    else if GetTickCount > 1 * 24 * 60 * 60 * 1000 then
      Lab_Etat2.Caption := 'Votre ordinateur n''a pas redémarré depuis plus d''un jour'
    else
      Lab_Etat2.Caption := 'Votre ordinateur à redémaré depuis moins d''un jours';
  end;

  DoEventStatus;
end;

procedure TFrm_LaunchV7.InitialiseLaunch;
var
  reg: TRegistry;
  k: Integer;
  j: Integer;
  I: Integer;
  repli: TLesreplication;
  Prov: TLesProvider;
  connex: TLesConnexion;
  S: string;
  Hh, Mm, Ss, Dd: Word;
  h: Integer;
  ini: TIniFile;
  Ref: TLesReference;
  RefLig: TLesReferenceLig;
  vReplicationActif: Boolean;
  vReplicationWebActif: Boolean;
  vReplicationPFActif: Boolean;
begin
  vReplicationActif := False;
  vReplicationWebActif := False;
  vReplicationPFActif := False;
  try

    Ajoute('Initialisation du launcher', 0, True);
    try
      EtatBackup := -1;
      // initialiser la variable d'erreur de recalcul des trigger
      boolRecalculOk := True;
      // synchroEnCours := False; // flag signalant qu'un synchro est en cours

      // Récupération des données de la réplication
      Tim_LanceRepli.Enabled := False;
      try
        Dm_LaunchMain.Dtb_Ginkoia.Close;
        try
          Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := LaBase0;
          try
            Dm_LaunchMain.Dtb_Ginkoia.Open;
          except
            on E: Exception do
            begin
              showHideLog(True);
              Ajoute('Problème connexion à la base InitialiseLaunch : ' + E.Message, 0, True);
              raise;
            end;
          end;

          // Ouverture de la transaction
          // if not Dm_LaunchMain.Tra_Ginkoia.InTransaction then
          Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

          // récupération de l'Id de la base 0
          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IB_LaBase (avant).', logDebug, True, 0, ltLocal);
          IB_LaBase.Open;
          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IB_LaBase (après).', logDebug, True, 0, ltLocal);

          IdBase0 := IB_LaBaseBAS_ID.AsInteger;
          NomBase0 := IB_LaBaseBAS_IDENT.AsString + ' - ' + IB_LaBaseBAS_NOM.AsString;
          PanFondPrincipal.GinkoiaAddon.PanTop.Labels.CaptionCenter := 'Launcher V' + GetNumVersionSoft + ' / Base : ' + NomBase0;
          IB_LaBase.Close;

          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_GetVersion (avant).', logDebug, True, 0, ltLocal);
          IBQue_GetVersion.Close;
          IBQue_GetVersion.Open;
          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_GetVersion (après).', logDebug, True, 0, ltLocal);

          sVersionEnCours := IBQue_GetVersion.Fields[0].AsString;
          IBQue_GetVersion.Close;

          checkKRange;

          // Récupération des horraires de réplication
          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_Horraire (avant).', logDebug, True, 0, ltLocal);
          Ib_Horraire.ParamByName('BasId').AsInteger := IdBase0;
          Ib_Horraire.Open;
          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_Horraire (après).', logDebug, True, 0, ltLocal);

          LauId := Ib_HorraireLAU_ID.AsInteger;
          HEURE1 := Ib_HorraireLAU_HEURE1.AsDateTime;
          H1 := Ib_HorraireLAU_H1.AsInteger = 1;
          HEURE2 := Ib_HorraireLAU_HEURE2.AsDateTime;
          H2 := Ib_HorraireLAU_H2.AsInteger = 1;
          AUTORUN := Ib_HorraireLAU_AUTORUN.AsInteger = 1;

          if Ib_HorraireLAU_BACK.AsInteger = 1 then
          begin
            EtatBackup := 5;
            HeureBackup := Ib_HorraireLAU_BACKTIME.AsDateTime;
          end;
          Ib_Horraire.Close;

          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IB_ForceMAJ (avant).', logDebug, True, 0, ltLocal);
          IB_ForceMAJ.ParamByName('BasId').AsInteger := IdBase0;
          IB_ForceMAJ.Open;
          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IB_ForceMAJ (après).', logDebug, True, 0, ltLocal);

          ForcerLaMaj := IB_ForceMAJPRM_POS.AsInteger = 1;
          IB_ForceMAJ.Close;

          // Vérification du lancement automatique
          try
            reg := TRegistry.Create(KEY_WRITE);
            try
              reg.RootKey := HKEY_LOCAL_MACHINE;
              reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False);

              if AUTORUN then
                reg.WriteString('Launch_Replication', Application.exename)
              else
                reg.DeleteValue('Launch_Replication');
            finally
              reg.closekey;
              reg.Free;
            end;
          except
            Ajoute(DateTimeToStr(Now) + '   ' + 'Problème de modification des registres', 0);
          end;

          Ajoute('Libération des listes ', 0, True);

          for I := 0 to ListeReplication.Count - 1 do
            TLesreplication(ListeReplication[I]).Free;
          ListeReplication.Clear;
          for I := 0 to ListeConnexion.Count - 1 do
            TLesConnexion(ListeConnexion[I]).Free;
          ListeConnexion.Clear;
          for I := 0 to ListeReference.Count - 1 do
            TLesReference(ListeReference[I]).Free;
          ListeReference.Clear;
          for I := 0 to ListeRefPF.Count - 1 do
            TLesReference(ListeRefPF[I]).Free;
          ListeRefPF.Clear;
          for I := 0 to ListeReplicWeb.Count - 1 do
            TLesReference(ListeReplicWeb[I]).Free;
          ListeReplicWeb.Clear;

          // Lecture des connexions
          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IB_Connexion (avant).', logDebug, True, 0, ltLocal);
          IB_Connexion.ParamByName('Lauid').AsInteger := LauId;
          IB_Connexion.Open;
          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IB_Connexion (après).', logDebug, True, 0, ltLocal);

          IB_Connexion.First;
          while not IB_Connexion.Eof do
          begin
            connex := TLesConnexion.Create;
            connex.Id := IB_ConnexionCON_ID.AsInteger;
            connex.Nom := IB_ConnexionCON_NOM.AsString;
            connex.Tel := IB_ConnexionCON_TEL.AsString;
            connex.LeType := IB_ConnexionCON_TYPE.AsInteger;
            ListeConnexion.Add(connex);
            IB_Connexion.Next;
          end;
          IB_Connexion.Close;

          // Lecture des données de réplication
          Ajoute('Lecture des données de réplication ', 0, True);

          // Ajout du module Réplic journalière (différent de réplic journée pr web).
          bReplicTpsReelActif := False;
          MajParamReplicTpsReel;
          Tim_ReplicTpsReel.Enabled := True;

          // FC : 16/12/2008, Ajout du module réplic en journée
          bReplicWebActif := False;
          MajDebFinReplicWeb();
          vReplicationWebActif := bReplicWebActif;

          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_ReplicWeb (avant).', logDebug, True, 0, ltLocal);

          Ib_ReplicWeb.ParamByName('Lauid').AsInteger := LauId;
          try
            Ib_ReplicWeb.Open;
          except
            on E: Exception do
            begin
              Ajoute(E.Message, 1);
              raise Exception.Create(E.Message);
            end;
          end;

          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_ReplicWeb (après).', logDebug, True, 0, ltLocal);
          Ib_ReplicWeb.First;

          while not Ib_ReplicWeb.Eof do
          begin
            repli := TLesreplication.Create;
            repli.Id := Ib_ReplicWebREP_ID.AsInteger;
            repli.Ping := Ib_ReplicWebREP_PING.AsString;
            repli.PUSH := Ib_ReplicWebREP_PUSH.AsString;
            repli.PULL := Ib_ReplicWebREP_PULL.AsString;
            repli.User := Ib_ReplicWebREP_USER.AsString;
            repli.PWD := Ib_ReplicWebREP_PWD.AsString;
            repli.URLLocal := Ib_ReplicWebREP_URLLOCAL.AsString;
            repli.URLDISTANT := Ib_ReplicWebREP_URLDISTANT.AsString;
            repli.PlaceEai := IncludeTrailingPathDelimiter(Ib_ReplicWebREP_PLACEEAI.AsString);
            repli.PlaceBase := Ib_ReplicWebREP_PLACEBASE.AsString;
            repli.ExeFinReplic := Ib_ReplicWebREP_EXEFINREPLIC.AsString;

            ListeReplicWeb.Add(repli);

            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_ProvRepli (avant).', logDebug, True, 0, ltLocal);
            Ib_ProvRepli.ParamByName('REPID').AsInteger := Ib_ReplicWebREP_ID.AsInteger;
            Ib_ProvRepli.Open;
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_ProvRepli (après).', logDebug, True, 0, ltLocal);

            Ib_ProvRepli.First;
            while not Ib_ProvRepli.Eof do
            begin
              Prov := TLesProvider.Create;
              Prov.Id := Ib_ProvRepliPRO_ID.AsInteger;
              Prov.Nom := Ib_ProvRepliPRO_NOM.AsString;
              Prov.LOOP := Ib_ProvRepliPRO_LOOP.AsInteger;
              repli.ListProvider.Add(Prov);
              Ib_ProvRepli.Next;
            end;
            Ib_ProvRepli.Close;

            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_SubsRepli (avant).', logDebug, True, 0, ltLocal);
            Ib_SubsRepli.ParamByName('REPID').AsInteger := Ib_ReplicWebREP_ID.AsInteger;
            Ib_SubsRepli.Open;
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_SubsRepli (après).', logDebug, True, 0, ltLocal);

            Ib_SubsRepli.First;
            while not Ib_SubsRepli.Eof do
            begin
              Prov := TLesProvider.Create;
              Prov.Id := Ib_SubsRepliSUB_ID.AsInteger;
              Prov.Nom := Ib_SubsRepliSUB_NOM.AsString;
              Prov.LOOP := Ib_SubsRepliSUB_LOOP.AsInteger;
              repli.ListSubScriber.Add(Prov);
              Ib_SubsRepli.Next;
            end;
            Ib_SubsRepli.Close;
            Ib_ReplicWeb.Next;
          end;
          Ib_ReplicWeb.Close;

          // Fin Ajout FC : 16/12/2008, Ajout du module réplic en journée
          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_Replication (avant).', logDebug, True, 0, ltLocal);
          Ib_Replication.ParamByName('Lauid').AsInteger := LauId;
          Ib_Replication.Open;
          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_Replication (après).', logDebug, True, 0, ltLocal);

          Ib_Replication.First;
          // Création des objets contenant chaque dossier de réplication
          // Avec les providers et subscribers associés
          while not Ib_Replication.Eof do
          begin
            repli := TLesreplication.Create;
            repli.Id := Ib_ReplicationREP_ID.AsInteger;
            repli.Ping := Ib_ReplicationREP_PING.AsString;
            repli.PUSH := Ib_ReplicationREP_PUSH.AsString;
            repli.PULL := Ib_ReplicationREP_PULL.AsString;
            repli.User := Ib_ReplicationREP_USER.AsString;
            repli.PWD := Ib_ReplicationREP_PWD.AsString;
            repli.URLLocal := Ib_ReplicationREP_URLLOCAL.AsString;
            repli.URLDISTANT := Ib_ReplicationREP_URLDISTANT.AsString;
            repli.PlaceEai := IncludeTrailingPathDelimiter(Ib_ReplicationREP_PLACEEAI.AsString);
            repli.PlaceBase := Ib_ReplicationREP_PLACEBASE.AsString;
            repli.bReplicJour := (Ib_ReplicationREP_JOUR.AsInteger = 1);
            repli.ExeFinReplic := Ib_ReplicationREP_EXEFINREPLIC.AsString;

            vReplicationActif := True;
            bReplicTpsReelActif := (bReplicTpsReelActif or repli.bReplicJour);

            ListeReplication.Add(repli);
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_ProvRepli (avant).', logDebug, True, 0, ltLocal);
            Ib_ProvRepli.ParamByName('REPID').AsInteger := Ib_ReplicationREP_ID.AsInteger;
            Ib_ProvRepli.Open;
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_ProvRepli (après).', logDebug, True, 0, ltLocal);

            Ib_ProvRepli.First;
            while not Ib_ProvRepli.Eof do
            begin
              Prov := TLesProvider.Create;
              Prov.Id := Ib_ProvRepliPRO_ID.AsInteger;
              Prov.Nom := Ib_ProvRepliPRO_NOM.AsString;
              Prov.LOOP := Ib_ProvRepliPRO_LOOP.AsInteger;
              repli.ListProvider.Add(Prov);
              Ib_ProvRepli.Next;
            end;
            Ib_ProvRepli.Close;

            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_SubsRepli (avant).', logDebug, True, 0, ltLocal);
            Ib_SubsRepli.ParamByName('REPID').AsInteger := Ib_ReplicationREP_ID.AsInteger;
            Ib_SubsRepli.Open;
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Ib_SubsRepli (après).', logDebug, True, 0, ltLocal);

            Ib_SubsRepli.First;
            while not Ib_SubsRepli.Eof do
            begin
              Prov := TLesProvider.Create;
              Prov.Id := Ib_SubsRepliSUB_ID.AsInteger;
              Prov.Nom := Ib_SubsRepliSUB_NOM.AsString;
              Prov.LOOP := Ib_SubsRepliSUB_LOOP.AsInteger;
              repli.ListSubScriber.Add(Prov);
              Ib_SubsRepli.Next;
            end;
            Ib_SubsRepli.Close;
            Ib_Replication.Next;
          end;
          Ib_Replication.Close;

          // Lecture des données sup
          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_Reference (avant).', logDebug, True, 0, ltLocal);
          IBQue_Reference.Close;
          IBQue_Reference.Open;
          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_Reference (après).', logDebug, True, 0, ltLocal);

          while not IBQue_Reference.Eof do
          begin
            // Controle, pour savoir si on doit traiter cette ligne de référencement.
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_ReferDesactive (avant).', logDebug, True, 0, ltLocal);
            IBQue_ReferDesactive.ParamByName('BASID').AsInteger := IdBase0;
            IBQue_ReferDesactive.ParamByName('RREID').AsInteger := IBQue_ReferenceRRE_ID.AsInteger;
            IBQue_ReferDesactive.Open;
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_ReferDesactive (après).', logDebug, True, 0, ltLocal);

            if IBQue_ReferDesactive.Fields[0].AsInteger = 0 then
            begin
              Ref := TLesReference.Create;
              Ref.Id := IBQue_ReferenceRRE_ID.AsInteger;
              Ref.Position := IBQue_ReferenceRRE_POSITION.AsInteger;
              Ref.Place := IBQue_ReferenceRRE_PLACE.AsInteger;
              Ref.Url := IBQue_ReferenceRRE_URL.AsString;
              Ref.Ordre := IBQue_ReferenceRRE_ORDRE.AsString;
              Ref.Plateforme := IBQue_ReferenceRRE_PF.AsInteger;
              ListeReference.Add(Ref);

              Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_RefLig (avant).', logDebug, True, 0, ltLocal);
              IBQue_RefLig.ParamByName('RREID').AsInteger := IBQue_ReferenceRRE_ID.AsInteger;
              IBQue_RefLig.Open;
              Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_RefLig (après).', logDebug, True, 0, ltLocal);

              while not IBQue_RefLig.Eof do
              begin
                RefLig := TLesReferenceLig.Create;
                RefLig.Id := IBQue_RefLigRRL_ID.AsInteger;
                RefLig.Param := IBQue_RefLigRRL_PARAM.AsString;
                Ref.LesLig.Add(RefLig);

                IBQue_RefLig.Next;
              end;
              IBQue_RefLig.Close;
            end;
            IBQue_ReferDesactive.Close;

            IBQue_Reference.Next;
          end;
          IBQue_Reference.Close;

          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_RefPF (avant).', logDebug, True, 0, ltLocal);
          IBQue_RefPF.Close;
          IBQue_RefPF.Open;
          Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_RefPF (après).', logDebug, True, 0, ltLocal);

          while not IBQue_RefPF.Eof do
          begin
            // Controle, pour savoir si on doit traiter cette ligne de référencement.
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_ReferDesactive (avant).', logDebug, True, 0, ltLocal);
            IBQue_ReferDesactive.ParamByName('BASID').AsInteger := IdBase0;
            IBQue_ReferDesactive.ParamByName('RREID').AsInteger := IBQue_ReferenceRRE_ID.AsInteger;
            IBQue_ReferDesactive.Open;
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_ReferDesactive (après).', logDebug, True, 0, ltLocal);

            if IBQue_ReferDesactive.Fields[0].AsInteger = 0 then
            begin
              Ref := TLesReference.Create;
              Ref.Id := IBQue_RefPFRRE_ID.AsInteger;
              Ref.Position := IBQue_RefPFRRE_POSITION.AsInteger;
              Ref.Place := IBQue_RefPFRRE_PLACE.AsInteger;
              Ref.Url := IBQue_RefPFRRE_URL.AsString;
              Ref.Ordre := IBQue_RefPFRRE_ORDRE.AsString;
              Ref.Plateforme := IBQue_RefPFRRE_PF.AsInteger;
              ListeRefPF.Add(Ref);

              vReplicationPFActif := bReplicPlateforme;

              Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_RefLig (avant).', logDebug, True, 0, ltLocal);
              IBQue_RefLig.ParamByName('RREID').AsInteger := IBQue_RefPFRRE_ID.AsInteger;
              IBQue_RefLig.Open;
              Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'IBQue_RefLig (après).', logDebug, True, 0, ltLocal);

              while not IBQue_RefLig.Eof do
              begin
                RefLig := TLesReferenceLig.Create;
                RefLig.Id := IBQue_RefLigRRL_ID.AsInteger;
                RefLig.Param := IBQue_RefLigRRL_PARAM.AsString;
                Ref.LesLig.Add(RefLig);

                IBQue_RefLig.Next;
              end;
              IBQue_RefLig.Close;
            end;
            IBQue_ReferDesactive.Close;

            IBQue_RefPF.Next;
          end;
          IBQue_RefPF.Close;

          if ListeReplication.Count < 1 then
          begin
            H1 := False;
            H2 := False;
          end;
        finally
          Dm_LaunchMain.Tra_Ginkoia.Commit;
          Dm_LaunchMain.Dtb_Ginkoia.Close;
        end;

        Ajoute('Verif etat backup ', 0, True);
        if EtatBackup <> 5 then
        begin
          // temps du backup
          Ajoute('backup <>5 ', 0, True);

          if FileExists(IncludeTrailingBackslash(ExtractFileName(Application.exename)) + 'ginkoia.ini') then
            S := IncludeTrailingBackslash(ExtractFileName(Application.exename))
          else if FileExists('C:\Ginkoia\ginkoia.ini') then
            S := 'C:\Ginkoia\'
          else if FileExists('D:\Ginkoia\ginkoia.ini') then
            S := 'D:\Ginkoia\';
          S := S + 'BackRest.ini';
          ini := TIniFile.Create(S);
          try
            I := ini.ReadInteger('TPS', 'TPS', 0);
          finally
            ini.Free;
          end;
          Ajoute('Calcule du temps ', 0, True);
          if I = 0 then
            I := 60 * 4
          else
          begin
            I := Trunc((I * 1.25) / 1000) div 60;
            if I < 60 then
              I := 60;
          end;
          if not (H1) and not (H2) then
          begin
            EtatBackup := 3; // à 23 Heures
          end
          else if H1 and not (H2) then
          begin
            decodeTime(HEURE1, Hh, Mm, Ss, Dd);
            h := Hh - 22;
            if h < 0 then
              h := h + 24;
            j := h * 60 + Mm;
            if j + I < 9 * 60 then
              EtatBackup := 1
            else
              EtatBackup := 3
          end
          else
          begin // H2 et H1
            decodeTime(HEURE2, Hh, Mm, Ss, Dd);
            h := Hh - 22;
            if h < 0 then
              h := h + 24;
            j := h * 60 + Mm;
            if j + I < 9 * 60 then
              EtatBackup := 2
            else
            begin
              decodeTime(HEURE1, Hh, Mm, Ss, Dd);
              h := Hh - 22;
              if h < 0 then
                h := h + 24;
              if h > 9 then
                EtatBackup := 3
              else
              begin
                k := h * 60 + Mm;
                if k + I < j then
                  EtatBackup := 1
                else if k - I > 0 then
                  EtatBackup := 4;
              end;
            end;
          end;
        end;
        Ajoute('Fin ', 0, True);

        // 1 après la 1° réplication
        // 2 après la 2° réplication
        // 3 à 23 H
        // 4 à 22 H
        // 5 à heure fixe
        case EtatBackup of
          -1:
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Backup désactivé', logInfo, True, 0, ltLocal);
          0:
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Backup inconnu', logWarning, True, 0, ltLocal);
          1:
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Backup après la réplication H1', logInfo, True, 0, ltLocal);
          2:
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Backup après la réplication H2', logInfo, True, 0, ltLocal);
          3:
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Backup à 23h', logInfo, True, 0, ltLocal);
          4:
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Backup à 22h', logInfo, True, 0, ltLocal);
          5:
            Log.Log('LaunchV7_Frm', 'InitialiseLaunch', 'Log', 'Backup à heure fixe : ' + FormatDateTime('hh:nn', HeureBackup), logInfo, True, 0, ltLocal);
        end;

        Info;
      finally
        Tim_LanceRepliTimer(NIL);
        // FC : 16/12/2008, Ajout du module réplic en journée
        if bReplicWebActif then
        begin
          SetTimerIntervalReplicWeb();
          Tim_ReplicWeb.Enabled := True; // Lance le timer
          Btn_ReplicWeb.visible := True;
          btReplicWeb.visible := True;
        end
        else
        begin
          Btn_ReplicWeb.visible := False;
          btReplicWeb.visible := False;
        end;
        // Fin Ajout FC : 16/12/2008, Ajout du module réplic en journée

        if bReplicTpsReelActif then
        begin
          SetTimerIntervalReplicTpsReel(False);
          if hNextReplicJourna > 0 then
            Ajoute('Prochaine réplication temps réél prévue : ' + DateTimeToStr(hNextReplicJourna), 1);

          Btn_ReplicTpsReel.visible := True;
        end
        else
        begin
          Btn_ReplicTpsReel.visible := False;
        end;

      end;
    except
      on E: Exception do
      begin
        Ajoute('InitialiseLaunch : ' + E.ClassName + ' - ' + E.Message, 0, True);
      end;
    end;

  finally
    taskReplication.Enabled := vReplicationActif;
    taskRecalc.Enabled := vReplicationActif;
    taskReplicationPF.Enabled := vReplicationPFActif;
    taskReplicationWeb.Enabled := vReplicationWebActif;
  end;

  Ajoute('Fin InitialiseLaunch');
  DoEventStatus;
end;

// ---------------------------------------------------------------
// Initialisation des connexions
// ---------------------------------------------------------------

// ---------------------------------------------------------------
// Procedure de call back (pour centraliser les requêtes)
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.NeedHorraire(Basid: Integer; Prin: Boolean; var LauId: Integer; var H1: string; var Valid1: Integer; var H2: string; var Valid2, Auto: Integer; var LaDate: string; var Back: Integer; var BackTime: string; var ForcerMaj: Boolean; var PRM_ID: Integer);
var
  Clef: Integer;
begin
  if Prin then
  begin
    // horraire de réplication
    Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'Ib_Horraire (avant).', logDebug, True, 0, ltLocal);
    Ib_Horraire.ParamByName('BASID').AsInteger := Basid;
    Ib_Horraire.Open;
    Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'Ib_Horraire (après).', logDebug, True, 0, ltLocal);

    if Ib_Horraire.IsEmpty then
    begin
      Clef := NouvelleClef;
      Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'insert GENLAUNCH (avant).', logDebug, True, 0, ltLocal);

      IB_Divers.SQL.Clear;
      IB_Divers.SQL.Add('Insert Into GENLAUNCH');
      IB_Divers.SQL.Add(' (LAU_ID, LAU_BASID, LAU_H1, LAU_H2, LAU_AUTORUN,LAU_BACK) ');
      IB_Divers.SQL.Add(' VALUES (' + IntToStr(Clef) + ',' + IntToStr(Basid) + ',0,0,0,0)');
      IB_Divers.ExecSQL;

      Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'insert GENLAUNCH (après).', logDebug, True, 0, ltLocal);

      InsertK(Clef, CstTblLaunch);
      Commit;

      Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'Ib_Horraire (avant).', logDebug, True, 0, ltLocal);
      Ib_Horraire.Close;
      Ib_Horraire.ParamByName('BASID').AsInteger := Basid;
      Ib_Horraire.Open;
      Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'Ib_Horraire (après).', logDebug, True, 0, ltLocal);
    end;
    H1 := FormatDateTime('HH:NN', Ib_HorraireLAU_HEURE1.AsDateTime);
    Valid1 := Ib_HorraireLAU_H1.AsInteger;
    H2 := FormatDateTime('HH:NN', Ib_HorraireLAU_HEURE2.AsDateTime);
    Valid2 := Ib_HorraireLAU_H2.AsInteger;
    Auto := Ib_HorraireLAU_AUTORUN.AsInteger;
    LauId := Ib_HorraireLAU_ID.AsInteger;
    Back := Ib_HorraireLAU_BACK.AsInteger;
    BackTime := FormatDateTime('HH:NN', Ib_HorraireLAU_BACKTIME.AsDateTime);
    Ib_Horraire.Close;

    Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'IB_ForceMAJ (avant).', logDebug, True, 0, ltLocal);
    IB_ForceMAJ.ParamByName('BASID').AsInteger := Basid;
    IB_ForceMAJ.Open;
    Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'IB_ForceMAJ (après).', logDebug, True, 0, ltLocal);

    if IB_ForceMAJ.IsEmpty then
    begin
      Clef := NouvelleClef;
      InsertK(Clef, CstTblGENPARAM);
      Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'insert GENPARAM (avant).', logDebug, True, 0, ltLocal);

      IB_Divers.SQL.Clear;
      IB_Divers.SQL.Add('Insert Into GENPARAM');
      IB_Divers.SQL.Add(' (PRM_ID, PRM_CODE, PRM_INTEGER, PRM_FLOAT, PRM_STRING, PRM_TYPE, PRM_MAGID, PRM_INFO, PRM_POS) ');
      IB_Divers.SQL.Add(' VALUES (' + IntToStr(Clef) + ',666,' + IntToStr(Basid) + ',0,'''',1999,0,''Forcer la MAJ'',0)');
      IB_Divers.ExecSQL;

      Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'insert GENPARAM (après).', logDebug, True, 0, ltLocal);
      Commit;

      Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'IB_ForceMAJ (avant).', logDebug, True, 0, ltLocal);
      IB_ForceMAJ.Close;
      IB_ForceMAJ.Open;
      Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'IB_ForceMAJ (après).', logDebug, True, 0, ltLocal);
    end;
    ForcerMaj := IB_ForceMAJPRM_POS.AsInteger = 1;
    PRM_ID := IB_ForceMAJPRM_ID.AsInteger;
    IB_ForceMAJ.Close;
  end
  else
  begin
    // horraire prédéfinie
    ForcerMaj := False;
    PRM_ID := 0;
    Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'select GENCHANGELAUNCH (avant).', logDebug, True, 0, ltLocal);

    IB_Divers.SQL.Clear;
    IB_Divers.SQL.Add('SELECT CHA_HEURE1, CHA_H1, CHA_HEURE2, CHA_H2, CHA_AUTORUN, CHA_ACTIVER, CHA_BACK, CHA_BACKTIME');
    IB_Divers.SQL.Add('FROM GENCHANGELAUNCH JOIN K ON (K_ID=CHA_ID AND K_ENABLED=1)');
    IB_Divers.SQL.Add('WHERE CHA_ACTIVE=0');
    IB_Divers.SQL.Add('  AND CHA_LAUID=' + EnStr(LauId));
    IB_Divers.Open;

    Log.Log('LaunchV7_Frm', 'NeedHorraire', 'Log', 'select GENCHANGELAUNCH (après).', logDebug, True, 0, ltLocal);
    if IB_Divers.IsEmpty then
    begin
      H1 := '';
      Valid1 := 0;
      H2 := '';
      Valid2 := 0;
      Auto := 0;
      LaDate := '';
      Back := 0;
      BackTime := '';
    end
    else
    begin
      H1 := IB_Divers.Fields[0].AsString;
      Valid1 := IB_Divers.Fields[1].AsInteger;
      H2 := IB_Divers.Fields[2].AsString;
      Valid2 := IB_Divers.Fields[3].AsInteger;
      Auto := IB_Divers.Fields[4].AsInteger;
      LaDate := IB_Divers.Fields[5].AsString;
      BackTime := IB_Divers.Fields[7].AsString;
      Back := IB_Divers.Fields[6].AsInteger;
    end;
    IB_Divers.Close;
  end;
end;

// ------------------------------------------------------------------------------
procedure TFrm_LaunchV7.Nbt_PingTestClick(Sender: TObject);
var
  ia: Integer;
  vRepli: TLesreplication;
begin
  if not Assigned(PingList) then
  begin
    PingList := TPingList.Create;
    PingList.onPingResult := PingList_OnPingResult;
    PingList.onFinish := PingList_OnFinish;
  end;

  if (MapGinkoia.Backup or MapGinkoia.Verifencours or MapGinkoia.MajAuto or MapGinkoia.Launcher) then
    EXIT;

  Ajoute('* Test de connexion démarré.', 1, False);

  // Launch Delos

  if (ListeReplication.Count > 0) then
  begin
    vRepli := TLesreplication(ListeReplication[0]);
    if LanceDelosQPMAgent(vRepli.PlaceEai, vRepli.URLLocal + vRepli.Ping) then
    begin
      ArretDelos;
      Ajoute('- Test de connexion locale : Réussi.', 1, False);
    end
    else
    begin
      Ajoute('# Test de connexion locale : Echec.', 0, False);
    end;
  end;

  // Ajout des URL à Pinger

  for ia := 0 to ListeReplication.Count - 1 do
  begin
    vRepli := TLesreplication(ListeReplication[ia]);
    PingList.AddUrl(vRepli.URLDISTANT + vRepli.Ping);
  end;

  for ia := 0 to ListeReplicWeb.Count - 1 do
  begin
    vRepli := TLesreplication(ListeReplicWeb[ia]);
    PingList.AddUrl(vRepli.URLDISTANT + vRepli.Ping);
  end;

  Nbt_PingTest.Enabled := False;
  PingList.Start;
end;

// ------------------------------------------------------------------------------
procedure TFrm_LaunchV7.PingList_OnPingResult(Sender: TObject; AUrl: string; resultCode: Integer; resultMsg: string; resultTime: Integer);
begin
  showHideLog(True);
  if (resultCode = 0) then
    Ajoute('- Test de connexion à [' + AUrl + '] : Réussi en ' + IntToStr(resultTime) + 'ms.', 0, False)
  else
    Ajoute('# Test de connexion à [' + AUrl + '] : (' + IntToStr(resultCode) + ')' + resultMsg + '.', 0, False);
end;

// ------------------------------------------------------------------------------
procedure TFrm_LaunchV7.PingList_OnFinish(Sender: TObject);
begin
  showHideLog(True);
  Ajoute('- Test de connexion terminé.', 0, False);

  Nbt_PingTest.Enabled := True;
end;

// ------------------------------------------------------------------------------
procedure TFrm_LaunchV7.Nbt_ReduireClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_LaunchV7.NeedConnexion(LauId: Integer; Conn: TUneConnexion);
begin
  Log.Log('LaunchV7_Frm', 'NeedConnexion', 'Log', 'IB_Connexion (avant).', logDebug, True, 0, ltLocal);

  //
  IB_Connexion.Close;
  IB_Connexion.ParamByName('LAUID').AsInteger := LauId;
  IB_Connexion.Open;

  Log.Log('LaunchV7_Frm', 'NeedConnexion', 'Log', 'IB_Connexion (après).', logDebug, True, 0, ltLocal);

  while not IB_Connexion.Eof do
  begin
    Conn(IB_ConnexionCON_NOM.AsString, IB_ConnexionCON_TEL.AsString, IB_ConnexionCON_TYPE.AsInteger, IB_ConnexionCON_ORDRE.AsInteger, IB_ConnexionCON_ID.AsInteger);
    IB_Connexion.Next;
  end;
  IB_Connexion.Close;
end;

procedure TFrm_LaunchV7.NeedReplication(LauId: Integer; repli: TUneReplication);
begin
  Log.Log('LaunchV7_Frm', 'NeedReplication', 'Log', 'Ib_Replication (avant).', logDebug, True, 0, ltLocal);

  Ib_Replication.Close;
  Ib_Replication.ParamByName('LAUID').AsInteger := LauId;
  Ib_Replication.Open;

  Log.Log('LaunchV7_Frm', 'NeedReplication', 'Log', 'Ib_Replication (après).', logDebug, True, 0, ltLocal);

  while not Ib_Replication.Eof do
  begin
    repli(Ib_ReplicationREP_ID.AsInteger, Ib_ReplicationREP_PING.AsString, Ib_ReplicationREP_PUSH.AsString, Ib_ReplicationREP_PULL.AsString, Ib_ReplicationREP_USER.AsString, Ib_ReplicationREP_PWD.AsString, Ib_ReplicationREP_URLLOCAL.AsString, Ib_ReplicationREP_URLDISTANT.AsString, Ib_ReplicationREP_PLACEEAI.AsString, Ib_ReplicationREP_PLACEBASE.AsString, Ib_ReplicationREP_ORDRE.AsInteger);
    Ib_Replication.Next;
  end;
  Ib_Replication.Close;
end;

// ---------------------------------------------------------------
// Initialisation des connexions Principale
// ---------------------------------------------------------------

function TFrm_LaunchV7.GetJeton(AMaxEssai, ADelaiEssai: Integer; AAdresse, ADatabaseWS, ASenderWs: string; AHttpRio: THTTPRIO): string;
var
  iNbEssai: Integer;
begin
  iNbEssai := 0;
  repeat // Récupération du jeton
    Inc(iNbEssai);
    Ajoute('Un magasin est déjà en train de répliquer, veuillez patienter', 0);
    Ajoute('Tentative de récupération du Jeton sur :  ' + AAdresse, 0, True);
    try
      Result := GetIJetonLaunch(AAdresse, AHttpRio).GetToken(ADatabaseWS, ASenderWs);
    except
      Result := 'ERR-HTTP';
    end;

    Ajoute('Résultat : ' + Result, 0, True);
    // Gestion des erreurs possibles
    if Result <> 'OK' then
    begin
      if Result = 'ERR-OQP' then
      begin
        Ajoute('Jeton : Occupé', 0);
      end
      else if Result = 'ERR-PRM' then
      begin
        Ajoute('Jeton : Erreur de paramétrage', 0);
        Ajoute(' - Adresse : ' + AAdresse, 0);
        Ajoute(' - DatabaseWS : ' + ADatabaseWS, 0);
        Ajoute(' - Sender : ' + ASenderWs, 0);
      end
      else if Result = 'ERR-CNX' then
      begin
        Ajoute('Jeton : Erreur de connexion à la base', 0);
      end
      else if Result = 'ERR-HTTP' then
      begin
        Ajoute('Jeton : Erreur de connexion au serveur distant', 0);
      end
      else
      begin
        Ajoute('Jeton : Erreur inconnue - ' + Result, 0);
      end;

      // Tempo
      Ajoute('Temporisation...' + IntToStr((ADelaiEssai div 1000)) + 's', 0);
      if iNbEssai < iNbEssaiMax then
        LeDelay(ADelaiEssai);
    end;
  until (Result = 'OK') or (iNbEssai >= AMaxEssai);
end;

function TFrm_LaunchV7.GetJetonPortable(ADelaiEssai: Integer; AAdresse, ADatabaseWS, ASenderWs: string; AHttpRio: THTTPRIO): string;
var
  WaitForFrm: Tfrm_WaitFor;
begin
  Result := '';
  Pan_AffRight.Enabled := False;
  try
    WaitForFrm := Tfrm_WaitFor.Create(Frm_LaunchV7);
    try
      WaitForFrm.Parent := Frm_LaunchV7;
      WaitForFrm.BringToFront;
      WaitForFrm.Top := (Frm_LaunchV7.Height div 2) - (WaitForFrm.Height div 2);
      WaitForFrm.Left := (Frm_LaunchV7.Width div 2) - (WaitForFrm.Width div 2);

      WaitForFrm.Show;
      repeat // Récupération du jeton
        Ajoute('Un magasin est déjà en train de répliquer, veuillez patienter', 0);
        Ajoute('Tentative de récupération du Jeton sur :  ' + AAdresse, 0, True);
        try
          Result := GetIJetonLaunch(AAdresse, AHttpRio).GetToken(ADatabaseWS, ASenderWs);
        except
          Result := 'ERR-HTTP';
        end;

        Ajoute('Résultat : ' + Result, 0, True);
        // Gestion des erreurs possibles
        if Result <> 'OK' then
        begin
          if Result = 'ERR-OQP' then
          begin
            Ajoute('Jeton : Occupé', 0);
          end
          else if Result = 'ERR-PRM' then
          begin
            raise Exception.Create(Format('Erreur de paramétrage '#13#10' - Adresse : %s'#13#10' - DatabaseWS : %s'#13#10' - Sender : %s', [AAdresse, ADatabaseWS, ASenderWs]));
          end
          else if Result = 'ERR-CNX' then
          begin
            raise Exception.Create('Jeton : Erreur de connexion à la base');
          end
          else if Result = 'ERR-HTTP' then
          begin
            raise Exception.Create('Jeton : Erreur de connexion au serveur distant');
          end
          else
          begin
            raise Exception.Create('Jeton : Erreur inconnue - ' + Result);
          end;

          // Tempo
          Ajoute('Temporisation...' + IntToStr((ADelaiEssai div 1000)) + 's', 0);
          if Result <> 'OK' then
            LeDelay(ADelaiEssai);
        end;
        Application.ProcessMessages;
      until (Result = 'OK') or (WaitForFrm.BtnState);
      if WaitForFrm.BtnState then
        Ajoute('Annulation demandée', 0);

    except
      on E: Exception do
      begin
        Ajoute('GetJetonPortable Erreur -> ' + E.Message, 0);
      end;
    end;
  finally
    Pan_AffRight.Enabled := True;
    WaitForFrm.Free;

  end;
end;

function TFrm_LaunchV7.GetLoop: Integer;
begin
  if Ed_Loop.Text <> '' then
  begin
    try
      Result := StrToInt(Ed_Loop.Text);
    except
      Result := 0;
    end;
  end
  else
  begin
    Result := 0;
  end;
end;

function TFrm_LaunchV7.GetParam(var IOInteger: Integer; var IOFloat: double; var IOString: string; AType, ACode, ABasID: Integer): Boolean;
begin
  Result := True;
  try
    Log.Log('LaunchV7_Frm', 'GetParam', 'Log', 'Que_GetParamReplicTpsReel (avant).', logDebug, True, 0, ltLocal);

    // Récupération d'un paramètre
    Que_GetParamReplicTpsReel.Close;
    Que_GetParamReplicTpsReel.ParamByName('TYPE').AsInteger := AType;
    Que_GetParamReplicTpsReel.ParamByName('CODE').AsInteger := ACode;
    Que_GetParamReplicTpsReel.ParamByName('BASID').AsInteger := ABasID;
    Que_GetParamReplicTpsReel.Open;

    Log.Log('LaunchV7_Frm', 'GetParam', 'Log', 'Que_GetParamReplicTpsReel (après).', logDebug, True, 0, ltLocal);

    IOInteger := Que_GetParamReplicTpsReel.FieldByName('PRM_INTEGER').AsInteger;
    IOFloat := Que_GetParamReplicTpsReel.FieldByName('PRM_FLOAT').AsFloat;
    IOString := Que_GetParamReplicTpsReel.FieldByName('PRM_STRING').AsString;
  except
    Result := False;
  end;
  Que_GetParamReplicTpsReel.Close;
end;

function TFrm_LaunchV7.GetParamFloat(AType, ACode, ABasID: Integer): double;
var
  AStr: string;
  AInt: Integer;
  AFloat: double;
begin
  Result := 0;
  if GetParam(AInt, AFloat, AStr, AType, ACode, ABasID) then
  begin
    Result := AFloat;
  end;
end;

function TFrm_LaunchV7.GetParamInteger(AType, ACode, ABasID: Integer): Integer;
var
  AStr: string;
  AInt: Integer;
  AFloat: double;
begin
  Result := 0;
  if GetParam(AInt, AFloat, AStr, AType, ACode, ABasID) then
  begin
    Result := AInt;
  end;
end;

function TFrm_LaunchV7.GetParamString(AType, ACode, ABasID: Integer): string;
var
  AStr: string;
  AInt: Integer;
  AFloat: double;
begin
  Result := '';
  if GetParam(AInt, AFloat, AStr, AType, ACode, ABasID) then
  begin
    Result := AStr;
  end;
end;

function TFrm_LaunchV7.GetTIdHttp(AuserName, APassWord: string; AConnectTimeOut: Integer): TIdHTTP;
begin
  Result := TIdHTTP.Create(Self);

  // Params par défaut
  with Result do
  begin
    AllowCookies := False;
    ProxyParams.BasicAuthentication := False;
    ProxyParams.ProxyPort := 0;
    Request.ContentLength := -1;
    Request.Accept := 'text/html, */*';
    Request.BasicAuthentication := False;
    Request.UserAgent := 'Mozilla/3.0 (compatible; Indy Library)';
    HTTPOptions := [hoKeepOrigProtocol, hoForceEncodeParams];
  end;

  with Result do
  begin
    Request.UserName := AuserName;
    Request.Password := APassWord;
    ConnectTimeout := AConnectTimeOut;
  end;

end;

function TFrm_LaunchV7.GetVersionBase: string;
begin
  Log.Log('LaunchV7_Frm', 'GetVersionBase', 'Log', 'select GENVERSION (avant).', logDebug, True, 0, ltLocal);

  with IBQue_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select VER_VERSION FROM GENVERSION');
    SQL.Add('Where VER_DATE IN (SELECT Max(VER_DATE) FROM GENVERSION)');
    ParamCheck := True;
    Open;

    Result := FieldByName('VER_VERSION').AsString;
  end;

  Log.Log('LaunchV7_Frm', 'GetVersionBase', 'Log', 'select GENVERSION (après).', logDebug, True, 0, ltLocal);
end;

function TFrm_LaunchV7.GetVersionBaseV: TVersion;
var
  vVersionStr: string;
  ia, ib: Integer;
begin
  FillChar(Result, SizeOf(Result), 0);
  vVersionStr := Trim(GetVersionBase);

  ia := 1;
  ib := Pos('.', vVersionStr);

  if (ib < 1) then
    EXIT;
  Result.Major := StrToIntDef(Copy(vVersionStr, ia, ib - ia), 0);
  ia := ib + 1;

  ib := PosEx('.', vVersionStr, ia + 1);
  if (ib < 1) then
    EXIT;
  Result.Minor := StrToIntDef(Copy(vVersionStr, ia, ib - ia), 0);
  ia := ib + 1;

  ib := PosEx('.', vVersionStr, ia + 1);
  if (ib < 1) then
    EXIT;
  Result.Revision := StrToIntDef(Copy(vVersionStr, ia, ib - ia), 0);
  ia := ib + 1;

  Result.Build := StrToIntDef(Copy(vVersionStr, ia, length(vVersionStr) - ia), 0);
end;

function TFrm_LaunchV7.GetVersionLame: string;
var
  Basid: Integer;
  sAdresseWS, sDatabaseWS, sAdresse: string;
begin
  Log.Log('LaunchV7_Frm', 'GetVersionLame', 'Log', 'select GENREPLICATION (avant).', logDebug, True, 0, ltLocal);

  with IBQue_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select REP_URLDISTANT');
    SQL.Add('  from GenReplication Join k On (K_id = REP_ID and K_ENABLED=1)');
    SQL.Add('  Join GenLaunch on REP_LAUID = LAU_ID');
    SQL.Add('  Join k on (K_ID = LAU_ID and K_Enabled=1)');
    SQL.Add('Where REP_ID>0');
    SQL.Add('  And LAU_BASID = :PBASID');
    SQL.Add('  And REP_ORDRE >= 0');
    SQL.Add('Order By REP_ORDRE');
    ParamCheck := True;
    ParamByName('PBASID').AsInteger := IdBase0;
    Open;

    sAdresseWS := GetParamString(11, 34, IdBase0);
    sDatabaseWS := GetParamString(11, 36, IdBase0);
    sAdresse := StringReplace(FieldByName('REP_URLDISTANT').AsString, '/DelosQPMAgent.dll', sAdresseWS, [rfReplaceAll, rfIgnoreCase]);

    Result := GetVersionThread(sAdresse, sDatabaseWS, RioJetonLaunch);
    // Result := GetIJetonLaunch(sAdresse, RioJetonLaunch).GetVersionBdd(sDatabaseWS);
  end;

  Log.Log('LaunchV7_Frm', 'GetVersionLame', 'Log', 'select GENREPLICATION (après).', logDebug, True, 0, ltLocal);
end;

function TFrm_LaunchV7.GetVersionReTry(AAdresse, ADatabaseWS, AVersionEnCours: string; var bVersionError: Boolean; ANbTry: Integer): Boolean;
var
  sResult: string; // Résultat de l'appel au WebService RecupVersion.
  bTestVersion: Boolean; // Résultat du test de version
  I: Integer; // Variable n° try en cours
  iWaitTime: Integer; // Temps d'attente
begin
  bTestVersion := False;
  bVersionError := False;
  sResult := '';
  try
    I := 0;
    // Repeat car on veut passer au moins une fois dans la boucle
    repeat
      // Récup version
      try
        Ajoute('Do GetVerion essai ' + IntToStr(I) + '/' + IntToStr(ANbTry), 0, True);
        sResult := GetVersionThread(AAdresse, ADatabaseWS, RioJetonLaunch);

        Ajoute('GetVersion : ' + sResult + ' / ' + AVersionEnCours, 0, True);
        if AVersionEnCours = sResult then
        begin
          bTestVersion := True;
        end
        else
        begin
          bTestVersion := False;
          Ajoute('Réplication impossible : Version du serveur réplicant différente de la version locale', 0);
        end;
      except
        on E: Exception do
        begin
          bTestVersion := False;
          Ajoute('Version : Erreur de connexion au serveur distant : ' + E.Message, 0);
        end;
      end;

      // Test effectué, incrémente i
      Inc(I);

      // Si test pas ok, et il reste des tests à faire, on temporise
      if ((not bTestVersion) and (I < ANbTry)) then
      begin
        // Attente en fonction du nombre d'essai
        iWaitTime := I * 10;
        Ajoute('Version : Temporisation avant essai suivant : ' + IntToStr(iWaitTime) + 's', 0);
        DoWait(iWaitTime * 1000);
      end;
    until ((I >= ANbTry) or (bTestVersion = True));

    if I >= ANbTry then
    begin
      Ajoute('Version : Erreur de connexion au serveur distant après ' + IntToStr(I) + ' essai(s)', 0);
      bVersionError := True;
    end;

  except
    on E: Exception do
    begin
      bTestVersion := False;
      bVersionError := True;
      Ajoute('Exception dans la boucle de récupération de version : ' + E.Message, 0);
    end;
  end;
  Result := bTestVersion;
end;

function TFrm_LaunchV7.GetVersionThread(AUrl, ADatabase: string; AHttpRio: THTTPRIO): string;
var
  I: Integer;
  VersionThread: TRioGetVersionThread;
begin
  Result := '';

  // Initialisation des paramètres de timeout (20s)
  AHttpRio.HTTPWebNode.ReceiveTimeout := 20000;
  AHttpRio.HTTPWebNode.SendTimeout := 20000;
  AHttpRio.HTTPWebNode.ConnectTimeout := 20000;

  VersionThread := TRioGetVersionThread.Create(AHttpRio, AUrl, ADatabase);
  try
    VersionThread.Start;

    I := 0;
    while (VersionThread.Resultat = '') do
    begin
      Inc(I);
      if I > 30 then
        raise ETIMEOUTRIO.Create('GetVersion : Délai d''attente expiré');
      DoWait(1000);
    end;

    if Pos('Erreur', VersionThread.Resultat) > 0 then
      raise Exception.Create(VersionThread.Resultat);

    Result := VersionThread.Resultat;

    VersionThread.Terminate;
    I := 0;
    while not VersionThread.EndOfThread do
    begin
      Inc(I);
      if I > 30 then
      begin
        TerminateThread(VersionThread.Handle, 1);
        EXIT;
      end;
      DoWait(1000);
    end;

  finally
    FreeAndNil(VersionThread);
  end;
end;

// ---------------------------------------------------------------
// Utilitaires
// ---------------------------------------------------------------

// ---------------------------------------------------------------
// Connexion au Modem
// ---------------------------------------------------------------

function TFrm_LaunchV7.ConnexionModem(Nom, Tel: string): Boolean;
var
  RasConn: HRasConn;
  TP: TRasDialParams;
  Pass: BOOL;
  err: DWord;
  Last: DWord;
  RasConStatus: TRasConnStatus;
  nb: DWord;
  Ok: Boolean;
  debut: TDateTime;
begin
  debut := Now;
  FillChar(TP, SizeOf(TP), #00);
  TP.Size := SizeOf(TP);
  StrPCopy(TP.pEntryName, Nom);
  err := RasGetEntryDialParams(NIL, TP, Pass);
  Ok := False;
  if err = 0 then
  begin
    StrPCopy(TP.pPhoneNumber, Tel);
    RasConn := 0;

    err := rasdial(NIL, NIL, @TP, $FFFFFFFF, Handle, RasConn);
    if err <> 0 then
    begin
      Result := False;
      EXIT;
    end;
    Application.ProcessMessages;
    Last := $FFFFFFFF;
    nb := GetTickCount + 600000; // 10 min
    repeat
      Application.ProcessMessages;
      RasConStatus.Size := SizeOf(RasConStatus);
      RasGetConnectStatus(RasConn, @RasConStatus);
      if Last <> RasConStatus.RasConnState then
      begin
        case RasConStatus.RasConnState of
          RASCS_Connected:
            Ok := True;
          RASCS_Disconnected:
            Ok := True;
        end;
        Last := RasConStatus.RasConnState;
      end;
      LeDelay(1000);
    until Ok or (GetTickCount > nb); // max 10 min
  end;
  Result := Ok;
  // IF Result THEN
  // Event(LaBase0, CstConnexionModem, True, Now - debut);
end;

// ---------------------------------------------------------------
// Deconnexion au Modem
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.DeconnexionModem;
var
  RasCom: array[1..100] of TRasConn;
  I, Connections: DWord;
  Ok: Boolean;
  RasConStatus: TRasConnStatus;
  debut: TDateTime;
begin
  debut := Now;
  repeat
    I := SizeOf(RasCom);
    RasCom[1].Size := SizeOf(TRasConn);
    RasEnumConnections(@RasCom, I, Connections);
    for I := 1 to Connections do
      RasHangUp(RasCom[I].RasConn);
    // Test si c'est bien deconnecté
    I := SizeOf(RasCom);
    RasCom[1].Size := SizeOf(TRasConn);
    RasEnumConnections(@RasCom, I, Connections);
    Ok := True;
    for I := 1 to Connections do
    begin
      Application.ProcessMessages;
      RasConStatus.Size := SizeOf(RasConStatus);
      RasGetConnectStatus(RasCom[I].RasConn, @RasConStatus);
      case RasConStatus.RasConnState of
        RASCS_Connected:
          Ok := False;
      end;
    end;
    if not Ok then
      LeDelay(5000);
  until Ok;
  // Event(LaBase0, CstDeConnexionModem, True, Now - debut);
end;

// ---------------------------------------------------------------
// Saisie du mot de passe
// ---------------------------------------------------------------

function TFrm_LaunchV7.MotDePasse(aPassName: String): Boolean;
// {$IFDEF DEBUG }
// {$ELSE }
var
  Frm_MotDePasse: TFrm_MotDePasse;
  Password: string;
  retourPassword: TPasswordValidation;
  // {$ENDIF }
begin
  Result := False;
  // {$IFDEF DEBUG }
  // Result := true;
  // {$ELSE }

  if aPassName = 'NoNeedPassword' then
  begin
    Result := True;
    Exit;
  end;

  Application.CreateForm(TFrm_MotDePasse, Frm_MotDePasse);
  try
    Frm_MotDePasse.Execute('Saisie du mot de passe', Password, True);

    //PasswordManager.PasswordName := 'PassGeneral';
    PasswordManager.PasswordName := aPassName;
    retourPassword := PasswordManager.ComparePassword(Password);

    // si le ini ou l'entrée n'existe pas, on test le pass par défaut
    if (RetourPassword = fileNotExist) or (retourPassword = PasswordNotExist) then
    begin
      if Password = CstPassword then
        Result := True;
    end
    else if RetourPassword = PassOk then
      Result := True;

  finally
    Frm_MotDePasse.release;
  end;
  // {$ENDIF }
end;

// ---------------------------------------------------------------
// Lancement du ping en boucle
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.InitPing(Url: string; Temps: DWord);
begin
  Ping := Tping.Create(Url, Temps);
end;

procedure TFrm_LaunchV7.InitTokenEnBoucle(Url, NomClient, Sender: string; Temps: DWord; ARio: THTTPRIO);
begin
  TokenEnBoucle := TToken.Create(Url, NomClient, Sender, Temps, ARio, False);
end;

procedure TFrm_LaunchV7.InitTokenEnBouclePF(Url, NomClient, Sender: string; Temps: DWord; ARio: THTTPRIO);
begin
  TokenEnBouclePF := TToken.Create(Url, NomClient, Sender, Temps, ARio, False);
end;

// ---------------------------------------------------------------
// Arret du ping
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.StopPing;
begin
  if Ping <> NIL then
  begin
    Ping.Terminate;
    Ping := NIL;
  end;
end;

procedure TFrm_LaunchV7.StopTokenEnBoucle;
var
  iCount: Integer;
begin
  Ajoute('Libération Jeton', 0);
  try
    TokenEnBoucle.StopToken;
    Ajoute('JetonEnBoucle stoppé', 0, True);
  except
    on E: Exception do
      Ajoute('Exception TFrm_LaunchV7.StopTokenEnBoucle : ' + E.Message, 0, True);
  end;

  if TokenEnBoucle <> NIL then
  begin
    Ajoute('Libération JetonEnBoucle', 0, True);
    try
      Ajoute('Libération JetonEnBoucle avant terminate', 0, True);
      TokenEnBoucle.Terminate;
      Ajoute('Libération JetonEnBoucle après terminate', 0, True);
      iCount := 0;
      while not TokenEnBoucle.EndOfThread do
      begin
        Inc(iCount);
        if iCount >= 30 then
        begin
          if TerminateThread(TokenEnBoucle.Handle, 1) then
            raise Exception.Create('End delai dépassé')
          else
            raise Exception.Create('End delai dépassé echec coupure du thread');
        end;
        DoWait(1000);
      end;
    except
      on E: Exception do
        Ajoute('Exception Terminate Jeton ' + E.Message, 0, True);
    end;
    try
      Ajoute('Libération JetonEnBoucle avant Free', 0, True);
      FreeAndNil(TokenEnBoucle);
      Ajoute('Libération JetonEnBoucle après Free', 0, True);

    except
      on E: Exception do
        Ajoute('Exception free Jeton ' + E.Message, 0, True);
    end;
  end;

  Ajoute('Après Libération Jeton', 0, True);
end;

procedure TFrm_LaunchV7.StopTokenEnBouclePF;
begin
  Ajoute('Libération Jeton PF', 0);
  try
    TokenEnBouclePF.StopToken;
    Ajoute('JetonEnBouclePF stoppé', 0, True);
  except
    on E: Exception do
      Ajoute('Exception TFrm_LaunchV7.StopTokenEnBouclePF : ' + E.Message, 0, True);
  end;

  if TokenEnBouclePF <> NIL then
  begin
    Ajoute('Libération JetonEnBoucle PF', 0, True);
    try
      TokenEnBouclePF.Terminate;
    except
      on E: Exception do
        Ajoute('Exception Terminate Jeton PF ' + E.Message, 0, True);
    end;
    try
      FreeAndNil(TokenEnBouclePF); // := NIL;
    except
      on E: Exception do
        Ajoute('Exception free Jeton PF ' + E.Message, 0, True);
    end;
  end;
  Ajoute('Après Libération Jeton PF', 0, True);
end;

// ---------------------------------------------------------------
// Insertion du K dans une table
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.InsertK(Clef, Table: Integer);
begin
  Log.Log('LaunchV7_Frm', 'InsertK', 'Log', 'insert K (avant).', logDebug, True, 0, ltLocal);

  IB_Divers.SQL.Clear;
  IB_Divers.SQL.Add('Insert Into K');
  IB_Divers.SQL.Add(' (K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,KSE_DELETE_ID,K_DELETED,KSE_UPDATE_ID,K_UPDATED,KSE_LOCK_ID,KMA_LOCK_ID)');
  IB_Divers.SQL.Add(' VALUES ');
  IB_Divers.SQL.Add(' (' + IntToStr(Clef) + ',-101,' + IntToStr(Table) + ',' + IntToStr(Clef) + ',1,-1,-1,Current_Date,0,''01/01/1980'',-1,Current_Date,0,0)');
  IB_Divers.ExecSQL;

  Log.Log('LaunchV7_Frm', 'InsertK', 'Log', 'insert K (après).', logDebug, True, 0, ltLocal);
  IB_Divers.SQL.Clear;
end;

function TFrm_LaunchV7.IsModuleActif(AModuleNom: string): Boolean;
begin
  Log.Log('LaunchV7_Frm', 'IsModuleActif', 'Log', 'select UILGRPGINKOIAMAG (avant).', logDebug, True, 0, ltLocal);

  with IBQue_Tmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select count(*) as Resultat From uilgrpginkoiamag');
    SQL.Add('  Join k on (k_id=UGM_ID and K_enabled=1)');
    SQL.Add('  join uilgrpginkoia Join k on (k_id=UGG_ID and K_enabled=1)');
    SQL.Add('  on (UGG_ID = UGM_UGGID)');
    SQL.Add('where UGG_ID<>0');
    SQL.Add('And UGG_NOM = :NOM');
    ParamCheck := True;
    ParamByName('NOM').AsString := AModuleNom;
    Open;

    Result := FieldByName('Resultat').AsInteger > 0;
  end;

  Log.Log('LaunchV7_Frm', 'IsModuleActif', 'Log', 'select UILGRPGINKOIAMAG (après).', logDebug, True, 0, ltLocal);
end;

// Vérifie si c'est le magasin Web
function TFrm_LaunchV7.IsMagasinWeb(): Boolean;
begin
  Log.Log('LaunchV7_Frm', 'IsMagasinWeb', 'Log', 'select GENPARAM (avant).', logDebug, True, 0, ltLocal);

  with IBQue_Tmp do
  begin
    Close();
    SQL.Clear();
    SQL.Add('SELECT COUNT(*) AS RESULTAT');
    SQL.Add('FROM   GENPARAM');
    SQL.Add('  JOIN  GENBASES ON (CAST(PRM_INTEGER AS VARCHAR(32)) = BAS_IDENT AND PRM_MAGID = BAS_MAGID)');
    SQL.Add('WHERE  PRM_TYPE    = :TYPE');
    SQL.Add('AND    PRM_CODE    = :CODE');
    SQL.Add('AND    BAS_ID      = :BASE');
    ParamCheck := True;
    ParamByName('TYPE').AsInteger := 9;
    ParamByName('CODE').AsInteger := 203;
    ParamByName('BASE').AsInteger := IdBase0;
    Open();

    Result := (FieldByName('RESULTAT').AsInteger > 0);

    Close();
  end;

  Log.Log('LaunchV7_Frm', 'IsMagasinWeb', 'Log', 'select GENPARAM (après).', logDebug, True, 0, ltLocal);
end;

function TFrm_LaunchV7.GetYellisVersion: string;
var
  lst: TStringList;
  iTentative: Integer;
begin
  try
    if not IB_LaBase.Active then
    begin
      Log.Log('LaunchV7_Frm', 'GetYellisVersion', 'Log', 'IB_LaBase (avant).', logDebug, True, 0, ltLocal);
      IB_LaBase.Open;
      Log.Log('LaunchV7_Frm', 'GetYellisVersion', 'Log', 'IB_LaBase (après).', logDebug, True, 0, ltLocal);
    end;

    YellisConnexion.Base := 'ginkoia_db1';
    Result := '';
    iTentative := 1;
    while Trim(Result) = '' do
    begin
      Result := YellisConnexion.GetVersion(IB_LaBase.FieldByName('BAS_GUID').AsString);
      Sleep(200);
      Inc(iTentative);
      if (iTentative > 3) and (Trim(Result) = '') then
        raise Exception.Create('Trop de tentative de récupération des données de yellis');
    end;
  except
    on E: Exception do
      raise Exception.Create('GetYellisVersion -> ' + E.Message);
  end;
end;

function TFrm_LaunchV7.GFixBase(ABase: string): Boolean;
var
  sCommande, sParam: string;
  ibServerProperties: TIBServerProperties;
begin
  ibServerProperties := TIBServerProperties.Create(Self);
  try
    try
      ibServerProperties.Active := False;
      ibServerProperties.Protocol := local;
      ibServerProperties.Options := [];
      ibServerProperties.Params.Add('user_name=sysdba');
      ibServerProperties.Params.Add('password=masterkey');
      ibServerProperties.LoginPrompt := False;
      ibServerProperties.Active := True;
      ibServerProperties.FetchVersionInfo;
      ibServerProperties.FetchConfigParams;

      sCommande := SpecialFolder(CSIDL_SYSTEM) + '\cmd.exe';
      sParam := Format(' /C "%sGFix.exe" %s -validate -user sysdba -password masterkey', [IncludeTrailingPathDelimiter(ibServerProperties.ConfigParams.BaseLocation), ABase]);

      ExecuteAndWait(sCommande, sParam);
    except
      on E: Exception do
        raise Exception.Create('GFixBase -> ' + E.Message);
    end;
  finally
    FreeAndNil(ibServerProperties);
  end;

end;

// ---------------------------------------------------------------
// Modification du K
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.ModifK(Clef: Integer);
begin
  Log.Log('LaunchV7_Frm', 'ModifK', 'Log', 'execute procedure PR_UPDATEK (avant).', logDebug, True, 0, ltLocal);

  IB_Divers.SQL.Clear;
  IB_Divers.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + IntToStr(Clef) + ', 0)');
  IB_Divers.ExecSQL;

  Log.Log('LaunchV7_Frm', 'ModifK', 'Log', 'execute procedure PR_UPDATEK (après).', logDebug, True, 0, ltLocal);
  IB_Divers.SQL.Clear;
end;

// ---------------------------------------------------------------
// suppression du K
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.DeleteK(Clef: Integer);
begin
  Log.Log('LaunchV7_Frm', 'DeleteK', 'Log', 'execute procedure PR_UPDATEK (avant).', logDebug, True, 0, ltLocal);

  IB_Divers.SQL.Clear;
  IB_Divers.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(' + IntToStr(Clef) + ', 1)');
  IB_Divers.ExecSQL;

  Log.Log('LaunchV7_Frm', 'DeleteK', 'Log', 'execute procedure PR_UPDATEK (après).', logDebug, True, 0, ltLocal);
  IB_Divers.SQL.Clear;
end;

// ---------------------------------------------------------------
// Récupération d'un nouvel ID
// ---------------------------------------------------------------

function TFrm_LaunchV7.NouvelleClef: Integer;
begin
  Sp_NewKey.Prepare;
  Sp_NewKey.ExecProc;
  Result := Sp_NewKey.ParamByName('NEWKEY').AsInteger;
  Sp_NewKey.UnPrepare;
  Sp_NewKey.Close;
end;

// ---------------------------------------------------------------
// Lancement du Commit
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.Commit;
begin
  if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
    Dm_LaunchMain.Tra_Ginkoia.Commit;

  Dm_LaunchMain.Tra_Ginkoia.StartTransaction;
end;


// ---------------------------------------------------------------
// Lance SM_AVANT_REPLI
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.Exec_AvantRepli(Base: string);
begin
  Dm_LaunchMain.Dtb_Ginkoia.Close;
  Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := Base;
  try
    try
      Dm_LaunchMain.Dtb_Ginkoia.Open;
    except
      Ajoute('Problème connexion à la base Deconnexion triggers ', 0, True);
      raise;
    end;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;
    Log.Log('LaunchV7_Frm', 'Exec_AvantRepli', 'Log', 'execute procedure SM_AVANT_REPLI (avant).', logDebug, True, 0, ltLocal);

    IB_Divers.SQL.Clear;
    IB_Divers.SQL.Add('execute procedure SM_AVANT_REPLI;');
    IB_Divers.ExecSQL;

    Log.Log('LaunchV7_Frm', 'Exec_AvantRepli', 'Log', 'execute procedure SM_AVANT_REPLI (après).', logDebug, True, 0, ltLocal);
    Dm_LaunchMain.Tra_Ginkoia.Commit;
  except
    Dm_LaunchMain.Tra_Ginkoia.Rollback;
    Ajoute('Erreur lors de la déxonnexion triggers ', 0, True);
  end;
  Dm_LaunchMain.Dtb_Ginkoia.Close;

end;

// ---------------------------------------------------------------
// Ajout d'une chaine dans le memo
// ---------------------------------------------------------------
procedure TFrm_LaunchV7.doLog(aMsg: string; aLevel: TLogLevel);
begin
  if (aLevel >= logInfo) or (ModeDebug) then
  begin
    Mem_Result.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' - ' + aMsg);
    Mem_Affiche.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' - ' + aMsg);
    Application.ProcessMessages;
  end;

  Log.Log('Main', FBasGuid, 'Log', aMsg, aLevel, True, 0, ltLocal);
end;

procedure TFrm_LaunchV7.Ajoute(S: string; Vider: Integer = 0; AOnlyIfDebug: Boolean = False);
var
  aLevel: TLogLevel;
begin
  if (Vider = 1) and (not ModeDebug) then
  begin
    Mem_Affiche.Lines.Clear;
  end;

  if (not AOnlyIfDebug) or (ModeDebug) then
  begin
    Mem_Result.Lines.Add(S);
    Mem_Affiche.Lines.Add(S);
    Application.ProcessMessages;
  end;

  if AOnlyIfDebug then
    aLevel := logDebug
  else
    aLevel := logNotice;

  Log.Log('Main', FBasGuid, 'Log', S, aLevel, True, 0, ltLocal);

  Application.ProcessMessages;
end;

// ---------------------------------------------------------------
// Ajout d'une chaine sur la dernbiere ligne du memo
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.AjouteTC(S: string; Vider: Integer);
begin
  if (Vider = 1) then
    Mem_Result.Lines.Clear;
  if Mem_Result.Lines.Count > 0 then
    Mem_Result.Lines[Mem_Result.Lines.Count - 1] := Mem_Result.Lines[Mem_Result.Lines.Count - 1] + S
  else
    Mem_Result.Lines.Add(S);
  Mem_Result.Update;

  Log.Log('Main', FBasGuid, 'Log', S, logInfo, True, 0, ltLocal);
end;

// ---------------------------------------------------------------
// RAZ ecran, info de la derniere repliaction ok
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.Info;
var // R_date, R_heure: STRING;
  connection, PasHisto: Boolean;
  S: string;
  TpListe: TStringList;
  Basid: Integer;
begin
  try
    // delay
    // raz de l'affichage
    // noter la dernier replication valide...
    LeDelay(5);
    connection := False;
    // PasHisto   := True;

    if LaBase0 <> '' then
    begin
      with Dm_LaunchEvent do
      begin
        try
          connection := Data_Evt.Connected;
          if not connection then
          begin
            Data_Evt.DatabaseName := LaBase0;
            Data_Evt.Open;
            // tran_evt.active       := True;
            IBStProc_BaseID.Prepare;
            IBStProc_BaseID.ExecProc;
            Basid := IBStProc_BaseID.ParamByName('BAS_ID').AsInteger;
            IBStProc_BaseID.UnPrepare;
            IBStProc_BaseID.Close;
          end;

          // IBQue_Last_Repli.ParambyName('BASID').asInteger := BasID;
          // IBQue_Last_Repli.ParamByName('BASID').AsInteger  := IdBase0;
          // IBQue_Last_Repli.ParamByName('REPLIC').AsInteger := 0;
          // IBQue_Last_Repli.Open;
          // IF NOT IBQue_Last_Repli.IsEmpty THEN
          // BEGIN
          // PasHisto := False;
          // Ajoute('La dernière réplication réussie a été faite le "' + IBQue_Last_Repli.FieldByName('L_Date').AsString + '" à ' +
          // IBQue_Last_Repli.FieldByName('L_Heure').AsString, 1);
          // signaler une erreur de recalcul
          if not boolRecalculOk then
          begin
            showHideLog(True);
            Ajoute('Erreur lors du recalcul des triggers.' + #13#10 + 'Veuillez contacter GINKOIA.', 0);
          end;
          // END;
        finally
          // IBQue_Last_Repli.Close;
          if not connection then
          begin
            tran_evt.Active := False;
            Data_Evt.Close;
            // Dm_LaunchEvent.CloseOpenConnexion();
          end;
        end;
      end;
    end;
  except
    on E: Exception do
      Ajoute('PR INFO : ' + E.Message, 0);
  end;
  // info de la dernière réplication réussi
  if isPortableSynchro then
  begin
    S := extractFilePath(ParamStr(0));
    if S[length(S)] <> '\' then
      S := S + '\';
    S := S + 'Synchro.ok';
    if FileExists(S) then
    begin
      TpListe := TStringList.Create;
      try
        TpListe.LoadFromFile(S);
        if TpListe.Count > 0 then
        begin
          S := TpListe[0];
          Ajoute(S, 0);
        end;
      except
      end;
      FreeAndNil(TpListe);
    end;
  end;

  // IF PasHisto THEN
  // Ajoute('Historique de réplication inexistant...', 1);

  if ((MessMAJ1 <> '') or (MessMAJ2 <> '')) then
  begin
    Ajoute('', 0);
    Ajoute('*********************************************************************', 0);
    Ajoute(MessMAJ1, 0);
    Ajoute(MessMAJ2, 0);
    Ajoute('*********************************************************************', 0);
  end;
end;

// ---------------------------------------------------------------
// Gestion du changement d'horraire
// ---------------------------------------------------------------

function TFrm_LaunchV7.VerifChangeHorraire: Boolean;
var
  DataOpen: Boolean;
begin
  Ajoute('Vérif changement d''horaire', 0, True);
  Result := False;
  DataOpen := Dm_LaunchMain.Dtb_Ginkoia.Connected;
  try
    try
      if not DataOpen then
      begin
        Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := LaBase0;
        try
          Dm_LaunchMain.Dtb_Ginkoia.Open;
        except
          Ajoute('Problème connexion à la base VerifChgHorraire ', 0, True);
          raise;
        end;
        Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

        Log.Log('LaunchV7_Frm', 'VerifChangeHorraire', 'Log', 'IB_LaBase (avant).', logDebug, True, 0, ltLocal);
        IB_LaBase.Open;
        Log.Log('LaunchV7_Frm', 'VerifChangeHorraire', 'Log', 'IB_LaBase (après).', logDebug, True, 0, ltLocal);

        IdBase0 := IB_LaBaseBAS_ID.AsInteger;
        IB_LaBase.Close;

        // Récupération des horraires
        Log.Log('LaunchV7_Frm', 'VerifChangeHorraire', 'Log', 'Ib_Horraire (avant).', logDebug, True, 0, ltLocal);
        Ib_Horraire.ParamByName('BasId').AsInteger := IdBase0;
        Ib_Horraire.Open;
        Log.Log('LaunchV7_Frm', 'VerifChangeHorraire', 'Log', 'Ib_Horraire (après).', logDebug, True, 0, ltLocal);

        LauId := Ib_HorraireLAU_ID.AsInteger;
        Ib_Horraire.Close;
      end;

      Log.Log('LaunchV7_Frm', 'VerifChangeHorraire', 'Log', 'IB_ChgLaunch (avant).', logDebug, True, 0, ltLocal);
      IB_ChgLaunch.ParamByName('LAUID').AsInteger := LauId;
      IB_ChgLaunch.Open;
      Log.Log('LaunchV7_Frm', 'VerifChangeHorraire', 'Log', 'IB_ChgLaunch (après).', logDebug, True, 0, ltLocal);
      try
        if not (IB_ChgLaunch.IsEmpty) then
        begin
          if IB_ChgLaunchCHA_ACTIVER.AsDateTime < Now then
          begin
            Ajoute(DateTimeToStr(Now) + '   ' + 'Changement des horaires de réplication', 0);
            // Activer le changement
            ModifK(LauId);
            Log.Log('LaunchV7_Frm', 'VerifChangeHorraire', 'Log', 'update GENLAUNCH (avant).', logDebug, True, 0, ltLocal);

            IB_Divers.SQL.Clear;
            IB_Divers.SQL.Add('UPDATE GENLAUNCH');
            if IB_ChgLaunchCHA_HEURE1.IsNull then
              IB_Divers.SQL.Add('   SET LAU_HEURE1 = NULL,')
            else
              IB_Divers.SQL.Add('   SET LAU_HEURE1 = ' + EnStr(IB_ChgLaunchCHA_HEURE1.AsString) + ',');
            IB_Divers.SQL.Add('       LAU_H1 = ' + EnStr(IB_ChgLaunchCHA_H1.AsInteger) + ',');
            if IB_ChgLaunchCHA_HEURE2.IsNull then
              IB_Divers.SQL.Add('       LAU_HEURE2 = NULL,')
            else
              IB_Divers.SQL.Add('       LAU_HEURE2 = ' + EnStr(IB_ChgLaunchCHA_HEURE2.AsString) + ',');
            IB_Divers.SQL.Add('       LAU_H2 = ' + EnStr(IB_ChgLaunchCHA_H2.AsInteger) + ',');

            if IB_ChgLaunchCHA_BACKTIME.IsNull then
              IB_Divers.SQL.Add('       LAU_BACKTIME = NULL,')
            else
              IB_Divers.SQL.Add('       LAU_BACKTIME = ' + EnStr(IB_ChgLaunchCHA_BACKTIME.AsString) + ',');

            IB_Divers.SQL.Add('       LAU_BACK = ' + EnStr(IB_ChgLaunchCHA_BACK.AsInteger) + ',');

            IB_Divers.SQL.Add('       LAU_AUTORUN = ' + EnStr(IB_ChgLaunchCHA_AUTORUN.AsInteger));
            IB_Divers.SQL.Add('WHERE LAU_ID = ' + EnStr(LauId));
            IB_Divers.ExecSQL;

            Log.Log('LaunchV7_Frm', 'VerifChangeHorraire', 'Log', 'update GENLAUNCH (après).', logDebug, True, 0, ltLocal);

            IB_Divers.SQL.Clear;
            IB_Divers.SQL.Add('UPDATE GENCHANGELAUNCH ');
            IB_Divers.SQL.Add('SET CHA_ACTIVE=1 ');
            IB_Divers.SQL.Add('WHERE CHA_ID = ' + EnStr(IB_ChgLaunchCHA_ID.AsInteger));
            Commit;
            Result := True;
            // Event(LaBase0, CstChangementhorraire, True, Null);
            //
          end;
        end;
      finally
        IB_ChgLaunch.Close;
      end;
    except
      on E: Exception do
        Ajoute('VerifChangHoraire : ' + E.Message, 0);
    end;
  finally
    if not DataOpen then
      Dm_LaunchMain.Dtb_Ginkoia.Close;
  end;
  Ajoute('Fin Vérif changement d''horraire', 0, True);
end;

procedure TFrm_LaunchV7.WMEndSession(var Message: TWMEndSession);
begin
  Message.Result := Integer(False);
  Log.Log('Main', FBasGuid, 'Log', 'Windows est en cours de redémarrage', logWarning, True, 0, ltLocal);

  FCanClose := True;
  Close;
end;

// ---------------------------------------------------------------
// Message de forcage de replication !
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.OnForceReplic(var Msg: TMessage);
begin
  // MessageDlg('Message recu -> replication !', mtInformation, [mbOK], 0);
  DoReplicAutoJournee(True);
end;

procedure TFrm_LaunchV7.OnForcePush(var Msg: TMessage);
begin
  if not LauncherIsDoingAction then
  begin
  // on prends quand même les jeton local pour informer les tools
    Try
      LocalBloqueReplic(LaBase0, 'ginkoia', 'ginkoia', -1, True);
      ReplicationAutomatique(True, False, 1, 0);
    Finally
      LocalDeBloqueReplic();
    end;
  end;
end;

procedure TFrm_LaunchV7.OnForcePull(var Msg: TMessage);
begin
  if not LauncherIsDoingAction then
    DoReplicAutoJournee(True, 2);
end;

procedure TFrm_LaunchV7.Tim_ForceReplicTimer(Sender: TObject);
var
  cloture: TclotGdTot;
begin
  // cloture des grands Totaux, une fois par jour, sur les caisses de secours seulement à partir de 8h45 pour ne pas interférer avec la synchro
   // si on est sur une caisse de secours, on vérifie qu'il est plus de 8h45, sinon on ne fait rien
  if not (IsCaisseSec) or ((IsCaisseSec) and (((HourOf(Now) >= 8) and (MinuteOf(Now) >= 45)) or (HourOf(Now) >= 9))) then
  begin
    if (DateLastCloture < Trunc(Now)) then
    begin
      Ajoute('Cloture des grands Totaux', 0, True);
      cloture := TclotGdTot.Create(FBasId, LaBase0);
      try
        try
          cloture.DoGrandTotauxClose;
        except
          on E: Exception do
          begin
            Ajoute('Erreur lors de la cloture des grands totaux : ' + E.Message, 0, True);
            Log.Log('Main', FBasGuid, 'Log', 'Erreur lors de la cloture des grands totaux : ' + E.Message, logError, True, 0, ltLocal);
          end;
        end;
      finally
        cloture.Free;
      end;

      DateLastCloture := Trunc(Now);
      Log.Log('Main', FBasGuid, 'Log', 'Cloture des grands totaux exécutée', logTrace, True, 0, ltLocal);

    end;
  end;

  // démarragelancement de piccobatch en automatique, une seule fois après le démarrage du launcher
  if not (hasLaunchPicco) then
    LaunchPiccoAuto();

  if FileExists(extractFilePath(ParamStr(0)) + PARAM_FORCE_REPLIC) then
  begin
    Sleep(100);
    DeleteFile(extractFilePath(ParamStr(0)) + PARAM_FORCE_REPLIC);
    // MessageDlg('Fichier trouver -> replication !', mtInformation, [mbOK], 0);
    DoReplicAutoJournee(True);
  end;
end;

// ---------------------------------------------------------------
// Boucle principale de gestion du launch
// ---------------------------------------------------------------

function TFrm_LaunchV7.LanceDelosQPMAgent(APlaceEAI, AURLPing: string): Boolean;
var
  TestExec: Integer;
begin
  Result := False;
  try
    Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement de QPMAgent ', 0);
    TestExec := Winexec(PAnsiChar(AnsiString(APlaceEAI + 'Delos_QpmAgent.exe')), 0);
    if TestExec > 31 then
    begin
      // Tempo pour laisser a delos le temps de se lancer
      LeDelay(1000);
      // 2° : tester si le ping local fonctionne
      if UnPing(AURLPing) then
      begin
        Result := True;
        Ajoute(DateTimeToStr(Now) + '   ' + 'PING Local OK ', 0);
      end
      else
      begin
        Ajoute(DateTimeToStr(Now) + '   ' + 'Echec de lancement de QPMAgent', 0);
        ArretDelos;
      end;
    end
    else if TestExec = ERROR_BAD_FORMAT then
    begin
      Ajoute(DateTimeToStr(Now) + '   ' + 'Fichier DelosQPMAgent.exe endommagé', 0);
    end
    else if TestExec = ERROR_FILE_NOT_FOUND then
    begin
      Ajoute(DateTimeToStr(Now) + '   ' + 'Fichier DelosQPMAgent.exe introuvable', 0);
    end
    else if TestExec = ERROR_PATH_NOT_FOUND then
    begin
      Ajoute(DateTimeToStr(Now) + '   ' + 'Chemin DelosQPMAgent.exe inconnu', 0);
    end
    else
    begin
      Ajoute(DateTimeToStr(Now) + '   ' + 'Erreur DelosQPMAgent', 0);
    end;
  except
    Ajoute(DateTimeToStr(Now) + '   ' + 'Echec de lancement de QPMAgent', 0);
    ArretDelos;
  end;
end;

function TFrm_LaunchV7.LancementBackup: Boolean;
var
  I: Integer;
  vSynchroCaisse: TSynchroCaisse;
begin
  FileRestart.setBackupRestore(False);

  // AJ 12/05/2017 Si le resynchroBase est en train de tourner, on attend jusqu'à 12x 5min avant de lancer le backup, ou que le resynchroBase ait terminé
  I := 1;
  while ((processExists('gtResynchroBase.exe')) and (I <= 12)) do
  begin
    LeDelay(300000);
    Ajoute('Attente de la fin du ResynchroBase, essai n°' + IntToStr(I));
    I := I + 1;
  end;
  I := 0;

  /// quand on est un portable on ne fait pas de backup
  if isPortableSynchro then
  begin
    Result := True;
    EXIT;
  end;

  vSynchroCaisse := getSynchroCaisse;
  if vSynchroCaisse.Enabled then
  begin
    Result := True;
    Exit;
  end;

  if (MapGinkoia.Verifencours or MapGinkoia.MajAuto) then
  begin
    Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de Lancement du Backup MAJ en cours !', 0);
    Result := False;
    EXIT;
  end;
  if EtatBackup <> 5 then
  begin
    if (Time < EncodeTime(18, 0, 0, 0)) and (Time > EncodeTime(8, 0, 0, 0)) then
    begin
      Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de Lancement du Backup ', 0);
      Result := False;
      EXIT;
    end;
  end;

  if FileExists(Path + 'BackRest.Exe') then
  begin
    Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement de Backup ', 0);
    // Event(LaBase0, CstLanceBackup, True, Null);
    try
      Dm_LaunchMain.Dtb_Ginkoia.Close;
    except
    end;
    try
      // Dm_LaunchEvent.Data_Evt.Close;
      Dm_LaunchEvent.CloseOpenConnexion();
    except
    end;
    Result := True;

    if Winexec(PAnsiChar(AnsiString(Path + 'BackRest.Exe auto')), 0) < 32 then
    begin
      // Event(LaBase0, CstLanceBackup, False, Null);
      Result := False;
    end;
    // Faire une attente de 10 Minutes
    for I := 1 to 600 do
    begin
      Sleep(1000);
      Application.ProcessMessages;
    end;
    I := 1;
    while MapGinkoia.Backup do
    begin
      Sleep(10000);
      Inc(I);
//      if I > (6 * 60) * 4 then // plus de 4 heures
//        BREAK;
      // plus de limite pendant le backup (certains durent plus de 4h), normalement le launcher doit de toute façon être fermé
      Application.ProcessMessages;
    end;
  end
  else
  begin
    Result := False;
    Ajoute(DateTimeToStr(Now) + '   ' + 'Ne trouve pas le Backup ', 0);
  end;
end;

procedure TFrm_LaunchV7.Tim_ReplicTpsReelTimer(Sender: TObject);
begin
//  Tim_ReplicTpsReelTimer.Enabled := False;
//  try
  Ajoute('Tick : Tim_ReplicTpsReelTimer ' + DateTimeToStr(now), 0, True);

  if Assigned(Frm_Param) and Frm_Param.visible
  // Fenetre de paramètrage des replic ouverte
    then
    EXIT;

  if taskReplication.Running then
    EXIT;

  if taskSynchroCaisse.Running then
    EXIT;

  if taskSynchroNotebook.Running then
    EXIT;

  // Synchro Caisse
  if isTimeSynchroCaisse then
  begin
    doSynchroCaisse;
    EXIT;
  end;

  // Replication Auto
  if ReplicTpsReelToDo then
  begin
    try
      Ajoute('Début réplication temps réél automatique', 2);
      ActiveOnglet(Tab_Affiche);

      // Lancement
      showHideLog(True);
      DoReplicTpsReelAndInfo;
    finally
      InitialiseLaunch;
      showHideLog(False);
    end;
  end;
  // JB
  if Date <> Lastdate then
  begin
    RecupDocDeVersion(Dm_LaunchV7.data_, extractFilePath(Application.exename));
    SetLastDateRecup;
  end;
  //

    // on regarde si on doit passer sur easy, et on fait les logs pour le monitoring
  CheckUpdateToEasy();
//  finally
//    Tim_ReplicTpsReelTimer.Enabled := True;
//  end;
end;

procedure TFrm_LaunchV7.SetLastDateRecup;
begin
  Lastdate := Date;
  saveIni;
end;

function TFrm_LaunchV7.isTimeSynchroCaisse: Boolean;
var
  vSynchroCaisse: TSynchroCaisse;
  vEvent: TEventHisto;
  vSyncTime, test, Test2: TDateTime;
begin
  Result := False;
  vSynchroCaisse := getSynchroCaisse;
  try
    Dm_LaunchEvent.CloseOpenConnexion();
    vEvent := GetEventInfos(LaBase0, CSYNCHROOK);
  except
    EXIT;
  end;

  if not vSynchroCaisse.Enabled then
    EXIT;
  if vSynchroCaisse.Server = '' then
    EXIT;
  vSyncTime := Frac(vSynchroCaisse.Time) + Trunc(Now);
  test := Now;
  Test2 := (vSyncTime + (10 * OneMinute));

  if Now < vSyncTime then
    EXIT; // Trop tot
  if Now > (vSyncTime + (10 * OneMinute)) then
    EXIT; // Trop tard

  if vEvent.HEV_DATE < vSyncTime then
    Result := True;
end;

function TFrm_LaunchV7.startVerification(aDownload: Boolean; aInstall: Boolean): Boolean;
var
  sParam: string;
  sFilename: string;
  sPath: string;
  sError: string;
  sReturn: Integer;
begin

  // on vérifie si on est sur le nouveau système de mise à jour, si c'est le cas on ne lance pas le vérif
  if not (IsNewMAJ) then
  begin
    sParam := '';
    if (not aDownload) and (not aInstall) then
      EXIT; // Nothing to do ...
    if aDownload and (not aInstall) then // appel avec (True, False)
      sParam := '';
    if (not aDownload) and aInstall then  // appel avec (False, True)
      sParam := 'AUTO';  // Modif 16/11 : Mode auto tout le temps.

      //sParam := 'MAJ';
    if aDownload and aInstall then // Appel avec (True, True)
      sParam := 'AUTO';

    Log.Log('Main', FBasGuid, 'Log', 'Démarrage de vérification.exe', logInfo, True, 0, ltLocal);

    sPath := IncludeTrailingBackslash(extractFilePath(Application.exename));
    sFilename := sPath + 'Verification.exe';

    if FileExists(sFilename) then
    begin
      Log.Log('Main', FBasGuid, 'Log', 'Execution de ' + sFilename + ' avec les paramètres ' + sParam, logInfo, True, 0, ltLocal);

      //sReturn := ExecAndWaitProcess(sError, sFilename, sParam, True, sPath);

      // on arrête tous les timers pendant le traitement
      try
        sReturn := ShellExecuteAndWait(sFilename, sParam, 3600); // une heure de timeout
      except
        on E: Exception do
        begin
          Log.Log('Main', FBasGuid, 'Log', 'Echec lor de l''execution de verification.exe : ''' + e.Message + '''', logError, True, 0, ltLocal);
        end;
      end;

      Log.Log('Main', FBasGuid, 'Log', 'Verification a retourné : ''' + SysErrorMessage(sReturn) + '''', logInfo, True, 0, ltLocal);
    end
    else
    begin
      Log.Log('Main', FBasGuid, 'Log', 'Verification non trouvé', logError, True, 0, ltLocal);
    end;
  end
  else
  begin
    Log.Log('Main', FBasGuid, 'Log', 'Verification.exe non lancé car on est sur le nouveau système de MAJ via les Ginkoia Tools' + sParam, logInfo, True, 0, ltLocal);
  end;

end;

// AJ le 20/09/2017 -> test si on est sur le nouveau système de MAJ avec les Ginkoia tools, pour désactiver le vérif
function TFrm_LaunchV7.IsNewMAJ(): Boolean;
begin
  IBQue_Tmp.Close;
  IBQue_Tmp.SQL.Clear;
  // pour le PRM_TYPE = 60 et PRM_CODE = 6, si PRM_INTEGER = 1 alors on est sur la mise à jour via les tools, sinon si 0 ou si la ligne n'existe pas, on est en MAJ Yellis
  IBQue_Tmp.SQL.Text := 'SELECT PRM_ID FROM GENPARAM WHERE PRM_TYPE = 60 AND PRM_CODE = 6 AND PRM_INTEGER = 1';
  IBQue_Tmp.Open;

  if not (IBQue_Tmp.Eof) then
    // si on trouve le genparam avec le PRM_INTEGER à 1, alors on est sur le nouveau système de MAJ
    Result := True
  else
    Result := False;

  IBQue_Tmp.SQL.Clear;
  IBQue_Tmp.Close;
end;

function TFrm_LaunchV7.updateVerification(): Boolean;
var
  sPath: string;
begin
  Result := False;

  sPath := IncludeTrailingBackslash(extractFilePath(Application.exename));

  //Cas particulier de l'exe qui ne se met plus a jour tous seul v13.2.10.0
  //Dans ce cas la le verification.exe ne sera pas traité.
  if ManageNotUpdatableVerificationExe then
  begin
    Exit;
  end;

  if FileExists(sPath + 'A_MAJ\verification.exe') then
  begin
    Log.Log('Main', FBasGuid, 'Log', 'Misa à jour de Verification', logInfo, True, 0, ltLocal);

    if CopyFile(pchar(sPath + 'A_MAJ\verification.exe'), pchar(sPath + 'verification.exe'), False) then
    begin
      Log.Log('Main', FBasGuid, 'Log', 'Mise à jour de Verification effectuée', logInfo, True, 0, ltLocal);
      if not DeleteFile(pchar(sPath + 'A_MAJ\verification.exe')) then
        Log.Log('Main', FBasGuid, 'Log', 'Erreur lors de la suppression de Verification dans A_MAJ', logError, True, 0, ltLocal);

      Result := True;
    end
    else
    begin
      Log.Log('Main', FBasGuid, 'Log', 'Erreur lors de la mise à jour de Verification', logError, True, 0, ltLocal);
    end;
  end
  else
    Result := True;
end;

procedure TFrm_LaunchV7.Tim_LanceRepliTimer(Sender: TObject);
var
  Ecart1: DWord;
  Ecart2: DWord;
  h, M, S, D: Word;
  debut: TDateTime;
  Ok: Boolean;
  // PathGinkoia: STRING;
begin
  try
    try
      Tim_LanceRepli.Enabled := False;

      ActiveOnglet(Tab_Affiche);

      InitEtat;
      Ajoute('Lancement du timer ', 0, True);
      if MapGinkoia.Backup then
      begin
        Ajoute('Backup en cours ', 0, True);
        Tim_LanceRepli.Interval := 1000 * 60 * 5;
        Tim_LanceRepli.Enabled := True;
        EXIT;
      end
      else
      begin
        updateVerification;

        // Lancement si dans les + ou - deux minutes
        if H1 then
        begin
          decodeTime(HEURE1, h, M, S, D);
          if (CalculeTemps(h, M, S, True) < 120000) then
          begin
            Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Automatique H1', 2);
            debut := Now;

            if H2 then
            // si on à une deuxième réplic nuit, on passe le recalcul à false pour qu'il ne le fasse qu'une seule fois aprrès la H2 : on fait maintenant toujours le recalcul lors de la première réplic nuit car sinon le backup et la base de synchro sont créés non recalculés
            begin
              Log.Log('LaunchV7_Frm', 'ReplicNuit', 'Log', 'Replic H1 normalement sans recalcul car H2', logDebug, True, 0, ltLocal);
              // Ok  := ReplicationAutomatique(False, False, 0, 0, False)
              Ok := ReplicationAutomatique(False, False, 0, 0)
            end
            else
            begin
              Log.Log('LaunchV7_Frm', 'ReplicNuit', 'Log', 'Replic H1 avec recalcul car pas de H2', logDebug, True, 0, ltLocal);
              Ok := ReplicationAutomatique(False, True, 0, 0);
            end;

            Ajoute('', 0);

            while CalculeTemps(h, M, S, True) < 120000 do
              LeDelay(1000);

//            if not H2 then
//            begin
//              if VerifChangeHorraire then
//              begin
//                InitialiseLaunch;
//                EXIT;
//              end;
//            end;
            InitialiseLaunch;
            EXIT;
          end;
        end;

        if H2 then
        begin
          decodeTime(HEURE2, h, M, S, D);
          if CalculeTemps(h, M, S, True) < 120000 then
          begin
            // réplication
            Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Automatique H2', 2);
            debut := Now;
            Ok := ReplicationAutomatique(False, True, 0, 0);

            while CalculeTemps(h, M, S, True) < 120000 do
              LeDelay(1000);
            if VerifChangeHorraire then
            begin
              InitialiseLaunch;
              EXIT;
            end;
            InitialiseLaunch;
            EXIT;
          end;
        end;

        if EtatBackup = 5 then
        begin
          decodeTime(HeureBackup, h, M, S, D);
          if CalculeTemps(h, M, S, True) < 120000 then
          begin
            LancementBackup;
            while CalculeTemps(h, M, S, True) < 120000 do
              LeDelay(1000);
          end;
        end;

        if EtatBackup = 3 then
        begin
          if CalculeTemps(23, 0, 0, True) < 120000 then
          begin
            LancementBackup;
            while CalculeTemps(23, 0, 0, True) < 120000 do
              LeDelay(1000);
          end;
        end;
        if EtatBackup = 4 then
        begin
          if CalculeTemps(22, 0, 0, True) < 120000 then
          begin
            LancementBackup;
            while CalculeTemps(22, 0, 0, True) < 120000 do
              LeDelay(1000);
          end;
        end;

        // 1 après la 1° réplication
        // 2 après la 2° réplication
        // 3 à 23 H
        // 4 à 22 H
        // 5 à heure fixe
        // à minuit vérification du changement d'horraire
        if (Sender <> NIL) and (CalculeTemps(0, 0, 2, True) < 120000) then
        begin
          if VerifChangeHorraire then
          begin
            InitialiseLaunch;
            EXIT;
          end;
        end;

        Ajoute('Calcule du prochain temps ', 0, True);
        decodeTime(Now, h, M, S, D);

        // on lance à heure pile
        Ecart1 := CalculeTemps(h + 1, 0, 0, False);
        if Ecart1 < 120000 then
          Ecart1 := 120000;

        // relancer le timer à heure réplication H1
        if H1 then
        begin
          Ajoute('H1 Valide ', 0, True);
          decodeTime(HEURE1, h, M, S, D);
          Ecart2 := CalculeTemps(h, M, S, False);
          Ajoute('Dans ' + IntToStr(Ecart2) + ' Ms', 0, True);
          if Ecart2 > 120000 then
          begin
            if Ecart2 < Ecart1 then
              Ecart1 := Ecart2;
          end;
        end;

        // relancer le timer à heure réplication H2
        if H2 then
        begin
          Ajoute('H2 Valide ', 0, True);
          decodeTime(HEURE2, h, M, S, D);
          Ecart2 := CalculeTemps(h, M, S, False);
          Ajoute('Dans ' + IntToStr(Ecart2) + ' Ms', 0, True);
          if Ecart2 > 120000 then
          begin
            if Ecart2 < Ecart1 then
              Ecart1 := Ecart2;
          end;
        end;

        if EtatBackup = 5 then
        begin
          Ajoute('Backup Valide ', 0, True);
          decodeTime(HeureBackup, h, M, S, D);
          Ecart2 := CalculeTemps(h, M, S, False);
          Ajoute('Dans ' + IntToStr(Ecart2) + ' Ms', 0, True);
          if Ecart2 > 120000 then
          begin
            if Ecart2 < Ecart1 then
              Ecart1 := Ecart2;
          end;
        end;

        if Ecart1 < 10000 then
          Ecart1 := 10000;
        Ajoute('Le temps : ' + IntToStr(Ecart1), 0, True);
        Tim_LanceRepli.Interval := Ecart1;
        Tim_LanceRepli.Enabled := True;
      end;
    except
      on E: Exception do
      begin
        if not (Tim_LanceRepli.Enabled) then
        begin
          Tim_LanceRepli.Enabled := True;

          Log.Log('Main', FBasGuid, 'ErrTimer', 'Impossible de relancer le timer : ' + E.Message, logError, True, 0, ltBoth);
        end;
      end;
    end;
  finally
    try
      if not (Tim_LanceRepli.Enabled) then
      begin
        Log.Log('Main', FBasGuid, 'ErrTimer', 'Timer pas relancé, relancé dans le Finally', logError, True, 0, ltBoth);
        Tim_LanceRepli.Enabled := True;
      end;

      Dm_LaunchMain.Dtb_Ginkoia.Close;
    except
    end;
    try
      // Dm_LaunchEvent.Data_Evt.Close;
      Dm_LaunchEvent.CloseOpenConnexion();
    except
    end;
  end;
end;

// ---------------------------------------------------------------
// Lancement manuel de la réplication
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.Btn_ReplicManuelleClick(Sender: TObject);
var
  debut: TDateTime;
  Ok: Boolean;
  LOOP: Integer;
begin
  showHideLog(True);
  Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Manuelle', 2);
  debut := Now;

  LOOP := GetLoop;

  Ok := ReplicationAutomatique(True, False, 0, LOOP, cbRecalculTrigger.Checked);

  if Ok then
  begin
    Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Réussie', 1);
    MessMAJ1 := '';
    MessMAJ2 := '';
  end
  else
    Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);
  Ajoute('', 0);
  Info;
  showHideLog(False);
end;

// ---------------------------------------------------------------
// Connexion à internet en fonction du mode choisi
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.Deconnexion;
begin
  if (Connectionencours <> NIL) and (Connectionencours.LeType = 0) then
    DeconnexionModem;
  Connectionencours := NIL;
end;

// ---------------------------------------------------------------
// deconnexion d'internet en fonction du mode choisi
// ---------------------------------------------------------------

function TFrm_LaunchV7.Connexion(repli: TLesreplication): Boolean;
var
  I: Integer;
  reg: TRegistry;
begin
  reg := TRegistry.Create(KEY_WRITE);
  try
    reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\', False);
    reg.WriteInteger('GlobalUserOffline', 0);
  finally
    reg.closekey;
    reg.Free;
  end;
  Result := False;
  I := 0;
  Connectionencours := NIL;
  while I < ListeConnexion.Count do
  begin
    Connectionencours := TLesConnexion(ListeConnexion[I]);
    if Connectionencours.LeType = 1 then // Routeur : Juste un Ping
    begin
      Ajoute(DateTimeToStr(Now) + '   ' + 'Connexion par un routeur', 0);
      if UnPing(repli.URLDISTANT + repli.Ping) then
      begin
        Ajoute(DateTimeToStr(Now) + '   ' + 'Connexion réussi', 0);
        tempsReplication := Now;
        Result := True;
        BREAK;
      end
      else
        Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de connexion au routeur [' + repli.URLDISTANT + repli.Ping + ']', 0);
    end
    else
    begin // Connexion sur modem
      tempsReplication := Now;
      Ajoute(DateTimeToStr(Now) + '   ' + 'Connexion par un modem', 0);
      if ConnexionModem(Connectionencours.Nom, Connectionencours.Tel) then
      begin
        Ajoute(DateTimeToStr(Now) + '   ' + 'Connexion réussi', 0);
        Result := True;
        BREAK;
      end
      else
        Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de connexion au modem', 0);
    end;
    Inc(I);
  end;
  if not Result then
    Connectionencours := NIL;
end;

// ---------------------------------------------------------------
// deconnexion des trigger de la base
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.DeconnexionTriger(Base: string; bWithEvent: Boolean = True);
begin
  Dm_LaunchMain.Dtb_Ginkoia.Close;
  Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := Base;
  try
    try
      Dm_LaunchMain.Dtb_Ginkoia.Open;
    except
      Ajoute('Problème connexion à la base Deconnexion trigger ', 0, True);
      raise;
    end;

    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;
    Log.Log('LaunchV7_Frm', 'DeconnexionTriger', 'Log', 'execute procedure BN_ACTIVETRIGGER (avant).', logDebug, True, 0, ltLocal);

    IB_Divers.SQL.Clear;
    IB_Divers.SQL.Add('execute procedure BN_ACTIVETRIGGER(0);');
    IB_Divers.ExecSQL;

    Log.Log('LaunchV7_Frm', 'DeconnexionTriger', 'Log', 'execute procedure BN_ACTIVETRIGGER (après).', logDebug, True, 0, ltLocal);
    Log.Log('LaunchV7_Frm', 'DeconnexionTriger', 'Log', 'execute procedure SM_AVANT_REPLI (avant).', logDebug, True, 0, ltLocal);

    IB_Divers.SQL.Clear;
    IB_Divers.SQL.Add('execute procedure SM_AVANT_REPLI;');
    IB_Divers.ExecSQL;

    Log.Log('LaunchV7_Frm', 'DeconnexionTriger', 'Log', 'execute procedure SM_AVANT_REPLI (après).', logDebug, True, 0, ltLocal);
    Commit;
    // if bWithEvent THEN
    // Event(Base, CstDeconnexionTrigger, True, Null);
  finally
    Dm_LaunchMain.Dtb_Ginkoia.Close;
  end;
end;

// ---------------------------------------------------------------
// reconnexion des trigger de la base
// ---------------------------------------------------------------

procedure TFrm_LaunchV7.connexionTriger(Base: string; bWithEvent: Boolean = True);
begin
  Dm_LaunchMain.Dtb_Ginkoia.Close;
  Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := Base;
  try
    try
      Dm_LaunchMain.Dtb_Ginkoia.Open;
    except
      Ajoute('Problème connexion à la base connexion trigger ', 0, True);
      raise;
    end;

    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;
    Log.Log('LaunchV7_Frm', 'connexionTriger', 'Log', 'execute procedure BN_ACTIVETRIGGER (avant).', logDebug, True, 0, ltLocal);

    IB_Divers.SQL.Clear;
    IB_Divers.SQL.Add('execute procedure BN_ACTIVETRIGGER(1);');
    IB_Divers.ExecSQL;

    Log.Log('LaunchV7_Frm', 'connexionTriger', 'Log', 'execute procedure BN_ACTIVETRIGGER (après).', logDebug, True, 0, ltLocal);
    Commit;
    // if bWithEvent THEN
    // Event(Base, CstReconnexionTrigger, True, Null);
  finally
    Dm_LaunchMain.Dtb_Ginkoia.Close;
  end;
end;

function TFrm_LaunchV7.ControleKVersion(Base: string): Integer;
var
  debut: TDateTime;
  Ok: Boolean;
  sPlage: string; // Contient la plage
  sPlageDeb: string;
  sPlageFin: string;
  iPlageDeb: Integer;
  iPlageFin: Integer;
begin
  Result := 0;
  debut := Now;
  Dm_LaunchMain.Dtb_Ginkoia.Close;
  Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := Base;
  Ok := False;
  try
    try
      Dm_LaunchMain.Dtb_Ginkoia.Open;
    except
      Ajoute('Problème connexion à la base Controle KVersion', 0, True);
      raise;
    end;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;
    try
      Log.Log('LaunchV7_Frm', 'ControleKVersion', 'Log', 'select GENBASES (avant).', logDebug, True, 0, ltLocal);

      IB_Divers.SQL.Clear;
      IB_Divers.SQL.Add('SELECT BAS_PLAGE');
      IB_Divers.SQL.Add('FROM GENBASES JOIN GENPARAMBASE ON (PAR_STRING = BAS_IDENT)');
      IB_Divers.SQL.Add('WHERE PAR_NOM = ''IDGENERATEUR''');
      IB_Divers.Open;

      Log.Log('LaunchV7_Frm', 'ControleKVersion', 'Log', 'select GENBASES (après).', logDebug, True, 0, ltLocal);
      iPlageDeb := -1;
      iPlageFin := -1;
      if not IB_Divers.IsEmpty then
      begin
        sPlage := IB_Divers.Fields[0].AsString;
        try
          sPlageDeb := StringReplace(Copy(sPlage, Pos('[', sPlage) + 1, Pos('_', sPlage) - (Pos('[', sPlage) + 1)), 'M', '000000', [rfReplaceAll]);
          sPlageFin := StringReplace(Copy(sPlage, Pos('_', sPlage) + 1, Pos(']', sPlage) - (Pos('_', sPlage) + 1)), 'M', '000000', [rfReplaceAll]);
          iPlageDeb := StrToInt(sPlageDeb);
          iPlageFin := StrToInt(sPlageFin);
          if iPlageDeb = 0 then
            sPlageDeb := '1';
        except
          iPlageDeb := -1;
          iPlageFin := -1;
        end;
      end;
      IB_Divers.Close;

      if (iPlageDeb >= 0) and (iPlageFin > 0) then
      begin
        Log.Log('LaunchV7_Frm', 'ControleKVersion', 'Log', 'select K (avant).', logDebug, True, 0, ltLocal);

        IB_Divers.SQL.Clear;
        IB_Divers.SQL.Add('SELECT K_ID');
        IB_Divers.SQL.Add('FROM K');
        IB_Divers.SQL.Add('WHERE K_VERSION >= ' + sPlageDeb);
        IB_Divers.SQL.Add(' AND K_VERSION <= ' + sPlageFin);
        IB_Divers.SQL.Add(' AND KSE_LOCK_ID <> 0');
        IB_Divers.SQL.Add(' AND K_ID <> 0');
        IB_Divers.SQL.Add(' AND KTB_ID NOT IN (-11111535, -11111709)');
        // Exclusion de ARTSEUILWEB & GENGENERATEUR
        IB_Divers.Open;

        Log.Log('LaunchV7_Frm', 'ControleKVersion', 'Log', 'select K (après).', logDebug, True, 0, ltLocal);
        Result := 0;
        IB_Divers.First;
        while not IB_Divers.Eof do
        begin
          Dm_LaunchMain.MainModifK(IB_Divers.Fields[0].AsInteger);
          Inc(Result);
          IB_Divers.Next;
        end;
        IB_Divers.Close;
      end;
      Ok := True;
      Dm_LaunchMain.Tra_Ginkoia.Commit;
    except
      on E: Exception do
      begin
        IB_Divers.Close;
        Dm_LaunchMain.Tra_Ginkoia.Rollback;

        Log.Log('LaunchV7_Frm', 'ControleKVersion', 'Log', E.Message, logError, True, 0, ltLocal);
      end;
    end;
  finally
    Dm_LaunchMain.Dtb_Ginkoia.Close;
  end;

  if Ok then
    Ajoute('Controle des KVersion OK', 0)
  else
    Ajoute('Controle des KVersion Erreur', 0);
end;

// ---------------------------------------------------------------
// recalcule des trigger de la base
// ---------------------------------------------------------------
function TFrm_LaunchV7.GetPasTrigger: Integer;
var
  Pas: Integer;
begin
  Pas := GetParamInteger(11, 52, FBasId);
  if Pas <= 0 then
    Pas := 500;
  Result := Pas;
end;

procedure TFrm_LaunchV7.recalculeTriger(Base: string; bWithEvent: Boolean = True; bReplicIsOK: Boolean = False; AvecPas: Boolean = False);
var
  IdDos: Integer;
  debut: TDateTime;
  Ok: Boolean;
  LePas: Integer;
  boucle: Integer;

  procedure Marque_Base(Valeur: Integer);
  begin
    if IdDos = -1 then
    begin
      IdDos := NouvelleClef;
      InsertK(IdDos, -11111338);
      Log.Log('LaunchV7_Frm', 'Marque_Base', 'Log', 'insert GENDOSSIER (avant).', logDebug, True, 0, ltLocal);

      IB_Divers.SQL.Clear;
      IB_Divers.SQL.Add('INSERT INTO GenDossier');
      IB_Divers.SQL.Add('(DOS_ID, DOS_NOM, DOS_STRING,DOS_FLOAT)');
      IB_Divers.SQL.Add('VALUES');
      IB_Divers.SQL.Add('(' + IntToStr(IdDos) + ',' + QuotedStr('T-' + IB_LaBaseBAS_ID.AsString) + ',' + DateToStr(Date) + ',' + IntToStr(Valeur) + ')');
      IB_Divers.ExecSQL;

      Log.Log('LaunchV7_Frm', 'Marque_Base', 'Log', 'insert GENDOSSIER (après).', logDebug, True, 0, ltLocal);
    end
    else
    begin
      ModifK(IdDos);
      Log.Log('LaunchV7_Frm', 'Marque_Base', 'Log', 'update GENDOSSIER (avant).', logDebug, True, 0, ltLocal);

      IB_Divers.Close;
      IB_Divers.SQL.Clear;
      IB_Divers.SQL.Add('UPDATE GENDOSSIER');
      IB_Divers.SQL.Add('SET DOS_STRING =' + EnStr(DateToStr(Date)) + ',');
      IB_Divers.SQL.Add('   DOS_FLOAT=' + EnStr(Valeur));
      IB_Divers.SQL.Add('WHERE DOS_ID = ' + EnStr(IdDos));
      IB_Divers.ExecSQL;

      Log.Log('LaunchV7_Frm', 'Marque_Base', 'Log', 'update GENDOSSIER (après).', logDebug, True, 0, ltLocal);
    end;
    Commit;
  end;

begin
  debut := Now;
  Dm_LaunchMain.Dtb_Ginkoia.Close;
  Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := Base;
  Ok := True;
  boolRecalculOk := True;
  // lab signale l'erreur pour déclencher l'affichage du message d'erreur recalcul

  taskRecalc.Running := True;
  taskRecalc.Last := Now;

  try
    try
      Dm_LaunchMain.Dtb_Ginkoia.Open;
    except
      Ajoute('Problème connexion à la base recalcul trigger ', 0, True);
      raise;
    end;
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;
    Log.Log('LaunchV7_Frm', 'recalculeTriger', 'Log', 'select GENDOSSIER (avant).', logDebug, True, 0, ltLocal);

    IB_Divers.SQL.Clear;
    IB_Divers.SQL.Add('Select DOS_ID');
    IB_Divers.SQL.Add('From GenDossier');
    IB_Divers.SQL.Add('Where DOS_NOM =' + QuotedStr('T-' + IB_LaBaseBAS_ID.AsString));
    IB_Divers.Open;

    Log.Log('LaunchV7_Frm', 'recalculeTriger', 'Log', 'select GENDOSSIER (après).', logDebug, True, 0, ltLocal);

    if IB_Divers.IsEmpty then
    begin
      IdDos := -1;
    end
    else
      IdDos := IB_Divers.Fields[0].AsInteger;
    IB_Divers.Close;
    try
      // On ajoute le prétraitement
      try
        Ajoute(DateTimeToStr(Now) + '   ' + 'Pré-traitement', 0);

        Log.Log('LaunchV7_Frm', 'recalculeTriger', 'Log', 'IBQue_PreCalculTrigger (avant).', logDebug, True, 0, ltLocal);
        IBQue_PreCalculTrigger.ExecSQL;
        Log.Log('LaunchV7_Frm', 'recalculeTriger', 'Log', 'IBQue_PreCalculTrigger (après).', logDebug, True, 0, ltLocal);
      finally
        IBQue_PreCalculTrigger.Close;
      end;
      Commit;

      LePas := 500;
      if AvecPas then
        LePas := GetPasTrigger;

      Ajoute(DateTimeToStr(Now) + '   ' + 'Calcul (Pas=' + IntToStr(LePas) + ')', 0);
      repeat
        AjouteTC('.', 0);
        Commit;

        Log.Log('LaunchV7_Frm', 'recalculeTriger', 'Log', 'IB_CalculeTrigger (avant).', logDebug, True, 0, ltLocal);
        IB_CalculeTrigger.Close;
        IB_CalculeTrigger.ParamByName('pas').AsInteger := LePas;
        IB_CalculeTrigger.Open;
        Log.Log('LaunchV7_Frm', 'recalculeTriger', 'Log', 'IB_CalculeTrigger (après).', logDebug, True, 0, ltLocal);
      until IB_CalculeTriggerRETOUR.AsInteger = 0;
      Commit;
      IB_CalculeTrigger.Close;

      // tous bon on le marque
      Ajoute(DateTimeToStr(Now) + '   ' + 'Recalcul OK (Pas=' + IntToStr(LePas) + ')', 0);

      if (boolRecalculOk) and (bReplicIsOK) then
      begin
        // On ajoute le traitement de la fusion
        try
          Ajoute(DateTimeToStr(Now) + '   ' + 'Fusion des fiches modèles', 0);

          Log.Log('LaunchV7_Frm', 'recalculeTriger', 'Log', 'IBQue_CalcFusion (avant).', logDebug, True, 0, ltLocal);
          IBQue_CalcFusion.ExecSQL;
          Log.Log('LaunchV7_Frm', 'recalculeTriger', 'Log', 'IBQue_CalcFusion (après).', logDebug, True, 0, ltLocal);
        finally
          IBQue_CalcFusion.Close;
        end;
        Commit;
      end;

      Marque_Base(1);
      taskRecalc.LastOk := Now;
      taskRecalc.Ok := True;
    except
      on E: Exception do
      begin
        // erreur de recalcule des trigger
        Ok := False;
        if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
          Dm_LaunchMain.Tra_Ginkoia.Rollback;

        Dm_LaunchMain.Tra_Ginkoia.StartTransaction;
        Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le recalcul ', 0);
        boolRecalculOk := False;
        taskRecalc.Error := E.Message;
        Marque_Base(0);
      end;
    end;

  finally
    taskRecalc.Running := False;

    Dm_LaunchMain.Dtb_Ginkoia.Close;
  end;
end;

// ---------------------------------------------------------------
// Faire le PUSH
// ---------------------------------------------------------------

function TFrm_LaunchV7.LoopPUSH(repli: TLesreplication; bWithEvent: Boolean = True): Boolean;
var
  I: Integer;
  ResultBody: string;
  Temps: ttimestamp;
  tsl: TStringList;
  tsSource: TStrings;
  DebutPush: TDateTime;
  debut: TDateTime;
begin
  if repli.ListProvider.Count = 0 then
  begin
    Result := True;
    debut := Now;
  end
  else
  begin
    Result := PUSH(repli, 1, bWithEvent);
  end;
end;

// ==============================================================================
function TFrm_LaunchV7.PUSH(repli: TLesreplication; AForceLoop: Integer = 0; bWithEvent: Boolean = True): Boolean;
var
  I: Integer;
  vLoop: Integer;
  vAutoLoop: Boolean;
  vPass: Integer;
  vProvider: string;
  vTc: Cardinal;
  // ----------------------------------------------------------------------------

  function doPush(aProvider: string; aLoop, aTry: Integer): Boolean;
  var
    vHttp: TIdHTTP;
    vBody: TStringStream;
    vTime: ttimestamp;
    vSa: string;
  begin
    Result := False;
    try

      vHttp := GetTIdHttp(repli.User, repli.PWD, 0);
      vBody := TStringStream.Create;
      try
        if (aLoop > 0) then
        begin
          vHttp.ReadTimeout := 300000; // 300 sec
          vHttp.Get(repli.URLLocal + 'LoopOnPush' + '?Caller=' + Application.exename + '&Provider=' + aProvider + '&VERSION_STEP=' + IntToStr(aLoop), vBody);
        end
        else
        begin
          vHttp.ReadTimeout := 1800000; // 1800 sec
          vHttp.Get(repli.URLLocal + repli.PUSH + '?Caller=' + Application.exename + '&Provider=' + aProvider, vBody);
        end;

        if (vHttp.ResponseCode <> 200) or (Pos('ERROR', UpperCase(vBody.DataString)) > 0) or (Pos('LOGITEM', UpperCase(vBody.DataString)) > 0) then
        begin
          vTime := DateTimeToTimeStamp(Now);
          vBody.SaveToFile(repli.PlaceEai + 'RESULT\PUSH\' + IntToStr(vTime.Date) + '-' + IntToStr(vTime.Time) + '-' + aProvider + '-' + IntToStr(aTry) + '.xml');
          raise Exception.Create('Problème sur le paquet ' + aProvider);
        end;

        Result := True;
      finally
        vBody.Free;
        vHttp.Free;
      end;

    except
      on E: Exception do
      begin
        if aLoop > 0 then
          doLog('Erreur PUSH : ' + E.Message, logTrace)
        else
          doLog('Erreur PUSH-LOOP : ' + E.Message, logTrace);
      end;
    end;
  end;
// ----------------------------------------------------------------------------



begin
  Result := False;
  ForceDirectories(repli.PlaceEai + 'RESULT\PUSH\');
  for I := 0 to repli.ListProvider.Count - 1 do
  begin
    vProvider := TLesProvider(repli.ListProvider[I]).Nom;
    vLoop := TLesProvider(repli.ListProvider[I]).LOOP;
    vAutoLoop := False;

    if AForceLoop <> 0 // Loop forcé
      then
      vLoop := AForceLoop;

    if vLoop < 0 then
    begin
      vAutoLoop := True; // Loop Auto
      vLoop := 0 - vLoop;
    end;

    if (vLoop = 1) // Compatibilité ascendante
      then
      vLoop := 750;

    try
      if vAutoLoop then
      begin
        vTc := GetTickCount;
        doLog('Envoi de ' + vProvider, logInfo);
        if not doPush(vProvider, 0, 1) then
        begin
          if (GetTickCount - vTc) > 30000 then
          begin
            doLog('Erreur lors de l''envoi de ' + vProvider + ' . Réessai en LOOP', logWarning);
            if not doPush(vProvider, vLoop, 1) then
            begin
              doLog('Erreur lors de l''envoi de ' + vProvider, logError);
              taskReplication.Error := 'Erreur lors de l''envoi de ' + vProvider;
              EXIT;
            end;
          end
          else
          begin
            doLog('Erreur lors de l''envoi de ' + vProvider, logError);
            taskReplication.Error := 'Erreur lors de l''envoi de ' + vProvider;
            EXIT;
          end;
        end;
      end
      else
      begin
        if vLoop > 0 then
          doLog('Envoi Loop de ' + vProvider, logInfo)
        else
          doLog('Envoi de ' + vProvider, logInfo);

        if not doPush(vProvider, vLoop, 1) then
        begin
          doLog('Erreur lors de l''envoi de ' + vProvider, logError);
          EXIT;
        end;
      end;
    except
      on E: Exception do
      begin
        doLog('Erreur lors de l''envoi de ' + vProvider + ' : ' + E.Message, logError);
        taskReplication.Error := 'Erreur lors de l''envoi de ' + vProvider;
        EXIT;
      end;
    end;
  end;

  Result := True;
end;
// ==============================================================================

// ---------------------------------------------------------------
// Faire le PULL
// ---------------------------------------------------------------

function TFrm_LaunchV7.LoopPULL(repli: TLesreplication; bWithEvent: Boolean = True): Boolean;
begin
  Result := PULL(repli, 1, bWithEvent);
  // Remplacé par un flag dans la procédure pull
end;

procedure TFrm_LaunchV7.PanFondPrincipalBtnCloseOnClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_LaunchV7.PanFondPrincipalMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  aPoint: TPoint;
begin
  MouseCapture := True;
  if (ssLeft in Shift) then
  begin
    if (MousePos.X = -1) then
    begin
      MousePos.X := X;
      MousePos.Y := Y;
    end
    else
    begin
      getCursorPos(aPoint);
      Frm_LaunchV7.Left := aPoint.X - MousePos.X;
      Frm_LaunchV7.Top := aPoint.Y - MousePos.Y;
    end;
  end
  else
  begin
    MousePos.X := -1;
    MousePos.Y := -1;
  end;

end;

procedure TFrm_LaunchV7.ParametrageClick(Sender: TObject);
begin
  if MotDePasse('PassGeneral') then
  begin
    ActiveOnglet(Tab_Manuel);
    DoEventStatus;
  end;
end;

function TFrm_LaunchV7.PULL(repli: TLesreplication; AForceLoop: Integer = 0; bWithEvent: Boolean = True): Boolean;
var
  I: Integer;
  vLoop: Integer;
  vAutoLoop: Boolean;
  vPass: Integer;
  vSubscription: string;
  vTc: Cardinal;

  // ----------------------------------------------------------------------------

  function doPull(aSubscription: string; aLoop, aTry: Integer): Boolean;
  var
    vHttp: TIdHTTP;
    vBody: TStringStream;
    vTime: ttimestamp;
  begin
    Result := False;
    try

      vHttp := GetTIdHttp(repli.User, repli.PWD, 0);
      vBody := TStringStream.Create;
      try
        if (aLoop > 0) then
        begin
          vHttp.ReadTimeout := 300000; // 300 sec
          vHttp.Get(repli.URLLocal + 'LoopOnPull' + '?Caller=' + Application.exename + '&Subscription=' + aSubscription + '&VERSION_STEP=' + IntToStr(aLoop), vBody);
        end
        else
        begin
          vHttp.ReadTimeout := 1800000; // 1800 sec
          vHttp.Get(repli.URLLocal + repli.PULL + '?Caller=' + Application.exename + '&Subscription=' + aSubscription, vBody);
        end;

        if (vHttp.ResponseCode <> 200) or (Pos('ERROR', UpperCase(vBody.DataString)) > 0) or (Pos('LOGITEM', UpperCase(vBody.DataString)) > 0) then
        begin
          vTime := DateTimeToTimeStamp(Now);
          vBody.SaveToFile(repli.PlaceEai + 'RESULT\PULL\' + IntToStr(vTime.Date) + '-' + IntToStr(vTime.Time) + '-' + aSubscription + '-' + IntToStr(aTry) + '.xml');
          raise Exception.Create('Problème sur le paquet ' + aSubscription);
        end;

        Result := True;
      finally
        vBody.Free;
        vHttp.Free;
      end;

    except
      on E: Exception do
      begin
        if aLoop > 0 then
          doLog('Erreur PULL : ' + E.Message, logTrace)
        else
          doLog('Erreur PULL-LOOP : ' + E.Message, logTrace);
      end;
    end;
  end;
// ----------------------------------------------------------------------------



begin

  Result := False;
  ForceDirectories(repli.PlaceEai + 'RESULT\PULL\');
  for I := 0 to repli.ListSubScriber.Count - 1 do
  begin
    vSubscription := TLesProvider(repli.ListSubScriber[I]).Nom;
    vLoop := TLesProvider(repli.ListSubScriber[I]).LOOP;
    vAutoLoop := False;

    if AForceLoop <> 0 // Loop forcé
      then
      vLoop := AForceLoop;

    if vLoop < 0 then
    begin
      vAutoLoop := True; // Loop Auto
      vLoop := 0 - vLoop;
    end;

    if (vLoop = 1) // Compatibilité ascendante
      then
      vLoop := 750;

    try
      if vAutoLoop then
      begin
        vTc := GetTickCount;
        doLog('Réception de ' + vSubscription, logInfo);
        if not doPull(vSubscription, 0, 1) then
        begin
          if (GetTickCount - vTc) > 30000 then
          begin
            doLog('Erreur lors de la réception de ' + vSubscription + ' . Réessai en LOOP', logWarning);
            if not doPull(vSubscription, vLoop, 1) then
            begin
              doLog('Erreur lors de la réception de ' + vSubscription, logError);
              taskReplication.Error := 'Erreur lors de la réception de ' + vSubscription;
              EXIT;
            end;
          end
          else
          begin
            doLog('Erreur lors de la réception de ' + vSubscription, logError);
            taskReplication.Error := 'Erreur lors de la réception de ' + vSubscription;
            EXIT;
          end;
        end;
      end
      else
      begin
        if vLoop > 0 then
          doLog('Réception Loop de ' + vSubscription, logInfo)
        else
          doLog('Réception de ' + vSubscription, logInfo);

        if not doPull(vSubscription, vLoop, 1) then
        begin
          doLog('Erreur lors de la reception de ' + vSubscription, logError);
          taskReplication.Error := 'Erreur lors de la réception de ' + vSubscription;
          EXIT;
        end;
      end;
    except
      on E: Exception do
      begin
        doLog('Erreur lors de la réception de ' + vSubscription + ' : ' + E.Message, logError);
        taskReplication.Error := 'Erreur lors de la réception de ' + vSubscription;
        EXIT;
      end;
    end;
  end;

  Result := True;

  // if repli.ListSubScriber.Count = 0 then
  // begin
  // Result := True;
  // debut  := Now;
  // end
  // else begin
  // Result := False;
  // debut  := Now;
  // ForceDirectories(repli.PlaceEai + 'RESULT\PULL\');
  // FOR I  := 0 TO repli.ListSubScriber.Count - 1 DO
  // BEGIN
  // Ajoute(DateTimeToStr(Now) + '   ' + format('%-20s', ['Reception ' + TLesProvider(repli.ListSubScriber[I]).Nom]) + #09, 0);
  // DebutPull    := Now;
  // TRY
  // sUrlParams := '?Caller=' + Application.exename;
  // sUrlParams := sUrlParams + '&Subscription=' + TLesProvider(repli.ListSubScriber[I]).Nom;
  //
  // MyHttp     := GetTIdHttp(repli.User, repli.PWD, 0);
  // TRY
  //
  // if (AForceLoop > 0) then
  // begin
  // AStep := AForceLoop;
  // end
  // else if TLesProvider(repli.ListSubScriber[I]).LOOP = 1 then
  // begin
  // AStep := 750; // compatibilité avec l'existant
  // end
  // else if TLesProvider(repli.ListSubScriber[I]).LOOP > 1 then
  // begin
  // AStep := TLesProvider(repli.ListSubScriber[I]).LOOP;
  // end
  // else begin
  // AStep := 0;
  // end;
  //
  // IF (AStep > 0) THEN
  // BEGIN
  // MyHttp.ReadTimeout := 300000;
  // sUrlParams         := sUrlParams + '&VERSION_STEP=' + Inttostr(AStep);
  // sLibOrdre          := 'PULL-LOOP';
  // ResultBody         := MyHttp.Get(repli.URLLocal + 'LoopOnPull' + sUrlParams);
  // END
  // ELSE
  // BEGIN
  // MyHttp.ReadTimeout := 900000;
  // sLibOrdre          := 'PULL';
  // ResultBody         := MyHttp.Get(repli.URLLocal + repli.PULL + sUrlParams);
  // END;
  //
  // Temps      := dateTimeToTimeStamp(Now);
  // tsl        := TStringList.Create;
  // TRY
  // tsl.Text := ResultBody;
  // // modification pour nouveau XML
  // IF (Pos('ERROR', Uppercase(tsl.Text)) > 0) OR (Pos('LOGITEM', Uppercase(tsl.Text)) > 0) THEN
  // BEGIN
  // tsl.Savetofile(repli.PlaceEai + 'RESULT\PULL\' + Inttostr(Temps.Date) + '-' + Inttostr(Temps.time) + '-' + Inttostr(I + 1) + '.Xml');
  // Result   := False;
  // MessMAJ2 := MessMAJ2 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur le ' + sLibOrdre + ' : ' + TLesProvider(repli.ListSubScriber[I]).Nom;
  // MyHttp.free;
  // BREAK; // ATTENTION BREAK
  // END
  // ELSE
  // Result := True;
  // FINALLY
  // tsl.free;
  // END;
  // MyHttp.free;
  // EXCEPT
  // Result   := False;
  // MessMAJ2 := MessMAJ2 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur le ' + sLibOrdre + '...';
  // MyHttp.free;
  // BREAK;
  // END;
  // FINALLY
  // AjouteTC('  Fin ' + FormatDateTime('hh:nn:ss', Now), 0);
  // END;
  // END;
  // end;
end;

function TFrm_LaunchV7.LignesModifiees: Boolean;
begin
  Result := True;
  FMaxVersion := 0;
  Ajoute('Recherche des données modifiées.');

  // Recherche du MAX_VERSION de la dernière réplication réussie.
  IBQue_Tmp.Close;
  IBQue_Tmp.SQL.Clear;
  IBQue_Tmp.SQL.Add('select PAR_STRING');
  IBQue_Tmp.SQL.Add('from GENPARAMBASE');
  IBQue_Tmp.SQL.Add('where PAR_NOM = ''MAX_VERSION''');
  try
    IBQue_Tmp.Open;
  except
    on E: Exception do
    begin
      Ajoute('Erreur :  la recherche du MAX_VERSION de la dernière réplication réussie a échoué :  ' + E.Message, 0, True);
      EXIT;
    end;
  end;
  if IBQue_Tmp.IsEmpty then
  begin
    // Création du paramètre.
    IBQue_Tmp.Close;
    IBQue_Tmp.SQL.Clear;
    IBQue_Tmp.SQL.Add('insert into GENPARAMBASE');
    IBQue_Tmp.SQL.Add('values(''MAX_VERSION'', ''0'', null)');
    try
      IBQue_Tmp.ExecSQL;
    except
      on E: Exception do
      begin
        Ajoute('Erreur :  la création du paramètre MAX_VERSION a échoué :  ' + E.Message, 0, True);
        EXIT;
      end;
    end;

    IBQue_Tmp.Transaction.Commit;
  end
  else
    TryStrToInt(IBQue_Tmp.Fields[0].AsString, FMaxVersion);

  // Recherche du nombre de lignes modifiées dans la tranche des K.
  IBQue_Tmp.Close;
  IBQue_Tmp.SQL.Clear;
  IBQue_Tmp.SQL.Add('select * from GET_NB_LIGNES_MODIFIEES(:BorneMin, :BorneMax, :MaxVersion)');
  try
    IBQue_Tmp.ParamByName('BorneMin').AsInteger := KRange.Min;
    IBQue_Tmp.ParamByName('BorneMax').AsInteger := KRange.Max;
    IBQue_Tmp.ParamByName('MaxVersion').AsInteger := FMaxVersion;
    IBQue_Tmp.Open;
  except
    on E: Exception do
    begin
      Ajoute('Erreur :  la recherche du nombre de lignes modifiées dans la tranche des K a échoué :  ' + E.Message, 0, True);
      EXIT;
    end;
  end;
  if IBQue_Tmp.Fields[0].AsInteger = 0 then
  begin
    Ajoute('>> Pas de données modifiées.');
    Result := False;
  end
  else
    Ajoute('>> ' + IntToStr(IBQue_Tmp.Fields[0].AsInteger) + IfThen(IBQue_Tmp.Fields[0].AsInteger > 1, ' données modifiées trouvées.', ' donnée modifiée trouvée.'));

  // Recherche du max(K_VERSION).
  IBQue_Tmp.Close;
  IBQue_Tmp.SQL.Clear;
  IBQue_Tmp.SQL.Add('select max(K_VERSION)');
  IBQue_Tmp.SQL.Add('from K');
  IBQue_Tmp.SQL.Add('where K_VERSION >= :BorneMin and K_VERSION < :BorneMax');
  try
    IBQue_Tmp.ParamByName('BorneMin').AsInteger := KRange.Min;
    IBQue_Tmp.ParamByName('BorneMax').AsInteger := KRange.Max;
    IBQue_Tmp.Open;
  except
    on E: Exception do
    begin
      Ajoute('Erreur :  la recherche du max(K_VERSION) a échoué :  ' + E.Message, 0, True);
      EXIT;
    end;
  end;
  if (not IBQue_Tmp.IsEmpty) and (not IBQue_Tmp.Fields[0].IsNull) then
    FMaxVersion := IBQue_Tmp.Fields[0].AsInteger;
end;

procedure TFrm_LaunchV7.SauvegardeMaxKVersion;
begin
  // Sauvegarde du max(K_VERSION).
  IBQue_Tmp.Close;
  IBQue_Tmp.SQL.Clear;
  IBQue_Tmp.SQL.Add('update GENPARAMBASE');
  IBQue_Tmp.SQL.Add('set PAR_STRING = :MaxKVersion');
  IBQue_Tmp.SQL.Add('where PAR_NOM = ''MAX_VERSION''');
  try
    IBQue_Tmp.ParamByName('MaxKVersion').AsInteger := FMaxVersion;
    IBQue_Tmp.ExecSQL;
  except
    on E: Exception do
    begin
      Ajoute('Erreur :  la sauvegarde du max(K_VERSION) a échoué :  ' + E.Message, 0, True);
      EXIT;
    end;
  end;

  IBQue_Tmp.Transaction.Commit;
end;

// ---------------------------------------------------------------
// Lancement de la réplication
// ---------------------------------------------------------------
function TFrm_LaunchV7.ReplicationAutomatique(Manuelle, Derniere: Boolean; LeType: Byte; LOOP: Integer; bRecalcul: Boolean = True): Boolean;
var
  I: Integer;
  Connecte: Boolean;
  repli: TLesreplication;
  debut: TDateTime;
  debutPF: TDateTime;
  finPF: TDateTime;
  DebutRepli: TDateTime;
  repliOk: Boolean;
  Ok: Boolean;
  reg: TRegistry;
  tsl: TStringList;
  S1, S: string;
  Max: Longint;
  DefaultLCID: LCID;
  iNbReplLog: Integer;
  bTestVersion: Boolean; // Teste si la version est ok
  bVersionError: Boolean;
  sAdresse: string; // Adresse du soap
  sResult: string; // résultat du getversion

  RioThread: TRioThread;
  iTrycount: Integer;
  bReferencementOK: Boolean;
  vSynchroCaisse: TSynchroCaisse;
  sRepertoireDestination: string;

{$REGION 'ReplicationAutomatique'}

  function Replication: Boolean;
  begin
    Result := True;
    Ajoute(DateTimeToStr(Now) + '   ' + 'Base ' + repli.PlaceBase, 0);
    DebutRepli := Now;
    repliOk := True;

    try
      // 1° : Lancer DelosQpmAgent
      if Winexec(PAnsiChar(AnsiString(repli.PlaceEai + 'Delos_QpmAgent.exe')), 0) > 31 then
      begin
        try
          Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement de QPMAgent ', 0);
          Sleep(1000);
          // 2° : tester si le ping local fonctionne
          if UnPing(repli.URLLocal + repli.Ping) then
          begin
            Ajoute(DateTimeToStr(Now) + '   ' + 'PING Local OK ', 0);
            if not Connecte then
            begin
              Ajoute(DateTimeToStr(Now) + '   ' + 'Connexion à Internet', 0);
              if not Connexion(repli) then
              begin
                // Pas de connexion à internet
                MessMAJ1 := DateTimeToStr(Now) + '   ' + 'Pas de connexion à internet';
                Ajoute(MessMAJ1, 0);
                Result := False;
                repliOk := False;
                taskReplication.Error := 'Pas de connexion à internet';

                // Passer à la réplication suivante.
                Result := False;
                EXIT;
              end
              else
                Connecte := True;
            end;

            // 3° : Essayer un Ping Distant
            if UnPing(repli.URLDISTANT + repli.Ping) then
            begin
              Ajoute(DateTimeToStr(Now) + '   ' + 'PING Distant OK ', 0);
              if (Connectionencours = NIL) or (Connectionencours.LeType = 1) then
              begin
                Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement du PING en Boucle ', 0);
                InitPing(repli.URLDISTANT + repli.Ping, 120000);
              end;

              try
                if LeType in [0, 1] then
                begin
                  // Push Provider
                  if (I = 0) and (LeType = 0) then
                    bReferencementOK := Lancementdesreferencements(1, repli);

                  DeconnexionTriger(repli.PlaceBase);
                  try

                    Ajoute(DateTimeToStr(Now) + '   ' + 'Début du PUSH ', 0);

                    Ok := PUSH(repli, LOOP);

                    if Ok then
                    begin
                      Ajoute(DateTimeToStr(Now) + '   ' + 'PUSH Réussi', 0);

                      // Sauvegarde du max(K_VERSION).
                      SauvegardeMaxKVersion;

                      if LeType = 0 then
                      begin
                        // Pull Subscripter
                        if (I = 0) and (LeType = 0) then
                        begin
                          debutPF := Now;
                          Ok := Lancementdesreferencements(2, repli);
                          finPF := Now;
                          bReferencementOK := Ok;
                        end;

                        if (bReplicPlateforme) and (not Ok) then
                        // En mode PF, on teste si le référencement à marché.
                        begin
                          // problème
                          Ajoute(MessReplicPlateforme, 0);
                          Result := False;
                          repliOk := False;
                        end
                        else
                        begin

                          Ajoute(DateTimeToStr(Now) + '   ' + 'Début du PULL', 0);

                          Ok := PULL(repli, LOOP);

                          if not Ok then
                          begin
                            // problème
                            Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le PULL', 0);
                            Result := False;
                            repliOk := False;
                          end
                          else
                          begin
                            Ajoute(DateTimeToStr(Now) + '   ' + 'PULL réussi', 0);
                            if (I = 0) and (LeType = 0) then
                              bReferencementOK := Lancementdesreferencements(3, repli);
                          end;
                        end;
                      end;
                    end
                    else
                    begin
                      Result := False;
                      repliOk := False;
                      Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le PUSH', 0);
                    end;
                  finally
                    connexionTriger(repli.PlaceBase);
                  end;
                end
                else
                begin
                  DeconnexionTriger(repli.PlaceBase);
                  try
                    // Pull Subscripter
                    Ajoute(DateTimeToStr(Now) + '   ' + 'Début du PULL', 0);

                    Ok := PULL(repli, LOOP);

                    if not Ok then
                    begin
                      // problème
                      Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le PULL', 0);
                      Result := False;
                      repliOk := False;
                    end
                    else
                      Ajoute(DateTimeToStr(Now) + '   ' + 'PULL réussi', 0);
                  finally
                    connexionTriger(repli.PlaceBase);
                  end;
                end;
              finally
                Ajoute(DateTimeToStr(Now) + '   ' + 'Arret du PING', 0);
                StopPing;
              end;
            end
            else
            begin
              // Pas Ping distant
              MessMAJ1 := DateTimeToStr(Now) + '   ' + 'Pas de PING Distant ';
              Ajoute(MessMAJ1, 0);
              Result := False;
              repliOk := False;
              taskReplication.Error := 'Pas de ping distant';
            end;
          end
          else
          begin
            // Pas de Ping en local
            MessMAJ1 := DateTimeToStr(Now) + '   ' + 'Pas de PING Local ';
            Ajoute(MessMAJ1, 0);
            Result := False;
            repliOk := False;
            taskReplication.Error := 'Pas de ping local';
          end;
        finally
          Ajoute(DateTimeToStr(Now) + '   ' + 'Arret de QPMAgent', 0);
          ArretDelos;
        end;
      end
      else
      begin
        // Pas possible de lancer QpmAgent
        MessMAJ1 := DateTimeToStr(Now) + '   ' + 'Impossible de lancer QPMAgent ';
        Ajoute(MessMAJ1, 0);
        // Ajoute (DateTimeToStr (Now) + '   ' + 'Impossible de lancer QPMAgent ', 0) ;
        Result := False;
        repliOk := False;
        taskReplication.Error := 'Impossible de lancer QPMAgent';
      end;
    finally
      // Event(repli.PlaceBase, CstUneReplication, repliOk, Now - DebutRepli);
    end;
  end;
{$ENDREGION}



begin
  MessReplicPlateforme := '';

  showHideLog(True);

  // LeType = 0 pour les deux, 1 push uniquement, 2 pull uniquement, 3 recalcul uniquement

  if not checkKRange then
    EXIT;
  if not checkLocalSeparators then
    EXIT;

  if taskSynchroNotebook.Running or taskSynchroCaisse.Running then
  begin
    Ajoute('Synchronisation en cours, réplication annulée', 0);
    EXIT;
  end;

  reg := TRegistry.Create(KEY_WRITE);
  try
    reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings\', False);
    reg.WriteInteger('GlobalUserOffline', 0);
  finally
    reg.Free;
  end;

  ReplicOk := False;
  bReferencementOK := False;
  RepliEnCours := True;
  taskReplication.Running := True;
  updateButtons;
  try
    Enabled := False;
    try
      debut := Now;
      //
      if MapGinkoia.Backup then
      begin
        if not TrouverlabonneHeure then
        begin
          Result := False;
          EXIT;
        end;
      end;
      MapGinkoia.Launcher := True;

      vSynchroCaisse := getSynchroCaisse;
      if (BaseSauvegarde) or (isPortableSynchro) or (vSynchroCaisse.Enabled) then
      begin
        // Contrôle si lignes modifiées (réplication utile / inutile).
        if LignesModifiees then
          LeType := 1
        else
          LeType := 3;
      end;

      Connecte := False;
      Connectionencours := NIL;
      Result := True;
      try
        if LeType in [0, 1, 2] then
        begin
          try
            for I := 0 to ListeReplication.Count - 1 do
            begin
              repli := TLesreplication(ListeReplication[I]);

              try
                // Vérification du REPL_LOG
                Dm_LaunchMain.Dtb_Ginkoia.Close;
                Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := repli.PlaceBase;
                Dm_LaunchMain.Dtb_Ginkoia.Open;

                Log.Log('LaunchV7_Frm', 'ReplicationAutomatique', 'Log', 'select RDB$RELATION_FIELDS (avant).', logDebug, True, 0, ltLocal);

                IB_Divers.Close;
                IB_Divers.SQL.Clear;
                IB_Divers.SQL.Text := 'SELECT count(*) FROM RDB$RELATION_FIELDS WHERE RDB$BASE_FIELD IS NULL AND RDB$RELATION_NAME = ''REPL_LOG''';
                IB_Divers.Open;

                Log.Log('LaunchV7_Frm', 'ReplicationAutomatique', 'Log', 'select RDB$RELATION_FIELDS (après).', logDebug, True, 0, ltLocal);

                if IB_Divers.Fields[0].AsInteger > 0 then
                begin
                  Log.Log('LaunchV7_Frm', 'ReplicationAutomatique', 'Log', 'select REPL_LOG (avant).', logDebug, True, 0, ltLocal);

                  IB_Divers.Close;
                  IB_Divers.SQL.Clear;
                  IB_Divers.SQL.Text := 'SELECT count(*) FROM REPL_LOG';
                  IB_Divers.Open;

                  Log.Log('LaunchV7_Frm', 'ReplicationAutomatique', 'Log', 'select REPL_LOG (après).', logDebug, True, 0, ltLocal);
                  iNbReplLog := IB_Divers.Fields[0].AsInteger;
                  Log.Log('LaunchV7_Frm', 'ReplicationAutomatique', 'Log', 'update GENBASES (avant).', logDebug, True, 0, ltLocal);

                  IB_Divers.Close;
                  IB_Divers.SQL.Clear;
                  IB_Divers.SQL.Text := 'UPDATE GENBASES SET BAS_REPLOG = ' + IntToStr(iNbReplLog) + ' WHERE BAS_ID = ' + IntToStr(IdBase0);
                  IB_Divers.ExecSQL;

                  Log.Log('LaunchV7_Frm', 'ReplicationAutomatique', 'Log', 'update GENBASES (après).', logDebug, True, 0, ltLocal);
                  Log.Log('LaunchV7_Frm', 'ReplicationAutomatique', 'Log', 'execute procedure PR_UPDATEK (avant).', logDebug, True, 0, ltLocal);

                  IB_Divers.Close;
                  IB_Divers.SQL.Clear;
                  IB_Divers.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(' + IntToStr(IdBase0) + ', 0)';
                  IB_Divers.ExecSQL;

                  Log.Log('LaunchV7_Frm', 'ReplicationAutomatique', 'Log', 'execute procedure PR_UPDATEK (après).', logDebug, True, 0, ltLocal);
                end;
                IB_Divers.Close;
              except
                on E: Exception do
                begin
                  Log.Log('LaunchV7_Frm', 'ReplicationAutomatique', 'Log', E.Message, logError, True, 0, ltLocal);
                end;
              end;

              bTestVersion := True;
              bVersionError := False;
              if (sAdresseWS = '') or (sDatabaseWS = '') then
              begin
                bTestVersion := False;
              end;

              if bTestVersion then
              begin
                // Tentative de récupération de jetons
                Ajoute('Serveur de réplication :  ' + repli.URLDISTANT, 0);
                sAdresse := StringReplace(repli.URLDISTANT, '/DelosQPMAgent.dll', sAdresseWS, [rfReplaceAll, rfIgnoreCase]);
                Ajoute('Serveur de jeton :  ' + sAdresse, 0);
                PathLogRio := repli.PlaceEai + 'RESULT\Jeton\';
                ForceDirectories(PathLogRio);

                Ajoute('Logs RIO dans : ' + PathLogRio, 0, True);
                // Récup version
                bTestVersion := GetVersionReTry(sAdresse, sDatabaseWS, sVersionEnCours, bVersionError);
              end;

              // Version OK, on réplique
              if bTestVersion then
              begin
                // ------------------ Réplication ------------------
                Result := Replication;
                if not (Result) then
                  BREAK;
              end
              else
              begin
                repliOk := False;
                Result := False;

                if bVersionError then
                  taskReplication.Error := 'Version : Erreur de connexion au serveur distant'
                else
                  taskReplication.Error := 'Version du serveur réplicant différente de la version locale';

                // Event(repli.PlaceBase, CstUneReplication, repliOk, Now - DebutRepli);
              end;

              // Ajout du contrôle des k_version avant le verif car vérif peut être long (pour éviter les sauts de réplication).
              if (not (LeType = 1)) and repliOk then
              begin
                // Si K oubliés.
                if ControleKVersion(repli.PlaceBase) > 0 then
                begin
                  // Re-réplication pour traiter les K oubliés.
                  Replication;
                end;
              end;
            end;

            if (not isPortableSynchro) and (not vSynchroCaisse.Enabled) then
            begin
              if (not Manuelle) or (ForcerLaMaj) then
              begin
                startVerification(True, False);
              end;
            end;

            if Connecte then
            begin
              Ajoute(DateTimeToStr(Now) + '   ' + 'Deconnexion d''internet', 0);
              Deconnexion;
              Connecte := False;
              // Event(LaBase0, CstConnexionGlobal, Result, Now - tempsReplication);
            end;

          finally
            try
              StopPing;
              if Connecte then
              begin
                Ajoute(DateTimeToStr(Now) + '   ' + 'Deconnexion d''internet', 0);
                Deconnexion;
                // Connecte := false;
                // Event(LaBase0, CstConnexionGlobal, Result, Now - tempsReplication);
              end;
            except
            end;
          end;
          Connectionencours := NIL;
        end;
      finally
        if (bRecalcul) then
        begin
          for I := 0 to ListeReplication.Count - 1 do
          begin
            repli := TLesreplication(ListeReplication[I]);

            // on fait le recalcul après avoir controlé les K pour qu'ils les prennent en compte et que la réplic après k ne chevauche pas une réplic d'un autre site (si recalcul long)
            Ajoute(DateTimeToStr(Now) + '   ' + 'Recalcul de la Base ' + repli.PlaceBase, 0);
            recalculeTriger(repli.PlaceBase, True, Result);
          end;
        end
        else
          Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de recalcul de la Base ' + repli.PlaceBase + ' ni de contrôle et traitement des K oubliés', 0);
      end;
    finally
      Enabled := True;
      MapGinkoia.Launcher := False;

      // Mise à jour des informations de réplication
      Event(LaBase0, CREPLICATIONOK, repliOk, Now - debut);
      if repliOk then
        Event(LaBase0, CLASTREPLIC, True, Now - debut);
      // Mise à jour des informations de réplication plateforme

      if bReplicPlateforme then
      begin
        Event(LaBase0, CPFOK, bReferencementOK, finPF - debutPF);
        if bReferencementOK then
          Event(LaBase0, CLASTPF, True, finPF - debutPF);
      end;

      DoEventStatus;
    end;

    if (isPortableSynchro) or (vSynchroCaisse.Enabled) then
    begin
      EXIT;
    end;

    FileRestart.setBackupRestore(False);

    if not (H1 and H2) then // une seul réplication
    begin
      if (EtatBackup = 2) or (EtatBackup = 1) then
      begin
        FileRestart.setBackupRestore(True);
      end;
    end
    else if Derniere and (EtatBackup = 2) then
    begin
      FileRestart.setBackupRestore(True);
    end
    else if not Derniere and (EtatBackup = 1) then
    begin
      FileRestart.setBackupRestore(True);
    end;

    try
      RepliEnCours := False;
      if ((not Manuelle) or (ForcerLaMaj)) and not (PasDeVerifACauseDeSynchro) then
      begin
        startVerification(False, True);
      end;
    except
      on E: Exception do
        Ajoute('Block Verification : ' + E.Message, 0);
    end;


    // Attente de la fin de Verification

    if MapGinkoia.Verifencours then
    begin
      Ajoute('Attente de la fin de Verification ...', 0);
      while MapGinkoia.Verifencours do
      begin
        Sleep(1000);
      end;
    end;

    Ajoute('Verification terminé sans arrêter le Launcher.', 0);

    // Pas de mise a jour par vérification : on annule l'ordre au restart
    FileRestart.setBackupRestore(False);

    sRepertoireDestination := '';
    if GetParamInteger(11, 60, FBasId) = 1 then
      sRepertoireDestination := GetParamString(11, 60, FBasId);


    // on arrête les timers pendants le traitement puis on les relance
    try
      //TimerOnOff(TimerOff);

         // Mode normal (attente d'une heure).
      Ajoute('Début exécution NettoieGinkoia.');
      Log.Log('Main', FBasGuid, 'Log', 'Debut de execution Nettoie', logInfo, True, 0, ltLocal);

      if ExecNettoieGinkoia(3600, sRepertoireDestination, FBasDossier, FBasGuid) then
        Ajoute('Fin exécution NettoieGinkoia.')
      else
        Ajoute('Fin exécution NettoieGinkoia [processus interrompu].');

      Log.Log('Main', FBasGuid, 'Log', 'Fin de execution Nettoie', logInfo, True, 0, ltLocal);
    finally
      //TimerOnOff(TimerOn);
    end;

    try
      if (not Manuelle) then
      begin
        if not (H1 and H2) then // une seul réplication
        begin
          if (EtatBackup = 2) or (EtatBackup = 1) then
          begin
            LancementBackup;
          end;
        end
        else if Derniere and (EtatBackup = 2) then
        begin
          LancementBackup;
        end
        else if not Derniere and (EtatBackup = 1) then
        begin
          LancementBackup;
        end;
      end;
    except
      on E: Exception do
        Ajoute('Block Backup : ' + E.Message, 0);
    end;
  finally
    ReplicOk := Result;
    RepliEnCours := False;
    taskReplication.Running := False;
    updateButtons;

    try
      // Dm_LaunchEvent.Data_Evt.Close;
      Dm_LaunchEvent.CloseOpenConnexion();
    except
    end;
    // Ouvrir le laucher à la fin de la réplication
    Hide;
    FormStyle := FsStayOnTop;
    Show;
    WindowState := wsNormal;

    Application.ProcessMessages;
    FormStyle := FsNormal;
    showHideLog(False);
  end;
  // on récupére les espaces disques disponible pour l'archivage et la base à chaque fin de réplication automatique
  diskSpace(FBasId);
end;

procedure TFrm_LaunchV7.MajHDebHFinReplicTpsReel;
begin
  hDebReplicJourna := Trunc(Now) + Frac(hDebReplicJourna);
  // Heure de début de réplication
  hFinReplicJourna := Trunc(Now) + Frac(hFinReplicJourna);
  // Heure de fin de réplic

  if hDebReplicJourna > hFinReplicJourna then
    // La fin est avant le début, donc fin le lendemain
    hFinReplicJourna := hFinReplic + 1;
end;

function TFrm_LaunchV7.ReplicTpsReelToDo: Boolean;
begin
  MajHDebHFinReplicTpsReel;

  Result := False;
  try
    if ((not bReplicTpsReelActif) or (hNextReplicJourna = 0)) then
    begin
      EXIT;
    end;

    if ((Now < hDebReplicJourna) or (Now > hFinReplicJourna)) then
    begin
      EXIT;
    end;

    if (Now < hNextReplicJourna) then
    begin
      EXIT;
    end;

    if ((MapGinkoia.Backup) or (RepliEnCours)) then
    begin
      EXIT;
    end;

    Result := True; // C'est l'heure de la réplic journée.
  except
    Result := False;
  end;
end;

// ---------------------------------------------------------------
// Recherche une heure pour lancer la réplication
// ---------------------------------------------------------------

function TFrm_LaunchV7.TrouverlabonneHeure: Boolean;
var
  LeTps: Integer;
  Ok: Boolean;
  Hh, Mm, Ss, Dd: Word;
  I: Integer;
begin
  Result := False;
  while MapGinkoia.Backup do
  begin
    Application.ProcessMessages;
    Sleep(10000);
  end;
  decodeTime(Now, Hh, Mm, Ss, Dd);
  if Hh >= 7 then
    EXIT;
  Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := LaBase0;
  try
    Dm_LaunchMain.Dtb_Ginkoia.Open;
  except
    Ajoute('Problème connexion à la base trouve la bonne heure ', 0, True);
    raise;
  end;

  try
    Dm_LaunchMain.Tra_Ginkoia.StartTransaction;
    repeat
      Ok := True;

      Log.Log('LaunchV7_Frm', 'TrouverlabonneHeure', 'Log', 'Ib_TousHorraire (avant).', logDebug, True, 0, ltLocal);
      Ib_TousHorraire.Open;
      Log.Log('LaunchV7_Frm', 'TrouverlabonneHeure', 'Log', 'Ib_TousHorraire (après).', logDebug, True, 0, ltLocal);

      while not Ib_TousHorraire.Eof do
      begin
        if Ib_TousHorraireLAU_H1.AsInteger = 1 then
        begin
          LeTps := Abs(Trunc(Ib_TousHorraireLAU_HEURE1.AsDateTime) - Trunc(Now));
          if LeTps < 0.0104 then // 15 min
          begin
            Ok := False;
            BREAK;
          end;
        end;
        if Ib_TousHorraireLAU_H2.AsInteger = 1 then
        begin
          LeTps := Abs(Trunc(Ib_TousHorraireLAU_HEURE2.AsDateTime) - Trunc(Now));
          if LeTps < 0.0104 then // 15 min
          begin
            Ok := False;
            BREAK;
          end;
        end;
        Ib_TousHorraire.Next;
      end;
      Ib_TousHorraire.Close;
      if not Ok then
      begin
        for I := 1 to 30 do // 5 Min
        begin
          Sleep(10000);
          Application.ProcessMessages;
        end;
        decodeTime(Now, Hh, Mm, Ss, Dd);
        if Hh >= 7 then
          EXIT;
      end;
    until Ok;
  finally
    Dm_LaunchMain.Dtb_Ginkoia.Close;
  end;
end;

procedure TFrm_LaunchV7.Btn_AProposClick(Sender: TObject);
begin
//  GFixBase(LaBase0);

  AboutDlg_Main.Description := 'Interbase v.' + FIBServerVersion;
  AboutDlg_Main.Execute;
end;

procedure TFrm_LaunchV7.Btn_CaissesSecClick(Sender: TObject);
var
  vErr: string;
begin
  if not MapGinkoia.Launcher then
  begin
    MapGinkoia.Launcher := True;
    try
      // vérifier si mono base
      Dm_LaunchMain.Dtb_Ginkoia.Close;
      Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := LaBase0;
      Dm_LaunchMain.Dtb_Ginkoia.Open;

      Log.Log('LaunchV7_Frm', 'Btn_CaissesSecClick', 'Log', 'Que_Bases (avant).', logDebug, True, 0, ltLocal);
      Que_Bases.Close;
      Que_Bases.Open;
      Log.Log('LaunchV7_Frm', 'Btn_CaissesSecClick', 'Log', 'Que_Bases (après).', logDebug, True, 0, ltLocal);

      if Que_Bases.Eof then
      begin
        MessageDlg('Base unique, pas de synchronisation possible.', mtInformation, [mbOk], 0);
      end
      else
      begin
        Dm_LaunchV7.ConnectDataBase(LaBase0, vErr);
        // si serveur afficher la liste des portables paramétré pour une synchro avec ce serveur
        ExecuteParamCaisseSync();

        Dm_LaunchV7.ClosedataBase();
        // actualiser les boutons en fonction des mises à jour
        boutonSynchro(1);
      end;
      Dm_LaunchMain.Dtb_Ginkoia.Close;

      InitialiseLaunch();
    finally
      MapGinkoia.Launcher := False;
    end;
  end;
end;

procedure TFrm_LaunchV7.Btn_EnvoiClick(Sender: TObject);
var
  iLoop: Integer;
  debut: TDateTime;
  Ok: Boolean;
begin
  iLoop := GetLoop;
  if iLoop > 0 then
  begin
    Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Manuelle que l''envoi en LOOP', 0);
    debut := Now;
    Ok := ReplicationAutomatique(True, False, 1, iLoop, cbRecalculTrigger.Checked);

    if Ok then
    begin
      Ajoute(DateTimeToStr(Now) + '   ' + 'Envoi en LOOP Réussie', 0);
      MessMAJ1 := '';
    end
    else
      Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);

    Ajoute('', 0);
  end
  else
  begin
    Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Manuelle que l''envoi', 0);
    debut := Now;
    Ok := ReplicationAutomatique(True, False, 1, 0, cbRecalculTrigger.Checked);

    if Ok then
    begin
      Ajoute(DateTimeToStr(Now) + '   ' + 'Envoie Réplication Réussie', 0);
      MessMAJ1 := '';
    end
    else
      Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);

    Ajoute('', 0);
  end;

end;

procedure TFrm_LaunchV7.ActiveOnglet(pTabSheet: TAdvOfficePage);
var
  aNumPage: Integer;
  I: Integer;
  b: Boolean;
begin
  PgC_Main.ActivePage := pTabSheet;

  aNumPage := pTabSheet.PageIndex;

  for I := 0 to PgC_Main.AdvPageCount - 1 do
  begin
    b := (I = aNumPage);
    PgC_Main.AdvPages[I].visible := b;
    PgC_Main.AdvPages[I].Enabled := b;
    PgC_Main.AdvPages[I].TabVisible := b;
  end;
end;

procedure TFrm_LaunchV7.Btn_RetourClick(Sender: TObject);
begin
  ActiveOnglet(Tab_Affiche);
end;

procedure TFrm_LaunchV7.AfficherleLauncher1Click(Sender: TObject);
begin
  Show;
end;

procedure TFrm_LaunchV7.QuitterleLauncher1Click(Sender: TObject);
begin
  Dm_LaunchMain.setFermerEtatLauncher();
  Commit;
  QuitLauncher;
end;

procedure TFrm_LaunchV7.QuitLauncher;
begin
  FCanClose := True;
  Close;
end;

procedure TFrm_LaunchV7.Quitter1Click(Sender: TObject);
begin
  QuitLauncher;
end;

procedure TFrm_LaunchV7.Cacher1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrm_LaunchV7.Tray_LaunchDblClick(Sender: TObject);
begin
  Show;
  FormStyle := FsStayOnTop;
  Application.ProcessMessages;
  FormStyle := FsNormal;
end;

procedure TFrm_LaunchV7.RecalcStockClick(Sender: TObject);
var
  debut: TDateTime;
  Ok: Boolean;
begin
  Ajoute(DateTimeToStr(Now) + '   ' + 'Recalcul manuel des triggers', 0);
  debut := Now;
  Ok := ReplicationAutomatique(True, False, 3, 0);

  if Ok then
    Ajoute(DateTimeToStr(Now) + '   ' + 'Recalcul Réussi', 0)
  else
    Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le Recalcul ', 0);

  Ajoute('', 0);
end;

function TFrm_LaunchV7.Lancementdesreferencements(Num: Integer; Rep: TLesreplication): Boolean;
var
  I, j: Integer;
  // FC 16/06/2009 : Migration, remplacement du TSimpleHTTP par TidHTTP
  ResultBody: string;
  TslResult: TStringList;
  tsSource: TStrings;
  S1: string;
  S: string;
  Ref: TLesReference;
  tbl, Chp: string;
  tsl: TStringList;
  Prov: string;
  subs: string;
  sMessProvSub: string;
  sPathLogsPF, sUrlEncours: string;
  // FC : 12/2011 : Rendre bloquant les ref
  Temps: ttimestamp;
begin
  MessReplicPlateforme := '';
  // if (bReplicPlateforme) then
  // Result := False
  // else
  Result := True;

  sPathLogsPF := extractFilePath(Application.exename) + 'Logs\PF-RA\';
  ForceDirectories(sPathLogsPF);

  try
    tsl := TStringList.Create;

    try
      for I := 0 to ListeReference.Count - 1 do
      begin
        Prov := '';
        subs := '';
        if TLesReference(ListeReference[I]).Place = Num then
        begin
          Ref := TLesReference(ListeReference[I]);
          Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement référencement ' + Ref.Ordre, 0);

          tsSource := TStringList.Create;
          try
            tsSource.Clear;
            for j := 0 to Ref.LesLig.Count - 1 do
            begin
              sMessProvSub := '';
              S := TLesReferenceLig(Ref.LesLig[j]).Param;
              if Pos('=', S) > 0 then
              begin
                S1 := Copy(S, Pos('=', S) + 1, 255);
                S := Copy(S, 1, Pos('=', S) - 1);
                if Copy(S1, 1, 1) = '?' then
                begin
                  Delete(S1, 1, 1);
                  if Pos('.', S1) > 0 then
                  begin
                    tbl := Copy(S1, 1, Pos('.', S1) - 1);
                    Chp := Copy(S1, Pos('.', S1) + 1, 255);
                    DataPass.Close;
                    DataPass.DatabaseName := Rep.PlaceBase;
                    DataPass.Open;
                    Tranpass.Active := True;
                    Log.Log('LaunchV7_Frm', 'Lancementdesreferencements', 'Log', 'select ' + tbl + ' (avant).', logDebug, True, 0, ltLocal);

                    IBQue_Pass.SQL.Clear;
                    IBQue_Pass.SQL.Add('Select ' + Chp);
                    IBQue_Pass.SQL.Add('FROM ' + tbl + ' Join k on (K_ID=' + Copy(Chp, 1, 4) + 'ID and K_ENABLED=1)');
                    IBQue_Pass.Open;

                    Log.Log('LaunchV7_Frm', 'Lancementdesreferencements', 'Log', 'select ' + tbl + ' (après).', logDebug, True, 0, ltLocal);

                    while not IBQue_Pass.Eof do
                    begin
                      if Trim(IBQue_Pass.Fields[0].AsString) <> '' then
                        tsl.Add(S + '=' + IBQue_Pass.Fields[0].AsString);
                      IBQue_Pass.Next;
                    end;
                    IBQue_Pass.Close;
                    DataPass.Close;
                  end;
                end
                else
                begin
                  if UpperCase(S) = 'PROVIDER' then
                    Prov := S1;
                  if (UpperCase(S) = 'SUBSCRIBER') or (UpperCase(S) = 'SUBSCRIPTION') then
                    subs := S1;
                  tsSource.Add(S + '=' + S1);
                end;
              end;
            end;

            if tsl.Count > 0 then
            begin
              ForceDirectories(Rep.PlaceEai + 'RESULT\PUSH\');

              for j := 0 to tsl.Count - 1 do
              begin
                S := tsl[j];
                S1 := Copy(S, Pos('=', S) + 1, 255);
                S := Copy(S, 1, Pos('=', S) - 1);
                tsSource.Add(S + '=' + S1);
                if UpperCase(S) = 'PROVIDER' then
                  Prov := S1;
                if (UpperCase(S) = 'SUBSCRIBER') or (UpperCase(S) = 'SUBSCRIPTION') then
                  subs := S1;
                Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement avec ' + S + ' = ' + S1, 0);
                Temps := DateTimeToTimeStamp(Now);

                MyHttp := GetTIdHttp('', '', 900000);

                IdLogFile1.fileName := sPathLogsPF + Format('LogId-1-%s.txt', [StringReplace(S + '-' + S1, '=', '-', [rfReplaceAll])]);
                if not ModeDebug then
                  if FileExists(IdLogFile1.fileName) then
                    DeleteFile(IdLogFile1.fileName);

                MyHttp.Intercept := IdLogFile1;
                IdLogFile1.Active := True;

                try
                  // Ajout du / s'il manque à la fin de l'url
                  sUrlEncours := Ref.Url;
                  if Copy(Trim(sUrlEncours), length(Trim(sUrlEncours)), 1) <> '/' then
                    sUrlEncours := sUrlEncours + '/';

                  MyHttp.ReadTimeout := 1800000; // 900 sec (15 min)
                  ResultBody := MyHttp.Get(SourceToURL(sUrlEncours + Ref.Ordre, tsSource));
                except
                  on E: Exception do
                  begin
                    ResultBody := 'ERROR - Exception sur le get : ' + E.Message;
                  end;
                end;
                IdLogFile1.Active := False;
                MyHttp.Free;

                if bReplicPlateforme then
                begin
                  TslResult := TStringList.Create;
                  try
                    TslResult.Text := ResultBody;
                    if (Pos('ERROR', UpperCase(TslResult.Text)) > 0) or (Pos('LOGITEM', UpperCase(TslResult.Text)) > 0) then
                    begin
                      TslResult.SaveToFile(Rep.PlaceEai + 'RESULT\PUSH\' + IntToStr(Temps.Date) + '-' + IntToStr(Temps.Time) + '-' + IntToStr(I + 1) + '.Xml');
                      Result := False;
                      MessMAJ1 := MessMAJ1 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur réplication plateforme ' + S + ' = ' + S1;
                      MessReplicPlateforme := DateTimeToStr(Now) + ' Problème sur réplication plateforme ' + S + ' = ' + S1;
                      taskReplicationPF.Error := ' Problème sur réplication plateforme ' + S + ' = ' + S1;
                      BREAK;
                    end
                    else
                      Result := True;
                  finally
                    TslResult.Free;
                  end;
                end;
              end;
              tsl.Clear;
            end
            else
            begin
              if Prov <> '' then
              begin
                Ajoute(DateTimeToStr(Now) + '   ' + 'Référencement  Provider=' + Prov, 0);
                sMessProvSub := 'Provider = ' + Prov;
              end;
              if subs <> '' then
              begin
                Ajoute(DateTimeToStr(Now) + '   ' + 'Référencement  Suscriber=' + subs, 0);
                sMessProvSub := 'Suscriber = ' + subs;
              end;
              MyHttp := GetTIdHttp('', '', 900000);
              IdLogFile1.fileName := sPathLogsPF + Format('LogId-2-%s.txt', [StringReplace(sMessProvSub, '=', '-', [rfReplaceAll])]);
              if not ModeDebug then
                if FileExists(IdLogFile1.fileName) then
                  DeleteFile(IdLogFile1.fileName);

              MyHttp.Intercept := IdLogFile1;
              IdLogFile1.Active := True;

              try
                // Ajout du / s'il manque à la fin de l'url
                sUrlEncours := Ref.Url;
                if Copy(Trim(sUrlEncours), length(Trim(sUrlEncours)), 1) <> '/' then
                  sUrlEncours := sUrlEncours + '/';

                MyHttp.ReadTimeout := 1800000; // 900 sec (15 min)
                ResultBody := MyHttp.Get(SourceToURL(sUrlEncours + Ref.Ordre, tsSource));
              except
                on E: Exception do
                begin
                  ResultBody := 'ERROR - Exception sur le get : ' + E.Message;
                end;
              end;
              IdLogFile1.Active := False;
              MyHttp.Free;

              if bReplicPlateforme then
              begin
                TslResult := TStringList.Create;
                try
                  TslResult.Text := ResultBody;
                  if (Pos('ERROR', UpperCase(TslResult.Text)) > 0) or (Pos('LOGITEM', UpperCase(TslResult.Text)) > 0) then
                  begin
                    TslResult.SaveToFile(Rep.PlaceEai + 'RESULT\PUSH\' + IntToStr(Temps.Date) + '-' + IntToStr(Temps.Time) + '-' + IntToStr(I + 1) + '.Xml');
                    Result := False;

                    MessMAJ1 := MessMAJ1 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur réplication plateforme ' + sMessProvSub + ' / ' + S + ' = ' + S1;
                    MessReplicPlateforme := DateTimeToStr(Now) + ' Problème sur réplication plateforme ' + sMessProvSub + ' / ' + S + ' = ' + S1;
                    taskReplicationPF.Error := ' Problème sur réplication plateforme ' + sMessProvSub + ' / ' + S + ' = ' + S1;
                    BREAK;
                  end
                  else
                    Result := True;
                finally
                  TslResult.Free;
                end;
              end;
            end;
          finally
            tsSource.Free;
          end;
        end;
      end;
    finally
      tsl.Free;
    end;
  except
    // ne pas blocker la réplication
    Ajoute(DateTimeToStr(Now) + '   ' + 'Exception lors du référencement', 0);
    if bReplicPlateforme then
    begin
      Result := False;
    end;
  end;
end;

function TFrm_LaunchV7.LanceRefPF(ARepli: TLesreplication; var aSuccess: Boolean): Boolean;
var
  sAdresse: string; // Adresse de la lame plateforme
  sResult: string; // Résultat du GetToken
  I, j: Integer; // Variable de boucle
  RefEnCours: TLesReference; // Référencement en cours de traitement
  sMessProvSub: string; // Message à afficher : Provider ou subscription
  sRRLParam: string; // Contient le RRL_PARAM
  sParamPrm: string; // Contient ce qui est coté gauche du = dans RRL_PARAM
  sValeurPrm: string; // Contient ce qui est coté droit du = dans RRL_PARAM
  iPosEgal: Integer; // Position du signe = dans la chaine de paramètre

  sProv: string; // Provider en cours
  sSubs: string; // Subscription en cours

  tsSource: TStrings; // Contient la liste des paramètres à ajouter à l'URL
  TslResult: TStrings;
  // Pour sauver le résultat de la réplic dans dossier RESULT
  sResultBody: string; // Contient le résultat de la réplic PF

  Temps: ttimestamp; // Timestamp pour le temps de réplication

  iCountTry: Integer;
  sPathLogsPF, sUrlEncours: string;
  Token: TTokenManager;
begin
  aSuccess := False;
  Result := True;
  // Si pas de référencement alors on quitte
  if ListeRefPF.Count = 0 then
    EXIT;

  sPathLogsPF := extractFilePath(Application.exename) + 'Logs\PF\';
  ForceDirectories(sPathLogsPF);

  sAdresse := sUrlPlateforme + sAdresseWS;

  taskReplicationPF.Running := True;
  updateButtons;
  Token := TTokenManager.Create; // Prise du jeton
  Token.tryGetToken(sAdresse, sDatabasePlateforme, sSenderPlateforme, 5, iDelaiEssai);
  try
    if Token.Acquired then
    begin
      Result := False;
      Ajoute('Token acquis.', 0); // Jeton acquis.
      tsSource := TStringList.Create;

      try
        // Envoie de le référencement PF
        for I := 0 to ListeRefPF.Count - 1 do
        begin
          RefEnCours := TLesReference(ListeRefPF[I]);
          Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement référencement ' + RefEnCours.Ordre, 0);

          // Création de l'ordre avec les lignes de ref
          sMessProvSub := '';
          tsSource.Clear;
          for j := 0 to RefEnCours.LesLig.Count - 1 do
          begin
            sRRLParam := TLesReferenceLig(RefEnCours.LesLig[j]).Param;
            iPosEgal := Pos('=', sRRLParam);

            if iPosEgal > 0 then
            begin
              sParamPrm := Copy(sRRLParam, 1, Pos('=', sRRLParam) - 1);
              // Provider ou subscription ou Database
              sValeurPrm := Copy(sRRLParam, Pos('=', sRRLParam) + 1, 255); //

              if UpperCase(sParamPrm) = 'PROVIDER' then
              begin
                sProv := sValeurPrm;
                sMessProvSub := 'Provider = ' + sProv;
              end
              else if (UpperCase(sParamPrm) = 'SUBSCRIBER') or (UpperCase(sParamPrm) = 'SUBSCRIPTION') then
              begin
                sSubs := sValeurPrm;
                sMessProvSub := 'Suscriber = ' + sSubs;
              end;

              tsSource.Add(sRRLParam);
            end;
          end;

          Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication plateforme ' + sMessProvSub, 0);
          MyHttp := GetTIdHttp('', '', 900000);

          IdLogFile1.fileName := sPathLogsPF + Format('LogId-%s.txt', [StringReplace(sMessProvSub, '=', '-', [rfReplaceAll])]);
          if not ModeDebug then
            if FileExists(IdLogFile1.fileName) then
              DeleteFile(IdLogFile1.fileName);

          MyHttp.Intercept := IdLogFile1;
          IdLogFile1.Active := True;
          try
            // Ajout du / s'il manque à la fin de l'url
            sUrlEncours := RefEnCours.Url;

            if Copy(Trim(sUrlEncours), length(Trim(sUrlEncours)), 1) <> '/' then
              sUrlEncours := sUrlEncours + '/';

            MyHttp.ReadTimeout := 1800000; // 900 sec (15 min)
            sResultBody := MyHttp.Get(SourceToURL(sUrlEncours + RefEnCours.Ordre, tsSource));
          except
            on E: Exception do
            begin
              sResultBody := 'ERROR - Exception sur le get : ' + E.Message;
            end;
          end;

          IdLogFile1.Active := False;
          MyHttp.Free;

          if (Pos('ERROR', UpperCase(sResultBody)) > 0) or (Pos('LOGITEM', UpperCase(sResultBody)) > 0) then
          begin
            TslResult := TStringList.Create;
            try
              Temps := DateTimeToTimeStamp(Now());
              TslResult.Text := sResultBody;
              TslResult.SaveToFile(ARepli.PlaceEai + 'RESULT\PUSH\' + IntToStr(Temps.Date) + '-' + IntToStr(Temps.Time) + '-' + IntToStr(I + 1) + '.Xml');

              Result := False;
              aSuccess := False;

              MessMAJ1 := MessMAJ1 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur réplication plateforme ' + sMessProvSub;
              MessReplicPlateforme := DateTimeToStr(Now) + ' Problème sur réplication plateforme ' + sMessProvSub;
              taskReplicationPF.Error := 'Problème sur réplication plateforme ' + sMessProvSub;
              BREAK;
            finally
              TslResult.Free;
            end;
          end
          else
          begin
            aSuccess := True;
            Result := True;
          end;
        end; // For

        if aSuccess then
          Ajoute(DateTimeToStr(Now) + '   ' + 'Synchronisation avec la plateforme réussie', 0)
        else
          Ajoute(DateTimeToStr(Now) + '   ' + 'Synchronisation avec la plateforme échouée', 0);

      finally
        tsSource.Free;
      end;
    end
    else
    begin
      // Echec lors de la prise du jeton
      Result := True;
      taskReplicationPF.Error := 'Prise de jeton impossible : ' + Token.GetReasonString;

      case Token.Reason of
        TOKEN_OK:
          Ajoute('Jeton Plateforme : Ok', 0);
        TOKEN_OQP:
          Ajoute('Jeton Plateforme : Occupé', 0);
        TOKEN_ERR_CNX:
          Ajoute('Jeton Plateforme : Erreur de connexion à la base', 0);
        TOKEN_ERR_PRM:
          Ajoute('Jeton Plateforme : Erreur de paramètrage', 0);
        TOKEN_ERR_HTTP:
          Ajoute('Jeton Plateforme : Erreur de connexion', 0);
        TOKEN_ERR_INTERNAL:
          Ajoute('Jeton Plateforme : Erreur interne', 0);
        TOKEN_ABORTED:
          Ajoute('Jeton Plateforme : Annulé', 0);
        TOKEN_NEVER:
          Ajoute('Jeton Plateforme : jamais demandé', 0);
      end;
    end;

  finally
    Token.Free; // Libération du jeton si besoin
    Ajoute('Token libéré', 0);

    taskReplicationPF.Running := False;
    DoEventStatus;
  end;
end;

procedure TFrm_LaunchV7.Btn_RecepClick(Sender: TObject);
var
  iLoop: Integer;
  debut: TDateTime;
  Ok: Boolean;
begin
  if (isPortableSynchro) then
  begin
    Ajoute('', 1);
    Ajoute(DateTimeToStr(Now) + '   ' + 'Réception interdite sur une base synchronisée', 0);
    EXIT;
  end;

  if (BaseSauvegarde) then
  begin
    Ajoute('', 1);
    Ajoute(DateTimeToStr(Now) + '   ' + 'Réception interdite sur une base sauvegarde', 0);
    EXIT;
  end;

  iLoop := GetLoop;
  if iLoop = 0 then
  begin
    Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Manuelle que la réception', 0);
    debut := Now;
    Ok := ReplicationAutomatique(True, False, 2, 0, cbRecalculTrigger.Checked);

    if Ok then
    begin
      Ajoute(DateTimeToStr(Now) + '   ' + 'Réception Réplication Réussie', 0);
      MessMAJ2 := '';
    end
    else
    begin
      Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);
    end;

    Ajoute('', 0);
  end
  else
  begin
    Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Manuelle que la réception en LOOP', 0);
    debut := Now;

    Ok := ReplicationAutomatique(True, False, 2, iLoop, cbRecalculTrigger.Checked);

    if Ok then
    begin
      Ajoute(DateTimeToStr(Now) + '   ' + 'Réception en LOOP Réussie', 0);
      MessMAJ2 := '';
    end
    else
    begin
      Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);
    end;

    Ajoute('', 0);

  end;
end;

procedure TFrm_LaunchV7.Btn_ReferClick(Sender: TObject);
var
  FRM_Reference: TFRM_Reference;
  Ok: Boolean;
  RRL: TLesReferenceLig;
  RRE: TLesReference;
  I, j: Integer;
begin
  if not MapGinkoia.Launcher then
  begin
    MapGinkoia.Launcher := True;
    try
      Ok := False;
      Dm_LaunchMain.Dtb_Ginkoia.Close;
      try
        Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := LaBase0;
        try
          Dm_LaunchMain.Dtb_Ginkoia.Open;
        except
          Ajoute('Problème connexion à la base Referencement1Click ', 0, True);
          raise;
        end;
        Dm_LaunchMain.Tra_Ginkoia.StartTransaction;
        Ok := False;
        Application.CreateForm(TFRM_Reference, FRM_Reference);
        try
          Ok := FRM_Reference.Execute(ListeReference);
          if Ok then
          begin
            for I := 0 to ListeReference.Count - 1 do
            begin
              RRE := TLesReference(ListeReference[I]);
              if RRE.Supp then
              begin
                if RRE.Id <> -1 then
                  DeleteK(RRE.Id);
              end
              else if RRE.Id = -1 then
              begin
                RRE.Id := NouvelleClef;
                InsertK(RRE.Id, CstTblRRE);
                Log.Log('LaunchV7_Frm', 'Btn_ReferClick', 'Log', 'insert GENREPREFER (avant).', logDebug, True, 0, ltLocal);

                IB_Divers.SQL.Clear;
                IB_Divers.SQL.Add('INSERT INTO GENREPREFER');
                IB_Divers.SQL.Add(' (RRE_ID, RRE_POSITION, RRE_PLACE, RRE_URL, RRE_ORDRE, RRE_PF)');
                IB_Divers.SQL.Add(' VALUES');
                IB_Divers.SQL.Add(' (' + IntToStr(RRE.Id) + ',' + IntToStr(RRE.Position) + ',' + IntToStr(RRE.Place) + ',' + QuotedStr(RRE.Url) + ',' + QuotedStr(RRE.Ordre) + ',' + IntToStr(RRE.Plateforme) + ')');
                IB_Divers.ExecSQL;

                Log.Log('LaunchV7_Frm', 'Btn_ReferClick', 'Log', 'insert GENREPREFER (après).', logDebug, True, 0, ltLocal);
              end
              else if RRE.Change then
              begin
                ModifK(RRE.Id);
                Log.Log('LaunchV7_Frm', 'Btn_ReferClick', 'Log', 'update GENREPREFER (avant).', logDebug, True, 0, ltLocal);

                IB_Divers.SQL.Clear;
                IB_Divers.SQL.Add('UPDATE GENREPREFER');
                IB_Divers.SQL.Add('SET RRE_POSITION = ' + IntToStr(RRE.Position));
                IB_Divers.SQL.Add('    ,RRE_PLACE = ' + IntToStr(RRE.Place));
                IB_Divers.SQL.Add('    ,RRE_URL = ' + QuotedStr(RRE.Url));
                IB_Divers.SQL.Add('    ,RRE_ORDRE = ' + QuotedStr(RRE.Ordre));
                IB_Divers.SQL.Add('    ,RRE_PF = ' + IntToStr(RRE.Plateforme));
                IB_Divers.SQL.Add('WHERE RRE_ID = ' + EnStr(RRE.Id));
                IB_Divers.ExecSQL;

                Log.Log('LaunchV7_Frm', 'Btn_ReferClick', 'Log', 'update GENREPREFER (après).', logDebug, True, 0, ltLocal);
              end;
              for j := 0 to RRE.LesLig.Count - 1 do
              begin
                RRL := TLesReferenceLig(RRE.LesLig[j]);
                if RRE.Supp or RRL.Supp then
                begin
                  if RRL.Id <> -1 then
                    DeleteK(RRL.Id);
                end
                else if RRL.Id = -1 then
                begin
                  RRL.Id := NouvelleClef;
                  InsertK(RRL.Id, CstTblRRL);
                  Log.Log('LaunchV7_Frm', 'Btn_ReferClick', 'Log', 'insert GENREPREFERLIGNE (avant).', logDebug, True, 0, ltLocal);

                  IB_Divers.SQL.Clear;
                  with IB_Divers.SQL do
                  begin
                    Add('INSERT INTO GENREPREFERLIGNE');
                    Add('(RRL_ID, RRL_RREID, RRL_PARAM)');
                    Add('VALUES');
                    Add('(' + IntToStr(RRL.Id) + ',' + IntToStr(RRE.Id) + ',' + QuotedStr(RRL.Param) + ')');
                  end;
                  IB_Divers.ExecSQL;

                  Log.Log('LaunchV7_Frm', 'Btn_ReferClick', 'Log', 'insert GENREPREFERLIGNE (après).', logDebug, True, 0, ltLocal);
                end
                else if RRL.Change then
                begin
                  ModifK(RRL.Id);
                  Log.Log('LaunchV7_Frm', 'Btn_ReferClick', 'Log', 'update GENREPREFERLIGNE (avant).', logDebug, True, 0, ltLocal);

                  IB_Divers.SQL.Clear;
                  with IB_Divers.SQL do
                  begin
                    Add('UPDATE GENREPREFERLIGNE');
                    Add('SET RRL_PARAM = ' + EnStr(RRL.Param));
                    Add('WHERE RRL_ID = ' + EnStr(RRL.Id));
                  end;
                  IB_Divers.ExecSQL;

                  Log.Log('LaunchV7_Frm', 'Btn_ReferClick', 'Log', 'update GENREPREFERLIGNE (après).', logDebug, True, 0, ltLocal);
                end;
              end;
            end;
            Commit;
          end;
        finally
          FRM_Reference.release;
        end;
      finally
        Dm_LaunchMain.Tra_Ginkoia.Commit;
        Dm_LaunchMain.Dtb_Ginkoia.Close;
      end;
      if Ok then
      begin
        VerifChangeHorraire;
        InitialiseLaunch;
      end;

    finally
      MapGinkoia.Launcher := False;
    end;
  end;
end;

procedure TFrm_LaunchV7.Dtb_GinkoiaBeforeConnect(Sender: TObject);
begin
  if MapGinkoia.Backup then
    ABORT;
end;

procedure TFrm_LaunchV7.SetTimerIntervalReplicTpsReel(bReLitParam: Boolean = True);
// FC : 16/12/2008, Ajout du module réplic en journée
var
  Events: TEventHisto;
  hPrevReplic: TDateTime;
  hNextReplic: TDateTime;
  hNextPeriode: TDateTime;
  iNextPeriodeMS: Integer;
  DoCalc: Boolean;
  ia: Integer;
begin
  try
    DoCalc := True;
    hNextReplic := 0;

    if taskReplication.Running then
      EXIT; // pas de recalcul lorsque la replic est en cours

    // Relecture des paramètres
    if bReLitParam then
    begin
      Dm_LaunchMain.Dtb_Ginkoia.Close;
      Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := LaBase0;
      try
        Dm_LaunchMain.Dtb_Ginkoia.Open;
        MajParamReplicTpsReel();
      except
        on E: Exception do
        begin
          Ajoute('Problème connexion à la base ' + E.Message, 0, True);
          hNextReplicJourna := Now + (15 * OneMinute);
          DoCalc := False;
        end;
      end;
      Dm_LaunchMain.Dtb_Ginkoia.Close;
    end;

    if not bReplicTpsReelActif then
    begin
      hNextReplicJourna := 0;
      EXIT;
    end;

    if DoCalc then
    begin
      // Get previous replication time
      try
        Dm_LaunchEvent.CloseOpenConnexion();
        Events := GetEventInfos(LaBase0, CREPLICATIONOK);
        if not (Events.isEOF) then
          hPrevReplic := Events.HEV_DATE;
      except
        Ajoute('Impossible de récuperer l''heure de la précédente réplication ! ', 0, True);
        hPrevReplic := Now;
      end;

      Ajoute('Calcul réplication jour', 0);
      Ajoute('hPrevReplic      : ' + FormatDateTime('YYYYMMDD HHNNSS', hPrevReplic), 0, True);
      Ajoute('hDebReplicJourna : ' + FormatDateTime('YYYYMMDD HHNNSS', hDebReplicJourna), 0, True);
      Ajoute('hFinReplicJourna : ' + FormatDateTime('YYYYMMDD HHNNSS', hFinReplicJourna), 0, True);

      ia := Ceil((Now - (hPrevReplic + (5 * OneMinute))) / (iIntervaleTpsReel * OneMillisecond));
      if ia < 1 then
        ia := 1;

      hNextReplic := hPrevReplic + (iIntervaleTpsReel * OneMillisecond) * ia;

      if hNextReplic < hDebReplicJourna then
        hNextReplic := hDebReplicJourna;

      if (hNextReplic > hFinReplicJourna) then
      // La prochaine réplic prévue est hors interval
      begin
        hNextReplic := hDebReplicJourna + 1;
        // le lendemain au debut de l'interval
      end;

      Ajoute('hNextReplic      : ' + FormatDateTime('YYYYMMDD HHNNSS', hNextReplic), 0, True);

      hNextReplicJourna := hNextReplic;
    end;
  except
    Ajoute('Erreur lors du recalcul de l''heure de prochaine réplication journée', 0, True);
  end;

end;

procedure TFrm_LaunchV7.SetTimerIntervalReplicWeb;
// FC : 16/12/2008, Ajout du module réplic en journée
var
  hNextPeriode: TDateTime;
  iNextPeriodeMS: Integer;
begin
  // Bloc de calcul de l'intervale du timer
  try
    // Init random
    Randomize();

    // Est ce qu'on est en période de réplication (à 1h près)
    if ((hDebReplic - (1 / 24)) <= Now) and (Now <= hFinReplic) then
    begin
      // On set l'intervalle avec l'interval habituel + un temps aléatoire pour etaler sur la période les magasins
      // intervale + ou - 30 secondes
      Tim_ReplicWeb.Interval := iIntervale + Trunc(Random(30000));
      hNextReplicWeb := Now + (Tim_ReplicWeb.Interval / (24 * 60 * 60 * 1000))
    end
    else
    begin
      // On set l'intervalle hors réplic
      // on calcule le prochain lancement, pour mettre l'intervalle comme il faut
      if hDebReplic <= Now then
        hNextPeriode := ((hDebReplic + 1) - Now)
      else
        hNextPeriode := Now - hDebReplic;

      // On se met 10 minutes avant le prochain lancement prévu
      hNextPeriode := hNextPeriode - (10 / (24 * 60));

      // On transforme en millisecondes et on fait - 2h
      iNextPeriodeMS := Trunc(hNextPeriode * 24 * 60 * 60 * 1000) - (2 * 60 * 60 * 1000);

      if iNextPeriodeMS <= 0 then
        iNextPeriodeMS := 60 * 60 * 1000;

      // On set le prochain timer
      Tim_ReplicWeb.Interval := iNextPeriodeMS;

      hNextReplicWeb := Now + hNextPeriode;
    end;
  except
    on E: Exception do
    begin
      // En cas d'exception, on relance le timer pour un intervale fixe, afin de réessayer
      Tim_ReplicWeb.Interval := iIntervale;
      hNextReplicWeb := Now + (iIntervale / (24 * 60 * 60 * 1000))
    end;
  end;

  Ajoute('(Replic Web) Prochain time dans (ms) : ' + IntToStr(Tim_ReplicWeb.Interval), 0, True)

end;

function TFrm_LaunchV7.SourceToURL(AUrl: string; ASource: TStrings): string;
var
  I: Integer;
  sRes: string;
begin
  sRes := '';
  for I := 0 to ASource.Count - 1 do
  begin
    sRes := sRes + '&' + ASource[I];
  end;

  if sRes <> '' then
    sRes[1] := '?';

  Result := AUrl + sRes;
end;

procedure TFrm_LaunchV7.MajParamReplicTpsReel();
begin
  iDelaiEssai := 30000; // Délai entre deux essais

  iNbEssaiMax := GetParamInteger(11, 30, IdBase0);
  // Nombre d'essais maxi   code = 30
  iIntervaleTpsReel := (GetParamInteger(11, 31, IdBase0) * 60 * 1000);
  // Intervale entre deux réplic    code = 31, stocké en minute, utilisé en MS
  hDebReplicJourna := Trunc(Now) + Frac(GetParamFloat(11, 32, IdBase0));
  // Heure de début de réplication   code = 32
  hFinReplicJourna := Trunc(Now) + Frac(GetParamFloat(11, 33, IdBase0));
  // Heure de fin de réplic   code = 33
  sAdresseWS := GetParamString(11, 34, IdBase0);
  // Adresse du webservice   code = 34
  sSenderWS := GetParamString(11, 35, IdBase0);
  // Sender pour le WebService   code = 35
  sDatabaseWS := GetParamString(11, 36, IdBase0);
  // DB pour le webservice   code = 36
  sUrlPlateforme := GetParamString(11, 40, IdBase0);
  // Url de la plateforme   code = 40
  sSenderPlateforme := GetParamString(11, 41, IdBase0);
  // Sender utilisé dans cette base pour la plateforme   code = 41
  sDatabasePlateforme := GetParamString(11, 42, IdBase0);
  // Nom dans le fichier Database (plateforme) = code = 42

  if hDebReplicJourna > hFinReplicJourna then
    // La fin est avant le début, donc fin le lendemain
    hFinReplicJourna := hFinReplic + 1;

  Ajoute('MajParamReplicTpsReel données lues', 0, True);
  Ajoute('sAdresseWS : ' + sAdresseWS, 0, True);
  Ajoute('sSenderWS : ' + sSenderWS, 0, True);
  Ajoute('sDatabaseWS : ' + sDatabaseWS, 0, True);
  Ajoute('sUrlPlateforme : ' + sUrlPlateforme, 0, True);
  Ajoute('sSenderPlateforme : ' + sSenderPlateforme, 0, True);
  Ajoute('sDatabasePlateforme : ' + sDatabasePlateforme, 0, True);
  Ajoute('hDebReplicJourna : ' + FormatDateTime('yyyy-mm-dd hhnnss', hDebReplicJourna), 0, True);
  Ajoute('hFinReplicJourna : ' + FormatDateTime('yyyy-mm-dd hhnnss', hFinReplicJourna), 0, True);
  Ajoute('iIntervaleTpsReel : ' + IntToStr(iIntervaleTpsReel), 0, True);
  Ajoute('iNbEssaiMax : ' + IntToStr(iNbEssaiMax), 0, True);
  Ajoute('iDelaiEssai : ' + IntToStr(iDelaiEssai), 0, True);
end;

procedure TFrm_LaunchV7.MenuReloadServiceClick(Sender: TObject);
var
  ThreadSrvMobilite: TThreadMobiliteService;
begin
  Log.Log('LaunchV7_Frm', 'ReloadServicevMobilite', 'Log', 'MenuReloadServiceClick (avant).', logDebug, True, 0, ltLocal);
  // FreeAndNil(ThreadSrvMobilite);
  ThreadSrvMobilite := TThreadMobiliteService.Create;
  ThreadSrvMobilite.Status := -1;
  ThreadSrvMobilite.Resume;
  Log.Log('LaunchV7_Frm', 'ReloadServicevMobilite', 'Log', 'MenuReloadServiceClick (après).', logDebug, True, 0, ltLocal);
end;

procedure TFrm_LaunchV7.MenuReloadServiceRepriseClick(Sender: TObject);
var
  ThreadSrvServiceReprise: TThreadServiceRepriseService;
begin
  Log.Log('LaunchV7_Frm', 'ReloadServicevServiceReprise', 'Log', 'MenuReloadServiceRepriseClick (avant).', logDebug, True, 0, ltLocal);
  // FreeAndNil(ThreadSrvMobilite);
  ThreadSrvServiceReprise := TThreadServiceRepriseService.Create;
  ThreadSrvServiceReprise.Status := -1;
  ThreadSrvServiceReprise.Resume;
  Log.Log('LaunchV7_Frm', 'ReloadServicevServiceReprise', 'Log', 'MenuReloadServiceRepriseClick (après).', logDebug, True, 0, ltLocal);
end;

procedure TFrm_LaunchV7.MenuStartServiceClick(Sender: TObject);
var
  ThreadSrvMobilite: TThreadMobiliteService;
begin
  Log.Log('LaunchV7_Frm', 'StartServicevMobilite', 'Log', 'MenuStartServiceClick (avant).', logDebug, True, 0, ltLocal);
  // FreeAndNil(ThreadSrvMobilite);
  ThreadSrvMobilite := TThreadMobiliteService.Create;
  ThreadSrvMobilite.Status := 1;
  ThreadSrvMobilite.Resume;
  Log.Log('LaunchV7_Frm', 'StartServicevMobilite', 'Log', 'MenuStartServiceClick (après).', logDebug, True, 0, ltLocal);
end;

procedure TFrm_LaunchV7.MenuStartServiceRepriseClick(Sender: TObject);
var
  ThreadSrvServiceReprise: TThreadServiceRepriseService;
begin
  Log.Log('LaunchV7_Frm', 'StartServicevServiceReprise', 'Log', 'MenuStartServiceRepriseClick (avant).', logDebug, True, 0, ltLocal);
  // FreeAndNil(ThreadSrvMobilite);
  ThreadSrvServiceReprise := TThreadServiceRepriseService.Create;
  ThreadSrvServiceReprise.Status := 1;
  ThreadSrvServiceReprise.Resume;
  Log.Log('LaunchV7_Frm', 'StartServicevServiceReprise', 'Log', 'MenuStartServiceRepriseClick (après).', logDebug, True, 0, ltLocal);
end;

procedure TFrm_LaunchV7.MenuStopPiccobatchClick(Sender: TObject);
var
  ThreadPiccobatch: TThreadPiccobatch;
begin
  // démarrage de piccobatch en mode auto
  ThreadPiccobatch := TThreadPiccobatch.Create;
  ThreadPiccobatch.Launch := False;
  ThreadPiccobatch.Resume;
end;

procedure TFrm_LaunchV7.MenuStartPiccobatchClick(Sender: TObject);
var
  ThreadPiccobatch: TThreadPiccobatch;
begin
  // démarrage de piccobatch en mode auto
  ThreadPiccobatch := TThreadPiccobatch.Create;
  ThreadPiccobatch.Launch := True;
  ThreadPiccobatch.Resume;
end;

procedure TFrm_LaunchV7.MenuStopServiceClick(Sender: TObject);
var
  ThreadSrvMobilite: TThreadMobiliteService;
begin
  Log.Log('LaunchV7_Frm', 'StopServicevMobilite', 'Log', 'MenuStopServiceClick (avant).', logDebug, True, 0, ltLocal);
  // FreeAndNil(ThreadSrvMobilite);
  ThreadSrvMobilite := TThreadMobiliteService.Create;
  ThreadSrvMobilite.Status := 0;
  ThreadSrvMobilite.Resume;
  Log.Log('LaunchV7_Frm', 'StopServicevMobilite', 'Log', 'MenuStopServiceClick (après).', logDebug, True, 0, ltLocal);
end;

procedure TFrm_LaunchV7.MenuStopServiceRepriseClick(Sender: TObject);
var
  ThreadSrvServiceReprise: TThreadServiceRepriseService;
begin
  Log.Log('LaunchV7_Frm', 'StopServicevServiceReprise', 'Log', 'MenuStopServiceRepriseClick(avant).', logDebug, True, 0, ltLocal);
  // FreeAndNil(ThreadSrvMobilite);
  ThreadSrvServiceReprise := TThreadServiceRepriseService.Create;
  ThreadSrvServiceReprise.Status := 0;
  ThreadSrvServiceReprise.Resume;
  Log.Log('LaunchV7_Frm', 'StopServicevServiceReprise', 'Log', 'MenuStopServiceRepriseClick (après).', logDebug, True, 0, ltLocal);
end;

procedure TFrm_LaunchV7.MajDebFinReplicWeb;
// FC : 16/12/2008, Ajout du module réplic en journée
begin
  // Récup dans la base
  Log.Log('LaunchV7_Frm', 'MajDebFinReplicWeb', 'Log', 'Ib_GetParamReplicWeb (avant).', logDebug, True, 0, ltLocal);
  Ib_GetParamReplicWeb.ParamByName('BAS_ID').AsInteger := IdBase0;
  Ib_GetParamReplicWeb.Open;
  Log.Log('LaunchV7_Frm', 'MajDebFinReplicWeb', 'Log', 'Ib_GetParamReplicWeb (après).', logDebug, True, 0, ltLocal);

  if Ib_GetParamReplicWebOK.AsInteger in [1, 2] then
  begin
    dtReplicBegin := Ib_GetParamReplicWebHDEB.AsFloat;
    dtReplicEnd := Ib_GetParamReplicWebHFIN.AsFloat;
    iIntervale := Ib_GetParamReplicWebINTERVALE.AsInteger;
    iOrdre := Ib_GetParamReplicWebOK.AsInteger;
    bReplicWebActif := True;
  end
  else
  begin
    dtReplicBegin := Now;
    dtReplicEnd := Now;
    iIntervale := 300000;
    bReplicWebActif := False;
  end;
  Ib_GetParamReplicWeb.Close;

  // Récup de l'heure de début de réplic pour aujourd'hui
  hDebReplic := Trunc(Now) + Frac(dtReplicBegin);

  // Récup de la fin de réplic
  hFinReplic := Trunc(Now) + Frac(dtReplicEnd);
  if dtReplicBegin > dtReplicEnd then
    // La fin est avant le début, donc fin le lendemain
    hFinReplic := hFinReplic + 1;

end;

function TFrm_LaunchV7.ReplicWebToDo: Boolean;
begin
  Result := False;
  try
    if bReplicWebActif then
    begin
      // Est ce qu'on est en période de réplication ?
      if (hDebReplic <= Now) and (Now <= hFinReplic) then
      begin
        if (not MapGinkoia.Backup) and (not RepliEnCours) then
        begin
          Result := True;
        end
        else
        begin
          Result := False;
        end;
      end
      else
      begin
        Result := False;
      end;
    end
    else
    begin
      Result := False;
    end;
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;
end;

procedure TFrm_LaunchV7.RioJetonLaunchAfterExecute(const MethodName: string; SOAPResponse: TStream);
var
  NomFic: string;
begin
  if ModeDebug then
    NomFic := FormatDateTime('yyyymmdd_hhnnss.zzz', Now) + '_Response.xml'
  else
    NomFic := 'Response.xml';

  if DirectoryExists(PathLogRio) then
    TMemoryStream(SOAPResponse).SaveToFile(PathLogRio + NomFic);
end;

procedure TFrm_LaunchV7.RioJetonLaunchBeforeExecute(const MethodName: string; SOAPRequest: TStream);
var
  NomFic: string;
begin
  if ModeDebug then
    NomFic := FormatDateTime('yyyymmdd_hhnnss.zzz', Now) + '_Request.xml'
  else
    NomFic := 'Request.xml';

  if DirectoryExists(PathLogRio) then
    TMemoryStream(SOAPRequest).SaveToFile(PathLogRio + NomFic);
end;

procedure TFrm_LaunchV7.DoEventStatus;
var
  Events: TEventHisto;
begin
  try
    if FLauncherStarted then
    begin
      if taskReplication.Enabled then
      begin
        Events := GetEventInfos(LaBase0, CREPLICATIONOK);
        if (Events.getInfosSuccess) then
        begin
          taskReplication.Ok := (Events.HEV_RESULT = 1);
          if not (Events.isEOF) then
            taskReplication.Last := Events.HEV_DATE;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;

        Events := GetEventInfos(LaBase0, CLASTREPLIC);
        taskReplication.Next := hNextReplicJourna;
        if (Events.getInfosSuccess) then
        begin
          if not (Events.isEOF) then
            taskReplication.LastOk := Events.HEV_DATE;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;
      end;

      if taskReplicationPF.Enabled then
      begin
        Events := GetEventInfos(LaBase0, CREPLICATIONOK);
        if (Events.getInfosSuccess) then
        begin
          taskReplicationPF.Ok := (Events.HEV_RESULT = 1);
          if not (Events.isEOF) then
            taskReplicationPF.Last := Events.HEV_DATE;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;

        Events := GetEventInfos(LaBase0, CLASTREPLIC);
        taskReplicationPF.Next := hNextReplicJourna;
        if (Events.getInfosSuccess) then
        begin
          if not (Events.isEOF) then
            taskReplicationPF.LastOk := Events.HEV_DATE;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;
      end;

      // Panel de synchronisation
      if taskSynchroNotebook.Enabled then
      begin
        Events := GetEventInfos(LaBase0, CSYNCHROOK);
        if (Events.getInfosSuccess) then
        begin
          taskSynchroNotebook.Ok := (Events.HEV_RESULT = 1);
          if not (Events.isEOF) then
            taskSynchroNotebook.Last := Events.HEV_DATE;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;

        Events := GetEventInfos(LaBase0, CLASTSYNC);
        if (Events.getInfosSuccess) then
        begin
          if not (Events.isEOF) then
            taskSynchroNotebook.LastOk := Events.HEV_DATE;
          taskSynchroNotebook.Next := 0;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;
      end;

      if taskSynchroCaisse.Enabled then
      begin
        Events := GetEventInfos(LaBase0, CSYNCHROOK);
        if (Events.getInfosSuccess) then
        begin
          taskSynchroCaisse.Ok := (Events.HEV_RESULT = 1);
          if not (Events.isEOF) then
            taskSynchroCaisse.Last := Events.HEV_DATE;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;

        Events := GetEventInfos(LaBase0, CLASTSYNC);
        if (Events.getInfosSuccess) then
        begin
          if not (Events.isEOF) then
            taskSynchroCaisse.LastOk := Events.HEV_DATE;
          taskSynchroCaisse.Next := 0;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;
      end;

      if taskReplicationWeb.Enabled then
      begin
        Events := GetEventInfos(LaBase0, CWEBOK);
        if (Events.getInfosSuccess) then
        begin
          taskReplicationWeb.Ok := (Events.HEV_RESULT = 1);
          if not (Events.isEOF) then
            taskReplicationWeb.Last := Events.HEV_DATE;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;

        Events := GetEventInfos(LaBase0, CLASTWEB);
        if (Events.getInfosSuccess) then
        begin
          if not (Events.isEOF) then
            taskReplicationWeb.LastOk := Events.HEV_DATE;
          taskReplicationWeb.Next := hNextReplicWeb;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;
      end;

      if taskBackupRestore.Enabled then
      begin
        Events := GetEventInfos(LaBase0, CBACKRESTOK);
        if (Events.getInfosSuccess) then
        begin
          taskBackupRestore.Ok := (Events.HEV_RESULT = 1);
          if not (Events.isEOF) then
            taskBackupRestore.Last := Events.HEV_DATE;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;

        Events := GetEventInfos(LaBase0, CLASTBACKREST);
        if (Events.getInfosSuccess) then
        begin
          if not (Events.isEOF) then
            taskBackupRestore.LastOk := Events.HEV_DATE;
          taskBackupRestore.Next := 0;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;
      end;

      if taskBI.Enabled then
      begin
        Events := GetEventInfos(LaBase0, CBIOK);
        if (Events.getInfosSuccess) then
        begin
          taskBI.Ok := (Events.HEV_RESULT = 1);
          if not (Events.isEOF) then
            taskBI.LastOk := Events.HEV_DATE;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;

        Events := GetEventInfos(LaBase0, CLASTBI);
        if (Events.getInfosSuccess) then
        begin
          if not (Events.isEOF) then
            taskBI.Last := Events.HEV_DATE;
          taskBI.Next := 0;
          FDataBaseOk := True;
        end
        else
        begin
          FDataBaseError := 'Impossible de récupérer les informations dans la base';
          FDataBaseOk := False;
        end;
      end;

      if not (FDataBaseOk) then
      begin
        // on ferme les connexions pour qu'elles soient recréés en cas d'erreur
        Dm_LaunchEvent.CloseOpenConnexion();
      end;
    end;

    checkLauncher;
  except
    on E: Exception do
    begin
      FDataBaseOk := False;
      FDataBaseError := E.Message;
      Ajoute('DoEventStatus ' + E.Message, 0);
      Dm_LaunchEvent.CloseOpenConnexion();

      checkLauncher;
    end;
  end;

  // sendStatus ;

  // Exécute le nettoyage de la zone de trayicon
  NettoieBarreDesTaches;
end;

procedure TFrm_LaunchV7.MajMobilite(Status: Word);
begin

  try

    {
      SERVICE_STOPPED          0x00000001 The service is not running.
      SERVICE_START_PENDING    0x00000002 The service is starting.
      SERVICE_STOP_PENDING     0x00000003 The service is stopping.
      SERVICE_RUNNING          0x00000004 The service is running.
      SERVICE_CONTINUE_PENDING 0x00000005 The service continue is pending.
      SERVICE_PAUSE_PENDING    0x00000006 The service pause is pending.
      SERVICE_PAUSED           0x00000007 The service is paused.
    }

    if Status = 0 then
      EventPanel[10].visible := False
    else
    begin
      EventPanel[10].visible := True;
      if Status = SERVICE_RUNNING then
      begin
        EventPanel[10].Level := logInfo;
        MenuReloadService.Enabled := True;
        MenuStartService.Enabled := False;
        MenuStopService.Enabled := True;
      end
      else if ((Status = SERVICE_STOPPED) or (Status = SERVICE_STOP_PENDING)) then
      begin
        EventPanel[10].Level := logError;
        MenuReloadService.Enabled := False;
        MenuStartService.Enabled := True;
        MenuStopService.Enabled := False;
      end
      else
      begin
        EventPanel[10].Level := logNotice;
        MenuReloadService.Enabled := False;
        MenuStartService.Enabled := False;
        MenuStopService.Enabled := False;
      end;
      Application.ProcessMessages;
    end;
  finally

  end;

end;

procedure TFrm_LaunchV7.MajServiceReprise(Status: Word);
begin

  try

    {
      SERVICE_STOPPED          0x00000001 The service is not running.
      SERVICE_START_PENDING    0x00000002 The service is starting.
      SERVICE_STOP_PENDING     0x00000003 The service is stopping.
      SERVICE_RUNNING          0x00000004 The service is running.
      SERVICE_CONTINUE_PENDING 0x00000005 The service continue is pending.
      SERVICE_PAUSE_PENDING    0x00000006 The service pause is pending.
      SERVICE_PAUSED           0x00000007 The service is paused.
    }

    if Status = 0 then
      EventPanel[11].visible := False
    else
    begin
      EventPanel[11].visible := True;
      if Status = SERVICE_RUNNING then
      begin
        EventPanel[11].Level := logInfo;
        MenuReloadServiceReprise.Enabled := True;
        MenuStartServiceReprise.Enabled := False;
        MenuStopServiceReprise.Enabled := True;
      end
      else if ((Status = SERVICE_STOPPED) or (Status = SERVICE_STOP_PENDING)) then
      begin
        EventPanel[11].Level := logError;
        MenuReloadServiceReprise.Enabled := False;
        MenuStartServiceReprise.Enabled := True;
        MenuStopServiceReprise.Enabled := False;
      end
      else
      begin
        EventPanel[11].Level := logNotice;
        MenuReloadServiceReprise.Enabled := False;
        MenuStartServiceReprise.Enabled := False;
        MenuStopServiceReprise.Enabled := False;
      end;
      Application.ProcessMessages;
    end;
  finally

  end;

end;

function TFrm_LaunchV7.ManageNotUpdatableVerificationExe: Boolean;
var
  sPath: string;
  sExeVersion: string;
begin
  Result := False;

  sPath := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));

  if FileExists(sPath + 'verification.tmp') then
  begin
    sExeVersion := ReadFileVersion(sPath + 'verification.exe', 4);

    if sExeVersion = CST_WrongVerificationVersion then
    begin
      Log.Log('Main', FBasGUID, 'Log', 'Gestion du verification.tmp', logInfo, True, 0, ltLocal);

      if FileExists(sPath + 'A_MAJ\verification.exe') then
      begin
        if DeleteFile(sPath + 'A_MAJ\verification.exe') then
        begin
          Log.Log('Main', FBasGUID, 'Suppression du fichier A_MAJ\verification.exe', '.tmp', logInfo, True, 0, ltLocal);
        end;
      end;

      Log.Log('Main', FBasGUID, 'Log', 'Renommage de verification.tmp', logInfo, True, 0, ltLocal);

      //Gestion du verification.exe existant
      if FileExists(sPath + 'verification.exe') then
      begin
        if DeleteFile(sPath + 'verification.exe') then
        begin
          Log.Log('Main', FBasGUID, 'Log', 'Suppression de verification.exe', logInfo, True, 0, ltLocal);
        end
        else
        begin
          Log.Log('Main', FBasGUID, 'Log', 'ERREUR : Suppression de verification.exe', logError, True, 0, ltLocal);
        end;
      end;

      if CopyFile(PWideChar(sPath + 'verification.tmp'), PWideChar(sPath + 'verification.exe'), True) then
      begin
        Result := True;
        Log.Log('Main', FBasGUID, 'Log', 'Copie verification.exe en verification.tmp SUCCES', logInfo, True, 0, ltLocal);
      end
      else
      begin
        Log.Log('Main', FBasGUID, 'Log', 'ERREUR : Copie verification.exe en verification.tmp', logError, True, 0, ltLocal);
      end;
    end
  end;
end;

procedure TFrm_LaunchV7.MajPiccobatchStatut(Running: Boolean);
begin
  try
    if Running then
    begin
      EventPanel[12].Level := logInfo;

      MenuStartPiccobatch.Enabled := False;
      MenuStopPiccobatch.Enabled := True;
    end
    else
    begin
      EventPanel[12].Level := logError;
      MenuStartPiccobatch.Enabled := True;
      MenuStopPiccobatch.Enabled := False;
    end;

    Application.ProcessMessages;
  finally

  end;
end;

procedure TFrm_LaunchV7.sendStatus;
begin
  // Log.Log('Replication', FBasSender, 'Status', taskReplication.Error, uLog.TLogLevel(taskReplication.Level), true, 0, ltServer) ;
  // Log.Log('ReplicationPF', FBasSender, 'Status', taskReplicationPF.Error, uLog.TLogLevel(taskReplicationPF.Level), true, 0, ltServer) ;
  // Log.Log('ReplicationWeb', FBasSender, 'Status', taskReplicationWeb.Error, uLog.TLogLevel(taskReplicationWeb.Level), true, 0, ltServer) ;
  // Log.Log('SynchroNb', FBasSender, 'Status', taskSynchroNotebook.Error, uLog.TLogLevel(taskSynchroNotebook.Level), true, 0, ltServer) ;
  // Log.Log('SynchroCaisse', FBasSender, 'Status', taskSynchroCaisse.Error, uLog.TLogLevel(taskSynchroCaisse.Level), true, 0, ltServer) ;
  // Log.Log('BackupRestore', FBasSender, 'Status', taskBackupRestore.Error, uLog.TLogLevel(taskBackupRestore.Level), true, 0, ltServer) ;
  // Log.Log('BI', FBasSender, 'Status', taskBI.Error, uLog.TLogLevel(taskBI.Level), true, 0, ltServer) ;
end;

function TFrm_LaunchV7.DoMajFacture: Boolean;
var
  TCPClient: TIdTCPClient;
begin
  Result := False;
  TCPClient := TIdTCPClient.Create(Self);
  TCPClient.Host := '127.0.0.1';
  TCPClient.Port := 5000;
  try
    try
      TCPClient.Connect;
    except
      on E: Exception do
      begin
        Ajoute('DoMajFacture -> Echec de connexion au service d''impression :' + E.Message, 0);
        EXIT;
      end;
    end;

    if not Dm_LaunchMain.Tra_Ginkoia.InTransaction then
      Dm_LaunchMain.Tra_Ginkoia.StartTransaction;

    with IBQue_Tmp do
    try
      Log.Log('LaunchV7_Frm', 'DoMajFacture', 'Log', 'select LAU_NEWFACTNUM (avant).', logDebug, True, 0, ltLocal);

      Close;
      SQL.Clear;
      SQL.Add('Select * from LAU_NEWFACTNUM');
      Open;

      Log.Log('LaunchV7_Frm', 'DoMajFacture', 'Log', 'select LAU_NEWFACTNUM (après).', logDebug, True, 0, ltLocal);

      if Recordcount > 0 then
      begin
        while not Eof do
        begin
          TCPClient.IOHandler.writeLn(Format('F%s;%s', [FieldByName('FCE_ID').AsString, FieldByName('ASS_NOM').AsString]));
          Next;
        end;
      end;

      if Dm_LaunchMain.Tra_Ginkoia.InTransaction then
        Dm_LaunchMain.Tra_Ginkoia.Commit;

    except
      on E: Exception do
      begin
        Dm_LaunchMain.Tra_Ginkoia.Rollback;
        Ajoute('DoMajFacture -> ' + E.Message, 0);
      end;
    end;

    TCPClient.Disconnect;
  finally
    TCPClient.Free;
  end;
  Result := True;
end;

function TFrm_LaunchV7.DoPushPull(LeType: Integer; ARepli: TLesreplication): Boolean;
var
  bActionOK: Boolean; // Résultat des push et pull
  dtDebut: TDateTime; // Datage début réplic
  dtDebutPF: TDateTime; // Datage début réplic
  dtFinPF: TDateTime; // Datage début réplic
  bReferencementOK: Boolean;
  vSynchroCaisse: TSynchroCaisse;
begin
  // Type = 0 : Les deux (Push, puis Pull)
  // Type = 1 : Push
  // Type = 2 : Pull only
  // Type = 3 : Aucun

  Ajoute(DateTimeToStr(Now) + '   Début de la réplication journée', 0);

  dtDebut := Now;
  vSynchroCaisse := getSynchroCaisse;

  if ((BaseSauvegarde) or (isPortableSynchro) or (vSynchroCaisse.Enabled)) and (LeType <> 3) then
  begin
    // de toute facon, que l'envois
    Ajoute(DateTimeToStr(Now) + '  Mode PUSH seulement', 0);
    LeType := 1;
  end;

  Result := False;
  bActionOK := False;
  try
    if LanceDelosQPMAgent(ARepli.PlaceEai, ARepli.URLLocal + ARepli.Ping) then
    begin
      try
        try
          if LeType in [0, 1] then
          begin
            // Push
            Exec_AvantRepli(ARepli.PlaceBase);

            Ajoute(DateTimeToStr(Now) + '   ' + 'Début du PUSH ', 0);

            bActionOK := PUSH(ARepli, 0, False);

            if bActionOK then
              Ajoute(DateTimeToStr(Now) + '   ' + 'Envoi des données réussi', 0);
          end
          else
          begin
            // Pas de push a faire donc ok forcément
            bActionOK := True;
          end;

          // Lancement ref plateforme
          if bActionOK and (LeType = 0) and bReplicPlateforme then
          begin
            dtDebutPF := Now;
            bActionOK := LanceRefPF(ARepli, bReferencementOK);
            dtFinPF := Now;
          end;

          if bActionOK then
          begin
            // Pull
            if LeType in [0, 2] then
            begin
              DeconnexionTriger(ARepli.PlaceBase, False);
              bActionOK := PULL(ARepli, 0, False);
            end;
          end;

          if bActionOK then
            Ajoute(DateTimeToStr(Now) + '   ' + 'Récupération des données réussie', 1)
          else
            Ajoute(DateTimeToStr(Now) + '   ' + 'Echec de récupération des données', 0);

        except
          on E: Exception do
          begin
            taskReplication.Error := E.Message;
            Ajoute('Exception DOPUSHPULL : ' + E.Message, 0);
            bActionOK := False;
          end;
        end;

      finally
        Ajoute(DateTimeToStr(Now) + '   ' + 'Arrêt de QPMAgent', 0);
        ArretDelos;
        Ajoute(DateTimeToStr(Now) + '   ' + 'QPMAgent stoppé', 0);
      end;
      Ajoute('Etat Resultat : ' + BoolToStr(bActionOK, True), 0, True);
      Result := bActionOK;
    end;

  finally
    // Mise à jour des informations de réplications
    Event(ARepli.PlaceBase, CREPLICATIONOK, bActionOK, Now - dtDebut);
    if bActionOK then
      Event(ARepli.PlaceBase, CLASTREPLIC, True, Now - dtDebut);

    // Mise à jour des informations de la réplication plateforme
    if bReplicPlateforme then
    begin
      Event(ARepli.PlaceBase, CPFOK, bReferencementOK, dtFinPF - dtDebutPF);
      if bReferencementOK then
        Event(ARepli.PlaceBase, CLASTPF, True, dtFinPF - dtDebutPF);
    end;

    DoEventStatus;
  end;
end;

function TFrm_LaunchV7.DoReplicAutoJournee(ReplicManuelle: Boolean = False; LeType: integer = 0): Boolean;
var
  sAdresse: string; // Adresse du webservice
  sResult: string; // Réponse du WebService
  I: Integer; // Variable de boucle
  repli: TLesreplication; // Variable de parcours
  DefaultLCID: LCID;
  RioThread: TRioThread;
  iTrycount: Integer;
  iTimeOutReception, iTimeOutSend, itimeOutConnect: Integer;
  sPathName, sFilename, sTmp: string;
  iPosBlank, iPosPoint: Integer;
  Token: TTokenManager;
  WaitForFrm: Tfrm_WaitFor;
  vSynchroCaisse: TSynchroCaisse;
  bReplication: Boolean;
begin
  bReplication := True;
  vSynchroCaisse := getSynchroCaisse;

  if (BaseSauvegarde) or (isPortableSynchro) or (vSynchroCaisse.Enabled) then
  begin
    // Contrôle si lignes modifiées (réplication utile / inutile).
    if not LignesModifiees then
      bReplication := False;
  end;

  if ReplicManuelle then
    Ajoute('Réplication Manuelle', 0)
  else
    Ajoute('Réplication Automatique', 0);

  Result := False;
  showHideLog(True);
  WaitForFrm := nil;

  if not checkKRange then
    EXIT;
  if not checkLocalSeparators then
    EXIT;

  // Check backup en cours ...
  if MapGinkoia.Backup or MapGinkoia.Launcher then
  begin
    if MapGinkoia.Backup then
      Ajoute('Backup en cours.', 0);
    if MapGinkoia.Launcher then
      Ajoute('Launcher en cours.', 0);
    EXIT;
  end;

  // Check paramètrage jeton
  if (sAdresseWS = '') or (sDatabaseWS = '') or (sSenderWS = '') then
  begin
    Ajoute('Erreur de paramétrage d''accès aux jetons, vérifiez votre paramétrage local', 0);
    taskReplication.Error := 'Erreur de paramétrage d''accès aux jetons';
    EXIT;
  end;

  Mem_Result.Clear;
  Result := True;
  MapGinkoia.Launcher := True; // Flag que l'on est en train de répliquer

  taskReplication.Running := True;
  updateButtons;

  try
    if bReplication then
    begin
      // Pour chaque réplication, on va faire une tentative de connexion, si pas possible, on passe à la suivante. On compte le nombre d'essai par réplic
      for I := 0 to ListeReplication.Count - 1 do
      begin
        repli := TLesreplication(ListeReplication[I]);
        if (repli.bReplicJour) or (isPortableSynchro) or (vSynchroCaisse.Enabled) or (ReplicManuelle) then
        begin
          try
            Event(repli.PlaceBase, CREPLICATIONOK, False, 0);

            Dm_LaunchMain.Dtb_Ginkoia.Close;
            Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := repli.PlaceBase;
            Ajoute('Réplication de la base ' + repli.PlaceBase, 0);

            try
              Dm_LaunchMain.Dtb_Ginkoia.Open;
              FDataBaseOk := True;
            except
              on E: Exception do
              begin
                FDataBaseOk := False;
                FDataBaseError := E.Message;
                raise;
              end;
            end;

            checkLauncher;

            // Tentative de récupération de jetons
            Ajoute('Serveur de réplication :  ' + repli.URLDISTANT, 0);
            sAdresse := StringReplace(repli.URLDISTANT, '/DelosQPMAgent.dll', sAdresseWS, [rfReplaceAll, rfIgnoreCase]);
            PathLogRio := repli.PlaceEai + 'RESULT\Jeton\';
            ForceDirectories(PathLogRio);
            Ajoute('Logs RIO dans : ' + PathLogRio, 0, True);

            sResult := 'OK';

{$REGION 'Check version'}
            if (sResult = 'OK') then
            begin
              // Récup version
              try
                Ajoute('Do GetVersion', 0, True);

                iTrycount := 0;
                repeat
                  Inc(iTrycount);
                  try
                    sResult := GetVersionThread(sAdresse, sDatabaseWS, RioJetonLaunch);
                  except
                    on E: Exception do
                    begin
                      sResult := 'ERR-HTTP';
                      Ajoute('Erreur lors de la récupération de la vesion lame : ' + E.Message, 0);
                      DoWait(1000);
                    end;
                  end;
                until (sResult <> 'ERR-HTTP') or (iTrycount > 10);

                if ((sResult <> '') and (sResult <> 'ERR-HTTP')) then
                begin

                  Ajoute('GetVersion : ' + sResult + ' / ' + sVersionEnCours, 0, True);
                  if sVersionEnCours = sResult then
                  begin
                    sResult := 'OK';
                  end
                  else
                  begin
                    if (isPortableSynchro) or (vSynchroCaisse.Enabled) then
                    begin
                      sResult := 'OK';
                      Ajoute('Version du serveur réplicant différente de la version locale. Portable Synchro : réplic autorisée.', 0);
                    end
                    else
                    begin
                      sResult := 'ERR-VER';
                      Ajoute('Réplication impossible : Version du serveur réplicant différente de la version locale', 0);
                      taskReplication.Error := 'Version du serveur réplicant différente de la version locale';
                    end;
                  end;

                end
                else
                begin
                  sResult := 'ERR-HTTP';
                  Ajoute('Version : Erreur de connexion au serveur distant', 0);
                  taskReplication.Error := 'Version : Erreur de connexion au serveur distant';
                end;

              except
                on E: Exception do
                begin
                  sResult := 'ERR-HTTP';
                  Ajoute('Version : Erreur ' + E.Message, 0);
                  taskReplication.Error := 'Version : ' + E.Message;
                end;
              end;
            end;
{$ENDREGION}
{$REGION 'Notification de replic en cours'}
            if sResult = 'OK' then
            begin
              sResult := notificationReplicEnCours(repli);
            end;
{$ENDREGION}
{$REGION 'Jeton et PushPull'}
            if sResult = 'OK' then
            begin
              // Tentative de récupération du jeton
              Token := TTokenManager.Create;

              if isPortableSynchro then
              begin
                Pan_AffRight.Enabled := False;

                WaitForFrm := Tfrm_WaitFor.Create(Frm_LaunchV7);
                WaitForFrm.Parent := Frm_LaunchV7;
                WaitForFrm.BringToFront;
                WaitForFrm.Top := (Frm_LaunchV7.Height div 2) - (WaitForFrm.Height div 2);
                WaitForFrm.Left := (Frm_LaunchV7.Width div 2) - (WaitForFrm.Width div 2);
                WaitForFrm.onAbort := Token.abortGetToken;
                WaitForFrm.Show;
              end;

              Token.tryGetToken(sAdresse, sDatabaseWS, sSenderWS, iNbEssaiMax, iDelaiEssai);

              if Assigned(WaitForFrm) then
              begin
                WaitForFrm.Close;
                FreeAndNil(WaitForFrm);
                Pan_AffRight.Enabled := True;
              end;

              try
                if Token.Acquired then // Jeton acquis
                begin
                  Ajoute('Token acquis.', 0);
                  try
                    // Envoie de la réplication
                    //Result := DoPushPull(0, repli);
                    Result := DoPushPull(LeType, repli);
                    if Result then
                    begin
                      // Sauvegarde du max(K_VERSION).
                      SauvegardeMaxKVersion;
                    end;
                  except
                    on E: Exception do
                    begin
                      // Quoi qu'il arrive on fera la libération
                      Ajoute('Exception rencontrée 1 : ' + E.Message, 0);
                      Result := False;
                    end;
                  end;
                end
                else
                begin
                  Result := False;

                  Ajoute('Jeton : ' + Token.GetReasonString, 0);
                  taskReplication.Warning := 'Jeton : ' + Token.GetReasonString;
                end;
              finally
                Token.Free; // Libération du jeton
                Ajoute('Token libéré', 0);
              end;

              // Calcul du stock sans triggers (pas de 500).
              recalculeTriger(repli.PlaceBase, False, Result);
              connexionTriger(repli.PlaceBase, False);
            end
            else
            begin
              Ajoute('La réplication a échouée.', 0);
              Event(repli.PlaceBase, CREPLICATIONOK, False, 0);
              Result := False;
            end;

{$ENDREGION}
            Ajoute('Avant LocalDeBloqueReplic', 0, True);
            LocalDeBloqueReplic;
            Ajoute('Après LocalDeBloqueReplic', 0, True);

          except
            on E: Exception do
            begin
              // Base injoignable
              Result := False;
              Ajoute('Exception rencontrée 2 : ' + E.Message, 0);
            end;
          end;

          Dm_LaunchMain.Dtb_Ginkoia.Close;
        end
        else
        begin
          Ajoute('Replication non paramétrée', 0);
          taskReplication.Error := 'Replication non paramétrée';
        end;
      end;
    end
    else
    begin
      if ListeReplication.Count > 0 then
      begin
        repli := TLesreplication(ListeReplication[0]);
        // Pas de réplication nécessaire (PUSH Only)
        Event(repli.PlaceBase, CREPLICATIONOK, True, 0);
        Event(repli.PlaceBase, CLASTREPLIC, True, 0);
      end;
    end;

{$REGION 'Recacul des triggers'}
    // Recalcul triggers
    for I := 0 to ListeReplication.Count - 1 do
    begin
      repli := TLesreplication(ListeReplication[I]);
      Ajoute(DateTimeToStr(Now) + '   ' + 'Recalcule Base ' + repli.PlaceBase, 0);
      recalculeTriger(repli.PlaceBase, False, Result, True);
    end;
{$ENDREGION}
{$REGION 'Exécution d''application externe en fin de replic'}
    // On ne traite que si la réplication c'est bien passé et qu'on est pas en réplication manuelle
    if Result and not ReplicManuelle then
    begin
      // Chargement de la liste des applications à tuer
      KillApp.Load;
      for I := 0 to ListeReplication.Count - 1 do
      begin
        repli := TLesreplication(ListeReplication[I]);
        if Trim(repli.ExeFinReplic) <> '' then
        begin
          Ajoute(DateTimeToStr(Now) + '   ' + 'Exécution de : ' + repli.ExeFinReplic, 0);
          sPathName := extractFilePath(repli.ExeFinReplic);
          sFilename := ExtractFileName(repli.ExeFinReplic);
          iPosBlank := Pos(' ', sFilename);
          iPosPoint := Pos('.', sFilename);
          if iPosBlank = 0 then
            iPosBlank := length(sFilename);

          while CompareValue(iPosBlank, iPosPoint) = LessThanValue do
          begin
            sTmp := Copy(sFilename, iPosBlank + 1, length(sFilename));
            iPosBlank := Pos(' ', sTmp);
            if iPosBlank = 0 then
              iPosBlank := length(sFilename);

            if Trim(sTmp) = '' then
            begin
              Ajoute(DateTimeToStr(Now) + '   Problème pour extraire le nom du fichier de : ' + repli.ExeFinReplic, 0);
              Continue;
            end;
          end;
          // Ajout à la liste du nom de fichier exécutable à tuer
          KillApp.Add(Trim(Copy(sFilename, 1, iPosBlank)));
          // exécution du logiciel
          Ajoute('Exécution de ' + sPathName + Copy(sFilename, 1, iPosBlank), 0);
          ShellExecute(0, 'OPEN', PWideChar(sPathName + Copy(sFilename, 1, iPosBlank)), PWideChar(Copy(sFilename, iPosBlank, length(sFilename))), PWideChar(sPathName), SW_NORMAL);
        end;
      end;
      // Sauvegarde de la liste des applications à tuer
      KillApp.Save;

    end;
{$ENDREGION}
  finally
    taskReplication.Running := False;
    MapGinkoia.Launcher := False;
    showHideLog(False);
    DoEventStatus;
  end;

  // on récupére les espaces disques disponible pour l'archivage et la base à chaque fin de réplication manuelle
  diskSpace(FBasId);
end;

// fonction qui notifie à la base qu'une réplication est en cours
function TFrm_LaunchV7.notificationReplicEnCours(var repli: TLesreplication): string;
var
  sResult: string;
begin
  repli.Nbessai := 0;

  repeat // Récupération du jeton
    Inc(repli.Nbessai);
    Ajoute('Tentative de notification de réplication en cours', 0);

    if LocalBloqueReplic(repli.PlaceBase, 'ginkoia', 'ginkoia', -1, True) then
    begin
      sResult := 'OK';
    end
    else
    begin
      sResult := 'OQP';
      Ajoute('Réplication impossible : Base occupée', 0);
    end;

    Ajoute('Résultat : ' + sResult, 0, True);

    // Gestion des erreurs possibles
    if (sResult <> 'OK') and (repli.Nbessai < iNbEssaiMax) then
    begin
      // Tempo
      Ajoute('Temporisation...' + IntToStr((iDelaiEssai div 1000)) + 's', 0);
      LeDelay(iDelaiEssai);
    end;
  until (sResult = 'OK') or (repli.Nbessai >= iNbEssaiMax);

  if (sResult <> 'OK') then
  begin
    taskReplication.Error := 'Base occupée';
  end;

  Result := sResult
end;

procedure TFrm_LaunchV7.DoReplicTpsReelAndInfo;
begin
  if bReplicTpsReelActif then
  begin
    if DoReplicAutoJournee() then
    begin
      // réplic ok
      if not ModeDebug then
      begin
        Info;
      end;
      // Ajoute('Résultat de la dernière réplication temps réél : Réussie - ' + DateTimeToStr(Now()), 0)
    end
    else
    begin
      // Ajoute('Résultat de la dernière réplication temps réél  : Echec - ' + DateTimeToStr(Now()), 0)
    end;
  end
  else
  begin
    Ajoute('Réplication temps réél inactive, veuillez compléter le paramétrage', 0);
  end;
end;

function TFrm_LaunchV7.DoReplicWeb(): Boolean;
// FC : 16/12/2008, Ajout du module réplic en journée
var
  I: Integer;
  repli: TLesreplication; // Réplic en cours de traitement

  debut, DebutRepli: TDateTime; // Début du traitement, Début de la réplication

  repliOk: Boolean; // Traitement terminé correctement ou pas

  Ok, Connecte: Boolean;
  // Flags pour savoir si réussi fonction, si on est connecté

  DefaultLCID: LCID;
  reg: TRegistry;
begin
  Result := False;
  showHideLog(True);

  try
    if not checkKRange then
      EXIT;
    if not checkLocalSeparators then
      EXIT;

    // test pour vérifier que le séparateur décimal de la machine est bien une virgule
    if taskSynchroNotebook.Running or taskSynchroCaisse.Running then
    begin
      Ajoute('Synchronisation en cours, réplication annulée', 0);
      EXIT;
    end;

    if MapGinkoia.Backup or MapGinkoia.Launcher then
    begin
      Ajoute('Web : Backup ou réplication en cours', 0);
      Ajoute('Etat BackUp : ' + BoolToStr(MapGinkoia.Backup, True), 0, True);
      Ajoute('Etat Launcher : ' + BoolToStr(MapGinkoia.Launcher, True), 0, True);
      EXIT;
    end;

    reg := TRegistry.Create(KEY_WRITE);
    try
      reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings\', False);
      reg.WriteInteger('GlobalUserOffline', 0);
    finally
      reg.Free;
    end;

    Enabled := False;
    MapGinkoia.Launcher := True;
    taskReplicationWeb.Running := True;
    updateButtons;
    try
      debut := Now;

      // Pas de réplic journée sur le serveur de secours
      if not (BaseSauvegarde) then
      begin
        Connecte := False;
        Connectionencours := NIL;
        Result := True;
        try // Try For
          // Parcours toute la liste des dossiers réplication à traiter
          for I := 0 to ListeReplicWeb.Count - 1 do
          begin
            // On stock dans 'Repli' le Iième Objet de la liste créée à partir de la table GENREPLICATION
            repli := TLesreplication(ListeReplicWeb[I]);
            Ajoute(DateTimeToStr(Now) + '   ' + 'Base ' + repli.PlaceBase, 0);
            // Log
            DebutRepli := Now; // Flag début de réplication
            repliOk := True; // Init à true, si pb -> False

            // On exécute SM_AVANT_REPLI pour les seuils de stock
            // Exec_AvantRepli(repli.PlaceBase);

            try
              // 1° : Lancer DelosQpmAgent
              if Winexec(PAnsiChar(AnsiString(repli.PlaceEai + 'Delos_QpmAgent.exe')), 0) > 31 then
              begin
                try
                  Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement de QPMAgent ', 0); // Log
                  Sleep(1000); // On patiente, le temps qu'il soit bien lancé

                  // 2° : tester si le ping local fonctionne
                  if UnPing(repli.URLLocal + repli.Ping) then
                  begin
                    Ajoute(DateTimeToStr(Now) + '   ' + 'PING Local OK ', 0);
                    if not Connecte then
                    begin
                      Ajoute(DateTimeToStr(Now) + '   ' + 'Connexion à Internet', 0);
                      if not Connexion(repli) then
                      begin
                        // Pas de connexion à internet -> sortie de boucle
                        Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de connexion à internet', 0);
                        Result := False;
                        repliOk := False;
                        BREAK;
                      end
                      else
                        Connecte := True;
                    end;

                    // 3° : Essayer un Ping Distant
                    if UnPing(repli.URLDISTANT + repli.Ping) then
                    begin
                      Ajoute(DateTimeToStr(Now) + '   ' + 'PING Distant OK ', 0);

                      // Type 1 = Routeur : ping en boucle
                      if (Connectionencours = NIL) or (Connectionencours.LeType = 1) then
                      begin
                        Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement du PING en Boucle ', 0);
                        InitPing(repli.URLDISTANT + repli.Ping, 120000);
                      end;

                      try
                        // Déconnecte les triggers et envoie SM_AvantRepli
                        try
                          DeconnexionTriger(repli.PlaceBase);
                        except
                          repliOk := False;
                          raise;
                        end;

                        if iOrdre = 2 then // Ordre = 2 -> Push puis pull
                        begin
                          // Push Provider
                          // Lance le push
                          Ajoute(DateTimeToStr(Now) + '   ' + 'Début du PUSH ', 0); // Log
                          Ok := PUSH(repli);
                          if Ok then
                          begin
                            Ajoute(DateTimeToStr(Now) + '   ' + 'PUSH Réussi', 0); // Log
                          end
                          else
                          begin
                            Result := False;
                            repliOk := False;
                            Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le PUSH', 0);
                          end;
                        end
                        else
                        begin // ordre = 1 Pull, puis push
                          Ok := True;
                        end;

                        if Ok then
                        // Ok est a true si on est en pull/push, ou si on est en push/pull et que le push a marche
                        begin
                          // Pull Subscripter
                          try
                            Ajoute(DateTimeToStr(Now) + '   ' + 'Début du PULL', 0);
                            Ok := PULL(repli); // Lancemenet du Pull
                            if Ok then
                            begin
                              Ajoute(DateTimeToStr(Now) + '   ' + 'PULL réussi', 0);
                            end
                            else
                            begin
                              // problème
                              Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le PULL', 0);
                              Result := False;
                              repliOk := False;
                            end;
                          finally
                            if IsModuleActif('EKOSPORT') and IsMagasinWeb() then
                            begin
                              // Traitement des factures N° de facture
                              DoMajFacture;
                            end;

                            recalculeTriger(repli.PlaceBase, True, repliOk);
                            connexionTriger(repli.PlaceBase);
                            recalculeTriger(repli.PlaceBase, True, repliOk);
                          end;
                        end;

                        if iOrdre = 1 then // Cas du Pull/Push
                        begin
                          // Contrairement à la réplic classique, on envoie le Push après, et non avant
                          // donc on le fait même si le pull a raté.

                          // Push Provider
                          // Lance le push
                          Ajoute(DateTimeToStr(Now) + '   ' + 'Début du PUSH ', 0); // Log
                          Ok := PUSH(repli);
                          if Ok then
                          begin
                            Ajoute(DateTimeToStr(Now) + '   ' + 'PUSH Réussi', 0); // Log
                          end
                          else
                          begin
                            Result := False;
                            repliOk := False;
                            Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le PUSH', 0);
                          end;
                        end;
                      finally
                        Ajoute(DateTimeToStr(Now) + '   ' + 'Arret du PING', 0);
                        StopPing;
                      end;
                    end
                    else
                    begin
                      // Pas Ping distant
                      Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de PING Distant ', 0);
                      Result := False;
                      repliOk := False;
                    end;
                  end
                  else
                  begin
                    // Pas de Ping en local
                    Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de PING Local', 0);
                    Result := False;
                    repliOk := False;
                  end;
                finally
                  Ajoute(DateTimeToStr(Now) + '   ' + 'Arret de QPMAgent', 0);
                  ArretDelos;
                end;
              end
              else
              begin
                // Pas possible de lancer QpmAgent
                Ajoute(DateTimeToStr(Now) + '   ' + 'Impossible de lancer QPMAgent ', 0);
                Result := False;
                repliOk := False;
              end;
            finally
              Event(LaBase0, CWEBOK, repliOk, Now - debut);
              if repliOk then
                Event(LaBase0, CLASTWEB, True, Now - debut);
            end;
          end; // End For
        finally
          try
            StopPing;
          finally
            // quoi qu'il arrive, on déonncete si on est connecté
            if Connecte then
            begin
              Ajoute(DateTimeToStr(Now) + '   ' + 'Deconnexion d''internet', 0);
              Deconnexion;
              // Event(LaBase0, CstConnexionGlobal, result, Now - tempsReplication); // Pas de log
            end;

          end;
        end; // End try For
        Connectionencours := NIL;
      end; // End BaseSauvegarde

    finally
      // On remet la possibilité de cliquer sur le form
      Enabled := True;
      MapGinkoia.Launcher := False;
      taskReplicationWeb.Running := False;
      DoEventStatus;
    end;
    // Event(LaBase0, CstTempsReplication, result, Now - Debut);  // Pas de log
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;

  // Pour le rafraichissement de l'état de réplication
  DoEventStatus;
  showHideLog(False);
end;

procedure TFrm_LaunchV7.Tim_ReplicWebTimer(Sender: TObject);
// FC : 16/12/2008, Ajout du module réplic Web
begin
  Tim_ReplicWeb.Enabled := False;

  ActiveOnglet(Tab_Affiche);

  // Mise à jour de l'heure de début et fin de réplic
  MajDebFinReplicWeb();

  // Vérifie si on doit répliquer
  if ReplicWebToDo() then
  begin
    DoReplicWebAndInfo();
  end;

  // Calcul du prochain enclenchement du timer
  SetTimerIntervalReplicWeb();

  // Réactivation du timer
  if bReplicWebActif then
    Tim_ReplicWeb.Enabled := True;

  DoEventStatus;
end;

procedure TFrm_LaunchV7.Btn_JourneeClick(Sender: TObject);
var
  vParamCaisse: TSynchroCaisse;
begin
  try
    DoReplicAutoJournee(True);

    vParamCaisse := getSynchroCaisse;
    if ((not isPortableSynchro) and (not vParamCaisse.Enabled)) then
    begin
      if (ForcerLaMaj) then
      begin
        Ajoute('Forcage de la mise a jour.', 0);
        startVerification(True, False);
      end;
    end;
  except
    on E: Exception do
    begin
      Ajoute('Réplication : ' + E.Message, 0);
    end;
  end;
end;

procedure TFrm_LaunchV7.Btn_JournInternetClick(Sender: TObject);
var
  Frm_Conso: TFrm_Conso;
  vErr: string;
begin
  try
    Application.CreateForm(TFrm_Conso, Frm_Conso);
    Dm_LaunchV7.ConnectDataBase(LaBase0, vErr);
    // Frm_Conso.OuvreQuery(Basid);
    Frm_Conso.OuvreQuery(IdBase0);
    Frm_Conso.ShowModal;
  finally
    Frm_Conso.FermeQuery;
    Dm_LaunchV7.ClosedataBase;
    Frm_Conso.Free;
  end;
end;

procedure TFrm_LaunchV7.Btn_JournInternetTousMagsClick(Sender: TObject);
var
  Frm_Conso: TFrm_Conso;
  vErr: string;
begin
  try
    Application.CreateForm(TFrm_Conso, Frm_Conso);
    Dm_LaunchV7.ConnectDataBase(LaBase0, vErr);
    Frm_Conso.OuvreQuery(0);
    Frm_Conso.ShowModal;
  finally
    Frm_Conso.FermeQuery;
    Dm_LaunchV7.ClosedataBase;
    Frm_Conso.Free;
  end;
end;

procedure TFrm_LaunchV7.Btn_JournReplicClick(Sender: TObject);
var
  Frm_SuiviReplic: TFrm_SuiviReplic;
  vErr: string;
begin
  try
    Application.CreateForm(TFrm_SuiviReplic, Frm_SuiviReplic);
    Dm_LaunchV7.ConnectDataBase(LaBase0, vErr);
    // Frm_SuiviReplic.OuvreQuery(Basid);
    Frm_SuiviReplic.OuvreQuery(IdBase0);
    Frm_SuiviReplic.ShowModal;
  finally
    Frm_SuiviReplic.FermeQuery;
    Dm_LaunchV7.ClosedataBase;
    Frm_SuiviReplic.Free;
  end;
end;

procedure TFrm_LaunchV7.Btn_KOubliesReplicationClick(Sender: TObject);
var
  vSynchroCaisse: TSynchroCaisse;
  I, nNbKOublies, nLoop: Integer;
  repli: TLesreplication;
  sResult, sAdresse: string;
  Token: TTokenManager;
begin
  vSynchroCaisse := getSynchroCaisse;
  if (BaseSauvegarde) or (isPortableSynchro) or (vSynchroCaisse.Enabled) then
  begin
    Ajoute('', 1);
    Ajoute(DateTimeToStr(Now) + '   ' + 'Fonction interdite sur une base synchronisée', 0);
    EXIT;
  end;

  showHideLog(True);
  Ajoute(DateTimeToStr(Now) + '   ' + 'Contrôle K oubliés', 2);
  for I := 0 to Pred(ListeReplication.Count) do
  begin
    repli := TLesreplication(ListeReplication[I]);

    // Si K oubliés.
    nNbKOublies := ControleKVersion(repli.PlaceBase);

    if nNbKOublies > 0 then
    begin
      // notification à la base
      sResult := notificationReplicEnCours(repli);

      // notification réussie
      if sResult = 'OK' then
      begin
        // récupération de l'adresse pour le jeton
        sAdresse := StringReplace(repli.URLDISTANT, '/DelosQPMAgent.dll', sAdresseWS, [rfReplaceAll, rfIgnoreCase]);

        // récupération d'un jeton
        Token := TTokenManager.Create;
        Token.tryGetToken(sAdresse, sDatabaseWS, sSenderWS, iNbEssaiMax, iDelaiEssai);

        try
          if Token.Acquired then // Jeton acquis
          begin
            Ajoute('Token acquis.', 0);

            Ajoute(DateTimeToStr(Now) + '   ' + IntToStr(nNbKOublies) + IfThen(nNbKOublies > 1, ' K oubliés', ' K oublié'), 2);

            // Réplication.
            nLoop := GetLoop;
            if ReplicationAutomatique(True, False, 0, nLoop, cbRecalculTrigger.Checked) then
            begin
              Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Réussie', 1);
              MessMAJ1 := '';
              MessMAJ2 := '';
            end
            else
              Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);

            Ajoute('', 0);
          end
          else
          begin
            Ajoute('Jeton : ' + Token.GetReasonString, 0);
            taskReplication.Warning := 'Jeton : ' + Token.GetReasonString;
          end;
        finally
          Token.Free; // Libération du jeton
          Ajoute('Token libéré', 0);
        end;
      end
    end
    else
      Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de K oublié', 2);
  end;

  Info;
  showHideLog(False);
end;

procedure TFrm_LaunchV7.Btn_ReplicWebClick(Sender: TObject);
begin
  DoReplicWebAndInfo;
end;

procedure TFrm_LaunchV7.DoReplicWebAndInfo;
begin
  if bReplicWebActif then
  begin
    if DoReplicWeb() then
    begin
      // réplic ok
      if not ModeDebug then
        Info;
      // Ajoute('Résultat de la dernière réplication WEB : Réussie - ' + DateTimeToStr(Now()), 0)
    end
    else
    begin
      // Ajoute('Résultat de la dernière réplication WEB  : Echec - ' + DateTimeToStr(Now()), 0)
    end;
    Ajoute('Prochaine réplication WEB prévue : ' + DateTimeToStr(hNextReplicWeb), 1);
  end
  else
  begin
    Ajoute('Réplication WEB inactive, veuillez compléter le paramétrage', 0);
  end;
end;

procedure TFrm_LaunchV7.Btn_SynchroniserClick(Sender: TObject);
var
  StartInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  strCmdline: string;
  debut: TDateTime;
  Ok: Boolean;
  SavPasDeVerifACauseDeSynchro: Boolean;
  sPassWord: string;
  sVersionBase, sVersionLame, sVersionYellis: string;
begin
  Ajoute('Lancement de la synchronisation de portable');

  Screen.Cursor := crHourGlass;
  showHideLog(True);

  taskSynchroNotebook.Running := True;
  updateButtons;
  try
    Dm_LaunchMain.Dtb_Ginkoia.Close;
    // actualiser le chemin de la base du serveur
    Dm_LaunchMain.Dtb_Ginkoia.Open;

    Log.Log('LaunchV7_Frm', 'Btn_SynchroniserClick', 'Log', 'Que_CheminServeur (avant).', logDebug, True, 0, ltLocal);
    Que_CheminServeur.Close;
    Que_CheminServeur.Open;
    Log.Log('LaunchV7_Frm', 'Btn_SynchroniserClick', 'Log', 'Que_CheminServeur (après).', logDebug, True, 0, ltLocal);

    // lire param dans la base, table genparam
    strPathBaseServ := Que_CheminServeurPRM_STRING.AsString;

    // Récupération des versions des bases
    sVersionBase := GetVersionBase;
    sVersionLame := GetVersionLame;
    // Tempo de 5s car entre l'exécution de Verification et le Patch, le launcher est relancé
    if not Assigned(Sender) then
      DoWait(5000);
    // Suppression du fichier (pour ne pas avoir à le recharger aux cas où
    FileRestart.DelFile;

    case CompareText(sVersionBase, sVersionLame) of
      // VersionBase < VersionLame
      LessThanValue:
        begin

        end;

      equalsValue:
        begin

        end;
      GreaterThanValue: // VersionBase > VersionLame Ne devrait pas se produire
        begin
          ShowMessage('Veuillez contacter ginkoia, car il est possible qu''il y est un problème avec la base de synchronisation');
          EXIT;
        end;
    end;

    // Remise à 0 car on fait un traitement normal.
    FileRestart.Init;
    // tester l'existence de la copie de la base du serveur
    // IF FileExists(strPathBaseServ) THEN
    // BEGIN
    // message pour informer qu'il faut impérativement sauver la travail en cours et fermer ginkoia.
    if MessageDlg('Assurez vous que toutes les applications Ginkoia sont fermées et le travail en cours sauvegardé avant de continuer', mtInformation, [mbOk, MbCancel], 0) = mrOk then
    begin
      // forcer la réplication : push avec vérification auto mais pas de pull
      SavPasDeVerifACauseDeSynchro := PasDeVerifACauseDeSynchro;
      PasDeVerifACauseDeSynchro := True;
      try
        Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Manuelle', 0);
        debut := Now;
        Ok := DoReplicAutoJournee();

        if Ok then
        begin
          ReplicOk := True;
          Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Réussie', 1);
          MessMAJ1 := '';
          MessMAJ2 := '';
        end
        else
          Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);
        Ajoute('', 0);
        Info;
      finally
        PasDeVerifACauseDeSynchro := SavPasDeVerifACauseDeSynchro;
      end;

      // vérifier si la réplication c'est bien passée
      if not ReplicOk then
      begin
        // message d'avertissement
        case MessageDlg('Attention votre réplication a rencontré un PROBLEME, ' + #13 + #10 + 'si vous avez des données GINKOIA sur ce poste elles seront perdues !' + #13 + #10 + 'Voulez-vous poursuivre la synchronisation ?', mtWarning, [mbYes, MbNo], 0, MbNo) of
          mrYes:
            begin
              if not MotDePasse('PassGeneral') then
              begin
                MessageDlg('Annulation de la synchronisation', mtInformation, [mbOk], 0);
                EXIT;
              end
              else
                Ajoute('Synchronisation forcée', 0, True);
            end;
          mrNo:
            EXIT;
        else
          EXIT;
        end; // case
      end;

      if not startSynchroPortable(LaBase0) then
      begin
        MessageDlg('Echec de la synchronisation : impossible de lancer le programme', mtWarning, [mbOk], 0);
        EXIT;
      end;

      FCanClose := True;
      Close;
      EXIT;
    end;
    // END
    // ELSE
    // BEGIN
    // MessageDlg('Echec de la synchronisation :' + #13#10 + 'Impossible de trouver la copie de la base sur le réseau', mtWarning, [mbOk], 0);
    // END;
  finally
    Screen.Cursor := crDefault;
    Que_CheminServeur.Close;
    Dm_LaunchMain.Dtb_Ginkoia.Close;
    showHideLog(False);
    taskSynchroNotebook.Running := False;
    DoEventStatus;
  end;
end;


procedure TFrm_LaunchV7.AlignementGENERATEUR_VERSION_ID();
var
  vQuery: TIBQuery;
  vVersion : string;
  vDeb,vFin:Int64;
  vGENERALID,vVERSIONID:int64;
begin
    vVersion:='';
    vQuery := TIBQuery.Create(Self);
    vQuery.Database := Dm_LaunchMain.Dtb_Ginkoia;
    try
      try
        Dm_LaunchMain.Dtb_Ginkoia.Open;
        vQuery.Close;
        vQuery.SQL.Clear;
        vQuery.SQL.Add('SELECT * FROM GENVERSION ORDER BY VER_DATE DESC ROWS 1');
        vQuery.Open;
        vVersion := vQuery.FieldByName('VER_VERSION').asstring;
        if (vVersion>='22.2')
         then
          begin

              vQuery.Close;
              vQuery.SQL.Clear;
              vQuery.SQL.Add('SELECT BAS_PLAGE, BAS_VERSDEB, BAS_VERSFIN ,  ');
              vQuery.SQL.Add(' GEN_ID(GENERAL_ID,0) AS GENERAL,  ');
              vQuery.SQL.Add(' GEN_ID(VERSION_ID,0) AS VERSION   ');
              vQuery.SQL.Add('  FROM GENBASES                    ');
              vQuery.SQL.Add('  JOIN GENPARAMBASE ON PAR_STRING=BAS_IDENT AND PAR_NOM=''IDGENERATEUR'' ');
              vQuery.Open;


              vDeb := vQuery.FieldByName('BAS_VERSDEB').AsLargeInt;
              vFIN := vQuery.FieldByName('BAS_VERSFIN').AsLargeInt;
              vGENERALID := vQuery.FieldByName('GENERAL').AsLargeInt;
              vVERSIONID := vQuery.FieldByName('VERSION').AsLargeInt;
              vQuery.Close;

              //---------
              Ajoute(format('GENERAL_ID  = %d',[vGENERALID]));
              Ajoute(format('BAS_VERSDEB = %d',[vDeb]));
              Ajoute(format('BAS_VERSFIN = %d',[vFIN]));
              //---------
              Ajoute(format('VERSION_ID  = %d',[vVERSIONID]));

              //---------
              If (vVERSIONID<vDeb) or (vFIN<vVERSIONID)
                then
                  begin
                    Ajoute('VERSION_ID mauvais positionnement');

                    // Réalignement....
                    vQuery.Close;
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add(format('SET GENERATOR VERSION_ID TO %d',[vGENERALID]));
                    vQuery.ExecSQL;
                    // ---------------------------------------------------------
                    Ajoute('VERSION_ID réalignement ');
                    Ajoute(vQuery.SQL.Text);

                  end
          end;
         vQuery.Close;
      except
        on E: Exception do
        begin
          Ajoute('AlignementGENERATEUR_VERSION_ID Erreur');
          EXIT;
        end;
      end;
    finally
      vQuery.Free;
      Dm_LaunchMain.Dtb_Ginkoia.Close;
    end;
end;

function TFrm_LaunchV7.getSynchroCaisse(): TSynchroCaisse;
var
  vQuery: TIBQuery;
  vBasId: Int64;
begin
  Result.Enabled := False;
  Result.Time := 0;
  Result.Server := '';

  // En v13, pas de synchro caisse
  if FBaseVersion.Major <= 13 then
    EXIT;

  vQuery := TIBQuery.Create(Self);
  vQuery.Database := Dm_LaunchMain.Dtb_Ginkoia;
  try
    Dm_LaunchMain.Dtb_Ginkoia.Open;
  except
    on E: Exception do
    begin
      Ajoute('Synchronisation de caisse : Impossible de récupérer l''identifiant de base.');
      EXIT;
    end;
  end;

  try
    try
      Log.Log('LaunchV7_Frm', 'getSynchroCaisse', 'Log', 'select GENPARAMBASE (avant).', logDebug, True, 0, ltLocal);
      vQuery.SQL.Text := 'SELECT PAR_STRING from GENPARAMBASE ' + 'WHERE PAR_NOM=''IDGENERATEUR''';
      vQuery.Open;
      Log.Log('LaunchV7_Frm', 'getSynchroCaisse', 'Log', 'select GENPARAMBASE (après).', logDebug, True, 0, ltLocal);

      if vQuery.IsEmpty then
      begin
        Ajoute('Synchronisation de caisse : Impossible de récupérer l''identifiant de base.');
        EXIT;
      end;

      vBasId := StrToIntDef(vQuery.FieldByName('PAR_STRING').AsString, -1);
      if vBasId < 1 then
      begin
        Ajoute('Synchronisation de caisse : Identifiant de base invalide.');
        EXIT;
      end;

      Log.Log('LaunchV7_Frm', 'getSynchroCaisse', 'Log', 'select GENPARAM (avant).', logDebug, True, 0, ltLocal);

      vQuery.Close;
      vQuery.SQL.Text := 'SELECT PRM_INTEGER, PRM_FLOAT, PRM_STRING FROM GENPARAM ' + 'JOIN K ON PRM_ID = K_ID AND K_ENABLED=1 ' + 'JOIN GENBASES ON BAS_ID = PRM_POS ' + 'WHERE PRM_TYPE=11 AND PRM_CODE=50 AND BAS_IDENT = :BASID';
      vQuery.ParamByName('BASID').AsLargeInt := vBasId;
      vQuery.Open;

      Log.Log('LaunchV7_Frm', 'getSynchroCaisse', 'Log', 'select GENPARAM (après).', logDebug, True, 0, ltLocal);

      if vQuery.IsEmpty then
      begin
        Ajoute('Synchronisation de caisse : Paramètrage invalide');
        EXIT;
      end;

      Result.Enabled := (vQuery.FieldByName('PRM_INTEGER').AsInteger = 1);
      Result.Time := Frac(vQuery.FieldByName('PRM_FLOAT').AsFloat);
      Result.Server := vQuery.FieldByName('PRM_STRING').AsString;
    finally
      vQuery.Free;
      Dm_LaunchMain.Dtb_Ginkoia.Close;
    end;
  except
    on E: Exception do
    begin
      Ajoute('Synchronisation de caisse : Impossible de récupérer les valeurs de Synchro Caisse.');
      EXIT;
    end;
  end;
end;

function TFrm_LaunchV7.doSynchroCaisse(): Boolean;
var
  vSynchroCaisse: TSynchroCaisse;
  vReplicOk: Boolean;
  vDebut: TDateTime;
begin
  Ajoute('Lancement de la Synchronisation de caisse');

  taskSynchroCaisse.Running := True;
  updateButtons;
  try
    Event(LaBase0, CSYNCHROOK, False, 0);

    vSynchroCaisse := getSynchroCaisse;
    if not vSynchroCaisse.Enabled then
    begin
      Ajoute('Synchronisation de caisse : Inactif');
      EXIT;
    end;

    // Verification de la base de synchro distante
    if not FileExists(vSynchroCaisse.Server) then
    begin
      Ajoute('Synchronisation de caisse : Base de synchronisation non trouvée.');
      taskSynchroCaisse.Error := 'Base de synchronisation non trouvée.';
      EXIT;
    end;

    if not FileExists(LaBase0) then
    begin
      Ajoute('Synchronisation de caisse : Base locale non trouvée.');
      taskSynchroCaisse.Error := 'Base locale non trouvée.';
      EXIT;
    end;

    vDebut := Now;
    vReplicOk := DoReplicAutoJournee();

    if not vReplicOk then
    begin
      Ajoute('Synchronisation de caisse : La réplication a échouée.');
      taskSynchroCaisse.Error := 'La réplication a échouée.';
      EXIT;
    end;

    DoEventStatus;

    startSynchroPortable(LaBase0);
  finally
    taskSynchroCaisse.Running := False;
    DoEventStatus;
  end;
end;

function TFrm_LaunchV7.startSynchroPortable(ABase: string): Boolean;
var
  vStartInfo: TStartupInfo;
  vProcessInfo: TProcessInformation;
  sCmdline: string;
  sExeName: string;
begin
  sExeName := IncludeTrailingPathDelimiter(extractFilePath(Application.exename)) + 'SynchroniserPortable.exe';
  sCmdline := sExeName + ' "' + ABase + '" "AUTO"';

  try
    // Dm_LaunchEvent.Data_Evt.Close ;
    // AJ modif le 12/05/2017 pour ajout section critique dans launchEvent_Dm, on ferme la connexion sans la rouvrir
    Dm_LaunchEvent.CloseConnexion();
  except
    Ajoute('Impossible de fermer la connexion à GENHISTOEVT');
    Log.Log('Synchro', FBasGuid, 'Synchro', 'Impossible de fermer la connexion à GENHISTOEVT', logTrace, True, 0, ltLocal);
  end;

  try
    Dm_LaunchMain.Dtb_Ginkoia.Close;
    Dm_LaunchV7.data_.Close;
  except
  end;

  try
    Dm_LaunchEvent.EnterCritical;
    Result := (ExecuteAndWait(sExeName, sCmdline) = 0);
  finally
    Dm_LaunchEvent.ExitCritical;
  end;
end;

procedure TFrm_LaunchV7.Btn_ParamsClick(Sender: TObject);
begin
  if not MapGinkoia.Launcher then
  begin
    MapGinkoia.Launcher := True;
    try
      ExecuteParamFrm(IdBase0);
    finally
      MapGinkoia.Launcher := False;
    end;
    VerifChangeHorraire;
    InitialiseLaunch();
  end;
end;

procedure TFrm_LaunchV7.Btn_PrmSynchroClick(Sender: TObject);
var
  Frm_ParamSynchro: TFrm_ParamSynchro;
  vErr: string;
begin
  if not MapGinkoia.Launcher then
  begin
    MapGinkoia.Launcher := True;
    try
      // vérifier si mono base
      Dm_LaunchMain.Dtb_Ginkoia.Close;
      Dm_LaunchMain.Dtb_Ginkoia.DatabaseName := LaBase0;
      Dm_LaunchMain.Dtb_Ginkoia.Open;

      Log.Log('LaunchV7_Frm', 'Btn_PrmSynchroClick', 'Log', 'Que_Bases (avant).', logDebug, True, 0, ltLocal);
      Que_Bases.Close;
      Que_Bases.Open;
      Log.Log('LaunchV7_Frm', 'Btn_PrmSynchroClick', 'Log', 'Que_Bases (après).', logDebug, True, 0, ltLocal);

      if Que_Bases.Eof then
      begin
        MessageDlg('Base unique, pas de synchronisation possible.', mtInformation, [mbOk], 0);
      end
      else
      begin
        Dm_LaunchV7.ConnectDataBase(LaBase0, vErr);
        // si serveur afficher la liste des portables paramétré pour une synchro avec ce serveur
        if isServeur then
        begin
          ExecuteListeSynchro();
        end
        else
        begin
          // sinon ouvrir la fenètre de paramétrage
          ExecuteParamSynchro();
        end;
        Dm_LaunchV7.ClosedataBase();
        // actualiser les boutons en fonction des mises à jour
        boutonSynchro(1);
      end;
      Dm_LaunchMain.Dtb_Ginkoia.Close;

      InitialiseLaunch();
    finally
      MapGinkoia.Launcher := False;
    end;
  end;
end;

procedure TFrm_LaunchV7.Btn_QuitterClick(Sender: TObject);
begin
  if ConfirmerSortie then
  begin
    Dm_LaunchMain.setFermerEtatLauncher();
    Commit;
    QuitLauncher;
  end;
end;

procedure TFrm_LaunchV7.boutonSynchro(msgError: Integer);
var
  vSynchroCaisse: TSynchroCaisse;
begin
  try
    isPortableSynchro := False;

    Dm_LaunchMain.Dtb_Ginkoia.Close;
    Dm_LaunchMain.Dtb_Ginkoia.Open;

    vSynchroCaisse := getSynchroCaisse;
    btnSynchroCaisse.visible := vSynchroCaisse.Enabled;
    btnSynchroCaisseHome.visible := vSynchroCaisse.Enabled;
    taskSynchroCaisse.Enabled := vSynchroCaisse.Enabled;

    // vérifier qu'il s'agit d'une base initialisée pour d'éventuelles synchro
    Log.Log('LaunchV7_Frm', 'boutonSynchro', 'Log', 'Que_CheminServeur (avant).', logDebug, True, 0, ltLocal);
    Que_CheminServeur.Open;
    Log.Log('LaunchV7_Frm', 'boutonSynchro', 'Log', 'Que_CheminServeur (après).', logDebug, True, 0, ltLocal);

    if (Que_CheminServeur.Recordcount = 1) then
    begin
      isPortableSynchro := (Que_CheminServeurPRM_INTEGER.AsInteger = 1) and (Que_CheminServeurPRM_STRING.AsString <> '') and (Que_CheminServeurPRM_FLOAT.AsInteger <> 0);

      taskSynchroNotebook.Enabled := isPortableSynchro;

      // verifier s'il s'agit d'un serveur dont le paramétre de la synchro est actif
      isServeur := (Que_CheminServeurPRM_INTEGER.AsInteger = 1) and (Que_CheminServeurPRM_FLOAT.AsInteger = 0);
      // bouton active si portable et synchro activée

      if isPortableSynchro then
      begin
        PasDeVerifACauseDeSynchro := True;
        Btn_Synchroniser.visible := True;
        strPathBaseServ := Que_CheminServeurPRM_STRING.AsString;
      end
      else
      begin
        Btn_Synchroniser.visible := False;
      end;
    end
    else // sinon prévenir que le paramétre initial ne pas été créé dans genparam
    begin
      if msgError = 1 then
      begin
        MessageDlg('Base pas initialisée pour la synchronisation', mtWarning, [mbOk], 0);
      end;
    end;
  finally
    Que_CheminServeur.Close;
    Dm_LaunchMain.Dtb_Ginkoia.Close;
  end;

  taskBackupRestore.Enabled := not (taskSynchroNotebook.Enabled or taskSynchroCaisse.Enabled);
  Btn_DoSynchro.visible := Btn_Synchroniser.visible;
  // Pan_FondTop.Visible := not Btn_Synchroniser.visible;
  // Pan_Synchro.Visible := Btn_Synchroniser.visible;

  // Nbt_ForceReplicTpsReel.Visible := Not (Btn_DoSynchro.Visible);
end;

procedure TFrm_LaunchV7.btnDateBackupClick(Sender: TObject);
var
  reponse: Integer;
  dateGenDossier, genDossNom: string;
  dos_id: Integer;
begin
  reponse := MessageDlg('Etes vous sûr de vouloir mettre à jour la date du backup à la date actuelle ?', mtCustom, [mbYes, MbNo], 0);

  if (reponse = 6) then
  begin
    dos_id := 0;

    // on met à jour la date du gendossier
    Log.Log('LaunchV7_Frm', 'Init', 'Log', 'Mise à jour de la date du backup à la date actuelle', logNotice, True, 0, ltLocal);

    try
      // selection du nom du gendossier
      IBQue_Tmp.Close;
      IBQue_Tmp.SQL.Text := 'SELECT (''B-''||bas_id) AS genDossNom FROM genbases ' + 'JOIN genparambase ON genbases.bas_ident = genparambase.par_string ' + 'WHERE par_nom = ''IDGENERATEUR''';
      IBQue_Tmp.Open;
      if not IBQue_Tmp.IsEmpty then
      begin
        genDossNom := IBQue_Tmp.FieldByName('genDossNom').AsString;
      end;

      // selection du dos_id qui correspond
      IBQue_Tmp.Close;
      IBQue_Tmp.SQL.Text := 'SELECT dos_id FROM gendossier WHERE dos_float = 1 AND dos_nom = :genDossNom';
      IBQue_Tmp.ParamByName('genDossNom').AsString := genDossNom;
      IBQue_Tmp.Open;
      if not IBQue_Tmp.IsEmpty then
      begin
        dos_id := IBQue_Tmp.FieldByName('dos_id').AsInteger;
      end;

      dateGenDossier := DateTimeToStr(Now) + ' - 0';

      // mise à jour de la valeur dans GenDossier
      if (dos_id > 0) then
      begin
        IBQue_Tmp.Close;
        IBQue_Tmp.SQL.Clear;
        IBQue_Tmp.SQL.Text := 'UPDATE GENDOSSIER SET dos_string = :dateGenDossier WHERE dos_id = :dos_id';
        IBQue_Tmp.ParamByName('dateGenDossier').AsString := dateGenDossier;
        IBQue_Tmp.ParamByName('dos_id').AsInteger := dos_id;

        IBQue_Tmp.ExecSQL;

        Commit;

        Ajoute('La date du GENDOSSIER a été mise à jour avec la valeur suivante : ' + dateGenDossier);
      end
      else
        Ajoute('Impossible de trouver le dos_id du GENDOSSIER de la date du backup');

    except
      on E: Exception do
        Ajoute('Erreur lors de la tentative de MAJ du GENDOSSIER : ' + E.Message);
    end;
  end;
end;

function TFrm_LaunchV7.IsBaseProd: Boolean;
begin
  Result := False;
  try
    // selection du nom du gendossier
    IBQue_Tmp.Close;
    IBQue_Tmp.SQL.Clear;
    IBQue_Tmp.SQL.Text := 'SELECT * FROM GENPARAMBASE WHERE par_nom = ''BASETYPE'' AND par_float = 1';
    IBQue_Tmp.Open;
    Result := not IBQue_Tmp.Eof;
  except
    on E: Exception do
      Ajoute('Erreur lors de la récupération du type de base : ' + E.Message);
  end;

end;

procedure TFrm_LaunchV7.btnSynchroCaisseClick(Sender: TObject);
begin
  doSynchroCaisse;
end;

function TFrm_LaunchV7.SrvSecours_EstALancer: Boolean;
var
  stEtatService: TEtatService;
begin
  /// Vérifie si on a besoin d'un serveur de secours,
  /// et si c'est le cas, vérifie si on est ok sur la config (service présent)
  /// Sinon vérif si on a une base non configurée et le service présent.
  /// Selon les cas, on va demander le démarrage du service
  /// Il faut démarrer s'il est nécéssaire et qu'il n'est pas démarré (mais installé quand meme)
  stEtatService := SrvSecours_EtatService;

  Result := False;
  if bSrvSecours_Present then
  begin
    if not Interbase7 then
    begin
      Result := False;
      SrvSecoursAffErreur(1, 'La base est configurée pour un serveur de secours, mais la base n''est pas en interbase 7 ou supérieur');
    end
    else
    begin
      if not stEtatService.bInstall then
      begin
        Result := False;
        SrvSecoursAffErreur(2, 'La base est configurée pour un serveur de secours, mais le service n''est pas installé');
      end
      else
      begin
        if stEtatService.bStarted then
        begin
          if not stEtatService.bAutomatique then
          begin
            Result := False;
            SrvSecoursAffErreur(1, 'La base est configurée pour un serveur de secours, le service est lancé mais est en manuel');
          end
          else
          begin
            SrvSecoursAffErreur(); // C'est tout bon
            Result := False;
          end;
        end
        else
        begin
          Result := True;
          SrvSecoursAffErreur(2, 'La base est configurée pour un serveur de secours, mais le service n''est pas lancé');
        end;
      end;
    end;
  end
  else
  begin
    // Ne doit pas être installé (en tous cas pas en auto)
    if stEtatService.bInstall and stEtatService.bAutomatique then
    begin
      // Problème
      SrvSecoursAffErreur(2, 'La base n''est pas configurée pour un serveur de secours, mais le service est présent');
      Result := False;
    end
    else
    begin
      SrvSecoursAffErreur();
      Result := False;
    end;
  end;

end;

function TFrm_LaunchV7.SrvSecours_EtatService: TEtatService;
// Tester si le serveur de secours est bien en route.
var
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  Config: TQueryServiceConfig;
  PConfig: PQueryServiceConfig;
  iSize: DWord;
begin

  Result.bInstall := False;
  Result.bAutomatique := False;
  Result.bStarted := False;

  hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
  hService := OpenService(hSCManager, 'IBRepl', SERVICE_QUERY_STATUS or SERVICE_QUERY_CONFIG);
  try
    if hService <> 0 then
    begin
      PConfig := @Config;
      iSize := 0;
      QueryServiceConfig(hService, PConfig, iSize, iSize);
      if QueryServiceConfig(hService, PConfig, iSize, iSize) then
      begin
        case Config.dwStartType of
          SERVICE_AUTO_START:
            begin
              Result.bInstall := True;
              Result.bAutomatique := True;
            end;

          SERVICE_DEMAND_START:
            begin
              Result.bInstall := True;
              Result.bAutomatique := False;
            end;

          SERVICE_DISABLED:
            begin
              Result.bInstall := False;
              Result.bAutomatique := False;
              Result.bStarted := False;
            end;
        end;

      end;
       //RaiseLastOSError(GetLastError());

      // S'il est installé, on va teste s'il est lancé
      if Result.bInstall then
      begin
        QueryServiceStatus(hService, Statut);
        if Statut.dwCurrentState <> SERVICE_RUNNING then
        begin
          Result.bStarted := False;
        end
        else
        begin
          Result.bStarted := True;
        end;
      end;
    end
    else
    begin
      Result.bInstall := False;
    end;
  finally
    CloseServiceHandle(hService);
    CloseServiceHandle(hSCManager);
  end;
end;

procedure TFrm_LaunchV7.SrvSecours_Demarre;
var
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  tempMini: DWord;
  CheckPoint: DWord;
begin
  if not Interbase7 then
    EXIT;

  if ServiceRepl then // ne redemarer le service que si on la arrété
  begin
    hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
    hService := OpenService(hSCManager, 'IBRepl', SERVICE_QUERY_STATUS or SERVICE_START or SERVICE_STOP or SERVICE_PAUSE_CONTINUE);
    if hService <> 0 then
    begin // Service non installé
      QueryServiceStatus(hService, Statut);
      tempMini := Statut.dwWaitHint + 10;
      ControlService(hService, SERVICE_CONTROL_CONTINUE, Statut);
      repeat
        CheckPoint := Statut.dwCheckPoint;
        Sleep(tempMini);
        QueryServiceStatus(hService, Statut);
      until (CheckPoint = Statut.dwCheckPoint) or (Statut.dwCurrentState = SERVICE_RUNNING);
      // si CheckPoint = Statut.dwCheckPoint Alors le service est dans les choux
    end;
    CloseServiceHandle(hService);
    CloseServiceHandle(hSCManager);
  end;
end;

procedure TFrm_LaunchV7.Tim_SrvSecoursTimer(Sender: TObject);
var
  stEtatService: TEtatService;
begin
  Tim_SrvSecours.Enabled := False;
//
//  bSrvSecours_Present := bSrvSecours_Present and Interbase7;
//
//  if bSrvSecours_Present then
//  begin
//    // Vérif l'état
//    stEtatService := SrvSecours_EtatService;
//    if not stEtatService.bStarted then
//    begin
//      // On tente de démarrer
//      SrvSecours_Demarre();
//
//      if Tim_SrvSecours.Interval = 1000 then // à l'init
//      begin
//        dtSrvSecours_PremiereTentative := Now;
//        Tim_SrvSecours.Interval := 30000;
//        // La première fois on réessaie après 30 secondes
//      end
//      else
//      begin
//        Tim_SrvSecours.Interval := 600000; // sinon 10 minutes
//      end;
//
//      Sleep(3000); // on attend 5 secondes pour le lancement du service
//      // Si le serveur n'est toujours pas actif, on retente
//      if SrvSecours_EstALancer then
//      begin
//        if (Now - dtSrvSecours_PremiereTentative) < 0.042 then
//        begin
//          Tim_SrvSecours.Enabled := True;
//        end;
//      end;
//
//    end
//    else
//    begin
//      // ben on fait rien, ca marche
//      SrvSecoursAffErreur();
//      Tim_SrvSecours.Interval := 1000;
//    end;
//  end;

end;

procedure TFrm_LaunchV7.SrvSecoursAffErreur(ANum: Integer = 0; ALibelle: string = '');
begin
  ///
  ///
  Img_SrvSecours1.visible := False;
  Img_SrvSecours2.visible := False;

  if ANum = 0 then // Effacer
  begin
    Pan_SrvSecours.Caption := '';
    Pan_SrvSecours.visible := False;
    EXIT; // on fait pas le reste
  end
  else
  begin

    case ANum of
      1:
        begin // Info
          Img_SrvSecours1.visible := True;
          Lab_SrvSecours.Font.Style := [fsBold];
        end;
      2:
        begin // Erreur
          Img_SrvSecours2.visible := True;
          Lab_SrvSecours.Font.Style := [];
        end;
    end;

    Lab_SrvSecours.Caption := ALibelle;
    Pan_SrvSecours.visible := True;
  end;

end;

procedure TFrm_LaunchV7.showHideLog(aShow: Boolean);
begin
  if Assigned(Mem_Affiche) then
  begin
    if Mem_Affiche.visible <> aShow then
    begin
      Mem_Affiche.visible := aShow;
    end;
  end;
end;

function TFrm_LaunchV7.checkKRange: Boolean;
var
  aBitmap: TBitmap;
begin
  KRange.Open(LaBase0);

  Result := KRange.checkRange;

  KRange.Close;

  if Result then
  begin
    if KRange.Used > 95 then
    begin
      FKRangeStatus := logWarning;
      Ajoute('Attention : La plage de K est presque pleine ! Contactez votre support client.', 0);
      // log pour le monitoring pour la section critique des K pleins
      Log.Log('Main', FBasGuid, 'PlageKLauncher', 'Attention : La plage de K est presque pleine : ' + FloatToStr(RoundTo(KRange.Used, -2)) + '%', logError, True, 0, ltBoth);
      pb_KRange.State := pbsPaused;
      Img_KRange.Picture.Bitmap.Assign(bmpRange[1]);
    end
    else
    begin
      // log pour le monitoring pour la section critique des K pleins
      Log.Log('Main', FBasGuid, 'PlageKLauncher', 'Plage de k utilisée à  : ' + FloatToStr(RoundTo(KRange.Used, -2)) + '%', logInfo, True, 0, ltBoth);
      FKRangeStatus := logInfo;
      pb_KRange.State := pbsNormal;
      Img_KRange.Picture.Bitmap.Assign(bmpRange[0]);
    end;
  end
  else
  begin
    FKRangeStatus := logError;
    if KRange.Used >= 0 then
      Ajoute('ERREUR CRITIQUE : Plage de K pleine !!!', 0)
    else
      Ajoute('ERREUR CRITIQUE : Générateur de K hors de la plage !!!', 0);
    pb_KRange.State := pbsError;
    Img_KRange.Picture.Bitmap.Assign(bmpRange[2]);
  end;

  pb_KRange.Position := Round(KRange.Used);
  Lab_KUsed.Caption := IntToStr(Floor(KRange.Used)) + '%';
  Pan_KRange.Hint := 'Plage : ' + IntToStr(KRange.Min) + ' ~ ' + IntToStr(KRange.Max) + #13#10 + 'Courant : ' + IntToStr(KRange.Current);
  Pan_KRange.ShowHint := True;

  checkLauncher;
end;

procedure TFrm_LaunchV7.checkLauncher;
var
  vLogLevel: TLogLevel;
  vError: string;
begin
  vLogLevel := logInfo;
  vError := 'Launcher OK';

  try
    if not FDataBaseOk then
    begin
      vLogLevel := logError;
      vError := 'Erreur : Base de donnée invalide : ' + FDataBaseError;

      EXIT;
    end;

    if not FLauncherStarted then
    begin
      vLogLevel := logNotice;
      vError := 'Démarrage en cours ...';
      EXIT;
    end;

    if FKRangeStatus = logWarning then
    begin
      vLogLevel := logWarning;
      vError := 'Avertissement : Vérifiez la plage de K';
      EXIT;
    end;

    if FKRangeStatus = logError then
    begin
      vLogLevel := logError;
      vError := 'Erreur : Plage de K invalide. Veuillez contacter Ginkoia';
      EXIT;
    end;

    if not checkPlaceBase then
    begin
      vLogLevel := logError;
      vError := 'Erreur : REP_PLACEBASE invalide';
      EXIT;
    end;

  finally
    EventPanel[1].Level := vLogLevel;
    EventPanel[1].Hint := vError;

    updateButtons;

    if FBasSender <> '' then
      Log.Log('Main', FBasGuid, 'Status', EventPanel[1].Hint, uLog.TLogLevel(EventPanel[1].Level), True, 3600, ltServer);

    Application.ProcessMessages;
  end;
end;

procedure TFrm_LaunchV7.LaunchAsAdministrator;
var
  reg: TRegistry;
  launchAsAdmin: string;
begin
  // lecture de la clé pour lancer le launcher en mode administrateur
  reg := TRegistry.Create(KEY_READ);
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers', False);

    launchAsAdmin := application.ExeName;
    launchAsAdmin := reg.ReadString(application.ExeName);
  finally
    reg.closekey;
    reg.Free;
  end;

  // si la clé n'existe pas, on la créé, en cas de succès, on redémarre le launcher
  if launchAsAdmin = '' then
  begin
    try
      reg := TRegistry.Create(KEY_WRITE);
      try
        reg.RootKey := HKEY_CURRENT_USER;
        reg.OpenKey('Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers', True);
        reg.WriteString(application.ExeName, 'RUNASADMIN');
      finally
        reg.closekey;
        reg.Free;
      end;

      // si ça n'est pas déjà un redémarrage, sécurité pour éviter de redémarrer en boucle
      if not isRestartApplication then
      begin
        // la clé est écrite, on redémarre le launcher
        ShellExecute(Handle, 'Open', PWideChar(application.ExeName), 'RESTART', Nil, SW_SHOWDEFAULT);
        Application.Terminate;
      end;
    except
      Application.MessageBox('Les droits Administrateur sont obligatoires pour modifier les registres', 'Attention', Mb_Ok);
    end;
  end;
end;

function TFrm_LaunchV7.checkPlaceBase: Boolean;
var
  vDatabase: TIBDatabase;
  vTrans: TIBTransaction;
  vQuery: TIBQuery;
  vPlaceEai, vPlaceBase: string;
begin
  Result := False;
  if FBasId < 1 then
    EXIT;

  try
    vDatabase := TIBDatabase.Create(Self);
    vDatabase.DatabaseName := LaBase0;
    vDatabase.Params.Clear;
    vDatabase.Params.Add('user_name=ginkoia');
    vDatabase.Params.Add('password=ginkoia');
    vDatabase.LoginPrompt := False;
    vDatabase.Open;

    vTrans := TIBTransaction.Create(Self);
    vTrans.AddDatabase(vDatabase);

    vQuery := TIBQuery.Create(Self);
    try
      vQuery.Database := vDatabase;
      vQuery.Transaction := vTrans;

      Log.Log('LaunchV7_Frm', 'checkPlaceBase', 'Log', 'select GENREPLICATION (avant).', logDebug, True, 0, ltLocal);

      vQuery.SQL.Text := 'SELECT REP_PLACEEAI, REP_PLACEBASE FROM GENREPLICATION ' + 'JOIN K ON K_ID = REP_ID AND K_ENABLED=1 ' + 'JOIN GENLAUNCH ON LAU_ID = REP_LAUID ' + 'JOIN K ON K_ID = LAU_ID AND K_ENABLED=1 ' + 'WHERE LAU_BASID = :BASID';

      vQuery.ParamByName('BASID').AsLargeInt := FBasId;
      vQuery.Open;

      Log.Log('LaunchV7_Frm', 'checkPlaceBase', 'Log', 'select GENREPLICATION (après).', logDebug, True, 0, ltLocal);
      if not vQuery.IsEmpty then
      begin
        vPlaceEai := vQuery.FieldByName('REP_PLACEEAI').AsString;
        vPlaceBase := vQuery.FieldByName('REP_PLACEBASE').AsString;

        if (UpperCase(Copy(vPlaceEai, 1, 3)) = UpperCase(Copy(vPlaceBase, 1, 3))) and (Upcase(vPlaceBase[1]) in ['A'..'Z']) and (vPlaceBase[2] = ':') then
          Result := True;

      end;

      vQuery.Close;
    finally
      vQuery.Free;
      vTrans.Free;
      vDatabase.Close;
      vDatabase.Free;
    end;
  except
  end;
end;

function TFrm_LaunchV7.checkLocalSeparators: Boolean;
var
  DefaultLCID: LCID;
  sMessage: string;
begin
  Result := False;

  try
    DefaultLCID := GetThreadLocale;

    if GetLocaleChar(DefaultLCID, LOCALE_SDECIMAL, '.') <> ',' then
    begin
      sMessage := 'Le symbole décimal doit être la "," (virgule) pour que la réplication fonctionne' + #13#10 + 'Corriger cette erreur dans le menu : Options régionales et linguistiques';
      Ajoute(sMessage, 0);
      Application.MessageBox(pchar(sMessage), 'ATTENTION', Mb_Ok);
      EXIT;
    end;

    if GetLocaleChar(DefaultLCID, LOCALE_SDATE, '.') <> '/' then
    begin
      sMessage := 'Le symbole séparateur de date doit être le "/" (slash) pour que la réplication fonctionne' + #13#10 + 'Corriger cette erreur dans le menu : Options régionales et linguistiques';
      Ajoute(sMessage, 0);
      Application.MessageBox(pchar(sMessage), 'ATTENTION', Mb_Ok);
      EXIT;
    end;

    Result := True;
  except
  end;
end;

procedure TFrm_LaunchV7.updateButtons;
var
  vRunning: Boolean;
begin
  vRunning := False;

  if not FLauncherStarted then
    vRunning := True;

  if taskReplication.Running then
    vRunning := True;
  if taskSynchroNotebook.Running then
    vRunning := True;
  if taskSynchroCaisse.Running then
    vRunning := True;

  Btn_DoSynchro.Enabled := not vRunning;
  btnSynchroCaisseHome.Enabled := not vRunning;
  Nbt_ForceReplicTpsReel.Enabled := not vRunning;
  Parametrage.Enabled := not vRunning;
  btReplicWeb.Enabled := not vRunning;
  Nbt_PingTest.Enabled := not vRunning;
  Btn_APropos.Enabled := not vRunning;
  Btn_Quitter.Enabled := not vRunning;
end;

{ TRioThread }

constructor TRioThread.Create(AHttpRio: THTTPRIO; ATimeMS: Integer; LabTimer: TLabel = nil);
begin
  inherited Create(True);

  FreeOnTerminate := False;
  FWaitMs := ATimeMS;
  FLabel := LabTimer;
  FHttpRio := AHttpRio;
  if Assigned(FLabel) then
    FLabel.Caption := '';
end;

procedure TRioThread.Execute;
var
  Start, encours: Integer;
begin
  Start := GetTickCount;
  encours := Start;
  if Assigned(FLabel) then
    FLabel.Caption := 'Debut';
  while encours <= Start + FWaitMs do
  begin
    encours := GetTickCount;
    if Assigned(FLabel) then
    begin
      FLabel.Caption := IntToStr(encours);
      FLabel.Update;
    end;
    Application.ProcessMessages;
  end;
  if Assigned(FLabel) then
    FLabel.Caption := 'Fin';
end;

{ TRioGetVersionThread }

constructor TRioGetVersionThread.Create(AHttpRio: THTTPRIO; AUrl, ADatabase: string);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FHttpRio := AHttpRio;
  FURL := AUrl;
  FDataBase := ADatabase;
  FResultat := '';
  FEndOfThread := False;
end;

procedure TRioGetVersionThread.Execute;
var
  sTmp: string;
begin
  Coinitialize(nil);
  try
    try
      FResultat := GetIJetonLaunch(FURL, FHttpRio).GetVersionBDD(FDataBase);
    except
      on E: Exception do
        FResultat := Format('Erreur : %s - %s', [E.ClassName, E.Message]);
    end;
  finally
    CoUnInitialize;
    FEndOfThread := True;
  end;
end;

// ==============================================================================
{ TTask }
// ==============================================================================
constructor TTask.Create;
begin
  inherited;

  FSend := True;
  FReference := '';

  FEnabled := False;
  FRunning := False;
  FLast := 0;
  FLastOk := 0;
  FNext := 0;
  FOk := False;
  FError := '';
  FWarning := '';
  FOverTime := 86400;
  FLevel := logNone;

  FEventPanel := nil;
end;

destructor TTask.Destroy;
begin

  inherited;
end;

procedure TTask.evalStatus;
var
  vStatus: TTaskStatus;
  vLogLevel: TLogLevel;
  vHint: string;
begin
  vStatus := tsDisabled;

  if FEnabled then
  begin
    if FRunning then
    begin
      vStatus := tsRunning;
    end
    else
    begin
      vStatus := tsStoppped;
    end;
  end;

  FStatus := vStatus;
  vLogLevel := logDebug;
  vHint := '';

  if (not Frm_LaunchV7.Started) or (not FEnabled) then
  begin
    vLogLevel := logTrace;
  end
  else
  begin
    if FRunning then
    begin
      vLogLevel := logNotice;
    end
    else
    begin

      if FOverTime > 0 then
      begin
        if (Now - FLastOk) > (FOverTime / 86400) then
        begin
          vLogLevel := logError;
        end
        else
        begin
          if FOk then
          begin
            vLogLevel := logInfo
          end
          else
          begin
            vLogLevel := logWarning;
            if FError <> '' then
              vLogLevel := logError;
          end;
        end;
      end
      else
      begin
        if FOk then
        begin
          vLogLevel := logInfo
        end
        else
        begin
          vLogLevel := logWarning;
          if FError <> '' then
            vLogLevel := logError;
        end;
      end;
    end;

    if FOk then
    begin
      if FLastOk > 0 then
        vHint := vHint + 'Dernière tentative réussie le : ' + FormatDateTime('dd/mm/yyyy à hh:nn:ss', FLastOk) + #13#10;
    end
    else
    begin
      if FError <> '' then
        vHint := vHint + 'Erreur : ' + FError + #13#10;
      if FLast > 0 then
        vHint := vHint + 'Dernière tentative le : ' + FormatDateTime('dd/mm/yyyy à hh:nn:ss', FLast) + #13#10;
      if FLastOk > 0 then
        vHint := vHint + 'Dernier tentative réussie : ' + FormatDateTime('dd/mm/yyyy à hh:nn:ss', FLastOk) + #13#10;
    end;

    if FNext > 0 then
      vHint := vHint + 'Prochaine tentative le : ' + FormatDateTime('dd/mm/yyyy à hh:nn:ss', FNext) + #13#10;

    if FLastOk > 0 then
      FEventPanel.Detail := 'Dernière réussite :' + #13#10 + FormatDateTime('dd/mm/yyyy hh:nn', FLastOk);
  end;

  if FLevel <> vLogLevel then
  begin
    FLevel := vLogLevel;
    FSend := True;
  end;

  if Assigned(FEventPanel) then
  begin
    FEventPanel.ShowHint := True;
    FEventPanel.Hint := vHint;
    FEventPanel.Level := vLogLevel;
    FEventPanel.visible := FEnabled;
  end;

  sendLog;

  Application.ProcessMessages;
end;

procedure TTask.sendLog;
begin
  if FSend = True then
  begin
    if (FError <> '') then
      Log.Log(FName, FReference, 'Status', FError, uLog.TLogLevel(Level), True, 0, ltServer)
    else
      Log.Log(FName, FReference, 'Status', FWarning, uLog.TLogLevel(Level), True, 0, ltServer);
  end;

  FSend := False;
end;

procedure TTask.setEnabled(const Value: Boolean);
begin
  if Value = FEnabled then
    EXIT;

  FEnabled := Value;
  FSend := True;

  evalStatus;
end;

procedure TTask.setError(const Value: string);
begin
  if Value = FError then
    EXIT;

  FError := Value;
  if FError <> '' then
  begin
    FWarning := '';
    FOk := False;
  end;

  FSend := True;

  evalStatus;
end;

procedure TTask.setWarning(const Value: string);
begin
  if Value = FWarning then
    EXIT;

  FWarning := Value;
  if FWarning <> '' then
    FOk := False;

  FSend := True;

  evalStatus;
end;

procedure TTask.setLast(const Value: TDateTime);
begin
  if Value = FLast then
    EXIT;

  FLast := Value;
  evalStatus;

  Log.Log(FName, FReference, 'dteLast', DateTimeToIso8601(FLast), logInfo, True, 0, ltServer);
end;

procedure TTask.setLastOk(const Value: TDateTime);
begin
  if Value = FLastOk then
    EXIT;

  FLastOk := Value;
  evalStatus;

  Log.Log(FName, FReference, 'dteLastOk', DateTimeToIso8601(FLastOk), logInfo, True, 0, ltServer);
end;

procedure TTask.setNext(const Value: TDateTime);
begin
  if Value = FNext then
    EXIT;

  FNext := Value;
  evalStatus;
end;

procedure TTask.setOk(const Value: Boolean);
begin
  if (FOk <> Value) then
  begin
    FOk := Value;
    if FOk then
    begin
      FWarning := '';
      FError := '';
    end;

    FSend := True;

    evalStatus;
  end;
end;

procedure TTask.setOverTime(const Value: Integer);
begin
  FOverTime := Value;
  evalStatus;
end;

procedure TTask.setRunning(const Value: Boolean);
begin
  if (FRunning <> Value) then
  begin
    FRunning := Value;
    evalStatus;
  end;
end;
{ TThreadMobiliteService }

constructor TThreadMobiliteService.Create(CreateSuspended: Boolean);
begin
  inherited;
  FreeOnTerminate := True;
end;

destructor TThreadMobiliteService.Destroy;
begin
  inherited;
end;

procedure TThreadMobiliteService.Execute;
begin
  inherited;

  if Status = -1 then
  begin
    if ServiceWaitStop('', 'GinkoiaMobiliteSvr', 10000) then
    begin
      Log.Log('LaunchV7_Frm', 'ReloadServicevMobilite', 'Log', 'Le service de Mobilité a été arrêté.', logInfo, True, 0, ltLocal);
      if ServiceWaitStart('', 'GinkoiaMobiliteSvr', 10000) then
        Log.Log('LaunchV7_Frm', 'ReloadServicevMobilite', 'Log', 'Le service de Mobilité a été démarré.', logInfo, True, 0, ltLocal)
      else
        Log.Log('LaunchV7_Frm', 'ReloadServicevMobilite', 'Log', 'Le service de Mobilité n''a pas pu être démarré.', logError, True, 0, ltLocal);
    end
    else
      Log.Log('LaunchV7_Frm', 'ReloadServicevMobilite', 'Log', 'Le service de Mobilité n''a pas pus être arrêté.', logError, True, 0, ltLocal);

  end;

  if Status = 0 then
    if ServiceWaitStop('', 'GinkoiaMobiliteSvr', 10000) then
      Log.Log('LaunchV7_Frm', 'ReloadServicevMobilite', 'Log', 'Le service de Mobilité a été arrêté.', logInfo, True, 0, ltLocal)
    else
      Log.Log('LaunchV7_Frm', 'ReloadServicevMobilite', 'Log', 'Le service de Mobilité n''a pas pu être arrêté.', logError, True, 0, ltLocal);

  if Status = 1 then
    if ServiceWaitStart('', 'GinkoiaMobiliteSvr', 10000) then
      Log.Log('LaunchV7_Frm', 'ReloadServicevMobilite', 'Log', 'Le service de Mobilité a été démarré.', logInfo, True, 0, ltLocal)
    else
      Log.Log('LaunchV7_Frm', 'ReloadServicevMobilite', 'Log', 'Le service de Mobilité n''a pas pu être démarré.', logError, True, 0, ltLocal);

end;

{ TThreadSrvCheckStatusMobilite }

constructor TThreadSrvCheckStatusMobilite.Create;
begin
  inherited;
  FreeOnTerminate := False;
end;

destructor TThreadSrvCheckStatusMobilite.Destroy;
begin
  Terminate;
  Resume;
  WaitFor;
  inherited;
end;

procedure TThreadSrvCheckStatusMobilite.Execute;
begin
  inherited;

  while not terminated do
  begin
    try
      FStatus := ServiceGetStatus('', 'GinkoiaMobiliteSvr');
      Synchronize(Synchro);
    except
    end;

    if not terminated then
      Sleep(1000);
  end;
end;

procedure TThreadSrvCheckStatusMobilite.Synchro;
begin
  try
    Frm_LaunchV7.MajMobilite(FStatus);
  except
  end;
end;

{ TThreadServiceRepriseService }

constructor TThreadServiceRepriseService.Create(CreateSuspended: Boolean);
begin
  inherited;
  FreeOnTerminate := True;
end;

destructor TThreadServiceRepriseService.Destroy;
begin
  inherited;
end;

procedure TThreadServiceRepriseService.Execute;
begin
  inherited;

  if Status = -1 then
  begin
    if ServiceWaitStop('', 'GinkoiaServiceReprises', 10000) then
    begin
      Log.Log('LaunchV7_Frm', 'ReloadServicevServiceReprise', 'Log', 'Le service de Reprise a été arrêté.', logInfo, True, 0, ltLocal);
      if ServiceWaitStart('', 'GinkoiaServiceReprises', 10000) then
        Log.Log('LaunchV7_Frm', 'ReloadServicevServiceReprise', 'Log', 'Le service de Reprise a été démarré.', logInfo, True, 0, ltLocal)
      else
        Log.Log('LaunchV7_Frm', 'ReloadServicevServiceReprise', 'Log', 'Le service de Reprise n''a pas pu être démarré.', logError, True, 0, ltLocal);
    end
    else
      Log.Log('LaunchV7_Frm', 'ReloadServicevServiceReprise', 'Log', 'Le service de Reprise n''a pas pus être arrêté.', logError, True, 0, ltLocal);

  end;

  if Status = 0 then
    if ServiceWaitStop('', 'GinkoiaServiceReprises', 10000) then
      Log.Log('LaunchV7_Frm', 'ReloadServicevServiceReprise', 'Log', 'Le service de Reprise a été arrêté.', logInfo, True, 0, ltLocal)
    else
      Log.Log('LaunchV7_Frm', 'ReloadServicevServiceReprise', 'Log', 'Le service de Reprise n''a pas pu être arrêté.', logError, True, 0, ltLocal);

  if Status = 1 then
    if ServiceWaitStart('', 'GinkoiaServiceReprises', 10000) then
      Log.Log('LaunchV7_Frm', 'ReloadServicevServiceReprise', 'Log', 'Le service de Reprise a été démarré.', logInfo, True, 0, ltLocal)
    else
      Log.Log('LaunchV7_Frm', 'ReloadServicevServiceReprise', 'Log', 'Le service de Reprise n''a pas pu être démarré.', logError, True, 0, ltLocal);

end;

{ TThreadSrvCheckStatusServiceReprise }

constructor TThreadSrvCheckStatusServiceReprise.Create;
begin
  inherited;
  FreeOnTerminate := False;
end;

destructor TThreadSrvCheckStatusServiceReprise.Destroy;
begin
  Terminate;
  Resume;
  WaitFor;
  inherited;
end;

procedure TThreadSrvCheckStatusServiceReprise.Execute;
begin
  inherited;

  while not terminated do
  begin
    try
      FStatus := ServiceGetStatus('', 'GinkoiaServiceReprises');
      Synchronize(Synchro);
    except
    end;

    if not terminated then
      Sleep(1000);
  end;
end;

procedure TThreadSrvCheckStatusServiceReprise.Synchro;
begin
  try
    Frm_LaunchV7.MajServiceReprise(FStatus);
  except
  end;
end;

{ TThreadPiccobatch }
constructor TThreadPiccobatch.Create(CreateSuspended: Boolean);
begin
  inherited;
  FreeOnTerminate := True;
end;

destructor TThreadPiccobatch.Destroy;
begin
  inherited;
end;

procedure TThreadPiccobatch.Execute;
begin
  inherited;

  if Launch then
    Frm_LaunchV7.LaunchPiccoAuto // on démarre Piccobatch
  else
    KillProcessus('piccobatch.exe'); // on arrête le Piccobatch
end;

{ TThreadSrvCheckStatusPiccobatch }

constructor TThreadSrvCheckStatusPiccobatch.Create;
begin
  inherited;
  FreeOnTerminate := False;
end;

destructor TThreadSrvCheckStatusPiccobatch.Destroy;
begin
  Terminate;
  Resume;
  WaitFor;
  inherited;
end;

procedure TThreadSrvCheckStatusPiccobatch.Execute;
begin
  inherited;

  while not terminated do
  begin
    try
      FRunning := processExists('piccobatch.exe');
      Synchronize(Synchro);
    except
    end;

    if not terminated then
      Sleep(1000);
  end;
end;

procedure TThreadSrvCheckStatusPiccobatch.Synchro;
begin
  try
    Frm_LaunchV7.MajPiccobatchStatut(FRunning);
  except
  end;
end;

end.

