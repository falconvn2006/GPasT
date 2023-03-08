unit uVersion;

interface

uses
  System.SysUtils, Winapi.Windows;

type
  TVersionField = ( vfMajor, vfMinor, vfRelease, vfBuild );
  TVersionFields = set of TVersionField;

const
  DetailVersion = [ vfMajor, vfMinor, vfRelease, vfBuild ];
  CommonVersion = [ vfMajor, vfMinor ];

// https://delphihaven.wordpress.com/2012/12/08/retrieving-the-applications-version-string/
function GetAppVersion(const VersionFields: TVersionFields = DetailVersion ): String;

implementation

procedure GetAppCommonVersion(out Major, Minor: Word);
var
  Rec: LongRec;
begin
  Rec := LongRec(GetFileVersion(ParamStr(0)));
  Major := Rec.Hi;
  Minor := Rec.Lo;
end;

procedure GetAppDetailVersion(out Major, Minor, Release, Build: Word);
var
  Exe: String;
  Size, Handle: DWORD;
  Buffer: TBytes;
  FixedPtr: PVSFixedFileInfo;
begin
  Exe := ParamStr(0);
  Size := GetFileVersionInfoSize(PChar(Exe), Handle);
  if Size = 0 then
    RaiseLastOSError;
  SetLength(Buffer, Size);
  if not GetFileVersionInfo(PChar(Exe), Handle, Size, Buffer) then
    RaiseLastOSError;
  if not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
    RaiseLastOSError;
  Major := LongRec(FixedPtr.dwFileVersionMS).Hi;
  Minor := LongRec(FixedPtr.dwFileVersionMS).Lo;
  Release := LongRec(FixedPtr.dwFileVersionLS).Hi;
  Build := LongRec(FixedPtr.dwFileVersionLS).Lo;
end;

function GetAppVersion(const VersionFields: TVersionFields): String;
  function IfThen(AValue: Boolean; const ATrue: string;
    AFalse: string = ''): string;
  begin
    if AValue then
      Result := ATrue
    else
      Result := AFalse;
  end;
var
  Major, Minor, Release, Build: Word;
begin
  if VersionFields * [ vfRelease, vfBuild ] = [] then
    GetAppCommonVersion( Major, Minor )
  else
    GetAppDetailVersion( Major, Minor, Release, Build );

  Result := '';
  if vfMajor in VersionFields then
    Result := Concat( Result, {IfThen( Result <> '', '.' ),} Major.ToString );
  if vfMinor in VersionFields then
    Result := Concat( Result, IfThen( Result <> '', '.' ), Minor.ToString );
  if vfRelease in VersionFields then
    Result := Concat( Result, IfThen( Result <> '', '.' ), Release.ToString );
  if vfBuild in VersionFields then
    Result := Concat( Result, IfThen( Result <> '', '.' ), Build.ToString );
end;

end.
