{Copyright (c) 2023 Stephan Breer

This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
}

unit RPGTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRABitmap;
  
 const
  MAXTOKENANIMSTEPS = 20;

function Map(Val, InValStart, InValEnd, OutValStart, OutValEnd: Double): Double;

type

  TGridType = (gtRect, gtHexH, gtHexV);

  TToken = class
    private
      FGlyph: TBGRABitmap;
      FPath: string;
      FXPos, FYPos,
      FXStartPos, FYStartPos,
      FXTargetPos, FYTargetPos,
      FWidth, FHeight: Integer;
      FAngle: Double;
      FOverlayIdx: Integer;
      FVisible: Boolean;
      FGridSlotsX, FGridSlotsY: Integer;
      FCurAnimationStep: Integer;
      FIsMoving: Boolean;
      procedure SetXPos(val: Integer);
      procedure SetYPos(val: integer);
      function GetXPos: Integer;
      function GetYPos: Integer;
      procedure SetAngle(val: Double);
    public
      constructor Create(Path: string; X, Y, pWidth, pHeight: Integer);
      destructor Destroy; override;
      procedure SnapToGrid(GridSizeX, GridSizeY, XOffset, YOffset: Single; GridType: TGridType);
      procedure StartAnimation;
      procedure StopAnimation;
      procedure DoAnimationStep;
      function GetBoundingRect: TRect;
      property XPos: Integer read GetXPos write SetXPos;
      property YPos: Integer read GetYPos write SetYPos;
      property XEndPos: Integer read FXTargetPos;     
      property YEndPos: Integer read FYTargetPos;
      property Width: Integer read FWidth write FWidth;
      property Height: Integer read FHeight write FHeight;
      property Visible: Boolean read FVisible write FVisible;
      property GridSlotsX: Integer read FGridSlotsX write FGridSlotsX;
      property GridSlotsY: Integer read FGridSlotsY write FGridSlotsY;
      property Angle: Double read FAngle write SetAngle;
      property OverlayIdx: Integer read FOverlayIdx write FOverlayIdx;
      property Glyph: TBGRABitmap read FGlyph;
      property IsMoving: Boolean read FIsMoving;
      property Path: string read FPath;
  end;


// Easings
type TEasingType = (etLinear,
                    etOutQuad,
                    etInQuad,
                    etInOutQuad,
                    etInCubic,
                    etOutCubic,
                    etInOutCubic,
                    etInQuart,
                    etOutQuart,
                    etInOutQuart,
                    etInQuint,
                    etOutQuint,
                    etInOutQuint,
                    etInSine,
                    etOutSine,
                    etInOutSine,
                    etInExpo,
                    etOutExpo,
                    etInOutExpo,
                    etInCirc,
                    etOutCirc,
                    etInOutCirc,
                    etInElastic,
                    etOutElastic,
                    etInOutElastic,
                    etInBack,
                    etOutBack,
                    etInOutBack,
                    etInBounce,
                    etOutBounce,
                    etInOutBounce,
                    etSmoothStep,
                    etSmootherStep);

function Ease(Time, StartVal, ChangeAmt, Duration: Double; eType: TEasingType): Double;


implementation

uses
  Math;


{ TToken }

constructor TToken.Create(Path: string; X, Y, pWidth, pHeight: Integer);
begin
  inherited Create;
  FXPos := X;
  FYPos := Y;
  FXTargetPos := X;
  FYTargetPos := Y; 
  FXStartPos := X;
  FYStartPos := Y;
  FWidth := pWidth;
  FHeight := pHeight;
  FVisible := True;
  FIsMoving := False;
  FGridSlotsX := 1;
  FGridSlotsY := 1;
  FOverlayIdx := -1;
  FCurAnimationStep := 0;
  FPath := Path;
  FGlyph := TBGRABitmap.Create(Path);
end;

destructor TToken.Destroy;
begin
  FGlyph.Free;
  inherited;
end;

procedure TToken.SnapToGrid(GridSizeX, GridSizeY, XOffset, YOffset: Single; GridType: TGridType);
var
  count: Integer;
  tmpGridSize: Single;
