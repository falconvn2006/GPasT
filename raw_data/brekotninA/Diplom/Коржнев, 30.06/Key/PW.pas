unit PW;

interface

uses
  Windows, Forms, SysUtils, DateUtils, Registry;

{$IfDeF SIMPLE_PROTECT}
function EvaluateKey : string;
function ReadAccessCode : string;
procedure WriteAccessCode(accessCode: string);
function CheckAccessCode(key, accessCode: string) : boolean;
{$EndIf}
{$IfDeF STANDARD_PROTECT}
function EvaluateKey : string;
function ReadAccessCode : string;
procedure WriteAccessCode(accessCode: string);
function CheckAccessCode(key, accessCode: string) : boolean;
{$EndIf}

var
  GoodKey: boolean;
  Reg:TRegistry;

{$IfDeF STANDARD_PROTECT}
const
     ValidSerialChars = '6VFN3AEPQRXYG172IKLM45HBJ89ZSTUCDW';
     ValidKeyChars = '6F2HBJ89PQVRXN3AE17VYGZS53J8FNIKLM49ZQ172UHAEPDW6IBWCDKLTUCRXYGSTM45';
{$EndIf}

implementation
uses Misc;

function ReadAccessCode : string;
begin
  result := '';
  Reg := TRegistry.Create;
  Reg.OpenKey(GetBaseKey + '\Common', true);
  if Reg.ValueExists('RegKey') then
    result := Reg.ReadString('RegKey');
end;

procedure WriteAccessCode(accessCode: string);
begin
  Reg := TRegistry.Create;
  Reg.OpenKey(GetBaseKey + '\Common', true);
  Reg.WriteString('RegKey',accessCode);
  Reg.CloseKey;
end;

{$IfDeF SIMPLE_PROTECT}
function CRC8Hash(s: string) : Byte;
var
		i, j: Integer;
begin
		result := $ff;
  for i := Length(s) downto 1 do begin
  		result := result xor Ord(s[i]);
				for j := 0 to 7 do begin
					if (result and $80) <> 0 then
     		result := (result shl 1) xor $31
     else
     	result := result shl 1;
    end;
  end;
end;

function EvaluateKey : string;
var
	 FileDrive: string;
  VolumeName,
  FileSystemName : array [0..MAX_PATH-1] of Char;
  VolumeSerialNo : DWord;
  MaxComponentLength,FileSystemFlags: Cardinal;
