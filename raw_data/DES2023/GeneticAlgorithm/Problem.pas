unit Problem;
interface
 uses
  Classes,
  Solution,
  VarType,
  MachineLine,
  TCList,
  Cryptographer,
  HashTable,
  FPlin;
 type

  PTProblem = ^TProblem;
  TProblem = Class
  Private
   Function GetSize :TInt;
   Function GetSize_ :TInt;
  public
   RememberMachineLine             :TMachineLine;
   UseMachineLine                  :TMachineLine;

   RememberSimpleMachineLine       :TMachineLine;
   UseSimpleMachineLine            :TMachineLine;

   CodeMaker                       :TCryptographer;

   List                            :THashTable;
//   List                            :TTCList;

   UpBoundary                      :TIntArray;

   revenuefunction                 :a_function;
   alloc_costfunction              :a_function;
   amort                           :TReal;
   inv_coef                        :TReal;
   det_cost                        :TRealArray;

   CalcValueCount                  :integer;

   Constructor Create;overload;
   Constructor Create(var x : TProblem);overload;
   Destructor Destroy;override;

   Procedure GetMemory;
   Procedure FreeMemory;

   Procedure Load(var f : TStringList);
   Procedure Assign(var x:TProblem);

   Procedure GetSolutionValue(var x:TSolution);
   Procedure ProblemFunction(var x:TIntArray;var Value:TValue);overload;
   Procedure ProblemFunction(var x:TIntArray;var Revenue,Expense,Throughput,Volume,StorageCost:TReal);overload;
   Procedure ProblemFunction(var x:TRealArray;var Revenue,Expense,Throughput,Volume,StorageCost:TReal);overload;
   Procedure BottleneckProblemFunction(var x:TRealArray;var Revenue:TReal);
   Procedure ProblemFunctionHelp(var lamda,mu,debit:TReal);

   Procedure SetMachineLine(var x:TMachineLine);
   Function MethodTime:TDateTime;

   Property Size :TInt read GetSize;
   Property Size_ :TInt read GetSize_;
  end;
