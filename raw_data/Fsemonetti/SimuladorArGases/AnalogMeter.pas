{ Written 1999 by Hannes Breuer (Hannes.Breuer@Talknet.de),
               inspired by Andrey Abakumov (aga@novoch.ru)

  Version 2.12 : 28. October 2004
        Changes by Eduardo Mantovani:
        Added a new property: ValueVertAdj, which has the
        same funcionality as CaptionVertAdj but works on the Value text.
        This fixes a cut-off problem with large fonts.
        
  Version 2.11 : 10. September 2003
	Changes by TyBreizh29 (TyBreizh29@yahoo.co.uk)
                and Marc le Meur (marc.lemeur@temex.fr):
        Changed consistency-check in SetMin(): Max gets changed if necessary, not the value for min!
        Some errorchecking added to AngleOf()
	TransparentZones : to draw the background with the gauge outline
        BackGroundTop & BackGroundLeft : to move the bitmap inside the gauge

        Changes by hannes:
        Did equivalent change to consistency-check of SetMax().
        Some errorchecking added to LogAngleOf()
        Fixed drawing the background at correct position:
              1. uncovered area is drawn in Self.Color
              2. forced redraw if BackGroundLeft/Right changed by adding setter-methods
        Fixed drawing of transparent zones: Borders of zones get shown now

  Version 2.10 : 01. August 2002
          Changes by Kermit (r.neumann@cityweb.de):
          Added property LogScale.    (enables logarithmic Scale)
          Added property TickValAbbr. (enables scientific Abbreviations (k,M))

  Version 2.09 : 18. August 2001
          Added property Background.
          ShowBackground toggles display of this bitmap or the standard single-
          colour background.

  Version 2.08 : 11. July 2001
          Changes by BIGMIKE (mike@bigmike.it):
          Added LowZoneValue and HighZoneValue properties. Now Low and High zones
          can be set by % (with LowZone and HighZone) or by number (LowZoneValue and
          HighZoneValue), where: Min <= number <= Max
          BugFix: Old SetHighZone had a bug when setting HighZone < LowZone
          Added CaptionPosition and CaptionVertAdj properties.

  Version 2.07 : 11.July 2000
          Changes by Peter Ingham:
          Separate Digits and Precision properties for Value and Ticks.
          Fixed SetLowZone and SetHighZone to avoid problems caused by incorrect
          calculation of the old zone position based on the new limit.
          Replaced several calls to DrawOuter,DrawInner, Paint with call to ForceRedraw.
          Used ForceRedraw in a few cases where only partial update was being done (which
          left artifacts behind).
          More small changes : Some properties are now Byte, not LongInt

  Version 2.06 : 8.May 2000
          Properties ShowRegions, KnobSize and NeedleWidth added. Thanks to Franky
          for the suggestions and code.

  Version 2.05 : 14.Apr.2000
          Property Color now changed such that it updates immediately on change.
          Thanks to Shlomo for that one.
          Value, Min, Max changed to Single, not LongInt. Thanks to Jim and Raimar
          for the suggestion.
          Tick-values are now spaced really nicely, thanks to Jim Cambel. He also
          introduced the Precision and Digits properties.

  Version 2.04 : 13.Mar.2000
          Added public procedure ForceRedraw, to allow updating the meter if
          an inherited property like color gets changed. Thanks to Henry for
          the bugreport.
          Added values at the ticks: Property ShowTicksScale. Useful if the meter
          is big enough. Thanks to Raimar for the suggestions.

  Version 2.03 : 17.Jan.2000
          Changed the comments such that the F1help-compiler can compile a
          HLP-file for it. Added that helpfile, of course.
          See www.geocities.com/SiliconValley/Vista/5524/f1help.html for the
          latest version of this really excellent tool.

  Version 2.02 : 1.Nov.1999 (November the first)
          Derived it from TCustomControl and moved WMSize to protected part,
          now WM_SIZE arrives correctly

  Version 2.01 : 6.Oct.1999
          Split DrawFace into DrawOuterFace and DrawInnerFace for speed.
          Cleaned up uses-clause

  Version 2.0 : 1.Oct.1999
          First release version, never mind the private version's history...


  Licensing: Use however you want.
  Please tell me where you use it (location and use of program).
  If you fix bugs or add nifty features, please let me know.
  If you earn money with it, please mention me.
  Visit my homepage for the latest version: www.talknet.de/~hannes.breuer/

  I WILL NOT ASSUME ANY RESPONSIBILITY WHATSOEVER FOR ANY DAMAGES RESULTING
  FROM THE USE/MISUSE OF THIS UNIT. Use at your own risk.
}
unit AnalogMeter;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls;

