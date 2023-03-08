unit UWMI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, StdCtrls, magwmi, magsubs1, Registry,
  ShellAPi,inifiles,Tlhelp32, WinSvc,Forms,StrUtils, IOUtils, Winapi.ActiveX;

Const QWMI_OS    = 'SELECT BuildNumber, Caption, CSDVersion, CSName, FreePhysicalMemory, FreeSpaceInPagingFiles, FreeVirtualMemory, ' +
                   ' LastBootUptime, LocalDateTime, LastBootUptime, LocalDateTime , ProductType, Version ' +
                   ' FROM Win32_OperatingSystem';
      QWMI_DRIVE = 'SELECT Compressed, DeviceID, FileSystem, FreeSpace, LastErrorCode, Size FROM Win32_LogicalDisk Where DriveType=3';

      QWMI_PROCESSORS = 'SELECT NumberOfLogicalProcessors FROM Win32_Processor';  // Une seule fois cette requete !

      QWMI_PROC  =  'SELECT KernelModeTime, PeakPageFileUsage, PeakVirtualSize, PeakWorkingSetSize, Priority, ProcessID, ' +
                    'ThreadCount, UserModeTime, VirtualSize, WorkingSetSize, WriteOperationCount  FROM Win32_Process WHERE Caption=''%s''';

      QWMI_PERFPROC =  'SELECT ElapsedTime, HandleCount, PercentProcessorTime, WorkingSet, WorkingSetPeak %s FROM  Win32_PerfFormattedData_PerfProc_Process WHERE IDProcess=%s';

      QWMI_SERVICES_EASY = 'SELECT Name, PathName, ProcessId,  StartMode, State, Status FROM Win32_Service WHERE Description=''Database Synchronization'' AND StartMode<>''Disabled'' AND Name=''EASY'' ';

      QWMI_SERVICE = 'SELECT Name, PathName, StartMode, State, Status FROM Win32_Service WHERE Name=''%s'' ';

      QWMI_PID = 'SELECT Caption, CommandLine, CreationDate, ExecutablePath, ProcessId FROM Win32_Process WHERE ProcessID=%d';

      QWMI_JAVAS = 'SELECT Caption, CommandLine, CreationDate, ExecutablePath, ProcessId FROM Win32_Process WHERE Caption=''%s'' ';

      LOGON_WITH_PROFILE = $00000001;


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
      ProductType    : string;
      OSArchitecture : string;
      Version        : string;
      NbProcessors   : integer;
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

     TProcessPIDInfos = packed record
        Caption        : string;
        CommandLine    : string;
        CreationDate   : TDateTime;
        ExecutablePath : string;
        ProcessId      : integer;
      public
        procedure Init;
      end;

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

     TArrayProcessInfos = array of TprocessInfos;

     TGroupProcessInfos = packed record
        NbProcess    : Integer;
        // Le Tableau des Process
        ArrayProcess : TArrayProcessInfos;
        // La Somme (pas tous les champs)
        SumProcess   : TprocessInfos;
     private
        procedure Init;
        procedure CalculSum;
     end;

     TServiceInfos = packed record
        ServiceName    : string;
        StartMode      : string;
        State          : string;
        Status         : string;
      private
        procedure Init;
     end;

     TEASYInfos = packed record
        ServiceName    : string;
        PathName       : String;
        ConfigDir      : string;
        ConfigFile     : String;
        StartMode      : string;
        State          : string;
        Status         : string;
        ProcessID      : integer;
        Directory      : string;
        Version        : string;
        http           : integer;
        https          : integer;
        jmxhttp        : integer;
        jmxagent       : integer;
        JavaPath        : string;
        JavaFullVersion : string;
        PropertiesFile : TFileName;
        registration_url : string;
        group_id         : string;
        external_id      : string;
     private
        procedure Init;
     end;

     {
     TBase = packed record
        BAS_SENDER  : string;
        SYM_NODE    : string;   // le sym_node est presque comme le bas_node mais en plus cour
                                //  serveur_xxxxxx_aaaa_yyy    => s_xxxxxx_aaaa_yyy
                                //  portablez_xxxxxx_aaaa_yyy  => pz_xxxxxx_aaaa_yyy
        BAS_IDENT   : Integer;
        BAS_GUID    : string;
     end;
     TBases = array of TBase;
     }
     {
     TDossierInfos = packed record
        ServiceName      : string;
        HTTPPort         : integer;
        SymDir           : string;
        DatabaseFile     : string;
        BAS_SENDER       : string;
        BAS_IDENT        : integer;
        BAS_GUID         : string;
        ExternalID       : string;
        Version          : string;
        Nom              : string;
        Isok             : boolean;
        TablesExclues    : string;
        RegistrationUrl  : string;
        ListBases        : TBases;
     public
        procedure Init;
        procedure SetSymDir;
     end;
     }
     TVGSE = packed record
       OSInfos      : TOSInfos;
       PublicIP     : string;  // IpPublic sur Internet
       ExePath      : string;
       Javaversion  : string;
       JavaPath     : string;
       Lock         : Boolean;
       EASY_PATHDIR   : string;
       EASY_PATHBASES : string;
       EASY_PORTS     : integer;
       Base0          : string;
       AttentionBase0 : Boolean;
     public procedure Init;
     end;


