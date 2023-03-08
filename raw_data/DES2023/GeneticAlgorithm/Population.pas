unit Population;
interface
 uses
  VarType,
  Solution;
 type
  IndividualArray = array of TSolution;
  PTPopulation = ^TPopulation;
  TPopulation = Class
  private
   FQuantity            :TInt;
   FSize                :TInt;

   FBestSolutionNumber  :TInt;
   FWorseSolutionNumber :TInt;

   Function GetSize_:TInt;
   Procedure SetQuantity(x:TInt);
   Function GetQuantity_:TInt;
  public
   Individual          :IndividualArray;

   Constructor Create(var x:TPopulation);overload;
   Destructor Destroy;

   Procedure GetMemory;virtual;
   Procedure FreeMemory;virtual;

   Procedure Assign(var x:TPopulation);overload;

   Procedure FindBest;
   Procedure FindWorse;
   Procedure FindAll;

   Function FindTheSameIndividual( var x:TSolution; var q:TInt):TBool;

   Property Size:TInt read FSize write FSize;
   Property Size_:TInt read GetSize_;

   Property Quantity:TInt read FQuantity write SetQuantity;
   Property Quantity_:TInt read GetQuantity_;

   Property BestSolutionNumber :TInt read FBestSolutionNumber;
   Property WorseSolutionNumber:TInt read FWorseSolutionNumber;
  end;
implementation
{******************************************************************************}
 Constructor TPopulation.Create(var x:TPopulation);
 begin
  Assign(x);
 end;
{******************************************************************************}
 Destructor TPopulation.Destroy;
 begin
  FreeMemory;
 end;
{******************************************************************************}
 Procedure TPopulation.GetMemory;
 var i:TInt;
 begin
  SetLength(Individual, Quantity);
  for i:=0 to Quantity_ do
  begin
   Individual[i]:=TSolution.Create;
   Individual[i].Size:=Size;
  end;
 end;
{******************************************************************************}
 Procedure TPopulation.FreeMemory;
 var i:TInt;
 begin
  if Length(Individual)<>0 then
  begin
   for i:=0 to High(Individual) do Individual[i].Destroy;
   Finalize(Individual);
  end;
 end;
{******************************************************************************}
 Procedure TPopulation.Assign(var x:TPopulation);
 var i:TInt;
 begin
  if Quantity <> x.Quantity then   Quantity := x.Quantity;
  for i:=0 to Quantity_ do Individual[i].Assign(x.Individual[i]);
  if Quantity_>0 then FSize:=Individual[Quantity_].Size;
  FBestSolutionNumber :=x.BestSolutionNumber;
  FWorseSolutionNumber:=x.WorseSolutionNumber;
 end;
{******************************************************************************}
 Procedure TPopulation.FindBest;
 var
  i  :TInt;
  max:TReal;
 begin
  max:=Individual[0].GetValue;
  FBestSolutionNumber:=0;
  for i:=1 to Quantity_ do
   if Individual[i].Getvalue > max then
   begin
    max:=Individual[i].Getvalue;
    FBestSolutionNumber:=i;
   end;
 end;
{******************************************************************************}
 Procedure TPopulation.FindWorse;
 var
  i:TInt;
  min:TReal;
 begin
  min:=Individual[0].Getvalue;
  FWorseSolutionNumber:=0;
  for i:=1 to Quantity_ do
   if Individual[i].Getvalue < min then
   begin
    min:=Individual[i].Getvalue;
    FWorseSolutionNumber:=i;
   end;
 end;
{******************************************************************************}
 Procedure TPopulation.FindAll;
 begin
  FindBest;
  FindWorse;
 end;
{******************************************************************************}
//This procedure look for the same genotype in this population
//If TRUE than genotype exist
//         x | genotype that we want to find
//code_array | massiv for code
//         q | if such genotype exist q = number in this population else q = -1
 Function TPopulation.FindTheSameIndividual( var x:TSolution; var q:TInt):TBool;
 var
  i,j,s : TInt;
  b     : TBool;
 begin
  b:=false;
  q:=-1;
  for i:=0 to Quantity_ do
  begin
   if individual[i].code = x.code then
   begin
    s:=0;
    for j:=0 to Size_ do
     if individual[i].Element[j] = x.Element[j] then
      s:=s+1;
    if s = x.size then
    begin
     b:=true;
     q:=i;
     break;
    end;
   end;
  end;
  FindTheSameIndividual:=b;
 end;
{******************************************************************************}
 Procedure TPopulation.SetQuantity(x:TInt);
 begin
  FreeMemory;
  FQuantity:=x;
  GetMemory;
 end;
{******************************************************************************}
 Function TPopulation.GetQuantity_ :TInt;
 begin
  GetQuantity_:=Quantity-1;
 end;
{******************************************************************************}
 Function TPopulation.GetSize_ :TIndex;
 begin
  GetSize_:=Size-1;
 end;
{******************************************************************************}
end.
