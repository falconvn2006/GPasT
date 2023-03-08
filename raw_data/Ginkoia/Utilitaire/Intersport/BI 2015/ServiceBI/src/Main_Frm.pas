unit Main_Frm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.SyncObjs,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.SvcMgr,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  FireDAC.Comp.Client,
  uLogFile,
  uCreateProcess,
  UBaseThread,
  UIBUtilsThread;

type
  TCountTraitement = (ect_None, ect_Some, ect_All);

type
  TMagasin = class(TObject)
  protected
    FID : integer;
    FActif : boolean;
    FInit : TDateTime;
    FSpecif : string;
  public
    constructor Create(ID : integer; Actif : boolean; Init : TDateTime; Specif : string); reintroduce;

    function SomeThingToDo() : boolean;
    function HasInit() : boolean;
    function HasSpecif() : boolean;

    property ID : integer read FID;
    property Actif : boolean read Factif;
    property Init : TDateTime read FInit;
    property Specif : string read FSpecif;
  end;
  TListeMag = Class(TObjectList<TMagasin>)
  public
    function SomeThingToDo() : boolean;
    function HasInit() : TCountTraitement;
    function HasSpecif() : TCountTraitement;
    function GetInitMagID() : string;
  end;

type
  TService_BI_Ginkoia = class(TService)
    tmr_Param: TTimer;
    tmr_Traitement: TTimer;
    tmr_ForceStopExp: TTimer;
    tmr_ForceStopImp: TTimer;

    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceAfterUninstall(Sender: TService);
    procedure ServiceBeforeInstall(Sender: TService);
    procedure ServiceBeforeUninstall(Sender: TService);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceShutdown(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);

    procedure tmr_ParamTimer(Sender: TObject);
    procedure tmr_TraitementTimer(Sender: TObject);
    procedure tmr_ForceStopExpTimer(Sender: TObject);
    procedure tmr_ForceStopImpTimer(Sender: TObject);
  private
    { Déclarations privées }
    // Objet de log
    FLogs : TLogFile;

    // Exe de traitement
    FExpExeName, FImpExeName : string;
    // chemin des bases
    FBaseGin, FBaseTpn : string;
    // backup
    FThreadGFix : TGFixThread;
    FThreadBackup : TBaseBackRestThread;
    // Compteur de temps pour les traitement
    FTempo : integer;
    FNextInit, FNextExpTrait, FNextImpTrait, FTimeReset, FLastReset, FNextReset : TDateTime;
    // faut il faire un traitement de log ?
    FLastDone : boolean;
    // periode d'arret !
    FTimeStop, FTimeStart : TDateTime;

    // Infos de base
    FBaseNom, FBaseGUID : string;

    // Durée de conservation (en années)
    FMinVte, FMinMvt, FMinCmd, FMinRap, FMinStk : integer;

    // est ce qu'un traitement d'init est en cours .
    FDoInit, FDoReset : boolean;
    // handle sur la process
    FExpProcess, FImpProcess : TCreateProcess;
    // Tick de debut de tentative de stop !
    FExpStartKill, FImpStartKill : cardinal;

    procedure StopProcess(TimeOut : cardinal; Const ExeName : string; var StartKill : cardinal; var Process : TCreateProcess);

    function GetServiceParam(var ListeMag : TListeMag) : boolean;
    procedure DoActivationMag(MagId : integer; Actif : boolean);
    procedure ClearSpecifMag(MagId : integer);

    procedure BackupRestore();

    function TraitementExpTrt() : boolean;
    function TraitementExpMonitor() : boolean;
    function TraitementInit(ListeMag : TListeMag) : boolean;
    function TraitementSpecif(ListeMag : TListeMag) : boolean;
    function TraitementReset() : boolean;
    function TraitementPurge() : boolean;
    procedure TraitementExpOut(Sender: TObject);
    procedure TraitementExpErr(Sender: TObject);
    procedure TraitementExpEnd(Sender: TObject);

    function TraitementImpTrt() : boolean;
    function TraitementImpMonitor() : boolean;
    procedure TraitementImpOut(Sender: TObject);
    procedure TraitementImpErr(Sender: TObject);
    procedure TraitementImpEnd(Sender: TObject);

    procedure updateServiceACL();
  public
    { Déclarations publiques }
    function GetServiceController() : TServiceController; override;
  end;

var
  Service_BI_Ginkoia : TService_BI_Ginkoia;

implementation

uses
  Winapi.ShellAPI,
  System.Math,
  System.DateUtils,
  System.StrUtils,
  System.Win.Registry,
  System.TypInfo,
  uGestionBDD,
  uGetWindowsList,
  uMessage,
  uIntervalText,
  uConstHistoEvent,
  UVersion,
  uLog;

{$R *.dfm}

const
  EXP_EXE_NAME = 'ExtractBI.exe';
  IMP_EXE_NAME = 'ImportBI.exe';
  LONG_BEFORE_HALT = 2700000; // 45 minutes
  LONG_BEFORE_KILL =  900000; // 15 minutes
  TIME_BETWEEN_LOOP =  60000; //  1 minute

{ --- }

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  Service_BI_Ginkoia.Controller(CtrlCode);
end;

{ TMagasin }

constructor TMagasin.Create(ID : integer; Actif : boolean; Init : TDateTime; Specif : string);
begin
  Inherited Create();
  FID := ID;
  FActif := Actif;
  FInit := Init;
  FSpecif := Specif;
end;

function TMagasin.SomeThingToDo() : boolean;
begin
  Result := FActif or
            HasInit() or
            HasSpecif();
end;

function TMagasin.HasInit() : boolean;
begin
  Result := not FActif and (FInit > 2) and (FInit <= Now());
end;

function TMagasin.HasSpecif() : boolean;
begin
  Result := FActif and ( ((FInit > 2) and (FInit <= Now())) or (FInit <= 2) ) and not (Trim(FSpecif) = '');
end;

{ TListeMag }

function TListeMag.SomeThingToDo() : boolean;
var
  Mag : TMagasin;
begin
  Result := false;
  for Mag in Self do
    if Mag.SomeThingToDo() then
    begin
      Result := true;
      Exit;
    end;
end;

function TListeMag.HasInit() : TCountTraitement;
var
  Mag : TMagasin;
  nb : integer;
begin
  nb := 0;
  for Mag in Self do
    if Mag.HasInit() then
      Inc(nb);

  if nb = count then
    Result := ect_All
  else if nb > 0 then
    Result := ect_Some
  else
    Result := ect_None;
end;

function TListeMag.HasSpecif() : TCountTraitement;
var
  Mag : TMagasin;
  nb : integer;
begin
  nb := 0;
  for Mag in Self do
    if Mag.HasSpecif() then
      Inc(nb);

  if nb = count then
    Result := ect_All
  else if nb > 0 then
    Result := ect_Some
  else
    Result := ect_None;
end;

function TListeMag.GetInitMagID() : string;
var
  Mag : TMagasin;
begin
  Result := '';
  for Mag in Self do
    if Mag.HasInit() then
    begin
      if Result = '' then
        Result := IntToStr(Mag.ID)
      else
        Result := Result + ';' + IntToStr(Mag.ID);
    end;
end;

{ TService_BI_Ginkoia }

// evenement

procedure TService_BI_Ginkoia.ServiceAfterInstall(Sender: TService);
var
  Reg: TRegistry;
begin
  FLogs.Log('** ServiceAfterInstall **', uLogFile.logTrace);

  try
    Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Name, false) then
    begin
      Reg.WriteString('Description', 'Service d''extraction de données vers une base tampon.');
      Reg.CloseKey();
    end;
  finally
    FreeAndNil(Reg);
  end;
  updateServiceACL();
end;

procedure TService_BI_Ginkoia.ServiceAfterUninstall(Sender: TService);
begin
  FLogs.Log('** ServiceAfterUninstall **', uLogFile.logTrace);
end;

procedure TService_BI_Ginkoia.ServiceBeforeInstall(Sender: TService);
begin
  FLogs.Log('** ServiceBeforeInstall **', uLogFile.logTrace);
end;

procedure TService_BI_Ginkoia.ServiceBeforeUninstall(Sender: TService);
begin
  FLogs.Log('** ServiceBeforeUninstall **', uLogFile.logTrace);
end;

procedure TService_BI_Ginkoia.ServiceContinue(Sender: TService; var Continued: Boolean);
begin
  FLogs.Log('** ServiceContinue **', uLogFile.logTrace);

  tmr_Param.Enabled := true;
  Continued := tmr_Param.Enabled;
end;

procedure TService_BI_Ginkoia.ServiceCreate(Sender: TObject);
var
  Reg : TRegistry;