begin
  if GridType = gtRect then
  begin
    XPos := Round(Round((FXTargetPos - XOffset - FWidth / 2) / GridSizeX) * GridSizeX + XOffset + (FGridSlotsX * GridSizeX / 2));
    YPos := Round(Round((FYTargetPos - YOffset - FHeight / 2) / GridSizeY) * GridSizeY + YOffset +(FGridSlotsY * GridSizeY / 2));
  end
  else if GridType = gtHexH then
  begin
    tmpGridSize := GridSizeY * 3 / 4;
    Count := Round((FYTargetPos - YOffset - FHeight / 2) / tmpGridSize);
    YPos := Round(Count * tmpGridSize + YOffset +(FGridSlotsY * GridSizeY / 2));
    if Odd(Count) then
      XOffset := XOffset + GridSizeX / 2;
    XPos := Round(Round((FXTargetPos - XOffset - FWidth / 2) / GridSizeX) * GridSizeX + XOffset + (FGridSlotsX * GridSizeX / 2));
  end
  else if GridType = gtHexV then
  begin
    tmpGridSize := GridSizeX * 3 / 4;
    Count := Round((FXTargetPos - XOffset - FWidth / 2) / tmpGridSize);
    XPos := Round(Count * tmpGridSize + XOffset + (FGridSlotsX * GridSizeX / 2));
    if Odd(Count) then
      YOffset := YOffset + GridSizeY / 2;
    YPos := Round(Round((FYTargetPos - YOffset - FHeight / 2) / GridSizeY) * GridSizeY + YOffset +(FGridSlotsY * GridSizeY / 2));
  end;
  if FVisible then
    StartAnimation;
end;

procedure TToken.SetXPos(val: Integer);
begin
  if FVisible then
  begin
    FXStartPos := FXPos;
    FXTargetPos := val;
    if FIsMoving then
      FCurAnimationStep := 0;
  end
  else
  begin
    FXPos := val;
    FXStartPos := val;
    FXTargetPos := val;
  end;
end;

procedure TToken.SetYPos(val: integer);
begin
  if FVisible then
  begin
    FYStartPos := FYPos;
    FYTargetPos := val;
    if FIsMoving then
      FCurAnimationStep := 0;
  end
  else
  begin
    FYPos := val;
    FYStartPos := val;
    FYTargetPos := val;
  end;
end;

function TToken.GetXPos: Integer;
begin
  if FIsMoving then
    Result := FXPos
  else
    Result := FXStartPos;
end;

function TToken.GetYPos: Integer;
begin
if FIsMoving then
  Result := FYPos
else
  Result := FYStartPos;
end;

procedure TToken.SetAngle(val: Double);
begin
  FAngle := val;
  {while FAngle < -PI do
    FAngle := FAngle + PI;
  while FAngle > PI do
    FAngle := FAngle - PI;}
end;

procedure TToken.StartAnimation;
begin
  FIsMoving := True;
  FCurAnimationStep := 0;
end;

procedure TToken.StopAnimation;
begin
  FIsMoving := False;
  FXStartPos := FXPos;
  FYStartPos := FYPos;
end;

procedure TToken.DoAnimationStep;
begin
  if not FIsMoving then
    Exit;
  if FCurAnimationStep = MAXTOKENANIMSTEPS then
  begin
    FXPos := FXTargetPos;
    FYPos := FYTargetPos;
    FXStartPos := FXTargetPos;
    FYStartPos := FYTargetPos;
    FIsMoving := False;
  end
  else
  begin
    Inc(FCurAnimationStep);
    FXPos := Round(Ease(FCurAnimationStep, FXStartPos, FXTargetPos - FXStartPos, MAXTOKENANIMSTEPS, etOutQuad));
    FYPos := Round(Ease(FCurAnimationStep, FYStartPos, FYTargetPos - FYStartPos, MAXTOKENANIMSTEPS, etOutQuad));
  end;
end;

function TToken.GetBoundingRect: TRect;
var
  aSin, aCos: Double;
  MaxX, MaxY, MinX, MinY: Double;
  TransX, TransY: Double;
  pX, pY: array[0..3] of Double;
  i: Integer;