type
  TCaptionPos = (cpTop,cpBottom);
  {Position of the caption relative to the center knob}

  TAnalogMeter = class(TCustomControl)
  {Component to show Single-Values in a VDO-meter like display}
  private
    //purely internal stuff:
    fTemp : TBitmap;        //these three are needed to create the transparent effect
    fMask : TBitmap;        // when drawing onto a background image
    fInvMask : TBitmap;
    fBitmap : TBitMap;
    fZeroAngle     : Single;  //depends on AngularRange, counted Clockwise from straight down, in Degrees
    fCentrePoint   : TPoint;  //gets shifted according to size and Angular range
    fOuterHalfAxes,
    fInnerHalfAxes : TPoint;  //dimensions of ellipses
    fFrameWidth : LongInt;    //adjusted according to size
    fTxtHeight     : LongInt; //gets set in Paint according to Font
    fOldValue : Single;       //needed to XOR over old display
    //events:
    FonResize : TNotifyEvent;
    FonChange : TNotifyEvent;
    FonRiseAboveHigh : TNotifyEvent;
    FonFallBelowHigh : TNotifyEvent;
    FonRiseAboveLow : TNotifyEvent;
    FonFallBelowLow : TNotifyEvent;
    fEnableZoneEvents : Boolean;   //allow switching them off wholesale
    //variables for properties:
    fBackGround : TBitmap;
    fShowBackground : Boolean;
    fBackGroundTop : integer;
    fBackGroundLeft : integer;
    fColor : TColor;
    fCaption : String;
    fCaptionPos : TCaptionPos;
    fCaptionVAdj : Shortint;
    fValueVAdj : Shortint;        // ajuste vertical do texto do valor
    fMin, fMax, fValue : Single;  //just like TSpinEdit
    fAngularRange : LongInt;      //portion of circle to be used for display, 10..360 (degrees)
    fTickCount : Byte;            //how many should be shown (including first & last)
    fLowZone,
    fHighZone : Single;           //real values, Set/Get work with percentage
    fShowZones,
    fShowFrame,
    fShowTicks,
    fShowTicksScale,
    fShowValue,
    fAbbrTickVals,                 //enables abbreviations (k, M) in tick-values
    fLogScale : Boolean;           //enables logarithmic scale
    fTickPrecision, fTickDigits : Byte;
    fValuePrecision, fValueDigits : Byte;
    fTickColor,
    fHighZoneColor,
    fLowZoneColor,
    fOKZoneColor : TColor;
    fTransparentZones : Boolean;
    fNeedleWidth,
    fKnobSize : Byte;
    Procedure SetShowZones(s : Boolean);
    Procedure SetKnobSize(s : Byte);
    Procedure SetNeedleWidth(w : Byte);
    Procedure SetColor(C : TColor);
    Procedure SetCaption(s : String);
    procedure SetCaptionPosition(P : TCaptionPos);
    Procedure SetCaptionVAdj(V : Shortint);
    Procedure SetValueVAdj(V : Shortint);
    Procedure SetMin(m : Single);
    Procedure SetMax(m : Single);
    Procedure SetValue(v : Single);
    Procedure SetTickPrecision(v : Byte);
    Procedure SetTickDigits(v : Byte);
    Procedure SetValuePrecision(v : Byte);
    Procedure SetValueDigits(v : Byte);
    Procedure SetAngularRange(r : LongInt);
    Procedure SetTickCount(t : Byte);
    Procedure SetLogScale(b : Boolean);
    Procedure SetAbbrTick(b : Boolean);
    Procedure SetLowZone(percent : Byte);
    Function GetLowZone : Byte;
    Procedure SetHighZone(percent : Byte);
    Function GetHighZone : Byte;
    Procedure SetShowValue(b : Boolean);
    Procedure SetHighZoneColor(c : TColor);
    Procedure SetLowZoneColor(c : TColor);
    Procedure SetOKZoneColor(c : TColor);
    Procedure SetTickColor(c : TColor);
    Procedure SetShowTicks(b : Boolean);
    Procedure SetShowTicksScale(b : Boolean);
    Procedure SetShowFrame(b : Boolean);
    Procedure SetFont(F : TFont);
    Function GetFont : TFont;
    procedure SetLowZoneValue(AValue:Single);
    procedure SetHighZoneValue(AValue:Single);
    procedure SetBackground(const Value: TBitmap);
    procedure SetShowBackgound(const Value: Boolean);
    procedure SetBackGroundLeft(v : Integer);
    procedure SetBackGroundTop(v : Integer);
    procedure SetTransparentZones(const Value: Boolean);
    //drawing routines:
    Function AbbreviateTickString(TickValue : Single) : String;
    Function NormalTickString(TickValue : Single) : String;
    Function AngleOf(v : Single) : Single; //calcs angle corresponding to value v
    Function LogAngleOf(v : Single) : Single; //calcs angle corresponding to value v
    Procedure OptimizeSizes; //according to dimensions and angular range
    Procedure ClearCanvas;
    Procedure DrawFrame;
    Procedure DrawZones;
    Procedure ClearInnerFace;
    Procedure DrawTicks;
    Procedure DrawTicksScale;
    Procedure DrawCaption;
    Procedure DrawPointer;
    Procedure DrawValue;
    Procedure DeleteOldValue;
    Procedure DrawOuterFace; //onto Bitmap in background
    Procedure DrawInnerFace; //onto Bitmap in background
  protected
    Procedure WMSize(var Message : TWMSize); message WM_SIZE;
    Procedure Paint; override; //BitBlt Background-Bitmap onto canvas
  public
    //The usual Constructor. Also creates the background bitmap which gets
    //BitBlt onto the Canvas
    constructor Create(AOwner: TComponent); override;
    //Frees the background bitmap, too
    destructor Destroy; override;
    //Call this procedure to force the Meter to redraw itself in case it didn't do so correctly
    procedure ForceRedraw;
  published
    //You can set a background. 
    //See also: ShowBackground, BackGroundLeft, BackGroundTop
    property BackGround : TBitmap read fBackGround write SetBackground;
    //Determines wheteher the background is the Bitmap set in Background
    //or if Color is used
    //See also: BackGround, BackGroundLeft, BackGroundTop
    property ShowBackground : Boolean read fShowBackground write SetShowBackgound;
    //You can move the background-bitmap.
    //See also: BackGroundLeft, BackGround, ShowBackGround
    property BackGroundTop : integer read fBackGroundTop write SetBackGroundTop;
    //You can move the background-bitmap.
    //See also: BackGroundTop, BackGround, ShowBackGround
    property BackGroundLeft : integer read fBackGroundLeft write SetBackGroundLeft;
    //The caption appears inside the face above or below the pointer's origin.
    //See also CaptionPosition, CaptionVertAdj, Font, ShowValue
    property Caption : String read fCaption write SetCaption;
    // Position of the caption relative to the center knob: above or below
    // See also: Caption, CaptionVertAdj
    property CaptionPosition : TCaptionPos read fCaptionPos write SetCaptionPosition default cpTop;
    // Vertical position of the caption fine tuning. Range: -30..+30
    // See also: Caption, CaptionPosition
    property CaptionVertAdj : Shortint read fCaptionVAdj write SetCaptionVAdj default 0;
    // Vertical position of the value fine tuning. Range: -30..+30
    // See also: ShowValue
    property ValueVertAdj : Shortint read fValueVAdj write SetValueVAdj default 0;
    //Minimum value, just like TSpinEdit's Min-property
    //See also: Max, Value
    property Min : Single read fMin write SetMin;
    //Maximum value, just like TSpinEdit's Max-property
    //See also: Min, Value
    property Max : Single read fMax write SetMax;
    //Current Value, just like TSpinEdit's Value
    //See also Min, Max, ShowValue
    property Value : Single read fValue write SetValue;
    //Precision when showing rounded values at ticks
    //See also TickDigits, ValuePrecision, ShowTicksScale
    property TickPrecision : Byte read fTickPrecision write SetTickPrecision default 7;
    //Digits when showing rounded values at ticks
    //See also TickPrecision, ValueDigits, ShowTicksScale
    property TickDigits : Byte read fTickDigits write SetTickDigits default 1;
    //This property enables the visualisation of logaritmic scaled values
    property LogScale : Boolean read fLogScale write SetLogScale default False;
    //This property enables the scientific abbreviations for tick-values
    //using the 'k' for factor 1000 and 'M' for factor 1000000
    property TickValAbbr : Boolean read fAbbrTickVals write SetAbbrTick default False;
    //Precision when showing the rounded value
    //See also ValueDigits, TickPrecision, ShowTicksScale
    property ValuePrecision : Byte read fValuePrecision write SetValuePrecision default 7;
    //Digits when showing the rounded value
    //See also ValuePrecision, TickDigits, ShowTicksScale
    property ValueDigits : Byte read fValueDigits write SetValueDigits default 1;
    //Section of circle used for the meter.
    //Range: 10..360 (degrees)
    property AngularRange : LongInt read fAngularRange write SetAngularRange default 270;
    //No of ticks to be displayed on the face.
    //Make this an odd number to get a tick at 50%
    //Range: 0..(Max-Min), less than 2 gets set to 0.
    //See also: TickCount, TickColor
    property TickCount : Byte read fTickCount write SetTickCount default 7;
    //Three zones can be defined: LowZone, HighZone and the zone inbetween (OKZone).
    //The low zone is defined as all values between Min and LowZone.
    //Definitions are in % of (Max-Min). If you do not want a low-zone, set this to 0.
    //If you do not want the OK-zone, set HighZone to the same percentage as LowZone.
    //Its colour is defined by LowZoneColor.
    //Its transition-events are: From low to OK: onRiseAboveLow
    //                           From OK to low: onFallBelowLow
    //See also: EnableZoneEvents, LowZoneValue
    property LowZone : Byte read GetLowZone write SetLowZone default 10;
    //Three zones can be defined: LowZone, HighZone and the zone inbetween(OKZone).
    //The high zone is defined as all values between HighZone and Max.
    //Definitions are in % of (Max-Min). If you do not want a high-zone, set this to 100.
    //If you do not want the OK-zone, set HighZone to the same percentage as LowZone.
    //Its colour is defined by HighZoneColor.
    //Its transition-events are: From OK to High: onRiseAboveHigh
    //                           From High to OK: onFallBelowHigh
    //See also: EnableZoneEvents, HighZoneValue
    property HighZone : Byte read GetHighZone write SetHighZone default 90;
    //Color of the HighZone on the meter's face.
    //See also: LowZoneColor, OKZoneColor
    property HighZoneColor : TColor read fHighZoneColor write SetHighZoneColor default clRed;
    //Color of the LowZone on the meter's face.
    //See also: HighZoneColor, OKZoneColor
    property LowZoneColor  : TColor read fLowZoneColor write SetLowZoneColor default clYellow;
    //Color of the zone inbetween LowZone and HighZone on the meter's face.
    //See also: LowZoneColor, HighZoneColor
    property OKZoneColor   : TColor read fOKZoneColor write SetOKZoneColor default cl3DLight;
    //If set, the zones are not filled with their respective colours, but with
    //the Color-value or with the Background (if ShowBackround is true)
    property TransparentZones : Boolean read fTransparentZones write SetTransparentZones;
    //Set fLowZone with a value and not in %
    //See also: LowZone, EnableZoneEvents
    property LowZoneValue  : Single read fLowZone write SetLowZoneValue;
    //Set fHighZone with a value and not in %
    //See also: HighZone, EnableZoneEvents
    property HighZoneValue : Single read fHighZone write SetHighZoneValue;
    //This property influences the diameter of the knob holding the pointer
    property KnobSize : Byte read fKnobSize write SetKnobSize;
    //This property influences the width of the pointer
    property NeedleWidth : Byte read fNeedleWidth write SetNeedleWidth;
    //Colour of the ticks and of the pointer on the meter's face
    //See also: TickCount, ShowTicks
    property TickColor : TColor read fTickColor write SetTickColor default clBlack;
    //Defines whether the ticks get displayed
    //See also: TickCount, TickColor, ShowTicksScale
    property ShowTicks : Boolean read fShowTicks write SetShowTicks default True;
    //Defines whether values get shown at the ticks
    //See also: TickCount, ShowTicks
    property ShowTicksScale : Boolean read fShowTicksScale write SetShowTicksScale default True;
    //Defines whether or not to draw the coloured regions
    property ShowZones : Boolean read fShowZones write SetShowZones default True;
    //Defines whether a frame gets drawn around the meter's face
    property ShowFrame : Boolean read fShowFrame write SetShowFrame default True;
    //Defines whether the current Value gets displayed (below the pointer's origin).
    //Alternatively, you can set this to False and use onChange to update a TLabel
    //anywhere on your form.
    //See also: Font
    property ShowValue : Boolean read fShowValue write SetShowValue default True;
    //The face's dimensions get recalculated when the size changes.
    //The space needed for the Value at the bottom of the meter remains the same!
    //Most of the calculations are done in OptimizeSizes (private function)
    property onResize : TNotifyEvent read fOnResize write FonResize;
    //This event gets triggered everytime the Value changes.
    //See also: onRiseAboveHigh, onFallBelowHigh, onRiseAboveLow, onFallBelowLow
    property onChange : TNotifyEvent read FonChange write FonChange;
    //Defines whether the events onRiseAboveHigh, onFallBelowHigh, onRiseAboveLow, onFallBelowLow
    //get triggered.
    //See also: LowZone, HighZone, LowZoneValue, HighZoneValue
    property EnableZoneEvents : Boolean read fEnableZoneEvents write fEnableZoneEvents default True;
    //This event gets triggered if the value changes from below HighZone to above it.
    //If the value changes from below LowZone to above HighZone, the event onRiseAboveLow
    //gets suppressed.
    //See also: EnableZoneEvents, onFallBelowHigh, onFallBelowLow
    property onRiseAboveHigh : TNotifyEvent
        read FonRiseAboveHigh
       write FonRiseAboveHigh;
    //This event gets triggered if the value changes from above HighZone to below it.
    //If the value changes from above HighZone to below LowZone, this event
    //gets suppressed and only onFallBelowLow gets triggered.
    //See also: EnableZoneEvents, onRiseAboveHigh, onRiseAboveLow
    property onFallBelowHigh : TNotifyEvent
        read FonFallBelowHigh
       write FonFallBelowHigh;
    //This event gets triggered if the value changes from below LowZone to above it.
    //If the value changes from below LowZone to above HighZone, this event
    //gets suppressed and only onRiseAboveHigh gets triggered.
    //See also: EnableZoneEvents, onFallBelowHigh, onFallBelowLow
    property onRiseAboveLow : TNotifyEvent
        read FonRiseAboveLow
       write FonRiseAboveLow;
    //This event gets triggered if the value changes from above LowZone to below it.
    //If the value changes from above HighZone to below LowZone, the event onFallBelowHigh
    //gets suppressed.
    //See also: EnableZoneEvents, onRiseAboveHigh, onRiseAboveLow
    property onFallBelowLow : TNotifyEvent
        read FonFallBelowLow
       write FonFallBelowLow;
    //Purely inherited property
    property Align;
    //Defines the basic colour of the meter's face
    property Color : TColor read fColor write SetColor;
    //Defines the fontkind for Value and Caption
    property Font : TFont read GetFont write SetFont;
    //Purely inherited property
    //See also: Color
    property ParentColor;
    //Purely inherited property
    //See also : Font
    property ParentFont;
    //Purely inherited property
    property ParentShowHint;
    //Purely inherited property
    property PopupMenu;
    //Purely inherited property
    property ShowHint;
    //Purely inherited property
    property Visible;
    //Purely inherited event
    property OnClick;
    //Purely inherited event
    property OnDblClick;
    //Purely inherited event
    property OnDragDrop;
    //Purely inherited event
    property OnDragOver;
    //Purely inherited event
    property OnEndDrag;
    //Purely inherited event
    property OnMouseDown;
    //Purely inherited event
    property OnMouseMove;
    //Purely inherited event
    property OnMouseUp;
    //Purely inherited event
    property OnStartDrag;