procedure GetPropertiesFile(var aEASY:TEASYInfos);
function WMI_MyJavaRun(aPathJava:string):boolean;
function  WMI_GetOsInfos:TOSInfos;
function  WMI_GetDrivesInfos:TDrives;
function  WMI_GetProcessInfos(aExeName:string;Const bquery:integer=2):TProcessInfos;
function  WMI_GetGroupProcessInfos(aExeName:string):TGroupProcessInfos;
function  WMI_GetServicesEASY():TEASYInfos;
function  WMI_GetPIDInfos(aPID :Integer ):TProcessPIDInfos;
function  WMI_GetService(aName:string):TServiceInfos;
procedure GetJavaInfos;
procedure GetBase0;
function CreateProcessWithLogonW(lpUsername, lpDomain, lpPassword: PWideChar;
  dwLogonFlags: dword; lpApplicationName, lpCommandLine: PWideChar;
  dwCreationFlags: dword; lpEnvironment: pointer;
  lpCurrentDirectory: PWideChar; lpStartupInfo: PStartUpInfoW;
  lpProcessInfo: PProcessInformation): boolean; stdcall;
  external 'advapi32.dll';
function Runas(USER,DOMAIN,PW,COMMANDLINE,PARAMS:PWideChar):boolean;
function FileVersion(const FileName: TFileName): String;
procedure RemoveDeadIcons;
function FileSize(const APath: string): int64;
Var VGSE    : TVGSE; // Variable Globale du Soft et de l'Environnnement

implementation

function FileSize(const APath: string): int64;
var Sr : TSearchRec;
begin
   {$WARN SYMBOL_PLATFORM OFF}
   if FindFirst(APath,faAnyFile,Sr)=0 then
    try
      Result := Int64(Sr.FindData.nFileSizeHigh) shl 32 + Sr.FindData.nFileSizeLow;
    finally
      FindClose(Sr);
    end
    else
      Result := 0;
   {$WARN SYMBOL_PLATFORM ON}
end;

function FileVersion(const FileName: TFileName): String;
var
  VerInfoSize: Cardinal;
  VerValueSize: Cardinal;
  Dummy: Cardinal;
  PVerInfo: Pointer;
  PVerValue: PVSFixedFileInfo;
