unit uLogger;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, eventlog;

type

  { TLogger }

  TLogger = class
  private
    procedure WriteTo(EventType: TEventType; const AMsg: string);
    procedure WriteTo(EventType: TEventType; const Fmt: string; Args: array of const);
  public
    procedure Error(const AMsg: string);
    procedure Error(const Fmt: string; Args: array of const);
    procedure Warn(const AMsg: string);
    procedure Warn(const Fmt: string; Args: array of const);
    procedure Info(const AMsg: string);
    procedure Info(const Fmt: string; Args: array of const);
    procedure Debug(const AMsg: string);
    procedure Debug(const Fmt: string; Args: array of const);
  end;

var
  logger: TLogger = nil;

implementation

var
  hMutex: THandle;

{ TLogger }
function GetLogFileName: string;
var
  aDirName, aFileName: string;
begin
  aDirName := ConcatPaths([ExtractFileDir(ParamStr(0)), 'logs']);
  if not DirectoryExists(aDirName) then
  begin
    mkdir(aDirName);
  end;
  aFileName := ChangeFileExt(ExtractFileName(ParamStr(0)), FormatdateTime('yyyymmdd', now) + '.log');
  Result := ConcatPaths([aDirName, aFileName]);
end;

procedure TLogger.WriteTo(EventType: TEventType; const AMsg: string);
begin
  if WaitForSingleObject(hMutex, INFINITE) = WAIT_OBJECT_0 then
  begin
    with TEventLog.Create(nil) do
      try
        LogType := ltFile;
        FileName := GetLogFileName;
        AppendContent := FileExists(FileName);
        Active := True;
        Log(EventType, AMsg);
      finally
        Active := False;
        Free;
      end;
    ReleaseMutex(hMutex);
  end;
end;

procedure TLogger.WriteTo(EventType: TEventType; const Fmt: string; Args: array of const);
begin
  WriteTo(EventType, Format(Fmt, Args));
end;

procedure TLogger.Error(const AMsg: string);
begin
  WriteTo(etError, AMsg);
end;

procedure TLogger.Error(const Fmt: string; Args: array of const);
begin
  WriteTo(etError, Fmt, Args);
end;

procedure TLogger.Warn(const AMsg: string);
begin
  WriteTo(etWarning, AMsg);
end;

procedure TLogger.Warn(const Fmt: string; Args: array of const);
begin
  WriteTo(etWarning, Fmt, Args);
end;


procedure TLogger.Info(const AMsg: string);
begin
  WriteTo(etInfo, AMsg);
end;

procedure TLogger.Info(const Fmt: string; Args: array of const);
begin
  WriteTo(etInfo, Fmt, Args);
end;


procedure TLogger.Debug(const AMsg: string);
begin
  {$IFDEF DebugMode}
  WriteTo(etDebug, AMsg);
  {$ENDIF}
end;

procedure TLogger.Debug(const Fmt: string; Args: array of const);
begin
  {$IFDEF DebugMode}
  WriteTo(etDebug, Fmt, Args);
  {$ENDIF}
end;

initialization
  begin
    hMutex := CreateMutex(nil, False, nil);
    logger := TLogger.Create;
    logger.Debug('Starting Application ' + ExtractFileName(GetModuleName(HInstance)));
  end;

finalization
  begin
    logger.Debug('Terminating Application ' + ExtractFileName(GetModuleName(HInstance)));
    FreeAndNil(logger);
    CloseHandle(hMutex);
  end;

end.
