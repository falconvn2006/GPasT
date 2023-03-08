unit BAPGA;
interface
 uses
  Solver,
  Solution,
  Problem,
  BAPSolution,
  BAPReduceLine,
  Population,
  Classes;
 type
  PTBAPGA = ^TBAPGA;
  TBAPGA = class(TSolver)
  private
   _order_vector                    :array of integer;
   _Task                          :TBAPReduceLine;
   _NewRecord                       :TBAPSolution;
   _NewSolution                     :TBAPSolution;
   _NowRecord                       :TBAPSolution;

   Function GetPopulationQuantity_  :integer;
  public


   Population                       :Array of TPopulation;
   PopulationQuantity               :integer;
   PopulationSize                   :array of integer;

   MutationIndex                    :integer;
   MutationParameter                :double;

   AdderMutationIndex               :integer;
   AdderMutationParameter           :double;

   LocalSearchIndex                 :integer;
   LocalSearchParameter             :integer;

   AdderLocalSearchIndex                 :integer;
   AdderLocalSearchParameter             :integer;

   OderIndex                        :integer;

   CrossoverIndex                   :integer;
   CrossoverParameter               :double;

   SelectionIndex                   :integer;
   SelectionParameter               :double;

   Constructor Create;overload;
   Destructor Destroy;overload;

   Procedure GetMemory;override;
   Procedure FreeMemory;override;

   Procedure Load(var f : TStringList);

   Procedure Iteration;override;
   Procedure FirstApproximation;override;

{Selection*********************************************************************}
   Procedure turnament_selection;
{Crossover*********************************************************************}
   Procedure one_point_crossover;
{Mutation**********************************************************************}
   Procedure Mutation1(p:integer;i:integer;p_mut:double);
   Procedure Mutation3(p:integer;i:integer;p_mut:double);
{LocalSearch*******************************************************************}
   Procedure LocalSearch_Hamming(numberpopulation,indexindivid:integer);
{Add***************************************************************************}
   Procedure add;
{GA****************************************************************************}
   Procedure MutationVariationForPopulation(
             popindex:integer;
             mindex:integer;
             mparam:double;
             LSindex:integer
             );
   Procedure MutationVariationForIndividual(
             popindex:integer;
             indindex:integer;
             mindex:integer;
             mparam:double;
             LSindex:integer
             );
   Function EnabledLocalSearch:boolean;
{GA****************************************************************************}
   Procedure ShowRecord;override;
   Procedure ShowDebug;override;
   Procedure SaveRecord;override;
   Procedure SaveDebug;override;



   Function GetNowRecord:TSolution;
   Property NowRecord:TSolution read GetNowRecord;

   Property PopulationQuantity_:integer read GetPopulationQuantity_;

   Function GetProblem:TProblem;override;
   Procedure SetProblem(x:TProblem);override;
   Property Task:TProblem read GetProblem write SetProblem;

  end;
implementation
 uses
  SysUtils,
  Math,
  FOrder;
{******************************************************************************}
 Constructor TBAPGA.Create;
 begin
  inherited;
  _Task:=TBAPReduceLine.Create;
  _NewRecord:=TBAPSolution.Create;
  _NewSolution:=TBAPSolution.Create;
  _NowRecord:=TBAPSolution.Create;
 end;
{******************************************************************************}
 Destructor TBAPGA.Destroy;
 begin
  Finalize(_order_vector);
  _Task.Destroy;
  inherited;
 end;
{******************************************************************************}
 Procedure TBAPGA.GetMemory;
 var i,x:integer;
 begin
  SetLength(Population,PopulationQuantity);
  SetLength(_order_vector,_Task.Size);
  for i:=0 to PopulationQuantity_ do
  begin
   Population[i]:=TPopulation.Create;
   Population[i].Size:=_Task.Size;
   Population[i].Quantity:=PopulationSize[i];
  end;
  {x:=BAPTask.GetUpBoundary(0);
  for i:=1 to Task.Size_ do
   if x < BAPTask.GetUpBoundary(i) then
    x := Task.UpBoundary[i];}
 end;
{******************************************************************************}
 Procedure TBAPGA.FreeMemory;
 var i:integer;
 begin
  for i:=0 to High(Population) do Population[i].Destroy;
  Finalize(PopulationSize);
  Finalize(Population);
  _Task.Free;

 end;
{******************************************************************************}
 Procedure TBAPGA.Load(var f : TstringList);
 var
  i,j,t,cod  :integer;
  s,k    :string;

 begin
  inherited;

  for i:=0 to f.Count-1 do
  begin

   s:=f.Strings[i];
   while pos(' ',s) = 1 do delete(s,1,1);
   j:=pos(' ',s);
   if j = 0 then k:=s
   else k:=copy(s,1,j-1);

