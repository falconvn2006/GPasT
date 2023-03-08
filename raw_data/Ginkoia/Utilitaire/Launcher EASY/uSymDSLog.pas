unit uThreadLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Vcl.ExtCtrls,System.IniFiles, Winapi.WinSvc,System.RegularExpressionsCore,ULog;

Type
  TThreadLOG = class(TThread)
  private
    { Déclarations privées }
    FFileList : TStrings;
    FIniFile : TFileName;
    FLastInfos : string;
    procedure ScanLogs;
    function LoadFilePos():integer;
    procedure SaveFilePos(aPosition:integer);
    procedure UpdateVCL();
    // procedure LoadParams;
  public
    procedure Execute; override;
    constructor Create(CreateSuspended:boolean;aIniFile:TFileName;const AEvent:TNotifyEvent=nil); reintroduce;
    { Déclarations publiques }
  end;

implementation

Uses UWMI,uMainForm,uLog;

procedure TThreadLOG.UpdateVCL();
begin
     Frm_Launcher.EventPanel[4].Detail :=  FLastInfos;
end;

procedure TThreadLOG.SaveFilePos(aPosition:integer);
var appINI : TIniFile;
begin
    appINI := TIniFile.Create(FIniFile) ;
    try
       appINI.WriteInteger('EASY','LOG_POSITION',aPosition) ;
      finally
      appINI.Free;
    end;
end;

function TThreadLOG.LoadFilePos():integer;
var appINI : TIniFile;
begin
    appINI := TIniFile.Create(FIniFile) ;
    result:=0;
    try
      result := appINI.ReadInteger('EASY','LOG_POSITION',0) ;
      finally
      appINI.Free;
    end;
end;

constructor TThreadLOG.Create(CreateSuspended:boolean;aIniFile:TFileName;Const AEvent:TNotifyEvent=nil);
begin
    inherited Create(CreateSuspended);
    WMI_GetServicesSYMDS;
    FreeOnTerminate  := true;
    FIniFile         := aIniFile;
    OnTerminate      := AEvent;
end;


procedure TThreadLOG.Execute;
begin
    try
      ScanLogs;
    finally
      Synchronize(UpdateVCL);
    end;
end;


procedure TThreadLOG.ScanLogs;
var aNumRows:Integer;
    i:Integer;
    vStream : TFileStream;
    vPos : integer;
    j :Integer;
    regExp : TPerlRegEx;
    vLevel : TLogLevel;
    vDateTime:TDateTime;

begin
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
              vPos:=LoadFilePos();
              if vStream.Size>=vPos
                then vStream.Position := vPos
                else vStream.Position := 0;
              FFileList.LoadFromStream(vStream);
              SaveFilePos(vStream.Size);
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
                                         FLastInfos := regExp.Groups[3];
                                         ///////////////////////////////////////
                                         {
                                         try
                                           vDateTime := ISO8601ToDateTime(regExp.Groups[1]);
                                         except
                                            On E:Exception do Log_Write(E.MEssage, el_Erreur);
                                         end;
                                         }
                                         {
                                         Log.Log(
                                            Log.Host,
                                            VGSYMDS[i].ServiceName,
                                            regExp.Groups[3],
                                            '',
                                            regExp.Groups[4],
                                            regExp.Groups[6],
                                            vLevel, true);
                                         }
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



end.
