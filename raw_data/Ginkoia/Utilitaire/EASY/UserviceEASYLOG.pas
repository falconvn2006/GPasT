unit UserviceEASYLOG;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Vcl.ExtCtrls,GestionLog,System.IniFiles, Winapi.WinSvc,System.RegularExpressionsCore,ULog;

type
  TServiceGinkoiaEASYLOG = class(TService)
    Timer1: TTimer;
    Timer2: TTimer;
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure Timer2Timer(Sender: TObject);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { Déclarations privées }
    FFileList : TStrings;
    Ftempo  : Integer;
    FStart  : integer;
    FStop   : Boolean;
    function GetStop():boolean;
    procedure ScanLogs;
    procedure SetStop(avalue:boolean);
  public
    procedure LoadParams;
    function GetServiceController: TServiceController; override;
  property
    Stop:Boolean read GetStop write setStop;
    { Déclarations publiques }
  end;

var
  ServiceGinkoiaEASYLOG: TServiceGinkoiaEASYLOG;

implementation

{$R *.dfm}

USes UWMI,UCommun;


procedure TServiceGinkoiaEASYLOG.LoadParams;
var Path:string;
    Ini: TIniFile;
    vdebug : integer;
begin
    Log_Write('LoadParams', el_Info);
    Ini := TIniFile.Create(VGSE.ExePath + 'ServiceEASYLOG.ini');
    try
       FStop:=true;
       // niveau de log
       vdebug := Ini.Readinteger('ServiceEASYLOG','debug',3);
       Case vdebug of
        0: Log_ChangeNiv(el_silent);
        1: Log_ChangeNiv(el_Erreur);
        2: Log_ChangeNiv(el_Warning);
        3: Log_ChangeNiv(el_Info);
        4: Log_ChangeNiv(el_Debug);
       End;

       Ftempo  := Ini.Readinteger('ServiceEASYLOG','tempo',5);
       FStart  := Ini.Readinteger('ServiceEASYLOG','start',5);

       // Les URL
       Timer1.Interval := 1000*Ftempo;
       Timer2.Enabled  := true;
       //---------------------------
       Log_Write('tempo   : '+ IntToStr(Ftempo), el_Info);
       Log_Write('start   : '+ IntToStr(FStart), el_Info);
    finally
       Ini.Free;
    end;
end;


procedure TServiceGinkoiaEASYLOG.SetStop(avalue:boolean);
begin
     FStop:=avalue;
     Log_Write(IntToStr(Timer1.Interval), el_Info);
     Timer1.Enabled:=not(aValue);
     if Avalue
       then Log_Write('Set Stop=true', el_Info)
       else Log_Write('Set Stop=false', el_Info)
end;

procedure TServiceGinkoiaEASYLOG.Timer1Timer(Sender: TObject);
begin
    Log_Write('Timer_1', el_Debug);
    if not (Status = csRunning) then Exit;
    try
       Log_Write('Timer', el_Debug);
       Timer1.Enabled := False;
       ScanLogs;
    finally
       Timer1.Enabled := True;
    end;
end;

procedure TServiceGinkoiaEASYLOG.Timer2Timer(Sender: TObject);
begin
     Dec(FStart);
     Log_Write(Format('Lancement dans %d secondes',[FStart]), el_Info);
     if FStart<=0 then
       begin
           // VGSE.OSInfos:=GetOsInfos;
           Stop:=false;
           Timer2.Enabled:=false;
       end;
end;

procedure TServiceGinkoiaEASYLOG.ScanLogs;
var aNumRows:Integer;
    i:Integer;
    vStream : TFileStream;
    vPos : integer;
    j :Integer;
    regExp : TPerlRegEx;
    vLevel : TLogLevel;
    vDateTime:TDateTime;

