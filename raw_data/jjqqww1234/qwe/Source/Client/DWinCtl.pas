unit DWinCtl;

interface

uses
  Windows, Classes, Graphics, SysUtils, Controls, DXDraws, DXClass,
  Forms, DirectX, DIB, Grids, wmUtil, HUtil32, Wil, cliUtil, Dialogs;

const
  WINLEFT    = 60;
  WINTOP     = 60;
  WINRIGHT   = 800 - 60;
  BOTTOMEDGE = 600 - 30;  //윈도의 Bottom이 WINBOTTOM을 넘을 수 없음.

type
  TClickSound    = (csNone, csStone, csGlass, csNorm);
  TDControl      = class;
  TOnDirectPaint = procedure(Sender: TObject; dsurface: TDirectDrawSurface) of object;
  TOnKeyPress = procedure(Sender: TObject; var Key: char) of object;
  TOnKeyDown = procedure(Sender: TObject; var Key: word; Shift: TShiftState) of object;
  TOnMouseMove = procedure(Sender: TObject; Shift: TShiftState;
    X, Y: integer) of object;
  TOnMouseDown = procedure(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: integer) of object;
  TOnMouseUp = procedure(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: integer) of object;
  TOnClick   = procedure(Sender: TObject) of object;
  TOnClickEx = procedure(Sender: TObject; X, Y: integer) of object;
  TOnInRealArea = procedure(Sender: TObject; X, Y: integer;
    var IsRealArea: boolean) of object;
  TOnGridSelect = procedure(Sender: TObject; ACol, ARow: integer;
    Shift: TShiftState) of object;
  TOnGridPaint = procedure(Sender: TObject; ACol, ARow: integer;
    Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface) of object;
  TOnClickSound = procedure(Sender: TObject; Clicksound: TClickSound) of object;

  TDControl = class(TCustomControl)
  private
    FCaption:      string;
    FDParent:      TDControl;
    FEnableFocus:  boolean;
    FOnDirectPaint: TOnDirectPaint;
    FOnKeyPress:   TOnKeyPress;
    FOnKeyDown:    TOnKeyDown;
    FOnMouseMove:  TOnMouseMove;
    FOnMouseDown:  TOnMouseDown;
    FOnMouseUp:    TOnMouseUp;
    FOnDblClick:   TNotifyEvent;
    FOnClick:      TOnClickEx;
    FOnInRealArea: TOnInRealArea;
    FOnBackgroundClick: TOnClick;
    procedure SetCaption(str: string);
  protected
    FVisible: boolean;
  public
    Background: boolean;
    DControls: TList;
    //FaceSurface: TDirectDrawSurface;
    WLib:      TWMImages;
    FaceIndex: integer;
    WantReturn: boolean; //Background일때, Click의 사용 여부..

    AlphaBlend: Boolean;
    AlphaBlendValue: Byte;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Loaded; override;
    function SurfaceX(x: integer): integer;
    function SurfaceY(y: integer): integer;
    function LocalX(x: integer): integer;
    function LocalY(y: integer): integer;
    procedure AddChild(dcon: TDControl);
    procedure ChangeChildOrder(dcon: TDControl);
    function InRange(x, y: integer): boolean;
    function KeyPress(var Key: char): boolean; dynamic;
    function KeyDown(var Key: word; Shift: TShiftState): boolean; dynamic;
    function MouseMove(Shift: TShiftState; X, Y: integer): boolean; dynamic;
    function MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer): boolean; dynamic;
    function MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer): boolean; dynamic;
    function DblClick(X, Y: integer): boolean; dynamic;
    function Click(X, Y: integer): boolean; dynamic;
    function CanFocusMsg: boolean;

    procedure SetImgIndex(Lib: TWMImages; index: integer);
    procedure DirectPaint(dsurface: TDirectDrawSurface); dynamic;

  published
    property OnDirectPaint: TOnDirectPaint Read FOnDirectPaint Write FOnDirectPaint;
    property OnKeyPress: TOnKeyPress Read FOnKeyPress Write FOnKeyPress;
    property OnKeyDown: TOnKeyDown Read FOnKeyDown Write FOnKeyDown;
    property OnMouseMove: TOnMouseMove Read FOnMouseMove Write FOnMouseMove;
    property OnMouseDown: TOnMouseDown Read FOnMouseDown Write FOnMouseDown;
    property OnMouseUp: TOnMouseUp Read FOnMouseUp Write FOnMouseUp;
    property OnDblClick: TNotifyEvent Read FOnDblClick Write FOnDblClick;
    property OnClick: TOnClickEx Read FOnClick Write FOnClick;
    property OnInRealArea: TOnInRealArea Read FOnInRealArea Write FOnInRealArea;
    property OnBackgroundClick: TOnClick Read FOnBackgroundClick
      Write FOnBackgroundClick;
    property Caption: string Read FCaption Write SetCaption;
    property DParent: TDControl Read FDParent Write FDParent;
    property Visible: boolean Read FVisible Write FVisible;
    property EnableFocus: boolean Read FEnableFocus Write FEnableFocus;
    property Color;
    property Font;
    property Hint;
    property ShowHint;
    property Align;
  end;

  TDButton = class(TDControl)
  private
    FClickSound:   TClickSound;
    FOnClick:      TOnClickEx;
    FOnClickSound: TOnClickSound;
  public
    Downed: boolean;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: integer): boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer): boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer): boolean; override;
  published
    property ClickCount: TClickSound Read FClickSound Write FClickSound;
    property OnClick: TOnClickEx Read FOnClick Write FOnClick;
    property OnClickSound: TOnClickSound Read FOnClickSound Write FOnClickSound;
  end;

  TDGrid = class(TDControl)
  private
    FColCount, FRowCount: integer;
    FColWidth, FRowHeight: integer;
    FViewTopLine: integer;
    SelectCell:   TPoint;
    DownPos:      TPoint;
    FOnGridSelect: TOnGridSelect;
    FOnGridMouseMove: TOnGridSelect;
    FOnGridPaint: TOnGridPaint;
    function GetColRow(x, y: integer; var acol, arow: integer): boolean;
  public
    CX, CY:   integer;
    Col, Row: integer;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: integer): boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer): boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer): boolean; override;
    function Click(X, Y: integer): boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
  published
    property ColCount: integer Read FColCount Write FColCount;
    property RowCount: integer Read FRowCount Write FRowCount;
    property ColWidth: integer Read FColWidth Write FColWidth;
    property RowHeight: integer Read FRowHeight Write FRowHeight;
    property ViewTopLine: integer Read FViewTopLine Write FViewTopLine;
    property OnGridSelect: TOnGridSelect Read FOnGridSelect Write FOnGridSelect;
    property OnGridMouseMove: TOnGridSelect Read FOnGridMouseMove
      Write FOnGridMouseMove;
    property OnGridPaint: TOnGridPaint Read FOnGridPaint Write FOnGridPaint;
  end;

  TDWindow = class(TDButton)
  private
    FFloating: boolean;
  protected
    procedure SetVisible(flag: boolean);
  public
    SpotX, SpotY: integer;
    DialogResult: TModalResult;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: integer): boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer): boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer): boolean; override;
    procedure Show;
    function ShowModal: integer;
  published
    property Visible: boolean Read FVisible Write SetVisible;
    property Floating: boolean Read FFloating Write FFloating;
  end;


  TDWinManager = class(TComponent)
  private
  public
    DWinList: TList; //list of TDControl;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddDControl(dcon: TDControl; Visible: boolean);
    procedure DelDControl(dcon: TDControl);
    procedure ClearAll;

    function KeyPress(var Key: char): boolean;
    function KeyDown(var Key: word; Shift: TShiftState): boolean;
    function MouseMove(Shift: TShiftState; X, Y: integer): boolean;
    function MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer): boolean;
    function MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer): boolean;
    function DblClick(X, Y: integer): boolean;
    function Click(X, Y: integer): boolean;
    procedure DirectPaint(dsurface: TDirectDrawSurface);
  end;

