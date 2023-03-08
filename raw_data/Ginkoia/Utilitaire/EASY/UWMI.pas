unit UWMI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, StdCtrls, magwmi, magsubs1, Registry,
  ShellAPi,inifiles,Tlhelp32, WinSvc,Forms,StrUtils, IOUtils, Winapi.ActiveX;

Const QWMI_OS    = 'SELECT BuildNumber, Caption, CSDVersion, CSName, FreePhysicalMemory, FreeSpaceInPagingFiles, FreeVirtualMemory, ' +
                   ' LastBootUptime, LocalDateTime, LastBootUptime, LocalDateTime , Version ' +
                   ' FROM Win32_OperatingSystem';
      QWMI_DRIVE = 'SELECT Compressed, DeviceID, FileSystem, FreeSpace, LastErrorCode, Size FROM Win32_LogicalDisk Where DriveType=3';

      QWMI_PROC  =  'SELECT KernelModeTime, PeakPageFileUsage, PeakVirtualSize, PeakWorkingSetSize, Priority, ProcessID, ' +
                    'ThreadCount, UserModeTime, VirtualSize, WorkingSetSize, WriteOperationCount  FROM Win32_Process WHERE Caption=''%s''';

      QWMI_PERFOS = 'SELECT PercentPrivilegedTime, PercentProcessorTime, PercentUserTime FROM Win32_PerfFormattedData_PerfOS_Processor WHERE Name=''_Total'' ';

      QWMI_PERFPROC = 'SELECT ElapsedTime, HandleCount, Name, PageFileBytesPeak, PercentProcessorTime, WorkingSet, WorkingSetPeak, WorkingSetPrivate FROM  Win32_PerfFormattedData_PerfProc_Process WHERE Name=''%s''';

      QWMI_SERVICES_SYMDS = 'SELECT Name, PathName, StartMode, State, Status FROM Win32_Service WHERE Description=''Database Synchronization'' AND StartMode<>''Disabled'' ';

      QWMI_SERVICES_SYMDS_ONLY_EASY = 'SELECT Name, PathName, StartMode, State, Status FROM Win32_Service WHERE Description=''Database Synchronization'' AND StartMode<>''Disabled'' AND Name=''EASY'' ';



type
    TOSInfos = packed record
      BuildNumber    : string;
      Caption        : string;
      CSDVersion     : string;
      CSName         : string;
      FreePhysicalMemory     : string;
      FreeSpaceInPagingFiles : string;
      FreeVirtualMemory      : string;
      LastBootUptime : string;
      LocalDateTime  : string;
      OSArchitecture : string;
      Version        : string;
     private
      procedure init;
     end;
     TDriveInfos = packed record
        Compressed    : string;
        DeviceID      : string;
        FileSystem    : string;
        FreeSpace     : string;
        LastErrorCode : string;
        Size          : string;
     private
        procedure Init;
     end;
     TDrives = array of TDriveInfos;
     TprocessInfos = packed record
        ElapsedTime            : string;
        PID                    : string;
        Priority               : string;
        PeakPageFileUsage      : string;
        PeakVirtualSize        : string;
        PeakWorkingSetSize     : string;
        ThreadCount            : string;
        VirtualSize            : string;
        WorkingSetSize         : string;
        WriteOperationCount    : string;
        //-----------------------------
        PercentProcessorTime   : string;
        HandleCount            : string;
        UserModeTime           : string;
        KernelModeTime         : string;
        WorkingSet             : string;
        WorkingSetPeak         : string;
        WorkingSetPrivate      : string;
        PageFileBytesPeak      : string;
      private
        procedure Init;
      end;
     TSYMDSInfos = packed record
        ServiceName : string;
        PathName    : String;
        ConfigDir   : string;
        ConfigFile  : String;
        StartMode   : string;
        State       : string;
        Status      : string;
        Directory   : string;
        Version     : string;
        http        : integer;
        https       : integer;
        jmxhttp     : integer;
        jmxagent    : integer;
     private
        procedure Init;
     end;

     TBase = packed record
        BAS_SENDER  : string;
        SYM_NODE    : string;   // le sym_node est presque comme le bas_node mais en plus cour
                                //  serveur_xxxxxx_aaaa_yyy    => s_xxxxxx_aaaa_yyy
                                //  portablez_xxxxxx_aaaa_yyy  => pz_xxxxxx_aaaa_yyy
        BAS_CENTRALE : string;
        BAS_IDENT    : Integer;
        BAS_GUID     : string;
     end;
     TBases = array of TBase;
     TDossierInfos = packed record
        ServiceName      : string;
        HTTPPort         : integer;
        SymDir           : string;
        PropertiesFile   : String;
        DatabaseFile     : string;
        BAS_SENDER       : string;
        BAS_IDENT        : integer;
        BAS_GUID         : string;
        BAS_PLAGE        : string;
        GENERAL_ID       : string;
        ExternalID       : string;
        Version          : string;
        Nom              : string;
        Isok             : boolean;
        // TablesExclues    : string; // Test GR 08/11/2018
        RegistrationUrl  : string;
        NODE_GROUP_ID    : string;
        ListBases        : TBases;
     public
        procedure Init;
        procedure SetSymDir;
     end;
     TVGSE = packed record
       OSInfos      : TOSInfos;
       PublicIP     : string;  // IpPublic sur Internet
       HostName     : string;
       ExePath      : string;
       Javaversion  : string;
       JavaPath     : string;
       Lock         : Boolean;
       EASY_PATHDIR   : string;
       EASY_PATHBASES : string;
       EASY_PORTS     : integer;
       EASY_BackupLame_Ini : string;
     public procedure Init;
     end;