begin
    WMI_GetServicesSYMDS;
    // GetDatabases;
    for i:=0 to length(VGSYMDS)-1 do
      begin
         if not(Assigned(FFileList))
            then
                begin
                    FFileList := TStringList.Create;
                end
             else FFileList.Clear;
         try
            vStream := TFileStream.Create(VGSYMDS[i].ConfigDir+'\..\logs\symmetric.log',fmOpenRead or fmShareDenyNone);
            try
              // SymmetricDS recrée un nouveau fichier si sa taille dépasse le paramète en conf.
              // donc si sa taille est plus grande on se positionne sur FFilePos
              // sinon on recommence à zéro
              vPos:=LoadFilePos(VGSYMDS[i].ServiceName);
              if vStream.Size>=vPos
                then vStream.Position := vPos
                else vStream.Position := 0;
              FFileList.LoadFromStream(vStream);
              SaveFilePos(VGSYMDS[i].ServiceName,vStream.Size);
              regExp := TPerlRegEx.Create;
              try
                regExp.RegEx := '(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3}) (.*?) \[([^]]*)\] \[([^]]*)\] \[([^]]*)\] (.*)';
                for j:= 0 to FFileList.count-1 do
                  begin
                     if Length(FFileList[j])>1
                       then
                            begin
                               regExp.Subject  := FFileList[j];
                               regExp.Options  := [preCaseLess];
                               If (regExp.Match())
                                then
                                  begin
                                      try
                                         // LogDT(adate:TDateTime;aSrv, aMdl, aDos, aRef, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean);
                                         vLevel := logError;
                                         if regExp.Groups[2]='INFO'  then vLevel := logInfo;
                                         if regExp.Groups[2]='WARN'  then vLevel := logWarning;
                                         if regExp.Groups[2]='ERROR' then vLevel := logError;
                                         ///////////////////////////////////////
                                         {
                                         try
                                           vDateTime := ISO8601ToDateTime(regExp.Groups[1]);
                                         except
                                            On E:Exception do Log_Write(E.MEssage, el_Erreur);
                                         end;
                                         }
                                         Log.Log(
                                            Log.Host,
                                            VGSYMDS[i].ServiceName,
                                            regExp.Groups[3],
                                            '',
                                            regExp.Groups[4],
                                            regExp.Groups[6],
                                            vLevel, true);
                                      finally

                                      end;
                                  end;
                            end;
                      end;
                    finally
                    regExp.Free;
                  end;
                finally
                 vStream.Free;
                end;
         except
            // Log de except
         end;
      end;
end;

function TServiceGinkoiaEASYLOG.GetStop():boolean;
begin
     result:=FStop;
end;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ServiceGinkoiaEASYLOG.Controller(CtrlCode);
end;

function TServiceGinkoiaEASYLOG.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;


procedure TServiceGinkoiaEASYLOG.ServiceAfterInstall(Sender: TService);
const  ALHRZ_DESCRIPTION = 'Service Ginkoia EASY Log';
var
  Svc: SC_HANDLE;
  SvcMgr: SC_HANDLE;
  Info: SERVICE_DESCRIPTION;
begin
  SvcMgr := OpenSCManager(nil, nil, STANDARD_RIGHTS_REQUIRED);
  try
    Svc := OpenService(SvcMgr, PChar(Self.Name), SERVICE_CHANGE_CONFIG);
    try
      Info.lpDescription := PChar(ALHRZ_DESCRIPTION);
      Winapi.WinSvc.ChangeServiceConfig2(Svc, SERVICE_CONFIG_DESCRIPTION, @Info);
    finally
      CloseServiceHandle(Svc);
    end;
  finally
    CloseServiceHandle(SvcMgr);
  end;
end;

procedure TServiceGinkoiaEASYLOG.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
    try
      Log_Write('Reprise du service', el_Info);
      LoadParams;
      Stop:=false;
    except
      On E:Exception do
        Log_Write(E.Message, el_Erreur);
    end;
end;

procedure TServiceGinkoiaEASYLOG.ServicePause(Sender: TService;
  var Paused: Boolean);
begin
   try
      Log_Write('Pause du service', el_Info);
      Stop:=true;
      Log.Close();
    except
      On E:Exception do
        Log_Write(E.Message, el_Erreur);
    end;
end;

procedure TServiceGinkoiaEASYLOG.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
    try
      Log_Init(el_Info, ExtractFilePath(ParamStr(0)));
      Log_Write('Démarage du service', el_Info);
      LoadParams;

      Log.readIni();
      Log.Srv      := Log.Host;
      Log.App      := 'EASYLOG';
      Log.MaxItems := 10000;
      Log.Deboublonage := false;
      Log.Open();
      Log.saveIni();
    except
      On E:Exception do
        Log_Write(E.Message, el_Erreur);
    end;
end;

procedure TServiceGinkoiaEASYLOG.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin
    try
      Log_Write('Arret du service', el_Info);
      Stop:=true;
      if (Assigned(FFileList))
        then FFileList.DisposeOf;
      Log.Close();
    except
      On E:Exception do
        Log_Write(E.Message, el_Erreur);
    end;
end;




end.
