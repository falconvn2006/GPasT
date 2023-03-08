{
 ReValuate item based on armor rating, and make it more like vanilla item price
}
unit SK_Revaluator;

uses SK_UtilsRemake;

function GetValue(armorRating: Integer): Integer;
var
itemValue: Integer;
begin
  if armorRating < 20 then
    itemValue := Round(5 * Exp(0.15 * armorRating) - 8) + 15;
  if armorRating > 19 then
    itemValue := Round(3 * Exp(0.112 * armorRating)) + 15 ;
  if armorRating > 29 then
    itemValue := Round(6 * Exp(0.075 * armorRating)) + 15;
  Result := itemValue;
end;

// Runs when the script starts
function Initialize: integer;
begin
AddMessage('---Revaluator fair  Price---');
Result := 0;
end;

// Runs for every record selected in xEdit
function Process(selectedRecord: IInterface): integer;
var
recordSignature: string;
armorRating: Float;
itemValue: Double;
begin
recordSignature := Signature(selectedRecord);

    // Filter selected records, which are not valid
    // NOTE: only weapons and armors are excepted, for now
if not ((recordSignature = 'WEAP') or (recordSignature = 'ARMO')) then
exit;

    // Get the Armor Rating from the DNAM subrecord
armorRating := GetElementEditValues(selectedRecord, 'DNAM');

    // Calculate the item value based on the armor rating
itemValue := GetValue(armorRating);


    // Set the new value for the Item
SetElementNativeValues(selectedRecord, 'DATA\Value', itemValue);

Result := 0;
end;

// Runs when the script ends
function Finalize: integer;
begin
AddMessage('---Revaluator process ended---');
Result := 0;
end;

end.
