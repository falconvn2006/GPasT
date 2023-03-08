unit uThreadWMI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Vcl.ExtCtrls, System.IniFiles, Winapi.WinSvc, System.RegularExpressionsCore, uLog, UWMI, IdURI, Math;

Type
  TMenuServiceAction = (MenuServiceStop, MenuServiceStart, MenuServiceRestart);
  TMenuExeAction = (MenuExeStop, MenuExeStart);

  TThreadWMI = class(TThread)
  private
    { Déclarations privées }
    PI_BackupRest: TprocessInfos;
    PI_Ginkoia: TprocessInfos;
    PI_Interbase: TprocessInfos;
    PI_Verification: TprocessInfos;
    PI_PG: TGroupProcessInfos;
    PI_Piccobatch: TprocessInfos;
    SE_EASY: TEASYInfos;
    SE_MAJ: TServiceInfos;
    SE_MOB: TServiceInfos;
    SE_REPR: TServiceInfos;
    SE_BI: TServiceInfos;
    FJava_RUN : boolean;
    FDRIVES    : TDrives;
    FFREESPACE : int64;
    FURL       : string;
    procedure GetProcessInfos;
    procedure GetServicesInfos;
    procedure GetDrivesInfos;
    function ParseRegistrationURL(aURL: string): string;
  public
    procedure Execute; override;
    constructor Create(CreateSuspended: boolean; const AEvent: TNotifyEvent = nil); reintroduce;
    property URL : string read FURL;
    property FREESPACE   : Int64      read FFREESPACE;
    property ServiceEASY : TEASYInfos read SE_EASY;
    property DRIVES      : TDrives    read FDRIVES;
    property Java_RUN    : boolean    read FJAVA_RUN;
    { Déclarations publiques }
  end;

implementation

constructor TThreadWMI.Create(CreateSuspended: boolean; Const AEvent: TNotifyEvent = nil);

begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := true;
  FFREESPACE  := 0;
  OnTerminate := AEvent;
  FJava_RUN   := false;
end;

procedure TThreadWMI.Execute;
var vDrive : string;
    i:integer;
begin
  try
    GetDrivesInfos;
    GetServicesInfos;
    GetProcessInfos;
    vDrive := UpperCase(ExtractFileDrive(SE_EASY.Directory));
    for I := Low(FDRIVES) to High(FDRIVES) do
      begin
        if FDRIVES[i].DeviceID=vDrive then
          begin
             FFREESPACE := StrToInt64Def(FDRIVES[i].FreeSpace,0);
          end;
      end;
    FJava_RUN := WMI_MyJavaRun(SE_EASY.JavaPath+'.exe');
    FURL := ParseRegistrationURL(SE_EASY.registration_url);
  finally
    // Synchronize(UpdateVCL);
  end;
end;


function TThreadWMI.ParseRegistrationURL(aURL: string): string;
var
  URI: TIdURI;
  vProtocol, vHost, vPort: string;
begin
  if aURL <> '' then
  begin
    URI := TIdURI.Create(aURL);
    try
      vProtocol := URI.Protocol;
      vHost := URI.Host;
      vPort := URI.Port;

      Result := vProtocol + '://' + vHost + ':' + vPort;
    finally
      URI.Free;
    end;
  end;
end;

procedure TThreadWMI.GetProcessInfos;
begin
  PI_BackupRest := WMI_GetProcessInfos('BackRest.exe');
  PI_Ginkoia := WMI_GetProcessInfos('Ginkoia.exe');
  PI_Verification := WMI_GetProcessInfos('verification.exe');
  PI_Interbase := WMI_GetProcessInfos('ibserver.exe');
  PI_PG := WMI_GetGroupProcessInfos('postgres.exe');
  PI_Piccobatch := WMI_GetProcessInfos('piccobatch.exe');
end;

procedure TThreadWMI.GetServicesInfos;
begin
  SE_EASY := WMI_GetServicesEASY();
  SE_MAJ  := WMI_GetService('SerMAJGINKOIA'); // GInkoiaMAJSvr
  SE_MOB  := WMI_GetService('GinkoiaMobiliteSvr');
  SE_REPR := WMI_GetService('GinkoiaServiceReprises');
  SE_BI   := WMI_GetService('Service_BI_Ginkoia');
end;

procedure TThreadWMI.GetDrivesInfos;
begin
  FDRIVES := WMI_GetDrivesInfos;
end;

end.
