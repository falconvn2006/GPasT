unit LocalSearch;
interface
 uses
  VarType,
  Solver,
  Solution,
  Classes;
 type
  PTLS = ^TLS;
  TLS = class(TSolver)
  private
   _order_vector                    :TIntArray;
   _NewRecord                        :TSolution;
   _NewSolution                      :TSolution;

  public
   OderIndexBP                      :TInt;

   Constructor Create;overload;
   Destructor Destroy;overload;

   Procedure GetMemory;override;
   Procedure FreeMemory;override;

   Procedure Load(var f : TStringList);

   Procedure Iteration;override;
   Procedure FirstApproximation;override;

   Procedure LocalSearch_Hamming();

   Procedure ShowResults;override;
   Procedure SaveRecord;override;
   Function StopIterations:TBool;override;
  end;
implementation
 uses
  SysUtils,
  Math,
  FOrder;
{******************************************************************************}
 Constructor TLS.Create;
 begin
  inherited;
  _NewRecord:=TSolution.Create;
  _NewSolution:=TSolution.Create;
 end;
{******************************************************************************}
 Destructor TLS.Destroy;
 begin
  _NewRecord.Destroy;
  _NewSolution.Destroy;
  Finalize(_order_vector);
  inherited;
 end;
{******************************************************************************}
 Procedure TLS.GetMemory;
 var i,x:TInt;
 begin
  inherited;
  if _NewRecord.Size = 0 then _NewRecord.Size:=Task.Size;
  if _NewSolution.Size = 0 then _NewSolution.Size:=Task.Size;
  SetLength(_order_vector,Task.Size);
 end;
{******************************************************************************}
 Procedure TLS.FreeMemory;
 var i:TInt;
 begin
  Finalize(_NewRecord);
  Finalize(_NewSolution);
  Finalize(_order_vector);
  inherited;
 end;
{******************************************************************************}
 Procedure TLS.Load(var f : TStringList);
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
  end;
  GetMemory;
 end;
{******************************************************************************}
 Procedure TLS.FirstApproximation;
 var i,j:TInt;
 begin
  for i:=0 to Task.Size_ do
  begin
   NowRecord.Element[i]:=round(int(random(Task.UpBoundary[i]+1)));
  end;
  Task.GetSolutionValue(NowRecord);
 end;
{******************************************************************************}
 procedure TLS.LocalSearch_Hamming();
 var
  i       :TInt;
 begin
{working individ---------------------------------------------------------------}
  _NewRecord.Assign(NowRecord);
{help individ------------------------------------------------------------------}
  _NewSolution.Assign(NowRecord);
{------------------------------------------------------------------------------}
  for i:=0 to Task.Size_ do
  begin
{if we may go up---------------------------------------------------------------}
   if _NewSolution.element[i] < Task.UpBoundary[i] then
   begin
    _NewSolution.element[i]:=_NewSolution.element[i]+1;
    Task.GetSolutionValue(_NewSolution);
    if _NewSolution.getvalue > _NewRecord.getvalue then _NewRecord.Assign(_NewSolution);
    _NewSolution.element[i]:=_NewSolution.element[i]-1;
   end;
{if we may go down-------------------------------------------------------------}
   if _NewSolution.element[i] > 0 then
   begin
    _NewSolution.element[i]:=_NewSolution.element[i]-1;
    Task.GetSolutionValue(_NewSolution);
    if _NewSolution.getvalue > _NewRecord.getvalue then _NewRecord.Assign(_NewSolution);
    _NewSolution.element[i]:=_NewSolution.element[i]+1;
   end;
  end;
 end;
 procedure TLS.Iteration;
 begin
  LocalSearch_Hamming();

  if NowRecord.Code = _NewRecord.Code then
   LastChangeRecord:=LastChangeRecord+1
  else
  begin
   LastChangeRecord:=0;
   NowRecord.Assign(_NewRecord);
  end;

  ShowResults;
 end;
  Function TLS.StopIterations:TBool;
 var Hour, Min, Sec, MSec   :Word;
 begin
  StopIterations:=false;
  if LastChangeRecord > 0 then StopIterations:=true
 end;
 {******************************************************************************}
  procedure TLS.ShowResults;
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
   end;
 procedure TLS.SaveRecord;
 var
  i:TInt;
  s:TString;
  sum:TReal;
 begin
  s:=IntToStr(CurrentIteration)+';'+FloatToStr(NowRecord.GetValue)+';';
  end;
{******************************************************************************}
end.
