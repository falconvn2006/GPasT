//$Log:
// 30   Utilitaires1.29        16/01/2019 11:37:39    Ludovic MASSE   ajout log
//      + nettoyage du fichier de log de version (ex :
//      LOGV18.1.0.1-VT18.3.0.1.Log)
// 29   Utilitaires1.28        10/12/2018 15:53:31    Ludovic MASSE  
//      v13.2.5.15 : correction lancemnt launcher easy, pas auto loggon non
//      bloquant, si easy pas de check des provider, nettoyage repertoire
// 28   Utilitaires1.27        20/11/2018 17:49:42    Ludovic MASSE   GinVer
//      v13.2.5.14
//      Verification v13.2.8.9
//      remont? du num?ro de version au monitoring
// 27   Utilitaires1.26        14/11/2018 12:31:41    Ludovic MASSE  
//      changement de mail
// 26   Utilitaires1.25        14/11/2018 12:09:10    Ludovic MASSE   ajout
//      nouveau mail + modif ancien mail + niveau max de l'uac descendu de 3 a
//      1
// 25   Utilitaires1.24        08/11/2018 11:22:37    Ludovic MASSE  
//      am?lioration pour ne plus perdre de base ou avoir des base corrompue
// 24   Utilitaires1.23        23/08/2018 15:46:55    Ludovic MASSE   13.2.3.14
//      : ajout cl? registre pour d?marrer en admin + nouvelle gestion du
//      uServiceManager pour EASY
// 23   Utilitaires1.22        06/07/2018 15:46:41    Python Benoit  
//      v13.2.8.16 : Ajout de la gestion des nom sans "patch"
// 22   Utilitaires1.21        26/09/2017 14:16:51    Ludovic MASSE   v13.2.4.3
//      - kill d'exe lors de l'echec d'une copie et recopie
// 21   Utilitaires1.20        21/09/2017 16:36:17    Ludovic MASSE   v13.2.4.1
//      - allongement timer d'avant arr?t des service, si l'arret ?choue on
//      kill l'exe
// 20   Utilitaires1.19        06/09/2017 13:40:16    Ludovic MASSE   CDC ?
//      SERVICES ? ARRET ET REDEMARRAGE
// 19   Utilitaires1.18        16/11/2016 15:39:14    Ludovic MASSE   CDC ?
//      SERVICES ? ARRET ET REDEMARRAGE
// 18   Utilitaires1.17        13/09/2016 10:36:13    Ludovic MASSE   CDC -
//      DEMENAGEMENT DE YELLIS
// 17   Utilitaires1.16        16/04/2015 10:48:10    Florian Louis   Arr?t et
//      red?marrage du service Mobilit? et BI pour Verification et Patch
// 16   Utilitaires1.15        11/03/2015 16:42:27    Florian Louis  
//      Deploiement Mobilit?
//      - Ajout de l'arret et du red?marrage du service mobilit? si besoin de
//      mise a jour.
// 15   Utilitaires1.14        03/12/2014 17:05:59    Florian Louis   -
//      Liberation du mapping MAJAuto en fin de Patch
// 14   Utilitaires1.13        12/11/2014 10:39:50    Python Benoit  
//      Correction Patch / Verification
// 13   Utilitaires1.12        06/11/2014 12:22:27    Python Benoit   Correction
// 12   Utilitaires1.11        27/10/2014 10:17:41    Python Benoit   Ajout
//      reboot a la fin de la migration.
// 11   Utilitaires1.10        01/07/2014 14:35:33    Python Benoit  
//      Utilisation de la bonne boite mail
//      Utilisation de constante pour l'url
//      Message si pas de GUID
// 10   Utilitaires1.9         03/06/2014 16:23:54    Python Benoit  
//      Correction sur la recup?ration des infos bases
// 9    Utilitaires1.8         14/04/2014 11:01:40    Python Benoit  
//      Modification dans Patch.exe
//      - Gestion des erreur, et code retour des fonctions de verification
//      - Recup des information de la base pour les emails
//      - Meilleur gestion des mail d'erreur
//      - Pas de passages des patch apres maj en 11.3 (attente du changement de
//      moteur)
// 8    Utilitaires1.7         03/04/2014 10:21:15    Python Benoit  
//      Correction dans patch.
//      Log, Reboot, gestion des services, ...
// 7    Utilitaires1.6         14/03/2014 15:17:43    Python Benoit   Meilleur
//      gestion des service
//      Envoi de mail
// 6    Utilitaires1.5         11/10/2013 11:42:25    Gr?gory BEN HAMZA Ajout
//      de logs.
//      Mise en commentaire du nouveau calcul du CRC(Rev.5) au profit de
//      l'ancien en attendant d'approfondir les tests (probl?me de lenteur cf.
//      Stan).
// 5    Utilitaires1.4         17/09/2013 11:43:20    Thierry Fleisch Patch.exe
//      Version 13.2.0.1 : 
//      - Ajout de la gestion du num?ro de version dans la barre du programme
//      - Remplacement de l'ancien CRC32 par le nouveau par Indy
//      V?rification Version 13.2.0.3 : 
//      - Remplacement de l'ancien CRC32 par le nouveau par Indy
// 4    Utilitaires1.3         16/09/2013 16:02:57    Gr?gory BEN HAMZA Prise
//      en charge de Interbase XE
// 3    Utilitaires1.2         29/08/2013 16:40:40    Python Benoit  
//      Modification de patch.exe pour lancer migrev13.exe
// 2    Utilitaires1.1         09/08/2013 09:28:25    Thierry Fleisch Ajout de
//      l'arr?t et du d?marrage du service d'impression
// 1    Utilitaires1.0         01/10/2012 16:06:34    Loic G          
//$
//$NoKeywords$
//

unit UGinkoiaMAJ;

interface

uses
  RASAPI,
  UVerification,
  XMLCursor,
  StdXML_TLB,
  MSXML2_TLB,
  registry,
  UMapping,
  WinSvc,
  CstLaunch,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  DFClasses,
  Buttons,
  RzLabel,
  ArtLabel,
  Db,
  IBDatabase,
  IBCustomDataSet,
  IBQuery,
  ExtCtrls,
  Variants,
  TlHelp32,
  uSevenZip,
  IdHashCrc,
  Idglobal,
  ShellApi,
  uToolsXE,
  IBServices,
  uVersion,
  uServicesManager,
  uLog;

type
  TWVersion = (wvUnknown, wvWOld, wvW2k, wvWXP, wvWXPP64, wvW2k3, wvWVista, wvW7, wvNewVersion);

  TMonXML = class(TXMLCursor)
  end;

  TFrm_Patch = class(TForm)
    pc: TPageControl;
    INST: TTabSheet;
    Pb2: TProgressBar;
    Lab_Fichier: TLabel;
    Pb1: TProgressBar;
    Lab_Etat: TLabel;
    PRES: TTabSheet;
    ArtLabel1: TLabel;
    RzLabel1: TRzLabel;
    Bout2: TBitBtn;
    VERIF1: TTabSheet;
    RzLabel2: TRzLabel;
    ArtLabel2: TLabel;
    Bout3: TBitBtn;
    Que_Version: TIBQuery;
    Que_VersionVER_VERSION: TIBStringField;
    IBQue_EAI: TIBQuery;
    IBQue_EAIREP_PLACEEAI: TIBStringField;
    tran: TIBTransaction;
    data: TIBDatabase;
    ERRVER: TTabSheet;
    ArtLabel3: TLabel;
    RzLabel3: TRzLabel;
    Bout4: TBitBtn;
    ERRCONN: TTabSheet;
    Bout5: TBitBtn;
    RzLabel4: TRzLabel;
    ArtLabel4: TLabel;
    RzLabel5: TRzLabel;
    Pb_1: TProgressBar;
    Fic: TLabel;
    pb_2: TProgressBar;
    ERRVALID: TTabSheet;
    ArtLabel5: TLabel;
    RzLabel6: TRzLabel;
    Bout6: TBitBtn;
    RzLabel7: TRzLabel;
    Bout1: TBitBtn;
    ArtLabel6: TLabel;
    RzLabel8: TRzLabel;
    RzLabel9: TRzLabel;
    RETSTABLE: TTabSheet;
    ArtLabel7: TLabel;
    RzLabel10: TRzLabel;
    Bout7: TBitBtn;
    Bout8: TBitBtn;
    RzLabel11: TRzLabel;
    Label1: TLabel;
    FINOK: TTabSheet;
    FINNOK: TTabSheet;
    ArtLabel8: TLabel;
    RzLabel12: TRzLabel;
    Bout9: TBitBtn;
    ArtLabel9: TLabel;
    RzLabel13: TRzLabel;
    Bout10: TBitBtn;
    PROBBCK: TTabSheet;
    ArtLabel10: TLabel;
    RzLabel14: TRzLabel;
    Bout11: TBitBtn;
    Que_Sql: TIBQuery;
    PROBAUTONO: TTabSheet;
    ArtLabel11: TLabel;
    RzLabel15: TRzLabel;
    Bout12: TBitBtn;
    FINCAISSE: TTabSheet;
    RzLabel16: TRzLabel;
    ArtLabel12: TLabel;
    Bout13: TBitBtn;
    RzLabel17: TRzLabel;
    RzLabel18: TRzLabel;
    Tim_Auto: TTimer;
    IB_Connexion: TIBQuery;
    IB_ConnexionCON_ID: TIntegerField;
    IB_ConnexionCON_LAUID: TIntegerField;
    IB_ConnexionCON_NOM: TIBStringField;
    IB_ConnexionCON_TEL: TIBStringField;
    IB_ConnexionCON_TYPE: TIntegerField;
    IB_ConnexionCON_ORDRE: TIntegerField;
    IBConfigService: TIBConfigService;
    que_Tmp: TIBQuery;

    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);

    procedure Bout2Click(Sender: TObject);
    procedure Bout3Click(Sender: TObject);
    procedure Bout5Click(Sender: TObject);
    procedure Bout1Click(Sender: TObject);
    procedure Bout8Click(Sender: TObject);
    procedure fermerClick(Sender: TObject);
    procedure Tim_AutoTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dataBeforeConnect(Sender: TObject);
  private
    { Déclarations privées }
    automatique: boolean;
    Labase: string;
    Ginkoia: string;
    FichierEnCours: string;
    CRCSauve: string;
    AncVersion: string;
    AncNumero: string;
    NvlVersion: string;
    NvlNumero: string;
    VersionEnCours: string;
    LesEai: TstringList;
    LeNomLog: string;

    First: Boolean;
    doclose: Boolean;
    CaisseAutonome: Boolean;
    ListeConnexion: Tlist;
    Connectionencours: TLesConnexion;

    FnewCRC: boolean;

    FHasInfoBase : boolean;
    FCentrale, FNom, FNomPourNous, FGinSender : string;

    FRestartMobilite, FRestartBI : boolean ;
    SrvManager : TServicesManager;
    FSendMailTech : Boolean;
    FDestinataire : TStringList;
//    slCRC : TStringList;
//    LogDbg : TStringList;
    function arreterApplie : boolean;
    procedure JeStartService(forceibguard : boolean = false);
    procedure JeStopService;
    procedure SetShutdownDatabase;
    procedure SetBringDatabaseOnline;
    function VersionEnInt(SS, Sd: string): Integer;
    function RecupFichier(FichierS, FichierD: string): Boolean;
    function Traitement_BATCH(LeFichier: string): Boolean;
    procedure AjouteNoeud(Xml: TMonXML; Noeud: string; Place: Integer; Valeur: string);
    function ChercheMaxVal(Noeuds: IXMLDOMNodeList; NoeudFils, TAG: string): string;
    function ChercheMinVal(Noeuds: IXMLDOMNodeList; NoeudFils, TAG: string): string;
    function ChercheVal(Noeuds: IXMLDOMNodeList; TAG: string): string;
    function Existes(Noeuds: IXMLDOMNodeList; NoeudFils, TAG, Valeur: string): Integer;
    function Existe(Noeuds: IXMLDOMNodeList; TAG, Valeur: string): Boolean;
    procedure RemplaceVal(Noeuds: IXMLDOMNodeList; TAG, Valeur: string);
    function traiteversion(S: string): string;
    procedure suite1;
    function StopServiceRepl: boolean;
    function Connexion: Boolean;
    function ConnexionModem(Nom, Tel: string): Boolean;
    procedure Deconnexion;
    procedure DeconnexionModem;

    procedure Attente_IB;
    function GetWindowsVersion: TWVersion;
    function getNomPoste : string;
    function getNomBase : string;
    function GetNow: string;
    procedure CleanLiveUpdate();
    procedure onLog(Sender: TObject; aMsg: string);
  public
    { Déclarations publiques }
    procedure PatchNotify(T_Actu, T_Tot: Integer);
    procedure FileNotify(Fichier: string);
    procedure effacerfichier(Rep: string);
    function testLog(Fichier: string): Boolean;
    function CopierFichier(FichierS, FichierD: string): Boolean;
    procedure retourStable;

    //      function DoNewCalcCRC32 (AFileName : String) : cardinal;

    // reboot auto
    function RestartAndRunOnce(AFileToRestart: string) : boolean;
    function DoRebootMachine(Time : Cardinal) : boolean;
    procedure AddToLogs(aMsg : string; aLvl : TLogLevel = LogInfo);
    function getCurrentLogFileName : string;
    procedure NettoyageLiveUpdate(aVersion : String);
  end;

var
  Frm_Patch: TFrm_Patch;

implementation

{$R *.DFM}

{$R 7z.RES}

uses
  FileCtrl,
  UDecodePatch,
  LaunchProcess,
  uServiceControler,
  GestionEMail,
  uConstante, uRunElevatedSupport, inifiles;

var
  Lapplication: string;
  AppliTourne: boolean;

const
  _launcher = 'LE LAUNCHER';
  _ginkoia = 'GINKOIA';
  _Caisse = 'CAISSEGINKOIA';
  _TPE = 'SERVEUR DE TPE';
  _PICCO = 'PICCOLINK';
  _SCRIPT = 'SCRIPT';
  _MIGREV13 = 'MIGREV13';
  _PICCOBATCH = 'PICCOBATCH';
  // FTH 12/09/2011 Utilise Killprocess au lieu de Enumwindows
  _SYNCWEB = 'syncweb.exe';
  c_MAIL_PORT = 587;
  _LaunchV7 = 'LaunchV7.Exe';
  _LauncherEasy = 'LauncherEasy.Exe';
  
resourcestring
  RS_MAIL_SERVER = 'pod51015.outlook.com';
  RS_MAIL_MDP = 'Toru682674';
  RS_MAIL_DEV = 'dev@ginkoia.fr';
  RS_MAIL_ADMIN = 'admin@ginkoia.fr';
  RS_MAIL_TECH = 'sav@ginkoia.fr';


function ProgressCallback(sender: Pointer; total: boolean; value: int64): HRESULT; stdcall;
begin
  if total then
    TProgressBar(sender).Max := (value div 1024) // Div 1024)
  else
    TProgressBar(sender).Position := (value div 1024); // Div 1024);
  Application.ProcessMessages;
  Result := S_OK;
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
      result := False;
    end;
  end;
end;

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

function ProcessExists(const ProcessName: string): Boolean;
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
        Result := True;
    until not Process32Next(HSnapShot, ProcessEntry32);

  CloseHandle(HSnapshot);
end;

procedure TFrm_Patch.DeconnexionModem;
var
  RasCom: array[1..100] of TRasConn;
  i, Connections: DWord;
  ok: Boolean;
  RasConStatus: TRasConnStatus;
