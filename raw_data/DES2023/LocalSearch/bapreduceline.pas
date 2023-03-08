unit BAPReduceLine;
{$MODE OBJFPC}
interface
 uses
  classes,
  Problem,
  Solution,
  BAPSolution,
  MachineLine,
  Cryptographer,
  BAPHashList,
  FPlin;
 type

  PTBAPReduceLine = ^TBAPReduceLine;
  TBAPReduceLine = Class(TProblem)
  public
   RememberMachineLine             :TMachineLine;
   UseMachineLine                  :TMachineLine;

   RememberSimpleMachineLine       :TMachineLine;
   UseSimpleMachineLine            :TMachineLine;

   CodeMaker                       :TCryptographer;

   Hash                            :TBAPHashList;

   UpBoundary                      :Array of Integer;

   revenuefunction                 :a_function;
   alloc_costfunction              :a_function;
   amort                           :Double;
   inv_coef                        :Double;
   det_cost                        :Array of Double;

   Constructor Create;overload;
   Constructor Create(x : TProblem);overload;
   Destructor Destroy;override;

   Procedure GetMemory;overload;
   Procedure FreeMemory;overload;

   Procedure Load(f : TStringList);
   Procedure Assign(x:TProblem);

   Procedure SetValue(x:TSolution); overload;
   Procedure ProblemFunction(var x:TBAPSolution);overload;
//   Procedure BottleneckProblemFunction(var x:TRealArray;var Revenue:TReal);
//   Procedure ProblemFunctionHelp(var lamda,mu,debit:TReal);

  Function GetSize :Integer; overload;
  Function GetSize_ :Integer; overload;
   Procedure SetMachineLine(var x:TMachineLine);
   Property Size :Integer read GetSize;
   Property Size_ :Integer read GetSize_;
   Function GetUpBoundary(i:Integer):Integer;overload;
  end;
implementation
uses SysUtils;
{******************************************************************************}
 Constructor TBAPReduceLine.Create;
  begin
  RememberMachineLine:=TMachineLine.Create;
  UseMachineLine:=TMachineLine.Create;
  CodeMaker:=TCryptographer.Create;
  Hash:=TBAPHashList.Create;
 end;
{******************************************************************************}
 Constructor TBAPReduceLine.Create(x : TProblem);
 begin
  Assign(x);
 end;
{******************************************************************************}
 Destructor TBAPReduceLine.Destroy;
 begin
  FreeMemory;
  RememberMachineLine.Destroy;
  UseMachineLine.Destroy;
  CodeMaker.Destroy;
  Hash.Destroy;
  revenuefunction.done;
  alloc_costfunction.done;
 end;
 Function TBAPReduceLine.GetUpBoundary(i:Integer):Integer;
 begin
   GetUpBoundary := UpBoundary[i];
 end;

{******************************************************************************}
 Procedure TBAPReduceLine.GetMemory;
 begin
  CodeMaker.Size:=Size;
  if Length(Det_cost)=0 then SetLength(Det_cost,Size+2);
  if Length(UpBoundary)=0 then SetLength(UpBoundary,Size);
 end;
{******************************************************************************}
 Procedure TBAPReduceLine.FreeMemory;
 begin
  if Length(Det_cost)<>0 then Finalize(Det_cost);
  if Length(UpBoundary)<>0 then Finalize(UpBoundary);
  Hash.FreeMemory;
  CodeMaker.FreeMemory;
 end;
{******************************************************************************}
 Procedure TBAPReduceLine.Load(f : TStringList);
 var
  i,j:Integer;
  cod:Integer;
  s,k:string;
  ok:Boolean;
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

{  s:=f.Strings[i];
  while pos(' ',s)=1 do delete(s,1,1);
  k:=copy(s,1,pos(' ',s)-1);delete(s,1,pos(' ',s));
  val(k,List.CurentCapacity,cod);
  while (pos(' ',s) <>0) do delete(s,pos(' ',s),1);
  val(s,List.MaxCapacity,cod);

  List.GetMemory;}

 end;
{******************************************************************************}
 Procedure TBAPReduceLine.Assign(x:TProblem);
 var
  p:TBAPReduceLine;
  i:Integer;
 begin
  p:=TBAPReduceLine(x);
  FreeMemory;
  SetMachineLine(p.RememberMachineLine);
  GetMemory;

  for i:=0 to Size_ do
  begin
   Det_Cost[i]:=p.Det_Cost[i];
   UpBoundary[i]:=p.UpBoundary[i];
  end;

  Det_Cost[Size]:=p.Det_Cost[Size];
  Det_Cost[Size+1]:=p.Det_Cost[Size+1];

  amort   :=p.amort;
  inv_coef:=p.inv_coef;
  det_cost:=p.det_cost;
  revenuefunction.Assign(p.revenuefunction);
  alloc_costfunction.Assign(p.alloc_costfunction);

 end;
{******************************************************************************}
 Procedure TBAPReduceLine.ProblemFunction(var x:TBAPSolution);
 var
  i,sum:Integer;
  lamda,mu,debit,avg_stock:Double;
  ok:Boolean;
 begin

  sum:=0;

  for i:=0 to Size_ do
  begin
   UseMachineLine.Buffer[i+1].Size:=x.Element[i];
   sum:=sum+x.Element[i];
  end;

  lamda   := 1;
  mu      := 1;
  debit   := 1;
  avg_stock:=1;

  UseMachineLine.ReduceLine(lamda,mu,debit,avg_stock,inv_coef,det_cost);

  UseMachineLine.Assign(RememberMachineLine);
  x.Throughput:=debit/(1+lamda/mu);
  x.Revenue:=amort*(revenuefunction.get(x.Throughput,ok));
  x.Expense:=amort*avg_stock+alloc_costfunction.get(sum,ok);
  x.Volume:=sum;
  x.StorageCost:=avg_stock;
 end;
{******************************************************************************
 Procedure TBAPReduceLine.ProblemFunctionHelp(var lamda,mu,debit:TReal);
 var
  ok:Boolean;
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
 Procedure TBAPReduceLine.BottleneckProblemFunction(var x:TRealArray;var Revenue:TReal);
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
 ******************************************************************************}
  Procedure TBAPReduceLine.SetValue(x:TSolution);
  var
   p:^TObject;
   n:PTBAPSolution;
  begin
 {$O-}
   TBAPSolution(x).SetCode(CodeMaker);
   p:=Hash.Find(Addr(x));
   if p=nil then
   begin
    ProblemFunction(TBAPSolution(x));
    new(n);
    n^:=TBAPSolution.Create(TBAPSolution(x));
    Hash.Add(n);
   end
   else
    x.Assign(PTBAPSolution(p)^);
 {$O+}
  end;
{******************************************************************************}
 Function TBAPReduceLine.GetSize :Integer;
 begin
  GetSize:=RememberMachineLine.BufferQuantity-2;
 end;
{******************************************************************************}
 Function TBAPReduceLine.GetSize_:Integer;
 begin
  GetSize_:=RememberMachineLine.BufferQuantity-3;
 end;
{******************************************************************************}
 Procedure TBAPReduceLine.SetMachineLine(var x:TMachineLine);
 begin
  RememberMachineLine.Assign(x);
  UseMachineLine.Assign(x);
 end;
{******************************************************************************}

end.