procedure Register;
procedure SetDFocus(dcon: TDControl);
procedure ReleaseDFocus;
procedure SetDCapture(dcon: TDControl);
procedure ReleaseDCapture;

var
  MouseCaptureControl: TDControl; //mouse message
  FocusedControl: TDControl;      //Key message
  MainWinHandle: integer;
  ModalDWindow:  TDControl;


implementation


procedure Register;
begin
  RegisterComponents('Zura', [TDWinManager, TDControl, TDButton, TDGrid, TDWindow]);
end;


procedure SetDFocus(dcon: TDControl);
begin
  FocusedControl := dcon;
end;

procedure ReleaseDFocus;
begin
  FocusedControl := nil;
end;

procedure SetDCapture(dcon: TDControl);
begin
  SetCapture(MainWinHandle);
  MouseCaptureControl := dcon;
end;

procedure ReleaseDCapture;
begin
  ReleaseCapture;
  MouseCaptureControl := nil;
end;

{----------------------------- TDControl -------------------------------}

constructor TDControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DParent := nil;
  inherited Visible := False;
  FEnableFocus := False;
  Background := False;

  FOnDirectPaint := nil;
  FOnKeyPress := nil;
  FOnKeyDown := nil;
  FOnMouseMove := nil;
  FOnMouseDown := nil;
  FOnMouseUp := nil;
  FOnInRealArea := nil;
  DControls := TList.Create;
  FDParent := nil;

  Width     := 80;
  Height    := 24;
  FCaption  := '';
  FVisible  := True;
  //FaceSurface := nil;
  WLib      := nil;
  WantReturn:= False;
  FaceIndex := 0;

  AlphaBlend:= False;
  AlphaBlendValue := 255;
