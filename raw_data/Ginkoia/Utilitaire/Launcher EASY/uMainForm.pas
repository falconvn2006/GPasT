unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Vcl.ComCtrls, uLauncherCommun, uEventPanel,
  uLog, System.ImageList, Vcl.ImgList, uThreadDB, uThreadLog, uThreadWMI, DateUtils, Winapi.ShellAPI,
  Vcl.StdCtrls, Vcl.Buttons, System.Win.Registry, Vcl.AppEvnts, uClotureGrandsTotaux, {,Vcl.XPMan}
  uThreadOptimizeDB, uWsQtePull, System.Notification , uThreadLinkLame, Math, uWinVersion, uIdleTimer;

Const
  CST_ProgrammeCGT = 'ClotureGrandTotaux.exe';
  CST_CGTMinVersion = '17.2.0.9999';
  CST_CRON_OPTIM    = 6/24;

  // constantes des identifiants des tuiles
  CID_SERVICE_EASY = 0;
  CID_EASY_LOG = 1;
  CID_JAVA_VERSION = 2;
  CID_BACKREST = 3;
  CID_TRAFFIC_ASC = 4;
  CID_HEARTBEAT = 5;
  CID_PLAGEK = 6;
  CID_MAJ = 7;
  CID_MOBILITE = 8;
  CID_BI = 9;
  CID_DRIVES = 10;
  CID_VERIF = 11;
  CID_INFOS = 12;
  CID_NETTOIE = 13;
  CID_INTERBASE = 14;
  CID_CGT = 15; // Cloture Grands Totaux
  CID_PG = 16; // Postgreql Pour CA$H
  CID_SERVICEREPRISE = 17; // a FAIRE
  CID_PICCOBATCH = 18;
  CID_OPTIM = 21;          // SWEEP recalcul Index et prépurge SymDS
  CID_TRAFFIC_DESC = 23;
  CID_STOCK = 22;
  CID_CLOUD = 24;

  // Tuiles de la vue par défaut
  CID_SYNCHRONISATION = 19;
  CID_INFORMATION   = 25;
  CID_SYSTEME       = 20;

  Cst_TPSVerifBR = 30; // Temps en Minutes entre le Verif et le BackupRestore

type
  TFrm_Launcher = class(TForm)
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    pOuvrir: TMenuItem;
    N1: TMenuItem;
    pQuitter: TMenuItem;
    PnlSynchro: TPanel;
    sbar: TStatusBar;
    limMonitor: TImageList;
    tmDB: TTimer;
    tmLOG: TTimer;
    tmWMI: TTimer;
    PnlSysteme: TPanel;
    tmSTARTED: TTimer;
    PnlProgrammes: TPanel;
    BitBtn2: TBitBtn;
    PageControl: TPageControl;
    TabDetails: TTabSheet;
    TabMain: TTabSheet;
    PnlEtatSynchro: TPanel;
    LblRetour: TLabel;
    LblPlus: TLabel;
    limMonitor64: TImageList;
    PnlMainBot: TPanel;
    PanelMainMid: TPanel;
    NotificationCenter1: TNotificationCenter;
    lbl_EASY_TITLE: TLabel;
    lbl_EASY_DETAILS: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pQuitterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pOuvrirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure tmDBTimer(Sender: TObject);

    procedure CallBackThreadWMI(Sender: TObject);
    procedure CallBackThreadDB(Sender: TObject);
    procedure CallBackThreadLOG(Sender: TObject);
    procedure CallBackOptimizeDB(Sender: TObject);
    procedure CallBackWSQtePULL(Sender: TObject);
    procedure CallBackLinkLame(Sender: TObject);

    procedure MyClick(Sender: TObject);
    procedure ShowNotification(aTitle:string;aBody:string);

    procedure tmLOGTimer(Sender: TObject);
    procedure tmWMITimer(Sender: TObject);
    procedure BINFOClick(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure tmSTARTEDTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LblPlusClick(Sender: TObject);
    procedure LblRetourClick(Sender: TObject);
  private
    FIdleTimer    : TIdleTimer;
    FStartTime: TDateTime;
    FWinVersion   : TWinVersion;
    FCanShowNotif : Boolean;
    FForceKill    : Boolean;
    {
      FTaskBackupRestore : TTask ;   // <---- faudra plutot utiliser ca que plein de variables plus bas..
      FTaskVerification  : TTask ;
    }

    FCanClose: Boolean;
    FLOCKINFO: Boolean;
    FOptimizeDB : TOptimizeDB;

    // Nombre d'erreur Lame Injoignable
    FNbErrorLame : Integer;
    FNbOkLame    : integer;
    FIntLockAction : integer;

    FLastOptimizeDB: TDateTime;

    FURL : string;
    FWMI: TThreadWMI;
    FLog: TThreadLOG;
    FDBINFO: TThreadDB;
    FEvalQtePull  : TThreadWsQtePull;
    FLinkLame     : TThreadLinkLame;

    FNode          : string;
    FNode_Group_ID : string;
    FVersionDB     : string;

    FPARAM_11_60: TGENPARAM;
    FPARAM_81_1: TGENPARAM;
    FPARAM_60_1: TGENPARAM;
    FPARAM_60_3: TGENPARAM;
    FPARAM_60_6: TGENPARAM; // paramètre qui définit si on est sur le nouveau système de MAJ via les tools
    FPARAM_60_8: TGENPARAM; // paramètre pour le chemin de stockage de l'archivage
    FPARAM_3_36: TGENPARAM; // paramètre du nom machine du serveur
    FPARAM_9_414: TGENPARAM; // paramètre du lancement automatique de PiccoBatch

    // Last_NettoieGinkoia  : TDateTime;
    // Last_Verification    : TDateTime;
    // Last_VerificationMAJ : TDateTime;

    FBase0Size: integer; // taille de la base 0 en Mo

    // FNbLancementBackRest : Integer;
    FBRDernier: TDateTime; // pas utilisé
    FBasNOMPOURNOUS: string; // BAS_NOMPOURNOUS
    FDBFirstPass: Boolean; // la première passe Database est spéciale
    FTimerFirstPass: Boolean; // certains traitements ne doivent ce faire qu'une fois après le lancement du launcher
    FBasGUID: string; // GUID de la base récupérée à la première passe
    FBASID: string; // BASID de la base récupéré à la première passe;
    FBasMagID: string; //
    FIsBaseProd: Boolean;

    // AJ pour savoir si on à déjà fait la maj des genparam de baseSize et d'archivage, vérifié dans le timer tmSTARTED
    FDateLastBaseSizesArchivage: integer;

    // AJ pour savoir si on à déjà fait la maj de verification.exe, vérifié dans le timer tmSTARTED
    FdateLastMAJverif: integer;

    // AJ pour savoir si on à déjà fait la cloture des grandtotaux, vérifier dans le timer tmSTARTED
    FDateLastCloture: integer;

    // bmpRange          : Array[0..2] of TBitmap ;
    FLastCGT: TDateTime;

    // AJ pour savoir si on à déjà fait la fusion des modèles, à faire une fois par jour
    FLastFusion: TDateTime;

    FOPTIM_CRON_HR : double;

    FBackRestTime: TPlanifTime;
    FVerifTime: TPlanifTime; // Verification,

    FBackRestEnd: Boolean; // false : c'est pas fini ou on ne sait pas /  True on a fini
    FBackRestRunning: shortInt; // -1 on sait pas    / 0= il tourne pas / 1=il tourne

    FEASYLog: TFileName;
    FEasyRunning: shortInt; // -1 on sait pas    / 0= il tourne pas / 1=il tourne

    FVerifRunning: shortInt; // -1 on sait pas    / 0= il tourne pas / 1=il tourne

    // function IsHeureBackupRestore():Boolean;
    function IsHeureVerification(): Boolean;
    function LanceBackRest(): Boolean;
    function LanceCGT(): Boolean;
    function LanceNettoieGinkoia(): Boolean;
    function LanceOptimisation(): Boolean;
    procedure EvalEasyMissingDatas();
    procedure EtatLiaisonLame();


    function EstCeQueJeSuisUnServeur():Boolean;
    // Est-ce que je suis un Portable ?
    function EstCeQueJeSuisUnPortable():Boolean;
    function EstCeQueJeSuisUnPortableDeSynchro():boolean;

    function LanceVerification(const aParam: string = ''): Boolean;
    function LanceSynchroPortablesEASY(): Boolean;


    function LoadIniDateTime(aKey: string): TDateTime;

    procedure LoadInitParams();
    procedure SaveInitParams();
    // function MAJVerification(): boolean;
    procedure SetBackRestTime(aValue: TPlanifTime);
    procedure DoLogServices(aServiceTitle, aLogMdl, aLogKey: string; aLogType: TLogType = ltServer; aLogFreq: integer = 0);
    procedure RedimLauncher;
    procedure LaunchPiccoAuto;
    procedure LanceFusion;
    procedure StartAutoRegistry;
    function updateVerification: Boolean;
    procedure FIdleTimerTimer(Sender: TObject);
    procedure DefaultHandler(var Msg); override;


    { Déclarations privées }
  public
    ListPanels: array [0 .. 5] of TPanel;
    EventPanel: Array [0 .. 25] of TEventPanel;

    procedure UpdateVerif();
    procedure SaveIniDateTime(aKey: string; aDateTime: TDateTime);
    // procedure MajMobilite(status : word);
    property VersionDB: string read FVersionDB write FVersionDB;

    property BasGUID: string read FBasGUID write FBasGUID;
    property BASID: string read FBASID write FBASID;
    property IsBaseProd: Boolean read FIsBaseProd write FIsBaseProd;
    property BasMAGID: string read FBasMagID write FBasMagID;
    property PARAM_11_60: TGENPARAM read FPARAM_11_60 write FPARAM_11_60;
    property PARAM_81_1: TGENPARAM read FPARAM_81_1 write FPARAM_81_1;
    property PARAM_60_1: TGENPARAM read FPARAM_60_1 write FPARAM_60_1;
    property PARAM_60_3: TGENPARAM read FPARAM_60_3 write FPARAM_60_3;
    property PARAM_60_6: TGENPARAM read FPARAM_60_6 write FPARAM_60_6;
    property PARAM_60_8: TGENPARAM read FPARAM_60_8 write FPARAM_60_8;
    property PARAM_3_36: TGENPARAM read FPARAM_3_36 write FPARAM_3_36;
    property PARAM_9_414: TGENPARAM read FPARAM_9_414 write FPARAM_9_414;

    property BasNOMPOURNOUS: string read FBasNOMPOURNOUS write FBasNOMPOURNOUS;

    property Base0Size: integer read FBase0Size write FBase0Size;

    property EASYRunning: shortInt read FEasyRunning write FEasyRunning;
    property EasyLog: TFileName read FEASYLog write FEASYLog;

    property BackRestRunning: shortInt read FBackRestRunning write FBackRestRunning;
    property BackRestEnd: Boolean read FBackRestEnd write FBackRestEnd;
    property BRDernier: TDateTime read FBRDernier write FBRDernier;
    property BackupTime: TPlanifTime read FBackRestTime write SetBackRestTime;

    /// ------------------------------------------------------------------------
    property VerifRunning: shortInt read FVerifRunning write FVerifRunning;
    property VerifTime: TPlanifTime read FVerifTime write FVerifTime;
    property LOCKINFO: Boolean read FLOCKINFO write FLOCKINFO;

    { Déclarations publiques }
  end;

var
  Frm_Launcher: TFrm_Launcher;
  Msg_Sys_Kill_LauncherEasy : UINT; // Message recherché

  // ThreadSrvCheckStatusMobilite : TThreadSrvCheckStatusMobilite;

implementation

USes UWMI, Infos_Frm, ServiceControler, ExeControler, LaunchProcess, System.IniFiles, WinSvc,
  uExecNettoieGinkoia, uUpdateDB, uArchivage;

{$R *.dfm}

procedure TFrm_Launcher.DefaultHandler;
begin
  inherited DefaultHandler(Msg);
  if (TMessage(Msg).Msg=Msg_Sys_Kill_LauncherEasy) then
    begin
      TrayIcon1.Visible:=false;
      FForceKill := True;
      pQuitterClick(Self);
      // Application.Terminate; // On ferme l'application
    end;
end;

function TFrm_Launcher.EstCeQueJeSuisUnServeur():boolean;
begin
    Result := Pos('s',FNode)=1;
end;

function TFrm_Launcher.EstCeQueJeSuisUnPortable():boolean;
begin
    result := false;
    if Pos('p',FNode)=1 then Result := true;
end;

function TFrm_Launcher.EstCeQueJeSuisUnPortableDeSynchro():boolean;
begin
    result := false;
    If (FNode_Group_ID='portables')
       then Result := true;
end;

procedure TFrm_Launcher.SetBackRestTime(aValue: TPlanifTime);
begin
  FBackRestTime := aValue;
  FVerifTime.Prochain := aValue.Prochain - Cst_TPSVerifBR / MinsPerDay;
  UpdateVerif();
end;

procedure TFrm_Launcher.LoadInitParams();
var
  appINI: TIniFile;
begin
  appINI := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    FBasGUID := appINI.ReadString('BASE', 'GUID', '');
    FBasMagID := appINI.ReadString('BASE', 'BASMAGID', '');
    FBASID := appINI.ReadString('BASE', 'BASID', '');

    // Fréquence de lancement des Threads... après le 1er appel
    // on pose/recup l'interval dans le TAG du Timer

    tmDB.Tag := appINI.Readinteger('LauncherEASY', 'tmDB', 60); // Toutes les minutes
    tmLOG.Tag := appINI.Readinteger('LauncherEASY', 'tmLOG', 30); // Toutes les 30 s
    tmWMI.Tag := appINI.Readinteger('LauncherEASY', 'tmWMI', 20); // Toutes les 20 s

    // pas moins de 10s
    tmDB.Enabled := (tmDB.Tag >= 10) and (tmDB.Tag <= 1000);
    tmLOG.Enabled := (tmLOG.Tag >= 10) and (tmLOG.Tag <= 1000);
    tmWMI.Enabled := (tmWMI.Tag >= 10) and (tmWMI.Tag <= 1000);

    { Last_NettoieGinkoia  := StrToDateTimeDef(appINI.ReadString('LauncherEASY','NettoieGinkoia',''),0);
      Last_Verification    := StrToDateTimeDef(appINI.ReadString('LauncherEASY','Verification',''),0);
      Last_VerificationMAJ := StrToDateTimeDef(appINI.ReadString('LauncherEASY','VerificationMAJ',''),0);
    }
  finally
    appINI.Free;
  end;
end;

procedure TFrm_Launcher.SaveInitParams();
var
  appINI: TIniFile;
begin
  appINI := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    if FBasGUID <> '' then
      appINI.WriteString('BASE', 'GUID', FBasGUID);
    if FBasMagID <> '' then
      appINI.WriteString('BASE', 'BASMAGID', FBasMagID);
    if FBASID <> '' then
      appINI.WriteString('BASE', 'BASID', FBASID);

    appINI.WriteInteger('LauncherEASY', 'tmDB', tmDB.Tag);
    appINI.WriteInteger('LauncherEASY', 'tmLOG', tmLOG.Tag);
    appINI.WriteInteger('LauncherEASY', 'tmWMI', tmWMI.Tag);

  finally
    appINI.Free;
  end;
end;

function TFrm_Launcher.LoadIniDateTime(aKey: string): TDateTime;
var
  appINI: TIniFile;
  // vstring :string;
begin
  appINI := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  try
    result := StrToDateTimeDef(appINI.ReadString('LauncherEASY', aKey, ''), 0);
  finally
    appINI.Free;
  end;
end;

procedure TFrm_Launcher.SaveIniDateTime(aKey: string; aDateTime: TDateTime);
var
  appINI: TIniFile;
begin
  appINI := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  try
    appINI.WriteString('LauncherEASY', aKey, DateTimeToStr(aDateTime));
  finally
    appINI.Free;
  end;
end;


function TFrm_Launcher.LanceSynchroPortablesEASY(): Boolean;
var vPath:string;
    vFilename:TFileName;
begin
  result := false;
  vPath := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(VGSE.Base0)));

  vFilename := vPath + 'SynchroEasy.exe';

  IF FileExists(vFilename) THEN
  BEGIN
    Log.Log('Main', BasGUID, 'SynchroEasy', 'Démarrage de SynchroEASY.exe', logInfo, True, 0, ltLocal);
    if FileExists(vFilename) then
    begin
      Log.Log('Main', BasGUID, 'SynchroEasy', 'Execution de ' + vFilename + ' AUTO', logInfo, True, 0, ltServer);

      ShellExecute(Handle, 'Open', PWideChar(vFilename), PWideChar('AUTO'), Nil, SW_SHOWDEFAULT);

      result := true;
    end
    else
    begin
      Log.Log('Main', BasGUID, 'SynchroEasy', 'SynchroEASY.exe non trouvé', logError, True, 0, ltServer);
    end;


  END;