(*    property OnEnter;    NOPE, defined in TControl, not visible to me
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
*)
  end;

procedure Register;

implementation
uses Math;

{------------------------------------------------------------------------------}
procedure Register;
begin
  RegisterComponents('Fabricio', [TAnalogMeter]);
end;

{-------------------some necessary utils---------------------------------------}
{------------------------------------------------------------------------------}
Function Radius(Theta : Single; HalfAxes : TPoint) : Single;
         //calculates length of 'radius' in ellipse defined by the half-axes at
         //angle Theta (0 is straight down, clockwise, in degrees)
Var C, S : Single;  //Cos / Sin
    w, h : LongInt; //half-axes
Begin
  C := Cos(Theta*Pi/180);
  S := Sin(Theta*Pi/180);
  w := HalfAxes.X;
  h := HalfAxes.Y;
  If (w <= 0) or (h <= 0) then begin
    Result := 0;
    Exit;
  end;
  Result := w*h/Sqrt(h*h*S*S + w*w*C*C);
End;

{------------------------------------------------------------------------------}
Function XinEllipse(Theta : Single; HalfAxes : TPoint) : LongInt;
         //calculates X-posn of point on ellipse at angle Theta
Var R : Single;
Begin
  R := Radius(Theta,Halfaxes);
  Result := Round(-R*Sin(Theta*Pi/180)); //theta counted from straight down, clockwise
End;

{------------------------------------------------------------------------------}
Function YinEllipse(Theta : Single; HalfAxes : TPoint) : LongInt;
         //calculates Y-posn of point on ellipse at angle Theta
Var R : Single;
Begin
  R := Radius(Theta,Halfaxes);
  Result := Round(R*Cos(Theta*Pi/180)); //theta counted from straight down, clockwise
End;

{------------------------------------------------------------------------------}
Function OptimalHalfHeight(AvailableHeight : LongInt; Theta : Single; Width : LongInt) : LongInt;
         //calculates optimal ellipse half-height if only part of the ellipse needs to fit
         //into the AvailableHeight. Theta is the ZeroAngle
Var UsedHeight : Single;
    H : LongInt; //half-height, found by trial as the equation is not
                 // analytically solvable       // by me ;)
    C, S, T : Single; //Cos, Sin and a temp. variable for speed
Begin
  If Theta >= 90 then begin //centre MUST be shown
    Result := AvailableHeight;
    Exit;
  end;
  S := Sin(Theta*Pi/180);
  S := Sqr(S);  //only the sqr is needed later on
  C := Cos(Theta*Pi/180);
  C := Width*C/2; //only the product is needed later on
  T := Sqr(C);
  //OK, start at H = 1/2 of available and Inc(H) it until it gets too big:
  H := AvailableHeight div 2;
  UsedHeight := H + H*C / Sqrt(Sqr(H)*S + T); //basically H +Radius*Cos(Theta), just sped up
  While UsedHeight < AvailableHeight do begin
    Inc(H);
    UsedHeight := H + H*C / Sqrt(Sqr(H)*S + T);
  end;
  Dec(H); //remember that it was Inc'ed once too often
  Result := H;
End;

