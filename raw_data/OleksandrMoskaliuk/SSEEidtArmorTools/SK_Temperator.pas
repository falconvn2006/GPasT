{
This script should be applied to armor records to create a tempering recipe.
Adds item for temper based on keyword if item has ArmorMaterialIron  it will add IronIngot.
it will add the ArcaneBlacksmith perk as a requirements for all recipes, but this condition works only works for enchanted items.
}

unit SK_Temperator;

uses SK_UtilsRemake;

// runs on script start
function Initialize: integer;
begin
  AddMessage('---Make armor temperable start---');
  Result := 0;
end;

// for every record selected in xEdit
function Process(selectedRecord: IInterface): integer;
var
recordSignature: string;
begin
recordSignature := Signature(selectedRecord);

    // filter selected records, which are not valid
    // NOTE: only weapons and armors are exepted, for now
if not ((recordSignature = 'WEAP') or (recordSignature = 'ARMO')) then
exit;

makeTemperable(selectedRecord);

Result := 0;
end;

// runs in the end
function Finalize: integer;
begin
AddMessage('---Temperator process ended---');
Result := 0;
end;

end.