implementation
uses SysUtils;
{******************************************************************************}
 Constructor TProblem.Create;
 var i:TInt;
 begin
  CalcValueCount:=0;

  RememberMachineLine:=TMachineLine.Create;
  UseMachineLine:=TMachineLine.Create;
  RememberSimpleMachineLine:=TMachineLine.Create;
  RememberSimpleMachineLine.MachineQuantity:=2;
  RememberSimpleMachineLine.BufferQuantity:=3;

  RememberSimpleMachineLine.Buffer[0].MachineQuantity:=2;
  RememberSimpleMachineLine.Buffer[1].MachineQuantity:=2;
  RememberSimpleMachineLine.Buffer[2].MachineQuantity:=2;

  RememberSimpleMachineLine.Buffer[0].Size:=2147483647;
  RememberSimpleMachineLine.Buffer[2].Size:=2147483647;

  RememberSimpleMachineLine.Machine[0].Number:=0;
  RememberSimpleMachineLine.Machine[0].NumberGDB:=0;
  RememberSimpleMachineLine.Machine[0].ListNumberGDB:=RememberSimpleMachineLine.Buffer[0].AddTDMachine(0);
  RememberSimpleMachineLine.Machine[0].NumberTDB:=1;
  RememberSimpleMachineLine.Machine[0].ListNumberTDB:=RememberSimpleMachineLine.Buffer[1].AddPDMachine(0);

  RememberSimpleMachineLine.Machine[1].Number:=1;
  RememberSimpleMachineLine.Machine[1].NumberGDB:=1;
  RememberSimpleMachineLine.Machine[1].ListNumberGDB:=RememberSimpleMachineLine.Buffer[1].AddTDMachine(1);
  RememberSimpleMachineLine.Machine[1].NumberTDB:=2;
  RememberSimpleMachineLine.Machine[1].ListNumberTDB:=RememberSimpleMachineLine.Buffer[2].AddPDMachine(1);

  for i:=0 to Size_ do
  begin
   RememberSimpleMachineLine.CBuffer[i]:=true;
   RememberSimpleMachineLine.CMachine[i]:=true;
  end;

  UseSimpleMachineLine:=TMachineLine.Create(RememberSimpleMachineLine);
  CodeMaker:=TCryptographer.Create;
  List:=THashTable.Create;
  
 end;
{******************************************************************************}
 Constructor TProblem.Create(var x : TProblem);
 begin
  Assign(x);
 end;
{******************************************************************************}
 Destructor TProblem.Destroy;
 begin
  CalcValueCount:=0;
  FreeMemory;
  RememberMachineLine.Destroy;
  UseMachineLine.Destroy;
  RememberSimpleMachineLine.Destroy;
  UseSimpleMachineLine.Destroy;
  CodeMaker.Destroy;
  List.Destroy;
  revenuefunction.done;
  alloc_costfunction.done;
 end;
{******************************************************************************}
 Procedure TProblem.GetMemory;
 begin
  CodeMaker.Size:=Size;
  if Length(Det_cost)=0 then SetLength(Det_cost,Size+2);
  if Length(UpBoundary)=0 then SetLength(UpBoundary,Size);
 end;
{******************************************************************************}
 Procedure TProblem.FreeMemory;
 begin
  if Length(Det_cost)<>0 then Finalize(Det_cost);
  if Length(UpBoundary)<>0 then Finalize(UpBoundary);
  List.FreeMemory;
  CodeMaker.FreeMemory;
 end;
{******************************************************************************}
 Procedure TProblem.Load(var f : TStringList);
 var
  i,j:TInt;
  cod:TInt;
  s,k:TString;
  ok:TBool;
 begin

  RememberMachineLine.Load(f);
  UseMachineLine.Assign(RememberMachineLine);

  GetMemory;

  for i:=0 to Size_ do
   UpBoundary[i]:=round(RememberMachineLine.Buffer[i+1].Size);

  i:=0;
  s:='';
  k:='';

  while (k <> 'BTF') and (i <> f.Count) do
  begin
   s:=f.Strings[i];
   i:=i+1;
   while (pos(' ',s) <>0) do delete(s,pos(' ',s),1);
   k:=s;
  end;

  s:=f.Strings[i];
  for j:=0 to Size do
  begin
   while (pos(' ',s) =1) do delete(s,1,1);
   val(copy(s,1,pos(' ',s)-1),Det_cost[j],cod);
   delete(s,1,pos(' ',s));
  end;
  while (pos(' ',s) <> 0) do delete(s,pos(' ',s),1);
  val(s,Det_cost[Size+1],cod);


  while (k <> 'revenueperitem') and (i <> f.Count) do
  begin
   s:=f.Strings[i];
   i:=i+1;
   while (pos(' ',s) <>0) do delete(s,pos(' ',s),1);
   k:=s;
  end;
  revenuefunction.fread(i,f,ok);

  while (k <> 'amortizationperiod') and (i <> f.Count) do
  begin
   s:=f.Strings[i];
   i:=i+1;
   while (pos(' ',s) <>0) do delete(s,pos(' ',s),1);
   k:=s;
  end;
  s:=f.Strings[i];
  while pos(' ',s) <>0 do delete(s,pos(' ',s),1);
  val(s,amort,cod);

  while (k <> 'inventorycostcoefficient') and (i <> f.Count) do
  begin
   s:=f.Strings[i];
   i:=i+1;
   while (pos(' ',s) <>0) do delete(s,pos(' ',s),1);
   k:=s;
  end;
  s:=f.Strings[i];
  while pos(' ',s) <>0 do delete(s,pos(' ',s),1);
  val(s,inv_coef,cod);

  while (k <> 'bufferspaceallocationcost') and (i <> f.Count) do
  begin
   s:=f.Strings[i];
   i:=i+1;
   while (pos(' ',s) <>0) do delete(s,pos(' ',s),1);
   k:=s;
  end;
  alloc_costfunction.fread(i,f,ok);

  {while (k <> 'solutionlistcapacity') and (i <> f.Count) do
  begin
   s:=f.Strings[i];
   i:=i+1;
   while (pos(' ',s) <>0) do delete(s,pos(' ',s),1);
   k:=s;
  end;
  s:=f.Strings[i];
  while pos(' ',s)=1 do delete(s,1,1);
  k:=copy(s,1,pos(' ',s)-1);delete(s,1,pos(' ',s));
  val(k,List.TableLength,cod);
  while (pos(' ',s) <>0) do delete(s,pos(' ',s),1);
  val(s,List.TableWidth,cod);}
  List.TableLength:=0;
  List.TableWidth :=0;

  List.MaxKey:=CodeMaker.MakeCode(UpBoundary);
  List.GetMemory;