{-------------------------TAnalogMeter-----------------------------------------}
{------------------------------------------------------------------------------}
Constructor TAnalogMeter.Create(AOwner: TComponent);
Begin
  inherited Create(AOwner);
  fBitmap := TBitmap.Create;
  fBackGround := TBitmap.Create;
  fMask := TBitmap.Create;
  fInvMask := TBitmap.Create;
  fTemp := TBitmap.Create;
//  fBackground.FreeImage;
  //defaults:
  fShowBackground := False;
  fBackGroundTop  := 0;
  fBackGroundLeft := 0;
  fTransparentZones := False;
  Width  := 121;
  Height := 117;
  fCaption := 'mV';
  fCaptionPos := cpTop;
  fCaptionVAdj := 0;
  fValueVAdj := 0;
  fMin   := 0;
  fMax   := 100;
  fValue := 0;
  fOldValue := fValue;
  fAngularRange  := 270;
  fTickCount     := 11;
  fLowZone      := 10;
  fColor := clBtnFace;
  fHighZone      := 90;
  fShowValue := True;
  fTickPrecision := 7;
  fTickDigits    := 1;
  fValuePrecision := 7;
  fValueDigits    := 1;
  fKnobSize  := 10;
  fNeedleWidth := 2;
  //internal stuff:
  fZeroAngle := 45;
  fTxtHeight := 8;
  fHighZoneColor    := clRed;
  fLowZoneColor     := clYellow;
  fOKZoneColor      := cl3DLight;
  fTickColor        := clBlack;
  fShowZones        := True;
  fShowTicks        := True;
  fShowTicksScale   := False;
  fLogScale         := False; //linear scale
  fAbbrTickVals     := False; //normal tick-values
  fShowFrame        := True;
  fEnableZoneEvents := True;
End;

{------------------------------------------------------------------------------}
Destructor TAnalogMeter.Destroy;
Begin
  fBitmap.Free;
  fBackGround.Free;
  fMask.Free;
  fInvMask.Free;
  fTemp.Free;
  inherited Destroy;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.WMSize(var Message : TWMSize);
Begin
  If Height < 37 then Height := 37; //anything else is nonsense
  If Width  < 52 then Width  := 52;
  If Assigned(FonResize) then FonResize(Self);
  OptimizeSizes;
  fBitmap.Width  := Width;
  fBitmap.Height := Height;
  fBackGround.Width  := Width;
  fBackGround.Height := Height;
  fMask.Width  := Width;
  fMask.Height := Height;
  fInvMask.Width  := Width;
  fInvMask.Height := Height;
  fTemp.Width  := Width;
  fTemp.Height := Height;
  DrawOuterFace;
  DrawInnerFace;
//  Paint;
  inherited;
End;

{------------------------------------------------------------------------------}
Function TAnalogMeter.GetFont : TFont;
Begin
  Result := fBitmap.Canvas.Font;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetFont(f : TFont);
Begin
  If fBitmap.Canvas.Font = f then Exit;
  fBitmap.Canvas.Font := f;
  fMask.Canvas.Font := f;
  fTxtHeight := fBitmap.Canvas.TextHeight('S');
  If fShowValue or fShowTicksScale or (Trim(fCaption) <> '') then
    ForceRedraw;
End;

{-------------------------------------------------------------}
Procedure TAnalogMeter.SetTickPrecision(v : Byte);
Begin
  If (fTickPrecision <> v) then begin
    fTickPrecision := v;
    DrawInnerFace;
    Paint;
  end;
End;          

{-------------------------------------------------------------}
Procedure TAnalogMeter.SetTickDigits(v : Byte);
Begin
  If (fTickDigits <> v) then begin
    fTickDigits := v;
    DrawInnerFace;
    Paint;
  end;
End;

{-------------------------------------------------------------}
Procedure TAnalogMeter.SetValuePrecision(v : Byte);
Begin
  If (fValuePrecision <> v) then begin
    fValuePrecision := v;
    ForceRedraw;
  end;
End;          

{-------------------------------------------------------------}
Procedure TAnalogMeter.SetValueDigits(v : Byte);
Begin
  If (fValueDigits <> v) then begin
    fValueDigits := v;
    ForceRedraw;
  end;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetColor(C : TColor);
Begin
  If fColor = C then Exit;
  fColor := C;
  ForceRedraw;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetCaption(s : String);
Begin
  s := Trim(s);
  If fCaption = s then Exit;
  fCaption := s;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetMin(m : Single);
Var OldLow, OldHigh : Longint;
Begin
  If m > fMax then fMax := m;    //force consistency (mlm)
  If fLogScale and (m <= 0)       //logs don't like such vals...
    then m := 1;
  If fMin = m then Exit;         //no action needed
  OldLow := GetLowZone;          //in %!
  OldHigh := GetHighZone;
  fMin := m;
  If fValue < m then Value := m; //force consistency
  SetLowZone(OldLow);            //converts internally
  SetHighZone(OldHigh);
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetMax(m : Single);
Var OldLow, OldHigh : Longint;
Begin
  If m < fMin then fMin := m;    //force consistency
  If fLogScale and (m <= 0)       //logs don't like such vals...
    then m := 1;
  If fMax = m then Exit;         //no action needed
  OldLow := GetLowZone;          //in %!
  OldHigh := GetHighZone;
  fMax := m;
  If fValue > m then Value := m; //force consistency
  SetLowZone(OldLow);            //converts internally
  SetHighZone(OldHigh);
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetValue(v : Single);
Var TriggerHi, TriggerLo : Boolean;
Begin
  If v < fMin then v := fMin;
  If v > fMax then v := fMax;
  If v = fValue then Exit;
  fOldValue := fValue;
  fValue := v;
  If Assigned(FonChange) then FonChange(Self);
  //redraw:
  DrawInnerFace;
  Paint;
  //call events if necessary:
  If not fEnableZoneEvents then Exit;
  TriggerHi := Assigned(FonRiseAboveHigh) and (fOldValue < fHighZone) and (fValue >= fHighZone);
  TriggerLo := Assigned(FonFallBelowLow) and (fOldValue >= fLowZone) and (fValue < fLowZone);
  If TriggerLo then FonFallBelowLow(Self);
  If TriggerHi then FonRiseAboveHigh(Self);
  If not (TriggerHi or TriggerLo) then begin//only trigger one the two events if we move through 2 zones:
    If Assigned(FonFallBelowHigh) and (fOldValue >= fHighZone) and (fValue < fHighZone)
      then FonFallBelowHigh(Self);
    If Assigned(FonRiseAboveLow) and (fOldValue < fLowZone) and (fValue >= fLowZone)
      then FonRiseAboveLow(Self);
  end;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetAngularRange(r : LongInt);
Begin
  If r < 10 then r := 10;         //hard limits
  If r > 360 then r := 360;
  If r = fAngularRange then Exit; //no action needed
  fAngularRange := r;
  fZeroAngle := (360-AngularRange)/2;
  OptimizeSizes;
  ForceRedraw;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetTickCount(t : Byte);
Begin
  If t > (100) then t := 100;  //hard limit
  If t = fTickCount then Exit; //no action needed
  fTickCount := t;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetKnobSize(s : Byte);
Begin
  If s = fKnobSize then Exit; //no action needed
  fKnobSize := s;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetNeedleWidth(w : Byte);
Begin
  If w = fNeedleWidth then Exit; //no action needed
  fNeedleWidth := w;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetLowZone(percent : Byte);
Begin
  If percent > 100 then percent := 100;
  //let SetLowZoneValue handle the rest
  LowZoneValue:=Min + (Max-Min)*percent/100;
End;

{------------------------------------------------------------------------------}
Function TAnalogMeter.GetLowZone : Byte;
Begin
  If Max = Min
    then Result := 0
    else Result := Round(100*(fLowZone - Min)/(Max - Min));
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetHighZone(percent : Byte);
Begin
  If percent > 100 then percent := 100;
  //let SetHighZoneValue handle the rest
  HighZoneValue:= Min + (Max-Min)*percent/100;
End;

