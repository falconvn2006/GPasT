unit UVersionUtils;

interface

uses
  System.Types;

function GetYellisVersion(Version : string) : string;
function CompareVersion(A, B : string) : TValueRelationship;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  System.Math;

function GetYellisVersion(Version : string) : string;
var
  IdxLast : integer;
begin
  IdxLast := Length(Version);
  while not (Version[IdxLast] = '.') do
    Dec(IdxLast);
  Result := 'V' + LeftStr(Version, IdxLast);
  if Copy(Version, IdxLast +1, 4) = '9999' then
    Result := Result + '1'
  else
    Result := Result + '0';
end;

function CompareVersion(A, B : string) : TValueRelationship;
var
  ListValA, ListValB : TStringList;
  ValA, ValB, i, nb : integer;
begin
  Result := EqualsValue;
  try
    While (Length(A) > 0) and not CharInSet(A[1], ['0'..'9'])  do
      Delete(A, 1, 1);
    While (Length(B) > 0) and not CharInSet(B[1], ['0'..'9']) do
      Delete(B, 1, 1);

    ListValA := TStringList.Create();
    ListValA.Delimiter := '.';
    ListValA.DelimitedText := Trim(A);
    ListValB := TStringList.Create();
    ListValB.Delimiter := '.';
    ListValB.DelimitedText := Trim(B);

    nb := Max(ListValA.Count, ListValB.Count);
    while ListValA.Count < nb do
      ListValA.Add('0');
    while ListValB.Count < nb do
      ListValB.Add('0');

    for i := 0 to nb -1 do
    begin
      if TryStrToInt(ListValA[i], ValA) and TryStrToInt(ListValB[i], ValB) then
        Result := CompareValue(ValA, ValB)
      else
        Result := CompareStr(ListValA[i], ListValB[i]);
      if not (Result = EqualsValue) then
        Exit;
    end;
  finally
    FreeAndNil(ListValA);
    FreeAndNil(ListValB);
  end;
end;

end.
