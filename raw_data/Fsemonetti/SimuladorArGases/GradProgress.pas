{ 
j.w.strikkers@hccnet.nl
25/10/98 Original version
28/10/98 1.2.0
         fixed Stepit
         added percent 
         added backcolor
29/12/98 V 1.2.1 
         small changes
06/03/99 V 1.2.2 
         small changes on request
         Bevel none added
         paintbevel changed
         vertical added
         perc rotated in vertical
15/03/99 V 1.2.3 
         Fonttype test when vertical (if ness. changed to Arial.)
         
Johan W. Strikkers
}

unit GradProgress;

{$MODE Delphi}


interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Extctrls, StdCtrls, Interfaces;

type
  TBevelWidth = 1..10;
  TBevelStyleExt = ( bsLowered, bsRaised, bsNone );
  TStyle = (gsVertical,gsHorizontal);

  TGradProgress = class(TGraphicControl)
  private
    { Private declarations }
    BM : TBitmap;
    Fr,FG,FB: integer;
    DR,DG,DB: integer;
    FBevelStyle: TBevelStyleExt;
    FBevelWidth: TBevelWidth;
    FStartColor: TColor;
    FEndColor: TColor;
    FBackColor: TColor;
    FPosition: integer;
    FMaxValue: integer;
    FStep: integer;
    FShowPercent: boolean;
    FStyle: TStyle;
    InstalledFonts: TStringList;
    procedure SetStyle(val : TStyle);
    procedure SetBevelStyle(val: TBevelStyleExt);
    procedure SetBevelWidth(val: TBevelWidth);
    procedure SetStartColor(val: TColor);
    procedure SetEndColor(val: TColor);
    procedure SetPosition(val: integer);
    procedure SetMaxValue(val: integer);
    procedure SetStep(val: integer);
    procedure SetShowPercent(val: boolean);
    procedure SetBackColor(val: TColor);
    procedure PaintBevel;
    procedure CalculateDColor;
    procedure VerticalText(Perc: string; R: Trect);
    procedure GetFontNames;
  protected                          
    { Protected declarations }
    procedure paint; override;
  public
    { Public declarations }
    constructor create(Aowner: TComponent); override;
    destructor destroy; override;
  published
    { Published declarations }
    property Align;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Visible;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;

    property Style: TStyle read FStyle write SetStyle;
    property BevelStyle: TBevelStyleExt read FBevelStyle write SetBevelStyle;
    property BevelWidth: TBevelWidth read FBevelWidth write SetBevelWidth;
    property StartColor: TColor read FStartColor write SetStartColor;
    property EndColor: TColor read FEndColor write SetEndColor;
    property Position: integer read FPosition write SetPosition;
    property MaxValue: integer read FMaxValue write SetMaxValue;
    property Step: integer read FStep write SetStep;
    property ShowPercent: boolean read FShowPercent write SetShowPercent;
    property BackColor: TColor read FBackColor write SetBackColor;
    procedure Stepit;
  end;

procedure Register;

implementation


constructor TGradProgress.create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Width        := 150;
  Height       := 16;
  Font.Size    := 8;
  Font.Name    := 'Default';
  Font.Color   := clWhite;
  Font.Style   := [];
  FBevelStyle  := bsLowered;
  FBevelWidth  := 1;
  FStartColor  := clBlue;
  FEndColor    := clRed;
  FBackColor   := clBtnFace;
  FStyle       := gsHorizontal;
  FPosition    := 0;
  FMaxValue    := 100;
  FShowPercent := True;
  FStep        := 1;
  BM           := TBitmap.Create;
  CalculateDColor;
  InstalledFonts    := TStringList.Create;
  GetFontNames;
end;

destructor TGradProgress.destroy;
begin
  bm.Free;
  InstalledFonts.Free;
  inherited;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  if fontType = TRUETYPE_FONTTYPE then
  TStrings(Data).Add(LogFont.lfFaceName);
  Result := 1;
end;

