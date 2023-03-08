unit uApplicationVersion;
// http://delphihaven.wordpress.com/2012/12/08/retrieving-the-applications-version-string/

interface

function GetAppVersionStr: string;
function GetAppVersionStrFull: string;

implementation

uses
  System.SysUtils,
  Winapi.Windows;

function GetAppVersionStr: string;
var
  Rec: LongRec;
begin
  Rec    := LongRec(GetFileVersion(ParamStr(0)));
  Result := Format('%d.%d', [Rec.Hi, Rec.Lo])
end;

function GetAppVersionStrFull: string;
var
  Exe         : string;
  Size, Handle: DWORD;
  Buffer      : TBytes;
  FixedPtr    : PVSFixedFileInfo;
begin
  Exe  := ParamStr(0);
  Size := GetFileVersionInfoSize(PChar(Exe), Handle);
  if Size = 0 then
    RaiseLastOSError;
  SetLength(Buffer, Size);
  if not GetFileVersionInfo(PChar(Exe), Handle, Size, Buffer) then
    RaiseLastOSError;
  if not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
    RaiseLastOSError;
  Result := Format('%d.%d.%d.%d',
    [LongRec(FixedPtr.dwFileVersionMS).Hi,   // major
      LongRec(FixedPtr.dwFileVersionMS).Lo,  // minor
      LongRec(FixedPtr.dwFileVersionLS).Hi,  // release
      LongRec(FixedPtr.dwFileVersionLS).Lo]) // build
end;

end.
