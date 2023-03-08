unit BAPHashList;
{$mode objfpc}{$H+}
interface
 uses
  Hash,
  BAPSolution,
  TwoConnectList;
 type
  PTBAPHashList = ^TBAPHashList;
  TBAPHashList = Class(THash)
  public
   Capacity :Integer;
   List :TTwoConnectList;

   Constructor Create;
   Destructor Destroy;override;

   Procedure GetMemory;virtual;
   Procedure FreeMemory;virtual;

   procedure Add(x:PTObject);
   function Find(x:PTObject):PTObject;
   function Equal(const x,y:PTObject):boolean;

   Function GetMaxSize:Integer;
   Procedure SetMaxSize(s:integer);
   Property MaxSize:Integer read GetMaxSize write SetMaxSize;

  end;
implementation
 uses Math, SysUtils;
 {******************************************************************************}
 Constructor TBAPHashList.Create;
 var p:TEqualFunction;
 begin
   p:= @Equal;
  List:=TTwoConnectList.Create(p);
 end;
{******************************************************************************}
 Destructor TBAPHashList.Destroy;
 begin
  FreeMemory;
 end;
{******************************************************************************}
 Procedure TBAPHashList.GetMemory;
 begin
 end;
{******************************************************************************}
 Procedure TBAPHashList.FreeMemory;
 begin
  List.FreeMemory;
 end;
{******************************************************************************}
 procedure TBAPHashList.Add(x:PTObject);
 begin
  List.Add(x);
 end;
{******************************************************************************}
 function TBAPHashList.Find(x:PTObject):PTObject;
 begin
  Find := List.Find(x);
 end;
{******************************************************************************}
function TBAPHashList.Equal(const x,y:PTObject):boolean;
begin
  Equal:= TBAPSolution(x).IsIdentical(y^);
end;
{******************************************************************************}
Function TBAPHashList.GetMaxSize:Integer;
begin
  GetMaxSize:=List.MaxSize;

end;

{******************************************************************************}
Procedure TBAPHashList.SetMaxSize(s:integer);
begin
  List.MaxSize:=s;
end;

{******************************************************************************}
end.

