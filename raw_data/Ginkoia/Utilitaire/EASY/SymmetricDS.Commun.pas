/// <summary>
/// Unité Commune à SymmetricDS
/// </summary>
unit SymmetricDS.Commun;

interface

uses
  System.SysUtils,
  System.Classes,
  System.RegularExpressionsCore,
  Winapi.ShellAPI,
  Winapi.Windows,
  Winapi.WinSvc,
  {$IF DECLARED(FireMonkeyVersion)}
  FMX.Forms,
  {$ELSE}
  VCL.Forms,
  {$ENDIF}
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdHTTP,registry;

type
  EServiceError     = class(Exception);
  EServiceCreer     = class(EServiceError);
  EServiceDemarrage = class(EServiceError);
  EServiceArret     = class(EServiceError);
  EServiceSupprimer = class(EServiceError);
  EServiceDetecter  = class(EServiceError);
  EServiceInfos     = class(EServiceError);

  // Information sur un exécutable
  TInfoSurExe = record
    FileDescription   : String;
    CompanyName       : String;
    FileVersion       : String;
    InternalName      : String;
    LegalCopyright    : String;
    OriginalFileName  : String;
    ProductName       : String;
    ProductVersion    : String;
  end;

  // Information sur un service
  TInfoSurService = record
    Exist            : boolean;
    ErrorMessage     : string;
    ServiceType      : (sNone,FileSystemDriver, KernelDriver, Win32OwnProcess, Win32ShareProcess);
    StartType        : (tNone,AutoStart, BootStart, DemandStart, Disabled, SystemStart);
    ErrorControl     : (eNone,ErrorCritical, ErrorIgnore, ErrorNormal, ErrorSevere);
    BinaryPathName   : String;
    LoadOrderGroup   : String;
    TagId            : Integer;
    Dependencies     : String;
    ServiceStartName : String;
    DisplayName      : String;
  private
    procedure Init;
  end;

// Récupère des informations sur un exécutable
function InfoSurExe(const AFichier: TFileName): TInfoSurExe;
// Récupère l'adresse IP extérieure
function RecupererIP(): string;
// Met un fichier à la corbeille
function MettreCorbeille(const ANomFichier: TFileName): Boolean;
// Déplace un fichier
function DeplaceFichier(const ASource, ADestination: TFileName): Boolean;
// Copie un fichier
function CopierFichier(const ASource, ADestination: TFileName): Boolean;
// Exécuter et attendre la fin
function Executer(const AFichier: TFileName; const AParametres: string = '';
  const ARepertoire: string = ''; const ACache: Boolean = False): Boolean;
// Exécuter en tant qu'administrateur et attendre la fin
function ExecuterAdministrateur(const AFichier: TFileName;
  const AParametres: string = ''; const ARepertoire: string = '';
  const ACache: Boolean = False): Boolean;
// Créer un service
function CreerService(const ANomService: String = 'SymmetricDS';
  const ACheminExe: String = 'java -jar "C:\SymmetricDS-Pro\lib\symmetric-wrapper.jar" init "C:\SymmetricDS-Pro\conf\sym_service.conf"'): Boolean;
// Démarrer un service
function DemarrerService(const ANomService: String = 'SymmetricDS'): Boolean;
// Arrête un service
function ArreterService(const ANomService: String = 'SymmetricDS'): Boolean;
// Supprime un service
function SupprimerService(const ANomService: String = 'SymmetricDS';
  const ACheminExe: String = 'java -jar "C:\SymmetricDS-Pro\lib\symmetric-wrapper.jar" init "C:\SymmetricDS-Pro\conf\sym_service.conf"'): Boolean;
// Vérifie si un service existe
function ServiceExiste(const ANomService: String = 'SymmetricDS'): Boolean;
// Récupère des informations sur un service
function InfoSurService(const AService: String = 'SymmetricDS'): TInfoSurService;
procedure WriteBase0(avalue:string);
function Readbase0:string;
procedure DeleteBase0();
function CleanLauncherAuto():Boolean;

