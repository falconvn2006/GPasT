unit BAPLocalSearchImitation;
interface
 uses
  Solver,
  Solution,
  Problem,
  BAPSolution,
  BAPImitation,
  Classes;
 type
  PTBAPLocalSearchImitation = ^TBAPLocalSearchImitation;
  TBAPLocalSearchImitation = class(TSolver)
  private
   _order_vector                    :Array of integer;
   _NewRecord                       :TBAPSolution;
   _NewSolution                     :TBAPSolution;
   _NowRecord                       :TBAPSolution;
   _Imitation                       :TBAPImitation;
  public
   OderIndexBP                      :Integer;
   FirstRecordList                  :TStringList;

   Constructor Create;overload;
   Destructor Destroy;overload;

   Procedure GetMemory;override;
   Procedure FreeMemory;override;

   Procedure Load(var f : TStringList);

   Procedure Run;override;
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
 Constructor TBAPLocalSearchImitation.Create;
 begin
  inherited;
  _NewRecord:=TBAPSolution.Create;
  _NewSolution:=TBAPSolution.Create;
  _NowRecord:=TBAPSolution.Create;

  FirstRecordList := TStringList.Create;
  FirstRecordList.Duplicates:=dupIgnore;
  FirstRecordList.Sorted:=false;

 end;
{******************************************************************************}
 Destructor TBAPLocalSearchImitation.Destroy;
 begin
  FreeMemory;
  _Imitation.Destroy;
  _NowRecord.Destroy;
  _NewRecord.Destroy;
  _NewSolution.Destroy;
  Finalize(_order_vector);
 end;
{******************************************************************************}
Function TBAPLocalSearchImitation.GetNowRecord:TSolution;
begin
 GetNowRecord:=TSolution(_NowRecord);
