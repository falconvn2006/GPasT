unit Ufuncoes;

interface

uses
  System.SysUtils, System.Classes, Data.FMTBcd, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.IB, FireDAC.Phys.IBDef,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLite, FireDAC.Comp.UI, FireDAC.Phys.IBBase,
  System.Bindings.Outputs, strutils, Math,
  System.Types, System.UITypes, FMX.Dialogs, System.IOUtils,
  System.Variants, Data.DbxDatasnap, IPPeerClient, Data.DBXCommon, Data.SqlExpr,
  Datasnap.DBClient, Datasnap.DSConnect, uproxy;

function TiraZeros(sNum: String; bRetornaErro: Boolean = True): String;
function Verificacpf(scpf: string): Boolean;
function ValidaEMail(const aStr: string): Boolean;
function LPad(value: string; tamanho: Integer; caractere: char): string;

implementation

function TiraZeros(sNum: String; bRetornaErro: Boolean): String;
begin
  Result := '';

  try
    Result := IntToStr(StrToInt(sNum));
  except
    on e: Exception do
      if (sNum <> '') and (bRetornaErro = True) then
        ShowMessage('Número informado inválido' + #13#13 + e.Message)
  end;
end;

function Verificacpf(scpf: string): Boolean;

const
  ignorelist: array [0 .. 10] of string = ('00000000000', '01234567890',
    '11111111111', '22222222222', '33333333333', '44444444444', '55555555555',
    '66666666666', '77777777777', '88888888888', '99999999999');
var
  i, d1, d2, r1, r2: Integer;
  cpf: string;
begin
  d1 := 0;
  d2 := 0;

{$IFDEF win32 or win64}
  for i := 1 to length(scpf) do
  begin
    if (scpf[i] in ['0' .. '9']) then
      cpf := cpf + scpf[i];
  end;

  if (length(cpf) <> 11) then
  begin
    Result := False;
    Exit;
  end;

  for i := low(ignorelist) to high(ignorelist) do
  begin
    if (cpf = ignorelist[i]) then
    begin
      Result := False;
      Exit;
    end;
  end;

  for i := 1 to 9 do
    d1 := d1 + (StrToInt(cpf[i]) * (11 - i));

  r1 := d1 mod 11;

  if (r1 > 1) then
    d1 := 11 - r1
  else
    d1 := 0;

  for i := 1 to 9 do
  begin
    d2 := d2 + (StrToInt(cpf[i]) * (12 - i));
  end;

  r2 := (d2 + (d1 * 2)) mod 11;

  if (r2 > 1) then
    d2 := 11 - r2
  else
    d2 := 0;

  if ((cpf[10] + cpf[11]) = (IntToStr(d1) + IntToStr(d2))) then
    Result := True
  else
    Result := False;
{$ENDIF}
{$IFDEF Android}
  for i := 0 to length(scpf) do
  begin
    if (scpf[i] in ['0' .. '9']) then
      cpf := cpf + scpf[i];
  end;

  if (length(cpf) <> 11) then
  begin
    Result := False;
    Exit;
  end;

  for i := low(ignorelist) to high(ignorelist) do
  begin
    if (cpf = ignorelist[i]) then
    begin
      Result := False;
      Exit;
    end;
  end;

  for i := 0 to 8 do
  begin
    d1 := d1 + (StrToInt(cpf[i]) * (10 - i));
    // str1:= str1 + ' '+ inttostr(d1) +' '  + cpf[i] +' * '+ inttostr((10-i)) + chr(13);
  end;

  r1 := (d1 * 10) mod 11;

  if (r1 = 10) then
    r1 := 0;

  for i := 0 to 9 do
  begin
    d2 := d2 + (StrToInt(cpf[i]) * (11 - i));
    // str2:= str2 + ' '+ inttostr(d2) +' '  + cpf[i] +' * '+ inttostr((11-i)) + chr(13);
  end;

  r2 := (d2 * 10) mod 11;

  // r2 := (d2 + (d1 * 2)) mod 11;

  if (r2 = 10) then
    d2 := 0;

  if ((cpf[9] + cpf[10]) = (IntToStr(r1) + IntToStr(r2))) then
    Result := True
  else
    Result := False;
{$ENDIF}
end;

function ValidaEMail(const aStr: string): Boolean;
const
  CaraEsp: array [1 .. 39] of string = ('!', '#', '$', '%', '¨', '&', '*', '(',
    ')', '+', '=', '§', '¬', '¢', '¹', '²', '³', '£', '´', '`', 'ç', 'Ç', ',',
    ';', ':', '<', '>', '~', '^', '?', '', '|', '[', ']', '{', ' }{ ', 'º',
    'ª', '°');
var
 cont: Integer;
  EMail: String;
begin

  EMail := Trim(UpperCase(aStr));
  if Pos('@', aStr) > 1 then
  begin
    Delete(EMail, 1, Pos('@', EMail));
    Result := (length(EMail) > 0) and (Pos('.', EMail) > 2);
  end
  else
    Result := False;

end;

function LPad(value: string; tamanho: Integer; caractere: char): string;
var
  i: Integer;
begin
  Result := value;
  if (length(value) > tamanho) then
    Exit;
  for i := 1 to (tamanho - length(value)) do
    Result := caractere + Result;
end;

end.