end;


function TFrm_Launcher.LanceVerification(const aParam: string = ''): Boolean;
var
  vParam: string;
  vFilename: string;
  vPath: string;
  vError: string;
  vReturn: integer;
begin
  result := False;
  if BasGUID = '' then
    exit;
  // Si on est en alert sur BASE0 on ne lance pas verification
  if VGSE.AttentionBase0 then
  begin
    Log.Log('Main', BasGUID, 'LanceVerification', 'Mauvaise Base0', logInfo, True, 0, ltLocal);
    exit;
  end;

  // Path : ==> DOTO Fonction de Base0 ? plutot non ? ou du chemin du Launcher ?
  // IF FileExists('C:\Ginkoia\ginkoia.ini') THEN
  // vPath := 'C:\Ginkoia\'
  // ELSE IF FileExists('D:\Ginkoia\ginkoia.ini') THEN
  // vPath := 'D:\Ginkoia\';

  // AJ : modifié en fonction du chemin de la base0
  vPath := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(VGSE.Base0)));

  vFilename := vPath + 'verification.exe';

  IF FileExists(vFilename) THEN
  BEGIN
    FVerifRunning := 1;
    vParam := aParam;
    Log.Log('Main', BasGUID, 'Verif', 'Démarrage de vérification.exe', logInfo, True, 0, ltLocal);
    if FileExists(vFilename) then
    begin
      Log.Log('Main', BasGUID, 'Verif ' + vParam, 'Execution de ' + vFilename + ' ' + vParam, logInfo, True, 0, ltServer);
      // faut ecrire dans un fichier.ini
      SaveIniDateTime('Verification' + aParam, Now());
      vReturn := ExecAndWaitProcess(vError, vFilename, vParam, True, vPath);
      Log.Log('Main', BasGUID, 'Verif ' + vParam, 'Verification a retourné ' + IntToStr(vReturn), logInfo, True, 0, ltServer);
    end
    else
    begin
      Log.Log('Main', BasGUID, 'Verif ' + vParam, 'Verification.exe non trouvé', logError, True, 0, ltServer);
    end;

    // Mise à jour des variables
    if aParam = 'MAJ' then
    begin
      // Last_VerificationMAJ := LoadIniDateTime('VerificationMAJ');
      EventPanel[CID_VERIF].Level := LogNotice;
    end;
    if aParam = '' then
    begin
      EventPanel[CID_VERIF].Level := LogNotice;
      FVerifTime.Dernier := LoadIniDateTime('Verification');
      // Last_Verification   := FVerifTime.Dernier;
    end;
    UpdateVerif();
    result := True;
  end;
end;

procedure TFrm_Launcher.UpdateVerif();
begin
  // Plusieurs cas....
  // Dernière fois qu'on a fait le VERIF sans paramètre
  FVerifTime.Dernier := LoadIniDateTime('Verification');
  // Le prochain est sensé etre un jour plus tard...

  if SecondsBetween(FVerifTime.Dernier, Now()) > 86400 then
    EventPanel[CID_VERIF].Level := logWarning
  else
    EventPanel[CID_VERIF].Level := logInfo;

  If (FVerifTime.Prochain + 5 / MinsPerDay < Now()) then
    FVerifTime.Prochain := FVerifTime.Prochain + 1;

  EventPanel[CID_VERIF].Hint := '';
  EventPanel[CID_VERIF].Detail := ' ';
  if FVerifTime.Dernier > 0 then
  begin
    EventPanel[CID_VERIF].Detail := FormatDateTime('dd/mm/yyyy HH:mm', FVerifTime.Dernier);
    EventPanel[CID_VERIF].Hint := 'Dernier  : ' + FormatDateTime('dd/mm/yyyy HH:mm', FVerifTime.Dernier) + #13 + #10;
  end;

  EventPanel[CID_VERIF].Hint := EventPanel[CID_VERIF].Hint + 'Prochain : ' + FormatDateTime('dd/mm/yyyy HH:mm', FVerifTime.Prochain);

  {
    eventPanel[CID_NETTOIE].Hint   := '';
    eventPanel[CID_NETTOIE].Detail := ' ';
    If Last_NettoieGinkoia>0
    then
    begin
    eventPanel[CID_NETTOIE].Detail  := FormatDateTime('dd/mm/yyyy HH:mm',Last_NettoieGinkoia);
    if SecondsBetween(Last_NettoieGinkoia,Now())>86400
    then eventPanel[CID_NETTOIE].Level   := logWarning
    else eventPanel[CID_NETTOIE].Level   := logInfo;
    end;
  }
end;

function TFrm_Launcher.LanceBackRest(): Boolean;
var
  vPath: string;
begin
   // Si c'est un portable....
   // if Pos('p',FNode)=1 then

  result := False;
  Log.Log('Main', BasGUID, 'LanceBackRest', 'Start', logInfo, True, 0, ltLocal);
  if VGSE.AttentionBase0 then
  begin
    Log.Log('Main', BasGUID, 'LanceBackRest', 'Mauvaise Base0', logWarning, True, 0, ltLocal);
    exit;
  end;

  // Path : ==> DOTO Fonction de Base0 ? plutot non ? ou du chemin du Launcher ?
  IF FileExists('C:\Ginkoia\ginkoia.ini') THEN
    vPath := 'C:\Ginkoia\'
  ELSE IF FileExists('D:\Ginkoia\ginkoia.ini') THEN
    vPath := 'D:\Ginkoia\';
  IF FileExists(vPath + 'BackRest.Exe') THEN
  BEGIN
    FBackRestRunning := 1; // Il va théoriquement tourner donc...
    FBRDernier := Now();
    EventPanel[3].Level := LogNotice;
    EventPanel[3].Detail := 'Lancement...';
    // Log.Log('Main', BasGUID, 'LanceBackRest1', FormatDateTime('dd/mm/yyyy hh:nn:ss',Now()), logInfo, True, 0, ltLocal);
    // Log.Log('Main', BasGUID, 'LanceBackRest2', FormatDateTime('dd/mm/yyyy hh:nn:ss',FBackRestTime.Prochain), logInfo, True, 0, ltLocal);
    Log.Log('BackupRestore', BasGUID, 'dteLast', DateTimeToIso8601(FBRDernier), logInfo, True, 0, ltServer);
    ShellExecute(Handle, 'Open', PWideChar(vPath + 'BackRest.Exe'), PWideChar('AUTO'), Nil, SW_SHOWDEFAULT);
    result := True;
  end
  else
  begin
    Log.Log('BackupRestore', BasGUID, 'dteLast', '', logError, True, 0, ltServer);
  end;
end;

function TFrm_Launcher.IsHeureVerification(): Boolean;
var
  delta: integer;
begin
  result := False;
  if (FVerifRunning = 0) then
  begin
    // Log.Log('Main', BasGUID, 'Log', 'IsHeureVerification(1)', logInfo, True, 0, ltLocal);

    if VerifTime.Prochain < 100 then
      exit; // Evite les trucs merdiques 1er passage à 30/12/1899 date 0

    // Nombre de minutes avec le dernier... si on est dans la plage Verif/BR faut passer qu'une seule fois..

    delta := MinutesBetween(Now(), VerifTime.Dernier);
    if delta <= Cst_TPSVerifBR then
      exit; // Evite les Bouclages sans arret de lancement de verification et verification MAJ

    delta := MinutesBetween(Now(), VerifTime.Prochain); // secondeBetween revoie toujours positif !
    if (Now() > VerifTime.Prochain) and (delta <= Cst_TPSVerifBR) // plus grand et jusqu'a 5 minutes
    then
    begin
      Log.Log('Main', BasGUID, 'Log', 'IsHeureVerification', logInfo, True, 0, ltLocal);
      If LanceVerification() then
      begin
        LanceVerification('MAJ');
        result := True;
      end;
      // LanceNettoie();
    end;
  end;
end;

// function TFrm_Launcher.IsHeureBackupRestore():Boolean;
// var delta:integer;
// vMyTime :TDateTime;
// begin
// Result := false;

