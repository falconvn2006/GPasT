unit uThreadLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Vcl.ExtCtrls,System.IniFiles, Winapi.WinSvc, System.RegularExpressionsCore, uLog, Math;

Type
  TLogEvent = record
    DATE   : TDateTime;
    TEXT   : string;
    LEVEL  : TLogLevel;
  end;

  TLogEvents = Array of TLogEvent;

  TThreadLOG = class(TThread)   //
  private
    { Déclarations privées }
    FFileList : TStrings;
    FIniFile : TFileName;
    FLogFile : TFileName;   // LogEasy fichier log de EASY  (VGSYMDS[i].ConfigDir+'\..\logs\symmetric.log)
    FLogs    : TLogEvents;
    FGUID     : string;
    FPosition : Integer;
    procedure ScanLogs;
    function LoadFilePos():integer;
    procedure SaveFilePos(aPosition:integer);
    procedure UpdateVCL();
    Function ISO8601ToDateTime(Value: String):TDateTime;
    // procedure LoadParams;
  public
    procedure Execute; override;
    constructor Create(CreateSuspended:boolean;aGUID:string;aLogFile:TFileName;aIniFile:TFileName;const AEvent:TNotifyEvent=nil); reintroduce;
    destructor Destroy; override;
    { Déclarations publiques }
  end;

implementation

Uses uMainForm;

destructor TThreadLOG.Destroy();
begin
    FFileList.Free;
    inherited;
end;

procedure TThreadLOG.UpdateVCL();
var i:integer;
begin
  //-----------------------------------
  for i := Length(FLogs)-1 downto 0  do
    begin
      if FLogs[i].Level>=logWarning
        then
          begin
            Frm_Launcher.EventPanel[CID_EASY_LOG].Detail := FormatDateTime('dd/mm/yyyy hh:nn',FLogs[i].Date);
            Frm_Launcher.EventPanel[CID_EASY_LOG].Hint   := FLogs[i].Text + Format(' [%d]',[FPosition]);
            Frm_Launcher.EventPanel[CID_EASY_LOG].Level  := FLogs[i].Level;
            exit;
          end;
    end;
  for i := Length(FLogs)-1 downto 0  do
    begin
      Frm_Launcher.EventPanel[CID_EASY_LOG].Detail := FormatDateTime('dd/mm/yyyy hh:nn',FLogs[i].Date);
      Frm_Launcher.EventPanel[CID_EASY_LOG].Hint   := FLogs[i].Text + Format(' [%d]',[FPosition]);
      Frm_Launcher.EventPanel[CID_EASY_LOG].Level  := FLogs[i].Level;
    end;


  //-----------------------------------

{  if FLastInfos<>'' then
        Frm_Launcher.EventPanel[CID_REPLICATION].Detail :=  FLastInfos;
}
end;

Function TThreadLOG.ISO8601ToDateTime(Value: String):TDateTime;
var FormatSettings: TFormatSettings;
    vValue:string;
begin
    try
      vValue := Copy(Value,1,19);
      // GetLocaleFormatSettings(GetThreadLocale, FormatSettings); // deprecated
      FormatSettings  := TFormatSettings.Create;
      FormatSettings.DateSeparator := '-';
      FormatSettings.ShortDateFormat := 'yyyy-mm-dd';
      FormatSettings.LongTimeFormat :='hh:nn:ss';
      Result := StrToDateTime(Value, FormatSettings);
    Except
      On E:Exception
        do raise;// rien
    end;
end;

procedure TThreadLOG.SaveFilePos(aPosition:integer);
var appINI : TIniFile;
begin
    appINI := TIniFile.Create(FIniFile) ;
    try
       FPosition := 0;
       appINI.WriteInteger('EASY','LOG_POSITION',aPosition) ;
      finally
      appINI.Free;
    end;
end;

