unit clearga;
interface
 uses
  VarType,
  Solver,
  Solution,
  Population,
  Classes;
 type
  PTClearGA = ^TClearGA;
  TClearGA = class(TSolver)
  private
   _order_vector                    :TIntArray;

   va                               :TIntArray;
   vb                               :TIntArray;
   vga                              :TRealArray;
   vhb                              :TRealArray;

   Function GetPopulationQuantity_  :TInt;
  public
   NamePopulationFile               :TString;

   Population                       :Array of TPopulation;
   PopulationQuantity               :TInt;
   PopulationSize                   :TIntArray;

   MutationIndexBP                  :TInt;//BP - begin population
   MutationParameterBP              :TReal;
   LocalSearchIndexBP               :TInt;
   OderIndexBP                      :TInt;

   MutationIndexDI                 :TInt;//DI - duplicate individual
   MutationParameterDI              :TReal;
   LocalSearchIndexDI               :TInt;
   OderIndexDI                      :TInt;

   MutationIndex                    :TInt;
   MutationParameter                :TReal;
   LocalSearchIndex                 :TInt;
   LocalSearchParameter             :TInt;
   OderIndex                        :TInt;
   CrossoverIndex                   :TInt;
   CrossoverParameter               :TReal;
   SelectionIndex                   :TInt;
   SelectionParameter               :TReal;
   SelectionRadius                  :TInt;

   OnlyBestAdd                      :TInt;
   PopulationSaved                  :boolean;

   PrevPopulationIndex              :integer;
   NextPopulationIndex              :integer;
   NextPopulationSize               :integer;
   ChildPopulationIndex             :integer;


//help
   h,h_                             :TSolution;
   Constructor Create;overload;
   Destructor Destroy;overload;

   Procedure GetMemory;override;
   Procedure FreeMemory;override;

   Procedure Load(var f : TStringList);

   Procedure Iteration;override;
   Procedure Run;override;
   Procedure FirstApproximation;override;

{Selection*********************************************************************}
   Procedure turnament_selection;
{Crossover*********************************************************************}
   Procedure one_point_crossover;
{Mutation**********************************************************************}
   Procedure Mutation1(p:TInt;i:TInt;p_mut:TReal);
   Procedure Mutation2(p:TInt;m:TInt;p_mut:TReal);
   Procedure Mutation3(p:TInt;i:TInt;p_mut:TReal);
{LocalSearch*******************************************************************}
   Procedure LocalSearch_Greedy(numberpopulation,indexindivid,index:TInt);
   Procedure LocalSearch_Hamming(numberpopulation,indexindivid:TInt);
   Procedure LocalSearch_WhileGood(numberpopulation,numberindivid,index:TInt);
   Procedure LocalSearch_LocalDescentWithWhileGood(numberpopulation,numberindivid,index:TInt);
   Procedure LocalSearch_MVG(numberpopulation,numberindivid,index:TInt);
   Procedure LocalSearch_LocalDescentWithHamming(numberpopulation,numberindivid:TInt);
   Procedure LocalSearch_NewLocalDescentWithHamming(numberpopulation,numberindivid:TInt);
   Procedure LocalSearch_WholeRange(numberpopulation, numberindivid,index:TInt);
{------------------------------------------------------------------------------}
   procedure LookForData(
    var p            :PTSolution;
        place        :TInt;
        cva           :TIntArray;
        cvb           :TIntArray;
        cvga          :TRealArray;
        cvhb          :TRealArray;
        in1          :TInt;
        where        :TBool);
   procedure MethodVG(numberpopulation,numberindivid, place:TInt);
{Add***************************************************************************}
   Procedure add;
{GA****************************************************************************}
   Procedure MutationVariationForPopulation(
             y:TInt;
             caseof:TInt;
             EnabledLocalSearch:TBool);
   Procedure MutationVariationForIndividual(
             y:TInt;
             i:TInt;
             caseof:TInt;
             EnabledLocalSearch:TBool);
   Function EnabledLocalSearch:TBool;
{GA****************************************************************************}
   Procedure ShowResults;override;
   Procedure SaveStatistic;override;
   Procedure SavePopulation(forse:boolean);
   Property PopulationQuantity_:TInt read GetPopulationQuantity_;
  end;
