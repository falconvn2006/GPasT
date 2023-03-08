unit RunStatistic;
interface
 uses
  VarType,
  Classes,
  Solution;
 type
  PTRunStatistic = ^TRunStatistic;
  TRunStatistic = Class
  private
   __RunTime                  :TReal;
   __AmountIteration          :TInt;
   FStrForLocalDesent   :TString;
  public
   Result                   :TSolution;
   IterationStatistic       :TStringList;

   Constructor Create;
   Property RunTime          :TReal read __RunTime write __RunTime;
   Property AmountIteration  :TInt read __AmountIteration write __AmountIteration;
   Property StrForLocalDesent:TString read FStrForLocalDesent write FStrForLocalDesent;
  end;
implementation
{******************************************************************************}
 Constructor TRunStatistic.Create;
 begin
   Result:=TSolution.Create;
   IterationStatistic:=TStringList.Create;
   IterationStatistic.Duplicates:=dupIgnore;
   IterationStatistic.Sorted:=false;
 end;
{******************************************************************************}
end.