{  s:=f.Strings[i];
  while pos(' ',s)=1 do delete(s,1,1);
  k:=copy(s,1,pos(' ',s)-1);delete(s,1,pos(' ',s));
  val(k,List.CurentCapacity,cod);
  while (pos(' ',s) <>0) do delete(s,pos(' ',s),1);
  val(s,List.MaxCapacity,cod);

  List.GetMemory;}

 end;
{******************************************************************************}
 Procedure TProblem.Assign(var x:TProblem);
 var
  i:TIndex;
 begin
  FreeMemory;
  SetMachineLine(x.RememberMachineLine);
  GetMemory;

  for i:=0 to Size_ do
  begin
   Det_Cost[i]:=x.Det_Cost[i];
   UpBoundary[i]:=x.UpBoundary[i];
  end;

  Det_Cost[Size]:=x.Det_Cost[Size];
  Det_Cost[Size+1]:=x.Det_Cost[Size+1];

  amort   :=x.amort;
  inv_coef:=x.inv_coef;
  det_cost:=x.det_cost;
  revenuefunction.Assign(x.revenuefunction);
  alloc_costfunction.Assign(x.alloc_costfunction);

 end;
{******************************************************************************}
 Procedure TProblem.ProblemFunction(var x:TIntArray;var Value:TValue);
 var
  i:TInt;
  lamda,mu,debit,avg_stock,sum:TReal;
  ok:TBool;
 begin

  sum:=0;

  for i:=0 to Size_ do
  begin
   UseMachineLine.Buffer[i+1].Size:=x[i];
   sum:=sum+x[i];
  end;

  lamda   := 1;
  mu      := 1;
  debit   := 1;
  avg_stock:=1;

  UseMachineLine.ReduceLine(lamda,mu,debit,avg_stock,inv_coef,det_cost);

  UseMachineLine.Assign(RememberMachineLine);

  Value.Revenue:=amort*(revenuefunction.get((debit/(1+lamda/mu) ),ok));
  Value.Expense:=amort*avg_stock+alloc_costfunction.get(sum,ok);
 end;
{******************************************************************************}
 Procedure TProblem.ProblemFunction(var x:TIntArray;var Revenue,Expense,Throughput,Volume,StorageCost:TReal);
 var
  i:TInt;
  lamda,mu,debit,avg_stock,sum:TReal;
  ok:TBool;
 begin

  sum:=0;

  for i:=0 to Size_ do
  begin
   UseMachineLine.Buffer[i+1].Size:=x[i];
   sum:=sum+x[i];
  end;

  lamda   := 1;
  mu      := 1;
  debit   := 1;
  avg_stock:=1;

  UseMachineLine.ReduceLine(lamda,mu,debit,avg_stock,inv_coef,det_cost);

  UseMachineLine.Assign(RememberMachineLine);

  Revenue:=amort*(revenuefunction.get((debit/(1+lamda/mu) ),ok));
  Expense:=amort*avg_stock+alloc_costfunction.get(sum,ok);
  Throughput:=debit/(1+lamda/mu);
  Volume:=sum;
  StorageCost:=avg_stock;
 end;
{******************************************************************************}
 Procedure TProblem.ProblemFunction(var x:TRealArray;var Revenue,Expense,Throughput,Volume,StorageCost:TReal);
 var
  i:TInt;
  lamda,mu,debit,avg_stock,sum:TReal;
  ok:TBool;
 begin

  sum:=0;

  for i:=0 to Size_ do
  begin
   UseMachineLine.Buffer[i+1].Size:=x[i];
   sum:=sum+x[i];
  end;

  lamda   := 1;
  mu      := 1;
  debit   := 1;
  avg_stock:=1;

  UseMachineLine.ReduceLine(lamda,mu,debit,avg_stock,inv_coef,det_cost);

  UseMachineLine.Assign(RememberMachineLine);

  Revenue:=amort*(revenuefunction.get((debit/(1+lamda/mu) ),ok));
  Expense:=amort*avg_stock+alloc_costfunction.get(sum,ok);
  Throughput:=debit/(1+lamda/mu);
  Volume:=sum;
  StorageCost:=avg_stock;
 end;
{******************************************************************************}
 Procedure TProblem.ProblemFunctionHelp(var lamda,mu,debit:TReal);
 var
  ok:TBool;
  avg_stock:TReal;
 begin

  lamda   := 1;
  mu      := 1;
  debit   := 1;
  avg_stock:=1;

  UseSimpleMachineLine.ReduceLine(lamda,mu,debit,avg_stock,inv_coef,det_cost);

  UseSimpleMachineLine.Assign(RememberSimpleMachineLine);
 end;
{******************************************************************************}
 Procedure TProblem.BottleneckProblemFunction(var x:TRealArray;var Revenue:TReal);
 var
  bi1,bi2,mi1,mi2,mi3,bb,mm1,mm2,i,ihm,j,k,t,tt:TInt;
  lamda,mu,debit,volume,stock_cost,avg_stock,sum,_size:TReal;
  lamdaf,muf,debitf,lamdal,mul,debitl:TReal;
  lamdab,mub,debitb,volumeb,bottleneck:TReal;
  lamdabf,mubf,debitbf,lamdabl,mubl,debitbl:TReal;
  l1,l2,m1,m2,d1,d2,v:TReal;
  ok,b:TBool;
 begin
  for i:=0 to Size_ do
   UseMachineLine.Buffer[i+1].Size:=x[i];

  while True do
  begin

   bi1 := UseMachineLine.R1f;
   bb := bi1;

   if bi1<>0 then
   begin
    mi1 := UseMachineLine.Buffer[bi1].NumberPDM[0];
    mm1 := mi1;
    mi2 := UseMachineLine.Buffer[bi1].NumberTDM[0];

    UseSimpleMachineLine.Buffer[1].Size:=UseMachineLine.Buffer[bi1].Size;
    volumeb:=UseMachineLine.Buffer[bi1].Size;

    UseSimpleMachineLine.Machine[0].Lambda:=UseMachineLine.Machine[mi1].Lambda;
    lamdabf:=UseMachineLine.Machine[mi1].Lambda;

    UseSimpleMachineLine.Machine[0].Mu:=UseMachineLine.Machine[mi1].Mu;
    mubf:=UseMachineLine.Machine[mi1].Mu;

    UseSimpleMachineLine.Machine[0].C:=UseMachineLine.Machine[mi1].C;
    debitbf:=UseMachineLine.Machine[mi1].C;


    UseSimpleMachineLine.Machine[1].Lambda:=UseMachineLine.Machine[mi2].Lambda;
    lamdabl:=UseMachineLine.Machine[mi2].Lambda;

    UseSimpleMachineLine.Machine[1].Mu:=UseMachineLine.Machine[mi2].Mu;
    mubl:=UseMachineLine.Machine[mi2].Mu;

    UseSimpleMachineLine.Machine[1].C:=UseMachineLine.Machine[mi2].C;
    debitbl:=UseMachineLine.Machine[mi2].C;

    ProblemFunctionHelp(lamdab,mub,debitb);

    UseMachineLine.CBuffer[bi1]:=False;
    UseMachineLine.CMQuantity := UseMachineLine.CMQuantity -1;
    UseMachineLine.CBQuantity := UseMachineLine.CBQuantity -1;

    while true do
    begin
     bi1:=UseMachineLine.Machine[UseMachineLine.Buffer[bi1].NumberTDM[0]].NumberTDB;
     if  (UseMachineLine.CBuffer[bi1] = True)
     and (UseMachineLine.Buffer[bi1].PDMQuantity = 1)
     and (UseMachineLine.Buffer[bi1].TDMQuantity = 1)
     then
     begin

      mi1 := UseMachineLine.Buffer[bi1].NumberPDM[0];
      mi2 := UseMachineLine.Buffer[bi1].NumberTDM[0];
      mm2 := mi2;

      UseSimpleMachineLine.Buffer[1].Size:=UseMachineLine.Buffer[bi1].Size;
      volume:=UseMachineLine.Buffer[bi1].Size;

      UseSimpleMachineLine.Machine[0].Lambda:=UseMachineLine.Machine[mi1].Lambda;
      lamdaf:=UseMachineLine.Machine[mi1].Lambda;

      UseSimpleMachineLine.Machine[0].Mu:=UseMachineLine.Machine[mi1].Mu;
      muf:=UseMachineLine.Machine[mi1].Mu;

      UseSimpleMachineLine.Machine[0].C:=UseMachineLine.Machine[mi1].C;
      debitf:=UseMachineLine.Machine[mi1].C;

      UseSimpleMachineLine.Machine[1].Lambda:=UseMachineLine.Machine[mi2].Lambda;
      lamdal:=UseMachineLine.Machine[mi2].Lambda;

      UseSimpleMachineLine.Machine[1].Mu:=UseMachineLine.Machine[mi2].Mu;
      mul:=UseMachineLine.Machine[mi2].Mu;

      UseSimpleMachineLine.Machine[1].C:=UseMachineLine.Machine[mi2].C;
      debitl:=UseMachineLine.Machine[mi2].C;

      ProblemFunctionHelp(lamda,mu,debit);

      if (debit/(1+lamda/mu))
          >
         (debitb/(1+lamdab/mub))
      then
      begin
       lamdab:=lamda;
       mub:=mu;
       debitb:=debit;
       volumeb:=volume;
       lamdabf:=lamdaf;
       mubf:=muf;
       debitbf:=debitf;
       lamdabl:=lamdal;
       mubl:=mul;
       debitbl:=debitl;
      end;
      UseMachineLine.CBuffer[bi1]:=False;
      UseMachineLine.CMQuantity := UseMachineLine.CMQuantity -1;
      UseMachineLine.CBQuantity := UseMachineLine.CBQuantity -1;
     end
     else
     begin

      bb:=UseMachineLine.Machine[mm2].NumberTDB;
      UseMachineLine.Machine[mm1].NumberTDB:=bb;
      UseMachineLine.Machine[mm1].ListNumberTDB:=UseMachineLine.Machine[mm2].ListNumberTDB;
      UseMachineLine.Buffer[bb].NumberPDM[UseMachineLine.Machine[mm2].ListNumberTDB]:=mm1;

      UseMachineLine.Machine[mm1].Lambda:=lamdab;
      UseMachineLine.Machine[mm1].Mu:=Mub;
      UseMachineLine.Machine[mm1].C:=debitb;

      break;
     end;
    end;
   end
   else
   begin
    if (UseMachineLine.CMQuantity = 1) and (UseMachineLine.CBQuantity = 2) then break;

    i:=-1;
    b:=true;
    while (i<UseMachineLine.BufferQuantity_) and (b=true) do
    begin
     i:=i+1;
     if (UseMachineLine.CBuffer[i]=True) and  (UseMachineLine.Buffer[i].TDMQuantity >= 2) then
     begin
      j:=-1;
      while (j<UseMachineLine.Buffer[i].TDMQuantity-1) and (b=true) do
      begin
       j:=j+1;
       k:=j;
       while (k<UseMachineLine.Buffer[i].TDMQuantity-1) and (b=true) do
       begin
        k:=k+1;
        if UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[j]].NumberTDB =
           UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[k]].NumberTDB then b:=False;
       end;
      end;
     end;
    end;

    UseMachineLine.parl(UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[j]].Lambda,
                        UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[j]].Mu,
                        UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[j]].C,
                        UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[k]].Lambda,
                        UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[k]].Mu,
                        UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[k]].C);

