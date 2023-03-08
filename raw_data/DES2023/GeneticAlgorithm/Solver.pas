unit Solver;

{$MODE Delphi}

interface
 uses
  SysUtils,
  Classes,
  VarType,
  Solution,
// IterRs,
  Statistic,
  Problem;
const
 a1 = 'Current operation: ';
 a2 = 'Best solution: ';
 a3 = 'Best solution value: ';
 a4 = 'Run number: ';
 a5 = 'Iteration namber: ';
 a6 = 'Time: ';

 type

  PTSolver = ^TSolver;
  TSolver = Class
  private
   FRunQuantity             :TInt;
   Function GetRunQuantity_ :TInt;
   Function GetSolutionSize :TInt;
   Function GetSolutionSize_:TInt;
  public
//-----Problem-----//
   Task                             :TProblem;
//-----Results-----//
//   Results                          :TIterationResults;
//   Statistic                        :TStatistic;
//-----Termination-----//
   TerminationCondition             :TInt;
   TerminationParameter             :TReal;
//-----Statistic-----//
   flag                             :TInt;
   LastChangeRecord                 :TInt;

   NowRecord                        :TSolution;

   CurrentIteration                 :TInt;
   CurrentRun                       :TInt;

   BeginTime                        :TDateTime;
//-----Files-----//
   NameResultFile                   :TString;
   NameParameterFile                :TString;

   Constructor Create;overload;
   Constructor Create(var x:TSolver);overload;
   Destructor Destroy;override;

   Procedure GetMemory;virtual;
   Procedure FreeMemory;virtual;

   Procedure Load(var f : TStringList);
   Procedure Assign(var x : TSolver);

   Function StopIterations:TBool;virtual;
   Procedure Iteration;virtual; abstract;
   Procedure FirstApproximation;virtual; abstract;
   Procedure ShowRecord;virtual; abstract;
   Procedure SaveRecord;virtual; abstract;
   Procedure ShowResults;virtual; abstract;
   //Procedure SaveStatistic;virtual; abstract;
   Procedure Run;virtual;
   Procedure Algoritm;

   Property Size:TInt read GetSolutionSize;
   Property Size_:TInt read GetSolutionSize_;
   Property RunQuantity:TInt read FRunQuantity write FRunQuantity;
   Property RunQuantity_:TInt read GetRunQuantity_;
  end;
implementation
{******************************************************************************}
 Constructor TSolver.Create;
 begin
  Randomize; 
  Task:=TProblem.Create;
//  Statistic:=TStatistic.Create;
  NowRecord:=TSolution.Create;
 end;
{******************************************************************************}
 Constructor TSolver.Create(var x:TSolver);
 begin
  Randomize;
  Assign(x);
 end;
{******************************************************************************}
 Destructor TSolver.Destroy;
 begin
  FreeMemory;
 end;
{******************************************************************************}
 Procedure TSolver.GetMemory;
 begin
//  Statistic.Size:=Task.Size;
//  Statistic.Quantity:=RunQuantity;
  if NowRecord.Size = 0 then NowRecord.Size:=Task.Size;
 end;
{******************************************************************************}
 Procedure TSolver.FreeMemory;
 begin
//  Statistic.FreeMemory;
  NowRecord.FreeMemory;
  Task.FreeMemory;
 end;
{******************************************************************************}
 Procedure TSolver.Load(var f : TStringList);
 var
  i,j,cod:TInt;
  s,k:TString;
 begin

  for i:=0 to f.Count-1 do
  begin

   s:=f.Strings[i];
   while pos(' ',s) = 1 do delete(s,1,1);
   j:=pos(' ',s);
   if j = 0 then k:=s
   else k:=copy(s,1,j-1);

   if k = 'RunQuantity' then
   begin
    j:=pos(' ',s);
    k:=copy(s,j+1,length(s));
    val (k,FRunQuantity,cod);
   end;

   if k = 'TerminationCondition' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,TerminationCondition,cod);
   end;

   if k = 'TerminationParameter' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,TerminationParameter,cod);
   end;
  end;
 end;
{******************************************************************************}
 Procedure TSolver.Assign(var x : TSolver);
 begin
  Task.Assign(x.Task);
//  Statistics.Assign(x.Results);
  NowRecord.Assign(x.NowRecord);

  RunQuantity := x.RunQuantity;
  TerminationCondition := x.TerminationCondition;
  TerminationParameter := x.TerminationParameter;
  flag := x.flag;
  LastChangeRecord := x.LastChangeRecord;
  CurrentIteration := x.CurrentIteration;
  CurrentRun := x.CurrentRun;
  BeginTime := x.BeginTime;
  NameResultFile := x.NameResultFile;
  NameParameterFile := x.NameParameterFile;
 end;
{******************************************************************************}
 Function TSolver.StopIterations:TBool;
 var Hour, Min, Sec, MSec   :Word;
 begin
  StopIterations:=false;
  if flag = 1 then StopIterations:=true
  else
  begin
   case TerminationCondition of
    1:if CurrentIteration >= TerminationParameter then
      begin
       flag:=2;
       StopIterations:=true;
      end;
    2:if Task.CalcValueCount >= TerminationParameter then
      begin
       flag:=2;
       StopIterations:=true;
      end;
    3:begin
       DecodeTime(Time-begintime,Hour, Min, Sec, MSec);
       if (sec+60*Min+3600*Hour+msec/1000) >= TerminationParameter then
       begin
        flag:=4;
        StopIterations:=true;
       end;
      end;
   end;
  end;
 end;
{******************************************************************************}
 Procedure TSolver.Run;
 var
  Hour, Min, Sec, MSec:Word;
 begin
  BeginTime:=Time;

  Task.CalcValueCount:=0;
  CurrentIteration:=0;
  LastChangeRecord:=0;

  while StopIterations = false do
  begin
   CurrentIteration:=CurrentIteration+1;

   Iteration;

   //Statistic.RunStatistic[Statistic.RealQuantity].AmountIteration:=CurrentIteration;
  end;
    SaveRecord;
  //Statistic.RunStatistic[Statistic.RealQuantity].Result.Assign(NowRecord);
  DecodeTime(Time-begintime,Hour, Min, Sec, MSec);
  //Statistic.RunStatistic[Statistic.RealQuantity].RunTime:=(sec+60*Min+3600*Hour+msec/1000);
  //Statistic.RealQuantity:=Statistic.RealQuantity+1;
 end;
{******************************************************************************}
 Procedure TSolver.Algoritm;
 begin
  CurrentRun:=0;
  flag := 0;

  while CurrentRun < RunQuantity do
  begin

   FirstApproximation;

   CurrentRun:=CurrentRun+1;

   Run;

   if flag = 1 then break;

  end;

//  Statistic.GetStatistic;

 end;
{******************************************************************************}
 Function TSolver.GetRunQuantity_ :TInt;
 begin
  GetRunQuantity_:=FRunQuantity-1;
 end;
{******************************************************************************}
 Function TSolver.GetSolutionSize :TInt;
 begin
  GetSolutionSize  := Task.Size;
 end;
{******************************************************************************}
 Function TSolver.GetSolutionSize_:TInt;
 begin
  GetSolutionSize_  := Task.Size_;
 end;
{******************************************************************************}
end.

