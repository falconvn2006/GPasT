unit janRoundedButton;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TrbsShape=(rbsRounded,rbsEllipse,rbsOctagon);

  TjanRoundedButton = class(TGraphicControl)
  private
    { Private declarations }
    FMouseOver:boolean;
    FPushDown:boolean;
    FColor: TColor;
    FGlyph: TBitmap;
    FGrayed:Tbitmap;
    FGray:boolean;
    FFlat: boolean;
    FShape: TrbsShape;
    FHotTrackColor: TColor;
    FTrackGlyph: boolean;
    procedure SetColor(const Value: TColor);
    procedure SetGlyph(const Value: TBitmap);
    procedure SetFlat(const Value: boolean);
    procedure SetShape(const Value: TrbsShape);
    procedure SetHotTrackColor(const Value: TColor);
    procedure MakeGrayed;
    procedure SetGray(const Value: boolean);
    procedure SetTrackGlyph(const Value: boolean);
  protected
    { Protected declarations }
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MouseLeave;
    procedure CMMouseEnter(var Message: TMessage); message CM_MouseEnter;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure GlyphChanged(sender:TObject);

  public
    { Public declarations }
    procedure Paint; override;
    constructor Create(AOwner:Tcomponent);override;
    destructor  Destroy; override;
  published
    { Published declarations }
    property Color:TColor read FColor write SetColor;
    Property Glyph:TBitmap read FGlyph write SetGlyph;
    property Gray:boolean read FGray write SetGray;
    property TrackGlyph:boolean read FTrackGlyph write SetTrackGlyph;
    property Flat:boolean read FFlat write SetFlat;
    property Align;
    {Determines how the control aligns within its container (parent control).}
    property Shape:TrbsShape read FShape write SetShape;
    property Font;
    {Controls the attributes of text written on the button.}
    property HotTrackColor:TColor read FHotTrackColor write SetHotTrackColor;
    property Caption;
    {Specifies a text string that identifies the control to the user.}
    property Constraints;
    {Specifies the size constraints for the control.}
    property Hint;
    {Contains the text string that can appear when the user moves the mouse over the button.}
    property ShowHint;
    {Determines whether the control displays a Help Hint when the mouse pointer rests momentarily on the control. }
    property onclick; //event
    {Occurs when the user clicks the button.}
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Fabricio', [TjanRoundedButton]);
end;




{ TjanRoundedButton }

procedure TjanRoundedButton.CMFontChanged(var Message: TMessage);
begin
  invalidate;
end;

procedure TjanRoundedButton.CMMouseEnter(var Message: TMessage);
begin
  FMouseOver := true;
  invalidate;
end;

procedure TjanRoundedButton.CMMouseLeave(var Message: TMessage);
begin
  FMouseOver := false;
  invalidate;

end;

procedure TjanRoundedButton.CMTextChanged(var Message: TMessage);
begin
  invalidate;
end;

constructor TjanRoundedButton.Create(AOwner: Tcomponent);
begin
  inherited;
  width:=81;
  height:=33;
  FPushDown := false;
  FMouseOver := false;
  FColor:=clsilver;
  FHotTrackColor:=clblue;
  FFlat := true;
  Fshape:=rbsRounded;
  FGlyph:=TBitmap.create;
  FGrayed:=TBitmap.create;
  FGlyph.onchange:=Glyphchanged;
  FGray:=true;
  FTrackGlyph:=true;
end;

destructor TjanRoundedButton.Destroy;
begin
  FGlyph.free;
  FGrayed.free;
  inherited;

end;

procedure TjanRoundedButton.GlyphChanged(sender: TObject);
begin
  invalidate;
end;

procedure TjanRoundedButton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FPushDown:=true;
  invalidate;
  inherited;

end;

procedure TjanRoundedButton.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FPushDown:=false;
  invalidate;
  inherited;

end;


procedure TjanRoundedButton.Paint;
var
   rgn :Hrgn;
   tlpoly,brpoly: array[0..2] of TPoint;
   clippoly,poly:array[0..7] of TPoint;
   i:integer;
   cr,xw,yh:integer;
   R,RCap:Trect;
   hiColor,loColor:Tcolor;
   dx,dy:integer;
   x4:integer;
   bm:TBitmap;

  procedure drawcaption;
  begin
    if FGlyph<>nil then
    begin
      if FGray then
        bm:=FGrayed
      else
        bm:=Fglyph;
      if Fmouseover and FTrackGlyph then
        bm:=FGlyph;
      case FShape of
      rbsRounded:
        rgn:=CreateRoundRectRgn(left+1,top+1,left+xw-1,top+yh-1,cr,cr);
      rbsEllipse:
        rgn:=CreateEllipticRgn(left+1,top+1,left+xw-1,top+yh-1);
      rbsOctagon:
        rgn :=  CreatePolygonRgn(clippoly,8,WINDING);
      end;
      SelectClipRgn(Canvas.handle,rgn);
      bm.transparent:=true;
      dx:=(width-bm.width) div 2;
      dy:=(height-bm.height) div 2;
      if FPushDown then
       canvas.Draw (dx+2,dy+1,bm)
      else
       canvas.Draw (dx+1,dy,bm);
      SelectClipRgn(Canvas.handle,0);
      DeleteObject(rgn);
    end;
    canvas.brush.style := bsclear;
    if (Fmouseover) and (not FPushDown) then
      canvas.font.color := FHotTrackColor
    else
      canvas.font.color := Font.color;
    DrawText(canvas.handle, @Caption[1], -1, Rcap, DT_SINGLELINE or DT_VCENTER or DT_CENTER or DT_END_ELLIPSIS);
  end;

  procedure drawframe;
  begin
   rgn :=  CreatePolygonRgn(tlpoly,3,WINDING);
   SelectClipRgn(Canvas.handle,rgn);
   with canvas do
   begin
     brush.color:=FColor;
     pen.color:=hiColor;
     case Fshape of
     rbsRounded:
       RoundRect(0,0,xw,yh,cr,cr);
     rbsEllipse:
       Ellipse(0,0,xw,yh);
     rbsoctagon:
       Polygon(poly)
     end;
   end;
   SelectClipRgn(Canvas.handle,0);
   DeleteObject(rgn);
   rgn :=  CreatePolygonRgn(brpoly,3,WINDING);
   SelectClipRgn(Canvas.handle,rgn);
   with canvas do
   begin
     brush.color:=FColor;
     pen.color:=loColor;
     case Fshape of
     rbsRounded:
       RoundRect(0,0,xw,yh,cr,cr);
     rbsEllipse:
       Ellipse(0,0,xw,yh);
     rbsoctagon:
       Polygon(poly)
     end;
   end;
   SelectClipRgn(Canvas.handle,0);
   DeleteObject(rgn);
  end;