procedure TGradProgress.GetFontNames;
var
  DC: HDC;
begin
 // DC := GetDC(0);
 // if assigned(InstalledFonts) then
//  EnumFonts(DC, nil, @EnumFontsProc, Pointer(InstalledFonts));
//  ReleaseDC(0, DC);
//  InstalledFonts.Sorted := True;
end;

procedure TGradProgress.SetShowPercent(val: boolean);
begin
  if val <> FShowPercent then begin
    FShowPercent := val;
    repaint;
  end;  
end;

procedure TGradProgress.Stepit;
begin
  SetPosition(FPosition + FStep);
end;

procedure TGradProgress.SetStep(Val: integer);
begin
  if Val <> FStep then FStep := val;
end;

procedure TGradProgress.SetStyle;
begin
  if val <> FStyle then begin
    FStyle := val;
    Repaint;
  end;  
end;

procedure TGradProgress.SetBevelStyle(Val: TBevelStyleExt);
begin
  if val <> FBevelStyle then begin
    FBevelStyle := Val;
    repaint;
  end;  
end;

procedure TGradProgress.SetBevelWidth(Val: TBevelWidth);
begin
  if val <> FBevelWidth then begin
    if ((val * 2) <= (Height-4)) and                     //To keep something left
       ((val * 2) <= (Width-4)) then FBevelWidth := Val; //for the bar
    repaint;                                            
  end;  
end;

procedure TGradProgress.CalculateDColor;
begin
  FR := FStartColor  and $000000FF;  
  FG := (FStartColor shr 8) and $000000FF;
  FB := (FStartColor shr 16) and $000000FF;
  DR := (FEndColor   and $000000FF) - FR;   
  DG := ((FEndColor  shr 8) and $000000FF) - FG;
  DB := ((FEndColor  shr 16) and $000000FF) - FB;
end;

procedure TGradProgress.SetStartColor(Val: TColor);
begin
  if FStartColor <> Val then begin
    FStartColor := val;
    CalculateDColor;
    repaint;
  end;
end;

procedure TGradProgress.SetEndColor(Val: TColor);
begin
  if FEndColor <> Val then begin
    FEndColor := val;
    CalculateDColor;
    repaint;
  end;  
end;

procedure TGradProgress.SetBackColor;
begin
  if FBackColor <> Val then begin
    FBackColor := val;
    repaint;
  end;  
end;

procedure TGradProgress.SetPosition(Val: integer);
begin
  if (Fposition <> Val) and (Val >= 0) then 
  begin    
    if Val > FMaxValue then Val := FMaxValue;
    FPosition := Val;
    if (csDesigning in ComponentState) then repaint
    else paint;
  end;  
end;

procedure TGradProgress.SetMaxValue(Val: integer);
begin
  if Val <> FMaxValue then begin
    FMaxValue := Val;
    if Fposition > FMaxValue then FPosition := FMaxValue;
    Repaint;
  end;  
end;

procedure TGradProgress.paint;
var str: string;
    Rect : Trect;
    x:integer;
    Step: integer;
    FPos:integer;
    Ro,Gr,Bl: Byte;
