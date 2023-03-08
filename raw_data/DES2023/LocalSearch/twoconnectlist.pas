unit TwoConnectList;{Two connect list}
{$MODE OBJFPC}
interface
 type
  PTObject = ^TObject;
  TEqualFunction = function(const x,y:PTObject):boolean of object;

  PTElement = ^TElement;
  TElement = Class
   Next : PTElement;
   Previous : PTElement;
   Data:PTObject;
  end;

  PTTwoConnectList = ^TTwoConnectList;
  TTwoConnectList = Class
  protected
   First    :PTElement;
   Last    :PTElement;

   _MaxSize:Integer;
   Size   :Integer;

   EqualFunction:TEqualFunction;

  public
   Constructor Create(func:TEqualFunction; MaxSizeList:Integer = 100);
   Destructor Destroy;override;

   Procedure GetMemory;
   Procedure FreeMemory;

   Procedure PushInEnd(d:PTObject);
   Procedure PushInBegin(d:PTObject);
   Procedure PushOutFirst;
   Procedure PushOutLast;

   procedure Add(x:PTObject);overload;

   function Find(x:PTObject):PTObject;

   Property MaxSize:Integer read _MaxSize write _MaxSize;

  end;
implementation
uses
 Sysutils;
{******************************************************************************}
 Constructor TTwoConnectList.Create(func:TEqualFunction; MaxSizeList:Integer = 100);
 begin
  EqualFunction:=func;

  Size    := 0;
  MaxSize := MaxSizeList;

  First := nil;
  Last := nil;

 end;
{******************************************************************************}
 Destructor TTwoConnectList.Destroy;
 begin
  FreeMemory;
  First^.Destroy;
  First:=nil;
  Last:=nil;
 end;
{******************************************************************************}
 Procedure TTwoConnectList.GetMemory;
 begin
 end;
{******************************************************************************}
 Procedure TTwoConnectList.FreeMemory;
 begin
  while size > 1 do PushOutFirst;
  size  :=0;
 end;
{******************************************************************************}
 Procedure TTwoConnectList.PushInEnd(d:PTObject);
 var
  x:PTElement;
 begin
  if size = 0  then
  begin
    new(First);
    First^ :=TElement.Create;

    First^.Next:=nil;
    First^.Previous:=nil;
    First^.Data:=d;

    Last := First;

    size :=1;
  end
  else
  begin
    new(x);
    x^ :=TElement.Create;
    x^.Data := d;
    x^.Next:=nil;
    Last^.Next:=x;
    x^.Previous:=Last;
    Last:=x;
    size :=Size+1;
  end
 end;
{******************************************************************************}
Procedure TTwoConnectList.PushInBegin(d:PTObject);
var
 x:PTElement;
begin
 if size = 0  then
 begin
   new(First);
   First^ :=TElement.Create;

   First^.Next:=nil;
   First^.Previous:=nil;
   First^.Data:=d;

   Last := First;

   size :=1;
 end
 else
 begin
   new(x);
   x^ :=TElement.Create;
   x^.Next:=nil;
   x^.Previous:=nil;
   x^.Data := d;

   x^.Next:=First;
   First^.Previous:=x;

   First:=x;
   size :=Size+1;
 end
end;
{******************************************************************************}
 procedure TTwoConnectList.PushOutFirst;
 var
  p:PTElement;
 begin
  p:=First;
  if p<>Last then
  begin
   First:=First^.next;
   first^.Previous:=nil;

   p^.Destroy;
   Finalize(p);

   if Size<>0 then Size:=Size-1;
  end
  else
  begin
   p^.Destroy;
   Finalize(p);
   First:=nil;
   Last:=nil;
   size:=0;
  end
 end;
{******************************************************************************}
 procedure TTwoConnectList.PushOutLast;
 var
  p:PTElement;
 begin
  p:=Last;
  if p<>First then
  begin
   Last:=Last^.Previous;
   Last^.Next:=nil;

   p^.Destroy;
   Finalize(p);

   if Size<>0 then Size:=Size-1;
  end
  else
  begin
   p^.Destroy;
   Finalize(p);
   First:=nil;
   Last:=nil;
   size:=0;
  end
 end;

{******************************************************************************}
 procedure TTwoConnectList.Add(x:PTObject);
  var p:PTElement;
 begin
  while Size >= _MaxSize do PushOutLast;
  PushInBegin(x);
 end;
{******************************************************************************}
 function TTwoConnectList.Find(x:PTObject):PTObject;
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
