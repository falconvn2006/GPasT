//$Log:
// 49   Utilitaires1.48        09/02/2012 14:54:00    Florent CHEVILLON Mise ?
//      jour pour instancier les composants quand n?cessaire
// 48   Utilitaires1.47        12/01/2012 17:39:42    Florent CHEVILLON
//      Suppression du test pr?-r?plic en mode synchro, qui ne servait a rien.
// 47   Utilitaires1.46        10/01/2012 09:07:00    Florent CHEVILLON
//      Correction
// 46   Utilitaires1.45        21/12/2011 16:33:20    Florent CHEVILLON Maj 11.2
// 45   Utilitaires1.44        01/02/2011 12:05:13    Christophe HENRAT Retrait
//      du composant RunOnlyOnceInstance pour le mettre au d?but des projets
// 44   Utilitaires1.43        17/01/2011 16:34:10    Christophe HENRAT pas de
//      Verification en mode portable
// 43   Utilitaires1.42        17/01/2011 10:48:34    Christophe HENRAT
//      Modification de la synchronisation du portable
// 42   Utilitaires1.41        14/01/2011 09:52:09    Florent CHEVILLON
//      Correction pb de r?plic journ?e
// 41   Utilitaires1.40        22/11/2010 10:27:26    Florent CHEVILLON
//      Modification de l'ordre d'ex?cution du push/pull pour la r?plic
//      journ?e.
//      Pull puis Push.
// 40   Utilitaires1.39        01/03/2010 09:41:09    Florent CHEVILLON Modif
//      EkoSport : Pb de deadlocks
// 39   Utilitaires1.38        08/12/2009 14:29:16    Florent CHEVILLON
//      Correction pb de timeout
// 38   Utilitaires1.37        09/10/2009 17:40:45    Florent CHEVILLON
//      Deconnexion/Reconnexion trigger
// 37   Utilitaires1.36        14/09/2009 11:33:29    Florent CHEVILLON
//      Lancement de SM_AVANTREPLI lors des r?plic jour (pour Stocks ATIPIC)
// 36   Utilitaires1.35        26/08/2009 12:19:34    Stan CHAUCHEPRAT
//      compilation 9.1.0.3 en mode release
// 35   Utilitaires1.34        26/06/2009 17:43:21    Florent CHEVILLON Ajout
//      fonction de d?marrage du serveur de secours. Pas actif pour l'instant
// 34   Utilitaires1.33        24/06/2009 17:58:37    Florent CHEVILLON
//      Correction sur probl?me affichage des erreurs autres que paquets
// 33   Utilitaires1.32        23/06/2009 16:46:31    Florent CHEVILLON Init
// 32   Utilitaires1.31        21/04/2009 10:59:01    Florent CHEVILLON
//      v?rification du bon d?roulement de la r?plic avant synchro
// 31   Utilitaires1.30        17/03/2009 16:33:07    Sandrine MEDEIROS
//      Correction pour maj dans GENDOSSIER T-(id base)
// 30   Utilitaires1.29        11/02/2009 15:31:44    Florent CHEVILLON
//      V?rification si monobase avant d'ouvrir la fen de param?trage
// 29   Utilitaires1.28        10/02/2009 23:08:51    Sandrine MEDEIROS maj du
//      test pour attendre le service interbase + pb de chemin des sources
// 28   Utilitaires1.27        10/02/2009 17:24:47    Florent CHEVILLON Ajout
//      connection base prope pour les fenetres cr?e pour la synchro.
//      + v?rification si synchro en cours avant r?plic
// 27   Utilitaires1.26        06/02/2009 15:04:56    Florent CHEVILLON
//      correction message recalcultrigger
// 26   Utilitaires1.25        06/02/2009 14:00:03    Florent CHEVILLON -
//      message ? l'ouverture si pb param synchro enlev?
//      - bug connection ? la base corrig?
// 25   Utilitaires1.24        05/02/2009 11:15:46    Florent CHEVILLON Ajout
//      d'un message lors d'une erreur sur le recalcul des triggers
//      Apr?s la ligne de de la derni?re r?plication r?ussie :
//      'Erreur lors du recalcul des triggers.'
//      'Veuillez contacter GINKOIA.'
// 24   Utilitaires1.23        03/02/2009 14:20:57    Florent CHEVILLON
//      Corrections apr?s test
// 23   Utilitaires1.22        02/02/2009 17:59:53    Florent CHEVILLON
//      correction de bug et ajouts
// 22   Utilitaires1.21        27/01/2009 17:28:21    Florent CHEVILLON ajout
//      petites modifs visiblit? bouton
// 21   Utilitaires1.20        27/01/2009 16:36:41    Florent CHEVILLON
//      Developpement suite
// 20   Utilitaires1.19        23/01/2009 09:14:42    Florent CHEVILLON ajout
//      de la fonction synchroniser qui d?clenche une r?plication push et lance
//      ensuite 'SynchroniserPortable.exe'
// 19   Utilitaires1.18        19/12/2008 11:33:21    Florent CHEVILLON
//      Correction affichage heure de prochaine r?plic journ?e
// 18   Utilitaires1.17        19/12/2008 10:39:00    Florent CHEVILLON
//      Evolutions pour g?rer une r?plication journali?re toutes les x minutes.
// 17   Utilitaires1.16        26/04/2007 16:55:30    Sandrine MEDEIROS
//      Correction pour que la backup ne bloque pas le launcher
// 16   Utilitaires1.15        02/04/2007 15:52:51    Sandrine MEDEIROS Loop en
//      750 + test si backup avant connection base de donn?es
// 15   Utilitaires1.14        02/04/2007 12:27:06    Sandrine MEDEIROS
//      GinkoiaMAP.Verification et MajAuto pour que le backup ne se lance pas
//      pendant la MAJ
// 14   Utilitaires1.13        29/03/2007 16:10:04    Sandrine MEDEIROS
//      lancement backup + verification en meme temps
// 13   Utilitaires1.12        30/01/2007 16:32:53    Sandrine MEDEIROS Mise en
//      place du TimeOUT sur HTTP.Post pour le r?ferencement
// 12   Utilitaires1.11        11/12/2006 16:59:47    Sandrine MEDEIROS
//      Correction IE7
// 11   Utilitaires1.10        10/12/2006 22:32:28    Sandrine MEDEIROS Modif
//      pour le Loop
// 10   Utilitaires1.9         30/11/2006 12:43:43    Sandrine MEDEIROS
//      detection des erreurs log
// 9    Utilitaires1.8         29/11/2006 17:39:18    Sandrine MEDEIROS
//      Am?liorer la gestion du nv msg d'erreur, si replication ok, supprimer
//      le message
// 8    Utilitaires1.7         10/11/2006 14:09:45    Sandrine MEDEIROS
//      chercher "ERROR" dans la page de retour
//      renseigner Mess1 et Mess2 pour les erreurs en cours de r?plication
// 7    Utilitaires1.6         28/06/2006 08:36:40    pascal          Modif
//      pour les XML et plus d'init par rapport au .ini ni de V4
// 6    Utilitaires1.5         14/06/2006 09:23:23    pascal         
//      Modification pour enp?cher la r?plication si ce n'est pas la virgule
//      qui est le s?parateur d?cimale
// 5    Utilitaires1.4         16/11/2005 10:52:57    pascal         
//      Branchement de SM_AVANT_REPLI
// 4    Utilitaires1.3         07/11/2005 08:23:36    pascal          Ajouter
//      les nom pour le referencement, et ne le lancer qu'une fois
// 3    Utilitaires1.2         21/06/2005 09:46:45    pascal         
//      Possibilit? de mettre ? jour les note book pas en r?plication
//      automatique
// 2    Utilitaires1.1         20/05/2005 11:20:28    pascal          Ajout de
//      l'appel automatique au programme de v?rification de la version
// 1    Utilitaires1.0         27/04/2005 10:40:57    pascal          
//$
//$NoKeywords$
//

UNIT LaunchV7_Frm;

INTERFACE

USES
  WinSvc,
  CstLaunch,
  Umapping,
  iniFiles,
  RASAPI,
  Variants,
  Ping_thread,
  FileCtrl,
  registry,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Db,
  ScktComp,
  LMDOneInstance,
  LMDContainerComponent,
  LMDBaseDialog,
  LMDAboutDlg,
  Menus,
  LMDCustomComponent,
  LMDWndProcComponent,
  LMDTrayIcon,
  ExtCtrls,
  IBStoredProc,
  IBDatabase,
  IBCustomDataSet,
  IBQuery,
  StdCtrls,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdHTTP,
  IdIOHandler,
  IdIOHandlerSocket,
  IdIOHandlerStack,
  ImgList,
  dxGDIPlusClasses;

TYPE
  TEtatService = RECORD
    bInstall: Boolean;
    bAutomatique: Boolean;
    bStarted: Boolean;
  END;

TYPE
  TFrm_LaunchV7 = CLASS(TForm)
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    Configuration1: TMenuItem;
    Gestiondesconnexions1: TMenuItem;
    N1: TMenuItem;
    Initialisation1: TMenuItem;
    Od: TOpenDialog;
    data: TIBDatabase;
    IB_Connexion: TIBQuery;
    Tran: TIBTransaction;
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
    ProvideretSubscribers1: TMenuItem;
    Subscribers1: TMenuItem;
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
    Panel1: TPanel;
    Panel2: TPanel;
    Mem_Result: TMemo;
    Button1: TButton;
    Ib_Event: TIBQuery;
    Journaux1: TMenuItem;
    Consomation1: TMenuItem;
    Rplication1: TMenuItem;
    Data_Evt: TIBDatabase;
    tran_evt: TIBTransaction;
    Sp_NewKey_Evt: TIBStoredProc;
    Ib_Divers_Evt: TIBQuery;
    Tray_Launch: TLMDTrayIcon;
    Men_Icon: TPopupMenu;
    AfficherleLauncher1: TMenuItem;
    N2: TMenuItem;
    QuitterleLauncher1: TMenuItem;
    Quitter1: TMenuItem;
    Cacher1: TMenuItem;
    N3: TMenuItem;
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
    Rplication2: TMenuItem;
    Envois1: TMenuItem;
    rception1: TMenuItem;
    N4: TMenuItem;
    Recalculedestriggers1: TMenuItem;
    Pan_Etat: TPanel;
    Lab_Etat1: TLabel;
    Lab_Etat2: TLabel;
    N5: TMenuItem;
    EnvoisenLOOP1: TMenuItem;
    RceptionenLOOP1: TMenuItem;
    RplicationenLOOP1: TMenuItem;
    AboutDlg_Main: TLMDAboutDlg;
    N6: TMenuItem;
    Apropos1: TMenuItem;
    IBStProc_BaseID: TIBStoredProc;
    ConsomationInternet1: TMenuItem;
    N7: TMenuItem;
    IBQue_Last_Repli: TIBQuery;
    IBQue_Last_RepliL_DATE: TDateField;
    IBQue_Last_RepliL_HEURE: TTimeField;
    Rplicationdetouslesmagasins1: TMenuItem;
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
    N8: TMenuItem;
    Referencement1: TMenuItem;
    DataPass: TIBDatabase;
    IBQue_Pass: TIBQuery;
    Tranpass: TIBTransaction;
    serveur: TServerSocket;
    Client: TClientSocket;
    Que_Version: TIBQuery;
    Que_VersionVER_VERSION: TIBStringField;
    IBQue_NextVersion: TIBQuery;
    IBQue_NextVersionPRM_ID: TIntegerField;
    IBQue_NextVersionPRM_CODE: TIntegerField;
    IBQue_NextVersionPRM_INTEGER: TIntegerField;
    IBQue_NextVersionPRM_FLOAT: TFloatField;
    IBQue_NextVersionPRM_STRING: TIBStringField;
    IBQue_NextVersionPRM_TYPE: TIntegerField;
    IBQue_NextVersionPRM_MAGID: TIntegerField;
    IBQue_NextVersionPRM_INFO: TIBStringField;
    IBQue_NextVersionPRM_POS: TIntegerField;
    IBQue_Autrefichier: TIBQuery;
    IBQue_AutrefichierPRM_ID: TIntegerField;
    IBQue_AutrefichierPRM_CODE: TIntegerField;
    IBQue_AutrefichierPRM_INTEGER: TIntegerField;
    IBQue_AutrefichierPRM_FLOAT: TFloatField;
    IBQue_AutrefichierPRM_STRING: TIBStringField;
    IBQue_AutrefichierPRM_TYPE: TIntegerField;
    IBQue_AutrefichierPRM_MAGID: TIntegerField;
    IBQue_AutrefichierPRM_INFO: TIBStringField;
    IBQue_AutrefichierPRM_POS: TIntegerField;
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
    Tim_ReplicJour: TTimer;
    Ib_ReplicJour: TIBQuery;
    Ib_ReplicJourREP_ID: TIntegerField;
    Ib_ReplicJourREP_LAUID: TIntegerField;
    Ib_ReplicJourREP_PING: TIBStringField;
    Ib_ReplicJourREP_PUSH: TIBStringField;
    Ib_ReplicJourREP_PULL: TIBStringField;
    Ib_ReplicJourREP_USER: TIBStringField;
    Ib_ReplicJourREP_PWD: TIBStringField;
    Ib_ReplicJourREP_ORDRE: TIntegerField;
    Ib_ReplicJourREP_URLLOCAL: TIBStringField;
    Ib_ReplicJourREP_URLDISTANT: TIBStringField;
    Ib_ReplicJourREP_PLACEEAI: TIBStringField;
    Ib_ReplicJourREP_PLACEBASE: TIBStringField;
    Btn_ReplicJour: TButton;
    Ib_GetParamReplicJour: TIBQuery;
    Ib_GetParamReplicJourHDEB: TFloatField;
    Ib_GetParamReplicJourHFIN: TFloatField;
    Ib_GetParamReplicJourINTERVALE: TIntegerField;
    Ib_GetParamReplicJourOK: TIntegerField;
    Btn_Synchroniser: TButton;
    Que_CheminServeur: TIBQuery;
    Que_CheminServeurPRM_STRING: TIBStringField;
    N9: TMenuItem;
    Synchronisation: TMenuItem;
    Que_CheminServeurPRM_INTEGER: TIntegerField;
    Que_CheminServeurPRM_FLOAT: TFloatField;
    Que_Bases: TIBQuery;
    Que_BasesBAS_ID: TIntegerField;
    Que_BasesBAS_NOM: TIBStringField;
    Que_BasesBAS_IDENT: TIBStringField;
    Tim_SrvSecours: TTimer;
    Pan_SrvSecours: TPanel;
    IB_SrvSecours_Present: TIBQuery;
    Img_SrvSecours1: TImage;
    Img_SrvSecours2: TImage;
    Lab_SrvSecours: TLabel;
    IBQue_IsPlateforme: TIBQuery;
    IBQue_IsPlateformePF: TIntegerField;
    IBQue_ReferDesactive: TIBQuery;
    IBQue_ReferDesactiveCOUNT: TIntegerField; // FC : 26/06/2009, Ajout Module de surveillance du serveur de secours
    PROCEDURE Initialisation1Click(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Gestiondesconnexions1Click(Sender: TObject);
    PROCEDURE ProvideretSubscribers1Click(Sender: TObject);
    PROCEDURE Subscribers1Click(Sender: TObject);
    PROCEDURE Tim_LanceRepliTimer(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    PROCEDURE Button1Click(Sender: TObject);
    PROCEDURE AfficherleLauncher1Click(Sender: TObject);
    PROCEDURE QuitterleLauncher1Click(Sender: TObject);
    PROCEDURE Quitter1Click(Sender: TObject);
    PROCEDURE Cacher1Click(Sender: TObject);
    PROCEDURE Tray_LaunchDblClick(Sender: TObject);
    PROCEDURE Envois1Click(Sender: TObject);
    PROCEDURE rception1Click(Sender: TObject);
    PROCEDURE Recalculedestriggers1Click(Sender: TObject);
    PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
    PROCEDURE EnvoisenLOOP1Click(Sender: TObject);
    PROCEDURE RceptionenLOOP1Click(Sender: TObject);
    PROCEDURE RplicationenLOOP1Click(Sender: TObject);
    PROCEDURE FormPaint(Sender: TObject);
    PROCEDURE Apropos1Click(Sender: TObject);
    PROCEDURE Consomation1Click(Sender: TObject);
    PROCEDURE ConsomationInternet1Click(Sender: TObject);
    PROCEDURE Rplication1Click(Sender: TObject);
    PROCEDURE Referencement1Click(Sender: TObject);
    PROCEDURE dataBeforeConnect(Sender: TObject);
    PROCEDURE Data_EvtBeforeConnect(Sender: TObject);
    PROCEDURE serveurClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; VAR ErrorCode: Integer);
    PROCEDURE serveurClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    PROCEDURE ClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; VAR ErrorCode: Integer);
    PROCEDURE ClientRead(Sender: TObject; Socket: TCustomWinSocket);
    // FC : 16/12/2008, Ajout du module réplic en journée
    PROCEDURE SetTimerIntervalReplicJour();
    PROCEDURE MajDebFinReplicJour();
    FUNCTION DoReplicJour(): Boolean;
    FUNCTION ReplicJourToDo(): Boolean;
    PROCEDURE Tim_ReplicJourTimer(Sender: TObject);
    PROCEDURE Btn_ReplicJourClick(Sender: TObject);
    PROCEDURE DoReplicJourAndInfo();
    // Fin Ajout FC : 16/12/2008, Ajout du module réplic en journée
    PROCEDURE Btn_SynchroniserClick(Sender: TObject);
    PROCEDURE SynchronisationClick(Sender: TObject);
    // FC : 26/06/2009, Ajout Module de surveillance du serveur de secours
    PROCEDURE Tim_SrvSecoursTimer(Sender: TObject);
    procedure Btn_testClick(Sender: TObject);
    // FC : 26/06/2009, Fin

  PRIVATE
    MyHttp: TIdHTTP; // Accès au moteur Delos 

    PasDeVerifACauseDeSynchro: boolean;
    Interbase7: Boolean;
    ServiceRepl: boolean;
    BaseSauvegarde, isPortableSynchro, isServeur: Boolean;

    // FC : 16/12/2008, Ajout du module réplic en journée
    dtLastReplic: TDateTime; // Dernière réplication, sera sauvée dans un fichier tmp
    dtReplicBegin: TDateTime; // Heure de début de réplication
    dtReplicEnd: TDateTime; // Heure de fin de réplic
    iIntervale: Integer; // Intervale entre deux réplic (en minutes)
    iOrdre: Integer; // Ordre push/pull : 1 = Pull/Push, 2 = Push/Pull

    bReplicJourActif: boolean;

    hNextReplic: TDateTime;

    hDebReplic, hFinReplic: TDateTime; // Date et heure de début et fin de réplic pour ce jour
    // Fin Ajout FC : 16/12/2008, Ajout du module réplic en journée

    strPathBaseServ: STRING; // lab notebook
    boolRecalculOk: boolean; //lab signale l'erreur pour déclencher l'affichage du message d'erreur recalcul
    synchroEnCours: boolean;

    // FC : 26/06/2009, Ajout Module de surveillance du serveur de secours
    bSrvSecours_Present: Boolean;
    dtSrvSecours_PremiereTentative: TDateTime;
    // FC : 26/06/2009, Fin

    bReplicPlateforme: boolean; // Permet de savoir si on est en mode plateforme ou non

    FUNCTION GetTIdHttp(AuserName, APassWord : string; AConnectTimeOut : integer): TIdHttp;
    FUNCTION TrouverlabonneHeure: Boolean;
    FUNCTION Connexion(repli: TLesreplication): Boolean;
    FUNCTION ConnexionModem(Nom, Tel: STRING): Boolean;
    PROCEDURE DeconnexionModem;
    PROCEDURE Deconnexion;
    PROCEDURE connexionTriger(Base: STRING);
    PROCEDURE DeconnexionTriger(Base: STRING);
    PROCEDURE recalculeTriger(Base: STRING);
    PROCEDURE Exec_AvantRepli(Base: STRING);
    FUNCTION PULL(repli: TLesreplication; bForceLoop : boolean = False): Boolean;
    FUNCTION PUSH(repli: TLesreplication; bForceLoop : boolean = False): Boolean;
    FUNCTION LoopPULL(repli: TLesreplication): Boolean;
    FUNCTION LoopPUSH(repli: TLesreplication): Boolean;
    PROCEDURE Ajoute(S: STRING; Vider: Integer);
    PROCEDURE AjouteTC(S: STRING; Vider: Integer);
    PROCEDURE Info;
    PROCEDURE InitEtat;
    PROCEDURE StartService;
    FUNCTION StopService: boolean;
    PROCEDURE Attente_IB;
    // FC : 26/06/2009, Ajout Module de surveillance du serveur de secours
    FUNCTION SrvSecours_EtatService: TEtatService;
    PROCEDURE SrvSecours_Demarre;
    FUNCTION SrvSecours_EstALancer: Boolean;
    PROCEDURE SrvSecoursAffErreur(ANum: Integer = 0; ALibelle: STRING = '');
    // FC : 26/06/2009, Fin

    { Déclarations privées }
  PROTECTED
    encours: Integer;

    IdBase: Integer;
    Basid: Integer; // pour les evts
    LauId: Integer;
    HEURE1: TDateTime;
    H1: Boolean;
    HEURE2: TDateTime;
    H2: Boolean;
    AUTORUN: Boolean;
    ForcerLaMaj: Boolean;

    // FC : 16/12/2008, Ajout du module réplic en journée
    ListeReplicJour: Tlist; // Liste des réplic pour le module jour
    // Fin Ajout FC : 16/12/2008, Ajout du module réplic en journée

    ListeReplication: Tlist;
    ListeConnexion: Tlist;
    ListeReference: TList;
    Connectionencours: TLesConnexion;

    Ping: Tping;
    LaBase0: STRING;

    Path: STRING;

    tempsReplication: TDateTime;

    RepliEnCours: Boolean;

    EtatBackup: Integer; // -1 pas de backup,
    //  1 après la 1° réplication
    //  2 après la 2° réplication
    //  3 à 23 H
    //  4 à 22 H
    //  5 à heure fixe
    HeureBackup: TDateTime;

    ModeDebug: Boolean;

    FirstPaint: Boolean;
    MessMAJ1: STRING;
    MessMAJ2: STRING;
    MessReplicPlateforme: string;
    ReplicOk: boolean; //lab flag réplication ok
    PROCEDURE InsertK(Clef, Table: Integer);
    PROCEDURE InsertK_Evt(Clef, Table: Integer);
    PROCEDURE ModifK(Clef: Integer);
    PROCEDURE DeleteK(Clef: Integer);
    FUNCTION MotDePasse: Boolean;
    PROCEDURE NeedHorraire(BasId: Integer; Prin: Boolean; VAR LauId: Integer; VAR H1: STRING; VAR Valid1: Integer; VAR H2: STRING; VAR Valid2: Integer; VAR Auto: Integer; VAR LaDate: STRING; VAR Back: Integer; VAR BackTime: STRING; VAR ForcerMaj: Boolean; VAR PRM_ID: Integer);
    PROCEDURE NeedConnexion(LAUID: Integer; Conn: TUneConnexion);
    PROCEDURE NeedReplication(LAUID: Integer; Repli: TUneReplication);
    FUNCTION NouvelleClef: Integer;
    FUNCTION NouvelleClef_evt: Integer;
    PROCEDURE Commit;
    PROCEDURE Commit_Evt;
    PROCEDURE InitialiseLaunch;
    FUNCTION VerifChangeHorraire: Boolean;
    // LeType = 0 tous, = 1 Que l'envois, =2 que la réception, =3 que le recalcule
    FUNCTION ReplicationAutomatique(Manuelle, Derniere: Boolean; LeType: Byte; LOOP: Boolean = False): Boolean;
    PROCEDURE Event(Base: STRING; LeType: Integer; Ok: Boolean; Temps: Variant);

    FUNCTION LancementBackup: Boolean;
    FUNCTION Lancementdesreferencements(Num: Integer; Rep: TLesreplication): boolean;
    PROCEDURE boutonSynchro(msgError: Integer);
    FUNCTION SourceToURL(AURL: STRING; ASource: TStrings): STRING;
  PUBLIC
    PROCEDURE InitPing(Url: STRING; temps: DWord);
    PROCEDURE StopPing;
  END;

VAR
  Frm_LaunchV7: TFrm_LaunchV7;

IMPLEMENTATION
USES
  Base_Frm,
  ProvSubs_frm,
  Reference_Frm,
  Question_Frm,
  Conso_Frm,
  LaunchV7_Dm,
  SuiviReplic_Frm,
  ParamSynchro_Frm,
  ListeSynchro_Frm;
//  ,ListProSub_Frm;

{$R *.DFM}
VAR
  AppliTourne: boolean;
  Lapplication: STRING;

FUNCTION EnumerateTourne(hwnd: HWND; Param: LPARAM): Boolean; STDCALL; FAR;
VAR
  lpClassName: ARRAY[0..999] OF Char;
  lpClassName2: ARRAY[0..999] OF Char;
  //Handle: DWORD;
 // lpdwProcessId: Pointer;
BEGIN
  result := true;
  Windows.GetClassName(hWnd, lpClassName, 500);
  IF Uppercase(StrPas(lpClassName)) = 'TAPPLICATION' THEN
  BEGIN
    Windows.GetWindowText(hWnd, lpClassName2, 500);
    IF Uppercase(StrPas(lpClassName2)) = Lapplication THEN
    BEGIN
      AppliTourne := True;
      result := False;
    END;
  END;
END;

//---------------------------------------------------------------
// Initialisation de l'application
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.StartService;
VAR
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  tempMini: DWORD;
  CheckPoint: DWORD;
