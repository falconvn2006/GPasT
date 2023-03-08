unit MachineLine;
interface
 uses
  VarType,
  Buffer,
  Classes;
 const
  MS = 2147483647;
  eps = 1e-6;
 type

  PTMachineLine = ^TMachineLine;
  TMachineLine = Class
  private
   FCMQuantity : TInt; //Considered machine quantity
   FCBQuantity : TInt; //Considered buffer quantity

   FMachineQuantity : TInt;
   FBufferQuantity : TInt;


   Procedure SetMachineQuantity(x:TInt);
   Procedure SetBufferQuantity(x:TInt);

   Function GetMachineQuantity_: TInt;
   Function GetBufferQuantity_: TInt;
  public
   Machine : array of TMachine;
   Buffer : array of TBuffer;

   CMachine : TBoolArray; //machine that we use
   CBuffer : TBoolArray; //buffer that we use

   Constructor Create(var x : TMachineLine);overload;
   Destructor Destroy;override;

   Procedure GetMachineMemory;
   Procedure GetBufferMemory;
   Procedure FreeMachineMemory;
   Procedure FreeBufferMemory;

   Procedure Load(var f : TStringList);overload;
   Procedure Assign(var x:TMachineLine);

   Function R1:TIndex;
   Function R1f:TIndex;

   procedure parl(var l1,m1,u1,l2,m2,u2:TReal);

   Procedure ReduceLine(
             var l1,m1,u1,stock_cost:TReal;
             var inv_coef:TReal;
             var det_cost:TRealArray
                       );
   procedure equiv(var lam1r,mu1r,deb1r,lam2r,mu2r,deb2r,hr,avg_stockr:TReal);

   Property CMQuantity: TInt read FCMQuantity write FCMQuantity;
   Property CBQuantity: TInt read FCBQuantity write FCBQuantity;

   Property MachineQuantity: TInt read FMachineQuantity write SetMachineQuantity;
   Property BufferQuantity: TInt read FBufferQuantity write SetBufferQuantity;

   Property MachineQuantity_: TIndex read GetMachineQuantity_;
   Property BufferQuantity_: TIndex read GetBufferQuantity_;
  end;
