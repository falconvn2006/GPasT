unit ugamegrid;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Controls, ExtCtrls, ugamecommon, Math,
  GR32_Image, GR32_Paths, GR32, GR32_Layers, GR32_Brushes;

type
  TLayerCollectionAccess = class(TLayerCollection);
//    public
//      function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): TCustomLayer;
//  end;

  TGameOnChangeMapSize = TNotifyEvent;
  TGameOnChangeViewport = TNotifyEvent;
  TGameOnLog = TNotifyEvent;

  TGameLayer = class(TBitmapLayer)
    private
      var FPos: TMapPos;
      var FSize: TMapSize;
      var FRect: TMapRect;
      var FData: pointer;
      var FOriginalBitmap: TBitmap32;
      procedure SetPos(AValue: TMapPos);
      procedure SetSize(AValue: TMapSize);
    public
      property Pos: TMapPos read FPos write SetPos;
      property Size: TMapSize read FSize write SetSize;
      property Rect: TMapRect read FRect;
      property Data: pointer read FData write FData;
      property OriginalBitmap: TBitmap32 read FOriginalBitmap write FOriginalBitmap;

      constructor Create(ALayerCollection: TLayerCollection); override;
      //destructor Destroy; override;
  end;

  TGameNeighbour = record
    Direction: TMapDir;
    Index: QWord;
    Layer: TGameLayer;
  end;
  TGameNeighbours = array of TGameNeighbour;

  TGameGrid = class
    private
      var Image: TImage32;
      var BitmapList: TBitmap32List;

      var FMapSize: TMapSize; //number of fields
      var FViewport: TMapRect; //lefttop field -> bottomright field
      var FLastViewport: TMapRect; //updatelayers() is using this
      var FLastImageSize: TMapSize; //and this too
      var FLog: string;
      var FFieldSelected: TMapPos;
      var FFieldCursor: TMapPos;

      var FOnChangeMapSize: TGameOnChangeMapSize;
      var FOnChangeViewport: TGameOnChangeViewport;
      var FOnLog: TGameOnLog;

      procedure SetMapSize(AValue: TMapSize);
      procedure SetViewport(AValue: TMapRect);
      procedure FixViewport(AForceChange: boolean = false);
      procedure SetFieldSelected(AValue: TMapPos);
      procedure SetFieldCursor(AValue: TMapPos);

      procedure DoOnChangeMapSize();
      procedure DoOnChangeViewport();
      procedure DoOnLog();

      function FieldSizeFloat(): TFloatPoint;
      function FieldSize(): TPoint;
      function FieldBounds(AField: TPoint): TRect;
      function FieldBounds(APos: TMapPos; ASize: TMapSize): TMapRect;

      procedure AddToLog(const AText: string);
    public
      property MapSize: TMapSize read FMapSize write SetMapSize;
      property Viewport: TMapRect read FViewport write SetViewport;
      property Log: string read FLog;
      property FieldSelected: TMapPos read FFieldSelected write SetFieldSelected;
      property FieldCursor: TMapPos read FFieldCursor write SetFieldCursor;

      property OnChangeMapSize: TGameOnChangeMapSize read FOnChangeMapSize write FOnChangeMapSize;
      property OnChangeViewport: TGameOnChangeViewport read FOnChangeViewport write FOnChangeViewport;
      property OnLog: TGameOnLog read FOnLog write FOnLog;

      constructor Create(AImage: TImage32; ABitmapList: TBitmap32List);
      destructor Destroy(); override;
      procedure Clear();

      procedure UpdateLayers();
      function FieldFromXY(AX,AY: integer): TMapPos;
      function LayerFromXY(AX,AY: integer): TCustomLayer;
      function LayerFromXY(AXY: TPoint): TCustomLayer;
      function FieldToXY(AField: TMapPos): TPoint;
      function LayerNeighbours(ALayer: TGameLayer): TGameNeighbours;

      function AddObject(ABitmap: integer; APos: TMapPos; ASize: TMapSize; AData: pointer): integer;
      function GetObject(AX,AY: integer): TGameLayer;
  end;

implementation

