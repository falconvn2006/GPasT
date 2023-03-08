unit uHexToStr;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function StringToHex(str: string): string;
function HexToString(str: string): string;

implementation
//-----------------------------------------------
//16进制字符转整数,16进制字符与字符串转换中间函数
//-----------------------------------------------
function HexToInt(hex: string): integer;
var
  i: integer;

  function Ncf(num, f: integer): integer;
  var
    i: integer;
  begin
    Result := 1;
    if f = 0 then
      exit;
    for i := 1 to f do
      Result := Result * num;
  end;

  function HexCharToInt(HexToken: char): integer;
  begin
    if HexToken > #97 then
      HexToken := Chr(Ord(HexToken) - 32);
    Result := 0;
    if (HexToken > #47) and (HexToken < #58) then { chars 0....9 }
      Result := Ord(HexToken) - 48
    else if (HexToken > #64) and (HexToken < #71) then { chars A....F }
      Result := Ord(HexToken) - 65 + 10;
  end;

begin
  Result := 0;
  hex := AnsiUpperCase(trim(hex));
  if hex = '' then
    exit;
  for i := 1 to length(hex) do
    Result := Result + HexCharToInt(hex[i]) * ncf(16, length(hex) - i);
end;



//-----------------------------------------------
//字符串转16进制字符
//-----------------------------------------------
function StringToHex(str: string): string;
var
  i: integer;
begin
  Result := EmptyStr;
  for i := 1 to length(str) do
  begin
    Result := Result + IntToHex(integer(str[i]), 2);
  end;
end;



//-----------------------------------------------
//16进制字符转字符串
//-----------------------------------------------
function HexToString(str: string): string;
var
  s, t: string;
  i: integer;
begin
  s := EmptyStr;
  i := 1;
  while i < length(str) do
  begin
    t := str[i] + str[i + 1];
    s := s + chr(HexToInt(t));
    i := i + 2;
  end;
  Result := s;
end;

end.