begin
  // recherche de la base en base de registre
  try
    Reg := TRegistry.Create(KEY_READ);
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('\Software\Algol\Ginkoia\') then
    begin
      FBaseGin := Reg.ReadString('Base0');
    end;
  finally
    FreeAndNil(Reg);
  end;
  // init du log
  FLogs := TLogFile.Create(ExtractFilePath(ParamStr(0)) + '\Logs\{%APP}_{%DATE}.log', false);
  FLogs.logLevel := uLogFile.logDebug;
  FLogs.Log('');
  FLogs.Log('==================================================', uLogFile.logInfo);
  FLogs.Log('Démarage du service (v' + GetNumVersionSoft() + ')', uLogFile.logInfo);
  // executable d'export ?
  if FileExists(ExtractFilePath(ParamStr(0)) + EXP_EXE_NAME) then
    FExpExeName := ExtractFilePath(ParamStr(0)) + EXP_EXE_NAME
  else if FileExists(ExtractFilePath(ParamStr(0)) + '..\..\..\ExtractBI\Win32\Debug\' + EXP_EXE_NAME) then
    FExpExeName := ExtractFilePath(ParamStr(0)) + '..\..\..\ExtractBI\Win32\Debug\' + EXP_EXE_NAME;
  FExpExeName := ExpandFileName(FExpExeName);
  FExpProcess := nil;
  FExpStartKill := 0;
  // executable d'import ?
  if FileExists(ExtractFilePath(ParamStr(0)) + IMP_EXE_NAME) then
    FImpExeName := ExtractFilePath(ParamStr(0)) + IMP_EXE_NAME
  else if FileExists(ExtractFilePath(ParamStr(0)) + '..\..\..\ImportBI\Win32\Debug\' + IMP_EXE_NAME) then
    FImpExeName := ExtractFilePath(ParamStr(0)) + '..\..\..\ImportBI\Win32\Debug\' + IMP_EXE_NAME;
  FImpExeName := ExpandFileName(FImpExeName);
  FImpProcess := nil;
  FImpStartKill := 0;
  // backup
  FThreadGFix := nil;
  FThreadBackup := nil;
  // init !
  FTempo := 15;
  FNextInit := 0;
  FNextExpTrait := Now();
  FNextImpTrait := Now();
  FTimeReset := 0;
  FLastReset := 0;
  FNextReset := 0;
  FLastDone := false;
  FTimeStop := 0;
  FTimeStart := 0;
  // variable de traitement en cours
  FDoInit := false;
  FDoReset := false;
end;

procedure TService_BI_Ginkoia.ServiceDestroy(Sender: TObject);
begin
  FLogs.Log('Fermture du service', uLogFile.logInfo);
  FLogs.Log('==================================================', uLogFile.logInfo);
  FreeAndNil(FLogs);
end;

procedure TService_BI_Ginkoia.ServicePause(Sender: TService; var Paused: Boolean);
var
  WinInfo : TWindowsInfo;
begin
  FLogs.Log('** ServicePause **', uLogFile.logTrace);

  tmr_Param.Enabled := false;
  tmr_Traitement.Enabled := false;
  tmr_ForceStopExp.Enabled := false;
  tmr_ForceStopImp.Enabled := false;

  // un process en cours ?
  if Assigned(FExpProcess) then
  begin
    WinInfo := FindWindowsByClass(FExpProcess.ProcessInfo.dwProcessId, 'Tfrm_Main');
    PostMessage(WinInfo.HWND, WM_ASK_TO_KILL, 0, 0);
    while Assigned(FExpProcess) do
    begin
      Sleep(1000);
      ReportStatus();
    end;
  end;
  if Assigned(FImpProcess) then
  begin
    WinInfo := FindWindowsByClass(FImpProcess.ProcessInfo.dwProcessId, 'Tfrm_Main');
    PostMessage(WinInfo.HWND, WM_ASK_TO_KILL, 0, 0);
    while Assigned(FImpProcess) do
    begin
      Sleep(1000);
      ReportStatus();
    end;
  end;
end;

procedure TService_BI_Ginkoia.ServiceShutdown(Sender: TService);
begin
  FLogs.Log('** ServiceShutdown **', uLogFile.logTrace);
end;

procedure TService_BI_Ginkoia.ServiceStart(Sender: TService; var Started: Boolean);
begin
  FLogs.Log('** ServiceStart **', uLogFile.logTrace);
  updateServiceACL();
end;

procedure TService_BI_Ginkoia.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  FLogs.Log('** ServiceStop **', uLogFile.logTrace);

  // un process en cours ?
  if Assigned(FExpProcess) then
  begin
    repeat
      StopProcess(LONG_BEFORE_KILL, FExpExeName, FExpStartKill, FExpProcess);
      Sleep(1000);
      ReportStatus();
    until not Assigned(FExpProcess);
  end;
  if Assigned(FImpProcess) then
  begin
    repeat
      StopProcess(LONG_BEFORE_KILL, FImpExeName, FImpStartKill, FImpProcess);
      Sleep(1000);
      ReportStatus();
    until not Assigned(FImpProcess);
  end;
  // un GFix en cours ?
  if Assigned(FThreadGFix) then
  begin
    while WaitForSingleObject(FThreadGFix.Handle, 1000) = WAIT_TIMEOUT do
      ReportStatus();
  end;
  // un backup en cours ?
  if Assigned(FThreadBackup) then
  begin
    while WaitForSingleObject(FThreadBackup.Handle, 1000) = WAIT_TIMEOUT do
      ReportStatus();
  end;
end;

// timmer !

procedure TService_BI_Ginkoia.tmr_ParamTimer(Sender: TObject);
var
  ListeMag : TListeMag;
begin
  ListeMag := nil;
  if not (Status = csRunning) then
    Exit;

  FLogs.Log('** tmr_ParamTimer **', uLogFile.logTrace);

  try
    if GetServiceParam(ListeMag) then
    begin
      // recup de la base si elle a été bloqué en cours de backup !
      if not FileExists(FBaseTpn) then
      begin
        if FileExists(ChangeFileExt(FBaseTpn, '.OLD')) then
        begin
          DeleteFile(ChangeFileExt(FBaseTpn, '.TMP'));
          DeleteFile(ChangeFileExt(FBaseTpn, '.NEW'));
          MoveFile(PWideChar(ChangeFileExt(FBaseTpn, '.OLD')), PWideChar(FBaseTpn));
        end;
      end;
      // lancement d'un Backup/Restore
      BackupRestore();
      // timer de traitement ...
      tmr_Traitement.Enabled := true;
      // et suppression de celui ci !
      tmr_Param.Enabled := false;
    end;
  finally
    FreeAndNil(ListeMag);
  end;
end;

procedure TService_BI_Ginkoia.tmr_TraitementTimer(Sender: TObject);
var
  ListeMag : TListeMag;
begin
  ListeMag := nil;
  if not (Status = csRunning) then
    Exit;

  FLogs.Log('** tmr_TraitementTimer **', uLogFile.logTrace);

  // si c'est la bonne heure ??
  if (FNextInit > 2) and (Now() > FNextInit) then
  begin
    try
      if GetServiceParam(ListeMag) then
      begin
        if ListeMag.SomeThingToDo() then
        begin
          // initialisation a faire !
          FLogs.Log('-> Initialisation a faire !!', uLogFile.logTrace);

          // fermeture de l'ancien export !
          if FDoInit then
          begin
            FLogs.Log('-> Déjà en cours ?? c''est une init on ne touche pas !!', uLogFile.logTrace);
          end
          else if Assigned(FExpProcess) or Assigned(FImpProcess) then
          begin
            if Assigned(FExpProcess) then
            begin
              FLogs.Log('-> Export déjà en cours ?? On le stop !!', uLogFile.logTrace);
              StopProcess(LONG_BEFORE_KILL, FExpExeName, FExpStartKill, FExpProcess);
            end;
            if Assigned(FImpProcess) then
            begin
              FLogs.Log('-> Import déjà en cours ?? On le stop !!', uLogFile.logTrace);
              StopProcess(LONG_BEFORE_KILL, FImpExeName, FImpStartKill, FImpProcess);
            end;
          end
          else
          begin
            // reinitialisation
            FExpStartKill := 0;
            FImpStartKill := 0;
            // lancement du traitement !
            TraitementInit(ListeMag);
            // reinit du time de prochaine initialisation
            FNextInit := IncMonth(Trunc(Now()) + EncodeTime(4, 0, 0, 0), 1);
          end;
        end
        else
          FLogs.Log('-> Pas de traitement a faire', uLogFile.logTrace);
      end
      else
        FLogs.Log('-> Erreur dans GetServiceParam()', uLogFile.logTrace);
    finally
      FreeAndNil(ListeMag);
    end;
  end
  else if (Frac(Now()) >= FTimeStart) and (Frac(Now()) <= FTimeStop) then
  begin
    try
      if GetServiceParam(ListeMag) then
      begin
        if ListeMag.SomeThingToDo() then
        begin
          if (Now() >= FNextReset) then
          begin
            // traitement a faire !
            FLogs.Log('-> Reset de stock a faire !!', uLogFile.logTrace);
            // fermeture de l'ancien export !
            if FDoReset then
            begin
              FLogs.Log('-> Déjà en cours ?? c''est un reset on ne touche pas !!', uLogFile.logTrace);
            end
            else if Assigned(FExpProcess) then
            begin
              FLogs.Log('-> Déjà en cours ?? On le stop !!', uLogFile.logTrace);
              StopProcess(LONG_BEFORE_KILL, FExpExeName, FExpStartKill, FExpProcess);
            end
            else
            begin
              // reinitialisation
              FExpStartKill := 0;
              // lancement du traitement !
              TraitementReset();
              // reinit du time de prochain Reset de stock
              FNextReset := IncDay(FNextReset);
            end;
          end
          else if (Now() >= FNextExpTrait) then
          begin
            // traitement a faire !
            FLogs.Log('-> Traitement a faire !!', uLogFile.logTrace);
            // Traitement d'export si pas déjà
            FLogs.Log('   Export ?', uLogFile.logTrace);
            if not Assigned(FExpProcess) then
            begin
              // traitement specifique
              if not (ListeMag.HasSpecif() = ect_None) then
                TraitementSpecif(ListeMag);
              // puis traitement normal !
              TraitementExpTrt();
            end
            else
              FLogs.Log('-> Déjà en cours...', uLogFile.logTrace);
            // Traitement d'import si pas déjà
            FLogs.Log('   Import ?', uLogFile.logTrace);
            if not Assigned(FImpProcess) then
            begin
              // traitement d'import
              TraitementImpTrt();
            end
            else
              FLogs.Log('-> Déjà en cours...', uLogFile.logTrace);
            // reinit du time de prochain traitement
            FNextExpTrait := IncMinute(FNextExpTrait, FTempo);
          end
          else
            FLogs.Log('-> Pas encore temps...', uLogFile.logTrace);
        end
        else
          FLogs.Log('-> Pas de traitement a faire', uLogFile.logTrace);
      end
      else
        FLogs.Log('-> Erreur dans GetServiceParam()', uLogFile.logTrace);
      // reinit du flag de prochain monitoring
      FLastDone := false;
    finally
      FreeAndNil(ListeMag);
    end;
  end
  else if (Frac(Now()) > FTimeStop) and not FLastDone then
  begin
    try
      if GetServiceParam(ListeMag) then
      begin
        if ListeMag.SomeThingToDo() then
        begin
          // traitement de monitoring a faire !
          FLogs.Log('-> Monitoring a faire !!', uLogFile.logTrace);
            // Traitement si pas déjà
          if not Assigned(FExpProcess) then
          begin
            // purge ??
            if Trunc(Now()) = Trunc(StartOfTheMonth(Now())) then
            begin
              FLogs.Log('-> Purge a faire !!', uLogFile.logTrace);
              TraitementPurge();
            end;
            // traitement normal
            TraitementExpMonitor();
            TraitementImpMonitor();
            // reinit du flag de prochain monitoring
            FLastDone := true;
          end
          else
            FLogs.Log('-> Déjà en cours...', uLogFile.logTrace);
        end
        else
          FLogs.Log('-> Pas de traitement a faire', uLogFile.logTrace);
      end
      else
        FLogs.Log('-> Erreur dans GetServiceParam()', uLogFile.logTrace);
    finally
      FreeAndNil(ListeMag);
    end;
  end
  else
    FLogs.Log('-> Hors plage...', uLogFile.logTrace);
end;

procedure TService_BI_Ginkoia.tmr_ForceStopExpTimer(Sender: TObject);
begin
  if not (Status = csRunning) then
    Exit;

  if Assigned(FExpProcess) then
  begin
    FLogs.Log('** ForceStopExpTimer **', uLogFile.logTrace);

    tmr_ForceStopExp.Interval := TIME_BETWEEN_LOOP; // une minute !
    StopProcess(LONG_BEFORE_KILL, FExpExeName, FExpStartKill, FExpProcess);
  end
  else
  begin
    tmr_ForceStopExp.Enabled := false;
    FExpStartKill := 0;
  end;
end;

procedure TService_BI_Ginkoia.tmr_ForceStopImpTimer(Sender: TObject);
begin
  if not (Status = csRunning) then
    Exit;

  if Assigned(FImpProcess) then
  begin
    FLogs.Log('** ForceStopImpTimer **', uLogFile.logTrace);

    tmr_ForceStopImp.Interval := TIME_BETWEEN_LOOP; // une minute !
    StopProcess(LONG_BEFORE_KILL, FImpExeName, FImpStartKill, FImpProcess);
  end
  else
  begin
    tmr_ForceStopImp.Enabled := false;
    FImpStartKill := 0;
  end;
end;

// fonction d'arret !

procedure TService_BI_Ginkoia.StopProcess(TimeOut : cardinal; const ExeName : string; var StartKill : cardinal; var Process : TCreateProcess);
var
  Error, TickForNow : Cardinal;
  WinInfo : TWindowsInfo;
  PrcInfo : TProcessInfo;
  tmpHandle : THandle;
begin
  FLogs.Log('  ** StopProcess (' + ExeName + ') **', uLogFile.logTrace);

  if Assigned(Process) then
  begin
    FLogs.Log('   -> Running... go to stop !', uLogFile.logDebug);

    if StartKill = 0 then
      StartKill := GetTickCount();
    TickForNow := GetTickCount() - StartKill;

    if TickForNow < TimeOut then
    begin
      WinInfo := FindWindowsByClass(Process.ProcessInfo.dwProcessId, 'Tfrm_Main');
      if WinInfo.HWND = 0 then
        FLogs.Log('   -> Windows not found ??', uLogFile.logDebug)
      else
      begin
        FLogs.Log('   -> Send stop to process "' + IntToStr(WinInfo.PID) + '" windows "' + IntToStr(WinInfo.HWND) + '"', uLogFile.logDebug);
        SendMessage(WinInfo.HWND, WM_ASK_TO_KILL, 0, 0);
      end;
//      Process.StdIn.WriteLn('STOP');
    end
    else
    begin
      FLogs.Log('   -> Elapsed time... go to kill !', uLogFile.logDebug);
      if Process.Kill(97) then
        FLogs.Log('   -> Kill successfull !', uLogFile.logDebug)
      else
      begin
        Error := GetLastError();
        FLogs.Log('   -> Kill dosn''t work (' + IntToStr(Error) + ' - ' + SysErrorMessage(Error) + ')... killall !', uLogFile.logDebug);
        PrcInfo := FindProcess(ExtractFileName(ExeName));
        if not (PrcInfo.PID = 0) then
        begin
          while not (PrcInfo.PID = 0) do
          begin
            tmpHandle := OpenProcess(PROCESS_ALL_ACCESS, true, PrcInfo.PID);
            if (tmpHandle = 0) then
              FLogs.Log('     -> Unable to open process...', uLogFile.logDebug)
            else
            begin
              try
                if TerminateProcess(tmpHandle, 97) then
                  FLogs.Log('     -> Process killed !', uLogFile.logDebug)
                else
                begin
                  Error := GetLastError();
                  FLogs.Log('     -> Kill dosn''t work (' + IntToStr(Error) + ' - ' + SysErrorMessage(Error) + ')... ', uLogFile.logDebug);
                end;
              finally
                CloseHandle(tmpHandle);
              end;
            end;
            PrcInfo := FindProcess(ExtractFileName(ExeName));
          end;
        end
        else
        begin
          FLogs.Log('   -> no process found, resetting internal variable !', uLogFile.logDebug);
        end;
        // reinit des variables
        Process := nil;
        StartKill := 0;
      end;
    end;
  end;
end;

// Get du paramétrage

function TService_BI_Ginkoia.GetServiceParam(var ListeMag : TListeMag) : boolean;
var
  ConnexionGnk : TMyConnection;
  QueryGnk : TMyQuery;
  IdGenerateur : string;
  IdBase : integer;
  tmpNivLog : uLogFile.TLogLevel;
  tmpBaseTpn : string;
  tmpTempo : integer;
  tmpNextInit, tmpTimeReset, tmpLastReset, tmpNextReset, tmpTimeStop, tmpTimeStart : TDateTime;
  tmpMinVte, tmpMinMvt, tmpMinCmd, tmpMinRap, tmpMinStk : integer;
  tmpTimes : string;
begin
  Result := false;
  IdGenerateur := '';
  IdBase := 0;

  FLogs.Log('  ** GetServiceParam **', uLogFile.logTrace);

  if Assigned(ListeMag) then
    ListeMag.Clear()
  else
    ListeMag := TListeMag.Create(true);

  ConnexionGnk := nil;
  QueryGnk := nil;

  tmpNivLog := uLogFile.logNotice;
  tmpBaseTpn := FBaseTpn;
  tmpTempo := 15;
  tmpNextInit := IncMonth(Trunc(Now()) + EncodeTime(4, 0, 0, 0), 1);
  tmpTimeReset := 0 + EncodeTime(20, 30, 0, 0);
  tmpLastReset := IncDay(Now(), -1);
  tmpNextReset := Trunc(Now()) + tmpTimeReset;
  tmpTimeStop := EncodeTime(21, 30, 0, 0);
  tmpTimeStart := EncodeTime(7, 0, 0, 0);
  tmpMinVte := 3;
  tmpMinMvt := 3;
  tmpMinCmd := 3;
  tmpMinRap := 3;
  tmpMinStk := 1;
  tmpTimes := '';

  if FileExists(FBaseGin) then
  begin
    try
      try
        ConnexionGnk := GetNewConnexion(FBaseGin, CST_GINKOIA_LOGIN, CST_GINKOIA_PASSWORD, false);
        QueryGnk := GetNewQuery(ConnexionGnk);

        ConnexionGnk.Open();

{$REGION '        Recup de l''ID generateur'}
        QueryGnk.SQL.Text := 'select par_string from genparambase where par_nom = ''IDGENERATEUR'';';
        try
          QueryGnk.Open();
          if QueryGnk.Eof then
            raise Exception.Create('IDGENERATEUR non trouver dans genparambase')
          else
            IdGenerateur := QueryGnk.FieldByName('par_string').AsString;
        finally
          QueryGnk.Close();
        end;
        QueryGnk.SQL.Text := 'select bas_id, bas_guid, bas_nompournous from genbases join k on k_id = bas_id and k_enabled = 1 where bas_ident = ' + QuotedStr(IdGenerateur) + ';';
        try
          QueryGnk.Open();
          if QueryGnk.Eof then
            raise Exception.Create('bas_id non trouver pour "' + IdGenerateur + '"')
          else
          begin
            IdBase := QueryGnk.FieldByName('bas_id').AsInteger;
            FBaseNom := QueryGnk.FieldByName('bas_nompournous').AsString;
            FBaseGUID := QueryGnk.FieldByName('bas_guid').AsString;
          end;
        finally
          QueryGnk.Close();
        end;
{$ENDREGION}

{$REGION '        Chemin de la base tampon'}
        QueryGnk.SQL.Text := 'select prm_string, count(*) '
                           + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                           + 'where prm_type = 25 and prm_code = 5 '
                           + '  and prm_magid in (select prm_magid '
                           + '                    from genparam join k on k_id = prm_id and k_enabled = 1 '
                           + '                    where prm_type = 25 and prm_code = 2 and prm_integer = ' + IntToStr(IdBase)+ ') '
                           + 'group by prm_string '
                           + 'order by 2 '
                           + 'rows 1;';
        try
          QueryGnk.Open();
          if not QueryGnk.Eof then
            tmpBaseTpn := QueryGnk.FieldByName('prm_string').AsString
        finally
          QueryGnk.Close();
        end;
{$ENDREGION}

{$REGION '        Date de dernier reset reussit...'}
        QueryGnk.SQL.Text := 'select hev_date '
                           + 'from genhistoevt join k on k_id = hev_id and k_enabled = 1 '
                           + 'where hev_type = ' + CLASTRS + ' and hev_basid = ' + IntToStr(IdBase) + ' and hev_result = 1;';
        try
          QueryGnk.Open();
          if not QueryGnk.Eof then
            tmpLastReset := QueryGnk.FieldByName('hev_date').AsDateTime;
        finally
          QueryGnk.Close();
        end;
{$ENDREGION}

{$REGION '        Paramètre globaux (intervalle pour l''extraction, time de stock, Niveau de log, horraire de stop, durées de rétention !)'}
        QueryGnk.SQL.Text := 'select prm_code, prm_integer, prm_float, prm_string '
                           + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                           + 'where prm_type = 25 and prm_code in (3, 4, 7, 9, 10, 11, 12, 13);';
        try
          QueryGnk.Open();
          if QueryGnk.Eof then
            raise Exception.Create('Pas de paramètre trouver')
          else
          begin
            while not QueryGnk.Eof do
            begin
              case QueryGnk.FieldByName('prm_code').AsInteger of
                03 :
                  begin
                    tmpTempo := QueryGnk.FieldByName('prm_integer').AsInteger;
                    tmpTimeReset := Frac(TDateTime(QueryGnk.FieldByName('prm_float').AsFloat));
                    if Trunc(Now()) + tmpTimeReset > tmpLastReset then
                      tmpNextReset := Trunc(Now()) + tmpTimeReset
                    else
                      tmpNextReset := IncDay(Trunc(Now())) + tmpTimeReset;
                  end;
                04 :
                  begin
                    tmpNivLog := uLogFile.TLogLevel(QueryGnk.FieldByName('prm_integer').AsInteger);
                  end;
                07 :
                  begin
                    tmpTimes := QueryGnk.FieldByName('prm_string').AsString;
                    tmpTimeStop := EncodeTime(StrToInt(Copy(tmpTimes, 1, 2)), StrToInt(Copy(tmpTimes, 4, 2)), 0, 0);
                    tmpTimeStart := EncodeTime(StrToInt(Copy(tmpTimes, 7, 2)), StrToInt(Copy(tmpTimes, 10, 2)), 0, 0);
                  end;
                // Durées
                09 : tmpMinVte := QueryGnk.FieldByName('prm_integer').AsInteger;
                10 : tmpMinMvt := QueryGnk.FieldByName('prm_integer').AsInteger;
                11 : tmpMinCmd := QueryGnk.FieldByName('prm_integer').AsInteger;
                12 : tmpMinRap := QueryGnk.FieldByName('prm_integer').AsInteger;
                13 : tmpMinStk := QueryGnk.FieldByName('prm_integer').AsInteger;
              end;
              QueryGnk.Next()
            end;
          end;
        finally
          QueryGnk.Close();
        end;
{$ENDREGION}

{$REGION '        Recup de la liste des magasins + Activation et date d''init'}
        QueryGnk.SQL.Text := 'select prmmag.prm_magid as magid, prmactif.prm_integer as actif, prmactif.prm_float as init, prmspecif.prm_string as specif '
                           + 'from genparam prmmag join k on k_id = prmmag.prm_id and k_enabled = 1 '
                           + 'join genparam prmactif join k on k_id = prmactif.prm_id and k_enabled = 1 '
                           + '     on prmactif.prm_type = 25 and prmactif.prm_code = 1 and prmmag.prm_magid = prmactif.prm_magid '
                           + 'left join genparam prmspecif join k on k_id = prmspecif.prm_id and k_enabled = 1 '
                           + '     on prmspecif.prm_type = 25 and prmspecif.prm_code = 6 and prmspecif.prm_magid = prmactif.prm_magid '
                           + 'where prmmag.prm_type = 25 and prmmag.prm_code = 2 and prmmag.prm_integer = ' + IntToStr(IdBase) + ';';
        try
          QueryGnk.Open();
          while not QueryGnk.Eof do
          begin
            // prochaine init
            if QueryGnk.FieldByName('init').AsFloat > 1 then
              tmpNextInit := Min(tmpNextInit, QueryGnk.FieldByName('init').AsFloat);
            // construction de la liste des magasins
            if QueryGnk.FieldByName('specif').IsNull then
              ListeMag.Add(Tmagasin.Create(QueryGnk.FieldByName('magid').AsInteger,
                                           (QueryGnk.FieldByName('actif').AsInteger = 1),
                                           TDateTime(QueryGnk.FieldByName('init').AsFloat),
                                           ''))
            else
              ListeMag.Add(Tmagasin.Create(QueryGnk.FieldByName('magid').AsInteger,
                                           (QueryGnk.FieldByName('actif').AsInteger = 1),
                                           TDateTime(QueryGnk.FieldByName('init').AsFloat),
                                           QueryGnk.FieldByName('specif').AsString));
            QueryGnk.Next();
          end;
        finally
          QueryGnk.Close();
        end;
{$ENDREGION}

        // log des paramètres !
        if not (Flogs.logLevel = tmpNivLog) then
          FLogs.Log('    logLevel = ' + GetEnumName(TypeInfo(TLogLevel), Ord(tmpNivLog)), uLogFile.logDebug);
        if not (FBaseTpn = tmpBaseTpn) then
          FLogs.Log('    BaseTpn = ' + tmpBaseTpn, uLogFile.logDebug);
        if not (FTempo = tmpTempo) then
          FLogs.Log('    Tempo = ' + IntToStr(tmpTempo), uLogFile.logDebug);
        if not (FNextInit = tmpNextInit) then
          FLogs.Log('    NextInit = ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', tmpNextInit), uLogFile.logDebug);
        if not (FTimeReset = tmpTimeReset) then
          FLogs.Log('    TimeReset = ' + FormatDateTime('hh:nn:ss', tmpTimeReset), uLogFile.logDebug);
        if not (FLastReset = tmpLastReset) then
          FLogs.Log('    LastReset = ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', tmpLastReset), uLogFile.logDebug);
        if not (FNextReset = tmpNextReset) then
          FLogs.Log('    NextReset = ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', tmpNextReset), uLogFile.logDebug);
        if not (FTimeStop = tmpTimeStop) then
          FLogs.Log('    TimeStop = ' + FormatDateTime('hh:nn:ss', tmpTimeStop), uLogFile.logDebug);
        if not (FTimeStart = tmpTimeStart) then
          FLogs.Log('    TimeStart = ' + FormatDateTime('hh:nn:ss', tmpTimeStart), uLogFile.logDebug);
        if not (FMinVte = tmpMinVte) then
          FLogs.Log('    FMinVte = ' + IntToStr(tmpMinVte), uLogFile.logDebug);
        if not (FMinMvt = tmpMinMvt) then
          FLogs.Log('    FMinMvt = ' + IntToStr(tmpMinMvt), uLogFile.logDebug);
        if not (FMinCmd = tmpMinCmd) then
          FLogs.Log('    FMinCmd = ' + IntToStr(tmpMinCmd), uLogFile.logDebug);
        if not (FMinRap = tmpMinRap) then
          FLogs.Log('    FMinRap = ' + IntToStr(tmpMinRap), uLogFile.logDebug);
        if not (FMinStk = tmpMinStk) then
          FLogs.Log('    FMinStk = ' + IntToStr(tmpMinStk), uLogFile.logDebug);

        // remplisage du paramétrage
        Flogs.logLevel := tmpNivLog;
        FBaseTpn := tmpBaseTpn;
        FTempo := tmpTempo;
        FNextInit := tmpNextInit;
        FTimeReset := tmpTimeReset;
        FLastReset := tmpLastReset;
        FNextReset := tmpNextReset;
        FTimeStop := tmpTimeStop;
        FTimeStart := tmpTimeStart;
        FMinVte := tmpMinVte;
        FMinMvt := tmpMinMvt;
        FMinCmd := tmpMinCmd;
        FMinRap := tmpMinRap;
        FMinStk := tmpMinStk;

        Result := true;
      finally
        FreeAndNil(QueryGnk);
        FreeAndNil(ConnexionGnk);
      end;
    except
      on e : Exception do
      begin
        Result := false;
        FLogs.Log('Exception : ' + e.ClassName + ' - ' + e.Message, uLogFile.logError);
      end;
    end;
  end
  else
    FLogs.Log('Base inexistante', uLogFile.logError);
