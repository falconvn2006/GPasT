{ ******************************************************************************
  Title: Util
  Description: Funções de Utilidades

  @author Fabiano Morais (fcpm_mike@hotmail.com)
  @add initial
  **************************************************************************** }
unit initialPascal.Util;

interface

uses
  fileinfo;

type

  { TUtil }

  TUtil = class
    class function VersionExe: String;
  end;

implementation

class function TUtil.VersionExe: String;
var
  FileVerInfo: TFileVersionInfo;
begin
  FileVerInfo:=TFileVersionInfo.Create(nil);
  try
    FileVerInfo.ReadFileInfo;
    //writeln('Company: ',FileVerInfo.VersionStrings.Values['CompanyName']);
    //writeln('File description: ',FileVerInfo.VersionStrings.Values['FileDescription']);
    //writeln('File version: ',FileVerInfo.VersionStrings.Values['FileVersion']);
    //writeln('Internal name: ',FileVerInfo.VersionStrings.Values['InternalName']);
    //writeln('Legal copyright: ',FileVerInfo.VersionStrings.Values['LegalCopyright']);
    //writeln('Original filename: ',FileVerInfo.VersionStrings.Values['OriginalFilename']);
    //writeln('Product name: ',FileVerInfo.VersionStrings.Values['ProductName']);
    Result := FileVerInfo.VersionStrings.Values['FileVersion'];
  finally
    FileVerInfo.Free;
  end;
end;

end.
