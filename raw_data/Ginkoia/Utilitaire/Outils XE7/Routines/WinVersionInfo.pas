unit WinVersionInfo;

interface

type
  TWinVersion = (wv_Unknown,
                 wv_Win95, wv_WinOSR2, wv_Win98, wv_Win98SE, wv_WinME, // Branch Win 9x
                 wv_WinNT, wv_Win2000,                                 // Branche NT pro
                 wv_WinXP, wv_WinXP64,                                 // Branche NT mixte...
                     wv_WinServer2003, wv_WinHomeServer, wv_WinServer2003R2,
                 wv_WinVista,wv_WinSeven,
                     wv_WinServer2008, wv_WinServer2008R2,
                 wv_Win8, wv_Win81,
                     wv_WinServer2012, wv_WinServer2012R2,
                 wv_Win10,
                     wv_WinServer2016,
                 wv_WinNext);                                          // autre ??

// Recuperation de la version de windows dans un type enuméré
function GetWinVersion() : TWinVersion;
// Recuperation d'une string a partir du type enuméré
function WinVersionToString(wv : TWinVersion) : string;

implementation

uses
  Winapi.Windows;

const
// Système metric a demandé pour la sous version de server 2003
  SM_SERVERR2 = 89; // The build number if the system is Windows Server 2003 R2; otherwise, 0.

const
// type de produit !
  VER_NT_WORKSTATION       = $0000001; // The operating system is Windows Vista, Windows XP Professional, Windows XP Home Edition, Windows 2000 Professional, or Windows NT Workstation 4.0.
  // Note that a server that is also a domain controller is reported as VER_NT_DOMAIN_CONTROLLER, not VER_NT_SERVER.
  VER_NT_DOMAIN_CONTROLLER = $0000002; // The system is a domain controller.
  VER_NT_SERVER            = $0000003; // The system is a server.

const
// masque des suite installé
  VER_SUITE_BACKOFFICE               = $00000004; // Microsoft BackOffice components are installed.
  VER_SUITE_BLADE                    = $00000400; // Windows Server 2003, Web Edition is installed.
  VER_SUITE_COMPUTE_SERVER           = $00004000; // Windows Server 2003, Compute Cluster Edition is installed.
  VER_SUITE_DATACENTER               = $00000080; // Windows Server 2008 Datacenter, Windows Server 2003, Datacenter Edition, or Windows 2000 Datacenter Server is installed.
  VER_SUITE_ENTERPRISE               = $00000002; // Windows Server 2008 Enterprise, Windows Server 2003, Enterprise Edition, or Windows 2000 Advanced Server is installed. Refer to the Remarks section for more information about this bit flag.
  VER_SUITE_EMBEDDEDNT               = $00000040; // Windows XP Embedded is installed.
  VER_SUITE_PERSONAL                 = $00000200; // Windows Vista Home Premium, Windows Vista Home Basic, or Windows XP Home Edition is installed.
  VER_SUITE_SINGLEUSERTS             = $00000100; // Remote Desktop is supported, but only one interactive session is supported. This value is set unless the system is running in application server mode.
  VER_SUITE_SMALLBUSINESS            = $00000001; // Microsoft Small Business Server was once installed on the system, but may have been upgraded to another version of Windows. Refer to the Remarks section for more information about this bit flag.
  VER_SUITE_SMALLBUSINESS_RESTRICTED = $00000020; // Microsoft Small Business Server is installed with the restrictive client license in force. Refer to the Remarks section for more information about this bit flag.
  VER_SUITE_STORAGE_SERVER           = $00002000; // Windows Storage Server 2003 R2 or Windows Storage Server 2003is installed.
  VER_SUITE_TERMINAL                 = $00000010; // Terminal Services is installed. This value is always set.
                                                  // If VER_SUITE_TERMINAL is set but VER_SUITE_SINGLEUSERTS is not set, the system is running in application server mode.
  VER_SUITE_WH_SERVER                = $00008000; // Windows Home Server is installed.

const
// Architecture
  PROCESSOR_ARCHITECTURE_AMD64 = 9;