{------------------------------------------------------------------------------}
Function TAnalogMeter.GetHighZone : Byte;
Begin
  If Max = Min
    then Result := 0
    else Result := Round(100*(fHighZone - Min)/(Max - Min));
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetShowValue(b : Boolean);
Begin
  If b = fShowValue then Exit;
  fShowValue := b;
  ForceRedraw;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetLogScale(b : Boolean);
Begin
  If b then begin
    If (fMin <= 0) then fMin := 1;      //Restrictions due to Log
    If Value < fMin then Value := fMin;
  end;
  If b = fLogScale then Exit;
  fLogScale := b;
  ForceRedraw;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetAbbrTick(b : Boolean);
Begin
  If b = fAbbrTickVals then Exit;
  fAbbrTickVals := b;
  ForceRedraw;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetHighZoneColor(c : TColor);
Begin
  If fHighZoneColor = c then Exit;
  fHighZoneColor := c;
  ForceRedraw;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetLowZoneColor(c : TColor);
Begin
  If fLowZoneColor = c then Exit;
  fLowZoneColor := c;
  ForceRedraw;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetOKZoneColor(c : TColor);
Begin
  If fOKZoneColor = c then Exit;
  fOKZoneColor := c;
  ForceRedraw;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetTickColor(c : TColor);
Begin
  If fTickColor = c then Exit;
  fTickColor := c;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetShowTicks(b : Boolean);
Begin
  If fShowTicks = b then Exit;
  fShowTicks := b;
  ForceRedraw;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetShowTicksScale(b : Boolean);
Begin
  If fShowTicksScale = b then Exit;
  fShowTicksScale := b;
  ForceRedraw;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetShowFrame(b : Boolean);
Begin
  If fShowFrame = b then Exit;
  fShowFrame := b;
  ForceRedraw;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetShowZones(s : Boolean);
Begin
  If fShowZones = s then Exit;
  fShowZones := s;
  ForceRedraw;
End;

{------------------------------------------------------------------------------}
{--------------- drawing routines: all on fBitmap in background ---------------}
{------------------------------------------------------------------------------}
function TAnalogMeter.NormalTickString(TickValue : Single) : String;
begin
  Result := FloatToStrF(TickValue, ffFixed, fTickPrecision, fTickDigits);
end;

{------------------------------------------------------------------------------}
function TAnalogMeter.AbbreviateTickString(TickValue : Single) : String;
// uses the Abbreviations 'k' and 'M' as symbols for 1000 and 1000000
var c : Char;
begin
  If TickValue >= 1000 then begin
    c := DecimalSeparator;//save old value
    If TickValue >= 1E6 then begin
      DecimalSeparator := 'M';
      Result := FloatToStrF(TickValue/1E6, ffFixed, fTickPrecision, fTickDigits);
    end else begin
      DecimalSeparator := 'k';
      Result := FloatToStrF(TickValue/1000, ffFixed, fTickPrecision, fTickDigits);
    end;
    DecimalSeparator := c;//restore old value
  end else
    Result := FloatToStrF(TickValue, ffFixed, fTickPrecision, fTickDigits);
end;

{------------------------------------------------------------------------------}
Function TAnalogMeter.AngleOf(v : Single) : Single;
Begin
  If fMax=fMin
    then Result := 0 //(mlm)
    else Result := fZeroAngle + fAngularRange*(v - fMin)/(fMax-fMin);
End;
Function TAnalogMeter.LogAngleOf(v : single) : Single;
Begin
  If fMax=fMin
    then Result := 0
    else Result := fZeroAngle + fAngularRange * log10(v/fMin) / log10(fMax/fMin);
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.OptimizeSizes;
var TH : LongInt; //space for text at the bottom
Begin
  TH := fTxtHeight + 2;
  fFrameWidth := (Width + Height) div 40;
  fOuterHalfAxes.Y := OptimalHalfHeight(Height - 2*fFrameWidth - TH, fZeroAngle, Width - 2*fFrameWidth);
  fCentrePoint.Y := fFrameWidth + fOuterHalfAxes.Y;
  fCentrePoint.X := Width Div 2;
  fOuterHalfAxes.X := fCentrePoint.X-fFrameWidth;
  fInnerHalfAxes := Point(fOuterHalfAxes.X - ((Width+Height)div 25),
                          fOuterHalfAxes.Y - ((Width+Height)div 25));
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.ClearCanvas;
Begin
  with fBitmap.Canvas do begin
    Brush.Style := bsClear;
    Brush.Color := Self.Color;
    FillRect(ClientRect);
  end;
  If fShowBackground then with fMask.Canvas do begin
    Brush.Style := bsSolid;
    Brush.Color := clBlack;
    FillRect(ClientRect);
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawFrame;
Begin
  with fBitmap.Canvas do begin
    Pen.Color := clBtnShadow;
    Pen.Width := 1;
    MoveTo(0,Height);
    LineTo(0,0);
    LineTo(Width-1,0);
    Pen.Color := clBtnHighLight;
    LineTo(Width-1,Height-1);
    LineTo(0,Height-1);
  end;
  If fShowBackground then with fMask.Canvas do begin
    Pen.Color := clWhite;
    Pen.Width := 1;
    MoveTo(0,Height);
    LineTo(0,0);
    LineTo(Width-1,0);
    LineTo(Width-1,Height-1);
    LineTo(0,Height-1);
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawZones;
Var Xzero, Yzero,
    Xlow, Ylow,
    XHi, YHi : LongInt;
    LowAngle, HiAngle : Single;