BEGIN
  IF NOT Interbase7 THEN EXIT;
  IF ServiceRepl THEN // ne redemarer le service que si on la arrété
  BEGIN
    hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
    hService := OpenService(hSCManager, 'IBRepl', SERVICE_QUERY_STATUS OR SERVICE_START OR SERVICE_STOP OR SERVICE_PAUSE_CONTINUE);
    IF hService <> 0 THEN
    BEGIN // Service non installé
      QueryServiceStatus(hService, Statut);
      tempMini := Statut.dwWaitHint + 10;
      ControlService(hService, SERVICE_CONTROL_CONTINUE, Statut);
      REPEAT
        CheckPoint := Statut.dwCheckPoint;
        Sleep(tempMini);
        QueryServiceStatus(hService, Statut);
      UNTIL (CheckPoint = Statut.dwCheckPoint) OR
        (statut.dwCurrentState = SERVICE_RUNNING);
      // si CheckPoint = Statut.dwCheckPoint Alors le service est dans les choux
    END;
    CloseServiceHandle(hService);
    CloseServiceHandle(hSCManager);
  END;
END;

FUNCTION TFrm_LaunchV7.StopService: boolean;
VAR
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  tempMini: DWORD;
  CheckPoint: DWORD;
BEGIN
  result := false;
  IF NOT Interbase7 THEN EXIT;
  hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
  hService := OpenService(hSCManager, 'IBRepl', SERVICE_QUERY_STATUS OR SERVICE_START OR SERVICE_STOP OR SERVICE_PAUSE_CONTINUE);
  IF hService = 0 THEN
  BEGIN // Service non installé
    ServiceRepl := False;
  END
  ELSE
  BEGIN
    QueryServiceStatus(hService, Statut);
    IF statut.dwCurrentState = SERVICE_RUNNING THEN
    BEGIN
      ServiceRepl := true;
      tempMini := Statut.dwWaitHint + 10;
      ControlService(hService, SERVICE_CONTROL_PAUSE, Statut);
      REPEAT
        CheckPoint := Statut.dwCheckPoint;
        Sleep(tempMini);
        QueryServiceStatus(hService, Statut);
      UNTIL (CheckPoint = Statut.dwCheckPoint) OR
        (statut.dwCurrentState = SERVICE_PAUSED);
      // si CheckPoint = Statut.dwCheckPoint Alors le service est dans les choux
      result := true;
    END
    ELSE
    BEGIN
      ServiceRepl := False;
    END;
  END;
  CloseServiceHandle(hService);
  CloseServiceHandle(hSCManager);
END;

PROCEDURE TFrm_LaunchV7.Attente_IB;
VAR
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  tempMini: DWORD;
  CheckPoint: DWORD;
  NbBcl: Integer;
BEGIN
  hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
  hService := OpenService(hSCManager, 'InterBaseGuardian', SERVICE_QUERY_STATUS);
  IF hService <> 0 THEN
  BEGIN // Service non installé
    QueryServiceStatus(hService, Statut);
    CheckPoint := 0;
    NbBcl := 0;
    WHILE (statut.dwCurrentState <> SERVICE_RUNNING) OR
      (CheckPoint <> Statut.dwCheckPoint) DO
    BEGIN
      CheckPoint := Statut.dwCheckPoint;
      tempMini := Statut.dwWaitHint + 1000;
      Sleep(tempMini);
      QueryServiceStatus(hService, Statut);
      Inc(nbBcl);
      IF NbBcl > 900 THEN BREAK;
    END;
    IF NbBcl < 900 THEN
    BEGIN
      CloseServiceHandle(hService);
      hService := OpenService(hSCManager, 'InterBaseServer', SERVICE_QUERY_STATUS);
      IF hService <> 0 THEN
      BEGIN // Service non installé
        QueryServiceStatus(hService, Statut);
        CheckPoint := 0;
        NbBcl := 0;
        WHILE (statut.dwCurrentState <> SERVICE_RUNNING) OR
          (CheckPoint <> Statut.dwCheckPoint) DO
        BEGIN
          CheckPoint := Statut.dwCheckPoint;
          tempMini := Statut.dwWaitHint + 1000;
          Sleep(tempMini);
          QueryServiceStatus(hService, Statut);
          Inc(nbBcl);
          IF NbBcl > 900 THEN BREAK;
        END;
      END;
    END;
  END;
  CloseServiceHandle(hService);
  CloseServiceHandle(hSCManager);
END;

PROCEDURE TFrm_LaunchV7.FormCreate(Sender: TObject);
VAR
  reg: TRegistry;
  dw: dword;
  Nbessai: Integer;
  ok: boolean;
  S: STRING;
  iIdBase: Integer;
  TpListe: TStringList;
BEGIN
  PasDeVerifACauseDeSynchro :=false;
  MessMAJ1 := '';
  MessMAJ2 := '';
  reg := Tregistry.Create;
  TRY
    reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
    S := Reg.ReadString('Version');
  FINALLY
    reg.free;
  END;
  Interbase7 := Copy(S, 1, 5) = 'WI-V7';
  IF interbase7 THEN
  BEGIN
    TRY
      serveur.active := true;
    EXCEPT
    END;
  END;

  Attente_IB;

  ListeReplication := NIL;
  ListeConnexion := NIL;
  ListeReference := NIL;

  ListeReplicJour := NIL; // FC : 16/12/2008, Ajout du module réplic en journée

  ok := false;

  FOR Nbessai := 0 TO 50 DO
  BEGIN
    TRY
      FirstPaint := true;
      IF (ParamCount > 0) AND (Uppercase(paramstr(1)) = 'DEBUG') THEN
        ModeDebug := True
      ELSE
        ModeDebug := False;

      EtatBackup := -1;
      RepliEnCours := False;
      // Lecture la base de référence
      Path := extractFilePath(Application.exename);
      IF path[length(path)] <> '\' THEN
        Path := Path + '\';

      IF ListeReplication = NIL THEN
        ListeReplication := Tlist.Create;
      IF ListeConnexion = NIL THEN
        ListeConnexion := Tlist.Create;
      IF ListeReference = NIL THEN
        ListeReference := TList.Create;

      IF ListeReplicJour = NIL THEN // FC : 16/12/2008, Ajout du module réplic en journée
        ListeReplicJour := Tlist.Create; // FC : 16/12/2008, Ajout du module réplic en journée

      reg := TRegistry.Create(KEY_READ);
      TRY
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
        Labase0 := reg.ReadString('Base0');

        IF Labase0 = '' THEN
        BEGIN
          IF (paramCount > 0) AND (uppercase(paramstr(1)) = 'AUTOINIT') THEN
          BEGIN
            Initialisation1.visible := true;
            Show;
            EXIT;
          END
          ELSE
          BEGIN
            Application.MessageBox('L''initialisation du Launcher doit être faite', 'Attention', Mb_Ok);
            Initialisation1.visible := true;
            Show;
            EXIT;
          END;
        END;
      FINALLY
        reg.closekey;
        reg.free;
      END;

      WHILE MapGinkoia.Backup DO
      BEGIN
        Sleep(5 * 60 * 1000);
      END;

      Dm_LaunchV7.ConnectDataBase(LaBase0);
      Event(Labase0, CstLancementProgramme, true, Null);
      VerifChangeHorraire;
      InitialiseLaunch;
      IB_LABASE.Open;
      iIdBase := IB_LABASEBAS_ID.AsInteger;
      S := IB_LABASEBAS_NOM.AsString;
      S := Uppercase(copy(S, Length(S) - 3, 4));
      BaseSauvegarde := S = '_SEC';
      IB_LABASE.Close;

      // FC : 26/06/2009 : Ajout fonction lancement du serveur de secours.
      // Récupération de l'info si on attend ou non un serveur de secours
      TRY
        IB_SrvSecours_Present.ParamByName('BASID').AsInteger := iIdBase;
        IB_SrvSecours_Present.Open;
        bSrvSecours_Present := IB_SrvSecours_Present.FieldByName('PRM_INTEGER').AsInteger = 1;
        IB_SrvSecours_Present.Close;
      EXCEPT
        bSrvSecours_Present := False;
      END;

      TRY
        IBQue_IsPlateforme.Open;
        bReplicPlateforme := IBQue_IsPlateforme.FieldByName('PF').AsInteger <> 0;
        IBQue_IsPlateforme.Close;
      EXCEPT
        bReplicPlateforme := False;
      END;

      // Désactivé pour l'instant
      // Si le serveur de secours n'est pas lancé mais devrait l'être, on envoie
//      IF SrvSecours_EstALancer THEN
//      BEGIN
//        Tim_SrvSecours.Interval := 1000; // tempo de 1 seconde
//        Tim_SrvSecours.Enabled := True;
//      END;

      IF (Dm_LaunchV7.NbMag > 1) THEN
      BEGIN
        ConsomationInternet1.visible := True;
      END;
      Dm_LaunchV7.ClosedataBase;
      ok := true;
      BREAK;
    EXCEPT
      dw := GetTickCount + (5000);
      WHILE dw > GetTickCount DO
      BEGIN
        Sleep(500);
        application.processmessages;
      END;
    END;
  END;
  IF NOT ok THEN
    Ajoute('Attention : pas de connexion à la base - JOINDRE GINKOIA -', 0);

  //régler la visibilité du bouton et du menu synchroniser
  boutonSynchro(0);
  // attendre 1h et recommencer

  // info de la dernière réplication réussi
  if isPortableSynchro then
  begin
    s := ExtractFilePath(ParamStr(0));
    if s[Length(s)]<>'\' then
      s:=s+'\';
    s := s+'Synchro.ok';
    if FileExists(s) then
    begin
      TpListe:=TStringList.Create;
      try
        TpListe.LoadFromFile(s);
        if TpListe.Count>0 then
        begin
          s := TpListe[0];
          Ajoute(s,0);
        end;
      except
      end;
      FreeAndNil(TpListe);
    end;
  end;

  // On affiche systématiquement le launcher.
  Show;
END;

//---------------------------------------------------------------
// Libération des variables
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.FormDestroy(Sender: TObject);
VAR
  i: Integer;
BEGIN
  FOR i := 0 TO ListeReplication.Count - 1 DO
    TLesreplication(ListeReplication[i]).Free;
  ListeReplication.free;
  FOR i := 0 TO ListeConnexion.Count - 1 DO
    TLesConnexion(ListeConnexion[i]).free;
  ListeConnexion.free;
  FOR i := 0 TO ListeReference.Count - 1 DO
    TLesReference(ListeReference[i]).Free;
  ListeReference.Free;

  // FC : 16/12/2008, Ajout du module réplic en journée
  FOR i := 0 TO ListeReplicJour.Count - 1 DO
    TLesReference(ListeReplicJour[i]).Free;
  ListeReplicJour.Free;
  // Fin Ajout FC : 16/12/2008, Ajout du module réplic en journée

  Event(Labase0, CstFermetureProgramme, true, Null);
END;

//---------------------------------------------------------------
// Passage de V7 à V4
//---------------------------------------------------------------

//---------------------------------------------------------------
// Initialisation de La base maitre
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.Initialisation1Click(Sender: TObject);
VAR
  reg: TRegistry;
BEGIN
  // Initialisation de la base de référence
  IF (sender = NIL) OR (MotDePasse) THEN
  BEGIN
    Initialisation1.Visible := false;
    IF Od.Execute THEN
    BEGIN
      IF od.filename <> Labase0 THEN
      BEGIN
        Labase0 := od.filename;
        TRY
          reg := TRegistry.Create(KEY_WRITE);
          TRY
            reg.RootKey := HKEY_LOCAL_MACHINE;
            reg.OpenKey('SOFTWARE\Algol\Ginkoia', True);
            reg.WriteString('Base0', Labase0);
          FINALLY
            reg.closekey;
            reg.free;
          END;
        EXCEPT
          Application.MessageBox('Les droits Administrateur sont Obligatoire pour modifier les registres', 'Attention', Mb_Ok);
        END;
        InitialiseLaunch;
        Event(Labase0, CstInitialisationBase, true, Null);
      END;
    END;
  END;
END;

//---------------------------------------------------------------
// Lecture des données de la réplication (Base horraire etc)
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.InitEtat;
VAR
  D: Dword;
BEGIN
  Lab_Etat1.Caption := '';
  IF AUTORUN THEN
    Lab_Etat1.Caption := Lab_Etat1.Caption + 'Automatique ';
  IF H1 AND H2 THEN
    Lab_Etat1.Caption := Lab_Etat1.Caption + '2 réplications ';
  IF EtatBackup = 5 THEN
    Lab_Etat1.Caption := Lab_Etat1.Caption + 'Backup ';

  Lab_Etat2.Caption := '';
  IF ModeDebug OR (GetTickCount > 3 * 24 * 60 * 60 * 1000) THEN
  BEGIN
    IF GetTickCount > 5 * 24 * 60 * 60 * 1000 THEN
    BEGIN
      D := GetTickCount;
      D := D DIV 1000;
      D := D DIV 60;
      D := D DIV 60;
      D := D DIV 24;
      Lab_Etat2.Caption := 'Votre ordinateur n''a pas redémarré depuis plus de ' + Inttostr(D) + ' jours'
    END
    ELSE IF GetTickCount > 4 * 24 * 60 * 60 * 1000 THEN
      Lab_Etat2.Caption := 'Votre ordinateur n''a pas redémarré depuis plus de 4 jours'
    ELSE IF GetTickCount > 3 * 24 * 60 * 60 * 1000 THEN
      Lab_Etat2.Caption := 'Votre ordinateur n''a pas redémarré depuis plus de 3 jours'
    ELSE IF GetTickCount > 2 * 24 * 60 * 60 * 1000 THEN
      Lab_Etat2.Caption := 'Votre ordinateur n''a pas redémarré depuis plus de 2 jours'
    ELSE IF GetTickCount > 1 * 24 * 60 * 60 * 1000 THEN
      Lab_Etat2.Caption := 'Votre ordinateur n''a pas redémarré depuis plus d''un jour'
    ELSE
      Lab_Etat2.Caption := 'Votre ordinateur à redémaré depuis moins d''un jours';
  END;
END;

PROCEDURE TFrm_LaunchV7.InitialiseLaunch;
VAR
  reg: TRegistry;
  k: integer;
  j: integer;
  i: integer;
  repli: TLesreplication;
  Prov: TLesProvider;
  connex: TLesConnexion;
  s: STRING;
  Hh, Mm, Ss, Dd: Word;
  h: integer;
  ini: tinifile;

  ref: TLesReference;
  RefLig: TLesReferenceLig;
BEGIN
  IF ModeDebug THEN Ajoute('Initialisation du launch ', 0);
  EtatBackup := -1;
  //initialiser la variable d'erreur de recalcul des trigger
  boolRecalculOk := true;
  synchroEnCours := false; //flag signalant qu'un synchro est en cours
  // Récupération des données de la réplication
  Tim_LanceRepli.enabled := false;
  TRY
    data.close;
    TRY
      data.DatabaseName := LaBase0;
      TRY
        data.Open;
      EXCEPT
        IF ModeDebug THEN Ajoute('Problème connexion à la base InitialiseLaunch ', 0);
        RAISE;
      END;
      tran.Active := true;
      // récupération de l'Id de la base 0
      Ib_LaBase.Open;
      IdBase := IB_LaBaseBAS_ID.Asinteger;
      Ib_LaBase.Close;

      // Récupération des horraires
      Ib_Horraire.ParamByName('BasId').AsInteger := IdBase;
      Ib_Horraire.Open;
      LAUID := Ib_HorraireLAU_ID.AsInteger;
      HEURE1 := Ib_HorraireLAU_HEURE1.AsDateTime;
      H1 := Ib_HorraireLAU_H1.AsInteger = 1;
      HEURE2 := Ib_HorraireLAU_HEURE2.AsDateTime;
      H2 := Ib_HorraireLAU_H2.AsInteger = 1;
      AUTORUN := Ib_HorraireLAU_AUTORUN.AsInteger = 1;

      IF Ib_HorraireLAU_BACK.AsInteger = 1 THEN
      BEGIN
        EtatBackup := 5;
        HeureBackup := Ib_HorraireLAU_BACKTIME.AsDateTime;
      END;

      Ib_Horraire.Close;

      IB_ForceMAJ.ParamByName('BasId').AsInteger := IdBase;
      IB_ForceMAJ.Open;
      ForcerLaMaj := IB_ForceMAJPRM_POS.AsInteger = 1;
      IB_ForceMAJ.Close;

      // Vérification du lancement automatique
      TRY
        reg := TRegistry.Create(KEY_WRITE);
        TRY
          reg.RootKey := HKEY_LOCAL_MACHINE;
          reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False);

          IF Autorun THEN
            reg.WriteString('Launch_Replication', Application.ExeName)
          ELSE
            reg.DeleteValue('Launch_Replication');
        FINALLY
          reg.closekey;
          reg.free;
        END;
      EXCEPT
        Ajoute(DateTimeToStr(Now) + '   ' + 'Problème de modification des registres', 0);
      END;

      IF ModeDebug THEN Ajoute('Libération des listes ', 0);
      FOR i := 0 TO ListeReplication.Count - 1 DO
        TLesreplication(ListeReplication[i]).Free;
      ListeReplication.Clear;
      FOR i := 0 TO ListeConnexion.Count - 1 DO
        TLesConnexion(ListeConnexion[i]).free;
      ListeConnexion.clear;
      FOR i := 0 TO ListeReference.Count - 1 DO
        TLesReference(ListeReference[i]).Free;
      ListeReference.Clear;

      // FC : 16/12/2008, Ajout du module réplic en journée
      FOR i := 0 TO ListeReplicJour.Count - 1 DO
        TLesReference(ListeReplicJour[i]).Free;
      ListeReplicJour.Clear;
      // Fin Ajout FC : 16/12/2008, Ajout du module réplic en journée

      // Lecture des connexions
      IB_Connexion.ParamByName('Lauid').AsInteger := LauId;
      IB_Connexion.Open;
      IB_Connexion.First;
      WHILE NOT IB_Connexion.Eof DO
      BEGIN
        connex := TLesConnexion.Create;
        connex.Id := IB_ConnexionCON_ID.AsInteger;
        connex.Nom := IB_ConnexionCON_NOM.AsString;
        connex.TEL := IB_ConnexionCON_TEL.AsString;
        connex.LeType := IB_ConnexionCON_TYPE.AsInteger;
        ListeConnexion.Add(connex);
        IB_Connexion.Next;
      END;
      IB_Connexion.Close;
      // Lecture des données de réplication
      IF ModeDebug THEN Ajoute('Lecture des données de réplication ', 0);

      // FC : 16/12/2008, Ajout du module réplic en journée
      bReplicJourActif := False;

      MajDebFinReplicJour();

      Ib_ReplicJour.ParamByName('Lauid').AsInteger := LauId;
      Ib_ReplicJour.Open;
      Ib_ReplicJour.First;

      WHILE NOT Ib_ReplicJour.Eof DO
      BEGIN
        Repli := TLesreplication.Create;
        repli.ID := Ib_ReplicJourREP_ID.AsInteger;
        repli.Ping := Ib_ReplicJourREP_PING.AsString;
        repli.Push := Ib_ReplicJourREP_PUSH.AsString;
        repli.Pull := Ib_ReplicJourREP_PULL.AsString;
        repli.User := Ib_ReplicJourREP_USER.AsString;
        repli.PWD := Ib_ReplicJourREP_PWD.AsString;
        repli.URLLocal := Ib_ReplicJourREP_URLLOCAL.AsString;
        repli.URLDISTANT := Ib_ReplicJourREP_URLDISTANT.AsString;
        repli.PlaceEai := Ib_ReplicJourREP_PLACEEAI.AsString;
        repli.PlaceBase := Ib_ReplicJourREP_PLACEBASE.AsString;

        ListeReplicJour.Add(Repli);

        Ib_ProvRepli.ParamByName('REPID').AsInteger := Ib_ReplicJourREP_ID.AsInteger;
        Ib_ProvRepli.Open;
        Ib_ProvRepli.First;
        WHILE NOT Ib_ProvRepli.Eof DO
        BEGIN
          Prov := TLesProvider.Create;
          prov.ID := Ib_ProvRepliPRO_ID.AsInteger;
          prov.Nom := Ib_ProvRepliPRO_NOM.AsString;
          prov.Loop := Ib_ProvRepliPRO_LOOP.Asinteger;
          repli.ListProvider.Add(Prov);
          Ib_ProvRepli.next;
        END;
        Ib_ProvRepli.Close;
        Ib_SubsRepli.ParamByName('REPID').AsInteger := Ib_ReplicJourREP_ID.AsInteger;
        Ib_SubsRepli.Open;
        Ib_SubsRepli.First;
        WHILE NOT Ib_SubsRepli.Eof DO
        BEGIN
          Prov := TLesProvider.Create;
          prov.ID := Ib_SubsRepliSUB_ID.AsInteger;
          prov.Nom := Ib_SubsRepliSUB_NOM.AsString;
          prov.Loop := Ib_SubsRepliSUB_LOOP.Asinteger;
          repli.ListSubScriber.Add(Prov);
          Ib_SubsRepli.next;
        END;
        Ib_SubsRepli.Close;
        Ib_ReplicJour.Next;
      END;
      Ib_ReplicJour.Close;

      // Fin Ajout FC : 16/12/2008, Ajout du module réplic en journée

      Ib_Replication.ParamByName('Lauid').AsInteger := LauId;
      Ib_Replication.Open;
      Ib_Replication.First;
      // Création des objets contenant chaque dossier de réplication
      // Avec les providers et subscribers associés
      WHILE NOT Ib_Replication.Eof DO
      BEGIN
        Repli := TLesreplication.Create;
        repli.ID := Ib_ReplicationREP_ID.AsInteger;
        repli.Ping := Ib_ReplicationREP_PING.AsString;
        repli.Push := Ib_ReplicationREP_PUSH.AsString;
        repli.Pull := Ib_ReplicationREP_PULL.AsString;
        repli.User := Ib_ReplicationREP_USER.AsString;
        repli.PWD := Ib_ReplicationREP_PWD.AsString;
        repli.URLLocal := Ib_ReplicationREP_URLLOCAL.AsString;
        repli.URLDISTANT := Ib_ReplicationREP_URLDISTANT.AsString;
        repli.PlaceEai := Ib_ReplicationREP_PLACEEAI.AsString;
        repli.PlaceBase := Ib_ReplicationREP_PLACEBASE.AsString;

        ListeReplication.Add(repli);
        Ib_ProvRepli.ParamByName('REPID').AsInteger := Ib_ReplicationREP_ID.AsInteger;
        Ib_ProvRepli.Open;
        Ib_ProvRepli.First;
        WHILE NOT Ib_ProvRepli.Eof DO
        BEGIN
          Prov := TLesProvider.Create;
          prov.ID := Ib_ProvRepliPRO_ID.AsInteger;
          prov.Nom := Ib_ProvRepliPRO_NOM.AsString;
          prov.Loop := Ib_ProvRepliPRO_LOOP.Asinteger;
          repli.ListProvider.Add(Prov);
          Ib_ProvRepli.next;
        END;
        Ib_ProvRepli.Close;
        Ib_SubsRepli.ParamByName('REPID').AsInteger := Ib_ReplicationREP_ID.AsInteger;
        Ib_SubsRepli.Open;
        Ib_SubsRepli.First;
        WHILE NOT Ib_SubsRepli.Eof DO
        BEGIN
          Prov := TLesProvider.Create;
          prov.ID := Ib_SubsRepliSUB_ID.AsInteger;
          prov.Nom := Ib_SubsRepliSUB_NOM.AsString;
          prov.Loop := Ib_SubsRepliSUB_LOOP.Asinteger;
          repli.ListSubScriber.Add(Prov);
          Ib_SubsRepli.next;
        END;
        Ib_SubsRepli.Close;
        Ib_Replication.Next;
      END;
      Ib_Replication.Close;


      // Lecture des données sup
      IBQue_Reference.Close;
      IBQue_Reference.Open;
      WHILE NOT IBQue_Reference.Eof DO
      BEGIN
        // Controle, pour savoir si on doit traiter cette ligne de référencement.
        IBQue_ReferDesactive.ParamByName('BASID').asInteger := IdBase;
        IBQue_ReferDesactive.ParamByName('RREID').asInteger := IBQue_ReferenceRRE_ID.AsInteger;
        IBQue_ReferDesactive.Open;
        if IBQue_ReferDesactive.Fields[0].AsInteger = 0 then
        begin
          Ref := TLesReference.Create;
          ref.ID := IBQue_ReferenceRRE_ID.AsInteger;
          ref.Position := IBQue_ReferenceRRE_POSITION.AsInteger;
          ref.Place := IBQue_ReferenceRRE_PLACE.AsInteger;
          ref.URL := IBQue_ReferenceRRE_URL.AsString;
          ref.Ordre := IBQue_ReferenceRRE_ORDRE.AsString;
          ListeReference.Add(Ref);
          IBQue_RefLig.ParamByName('RREID').AsInteger := IBQue_ReferenceRRE_ID.AsInteger;
          IBQue_RefLig.Open;
          WHILE NOT IBQue_RefLig.Eof DO
          BEGIN
            RefLig := TLesReferenceLig.Create;
            RefLig.ID := IBQue_RefLigRRL_ID.AsInteger;
            RefLig.PARAM := IBQue_RefLigRRL_PARAM.AsString;
            ref.LesLig.Add(RefLig);

            IBQue_RefLig.next;
          END;
          IBQue_RefLig.Close;
        end;
        IBQue_ReferDesactive.Close;

        IBQue_Reference.Next;
      END;
      IBQue_Reference.Close;

      IF ListeReplication.Count < 1 THEN
      BEGIN
        H1 := False;
        H2 := False;
      END;
    FINALLY
      data.close;
    END;

    IF ModeDebug THEN Ajoute('Verif etat backup ', 0);
    IF EtatBackup <> 5 THEN
    BEGIN
      // temps du backup
      IF ModeDebug THEN Ajoute('backup <>5 ', 0);
      IF Fileexists(IncludeTrailingBackslash(ExtractFileName(application.ExeName)) + 'ginkoia.ini') THEN
        S := IncludeTrailingBackslash(ExtractFileName(application.ExeName))
      ELSE IF Fileexists('C:\Ginkoia\ginkoia.ini') THEN
        S := 'C:\Ginkoia\'
      ELSE IF Fileexists('D:\Ginkoia\ginkoia.ini') THEN
        S := 'D:\Ginkoia\';
      S := S + 'BackRest.ini';
      ini := Tinifile.create(S);
      TRY
        i := Ini.readinteger('TPS', 'TPS', 0);
      FINALLY
        ini.free;
      END;
      IF ModeDebug THEN Ajoute('Calcule du temps ', 0);
      IF i = 0 THEN
        i := 60 * 4
      ELSE
      BEGIN
        i := trunc((i * 1.25) / 1000) DIV 60;
        IF i < 60 THEN
          i := 60;
      END;
      IF NOT (H1) AND NOT (H2) THEN
      BEGIN
        EtatBackup := 3; // à 23 Heures
      END
      ELSE IF H1 AND NOT (H2) THEN
      BEGIN
        decodeTime(HEURE1, Hh, Mm, Ss, Dd);
        h := hh - 22;
        IF h < 0 THEN h := h + 24;
        j := h * 60 + mm;
        IF j + i < 9 * 60 THEN
          etatBackup := 1
        ELSE
          etatBackup := 3
      END
      ELSE
      BEGIN // H2 et H1
        decodeTime(HEURE2, Hh, Mm, Ss, Dd);
        h := hh - 22;
        IF h < 0 THEN h := h + 24;
        j := h * 60 + mm;
        IF J + i < 9 * 60 THEN
          etatBackup := 2
        ELSE
        BEGIN
          decodeTime(HEURE1, Hh, Mm, Ss, Dd);
          h := hh - 22;
          IF h < 0 THEN H := H + 24;
          IF h > 9 THEN
            etatBackup := 3
          ELSE
          BEGIN
            k := h * 60 + mm;
            IF k + i < j THEN
              etatBackup := 1
            ELSE IF k - i > 0 THEN
              etatBackup := 4;
          END;
        END;
      END;
    END;
    IF ModeDebug THEN Ajoute('Fin ', 0);
    Info;
  FINALLY
    Tim_LanceRepliTimer(NIL);
    // FC : 16/12/2008, Ajout du module réplic en journée
    IF bReplicJourActif THEN
    BEGIN
      SetTimerIntervalReplicJour();
      Tim_ReplicJour.Enabled := True; // Lance le timer
      Btn_ReplicJour.Visible := True;
    END
    ELSE BEGIN
      Btn_ReplicJour.Visible := False;
    END;
    // Fin Ajout FC : 16/12/2008, Ajout du module réplic en journée
  END;
  //