const
// Type de produit installé
  PRODUCT_BUSINESS                      = $00000006; // Business Edition
  PRODUCT_BUSINESS_N                    = $00000010; // Business Edition (without media center)
  PRODUCT_CLUSTER_SERVER                = $00000012; // Cluster Server Edition
  PRODUCT_DATACENTER_SERVER             = $00000008; // Server Datacenter Edition (full installation)
  PRODUCT_DATACENTER_SERVER_CORE        = $0000000C; // Server Datacenter Edition (core installation)
  PRODUCT_ENTERPRISE                    = $00000004; // Enterprise Edition
  PRODUCT_ENTERPRISE_N                  = $0000001B; // Enterprise Edition (without media center)
  PRODUCT_ENTERPRISE_SERVER             = $0000000A; // Server Enterprise Edition (full installation)
  PRODUCT_ENTERPRISE_SERVER_CORE        = $0000000E; // Server Enterprise Edition (core installation)
  PRODUCT_ENTERPRISE_SERVER_IA64        = $0000000F; // Server Enterprise Edition for Itanium-based Systems
  PRODUCT_HOME_BASIC                    = $00000002; // Home Basic Edition
  PRODUCT_HOME_BASIC_N                  = $00000005; // Home Basic Edition (without media center)
  PRODUCT_HOME_PREMIUM                  = $00000003; // Home Premium Edition
  PRODUCT_HOME_PREMIUM_N                = $0000001A; // Home Premium Edition (without media center)
  PRODUCT_HOME_SERVER                   = $00000013; // Home Server Edition
  PRODUCT_SERVER_FOR_SMALLBUSINESS      = $00000018; // Server for Small Business Edition
  PRODUCT_SMALLBUSINESS_SERVER          = $00000009; // Small Business Server
  PRODUCT_SMALLBUSINESS_SERVER_PREMIUM  = $00000019; // Small Business Server Premium Edition
  PRODUCT_STANDARD_SERVER               = $00000007; // Server Standard Edition (full installation)
  PRODUCT_STANDARD_SERVER_CORE          = $0000000D; // Server Standard Edition (core installation)
  PRODUCT_STARTER                       = $0000000B; // Starter Edition
  PRODUCT_STORAGE_ENTERPRISE_SERVER     = $00000017; // Storage Server Enterprise Edition
  PRODUCT_STORAGE_EXPRESS_SERVER        = $00000014; // Storage Server Express Edition
  PRODUCT_STORAGE_STANDARD_SERVER       = $00000015; // Storage Server Standard Edition
  PRODUCT_STORAGE_WORKGROUP_SERVER      = $00000016; // Storage Server Workgroup Edition
  PRODUCT_UNDEFINED                     = $00000000; // An unknown product
  PRODUCT_ULTIMATE                      = $00000001; // Ultimate Edition
  PRODUCT_ULTIMATE_N                    = $0000001C; // Ultimate Edition (without media center)
  PRODUCT_WEB_SERVER                    = $00000011; // Web Server Edition
  PRODUCT_UNLICENSED                    = $ABCDABCD; // Unlicensed product

type
  WKSTA_INFO_100 = record
    wki100_platform_id: DWORD;
    wki100_computername: LPWSTR;
    wki100_langroup: LPWSTR;
    wki100_ver_major: DWORD;
    wki100_ver_minor: DWORD;
  end;
  LPWKSTA_INFO_100 = ^WKSTA_INFO_100;

function NetWkstaGetInfo(ServerName: LPWSTR; Level: DWORD; BufPtr: LPBYTE): Longint; stdcall; external 'netapi32.dll' name 'NetWkstaGetInfo';

function PlatformToString(id : DWORD) : string;
begin
  case id of
    VER_PLATFORM_WIN32s        : Result := '??';
    VER_PLATFORM_WIN32_WINDOWS : Result := 'Branche 9x';
    VER_PLATFORM_WIN32_NT      : Result := 'Branche NT';
    VER_PLATFORM_WIN32_CE      : Result := 'Branche CE';
  end;
end;

function ProductTypeToString(ptype : WORD) : string;
begin
  case ptype of
    VER_NT_WORKSTATION       : Result := 'Station de travail';
    VER_NT_SERVER            : Result := 'Serveur';
    VER_NT_DOMAIN_CONTROLLER : Result := 'Serveur de domaine';
  end;
end;

