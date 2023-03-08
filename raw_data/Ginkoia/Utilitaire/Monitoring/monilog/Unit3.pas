unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs, VCL.Forms,
  IdIcmpClient, UlogModule, ULogModule_ICMP, ULogModule_WMI, ULogModule_INTERBASE.Log,
  ULogModule_MONITOR, ULogModule_IB, Ulog, ULogModule_SFTP, inifiles, Contnrs, Vcl.OleCtrls, SHDocVw,
  FireDAC.Stan.StorageJSON, SBSimpleSftp, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Buttons, Vcl.ExtCtrls, Registry;

type
  TListModules =  class(TObjectList);
  TServMonilog = class(TService)
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceAfterInstall(Sender: TService);
  private
    FNbModule:integer;
    FModules  : TListModules;
    FServname : string;
    procedure LoadIni;
    procedure AfterICMPTest(Sender:Tobject);
    procedure AfterIBTest(Sender:TObject);
    procedure AfterWMITest(Sender:Tobject);
    procedure AfterSFTPTest(Sender:Tobject);
    { Déclarations privées }
  public
    function GetServiceController: TServiceController; override;
    { Déclarations publiques }
  end;

var
  ServMonilog: TServMonilog;

implementation

{$R *.dfm}

uses UCommun,GestionLog;

procedure TServMonilog.AfterWMITest(Sender:Tobject);
begin
    //
    Log_Write(Format(' Max : %d',[TLogModule_ICMP(Sender).Datas.Max]), el_Info);
    Log_Write(Format(' Min : %d',[TLogModule_ICMP(Sender).Datas.min]), el_Info);
    Log_Write(Format(' Avg : %d',[TLogModule_ICMP(Sender).Datas.Avg]), el_Info);
end;


procedure TServMonilog.AfterIBTest(Sender:Tobject);
begin
    //
end;

procedure TServMonilog.AfterSFTPTest(Sender:Tobject);
begin
    //
end;


procedure TServMonilog.AfterICMPTest(Sender:Tobject);
begin
    //
end;

procedure TServMonilog.Timer1Timer(Sender: TObject);
var i:integer;
begin
    Timer1.Enabled:=false;
    try
        for i:= 0 to FModules.Count-1 do
            begin
               Log_Write(TLogModule(FModules[i]).Module, el_Debug);
               TLogModule(FModules[i]).next:=TLogModule(FModules[i]).next-1;
               if TLogModule(FModules[i]).next<=0 then
                  begin
                      Log_Write('DoTest', el_Info);
                      TLogModule(FModules[i]).Test;
                      TLogModule(FModules[i]).Next:=TLogModule(FModules[i]).Freq;
                  end;
            end;
    finally
        Timer1.Enabled:=true;
    end;
end;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ServMonilog.Controller(CtrlCode);
end;

function TServMonilog.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TServMonilog.LoadIni;
var iniFile:TIniFile;
    i:integer;
    aType     : string;
    aMod      : string;
    AName     : string;
    AHost     : string;
    AWS       : string;
    AFREQ     : integer;
    APORT     : integer;
    AGRP      : string;
    AUSERNAME : string;
    APASSWORD : string;
    AREMOTEPATH :string;
    FLogModule:TLogModule;
