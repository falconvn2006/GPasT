unit Misc;

interface

function GetBaseCaption:string;
function GetBaseKey:string;
function GetInstallDateKey:string;

implementation

function GetBaseCaption:string;
begin
{$IfDef TRIZ_MODE}
  Result:='СИРС-9.0. Математика. Профильный уровень';
{$Else}
  Result:='СИРС-9.0. Математика. Профильный уровень';
  //Result:='Олимпиадная подготовка по математике для начальных и средних классов';
{$EndIf}
end;

function GetBaseKey:string;
begin
{$IfDef TRIZ_MODE}
  Result:='Software\Burov A N\Triz';
{$Else}
  Result:='Software\Burov A N\Logic';
{$EndIf}
end;

function GetInstallDateKey:string;
begin
{$IfDef TRIZ_MODE}
  Result:='TGUID';
{$Else}
  Result:='LGUID';
{$EndIf}
end;
end.