implementation


procedure TInfoSurService.Init;
begin
    Exist             :=false;
    ErrorMessage      :='';
    ServiceType       :=sNone;
    StartType         :=tNone;
    ErrorControl      :=eNone;
    BinaryPathName    :='';
    LoadOrderGroup    :='';
    TagId             :=0;
    Dependencies      :='';
    ServiceStartName  :='';
    DisplayName       :='';
end;


function CleanLauncherAuto():Boolean;
var reg  : TRegistry;
    vLancher : string;
begin
   // On essaye d'ecrire la valeur
   try
      reg := TRegistry.Create(KEY_WRITE);
      try
        reg.RootKey := HKEY_LOCAL_MACHINE;
        reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False);
        reg.DeleteValue('Launch_Replication');
        reg.DeleteValue('GinkoRep');
      finally
        reg.CloseKey;
        reg.free;
      end;
    except on E: Exception do
      begin
        // result:=false;
      end;
   end;
end;



procedure DeleteBase0();
Const C_KEY='Software\Algol\Ginkoia\';
var  RegistryEntry: TRegistry;
begin
  RegistryEntry := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    RegistryEntry.RootKey := HKEY_LOCAL_MACHINE;
    RegistryEntry.Access := KEY_WRITE;
    if not(RegistryEntry.KeyExists(C_KEY)) then
      begin
         RegistryEntry.CreateKey(C_KEY)
      end;
    if RegistryEntry.OpenKey(C_KEY, false) then
      begin
        RegistryEntry.DeleteValue('Base0');
      end;
    RegistryEntry.CloseKey();
  finally
    RegistryEntry.Free;
  end;
end;


procedure WriteBase0(avalue:string);
Const C_KEY='Software\Algol\Ginkoia\';
var  RegistryEntry: TRegistry;
begin
  RegistryEntry := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    RegistryEntry.RootKey := HKEY_LOCAL_MACHINE;
    RegistryEntry.Access := KEY_WRITE;
    if not(RegistryEntry.KeyExists(C_KEY)) then
      begin
         RegistryEntry.CreateKey(C_KEY);
      end;
    if RegistryEntry.OpenKey(C_KEY, false) then
      begin
        RegistryEntry.WriteString('Base0',avalue);
      end;
    RegistryEntry.CloseKey();
  finally
    RegistryEntry.Free;
  end;
end;

function Readbase0:string;
Const C_KEY='Software\Algol\Ginkoia\';
var
  RegistryEntry: TRegistry;
begin
  result:='';
  RegistryEntry := TRegistry.Create(KEY_READ or KEY_WOW64_64KEY);
  try
    RegistryEntry.RootKey := HKEY_LOCAL_MACHINE;
    RegistryEntry.Access := KEY_READ {or KEY_WOW64_64KEY};
    if RegistryEntry.OpenKey(C_KEY, false) then
      begin
        result := RegistryEntry.ReadString('Base0');
      end;
    RegistryEntry.CloseKey();
  finally
    RegistryEntry.Free;
  end;
end;


// Récupère des informations sur un exécutable
function InfoSurExe(const AFichier: TFileName): TInfoSurExe;
const
  VersionInfo: array [1..8] of String =
    ('FileDescription', 'CompanyName', 'FileVersion',
    'InternalName', 'LegalCopyRight', 'OriginalFileName',
    'ProductName', 'ProductVersion');
var
  Handle:   DWord;
  Info:     Pointer;
  InfoData: Pointer;
  InfoSize: Longint;
  DataLen:  UInt;
  LangPtr:  Pointer;
  InfoType: String;
  i:        Integer;