begin
     IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
     Log_Write(IniFile.FileName, el_Info);
     FModules:=TListModules.Create(true);
     Try
        FNbModule     := IniFile.ReadInteger('GLOBAL','NbModules',0) ;
        FServname := IniFile.Readstring('GLOBAL','SERVNAME','') ;
        for i := 0 to FNbModule-1 do
          begin
             aType       := IniFile.Readstring(Format('MODULE_%d',[i+1]),'TYPE','');
             aMod        := IniFile.Readstring(Format('MODULE_%d',[i+1]),'MOD','');
             AName       := IniFile.ReadString(Format('MODULE_%d',[i+1]),'NAME','');
             AHost       := IniFile.ReadString(Format('MODULE_%d',[i+1]),'HOST','');
             AWS         := IniFile.ReadString(Format('MODULE_%d',[i+1]),'WS','');
             AFREQ       := IniFile.Readinteger(Format('MODULE_%d',[i+1]),'FREQ',60);
             APORT       := IniFile.Readinteger(Format('MODULE_%d',[i+1]),'PORT',22);
             AUSERNAME   := IniFile.Readstring(Format('MODULE_%d',[i+1]),'USERNAME','');
             APASSWORD   := IniFile.Readstring(Format('MODULE_%d',[i+1]),'PASSWORD','');
             AREMOTEPATH := IniFile.Readstring(Format('MODULE_%d',[i+1]),'REMOTEPATH','');
             AGRP        := IniFile.Readstring(Format('MODULE_%d',[i+1]),'GRP','');
             case CaseOfString(AType, ['ICMP','INTERBASE/GINKOIA','INTERBASE/MONITOR','WMI','SFTP','INTERBASE.LOG']) of
              0: // Ping
                begin
                  FLogModule:=TLogModule_ICMP.create(FServname, AFreq ,AfterICMPTest);
                  TLogModule_ICMP(FLogModule).PingHost:=AHost;
                end;
              1: // Interbase/ginkoia
                begin
                  FLogModule:=TLogModule_IB.create(FServname, AFreq ,AfterIBTest);
                  TLogModule_IB(FLogModule).GRP  := AGRP;
                  TLogModule_IB(FLogModule).Mode := aMod;
                  TLogModule_IB(FLogModule).WS   := AWS;
                  TLogModule_IB(FLogModule).WSFREQ := 50;
                  TLogModule_IB(FLogModule).Prepare;
                end;
              2: // Interbase/monitor
                begin
                  FLogModule:=TLogModule_MONITOR.create(FServname, AFreq ,AfterIBTest);
                  TLogModule_MONITOR(FLogModule).GRP  := AGRP;
                  TLogModule_MONITOR(FLogModule).Mode := aMod;
                  TLogModule_MONITOR(FLogModule).WS   := AWS;
                  TLogModule_MONITOR(FLogModule).WSFREQ := 50;
                  TLogModule_MONITOR(FLogModule).Prepare;
                end;
              3: // WMI
                begin
                  FLogModule:=TLogModule_WMI.create(FServname, AFreq ,AfterWMITest);
                end;
              4: // SFTP
                begin
                  FLogModule:=TLogModule_SFTP.create(FServname, AFreq ,AfterSFTPTest);
                  TLogModule_SFTP(FLogModule).Adresse    := AHOST;
                  TLogModule_SFTP(FLogModule).Port       := APORT;
                  TLogModule_SFTP(FLogModule).Username   := AUSERNAME;
                  TLogModule_SFTP(FLogModule).Password   := APASSWORD;
                  TLogModule_SFTP(FLogModule).RemotePath := AREMOTEPATH;
                end;
              5: // INTERBASE.LOG
                begin
                  FLogModule:=TLogModule_INTERBASE_LOG.create(FServname, AFreq ,AfterSFTPTest);
                end
               else
                begin
                   //
                end;
             end;
             FModules.Add(FLogModule);
          end;
     Finally
        IniFile.Free;
     End;
end;


procedure TServMonilog.ServiceAfterInstall(Sender: TService);
var Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Name, false) then
    begin
      Reg.WriteString('Description', 'Envoie les données de Monitoring au serveur de Log de Ginkoia');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TServMonilog.ServiceStart(Sender: TService; var Started: Boolean);
begin
    LoadIni;
    Log.App  := 'smonilog';
    Log.Inst := '1';
    Log.Open;
    //
    Log_Init(el_Info, ExtractFilePath(ParamStr(0)));
    Log_Write('Démarage du service', el_Info);
    LoadIni;
    Timer1.Enabled:=true;
end;

procedure TServMonilog.ServiceStop(Sender: TService; var Stopped: Boolean);
var i:integer;
begin
    Timer1.Enabled:=False;
    for i:= FModules.Count-1 downto 0 do
        begin
           FModules[i].DisposeOf;
        end;
    Log.saveIni();
end;

end.