begin
  SinCos(FAngle, aSin, aCos);
  MaxX := -MAXDOUBLE;
  MaxY := -MAXDOUBLE;
  MinX := MAXDOUBLE;
  MinY := MAXDOUBLE;

  pX[0] := FWidth / 2;
  pY[0] := -FHeight / 2;
  px[1] := FWidth / 2;  
  pY[1] := FHeight / 2;
  px[2] := -FWidth / 2;
  pY[2] := FHeight / 2;
  px[3] := -FWidth / 2;
  pY[3] := -FHeight / 2;

  for i := 0 to 3 do
  begin 
    TransX := pX[i] * aCos + pY[i] * aSin;
    TransY := -pX[i] * aSin + pY[i] * aCos;
                                           
    MinX := Min(MinX, TransX);
    MaxX := Max(MaxX, TransX);   
    MinY := Min(MinY, TransY);
    MaxY := Max(MaxY, TransY);
  end;

  Result := Rect(Floor(MinX), Floor(MinY), Ceil(MaxX), Ceil(MaxY));
end;

function Map(Val, InValStart, InValEnd, OutValStart, OutValEnd: Double): Double;
begin
  Result := OutValStart + (OutValEnd - OutValStart) * ((Val - InValStart) / (InValEnd - InValStart));
end;

{ Easing-Functions }

// probably won't need all of these for this project, but wth, I ported them, I'm going to use them

function EaseLinear(Time, StartVal, ChangeAmt, Duration: Double): Double;
begin
  Result := ChangeAmt * (Time / Duration) + StartVal;
end;

function EaseInQuad(Time, StartVal, ChangeAmt, Duration: Double): Double;
begin
  Result := ChangeAmt * Sqr(Time / Duration) + StartVal;
end;

function EaseOutQuad(Time, StartVal, ChangeAmt, Duration: Double): Double;
begin
  Result := -ChangeAmt * (Time / Duration) * ((Time / Duration) - 2) + StartVal;
end;