implementation
 uses
  SysUtils,
  Math,
  FOrder;
{******************************************************************************}
 Constructor TClearGA.Create;
 begin
  inherited;
  PrevPopulationIndex:=0;
  NextPopulationIndex:=1;
  NextPopulationSize:=0;
  ChildPopulationIndex:=2;
  h:=TSolution.Create;
  h_:=TSolution.Create;
 end;
{******************************************************************************}
 Destructor TClearGA.Destroy;
 begin
  h.Destroy;
  h_.Destroy;
  Finalize(_order_vector);
  Finalize(va);
  Finalize(vb);
  Finalize(vga);
  Finalize(vhb);
  inherited;
 end;
{******************************************************************************}
 Procedure TClearGA.GetMemory;
 var i,x:TInt;
 begin
  inherited;
  SetLength(Population,PopulationQuantity);
  SetLength(_order_vector,Task.Size);
  for i:=0 to PopulationQuantity_ do
  begin
   Population[i]:=TPopulation.Create;
   Population[i].Size:=Task.Size;
   Population[i].Quantity:=PopulationSize[i];
  end;
  x:=Task.UpBoundary[0];
  for i:=1 to Task.Size_ do
   if x < Task.UpBoundary[i] then
    x := Task.UpBoundary[i];

  SetLength(va,x+3);
  SetLength(vb,x+3);
  SetLength(vga,x+3);
  SetLength(vhb,x+3);

 end;
{******************************************************************************}
 Procedure TClearGA.FreeMemory;
 var i:TInt;
 begin
  for i:=0 to High(Population) do Population[i].Destroy;
  Finalize(PopulationSize);
  Finalize(Population);
  inherited;
 end;
{******************************************************************************}
 Procedure TClearGA.Load(var f : TStringList);
 var
  i,j,t,cod  :TInt;
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

   if k = 'SelectionRadius' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,SelectionRadius,cod);
   end;
{______________________________________________________________________________}

   if k = 'MutationIndexBP' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,MutationIndexBP,cod);
   end;
{______________________________________________________________________________}

   if k = 'MutationParameterBP' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,MutationParameterBP,cod);
   end;
{______________________________________________________________________________}

   if k = 'LocalSearchIndexBP' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,LocalSearchIndexBP,cod);
   end;
{______________________________________________________________________________}

   if k = 'OderIndexBP' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,OderIndexBP,cod);
   end;
{______________________________________________________________________________}


   if k = 'MutationIndexDI' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,MutationIndexDI,cod);
   end;
{______________________________________________________________________________}


   if k = 'MutationParameterDI' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,MutationParameterDI,cod);
   end;
{______________________________________________________________________________}

   if k = 'LocalSearchIndexDI' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,LocalSearchIndexDI,cod);
   end;
{______________________________________________________________________________}

   if k = 'OderIndexDI' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,OderIndexDI,cod);
   end;
{______________________________________________________________________________}

   if k = 'OnlyBestAdd' then
   begin
    s:=copy(s,j+1,length(s));
    while pos(' ',s) = 1 do delete(s,1,1);
    j:=pos(' ',s);
    if j=0 then k:=copy(s,1,length(s))
    else k:=copy(s,1,j-1);
    val (k,OnlyBestAdd,cod);
   end;
{______________________________________________________________________________}
  end;
  GetMemory;
 end;
{******************************************************************************}
 Procedure TClearGA.FirstApproximation;
 var i,j:TInt;
 begin
  for i:=0 to Population[PrevPopulationIndex].Quantity_ do
  begin
   for j:=0 to Population[PrevPopulationIndex].Size_ do
    Population[PrevPopulationIndex].Individual[i].Element[j]:=round(int(random(Task.UpBoundary[j]+1)));
   Task.GetSolutionValue(Population[PrevPopulationIndex].Individual[i]);
  end;
  Population[PrevPopulationIndex].FindAll;
  NowRecord.Assign(Population[PrevPopulationIndex].Individual[Population[PrevPopulationIndex].BestSolutionNumber]);
 end;
{Selection*********************************************************************}
 Procedure TClearGA.turnament_selection;
 var
  i,j,z,best:TInt;
 begin
  for i := 0 to Population[ChildPopulationIndex].Quantity_ do
  begin
   best:=random(population[PrevPopulationIndex].Quantity);
   for j := 2 to round(SelectionParameter) do
   begin
    z := random(population[PrevPopulationIndex].Quantity);
    if population[PrevPopulationIndex].individual[z].GetValue >
       population[PrevPopulationIndex].individual[best].GetValue then best:=z;
   end;
   population[ChildPopulationIndex].individual[i].Assign(population[PrevPopulationIndex].individual[best]);
  end;
 end;
{Crossover*********************************************************************}
 Procedure TClearGA.one_point_crossover;
 var
  i,k,l:TInt;
  p:TReal;
  s:String;
 begin
  p := random;
  if p <= CrossoverParameter then
  begin
   k := random(Task.Size);
   for i := k to Task.Size_ do
   begin
    l := population[ChildPopulationIndex].individual[0].element[i];
    population[ChildPopulationIndex].individual[0].element[i]:=population[ChildPopulationIndex].individual[1].element[i];
    population[ChildPopulationIndex].individual[1].element[i]:=l;
   end;
   Task.GetSolutionValue(population[ChildPopulationIndex].individual[0]);
   Task.GetSolutionValue(population[ChildPopulationIndex].individual[1]);
  end;
 end;
{Mutation**********************************************************************}
 Procedure TClearGA.Mutation1(p:TInt;i:TInt;p_mut:TReal);
 var
  j:TInt;
  yy:TReal;
 begin
  for j := 0 to Task.Size_ do
  begin
   yy := random;
   if yy <= p_mut then
    population[p].individual[i].element[j]:=random(Task.UpBoundary[j]+1);
  end;
  Task.GetSolutionValue(population[p].individual[i]);
 end;
{******************************************************************************}
 Procedure TClearGA.Mutation2(p:TInt;m:TInt;p_mut:TReal);
 var
  i_give,i_get,i,j,k,l:TInt;
  not_full:TIntArray;
  not_empty:TIntArray;
 begin
  for l:=1 to round(p_mut) do
  begin
   j:=0;
   k:=0;
   for i := 0 to Task.Size_ do
   begin
    if population[p].individual[m].element[i]<>0 then j:=j+1;
    if population[p].individual[m].element[i]<>Task.UpBoundary[i] then k:=k+1;
   end;
   SetLength(not_full,k);
   SetLength(not_empty,j);
   j:=0;
   k:=0;
   for i := 0 to Task.Size_ do
   begin
    if population[p].individual[m].element[i]<>0 then
    begin
     not_empty[j]:=i;
     j:=j+1;
    end;
    if population[p].individual[m].element[i]<>Task.UpBoundary[i] then
    begin
     not_full[k]:=i;
     k:=k+1;
    end;
   end;
   i_give:=random(Length(not_empty));
   i_give:=not_empty[i_give];
   i_get:=random(Length(not_full));
   i_get:=not_full[i_get];
   population[p].individual[m].element[i_give]:=population[p].individual[m].element[i_give]-1;
   population[p].individual[m].element[i_get]:=population[p].individual[m].element[i_get]+1;
   Finalize(not_full);
   Finalize(not_empty);
   Task.GetSolutionValue(population[p].individual[m]);
  end;
 end;
{******************************************************************************}
 Procedure TClearGA.Mutation3(p:TInt;i:TInt;p_mut:TReal);
 var
  j:TInt;
  new_val:TInt;
  from_rnd:TInt;
  to_rnd:TInt;
 begin
  for j := 0 to Task.Size_ do
  begin
   from_rnd:=population[p].individual[i].element[j]- min(population[p].individual[i].element[j],round(p_mut));
   to_rnd:=population[p].individual[i].element[j]+ min(Task.UpBoundary[j]-population[p].individual[i].element[j],round(p_mut));
   new_val := from_rnd+random(to_rnd-from_rnd+1);
   population[p].individual[i].element[j]:=new_val;
  end;
  Task.GetSolutionValue(population[p].individual[i]);
 end;
{LocalSearch*******************************************************************}
 procedure TClearGA.LocalSearch_Greedy(numberpopulation,indexindivid,index:TInt);
 var
  p     :PTSolution;
  j,t,i :TInt;
  s:string;
 begin
{working individ---------------------------------------------------------------}
  p:=addr(population[numberpopulation].individual[indexindivid]);
 {help individ------------------------------------------------------------------}
  h.Assign(p^);
{help individ------------------------------------------------------------------}
  h_.Assign(p^);
{oder vector-------------------------------------------------------------------}
  case index of
   0:SimpleOrder(_order_vector);
   1:RandomOrder(_order_vector);
   2:BottleneckOrder(_order_vector);
  end;
{------------------------------------------------------------------------------}
  for t:=0 to Task.Size_ do
  begin
   j:=_order_vector[t];
{if we may go up---------------------------------------------------------------}
   if h_.element[j] < Task.UpBoundary[j] then
   begin
    h.element[j]:=h_.element[j]+1;
    Task.GetSolutionValue(h);
    if h.getvalue > p^.getvalue then p^.Assign(h)
    else h.Assign(p^);
   end;
{if we may go down-------------------------------------------------------------}
   if h_.element[j] > 0 then
   begin
    h.element[j]:=h_.element[j]-1;
    Task.GetSolutionValue(h);
    if h.getvalue > p^.getvalue then  p^.Assign(h)
    else h.Assign(p^);
   end;
  end;
{delete------------------------------------------------------------------------}
 end;
{******************************************************************************}
 procedure TClearGA.LocalSearch_Hamming(numberpopulation,indexindivid:TInt);
 var
  i       :TInt;
  p       :PTSolution;
 begin
{working individ---------------------------------------------------------------}
  p:=addr(population[numberpopulation].individual[indexindivid]);
{help individ------------------------------------------------------------------}
  h.Assign(p^);
{------------------------------------------------------------------------------}
  for i:=0 to Task.Size_ do
  begin
{if we may go up---------------------------------------------------------------}
   if h.element[i] < Task.UpBoundary[i] then
   begin
    h.element[i]:=h.element[i]+1;
    Task.GetSolutionValue(h);
    if h.getvalue > p^.getvalue then p^.Assign(h);
    h.element[i]:=h.element[i]-1;
   end;
{if we may go down-------------------------------------------------------------}
   if h.element[i] > 0 then
   begin
    h.element[i]:=h.element[i]-1;
    Task.GetSolutionValue(h);
    if h.getvalue > p^.getvalue then p^.Assign(h);
    h.element[i]:=h.element[i]+1;
   end;
  end;
{delete------------------------------------------------------------------------}
 end;
{******************************************************************************}
 procedure TClearGA.LocalSearch_WhileGood(numberpopulation,numberindivid,index:TInt);
 var
  p      :PTSolution;
  i,j    :TInt;
 begin
{working individ---------------------------------------------------------------}
  p:=addr(population[numberpopulation].individual[numberindivid]);
{oder vector-------------------------------------------------------------------}
  case index of
   0:SimpleOrder(_order_vector);
   1:RandomOrder(_order_vector);
   2:BottleneckOrder(_order_vector);
  end;
{------------------------------------------------------------------------------}
  for i:=0 to Task.Size_ do
  begin

   h.Assign(p^);
   h_.Assign(p^);
   j:=_order_vector[i];

