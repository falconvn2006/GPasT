unit Molview1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TFrustumClass, dglOpenGL, ExtCtrls, AppEvnts, StdCtrls, Buttons,
  ComCtrls, DBCtrls, ToolWin, Math;

type
  AtomRecord = array of record
                 x,y,z,Radius : Single;
                 R,G,B        : Single;
                 Speed        : Single;
                end;
  BondRecord = array of record
               a1,a2:integer;
              end;

TLightDesc=record
red,
green,
blue,
alpha: glFloat;
end;

  TGLDraw = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button2: TButton;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Panel3: TPanel;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    StaticText1: TStaticText;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    Timer1: TTimer;
    SpeedButton3: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure LefMovClick(Sender: TObject);
    procedure RightmovClick(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SetProtDraw(aAtom : AtomRecord; aBond: BondRecord);
    procedure Draw1;
    procedure drawjet;
    procedure DrawGLCylinder4(rb, rt, h: single; ns:integer );
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Panel1Click(Sender: TObject);



   private
    //Mouse move block
    alpha, betha:GLfloat; //angle for mouse event
    dx,dy:GLFloat;        //current angle offsets
    mStartX,mStartY:integer; //start point for mouse move

    procedure GLMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    //custom mouse up event for new control
    procedure GLMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    //custom mouse move event for new control
    procedure GLMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  public
    RC : HGLRC;
    DC : HDC;
  end;

var
  GLDraw      : TGLDraw;
  Atom        : AtomRecord;
  Bond        : BondRecord;
  Frames      : Integer;
  bondseq, FrustumCull : Boolean;
  Anim, BackBone    : Boolean;
  MovRL,MovUD, modZ        : Single;
  angle: double;

implementation

{$R *.dfm}
//--------------------String Tools -------------------------------------

const delims=' '#9#13#10;


function GetToken(const s:string;var cp:integer):string;
var b:integer;
begin
  while (Pos(s[cp],delims)<>0) and (cp<=length(s)) do inc(cp);
  b:=cp;
  while (Pos(s[cp],delims)=0) and (cp<=length(s)) do inc(cp);
  result:=copy(s,b,cp-b);
end;

function StoR(s:string):single;
var k:integer;
begin
 while pos(',',s)>0 do s[pos(',',s)]:='.';
 val(s,result,k);
 if k<>0 then raise Exception.Create('Floating point number parsing error.');
end;




procedure TGLDraw.FormCreate(Sender: TObject);
begin
FrustumCull := True;
Anim        := True;
BackBone    := true;
modZ := 0.0;
MovRL:=0.0;
MovUD := 0.0;
{Alpha := -10;
betha:=-5;
dx:=0;
dy:=0;
 }
panel1.OnMouseDown:=GLMouseDown;
panel1.OnMouseMove:=GLMouseMove;
panel1.OnMouseUp:=GLMouseUp;
InitOpenGL;
DC := GetDC(Panel1.Handle);
RC := CreateRenderingContext(DC, [opDoubleBuffered], 32, 24, 0, 0, 0, 0);
ActivateRenderingContext(DC, RC);

// Black Background
glClearColor(0.0,0.0,0.0,0.0);
glClear(GL_COLOR_BUFFER_BIT);
glEnable(GL_NORMALIZE);
glEnable(GL_LINE_WIDTH);
glEnable(GL_LIGHTING);
glEnable(GL_DEPTH_TEST);
draw1;
end;

procedure TGLDraw.FormDestroy(Sender: TObject);
begin
DeactivateRenderingContext;
DestroyRenderingContext(RC);
ReleaseDC(Handle, DC);                              
end;

procedure  TGLDraw.FormPaint(Sender: TObject);
begin
 if Anim then angle:=angle + 2;
 if Angle >=359 then Angle := 0.0;
 DrawJet;
end;


procedure TGLDraw.GLMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 Label1.Caption:=Format('down: %d, %d',[X,Y]);
 mStartX:=X;
 mStartY:=Y;
end;

procedure TGLDraw.GLMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 Label1.Caption:=Format('up: %d, %d',[X,Y]);
 alpha:=alpha+dx;
 dx:=0.0;
 betha:=betha+dy;
 dy:=0.0;
end;

procedure TGLDraw.GLMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 if (ssLeft in Shift) then begin
   Label1.Caption:=Format('Rotation : %d, %d',[X,Y]);
   dx:=(x-mStartX)/2;
   dy:=(y-mStartY)/2;
  Drawjet;
 end;
 if (ssRight in Shift) then begin
   Label1.Caption:=Format('Translate: %d, %d',[X,Y]);
    MovRl:= MovRL+(x-mStartX)/200;
    MovUD:= MovUD-(Y-MStarty)/200;
    DrawJet;
   end;

end;

procedure TGLDraw.SetProtDraw(aAtom : AtomRecord; abond: BondRecord);
var
 I : Integer;
begin
 I:= High(aAtom)+1;
 SetLength(Atom, I);
for i := 0 to High(Atom) do
 with Atom[i] do
  begin
   x      := aAtom[i].x;
   y      := aAtom[i].y;
   z      := aAtom[i].z;
   r      := aAtom[i].r;
   g      := aAtom[i].g;
   b      := aAtom[i].b;
   Speed  := 0;
  Radius := aAtom[i].Radius;
  end;

  I := High(aBond)+1;
 if I <> 0 then
   begin
    Bondseq := true;
    Setlength (Bond, I);
    For  I :=0 to High(Bond) do
     begin
      Bond[I].a1 := aBond[i].a1;
      Bond[I].a2 := aBond[I].a2;
     end;

  end;

 Alpha := -10;
 betha:=-5;
 dx:=0;
 dy:=0;
 draw1;
end;

procedure TGLDraw.draw1;
var
 Q : PGLUQuadric;
 i : Integer;
 ambient: TLightDesc;
begin
ambient.red := 0.2;
ambient.green := 0.5;
ambient.blue := 0.8;
ambient.alpha := 1.0;
glMaterialfv(GL_FRONT,GL_AMBIENT,@ambient);
if Length(Atom) = 0 then
 exit;

glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
glViewport(0, 0, Panel1.ClientWidth, Panel1.ClientHeight);
glMatrixMode(GL_PROJECTION);
glLoadIdentity;
gluPerspective(45, Panel1.ClientWidth/Panel1.ClientHeight, 0.1, 1024);
glMatrixMode(GL_MODELVIEW);
glLoadIdentity;

glEnable(GL_LIGHT0);
glEnable(GL_LIGHTING);
glEnable(GL_COLOR_MATERIAL);

glTranslatef(0,-10,-200);
//glTranslatef(MovRl,-10 + MovUD ,-200 + modZ);

 // GLtRANSLATE(0.0.-100);
Frustum.Calculate;

Q := gluNewQuadric;
for i := 0 to High(Atom) do
 with Atom[i] do
  if Frustum.IsSphereWithin(x,y,z,Radius) or not FrustumCull then
   begin
    glPushMatrix;
    glColor3f(r,g,b);
    glTranslatef(x,y,z);
    gluSphere(Q, Radius, 16, 16);
    glPopMatrix;
   end;

//    glBegin(GL_LINES);
 if   not bondseq then
  begin
    glLineWidth(6.0);
    glbegin(GL_Lines);
    glColor3f(0.3, 0.3, 0.8);
    for I:=1 to high(Atom) do
     begin
      glVertex3f(Atom[i-1].x,Atom[i-1].y,Atom[i-1].z);
      glVertex3f(Atom[i].x,Atom[i].y,Atom[i].z);
     end;
    glEnd;
  end;

SwapBuffers(DC);
inc(Frames);
gluDeleteQuadric(Q);
end;


procedure TGLDraw.drawjet;
var
 Q  : PGLUQuadric;
 i, T1,T2, dth,dz : Integer;
 ambient: TLightDesc;
 xm,ym,zm, r2d,rb,rt,ax,
 vx,vy,vz,v,rx,ry:double;


begin
ambient.red := 0.2;
ambient.green := 0.5;
ambient.blue := 0.8;
ambient.alpha := 1.0;

r2d := 180.0/pi;	// radians to degrees conversion factor
rb := 0.15;	 // radius of cylinder bottom
rt := 0.15;	 // radius of cylinder bottom
dth := 10;		 // no. of angular cylinder subdivsions
dz := 10;		 // no. of cylinder subdivsions in z direction

glMaterialfv(GL_FRONT,GL_AMBIENT,@ambient);
if Length(Atom) = 0 then
 exit;

glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
glViewport(0, 0, Panel1.ClientWidth, Panel1.ClientHeight);
glMatrixMode(GL_PROJECTION);
glLoadIdentity;
gluPerspective(45, Panel1.ClientWidth/Panel1.ClientHeight, 0.1, 1024);
glMatrixMode(GL_MODELVIEW);
glLoadIdentity;

glEnable(GL_LIGHT0);
glEnable(GL_LIGHTING);
glEnable(GL_COLOR_MATERIAL);

//glTranslatef(0,-10,-200);
 glTranslatef(MovRl,-10 + MovUD ,-200 + modZ);
 glRotatef(alpha+dx,0.0,1.0,0.0);
 glRotatef(betha+dy,1.0,0.0,0.0);
 if anim then glRotatef(angle,1,1,0);
 // GLtRANSLATE(0.0.-100);
Frustum.Calculate;

Q := gluNewQuadric;

if BackBone then
for i := 0 to High(Atom) do
 with Atom[i] do
  if Frustum.IsSphereWithin(x,y,z,Radius) or not FrustumCull then
   begin
    glPushMatrix;
    glColor3f(r,g,b);
    glTranslatef(x,y,z);
    gluSphere(Q, Radius, 16, 16);
    glPopMatrix;
   end;


 if  not bondseq then
  begin
    glBegin(GL_LINES);
   // if backbone then glLineWidth(1.0) else glLineWidth(2.0);
    for I:=1 to high(Atom) do
     begin
      xm := (Atom[i-1].x + Atom[i].x )/2 ;
      ym :=  (Atom[i-1].y + Atom[i].y)/2;
      zm :=  (Atom[i-1].z + Atom[i].z)/2;
      glColor3f(0.0, 1.0, 0.0);                  // green */
      glColor3f(0.5, 0.5, 0.5);                  // red */
      glVertex3f(Atom[i-1].x,Atom[i-1].y,Atom[i-1].z);
      glVertex3f(xm,ym,zm);
      glColor3f(1.0, 1.0, 0.0);                  // yellow */
      glColor3f(0.0, 0.0, 1.0);
      glVertex3f(xm,ym,zm);                  // blue */
      glVertex3f(Atom[i].x,Atom[i].y,Atom[i].z);
     end;
    glEnd;
   end;
  //cyl :=  gluNewQuadric;
  //gluQuadricDrawStyle(Cyl, GLU_FILL);
  if bondseq  then
   if  Backbone then
      begin

   //   if backbone then glLineWidth(6.0) else glLineWidth(2.0);
       For I := 0 to High(Bond)do
          begin
             T1 := Bond[I].a1;
             T2 := Bond[I].a2;
              // orientation vector
             vx := Atom[T2].x-Atom[T1].x;	//	component in x-direction
             vy := Atom[T2].y-Atom[T1].y;	//	component in y-direction
             vz := Atom[T2].z-Atom[T1].z;	//	component in z-direction

              v := sqrt( vx*vx + vy*vy + vz*vz );	// cylinder length

              // rotation vector, z x r
             rx := -vy*vz;
             ry := +vx*vz;
              ax:=0.0;






              if (abs(vz) <= 1.0e-3)  then
               begin
                ax := r2d*arccos( vx/v );	// rotation angle in x-y plane
                if ( vx <= 0.0 ) then ax := -ax;
               end
              else
               begin
                ax := r2d*arccos( vz/v );	// rotation angle
                if ( vz <= 0.0 ) then ax := -ax;
               end;

              glColor3f(0.2, 0.2, 0.2);	// set cylinder color
              glPushMatrix;
              glTranslated( Atom[T1].x, Atom[T1].y, Atom[T1].z );	// translate to point 1


          if (abs(vz) < 1.0e-3) then
               begin
                 glRotated(90.0, 0.0, 1.0, 0.0);
                 glRotated(ax, -1.0, 0.0, 0.0);
               end
              else
                glRotated(ax, rx, ry, 0.0);

              DrawGLCylinder4( rb, rt, v, 100 );

     //         gluCylinder(cyl, rb, rt, v, dth, dz);
              glPopMatrix;
           end;
        end
    else

   begin
    glBegin(GL_LINES);
 //   if backbone then glLineWidth(1.0) else glLineWidth(2.0);
    For I := 0 to High(Bond)do
      begin
       T1 := Bond[I].a1;
       T2 := Bond[I].a2;
       xm := (Atom[T1].x + Atom[T2].x )/2 ;
       ym :=  (Atom[T1].y + Atom[T2].y)/2;
       zm :=  (Atom[T1].z + Atom[T2].z)/2;
       glColor3f(Atom[T1].R,Atom[T1].G,Atom[T1].B);
       glVertex3f(Atom[T1].x,Atom[T1].y,Atom[T1].z);
       glVertex3f(xm,ym,zm);
       glColor3f(Atom[T2].R,Atom[T2].G,Atom[T2].B);
       glVertex3f(xm,ym,zm);
       glVertex3f(Atom[T2].x,Atom[T2].y,Atom[T2].z);
      end;
     glEnd;
  end;


SwapBuffers(DC);
inc(Frames);
gluDeleteQuadric(Q);
//gluDeleteQuadric (Cyl);
end;



procedure TGLDraw.Button2Click(Sender: TObject);
begin
Anim := not Anim;
end;


procedure TGLDraw.SpeedButton1Click(Sender: TObject);

 const KS=3.5;
var sl:TStringList;
    i,j:integer;
    s:string;
begin
 if OpenDialog1.Execute then begin
   sl:=TStringList.Create;
   sl.LoadFromFile(OpenDialog1.FileName);
   i:=0;
   j:=1; s:=sl[i];
   i:= 16 ;
SetLength(Atom, I);
for i := 0 to High(Atom) do
 with Atom[i] do
  begin
    j:=1; s:=sl[i];
   // GetToken(s,j); GetToken(s,j);
   Atom[i].x:=StoR(GetToken(s,j))*KS;
   Atom[i].y:=StoR(GetToken(s,j))*KS;
   Atom[i].z:=StoR(GetToken(s,j))*KS;
    Atom[i].r      := Random;
   Atom[i].g      := Random;
   Atom[i].b      := Random;
   Atom[i].Speed  := 0;
   Atom[i].Radius := 1;
    inc (J);
  end;

end;
end;
procedure TGLDraw.SpeedButton2Click(Sender: TObject);

const KS=3.5;
STEPS = 32;
var sl:TStringList;
    i,j,k:integer;
  s:string;


begin
 if OpenDialog1.Execute then begin
   sl:=TStringList.Create;
   sl.LoadFromFile(OpenDialog1.FileName);
   i:=0;
    //while (copy(sl[i],1,5)<>'mol') do inc(i);
   j:=1; s:=sl[i];
   k:= StrtoInt(GetToken(s,j));
SetLength(Atom, k);
for i := 0 to High(Atom) do
 with Atom[i] do
  begin
    j:=1; s:=sl[i+1];
    GetToken(s,j);
    GetToken(s,j);
    Atom[i].x:=StoR(GetToken(s,j))*KS;
    Atom[i].y:=StoR(GetToken(s,j))*KS;
     Atom[i].z:=StoR(GetToken(s,j))*KS;
   Atom[i].r      := Random;
   Atom[i].g      := Random;
   Atom[i].b      := Random;
   Atom[i].Speed  := 0;
   Atom[i].Radius := 1;
    inc (J);


  end;
  end;

end;
procedure TGLDraw.SpeedButton3Click(Sender: TObject);
begin
 BackBone := not BackBone;
end;

procedure TGLDraw.SpeedButton4Click(Sender: TObject);
begin
 modZ := modZ + 10;
 Drawjet;
end;

procedure TGLDraw.SpeedButton5Click(Sender: TObject);
begin
    modZ := modZ - 10;
    Drawjet;
end;

procedure TGLDraw.LefMovClick(Sender: TObject);
begin
 MovRL := MovRl -  10;
 DrawJet;
end;

procedure TGLDraw.RightmovClick(Sender: TObject);
begin
 MovRL := MovRl +  10;
 Drawjet;
end;


procedure TGLDraw.SpeedButton7Click(Sender: TObject);
begin
    MovRL := MovRl +  10;
    Drawjet;
end;

procedure TGLDraw.SpeedButton10Click(Sender: TObject);
begin
   MovRL := MovRl - 10;
   Drawjet;
end;

procedure TGLDraw.SpeedButton11Click(Sender: TObject);
begin
       MovRL := MovRl + 10;
       Drawjet;
end;

procedure TGLDraw.SpeedButton8Click(Sender: TObject);
begin
 MovUD := MovUD + 10;
 Drawjet;
end;

procedure TGLDraw.SpeedButton9Click(Sender: TObject);
begin
    MovUD := MovUD - 10;
    Drawjet;
end;


procedure TGLDraw.BitBtn1Click(Sender: TObject);
begin
      BackBone := false;
      Drawjet;
      ModalResult := mrOK;
end;

procedure TGLDraw.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
   modZ := modZ + 0.5;
  Drawjet;
end;

procedure TGLDraw.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
   modZ := modZ - 0.5;
 Drawjet;
end;



procedure TGLDraw.Panel1Click(Sender: TObject);
begin
 DrawJet;
end;
procedure TGLDraw.DrawGLCylinder4(rb, rt, h: single; ns:integer );
type
 points = array of double;
var
 i,j,np,nsm,nsp, ism: integer;
 al, be, cosa,sina: single;
 x,y,z:points;

begin
 np := 2*ns;		 // total number of vertices
 al := 2*pi/ns; 	// angle increment in radians
 be := 0.0;		// initial angle
 nsm := ns-1;	// number of sides minus 1
 nsp := ns+1;	// number of sides plus 1

//	create cylinder vertices
setlength (x, np+1);
setlength (y, np+1);
setlength (z, np+1);

cosa := 0.0;
sina := 0.0;
ism :=0;
//j := 0;
for  i := 1 to ns do
 begin
  ism := i-1;
   be := ism * al;
 cosa := cos(be);
 sina := sin(be);
// bottom cylinder vertices
 x[i] := rb*cosa;
 y[i] := rb*sina;
 z[i] := 0.0;
// top cylinder vertices
	j := ns+i;
	x[j] := rt*cosa;
	y[j] := rt*sina;
	z[j] := h;
end;



// bottom face of cylinder
 glBegin(GL_POLYGON);
  glColor3f(1.0, 0.0, 0.0);	// set cylinder color
 for i := 1 to ns do
  begin
 //	xx = x[i];	yy = y[i];	zz = z[i];
	glVertex3d(x[i], y[i], z[i]);
 end;
 glEnd;

	// top face of cylinder
 glBegin(GL_POLYGON);
 for i := nsp to  np do
  begin
 //		xx = x[i];	yy = y[i]; zz = z[i];
   glVertex3d(x[i], y[i], z[i]);
  end;
 glEnd;

// side faces of cylinder
 glBegin(GL_QUAD_STRIP);
 for i := 1 to ns do
	begin
		//xx = x[i];	yy = y[i];	zz = z[i];
		glVertex3d(x[i], y[i], z[i]);
		j := ns+i;
		//xx = x[j];	yy = y[j];	zz = z[j];
		glVertex3d(x[J], y[J], z[J]);


	end;
// add final side face to GL_QUAD_STRIP
	i := 1;
	//xx = x[i];	yy = y[i];	zz = z[i];
	glVertex3d(x[i], y[i], z[i]);
	j := ns+i;
	//xx = x[j];	yy = y[j];	zz = z[j];
	glVertex3d(x[J], y[J], z[J]);
	glEnd;

//	clean up
 //	delete [] x; y = 0;
 //	delete [] y; y = 0;
 //	delete [] z; z = 0;

	
end;







end.

// Reserva
procedure TGLDraw.Button1Click(Sender: TObject);
begin
FrustumCull := not FrustumCull;
case FrustumCull of
 True  : Button1.Caption := 'Frustum Culling is on';
 False : Button1.Caption := 'Frustum Culling is off';
end;
end;