end;

// gestion des paramètres de magasin !

procedure TService_BI_Ginkoia.DoActivationMag(MagId : integer; Actif : boolean);
var
  ConnexionGnk : TMyConnection;
  TransactionGnk : TMyTransaction;
  QueryGnk : TMyQuery;
  IdGenerateur : string;
  IdPrm : integer;
begin
  IdGenerateur := '';
  IdPrm := 0;

  ConnexionGnk := nil;
  TransactionGnk := nil;
  QueryGnk := nil;

  try
    ConnexionGnk := GetNewConnexion(FBaseGin, CST_GINKOIA_LOGIN, CST_GINKOIA_PASSWORD, false);
    TransactionGnk := GetNewTransaction(ConnexionGnk, false);
    QueryGnk := GetNewQuery(ConnexionGnk, TransactionGnk);

    ConnexionGnk.Open();

    try
      TransactionGnk.StartTransaction();

      // recup de l'ID
      QueryGnk.SQL.Text := 'select prm_id '
                         + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                         + 'where prm_type = 25 and prm_code = 1 and prm_magid = ' + IntToStr(MagId) + ';';
      try
        QueryGnk.Open();
        if QueryGnk.Eof then
          raise exception.Create('Paramètre d''activation non trouvé')
        else
          IdPrm := QueryGnk.FieldByName('prm_id').AsInteger;
      finally
        QueryGnk.Close();
      end;

      // MAJ du paramètre d'activation !
      QueryGnk.SQL.Text := 'update genparam set prm_float = 0, prm_integer = ' + IfThen(Actif, '1', '0') + ' where prm_id = ' + IntToStr(IdPrm) + ';';
      QueryGnk.ExecSQL();
      if QueryGnk.RowsAffected = 0 then
        raise Exception.Create('Paramètre d''activation non mis-à-jour');
      // MAJ du K
      QueryGnk.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(IdPrm) + ', 0);';
      QueryGnk.ExecSQL();

      // recup de l'ID
      QueryGnk.SQL.Text := 'select prm_id '
                         + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                         + 'where prm_type = 25 and prm_code = 6 and prm_magid = ' + IntToStr(MagId) + ';';
      try
        QueryGnk.Open();
        if QueryGnk.Eof then
          raise exception.Create('Paramètre spécifique non trouvé')
        else
          IdPrm := QueryGnk.FieldByName('prm_id').AsInteger;
      finally
        QueryGnk.Close();
      end;

      // MAJ du paramètre de spécifique !
      QueryGnk.SQL.Text := 'update genparam set prm_string = '''' where prm_id = ' + IntToStr(IdPrm) + ';';
      QueryGnk.ExecSQL();
      if QueryGnk.RowsAffected = 0 then
        raise Exception.Create('Paramètre spécifique non mis-à-jour');
      // MAJ du K
      QueryGnk.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(IdPrm) + ', 0);';
      QueryGnk.ExecSQL();

      TransactionGnk.Commit();
    except
      TransactionGnk.Rollback();
      raise;
    end;
  finally
    FreeAndNil(QueryGnk);
    FreeAndNil(TransactionGnk);
    FreeAndNil(ConnexionGnk);
  end;
end;

procedure TService_BI_Ginkoia.ClearSpecifMag(MagId : integer);
var
  ConnexionGnk : TMyConnection;
  TransactionGnk : TMyTransaction;
  QueryGnk : TMyQuery;
  IdGenerateur : string;
  IdPrm : integer;
begin
  IdGenerateur := '';
  IdPrm := 0;

  ConnexionGnk := nil;
  TransactionGnk := nil;
  QueryGnk := nil;

  try
    ConnexionGnk := GetNewConnexion(FBaseGin, CST_GINKOIA_LOGIN, CST_GINKOIA_PASSWORD, false);
    TransactionGnk := GetNewTransaction(ConnexionGnk, false);
    QueryGnk := GetNewQuery(ConnexionGnk, TransactionGnk);

    ConnexionGnk.Open();

    try
      TransactionGnk.StartTransaction();

      // recup de l'ID
      QueryGnk.SQL.Text := 'select prm_id '
                         + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                         + 'where prm_type = 25 and prm_code = 6 and prm_magid = ' + IntToStr(MagId) + ';';
      try
        QueryGnk.Open();
        if QueryGnk.Eof then
          raise exception.Create('Paramètre spécifique non trouvé')
        else
          IdPrm := QueryGnk.FieldByName('prm_id').AsInteger;
      finally
        QueryGnk.Close();
      end;

      // MAJ du paramètre de spécifique !
      QueryGnk.SQL.Text := 'update genparam set prm_string = '''' where prm_id = ' + IntToStr(IdPrm) + ';';
      QueryGnk.ExecSQL();
      if QueryGnk.RowsAffected = 0 then
        raise Exception.Create('Paramètre spécifique non mis-à-jour');
      // MAJ du K
      QueryGnk.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(IdPrm) + ', 0);';
      QueryGnk.ExecSQL();

      // recup de l'ID
      QueryGnk.SQL.Text := 'select prm_id '
                         + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                         + 'where prm_type = 25 and prm_code = 1 and prm_magid = ' + IntToStr(MagId) + ';';
      try
        QueryGnk.Open();
        if QueryGnk.Eof then
          raise exception.Create('Paramètre d''activation non trouvé')
        else
          IdPrm := QueryGnk.FieldByName('prm_id').AsInteger;
      finally
        QueryGnk.Close();
      end;

      // MAJ de la date du paramètre d'activation !
      QueryGnk.SQL.Text := 'update genparam set prm_float = 0 where prm_id = ' + IntToStr(IdPrm) + ';';
      QueryGnk.ExecSQL();
      if QueryGnk.RowsAffected = 0 then
        raise Exception.Create('Paramètre d''activation non mis-à-jour');
      // MAJ du K
      QueryGnk.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(IdPrm) + ', 0);';
      QueryGnk.ExecSQL();

      TransactionGnk.Commit();
    except
      TransactionGnk.Rollback();
      raise;
    end;
  finally
    // fermeture
    ConnexionGnk.Close();
    // liberation
    FreeAndNil(QueryGnk);
    FreeAndNil(TransactionGnk);
    FreeAndNil(ConnexionGnk);
  end;
