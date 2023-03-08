{Copyright (c) 2023 Stephan Breer

This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
}

unit DisplayForm;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF DEBUG}Windows,{$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  BGRABitmapTypes, BGRABitmap, RPGTypes;

const
  MAXMAPANIMSTEPS = 100;

type

  { TfmDisplay }

  TfmDisplay = class(TForm)
    tMapAnim: TTimer;
    tTokenAnim: TTimer;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DrawPhongFrame(dest: TBGRABitmap);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tTokenAnimTimer(Sender: TObject);
    procedure tMapAnimTimer(Sender: TObject);
  private
    FMapOffsetX, FMapOffsetY: Integer;
    FStartMapOffsetX, FStartMapOffsetY: Integer;
    FTargetMapOffsetX, FTargetMapOffsetY: Integer;
    FCurMapAnimStep: Integer;
    FMapZoom: Double;
    FMapFileName: string;
    FMapPic, FPortrait: TBGRABitmap;
    FPortraitFrame, FInitiativeFrame, FMapFrame: TBGRABitmap;
    FBgPic: TPicture;
    FGridSizeX, FGridSizeY, FGridOffsetX, FGridOffsetY: Single;
    FGridType: TGridType;
    FMarkerX, FMarkerY: Integer;
    FGridColor: TColor;
    FCombatMode: Boolean;
    FPortraitFile: string;

    procedure SetMapFile(FileName: string);
    procedure SetMapOffsetX(val: Integer);
    procedure SetMapOffsetY(val: Integer);
    procedure SetMapZoom(val: Double);
    procedure SetGridSizeX(val: Single);  
    procedure SetGridSizeY(val: Single);
    procedure SetGridOffsetX(val: Single);
    procedure SetGridOffsetY(val: Single);
    procedure SetGridType(val: TGridType);
    procedure SetMarkerX(val: Integer);
    procedure SetMarkerY(val: Integer);
    procedure SetGridColor(val: TColor);
    procedure SetCombatMode(val: Boolean);
    procedure SetPortraitFile(FileName: string);
  public
    property MapFileName: string read FMapFileName write SetMapFile;
    property MapOffsetX: Integer read FMapOffsetX write SetMapOffsetX;
    property MapOffsetY: Integer read FMapOffsetY write SetMapOffsetY;
    property MapZoom: Double read FMapZoom write SetMapZoom;
    property GridSizeX: Single read FGridSizeX write SetGridSizeX;  
    property GridSizeY: Single read FGridSizeY write SetGridSizeY;
    property GridOffsetX: Single read FGridOffsetX write SetGridOffsetX;
    property GridOffsetY: Single read FGridOffsetY write SetGridOffsetY;
    property GridType: TGridType read FGridType write SetGridType;
    property MarkerX: Integer read FMarkerX write SetMarkerX;
    property MarkerY: Integer read FMarkerY write SetMarkerY;
    property GridColor: TColor read FGridColor write SetGridColor;
    property CombatMode: Boolean read FCombatMode write SetCombatMode;
    property PortraitFileName: string read FPortraitFile write SetPortraitFile;
  end;

  TBGRAFrameScanner = class(TBGRACustomScanner)
  private
    FOuterColor, FInnerColor: TBGRAPixel;
    FFrameWidth, FFrameHeight, FFrameSize: Integer;
    function ScanAt(X, Y: Single): TBGRAPixel; override;
  public
    constructor Create(InnerColor, OuterColor:TBGRAPixel; FrameWidth, FrameHeight, FrameSize: Integer);
  end;

var
  fmDisplay: TfmDisplay;


implementation

{$R *.lfm}

uses
  ControllerForm,
  DisplayConst,
  LangStrings,
  LazLogger,
  Math,
  StrUtils,
  bgrabitmappack,
  BGRAGradients,
  BGRATransform;

{ TfmDisplay }

procedure TfmDisplay.SetMapFile(FileName: string);
begin
  FMapFileName := FileName;
  if FileExists(FileName) and MatchText(ExtractFileExt(FileName), ['.jpg', '.jpeg', '.png', '.bmp', '.webp']) then
    FMapPic.LoadFromFile(FileName);
  Invalidate;
end;

procedure TfmDisplay.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := False;
end;

procedure TfmDisplay.FormCreate(Sender: TObject);
begin        
  FMapZoom := 1;
  FCombatMode := False;
  FGridSizeX := 100;
  FGridSizeY := 100;
  FGridColor := clSilver;
  FMapPic := TBGRABitmap.Create(0, 0);
  FPortrait := TBGRABitmap.Create(0, 0);
  FBgPic := TPicture.Create;
  FBgPic.LoadFromResourceName(HINSTANCE, 'PARCHMENT_TILE');
  FPortraitFrame := TBGRABitmap.Create(FRAMESIZE + PORTRAITWIDTH + FRAMESIZE, FRAMESIZE + PORTRAITHEIGHT + FRAMESIZE);
  FInitiativeFrame := TBGRABitmap.Create(FRAMESIZE + INITIATIVEWIDTH + FRAMESIZE, FRAMESIZE + INITIATIVEHEIGHT + FRAMESIZE);
  DrawPhongFrame(FPortraitFrame);
  DrawPhongFrame(FInitiativeFrame);
  //FMapFrame // We draw that one in OnResize, because it is the only one that can change size
end;

procedure TfmDisplay.DrawPhongFrame(dest: TBGRABitmap);
var
  phong: TPhongShading;
  {frame, }heightmap: TBGRABitmap;
  scan: TBGRAFrameScanner;
begin
  //vRect.Inflate(7, 7);
  //frame := TBGRABitmap.Create(vRect.Width, vRect.Height, clWhite);
  heightmap := TBGRABitmap.Create(dest.Width, dest.Height);
  phong := TPhongShading.Create;
  try
    phong.LightPositionZ := 150;
    //phong.LightPosition := Point(10, 10);
    phong.SpecularIndex := 20;
    phong.AmbientFactor := 0.1;
    phong.DiffusionFactor := 0.4;
    phong.SpecularFactor := 0.8;
    phong.LightSourceIntensity := 1000;
    phong.LightSourceDistanceTerm := 200;

    scan := TBGRAFrameScanner.Create(BGRA(65, 65, 65), BGRA(0, 0, 0), dest.Width, dest.Height, FRAMESIZE);
    heightmap.Fill(scan);

    phong.Draw(dest, heightmap, FRAMESIZE, 0, 0, RGBToColor(138, 138, 138));
    dest.EraseRect(Rect(FRAMESIZE, FRAMESIZE, dest.Width - FRAMESIZE, dest.Height - FRAMESIZE), 255);

    //frame.Draw(Canvas, vRect, False);
  finally
    //frame.Free;
    heightmap.Free;
    phong.Free;
    scan.Free;
  end;
end;

procedure TfmDisplay.FormDestroy(Sender: TObject);
begin
  FMapPic.Free;
  FBgPic.Free;
  FPortrait.Free;
  FPortraitFrame.Free;
  FInitiativeFrame.Free;
  if Assigned(FMapFrame) then
    FMapFrame.Free;
end;

procedure TfmDisplay.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  fmController.FormKeyUp(Sender, Key, Shift);
end;

procedure TfmDisplay.SetMapOffsetX(val: Integer);
begin
  //FMapOffsetX := val;
  FStartMapOffsetX := FMapOffsetX;
  FTargetMapOffsetX := val;
  if tMapAnim.Enabled then
    FCurMapAnimStep := 0;
  tMapAnim.Enabled := True;
  Invalidate;
end;

procedure TfmDisplay.SetMapOffsetY(val: Integer);
begin
  //FMapOffsetY := val;
  FStartMapOffsetY := FMapOffsetY;
  FTargetMapOffsetY := val;
  if tMapAnim.Enabled then
    FCurMapAnimStep := 0;
  tMapAnim.Enabled := True;
  Invalidate;
end;

procedure TfmDisplay.SetMapZoom(val: Double);
begin
  FMapZoom := val;
  Invalidate;
end;

procedure TfmDisplay.SetGridSizeX(val: Single);
begin
  FGridSizeX := val;
  Invalidate;
end;
            
procedure TfmDisplay.SetGridSizeY(val: Single);
begin
  FGridSizeY := val;
  Invalidate;
end;

procedure TfmDisplay.SetGridOffsetX(val: Single);
begin
  FGridOffsetX := val;
  Invalidate;
end;

procedure TfmDisplay.SetGridOffsetY(val: Single);
begin
  FGridOffsetY := val;
  Invalidate;
end;

procedure TfmDisplay.SetGridType(val: TGridType);
begin
  FGridType := val;
  Invalidate;
end;

procedure TfmDisplay.SetMarkerX(val: Integer);
begin
  FMarkerX := val;
  Invalidate;
end;

procedure TfmDisplay.SetMarkerY(val: Integer);
begin
  FMarkerY := val;
  Invalidate;
end;

procedure TfmDisplay.SetGridColor(val: TColor);
begin
  FGridColor := val;
  Invalidate;
end;

procedure TfmDisplay.SetCombatMode(val: Boolean);
begin
  FCombatMode := val;
  Invalidate;
end;

procedure TfmDisplay.SetPortraitFile(FileName: string);
begin
  FPortraitFile := FileName;
  if FileExists(FileName) and MatchText(ExtractFileExt(FileName), ['.jpg', '.jpeg', '.png', '.bmp', '.webp']) then
    FPortrait.LoadFromFile(FileName)
  else if Assigned(FPortrait) then
  begin
    FPortrait.Free;
    FPortrait := TBGRABitmap.Create(0, 0);
  end;
  Invalidate;
end;

procedure TfmDisplay.FormPaint(Sender: TObject);
var
  MapSegment, MapSegmentStretched: TBGRABitmap;
  TokenBmp, RotatedBmp, OverlayBmp, OverlayScaled: TBGRABitmap;
  Rotation: TBGRAAffineBitmapTransform;
  MapWidth, MapHeight: Integer;
  i, j, CurGridPos: Integer;
  CurMarkerX, CurMarkerY: Single;
  CurToken: TToken;
  CurTokenPosX, CurTokenPosY: Integer;
  TokenRect, ClipRect, RotatedRect, BoundingRect: TRect;
  MapRect: TRect;
  MaxPortraits: Integer;
  tmpPicture: TPicture;
  CellRect: TRect;
  Hex: array[0..5] of TPoint;
  tmpGridSize: Single;
  {$IFDEF DEBUG}StartTime: Int64;{$ENDIF}

procedure Draw3DFrame(pRect: TRect);
var
  vRect: TRect;
  i: Integer;
begin
  vRect := pRect;
  vRect.Inflate(FRAMESIZE, FRAMESIZE);
  for i := 1 to 3 do
  begin
    Canvas.Pen.Color := RGBToColor(217, 217, 217);
    Canvas.MoveTo(vRect.Left, vRect.Top);
    Canvas.LineTo(vRect.Right, vRect.Top);
    Canvas.Pen.Color := RGBToColor(56, 56, 56);
    Canvas.MoveTo(vRect.Left, vRect.Top);
    Canvas.LineTo(vRect.Left, vRect.Bottom + 1);
    Canvas.MoveTo(vRect.Right, vRect.Top);
    Canvas.LineTo(vRect.Right, vRect.Bottom + 1);
    Canvas.Pen.Color := RGBToColor(38, 38, 38);
    Canvas.MoveTo(vRect.Left, vRect.Bottom);
    Canvas.LineTo(vRect.Right, vRect.Bottom);
    vRect.Inflate(-1, -1);
  end;
  Canvas.Pen.Color := RGBToColor(38, 38, 38);
  Canvas.MoveTo(vRect.Left, vRect.Top);
  Canvas.LineTo(vRect.Right, vRect.Top);
  Canvas.Pen.Color := RGBToColor(67, 67, 67);
  Canvas.MoveTo(vRect.Left, vRect.Top);
  Canvas.LineTo(vRect.Left, vRect.Bottom + 1);
  Canvas.MoveTo(vRect.Right, vRect.Top);
  Canvas.LineTo(vRect.Right, vRect.Bottom + 1);
  Canvas.Pen.Color := RGBToColor(138, 138, 138);
  Canvas.MoveTo(vRect.Left, vRect.Bottom);
  Canvas.LineTo(vRect.Right, vRect.Bottom);
  vRect.Inflate(-1, -1);
  for i := 1 to 3 do
  begin
    Canvas.Pen.Color := RGBToColor(38, 38, 38);
    Canvas.MoveTo(vRect.Left, vRect.Top);
    Canvas.LineTo(vRect.Right, vRect.Top);
    Canvas.Pen.Color := RGBToColor(56, 56, 56);
    Canvas.MoveTo(vRect.Left, vRect.Top);
    Canvas.LineTo(vRect.Left, vRect.Bottom + 1);
    Canvas.MoveTo(vRect.Right, vRect.Top);
    Canvas.LineTo(vRect.Right, vRect.Bottom + 1);
    Canvas.Pen.Color := RGBToColor(138, 138, 138);
    Canvas.MoveTo(vRect.Left, vRect.Bottom);
    Canvas.LineTo(vRect.Right, vRect.Bottom);
    vRect.Inflate(-1, -1);
  end;

end;


begin
  {$IFDEF DEBUG}StartTime := GetTickCount64;{$ENDIF}
  // Background texture
  if (FBgPic.Width > 0) and (FBgPic.Height > 0) then
  begin
    for i := 0 to Ceil(ClientWidth / FBgPic.Width) - 1 do
      for j := 0 to Ceil(ClientHeight / FBgPic.Height) - 1 do
        Canvas.Draw(i * FBgPic.Width, j * FBgPic.Height, FBgPic.Graphic);
  end;

  // Frame for Map
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Width := 1;
  Canvas.Brush.Style := bsClear;
  //Canvas.Brush.Color := clWhite;
  //Canvas.Rectangle(HMARGIN, VMARGIN, ClientWidth - HMARGIN - PORTRAITWIDTH - HMARGIN, ClientHeight - VMARGIN);
  ClipRect := Rect(HMARGIN, VMARGIN, ClientWidth - HMARGIN - PORTRAITWIDTH - HMARGIN, ClientHeight - VMARGIN);
  //DrawPhongFrame(ClipRect);
  if Assigned(FMapFrame) then
    FMapFrame.Draw(Canvas, ClipRect.Left - FRAMESIZE, ClipRect.Top - FRAMESIZE, False);

  // Map
  MapWidth := ClientWidth - VMARGIN - VMARGIN - PORTRAITHEIGHT - VMARGIN;
  MapHeight := ClientHeight - HMARGIN - HMARGIN;
  // MapRect: Rectangle we want to fill with our map, might be smaller than MapWidth * MapHeight
  MapRect := Bounds(HMARGIN, VMARGIN, Round(Min(MapWidth, FMapPic.Width * FMapZoom)), Round(Min(MapHeight, FMapPic.Height * FMapZoom)));
  // We need to trim MapSegment to match the aspect ratio
  MapSegment := TBGRABitmap.Create(Round(MapRect.Width / FMapZoom), Round(MapRect.Height / FMapZoom));
  try
    MapSegment.Canvas.Brush.Style := bsClear;
    MapSegment.Canvas.Pen.Color := clBlack;
    MapSegment.Canvas.FillRect(0, 0, MapSegment.Width, MapSegment.Height);
    if Assigned(FMapPic) then
    begin

      MapSegment.Canvas.CopyRect(Rect(0, 0, MapSegment.Width, MapSegment.Height),
                                 FMapPic.Canvas,
                                 Bounds(Round(FMapOffsetX / FMapZoom), Round(FMapOffsetY / FMapZoom), MapSegment.Width, MapSegment.Height));

      try
        if FMapZoom > 1 then
          MapSegment.ResampleFilter := rfSpline
        else
          MapSegment.ResampleFilter := rfMitchell;
        MapSegmentStretched := MapSegment.Resample(MapRect.Width, MapRect.Height, rmSimpleStretch);

        // Grid
        if fmController.ShowGrid then
        begin
          case FGridType of
            gtRect:
            begin
              // Horizontal lines
              for i := 0 to Ceil(((FMapPic.Height - (FGridOffsetY mod FGridSizeY)) / FGridSizeY)) do
              begin
                CurGridPos := Round((FGridOffsetY + i * FGridSizeY) * FMapZoom - FMapOffsetY);
                if InRange(CurGridPos, 0, MapHeight) then
                begin
                  MapSegmentStretched.DrawLineAntialias(0, CurGridPos,
                                                        MapSegmentStretched.Width, CurGridPos,
                                                        FGridColor, 1);
                end;
              end;
              // Vertical lines
              for i := 0 to Ceil(((FMapPic.Width - (FGridOffsetX mod FGridSizeX)) / FGridSizeX)) do
              begin
                CurGridPos := Round((FGridOffsetX + i * FGridSizeX) * FMapZoom - FMapOffsetX);
                if InRange(CurGridPos, 0, MapWidth) then
                begin
                  MapSegmentStretched.DrawLineAntialias(CurGridPos, 0,
                                                        CurGridPos, MapSegmentStretched.Height,
                                                        FGridColor, 1);
                end;
              end;

            end;
            gtHexH:
            begin
              tmpGridSize := FGridSizeY  * 3 / 4;
              for i := 0 to Ceil(((FMapPic.Height - (FGridOffsetY mod tmpGridSize)) / tmpGridSize)) do
                for j := 0 to Ceil(((FMapPic.Width - (FGridOffsetX mod FGridSizeX)) / FGridSizeX)) do
                begin
                  CellRect := Rect(Round((FGridOffsetX + j * FGridSizeX) * FMapZoom - FMapOffsetX),
                                   Round((FGridOffsetY + i * tmpGridSize) * FMapZoom - FMapOffsetY),
                                   Round((FGridOffsetX + (j + 1) * FGridSizeX) * FMapZoom - FMapOffsetX),
                                   Round((FGridOffsetY + i * tmpGridSize + FGridSizeY) * FMapZoom - FMapOffsetY));
                  if Odd(i) then
                    CellRect.Offset(Round(FGridSizeX  * FMapZoom / 2), 0);
                  Hex[0] := Point(CellRect.Left, CellRect.Bottom - CellRect.Height div 4);
                  Hex[1] := Point(CellRect.Left, CellRect.Top + CellRect.Height div 4);
                  Hex[2] := Point(CellRect.Left + CellRect.Width div 2, CellRect.Top);
                  Hex[3] := Point(CellRect.Right, CellRect.Top + CellRect.Height div 4);
                  Hex[4] := Point(CellRect.Right, CellRect.Bottom - CellRect.Height div 4);
                  Hex[5] := Point(CellRect.Left + CellRect.Width div 2, CellRect.Bottom);
                  MapSegmentStretched.DrawPolygonAntialias(Hex, FGridColor, 1, BGRAPixelTransparent);
                end;
            end;
            gtHexV:
            begin
              tmpGridSize := FGridSizeX  * 3 / 4;
              for i := 0 to Ceil(((FMapPic.Height - (FGridOffsetY mod FGridSizeY)) / FGridSizeY)) do
                for j := 0 to Ceil(((FMapPic.Width - (FGridOffsetX mod tmpGridSize)) / tmpGridSize)) do
                begin
                  CellRect := Rect(Round((FGridOffsetX + j * tmpGridSize) * FMapZoom - FMapOffsetX),
                                   Round((FGridOffsetY + i * FGridSizeY) * FMapZoom - FMapOffsetY),
                                   Round((FGridOffsetX + j * tmpGridSize + FGridSizeX) * FMapZoom - FMapOffsetX),
                                   Round((FGridOffsetY + (i + 1) * FGridSizeY) * FMapZoom - FMapOffsetY));
                  if Odd(j) then
                    CellRect.Offset(0, Round(FGridSizeY  * FMapZoom / 2));
                  Hex[0] := Point(CellRect.Left, CellRect.Top + CellRect.Height div 2);
                  Hex[1] := Point(CellRect.Left + CellRect.Width div 4, CellRect.Top);
                  Hex[2] := Point(CellRect.Right - CellRect.Width div 4, CellRect.Top);
                  Hex[3] := Point(CellRect.Right, CellRect.Top + CellRect.Height div 2);
                  Hex[4] := Point(CellRect.Right - CellRect.Width div 4, CellRect.Bottom);
                  Hex[5] := Point(CellRect.Left + CellRect.Width div 4, CellRect.Bottom);
                  MapSegmentStretched.DrawPolygonAntialias(Hex, FGridColor, 1, BGRAPixelTransparent);
                end;
            end;
          end;
        end;

        // Marker
        if fmController.ShowMarker then
        begin
          Canvas.Pen.Color := clRed;
          Canvas.Pen.Width := 2;
          Canvas.Brush.Style := bsClear;
          CurMarkerX := FMarkerX * FMapZoom - FMapOffsetX;
          CurMarkerY := FMarkerY * FMapZoom - FMapOffsetY;
          if InRange(CurMarkerX, 0, MapWidth) and InRange(CurMarkerY, 0, MapHeight) then
          begin
            MapSegmentStretched.EllipseAntialias(CurMarkerX, CurMarkerY, 10, 10, clRed, 2, BGRAPixelTransparent);

            MapSegmentStretched.DrawLineAntialias(CurMarkerX - 15, CurMarkerY, CurMarkerX - 5, CurMarkerY, clRed, 2);
            MapSegmentStretched.DrawLineAntialias(CurMarkerX + 5, CurMarkerY, CurMarkerX + 15, CurMarkerY, clRed, 2);

            MapSegmentStretched.DrawLineAntialias(CurMarkerX, CurMarkerY - 15, CurMarkerX, CurMarkerY - 5, clRed, 2);
            MapSegmentStretched.DrawLineAntialias(CurMarkerX, CurMarkerY + 5, CurMarkerX, CurMarkerY + 15, clRed, 2);
          end;
        end;

        // Token
        if fmController.ShowTokens then
        begin
          for i := 0 to fmController.GetTokenCount - 1 do
          begin
            CurToken := fmController.GetToken(i);
            if CurToken.Visible then
            begin
              CurTokenPosX := Round(CurToken.XPos * FMapZoom - FMapOffsetX - (FMapZoom * CurToken.Width / 2));
              CurTokenPosY := Round(CurToken.YPos * FMapZoom - FMapOffsetY - (FMapZoom * CurToken.Height / 2));
              TokenRect := Bounds(CurTokenPosX, CurTokenPosY,
                                  Round(CurToken.Width * FMapZoom),
                                  Round(CurToken.Height * FMapZoom));

              TokenBmp := CurToken.Glyph.Resample(Round(CurToken.Width), Round(CurToken.Height), rmSimpleStretch);
              try         
                BoundingRect := CurToken.GetBoundingRect;
                Rotation := TBGRAAffineBitmapTransform.Create(TokenBmp);
                Rotation.Translate(-TokenBmp.Width / 2, -TokenBmp.Height / 2);
                Rotation.RotateRad(CurToken.Angle);
                //Rotation.Translate(Hypot(CurToken.Width, CurToken.Height) * SQRT05, Hypot(CurToken.Width, CurToken.Height) * SQRT05);
                Rotation.Translate(BoundingRect.Width / 2, BoundingRect.Height / 2); 
                Rotation.Scale(FMapZoom, FMapZoom);
                try
                  //RotatedBmp := TBGRABitmap.Create(Round(Hypot(CurToken.Width, CurToken.Height) * SQRT2),
                  //                                 Round(Hypot(CurToken.Width, CurToken.Height) * SQRT2));
                  RotatedBmp := TBGRABitmap.Create(Round(BoundingRect.Width * FMapZoom),
                                               Round(BoundingRect.Height * FMapZoom));
                  RotatedBmp.Fill(Rotation, dmDrawWithTransparencY);
                  RotatedRect := Bounds(TokenRect.Left - RotatedBmp.Width div 2 + Round(TokenBmp.Width * FMapZoom / 2),
                                        TokenRect.Top - RotatedBmp.Height div 2 + Round(TokenBmp.Height * FMapZoom / 2),
                                        RotatedBmp.Width,
                                        RotatedBmp.Height);
                  // Add overlay
                  OverlayBmp := fmController.GetOverlay(CurToken.OverlayIdx);
                  if Assigned(OverlayBmp) then
                  begin
                    OverlayScaled := OverlayBmp.Resample(Round(OverlayBmp.Width * FMapZoom), Round(OverlayBmp.Height  * FMapZoom), rmSimpleStretch);
                    OverlayScaled.Draw(RotatedBmp.Canvas,
                                       Round(RotatedBmp.Width - TokenBmp.Width * FMapZoom) div 2,
                                       Round(RotatedBmp.Height - TokenBmp.Height * FMapZoom) div 2,
                                       False);
                    OverlayScaled.Free;
                  end;
                  RotatedBmp.Draw(MapSegmentStretched.Canvas,
                                  RotatedRect,
                                  False);
                finally
                  Rotation.Free;
                  RotatedBmp.Free;
                end;
              finally
                TokenBmp.Free;
              end;
            end;
          end;
        end;

        MapSegmentStretched.Draw(Canvas, MapRect);

      finally
        MapSegmentStretched.Free;
      end;
    end;
  finally
    MapSegment.Free;
  end;
     
  {$IFDEF DEBUG}OutputDebugString(PChar(IntToStr(GetTickCount64 - StartTime) + ' ms'));{$ENDIF}
  // Frame of Portrait
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Width := 1;
  Canvas.Brush.Style := bsClear;
  ClipRect := Rect(ClientWidth - HMARGIN - PORTRAITWIDTH, VMARGIN, ClientWidth - HMARGIN, PORTRAITHEIGHT + VMARGIN);
  //Draw3DFrame(ClipRect);
  //DrawPhongFrame(ClipRect);
  FPortraitFrame.Draw(Canvas, ClipRect.Left - FRAMESIZE, ClipRect.Top - FRAMESIZE, False);

  if not FCombatMode then
  begin
    // Portrait, if assigned
    if FPortrait.Width > 0 then
    begin
      TokenBmp := FPortrait.Resample(PORTRAITWIDTH, PORTRAITHEIGHT);
      TokenBmp.Draw(Canvas, Bounds(ClientWidth - HMARGIN - PORTRAITWIDTH, VMARGIN, PORTRAITWIDTH, PORTRAITHEIGHT), False);
      //Canvas.StretchDraw(Bounds(ClientWidth - HMARGIN - PORTRAITWIDTH, VMARGIN, PORTRAITWIDTH, PORTRAITHEIGHT), FPortrait);
    end;
  end
  else
  begin
    // Frames for further fighters
    MaxPortraits := Ceil((ClientHeight - VMARGIN - PORTRAITHEIGHT) / (INITIATIVEHEIGHT + VMARGIN));
    for i := 0 to Min(MaxPortraits, fmController.GetInitiativeCount) - 2 do
    begin
      ClipRect := Rect(ClientWidth - HMARGIN - INITIATIVEWIDTH,
                       VMARGIN + PORTRAITHEIGHT + VMARGIN + i * (INITIATIVEHEIGHT + VMARGIN),
                       ClientWidth - HMARGIN - INITIATIVEWIDTH + INITIATIVEWIDTH,
                       VMARGIN + PORTRAITHEIGHT + VMARGIN + i * (INITIATIVEHEIGHT + VMARGIN) + INITIATIVEHEIGHT);
      //DrawPhongFrame(ClipRect);
      FInitiativeFrame.Draw(Canvas, CliPRect.Left - FRAMESIZE, ClipRect.Top - FRAMESIZE, False);
    end;

    for i := 0 to Min(MaxPortraits, fmController.GetInitiativeCount) - 1 do
    begin
      TokenRect := Bounds(ClientWidth - HMargin - IfThen(i = 0, PORTRAITWIDTH, INITIATIVEWIDTH),
                          VMARGIN + IfThen(i = 0, 0, PORTRAITHEIGHT + VMARGIN + (i - 1) * (INITIATIVEHEIGHT + VMARGIN)),
                          IfThen(i = 0, PORTRAITWIDTH, INITIATIVEWIDTH),
                          IfThen(i = 0, PORTRAITHEIGHT, INITIATIVEHEIGHT));
      tmpPicture := fmController.GetInitiative((i + fmController.CurInitiativeIndex) mod fmController.GetInitiativeCount);
      if Assigned(tmpPicture) then
        Canvas.StretchDraw(TokenRect, tmpPicture.Graphic);
    end;

  end;
end;

procedure TfmDisplay.FormResize(Sender: TObject);
begin
  fmController.UpdateViewport;
  if Assigned(FMapFrame) then
    FMapFrame.Free;
  FMapFrame := TBGRABitmap.Create(FRAMESIZE + ClientWidth - VMARGIN - VMARGIN - PORTRAITHEIGHT - VMARGIN + FRAMESIZE,
                                  FRAMESIZE + ClientHeight - HMARGIN - HMARGIN + FRAMESIZE);
  DrawPhongFrame(FMapFrame);
end;

procedure TfmDisplay.FormShow(Sender: TObject);
begin
  Caption := GetString(LanguageID, 'DisplayCaption');
end;

procedure TfmDisplay.tTokenAnimTimer(Sender: TObject);
var
  i: Integer;
  CurToken: TToken;
  AnyTokenMoving: Boolean;
begin
   // Move Tokens
  AnyTokenMoving := False;
  for i := 0 to fmController.GetTokenCount - 1 do
  begin
    CurToken := fmController.GetToken(i);
    if Assigned(CurToken) then
    begin
      CurToken.DoAnimationStep;
      AnyTokenMoving := AnyTokenMoving or CurToken.IsMoving;
    end;
  end;
  if AnyTokenMoving then
    Invalidate;
end;

procedure TfmDisplay.tMapAnimTimer(Sender: TObject);
begin
  Inc(FCurMapAnimStep);
  if FCurMapAnimStep = MAXMAPANIMSTEPS then
  begin
    FMapOffsetX := FTargetMapOffsetX;
    FMapOffsetY := FTargetMapOffsetY;
    tMapAnim.Enabled := False;
    Invalidate;
    Exit;
  end;
  FMapOffsetX := Round(Ease(FCurMapAnimStep, FStartMapOffsetX, FTargetMapOffsetX - FStartMapOffsetX, MAXMAPANIMSTEPS, etOutQuad));
  FMapOffsetY := Round(Ease(FCurMapAnimStep, FStartMapOffsetY, FTargetMapOffsetY - FStartMapOffsetY, MAXMAPANIMSTEPS, etOutQuad));

  Invalidate;
end;

{ TBGRAFrameScanner }

constructor TBGRAFrameScanner.Create(InnerColor, OuterColor:TBGRAPixel; FrameWidth, FrameHeight, FrameSize: Integer);
begin
  inherited Create;
  FInnerColor := InnerColor;
  FOuterColor := OuterColor;
  FFrameWidth := FrameWidth;
  FFrameHeight := FrameHeight;
  FFrameSize := FrameSize;
end;

function TBGRAFrameScanner.ScanAt(X, Y: Single): TBGRAPixel;
var
  iRed, iGreen, iBlue, oRed, oGreen, oBlue: Byte;
  dist: Single; // 0: outer side of edge; 1: inner side of edge
begin
  if InRange(X, 0, FFrameWidth) and InRange(Y, 0, FFrameHeight) then
  begin
    FInnerColor.ToRGB(iRed, iGreen, iBlue);
    FOuterColor.ToRGB(oRed, oGreen, oBlue);
    dist := 0;

    // Get Manhattan-distance to edge of frame
    // Is the point close to an edge?
    if InRange(X, 0, FFrameSize) then
    begin // Left edge
      dist := x / FFrameSize;
      // Blend corners
      dist := Min(dist, Y / FFrameSize);
      dist := Min(dist, (FFrameHeight - Y) / FFrameSize);
    end
    else if InRange(X, FFrameWidth - FFrameSize, FFrameWidth) then
    begin // Right edge
      dist := (FFrameWidth - X) / FFrameSize;            
      // Blend corners
      dist := Min(dist, Y / FFrameSize);
      dist := Min(dist, (FFrameHeight - Y) / FFrameSize);
    end
    else if InRange(Y, 0, FFrameSize) then
    begin // Top edge
      dist := Y / FFrameSize;
    end
    else if InRange(Y, FFrameHeight - FFrameSize, FFrameHeight) then
    begin // Bottom edge
      dist := (FFrameHeight - Y) / FFrameSize;
    end
    else
    begin // Inside the frame
      Exit(FOuterColor);
    end;

    if dist < 0.5 then
      Result.FromRGB(Round(Map(dist * 2, 0, 1, oRed, iRed)),
                     Round(Map(dist * 2, 0, 1, oGreen, iGreen)),
                     Round(Map(dist * 2, 0, 1, oBlue, iBlue)))
    else
      Result.FromRGB(Round(Map((dist - 0.5) * 2, 1, 0, oRed, iRed)),
                     Round(Map((dist - 0.5) * 2, 1, 0, oGreen, iGreen)),
                     Round(Map((dist - 0.5) * 2, 1, 0, oBlue, iBlue)));
  end
  else
  begin
    Result := FOuterColor;
  end;
end;

end.