procedure TGameLayer.SetPos(AValue: TMapPos);
begin
  FPos := AValue;
  FRect.Create(FPos, FSize);
end;

procedure TGameLayer.SetSize(AValue: TMapSize);
begin
  FSize := AValue;
  FRect.Create(FPos, FSize);
end;

constructor TGameLayer.Create(ALayerCollection: TLayerCollection);
begin
  inherited Create(ALayerCollection);
  Pos := TMapPos.Make(0,0);
  Size := TMapSize.Make(0,0);

  FData := nil;
  FOriginalBitmap := nil;
end;

//destructor TGameLayer.Destroy;
//begin
//  inherited Destroy();
//end;

{ Private }

procedure TGameGrid.SetMapSize(AValue: TMapSize);
begin
  if (AValue.Width < 1) or (AValue.Height < 1) or (FMapSize = AValue) then
  begin
    Exit;
  end;

  FMapSize := AValue;
  FixViewport(true);
  DoOnChangeMapSize();
end;

procedure TGameGrid.SetViewport(AValue: TMapRect);
begin
  if (FViewport = AValue) then
  begin
    Exit;
  end;

  FViewport := AValue;
  FixViewport(true);
end;

procedure TGameGrid.FixViewport(AForceChange: boolean = false);
var t: QWord;
    vpOriginal: TMapRect;
begin
  vpOriginal := FViewport;

  //Viewport is wider than map => reset to span whole map width
  if FViewport.Width > FMapSize.Width then
  begin
    FViewport.Left := 0;
    FViewport.Width := FMapSize.Width;
  end;
  //Viewport is taller than map => reset to span whole map height
  if FViewport.Height > FMapSize.Height then
  begin
    FViewport.Top := 0;
    FViewport.Height := FMapSize.Height;
  end;
  //Viewport starts next to the map -> move back to the map and keep width
  if FViewport.Left >= FMapSize.Width then
  begin
    t := FViewport.Width;
    FViewport.Left := FMapSize.Width-FViewport.Width;
    FViewport.Width := t;
  end;
  //Viewport starts under the map -> move back to the map and keep height
  if FViewport.Top >= FMapSize.Height then
  begin
    t := FViewport.Height;
    FViewport.Top := FMapSize.Height-FViewport.Height;
    FViewport.Height := t;
  end;
  //Viewport X starts on the map but reaches out -> move back to the map and keep width
  if FViewport.Right >= FMapSize.Width then
  begin
    t := FViewport.Width;
    FViewport.Right := FMapSize.Width-1;
    FViewport.Left := FViewport.Right-t+1;
  end;
  //Viewport Y starts on the map but reaches out -> move back to the map and keep height
  if FViewport.Bottom >= FMapSize.Height then
  begin
    t := FViewport.Height;
    FViewport.Bottom := FMapSize.Height-1;
    FViewport.Top := FViewport.Bottom-t+1;
  end;

  if AForceChange or (vpOriginal <> FViewport) then
  begin
    UpdateLayers();
    DoOnChangeViewport();
  end;
end;

procedure TGameGrid.SetFieldSelected(AValue: TMapPos);
begin
  FFieldSelected := AValue;
  UpdateLayers();
end;

procedure TGameGrid.SetFieldCursor(AValue: TMapPos);
begin
  FFieldCursor := AValue;
  UpdateLayers();
end;

procedure TGameGrid.DoOnChangeMapSize();
begin
  if Assigned(FOnChangeMapSize) then
  begin
    FOnChangeMapSize(self);
  end;
end;

procedure TGameGrid.DoOnChangeViewport();
begin
  if Assigned(FOnChangeViewport) then
  begin
    FOnChangeViewport(self);
  end;
end;

procedure TGameGrid.DoOnLog();
begin
  if Assigned(FOnLog) then
  begin
    FOnLog(self);
  end;
end;

//Do this when
//  - Image32 size changes
//  - Viewport rect changes
procedure TGameGrid.UpdateLayers();
var c: TCanvas32;
    ptField: TPoint;
    i,iXY: integer;
    Layer0,Layer1: TBitmapLayer;
    LayerN: TGameLayer;
    boolCursor: boolean; //whether cursor/selected field were highlighted
    rctXY: TRect;
