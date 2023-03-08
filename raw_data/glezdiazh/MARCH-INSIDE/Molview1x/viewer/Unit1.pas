{========================================================================}
{=                (c) engram GmbH, Bremen   	                        =}
{========================================================================}
{=  D28199 Bremen             ===     Tel.: +0421-557090                =}
{=  Otto-Lilienthal Str. 16   ===     http:\www.engram.de               =}
{========================================================================}
{=  Authors: A.Semichastnyy, J. Skuratowski, O. Wild                    =}
{========================================================================}
{= $Date: 6/23/98 - 3:51:16 PM $                                       =}  
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, OpenGL;

type
  Vec3D=record
   case byte of
   0:(x,y,z:single);
   1:(a:array [0..2] of single);
  end;

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    alf, bet, gam :integer;
    Pt:array [0..2023] of Vec3D;
    nPts:integer;
    Face:array [0..4023] of record v:array [0..2] of integer; end;
    nFaces:integer;
    { Private declarations }
    procedure DrawScene;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

//----------------- Vector Functions ------------------------

function MulV(aVec,bVec:Vec3D):Vec3D;
begin
 result.x:=aVec.a[1]*bVec.a[2]-aVec.a[2]*bVec.a[1];
 result.y:=aVec.a[2]*bVec.a[0]-aVec.a[0]*bVec.a[2];
 result.z:=aVec.a[0]*bVec.a[1]-aVec.a[1]*bVec.a[0];
end;

function SubV(aVec,bVec:Vec3D):Vec3D;
begin
 result.x:=bVec.a[0]-aVec.a[0];
 result.y:=bVec.a[1]-aVec.a[1];
 result.z:=bVec.a[2]-aVec.a[2];
end;


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



//-------------------- Win-OpenGL Functions ----------------------

procedure setupPixelFormat(DC:HDC);
const
 pfd:TPIXELFORMATDESCRIPTOR = (
	nSize:sizeof(TPIXELFORMATDESCRIPTOR);	// size
	nVersion:1;				// version
	dwFlags:PFD_SUPPORT_OPENGL or PFD_DRAW_TO_WINDOW or
                PFD_DOUBLEBUFFER;		// support double-buffering
	iPixelType:PFD_TYPE_RGBA;			// color type
	cColorBits:16;				// prefered color depth
	cRedBits:0; cRedShift:0;		// color bits (ignored)
        cGreenBits:0;  cGreenShift:0;
        cBlueBits:0; cBlueShift:0;
        cAlphaBits:0;  cAlphaShift:0;   // no alpha buffer
        cAccumBits: 0;
        cAccumRedBits: 0;  		// no accumulation buffer,
        cAccumGreenBits: 0;             // accum bits (ignored)
        cAccumBlueBits: 0;
        cAccumAlphaBits: 0;
	cDepthBits:16;				// depth buffer
	cStencilBits:0;				// no stencil buffer
	cAuxBuffers:0;				// no auxiliary buffers
	iLayerType:PFD_MAIN_PLANE;              // main layer
        bReserved: 0;
    dwLayerMask: 0;
    dwVisibleMask: 0;
    dwDamageMask: 0;                    // no layer, visible, damage masks */
    );
var pixelFormat:integer;
begin
  pixelFormat := ChoosePixelFormat(DC, @pfd);
  if (pixelFormat = 0) then begin
	MessageBox(WindowFromDC(DC), 'ChoosePixelFormat failed.', 'Error',
		MB_ICONERROR or MB_OK);
	exit;
  end;
  if (SetPixelFormat(DC, pixelFormat, @pfd) <> TRUE) then begin
	MessageBox(WindowFromDC(DC), 'SetPixelFormat failed.', 'Error',
		MB_ICONERROR or MB_OK);
	exit;
  end;
end;

procedure GLInit;
begin
   // set viewing projection
   glMatrixMode(GL_PROJECTION);
   glFrustum(-0.1, 0.1, -0.1, 0.1, 0.1, 25.0);

   // position viewer
   glMatrixMode(GL_MODELVIEW);

   glShadeModel(GL_FLAT);
   glEnable(GL_DEPTH_TEST);
   glEnable(GL_LIGHTING);
   glEnable(GL_LIGHT0);
   //glEnable(GL_COLOR_MATERIAL);
