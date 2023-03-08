unit SetEvaluation;

{$MODE Delphi}

interface
uses
 VarType,
 Solution;
 type
  PTSetEvaluation = ^TSetEvaluation;
  TSetEvaluation = Class
  private
   Function GetEvaluation :TReal;
   Function GetSize :TInt;
   Procedure SetSize(x:TInt);
  public
   BuffersFull:TSolution;
   BuffersEmpty:TSolution;

   Constructor Create;overload;
   Constructor Create(var x:TSetEvaluation);overload;
   Destructor Destroy;override;

   Procedure GetMemory;
   Procedure FreeMemory;

   Procedure Assign(var x:TSetEvaluation);

   Property Evaluation:TReal read GetEvaluation;
   Property Size:TInt read GetSize write SetSize;
  end;
implementation
{******************************************************************************}
Constructor TSetEvaluation.Create;
begin
 BuffersFull:=TSolution.Create;
 BuffersEmpty:=TSolution.Create;
end;
{******************************************************************************}
Constructor TSetEvaluation.Create(var x:TSetEvaluation);
begin
 BuffersFull:=TSolution.Create;
 BuffersEmpty:=TSolution.Create;
 Assign(x);
end;
{******************************************************************************}
Destructor TSetEvaluation.Destroy;
begin
 BuffersFull.Destroy;
 BuffersEmpty.Destroy;
end;
{******************************************************************************}
Procedure TSetEvaluation.GetMemory;
begin
end;
{******************************************************************************}
Procedure TSetEvaluation.FreeMemory;
begin
 BuffersFull.FreeMemory;
 BuffersEmpty.FreeMemory;
end;
{******************************************************************************}
Function TSetEvaluation.GetEvaluation :TReal;
begin
 GetEvaluation:=BuffersFull.Revenue-BuffersEmpty.Expense;
end;
{******************************************************************************}
Function TSetEvaluation.GetSize :TInt;
begin
 GetSize:=BuffersFull.Size;
end;
{******************************************************************************}
Procedure TSetEvaluation.SetSize(x:TInt);
begin
 BuffersFull.Size:=x;
 BuffersEmpty.Size:=x;
end;
{******************************************************************************}
Procedure TSetEvaluation.Assign(var x:TSetEvaluation);
begin
 BuffersFull.Assign(x.BuffersFull);
 BuffersEmpty.Assign(x.BuffersEmpty);
end;
{******************************************************************************}
end.
