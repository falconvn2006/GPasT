unit URecalcAgrPrin_Types;

interface

uses Classes, IniFiles, SysUtils, Forms;

type
  TIniStruct = record
    Path : string;
    Fichier : string;
    ExportExe : String;
    From, SendTo : string;
    END;

  procedure LoadIni;

  var
    IniStruct : TIniStruct;

implementation

{ TIniStruct }

PROCEDURE LoadIni;
begin
  With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    IniStruct.Path := ReadString('MAIN','DIR','');
    IniStruct.Path := IncludeTrailingBackslash(IniStruct.Path);
    IniStruct.Fichier   := ReadString('MAIN','FILE','');
    IniStruct.ExportExe := ReadString('MAIN','Export','');
    IniStruct.From      := ReadString('MAIN','From','');
    IniStruct.SendTo    := ReadString('MAIN','SendTo','');
  finally
    Free;
  end;
end;

end.
