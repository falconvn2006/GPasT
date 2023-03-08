unit vect;
interface
type
  VectIndex = integer;
  VectElem  = real;
  arr=array [1..255] of VectElem;
  Vector = class
  Private
    VectorSize:VectIndex;
    Function GetSize:VectIndex;
  Public
    PVector:^arr;
    Constructor Init(x:VectIndex);
    Destructor Done;
    Procedure Null;
    Function InRange(y:VectIndex):boolean;
    Function GetElem(y:VectIndex):VectElem;
    Procedure AssignElem(y:VectIndex;Val:VectElem);
    Procedure Assign(V:Vector);
    Procedure Multiply(a:VectIndex);
    Procedure Abbition(V1:Vector; var V2:Vector);
    Function SkalMult(V1:vector):vectelem;
    Property Size:VectIndex
             Read GetSize;
end;
implementation
  Constructor Vector.Init(x:VectIndex);
  Begin
    getmem(PVector,x*sizeof(VectElem));
    VectorSize:=x;
  end;
  Destructor Vector.Done;
  Begin
    freemem(PVector,VectorSize*sizeof(VectElem));
  end;
  procedure Vector.Null;
  Begin
    PVector := nil;
  end;
  Function Vector.InRange(y:VectIndex):boolean;
  Begin
    inrange:=(y<=VectorSize) and (0<y);
  end;
  Function Vector.GetElem(y:VectIndex):VectElem;
  begin
   if InRange(y) then
     GetElem:=PVector^[Y];
  end;
  procedure Vector.AssignElem(y:VectIndex;Val:VectElem);
  begin
    PVector^[Y]:=Val;
  end;
 procedure Vector.Assign(V:Vector);
  var i:VectIndex;
  begin
    for i:=1 TO VectorSize do PVector^[i]:=v.getelem(i);
  end;
 procedure Vector.Multiply(a:VectIndex);
  var i:VectIndex;
  begin
       for i:=1 to VectorSize do
                        PVector^[i]:=a*PVector^[i];
  end;
procedure vector.abbition(V1:Vector; var V2:Vector);
 var i:VectIndex;
 begin
    for i:=1 to VectorSize do v2.assignelem(i,pvector^[I]+V1.GETELEM(i));
 end;
 function vector.skalmult(V1:vector):vectelem;
 var i:VectIndex;s:vectelem;
 begin
      s:=0;
      for i:=1 to VectorSize do
       begin
            S:=s+(v1.getelem(i)*pvector^[i]);
       end;
       skalmult:=s;
 end;
 Function Vector.GetSize:VectIndex;
 begin
   GetSize:=VectorSize;
 end;

 end.