end;

destructor TDControl.Destroy;
begin
  DControls.Free;
  inherited Destroy;
end;

procedure TDControl.SetCaption(str: string);
begin
  FCaption := str;
  if csDesigning in ComponentState then begin
    Refresh;
  end;
end;

procedure TDControl.Paint;
begin
  if csDesigning in ComponentState then begin
    if self is TDWindow then begin
      with Canvas do begin
        Pen.Color := clBlack;
        MoveTo(0, 0);
        LineTo(Width - 1, 0);
        LineTo(Width - 1, Height - 1);
        LineTo(0, Height - 1);
        LineTo(0, 0);
        LineTo(Width - 1, Height - 1);
        MoveTo(Width - 1, 0);
        LineTo(0, Height - 1);
        TextOut((Width - TextWidth(Caption)) div 2,
          (Height - TextHeight(Caption)) div 2, Caption);
      end;
    end else begin
      with Canvas do begin
        Pen.Color := clBlack;
        MoveTo(0, 0);
        LineTo(Width - 1, 0);
        LineTo(Width - 1, Height - 1);
        LineTo(0, Height - 1);
        LineTo(0, 0);
        TextOut((Width - TextWidth(Caption)) div 2,
          (Height - TextHeight(Caption)) div 2, Caption);
      end;
    end;
  end;
end;

procedure TDControl.Loaded;
var
  i:    integer;
  dcon: TDControl;
begin
  if not (csDesigning in ComponentState) then begin
    if Parent <> nil then
      for i := 0 to TControl(Parent).ComponentCount - 1 do begin
        if TControl(Parent).Components[i] is TDControl then begin
          dcon := TDControl(TControl(Parent).Components[i]);
          if dcon.DParent = self then begin
            AddChild(dcon);
          end;
        end;
      end;
  end;
end;

//지역 좌표를 전체 좌표로 바꿈
function TDControl.SurfaceX(x: integer): integer;
var
  d: TDControl;
begin
  d := self;
  while True do begin
    if d.DParent = nil then
      break;
    x := x + d.DParent.Left;
    d := d.DParent;
  end;
  Result := x;
end;

function TDControl.SurfaceY(y: integer): integer;
var
  d: TDControl;
begin
  d := self;
  while True do begin
    if d.DParent = nil then
      break;
    y := y + d.DParent.Top;
    d := d.DParent;
  end;
  Result := y;
end;

//전체좌표를 객체의 좌표로 바꿈
function TDControl.LocalX(x: integer): integer;
var
  d: TDControl;
begin
  d := self;
  while True do begin
    if d.DParent = nil then
      break;
    x := x - d.DParent.Left;
    d := d.DParent;
  end;
  Result := x;
end;

function TDControl.LocalY(y: integer): integer;
var
  d: TDControl;
begin
  d := self;
  while True do begin
    if d.DParent = nil then
      break;
    y := y - d.DParent.Top;
    d := d.DParent;
  end;
  Result := y;