begin
  canvas.font.Assign(Font);
  canvas.brush.style:=bssolid;
  R := Rect(0, 0, width, height);
  Rcap := Rect(0, 0, width-1, height-1);
  if FPushDown then
  begin
    RCap.left := Rcap.left + 1;
    RCap.top := RCap.top + 1;
    RCap.Right := RCap.right + 1;
    RCap.Bottom := Rcap.Bottom + 1;
  end;
   xw:=width-1;
   yh:=height-1;
   cr:=width div 4;
   x4:=width div 4;
   // octagon shape
   case FShape of
     rbsOctagon:
     begin
       poly[0]:=point(x4,0);
       poly[1]:=point(xw-x4,0);
       poly[2]:=point(xw-1,x4);
       poly[3]:=point(xw-1,yh-x4);
       poly[4]:=point(xw-x4,yh-1);
       poly[5]:=point(x4,yh-1);
       poly[6]:=point(0,yh-x4);
       poly[7]:=point(0,x4);
       clippoly[0]:=point(left+x4,top+1);
       clippoly[1]:=point(left+xw-x4,top+1);
       clippoly[2]:=point(left+xw-2,top+x4);
       clippoly[3]:=point(left+xw-2,top+yh-x4);
       clippoly[4]:=point(left+xw-x4,top+yh-2);
       clippoly[5]:=point(left+x4,top+yh-2);
       clippoly[6]:=point(left+1,top+yh-x4);
       clippoly[7]:=point(left+1,top+x4);
     end
   end;
   // topleft region
   tlpoly[0]:=point(left,top+yh);
   tlpoly[1]:=point(left,top);
   tlpoly[2]:=point(left+xw,top);
   // bottom right region
   brpoly[0]:=point(left+xw,top);
   brpoly[1]:=point(left+xw,top+yh);
   brpoly[2]:=point(left,top+yh);
   canvas.pen.style:=pssolid;
  if (csDesigning in ComponentState) then
  begin
    hiColor:=clwhite;
    locolor:=clblack;
    drawframe;
    drawcaption;
  end
  else if FPushDown then
  begin // depressed button
    hiColor:=clblack;
    locolor:=clwhite;
    drawframe;
    drawcaption;
  end
  else if FMouseOver or (not FFlat) then
  begin // raised button with normal caption
    hiColor:=clwhite;
    locolor:=clblack;
    drawframe;
    drawcaption;
  end
  else
  begin // flat button with normal caption
    canvas.pen.style:=psclear;
    hiColor:=clwhite;
    locolor:=clblack;
    drawframe;
    drawcaption;
  end;
end;

procedure TjanRoundedButton.SetColor(const Value: TColor);
begin
  if value <> FColor then
  begin
    FColor := Value;
    invalidate;
  end;
end;

procedure TjanRoundedButton.SetFlat(const Value: boolean);
begin
  FFlat := Value;
end;

procedure TjanRoundedButton.SetGlyph(const Value: TBitmap);
begin
  FGlyph.assign(Value);
  if FGlyph<>nil then
  begin
    FGlyph.transparent:=true;
    MakeGrayed;
  end
end;

procedure TjanRoundedButton.MakeGrayed;
var g,x,y,w,h:integer;
    p1,p2:Pbytearray;
begin
  w:=FGlyph.width;
  h:=FGlyph.height;
  FGrayed.width:=w;
  FGrayed.height:=h;
  FGlyph.PixelFormat:=pf24bit;
  FGrayed.PixelFormat :=pf24bit;
  for y:=0 to h-1 do
  begin
    p1:=FGlyph.ScanLine [y];
    p2:=FGrayed.ScanLine [y];
    for x:=0 to w-1 do
    begin
      g:=(p1[x*3]+p1[x*3+1]+p1[x*3+2]) div 3;
      p2[x*3]:=g;
      p2[x*3+1]:=g;
      p2[x*3+2]:=g;
    end;
  end;
end;

procedure TjanRoundedButton.SetHotTrackColor(const Value: TColor);
begin
  FHotTrackColor := Value;
end;

procedure TjanRoundedButton.SetShape(const Value: TrbsShape);
begin
  FShape := Value;
  invalidate;
end;

procedure TjanRoundedButton.SetGray(const Value: boolean);
begin
  if FGray<>value then
  begin
   FGray := Value;
   invalidate;
  end;
end;

procedure TjanRoundedButton.SetTrackGlyph(const Value: boolean);
begin
  if FTrackGlyph<>value then
  begin
    FTrackGlyph := Value;
    if FTrackGlyph then
      Gray:=true;
  end;
end;

procedure TjanRoundedButton.Loaded;
begin
  inherited;
  if FGlyph<>nil then
  begin
    MakeGrayed;
    invalidate;
  end;
end;

end.
