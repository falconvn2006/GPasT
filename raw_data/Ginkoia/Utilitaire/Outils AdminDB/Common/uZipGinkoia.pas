unit uZipGinkoia;

interface

uses SysUtils, Classes, uSevenzip;


function ZipFile(Const AListFile: TStrings;
                 Const AZipName: String;
                 AZipFormat: String = '7z';
                 AZipPassWord : String = ''): Boolean;

function ZipFileWithPath(Const Dir, Path, Willcards: String;
                         Const recurse: boolean;
                         Const AZipName: String;
                         AZipFormat: String = '7z';
                         AZipPassWord : String = ''): Boolean;

function UnZipFile(Const AZipFile, ADestDir: String;
                   Const AZipName: String;
                   AZipFormat: String = '7z';
                   AZipPassWord : String = ''): Boolean;


implementation

function ZipFile(Const AListFile: TStrings;
  Const AZipName: String;
  AZipFormat: String = '7z';
  AZipPassWord : String = ''): Boolean;
var
  i: integer;
  vZip: I7zOutArchive;
  vTmp: TGuid;
begin
  Result := False;
  if AListFile.Count = 0 then
    Exit;
  if AZipFormat = 'Zip' then
    vTmp := CLSID_CFormatZip
  else
    vTmp := CLSID_CFormat7z;

  vZip:= CreateOutArchive(vTmp);
  try
    if AZipPassWord <> '' then
      vZip.SetPassword(AZipPassWord);

    SetCompressionLevel(vZip, 4);   //SR - 06/03/2014 : Ajout du taux

    for i:= 0 to AListFile.Count -1 do
      vZip.AddFile(AListFile.Strings[i], ExtractFileName(AListFile.Strings[i]));
    vZip.SaveToFile(AZipName);
    Result:= True;
  except on E:Exception do
    raise Exception.Create('ZipFile -> ' + E.Message);
  end;
end;

function UnZipFile(Const AZipFile, ADestDir: String;
  Const AZipName: String;
  AZipFormat: String = '7z';
  AZipPassWord : String = ''): Boolean;
var
  vZip: I7zInArchive;
  vTmp: TGuid;
begin
  Result := False;
  if AZipFormat = 'Zip' then
    vTmp := CLSID_CFormatZip
  else
    vTmp := CLSID_CFormat7z;

  vZip:= CreateInArchive(vTmp);
  try
    if AZipPassWord <> '' then
      vZip.SetPassword(AZipPassWord);

    vZip.OpenFile(AZipFile);
    vZip.ExtractTo(ExtractFilePath(ADestDir));
    Result:= True;
  except on E:Exception do
    raise Exception.Create('UnZipFile -> ' + E.Message);
  end;
end;

function ZipFileWithPath(Const Dir, Path, Willcards: String;
  Const recurse: boolean;
  Const AZipName: String;
  AZipFormat: String = '7z';
  AZipPassWord : String = ''): Boolean;
var
  vZip: I7zOutArchive;
  vTmp: TGuid;
begin
  Result := False;

  if AZipFormat = 'Zip' then
    vTmp := CLSID_CFormatZip
  else
    vTmp := CLSID_CFormat7z;

  vZip:= CreateOutArchive(vTmp);
  try
    if AZipPassWord <> '' then
      vZip.SetPassword(AZipPassWord);

    vZip.AddFiles(Dir, Path, Willcards, recurse);
    vZip.SaveToFile(AZipName);
    Result:= True;
  except on E:Exception do
    raise Exception.Create('ZipFile -> ' + E.Message);
  end;
end;

end.
