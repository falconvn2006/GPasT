unit IFC_Type;

interface

uses  SysUtils, Windows, Forms, Inifiles, Classes, StdCtrls,
      Dialogs, Graphics, Controls, Consts;

type
  TCFG = record
    Database : String;

  public
    Procedure LoadIni;
    Procedure SaveIni;
  end;


var
  GAPPPATH : String;
  IniCfg : TCFG;

  function DoCryptPass(APass : String) : String;
  function DoUnCryptPass(APass : String) : String;
implementation


function DoCryptPass(APass : String) : String;
var
  i : Integer;
begin
  Result := '';
  for i  := 1 to Length(APass) do
    Result := Result +IntToHex(Ord(APass[i]),2) + IntToHex(Random(255),2);
end;

function DoUnCryptPass(APass : String) : String;
var
  i : Integer;
begin
  Result := '';
  for i  := 1 to (Length(APass) Div 4) do
    Result := Result + Chr(StrToInt('$' + APass[(i - 1)* 4 + 1] + APass[(i -1) * 4 + 2]));
end;

{ TCFG }

procedure TCFG.LoadIni;
begin
  With TIniFile.Create(GAPPPATH + ChangeFileExt(ExtractFileName(Application.ExeName), '.ini')) do
  try
    Database := ReadString('DIR','DATABASE','');
  finally
    free;
  end;
end;

procedure TCFG.SaveIni;
begin
  With TIniFile.Create(GAPPPATH + ChangeFileExt(ExtractFileName(Application.ExeName), '.ini')) do
  try
    WriteString('DIR','DATABASE',Database);
  finally
    free;
  end;

end;

end.