end;

procedure TDControl.AddChild(dcon: TDControl);
begin
  DControls.Add(Pointer(dcon));
end;

procedure TDControl.ChangeChildOrder(dcon: TDControl);
var
  i: integer;
begin
  if not (dcon is TDWindow) then
    exit;
  if TDWindow(dcon).Floating then begin
    for i := 0 to DControls.Count - 1 do begin
      if dcon = DControls[i] then begin
        DControls.Delete(i);
        break;
      end;
    end;
    DControls.Add(dcon);
  end;
end;

function TDControl.InRange(x, y: integer): boolean;
var
  inrange: boolean;
  d: TDirectDrawSurface;
begin
  if (x >= Left) and (x < Left + Width) and (y >= Top) and (y < Top + Height) then begin
    inrange := True;
    if Assigned(FOnInRealArea) then
      FOnInRealArea(self, x - Left, y - Top, inrange)
    else if WLib <> nil then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        if d.Pixels[x - Left, y - Top] <= 0 then
          inrange := False;
    end;
    Result := inrange;
  end else
    Result := False;
end;

function TDControl.KeyPress(var Key: char): boolean;
var
  i: integer;
begin
  Result := False;
  if Background then
    exit;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).KeyPress(Key) then begin
        Result := True;
        exit;
      end;
  if (FocusedControl = self) then begin
    if Assigned(FOnKeyPress) then
      FOnKeyPress(self, Key);
    Result := True;
  end;
end;

function TDControl.KeyDown(var Key: word; Shift: TShiftState): boolean;
var
  i: integer;
begin
  Result := False;
  if Background then
    exit;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).KeyDown(Key, Shift) then begin
        Result := True;
        exit;
      end;
  if (FocusedControl = self) then begin
    if Assigned(FOnKeyDown) then
      FOnKeyDown(self, Key, Shift);
    Result := True;
  end;
end;

function TDControl.CanFocusMsg: boolean;
begin
  if (MouseCaptureControl = nil) or ((MouseCaptureControl <> nil) and
    ((MouseCaptureControl = self) or (MouseCaptureControl = DParent))) then
    Result := True
  else
    Result := False;
end;

function TDControl.MouseMove(Shift: TShiftState; X, Y: integer): boolean;
var
  i: integer;
begin
  Result := False;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).MouseMove(Shift, X - Left, Y - Top) then begin
        Result := True;
        exit;
      end;

  if (MouseCaptureControl <> nil) then begin //MouseCapture 이면 자신이 우선
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnMouseMove) then
        FOnMouseMove(self, Shift, X, Y);
      Result := True;
    end;
    exit;
  end;

  if Background then
    exit;
  if InRange(X, Y) then begin
    if Assigned(FOnMouseMove) then
      FOnMouseMove(self, Shift, X, Y);
    Result := True;
  end;
end;

function TDControl.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer): boolean;
var
  i: integer;
begin
  Result := False;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).MouseDown(Button, Shift, X - Left, Y - Top) then begin
        Result := True;
        exit;
      end;
  if Background then begin
    if Assigned(FOnBackgroundClick) then begin
      WantReturn := False;
      FOnBackgroundClick(self);
      if WantReturn then
        Result := True;
    end;
    ReleaseDFocus;
    exit;
  end;
  if CanFocusMsg then begin
    if InRange(X, Y) or (MouseCaptureControl = self) then begin
      if Assigned(FOnMouseDown) then
        FOnMouseDown(self, Button, Shift, X, Y);
      if EnableFocus then
        SetDFocus(self);
      //else ReleaseDFocus;
      Result := True;
    end;
  end;
end;

function TDControl.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer): boolean;
var
  i: integer;
begin
  Result := False;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).MouseUp(Button, Shift, X - Left, Y - Top) then begin
        Result := True;
        exit;
      end;

  if (MouseCaptureControl <> nil) then begin //MouseCapture 이면 자신이 우선
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnMouseUp) then
        FOnMouseUp(self, Button, Shift, X, Y);
      Result := True;
    end;
    exit;
  end;

  if Background then
    exit;
  if InRange(X, Y) then begin
    if Assigned(FOnMouseUp) then
      FOnMouseUp(self, Button, Shift, X, Y);
    Result := True;
  end;