end;

// gestion du backup/restore

procedure TService_BI_Ginkoia.BackupRestore();
var
  LogName : string;
begin
  FLogs.Log('  ** BackupRestore **', uLogFile.logTrace);
  Log.readIni();
  Log.Open();

  if FileExists(FBaseTpn) then
  begin
    LogName := ExtractFilePath(ParamStr(0)) + '\Logs\' + ChangeFileExt(ExtractFileName(ParamStr(0)), '') + '_Backup_' + FormatDateTime('yyyy-mm-dd', Now()) + '.log';

    // GFIX
    try
      FThreadGFix := TGFixThread.Create(nil, nil, LogName, CST_BASE_SERVEUR, FBaseTpn, CST_BASE_PORT, false, CST_PAGE_BUFFER_MAGASIN, nil, nil);
      while WaitForSingleObject(FThreadGFix.Handle, 100) = WAIT_TIMEOUT do
        Sleep(100);
      case FThreadGFix.ReturnValue of
         0 :
          begin
            FLogs.Log('  -> GFix effectué correctement.', uLogFile.logInfo);
            Log.Log(Log.Host, 'GFix', FBaseNom, FBaseGUID, '', 'GFix', 'OK', uLog.logInfo, true, 0, ltServer);
          end;
        else
          begin
            FLogs.Log('  -> Erreur lors du GFix : ' + FThreadGFix.GetErrorLibelle(FThreadGFix.ReturnValue), uLogFile.logError);
            Log.Log(Log.Host, 'GFix', FBaseNom, FBaseGUID, '', 'GFix', 'Erreur : ' + FThreadGFix.GetErrorLibelle(FThreadGFix.ReturnValue), uLog.logError, true, 0, ltServer);
          end;
      end;
    finally
      FreeAndNil(FThreadGFix);
    end;

    // Backup/Restore
    try
      FThreadBackup := TBaseBackRestThread.Create(nil, nil, LogName, CST_BASE_SERVEUR, FBaseTpn, CST_BASE_PORT, true, CST_PAGE_BUFFER_MAGASIN, ear_No, nil, nil);
      while WaitForSingleObject(FThreadBackup.Handle, 100) = WAIT_TIMEOUT do
        Sleep(100);
      case FThreadBackup.ReturnValue of
         0 :
          begin
            FLogs.Log('  -> Backup effectué correctement.', uLogFile.logInfo);
            Log.Log(Log.Host, 'GFix', FBaseNom, FBaseGUID, '', 'Backup', 'OK', uLog.logInfo, true, 0, ltServer);
          end;
        else
          begin
            FLogs.Log('  -> Erreur lors du backup/restore : ' + FThreadBackup.GetErrorLibelle(FThreadBackup.ReturnValue), uLogFile.logWarning);
            FLogs.Log('     Nouvelle tentative sans verification des nombre d''enreg', uLogFile.logWarning);
            Log.Log(Log.Host, 'GFix', FBaseNom, FBaseGUID, '', 'Backup', 'Erreur : ' + FThreadBackup.GetErrorLibelle(FThreadBackup.ReturnValue), uLog.logWarning, true, 0, ltServer);

            FreeAndNil(FThreadBackup);
            FThreadBackup := TBaseBackRestThread.Create(nil, nil, LogName, CST_BASE_SERVEUR, FBaseTpn, CST_BASE_PORT, true, CST_PAGE_BUFFER_MAGASIN, ear_Yes, nil, nil);
            while WaitForSingleObject(FThreadBackup.Handle, 100) = WAIT_TIMEOUT do
              Sleep(100);
            case FThreadBackup.ReturnValue of
               0 :
                begin
                  FLogs.Log('  -> Backup effectué correctement.', uLogFile.logInfo);
                  Log.Log(Log.Host, 'GFix', FBaseNom, FBaseGUID, '', 'Backup', 'OK', uLog.logInfo, true, 0, ltServer);
                end;
              else
                begin
                  FLogs.Log('  -> Erreur lors du backup/restore : ' + FThreadBackup.GetErrorLibelle(FThreadBackup.ReturnValue), uLogFile.logError);
                  Log.Log(Log.Host, 'GFix', FBaseNom, FBaseGUID, '', 'Backup', 'Erreur : ' + FThreadBackup.GetErrorLibelle(FThreadBackup.ReturnValue), uLog.logError, true, 0, ltServer);
                end;
            end;
          end;
      end;
    finally
      FreeAndNil(FThreadBackup);
    end;
  end;