{
  // vMyTime := BackupTime.Prochain;   // Date + EncodeTime(15,45,0,0);
  // Si c'est bientot l'heure de la MAJ on va arreter l'autre
  if secondsBetween(Now(),vMyTime)<300 // secondes Between retourne toujours qqchose de positif
  then
  begin
  if (Now()>vMyTime) and not(FBRDone)
  then
  begin
  result:=true;
  FBRDone :=true;
  end;
  end
  else
  begin
  FBRDone := false;  // Pour Que ca repasse demain
  end;
}
// Log.Log('Main', BasGUID, 'Log', 'IsHeureBackupRestore' + DateTimeToStr(BackupTime.Prochain), logInfo, True, 0, ltLocal);
// Si c'est l'heure mais qu'il tourne déjà on ne fait rien
// >>  ne depend maintenant que de que WMI
// Si on trouve un programme BackRest.Exe dans les processus on passe FBackRestRunning à true
{
  if BackupTime.Prochain<100 then exit;   // Evite les trucs merdiques 1er passage à 30/12/1899 date 0
  // Log.Log('Main', BasGUID, 'Log', 'IsHeureBackupRestore[2]', logInfo, True, 0, ltLocal);
  if (FBackRestRunning=0) and ((FBRDernier=0) or (SecondsBetween(Now(),FBRDernier)>300))  // 5 Minutes
  then
  begin
  // Log.Log('Main', BasGUID, 'Log', 'IsHeureBackupRestore[3]', logInfo, True, 0, ltLocal);
  Delta := SecondsBetween(Now(), BackupTime.Prochain); // secondeBetween revoie toujours positif !
  if (Now()>BackupTime.Prochain) and (delta<300) // plus grand et jusqu'a 5 minutes
  then
  begin
  // Log.Log('Main', BasGUID, 'Log', 'IsHeureBackupRestore[4]', logInfo, True, 0, ltLocal);
  If (FEasyRunning=0)
  then
  begin
  // Log.Log('Main', BasGUID, 'Log', 'IsHeureBackupRestore[5]', logInfo, True, 0, ltLocal);
  LanceBackRest();
  result:=true;
  end;
  If (FEasyRunning=1)
  then
  begin
  // Log.Log('Main', BasGUID, 'Log', 'IsHeureBackupRestore[6]', logInfo, True, 0, ltLocal);
  ServiceStop('','EASY');
  end;
  end;
  end;
}
// end;

procedure TFrm_Launcher.FormActivate(Sender: TObject);
begin
  // ShowWindow(Application.Handle, SW_HIDE);  GR 12/09/2017
end;

procedure TFrm_Launcher.CallBackThreadLOG(Sender: TObject);
begin
  FLog := nil;
  tmLOG.Enabled := True;
end;

procedure TFrm_Launcher.CallBackThreadWMI(Sender: TObject);
var
  I, freeSpaceRestauration, freeSpaceStockage: integer;
  delta: Int64;
  // vProcheBR : Boolean;
  vLastDateTimeNettoie: TDateTime;
  vNettoieIsDone: Boolean;
  vArchivageRestauration, vArchivageStockage: string;
  vGestionArchivage: Tarchivage;
  UpdateDB: TupdateDB;
begin
  FURL := TThreadWMI(Sender).URL;

  FWMI := nil;

  freeSpaceRestauration := 0;
  try
    // on regarde si on est sur le nouveau système de maj si oui on ne lance pas vérification
    if PARAM_60_6.PRMINTEGER <> 1 then
      IsHeureVerification();

   {$REGION 'Backup/Restore'} // 'commence par s, sec
   // normalement s = serveur = B/R Visible
   if EstCeQueJeSuisUnServeur or (EventPanel[CID_BACKREST].Visible) then
    begin
      // Log.Log('Main', BasGUID, 'WMI', 'CallBack'+FormatDateTime('dd/mm/yyyy hh:nn:ss',BackupTime.Prochain), logInfo, True, 0, ltLocal);
      if (FBackRestRunning = 0) and ((FBRDernier = 0) or (SecondsBetween(Now(), FBRDernier) > 300)) // 5 Minutes
        then
          begin
            // Log.Log('Main', BasGUID, 'Log', 'Ne Tourne Pas', logInfo, True, 0, ltLocal);
            delta := SecondsBetween(Now(), BackupTime.Prochain); // secondeBetween revoie toujours positif !
            if (Now() > BackupTime.Prochain) and (delta < 300) // plus grand et jusqu'a 5 minutes
            then
            begin
              // vProcheBR := True;
              Log.Log('Main', BasGUID, 'Log', 'Analyse Stop EASY Ou Lance BR', logInfo, True, 0, ltLocal);
              If (FEasyRunning = 0) then
              begin
                Log.Log('Main', BasGUID, 'Log', 'Lance B/R', logInfo, True, 0, ltLocal);
                LanceBackRest();
              end;
              If (FEasyRunning = 1) then
              begin
                Log.Log('Main', BasGUID, 'Log', 'Stop EASY', logInfo, True, 0, ltLocal);
                ServiceStop('', 'EASY');
              end;
            end;
          end;

      If (FBackRestRunning = 0) and (FBackRestEnd) // On va pas re relancer en permanance
        then
          begin
            Log.Log('Main', BasGUID, 'Log', 'Start EASY', logInfo, True, 0, ltLocal);
            ServiceStart('', 'EASY');
            FBackRestEnd := False;
            // Après un Backup/restore on lance le netttoyage Ginkoia
            LanceNettoieGinkoia();
            // ------------------------------------------------------------------
            tmDB.Enabled := True;
          end;

    end;
   {$ENDREGION 'Backup/Restore'}

    // une seule fois par jour !

    // Si on veut charger dynamiquement FlastCGT (pour tests) par le .ini
    // sinon il est sensé etre à jour donc on peut commenter la ligne suivante en prod
    FLastCGT := LoadIniDateTime('CGT');
    vLastDateTimeNettoie := LoadIniDateTime('NettoieGinkoia');
    vNettoieIsDone := (vLastDateTimeNettoie > 100) and (SecondsBetween(vLastDateTimeNettoie, Now()) < 12 * SecsPerHour);

    // exécution de l'optimisation
    // Toutes les
    if not(EstcequejesuisUnServeur)
         and (FLastOptimizeDB+FOPTIM_CRON_HR/24 < Now)
         and (FBackRestRunning = 0) then
    begin
      LanceOptimisation();
    end;



    // exécution des grands totaux, une fois par jour
    if (FDateLastCloture < Trunc(Now)) and (FBackRestRunning = 0) and (vNettoieIsDone) then
    begin
      LanceCGT();
    end;

    // Execution de la fusion des modèles, une fois par jour
    if (Trunc(FLastFusion) < Trunc(Now)) and (FBackRestRunning = 0) and (vNettoieIsDone) then
    begin
      LanceFusion();
    end;

    DoLogServices('Service EASY', 'ServiceEasy', 'Status');

    DoLogServices('BI', 'BI', 'Status');
    DoLogServices('BI', 'BI', 'DteLast');
    DoLogServices('BI', 'BI', 'DteLastOk');

    // -------------------------------------------------------------------------
    // ------------ partie pour l'archivage et les logs de baseSize ------------
    // -------------------------------------------------------------------------
    // partie qui met à jour les Log de la taille de la base, de l'espace disque disponible, et de l'archivage lancé une fois par jour seulement
    // exécutée seulement si le backup restore ne tourne pas
    if (FDateLastBaseSizesArchivage < Trunc(Now)) and (FBackRestRunning = 0) then
    begin
      DoLogServices('Disques', 'BaseSize', 'Base');
      DoLogServices('Disques', 'DiskSpace', 'Base');

      // ***********************************************************************
      // partie pour l'espace disque du chemin de stockage de l'archivage ******
      // ***********************************************************************

      // si le genparam de l'archivage Restauration existe, on récupère le disque du chemin de l'archivage
      if (PARAM_60_8.PRMSTRING <> '') then
      begin
        vArchivageStockage := ExtractFileDrive(PARAM_60_8.PRMSTRING);
      end;

      // on vérifie le type de disque pour l'archivage
      if (getdrivetype(pchar(vArchivageStockage)) = 2) or (getdrivetype(pchar(vArchivageStockage)) = 3) or (getdrivetype(pchar(vArchivageStockage)) = 4) then
      // drivetype = 2 -> disque removable, comme clé usb
      // drivetype = 3 -> disque dur fixe
      // drivetype = 4 -> disque réseau
      begin
        try
          vGestionArchivage := Tarchivage.Create();
          try
            freeSpaceStockage := vGestionArchivage.EspaceDisque(vArchivageStockage, tedLibre, tuoMoctet);

            if (freeSpaceStockage < (Base0Size)) then // si on a pas deux fois la taille de la base en espace disque dispo, on remonte un warning
              Log.Log('DiskSpace', BasGUID, 'Archivage', IntToStr(freeSpaceStockage), logWarning, True, 0, ltServer)
            else
              Log.Log('DiskSpace', BasGUID, 'Archivage', IntToStr(freeSpaceStockage), logInfo, True, 0, ltServer);
          finally
            vGestionArchivage.Free;
          end;
        except
          on E: Exception do
            Log.Log('DiskSpace', BasGUID, 'Archivage', 'Erreur lors de la mise à jour de l''espace disque de stockage de l''archivage : ' + E.Message, logError,
              True, 0, ltLocal);
        end;
      end
      else // on ne trouve pas le chemin : on log en erreur
      begin
        Log.Log('DiskSpace', FBasGUID, 'Archivage', 'Impossible de trouver le chemin du lecteur pour le stockage de l''archive', logError, True, 0, ltServer);
      end;

      // mise à jour du genparam du stockage de l'archivage et du nom machine pour l'archivage
      try
        UpdateDB := TupdateDB.Create(VGSE.Base0, StrToInt(BASID));
        try
          UpdateDB.UpdateGenParam(PARAM_60_8.PRMTYPE, PARAM_60_8.PRMCODE, freeSpaceStockage, TypeFloat);

          if PARAM_3_36.PRMSTRING <> Log.Host then
            UpdateDB.UpdateGenParam(PARAM_3_36.PRMTYPE, PARAM_3_36.PRMCODE, Log.Host, TypeString);
        finally
          UpdateDB.Free;
        end;
      except
        on E: Exception do
          Log.Log('DiskSpace', BasGUID, 'Archivage', 'Erreur lors de la mise à jour du genparam archivage : ' + E.Message, logError, True, 0, ltLocal);
      end;

      // ***********************************************************************
      // partie pour l'espace disque du chemin de restauration de l'archivage ******
      // ***********************************************************************

      // si le genparam de l'archivage Restauration existe, on récupère le disque du chemin de l'archivage
      if (PARAM_60_1.PRMSTRING <> '') then
      begin
        vArchivageRestauration := ExtractFileDrive(PARAM_60_1.PRMSTRING);
      end;

      // on vérifie le type de disque pour l'archivage (on ne fait les actions que si c'est un dd fixe);
      if (getdrivetype(pchar(vArchivageRestauration)) = 3) then // drivetype = 3 -> disque dur fixe
      begin
        try
          vGestionArchivage := Tarchivage.Create();
          try
            freeSpaceRestauration := vGestionArchivage.EspaceDisque(vArchivageRestauration, tedLibre, tuoMoctet);

            // on ne log plus cette partie qui devient la restauration, à la place on log le nouveau genparam pour le stockage
            // if (freeSpaceRestauration < (Base0Size * 2)) then // si on a pas deux fois la taille de la base en espace disque dispo, on remonte un warning
            // Log.Log('DiskSpace', BasGUID, 'Archivage', IntToStr(freeSpaceRestauration), logWarning, True, 0, ltServer)
            // else
            // Log.Log('DiskSpace', BasGUID, 'Archivage', IntToStr(freeSpaceRestauration), logInfo, True, 0, ltServer);

            // On vérifie les droits réseau pour l'archivage AJ 13/02/2018, et on partage si besoin
            vGestionArchivage.checkNetworkArchivage();

          finally
            vGestionArchivage.Free;
          end;
        except
          on E: Exception do
            Log.Log('DiskSpace', BasGUID, 'Archivage', 'Erreur lors de la mise à jour de l''espace disque archivage : ' + E.Message, logError, True, 0,
              ltLocal);
        end;
      end
      else // on ne trouve pas le chemin : on log en erreur
      begin
        Log.Log('DiskSpace', FBasGUID, 'Archivage', 'Impossible de trouver le chemin du lecteur', logError, True, 0, ltServer);
      end;

      // mise à jour du genparam de la restauration de l'archivage
      try
        UpdateDB := TupdateDB.Create(VGSE.Base0, StrToInt(BASID));
        try
          UpdateDB.UpdateGenParam(PARAM_60_1.PRMTYPE, PARAM_60_1.PRMCODE, freeSpaceRestauration, TypeFloat);
        finally
          UpdateDB.Free;
        end;
      except
        on E: Exception do
          Log.Log('DiskSpace', BasGUID, 'Archivage', 'Erreur lors de la mise à jour du genparam archivage : ' + E.Message, logError, True, 0, ltLocal);
      end;

      // on met à jour la date de dernière exécution, pour ne le faire qu'une fois par jour
      FDateLastBaseSizesArchivage := Trunc(Now);
    end;

    // -------------------------------------------------------------------------
    // ------------------------- fin archivage ---------------------------------
    // -------------------------------------------------------------------------

    // ---------------------------------------------------------------------------------------
    // -------- partie pour le lancement automatique de Piccobatch, une seule fois -----------
    // ---------------------------------------------------------------------------------------
    if FTimerFirstPass then
      LaunchPiccoAuto;

    // ---------------------------------------------------------------------------------------
    // -------- partie pour la maj de l'exe verification.exe ---------------------------------
    // ---------------------------------------------------------------------------------------
    if (FdateLastMAJverif < Trunc(Now)) and (FBackRestRunning = 0) and (FVerifRunning = 0) then
    begin
      // on met à jour la date de dernière exécution, pour ne le faire qu'une fois par jour
      if updateVerification then
        FdateLastMAJverif := Trunc(Now);
    end;

    // redimensionnement du launcher en fonction du nombre de tuiles max
    RedimLauncher();

    FTimerFirstPass := False;
  finally
    tmWMI.Enabled := True;
  end;
