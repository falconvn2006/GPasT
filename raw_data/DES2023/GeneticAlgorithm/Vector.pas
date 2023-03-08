unit Vector;
interface
 uses
  VarType,
  Cryptographer;
 type

  PTVector = ^TVector;
  TVector = Class
  private
   FCode             :TReal;
   FSize             :TInt;
   Function GetVolume:TInt;
   Function GetSize_ :TInt;
   Procedure SetSize(x:TInt);
  public
   Element          :TIntArray;

   Constructor Create();overload;
   Constructor Create(var x : TVector);overload;
   Destructor Destroy;override;

   Procedure GetMemory;
   Procedure FreeMemory;

   Procedure FillBy(x: TInt);
   Procedure Assign(var x:TVector);overload;

   Function Equal(var x:TVector):TBool;

   Procedure GetCode(var x:TCryptographer);

   Property Volume:TInt read GetVolume;
   Property Code:TReal read FCode write FCode;
   Property Size:TInt read FSize write SetSize;
   Property Size_:TInt read GetSize_;
  end;
implementation
 {******************************************************************************}
 Constructor TVector.Create();
 begin
   FCode:=-1;
   FSize:=0;
 end;
{******************************************************************************}
 Constructor TVector.Create(var x : TVector);
 begin
  Assign(x);
 end;
{******************************************************************************}
 Destructor TVector.Destroy;
 begin
  FreeMemory;
 end;
{******************************************************************************}
 Procedure TVector.GetMemory;
 begin
  SetLength(Element,FSize);
 end;
{******************************************************************************}
 Procedure TVector.FreeMemory;
 begin
  Finalize(Element);
 end;
{******************************************************************************}
 Procedure TVector.FillBy(x:TInt);
 var i : TInt;
 begin
  for i:=0 to Size_ do  Element[i]:=x;
 end;
{******************************************************************************}
 Procedure TVector.Assign(var x:TVector);
 var i:TInt;
 begin
  if x.Size <> Size then Size:=x.Size;
  for i:=0 to Size_ do  Element[i] := x.Element[i];
  FCode  :=x.Code;
 end;
{******************************************************************************}
 Function TVector.Equal(var x:TVector):TBool;
 var i:TInt;
 begin
  Equal:=false;
  if (Code = x.Code) and (Size = x.Size) then
  begin
   Equal:=true;
   for i:=0 to Size_ do
    if x.Element[i] <> Element[i] then
    begin
     Equal:=false;
     break;
    end;
  end;
 end;
{******************************************************************************}
 Procedure TVector.GetCode(var x:TCryptographer);
 begin
  FCode:=x.MakeCode(Element);
 end;
{******************************************************************************}
 Function TVector.GetVolume:TInt;
 var i:TInt;
 begin
  GetVolume:=0;
  for i:=0 to Size_ do  GetVolume := GetVolume + Element[i];
 end;
{******************************************************************************}
 Function TVector.GetSize_:TIndex;
 begin
  GetSize_:=FSize-1;
 end;
{******************************************************************************}
 Procedure TVector.SetSize(x:TInt);
 begin
  FreeMemory;
  FSize:=x;
  GetMemory;
 end;
{******************************************************************************}
end.

