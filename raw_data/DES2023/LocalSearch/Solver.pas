unit Solver;

{$MODE Delphi}

interface
 uses
  SysUtils,
  Classes,
  VarType,
  Solution,
  Problem,
  BAPReduceLine;
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
  protected
   FRunQuantity             :TInt;
   Function GetRunQuantity_ :TInt;
   Function GetSolutionSize :TInt;
   Function GetSolutionSize_:TInt;
  public

//-----Statistic-----//
   LastChangeRecord                 :integer;

   CurrentIteration                 :integer;
   CurrentRun                       :integer;

   BeginTime                        :TDateTime;
//-----Files-----//
   NameRecordFile                   :TString;
   NameDebugFile                   :TString;
   NameParameterFile                :TString;

   TerminationIndex              :integer;
   TerminationParameter              :double;

   Constructor Create;overload;
   Constructor Create(var x:TSolver);overload;
   Destructor Destroy;override;

   Procedure GetMemory;virtual;abstract;
   Procedure FreeMemory;virtual;abstract;

   Procedure Load(var f : TStringList);
   Procedure Assign(var x : TSolver);

   Function StopIterations:TBool;virtual;
   Procedure Iteration;virtual; abstract;
   Procedure FirstApproximation;virtual; abstract;
   Procedure ShowRecord;virtual; abstract;   
   Procedure ShowDebug;virtual; abstract;
   Procedure SaveRecord;virtual; abstract;
   Procedure SaveDebug;virtual; abstract;
   Procedure Run;virtual;
   Procedure Algoritm;virtual;

   Function GetNowRecord:TSolution;virtual; abstract;
   Function GetProblem:TProblem;virtual; abstract;
   Procedure SetProblem(x:TProblem);virtual; abstract;

   Property Size:TInt read GetSolutionSize;
   Property Size_:TInt read GetSolutionSize_;
   Property RunQuantity:TInt read FRunQuantity write FRunQuantity;
   Property RunQuantity_:TInt read GetRunQuantity_;
   Property NowRecord:TSolution read GetNowRecord;
   Property Task:TProblem read GetProblem write SetProblem;
  end;
implementation
{******************************************************************************}
 Constructor TSolver.Create;
 begin
   NameRecordFile:='';
   NameDebugFile:='';
   NameParameterFile:='';
 end;
{******************************************************************************}
 Constructor TSolver.Create(var x:TSolver);
 begin
  NameRecordFile:='';
  NameDebugFile:='';
  NameParameterFile:='';
  Assign(x);
 end;
{******************************************************************************}
 Destructor TSolver.Destroy;
 begin
 end;
{******************************************************************************}
 Procedure TSolver.Load(var f : TStringList);
 var
  i,j,cod:TInt;
  s,k:TString;
 begin
{
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
  }
 end;
{******************************************************************************}
 Procedure TSolver.Assign(var x : TSolver);
 begin
  NowRecord.Assign(TObject(x.NowRecord));
  RunQuantity := x.RunQuantity;
  LastChangeRecord := x.LastChangeRecord;
  CurrentIteration := x.CurrentIteration;
  CurrentRun := x.CurrentRun;
  BeginTime := x.BeginTime;
  NameRecordFile:=x.NameRecordFile;
  NameDebugFile:=x.NameDebugFile;
  NameParameterFile:=x.NameParameterFile;
 end;
{******************************************************************************}
 Function TSolver.StopIterations:boolean;
 var Hour, Min, Sec, MSec   :Word;
 begin
  StopIterations:=false;
  case TerminationIndex of
   1:if CurrentIteration >= TerminationParameter then
     begin
      StopIterations:=true;
     end;
   3:begin
      DecodeTime(Time-begintime,Hour, Min, Sec, MSec);
      if (sec+60*Min+3600*Hour+msec/1000) >= TerminationParameter then
      begin
       StopIterations:=true;
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

  CurrentIteration:=0;
  LastChangeRecord:=0;

  while StopIterations = false do
  begin
   CurrentIteration:=CurrentIteration+1;

   Iteration;

  end;
  DecodeTime(Time-begintime,Hour, Min, Sec, MSec);
 end;
{******************************************************************************}
 Procedure TSolver.Algoritm;
 begin
  Randomize;

  CurrentRun:=0;

  while CurrentRun < RunQuantity do
  begin

   CurrentRun:=CurrentRun+1;

   FirstApproximation;

   Run;

   SaveRecord;
  end;

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