implementation
{******************************************************************************}
 Constructor TMachineLine.Create(var x:TMachineLine);
 begin
  Assign(x);
 end;
{******************************************************************************}
 Destructor TMachineLine.Destroy;
 begin
  FreeMachineMemory;
  FreeBufferMemory;
 end;
{******************************************************************************}
 Procedure TMachineLine.GetMachineMemory;
 var i : TInt;
 begin
  SetLength(Machine,MachineQuantity);
  SetLength(CMachine,MachineQuantity);
  for i:=0 to MachineQuantity_ do CMachine[i]:=True;
  CMQuantity:=MachineQuantity;
 end;
{******************************************************************************}
 Procedure TMachineLine.GetBufferMemory;
 var i : TInt;
 begin
  SetLength(Buffer,BufferQuantity);
  SetLength(CBuffer,BufferQuantity);
  for i:=0 to BufferQuantity_ do
  begin
   CBuffer[i]:=True;
   Buffer[i]:=TBuffer.Create;
  end;
  CBQuantity:=BufferQuantity;
 end;
{******************************************************************************}
 Procedure TMachineLine.FreeMachineMemory;
 begin
  if 0 <> Length(Machine) then  Finalize(Machine);
  if 0 <> Length(CMachine) then  Finalize(CMachine);
  CMQuantity:=0;
 end;
{******************************************************************************}
 Procedure TMachineLine.FreeBufferMemory;
 var i : TInt;
 begin
  if Length(Buffer)<>0 then
  begin
   for i:=0 to High(Buffer) do Buffer[i].Destroy;
   Finalize(Buffer);
  end;
  if 0 <> Length(CBuffer) then Finalize(CBuffer);
  CBQuantity:=0;
 end;
{******************************************************************************}
 Procedure TMachineLine.Load(var f : TStringList);
 var
  i,j,l,n,sz,cod,m,b,i1,i2:TInt;
  lam,mu,c:TReal;
  s,k:TString;
  ss:array[0..2] of TString;

 begin
  i:=0;
  s:='';
  k:='';

  while (k <> 'BML') and (i <> f.Count) do
  begin
   s:=f.Strings[i];
   i:=i+1;
   while (pos(' ',s) = j) and (j<>0) do delete(s,j,1);
   j:=pos(' ',s);
   if j = 0 then k:=s
   else k:=Copy(s,1,j-1);
  end;

  s:=f.Strings[i];
  i:=i+1;

  j:=pos(' ',s);
  k:=Copy(s,1,j-1);
  delete(s,1,j);
  val (k,b,cod);
  BufferQuantity:=b;
  while (pos(' ',s) = j) and (j<>0) do delete(s,j,1);
  val (s,m,cod);
  MachineQuantity:=m;

  l:=0;
  while (l<>BufferQuantity) and (i <> f.Count) do
  begin
   n:=0;
   s:=f.Strings[i];
   i:=i+1;
   j:=pos(':',s);
   k:=Copy(s,1,j-1);
   val (k,n,cod);
   k:=Copy(s,j+1,length(s));
   while pos(' ',k) = 1 do delete(k,1,1);

   Buffer[n-1].MachineQuantity:=MachineQuantity;
   Buffer[n-1].Number:=n-1;
   if k = '*' then Buffer[n-1].Size:=MS
   else
   begin
    val (k,sz,cod);
    Buffer[n-1].Size:=sz;
   end;
   l:=l+1;
  end;

  l:=0;
  while (l < MachineQuantity) and (i <> f.Count) do
  begin
   s:=f.Strings[i];
   i:=i+1;

   while pos(' ',k) = 1 do delete(k,1,1);
   j:=pos(':',s);
   k:=Copy(s,1,j-1);
   delete(s,1,j);
   val (k,n,cod);

   while pos(' ',k) = 1 do delete(k,1,1);
   j:=pos(' ',s);
   k:=Copy(s,1,j-1);
   delete(s,1,j);
   val (k,lam,cod);

   while pos(' ',k) = 1 do delete(k,1,1);
   j:=pos(' ',s);
   k:=Copy(s,1,j-1);
   delete(s,1,j);
   val (k,mu,cod);

   while pos(' ',k) = 1 do delete(k,1,1);
   j:=pos(' ',s);
   k:=Copy(s,1,j-1);
   delete(s,1,j);
   val (k,c,cod);

   while pos(' ',k) = 1 do delete(k,1,1);
   j:=pos(' ',s);
   k:=Copy(s,1,j-1);
   delete(s,1,j);
   val (k,i1,cod);

   while pos(' ',k) = 1 do delete(k,1,1);
   k:=Copy(s,1,length(s));
   delete(s,1,j);
   val (k,i2,cod);

   Machine[n-1].Lambda:=1/(lam*1.0);
   Machine[n-1].Mu:=1/(mu*1.0);
   Machine[n-1].C:=1/(c*1.0);
   Machine[n-1].NumberGDB:=i1-1;
   Machine[n-1].ListNumberGDB:= Buffer[i1-1].AddTDMachine(n-1);
   Machine[n-1].NumberTDB:=i2-1;
   Machine[n-1].ListNumberTDB:= Buffer[i2-1].AddPDMachine(n-1);
   Machine[n-1].Number:=n-1;
   l:=l+1;
  end;
 end;
{******************************************************************************}
 Procedure TMachineLine.Assign(var x:TMachineLine);
 var i:TInt;
 begin
  if MachineQuantity <> x.MachineQuantity then MachineQuantity := x.MachineQuantity;
  if BufferQuantity <> x.BufferQuantity then BufferQuantity := x.BufferQuantity;

  CMQuantity := x.CMQuantity;
  CBQuantity := x.CBQuantity;

  for i:=0 to MachineQuantity_ do
  begin
   Machine[i]:=x.Machine[i];
   CMachine[i]:=x.CMachine[i];
  end;

  for i:=0 to BufferQuantity_ do
  begin
   Buffer[i].Assign(x.Buffer[i]);
   CBuffer[i]:=x.CBuffer[i];
  end;

 end;
{******************************************************************************}
 Function TMachineLine.R1:TInt;
 var
  i,minindex : TInt;
  minsize : TReal;
 begin
  minsize:=Buffer[0].Size;
  minindex:=0;

  for i:=1 to BufferQuantity_ do
  begin
   if  (CBuffer[i] = True)
   and (Buffer[i].Size <= minsize)
   and (Buffer[i].PDMQuantity = 1)
   and (Buffer[i].TDMQuantity = 1) then
   begin
    minsize:=Buffer[i].Size;
    minindex:=i;
   end;
  end;
  R1:= minindex;
 end;
{******************************************************************************}
 Function TMachineLine.R1f:TInt;
 var
  i,index : TInt;
 begin
  index:=0;

  for i:=1 to BufferQuantity_ do
   if  (CBuffer[i] = True)
   and (Buffer[i].PDMQuantity = 1)
   and (Buffer[i].TDMQuantity = 1)
   then
   begin
    index:=i;
    break;
   end;

  while (CBuffer[Machine[Buffer[index].NumberPDM[0]].NumberGDB] = True)
    and (Buffer[Machine[Buffer[index].NumberPDM[0]].NumberGDB].PDMQuantity = 1)
    and (Buffer[Machine[Buffer[index].NumberPDM[0]].NumberGDB].TDMQuantity = 1)
     do index:=Machine[Buffer[index].NumberPDM[0]].NumberGDB;
   
   R1f := index;
 end;
 {******************************************************************************}
 Procedure TMachineLine.ReduceLine(
             var l1,m1,u1,stock_cost:TReal;
             var inv_coef:TReal;
             var det_cost:TRealArray
                       );
 var