end;
{******************************************************************************}
 Procedure TBAPLocalSearchImitation.GetMemory;
 var i,x:Integer;
 begin
  if _NowRecord.Size = 0 then _NowRecord.Size:=_Imitation.Size;
  if _NewRecord.Size = 0 then _NewRecord.Size:=_Imitation.Size;
  if _NewSolution.Size = 0 then _NewSolution.Size:=_Imitation.Size;
  SetLength(_order_vector,_Imitation.Size);
 end;
{******************************************************************************}
 Procedure TBAPLocalSearchImitation.FreeMemory;
 var i:Integer;
 begin
  _Imitation.FreeMemory;
  _NowRecord.FreeMemory;
  _NewRecord.FreeMemory;
  _NewSolution.FreeMemory;
  FirstRecordList.Free;
 end;
{******************************************************************************}
 Procedure TBAPLocalSearchImitation.Load(var f : TStringList);
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
 Procedure TBAPLocalSearchImitation.FirstApproximation;
 var i,j,v,cod:Integer;
  s:string;
 begin

  if(FirstRecordList.Count>CurrentRun) then
  begin
    s:=FirstRecordList.Strings[CurrentRun-1];
    for i:=0 to _Imitation.Size_ do
    begin
     while (pos(' ',s) =1) do delete(s,1,1);
     val(copy(s,1,pos(' ',s)-1),v,cod);
     _NowRecord.Element[i]:=v;
     delete(s,1,pos(' ',s));
    end;
    _Imitation.SetValue(_NowRecord);
  end
  else
  begin
    for i:=0 to _Imitation.Size_ do
    begin
         _NowRecord.Element[i]:=round(int(random(_Imitation.GetUpBoundary(i)+1)));
    end;
    _Imitation.SetValue(_NowRecord);
  end;
  ShowDebug;
  SaveDebug;
  //Statistic.SaveIterationResult(NameResultFile+'.iter',CurrentRun-1,0);
 end;
{******************************************************************************}
 procedure TBAPLocalSearchImitation.LocalSearch_Hamming();
 var
  i       :Integer;
 begin
{working individ---------------------------------------------------------------}
  _NewRecord.Assign(_NowRecord);
{help individ------------------------------------------------------------------}
  _NewSolution.Assign(_NowRecord);
{------------------------------------------------------------------------------}
  for i:=0 to _Imitation.Size_ do
  begin
{if we may go up---------------------------------------------------------------}
   if _NewSolution.Element[i] < _Imitation.GetUpBoundary(i) then
   begin
    _NewSolution.Element[i]:=_NewSolution.Element[i]+1;
    _Imitation.SetValue(_NewSolution);
    if _NewSolution.getvalue > _NewRecord.getvalue then _NewRecord.Assign(_NewSolution);
    _NewSolution.Element[i]:=_NewSolution.Element[i]-1;
   end;
{if we may go down-------------------------------------------------------------}
   if _NewSolution.element[i] > 0 then
   begin
    _NewSolution.Element[i]:=_NewSolution.Element[i]-1;
    _Imitation.SetValue(_NewSolution);
    if _NewSolution.getvalue > _NewRecord.getvalue then _NewRecord.Assign(_NewSolution);
    _NewSolution.Element[i]:=_NewSolution.Element[i]+1;
   end;
  end;
 end;
 {******************************************************************************}
  Procedure TBAPLocalSearchImitation.Run;
  var
   Hour, Min, Sec, MSec:Word;
  begin
   BeginTime:=Time;

   CurrentIteration:=0;
   LastChangeRecord:=0;
   _Imitation.NumberSimulationIterations:=10;

   while StopIterations = false do
   begin
    CurrentIteration:=CurrentIteration+1;

    Iteration;

   end;
   DecodeTime(Time-begintime,Hour, Min, Sec, MSec);
  end;
 procedure TBAPLocalSearchImitation.Iteration;
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
  Function TBAPLocalSearchImitation.StopIterations:boolean;
 var Hour, Min, Sec, MSec   :Word;
 begin
  StopIterations:=false;
  if LastChangeRecord > 0 then
  begin
   _Imitation.Hash.FreeMemory;
   if _Imitation.NumberSimulationIterations >= 5000 then
   begin
    StopIterations:=true
   end
   else
   begin
     _Imitation.NumberSimulationIterations:=_Imitation.NumberSimulationIterations*10;
     _Imitation.SetValue(_NowRecord);
   end;
  end;
 end;
 {******************************************************************************}
 procedure TBAPLocalSearchImitation.ShowDebug;
 begin
  ShowRecord;
  end;
 {******************************************************************************}
 procedure TBAPLocalSearchImitation.ShowRecord;
 var
   s:string;
  begin
   s:=IntToStr(CurrentRun)+';'+IntToStr(CurrentIteration)+';'+IntToStr(_imitation.SimulationDuration)+';'+IntToStr(_imitation.NumberSimulationIterations)+';'+_NowRecord.ToString();
   writeln(s);
   end;
  {******************************************************************************}
 procedure TBAPLocalSearchImitation.SaveDebug;
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
      s:=IntToStr(CurrentRun)+';'+IntToStr(CurrentIteration)+';'+IntToStr(_imitation.SimulationDuration)+';'+IntToStr(_imitation.NumberSimulationIterations)+';'+_NowRecord.ToString();
      WriteLn(f,s);
      closefile(f);
     end;
   end;
  {******************************************************************************}
 procedure TBAPLocalSearchImitation.SaveRecord;
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
     s:=IntToStr(CurrentRun)+';'+IntToStr(CurrentIteration)+';'+IntToStr(_imitation.SimulationDuration)+';'+IntToStr(_imitation.NumberSimulationIterations)+';'+_NowRecord.ToString();
     WriteLn(f,s);
     closefile(f);
    end;
   end;
  {******************************************************************************}
  Function TBAPLocalSearchImitation.GetProblem:TProblem;
  begin
   GetProblem:= _Imitation;
  end;

  {******************************************************************************}
  Procedure TBAPLocalSearchImitation.SetProblem(x:TProblem);
  begin
   _Imitation:=TBAPImitation(x);
  end;
  {******************************************************************************}
end.