END;

//---------------------------------------------------------------
// Initialisation des connexions
//---------------------------------------------------------------

//---------------------------------------------------------------
// Procedure de call back (pour centraliser les requêtes)
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.NeedHorraire(BasId: Integer; Prin: Boolean; VAR LauId: Integer; VAR H1: STRING;
  VAR Valid1: Integer; VAR H2: STRING; VAR Valid2, Auto: Integer; VAR LaDate: STRING;
  VAR Back: Integer; VAR BackTime: STRING; VAR ForcerMaj: Boolean; VAR PRM_ID: Integer);
VAR
  Clef: Integer;
BEGIN
  IF prin THEN
  BEGIN
    // horraire de réplication
    Ib_Horraire.ParamByName('BASID').Asinteger := BasId;
    Ib_Horraire.Open;
    IF Ib_Horraire.IsEmpty THEN
    BEGIN
      Clef := NouvelleClef;
      Ib_Divers.Sql.Clear;
      Ib_Divers.Sql.Add('Insert Into GENLAUNCH');
      Ib_Divers.Sql.Add(' (LAU_ID, LAU_BASID, LAU_H1, LAU_H2, LAU_AUTORUN,LAU_BACK) ');
      Ib_Divers.Sql.Add(' VALUES (' + Inttostr(clef) + ',' + InttoStr(BasId) + ',0,0,0,0)');
      Ib_Divers.ExecSQL;
      InsertK(Clef, CstTblLaunch);
      Commit;
      Ib_Horraire.Close;
      Ib_Horraire.ParamByName('BASID').Asinteger := BasId;
      Ib_Horraire.Open;
    END;
    H1 := FormatDateTime('HH:NN', Ib_HorraireLAU_HEURE1.AsDateTime);
    Valid1 := Ib_HorraireLAU_H1.AsInteger;
    H2 := FormatDateTime('HH:NN', Ib_HorraireLAU_HEURE2.AsDateTime);
    Valid2 := Ib_HorraireLAU_H2.Asinteger;
    Auto := Ib_HorraireLAU_AUTORUN.AsInteger;
    LauId := Ib_HorraireLAU_Id.AsInteger;
    Back := Ib_HorraireLAU_Back.AsInteger;
    BackTime := FormatDateTime('HH:NN', Ib_HorraireLAU_BackTime.AsDateTime);
    Ib_Horraire.Close;
    IB_ForceMAJ.ParamByName('BASID').Asinteger := BasId;
    IB_ForceMAJ.Open;
    IF IB_ForceMAJ.isempty THEN
    BEGIN
      Clef := NouvelleClef;
      InsertK(Clef, CstTblGENPARAM);
      Ib_Divers.Sql.Clear;
      Ib_Divers.Sql.Add('Insert Into GENPARAM');
      Ib_Divers.Sql.Add(' (PRM_ID, PRM_CODE, PRM_INTEGER, PRM_FLOAT, PRM_STRING, PRM_TYPE, PRM_MAGID, PRM_INFO, PRM_POS) ');
      Ib_Divers.Sql.Add(' VALUES (' + Inttostr(clef) + ',666,' + Inttostr(BasId) + ',0,'''',1999,0,''Forcer la MAJ'',0)');
      Ib_Divers.ExecSQL;
      Commit;
      IB_ForceMAJ.Close;
      IB_ForceMAJ.Open;
    END;
    ForcerMAJ := IB_ForceMAJPRM_POS.AsInteger = 1;
    PRM_ID := IB_ForceMAJPRM_ID.AsInteger;
    IB_ForceMAJ.Close;
  END
  ELSE
  BEGIN
    // horraire prédéfinie
    ForcerMaj := False;
    PRM_ID := 0;
    IB_Divers.sql.clear;
    IB_Divers.sql.add('SELECT CHA_HEURE1, CHA_H1, CHA_HEURE2, CHA_H2, CHA_AUTORUN, CHA_ACTIVER, CHA_BACK, CHA_BACKTIME');
    IB_Divers.sql.add('FROM GENCHANGELAUNCH JOIN K ON (K_ID=CHA_ID AND K_ENABLED=1)');
    IB_Divers.sql.add('WHERE CHA_ACTIVE=0');
    IB_Divers.sql.add('  AND CHA_LAUID=' + EnStr(LauID));
    IB_Divers.Open;
    IF IB_Divers.IsEmpty THEN
    BEGIN
      H1 := '';
      Valid1 := 0;
      H2 := '';
      Valid2 := 0;
      Auto := 0;
      LaDate := '';
      Back := 0;
      BackTime := '';
    END
    ELSE
    BEGIN
      H1 := IB_Divers.Fields[0].AsString;
      Valid1 := IB_Divers.Fields[1].AsInteger;
      H2 := IB_Divers.Fields[2].AsString;
      Valid2 := IB_Divers.Fields[3].AsInteger;
      Auto := IB_Divers.Fields[4].AsInteger;
      LaDate := IB_Divers.Fields[5].AsString;
      BackTime := IB_Divers.Fields[7].AsString;
      Back := IB_Divers.Fields[6].AsInteger;
    END;
    IB_Divers.Close;
  END;
END;

PROCEDURE TFrm_LaunchV7.NeedConnexion(LAUID: Integer; Conn: TUneConnexion);
BEGIN
  //
  IB_Connexion.Close;
  IB_Connexion.ParamByName('LAUID').AsInteger := LAUID;
  IB_Connexion.Open;
  WHILE NOT IB_Connexion.Eof DO
  BEGIN
    Conn(IB_ConnexionCON_NOM.AsString,
      IB_ConnexionCON_TEL.AsString,
      IB_ConnexionCON_TYPE.AsInteger,
      IB_ConnexionCON_ORDRE.AsInteger,
      IB_ConnexionCON_ID.Asinteger);
    IB_Connexion.Next;
  END;
  IB_Connexion.Close;
END;

PROCEDURE TFrm_LaunchV7.NeedReplication(LAUID: Integer;
  Repli: TUneReplication);
BEGIN
  Ib_Replication.Close;
  Ib_Replication.ParamByName('LAUID').AsInteger := LAUID;
  Ib_Replication.Open;
  WHILE NOT Ib_Replication.Eof DO
  BEGIN
    repli(Ib_ReplicationREP_ID.AsInteger,
      Ib_ReplicationREP_PING.AsString,
      Ib_ReplicationREP_PUSH.AsString,
      Ib_ReplicationREP_PULL.AsString,
      Ib_ReplicationREP_USER.AsString,
      Ib_ReplicationREP_PWD.AsString,
      Ib_ReplicationREP_URLLOCAL.AsString,
      Ib_ReplicationREP_URLDISTANT.AsString,
      Ib_ReplicationREP_PLACEEAI.AsString,
      Ib_ReplicationREP_PLACEBASE.AsString,
      Ib_ReplicationREP_ORDRE.AsInteger
      );
    Ib_Replication.Next;
  END;
  Ib_Replication.Close;
END;

//---------------------------------------------------------------
// Initialisation des connexions Principale
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.Gestiondesconnexions1Click(Sender: TObject);
VAR
  Frm_Base: TFrm_Base;
  i: integer;
  Connex: TLesConnexion;
  repli: TLesreplication;
  Clef2: Integer;
  Clef: Integer;
  ini: TIniFile;
  S1: STRING;
  s: STRING;
BEGIN
  IF MotDePasse THEN
  BEGIN
    data.close;
    TRY
      data.DatabaseName := LaBase0;
      TRY
        data.Open;
      EXCEPT
        IF ModeDebug THEN Ajoute('Problème connexion à la base Gestiondesconnexions1Click ', 0);
        RAISE;
      END;
      tran.Active := true;
      // Création des providers/subscripters par defaut
      Ib_Provider.Open;
      IF Ib_Provider.isEmpty THEN
      BEGIN
        ini := TiniFile.Create(ChangeFileExt(Application.exename, '.INI'));
        TRY
          i := 0;
          REPEAT
            S := ini.readstring('PROVIDER', 'PROVIDER' + Inttostr(i), '');
            IF S <> '' THEN
            BEGIN
              Clef := NouvelleClef;
              InsertK(Clef, CstTblProviders);
              Ib_Divers.Sql.Clear;
              Ib_Divers.Sql.Add('INSERT INTO GENPROVIDERS');
              Ib_Divers.Sql.Add('(PRO_ID,PRO_NOM,PRO_ORDRE, PRO_LOOP)');
              Ib_Divers.Sql.Add('VALUES');
              Ib_Divers.Sql.Add('(' + ListeEnStr([CLEF, S, i + 1, 0]) + ')');
              Ib_Divers.ExecSql;
            END;
            inc(i);
          UNTIL s = '';
          Commit;
        FINALLY
          ini.free;
        END;
      END;
      Ib_Provider.close;

      Ib_Subsciber.Open;
      IF Ib_Subsciber.IsEmpty THEN
      BEGIN
        ini := TiniFile.Create(ChangeFileExt(Application.exename, '.INI'));
        TRY
          i := 0;
          REPEAT
            S := ini.readstring('SUBSCRIBER', 'PROVIDER' + Inttostr(i), '');
            IF S <> '' THEN
            BEGIN
              Clef := NouvelleClef;
              InsertK(Clef, CstTblSubScribers);
              Ib_Divers.Sql.Clear;
              Ib_Divers.Sql.Add('INSERT INTO GENSUBSCRIBERS');
              Ib_Divers.Sql.Add('(SUB_ID,SUB_NOM,SUB_ORDRE, SUB_LOOP)');
              Ib_Divers.Sql.Add('VALUES');
              Ib_Divers.Sql.Add('(' + ListeEnStr([CLEF, S, i + 1, 0]) + ')');
              Ib_Divers.ExecSql;
            END;
            inc(i);
          UNTIL s = '';
          Commit;
        FINALLY
          ini.free;
        END;
      END;
      Ib_Subsciber.Close;
      //
      Ib_Labase.open;
      Ib_Lesbases.Open;
      Application.CreateForm(TFrm_Base, Frm_Base);
      TRY
        Frm_Base.Cb_Base.items.Clear;
        Ib_Lesbases.First;
        WHILE NOT Ib_Lesbases.Eof DO
        BEGIN
          i := Ib_LesBasesBAS_ID.AsInteger;
          Frm_Base.Cb_Base.items.AddObject(Ib_LesBasesBAS_NOM.AsString, pointer(i));
          IF Ib_LesBasesBAS_ID.AsInteger = IB_LaBaseBAS_ID.AsInteger THEN
            Frm_Base.Cb_Base.ItemIndex := Frm_Base.Cb_Base.Items.Count - 1;
          Ib_Lesbases.next;
        END;
        Frm_Base.OnNeedHorraire := NeedHorraire;
        Frm_Base.OnNeedConnexion := NeedConnexion;
        Frm_Base.OnNeedReplication := NeedReplication;
        IF Frm_Base.Execute THEN
        BEGIN
          Event(Labase0, CstModifParametre, true, Null);
          Ib_Divers.Sql.Clear;
          Ib_Divers.Sql.Add('UPDATE GENLAUNCH');
          Ib_Divers.Sql.Add('SET ');
          IF trim(Frm_Base.Ed_Heure1.text) <> '' THEN
          BEGIN
            Ib_Divers.Sql.Add('LAU_HEURE1 = ''01/01/2000 ' + Frm_Base.Ed_Heure1.text + ''',');
            IF Frm_Base.Cb_Valide1.Checked THEN
              Ib_Divers.Sql.Add('LAU_H1 = 1,')
            ELSE
              Ib_Divers.Sql.Add('LAU_H1 = 0,')
          END
          ELSE
            Ib_Divers.Sql.Add('LAU_HEURE1 = NULL, LAU_H1 = 0,');
          IF trim(Frm_Base.Ed_Heure2.text) <> '' THEN
          BEGIN
            Ib_Divers.Sql.Add('LAU_HEURE2 = ''01/01/2000 ' + Frm_Base.Ed_Heure2.text + ''',');
            IF Frm_Base.Cb_Valide2.Checked THEN
              Ib_Divers.Sql.Add('LAU_H2 = 1,')
            ELSE
              Ib_Divers.Sql.Add('LAU_H2 = 0,')
          END
          ELSE
            Ib_Divers.Sql.Add('LAU_HEURE2 = NULL, LAU_H2 = 0,');
          IF trim(frm_base.ed_backtime.text) <> '' THEN
          BEGIN
            Ib_Divers.Sql.Add('LAU_BACKTIME = ''01/01/2000 ' + Frm_Base.Ed_BackTime.text + ''',');
            IF Frm_Base.Cb_BACK.Checked THEN
              Ib_Divers.Sql.Add('LAU_BACK = 1,')
            ELSE
              Ib_Divers.Sql.Add('LAU_BACK = 0,')
          END
          ELSE
            Ib_Divers.Sql.Add('LAU_BACKTIME = NULL, LAU_BACK = 0,');
          IF Frm_Base.Cb_Auto.Checked THEN
            Ib_Divers.Sql.Add('LAU_AUTORUN=1')
          ELSE
            Ib_Divers.Sql.Add('LAU_AUTORUN=0');
          Ib_Divers.Sql.Add(' WHERE LAU_ID = ' + EnStr(Frm_Base.lauID));
          Ib_Divers.ExecSQL;
          ModifK(Frm_Base.lauID);
          Commit;

          Ib_Divers.Sql.Clear;
          Ib_Divers.Sql.Add('UPDATE GENPARAM');
          IF frm_base.CB_ForceMaj.Checked THEN
            Ib_Divers.Sql.Add('SET PRM_POS=1')
          ELSE
            Ib_Divers.Sql.Add('SET PRM_POS=0');
          Ib_Divers.Sql.Add('WHERE PRM_INTEGER = ' + Inttostr(frm_base.BASID));
          Ib_Divers.Sql.Add('And  PRM_TYPE = 1999');
          Ib_Divers.Sql.Add('And  PRM_CODE = 666');
          Ib_Divers.Sql.Add('AND PRM_MAGID = 0');
          Ib_Divers.ExecSql;
          ModifK(Frm_Base.PRMID);
          Commit;

          FOR i := 0 TO Frm_Base.List_ConnSup.Count - 1 DO
          BEGIN
            Connex := TLesConnexion(Frm_Base.List_ConnSup[i]);
            DeleteK(Connex.ID);
          END;
          Commit;
          FOR i := 0 TO Frm_Base.List_Connexion.Count - 1 DO
          BEGIN
            Connex := TLesConnexion(Frm_Base.List_Connexion[i]);
            IF Connex.Change THEN
            BEGIN
              IF Connex.Id <> -1 THEN
              BEGIN
                modifk(Connex.ID);
                Ib_Divers.Sql.CLEAR;
                Ib_Divers.Sql.Add('Update GENCONNEXION');
                Ib_Divers.Sql.Add('SET CON_NOM = ' + EnStr(Connex.Nom) + ',');
                Ib_Divers.Sql.Add('    CON_TEL = ' + EnStr(Connex.TEL) + ',');
                Ib_Divers.Sql.Add('    CON_TYPE = ' + EnStr(Connex.LeType) + ',');
                Ib_Divers.Sql.Add('    CON_ORDRE = ' + EnStr(Connex.Ordre));
                Ib_Divers.Sql.Add('WHERE CON_ID = ' + EnStr(Connex.ID));
                Ib_Divers.ExecSql;
              END
              ELSE
              BEGIN
                Clef := NouvelleClef;
                InsertK(Clef, CstTblConnexion);
                Ib_Divers.Sql.CLEAR;
                Ib_Divers.Sql.Add('INSERT INTO GENCONNEXION');
                Ib_Divers.Sql.Add('(CON_ID, CON_LAUID, CON_NOM, CON_TEL, CON_TYPE, CON_ORDRE)');
                Ib_Divers.Sql.Add('VALUES');
                Ib_Divers.Sql.Add('(' + ListeEnStr([Clef, frm_base.LAUID, Connex.nom, Connex.Tel, connex.LeType, Connex.Ordre]) + ')');
                Ib_Divers.execSql;
              END;
            END;
          END;
          Commit;
          FOR i := 0 TO Frm_Base.List_Repli.count - 1 DO
          BEGIN
            repli := TLesreplication(Frm_Base.List_Repli[i]);
            IF repli.Supp THEN
            BEGIN
              IF repli.id <> -1 THEN
              BEGIN
                DeleteK(repli.id);
                ib_Liaison.Sql.Clear;
                ib_Liaison.Sql.Add('SELECT GLR_ID ');
                ib_Liaison.Sql.Add('FROM GENLIAIREPLI JOIN K on (K_ID = GLR_ID and K_ENABLED=1) ');
                ib_Liaison.Sql.Add('WHERE GLR_REPID = ' + enStr(repli.id));
                ib_Liaison.open;
                ib_Liaison.First;
                WHILE NOT ib_Liaison.EOF DO
                BEGIN
                  DeleteK(ib_Liaison.Fields[0].AsInteger);
                  ib_Liaison.Next;
                END;
                ib_Liaison.Close;
              END;
            END
            ELSE IF repli.Change THEN
            BEGIN
              IF repli.id = -1 THEN
              BEGIN
                Clef := NouvelleClef;
                InsertK(Clef, CstTblReplication);
                ib_divers.sql.clear;
                ib_divers.sql.Add('INSERT INTO GENREPLICATION');
                ib_divers.sql.Add('(REP_ID, REP_LAUID, REP_PING, REP_PUSH, REP_PULL, REP_USER, REP_PWD, REP_ORDRE, REP_URLLOCAL, REP_URLDISTANT, REP_PLACEEAI, REP_PLACEBASE)');
                ib_divers.sql.Add('VALUES');
                ib_divers.sql.Add('(' + ListeEnStr([Clef, frm_base.LAUID, repli.ping, repli.push, repli.pull,
                  repli.user, repli.pwd, repli.ordre, repli.UrlLocal, repli.UrlDistant, repli.PlaceEai, repli.PlaceBase]) + ')');
                ib_divers.execSql;
                Ib_Provider.Open;
                Ib_Provider.First;
                WHILE NOT Ib_Provider.Eof DO
                BEGIN
                  Clef2 := NouvelleClef;
                  InsertK(Clef2, CstTblLiaiRepli);
                  ib_divers.Sql.Clear;
                  ib_divers.sql.Add('INSERT INTO GENLIAIREPLI');
                  ib_divers.sql.Add('(GLR_ID, GLR_REPID, GLR_PROSUBID)');
                  ib_divers.sql.Add('VALUES');
                  ib_divers.sql.Add('(' + ListeEnStr([Clef2, Clef, Ib_ProviderPRO_ID.AsInteger]) + ')');
                  ib_divers.ExecSql;
                  Ib_Provider.Next;
                END;
                Ib_Provider.Close;
                Ib_Subsciber.Open;
                Ib_Subsciber.First;
                WHILE NOT Ib_Subsciber.Eof DO
                BEGIN
                  Clef2 := NouvelleClef;
                  InsertK(Clef2, CstTblLiaiRepli);
                  ib_divers.Sql.Clear;
                  ib_divers.sql.Add('INSERT INTO GENLIAIREPLI');
                  ib_divers.sql.Add('(GLR_ID, GLR_REPID, GLR_PROSUBID)');
                  ib_divers.sql.Add('VALUES');
                  ib_divers.sql.Add('(' + ListeEnStr([Clef2, Clef, Ib_SubsciberSUB_ID.AsInteger]) + ')');
                  ib_divers.ExecSql;
                  Ib_Subsciber.Next;
                END;
                Ib_Subsciber.Close;
              END
              ELSE
              BEGIN
                ModifK(repli.id);
                ib_divers.sql.clear;
                ib_divers.sql.Add('Update GENREPLICATION');
                ib_divers.sql.Add('SET ');
                ib_divers.sql.Add('REP_PING = ' + enstr(repli.ping) + ', ');
                ib_divers.sql.Add('REP_PUSH = ' + enstr(repli.push) + ', ');
                ib_divers.sql.Add('REP_PULL = ' + enstr(repli.pull) + ', ');
                ib_divers.sql.Add('REP_USER = ' + enstr(repli.user) + ', ');
                ib_divers.sql.Add('REP_PWD = ' + enstr(repli.pwd) + ', ');
                ib_divers.sql.Add('REP_URLLOCAL = ' + enstr(repli.UrlLocal) + ', ');
                ib_divers.sql.Add('REP_URLDISTANT = ' + enstr(repli.UrlDistant) + ', ');
                ib_divers.sql.Add('REP_PLACEEAI = ' + enstr(repli.PlaceEai) + ', ');
                ib_divers.sql.Add('REP_PLACEBASE = ' + enstr(repli.PlaceBase) + ', ');
                ib_divers.sql.Add('REP_ORDRE = ' + enstr(repli.ORDRE));
                ib_divers.sql.Add('WHERE REP_ID = ' + enstr(repli.id));
                ib_divers.execSql;
              END;
            END;
          END;
          Commit;
          IF Frm_Base.UnNv THEN
          BEGIN
            // une nouvelle programation existe
            S := Frm_Base.NvDate;
            IF trim(S) <> '' THEN
            BEGIN
              S1 := Copy(S, 1, Pos('/', S));
              Delete(S, 1, pos('/', S));
              Insert(S1, S, Pos('/', S) + 1);
              IB_Divers.sql.clear;
              IB_Divers.sql.add('SELECT CHA_ID');
              IB_Divers.sql.add('FROM GENCHANGELAUNCH JOIN K ON (K_ID=CHA_ID AND K_ENABLED=1)');
              IB_Divers.sql.add('WHERE CHA_LAUID=' + EnStr(Frm_Base.LauID));
              IB_Divers.Open;
              IF trim(Frm_Base.NvHeure1) = '' THEN
              BEGIN
                Frm_Base.NvHeure1 := 'NULL';
                Frm_Base.NvH1 := false;
              END
              ELSE
                Frm_Base.NvHeure1 := '01/01/2001 ' + Frm_Base.NvHeure1;
              IF trim(Frm_Base.NvHeure2) = '' THEN
              BEGIN
                Frm_Base.NvHeure2 := 'NULL';
                Frm_Base.NvH2 := false;
              END
              ELSE
                Frm_Base.NvHeure2 := '01/01/2001 ' + Frm_Base.NvHeure2;
              IF trim(Frm_Base.NvBACKTIME) = '' THEN
              BEGIN
                Frm_Base.NvBACKTIME := 'NULL';
                Frm_Base.NvBACK := false;
              END
              ELSE
                Frm_Base.NvBACKTIME := '01/01/2001 ' + Frm_Base.NvBACKTIME;
              IF IB_Divers.IsEmpty THEN
              BEGIN
                Ib_Divers.Close;
                Clef := NouvelleClef;
                InsertK(Clef, CstTblChangeLaunch);
                IB_Divers.sql.clear;
                IB_Divers.sql.Add('INSERT INTO GENCHANGELAUNCH');
                IB_Divers.sql.Add('(CHA_ID,CHA_LAUID,CHA_HEURE1,CHA_H1,CHA_HEURE2,CHA_H2,CHA_AUTORUN,CHA_ACTIVER, CHA_ACTIVE, CHA_BACK, CHA_BACKTIME)');
                IB_Divers.sql.Add('VALUES');
                IB_Divers.sql.Add('(' + ListeEnStr([Clef, Frm_Base.LauId, Frm_Base.NvHeure1, Frm_Base.NvH1,
                  Frm_Base.NvHeure2, Frm_Base.NvH2, Frm_Base.NvAuto, S, False, Frm_Base.NvBACK, Frm_Base.NvBACKTIME]) + ')');
                IB_Divers.ExecSql;
              END
              ELSE
              BEGIN
                Clef := Ib_Divers.Fields[0].AsInteger;
                Ib_Divers.Close;
                ModifK(Clef);
                IB_Divers.sql.clear;
                IB_Divers.sql.Add('UPDATE GENCHANGELAUNCH');
                IB_Divers.sql.Add('SET CHA_HEURE1 = ' + EnStr(Frm_Base.NvHeure1) + ', ');
                IB_Divers.sql.Add('    CHA_H1 = ' + EnStr(Frm_Base.NvH1) + ', ');
                IB_Divers.sql.Add('    CHA_HEURE2 = ' + EnStr(Frm_Base.NvHeure2) + ', ');
                IB_Divers.sql.Add('    CHA_H2 = ' + EnStr(Frm_Base.NvH2) + ', ');
                IB_Divers.sql.Add('    CHA_AUTORUN = ' + EnStr(Frm_Base.NvAuto) + ', ');
                IB_Divers.sql.Add('    CHA_ACTIVER= ' + EnStr(S) + ', ');
                IB_Divers.sql.Add('    CHA_BACK= ' + EnStr(Frm_Base.NvBack) + ', ');
                IB_Divers.sql.Add('    CHA_BACKTIME= ' + EnStr(Frm_Base.NvBackTIME) + ', ');
                IB_Divers.sql.Add('    CHA_ACTIVE= 0');
                IB_Divers.sql.Add('WHERE CHA_ID = ' + EnStr(Clef));
                IB_Divers.ExecSql;
              END;
            END;
            commit;
          END;
        END;
      FINALLY
        Frm_Base.release;
      END;
    FINALLY
      data.close;
    END;
    VerifChangeHorraire;
    InitialiseLaunch;
  END;
END;

function TFrm_LaunchV7.GetTIdHttp(AuserName, APassWord : string; AConnectTimeOut : integer): TIdHttp;
begin
  Result := TIdHTTP.Create(Self);

  // Params par défaut
  With Result do
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

  With Result do
  begin
    Request.UserName := AUserName;
    Request.Password := APassWord;
    ConnectTimeout := AConnectTimeOut;
  end;

end;

//---------------------------------------------------------------
// Définition des Providers
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.ProvideretSubscribers1Click(Sender: TObject);
VAR
  List: Tlist;
  Prov: TLesProvider;
  i: integer;
  frm_ProvSubs: Tfrm_ProvSubs;
  Clef2: Integer;
  Clef: Integer;
BEGIN
  IF MotDePasse THEN
  BEGIN
    data.close;
    TRY
      data.DatabaseName := LaBase0;
      TRY
        data.Open;
      EXCEPT
        IF ModeDebug THEN Ajoute('Problème connexion à la base ProvideretSubscribers1Click ', 0);
        RAISE;
      END;
      tran.Active := true;
      List := Tlist.create;
      TRY
        Ib_Provider.Open;
        Ib_Provider.First;
        WHILE NOT Ib_Provider.Eof DO
        BEGIN
          Prov := TLesProvider.Create;
          Prov.ID := Ib_ProviderPRO_ID.AsInteger;
          Prov.Nom := Ib_ProviderPRO_NOM.AsSTRING;
          Prov.Ordre := Ib_ProviderPRO_ORDRE.AsInteger;
          Prov.Loop := Ib_ProviderPRO_Loop.AsInteger;
          List.Add(Prov);
          Ib_Provider.Next;
        END;
        Ib_Provider.Close;
        FOR i := 0 TO list.count - 2 DO
        BEGIN
          IF (TLesProvider(list[i]).Ordre >= TLesProvider(list[i + 1]).Ordre) THEN
          BEGIN
            TLesProvider(list[i + 1]).Ordre := TLesProvider(list[i]).Ordre + 1;
            TLesProvider(list[i + 1]).Change := true;
          END;
        END;
        Application.CreateForm(Tfrm_ProvSubs, frm_ProvSubs);
        TRY
          frm_ProvSubs.Caption := 'Saisie des Providers';
          IF frm_ProvSubs.execute(List) THEN
          BEGIN
            Event(Labase0, CstModifProvider, true, Null);
            FOR i := 0 TO list.count - 1 DO
            BEGIN
              prov := TLesProvider(List[i]);
              IF prov.Supp THEN
              BEGIN
                IF prov.id <> -1 THEN
                BEGIN
                  DeleteK(prov.id);
                  ib_Liaison.Sql.Clear;
                  ib_Liaison.Sql.Add('SELECT GLR_ID ');
                  ib_Liaison.Sql.Add('FROM GENLIAIREPLI JOIN K on (K_ID = GLR_ID and K_ENABLED=1) ');
                  ib_Liaison.Sql.Add('WHERE GLR_PROSUBID = ' + enStr(Prov.id));
                  ib_Liaison.open;
                  ib_Liaison.First;
                  WHILE NOT ib_Liaison.EOF DO
                  BEGIN
                    DeleteK(ib_Liaison.Fields[0].AsInteger);
                    ib_Liaison.Next;
                  END;
                  ib_Liaison.Close;
                END;
              END
              ELSE IF prov.Change THEN
              BEGIN
                IF prov.id = -1 THEN
                BEGIN
                  Clef := NouvelleClef;
                  InsertK(Clef, CstTblProviders);
                  Ib_Divers.Sql.Clear;
                  Ib_Divers.Sql.Add('INSERT INTO GENPROVIDERS');
                  Ib_Divers.Sql.Add('(PRO_ID, PRO_NOM, PRO_ORDRE, PRO_LOOP)');
                  Ib_Divers.Sql.Add('VALUES');
                  Ib_Divers.Sql.Add('(' + ListeEnStr([Clef, prov.nom, prov.ordre, prov.loop]) + ')');
                  Ib_Divers.ExecSql;
                  ib_Liaison.Sql.Clear;
                  ib_Liaison.Sql.Add('SELECT REP_ID ');
                  ib_Liaison.Sql.Add('FROM GENREPLICATION JOIN K ON (K_ID=REP_ID AND K_ENABLED=1)');
                  ib_Liaison.Sql.Add('WHERE REP_ID>0');
                  ib_Liaison.Open;
                  WHILE NOT ib_Liaison.Eof DO
                  BEGIN
                    Clef2 := NouvelleClef;
                    InsertK(Clef2, CstTblLiaiRepli);
                    Ib_Divers.Sql.Clear;
                    Ib_Divers.Sql.Add('INSERT INTO GENLIAIREPLI');
                    Ib_Divers.Sql.Add('(GLR_ID, GLR_REPID, GLR_PROSUBID)');
                    Ib_Divers.Sql.Add('VALUES');
                    Ib_Divers.Sql.Add('(' + ListeEnStr([Clef2, ib_Liaison.Fields[0].AsInteger, Clef]) + ')');
                    Ib_Divers.ExecSql;
                    ib_Liaison.Next;
                  END;
                  ib_Liaison.Close;
                END
                ELSE
                BEGIN
                  ModifK(Prov.Id);
                  Ib_Divers.Sql.Clear;
                  Ib_Divers.Sql.Add('UPDATE GENPROVIDERS');
                  Ib_Divers.Sql.Add('SET PRO_NOM = ' + EnStr(Prov.Nom) + ',');
                  Ib_Divers.Sql.Add('    PRO_ORDRE = ' + EnStr(Prov.Ordre) + ',');
                  Ib_Divers.Sql.Add('    PRO_LOOP = ' + EnStr(Prov.Loop));
                  Ib_Divers.Sql.Add('WHERE PRO_ID = ' + EnStr(Prov.Id));
                  Ib_Divers.ExecSql;
                END;
              END;
            END;
            Commit;
          END;
        FINALLY
          frm_ProvSubs.release;
        END;
      FINALLY
        FOR i := 0 TO list.count - 1 DO
          TLesProvider(List[i]).free;
        list.clear;
        List.free;
      END;
    FINALLY
      data.close;
    END;
    VerifChangeHorraire;
    InitialiseLaunch;
  END;
END;

//---------------------------------------------------------------
// Définition des Subscribers
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.Subscribers1Click(Sender: TObject);
VAR
  List: Tlist;
  Prov: TLesProvider;
  i: integer;
  frm_ProvSubs: Tfrm_ProvSubs;
  Clef2: Integer;
  Clef: Integer;
BEGIN
  IF MotDePasse THEN
  BEGIN
    data.close;
    TRY
      data.DatabaseName := LaBase0;
      TRY
        data.Open;
      EXCEPT
        IF ModeDebug THEN Ajoute('Problème connexion à la base Subscribers1Click ', 0);
        RAISE;
      END;
      tran.Active := true;
      List := Tlist.create;
      TRY
        Ib_Subsciber.Open;
        Ib_Subsciber.First;
        WHILE NOT Ib_Subsciber.Eof DO
        BEGIN
          Prov := TLesProvider.Create;
          Prov.ID := Ib_SubsciberSUB_ID.AsInteger;
          Prov.Nom := Ib_SubsciberSUB_NOM.AsSTRING;
          Prov.Ordre := Ib_SubsciberSUB_ORDRE.AsInteger;
          Prov.Loop := Ib_SubsciberSUB_Loop.AsInteger;
          List.Add(Prov);
          Ib_Subsciber.Next;
        END;
        Ib_Subsciber.Close;
        Application.CreateForm(Tfrm_ProvSubs, frm_ProvSubs);
        TRY
          frm_ProvSubs.Caption := 'Saisie des Subscribers';
          IF frm_ProvSubs.execute(List) THEN
          BEGIN
            Event(Labase0, CstModifSubscriber, true, Null);
            FOR i := 0 TO list.count - 1 DO
            BEGIN
              prov := TLesProvider(List[i]);
              IF prov.Supp THEN
              BEGIN
                IF prov.id <> -1 THEN
                BEGIN
                  DeleteK(prov.id);
                  ib_Liaison.Sql.Clear;
                  ib_Liaison.Sql.Add('SELECT GLR_ID ');
                  ib_Liaison.Sql.Add('FROM GENLIAIREPLI JOIN K on (K_ID = GLR_ID and K_ENABLED=1) ');
                  ib_Liaison.Sql.Add('WHERE GLR_PROSUBID = ' + enStr(Prov.id));
                  ib_Liaison.open;
                  ib_Liaison.First;
                  WHILE NOT ib_Liaison.EOF DO
                  BEGIN
                    DeleteK(ib_Liaison.Fields[0].AsInteger);
                    ib_Liaison.Next;
                  END;
                  ib_Liaison.Close;
                END;
              END
              ELSE IF prov.Change THEN
              BEGIN
                IF prov.id = -1 THEN
                BEGIN
                  Clef := NouvelleClef;
                  InsertK(Clef, CstTblProviders);
                  Ib_Divers.Sql.Clear;
                  Ib_Divers.Sql.Add('INSERT INTO GENSUBSCRIBERS');
                  Ib_Divers.Sql.Add('(SUB_ID, SUB_NOM, SUB_ORDRE, SUB_LOOP)');
                  Ib_Divers.Sql.Add('VALUES');
                  Ib_Divers.Sql.Add('(' + ListeEnStr([clef, prov.nom, prov.ordre, prov.loop]) + ')');
                  Ib_Divers.ExecSql;
                  ib_Liaison.Sql.Clear;
                  ib_Liaison.Sql.Add('SELECT REP_ID ');
                  ib_Liaison.Sql.Add('FROM GENREPLICATION JOIN K ON (K_ID=REP_ID AND K_ENABLED=1)');
                  ib_Liaison.Sql.Add('WHERE REP_ID>0');
                  ib_Liaison.Open;
                  WHILE NOT ib_Liaison.Eof DO
                  BEGIN
                    Clef2 := NouvelleClef;
                    InsertK(Clef2, CstTblLiaiRepli);
                    Ib_Divers.Sql.Clear;
                    Ib_Divers.Sql.Add('INSERT INTO GENLIAIREPLI');
                    Ib_Divers.Sql.Add('(GLR_ID, GLR_REPID, GLR_PROSUBID)');
                    Ib_Divers.Sql.Add('VALUES');
                    Ib_Divers.Sql.Add('(' + ListeEnStr([Clef2, ib_Liaison.Fields[0].AsInteger, Clef]) + ')');
                    Ib_Divers.ExecSql;
                    ib_Liaison.Next;
                  END;
                  ib_Liaison.Close;
                END
                ELSE
                BEGIN
                  ModifK(Prov.Id);
                  Ib_Divers.Sql.Clear;
                  Ib_Divers.Sql.Add('UPDATE GENSUBSCRIBERS');
                  Ib_Divers.Sql.Add('SET SUB_NOM = ' + EnStr(Prov.Nom) + ',');
                  Ib_Divers.Sql.Add('    SUB_ORDRE = ' + EnStr(Prov.Ordre) + ',');
                  Ib_Divers.Sql.Add('    SUB_LOOP = ' + EnStr(Prov.Loop));
                  Ib_Divers.Sql.Add('WHERE SUB_ID = ' + EnStr(Prov.Id));
                  Ib_Divers.ExecSql;
                END;
              END;
            END;
            Commit;
          END;
        FINALLY
          frm_ProvSubs.release;
        END;
      FINALLY
        FOR i := 0 TO list.count - 1 DO
          TLesProvider(List[i]).free;
        list.clear;
        List.free;
      END;
    FINALLY
      data.close;
    END;
    VerifChangeHorraire;
    InitialiseLaunch;
  END;
END;

//---------------------------------------------------------------
// Utilitaires
//---------------------------------------------------------------

//---------------------------------------------------------------
// Connexion au Modem
//---------------------------------------------------------------

FUNCTION TFrm_LaunchV7.ConnexionModem(Nom, Tel: STRING): Boolean;
VAR
  RasConn: HRasConn;
  TP: TRasDialParams;
  Pass: Bool;
  err: DWORD;
  Last: DWord;
  RasConStatus: TRasConnStatus;
  nb: DWORD;
  ok: Boolean;
  debut: TdateTime;
BEGIN
  Debut := Now;
  fillchar(tp, Sizeof(tp), #00);
  tp.Size := Sizeof(Tp);
  StrPCopy(tp.pEntryName, NOM);
  err := RasGetEntryDialParams(NIL, TP, Pass);
  Ok := false;
  IF err = 0 THEN
  BEGIN
    StrPCopy(tp.pPhoneNumber, TEL);
    RasConn := 0;

    err := rasdial(NIL, NIL, @tp, $FFFFFFFF, Handle, RasConn);
    IF err <> 0 THEN
    BEGIN
      result := false;
      EXIT;
    END;
    Application.ProcessMessages;
    Last := $FFFFFFFF;
    nb := gettickcount + 600000; // 10 min
    REPEAT
      Application.ProcessMessages;
      RasConStatus.Size := sizeof(RasConStatus);
      RasGetConnectStatus(RasConn, @RasConStatus);
      IF Last <> RasConStatus.RasConnState THEN
      BEGIN
        CASE RasConStatus.RasConnState OF
          RASCS_Connected: ok := true;
          RASCS_Disconnected: ok := true;
        END;
        Last := RasConStatus.RasConnState;
      END;
      LeDelay(1000);
    UNTIL OK OR (gettickcount > nb); // max 10 min
  END;
  result := Ok;
  IF result THEN
    Event(Labase0, CstConnexionModem, true, Now - Debut);
END;

//---------------------------------------------------------------
// Deconnexion au Modem
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.DeconnexionModem;
VAR
  RasCom: ARRAY[1..100] OF TRasConn;
  i, Connections: DWord;
  ok: Boolean;
  RasConStatus: TRasConnStatus;
  debut: TdateTime;
BEGIN
  debut := now;
  REPEAT
    i := Sizeof(RasCom);
    RasCom[1].Size := sizeof(TRasConn);
    RasEnumConnections(@RasCom, i, Connections);
    FOR i := 1 TO Connections DO RasHangUp(RasCom[i].RasConn);
    // Test si c'est bien deconnecté
    i := Sizeof(RasCom);
    RasCom[1].Size := sizeof(TRasConn);
    RasEnumConnections(@RasCom, i, Connections);
    ok := True;
    FOR i := 1 TO Connections DO
    BEGIN
      Application.ProcessMessages;
      RasConStatus.Size := sizeof(RasConStatus);
      RasGetConnectStatus(RasCom[i].RasConn, @RasConStatus);
      CASE RasConStatus.RasConnState OF
        RASCS_Connected: ok := False;
      END;
    END;
    IF NOT ok THEN
      LeDelay(5000);
  UNTIL OK;
  Event(Labase0, CstDeConnexionModem, true, Now - Debut);
END;

//---------------------------------------------------------------
//Saisie du mot de passe
//---------------------------------------------------------------

FUNCTION TFrm_LaunchV7.MotDePasse: Boolean;
{$IFDEF DEBUG }
{$ELSE }
VAR
  Frm_Question: TFrm_Question;
  Password: STRING;
{$ENDIF }
BEGIN
{$IFDEF DEBUG }
  result := true;
{$ELSE }
  Application.CreateForm(TFrm_Question, Frm_Question);
  TRY
    result := (Frm_Question.Execute('Saisie du mot de passe', Password, true)) AND
      (Password = CstPassword);
  FINALLY
    Frm_Question.release;
  END;
{$ENDIF }
END;

//---------------------------------------------------------------
//Lancement du ping en boucle
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.InitPing(Url: STRING; temps: Dword);
BEGIN
  Ping := Tping.Create(Url, temps);
END;

//---------------------------------------------------------------
//Arret du ping
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.StopPing;
BEGIN
  IF ping <> NIL THEN
  BEGIN
    Ping.terminate;
    ping := NIL;
  END;
END;

//---------------------------------------------------------------
//Insertion du K dans une table
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.InsertK(Clef, Table: Integer);
BEGIN
  Ib_Divers.Sql.Clear;
  Ib_Divers.Sql.Add('Insert Into K');
  Ib_Divers.Sql.Add(' (K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,KSE_DELETE_ID,K_DELETED,KSE_UPDATE_ID,K_UPDATED,KSE_LOCK_ID,KMA_LOCK_ID)');
  Ib_Divers.Sql.Add(' VALUES ');
  Ib_Divers.Sql.Add(' (' + IntToStr(Clef) + ',-101,' + InttoStr(Table) + ',' + IntToStr(Clef) + ',1,-1,-1,Current_Date,0,''01/01/1980'',-1,Current_Date,0,0)');
  Ib_Divers.ExecSQL;
  Ib_Divers.Sql.Clear;
END;

//---------------------------------------------------------------
// Modification du K
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.ModifK(Clef: Integer);
BEGIN
  Ib_Divers.Sql.CLEAR;
//  Ib_Divers.Sql.Add('Update K');
//  Ib_Divers.Sql.Add('SET K_VERSION = GEN_ID(GENERAL_ID,1), K_UPDATED = CURRENT_DATE ');
//  Ib_Divers.Sql.Add('WHERE K_ID = ' + Inttostr(Clef));
  Ib_Divers.Sql.Add('EXECUTE PROCEDURE PR_UPDATEK(' + Inttostr(Clef) + ', 0)');
  Ib_Divers.ExecSQL;
  Ib_Divers.Sql.Clear;
END;

//---------------------------------------------------------------
// suppression du K
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.DeleteK(Clef: Integer);
BEGIN
  Ib_Divers.Sql.CLEAR;
//  Ib_Divers.Sql.Add('Update K');
//  Ib_Divers.Sql.Add('SET K_VERSION = GEN_ID(GENERAL_ID,1), K_DELETED = CURRENT_DATE, K_ENABLED = 0 ');
//  Ib_Divers.Sql.Add('WHERE K_ID = ' + Inttostr(Clef));
  Ib_Divers.Sql.Add('EXECUTE PROCEDURE PR_UPDATEK(' + Inttostr(Clef) + ', 1)');
  Ib_Divers.ExecSql;
  Ib_Divers.Sql.CLEAR;
END;

//---------------------------------------------------------------
// Récupération d'un nouvel ID
//---------------------------------------------------------------

FUNCTION TFrm_LaunchV7.NouvelleClef: Integer;
BEGIN
  Sp_NewKey.Prepare;
  Sp_NewKey.ExecProc;
  Result := Sp_NewKey.Parambyname('NEWKEY').AsInteger;
  Sp_NewKey.UnPrepare;
  Sp_NewKey.Close;
END;

//---------------------------------------------------------------
// Lancement du Commit
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.Commit;
BEGIN
  IF Ib_Divers.Transaction.InTransaction THEN
    Ib_Divers.Transaction.Commit;
  Ib_Divers.Transaction.Active := true;
END;

//---------------------------------------------------------------
// Ajout d'un evenement dans la table
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.Event(Base: STRING; LeType: Integer; Ok: Boolean;
  Temps: Variant);
VAR
  connection: Boolean;
  Clef: Integer;
  Letemps: TDateTime;
BEGIN
  IF NOT MapGinkoia.Backup THEN
  BEGIN
    IF Labase0 <> '' THEN
    BEGIN
      TRY
        connection := data_evt.Connected;
        TRY
          IF NOT connection THEN
          BEGIN
            data_evt.dataBaseName := Labase0;
            TRY
              data_evt.open;
            EXCEPT
              IF ModeDebug THEN Ajoute('Problème connexion à la base EVT ', 0);
              RAISE;
            END;
            tran_Evt.Active := true;
            IBStProc_BaseID.Prepare;
            IBStProc_BaseID.ExecProc;
            BasID := IBStProc_BaseID.Parambyname('BAS_ID').AsInteger;
            IBStProc_BaseID.UnPrepare;
            IBStProc_BaseID.Close;
          END;
          Clef := NouvelleClef_Evt;
          InsertK_Evt(Clef, CstTblEvent);
          IB_EVENT.ParamByName('ID').AsInteger := Clef;
          IB_EVENT.ParamByName('BASE').AsString := Base;
          //IB_EVENT.ParamByName('BASID').AsInteger := BasID;
          IB_EVENT.ParamByName('BASID').AsInteger := IDBase;
          IB_EVENT.ParamByName('TYPE').AsInteger := LeType;
          IF ok THEN
            IB_EVENT.ParamByName('RESULT').AsInteger := 1
          ELSE
            IB_EVENT.ParamByName('RESULT').AsInteger := 0;
          IF temps = null THEN
            IB_EVENT.ParamByName('TEMPS').clear
          ELSE
          BEGIN
            Letemps := temps;
            IB_EVENT.ParamByName('TEMPS').AsDateTime := Letemps;
          END;
          IB_EVENT.execsql;
          Commit_Evt;
        FINALLY
          IF (NOT connection) AND (NOT RepliEnCours) THEN
            data_evt.close;
        END;
      EXCEPT
{$IFDEF DEBUG }
        RAISE;
{$ENDIF DEBUG }
      END;
    END;
  END;
END;

//---------------------------------------------------------------
// Lance SM_AVANT_REPLI
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.Exec_AvantRepli(Base: STRING);
BEGIN
  Data.close;
  Data.DatabaseName := Base;
  TRY
    TRY
      Data.Open;
    EXCEPT
      IF ModeDebug THEN Ajoute('Problème connexion à la base Deconnexion trigger ', 0);
      RAISE;
    END;
    tran.active := true;
    IB_Divers.Sql.Clear;
    IB_Divers.Sql.Add('execute procedure SM_AVANT_REPLI ;');
    IB_Divers.ExecSql;
    commit;
  FINALLY
    data.close;
  END;

END;

//---------------------------------------------------------------
// Ajout d'une chaine dans le memo
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.Ajoute(S: STRING; Vider: Integer);
BEGIN
  IF (Vider = 1) and (not ModeDebug) THEN
    Mem_Result.Lines.Clear;
  Mem_Result.lines.Add(S);
  Mem_Result.Update;
  application.processmessages;
END;

//---------------------------------------------------------------
// Ajout d'une chaine sur la dernbiere ligne du memo
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.AjouteTC(S: STRING; Vider: Integer);
BEGIN
  IF (Vider = 1) THEN
    Mem_Result.Lines.Clear;
  IF Mem_Result.Lines.Count > 0 THEN
    Mem_Result.lines[Mem_Result.Lines.Count - 1] := Mem_Result.lines[Mem_Result.Lines.Count - 1] + S
  ELSE
    Mem_Result.lines.Add(S);
  Mem_Result.Update;
END;

//---------------------------------------------------------------
// RAZ ecran, info de la derniere repliaction ok
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.Info;
VAR // R_date, R_heure: STRING;
  connection, PasHisto: Boolean;
  s: string;
  TPListe: TStringList;
BEGIN
  // delay
  // raz de l'affichage
  // noter la dernier replication valide...
  LeDelay(5);
  connection := False;
  PasHisto := True;

  IF Labase0 <> '' THEN
  BEGIN
    TRY
      connection := data_evt.Connected;
      IF NOT connection THEN
      BEGIN
        data_evt.dataBaseName := Labase0;
        data_evt.Open;
        tran_evt.Active := True;
        IBStProc_BaseID.Prepare;
        IBStProc_BaseID.ExecProc;
        BasID := IBStProc_BaseID.Parambyname('BAS_ID').AsInteger;
        IBStProc_BaseID.UnPrepare;
        IBStProc_BaseID.Close;
      END;

      // IBQue_Last_Repli.ParambyName('BASID').asInteger := BasID;
      IBQue_Last_Repli.ParambyName('BASID').asInteger := IDBase;
      IBQue_Last_Repli.ParambyName('REPLIC').asInteger := 0;
      IBQue_Last_Repli.Open;
      IF NOT IBQue_Last_Repli.IsEmpty THEN
      BEGIN
        PasHisto := False;
        Ajoute('La dernière réplication réussie a été faite le "' + IBQue_Last_Repli.Fieldbyname('L_Date').asString + '" à ' + IBQue_Last_Repli.Fieldbyname('L_Heure').asString, 1);
        //signaler une erreur de recalcul
        IF NOT boolRecalculOk THEN
        BEGIN
          Ajoute('Erreur lors du recalcul des triggers.' + #13#10 + 'Veuillez contacter GINKOIA.', 0);
        END;
      END;
    FINALLY
      IBQue_Last_Repli.Close;
      IF NOT connection THEN
      BEGIN
        tran_evt.Active := False;
        data_evt.Close;
      END;
    END;
  END;

  // info de la dernière réplication réussi
  if isPortableSynchro then
  begin
    s := ExtractFilePath(ParamStr(0));
    if s[Length(s)]<>'\' then
      s:=s+'\';
    s := s+'Synchro.ok';
    if FileExists(s) then
    begin
      TpListe:=TStringList.Create;
      try
        TpListe.LoadFromFile(s);
        if TpListe.Count>0 then
        begin
          s := TpListe[0];
          Ajoute(s,0);
        end;
      except
      end;
      FreeAndNil(TpListe);
    end;
  end;

  IF PasHisto THEN
    Ajoute('Historique de réplication inexistant...', 1);

  IF ((MessMAJ1 <> '') OR (MessMAJ2 <> '')) THEN
  BEGIN
    Ajoute('', 0);
    Ajoute('*********************************************************************', 0);
    Ajoute(MessMAJ1, 0);
    Ajoute(MessMAJ2, 0);
    Ajoute('*********************************************************************', 0);
  END;
END;

//---------------------------------------------------------------
// Gestion du changement d'horraire
//---------------------------------------------------------------

FUNCTION TFrm_LaunchV7.VerifChangeHorraire: Boolean;
VAR
  DataOpen: Boolean;
BEGIN
  IF ModeDebug THEN Ajoute('Vérif changement d''horraire', 0);
  result := false;
  DataOpen := Data.Connected;
  TRY
    IF NOT DataOpen THEN
    BEGIN
      data.DatabaseName := LaBase0;
      TRY
        data.Open;
      EXCEPT
        IF ModeDebug THEN Ajoute('Problème connexion à la base VerifChgHorraire ', 0);
        RAISE;
      END;
      tran.Active := true;
      Ib_LaBase.Open;
      IdBase := IB_LaBaseBAS_ID.Asinteger;
      Ib_LaBase.Close;

      // Récupération des horraires
      Ib_Horraire.ParamByName('BasId').AsInteger := IdBase;
      Ib_Horraire.Open;
      LAUID := Ib_HorraireLAU_ID.AsInteger;
      Ib_Horraire.Close;
    END;

    IB_ChgLaunch.ParamByName('LAUID').AsInteger := LauID;
    IB_ChgLaunch.Open;
    TRY
      IF NOT (IB_ChgLaunch.IsEmpty) THEN
      BEGIN
        IF IB_ChgLaunchCHA_ACTIVER.AsDateTime < Now THEN
        BEGIN
          Ajoute(DateTimeToStr(Now) + '   ' + 'Changement des horraires de réplication', 0);
          // Activer le changement
          ModifK(LauID);
          IB_Divers.Sql.Clear;
          IB_Divers.Sql.Add('UPDATE GENLAUNCH');
          IF IB_ChgLaunchCHA_HEURE1.IsNull THEN
            IB_Divers.Sql.Add('   SET LAU_HEURE1 = NULL,')
          ELSE
            IB_Divers.Sql.Add('   SET LAU_HEURE1 = ' + EnStr(IB_ChgLaunchCHA_HEURE1.AsString) + ',');
          IB_Divers.Sql.Add('       LAU_H1 = ' + EnStr(IB_ChgLaunchCHA_H1.AsInteger) + ',');
          IF IB_ChgLaunchCHA_HEURE2.IsNull THEN
            IB_Divers.Sql.Add('       LAU_HEURE2 = NULL,')
          ELSE
            IB_Divers.Sql.Add('       LAU_HEURE2 = ' + EnStr(IB_ChgLaunchCHA_HEURE2.AsString) + ',');
          IB_Divers.Sql.Add('       LAU_H2 = ' + EnStr(IB_ChgLaunchCHA_H2.AsInteger) + ',');

          IF IB_ChgLaunchCHA_BACKTIME.IsNull THEN
            IB_Divers.Sql.Add('       LAU_BACKTIME = NULL,')
          ELSE
            IB_Divers.Sql.Add('       LAU_BACKTIME = ' + EnStr(IB_ChgLaunchCHA_BACKTIME.AsString) + ',');

          IB_Divers.Sql.Add('       LAU_BACK = ' + EnStr(IB_ChgLaunchCHA_BACK.AsInteger) + ',');

          IB_Divers.Sql.Add('       LAU_AUTORUN = ' + EnStr(IB_ChgLaunchCHA_AUTORUN.AsInteger));
          IB_Divers.Sql.Add('WHERE LAU_ID = ' + EnStr(LauId));
          IB_Divers.ExecSQL;

          IB_Divers.Sql.Clear;
          IB_Divers.Sql.Add('UPDATE GENCHANGELAUNCH ');
          IB_Divers.Sql.Add('SET CHA_ACTIVE=1 ');
          IB_Divers.Sql.Add('WHERE CHA_ID = ' + EnStr(IB_ChgLaunchCHA_ID.AsInteger));
          commit;
          result := true;
          Event(Labase0, CstChangementhorraire, true, Null);
          //
        END;
      END;
    FINALLY
      IB_ChgLaunch.Close;
    END;
  FINALLY
    IF NOT DataOpen THEN
      data.Close;
  END;
  IF ModeDebug THEN Ajoute('Fin Vérif changement d''horraire', 0);
END;

//---------------------------------------------------------------
// Boucle principale de gestion du launch
//---------------------------------------------------------------

FUNCTION TFrm_LaunchV7.LancementBackup: Boolean;
VAR
  i: integer;
BEGIN
  IF (MapGinkoia.Verifencours OR MapGinkoia.MajAuto) THEN
  BEGIN
    Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de Lancement du Backup MAJ en cours !', 0);
    result := false;
    EXIT;
  END;
  IF EtatBackup <> 5 THEN
  BEGIN
    IF (time < EncodeTime(18, 0, 0, 0)) AND
      (time > EncodeTime(8, 0, 0, 0)) THEN
    BEGIN
      Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de Lancement du Backup ', 0);
      result := false;
      EXIT;
    END;
  END;
  IF fileexists(Path + 'BackRest.Exe') THEN
  BEGIN
    Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement de Backup ', 0);
    Event(LaBase0, CstLanceBackup, true, null);
    TRY
      data.close;
    EXCEPT
    END;
    TRY
      data_evt.close;
    EXCEPT
    END;
    result := true;
    IF Winexec(Pchar(Path + 'BackRest.Exe auto'), 0) < 32 THEN
    BEGIN
      Event(LaBase0, CstLanceBackup, False, null);
      result := False;
    END;
    // Faire une attente de 10 Minutes
    FOR i := 1 TO 600 DO
    BEGIN
      Sleep(1000);
      Application.processmessages;
    END;
    i := 1;
    WHILE MapGinkoia.Backup DO
    BEGIN
      Sleep(10000);
      inc(i);
      IF i > (6 * 60) * 4 THEN // plus de 4 heures
        BREAK;
      Application.processmessages;
    END;
  END
  ELSE
  BEGIN
    Result := false;
    Ajoute(DateTimeToStr(Now) + '   ' + 'Ne trouve pas le Backup ', 0);
  END;
END;

PROCEDURE TFrm_LaunchV7.Tim_LanceRepliTimer(Sender: TObject);
VAR
  Ecart1: Dword;
  Ecart2: DWord;
  H, M, S, D: Word;
  debut: TDateTime;
  ok: Boolean;
  PathGinkoia: STRING;
BEGIN
  TRY
    Tim_LanceRepli.Enabled := false;
    InitEtat;
    IF ModeDebug THEN Ajoute('Lancement du timer ', 0);
    IF MapGinkoia.Backup THEN
    BEGIN
      IF ModeDebug THEN Ajoute('Backup en cours ', 0);
      Tim_LanceRepli.Interval := 1000 * 60 * 5;
      Tim_LanceRepli.Enabled := True;
      EXIT;
    END
    ELSE
    BEGIN
      //vérification que la vérification n'est pas bloquée dans les MAJ
      PathGinkoia := IncludeTrailingBackslash(ExtractFilePath(application.ExeName));
      IF fileexists(PathGinkoia + 'A_MAJ\verification.exe') THEN
      BEGIN
        IF CopyFile(Pchar(PathGinkoia + 'A_MAJ\verification.exe'), Pchar(PathGinkoia + 'verification.exe'), false) THEN
          deletefile(Pchar(PathGinkoia + 'A_MAJ\verification.exe'));
      END;
      // Lancement si dans les + ou - deux minutes
      IF H1 THEN
      BEGIN
        decodeTime(HEURE1, H, M, S, D);
        IF CalculeTemps(H, m, s, True) < 120000 THEN
        BEGIN
          Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Automatique H1', 0);
          Debut := Now;
          IF H2 THEN
            ok := ReplicationAutomatique(false, false, 0)
          ELSE
            ok := ReplicationAutomatique(false, true, 0);
          Ajoute('', 0);
          Event(LaBase0, CstReplicationAutomatiqueH1, Ok, Now - Debut);
          WHILE CalculeTemps(H, m, s, True) < 120000 DO
            LeDelay(1000);

          IF NOT H2 THEN
          BEGIN
            IF VerifChangeHorraire THEN
            BEGIN
              InitialiseLaunch;
              EXIT;
            END;
          END;
          InitialiseLaunch;
          EXIT;
        END;
      END;
      IF H2 THEN
      BEGIN
        decodeTime(HEURE2, H, M, S, D);
        IF CalculeTemps(H, m, s, True) < 120000 THEN
        BEGIN
          // réplication
          Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Automatique H2', 0);
          Debut := Now;
          ok := ReplicationAutomatique(false, true, 0);
          Ajoute('', 0);
          Event(LaBase0, CstReplicationAutomatiqueH2, Ok, Now - Debut);
          WHILE CalculeTemps(H, m, s, True) < 120000 DO
            LeDelay(1000);
          IF VerifChangeHorraire THEN
          BEGIN
            InitialiseLaunch;
            EXIT;
          END;
          InitialiseLaunch;
          EXIT;
        END;
      END;
      IF EtatBackup = 5 THEN
      BEGIN
        decodeTime(HeureBackup, H, M, S, D);
        IF CalculeTemps(H, m, s, True) < 120000 THEN
        BEGIN
          LancementBackup;
          WHILE CalculeTemps(H, m, s, True) < 120000 DO
            LeDelay(1000);
        END;
      END;

      IF EtatBackup = 3 THEN
      BEGIN
        IF CalculeTemps(23, 0, 0, True) < 120000 THEN
        BEGIN
          LancementBackup;
          WHILE CalculeTemps(23, 0, 0, True) < 120000 DO
            LeDelay(1000);
        END;
      END;
      IF EtatBackup = 4 THEN
      BEGIN
        IF CalculeTemps(22, 0, 0, True) < 120000 THEN
        BEGIN
          LancementBackup;
          WHILE CalculeTemps(22, 0, 0, True) < 120000 DO
            LeDelay(1000);
        END;
      END;

      //  1 après la 1° réplication
      //  2 après la 2° réplication
      //  3 à 23 H
      //  4 à 22 H
      //  5 à heure fixe
      //  à minuit vérification du changement d'horraire
      IF (Sender <> NIL) AND (CalculeTemps(0, 0, 2, True) < 120000) THEN
      BEGIN
        IF VerifChangeHorraire THEN
        BEGIN
          InitialiseLaunch;
          EXIT;
        END;
      END;

      IF ModeDebug THEN Ajoute('Calcule du prochain temps ', 0);
      decodeTime(now, H, M, S, D);

      // on lance à heure pile
      Ecart1 := CalculeTemps(H + 1, 0, 0, false);
      IF ecart1 < 120000 THEN
        ecart1 := 120000;

      // relancer le timer à heure réplication H1
      IF H1 THEN
      BEGIN
        IF ModeDebug THEN Ajoute('H1 Valide ', 0);
        decodeTime(HEURE1, H, M, S, D);
        Ecart2 := CalculeTemps(H, M, S, False);
        IF ModeDebug THEN Ajoute('Dans ' + Inttostr(Ecart2) + ' Ms', 0);
        IF ecart2 > 120000 THEN
        BEGIN
          IF Ecart2 < Ecart1 THEN
            Ecart1 := Ecart2;
        END;
      END;

      // relancer le timer à heure réplication H2
      IF H2 THEN
      BEGIN
        IF ModeDebug THEN Ajoute('H2 Valide ', 0);
        decodeTime(HEURE2, H, M, S, D);
        Ecart2 := CalculeTemps(H, M, S, False);
        IF ModeDebug THEN Ajoute('Dans ' + Inttostr(Ecart2) + ' Ms', 0);
        IF ecart2 > 120000 THEN
        BEGIN
          IF Ecart2 < Ecart1 THEN
            Ecart1 := Ecart2;
        END;
      END;

      IF etatBackup = 5 THEN
      BEGIN
        IF ModeDebug THEN Ajoute('Backup Valide ', 0);
        decodeTime(HeureBackup, H, M, S, D);
        Ecart2 := CalculeTemps(H, M, S, False);
        IF ModeDebug THEN Ajoute('Dans ' + Inttostr(Ecart2) + ' Ms', 0);
        IF ecart2 > 120000 THEN
        BEGIN
          IF Ecart2 < Ecart1 THEN
            Ecart1 := Ecart2;
        END;
      END;

      IF Ecart1 < 10000 THEN
        Ecart1 := 10000;
      IF ModeDebug THEN Ajoute('Le temps : ' + Inttostr(Ecart1), 0);
      Tim_LanceRepli.Interval := Ecart1;
      Tim_LanceRepli.enabled := true;
    END;
  FINALLY
    TRY
      data.close;
    EXCEPT
    END;
    TRY
      data_evt.close;
    EXCEPT
    END;
  END;
END;

//---------------------------------------------------------------
// Lancement manuel de la réplication
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.Button1Click(Sender: TObject);
VAR
  debut: TDateTime;
  ok: Boolean;
BEGIN
  Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Manuelle', 0);
  debut := Now;
  ok := ReplicationAutomatique(true, False, 0);
  Event(Labase0, CstReplicationManuel, ok, Now - Debut);
  IF ok THEN
  BEGIN
    Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Réussie', 0);
    Messmaj1 := '';
    Messmaj2 := '';
  END
  ELSE
    Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);
  Ajoute('', 0);
  Info;
END;

//---------------------------------------------------------------
// Connexion à internet en fonction du mode choisi
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.Deconnexion;
BEGIN
  IF (Connectionencours <> NIL) AND
    (Connectionencours.LeType = 0) THEN
    DeconnexionModem;
  Connectionencours := NIL;
END;

//---------------------------------------------------------------
// deconnexion d'internet en fonction du mode choisi
//---------------------------------------------------------------

FUNCTION TFrm_LaunchV7.Connexion(repli: TLesreplication): Boolean;
VAR
  i: Integer;
  reg: tregistry;
BEGIN
  reg := tregistry.create(KEY_WRITE);
  TRY
    reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\', False);
    reg.WriteInteger('GlobalUserOffline', 0);
  FINALLY
    reg.closekey;
    reg.free;
  END;
  result := false;
  i := 0;
  Connectionencours := NIL;
  WHILE i < ListeConnexion.Count DO
  BEGIN
    Connectionencours := TLesConnexion(ListeConnexion[i]);
    IF Connectionencours.LeType = 1 THEN // Routeur : Juste un Ping
    BEGIN
      Ajoute(DateTimeToStr(Now) + '   ' + 'Connexion par un routeur', 0);
      IF UnPing(repli.URLDISTANT + repli.ping) THEN
      BEGIN
        Ajoute(DateTimeToStr(Now) + '   ' + 'Connexion réussi', 0);
        tempsReplication := Now;
        result := true;
        BREAK;
      END
      ELSE
        Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de connexion au routeur', 0);
    END
    ELSE
    BEGIN // Connexion sur modem
      tempsreplication := Now;
      Ajoute(DateTimeToStr(Now) + '   ' + 'Connexion par un modem', 0);
      IF ConnexionModem(Connectionencours.Nom, Connectionencours.TEL) THEN
      BEGIN
        Ajoute(DateTimeToStr(Now) + '   ' + 'Connexion réussi', 0);
        result := true;
        BREAK;
      END
      ELSE
        Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de connexion au modem', 0);
    END;
    Inc(i);
  END;
  IF NOT result THEN
    Connectionencours := NIL;
END;

//---------------------------------------------------------------
// deconnexion des trigger de la base
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.DeconnexionTriger(Base: STRING);
BEGIN
  Data.close;
  Data.DatabaseName := Base;
  TRY
    TRY
      Data.Open;
    EXCEPT
      IF ModeDebug THEN Ajoute('Problème connexion à la base Deconnexion trigger ', 0);
      RAISE;
    END;
    tran.active := true;
    IB_Divers.Sql.Clear;
    IB_Divers.Sql.Add('execute procedure BN_ACTIVETRIGGER(0);');
    IB_Divers.ExecSql;
    IB_Divers.Sql.Clear;
    IB_Divers.Sql.Add('execute procedure SM_AVANT_REPLI ;');
    IB_Divers.ExecSql;
    commit;
    Event(Base, CstDeconnexionTrigger, true, Null);
  FINALLY
    data.close;
  END;
END;

//---------------------------------------------------------------
// reconnexion des trigger de la base
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.connexionTriger(Base: STRING);
BEGIN
  Data.close;
  Data.DatabaseName := Base;
  TRY
    TRY
      Data.Open;
    EXCEPT
      IF ModeDebug THEN Ajoute('Problème connexion à la base connexion trigger ', 0);
      RAISE;
    END;
    tran.active := true;
    IB_Divers.Sql.Clear;
    IB_Divers.Sql.Add('execute procedure BN_ACTIVETRIGGER(1);');
    IB_Divers.ExecSql;
    commit;
    Event(Base, CstReconnexionTrigger, true, Null);
  FINALLY
    data.close;
  END;
END;

//---------------------------------------------------------------
// recalcule des trigger de la base
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.recalculeTriger(Base: STRING);
VAR
  IdDos: Integer;
  debut: TDateTime;
  ok: boolean;

  PROCEDURE Marque_Base(Valeur: Integer);
  BEGIN
    IF IdDos = -1 THEN
    BEGIN
      IdDos := NouvelleClef;
      InsertK(IdDos, -11111338);
      Ib_Divers.Sql.Clear;
      Ib_Divers.Sql.Add('INSERT INTO GenDossier');
      Ib_Divers.Sql.Add('(DOS_ID, DOS_NOM, DOS_STRING,DOS_FLOAT)');
      Ib_Divers.Sql.Add('VALUES');
      Ib_Divers.Sql.Add('(' + ListeEnStr([IdDos, 'T-' + IB_LaBaseBAS_ID.AsString, DateToStr(Date), Valeur]) + ')');
      Ib_Divers.ExecSql;
    END
    ELSE
    BEGIN
      ModifK(IdDos);
      Ib_Divers.Close;
      Ib_Divers.Sql.Clear;
      Ib_Divers.Sql.ADD('UPDATE GENDOSSIER');
      Ib_Divers.Sql.ADD('SET DOS_STRING =' + EnStr(DateToStr(Date)) + ',');
      Ib_Divers.Sql.ADD('   DOS_FLOAT=' + EnStr(Valeur));
      Ib_Divers.Sql.Add('WHERE DOS_ID = ' + EnStr(IdDos));
      Ib_Divers.ExecSql;
    END;
    Commit;
  END;

BEGIN
  Debut := Now;
  Data.close;
  Data.DatabaseName := Base;
  ok := true;
  boolRecalculOk := true; //lab signale l'erreur pour déclencher l'affichage du message d'erreur recalcul
  TRY
    TRY
      Data.Open;
    EXCEPT
      IF ModeDebug THEN Ajoute('Problème connexion à la base recalcul trigger ', 0);
      RAISE;
    END;
    tran.active := true;
    Ib_Divers.Sql.Clear;
    Ib_Divers.Sql.Add('Select DOS_ID');
    Ib_Divers.Sql.Add('From GenDossier');
    Ib_Divers.Sql.Add('Where DOS_NOM =' + enStr('T-' + IB_LaBaseBAS_ID.AsString));
    Ib_Divers.Open;
    IF Ib_Divers.IsEmpty THEN
    BEGIN
      IdDos := -1;
    END
    ELSE
      IdDos := Ib_Divers.Fields[0].AsInteger;
    Ib_Divers.Close;
    Ajoute(DateTimeToStr(Now) + '   ' + 'Calcul ', 0);
    TRY
      REPEAT
        AjouteTC('.', 0);
        Commit;
        IB_CalculeTrigger.Close;
        IB_CalculeTrigger.Open;
      UNTIL IB_CalculeTriggerRETOUR.AsInteger = 0;
      Commit;
      IB_CalculeTrigger.Close;
      // tous bon on le marque
      Ajoute(DateTimeToStr(Now) + '   ' + 'Recalcul OK ', 0);
      Marque_Base(1);
    EXCEPT
      // erreur de recalcule des trigger
      ok := false;
      IF tran.InTransaction THEN
        tran.rollback;
      tran.Active := true;
      Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le recalcul ', 0);
      boolRecalculOk := false;
      Marque_Base(0);
    END;
  FINALLY
    data.close;
  END;
  Event(Base, CstRecalculeTrigger, Ok, Now - Debut);
END;

//---------------------------------------------------------------
// Faire le PUSH
//---------------------------------------------------------------

FUNCTION TFrm_LaunchV7.LoopPUSH(repli: TLesreplication): Boolean;
VAR
  I: Integer;
  // FC 16/06/2009 : Migration, remplacement du TSimpleHTTP par TidHTTP
  ResultBody: STRING;
  temps: ttimestamp;
  tsl: tstringList;
  tsSource: TStrings;
  DebutPush: TDateTime;
  Debut: TDateTime;
BEGIN
  if repli.ListProvider.count = 0 then
  begin
    result := True;
    Debut := Now;
  end
  else begin
    Result := PUSH(repli, true);
  end;



//    result := False;
//    Debut := Now;
//    ForceDirectories(repli.PlaceEai + 'RESULT\PUSH\');
//    FOR i := 0 TO repli.ListProvider.count - 1 DO
//    BEGIN
//      Ajoute(DateTimeToStr(Now) + '   ' + format('%-30s', ['Envoie ' + TLesProvider(repli.ListProvider[i]).Nom]) + #09, 0);
//      DebutPush := Now;
//      TRY
//        tsSource := TStringList.Create;
//        TRY
//          FHTTP.Request.UserName := repli.User;
//          FHTTP.Request.Password := repli.PWD;
//          //        FHTTP.Request.Expires := 300;
//          FHTTP.ConnectTimeout := 2500; // 2.5 sec
//          FHTTP.ReadTimeout := 300000; // 300 sec
//
//          tsSource.Clear;
//          tsSource.Add('Caller=' + Application.ExeName);
//          tsSource.Add('Provider=' + TLesProvider(repli.ListProvider[i]).Nom);
//          tsSource.Add('VERSION_STEP=750');
//          TRY
//            ResultBody := MyHTTP.Get(SourceToURL(repli.URLLocal + 'LoopOnPush', tsSource));
//            temps := dateTimeToTimeStamp(Now);
//            tsl := tstringList.Create;
//            TRY
//              tsl.Text := ResultBody;
//              IF (pos('ERROR', UpperCase(tsl.Text)) > 0)
//                OR (pos('LOGITEM', UpperCase(tsl.Text)) > 0) THEN
//              BEGIN
//                tsl.Savetofile(repli.PlaceEai + 'RESULT\PUSH\' + Inttostr(temps.Date) + '-' + Inttostr(temps.Time) + '-' + Inttostr(i + 1) + '.Xml');
//                result := false;
//                Messmaj1 := Messmaj1 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur le PUSH-LOOP : ' + TLesProvider(repli.ListProvider[i]).Nom;
//                BREAK;
//              END
//              ELSE result := True;
//            FINALLY
//              tsl.free;
//            END;
//          EXCEPT
//            result := false;
//            Messmaj1 := Messmaj1 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur le LoopOnPUSH..';
//            BREAK;
//          END;
//        FINALLY
//          tsSource.free;
//        END;
//      FINALLY
//        Event(repli.PlaceBase, CstModulePush + i, result, Now - DebutPush);
//        AjouteTC('  Fin ' + DateTimeToStr(Now), 0);
//      END;
//    END;
//  end;
//  // Push Provider
//  Event(repli.PlaceBase, CstPush, result, Now - Debut);
END;

FUNCTION TFrm_LaunchV7.PUSH(repli: TLesreplication; bForceLoop : boolean = False): Boolean;
VAR
  I: Integer;
  // FC 16/06/2009 : Migration, remplacement du TSimpleHTTP par TidHTTP
  ResultBody: STRING;
  temps: ttimestamp;
  tsl: tstringList;
  DebutPush: TDateTime;
  Debut: TDateTime;

  // FC 25/01/2012 : Modif instanciation FHTTP
  sUrlParams : string; // Paramètres passés à l'url  
  sLibOrdre  : string; // Libellé à afficher dans le message
BEGIN
  result := False;
  Debut := Now;
  ForceDirectories(repli.PlaceEai + 'RESULT\PUSH\');
  FOR i := 0 TO repli.ListProvider.count - 1 DO
  BEGIN
    Ajoute(DateTimeToStr(Now) + '   ' + format('%-30s', ['Envoie ' + TLesProvider(repli.ListProvider[i]).Nom]) + #09, 0);
    DebutPush := Now;
    TRY
      sUrlParams := '?Caller=' + Application.ExeName;
      sUrlParams := sUrlParams + '&Provider=' + TLesProvider(repli.ListProvider[i]).Nom;

      MyHTTP := GetTIdHTTP(repli.User, repli.PWD, 2500);
      TRY
        IF (TLesProvider(repli.ListProvider[i]).Loop = 1) OR (bForceLoop) THEN
        BEGIN
          MyHTTP.ReadTimeout := 300000; // 300 sec
          sUrlParams         := sUrlParams + '&VERSION_STEP=750';
          sLibOrdre          := 'PUSH-LOOP';
          ResultBody         := MyHTTP.Get(repli.URLLocal + 'LoopOnPush' + sUrlParams);
        END
        ELSE
        BEGIN
          MyHTTP.ReadTimeout := 1800000; // 1800 sec
          sLibOrdre          := 'PUSH';
          ResultBody         := MyHTTP.Get(repli.URLLocal + repli.Push + sUrlParams);
        END;
        temps := dateTimeToTimeStamp(Now);
        tsl := tstringList.Create;
        TRY
          tsl.Text := ResultBody;
          IF (pos('ERROR', UpperCase(tsl.Text)) > 0)
            OR (pos('LOGITEM', UpperCase(tsl.Text)) > 0) THEN
          BEGIN
            tsl.Savetofile(repli.PlaceEai + 'RESULT\PUSH\' + Inttostr(temps.Date) + '-' + Inttostr(temps.Time) + '-' + Inttostr(i + 1) + '.Xml');
            result := false;
            Messmaj1 := Messmaj1 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur le ' + sLibOrdre + ' : ' + TLesProvider(repli.ListProvider[i]).Nom;
            MyHTTP.Free;
            BREAK;  // ATTENTION BREAK
          END
          ELSE begin
            result := True;
          end;
        FINALLY
          tsl.free;
        END;
        MyHTTP.Free;
      EXCEPT
        result := false;
        Messmaj1 := Messmaj1 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur le ' + sLibOrdre + '...';
        MyHTTP.Free;
        BREAK;
      END;
    FINALLY
      Event(repli.PlaceBase, CstModulePush + i, result, Now - DebutPush);
      AjouteTC('  Fin ' + DateTimeToStr(Now), 0);
    END;
  END;
  // Push Provider
  Event(repli.PlaceBase, CstPush, result, Now - Debut);
END;

//---------------------------------------------------------------
// Faire le PULL
//---------------------------------------------------------------

FUNCTION TFrm_LaunchV7.LoopPULL(repli: TLesreplication): Boolean;
//VAR
//  I: Integer;
//  // FC 16/06/2009 : Migration, remplacement du TSimpleHTTP par TidHTTP
//  ResultBody: STRING;
//  tsSource: TStrings;
//  temps: ttimestamp;
//  tsl: tstringList;
//  DebutPull: TDateTime;
//  Debut: TDateTime;
BEGIN
  Result := PULL(repli, True);  // Remplacé par un flag dans la procédure pull

  // ATTENTION PROCEDURE DEPRECIE

//  result := False;
//  Debut := Now;
//  ForceDirectories(repli.PlaceEai + 'RESULT\PULL\');
//  FOR i := 0 TO repli.ListSubScriber.count - 1 DO
//  BEGIN
//    Ajoute(DateTimeToStr(Now) + '   ' + format('%-30s', ['Reception ' + TLesProvider(repli.ListSubScriber[i]).Nom]) + #09, 0);
//    DebutPull := Now;
//    TRY
//      tsSource := TStringList.Create;
//      TRY
//        FHTTP.Request.UserName := repli.User;
//        FHTTP.Request.Password := repli.PWD;
//        //        FHTTP.Request.Expires := 300;
//        FHTTP.ConnectTimeout := 2500; // 2.5 sec
//        FHTTP.ReadTimeout := 300000; // 300 sec
//        tsSource.Clear;
//        tsSource.Add('Caller=' + Application.ExeName);
//        tsSource.Add('Subscription=' + TLesProvider(repli.ListSubScriber[i]).Nom);
//        TRY
//          tsSource.Add('VERSION_STEP=750');
//          ResultBody := FHTTP.Get(SourceToURL(repli.URLLocal + 'LoopOnPull', tsSource));
//          temps := dateTimeToTimeStamp(Now);
//          tsl := tstringList.Create;
//          TRY
//            tsl.Text := ResultBody;
//            IF (pos('ERROR', UpperCase(tsl.Text)) > 0)
//              OR (pos('LOGITEM', UpperCase(tsl.Text)) > 0) THEN
//            BEGIN
//              tsl.Savetofile(repli.PlaceEai + 'RESULT\PULL\' + Inttostr(temps.Date) + '-' + Inttostr(temps.Time) + '-' + Inttostr(i + 1) + '.Xml');
//              result := false;
//              Messmaj2 := Messmaj2 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur le PULL-LOOP : ' + TLesProvider(repli.ListSubScriber[i]).Nom;
//              BREAK;
//            END
//            ELSE result := True;
//          FINALLY
//            tsl.free;
//          END;
//        EXCEPT
//          result := false;
//          Messmaj2 := Messmaj2 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur le LoopOnPULL..';
//          BREAK;
//        END;
//      FINALLY
//        tsSource.free;
//      END;
//    FINALLY
//      AjouteTC('  Fin ' + DateTimeToStr(Now), 0);
//      Event(repli.PlaceBase, CstModulePull + i, result, Now - DebutPull);
//    END;
//  END;
//  Event(repli.PlaceBase, CstPull, result, Now - Debut);
//  //Pull Subscripter
END;

FUNCTION TFrm_LaunchV7.PULL(repli: TLesreplication; bForceLoop : boolean = False): Boolean;
VAR
  I: Integer;
  ResultBody: STRING;   // FC 16/06/2009 : Migration, remplacement du TSimpleHTTP par TidHTTP

  temps: ttimestamp;
  tsl: tstringList;
  DebutPull: TDateTime;
  Debut: TDateTime;

  // FC 25/01/2012 : Modif instanciation FHTTP
  sUrlParams : string; // Paramètres passés à l'url  
  sLibOrdre  : string; // Libellé à afficher dans le message
BEGIN
  if repli.ListSubScriber.count = 0 then
  begin
    result := True;
    Debut := Now;
  end
  else begin
    result := False;
    Debut := Now;
    ForceDirectories(repli.PlaceEai + 'RESULT\PULL\');
    FOR i := 0 TO repli.ListSubScriber.count - 1 DO
    BEGIN
      Ajoute(DateTimeToStr(Now) + '   ' + format('%-30s', ['Reception ' + TLesProvider(repli.ListSubScriber[i]).Nom]) + #09, 0);
      DebutPull := Now;
      TRY
        sUrlParams := '?Caller=' + Application.ExeName;
        sUrlParams := sUrlParams + '&Subscription=' + TLesProvider(repli.ListSubScriber[i]).Nom;

        MyHTTP := GetTIdHTTP(repli.User, repli.PWD, 2500);
        TRY
          IF (TLesProvider(repli.ListSubScriber[i]).Loop = 1) OR (bForceLoop) THEN
          BEGIN
            MyHTTP.ReadTimeout := 300000;
            sUrlParams         := sUrlParams + '&VERSION_STEP=750';
            sLibOrdre          := 'PULL-LOOP';
            ResultBody         := MyHTTP.Get(repli.URLLocal + 'LoopOnPull' + sUrlParams);
          END
          ELSE
          BEGIN
            MyHTTP.ReadTimeout := 900000;
            sLibOrdre          := 'PULL';
            ResultBody         := MyHTTP.Get(repli.URLLocal + repli.Pull + sUrlParams);
          END;

          temps := dateTimeToTimeStamp(Now);
          tsl := tstringList.Create;
          TRY
            tsl.Text := ResultBody;
            // modification pour nouveau XML
            IF (pos('ERROR', UpperCase(tsl.Text)) > 0)
              OR (pos('LOGITEM', UpperCase(tsl.Text)) > 0) THEN
            BEGIN
              tsl.Savetofile(repli.PlaceEai + 'RESULT\PULL\' + Inttostr(temps.Date) + '-' + Inttostr(temps.Time) + '-' + Inttostr(i + 1) + '.Xml');
              result := false;
              Messmaj2 := Messmaj2 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur le ' + sLibOrdre + ' : ' + TLesProvider(repli.ListSubScriber[i]).Nom;
              MyHTTP.Free;
              BREAK;  // ATTENTION BREAK
            END
            ELSE result := True;
          FINALLY
            tsl.free;
          END;
          MyHTTP.Free;
        EXCEPT
          result := false;
          Messmaj2 := Messmaj2 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur le ' + sLibOrdre + '...';
          MyHTTP.Free;
          BREAK;
        END;
      FINALLY
        AjouteTC('  Fin ' + DateTimeToStr(Now), 0);
        Event(repli.PlaceBase, CstModulePull + i, result, Now - DebutPull);
      END;
    END;
  end;
  Event(repli.PlaceBase, CstPull, result, Now - Debut);
END;

//---------------------------------------------------------------
// Lancement de la réplication
//---------------------------------------------------------------

PROCEDURE TFrm_LaunchV7.EnvoisenLOOP1Click(Sender: TObject);
VAR
  debut: TDateTime;
  ok: Boolean;
BEGIN
  Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Manuelle que l''envoi en LOOP', 0);
  debut := Now;
  ok := ReplicationAutomatique(true, False, 1, True);
  Event(Labase0, CstReplicationManuel, ok, Now - Debut);
  IF ok THEN
  BEGIN
    Ajoute(DateTimeToStr(Now) + '   ' + 'Envoi en LOOP Réussie', 0);
    Messmaj1 := '';
  END
  ELSE
    Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);
  Ajoute('', 0);
END;

PROCEDURE TFrm_LaunchV7.RceptionenLOOP1Click(Sender: TObject);
VAR
  debut: TDateTime;
  ok: Boolean;
BEGIN
  Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Manuelle que la réception en LOOP', 0);
  debut := Now;
  ok := ReplicationAutomatique(true, False, 2, True);
  Event(Labase0, CstReplicationManuel, ok, Now - Debut);
  IF ok THEN
  BEGIN
    Ajoute(DateTimeToStr(Now) + '   ' + 'Réception en LOOP Réussie', 0);
    Messmaj2 := '';
  END
  ELSE
    Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);
  Ajoute('', 0);
END;

PROCEDURE TFrm_LaunchV7.RplicationenLOOP1Click(Sender: TObject);
VAR
  debut: TDateTime;
  ok: Boolean;
BEGIN
  Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Manuelle en LOOP', 0);
  debut := Now;
  ok := ReplicationAutomatique(true, False, 0, true);
  Event(Labase0, CstReplicationManuel, ok, Now - Debut);
  IF ok THEN
  BEGIN
    Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication en LOOP Réussie', 0);
    Messmaj1 := '';
    Messmaj2 := '';
  END
  ELSE
    Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);
  Ajoute('', 0);
END;

FUNCTION TFrm_LaunchV7.ReplicationAutomatique(Manuelle, Derniere: Boolean; LeType: Byte; LOOP: Boolean = False): Boolean;
VAR
  i: integer;
  Connecte: Boolean;
  repli: TLesreplication;
  Debut: TDateTime;
  DebutRepli: TDateTime;
  repliOk: Boolean;

  OK: Boolean;
  reg: tregistry;
  tsl: tstringlist;
  s1,
    S: STRING;
  Max: Longint;
  DefaultLCID: LCID;

  iNbReplLog : integer;
BEGIN
  MessReplicPlateforme := '';

  // LeType = 0 pour les deux, 1 push uniquement, 2 pull uniquement

  // test pour vérifier que le séparateur décimal de la machine est bien une virgule
  DefaultLCID := GetThreadLocale;
  IF GetLocaleChar(DefaultLCID, LOCALE_SDECIMAL, '.') <> ',' THEN
  BEGIN
    result := false;
    application.messagebox('Le symbole décimal doit être la "," (virgule) pour que la réplication fonctionne' + #10#13 +
      'Corriger cette erreur dans le menu : Options régionales et linguistiques', 'ATTENTION', mb_ok);
    EXIT;
  END;

  IF synchroEnCours THEN
  BEGIN
    Ajoute('Synchronisation en cours, réplication annulée', 0);
    EXIT;
  END;

  reg := tregistry.create(KEY_WRITE);
  TRY
    reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings\', False);
    reg.WriteInteger('GlobalUserOffline', 0);
  FINALLY
    reg.free;
  END;
  ReplicOk := false;
  RepliEnCours := true;
  TRY
    enabled := false;
    TRY
      debut := Now;
      //
      IF MapGinkoia.Backup THEN
      BEGIN
        IF NOT TrouverlabonneHeure THEN
        BEGIN
          result := false;
          EXIT;
        END;
      END;
      MapGinkoia.Launcher := true;

      IF (BaseSauvegarde) OR (isPortableSynchro) THEN
      BEGIN
        // de toute facon, que l'envois
        LeType := 1;
        // Code annulé : trop long, et donc inutile
//        IF LeType = 1 THEN
//        BEGIN
//          // vérifier la cohérence de la réplication
//          // y'a t'il qquechose à envoyer ?
//          repli := TLesreplication(ListeReplication[0]);
//          tsl := tstringlist.Create;
//          TRY
//            tsl.loadfromfile(repli.PlaceEai + '\DelosQPMAgent.Providers.xml');
//          EXCEPT
//          END;
//          S := tsl.Text;
//          Max := 0;
//
//          // Récupère le last version maxi du fichier providers
//          WHILE Pos('<LAST_VERSION>', S) > 0 DO
//          BEGIN
//            delete(S, 1, Pos('<LAST_VERSION>', S) + 13);
//            S1 := Copy(S, 1, pos('<', S) - 1);
//            IF StrToInt(S1) > Max THEN
//              Max := StrToInt(S1);
//          END;
//
//          // Récupère le K_version max de la base
//          Data.close;
//          Data.DatabaseName := repli.PlaceBase;
//          Data.Open;
//          IB_Divers.Sql.Clear;
//          IB_Divers.Sql.Add('select Max(K_Version)');
//          IB_Divers.Sql.Add('from k join ktb on (ktb.ktb_id = k.Ktb_ID)');
//          IB_Divers.Sql.Add('Where Not (ktb_name starting ''K'')');
//          IB_Divers.Sql.Add('  And not (ktb_name in (''GENHISTOEVT'',''GENDOSSIER''))');
//          IB_Divers.Sql.Add('  And k_version<gen_id(general_id,0)');
//          IB_Divers.Open;
//
//          // On compare le k_version max et le last version max pour savoir si on doit envoyer kkchose
//          IF NOT (Max < IB_Divers.Fields[0].AsInteger) THEN
//            LeType := 3;
//          Data.close;
//        END;
      END;

      Connecte := false;
      Connectionencours := NIL;
      result := true;
      TRY
        IF letype IN [0, 1, 2] THEN
        BEGIN
          TRY
            FOR i := 0 TO ListeReplication.Count - 1 DO
            BEGIN
              repli := TLesreplication(ListeReplication[i]);
              
              try
                // Vérification du REPL_LOG
                Data.close;
                Data.DatabaseName := repli.PlaceBase;
                Data.Open;

                IB_Divers.Close;
                IB_Divers.SQL.Clear;
                IB_Divers.SQL.Text := 'SELECT count(*) FROM RDB$RELATION_FIELDS WHERE RDB$BASE_FIELD IS NULL AND RDB$RELATION_NAME = ''REPL_LOG''';
                IB_Divers.Open;
                IF IB_Divers.Fields[0].AsInteger > 0 THEN
                begin
                  IB_Divers.Close;
                  IB_Divers.SQL.Clear;
                  IB_Divers.SQL.Text := 'SELECT count(*) FROM REPL_LOG';
                  IB_Divers.Open;

                  iNbReplLog := IB_Divers.Fields[0].AsInteger;

                  IB_Divers.Close;
                  IB_Divers.SQL.Clear;
                  IB_Divers.SQL.Text := 'UPDATE GENBASES SET BAS_REPLOG = ' + IntToStr(iNbReplLog) + ' WHERE BAS_ID = ' + IntToStr(IdBase);
                  IB_Divers.ExecSQL;

                  IB_Divers.Close;
                  IB_Divers.SQL.Clear;
                  IB_Divers.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(' + IntToStr(IdBase) + ', 0)';
                  IB_Divers.ExecSQL;
                end;
                IB_Divers.Close;
              Except

              end;

              Ajoute(DateTimeToStr(Now) + '   ' + 'Base ' + repli.PlaceBase, 0);
              DebutRepli := Now;
              repliOk := true;
              TRY
                //1° : Lancer DelosQpmAgent
                IF WinExec(Pchar(repli.PlaceEai + 'Delos_QpmAgent.exe'), 0) > 31 THEN
                BEGIN
                  TRY
                    Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement de QPMAgent ', 0);
                    Sleep(1000);
                    //2° : tester si le ping local fonctionne
                    IF UnPing(repli.URLLocal + repli.ping) THEN
                    BEGIN
                      Ajoute(DateTimeToStr(Now) + '   ' + 'PING Local OK ', 0);
                      IF NOT Connecte THEN
                      BEGIN
                        Ajoute(DateTimeToStr(Now) + '   ' + 'Connexion à Internet', 0);
                        IF NOT Connexion(repli) THEN
                        BEGIN
                          // Pas de connexion à internet
                          MessMAJ1 := DateTimeToStr(Now) + '   ' + 'Pas de connexion à internet';
                          Ajoute(MessMAJ1, 0);
                          result := false;
                          repliOk := False;
                          BREAK;
                        END
                        ELSE
                          Connecte := true;
                      END;

                      //3° : Essayer un Ping Distant
                      IF UnPing(repli.URLDISTANT + repli.ping) THEN
                      BEGIN
                        Ajoute(DateTimeToStr(Now) + '   ' + 'PING Distant OK ', 0);
                        IF (Connectionencours = NIL) OR
                          (Connectionencours.LeType = 1) THEN
                        BEGIN
                          Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement du PING en Boucle ', 0);
                          InitPing(repli.URLDISTANT + repli.ping, 120000);
                        END;

                        TRY
                          IF LeType IN [0, 1] THEN
                          BEGIN
                            // Push Provider
                            IF (i = 0) AND (letype = 0) THEN
                              Ok := Lancementdesreferencements(1, repli);

                            DeconnexionTriger(repli.PlaceBase);
                            TRY

                              Ajoute(DateTimeToStr(Now) + '   ' + 'Début du PUSH ', 0);
                              IF loop THEN
                                Ok := LoopPush(repli)
                              ELSE
                                Ok := Push(repli);
                              IF Ok THEN
                              BEGIN
                                Ajoute(DateTimeToStr(Now) + '   ' + 'PUSH Réussi', 0);
                                IF LeType = 0 THEN
                                BEGIN
                                  //Pull Subscripter
                                  IF (i = 0) AND (letype = 0) THEN
                                    Ok := Lancementdesreferencements(2, repli);

                                  IF (bReplicPlateforme) AND (NOT Ok) THEN
                                  BEGIN
                                    // En mode PF, on teste si le référencement à marché.
                                    // problème
                                    Ajoute(MessReplicPlateforme, 0);
                                    result := false;
                                    repliOk := False;
                                  END
                                  else BEGIN


                                    Ajoute(DateTimeToStr(Now) + '   ' + 'Début du PULL', 0);
                                    IF Loop THEN
                                      Ok := LoopPull(repli)
                                    ELSE
                                      Ok := Pull(repli);
                                    IF NOT ok THEN
                                    BEGIN
                                      // problème
                                      Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le PULL', 0);
                                      result := false;
                                      repliOk := False;
                                    END
                                    ELSE
                                    BEGIN
                                      Ajoute(DateTimeToStr(Now) + '   ' + 'PULL réussi', 0);
                                      IF (i = 0) AND (letype = 0) THEN
                                        Ok := Lancementdesreferencements(3, repli);
                                    END;
                                  END;
                                END;
                              END
                              ELSE
                              BEGIN
                                result := false;
                                repliOk := False;
                                Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le PUSH', 0);
                              END;
                            FINALLY
                              connexionTriger(repli.PlaceBase);
                            END;
                          END
                          ELSE
                          BEGIN
                            DeconnexionTriger(repli.PlaceBase);
                            TRY
                              //Pull Subscripter
                              Ajoute(DateTimeToStr(Now) + '   ' + 'Début du PULL', 0);
                              IF loop THEN
                                ok := LoopPull(repli)
                              ELSE
                                Ok := Pull(Repli);
                              IF NOT ok THEN
                              BEGIN
                                // problème
                                Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le PULL', 0);
                                result := false;
                                repliOk := False;
                              END
                              ELSE
                                Ajoute(DateTimeToStr(Now) + '   ' + 'PULL réussi', 0);
                            FINALLY
                              connexionTriger(repli.PlaceBase);
                            END;
                          END;
                        FINALLY
                          Ajoute(DateTimeToStr(Now) + '   ' + 'Arret du PING', 0);
                          StopPing;
                        END;
                      END
                      ELSE
                      BEGIN
                        // Pas Ping distant
                        MessMAJ1 := DateTimeToStr(Now) + '   ' + 'Pas de PING Distant ';
                        Ajoute(MessMAJ1, 0);
                        result := false;
                        repliOk := False;
                      END;
                    END
                    ELSE
                    BEGIN
                      // Pas de Ping en local
                      MessMAJ1 := DateTimeToStr(Now) + '   ' + 'Pas de PING Local ';
                      Ajoute(MessMAJ1, 0);
                      result := false;
                      repliOk := False;
                    END;
                  FINALLY
                    Ajoute(DateTimeToStr(Now) + '   ' + 'Arret de QPMAgent', 0);
                    ArretDelos;
                  END;
                END
                ELSE
                BEGIN
                  // Pas possible de lancer QpmAgent
                  MessMAJ1 := DateTimeToStr(Now) + '   ' + 'Impossible de lancer QPMAgent ';
                  Ajoute(MessMAJ1, 0);
                  //                  Ajoute (DateTimeToStr (Now) + '   ' + 'Impossible de lancer QPMAgent ', 0) ;
                  result := False;
                  repliOk := False;
                END;
              FINALLY
                Event(repli.PlaceBase, CstUneReplication, repliOk, Now - DebutRepli);
              END;
            END;

            IF connecte THEN
            BEGIN
              IF (NOT Manuelle) OR (ForcerLaMaj) THEN
              BEGIN
                IF fileexists(IncludeTrailingBackslash(Extractfilepath(Application.exename)) + 'Verification.exe') THEN
                BEGIN
                  Winexec(Pchar(IncludeTrailingBackslash(Extractfilepath(Application.exename)) + 'Verification.exe'), 0);
                  Sleep(20000);
                  WHILE MapGinkoia.Verifencours DO
                    sleep(5000);
                END;
              END;

              Ajoute(DateTimeToStr(Now) + '   ' + 'Deconnexion d''internet', 0);
              Deconnexion;
              Connecte := false;
              Event(LaBase0, CstConnexionGlobal, result, Now - tempsReplication);
            END;

          FINALLY
            TRY
              StopPing;
              IF connecte THEN
              BEGIN
                Ajoute(DateTimeToStr(Now) + '   ' + 'Deconnexion d''internet', 0);
                Deconnexion;
                //Connecte := false;
                Event(LaBase0, CstConnexionGlobal, result, Now - tempsReplication);
              END;
            EXCEPT
            END;
          END;
          Connectionencours := NIL;
        END;
      FINALLY
        FOR i := 0 TO ListeReplication.Count - 1 DO
        BEGIN
          repli := TLesreplication(ListeReplication[i]);
          Ajoute(DateTimeToStr(Now) + '   ' + 'Recalcule Base ' + Repli.PlaceBase, 0);
          recalculeTriger(repli.PlaceBase);
        END;
      END;
    FINALLY
      enabled := true
    END;

    Event(LaBase0, CstTempsReplication, result, Now - Debut);
    MapGinkoia.Launcher := False;
    RepliEnCours := false;
    IF ((NOT Manuelle) OR (ForcerLaMaj)) and not(PasDeVerifACauseDeSynchro) THEN
    BEGIN
      IF fileexists(IncludeTrailingBackslash(Extractfilepath(Application.exename)) + 'Verification.exe') THEN
      BEGIN
        Winexec(Pchar(IncludeTrailingBackslash(Extractfilepath(Application.exename)) + 'Verification.exe MAJ'), 0);
        Sleep(40 * 1000);
        WHILE (MapGinkoia.Verifencours OR MapGinkoia.MajAuto) DO
          Sleep(10 * 1000);
        //
      END;
    END;
    IF (NOT Manuelle) THEN
    BEGIN
      IF NOT (H1 AND H2) THEN // une seul réplication
      BEGIN
        IF (EtatBackup = 2) OR (EtatBackup = 1) THEN
        BEGIN
          LancementBackup;
        END;
      END
      ELSE IF derniere AND (EtatBackup = 2) THEN
      BEGIN
        LancementBackup;
      END
      ELSE IF NOT derniere AND (EtatBackup = 1) THEN
      BEGIN
        LancementBackup;
      END;

    END;
  FINALLY
    ReplicOk := Result;
    RepliEnCours := false;
    TRY
      Data_Evt.Close;
    EXCEPT
    END;
    // Ouvrir le laucher à la fin de la réplication
    Hide;
    FormStyle := FsStayOnTop;
    Show;
    WindowState := wsNormal;
    Application.processmessages;
    FormStyle := FsNormal;

  END;
  //
END;

//---------------------------------------------------------------
// Recherche une heure pour lancer la réplication
//---------------------------------------------------------------

FUNCTION TFrm_LaunchV7.TrouverlabonneHeure: Boolean;
VAR
  LeTps: Integer;
  Ok: Boolean;
  hh, mm, ss, dd: Word;
  i: Integer;
BEGIN
  result := False;
  WHILE MapGinkoia.Backup DO
  BEGIN
    Application.processMessages;
    Sleep(10000);
  END;
  Decodetime(Now, hh, mm, ss, dd);
  IF hh >= 7 THEN
    EXIT;
  data.DatabaseName := LaBase0;
  TRY
    data.Open;
  EXCEPT
    IF ModeDebug THEN Ajoute('Problème connexion à la base trouve la bonne heure ', 0);
    RAISE;
  END;

  TRY
    tran.Active := true;
    REPEAT
      ok := true;
      Ib_TousHorraire.Open;
      WHILE NOT Ib_TousHorraire.Eof DO
      BEGIN
        IF Ib_TousHorraireLAU_H1.AsInteger = 1 THEN
        BEGIN
          LeTps := Abs(trunc(Ib_TousHorraireLAU_HEURE1.AsDateTime) - trunc(Now));
          IF LeTps < 0.0104 THEN // 15 min
          BEGIN
            ok := false;
            BREAK;
          END;
        END;
        IF Ib_TousHorraireLAU_H2.AsInteger = 1 THEN
        BEGIN
          LeTps := Abs(trunc(Ib_TousHorraireLAU_HEURE2.AsDateTime) - trunc(Now));
          IF LeTps < 0.0104 THEN // 15 min
          BEGIN
            ok := false;
            BREAK;
          END;
        END;
        Ib_TousHorraire.next;
      END;
      Ib_TousHorraire.Close;
      IF NOT ok THEN
      BEGIN
        FOR i := 1 TO 30 DO // 5 Min
        BEGIN
          Sleep(10000);
          Application.processMessages;
        END;
        Decodetime(Now, hh, mm, ss, dd);
        IF hh >= 7 THEN
          EXIT;
      END;
    UNTIL Ok;
  FINALLY
    data.close;
  END;
END;

FUNCTION TFrm_LaunchV7.NouvelleClef_evt: Integer;
BEGIN
  Sp_NewKey_Evt.Prepare;
  Sp_NewKey_Evt.ExecProc;
  Result := Sp_NewKey_Evt.Parambyname('NEWKEY').AsInteger;
  Sp_NewKey_Evt.UnPrepare;
  Sp_NewKey_Evt.Close;
END;

PROCEDURE TFrm_LaunchV7.InsertK_Evt(Clef, Table: Integer);
BEGIN
  Ib_Divers_Evt.Sql.Clear;
  Ib_Divers_Evt.Sql.Add('Insert Into K');
  Ib_Divers_Evt.Sql.Add(' (K_ID,KRH_ID,KTB_ID,K_VERSION,K_ENABLED,KSE_OWNER_ID,KSE_INSERT_ID,K_INSERTED,KSE_DELETE_ID,K_DELETED,KSE_UPDATE_ID,K_UPDATED,KSE_LOCK_ID,KMA_LOCK_ID)');
  Ib_Divers_Evt.Sql.Add(' VALUES ');
  Ib_Divers_Evt.Sql.Add(' (' + IntToStr(Clef) + ',-101,' + InttoStr(Table) + ',' + IntToStr(Clef) + ',1,-1,-1,Current_Date,0,''01/01/1980'',-1,Current_Date,0,0)');
  Ib_Divers_Evt.ExecSQL;
  Ib_Divers_Evt.Sql.Clear;
END;

PROCEDURE TFrm_LaunchV7.Commit_Evt;
BEGIN
  IF Tran_EVT.InTransaction THEN
    Tran_EVT.Commit;
  Tran_EVT.Active := true;
END;

PROCEDURE TFrm_LaunchV7.AfficherleLauncher1Click(Sender: TObject);
BEGIN
  Show;
END;

PROCEDURE TFrm_LaunchV7.QuitterleLauncher1Click(Sender: TObject);
BEGIN
  Tray_Launch.NoClose := False;
  Close;
END;

PROCEDURE TFrm_LaunchV7.Quitter1Click(Sender: TObject);
BEGIN
  Tray_Launch.NoClose := False;
  Close;
END;

PROCEDURE TFrm_LaunchV7.Cacher1Click(Sender: TObject);
BEGIN
  close;
END;

PROCEDURE TFrm_LaunchV7.Tray_LaunchDblClick(Sender: TObject);
BEGIN
  show;
  FormStyle := FsStayOnTop;
  Application.processmessages;
  FormStyle := FsNormal;
END;

PROCEDURE TFrm_LaunchV7.Envois1Click(Sender: TObject);
VAR
  debut: TDateTime;
  ok: Boolean;
BEGIN
  Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Manuelle que l''envoi', 0);
  debut := Now;
  ok := ReplicationAutomatique(true, False, 1);
  Event(Labase0, CstReplicationManuel, ok, Now - Debut);
  IF ok THEN
  BEGIN
    Ajoute(DateTimeToStr(Now) + '   ' + 'Envoie Réplication Réussie', 0);
    Messmaj1 := '';
  END
  ELSE
    Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);
  Ajoute('', 0);
END;

PROCEDURE TFrm_LaunchV7.rception1Click(Sender: TObject);
VAR
  debut: TDateTime;
  ok: Boolean;
BEGIN
  Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Manuelle que la réception', 0);
  debut := Now;
  ok := ReplicationAutomatique(true, False, 2);
  Event(Labase0, CstReplicationManuel, ok, Now - Debut);
  IF ok THEN
  BEGIN
    Ajoute(DateTimeToStr(Now) + '   ' + 'Réception Réplication Réussie', 0);
    Messmaj2 := '';
  END
  ELSE
    Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);
  Ajoute('', 0);
END;

PROCEDURE TFrm_LaunchV7.Recalculedestriggers1Click(Sender: TObject);
VAR
  debut: TDateTime;
  ok: Boolean;
BEGIN
  Ajoute(DateTimeToStr(Now) + '   ' + 'Recalcul manuel des triggers', 0);
  debut := Now;
  ok := ReplicationAutomatique(true, False, 3);
  Event(Labase0, CstReplicationManuel, ok, Now - Debut);
  IF ok THEN
    Ajoute(DateTimeToStr(Now) + '   ' + 'Recalcul Réussie', 0)
  ELSE
    Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le Recalcul ', 0);
  Ajoute('', 0);
END;

PROCEDURE TFrm_LaunchV7.FormClose(Sender: TObject;
  VAR Action: TCloseAction);
BEGIN
  IF Tray_Launch.NoClose THEN
  BEGIN
    Hide;
    Action := CaNone;
  END;
END;

PROCEDURE TFrm_LaunchV7.FormPaint(Sender: TObject);
BEGIN
  IF FirstPaint THEN
  BEGIN
    FirstPaint := false;
    IF Initialisation1.visible THEN
    BEGIN
      IF (paramCount > 0) AND (uppercase(paramstr(1)) = 'AUTOINIT') THEN
      BEGIN
        Initialisation1Click(NIL);
      END;
    END;
  END;
END;

PROCEDURE TFrm_LaunchV7.Apropos1Click(Sender: TObject);
BEGIN
  AboutDlg_Main.Execute;
END;

PROCEDURE TFrm_LaunchV7.Consomation1Click(Sender: TObject);
VAR
  Frm_Conso: TFrm_Conso;
BEGIN
  TRY
    Application.CreateForm(TFrm_Conso, Frm_Conso);
    Dm_LaunchV7.ConnectDataBase(LaBase0);
    //Frm_Conso.OuvreQuery(Basid);
    Frm_Conso.OuvreQuery(idBase);
    Frm_Conso.ShowModal;
  FINALLY
    Frm_Conso.FermeQuery;
    Dm_LaunchV7.CloseDataBase;
    Frm_Conso.Free;
  END;
END;

PROCEDURE TFrm_LaunchV7.ConsomationInternet1Click(Sender: TObject);
VAR
  Frm_Conso: TFrm_Conso;
BEGIN
  TRY
    Application.CreateForm(TFrm_Conso, Frm_Conso);
    Dm_LaunchV7.ConnectDataBase(LaBase0);
    Frm_Conso.OuvreQuery(0);
    Frm_Conso.ShowModal;
  FINALLY
    Frm_Conso.FermeQuery;
    Dm_LaunchV7.CloseDataBase;
    Frm_Conso.Free;
  END;
END;

PROCEDURE TFrm_LaunchV7.Rplication1Click(Sender: TObject);
VAR
  Frm_SuiviReplic: TFrm_SuiviReplic;
BEGIN
  TRY
    Application.CreateForm(TFrm_SuiviReplic, Frm_SuiviReplic);
    Dm_LaunchV7.ConnectDataBase(LaBase0);
    //Frm_SuiviReplic.OuvreQuery(Basid);
    Frm_SuiviReplic.OuvreQuery(idBase);
    Frm_SuiviReplic.ShowModal;
  FINALLY
    Frm_SuiviReplic.FermeQuery;
    Dm_LaunchV7.CloseDataBase;
    Frm_SuiviReplic.Free;
  END;
END;

function TFrm_LaunchV7.Lancementdesreferencements(Num: Integer; Rep: TLesreplication): boolean;
VAR
  I, j: Integer;
  // FC 16/06/2009 : Migration, remplacement du TSimpleHTTP par TidHTTP
  ResultBody: STRING;
  TslResult : TStringList;
  tsSource: TStrings;
  S1: STRING;
  S: STRING;
  Ref: TLesReference;
  tbl, Chp: STRING;
  Tsl: TstringList;
  prov: STRING;
  subs: STRING;
  sMessProvSub : string;

  // FC : 12/2011 : Rendre bloquant les ref
  temps : TTimeStamp;
BEGIN
  MessReplicPlateforme := '';
//  if (bReplicPlateforme) then
//    Result := False
//  else
  Result := True;

  TRY
    Tsl := tstringList.create;

    TRY
      FOR i := 0 TO ListeReference.count - 1 DO
      BEGIN
        prov := '';
        subs := '';
        IF TLesReference(ListeReference[i]).Place = Num THEN
        BEGIN
          ref := TLesReference(ListeReference[i]);
          Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement référencement ' + ref.Ordre, 0);

          tsSource := TStringList.Create;
          TRY
            tsSource.Clear;
            FOR j := 0 TO ref.LesLig.Count - 1 DO
            BEGIN
              sMessProvSub := '';
              S := TLesReferenceLig(ref.LesLig[j]).Param;
              IF pos('=', S) > 0 THEN
              BEGIN
                S1 := Copy(S, Pos('=', S) + 1, 255);
                S := Copy(S, 1, Pos('=', S) - 1);
                IF Copy(S1, 1, 1) = '?' THEN
                BEGIN
                  delete(s1, 1, 1);
                  IF Pos('.', S1) > 0 THEN
                  BEGIN
                    tbl := Copy(S1, 1, Pos('.', S1) - 1);
                    Chp := Copy(S1, Pos('.', S1) + 1, 255);
                    DataPass.Close;
                    DataPass.DataBaseName := rep.PlaceBase;
                    DataPass.Open;
                    Tranpass.active := true;
                    IBQue_Pass.Sql.Clear;
                    IBQue_Pass.Sql.ADD('Select ' + Chp);
                    IBQue_Pass.Sql.ADD('FROM ' + Tbl + ' Join k on (K_ID=' + Copy(chp, 1, 4) + 'ID and K_ENABLED=1)');
                    IBQue_Pass.Open;
                    WHILE NOT IBQue_Pass.Eof DO
                    BEGIN
                      IF trim(IBQue_Pass.Fields[0].AsString) <> '' THEN
                        tsl.add(S + '=' + IBQue_Pass.Fields[0].AsString);
                      IBQue_Pass.Next;
                    END;
                    IBQue_Pass.Close;
                    DataPass.Close;
                  END;
                END
                ELSE
                BEGIN
                  IF uppercase(S) = 'PROVIDER' THEN prov := S1;
                  IF (uppercase(S) = 'SUBSCRIBER') OR (uppercase(S) = 'SUBSCRIPTION') THEN subs := S1;
                  tsSource.Add(S + '=' + S1);
                END;
              END;
            END;
            IF tsl.count > 0 THEN
            BEGIN
              ForceDirectories(Rep.PlaceEai + 'RESULT\PUSH\');

              FOR j := 0 TO Tsl.count - 1 DO
              BEGIN
                S := TSL[j];
                S1 := Copy(S, Pos('=', S) + 1, 255);
                S := Copy(S, 1, Pos('=', S) - 1);
                tsSource.Add(S + '=' + S1);
                IF uppercase(S) = 'PROVIDER' THEN prov := S1;
                IF (uppercase(S) = 'SUBSCRIBER') OR (uppercase(S) = 'SUBSCRIPTION') THEN subs := S1;
                Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement avec ' + S + ' = ' + S1, 0);
                temps := dateTimeToTimeStamp(Now);


                MyHTTP := GetTIdHTTP('', '', 5000);
                try
                  MyHTTP.ReadTimeout := 900000; // 900 sec (15 min)
                  ResultBody := MyHTTP.Get(SourceToURL(ref.URL + ref.Ordre, tsSource));
                except
                  on e: Exception do
                  begin
                    ResultBody := 'ERROR - Exception sur le get : ' + E.Message;
                  end;
                end;
                MyHttp.Free;

                if bReplicPlateforme then
                begin
                  TslResult := tstringList.Create;
                  TRY
                    TslResult.Text := ResultBody;
                    IF (pos('ERROR', UpperCase(TslResult.Text)) > 0)
                      OR (pos('LOGITEM', UpperCase(TslResult.Text)) > 0) THEN
                    BEGIN
                      TslResult.Savetofile(Rep.PlaceEai + 'RESULT\PUSH\' + Inttostr(temps.Date) + '-' + Inttostr(temps.Time) + '-' + Inttostr(i + 1) + '.Xml');
                      result := false;
                      Messmaj1 := Messmaj1 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur réplication plateforme ' + S + ' = ' + S1;
                      MessReplicPlateforme := DateTimeToStr(Now) + ' Problème sur réplication plateforme ' + S + ' = ' + S1;
                      BREAK;
                    END
                    ELSE
                      result := True;
                  FINALLY
                    TslResult.free;
                  END;
                end;
              END;
              tsl.clear;
            END
            ELSE
            BEGIN
              IF prov <> '' THEN
              begin
                Ajoute(DateTimeToStr(Now) + '   ' + 'Référencement  Provider=' + prov, 0);
                sMessProvSub := 'Provider = ' + prov;
              end;
              IF subs <> '' THEN
              begin
                Ajoute(DateTimeToStr(Now) + '   ' + 'Référencement  Suscriber=' + subs, 0);
                sMessProvSub := 'Suscriber = ' + subs;
              end;
              MyHTTP := GetTIdHTTP('', '', 5000);
              try
                MyHTTP.ReadTimeout := 900000; // 900 sec (15 min)
                ResultBody := MyHTTP.Get(SourceToURL(ref.URL + ref.Ordre, tsSource));
              except
                  on e: Exception do
                  begin
                    ResultBody := 'ERROR - Exception sur le get : ' + E.Message;
                  end;
              end;
              MyHttp.Free;


              if bReplicPlateforme then
              begin
                TslResult := tstringList.Create;
                TRY
                  TslResult.Text := ResultBody;
                  IF (pos('ERROR', UpperCase(TslResult.Text)) > 0)
                    OR (pos('LOGITEM', UpperCase(TslResult.Text)) > 0) THEN
                  BEGIN
                    TslResult.Savetofile(Rep.PlaceEai + 'RESULT\PUSH\' + Inttostr(temps.Date) + '-' + Inttostr(temps.Time) + '-' + Inttostr(i + 1) + '.Xml');
                    result := false;

                    Messmaj1 := Messmaj1 + #13 + #10 + DateTimeToStr(Now) + ' Problème sur réplication plateforme ' + sMessProvSub + ' / ' + S + ' = ' + S1;
                    MessReplicPlateforme := DateTimeToStr(Now) + ' Problème sur réplication plateforme ' + sMessProvSub + ' / ' + S + ' = ' + S1;
                    BREAK;
                  END
                  ELSE
                    result := True;
                FINALLY
                  TslResult.free;
                END;
              end;
            END;
          FINALLY
            tsSource.free;
          END;
        END;
      END;
    FINALLY
      tsl.free;
    END;
  EXCEPT
    // ne pas blocker la réplication
    Ajoute(DateTimeToStr(Now) + '   ' + 'Exception lors du référencement', 0);
    if bReplicPlateforme then
    begin
      Result := False;
    end;
  END;
END;

PROCEDURE TFrm_LaunchV7.Referencement1Click(Sender: TObject);
VAR
  FRM_Reference: TFRM_Reference;
  ok: Boolean;
  RRL: TLesReferenceLig;
  RRE: TLesReference;
  I, J: Integer;
BEGIN
  IF MotDePasse THEN
  BEGIN
    Ok := False;
    data.close;
    TRY
      data.DatabaseName := LaBase0;
      TRY
        data.Open;
      EXCEPT
        IF ModeDebug THEN Ajoute('Problème connexion à la base Referencement1Click ', 0);
        RAISE;
      END;
      tran.Active := true;
      ok := false;
      Application.Createform(TFRM_Reference, FRM_Reference);
      TRY
        ok := FRM_Reference.execute(ListeReference);
        IF ok THEN
        BEGIN
          FOR i := 0 TO ListeReference.Count - 1 DO
          BEGIN
            RRE := TLesReference(ListeReference[i]);
            IF rre.Supp THEN
            BEGIN
              IF rre.ID <> -1 THEN
                DeleteK(rre.ID);
            END
            ELSE IF rre.Id = -1 THEN
            BEGIN
              rre.Id := NouvelleClef;
              InsertK(RRe.Id, CstTblRRE);
              IB_Divers.Sql.Clear;
              WITH IB_Divers.Sql DO
              BEGIN
                Add('INSERT INTO GENREPREFER');
                ADD('(RRE_ID, RRE_POSITION, RRE_PLACE, RRE_URL, RRE_ORDRE)');
                Add(' VALUES');
                ADD('(' + ListeEnStr([RRe.ID, rre.position, rre.Place, rre.URL, rre.Ordre]) + ')')
              END;
              Ib_Divers.ExecSQL;
            END
            ELSE IF rre.Change THEN
            BEGIN
              ModifK(RRe.Id);
              IB_Divers.Sql.Clear;
              WITH IB_Divers.Sql DO
              BEGIN
                ADD('UPDATE GENREPREFER');
                ADD('SET RRE_POSITION = ' + EnStr(rre.Position));
                ADD('    ,RRE_PLACE = ' + EnStr(rre.Place));
                ADD('    ,RRE_URL = ' + EnStr(rre.URL));
                ADD('    ,RRE_ORDRE = ' + EnStr(rre.ORDRE));
                ADD('WHERE RRE_ID = ' + EnStr(RRE.ID));
              END;
              Ib_Divers.ExecSQL;
            END;
            FOR j := 0 TO rre.LesLig.count - 1 DO
            BEGIN
              RRL := TLesReferenceLig(rre.LesLig[J]);
              IF rre.Supp OR RRL.Supp THEN
              BEGIN
                IF rrl.ID <> -1 THEN
                  DeleteK(rrl.ID);
              END
              ELSE IF RRL.ID = -1 THEN
              BEGIN
                rrl.Id := NouvelleClef;
                InsertK(RRl.Id, CstTblRRL);
                IB_Divers.Sql.Clear;
                WITH IB_Divers.Sql DO
                BEGIN
                  ADD('INSERT INTO GENREPREFERLIGNE');
                  ADD('(RRL_ID, RRL_RREID, RRL_PARAM)');
                  ADD('VALUES');
                  ADD('(' + ListeEnStr([RRL.ID, RRE.ID, RRL.PARAM]) + ')');
                END;
                Ib_Divers.ExecSQL;
              END
              ELSE IF rrl.Change THEN
              BEGIN
                ModifK(RRl.Id);
                IB_Divers.Sql.Clear;
                WITH IB_Divers.Sql DO
                BEGIN
                  ADD('UPDATE GENREPREFERLIGNE');
                  ADD('SET RRL_PARAM = ' + EnStr(rrl.Param));
                  ADD('WHERE RRL_ID = ' + EnStr(RRL.ID));
                END;
                Ib_Divers.ExecSQL;
              END;
            END;
          END;
          Commit;
        END;
      FINALLY
        FRM_Reference.release;
      END;
    FINALLY
      data.close;
    END;
    IF ok THEN
    BEGIN
      VerifChangeHorraire;
      InitialiseLaunch;
    END;
  END;
END;

PROCEDURE TFrm_LaunchV7.dataBeforeConnect(Sender: TObject);
BEGIN
  IF MapGinkoia.Backup THEN
    ABORT;
END;

PROCEDURE TFrm_LaunchV7.Data_EvtBeforeConnect(Sender: TObject);
BEGIN
  IF MapGinkoia.Backup THEN
    ABORT;
END;

PROCEDURE TFrm_LaunchV7.serveurClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  VAR ErrorCode: Integer);
BEGIN
  ErrorCode := 0;
END;

PROCEDURE TFrm_LaunchV7.serveurClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
VAR
  S: STRING;
BEGIN
  S := Socket.ReceiveText;
  IF trim(S) = 'DEMARRE' THEN
  BEGIN
    StartService;
    Socket.SendText('OK');
  END;
  IF trim(S) = 'ARRET' THEN
  BEGIN
    StopService;
    Socket.SendText('OK');
  END;
  IF trim(S) = 'PRESENT' THEN
  BEGIN
    Socket.SendText('OK');
  END;
END;

PROCEDURE TFrm_LaunchV7.ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  VAR ErrorCode: Integer);
BEGIN
  ErrorCode := 0;
  encours := -99;
END;

PROCEDURE TFrm_LaunchV7.ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
VAR
  S: STRING;
BEGIN
  S := Socket.ReceiveText;
  IF S = 'OK' THEN
    inc(encours)
  ELSE
    encours := -Encours;
END;

PROCEDURE TFrm_LaunchV7.SetTimerIntervalReplicJour;
// FC : 16/12/2008, Ajout du module réplic en journée
VAR
  hNextPeriode: TDateTime;
  iNextPeriodeMS: integer;
BEGIN
  // Bloc de calcul de l'intervale du timer
  TRY
    // Init random
    Randomize();

    // Est ce qu'on est en période de réplication (à 1h près)
    IF ((hDebReplic - (1 / 24)) <= Now) AND (Now <= hFinReplic) THEN
    BEGIN
      // On set l'intervalle avec l'interval habituel + un temps aléatoire pour etaler sur la période les magasins
      // intervale + ou - 30 secondes
      Tim_ReplicJour.Interval := iIntervale + Trunc(Random(30000));
      hNextReplic := Now + (Tim_ReplicJour.Interval / (24 * 60 * 60 * 1000))
    END ELSE
    BEGIN
      // On set l'intervalle hors réplic
      // on calcule le prochain lancement, pour mettre l'intervalle comme il faut
      IF hDebReplic <= Now THEN
        hNextPeriode := ((hDebReplic + 1) - Now)
      ELSE
        hNextPeriode := Now - hDebReplic;

      // On se met 10 minutes avant le prochain lancement prévu
      hNextPeriode := hNextPeriode - (10 / (24 * 60));

      // On transforme en millisecondes et on fait - 2h
      iNextPeriodeMS := trunc(hNextPeriode * 24 * 60 * 60 * 1000) - (2 * 60 * 60 * 1000);

      IF iNextPeriodeMS <= 0 THEN
        iNextPeriodeMS := 60 * 60 * 1000;

      // On set le prochain timer
      Tim_ReplicJour.Interval := iNextPeriodeMS;

      hNextReplic := Now + hNextPeriode;
    END;
  EXCEPT
    ON E: Exception DO
    BEGIN
      // En cas d'exception, on relance le timer pour un intervale fixe, afin de réessayer
      Tim_ReplicJour.Interval := iIntervale;
      hNextReplic := Now + (iIntervale / (24 * 60 * 60 * 1000))
    END;
  END;

  IF ModeDebug THEN
    Ajoute('(Replic Jour) Prochain time dans (ms) : ' + inttostr(Tim_ReplicJour.Interval), 0)

END;

FUNCTION TFrm_LaunchV7.SourceToURL(AURL: STRING; ASource: TStrings): STRING;
VAR
  i: Integer;
  sRes: STRING;
BEGIN
  sRes := '';
  FOR i := 0 TO ASource.Count - 1 DO
  BEGIN
    sRes := sRes + '&' + ASource[i];
  END;

  IF sRes <> '' THEN
    sRes[1] := '?';

  Result := AURL + sRes;
END;

PROCEDURE TFrm_LaunchV7.MajDebFinReplicJour;
// FC : 16/12/2008, Ajout du module réplic en journée
BEGIN
  // Récup dans la base
  Ib_GetParamReplicJour.ParamByName('BAS_ID').AsInteger := IdBase;
  Ib_GetParamReplicJour.Open;
  IF Ib_GetParamReplicJourOK.AsInteger in [1, 2] THEN
  BEGIN
    dtReplicBegin := Ib_GetParamReplicJourHDEB.AsFloat;
    dtReplicEnd := Ib_GetParamReplicJourHFIN.AsFloat;
    iIntervale := Ib_GetParamReplicJourINTERVALE.AsInteger;
    iOrdre := Ib_GetParamReplicJourOK.AsInteger;
    bReplicJourActif := True;
  END
  else BEGIN
    dtReplicBegin := Now;
    dtReplicEnd := Now;
    iIntervale := 300000;
    bReplicJourActif := False;
  END;
  Ib_GetParamReplicJour.Close;

  // Récup de l'heure de début de réplic pour aujourd'hui
  hDebReplic := Trunc(Now) + Frac(dtReplicBegin);

  // Récup de la fin de réplic
  hFinReplic := Trunc(Now) + Frac(dtReplicEnd);
  IF dtReplicBegin > dtReplicEnd THEN // La fin est avant le début, donc fin le lendemain
    hFinReplic := hFinReplic + 1;

END;

FUNCTION TFrm_LaunchV7.ReplicJourToDo: Boolean;
BEGIN
  Result := False;
  TRY
    IF bReplicJourActif THEN
    BEGIN
      // Est ce qu'on est en période de réplication ?
      IF (hDebReplic <= Now) AND (Now <= hFinReplic) THEN
      BEGIN
        IF (NOT MapGinkoia.Backup) AND (NOT RepliEnCours) THEN
        BEGIN
          Result := True;
        END
        ELSE BEGIN
          Result := False;
        END;
      END
      ELSE BEGIN
        Result := False;
      END;
    END
    ELSE
    BEGIN
      Result := False;
    END;
  EXCEPT
    ON E: Exception DO
    BEGIN
      Result := False;
    END;
  END;
END;

FUNCTION TFrm_LaunchV7.DoReplicJour(): Boolean;
// FC : 16/12/2008, Ajout du module réplic en journée
VAR
  i: integer;

  repli: TLesreplication; // Réplic en cours de traitement

  Debut, DebutRepli: TDateTime; // Début du traitement, Début de la réplication

  RepliOk: Boolean; // Traitement terminé correctement ou pas

  Ok, Connecte: Boolean; // Flags pour savoir si réussi fonction, si on est connecté

  DefaultLCID: LCID;
  reg: tregistry;
BEGIN
  Result := False;

  TRY
    // test pour vérifier que le séparateur décimal de la machine est bien une virgule
    DefaultLCID := GetThreadLocale;
    IF GetLocaleChar(DefaultLCID, LOCALE_SDECIMAL, '.') <> ',' THEN
    BEGIN
      result := false;
      application.messagebox('Le symbole décimal doit être la "," (virgule) pour que la réplication fonctionne'#10#13 +
        'Corriger cette erreur dans le menu : Options régionales et linguistiques', 'ATTENTION', mb_ok);
      EXIT;
    END;

    IF synchroEnCours THEN
    BEGIN
      Ajoute('Synchronisation en cours, réplication annulée', 0);
      EXIT;
    END;

    reg := tregistry.create(KEY_WRITE);
    TRY
      reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Settings\', False);
      reg.WriteInteger('GlobalUserOffline', 0);
    FINALLY
      reg.free;
    END;

    Enabled := False;
    MapGinkoia.Launcher := true;
    TRY
      Debut := Now;

      // Pas de réplic journée sur le serveur de secours
      IF NOT (BaseSauvegarde) THEN
      BEGIN
        Connecte := false;
        Connectionencours := NIL;
        result := true;
        TRY // Try For
          // Parcours toute la liste des dossiers réplication à traiter
          FOR i := 0 TO ListeReplicJour.Count - 1 DO
          BEGIN
            // On stock dans 'Repli' le Iième Objet de la liste créée à partir de la table GENREPLICATION
            repli := TLesreplication(ListeReplicJour[i]);
            Ajoute(DateTimeToStr(Now) + '   ' + 'Base ' + repli.PlaceBase, 0); // Log
            DebutRepli := Now; // Flag début de réplication
            RepliOk := true; // Init à true, si pb -> False

            // On exécute SM_AVANT_REPLI pour les seuils de stock
//            Exec_AvantRepli(repli.PlaceBase);

            TRY
              //1° : Lancer DelosQpmAgent
              IF WinExec(Pchar(repli.PlaceEai + 'Delos_QpmAgent.exe'), 0) > 31 THEN
              BEGIN
                TRY
                  Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement de QPMAgent ', 0); // Log
                  Sleep(1000); // On patiente, le temps qu'il soit bien lancé

                  //2° : tester si le ping local fonctionne
                  IF UnPing(repli.URLLocal + repli.ping) THEN
                  BEGIN
                    Ajoute(DateTimeToStr(Now) + '   ' + 'PING Local OK ', 0);
                    IF NOT Connecte THEN
                    BEGIN
                      Ajoute(DateTimeToStr(Now) + '   ' + 'Connexion à Internet', 0);
                      IF NOT Connexion(repli) THEN
                      BEGIN
                        // Pas de connexion à internet -> sortie de boucle
                        Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de connexion à internet', 0);
                        result := false;
                        repliOk := False;
                        BREAK;
                      END
                      ELSE
                        Connecte := true;
                    END;

                    //3° : Essayer un Ping Distant
                    IF UnPing(repli.URLDISTANT + repli.ping) THEN
                    BEGIN
                      Ajoute(DateTimeToStr(Now) + '   ' + 'PING Distant OK ', 0);

                      // Type 1 = Routeur : ping en boucle
                      IF (Connectionencours = NIL) OR (Connectionencours.LeType = 1) THEN
                      BEGIN
                        Ajoute(DateTimeToStr(Now) + '   ' + 'Lancement du PING en Boucle ', 0);
                        InitPing(repli.URLDISTANT + repli.ping, 120000);
                      END;

                      TRY
                          // Déconnecte les triggers et envoie SM_AvantRepli
                          DeconnexionTriger(repli.PlaceBase);

                          if iOrdre = 2 then // Ordre = 2 -> Push puis pull
                          begin
                            // Push Provider
                            // Lance le push
                            Ajoute(DateTimeToStr(Now) + '   ' + 'Début du PUSH ', 0); // Log
                            Ok := Push(repli);
                            IF Ok THEN
                            BEGIN
                              Ajoute(DateTimeToStr(Now) + '   ' + 'PUSH Réussi', 0); // Log
                            END
                            ELSE
                            BEGIN
                              result := false;
                              repliOk := False;
                              Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le PUSH', 0);
                            END;
                          end
                          else begin // ordre = 1 Pull, puis push
                            Ok := True;
                          end;

                          if Ok then // Ok est a true si on est en pull/push, ou si on est en push/pull et que le push a marche
                          begin
                            //Pull Subscripter
                            TRY
                              Ajoute(DateTimeToStr(Now) + '   ' + 'Début du PULL', 0);
                              Ok := Pull(repli); // Lancemenet du Pull
                              IF Ok THEN
                              BEGIN
                                Ajoute(DateTimeToStr(Now) + '   ' + 'PULL réussi', 0);
                              END
                              ELSE BEGIN
                                // problème
                                Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le PULL', 0);
                                result := false;
                                repliOk := False;
                              END;
                            FINALLY
                              RecalculeTriger(repli.PlaceBase);
                              ConnexionTriger(repli.PlaceBase);
                              RecalculeTriger(repli.PlaceBase);
                            END;
                          end;

                          if iOrdre = 1 then // Cas du Pull/Push
                          begin
                            // Contrairement à la réplic classique, on envoie le Push après, et non avant
                            // donc on le fait même si le pull a raté.

                            // Push Provider
                            // Lance le push
                            Ajoute(DateTimeToStr(Now) + '   ' + 'Début du PUSH ', 0); // Log
                            Ok := Push(repli);
                            IF Ok THEN
                            BEGIN
                              Ajoute(DateTimeToStr(Now) + '   ' + 'PUSH Réussi', 0); // Log
                            END
                            ELSE
                            BEGIN
                              result := false;
                              repliOk := False;
                              Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur le PUSH', 0);
                            END;
                          end;
                      FINALLY
                        Ajoute(DateTimeToStr(Now) + '   ' + 'Arret du PING', 0);
                        StopPing;
                      END;
                    END
                    ELSE
                    BEGIN
                      // Pas Ping distant
                      Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de PING Distant ', 0);
                      result := false;
                      repliOk := False;
                    END;
                  END
                  ELSE
                  BEGIN
                    // Pas de Ping en local
                    Ajoute(DateTimeToStr(Now) + '   ' + 'Pas de PING Local', 0);
                    result := false;
                    repliOk := False;
                  END;
                FINALLY
                  Ajoute(DateTimeToStr(Now) + '   ' + 'Arret de QPMAgent', 0);
                  ArretDelos;
                END;
              END
              ELSE
              BEGIN
                // Pas possible de lancer QpmAgent
                Ajoute(DateTimeToStr(Now) + '   ' + 'Impossible de lancer QPMAgent ', 0);
                result := False;
                repliOk := False;
              END;
            FINALLY
              // Event(repli.PlaceBase, CstUneReplication, repliOk, Now - DebutRepli);  // Pas de log
            END;
          END; // End For
        FINALLY
          TRY
            StopPing;
          FINALLY
            // quoi qu'il arrive, on déonncete si on est connecté
            IF Connecte THEN
            BEGIN
              Ajoute(DateTimeToStr(Now) + '   ' + 'Deconnexion d''internet', 0);
              Deconnexion;
              // Event(LaBase0, CstConnexionGlobal, result, Now - tempsReplication); // Pas de log
            END;

          END;
        END; // End try For
        Connectionencours := NIL;
      END; // End BaseSauvegarde

    FINALLY
      // On remet la possibilité de cliquer sur le form
      Enabled := true;
      MapGinkoia.Launcher := False;
    END;
    // Event(LaBase0, CstTempsReplication, result, Now - Debut);  // Pas de log
  EXCEPT
    ON E: Exception DO
    BEGIN
      Result := False;
    END;
  END;
END;

PROCEDURE TFrm_LaunchV7.Tim_ReplicJourTimer(Sender: TObject);
// FC : 16/12/2008, Ajout du module réplic en journée
BEGIN
  Tim_ReplicJour.Enabled := False;

  // Mise à jour de l'heure de début et fin de réplic
  MajDebFinReplicJour();

  // Calcul du prochain enclenchement du timer
  SetTimerIntervalReplicJour();

  // Vérifie si on doit répliquer
  IF ReplicJourToDo() THEN
  BEGIN
    DoReplicJourAndInfo();
  END;

  // Réactivation du timer
  IF bReplicJourActif THEN
    Tim_ReplicJour.Enabled := True;
END;

PROCEDURE TFrm_LaunchV7.Btn_ReplicJourClick(Sender: TObject);
BEGIN
  DoReplicJourAndInfo;
END;

PROCEDURE TFrm_LaunchV7.DoReplicJourAndInfo;
BEGIN
  IF bReplicJourActif THEN
  BEGIN
    IF DoReplicJour() THEN
    BEGIN
      // réplic ok
      IF NOT ModeDebug THEN
        Info;
      Ajoute('Résultat de la dernière réplication de journée : Réussie - ' + DateTimeToStr(Now()), 0)
    END
    ELSE BEGIN
      Ajoute('Résultat de la dernière réplication de journée : Echec - ' + DateTimeToStr(Now()), 0)
    END;
    Ajoute('Prochaine réplication prévue : ' + DateTimeToStr(hNextReplic), 0);
  END
  ELSE BEGIN
    Ajoute('Réplication de journée inactive, veuillez completer le paramétrage', 0);
  END;
END;

PROCEDURE TFrm_LaunchV7.Btn_SynchroniserClick(Sender: TObject);
VAR
  StartInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  strCmdline: STRING;  
  debut: TDateTime;
  ok: Boolean;
  SavPasDeVerifACauseDeSynchro: boolean;
BEGIN 
  Screen.Cursor := crHourGlass;
  TRY
    data.close;
    //actualiser le chemin de la base du serveur
    data.open;
    Que_CheminServeur.Close;
    Que_CheminServeur.open;
    //lire param dans la base, table genparam
    strPathBaseServ := Que_CheminServeurPrm_string.asstring;
    //tester l'existence de la copie de la base du serveur
    IF FileExists(strPathBaseServ) THEN
    BEGIN
      //message pour informer qu'il faut impérativement sauver la travail en cours et fermer ginkoia.
      IF MessageDlg('Assurez vous que toutes les applications Ginkoia sont fermées' + #13#10 +
                    'et le travail en cours sauvegardé avant de continuer',
                    mtInformation, [mbOk, MbCancel], 0) = mrOk THEN
      BEGIN
        //forcer la réplication : push avec vérification auto mais pas de pull
        SavPasDeVerifACauseDeSynchro := PasDeVerifACauseDeSynchro;
        PasDeVerifACauseDeSynchro := true;
        try  
          Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Manuelle', 0);
          debut := Now;
          ok := ReplicationAutomatique(true, False, 0);
          Event(Labase0, CstReplicationManuel, ok, Now - Debut);
          IF ok THEN
          BEGIN
            Ajoute(DateTimeToStr(Now) + '   ' + 'Réplication Réussie', 0);
            Messmaj1 := '';
            Messmaj2 := '';
          END
          ELSE
            Ajoute(DateTimeToStr(Now) + '   ' + 'Problème sur la Réplication ', 0);
          Ajoute('', 0);
          Info;
        finally
          PasDeVerifACauseDeSynchro := SavPasDeVerifACauseDeSynchro;
        end;

        //vérifier si la réplication c'est bien passée
        IF NOT ReplicOk THEN
        BEGIN
          //message d'avertissement
          IF MessageDlg('Attention votre réplication a rencontré un PROBLEME, '+#13+#10
              +'si vous avez des données GINKOIA sur ce poste elles seront perdues !'+#13+#10
              + 'Voulez-vous poursuivre la synchronisation ?', mtWarning, [mbYes, MbNo], 0, mbno)<>mryes THEN
            exit;
        END;

        //lancer le programe de synchronisation
        //signaler synchro en cours
        synchroEnCours := true;
        //Mise à zéro de la structure StartInfo
        FillChar(StartInfo, SizeOf(StartInfo), #0);
        //Seule la taille est renseignée, toutes les autres options laissées à zéro prendront les valeurs par défaut
        StartInfo.cb := SizeOf(StartInfo);
        Screen.Cursor := crHourGlass;
        strCmdLine := ExtractFilePath(Application.exename);
        if strCmdLine[Length(strCmdLine)]<>'\' then
          strCmdLine := strCmdLine +'\';
        strCmdLine := strCmdLine+'SynchroniserPortable.exe ' + '"' + Labase0 + '"';
        //Lancement de la ligne de commande avec en paramétre le chemin de la base du notebook
        IF NOT CreateProcess(NIL, Pchar(strCmdLine), NIL, NIL, False, 0, NIL, NIL, StartInfo, ProcessInfo) THEN
        BEGIN
          //si lancement échoue
          MessageDlg('Echec de la synchronisation : impossible de lancer le programme', mtWarning, [mbOk], 0);
          exit;
        END;
        Tray_Launch.NoClose := False;
        Close;
        exit;

      END;
    END
    ELSE
    BEGIN
      MessageDlg('Echec de la synchronisation :' + #13#10 + 'Impossible de trouver la copie de la base sur le réseau', mtWarning, [mbok], 0);
    END;
  FINALLY
    Screen.Cursor := crDefault;
    Que_CheminServeur.Close;
    data.close;
  END;
END;

procedure TFrm_LaunchV7.Btn_testClick(Sender: TObject);
begin
//  Application.CreateForm(TFrm_ListProSub, Frm_ListProSub);
//  TRY
//    Frm_ListProSub.ShowModal;
//  FINALLY
//    Frm_ListProSub.Free;
//  end;
end;

PROCEDURE TFrm_LaunchV7.SynchronisationClick(Sender: TObject);
VAR
  Frm_ParamSynchro: TFrm_ParamSynchro;
BEGIN
  //vérifier si mono base
  data.open;
  Que_Bases.Close;
  Que_Bases.open;
  IF Que_Bases.EOF THEN
  BEGIN
    MessageDlg('Base unique, pas de synchronisation possible.', mtInformation, [mbOK], 0);
  END
  ELSE
  BEGIN
    IF MotDePasse THEN
    BEGIN
      Dm_LaunchV7.ConnectDataBase(LaBase0);
      //si serveur afficher la liste des portables paramétré pour une synchro avec ce serveur
      IF isServeur THEN
      BEGIN
        ExecuteListeSynchro();
      END
      ELSE
      BEGIN
        //sinon ouvrir la fenètre de paramétrage
        ExecuteParamSynchro();
      END;
      Dm_LaunchV7.CloseDataBase();
      //actualiser les boutons en fonction des mises à jour
      boutonSynchro(1);
    END;
  END;
  data.close;
END;

PROCEDURE TFrm_LaunchV7.boutonSynchro(msgError: Integer);
BEGIN
  TRY
    data.close;
    data.open;
    //vérifier qu'il s'agit d'une base initialisée pour d'éventuelles synchro
    Que_CheminServeur.open;
    IF (Que_CheminServeur.RecordCount = 1) THEN
    BEGIN
      isPortableSynchro := (Que_CheminServeurPRM_INTEGER.asInteger = 1) AND (Que_CheminServeurPRM_String.asString <> '') AND (Que_CheminServeurPrm_Float.asinteger <> 0);
      //verifier s'il s'agit d'un serveur dont le paramétre de la synchro est actif
      isServeur := (Que_CheminServeurPRM_INTEGER.asInteger = 1) AND (Que_CheminServeurPRM_String.asString = '') AND (Que_CheminServeurPrm_Float.asinteger = 0);
      //bouton active si portable et synchro activée
      IF isPortableSynchro THEN
      BEGIN
        PasDeVerifACauseDeSynchro := true;
        Btn_Synchroniser.Visible := true;
        strPathBaseServ := Que_CheminServeurPrm_string.asstring;
      END
      ELSE
      BEGIN
        Btn_Synchroniser.Visible := false;
      END;
    END
    ELSE //sinon prévenir que le paramétre initial ne pas été créé dans genparam
    BEGIN
      IF msgError = 1 THEN
      BEGIN
        MessageDlg('Base pas initialisée pour la synchronisation', mtWarning, [mbOk], 0);
      END;
    END;
  FINALLY
    Que_CheminServeur.Close;
    data.close;
  END;
END;

FUNCTION TFrm_LaunchV7.SrvSecours_EstALancer: Boolean;
VAR
  stEtatService: TEtatService;
BEGIN
  ///  Vérifie si on a besoin d'un serveur de secours,
  ///  et si c'est le cas, vérifie si on est ok sur la config (service présent)
  ///  Sinon vérif si on a une base non configurée et le service présent.
  ///  Selon les cas, on va demander le démarrage du service
  ///  Il faut démarrer s'il est nécéssaire et qu'il n'est pas démarré (mais installé quand meme)
  stEtatService := SrvSecours_EtatService;

  Result := False;
  IF bSrvSecours_Present THEN
  BEGIN
    IF NOT InterBase7 THEN
    BEGIN
      Result := False;
      SrvSecoursAffErreur(1, 'La base est configurée pour un serveur de secours, mais la base n''est pas en interbase 7 ou supérieur');
    END
    ELSE BEGIN
      IF NOT stEtatService.bInstall THEN
      BEGIN
        Result := False;
        SrvSecoursAffErreur(2, 'La base est configurée pour un serveur de secours, mais le service n''est pas installé');
      END
      ELSE BEGIN
        IF stEtatService.bStarted THEN
        BEGIN
          IF NOT stEtatService.bAutomatique THEN
          BEGIN
            Result := False;
            SrvSecoursAffErreur(1, 'La base est configurée pour un serveur de secours, le service est lancé mais est en manuel');
          END
          ELSE BEGIN
            SrvSecoursAffErreur(); // C'est tout bon
            Result := False;
          END;
        END
        ELSE BEGIN
          Result := True;
          SrvSecoursAffErreur(2, 'La base est configurée pour un serveur de secours, mais le service n''est pas lancé');
        END;
      END;
    END;
  END
  ELSE BEGIN
    // Ne doit pas être installé (en tous cas pas en auto)
    IF stEtatService.bInstall AND stEtatService.bAutomatique THEN
    BEGIN
      // Problème
      SrvSecoursAffErreur(2, 'La base n''est pas configurée pour un serveur de secours, mais le service est présent');
      Result := False;
    END
    ELSE BEGIN
      SrvSecoursAffErreur();
      Result := False;
    END;
  END;

END;

FUNCTION TFrm_LaunchV7.SrvSecours_EtatService: TEtatService;
// Tester si le serveur de secours est bien en route.
VAR
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  Config: TQueryServiceConfig;
  PConfig: PQueryServiceConfig;
  iSize: DWORD;

BEGIN

  Result.bInstall := False;
  Result.bAutomatique := False;
  Result.bStarted := False;

  hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
  hService := OpenService(hSCManager, 'IBRepl', SERVICE_QUERY_STATUS OR SERVICE_QUERY_CONFIG);
  TRY
    IF hService <> 0 THEN
    BEGIN
      PConfig := @Config;
      iSize := 0;
      QueryServiceConfig(hService, PConfig, iSize, iSize);
      IF QueryServiceConfig(hService, PConfig, iSize, iSize) THEN
      BEGIN
        CASE Config.dwStartType OF
          SERVICE_AUTO_START: BEGIN
              Result.bInstall := True;
              Result.bAutomatique := True;
            END;

          SERVICE_DEMAND_START: BEGIN
              Result.bInstall := True;
              Result.bAutomatique := False;
            END;

          SERVICE_DISABLED: BEGIN
              Result.bInstall := False;
              Result.bAutomatique := False;
              Result.bStarted := False;
            END;
        END;

      END;
      //     RaiseLastOSError(GetLastError());

            // S'il est installé, on va teste s'il est lancé
      IF Result.bInstall THEN
      BEGIN
        QueryServiceStatus(hService, Statut);
        IF Statut.dwCurrentState <> SERVICE_RUNNING THEN
        BEGIN
          Result.bStarted := False;
        END
        ELSE BEGIN
          Result.bStarted := True;
        END;
      END;
    END
    ELSE BEGIN
      Result.bInstall := False;
    END;
  FINALLY
    CloseServiceHandle(hService);
    CloseServiceHandle(hSCManager);
  END;
END;

PROCEDURE TFrm_LaunchV7.SrvSecours_Demarre;
VAR
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  tempMini: DWORD;
  CheckPoint: DWORD;
BEGIN
  IF NOT Interbase7 THEN EXIT;

  IF ServiceRepl THEN // ne redemarer le service que si on la arrété
  BEGIN
    hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
    hService := OpenService(hSCManager, 'IBRepl', SERVICE_QUERY_STATUS OR SERVICE_START OR SERVICE_STOP OR SERVICE_PAUSE_CONTINUE);
    IF hService <> 0 THEN
    BEGIN // Service non installé
      QueryServiceStatus(hService, Statut);
      tempMini := Statut.dwWaitHint + 10;
      ControlService(hService, SERVICE_CONTROL_CONTINUE, Statut);
      REPEAT
        CheckPoint := Statut.dwCheckPoint;
        Sleep(tempMini);
        QueryServiceStatus(hService, Statut);
      UNTIL (CheckPoint = Statut.dwCheckPoint) OR
        (statut.dwCurrentState = SERVICE_RUNNING);
      // si CheckPoint = Statut.dwCheckPoint Alors le service est dans les choux
    END;
    CloseServiceHandle(hService);
    CloseServiceHandle(hSCManager);
  END;
END;

PROCEDURE TFrm_LaunchV7.Tim_SrvSecoursTimer(Sender: TObject);
VAR
  stEtatService: TEtatService;
BEGIN
  Tim_SrvSecours.Enabled := False;

  bSrvSecours_Present := bSrvSecours_Present AND Interbase7;

  IF bSrvSecours_Present THEN
  BEGIN
    // Vérif l'état
    stEtatService := SrvSecours_EtatService;
    IF NOT stEtatService.bStarted THEN
    BEGIN
      // On tente de démarrer
      SrvSecours_Demarre();

      IF Tim_SrvSecours.Interval = 1000 THEN // à l'init
      BEGIN
        dtSrvSecours_PremiereTentative := Now;
        Tim_SrvSecours.Interval := 30000; // La première fois on réessaie après 30 secondes
      END
      ELSE BEGIN
        Tim_SrvSecours.Interval := 600000; // sinon 10 minutes
      END;

      Sleep(3000); // on attend 5 secondes pour le lancement du service
      // Si le serveur n'est toujours pas actif, on retente
      IF SrvSecours_EstALancer THEN
      BEGIN
        IF (Now - dtSrvSecours_PremiereTentative) < 0.042 THEN
        BEGIN
          Tim_SrvSecours.Enabled := True;
        END;
      END;

    END
    ELSE BEGIN
      // ben on fait rien, ca marche
      SrvSecoursAffErreur();
      Tim_SrvSecours.Interval := 1000;
    END;
  END;

END;

PROCEDURE TFrm_LaunchV7.SrvSecoursAffErreur(ANum: Integer = 0; ALibelle: STRING = '');
BEGIN
  ///
  ///
  Img_SrvSecours1.Visible := False;
  Img_SrvSecours2.Visible := False;

  IF ANum = 0 THEN // Effacer
  BEGIN
    Pan_SrvSecours.Caption := '';
    Pan_SrvSecours.Visible := False;
    Exit; // on fait pas le reste
  END
  ELSE BEGIN

    CASE ANum OF
      1: BEGIN // Info
          Img_SrvSecours1.Visible := True;
          Lab_SrvSecours.Font.Style := [fsBold];
        END;
      2: BEGIN // Erreur
          Img_SrvSecours2.Visible := True;
          Lab_SrvSecours.Font.Style := [];
        END;
    END;

    Lab_SrvSecours.Caption := ALibelle;
    Pan_SrvSecours.Visible := True;
  END;

END;

END.

