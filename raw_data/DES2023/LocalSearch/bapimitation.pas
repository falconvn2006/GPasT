unit BAPImitation;
{$MODE OBJFPC}
interface
 uses
  GlobalVar,
  chartext,
  Solution,
  BAPSolution,
  Problem,
  MachineLineDolguiStructure,
  Cryptographer,
  BAPHashList;
 type

  PTBAPImitation = ^TBAPImitation;
  TBAPImitation = Class(TProblem)
  protected
   UpBoundary:Array of Integer;
   text:MyText;
   _SimulationDuration:integer;
   _NumberSimulationIterations:integer;
  public
   Chain	:TMachineLineDolguiStructure;
   CodeMaker :TCryptographer;
   Hash :TBAPHashList;

   Constructor Create();
   Constructor Create(var str5:MyText);
   Procedure Load(var str5:MyText);
   Destructor Destroy;override;

   Procedure SetValue(x:TSolution); overload;
   Function GetSize :Integer; overload;
   Function GetSize_ :Integer; overload;
   Function GetUpBoundary(i:Integer):Integer; overload;
   Procedure GetMemory; overload;
   Procedure FreeMemory; overload;

   Property Size :Integer read GetSize;
   Property Size_ :Integer read GetSize_;

   Property SimulationDuration:integer read _SimulationDuration write _SimulationDuration;
   Property NumberSimulationIterations:integer read _NumberSimulationIterations write _NumberSimulationIterations;
 end;
implementation
uses SysUtils;
{******************************************************************************}
 Constructor TBAPImitation.Create;
 begin
  CodeMaker:=TCryptographer.Create;
  Hash:=TBAPHashList.Create;
 end;
 {******************************************************************************}
 Constructor TBAPImitation.Create(var str5:MyText);
 var i:Integer;
 begin
  CodeMaker:=TCryptographer.Create;
  Hash:=TBAPHashList.Create;
  Load(str5);
 end;
{******************************************************************************}
Procedure TBAPImitation.Load(var str5:MyText);
 var i:Integer;
 begin
  text:=str5;
  Chain := TMachineLineDolguiStructure.Create(text);
  CodeMaker.Size := GetSize;
  CodeMaker.GetMemory();
  SetLength(UpBoundary,Size);
  for i:=0 to Size_ do
  begin
    UpBoundary[i]:=Round(Chain.pl[i+2]^.h);
  end;
 end;
{******************************************************************************}
 Destructor TBAPImitation.Destroy;
 begin
  CodeMaker.Destroy;
  Hash.Destroy;
 end;
{******************************************************************************}
 Procedure TBAPImitation.GetMemory;
 begin

 end;

 {******************************************************************************}
 Procedure TBAPImitation.FreeMemory;
 begin

 end;
 {******************************************************************************}
 Procedure TBAPImitation.SetValue(x:TSolution);
   var
   p:^TObject;
   n:PTBAPSolution;
   i,Volume: Integer;
   Throughput,StorageCost:Double;
   ok:boolean;
  begin
 {$O-}
   TBAPSolution(x).SetCode(CodeMaker);
   p:=Hash.Find(Addr(x));
   if p=nil then
   begin
    Volume:=0;
    for i:=0 to Size_ do
    begin
      chain.pl[i+2]^.h:=TBAPSolution(x).Element[i];
      Volume:=   Volume+TBAPSolution(x).Element[i];
    end;
    chain.Imitation(SimulationDuration,NumberSimulationIterations,Throughput,StorageCost);
    TBAPSolution(x).Throughput:=Throughput;
    TBAPSolution(x).StorageCost:=StorageCost;
    TBAPSolution(x).Volume:=Volume;
    TBAPSolution(x).Revenue:=amort*revenue.get(Throughput,ok);
    TBAPSolution(x).Expense:=amort*StorageCost+alloc_cost.get(Volume,ok);

    new(n);
    n^:=TBAPSolution.Create(TBAPSolution(x));
    Hash.Add(n);
   end
   else
    x.Assign(PTBAPSolution(p)^);
 {$O+}
 end;
 {******************************************************************************}
  Function TBAPImitation.GetUpBoundary(i:Integer):Integer;
  begin
   GetUpBoundary:=UpBoundary[i];
  end;
  {******************************************************************************}
 Function TBAPImitation.GetSize :Integer;
 begin
  GetSize:=Chain.m-2;
 end;
{******************************************************************************}
 Function TBAPImitation.GetSize_:Integer;
 begin
  GetSize_:=Chain.m-3;
 end;
{******************************************************************************}
end.