begin
  repeat
    i := Sizeof(RasCom);
    RasCom[1].Size := sizeof(TRasConn);
    RasEnumConnections(@RasCom, i, Connections);
    for i := 1 to Connections do
      RasHangUp(RasCom[i].RasConn);
    // Test si c'est bien deconnecté
    i := Sizeof(RasCom);
    RasCom[1].Size := sizeof(TRasConn);
    RasEnumConnections(@RasCom, i, Connections);
    ok := True;
    for i := 1 to Connections do
    begin
      Application.ProcessMessages;
      RasConStatus.Size := sizeof(RasConStatus);
      RasGetConnectStatus(RasCom[i].RasConn, @RasConStatus);
      case RasConStatus.RasConnState of
        RASCS_Connected: ok := False;
      end;
    end;
    if not ok then
      LeDelay(5000);
  until OK;
end;

//function TFrm_Patch.DoNewCalcCRC32 (AFileName : String) : cardinal;
//var
//  IndyStream : TFileStream;
//  Hash32 : TIdHashCRC32;
//begin
//  IndyStream := TFileStream.Create(AFileName,fmOpenRead);
//  Hash32 := TIdHashCRC32.Create;
//  Result := Hash32.HashValue(IndyStream);
//  Hash32.Free;
//  IndyStream.Free;
//end;

procedure TFrm_Patch.Deconnexion;
begin
  if (Connectionencours <> nil) and (Connectionencours.LeType = 0) then
    DeconnexionModem;
  Connectionencours := nil;
end;

function TFrm_Patch.ConnexionModem(Nom, Tel: string): Boolean;
var
  RasConn: HRasConn;
  TP: TRasDialParams;
  Pass: Bool;
  err: DWORD;
  Last: DWord;
  RasConStatus: TRasConnStatus;
  nb: DWORD;
  ok: Boolean;