end;

// fonctionnement

// traitement d'extraction

function TService_BI_Ginkoia.TraitementExpTrt() : boolean;
var
  ExeParam : string;
begin
  Result := false;

  FLogs.Log('  ** TraitementExpTrt **', uLogFile.logInfo);

  try
    if (not (FExpExeName = '')) and FileExists(FExpExeName) then
    begin
      ExeParam := '-LogLevel:' + GetEnumName(TypeInfo(TLogLevel), Ord(FLogs.logLevel)) + ' '
                + '-BaseGin:"' + FBaseGin + '" '
                + '-BaseTpn:"' + FBaseTpn + '" '
                + '-NbYearVte:' + IntToStr(FMinVte) + ' -NbYearMvt:' + IntToStr(FMinMvt) + ' -NbYearCmd:' + IntToStr(FMinCmd) + ' -NbYearRap:' + IntToStr(FMinRap) + ' -NbYearStk:' + IntToStr(FMinStk) + ' '
                + '-Delta';

      FLogs.Log('    Execution de', uLogFile.logDebug);
      FLogs.Log('      ExeFile  : ' + FExpExeName, uLogFile.logDebug);
      FLogs.Log('      ExeParam : ' + ExeParam, uLogFile.logDebug);

      // Activation du timer de temps !
      tmr_ForceStopExp.Interval := LONG_BEFORE_HALT;
      tmr_ForceStopExp.Enabled := true;

      // nouveau lancement du process
      FExpProcess := TCreateProcess.Create();
      FExpProcess.Name := 'Delta';
      FExpProcess.Cmd  := FExpExeName + ' ' + ExeParam;
      FExpProcess.Path := ExtractFilePath(FExpExeName);
      FExpProcess.OnStdOut := TraitementExpOut;
      FExpProcess.OnStdErr := TraitementExpErr;
      FExpProcess.onFinished := TraitementExpEnd;
      FExpProcess.Run();
    end
    else
      FLogs.Log('  -> Executable non trouvé', uLogFile.logWarning);
  except
    on e : Exception do
      FLogs.Log('  -> Exception lors du traitement delta : ' + e.ClassName + ' - ' + e.Message, uLogFile.logError);
  end;