function WMI_GetOsInfos:TOSInfos;
function WMI_GetDrivesInfos:TDrives;
function WMI_GetPerfOSProc():Integer;
function WMI_GetProcessInfos(aExeName:string):TProcessInfos;
procedure WMI_GetServicesSYMDS();
procedure WMI_GetServicesSYMDS_ONLY_EASY();
function WMI_ProcessIsRunning(aFullPathExeName:string):Boolean;

Var VGSE    : TVGSE; // Variable Globale du Soft et de l'Environnnement
    VGSYMDS : array of TSYMDSInfos;
    VGIB    : array of TDossierInfos;

implementation

Uses UCommun;

procedure TVGSE.Init;
begin
   ExePath     := ExtractFilePath(ParamStr(0));
   HostName    := '';
   Javaversion := '';
   JavaPath    := '';
   OSInfos     := WMI_GetOsInfos;
   Lock        := false;
   EASY_PATHDIR    := ExtractFilePath(ParamStr(0));
   EASY_PATHBASES  := ExtractFilePath(ParamStr(0));
   EASY_PORTS      := 30000;
end;

procedure TOSInfos.Init;
begin
    BuildNumber    :='';
    Caption        :='';
    CSDversion     :='';
    CSName         :='';
    FreePhysicalMemory     := '';
    FreeSpaceInPagingFiles := '';
    FreeVirtualMemory      := '';
    OSArchitecture         := '';
    Version                := '';
end;

procedure  TprocessInfos.Init;
begin
      PID                    := '';
      Priority               := '';
      PeakPageFileUsage      := '';
      PeakVirtualSize        := '';
      PeakWorkingSetSize     := '';
      ThreadCount            := '';
      KernelModeTime         := '';
      UserModeTime           := '';
      VirtualSize            := '';
      WorkingSetSize         := '';
      WriteOperationCount    := '';
      //-----------------------------
      PercentProcessorTime   := '';
      HandleCount            := '';
      WorkingSet             := '';
      WorkingSetPeak         := '';
      WorkingSetPrivate      := '';
      ElapsedTime            := '';
      PageFileBytesPeak      := '';
end;

procedure TDriveInfos.Init;
begin
     Compressed    :='';
     DeviceID      :='';
     FileSystem    :='';
     FreeSpace     :='';
     LastErrorCode :='';
     Size          :='';
end;


