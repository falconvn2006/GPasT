unit Tools;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

function FixPath(S: string): string;
function RemoveFileExt(S: string): string;

var
  cfgFile: string;
  AppPath: string;



implementation

function FixPath(S: string): string;
begin
  if RightStr(S, 1) <> PathDelim then
  begin
    Result := S + PathDelim;
  end
  else
  begin
    Result := S;
  end;
end;

function RemoveFileExt(S: string): string;
var
  sPos: integer;
begin
  sPos := Pos('.', S);
  if sPos > 0 then
  begin
    Result := LeftStr(S, sPos - 1);
  end
  else
  begin
    Result := S;
  end;
end;

end.