function SuiteToString(SuiteMask : WORD) : string;
begin
  Result := '';
       if (SuiteMask and VER_SUITE_BACKOFFICE) <> 0 then               Result := Result + #13 + 'Microsoft BackOffice components are installed.'
  else if (SuiteMask and VER_SUITE_BLADE) <> 0 then                    Result := Result + #13 + 'Windows Server 2003, Web Edition is installed.'
  else if (SuiteMask and VER_SUITE_COMPUTE_SERVER) <> 0 then           Result := Result + #13 + 'Windows Server 2003, Compute Cluster Edition is installed.'
  else if (SuiteMask and VER_SUITE_DATACENTER) <> 0 then               Result := Result + #13 + 'Windows Server 2008 Datacenter, Windows Server 2003, Datacenter Edition, or Windows 2000 Datacenter Server is installed.'
  else if (SuiteMask and VER_SUITE_ENTERPRISE) <> 0 then               Result := Result + #13 + 'Windows Server 2008 Enterprise, Windows Server 2003, Enterprise Edition, or Windows 2000 Advanced Server is installed. Refer to the Remarks section for more information about this bit flag.'
  else if (SuiteMask and VER_SUITE_EMBEDDEDNT) <> 0 then               Result := Result + #13 + 'Windows XP Embedded is installed.'
  else if (SuiteMask and VER_SUITE_PERSONAL) <> 0 then                 Result := Result + #13 + 'Windows Vista Home Premium, Windows Vista Home Basic, or Windows XP Home Edition is installed.'
  else if (SuiteMask and VER_SUITE_SINGLEUSERTS) <> 0 then             Result := Result + #13 + 'Remote Desktop is supported, but only one interactive session is supported. This value is set unless the system is running in application server mode.'
  else if (SuiteMask and VER_SUITE_SMALLBUSINESS) <> 0 then            Result := Result + #13 + 'Microsoft Small Business Server was once installed on the system, but may have been upgraded to another version of Windows. Refer to the Remarks section for more information about this bit flag.'
  else if (SuiteMask and VER_SUITE_SMALLBUSINESS_RESTRICTED) <> 0 then Result := Result + #13 + 'Microsoft Small Business Server is installed with the restrictive client license in force. Refer to the Remarks section for more information about this bit flag.'
  else if (SuiteMask and VER_SUITE_STORAGE_SERVER) <> 0 then           Result := Result + #13 + 'Windows Storage Server 2003 R2 or Windows Storage Server 2003is installed.'
  else if (SuiteMask and VER_SUITE_TERMINAL) <> 0 then                 Result := Result + #13 + 'Terminal Services is installed. This value is always set.'
  else if (SuiteMask and VER_SUITE_WH_SERVER) <> 0 then                Result := Result + #13 + 'Windows Home Server is installed.';
  Result := Copy(Result, 2, Length(Result));
end;

function GetProductInfoString(VerOSMaj, VerOSMin : DWORD; VerSPMin, VerSPMaj : WORD) : string;
var
  ProductType : DWORD;
  GetProductInfo: function(dwOSMajorVersion, dwOSMinorVersion,
                           dwSpMajorVersion, dwSpMinorVersion: DWORD;
                           var pdwReturnedProductType: DWORD): BOOL stdcall;
begin
  Result := '';
  @GetProductInfo := GetProcAddress(GetModuleHandle('KERNEL32.DLL'), 'GetProductInfo');
  if Assigned(GetProductInfo) then
  begin
    if GetProductInfo(VerOSMaj, VerOSMin, VerSPMaj, VerSPMin, ProductType) then
    begin
      case ProductType of
        PRODUCT_BUSINESS :                     Result := 'Business Edition';
        PRODUCT_BUSINESS_N :                   Result := 'Business Edition (without media center)';
        PRODUCT_CLUSTER_SERVER :               Result := 'Cluster Server Edition';
        PRODUCT_DATACENTER_SERVER :            Result := 'Server Datacenter Edition (full installation)';
        PRODUCT_DATACENTER_SERVER_CORE :       Result := 'Server Datacenter Edition (core installation)';
        PRODUCT_ENTERPRISE :                   Result := 'Enterprise Edition';
        PRODUCT_ENTERPRISE_N :                 Result := 'Enterprise Edition (without media center)';
        PRODUCT_ENTERPRISE_SERVER :            Result := 'Server Enterprise Edition (full installation)';
        PRODUCT_ENTERPRISE_SERVER_CORE :       Result := 'Server Enterprise Edition (core installation)';
        PRODUCT_ENTERPRISE_SERVER_IA64 :       Result := 'Server Enterprise Edition for Itanium-based Systems';
        PRODUCT_HOME_BASIC :                   Result := 'Home Basic Edition';
        PRODUCT_HOME_BASIC_N :                 Result := 'Home Basic Edition (without media center)';
        PRODUCT_HOME_PREMIUM :                 Result := 'Home Premium Edition';
        PRODUCT_HOME_PREMIUM_N :               Result := 'Home Premium Edition (without media center)';
        PRODUCT_HOME_SERVER :                  Result := 'Home Server Edition';
        PRODUCT_SERVER_FOR_SMALLBUSINESS :     Result := 'Server for Small Business Edition';
        PRODUCT_SMALLBUSINESS_SERVER :         Result := 'Small Business Server';
        PRODUCT_SMALLBUSINESS_SERVER_PREMIUM : Result := 'Small Business Server Premium Edition';
        PRODUCT_STANDARD_SERVER :              Result := 'Server Standard Edition (full installation)';
        PRODUCT_STANDARD_SERVER_CORE :         Result := 'Server Standard Edition (core installation)';
        PRODUCT_STARTER :                      Result := 'Starter Edition';
        PRODUCT_STORAGE_ENTERPRISE_SERVER :    Result := 'Storage Server Enterprise Edition';
        PRODUCT_STORAGE_EXPRESS_SERVER :       Result := 'Storage Server Express Edition';
        PRODUCT_STORAGE_STANDARD_SERVER :      Result := 'Storage Server Standard Edition';
        PRODUCT_STORAGE_WORKGROUP_SERVER :     Result := 'Storage Server Workgroup Edition';
        PRODUCT_ULTIMATE :                     Result := 'Ultimate Edition';
        PRODUCT_ULTIMATE_N :                   Result := 'Ultimate Edition (without media center)';
        PRODUCT_WEB_SERVER :                   Result := 'Web Server Edition';
        PRODUCT_UNLICENSED :                   Result := 'Unlicensed product'
        else                                   Result := 'An unknown product';
      end;
    end;
  end;