Begin
  //3 arcs for the 3 zones:
  if fLogScale then begin //log. scale
    LowAngle := LogAngleOf(fLowZone);
    HiAngle  := LogAngleOf(fHighZone);
  end else begin //linear scale
    LowAngle := AngleOf(fLowZone);
    HiAngle  := AngleOf(fHighZone);
  end;
  Xzero := XInEllipse(fZeroAngle,fOuterHalfAxes);
  Yzero := YInEllipse(fZeroAngle,fOuterHalfAxes);
  XLow  := XInEllipse(LowAngle,fOuterHalfAxes);
  YLow  := YInEllipse(LowAngle,fOuterHalfAxes);
  XHi   := XInEllipse(HiAngle,fOuterHalfAxes);
  YHi   := YInEllipse(HiAngle,fOuterHalfAxes);
   //fill zones with colours:
  with fBitmap.Canvas do begin
    Pen.Width := 2;
    If Color = clBtnShadow then Pen.Color := cl3DLight
                           else Pen.Color := clBtnShadow;
    If fLowZone > fMin then begin
      if fTransparentZones
        then Brush.Color := Self.Color
        else Brush.Color := fLowZoneColor;
      Pie(fCentrePoint.X-fOuterHalfAxes.X, fCentrePoint.Y-fOuterHalfAxes.Y,
          fCentrePoint.X+fOuterHalfAxes.X, fCentrePoint.Y+fOuterHalfAxes.Y,
          fCentrePoint.X + XLow, fCentrePoint.Y + YLow,
          fCentrePoint.X + Xzero, fCentrePoint.Y + Yzero);
    end;
    If (fHighZone > fLowZone) then begin
      if fTransparentZones
        then Brush.Color := Self.Color
        else Brush.Color := fOKZoneColor;
      Pie(fCentrePoint.X-fOuterHalfAxes.X, fCentrePoint.Y-fOuterHalfAxes.Y,
          fCentrePoint.X+fOuterHalfAxes.X, fCentrePoint.Y+fOuterHalfAxes.Y,
          fCentrePoint.X + XHi, fCentrePoint.Y + YHi,
          fCentrePoint.X + XLow, fCentrePoint.Y + YLow);
    end;
    If (fHighZone < fMax) then begin
      if fTransparentZones
        then Brush.Color := Self.Color
        else Brush.Color := fHighZoneColor;
      Pie(fCentrePoint.X-fOuterHalfAxes.X, fCentrePoint.Y-fOuterHalfAxes.Y,
          fCentrePoint.X+fOuterHalfAxes.X, fCentrePoint.Y+fOuterHalfAxes.Y,
          fCentrePoint.X - Xzero, fCentrePoint.Y + Yzero,
          fCentrePoint.X + XHi, fCentrePoint.Y + YHi);
    end;
  end;
  If fShowBackground then with fMask.Canvas do begin
    Pen.Width := 2;
    Pen.Color := clWhite;
    Brush.Color := clWhite;
    if fTransparentZones
      then Brush.Color := clBlack
      else Brush.Color := clWhite;
    If fLowZone > fMin then begin
      Pie(fCentrePoint.X-fOuterHalfAxes.X, fCentrePoint.Y-fOuterHalfAxes.Y,
          fCentrePoint.X+fOuterHalfAxes.X, fCentrePoint.Y+fOuterHalfAxes.Y,
          fCentrePoint.X + XLow, fCentrePoint.Y + YLow,
          fCentrePoint.X + Xzero, fCentrePoint.Y + Yzero);
    end;
    If (fHighZone > fLowZone) then begin
      Pie(fCentrePoint.X-fOuterHalfAxes.X, fCentrePoint.Y-fOuterHalfAxes.Y,
          fCentrePoint.X+fOuterHalfAxes.X, fCentrePoint.Y+fOuterHalfAxes.Y,
          fCentrePoint.X + XHi, fCentrePoint.Y + YHi,
          fCentrePoint.X + XLow, fCentrePoint.Y + YLow);
    end;
    If (fHighZone < fMax) then begin
      Pie(fCentrePoint.X-fOuterHalfAxes.X, fCentrePoint.Y-fOuterHalfAxes.Y,
          fCentrePoint.X+fOuterHalfAxes.X, fCentrePoint.Y+fOuterHalfAxes.Y,
          fCentrePoint.X - Xzero, fCentrePoint.Y + Yzero,
          fCentrePoint.X + XHi, fCentrePoint.Y + YHi);
    end;
    Arc(fCentrePoint.X-fInnerHalfAxes.X, fCentrePoint.Y-fInnerHalfAxes.Y,
        fCentrePoint.X+fInnerHalfAxes.X, fCentrePoint.Y+fInnerHalfAxes.Y,
        fCentrePoint.X - Xzero, fCentrePoint.Y + Yzero,
        fCentrePoint.X + Xzero, fCentrePoint.Y + Yzero);
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.ClearInnerFace;
Var Xzero, Yzero : LongInt;
Begin
  Xzero := XInEllipse(fZeroAngle,fOuterHalfAxes);
  Yzero := YInEllipse(fZeroAngle,fOuterHalfAxes);
  with fBitmap.Canvas do begin
    Pen.Width := 2;
    If Color = clBtnShadow then Pen.Color := cl3DLight
                           else Pen.Color := clBtnShadow;
    If fShowZones then
      Arc(fCentrePoint.X-fInnerHalfAxes.X, fCentrePoint.Y-fInnerHalfAxes.Y,
          fCentrePoint.X+fInnerHalfAxes.X, fCentrePoint.Y+fInnerHalfAxes.Y,
          fCentrePoint.X - Xzero, fCentrePoint.Y + Yzero,
          fCentrePoint.X + Xzero, fCentrePoint.Y + Yzero);
    //overwrite colours:
    Pen.Color := Color;  //don't want edges of pie
    Brush.Color := Color;
    Ellipse(fCentrePoint.X-fInnerHalfAxes.X+2, fCentrePoint.Y-fInnerHalfAxes.Y+2,
        fCentrePoint.X+fInnerHalfAxes.X-2, fCentrePoint.Y+fInnerHalfAxes.Y-2);
  end;
  If fShowBackground then with fMask.Canvas do begin
    Pen.Width := 2;
    Pen.Color := clBlack;
    Brush.Color := clBlack;
    Ellipse(fCentrePoint.X-fInnerHalfAxes.X+2, fCentrePoint.Y-fInnerHalfAxes.Y+2,
        fCentrePoint.X+fInnerHalfAxes.X-2, fCentrePoint.Y+fInnerHalfAxes.Y-2);
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawTicks;
var i : LongInt;
    SmallEllipse : TPoint;
    Angle : Single;
Begin
  SmallEllipse.X := fInnerHalfAxes.X-((Width+Height) div 35);
  SmallEllipse.Y := fInnerHalfAxes.Y-((Width+Height) div 35);
  with fBitmap.Canvas do begin
    Pen.Color := fTickColor;
    Pen.Width := 1;
    For i := 1 to fTickCount do begin
      Angle := AngleOf(Min + (Max-Min)*(i-1)/(fTickCount-1));
      MoveTo(fCentrePoint.X + XInEllipse(Angle,fInnerHalfAxes),
             fCentrePoint.Y + YInEllipse(Angle,fInnerHalfAxes));
      LineTo(fCentrePoint.X + XInEllipse(Angle,SmallEllipse),
             fCentrePoint.Y + YInEllipse(Angle,SmallEllipse));
    end;
  end;
  If fShowBackground then with fMask.Canvas do begin
    Pen.Color := clWhite;
    Pen.Width := 1;
    For i := 1 to fTickCount do begin
      Angle := AngleOf(Min + (Max-Min)*(i-1)/(fTickCount-1));
      MoveTo(fCentrePoint.X + XInEllipse(Angle,fInnerHalfAxes),
             fCentrePoint.Y + YInEllipse(Angle,fInnerHalfAxes));
      LineTo(fCentrePoint.X + XInEllipse(Angle,SmallEllipse),
             fCentrePoint.Y + YInEllipse(Angle,SmallEllipse));
    end;
  end;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawTicksScale;
var i : LongInt;
    SmallEllipse : TPoint;
    TickValue : Single;
    Angle : Single;
    ScaleText : String;
    SizeRect     : TRect;
    Pos_Factor   : Single;
    OldFontColor : TColor;