{______________________________________________________________________________}
   if k = 'PopulationQuantity' then
   begin
    j:=pos(' ',s);
    k:=copy(s,j+1,length(s));
    val (k,PopulationQuantity,cod);
    if cod = 0 then
    begin
     if Length(PopulationSize)<>0 then Finalize(PopulationSize);
     SetLength(PopulationSize,PopulationQuantity);
    end;
   end;
{______________________________________________________________________________}
   if k = 'PopulationSize' then
   begin
    s:=copy(s,j+1,length(s));
    for t:=0 to PopulationQuantity_ do
    begin
     while pos(' ',s) = 1 do delete(s,1,1);
     j:=pos(' ',s);
     if j=0 then k:=copy(s,1,length(s))
     else k:=copy(s,1,j-1);
     val (k,PopulationSize[t],cod);
     s:=copy(s,j+1,length(s));
    end;
   end;
{______________________________________________________________________________}

   if k = 'MutationIndex' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,MutationIndex,cod);
   end;
{______________________________________________________________________________}

   if k = 'MutationParameter' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,MutationParameter,cod);
   end;
   {______________________________________________________________________________}

      if k = 'AdderMutationIndex' then
      begin
       s:=copy(s,j+1,length(s));
       while pos(' ',s) = 1 do delete(s,1,1);
       j:=pos(' ',s);
       if j=0 then k:=copy(s,1,length(s))
       else k:=copy(s,1,j-1);
       val (k,AdderMutationIndex,cod);
      end;
   {______________________________________________________________________________}

      if k = 'AdderMutationParameter' then
      begin
       s:=copy(s,j+1,length(s));
       while pos(' ',s) = 1 do delete(s,1,1);
       j:=pos(' ',s);
       if j=0 then k:=copy(s,1,length(s))
       else k:=copy(s,1,j-1);
       val (k,AdderMutationParameter,cod);
      end;
{______________________________________________________________________________}

   if k = 'LocalSearchIndex' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,LocalSearchIndex,cod);
   end;
{______________________________________________________________________________}

   if k = 'LocalSearchParameter' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,LocalSearchParameter,cod);
   end;
{______________________________________________________________________________}
   if k = 'AdderLocalSearchIndex' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,AdderLocalSearchIndex,cod);
   end;
{______________________________________________________________________________}

   if k = 'AdderLocalSearchParameter' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,AdderLocalSearchParameter,cod);
   end;
{______________________________________________________________________________}

   if k = 'OderIndex' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,OderIndex,cod);
   end;
{______________________________________________________________________________}

   if k = 'CrossoverIndex' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,CrossoverIndex,cod);
   end;
{______________________________________________________________________________}

   if k = 'CrossoverParameter' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,CrossoverParameter,cod);
   end;
{______________________________________________________________________________}

   if k = 'SelectionIndex' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,SelectionIndex,cod);
   end;
{______________________________________________________________________________}

   if k = 'SelectionParameter' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,SelectionParameter,cod);
   end;
{______________________________________________________________________________}

   if k = 'TerminationIndex' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,TerminationIndex,cod);
   end;
{______________________________________________________________________________}

   if k = 'TerminationParameter' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,TerminationParameter,cod);
   end;
{______________________________________________________________________________}
   if k = 'RunQuantity' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,FRunQuantity,cod);
   end;
{______________________________________________________________________________}

  end;
  GetMemory;
 end;
{******************************************************************************}
 Procedure TBAPGA.FirstApproximation;
 var i,j:integer;
 begin
  for i:=0 to Population[0].Quantity_ do
  begin
   for j:=0 to Population[0].Size_ do
    Population[0].Individual[i].Element[j]:=round(int(random(_Task.GetUpBoundary(j)+1)));
   _Task.SetValue(Population[0].Individual[i]);
  end;
  Population[0].FindAll;
  _NowRecord.Assign(Population[0].Individual[Population[0].BestSolutionNumber]);
  SaveDebug;
 end;
{Selection*********************************************************************}
 Procedure TBAPGA.turnament_selection;
 var
  i,j,z,best:integer;
 begin
  for i := 0 to Population[1].Quantity_ do
  begin
   best:=random(population[0].Quantity);
   for j := 2 to round(SelectionParameter) do
   begin
    z := random(population[0].Quantity);
    if population[0].individual[z].GetValue >
       population[0].individual[best].GetValue then best:=z;
   end;
   population[1].individual[i].Assign(population[0].individual[best]);
  end;
 end;
{Crossover*********************************************************************}
 Procedure TBAPGA.one_point_crossover;
 var
  i,k,l:integer;
  p:double;
  s:String;
 begin
  p := random;
  if p <= CrossoverParameter then
  begin
   k := random(_Task.Size);
   for i := k to _Task.Size_ do
   begin
    l := population[1].individual[0].element[i];
    population[1].individual[0].element[i]:=population[1].individual[1].element[i];
    population[1].individual[1].element[i]:=l;
   end;
   _Task.SetValue(population[1].individual[0]);
   _Task.SetValue(population[1].individual[1]);
  end;
 end;
{Mutation**********************************************************************}
 Procedure TBAPGA.Mutation1(p:integer;i:integer;p_mut:double);
 var
  j:integer;
  yy:double;
 begin
  for j := 0 to _Task.Size_ do
  begin
   yy := random;
   if yy <= p_mut then
    population[p].individual[i].element[j]:=random(_Task.GetUpBoundary(j)+1);
  end;
  _Task.SetValue(population[p].individual[i]);
 end;

 {******************************************************************************}
  Procedure TBAPGA.Mutation3(p:integer;i:integer;p_mut:double);
  var
   j:integer;
   new_val:integer;
   from_rnd:integer;
   to_rnd:integer;
  begin
   for j := 0 to _Task.Size_ do
   begin
    from_rnd:=population[p].individual[i].element[j]- min(population[p].individual[i].element[j],round(p_mut));
    to_rnd:=population[p].individual[i].element[j]+ min(_Task.GetUpBoundary(j)-population[p].individual[i].element[j],round(p_mut));
    new_val := from_rnd+random(to_rnd-from_rnd+1);
    population[p].individual[i].element[j]:=new_val;
   end;
   _Task.SetValue(population[p].individual[i]);
  end;
{LocalSearch*******************************************************************}
 procedure TBAPGA.LocalSearch_Hamming(numberpopulation,indexindivid:integer);
 var
  i       :integer;
  p       :PTBAPSolution;
 begin
{working individ---------------------------------------------------------------}
  p:=addr(population[numberpopulation].individual[indexindivid]);
{help individ------------------------------------------------------------------}
  _NewSolution.Assign(p^);
{------------------------------------------------------------------------------}
  for i:=0 to _Task.Size_ do
  begin
{if we may go up---------------------------------------------------------------}
   if _NewSolution.element[i] < _Task.GetUpBoundary(i) then
   begin
    _NewSolution.element[i]:=_NewSolution.element[i]+1;
    _Task.SetValue(_NewSolution);
    if _NewSolution.getvalue > p^.getvalue then p^.Assign(_NewSolution);
    _NewSolution.element[i]:=_NewSolution.element[i]-1;
   end;
{if we may go down-------------------------------------------------------------}
   if _NewSolution.element[i] > 0 then
   begin
    _NewSolution.element[i]:=_NewSolution.element[i]-1;
    _Task.SetValue(_NewSolution);
    if _NewSolution.getvalue > p^.getvalue then p^.Assign(_NewSolution);
    _NewSolution.element[i]:=_NewSolution.element[i]+1;
   end;
  end;
{delete------------------------------------------------------------------------}
 end;
{******************************************************************************}