begin     
  PaintBevel;
  if FBevelStyle = bsNone then begin
    Rect.TopLeft := Point(1,1);
    Rect.BottomRight := Point(Width-1,Height-1);
  end else begin
    Rect.TopLeft := Point(FBevelWidth,FBevelWidth);
    Rect.BottomRight := Point(Width-FBevelWidth,Height-FBevelWidth);
  end;
  if FStyle = gsVertical then
    FPos := MulDiv(FPosition, Height, FMaxValue)
  else FPos := MulDiv(FPosition, Width, FMaxValue);
  with BM.Canvas do begin
    BM.Width  := Rect.Right;
    BM.Height := Rect.Bottom;
    Pen.Style := psSolid;
    Pen.Width := 0;
    for x := 0 to FPos do begin  
      Step := MulDiv(255,x,FPos);
      Ro   := fr + MulDiv(Step, dr, 255);
      Gr   := fg + MulDiv(Step, dg, 255);
      Bl   := fb + MulDiv(Step, db, 255);
      Pen.Color := RGB(Ro, Gr, Bl);
      if FStyle = gsVertical then begin
        MoveTo(Rect.left, abs(x-Height));
        LineTo(Rect.Right,abs(x-Height));
      end else begin
        MoveTo(x, Rect.top);
        LineTo(x, Rect.bottom);
      end; 
    end;
    Brush.Color := FBackColor;
    Pen.color := FBackColor;
    if FStyle = gsVertical then 
      rectangle(Rect.Left,Rect.Top,Rect.Right,Abs(FPos-Height))
    else rectangle(Fpos,Rect.Top,Width,Height);
    Brush.Style := Bsclear;
  end;
  if FShowPercent then begin
    With BM.Canvas.Font do begin
    Color := font.color;
    Size  := Font.Size;
    Style := Font.Style;
    Name  := Font.Name;
    end;
    if FStyle = gsVertical then begin
      str := Inttostr(muldiv(FPos, 100, Height)) + '%';
      VerticalText(str, Rect);
    end else begin
      str := Inttostr(muldiv(FPos, 100, width)) + '%';
      Drawtext(bm.Canvas.Handle, Pchar(str), Length(str),
               Rect, Dt_Center Or Dt_Vcenter Or Dt_Singleline);
    end;           
  end;
  Canvas.CopyRect(rect,BM.Canvas,rect);
end;

procedure TGradProgress.VerticalText(Perc: string; R: TRect);
var LFont             : TLogFont;
    hOldFont, hNewFont: HFont;
    DC: HDC;
    Size: TSize;
    OldName: string;
begin  
  //Must be TrueType when vertical
  OldName := BM.Canvas.Font.Name;
  if InstalledFonts.IndexOf(OldName) = -1 then 
  BM.Canvas.Font.Name := InstalledFonts[0]; //'Arial';
  DC := GetDC(0);
  GetTextExtentPoint32(DC,PChar(Perc),Length(Perc),Size);
  ReleaseDC(0,DC);
  With BM.Canvas do begin
    if Size.cx > (Width - 6 - 2*FBevelWidth) then begin 
      GetObject(Font.Handle,SizeOf(LFont),Addr(LFont));
      LFont.lfEscapement := 270*10; 
      hNewFont := CreateFontIndirect(LFont);
      hOldFont := SelectObject(Handle,hNewFont);
      R.Left := round((Width+size.cy-3)/2);
      R.Top := Round((Height-size.cx+3)/2);
      TextOut(R.Left,R.Top,Perc);
      hNewFont := SelectObject(Handle,hOldFont);
      DeleteObject(hNewFont);
    end else begin
      BM.Canvas.Font.Name := OldName;
      Drawtext(bm.Canvas.Handle, Pchar(Perc), Length(Perc),
               R, Dt_Center Or Dt_Vcenter Or Dt_Singleline);
    end;         
  end;  
  BM.Canvas.Font.Name := OldName;
end;

procedure TGradProgress.PaintBevel;
var Edge: Word;
    R: TRect;
    Ix : integer;
begin
  Case FBevelStyle of
    bsRaised:  Edge := BDR_RAISEDINNER;
    bsLowered,
    bsNone:    Edge := BDR_SUNKENOUTER;
  end;
  if FBevelStyle = bsNone then begin
    if (csDesigning in componentstate) then begin
    R := Rect(0,0,Width,Height);
    DrawEdge(Canvas.Handle,R,Edge,BF_RECT or BF_MONO);
    end;
  end else begin
    for Ix := 0 to FBevelWidth - 1 do begin
      R := Rect(0+Ix,0+Ix,width-Ix,height-Ix);
      DrawEdge(Canvas.Handle,R,Edge,BF_RECT);
    end;
  end;
end;

procedure Register;
begin
  RegisterComponents('Fabricio', [TGradProgress]);
end;

end.