begin
  Result := '';
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  GetMem(PVerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, PVerInfo) then
      if VerQueryValue(PVerInfo, '\', Pointer(PVerValue), VerValueSize) then
        with PVerValue^ do
          Result := Format('%d.%d.%d.%d', [
            HiWord(dwFileVersionMS), //Major
            LoWord(dwFileVersionMS), //Minor
            HiWord(dwFileVersionLS), //Release
            LoWord(dwFileVersionLS)]); //Build
  finally
    FreeMem(PVerInfo, VerInfoSize);
  end;
end;

function Runas(USER,DOMAIN,PW,COMMANDLINE,PARAMS:PWideChar):boolean;
var
  si : TStartupInfoW;
  pif : TProcessInformation;

begin

  ZeroMemory(@si,sizeof(si));
  si.cb := sizeof(si);
  si.dwFlags := STARTF_USESHOWWINDOW;
  si.wShowWindow := 1;

  if DOMAIN <> 'nil' then
  begin
    result := CreateProcessWithLogonW(USER,DOMAIN,
      PW,LOGON_WITH_PROFILE,
      COMMANDLINE, PARAMS,
      CREATE_DEFAULT_ERROR_MODE,nil,nil,@si,@pif);
  end
  else
  begin
     result := CreateProcessWithLogonW(USER,nil,
      PW,LOGON_WITH_PROFILE,
      COMMANDLINE, PARAMS,
      CREATE_DEFAULT_ERROR_MODE,nil,nil,@si,@pif);
  end;

end;

procedure GetBase0();
VAR reg  : TRegistry;
   appINI : TIniFile;
   vIniBase0 :string;
begin
  reg   := TRegistry.Create(KEY_READ);
  TRY
    reg.RootKey  := HKEY_LOCAL_MACHINE;
    reg.OpenKey('SOFTWARE\Algol\Ginkoia', False);
    VGSE.Base0 := reg.ReadString('Base0');
  FINALLY
    reg.closekey;
    reg.free;
  END;
  // si il y a BASE0 dans le launcher.INI alors il prend le priorité (HACK pour MB)
  appINI     := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    // Attention : HACK pour Mathieu BOUDIN son installation n'est pas compatible "BASE0"
    vIniBase0   := appINI.Readstring('LauncherEASY','Base0',VGSE.Base0);
    if (UpperCase(vIniBase0)<>UpperCase(VGSE.Base0))
      then VGSE.AttentionBase0 := true
      else VGSE.AttentionBase0 := false;
    VGSE.Base0 := vIniBase0;
  finally
    appINI.Free;
  end;
end;

procedure TVGSE.Init;
begin
   ExePath     := ExtractFilePath(ParamStr(0));
   Javaversion := '';
   JavaPath    := '';
   OSInfos     := WMI_GetOsInfos;
   Lock        := false;
   EASY_PATHDIR    := ExtractFilePath(ParamStr(0));
   EASY_PATHBASES  := ExtractFilePath(ParamStr(0));
   EASY_PORTS      := 30000;
   Base0           := '';
   AttentionBase0  := true;
end;

procedure TProcessPIDInfos.Init;
begin
     Self.Caption        :='';
     Self.CommandLine    :='';
     Self.CreationDate   := 0;
     Self.ExecutablePath := '';
     Self.ProcessId      := 0;
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
    ProductType             := '';
    Version                := '';
end;

procedure  TServiceInfos.Init;
begin
    ServiceName := '';
    StartMode   :='';
    State       := '';
    Status      := '';
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

procedure TGroupProcessInfos.Init;
begin
  NbProcess := 0;
  SetLength(ArrayProcess,0);
  SumProcess.Init;
end;

procedure TGroupProcessInfos.CalculSum;
var i:Integer;
begin
  NbProcess := High(ArrayProcess);
  for I := Low(ArrayProcess) to High(ArrayProcess) do
    begin
       SumProcess.ThreadCount := IntToStr(StrToIntDef(SumProcess.ThreadCount,0)  + StrToIntDef(ArrayProcess[i].ThreadCount,0));
       SumProcess.VirtualSize := IntToStr(StrToIntDef(SumProcess.VirtualSize,0)  + StrToIntDef(ArrayProcess[i].VirtualSize,0));
       SumProcess.WorkingSetSize := IntToStr(StrToIntDef(SumProcess.WorkingSetSize,0)  + StrToIntDef(ArrayProcess[i].WorkingSetSize,0));
//       SumProcess.WriteOperationCount :=
    end;
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


{
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
    DatabaseFile     :='';
    Version          :='';
    BAS_IDENT        :=-1;
    BAS_GUID         :='';
    BAS_SENDER       :='';
    Nom              :='';
    ExternalID       :='';
    IsOk             := false;
    TablesExclues    := '';
    RegistrationUrl  := '';
end;
}

procedure TEASYInfos.Init;
begin
    ServiceName := '';
    PathName    := '';
    ConfigFile  := '';
    Status      := '';
    ConfigDir   := '';
    StartMode   := '';
    ConfigFile  := '';
    Directory   := '';
    JavaPath    := '';
    JavaFullVersion := '';
    http        := 0;
    https       := 0;
    jmxhttp     := 0;
    jmxagent    := 0;
    group_id    := '';
    external_id := '';
end;

procedure RemoveDeadIcons;
var
  wnd : cardinal;
  rec : TRect;
  w,h : integer;
  x,y : integer;
begin
    wnd := FindWindow('Shell_TrayWnd', nil);
    wnd := FindWindowEx(wnd, 0, 'TrayNotifyWnd', nil);
    wnd := FindWindowEx(wnd, 0, 'SysPager', nil);
    wnd := FindWindowEx(wnd, 0, 'ToolbarWindow32', nil);
    windows.GetClientRect(wnd, rec);
    w := GetSystemMetrics(sm_cxsmicon);
    h := GetSystemMetrics(sm_cysmicon);
    y := w shr 1;
    while y < rec.Bottom do begin // while y < height of tray
      x := h shr 1;                                        // initial x position of mouse - half of width of icon
      while x < rec.Right do begin // while x < width of tray
                   SendMessage(wnd, wm_mousemove, 0, y shl 16 or x); // simulate moving mouse over an icon
                   x := x + w; // add width of icon to x position
      end;
      y := y + h; // add height of icon to y position
    end;
end;

procedure GetPropertiesFile(var aEASY:TEASYInfos);
var // i,j:integer;
    searchResult : TSearchRec;
    bFound : boolean;
begin
    SetCurrentDir(AEasy.Directory + '\engines');
    bFound:=FindFirst('*.properties', faAnyFile, searchResult) = 0;
    While bFound do
       begin
          with TStringList.Create do
          try
            aEASY.PropertiesFile := GetCurrentDir + '\' + searchResult.Name;
            LoadFromFile(aEASY.PropertiesFile);
            aEASY.registration_url := StringReplace(Values['registration.url'],'\','',[rfReplaceAll]);
            aEASY.group_id    := Values['group.id'];
            aEASY.external_id := Values['external.id'];
          finally
              Free;
          end;
          bFound := FindNext(searchResult) = 0;
        end;
     FindClose(searchResult);
end;

function WMI_GetService(aName:string):TServiceInfos;
var rows, instances: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
begin
    result.Init;
    try
    CoInitialize(nil);
    rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',Format(QWMI_SERVICE,[aName]), WmiResults, instances, errstr) ;
    if (rows>0) then
       begin
            if instances=1 then
            begin
               result.ServiceName :=  WmiResults[1, 1 ];
               result.StartMode   :=  WmiResults[1, 3 ];
               result.Status      :=  WmiResults[1, 4 ];
               result.State       :=  WmiResults[1, 5 ];
            end;
       end;
    finally
      CoUninitialize;
    end;
end;

function WMI_GetServicesEASY:TEASYInfos;
var rows, instances: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
//    aStr : string;
    iIndex : integer;
    sValeur : string;
    vJavaVersion : string;
begin
    result.Init;
    try
    CoInitialize(nil);
    rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',QWMI_SERVICES_EASY, WmiResults, instances, errstr) ;
    if (rows>0) then
       begin
            if instances=1 then
            begin
                 result.ServiceName :=  WmiResults[1, 1 ];
                 result.PathName    :=  WmiResults[1, 2 ];
                 result.ProcessID   :=  StrToIntDef(WmiResults[1, 3 ],0);
                 result.StartMode   :=  WmiResults[1, 4 ];
                 result.Status      :=  WmiResults[1, 5 ];
                 result.State       :=  WmiResults[1, 6 ];
                 result.ConfigFile  :=  ReplaceText(Trim(Copy(result.PathName,
                                         Pos('" init "',result.PathName)+7,
                                         Length(result.PathName)
                                          )),'"','');
                 result.ConfigDir   := ExtractFileDir(result.ConfigFile);
                 result.Directory   := TDirectory.GetParent(ExcludeTrailingPathDelimiter(result.ConfigDir));
                 with TStringList.Create do
                    try
                       LoadFromFile(result.ConfigDir + '\symmetric-server.properties');
                       result.http     := StrToIntDef(Values['http.port'],0);
                       result.https    := StrToIntDef(Values['https.port'],0);
                       result.jmxhttp  := StrToIntDef(Values['jmx.http.port'],0);
                     Finally
                      Free
                   end;
                // Le N° de Port de jmx.agent.port est dans le fichier sym_service.conf  maintenant

                 with TStringList.Create do
                   try
                       LoadFromFile(result.ConfigDir + '\sym_service.conf');
                       iIndex:=1;
                       result.JavaPath := Values['wrapper.java.command'];
                       vJavaVersion := StringReplace(result.JavaPath,'\bin\java','',[rfReplaceAll,rfIgnoreCase]);
                       result.JavaFullVersion := ExtractFileName(vJavaVersion);
                       while IndexOfName(Format('wrapper.java.additional.%d',[iIndex]))>-1 do
                          begin
                            // pos:=IndexOfName(Format('wrapper.java.additional.%d',[iIndex]));
                            sValeur := Values[Format('wrapper.java.additional.%d',[iIndex])];
                            if Pos('-Dcom.sun.management.jmxremote.port=',sValeur)>0
                              then
                                begin
                                     result.jmxagent := StrToIntDef(
                                             Copy(sValeur,37,5),0);
                                end;
                             inc(iIndex);
                          end;
                     Finally
                      Free
                   end;

                GetPropertiesFile(result);

                 // replissage des différentes bases...
            end;
       end;
    finally
      CoUninitialize;
    end;
end;

function WMI_MyJavaRun(aPathJava:string):boolean;
var rows, instances: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
    i:Integer;
begin
  Result := false;
  CoInitialize(nil);
  try
    rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',Format(QWMI_JAVAS,['java.exe']), WmiResults, instances, errstr);
    if rows>0 then
       begin
         for i:=1 to instances do
            begin
               if (UpperCase(aPathJava)=UpperCase(WmiResults[i, 4 ]))
                 then
                   begin
                     result:=True;
                     exit;
                   end;
            end;
        end;
  finally
      WmiResults := Nil ;
      CoUninitialize;
  end;
end;

function WMI_GetPIDInfos(aPID :Integer ):TProcessPIDInfos;
var rows, instances: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
    i:Integer;
begin
    result.Init;
    CoInitialize(nil);

    try
       rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',Format(QWMI_PID,[aPID]), WmiResults, instances, errstr);
       if rows>0 then
        begin
           for i:=1 to instances do
            begin
               result.Caption         := WmiResults[i, 1 ];
               result.CommandLine     := WmiResults[i, 2 ];
               result.CreationDate    := StrToDateTimeDef(WmiResults[i, 3 ],0);
               result.ExecutablePath  := WmiResults[i, 4 ];
               result.ProcessId       := StrToIntDef(WmiResults[i, 5 ],0);
               {
               'Caption'
               'CommandLine'
               'CreatDate'
               'CreatDate'
               'ProcessId'


               Result.ArrayProcess[i-1].KernelModeTime         := WmiResults[i, 2 ];
               Result.ArrayProcess[i-1].PeakPageFileUsage      := WmiResults[i, 3 ];
               Result.ArrayProcess[i-1].PeakVirtualSize        := WmiResults[i, 4 ];
               Result.ArrayProcess[i-1].PeakWorkingSetSize     := WmiResults[i, 5 ];
               Result.ArrayProcess[i-1].Priority               := WmiResults[i, 6 ];
               Result.ArrayProcess[i-1].PID                    := WmiResults[i, 7 ];
               Result.ArrayProcess[i-1].ThreadCount            := WmiResults[i, 8 ];
               Result.ArrayProcess[i-1].UserModeTime           := WmiResults[i, 9 ];
               Result.ArrayProcess[i-1].VirtualSize            := WmiResults[i, 10 ];
               Result.ArrayProcess[i-1].WorkingSetSize         := WmiResults[i, 11 ];
               Result.ArrayProcess[i-1].WriteOperationCount    := WmiResults[i, 12 ];
               }
            end;
        end;
    finally
        WmiResults := Nil ;
        CoUninitialize;
    end;
end;




function WMI_GetGroupProcessInfos(aExeName:string):TGroupProcessInfos;
var rows, instances: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
    wsp:string;
    i:Integer;
begin
    result.Init;
    wsp:='';
    CoInitialize(nil);

    try
       If Win32MajorVersion>=6 then wsp:=', WorkingSetPrivate';
       rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',Format(QWMI_PROC,[aExeName]), WmiResults, instances, errstr);
       if rows>0 then
        begin
           result.NbProcess := instances;
           SetLength(Result.ArrayProcess,instances);
           for i:=1 to instances do
            begin
               Result.ArrayProcess[i-1].KernelModeTime         := WmiResults[i, 2 ];
               Result.ArrayProcess[i-1].PeakPageFileUsage      := WmiResults[i, 3 ];
               Result.ArrayProcess[i-1].PeakVirtualSize        := WmiResults[i, 4 ];
               Result.ArrayProcess[i-1].PeakWorkingSetSize     := WmiResults[i, 5 ];
               Result.ArrayProcess[i-1].Priority               := WmiResults[i, 6 ];
               Result.ArrayProcess[i-1].PID                    := WmiResults[i, 7 ];
               Result.ArrayProcess[i-1].ThreadCount            := WmiResults[i, 8 ];
               Result.ArrayProcess[i-1].UserModeTime           := WmiResults[i, 9 ];
               Result.ArrayProcess[i-1].VirtualSize            := WmiResults[i, 10 ];
               Result.ArrayProcess[i-1].WorkingSetSize         := WmiResults[i, 11 ];
               Result.ArrayProcess[i-1].WriteOperationCount    := WmiResults[i, 12 ];
            end;
        end;
        Result.CalculSum;
    finally
        WmiResults := Nil ;
        CoUninitialize;
    end;
end;


function WMI_GetProcessInfos(aExeName:string;Const bquery:integer=2):TProcessInfos;
var rows, instances: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
    wsp:string;
begin
    result.Init;
    wsp:='';
    CoInitialize(nil);
    try
        If Win32MajorVersion>=6 then wsp:=', WorkingSetPrivate';
        if (bquery>=1) then
          begin
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
            // if errstr<>'' then Log_Write('GetProcessInfos/Erreur(1):' + errstr, el_Debug);
            // Parfois cette requete renvoie rien...
            if (bquery=2) and (result.PID<>'') then
              begin
                rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',
                          Format(QWMI_PERFPROC,[wsp,result.PID]), WmiResults, instances, errstr) ;
                if rows > 0 then
                  begin
                       result.ElapsedTime            := WmiResults[1, 2 ];
                       result.HandleCount            := WmiResults[1, 3 ];
                       result.PercentProcessorTime   := WmiResults[1, 4 ];
                       result.WorkingSet             := WmiResults[1, 5 ];
                       result.WorkingSetPeak         := WmiResults[1, 6 ];
                       if Win32MajorVersion>=6 then result.WorkingSetPrivate := WmiResults[1, 7 ];
                  end;
                 //  if errstr<>'' then Log_Write('GetProcessInfos/Erreur(2):' + errstr, el_Debug);
              end;
          end;
    finally
        WmiResults := Nil ;
        CoUninitialize;
    end;
end;

function WMI_GetDrivesInfos:TDrives;
var rows, instances, i: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
begin
    SetLength(Result,0);
    CoInitialize(nil);
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
        CoUninitialize;
    end ;
end;

function WMI_GetOsInfos:TOSInfos;
var rows, instances: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
begin
    Result.Init;
    CoInitialize(nil);
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
             result.ProductType            := WmiResults[1, 10];
             result.Version                := WmiResults[1, 11 ];
        end;

       rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',QWMI_PROCESSORS, WmiResults, instances, errstr) ;
       if rows > 0 then
        begin
             result.NbProcessors := StrToIntDef(WmiResults[1, 2],1);
        end;

    finally
        WmiResults := Nil ;
        CoUninitialize;
    end ;
end;

procedure GetJavaInfos;
const REGJAVA = '\Software\JavaSoft\Java Runtime Environment';
var Registre          : TRegistry;
begin
  Registre      := TRegistry.Create(KEY_READ OR KEY_WOW64_64KEY);
  try
    Registre.RootKey  := HKEY_LOCAL_MACHINE;
    if Registre.OpenKey(REGJAVA, False) then
      begin
        VGSE.Javaversion := Registre.ReadString('CurrentVersion');
        if Registre.OpenKey(Format('%s\%s',[REGJAVA,VGSE.Javaversion]), False) then
          begin
              VGSE.JavaPath  := Registre.ReadString('JavaHome');
          end;
      end;
  finally
    Registre.Free();
  end;

  if VGSE.JavaPath='' then
    begin
        Registre      := TRegistry.Create(KEY_READ OR KEY_WOW64_32KEY);
        try
          Registre.RootKey  := HKEY_LOCAL_MACHINE;
          if Registre.OpenKey(REGJAVA, False) then
            begin
              VGSE.Javaversion := Registre.ReadString('CurrentVersion');
              if Registre.OpenKey(Format('%s\%s',[REGJAVA,VGSE.Javaversion]), False) then
                begin
                    VGSE.JavaPath  := Registre.ReadString('JavaHome');
                end;
            end;
        finally
          Registre.Free();
        end;
    end;
end;

begin
    VGSE.Init;
    GetBase0;
end.

