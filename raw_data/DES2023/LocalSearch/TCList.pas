unit TCList;{Two connect list}
{$MODE OBJFPC}
interface
uses Equalable;
 type
  PTObject = ^TObject;
  TEqualFunction = function(x,y:PTObject):boolean;
  PTElement = ^TElement;
  TElement = Class
   Next : PTElement;
   Previous : PTElement;
   data:PTObject;
  end;

  PTTCList = ^TTCList;
  TTCList = Class
  public
   EqualFunction:TEqualFunction;

   First    :PTElement;
   CurrentLast    :PTElement;
   Last    :PTElement;

   MaxCapacity     :Integer;
   CurentCapacity  :Integer;
   Size  :Integer;

   Constructor Create(func:TEqualFunction);
   Destructor Destroy;override;

   Procedure GetMemory;
   Procedure FreeMemory;

   function CreateNewElement:PTElement;

   Procedure PushInListEnd(d:PTObject);
   Procedure PushOutFirst;

   procedure Add(s:PTObject);overload;

   function Find(x:PTObject):PTObject;

  end;
implementation
uses
 Sysutils;
{******************************************************************************}
 Constructor TTCList.Create(func:TEqualFunction);
 begin
  EqualFunction:=func;

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
  i:Integer;
 begin
  i:=1;
  while i < MaxCapacity do
  begin
   PushInListEnd(nil);
   i:=i+1;
  end;
 end;
{******************************************************************************}
 Procedure TTCList.FreeMemory;
 begin
  while CurentCapacity > 1 do PushOutFirst;
  MaxCapacity    :=0;
  CurentCapacity :=0;
 end;
{******************************************************************************}
function TTCList.CreateNewElement:PTElement;
var
 x:PTElement;
begin
  new(x);
  x^ :=TElement.Create;
  CreateNewElement:=x;
end;

{******************************************************************************}
 Procedure TTCList.PushInListEnd(d:PTObject);
 var
  x:PTElement;
 begin
  x:= CreateNewElement;
  x^.Data := d;
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
 procedure TTCList.Add(s:PTObject);
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

   First^.Data := s;

   if Size < CurentCapacity then Size:=Size + 1;
 end;
{******************************************************************************}
 function TTCList.Find(x:PTObject):PTObject;
 var
  p:PTElement;
  i:Integer;
  b:Boolean;
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
    if EqualFunction(p^.Data,x) then
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
   Find:=nil
  else
  begin
   Find:=first^.data;
  end;

 end;
{******************************************************************************}
end.
