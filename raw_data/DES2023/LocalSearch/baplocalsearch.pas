unit BAPLocalSearch;
interface
 uses
  Solver,
  Solution,
  BAPSolution,
  BAPReduceLine,
  Problem,
  Classes;
 type
  PBAPLocalSearch = ^TBAPLocalSearch;
  TBAPLocalSearch = class(TSolver)
  private
   _Problem                         :TBAPReduceLine;
   _order_vector                    :Array of integer;
   _NewRecord                       :TBAPSolution;
   _NewSolution                     :TBAPSolution;
   _NowRecord                       :TBAPSolution;
  public
   OderIndexBP                      :Integer;
   FirstRecordList                  :TStringList;

   Constructor Create;overload;
   Destructor Destroy;overload;

   Procedure GetMemory;override;
   Procedure FreeMemory;override;

   Procedure Load(var f : TStringList);

   Procedure Iteration;override;
   Procedure FirstApproximation;override;

   Procedure LocalSearch_Hamming();

   Procedure ShowRecord;override;
   Procedure ShowDebug;override;
   Procedure SaveRecord;override;
   Procedure SaveDebug;override;

   Function StopIterations:Boolean;override;

   Function GetNowRecord:TSolution;
   Property NowRecord:TSolution read GetNowRecord;

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
 Constructor TBAPLocalSearch.Create;
 begin
  inherited;
  _NewRecord:=TBAPSolution.Create;
  _NewSolution:=TBAPSolution.Create;
  _NowRecord:=TBAPSolution.Create;

  FirstRecordList := TStringList.Create;
  FirstRecordList.Duplicates:=dupIgnore;
  FirstRecordList.Sorted:=false;

  _Problem:= TBAPReduceLine.Create;

 end;
{******************************************************************************}
 Destructor TBAPLocalSearch.Destroy;
 begin
  _NewRecord.Destroy;
  _NewSolution.Destroy;
  Finalize(_order_vector);
  FirstRecordList.Free;
  inherited;
 end;
{******************************************************************************}
Function TBAPLocalSearch.GetNowRecord:TSolution;
begin
 GetNowRecord:=TSolution(_NowRecord);
end;
{******************************************************************************}
 Procedure TBAPLocalSearch.GetMemory;
 var i,x:Integer;
 begin
  if _NowRecord.Size = 0 then _NowRecord.Size:=_Problem.Size;
  if _NewRecord.Size = 0 then _NewRecord.Size:=_Problem.Size;
  if _NewSolution.Size = 0 then _NewSolution.Size:=_Problem.Size;
  SetLength(_order_vector,_Problem.Size);
 end;
{******************************************************************************}
 Procedure TBAPLocalSearch.FreeMemory;
 var i:Integer;
 begin
  Finalize(_NewRecord);
  Finalize(_NewSolution);
  Finalize(_order_vector);
 end;
{******************************************************************************}
 Procedure TBAPLocalSearch.Load(var f : TStringList);
 var
  i,j,t,cod  :Integer;
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
  end;
  GetMemory;
 end;
{******************************************************************************}
 Procedure TBAPLocalSearch.FirstApproximation;
 var i,j,v,cod:Integer;
  s:string;
 begin

  if(FirstRecordList.Count>CurrentRun) then
  begin
    s:=FirstRecordList.Strings[CurrentRun];
    for i:=0 to _Problem.Size_ do
    begin
     while (pos(' ',s) =1) do delete(s,1,1);
     val(copy(s,1,pos(' ',s)-1),v,cod);
     _NowRecord.Element[i]:=v;
     delete(s,1,pos(' ',s));
    end;
    _Problem.SetValue(_NowRecord);
  end
  else
  begin
    for i:=0 to _Problem.Size_ do
    begin
         _NowRecord.Element[i]:=round(int(random(_Problem.GetUpBoundary(i)+1)));
    end;
    _Problem.SetValue(_NowRecord);
  end;
  ShowDebug;
  SaveDebug;
 end;
{******************************************************************************}
 procedure TBAPLocalSearch.LocalSearch_Hamming();
 var
  i       :Integer;
 begin
{working individ---------------------------------------------------------------}
  _NewRecord.Assign(_NowRecord);
{help individ------------------------------------------------------------------}
  _NewSolution.Assign(_NowRecord);
{------------------------------------------------------------------------------}
  for i:=0 to _Problem.Size_ do
  begin
{if we may go up---------------------------------------------------------------}
   if _NewSolution.Element[i] < _Problem.GetUpBoundary(i) then
   begin
    _NewSolution.Element[i]:=_NewSolution.Element[i]+1;
    _Problem.SetValue(_NewSolution);
    if _NewSolution.getvalue > _NewRecord.getvalue then _NewRecord.Assign(_NewSolution);
    _NewSolution.Element[i]:=_NewSolution.Element[i]-1;
   end;
{if we may go down-------------------------------------------------------------}
   if _NewSolution.element[i] > 0 then
   begin
    _NewSolution.Element[i]:=_NewSolution.Element[i]-1;
    _Problem.SetValue(_NewSolution);
    if _NewSolution.getvalue > _NewRecord.getvalue then _NewRecord.Assign(_NewSolution);
    _NewSolution.Element[i]:=_NewSolution.Element[i]+1;
   end;
  end;
 end;
 procedure TBAPLocalSearch.Iteration;
 begin
  LocalSearch_Hamming();

  if _NowRecord.Code = _NewRecord.Code then
   LastChangeRecord:=LastChangeRecord+1
  else
  begin
   LastChangeRecord:=0;
   _NowRecord.Assign(_NewRecord);
  end;

  ShowDebug;
  SaveDebug;
 end;
  Function TBAPLocalSearch.StopIterations:boolean;
 var Hour, Min, Sec, MSec   :Word;
 begin
  StopIterations:=false;
  if LastChangeRecord > 0 then StopIterations:=true
 end;
  {******************************************************************************}
 procedure TBAPLocalSearch.ShowDebug;
 begin
  ShowRecord;
  end;
 {******************************************************************************}
 procedure TBAPLocalSearch.ShowRecord;
 var
   s:string;
  begin
   s:=IntToStr(CurrentRun)+';'+IntToStr(CurrentIteration)+';'+_NowRecord.ToString();
   writeln(s);
   end;
  {******************************************************************************}
 procedure TBAPLocalSearch.SaveDebug;
 var
 f:TextFile;
    s:string;
    begin
     if NameDebugFile<> '' then
     begin
      AssignFile(f,NameDebugFile);
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
  {******************************************************************************}
 procedure TBAPLocalSearch.SaveRecord;
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
  {******************************************************************************}
  Function TBAPLocalSearch.GetProblem:TProblem;
  begin
   GetProblem:= _Problem;
  end;

  {******************************************************************************}
  Procedure TBAPLocalSearch.SetProblem(x:TProblem);
  begin
   _Problem:=TBAPReduceLine(x);
  end;
  {******************************************************************************}
end.