begin
  fillchar(tp, Sizeof(tp), #00);
  tp.Size := Sizeof(Tp);
  StrPCopy(tp.pEntryName, NOM);
  err := RasGetEntryDialParams(nil, TP, Pass);
  Ok := false;
  if err = 0 then
  begin
    StrPCopy(tp.pPhoneNumber, TEL);
    RasConn := 0;

    err := rasdial(nil, nil, @tp, $FFFFFFFF, Handle, RasConn);
    if err <> 0 then
    begin
      result := false;
      EXIT;
    end;
    Application.ProcessMessages;
    Last := $FFFFFFFF;
    nb := gettickcount + 600000; // 10 min
    repeat
      Application.ProcessMessages;
      RasConStatus.Size := sizeof(RasConStatus);
      RasGetConnectStatus(RasConn, @RasConStatus);
      if Last <> RasConStatus.RasConnState then
      begin
        case RasConStatus.RasConnState of
          RASCS_Connected: ok := true;
          RASCS_Disconnected: ok := true;
        end;
        Last := RasConStatus.RasConnState;
      end;
      LeDelay(1000);
    until OK or (gettickcount > nb); // max 10 min
  end;
  result := Ok;
end;

function TFrm_Patch.Connexion: Boolean;
var
  i: Integer;
  reg: tregistry;
begin
  reg := tregistry.create(KEY_WRITE);
  try
    reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\', False);
    reg.WriteInteger('GlobalUserOffline', 0);
  finally
    reg.closekey;
    reg.free;
  end;
  result := false;
  i := 0;
  Connectionencours := nil;
  while i < ListeConnexion.Count do
  begin
    Connectionencours := TLesConnexion(ListeConnexion[i]);
    if Connectionencours.LeType = 1 then // Routeur : Juste un Ping
    begin
      if Frm_Verification.Connexion then
      begin
        result := true;
        BREAK;
      end;
    end
    else
    begin // Connexion sur modem
      if ConnexionModem(Connectionencours.Nom, Connectionencours.TEL) then
      begin
        result := true;
        BREAK;
      end;
    end;
    Inc(i);
  end;
  if not result then
    Connectionencours := nil;
end;

procedure TFrm_Patch.JeStartService(forceibguard : boolean);
var
//  vSL: TStringList;
  Buffer, vResult: string;
  aValue : word;
  procedure SetStartService(const AServiceName: PAnsiChar; forceibguard : boolean = false);
  var
    hSCManager: SC_HANDLE;
    hService: SC_HANDLE;
    Statut: TServiceStatus;
    tempMini: DWORD;
    CheckPoint: DWORD;
    PC: PChar;
    NbEssai: Integer;
    MaxEssai: Integer;

    Reg: TRegistry;
    sPathIbGuard: string;
  begin
    AddToLogs('SetStartService');

    if GetWindowsVersion in [wvW7, wvNewVersion] then
    begin
      // On exécute le process interbase
      try
        Reg := TRegistry.Create(KEY_READ);
        Reg.RootKey := HKEY_LOCAL_MACHINE;
        if Reg.OpenKey('SYSTEM\ControlSet001\Services\' + AServiceName + '\', False) then
        begin
          sPathIbGuard := Reg.ReadString('ImagePath');
          if FileExists(sPathIbGuard) then
          begin
            if forceibguard or not ProcessExists('ibguard.exe') then
            begin
              try
                ShellExecute(0, 'OPEN', PCHAR(sPathIbGuard), PCHAR(' -a'), PCHAR(ExtractFilePath(sPathIbGuard)), HIDE_WINDOW);
                AddToLogs('Started processus');
              except
                on E: Exception do
                  AddToLogs('SetStartService : ' + E.Message, logError);
              end;
            end
            else
              AddToLogs('processus already started');
          end
          else
            AddToLogs(format('file "%s" don''t exist', [sPathIbGuard]));
        end;
      finally
        Reg.free;
      end;
    end;

    //    hSCManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
    //    hService := OpenService(hSCManager, AServiceName, SERVICE_QUERY_STATUS or SERVICE_START or SERVICE_STOP or SERVICE_PAUSE_CONTINUE);
    //    if hService <> 0 then
    //      begin // Service non installé
    //        QueryServiceStatus(hService, Statut);
    //        tempMini := Statut.dwWaitHint + 25;
    //        MaxEssai := trunc((10 * 60000) / tempMini);
    //        PC := nil;
    //        StartService(hService, 0, PC);
    //        NbEssai := 0;
    //        repeat
    //           CheckPoint := Statut.dwCheckPoint;
    //           Sleep(tempMini);
    //           application.processmessages;
    //           QueryServiceStatus(hService, Statut);
    //           tempMini := Statut.dwWaitHint + 25;
    //           inc(NbEssai);
    //        until ((CheckPoint = Statut.dwCheckPoint) and (NbEssai > MaxEssai)) or
    //           (statut.dwCurrentState = SERVICE_RUNNING);
    //              // si CheckPoint = Statut.dwCheckPoint Alors le service est dans les choux
    //
    //        vSL.Append(GetNow + AServiceName + ' : Service installé');
    //      end;
    //
    //    CloseServiceHandle(hService);
    //    CloseServiceHandle(hSCManager);

    case ServiceGetStatus('', AServiceName) of
       1:AddToLogs(AServiceName + ' (before) : SERVICE_STOPPED');
       2:AddToLogs(AServiceName + ' (before) : SERVICE_START_PENDING');
       3:AddToLogs(AServiceName + ' (before) : SERVICE_STOP_PENDING');
       4:AddToLogs(AServiceName + ' (before) : SERVICE_RUNNING');
       5:AddToLogs(AServiceName + ' (before) : SERVICE_CONTINUE_PENDING');
       6:AddToLogs(AServiceName + ' (before) : SERVICE_PAUSE_PENDING');
       7:AddToLogs(AServiceName + ' (before) : SERVICE_PAUSED');
    else AddToLogs(AServiceName + ' (before) : Error opening service');
    end;

    if ServiceStart('', AServiceName) then
      AddToLogs(AServiceName + ' : Service démaré')
    else
      AddToLogs(AServiceName + ' : erreur au démarage');

    case ServiceGetStatus('', AServiceName) of
       1:AddToLogs(AServiceName + ' (after) : SERVICE_STOPPED');
       2:AddToLogs(AServiceName + ' (after) : SERVICE_START_PENDING');
       3:AddToLogs(AServiceName + ' (after) : SERVICE_STOP_PENDING');
       4:AddToLogs(AServiceName + ' (after) : SERVICE_RUNNING');
       5:AddToLogs(AServiceName + ' (after) : SERVICE_CONTINUE_PENDING');
       6:AddToLogs(AServiceName + ' (after) : SERVICE_PAUSE_PENDING');
       7:AddToLogs(AServiceName + ' (after) : SERVICE_PAUSED');
    else AddToLogs(AServiceName + ' (after) : Error opening service');
    end;
  end;

begin
  AddToLogs('JeStartService', logDebug);
//  vSL := TStringList.Create;
  try
//    Buffer := ChangeFileExt(LeNomLog, '_JeStartService.log');
//    if FileExists(Buffer) then
//      vSL.LoadFromFile(Buffer);

    // demarage des guardian
    if ServiceExist('', 'InterBaseGuardian') then
      SetStartService('InterBaseGuardian');
    if ServiceExist('', 'IBG_gds_db') then
      SetStartService('IBG_gds_db');
    // demarage de interbase
    if ServiceExist('', 'InterBaseServer') then
      ServiceStart('', 'InterBaseServer');
    if ServiceExist('', 'IBS_gds_db') then
      ServiceStart('', 'IBS_gds_db');
  finally
//    vSL.SaveToFile(Buffer);
//    FreeAndNil(vSL);
  end;
end;


procedure TFrm_Patch.JeStopService;
var
//  vSL: TStringList;
  Buffer: string;

  procedure SetStopService(const AServiceName: PAnsiChar);
  var
    hSCManager: SC_HANDLE;
    hService: SC_HANDLE;
    Statut: TServiceStatus;
    tempMini: DWORD;
    CheckPoint: DWORD;

    Reg: TRegistry;
    sPathIbGuard: string;
  begin
    AddToLogs('SetStopService');
    //    hSCManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
    //    hService := OpenService(hSCManager, AServiceName, SERVICE_QUERY_STATUS or SERVICE_START or SERVICE_STOP or SERVICE_PAUSE_CONTINUE);
    //    if hService = 0 then
    //      begin // Service non installé
    //        vSL.Append(GetNow + AServiceName + ' : Service non installé');
    //      end
    //    else
    //      begin
    //         QueryServiceStatus(hService, Statut);
    //         if statut.dwCurrentState = SERVICE_RUNNING then
    //           begin
    //             tempMini := Statut.dwWaitHint + 10;
    //             ControlService(hService, SERVICE_CONTROL_STOP, Statut);
    //             repeat
    //                CheckPoint := Statut.dwCheckPoint;
    //                Sleep(tempMini);
    //                QueryServiceStatus(hService, Statut);
    //             until (CheckPoint = Statut.dwCheckPoint) or
    //                (statut.dwCurrentState = SERVICE_PAUSED);
    //                // si CheckPoint = Statut.dwCheckPoint Alors le service est dans les choux
    //
    //             vSL.Append(GetNow + AServiceName + ' : Service arrêté');
    //           end
    //         else
    //           begin
    //             vSL.Append(GetNow + AServiceName + ' : Service déjà arrêté');
    //           end;
    //      end;
    //    CloseServiceHandle(hService);
    //    CloseServiceHandle(hSCManager);

    case ServiceGetStatus('', AServiceName) of
       1:AddToLogs(AServiceName + ' (before) : SERVICE_STOPPED');
       2:AddToLogs(AServiceName + ' (before) : SERVICE_START_PENDING');
       3:AddToLogs(AServiceName + ' (before) : SERVICE_STOP_PENDING');
       4:AddToLogs(AServiceName + ' (before) : SERVICE_RUNNING');
       5:AddToLogs(AServiceName + ' (before) : SERVICE_CONTINUE_PENDING');
       6:AddToLogs(AServiceName + ' (before) : SERVICE_PAUSE_PENDING');
       7:AddToLogs(AServiceName + ' (before) : SERVICE_PAUSED');
    else AddToLogs(AServiceName + ' (before) : Error opening service')
    end;

    if ServiceStop('', AServiceName) then
      AddToLogs(AServiceName + ' : Service arrêté')
    else
      AddToLogs(AServiceName + ' : erreur a l''arrêt');

    case ServiceGetStatus('', AServiceName) of
       1:AddToLogs(AServiceName + ' (after) : SERVICE_STOPPED');
       2:AddToLogs(AServiceName + ' (after) : SERVICE_START_PENDING');
       3:AddToLogs(AServiceName + ' (after) : SERVICE_STOP_PENDING');
       4:AddToLogs(AServiceName + ' (after) : SERVICE_RUNNING');
       5:AddToLogs(AServiceName + ' (after) : SERVICE_CONTINUE_PENDING');
       6:AddToLogs(AServiceName + ' (after) : SERVICE_PAUSE_PENDING');
       7:AddToLogs(AServiceName + ' (after) : SERVICE_PAUSED');
    else AddToLogs(AServiceName + ' (after) : Error opening service');
    end;

    if GetWindowsVersion in [wvW7, wvNewVersion] then
    begin
      Reg := TRegistry.Create(KEY_READ);
      try
        Reg.RootKey := HKEY_LOCAL_MACHINE;
        if Reg.OpenKey('SYSTEM\ControlSet001\Services\' + AServiceName + '\', False) then
        begin
          sPathIbGuard := Reg.ReadString('ImagePath');
          if FileExists(sPathIbGuard) then
          begin
            KillProcess('ibserver.exe');
            KillProcess('ibguard.exe');
            AddToLogs(AServiceName + ' : Processus arrêté');
          end;
        end;
      finally
        Reg.free;
      end;
    end;
  end;

begin
  AddToLogs('JeStopService', logDebug);
//  vSL := TStringList.Create;
  try
//    Buffer := ChangeFileExt(LeNomLog, '_JeStopService.log');
//    if FileExists(Buffer) then
//      vSL.LoadFromFile(Buffer);

    // arret des guardian
    if ServiceExist('', 'InterBaseGuardian') then
      SetStopService('InterBaseGuardian');
    if ServiceExist('', 'IBG_gds_db') then
      SetStopService('IBG_gds_db');
    // arret de interbase
    if ServiceExist('', 'InterBaseServer') then
      ServiceStop('', 'InterBaseServer');
    if ServiceExist('', 'IBS_gds_db') then
      ServiceStop('', 'IBS_gds_db');
  finally
//    vSL.SaveToFile(Buffer);
//    FreeAndNil(vSL);
  end;
end;

procedure TFrm_Patch.NettoyageLiveUpdate(aVersion : String);
var
  sGin, sZip, sExe, sTxt, sLog : String;
begin
  AddToLogs('NettoyageLiveUpdate', logDebug);
  sGin := ChangeFileExt(Application.ExeName, '.GIN');
  sZip := ChangeFileExt(Application.ExeName, '.ZIP');
  sExe := aVersion + '.EXE';
  sTxt := aVersion + '.TXT';
  sLog := 'LOG' + aVersion + '.Log';
  if FileExists(sGin) then DeleteFile(sGin);
  if FileExists(sZip) then DeleteFile(sZip);
  if FileExists(sExe) then DeleteFile(sExe);
  if FileExists(sTxt) then DeleteFile(sTxt);
  if FileExists(sLog) then DeleteFile(sLog);
  AddToLogs('Nettoyage');
  AddToLogs('     ' + sGin);
  AddToLogs('     ' + sZip);
  AddToLogs('     ' + sExe);
  AddToLogs('     ' + sTxt);
  AddToLogs('     ' + sLog);
end;

procedure TFrm_Patch.onLog(Sender: TObject; aMsg: string);
begin
  AddToLogs(aMsg);
//  LLOG.Add('[' +DateTimeToStr(Now) + '] ' + aMsg);
end;

procedure TFrm_Patch.effacerfichier(Rep: string);
var
  F: TSearchRec;
begin
  if FindFirst(rep + '*.*', FaAnyFile, F) = 0 then
  begin
    repeat
      if (f.name <> '.') and (f.name <> '..') then
      begin
        if f.Attr and Fadirectory = Fadirectory then
          effacerfichier(Rep + f.name + '\')
        else
          deletefile(Rep + f.name);
      end;
    until FindNext(f) <> 0;
  end;
  FindClose(f);
end;

procedure TFrm_Patch.FileNotify(Fichier: string);
begin
  FichierEnCours := Fichier;
  Lab_Fichier.Caption := FichierEnCours;
  Lab_Fichier.Update;
  application.ProcessMessages;
end;

function TFrm_Patch.arreterApplie : boolean;
begin
  AddToLogs('arreterApplie', logDebug);
  result := False;
  Lapplication := _SCRIPT;
  EnumWindows(@Enumerate, 0);
  Lapplication := _ginkoia;
  EnumWindows(@Enumerate, 0);
  sleep(100);
  Lapplication := _Caisse;
  EnumWindows(@Enumerate, 0);
  sleep(100);
  Lapplication := _PICCO;
  EnumWindows(@Enumerate, 0);
  sleep(100);
  Lapplication := _PICCOBATCH;
  EnumWindows(@Enumerate, 0);
  sleep(100);
  Lapplication := _TPE;
  EnumWindows(@Enumerate, 0);

  sleep(100);
  //   Lapplication := _SYNCWEB;
  //   EnumWindows(@Enumerate, 0);
  KillProcess(_SYNCWEB);

  sleep(100);
  Lapplication := _launcher;
  EnumWindows(@Enumerate, 0);
  sleep(60000); 

//  // Arrêt du service d'impression Ginkoia
//  ServiceStop('', 'ImpDoc_SRC');
//
//  // Arrêt du service Mobilité
//  FRestartMobilite := false ;
//  if ServiceStarted('', 'GinkoiaMobiliteSvr') then
//  begin
//    FRestartMobilite := true ;
//    ServiceStop('', 'GinkoiaMobiliteSvr');
//  end;
//
//  // Arrêt du service BI
//  FRestartBI := false ;
//  if ServiceStarted('', 'Service_BI_Ginkoia') then
//  begin
//    FRestartBI := true ;
//    ServiceStop('', 'Service_BI_Ginkoia');
//  end;
  result := SrvManager.stopServices;
  // Arrêt de la base
  SetShutdownDatabase;
end;

procedure TFrm_Patch.Attente_IB;
//var
//  vSL: TStringList;
//  Buffer: string;

  procedure SetAttente_IB(const AServiceName: PAnsiChar);
    //  VAR
    //    hSCManager: SC_HANDLE;
    //    hService: SC_HANDLE;
    //    Statut: TServiceStatus;
    //    tempMini: DWORD;
    //    CheckPoint: DWORD;
    //    NbBcl: Integer;
  begin
    //    hSCManager := OpenSCManager(NIL, NIL, SC_MANAGER_CONNECT);
    //    hService := OpenService(hSCManager, AServiceName, SERVICE_QUERY_STATUS);
    //    IF hService <> 0 THEN
    //    BEGIN // Service non installé
    //      QueryServiceStatus(hService, Statut);
    //      CheckPoint := 0;
    //      NbBcl := 0;
    //      WHILE (statut.dwCurrentState <> SERVICE_RUNNING) DO
    //      BEGIN
    //        CheckPoint := Statut.dwCheckPoint;
    //        tempMini := Statut.dwWaitHint + 1000;
    //        Sleep(tempMini);
    //        QueryServiceStatus(hService, Statut);
    //        Inc(nbBcl);
    //        IF NbBcl > 900 THEN
    //        begin
    //          vSL.Append(GetNow + AServiceName + ' - SetAttente_IB (1) : Time out');
    //          BREAK;
    //        end;
    //      END;
    //
    //      IF NbBcl < 900 THEN
    //      BEGIN
    //        CloseServiceHandle(hService);
    //        hService := OpenService(hSCManager, AServiceName, SERVICE_QUERY_STATUS);
    //        IF hService <> 0 THEN
    //        BEGIN // Service non installé
    //          QueryServiceStatus(hService, Statut);
    //          CheckPoint := 0;
    //          NbBcl := 0;
    //          WHILE (statut.dwCurrentState <> SERVICE_RUNNING) OR
    //            (CheckPoint <> Statut.dwCheckPoint) DO
    //          BEGIN
    //            CheckPoint := Statut.dwCheckPoint;
    //            tempMini := Statut.dwWaitHint + 1000;
    //            Sleep(tempMini);
    //            QueryServiceStatus(hService, Statut);
    //            Inc(nbBcl);
    //            IF NbBcl > 900 THEN
    //              begin
    //                vSL.Append(GetNow + AServiceName + ' - SetAttente_IB (2) : Time out');
    //                BREAK;
    //              end;
    //          END;
    //        END;
    //      END;
    //    END;
    //    CloseServiceHandle(hService);
    //    CloseServiceHandle(hSCManager);

    if not ServiceWaitStart('', AServiceName, 60000) then
      AddToLogs(AServiceName + ' - SetAttente_IB (2) : Time out');
  end;

begin
  AddToLogs('AttenteIB', logDebug);
//  vSL := TStringList.Create;
  try
//    Buffer := ChangeFileExt(LeNomLog, '_Attente_IB.log');
//    if FileExists(Buffer) then
//      vSL.LoadFromFile(Buffer);

    // demarage des guardian
    if ServiceExist('', 'InterBaseGuardian') then
      SetAttente_IB('InterBaseGuardian');
    if ServiceExist('', 'IBG_gds_db') then
      SetAttente_IB('IBG_gds_db');
    // demarage de interbase
    if ServiceExist('', 'InterBaseServer') then
      SetAttente_IB('InterBaseServer');
    if ServiceExist('', 'IBS_gds_db') then
      SetAttente_IB('IBS_gds_db');
  finally
//    vSL.SaveToFile(Buffer);
//    FreeAndNil(vSL);
  end;
end;

function TFrm_Patch.VersionEnInt(SS, Sd: string): Integer;
var
  V1, V1d: Integer;
  V2, V3: Integer;
  V2d, V3d, V4d: Integer;
begin
  V1 := Strtoint(Copy(Ss, 1, pos('.', Ss) - 1));
  delete(ss, 1, pos('.', Ss));
  V2 := Strtoint(Copy(Ss, 1, pos('.', Ss) - 1));
  delete(ss, 1, pos('.', Ss));
  V3 := Strtoint(Copy(Ss, 1, pos('.', Ss) - 1));
  delete(ss, 1, pos('.', Ss));

  V1d := Strtoint(Copy(Sd, 1, pos('.', Sd) - 1));
  delete(sd, 1, pos('.', Sd));
  V2d := Strtoint(Copy(Sd, 1, pos('.', Sd) - 1));
  delete(sd, 1, pos('.', Sd));
  V3d := Strtoint(Copy(Sd, 1, pos('.', Sd) - 1));
  delete(sd, 1, pos('.', Sd));
  V4d := Strtoint(trim(Sd));
  if (V3d - V3) < 0 then
    V3 := V3d;
  if (V2d - V2) < 0 then
    V2 := V2d;
  Result := trunc(V4d / 10) + (V3d - V3) * 1000 + (V2d - V2) * 1000 * 12 + (V1d - V1) * 1000 * 12 * 10;
end;

procedure TFrm_Patch.FormCreate(Sender: TObject);
var
  S: string;
  reg: TRegistry;
  TmLesFic: TmemoryStream;
  AncVersion: string;
  AncNumero: string;
  NvlVersion: string;
  NvlNumero: string;

  APPPATH: string;
  Res: TResourceStream;

  i : integer;
  NoReboot : boolean;

  bAdmin, bAdministratorAccount, bElevated : boolean;
  iUAC, iLevelUAC : integer;
  iAutoLogon : integer;
  sMsg : string;
begin
  try
    if not Log.Opened then
    begin
      Log.Open;
      Log.readIni;
      Log.saveIni;
    end;


//    if FileExists(ExtractFilePath(Application.ExeName) + 'GinVer.ini') then
//    begin
//      ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'GinVer.ini');
//      if not ini.SectionExists('DEFAULT') then
//      begin
//        ini.WriteBool('DEFAULT', 'bDefAdmin', bDefAdmin);
//        ini.WriteBool('DEFAULT', 'bDefAdministratorAccount', bDefAdministratorAccount);
//        ini.WriteBool('DEFAULT', 'bDefElevated', bDefElevated);
//        ini.WriteInteger('DEFAULT', 'iDefAutoLogon', iDefAutoLogon);
//        ini.WriteInteger('DEFAULT', 'iDefOffUAC', iDefOffUAC);
//        ini.WriteInteger('DEFAULT', 'iDefOffLevelUAC', iDefOffLevelUAC);
//        ini.WriteInteger('DEFAULT', 'iDefOnUAC', iDefOnUAC);
//        ini.WriteInteger('DEFAULT', 'iDefOnLevelUAC', iDefOnLevelUAC);
//      end
//      else
//      begin
//        bDefAdmin := ini.ReadBool('DEFAULT', 'bDefAdmin', True);
//        bDefAdministratorAccount := ini.ReadBool('DEFAULT', 'bDefAdministratorAccount', True);
//        bDefElevated := ini.ReadBool('DEFAULT', 'bDefElevated', True);
//        iDefAutoLogon := ini.Readinteger('DEFAULT', 'iDefAutoLogon', 1);
//        iDefOffUAC := ini.Readinteger('DEFAULT', 'iDefOffUAC', 0);
//        iDefOffLevelUAC := ini.Readinteger('DEFAULT', 'iDefOffLevelUAC', 0);
//        iDefOnUAC := ini.Readinteger('DEFAULT', 'iDefOnUAC', 1);
//        iDefOnLevelUAC := ini.Readinteger('DEFAULT', 'iDefOnLevelUAC', 1);
//      end;
//      ini.Free;
//    end;
//    else
//    begin
//      ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'GinVer.ini');
//      ini.WriteBool('DEFAULT', 'bDefAdmin', bDefAdmin);
//      ini.WriteBool('DEFAULT', 'bDefAdministratorAccount', bDefAdministratorAccount);
//      ini.WriteBool('DEFAULT', 'bDefElevated', bDefElevated);
//      ini.WriteInteger('DEFAULT', 'iDefAutoLogon', iDefAutoLogon);
//      ini.WriteInteger('DEFAULT', 'iDefOffUAC', iDefOffUAC);
//      ini.WriteInteger('DEFAULT', 'iDefOffLevelUAC', iDefOffLevelUAC);
//      ini.WriteInteger('DEFAULT', 'iDefOnUAC', iDefOnUAC);
//      ini.WriteInteger('DEFAULT', 'iDefOnLevelUAC', iDefOnLevelUAC);
//      ini.Free;
//    end;

    bAdmin := IsAdministrator;
    bAdministratorAccount := IsAdministratorAccount;
    bElevated := isElevated;
    iUAC := getValueI('\Software\Microsoft\Windows\CurrentVersion\Policies\System', 'EnableLUA');
    iLevelUAC := getValueI('\Software\Microsoft\Windows\CurrentVersion\Policies\System', 'ConsentPromptBehaviorAdmin');
    iAutoLogon := StrToIntDef(getValueS('\Software\Microsoft\Windows NT\CurrentVersion\Winlogon', 'AutoAdminLogon'), 1);

    AddToLogs(Format('  IsAdministrator: %s', [BoolToStr(bAdmin, True)]));
    AddToLogs(Format('  IsAdministratorAccount: %s', [BoolToStr(bAdministratorAccount, True)]));
    AddToLogs(Format('  IsElevated: %s', [BoolToStr(bElevated, True)]));
    AddToLogs(Format('  \Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA: %d', [iUAC]));
    AddToLogs(Format('  \Software\Microsoft\Windows\CurrentVersion\Policies\System\ConsentPromptBehaviorAdmin: %d', [iLevelUAC]));
    AddToLogs(Format('  \Software\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon: %d', [iAutoLogon]));
    AddToLogs(Format('  \Software\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultUsername: %s', [getValueS('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon', 'DefaultUsername')]));
    sMsg := 'Pas de MAJ sur le poste : ' + getNomPoste;
    FSendMailTech := false;

    if ((Win32MajorVersion >= 6) and (Win32MinorVersion >= 1)) then
    begin
      AddToLogs('Version de Windows supérieur à Seven');
      if not (bAdmin or bAdministratorAccount) then
      begin
        sMsg := sMsg + #13#10 + '    Pas administrateur';
        AddToLogs(sMsg, logError);
        doclose := true;
        FSendMailTech := true;
      end
      else
      begin
        if iUAC = 1 then
        begin
          if iLevelUAC >= 2 then
          begin
            sMsg := sMsg + #13#10 + '    UAC activé ('+inttostr(iUAC)+') mais le niveau est supérieur à 1 ('+inttostr(iLevelUAC)+')';
            AddToLogs(sMsg, logError);
            doclose := true;
            FSendMailTech := true;
          end;
        end
        else if iUAC > 1 then
        begin
          sMsg := sMsg + #13#10 + '    UAC activé ('+inttostr(iUAC)+') avec un niveau de '+inttostr(iLevelUAC);
          AddToLogs(sMsg, logError);
          doclose := true;
          FSendMailTech := true;
        end;
        if not(iAutoLogon = 1) then
        begin
          sMsg := sMsg + #13#10 + '    Pas d''auto logon';
          AddToLogs(sMsg, logError);
//          doclose := true;
          FSendMailTech := true;
        end;
      end;
    end
    else AddToLogs('Version de Windows inférieur à Seven');


   //    Application.Terminate;
//  end;

  Caption := Caption + ' - ' + GetNumVersionSoft;

  // Gestion des paramètres du logiciel
  automatique := false;
  // gestion du reboot automatique !
  NoReboot := false;
  if ParamCount > 0 then
  begin
    for i := 1 to ParamCount do
    begin
      if UpperCase(ParamStr(i)) = 'NOREBOOT' then
        NoReboot := True
      else if uppercase(paramstr(1)) = 'AUTO' then
        automatique := true;
    end;
  end;


  if automatique and not NoReboot then
  begin
    if (bAdmin or bAdministratorAccount) then
    begin
      AddToLogs('reboot');
      doclose := true;
      if RestartAndRunOnce(ParamStr(0) + ' AUTO NOREBOOT') then
        Exit;
    end
    else
    begin
      AddToLogs('pas de reboot car pas admin');
      doclose := true;
      Exit;
    end;
  end;


  FnewCRC := false;

//  APPPATH := ExtractFilePath(Application.ExeName);
//
//  if FileExists(APPPATH + '7z.dll') then
//    DeleteFile(APPPATH + '7z.dll');
//
//  Res := TResourceStream.Create(0, 'SEVENZIP', 'DLL');
//  Res.SaveToFile(ExtractFilePath(Application.ExeName) + '7z.dll');
//  Res.Free;

  MapGinkoia.MajAuto := True;
  First := true;
  doclose := False;
  CaisseAutonome := false;
  RzLabel5.Caption := '';
  pc.ActivePage := PRES;
  tim_auto.tag := 2;
  if automatique then
    tim_auto.enabled := true;
  reg := TRegistry.Create(KEY_READ);
  try
    reg.access := Key_Read;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    s := '';
    reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
    S := reg.ReadString('Base0');
  finally
    reg.free;
  end;

  Labase := S;
  S := ExcludetrailingBackSlash(ExtractFilePath(S));
  while s[length(S)] <> '\' do
    delete(S, length(S), 1);
  Ginkoia := S;


  AddToLogs('   Path Database:'+Labase);
  AddToLogs('   Path Ginkoia:'+Ginkoia);
  data.DatabaseName := Labase;

  TmLesFic := TmemoryStream.Create;
  try
    try
      TmLesFic.LoadFromFile(Ginkoia + 'LiveUpdate\' + Nom_Outil_Maj + '.GIN');
      TmLesFic.seek(0, soFromBeginning);
      AncVersion := ReadString(TmLesFic);
      AncNumero := ReadString(TmLesFic);
      NvlVersion := ReadString(TmLesFic);
      NvlNumero := ReadString(TmLesFic);
    finally
      TmLesFic.free;
    end;
    ArtLabel1.caption := Format(ArtLabel1.Caption, [NvlVersion]);
    ArtLabel2.caption := Format(ArtLabel2.Caption, [NvlVersion]);
    ArtLabel3.caption := Format(ArtLabel3.Caption, [NvlVersion]);
    ArtLabel4.caption := Format(ArtLabel4.Caption, [NvlVersion]);
    ArtLabel5.caption := Format(ArtLabel5.Caption, [NvlVersion]);
    ArtLabel6.caption := Format(ArtLabel6.Caption, [NvlVersion]);
    ArtLabel7.caption := Format(ArtLabel7.Caption, [NvlVersion]);
    ArtLabel8.caption := Format(ArtLabel8.Caption, [NvlVersion]);
    ArtLabel9.caption := Format(ArtLabel9.Caption, [NvlVersion]);
    ArtLabel10.caption := Format(ArtLabel10.Caption, [NvlVersion]);
    rzlabel1.caption := Format(rzlabel1.Caption, [NvlVersion]);
    pc.ActivePage := PRES;
    tim_auto.tag := 2;
    if automatique then
      tim_auto.enabled := true;

    LeNomLog := Ginkoia + 'LiveUpdate\LOG' + AncVersion + '-' + NvlVersion + '.Log';
    if FileExists(LeNomLog) and testLog(LeNomLog) then
    begin
      AddToLogs('FormCreate > RetourStable', logDebug);
      pc.ActivePage := RETSTABLE;
      tim_auto.tag := 7;
      if automatique then
        tim_auto.enabled := true;
    end;
  except
    on E: Exception do
    begin
      AddToLogs('Patch FormCreate : ' + E.Message, logError);
      doclose := true;
      if not automatique then
        Application.messagebox('Problème important sur le logiciel, il va se fermer', ' Fermer', Mb_OK)
    end;
  end;
  JeStartService;
//  LogDbg := TStringList.create;
//  LLOG := TStringList.Create;
//  if FileExists(Ginkoia + 'LiveUpdate\LOG_SrvManager.Log') then
//    LLOG.loadfromfile(Ginkoia + 'LiveUpdate\LOG_SrvManager.Log');




  SrvManager := TServicesManager.create(onLog, Ginkoia + 'Services.ini', true);
  SrvManager.Application := ChangeFileExt(ExtractFileName(Application.ExeName), '');
  AddToLogs('-----------------------------------------------------------------------------');
  {$IFDEF DEBUG}
    AddToLogs('Démarrage de Patch v.'+GetNumVersionSoft+' DEBUG');
  {$ELSE}
    AddToLogs('Démarrage de Patch v.'+GetNumVersionSoft);
  {$ENDIF}
//  slCRC := TStringList.Create;
  finally
    if FSendMailTech then
    begin
      doclose := true;
      FDestinataire := TStringList.Create;
      try
        FDestinataire.Add(RS_MAIL_ADMIN);
        FDestinataire.Add(RS_MAIL_TECH);
  //      FDestinataire.Add('ludovic*.masse@ginkoia.fr');
        SendMail(RS_MAIL_SERVER, c_MAIL_PORT, RS_MAIL_DEV, RS_MAIL_MDP, tsm_TLS,
          RS_MAIL_DEV, FDestinataire, 'Mauvais Param : ' + getNomBase,
          sMsg, getCurrentLogFileName);
      finally
        FreeAndNil(FDestinataire);
      end;
    end;
  end;
end;

procedure TFrm_Patch.FormDestroy(Sender: TObject);
begin
//  FreeAndNil(slCRC);
//  LLOG.SaveToFile(Ginkoia + 'LiveUpdate\LOG_SrvManager.Log');
//  LLOG.free;
//  LogDbg.SaveToFile(Ginkoia + 'LiveUpdate\LOG_Debug_' + FormatDateTime('ddmmyyyyhhnnss', Now) + '.Log');
//  LogDbg.free;
  MapGinkoia.MajAuto := false ;
end;

procedure TFrm_Patch.PatchNotify(T_Actu, T_Tot: Integer);
begin
  try
    Pb2.Max := T_Tot;
    Pb2.Position := T_Actu;
  except
  end;
end;

function TFrm_Patch.testLog(Fichier: string): boolean;
var
  TSL: TstringList;
  i: integer;
begin
  result := False;
  Tsl := TstringList.Create;
  if FileExists(fichier) then
  begin
    tsl.loadfromfile(fichier);
    for i := 0 to tsl.count - 1 do
    begin
      if Copy(tsl[i], 1, 1) = '*' then
      begin
        result := true;
        BREAK;
      end;
    end;
  end;
  tsl.free;
end;

function TFrm_Patch.CopierFichier(FichierS, FichierD: string): Boolean;
var
  Arch: I7zOutArchive;
  CRCold: DWORD;
  CRCnew: DWORD;
begin
  result := True;
  Lab_Fichier.Caption := 'Sauvegarde de ' + FichierS;
  Lab_Fichier.Update;
  application.ProcessMessages;

  ForceDirectories(extractfilepath(FichierD));
  if Uppercase(ExtractFileExt(FichierS)) = '.ZIP' then
  begin
    Result := CopyFile(Pchar(FichierS), Pchar(FichierD), False);

    try
//      LogDbg.Add('[' +DateTimeToStr(Now) + '] ' + '________________________________________________________________');
//      LogDbg.Add('[' +DateTimeToStr(Now) + '] ' + 'Try:Copy "' + FichierS + '" > "' + FichierD +'"');
      Result := CopyFile(Pchar(FichierS), Pchar(FichierD), False);
      if not Result then
      begin
//        LogDbg.Add('[' +DateTimeToStr(Now) + '] ' + 'If:Copy Fail > Kill Exe:"' + ExtractFileName(Pchar(FichierS)) + '"');
        KillTask(ExtractFileName(Pchar(FichierS)));
        Sleep(5000);
//        LogDbg.Add('[' +DateTimeToStr(Now) + '] ' + 'If:Retry Copy');
        result := CopyFile(Pchar(FichierS), Pchar(FichierD), False);
//        if result
//          then LogDbg.Add('[' +DateTimeToStr(Now) + '] ' + 'If:Copy Ok')
//          else LogDbg.Add('[' +DateTimeToStr(Now) + '] ' + 'If:Copy Fail');
      end;
    except
      on E: Exception do
      begin
        AddToLogs('CopierFichier : ' + E.Message, logError);
        KillTask(ExtractFileName(Pchar(FichierS)));
        Sleep(5000);
        result := CopyFile(Pchar(FichierS), Pchar(FichierD), False);
      end;
    end;



  end
  else
  begin
    //      Pb2.position := 0; Pb2.Max := 100;
    if FileEXists(FichierS) then
    try
      // Calcul du CRC32
      // TODO : CRCSauve := IntToStr(DoNewCalcCRC32(FichierS));
      // Zip du fichier
      Arch := CreateOutArchive(CLSID_CFormatZip);
      Arch.AddFile(FichierS, ExtractFileName(FichierS));
      SetCompressionLevel(Arch, 4);
      Arch.SetProgressCallback(Pb2, ProgressCallback);
      Arch.SaveToFile(FichierD + '.ZIP');

      try
        CRCold := FileCRC32(FichierD + '.ZIP');
      except
        on E: Exception do
        begin
          AddToLogs('FileCRC32('+FichierD+'.ZIP) : ' + E.Message, logError);
          CRCold := 0;
        end;
      end;
      try
        CRCnew := DoNewCalcCRC32(FichierD + '.ZIP');
      except
        on E: Exception do
        begin
          AddToLogs('DoNewCalcCRC32('+FichierD+'.ZIP) : ' + E.Message, logError);
          CRCnew := 0;
        end;
      end;

      if FnewCRC then
        CRCSauve := Inttostr(CRCnew)
      else
        CRCSauve := Inttostr(CRCold);
    except
      result := false;
    end;
  end;
end;

procedure TFrm_Patch.dataBeforeConnect(Sender: TObject);
var
  reg : TRegistry;
begin
  if not FileExists(Data.databasename) then
  begin
    AddToLogs('La database "' + Data.databasename + '" n''existe pas');
    // Traitement
    reg := TRegistry.Create;
    try
      reg.access := Key_Read;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Labase := '';
      reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
      Labase := reg.ReadString('Base0');
    finally
      reg.free;
    end;
    Data.databasename := Labase;
    AddToLogs('On va cherche celle de la base 0 "'+Data.databasename+'"');
  end;
end;

function TFrm_Patch.RecupFichier(FichierS, FichierD: string): Boolean;
var
  Arch: I7zInArchive;
begin
  AddToLogs('RecupFichier(' + FichierS + '/' + FichierD + ')', logDebug);
  try
    result := True;
    Lab_Fichier.Caption := 'Récupération de ' + FichierD;
    Lab_Fichier.Update;
    application.ProcessMessages;

    Pb2.position := 0;
    Pb2.Max := 100;
    if uppercase(ExtractFileExt(FichierS)) = '.ZIP' then
    begin
      Result := CopyFile(Pchar(FichierS), Pchar(FichierD), False);
    end
    else if fileexists(FichierS) then
    begin
      Result := CopyFile(Pchar(FichierS), Pchar(FichierD), False);
    end
    else
    begin
      if fileexists(FichierS + '.ZIP') then
      begin
        try
          Arch := CreateInArchive(CLSID_CFormatZip);
          Arch.OpenFile(FichierS + '.ZIP');
          Arch.SetProgressCallback(Pb2, ProgressCallback);
          Arch.ExtractTo(extractfilepath(FichierD));
        except
          result := false;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      AddToLogs('RecupFichier - ' + e.Message, logError);
      if automatique then
        Showmessage('RecupFichier : ' + E.Message);
    end;
  end;
end;

procedure TFrm_Patch.retourStable;
var
  TSL: TstringList;
  i: integer;
  S1: string;
  S: string;
  NewCRC: Cardinal;
  IndyStream: TFileStream;
  Hash32: TIdHashCRC32;
  CRCold: DWORD;
  CRCnew: DWORD;
  bError : boolean;
begin
  AddToLogs('retourStable', logDebug);
  bError := false;
  try
    if not arreterApplie then
    begin
      doclose := true;
      AddToLogs('Impossible d''arreter les services, impossible de revenir à un état stable', logError);
      Exit;
    end;
    Tsl := TstringList.Create;
    if FileExists(LeNomLog) then
      tsl.loadfromfile(LeNomLog);
    AddToLogs('- Retour à un état stable ');
//    tsl.Savetofile(log);
//    tslLog := TStringList.Create;
//    tslLog.Text := tsl.Text;
//    iLogCount := tslLog.Count; // Permet de vérifier à la fin s'il y a eu des soucis
    // vérification de la cohérence de la sauvegarde
    try
      for i := 0 to tsl.count - 1 do
      begin
        if Copy(tsl[i], 1, 1) = '*' then
        begin
          if Copy(tsl[i], 1, 2) = '**' then
          begin // recup d'un fichier sauvegardé
            S := Copy(tsl[i], 3, 255);
            S1 := Copy(S, pos(';', S) + 1, 255);
            delete(S, Pos(';', S), 255);
            Lab_Etat.Caption := 'Récupération de ' + S;
            Lab_Etat.Update;
            application.ProcessMessages;

            RecupFichier(Ginkoia + 'Sauve\' + S, Ginkoia + S);
            // Calcul du CRC

            try
              CRCold := FileCRC32(Ginkoia + S);
            except
              on E: Exception do
              begin
                AddToLogs('DoNewCalcCRC32('+Ginkoia + S + ') : ' + E.Message, logError);
                CRCold := 0;
              end;
            end;
            try
              CRCnew := DoNewCalcCRC32(Ginkoia + S);
            except
              on E: Exception do
              begin
                AddToLogs('DoNewCalcCRC32('+Ginkoia + S + ') : ' + E.Message, logError);
                CRCnew := 0;
              end;
            end;

            if FnewCRC then
              NewCRC := CRCnew
            else
              NewCRC := CRCold;

            // Vérification avec l'ancien CRC
            if Trim(S1) <> IntToStr(NewCRC) then
            begin
              AddToLogs('CRC Incorrect : ' + Ginkoia + S, logError);
              AddToLogs('Old : ' + S1 + ' / New : ' + IntToStr(NewCRC), logError);
              bError := true;
            end
            else
            begin
              AddToLogs('CRC Correct : ' + Ginkoia + S);
              AddToLogs('CRC BASE : ' + IntToStr(NewCRC));
            end;
          end
          else if Copy(tsl[i], 1, 2) = '*?' then
          begin // recup de la base sauvegardée
            S := Copy(tsl[i], 3, 255);
            S1 := Copy(S, pos(';', S) + 1, 255);
            Lab_Etat.Caption := 'Récupération de la base ';
            Lab_Etat.Update;
            application.ProcessMessages;

            // si la base sauvegardé existe
            if FileExists(Ginkoia + 'Sauve\BASES.IB') then
            begin
              // on rename la base normal
              RenameFile(LaBase, ChangeFileExt(LaBase, '.TMP'));
              // on copie la base sauvegarder a la place de la base normal
              if not CopyFile(PAnsiChar(Ginkoia + 'Sauve\BASES.IB'), PAnsiChar(LaBase), false) then
              begin
                RenameFile(ChangeFileExt(LaBase, '.TMP'), LaBase);
                AddToLogs('Retour KO - Echec de la copie de la base', logError);
              end
              else
                // si la copie a réussi on supprime la base normal renommé
                DeleteFile(ChangeFileExt(LaBase, '.TMP'));
            end;

            // RecupFichier(Ginkoia + 'Sauve\BASES', LaBase);

            // Calcul du CRC
            try
              CRCold := FileCRC32(LaBase);
            except
              on E: Exception do
              begin
                AddToLogs('FileCRC32(' + LaBase + ') : ' + E.Message, logError);
                CRCold := 0;
              end;
            end;
            try
              CRCnew := DoNewCalcCRC32(LaBase);
            except
              on E: Exception do
              begin
                AddToLogs('DoNewCalcCRC32(' + LaBase + ') : ' + E.Message, logError);
                CRCnew := 0;
              end;
            end;

            if FnewCRC then
              NewCRC := CRCnew
            else
              NewCRC := CRCold;

            // Vérification avec l'ancien CRC
            if Trim(S1) <> IntToStr(NewCRC) then
            begin
              AddToLogs('CRC Incorrect : ' + LaBase, logError);
              AddToLogs('Old : ' + S1 + ' / New : ' + IntToStr(NewCRC), logError);
              bError := true;
            end
            else
            begin
              AddToLogs('CRC Correct : ' + LaBase);
              AddToLogs('CRC BASE : ' + IntToStr(NewCRC));
            end;
          end
        end;
      end;

      if bError then
      begin
        AddToLogs('La sauvegarde est altérée, impossible de revenir à un état stable', logError);
        if not automatique then
          Application.messageBox('La sauvegarde est altérée, impossible de revenir à un état stable', ' PROBLEME', Mb_Ok);
      end
      else
        AddToLogs('- OK Retour à un état stable');
    except
      on E: Exception do
      begin
        AddToLogs('retourStable : ' + E.Message, logError);
        if not automatique then
          Showmessage('retourStable : ' + E.Message);
      end;
    end;
  finally
    SetBringDatabaseOnline;
    AddToLogs('Fin Retour Stable');
    if FileExists(LeNomLog) then
    begin
      AddToLogs('Suppression du fichier:' + LeNomLog);
      DeleteFile(LeNomLog);
    end;
//    tslLog.Savetofile(log);
//    tsl.free;
//    tslLog.Free;
//    forcedirectories(Ginkoia + 'LiveUpdate\LOG\');
//    CopyFile(Pchar(Log), Pchar(Ginkoia + 'LiveUpdate\LOG\' + FormatDateTime('ddmmyyyy_hhnnss', now) + '_' + ExtractFileName(Log) ), False);
//    deletefile(Log);
  end;
end;

procedure TFrm_Patch.RemplaceVal(Noeuds: IXMLDOMNodeList; TAG: string; Valeur: string);
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

procedure TFrm_Patch.AddToLogs(aMsg: string; aLvl : TLogLevel = LogInfo);
begin
  Log.Log('Patch', 'Log', aMsg, aLvl, false, -1, ltLocal) ;
end;

procedure TFrm_Patch.AjouteNoeud(Xml: TMonXML; Noeud: string; Place: Integer; Valeur: string);
var
  Actu: string;
  S: string;
  Node: IXMLDOMNode;
  ok: Boolean;
  NodeAjout: TMonXml;
  i: Integer;
begin
  AddToLogs('AjouteNoeud', logDebug);
  NodeAjout := TMonXml.Create;
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

function TFrm_Patch.ChercheVal(Noeuds: IXMLDOMNodeList; TAG: string): string;
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

procedure TFrm_Patch.CleanLiveUpdate();
var
  F: TSearchRec;
  sRep : string;
  bDelete : boolean;
begin
  sRep := Ginkoia + 'Liveupdate\';
  if FindFirst(sRep + '*.*', FaAnyFile, F) = 0 then
  begin
    repeat
      if (f.name <> '.') and (f.name <> '..') then
      begin
        if not(f.Attr and Fadirectory = Fadirectory) then
        begin
          bDelete := not((LowerCase(f.name) = 'amaj.txt')
                      or (LowerCase(f.name) = '7z.dll')
                      or (LowerCase(f.name) = 'delzip179.dll')
                      or (LowerCase(f.name) = 'migre_version.alg')
                      or (LowerCase(f.name) = 'ginver.exe'));


          if bDelete then
            deletefile(sRep + f.name);
        end;
      end;
    until FindNext(f) <> 0;
  end;
  FindClose(f);
end;

function TFrm_Patch.ChercheMinVal(Noeuds: IXMLDOMNodeList; NoeudFils: string; TAG: string): string;
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

function TFrm_Patch.ChercheMaxVal(Noeuds: IXMLDOMNodeList; NoeudFils: string; TAG: string): string;
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

function TFrm_Patch.Existe(Noeuds: IXMLDOMNodeList; TAG, Valeur: string): Boolean;
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

function TFrm_Patch.Existes(Noeuds: IXMLDOMNodeList; NoeudFils: string; TAG, Valeur: string): Integer;
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

function TFrm_Patch.Traitement_BATCH(LeFichier: string): Boolean;
var
  PassTsl: TstringList;
  Tsl: TstringList;
  LesVar: TstringList;
  LesVal: TstringList;
  LaPille: TstringList;
  Ordre: string;
  MarqueurEai: Integer;
  EaiEnCours: Integer;
  XML: TMonXML;
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

    MonPathExtract: string;

    reg: tregistry;
    Arch: I7zInArchive;
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
        MonPathExtract := S;
        while pos('\', MonPathExtract) > 0 do
          delete(MonPathExtract, 1, pos('\', MonPathExtract));
        MonPathExtract := Ginkoia + 'LiveUpdate\' + ChangeFileExt(MonPathExtract, '') + '\';
        Arch := CreateInArchive(CLSID_CFormatZip);
        Arch.OpenFile(S);
        Arch.ExtractTo(MonPathExtract);

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
//        Winexec(PChar(S), 0);
        ShellExecute(0, 'open', PChar(s), '', nil, SW_SHOWNORMAL);
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
        if FileExists(S) then
        begin
          FileSetAttr(Pchar(S), 0);
          DeleteFile(S);
        end;
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
          AddToLogs('Load XML ' + Traite(S));
          PassTsl.loadFromFile(Traite(S));
          AddToLogs('Parsing de ' + Traite(S));
          Xml.LoadXML(PassTsl.Text);
          AddToLogs('Parsing OK ');
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
          Place := StrtoInt(Copy(S, 1, Pos(';', S) - 1));
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
  AddToLogs('Traitement_BATCH', logDebug);
  Tsl := TstringList.Create;
  LesVar := TstringList.Create;
  LesVal := TstringList.Create;
  LaPille := TstringList.Create;
  XML := TMonXML.Create;

  AddToLogs('Ouverture de ' + LeFichier);
  tsl.LoadFromFile(LeFichier);
  i := 0;
  TimeOut := false;
  PathOrdre := IncludeTrailingBackslash(ExtractFilePath(LeFichier));
  Temps := 0;

  MarqueurEai := -1;
  MarqueurNoeuds := -1;
  Lab_Fichier.Caption := 'Execution de ' + LeFichier;
  Lab_Fichier.Update;
  application.ProcessMessages;

  try
    Pb2.Max := tsl.count;
    Pb2.position := i + 1;
  except
  end;
  while i < tsl.count do
  begin
    Ordre := Uppercase(trim(tsl.Names[i]));
    AddToLogs('Execute ' + tsl[i]);
    Lab_Fichier.Caption := 'Execution de ' + LeFichier;
    Lab_Fichier.Update;
    application.ProcessMessages;

    try
      Pb2.Max := tsl.count;
      Pb2.position := i + 1;
    except
    end;
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
end;

procedure TFrm_Patch.Bout2Click(Sender: TObject);
begin
  AddToLogs('Bout2', logDebug);
  pc.ActivePage := VERIF1;
  tim_auto.tag := 3;
  if automatique then
    tim_auto.enabled := true;
end;

function TFrm_Patch.traiteversion(S: string): string;
var
  S1: string;
begin
  AddToLogs('traiteversion(' + s + ')', logDebug);
  result := '';
  while pos('.', S) > 0 do
  begin
    S1 := Copy(S, 1, pos('.', S));
    delete(S, 1, pos('.', S));
    while (Length(S1) > 2) and (S1[1] = '0') do
      delete(S1, 1, 1);
    result := result + S1;
  end;
  S1 := S;
  while (Length(S1) > 1) and (S1[1] = '0') do
    delete(S1, 1, 1);
  result := result + S1;
end;

procedure TFrm_Patch.Bout3Click(Sender: TObject);

  procedure ForceIbGuard();
  var
    Reg: TRegistry;
    sPathIbGuard: string;
//    vSL : TStringList;
  begin
//    vSL := TStringList.Create;
    try
//      Buffer := ChangeFileExt(LeNomLog, '_ForceIbGuard.log');
//      if FileExists(Buffer) then
//        vSL.LoadFromFile(Buffer);

      AddToLogs(GetNow + 'ForceIbGuard');

      if GetWindowsVersion in [wvW7, wvNewVersion] then
      begin
        // On exécute le process interbase
        Reg := TRegistry.Create(KEY_READ);
        try
          Reg.RootKey := HKEY_LOCAL_MACHINE;
          if Reg.OpenKey('SYSTEM\ControlSet001\Services\InterBaseGuardian\', False) then
          begin
            sPathIbGuard := Reg.ReadString('ImagePath');
            if FileExists(sPathIbGuard) then
            begin
              try
                ShellExecute(0, 'OPEN', PCHAR(sPathIbGuard), PCHAR(' -a'), PCHAR(ExtractFilePath(sPathIbGuard)), SW_SHOWNORMAL);
                AddToLogs(GetNow + 'Started processus');
            except
              on E: Exception do
              begin
                AddToLogs('ForceIbGuard : ' + E.Message, logError);
              end;
            end;
            end
            else
              AddToLogs(format('file "%s" don''t exist', [sPathIbGuard]));
          end;
        finally
          Reg.free;
        end;
      end;
    finally
//      vSL.SaveToFile(Buffer);
//      FreeAndNil(vSL);
    end;
  end;

  function GetInfoBase(out Centrale, Nom, NomPourNous, Sender : string) : boolean;
  var
    Openned : boolean;
    Retry : integer;
  begin
    Result := false;
    Centrale := '';
    Nom := '';
    NomPourNous := '';
    Sender := '';
    // tentative de connexion
    try
      if Data.Connected then
        Openned := true
      else
      begin
        Openned := False;
        Retry := 5;
        repeat
          try
            AddToLogs('Ouverture de la database:'+data.dataBaseName + '(GetInfoBase)') ;
            Data.Open();
          except
            on E: Exception do
            begin
              AddToLogs('Data.Open(' + IntToStr(Retry) + ') : ' + E.Message, logError);
              Sleep(10000);
            end;
          end;
          Dec(Retry);
        until Data.Connected or (retry <= 0);
      end;
      // si connecté alors ...
      if Data.Connected then
      begin
        try
          Que_Sql.SQL.Text := 'select bas_centrale, bas_nom, bas_nompournous, bas_sender '
                            + 'from genparambase '
                            + 'join genbases join k on k_id = bas_id and k_enabled = 1 on bas_ident = par_string '
                            + 'where par_nom = ''IDGENERATEUR''';
          try
            Que_Sql.Open();
            if not Que_Sql.Eof then
            begin
              Centrale := Que_Sql.FieldByName('bas_centrale').AsString;
              Nom := Que_Sql.FieldByName('bas_nom').AsString;
              NomPourNous := Que_Sql.FieldByName('bas_nompournous').AsString;
              Sender := Que_Sql.FieldByName('bas_sender').AsString;
              Result := true;
            end;
          finally
            Que_Sql.Close();
          end;
        except
          on e : Exception do
          begin
            Nom := E.ClassName + ' - ' + e.Message;
            AddToLogs(Nom, logError);
          end;
        end;
      end
      else
        Nom := 'Impossible de se connecté a la base de données.'
    finally
      if not Openned then
        Data.Close();
    end;
  end;

var
  TmLesFic: TmemoryStream;
  Frm_Verification: TFrm_Verification;
  connex: TLesConnexion;
  Retry : integer;
//  Log: TStringList;
begin
  AddToLogs('Bout3', logDebug);
  try
//    Log := TStringList.Create();

    Screen.Cursor := crhourglass;
    enabled := false;
    try
      RzLabel7.visible := true;
      Update;
      application.ProcessMessages;

      TmLesFic := TmemoryStream.Create;
      try
        TmLesFic.LoadFromFile(Ginkoia + 'LiveUpdate\' + Nom_Outil_Maj + '.GIN');
        TmLesFic.seek(0, soFromBeginning);
        AncVersion := ReadString(TmLesFic);
        AncNumero := ReadString(TmLesFic);
        NvlVersion := ReadString(TmLesFic);
        NvlNumero := ReadString(TmLesFic);
      finally
        TmLesFic.free;
      end;

      AddToLogs('Versions : ');
      AddToLogs(' - AncVersion : ' + AncVersion);
      AddToLogs(' - AncNumero  : ' + AncNumero);
      AddToLogs(' - NvlVersion : ' + NvlVersion);
      AddToLogs(' - NvlNumero  : ' + NvlNumero);

      // si lancement auto alors il y a eu reboot
      // il faut forcé interbase !
      if automatique then
      begin
        ForceIbGuard();
        Attente_IB();
      end;

      data.dataBaseName := LaBase;

      Retry := 5;
      repeat
        try
          AddToLogs('Ouverture de la database:'+data.dataBaseName+ '(Bout3Click)') ;
          Data.Open();
        except
          on E: Exception do
          begin
            AddToLogs('Data.Open(' + IntToStr(Retry) + ') : ' + E.Message, logError);
            Sleep(10000);
          end;
        end;
        Dec(Retry);
      until Data.Connected or (retry <= 0);

      Que_Version.Open;
      VersionEnCours := Que_VersionVER_VERSION.AsString;
      Que_Version.Close;

      FHasInfoBase := GetInfoBase(FCentrale, FNom, FNomPourNous, FGinSender);
      LesEai := tstringlist.Create;
      IBQue_EAI.Open;
      IBQue_EAI.first;
      while not IBQue_EAI.eof do
      begin
        Update;
        application.ProcessMessages;
        LesEai.Add(IBQue_EAIREP_PLACEEAI.AsString);
        IBQue_EAI.next;
      end;
      IBQue_EAI.close;

      ListeConnexion := Tlist.create;
      IB_Connexion.Open;
      IB_Connexion.First;
      while not IB_Connexion.Eof do
      begin
        connex := TLesConnexion.Create;
        connex.Id := IB_ConnexionCON_ID.AsInteger;
        connex.Nom := IB_ConnexionCON_NOM.AsString;
        connex.TEL := IB_ConnexionCON_TEL.AsString;
        connex.LeType := IB_ConnexionCON_TYPE.AsInteger;
        ListeConnexion.Add(connex);
        IB_Connexion.Next;
      end;
      IB_Connexion.Close;

      data.Close;
      VersionEnCours := traiteversion(VersionEnCours);
      if trim(VersionEnCours) <> trim(AncNumero) then
      begin
        AddToLogs('ERREUR : VersionEnCours <> AncNumero', logError);
        AddToLogs(' - VersionEnCours : ' + VersionEnCours, logError);
        AddToLogs(' - AncNumero      : ' + AncNumero, logError);

        RzLabel3.caption := Format(RzLabel3.caption, [AncVersion]);
        Deletefile(Ginkoia + 'LiveUpdate\' + Nom_Outil_Maj + '.GIN');
        Deletefile(Ginkoia + 'LiveUpdate\' + Nom_Outil_Maj + '.ZIP');
        pc.activepage := ERRVER;
        tim_auto.tag := 4;
        if automatique then
          tim_auto.enabled := true;

      end
      else
      begin
        Connexion;
        try
          Application.CreateForm(TFrm_Verification, Frm_Verification);
          try
            Frm_Verification.NewCRC := FnewCRC;
            if not Frm_Verification.Connexion then
            begin
              AddToLogs('ERREUR : Frm_Verification.Connexion', logError);

              pc.activepage := ERRCONN;
              tim_auto.tag := 5;
              if automatique then
                tim_auto.enabled := true;
            end
            else
              suite1;
          finally
            Frm_Verification.release;
          end;
        except
        end;
        Deconnexion;
      end;
    finally
      Screen.Cursor := CrDefault;
      enabled := true;
    end;
  finally
//    Log.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Verif-btn3-' + ChangeFileExt(ExtractFileName(ParamStr(0)), '.log'));
//    FreeAndNil(Log);
  end;
end;

procedure TFrm_Patch.SetBringDatabaseOnline;
//var
//  vSL: TStringList;
//  Buffer: string;
begin
//  vSL := TStringList.Create;
  try
//    Buffer := ChangeFileExt(LeNomLog, '_SetBringDatabaseOnline.log');
//    if FileExists(Buffer) then
//      vSL.LoadFromFile(Buffer);
    AddToLogs('SetBringDatabaseOnline.DatabaseName('+data.DatabaseName+')');
    IBConfigService.DatabaseName := data.DatabaseName;
    IBConfigService.Active := True;
    IBConfigService.BringDatabaseOnline;
    IBConfigService.Active := False;
    AddToLogs('SetBringDatabaseOnline');
//    vSL.Append(GetNow + 'SetBringDatabaseOnline');
  except
    on e:exception do
      AddToLogs('SetBringDatabaseOnline - Except : ' + e.Message, logError);
//    vSL.SaveToFile(Buffer);
//    FreeAndNil(vSL);
  end;
end;

procedure TFrm_Patch.SetShutdownDatabase;
//var
//  vSL: TStringList;
//  Buffer: string;
begin
//  vSL := TStringList.Create;
  try
//    Buffer := ChangeFileExt(LeNomLog, '_SetShutdownDatabase.log');
//    if FileExists(Buffer) then
//      vSL.LoadFromFile(Buffer);
    AddToLogs('SetShutdownDatabase.DatabaseName('+data.DatabaseName+')');

    IBConfigService.DatabaseName := data.DatabaseName;
    IBConfigService.Active := True;
    IBConfigService.ShutdownDatabase(Forced, 0);
    IBConfigService.Active := False;

    { La methode "ShutdownDatabase" prend quelques secondes, on effectue
      donc un DoWait }
    DoWait(3000);
//    vSL.Append(GetNow + 'SetShutdownDatabase');
    AddToLogs('SetShutdownDatabase');
  except
    on e:exception do
      AddToLogs('SetShutdownDatabase - Except : ' + e.Message, logError);
//    vSL.SaveToFile(Buffer);
//    FreeAndNil(vSL);
  end;
end;

function TFrm_Patch.StopServiceRepl: boolean;
var
  hSCManager: SC_HANDLE;
  hService: SC_HANDLE;
  Statut: TServiceStatus;
  tempMini: DWORD;
  CheckPoint: DWORD;
  Interbase7: Boolean;
  reg: Tregistry;
  S: string;
begin
  AddToLogs('StopServiceRepl', logDebug);
  result := false;
  reg := Tregistry.Create(KEY_READ);
  try
    reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey('\Software\Borland\Interbase\CurrentVersion', False);
    S := Reg.ReadString('Version');
  finally
    reg.free;
  end;
  Interbase7 := Copy(S, 1, 5) = 'WI-V7';
  if not Interbase7 then
    EXIT;
  hSCManager := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
  hService := OpenService(hSCManager, 'IBRepl', SERVICE_QUERY_STATUS or SERVICE_START or SERVICE_STOP or SERVICE_PAUSE_CONTINUE);
  if hService <> 0 then
  begin
    QueryServiceStatus(hService, Statut);
    if statut.dwCurrentState = SERVICE_RUNNING then
    begin
      tempMini := Statut.dwWaitHint + 10;
      ControlService(hService, SERVICE_CONTROL_PAUSE, Statut);
      repeat
        CheckPoint := Statut.dwCheckPoint;
        Sleep(tempMini);
        QueryServiceStatus(hService, Statut);
      until (CheckPoint = Statut.dwCheckPoint) or
        (statut.dwCurrentState = SERVICE_PAUSED);
      // si CheckPoint = Statut.dwCheckPoint Alors le service est dans les choux
      result := true;
    end;
  end;
  CloseServiceHandle(hService);
  CloseServiceHandle(hSCManager);
end;

procedure TFrm_Patch.suite1;
var
  Frm_Verification: TFrm_Verification;
  _Dep: string;
  _Arr: string;
  reg: Tregistry;
  refrepli: string;
begin
  AddToLogs('suite1)', logDebug);
  Screen.Cursor := crhourglass;
  enabled := false;
  try
    Update;
    application.ProcessMessages;

    Application.CreateForm(TFrm_Verification, Frm_Verification);
    try
      Frm_Verification.NewCRC := FnewCRC;
      Frm_Verification.de_a_version(_Dep, _Arr);
      if (_dep <> uppercase(AncVersion)) or
        (_arr <> uppercase(NvlVersion)) then
      begin
        AddToLogs('ERREUR : Frm_Verification.de_a_version', logError);
        AddToLogs(' - _dep       : ' + _dep, logError);
        AddToLogs(' - AncVersion : ' + AncVersion, logError);
        AddToLogs(' - _arr       : ' + _arr, logError);
        AddToLogs(' - NvlVersion : ' + NvlVersion, logError);
        
        pc.activepage := ERRVALID;
        tim_auto.tag := 6;
        if automatique then
          tim_auto.enabled := true;
      end
      else
      begin
        Frm_Verification.pbPhase:= pb_1;
        Frm_Verification.pbDetail := pb_2;
        Frm_Verification.lbVersion := fic;
        fic.Caption := '';
        RzLabel7.visible := true;
        pb1.Visible := true;
        pb2.Visible := true;
        fic.Visible := true;
        Frm_Verification.Automatique := false;
        try
          if not Frm_Verification.Verifielaversion() then
            Raise Exception.Create('Erreur de "Verifielaversion"');
          Frm_Verification.MetAJourlaversion();
        except
          on e : Exception do
          begin
            AddToLogs('ERREUR : Frm_Verification.MetAJourlaversion', logError);
            AddToLogs(' - ' + e.ClassName + ' - ' + e.Message, logError);

            RzLabel3.caption := Format(RzLabel3.caption, [AncVersion]);
            pc.activepage := ERRVER;
            tim_auto.tag := 4;
            if automatique then
              tim_auto.enabled := true;
            Exit;
          end;
        end;

        // Test pour les caisse autonome
        try
          reg := Tregistry.Create(KEY_READ);
          reg.Access := KEY_READ;
          Reg.RootKey := HKEY_LOCAL_MACHINE;
          reg.OpenKey('Software\Algol\Ginkoia', False);
          refrepli := reg.ReadString('REPL_REFERENCE');
        finally
          FreeAndNil(Reg);
        end;
        if trim(refrepli) <> '' then
        begin
          Que_Sql.Sql.Clear;
          Que_Sql.Sql.Add('Select rdb$GENERATOR_NAME NAME');
          Que_Sql.Sql.Add('From rdb$GENERATORS');
          Que_Sql.Sql.Add('Where rdb$GENERATOR_NAME= ''REPL_GENERATOR''');
          Que_Sql.Open;
          if not Que_Sql.isempty then
          begin
            Que_Sql.Close;
            Que_Sql.Sql.Clear;
            Que_Sql.Sql.Add('Select Count(*) from REPL_LOG');
            Que_Sql.Open;
            if Que_Sql.Fields[0].AsInteger > 0 then
            begin
              AddToLogs('ERREUR : Select Count(*) from REPL_LOG non 0', logError);
              AddToLogs(' - ' + IntToSTr(Que_Sql.Fields[0].AsInteger), logError);

              Que_Sql.Close;
              pc.activepage := PROBAUTONO;
              tim_auto.tag := 12;
              if automatique then
                tim_auto.enabled := true;

              EXIT;
            end;
            CaisseAutonome := true;
            Que_Sql.Close;
            StopServiceRepl;
          end;
          Que_Sql.Close;
        end;
        //

        if not Frm_Verification.BackupOk then
        begin
          AddToLogs('ERREUR : Backup pas ok', logError);
          AddToLogs(' - Backup : ' + BoolToStr(Frm_Verification.BackupOk, true), logError);

          pc.activepage := PROBBCK;
          tim_auto.tag := 11;
          if automatique then
            tim_auto.enabled := true;
        end
        else
        begin
          pc.activepage := INST;
          tim_auto.tag := 1;
          if automatique then
            tim_auto.enabled := true;
        end;
      end;
    finally
      Frm_Verification.release;
    end;
  finally
    Screen.Cursor := CrDefault;
    enabled := true;
  end;
end;

procedure TFrm_Patch.Bout5Click(Sender: TObject);
var
  Frm_Verification: TFrm_Verification;
  delay: Dword;
//  Log : TStringList;
begin
  AddToLogs('Bout5', logDebug);
  try
//    Log := TStringList.Create();

    Screen.Cursor := crhourglass;
    enabled := false;
    try
      RzLabel5.Caption := 'tentative de connexion';
      RzLabel1.Update;
      delay := GetTickCount;
      Application.CreateForm(TFrm_Verification, Frm_Verification);
      try
        Frm_Verification.NewCRC := FnewCRC;
        if not Frm_Verification.Connexion then
        begin
          while (GetTickCount - delay < 1000) do
            application.processmessages;
          RzLabel5.Caption := 'Impossible de se connecter, réessayez';
        end
        else
        begin
          RzLabel5.caption := '';
          pc.activepage := VERIF1;
          tim_auto.tag := 3;
          if automatique then
            tim_auto.enabled := true;

          suite1;
        end;
      finally
        Frm_Verification.release;
      end;
    finally
      enabled := true;
      Screen.Cursor := CrDefault;
    end;
  finally
//    Log.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Verif-btn5-' + ChangeFileExt(ExtractFileName(ParamStr(0)), '.log'));
//    FreeAndNil(Log);
  end;
end;

procedure TFrm_Patch.Bout1Click(Sender: TObject);
var
  Pourquoi: string;
  ok: Boolean;
  reg: TRegistry;
  S: string;
  TmLesFic: TmemoryStream;
  TMPass: TmemoryStream;
  I, J: Integer;
  tps, LastTps: DWord;
  LastVer: string;
  LastOk: Boolean;
  refrepli: string;

  Arch: I7zOutArchive;
  IndyStream: TFileStream;
  Hash32: TIdHashCRC32;

  QuelleLigne: string;
  tsl : TStringList;
begin
  AddToLogs('Bout1', logDebug);
  Screen.Cursor := crhourglass;
  enabled := false;
  try
    tsl := TStringList.Create;
    if FileExists(LeNomLog) then
      tsl.LoadFromFile(LeNomLog);
    bout1.hide;
    application.ProcessMessages;
    Pourquoi := '';
    OK := true;
    try
      Lab_Etat.Caption := 'ARRETS DES APPLICATION EN COURS';
      Update;
      if not arreterApplie then
      begin
        doclose := true;
        AddToLogs('Impossible d''arreter les services, on stop la MAJ', logError);
        Exit;
      end;
      JeStopService;

      Lab_Etat.Caption := 'MAJ en cours';
      Lab_Etat.Update;
      application.ProcessMessages;

      // Traitement
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
      Labase := S;
      S := ExcludetrailingBackSlash(ExtractFilePath(S));
      while s[length(S)] <> '\' do
        delete(S, length(S), 1);
      Ginkoia := S;

      if Ok then
      begin
        TmLesFic := TmemoryStream.Create;
        TMPass := TmemoryStream.Create;
        try
          try
            TmLesFic.LoadFromFile(Ginkoia + 'LiveUpdate\' + Nom_Outil_Maj + '.GIN');
            TmLesFic.seek(0, soFromBeginning);
            Pb1.Max := TmLesFic.Size * 2;
            AncVersion := ReadString(TmLesFic);
            AncNumero := ReadString(TmLesFic);
            NvlVersion := ReadString(TmLesFic);
            NvlNumero := ReadString(TmLesFic);
            if FileExists(LeNomLog) and testLog(LeNomLog) then
            begin
              AddToLogs('----------------------- ');
              AddToLogs('- retour état stable suite plantage (relancement de patch avec log en cours...) ');
              // retour à un état stable
              Pourquoi := 'retour état stable suite plantage (relancement de patch avec log en cours...)';
              Ok := false;
            end
            else
            begin
              Lab_Etat.Caption := 'Vérification du patch ';
              Lab_Etat.Update;
              application.ProcessMessages;

              Caption := ' MAJ De la version ' + AncVersion + ' à la version ' + NvlVersion;

  {$REGION '            Recherche des infos clients '}
              if FHasInfoBase then
              begin
                AddToLogs('----------------------- ');
                AddToLogs('- Centrale    : ' + FCentrale);
                AddToLogs('- Nom         : ' + FNom);
                AddToLogs('- NomPourNous : ' + FNomPourNous);
                AddToLogs('- Sender      : ' + FGinSender);
                AddToLogs('----------------------- ');
              end
              else
                AddToLogs('Erreur lors de la recupération des infos base : ' + FNom, logError);
  {$ENDREGION}

              AddToLogs('- MAJ Du ' + DateTimeToStr(Now));
              AddToLogs('- De la version ' + AncVersion + ' à la version ' + NvlVersion);
              AddToLogs('- Du Numéro ' + AncNumero + ' Au numéro ' + NvlNumero);
              AddToLogs('----------------------- ');
              AddToLogs('- Vérification du patch ');
            
              // Vérification des Check Sum
              while TmLesFic.Position < TmLesFic.Size do
              begin
                TmPass.Size := 0;
                try
                  Pb1.Position := TmLesFic.Position;
                except
                end;
                TmLesFic.Read(I, Sizeof(i));
                j := TmPass.CopyFrom(TmLesFic, i);
                if j <> i then
                begin
                  AddToLogs('- Problème sur le patch (erreur de concordance des tailles)', logError);
                
                  Pourquoi := 'Problème sur le patch (erreur de concordance des tailles)';
                  ok := false;
                  BREAK;
                end;

                I := VerifieLeCrc(TmPass, Ginkoia, FileNotify, FnewCRC);
                if I = CstTypeInconnue then
                  S := '- Problème sur le patch ' + FichierEnCours
                else if I and CstTypeCopy = CstTypeCopy then
                  S := '- Copie de ' + FichierEnCours
                else if I and CstTypePareil = CstTypePareil then
                  S := '- Fichier identique ' + FichierEnCours
                else if I and CstTypeMAJ = CstTypeMAJ then
                  S := '- Maj de ' + FichierEnCours
                else if I and CstTypeSUP = CstTypeSUP then
                  S := '- Suppression de ' + FichierEnCours
                else if I and $FF00 > 0 then
                  S := '- Autre traitement (??) sur ' + FichierEnCours;

                if I and CstErrCRCDest = CstErrCRCDest then
                  S := S + ' CRC pas OK (' + FichierEnCours + ')'
                else if I and $00FF > 0 then
                  S := S + ' Problème sur le patch (autres...)'
                else
                  S := S + ' Vérifié';
              
                AddToLogs(S);
              
                if I and $00FF > 0 then
                begin
                  // Problème
                  Lab_Etat.Caption := 'Problème impossible de faire la MAJ ';
                  Lab_Etat.Update;
                  application.ProcessMessages;

                  ok := false;
                  Pourquoi := S;
                  BREAK;
                end;
              end;
              if ok then
              begin
                // Maj
                Lab_Etat.Caption := 'Maj en cours ';
                Lab_Etat.Update;
                application.ProcessMessages;

                AddToLogs('----------------------- ');
                AddToLogs('- Lancement de la MAJ ' + DateTimeToStr(Now));
              
                // Vider le sauve precedent
                effacerfichier(Ginkoia + 'Sauve\');
                TmLesFic.seek(0, soFromBeginning);
                AncVersion := ReadString(TmLesFic);
                AncNumero := ReadString(TmLesFic);
                NvlVersion := ReadString(TmLesFic);
                NvlNumero := ReadString(TmLesFic);

                while TmLesFic.Position < TmLesFic.Size do
                begin
                  TmPass.Size := 0;
                  try
                    Pb1.Position := TmLesFic.Size + TmLesFic.Position;
                  except
                  end;
                  TmLesFic.Read(I, Sizeof(i));
                  j := TmPass.CopyFrom(TmLesFic, i);
                  if j <> i then
                  begin
                    AddToLogs('- Problème sur le patch (erreur de concordance des tailles)', logError);
                  
                    Pourquoi := 'Problème sur le patch (erreur de concordance des tailles)';
                    ok := false;
                    BREAK;
                  end;

                  I := Depatch(TmPass, Ginkoia + 'Sauve\', Ginkoia, PatchNotify, FileNotify, CopierFichier, lesEAI);
                  if I = CstTypeInconnue then
                    S := '- Problème sur le patch ' + FichierEnCours
                  else if I and CstTypeCopy = CstTypeCopy then
                    S := '- Copie de ' + FichierEnCours
                  else if I and CstTypePareil = CstTypePareil then
                    S := '- Fichier identique ' + FichierEnCours
                  else if I and CstTypeMAJ = CstTypeMAJ then
                  begin
                    S := '- Maj de ' + FichierEnCours;
                    if i and CstErrSauve = 0 then
                    begin
                      tsl.add('**' + FichierEnCours + ';' + CRCSauve);
                    
                    end;
                  end
                  else if I and CstTypeSUP = CstTypeSUP then
                  begin
                    S := '- Suppression de ' + FichierEnCours;
                    if i and CstErrSauve = 0 then
                    begin
                      tsl.add('**' + FichierEnCours + ';' + CRCSauve);

                    end
                  end
                  else if I and $FF00 > 0 then
                    S := '- Autre traitement (??) sur ' + FichierEnCours;

                  if I and CstErrCRCDest = CstErrCRCDest then
                    S := S + ' CRC pas OK'
                  else if I and CstErrMAJDate = CstErrMAJDate then
                    S := S + ' Problème de MAJ de la date'
                  else if I and CstErrSauve = CstErrSauve then
                    S := S + ' Problème de sauvegarde'
                  else if I and CstErrPatch = CstErrPatch then
                    S := S + ' Erreur sur le patch'
                  else if I and CstErrTaille = CstErrTaille then
                    S := S + ' Erreur sur la taille finale '
                  else if I and $00FF > 0 then
                    S := S + ' Problème sur le patch (autres...) '
                  else
                    S := S + ' Vérifié';

                  AddToLogs(S);
                
                  if (I and $00FF > 0) and (I and $00FF <> CstErrMAJDate) then
                  begin
                    // Problème
                    ok := false;
                    Pourquoi := S;
                    BREAK;
                  end;
                end;
              end;
            end;
          finally
            TmLesFic.Free;
            TMPass.Free;
          end;
        except
          on E: Exception do
          begin
            AddToLogs('Bout1.Click ... : ' + E.Message, logError);
            ok := false;
            raise;
          end;
        end;
      end;
      
      if Ok then
      begin
        // sauvegarde de la base
        Lab_Fichier.Caption := 'Sauvegarde de la base';
        Lab_Fichier.Update;
        Application.ProcessMessages;
        AddToLogs('----------------------- ');
        AddToLogs('Sauvegarde de la base');
        

        try
          if FileExists(Ginkoia + 'Sauve\BASES.IB') then
            RenameFile(Ginkoia + 'Sauve\BASES.IB', Ginkoia + 'Sauve\o_BASES.IB');

          if CopyFile(PAnsiChar(LaBase), PAnsiChar(Ginkoia + 'Sauve\BASES.IB'), false) then
            DeleteFile(Ginkoia + 'Sauve\o_BASES.IB')
          else
          begin
            // La copie n'a pas réussi retour en arrière
            DeleteFile(Ginkoia + 'Sauve\BASES.IB');
            RenameFile(Ginkoia + 'Sauve\o_BASES.IB', Ginkoia + 'Sauve\BASES.IB');
            Ok := False;
            Pourquoi := Format('Echec de la copie (sauvegarde base) (%d)', [GetLastError]);
          end;
        except
          on e: exception do
          begin
            Ok := false;
            Pourquoi := 'Pas de sauve de base';
            AddToLogs(Pourquoi + ' : ' + E.ClassName + ' - ' + e.Message, logError);
            AddToLogs('Dernière instruction : ' + QuelleLigne, logError);
            
          end;
        end;
      end;

      JeStartService;
      Attente_IB;

      if ok then
      begin
        // scripting
        Lab_Etat.Caption := 'Scripting des base';
        Lab_Etat.Update;
        application.ProcessMessages;
        AddToLogs('----------------------- ');
        AddToLogs('Lancement de script.exe ');
        

//        WinExec(Pchar(Ginkoia + 'Script.exe BASE'), 0);
        ShellExecute(0, 'open', PChar(Ginkoia + 'Script.exe'), PChar('BASE'), nil, SW_SHOWNORMAL);

        tps := GetTickCount + 60000;
        Update;
        application.ProcessMessages;

        // attente du démarage du script ;
        while (not MapGinkoia.Script) and (tps > GetTickCount) do
        begin
          Sleep(100);
        end;
        if MapGinkoia.Script then
        begin
          AddToLogs('Script.exe BASE : Started');
          Update;
          application.ProcessMessages;

          tsl.add('*? BASES;' + CRCSauve);
          
          LastTps := GetTickCount;
          LastVer := '';
          Lastok := false;
          try
            Pb2.Position := 0;
            Pb2.Max := VersionEnInt(AncNumero, NvlNumero);
          except
          end;
          while (MapGinkoia.Script) do
          begin
            if (LastVer = MapGinkoia.ScriptEnCours) and
              (GetTickCount - LastTps > 60000) then
              Lastok := true;
            if lastOk and (LastVer <> MapGinkoia.ScriptEnCours) then
            begin
              LastOk := false;
              AddToLogs('- Script ' + LastVer + ' prend ' + Inttostr(trunc((GetTickCount - LastTps) / 1000)) + ' Secondes');
              
            end;
            if LastVer <> MapGinkoia.ScriptEnCours then
            begin
              lastVer := MapGinkoia.ScriptEnCours;
              LastTps := GetTickCount;
              S := Uppercase(lastVer);
              if Pos('.GDB ', S) > 0 then
                delete(S, 1, Pos('.GDB ', S) + 4);
              if Pos('.IB ', S) > 0 then
                delete(S, 1, Pos('.IB ', S) + 3);
              if trim(S) <> 'ERREUR' then
              begin
                try
                  Pb2.Position := VersionEnInt(AncNumero, S);
                except
                end;
              end;
            end;
            Lab_Fichier.Caption := MapGinkoia.ScriptEnCours;
            Lab_Fichier.Update;
            application.ProcessMessages;

            Sleep(250);
          end;
          if MapGinkoia.ScriptOK then
          begin
            AddToLogs('- Script OK');
            
            ok := true;
          end
          else
          begin
            AddToLogs('- Problème sur le scripting', logError);
            AddToLogs('- ' + MapGinkoia.ScriptEnCours, logError);
            AddToLogs('- ' + MapGinkoia.ScriptErreur, logError);
            
            ok := false;
            Pourquoi := 'Scripting pas ok';


//            Lapplication := _SCRIPT;
//            EnumWindows(@Enumerate, 0);
            MapGinkoia.Script := false;
          end
        end
        else
        begin
          AddToLogs('- Script.exe ne ce lance pas !?!', logError);
          
          Ok := false;
          Pourquoi := 'Script.exe non lancé';
//          Lapplication := _SCRIPT;
//          EnumWindows(@Enumerate, 0);
          MapGinkoia.Script := false;
        end;
      end;

      if Ok then
      begin
        // migration de la v11.3 a la v13.X ??
        // - AncVersion : ancien numero de version
        // - NvlVersion : nouveau numero de version
        //   - AncNumero ??
        //   - NvlNumero ??
        if AncNumero = '11.3.0.9999' then
        begin
          AddToLogs('----------------------- ');
          AddToLogs('Migration depuis la 11.3 ');
          
          if not (ExecAndWaitProcess(Pourquoi, Ginkoia + 'EXE\MigreV13.exe', 'AUTO SITE') = 0) then
          begin
            AddToLogs('- ' + Pourquoi);
            
            Ok := false;
            //               Lapplication := _MIGREV13;
            //               EnumWindows(@Enumerate, 0);
            //               MapGinkoia.Script := false;
          end;
        end;
      end;

    finally
      if (not ok) and testLog(LeNomLog) then
      begin
        // retour à un état stable ;
        Lab_Etat.Caption := 'Retour à un état stable';
        Lab_Etat.Update;
        application.ProcessMessages;

        AddToLogs('Suite a erreur retour a l''etat anterieur ', logError);
        AddToLogs(Pourquoi, logError);
        tsl.SaveToFile(LeNomLog);
        retourStable;

        SendMail(RS_MAIL_SERVER, c_MAIL_PORT, RS_MAIL_DEV, RS_MAIL_MDP, tsm_TLS,
          RS_MAIL_DEV, RS_MAIL_ADMIN, 'Echec de ' + Application.ExeName + ' : ' + getNomBase,
          'ERREUR : ' + Pourquoi + #13#10#13#10, getCurrentLogFileName);

        SetBringDatabaseOnline;

        Application.CreateForm(TFrm_Verification, Frm_Verification);
        try
          Frm_Verification.NewCRC := FnewCRC;
          Frm_Verification.MAJplante(Pourquoi);
        finally
          Frm_Verification.release;
        end;
      end
      else if OK then
      begin
        AddToLogs('----------------------- ');
        AddToLogs('Lancement des ALG ');
        AddToLogs('======================= ');
        

        try
          if FileExists(Ginkoia + 'LiveUpdate\Algol.Alg') then
          begin
            if Traitement_BATCH(Ginkoia + 'LiveUpdate\Algol.Alg') then
            begin
              AddToLogs('======================= ');
              AddToLogs('- Execution de algol.alg réussie');
//              Log.ForceSaveToFile(LeNomLog);

              SendMail(RS_MAIL_SERVER, c_MAIL_PORT, RS_MAIL_DEV, RS_MAIL_MDP, tsm_TLS,
                RS_MAIL_DEV, RS_MAIL_ADMIN, 'Reussite de ' + Application.ExeName + ' : ' + getNomBase,
                '', getCurrentLogFileName);
            end
            else
            begin
              AddToLogs('======================= ');
              AddToLogs('- Execution de algol.alg raté');
//              Log.ForceSaveToFile(LeNomLog);

              OK := False;

              SendMail(RS_MAIL_SERVER, c_MAIL_PORT, RS_MAIL_DEV, RS_MAIL_MDP, tsm_TLS,
                RS_MAIL_DEV, RS_MAIL_ADMIN, 'Echec de ' + Application.ExeName + ' lors des ALG : ' + getNomBase,
                'ERREUR dans les ALG : ... (retour flase)' + #13#10#13#10, getCurrentLogFileName);
            end
          end;

          AddToLogs('----------------------- ');
          AddToLogs('SetBringDatabaseOnline  ');
          SetBringDatabaseOnline;
          AddToLogs('----------------------- ');
        except
          on e: exception do
          begin
            AddToLogs('======================= ');
            AddToLogs('- exception lors de l''execution de algol.alg', logError);
            AddToLogs('  ' + e.ClassName + ' - ' + e.Message);

            OK := False;

            SendMail(RS_MAIL_SERVER, c_MAIL_PORT, RS_MAIL_DEV, RS_MAIL_MDP, tsm_TLS,
              RS_MAIL_DEV, RS_MAIL_ADMIN, 'Echec de ' + Application.ExeName + ' lors des ALG : ' + getNomBase,
              'ERREUR dans les ALG : ' + e.ClassName + ' - ' + e.Message + #13#10#13#10, getCurrentLogFileName);
          end;
        end;

        if (NvlNumero = '11.3.0.9999') then
        begin
          AddToLogs('----------------------- ');
          AddToLogs('Mise a jour IB7 -> IBXE... ');
          AddToLogs('----------------------- ');
          
        end
        else
        begin
          Lab_Etat.Caption := 'VERIFICATION QUE VOTRE VERSION EST A JOUR';
          Update;
          application.ProcessMessages;

          AddToLogs('----------------------- ');
          AddToLogs('Lancement des procedure de verification ');
          

          Application.CreateForm(TFrm_Verification, Frm_Verification);
          try
            Frm_Verification.NewCRC := FnewCRC;
            Frm_Verification.Automatique := false;
            AddToLogs(' -> Verifielaversion ');
            
            Frm_Verification.Verifielaversion();
            AddToLogs(' -> MetAJourlaversion ');
            
            if not Frm_Verification.MetAJourlaversion() then
              AddToLogs(' -> MetAJourlaversion : FAIL');
          finally
            Frm_Verification.release;
          end;
        end;
      end;
    end;

    S := '';
    try
      reg := TRegistry.Create(KEY_READ);
      try
        // relancer le launcher si besoin
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
        S := reg.ReadString('Launch_Replication');
        // avec le registre
        if ((S <> '') and (FileExists(s))) then
        begin
          AddToLogs(format('Registry Start "%s"', [s]));
          ShellExecute(0, 'open', PChar(s), '', nil, SW_SHOWNORMAL);
        end
        else
        begin
          // si le fichier n'existe pas
          data.DatabaseName := LaBase ;
          AddToLogs('Ouverture de la database:'+data.dataBaseName+ '(Bout1Click 1)') ;
          data.Open;
          Que_Tmp.Close ;
          Que_Tmp.SQL.Text := 'SELECT PRM_STRING FROM GENPARAM WHERE PRM_TYPE = 80 AND PRM_CODE = 1' ;
          Que_Tmp.Open;
          // si replication EASY
          if (Que_Tmp.FieldByName('PRM_STRING').AsString <> '') then
          begin
            // si le fichier existe
            if FileExists(Ginkoia + _LauncherEasy) then
            begin
              // lancement du launcher easy
              AddToLogs(format('Start "%s"', [Ginkoia + _LauncherEasy]));
              ShellExecute(0, 'open', PChar(Ginkoia + _LauncherEasy), '', nil, SW_SHOWNORMAL);
            end
            else AddToLogs(format('File not exist "%s"', [Ginkoia + _LauncherEasy]), logError);
          end
          else
          begin
            // replication delos
            if FileExists(Ginkoia + _LaunchV7) then
            begin
              // lancement du launcher delos
              AddToLogs(format('Start "%s"', [Ginkoia + _LaunchV7]));
              ShellExecute(0, 'open', PChar(Ginkoia + _LaunchV7), '', nil, SW_SHOWNORMAL);
            end
            else AddToLogs(format('File not exist "%s"', [Ginkoia + _LaunchV7]), logError);
          end;
          Que_Tmp.Close;
          data.Close ;
        end;
        SrvManager.restartServices;
      finally
        reg.free;
      end;
    except
      on e:exception do
      begin
        AddToLogs('Registry - ' + e.Message, logError);
      end;
    end;

    if ok then
    begin
      // Mise a jour du flag UPDATED dans la base
      if Connexion then
      begin
        data.DatabaseName := LaBase ;
        AddToLogs('Mise a jour de l''indicateur dans la base : Version UPDATED') ;
        try
          AddToLogs('Ouverture de la database:'+data.dataBaseName+ '(Bout1Click 2)') ;
          data.Open ;
          Que_Tmp.Transaction.StartTransaction ;
          try
            Que_Tmp.Close ;
            Que_Tmp.SQL.Text := 'UPDATE GENPARAMBASE SET PAR_STRING=:STRING, PAR_FLOAT=:FLOAT WHERE PAR_NOM=:NOM' ;
            Que_Tmp.ParamCheck := true ;
            Que_Tmp.ParamByName('NOM').AsString  := 'VERIFICATION' ;
            Que_Tmp.ParamByName('FLOAT').AsFloat := Double(now) ;
            Que_Tmp.ParamByName('STRING').AsString := 'UPDATED' ;
            Que_Tmp.ExecSQL ;

            if Que_Tmp.RowsAffected < 1 then
            begin
              Que_Tmp.SQL.Text := 'INSERT INTO GENPARAMBASE (PAR_NOM, PAR_STRING, PAR_FLOAT) VALUES (:NOM, :STRING, :FLOAT)' ;
              Que_Tmp.ParamCheck := true ;
              Que_Tmp.ParamByName('NOM').AsString  := 'VERIFICATION' ;
              Que_Tmp.ParamByName('FLOAT').AsFloat := Double(now) ;

              Que_Tmp.ParamByName('STRING').AsString := 'UPDATED' ;
              Que_Tmp.ExecSQL ;
            end;

            Que_Tmp.Transaction.Commit ;
            AddToLogs('--> Ok');
            NettoyageLiveUpdate(AncVersion + '-' + NvlVersion);
          except
            on E:Exception do
            begin
                AddToLogs('Update/Insert GENPARAMBASE ' + e.message, logError);
                Que_Tmp.Transaction.Rollback ;
            end;
          end;
          data.Close ;
        except
          on E:Exception do
          begin
            AddToLogs('Database.Open('+data.DatabaseName+') Fail - ' + e.message, logError);
          end;
        end;
      end;
    end;

    if ok then
    begin
      if CaisseAutonome then
      begin
        Lab_Etat.Caption := 'Mise à jour de la caisse autonome';
        Lab_Etat.Update;
        application.ProcessMessages;

        reg := Tregistry.Create;
        try
          reg.Access := KEY_READ;
          Reg.RootKey := HKEY_LOCAL_MACHINE;
          reg.OpenKey('Software\Algol\Ginkoia', False);
          refrepli := reg.ReadString('REPL_REFERENCE');
          CopyFile(Pchar(Ginkoia + 'BaseAuto\GinkoiaRepl.IB'), Pchar(refrepli), False);
//          Winexec(Pchar(Ginkoia + 'ParamRepli.exe AUTO'), 0);
          ShellExecute(0, 'open', PChar(Ginkoia + 'ParamRepli.exe'), PChar('AUTO'), nil, SW_SHOWNORMAL);
          tps := GetTickCount + 60000;
          while not (MapGinkoia.PingStop) and (tps > GetTickCount) do
          begin
            Sleep(100);
          end;
          while (MapGinkoia.PingStop) do
          begin
            Sleep(5000);
          end;
        finally
          reg.free;
        end;
        pc.activepage := FINCAISSE;
        tim_auto.tag := 13;
        if automatique then
          tim_auto.enabled := true;

      end
      else
      begin
        pc.activepage := FINOK;
        tim_auto.tag := 9;
        if automatique then
          tim_auto.enabled := true;
      end;
    end
    else
    begin
      pc.activepage := FINNOK;
      tim_auto.tag := 10;
      if automatique then
        tim_auto.enabled := true;

    end;

    // nettoyage du repertoire
    if ok then
      CleanLiveUpdate();


    if (AncNumero = '11.3.0.9999') and (pc.activepage = FINOK) then
      DoRebootMachine(15);
  finally
    tsl.SaveToFile(LeNomLog);
    tsl.free;
    Screen.Cursor := CrDefault;
    enabled := true;
  end;
end;

procedure TFrm_Patch.Bout8Click(Sender: TObject);
begin
  AddToLogs('Bout8', logDebug);
  // Bout8 -> RETSTABLE

  Screen.Cursor := crhourglass;
  enabled := false;
  try
    RzLabel11.visible := true;
    bout8.visible := false;
    Lab_Etat := Label1;
    Lab_Etat.Caption := 'Retour à un état stable';
    Lab_Etat.visible := true;
    Lab_Etat.Update;
    application.ProcessMessages;

    retourStable;
    Application.CreateForm(TFrm_Verification, Frm_Verification);
    try
      Frm_Verification.newCRC := FnewCRC;
      Frm_Verification.MAJplante('retour état stable suite plantage');
    finally
      Frm_Verification.release;
    end;
    RzLabel11.visible := false;
    Lab_Etat.visible := false;
  finally
    enabled := true;
    Screen.Cursor := CrDefault;
  end;
  if not automatique then
    Application.messagebox('Traitement terminé, vous devez quitter l''aplication', ' Terminé', Mb_OK)
  else
  begin
    Close();
  end;
end;

procedure TFrm_Patch.fermerClick(Sender: TObject);
begin
  AddToLogs('fermerClick', logDebug);
  if automatique then
  begin
    if Sender = Bout4 then
      // Bout4 -> ERRVER
      SendMail(RS_MAIL_SERVER, c_MAIL_PORT, RS_MAIL_DEV, RS_MAIL_MDP, tsm_TLS,
        RS_MAIL_DEV, RS_MAIL_ADMIN, 'Echec de ' + Application.ExeName + ' : ' + getNomBase,
        'ERREUR : Bouton4; ERRVER; -> ' + RzLabel3.Caption,
        getCurrentLogFileName)
    else if Sender = Bout6 then
      // Bout6 -> ERRVALID
      SendMail(RS_MAIL_SERVER, c_MAIL_PORT, RS_MAIL_DEV, RS_MAIL_MDP, tsm_TLS,
        RS_MAIL_DEV, RS_MAIL_ADMIN, 'Echec de ' + Application.ExeName + ' : ' + getNomBase,
        'ERREUR : Bouton6; ERRVALID; -> ' + RzLabel6.Caption,
        getCurrentLogFileName)
    else if Sender = Bout11 then
      // Bout11 -> PROBBCK
      SendMail(RS_MAIL_SERVER, c_MAIL_PORT, RS_MAIL_DEV, RS_MAIL_MDP, tsm_TLS,
        RS_MAIL_DEV, RS_MAIL_ADMIN, 'Echec de ' + Application.ExeName + ' : ' + getNomBase,
        'ERREUR : Bout11; PROBBCK; -> ' + RzLabel14.Caption,
        getCurrentLogFileName)
    else if Sender = Bout12 then
      // Bout12 -> PROBAUTONO
      SendMail(RS_MAIL_SERVER, c_MAIL_PORT, RS_MAIL_DEV, RS_MAIL_MDP, tsm_TLS,
        RS_MAIL_DEV, RS_MAIL_ADMIN, 'Echec de ' + Application.ExeName + ' : ' + getNomBase,
        'ERREUR : Bouton12; PROBAUTONO; -> ' + RzLabel15.Caption,
        getCurrentLogFileName);

    // Bout7 -> RETSTABLE
    // Bout10 -> FINNOK     -> Géré !

    // Bout9 -> FINOK       -> Géré !
    // Bout13 -> FINCAISSE  -> Géré !
  end;

  Close();
end;

procedure TFrm_Patch.FormPaint(Sender: TObject);
begin
  if first then
  begin
    first := false;
    if doclose then
    begin
      // fermeture auto ???
      
      Close();
    end;
  end;
end;

function TFrm_Patch.getCurrentLogFileName: string;
var
  sLogFileName : string;
begin
  result := ExtractFilePath(getApplicationFileName) + 'logs' + PathDelim
                                + 'log_' + Log.App + '_' + Log.Inst + '_' + FormatDateTime('yyyy-mm-dd', now) + '.log';
end;

function TFrm_Patch.getNomBase: string;
var
  sOld : string;
  bOpen : boolean;
  ini : TIniFile;
begin
  result := '';
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'GinVer.ini');
  try
    if ini.SectionExists('BASE') then
    begin
      result := ini.ReadString('BASE', 'NOM', '');
    end
    else
    begin
      try
        sOld := que_Tmp.SQL.Text;
        bOpen := que_Tmp.Active;
        if not FileExists(Labase) then
        begin
          AddToLogs('La base n''existe pas:'+Labase+ '(getNomBase)') ;
          Exit;
        end;
        if FileExists(Data.DatabaseName) then
        begin
          if not Data.Connected then
          begin
            Data.DatabaseName := Labase;
            AddToLogs('Ouverture de la database:'+data.dataBaseName+ '(getNomBase)') ;
            Data.Open;
          end;
        end
        else
        begin
          try
            Data.Close;
          except
          end;
          Data.DatabaseName := Labase;
          AddToLogs('Ouverture de la database:'+data.dataBaseName+ '(getNomBase)') ;
          Data.Open;
        end;

        que_Tmp.close;
        que_Tmp.SQL.Clear;
        que_Tmp.SQL.Add('select BAS_ID, BAS_NOM');
        que_Tmp.SQL.Add('From (GENBASES join k on k_id=bas_id and k_enabled=1)');
        que_Tmp.SQL.Add('Join genparambase on (PAR_STRING= BAS_IDENT)');
        que_Tmp.SQL.Add('WHERE PAR_NOM = ''IDGENERATEUR'' ');
        que_Tmp.open;
        if que_Tmp.RecordCount > 0 then
        begin
          result := que_Tmp.FieldByName('BAS_NOM').AsString;
          ini.WriteString('BASE', 'NOM', result);
        end;
        que_Tmp.close;

        que_Tmp.SQL.Text := sOld;
        if bOpen then
          que_Tmp.open;
      except
        on e:exception do
          AddLog('getNomBase : ' + e.ClassName + ' - ' + e.Message, logError);
      end;
    end;
  finally
    FreeAndNil(ini);
  end;
end;

function TFrm_Patch.getNomPoste: string;
var
  MyComputerName : array[0..MAX_COMPUTERNAME_LENGTH] of Char;
  nSize          : DWord;
begin
  result := '';
  try
    nSize := SizeOf(MyComputerName);
    GetComputerName(@MyComputerName, nSize);

    result := MyComputerName;
  except
    on e:exception do
      AddLog(e.ClassName + ' - ' + e.Message, logError);
  end;
end;

function TFrm_Patch.GetNow: string;
begin
  Result := '[' + FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + '] ';
end;

function TFrm_Patch.GetWindowsVersion: TWVersion;
var
  sWin32Platform: string;
begin
  sWin32Platform := 'Win32Platform : ' + inttostr(Win32Platform) +
    ' -Maj. version : ' + inttostr(Win32MajorVersion) + ' -Min. version : ' +
    inttostr(Win32Platform);
  case Win32MajorVersion of
    3: Result := wvWOld; // 'Windows NT 3.51';
    4:
      case Win32MinorVersion of
        0:
          case Win32Platform of
            1:
              case Win32CSDVersion[1] of
                'A': Result := wvWOld; // 'Windows 95 SP 1';
                'B': Result := wvWOld; // 'Windows 95 SP 2';
              else
                Result := wvUnknown; //sWin32Platform;
              end;
            2: Result := wvWOld; // 'Windows NT 4.0'
          else
            Result := wvUnknown; // sWin32Platform;
          end;
        10:
          case Win32CSDVersion[1] of
            'A': Result := wvWOld; // 'Windows 98 SP 1';
            'B': Result := wvWOld; // 'Windows 98 SP 2';
          else
            // Result := 'Inconnue';
            Result := wvWOld; // sWin32Platform;
          end;
        90: Result := wvWOld; // 'Windows ME';
      else
        Result := wvUnknown; // sWin32Platform;
      end;
    5:
      case Win32MinorVersion of
        0: Result := wvW2k; //  'Windows 2000';
        1: Result := wvWXP; //  'Windows XP';
        2: Result := wvW2k3; //  'Windows 2003';
      else
        Result := wvUnknown; // sWin32Platform;
      end;
    6:
      case Win32MinorVersion of
        0: Result := wvWVista; // 'Vista';
        1: Result := wvW7; // 'Seven';
      else
        Result := wvUnknown; // sWin32Platform;
      end;
    7: Result := wvNewVersion; // 'Version ulterieure a Seven';
    8: Result := wvNewVersion; // 'Version ulterieure a Seven';
  else
    Result := wvUnknown; // sWin32Platform;
  end;
end;

procedure TFrm_Patch.Tim_AutoTimer(Sender: TObject);
begin
  //
  tim_auto.enabled := false;
  if not (doclose) then
  begin
    case tim_auto.tag of
      1: Bout1.OnClick(nil);
      2: Bout2.OnClick(nil);
      3: Bout3.OnClick(nil);
      4: Bout4.OnClick(nil);
      5: Bout5.OnClick(nil);
      6: Bout6.OnClick(nil);
      7: Bout8.OnClick(nil);
      9: Bout9.OnClick(nil);
      10: Bout10.OnClick(nil);
      11: Bout11.OnClick(nil);
      12: Bout12.OnClick(nil);
      13: Bout13.OnClick(nil);
    end;
  end;
end;

function TFrm_Patch.RestartAndRunOnce(AFileToRestart: string) : boolean;
var
  Reg : TRegistry;
  hToken, hProcess : THandle;
  tp, prev_tp : TTokenPrivileges;
  Len : DWORD;
begin
  Result := true;;
  try
    try
      reg := TRegistry.Create(KEY_ALL_ACCESS);
      reg.RootKey := HKEY_LOCAL_MACHINE;
      reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce', true);
      reg.WriteString('RESTARTAPP', AFileToRestart);
    finally
      FreeAndNil(reg);
    end;

    hProcess := OpenProcess(PROCESS_ALL_ACCESS, True, GetCurrentProcessID);
    if OpenProcessToken(hProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
    begin
      CloseHandle(hProcess);
      if LookupPrivilegeValue('', 'SeShutdownPrivilege', tp.Privileges[0].Luid) then
      begin
        tp.PrivilegeCount := 1;
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        if AdjustTokenPrivileges(hToken, False, tp, SizeOf(prev_tp), prev_tp, Len) then
        begin
          CloseHandle(hToken);

          ExitWindowsEx(EWX_FORCE or EWX_REBOOT, 0);
          HALT;
        end;
      end;
    end;
  except
    Result := false;
  end;
end;

function TFrm_Patch.DoRebootMachine(Time : cardinal) : boolean;
var
  hToken : THandle;
  tp, prev_tp : TTokenPrivileges;
  Len : DWORD;
begin
  if OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
  begin
    try
      if LookupPrivilegeValue('', 'SeShutdownPrivilege', tp.Privileges[0].Luid) then
      begin
        tp.PrivilegeCount := 1;
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        if AdjustTokenPrivileges(hToken, False, tp, SizeOf(prev_tp), prev_tp, Len) then
        else
          ; // Cannot change privileges -> GetLastError
      end
      else
        ; // Cannot get the LUID -> GetLastError
    finally
      CloseHandle(hToken);
    end;
  end
  else
    ; // Cannot open process token -> GetLastError

  Result := InitiateSystemShutdown('', 'Reboot suite a Patch', Time, true, true);
end;

end.

