//$Log:
// 58   Utilitaires1.57        01/03/2023 11:25:57    Antoine JOLY    V14.0 :
//      changement fonctionnement -> passage des patchs uniquement si tous les
//      exes sont bien t?l?charg?s + optim dl et rollback
// 57   Utilitaires1.56        24/02/2023 13:41:20    Antoine JOLY   
//      Verification des URL pour le dl des fichiers et maj url melk
// 56   Utilitaires1.55        16/09/2022 12:25:59    Antoine JOLY   
//      Verification.exe : optimisations logs et param?trage preprod
// 55   Utilitaires1.54        12/08/2022 14:56:45    Sylvain CORBELETTA
//      Modification pour que le fichier veriifcation.exe ne soit pas supprim?
//      de AMAJ
// 54   Utilitaires1.53        28/07/2022 16:43:14    Antoine JOLY   
//      Verification.exe V13.2.10.1 : Deconnexion bases -> pas de traitement si
//      le backup tourne, l'exe log que les backup est en cours et il se ferme
// 53   Utilitaires1.52        06/10/2021 14:38:31    Antoine JOLY   
//      verification.exe : passage du k_version en int64
// 52   Utilitaires1.51        15/09/2021 17:34:52    Antoine JOLY   
//      Verification.exe : plus de suppression des exes A_MAJ si ?chec de la
//      MAJ + correction dans gestion des services
// 51   Utilitaires1.50        25/02/2021 09:45:54    Python Benoit   Ajout de
//      log, notament les exception
// 50   Utilitaires1.49        16/01/2019 11:37:39    Ludovic MASSE   ajout log
//      + nettoyage du fichier de log de version (ex :
//      LOGV18.1.0.1-VT18.3.0.1.Log)
// 49   Utilitaires1.48        14/12/2018 14:46:05    St?phane MATHIS
//      correction probleme lancement ALG
// 48   Utilitaires1.47        10/12/2018 15:53:31    Ludovic MASSE  
//      v13.2.5.15 : correction lancemnt launcher easy, pas auto loggon non
//      bloquant, si easy pas de check des provider, nettoyage repertoire
// 47   Utilitaires1.46        20/11/2018 17:49:42    Ludovic MASSE   GinVer
//      v13.2.5.14
//      Verification v13.2.8.9
//      remont? du num?ro de version au monitoring
// 46   Utilitaires1.45        08/11/2018 11:22:37    Ludovic MASSE  
//      am?lioration pour ne plus perdre de base ou avoir des base corrompue
// 45   Utilitaires1.44        18/10/2018 09:54:24    Antoine JOLY   
//      Verification.exe : modification du nom de l'exe LauncherEasy.exe pour
//      mise ? jour de l'exe
// 44   Utilitaires1.43        23/08/2018 15:27:25    Ludovic MASSE  
//      v13.2.8.17 : ajout cl? registre pour d?marrer en admin + nouvelle
//      gestion du uServiceManager pour EASY
// 43   Utilitaires1.42        19/07/2018 15:00:04    Gr?gory BEN HAMZA
//      Annulation de la modification de recherche de pb DAUDIN
// 42   Utilitaires1.41        10/07/2018 16:04:27    Florent CHEVILLON Export
//      des ventes le temps des cerises - DAUDIN
//      Recherche de pb de non red?marrage se SyncWeb : Ajout d'un sleep.
// 41   Utilitaires1.40        06/07/2018 15:46:42    Python Benoit  
//      v13.2.8.16 : Ajout de la gestion des nom sans "patch"
// 40   Utilitaires1.39        30/05/2018 13:59:00    Ludovic MASSE  
//      v13.2.8.15 : Ajout de la gestion du launcher easy
// 39   Utilitaires1.38        27/04/2018 15:15:30    Ludovic MASSE   rendu
//      temporaire 
// 38   Utilitaires1.37        05/10/2017 12:01:51    Antoine JOLY   
//      Modifications pour nouveau syst?me de MAJ des tools
// 37   Utilitaires1.36        17/08/2017 15:10:36    Ludovic MASSE   Modif
//      Verif : ajout gestion service ALG
// 36   Utilitaires1.35        16/11/2016 15:39:14    Ludovic MASSE   CDC ?
//      SERVICES ? ARRET ET REDEMARRAGE
// 35   Utilitaires1.34        02/11/2016 15:13:46    Ludovic MASSE   v13.2.8.3
//      - CDC - DEMENAGEMENT DE YELLIS 
// 34   Utilitaires1.33        16/09/2016 11:13:06    Florian Louis   Rendu
//      pour la mise a jour du flag Updated et non prise en compte des
//      resultats du t?l?chargement des  patchs specifiques
// 33   Utilitaires1.32        13/09/2016 10:36:13    Ludovic MASSE   CDC -
//      DEMENAGEMENT DE YELLIS
// 32   Utilitaires1.31        13/09/2016 10:22:34    Ludovic MASSE   CDC -
//      DEMENAGEMENT DE YELLIS
// 31   Utilitaires1.30        29/06/2016 13:07:06    Florian Louis   v13.2.5.1
//      : Changement de lame2.no-ip.com -> update.ginkoia.net
// 30   Utilitaires1.29        17/03/2016 15:33:03    Python Benoit   Version
//      13.2.4.35 : 
//      Param?tre sp?cifique pour les sites de synchro
// 29   Utilitaires1.28        15/03/2016 15:22:58    Python Benoit   Version
//      13.2.4.33 :
//      Correction pour lancement des sp?cifique sur les postes de synchro
//      Signature de l'executable
// 28   Utilitaires1.27        11/03/2016 12:09:08    Python Benoit   Version
//      13.2.3.27 :
//      Correction du test de maj de InstallBMC
//      Correction de la conversion des dates pour programmation de MAJ
// 27   Utilitaires1.26        11/03/2016 12:05:37    Python Benoit   Version
//      13.2.3.27 :
//      Correction du test de maj de InstallBMC
//      Correction de la conversion des dates pour programmation de MAJ
// 26   Utilitaires1.25        26/02/2016 18:49:06    Python Benoit  
//      Correction dans verification. Lancement que si effectivement different.
// 25   Utilitaires1.24        12/02/2016 15:09:51    Florian Louis   -
//      Correctifs pour la v15.2
// 24   Utilitaires1.23        14/12/2015 16:36:18    Python Benoit   Version
//      13.2.1.46 : Gestion de InstallBMC
// 23   Utilitaires1.22        17/09/2015 14:10:18    Florian Louis  
//      Correction de l'erreur "chaine vide en reponse" (Yellis)
// 22   Utilitaires1.21        08/09/2015 11:08:08    Florian Louis   -
//      Correction des batchs suite au bug du Deploy
// 21   Utilitaires1.20        16/04/2015 10:48:10    Florian Louis   Arr?t et
//      red?marrage du service Mobilit? et BI pour Verification et Patch
// 20   Utilitaires1.19        01/04/2015 12:01:07    Florian Louis   - Rendu
//      en RELEASE + ajout de delai de retry requetes yellis
// 19   Utilitaires1.18        11/03/2015 16:42:26    Florian Louis  
//      Deploiement Mobilit?
//      - Ajout de l'arret et du red?marrage du service mobilit? si besoin de
//      mise a jour.
// 18   Utilitaires1.17        12/12/2014 12:09:02    Florian Louis   -
//      Correction dans les patchs specifiques
//      - Ajout de logs
// 17   Utilitaires1.16        28/11/2014 12:56:12    Florian Louis   -
//      Reparation du blocage MAJ
// 16   Utilitaires1.15        24/11/2014 13:11:52    Florian Louis   - Ajour
//      de logs d?taill?s lors de la verification de la version
// 15   Utilitaires1.14        21/11/2014 17:32:19    Florian Louis   - Ajout
//      de la gestion du flag UPDATED pour l'archive de version fabriqu?e par
//      BackRest
//      - Ajout d'un retry (x5) sur les downloads HTTP
// 14   Utilitaires1.13        06/11/2014 12:20:40    Python Benoit   ajout de
//      la gestion de cmdsync des DLL
// 13   Utilitaires1.12        31/10/2014 15:15:09    Gilles Riand    Ajout de
//      la gestion de Easycomptage
// 12   Utilitaires1.11        31/10/2014 14:40:49    Ortega Julien   TSocket
//      -> TIdHTTP
// 11   Utilitaires1.10        28/07/2014 09:55:03    Python Benoit   Nouvelle
//      version en release.
// 10   Utilitaires1.9         01/07/2014 14:35:33    Python Benoit  
//      Utilisation de la bonne boite mail
//      Utilisation de constante pour l'url
//      Message si pas de GUID
// 9    Utilitaires1.8         14/04/2014 10:59:22    Python Benoit  
//      Amelioration de Verification.exe :
//      - Gestion correcte des erreurs de patch
//      - Code retour de Verifielaversion
//      - T?l?chargement mais non programmation de maj version si pas a jour
//      des patch
//      - Log des erreur SQL des patchs
// 8    Utilitaires1.7         03/04/2014 12:08:58    Python Benoit   Version
//      des fichiers.
//      Pas de maj sur pas tous les patchs.
// 7    Utilitaires1.6         03/04/2014 10:21:15    Python Benoit  
//      Correction dans patch.
//      Log, Reboot, gestion des services, ...
// 6    Utilitaires1.5         25/02/2014 11:51:35    Thierry Fleisch Rendu
// 5    Utilitaires1.4         17/09/2013 11:43:20    Thierry Fleisch Patch.exe
//      Version 13.2.0.1 : 
//      - Ajout de la gestion du num?ro de version dans la barre du programme
//      - Remplacement de l'ancien CRC32 par le nouveau par Indy
//      V?rification Version 13.2.0.3 : 
//      - Remplacement de l'ancien CRC32 par le nouveau par Indy
// 4    Utilitaires1.3         09/08/2013 09:28:25    Thierry Fleisch Ajout de
//      l'arr?t et du d?marrage du service d'impression
// 3    Utilitaires1.2         26/07/2013 15:01:09    Thierry Fleisch Version
//      13.2.0.1 : 
//      - Ajout du syst?me de version 
//      - Ajout du Kill des app Externe via le fichier KLaunch.app
// 2    Utilitaires1.1         23/04/2013 17:15:51    Thierry Fleisch Ajout de
//      logs + Changement du kill du launcher
// 1    Utilitaires1.0         01/10/2012 16:06:39    Loic G          
//$
//$NoKeywords$
//

unit UVerification;

interface

uses
  XMLCursor,
  StdXML_TLB,
  MSXML2_TLB,
  Upost,
  Xml_Unit,
  IcXMLParser,
  registry,
  UMapping,
  UmakePatch,
  cstlaunch,
  variants,
  forms,
  windows,
  sysutils,
  filectrl,
  IBSQL,
  IBDatabase,
  Db,
  IBCustomDataSet,
  IBQuery,
  Controls,
  ComCtrls,
  StdCtrls,
  Classes,
  VCLUnZip,
  VCLZip,
  RzBckgnd,
  TlHelp32,
  uFileRestart,
  uVersion,
  uKillApp,
  uToolsXE,
  IBServices,
  IdHTTP,
  IdCompressorZLib,
  IdURI,
  IdComponent,
  ExtCtrls,
  Math,
  uServicesManager,
  Graphics,
  uLog,
  DateUtils;

const
//  URL_SERVEUR_MAJ = 'lame2.no-ip.com';
  URL_SERVEUR_MAJ = 'update.ginkoia.net';

type
  TMonXML2 = class(TXMLCursor)
  end;

  TGestion_K_Version = (tKNone, tKV32, tKV64);

  TAddDelRegistry = (regAdd, regDel);

  TFrm_Verification = class(TForm)
    data: TIBDatabase;
    IBQue_Base: TIBQuery;
    IBQue_BaseBAS_NOM: TIBStringField;
    IBQue_Soc: TIBQuery;
    Que_Version: TIBQuery;
    Que_VersionVER_VERSION: TIBStringField;
    tran: TIBTransaction;
    IBQue_Connexion: TIBQuery;
    IBQue_ConnexionCON_TYPE: TIntegerField;
    IBQue_ConnexionCON_NOM: TIBStringField;
    IBQue_ConnexionCON_TEL: TIBStringField;
    IBQue_SocSOC_NOM: TIBStringField;
    pbPhase: TProgressBar;
    pbDetail: TProgressBar;
    lbDetail: TLabel;
    SQL: TIBSQL;
    Last_bckok: TIBQuery;
    Last_bckokDOS_STRING: TIBStringField;
    Last_bck: TIBQuery;
    Last_bckDOS_STRING: TIBStringField;
    IBQue_BaseBAS_ID: TIntegerField;
    Les_BD: TIBQuery;
    Les_BDREP_PLACEBASE: TIBStringField;
    Les_BDREP_PLACEEAI: TIBStringField;
    //Background5: TBackground; lab : migration
    Que_Exists: TIBQuery;
    Que_ExistsNB: TIntegerField;
    Que_GUIDBASE: TIBQuery;
    Que_GUIDBASEBAS_GUID: TIBStringField;
    IBQue_Param: TIBQuery;
    IBQue_ParamPRM_STRING: TIBStringField;
    Que_Url: TIBQuery;
    Que_UrlLAU_ID: TIntegerField;
    Que_UrlREP_ID: TIntegerField;
    Que_UrlREP_URLDISTANT: TIBStringField;
    Zip: TVCLZip;
    IBServerProperties: TIBServerProperties;
    Que_Tmp: TIBQuery;
    panTop: TPanel;
    lbPhase: TLabel;
    lbTitre: TLabel;
    lbDl: TLabel;
    lbTitle: TLabel;
    imgLogo: TImage;
    lbVersion: TLabel;
    IBQue_BaseBAS_MAGID: TIntegerField;
    procedure FormCreate(Sender: TObject);

    procedure IdHTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure IdHTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure FormActivate(Sender: TObject);
  private
    { Déclarations privées }
    first: Boolean;
    Ginkoia: string;
    VersionEnCours: string;
    Base: string;
    Soc: string;
    BasePrinc: string;
    FromSynchro: Boolean;
    FNewMaj: Boolean;
    ServeurGuid: string;
    URLTools: string;
    FGestion_K_VERSION : TGestion_K_Version;
    FUrlUpdate: String;
    FTimeOutDl: TDateTime;
    FIsTimeOut: boolean;

    FnewCRC : boolean;
    FDlMax  : Int64 ;
    SrvManager : TServicesManager;
    function Lesfichier(Path: string; var Lataille: Integer): TStringList;
    function LeGuid: string;
    function Traitement_BATCH(LeFichier: string): Boolean;
    procedure AjouteNoeud(Xml: TMonXML2; Noeud: string; Place: Integer; Valeur: string);
    function ChercheMaxVal(Noeuds: IXMLDOMNodeList; NoeudFils, TAG: string): string;
    function ChercheMinVal(Noeuds: IXMLDOMNodeList; NoeudFils, TAG: string): string;
    function ChercheVal(Noeuds: IXMLDOMNodeList; TAG: string): string;
    function Existes(Noeuds: IXMLDOMNodeList; NoeudFils, TAG, Valeur: string): Integer;
    function Existe(Noeuds: IXMLDOMNodeList; TAG, Valeur: string): Boolean;
    procedure RemplaceVal(Noeuds: IXMLDOMNodeList; TAG, Valeur: string);
    procedure Fait_un_zip(le_zip: string);
    procedure Fait_un_alg(le_alg: string);
    procedure setPhase(aPhase: string; aProgress: integer = 0);
    procedure setDetail(aDetail: string; aProgress: integer = 0);
    procedure VclWait(aTime: Integer);
    procedure doTraitement;
    procedure onLog(Sender: TObject; aMsg: string);
    // fonction qui test si on est sur le nouveau système de mise à jour ou pas
    function IsNewMAJ: Boolean;
    procedure Check_Mode_K_VERSION;
    function GetGestion_K_VERSION: TGestion_K_Version;
    procedure AddDelRegistryForGinkoRep(aTypeAction: TAddDelRegistry);
    function DownloadExes: boolean;
  public
    Automatique: boolean;
    BackupOk: boolean;
    { Déclarations publiques }
    function Connexion: boolean;
    procedure de_a_version(var Dep, Arr: string);
    function traitechaine(S: string): string;
    procedure MAJplante(S: string);
    function Script(base, S: string): Boolean;
    function NetoyageDesConneriesAStan(test: boolean): boolean;
    procedure verification_des_batch;
    function Launcher(aStop : Boolean) : boolean;
    function isEasy : boolean;
    // fonctionnement dfe base selon les paramètres
    function Verifielaversion() : Boolean;
    function ChargeSpecifique() : Boolean;
    function MetAJourlaversion() : boolean;

    // téléchargement des specifique
    function DownloadSpecifique(Yellis : Tconnexion; IdClt : string) : boolean;
    procedure AddToLogs(aMsg : string; aLvl : TLogLevel = logInfo);
    procedure AddToLogsAndMonitoring(aMdl, aKey, aVal : string; aLvl : TLogLevel = logInfo);
    // procédure d'attente du démarrage du service
    procedure WaitService;

    function Download(const URL, DestFilename: String): Boolean;
    function DownloadFmt(const FormatURL: String; const ArgsURL: array of const; const FormatDestFilename: String; const ArgsDestFilename: array of const): Boolean; overload;
    function DownloadFmt(const URL, FormatDestFilename: String; const ArgsDestFilename: array of const): Boolean; overload;
    function DownloadFmt(const FormatURL: String; const ArgsURL: array of const; const DestFilename: String): Boolean; overload;

    property NewCRC : boolean read FnewCRC write FnewCRC;

    property Gestion_K_VERSION: TGestion_K_Version read GetGestion_K_VERSION;
  end;

var
  Frm_Verification: TFrm_Verification;

  {
  Actions
    1 : création
    2 : Maj version
    3 : recup de Maj pour un fichier
    4 : script passé
    5 : script planté
    6 : Maj fichier planté
    7 : Scrip Perso OK
    8 : Scrip Perso planté
    10 : majplanté
  }

implementation

uses
  ShellAPI,
  Iso8601Unit;

var
  Lapplication: string;
  AppliTourne: boolean;
  AppliArret: boolean;

const
  _launcher = 'LE LAUNCHER';
  _ginkoia = 'GINKOIA';
  _Caisse = 'CAISSEGINKOIA';
//  _TPE = 'SERVEUR DE TPE';
  _PICCO = 'PICCOLINK';
  _SCRIPT = 'SCRIPT';
  _PICCOBATCH = 'PICCOBATCH';
  _EASYCOMPTAGE = 'GKEasyComptageExport.exe';
  //cURL_YELLIS = 'yellis.ginkoia.net';
  // FTH 12/09/2011 Utilise Killprocess au lieu de Enumwindows
  _SYNCWEB = 'syncweb.exe';
  _LaunchV7 = 'LaunchV7.Exe';
  _LauncherEasy = 'LauncherEasy.Exe';
  _TPE = 'TPESERV.exe' ;

{$R *.DFM}

  {
  const
     launcher = 'LE LAUNCHER';
     ginkoia = 'GINKOIA';
     Caisse = 'CAISSEGINKOIA';
     TPE = 'SERVEUR DE TPE';
     PICCO = 'PICCOLINK';
  }

function Enumerate2(hwnd: HWND; Param: LPARAM): Boolean; stdcall; far;
var
  lpClassName: array[0..999] of Char;
  lpClassName2: array[0..999] of Char;
