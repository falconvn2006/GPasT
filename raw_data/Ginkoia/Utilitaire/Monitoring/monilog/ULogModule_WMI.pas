unit ULogModule_WMI;

interface

uses
   Classes, IdIcmpClient, Math, UlogModule, SysUtils, ULog, UWMI;

type
   TLogModule_WMI = class(TLogModule)
   private
     FRunning : boolean;
     FStatus  : string;
     FOnAfterTest: TNotifyEvent;
     FServname : string;
     FPath : string;
   protected
    procedure DoTest; override;
   public
     constructor Create(Servname: string; AFreq:integer; ANotifyEvent: TNotifyEvent);
     destructor Destroy; override;
     property Running: boolean read FRunning write FRunning;
     property Path: string read FPath write FPath;
   end;

implementation

uses
   SyncObjs,GestionLog;

{ TPingThread }

constructor TLogModule_WMI.Create(Servname: string;  AFreq:integer; ANotifyEvent: TNotifyEvent);
begin
   inherited;
   FServname := Servname;
   FModule   := 'WMI';
   FActiveX  := true;
end;

destructor TLogModule_WMI.Destroy;
begin
   inherited;
end;

procedure TLogModule_WMI.DoTest;
const CLimit = 10737418240;
var FIBServer : TprocessInfos;
    FLame     : string;
    FDrives   : TDrives;
    i:integer;
    // AWPost    : TWPost;
    FreeLevel:TLogLevel;
    LastElevel:TLogLevel;
begin
   try
     try
        FStatus := 'Running';
        FDrives   := GetDrivesinfos;
        for i:=0 to High(FDrives) do
        begin
             FreeLevel := logError;           // 6
             if (StrToInt64(FDrives[i].FreeSpace)>(CLimit div 2))
               then FreeLevel := logWarning;  // 5
             if (StrToInt64(FDrives[i].FreeSpace)>CLimit)
               then FreeLevel := logInfo;     // 3
             Log.Log(FServname,'WMI/DRIVE','',FDrives[i].DeviceID,'Free',FDrives[i].FreeSpace,FreeLevel,true);
             //
             Log.Log(FServname,'WMI/DRIVE','',FDrives[i].DeviceID,'Size',FDrives[i].Size,logInfo,true);
             LastElevel:=logInfo;
             if (FDrives[i].LastErrorCode<>'NULL')
               then LastElevel:=LogEmergency;  // 8
             Log.Log(FServname,'WMI/DRIVE','',FDrives[i].DeviceID,'LastErrorCode',FDrives[i].LastErrorCode,lastELevel,true);
        end;
        //---------------------------------------------
        FIBServer := GetProcessInfos('ibserver.exe',1);
        //---------------------------------------------
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','pid'     , FIBServer.PID                 , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','priority', FIBServer.Priority            , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','ppfu'    , FIBServer.PeakPageFileUsage   , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','pvs'     , FIBServer.PeakVirtualSize     , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','pwss'    , FIBServer.PeakWorkingSetSize  , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','tc'      , FIBServer.ThreadCount         , logInfo, true);

        Log.Log(FServname,'WMI/PROC','','ibserver.exe','tc'      , FIBServer.ThreadCount         , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','vs'      , FIBServer.VirtualSize         , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','wss'     , FIBServer.WorkingSetSize      , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','woc'     , FIBServer.WriteOperationCount , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','hc'      , FIBServer.HandleCount         , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','pfbp'    , FIBServer.PageFileBytesPeak   , logInfo, true);

        Log.Log(FServname,'WMI/PROC','','ibserver.exe','ppt'     , FIBServer.PercentProcessorTime, logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','ws'      , FIBServer.WorkingSet          , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','wspk'    , FIBServer.WorkingSetPeak      , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','wspv'    , FIBServer.WorkingSetPrivate   , logInfo, true);

        Log.Log(FServname,'WMI/PROC','','ibserver.exe','umt'     , FIBServer.UserModeTime        , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','et'      , FIBServer.ElapsedTime         , logInfo, true);
        Log.Log(FServname,'WMI/PROC','','ibserver.exe','kmt'     , FIBServer.KernelModeTime      , logInfo, true);
        //*******************************************
        // AWPost := TWPost.Create('',str,nil);
        //*******************************************


      except
      //
      end;
   finally
     FStatus := 'Not Running';
     FRunning := false;
   end;
end;

end.
