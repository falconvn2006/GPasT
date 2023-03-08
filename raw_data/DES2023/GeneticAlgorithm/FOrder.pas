unit FOrder;

{$MODE Delphi}

interface
uses VarType;
 Procedure SimpleOrder(var a:TIntArray);
 Procedure RandomOrder(var a:TIntArray);
 Procedure BottleneckOrder(var a:TIntArray);
implementation
{------------------------------------------------------------------------------}
 Procedure SimpleOrder(var a:TIntArray);
 var i:TInt;
 begin
  for i:=0 to High(a) do
   a[i]:=i;
 end;
{------------------------------------------------------------------------------}
 Procedure RandomOrder(var a:TIntArray);
 var
  i,j:TInt;
  new:TInt;
  b:TIntArray;
 begin
  SetLength(b,Length(a));
  Randomize();
  for i:=0 to High(a) do
  begin
   j:=random(Length(a));
   new:=b[j];
   while new = 1 do
   begin
    j:=(j+1) mod Length(a);
    new:=b[j];
   end;
   b[j]:=1;
   a[i]:=j;
  end;
  Finalize(b);
 end;
{------------------------------------------------------------------------------}
 Procedure BottleneckOrder(var a:TIntArray);
 begin
 end;
{------------------------------------------------------------------------------}
end.
