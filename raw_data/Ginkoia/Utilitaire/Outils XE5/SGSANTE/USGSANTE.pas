unit USGSANTE;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Vcl.ExtCtrls,GestionLog,ShellAPi,System.IniFiles,UCommun;

Const script = 'ws_sgsante.php';

type
  TSSGSANTE = class(TService)
    Timer1: TTimer;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure Timer2Timer(Sender: TObject);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
  private
    FIBServer : TprocessInfos;
    FLame     : string;
    FDrives   : TDrives;
    Ftempo    : Integer;
    FAuto     : boolean;
    FStart    : integer;
    FStop     : Boolean;
    FUrl      : string;
    Fnodel    : boolean;
    FbQuery   : integer;
    { Déclarations privées }
    function GetStop():boolean;
    procedure SetStop(avalue:boolean);
  public
    function GetServiceController: TServiceController; override;
    procedure LoadParams;
    procedure Scan;
    { Déclarations publiques }
  property
    Stop:Boolean read GetStop write setStop;
  end;

var
  SSGSANTE: TSSGSANTE;

implementation


{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  SSGSANTE.Controller(CtrlCode);
end;

function TSSGSANTE.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;


procedure TSSGSANTE.ServiceContinue(Sender: TService; var Continued: Boolean);
begin
    Log_Write('Reprise du service', el_Info);
    LoadParams;
    Stop:=false;
end;

procedure TSSGSANTE.ServicePause(Sender: TService; var Paused: Boolean);
begin
    Log_Write('Pause du service', el_Info);
    Stop:=true;
end;

procedure TSSGSANTE.ServiceStart(Sender: TService; var Started: Boolean);
begin
    Log_Init(el_Info, ExtractFilePath(ParamStr(0)));
    Log_Write('Démarage du service', el_Info);
    LoadParams;
end;

procedure TSSGSANTE.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
    Log_Write('Arret du service', el_Info);
    Stop:=true;
end;

procedure TSSGSANTE.SetStop(avalue:boolean);
begin
     FStop:=avalue;
     Log_Write(IntToStr(Timer1.Interval), el_Info);
     Timer1.Enabled:=not(aValue);
     if Avalue
       then Log_Write('Set Stop=true', el_Info)
       else Log_Write('Set Stop=false', el_Info)
end;

function TSSGSANTE.GetStop():boolean;
begin
     result:=FStop;
end;

procedure TSSGSANTE.Timer1Timer(Sender: TObject);
begin
    Log_Write('Timer_1', el_Debug);
    if not (Status = csRunning) then
      Exit;
    try
       Log_Write('Timer', el_Debug);
       Timer1.Enabled := False;
       // Raichissement;
       Scan;
    finally
       Timer1.Enabled := True;
    end;
end;

procedure TSSGSANTE.Timer2Timer(Sender: TObject);
begin
     Dec(FStart);
     Log_Write(Format('Lancement dans %d secondes',[FStart]), el_Info);
     if FStart<=0 then
      begin
           VGSE.OSInfos:=GetOsInfos;
           Stop:=false;
           Timer2.Enabled:=false;
      end;
end;

procedure TSSGSANTE.Scan;
var i:Integer;
    json:string;
    virgule:string;
   Parametres:string;
    sAuto,sNodel:string;
    nerror:Integer;
    sNewFileName:string;
begin
    Log_Write('Scan', el_Debug);
    if FAuto
      then sAuto:='-auto '
      else sAuto:='';

    if Fnodel
      then sNodel:='-nodel '
      else sNodel:='';

    json:='';
    json:=json + Format('{"os":[{"pcname":"%s","os":"%s"}]}',[VGSE.OSInfos.CSName,VGSE.OSInfos.Caption]);
    FDrives   := GetDrivesinfos;
    json:=json+',{"drives":[';
    virgule:='';
    for I:=0 to High(FDrives) do
        begin
             json := json + Format('%s{"name":"%s","size":"%s","free":"%s"}',[virgule,FDrives[i].DeviceID,FDrives[i].Size,FDrives[i].FreeSpace]);
             virgule:=',';
        end;
    json:=json+']},';
    FIBServer := GetProcessInfos('ibserver.exe',FbQuery);
    json := json + Format('{"ibserver":[{"pid":"%s","priority":"%s","ppfu":"%s","pvs":"%s","pwss":"%s","tc":"%s","vs":"%s","wss":"%s","woc":"%s","hc":"%s","pfbp":"%s","ppt":"%s","ws":"%s","wspk":"%s","wspv":"%s","umt":"%s","et":"%s","kmt":"%s"}]}',
      [FIBServer.PID,
      FIBServer.Priority,
      FIBServer.PeakPageFileUsage,
      FIBServer.PeakVirtualSize,
      FIBServer.PeakWorkingSetSize,
      FIBServer.ThreadCount,
      FIBServer.VirtualSize,
      FIBServer.WorkingSetSize,
      FIBServer.WriteOperationCount,
      FIBServer.HandleCount,
      FIBServer.PageFileBytesPeak,
      FIBServer.PercentProcessorTime,
      FIBServer.WorkingSet,
      FIBServer.WorkingSetPeak,
      FIBServer.WorkingSetPrivate,
      FIBServer.UserModeTime,
      FIBServer.ElapsedTime,
      FIBServer.KernelModeTime
      ]);
    json := Format('{"lame":"%s","datas":[%s]}',[Flame,json]);
    sNewFileName := CreateUniqueGUIDFileName(GetTmpDir,'ws_ugsante','.tmp');
    SaveStrToFile(sNewFileName,json);
    Parametres:=Format('%s-url=%s %s -psk=GFD791SQ6 -file="%s"',[
         sauto,
         FUrl,
         sNodel,
         sNewFileName]);
     Log_Write('WDPOST.exe ' + Parametres, el_Debug);
     ShellExecute(0,'Open',PChar('WDPOST.exe'),PChar(Parametres),Nil,SW_SHOWDEFAULT);
end;

procedure TSSGSANTE.LoadParams;
var // i:Integer;
    // value,param:string;
    Path:string;
    Ini: TIniFile;
    vdebug : integer;
begin
    Log_Write('LoadParams', el_Info);
    Ini := TIniFile.Create(VGSE.ExePath + 'SGSANTE.ini');
    try
       FStop:=true;
       // niveau de log
       vdebug := Ini.Readinteger('SGSANTE','debug',4);
       Case vdebug of
        0: Log_ChangeNiv(el_silent);
        1: Log_ChangeNiv(el_Erreur);
        2: Log_ChangeNiv(el_Warning);
        3: Log_ChangeNiv(el_Info);
        4: Log_ChangeNiv(el_Debug);
       End;

       Path    := Ini.ReadString('SGSANTE','path','http://127.0.0.1/');
       FAuto   := Ini.ReadInteger('SGSANTE','auto',1)=1;
       Ftempo  := Ini.Readinteger('SGSANTE','tempo',10);
       FStart  := Ini.Readinteger('SGSANTE','start',60);
       FLame   := Ini.Readstring('SGSANTE','lame','lame');
       Fnodel  := Ini.ReadInteger('SGSANTE','nodel',0)=1;
       FbQuery := Ini.ReadInteger('SGSANTE','bquery',2);

       // Les URL
       FUrl      := Path + script;
       Timer1.Interval := 1000*Ftempo;
       Timer2.Enabled  := true;
       //---------------------------
       Log_Write('tempo   : '+ IntToStr(Ftempo), el_Info);
       Log_Write('start   : '+ IntToStr(FStart), el_Info);
       Log_Write('url     : '+ FURL, el_Info);

    finally
       Ini.Free;
    end;
end;



end.