function EaseInOutQuad(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration * 2;
  if t < 1 then
    Result := ChangeAmt * 0.5 * Sqr(t) + StartVal
  else
    Result := -ChangeAmt * 0.5 * ((t - 1) * (t - 3) - 1) + StartVal;
end;

function EaseInCubic(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration;
  Result := ChangeAmt * t * t * t + StartVal;
end;

function EaseOutCubic(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration - 1;
  Result := ChangeAmt * (t * t * t + 1) + StartVal;
end;

function EaseInOutCubic(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration * 2;
  if t < 1 then
    Result := ChangeAmt * 0.5 * t * t * t + StartVal
  else
    Result := ChangeAmt * 0.5 * ((t - 2) * (t - 2) * (t - 2) + 2) + StartVal;
end;

function EaseInQuart(Time, StartVal, ChangeAmt, Duration: Double): Double;
begin
  Result := ChangeAmt * Sqr(Sqr(Time / Duration)) + StartVal;
end;

function EaseOutQuart(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration - 1;
  Result := -ChangeAmt * (Sqr(Sqr(t)) - 1) + StartVal;
end;

function EaseInOutQuart(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration * 2;
  if t < 1 then
    Result := ChangeAmt * 0.5 * Sqr(Sqr(t)) + StartVal
  else
    Result := -ChangeAmt * 0.5 * (Sqr(Sqr(t - 2)) - 2) + StartVal;
end;

function EaseInQuint(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration;
  Result := ChangeAmt * Sqr(Sqr(t)) * t + StartVal;
end;

function EaseOutQuint(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration - 1;
  Result := ChangeAmt * (Sqr(sqr(t)) * t + 1) + StartVal;
end;

function EaseInOutQuint(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration * 2;
  if t < 1 then
    Result := ChangeAmt * 0.5 * Sqr(Sqr(t)) * t + StartVal
  else
    Result := ChangeAmt * 0.5 * (Sqr(Sqr(t - 2)) * (t - 2) + 2) + StartVal;
end;

function EaseInSine(Time, StartVal, ChangeAmt, Duration: Double): Double;
begin
  Result := -ChangeAmt * Cos(Time / Duration * (PI / 2)) + ChangeAmt + StartVal;
end;

function EaseOutSine(Time, StartVal, ChangeAmt, Duration: Double): Double;
begin
  Result := ChangeAmt * Sin(Time / Duration * (PI / 2)) + StartVal;
end;

function EaseInOutSine(Time, StartVal, ChangeAmt, Duration: Double): Double;
begin
  Result := -ChangeAmt * 0.5 * (Cos(PI * Time / Duration) - 1) + StartVal;
end;

function EaseInExpo(Time, StartVal, ChangeAmt, Duration: Double): Double;
begin
  if SameValue(Time, 0.0) then
    Result := StartVal
  else
    Result := ChangeAmt * Power(2, 10 * (Time / Duration - 1)) + StartVal;
end;

function EaseOutExpo(Time, StartVal, ChangeAmt, Duration: Double): Double;
begin
  if SameValue(Time, Duration) then
    Result := StartVal + ChangeAmt
  else
    Result := ChangeAmt * (-Power(2, -10 * Time / Duration) + 1) + StartVal;
end;

function EaseInOutExpo(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration * 2;
  if SameValue(Time, 0) then
    Result := StartVal
  else if SameValue(Time, Duration) then
    Result := StartVal + ChangeAmt
  else if (t / 2) < 1 then
    Result := ChangeAmt * 0.5 * Power(2, 10 * (t - 1)) + StartVal
  else
    Result := ChangeAmt * 0.5 * (-Power(2, -10 * (t - 1)) + 2) + StartVal;
end;

function EaseInCirc(Time, StartVal, ChangeAmt, Duration: Double): Double;
begin
  Result := -ChangeAmt * (Sqrt(1 - Sqr(Time / Duration)) - 1) + StartVal;
end;

function EaseOutCirc(Time, StartVal, ChangeAmt, Duration: Double): Double;
begin
  Result := ChangeAmt * Sqrt(1 - Sqr(Time / Duration - 1)) + StartVal;
end;

function EaseInOutCirc(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration * 2;
  if t < 1 then
    Result := -ChangeAmt * 0.5 * (Sqrt(1 - Sqr(t)) - 1) + StartVal
  else
    Result := ChangeAmt * 0.5 * (Sqrt(1 - Sqr(t - 2)) + 1) + StartVal;
end;

function EaseInElastic(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration;
  Result := ChangeAmt * Sin(13 * PI / 2 * t) * Power(2, 10 * (t - 1)) + StartVal;
end;

function EaseOutElastic(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration;
  Result := ChangeAmt * (Sin(-13 * PI / 2 * (t + 1)) * Power(2, -10 * t) + 1) + StartVal;
end;

function EaseInOutElastic(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration;
  if t < 0.5 then
    Result := ChangeAmt * 0.5 * Sin(13 * PI * t) * Power(2, 10 * ((2 * t) - 1)) + StartVal
  else
    Result := ChangeAmt * 0.5 * (Sin(-13 * PI * t) * Power(2, -10 * (2 * t - 1)) + 2) + StartVal;
end;

function EaseInBack(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration;
  Result := ChangeAmt * (Sqr(t) * t - t * Sin(t * PI)) + StartVal;
end;

function EaseOutBack(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := 1 - Time / Duration;
  Result := ChangeAmt * (1 - (Sqr(t) * t - t * Sin(t * PI))) + StartVal;
end;

function EaseInOutBack(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  if (Time / Duration) < 0.5 then
  begin
    t := 2 * Time / Duration;
    Result := ChangeAmt * 0.5 * (Sqr(t) * t - t * Sin(t * PI)) + StartVal;
  end
  else
  begin
    t := 2 - 2 * Time / Duration;
    Result := ChangeAmt * (0.5 * (1 - (Sqr(t) * t - t * Sin(t * PI))) + 0.5) + StartVal;
  end;
end;

function EaseOutBounce(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := Time / Duration;
  if t < (1 / 2.75) then
    Result := ChangeAmt * (7.5625 * Sqr(t)) + StartVal
  else if t < (2 / 2.75) then
    Result := ChangeAmt * (7.5625 * Sqr(t - (1.5 / 2.75)) + 0.75) + StartVal
  else if t < (2.5 / 2.75) then
    Result := ChangeAmt * (7.5625 * Sqr(t - (2.25 / 2.75)) + 0.9375) + StartVal
  else
    Result := ChangeAmt * (7.5625 * Sqr(t - (2.625 / 2.75)) + 0.984375) + StartVal;
end;

function EaseInBounce(Time, StartVal, ChangeAmt, Duration: Double): Double;
begin
  Result := ChangeAmt - EaseOutBounce(Duration - Time, 0, ChangeAmt, Duration) + StartVal;
end;

function EaseInOutBounce(Time, StartVal, ChangeAmt, Duration: Double): Double;
begin
  if Time < (Duration / 2) then
    Result := EaseInBounce(Time * 2, 0, ChangeAmt, Duration) * 0.5 + StartVal
  else
    Result := EaseOutBounce(Time * 2 - Duration, 0, ChangeAmt, Duration) * 0.5 + ChangeAmt * 0.5 + StartVal;
end;

function EaseSmoothStep(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := EnsureRange(Time / Duration, 0, 1);
  Result := ChangeAmt * (t * t * (3 - 2 * t)) + StartVal;
end;

function EaseSmootherStep(Time, StartVal, ChangeAmt, Duration: Double): Double;
var t: Double;
begin
  t := EnsureRange(Time / Duration, 0, 1);
  Result := ChangeAmt * (t * t * t * (t * (t * 6 - 15) + 10)) + StartVal;
end;

function Ease(Time, StartVal, ChangeAmt, Duration: Double; eType: TEasingType): Double;
begin
  case eType of
    etLinear      : Result := EaseLinear(Time, StartVal, ChangeAmt, Duration);
    etOutQuad     : Result := EaseOutQuad(Time, StartVal, ChangeAmt, Duration);
    etInQuad      : Result := EaseInQuad(Time, StartVal, ChangeAmt, Duration);
    etInOutQuad   : Result := EaseInOutQuad(Time, StartVal, ChangeAmt, Duration);
    etInCubic     : Result := EaseInCubic(Time, StartVal, ChangeAmt, Duration);
    etOutCubic    : Result := EaseOutCubic(Time, StartVal, ChangeAmt, Duration);
    etInOutCubic  : Result := EaseInOutCubic(Time, StartVal, ChangeAmt, Duration);
    etInQuart     : Result := EaseInQuart(Time, StartVal, ChangeAmt, Duration);
    etOutQuart    : Result := EaseOutQuart(Time, StartVal, ChangeAmt, Duration);
    etInOutQuart  : Result := EaseInOutQuart(Time, StartVal, ChangeAmt, Duration);
    etInQuint     : Result := EaseInQuint(Time, StartVal, ChangeAmt, Duration);
    etOutQuint    : Result := EaseOutQuint(Time, StartVal, ChangeAmt, Duration);
    etInOutQuint  : Result := EaseInOutQuint(Time, StartVal, ChangeAmt, Duration);
    etInSine      : Result := EaseInSine(Time, StartVal, ChangeAmt, Duration);
    etOutSine     : Result := EaseOutSine(Time, StartVal, ChangeAmt, Duration);
    etInOutSine   : Result := EaseInOutSine(Time, StartVal, ChangeAmt, Duration);
    etInExpo      : Result := EaseInExpo(Time, StartVal, ChangeAmt, Duration);
    etOutExpo     : Result := EaseOutExpo(Time, StartVal, ChangeAmt, Duration);
    etInOutExpo   : Result := EaseInOutExpo(Time, StartVal, ChangeAmt, Duration);
    etInCirc      : Result := EaseInCirc(Time, StartVal, ChangeAmt, Duration);
    etOutCirc     : Result := EaseOutCirc(Time, StartVal, ChangeAmt, Duration);
    etInOutCirc   : Result := EaseInOutCirc(Time, StartVal, ChangeAmt, Duration);
    etInElastic   : Result := EaseInElastic(Time, StartVal, ChangeAmt, Duration);
    etOutElastic  : Result := EaseOutElastic(Time, StartVal, ChangeAmt, Duration);
    etInOutElastic: Result := EaseInOutElastic(Time, StartVal, ChangeAmt, Duration);
    etInBack      : Result := EaseInBack(Time, StartVal, ChangeAmt, Duration);
    etOutBack     : Result := EaseOutBack(Time, StartVal, ChangeAmt, Duration);
    etInOutBack   : Result := EaseInOutBack(Time, StartVal, ChangeAmt, Duration);
    etInBounce    : Result := EaseInBounce(Time, StartVal, ChangeAmt, Duration);
    etOutBounce   : Result := EaseOutBounce(Time, StartVal, ChangeAmt, Duration);
    etInOutBounce : Result := EaseInOutBounce(Time, StartVal, ChangeAmt, Duration);
    etSmoothStep  : Result := EaseSmoothStep(Time, StartVal, ChangeAmt, Duration);
    etSmootherStep: Result := EaseSmootherStep(Time, StartVal, ChangeAmt, Duration);
  else
    Result := 0;
  end;
end;

end.