function TThreadLOG.LoadFilePos():integer;
var appINI : TIniFile;
begin
    result := 0; // Conseil : H2077 à la construction sans aucune raison => BUG des conseils du COMPILATEUR
    appINI := TIniFile.Create(FIniFile) ;
    try
      try
        result := appINI.ReadInteger('EASY','LOG_POSITION',0) ;
        FPosition := Result;
      except
        result := 0;
      end;
    finally
     appINI.Free;
    end;
end;

constructor TThreadLOG.Create(CreateSuspended:boolean;aGUID:string;aLogFile:TFileName;aIniFile:TFileName;Const AEvent:TNotifyEvent=nil);
begin
    inherited Create(CreateSuspended);
    FreeOnTerminate  := true;
    FIniFile         := aIniFile;
    FGUID            := aGUID;
    FLogFile         := aLogFile;
    SetLength(FLogs,0);
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
var // aNumRows:Integer;
    {i,}j,k:Integer;
    vStream : TFileStream;
    vPos : integer;
    regExp : TPerlRegEx;
    vLevel,vMaxLevel : TLogLevel;
    vDateTime:TDateTime;

begin
    if not(Assigned(FFileList))
       then
          begin
             FFileList := TStringList.Create;
          end
    else FFileList.Clear;
      try
          vStream := TFileStream.Create(FLogFile,fmOpenRead or fmShareDenyNone);
          try
            // SymmetricDS recrée un nouveau fichier si sa taille dépasse le paramète en conf.
            // donc si sa taille est plus grande on se positionne sur FFilePos
            // sinon on recommence à zéro

            vPos := LoadFilePos();

            if vStream.Size>=vPos
              then vStream.Position := vPos
              else vStream.Position := 0;

            // Pour le moment en recommence toujours à zéro
            // vStream.Position := 0;

            FFileList.LoadFromStream(vStream);
            SaveFilePos(vStream.Size);
            regExp := TPerlRegEx.Create;
            try
              vMaxLevel := logInfo;
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
                                       vLevel := logError;
                                       // LogDT(adate:TDateTime;aSrv, aMdl, aDos, aRef, aKey, aVal: string; aLvl: TLogLevel; aOvl: boolean);
                                       if regExp.Groups[2]='INFO'  then vLevel := logInfo;
                                       if regExp.Groups[2]='WARN'  then vLevel := logWarning;
                                       if regExp.Groups[2]='ERROR' then vLevel := logError;
                                       try
                                         vDateTime := ISO8601ToDateTime(regExp.Groups[1]);
                                         k:=Length(FLogs);
                                         SetLength(FLogs,k+1);
                                         FLogs[k].DATE :=  vDateTime;
                                         FLogs[k].Level := vLevel;
                                         FLogs[k].TEXT  := regExp.Groups[6];
                                         // Bug des Logs de SymmetricDS le Failure passe en INFO !
                                         If ((Pos('failure',FLogs[k].TEXT)>0) and (vLevel=logInfo))
                                            then
                                                begin
                                                  FLogs[k].Level := logWarning;
                                                  vLevel         := logWarning;
                                                end;
                                         if vLevel>vMaxLevel then
                                            vMaxLevel := vLevel;
                                       except
                                         //  On E:Exception do Log_Write(E.MEssage, el_Erreur);
                                       end;
                                       // On log vers le serveur que les WARN, ERROR ou les Pull et Push
                                       if (Ord(vLevel)>3) or (regExp.Groups[4]='PullService') or (regExp.Groups[4]='PushService')
                                          then Log.Log('SymLog', FGUID, regExp.Groups[4], regExp.Groups[6], vMaxLevel, True, 0, ltServer);

                                       // --------------------------------------
                                       if (regExp.Groups[4]='PullService') or (regExp.Groups[4]='PushService')
                                         then
                                            begin
                                               Log.Log('Replication',FGUID,'Status',regExp.Groups[6], vMaxLevel , True, 0, ltServer);
                                            end;
                                       //---------------------------------------

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



end.


