unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,StdCtrls, IdIcmpClient, UlogModule, ULogModule_ICMP, ULogModule_WMI, ULogModule_INTERBASE.Log,
  ULogModule_MONITOR, ULogModule_IB, Ulog, ULogModule_SFTP, inifiles, Contnrs, Vcl.OleCtrls, SHDocVw,
  FireDAC.Stan.StorageJSON, SBSimpleSftp, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Buttons, Vcl.ExtCtrls;

type
  TListModules =  class(TObjectList);
  TForm2 = class(TForm)
    Timer1: TTimer;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure PingClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BIBClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    FNbModule:integer;
    FModules  : TListModules;
    FServname : string;
    { Déclarations privées }
  function CaseOfString(s: string; a: array of string): Integer;
  procedure LoadIni;
  procedure AfterICMPTest(Sender:Tobject);
  procedure AfterIBTest(Sender:TObject);
  procedure AfterWMITest(Sender:Tobject);
  procedure AfterSFTPTest(Sender:Tobject);
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.AfterWMITest(Sender:Tobject);
begin
end;


procedure TForm2.AfterIBTest(Sender:Tobject);
begin
end;

procedure TForm2.AfterSFTPTest(Sender:Tobject);
begin
{   memo1.Lines.Clear;
    if (TLogModule_SFTP(Sender).Etat.Connected=true)
      then memo1.Lines.Add('Connection SFTP : OK')
      else
        begin
          memo1.Lines.Add('Connection SFTP : KO');
          memo1.Lines.Add('Error Msg ' + TLogModule_SFTP(Sender).Etat.ErrorMsg);
        end;
    memo1.Lines.Add(Format('Filesize  : %d',[TLogModule_SFTP(Sender).Etat.FileSize]));

    if (TLogModule_SFTP(Sender).Etat.Uploaded)
      then memo1.Lines.Add('Upload : OK')
      else memo1.Lines.Add('Upload : KO');

    if (TLogModule_SFTP(Sender).Etat.Downloaded)
      then memo1.Lines.Add('Download : OK')
      else memo1.Lines.Add('Download : KO');

    if (TLogModule_SFTP(Sender).Etat.Compared)
      then memo1.Lines.Add('Compared : OK')
      else memo1.Lines.Add('Compared : KO');


    memo1.Lines.Add(Format('ConnectTime  : %d',[TLogModule_SFTP(Sender).Etat.ConnectTime]));
    memo1.Lines.Add(Format('UploadTime   : %d',[TLogModule_SFTP(Sender).Etat.UploadTime]));
    memo1.Lines.Add(Format('DownloadTime : %d',[TLogModule_SFTP(Sender).Etat.DownloadTime]));
}
end;


procedure TForm2.AfterICMPTest(Sender:Tobject);
begin
{    memo2.Lines.Add('Min : ' + IntToStr(TLogModule_ICMP(Sender).datas.Min));
    memo2.Lines.Add('Max : ' + IntToStr(TLogModule_ICMP(Sender).datas.Max));
    memo2.Lines.Add('Avg : ' + IntToStr(TLogModule_ICMP(Sender).datas.Avg));
    }
end;

procedure TForm2.PingClick(Sender: TObject);
begin
   // FPing.Test;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
var i:integer;
begin
    for i:= 0 to FModules.Count-1 do
        begin
           TLogModule(FModules[i]).next:=TLogModule(FModules[i]).next-1;
           if TLogModule(FModules[i]).next<=0 then
              begin
                  TLogModule(FModules[i]).Test;
                  TLogModule(FModules[i]).Next:=TLogModule(FModules[i]).Freq;
              end;
        end;
end;

procedure TForm2.BIBClick(Sender: TObject);
begin

//    FIB.Test;
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
    Timer1.Enabled:=true;
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
    Timer1.Enabled:=false;
end;

procedure TForm2.Button1Click(Sender: TObject);
// var i:integer;
begin
//     for i:= 0 to FModules.Count-1 do
//         begin
//            TLogModule(FModules[i]).Test;
//         end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
    LoadIni;
    Log.App  := 'monilog';
    Log.Inst := '1';
    Log.Open;
end;

function TForm2.CaseOfString(s: string; a: array of string): Integer;
begin
Result := 0;
while (Result < Length(a)) and (a[Result] <> s) do
Inc(Result);
if a[Result] <> s then
Result := -1;
end;

procedure TForm2.LoadIni;
var iniFile:TIniFile;
    i:integer;
    aType     : string;
    aMod      : string;
    AName     : string;
    AHost     : string;
    AWS       : string;
    AFREQ     : integer;
    APORT     : integer;
    AUSERNAME : string;
    APASSWORD : string;
    AREMOTEPATH :string;
    FLogModule:TLogModule;
begin
     IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
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
             case CaseOfString(AType, ['ICMP','INTERBASE/GINKOIA','INTERBASE/MONITOR','WMI','SFTP','INTERBASE.LOG']) of
              0: // Ping
                begin
                  FLogModule:=TLogModule_ICMP.create(FServname, AFreq ,AfterICMPTest);
                  TLogModule_ICMP(FLogModule).PingHost:=AHost;
                end;
              1: // Interbase/ginkoia
                begin
                  // ici SQLite représente le chemin vers la base sqlite
                  FLogModule:=TLogModule_IB.create(AHost, AFreq ,AfterIBTest);
                  TLogModule_IB(FLogModule).Mode := aMod;
                  TLogModule_IB(FLogModule).WS   := AWS;
                  TLogModule_IB(FLogModule).WSFREQ := 50;
                  TLogModule_IB(FLogModule).Prepare;
                end;
              2: // Interbase/monitor
                begin
                  // ici SQLite représente le chemin vers la base sqlite
                  FLogModule:=TLogModule_MONITOR.create(AHost, AFreq ,AfterIBTest);
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
                  TLogModule_SFTP(FLogModule).Adresse:=AHOST;
                  TLogModule_SFTP(FLogModule).Port:=APORT;
                  TLogModule_SFTP(FLogModule).Username:=AUSERNAME;
                  TLogModule_SFTP(FLogModule).Password:=APASSWORD;
                  TLogModule_SFTP(FLogModule).RemotePath:=AREMOTEPATH;
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

procedure TForm2.FormDestroy(Sender: TObject);
var i:integer;
begin
    for i:= FModules.Count-1 downto 0 do
        begin
           FModules[i].DisposeOf;
        end;
    Log.saveIni();
end;

end.
