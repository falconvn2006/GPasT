unit UFileUtils;

interface

function GetTempDirectory(Base : string = '') : String;
function GetFileSize(FileName : string) : Int64;
function GetDiskFreeSpace(Drive : char) : Int64;
function DelTree(DirName : string): Boolean;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  Winapi.ShellAPI;

function GetTempDirectory(Base : string) : String;
var
  tempFolder: string;
begin
  Randomize();
  if Trim(Base) = '' then
    tempFolder := TPath.GetTempPath()
  else
    tempFolder := IncludeTrailingPathDelimiter(Base);
  repeat
    result := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(tempFolder) + IntToStr(Random(999999999)));
  until not DirectoryExists(Result);
end;

function GetFileSize(FileName : string) : Int64;
var
  FindStruc : TSearchRec;
begin
  Result := 0;
  try
    if FindFirst(FileName, faanyfile, FindStruc) = 0 THEN
      Result := FindStruc.Size;
  finally
    findClose(FindStruc);
  end;
end;

function GetDiskFreeSpace(Drive : char) : Int64;
begin
  Result := DiskFree(Ord(Drive) - ORD('A') + 1);
end;

function DelTree(DirName : string): Boolean;
var
  SHFileOpStruct : TSHFileOpStruct;
begin
  try
    Fillchar(SHFileOpStruct, Sizeof(SHFileOpStruct), 0);
    SHFileOpStruct.Wnd := 0;
    SHFileOpStruct.pFrom := Pchar(DirName);
    SHFileOpStruct.wFunc := FO_DELETE;
    SHFileOpStruct.fFlags := FOF_NOCONFIRMATION or FOF_SILENT;
    Result := (SHFileOperation(SHFileOpStruct) = 0);
  except
    Result := False;
  end;
end;

end.