end;

function GetWinVersion() : TWinVersion;

  function GetProductVersion(var AMajor, AMinor, ABuild: Cardinal): Boolean;
  var
    FileName: string;
    InfoSize, Wnd: DWORD;
    VerBuf: Pointer;
    FI: PVSFixedFileInfo;
    VerSize: DWORD;
  begin
    Result := False;
    // GetFileVersionInfo modifies the filename parameter data while parsing.
    // Copy the string const into a local variable to create a writeable copy.
    FileName := 'kernel32.dll';
    UniqueString(FileName);
    InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
    if InfoSize <> 0 then
    begin
      GetMem(VerBuf, InfoSize);
      try
        if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
          if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
          begin
            AMajor := HiWord(FI.dwProductVersionMS);
            AMinor := LoWord(FI.dwProductVersionMS);
            ABuild := HiWord(FI.dwProductVersionLS);
            Result:= True;
          end;
      finally
        FreeMem(VerBuf);
      end;
    end;
  end;

  function GetNetWkstaMajorMinor(var MajorVersion, MinorVersion: DWORD): Boolean;
  var
    LBuf: LPWKSTA_INFO_100;
  begin
    Result := NetWkstaGetInfo(nil, 100, @LBuf) = 0;
    if Result then
    begin
      MajorVersion := LBuf^.wki100_ver_major;
      MinorVersion := LBuf^.wki100_ver_minor;
    end;
  end;

var
  osVerInfo : TOSVersionInfoEx;
  osSysInfo : TSystemInfo;
  MajorNum, MinorNum, BuildNum : DWORD;
