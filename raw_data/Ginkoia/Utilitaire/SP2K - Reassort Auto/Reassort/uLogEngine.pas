unit uLogEngine;

interface

uses
  uLog, Classes;

type
  TLogModule = type String;
  TLogDossier = type String;
  TLogRef = type String;
  TLogKey = type String;
  TLogVal = type String;
  TLogOverride = type Boolean;

  TLogEngine = record
  private type
    Default = record
    type
      Notice = record
      const
        Value = 'Tentative...';
        Override = False;
      end;
      Info = record
      const
        Value = 'Réussie';
        Override = True;
      end;
      Error = record
      const
        Value = 'Réussie';
        Override = True;
      end;
    end;
  private
    class procedure Common(const LogModule, LogDossier, LogRef, LogKey, LogVal: String; const LogLevel: TLogLevel; const Override: Boolean); static;
  public
    {$REGION 'Notice'}
    class procedure Notice(const LogModule: TLogModule; const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey; const LogVal: TLogVal; const Override: TLogOverride = Default.Notice.Override); overload; static;
    class procedure Notice(const LogModule: TLogModule; const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey; const Format: String; const Args: array of const; const Override: TLogOverride = Default.Notice.Override); overload; static;
    class procedure Notice(const LogModule: TLogModule; const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey; const Override: TLogOverride = Default.Notice.Override); overload; static;

    class procedure Notice(const LogRef: TLogRef; const LogKey: TLogKey; const LogVal: TLogVal; const Override: TLogOverride = Default.Notice.Override); overload; static;
    class procedure Notice(const LogRef: TLogRef; const LogKey: TLogKey; const Format: String; const Args: array of const; const Override: TLogOverride = Default.Notice.Override); overload; static;

    class procedure Notice(const LogKey: TLogKey; const LogVal: TLogVal; const Override: TLogOverride = Default.Notice.Override); overload; static;
    class procedure Notice(const LogKey: TLogKey; const Format: String; const Args: array of const; const Override: TLogOverride = Default.Notice.Override); overload; static;
    class procedure Notice(const LogKey: TLogKey; const Override: TLogOverride = Default.Notice.Override); overload; static;
    {$ENDREGION}
    {$REGION 'Info'}
    class procedure Info(const LogModule: TLogModule; const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey; const LogVal: TLogVal; const Override: TLogOverride = Default.Info.Override); overload; static;
    class procedure Info(const LogModule: TLogModule; const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey; const Format: String; const Args: array of const; const Override: TLogOverride = Default.Info.Override); overload; static;
    class procedure Info(const LogModule: TLogModule; const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey; const Override: TLogOverride = Default.Info.Override); overload; static;

    class procedure Info(const LogRef: TLogRef; const LogKey: TLogKey; const LogVal: TLogVal; const Override: TLogOverride = Default.Info.Override); overload; static;
    class procedure Info(const LogRef: TLogRef; const LogKey: TLogKey; const Format: String; const Args: array of const; const Override: TLogOverride = Default.Info.Override); overload; static;

    class procedure Info(const LogKey: TLogKey; const LogVal: TLogVal; const Override: TLogOverride = Default.Info.Override); overload; static;
    class procedure Info(const LogKey: TLogKey; const Format: String; const Args: array of const; const Override: TLogOverride = Default.Info.Override); overload; static;
    class procedure Info(const LogKey: TLogKey; const Override: TLogOverride = Default.Info.Override); overload; static;
    {$ENDREGION}
    {$REGION 'Info'}
    class procedure Error(const LogModule: TLogModule; const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey; const LogVal: TLogVal; const Override: TLogOverride = Default.Error.Override); overload; static;
    class procedure Error(const LogModule: TLogModule; const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey; const Format: String; const Args: array of const; const Override: TLogOverride = Default.Error.Override); overload; static;
    class procedure Error(const LogModule: TLogModule; const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey; const Override: TLogOverride = Default.Error.Override); overload; static;
    {$ENDREGION}
    class procedure Error(const LogRef: TLogRef; const LogKey: TLogKey; const LogVal: TLogVal; const Override: TLogOverride = Default.Error.Override); overload; static;
    class procedure Error(const LogRef: TLogRef; const LogKey: TLogKey; const Format: String; const Args: array of const; const Override: TLogOverride = Default.Error.Override); overload; static;

    class procedure Error(const LogKey: TLogKey; const LogVal: TLogVal; const Override: TLogOverride = Default.Error.Override); overload; static;
    class procedure Error(const LogKey: TLogKey; const Format: String; const Args: array of const; const Override: TLogOverride = Default.Error.Override); overload; static;
    class procedure Error(const LogKey: TLogKey; const Override: TLogOverride = Default.Info.Override); overload; static;
  public class var
    Strings: TStrings;
  end;