{while better go up------------------------------------------------------------}
   while true do
   begin

    if p^.element[j]+1 > task.UpBoundary[j] then break;
    h.element[j]:=p^.element[j]+1;
    Task.GetSolutionValue(h);

    if h.getvalue <= p^.getvalue then break;
    p^.Assign(h);
   end;
   h.Assign(p^);


{while better go down----------------------------------------------------------}
   p^.Assign(h_);
   while true do
   begin

    if p^.element[j]-1 < 0 then break;
    h_.element[j]:=p^.element[j]-1;
    Task.GetSolutionValue(h_);

    if h_.getvalue <= p^.getvalue then break;
    p^.Assign(h_);
   end;
{------------------------------------------------------------------------------}

   if h.getvalue >= p^.getvalue then p^.Assign(h);
  end;
{delete------------------------------------------------------------------------}
 end;
{******************************************************************************}
 procedure TClearGA.LocalSearch_LocalDescentWithWhileGood(numberpopulation,numberindivid,index:TInt);
 var
  p        :PTSolution;
  k,i      :TInt;
  s        :string;

 begin
{working individ---------------------------------------------------------------}
  p:=addr(population[numberpopulation].individual[numberindivid]);
{help individ------------------------------------------------------------------}
  h.Assign(p^);
{------------------------------------------------------------------------------}
  k:=0;
  s:='b: ';
  for i:=0 to Task.Size_ do
   s:=s+IntToStr(p^.element[i])+' ';
  while true do
  begin
   k:=k+1;
{find better individ-----------------------------------------------------------}
   LocalSearch_WhileGood(numberpopulation, numberindivid, index);
{if no change then stop--------------------------------------------------------}
   if (p^.getvalue = h.getvalue) and (p^.Equal(h)=true) then break;
   h.Assign(p^);
  end;
  s:=s+'i: '+IntToStr(k);{+' e: ';
  for i:=0 to x^.individual_size-1 do
   s:=s+IntToStr(p^.gen[i])+' ';}
  if {(x^.termination_condition = 1)
     and
     (x^.termination_parameter = 1)
     and}
     (p^.getvalue > population[0].individual[population[0].BestSolutionNumber].getvalue)
     and
     (p^.getvalue >= population[numberpopulation].individual[population[numberpopulation].BestSolutionNumber].getvalue)
     then Statistic.RunStatistic[CurrentRun-1].strforlocaldesent:=s;
{delete------------------------------------------------------------------------}
 end;
{******************************************************************************}
 procedure TClearGA.LocalSearch_LocalDescentWithHamming(numberpopulation,numberindivid:TInt);
 var
  p        :PTSolution;
  k,i      :TInt;
  s        :string;
 begin
{working individ---------------------------------------------------------------}
  p:=addr(population[numberpopulation].individual[numberindivid]);
{help individ------------------------------------------------------------------}
  h.Assign(p^);
{------------------------------------------------------------------------------}
  k:=0;
  s:='b: ';
  for i:=0 to Task.Size_ do
   s:=s+IntToStr(p^.element[i])+' ';
  while true do
  begin
   k:=k+1;
{find better individ-----------------------------------------------------------}
   LocalSearch_Hamming(numberpopulation,  numberindivid);
{if no change then stop--------------------------------------------------------}
   if p^.Equal(h)=true then  break;
   h.Assign(p^);
  end;
  s:=s+'i: '+IntToStr(k)+' e: ';
  for i:=0 to size-1 do
   s:=s+IntToStr(p^.element[i])+' ';
  if (terminationcondition = 1)
     and
     (terminationparameter = 1)
     and
     (p^.getvalue > population[0].individual[population[0].BestSolutionNumber].getvalue)
     and
     (p^.getvalue >= population[numberpopulation].individual[population[numberpopulation].BestSolutionNumber].getvalue)
     then Statistic.RunStatistic[currentrun-1].strforlocaldesent:=s+FloatToStr(p^.getvalue);
{delete------------------------------------------------------------------------}
 end;
{******************************************************************************}
 procedure TClearGA.LocalSearch_NewLocalDescentWithHamming(numberpopulation,numberindivid:TInt);
 var
  p        :PTSolution;
  k,i      :TInt;
  s        :string;
 begin
{working individ---------------------------------------------------------------}
  p:=addr(population[numberpopulation].individual[numberindivid]);
{help individ------------------------------------------------------------------}
  h.Assign(p^);
  k:=1;
  s:='b: ';
  for i:=0 to Task.Size_ do
   s:=s+IntToStr(p^.element[i])+' ';
  LocalSearch_LocalDescentWithHamming(numberpopulation,numberindivid);
{------------------------------------------------------------------------------}
  while p^.getvalue > h.getvalue do
  begin
   k:=k+1;
{find better individ-----------------------------------------------------------}
   h.Assign(p^);
   Mutation2( numberpopulation,  numberindivid, 5);
   Task.GetSolutionValue(p^);
   LocalSearch_LocalDescentWithHamming(numberpopulation,numberindivid);
  end;
{delete------------------------------------------------------------------------}
  p^.assign(h);
 end;
{******************************************************************************}
 procedure TClearGA.LocalSearch_MVG(numberpopulation,numberindivid,index:TInt);
 var
  i:Tint;
 begin
{oder vector-------------------------------------------------------------------}

  case index of
   0:SimpleOrder(_order_vector);
   1:RandomOrder(_order_vector);
   2:BottleneckOrder(_order_vector);
  end;
{run MVG for each gen----------------------------------------------------------}
  for i:=0 to Task.Size_ do
   MethodVG(numberpopulation,numberindivid,_order_vector[i]);
{------------------------------------------------------------------------------}
 end;
{******************************************************************************}
 procedure TClearGA.LocalSearch_WholeRange(numberpopulation, numberindivid,index:TInt);
 var
  i,k                              :TInt;
  p                                :PTSolution;

 begin
{working individ---------------------------------------------------------------}
  p:=addr(population[numberpopulation].individual[numberindivid]);
{help individ------------------------------------------------------------------}
  h.Assign(p^);
{oder vector-------------------------------------------------------------------}

  case index of
   0:SimpleOrder(_order_vector);
   1:RandomOrder(_order_vector);
   2:BottleneckOrder(_order_vector);
  end;
{look all range----------------------------------------------------------------}
  for i:=0 to Task.Size_ do
  begin
   h.assign(p^);
   h.element[_order_vector[i]]:=0;
   Task.GetSolutionValue(h);

   p^.assign(h);

   for k:=1 to task.UpBoundary[_order_vector[i]] do
   begin
    h.element[_order_vector[i]]:=k;
    Task.GetSolutionValue(h);
    if h.getvalue <= p^.getvalue then
     p^.assign(h);
   end;

  end;
{delete------------------------------------------------------------------------}
 end;
{------------------------------------------------------------------------------}
 procedure TClearGA.LookForData(
    var p            :PTSolution;
        place        :TInt;
        cva           :TIntArray;
        cvb           :TIntArray;
        cvga          :TRealArray;
        cvhb          :TRealArray;
        in1          :TInt;
        where        :TBool);
  var v:TValue;
 begin
  if where = true then p^.element[place]:=cvb[in1]
  else p^.element[place]:=cva[in1];

  Task.ProblemFunction(p^.Element,v);

  if where = true then
   cvhb[in1]:=v.Revenue
  else
   cvga[in1]:=v.Expense;

 end;
{------------------------------------------------------------------------------}
 procedure TClearGA.MethodVG(numberpopulation,numberindivid, place:TInt);
 var
  k,in1,in2,new,i:TInt;
  raz,q:TReal;
  p:PTSolution;
  function findbest:TInt;
  var
   i,rem:TInt;
   max,rec:TReal;
  begin
   rem:=0;
   max:= vhb[rem]-vga[rem];
   for i:=1 to new do  //?
   begin
    rec:= vhb[i]-vga[i];
    if max <= rec then
    begin
     max:=rec;
     rem:=i;
    end;
   end;
   findbest:=rem;
  end;

 begin
  p:=addr(population[numberpopulation].individual[numberindivid]);
  if place <= p^.Size then
  begin

   new:=0;//1

   in1:=0;

   va[new]:=0;
   vb[new]:=task.UpBoundary[place];

   raz:=vb[in1]-va[in1];

   LookForData(p,place,va,vb,vga,vhb,in1,true);
   LookForData(p,place,va,vb,vga,vhb,in1,false);

   k:=Round(Int(raz/2));

   while raz > 0 do
   begin
    new:=new+1;

    vb[new]:=vb[in1];
    vb[in1]:=va[in1]+k;    
    vga[new]:=vga[in1];
    vhb[new]:=vhb[in1];

    if frac(raz/2)>0 then
     va[new]:=va[in1]+Round(raz)-k
    else
     va[new]:=va[in1]+Round(raz)-k+1;


    LookForData(p,place,va,vb,vga,vhb,in1,true);
    LookForData(p,place,va,vb,vga,vhb,new,false);

    in1:=findbest;

    raz:=vb[in1]-va[in1];
    k:=Round(Int(raz/2));
   end;

   p^.element[place]:=va[in1];
   Task.GetSolutionValue(p^);
  end;
 end;