begin
  result := true;
  Windows.GetClassName(hWnd, lpClassName, 500);
  if Uppercase(StrPas(lpClassName)) = 'TAPPLICATION' then
  begin
    Windows.GetWindowText(hWnd, lpClassName2, 500);
    if Uppercase(StrPas(lpClassName2)) = Lapplication then
    begin
      AppliTourne := True;
      result := False;
    end;
  end;
end;

function Enumerate(hwnd: HWND; Param: LPARAM): Boolean; stdcall; far;
var
  lpClassName: array[0..999] of Char;
  lpClassName2: array[0..999] of Char;
  Handle: DWORD;
begin
  result := true;
  Windows.GetClassName(hWnd, lpClassName, 500);
  if Uppercase(StrPas(lpClassName)) = 'TAPPLICATION' then
  begin
    Windows.GetWindowText(hWnd, lpClassName2, 500);
    if Uppercase(StrPas(lpClassName2)) = Lapplication then
    begin
      GetWindowThreadProcessId(hWnd, @Handle);
      TerminateProcess(OpenProcess(PROCESS_ALL_ACCESS, False, Handle), 0);
      AppliArret := true;
      result := False;
    end;
  end;
end;

function KillProcess(const ProcessName: string): boolean;
var
  ProcessEntry32: TProcessEntry32;
  HSnapShot: THandle;
  HProcess: THandle;
begin
  Result := False;

  HSnapShot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if HSnapShot = 0 then
    exit;

  ProcessEntry32.dwSize := sizeof(ProcessEntry32);
  if Process32First(HSnapShot, ProcessEntry32) then
    repeat
      if CompareText(ProcessEntry32.szExeFile, ProcessName) = 0 then
      begin
        HProcess := OpenProcess(PROCESS_TERMINATE, False, ProcessEntry32.th32ProcessID);
        if HProcess <> 0 then
        begin
          Result := TerminateProcess(HProcess, 0);
          CloseHandle(HProcess);
        end;
        Break;
      end;
    until not Process32Next(HSnapShot, ProcessEntry32);

  CloseHandle(HSnapshot);
end;

procedure TFrm_Verification.setPhase(aPhase : string ; aProgress : integer = 0) ;
begin
  lbPhase.Caption := ' ' + aPhase ;
  pbPhase.Position := aProgress ;
  lbDetail.Caption := '' ;
  pbDetail.Position := 0 ;

  Application.ProcessMessages ;
end;

procedure TFrm_Verification.setDetail(aDetail : string ; aProgress : integer = 0) ;
begin
  lbDetail.Caption := ' ' + aDetail ;
  pbDetail.Position := aProgress ;

  Application.ProcessMessages ;
end;

procedure TFrm_Verification.FormActivate(Sender: TObject);
begin
  if (First) then
  begin
    first := false ;
    doTraitement ;
  end;
end;

procedure TFrm_Verification.AddDelRegistryForGinkoRep(aTypeAction: TAddDelRegistry);
var
  reg: TRegistry;
  valueExists: string;
begin
  reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False);
    valueExists := reg.ReadString('GinkoRep');

    case aTypeAction of
      regAdd:
      begin
        if valueExists = '' then
          reg.WriteString('GinkoRep', Ginkoia + 'GinkoRep.exe ' + Ginkoia);
      end;
      regDel:
      begin
        if valueExists <> '' then
          reg.DeleteValue('GinkoRep');
      end;
    end
  finally
    reg.free;
  end;
end;

procedure TFrm_Verification.FormCreate(Sender: TObject);
var
  reg: TRegistry;
  s: string;
  i: integer;
  sServicesPath : String;