end;

function TDControl.DblClick(X, Y: integer): boolean;
var
  i: integer;
begin
  Result := False;
  if (MouseCaptureControl <> nil) then begin //MouseCapture 이면 자신이 우선
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnDblClick) then
        FOnDblClick(self);
      Result := True;
    end;
    exit;
  end;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).DblClick(X - Left, Y - Top) then begin
        Result := True;
        exit;
      end;
  if Background then
    exit;
  if InRange(X, Y) then begin
    if Assigned(FOnDblClick) then
      FOnDblClick(self);
    Result := True;
  end;
end;

function TDControl.Click(X, Y: integer): boolean;
var
  i: integer;
begin
  Result := False;
  if (MouseCaptureControl <> nil) then begin //MouseCapture 이면 자신이 우선
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnClick) then
        FOnClick(self, X, Y);
      Result := True;
    end;
    exit;
  end;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).Click(X - Left, Y - Top) then begin
        Result := True;
        exit;
      end;
  if Background then
    exit;
  if InRange(X, Y) then begin
    if Assigned(FOnClick) then
      FOnClick(self, X, Y);
    Result := True;
  end;
end;

procedure TDControl.SetImgIndex(Lib: TWMImages; index: integer);
var
  d: TDirectDrawSurface;
begin
  //FaceSurface := dsurface;
  if Lib <> nil then begin
    d    := Lib.Images[index];
    WLib := Lib;
    FaceIndex := index;
    if d <> nil then begin
      Width  := d.Width;
      Height := d.Height;
    end;
  end;
end;

procedure TDControl.DirectPaint(dsurface: TDirectDrawSurface);
var
  i: integer;
  d: TDirectDrawSurface;
  DestRect: TRect;
begin
  if Assigned(FOnDirectPaint) then
    FOnDirectPaint(self, dsurface)
  else if WLib <> nil then begin
    d := WLib.Images[FaceIndex];
    if d <> nil then begin
      if not AlphaBlend then begin
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
      end else begin
        // NOTE: Need to fix this part for. * Remove the line below.
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

        //with d.ClientRect do
        //  DestRect := Bounds(SurfaceX(Left), SurfaceY(Top), Right - Left, Bottom - Top);

        //DestRect.Left   := SurfaceX(Left);
        //DestRect.Top    := SurfaceY(Top);
        //DestRect.  := d.ClientRect.Right - d.ClientRect.Left;
        //DestRect.Bottom := d.ClientRect.Bottom - d.ClientRect.Top;}
        //dsurface.DrawAlpha(DestRect, d.ClientRect, d, True, AlphaBlendValue);
      end;
    end;
  end;
  for i := 0 to DControls.Count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);
end;


{--------------------- TDButton --------------------------}


constructor TDButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Downed      := False;
  FOnClick    := nil;
  FEnableFocus := True;
  FClickSound := csNone;
end;

function TDButton.MouseMove(Shift: TShiftState; X, Y: integer): boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if (not Background) and (not Result) then begin
    Result := inherited MouseMove(Shift, X, Y);
    if MouseCaptureControl = self then
      if InRange(X, Y) then
        Downed := True
      else
        Downed := False;
  end;
end;

function TDButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer): boolean;
begin
  Result := False;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      Downed := True;
      SetDCapture(self);
    end;
    Result := True;
  end;
end;

function TDButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer): boolean;
begin
  Result := False;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if not Background then begin
      if InRange(X, Y) then begin
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Downed := False;
    Result := True;
    exit;
  end else begin
    ReleaseDCapture;
    Downed := False;
  end;
end;

{------------------------- TDGrid --------------------------}

constructor TDGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColCount     := 8;
  FRowCount     := 5;
  FColWidth     := 36;
  FRowHeight    := 32;
  FOnGridSelect := nil;
  FOnGridMouseMove := nil;
  FOnGridPaint  := nil;
end;

function TDGrid.GetColRow(x, y: integer; var acol, arow: integer): boolean;
begin
  Result := False;
  if InRange(x, y) then begin
    acol   := (x - Left) div FColWidth;
    arow   := (y - Top) div FRowHeight;
    Result := True;
  end;
end;

function TDGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer): boolean;
var
  acol, arow: integer;
