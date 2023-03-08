/// <summary>
/// Gestion de la journalisation des exceptions.
/// </summary>
unit uCallStack;

interface

implementation

uses
  System.Classes,
  System.SysUtils,
  Winapi.Windows,
  JclDebug,
  JclHookExcept;

procedure HookGlobalException(ExceptObj: TObject; ExceptAddr: Pointer; OSException: Boolean);

  function GetApplicationFileName(): string;
  begin
    SetLength(Result, MAX_PATH + 1);
    GetModuleFileName(HInstance, PChar(Result), MAX_PATH);
    SetLength(Result, Length(PChar(Result)));
  end;

  function ReadFileVersion(Fichier: string): string;
  var
    Dummy       : DWORD;
    Info        : Pointer;
    InfoSize    : Cardinal;
    VerValue    : PVSFixedFileInfo;
    InfoDataSize: Cardinal;
  begin
    Result := '';

    if Trim(Fichier) = '' then
      Fichier := GetApplicationFileName();
    if FileExists(Fichier) then
    begin
      InfoSize := GetFileVersionInfoSize(PChar(Fichier), Dummy);
      GetMem(Info, InfoSize);
      try
        if GetFileVersionInfo(PChar(Fichier), Dummy, InfoSize, Info) then
        begin
          if VerQueryValue(Info, '\', Pointer(VerValue), InfoDataSize) then
          begin
            Result := IntToStr(VerValue^.dwFileVersionMS shr 16);
            Result := Result + '.' + IntToStr(VerValue^.dwFileVersionMS and $FFFF);
            Result := Result + '.' + IntToStr(VerValue^.dwFileVersionLS shr 16);
            Result := Result + '.' + IntToStr(VerValue^.dwFileVersionLS and $FFFF);
          end;
        end;
      finally
        FreeMem(Info, InfoSize);
      end;
    end;
  end;

var
  FileName     : string;
  FileVersion  : string;
  ExceptionFile: TStringList;
begin
  FileName    := GetApplicationFileName();
  FileVersion := ReadFileVersion(FileName);

  try
    ExceptionFile := TStringList.Create();
    ExceptionFile.Add(DateTimeToStr(Now));
    ExceptionFile.Add(Exception(ExceptObj).ClassName);
    ExceptionFile.Add(Exception(ExceptObj).Message);
    ExceptionFile.Add('');
    ExceptionFile.Add('Fichier  : ' + FileName);
    ExceptionFile.Add('Version  : ' + FileVersion);
    ExceptionFile.Add('Commande : ' + CmdLine);
    ExceptionFile.Add('');

    JclLastExceptStackListToStrings(ExceptionFile, False, False, False, False);
    ForceDirectories(IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(FileName)) + 'Exceptions'));
    ExceptionFile.SaveToFile(IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(FileName)) + 'Exceptions') + ExtractFileName(FileName) + '_' +
        FormatDateTime('yyyy-mm-dd-hh-nn-ss-zzz', Now()) + '.log');
  finally
    FreeAndNil(ExceptionFile);
  end;
end;

initialization

Include(JclStackTrackingOptions, stRawMode);
Include(JclStackTrackingOptions, stStaticModuleList);
JclStartExceptionTracking();

JclAddExceptNotifier(HookGlobalException, npFirstChain);
JclHookExceptions();

finalization

JclUnhookExceptions();
JclStopExceptionTracking();

end.
