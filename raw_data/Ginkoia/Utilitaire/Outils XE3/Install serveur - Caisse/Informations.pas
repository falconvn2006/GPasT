unit Informations;

interface

uses
  SysUtils, Windows, WinSvc;

type
  // Information sur un exécutable
  TInfoSurExe = record
    FileDescription:  String;
    CompanyName:      String;
    FileVersion:      String;
    InternalName:     String;
    LegalCopyright:   String;
    OriginalFileName: String;
    ProductName:      String;
    ProductVersion:   String;
  end;
  TInfoSurService = record
    ServiceType:      (FileSystemDriver, KernelDriver, Win32OwnProcess, Win32ShareProcess);
    StartType:        (AutoStart, BootStart, DemandStart, Disabled, SystemStart);
    ErrorControl:     (ErrorCritical, ErrorIgnore, ErrorNormal, ErrorSevere);
    BinaryPathName:   String;
    LoadOrderGroup:   String;
    TagId:            Integer;
    Dependencies:     String;
    ServiceStartName: String;
    DisplayName:      String;
  end;

// Récupère des informations sur un exécutable
function InfoSurExe(AFichier: String): TInfoSurExe;
// Récupère des informations sur un service
function InfoSurService(AService: String): TInfoSurService;
// Vérifie si un service existe
function ServiceExiste(AService: String): Boolean;

resourcestring
  RS_ERREUR_GESTIONNAIRE_SERVICE = 'Erreur lors de la connexion au gestionnaire de services.';
  RS_ERREUR_OUVERTURE_SERVICE    = 'Le service "%s" n''existe pas.';
  RS_ERREUR_RECUPERATION_CONFIG  = 'Erreur lors de la récupération de la configuration du service "%s". %s';

implementation

// Récupère des informations sur un exécutable
function InfoSurExe(AFichier: String): TInfoSurExe;
const
  VersionInfo: array [1..8] of String =
    ('FileDescription', 'CompanyName', 'FileVersion',
    'InternalName', 'LegalCopyRight', 'OriginalFileName',
    'ProductName', 'ProductVersion');
var
  Handle:   DWord;
  Info:     Pointer;
  InfoData: PChar;
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
          if VerQueryValue(Info, @InfoType[1], Pointer(InfoData), DataLen) then
            case i of
              1:
                Result.FileDescription    := InfoData;
              2:
                Result.CompanyName        := InfoData;
              3:
                Result.FileVersion        := InfoData;
              4:
                Result.InternalName       := InfoData;
              5:
                Result.LegalCopyright     := InfoData;
              6:
                Result.OriginalFileName   := InfoData;
              7:
                Result.ProductName        := InfoData;
              8:
                Result.ProductVersion     := InfoData;
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

// Récupère des informations sur un service
function InfoSurService(AService: String): TInfoSurService;
var
  HandleSCM, HandleService: SC_HANDLE;
  ServiceConfig: PQueryServiceConfig;
  BytesNeeded: DWORD;
  ErrorCode: Cardinal;
