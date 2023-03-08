unit TabuList;
interface
uses
 VarType,
 Solution;
 type
  PTEData = ^TEData;
  TEData = Class
   Index:TInt;
   Tabu:TInt;
   Constructor Create(var x:TEData);overload;
   Procedure Assign(var x:TEData);
   Function Equal(var x:TEData):TBool;overload;
   Function Equal(x:TInt;i:TInt):TBool;overload;
  end;

  PTElement = ^TElement;
  TElement = Class(TEData)
   Next : PTElement;
   Previous : PTElement;
   Constructor Create(var x:TEData);overload;
  end;

  PTTabuList = ^TTabuList;
  TTabuList = Class
  private
   FCurentCapacity  :TInt;
   procedure ChangeCapacity(s:TInt);
  public

   First    :PTElement;
   CurrentLast    :PTElement;
   Last    :PTElement;

   MaxCapacity     :TInt;
   Size  :TInt;

   Constructor Create;
   Destructor Destroy;

   Procedure GetMemory;
   Procedure FreeMemory;

   Procedure PushInListEnd(var x:PTElement);
   Procedure PushOutFirst;

   procedure Add(var s:TEData);overload;
   procedure Add(var s,s1:TSolution);overload;

   function FindTheSameElement(var ind:TEData):PTEData;
   function Tabu(x:TInt;j:TInt):TBool;

   property CurentCapacity:TInt read FCurentCapacity write ChangeCapacity;
  end;
implementation
uses
 Sysutils,
 Main;
{******************************************************************************}
 Constructor TEData.Create(var x:TEData);
 begin
  Assign(x);
 end;
{******************************************************************************}
 Procedure TEData.Assign(var x:TEData);
 begin
  Index:=x.Index;
  Tabu:=x.Tabu;
 end;
{******************************************************************************}
 Function TEData.Equal(var x:TEData):TBool;
 begin
  if (Index=x.Index) and (Tabu=x.Tabu) then Equal:=True
  else Equal:=False;
 end;
{******************************************************************************}
 Function TEData.Equal(x:TInt;i:TInt):TBool;
 begin
  if (Index=I) and (Tabu=x) then Equal:=True
  else Equal:=False;
 end;
{******************************************************************************}
 Constructor TElement.Create(var x:TEData);
 begin
  inherited Create(x);
 end;
{******************************************************************************}
 Constructor TTabuList.Create;
 begin
  FCurentCapacity  :=0;
  MaxCapacity     :=0;
  Size            :=0;

  new(First);
  First^ :=TElement.Create;

  First^.Next:=nil;
  First^.Previous:=nil;

  CurrentLast := First;
  Last := First;
 end;
{******************************************************************************}
 Destructor TTabuList.Destroy;
 begin
  FreeMemory;
  First^.Destroy;
  First:=nil;
 end;
{******************************************************************************}
 Procedure TTabuList.GetMemory;
 var
  x:PTElement;
  i:TInt;
 begin
  i:=1;
  while i < MaxCapacity do
  begin
   new(x);
   x^ :=TElement.Create;
   PushInListEnd(x);
   i:=i+1;
  end;
 end;
{******************************************************************************}
 Procedure TTabuList.FreeMemory;
 begin
  while MaxCapacity > 1 do PushOutFirst;
  MaxCapacity    :=0;
 end;
{******************************************************************************}
 Procedure TTabuList.PushInListEnd(var x:PTElement);
 begin
  x^.Next:=nil;
  Last^.Next:=x;
  x^.Previous:=Last;
  Last:=x;
 end;
{******************************************************************************}
 procedure TTabuList.PushOutFirst;
 var
  p:PTElement;
 begin
  p:=First; 
  if p<>Last then
  begin
   First:=First^.next;
   if p = CurrentLast then CurrentLast := First;

   first^.Previous:=nil;

   p^.Destroy;
   p:=nil;

   if Size<>0 then Size:=Size-1;
   if CurentCapacity<>0 then CurentCapacity :=CurentCapacity-1;
   MaxCapacity :=MaxCapacity-1;
  end;
 end;

{******************************************************************************}
 procedure TTabuList.Add(var s:TEData);
  var p:PTElement;
 begin
 
  if CurentCapacity <> 0 then
   if not
    ((Size=0)or(CurentCapacity=1))
   then
   begin

    if Size = CurentCapacity then
    begin
     p:=CurrentLast;
     CurrentLast:=CurrentLast^.Previous;
     if MaxCapacity = CurentCapacity then
     begin
      CurrentLast^.Next:=Nil;
      Last:=CurrentLast;
     end
     else
     begin
      CurrentLast^.Next:=p^.Next;
      p^.Next^.Previous:=CurrentLast;
     end;
    end
    else
    begin
     p:=CurrentLast^.Next;
     if (MaxCapacity = CurentCapacity) and (Size = CurentCapacity-1) then
     begin
      CurrentLast^.Next:=Nil;
      Last:=CurrentLast;
     end
     else
     begin
      CurrentLast^.Next:=p^.Next;
      p^.Next^.Previous:=CurrentLast;
     end;
    end;
    p^.Previous:=nil;
    p^.Next:=First;
    First^.Previous:=p;
    First:=p;

   end;
   First^.Assign(s);
   if Size < CurentCapacity then Size:=Size + 1;

 end;
{******************************************************************************}
 procedure TTabuList.Add(var s,s1:TSolution);
 var
  i:TInt;
  ss:TEData;
 begin
  ss:=TEData.Create;
  for i:=0 to s.Size_ do
   if s.Element[i]<>s1.element[i] then
   begin
    ss.Index:=i;
    ss.Tabu:=s.Element[i];
    Add(ss);
   end;
  ss.Destroy;
 end;
{******************************************************************************}
 function TTabuList.FindTheSameElement(var ind:TEData):PTEData;
 var
  p:PTElement;
  q:PTEData;
  i:TInt;
  b:TBool;
 begin

  if Size = 0 then
   b:=false
  else

  begin

   p:=first;

   b:=false;

   i:=0;
   while i < Size do
   begin

    if p^.Equal(ind) then
    begin
     b:=true;

     if p <> first then
     begin
      if p = CurrentLast then
      begin
       if p = Last then Last:=p^.Previous;
       CurrentLast:=p^.Previous;
      end;
      p^.Previous^.Next:=p^.Next;
      if p <> Last then p^.Next^.Previous:=p^.Previous;
      p^.Previous:=nil;
      p^.Next:=First;
      First^.Previous:=p;
      First:=p;
     end;

     break;

    end;

    p:=p^.next;

    i:=i+1;

   end;
  end;

  if b = false then
   FindTheSameElement:=nil
  else
  begin
   FindTheSameElement:=PTEData(first);
  end;

 end;
{******************************************************************************}
 function TTabuList.Tabu(x:TInt;j:TInt):TBool;
 var
  p:PTElement;
  i:TInt;
  b:TBool;
 begin

  if Size = 0 then
   b:=false
  else

  begin

   p:=first;

   b:=false;

   for i:=1 to Size do
    if p^.Equal(x,j) then
    begin
     b:=true;
     break;
    end
    else p:=p^.next;

  end;

  Tabu:=b;
 end;
{******************************************************************************}
 procedure TTabuList.ChangeCapacity(s:TInt);
 var
  i:TInt;
  p:PTElement;
 begin
  if s <= MaxCapacity then
  begin
   FCurentCapacity:=s;
   if Size > FCurentCapacity then Size:=FCurentCapacity;
   p:=first;
   for i:=2 to Size do p:=p^.Next;
   CurrentLast:=p;
  end;
 end;
{******************************************************************************}
end.