end;

function TService_BI_Ginkoia.TraitementExpMonitor() : boolean;
var
  ExeParam : string;
begin
  Result := false;

  FLogs.Log('  ** TraitementExpMonitor **', uLogFile.logInfo);

  try
    if (not (FExpExeName = '')) and FileExists(FExpExeName) then
    begin
      ExeParam := '-LogLevel:' + GetEnumName(TypeInfo(TLogLevel), Ord(FLogs.logLevel)) + ' '
                + '-BaseGin:"' + FBaseGin + '" '
                + '-BaseTpn:"' + FBaseTpn + '" '
                + '-NbYearVte:' + IntToStr(FMinVte) + ' -NbYearMvt:' + IntToStr(FMinMvt) + ' -NbYearCmd:' + IntToStr(FMinCmd) + ' -NbYearRap:' + IntToStr(FMinRap) + ' -NbYearStk:' + IntToStr(FMinStk) + ' '
                + '-LogForce '
                + '-LogInterval:' + IntToStr(SecondsBetween(Now(), IncDay(Trunc(Now())) + FTimeStart));

      FLogs.Log('    Execution de', uLogFile.logDebug);
      FLogs.Log('      ExeFile  : ' + FExpExeName, uLogFile.logDebug);
      FLogs.Log('      ExeParam : ' + ExeParam, uLogFile.logDebug);

      // Activation du timer de temps !
      tmr_ForceStopExp.Interval := LONG_BEFORE_HALT;
      tmr_ForceStopExp.Enabled := true;

      // nouveau lancement du process
      FExpProcess := TCreateProcess.Create();
      FExpProcess.Name := 'Monitor';
      FExpProcess.Cmd  := FExpExeName + ' ' + ExeParam;
      FExpProcess.Path := ExtractFilePath(FExpExeName);
      FExpProcess.OnStdOut := TraitementExpOut;
      FExpProcess.OnStdErr := TraitementExpErr;
      FExpProcess.onFinished := TraitementExpEnd;
      FExpProcess.Run();
    end
    else
      FLogs.Log('  -> Executable non trouvé', uLogFile.logWarning);
  except
    on e : Exception do
      FLogs.Log('  -> Exception lors du traitement monitor : ' + e.ClassName + ' - ' + e.Message, uLogFile.logError);
  end;
end;

function TService_BI_Ginkoia.TraitementInit(ListeMag : TListeMag) : boolean;
var
  ExeParam : string;
  Resultat : Cardinal;
  Magasin : TMagasin;
  CreateBase : boolean;
begin
  Result := false;

  FLogs.Log('  ** TraitementInit **', uLogFile.logInfo);

  try
    try
      FDoInit := true;

      if (not (FExpExeName = '')) and FileExists(FExpExeName) then
      begin
        // forcage de la creation de base ?
        CreateBase := false;
        for Magasin in ListeMag do
          if Magasin.HasInit() and (Pos('-CreateBase', Magasin.Specif) > 0) then
            CreateBase := true;

        if not FileExists(FBaseTpn) or CreateBase then
        begin
          //=======================================================================
          // Creation de la base (que si l'ont reprend tout !)
          ExeParam := '-LogLevel:' + GetEnumName(TypeInfo(TLogLevel), Ord(FLogs.logLevel)) + ' '
                    + '-BaseGin:"' + FBaseGin + '" '
                    + '-BaseTpn:"' + FBaseTpn + '" '
                    + '-CreateBase';

          FLogs.Log('    Execution de', uLogFile.logDebug);
          FLogs.Log('      ExeFile  : ' + FExpExeName, uLogFile.logDebug);
          FLogs.Log('      ExeParam : ' + ExeParam, uLogFile.logDebug);

          // nouveau lancement du process
          FExpProcess := TCreateProcess.Create();
          FExpProcess.Name := 'Création de base';
          FExpProcess.Cmd  := FExpExeName + ' ' + ExeParam;
          FExpProcess.Path := ExtractFilePath(FExpExeName);
          FExpProcess.OnStdOut := TraitementExpOut;
          FExpProcess.OnStdErr := TraitementExpErr;
          Resultat := FExpProcess.RunAndWait();
          FExpProcess := nil;

          // retour du process !
          case Resultat of
            0              : FLogs.Log('  -> Traitement d''initialisation reussit', uLogFile.logInfo);
            97             : FLogs.Log('  -> Le traitement a été tué !', uLogFile.logWarning);
            98             : FLogs.Log('  -> Backup/Restore en cours !', uLogFile.logWarning);
            99             : FLogs.Log('  -> Erreur traitement (d''initialisation ou non) déjà lancé !', uLogFile.logWarning);
            High(cardinal) : FLogs.Log('  -> Erreur de lancement du traitement d''initialisation', uLogFile.logError);
            else             FLogs.Log('  -> Erreur dans le traitement d''initialisation : ' + IntToStr(Resultat), uLogFile.logError);
          end;
        end
        else
          Resultat := 0;

        // si ratage alors on sort
        if Resultat = 0 then
        begin
          // activation des magasins !
          for Magasin in ListeMag do
            if Magasin.HasInit() then
              DoActivationMag(Magasin.ID, true);

          //=======================================================================
          // premiére execution
          ExeParam := '-LogLevel:' + GetEnumName(TypeInfo(TLogLevel), Ord(FLogs.logLevel)) + ' '
                    + '-BaseGin:"' + FBaseGin + '" '
                    + '-BaseTpn:"' + FBaseTpn + '" '
                    + '-NbYearVte:' + IntToStr(FMinVte) + ' -NbYearMvt:' + IntToStr(FMinMvt) + ' -NbYearCmd:' + IntToStr(FMinCmd) + ' -NbYearRap:' + IntToStr(FMinRap) + ' -NbYearStk:' + IntToStr(FMinStk) + ' '
                    + '-Init';

          if ListeMag.HasInit() = ect_Some then
            ExeParam := ExeParam + ' -Magasins:' + ListeMag.GetInitMagID();

          FLogs.Log('    Execution de', uLogFile.logDebug);
          FLogs.Log('      ExeFile  : ' + FExpExeName, uLogFile.logDebug);
          FLogs.Log('      ExeParam : ' + ExeParam, uLogFile.logDebug);


          // nouveau lancement du process
          FExpProcess := TCreateProcess.Create();
          FExpProcess.Name := 'Initialisation';
          FExpProcess.Cmd  := FExpExeName + ' ' + ExeParam;
          FExpProcess.Path := ExtractFilePath(FExpExeName);
          FExpProcess.OnStdOut := TraitementExpOut;
          FExpProcess.OnStdErr := TraitementExpErr;
          Resultat := FExpProcess.RunAndWait();
          FExpProcess := nil;

          // retour du process !
          if Resultat = 0 then
             FLogs.Log('  -> Traitement d''initialisation reussit', uLogFile.logInfo)
          else
          begin
            case Resultat of
              97             : FLogs.Log('  -> Le traitement a été tué !', uLogFile.logWarning);
              98             : FLogs.Log('  -> Backup/Restore en cours !', uLogFile.logWarning);
              99             : FLogs.Log('  -> Erreur traitement (d''initialisation ou non) déjà lancé !', uLogFile.logWarning);
              High(cardinal) : FLogs.Log('  -> Erreur de lancement du traitement d''initialisation', uLogFile.logError);
              else             FLogs.Log('  -> Erreur dans le traitement d''initialisation : ' + IntToStr(Resultat), uLogFile.logError);
            end;
            // si ratage alors on desactive !
            for Magasin in ListeMag do
              if Magasin.HasInit() then
                DoActivationMag(Magasin.ID, false);
          end;
        end;
      end
      else
        FLogs.Log('  -> Executable non trouvé', uLogFile.logDebug);
    finally
      FDoInit := false;
    end;
  except
    on e : Exception do
      FLogs.Log('  -> Exception lors du traitement d''initialisation : ' + e.ClassName + ' - ' + e.Message, uLogFile.logError);
  end;