begin
  Result := wv_Unknown;

  ZeroMemory(@osSysInfo, SizeOf(osSysInfo));
  ZeroMemory(@osVerInfo, SizeOf(osVerInfo));
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);

  GetSystemInfo(osSysInfo);
  if GetVersionEx(osVerInfo) then
  begin
    case osVerInfo.dwPlatformId of
      VER_PLATFORM_WIN32s :
        // ???
        ;
      VER_PLATFORM_WIN32_CE :
        // platform windows CE
        ;

      VER_PLATFORM_WIN32_WINDOWS :
        begin
               if (osVerInfo.dwMajorVersion = 4) and (osVerInfo.dwMinorVersion < 10) and (osVerInfo.szCSDVersion[1] >= 'B') then
            Result := wv_WinOSR2
          else if (osVerInfo.dwMajorVersion = 4) and (osVerInfo.dwMinorVersion < 10) then
            Result := wv_Win95
          else if (osVerInfo.dwMajorVersion = 4) and (osVerInfo.dwMinorVersion = 10) and (osVerInfo.szCSDVersion[1] = 'A') then
            Result := wv_Win98SE
          else if (osVerInfo.dwMajorVersion = 4) and (osVerInfo.dwMinorVersion = 10) then
            Result := wv_Win98
          else if (osVerInfo.dwMajorVersion = 4) and (osVerInfo.dwMinorVersion = 90) then
            Result := wv_WinME
          else
            Result := wv_Unknown;
        end;
      VER_PLATFORM_WIN32_NT :
        begin
          if (osVerInfo.dwMajorVersion > 6) or ((osVerInfo.dwMajorVersion = 6) and  (osVerInfo.dwMinorVersion > 1)) then
          begin
            if not GetNetWkstaMajorMinor(MajorNum, MinorNum) then
              GetProductVersion(MajorNum, MinorNum, BuildNum);
                 if (MajorNum = 10) and (MinorNum = 0) and (osVerInfo.wProductType = VER_NT_WORKSTATION) then
              Result := wv_Win10
            else if (MajorNum = 10) and (MinorNum = 0) then
              Result := wv_WinServer2016
            else if (MajorNum = 6) and (MinorNum = 3) and (osVerInfo.wProductType = VER_NT_WORKSTATION) then
              Result := wv_Win81
            else if (MajorNum = 6) and (MinorNum = 3) then
              Result := wv_WinServer2012R2
            else if (MajorNum = 6) and (MinorNum = 2) and (osVerInfo.wProductType = VER_NT_WORKSTATION) then
              Result := wv_Win8
          end
          else if (osVerInfo.dwMajorVersion = 6) and (osVerInfo.dwMinorVersion = 1) and (osVerInfo.wProductType = VER_NT_WORKSTATION) then
            Result := wv_WinSeven
          else if (osVerInfo.dwMajorVersion = 6) and (osVerInfo.dwMinorVersion = 1) then
            Result := wv_WinServer2008R2
          else if (osVerInfo.dwMajorVersion = 6) and (osVerInfo.dwMinorVersion = 0) and (osVerInfo.wProductType = VER_NT_WORKSTATION) then
            Result := wv_WinVista
          else if (osVerInfo.dwMajorVersion = 6) and (osVerInfo.dwMinorVersion = 0) then
            Result := wv_WinServer2008
          else if (osVerInfo.dwMajorVersion = 5) and (osVerInfo.dwMinorVersion = 2) and (GetSystemMetrics(SM_SERVERR2) <> 0) then
            Result := wv_WinServer2003R2
          else if (osVerInfo.dwMajorVersion = 5) and (osVerInfo.dwMinorVersion = 2) and ((osVerInfo.wSuiteMask and VER_SUITE_WH_SERVER) <> 0) then
            Result := wv_WinHomeServer
          else if (osVerInfo.dwMajorVersion = 5) and (osVerInfo.dwMinorVersion = 2) and (GetSystemMetrics(SM_SERVERR2) = 0) then
            Result := wv_WinServer2003
          else if (osVerInfo.dwMajorVersion = 5) and (osVerInfo.dwMinorVersion = 2) and (osVerInfo.wProductType = VER_NT_WORKSTATION) and (osSysInfo.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) then
            Result := wv_WinXP64
          else if (osVerInfo.dwMajorVersion = 5) and (osVerInfo.dwMinorVersion = 1) then
            Result := wv_WinXP
          else if (osVerInfo.dwMajorVersion = 5) and (osVerInfo.dwMinorVersion = 0) then
            Result := wv_Win2000
          else if osVerInfo.dwMajorVersion <= 4 then
            Result := wv_WinNT
          else
            Result := wv_WinNext;
        end;
    end;
  end;
end;

function WinVersionToString(wv : TWinVersion) : string;
begin
  case wv of
    wv_Win95 :           Result := 'Windows 95';
    wv_WinOSR2 :         Result := 'Windows 95 OSR-2';
    wv_Win98 :           Result := 'Windows 98';
    wv_Win98SE :         Result := 'Windows 98 Seconde Edition';
    wv_WinME :           Result := 'Windows Millenium';
    wv_WinNT :           Result := 'Windows NT (jusqu''a version 4)';
    wv_Win2000 :         Result := 'Windows 2000';
    wv_WinXP :           Result := 'Windows XP';
    wv_WinXP64 :         Result := 'Windows XP Professional x64 Edition';
    wv_WinVista :        Result := 'Windows Vista';
    wv_WinSeven :        Result := 'Windows 7';
    wv_Win8 :            Result := 'Windows 8';
    wv_Win81 :           Result := 'Windows 8.1';
    wv_Win10 :           Result := 'Windows 10';

    wv_WinServer2003 :   Result := 'Windows Server 2003';
    wv_WinServer2003R2 : Result := 'Windows Server 2003 R2';
    wv_WinHomeServer :   Result := 'Windows Home Server';
    wv_WinServer2008 :   Result := 'Windows Server 2008';
    wv_WinServer2008R2 : Result := 'Windows Server 2008 R2';
    wv_WinServer2012 :   Result := 'Windows Server 2012';
    wv_WinServer2012R2 : Result := 'Windows Server 2012 R2';
    wv_WinServer2016 :   Result := 'Windows Server 2016';

    wv_WinNext:          Result := 'Autre nouvelle version de Windows';
    else                 Result := 'Inconnue';
  end;
end;

end.

