unit BaseCrypt;

interface

function CryptString(const Value, Key : string) : string;
function DecryptString(const Value, Key : string) : string;

implementation

uses
  SysUtils;

function CryptString(const Value, Key : string) : string;
var
  i, j : Integer;
  PassPhrase : string;
begin
  Result := '';
  PassPhrase := Key;

  j := 1;
  for i := 1 to Length(Value) do
  begin
    Result := Result + IntToHex(Ord(Value[i]) xor Ord(PassPhrase[j]), 2);
    Inc(j);
    if j > Length(PassPhrase) then
      j := 1;
  end;
end;

function DecryptString(const Value, Key : string) : string;
var
  i, j : Integer;
  PassPhrase : string;
begin
  Result := '';
  PassPhrase := Key;

  i := 1;
  j := 1;
  repeat
    Result := Result + Chr(StrToInt('$' + Copy(Value, i, 2)) xor Ord(PassPhrase[j]));
    Inc(i, 2);
    Inc(j);
    if j > Length(PassPhrase) then
      j := 1;
  until i > Length(Value);
end;

end.