procedure TDossierInfos.SetSymDir;
var i:integer;
begin
    if ServiceName='' then exit;
    for i:=0 to length(VGSYMDS)-1 do
      begin
         if ServiceName=VGSYMDS[i].ServiceName then
           begin
             SymDir   := VGSYMDS[i].Directory;
             httpport := VGSYMDS[i].http;
           end;
      end;
end;


procedure TDossierInfos.Init;
begin
    SetLength(ListBases,0);
    ServiceName      :='';
    HTTPPort         :=0;
    SymDir           :='';
    PropertiesFile   :='';
    Version          :='';
    DatabaseFile     :='';
    BAS_IDENT        :=-1;
    BAS_GUID         :='';
    BAS_SENDER       :='';
    Nom              :='';
    ExternalID       :='';
    IsOk             := false;
    // TablesExclues    := '';
    RegistrationUrl  := '';
end;

procedure TSYMDSInfos.Init;
begin
    ServiceName := '';
    PathName    := '';
    ConfigFile  := '';
    Status      := '';
    ConfigDir   := '';
    StartMode   := '';
    ConfigFile  := '';
    Directory   := '';
    http        := 0;
    https       := 0;
    jmxhttp     := 0;
    jmxagent    := 0;
end;

procedure WMI_GetServicesSYMDS_ONLY_EASY();
var rows, instances, I, J: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
    wsp:string;
    ini : TIniFile;
    aStr : string;
    iIndex : integer;
    sValeur : string;
begin
    SetLength(VGSYMDS,0);
    CoInitialize(nil);
    try
      rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',QWMI_SERVICES_SYMDS_ONLY_EASY, WmiResults, instances, errstr) ;
      if (rows>0) then
         begin
              SetLength(VGSYMDS,instances);
              for i:=0 to instances-1 do
              begin

                   VGSYMDS[i].Init;
                   VGSYMDS[i].ServiceName :=  WmiResults[i+1, 1 ];
                   VGSYMDS[i].PathName    :=  WmiResults[i+1, 2 ];
                   VGSYMDS[i].StartMode   :=  WmiResults[i+1, 3 ];
                   VGSYMDS[i].Status      :=  WmiResults[i+1, 4 ];
                   VGSYMDS[i].State       :=  WmiResults[i+1, 5 ];
                   VGSYMDS[i].ConfigFile  :=  ReplaceText(Trim(Copy(VGSYMDS[i].PathName,
                                           Pos('" init "',VGSYMDS[i].PathName)+7,
                                           Length(VGSYMDS[i].PathName)
                                            )),'"','');
                   VGSYMDS[i].ConfigDir   := ExtractFileDir(VGSYMDS[i].ConfigFile);
                   VGSYMDS[i].Directory   := TDirectory.GetParent(ExcludeTrailingPathDelimiter(VGSYMDS[i].ConfigDir));
                   with TStringList.Create do
                      try
                         LoadFromFile(VGSYMDS[i].ConfigDir + '\symmetric-server.properties');
                         VGSYMDS[i].http     := StrToIntDef(Values['http.port'],0);
                         VGSYMDS[i].https    := StrToIntDef(Values['https.port'],0);
                         VGSYMDS[i].jmxhttp  := StrToIntDef(Values['jmx.http.port'],0);
                       Finally
                        Free
                     end;
                  // Le N° de Port de jmx.agent.port est dans le fichier sym_service.conf  maintenant

                   with TStringList.Create do
                      try
                         LoadFromFile(VGSYMDS[i].ConfigDir + '\sym_service.conf');
                         iIndex:=1;
                         while IndexOfName(Format('wrapper.java.additional.%d',[iIndex]))>-1 do
                            begin
                              // pos:=IndexOfName(Format('wrapper.java.additional.%d',[iIndex]));
                              sValeur := Values[Format('wrapper.java.additional.%d',[iIndex])];
                              if Pos('-Dcom.sun.management.jmxremote.port=',sValeur)>0
                                then
                                  begin
                                       VGSYMDS[i].jmxagent := StrToIntDef(
                                               Copy(sValeur,37,5),0);
                                  end;
                               inc(iIndex);
                            end;
                       Finally
                        Free
                     end;
                   // replissage des différentes bases...
              end;
         end;
    finally
      WmiResults := nil;
      CoUninitialize;
    end;