//  order1:TIntVector;
  boo,b                 : Boolean;
  ihm,pos,i,j,k,t,tt,hh : TInt;
  hmin,l2,m2,u2,fi1,fi2 : TReal;
  A                     : Char;
  avg_stock,size        : TReal;
  minsize               : TReal;
  {
procedure parl(var l1,m1,u1,l2,m2,u2:TReal);
var pl:treal;
begin
 pl:=u1/(1+l1/m1)+u2/(1+l2/m2);
 u1:=u1+u2;
 l1:=l1*m2/(l2+m2)+l2*m1/(m1+l1);
 m1:=l1/(u1/pl-1);
end;

procedure equiv(var lam1r,mu1r,deb1r,lam2r,mu2r,deb2r,hr,avg_stockr:TReal);
var lam1,mu1,deb1,lam2,mu2,deb2,h,avg_stock,
    fm11x0,fm11xh,fm10x0,fm10xh,fm01x0,fm01xh,fm00x0,fm00xh:TReal;
    f11x0,f11xh,f10x0,f10xh,f01x0,f01xh,f00x0,f00xh:TReal;
    p11x0,p11xh,p10xh,p01x0:TReal;
    lamp,mup,lama,mua,up,ua,deb,i1,i2:TReal;
    pr,prp,pra,mindb,dba,dbp,rp,ra,dp,da,lmp,lma,mp,ma:TReal;
    mia,am,a1,a2,A,B,k:TReal;

function ex (y:TReal):TReal;
begin
 if abs(y) > 88 then y:=round(y/abs(y))*88;
  ex:= exp(y)
end;

procedure func0 (l1,l2,m1,m2,i,u0,h:TReal; var k:TReal);
Var c0:TReal;
begin
 c0:=1/(u0*(l1+l2)/(l1*l2)*(1+2*i)+((1+i)*(1+i))/i*h);
 fm01x0:=c0;  fm01xh:=c0;
 fm10xh:=fm01xh; fm10x0:=fm01x0;
 fm00x0:=i*fm01x0;fm00xh:=fm00x0;
 fm11x0:=c0/i; fm11xh:=fm11x0;
 p11x0:=u0/l2*fm10x0;
 p11xh:=u0/l1*fm01xh;
 p01x0:=u0*(l1+l2)/(m1*l2)*c0;
 p10xh:=u0*(l1+l2)/(m2*l1)*c0;
 f01xh:=c0*h;
 f10xh:=f01xh;
 f11xh:=c0*h/i;
 f00xh:=i*c0*h;
 k:=c0;
END;

procedure func1 (l1,l2,m1,m2,i1,i2,u0,h: TReal; var am,k: TReal);
var c:TReal;
begin
 am:=(l2*m1-l1*m2)/u0*(l1+l2+m1+m2)/((l1+l2)*(m1+m2));
 c:=1/(u0*(l1+l2)/(l2*m1-l1*m2)*((1+i2)/i1*ex(am*h)-(1+i1)/i2));
 fm01x0:=c; fm10x0:=fm01x0;
 fm10xh:=c*ex(am*h); fm01xh:=fm10xh;
 fm11x0:=(m1+m2)/(l1+l2)*c; fm11xh:=fm11x0*ex(am*h);
 fm00x0:=(l1+l2)/(m1+m2)*c; fm00xh:=fm00x0*ex(am*h);
 p11x0:=(u0/l2)*c;
 p11xh:=(u0/l1)*fm10xh;
 p01x0:=u0*(l1+l2)/(m1*l2)*c;
 p10xh:=u0*(l1+l2)/(l1*m2)*fm10xh;
 f01xh:=c*(ex(am*h)-1)/am;
 f10xh:=f01xh;
 f11xh:=(m1+m2)/(l1+l2)*f01xh;
 f00xh:=(l1+l2)/(m1+m2)*f01xh;
 k:=c;
end;

procedure func2 (l1,l2,m1,m2,u1,u2,h:TReal; var a1,a2,A,B,k:TReal);
var E,D,di:TReal;
    W,wm:TReal;
function fufm01(x:treal):TReal;
begin
 if u1>u2 then fufm01:=(w*(a1-A)*ex(a1*x)-w*(a2-A)*ex(a2*x))/B
 else fufm01:=(w*(a1-A)*ex(a1*x-h*(a1-a2))-
               w*(a1-A)*ex(a2*x))*ex(h*(a1-a2))/B
end;

function fufm10 (x:TReal):TReal;
begin
 if u1>u2 then fufm10:=w*ex(a1*x)-w*ex(a2*x)
 else fufm10:=w*ex(h*(a1-a2))*(ex(a1*x-h*(a1-a2))
		 *(a2-A)-(a1-A)*ex(a2*x))/(a2-A)
end;

function loif01 (x:TReal):TReal;
begin
 if abs(a2)<>0 then
  if u1>u2 then
   loif01:=(w*(a1-A)/a1*(ex(a1*x)-1)-w*(a2-A)/a2*(ex(a2*x)-1))/B
  else loif01:=(a1-A)*(w/a1*(ex(a1*x-h*(a1-a2))-ex(-h*(a1-a2)))-w/a2*(ex(a2*x)-1))/B*ex(h*(a1-a2))
 else
  if u1>u2 then loif01:=w*(a1-A)/(B*a1)*(ex(a1*x)-1)+w*A/B*x
  else loif01:=w*(a1-A)/(B*a1)*(ex(a1*x)-1)-w*(a1-A)/B*ex(a1*h)*x
end;

function loif10 (x:TReal):TReal;
begin
 if abs(a2)<>0 then
  if u1<u2 then
   loif10:=(w/a1*(a2-A)*(ex(a1*x-h*(a1-a2))-ex(-h*(a1-a2)))-w*(a1-A)/a2
            *(ex(a2*x)-1))*ex(h*(a1-a2))/(a2-A)
  else loif10:=w*(ex(a1*x)-1)/a1-w*(ex(a2*x)-1)/a2
 else
  if u1>u2 then loif10:=w/a1*(ex(a1*x)-1)-w*x
  else loif10:=w/a1*(ex(a1*x)-1)+w*(a1-A)/A*ex(a1*h)*x
end;

begin {func2}

 A:=l2/(u2-u1)-m2*(m1+m2+l1)/(u1*(m1+m2));
 B:=l2/u1*(m1/(m1+m2)-u2/(u2-u1));
 E:=-l1/u2*(m2/(m1+m2)+u1/(u2-u1));
 D:=l1/(u2-u1)+m1*(m1+m2+l2)/(u2*(m1+m2));
 di:=(A-D)*(A-D)+4*E*B;
 a1:=(A+D+sqrt(di))/2;
 a2:=(A+D-sqrt(di))/2;

 if abs(a1)>abs(a2) then
  mia:=abs(a1)
 else mia:=abs(a2);
  if mia*h < 63 then w:=1
  else
   if mia*h<87 then w:=exp(-23)
    else
     if mia*h<150 then w:=exp(-mia*h+63)
      else
        w:=1.0E-30;
 fm01x0:=fufm01(0);
 fm10xh:=fufm10(h);
 if u1>u2 then fm01xh:=fufm01(h)
 else fm01xh:=0;
 if u2>u1 then fm10x0:=fufm10(0)
 else fm10x0:=0;
 fm11x0:=u1/(u2-u1)*fm10x0-u2/(u2-u1)*fm01x0;
 fm11xh:=u1/(u2-u1)*fm10xh-u2/(u2-u1)*fm01xh;
 fm00xh:=l1/(m1+m2)*fm10xh+l2/(m1+m2)*fm01xh;
 fm00x0:=l1/(m1+m2)*fm10x0+l2/(m1+m2)*fm01x0;
 p11xh:=u1/l1*fm01xh;
 p11x0:=u2/l2*fm10x0;
 p01x0:=l1/m1*p11x0+u2/m1*fm01x0;
 p10xh:=u1/m2*fm10xh+l2/m2*p11xh;
 f01xh:=loif01(h);
 f10xh:=loif10(h);
 f11xh:=u1/(u2-u1)*loif10(h)-u2/(u2-u1)*loif01(h);
 f00xh:=l1/(m1+m2)*loif10(h)+l2/(m1+m2)*loif01(h);
 wm:=w;
 W:=1/(f10xh+f01xh+f00xh+f11xh+p11xh+p10xh+p01x0+p11x0);
 fm01x0:=fm01x0*W;
 fm10xh:=fm10xh*W;
 fm11x0:=fm11x0*W;
 fm11xh:=fm11xh*W;
 fm10x0:=fm10x0*W;
 fm01xh:=fm01xh*W;
 p11xh:=p11xh*W;
 p11x0:=p11x0*W;
 p01x0:=p01x0*W;
 p10xh:=p10xh*W;
 f11xh:=f11xh*W;
 f00xh:=f00xh*W;
 f01xh:=f01xh*W;
 f10xh:=f10xh*W;
 k:=W*wm;
end;

  function fi(a:TReal):TReal; {INT(x*exp(a*x),0,h)}
  var ah,f:extended;
  begin
    ah:=a*h;
    f:=(ex(ah)*(ah-1)+1)/(a*a);
    fi:=f;
  end;

begin {equiv}
 lam1:=lam1r; mu1:=mu1r;deb1:=deb1r;lam2:=lam2r; mu2:=mu2r;
 deb2:=deb2r;h:=hr;avg_stock:=avg_stockr;
 fm11x0:=0; fm11xh:=0; fm10x0:=0; fm10xh:=0;
 fm01x0:=0; fm01xh:=0; fm00x0:=0; fm00xh:=0;
 f11x0:=0;  f11xh:=0;  f10x0:=0;  f10xh:=0;
 f01x0:=0;  f01xh:=0;  f00x0:=0;  f00xh:=0;
 p11x0:=0;  p11xh:=0;  p10xh:=0;  p01x0:=0;
 i1:=lam1/mu1; i2:=lam2/mu2;

 if abs(deb1-deb2)<=eps then
  if abs(i1-i2)<=eps then
  begin
   func0 (lam1,lam2,mu1,mu2,i1,deb1,h,k);
   avg_stock:=h*h*k*(2+(mu1+mu2)/(lam1+lam2)+(lam1+lam2)/(mu1+mu2))/2+h*(p11xh+p10xh);
  end
  else
  begin
   func1 (lam1,lam2,mu1,mu2,i1,i2,deb1,h,am,k);
   avg_stock:=fi(am)*k*(2+(mu1+mu2)/(lam1+lam2)+(lam1+lam2)/(mu1+mu2))+h*(p11xh+p10xh);
  end
 else
 begin
  func2 (lam1,lam2,mu1,mu2,deb1,deb2,h,a1,a2,A,B,k);
  if deb1>deb2 then
  begin
   fi1:=fi(a1);
   fi2:=fi(a2);
   avg_stock:=k*(1+deb1/(deb2-deb1)+lam1/(mu1+mu2))*(fi1-fi2);
   avg_stock:=avg_stock+k*(1-deb2/(deb2-deb1)+lam2/(mu1+mu2))*((a1-A)*fi1-(a2-A)*fi2)/B;
   avg_stock:=avg_stock+h*(p11xh+p10xh);
  end
  else
  begin
   avg_stock:=k*(1+deb1/(deb2-deb1)+lam1/(mu1+mu2))*(fi(a1)-(a1-A)/(a2-A)*ex(h*(a1-a2))*fi(a2))+
              k*(1-deb2/(deb2-deb1)+lam2/(mu1+mu2))*
              ((a1-A)*fi(a1)-(a1-A)*fi(a2)*ex(h*(a1-a2)))/B+
              h*p10xh;
  end;
 end;
 if deb1>deb2 then mindb:=deb2
 else mindb:=deb1;
 pr:=(f11xh+f01xh+p11xh)*deb2+p11x0*mindb;
 if deb1>=deb2 then
 begin
  lamp:=lam2+(deb2*fm01x0+lam1*p11x0)/(f11xh+f01xh+p11xh+p11x0);
  mup:= (mu1*p01x0+mu2*(f00xh+f10xh+p10xh))/(f00xh+f10xh+p01x0+p10xh)
 end
 else
 begin
  lamp:=lam2+(p11x0*deb1*(1+lam1/deb2)+fm01x0*deb2+fm11x0*(deb2-deb1))/
        	(f11xh+f01xh+deb1/deb2*p11x0);
  mup:=(mu2*(f10xh+f00xh+p10xh)+mu1*p01x0+deb1*p11x0)/
             (f10xh+f00xh+p10xh+p01x0+p11x0*(1-deb1/deb2))
 end;
 if deb1<=deb2 then
 begin
  lama:=lam1+(deb1*fm10xh+lam2*p11xh)/(f10xh+f11xh+p11x0+p11xh);
  mua:=(mu1*(f01xh+f00xh+p01x0)+mu2*p10xh)/(f00xh+f01xh+p01x0+p10xh)
 end
 else
 begin
  lama:=lam1+(p11xh*deb2*(1+lam2/deb1)+fm10xh*deb1+fm11xh*(deb1-deb2))/
     (f11xh+f10xh+deb2/deb1*p11xh);
  mua:=(mu1*(f00xh+f01xh+p01x0)+mu2*p10xh+deb2*p11xh)/
      (f00xh+f01xh+p01x0+p10xh+(1-deb2/deb1)*p11xh)
 end;
 dbp:=deb2;  dba:=deb1;
 prp:=dbp/(1+lamp/mup);
 pra:=dba/(1+lama/mua);
 if deb1=deb2 then
 begin
  lmp:=lamp;  lma:=lama; mp:=mup;
  ma:=mua; dp:=dbp; da:=dba;
 end
 else
  if deb1>deb2 then
  begin
   dp:=deb2;
   lmp:=lam2+p01x0*mu1/(f11xh+f01xh+p11xh);
   mp:=((f10xh+f00xh+p10xh)*mu2+p01x0*mu1)/(f10xh+f00xh+p10xh+p01x0);
   da:=(deb1*(f11xh+f10xh)+deb2*p11xh)/(f11xh+f10xh+p11xh);
   lma:=(lam1*(f11xh+f10xh+p11xh*deb2/deb1)+mu2*p10xh)/(f11xh+f10xh+p11xh);
   ma:=(mu1*(f01xh+f00xh+p01x0)+p10xh*mu2)/(f01xh+f00xh+p10xh+p01x0)
  end
  else
  begin
   da:=deb1;
   lma:=lam1+p10xh*mu2/(f11xh+f10xh+p11x0);
   ma:=((f01xh+f00xh+p01x0)*mu1+p10xh*mu2)/(f01xh+f00xh+p10xh+p01x0);
   dp:=(deb2*(f11xh+f01xh)+deb1*p11x0)/(f11xh+f01xh+p11x0);
   lmp:=(lam2*(f11xh+f01xh+p11x0*deb1/deb2)+mu1*p01x0)/(f11xh+f01xh+p11x0);
   mp:=(mu2*(f10xh+f00xh+p10xh)+p01x0*mu1)/(f10xh+f00xh+p10xh+p01x0)
  end;
 rp:=dp/(1+lmp/mp);
 ra:=da/(1+lma/ma);
 if deb1<deb2 then
 begin
  lam1:=lma;
  mu1:=ma;
  deb1:=da
 end
 else
 begin
            lam1:=lmp;
            mu1:=mp;
            deb1:=dp
          end;
  lam1r:=lam1; mu1r:=mu1;deb1r:=deb1;lam2r:=lam2; mu2r:=mu2;
  deb2r:=deb2;hr:=h;avg_stockr:=avg_stock;
  end;

 begin
  stock_cost:=0;

  while True do
  begin
   ihm := R1;
   if ihm <> 0 then
   begin

    size:=Buffer[ihm].Size;

    equiv(Machine[Buffer[ihm].NumberPDM[0]].Lambda,
          Machine[Buffer[ihm].NumberPDM[0]].Mu,
          Machine[Buffer[ihm].NumberPDM[0]].C,
          Machine[Buffer[ihm].NumberTDM[0]].Lambda,
          Machine[Buffer[ihm].NumberTDM[0]].Mu,
          Machine[Buffer[ihm].NumberTDM[0]].C,
          Size,avg_stock);

          l1:=Machine[Buffer[ihm].NumberPDM[0]].Lambda;
          m1:=Machine[Buffer[ihm].NumberPDM[0]].Mu;
          u1:=Machine[Buffer[ihm].NumberPDM[0]].C;

    stock_cost:=stock_cost+avg_stock*inv_coef*det_cost[ihm];

    Machine[Buffer[ihm].NumberPDM[0]].NumberTDB:=
    Machine[Buffer[ihm].NumberTDM[0]].NumberTDB;

    Buffer[
     Machine[
      Buffer[ihm].NumberTDM[0]
     ].NumberTDB
    ].NumberPDM[
                      Machine[
                       Buffer[ihm].NumberTDM[0]
                      ].ListNumberGDB
                     ]:=Buffer[ihm].NumberPDM[0];

    CBuffer[ihm]:=False;
    CMQuantity := CMQuantity -1;
    CBQuantity := CBQuantity -1;

   end
   else
   begin
    if (CMQuantity = 1) and (CBQuantity = 2) then break;

    i:=-1;
    b:=true;
    while (i<BufferQuantity_) and (b=true) do
    begin
     i:=i+1;
     if (CBuffer[i]=True) and  (Buffer[i].TDMQuantity >= 2) then
     begin
      j:=-1;
      while (j<Buffer[i].TDMQuantity-1) and (b=true) do
      begin
       j:=j+1;
       k:=j;
       while (k<Buffer[i].TDMQuantity-1) and (b=true) do
       begin
        k:=k+1;
        if Machine[Buffer[i].NumberTDM[j]].NumberTDB =
           Machine[Buffer[i].NumberTDM[k]].NumberTDB then b:=False;
       end;
      end;
     end;
    end;
    parl(Machine[Buffer[i].NumberTDM[j]].Lambda,
         Machine[Buffer[i].NumberTDM[j]].Mu,
         Machine[Buffer[i].NumberTDM[j]].C,
         Machine[Buffer[i].NumberTDM[k]].Lambda,
         Machine[Buffer[i].NumberTDM[k]].Mu,
         Machine[Buffer[i].NumberTDM[k]].C);

     l1:=Machine[Buffer[i].NumberTDM[j]].Lambda;
     m1:=Machine[Buffer[i].NumberTDM[j]].Mu;
     u1:=Machine[Buffer[i].NumberTDM[j]].C;

    Buffer[Machine[Buffer[i].NumberTDM[k]].NumberTDB].PDMQuantity:=
    Buffer[Machine[Buffer[i].NumberTDM[k]].NumberTDB].PDMQuantity-1;

    t:=Machine[Buffer[i].NumberTDM[k]].NumberGDB;
    if t<>Buffer[Machine[Buffer[i].NumberTDM[k]].NumberTDB].PDMQuantity then
    begin
     Buffer[
      Machine[
       Buffer[i].NumberTDM[k]
      ].NumberTDB
     ].NumberPDM[t]:=
     Buffer[
      Machine[
       Buffer[i].NumberTDM[k]
      ].NumberTDB
     ].NumberPDM[
                 Buffer[
                  Machine[
                   Buffer[i].NumberTDM[k]
                  ].NumberTDB
                 ].PDMQuantity
                ];

     tt:=Buffer[i].NumberTDM[k];
     tt:=Machine[tt].NumberTDB;
     tt:=Buffer[tt].NumberPDM[Buffer[tt].PDMQuantity];
     Machine[tt].ListNumberGDB:=t;

{     hh:=Buffer[i].NumberTDMachine[k];
     Machine[
      Buffer[
       Machine[
        Buffer[i].NumberTDMachine[k]
       ].NumberTDB
      ].NumberPDMachine[
                  Buffer[
                   Machine[
                    Buffer[i].NumberTDMachine[k]
                   ].NumberTDB
                  ].PDMQuantity
     ].ListNumberGDB:= t;}
    end;

    CMQuantity:=CMQuantity-1;

    Buffer[i].TDMQuantity := Buffer[i].TDMQuantity-1;
    if k < Buffer[i].TDMQuantity then
    begin
     Buffer[i].NumberTDM[k]:=Buffer[i].NumberTDM[Buffer[i].TDMQuantity];
     Machine[Buffer[i].NumberTDM[Buffer[i].TDMQuantity]].NumberGDB:=k;
    end;

   end;
  end;
 end;
{******************************************************************************}
}
 procedure TMachineLine.equiv(var lam1r,mu1r,deb1r,lam2r,mu2r,deb2r,hr,avg_stockr:TReal);
var lam1,mu1,deb1,lam2,mu2,deb2,h,avg_stock,
    fm11x0,fm11xh,fm10x0,fm10xh,fm01x0,fm01xh,fm00x0,fm00xh:TReal;
    f11x0,f11xh,f10x0,f10xh,f01x0,f01xh,f00x0,f00xh:TReal;
    p11x0,p11xh,p10xh,p01x0:TReal;
    lamp,mup,lama,mua,up,ua,deb,i1,i2:TReal;
    pr,prp,pra,mindb,dba,dbp,rp,ra,dp,da,lmp,lma,mp,ma:TReal;
    fi2,fi1,mia,am,a1,a2,A,B,k:TReal;

function ex (y:TReal):TReal;
begin
 if abs(y) > 88 then y:=round(y/abs(y))*88;
  ex:= exp(y)
end;

procedure func0 (l1,l2,m1,m2,i,u0,h:TReal; var k:TReal);
Var c0:TReal;
begin
 c0:=1/(u0*(l1+l2)/(l1*l2)*(1+2*i)+((1+i)*(1+i))/i*h);
 fm01x0:=c0;  fm01xh:=c0;
 fm10xh:=fm01xh; fm10x0:=fm01x0;
 fm00x0:=i*fm01x0;fm00xh:=fm00x0;
 fm11x0:=c0/i; fm11xh:=fm11x0;
 p11x0:=u0/l2*fm10x0;
 p11xh:=u0/l1*fm01xh;
 p01x0:=u0*(l1+l2)/(m1*l2)*c0;
 p10xh:=u0*(l1+l2)/(m2*l1)*c0;
 f01xh:=c0*h;
 f10xh:=f01xh;
 f11xh:=c0*h/i;
 f00xh:=i*c0*h;
 k:=c0;
END;

procedure func1 (l1,l2,m1,m2,i1,i2,u0,h: TReal; var am,k: TReal);
var c:TReal;
begin
 am:=(l2*m1-l1*m2)/u0*(l1+l2+m1+m2)/((l1+l2)*(m1+m2));
 c:=1/(u0*(l1+l2)/(l2*m1-l1*m2)*((1+i2)/i1*ex(am*h)-(1+i1)/i2));
 fm01x0:=c; fm10x0:=fm01x0;
 fm10xh:=c*ex(am*h); fm01xh:=fm10xh;
 fm11x0:=(m1+m2)/(l1+l2)*c; fm11xh:=fm11x0*ex(am*h);
 fm00x0:=(l1+l2)/(m1+m2)*c; fm00xh:=fm00x0*ex(am*h);
 p11x0:=(u0/l2)*c;
 p11xh:=(u0/l1)*fm10xh;
 p01x0:=u0*(l1+l2)/(m1*l2)*c;
 p10xh:=u0*(l1+l2)/(l1*m2)*fm10xh;
 f01xh:=c*(ex(am*h)-1)/am;
 f10xh:=f01xh;
 f11xh:=(m1+m2)/(l1+l2)*f01xh;
 f00xh:=(l1+l2)/(m1+m2)*f01xh;
 k:=c;
end;

procedure func2 (l1,l2,m1,m2,u1,u2,h:TReal; var a1,a2,A,B,k:TReal);
var E,D,di:TReal;
    W,wm:TReal;
function fufm01(x:treal):TReal;
begin
 if u1>u2 then fufm01:=(w*(a1-A)*ex(a1*x)-w*(a2-A)*ex(a2*x))/B
 else fufm01:=(w*(a1-A)*ex(a1*x-h*(a1-a2))-
               w*(a1-A)*ex(a2*x))*ex(h*(a1-a2))/B
end;

function fufm10 (x:TReal):TReal;
begin
 if u1>u2 then fufm10:=w*ex(a1*x)-w*ex(a2*x)
 else fufm10:=w*ex(h*(a1-a2))*(ex(a1*x-h*(a1-a2))
		 *(a2-A)-(a1-A)*ex(a2*x))/(a2-A)
end;

function loif01 (x:TReal):TReal;
begin
 if abs(a2)<>0 then
  if u1>u2 then
   loif01:=(w*(a1-A)/a1*(ex(a1*x)-1)-w*(a2-A)/a2*(ex(a2*x)-1))/B
  else loif01:=(a1-A)*(w/a1*(ex(a1*x-h*(a1-a2))-ex(-h*(a1-a2)))-w/a2*(ex(a2*x)-1))/B*ex(h*(a1-a2))
 else
  if u1>u2 then loif01:=w*(a1-A)/(B*a1)*(ex(a1*x)-1)+w*A/B*x
  else loif01:=w*(a1-A)/(B*a1)*(ex(a1*x)-1)-w*(a1-A)/B*ex(a1*h)*x
end;

function loif10 (x:TReal):TReal;
begin
 if abs(a2)<>0 then
  if u1<u2 then
   loif10:=(w/a1*(a2-A)*(ex(a1*x-h*(a1-a2))-ex(-h*(a1-a2)))-w*(a1-A)/a2
            *(ex(a2*x)-1))*ex(h*(a1-a2))/(a2-A)
  else loif10:=w*(ex(a1*x)-1)/a1-w*(ex(a2*x)-1)/a2
 else
  if u1>u2 then loif10:=w/a1*(ex(a1*x)-1)-w*x
  else loif10:=w/a1*(ex(a1*x)-1)+w*(a1-A)/A*ex(a1*h)*x
end;

begin {func2}

 A:=l2/(u2-u1)-m2*(m1+m2+l1)/(u1*(m1+m2));
 B:=l2/u1*(m1/(m1+m2)-u2/(u2-u1));
 E:=-l1/u2*(m2/(m1+m2)+u1/(u2-u1));
 D:=l1/(u2-u1)+m1*(m1+m2+l2)/(u2*(m1+m2));
 di:=(A-D)*(A-D)+4*E*B;
 a1:=(A+D+sqrt(di))/2;
 a2:=(A+D-sqrt(di))/2;

 if abs(a1)>abs(a2) then
  mia:=abs(a1)
 else mia:=abs(a2);
  if mia*h < 63 then w:=1
  else
   if mia*h<87 then w:=exp(-23)
    else
     if mia*h<150 then w:=exp(-mia*h+63)
      else
        w:=1.0E-30;
 fm01x0:=fufm01(0);
 fm10xh:=fufm10(h);
 if u1>u2 then fm01xh:=fufm01(h)
 else fm01xh:=0;
 if u2>u1 then fm10x0:=fufm10(0)
 else fm10x0:=0;
 fm11x0:=u1/(u2-u1)*fm10x0-u2/(u2-u1)*fm01x0;
 fm11xh:=u1/(u2-u1)*fm10xh-u2/(u2-u1)*fm01xh;
 fm00xh:=l1/(m1+m2)*fm10xh+l2/(m1+m2)*fm01xh;
 fm00x0:=l1/(m1+m2)*fm10x0+l2/(m1+m2)*fm01x0;
 p11xh:=u1/l1*fm01xh;
 p11x0:=u2/l2*fm10x0;
 p01x0:=l1/m1*p11x0+u2/m1*fm01x0;
 p10xh:=u1/m2*fm10xh+l2/m2*p11xh;
 f01xh:=loif01(h);
 f10xh:=loif10(h);
 f11xh:=u1/(u2-u1)*loif10(h)-u2/(u2-u1)*loif01(h);
 f00xh:=l1/(m1+m2)*loif10(h)+l2/(m1+m2)*loif01(h);
 wm:=w;
 W:=1/(f10xh+f01xh+f00xh+f11xh+p11xh+p10xh+p01x0+p11x0);
 fm01x0:=fm01x0*W;
 fm10xh:=fm10xh*W;
 fm11x0:=fm11x0*W;
 fm11xh:=fm11xh*W;
 fm10x0:=fm10x0*W;
 fm01xh:=fm01xh*W;
 p11xh:=p11xh*W;
 p11x0:=p11x0*W;
 p01x0:=p01x0*W;
 p10xh:=p10xh*W;
 f11xh:=f11xh*W;
 f00xh:=f00xh*W;
 f01xh:=f01xh*W;
 f10xh:=f10xh*W;
 k:=W*wm;
end;

  function fi(a:TReal):TReal; {INT(x*exp(a*x),0,h)}
  var ah,f:extended;
  begin
    ah:=a*h;
    f:=(ex(ah)*(ah-1)+1)/(a*a);
    fi:=f;
  end;

begin {equiv}
 lam1:=lam1r; mu1:=mu1r;deb1:=deb1r;lam2:=lam2r; mu2:=mu2r;
 deb2:=deb2r;h:=hr;avg_stock:=avg_stockr;
 fm11x0:=0; fm11xh:=0; fm10x0:=0; fm10xh:=0;
 fm01x0:=0; fm01xh:=0; fm00x0:=0; fm00xh:=0;
 f11x0:=0;  f11xh:=0;  f10x0:=0;  f10xh:=0;
 f01x0:=0;  f01xh:=0;  f00x0:=0;  f00xh:=0;
 p11x0:=0;  p11xh:=0;  p10xh:=0;  p01x0:=0;
 i1:=lam1/mu1; i2:=lam2/mu2;

 if abs(deb1-deb2)<=eps then
  if abs(i1-i2)<=eps then
  begin
   func0 (lam1,lam2,mu1,mu2,i1,deb1,h,k);
   avg_stock:=h*h*k*(2+(mu1+mu2)/(lam1+lam2)+(lam1+lam2)/(mu1+mu2))/2+h*(p11xh+p10xh);
  end
  else
  begin
   func1 (lam1,lam2,mu1,mu2,i1,i2,deb1,h,am,k);
   avg_stock:=fi(am)*k*(2+(mu1+mu2)/(lam1+lam2)+(lam1+lam2)/(mu1+mu2))+h*(p11xh+p10xh);
  end
 else
 begin
  func2 (lam1,lam2,mu1,mu2,deb1,deb2,h,a1,a2,A,B,k);
  if deb1>deb2 then
  begin
   fi1:=fi(a1);
   fi2:=fi(a2);
   avg_stock:=k*(1+deb1/(deb2-deb1)+lam1/(mu1+mu2))*(fi1-fi2);
   avg_stock:=avg_stock+k*(1-deb2/(deb2-deb1)+lam2/(mu1+mu2))*((a1-A)*fi1-(a2-A)*fi2)/B;
   avg_stock:=avg_stock+h*(p11xh+p10xh);
  end
  else
  begin
   avg_stock:=k*(1+deb1/(deb2-deb1)+lam1/(mu1+mu2))*(fi(a1)-(a1-A)/(a2-A)*ex(h*(a1-a2))*fi(a2))+
              k*(1-deb2/(deb2-deb1)+lam2/(mu1+mu2))*
              ((a1-A)*fi(a1)-(a1-A)*fi(a2)*ex(h*(a1-a2)))/B+
              h*p10xh;
  end;
 end;
 if deb1>deb2 then mindb:=deb2
 else mindb:=deb1;
 pr:=(f11xh+f01xh+p11xh)*deb2+p11x0*mindb;
 if deb1>=deb2 then
 begin
  lamp:=lam2+(deb2*fm01x0+lam1*p11x0)/(f11xh+f01xh+p11xh+p11x0);
  mup:= (mu1*p01x0+mu2*(f00xh+f10xh+p10xh))/(f00xh+f10xh+p01x0+p10xh)
 end
 else
 begin
  lamp:=lam2+(p11x0*deb1*(1+lam1/deb2)+fm01x0*deb2+fm11x0*(deb2-deb1))/
        	(f11xh+f01xh+deb1/deb2*p11x0);
  mup:=(mu2*(f10xh+f00xh+p10xh)+mu1*p01x0+deb1*p11x0)/
             (f10xh+f00xh+p10xh+p01x0+p11x0*(1-deb1/deb2))
 end;
 if deb1<=deb2 then
 begin
  lama:=lam1+(deb1*fm10xh+lam2*p11xh)/(f10xh+f11xh+p11x0+p11xh);
  mua:=(mu1*(f01xh+f00xh+p01x0)+mu2*p10xh)/(f00xh+f01xh+p01x0+p10xh)
 end
 else
 begin
  lama:=lam1+(p11xh*deb2*(1+lam2/deb1)+fm10xh*deb1+fm11xh*(deb1-deb2))/
     (f11xh+f10xh+deb2/deb1*p11xh);
  mua:=(mu1*(f00xh+f01xh+p01x0)+mu2*p10xh+deb2*p11xh)/
      (f00xh+f01xh+p01x0+p10xh+(1-deb2/deb1)*p11xh)
 end;
 dbp:=deb2;  dba:=deb1;
 prp:=dbp/(1+lamp/mup);
 pra:=dba/(1+lama/mua);
 if deb1=deb2 then
 begin
  lmp:=lamp;  lma:=lama; mp:=mup;
  ma:=mua; dp:=dbp; da:=dba;
 end
 else
  if deb1>deb2 then
  begin
   dp:=deb2;
   lmp:=lam2+p01x0*mu1/(f11xh+f01xh+p11xh);
   mp:=((f10xh+f00xh+p10xh)*mu2+p01x0*mu1)/(f10xh+f00xh+p10xh+p01x0);
   da:=(deb1*(f11xh+f10xh)+deb2*p11xh)/(f11xh+f10xh+p11xh);
   lma:=(lam1*(f11xh+f10xh+p11xh*deb2/deb1)+mu2*p10xh)/(f11xh+f10xh+p11xh);
   ma:=(mu1*(f01xh+f00xh+p01x0)+p10xh*mu2)/(f01xh+f00xh+p10xh+p01x0)
  end
  else
  begin
   da:=deb1;
   lma:=lam1+p10xh*mu2/(f11xh+f10xh+p11x0);
   ma:=((f01xh+f00xh+p01x0)*mu1+p10xh*mu2)/(f01xh+f00xh+p10xh+p01x0);
   dp:=(deb2*(f11xh+f01xh)+deb1*p11x0)/(f11xh+f01xh+p11x0);
   lmp:=(lam2*(f11xh+f01xh+p11x0*deb1/deb2)+mu1*p01x0)/(f11xh+f01xh+p11x0);
   mp:=(mu2*(f10xh+f00xh+p10xh)+p01x0*mu1)/(f10xh+f00xh+p10xh+p01x0)
  end;
 rp:=dp/(1+lmp/mp);
 ra:=da/(1+lma/ma);
 if deb1<deb2 then
 begin
  lam1:=lma;
  mu1:=ma;
  deb1:=da
 end
 else
 begin
            lam1:=lmp;
            mu1:=mp;
            deb1:=dp
          end;
  lam1r:=lam1; mu1r:=mu1;deb1r:=deb1;lam2r:=lam2; mu2r:=mu2;
  deb2r:=deb2;hr:=h;avg_stockr:=avg_stock;
  end;
{******************************************************************************}
procedure TMachineLine.parl(var l1,m1,u1,l2,m2,u2:TReal);
var pl:treal;
begin
 pl:=u1/(1+l1/m1)+u2/(1+l2/m2);
 u1:=u1+u2;
 l1:=l1*m2/(l2+m2)+l2*m1/(m1+l1);
 m1:=l1/(u1/pl-1);
end;
{******************************************************************************}
 Procedure TMachineLine.SetMachineQuantity(x:TInt);
 begin
  FreeMachineMemory;
  FMachineQuantity:=x;
  GetMachineMemory;
 end;
{******************************************************************************}
 Procedure TMachineLine.SetBufferQuantity(x:TInt);
 begin
  FreeBufferMemory;
  FBufferQuantity:=x;
  GetBufferMemory;
 end;
{******************************************************************************}
 Function TMachineLine.GetMachineQuantity_: TInt;
 begin
  GetMachineQuantity_ := MachineQuantity-1;
 end;
{******************************************************************************}
 Function TMachineLine.GetBufferQuantity_ : TIndex;
 begin
  GetBufferQuantity_ := BufferQuantity-1;
 end;
{******************************************************************************}
end.
