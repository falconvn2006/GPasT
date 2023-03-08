unit Solution;

{$MODE Delphi}

interface
 uses
  VarType,
  Vector;
 type

  TValue = Record
   Revenue         :TReal;
   Expense         :TReal;
   Throughput      :TReal;
   Volume          :TReal;
   StorageCost     :TReal;
  end;


  PTSolution = ^TSolution;
  TSolution = Class(TVector)
  public
   Revenue          :TReal;
   Expense          :TReal;
   Throughput       :TReal;
   Volume           :TReal;
   StorageCost      :TReal;
   CalcFunctionCount:TInt;


   Constructor Create(var x : TSolution);overload;

   Procedure Assign(var x:TSolution);overload;

   Function Equal(var x:TSolution):TBool;overload;

   Function GetValue:TReal;
  end;
implementation
{******************************************************************************}
 Constructor TSolution.Create(var x : TSolution);
 begin
  Assign(x);
 end;
{******************************************************************************}
 Procedure TSolution.Assign(var x:TSolution);
 begin
  self.Assign(TVector(x));
  Revenue    := x.Revenue;
  Expense    := x.Expense;
  Throughput := x.Throughput;
  Volume     := x.Volume;
  StorageCost:= x.StorageCost;
  CalcFunctionCount:= x.CalcFunctionCount;

 end;
{******************************************************************************}
 Function TSolution.Equal(var x:TSolution):TBool;
 begin
  Equal:=self.Equal(TVector(x));
 end;
{******************************************************************************}
 Function TSolution.GetValue:TReal;
 begin
  GetValue := Revenue - Expense;
 end;
{******************************************************************************}
end.