{Add***************************************************************************}
 Procedure TBAPGA.add;
 var
  i,j,q:integer;
  b,d:boolean;
 begin
  for i:=0 to Population[1].Quantity_ do
  begin
    b:=true;
    while b=true do
    begin
     b:=population[0].FindTheSameIndividual(population[1].individual[i], q);

     if b = true then MutationVariationForIndividual(1,i,addermutationindex,addermutationparameter,adderlocalsearchindex);
    end;
   if (population[0].individual[population[0].WorseSolutionNumber].getvalue <  population[1].individual[i].getvalue) and
      (population[0].FindTheSameIndividual(population[1].individual[i], q) = false)  then
   begin
    population[0].individual[population[0].WorseSolutionNumber].Assign(population[1].individual[i]);
    population[0].FindWorse;
   end;
  end;
 end;
{GA****************************************************************************}
 procedure TBAPGA.MutationVariationForPopulation(
           popindex:integer;
           mindex:integer;
           mparam:double;
           LSindex:integer
           );
 var i:integer;
 begin
  for i:=0 to Population[popindex].Quantity_ do
   MutationVariationForIndividual(popindex,i,mindex,mparam,LSindex);
  population[popindex].FindAll;
 end;
{******************************************************************************}
 procedure TBAPGA.MutationVariationForIndividual(
           popindex:integer;
           indindex:integer;
           mindex:integer;
           mparam:double;
           LSindex:integer
             );
 begin
      case mindex of
       1:Mutation1(popindex,indindex,mparam);
       3:Mutation3(popindex,indindex,mparam);
      end;

     case LSindex of
      8:LocalSearch_Hamming(popindex,indindex);
     end;
  end;
{******************************************************************************}
 procedure TBAPGA.Iteration;
 begin

  case SelectionIndex of
   1:turnament_selection;
  end;

  case CrossoverIndex of
   1:one_point_crossover;
  end;

  if(CurrentIteration mod int(localsearchparameter) = 0) then
    MutationVariationForPopulation(1,mutationindex,mutationparameter,localsearchindex)
  else
    MutationVariationForPopulation(1,mutationindex,mutationparameter,0);


  add;

  population[0].FindAll;

  if _NowRecord.Code = Population[0].Individual[Population[0].BestSolutionNumber].Code then
   LastChangeRecord:=LastChangeRecord+1
  else
  begin
   LastChangeRecord:=0;
   _NowRecord.Assign(population[0].individual[population[0].BestSolutionNumber]);
  end;

  ShowRecord;
  SaveDebug;
 end;
{******************************************************************************}
 function TBAPGA.EnabledLocalSearch:boolean;
 begin
  if (localsearchindex = 0) or (localsearchparameter = 0) then EnabledLocalSearch := false
  else
   if frac( Currentiteration /(localsearchparameter*1.0)) = 0 then
    EnabledLocalSearch:=true
   else
    EnabledLocalSearch:=false;
 end;
{******************************************************************************}
 Function TBAPGA.GetPopulationQuantity_:integer;
 begin
  GetPopulationQuantity_:=PopulationQuantity-1;
 end;
 {******************************************************************************}