end;


//------------------------ FORM1 ---------------------------------
procedure TForm1.FormCreate(Sender: TObject);
var DC:HDC;
    RC:HGLRC;
begin
 DC:=GetDC(Handle);
 SetupPixelFormat(DC);
 RC:=wglCreateContext(DC);
 wglMakeCurrent(DC, RC);
 GLInit;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var DC:HDC;
    RC:HGLRC;
begin
 DC := wglGetCurrentDC;
 RC := wglGetCurrentContext;
 wglMakeCurrent(0, 0);
 if (RC<>0) then wglDeleteContext(RC);
 if (DC<>0) then ReleaseDC(Handle, DC);
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
 Close;
end;

procedure TForm1.DrawScene;
const DIST=7;
var i,j:integer;
    n,a,b:Vec3D;
begin
 if nFaces>0 then begin
 glClear(
 //GL_ACCUM_BUFFER_BIT or
 GL_STENCIL_BUFFER_BIT or
 GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
 glLoadIdentity;
 glTranslatef(0.0, 0.0, -DIST);
 glRotatef(alf, 1.0, 0.0, 0.0);
 glRotatef(bet, 0.0, 1.0, 0.0);
 glRotatef(gam, 0.0, 0.0, 1.0);

    glEnable(GL_NORMALIZE);
    glBegin(GL_TRIANGLES);
    for i:=0 to nFaces-1 do with Face[i] do begin
     n:=MulV( SubV(Pt[v[1]],Pt[v[0]]), SubV(Pt[v[2]],Pt[v[0]]) );
     glNormal3f(n.x,n.y,n.z);
     for j:=0 to 2 do with Pt[v[j]] do glVertex3f( x, y, z);
    end;
    glEnd();
    glDisable(GL_NORMALIZE);
 end;   
 SwapBuffers(wglGetCurrentDC);
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
 DrawScene;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
   glViewport(0, 0, 399, 399);
end;

procedure TForm1.Open1Click(Sender: TObject);
const KS=0.025;
var sl:TStringList;
    i,j,k,vi:integer;
    s,s1:string;
begin
 if OpenDialog1.Execute then begin
   sl:=TStringList.Create;
   sl.LoadFromFile(OpenDialog1.FileName);
   i:=0;
 //while (copy(sl[i],1,8)<>'Material') do inc(i);
   while (copy(sl[i],1,8)<>'Tri-mesh') do inc(i);
   j:=1; s:=sl[i];
   GetToken(s,j);
   GetToken(s,j);
   nPts:=StrToInt(GetToken(s,j));
   GetToken(s,j);
   nFaces:=StrToInt(GetToken(s,j));
   inc(i,2); //Vertex list
   for vi:=0 to nPts-1 do begin
    j:=1; s:=sl[i];
    GetToken(s,j); GetToken(s,j); //Vertex Nr.
    GetToken(s,j); Pt[vi].x:=StoR(GetToken(s,j))*KS;
    GetToken(s,j); Pt[vi].y:=StoR(GetToken(s,j))*KS;
    GetToken(s,j); Pt[vi].z:=StoR(GetToken(s,j))*KS;
    inc(i);
   end;
   inc(i); //Face list
   for vi:=0 to nFaces-1 do begin
    j:=1; s:=sl[i];
    GetToken(s,j); GetToken(s,j); //Face Nr.
    for k:=0 to 2 do
     Face[vi].v[k]:=StrToInt(copy(GetToken(s,j),3,7));
    inc(i);
    if i<sl.Count then
      if copy(sl[i],1,9)='Smoothing' then inc(i);
   end;
   DrawScene;
 end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 inc(alf,1);
 inc(bet,2);
 inc(gam,3);
 if alf>=360 then alf:=alf mod 360;
 if bet>=360 then bet:=bet mod 360;
 if gam>=360 then gam:=gam mod 360;
 DrawScene;
end;

end.
