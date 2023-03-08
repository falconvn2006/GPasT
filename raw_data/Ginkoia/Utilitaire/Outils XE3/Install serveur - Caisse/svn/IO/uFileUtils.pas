unit uFileUtils;

interface

type
  TLineDetail = record
    Step     : string;
    Progress : string;
    FilePath : string;
    FileSize : integer;
  end;


function GetTempDirectory(Base : string = '') : String;
function GetFileSize(FileName : string) : Int64;
function GetDiskFreeSpace(Drive : char) : Int64;
function DelTree(DirName : string; nbTry : integer = 1; Wait : integer = 1000): Boolean;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  Vcl.StdCtrls,
  Vcl.Forms,
{$IFDEF DEBUG}
  System.UITypes,
  Vcl.Dialogs,
{$ENDIF}
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

function DelTree(DirName : string; nbTry : integer; Wait : integer): Boolean;
var
  numTry, res : integer;
  SHFileOpStruct : TSHFileOpStruct;
begin
  numTry := 1;
  repeat
    try
      Fillchar(SHFileOpStruct, Sizeof(SHFileOpStruct), 0);
      SHFileOpStruct.Wnd := 0;
      // Attention : les chemins doivent être double null terminé (en fait c'est une liste avec #0 entre les elements et #0#0 a la fin !!)
      SHFileOpStruct.pFrom := Pchar(ExcludeTrailingPathDelimiter(DirName) + #0#0);
      SHFileOpStruct.wFunc := FO_DELETE;
      SHFileOpStruct.fFlags := FOF_NOCONFIRMATION or FOF_SILENT;
      res := SHFileOperation(SHFileOpStruct);
{$IFDEF DEBUG}
      if (res <> 0) then
        MessageDlg('Erreur de suppression du repertoir "' + DirName + '" : ' + IntToStr(res) + ' - ' + SysErrorMessage(res), mtWarning, [mbOK], 0);
{$ENDIF}
      Result := (res = 0);
      // tentative
      Inc(NumTry);
      if not (Result or (numTry >= nbTry)) then
        Sleep(Wait * numTry);
    except
      Result := False;
    end;
  until Result or (numTry >= nbTry);
end;

end.