Begin
  SmallEllipse.X := fInnerHalfAxes.X-((Width+Height) div 35);
  SmallEllipse.Y := fInnerHalfAxes.Y-((Width+Height) div 35);
  Pos_Factor := 1; //just to kill the compiler warning
  with fBitmap.Canvas do begin
    OldFontColor := Font.Color;
    Font.Color := fTickColor;
    Brush.Style := bsClear;
    For i := 0 to (fTickCount - 1) do begin
      //If log-scale: also keep ticks at regular angular intervals!
      if fLogScale 
        then TickValue := Min * Power(Max/Min, i/(fTickCount-1))
        else TickValue := Min + (Max-Min)*i/(fTickCount-1);
      Angle := AngleOf(Min + (Max-Min)*i/(fTickCount-1));
      If fAbbrTickVals
        then ScaleText := AbbreviateTickString(TickValue)
        else ScaleText := NormalTickString(TickValue);
      SizeRect := Rect(0,0,TextWidth(ScaleText),TextHeight(ScaleText));
      If (Angle <= 45) or (Angle >= 315) then begin
        If Angle >=  45 then Pos_Factor := (45 - Angle) / 90; //0 to 0.5
        If Angle >= 315 then Pos_Factor := 1 - (Angle - 315) / 90; // 0.5 to 1
        // Align Horz Center to Bottom
        SizeRect.Right  := Trunc(SizeRect.Right * Pos_Factor);
        SizeRect.Left   := fCentrePoint.X + XInEllipse(Angle,SmallEllipse)- SizeRect.Right;
        SizeRect.Top    := fCentrePoint.Y + YInEllipse(Angle,SmallEllipse) - SizeRect.Bottom;
        TextOut( SizeRect.Left, SizeRect.Top, ScaleText);
      end;
      If ((Angle > 45) and (Angle < 135)) then begin
        Pos_Factor := 1 - (Angle - 45) / 90;
        // Align Vert Center to Left
        SizeRect.Bottom := Trunc(SizeRect.Bottom * Pos_Factor);
        SizeRect.Left   := fCentrePoint.X + XInEllipse(Angle,SmallEllipse);
        SizeRect.Top    := fCentrePoint.Y + YInEllipse(Angle,SmallEllipse) - SizeRect.Bottom;
        TextOut( SizeRect.Left, SizeRect.Top, ScaleText);
      end;
      If ((Angle >= 135) and (Angle <= 225)) then begin
        Pos_Factor := (Angle - 135) / 90;
        // Align Horz Center to Top
        SizeRect.Right  := Trunc(SizeRect.Right * Pos_Factor);
        SizeRect.Left   := fCentrePoint.X + XInEllipse(Angle,SmallEllipse)- SizeRect.Right;
        SizeRect.Top    := fCentrePoint.Y + YInEllipse(Angle,SmallEllipse);
        TextOut( SizeRect.Left, SizeRect.Top, ScaleText);
      end;
      If ((Angle > 225) and (Angle < 315)) then begin
        Pos_Factor := (Angle - 225) / 90;
        // Align Vert Center to Right
        SizeRect.Bottom := Trunc(SizeRect.Bottom * Pos_Factor);
        SizeRect.Left   := fCentrePoint.X + XInEllipse(Angle,SmallEllipse) - SizeRect.Right;
        SizeRect.Top    := fCentrePoint.Y + YInEllipse(Angle,SmallEllipse) - SizeRect.Bottom;
        TextOut( SizeRect.Left, SizeRect.Top, ScaleText);
      end;
    end;
    Font.Color := OldFontColor;
  end;
  If fShowBackground then with fMask.Canvas do begin
    Font.Color := clWhite;
    Brush.Style := bsClear;
    For i := 0 to (fTickCount - 1) do begin
      //If log-scale: also keep ticks at regular angular intervals!
      if fLogScale
        then TickValue := Min * Power(Max/Min, i/(fTickCount-1))
        else TickValue := Min + (Max-Min)*i/(fTickCount-1);
      Angle := AngleOf(Min + (Max-Min)*i/(fTickCount-1));
      If fAbbrTickVals
        then ScaleText := AbbreviateTickString(TickValue)
        else ScaleText := NormalTickString(TickValue);
      SizeRect := Rect(0,0,TextWidth(ScaleText),TextHeight(ScaleText));
      If (Angle <= 45) or (Angle >= 315) then begin
        If Angle >=  45 then Pos_Factor := (45 - Angle) / 90; //0 to 0.5
        If Angle >= 315 then Pos_Factor := 1 - (Angle - 315) / 90; // 0.5 to 1
        // Align Horz Center to Bottom
        SizeRect.Right  := Trunc(SizeRect.Right * Pos_Factor);
        SizeRect.Left   := fCentrePoint.X + XInEllipse(Angle,SmallEllipse)- SizeRect.Right;
        SizeRect.Top    := fCentrePoint.Y + YInEllipse(Angle,SmallEllipse) - SizeRect.Bottom;
        TextOut( SizeRect.Left, SizeRect.Top, ScaleText);
      end;
      If ((Angle > 45) and (Angle < 135)) then begin
        Pos_Factor := 1 - (Angle - 45) / 90;
        // Align Vert Center to Left
        SizeRect.Bottom := Trunc(SizeRect.Bottom * Pos_Factor);
        SizeRect.Left   := fCentrePoint.X + XInEllipse(Angle,SmallEllipse);
        SizeRect.Top    := fCentrePoint.Y + YInEllipse(Angle,SmallEllipse) - SizeRect.Bottom;
        TextOut( SizeRect.Left, SizeRect.Top, ScaleText);
      end;
      If ((Angle >= 135) and (Angle <= 225)) then begin
        Pos_Factor := (Angle - 135) / 90;
        // Align Horz Center to Top
        SizeRect.Right  := Trunc(SizeRect.Right * Pos_Factor);
        SizeRect.Left   := fCentrePoint.X + XInEllipse(Angle,SmallEllipse)- SizeRect.Right;
        SizeRect.Top    := fCentrePoint.Y + YInEllipse(Angle,SmallEllipse);
        TextOut( SizeRect.Left, SizeRect.Top, ScaleText);
      end;
      If ((Angle > 225) and (Angle < 315)) then begin
        Pos_Factor := (Angle - 225) / 90;
        // Align Vert Center to Right
        SizeRect.Bottom := Trunc(SizeRect.Bottom * Pos_Factor);
        SizeRect.Left   := fCentrePoint.X + XInEllipse(Angle,SmallEllipse) - SizeRect.Right;
        SizeRect.Top    := fCentrePoint.Y + YInEllipse(Angle,SmallEllipse) - SizeRect.Bottom;
        TextOut( SizeRect.Left, SizeRect.Top, ScaleText);
      end;
    end;
  end;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawCaption;
var TW: LongInt; //textwidth
    TH: Longint; // TextHeight;
    H, H1, H2 : LongInt;
Begin
  with fBitmap.Canvas do begin
    TW := TextWidth(fCaption) DIV 2;
    TH := TextHeight(fCaption) DIV 2;
  end;
  case fCaptionPos of
    cpBottom: begin
      H1 := fCentrePoint.Y + ((Width + Height) div 40); //bottom of knob
      H2 := Height - fTxtHeight - 2 - (fOuterHalfAxes.Y - fInnerHalfAxes.Y);
      H  := ((H2 + H1) div 2) + fCaptionVAdj - TH;
    end;  (* cpBottom *)
    else begin  // cpTop
      H1 := fCentrePoint.Y - ((Width + Height) div 40); //top of knob
      H2 := fCentrePoint.Y - fInnerHalfAxes.Y - 1;      //bottom of scale
      H  := ((H1 + H2) div 2) + fCaptionVAdj;
    end;  (* else *)
  end;  (* case *)

  with fBitmap.Canvas do begin
    Brush.Color := Color; //background
    TextOut(fCentrePoint.X - TW, H, fCaption);
  end;
  If fShowBackground then with fMask.Canvas do begin
    Brush.Color := clBlack;
    TextOut(fCentrePoint.X - TW, H, fCaption);
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawPointer;
var angle : Single;
    X,Y : LongInt;
    SmallEllipse : TPoint;
    Radius : LongInt;
Begin
  with fBitmap.Canvas do begin
    //hand:
    SmallEllipse.X := fInnerHalfAxes.X-fNeedleWidth-1;
    SmallEllipse.Y := fInnerHalfAxes.Y-fNeedleWidth-1;
    If fLogScale
      then angle := LogAngleOf(fValue)
      else angle := AngleOf(fValue);
    X := XInEllipse(Angle,SmallEllipse);
    Y := YInEllipse(Angle,SmallEllipse);
    Pen.Width := fNeedleWidth;
    Pen.Color := fTickColor;
    MoveTo(fCentrePoint.X, fCentrePoint.Y);
    LineTo(fCentrePoint.X + X, fCentrePoint.Y + Y);
    //knob:
    Radius := fKnobsize*(Width + Height) div 400;
    //shadow:
    Pen.Width := 3;
    Pen.Color := clBtnShadow;
    Ellipse(fCentrePoint.X - Radius+1, fCentrePoint.Y - Radius,
            fCentrePoint.X + Radius+1, fCentrePoint.Y + Radius);
    //knob itself, in colour of current zone:
    Pen.Width := 1;
    If (fLowZone > fMin) and (fValue <= fLowZone)
      then Brush.Color := fLowZoneColor
      else If (fHighZone < fMax) and (fValue >= fHighZone)
        then Brush.Color := fHighzoneColor
        else Brush.Color := fOKzoneColor;
    Pen.Color := Brush.Color;
    Ellipse(fCentrePoint.X - Radius, fCentrePoint.Y - Radius,
            fCentrePoint.X + Radius, fCentrePoint.Y + Radius);
  end;
  If fShowBackground then with fMask.Canvas do begin
    //hand:
    SmallEllipse.X := fInnerHalfAxes.X-fNeedleWidth-1;
    SmallEllipse.Y := fInnerHalfAxes.Y-fNeedleWidth-1;
    If fLogScale
      then angle := LogAngleOf(fValue)
      else angle := AngleOf(fValue);
    X := XInEllipse(Angle,SmallEllipse);
    Y := YInEllipse(Angle,SmallEllipse);
    Pen.Width := fNeedleWidth;
    Pen.Color := clWhite;
    Brush.Color := clWhite;
    MoveTo(fCentrePoint.X, fCentrePoint.Y);
    LineTo(fCentrePoint.X + X, fCentrePoint.Y + Y);
    //knob:
    Radius := fKnobsize*(Width + Height) div 400;
    //shadow:
    Pen.Width := 3;
    Ellipse(fCentrePoint.X - Radius+1, fCentrePoint.Y - Radius,
            fCentrePoint.X + Radius+1, fCentrePoint.Y + Radius);
    //knob itself:
    Pen.Width := 1;
    Ellipse(fCentrePoint.X - Radius, fCentrePoint.Y - Radius,
            fCentrePoint.X + Radius, fCentrePoint.Y + Radius);
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawValue;
var s : String;
Begin
  s := FloatToStrF(Value, ffFixed, fValuePrecision, fValueDigits);
  with fBitmap.Canvas do begin
    Brush.Style := bsClear;
    TextOut(fCentrePoint.X - (TextWidth(s) div 2),
            Height- fFrameWidth -fTxtHeight +fValueVAdj -1, s);
  end;
  If fShowBackground then with fMask.Canvas do begin
    Brush.Style := bsClear;
    Font.Color := clWhite;
    TextOut(fCentrePoint.X - (TextWidth(s) div 2),
            Height- fFrameWidth -fTxtHeight +fValueVAdj -1, s);
  end;