begin
  // Récupère la taille nécessaire pour les infos
  InfoSize := GetFileVersionInfoSize(Pchar(AFichier), Handle);

  // Initialise la variable de retour
  with Result do
  begin
    FileDescription  := '';
    CompanyName      := '';
    FileVersion      := '';
    InternalName     := '';
    LegalCopyright   := '';
    OriginalFileName := '';
    ProductName      := '';
    ProductVersion   := '';
  end;
  i := 1;

  // Si il y a des informations de version
  if InfoSize > 0 then
  begin
    // Réserve la mémoire
    GetMem(Info, InfoSize);

    try
      // Si les infos peuvent être récupérées
      if GetFileVersionInfo(Pchar(AFichier), Handle, InfoSize, Info) then
        repeat
          // Spécifie le type d'information à récupérer
          InfoType := VersionInfo[i];

          if VerQueryValue(Info, '\VarFileInfo\Translation',
            LangPtr, DataLen) then
            InfoType := Format('\StringFileInfo\%0.4x%0.4x\%s'#0,
              [LoWord(Longint(LangPtr^)), HiWord(Longint(LangPtr^)),
              InfoType]);

            // Remplit la variable de retour
          if VerQueryValue(Info, @InfoType[1], InfoData, DataLen) then
            case i of
              1: Result.FileDescription  := PChar(InfoData);
              2: Result.CompanyName      := PChar(InfoData);
              3: Result.FileVersion      := PChar(InfoData);
              4: Result.InternalName     := PChar(InfoData);
              5: Result.LegalCopyright   := PChar(InfoData);
              6: Result.OriginalFileName := PChar(InfoData);
              7: Result.ProductName      := PChar(InfoData);
              8: Result.ProductVersion   := PChar(InfoData);
            end;

          // Incrémente i
          Inc(i);
        until i >= 8;
    finally
      // Libère la mémoire
      FreeMem(Info, InfoSize);
    end;
  end;
end;

// Récupère l'adresse IP extérieure
function RecupererIP(): string;
const
  REGEX_IP      = '<ip_address>(.+)</ip_address>';
  URL_MYIP      = 'http://www.domaintools.com/research/my-ip/myip.xml';
var
  IdHTTP        : TIdHTTP;
  StringStream  : TStringStream;
  reExpression  : TPerlRegEx;
begin
  // Ouvre la connexion
  try
    StringStream  := TStringStream.Create();
    reExpression  := TPerlRegEx.Create();
    IdHTTP        := TIdHTTP.Create();
    try
      IdHTTP.Request.UserAgent  := 'Mozilla/3.0 (compatible)';
      IdHTTP.Get(URL_MYIP, StringStream);
      reExpression.RegEx        := REGEX_IP;
      reExpression.Options      := [preCaseLess];
      reExpression.Subject      := StringStream.DataString;

      if reExpression.Match() then
        Result := reExpression.Groups[1]
      else
        Result := '127.0.0.1';
    finally
      IdHTTP.Free();
      reExpression.Free();
      StringStream.Free();
    end;
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

// Met un fichier à la corbeille
function MettreCorbeille(const ANomFichier: TFileName): Boolean;
var
  fos: TSHFileOpStruct;
