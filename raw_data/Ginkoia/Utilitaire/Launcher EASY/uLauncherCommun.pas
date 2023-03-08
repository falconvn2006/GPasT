unit uLauncherCommun;

interface

USES
  Windows,
  Messages, Forms,
  SysUtils, StrUtils,
  Variants,
  Classes,
  Graphics,
  WinSvc,
  Registry,
  IniFiles,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  InvokeRegistry,
  ImgList,
  DateUtils, Types,
  ShlObj, ShellAPI,  Math,
  ActiveX, uLog, ComCtrls, uEventPanel, Generics.Collections;

TYPE
  TypeValue = (TypeString, TypeInteger, TypeFloat);

  TEtatService = RECORD
    bInstall: Boolean;
    bAutomatique: Boolean;
    bStarted: Boolean;
  END;

  TTaskStatus = (tsDisabled, tsStoppped, tsWaiting, tsPaused, tsRunning) ;
  TTask = class
  private
    FName     : string ;
    FStatus   : TTaskStatus ;
    FEnabled  : boolean ;
    FRunning  : boolean ;
    FOk       : boolean ;
    FError    : string ;
    FWarning  : string ;
    FLast     : TDateTime ;
    FLastOk   : TDateTime ;
    FNext     : TDateTime ;
    FOverTime : Integer ;
    FLevel    : TLogLevel ;

    FEventPanel : TEventPanel ;
    FSend       : Boolean ;
    FReference  : string ;

    procedure evalStatus ;
    procedure setEnabled(const Value: boolean);
    procedure setOk(const Value: boolean);
    procedure setRunning(const Value: boolean);
    procedure setOverTime(const Value: Integer);
    procedure setError(const Value: string);
    procedure setLast(const Value: TDateTime);
    procedure setLastOk(const Value: TDateTime);
    procedure setNext(const Value: TDateTime);
    procedure setWarning(const Value: string);
  public
    constructor Create ;
    destructor Destroy ; override;
    procedure sendLog;
//  published
    property Name    : string      read FName      write FName ;
    property Reference : string    read FReference write FReference ;

    property Status  : TTaskStatus read FStatus ;
    property Enabled : boolean     read FEnabled   write setEnabled ;
    property Running : boolean     read FRunning   write setRunning ;
    property Ok      : boolean     read FOk        write setOk ;
    property Error   : string      read FError     write setError ;
    property Warning : string      read FWarning   write setWarning ;
    property Last    : TDateTime   read FLast      write setLast ;
    property LastOk  : TDateTime   read FLastOk    write setLastOk ;
    property Next    : TDateTime   read FNext      write setNext ;
    property OverTime : Integer    read FOverTime  write setOverTime ;
    property Level   : TLogLevel   read FLevel     write FLevel ;

    property EventPanel : TEventPanel read FEventPanel write FEventPanel ;
  end;

  TSynchroCaisse = record
    Enabled : boolean ;
    Time    : TTime ;
    Server  : string ;
  end ;

  TVersion = record
    Major     : Word ;
    Minor     : Word ;
    Revision  : Word ;
    Build     : Word ;
  end ;

implementation



//==============================================================================
{ TTask }
//==============================================================================
constructor TTask.Create;
begin
  inherited ;

  FSend    := true ;
  FReference := '' ;

  FEnabled := false ;
  FRunning := false ;
  FLast    := 0 ;
  FLastOk  := 0 ;
  FNext    := 0 ;
  FOk      := false ;
  FError   := '' ;
  FWarning := '' ;
  FOverTime := 86400 ;
  FLevel   := logNone ;

  FEventPanel := nil ;
end;

destructor TTask.Destroy;
begin
  inherited ;
end;

procedure TTask.evalStatus;
var
  vStatus : TTaskStatus ;
  vLogLevel : TLogLevel ;
  vHint     : string ;