//  function AppVersion: String; inline;

implementation

uses
  SysUtils, Windows, Dialogs, Forms;


{ TLogEngine }

class procedure TLogEngine.Common(const LogModule, LogDossier, LogRef, LogKey,
  LogVal: String; const LogLevel: TLogLevel; const Override: Boolean);
var
  Msg: String;
begin
  Msg := Format(
    '{"srv":"%s","mdl":"%s","dos":"%s","ref":"%s","key":"%s","val":"%s","lvl":%d,"ovl":%d}', [
      Log.Host, LogModule, LogDossier, LogRef, LogKey, LogVal, Ord( LogLevel ), Ord( Override )
    ]
  );
  {$IFDEF DEBUG}
  if Assigned( TLogEngine.Strings ) then
    TLogEngine.Strings.Add( Msg )
  else
    with CreateMessageDialog( Msg, mtInformation, [ mbClose ], mbClose ) do
      try
        Caption := Concat( Application.Title, ' - Monitoring' );
        Position := poMainFormCenter;
        ShowModal;
      finally
        Free;
      end;
  {$ELSE}
//  Log.Log( Log.Host, LogModule, LogDossier, LogRef, LogKey, LogVal, LogLevel, Override );
  {$ENDIF}
end;

class procedure TLogEngine.Notice(const LogModule: TLogModule;
  const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey;
  const LogVal: TLogVal; const Override: TLogOverride);
begin
  TLogEngine.Common( LogModule, LogDossier, LogRef, LogKey, LogVal, TLogLevel.logNotice, Override );
end;

class procedure TLogEngine.Notice(const LogKey: TLogKey; const LogVal: TLogVal;
  const Override: TLogOverride);
begin
  TLogEngine.Notice( SysUtils.EmptyStr, LogKey, LogVal, Override );
end;

class procedure TLogEngine.Info(const LogModule: TLogModule;
  const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey;
  const LogVal: TLogVal; const Override: TLogOverride);
begin
  TLogEngine.Common( LogModule, LogDossier, LogRef, LogKey, LogVal, TLogLevel.logInfo, Override );
end;

class procedure TLogEngine.Info(const LogKey: TLogKey; const LogVal: TLogVal;
  const Override: TLogOverride);
begin
  TLogEngine.Info( SysUtils.EmptyStr, LogKey, LogVal, Override );
end;

class procedure TLogEngine.Error(const LogModule: TLogModule;
  const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey;
  const LogVal: TLogVal; const Override: TLogOverride);
begin
  TLogEngine.Common( LogModule, LogDossier, LogRef, LogKey, LogVal, TLogLevel.logError, Override );
end;

class procedure TLogEngine.Error(const LogKey: TLogKey; const LogVal: TLogVal;
  const Override: TLogOverride);
begin
  TLogEngine.Error( SysUtils.EmptyStr, LogKey, LogVal, Override );
end;

class procedure TLogEngine.Notice(const LogKey: TLogKey; const Override: TLogOverride);
begin
  TLogEngine.Notice( LogKey, Default.Notice.Value, Override );
end;

class procedure TLogEngine.Notice(const LogModule: TLogModule;
  const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey;
  const Override: TLogOverride);
begin
  TLogEngine.Notice( LogModule, LogDossier, LogRef, LogKey, Default.Notice.Value );
end;

class procedure TLogEngine.Notice(const LogRef: TLogRef; const LogKey: TLogKey;
  const LogVal: TLogVal; const Override: TLogOverride);
begin
  TLogEngine.Notice( SysUtils.EmptyStr, SysUtils.EmptyStr, LogRef, LogKey, LogVal, Override );