begin
  FillChar(fos, SizeOf(fos), 0);
  with fos do
  begin
    wFunc   := FO_DELETE;
    pFrom   := PChar(ANomFichier + #0);
    fFlags  := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_SILENT;
  end;
  Result := (0 = ShFileOperation(fos));
end;

// Déplace un fichier
function DeplaceFichier(const ASource, ADestination: TFileName): Boolean;
var
  fos: TSHFileOpStruct;
begin
  FillChar(fos, SizeOf(fos), 0);
  with fos do
  begin
    wFunc   := FO_MOVE;
    pFrom   := Pchar(ASource + #0);
    pTo     := Pchar(ADestination + #0);
    fFlags  := FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR or FOF_NOCOPYSECURITYATTRIBS;
  end;
  Result := (0 = ShFileOperation(fos));
end;

// Copie un fichier
function CopierFichier(const ASource, ADestination: TFileName): Boolean;
var
  fos: TSHFileOpStruct;
begin
  FillChar(fos, SizeOf(fos), 0);
  with fos do
  begin
    wFunc   := FO_COPY;
    pFrom   := Pchar(ASource + #0);
    pTo     := Pchar(ADestination + #0);
    fFlags  := FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR or FOF_NOCOPYSECURITYATTRIBS;
  end;
  Result := (0 = ShFileOperation(fos));
end;

// Exécuter et attendre la fin
function Executer(const AFichier: TFileName; const AParametres: string = '';
  const ARepertoire: string = ''; const ACache: Boolean = False): Boolean;
var
  InfoExecution     : TShellExecuteInfo;
  bFini             : Boolean;
begin
  Result := False;

  // -> http://msdn.microsoft.com/library/bb762154
  FillChar(InfoExecution, SizeOf(InfoExecution), #0);
  InfoExecution.cbSize        := SizeOf(InfoExecution);
  InfoExecution.fMask         := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_NOASYNC;
  InfoExecution.lpVerb        := 'OPEN';
  InfoExecution.lpFile        := PChar(AFichier);
  InfoExecution.lpDirectory   := PChar(ARepertoire);
  InfoExecution.lpParameters  := PChar(AParametres);
  if not(ACache) then
    InfoExecution.nShow       := SW_SHOW
  else
    InfoExecution.nShow       := SW_HIDE;
  if ShellExecuteEx(@InfoExecution) then
  begin
    bFini := False;
    Application.ProcessMessages();

    // Attente de la fin du programme
    repeat
      case WaitForSingleObject(InfoExecution.hProcess, 200) of
        WAIT_OBJECT_0:
          bFini := True;
        WAIT_TIMEOUT:
          bFini := False;
      end;
      Application.ProcessMessages();
    until bFini;

    Result := True;
  end;
end;

// Exécuter en tant qu'administrateur et attendre la fin
function ExecuterAdministrateur(const AFichier: TFileName;
  const AParametres: string = ''; const ARepertoire: string = '';
  const ACache: Boolean = False): Boolean;
var
  InfoExecution     : TShellExecuteInfo;
  bFini             : Boolean;
begin
  Result := False;

  // -> http://msdn.microsoft.com/library/bb762154
  FillChar(InfoExecution, SizeOf(InfoExecution), #0);
  InfoExecution.cbSize        := SizeOf(InfoExecution);
  InfoExecution.fMask         := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_NOASYNC;
  InfoExecution.lpVerb        := 'RUNAS';
  InfoExecution.lpFile        := PChar(AFichier);
  InfoExecution.lpDirectory   := PChar(ARepertoire);
  InfoExecution.lpParameters  := PChar(AParametres);
  if not(ACache) then
    InfoExecution.nShow       := SW_SHOW
  else
    InfoExecution.nShow       := SW_HIDE;
  if ShellExecuteEx(@InfoExecution) then
  begin
    bFini := False;
    Application.ProcessMessages();

    // Attente de la fin du programme
    repeat
      case WaitForSingleObject(InfoExecution.hProcess, 200) of
        WAIT_OBJECT_0:
          bFini := True;
        WAIT_TIMEOUT:
          bFini := False;
      end;
      Application.ProcessMessages();
    until bFini;

    Result := True;
  end;
end;

// Créer un service
function CreerService(const ANomService: String = 'SymmetricDS';
  const ACheminExe: String = 'java -jar "C:\SymmetricDS-Pro\lib\symmetric-wrapper.jar" init "C:\SymmetricDS-Pro\conf\sym_service.conf"'): Boolean;
var
  Fini:                     Boolean;
  InfoExecution:            TShellExecuteInfo;
  HandleSCM, HandleService: SC_HANDLE;
begin
  Result := False;

  try
    // Connexion au gestionnaire de service
    // -> http://msdn.microsoft.com/library/ms684323
    HandleSCM := OpenSCManager(Nil, Nil, SC_MANAGER_ALL_ACCESS);

    if HandleSCM = 0 then
    begin
      raise EServiceCreer.Create('Erreur lors de la connexion au gestionnaire de service.');
    end;

    // Ouverture du service
    // -> http://msdn.microsoft.com/library/ms684330
    HandleService := OpenService(HandleSCM, Pchar(ANomService),
      SC_MANAGER_ALL_ACCESS);

    // Si le service n'existe pas
    if HandleService = 0 then
    begin
      // Paramètre d'exécution
      // -> http://msdn.microsoft.com/library/bb762154
      FillChar(InfoExecution, SizeOf(InfoExecution), #0);
      with InfoExecution do
      begin
        cbSize       := SizeOf(InfoExecution);
        fMask        := SEE_MASK_NOCLOSEPROCESS;
        lpVerb       := 'OPEN';
        lpFile       := Pchar(ACheminExe);
        lpDirectory  := Pchar(ExtractFilePath(ACheminExe));
        lpParameters := '/INSTALL';
        nShow        := SW_NORMAL;
      end;

      // Exécution
      // -> http://msdn.microsoft.com/library/bb762154
      if ShellExecuteEx(@InfoExecution) then
      begin
        Fini := False;
        repeat
          // -> http://msdn.microsoft.com/library/ms687032
          case WaitForSingleObject(InfoExecution.hProcess, 200) of
            WAIT_OBJECT_0:
              Fini := True;
            WAIT_TIMEOUT:
              Fini := False;
          end;
          Application.ProcessMessages();
        until Fini;
        Result := True;
      end
      else begin
        raise EServiceCreer.Create('Erreur lors de l’installation du service.');
      end;
    end
    // Si le service existe
    else
      Result := True;
  finally
    // Libère les maintiens pour les services
    // -> http://msdn.microsoft.com/library/ms682028
    CloseServiceHandle(HandleSCM);
    CloseServiceHandle(HandleService);
  end;
end;

// Démarrer un service
function DemarrerService(const ANomService: String = 'SymmetricDS'): Boolean;
var
  HandleSCM, HandleService: SC_HANDLE;
  TabArguments:             Pchar;
  IdErreur:                 Cardinal;
begin
  Result := False;

  try
    // Connexion au gestionnaire de service
    // -> http://msdn.microsoft.com/library/ms684323
    HandleSCM := OpenSCManager(Nil, Nil, GENERIC_EXECUTE);

    if HandleSCM = 0 then
    begin
      IdErreur := GetLastError();

      raise EServiceDemarrage.Create('Erreur lors de la connexion au gestionnaire de service.'
        + sLineBreak + SysErrorMessage(IdErreur));
    end;

    // Ouverture du service
    // -> http://msdn.microsoft.com/library/ms684330
    HandleService := OpenService(HandleSCM, Pchar(ANomService),
      GENERIC_EXECUTE);
    if HandleService = 0 then
    begin
      IdErreur := GetLastError();

      raise EServiceDemarrage.Create(Format('Erreur lors de l’ouverture du service "%s".', [ANomService])
        + sLineBreak + SysErrorMessage(IdErreur));
    end;

    // Lancement du service
    // -> http://msdn.microsoft.com/library/ms686321
    if not StartService(HandleService, 0, TabArguments) then
    begin
      IdErreur := GetLastError();

      // Si l'erreur a indiqué que le service était déjà démarrer : c'est bon
      if IdErreur <> ERROR_SERVICE_ALREADY_RUNNING then
      begin
        raise EServiceDemarrage.Create(Format('Erreur lors du démarrage du service "%s". %s',
          [ANomService, SysErrorMessage(IdErreur)]));
      end;
    end;

    Result := True;
  finally
    // Libère les maintiens pour les services
    // -> http://msdn.microsoft.com/library/ms682028
    CloseServiceHandle(HandleSCM);
    CloseServiceHandle(HandleService);
  end;
end;

// Arrête un service
function ArreterService(const ANomService: String = 'SymmetricDS'): Boolean;
var
  HandleSCM, HandleService: SC_HANDLE;
  StatusService:            TServiceStatus;
begin
  Result := False;

  try
    // Connexion au gestionnaire de service
    // -> http://msdn.microsoft.com/library/ms684323
    HandleSCM := OpenSCManager(Nil, Nil, GENERIC_EXECUTE);

    if HandleSCM = 0 then
    begin
      raise EServiceArret.Create('Erreur lors de la connexion au gestionnaire de service.');
    end;

    // Ouverture du service
    // -> http://msdn.microsoft.com/library/ms684330
    HandleService := OpenService(HandleSCM, Pchar(ANomService),
      GENERIC_EXECUTE);
    if HandleService = 0 then
    begin
      raise EServiceArret.Create(Format('Erreur lors de l’ouverture du service "%s".', [ANomService]));
    end;

    // Arrêt du service
    // -> http://msdn.microsoft.com/library/ms682108
    if not ControlService(HandleService, SERVICE_CONTROL_STOP,
      StatusService) then
    begin
      raise EServiceDemarrage.Create(Format('Erreur lors de l’arrêt du service "%s".', [ANomService]));
    end;

    Result := True;
  finally
    // Libère les maintiens pour les services
    // -> http://msdn.microsoft.com/library/ms682028
    CloseServiceHandle(HandleSCM);
    CloseServiceHandle(HandleService);
  end;
end;

function SupprimerService(const ANomService: String = 'SymmetricDS';
  const ACheminExe: String = 'java -jar "C:\SymmetricDS-Pro\lib\symmetric-wrapper.jar" init "C:\SymmetricDS-Pro\conf\sym_service.conf"'): Boolean;
var
  HandleSCM, HandleService: SC_HANDLE;
begin
  Result := False;

  try
    // Connexion au gestionnaire de service
    // -> http://msdn.microsoft.com/library/ms684323
    HandleSCM := OpenSCManager(Nil, Nil, SC_MANAGER_ALL_ACCESS);

    if HandleSCM = 0 then
    begin
      raise EServiceSupprimer.Create('Erreur lors de la connexion au gestionnaire de service.');
    end;

    // Ouverture du service
    // -> http://msdn.microsoft.com/library/ms684330
    HandleService := OpenService(HandleSCM, Pchar(ANomService),
      SC_MANAGER_ALL_ACCESS);
    if HandleService = 0 then
      // Le service n'existe pas : c'est bon
      Result := True
    else
      // Le service existe : le désinstaller
      Result := ShellExecute(0, 'OPEN', Pchar(ACheminExe), '/UNINSTALL', '', SW_NORMAL) > 32;
  finally
    // Libère les maintiens pour les services
    // -> http://msdn.microsoft.com/library/ms682028
    CloseServiceHandle(HandleSCM);
    CloseServiceHandle(HandleService);
  end;
end;

function ServiceExiste(const ANomService: String = 'SymmetricDS'): Boolean;
var
  HandleSCM, HandleService: SC_HANDLE;
begin
  Result := False;

  try
    // Connexion au gestionnaire de service
    // -> http://msdn.microsoft.com/library/ms684323
    HandleSCM := OpenSCManager(Nil, Nil, GENERIC_READ);

    if HandleSCM = 0 then
    begin
      raise EServiceDetecter.Create('Erreur lors de la connexion au gestionnaire de service.');
    end;

    // Ouverture du service
    // -> http://msdn.microsoft.com/library/ms684330
    HandleService := OpenService(HandleSCM, Pchar(ANomService),
      GENERIC_READ);
    Result        := HandleService <> 0;
  finally
    // Libère les maintiens pour les services
    // -> http://msdn.microsoft.com/library/ms682028
    CloseServiceHandle(HandleSCM);
    CloseServiceHandle(HandleService);
  end;
end;

// Récupère des informations sur un service
function InfoSurService(const AService: String = 'SymmetricDS'): TInfoSurService;
var
  HandleSCM, HandleService: SC_HANDLE;
  ServiceConfig: LPQUERY_SERVICE_CONFIGW;
  BytesNeeded: DWORD;
  ErrorCode: Cardinal;
begin
  Result.Init;
  try
    try
    // Connexion au gestionnaire de service
    // -> http://msdn.microsoft.com/library/ms684323
    HandleSCM := OpenSCManager(Nil, Nil, GENERIC_READ);

    if HandleSCM = 0 then
      begin
          Result.ErrorMessage:='Erreur lors de la connexion au gestionnaire de services.';
          exit;
      end;

    // Ouverture du service
    // -> http://msdn.microsoft.com/library/ms684330
    HandleService := OpenService(HandleSCM, Pchar(AService), GENERIC_READ);
    // Si le service n'existe pas
    if HandleService = 0 then
       begin
           Result.ErrorMessage:=Format('Le service "%s" n’existe pas.', [AService]);
           exit;
        end;
    // le service existe
    Result.Exist:=true;

    // Premier appel pour récupérer la taille du buffer
    QueryServiceConfig(HandleService, nil, 0, BytesNeeded);

    ErrorCode := GetLastError();

    if ErrorCode <> ERROR_INSUFFICIENT_BUFFER then
      begin
        Result.ErrorMessage:= Format('Erreur lors de la récupération de la configuration du service "%s". %s',
            [AService, SysErrorMessage(ErrorCode)]);
        exit;
      end;

    GetMem(ServiceConfig, BytesNeeded);

    // Second appel pour récupérer les informations
    if QueryServiceConfig(HandleService, ServiceConfig, BytesNeeded, BytesNeeded) then
    begin
      with ServiceConfig^ do
      begin
        // Récupére les informations
        case dwServiceType of
          SERVICE_FILE_SYSTEM_DRIVER:
            Result.ServiceType  := FileSystemDriver;
          SERVICE_KERNEL_DRIVER:
            Result.ServiceType  := KernelDriver;
          SERVICE_WIN32_OWN_PROCESS:
            Result.ServiceType  := Win32OwnProcess;
          SERVICE_WIN32_SHARE_PROCESS:
            Result.ServiceType  := Win32ShareProcess;
        end;

        case dwStartType of
          SERVICE_AUTO_START:
            Result.StartType    := AutoStart;
          SERVICE_BOOT_START:
            Result.StartType    := BootStart;
          SERVICE_DEMAND_START:
            Result.StartType    := DemandStart;
          SERVICE_DISABLED:
            Result.StartType    := Disabled;
          SERVICE_SYSTEM_START:
            Result.StartType    := SystemStart;
        end;

        case dwErrorControl of
          SERVICE_ERROR_CRITICAL:
            Result.ErrorControl := ErrorCritical;
          SERVICE_ERROR_IGNORE:
            Result.ErrorControl := ErrorIgnore;
          SERVICE_ERROR_NORMAL:
            Result.ErrorControl := ErrorNormal;
          SERVICE_ERROR_SEVERE:
            Result.ErrorControl := ErrorSevere;
        end;

        Result.BinaryPathName   := lpBinaryPathName;
        Result.LoadOrderGroup   := lpLoadOrderGroup;
        Result.TagId            := dwTagId;
        Result.Dependencies     := lpDependencies;
        Result.ServiceStartName := lpServiceStartName;
        Result.DisplayName      := lpDisplayName;
      end;
    end
    else begin
      ErrorCode := GetLastError();
      Result.ErrorMessage :=Format('Erreur lors de la récupération de la configuration du service "%s". %s',
        [AService, SysErrorMessage(ErrorCode)]);
    end;
    Except

    end;
  finally
    // Libère les maintiens pour les services
    If Assigned(ServiceConfig) then
      FreeMem(ServiceConfig);

    // -> http://msdn.microsoft.com/library/ms682028
    If (HandleSCM<>0) then CloseServiceHandle(HandleSCM);
    if HandleService<>0 then CloseServiceHandle(HandleService);
  end;
end;

end.