begin
//  try
//    // Connexion au gestionnaire de service
//    // -> http://msdn.microsoft.com/library/ms684323
//    HandleSCM := OpenSCManager(Nil, Nil, SC_MANAGER_ALL_ACCESS);
//
//    if HandleSCM = 0 then
//      raise Exception.Create(RS_ERREUR_GESTIONNAIRE_SERVICE);
//
//    // Ouverture du service
//    // -> http://msdn.microsoft.com/library/ms684330
//    HandleService := OpenService(HandleSCM, Pchar(AService), SC_MANAGER_ALL_ACCESS);
//
//    // Si le service n'existe pas
//    if HandleService = 0 then
//      raise Exception.Create(Format(RS_ERREUR_OUVERTURE_SERVICE, [AService]));
//
//    // Premier appel pour récupérer la taille du buffer
//    QueryServiceConfig(HandleService, nil, 0, BytesNeeded);
//
//    ErrorCode := GetLastError();
//
//    if ErrorCode <> ERROR_INSUFFICIENT_BUFFER then
//      raise Exception.Create(Format(RS_ERREUR_RECUPERATION_CONFIG, [AService, SysErrorMessage(ErrorCode)]));
//
//    GetMem(ServiceConfig, BytesNeeded);
//
//    // Second appel pour récupérer les informations
//    if QueryServiceConfig(HandleService, ServiceConfig, BytesNeeded, BytesNeeded) then
//    begin
//      with ServiceConfig^ do
//      begin
//        // Récupére les informations
//        case dwServiceType of
//          SERVICE_FILE_SYSTEM_DRIVER:
//            Result.ServiceType  := FileSystemDriver;
//          SERVICE_KERNEL_DRIVER:
//            Result.ServiceType  := KernelDriver;
//          SERVICE_WIN32_OWN_PROCESS:
//            Result.ServiceType  := Win32OwnProcess;
//          SERVICE_WIN32_SHARE_PROCESS:
//            Result.ServiceType  := Win32ShareProcess;
//        end;
//
//        case dwStartType of
//          SERVICE_AUTO_START:
//            Result.StartType    := AutoStart;
//          SERVICE_BOOT_START:
//            Result.StartType    := BootStart;
//          SERVICE_DEMAND_START:
//            Result.StartType    := DemandStart;
//          SERVICE_DISABLED:
//            Result.StartType    := Disabled;
//          SERVICE_SYSTEM_START:
//            Result.StartType    := SystemStart;
//        end;
//
//        case dwErrorControl of
//          SERVICE_ERROR_CRITICAL:
//            Result.ErrorControl := ErrorCritical;
//          SERVICE_ERROR_IGNORE:
//            Result.ErrorControl := ErrorIgnore;
//          SERVICE_ERROR_NORMAL:
//            Result.ErrorControl := ErrorNormal;
//          SERVICE_ERROR_SEVERE:
//            Result.ErrorControl := ErrorSevere;
//        end;
//
//        Result.BinaryPathName   := lpBinaryPathName;
//        Result.LoadOrderGroup   := lpLoadOrderGroup;
//        Result.TagId            := dwTagId;
//        Result.Dependencies     := lpDependencies;
//        Result.ServiceStartName := lpServiceStartName;
//        Result.DisplayName      := lpDisplayName;
//      end;
//    end
//    else begin
//      ErrorCode := GetLastError();
//      raise Exception.Create(Format(RS_ERREUR_RECUPERATION_CONFIG, [AService, SysErrorMessage(ErrorCode)]));
//    end;
//  finally
//    // Libère les maintiens pour les services
//    If Assigned(ServiceConfig) then
//      FreeMem(ServiceConfig);
//
//    // -> http://msdn.microsoft.com/library/ms682028
//    CloseServiceHandle(HandleSCM);
//    CloseServiceHandle(HandleService);
//  end;
end;

// Vérifie si un service existe
function ServiceExiste(AService: String): Boolean;
var
  HandleSCM, HandleService: SC_HANDLE;
begin
  try
    // Connexion au gestionnaire de service
    // -> http://msdn.microsoft.com/library/ms684323
    HandleSCM := OpenSCManager(Nil, Nil, SC_MANAGER_ALL_ACCESS);

    if HandleSCM = 0 then
      raise Exception.Create(RS_ERREUR_GESTIONNAIRE_SERVICE);

    // Ouverture du service DBISAM
    // -> http://msdn.microsoft.com/library/ms684330
    HandleService := OpenService(HandleSCM, PChar(AService), SC_MANAGER_ALL_ACCESS);
    Result := (HandleService <> 0);
  finally
    // Libère les maintiens pour les services
    // -> http://msdn.microsoft.com/library/ms682028
    CloseServiceHandle(HandleSCM);
    CloseServiceHandle(HandleService);
  end;
end;

end.
