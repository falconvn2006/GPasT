//------------------------------------------------------------------------------
// Nom de l'unité : UFindCmdLineSwitch
// Rôle           : Détermine si une chaîne a été transmise à l'application en tant qu'argument de ligne de commande.
// Auteur         : Lionel PLAIS
//
// Date       Nom           Description
// 11/03/2014 Lionel PLAIS  Reprise du code de Delphi XE
//------------------------------------------------------------------------------
unit UFindCmdLineSwitchEx;

interface

uses
  Windows, SysUtils;

{ FindCmdLineSwitch determines whether the string in the Switch parameter
  was passed as a command line argument to the application.  SwitchChars
  identifies valid argument-delimiter characters (i.e., "-" and "/" are
  common delimiters). The IgnoreCase paramter controls whether a
  case-sensistive or case-insensitive search is performed. }

const
  SwitchChars = {$IFDEF MSWINDOWS} ['/','-']; {$ENDIF}
                {$IFDEF LINUX}  ['-'];  {$ENDIF}
                {$IFDEF MACOS}  ['-'];  {$ENDIF}

function FindCmdLineSwitchEx(const Switch: string; const Chars: TSysCharSet;
  IgnoreCase: Boolean): Boolean; overload;

{ These versions of FindCmdLineSwitch are convenient for writing portable
  code.  The characters that are valid to indicate command line switches vary
  on different platforms.  For example, '/' cannot be used as a switch char
  on Linux because '/' is the path delimiter. }

{ This version uses SwitchChars defined above, and IgnoreCase False. }
function FindCmdLineSwitchEx(const Switch: string): Boolean; overload;

{ This version uses SwitchChars defined above. }
function FindCmdLineSwitchEx(const Switch: string; IgnoreCase: Boolean): Boolean; overload;

type
  TCmdLineSwitchType = (clstValueNextParam, clstValueAppended);
  TCmdLineSwitchTypes = set of TCmdLineSwitchType;

{ This version is used to return values.
  Switch values may be specified in the following ways on the command line:
    -p Value                - clstValueNextParam
    -pValue or -p:Value     - clstValueAppended

  Pass the SwitchTypes parameter to exclude either of these switch types.
  Switch may be 1 or more characters in length. }
function FindCmdLineSwitchEx(const Switch: string; var Value: string; IgnoreCase: Boolean = True;
  const SwitchTypes: TCmdLineSwitchTypes = [clstValueNextParam, clstValueAppended]): Boolean; overload;   

{ CharInSet tests whether or not the given character is in the given set of lower
  characters }

function CharInSet(C: AnsiChar; const CharSet: TSysCharSet): Boolean; overload; inline;
function CharInSet(C: WideChar; const CharSet: TSysCharSet): Boolean; overload; inline;

implementation

function FindCmdLineSwitchEx(const Switch: string; const Chars: TSysCharSet;
  IgnoreCase: Boolean): Boolean;
var
  I: Integer;
  S: string;
begin
  for I := 1 to ParamCount do
  begin
    S := ParamStr(I);
    if (Chars = []) or (S[1] in Chars) then
      if IgnoreCase then
      begin
        if (AnsiCompareText(Copy(S, 2, Maxint), Switch) = 0) then
        begin
          Result := True;
          Exit;
        end;
      end
      else begin
        if (AnsiCompareStr(Copy(S, 2, Maxint), Switch) = 0) then
        begin
          Result := True;
          Exit;
        end;
      end;
  end;
  Result := False;
end;

function FindCmdLineSwitchEx(const Switch: string): Boolean;
begin
  Result := FindCmdLineSwitchEx(Switch, SwitchChars, True);
end;

function FindCmdLineSwitchEx(const Switch: string; IgnoreCase: Boolean): Boolean;
begin
  Result := FindCmdLineSwitchEx(Switch, SwitchChars, IgnoreCase);
end;

function FindCmdLineSwitchEx(const Switch: string; var Value: string; IgnoreCase: Boolean = True;
  const SwitchTypes: TCmdLineSwitchTypes = [clstValueNextParam, clstValueAppended]): Boolean; overload;
type
  TCompareProc = function(const S1, S2: string): Boolean;
var
  Param: string;
  I, ValueOfs,
  SwitchLen, ParamLen: Integer;
  SameSwitch: TCompareProc;
begin
  Result := False;
  Value := '';
  if IgnoreCase then
    SameSwitch := SameText else
    SameSwitch := SameStr;
  SwitchLen := Length(Switch);

  for I := 1 to ParamCount do
  begin
    Param := ParamStr(I);
    if CharInSet(Param[1], SwitchChars) and SameSwitch(Copy(Param, 2, SwitchLen), Switch) then
    begin
      ParamLen := Length(Param);
      // Look for an appended value if the param is longer than the switch
      if (ParamLen > SwitchLen+1) then
      begin
        // If not looking for appended value switches then this is not a matching switch
        if not (clstValueAppended in SwitchTypes) then
          Continue;
        ValueOfs := SwitchLen + 2;
        if Param[ValueOfs] = ':' then
          Inc(ValueOfs);
        Value := Copy(Param, ValueOfs, MaxInt);
      end
      // If the next param is not a switch, then treat it as the value
      else if (clstValueNextParam in SwitchTypes) and (I < ParamCount) and
              not CharInSet(ParamStr(I+1)[1], SwitchChars) then
        Value := ParamStr(I+1);
      Result := True;
      Break;
    end;
  end;
end;

function CharInSet(C: AnsiChar; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;

function CharInSet(C: WideChar; const CharSet: TSysCharSet): Boolean;
begin
  Result := C in CharSet;
end;   

end.
