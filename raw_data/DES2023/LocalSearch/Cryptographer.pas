unit Cryptographer;
{$MODE OBJFPC}
interface
 type
  PTCryptographer = ^TCryptographer;
  TCryptographer = Class
  private
   _Size :Integer;
  public
   CodeArray :Array of double;

   Constructor Create(var x:TCryptographer);overload;
   Destructor Destroy;override;

   Procedure GetMemory;
   Procedure FreeMemory;

   Procedure Assign(var x:TCryptographer);

   Function MakeCode(var x : array of double):double;overload;
   Function MakeCode(var x : array of integer):double;overload;


   Function GetSize_:Integer;
   Procedure SetSize(x:Integer);

   Property Size :integer read _Size write SetSize;
   Property Size_ :integer read GetSize_;
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
  j,t:integer;
  k:double;
  b:boolean;
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
 Function TCryptographer.MakeCode(var x : array of double):double;
 var
  i:integer;
  r:double;
 begin
  r:=0;
  for i:=0 to Size_ do
   r:=r+x[i]*CodeArray[i];
  MakeCode:=r;
 end;
{******************************************************************************}
 Function TCryptographer.MakeCode(var x : array of integer):double;
 var
  i:integer;
  r:double;
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
 var i:integer;
 begin
  if Size <> x.Size then Size := x.Size;
  for i:=0 to Size_ do CodeArray[i]:=x.CodeArray[i];
 end;
{******************************************************************************}
 Procedure TCryptographer.SetSize(x :integer);
 begin
  FreeMemory; 
  _Size:=x;
  GetMemory;
 end;
{******************************************************************************}
 Function TCryptographer.GetSize_ :integer;
 begin
  GetSize_:=Size-1;
 end;
{******************************************************************************}
end.