begin
  // First we update layer 0, which is the background grid
  // Only if the viewport changed, otherwise the grid stays the same
  if (FLastViewport <> FViewport) or (FLastImageSize <> TMapSize.Make(Image.Width, Image.Height)) then
  begin
    FLastViewport := FViewport;
    FLastImageSize := TMapSize.Make(Image.Width, Image.Height);

    // Ensure the background grid layer exists
    if Image.Layers.Count = 0 then
    begin
      Image.Layers.Add(TBitmapLayer);
    end;

    // Load the layer
    Layer0 := TBitmapLayer(Image.Layers[0]);
    Layer0.MouseEvents := true;

    // Start drawing
    Layer0.Bitmap.BeginUpdate;
    try
      // Reset bitmap size to the whole image
      Layer0.Bitmap.SetSize(Image.Width,Image.Height);
      Layer0.Bitmap.DrawMode := dmOpaque;
      Layer0.Location := FloatRect(0,0,Image.Width,Image.Height);
      // Set background color
      Layer0.Bitmap.Clear(Color32(clBtnFace));
      // Get field size and start drawing lines
      ptField := FieldSize();
      c := TCanvas32.Create(Layer0.Bitmap);
      try
        // Set brush for lines
        c.Brushes.Add(TStrokeBrush);
        c.Brushes[0].Visible := true;
        TStrokeBrush(c.Brushes[0]).FillColor := clBlack32;
        TStrokeBrush(c.Brushes[0]).StrokeWidth := 1;
        // Draw vertical lines
        for i := 1 to FViewport.Width-1 do
        begin
          iXY := (i*(ptField.X+2))-1;
          c.MoveTo(FloatPoint(iXY, 0));
          c.LineTo(FloatPoint(iXY, Image.Height));
          c.EndPath();
        end;
        // Draw horizontal lines
        for i := 1 to FViewport.Height-1 do
        begin
          iXY := (i*(ptField.Y+2))-1;
          c.MoveTo(FloatPoint(0, iXY));
          c.LineTo(FloatPoint(Image.Width, iXY));
          c.EndPath();
        end;
      finally
        c.Free;
      end;
    finally
      Layer0.Bitmap.EndUpdate;
    end;
  end;

  // Load background cursor layer
  if Image.Layers.Count = 1 then
  begin
    Image.Layers.Add(TBitmapLayer);
  end;
  Layer1 := TBitmapLayer(Image.Layers[1]);
  boolCursor := false;

  // If there are no other objects, we can skip this part
  if Image.Layers.Count > 2 then
  begin
    // Now we update all other layers, i.e. objects on the grid
    ptField := FieldSize();
    for i := 2 to Image.Layers.Count-1 do
    begin
      if not (Image.Layers[i] is TGameLayer) then
      begin
        continue;
      end;
      LayerN := TGameLayer(Image.Layers[i]);
      LayerN.Visible := FViewport.Contains(LayerN.Pos);
      if not LayerN.Visible then
      begin
        continue;
      end;
      LayerN.Location := FloatRect(FieldBounds(LayerN.Pos,LayerN.Size).ToRect());
      LayerN.Bitmap.SetSize(ptField.X, ptField.Y);
      if Assigned(LayerN.OriginalBitmap) then
      begin
        LayerN.OriginalBitmap.DrawTo(LayerN.Bitmap, LayerN.Bitmap.BoundsRect);
        if FFieldCursor.Valid and LayerN.Rect.Contains(FFieldCursor) then
        begin
          LayerN.Bitmap.FillRectTS(LayerN.Bitmap.BoundsRect, Color32(255,0,0,128));
          boolCursor := true;
        end;
        if FFieldSelected.Valid and LayerN.Rect.Contains(FFieldSelected) then
        begin
          LayerN.Bitmap.FillRectTS(LayerN.Bitmap.BoundsRect, Color32(0,0,255,128));
        end;
      end
      else
      begin
        LayerN.Bitmap.Clear(clAqua32);
      end;
    end;
  end;

  Layer1.Visible := FFieldCursor.Valid and FViewport.Contains(FFieldCursor) and (not boolCursor);
  if Layer1.Visible then
  begin
    rctXY := FieldBounds(FFieldCursor.ToPoint());
    Layer1.Bitmap.SetSize(rctXY.Width, rctXY.Height);
    Layer1.Bitmap.Clear(Color32(255,0,0,128));
    Layer1.Location := FloatRect(rctXY);
  end;
