unit Cryptographer;
interface
 uses
  VarType;
 type

  PTCryptographer = ^TCryptographer;
  TCryptographer = Class
  private
   FSize :TInt;
   Function GetSize_:TInt;
   Procedure SetSize(x:TInt);
  public
   CodeArray :TRealArray;

   Constructor Create(var x:TCryptographer);overload;
   Destructor Destroy;override;

   Procedure GetMemory;
   Procedure FreeMemory;

   Procedure Assign(var x:TCryptographer);

   Function MakeCode(var x : TRealArray):TReal;overload;
   Function MakeCode(var x : TIntArray):TReal;overload;

   Property Size :TInt read FSize write SetSize;
   Property Size_ :TInt read GetSize_;
  end;
implementation
{******************************************************************************}
 Constructor TCryptographer.Create(var x:TCryptographer);
 begin
  Assign(x);
 end;
{******************************************************************************}
 Destructor TCryptographer.Destroy;
 begin
  FreeMemory;
 end;
{******************************************************************************}
 Procedure TCryptographer.GetMemory;
 var
  j,t:TInt;
  k:TReal;
  b:TBool;
 begin
  SetLength(CodeArray,Size);
  CodeArray[0] := 2.0;
  j := 0;
  k := 3.0;
  b := true;
  while j < Size_ do
  begin
   for t := 0 to j do
    if frac(k / CodeArray[t]) = 0.0 then
     b := false;
   if b <> false then
   begin
    j := j + 1;
    CodeArray[j] := k;
   end;
   k := k + 1;
   b := true;
  end;
  for t := 0 to Size_ do
   CodeArray[t] := sqrt(CodeArray[t]);
 end;
{******************************************************************************}
 Procedure TCryptographer.FreeMemory;
 begin
  Finalize(CodeArray);
 end;
{******************************************************************************}
 Function TCryptographer.MakeCode(var x : TRealArray):TReal;
 var
  i:TInt;
  r:TReal;
 begin
  r:=0;
  for i:=0 to Size_ do
   r:=r+x[i]*CodeArray[i];
  MakeCode:=r;
 end;
{******************************************************************************}
 Function TCryptographer.MakeCode(var x : TIntArray):TReal;
 var
  i:TInt;
  r:TReal;
 begin
{O-}
  r:=0;
  for i:=0 to Size_ do
   r:=r+x[i]*CodeArray[i];
  MakeCode:=r;
{O+}  
 end;
{******************************************************************************}
 Procedure TCryptographer.Assign(var x:TCryptographer);
 var i:TInt;
 begin
  if Size <> x.Size then Size := x.Size;
  for i:=0 to Size_ do CodeArray[i]:=x.CodeArray[i];
 end;
{******************************************************************************}
 Procedure TCryptographer.SetSize(x :TInt);
 begin
  FreeMemory; 
  FSize:=x;
  GetMemory;
 end;
{******************************************************************************}
 Function TCryptographer.GetSize_ :TInt;
 begin
  GetSize_:=Size-1;
 end;
{******************************************************************************}
end.