{Add***************************************************************************}
 Procedure TClearGA.add;
 var
  i,j,q:TInt;
  b,d:TBool;
 begin
  for i:=0 to Population[ChildPopulationIndex].Quantity_ do
  begin
   if (mutationindexdi <> 0)and
      (localsearchindexdi<>0)then
   begin
    b:=true;
    while b=true do
    begin
     b:=population[NextPopulationIndex].FindTheSameIndividual(population[ChildPopulationIndex].individual[i], q);

     if b = true then MutationVariationForIndividual(1,i,1,TRUE);
    end;
   end;
    population[NextPopulationIndex].individual[NextPopulationSize].Assign(population[ChildPopulationIndex].individual[i]);
    NextPopulationSize:=NextPopulationSize+1;
    if(NextPopulationSize = Population[NextPopulationIndex].Quantity) then
    begin
      population[NextPopulationIndex].FindAll;
      if(NowRecord.GetValue < population[NextPopulationIndex].Individual[population[NextPopulationIndex].BestSolutionNumber].GetValue ) then
         NowRecord.assign(population[NextPopulationIndex].Individual[population[NextPopulationIndex].BestSolutionNumber]);
      SavePopulation(false);
      NextPopulationSize:=0;
      j:=NextPopulationIndex;
      NextPopulationIndex:=PrevPopulationIndex;
      PrevPopulationIndex:=j;

    end;
  end;
 end;
{GA****************************************************************************}
 procedure TClearGA.MutationVariationForPopulation(
             y:TInt;
             caseof:TInt;
             EnabledLocalSearch:TBool);
 var i:TInt;
 begin
  for i:=0 to Population[y].Quantity_ do
   MutationVariationForIndividual(y,i,caseof,EnabledLocalSearch);
  population[y].FindAll;
 end;
{******************************************************************************}
 procedure TClearGA.MutationVariationForIndividual(
             y:TInt;
             i:TInt;
             caseof:TInt;
             EnabledLocalSearch:TBool);
 begin
  case caseof of
     //first poulation
   0:begin
      case mutationindexbp of
       1:Mutation1(y,i,mutationparameterbp);
       2:Mutation3(y,i,mutationparameterbp);
       3:Mutation2(y,i,mutationparameterbp);
      end;

      if EnabledLocalSearch then //proizvodit` li globalinuyu otimizaciu
       case localsearchindexbp of
        1:LocalSearch_MVG(y,i,oderindexbp);
        2:LocalSearch_WholeRange(y,i,oderindexbp);
        3:LocalSearch_WhileGood(y,i,oderindexbp);
        4:LocalSearch_LocalDescentWithHamming(y,i);
        5:LocalSearch_LocalDescentWithWhileGood(y,i,oderindexbp);
        6:LocalSearch_NewLocalDescentWithHamming(y,i);
        7:LocalSearch_Greedy(y,i,oderindexbp);
        8:LocalSearch_Hamming(y,i);
       end;

     end;

   1:begin
     //adding to population
      case mutationindexdi of
       1:Mutation1(y,i,mutationparameterdi);
       2:Mutation3(y,i,mutationparameterdi);
       3:Mutation2(y,i,mutationparameterdi);
      end;

      if EnabledLocalSearch then //proizvodit` li globalinuyu otimizaciu
       case localsearchindexdi of
        1:LocalSearch_MVG(y,i,oderindexdi);
        2:LocalSearch_WholeRange(y,i,oderindexdi);
        3:LocalSearch_WhileGood(y,i,oderindexdi);
        4:LocalSearch_LocalDescentWithHamming(y,i);
        5:LocalSearch_LocalDescentWithWhileGood(y,i,oderindexdi);
        6:LocalSearch_NewLocalDescentWithHamming(y,i);
        7:LocalSearch_Greedy(y,i,oderindexdi);
        8:LocalSearch_Hamming(y,i);
       end;

     end;

   2:begin
     //other

      case mutationindex of
       1:Mutation1(y,i,mutationparameter);
       2:Mutation3(y,i,mutationparameter);
       3:Mutation2(y,i,mutationparameter);
      end;

      if EnabledLocalSearch then //proizvodit` li globalinuyu otimizaciu
       case localsearchindex of
        1:LocalSearch_MVG(y,i,oderindex);
        2:LocalSearch_WholeRange(y,i,oderindex);
        3:LocalSearch_WhileGood(y,i,oderindex);
        4:LocalSearch_LocalDescentWithHamming(y,i);
        5:LocalSearch_LocalDescentWithWhileGood(y,i,oderindex);
        6:LocalSearch_NewLocalDescentWithHamming(y,i);
        7:LocalSearch_Greedy(y,i,oderindex);
        8:LocalSearch_Hamming(y,i);
       end;
     end;

    end;
  end;
{******************************************************************************}
 procedure TClearGA.Iteration;
 begin

  case SelectionIndex of
   1:turnament_selection;
  end;

  case CrossoverIndex of
   1:one_point_crossover;
  end;

  MutationVariationForPopulation(1,2,EnabledLocalSearch);

  add;

  PopulationSaved := false;

  {if NowRecord.Code = Population[NextPopulationIndex].Individual[Population[NextPopulationIndex].BestSolutionNumber].Code then
   LastChangeRecord:=LastChangeRecord+1
  else
  begin
   LastChangeRecord:=0;
   NowRecord.Assign(population[NextPopulationIndex].individual[population[NextPopulationIndex].BestSolutionNumber]);
  end;}

  ShowResults;
  SaveStatistic;
  PopulationSaved:=true;
 end;
 {******************************************************************************}
 Procedure TClearGA.Run;
 var
  Hour, Min, Sec, MSec:Word;
 begin
  BeginTime:=Time;

  CurrentIteration:=0;
  Task.CalcValueCount:=0;
  LastChangeRecord:=0;

  PrevPopulationIndex:=0;
  NextPopulationIndex:=1;
  NextPopulationSize:=0;
  ChildPopulationIndex:=2;


  while StopIterations = false do
  begin
   CurrentIteration:=CurrentIteration+1;

   Iteration;

   Statistic.RunStatistic[Statistic.RealQuantity].AmountIteration:=CurrentIteration;
  end;
  Statistic.RunStatistic[Statistic.RealQuantity].Result.Assign(NowRecord);
  DecodeTime(Time-begintime,Hour, Min, Sec, MSec);
  Statistic.RunStatistic[Statistic.RealQuantity].RunTime:=(sec+60*Min+3600*Hour+msec/1000);
  Statistic.RealQuantity:=Statistic.RealQuantity+1;
 end;
{******************************************************************************}
 function TClearGA.EnabledLocalSearch:TBool;
 begin
  if (localsearchindex = 0) or (localsearchparameter = 0) then EnabledLocalSearch := false
  else
   if frac( Currentiteration /(localsearchparameter*1.0)) = 0 then
    EnabledLocalSearch:=true
   else
    EnabledLocalSearch:=false;
 end;
{******************************************************************************}
 Function TClearGA.GetPopulationQuantity_:TInt;
 begin
  GetPopulationQuantity_:=PopulationQuantity-1;
 end;
 {******************************************************************************}
  procedure TClearGA.ShowResults;
  var
   i:TInt;
   s:TString;
   p:PTSolution;
   Hour, Min, Sec, MSec   :Word;
  begin
   s:='';
   for i:=0 to Task.Size_ do
    s:=s+IntToStr(NowRecord.Element[i])+' ';
   DecodeTime(Time-begintime,Hour, Min, Sec, MSec);
   {MainF.RNum.Caption:='Run number: '+IntToStr(CurrentRun);
   MainF.INum.Caption:='Iteration number: '+IntToStr(CurrentIteration);
   MainF.BSol.Caption:='Best solution: '+S;
   MainF.BSV.Caption:='Best solution value: '+FloatToStr(p^.GetValue);}

   //Form1.T.Caption:='Time: '+FloatToStr(sec+60*Min+3600*Hour+msec/1000);

   {Mainf.Process.Cells[5,parSR]:=IntToStr(CurrentRun);
   Mainf.Process.Cells[6,parSR]:=IntToStr(CurrentIteration);
   Mainf.Process.Cells[7,parSR]:=S;
   Mainf.Process.Cells[8,parSR]:=FloatToStr(NowRecord.GetValue);
   Mainf.Process.Cells[9,parSR]:=FloatToStr(sec+60*Min+3600*Hour+msec/1000);}
   end;         {******************************************************************************}
 procedure TClearGA.SaveStatistic;
 var
  i:TInt;
  s:TString;
  sum:TReal;
 begin
  s:=IntToStr(CurrentRun)+';'+IntToStr(CurrentIteration)+';'+IntToStr(Task.CalcValueCount)+';'+
     FloatToStr(NowRecord.Throughput)+';'+
     FloatToStr(NowRecord.Volume)+';'+
     FloatToStr(NowRecord.StorageCost)+';'+
     FloatToStr(NowRecord.Revenue)+';'+
     FloatToStr(NowRecord.Expense)+';'+
     FloatToStr(NowRecord.GetValue())+';';
  for i:=0 to Task.size_ do
      s:=s+IntToStr(NowRecord.Element[i])+' ';
  Statistic.RunStatistic[Statistic.RealQuantity].IterationStatistic.Add(s);
  end;
{******************************************************************************}
 procedure TClearGA.SavePopulation(forse:boolean);
  var
   i,j:TInt;
   s:TString;
   f:TextFile;
  begin
     if (NamePopulationFile<> '')
     then
     begin
      AssignFile(f,NamePopulationFile);
      {$I-}
      Append(f);
      {$I+}
      if IOResult <> 0 then
      begin
         Rewrite(f);
         WriteLn(f,'run;iteration;CalcValueCount;individ;throughput;buffercount;stockcost;revenue;expense;value;buffers');
      end;
      for i:=0 to Population[0].Quantity_ do
      begin
         s:=IntToStr(CurrentRun)+';'+IntToStr(CurrentIteration)+';'+IntToStr(Task.CalcValueCount)+';'+IntToStr(i)+';'+
            FloatToStr(population[NextPopulationIndex].individual[i].Throughput)+';'+
            FloatToStr(population[NextPopulationIndex].individual[i].Volume)+';'+
            FloatToStr(population[NextPopulationIndex].individual[i].StorageCost)+';'+
            FloatToStr(population[NextPopulationIndex].individual[i].Revenue)+';'+
            FloatToStr(population[NextPopulationIndex].individual[i].Expense)+';'+
            FloatToStr(population[NextPopulationIndex].individual[i].GetValue())+';';
         for j:=0 to Task.size_ do
             s:=s+IntToStr(population[NextPopulationIndex].individual[i].Element[j])+' ';
         WriteLn(f,s);
      end;
      closefile(f);
     end;
   end;
end.
