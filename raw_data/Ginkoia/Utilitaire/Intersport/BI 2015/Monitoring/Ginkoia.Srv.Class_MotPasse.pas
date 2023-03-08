unit Ginkoia.Srv.Class_MotPasse;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  System.Math,
  System.DateUtils,
  IdHashMessageDigest;

function GetPassword(Seed : string = ''; DateGen : TDateTime = 0) : string;
function IsValidPassword(Password : string) : boolean;

const
  DEFAULT_PASSWORD_SEED = 'Ginkoia1082';

implementation

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

function IsValidPassword(Password : string) : boolean;
var
  Pass1, Pass2 : string;
begin
  Pass1 := GetPassword(DEFAULT_PASSWORD_SEED, Now());
  Pass2 := GetPassword(DEFAULT_PASSWORD_SEED, IncMinute(Now(), -1));
  Result := (IndexStr(Password, [Pass1, Pass2]) >= 0);
end;

end.