end;

function TService_BI_Ginkoia.TraitementSpecif(ListeMag : TListeMag) : boolean;
var
  ExeParam : string;
  Magasin : TMagasin;
  Resultat : Cardinal;
begin
  Result := false;

  FLogs.Log('  ** TraitementSpecif **', uLogFile.logInfo);

  try
    if (not (FExpExeName = '')) and FileExists(FExpExeName) then
    begin
      for Magasin in ListeMag do
      begin
        if not (Trim(Magasin.Specif) = '') then
        begin
          ExeParam := '-LogLevel:' + GetEnumName(TypeInfo(TLogLevel), Ord(FLogs.logLevel)) + ' '
                    + '-BaseGin:"' + FBaseGin + '" '
                    + '-BaseTpn:"' + FBaseTpn + '" '
                    + '-NbYearVte:' + IntToStr(FMinVte) + ' -NbYearMvt:' + IntToStr(FMinMvt) + ' -NbYearCmd:' + IntToStr(FMinCmd) + ' -NbYearRap:' + IntToStr(FMinRap) + ' -NbYearStk:' + IntToStr(FMinStk) + ' '
                    + '-Magasins:' + IntToStr(Magasin.ID) + ' '
                    + Magasin.Specif;

          FLogs.Log('    Execution de', uLogFile.logDebug);
          FLogs.Log('      ExeFile  : ' + FExpExeName, uLogFile.logDebug);
          FLogs.Log('      ExeParam : ' + ExeParam, uLogFile.logDebug);

          try
            // Activation du timer de temps !
            tmr_ForceStopExp.Interval := LONG_BEFORE_HALT;
            tmr_ForceStopExp.Enabled := true;

            // nouveau lancement du process
            FExpProcess := TCreateProcess.Create();
            FExpProcess.Name := 'Spécifique';
            FExpProcess.Cmd  := FExpExeName + ' ' + ExeParam;
            FExpProcess.Path := ExtractFilePath(FExpExeName);
            FExpProcess.OnStdOut := TraitementExpOut;
            FExpProcess.OnStdErr := TraitementExpErr;
            Resultat := FExpProcess.RunAndWait();
            FExpProcess := nil;

            // retour du process !
            if Resultat = 0 then
            begin
              FLogs.Log('  -> Traitement spécifique reussit', uLogFile.logInfo);
              ClearSpecifMag(Magasin.ID);
            end
            else
            begin
              case Resultat of
                97             : FLogs.Log('  -> Le traitement a été tué !', uLogFile.logWarning);
                98             : FLogs.Log('  -> Backup/Restore en cours !', uLogFile.logWarning);
                99             : FLogs.Log('  -> Erreur traitement (spécifique ou non) déjà lancé !', uLogFile.logWarning);
                High(cardinal) : FLogs.Log('  -> Erreur de lancement du traitement spécifique', uLogFile.logError);
                else             FLogs.Log('  -> Erreur dans le traitement spécifique : ' + IntToStr(Resultat), uLogFile.logError);
              end;
            end;
          finally
            tmr_ForceStopExp.Enabled := false;
          end;
        end;
      end;
    end
    else
      FLogs.Log('  -> Executable non trouvé', uLogFile.logWarning);
  except
    on e : Exception do
      FLogs.Log('  -> Exception lors du traitement spécifique : ' + e.ClassName + ' - ' + e.Message, uLogFile.logError);
  end;
end;

function TService_BI_Ginkoia.TraitementReset() : boolean;
var
  ExeParam : string;
begin
  Result := false;

  FLogs.Log('  ** TraitementReset **', uLogFile.logInfo);

  try
    try
      FDoReset := true;

      if (not (FExpExeName = '')) and FileExists(FExpExeName) then
      begin
        ExeParam := '-LogLevel:' + GetEnumName(TypeInfo(TLogLevel), Ord(FLogs.logLevel)) + ' '
                  + '-BaseGin:"' + FBaseGin + '" '
                  + '-BaseTpn:"' + FBaseTpn + '" '
                  + '-NbYearVte:' + IntToStr(FMinVte) + ' -NbYearMvt:' + IntToStr(FMinMvt) + ' -NbYearCmd:' + IntToStr(FMinCmd) + ' -NbYearRap:' + IntToStr(FMinRap) + ' -NbYearStk:' + IntToStr(FMinStk) + ' '
                  + '-ResetStock '
                  + '-LogInterval:' + IntToStr(SecondsBetween(Now(), IncMinute(IncDay(Trunc(Now())) + FTimeReset, 15) )); // Tous les jours (+15 minutes de battement)

        FLogs.Log('    Execution de', uLogFile.logDebug);
        FLogs.Log('      ExeFile  : ' + FExpExeName, uLogFile.logDebug);
        FLogs.Log('      ExeParam : ' + ExeParam, uLogFile.logDebug);

        // Activation du timer de temps !
        tmr_ForceStopExp.Interval := LONG_BEFORE_HALT;
        tmr_ForceStopExp.Enabled := true;

        // nouveau lancement du process
        FExpProcess := TCreateProcess.Create();
        FExpProcess.Name := 'Reset';
        FExpProcess.Cmd  := FExpExeName + ' ' + ExeParam;
        FExpProcess.Path := ExtractFilePath(FExpExeName);
        FExpProcess.OnStdOut := TraitementExpOut;
        FExpProcess.OnStdErr := TraitementExpErr;
        FExpProcess.onFinished := TraitementExpEnd;
        FExpProcess.Run();
      end
      else
        FLogs.Log('  -> Executable non trouvé', uLogFile.logWarning);
    finally
      FDoReset := false;
    end;
  except
    on e : Exception do
      FLogs.Log('  -> Exception lors du traitement de stock : ' + e.ClassName + ' - ' + e.Message, uLogFile.logError);
  end;
end;

function TService_BI_Ginkoia.TraitementPurge() : boolean;
var
  ExeParam : string;
begin
  Result := false;

  FLogs.Log('  ** TraitementPurge **', uLogFile.logInfo);

  try
    if (not (FExpExeName = '')) and FileExists(FExpExeName) then
    begin
      ExeParam := '-LogLevel:' + GetEnumName(TypeInfo(TLogLevel), Ord(FLogs.logLevel)) + ' '
                + '-BaseGin:"' + FBaseGin + '" '
                + '-BaseTpn:"' + FBaseTpn + '" '
                + '-NbYearVte:' + IntToStr(FMinVte) + ' -NbYearMvt:' + IntToStr(FMinMvt) + ' -NbYearCmd:' + IntToStr(FMinCmd) + ' -NbYearRap:' + IntToStr(FMinRap) + ' -NbYearStk:' + IntToStr(FMinStk) + ' '
                + '-Purges '
                + '-LogInterval:' + IntToStr(SecondsBetween(Now(), IncMonth(IncDay(Trunc(Now()))) + FTimeStop)); // tous les mois (+1 jours de battement)

      FLogs.Log('    Execution de', uLogFile.logDebug);
      FLogs.Log('      ExeFile  : ' + FExpExeName, uLogFile.logDebug);
      FLogs.Log('      ExeParam : ' + ExeParam, uLogFile.logDebug);

      // Activation du timer de temps !
      tmr_ForceStopExp.Interval := LONG_BEFORE_HALT;
      tmr_ForceStopExp.Enabled := true;

      // nouveau lancement du process
      FExpProcess := TCreateProcess.Create();
      FExpProcess.Name := 'Purge';
      FExpProcess.Cmd  := FExpExeName + ' ' + ExeParam;
      FExpProcess.Path := ExtractFilePath(FExpExeName);
      FExpProcess.OnStdOut := TraitementExpOut;
      FExpProcess.OnStdErr := TraitementExpErr;
      FExpProcess.onFinished := TraitementExpEnd;
      FExpProcess.Run();
    end
    else
      FLogs.Log('  -> Executable non trouvé', uLogFile.logWarning);
  except
    on e : Exception do
      FLogs.Log('  -> Exception lors de la purge : ' + e.ClassName + ' - ' + e.Message, uLogFile.logError);
  end;