end;

class procedure TLogEngine.Notice(const LogRef: TLogRef; const LogKey: TLogKey;
  const Format: String; const Args: array of const;
  const Override: TLogOverride);
begin
  TLogEngine.Notice( LogRef, LogKey, SysUtils.Format( Format, Args ), Override );
end;

class procedure TLogEngine.Notice(const LogKey: TLogKey; const Format: String;
  const Args: array of const; const Override: TLogOverride);
begin
  TLogEngine.Notice( LogKey, SysUtils.Format( Format, Args ), Override );
end;

class procedure TLogEngine.Info(const LogKey: TLogKey;
  const Override: TLogOverride);
begin
  TLogEngine.Info( LogKey, Default.Info.Value, Override );
end;

class procedure TLogEngine.Info(const LogModule: TLogModule;
  const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey;
  const Override: TLogOverride);
begin
  TLogEngine.Info( LogModule, LogDossier, LogRef, LogKey, Default.Info.Value );
end;

class procedure TLogEngine.Info(const LogRef: TLogRef; const LogKey: TLogKey;
  const LogVal: TLogVal; const Override: TLogOverride);
begin
  TLogEngine.Info( SysUtils.EmptyStr, SysUtils.EmptyStr, LogRef, LogKey, LogVal, Override );
end;

class procedure TLogEngine.Info(const LogModule: TLogModule;
  const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey;
  const Format: String; const Args: array of const;
  const Override: TLogOverride);
begin
  TLogEngine.Info( LogModule, LogDossier, LogRef, LogKey, SysUtils.Format( Format, Args ), Override );
end;

class procedure TLogEngine.Info(const LogKey: TLogKey; const Format: String;
  const Args: array of const; const Override: TLogOverride);
begin
  TLogEngine.Info( LogKey, SysUtils.Format( Format, Args ), Override );
end;

class procedure TLogEngine.Info(const LogRef: TLogRef; const LogKey: TLogKey;
  const Format: String; const Args: array of const;
  const Override: TLogOverride);
begin
  TLogEngine.Info( LogRef, LogKey, SysUtils.Format( Format, Args ), Override );
end;

class procedure TLogEngine.Notice(const LogModule: TLogModule;
  const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey;
  const Format: String; const Args: array of const;
  const Override: TLogOverride);
begin
  TLogEngine.Notice( LogModule, LogDossier, LogRef, LogKey, SysUtils.Format( Format, Args ), Override );
end;

class procedure TLogEngine.Error(const LogKey: TLogKey;
  const Override: TLogOverride);
begin
  TLogEngine.Error( LogKey, Default.Error.Value, Override );
end;

class procedure TLogEngine.Error(const LogModule: TLogModule;
  const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey;
  const Override: TLogOverride);
begin
  TLogEngine.Error( LogModule, LogDossier, LogRef, LogKey, Default.Error.Value );
end;

class procedure TLogEngine.Error(const LogRef: TLogRef; const LogKey: TLogKey;
  const LogVal: TLogVal; const Override: TLogOverride);
begin
  TLogEngine.Error( SysUtils.EmptyStr, SysUtils.EmptyStr, LogRef, LogKey, LogVal, Override );
end;

class procedure TLogEngine.Error(const LogModule: TLogModule;
  const LogDossier: TLogDossier; const LogRef: TLogRef; const LogKey: TLogKey;
  const Format: String; const Args: array of const;
  const Override: TLogOverride);
begin
  TLogEngine.Error( LogModule, LogDossier, LogRef, LogKey, SysUtils.Format( Format, Args ), Override );
end;

class procedure TLogEngine.Error(const LogKey: TLogKey; const Format: String;
  const Args: array of const; const Override: TLogOverride);
begin
  TLogEngine.Error( LogKey, SysUtils.Format( Format, Args ), Override );
end;

class procedure TLogEngine.Error(const LogRef: TLogRef; const LogKey: TLogKey;
  const Format: String; const Args: array of const;
  const Override: TLogOverride);
begin
  TLogEngine.Error( LogRef, LogKey, SysUtils.Format( Format, Args ), Override );
end;

initialization
  TLogEngine.Strings := nil;

finalization
  TLogEngine.Strings := nil;

end.

