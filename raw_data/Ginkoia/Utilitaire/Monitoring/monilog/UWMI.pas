unit UWMI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, StdCtrls, magwmi, magsubs1, Registry,
  ShellAPi,inifiles,Tlhelp32, WinSvc,Forms;

Const QWMI_OS    = 'SELECT BuildNumber, Caption, CSDVersion, CSName, FreePhysicalMemory, FreeSpaceInPagingFiles, FreeVirtualMemory, ' +
                   ' LastBootUptime, LocalDateTime, LastBootUptime, LocalDateTime , Version ' +
                   ' FROM Win32_OperatingSystem';
      QWMI_DRIVE = 'SELECT Compressed, DeviceID, FileSystem, FreeSpace, LastErrorCode, Size FROM Win32_LogicalDisk Where DriveType=3';

      QWMI_PROC  =  'SELECT KernelModeTime, PeakPageFileUsage, PeakVirtualSize, PeakWorkingSetSize, Priority, ProcessID, ' +
                    'ThreadCount, UserModeTime, VirtualSize, WorkingSetSize, WriteOperationCount  FROM Win32_Process WHERE Caption=''%s''';

      QWMI_PERFPROC =  'SELECT ElapsedTime, HandleCount, Name, PageFileBytesPeak, PercentProcessorTime, WorkingSet, WorkingSetPeak %s FROM  Win32_PerfFormattedData_PerfProc_Process WHERE IDProcess=%s';


type TOSInfos = packed record
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

     TVGSE = packed record
       OSInfos : TOSInfos;
       ExePath : string;
     end;

function SecondsIdle: DWord;
function GetOsInfos:TOSInfos;
function GetDrivesInfos:TDrives;
function GetProcessInfos(aExeName:string;Const bquery:integer=2):TProcessInfos;
function SaveStrToFile(AfileName:string;astring:string):boolean;
function CreateUniqueGUIDFileName(sPath, sPrefix, sExtension : string) : string;
function GetTmpDir:string;

Var VGSE: TVGSE; // Variable Glabale du Soft et de l'Environnnement

implementation

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

function GetTmpDir:string;
var Path : Array[0..MAX_PATH] Of Char ;
begin
     // Récupération du répertoire temporaire (éventuellement, celui de l'application).
     If (GetTempPath(MAX_PATH,@Path)=0) Then
        StrCopy(@Path,PChar(ExtractFileDir(Application.ExeName)));
     result:=Path;
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

function CreateNewFileName(BaseFileName: String; Ext: String;
  AlwaysUseNumber: Boolean = True): String;
var
  DocIndex: Integer;
  FileName: String;
  FileNameFound: Boolean;
begin
  DocIndex := 1;
  Filenamefound := False;
  if not(AlwaysUseNumber) and (not(fileexists(BaseFilename + ext))) then
  begin
    Filename := BaseFilename + ext;
    FilenameFound := true;
  end;
  while not (FileNameFound) do
  begin
    filename := BaseFilename + inttostr(DocIndex) + Ext;
    if fileexists(filename) then
      inc(DocIndex)
    else
      FileNameFound := true;
  end;
  Result := filename;
end;


function GetProcessInfos(aExeName:string;Const bquery:integer=2):TProcessInfos;
var rows, instances, I, J: integer;
    WmiResults: T2DimStrArray;
    errstr:string;
    wsp:string;
begin
    result.Init;
    wsp:='';
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
              begin   // SELECT HandleCount, Name, PageFileBytesPeak, PercentProcessorTime, WorkingSet, WorkingSetPeak, WorkingSetPrivate FROM  Win32_PerfFormattedData_PerfProc_Process
                rows := MagWmiGetInfoEx ('.', 'root\CIMV2', '','',
                          Format(QWMI_PROC,[wsp,result.PID]), WmiResults, instances, errstr) ;
                if rows > 0 then
                  begin
                       result.ElapsedTime            := WmiResults[1, 1 ];
                       result.HandleCount            := WmiResults[1, 2 ];
                  //   result.Name                   := WmiResults[1, 3 ];
                       result.PageFileBytesPeak      := WmiResults[1, 4 ];
                       result.PercentProcessorTime   := WmiResults[1, 5 ];
                       result.WorkingSet             := WmiResults[1, 6 ];
                       result.WorkingSetPeak         := WmiResults[1, 7 ];
                       if Win32MajorVersion>=6 then result.WorkingSetPrivate := WmiResults[1, 8 ];
                  end;
                 //  if errstr<>'' then Log_Write('GetProcessInfos/Erreur(2):' + errstr, el_Debug);
              end;
          end;
    finally
        WmiResults := Nil ;
    end ;
end;

function GetDrivesInfos:TDrives;
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

function CreateUniqueGUIDFileName(sPath, sPrefix, sExtension : string) : string;
   var sFileName : string;
        Guid : TGUID;
begin
  Result := '';
  repeat
   SFileName := '';
   CreateGUID(Guid);
   SFileName := sPath + sPrefix + GUIDtoString(GUID);
   Result := ChangeFileExt(sFileName, sExtension)
  until not FileExists(Result);
end;

function SaveStrToFile(AfileName:string;astring:string):boolean;
var MyText : TStringlist;
    fs     : TFileStream;
begin
  MyText := TStringlist.create;
  fs     := TFileStream.Create(AfileName,fmCreate);
  try
    try
      MyText.Text:=astring;
      MyText.SaveToStream(fs, TEncoding.ANSI);
      fs.Size := fs.Size - Length(System.sLineBreak);
      result:=true;
    Except
      result:=false;
    end;
  finally
    MyText.Free;
    fs.Free;
  end;
end;

function GetOsInfos:TOSInfos;
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

function SecondsIdle: DWord;
var
   liInfo: TLastInputInfo;
begin
   liInfo.cbSize := SizeOf(TLastInputInfo) ;
   GetLastInputInfo(liInfo) ;
   Result := (GetTickCount - liInfo.dwTime) DIV 1000;
end;

begin
     VGSE.ExePath:=ExtractFilePath(ParamStr(0));
     FormatSettings.DecimalSeparator  := '.';
     SetCurrentDir(ExtractFileDir(ParamStr(0)));
end.

