unit LocalSearch;
interface
 uses
  Solver,
  Solution,
  Classes;
 type
  PTLS = ^TLS;
  TLS = class(TSolver)
  private
   _order_vector                    :Array of integer;
   _NewRecord                       :TSolution;
   _NewSolution                     :TSolution;

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

   Procedure ShowResults;override;
   Procedure SaveStatistic;override;
   Function StopIterations:boolean;override;

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
  FirstRecordList := TStringList.Create;
  FirstRecordList.Duplicates:=dupIgnore;
  FirstRecordList.Sorted:=false;

 end;
{******************************************************************************}
 Destructor TLS.Destroy;
 begin
  _NewRecord.Destroy;
  _NewSolution.Destroy;
  Finalize(_order_vector);
  FirstRecordList.Free;
  inherited;
 end;
{******************************************************************************}
 Procedure TLS.GetMemory;
 var i,x:Integer;
 begin
  inherited;
  if _NewRecord.Size = 0 then _NewRecord.Size:=Task.Size;
  if _NewSolution.Size = 0 then _NewSolution.Size:=Task.Size;
  SetLength(_order_vector,Task.Size);
 end;
{******************************************************************************}
 Procedure TLS.FreeMemory;
 var i:Integer;
 begin
  Finalize(_NewRecord);
  Finalize(_NewSolution);
  Finalize(_order_vector);
  inherited;
 end;
{******************************************************************************}
 Procedure TLS.Load(var f : TStringList);
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
end.
