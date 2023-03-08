unit Buffer;
interface
 uses
  VarType;
 type

  PTBuffer = ^TBuffer;
  PTMachine = ^TMachine;

  TMachine = Record

   Number : TInt; //Machine number
   ListNumberGDB : TInt; //Number in list of giving detail buffer
   ListNumberTDB : TInt; //Number in list of taking detail buffer

   Lambda : TReal;
   Mu : TReal;
   C : TReal;

   NumberGDB : TInt; //Number giving detail buffer
   NumberTDB : TInt; //Number taking detail buffer
  end;

  TBuffer = Class
  private
   FNumber : TInt; //Buffer number
   FSize : TReal;
   FMachineQuantity : TInt;
   FPDMQuantity : TInt; //Puting detail machine quantity
   FTDMQuantity : TInt; //Taking detail machine quantity
   Procedure SetMachineQuantity(x:TInt);
   Function GetMachineQuantity_:TInt;
  public

   NumberPDM : array of TInt; //Puting detail machine
   NumberTDM : array of TInt; //Taking detail machine

   Constructor Create(var x : TBuffer);overload;
   Destructor Destroy;override;
   Procedure GetMemory;
   Procedure FreeMemory;

   Procedure Assign(var x : TBuffer);

   Function AddPDMachine(x : TInt): TInt;
   Function AddTDMachine(x : TInt): TInt;

   Property Number : TInt read FNumber write FNumber;
   Property Size : TReal read FSize write FSize;
   Property PDMQuantity : TInt read FPDMQuantity write FPDMQuantity;
   Property TDMQuantity : TInt read FTDMQuantity write FTDMQuantity;
   Property MachineQuantity : TInt read FMachineQuantity write SetMachineQuantity;
   Property MachineQuantity_ : TInt read GetMachineQuantity_;

  end;
implementation
{******************************************************************************}
 Constructor TBuffer.Create(var x : TBuffer);
 begin
  Assign(x);
 end;
{******************************************************************************}
 Destructor TBuffer.Destroy;
 begin
  FreeMemory;
 end;
{******************************************************************************}
 Procedure TBuffer.GetMemory;
 begin
  if Length(NumberPDM) = 0 then SetLength(NumberPDM,MachineQuantity);
  if Length(NumberTDM) = 0 then SetLength(NumberTDM,MachineQuantity);
 end;
{******************************************************************************}
 Procedure TBuffer.FreeMemory;
 begin
  if Length(NumberPDM)<>0 then Finalize(NumberPDM);
  if Length(NumberTDM)<>0 then Finalize(NumberTDM);
  FNumber :=0;
  FSize :=0;
  FMachineQuantity := 0;
  FPDMQuantity := 0;
  FTDMQuantity := 0;
 end;
{******************************************************************************}
 Procedure TBuffer.Assign(var x : TBuffer);
 begin
  if MachineQuantity <> x.MachineQuantity then MachineQuantity:=x.MachineQuantity;
  Size:=x.Size;
  PDMQuantity:=x.PDMQuantity;
  TDMQuantity:=x.TDMQuantity;
  Number:=x.Number;
  Move(x.NumberPDM[0],NumberPDM[0],MachineQuantity*SizeOf(TInt));
  Move(x.NumberTDM[0],NumberTDM[0],MachineQuantity*SizeOf(TInt));
 end;
{******************************************************************************}
 Function TBuffer.AddPDMachine(x : TInt): TInt;
 begin
  NumberPDM[PDMQuantity]:=x;
  PDMQuantity := PDMQuantity+1;
  AddPDMachine := PDMQuantity-1;
 end;
{******************************************************************************}
 Function TBuffer.AddTDMachine(x : TInt): TInt;
 begin
  NumberTDM[TDMQuantity]:=x;
  TDMQuantity := TDMQuantity+1;
  AddTDMachine := TDMQuantity-1;
 end;
{******************************************************************************}
 Procedure TBuffer.SetMachineQuantity(x:TInt);
 begin
  FreeMemory;
  FMachineQuantity:=x;
  GetMemory;  
 end;
{******************************************************************************}
 Function TBuffer.GetMachineQuantity_ : TInt;
 begin
  GetMachineQuantity_ := MachineQuantity-1;
 end;
{******************************************************************************}
end.