Function TBAPGA.GetNowRecord:TSolution;
begin
 GetNowRecord:=TSolution(_NowRecord);
end;
   {******************************************************************************}
  Function TBAPGA.GetProblem:TProblem;
  begin
   GetProblem:= _Task;
  end;

  {******************************************************************************}
  Procedure TBAPGA.SetProblem(x:TProblem);
  begin
   _Task:=TBAPReduceLine(x);
  end;

 {******************************************************************************}
 {******************************************************************************}
 procedure TBAPGA.ShowDebug;
 var
 i:integer;
 s:string;
 begin
  for i:=0 to Population[0].Quantity_ do
  begin
   s:=IntToStr(CurrentRun)+';'+IntToStr(CurrentIteration)+';'+IntToStr(i)+';'+Population[0].Individual[i].ToString();
   writeln(s);
  end;
 end;
 {******************************************************************************}
 procedure TBAPGA.ShowRecord;
  var
 i:integer;
 s:string;
  begin
   s:=IntToStr(CurrentRun)+';'+IntToStr(CurrentIteration)+';'+_NowRecord.ToString();
   writeln(s);
   end;
  {******************************************************************************}
 procedure TBAPGA.SaveDebug;
  var
 i:integer;
 f:TextFile;
    s:string;
    begin
     if (NameDebugFile<> '') and ((CurrentIteration = 0) or ( (CurrentIteration >= 100) and (CurrentIteration mod 100=0) )) then
     begin
      AssignFile(f,NameDebugFile);
      {$I-}
      Append(f);
      {$I+}
      if IOResult <> 0 then
      begin
         Rewrite(f);
         WriteLn(f,'run;iteration;individ;throughput;buffercount;stockcost;revenue;expense;value;buffers');
      end;
      for i:=0 to Population[0].Quantity_ do
      begin
       s:=IntToStr(CurrentRun)+';'+IntToStr(CurrentIteration)+';'+IntToStr(i)+';'+Population[0].Individual[i].ToString();
       WriteLn(f,s);
      end;
      closefile(f);
     end;
   end;
  {******************************************************************************}
 procedure TBAPGA.SaveRecord;
    var
    f:TextFile;
       s:string;
   begin
    if NameRecordFile<> '' then
    begin
     AssignFile(f,NameRecordFile);
     {$I-}
     Append(f);
     {$I+}
     if IOResult <> 0 then
        Rewrite(f);
     s:=IntToStr(CurrentRun)+';'+IntToStr(CurrentIteration)+';'+_NowRecord.ToString();
     WriteLn(f,s);
     closefile(f);
    end;
   end;
end.