end;

function TGameGrid.FieldSizeFloat(): TFloatPoint;
begin
  result.X := (Image.Width-Viewport.Width+1)/Viewport.Width;
  result.Y := (Image.Height-Viewport.Height+1)/Viewport.Height;
end;

function TGameGrid.FieldSize(): TPoint;
var ptField: TFloatPoint;
begin
  ptField := FieldSizeFloat;
  result.Create(Math.Floor(ptField.X), Math.Floor(ptField.Y));
  if Frac(ptField.X) < 0.001 then
  begin
    Dec(result.X);
  end;
  if Frac(ptField.Y) < 0.001 then
  begin
    Dec(result.Y);
  end;
end;

function TGameGrid.FieldBounds(AField: TPoint): TRect;
var ptField: TPoint;
begin
  ptField := FieldSize;

  result.Create(TPoint.Create(
    (AField.X-FViewport.Left)*(ptField.X+2),
    (AField.Y-FViewport.Top)*(ptField.Y+2)),
    ptField.X+2,
    ptField.Y+2
  );
  if AField.X = Viewport.Right then
  begin
    result.Right := Image.Width;
  end;
  if AField.Y = Viewport.Bottom then
  begin
    result.Bottom := Image.Height;
  end;
end;

function TGameGrid.FieldBounds(APos: TMapPos; ASize: TMapSize): TMapRect;
var ptField: TPoint;
    rct: TMapRect;
begin
  ptField := FieldSize;
  rct.Create(APos, ASize);

  if FViewport.Overflow(rct) then
  begin
    raise Exception.CreateFmt('Rectangle overflow VP%s R%s', [FViewport.ToStr(), rct.ToStr()]);
    result.Create();
    Exit;
  end;

  result.Create(TMapPos.Make(
    (APos.X-FViewport.Left)*(ptField.X+2),
    (APos.Y-FViewport.Top)*(ptField.Y+2)),
    ASize.Width*(ptField.X+2),
    ASize.Height*(ptField.Y+2)
  );
  if APos.X = Viewport.Right then
  begin
    result.Right := Image.Width;
  end;
  if APos.Y = Viewport.Bottom then
  begin
    result.Bottom := Image.Height;
  end;
end;

function TGameGrid.LayerNeighbours(ALayer: TGameLayer): TGameNeighbours;
var i: integer;
    posNeighbour: TMapPos;
    ptNeighbour: TPoint;
    l: TCustomLayer;
begin
  SetLength(result, 2*(ALayer.Size.Width+ALayer.Size.Height));
  for i := Low(result) to High(result) do
  begin
    posNeighbour.Create(0,0);
    if (i < ALayer.Size.Height) then
    begin
      result[i].Direction := mdLeft;
      result[i].Index := i;
      posNeighbour.Create(ALayer.FRect.Left-1, ALayer.FRect.Top-i);
    end
    else if (i < (ALayer.Size.Height+ALayer.Size.Width)) then
    begin
      result[i].Direction := mdBottom;
      result[i].Index := i-ALayer.Size.Height;
      posNeighbour.Create(ALayer.FRect.Left-result[i].Index, ALayer.FRect.Bottom+1);
    end
    else if (i < (ALayer.Size.Height+ALayer.Size.Width+ALayer.Size.Height)) then
    begin
      result[i].Direction := mdRight;
      result[i].Index := i-ALayer.Size.Height-ALayer.Size.Width;
      posNeighbour.Create(ALayer.FRect.Right+1, ALayer.FRect.Bottom-result[i].Index);
    end
    else
    begin
      result[i].Direction := mdTop;
      result[i].Index := i-ALayer.Size.Height-ALayer.Size.Width-ALayer.Size.Height;
      posNeighbour.Create(ALayer.FRect.Right-result[i].Index, ALayer.FRect.Top-1);
    end;
    result[i].Layer := nil;
    if Image.Layers.MouseEvents then
    begin
      ptNeighbour := FieldToXY(posNeighbour);
      l := LayerFromXY(ptNeighbour.X, ptNeighbour.Y);
      if l is TGameLayer then
      begin
        result[i].Layer := (l as TGameLayer);
      end;
    end;

  end;