end;


procedure WMI_GetServicesSYMDS();
var rows, instances, I, J: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
    wsp:string;
    ini : TIniFile;
    aStr : string;
    iIndex : integer;
    sValeur : string;
begin
    SetLength(VGSYMDS,0);
    CoInitialize(nil);
    try
      rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',QWMI_SERVICES_SYMDS, WmiResults, instances, errstr) ;
      if (rows>0) then
         begin
              SetLength(VGSYMDS,instances);
              for i:=0 to instances-1 do
              begin

                   VGSYMDS[i].Init;
                   VGSYMDS[i].ServiceName :=  WmiResults[i+1, 1 ];
                   VGSYMDS[i].PathName    :=  WmiResults[i+1, 2 ];
                   VGSYMDS[i].StartMode   :=  WmiResults[i+1, 3 ];
                   VGSYMDS[i].Status      :=  WmiResults[i+1, 4 ];
                   VGSYMDS[i].State       :=  WmiResults[i+1, 5 ];
                   VGSYMDS[i].ConfigFile  :=  ReplaceText(Trim(Copy(VGSYMDS[i].PathName,
                                           Pos('" init "',VGSYMDS[i].PathName)+7,
                                           Length(VGSYMDS[i].PathName)
                                            )),'"','');
                   VGSYMDS[i].ConfigDir   := ExtractFileDir(VGSYMDS[i].ConfigFile);
                   VGSYMDS[i].Directory   := TDirectory.GetParent(ExcludeTrailingPathDelimiter(VGSYMDS[i].ConfigDir));
                   with TStringList.Create do
                      try
                         LoadFromFile(VGSYMDS[i].ConfigDir + '\symmetric-server.properties');
                         VGSYMDS[i].http     := StrToIntDef(Values['http.port'],0);
                         VGSYMDS[i].https    := StrToIntDef(Values['https.port'],0);
                         VGSYMDS[i].jmxhttp  := StrToIntDef(Values['jmx.http.port'],0);
                       Finally
                        Free
                     end;
                  // Le N° de Port de jmx.agent.port est dans le fichier sym_service.conf  maintenant

                   with TStringList.Create do
                      try
                         LoadFromFile(VGSYMDS[i].ConfigDir + '\sym_service.conf');
                         iIndex:=1;
                         while IndexOfName(Format('wrapper.java.additional.%d',[iIndex]))>-1 do
                            begin
                              // pos:=IndexOfName(Format('wrapper.java.additional.%d',[iIndex]));
                              sValeur := Values[Format('wrapper.java.additional.%d',[iIndex])];
                              if Pos('-Dcom.sun.management.jmxremote.port=',sValeur)>0
                                then
                                  begin
                                       VGSYMDS[i].jmxagent := StrToIntDef(
                                               Copy(sValeur,37,5),0);
                                  end;
                               inc(iIndex);
                            end;
                       Finally
                        Free
                     end;
                   // replissage des différentes bases...
              end;
         end;
    finally
      WmiResults := nil;
      CoUninitialize;
    end;
end;

function WMI_ProcessIsRunning(aFullPathExeName:string):Boolean;
var rows, instances: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
    vExeFile : string;