begin
  FileDrive := AnsiUpperCase(ExtractFileDrive(Application.ExeName) + '\');
  GetVolumeInformation(PAnsiChar(FileDrive), VolumeName, MAX_PATH, @VolumeSerialNo, MaxComponentLength, FileSystemFlags, FileSystemName, MAX_PATH);
  result := AnsiUpperCase(IntToHex(VolumeSerialNo,10)) + 'A128CG';
end;

function CheckAccessCode(key, accessCode: string) : boolean;
var
  i: Integer;
  pr: Integer;
  code, UserCode: String;
  crc8s: string;
begin
  result := false;
  if (Length(key) = 16) and (Length(accessCode) = 9) then begin
  		UserCode := Copy(accessCode, 1, 4) + Copy(accessCode, 7, 3);
    crc8s := Copy(accessCode, 5, 2);
    if crc8s = Format('%2.2X', [CRC8Hash(UserCode)]) then begin
      for i := 1 to Length(key) do begin
        if(key[i] = '-')then
          Delete(key, i, 1);
      end;
      for i:=1 to Length(key) do begin
        if(key[i] = '') then
          Delete(key, i, 1);
        if(i in [1, 3, 5, 7]) then begin
          pr := ord(key[i]) + ord(key[i+1]) - ord('B');
          if( pr > 15 ) then
            code := code + Format('%1.1X', [(pr - 15)]);
          if(pr < 15) then
            code := code + Format('%1.1X', [pr]);
        end;
      end;
      if UserCode = code then
        result := true;
    end;
  end;
end;
{$EndIf}
{$IfDeF STANDARD_PROTECT}
function ReadInstallDate : TDateTime;
begin
  result := 0.0;
  Reg := TRegistry.Create;
  Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion', true);
  if Reg.ValueExists(GetInstallDateKey) then begin
  	 try
      result := StrToDate(Reg.ReadString(GetInstallDateKey));
    except
			 on E:Exception do
        result := 0.0;
    end;
  end;
end;

procedure UpdateString(var AStr: String);
var
   i: Integer;
   i64: Int64;
   j: Integer;
   ch: Char;
begin
 for i := 1 to Length(AStr) do begin
     i64 := i;
     for j := 0 to Length(AStr) do begin
         if j <> i then i64 := i64 + ord(AStr[j]) * j;
         while i64 > Length(AStr) do
               i64 := i64 - Length(AStr);
     end;
     j := i64;
     ch := AStr[j];
     AStr[j] := AStr[i];
     AStr[i] := ch;
 end;
end;

function EvaluateKey : string;
var
	 FileDrive : string;
  VolumeName,
  FileSystemName : array [0..MAX_PATH-1] of Char;
  VolumeSerialNo : DWord;
  MaxComponentLength,FileSystemFlags: Cardinal;
  i: Integer;
  len: Integer;
  i64: Int64;
  vch, ch: string;
const
{$IfDef TRIZ_MODE}
  phone: DWord = 4381662;
{$Else}
  phone: DWord = 7419700;
{$EndIf}
begin
  FileDrive := AnsiUpperCase(ExtractFileDrive(Application.ExeName) + '\');
  GetVolumeInformation(PAnsiChar(FileDrive), VolumeName, MAX_PATH, @VolumeSerialNo, MaxComponentLength, FileSystemFlags, FileSystemName, MAX_PATH);
  VolumeSerialNo := VolumeSerialNo xor phone;
  result := AnsiUpperCase(Format('%u%u%u', [VolumeSerialNo and $0000FFFF, (VolumeSerialNo and $FFFF0000) shr 16, VolumeSerialNo]));
  val(result, i64, i);
  vch := ValidSerialChars;
  result := '';
  while i64 <> 0 do begin
    i := i64 mod Length(vch);
    result := vch[i+1] + result;
    result := ch + result;
    i64 := i64 div Length(vch);
    UpdateString(vch);
  end;
  while Length(Result) < 14 do begin
    result := vch[1] + result;
    UpdateString(vch);
  end;
  if Length(result) > 14 then
    SetLength(result, 14);
   i64 := 0;
  for i := 1 to 7 do begin
    i64 := i64 + ord(result[i]);
    while i64 >= Length(ValidSerialChars) do
      i64 := i64 - Length(ValidSerialChars);
  end;
  result := ValidSerialChars[i64 + 1] + result;
  i64 := 0;
  for i := 9 to 15 do begin
     i64 := i64 + ord(result[i]);
     while i64 >= Length(ValidSerialChars) do
       i64 := i64 - Length(ValidSerialChars);
 end;
 result := ValidSerialChars[i64 + 1] + Result;
end;

function DeGenerateSerialKey(AKey: String; var Ret: Int64): Boolean;
var
   i: Integer;
   i64: Int64;
   m64: Int64;
   ctl1: char;
   ctl2: char;
   vch: String;
begin
 Ret := 0;
 vch := ValidSerialChars;
 if Length(AKey) <> 16 then begin
   result := false;
   exit;
 end;
 ctl1 := AKey[1];
 ctl2 := AKey[2];
 Delete(AKey, 1, 2);
 i64 := 0;
 for i := 1 to 7 do begin
   i64 := i64 + ord(AKey[i]);
   while i64 >= Length(ValidSerialChars) do
     i64 := i64 - Length(ValidSerialChars);
 end;
 if ctl2 <> ValidSerialChars[i64+1] then begin
   result := false;
   exit;
 end;
 i64 := 0;
 for i := 8 to 14 do begin
     i64 := i64 + ord(AKey[i]);
     while i64 >= Length(ValidSerialChars) do
           i64 := i64 - Length(ValidSerialChars);
 end;
 if ctl1 <> ValidSerialChars[i64+1] then begin
   result := false;
   exit;
 end;
 m64 := 1;
 i64 := 0;
 for i := Length(AKey) downto 1 do begin
   if Pos(AKey[i], vch) = 0 then begin
     result := false;
     exit;
   end;
   i64 := i64 + (Pos(AKey[i], vch)-1) * m64;
   m64 := m64 * Length(vch);
   UpdateString(vch);
 end;
 result := true;
 ret := abs(i64);
end;

function GenerateAccessCode(AKey: String; Expiered: Integer): String;
var
   i: Integer;
   i64: Int64;
   iArr: array[0..7] of Byte absolute i64;
   vch, ch: string;
begin
	result := '';
 if not DeGenerateSerialKey(AKey, i64) then
 	exit;
 for i := 0 to 7 do begin
     iArr[i] := (iArr[i] shr 1) shl 1;
     if Expiered and (1 shl (7-i)) = 1 shl (7-i) then
        iArr[i] := iArr[i] + 1;
 end;
 vch := ValidKeyChars;
 while i64 <> 0 do begin
   i := i64 mod Length(vch);
   result := vch[i+1] + result;
   result := ch + result;
   i64 := i64 div Length(vch);
 end;
 while Length(Result) < 12 do begin
   i := Length(result) div 2;
   if odd(Length(result)) then
     i := i + i div 2
   else
     i := i - i div 2;
   if i < 1 then
     i := 1;
   if i > Length(result) then
     i := Length(result);
   if Pos(result[i], vch) + i < Length(vch) then
     result := vch[Pos(result[i], vch) + i] + result
   else
     result := result[i] + result;
 end;
 if Length(result) > 12 then
   SetLength(result, 12);
end;

function CheckAccessCode(key, accessCode: string) : boolean;
var
 InstallDate: TDateTime;
 i, d, id: Integer;
const
   maxDays: array[0..6] of integer = (1, 7, 31, 93, 186, 365, 36500);
begin
  result := false;
  InstallDate := ReadInstallDate;
  if (Length(key) = 0) or (Length(accessCode) = 0) or (InstallDate = 0.0) then
    exit;
  if (not IsValidDate(YearOf(InstallDate), MonthOf(InstallDate), DayOf(InstallDate))) then
  	exit;
  id := -1;
  for i := 0 to 6 do begin
    if accessCode = GenerateAccessCode(key, i) then begin
      id := i;
      break;
    end;
  end;
  if id = -1 then
    exit;
  d := trunc(Date() - InstallDate);
  if (d >= 0) and (d <= maxDays[id]) then
    result := true;
end;
{$EndIf}

end.