end;

procedure TFrm_Launcher.BINFOClick(Sender: TObject);
begin
  if FLOCKINFO then
    exit;
  FLOCKINFO := True;
  Application.CreateForm(TFrm_Infos, Frm_Infos);
  try
    Frm_Infos.IBFile := VGSE.Base0;
    Frm_Infos.Show; // Showmodal
  finally
    // FLOCKINFO := false;
  end;
end;

procedure TFrm_Launcher.ShowNotification(aTitle:string;aBody:string);
var MyNotification: TNotification; //Defines a TNotification variable
begin
  // Seulement si on peut mettre les Notifs....
  if FCanShowNotif then
    begin
      MyNotification := NotificationCenter1.CreateNotification; //Creates the notification
      try
        MyNotification.Name := 'LauncherEasy';
        MyNotification.Title := aTitle;
        MyNotification.AlertBody := aBody;
        NotificationCenter1.PresentNotification(MyNotification);
      finally
        MyNotification.Free;
      end;
    end;
end;

procedure TFrm_Launcher.CallBackLinkLame(Sender: TObject);
begin
  try
     if not(TThreadLinkLame(Sender).TCPOpen) // or not(TThreadLinkLame(Sender).PingReply)
       then
          begin
            FNbOkLame := 0;
            inc(FNbErrorLame);
            EventPanel[CID_CLOUD].Detail       := Format('Lame : %d Erreurs',[FNbErrorLame])+#13+#10+FormatDateTime('dd/mm/yyyy hh:nn',Now());
            // EventPanel[CID_SERVICE_EASY].Hint  := Format('Lame injoignable %d fois',[FNbErrorLame])+#13+#10+FormatDateTime('dd/mm/yyyy hh:nn',Now());
          end
       else
          begin
             // On repart à zéro...
             Inc(FNbOkLame);
             FNbErrorLame:=0;
             EventPanel[CID_CLOUD].Level        := logInfo;
             EventPanel[CID_CLOUD].Detail       := 'Lame OK'+#13+#10+FormatDateTime('dd/mm/yyyy hh:nn',Now());
             // EventPanel[CID_SERVICE_EASY].Level := logInfo;
             // EventPanel[CID_SERVICE_EASY].Hint  := 'Lame OK'+#13+#10+FormatDateTime('dd/mm/yyyy hh:nn',Now());
            // Si le Service EASY est arrêté.... on le relance.................
            // et aussi que ca fait au moins 5 ou 10 bonnes...
            if EstCeQueJeSuisUnPortable and (FEasyRunning=0) and (FBackRestRunning=0) and (FNbOkLame>5)
               then ServiceStart('','EASY');
          end;
     //  5 Erreurs de suite...
     EventPanel[CID_CLOUD].Hint := 'Réponse au Ping : ' + FloatToStr(TThreadLinkLame(Sender).PingTime) +'ms';
     if FNbErrorLame>=5 then
        begin
           EventPanel[CID_CLOUD].Level          := LogWarning;
           EventPanel[CID_TRAFFIC_DESC].Level   := LogWarning;
           if EstCeQueJeSuisUnPortable and  EstceQueJeSuisUnPortableDeSynchro
              and (FEasyRunning=1) and (FBackRestRunning = 0)
              then
                begin
                  ShowNotification('Erreur','Lame injoignable'+#13+#10+'Arrêt du Service EASY...');
                  // StartEASY
                  ServiceStop('','EASY');
                end;
        end;
  finally
    FLinkLame := nil;
  end;
end;

procedure TFrm_Launcher.CallBackWSQtePULL(Sender: TObject);
begin
  try
    EventPanel[CID_TRAFFIC_DESC].Level := TThreadWsQtePull(Sender).Level;
    if TThreadWsQtePull(Sender).datacount<=1
      then
        begin
            EventPanel[CID_TRAFFIC_DESC].Detail := Format('%d ligne'+#13+#10+'%s',
                [ TThreadWsQtePull(Sender).datacount,
                TThreadWsQtePull(Sender).oldestbatch]);
        end
      else
        begin
           EventPanel[CID_TRAFFIC_DESC].Detail := Format('%d lignes'+#13+#10+'%s',
                [ TThreadWsQtePull(Sender).datacount,
                TThreadWsQtePull(Sender).oldestbatch]);
        end;
  finally
    FEvalQtePull := nil;
  end;
end;

procedure TFrm_Launcher.CallBackOptimizeDB(Sender: TObject);
begin
   EventPanel[CID_OPTIM].Level := logInfo;
   FOptimizeDB := nil;
end;

procedure TFrm_Launcher.CallBackThreadDB(Sender: TObject);
var
  I, IPanel: integer;
  ListPanel: array [0 .. 3] of TPanel;
  aPanel: TPanel;
begin
  try
    if FDBFirstPass then
    begin
      FNode := TThreadDB(Sender).Node;
      FNode_Group_ID := TThreadDB(Sender).NODE_GROUP_ID;

      if FNode_Group_ID='portables' then
        begin
          EventPanel[CID_SYNCHRONISATION].Visible := true;
          EventPanel[CID_TRAFFIC_DESC].Visible    := false;
          lbl_EASY_TITLE.Caption   := 'SYNCHRONISATION Manuelle';
          lbl_EASY_DETAILS.Caption := '';
          lbl_EASY_TITLE.Visible   := true;
          lbl_EASY_DETAILS.Visible := true;
          EventPanel[CID_SYNCHRONISATION].Detail :=
                'Dernière Synchro Ok : ' + FormatDateTime('dd/mm/yyyy hh:nn',TThreadDB(Sender).SYNCHROOK);
          if (TThreadDB(Sender).LASTSYNC_RESULT=1)
            then EventPanel[CID_SYNCHRONISATION].Level  := logInfo
            else
              begin
                  EventPanel[CID_SYNCHRONISATION].Level  := logError;
                  EventPanel[CID_SYNCHRONISATION].Detail := EventPanel[CID_SYNCHRONISATION].Detail + #13+#10+
                      'Dernière Synchro  : ' + FormatDateTime('dd/mm/yyyy hh:nn',TThreadDB(Sender).LASTSYNC);
              end;
          // première passe.... On s'affiche au premier plan pour les Portables de Synchro
          Self.Show;
          Application.BringToFront;
        end;

      if (FNode_Group_ID='mags') and EstCeQueJeSuisUnServeur() then
        begin
          EventPanel[CID_SYNCHRONISATION].Visible := false;
          EventPanel[CID_TRAFFIC_DESC].Visible    := true;
          lbl_EASY_TITLE.Caption   := 'EASY Serveur';
          lbl_EASY_DETAILS.Caption := 'Echange Automatique SYnchrone';
          lbl_EASY_TITLE.Visible   := true;
          lbl_EASY_DETAILS.Visible := true;
        end;

      if (FNode_Group_ID='mags') and EstCeQueJeSuisUnPortable() then
        begin
          EventPanel[CID_SYNCHRONISATION].Visible := false;
          EventPanel[CID_TRAFFIC_DESC].Visible    := true;
          lbl_EASY_TITLE.Caption   := 'EASY Portable';
          lbl_EASY_DETAILS.Caption := 'Echange Automatique SYnchrone';
          lbl_EASY_TITLE.Visible   := true;
          lbl_EASY_DETAILS.Visible := true;
        end;

      EventPanel[CID_BACKREST].Visible:=Pos('s',FNode)=1;

      // Log.Doss  := FBasDossier;
      Log.Mag := FBasMagID;
      Log.Ref := FBasGUID;
      SaveInitParams();
      // la mise à jour de verification ne se fait qu'une seule fois au retour du premier DBTimer
      // MAJVerification();
    end;

    EventPanel[CID_BACKREST].Visible := TThreadDB(Sender).BR_Visible;
    EventPanel[CID_OPTIM].Visible  := TThreadDB(Sender).OPTIM_Visible;
    FOPTIM_CRON_HR                 := TThreadDB(Sender).OPTIM_CRON_HR;
    EventPanel[CID_OPTIM].Hint     := 'Prochaine Optimisation ' +
                                    FormatDateTime('dd/mm/yyyy hh:nn',FLastOptimizeDB+FOPTIM_CRON_HR/24);
    EventPanel[CID_STOCK].Visible  := TThreadDB(Sender).Recalc_Stock;


    if TThreadDB(Sender).Datacount<=1
      then EventPanel[CID_TRAFFIC_ASC].Detail := Format('%d ligne'+#13+#10'%s',[TThreadDB(Sender).Datacount,FormatDateTime('dd/mm/yyyy hh:nn',TThreadDB(Sender).OldestbatchOk)])
      else EventPanel[CID_TRAFFIC_ASC].Detail := Format('%d lignes'+#13+#10'%s',[TThreadDB(Sender).Datacount,FormatDateTime('dd/mm/yyyy hh:nn',TThreadDB(Sender).OldestbatchOk)]);

    // On post en LOG uniquement le pas vide
    if TThreadDB(Sender).OldestbatchOk>0
      then Log.Log('Replication', FBasGUID, 'dteLastOk', DateTimeToISO8601(TThreadDB(Sender).OldestbatchOk), EventPanel[CID_TRAFFIC_ASC].Level, True, 0, ltServer);
    if TThreadDB(Sender).OldestbatchNotOk>0
      then Log.Log('Replication', FBasGUID, 'dteLast', DateTimeToISO8601(TThreadDB(Sender).OldestbatchNotOk), EventPanel[CID_TRAFFIC_ASC].Level, True, 0, ltServer);

    if TThreadDB(Sender).LignesStock<=1
      then EventPanel[CID_STOCK].Detail       := Format('%s'+#13+#10+'%d ligne',[TThreadDB(Sender).TriggerDiff,TThreadDB(Sender).LignesStock])
      else EventPanel[CID_STOCK].Detail       := Format('%s'+#13+#10+'%d lignes',[TThreadDB(Sender).TriggerDiff,TThreadDB(Sender).LignesStock]);

    FDBINFO := nil;

    (* Pourquoi faire des boucles alors qu'on peu y acceder directement ?
    // il faudra changer la grande boucle suivante...
    *)
    // liste des panels à parcourir :
    for IPanel := Low(ListPanels) to High(ListPanels) do
    begin
      aPanel := ListPanels[IPanel];

      for I := 0 to aPanel.ControlCount - 1 do
      begin
        if (aPanel.Controls[I] is TEventPanel) then
        begin
          // Log.Log('Debug', FBasGUID, 'InfoPanel',' titre tuile : ' + TEventPanel(aPanel.Controls[I]).Title + ' ID : ' +  TEventPanel(aPanel.Controls[I]).id + ' Visible : ' + BoolToStr(TEventPanel(aPanel.Controls[I]).Visible),logInfo, True, 0, ltLocal);

          if TEventPanel(aPanel.Controls[I]).Visible then
          begin
            if (TEventPanel(aPanel.Controls[I]).ID = 'backup') then
            begin
              Log.Log('BackupRestore', FBasGUID, 'dteLastOk', TEventPanel(aPanel.Controls[I]).InfoValue1, logInfo, True, 0, ltServer);
            end;

            if (TEventPanel(aPanel.Controls[I]).ID = 'heartbeat') then
            begin
              Log.Log('HeartBeat', FBasGUID, 'dteLast', TEventPanel(aPanel.Controls[I]).InfoValue1, TEventPanel(aPanel.Controls[I]).Level, True, 0, ltServer);
            end;
            (* Faut plus faire comme ca... au retour du thread on set directement (voir plus haut)
            {
            if (TEventPanel(aPanel.Controls[I]).ID = 'replication') then
            begin
              // sans Accent
              if TEventPanel(aPanel.Controls[I]).Level = logInfo then
              begin
                Log.Log('Replication', FBasGUID, 'dteLastOk', TEventPanel(aPanel.Controls[I]).InfoValue1, logInfo, True, 0, ltServer);
                // le dteLast est aussi OK du coup...
                Log.Log('Replication', FBasGUID, 'dteLast', TEventPanel(aPanel.Controls[I]).InfoValue1, logInfo, True, 0, ltServer);
              end
              else
                Log.Log('Replication', FBasGUID, 'dteLast', TEventPanel(aPanel.Controls[I]).InfoValue1, TEventPanel(aPanel.Controls[I]).Level, True, 0,
                  ltServer);
            end;
            }*)
          end;
        end
      end;
    end;

    // Si jamais on est en 1ère passe et qu'on a pas le retour du WMI ca peut arreter de scanner la base
    // on a pas encore le retour de FBackRestRunning (-1 on sait pas encore) / (0=tourne pas) / (1=Tourne)
    // on ajoute donc OR FDBFirstPass
    // Donc si on a toujours pas de retour à la deuxième passe ca s'arrête
    tmDB.Enabled := (FBackRestRunning = 0) or (FDBFirstPass);
    // --------------------------------------------------------------------------
    FDBFirstPass := False;
    // En retour si maintenant on est à l'heure du backup il faut le lancer....
    // If (IsHeureBackupRestore()) then exit;

    // if Pos('p',FNode)=1 then

  except
    Log.Log('Main', FBasGUID, 'Log', 'CallBackThreadDBError', logError, True, 0, ltLocal);
  end;
end;

procedure TFrm_Launcher.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Mieux en Debug..
  // CanClose:=true;
  Self.Hide;
  CanClose := FCanClose;
end;

procedure TFrm_Launcher.MyClick(Sender: TObject);
begin
    If FIntLockAction=0
      then
        begin
          AtomicIncrement(FIntLockAction);
          try
            if FNode_GROUP_ID='portables'
              then
                begin
                  LanceSynchroPortablesEASY();
                end;
          finally
            AtomicDecrement(FIntLockAction);
          end;
        end;
end;


procedure TFrm_Launcher.FIdleTimerTimer(Sender: TObject);
var atime:variant;
    Log:string;
    Bol:boolean;
    Etat:integer;
begin
     FIdleTimer.Enabled:=false;
     // LblPlus.Caption := 'Dernière Activité : ' + FormatDateTime('hh:nn',FIdleTimer.LastActivity);
     If (FIdleTimer.IdleMinutes>=1)
        then
            begin
                 // LblPlus.Caption := 'plus d''une minute...Dernière Activité : ' + FormatDateTime('hh:nn',FIdleTimer.LastActivity);
                 {
                 // on peut faire un truc
                 }



            end;
     FIdleTimer.Enabled:=true;
end;

procedure TFrm_Launcher.FormCreate(Sender: TObject);
var
  vDateTimeNettoie: TDateTime;
  vDateTimeCGT: TDateTime;
  vVersion, vQuery: string;
  UpdateDB: TupdateDB;
begin
   FIdleTimer    := TIdleTimer.Create(Self);
   FIdleTimer.Enabled := False;
   FIdleTimer.Interval := 60000;
   FIdleTimer.OnTimer  := FIdleTimerTimer;


   FWinVersion := GetWinVersion();
   FCanShowNotif := (FWinVersion>=wv_Win81);
   FForceKill := False;
   Msg_Sys_Kill_LauncherEasy  := RegisterWindowMessageW('Msg_Sys_Kill_LauncherEasy');

   FOptimizeDB := nil;
   FNode_Group_ID := '';
   FNode := '';
   FNbErrorLame := 0;
   FNbOkLame    := 0;

  FOPTIM_CRON_HR := CST_CRON_OPTIM;

  // on vérifie que le démarrage automatique est  bien inscrit dans le registre
  StartAutoRegistry();

  // on vérifie qu'on est sur EASY, sinon on ferme le launcher avant de faire quoi que ce soit
  UpdateDB := TupdateDB.Create(VGSE.Base0, 0);
  try
    // si on ne trouve pas le genparam de Easy, on ferme le launcher
    vQuery := 'SELECT prm_string FROM genparam WHERE prm_type = 80 AND prm_code = 1';
    if UpdateDB.SelectQuery(vQuery) = '' then
    begin
      Application.Terminate;
      exit;
    end;
    Screen.Cursor := crDefault;
  finally
    UpdateDB.Free;
  end;

  // liste des panels de l'application, à parcourir pour les logs etc...
  ListPanels[0] := PnlProgrammes;
  ListPanels[1] := PnlSynchro;
  ListPanels[2] := PnlSysteme;
  ListPanels[3] := PnlMainBot;
  ListPanels[4] := PnlEtatSynchro;
  ListPanels[5] := PanelMainMid;

  FDateLastBaseSizesArchivage := 0;
  FDateLastCloture := 0;
  FdateLastMAJverif := 0;

  vVersion := FileVersion(ParamStr(0));

  FStartTime := Now;
  FLOCKINFO := False;
  IsBaseProd := False;
  FBRDernier := 0;
  Hint := 'Launcher EASY ' + vVersion;
  Caption :=Hint;

  RemoveDeadIcons;
  FDBFirstPass := True;
  FTimerFirstPass := True;
  FBasGUID := '';
  FVersionDB := '';
  PARAM_11_60.INit;
  PARAM_81_1.INit;

  LoadInitParams();

  Log.App := 'LauncherEASY';
  Log.Inst := '';
  Log.FileLogFormat := [elDate, elMdl, elKey, elLevel, elNb, elValue];
  Log.SendOnClose := True;
  Log.Open;
  Log.SendLogLevel := logTrace;
  Log.Mag := FBasMagID;
  Log.Log('Main', FBasGUID, 'Status', 'Démarrage en cours ...', logInfo, True);
  Log.Log('Main', FBasGUID, 'Version', vVersion, logInfo, True, 0, ltServer);

  Log.saveIni();

  FCanClose := False;
  FEASYLog := '';
  FBackRestRunning := -1;
  FEasyRunning := -1;
  // FVerifRunning    := -1;
  FBackRestEnd := False;
  FLastCGT := 0;
  FLastFusion := 0;
  FLastOptimizeDB := 0;

  // Création des tuiles
  // Cloud
  EventPanel[CID_CLOUD] := TEventPanel.Create(Self);
  EventPanel[CID_CLOUD].Left := 0;
  EventPanel[CID_CLOUD].Align := alLeft;
  EventPanel[CID_CLOUD].Level := logInfo;
  EventPanel[CID_CLOUD].Visible := true;
  EventPanel[CID_CLOUD].Parent := PnlEtatSynchro;
  EventPanel[CID_CLOUD].Title := 'Cloud';
  EventPanel[CID_CLOUD].Detail := ' '+#13+#10+' ';
  EventPanel[CID_CLOUD].Height := PnlEtatSynchro.Height-10;
  EventPanel[CID_CLOUD].width  := EventPanel[CID_CLOUD].Height;
  EventPanel[CID_CLOUD].ID := 'Cloud';
  EventPanel[CID_CLOUD].Image.Align := alNone;
  EventPanel[CID_CLOUD].Image.Left := round((EventPanel[CID_CLOUD].Width-32) / 2);
  limMonitor.GetIcon(24, EventPanel[CID_CLOUD].Icon);

  EventPanel[CID_TRAFFIC_ASC] := TEventPanel.Create(Self);
  EventPanel[CID_TRAFFIC_ASC].Align := alLeft;
  EventPanel[CID_TRAFFIC_ASC].Left := PnlEtatSynchro.Height+10;
  EventPanel[CID_TRAFFIC_ASC].Level := logTrace;
  EventPanel[CID_TRAFFIC_ASC].Visible := True;
  EventPanel[CID_TRAFFIC_ASC].Parent := PnlEtatSynchro;  // PnlSynchro;
  EventPanel[CID_TRAFFIC_ASC].Title := 'Traffic Asc.';
  EventPanel[CID_TRAFFIC_ASC].Detail := ' '+#13+#10+' ';
  EventPanel[CID_TRAFFIC_ASC].ID := 'replication';
  EventPanel[CID_TRAFFIC_ASC].Height := PnlEtatSynchro.Height-10;
  EventPanel[CID_TRAFFIC_ASC].width  := EventPanel[CID_TRAFFIC_ASC].Height;
  EventPanel[CID_TRAFFIC_ASC].Image.Align := alNone;
  EventPanel[CID_TRAFFIC_ASC].Image.Left := round((EventPanel[CID_TRAFFIC_ASC].Width-32) / 2);
  limMonitor.GetIcon(21, EventPanel[CID_TRAFFIC_ASC].Icon);

  // Traffic PULL
  EventPanel[CID_TRAFFIC_DESC] := TEventPanel.Create(Self);
  EventPanel[CID_TRAFFIC_DESC].Left := (PnlEtatSynchro.Height+10)*2;
  EventPanel[CID_TRAFFIC_DESC].Align := alLeft;
  EventPanel[CID_TRAFFIC_DESC].Level := logINfo;
  EventPanel[CID_TRAFFIC_DESC].Visible := false;
  EventPanel[CID_TRAFFIC_DESC].Parent := PnlEtatSynchro;   // PnlSynchro;
  EventPanel[CID_TRAFFIC_DESC].Title := 'Traffic Desc.';
  EventPanel[CID_TRAFFIC_DESC].Detail := ' '+#13+#10+' ';
  EventPanel[CID_TRAFFIC_DESC].ID := 'Pull';
  EventPanel[CID_TRAFFIC_DESC].Height := PnlEtatSynchro.Height-10;
  EventPanel[CID_TRAFFIC_DESC].width  := EventPanel[CID_TRAFFIC_DESC].Height;
  EventPanel[CID_TRAFFIC_DESC].Image.Align := alNone;
  EventPanel[CID_TRAFFIC_DESC].Image.Left := round((EventPanel[CID_TRAFFIC_DESC].Width-32) / 2);
  limMonitor.GetIcon(22, EventPanel[CID_TRAFFIC_DESC].Icon);


  EventPanel[CID_EASY_LOG] := TEventPanel.Create(Self);
  EventPanel[CID_EASY_LOG].Left := 800;
  EventPanel[CID_EASY_LOG].Align := alLeft;
  EventPanel[CID_EASY_LOG].Level := logTrace;
  EventPanel[CID_EASY_LOG].Visible := False;
  EventPanel[CID_EASY_LOG].Parent := PnlSynchro;
  EventPanel[CID_EASY_LOG].Title := 'EASY LOG';
  limMonitor.GetIcon(CID_EASY_LOG, EventPanel[CID_EASY_LOG].Icon);


  EventPanel[CID_JAVA_VERSION] := TEventPanel.Create(Self);
  EventPanel[CID_JAVA_VERSION].Align := alLeft;
  EventPanel[CID_JAVA_VERSION].Left := 100;
  EventPanel[CID_JAVA_VERSION].Level := logTrace;
  EventPanel[CID_JAVA_VERSION].Visible := true; //// est-ce la peine de l'afficher ?
  EventPanel[CID_JAVA_VERSION].Parent := PnlSysteme;
  EventPanel[CID_JAVA_VERSION].Title := 'Java ' + VGSE.Javaversion;
  EventPanel[CID_JAVA_VERSION].Level := logInfo;
  limMonitor.GetIcon(CID_JAVA_VERSION, EventPanel[CID_JAVA_VERSION].Icon);

  // tuile système qui regroupe :
  // occupation de la plage des K
  // cloture des grands totaux
  // verification.exe
  // espace disque disponible
  // java
  // Easy log
  // postgre
  EventPanel[CID_SYSTEME] := TEventPanel.Create(Self);
  EventPanel[CID_SYSTEME].Align := alLeft;
  EventPanel[CID_SYSTEME].Level := logTrace;
  EventPanel[CID_SYSTEME].Visible := True;
  EventPanel[CID_SYSTEME].Parent := PnlMainBot;
  EventPanel[CID_SYSTEME].Title := 'SYSTEME';
  limMonitor.GetIcon(CID_SYSTEME, EventPanel[CID_SYSTEME].Icon);

  EventPanel[CID_BACKREST] := TEventPanel.Create(Self);
  EventPanel[CID_BACKREST].Left := 0;
  EventPanel[CID_BACKREST].Align := alLeft;
  EventPanel[CID_BACKREST].Level := logTrace;
  EventPanel[CID_BACKREST].Visible := False; // True;
  EventPanel[CID_BACKREST].Parent := PnlMainBot; // par défaut sur le panel principal mais transféré quand on regarde le détails
  EventPanel[CID_BACKREST].Title := 'Backup Restore';
  EventPanel[CID_BACKREST].ID := 'backup';
  limMonitor.GetIcon(CID_BACKREST, EventPanel[CID_BACKREST].Icon);



  EventPanel[CID_SERVICE_EASY] := TEventPanel.Create(Self);
  EventPanel[CID_SERVICE_EASY].left := 300;
  EventPanel[CID_SERVICE_EASY].Align := alLeft;
  EventPanel[CID_SERVICE_EASY].Level := logTrace;
  EventPanel[CID_SERVICE_EASY].Visible := True;
  EventPanel[CID_SERVICE_EASY].Parent := PnlSynchro;
  EventPanel[CID_SERVICE_EASY].Title := 'Service EASY';
  EventPanel[CID_SERVICE_EASY].SetPopMenu('EASY'); // pop up menu pour arrêter le service EASY (et donc la réplication)
  limMonitor.GetIcon(CID_SERVICE_EASY, EventPanel[CID_SERVICE_EASY].Icon);


  EventPanel[CID_HEARTBEAT] := TEventPanel.Create(Self);
  EventPanel[CID_HEARTBEAT].Left := 400;
  EventPanel[CID_HEARTBEAT].Align := alLeft;
  EventPanel[CID_HEARTBEAT].Level := logTrace;
  EventPanel[CID_HEARTBEAT].Visible := True;
  EventPanel[CID_HEARTBEAT].Parent := PnlSynchro;
  EventPanel[CID_HEARTBEAT].Title := 'HeartBeat';
  EventPanel[CID_HEARTBEAT].ID := 'heartbeat';
  limMonitor.GetIcon(CID_HEARTBEAT, EventPanel[CID_HEARTBEAT].Icon);

  EventPanel[CID_PLAGEK] := TEventPanel.Create(Self);
  EventPanel[CID_PLAGEK].Left := 500;
  EventPanel[CID_PLAGEK].Align := alLeft;
  EventPanel[CID_PLAGEK].Level := logTrace;
  EventPanel[CID_PLAGEK].Visible := True;
  EventPanel[CID_PLAGEK].Parent := PnlSynchro;
  EventPanel[CID_PLAGEK].Title := 'Occup. Plage K';
  EventPanel[CID_PLAGEK].Detail := '0%';
  limMonitor.GetIcon(CID_PLAGEK, EventPanel[CID_PLAGEK].Icon);

  EventPanel[CID_VERIF] := TEventPanel.Create(Self);
  EventPanel[CID_VERIF].Align := alLeft;
  EventPanel[CID_VERIF].Left := 200;
  EventPanel[CID_VERIF].Level := logTrace;
  EventPanel[CID_VERIF].Visible := True;
  EventPanel[CID_VERIF].Parent := PnlProgrammes;
  EventPanel[CID_VERIF].Title := 'Vérification';
  limMonitor.GetIcon(CID_VERIF, EventPanel[CID_VERIF].Icon);

  EventPanel[CID_NETTOIE] := TEventPanel.Create(Self);
  EventPanel[CID_NETTOIE].Align := alLeft;
  EventPanel[CID_NETTOIE].Left := 300;
  EventPanel[CID_NETTOIE].Level := logTrace;
  EventPanel[CID_NETTOIE].Visible := False; // on n'affiche plus la tuile à présent
  EventPanel[CID_NETTOIE].Parent := PnlProgrammes;
  EventPanel[CID_NETTOIE].Title := 'Nettoie Ginkoia';
  limMonitor.GetIcon(CID_NETTOIE, EventPanel[CID_NETTOIE].Icon);
  vDateTimeNettoie := LoadIniDateTime('NettoieGinkoia');
  if vDateTimeNettoie > 100 then
    EventPanel[CID_NETTOIE].Detail := FormatDateTime('dd/mm/yyyy hh:nn', vDateTimeNettoie);

  if MinutesBetween(Now(), vDateTimeNettoie) > MinsPerDay then
    EventPanel[CID_NETTOIE].Level := logWarning
  else
    EventPanel[CID_NETTOIE].Level := logInfo;

  EventPanel[CID_CGT] := TEventPanel.Create(Self);
  EventPanel[CID_CGT].Align := alLeft;
  EventPanel[CID_CGT].Left := 400;
  EventPanel[CID_CGT].Level := logTrace;
  EventPanel[CID_CGT].Visible := True;
  EventPanel[CID_CGT].Parent := PnlProgrammes;
  EventPanel[CID_CGT].Title := 'Grands Totaux';
  limMonitor.GetIcon(CID_CGT, EventPanel[CID_CGT].Icon);
  FLastCGT := LoadIniDateTime('CGT');
  if FLastCGT > 100 then
    EventPanel[CID_CGT].Detail := FormatDateTime('dd/mm/yyyy hh:nn', FLastCGT);

  FLastFusion     := LoadIniDateTime('Fusion');
  FLastOptimizeDB := LoadIniDateTime('OptimizeDB');
  // Si très vieux ou pas de valeur
  if FLastOptimizeDB<1 then FLastOptimizeDB := Now()-0.1;

  if MinutesBetween(Now(), FLastCGT) > MinsPerDay then
    EventPanel[CID_CGT].Level := logWarning
  else
    EventPanel[CID_CGT].Level := logInfo;

  EventPanel[CID_INFOS] := TEventPanel.Create(Self);
  EventPanel[CID_INFOS].Align := alLeft;
  EventPanel[CID_INFOS].Left := 500;
  EventPanel[CID_INFOS].Level := LogNotice;
  EventPanel[CID_INFOS].Visible := True;
  EventPanel[CID_INFOS].Parent := PnlSysteme;
  EventPanel[CID_INFOS].Title := 'Autres Infos';
  limMonitor.GetIcon(CID_INFOS, EventPanel[CID_INFOS].Icon);
  //
  TPanel(EventPanel[CID_INFOS]).OnDblClick := BINFOClick;
  EventPanel[CID_INFOS].Image.OnDblClick   := BINFOClick;
  EventPanel[CID_INFOS].LblTitle.OnDblClick:= BINFOClick;
  EventPanel[CID_INFOS].LblDetail.OnDblClick:= BINFOClick;

  EventPanel[CID_INTERBASE] := TEventPanel.Create(Self);
  EventPanel[CID_INTERBASE].Align := alLeft;
  EventPanel[CID_INTERBASE].Level := logTrace;
  EventPanel[CID_INTERBASE].Visible := True;
  EventPanel[CID_INTERBASE].Parent := PnlSysteme;
  EventPanel[CID_INTERBASE].Title := 'Interbase';
  limMonitor.GetIcon(CID_INTERBASE, EventPanel[CID_INTERBASE].Icon);

  EventPanel[CID_PG] := TEventPanel.Create(Self);
  EventPanel[CID_PG].Align := alLeft;
  EventPanel[CID_PG].Level := logTrace;
  EventPanel[CID_PG].Visible := True;
  EventPanel[CID_PG].Parent := PnlSysteme;
  EventPanel[CID_PG].Title := 'PostgreSQL';
  limMonitor.GetIcon(CID_PG, EventPanel[CID_PG].Icon);

  EventPanel[CID_DRIVES] := TEventPanel.Create(Self);
  EventPanel[CID_DRIVES].Align := alLeft;
  EventPanel[CID_DRIVES].Level := LogNotice;
  EventPanel[CID_DRIVES].Visible := True;
  EventPanel[CID_DRIVES].Parent := PnlSysteme;
  EventPanel[CID_DRIVES].Title := 'Disques';
  limMonitor.GetIcon(CID_DRIVES, EventPanel[CID_DRIVES].Icon);

  EventPanel[CID_MOBILITE] := TEventPanel.Create(Self);
  EventPanel[CID_MOBILITE].Left := 500;
  EventPanel[CID_MOBILITE].Align := alLeft;
  EventPanel[CID_MOBILITE].Level := logTrace;
  EventPanel[CID_MOBILITE].Visible := False;
  EventPanel[CID_MOBILITE].Parent := PnlProgrammes;
  EventPanel[CID_MOBILITE].Title := 'Service Mobilité';
  EventPanel[CID_MOBILITE].SetPopMenu('GinkoiaMobiliteSvr');
  limMonitor.GetIcon(CID_MOBILITE, EventPanel[CID_MOBILITE].Icon);

  EventPanel[CID_SERVICEREPRISE] := TEventPanel.Create(Self);
  EventPanel[CID_SERVICEREPRISE].Align := alRight;
  EventPanel[CID_SERVICEREPRISE].Level := logTrace;
  EventPanel[CID_SERVICEREPRISE].Visible := False;
  EventPanel[CID_SERVICEREPRISE].Parent := PnlMainBot; // par défaut sur le panel principal mais transféré quand on regarde le détails
  EventPanel[CID_SERVICEREPRISE].Title := 'Service Reprise';
  EventPanel[CID_SERVICEREPRISE].SetPopMenu('GinkoiaServiceReprises');
  limMonitor.GetIcon(CID_SERVICEREPRISE, EventPanel[CID_SERVICEREPRISE].Icon);

  EventPanel[CID_MAJ] := TEventPanel.Create(Self);
  EventPanel[CID_MAJ].Align := alLeft;
  EventPanel[CID_MAJ].Level := logTrace;
  EventPanel[CID_MAJ].Visible := False;
  EventPanel[CID_MAJ].Parent := PnlProgrammes;
  EventPanel[CID_MAJ].Title := 'MAJ GINKOIA';
  limMonitor.GetIcon(CID_MAJ, EventPanel[CID_MAJ].Icon);

  EventPanel[CID_BI] := TEventPanel.Create(Self);
  EventPanel[CID_BI].Left := 400;
  EventPanel[CID_BI].Align := alRight;
  EventPanel[CID_BI].Level := logTrace;
  EventPanel[CID_BI].Visible := False;
  EventPanel[CID_BI].Parent := PnlMainBot;
  EventPanel[CID_BI].Title := 'BI';
  EventPanel[CID_BI].SetPopMenu('Service_BI_Ginkoia');
  limMonitor.GetIcon(CID_BI, EventPanel[CID_BI].Icon);

  EventPanel[CID_PICCOBATCH] := TEventPanel.Create(Self);
  EventPanel[CID_PICCOBATCH].Left := 400;
  EventPanel[CID_PICCOBATCH].Align := alLeft;
  EventPanel[CID_PICCOBATCH].Level := logTrace;
  EventPanel[CID_PICCOBATCH].Visible := False;
  EventPanel[CID_PICCOBATCH].Parent := PnlProgrammes;
  EventPanel[CID_PICCOBATCH].Title := 'PiccoBatch';
  EventPanel[CID_PICCOBATCH].SetPopMenuExe('piccobatch.exe', 'auto launcher');
  limMonitor.GetIcon(CID_PICCOBATCH, EventPanel[CID_PICCOBATCH].Icon);

  EventPanel[CID_OPTIM] := TEventPanel.Create(Self);
  EventPanel[CID_OPTIM].Left := 400;
  EventPanel[CID_OPTIM].Align := alLeft;
  EventPanel[CID_OPTIM].Level := logInfo;
  EventPanel[CID_OPTIM].Visible := true;
  EventPanel[CID_OPTIM].Parent := PnlProgrammes;
  EventPanel[CID_OPTIM].Title := 'Optimisation';
  EventPanel[CID_OPTIM].Detail := FormatDateTime('dd/mm/yyyy hh:nn', FLastOptimizeDB);
  if Trunc(FLastOptimizeDB-Now)>0 then
    begin
      EventPanel[CID_OPTIM].Level := logWarning;
    end;
  if Trunc(FLastOptimizeDB-Now)>1 then
    begin
      EventPanel[CID_OPTIM].Level := logError;
    end;

  // on ne sait pas encore à ce moment la
  // EventPanel[CID_OPTIM].Hint  := 'Prochaine Optimisation ' +
  //                                  FormatDateTime('dd/mm/yyyy hh:nn',FLastOptimizeDB+FOPTIM_CRON_HR);

  //  EventPanel[CID_OPTIM].SetPopMenuExe('piccobatch.exe', 'auto launcher');
  limMonitor.GetIcon(CID_BACKREST, EventPanel[CID_OPTIM].Icon);


  // Calcul du Stock
  EventPanel[CID_STOCK] := TEventPanel.Create(Self);
  EventPanel[CID_STOCK].ID := 'STOCK';
  EventPanel[CID_STOCK].Left := 400;
  EventPanel[CID_STOCK].Align := alLeft;
  EventPanel[CID_STOCK].Level := logInfo;
  EventPanel[CID_STOCK].Visible := true;
  EventPanel[CID_STOCK].Parent := PnlProgrammes;
  EventPanel[CID_STOCK].Title     := 'Calcul Stock';
  // EventPanel[CID_STOCK].SetPopMenu('GinkoiaCalculStock');
  limMonitor.GetIcon(23, EventPanel[CID_STOCK].Icon);

  sbar.Panels[0].Text := VGSE.Base0;
  if VGSE.AttentionBase0 then
  begin
    sbar.Panels[0].Text := sbar.Panels[0].Text + ' [Attention BASE0]';
  end;

  // Tuile de synchronisation générale sur les états de
  // service Easy
  // heartbeat
  // traffic
  // interbase
  EventPanel[CID_SYNCHRONISATION] := TEventPanel.Create(Self);
  EventPanel[CID_SYNCHRONISATION].Left := 200;
  EventPanel[CID_SYNCHRONISATION].Align := alLeft;
  EventPanel[CID_SYNCHRONISATION].Level := logTrace;
  EventPanel[CID_SYNCHRONISATION].Visible := False;  // Uniquement si Portable de Synchro
  EventPanel[CID_SYNCHRONISATION].Parent := PnlEtatSynchro;
  EventPanel[CID_SYNCHRONISATION].Title := 'Synchroniser maintenant';
  EventPanel[CID_SYNCHRONISATION].Detail := ' '+#13+#10+' ';

  EventPanel[CID_SYNCHRONISATION].ID := 'synchronisation';
  EventPanel[CID_SYNCHRONISATION].Height := PnlEtatSynchro.Height - 10;
  EventPanel[CID_SYNCHRONISATION].width := EventPanel[CID_SYNCHRONISATION].Height * 2;
  EventPanel[CID_SYNCHRONISATION].Hint  := 'Lancer une Synchro manuelle';


  // EventPanel[CID_SYNCHRONISATION].Image.Align := alNone;
//  limMonitor64.GetIcon(0, EventPanel[CID_SYNCHRONISATION].Icon);
  // EventPanel[CID_SYNCHRONISATION].Image.Stretch := true;

  limMonitor64.GetIcon(0, EventPanel[CID_SYNCHRONISATION].Icon);

  EventPanel[CID_SYNCHRONISATION].Image.Width := 64;
  EventPanel[CID_SYNCHRONISATION].Image.Height := 64;
  //  EventPanel[CID_SYNCHRONISATION].Image.Left := round(Frm_Launcher.ClientWidth / 2) - 180;
  //  EventPanel[CID_SYNCHRONISATION].Image.Top := round(PnlEtatSynchro.Height / 2) - 35;
  EventPanel[CID_SYNCHRONISATION].Image.Align := alTop;
  EventPanel[CID_SYNCHRONISATION].Image.Center := true;
  EventPanel[CID_SYNCHRONISATION].Image.Left   := round((EventPanel[CID_SYNCHRONISATION].Width-64) / 2);

  EventPanel[CID_SYNCHRONISATION].LblTitle.Align := alBottom;
  EventPanel[CID_SYNCHRONISATION].LblTitle.Alignment := taCenter;
  {
  EventPanel[CID_SYNCHRONISATION].LblTitle.Layout := tlCenter;
  EventPanel[CID_SYNCHRONISATION].LblTitle.Font.Size := 14;
  // EventPanel[CID_SYNCHRONISATION].Image.Align := alNone;
  EventPanel[CID_SYNCHRONISATION].Image.Width := 32;
  EventPanel[CID_SYNCHRONISATION].Image.Height := 32;
  //  EventPanel[CID_SYNCHRONISATION].Image.Left := round(Frm_Launcher.ClientWidth / 2) - 180;
  //  EventPanel[CID_SYNCHRONISATION].Image.Top := round(PnlEtatSynchro.Height / 2) - 35;
  EventPanel[CID_SYNCHRONISATION].Image.Align := alNone;
  EventPanel[CID_SYNCHRONISATION].Image.Left := round((EventPanel[CID_SYNCHRONISATION].Width-32) / 2);
}

  // C'est lourd mais ca marche....
  TPanel(EventPanel[CID_SYNCHRONISATION]).OnClick   := MyClick;
  EventPanel[CID_SYNCHRONISATION].Image.OnClick     := MyClick;
  EventPanel[CID_SYNCHRONISATION].LblTitle.OnClick  := MyClick;
  EventPanel[CID_SYNCHRONISATION].LblDetail.OnClick := MyClick;
  //-----------------------------------


end;

procedure TFrm_Launcher.FormDestroy(Sender: TObject);
begin
  Log.Log('Main', FBasGUID, 'Log', 'Arrêt du Launcher', logTrace, True, 0, ltLocal);
  Log.Log('Main', FBasGUID, 'Log', 'Launcher arrêté', logTrace, True, 0, ltLocal);
  Log.Log('Main', FBasGUID, 'Status', 'Launcher arrêté', logWarning, True, 3600, ltServer);
  Log.Close;
  // FreeAndNil(ThreadSrvCheckStatusMobilite);
end;

procedure TFrm_Launcher.FormResize(Sender: TObject);
begin
  sbar.Panels[0].Width := Frm_Launcher.ClientWidth - 6 - (sbar.Panels[1].Width + sbar.Panels[2].Width + sbar.Panels[3].Width + sbar.Panels[4].Width);
end;

procedure TFrm_Launcher.FormShow(Sender: TObject);
begin
  // ShowWindow(Application.Handle, SW_HIDE); GR 12/09/2017
end;

procedure TFrm_Launcher.StartAutoRegistry();
var
  reg: TRegistry;
  vLancher: string;
  inRegistry: Boolean;
begin
  inRegistry := False;

  // on regarde si la valeur existe dans le registre
  try
    reg := TRegistry.Create(KEY_READ);
    try
      reg.RootKey := HKEY_LOCAL_MACHINE;
      reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
      vLancher := reg.ReadString('Launch_Replication');
      If UpperCase(Application.ExeName) <> UpperCase(vLancher) then
        inRegistry := False
      else
        inRegistry := True;
    finally
      reg.CloseKey;
      reg.Free;
    end;
  except
    on E: Exception do
    begin
      // peut être mettre un log si pas possible de lire le registre
    end;
  end;

  // On essaye d'ecrire la valeur si pas existante
  if not inRegistry then
  begin
    try
      reg := TRegistry.Create(KEY_WRITE);
      try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
        reg.WriteString('Launch_Replication', Application.ExeName);
      finally
        reg.CloseKey;
        reg.Free;
      end;
    except
      on E: Exception do
      begin
        // result:=false;
      end;
    end;
  end;
end;

procedure TFrm_Launcher.pOuvrirClick(Sender: TObject);
begin
  Self.Show;
  Application.BringToFront;
end;

procedure TFrm_Launcher.pQuitterClick(Sender: TObject);
begin
  FCanClose := False;
  if FForceKill then
    begin
      FCanClose := true;
      Close;
      exit;
    end;
  if Application.MessageBox('Voulez-vous quitter le Launcher EASY ?', pchar('Launcher EASY'), MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_TOPMOST) = IDYES
  then
  begin
    FCanClose := True;
    Close;
  end;
end;

procedure TFrm_Launcher.tmDBTimer(Sender: TObject);
begin
  tmDB.Enabled := False;
  sbar.Panels[1].Text := IntToStr(StrToIntDef(sbar.Panels[1].Text, 0) + 1);
  FDBINFO := TThreadDB.Create(True, FDBFirstPass, CallBackThreadDB);
  FDBINFO.IBFile := VGSE.Base0;
  tmDB.Interval := tmDB.Tag * 1000;
  FDBINFO.Start;
  //-----------------------
  EvalEasyMissingDatas();
  // ----------------------
  EtatLiaisonLame();
end;

procedure TFrm_Launcher.tmWMITimer(Sender: TObject);
begin
  sbar.Panels[3].Text := IntToStr(StrToIntDef(sbar.Panels[3].Text, 0) + 1);
  FWMI := TThreadWMI.Create(True, CallBackThreadWMI);
  // le Log n'est plus fait ici
  // Log.Log('Main', FBasGUID , 'EASY', eventPanel[0].Detail, eventPanel[0].Level, True, 0, ltServer);
  tmWMI.Interval := tmWMI.Tag * 1000;
  // FWMI.Resume; deprecated
  FWMI.Start;
end;

procedure TFrm_Launcher.TrayIcon1DblClick(Sender: TObject);
begin
  Self.Show;
  Application.BringToFront;
end;

procedure TFrm_Launcher.tmLOGTimer(Sender: TObject);
begin
  if FEASYLog = '' then
    exit;
  if FBasGUID = '' then
    exit;
  tmLOG.Enabled := False;
  sbar.Panels[2].Text := IntToStr(StrToIntDef(sbar.Panels[2].Text, 0) + 1);
  FLog := TThreadLOG.Create(True, FBasGUID, FEASYLog, ChangeFileExt(Application.ExeName, '.INI'), CallBackThreadLOG);
  tmLOG.Interval := tmLOG.Tag * 1000;
  // FLog.Resume; // deprecated
  FLog.Start;
end;

procedure TFrm_Launcher.tmSTARTEDTimer(Sender: TObject);
var // delta:Int64;
  vJour: integer;
  vDeltaWidth, I: integer;
  vLevel: TLogLevel;
  vPbInfo: string;
begin
  tmSTARTED.Enabled := False;

  // Est-ce plutot ce Timer qui doit donner les ordres de lancement ?
  vJour := SecondsBetween(Now(), FStartTime) div SecsPerDay;
  // vJour := 1; // TEst Affichage
  sbar.Panels[4].Text := '';
  if vJour > 0 then
  begin
    sbar.Panels[4].Text := Format('%d j ', [vJour]);
  end;

  sbar.Panels[4].Text := sbar.Panels[4].Text + FormatDateTime('hh:nn:ss', SecondsBetween(Now(), FStartTime) / SecsPerDay);

  // On regarde toutes les tuiles visibles
  // On regarde au ... dessus de Erreur
//  vLevel := logInfo;
//  vPbInfo := '';
//  for I := Low(EventPanel) to High(EventPanel) do
//  begin
//    // on ne met à jour le main status que pour les problèmes de réplication
//    If (EventPanel[I].Visible) and (EventPanel[I].Level > vLevel) then
//    begin
//      vLevel := EventPanel[I].Level;
//      // niveau le plus haut
//      vPbInfo := EventPanel[I].Title;
//    end;
//  end;
//
//  if vLevel < logError then
//    Log.Log('Main', FBasGUID, 'Status', 'Launcher OK', logInfo, True, 0, ltServer)
//  else
//    Log.Log('Main', FBasGUID, 'Status', vPbInfo, vLevel, True, 0, ltServer);

  // on ne regarde à présent que le status de la réplication (tuile synchronisation qui est déjà calculée) pour le main status,
  // pour que le monitoring en tienne compte pour l'état des réplications
  If (EventPanel[CID_TRAFFIC_ASC].Level > logInfo) then
    Log.Log('Main', FBasGUID, 'Status', EventPanel[CID_TRAFFIC_ASC].Detail, EventPanel[CID_TRAFFIC_ASC].Level, True, 0, ltServer)
  else
    Log.Log('Main', FBasGUID, 'Status', 'Launcher OK', logInfo, True, 0, ltServer);


  tmSTARTED.Enabled := True;
end;

procedure TFrm_Launcher.RedimLauncher();
var i:integer;
    MaxRight : integer;
begin
   MaxRight := 500;
   for i := Low(EventPanel) to High(EventPanel)-1 do
    begin
      if EventPanel[i].Visible
        then
          begin
              MaxRight := Math.Max(MaxRight,EventPanel[i].Left+EventPanel[i].Width);
          end;
    end;

  // vDeltaWidth := Frm_Launcher.Width - Frm_Launcher.ClientWidth + 10; // ajout de 10 pour prendre en compte la largeur du tabsheet
  // Frm_Launcher.Width := MaxTuile * (108) + vDeltaWidth;

  Frm_Launcher.Width := MaxRight + 20;

  // On repositionne l'image de la tuile de synchro
  // EventPanel[CID_SYNCHRONISATION].Image.Left := round(Frm_Launcher.ClientWidth / 2) - 180;
  // EventPanel[CID_SYNCHRONISATION].Image.Top := round(PnlEtatSynchro.Height / 2) - 35;
end;


procedure TFrm_Launcher.EtatLiaisonLame();
begin
  try
    if not(Assigned(FLinkLame)) and (FURL<>'')
      then
        begin
          FLinkLame := TThreadLinkLame.Create(true,FURL,CallBackLinkLame);
          FLinkLame.Start;
        end;
  finally

  end;
end;

procedure TFrm_Launcher.EvalEasyMissingDatas();
var i,j:integer;
begin
  try
    if not(Assigned(FEvalQtePull)) and (FBasGUID<>'')
      then
        begin
          FEvalQtePull := TThreadWsQtePull.Create(true,FBasGUID,CallBackWSQtePULL);
          FEvalQtePull.Start;
        end;
  finally
    //------------------------------------------------------------------------
  end;
end;


function TFrm_Launcher.LanceOptimisation(): Boolean;
var i,j:integer;
begin
  try
    if not(Assigned(FOptimizeDB))
      then
        begin
          FOptimizeDB := TOptimizeDB.Create(VGSE.Base0,nil,nil,CallBackOptimizeDB);
          FLastOptimizeDB := Now();
          EventPanel[CID_OPTIM].Level := logNotice;
          EventPanel[CID_OPTIM].Detail := FormatDateTime('dd/mm/yyyy hh:nn',FLastOptimizeDB);
          EventPanel[CID_OPTIM].Hint   := 'Optimisation en cours...';
          // Optimisation suivante ' + FormatDateTime('dd/mm/yyyy hh:nn',FLastOptimizeDB+CST_CRON_OPTIM)
          SaveIniDateTime('OptimizeDB', FLastOptimizeDB);
          FOptimizeDB.Start;
          result:=true;
        end;
  except
    result:=False;
  end;
end;


function TFrm_Launcher.LanceCGT(): Boolean;
var
  vNow: TDateTime;
  vFilename: TFileName;
  vPath: string;
  vReturn: integer;
  vError: string;

  cloture: TclotGdTot;
begin
  FLastCGT := Now();

  if VGSE.AttentionBase0 then
  begin
    Log.Log('Main', BasGUID, 'CGT', 'Mauvaise Base0', logWarning, True, 0, ltServer);
    exit;
  end;

  EventPanel[CID_CGT].Hint := 'Dernière tentative de lancement : ' + FormatDateTime('dd/mm/yyyy hh:nn', FLastCGT);

  cloture := TclotGdTot.Create(StrToInt(BASID), VGSE.Base0);
  try
    try
      cloture.DoGrandTotauxClose;
      FLastCGT := LoadIniDateTime('CGT');
      EventPanel[CID_CGT].Detail := FormatDateTime('dd/mm/yyyy hh:nn', FLastCGT);
      EventPanel[CID_CGT].Hint := 'Dernière tentative de lancement : ' + FormatDateTime('dd/mm/yyyy hh:nn', FLastCGT) + ' > OK';
      EventPanel[CID_CGT].Level := logInfo;
      Log.Log('Main', FBasGUID, 'CGT', 'Cloture des grands totaux effectuée', logInfo, True, 0, ltServer);
    except
      on E: Exception do
      begin
        EventPanel[CID_CGT].Hint := EventPanel[CID_CGT].Hint + ' >> Erreur : ' + E.Message;
        EventPanel[CID_CGT].Level := logError;

        Log.Log('Main', FBasGUID, 'CGT', 'Erreur lors de la cloture des grands totaux : ' + E.Message, logInfo, True, 0, ltServer);
      end;
    end;

    FDateLastCloture := Trunc(Now)
  finally
    cloture.Free;
  end;
end;

procedure TFrm_Launcher.LanceFusion();
var
  UpdateDB: TupdateDB;
  query: string;
begin
  try
    UpdateDB := TupdateDB.Create(VGSE.Base0, StrToInt(BASID));
    try
      query := 'EXECUTE PROCEDURE FUSMOD_DOCUMENTS';
      UpdateDB.ExecQuery(query);

      if UpdateDB.Error = '' then
        Log.Log('FusionModele', BasGUID, 'Status', 'Fusion des modèles exécutée', logInfo, True, 0, ltboth)
      else
        Log.Log('FusionModele', BasGUID, 'Status', UpdateDB.Error, logError, True, 0, ltboth);

    finally
      UpdateDB.Free;
    end;
  except
    on E: Exception do
      Log.Log('FusionModele', BasGUID, 'Status', 'Erreur lors de la fusion modèles : ' + E.Message, logError, True, 0, ltboth);
  end;

  FLastFusion := Now;
  SaveIniDateTime('Fusion', FLastFusion);
end;

function TFrm_Launcher.LanceNettoieGinkoia(): Boolean;
var
  vNow: TDateTime;
begin
  Log.Log('LanceNettoieGinkoia', FBasGUID, 'Status', 'Start', logInfo, True, 0, ltLocal);
  if VGSE.AttentionBase0 then
  begin
    Log.Log('LanceNettoieGinkoia', BasGUID, 'Status', 'Mauvaise Base0', logWarning, True, 0, ltLocal);
    exit;
  end;
  if ExecNettoieGinkoia(3600, FPARAM_11_60.PRMSTRING, FBasNOMPOURNOUS, FBasGUID) then
  begin
    vNow := Now();
    SaveIniDateTime('NettoieGinkoia', vNow);
    // Mise à jour de la tuille
    EventPanel[CID_NETTOIE].Detail := FormatDateTime('dd/mm/yyyy hh:nn', vNow);
    EventPanel[CID_NETTOIE].Level := logInfo;
    Log.Log('LanceNettoieGinkoia', FBasGUID, 'Status', '', logInfo, True, 0, ltLocal);
  end
  else
    Log.Log('LanceNettoieGinkoia', FBasGUID, 'Status', '[processus interrompu]', logWarning, True, 0, ltLocal);
end;

procedure TFrm_Launcher.DoLogServices(aServiceTitle, aLogMdl, aLogKey: string; aLogType: TLogType = ltServer; aLogFreq: integer = 0);
var
  I, IPanel: integer;
  UpdateDB: TupdateDB;
  infoToLog: string;
  aPanel: TPanel;
begin
  for IPanel := Low(ListPanels) to High(ListPanels) do
  begin
    aPanel := ListPanels[IPanel];

    for I := 0 to aPanel.ControlCount - 1 do
    begin
      if (aPanel.Controls[I] is TEventPanel) then
      begin
        with TEventPanel(aPanel.Controls[I]) do
        begin
          // On log que les visibles
          if Visible then
            If (Title = aServiceTitle) then
            begin
              infoToLog := InfoValue1;

              if (aLogMdl = 'DiskSpace') OR ((aLogMdl = 'BI') and (aLogKey = 'DteLast')) then
                infoToLog := InfoValue2;
              if (aLogMdl = 'BI') and (aLogKey = 'Status') then
                infoToLog := '';

              Log.Log(aLogMdl, BasGUID, aLogKey, infoToLog, Level, True, 0, ltServer);

              // si c'est le module BaseSize (et qu'on est pas en cours de backup restore), on met à jour le GENPARAM
              if (aLogMdl = 'BaseSize') and (FBackRestRunning = 0) then
              begin
                // on met à jour le genparam avec la taille de la base et on le mouvemente
                try
                  UpdateDB := TupdateDB.Create(VGSE.Base0, StrToInt(BASID));
                  try
                    UpdateDB.UpdateGenParam(PARAM_60_3.PRMTYPE, PARAM_60_3.PRMCODE, StrToInt(infoToLog), TypeInteger);
                  finally
                    UpdateDB.Free;
                  end;
                except
                  on E: Exception do
                    Log.Log('BaseSize', BasGUID, 'Base', 'Erreur lors de la mise à jour du genparam type 60 code 3 : ' + E.Message, logError, True, 0, ltLocal);
                end;
              end;

              // Si on a trouvé le service dans le panel, on sort
              exit;

            End;
        end;

      end
    end;
  end;
end;

PROCEDURE TFrm_Launcher.LaunchPiccoAuto();
var
  PathExe: string;
  UpdateDB: TupdateDB;
begin
  try
    // on vérifie qu'on est pas en base Test ou Archive, puis on regarde dans le GENPARAM si c'est au launcher de le lancer
    if IsBaseProd then
    begin
      // si PRM_INTEGER = -1, c'est au launcher de lancer le Piccobatch en mode automatique
      if PARAM_9_414.PRMINTEGER = -1 then
      begin
        // on vérifie que les échange et retours sont bien cochés en mode automatique

        UpdateDB := TupdateDB.Create(VGSE.Base0, StrToInt(BASID));
        try
          if (UpdateDB.IsPiccobatchAuto(StrToInt(BasMAGID))) then
          begin
            EventPanel[CID_PICCOBATCH].Visible := True;

            // on vérifie d'abord si le process tourne déjà, si il tourne on ne fait rien de plus
            if not(ProcessExists('piccobatch.exe')) then
            begin
              // lancement de PiccoBatch en mode auto
              PathExe := ExtractFilePath(ParamStr(0)) + 'piccobatch.exe';

              // Exest
              ShellExecute(0, 'Open', PWideChar(PathExe), PWideChar('auto launcher'), Nil, SW_SHOWDEFAULT);

              Log.Log('Main', BasGUID, 'Log', 'Démarrage de PiccoBatch en mode automatique', logTrace, True, 0, ltLocal);
            end;
          end;
        finally
          UpdateDB.Free;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Log.Log('Piccobatch', BasGUID, 'Lancement automatique', 'Erreur lors du lancement automatique de Piccobatch : ' + E.Message, logError, True, 0, ltLocal);
    end;
  END;
end;

procedure TFrm_Launcher.LblPlusClick(Sender: TObject);
begin

  PageControl.ActivePage := TabDetails;

  // changement de panel des tuiles communes
  EventPanel[CID_CLOUD].Align := alNone;
  EventPanel[CID_TRAFFIC_ASC].Align := alNone;
  EventPanel[CID_TRAFFIC_DESC].Align := alNone;
  EventPanel[CID_CLOUD].Left         :=0;
  EventPanel[CID_TRAFFIC_ASC].Left   :=100;
  EventPanel[CID_TRAFFIC_DESC].Left  :=200;

  EventPanel[CID_SERVICEREPRISE].Align := alLeft;
  EventPanel[CID_SERVICEREPRISE].Parent := PnlProgrammes;
  EventPanel[CID_BI].Align := alLeft;
  EventPanel[CID_BI].Parent := PnlProgrammes;
  EventPanel[CID_BACKREST].Parent := PnlProgrammes;

  // il faut le redimentionn
  EventPanel[CID_CLOUD].Parent := PnlSynchro;
  EventPanel[CID_CLOUD].Align := alLeft;
  EventPanel[CID_CLOUD].Width   := 100;
  EventPanel[CID_CLOUD].Height  := 100;
  EventPanel[CID_CLOUD].Image.Left := round((EventPanel[CID_CLOUD].Width-32) / 2);

  // il faut le redimentionn
  EventPanel[CID_TRAFFIC_ASC].Parent := PnlSynchro;
  EventPanel[CID_TRAFFIC_ASC].Align := alLeft;
  EventPanel[CID_TRAFFIC_ASC].Width   := 100;
  EventPanel[CID_TRAFFIC_ASC].Height  := 100;
  EventPanel[CID_TRAFFIC_ASC].Image.Left := round((EventPanel[CID_TRAFFIC_ASC].Width-32) / 2);

  // il faut le redimentionn
  EventPanel[CID_TRAFFIC_DESC].Parent := PnlSynchro;
  EventPanel[CID_TRAFFIC_DESC].Align := alLeft;
  EventPanel[CID_TRAFFIC_DESC].Width   := 100;
  EventPanel[CID_TRAFFIC_DESC].Height  := 100;
  EventPanel[CID_TRAFFIC_DESC].Image.Left := round((EventPanel[CID_TRAFFIC_DESC].Width-32) / 2);

  RedimLauncher;

end;

procedure TFrm_Launcher.LblRetourClick(Sender: TObject);
begin
  PageControl.ActivePage := TabMain;

  // changement de panel des tuiles communes
  EventPanel[CID_SERVICEREPRISE].Align := alRight;
  EventPanel[CID_SERVICEREPRISE].Parent := PnlMainBot;

  EventPanel[CID_CLOUD].Align := alNone;
  EventPanel[CID_TRAFFIC_ASC].Align := alNone;
  EventPanel[CID_TRAFFIC_DESC].Align := alNone;
  EventPanel[CID_CLOUD].Left         :=0;
  EventPanel[CID_TRAFFIC_ASC].Left   :=100;
  EventPanel[CID_TRAFFIC_DESC].Left  :=200;


  EventPanel[CID_CLOUD].Parent  := PnlEtatSynchro;
  EventPanel[CID_CLOUD].Align := alLeft;
  EventPanel[CID_CLOUD].Height  := PnlEtatSynchro.height-10;
  EventPanel[CID_CLOUD].Width   := EventPanel[CID_CLOUD].Height;
  EventPanel[CID_CLOUD].Image.Left := round((EventPanel[CID_CLOUD].Width-32) / 2);

  EventPanel[CID_TRAFFIC_ASC].Parent  := PnlEtatSynchro;
  EventPanel[CID_TRAFFIC_ASC].Align := alLeft;
  EventPanel[CID_TRAFFIC_ASC].Height  := PnlEtatSynchro.height-10;
  EventPanel[CID_TRAFFIC_ASC].Width   := EventPanel[CID_TRAFFIC_ASC].Height;
  EventPanel[CID_TRAFFIC_ASC].Image.Left := round((EventPanel[CID_TRAFFIC_ASC].Width-32) / 2);

  EventPanel[CID_TRAFFIC_DESC].Parent  := PnlEtatSynchro;
  EventPanel[CID_TRAFFIC_DESC].Align := alLeft;
  EventPanel[CID_TRAFFIC_DESC].Height  := PnlEtatSynchro.height-10;
  EventPanel[CID_TRAFFIC_DESC].Width   := EventPanel[CID_TRAFFIC_DESC].Height;
  EventPanel[CID_TRAFFIC_DESC].Image.Left := round((EventPanel[CID_TRAFFIC_DESC].Width-32) / 2);


  EventPanel[CID_BI].Align := alRight;
  EventPanel[CID_BI].Parent := PnlMainBot;
  EventPanel[CID_BACKREST].Parent := PnlMainBot;

  RedimLauncher;

end;

function TFrm_Launcher.updateVerification(): Boolean;
var
  sPath: string;
begin
  result := False;

  sPath := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));

  if FileExists(sPath + 'A_MAJ\verification.exe') then
  begin
    Log.Log('Main', FBasGUID, 'Log', 'Mise à jour de Verification', logInfo, True, 0, ltLocal);

    if CopyFile(pchar(sPath + 'A_MAJ\verification.exe'), pchar(sPath + 'verification.exe'), False) then
    begin
      Log.Log('Main', FBasGUID, 'Log', 'Mise à jour de Verification effectuée', logInfo, True, 0, ltLocal);
      if not DeleteFile(pchar(sPath + 'A_MAJ\verification.exe')) then
        Log.Log('Main', FBasGUID, 'Log', 'Erreur lors de la suppression de Verification dans A_MAJ', logError, True, 0, ltLocal);

      result := True;
    end
    else
    begin
      Log.Log('Main', FBasGUID, 'Log', 'Erreur lors de la mise à jour de Verification', logError, True, 0, ltLocal);
    end;
  end
  else
    result := True;

end;

end.