begin
  Result := False;
  //   if mbLeft = Button then begin  // 0216 MouseRightButton
  if GetColRow(X, Y, acol, arow) then begin
    SelectCell.X := acol;
    SelectCell.Y := arow;
    DownPos.X    := X;
    DownPos.Y    := Y;
    if mbLeft = Button then
      SetDCapture(self);
    Result := True;
  end;
  //   end;
end;

function TDGrid.MouseMove(Shift: TShiftState; X, Y: integer): boolean;
var
  acol, arow: integer;
begin
  Result := False;
  if InRange(X, Y) then begin
    if GetColRow(X, Y, acol, arow) then begin
      if Assigned(FOnGridMouseMove) then
        FOnGridMouseMove(self, acol, arow, Shift);
    end;
    Result := True;
  end;
end;

function TDGrid.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer): boolean;
var
  acol, arow: integer;
begin

  if mbRight = Button then
    Shift := [ssRight];
  Result := False;
  //   if mbLeft = Button then begin // 0216 MouseRightButton
  if GetColRow(X, Y, acol, arow) then begin
    if (SelectCell.X = acol) and (SelectCell.Y = arow) then begin
      Col := acol;
      Row := arow;
      if Assigned(FOnGridSelect) then
        FOnGridSelect(self, acol, arow, Shift);
    end;
    Result := True;
  end;
  ReleaseDCapture;
  //   end;
end;

function TDGrid.Click(X, Y: integer): boolean;
var
  acol, arow: integer;
begin
  Result := False;
  { if GetColRow (X, Y, acol, arow) then begin
      if Assigned (FOnGridSelect) then
         FOnGridSelect (self, acol, arow, []);
      Result := TRUE;
   end; }
end;

procedure TDGrid.DirectPaint(dsurface: TDirectDrawSurface);
var
  i, j: integer;
  rc:   TRect;
begin
  if Assigned(FOnGridPaint) then
    for i := 0 to FRowCount - 1 do
      for j := 0 to FColCount - 1 do begin
        rc := Rect(Left + j * FColWidth, Top + i * FRowHeight, Left +
          j * (FColWidth + 1) - 1, Top + i * (FRowHeight + 1) - 1);
        if (SelectCell.Y = i) and (SelectCell.X = j) then
          FOnGridPaint(self, j, i, rc, [gdSelected], dsurface)
        else
          FOnGridPaint(self, j, i, rc, [], dsurface);
      end;
end;


{--------------------- TDWindown --------------------------}


constructor TDWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFloating := False;
  FEnableFocus := True;
  Width  := 120;
  Height := 120;
end;

procedure TDWindow.SetVisible(flag: boolean);
begin
  FVisible := flag;
  if Floating then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
end;

function TDWindow.MouseMove(Shift: TShiftState; X, Y: integer): boolean;
var
  al, at: integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result and FFloating and (MouseCaptureControl = self) then begin
    if (SpotX <> X) or (SpotY <> Y) then begin
      al := Left + (X - SpotX);
      at := Top + (Y - SpotY);
      if al + Width < WINLEFT then
        al := WINLEFT - Width;
      if al > WINRIGHT then
        al := WINRIGHT;
      if at + Height < WINTOP then
        at := WINTOP - Height;
      if at + Height > BOTTOMEDGE then
        at := BOTTOMEDGE - Height;
      Left := al;
      Top   := at;
      SpotX := X;
      SpotY := Y;
    end;
  end;
end;

function TDWindow.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer): boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then begin
    if Floating then begin
      if DParent <> nil then
        DParent.ChangeChildOrder(self);
    end;
    SpotX := X;
    SpotY := Y;
  end;
end;

function TDWindow.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer): boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
end;

procedure TDWindow.Show;
begin
  Visible := True;
  if Floating then begin
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
  end;
  if EnableFocus then
    SetDFocus(self);
end;

function TDWindow.ShowModal: integer;
begin
  Result  := 0;
  Visible := True;
  ModalDWindow := self;
  if EnableFocus then
    SetDFocus(self);
end;


{--------------------- TDWinManager --------------------------}


constructor TDWinManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DWinList := TList.Create;
  MouseCaptureControl := nil;
  FocusedControl := nil;
end;