begin
  vStatus := tsDisabled ;
  vLogLevel := logDebug ;   // Conseil : H2077 à la construction sans aucune raison => BUG des conseils du COMPILATEUR
  vHint := '' ;

  if FEnabled then
  begin
    if FRunning then
    begin
      vStatus := tsRunning ;
    end else begin
      vStatus := tsStoppped ;
    end;
  end;

  FStatus := vStatus ;

  if (not FEnabled) then
  begin
    vLogLevel := logTrace ;
  end else begin
    if FRunning then
    begin
      vLogLevel := logNotice ;
    end else begin

      if FOverTime > 0 then
      begin
        if (Now - FLastOk) > (FOverTime /86400) then
        begin
          vLogLevel := logError ;
        end else begin
          if FOk  then
          begin
            vLogLevel := logInfo
          end else begin
            vLogLevel := logWarning ;
            if FError <> ''
              then vLogLevel := logError ;
          end;
        end;
      end else begin
          if FOk  then
          begin
            vLogLevel := logInfo
          end else begin
            vLogLevel := logWarning ;
            if FError <> ''
              then vLogLevel := logError ;
          end;
      end;
    end;

    if FOk then
    begin
      if FLastOk > 0
        then vHint := vHint + 'Dernière tentative réussie le : ' + FormatDateTime('dd/mm/yyyy à hh:nn:ss', FLastOk) + #13#10 ;
    end else begin
      if FError <> ''
        then vHint := vHint + 'Erreur : ' + FError + #13#10 ;
      if FLast > 0
        then vHint := vHint + 'Dernière tentative le : ' + FormatDateTime('dd/mm/yyyy à hh:nn:ss', FLast) + #13#10 ;
      if FLastOk > 0
        then vHint := vHint + 'Dernier tentative réussie : ' + FormatDateTime('dd/mm/yyyy à hh:nn:ss', FLastOk) + #13#10 ;
    end;

    if Fnext > 0
      then vHint := vHint + 'Prochaine tentative le : ' + FormatDateTime('dd/mm/yyyy à hh:nn:ss', FNext) + #13#10 ;

    if FLastOk > 0
      then FEventPanel.Detail := 'Dernière réussite :' + #13#10 + FormatDateTime('dd/mm/yyyy hh:nn', FLastOk) ;
  end;

  if FLevel <> vLogLevel then
  begin
    FLevel := vLogLevel ;
    FSend := true ;
  end;

  if Assigned(FEventPanel) then
  begin
    FEventPanel.ShowHint := true ;
    FEventPanel.Hint := vHint ;
    FEventPanel.Level := vLogLevel ;
    FEventPanel.Visible := FEnabled ;
  end;

  sendLog;
  Application.ProcessMessages ;
end;


procedure TTask.sendLog ;
begin
  if FSend = true then
  begin
    if (FError <> '')
      then Log.Log(FName, FReference, 'Status', FError, uLog.TLogLevel(Level), true, 0, ltServer)
      else Log.Log(FName, FReference, 'Status', FWarning, uLog.TLogLevel(Level), true, 0, ltServer) ;
  end;

  FSend := false ;
end;

procedure TTask.setEnabled(const Value: boolean);
begin
    if Value = FEnabled then Exit ;

    FEnabled := Value;
    fSend := True ;

    evalStatus ;
end;

procedure TTask.setError(const Value: string);
begin
  if Value = FError then Exit ;

  FError := Value;
  if FError <> '' then
  begin
    FWarning := '' ;
    FOk := false ;
  end;

  fSend := true ;

  evalStatus ;
end;

procedure TTask.setWarning(const Value: string);
begin
  if Value = FWarning then Exit ;

  FWarning := Value;
  if FWarning <> '' then FOk := false ;

  fSend := true ;

  evalStatus ;
end;

procedure TTask.setLast(const Value: TDateTime);
begin
  if Value = FLast  then Exit;

  FLast := Value;
  evalStatus ;

  Log.Log(FName, FReference, 'dteLast', DateTimeToIso8601(FLast), logInfo, true, 0, ltServer) ;
end;

procedure TTask.setLastOk(const Value: TDateTime);
begin
  if Value = FLastOk  then Exit;

  FLastOk := Value;
  evalStatus ;

  Log.Log(FName, FReference, 'dteLastOk', DateTimeToIso8601(FLastOk), logInfo, true, 0, ltServer) ;
end;

procedure TTask.setNext(const Value: TDateTime);
begin
  if Value = FNext  then Exit;

  FNext := Value;
  evalStatus ;
end;

procedure TTask.setOk(const Value: boolean);
begin
  if (FOk <> Value) then
  begin
    FOk := Value;
    if FOk then
    begin
      FWarning := '' ;
      FError := '';
    end;

    fSend := true ;

    evalStatus ;
  end;
end;

procedure TTask.setOverTime(const Value: Integer);
begin
  FOverTime := Value;
  evalStatus ;
end;

procedure TTask.setRunning(const Value: boolean);
begin
  if (FRunning <> Value) then
  begin
    FRunning := Value;
    evalStatus ;
  end;
end;


end.
