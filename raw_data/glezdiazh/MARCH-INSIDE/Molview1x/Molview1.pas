unit Molview1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TFrustumClass, dglOpenGL, ExtCtrls, AppEvnts, StdCtrls, Buttons,
  ComCtrls, DBCtrls, ToolWin;

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
    SpeedButton2: TSpeedButton;
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
    procedure SetProtDraw(aAtom : AtomRecord; bonds: BondRecord);
    procedure DrawJet;
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
  Atom      : AtomRecord;
  Frames      : Integer;
  bondseq, FrustumCull : Boolean;
  Anim        : Boolean;
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



procedure CylinderT(sTex,tTex:glFloat);
var
  around: integer;
  s36: GLfloat;
  CircleX, CircleY:Array[0..35] of Single;
begin
  S36 := sTex/36.0;
  glBegin(GL_TRIANGLE_STRIP);
    for around := 0 to 35 do
    begin
      CircleX[around]:=100+ 2*around+35;
      CircleY[Around]:= 100+ 3.5*around+4;
      glTexCoord2f(around*s36,tTex);
      glVertex3f(circleX[around],circleY[around],-0.4);
      glTexCoord2f(around*s36,0.0);
      glVertex3f(circleX[around],circleY[around],+0.4);
    end; {for}
    glTexCoord2f(sTex,tTex);
    glVertex3f(circleX[0],circleY[0],-0.4);
    glTexCoord2f(sTex,0.0);
    glVertex3f(circleX[0],circleY[0],+0.4);
  glEnd;
end;


procedure TGLDraw.FormCreate(Sender: TObject);
const
 light0_position:array [0..3] of GLfloat=( 4.0, 4.0, 4.0, 0.0);
  specular: array [0..3] of GLfloat=( 1.0, 1.0, 0.0, 1.0);
  diffuse:  array [0..3] of GLfloat=( 1.0, 1.0, 1.0, 0.7);
begin
FrustumCull := True;
Anim        := True;
modZ := 0.0;
MovRL:=0.0;
MovUD := 0.0;
panel1.OnMouseDown:=GLMouseDown;
panel1.OnMouseMove:=GLMouseMove;
panel1.OnMouseUp:=GLMouseUp;
InitOpenGL;
DC := GetDC(Panel1.Handle);
RC := CreateRenderingContext(DC, [opDoubleBuffered], 32, 24, 0, 0, 0, 0);
ActivateRenderingContext(DC, RC);
//glClearColor(0,1,0,0);
glClearColor(0.0,0.1,0.0,0.4);
//Lichtquelle
    glLightfv(GL_LIGHT0, GL_POSITION, @light0_position);
    glLightfv(GL_LIGHT0, GL_DIFFUSE,  @diffuse);
    glLightfv(GL_LIGHT0, GL_SPECULAR, @specular);
 glEnable(GL_NORMALIZE);
 glEnable(GL_LIGHTING);
 glEnable( GL_LIGHT0 );
 glEnable(GL_DEPTH_TEST);
 drawJet;
end;

procedure TGLDraw.FormDestroy(Sender: TObject);
begin
DeactivateRenderingContext;
DestroyRenderingContext(RC);
ReleaseDC(Handle, DC);
end;

procedure  TGLDraw.FormPaint(Sender: TObject);
begin
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
   Label1.Caption:=Format('move: %d, %d',[X,Y]);
   dx:=(x-mStartX)/2;
   dy:=(y-mStartY)/2;
  DrawJet;
 end;
end;

procedure TGLDraw.SetProtDraw(aAtom : AtomRecord; bonds: BondRecord);
var
 I : Integer;
begin
 I:= High(aAtom);
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
end;
procedure TGLDraw.DrawJet;
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
    glColor3f(0.3, 0.3, 0.3);
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

{procedure TGLDraw.ApplicationEvents1Idle(Sender: TObject;  var Done: Boolean);
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
glMaterialfv(GL_FRONT, GL_SHININESS,@ambient);


if Length(Atom) = 0 then
 exit;
Done := False;

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
    glColor3f(0.0, 0.0, 2.0);
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
 }




procedure TGLDraw.Button2Click(Sender: TObject);
begin
Anim := not Anim;
end;


procedure TGLDraw.SpeedButton1Click(Sender: TObject);

 const KS=3.5;
var sl:TStringList;
    i,j,k,vi:integer;
    s,s1:string;
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
    i,j,k,vi:integer;
  s,s1:string;


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
var
astring: string[7];
angle:double;
begin
 astring := InputBox('Angle of Rotation','float:','0.0');
 angle := StrToFloat(astring);
 glMatrixMode(GL_MODELVIEW);
 glLoadIdentity;

glRotatef(angle,1,1,0);

end;

procedure TGLDraw.SpeedButton4Click(Sender: TObject);
begin
 modZ := modZ + 10;
end;

procedure TGLDraw.SpeedButton5Click(Sender: TObject);
begin
    modZ := modZ - 10;
end;

procedure TGLDraw.LefMovClick(Sender: TObject);
begin
 MovRL := MovRl -  10;
end;

procedure TGLDraw.RightmovClick(Sender: TObject);
begin
 MovRL := MovRl +  10;
end;


procedure TGLDraw.SpeedButton7Click(Sender: TObject);
begin
    MovRL := MovRl +  10;
end;

procedure TGLDraw.SpeedButton10Click(Sender: TObject);
begin
   MovRL := MovRl - 10;
       DrawJet;
end;

procedure TGLDraw.SpeedButton11Click(Sender: TObject);
begin
       MovRL := MovRl + 10;
           DrawJet;
end;

procedure TGLDraw.SpeedButton8Click(Sender: TObject);
begin
 MovUD := MovUD + 10;
     DrawJet;
end;

procedure TGLDraw.SpeedButton9Click(Sender: TObject);
begin
    MovUD := MovUD - 10;
    DrawJet;
end;


procedure TGLDraw.BitBtn1Click(Sender: TObject);
begin
      ModalResult := mrOK;
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

