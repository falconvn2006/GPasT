unit HashTable;
interface
 uses
  VarType,
  Solution,
  TCList;
 type
  PTHashTable = ^THashTable;
  THashTable = Class
  public
   TableLength :TInt;
   TableWidth :TInt;
   MaxKey :TReal;
   K:TReal; //коэффициент
   TableString :array of TTCList;

   Destructor Destroy;override;

   Procedure GetMemory;virtual;
   Procedure FreeMemory;virtual;

   procedure Add(var s:TSolution);
   function FindTheSameElement(var s:TSolution):PTSolution;

  end;
implementation
 uses Math, SysUtils;
{******************************************************************************}
 Destructor THashTable.Destroy;
 begin
  FreeMemory;
 end;
{******************************************************************************}
 Procedure THashTable.GetMemory;
 var i:TInt;
 begin
  SetLength(TableString, TableLength);
  for i:=0 to TableLength-1 do
  begin
   TableString[i]:=TTCList.Create;
   TableString[i].MaxCapacity:=TableWidth;
   TableString[i].CurentCapacity:=TableWidth;
   TableString[i].GetMemory;
  end;
  if TableLength<>0 then K:=MaxKey/TableLength;
 end;
{******************************************************************************}
 Procedure THashTable.FreeMemory;
 var i:TInt;
 begin
  if Length(TableString)<>0 then
  begin
   for i:=0 to High(TableString) do TableString[i].Destroy;
   Finalize(TableString);
  end;
 end;
{******************************************************************************}
 procedure THashTable.Add(var s:TSolution);
 var i:TInt;
 begin
  if TableLength <> 0 then
  begin
   i:=floor(s.Code/K);
   if i>= TableLength then i:=TableLength-1;
   TableString[i].Add(s);
  end;
 end;
{******************************************************************************}
 function THashTable.FindTheSameElement(var s:TSolution):PTSolution;
 var i:TInt;
 begin
  if TableLength <> 0 then
  begin
   i:=floor(s.Code/K);
   if i>= TableLength then
    i:=TableLength-1;
   FindTheSameElement:=TableString[i].FindTheSameElement(s);
  end
  else FindTheSameElement:=nil;
 end;
{******************************************************************************}
end.
{
Assignfile(f,'sdfh');
Rewrite(f);
 writeln(f,'1');
Closefile(f);

}

