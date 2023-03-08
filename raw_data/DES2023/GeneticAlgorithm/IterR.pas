unit IterR;
interface
 uses
  VarType,
  Solution;
 type
  PTIterationResult = ^TIterationResult;
  TIterationResult = Class(TSolution)
  private
   FRunTime             :TReal;
   FAmountIteration     :TInt;
   FStrForLocalDesent   :TString;
  public
   Constructor Create(var x : TIterationResult);overload;
   Procedure Assign(var x:TIterationResult);overload;

   Property RunTime          :TReal read FRunTime write FRunTime;
   Property AmountIteration  :TInt read FAmountIteration write FAmountIteration;
   Property StrForLocalDesent:TString read FStrForLocalDesent write FStrForLocalDesent;
  end;
implementation
{******************************************************************************}
 Constructor TIterationResult.Create(var x : TIterationResult);
 begin
  Assign(x);
 end;
{******************************************************************************}
 Procedure TIterationResult.Assign(var x:TIterationResult);
 begin
  inherited Assign(TSolution(x));
  RunTime:=x.RunTime;
  AmountIteration:=x.AmountIteration;
  StrForLocalDesent:=x.StrForLocalDesent;
 end;
{******************************************************************************}
end.
