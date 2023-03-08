unit TCList;{Two connect list}
interface
uses
 VarType,
 Solution;
 type
  PTEData = PTSolution;
  TEData = TSolution;

  PTElement = ^TElement;
  TElement = Class(TEData)
   Next : PTElement;
   Previous : PTElement;
   Constructor Create(var x:TEData);overload;
  end;

  PTTCList = ^TTCList;
  TTCList = Class
  public

   First    :PTElement;
   CurrentLast    :PTElement;
   Last    :PTElement;

   MaxCapacity     :TInt;
   CurentCapacity  :TInt;
   Size  :TInt;

   Constructor Create;
   Destructor Destroy;override;

   Procedure GetMemory;
   Procedure FreeMemory;

   Procedure PushInListEnd(var x:PTElement);
   Procedure PushOutFirst;

   procedure Add(var s:TEData);overload;

   function FindTheSameElement(var ind:TEData):PTEData;

  end;
implementation
uses
 Sysutils;
{******************************************************************************}
 Constructor TElement.Create(var x:TEData);
 begin
  inherited Create(x);
 end;
{******************************************************************************}
 Constructor TTCList.Create;
 begin
  CurentCapacity  :=0;
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
 Destructor TTCList.Destroy;
 begin
  FreeMemory;
  First^.Destroy;
  First:=nil;
 end;
{******************************************************************************}
 Procedure TTCList.GetMemory;
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
 Procedure TTCList.FreeMemory;
 begin
  while MaxCapacity > 1 do PushOutFirst;
  MaxCapacity    :=0;
 end;
{******************************************************************************}
 Procedure TTCList.PushInListEnd(var x:PTElement);
 begin
  x^.Next:=nil;
  Last^.Next:=x;
  x^.Previous:=Last;
  Last:=x;
 end;
{******************************************************************************}
 procedure TTCList.PushOutFirst;
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

   if Size<>0 then Size:=Size-1;
   if CurentCapacity<>0 then CurentCapacity :=CurentCapacity-1;
   MaxCapacity :=MaxCapacity-1;
  end;
 end;

{******************************************************************************}
 procedure TTCList.Add(var s:TEData);
  var p:PTElement;
 begin
  if CurentCapacity <> 0 then
   if not(Size = 0) and not( (Size = CurentCapacity) and (CurentCapacity = 1 ) ) then
   begin

    if Size = CurentCapacity then
    begin
     p:=CurrentLast;
     CurrentLast:=CurrentLast^.Previous;
    end
    else p:=CurrentLast^.Next;

    if (MaxCapacity = CurentCapacity) and (Size >= CurentCapacity-1) then
    begin
     CurrentLast^.Next:=Nil;
     Last:=CurrentLast;
    end
    else
    begin
     CurrentLast^.Next:=p^.Next;
     p^.Next^.Previous:=CurrentLast;
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
 function TTCList.FindTheSameElement(var ind:TEData):PTEData;
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
      if p^.Next <> nil then p^.Next^.Previous:=p^.Previous;
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
end.