//     l1:=UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[j]].Lambda;
//     m1:=UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[j]].Mu;
//     u1:=UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[j]].C;

    UseMachineLine.Buffer[UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[k]].NumberTDB].PDMQuantity:=
    UseMachineLine.Buffer[UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[k]].NumberTDB].PDMQuantity-1;

    t:=UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[k]].NumberGDB;
    if t<>UseMachineLine.Buffer[UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[k]].NumberTDB].PDMQuantity then
    begin
     UseMachineLine.Buffer[
      UseMachineLine.Machine[
       UseMachineLine.Buffer[i].NumberTDM[k]
      ].NumberTDB
     ].NumberPDM[t]:=
     UseMachineLine.Buffer[
      UseMachineLine.Machine[
       UseMachineLine.Buffer[i].NumberTDM[k]
      ].NumberTDB
     ].NumberPDM[
                 UseMachineLine.Buffer[
                  UseMachineLine.Machine[
                   UseMachineLine.Buffer[i].NumberTDM[k]
                  ].NumberTDB
                 ].PDMQuantity
                ];

     tt:=UseMachineLine.Buffer[i].NumberTDM[k];
     tt:=UseMachineLine.Machine[tt].NumberTDB;
     tt:=UseMachineLine.Buffer[tt].NumberPDM[UseMachineLine.Buffer[tt].PDMQuantity];
     UseMachineLine.Machine[tt].ListNumberGDB:=t;