begin
  // paramètre pour l'URL de téléchargement des fichiers
  FUrlUpdate := ReadWriteDelIni('Verification', 'UrlUpdate', '', dtString, otRead);

  if (FUrlUpdate = '') or (FUrlUpdate <> URL_SERVEUR_MAJ) then
  begin
    FUrlUpdate := URL_SERVEUR_MAJ;
    ReadWriteDelIni('Verification', 'UrlUpdate', FUrlUpdate, dtString, otWrite);

    // si l'URL n'existait pas, on supprime la section log car la version précédente de uLog n'avait pas la bonne
    // URL du Melk, il doit la recréer
    ReadWriteDelIni('Log', '', '', dtDel, otDel);
  end;

  if not Log.Opened then
  begin
    Log.Open;
    Log.readIni;
    Log.saveIni;
  end;

  lbVersion.Caption := 'v.' + GetNumVersionSoft ;

  FnewCRC := false;

  FromSynchro := false;
  URLTools := '';

  setPhase('') ;

  if MapGinkoia.Backup then
  begin
    AddToLogsAndMonitoring('Verification', 'FormCreate', 'Le backup est en cours, fermeture de l''application', logError);
    Application.Terminate;
    Exit;
  end;

  BackupOk := true;
  reg := TRegistry.Create;
  try
    reg.access := Key_Read;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    s := '';
    reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
    S := reg.ReadString('Base0');
  finally
    reg.free;
  end;
  BasePrinc := S;
  data.dataBaseName := BasePrinc;
  first := true;
  Ginkoia := S;
  while Ginkoia[length(Ginkoia)] <> '\' do
    delete(ginkoia, length(Ginkoia), 1);
  delete(ginkoia, length(Ginkoia), 1);
  while Ginkoia[length(Ginkoia)] <> '\' do
    delete(ginkoia, length(Ginkoia), 1);
  if not (Fileexists(Ginkoia + 'ginkoia.ini')) then
    Ginkoia := 'C:\GINKOIA\';
  if not (Fileexists(Ginkoia + 'ginkoia.ini')) then
    Ginkoia := 'D:\GINKOIA\';
  if not (Fileexists(Ginkoia + 'ginkoia.ini')) then
    Ginkoia := IncludeTrailingBackslash(extractFilePath(application.exename));
  Automatique := true;
  ForceDirectories(GINKOIA + 'liveupdate\');

//  Logs.Path := IncludeTrailingPathDelimiter(Ginkoia) + 'Logs\';
//  Logs.FileName := FormatDateTime('YYYY_MM_DD', Now) + '_Verification.log';
//  ForceDirectories(Logs.Path);

  // Chargement du fichier commun s'il existe
  if FileExists(ExtractFilePath(Application.ExeName) + 'CfgRestart.ini') then
    FileRestart.LoadFile
  else
    FileRestart.Init;

  sServicesPath := ExtractFilePath(Application.ExeName) + 'Services.ini';
  if not FileExists(sServicesPath) then
  begin
    sServicesPath := Ginkoia + 'Services.ini';
    if not FileExists(sServicesPath) then
    begin
      AddToLogsAndMonitoring('Verification', 'FormCreate', format('Le fichier "%s" n''existe pas', [sServicesPath]), logError);
      Application.Terminate;
    end;
  end;

  // on supprime la clé de registre du lancement auto de ginkorep, elle sera recréé uniquement dans le cas ou on a bien tout téléchargé mais qu'un fichier n'a pas pu être remplacé
  AddDelRegistryForGinkoRep(regDel);

  SrvManager := TServicesManager.create(onLog, sServicesPath, true);
  SrvManager.Application := ChangeFileExt(ExtractFileName(Application.ExeName), '');
end;

function TFrm_Verification.GetGestion_K_VERSION: TGestion_K_Version;
begin
  if (FGestion_K_VERSION = TKNone) then
    Check_Mode_K_VERSION();

  Result := FGestion_K_VERSION;
end;

function TFrm_Verification.Connexion: boolean;
begin
  if UnPing('http://' + FUrlUpdate + '/MajBin/DelosQPMAgent.dll/Ping') then
    result := true
  else
    result := false;
end;

function TFrm_Verification.Lesfichier(Path: string; var Lataille: Integer): TStringList;

  procedure liste(PO, path: string);
  var
    f: TSearchRec;
  begin
    if findfirst(path + '*.*', FaAnyfile, F) = 0 then
    begin
      repeat
        if (f.name <> '.') and (f.name <> '..') then
        begin
          if f.attr and faDirectory = faDirectory then
          begin
            Liste(Po + f.name + '\', path + f.name + '\');
          end
          else
          begin
            result.add(Uppercase(Po + f.name));
            LaTaille := LaTaille + f.size;
          end;
        end;
      until findnext(f) <> 0;
    end;
    findclose(f);
  end;

begin
  Lataille := 0;
  result := tstringlist.create;
  liste('', IncludeTrailingBackslash(path));
end;

function TFrm_Verification.Launcher(aStop: Boolean) : boolean;
var
  sLaunchName : String;
begin
  result := false;
  sLaunchName := _LaunchV7;

  if isEasy then
    sLaunchName := _LauncherEasy;


  if aStop then
  begin
    if KillProcess(sLaunchName) then
    begin
      result := true;
      AddToLogs('Arrêt du ' + sLaunchName + ' : Ok')
    end else begin
      AddToLogs('Arrêt du ' + sLaunchName + ' : Echec')
    end;
  end
  else
  begin
    AddToLogs('Relance du ' + sLaunchName);
    ShellExecute(0, 'open', Pchar(Ginkoia + sLaunchName), '', nil, SW_SHOWNORMAL);
  end;
end;

function TFrm_Verification.LeGuid: string;
begin
  Que_Exists.Open;
  IBQue_Base.open;
  // recherche du GUID
  if Que_ExistsNB.AsInteger > 0 then
  begin
    // recupération du GUID dans GENBASE
    Que_GUIDBASE.ParamByName('BASID').AsInteger := IBQue_BaseBAS_ID.AsInteger;
    Que_GUIDBASE.Open;
    result := Que_GUIDBASEBAS_GUID.AsString;
    Que_GUIDBASE.Close;
    if result = '' then
    begin
      // Cas du passage de version
      IBQue_Param.parambyname('magid').AsInteger := IBQue_BaseBAS_ID.AsInteger;
      IBQue_Param.Open;
      result := IBQue_ParamPRM_STRING.AsString;
      IBQue_Param.Close;
    end;
  end
  else
  begin
    // recupération du GUID dans GENPARAM
    IBQue_Param.parambyname('magid').AsInteger := IBQue_BaseBAS_ID.AsInteger;
    IBQue_Param.Open;
    result := IBQue_ParamPRM_STRING.AsString;
    IBQue_Param.Close;
  end;
  Que_Exists.close;
end;

function TFrm_Verification.Verifielaversion() : Boolean;

  function recup_version(tc : tconnexion; Tc_R : TstringList; NomVer, NomVerprev : string) : string;
  var
    CRC, CRCold, CRCnew, paramCRC : string;
    tsl : TStringList;
  begin
    ForceDirectories(GINKOIA + 'liveupdate\');
    Result := (* 'PatchGin' + *) NomVer + '-' + NomVerprev;
    // on recup le crc
    if DownloadFmt( 'http://' + FUrlUpdate + '/MAJ/%s.TXT', [ Result ], '%sliveupdate\%s.TXT', [ GINKOIA, Result ] ) then
    begin
      try
        tsl := tstringlist.create;
        tsl.loadfromfile(GINKOIA + 'liveupdate\' + Result + '.TXT');
        if tsl.count > 1 then
          paramCRC := tsl[1]
        else
          paramCRC := '';
      finally
        FreeAndNil(tsl);
      end;

      if FileExists(GINKOIA + 'liveupdate\' + Result + '.EXE') then
      begin
        CRCold := IntToStr(FileCRC32(GINKOIA + 'liveupdate\' + Result + '.EXE'));
        CRCnew := IntToStr(DoNewCalcCRC32(GINKOIA + 'liveupdate\' + Result + '.EXE'));
        if FnewCRC then
          CRC := CRCnew
        else
          CRC := CRCold;

        // test du crc
        if paramCRC <> CRC then
        begin
          deletefile(GINKOIA + 'liveupdate\' + Result + '.EXE');
        end;
      end;
    end;

    if not FileExists(GINKOIA + 'liveupdate\' + Result + '.EXE') then
    begin
      if DownloadFmt( 'http://' + FUrlUpdate + '/MAJ/%s.EXE', [ Result ], '%sliveupdate\%s.EXE', [ GINKOIA, Result ] ) then
      begin
        // calcul du CRC
        CRCold := IntToStr(FileCRC32(GINKOIA + 'liveupdate\' + Result + '.EXE'));
        CRCnew := IntToStr(DoNewCalcCRC32(GINKOIA + 'liveupdate\' + Result + '.EXE'));
        if FnewCRC then
          CRC := CRCnew
        else
          CRC := CRCold;

        // test du crc
        if paramCRC <> CRC then
        begin
          deletefile(GINKOIA + 'liveupdate\' + Result + '.EXE');
        end
        else
        begin
          // Ajout test après quelques secondes si l'antivirus l'aurait pas supprimée
          Sleep(2000);
          if not FileExists(GINKOIA + 'liveupdate\' + Result + '.EXE') then
          begin
            // Si on est sur le nouveau système de mise à jour, on ne met pas à jour Yellis
            if not (FNewMaj) then
              tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
              'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
              '15, "Version supprimée par antivirus","' + Result + '","","")');
          end
          else
          begin
            // Si on est sur le nouveau système de mise à jour, on ne met pas à jour Yellis
            if not (FNewMaj) then
              tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
              'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
              '15, "Recupération de la version","' + Result + '","","")');
          end;
        end;

      end;
    end;
  end;

var
  idver: Integer;
  Patch: integer;
  NomVerprev,
    NomVer: string;
  S, S1: string;
  CRC, CRCold, CRCnew : string;
  Fich: string;
  j: integer;
  i: integer;
  ia, ib : integer ;
  LeScript: Tstringlist;
  idbase: string;
  LesBases: TstringList;

  BaseEnCours: string;
  ARecup: boolean;
  tsl: tstringlist;
  oksql, oksqlspe: boolean;
  GUID: string;

  tc: tconnexion;
  Tc_R: TstringList;
  Tc_Fic: TstringList;
  Tc_Prev: TstringList;
  tc_vprev: TstringList;
  i_fic: integer;

  DateActuel: TDateTime;
  DateMAJDeb: TDateTime;
  DateMAJFin: TDateTime;
  Hour, Min, Sec, MSec: Word;

  VersionAFaire: string;

  reg: TRegistry;
  LesEai: TstringList;
  lurl: string;
  Xml: TmonXML;
  Pass: TIcXMLElement;
  elem: TIcXMLElement;

  sLogs: string;
begin
  AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Debut Verifielaversion');

  lbTitre.Caption := 'Vérification' ;

  setPhase('Vérification de la version') ;

  AddToLogs('-------------------');
  AddToLogs('Vérifier la version');
  AddToLogs('-------------------');
  ForceDirectories(GINKOIA + 'liveupdate\');
  if not Automatique then
    MapGinkoia.verifencours := true;
  // vérification de la connexion internet
  result := true;
  if Connexion then
  begin
    AddToLogs('Connexion à la base de données - OK');

    data.DatabaseName := BasePrinc;
    Tc := Tconnexion.create;
    Que_Version.Open;
    VersionEnCours := Que_VersionVER_VERSION.AsString;
    Que_Version.Close;
    AddToLogs('Version en cours : ' + VersionEnCours);

    IBQue_Base.Open;
    GUID := LeGuid;

    Log.Ref := GUID;
    Log.Mag := IntToStr(IBQue_BaseBAS_MAGID.AsInteger);
    AddToLogsAndMonitoring('Main', 'Version', GetNumVersionSoft, logInfo);

    Base := IBQue_BaseBAS_NOM.AsString;
    idbase := IBQue_BaseBAS_ID.AsString;
    IBQue_Base.Close;

    LesBases := TstringList.Create;
    LesEai := TstringList.Create;
    Les_BD.paramByName('BASID').AsString := idbase;
    Les_BD.Open;
    while not Les_BD.Eof do
    begin
      LesBases.Add(Les_BDREP_PLACEBASE.AsString);
      LesEai.Add(Les_BDREP_PLACEEAI.AsString);
      Les_BD.next;
    end;
    Les_BD.Close;

    IBQue_Soc.Open;
    Soc := IBQue_SocSOC_NOM.AsString;
    IBQue_Soc.Close;
    data.close;
    Tc_R := tc.Select('Select * from version where version = "' + VersionEnCours + '"');
    if tc.recordCount(Tc_R) = 0 then
    begin
      idver := 0;
      Patch := 0;
      NomVer := '';
    end
    else
    begin
      idver := Strtoint(tc.UneValeur(tc_R, 'id'));
      Patch := Strtoint(tc.UneValeur(tc_R, 'Patch'));
      NomVer := tc.UneValeur(tc_R, 'nomversion');
    end;
    AddToLogs(Format('Id %d - Patch %d - NomVer %s', [IdVer, Patch, NomVer]));

    tc.FreeResult(tc_r);
    if trim(GUID) <> '' then
    begin
      tc_r := tc.select('select * from clients where clt_GUID="' + GUID + '"');
      if tc.recordCount(tc_r) = 0 then
      begin
        // plus de création par le client
      end
      else
      begin
{$REGION '        Mise a jour de Yellis (version, backup, ...) '}
        if tc.UneValeurEntiere(tc_r, 'version') <> idver then
        begin
          AddToLogs(Format('GUID -> Maj de la version par le client : %d <> %d', [tc.UneValeurEntiere(tc_r, 'version'), idver]));

          // le client n'est pas dans la version de yellis, MAJ du site yellis
          // Si on est sur le nouveau système de mise à jour, on ne met pas à jour Yellis
          if not (FNewMaj) then
          begin
            tc.ordre('UPDATE clients set version=' + inttostr(idver) + ', patch=0 where id=' + tc.UneValeur(tc_r, 'id'));
            tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
            'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
            '2, "Maj de la version par le client","","","")');
          end;
          tstringlist(tc_r.objects[tc_r.indexof('patch')]).strings[0] := '0';
        end;

        // Si on est sur le nouveau système de mise à jour, on ne met pas à jour Yellis
        if not (FNewMaj) then
        begin
          //Marquage du dernier Backup
          Last_bckok.ParamByName('DOS').AsString := 'B-' + idbase;
          Last_bckok.Open;
          if not Last_bckok.isempty then
          begin
            S := copy(Last_bckokDOS_STRING.AsString, 1, 19);
            tc.ordre('Update clients set bckok="' + tc.DateTime(Strtodatetime(S)) + '" where id=' + tc.UneValeur(tc_r, 'id'));
          end;
          Last_bckok.Close;
          Last_bck.ParamByName('DOS').AsString := 'B-' + idbase;
          Last_bck.Open;
          if not Last_bck.Eof then
          begin
            S := Last_bckDOS_STRING.AsString;
            Last_bck.next;
            if not Last_bck.eof then
            begin
              S1 := Last_bckDOS_STRING.AsString;
              if Strtodatetime(copy(S1, 1, 19)) > Strtodatetime(copy(S, 1, 19)) then
                S := S1;
            end;
            s1 := 'Update clients set dernbck="' + tc.DateTime(Strtodatetime(Copy(S, 1, 19))) + '" ';
            delete(S, 1, 20);
            if pos('-', S) > 0 then
              delete(S, 1, pos('-', S));
            S := trim(S);
            if s = '0' then
            begin
              s1 := s1 + ', resbck="Pas de prob", dernbckok=1';
              BackupOk := true;
            end
            else if s = '1' then
            begin
              s1 := s1 + ', resbck="Base non renomée", dernbckok=1';
              BackupOk := true;
            end
            else if s = '2' then
            begin
              s1 := s1 + ', resbck="Restore OK mais base mauvaise", dernbckok=0';
              BackupOk := false;
            end
            else if s = '3' then
            begin
              s1 := s1 + ', resbck="Pas de restore", dernbckok=0';
              BackupOk := false;
            end
            else if s = '4' then
            begin
              s1 := s1 + ', resbck="Pas de backup", dernbckok=0';
              BackupOk := false;
            end
            else if s = '5' then
            begin
              s1 := s1 + ', resbck="Pas de place", dernbckok=0';
              BackupOk := false;
            end
            else
            begin
              s1 := s1 + ', resbck="Pas d''identification", dernbckok=1';
              BackupOk := true;
            end;
            tc.ordre(S1 + ' where id=' + tc.UneValeur(tc_r, 'id'));
            AddToLogs(S1);
          end;
          Last_bck.Close;
        end;
{$ENDREGION}

        if idver <> 0 then
        begin
          if Automatique and (tc.UneValeurEntiere(tc_r, 'blockmaj') <> 0) then
          begin
            // la demande de MAJ est bloquée
            AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Maj Bloquée');
          end
          else
          begin
            oksql := true;
            oksqlspe := true;
            if (paramcount > 0) and (Uppercase(paramstr(1)) = 'RAZ') then
              tstringlist(tc_r.objects[tc_r.indexof('patch')]).strings[0] := '0';

{$REGION '            Patch Version '}
            // passage des patch version
            setPhase('Passage des patchs version',20) ;
            ia := tc.UneValeurEntiere(tc_r, 'patch') ;
            if Patch > tc.UneValeurEntiere(tc_r, 'patch') then
            begin
              for i := Math.Max(1,tc.UneValeurEntiere(tc_r, 'patch') + 1) to Patch do
              begin
                Fich := GINKOIA + 'A_Patch\';
                ForceDirectories(GINKOIA + 'A_Patch\');
                if DownloadFmt( 'http://%s/maj/patch/%s/script%d.SQL', [ FUrlUpdate, NomVer, i ], '%sA_Patch\script%d.SQL', [ GINKOIA, i ] ) then
                begin
                  AddToLogs('Passage du script ' + IntToStr(i));
                  setDetail('Script ' + IntToStr(i), Round((i - ia) / (patch - ia) * 100)) ;

                  // Passer le script
                  LeScript := tstringlist.create;
                  LeScript.loadfromfile(GINKOIA + 'A_Patch\script' + Inttostr(i) + '.SQL');
                  S := LeScript.Text;
                  LeScript.free;
                  BaseEnCours := '';
                  while s <> '' do
                  begin
                    if pos('<---->', S) > 0 then
                    begin
                      S1 := trim(Copy(S, 1, pos('<---->', S) - 1));
                      Delete(S, 1, pos('<---->', S) + 5);
                    end
                    else
                    begin
                      S1 := trim(S);
                      S := '';
                    end;
                    if s1 <> '' then
                    begin
                      for j := 0 to LesBases.count - 1 do
                      begin
                        if fileexists(LesBases[j]) then
                        begin
                          BaseEnCours := LesBases[j];
                          oksql := Script(LesBases[j], S1);
                          if not oksql then
                          begin
                            Result := false;
                            BREAK;
                          end;
                        end;
                      end; // end for les bases a traité
                      if not oksql then
                        Break;
                    end;
                  end; // end while des instruction du patch
                  //

                  AddToLogs('Mise à jour de Yellis ...');

                  // Si on est sur le nouveau système de mise à jour, on ne met pas à jour Yellis
                  if not (FNewMaj) then
                  begin
                    if (oksql) then
                    begin
                      AddToLogs('Script ' + IntToStr(i) + ' passé.');
                      if not tc.ordre('update clients set patch=' + Inttostr(i) + ' where id=' + tc.UneValeur(tc_r, 'id')) then
                        AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Erreur lors de la mise à jour de Yellis. (clients)', logWarning);

                      if not tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                        'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                        '4, "script' + Inttostr(i) + '.SQL","' + BaseEnCours + '","","")')
                        then
                      AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Erreur lors de la mise à jour de Yellis. (histo)', logWarning);

                      // dévalider les scripts mal passés
                      tc.ordre('update histo set fait=1 where action=5 and id_cli=' + tc.UneValeur(tc_r, 'id'));
                    end else
                    begin
                      AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Problème Script ' + IntToStr(i), logError);
                      if not tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                        'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                        '5, "script' + Inttostr(i) + '.SQL","' + BaseEnCours + '","Problème","")')
                        then
                        AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Erreur lors de la mise à jour de Yellis. (histo)', logWarning);
                      BREAK;
                    end;
                    AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Mise à jour de Yellis terminée');
                  end;
                end
                else
                begin
                  Result := false;
                  oksql := false;
                  BREAK;
                end;
              end; // end for num script

            end;
{$ENDREGION}

{$REGION '            Patch spécifique '}
            setPhase('Passage des patchs client',40) ;
            // passage des patch clients
            if tc.UneValeurEntiere(tc_r, 'spe_patch') > tc.UneValeurEntiere(tc_r, 'spe_fait') then
            begin
              AddToLogs('Patch spécifique du client à passer : ('+IntToStr(tc.UneValeurEntiere(tc_r, 'spe_fait')+1)+' -> '+IntTostr(tc.UneValeurEntiere(tc_r, 'spe_patch'))+')') ;

              ia := tc.UneValeurEntiere(tc_r, 'spe_patch') - tc.UneValeurEntiere(tc_r, 'spe_fait') ;
              for i := Math.Max(1,tc.UneValeurEntiere(tc_r, 'spe_fait') + 1) to tc.UneValeurEntiere(tc_r, 'spe_patch') do
              begin
                ib := i - tc.UneValeurEntiere(tc_r, 'spe_fait') ;

                Fich := GINKOIA + 'A_Patch\';
                ForceDirectories(GINKOIA + 'A_Patch\');
                AddToLogs('Téléchargement du script ' + IntToStr(i)+ ' ...');
                if DownloadFmt( 'http://%s/maj/patch/%s/script%d.SQL', [ FUrlUpdate, GUID, i ], '%sA_Patch\script%d.SQL', [ GINKOIA, i ] ) then
                begin
                  AddToLogs('Script ' + IntToStr(i)+ ' téléchargé.');
                  AddToLogs('Passage du script ' + IntToStr(i));

                  setDetail('Script ' + Inttostr(i), Trunc(ib / ia * 100)-1) ;

                  // Passer le script
                  LeScript := tstringlist.create;
                  LeScript.loadfromfile(GINKOIA + 'A_Patch\script' + Inttostr(i) + '.SQL');
                  S := LeScript.Text;
                  LeScript.free;
                  while s <> '' do
                  begin
                    if pos('<---->', S) > 0 then
                    begin
                      S1 := trim(Copy(S, 1, pos('<---->', S) - 1));
                      Delete(S, 1, pos('<---->', S) + 5);
                    end
                    else
                    begin
                      S1 := trim(S);
                      S := '';
                    end;
                    if s1 <> '' then
                    begin
                      BaseEnCours := BasePrinc;
                      oksqlspe := script(BasePrinc, s1);
                      if not oksqlspe then
                      begin
                        Result := false;
                        BREAK;
                      end;
                    end;
                  end; // end while des instruction du patch
                  //

                  setDetail('Script ' + Inttostr(i), Trunc(ib / ia * 100)) ;

                  // Si on est sur le nouveau système de mise à jour, on ne met pas à jour Yellis
                  if not (FNewMaj) then
                  begin
                    if oksqlspe then
                    begin
                      tc.ordre('update clients set spe_fait=' + Inttostr(i) + ' where id=' + tc.UneValeur(tc_r, 'id'));
                      tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                        'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                        '7, "script' + Inttostr(i) + '.SQL","' + BaseEnCours + '","","")');
                      // dévalider les scripts mal passés
                      tc.ordre('update histo set fait=1 where action=8 and id_cli=' + tc.UneValeur(tc_r, 'id'));
                    end
                    else
                    begin
                      tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                        'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                        '8, "script' + Inttostr(i) + '.SQL","' + BaseEnCours + '","Problème","")');
                      AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Problème Script ' + IntToStr(i), logError);
                      BREAK;
                    end;
                  end;
                end
                else
                begin
                  AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Erreur lors du téléchargement du script ' + IntToStr(i)+ '.', logError);
                  oksqlspe := false;
                  Result := false;
                  BREAK;
                end;

              end; // end for num script
            end
            else
            begin
              AddToLogs('Aucun patch spécifique du client à passer : ('+ IntToStr(tc.UneValeurEntiere(tc_r, 'spe_fait')) + '/' + IntToStr(tc.UneValeurEntiere(tc_r, 'spe_patch'))+')') ;
            end;
{$ENDREGION}

{$REGION '            Gestion des fichiers '}
            // verification des fichiers ...
            // fait à présent avant les traitements qui téléchargent les fichiers et passent des patchs dans la méthode DownloadExes
{$ENDREGION}            
          end;
        end;

        // tester si le client doit être mise à jour
        // Test si (oksql and oksqlspe) car pas de MAJ si pas a jour des patch + exe
        if Automatique then
        begin
          if idver <> 0 then
          begin
{$REGION '            Gestion de l''existance de MAJ de version '}
            // dois-je récupérer une version
            VersionAFaire := '';
            if tc.UneValeurEntiere(Tc_R, 'version_max') > idver then
            begin
              tc_vprev := tc.select('select * from version where id =' + tc.UneValeur(Tc_R, 'version_max'));
              NomVerprev := tc.UneValeur(tc_vprev, 'nomversion');
              tc.FreeResult(tc_vprev);

              setPhase('Récupération de la version',60) ;
              setDetail('Version ' + NomVerprev) ;
              AddToLogs('Récupération de la version ' + NomVerprev);
              VersionAFaire := recup_version(tc, Tc_R, NomVer, NomVerprev);
            end
            else
            begin
              Tc_Prev := tc.select('select * from plageMAJ where plg_cltid = ' + tc.UneValeur(tc_r, 'id'));
              if (tc.recordCount(Tc_Prev) > 0) and (tc.UneValeurEntiere(tc_prev, 'plg_versionmax') > idver) then
              begin
                tc_vprev := tc.select('select * from version where id =' + tc.UneValeur(tc_prev, 'plg_versionmax'));
                NomVerprev := tc.UneValeur(tc_vprev, 'nomversion');
                tc.FreeResult(tc_vprev);

                setPhase('Récupération de la version',60) ;
                setDetail('Version ' + NomVerprev) ;
                AddToLogs('Récupération de la version ' + NomVerprev);
                VersionAFaire := recup_version(tc, Tc_R, NomVer, NomVerprev);
              end;
              tc.FreeResult(Tc_Prev);
            end;
{$ENDREGION}

{$REGION '            Mise-à-jour de version si besoin '}
            if (VersionAFaire <> '') // si version a faire
              and FileExists(GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE') // et que l'on a le fichier
              and oksql and oksqlspe then // et que le client est a jour de ces patch
            begin
              // deux cas
              // La MAJ est demandé
              if tc.UneValeurEntiere(Tc_R, 'version_max') > idver then
              begin
                AddToLogs('Maj demandé');

                tsl := tstringlist.create;
                tsl.add(GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE');
                tsl.savetofile(GINKOIA + 'liveupdate\amaj.txt');
                tsl.free;
              end
              else
              begin
                AddToLogs('Maj prévue');
                // la MAJ est prévue
                try
                  Tc_Prev := tc.select('select * from plageMAJ where plg_cltid = ' + tc.UneValeur(tc_r, 'id'));
                  DateActuel := Date;
                  DecodeTime(Time, Hour, Min, Sec, MSec);
                  if hour >= 19 then
                    DateActuel := DateActuel + 1;
                  S := tc.UneValeur(Tc_Prev, 'plg_datedeb');
                  if pos('-', S) > 0 then
                  begin
                    if Copy(S, 9, 2) = '00' then
                      DateMAJDeb := 0
                    else
                      DateMAJDeb := TIso8601.DateTimeFromIso8601(S);
                  end
                  else
                    DateMAJDeb := Strtodate(S);
                  S := tc.UneValeur(Tc_Prev, 'plg_datefin');
                  if pos('-', S) > 0 then
                  begin
                    if Copy(S, 9, 2) = '00' then
                      DateMAJFin := 0
                    else
                      DateMAJFin := TIso8601.DateTimeFromIso8601(S);
                  end
                  else
                    DateMAJFin := Strtodate(S);

                  if (DateMAJFin <= DateActuel) and
                    (DateMAJDeb >= DateActuel) then
                  begin
                    tsl := tstringlist.create;
                    tsl.add(GINKOIA + 'liveupdate\' + VersionAFaire + '.EXE');
                    tsl.savetofile(GINKOIA + 'liveupdate\amaj.txt');
                    tsl.free;

                    // Si on est sur le nouveau système de mise à jour, on ne met pas à jour Yellis
                    if not (FNewMaj) then
                    begin
                      // et on update la fiche client
                      tc.ordre('Update clients set bckok="' + S + '" where id=' + tc.UneValeur(tc_r, 'id'));
                      tc.ordre('update clients set version_max=' + tc.UneValeur(tc_prev, 'plg_versionmax') +
                        ' where id=' + tc.UneValeur(tc_r, 'id'));
                    end;
                  end;
                  tc.FreeResult(Tc_Prev);
                except
                  on e : Exception do
                  begin
                    AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Exception dans la programmation de MAJ : ' + e.ClassName + ' - ' + e.Message, logCritical);
                  end;
                end
              end;
            end;
{$ENDREGION}
          end;
        end;
      end;

      // vérification des spécifiques
      setPhase('Traitement patchs spécifiques',70) ;
      DownloadSpecifique(tc, tc.UneValeur(tc_r, 'id'));

      tc.FreeResult(tc_r);
      
      // Traitement EAI
      setPhase('Traitement des EAI',90) ;
      AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Traitement EAI');
      for i := 0 to LesEai.count - 1 do
      begin
        data.close;
        data.DatabaseName := LesBases[i];
        data.open;
        tran.Active := true;
        IBQue_Base.Open;
        GUID := LeGuid;
        data.close;
        if trim(GUID) <> '' then
        begin
          tc_r := tc.select('select * from clients where clt_GUID="' + GUID + '"');
          if tc.recordCount(tc_r) <> 0 then
          begin
            // recherche de l'url ;
            Tc_Prev := tc.select('select * from lesurl where UCASE(url_machine)="' + uppercase(tc.UneValeur(tc_r, 'clt_machine')) +
              '" and UCASE(url_centrale)="' + uppercase(tc.UneValeur(tc_r, 'clt_centrale')) + '"');
            if tc.recordCount(Tc_Prev) = 0 then
            begin
              tc.FreeResult(Tc_Prev);
              Tc_Prev := tc.select('select * from lesurl where UCASE(url_machine)="' + uppercase(tc.UneValeur(tc_r, 'clt_machine')) + '"');
            end;
            if tc.recordCount(Tc_Prev) <> 0 then
            begin
              lurl := tc.UneValeur(Tc_Prev, 'url_url');
              data.DatabaseName := BasePrinc;
              data.open;
              tran.Active := true;
              IBQue_Base.open;
              Que_Url.ParamByName('BASID').AsInteger := IBQue_BaseBAS_ID.AsInteger;
              Que_Url.Open;
              while not Que_Url.eof do
              begin
                S := uppercase(Que_UrlREP_URLDISTANT.AsString);
                if Copy(S, 1, length(lurl)) <> uppercase(lurl) then
                begin
                  if not isEasy then
                  begin
                    Xml := TmonXML.Create;
                    xml.LoadFromFile(LesEai[i] + 'DelosQPMAgent.Providers.xml');
                    Pass := Xml.find('/Providers/Provider');
                    while pass <> nil do
                    begin
                      elem := pass.GetFirstChild;
                      while (elem <> nil) and (elem.getname <> 'URL') do
                        elem := elem.NextSibling;
                      if elem <> nil then
                      begin
                        s := elem.GetFirstNode.GetValue;
                        delete(s, 1, pos('//', S) + 1);
                        delete(s, 1, pos('/', S));
                        S := lurl + s;
                        elem.GetFirstNode.SetValue(S);
                      end;
                      pass := pass.NextSibling;
                    end;
                    xml.SaveToFile(LesEai[i] + 'DelosQPMAgent.Providers.xml');

                    xml.LoadFromFile(LesEai[i] + 'DelosQPMAgent.Subscriptions.xml');
                    Pass := Xml.find('/Subscriptions/Subscription');
                    while pass <> nil do
                    begin
                      elem := pass.GetFirstChild;
                      while (elem <> nil) and (elem.getname <> 'URL') do
                        elem := elem.NextSibling;
                      if elem <> nil then
                      begin
                        s := elem.GetFirstNode.GetValue;
                        delete(s, 1, pos('//', S) + 1);
                        delete(s, 1, pos('/', S));
                        S := lurl + s;
                        elem.GetFirstNode.SetValue(S);
                      end;
                      pass := pass.NextSibling;
                    end;
                    xml.SaveToFile(LesEai[i] + 'DelosQPMAgent.Subscriptions.xml');

                    xml.LoadFromFile(LesEai[i] + 'DelosQPMAgent.InitParams.xml');
                    Pass := Xml.find('/InitParams/QPM');
                    elem := pass.GetFirstChild;
                    while (elem <> nil) do
                    begin
                      if elem.GetFirstNode <> nil then
                      begin
                        s := elem.GetFirstNode.GetValue;
                        if uppercase(copy(s, 1, 7)) = 'HTTP://' then
                        begin
                          delete(s, 1, pos('//', S) + 1);
                          delete(s, 1, pos('/', S));
                          S := lurl + s;
                          elem.GetFirstNode.SetValue(S);
                        end;
                      end;
                      elem := elem.NextSibling;
                    end;
                    xml.SaveToFile(LesEai[i] + 'DelosQPMAgent.InitParams.xml');
                    xml.free;
                  end;
                  S := Que_UrlREP_URLDISTANT.AsString;
                  delete(s, 1, pos('//', S) + 1);
                  delete(s, 1, pos('/', S));
                  S := lurl + s;

                  if Gestion_K_VERSION = tKV64 then
                    sql.sql.text := 'update k set k_version=gen_id(VERSION_ID,1) where k_id=' + Que_UrlREP_ID.AsString
                  else
                    sql.sql.text := 'update k set k_version=gen_id(general_id,1) where k_id=' + Que_UrlREP_ID.AsString;
                  sql.ExecQuery;
                  sql.sql.text := 'update genreplication set REP_URLDISTANT = ''' + S + ''' where REP_ID=' + Que_UrlREP_ID.AsString;
                  sql.ExecQuery;
                  // Si on est sur le nouveau système de mise à jour, on ne met pas à jour Yellis
                  if not (FNewMaj) then
                  begin
                    tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                    'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                    '25, "MAJ des EAI","' + s + '","","")');
                  end;
                end;
                Que_Url.Next;
              end;
              Que_Url.close;
              if tran.InTransaction then
                tran.Commit;
              data.close;
            end;
            tc.FreeResult(Tc_Prev);
          end;
          tc.FreeResult(tc_r);
        end;
        data.close;
      end;
      AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Fin EAI');
    end
    else
      AddToLogsAndMonitoring('Verification', 'VerifVersion', 'pas de GUID !!!', logError);

    tc.free;
    LesBases.free;
    LesEai.free;
    Close;

    setPhase('Vérification terminée',100) ;
  end
  else
  begin
    AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Connexion à la base de données - ECHEC', logError);
    result := false;
  end;
  if not Automatique then
    MapGinkoia.verifencours := false;
  AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Fin Verifielaversion');
end;

procedure TFrm_Verification.Check_Mode_K_VERSION;
var
  QueTmp: TIBQuery;
  vK_ENABLED: string;
  vVERSION_ID: boolean;
  vDependance_VERSION_ID: boolean;
begin
  if (FGestion_K_VERSION = TKNone) then
  begin
    vK_ENABLED := 'int32';
    vVERSION_ID := false;
    vDependance_VERSION_ID := false;
    QueTmp := TIBQuery.Create(Self);
    try
      QueTmp.Database := Data;
        //----------------------------------------------
      QueTmp.close;
      QueTmp.SQL.Clear;
      QueTmp.SQL.Add('SELECT r.RDB$RELATION_NAME,  ');
      QueTmp.SQL.Add('     r.RDB$FIELD_NAME,       ');
      QueTmp.SQL.Add('     f.RDB$FIELD_TYPE,       ');
      QueTmp.SQL.Add('     f.RDB$FIELD_SUB_TYPE,   ');
      QueTmp.SQL.Add('     f.RDB$FIELD_LENGTH      ');
      QueTmp.SQL.Add(' FROM RDB$RELATION_FIELDS r  ');
      QueTmp.SQL.Add(' JOIN RDB$FIELDS f ON r.RDB$FIELD_SOURCE = f.RDB$FIELD_NAME         ');
      QueTmp.SQL.Add(' WHERE r.RDB$RELATION_NAME=''K'' AND r.RDB$FIELD_NAME=''K_VERSION'' ');
      QueTmp.open();
      if not (QueTmp.eof) then
      begin
        if QueTmp.FieldByName('RDB$FIELD_TYPE').asinteger = 16 then
          vK_ENABLED := 'int64'
        else
        begin
          FGestion_K_VERSION := TKV32;
          exit;
        end;
      end;
      QueTmp.close();

      QueTmp.close;
      QueTmp.SQL.Clear;
      QueTmp.SQL.Add('SELECT * FROM RDB$GENERATORS WHERE RDB$GENERATOR_NAME=''VERSION_ID'' ');
      QueTmp.open();
      if not (QueTmp.eof) then
        vVERSION_ID := true
      else
        exit;

      QueTmp.close;
      QueTmp.SQL.Clear;
      if (vVERSION_ID) then
      begin
        QueTmp.close;
        QueTmp.SQL.Clear;
        QueTmp.SQL.Add('SELECT * FROM RDB$DEPENDENCIES WHERE RDB$DEPENDED_ON_NAME=''VERSION_ID'' AND RDB$DEPENDENT_NAME=''PR_UPDATEK'' ');
        QueTmp.open();
        if not (QueTmp.eof) then
          vDependance_VERSION_ID := true
        else
          exit;
      end;
    
        // On peut également controler qu'il est dans sa tranche etc...
      QueTmp.close;
    finally
      if (vK_ENABLED = 'int64') and (vVERSION_ID) and (vDependance_VERSION_ID) then
        FGestion_K_VERSION := TKV64;

      QueTmp.Free;
    end;
  end;
end;

function TFrm_Verification.ChargeSpecifique() : Boolean;
var
  GUID: string;
  tc: tconnexion;
  Tc_R: TstringList;
begin
  lbTitre.Caption := 'Spécifiques' ;

  setPhase('Chargement des spécifiques') ;

  AddToLogs('--------------------------');
  AddToLogsAndMonitoring('Verification', 'ChargeSpecifique', 'Chargement des spécifiques');
  AddToLogs('--------------------------');
  ForceDirectories(GINKOIA + 'liveupdate\');
  if not Automatique then
    MapGinkoia.verifencours := true;
  // vérification de la connexion internet
  result := true;
  
  if Connexion then
  begin
    AddToLogs('Connexion à la base de données - OK');

    data.DatabaseName := BasePrinc;
    try
      Data.Open();
      try
        IBQue_Base.Open;
        GUID := LeGuid;
      finally
        IBQue_Base.Close;
      end;
    finally
      data.Close();
    end;

    try
      Tc := Tconnexion.create;

      if trim(GUID) <> '' then
      begin
        try
          tc_r := tc.select('select * from clients where clt_GUID="' + GUID + '"');
          setPhase('Traitement patchs spécifiques',50) ;
          Result := DownloadSpecifique(tc, tc.UneValeur(tc_r, 'id'))
        finally
          tc.FreeResult(tc_r);
        end;
      end
      else
        AddToLogsAndMonitoring('Verification', 'ChargeSpecifique', 'Pas de GUID !!!', logError);
    finally
      FreeAndNil(tc);
    end;

    Close;

    setPhase('Chargement des spécifiques terminée',100) ;
    AddToLogsAndMonitoring('Verification', 'ChargeSpecifique', 'Chargement des spécifiques terminé');
  end
  else
  begin
    AddToLogsAndMonitoring('Verification', 'ChargeSpecifique', 'Connexion à la base de données - ECHEC', logError);
    result := false;
  end;
  if not Automatique then
    MapGinkoia.verifencours := false;
end;

procedure TFrm_Verification.WaitService;
var
  bConnexion: Boolean;
begin
  bConnexion := False;
  with IBServerProperties do
    while not bConnexion do
    begin
      try
        Active := True;
        bConnexion := True;
      except on E: Exception do
        begin
          Sleep(5000);
        end;
      end;
    end;
end;

// AJ le 28/09/2017 -> test si on est sur le nouveau système de MAJ avec les Ginkoia tools, pour désactiver le vérif
function TFrm_Verification.IsNewMAJ(): Boolean;
begin
  Que_Tmp.Close;
  Que_Tmp.SQL.Clear;
  // pour le PRM_TYPE = 60 et PRM_CODE = 6, si PRM_INTEGER = 1 alors on est sur la mise à jour via les tools, sinon si 0 ou si la ligne n'existe pas, on est en MAJ Yellis
  Que_Tmp.SQL.Text := 'SELECT PRM_ID, PRM_STRING FROM GENPARAM WHERE PRM_TYPE = 60 AND PRM_CODE = 6 AND PRM_INTEGER = 1';
  Que_Tmp.Open;

  if not(Que_Tmp.Eof) then  // si on trouve le genparam avec le PRM_INTEGER à 1, alors on est sur le nouveau système de MAJ
  begin
    Result := true;
    URLTools := Que_Tmp.FieldByName('PRM_STRING').AsString;
  end
  else
    Result := false;

  Que_Tmp.SQL.Clear;
  Que_Tmp.Close;
end;



function TFrm_Verification.DownloadExes(): boolean ;
var
  tConn: Tconnexion;
  GUID, VersionEnCours, idbase, NomVer: string;
  idver, Patch: Integer;
  slYellis, slFiles: TStringList;
  iFic, fileCount: integer;
  fileName: String;
  CRC, CRCold, CRCnew: string;
  doRecup, hasError: boolean;
begin
  Result := False;
  hasError:= false;
  
  if Connexion then
  begin
    try
//      slYellis := TStringList.Create();
//      slFiles := TStringList.Create();

      AddToLogs('Connexion à la base de données - OK');

      data.DatabaseName := BasePrinc;
      tConn := Tconnexion.create;
      Que_Version.Open;
      VersionEnCours := Que_VersionVER_VERSION.AsString;
      Que_Version.Close;
      AddToLogs('Version en cours : ' + VersionEnCours);

      IBQue_Base.Open;
      GUID := LeGuid;

      Log.Ref := GUID;
      Log.Mag := IntToStr(IBQue_BaseBAS_MAGID.AsInteger);
      AddToLogsAndMonitoring('Main', 'Version', GetNumVersionSoft, logInfo);

      Base := IBQue_BaseBAS_NOM.AsString;
      idbase := IBQue_BaseBAS_ID.AsString;
      IBQue_Base.Close;

      // récupération de la version du dossier
      slYellis := tConn.Select('Select * from version where version = "' + VersionEnCours + '"');
      if tConn.recordCount(slYellis) = 0 then
      begin
        idver := 0;
        Patch := 0;
        NomVer := '';
      end
      else
      begin
        idver := Strtoint(tConn.UneValeur(slYellis, 'id'));
        Patch := Strtoint(tConn.UneValeur(slYellis, 'Patch'));
        NomVer := tConn.UneValeur(slYellis, 'nomversion');
      end;
      tConn.FreeResult(slYellis);

      slYellis := tConn.select('select * from clients where clt_GUID="' + GUID + '"');
      if Automatique and (tConn.UneValeurEntiere(slYellis, 'blockmaj') <> 0) then
      begin
        // la demande de MAJ est bloquée
        AddToLogsAndMonitoring('Verification', 'DownloadExes', 'Maj Bloquée');
        Exit;
      end;

      setPhase('Vérification des fichiers',50) ;
      setDetail('Chargement de la liste des fichiers ...') ;
      slFiles := tConn.select('Select * from fichiers Where id_ver = ' + Inttostr(idver));

      fileCount := tConn.recordCount(slFiles);
      for iFic := 0 to tConn.recordCount(slFiles) - 1 do
      begin
        fileName := Ginkoia + tConn.UneValeur(slFiles, 'fichier', iFic);

        // gestion des CRC
        try
          CRCold := IntToStr(FileCRC32(fileName));
        except
          CRCold := '';
        end;
        try
          CRCnew := IntToStr(DoNewCalcCRC32(fileName));
        except
          CRCnew := '';
        end;
        if FnewCRC then
          CRC := CRCnew
        else
          CRC := CRCold;

        setDetail(tConn.UneValeur(slFiles, 'fichier',iFic), Trunc(iFic / fileCount * 100)) ;

        if CRC <> tConn.UneValeur(slFiles, 'crc', iFic) then
        begin
          AddToLogs('Le fichier ' + tConn.UneValeur(slFiles, 'fichier', iFic) + ' doit être mis à jour.');

          doRecup := true;
          if FileExists(GINKOIA + 'A_MAJ\' + tConn.UneValeur(slFiles, 'fichier', iFic)) then
          begin
            CRCold := IntToStr(FileCRC32(GINKOIA + 'A_MAJ\' + tConn.UneValeur(slFiles, 'fichier', iFic)));
            CRCnew := IntToStr(DoNewCalcCRC32(GINKOIA + 'A_MAJ\' + tConn.UneValeur(slFiles, 'fichier', iFic)));
            if FnewCRC then
              CRC := CRCnew
            else
              CRC := CRCold;

            if CRC = tConn.UneValeur(slFiles, 'crc', iFic) then
            begin
              doRecup := False;
              AddToLogs('Le fichier ' + tConn.UneValeur(slFiles, 'fichier', iFic) + ' est déja téléchargé.');
            end else begin
              AddToLogs('Le fichier ' + tConn.UneValeur(slFiles, 'fichier', iFic) + ' téléchargé n''est pas le bon.');
            end;
          end ;

          if doRecup then
          begin

            AddToLogs('Récupération de ' + tConn.UneValeur(slFiles, 'fichier', iFic));

            fileName := GINKOIA + 'A_MAJ\' + tConn.UneValeur(slFiles, 'fichier', iFic);
            ForceDirectories(extractfilepath(fileName));
            if not DownloadFmt( 'http://%s/maj/%s/%s', [ FUrlUpdate, NomVer, tConn.UneValeur( slFiles, 'fichier', iFic ) ], fileName ) then
            begin
              // si on a pas pu télécharger un des fichiers, on le log mais on essai les autres
              AddToLogs('Erreur lors du téléchargement du fichier : ' + fileName, logError);
              hasError := true;
              continue; // pas la peine de tester le CRC si on a eu une erreur lors du DL
            end;

            CRCold := IntToStr(FileCRC32(fileName));
            CRCnew := IntToStr(DoNewCalcCRC32(fileName));
            if FnewCRC then
              CRC := CRCnew
            else
              CRC := CRCold;

            if CRC = tConn.UneValeur(slFiles, 'crc', iFic) then
            begin
              // Si on est sur le nouveau système de mise à jour, on ne met pas à jour Yellis
              if not (FNewMaj) then
                tConn.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                'values (' + tConn.UneValeur(slYellis, 'id') + ', "' + tConn.DateTime(Now) + '", ' +
                '3, "' + tConn.UneValeur(slFiles, 'fichier', iFic) + '","OK","","")')
            end
            else
            begin
              AddToLogs('Erreur CRC dans ' + tConn.UneValeur(slFiles, 'fichier', iFic) + ' -> ECHEC de téléchargement', logError);

              FIsTimeOut := False;
              hasError := true;
              deletefile(fileName);
            end;
          end;
        end
        else begin
          AddToLogs('Le fichier ' + tConn.UneValeur(slFiles, 'fichier', iFic) + ' est à jour.');
        end;
      end;
      tConn.FreeResult(slFiles);
      tConn.FreeResult(slYellis);

      // tous les fichiers sont téléchargés avec succès
      if not hasError then
      begin
        AddToLogsAndMonitoring('Verification', 'DownloadExes', 'Fichiers de la version téléchargés avec succès');
        Result := true;
      end;

    finally
      FreeAndNil(tConn);
    end;
  end
  else
  begin
    AddToLogsAndMonitoring('Verification', 'VerifVersion', 'Connexion à la base de données - ECHEC', logError);
    result := false;
  end;
end;

procedure TFrm_Verification.doTraitement ;
var
  LogLevelProcess: TLogLevel;
  vDlExes: Boolean;
begin
  LogLevelProcess := logInfo;

  AddToLogs('-----------------------------------------------------------------------------');
{$IFDEF DEBUG}
  AddToLogs('Démarrage de Vérification v.'+GetNumVersionSoft+' DEBUG');
{$ELSE}
  AddToLogsAndMonitoring('Verification', 'doTraitement', 'Démarrage de Vérification v.'+GetNumVersionSoft);
{$ENDIF}

  if (MapGinkoia.Backup) then
    exit;

  // Vérifie que le service interbase a bien démarré.
  AddToLogs('Attente du service Interbase ...') ;
  WaitService;
  AddToLogs('Interbase a répondu.') ;

  Update;

  // pour copier le rep documents
  verification_des_batch;

  if not Automatique
    then EXIT;

  // On vérifie si le programme est lancé par synchroportable, et si on est sur le nouveau système de mise à jour
  FNewMaj := IsNewMAJ();

  if (UpperCase(paramstr(2)) = 'SYNCHROPORTABLE') or (UpperCase(paramstr(1)) = 'SYNCHROPORTABLE') then
  begin
    FromSynchro := true;
    ServeurGuid := paramstr(3);
  end;

  // Si le vérif n'est pas lancé par le synchroPortable,
  //on regarde le genparam du nouveau système de mise à jour pour savoir si on lance le vérif ou pas, pas de test si lancé par synchro
  if not (FromSynchro) and (FNewMaj) then
  begin

      MapGinkoia.Verifencours := false;
      lbPhase.Visible := false;
      pbPhase.Visible := false;
      lbDetail.Visible := false;
      pbDetail.Visible := false;
      lbDl.Visible := false;

      lbTitre.Height := 65;
      lbTitre.Top := 75;
      lbTitre.Font.Size := 10;
      lbTitre.WordWrap := True;
      lbTitre.Font.Style := [fsBold];
      lbTitre.Font.Color := clMaroon;
      lbTitre.Caption := 'Cette base utilise le nouveau système de mises à jour, veuillez faire la mise à jour avec GtUpdate.'#13#10'Le programme de verification va se fermer dans 15 secondes.';

      
      VclWait(15000) ;
      MapGinkoia.Verifencours := false;
      close;
      exit;

  end;  

  MapGinkoia.Verifencours := true;
  application.ProcessMessages;

  vDlExes := true;
  // dans tous les modes qui doivent télécharger des fichiers / patchs (sauf spécifique), on vérifie que le DL est ok avant de faire le moindre traitement
  if (Uppercase(paramstr(1)) <> 'SPECIFIQUE') and (Uppercase(paramstr(1)) <> 'ZIP') and (Uppercase(paramstr(1)) <> 'ALG') then
  begin
    vDlExes := DownloadExes();
  end;

  try
    if vDlExes then
    begin
      try
        if paramcount = 0 then
          AddToLogsAndMonitoring('Verification', 'doTraitement', 'Démarrage en mode par défaut')
        else
          AddToLogsAndMonitoring('Verification', 'doTraitement', 'Démarrage en mode ' + paramstr(1));

        if paramcount = 0 then
        begin
          if not Verifielaversion then
            LogLevelProcess := logError;
        end
        else if Uppercase(paramstr(1)) = 'SPECIFIQUE' then
        begin
          if not ChargeSpecifique then
            LogLevelProcess := logError;
        end
        else if Uppercase(paramstr(1)) = 'MAJ' then
        begin
          if not MetAJourlaversion() then
          begin
            AddToLogs(' -> Démarrage en mode MAJ : FAIL');
            LogLevelProcess := logError;
          end;
        end
        else if Uppercase(paramstr(1)) = 'AUTO' then
        begin
          if not Verifielaversion then
            LogLevelProcess := logError;
          if not MetAJourlaversion() then
            AddToLogs(' -> Démarrage en mode AUTO : FAIL');
        end
        else if Uppercase(paramstr(1)) = 'RAZ' then
        begin
          if not Verifielaversion then
            LogLevelProcess := logError;
        end
        else if Uppercase(paramstr(1)) = 'ZIP' then
        begin
          Fait_un_zip(paramstr(2));
        end
        else if Uppercase(paramstr(1)) = 'ALG' then
        begin
          Fait_un_alg(paramstr(2));
        end;
      except
        on e : Exception do
        begin
          AddToLogsAndMonitoring('Verification', 'doTraitement', '!! Exception : ' + e.ClassName + ' - ' + e.Message, logCritical);
          LogLevelProcess := logError;
        end;
      end;
    end
    else
      AddToLogsAndMonitoring('Verification', 'doTraitement', 'Echec du téléchargement des fichiers, arrêt du traitement');
  finally
    AddToLogsAndMonitoring('Verification', 'doTraitement', 'Vérification terminée.', LogLevelProcess);
    VclWait(5000) ;
    MapGinkoia.Verifencours := false;
    close;
  end;
end;

procedure TFrm_Verification.VclWait(aTime : Integer) ;
var
  vTc : Cardinal ;
begin
  vTc := getTickCount ;

  while (getTickCount < (vTc + aTime)) do
  begin
    sleep(10) ;
    Application.ProcessMessages ;
  end;
end; 

procedure TFrm_Verification.IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
var
  sa : string ;
begin

  // si plus de 20 min pour le dl d'un fichier, on passe en timeout
  if SecondsBetween(now(), FTimeOutDl) > 1200 then
  begin;
    FIsTimeOut := true;
    TIdHTTP(ASender).Disconnect();
  end;

  if AWorkMode=wmRead then
  begin
      if FDlMax > 0 then
      begin
        lbDl.Alignment := taRightJustify ;
        lbDl.Caption := IntToStr(Round(AWorkCount / FDLMax * 100)) + '% ' ;
      end else begin
        sa := ' ' + copy('••••••••••', 1, Trunc(AWorkCount / (1024 * 1024 / 10)) mod 10) ;
        lbDl.Alignment := taLeftJustify ;
        lbDl.Caption := sa ;
      end;
  end;

  Application.ProcessMessages ;
end;

procedure TFrm_Verification.IdHTTPWorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  if AWorkMode = wmRead then
   begin
     FDlMax := AWorkCountMax;
     lbDl.Caption := '' ;
   end;
   Application.ProcessMessages ;
end;

procedure TFrm_Verification.IdHTTPWorkEnd(ASender: TObject;
  AWorkMode: TWorkMode);
begin
  lbDl.Caption := '' ;
  Application.ProcessMessages ;
end;

function TFrm_Verification.isEasy: boolean;
begin
  result := false;

  Que_Tmp.Close;
  Que_Tmp.SQL.Clear;
  Que_Tmp.SQL.Text := 'SELECT PRM_STRING FROM GENPARAM WHERE PRM_TYPE = 80 AND PRM_CODE = 1';
  Que_Tmp.Open;

  if not(Que_Tmp.Eof) then
    Result := (Que_Tmp.FieldByName('PRM_STRING').AsString <> '');

  Que_Tmp.SQL.Clear;
  Que_Tmp.Close;

end;

function TFrm_Verification.MetAJourlaversion : boolean;
var
  Fich: string;
  j: integer;
  i: integer;
  k: integer;
  ListMaj: Tstringlist;
  Sauve: tstringlist;
  LeSyncWeb: Boolean;
  LeEasyComptage: Boolean;
  Base: string;
  LesEai: TstringList;
  idbase: string;
  s: string;
  Handle: Integer;
  tsl: tstringlist;
  tc: Tconnexion;
  t_clt: tstringlist;
  GUID: string;
  LesBases: TstringList;
  f: tsearchrec;
  vDir : string ;

  Dois_relance_SYNCWEB: Boolean;

  vVersionUpdated : boolean ;
  vMobiliteSvrUpdated : boolean ;

  vRestartMobilite, vRestartBI, vRestartLauncher : boolean ;

  CRC1, CRC1old, CRC1new : string;
  CRC2, CRC2old, CRC2new : string;

  HasNoError: boolean;
begin
  AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'Début MetAJourlaversion');

  HasNoError := true;
  result := false;
  vVersionUpdated := false ;
  vMobiliteSvrUpdated := false ;
  vRestartMobilite := false ;
  vRestartBI := false ;
  vRestartLauncher := false ;

  lbTitre.Caption := 'Mise à jour' ;

  AddToLogs('---------------------');
  AddToLogs('Met a jour la version');
  AddToLogs('---------------------');

  if FileExists(GINKOIA + 'liveupdate\amaj.txt') then
  begin
    tsl := tstringlist.create;
    tsl.LoadFromFile(GINKOIA + 'liveupdate\amaj.txt');
    tsl.savetofile(GINKOIA + 'liveupdate\copy.tmp');
    tsl.free;
    AddToLogs('copie de "' + GINKOIA + 'liveupdate\amaj.txt' + '" vers "' + GINKOIA + 'liveupdate\copy.tmp"');
  end;



  Dois_relance_SYNCWEB := false;
  LeSyncWeb := false;
  if not Automatique then
    MapGinkoia.verifencours := true;

  // si le backup était lancé (ce qui ne devrait pas être le cas, attendre qu'il soit fini !
  while MapGinkoia.Backup do
  begin
    setPhase('Attente de la fin de Backup',0) ;
    Application.ProcessMessages ;
    Sleep(1000);
  end;

  setPhase('',10) ;

  ListMaj := Lesfichier(GINKOIA + 'A_MAJ\', i); // ATTENTION : La liste est avec les chemin relatif a "ginkoia" !

  try

    if (ListMaj.count > 0) or (NetoyageDesConneriesAStan(true)) then
    begin
      AddToLogs('Mise à jour nécessaire traitement des fichiers en cours');

      for i := 0 to ListMaj.Count -1 do
      begin
        if pos('MOBILITESVR.EXE', UpperCase(ListMaj[i])) > 0 then
        begin
          AddToLogs('Le service mobilité doit être mis à jour.');
          vMobiliteSvrUpdated := true ;
        end;
      end;

      tc := Tconnexion.create;
      IBQue_Base.Open;
      Base := IBQue_BaseBAS_NOM.AsString;
      idbase := IBQue_BaseBAS_ID.AsString;
      IBQue_Base.Close;

      LesBases := TstringList.Create;
      LesEai := TstringList.Create;
      Les_BD.paramByName('BASID').AsString := idbase;
      Les_BD.Open;
      while not Les_BD.Eof do
      begin
        if ((Les_BDREP_PLACEEAI.AsString = '') or (Les_BDREP_PLACEBASE.AsString = ''))
          then AddToLogs('Erreur : Paramétrage dans la base invalide (REP_PLACEBASE et REP_PLACEEAI)');

        LesBases.Add(Les_BDREP_PLACEBASE.AsString);
        LesEai.Add(Les_BDREP_PLACEEAI.AsString);
        Les_BD.next;
      end;
      Les_BD.Close;
      data.close;

      setPhase('Arrêt des applications',20) ;
      AddToLogs('Arret des applications en cours');

      Lapplication := _ginkoia;
      EnumWindows(@Enumerate, 0);
      sleep(100);
      Lapplication := _Caisse;
      EnumWindows(@Enumerate, 0);
      sleep(100);
      Lapplication := _PICCO;
      EnumWindows(@Enumerate, 0);
      sleep(100);
  //    Lapplication := _TPE;
  //    EnumWindows(@Enumerate, 0);
  //    sleep(100);

      vRestartLauncher := Launcher(true);

      sleep(100);

      // Arret d'EasyComptage s'il est lancé
      LeEasyComptage :=KillProcess(_EasyComptage);
      Sleep(100);

      Lapplication := _PICCOBATCH;
      EnumWindows(@Enumerate, 0);
      sleep(100);

      Lapplication := _SCRIPT;
      EnumWindows(@Enumerate, 0);

      sleep(100);
      if KillProcess(_TPE)
        then AddToLogs('Arrêt du Serveur TPE : Ok')
        else AddToLogs('Arrêt du Serveur TPE : Echec');

      sleep(100);
      AppliArret := KillProcess(_SYNCWEB);
      LeSyncWeb := AppliArret;

      sleep(5000);
      Dois_relance_SYNCWEB := true;

      // Arrêt du service d'impression Ginkoia
//      ServiceStop('', 'ImpDoc_SRC');
//
//      // Arrêt du service Mobilité
//      vRestartMobilite := false ;
//      if vMobiliteSvrUpdated then
//      begin
//        if ServiceStarted('', 'GinkoiaMobiliteSvr') then
//        begin
//          vRestartMobilite := true ;
//          AddToLogs('Arrêt du service Mobilité');
//          ServiceStop('', 'GinkoiaMobiliteSvr');
//        end;
//      end;
//
//      vRestartBI := false ;
//      if ServiceStarted('', 'Service_BI_Ginkoia') then
//      begin
//        vRestartBI := true ;
//        AddToLogs('Arrêt du service BI');
//        ServiceStop('', 'Service_BI_Ginkoia') ;
//      end;
    if not SrvManager.stopServices then
    begin
      AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'Impossible d''arreter les services, on stop la MAJ', logError);
      Exit;
    end;

  {$REGION 'Arret des applications externe via le fichier KLaunch.app'}
      KillApp.Load;
      for i := 0 to KillApp.Count - 1 do
        KillProcess(KillApp.List[i]);
  {$ENDREGION}


      NetoyageDesConneriesAStan(false);

      Sauve := tstringlist.create;

      setPhase('Mise à jour des fichiers',50) ;


      for i := 0 to ListMaj.count - 1 do
      begin
        if uppercase(Ginkoia + ListMaj[i]) = uppercase(Application.exename) then
        begin
          // ne pas essayer de se mettre a jour sois-même
          continue;
        end;

        setDetail('Fichier ' + ListMaj[i], Round( i / ListMaj.count * 100)) ;
        AddToLogs('Maj de ' + ListMaj[i]);

        Fich := Ginkoia + 'SVE_NOW\' + ListMaj[i];
        ForceDirectories(extractfilepath(Fich));
        if CopyFile(Pchar(Ginkoia + ListMaj[i]), Pchar(fich), False) then
          Sauve.Add(ListMaj[i]);

        if pos('\EAI\', Uppercase(Ginkoia + ListMaj[i])) > 0 then
        begin
          // Traitement des EAI

          for k := 0 to LesEai.count - 1 do
          begin
            S := ListMaj[i];
            delete(s, 1, 4);

            vDir := extractfilepath(LesEai[k] + S) ;
            ForceDirectories(vDir);

            if not CopyFile(Pchar(GINKOIA + 'A_MAJ\' + ListMaj[i]), Pchar(LesEai[k] + S), false) then
            begin
              if Connexion then
              begin
                data.dataBaseName := BasePrinc;
                data.open;
                IBQue_Base.Open;
                GUID := LeGuid;
                Base := IBQue_BaseBAS_NOM.AsString;
                data.Close;
                if trim(GUID) <> '' then
                begin
                  AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'EAI -> Problème Maj d''un fichier : ' + ListMaj[i] + ' ' + LesEai[k] + S, logError);
                  t_Clt := tc.select('select * from clients where clt_GUID="' + GUID + '"');
                  IBQue_Base.Close;
                  // Si on est sur le nouveau système de mise à jour, on ne met pas à jour Yellis
                  if not (FNewMaj) then
                    tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                    'values (' + tc.UneValeur(t_Clt, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                    '6, "Problème de MAJ d''un fichier","' + LesEai[k] + S + '","' + VersionEnCours + '","")');
                  tc.FreeResult(t_clt);
                end;
              end;
            end
            else
              AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'EAI ->Maj d''un fichier ok : ' + ListMaj[i] + ' ' + LesEai[k] + S, logInfo);

          end; // for LesEai

        end
        else
        begin
          // Traitement des autres fichiers

          vDir := extractfilepath(Ginkoia + ListMaj[i]) ;
          if not DirectoryExists(vDir) then
          begin
            AddToLogs('Création du répertoire ' + vDir);
            if not ForceDirectories(vDir)
              then AddToLogs('Création du répertoire ' + vDir + ' : Echec');
          end;

          if (pos('INSTALLBMC.EXE', UpperCase(ListMaj[i])) > 0) then
          begin
            try
              CRC1old := IntToStr(FileCRC32(Ginkoia + ListMaj[i]));
            except
              CRC1old := '';
            end;
            try
              CRC1new := IntToStr(DoNewCalcCRC32(Ginkoia + ListMaj[i]));
            except
              CRC1new := '';
            end;
            if FnewCRC then
              CRC1 := CRC1new
            else
              CRC1 := CRC1old;
          end;

          if not CopyFile(Pchar(GINKOIA + 'A_MAJ\' + ListMaj[i]), Pchar(Ginkoia + ListMaj[i]), false) then
          begin
            if (UpperCase(ListMaj[i]) = 'BPL\LIBEAY32.DLL') or (UpperCase(ListMaj[i]) = 'BPL\SSLEAY32.DLL') then
            begin
              AddToLogs('Skip copy file : ' + ListMaj[i]);
              // si ces fichiers existents c'est qu'il doivent être remplacé, on lance GinkoRep pour le prochain démarrage
              AddDelRegistryForGinkoRep(regAdd);
              continue;
            end;

            // Rollback All
            AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'Maj de ' + ListMaj[i]+' : Echec', logError);
            HasNoError := False;

            setPhase('Echec de la mise à jour', 60) ;

            AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'Rollback de la mise à jour ...', logCritical);
            for j := sauve.count - 1 downto 0 do
            begin
              setDetail('Rollback de ' + Sauve[j], Round( j / ListMaj.count * 100)) ;

              if CopyFile(Pchar(Ginkoia + 'SVE_NOW\' + Sauve[j]), Pchar(Ginkoia + Sauve[j]), False) then
              begin
                AddToLogs('Restauration de ' + Sauve[j] + ' : Ok');
                // suppression seulement si le fichier a été restauré correctement
                if deletefile(Pchar(Ginkoia + 'SVE_NOW\' + Sauve[j])) then
                  AddToLogs('Suppression de ' + Ginkoia + 'SVE_NOW\' + Sauve[j] + ' - OK')
              end
              else
                AddToLogs('Restauration de ' + Sauve[j] + ' : Echec') ;
            end;
            AddToLogs('Rollback effectué') ;

            if Connexion then
            begin
              AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'Mise à jour de Yellis ...');
              data.dataBaseName := BasePrinc;
              data.open;
              IBQue_Base.Open;
              GUID := LeGuid;
              Base := IBQue_BaseBAS_NOM.AsString;
              data.Close;
              if trim(GUID) <> '' then
              begin
                AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'Problème Maj d''un fichier : ' + ListMaj[i] + ' ' + LesEai[k] + S, logError);
                t_Clt := tc.select('select * from clients where clt_GUID="' + GUID + '"');
                IBQue_Base.Close;
                // Si on est sur le nouveau système de mise à jour, on ne met pas à jour Yellis
                if not (FNewMaj) then
                  tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                  'values (' + tc.UneValeur(t_Clt, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                  '6, "Problème de MAJ d''un fichier","' + ListMaj[i] + '","' + VersionEnCours + '","")');
                tc.FreeResult(t_clt);
              end;
              AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'Mise à jour de Yellis effectuée');
            end;

            break;
          end
          else
          begin
            AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'Maj de ' + ListMaj[i] + ' : Ok', logInfo);

            try
              Handle := FileOpen(Pchar(Ginkoia + ListMaj[i]), fmOpenReadWrite);
              FileSetDate(Handle, DateTimeToFileDate(now));
              FileClose(Handle);
              AddToLogs('Maj de la dat de ' + ListMaj[i] + ' : Ok');
            except
              AddToLogs('Maj de la dat de ' + ListMaj[i] + ' : Echec');
            end;

            if (pos('INSTALLBMC.EXE', UpperCase(ListMaj[i])) > 0) then
            begin
              try
                CRC2old := IntToStr(FileCRC32(Ginkoia + ListMaj[i]));
              except
                CRC2old := '';
              end;
              try
                CRC2new := IntToStr(DoNewCalcCRC32(Ginkoia + ListMaj[i]));
              except
                CRC2new := '';
              end;
              if FnewCRC then
                CRC2 := CRC2new
              else
                CRC2 := CRC2old;

              if (CRC1 <> CRC2) then
              begin
                AddToLogs('BMC doit être mis à jour (' + CRC1 + ' <> ' + CRC2 + ').');
                ShellExecute(0, 'open', PChar(Ginkoia + ListMaj[i]), 'SERVEUR', nil, SW_HIDE);
              end
              else
                AddToLogs('BMC est déjà à jour (' + CRC1 + ' = ' + CRC2 + ').');
            end;

            // Aumoins un fichier a été mis a jour
            vVersionUpdated := true ;
          end;
        end;
      end; // for


      // si on a réussi à mettre à jour tous les fichiers, on les supprimes de A_MAJ
      if HasNoError then
      begin
        for i := 0 to ListMaj.count - 1 do
        begin
          if uppercase(Ginkoia + ListMaj[i]) = uppercase(Application.exename) then
          begin
            // On ne supprime pas le fichier verification.Exe. C'est via les launcher qu'il est mis à jour
            AddToLogs('Fichier ' + ListMaj[i] + ' non traité. Sera MAJ par le launcher');
            continue;
          end;

          if deletefile(Pchar(GINKOIA + 'A_MAJ\' + ListMaj[i])) then
            AddToLogs('Suppression de la source de ' + ListMaj[i] + ' : Ok')
          else
            AddToLogs('Suppression de la source de ' + ListMaj[i] + ' : Erreur');
        end;

        AddToLogs('Suppression des fichier de sauvegarde');
        for j := 0 to sauve.count - 1 do
        begin
          if deletefile(Pchar(Ginkoia + 'SVE_NOW\' + Sauve[j]))
            then AddToLogs(Ginkoia + 'SVE_NOW\' + Sauve[j] + ' - OK')
            else AddToLogs(Ginkoia + 'SVE_NOW\' + Sauve[j] + ' - ECHEC');
        end;
        Sauve.free;
      end
      else
        // si une erreur lors du remplacement des fichiers, on lancera ginkorep au prochain démarrage
        AddDelRegistryForGinkoRep(regAdd);

      GUID := LeGuid;

      // si on est lancé par le synchroPortable est qu'on est sur le nouveau système de mise à jour, on informe le nouveau système  :
      if (FNewMaj) and (FromSynchro) and (ServeurGuid <> '') and (GUID <> '')  then
      begin
        tc.updateGT(ServeurGuid, GUID, URLTools);
      end;

      LesBases.free;
      LesEai.free;
      tc.free;
    end;

  except
    on E:Exception do
    begin
      AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'Erreur lors de la mise à jour  : ' + E.Message, logCritical);
      // si une erreur lors du remplacement des fichiers, on lancera ginkorep au prochain démarrage
      AddDelRegistryForGinkoRep(regAdd);
    end;
  end;

  ListMaj.free;

  // Update de la base
  if vVersionUpdated then
  begin
    AddToLogs('Mise a jour de l''indicateur dans la base : Version UPDATED') ;

    try
      if data.Connected then
      begin
        if tran.Active then
        begin
          AddToLogs('la transaction est active, on rollback') ;
          tran.Rollback ;
        end;
        AddToLogs('fermeture de la database:'+data.dataBaseName) ;
        data.close;
      end;
      data.dataBaseName := BasePrinc;
      AddToLogs('Ouverture de la database:'+data.dataBaseName) ;
      data.open;
      AddToLogs('début de la transaction') ;
      Que_Tmp.Transaction.StartTransaction ;
      try
        Que_Tmp.Close ;
        Que_Tmp.SQL.Text := 'UPDATE GENPARAMBASE SET PAR_STRING=:STRING, PAR_FLOAT=:FLOAT WHERE PAR_NOM=:NOM' ;
        Que_Tmp.ParamCheck := true ;
        Que_Tmp.ParamByName('NOM').AsString  := 'VERIFICATION' ;
        Que_Tmp.ParamByName('FLOAT').AsFloat := Double(now) ;

        if vVersionUpdated
          then Que_Tmp.ParamByName('STRING').AsString := 'UPDATED'
          else Que_Tmp.ParamByName('STRING').AsString := 'OK' ;

        Que_Tmp.ExecSQL ;

        if Que_Tmp.RowsAffected < 1 then
        begin
          Que_Tmp.SQL.Text := 'INSERT INTO GENPARAMBASE (PAR_NOM, PAR_STRING, PAR_FLOAT) VALUES (:NOM, :STRING, :FLOAT)' ;
          Que_Tmp.ParamCheck := true ;
          Que_Tmp.ParamByName('NOM').AsString  := 'VERIFICATION' ;
          Que_Tmp.ParamByName('FLOAT').AsFloat := Double(now) ;

          if vVersionUpdated
            then Que_Tmp.ParamByName('STRING').AsString := 'UPDATED'
            else Que_Tmp.ParamByName('STRING').AsString := 'OK' ;

          Que_Tmp.ExecSQL ;
        end;

        Que_Tmp.Transaction.Commit ;
        AddToLogs('--> Ok');
      except
        on E:Exception do
        begin
            AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', '--> Error Updating database version  : ' + E.Message, logCritical);
            Que_Tmp.Transaction.Rollback ;
        end;
      end;
      data.Close ;

    except
      on E:Exception do
        AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'Erreur lors de la mise a jour de l''indicateur dans la base : ' + E.Message, logCritical);
    end;
  end else begin
    AddToLogs('Mise a jour de l''indicateur dans la base : Non effectué') ;
  end;


  AddToLogs('Début du traitement du fichier : ' + Ginkoia + 'liveupdate\amaj.txt');
  try
    if not Automatique then
    begin
      AddToLogs('Pas en Auto, pas de traitement de AMAJ');
      MapGinkoia.verifencours := false
    end
    else
    begin
      if FileExists(Ginkoia + 'liveupdate\amaj.txt') then
      begin
        AddToLogs('Traitement du fichier : ' + Ginkoia + 'liveupdate\amaj.txt');
        tsl := tstringlist.create;
        tsl.loadfromfile(Ginkoia + 'liveupdate\amaj.txt');
        while tsl.count > 0 do
        begin
          S := tsl[0];
          while tsl.indexof(s) > -1 do
            tsl.delete(tsl.indexof(s));
          tsl.savetofile(Ginkoia + 'liveupdate\amaj.txt');
          if uppercase(ExtractFileExt(s)) = '.EXE' then
          begin
//            s := s + ' AUTO';
            AddToLogs('Exécution du fichier : ' + s);
//            winexec(pchar(s), 0);
            ShellExecute(0, 'open', PChar(s), PChar('Auto'), nil, SW_SHOWNORMAL);
          end
          else if uppercase(ExtractFileExt(s)) = '.ZIP' then
          begin
            AddToLogs('Dézippagze du fichier : ' + s);
            zip.DestDir := Ginkoia + 'LiveUpdate\' + ChangeFileExt(s, '') + '\';
            zip.ZipName := S;
            zip.unzip;
            if findfirst(Ginkoia + 'LiveUpdate\' + ChangeFileExt(s, '') + '\*.alg', faAnyFile, f) = 0 then
            begin
              AddToLogs('Traitement BATCH(ZIP) du fichier : ' + Ginkoia + 'LiveUpdate\' + ChangeFileExt(s, '') + '\' + f.Name);
              Traitement_BATCH(Ginkoia + 'LiveUpdate\' + ChangeFileExt(s, '') + '\' + f.Name);
            end;
            findclose(f);
          end
          else if uppercase(ExtractFileExt(s)) = '.ALG' then
          begin
            // language macro
            AddToLogs('Traitement BATCH (ALG) du fichier : ' + s);
            Traitement_BATCH(s);
          end;
        end;
        tsl.free;
      end
      else AddToLogs('Le fichier "' + Ginkoia + 'liveupdate\amaj.txt" n''existe pas');
    end;
  except
    on E:Exception do
      AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'Erreur lors du traitement des ALG : ' + E.Message, logCritical);
  end;

  AddToLogs('Redémarrage des applications :');
  setPhase('Redémarrage des applications',90) ;

  try
    if vRestartLauncher then
      Launcher(false);

//    // Relance du service d'impression ginkoia
//    ServiceStart('', 'ImpDoc_SRC');
//
//    // Relance du service de Mobilité
//    if vRestartMobilite then
//    begin
//      AddToLogs('Redémarrage du service Mobilité');
//      ServiceStart('', 'GinkoiaMobiliteSvr');
//    end;
//
//    if vRestartBI then
//    begin
//      AddToLogs('Redémarrage du service BI');
//      ServiceStart('', 'Service_BI_Ginkoia');
//    end;

    SrvManager.restartServices;

    if LeEasyComptage then
    begin
      AddToLogs('Relance de EasyComptage');
      // Relance de EasyComptage en mode Auto
//      WinExec(Pchar(Ginkoia + 'Easycomptage\'+ _EasyComptage +' /AUTO'), 0);
      ShellExecute(0, 'open', PChar(Ginkoia + 'Easycomptage\'+ _EasyComptage), PChar(' /AUTO'), nil, SW_SHOWNORMAL);
    end;

    if Dois_relance_SYNCWEB and LeSyncWeb then
    begin
      AddToLogs('Relance de SyncWeb');
//      WinExec(Pchar(Ginkoia + 'FluxWeb\SyncWeb.exe AUTO'), 0);
      ShellExecute(0, 'open', PChar(Ginkoia + 'FluxWeb\SyncWeb.exe'), PChar('AUTO'), nil, SW_SHOWNORMAL);
    end;
  except
    on E:Exception do
      AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'Erreur lors du redémarrage des applications : ' + E.Message, logCritical);
  end;

  AddToLogsAndMonitoring('Verification', 'MetAJourlaversion', 'Fin MetAJourlaversion');
  setPhase('Mise à jour terminée',100) ;
  result := true;
end;

function TFrm_Verification.traitechaine(S: string): string;
var
  kk: Integer;
begin
  while pos(' ', S) > 0 do
  begin
    kk := pos(' ', S);
    delete(S, kk, 1);
    Insert('%20', S, kk);
  end;
  result := S;
end;

procedure TFrm_Verification.de_a_version(var Dep, Arr: string);
var
  base: string;
  soc: string;
//  tsl: tstringlist;
  GUID: string;
  tc: tconnexion;
  T_Clt: tstringlist;
  T_Ver: tstringlist;
begin
  // recherche du GUID
  Tc := Tconnexion.create;
  IBQue_Base.Open;
  GUID := trim(LeGuid);
//  tsl := tstringlist.create;
  Base := IBQue_BaseBAS_NOM.AsString;
  IBQue_Base.Close;
  IBQue_Soc.Open;
  Soc := IBQue_SocSOC_NOM.AsString;
  IBQue_Soc.Close;
  data.close;
  AddToLogs('Nom de la base ' + Base);
  if trim(GUID) <> '' then
  begin
    T_Clt := tc.Select('Select * from clients where clt_GUID="' + GUID + '"');
    AddToLogs('Version du client ' + tc.UneValeur(T_Clt, 'version'));
    T_Ver := tc.select('Select * from version where id = ' + tc.UneValeur(T_Clt, 'version'));
    if tc.recordCount(T_Ver) = 0 then
      Dep := ''
    else
      Dep := Uppercase(tc.UneValeur(T_Ver, 'nomversion'));
    AddToLogs('Nom de la version  ' + tc.UneValeur(T_Ver, 'nomversion'));
    AddToLogs('Version à passer ' + tc.UneValeur(T_Clt, 'version_max'));
    tc.FreeResult(T_Ver);
    T_Ver := tc.select('Select * from version where id = ' + tc.UneValeur(T_Clt, 'version_max'));
    if tc.recordCount(T_Ver) = 0 then
      Arr := ''
    else
      Arr := Uppercase(tc.UneValeur(T_Ver, 'nomversion'));
    AddToLogs('Nom de la version  ' + tc.UneValeur(T_Ver, 'nomversion'));
    tc.FreeResult(T_Ver);
    tc.FreeResult(T_Clt);
  end;
//  tsl.savetofile(changefileext(application.exename, '.txt'));
//  tsl.free;
  tc.free;
end;

function TFrm_Verification.Download(const URL, DestFilename: String): Boolean;
  function  FormatInClock(TickCount: Cardinal): string;
  var
    dd,hh,mm,ss,ms: Cardinal;
  begin
    Result := '00:00:00:00:000';
    if (TickCount > 0) then
    try
      ms := TickCount mod 1000;
      TickCount := TickCount div 1000;

      ss := TickCount mod 60;
      TickCount := TickCount div 60;

      mm := TickCount mod 60;
      TickCount := TickCount div 60;

      hh := TickCount mod 60;
      TickCount := TickCount div 60;

      dd := TickCount;
    finally
      Result := Format( '%.2d:%.2d:%.2d:%.2d:%.2d', [ dd, hh, mm, ss, ms ] );
    end;
  end;
var
  IdHTTP: TIdHTTP;
  IdCompressorZLib: TIdCompressorZLib;
  FileStream: TFileStream;
  InitialTickCount: Cardinal;
  vTry      : Integer ;
begin
  Result := False ;
  vTry := 0 ;

  repeat

    Inc(vTry) ;
    try

      FileStream := TFileStream.Create( DestFilename, fmCreate or fmShareExclusive );
      try
        IdHTTP := TIdHTTP.Create( nil );
        IdHTTP.OnWork := IdHTTPWork;
        IdHTTP.OnWorkBegin := IdHTTPWorkBegin;
        IdHTTP.OnWorkEnd := IdHTTPWorkEnd;
        IdCompressorZLib := TIdCompressorZLib.Create( nil );
        IdHTTP.Compressor := IdCompressorZLib;
        IdHTTP.Request.AcceptEncoding := 'gzip';
        IdHTTP.HandleRedirects := True;
        IdHTTP.RedirectMaximum := 15;
        //IdHTTP.ReadTimeout := 1800000; // 30min max pour un dl de fichier
        FIsTimeOut := false;
        FTimeOutDl := Now();

        try
          AddToLogs( Format( 'Downloading "%s" -> "%s" (Try %d/5)', [ traitechaine( URL ), DestFilename, vTry ] ) );

          InitialTickCount := GetTickCount;

          IdHTTP.Get( TIdURI.URLEncode( URL ), FileStream );                    // traitechaine( URL )

          if idHTTP.ResponseCode = 200 then
          begin
            if FIsTimeOut then
            begin
              AddToLogs(Format( '  --> ERREUR TIMEOUT : %s (ms)', [FormatInClock(GetTickCount - InitialTickCount)]), logError);
              Result := False;
            end
            else
            begin
              AddToLogs(Format( '  --> OK : %s (ms)',[FormatInClock(GetTickCount - InitialTickCount)]));
              Result := True;
            end;
          end
          else
          begin
            raise Exception.Create('Erreur lors du téléchargement : ' + IntToStr(idHTTP.ResponseCode) + ' : ' + idHTTP.ResponseText ) ;
          end;

        finally
          IdHTTP.Free;
        end;

        if FileStream.Size < 1 then
        begin
          raise Exception.Create('Le fichier téléchargé est vide');
        end;

      finally
        FileStream.Free;
      end;

    except
      on E: Exception do begin
        AddToLogs( Format( '  --> Erreur : %s - %s - %s - %s', [ traitechaine( URL ), DestFilename, E.ClassName, E.Message ] ) );
        if FileExists( DestFilename ) then
          DeleteFile( DestFilename );
        Result := False;
      end;
    end;

    if Result = false then
      sleep(1000) ;              // Pause de 1 seconde entre 2 réessais

  until (Result = true) or (vTry >= 5) ;
end;

function TFrm_Verification.DownloadFmt(const URL, FormatDestFilename: String;
  const ArgsDestFilename: array of const): Boolean;
begin
  Result := Download( URL, Format( FormatDestFilename, ArgsDestFilename ) );
end;

function TFrm_Verification.DownloadFmt(const FormatURL: String;
  const ArgsURL: array of const; const DestFilename: String): Boolean;
begin
  Result := Download( Format( FormatURL, ArgsURL ), DestFilename );
end;

function TFrm_Verification.DownloadFmt(const FormatURL: String;
  const ArgsURL: array of const; const FormatDestFilename: String;
  const ArgsDestFilename: array of const): Boolean;
begin
  Result := False ;
  try
    Result := Download( Format( FormatURL, ArgsURL ), Format( FormatDestFilename, ArgsDestFilename ) );
  except
    on E:Exception do
      AddToLogsAndMonitoring('Verification', 'DownloadFmt', 'Exception lors du téléchargement de ' + Format( FormatURL, ArgsURL ) + ' vers ' + Format( FormatDestFilename, ArgsDestFilename ) + ' : ' + E.Message, logCritical);
  end;
end;

procedure TFrm_Verification.MAJplante(S: string);
var
  GUID: string;
  t_Clt: Tstringlist;
  tc: tconnexion;
begin
  try
    tc := tconnexion.create;
    IBQue_Base.Open;
    GUID := LeGuid;
    Base := IBQue_BaseBAS_NOM.AsString;
    data.Close;
    if trim(GUID) <> '' then
    begin
      t_Clt := tc.select('select * from clients where clt_GUID="' + GUID + '"');
      IBQue_Base.Close;
      // Si on est sur le nouveau système de mise à jour, on ne met pas à jour Yellis
      if not (FNewMaj) then
        tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
        'values (' + tc.UneValeur(t_Clt, 'id') + ', "' + tc.DateTime(Now) + '", ' +
        '10, "MAJ plantée","' + S + '","","")');
      tc.FreeResult(t_clt);
    end;
    tc.free;
  except
  end;
end;

function TFrm_Verification.Script(base, S: string): Boolean;
begin
  result := true;
  try
    S := trim(s);
    data.close;
    data.databasename := base;
    data.open;
    tran.Active := true;
    Sql.SQL.Text := S;
    Sql.ExecQuery;
    if Sql.Transaction.InTransaction then
      Sql.Transaction.Commit;
    data.close;
  except
    on e : Exception do
    begin
      if Sql.Transaction.InTransaction then
        Sql.Transaction.rollback;
      tran.Active := true;
      //lab 1213 :  UpperCAse sur le texte à comparer et non sur tout le script pour éviter certains bugs
      //S := UpperCase(S);
      if Pos(#13#10, S) > 0 then
        AddToLogsAndMonitoring('Verification', 'Script', 'Script warning : exception in "' + Copy(S, 1, Pos(#13#10, S) -1) + '...".', logError)
      else
        AddToLogsAndMonitoring('Verification', 'Script', 'Script warning : exception in "' + S + '".', logError);
      // gestion des GENERATOR déja existants
      if UPPERCASE(copy(S, 1, length('CREATE GENERATOR'))) = 'CREATE GENERATOR' then
      begin
        result := True;
      end
        // gestion des TRIGGER déja existants
      else if UPPERCASE(Copy(S, 1, length('CREATE TRIGGER'))) = 'CREATE TRIGGER' then
      begin
        result := True;
      end
        // gestion des INDEX déja existants
      else if UPPERCASE(Copy(S, 1, length('CREATE INDEX'))) = 'CREATE INDEX' then
      begin
        result := True;
      end
        // gestion des PROCEDURE déja existance
      else if UPPERCASE(Copy(S, 1, length('CREATE PROCEDURE'))) = 'CREATE PROCEDURE' then
      begin
        delete(s, 1, 6);
        S := 'ALTER' + S;
        try
          Sql.SQL.Text := S;
          Sql.ExecQuery;
          if Sql.Transaction.InTransaction then
            Sql.Transaction.Commit;
          data.close;
        except
          begin
            AddToLogsAndMonitoring('Verification', 'Script', 'Script error : exception relancée -> ' + e.ClassName + ' - ' + e.Message, logError);
            result := false;
          end;
        end;
      end
      else
      begin
        AddToLogsAndMonitoring('Verification', 'Script', 'Script error : exception non gérée -> ' + e.ClassName + ' - ' + e.Message, logError);
        result := false;
      end;
    end;
  end;
end;

procedure Detruit(src: string);
var
  f: tsearchrec;
begin
  if src[length(src)] <> '\' then
    src := src + '\';
  if findfirst(src + '*.*', faanyfile, f) = 0 then
  begin
    repeat
      if (f.name <> '.') and (f.name <> '..') then
      begin
        if f.Attr and faDirectory = 0 then
        begin
          fileSetAttr(src + f.Name, 0);
          deletefile(src + f.Name);
        end
        else
          Detruit(Src + f.name);
      end;
    until findnext(f) <> 0;
  end;
  findclose(f);
  RemoveDir(Src);
end;

function TFrm_Verification.Traitement_BATCH(LeFichier: string): Boolean;
var
  PassTsl: TstringList;
  Tsl: TstringList;
  LesVar: TstringList;
  LesVal: TstringList;
  LaPille: TstringList;
  Ordre: string;
  MarqueurEai: Integer;
  EaiEnCours: Integer;
  XML: TMonXML2;
  PathOrdre: string;
  PathEAI: string;
  i: Integer;
  S: string;
  LeTemps: Dword;
  Temps: Dword;
  timeout: Boolean;

  NoeudsEnCours: IXMLDOMNodeList;
  NoeudConcerne: string;
  ValeurEnCours: Integer;
  MarqueurNoeuds: Integer;

  LesEai: tstringlist;

  function LeTimeOut: boolean;
  begin
    result := false;
    if timeout then
    begin
      if GetTickCount > LeTemps then
      begin
        result := true;
      end;
    end;
  end;

  function remplacer(S: string; Cherche: string; Valeur: string): string;
  var
    j: Integer;
  begin
    while Pos(Cherche, S) > 0 do
    begin
      j := Pos(Cherche, S);
      if j > 0 then
      begin
        delete(S, j, length(cherche));
        Insert(valeur, S, J);
      end;
    end;
    result := S;
  end;

  function Traite(S: string): string;
  var
    i: integer;
  begin
    S := remplacer(S, '[GINKOIA]', Ginkoia);
    S := remplacer(S, '[ACTUEL]', PathOrdre);
    S := remplacer(S, '[EAI]', PathEAI);
    for i := 0 to lesVar.count - 1 do
    begin
      S := remplacer(S, lesVar[i], LesVal[i]);
    end;
    result := s;
  end;

  function PositionsurNoeuds(Placedunoeud: string): IXMLDOMNodeList;
  var
    i: Integer;
    ok: Boolean;
    SousNoeud: string;
  begin
    Xml.First;
    result := Xml.Get_CurrentNodeList;
    while (Placedunoeud <> '') do
    begin
      if Pos('/', Placedunoeud) > 0 then
      begin
        SousNoeud := Copy(Placedunoeud, 1, Pos('/', Placedunoeud) - 1);
        delete(Placedunoeud, 1, Pos('/', Placedunoeud));
      end
      else
      begin
        SousNoeud := Placedunoeud;
        Placedunoeud := '';
      end;
      i := 0;
      Ok := false;
      while i < result.Get_length do
      begin
        if result.Item[i].Get_nodeName = SousNoeud then
        begin
          result := result.Item[i].Get_childNodes;
          ok := true;
          BREAK;
        end;
        Inc(i);
      end;
      if not ok then
      begin
        Result := nil;
        BREAK;
      end;
    end;
  end;

  function TraiteVal(S: string): string;
  var
    Ordre: string;
    SSOrdre: string;
    PlaceduNoeud: string;
    Noeuds: IXMLDOMNodeList;
    NoeudFils: string;
    TAG: string;
    Place: string;
    reg: tregistry;
    Var1: string;
  begin
    result := '';
    if pos('=', S) > 0 then
    begin
      Ordre := Copy(S, 1, pos('=', S) - 1);
      delete(S, 1, pos('=', S));
      if Ordre = 'REGLIT' then
      begin
        SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
        delete(S, 1, pos(';', S));
        reg := tregistry.Create(Key_READ);
        try
          Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
          delete(SSOrdre, 1, pos('\', SSOrdre));
          if Var1 = 'HKEY_LOCAL_MACHINE\' then
            reg.RootKey := HKEY_LOCAL_MACHINE
          else if Var1 = 'HKEY_CLASSES_ROOT\' then
            reg.RootKey := HKEY_CLASSES_ROOT
          else if Var1 = 'HKEY_CURRENT_USER\' then
            reg.RootKey := HKEY_CURRENT_USER
          else if Var1 = 'HKEY_USERS\' then
            reg.RootKey := HKEY_USERS
          else if Var1 = 'HKEY_CURRENT_CONFIG\' then
            reg.RootKey := HKEY_CURRENT_CONFIG;
          if reg.OpenKey(SSOrdre, True) then
          begin
            S := traite(S);
            result := reg.ReadString(S);
            reg.closeKey;
          end;
        finally
          reg.free;
        end;
      end
      else if Ordre = 'POS' then
      begin
        SSOrdre := Copy(S, 1, Pos(';', S) - 1);
        delete(S, 1, Pos(';', S));
        S := traite(S);
        SSOrdre := traite(SSOrdre);
        result := Inttostr(Pos(SSOrdre, S));
      end
      else if Ordre = 'ADD' then
      begin
        SSOrdre := Copy(S, 1, Pos(';', S) - 1);
        delete(S, 1, Pos(';', S));
        S := traite(S);
        SSOrdre := traite(SSOrdre);
        result := Inttostr(StrToInt(S) + StrToInt(SSOrdre));
      end
      else if Ordre = 'COPY' then
      begin
        SSOrdre := Copy(S, 1, Pos(';', S) - 1);
        delete(S, 1, Pos(';', S));
        Place := Copy(S, 1, Pos(';', S) - 1);
        delete(S, 1, Pos(';', S));
        SSOrdre := traite(SSOrdre);
        S := Traite(S);
        Place := traite(Place);
        result := Copy(SSOrdre, StrToInt(Place), StrToInt(s));
      end
      else if Ordre = 'DELETE' then
      begin
        SSOrdre := Copy(S, 1, Pos(';', S) - 1);
        delete(S, 1, Pos(';', S));
        Place := Copy(S, 1, Pos(';', S) - 1);
        delete(S, 1, Pos(';', S));
        SSOrdre := traite(SSOrdre);
        Place := traite(Place);
        S := Traite(S);
        Delete(SSOrdre, StrToInt(Place), StrToInt(s));
        result := SSOrdre;
      end
      else if Ordre = 'CONCAT' then
      begin
        SSOrdre := Copy(S, 1, Pos(';', S) - 1);
        delete(S, 1, Pos(';', S));
        SSOrdre := traite(SSOrdre);
        S := Traite(S);
        result := SSOrdre + S;
      end
      else if Ordre = 'XML' then
      begin
        Xml.First;
        SSOrdre := Copy(S, 1, Pos(';', S) - 1);
        delete(S, 1, Pos(';', S));
        if SSOrdre = 'GETVALEUR' then
        begin
          result := ChercheVal(NoeudsEnCours.item[ValeurEnCours].Get_childNodes, S);
        end
        else if SSOrdre = 'EXISTES' then
        begin
          Placedunoeud := Copy(S, 1, Pos(';', S) - 1);
          delete(S, 1, Pos(';', S));
          Noeuds := PositionsurNoeuds(Placedunoeud);
          if Noeuds <> nil then
          begin
            NoeudFils := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            TAG := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            result := Inttostr(Existes(Noeuds, NoeudFils, Tag, Traite(S)));
          end;
        end
        else if SSOrdre = 'MINVALUE' then
        begin
          Placedunoeud := Copy(S, 1, Pos(';', S) - 1);
          delete(S, 1, Pos(';', S));
          Noeuds := PositionsurNoeuds(Placedunoeud);
          if Noeuds <> nil then
          begin
            NoeudFils := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            result := ChercheMinVal(Noeuds, NoeudFils, S);
          end;
        end
        else if SSOrdre = 'MAXVALUE' then
        begin
          Placedunoeud := Copy(S, 1, Pos(';', S) - 1);
          delete(S, 1, Pos(';', S));
          Noeuds := PositionsurNoeuds(Placedunoeud);
          if Noeuds <> nil then
          begin
            NoeudFils := Copy(S, 1, Pos(';', S) - 1);
            delete(S, 1, Pos(';', S));
            result := ChercheMaxVal(Noeuds, NoeudFils, S);
          end;
        end;
      end;
    end
    else
      result := S;
  end;

  function TraiteOrdre(Ordre: string; Valeur: string; I: Integer): Integer;
  var
    s: string;
    SSOrdre: string;
    j: Integer;
    Noeud: string;
    Place: Integer;
    Var1: string;
    Var2: string;

    SrvCmd, SrvNom, SrvPath : String;
    MonPathExtract: string;

    reg: tregistry;
    SrvItm : TServiceItem;
  begin
    if (ordre <> '') and (Ordre[1] <> ';') then
    begin
      S := Valeur;
      if ORDRE = 'REGADD' then
      begin
        SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
        delete(S, 1, pos(';', S));
        reg := tregistry.Create(Key_ALL_ACCESS);
        try
          Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
          delete(SSOrdre, 1, pos('\', SSOrdre));
          if Var1 = 'HKEY_LOCAL_MACHINE\' then
            reg.RootKey := HKEY_LOCAL_MACHINE
          else if Var1 = 'HKEY_CLASSES_ROOT\' then
            reg.RootKey := HKEY_CLASSES_ROOT
          else if Var1 = 'HKEY_CURRENT_USER\' then
            reg.RootKey := HKEY_CURRENT_USER
          else if Var1 = 'HKEY_USERS\' then
            reg.RootKey := HKEY_USERS
          else if Var1 = 'HKEY_CURRENT_CONFIG\' then
            reg.RootKey := HKEY_CURRENT_CONFIG;
          if reg.OpenKey(SSOrdre, True) then
          begin
            SSOrdre := traite(Copy(S, 1, Pos(';', S) - 1));
            delete(S, 1, pos(';', S));
            S := traite(S);
            reg.WriteString(SSOrdre, S);
            reg.closeKey;
          end;
        finally
          reg.free;
        end;
        inc(i);
      end
      else if ORDRE = 'REGSUP' then
      begin
        SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
        delete(S, 1, pos(';', S));
        reg := tregistry.Create(Key_ALL_ACCESS);
        try
          Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
          delete(SSOrdre, 1, pos('\', SSOrdre));
          if Var1 = 'HKEY_LOCAL_MACHINE\' then
            reg.RootKey := HKEY_LOCAL_MACHINE
          else if Var1 = 'HKEY_CLASSES_ROOT\' then
            reg.RootKey := HKEY_CLASSES_ROOT
          else if Var1 = 'HKEY_CURRENT_USER\' then
            reg.RootKey := HKEY_CURRENT_USER
          else if Var1 = 'HKEY_USERS\' then
            reg.RootKey := HKEY_USERS
          else if Var1 = 'HKEY_CURRENT_CONFIG\' then
            reg.RootKey := HKEY_CURRENT_CONFIG;
          if reg.OpenKey(SSOrdre, True) then
          begin
            S := traite(S);
            reg.DeleteValue(S);
            reg.closeKey;
          end;
        finally
          reg.free;
        end;
        inc(i);
      end
      else if ORDRE = 'REGSUPCLEF' then
      begin
        SSOrdre := Traite(Copy(S, 1, Pos(';', S) - 1));
        delete(S, 1, pos(';', S));
        reg := tregistry.Create(Key_ALL_ACCESS);
        try
          Var1 := Copy(SSOrdre, 1, pos('\', SSOrdre));
          delete(SSOrdre, 1, pos('\', SSOrdre));
          if Var1 = 'HKEY_LOCAL_MACHINE\' then
            reg.RootKey := HKEY_LOCAL_MACHINE
          else if Var1 = 'HKEY_CLASSES_ROOT\' then
            reg.RootKey := HKEY_CLASSES_ROOT
          else if Var1 = 'HKEY_CURRENT_USER\' then
            reg.RootKey := HKEY_CURRENT_USER
          else if Var1 = 'HKEY_USERS\' then
            reg.RootKey := HKEY_USERS
          else if Var1 = 'HKEY_CURRENT_CONFIG\' then
            reg.RootKey := HKEY_CURRENT_CONFIG;
          S := traite(S);
          reg.DeleteKey(S);
        finally
          reg.free;
        end;
        inc(i);
      end
      else if ORDRE = 'SUPDIR' then
      begin
        S := traite(S);
        Detruit(S);
        inc(i);
      end
      else if ORDRE = 'UNZIP' then
      begin
        S := traite(S);
        zip.ZipName := S;
        MonPathExtract := S;
        while pos('\', MonPathExtract) > 0 do
          delete(MonPathExtract, 1, pos('\', MonPathExtract));
        MonPathExtract := Ginkoia + 'LiveUpdate\' + ChangeFileExt(MonPathExtract, '') + '\';
        zip.DestDir := MonPathExtract;
        zip.unzip;
        inc(i);
      end
      else if ORDRE = 'COMMANDE' then
      begin
        S := traite(S);
        if Fileexists(S) then
        begin
          if not Traitement_BATCH(S) then
          begin
            result := 99999;
            EXIT;
          end;
        end;
        inc(i);
      end
      else if Ordre = 'CALL' then
      begin
        J := 0;
        while (j < tsl.count) and (tsl[j] <> 'BCL=' + S) do
          Inc(j);
        if j < tsl.count then
        begin
          LaPille.Add(Inttostr(i));
          i := J;
        end;
      end
      else if Ordre = 'RETURN' then
      begin
        if LaPille.count > 0 then
        begin
          S := LaPille[LaPille.Count - 1];
          LaPille.Delete(LaPille.Count - 1);
          I := StrToInt(S);
        end;
        inc(i);
      end
      else if ordre = 'TOUT_NOEUD' then
      begin
        if S = 'END' then
        begin
          if NoeudsEnCours <> nil then
          begin
            inc(ValeurEnCours);
            while (ValeurEnCours < NoeudsEnCours.Get_length) and
              (NoeudsEnCours.item[ValeurEnCours].Get_nodeName <> NoeudConcerne) do
              inc(ValeurEnCours);
            if ValeurEnCours >= NoeudsEnCours.Get_length then
              NoeudsEnCours := nil;
            if NoeudsEnCours <> nil then
            begin
              i := MarqueurNoeuds;
            end;
          end;
          Inc(i);
        end
        else
        begin
          SSOrdre := Copy(S, 1, Pos(';', S) - 1);
          delete(S, 1, pos(';', S));
          NoeudsEnCours := PositionsurNoeuds(SSOrdre);
          NoeudConcerne := S;
          MarqueurNoeuds := i;
          if NoeudsEnCours <> nil then
          begin
            ValeurEnCours := 0;
            while (ValeurEnCours < NoeudsEnCours.Get_length) and
              (NoeudsEnCours.item[ValeurEnCours].Get_nodeName <> NoeudConcerne) do
              inc(ValeurEnCours);
            if ValeurEnCours >= NoeudsEnCours.Get_length then
              NoeudsEnCours := nil;
          end;
          if NoeudsEnCours = nil then
          begin
            while tsl[i] <> 'TOUT_NOEUD=END' do
              Inc(i);
          end;
          inc(i);
        end;
      end
      else if ordre = 'RENAME' then
      begin
        SSOrdre := Copy(S, 1, Pos(';', S) - 1);
        delete(S, 1, pos(';', S));
        S := traite(S);
        SSOrdre := traite(SSOrdre);
        RenameFile(SSOrdre, S);
        Inc(i);
      end
        {
        ELSE IF ORDRE = 'SCRIPT' THEN
        BEGIN
            S := Traite(S);
            IbScript.Sql.Loadfromfile(S);
            IF NOT tran.InTransaction THEN
                tran.StartTransaction;
            IbScript.Execute;
            IF tran.InTransaction THEN
                tran.commit;
            Inc(i);
        END
        }
      else if ORDRE = 'EXECUTE' then
      begin
        S := Traite(S);
        Winexec(PChar(S), 0);
//        ShellExecute(0, 'open', PChar(s), '', nil, SW_SHOWNORMAL);
        inc(i);
      end
      else if ORDRE = 'STOP' then
      begin
        Lapplication := S;
        EnumWindows(@Enumerate, 0);
        Lapplication := S;
        EnumWindows(@Enumerate, 0);
        inc(i);
      end
      else if ORDRE = 'TIMEOUT' then
      begin
        timeout := true;
        temps := StrToInt(S);
        inc(i);
      end
      else if ORDRE = 'STOPTIMEOUT' then
      begin
        timeout := False;
        inc(i);
      end
      else if ORDRE = 'DELAY' then
      begin
        LeTemps := StrToInt(S);
        LeTemps := GetTickCount + LeTemps;
        while GetTickCount < LeTemps do
        begin
          Sleep(1000);
          Application.processMessages;
        end;
        inc(i);
      end
      else if ORDRE = 'SUPPRIME' then
      begin
        S := traite(S);
        FileSetAttr(Pchar(S), 0);
        DeleteFile(S);
        Inc(i);
      end
      else if ORDRE = 'ATTENTE' then
      begin
        SSOrdre := Copy(S, 1, Pos('=', S) - 1);
        delete(S, 1, pos('=', S));
        if SSOrdre = 'FIN' then
        begin
          LeTemps := GetTickCount + Temps;
          repeat
            AppliTourne := False;
            Lapplication := uppercase(S);
            EnumWindows(@Enumerate2, 0);
            if LeTimeOut then
            begin
              result := 99999;
              EXIT;
            end;
            Sleep(250);
          until not (AppliTourne);
        end
        else if SSOrdre = 'DEBUT' then
        begin
          LeTemps := GetTickCount + Temps;
          repeat
            AppliTourne := False;
            Lapplication := uppercase(S);
            EnumWindows(@Enumerate2, 0);
            if LeTimeOut then
            begin
              result := 99999;
              EXIT;
            end;
            sleep(250);
          until AppliTourne;
        end
        else if SSOrdre = 'FILEEXISTS' then
        begin
          S := traite(S);
          LeTemps := GetTickCount + Temps;
          while not Fileexists(S) do
          begin
            sleep(1000);
            if LeTimeOut then
            begin
              result := 99999;
              EXIT;
            end;
          end;
        end
        else if SSOrdre = 'MAPSTART' then
        begin
          S := uppercase(s);
          if S = 'GINKOIA' then
          begin
            LeTemps := GetTickCount + Temps;
            while not MapGinkoia.Ginkoia do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'CAISSE' then
          begin
            LeTemps := GetTickCount + Temps;
            while not MapGinkoia.Caisse do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'LAUNCHER' then
          begin
            LeTemps := GetTickCount + Temps;
            while not MapGinkoia.Launcher do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'BACKUP' then
          begin
            LeTemps := GetTickCount + Temps;
            while not MapGinkoia.Backup do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'LIVEUPDATE' then
          begin
            LeTemps := GetTickCount + Temps;
            while not MapGinkoia.LiveUpdate do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'MAJAUTO' then
          begin
            LeTemps := GetTickCount + Temps;
            while not MapGinkoia.MajAuto do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'PARAMGINKOIA' then
          begin
            LeTemps := GetTickCount + Temps;
            while not MapGinkoia.ParamGinkoia do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'PING' then
          begin
            LeTemps := GetTickCount + Temps;
            while not MapGinkoia.Ping do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'PINGSTOP' then
          begin
            LeTemps := GetTickCount + Temps;
            while not MapGinkoia.PingStop do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'SCRIPT' then
          begin
            LeTemps := GetTickCount + Temps;
            while not MapGinkoia.Script do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'SCRIPTOK' then
          begin
            LeTemps := GetTickCount + Temps;
            while not MapGinkoia.ScriptOK do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end;
        end
        else if SSOrdre = 'MAPSTOP' then
        begin
          S := uppercase(s);
          if S = 'GINKOIA' then
          begin
            LeTemps := GetTickCount + Temps;
            while MapGinkoia.Ginkoia do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'CAISSE' then
          begin
            LeTemps := GetTickCount + Temps;
            while MapGinkoia.Caisse do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'LAUNCHER' then
          begin
            LeTemps := GetTickCount + Temps;
            while MapGinkoia.Launcher do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'BACKUP' then
          begin
            LeTemps := GetTickCount + Temps;
            while MapGinkoia.Backup do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'LIVEUPDATE' then
          begin
            LeTemps := GetTickCount + Temps;
            while MapGinkoia.LiveUpdate do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'MAJAUTO' then
          begin
            LeTemps := GetTickCount + Temps;
            while MapGinkoia.MajAuto do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'PARAMGINKOIA' then
          begin
            LeTemps := GetTickCount + Temps;
            while MapGinkoia.ParamGinkoia do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'PING' then
          begin
            LeTemps := GetTickCount + Temps;
            while MapGinkoia.Ping do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'PINGSTOP' then
          begin
            LeTemps := GetTickCount + Temps;
            while MapGinkoia.PingStop do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'SCRIPT' then
          begin
            LeTemps := GetTickCount + Temps;
            while MapGinkoia.Script do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end
          else if S = 'SCRIPTOK' then
          begin
            LeTemps := GetTickCount + Temps;
            while MapGinkoia.ScriptOK do
            begin
              sleep(1000);
              if LeTimeOut then
              begin
                result := 99999;
                EXIT;
              end;
            end;
          end;
        end;
        Inc(i);
      end
      else if Ordre = 'TOUT_EAI' then
      begin
        ssOrdre := S;
        if ssOrdre = 'BEGIN' then
        begin
          MarqueurEai := i;
          EaiEnCours := 0;
          PathEAI := LesEai[EaiEnCours];
        end
        else if ssOrdre = 'END' then
        begin
          inc(EaiEnCours);
          if EaiEnCours < LesEai.Count then
          begin
            PathEAI := LesEai[EaiEnCours];
            i := MarqueurEai;
          end;
        end;
        inc(i);
      end
      else if ordre = 'XML' then
      begin
        ssOrdre := Copy(S, 1, Pos(';', S) - 1);
        delete(S, 1, Pos(';', S));
        if ssOrdre = 'SETVALEUR' then
        begin
          Noeud := Copy(S, 1, Pos(';', S) - 1);
          delete(S, 1, Pos(';', S));
          Noeud := traite(Noeud);
          S := traite(S);
          RemplaceVal(NoeudsEnCours.item[ValeurEnCours].Get_childNodes, Noeud, S);
        end
        else if ssOrdre = 'LOAD' then
        begin
          PassTsl := TstringList.Create;
          if log <> nil then
          begin
            AddToLogs('Load XML ' + Traite(S));
            
          end;
          PassTsl.loadFromFile(Traite(S));
          if log <> nil then
          begin
            AddToLogs('Parsing de ' + Traite(S));
            
          end;
          Xml.LoadXML(PassTsl.Text);
          if log <> nil then
          begin
            AddToLogs('Parsing OK ');
            
          end;
          NoeudsEnCours := XML.Get_CurrentNodeList;
        end
        else if ssOrdre = 'SAVE' then
        begin
          xml.Save(traite(s));
        end
        else if ssOrdre = 'ADD' then
        begin
          Xml.First;
          Noeud := Copy(S, 1, Pos(';', S) - 1);
          delete(S, 1, Pos(';', S));
          Place := StrtoInt(traite(Copy(S, 1, Pos(';', S) - 1)));
          delete(S, 1, Pos(';', S));
          S := Traite(S);
          AjouteNoeud(Xml, Noeud, Place, S);
        end;
        inc(i)
      end
      else if ordre = 'GOTO' then
      begin
        j := 0;
        while j < tsl.count do
        begin
          if Uppercase(tsl.Names[j]) = 'BCL' then
          begin
            SSOrdre := Copy(tsl[j], Pos('=', tsl[j]) + 1, Length(tsl[j]));
            if SSOrdre = S then
            begin
              I := J;
              BREAK;
            end;
          end;
          Inc(j);
        end;
        Inc(i);
      end
      else if Copy(Ordre, 1, 2) = '$$' then
      begin
        // Variable ;
        j := LesVar.IndexOf(Ordre);
        if j = -1 then
        begin
          J := LesVar.Add(Ordre);
          LesVal.Add('');
        end;
        LesVal[j] := TraiteVal(S);
        Inc(i);
      end
      else if Ordre = 'SI' then
      begin
        SSOrdre := Copy(S, 1, Pos(')', S));
        Delete(S, 1, Pos(')', S));
        Delete(S, 1, Pos(';', S));
        if Copy(SSOrdre, 1, Pos('(', SSOrdre)) = 'DIFF(' then
        begin
          delete(SSOrdre, 1, Pos('(', SSOrdre));
          Var1 := Copy(SSOrdre, 1, Pos(';', SSOrdre) - 1);
          delete(SSOrdre, 1, Pos(';', SSOrdre));
          Var2 := Copy(SSOrdre, 1, Pos(')', SSOrdre) - 1);
          if Copy(var1, 1, 2) = '$$' then
            Var1 := Traite(Var1);
          if Copy(var2, 1, 2) = '$$' then
            Var2 := Traite(Var2);
          if Var1 <> var2 then
          begin
            Ordre := Copy(S, 1, pos('=', S) - 1);
            delete(S, 1, Pos('=', S));
            I := TraiteOrdre(Ordre, S, i);
          end
          else
            Inc(i);
        end
        else if Copy(SSOrdre, 1, Pos('(', SSOrdre)) = 'EGAL(' then
        begin
          delete(SSOrdre, 1, Pos('(', SSOrdre));
          Var1 := Copy(SSOrdre, 1, Pos(';', SSOrdre) - 1);
          delete(SSOrdre, 1, Pos(';', SSOrdre));
          Var2 := Copy(SSOrdre, 1, Pos(')', SSOrdre) - 1);
          if Copy(var1, 1, 2) = '$$' then
            Var1 := Traite(Var1);
          if Copy(var2, 1, 2) = '$$' then
            Var2 := Traite(Var2);
          if Var1 = var2 then
          begin
            Ordre := Copy(S, 1, pos('=', S) - 1);
            delete(S, 1, Pos('=', S));
            I := TraiteOrdre(Ordre, S, i);
          end
          else
            Inc(i);
        end;
      end
      else if Ordre = 'SERVICE' then
      begin
        SrvCmd := Copy(S, pos('=', S) + 1, (pos(' ', S) - pos('=', S)-1));
        SrvNom := Copy(S, pos(' ', S) + 1, length(S));
        if Pos('"', SrvNom) > 0 then
        begin
          S := Traite(S);
          SrvNom := Copy(S, pos(' ', S) + 1, (pos('"', S) - pos(' ', S)-2));
          SrvPath := Copy(S, pos('"', S), length(S));
          SrvPath := StringReplace(SrvPath,'"','',[rfReplaceAll]);
        end
        else
          SrvPath := '';

        SrvItm := TServiceItem.Create(onLog);
        try
          SrvItm.Nom := SrvNom; // nom du service
          SrvItm.Path := SrvPath; // path + exe
          SrvItm.doRefreshState;
          SrvItm.TimeOut := 10; //10s
          if SrvCmd = 'Install' then
            SrvItm.doInstall
          else if SrvCmd = 'Uninstall' then
            SrvItm.doUninstall
          else if SrvCmd = 'Start' then
            SrvItm.doStart
          else if SrvCmd = 'Stop' then
            SrvItm.doStop;
        finally
          SrvItm.free;
        end;
        inc(i);
      end
      else
      begin
        inc(i);
      end;
    end
    else
      inc(i);
    result := i;
  end;

begin
  data.DatabaseName := BasePrinc;
  IBQue_Base.Open;
  LesEai := TstringList.Create;
  Les_BD.paramByName('BASID').AsString := IBQue_BaseBAS_ID.AsString;
  Les_BD.Open;
  while not Les_BD.Eof do
  begin
    LesEai.Add(Les_BDREP_PLACEEAI.AsString);
    Les_BD.next;
  end;
  Les_BD.Close;
  IBQue_Base.close;
  data.close;

  Tsl := TstringList.Create;
  LesVar := TstringList.Create;
  LesVal := TstringList.Create;
  LaPille := TstringList.Create;
  XML := TMonXML2.Create;

  if log <> nil then
  begin
    AddToLogs('Ouverture de ' + LeFichier);
    
  end;
  tsl.LoadFromFile(LeFichier);
  i := 0;
  TimeOut := false;
  PathOrdre := IncludeTrailingBackslash(ExtractFilePath(LeFichier));
  Temps := 0;

  MarqueurEai := -1;
  MarqueurNoeuds := -1;

  setPhase('Traitement des batchs',80) ;

  while i < tsl.count do
  begin
    Ordre := Uppercase(trim(tsl.Names[i]));
    if log <> nil then
    begin
      AddToLogs('Execute ' + tsl[i]);
      
    end;

    setDetail('', Round(i / tsl.Count * 100)) ;

    S := trim(Copy(tsl[i], Pos('=', tsl[i]) + 1, Length(tsl[i])));
    i := TraiteOrdre(Ordre, S, i);
  end;

  AddToLogs('Fin du fichier ');

  result := i <> 99999;
  XML.free;
  LesVar.free;
  LesVal.free;
  Tsl.free;
  LaPille.free;
  leseai.free;
end;

procedure TFrm_Verification.AddToLogs(aMsg: string; aLvl : TLogLevel = logInfo);
begin
  Log.Log('Verification', 'Log', aMsg, aLvl, false, -1, ltLocal) ;
end;

procedure TFrm_Verification.AddToLogsAndMonitoring(aMdl, aKey, aVal: string; aLvl: TLogLevel);
begin
  Log.Log(aMdl, aKey, aVal, aLvl, false, -1, ltBoth) ;
end;

procedure TFrm_Verification.AjouteNoeud(Xml: TMonXML2; Noeud: string; Place: Integer; Valeur: string);
var
  Actu: string;
  S: string;
  Node: IXMLDOMNode;
  ok: Boolean;
  NodeAjout: TMonXml2;
  i: Integer;
begin
  NodeAjout := TMonXml2.Create;
  try
    NodeAjout.LoadXML(Valeur);
    NodeAjout.First;
    S := Noeud;
    if Pos('/', S) > 0 then
    begin
      Actu := Copy(S, 1, Pos('/', S) - 1);
      delete(S, 1, Pos('/', S));
    end
    else
    begin
      Actu := S;
      S := '';
    end;
    Xml.First;
    while not Xml.EOF do
    begin
      if Xml.Get_CurrentNode.Get_nodeName = Actu then
      begin
        Node := xml.Get_CurrentNode;
        ok := true;
        while (S <> '') and ok do
        begin
          if Pos('/', S) > 0 then
          begin
            Actu := Copy(S, 1, Pos('/', S) - 1);
            delete(S, 1, Pos('/', S));
          end
          else
          begin
            Actu := S;
            S := '';
          end;
          ok := false;
          for i := 0 to Node.childNodes.length - 1 do
          begin
            if Node.childNodes.Item[i].Get_nodeName = Actu then
            begin
              Ok := true;
              Node := Node.childNodes.Item[i];
              BREAK;
            end;
          end;
        end;
        if ok then
        begin
          // Mon Node contient le Noeud en question
          if Place <= 0 then
          begin
            Node.insertBefore(NodeAjout.Get_CurrentNode, Node.childNodes.Item[0]);
          end
          else if Place >= Node.childNodes.Get_length then
          begin
            Node.appendChild(NodeAjout.Get_CurrentNode);
          end
          else
          begin
            Node.insertBefore(NodeAjout.Get_CurrentNode, Node.childNodes.Item[Place - 1]);
          end;
        end;
        BREAK;
      end;
      Xml.Next;
    end;
  finally
    NodeAjout.free;
  end;
end;

function TFrm_Verification.ChercheMaxVal(Noeuds: IXMLDOMNodeList; NoeudFils, TAG: string): string;
var
  i: integer;
  S: string;
  d, d1: double;
  code: Integer;
begin
  result := '';
  for i := 0 to Noeuds.Get_length - 1 do
  begin
    if Noeuds.item[i].Get_nodeName = NoeudFils then
    begin
      S := ChercheVal(Noeuds.item[i].childNodes, Tag);
      if result = '' then
        result := S
      else if (S <> '') then
      begin
        Val(S, D, Code);
        d1 := 0;
        if code = 0 then
          Val(result, D1, Code);
        if code = 0 then
        begin
          if d1 < d then
            result := S;
        end
        else
        begin
          if (result < S) then
            result := S;
        end;
      end;
    end;
  end;
end;

function TFrm_Verification.ChercheMinVal(Noeuds: IXMLDOMNodeList; NoeudFils, TAG: string): string;
var
  i: integer;
  S: string;
  code: Integer;
  D, d1: Double;
begin
  result := '';
  for i := 0 to Noeuds.Get_length - 1 do
  begin
    if Noeuds.item[i].Get_nodeName = NoeudFils then
    begin
      S := ChercheVal(Noeuds.item[i].childNodes, Tag);
      if result = '' then
        result := S
      else if (S <> '') then
      begin
        Val(S, D, Code);
        d1 := 0;
        if code = 0 then
          Val(result, D1, Code);
        if code = 0 then
        begin
          if d1 > d then
            result := S;
        end
        else
        begin
          if (result > S) then
            result := S;
        end;
      end;
    end;
  end;
end;

function TFrm_Verification.ChercheVal(Noeuds: IXMLDOMNodeList; TAG: string): string;
var
  i: integer;
begin
  result := '';
  for i := 0 to Noeuds.Get_length - 1 do
  begin
    if Noeuds.item[i].Get_nodeName = Tag then
    begin
      if Noeuds.item[i].childNodes.Get_length < 1 then
        result := ''
      else if Noeuds.item[i].childNodes.item[0].Get_nodeValue <> Null then
        result := Noeuds.item[i].childNodes.item[0].Get_nodeValue;
      BREAK;
    end;
  end;
end;

function TFrm_Verification.Existe(Noeuds: IXMLDOMNodeList; TAG, Valeur: string): Boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to Noeuds.Get_length - 1 do
  begin
    if Noeuds.item[i].Get_nodeName = Tag then
    begin
      if Noeuds.item[i].childNodes.item[0].Get_nodeValue = Valeur then
        result := true;
      BREAK;
    end;
  end;
end;

function TFrm_Verification.Existes(Noeuds: IXMLDOMNodeList; NoeudFils, TAG, Valeur: string): Integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Noeuds.Get_length - 1 do
  begin
    if Noeuds.item[i].Get_nodeName = NoeudFils then
    begin
      if Existe(Noeuds.item[i].childNodes, Tag, Valeur) then
      begin
        result := I + 1;
        BREAK;
      end;
    end;
  end;
end;

procedure TFrm_Verification.RemplaceVal(Noeuds: IXMLDOMNodeList; TAG, Valeur: string);
var
  i: integer;
begin
  for i := 0 to Noeuds.Get_length - 1 do
  begin
    if Noeuds.item[i].Get_nodeName = Tag then
    begin
      if Noeuds.item[i].childNodes.Get_length = 0 then
        Noeuds.item[i].Set_text(Valeur)
      else
        Noeuds.item[i].childNodes.item[0].Set_nodeValue(Valeur);
      BREAK;
    end;
  end;
end;

function TFrm_Verification.NetoyageDesConneriesAStan(test: boolean): boolean;
var
  F: Tsearchrec;
begin
  result := false;
  try
    if FindFirst(ginkoia + '*.bpl', faanyfile, f) = 0 then
    begin
      repeat
        if (f.name <> '.') and (f.name <> '..') then
        begin
          if (f.Attr and faDirectory = 0) and (uppercase(Extractfileext(f.Name)) = '.BPL') then
          begin
            result := true;
            if test then
              BREAK;
            fileSetAttr(ginkoia + f.Name, 0);
            deletefile(ginkoia + f.Name);
          end;
        end;
      until findnext(f) <> 0;
    end;
    findclose(f);
  except
  end;
end;

procedure TFrm_Verification.onLog(Sender: TObject; aMsg: string);
begin
  AddToLogs(aMsg);
end;

procedure TFrm_Verification.verification_des_batch;
var
  S: string;
  S1: string;
  S2, S3, S4: string;
  SS: string;
  i: integer;
  F: TSearchRec;
  tsl: tstringlist;
  prem: boolean;
begin
  try
    S := ExtractFileDrive(paramstr(0));
    S := Copy(S, 1, 1) + ':\GINKOIA\BATCH\';
    if FindFirst(S + '*.bat', faanyfile, f) = 0 then
    begin
      repeat
        if Uppercase(extractfileext(F.Name)) = '.BAT' then
        begin
          fileSetAttr(S + f.Name, 0);
          tsl := tstringlist.Create;
          tsl.LoadFromFile(S + f.Name);

          prem := true;
          SS := '';
          for i := 0 to tsl.count - 1 do
          begin
            S1 := tsl[i];
            if prem and (Pos('CMDSYNC.EXE', Uppercase(S1)) > 0) then
            begin
              prem := false;
              // découpon en 4 partie
              S2 := Copy(S1, 1, Pos('CMDSYNC.EXE', Uppercase(S1)) + 11);
              // s2 -> \\serveur\c\ginkoia\filesync\cmdsync.exe
              delete(S1, 1, Pos('CMDSYNC.EXE', Uppercase(S1)) + 11);
              S3 := trim(Copy(S1, 1, Pos(' ', S1)));
              // S3 -> "\\serveur\c\ginkoia\bpl"
              Delete(S1, 1, Pos(' ', S1));
              S4 := trim(Copy(S1, 1, Pos(' ', S1)));
              // S4 -> "*.*"
              Delete(S1, 1, Pos(' ', S1));
              // S1 = "d:\ginkoia\bpl" /S
              if pos('/S', S1) > 0 then
                S1 := trim(Copy(S1, 1, pos('/S', S1) - 1));
              if pos('/D', S1) > 0 then
                S1 := trim(Copy(S1, 1, pos('/D', S1) - 1));
              // S1 = "d:\ginkoia\bpl"
              SS := trim(S2) + ' ';
              // SS -> \\serveur\c\ginkoia\filesync\cmdsync.exe
              while pos('"', S3) > 0 do
                delete(S3, pos('"', S3), 1);
              S3 := Uppercase(S3);
              S3 := Copy(S3, 1, pos('GINKOIA', S3) + 6);
              S3 := S3 + '\DOCUMENTS';
              SS := SS + '"' + S3 + '" "*.*" ';
              // SS -> \\serveur\c\ginkoia\filesync\cmdsync.exe "\\serveur\c\ginkoia\images" "*.*"
              S3 := Uppercase(S1);
              while pos('"', S3) > 0 do
                delete(S3, pos('"', S3), 1);
              S3 := Copy(S3, 1, pos('GINKOIA', S3) + 6);
              S3 := S3 + '\DOCUMENTS';
              SS := SS + '"' + S3 + '" /D';
              // SS -> \\serveur\c\ginkoia\filesync\cmdsync.exe "\\serveur\c\ginkoia\images" "*.*" "d:\ginkoia\images" /S
            end;
            if pos('DOCUMENTS', Uppercase(TSL[I])) > 0 then
            begin
              SS := '';
              BREAK;
            end;
          end;
          if ss <> '' then
            tsl.insert(2, SS);

          // doit on ajouter la ligne ?
          if pos('\GINKOIA" "*.DLL" ', UpperCase(tsl.text)) < 1 then
          begin
            for i := 0 to tsl.Count -1 do
            begin
              if Pos('\GINKOIA" "*.EXE" ', UpperCase(tsl[i])) > 0 then
              begin
                tsl.Insert(i +1, '');
                tsl.Insert(i +2, StringReplace(tsl[i], '"*.exe"', '"*.dll"', [rfIgnoreCase]));
                break;
              end;
            end;
          end;

          // Correction des conneries du Deploy
          for i := 0 to tsl.count - 1 do
          begin
            S1 := tsl[i];
            if (Pos('CMDSYNC.EXE', Uppercase(S1)) > 0) then
            begin
              if (Pos('\GINKOIA\DATA', Uppercase(S1)) > 0) then
              begin
                tsl[i] := StringReplace(tsl[i], '\GINKOIA\DATA', '\GINKOIA', [rfIgnoreCase]) ;
              end;
            end;
          end;

          Filesetattr(S + f.Name, 0);
          try
            tsl.SaveToFile(S + f.Name);
          except
          end;
          tsl.free;
        end;
      until findnext(f) <> 0
    end;
    findclose(f);
  except
  end;
end;

procedure TFrm_Verification.Fait_un_alg(le_alg: string);
var
  s: string;
//  log: tstringlist;
begin
  lbTitre.Caption := 'Passage d''ALG' ;

//  s := changefileext(le_alg, '.log');
//  log := tstringlist.create;
  Traitement_BATCH(le_alg);
  
//  log.free;
end;

procedure TFrm_Verification.Fait_un_zip(le_zip: string);
var
  F: TSearchRec;
//  s: string;
//  log: tstringlist;
begin
  zip.DestDir := Ginkoia + 'LiveUpdate\' + ChangeFileExt(extractfilename(le_zip), '') + '\';
  zip.ZipName := le_zip;
  zip.unzip;
//  s := changefileext(le_zip, '.log');
//  log := tstringlist.create;
  if findfirst(Ginkoia + 'LiveUpdate\' + ChangeFileExt(extractfilename(le_zip), '') + '\*.alg', faAnyFile, f) = 0 then
    Traitement_BATCH(Ginkoia + 'LiveUpdate\' + ChangeFileExt(extractfilename(le_zip), '') + '\' + f.Name);
  findclose(f);

//  log.free;
end;

function TFrm_Verification.DownloadSpecifique(Yellis : Tconnexion; IdClt : string) : boolean;
var
  Resultat : TStringList;
  aMajFile : TStringList;
  i : integer;
  FileName : string;
begin
  result := false;
  Resultat := nil;
  aMajFile := nil;

  // vérification des spécifiques
  try
    Resultat := Yellis.select('select * from specifique where spe_fait = 0 and spe_cltid = ' + IdClt);
    if Yellis.recordCount(Resultat) > 0 then
    begin
      try
        aMajFile := TStringList.Create();
        AddToLogs('Récupération des fichier A_MAJ\LIVEUPDATE');

        for i := 0 to Yellis.recordCount(Resultat) - 1 do
        begin
          // récupération du fichier dans A_MAJ\LIVEUPDATE
          FileName := Yellis.UneValeur(Resultat, 'spe_fichier', i);
          if DownloadFmt( 'http://%s/maj/%s', [ FUrlUpdate, FileName ], '%sLIVEUPDATE\%s', [ GINKOIA, FileName ] ) then
          begin
            aMajFile.add(GINKOIA + 'liveupdate\' + FileName);
            aMajFile.savetofile(GINKOIA + 'liveupdate\amaj.txt');

            // Si on est sur le nouveau système de mise à jour, on ne met pas à jour Yellis
            if not (FNewMaj) then
              Yellis.ordre('update specifique set spe_fait = 1, spe_date = "' + Yellis.DateTime(now) + '" where spe_id = ' + Yellis.UneValeur(Resultat, 'spe_id', i));

            AddToLogs(FileName + ' - OK');
          end
          else
            AddToLogs(FileName + ' - ECHEC');
        end;
      finally
        FreeAndNil(aMajFile);
      end;
    end;
  finally
    Yellis.FreeResult(Resultat);
  end;
end;

end.