destructor TDWinManager.Destroy;
begin
  DWinList.Free;
  inherited Destroy;
end;

procedure TDWinManager.ClearAll;
begin
  DWinList.Clear;
end;

procedure TDWinManager.AddDControl(dcon: TDControl; Visible: boolean);
begin
  dcon.Visible := Visible;
  DWinList.Add(dcon);
end;

procedure TDWinManager.DelDControl(dcon: TDControl);
var
  i: integer;
begin
  for i := 0 to DWinList.Count - 1 do
    if DWinList[i] = dcon then begin
      DWinList.Delete(i);
      break;
    end;
end;

function TDWinManager.KeyPress(var Key: char): boolean;
var
  i: integer;
begin
  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := KeyPress(Key);
      exit;
    end else
      ModalDWindow := nil;
    Key := #0; //ModalDWindow가 KeyDown을 거치면서 Visible=false로 변하면서
    //KeyPress를 다시거쳐서 ModalDwindow=nil이 된다.
  end;

  if FocusedControl <> nil then begin
    if FocusedControl.Visible then begin
      Result := FocusedControl.KeyPress(Key);
    end else
      ReleaseDFocus;
  end;
   {for i:=0 to DWinList.Count-1 do begin
      if TDControl(DWinList[i]).Visible then begin
         if TDControl(DWinList[i]).KeyPress (Key) then begin
            Result := TRUE;
            break;
         end;
      end;
   end; }
end;

function TDWinManager.KeyDown(var Key: word; Shift: TShiftState): boolean;
var
  i: integer;
begin
  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := KeyDown(Key, Shift);
      exit;
    end else
      MOdalDWindow := nil;
  end;
  if FocusedControl <> nil then begin
    if FocusedControl.Visible then
      Result := FocusedControl.KeyDown(Key, Shift)
    else
      ReleaseDFocus;
  end;
   {for i:=0 to DWinList.Count-1 do begin
      if TDControl(DWinList[i]).Visible then begin
         if TDControl(DWinList[i]).KeyDown (Key, Shift) then begin
            Result := TRUE;
            break;
         end;
      end;
   end; }
end;

function TDWinManager.MouseMove(Shift: TShiftState; X, Y: integer): boolean;
var
  i: integer;
begin
  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        MouseMove(Shift, LocalX(X), LocalY(Y));
      Result := True;
      exit;
    end else
      MOdalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseMove(Shift, LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.Count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).MouseMove(Shift, X, Y) then begin
          Result := True;
          break;
        end;
      end;
    end;
end;

function TDWinManager.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer): boolean;
var
  i: integer;
begin
  Result := False;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        MouseDown(Button, Shift, LocalX(X), LocalY(Y));
      Result := True;
      exit;
    end else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseDown(Button, Shift, LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.Count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).MouseDown(Button, Shift, X, Y) then begin
          Result := True;
          break;
        end;
      end;
    end;
end;

function TDWinManager.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer): boolean;
var
  i: integer;
begin
  Result := True;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
      exit;
    end else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.Count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).MouseUp(Button, Shift, X, Y) then begin
          Result := True;
          break;
        end;
      end;
    end;
end;

function TDWinManager.DblClick(X, Y: integer): boolean;
var
  i: integer;
begin
  Result := True;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := DblClick(LocalX(X), LocalY(Y));
      exit;
    end else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := DblClick(LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.Count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).DblClick(X, Y) then begin
          Result := True;
          break;
        end;
      end;
    end;
end;

function TDWinManager.Click(X, Y: integer): boolean;
var
  i: integer;
begin
  Result := True;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := Click(LocalX(X), LocalY(Y));
      exit;
    end else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := Click(LocalX(X), LocalY(Y));
  end else
    for i := 0 to DWinList.Count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).Click(X, Y) then begin
          Result := True;
          break;
        end;
      end;
    end;
end;

procedure TDWinManager.DirectPaint(dsurface: TDirectDrawSurface);
var
  i: integer;
begin
  for i := 0 to DWinList.Count - 1 do begin
    if TDControl(DWinList[i]).Visible then begin
      TDControl(DWinList[i]).DirectPaint(dsurface);
    end;
  end;
  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then
      with ModalDWindow do
        DirectPaint(dsurface);
  end;
end;

end.