End;
{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DeleteOldValue;
var s : String;
    c : TColor;
Begin
  s := FloatToStrF(fOldValue, ffFixed, fValuePrecision, fValueDigits);
  with fBitmap.Canvas do begin
    Brush.Style := bsClear;
    c := Font.Color;
    Font.Color  := Color;
    TextOut(fCentrePoint.X - (TextWidth(s) div 2),
            Height- fFrameWidth -fTxtHeight +fValueVAdj -1, s);
    Font.Color := c; //reset
  end;
  If fShowBackground then with fMask.Canvas do begin
    Brush.Style := bsClear;
    Font.Color  := clBlack;
    TextOut(fCentrePoint.X - (TextWidth(s) div 2),
            Height- fFrameWidth -fTxtHeight +fValueVAdj -1, s);
    Font.Color := clWhite;
  end;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawOuterFace;
Begin
  ClearCanvas;
  If fShowZones then DrawZones;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.DrawInnerFace;
Begin
  ClearInnerFace;
  If fShowTicks and (TickCount > 1) then DrawTicks;
  If fShowTicksScale and (TickCount > 1) then DrawTicksScale;
  If fCaption <> '' then DrawCaption;
  If fShowValue then DeleteOldValue;
  DrawPointer;
  If fShowValue then DrawValue;
  If fShowFrame then DrawFrame;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.Paint;
Begin
  If fShowBackground then begin
    //Get an inverse of the mask:
    BitBlt(fInvMask.Canvas.Handle, 0, 0, Width, Height,
           fMask.Canvas.Handle, 0, 0, NOTSRCCOPY);
    //Draw Background:
    //Clear Tmp:
    with fTemp.Canvas do begin
      Brush.Style := bsClear;
      Brush.Color := Self.Color;
      FillRect(ClientRect);
    end;
    ///and draw background onto it:
    BitBlt(fTemp.Canvas.Handle, fBackGroundLeft, fBackGroundTop, Width, Height,
	fBackGround.Canvas.Handle, 0, 0, SRCCOPY);
    //use only relevant part of background:
    BitBlt(fTemp.Canvas.Handle, 0, 0, Width, Height,
           fInvMask.Canvas.Handle, 0, 0, SRCAND);
    //get relevant part of fBitmap:
    BitBlt(fBitmap.Canvas.Handle, 0, 0, Width, Height,
           fMask.Canvas.Handle, 0, 0, SRCAND);
    //merge relevant parts:
    BitBlt(fTemp.Canvas.Handle, 0, 0, Width, Height,
           fBitmap.Canvas.Handle, 0, 0, SRCPAINT);
    //and now show the result:
    BitBlt(Canvas.Handle, 0, 0, Width, Height,
           fTemp.Canvas.Handle, 0, 0, SRCCOPY);
  end else
    //just draw the bitmap:
    BitBlt(Canvas.Handle, 0, 0, Width, Height,
           fBitmap.Canvas.Handle, 0, 0, SRCCOPY);
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.ForceRedraw;
Begin
  DrawOuterFace;
  DrawInnerFace;
  Paint;
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetLowZoneValue(AValue : Single);
Var fOldLow : Single;
Begin
  if AValue > Max then
    AValue := Max;
  if AValue < Min then
    AValue := Min;

  if AValue > fHighZone then  //no need for onFallBelowHigh: FonFallBelowLow takes precedence
    fHighZone := AValue;

  fOldLow := fLowZone;
  fLowZone := AValue;
  ForceRedraw;

  //call events if necessary:
  If not fEnableZoneEvents then Exit;
  If Assigned(FonFallBelowLow) and (fValue >= fOldLow) and (fValue < fLowZone)
    then FonFallBelowLow(Self);
  If Assigned(FonRiseAboveLow) and (fValue < fOldLow) and (fValue >= fLowZone)
    then FonRiseAboveLow(Self);
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetHighZoneValue(AValue : Single);
Var fOldHigh : Single;
Begin
  if AValue > Max then
    AValue := Max;
  if AValue < Min then
    AValue := Min;

  if AValue < fLowZone then     //no need for FonRiseAboveLow-Text: FonRiseAboveHigh takes precedence
    fLowZone:=AValue;

  fOldHigh := fHighZone;
  fHighZone := AValue;
  ForceRedraw;

  //call events if necessary:
  If not fEnableZoneEvents then Exit;
  If Assigned(FonFallBelowHigh) and (fValue >= fOldHigh) and (fValue < fHighZone)
    then FonFallBelowHigh(Self);
  If Assigned(FonRiseAboveHigh) and (fValue < fOldHigh) and (fValue >= fHighZone)
    then FonRiseAboveHigh(Self);
End;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetCaptionVAdj(V : Shortint);
begin
  if (V <> fCaptionVAdj) and (V >= -30) and (V <= 30) then begin
    fCaptionVAdj := V;
    ForceRedraw;
  end;
end;

{------------------------------------------------------------------------------}
Procedure TAnalogMeter.SetValueVAdj(V : Shortint);
begin
  if (V <> fValueVAdj) and (V >= -30) and (V <= 30) then begin
    fValueVAdj := V;
    ForceRedraw;
  end;
end;

{------------------------------------------------------------------------------}
procedure TAnalogMeter.SetCaptionPosition(P : TCaptionPos);
begin
  if P <> fCaptionPos then begin
    fCaptionPos:=P;
    ForceRedraw;
  end;
end;

{------------------------------------------------------------------------------}
procedure TAnalogMeter.SetBackground(const Value: TBitmap);
begin
  fBackGround.Assign(Value);
  ForceRedraw;
end;

{------------------------------------------------------------------------------}
procedure TAnalogMeter.SetShowBackgound(const Value: Boolean);
begin
  If Value <> fShowBackground then begin
    fShowBackground := Value;
    ForceRedraw;
  end;
end;

{------------------------------------------------------------------------------}
procedure TAnalogMeter.SetBackGroundLeft(v : Integer);
begin
  If v = fBackGroundLeft then Exit; //nothing to do
  fBackGroundLeft := v;
  If fShowBackground then ForceRedraw;
end;

{------------------------------------------------------------------------------}
procedure TAnalogMeter.SetBackGroundTop(v : Integer);
begin
  If v = fBackGroundTop then Exit; //nothing to do
  fBackGroundTop := v;
  If fShowBackground then ForceRedraw;
end;

{------------------------------------------------------------------------------}
procedure TAnalogMeter.SetTransparentZones(const Value: Boolean);
begin
  If Value <> fTransparentZones then begin
    fTransparentZones := Value;
    ForceRedraw;
  end;
end;
{------------------------------------------------------------------------------}
end.
