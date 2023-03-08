unit AMAdvLed;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TLedStateChanged = procedure (Sender: TObject; LedOn: boolean; NumSwitch: LongInt) of object;

  TBorder = (brDefault, brRaised, brLowered);
  TLedType = (ltDiamond, ltEllipsHrz, ltEllipsVrt, ltMoonLeft, ltMoonRight, ltParallelBck,
              ltParallelFwd, ltPentagon, ltRound, ltRectangleHrz, ltRectangleVrt, ltSquare,
              ltTriangleDwn, ltTriangleLeft, ltTriangleRight, ltTriangleUp);

  TAMAdvLed = class(TGraphicControl)
  private
    FBorderStyle: TBorder;
    FColorOff,
    FColorOn: TColor;
    FCtl3D: boolean;
    FLed: TBitmap;
    FLedSrc: TBitmap;
    FLedOn: boolean;
    FLedType: TLedType;
    FNumSwitch: LongInt;
    FLedStateChanged: TLedStateChanged;

    procedure SetLedSrc;
    procedure SetBorderStyle(Value: TBorder);
    procedure SetColor(index: integer; Value: TColor);
    procedure SetCtl3D(Value: boolean);
    procedure SetLedOn(Value: boolean);
    procedure SetLedType(Value: TLedType);
  protected
    procedure CMParentColorChanged(var Message: TWMNoParams); message CM_PARENTCOLORCHANGED;
    procedure Loaded; override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property BorderStyle: TBorder read FBorderStyle write SetBorderStyle default brRaised;
    property ColorOff: TColor index 0 read FColorOff write SetColor default clGreen;
    property ColorOn: TColor index 1 read FColorOn write SetColor default clLime;
    property Ctl3D: boolean read FCtl3D write SetCtl3D default True;
    property LedOn: boolean read FLedOn write SetLedOn default False;
    property LedType: TLedType read FLedType write SetLedType default ltRound;
    property OnLedStateChanged: TLedStateChanged read FLedStateChanged write FLedStateChanged;
    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
  end;

procedure Register;

implementation

//{$R AMAdvLed.res}

procedure TAMAdvLed.SetLedSrc;
var
  LedStr: string;
begin
  LedStr := '';
  case LedType of
    ltDiamond       : LedStr := 'AMDMDLED';
    ltEllipsHrz     : LedStr := 'AMLPSLEDHRZ';
    ltEllipsVrt     : LedStr := 'AMLPSLEDVRT';
    ltMoonLeft      : LedStr := 'AMMONLEDLEFT';
    ltMoonRight     : LedStr := 'AMMONLEDRIGHT';
    ltParallelBck   : LedStr := 'AMPRLLEDBCK';
    ltParallelFwd   : LedStr := 'AMPRLLEDFWT';
    ltPentagon      : LedStr := 'AMPNTLED';
    ltRectangleHrz  : LedStr := 'AMRCTLEDHRZ';
    ltRectangleVrt  : LedStr := 'AMRCTLEDVRT';
    ltRound         : LedStr := 'AMRNDLED';
    ltSquare        : LedStr := 'AMSQRLED';
    ltTriangleDwn   : LedStr := 'AMTRILEDDWN';
    ltTriangleLeft  : LedStr := 'AMTRILEDLEFT';
    ltTriangleUp    : LedStr := 'AMTRILEDUP';
    ltTriangleRight : LedStr := 'AMTRILEDRIGHT';
  else
    LedStr := 'AMRNDLED';
  end;
  case BorderStyle of
    brRaised   : LedStr := LedStr+'3DUP';
    brLowered  : LedStr := LedStr+'3DDWN';
  end;
  if not Ctl3D then LedStr := LedStr+'FLAT';
  FLedSrc.Handle := LoadBitmap(hInstance, PChar(LedStr));
  Repaint;
end;

procedure TAMAdvLed.CMParentColorChanged(var Message: TWMNoParams);
begin
  inherited;
  Repaint;
end;

procedure TAMAdvLed.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    Width := 13;
    Height := 13;
  end;
end;

procedure TAMAdvLed.Paint;
var
  LedRect: TRect;
begin
  LedRect := ClientRect;
  case LedOn of
    True  : FLed.Canvas.Brush.Color := FColorOn;
    False : FLed.Canvas.Brush.Color := FColorOff;
  end;
  FLed.Canvas.BrushCopy(LedRect,FLedSrc,LedRect,clSilver);
  Canvas.Brush.Color := Self.Color;
  Canvas.BrushCopy(ClientRect,FLed,ClientRect,clOlive);
end;

procedure TAMAdvLed.SetBorderStyle(Value: TBorder);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    if Value <> brDefault then FCtl3D := True;
    SetLedSrc;
  end;
end;

procedure TAMAdvLed.SetColor(index: integer; Value: TColor);
begin
  case index of
    0: if Value <> FColorOff then FColorOff := Value;
    1: if Value <> FColorOn then FColorOn := Value;
  end;
  Repaint;
end;

procedure TAMAdvLed.SetCtl3D(Value: boolean);
begin
  if Value <> FCtl3D then
  begin
    FCtl3D := Value;
    if not Value then FBorderStyle := brDefault;
    SetLedSrc;
  end;
end;

procedure TAMAdvLed.SetLedOn(Value: boolean);
begin
  if Value <> FLedOn then
  begin
    FLedOn := Value;
    inc(FNumSwitch);
    if Assigned(FLedStateChanged) then FLedStateChanged(Self, Value, FNumSwitch);
    Repaint;
  end;
end;

procedure TAMAdvLed.SetLedType(Value: TLedType);
begin
  if Value <> FLedType then
  begin
    FLedType := Value;
    SetLedSrc;
  end;
end;

constructor TAMAdvLed.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(0,0,13,13);
  Controlstyle := Controlstyle+[csOpaque];
  FLedSrc := TBitmap.Create;
  FLedSrc.Width := Self.Width;
  FLedSrc.Height := Self.Height;
  FLed := TBitmap.Create;
  FLed.Width := FLedSrc.Width;
  FLed.Height := FLedSrc.Height;
  FBorderStyle := brRaised;
  FColorOff := clGreen;
  FColorOn := clLime;
  FCtl3D := True;
  FLedOn := False;
  FLedType := ltRound;
  FNumSwitch := 0;
  SetLedSrc;
end;

destructor TAMAdvLed.Destroy;
begin
  FLedSrc.Free;
  FLed.Free;
  inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents('Fabricio', [TAMAdvLed]);
end;

end.
