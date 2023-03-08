{$O+,F+}
{$MODE OBJFPC}
unit MachineLineDolguiStructure;
interface
uses 
	MyTypes,
	classes,
	CharText,
        VarType,
        GlobalVar,
	sysutils,
	crt;
const
	am=255;
	an=255;
	mx=1.0e+37;
type
	yarc=^arc;
	arc=record
		vit:real;
		pos:1..am;
		pap:yarc;
		pat:yarc;
		tr:0..an;
	end;
	tran=record
		l:real;
		m:real;
	end;
	place=record
		h:real
	end;
	ytran=^tran ;
	yplace=^place ;
	trns=array(.1..an.) of ytran;
	pls=array(.1..am.) of yplace;
	tar=array(.1..an.) of yarc;
	plar=array(.1..am.) of yarc;
	TMachineLineDolguiStructure = class
	public
		m,n               : integer;{max ����� ������� � ���������}
		p0                : integer;{������ ���� ������ (1-�����������,2-����������)}
		w,b,b1,s,s1       : yarc;   {��������� ���������� �� ��������� ����}
		et,st             : tar;    {������� ������ �� ����� � ������ ���������}
		ep,sp             : plar;   {������� ������ �� ����� � ������ �������}
		tr                : trns;   {������� ������ �� ��������� ���������,������ ����� transitions}
		pl                : pls;    {������� ������ �� ��������� �������,������ ����� places}
		mpl,mtr           : set of 1..255;{������� ������ �� ��������� �������,}
		entered           : boolean;
		result_oper       : boolean;{��������� �������� (���� FALSE,�� ���� ������)}
		//DlitMod           : integer;
		//NmbIter           : integer ;

		Constructor Create(var str5:MyText);
		procedure svpl(var l1,m1,u1,stock_cost:real);
		procedure svpl_incomplete(buf_var:integer;
		var reduced_line_kind:integer;
		var reduced_line:machine_array;
		var stock_cost:real);
		procedure svpl_lead_stock(var l1,m1,u1,stock_cost:real;
		var new_order:easy; position:integer);
		{Does the same as svpl but the inventory costs are computed only for the
		buffers with GA-numbers new_order[i], i=position,...,(#of buffers)}

		//function sequence(var new_order:order):boolean;
                procedure Imitation(DlitMod, NmbIter: integer; var Throughput_,StorageCost_:real); overload;
//		procedure Imitation(var Throughput_,StorageCost_:TReal);overload;
		destructor done;
	end;
        function astrimlead(s:string):string;
        function astrim(s:string):string;
implementation
const eps=1e-6;

function astrimlead(s:string):string;
begin
	while (length(s)<>0) and (ord(s[1])<=32) do
	delete(s,1,1);
	astrimlead:=s;
end;
function astrim(s:string):string;
var
	i:integer;
begin
	while (length(s)<>0) and (ord(s[1])<=32) do delete(s,1,1);
	i:=length(s);
	while ord(s[i])<=32 do
	begin
		delete(s,i,1);
		i:=i-1;
	end;
	astrim:=s;
end;

Constructor TMachineLineDolguiStructure.Create(var str5:mytext);
	type 
		slovo=string[15];
		slovo1=string[100];
	var
		str6          :string;
		Esc           :boolean;
		mdl           :text;
		str1,str2     :slovo1;
		str3          :string[250];
		str           :string[1];
		mn            :real;
		in1,in2,in3   :integer;
		in4,in5       :integer;
		np,mp,mm,kk   :integer;
		j,l,tran,i    :integer;
		ind,npos,d    :integer;
		flag          :boolean;
		Kod           :char;
		cod           :integer;
{---------------------------------------------------------------------------}
	Procedure PKF(sl1,sl2:slovo); {�������� ����� �����}
	begin
		if str5._End 
		then
			if (pos(sl1,str3)=0) and (pos(sl2,str3)=0) then
			begin
				flag:=true;
				result_oper:=false
			end
	end;{�������� ����� �����}
{---------------------------------------------------------------------------}
	Procedure Udal;
	begin
		str3:=astrimlead(str3);
		while (length(str3)=0) and(not str5._End) do
		begin
			str3:=str5.Str;
			str3:=astrimlead(str3);
		end
	end;
{---------------------------------------------------------------------------}
	Procedure PTZ(sl:slovo1; A :char; var i:integer);{����. �������}
	Begin
		ind:=pos(sl,str3)+length(sl);
		str3:=copy(str3,ind,length(str3)-ind+1);
		if str3[1]=' ' then  udal;
		if str3[1]=A then
		begin
			delete(str3,1,1);
			udal;
		end
		else
		begin
			result_oper:=false;
			l:=l+1
		end;
		sl:=asTrim(sl);
		ind:=1;
	End;     {����. �������}
{---------------------------------------------------------------------------}
	Procedure BL1(sl1,sl2:slovo);{������� ������}
	var in1:integer;
	begin
		ind:=300; in1:=300;
		while (pos(sl1,str3)=0) and
          (pos(sl2,str3)=0) and
          (not str5._End  ) do
        begin
			str3:=str5.Str;
        end;
		if pos(sl1,str3)<>0 then ind:=pos(sl1,str3);
		if pos(sl2,str3)<>0 then in1:=pos(sl2,str3);
		if in1<ind then ind:=in1;
		str3:=copy(str3,ind,length(str3)-ind+1);
		ind:=1
	end;{�������� ������}
{---------------------------------------------------------------------------}
Begin {�������� ���������}
  for j:=1 to an do begin
     et[j]:=nil;
     st[j]:=nil;
     tr[j]:=nil;
  end;
  for j:=1 to am do begin
     ep[j]:=nil;
     sp[j]:=nil;
     pl[j]:=nil;
  end;
  flag:=false;
  l:=0;
  p0:=1;
  result_oper:=true;
  str3:=str5.Str;
  BL1('definition','connect');
  PKF('definition','connect');
  if flag then Exit;
  i:=1;
  if pos('definition',str3)<>ind then
  begin
      PTZ('connect',';',i);
      result_oper:=false;
      Exit
  end;
  PTZ('definition',';',i );
  BL1('places','transitions');
  PKF('places','transitions');
  if flag then Exit;
  in1:=0; m:=0; n:=0; mpl:=[]; mtr:=[];
  repeat
     in2:=0; in3:=0; str1:='';kk:=1;
     str:=copy(str3,ind,1);
     while (str<>';') and (ind<=length(str3)) do
     begin
       str1:=str1+str;
       inc(ind);
       str:=copy(str3,ind,1)
     end;
     i:=i+1;
     j:=1;
     PTZ(str1,';',i);
     str1:=asTrim(str1);
     if str1='places' then in1:=1
     else
         if str1='transitions' then in1:=2
	 else
             if str1='enters' then in1:=3
	     else
                 if str1='exits' then in1:=4
                 else
                     if str1='end' then
                     begin
                        i:=i+1;
                        BL1('connect','end');
                        PKF('connect','end');
                        if flag then Exit;
                        if pos('connect',str3)=ind then
                        begin
                           PTZ('connect',';',i);
                           BL1('enters','exits');
                           PKF('enters','exits');
                           if flag then Exit;
                        end
                        else
                        begin {�������� �����}
                           PTZ('end','.',i);
                           while not str5._End do
                           begin
                            str3:=str5.Str;
                           end;
                           ind:=length(str3)
                        end{�������� "."}
                     end
                     else
                        case in1 of
                             1:begin
                                 in2:=pos(':',str1);
		                 str2:=copy(str1,1,in2-1);
		                 val (str2,np,cod);
		                 if cod<>0 then
                                 begin
                                   l:=l+1
                                 end;
                                 if not(np in mpl) then mpl:=mpl+[np]
                                 else
                                 begin
                                   l:=l+1
                                 end;
                                 if np>m then m:=np;
                                 str2:=copy(str1,in2+1,length(str1)-in2);
                                 new(pl[np]);
                                 if (str2='*') then pl[np]^.h:=mx
                                 else
                                 begin
                                   val(str2,mn,cod);
		                   if mn<0 then
                                   begin
                                     l:=l+1
                                   end;
		                   if cod<>0 then
                                   begin
                                     l:=l+1
                                   end;
		                   pl[np]^.h:=mn
                                 end;
	                       end;
	                     2:begin
                                 in2:=pos(':',str1);
		                 str2:=copy(str1,1,in2-1);
                                 val(str2,np,cod);
		                 if cod<>0 then
                                 begin
                                   l:=l+1
                                 end;
                                 if not(np in mtr) then mtr:=mtr+[np]
                                 else
                                 begin
                                   l:=l+1
                                 end;
		                 if np>n then n:=np;
		                 new(tr[np]);
                                 in3:=pos(',',str1);
		                 str2:=copy(str1,in2+1,in3-in2-1);
                                 if str2='*' then tr[np]^.l:=1.0E-36
                                 else
                                 begin
                                   val(str2,mn,cod);
		                   if cod<>0 then
                                   begin
                                     l:=l+1
                                   end;
		                   if mn<0 then
                                   begin
                                     l:=l+1
                                   end;
                                   case p0 of
			              1: tr[np]^.l:=1/mn;
			              2: tr[np]^.l:=mn;
			              else
                                      begin
                                        l:=l+1
                                      end
                                   end
                                 end;
		                 str2:=copy(str1,in3+1,length(str1)-in3);
                                 if str2='*' then tr[np]^.m:=mx
                                 else
                                 begin
                                   val(str2,mn,cod);
		                   if cod<>0 then
                                   begin
                                     l:=l+1
                                   end;
		                   if mn<0 then
                                   begin
                                     l:=l+1
                                   end;
		                   case p0 of
			               1: tr[np]^.m:=1/mn;
			               2: tr[np]^.m:=mn;
			               else
                                       begin
                                         l:=l+1
                                       end
                                   end
                                 end;
	                       end;
	                     3:begin
                                 in2:=pos('<=',str1);
		                 str2:=copy(str1,1,in2-1);
		                 if copy(str2,1,1)='t' then delete(str2,1,1)
				 else
                                 begin
                                   l:=l+1
                                 end;
                                 val(str2,mp,cod);
		                 if cod<>0 then
                                 begin
                                   l:=l+1
                                 end;
                                 if not(mp in mtr) then
                                 begin
                                   l:=l+1
                                 end;
                                 delete(str1,1,in2+1);
                                 in4:=1 ;
                                 while in4<>0 do
                                 begin
                                   s:=et[mp];
		                   j:=1;
		                   if s=nil then
                                   begin
                                     new(s);
                                     s^.tr:=mp;
				     s^.pap:=nil;s^.pat:=nil;
				     et[mp]:=s
				   end
			           else
                                   begin
				     while s<>nil do
                                     begin
                                       j:=j+1;
				       b:=s;
				       s:=s^.pat
				     end;
				     new(s); s^.tr:=mp;
				     s^.pap:=nil;s^.pat:=nil;
				     b^.pat:=s
				   end;
		                   in3:=pos(':',str1);
		                   str2:=copy(str1,1,in3-1);
		                   if copy(str2,1,1)='p' then delete(str2,1,1)
				   else
                                   begin
                                     l:=l+1
                                   end;
                                   val(str2,mm,cod);
		                   if cod<>0 then
                                   begin
                                     l:=l+1
                                   end;
                                   if not(mm in mpl) then
                                   begin
                                     l:=l+1
                                   end;
                                   s^.pos:=mm;
		                   w:=sp[mm]; j:=1;
		                   if w=nil then sp[mm]:=s
			           else
                                   begin
				     while w<>nil do
                                     begin
			               j:=j+1;
				       b:=w;
				       w:=w^.pap
				     end;
		                     b^.pap:=s
				   end;
                                   delete(str1,1,in3) ;
                                   in4:=pos('/',str1);
                                   if in4<>0 then in5:=in4-1
                                   else in5:=length(str1);
                                   if in5=0 then s^.vit:=1
                                   else
                                   begin
		                     str2:=copy(str1,1,in5);
                                     val(str2,mn,cod);
                                     if cod<>0 then
                                     begin
                                       l:=l+1
                                     end;
		                     if mn<0 then
                                     begin
                                       l:=l+1
                                     end;
                                     case p0 of
                                         1 :  s^.vit:=1/mn;
                                         2 :  s^.vit:=mn ;
                                     end;
                                   end;
                                   if in4<>0 then delete(str1,1,in4)
                                 end
		               end;
	                     4:begin
                                 in2:=pos('=>',str1);
         	                 str2:=copy(str1,1,in2-1);
		                 if copy(str2,1,1)='t' then delete(str2,1,1)
			         else
                                 begin
                                   l:=l+1
                                 end;
                                 val(str2,mp,cod);
		                 if cod<>0 then
                                 begin
                                   l:=l+1
                                 end;
                                 if not(mp in mtr) then
                                 begin
                                   l:=l+1
                                 end;
                                 delete(str1,1,in2+1) ;
                                 in4:=1 ;
                                 while in4<>0 do
                                 begin
                           	   s:=st[mp];
                                   j:=1;
		                   if s=nil then
                                   begin
                                     new(s); s^.tr:=mp;
				     s^.pat:=nil;s^.pap:=nil;
				     st[mp]:=s
				   end
			           else
                                   begin
				     while s<>nil do
                                     begin
                                       j:=j+1;
				       b:=s;
				       s:=s^.pat
				     end;
				     new(s); s^.tr:=mp;
				     s^.pap:=nil;s^.pat:=nil;
				     b^.pat:=s;
				   end;
                                   in3:=pos(':',str1);
		                   str2:=copy(str1,1,in3-1);
		                   if copy(str2,1,1)='p' then delete(str2,1,1)
				   else
                                   begin
                                     l:=l+1
                                   end;
                                   val(str2,mm,cod);
		                   if cod<>0 then
                                   begin
                                     l:=l+1
                                   end;
                                   if not(mm in mpl) then
                                   begin
                                     l:=l+1
                                   end;
		                   s^.pos:=mm;
                                   w:=ep[mm]; j:=1;
		                   if w=nil then ep[mm]:=s
			           else
                                   begin
				     while w<>nil do
                                     begin
			               j:=j+1;
				       b:=w;
				       w:=w^.pap
				     end;
		                     b^.pap:=s
				   end;
                                   delete(str1,1,in3) ;
                                   in4:=pos('/',str1);
                                   if in4<>0 then in5:=in4-1
                                   else in5:=length(str1);
                                   if in5=0 then s^.vit:=1
                                   else
                                   begin
		                     str2:=copy(str1,1,in5);
                                     val(str2,mn,cod);
		                     if cod<>0 then
                                     begin
                                       l:=l+1
                                     end;
		                     if mn<0 then
                                     begin
                                       l:=l+1
                                     end;
                                     case p0 of
                                          1 : s^.vit:=1/mn;
                                          2 : s^.vit:=mn ;
                                     end
                                   end;
                                   if in4<>0 then delete(str1,1,in4)
                                 end
                               end;
                        end; {�� case}
  until str5._End and (ind=length(str3));
  npos:=0; tran:=0; d:=0;
  for j:=1 to n do
    if j in mtr then
      tran:=tran+1;
    for j:=1 to m do
      if j in mpl then
      begin
        npos:=npos+1;
        s:=sp[j];
        if s<>nil then
        begin
          d:=d+1;
          while s^.pap<>nil do
          begin
            s:=s^.pap;
            d:=d+1
          end
        end;
        s:=ep[j];
        if s<>nil then
        begin
          d:=d+1;
          while s^.pap<>nil do
          begin
            s:=s^.pap;
            d:=d+1
          end
        end
      end;
 end ;

procedure TMachineLineDolguiStructure.svpl(var l1,m1,u1,stock_cost:real);
label a3;
var
 order1:order; boo:boolean;
 ihm,pos,i,wtr         : integer;
 hmin,l2,m2,u2,fi1,fi2     : real;
 A                 : char;
 avg_stock:real;
procedure parl(var l1,m1,u1,l2,m2,u2:real);
var pl:real;
begin
 pl:=u1/(1+l1/m1)+u2/(1+l2/m2);
 u1:=u1+u2;
 l1:=l1*m2/(l2+m2)+l2*m1/(m1+l1);
 m1:=l1/(u1/pl-1);
end;

procedure equiv(var lam1r,mu1r,deb1r,lam2r,mu2r,deb2r,hr,avg_stockr:real);
var lam1,mu1,deb1,lam2,mu2,deb2,h,avg_stock,
    fm11x0,fm11xh,fm10x0,fm10xh,fm01x0,fm01xh,fm00x0,fm00xh:extended;
    f11x0,f11xh,f10x0,f10xh,f01x0,f01xh,f00x0,f00xh:extended;
    p11x0,p11xh,p10xh,p01x0:extended;
    lamp,mup,lama,mua,up,ua,deb,i1,i2:extended;
    pr,prp,pra,mindb,dba,dbp,rp,ra,dp,da,lmp,lma,mp,ma:extended;
    mia,am,a1,a2,A,B,k:extended;

function ex (y:extended):extended;
begin
 if abs(y) > 88 then y:=round(y/abs(y))*88;
  ex:= exp(y)
end;

procedure func0 (l1,l2,m1,m2,i,u0,h:extended; var k:extended);
Var c0:extended;
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

procedure func1 (l1,l2,m1,m2,i1,i2,u0,h: extended; var am,k: extended);
var c:extended;
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

procedure func2 (l1,l2,m1,m2,u1,u2,h:extended; var a1,a2,A,B,k:extended);
var E,D,di:extended;
    W,wm:extended;
function fufm01(x:real):extended;
begin
 if u1>u2 then fufm01:=(w*(a1-A)*ex(a1*x)-w*(a2-A)*ex(a2*x))/B
 else fufm01:=(w*(a1-A)*ex(a1*x-h*(a1-a2))-
               w*(a1-A)*ex(a2*x))*ex(h*(a1-a2))/B
end;

function fufm10 (x:extended):extended;
begin
 if u1>u2 then fufm10:=w*ex(a1*x)-w*ex(a2*x)
 else fufm10:=w*ex(h*(a1-a2))*(ex(a1*x-h*(a1-a2))
		 *(a2-A)-(a1-A)*ex(a2*x))/(a2-A)
end;

function loif01 (x:extended):extended;
begin
 if abs(a2)<>0 then
  if u1>u2 then
   loif01:=(w*(a1-A)/a1*(ex(a1*x)-1)-w*(a2-A)/a2*(ex(a2*x)-1))/B
  else loif01:=(a1-A)*(w/a1*(ex(a1*x-h*(a1-a2))-ex(-h*(a1-a2)))-w/a2*(ex(a2*x)-1))/B*ex(h*(a1-a2))
 else
  if u1>u2 then loif01:=w*(a1-A)/(B*a1)*(ex(a1*x)-1)+w*A/B*x
  else loif01:=w*(a1-A)/(B*a1)*(ex(a1*x)-1)-w*(a1-A)/B*ex(a1*h)*x
end;

function loif10 (x:extended):extended;
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

  function fi(a:extended):extended; {INT(x*exp(a*x),0,h)}
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
      avg_stock:=h*h*k*(
                 2+(mu1+mu2)/(lam1+lam2)+
                 (lam1+lam2)/(mu1+mu2)
                       )/2
                 +h*(p11xh+p10xh);
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
             avg_stock:=avg_stock+k*(1-deb2/(deb2-deb1)+lam2/(mu1+mu2))*
                       ((a1-A)*fi1-(a2-A)*fi2)/B;
             avg_stock:=avg_stock+h*(p11xh+p10xh);

           end
           else
           begin
             avg_stock:=k*(1+deb1/(deb2-deb1)+lam1/(mu1+mu2))*
                     (fi(a1)-(a1-A)/(a2-A)*ex(h*(a1-a2))*fi(a2))+
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



begin   {  �������� ���������  }

//     boo:=sequence(order1);

     stock_cost:=0;
              for i:=1 to n do
         if tr[i]<>nil then
           if (et[i]^.pat<>nil) or (st[i]^.pat<>nil) then
		begin
                  write ('����-�� ����������, c������ �� ��������   ');
                  exit;
		end;
a3:     hmin:=mx;
        ihm:=0;
	for i:=2 to m-1 do
	  if pl[i]<>nil then
            if (ep[i]^.pap=nil) and (sp[i]^.pap=nil) then
	      if pl[i]^.h<=hmin then
                begin               { ����� ���������������� ������� }
	        ihm:=i;             { � ����������� �������...       }
	        hmin:=pl[i]^.h
	        end;
	  if ihm<>0 then begin
        l1:=tr[ep[ihm]^.tr]^.l;
        m1:=tr[ep[ihm]^.tr]^.m;
        u1:=ep[ihm]^.vit;

 equiv(l1,m1,u1,                    {          ...� �� ������������  }
  tr[sp[ihm]^.tr]^.l,tr[sp[ihm]^.tr]^.m,sp[ihm]^.vit,hmin,avg_stock);
  stock_cost:=stock_cost+avg_stock*inv_coef*det_cost[ihm]^.h;
                          et[ep[ihm]^.tr]^.vit:=u1; { ������������ �������� }
                          st[sp[ihm]^.tr]^.vit:=u1; { ������ ��������       }
                          tr[ep[ihm]^.tr]^.l:=l1;
                          tr[ep[ihm]^.tr]^.m:=m1;
                          w:=st[sp[ihm]^.tr];       { ���������� ���...}
                          w^.tr:=ep[ihm]^.tr;
       	                  st[ep[ihm]^.tr]:=w;
			  dispose(tr[sp[ihm]^.tr]);
			  et[sp[ihm]^.tr]:=nil;     {...� �������� �������� }
                          st[sp[ihm]^.tr]:=nil;     { ���������             }
			  tr[sp[ihm]^.tr]:=nil;
			  dispose(sp[ihm]);
			  sp[ihm]:=nil;
                          dispose(ep[ihm]);
			  ep[ihm]:=nil;
                          dispose(pl[ihm]);
                          pl[ihm]:=nil;
       			  goto a3                   { ����������� ������    }
			  end;                      { ��������������. ��-�� }
	for i:=1 to m-1 do
         if pl[i]<>nil then
          if sp[i]^.pap<>nil then
			               begin        { ����� �������������   }
		s:=sp[i];                           { ������� ����          }
		while s<>nil do
                                           begin
                  if st[s^.tr]^.pap<>nil then
                                             begin
                                             w:=st[s^.tr];
                    repeat
                    b1:=w^.pap;
          (* FIXED! ---- \/  *)
                    if (b1<>nil) and (et[b1^.tr]^.pos=i) then
                    begin
                                w^.pap:=b1^.pap;
                                w:=et[b1^.tr];
				l1:=tr[s^.tr]^.l;    { ������������         }
				m1:=tr[s^.tr]^.m;    {           ��������   }
				u1:=s^.vit;          { ��� ������ PARL      }
				l2:=tr[w^.tr]^.l;
				m2:=tr[w^.tr]^.m;
				u2:=w^.vit;
                                s1:=s;
                            if w=sp[i] then          { ���������� ���...    }
                              sp[i]:=w^.pap
                                       else
                                         begin
                                s:=sp[i];
                                while s^.pap<>w do
                                  s:=s^.pap;
                                s^.pap:=w^.pap
                                         end;
                                wtr:=w^.tr;
				dispose(tr[wtr]);  { ...� ��������        }
	                        dispose(et[wtr]);  { �������� ���������   }
	                        dispose(st[wtr]);
	                        tr[wtr]:=nil;
	                        st[wtr]:=nil;
	                        et[wtr]:=nil;
	                        parl(l1,m1,u1,l2,m2,u2);
                                tr[s1^.tr]^.l:=l1;   { ����������� �����    }
				tr[s1^.tr]^.m:=m1;   { �������� ��������    }
				s1^.vit:=u1;         { � �����              }
				st[s1^.tr]^.vit:=u1;
                                goto a3              { ������ � ������      }
				                end  {    ������            }

                                       else
		                w:=w^.pap
                    until w=nil
                                             end;
                   s:=s^.pap
		                           end
                                       end;
     end;   {  �������� ���������  }

procedure TMachineLineDolguiStructure.svpl_lead_stock(var l1,m1,u1,stock_cost:real;
                                  var new_order:easy; position:integer);
label a3;
var
 order1:order; boo:boolean;
 ii,ihm,pos,i,wtr         : integer;
 hmin,l2,m2,u2,fi1,fi2     : real;
 A                 : char;
 avg_stock:real;
procedure parl(var l1,m1,u1,l2,m2,u2:real);
var pl:real;
begin
 pl:=u1/(1+l1/m1)+u2/(1+l2/m2);
 u1:=u1+u2;
 l1:=l1*m2/(l2+m2)+l2*m1/(m1+l1);
 m1:=l1/(u1/pl-1);
end;

procedure equiv(var lam1r,mu1r,deb1r,lam2r,mu2r,deb2r,hr,avg_stockr:real);
var lam1,mu1,deb1,lam2,mu2,deb2,h,avg_stock,
    fm11x0,fm11xh,fm10x0,fm10xh,fm01x0,fm01xh,fm00x0,fm00xh:extended;
    f11x0,f11xh,f10x0,f10xh,f01x0,f01xh,f00x0,f00xh:extended;
    p11x0,p11xh,p10xh,p01x0:extended;
    lamp,mup,lama,mua,up,ua,deb,i1,i2:extended;
    pr,prp,pra,mindb,dba,dbp,rp,ra,dp,da,lmp,lma,mp,ma:extended;
    mia,am,a1,a2,A,B,k:extended;

function ex (y:extended):extended;
begin
 if abs(y) > 88 then y:=round(y/abs(y))*88;
  ex:= exp(y)
end;

procedure func0 (l1,l2,m1,m2,i,u0,h:extended; var k:extended);
Var c0:extended;
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

procedure func1 (l1,l2,m1,m2,i1,i2,u0,h: extended; var am,k: extended);
var c:extended;
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

procedure func2 (l1,l2,m1,m2,u1,u2,h:extended; var a1,a2,A,B,k:extended);
var E,D,di:extended;
    W,wm:extended;
function fufm01(x:real):extended;
begin
 if u1>u2 then fufm01:=(w*(a1-A)*ex(a1*x)-w*(a2-A)*ex(a2*x))/B
 else fufm01:=(w*(a1-A)*ex(a1*x-h*(a1-a2))-
               w*(a1-A)*ex(a2*x))*ex(h*(a1-a2))/B
end;

function fufm10 (x:extended):extended;
begin
 if u1>u2 then fufm10:=w*ex(a1*x)-w*ex(a2*x)
 else fufm10:=w*ex(h*(a1-a2))*(ex(a1*x-h*(a1-a2))
		 *(a2-A)-(a1-A)*ex(a2*x))/(a2-A)
end;

function loif01 (x:extended):extended;
begin
 if abs(a2)<>0 then
  if u1>u2 then
   loif01:=(w*(a1-A)/a1*(ex(a1*x)-1)-w*(a2-A)/a2*(ex(a2*x)-1))/B
  else loif01:=(a1-A)*(w/a1*(ex(a1*x-h*(a1-a2))-ex(-h*(a1-a2)))-w/a2*(ex(a2*x)-1))/B*ex(h*(a1-a2))
 else
  if u1>u2 then loif01:=w*(a1-A)/(B*a1)*(ex(a1*x)-1)+w*A/B*x
  else loif01:=w*(a1-A)/(B*a1)*(ex(a1*x)-1)-w*(a1-A)/B*ex(a1*h)*x
end;

function loif10 (x:extended):extended;
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

  function fi(a:extended):extended; {INT(x*exp(a*x),0,h)}
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
      avg_stock:=h*h*k*(
                 2+(mu1+mu2)/(lam1+lam2)+
                 (lam1+lam2)/(mu1+mu2)
                       )/2
                 +h*(p11xh+p10xh);
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
             avg_stock:=avg_stock+k*(1-deb2/(deb2-deb1)+lam2/(mu1+mu2))*
                       ((a1-A)*fi1-(a2-A)*fi2)/B;
             avg_stock:=avg_stock+h*(p11xh+p10xh);

           end
           else
           begin
             avg_stock:=k*(1+deb1/(deb2-deb1)+lam1/(mu1+mu2))*
                     (fi(a1)-(a1-A)/(a2-A)*ex(h*(a1-a2))*fi(a2))+
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



begin   {  �������� ���������  }

//     boo:=sequence(order1);

     stock_cost:=0;
              for i:=1 to n do
         if tr[i]<>nil then
           if (et[i]^.pat<>nil) or (st[i]^.pat<>nil) then
		begin
                  write ('����-�� ����������, c������ �� ��������   ');
                  exit;
		end;
a3:     hmin:=mx;
        ihm:=0;
	for i:=2 to m-1 do
	  if pl[i]<>nil then
            if (ep[i]^.pap=nil) and (sp[i]^.pap=nil) then
	      if pl[i]^.h<=hmin then
                begin               { ����� ���������������� ������� }
	        ihm:=i;             { � ����������� �������...       }
	        hmin:=pl[i]^.h
	        end;
	  if ihm<>0 then begin
        l1:=tr[ep[ihm]^.tr]^.l;
        m1:=tr[ep[ihm]^.tr]^.m;
        u1:=ep[ihm]^.vit;

 equiv(l1,m1,u1,                    {          ...� �� ������������  }
  tr[sp[ihm]^.tr]^.l,tr[sp[ihm]^.tr]^.m,sp[ihm]^.vit,hmin,avg_stock);

{Add the inventory cost only if this buffer in the new_order stands on the place >=position}
  ii:=position;
  while (ii<=m-2) and (new_order[ii]<>ihm-1) do inc(ii);
  if new_order[ii]=ihm-1 then
    stock_cost:=stock_cost+avg_stock*inv_coef*det_cost[ihm]^.h;

                          et[ep[ihm]^.tr]^.vit:=u1; { ������������ �������� }
                          st[sp[ihm]^.tr]^.vit:=u1; { ������ ��������       }
                          tr[ep[ihm]^.tr]^.l:=l1;
                          tr[ep[ihm]^.tr]^.m:=m1;
                          w:=st[sp[ihm]^.tr];       { ���������� ���...}
                          w^.tr:=ep[ihm]^.tr;
       	                  st[ep[ihm]^.tr]:=w;
			  dispose(tr[sp[ihm]^.tr]);
			  et[sp[ihm]^.tr]:=nil;     {...� �������� �������� }
                          st[sp[ihm]^.tr]:=nil;     { ���������             }
			  tr[sp[ihm]^.tr]:=nil;
			  dispose(sp[ihm]);
			  sp[ihm]:=nil;
                          dispose(ep[ihm]);
			  ep[ihm]:=nil;
                          dispose(pl[ihm]);
                          pl[ihm]:=nil;
       			  goto a3                   { ����������� ������    }
			  end;                      { ��������������. ��-�� }
	for i:=1 to m-1 do
         if pl[i]<>nil then
          if sp[i]^.pap<>nil then
			               begin        { ����� �������������   }
		s:=sp[i];                           { ������� ����          }
		while s<>nil do
                                           begin
                  if st[s^.tr]^.pap<>nil then
                                             begin
                                             w:=st[s^.tr];
                    repeat
                    b1:=w^.pap;
          (* FIXED! ---- \/  *)
                    if (b1<>nil) and (et[b1^.tr]^.pos=i) then
                    begin
                                w^.pap:=b1^.pap;
                                w:=et[b1^.tr];
				l1:=tr[s^.tr]^.l;    { ������������         }
				m1:=tr[s^.tr]^.m;    {           ��������   }
				u1:=s^.vit;          { ��� ������ PARL      }
				l2:=tr[w^.tr]^.l;
				m2:=tr[w^.tr]^.m;
				u2:=w^.vit;
                                s1:=s;
                            if w=sp[i] then          { ���������� ���...    }
                              sp[i]:=w^.pap
                                       else
                                         begin
                                s:=sp[i];
                                while s^.pap<>w do
                                  s:=s^.pap;
                                s^.pap:=w^.pap
                                         end;
                                wtr:=w^.tr;
				dispose(tr[wtr]);  { ...� ��������        }
	                        dispose(et[wtr]);  { �������� ���������   }
	                        dispose(st[wtr]);
	                        tr[wtr]:=nil;
	                        st[wtr]:=nil;
	                        et[wtr]:=nil;
	                        parl(l1,m1,u1,l2,m2,u2);
                                tr[s1^.tr]^.l:=l1;   { ����������� �����    }
				tr[s1^.tr]^.m:=m1;   { �������� ��������    }
				s1^.vit:=u1;         { � �����              }
				st[s1^.tr]^.vit:=u1;
                                goto a3              { ������ � ������      }
				                end  {    ������            }

                                       else
		                w:=w^.pap
                    until w=nil
                                             end;
                   s:=s^.pap
		                           end
                                       end;
     end;   {  �������� ���������  }

procedure TMachineLineDolguiStructure.svpl_incomplete(buf_var:integer;
                                var reduced_line_kind:integer;
                                var reduced_line:machine_array;
                                var stock_cost:real);
label a3;
var l1,m1,u1:real;
 ihm,pos,i,wtr         : integer;
 hmin,l2,m2,u2,fi1,fi2     : real;
 A                 : char;
 avg_stock:real;
 bufs_remained:integer; {����� ���������� ������������� ������� � �������� �������}

procedure parl(var l1,m1,u1,l2,m2,u2:real);
var pl:real;
begin
 pl:=u1/(1+l1/m1)+u2/(1+l2/m2);
 u1:=u1+u2;
 l1:=l1*m2/(l2+m2)+l2*m1/(m1+l1);
 m1:=l1/(u1/pl-1);
end;

procedure equiv(var lam1r,mu1r,deb1r,lam2r,mu2r,deb2r,hr,avg_stockr:real);
var lam1,mu1,deb1,lam2,mu2,deb2,h,avg_stock,
    fm11x0,fm11xh,fm10x0,fm10xh,fm01x0,fm01xh,fm00x0,fm00xh:extended;
    f11x0,f11xh,f10x0,f10xh,f01x0,f01xh,f00x0,f00xh:extended;
    p11x0,p11xh,p10xh,p01x0:extended;
    lamp,mup,lama,mua,up,ua,deb,i1,i2:extended;
    pr,prp,pra,mindb,dba,dbp,rp,ra,dp,da,lmp,lma,mp,ma:extended;
    mia,am,a1,a2,A,B,k:extended;

function ex (y:extended):extended;
begin
 if abs(y) > 88 then y:=round(y/abs(y))*88;
  ex:= exp(y)
end;

procedure func0 (l1,l2,m1,m2,i,u0,h:extended; var k:extended);
Var c0:extended;
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

procedure func1 (l1,l2,m1,m2,i1,i2,u0,h: extended; var am,k: extended);
var c:extended;
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

procedure func2 (l1,l2,m1,m2,u1,u2,h:extended; var a1,a2,A,B,k:extended);
var E,D,di:extended;
    W,wm:extended;
function fufm01(x:real):extended;
begin
 if u1>u2 then fufm01:=(w*(a1-A)*ex(a1*x)-w*(a2-A)*ex(a2*x))/B
 else fufm01:=(w*(a1-A)*ex(a1*x-h*(a1-a2))-
               w*(a1-A)*ex(a2*x))*ex(h*(a1-a2))/B
end;

function fufm10 (x:extended):extended;
begin
 if u1>u2 then fufm10:=w*ex(a1*x)-w*ex(a2*x)
 else fufm10:=w*ex(h*(a1-a2))*(ex(a1*x-h*(a1-a2))
		 *(a2-A)-(a1-A)*ex(a2*x))/(a2-A)
end;

function loif01 (x:extended):extended;
begin
 if abs(a2)<>0 then
  if u1>u2 then
   loif01:=(w*(a1-A)/a1*(ex(a1*x)-1)-w*(a2-A)/a2*(ex(a2*x)-1))/B
  else loif01:=(a1-A)*(w/a1*(ex(a1*x-h*(a1-a2))-ex(-h*(a1-a2)))-w/a2*(ex(a2*x)-1))/B*ex(h*(a1-a2))
 else
  if u1>u2 then loif01:=w*(a1-A)/(B*a1)*(ex(a1*x)-1)+w*A/B*x
  else loif01:=w*(a1-A)/(B*a1)*(ex(a1*x)-1)-w*(a1-A)/B*ex(a1*h)*x
end;

function loif10 (x:extended):extended;
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

  function fi(a:extended):extended; {INT(x*exp(a*x),0,h)}
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
             avg_stock:=avg_stock+k*(1-deb2/(deb2-deb1)+lam2/(mu1+mu2))*
                       ((a1-A)*fi1-(a2-A)*fi2)/B;
             avg_stock:=avg_stock+h*(p11xh+p10xh);

           end
           else
           begin
             avg_stock:=k*(1+deb1/(deb2-deb1)+lam1/(mu1+mu2))*
                     (fi(a1)-(a1-A)/(a2-A)*ex(h*(a1-a2))*fi(a2))+
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

begin   {  �������� ���������  }
     bufs_remained:= m-2;
     stock_cost:=0;
              for i:=1 to n do
         if tr[i]<>nil then
           if (et[i]^.pat<>nil) or (st[i]^.pat<>nil) then
		begin
                  write ('����-�� ����������, c������ �� ��������   ');
                  exit;
		end;
a3:     hmin:=mx;
        ihm:=0;
	for i:=2 to m-1 do      (**********)
	  if (pl[i]<>nil)  and  (i<>buf_var) then
            if (ep[i]^.pap=nil) and (sp[i]^.pap=nil) then
	      if pl[i]^.h<=hmin then
                begin               { ����� ���������������� ������� }
	        ihm:=i;             { � ����������� �������...       }
	        hmin:=pl[i]^.h
	        end;
	  if ihm<>0 then begin
        l1:=tr[ep[ihm]^.tr]^.l;
        m1:=tr[ep[ihm]^.tr]^.m;
        u1:=ep[ihm]^.vit;
 dec(bufs_remained);
 equiv(l1,m1,u1,                    {          ...� �� ������������  }
  tr[sp[ihm]^.tr]^.l,tr[sp[ihm]^.tr]^.m,sp[ihm]^.vit,hmin,avg_stock);
  stock_cost:=stock_cost+avg_stock*inv_coef*det_cost[ihm]^.h;
                          et[ep[ihm]^.tr]^.vit:=u1; { ������������ �������� }
                          st[sp[ihm]^.tr]^.vit:=u1; { ������ ��������       }
                          tr[ep[ihm]^.tr]^.l:=l1;
                          tr[ep[ihm]^.tr]^.m:=m1;
                          w:=st[sp[ihm]^.tr];       { ���������� ���...}
                          w^.tr:=ep[ihm]^.tr;
       	                  st[ep[ihm]^.tr]:=w;
			  dispose(tr[sp[ihm]^.tr]);
			  et[sp[ihm]^.tr]:=nil;     {...� �������� �������� }
                          st[sp[ihm]^.tr]:=nil;     { ���������             }
			  tr[sp[ihm]^.tr]:=nil;
			  dispose(sp[ihm]);
			  sp[ihm]:=nil;
                          dispose(ep[ihm]);
			  ep[ihm]:=nil;
                          dispose(pl[ihm]);
                          pl[ihm]:=nil;
       			  goto a3                   { ����������� ������    }
			  end;                      { ��������������. ��-�� }
	for i:=1 to m-1 do
         if (pl[i]<>nil) then
          if sp[i]^.pap<>nil then {�� ������ ���� ��������� �������}
          begin        { ����� �������������   }
		s:=sp[i];                           { ������� ����          }
		while s<>nil do
                begin
                  if st[s^.tr]^.pap<>nil then {� ����� �� ���� �������
                                               �������� ��������� �������}
                  begin
                    w:=st[s^.tr]; {������ �� ����, �������� � ����� �� �������}
                    repeat
                      b1:=w^.pap;
             (* FIXED! ---- \/  *)
                      if (b1<>nil) and (et[b1^.tr]^.pos=i) then
			{���� ������ b1^.tr ���� �����  ������ �� ������ i ��:}
                      begin
                        w^.pap:=b1^.pap; {������������ ������ �� w �� b1^.pap ������ b1}

                        w:=et[b1^.tr];
			l1:=tr[s^.tr]^.l;    { ������������         }
			m1:=tr[s^.tr]^.m;    {           ��������   }
			u1:=s^.vit;          { ��� ������ PARL      }
			l2:=tr[w^.tr]^.l;
			m2:=tr[w^.tr]^.m;
			u2:=w^.vit;
                        s1:=s;
                        if w=sp[i] then          { ���������� ��� (���������� ���� w �� ������ sp[i]) }
                          sp[i]:=w^.pap
                        else
                        begin
                          s:=sp[i];
                          while s^.pap<>w do
                            s:=s^.pap;
                          s^.pap:=w^.pap
                        end;
                        wtr:=w^.tr;

			{ �������� ��������� ������ }
			dispose(tr[wtr]);
	                dispose(et[wtr]);
	                dispose(st[wtr]);
	                tr[wtr]:=nil;
	                st[wtr]:=nil;
	                et[wtr]:=nil;

	                parl(l1,m1,u1,l2,m2,u2);
                        tr[s1^.tr]^.l:=l1;   { ����������� �����    }
			tr[s1^.tr]^.m:=m1;   { �������� ����������� ��������}
			s1^.vit:=u1;         { � �����              }
			st[s1^.tr]^.vit:=u1;
                        goto a3              { ����� � ������      }
		      end                    {    ������            }
                      else
		        w:=w^.pap
                    until w=nil
                  end;
                  s:=s^.pap; {������� � ���������� ������ ������ i }
		end
        end;

        if bufs_remained=1 then
        begin
          reduced_line_kind:=1;
          i:=ep[buf_var]^.tr; {������ ������}
          reduced_line[1].u:=st[i]^.vit; {������������������ ������ ������ � �.�.}
          reduced_line[1].lambda:=tr[i]^.l;
          reduced_line[1].mu:=tr[i]^.m;
          i:=sp[buf_var]^.tr; {������ ������}
          reduced_line[2].u:=st[i]^.vit; {������������������ ������ ������ � �.�.}
          reduced_line[2].lambda:=tr[i]^.l;
          reduced_line[2].mu:=tr[i]^.m;
        end
        else
        begin
          reduced_line_kind:=0; {���� ������}
        end;
     end;   {  �������� ���������  }

destructor TMachineLineDolguiStructure.done;
var i:my_int;
begin
 for i:=1 to m do
 begin
  if pl[i]<>nil then
  begin
   dispose(pl[i]);
   pl[i]:=nil;
  end;
  if sp[i]<>nil then
  begin
   dispose(sp[i]);
   sp[i]:=nil;
  end;
  if ep[i]<>nil then
  begin
   dispose(ep[i]);
   ep[i]:=nil;
  end;
 end;
 for i:=1 to n do
 begin
  if tr[i]<>nil then
  begin
   dispose(tr[i]);
   tr[i]:=nil;
  end;
//if st[i]<>nil then
//begin
// dispose(st[i]);
// st[i]:=nil;
//end;
//if et[i]<>nil then
//begin
// dispose(et[i]);
// et[i]:=nil;
//end;
 end;
end;

procedure TMachineLineDolguiStructure.Imitation(DlitMod, NmbIter: integer; var Throughput_,StorageCost_:real);
(*------------------------------------------------------------------
     подпрограмма для имитации параметризованной
     сети Петри
  ------------------------------------------------------------------ *)

label
      Me01,me21,me24,me27,
      me30,me31,me32,me33,me34,me35,me37,
      me40,me42,Prer,Pokaz,mexit;

      (*--------------------------------------------------------------------
        типы
               ms  - массивы начальной и текущей маркировок
               ls  - массивы наработок до отказа для переходов
               la  - массивы для отметки занятости переходов
             Spis  - элемент статического и динамического списков
          Numtrsp  - номер перехода помещенного в список
           TimeSp  - временная отметка перехода
           Avant   - ссылка на предедущую запись списка
           Arrier  - ссылка на последующуу запись списка
        --------------------------------------------------------------------*)

type ms=array[1..am] of integer ;
     ls=array[1..an] of double ;
     la=array[1..an] of boolean ;
     sspis=^spis ;
     Spis=record
          NumTrSp: 0..an ;
          TimeSp:real ;
          Avant:sspis ;
          Arrier:sspis
          end;
      Stroka=string;
(*--------------------------------------------------------------------
переменные

Numtran  - номер рассматриваемого перехода
TimeCour - текущее модельное время
Time     - время
DlitMod  - длительность моделирования
NumIter  - номер текущей итерации
NmbIter  - число итераций
FinPos   - номер позиции для сбора статистики
Numpos   - номер маркировки
nmr,i,j  - индексные переменные
EntrStr1 - строка для ввода начальной маркировки
Produc   - производительность моделируемой системы
SspEntr  - ссылка на начало статического списка
SspSort  - ссылка на конец статического списка
DspEntr  - ссылка на начало динамического списка
DspSort  - ссылка на конец динамического списка
ZspEntr  - ссылка на начало списка задержанных переходов
ZspSort  - ссылка на конец  списка задержанных переходов
PredTran - множество предшествующих переходов
At,Ap,Bt,Bp - вспомогательные ссылочные переменные
MarkNul,MarkCour- начальная и текущая маркировка
OcupTran -массив для отметки занятости переходов
OtkTran  -массив наработок до отказа
cod      - kod возврата процедуры VAL

переменные, описанные в уните trnsl:
w,b,b1,s,s1    - ссылочные переменные на дуги
str5           - строка содержащая имя файла модели
et,st          - массивы ссылок на дуги инцидентные переходам
ep,sp          - массивы ссылок на дуги инцидентные позициям
tr             - массивы ссылок на параметры переходов
pl             - массивы ссылок на параметры позиций
m,n            - число позиций и переходов
am,an          - максимально возможное число позиций и переходов
mx             - константа 0.1E+38
--------------------------------------------------------------------*)

var
     TimeCour,Time                          : real;
     NumIter,FinPos,Numpos,Numtran  : word ;
     nmr,j,i,k                                : integer ;
     EntrStr1,EntrStr2                      : Stroka;
     Produc                                 : real;
     SspEntr,SspSort                        : sspis;
     DspEntr,DspSort                        : sspis;
     ZspEntr,ZspSort                        : sspis;
     At,Ap,Bt,Bp                            : sspis;
     MarkNul,MarkCour                       : ms;
     OtkTran                                : ls;
     OcupTran                               : la;
     r1,A                                   : char;
     PredTran                               : set of 0..an;
     Cod                                    : integer;
     Produc1                                : real ;
     PosEntr,err                            : integer ;
     Esc                                    : boolean ;
     Buf                                    : pointer ;
     Kode                                   : integer ;
     bs,c                                   : string ;
     help                                    : real ;


begin
  randomize;
  Throughput_ := 0;
  StorageCost_:=0;

{ ---------  начальные значения переменных (по умолчанию)  ---------  }

  FinPos:=m;         { позиция для сбора статистики       }
  Time:=0;           { модельное время (не исп.)          }
  NumTran:=1;        { номер стартового перехода(не исп.) }

{  -----------  начальная маркировка (по умолчанию) ----------------  }

  MarkNul[1]:=DlitMod*100;
  PosEntr:=1;
  for i:=2 to Length(MarkNul) do
    MarkNul[i]:=0;
{  -------------------- ���������� ������ ----------------  }

(*------------------------------------------------------------------
начальные значения переменнных
------------------------------------------------------------------ *)
  Produc1:=0 ;
  NumIter:=0;
  Numpos:=1;
  TimeCour:=0;
  i:=0; j:=0;
  EntrStr1:='  0';  Produc:=0;
  SspEntr:=nil; SspSort:=nil;
  DspEntr:=nil; DspSort:=nil;
  ZspEntr:=nil; ZspSort:=nil;
  At:=nil; Ap:=nil; Bt:=nil; Bp:=nil;
  MarkCour:=MarkNul;
(*------------------------------------------------------------------
занесение стартового перехода в статический список
------------------------------------------------------------------*)
  New(SspEntr);
  SspEntr^.NumTrSp:=0;
  SspSort:=SspEntr;
  SspEntr^.Avant:=nil; SspEntr^.Arrier:=nil;
  SspEntr^.TimeSp:=DlitMod;


  for i:=1 to n do
  begin
    if tr[i]<>nil then
    begin
        OtkTran[i]:=-ln(1-random())/tr[i]^.l;
    end
    else
        OtkTran[i]:=mx;
  end;

  for i:=1 to n do OcupTran[i]:=False;

  w:=nil; b:=nil; s:=nil; s1:=nil; b1:=nil;

(*-------------------------------------------------------------------
обращение к статическому списку для выполнения
следующего шага сценария
------------------------------------------------------------------- *)

Me21:

  if SspEntr^.NumTrSp=0 then goto me40;

(*-----------------------------------------------------
проверить осуществимо ли заданное управление
----------------------------------------------------- *)

  s:=et[SspEntr^.NumTrSp];

Me24:

  if s=nil then goto me27;
  if MarkCour[s^.pos]>0 then begin
     s:=s^.pat;
     goto me24;
  end
  else begin
    goto me01;
  end;

(*------------------------------------------------------------
снять у принудительно запускаемого перехода входную
маркировку и отметить занятость перехода
------------------------------------------------------------ *)
  s:=et[Sspentr^.NumTrSp];
  while s<>nil do begin
    MarkCour[s^.pos]:=MarkCour[s^.pos]-1;
    s:=s^.pat;
  end;
  OcupTran[SspEntr^.NumTrSp]:=True;

(*---------------------------------------------------------------
переслать номер перехода из статического списка
в динамический
--------------------------------------------------------------- *)

me27:

  New(DspEntr);
  DspEntr^.NumTrSp:=SspEntr^.NumTrSp;
  DspEntr^.Avant:=nil;
  DspEntr^.Arrier:=nil;
  if SspEntr^.TimeSp<=TimeCour then DspEntr^.TimeSp:=TimeCour
  else DspEntr^.TimeSp:=SspEntr^.TimeSp;

  DspSort:=DspEntr;

(*------------------------------------------------------------------
поместить в статическом списке первый переход на последнее
место
------------------------------------------------------------------ *)

  if SspEntr^.Arrier<>nil then    begin
    SspEntr^.Avant:=SspSort;
    SspSort^.Arrier:=SspEntr;
    SspSort:=SspEntr;
    SspEntr^.Arrier^.Avant:=nil;
    SspEntr:=SspEntr^.Arrier;
  end;

me30:

(*------------------------------------------------------------
расмотреть очередное событие в динамическом списке
------------------------------------------------------------*)

  if DspEntr=nil then goto me21;
	
//mes := IntToStr(NumIter)+';'+ IntToStr(Round(DspEntr^.TimeSp))+';'+IntToStr(MarkCour[1])+';'+IntToStr(MarkCour[2])+';'+IntToStr(MarkCour[3])+';'+IntToStr(MarkCour[4])+';'+IntToStr(MarkCour[5])+';'+IntToStr(MarkCour[6])+';';
//messages.Add(mes);

(*-------------------------------------------------------------
проверка условий завершения очередного прогона
--------------------------------------------------------------- *)

  if DspEntr^.TimeSp>=DlitMod then goto me40;

(*---------------------------------------------------------------
продвинуться к следующему моменту времени
и удалить первый элемент динамического списка
----------------------------------------------------------------*)

  NumTran:=DspEntr^.NumTrSp;

  if TimeCour<DspEntr^.TimeSp then TimeCour:=DspEntr^.TimeSp;
  Bp:=DspEntr^.Arrier;
  if Bp<>nil then Bp^.Avant:=nil;
  dispose(DspEntr);
  DspEntr:=Bp;
  if DspEntr=nil Then DspSort:=nil;

(*----------------------------------------------------------------
проверить не является ли данный переход задержанным
---------------------------------------------------------------*)

  b:=st[NumTran];
  While b<>nil do begin
     if pl[b^.pos]^.h>=32000 then goto me31;
     if MarkCour[b^.pos]>=round(pl[b^.pos]^.h+1) then goto me32;
me31:
     b:=b^.pat
  end;

(*-----------------------------------------------------------------
выставить выходную маркировку и снять занятость
-----------------------------------------------------------------*)

  s:=st[NumTran];
  while s<>nil do begin
     MarkCour[s^.pos]:=MarkCour[s^.pos]+1;
     s:=s^.pat
  end;

  OcupTran[NumTran]:=False;

(*------------------------------------------------------------------
реализовать правило диспетчирования- выбрать последовательность
активизации переходов и поместить их в динамический
список
-------------------------------------------------------------------*)

Me33:
  { DISP  }
  i:=m;
  While i<>0 do begin {a}
     if MarkCour[i]>0 then begin {b}
        s:=sp[i];
        while s<>nil do begin {c}
           if OcupTran[s^.tr]=True then goto me35;
           s1:=et[s^.tr];
           while s1<>nil do
              if MarkCour[s1^.pos]>0 then
                 s1:=s1^.pat
              else goto me35;
           s1:=et[s^.tr];
           OcupTran[s^.tr]:=True;

           While s1<>nil do begin
              MarkCour[s1^.pos]:=MarkCour[s1^.pos]-1;
              s1:=s1^.pat
           end;

           if (1/s^.vit)>=OtkTran[s^.tr] then begin
              Time:=TimeCour+1/s^.vit-ln(1-Random)/tr[s^.tr]^.m;
              OtkTran[s^.tr]:=OtkTran[s^.tr]-ln(1-Random)/tr[s^.tr]^.l-1/s^.vit
           end
           else begin
             OtkTran[s^.tr]:=OtkTran[s^.tr]-1/s^.vit;
             Time:=TimeCour+1/s^.vit;
           end;

(*---------------------------------------------------------------------
вставить в список активизированный переход
---------------------------------------------------------------------*)
          Bp:=DspEntr;
          While Bp<>nil do  begin
             if Bp^.TimeSp>Time then begin
                new(Ap);
                Ap^.Avant:=Bp^.Avant;
                Ap^.Arrier:=Bp;
                if Ap^.Avant<>nil then Ap^.Avant^.Arrier:=Ap;
                Bp^.Avant:=Ap;
                Ap^.TimeSp:=Time;
                Ap^.NumTrSp:=s^.tr;
                if Bp=DspEntr then DspEntr:=Ap;
                goto me34;
             end;
             Bp:=Bp^.Arrier;
          end;
(*------------------------------------------
вставить в конец списка или в пустой список
-------------------------------------------*)
          new(Ap);
          Bp:=DspSort;
          if  Bp<>nil then Bp^.Arrier:=Ap;
          Ap^.Avant:=Bp;
          Ap^.Arrier:=nil;
          AP^.TimeSp:=Time;
          Ap^.NumTrSp:=s^.tr;
          DspSort:=Ap;
          if DspEntr=nil then DspEntr:=Ap;

(*-------------------------------------------
проверить нет ли задержаных переходов
изменивших свой статус
-------------------------------------------*)

me34:

          if ZspSort<>nil then begin {сформировать мн-во предшествующих пер.}
             PredTran:=[];
             s1:=et[s^.tr];
             While s1<>nil do begin
                w:=ep[s1^.pos];
                While w<>nil do begin
                    PredTran:=PredTran+[W^.tr];
                    w:=w^.pap
                end;
                s1:=s1^.pat
             end;
             if PredTran=[] then goto me35 ;
{ просмотр списка задержанных переходов }
             Bt:=ZspSort;
             While Bt<>nil do
                 if Bt^.NumTrSp in PredTran then
                 begin
{вставить первым элементом списка Dt }
                    New(Ap);
                    DspEntr^.Avant:=Ap;
                    Ap^.Arrier:=DspEntr;
                    Ap^.Avant:=nil;
                    Ap^.NumTrSp:=Bt^.NumTrSp;
                    Ap^.TimeSp:=Bt^.TimeSp;
                    DspEntr:=Ap;
{удалить элемент из списка Zt }

                    if Bt=ZspSort then ZspSort:=Bt^.Avant;
                    if Bt=ZspEntr then ZspEntr:=Bt^.Arrier;
                    if Bt^.Avant<>nil then Bt^.Avant^.Arrier:=Bt^.Arrier;
                    if Bt^.arrier<>nil then Bt^.Arrier^.Avant:=Bt^.Avant;

                    Dispose(Bt) ;
                    Bt:=nil
                 end
                 else Bt:=Bt^.Avant;

                 PredTran:=[]
          end;
me35:
(*------------------------
 перейти к следующей дуге
 -------------------------*)
          s:=s^.pap;
        end{c};
     end{b};
Me37:
     i:=i-1
  end{a};
  goto me30;

me32:
(*-------------------------------------------------------------------
поместить переход в список задержанных -Zt
---------------------------------------------------------------------*)
  New(Ap);
  Bp:=ZspSort;
  if Bp<>nil then Bp^.Arrier:=Ap;
  Ap^.Avant:=Bp;
  Ap^.Arrier:=nil;
  Ap^.TimeSp:=TimeCour;
  Ap^.NumTrSp:=NumTran;
  ZspSort:=Ap;
  if ZspEntr=nil then ZspEntr:=Ap;

  goto me30;

(*------------------------------------------------------------------
обработка результатов прогона модели
------------------------------------------------------------------ *)

me40:

  i:=2;
  for i:=2 to m-1 do
  begin
     StorageCost_:=StorageCost_+MarkCour[i]*inv_coef*det_cost[i]^.h;
  end;

  if NumIter=0 then Produc:=Produc-MarkCour[FinPos]
  else produc1:=produc;

  Produc:=Produc+MarkCour[FinPos];
  produc1:=produc-produc1 ;
  NumIter:=NumIter+1;
(*----------------------------
очистить динамический список
----------------------------*)
  while DspEntr<>nil do
  begin
    Bt:=DspEntr;
    DspEntr:=Bt^.Arrier;
    Dispose(Bt);
  end;
  DspSort:=nil; DspEntr:=nil;
(*----------------------------
очистить список задержанных
----------------------------*)
  while ZspEntr<>nil do
  begin
     Bt:=ZspEntr;
     ZspEntr:=Bt^.Arrier;
     Dispose(Bt);
  end;

  ZspSort:=nil; ZspEntr:=nil;
  TimeCour:=0;

Prer:

  for i:=1 to n do
  begin
     if tr[i]<>nil then
        OtkTran[i]:=-ln(1-random)/tr[i]^.l
     else
        OtkTran[i]:=mx;
  end;

  for i:=1 to n do
    OcupTran[i]:=False;

  MarkCour:=MarkNul;

  if NumIter>NmbIter then
  begin
     NumIter:=NmbIter;
     goto me42;
  end;

  if SspEntr^.NumTrSp<>0 then
  goto me01;

  goto Me33;

me42:

  Produc:=Produc/NumIter;

  Throughput_:=(Produc/DlitMod);

  StorageCost_:=StorageCost_/NumIter;

Me01:

end;  {  IMIT  }

end.






