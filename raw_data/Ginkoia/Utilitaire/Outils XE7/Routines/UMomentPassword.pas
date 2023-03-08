unit UMomentPassword;

interface

function GetPassword(Seed : string = ''; DateGen : TDateTime = 0) : string;
function IsValidPassword(Password : string; Seed : string = ''; DateGen : TDateTime = 0) : boolean;

implementation

uses
  System.Math,
  System.SysUtils,
  System.StrUtils,
  System.DateUtils,
  IdHashMessageDigest;

const
  DEFAULT_PASSWORD_SEED = 'G1nkoi@1082ch@mon1x';

function GetPassword(Seed : string; DateGen : TDateTime) : string;
var
  MaxSize, i : integer;
  tmpSeed, tmpDate, tmpVoid, tmpPass : string;
  MD5 : TIdHashMessageDigest5;
begin
  if Seed = '' then
    Seed := DEFAULT_PASSWORD_SEED;
  if DateGen = 0 then
    DateGen := Now();
  try
    MD5 := TIdHashMessageDigest5.Create();
    MaxSize := Max(12, Length(Seed));
    tmpVoid := StringOfChar(' ', MaxSize);
    tmpSeed := Format('%.*s', [MaxSize, Seed + tmpVoid]);
    tmpDate := Format('%.*s', [MaxSize, FormatDateTime('yyyymmddhhnn', DateGen) + tmpVoid]);
    for i := 1 to MaxSize do
      tmpPass := tmpPass + tmpDate[i] + tmpSeed[i];
    Result := MD5.HashStringAsHex(tmpPass);
  finally
    FreeAndNil(MD5);
  end;
end;

function IsValidPassword(Password : string; Seed : string; DateGen : TDateTime) : boolean;
var
  Pass1, Pass2 : string;
begin
  Pass1 := GetPassword(Seed, DateGen);
  Pass2 := GetPassword(Seed, IncMinute(DateGen, -1));
  Result := (IndexStr(Password, [Pass1, Pass2]) >= 0);
end;

end.
