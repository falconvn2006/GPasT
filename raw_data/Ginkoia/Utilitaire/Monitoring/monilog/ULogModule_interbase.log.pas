unit ULogModule_interbase.log;

interface

uses
   Classes, IdIcmpClient, Math, UlogModule, ULog, Sysutils,DateUtils;

type
   TIbLogDatas = record
      dDate    : TDateTime;
      sType    : string;
      sMessage : string;
   end;
   TLogModule_interbase_Log = class(TLogModule)
   private
     FDatas   : TIbLogDatas;
     FLastLog : TdateTime;
     FRunning: boolean;
     FOnAfterTest: TNotifyEvent;
     FServname  : string;
   strict private
     FPosLine : integer;
     FFileList: TStrings;
     procedure Traitement_Fichier;
     procedure Analyse_Lignes;
   protected
    procedure DoTest; override;
   public
     constructor Create(AServname:string; AFreq:integer; ANotifyEvent: TNotifyEvent);
     destructor Destroy; override;
     property Running : boolean   read FRunning write FRunning;
     property LastLog : TDateTime read FLastLog write FLastLog;
   end;

implementation

uses
   SyncObjs,UCommun;

{ TLogModule_ICMP }

constructor TLogModule_interbase_Log.Create(AServname:string; AFreq:integer; ANotifyEvent: TNotifyEvent);
begin
   inherited;
   // On Ping toujours depuis un 'Localhost'
   FPosLine  := 0;
   FModule   := 'INTERBASE.LOG';
   FServname := AServname;
   FLastLog  :=  EncodeDateTime(2014, 1, 1, 0, 0, 0, 000);
end;

destructor TLogModule_interbase_Log.Destroy;
begin
//   FIcmpClient.DisposeOf;
   inherited;
end;


procedure TLogModule_interbase_Log.Traitement_Fichier;
Const LogFile='C:\Embarcadero\InterBase\interbase.log';
Const LimitFile = 2000;  // Correspond à 2 Mo
var vFileStream : TFileStream;
begin
    // S'il est trop gros on le renomme
    try
      if ((getFileSize(LogFile) div 1024)>2000) then
         begin
            if RenameFile(LogFile,LogFile+'.'+FormatDateTime('yyyymmdd',Now()))
              then
                begin
                     Log.Log(FServname,Module,'','interbase.log','Renommage','OK',logInfo,true);
                     FPosLine:=0;
                end
              else Log.Log(FServname,Module,'','interbase.log','Renommage','KO',logError,true);
         end;
      finally
    end;
    if not(Assigned(FFileList))
      then FFileList := TStringList.Create
      else FFileList.Clear;
    try
      try
        vFileStream := TFileStream.Create(LogFile, fmOpenRead or fmShareDenyNone);
        FFileList.LoadFromStream(vFileStream);
        Analyse_Lignes;
      Except on E:Exception do
        Log.Log(FServname,Module,'','interbase.log','Exception',E.Message,logError,true);
      end;
    finally
      vFileStream.Free;
    end;
end;


procedure TLogModule_interbase_Log.DoTest;
var ABuffer: String;
begin
   try
    try
       FRunning := true;
       Traitement_Fichier;
    except On E:Exception do
      Log.Log(FServname,Module,'','interbase.log','status',E.Message,logError,true);
    end;
   finally
     FStatus := 'Not Running';
     FRunning := false;
   end;
end;


procedure TLogModule_interbase_Log.Analyse_Lignes;
var i,j:integer;
    s:string;
    astrdate:string;
    syear,smonth:string;
    iyear:integer;
    iMonth:integer;
    sday:string;
    iday:integer;
    stime:string;
    FS: TFormatSettings;
    ouvert:boolean;
    Host:string;
    Infos:string;
begin
    FS := TFormatSettings.Create('en-US');
    ouvert:=false;
    Infos:='';
    For i:=FPosLine to FFileList.Count-1 do
      begin
           s:=FFileList.Strings[i];
           if (s='') and (ouvert) then
              begin
                 ouvert:=false;
                 // ----------------   FDatas.Add(Format('Infos : %s',[infos]));
                 FDatas.sMessage:=infos;
                 if (FDatas.dDate>=LastLog) then
                  begin
                     Log.LogDt(FDatas.dDate,FServname, Module,'','','',FDatas.sMessage,logInfo,true);
                     LastLog:=FDatas.dDate;
                     // On se positionne sur le
                     FPosLine:=i;
                  end;
              end;
           if ouvert then
              begin
                 infos:=Trim(Infos+'\n'+trim(s));
              end;
           If (Pos('(Client)'+#9,s)>1) or (Pos('(Server)'+#9,s)>1) then
           If (Pos('(Client)'+#9,s)>1) or (Pos('(Server)'+#9,s)>1) then
              begin
                 astrdate:=Copy(s,Pos('(Client)'+#9,s)+9,Length(s));
                 sday :=Copy(astrdate,Length(astrdate)-15,2);
                 iday:=StrToInt(sDay);
                 smonth:=Copy(astrdate,Length(astrdate)-19,3);
                 syear:=Copy(astrdate,Length(astrdate)-3,4);
                 iyear:=StrToInt(syear);
                 stime:=Copy(astrdate,Length(astrdate)-12,8);
                 iMonth:=0;
                 for j:=1 to 12 do
                    begin
                        if (fs.ShortMonthNames[j]=sMonth)
                          then iMonth:=j;
                    end;
                 FDatas.dDate:= EncodeDate(iyear,imonth,iday) + StrToTime(stime);
                 // Format('%s-%.2d-%s %s',[syear,imonth,sday,stime]);
                 FDatas.sType:=Copy(s,1,Pos(')'+#9,s));
                 ouvert:=true;
                 Infos:='';
              end;
      end;
end;


end.
