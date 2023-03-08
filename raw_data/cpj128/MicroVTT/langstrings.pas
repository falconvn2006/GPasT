{Copyright (c) 2023 Stephan Breer

This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
}

unit LangStrings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function GetString(Lang, StrID: string): string;
function GetLanguages: TStrings;

var
  LanguageID: string;

implementation

uses
  IniFiles;

var
  FLangFile: TIniFile;

function GetString(Lang, StrID: string): string;
begin
  Result := StrID;
  if Assigned(FLangFile) then
    Result := FLangFile.ReadString(Lang, StrID, StrID);
end;

function GetLanguages: TStrings;
begin
  Result := TStringList.Create;
  FLangFile.ReadSections(Result);
end;

initialization
  LanguageID := 'English';
  FLangFile := TIniFile.Create('LangStrings.ini');

finalization
  FLangFile.Free;

end.

