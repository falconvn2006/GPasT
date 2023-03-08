unit winsmall;

interface

function GetDiskFreeSpace(lpRootPathName: PChar;
  var lpSectorsPerCluster, lpBytesPerSector, lpNumberOfFreeClusters, lpTotalNumberOfClusters: LongWord): LongBool; stdcall;

function DeleteFile(lpFileName: PChar): LongBool; stdcall;
{$EXTERNALSYM DeleteFile}
function GetTickCount: LongWord; stdcall;
{$EXTERNALSYM GetTickCount}
function GetDiskFreeSpaceEx(lpDirectoryName: PChar;
  var lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes; lpTotalNumberOfFreeBytes: Pointer): LongBool; stdcall;

function CreateFile(lpFileName: PChar; dwDesiredAccess, dwShareMode: LongWord;
  lpSecurityAttributes: Pointer; dwCreationDisposition, dwFlagsAndAttributes: LongWord;
  hTemplateFile: LongWord): LongWord; stdcall;
{$EXTERNALSYM CreateFile}
function WriteFile(hFile: LongWord; const Buffer; nNumberOfBytesToWrite: LongWord;
  var lpNumberOfBytesWritten: LongWord; lpOverlapped: Pointer): LongBool; stdcall;
{$EXTERNALSYM WriteFile}
function CloseHandle(hObject: LongWord): LongBool; stdcall;
{$EXTERNALSYM CloseHandle}

implementation

function DeleteFile; external 'kernel32.dll' name 'DeleteFileA';
function GetTickCount; external 'kernel32.dll' name 'GetTickCount';
function GetDiskFreeSpaceEx; external 'kernel32.dll' name 'GetDiskFreeSpaceExA';
function CreateFile; external 'kernel32.dll' name 'CreateFileA';
function WriteFile; external 'kernel32.dll' name 'WriteFile';
function CloseHandle; external 'kernel32.dll' name 'CloseHandle';
function GetDiskFreeSpace; external 'kernel32.dll' name 'GetDiskFreeSpaceA';

end.