end;

function TGameGrid.FieldFromXY(AX,AY: integer): TMapPos;
var fs: TPoint;
begin
  fs := FieldSize();
  result.Create(
    FViewport.Left + Math.Floor(AX / fs.X),
    FViewport.Top + Math.Floor(AY / fs.Y)
  );
end;

function TGameGrid.LayerFromXY(AX,AY: integer): TCustomLayer;
begin
  result := TLayerCollectionAccess(Image.Layers).MouseUp(mbLeft, [], AX, AY);
end;

function TGameGrid.LayerFromXY(AXY: TPoint): TCustomLayer;
begin
  result := LayerFromXY(AXY.X, AXY.Y);
end;

function TGameGrid.FieldToXY(AField: TMapPos): TPoint;
var fs: TPoint;
begin
  fs := FieldSize();
  result.Create(
    ((AField.X - FViewport.Left) * fs.X) + Round(fs.X / 2),
    ((AField.Y - FViewport.Top) * fs.Y) + Round(fs.Y / 2)
  );
end;

procedure TGameGrid.AddToLog(const AText: string);
begin
  FLog := FLog + AText + #13#10;
  DoOnLog();
end;

{ Public }

constructor TGameGrid.Create(AImage: TImage32; ABitmapList: TBitmap32List);
begin
  Image := AImage;
  BitmapList := ABitmapList;
  MapSize := TMapSize.Make(0,0);
  FLastViewport := TMapRect.Make();
  Viewport := TMapRect.Make();
  FLog := '';
end;

destructor TGameGrid.Destroy;
begin
  inherited Destroy;
end;

procedure TGameGrid.Clear;
begin
end;

function TGameGrid.AddObject(ABitmap: integer; APos: TMapPos; ASize: TMapSize; AData: pointer): integer;
var layer: TCustomLayer;
    i: integer;
    rct: TMapRect;
    strDebug: string;
begin
  result := -1;

  // Check for a layer that has the same position
  rct.Create(APos,ASize);
  if Image.Layers.Count > 1 then
  begin
    for i := 1 to Image.Layers.Count-1 do
    begin
      if (not Assigned(Image.Layers)) or (not (Image.Layers[i] is TGameLayer)) then
      begin
        continue;
      end;
      strDebug := '';
      if (Image.Layers[i] as TGameLayer).Rect.Contains(rct, strDebug) then
      begin
        AddToLog(strDebug);
        Exit;
      end;
    end;
  end;

  // Try to add a new layer
  layer := Image.Layers.Add(TGameLayer);
  if (not Assigned(layer)) or (not (layer is TGameLayer)) then
  begin
    Exit;
  end;

  // All good, we just set properties
  result := 0;
  (layer as TGameLayer).Pos := APos;
  (layer as TGameLayer).Size := ASize;
  (layer as TGameLayer).Data := AData;
  if (ABitmap >= 0) and (ABitmap < BitmapList.Bitmaps.Count) then
  begin
    (layer as TGameLayer).OriginalBitmap := BitmapList.Bitmap[ABitmap];
  end;

  UpdateLayers();
end;

function TGameGrid.GetObject(AX,AY: integer): TGameLayer;
var i: integer;
    pos: TMapPos;
begin
  result := nil;
  if Image.Layers.Count > 1 then
  begin
    pos := FieldFromXY(AX,AY);
    for i := 1 to Image.Layers.Count-1 do
    begin
      if (not Assigned(Image.Layers)) or (not (Image.Layers[i] is TGameLayer)) then
      begin
        continue;
      end;
      if (Image.Layers[i] as TGameLayer).Rect.Contains(pos) then
      begin
        result := (Image.Layers[i] as TGameLayer);
        Exit;
      end;
    end;
  end;

end;

end.