begin
    result :=false;
    CoInitialize(nil);
    try
       vExeFile := ExtractFileName(aFullPathExeName);
       rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',Format('SELECT ExecutablePath FROM Win32_Process WHERE Caption=''%s''',[vExeFile]), WmiResults, instances, errstr) ;
       if rows > 0 then
         begin
           result := UpperCase(WmiResults[1,1]) = UpperCase(aFullPathExeNAME);
         end;
    finally
      WmiResults := Nil ;
      CoUninitialize;
    end ;
end;

function WMI_GetPerfOSProc():Integer;
var rows, instances, I, J: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
begin
    result := 0;
    CoInitialize(nil);
    try
      try
         rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',QWMI_PERFOS, WmiResults, instances, errstr) ;
         if rows > 0 then
            begin
               result := StrToIntDef(WmiResults[1, 3 ],0);
            end;
      except
        // Rien pas grave...
      end;
    finally
      WmiResults := Nil ;
      CoUninitialize;
    end ;
end;


function WMI_GetProcessInfos(aExeName:string):TProcessInfos;
var rows, instances, I, J: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
begin
    result.Init;
    CoInitialize(nil);
    try
      try
         rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',Format(QWMI_PROC,[aExeName]), WmiResults, instances, errstr) ;
         if rows > 0 then
            begin
                 result.KernelModeTime         := WmiResults[1, 2 ];
                 result.PeakPageFileUsage      := WmiResults[1, 3 ];
                 result.PeakVirtualSize        := WmiResults[1, 4 ];
                 result.PeakWorkingSetSize     := WmiResults[1, 5 ];
                 result.Priority               := WmiResults[1, 6 ];
                 result.PID                    := WmiResults[1, 7 ];
                 result.ThreadCount            := WmiResults[1, 8 ];
                 result.UserModeTime           := WmiResults[1, 9 ];;
                 result.VirtualSize            := WmiResults[1, 10 ];;
                 result.WorkingSetSize         := WmiResults[1, 11 ];;
                 result.WriteOperationCount    := WmiResults[1, 12 ];
            end;
         //
         Sleep(5);
         //
         rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',
                    Format(QWMI_PERFPROC,['ibserver']), WmiResults, instances, errstr) ;
         if rows > 0 then
                  begin
                       result.ElapsedTime            := WmiResults[1, 1 ];
                       result.HandleCount            := WmiResults[1, 2 ];
                       // result.Name                   := WmiResults[1, 3 ];
                       result.PageFileBytesPeak      := WmiResults[1, 4 ];
                       result.PercentProcessorTime   := WmiResults[1, 5 ];
                       result.WorkingSet             := WmiResults[1, 6 ];
                       result.WorkingSetPeak         := WmiResults[1, 7 ];
                       result.WorkingSetPrivate      := WmiResults[1, 8 ];
                  end;
      except
        // Rien pas grave...
      end;
    finally
      WmiResults := Nil ;
      CoUninitialize;
    end ;
end;

function WMI_GetDrivesInfos:TDrives;
var rows, instances, I, J: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
begin
    SetLength(Result,0);
    try
        rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',QWMI_DRIVE, WmiResults, instances, errstr) ;
        if (rows>0) then
          begin
              SetLength(Result,instances);
              for i:=0 to instances-1 do
              begin
                   result[i].Init;
                   result[i].Compressed   := WmiResults[i+1, 1 ];
                   result[i].DeviceID     := WmiResults[i+1, 2 ];
                   result[i].FileSystem   := WmiResults[i+1, 3 ];
                   result[i].FreeSpace    := WmiResults[i+1, 4 ];
                   result[i].LastErrorCode:= WmiResults[i+1, 5 ];
                   result[i].Size         := WmiResults[i+1, 6 ];
              end;
          end;
    finally
        WmiResults := Nil ;
    end ;
end;

function WMI_GetOsInfos:TOSInfos;
var rows, instances, I, J: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
begin
    Result.Init;
    try
       rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',QWMI_OS, WmiResults, instances, errstr) ;
        if rows > 0 then
        begin
             result.BuildNumber            := WmiResults[1, 1];
             result.Caption                := WmiResults[1, 2];
             result.CSDVersion             := WmiResults[1, 3];
             result.CSName                 := WmiResults[1, 4];
             result.FreePhysicalMemory     := WmiResults[1, 5];
             result.FreeSpaceInPagingFiles := WmiResults[1, 6];
             result.FreeVirtualMemory      := WmiResults[1, 7];
             result.LastBootUptime         := WmiResults[1, 8];
             result.LocalDateTime          := WmiResults[1, 9];
             result.Version                := WmiResults[1, 10 ];
             // result.OSArchitecture         := WmiResults[1, 7];       <----
        end;
    finally
        WmiResults := Nil ;
    end ;
end;

begin
    VGSE.Init;
    // GetJavaInfos;
end.

