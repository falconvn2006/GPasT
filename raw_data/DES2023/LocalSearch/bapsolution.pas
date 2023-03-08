unit BAPSolution;

{$mode ObjFPC}

interface
 uses
  Cryptographer,
  Solution,
  CodeObject;
 type
  T = Integer;
{$DEFINE INTERFACE}
{$INCLUDE 'Vector.inc'}

  PTBAPSolution = ^TBAPSolution;
  TBAPSolution = Class(TSolution,ICodeObject)
  protected
   Code_            :Double;
   Revenue_         :Double;
   Expense_         :Double;
   Throughput_      :Double;
   Volume_          :Integer;
   StorageCost_     :Double;
   _Buffer          :TVector;

  public
   Constructor Create;overload;
   Constructor Create(const x : TBAPSolution);overload;
   Destructor Destroy;

   Procedure Assign(const x:TBAPSolution);
   Procedure Assign(const x:TObject);overload;

   Procedure SetCode(var x:TCryptographer);
   Function GetCode:Double;

   Procedure GetMemory;override;
   Procedure FreeMemory;override;

   Function IsIdentical(const x:TObject):boolean;overload;
   Function IsEqual(const x:TObject):boolean;overload;
   Function IsNotEqual(const x:TObject):boolean;overload;
   Function IsBetter(const x:TObject):boolean;overload;
   Function IsBetterOrEqual(const x:TObject):boolean;overload;
   Function IsWorseOrEqual(const x:TObject):boolean;overload;
   Function IsWorse(const x:TObject):boolean;overload;

   Function ToString:ansistring;overload;

   Property Volume:Integer read Volume_ write Volume_;
   Property Revenue:Double read Revenue_ write Revenue_;
   Property Expense:Double read Expense_ write Expense_;
   Property Throughput:Double read Throughput_ write Throughput_;
   Property StorageCost:Double read StorageCost_ write StorageCost_;
   Property Code:Double read GetCode;

   Function GetValue:Double;
   Property Value:Double read GetValue;
   Function GetElement(Index:integer):T;
   Procedure SetElement(Index:integer;Val:T);
   Function GetSize :Integer;
   Function GetSize_ :Integer;
   Procedure SetSize(x:Integer);

   Property Element[Index:integer]:T read GetElement write SetElement;
   Property Size:Integer read GetSize write SetSize;
   Property Size_:Integer read GetSize_;

  end;
implementation
uses Sysutils;
{$DEFINE IMPLEMENTATION}
{$INCLUDE 'Vector.inc'}
{******************************************************************************}
Constructor TBAPSolution.Create;
begin
 _Buffer:=TVector.Create;
end;
{******************************************************************************}
 Constructor TBAPSolution.Create(const x : TBAPSolution);
 begin
  _Buffer:=TVector.Create;
  Assign(x);
 end;
 {******************************************************************************}
 Destructor TBAPSolution.Destroy;
 begin
  FreeMemory;
  _Buffer.Destroy;
 end;
  {******************************************************************************}
 Procedure TBAPSolution.Assign(const x:TBAPSolution);
 begin
   _Buffer.Assign(x._Buffer);
   Code_       := x.Code_;
   Revenue_    := x.Revenue_;
   Expense_    := x.Expense_;
   Throughput_ := x.Throughput_;
   Volume_     := x.Volume_;
   StorageCost_:= x.StorageCost_;
 end;
 {******************************************************************************}
 Procedure TBAPSolution.Assign(const x:TObject);
 begin
   Assign(TBAPSolution(x));
 end;
{******************************************************************************}
 Procedure TBAPSolution.SetCode(var x:TCryptographer);
 begin
  Code_:=x.MakeCode(_Buffer.Element_);
 end;
 {******************************************************************************}
 Function TBAPSolution.GetCode:Double;
 begin
   GetCode := Code_;
 end;
 {******************************************************************************}
 Procedure TBAPSolution.GetMemory;
 begin

 end;

 {******************************************************************************}
 Procedure TBAPSolution.FreeMemory;
 begin
   _Buffer.FreeMemory;
 end;

{******************************************************************************}
 Function TBAPSolution.IsEqual(const x:TObject):boolean;
 begin
  IsEqual:=self.Value = TBAPSolution(x).Value;
 end;
 {******************************************************************************}
 Function TBAPSolution.IsIdentical(const x:TObject):boolean;
 begin
  if Code_ <> TBAPSolution(x).Code_ then IsIdentical:= false
  else IsIdentical:=_Buffer.IsEqual(TBAPSolution(x)._Buffer);
 end;
 {******************************************************************************}
 Function TBAPSolution.IsNotEqual(const x:TObject):boolean;
 begin
  IsNotEqual:= self.Value <> TBAPSolution(x).Value;
 end;

 {******************************************************************************}
 Function TBAPSolution.IsBetter(const x:TObject):boolean;
 begin
  IsBetter:= self.Value > TBAPSolution(x).Value;
 end;
 {******************************************************************************}
 Function TBAPSolution.IsBetterOrEqual(const x:TObject):boolean;
 begin
  IsBetterOrEqual:= self.Value >= TBAPSolution(x).Value;
 end;
 {******************************************************************************}
 Function TBAPSolution.IsWorseOrEqual(const x:TObject):boolean;
 begin
  IsWorseOrEqual:= self.Value <= TBAPSolution(x).Value;
 end;
 {******************************************************************************}
 Function TBAPSolution.IsWorse(const x:TObject):boolean;
 begin
  IsWorse:= self.Value < TBAPSolution(x).Value;
 end;
{******************************************************************************}
Function TBAPSolution.GetValue:Double;
 begin
  GetValue := Revenue - Expense;
 end;
{******************************************************************************}
Function TBAPSolution.GetElement(Index:integer):T;
begin
 GetElement:=_Buffer.Element_[Index];
end;
{******************************************************************************}
Procedure TBAPSolution.SetElement(Index:integer;Val:T);
begin
 _Buffer.Element_[Index]:=Val;
end;
{******************************************************************************}
Function TBAPSolution.GetSize :Integer;
begin
 GetSize:=_Buffer.Size;;

end;
{******************************************************************************}
Function TBAPSolution.GetSize_ :Integer;
begin
 GetSize_:=_Buffer.Size_;
end;

{******************************************************************************}
Procedure TBAPSolution.SetSize(x:Integer);
begin
 _Buffer.Size:=x;
end;

{******************************************************************************}
Function TBAPSolution.ToString:ansistring;
var s:string;
i:integer;
begin
 s :=  FloatToStr(Throughput) + ';' + FloatToStr(Volume) + ';' +  FloatToStr(StorageCost) + ';' + FloatToStr(Revenue) + ';' +  FloatToStr(Expense) + ';'+  FloatToStr(Value) + ';';
 for i :=0 to Size_ do
     s := s + IntToStr(self.Element[i]) + ' ';
 ToString := s;
end;
{******************************************************************************}
end.