{     hh:=Buffer[i].NumberTDMachine[k];

     ].ListNumberGDB:= t;}
    end;

    UseMachineLine.CMQuantity:=UseMachineLine.CMQuantity-1;

    UseMachineLine.Buffer[i].TDMQuantity := UseMachineLine.Buffer[i].TDMQuantity-1;
    if k < UseMachineLine.Buffer[i].TDMQuantity then
    begin
     UseMachineLine.Buffer[i].NumberTDM[k]:=UseMachineLine.Buffer[i].NumberTDM[UseMachineLine.Buffer[i].TDMQuantity];
     UseMachineLine.Machine[UseMachineLine.Buffer[i].NumberTDM[UseMachineLine.Buffer[i].TDMQuantity]].NumberGDB:=k;
    end;

   end;
  end;

  lamda:=UseMachineLine.Machine[UseMachineLine.Buffer[0].NumberTDM[0]].Lambda;
  mu:=UseMachineLine.Machine[UseMachineLine.Buffer[0].NumberTDM[0]].Mu;
  debit:=UseMachineLine.Machine[UseMachineLine.Buffer[0].NumberTDM[0]].C;


  UseMachineLine.Assign(RememberMachineLine);

  Revenue:=amort*(revenuefunction.get((debitb/(1+lamdab/mub) ),ok));
 end;
{******************************************************************************}
 Procedure TProblem.GetSolutionValue(var x:TSolution);
 var
  p:PTSolution;
 begin
{$O-}
  x.GetCode(CodeMaker);
  p:=list.FindTheSameElement(x);
  if p=nil then
  begin
   ProblemFunction(x.Element,x.Revenue,x.Expense,x.Throughput,x.Volume,x.StorageCost);
   CalcValueCount:=  CalcValueCount+1;
   x.CalcFunctionCount:=CalcValueCount;
   List.Add(x);
  end
  else
   x.Assign(p^);
{$O+}
 end;
{******************************************************************************}
 Function TProblem.GetSize :TInt;
 begin
  GetSize:=RememberMachineLine.BufferQuantity-2;
 end;
{******************************************************************************}
 Function TProblem.GetSize_ :TInt;
 begin
  GetSize_:=RememberMachineLine.BufferQuantity-3;
 end;
{******************************************************************************}
 Procedure TProblem.SetMachineLine(var x:TMachineLine);
 begin
  RememberMachineLine.Assign(x);
  UseMachineLine.Assign(x);
 end;
{******************************************************************************}
 Function TProblem.MethodTime:TDateTime;
 var BT:TDateTime;
     Sol:TSolution;
     i,j,l,m,i1,j1,l1,m1:TInt;
     k,t:TReal;
Hour, Min, Sec, MSec   :Word;
 begin
  Randomize;
  Sol:=TSolution.Create;
  Sol.Size:=Size;
  BT:=Time;
  for i:=0 to UpBoundary[0] do
   for j:=0 to UpBoundary[1] do
    for l:=0 to UpBoundary[2] do
     for m:=0 to UpBoundary[3] do
  for i1:=0 to UpBoundary[4] do
   for j1:=0 to UpBoundary[5] do
    for l1:=0 to UpBoundary[6] do
     for m1:=0 to UpBoundary[7] do
     begin
      Sol.Element[0]:=i;
      Sol.Element[1]:=j;
      Sol.Element[2]:=l;
      Sol.Element[3]:=m;
      Sol.Element[4]:=i1;
      Sol.Element[5]:=j1;
      Sol.Element[6]:=l1;
      Sol.Element[7]:=m1;

      GetSolutionValue(Sol);
    end;
  DecodeTime(Time-BT,Hour, Min, Sec, MSec);
  t:=sec+60*Min+3600*Hour+msec/1000;
  T:=t;
  Sol.Destroy;
  MethodTime:=T;
 end;
{******************************************************************************}
end.