end;

procedure TService_BI_Ginkoia.TraitementExpOut(Sender: TObject);
var
  Msg : string;
begin
  Msg := FExpProcess.StdOut.readLine();
  while not (Trim(Msg) = '') do
  begin
    FLogs.Log('   <=>   FExpProcess.StdOut : ' + Msg, uLogFile.logInfo);
    Msg := FExpProcess.StdOut.readLine();
  end;
end;

procedure TService_BI_Ginkoia.TraitementExpErr(Sender: TObject);
var
  Msg, Info, Text : string;
begin
  Msg := FExpProcess.StdErr.readLine();
  while not (Trim(Msg) = '') do
  begin
    FLogs.Log('   <=>   FExpProcess.StdErr : ' + Msg, uLogFile.logInfo);
    // decoupage du message
    if Pos(' ', Msg) > 0 then
    begin
      Info := Trim(Copy(Msg, 1, Pos(' ', Msg) -1));
      Text := Trim(Copy(Msg, Pos(' ', Msg) +1, Length(msg)));
    end
    else
    begin
      Info := Trim(Msg);
      Text := '';
    end;
    // les chose a faire
    if Info = 'CANTSTOP' then
    begin
      FLogs.Log('          -> en fait on ne peut pas tué ce traitement...', uLogFile.logInfo);
      FExpStartKill := 0;
    end;
    // message suivant !
    Msg := FExpProcess.StdErr.readLine();
  end;
end;

procedure TService_BI_Ginkoia.TraitementExpEnd(Sender: TObject);
begin
  // retour du process !
  case FExpProcess.ReturnCode of
    0              : FLogs.Log('  -> Traitement ' + FExpProcess.Name + ' reussit', uLogFile.logInfo);
    97             : FLogs.Log('  -> Le traitement a été tué !', uLogFile.logWarning);
    98             : FLogs.Log('  -> Backup/Restore en cours !', uLogFile.logWarning);
    99             : FLogs.Log('  -> Traitement (delta ou non) déjà lancé !', uLogFile.logWarning);
    High(cardinal) : FLogs.Log('  -> Erreur de lancement du traitement ' + FExpProcess.Name, uLogFile.logError);
    else             FLogs.Log('  -> Erreur dans le traitement ' + FExpProcess.Name + ' : ' + IntToStr(FExpProcess.ReturnCode), uLogFile.logError);
  end;
  // liberation du process !
  FExpProcess := nil;
  // desactivation de la surveillance
  tmr_ForceStopExp.Enabled := false;
  FExpStartKill := 0;
end;

// traitement d'import

function TService_BI_Ginkoia.TraitementImpTrt() : boolean;
var
  ExeParam : string;
begin
  Result := false;

  FLogs.Log('  ** TraitementImpTrt **', uLogFile.logInfo);

  try
    if (not (FImpExeName = '')) and FileExists(FImpExeName) then
    begin
      ExeParam := '-LogLevel:' + GetEnumName(TypeInfo(TLogLevel), Ord(FLogs.logLevel)) + ' '
                + '-BaseGin:"' + FBaseGin + '" '
                + '-BaseTpn:"' + FBaseTpn + '" '
                + '-ImpRapp';

      FLogs.Log('    Execution de', uLogFile.logDebug);
      FLogs.Log('      ExeFile  : ' + FImpExeName, uLogFile.logDebug);
      FLogs.Log('      ExeParam : ' + ExeParam, uLogFile.logDebug);

      // Activation du timer de temps !
      tmr_ForceStopImp.Interval := LONG_BEFORE_HALT;
      tmr_ForceStopImp.Enabled := true;

      // nouveau lancement du process
      FImpProcess := TCreateProcess.Create();
      FImpProcess.Name := 'Import';
      FImpProcess.Cmd  := FImpExeName + ' ' + ExeParam;
      FImpProcess.Path := ExtractFilePath(FImpExeName);
      FImpProcess.OnStdOut := TraitementImpOut;
      FImpProcess.OnStdErr := TraitementImpErr;
      FImpProcess.onFinished := TraitementImpEnd;
      FImpProcess.Run();
    end
    else
      FLogs.Log('  -> Executable non trouvé', uLogFile.logWarning);
  except
    on e : Exception do
      FLogs.Log('  -> Exception lors du traitement d''import : ' + e.ClassName + ' - ' + e.Message, uLogFile.logError);
  end;

end;

function TService_BI_Ginkoia.TraitementImpMonitor() : boolean;
var
  ExeParam : string;
begin
  Result := false;

  FLogs.Log('  ** TraitementImpMonitor **', uLogFile.logInfo);

  try
    if (not (FImpExeName = '')) and FileExists(FImpExeName) then
    begin
      ExeParam := '-LogLevel:' + GetEnumName(TypeInfo(TLogLevel), Ord(FLogs.logLevel)) + ' '
                + '-BaseGin:"' + FBaseGin + '" '
                + '-BaseTpn:"' + FBaseTpn + '" '
                + '-LogForce '
                + '-LogInterval:' + IntToStr(SecondsBetween(Now(), IncDay(Trunc(Now())) + FTimeStart));

      FLogs.Log('    Execution de', uLogFile.logDebug);
      FLogs.Log('      ExeFile  : ' + FImpExeName, uLogFile.logDebug);
      FLogs.Log('      ExeParam : ' + ExeParam, uLogFile.logDebug);

      // Activation du timer de temps !
      tmr_ForceStopImp.Interval := LONG_BEFORE_HALT;
      tmr_ForceStopImp.Enabled := true;

      // nouveau lancement du process
      FImpProcess := TCreateProcess.Create();
      FImpProcess.Name := 'Monitor';
      FImpProcess.Cmd  := FImpExeName + ' ' + ExeParam;
      FImpProcess.Path := ExtractFilePath(FImpExeName);
      FImpProcess.OnStdOut := TraitementImpOut;
      FImpProcess.OnStdErr := TraitementImpErr;
      FImpProcess.onFinished := TraitementImpEnd;
      FImpProcess.Run();
    end
    else
      FLogs.Log('  -> Executable non trouvé', uLogFile.logWarning);
  except
    on e : Exception do
      FLogs.Log('  -> Exception lors du traitement monitor : ' + e.ClassName + ' - ' + e.Message, uLogFile.logError);
  end;
end;

procedure TService_BI_Ginkoia.TraitementImpOut(Sender: TObject);
var
  Msg : string;
begin
  Msg := FImpProcess.StdOut.readLine();
  while not (Trim(Msg) = '') do
  begin
    FLogs.Log('   <=>   FImpProcess.StdOut : ' + Msg, uLogFile.logInfo);
    Msg := FImpProcess.StdOut.readLine();
  end;
end;

procedure TService_BI_Ginkoia.TraitementImpErr(Sender: TObject);
var
  Msg : string;
begin
  Msg := FImpProcess.StdErr.readLine();
  while not (Trim(Msg) = '') do
  begin
    FLogs.Log('   <=>   FImpProcess.StdErr : ' + Msg, uLogFile.logInfo);
    Msg := FImpProcess.StdErr.readLine();
  end;
end;

procedure TService_BI_Ginkoia.TraitementImpEnd(Sender: TObject);
begin
  // retour du process !
  case FImpProcess.ReturnCode of
    0              : FLogs.Log('  -> Traitement ' + FImpProcess.Name + ' reussit', uLogFile.logInfo);
    97             : FLogs.Log('  -> Le traitement a été tué !', uLogFile.logWarning);
    98             : FLogs.Log('  -> Backup/Restore en cours !', uLogFile.logWarning);
    99             : FLogs.Log('  -> Traitement déjà lancé !', uLogFile.logWarning);
    High(cardinal) : FLogs.Log('  -> Erreur de lancement du traitement ' + FImpProcess.Name, uLogFile.logError);
    else             FLogs.Log('  -> Erreur dans le traitement ' + FImpProcess.Name + ' : ' + IntToStr(FImpProcess.ReturnCode), uLogFile.logError);
  end;
  // liberation du process !
  FImpProcess := nil;
  // desactivation de la surveillance
  tmr_ForceStopImp.Enabled := false;
  FImpStartKill := 0;
end;

// Modification de l'ACL pour autorizé la gestion du service

procedure TService_BI_Ginkoia.updateServiceACL;
var
  vSDDL : string;
begin
  vSDDL := 'D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)(A;;RPWPDT;;;AU)' ;
  ShellExecute(0, 'Open' ,'sc.exe', PWideChar('sdset ' + Name + ' ' + vSDDL), nil, SW_HIDE) ;
end;

// controlleur

function TService_BI_Ginkoia.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

end.

