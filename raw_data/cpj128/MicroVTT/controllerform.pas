{Copyright (c) 2023 Stephan Breer

This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
}

unit ControllerForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, Menus, IniFiles, BGRABitmap, RPGTypes;

const
  MAPLIBFILE = 'Maps.txt';
  TOKENLIBFILE = 'Tokens.txt';
  OVERLAYLIBFILE = 'Overlays.txt';

type

  { TfmController }

  TfmController = class(TForm)
    bResetZoom: TButton;
    ilMapIcons: TImageList;
    ilMenuItems: TImageList;
    Image1: TImage;
    lvInitiative: TListView;
    lZoom: TLabel;
    lvMaps: TListView;
    odLoadSession: TOpenDialog;
    pPortrait: TPanel;
    pbViewport: TPaintBox;
    sdSaveSession: TSaveDialog;
    tbMapZoom: TTrackBar;
    tbControl: TToolBar;
    tbExit: TToolButton;
    tbFullscreen: TToolButton;
    tbShowGrid: TToolButton;
    tbGridSettings: TToolButton;
    ToolButton1: TToolButton;
    tbHideMarker: TToolButton;
    tbHidePortrait: TToolButton;
    tbSnapTokensToGrid: TToolButton;
    tbHideTokens: TToolButton;
    ToolButton2: TToolButton;
    tbCombatMode: TToolButton;
    tbNextCombatant: TToolButton;
    tbClearTokens: TToolButton;
    ToolButton3: TToolButton;
    tbSettings: TToolButton;
    tbRefreshMaps: TToolButton;
    tbRefreshTokens: TToolButton;
    tbClearInitiative: TToolButton;
    tbRemoveFromInitiative: TToolButton;
    tbLibrary: TToolButton;
    tbLoadSession: TToolButton;
    tbSaveSession: TToolButton;
    tvTokens: TTreeView;
    procedure bFullscreenClick(Sender: TObject);
    procedure bRefreshMapsClick(Sender: TObject);
    procedure bResetZoomClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvInitiativeCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvInitiativeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lvInitiativeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvMapsDblClick(Sender: TObject);
    procedure pbViewportDblClick(Sender: TObject);
    procedure pbViewportDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure pbViewportDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure pbViewportMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbViewportMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbViewportMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbViewportPaint(Sender: TObject);
    procedure pPortraitDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure pPortraitDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure pPortraitResize(Sender: TObject);
    procedure tbClearInitiativeClick(Sender: TObject);
    procedure tbClearTokensClick(Sender: TObject);
    procedure tbCombatModeClick(Sender: TObject);
    procedure tbExitClick(Sender: TObject);
    procedure tbGridSettingsClick(Sender: TObject);
    procedure tbHideMarkerClick(Sender: TObject);
    procedure tbHidePortraitClick(Sender: TObject);
    procedure tbHideTokensClick(Sender: TObject);
    procedure tbLibraryClick(Sender: TObject);
    procedure tbLoadSessionClick(Sender: TObject);
    procedure tbMapZoomChange(Sender: TObject);
    procedure tbNextCombatantClick(Sender: TObject);
    procedure tbRefreshMapsClick(Sender: TObject);
    procedure tbRefreshTokensClick(Sender: TObject);
    procedure tbRemoveFromInitiativeClick(Sender: TObject);
    procedure tbSaveSessionClick(Sender: TObject);
    procedure tbSettingsClick(Sender: TObject);
    procedure tbShowGridClick(Sender: TObject);
    procedure tbSnapTokensToGridClick(Sender: TObject);
    procedure tvTokensDeletion(Sender: TObject; Node: TTreeNode);
    procedure tvTokensDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
  private
    FMapPic: TBGRABitmap;
    FMapFileName: string;
    FViewRectWidth, FViewRectHeight: Integer;
    FViewRectXOffset, FViewRectYOffset: Integer;
    FViewRectMaxXOffset, FViewRectMaxYOffset: Integer;
    FDisplayScale: Double;
    FZoomFactor: Double;
    FIsDragging: Boolean;
    FIsDraggingToken: Boolean;
    FIsRotatingToken: Boolean;
    FCurDraggedToken: TToken;
    FSnapTokensToGrid: Boolean;
    FDragStartX, FDragStartY, // In pbViewPort-coordinates
    FLastMouseX, FLastMouseY, // In pbViewPort-coordinates
    FStartDragXOffset, FStartDragYOffset: Integer;
    FGridSizeX, FGridSizeY, FGridOffsetX, FGridOffsetY: Single;
    FShowGrid: Boolean;
    FGridColor: TColor;
    FGridType: TGridType;
    FOldGridSizeX, FOldGridSizeY, FOldGridOffsetX, FOldGridOffsetY: Single;
    FOldGridType: TGridType;
    FOldGridColor: TColor;
    FMarkerPosX, FMarkerPosY: Integer; // In MapPic-coordinates
    FShowMarker: Boolean;
    FShowTokens: Boolean;
    FCombatMode: Boolean;
    FInitiativeList: TList;
    FCurInitiativeIndex: Integer;
    FTokenList: TList;
    FMapDir, FTokenDir, FOverlayDir: string;
    FInitiativeDesc, FTokensStartInvisible: Boolean;
    FAppSettings: TIniFile;
    FMapLib, FTokenLib, FOverlayLib: TStringList;
    procedure UpdateMapList;
    procedure UpdateTokenList;
    procedure UpdateOverlayList;
    function MapToViewPortX(MapX: Single): Integer;
    function MapToViewPortY(MapY: Single): Integer;
    function ViewPortToMapX(ViewPortX: Integer): Integer;
    function ViewPortToMapY(ViewPortY: Integer): Integer;
    function GetTokenAtPos(X, Y: Integer): TToken;
    procedure SetCurInitiativeIndex(val: Integer);
    procedure LoadMap(FileName: string);
    procedure SetCombatMode(val: Boolean);
  public
    procedure UpdateViewport;
    function GetToken(idx: Integer): TToken;
    function GetTokenCount: Integer;
    function GetOverlay(idx: Integer): TBGRABitmap;
    procedure RemoveToken(token: TToken);
    function GetInitiative(idx: Integer): TPicture;
    function GetInitiativeCount: Integer;
    function GetCurInitiativeIdx: Integer;
    procedure SnapAllTokensToGrid;
    procedure SnapTokenToGrid(token: TToken);
    procedure SaveLibraryData;
    procedure SaveSettings;
    procedure RestoreGridData;
    procedure SaveGridData;
    procedure AddToInitiative(pName, Path: string; Value: Integer);
    property GridSizeX: Single read FGridSizeX write FGridSizeX; 
    property GridSizeY: Single read FGridSizeY write FGridSizeY;
    property GridOffsetX: Single read FGridOffsetX write FGridOffsetX;
    property GridOffsetY: Single read FGridOffsetY write FGridOffsetY;
    property GridColor: TColor read FGridColor write FGridColor;
    property GridType: TGridType read FGridType write FGridType;
    property CurInitiativeIndex: Integer read FCurInitiativeIndex write SetCurInitiativeIndex;
    property MapLib: TStringList read FMapLib;
    property TokenLib: TStringList read FTokenLib;
    property OverlayLib: TStringList read FOverlayLib;
    property MapDir: string read FMapDir;
    property TokenDir: string read FTokenDir;
    property OverlayDir: string read FOverlayDir;
    property ShowMarker: Boolean read FShowMarker;
    property ShowGrid: Boolean read FShowGrid;
    property ShowTokens: Boolean read FShowTokens;
  end;

  TTokenNodeData = class
    public
      FullPath: string;
      Name: string;
      DefaultWidth, DefaultHeight: Integer;
      DefaultGridSlotsX, DefaultGridSlotsY: Integer;
      DefaultAngle: Single;
      BaseInitiative: Integer;
  end;

  TPicLoaderThread = class(TThread)
    private
      FFileList: TStringList;
      CurIdx: Integer;
      Thumbnail: TBitmap;
      procedure SetThumbnail;
    protected
      procedure Execute; override;
    public
      constructor Create(CreateSuspended : Boolean; FileList: TStringList; Width, Height: Integer);
  end;

var
  fmController: TfmController;

implementation

{$R *.lfm}

uses
  FileUtil,
  StrUtils,
  Math,
  GetText,
  BGRABitmapTypes,
  BGRATransform,
  DisplayConst,
  LangStrings,
  DisplayForm,
  GridSettingsForm,
  SettingsForm,
  LibraryForm,
  TokenSettingsForm,
  InitiativeForm;

{ TfmController }

procedure TfmController.FormShow(Sender: TObject);
begin
  Caption := GetString(LangStrings.LanguageID, 'ControllerCaption');

  tbExit.Hint := GetString(LangStrings.LanguageID, 'ControllerExitHint');
  tbSettings.Hint := GetString(LangStrings.LanguageID, 'ControllerSettingsHint');  
  tbRefreshMaps.Hint := GetString(LangStrings.LanguageID, 'ControllerRefreshMapsHint');
  tbRefreshTokens.Hint := GetString(LangStrings.LanguageID, 'ControllerRefreshTokensHint');  
  tbLibrary.Hint := GetString(LangStrings.LanguageID, 'ControllerLibraryHint');
  tbLoadSession.Hint := GetString(LangStrings.LanguageID, 'ControllerLoadHint');
  tbSaveSession.Hint := GetString(LangStrings.LanguageID, 'ControllerSaveHint');

  tbFullScreen.Hint := GetString(LangStrings.LanguageID, 'ControllerFullscreenHint');
  tbShowgrid.Hint := GetString(LangStrings.LanguageID, 'ControllerToggleGridHint');
  tbGridSettings.Hint := GetString(LangStrings.LanguageID, 'ControllerGridSettingsHint'); 
  tbSnapTokensToGrid.Hint := GetString(LangStrings.LanguageID, 'ControllerSnapToGridHint');
  tbHideTokens.Hint := GetString(LangStrings.LanguageID, 'ControllerHideAllTokensHint');

  tbHideMarker.Hint := GetString(LangStrings.LanguageID, 'ControllerHideMarkerHint');
  tbHidePortrait.Hint := GetString(LangStrings.LanguageID, 'ControllerHidePortraitHint');
  tbClearTokens.Hint := GetString(LangStrings.LanguageID, 'ControllerClearTokensHint');

  tbCombatMode.Hint := GetString(LangStrings.LanguageID, 'ControllerCombatModeHint');
  tbNextCombatant.Hint := GetString(LangStrings.LanguageID, 'ControllerCombatNextHint');
  tbClearInitiative.Hint := GetString(LangStrings.LanguageID, 'ControllerClearInitiativeHint');
  tbRemoveFromInitiative.Hint := GetString(LangStrings.LanguageID, 'ControllerRemoveFromInitiativeHint');

  lvInitiative.Column[1].Caption := GetString(LangStrings.LanguageID, 'ControllerIniListHeaderName');
  lvInitiative.Column[2].Caption := GetString(LangStrings.LanguageID, 'ControllerIniListHeaderInitiative');
  lvInitiative.Column[3].Caption := GetString(LangStrings.LanguageID, 'ControllerIniListHeaderPath');

  fmDisplay.Show;
  UpdateMapList;
  UpdateTokenList;
  UpdateOverlayList;
  UpdateViewport;
end;

procedure TfmController.lvInitiativeCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var Ini1, Ini2: Integer;
begin
  Ini1 := StrToInt(Item1.SubItems[1]);
  Ini2 := StrToInt(Item2.SubItems[1]);
  Compare := CompareValue(Ini1, Ini2);
  if FInitiativeDesc then
    Compare := -Compare;
end;

procedure TfmController.lvMapsDblClick(Sender: TObject);
begin
  LoadMap(lvMaps.Items[lvMaps.ItemIndex].SubItems[0]);
end;

procedure TfmController.LoadMap(FileName: string);
begin
  if not FileExists(FileName) then
    Exit;
  FMapFileName := FileName;
  fmDisplay.MapFileName := FMapFileName;
  FMapPic := TBGRABitmap.Create(FMapFileName, True);
  FViewRectXOffset := 0;
  FViewRectYOffset := 0;
  UpdateViewport;
  pbViewport.Invalidate;
  tbMapZoom.Enabled := True;
  bResetZoom.Enabled := True;
end;

procedure TfmController.pbViewportDblClick(Sender: TObject);
begin
  if Assigned(FMapPic) then
  begin
    FShowMarker := True;
    FIsDragging := False;
    FIsDraggingToken := False;
    FMarkerPosX := ViewPortToMapX(FLastMouseX);
    FMarkerPosY := ViewPortToMapY(FLastMouseY);
    fmDisplay.MarkerX := FMarkerPosX;
    fmDisplay.MarkerY := FMarkerPosY;
    pbViewPort.Invalidate;
  end;
end;

procedure TfmController.pbViewportDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  tmpToken: TToken;
begin
  if (Source is TTreeView) and Assigned(TTreeView(Source).Selected) and Assigned(TTreeView(Source).Selected.Data) then
  begin
    tmpToken := TToken.Create(TTokenNodeData(TTreeView(Source).Selected.Data).FullPath,
                              ViewPortToMapX(X),
                              ViewPortToMapY(Y),
                              TTokenNodeData(TTreeView(Source).Selected.Data).DefaultWidth,
                              TTokenNodeData(TTreeView(Source).Selected.Data).DefaultHeight);
    tmpToken.GridSlotsX := TTokenNodeData(TTreeView(Source).Selected.Data).DefaultGridSlotsX;
    tmpToken.GridSlotsY := TTokenNodeData(TTreeView(Source).Selected.Data).DefaultGridSlotsY;
    tmpToken.Angle := TTokenNodeData(TTreeView(Source).Selected.Data).DefaultAngle;
    tmpToken.Visible := FTokensStartInvisible;
    if FSnapTokensToGrid then
      tmpToken.SnapToGrid(FGridSizeX, FGridSizeY, FGridOffsetX, FGridOffsetY, FGridType);
    FTokenlist.Add(tmpToken);
    pbViewPort.Invalidate;
    fmDisplay.Invalidate;
  end
  else if (Source = lvMaps) then
  begin
    LoadMap(lvMaps.Items[lvMaps.ItemIndex].SubItems[0]);
  end;
end;

procedure TfmController.pbViewportDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Assigned(FMapPic) and
            (Source is TTreeView) and
            Assigned(TTreeView(Source).Selected) and
            Assigned(TTreeView(Source).Selected.Data)) or
            (Source = lvMaps);
end;

procedure TfmController.lvInitiativeDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := not FCombatMode and
            (Source is TTreeView) and
            Assigned(TTreeView(Source).Selected) and
            Assigned(TTreeView(Source).Selected.Data);
end;

procedure TfmController.lvInitiativeDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if not FCombatMode then
  begin
    fmSetInitiative.udBaseInitiative.Position := TTokenNodeData(TTreeView(Source).Selected.Data).BaseInitiative;
    fmSetInitiative.udRolledInitiative.Position := 1;
    fmSetInitiative.TokenName := TTokenNodeData(TTreeView(Source).Selected.Data).Name;
    fmSetInitiative.TokenPath := TTokenNodeData(TTreeView(Source).Selected.Data).FullPath;
    fmSetInitiative.Show;
  end;
end;

procedure TfmController.pbViewportMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FIsDragging := True;
    FCurDraggedToken := GetTokenAtPos(X, Y);
    FIsDraggingToken := Assigned(FCurDraggedToken);
    FDragStartX := X;
    FDragStartY := Y;
    if FIsDraggingToken then
    begin
      FIsRotatingToken := ssShift in Shift;
      {if FIsRotatingToken then
      begin
        FDragStartX := FCurDraggedToken.XEndPos + FCurDraggedToken.Width div 2;
        FDragStartY := FCurDraggedToken.YEndPos + FCurDraggedToken.Height div 2;
      end;}
      FCurDraggedToken.StopAnimation;
      FStartDragXOffset := FCurDraggedToken.XEndPos;
      FStartDragYOffset := FCurDraggedToken.YEndPos;
    end
    else
    begin
      FIsRotatingToken := False;
      FStartDragXOffset := FViewRectXOffset;
      FStartDragYOffset := FViewRectYOffset;
    end;
  end;
end;

procedure TfmController.pbViewportMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin 
  FLastMouseX := X;
  FLastMouseY := Y;
  if FIsDragging then
  begin
    if FIsDraggingToken then
    begin
      if FIsRotatingToken then
      begin

        FCurDraggedToken.Angle := ArcTan2((Y - FDragStartY), -(X - FDragStartX)) + PI/2;
      end
      else
      begin
        FCurDraggedToken.XPos := Round(FStartDragXOffset + (X - FDragStartX) / FDisplayScale / FZoomFactor);
        FCurDraggedToken.YPos := Round(FStartDragYOffset + (Y - FDragStartY) / FDisplayScale / FZoomFactor);
      end;
      //fmDisplay.Invalidate;
    end
    else
    begin
      FViewRectXOffset := EnsureRange(FStartDragXOffset + FDragStartX - X, 0, FViewRectMaxXOffset);
      FViewRectYOffset := EnsureRange(FStartDragYOffset + FDragStartY - Y, 0, FViewRectMaxYOffset);
      //fmDisplay.MapOffsetX := Round(FViewRectXOffset / FDisplayScale);
      //fmDisplay.MapOffsetY := Round(FViewRectYOffset / FDisplayScale);
    end;
    pbViewPort.Invalidate;
  end;
end;

procedure TfmController.pbViewportMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ClickedToken: TToken;
  //Modal: TModalResult;
begin
  if Button = mbLeft then
  begin
    if FIsDragging then
    begin
      fmDisplay.MapOffsetX := Round(FViewRectXOffset / FDisplayScale);
      fmDisplay.MapOffsetY := Round(FViewRectYOffset / FDisplayScale);
      pbViewPort.Invalidate;
      fmDisplay.Invalidate;
    end;
    if FIsDraggingToken then
    begin
      if FIsRotatingToken then
      begin
        FCurDraggedToken.Angle := ArcTan2((Y - FDragStartY), -(X - FDragStartX)) + PI/2;
      end
      else
      begin
        if FSnapTokensToGrid then
          FCurDraggedToken.SnapToGrid(FGridSizeX, FGridSizeY, FGridOffsetX, FGridOffsetY, FGridType);
        FCurDraggedToken.StartAnimation;
      end;
    end;
    FIsDragging := False;
    FIsDraggingToken := False;
    FIsRotatingToken := False;
    FCurDraggedToken := nil;
  end
  else if Button = mbRight then
  begin
    ClickedToken := GetTokenAtPos(X, Y);
    if Assigned(ClickedToken) then
    begin
      fmTokenSettings.cbVisible.Checked := ClickedToken.Visible;
      fmTokenSettings.udWidth.Position  := ClickedToken.Width;
      fmTokenSettings.udHeight.Position := ClickedToken.Height;
      fmTokenSettings.fseRotation.Value := -RadToDeg(ClickedToken.Angle);
      fmTokenSettings.udGridSlotsX.Position := ClickedToken.GridSlotsX;
      fmTokenSettings.udGridSlotsY.Position := ClickedToken.GridSlotsY;
      fmTokenSettings.cbOverlay.ItemIndex := ClickedToken.OverlayIdx + 1;
      fmTokenSettings.Left := Left + pbViewPort.Left + X;
      fmTokenSettings.Top  := Top  + pbViewPort.Top  + Y;
      fmTokenSettings.LinkedToken := ClickedToken;
      fmTokenSettings.Show; // So apparently ShowModal is broken and I have to do everything like this now?

    end;
  end;
end;

procedure TfmController.pbViewportPaint(Sender: TObject);
var
  ScaledBmp, DrawnMapSegment, TokenBmp: TBGRABitmap;
  i, j, CurGridPos: Integer;
  CurMarkerX, CurMarkerY: Integer;
  CurToken: TToken;
  CellRect, BoundingRect: TRect;
  Hex: array[0..5] of TPoint;
  tmpGridSize: Single;
  Rotation: TBGRAAffineBitmapTransform;
  RotatedBmp, OverlayBmp, OverlayScaled: TBGRABitmap;
begin
  // Draw Map
  if Assigned(FMapPic) then
  begin
    ScaledBmp := FMapPic.Resample(Round(FMapPic.Width * FDisplayScale * FZoomFactor), Round(FMapPic.Height * FDisplayScale * FZoomFactor), rmSimpleStretch);
    try
      DrawnMapSegment := TBGRABitmap.Create(pbViewPort.Width, pbViewPort.Height);
      try
        DrawnMapSegment.Canvas.CopyRect(Rect(0, 0, pbViewPort.Width, pbViewPort.Height),
                                        ScaledBmp.Canvas,
                                        Bounds(FViewRectXOffset, FViewRectYOffset, pbViewPort.Width, pbViewPort.Height));
        // Grid
        if FShowGrid then
        begin
          case FGridType of
            gtRect:
            begin
              // Horizontal lines
              for i := 0 to Ceil(((FMapPic.Height - (FGridOffsetY mod FGridSizeY)) / FGridSizeY)) do
              begin
                CurGridPos := MapToViewPortY(FGridOffsetY + i * FGridSizeY);
                if InRange(CurGridPos, 0, MapToViewPortY(FMapPic.Height)) then
                begin
                  DrawnMapSegment.DrawLineAntialias(0.0, CurGridPos,
                                                    MapToViewPortX(FMapPic.Width), CurGridPos,
                                                    FGridColor, 1);
                end;
              end;
              // Vertical lines
              for i := 0 to Ceil(((FMapPic.Width - (FGridOffsetX mod FGridSizeX)) / FGridSizeX)) do
              begin
                CurGridPos := MapToViewPortX(FGridOffsetX + i * FGridSizeX);
                if InRange(CurGridPos, 0, MapToViewPortX(FMapPic.Width)) then
                begin
                  DrawnMapSegment.DrawLineAntialias(CurGridPos, 0,
                                                    CurGridPos, MapToViewPortY(FMapPic.Height),
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
                  CellRect := Rect(MapToViewPortX(FGridOffsetX + j * FGridSizeX),
                                   MapToViewportY(FGridOffsetY + i * tmpGridSize),
                                   MapToViewPortX(FGridOffsetX + (j + 1) * FGridSizeX),
                                   MapToViewportY(FGridOffsetY + i * tmpGridSize + FGridSizeY));
                  if Odd(i) then
                    CellRect.Offset(Round(FGridSizeX  * FDisplayScale * FZoomFactor / 2), 0);
                  Hex[0] := Point(CellRect.Left, CellRect.Bottom - CellRect.Height div 4);
                  Hex[1] := Point(CellRect.Left, CellRect.Top + CellRect.Height div 4);
                  Hex[2] := Point(CellRect.Left + CellRect.Width div 2, CellRect.Top);
                  Hex[3] := Point(CellRect.Right, CellRect.Top + CellRect.Height div 4);
                  Hex[4] := Point(CellRect.Right, CellRect.Bottom - CellRect.Height div 4);
                  Hex[5] := Point(CellRect.Left + CellRect.Width div 2, CellRect.Bottom);
                  DrawnMapSegment.DrawPolygonAntialias(Hex, FGridColor, 1, BGRAPixelTransparent);
                end;
            end;
            gtHexV:
            begin
              tmpGridSize := FGridSizeX  * 3 / 4;
              for i := 0 to Ceil(((FMapPic.Height - (FGridOffsetY mod FGridSizeY)) / FGridSizeY)) do
                for j := 0 to Ceil(((FMapPic.Width - (FGridOffsetX mod tmpGridSize)) / tmpGridSize)) do
                begin
                  CellRect := Rect(MapToViewPortX(FGridOffsetX + j * tmpGridSize),
                                   MapToViewportY(FGridOffsetY + i * FGridSizeY),
                                   MapToViewPortX(FGridOffsetX + j * tmpGridSize + FGridSizeX),
                                   MapToViewportY(FGridOffsetY + (i + 1) * FGridSizeY));
                  if Odd(j) then
                    CellRect.Offset(0, Round(FGridSizeY  * FDisplayScale * FZoomFactor / 2));
                  Hex[0] := Point(CellRect.Left, CellRect.Top + CellRect.Height div 2);
                  Hex[1] := Point(CellRect.Left + CellRect.Width div 4, CellRect.Top);
                  Hex[2] := Point(CellRect.Right - CellRect.Width div 4, CellRect.Top);
                  Hex[3] := Point(CellRect.Right, CellRect.Top + CellRect.Height div 2);
                  Hex[4] := Point(CellRect.Right - CellRect.Width div 4, CellRect.Bottom);
                  Hex[5] := Point(CellRect.Left + CellRect.Width div 4, CellRect.Bottom);
                  DrawnMapSegment.DrawPolygonAntialias(Hex, FGridColor, 1, BGRAPixelTransparent);
                end;
            end;
          end;
        end;
        // Draw Tokens
        // TODO: Draw Tokens on the map before downsampling?
        // Probably not an improvement, because I'd have to resample to the desired size anyway
        for i := 0 to FTokenList.Count - 1 do
        begin
          CurToken := TToken(FTokenList[i]);
          TokenBmp := CurToken.Glyph.Resample(Round(CurToken.Width * FDisplayScale * FZoomFactor), Round(CurToken.Height * FDisplayScale * FZoomFactor));
          try
            if not CurToken.Visible then
            begin
              TokenBmp.DrawLineAntialias(0, 0, TokenBmp.Width, TokenBmp.Height, clRed, 2);
            end;
            if not FShowTokens then
            begin
              TokenBmp.DrawLineAntialias(TokenBmp.Width, 0, 0, TokenBmp.Height, clRed, 2);
            end;    
            BoundingRect := CurToken.GetBoundingRect;
            Rotation := TBGRAAffineBitmapTransform.Create(TokenBmp);
            Rotation.Translate(-TokenBmp.Width / 2, -TokenBmp.Height / 2);
            Rotation.RotateRad(CurToken.Angle);
            Rotation.Translate(BoundingRect.Width * FDisplayScale * FZoomFactor / 2, BoundingRect.Height * FDisplayScale * FZoomFactor / 2);
            try
              RotatedBmp := TBGRABitmap.Create(Round(BoundingRect.Width * FDisplayScale * FZoomFactor),
                                               Round(BoundingRect.Height * FDisplayScale * FZoomFactor));
              RotatedBmp.Fill(Rotation, dmDrawWithTransparencY);
              // Add overlay
              OverlayBmp := GetOverlay(CurToken.OverlayIdx);
              if Assigned(OverlayBmp) then
              begin
                OverlayScaled := OverlayBmp.Resample(Round(OverlayBmp.Width * FDisplayScale * FZoomFactor), Round(OverlayBmp.Height  * FDisplayScale * FZoomFactor));
                OverlayScaled.Draw(RotatedBmp.Canvas,
                                   (RotatedBmp.Width - TokenBmp.Width) div 2,
                                   (RotatedBmp.Height - TokenBmp.Height) div 2,
                                   False);
                OverlayScaled.Free;
              end;
              RotatedBmp.Draw(DrawnMapSegment.Canvas,
                              MapToViewPortX(CurToken.XEndPos) - RotatedBmp.Width div 2,
                              MapToViewPortY(CurToken.YEndPos) - RotatedBmp.Height div 2,
                              False);
            finally
              Rotation.Free;
              RotatedBmp.Free;
            end;
          finally
            TokenBmp.Free;
          end;
        end;
        // Draw Marker
        if FShowMarker then
        begin
          CurMarkerX := MapToViewPortX(FMarkerPosX);
          CurMarkerY := MapToViewPortY(FMarkerPosY);
          DrawnMapSegment.EllipseAntialias(CurMarkerX, CurMarkerY, 3, 3, clRed, 2);
        end;

        DrawnMapSegment.Draw(pbViewPort.Canvas, 0, 0, False);
      finally
        DrawnMapSegment.Free;
      end;

    finally
      ScaledBmp.Free;
    end;
  end;

  // Draw Bounds of Display window
  pbViewPort.Canvas.Brush.Style := bsClear;
  pbViewPort.Canvas.Pen.Width := 3;
  pbViewPort.Canvas.Pen.Color := clBlack;
  pbViewPort.Canvas.Rectangle(0, 0, FViewRectWidth, FViewRectHeight);
end;

procedure TfmController.pPortraitDragDrop(Sender, Source: TObject; X, Y: Integer
  );
begin
  if (Source is TTreeView) and Assigned(TTreeView(Source).Selected) and Assigned(TTreeView(Source).Selected.Data) then
    fmDisplay.PortraitFileName := TTokenNodeData(TTreeView(Source).Selected.Data).FullPath;
end;

procedure TfmController.pPortraitDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TTreeView);
end;

procedure TfmController.pPortraitResize(Sender: TObject);
begin
  UpdateViewPort;
end;

procedure TfmController.tbClearInitiativeClick(Sender: TObject);
begin
  lvInitiative.Clear;
end;

procedure TfmController.tbClearTokensClick(Sender: TObject);
var
  i: Integer;
  CurToken: TToken;
begin
  for i := FTokenlist.Count - 1 downto 0 do
  begin
    CurToken := TToken(FTokenList[i]);
    CurToken.Free;
    FTokenlist.Delete(i);
  end;
  pbViewPort.Invalidate;
  fmDisplay.Invalidate;
end;

procedure TfmController.tbCombatModeClick(Sender: TObject);
begin
  SetCombatMode(tbCombatMode.Down);
end;

procedure TfmController.SetCombatMode(val: Boolean);  
var
  i: Integer;
  bmp: TPicture;
begin
  FCombatMode := val;
  fmDisplay.CombatMode := FCombatMode;
  tbNextCombatant.Enabled := False;
  tbCombatMode.Down := FCombatMode;
  tbClearInitiative.Enabled := not FCombatMode;
  tbRemoveFromInitiative.Enabled := FCombatMode;
  if FCombatMode and (lvInitiative.Items.Count > 0) then
  begin
    tbNextCombatant.Enabled := True;
    // Sort List by initiative, descending
    lvInitiative.Sort;
    FCurInitiativeIndex := 0;
    // Generate list of bitmaps
    for i := 0 to lvInitiative.Items.Count - 1 do
    begin
      bmp := TPicture.Create;
      bmp.LoadFromFile(lvInitiative.Items[i].SubItems[2]);
      FInitiativeList.Add(bmp);
    end;
    // Mark first item
    lvInitiative.Items[0].Caption := '>';
  end;
  if not FCombatMode then
  begin
    for i := 0 to lvInitiative.Items.Count - 1 do
      lvInitiative.Items[i].Caption := '';
    for i := FInitiativeList.Count - 1 downto 0 do
    begin
      bmp := TPicture(FInitiativeList[i]);
      FInitiativeList.Delete(i);
      bmp.Free;
    end;
  end;
end;

function TfmController.MapToViewPortX(MapX: Single): Integer;
begin
  Result := Round(MapX * FDisplayScale * FZoomFactor - FViewRectXOffset);
end;

function TfmController.MapToViewPortY(MapY: Single): Integer;
begin
  Result := Round(MapY * FDisplayScale * FZoomFactor - FViewRectYOffset);
end;

function TfmController.ViewPortToMapX(ViewPortX: Integer): Integer;
begin
  Result := Round((ViewPortX + FViewRectXOffset) / FDisplayScale / FZoomFactor);
end;

function TfmController.ViewPortToMapY(ViewPortY: Integer): Integer;
begin
  Result := Round((ViewPortY + FViewRectYOffset) / FDisplayScale / FZoomFactor);
end;

procedure TfmController.SetCurInitiativeIndex(val: Integer);
begin
  FCurInitiativeIndex := val mod lvInitiative.Items.Count;
end;

function TfmController.GetTokenAtPos(X, Y: Integer): TToken;
var
  i: Integer;
  SearchPnt: TPoint;
  CurToken: TToken;
  TokenRect: TRect;
begin
  Result := nil;
  SearchPnt := Point(ViewPortToMapX(X), ViewPortToMapY(Y));
  // We search the list backwards, because the tokens are drawn first to last,
  // meaning the later ones are the highest in z-order
  for i := FTokenList.Count - 1 downto 0 do
  begin
    CurToken := TToken(FTokenList.Items[i]);
    TokenRect := Bounds(CurToken.XEndPos - CurToken.Width div 2,
                        CurToken.YEndPos - CurToken.Height div 2,
                        CurToken.Width,
                        CurToken.Height);
    if TokenRect.Contains(SearchPnt) then
    begin
      Result := CurToken;
      Break;
    end;
  end;
end;

procedure TfmController.tbExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfmController.tbGridSettingsClick(Sender: TObject);
//var
  {OldGridSizeX, OldGridSizeY, OldGridOffsetX, OldGridOffsetY: Single;
  OldGridType: TGridType;
  OldGridColor: TColor;}
  //i: Integer;
  //CurToken: TToken;
begin
  FOldGridSizeX := FGridSizeX;    
  FOldGridSizeY := FGridSizeY;
  FOldGridOffsetX := FGridOffsetX;
  FOldGridOffsetY := FGridOffsetY;
  FOldGridColor := FGridColor;
  FOldGridType := FGridType;
  fmGridSettings.fseGridOffsetX.Value := FGridOffsetX;    
  fmGridSettings.fseGridOffsetY.Value := FGridOffsetY;
  fmGridSettings.fseGridSizeX.Value   := FGridSizeX;
  fmGridSettings.fseGridSizeY.Value   := FGridSizeY;
  fmGridSettings.pGridColor.Color     := FGridColor;
  fmGridSettings.cbGridType.ItemIndex := Ord(FGridType);
  fmGridSettings.Show;
  {if fmGridSettings.ShowModal = mrOK then
  begin
    FGridOffsetX := fmGridSettings.fseGridOffsetX.Value;
    FGridOffsetY := fmGridSettings.fseGridOffsetY.Value;
    FGridSizeX   := fmGridSettings.fseGridSizeX.Value;    
    FGridSizeY   := fmGridSettings.fseGridSizeY.Value;
    FGridColor   := fmGridSettings.pGridColor.Color;
    FGridType    := TGridType(fmGridSettings.cbGridType.ItemIndex);
    fmDisplay.GridOffsetX := FGridOffsetX;
    fmDisplay.GridOffsetY := FGridOffsetY;
    fmDisplay.GridSizeX   := FGridSizeX;   
    fmDisplay.GridSizeY   := FGridSizeY;
    fmDisplay.GridColor   := FGridColor;
    fmDisplay.GridType    := FGridType;
    if FSnapTokensToGrid then
    begin
      for i := 0 to FTokenlist.Count - 1 do
      begin
        CurToken := TToken(FTokenList[i]);
        CurToken.XPos := CurToken.XEndPos - Round(OldGridOffsetX + FGridOffsetX);
        CurToken.YPos := CurToken.YEndPos - Round(OldGridOffsetY + FGridOffsetY);
        CurToken.SnapToGrid(FGridSizeX, FGridSizeY, FGridOffsetX, FGridOffsetY, FGridType);
      end;
    end;
  end
  else
  begin
    FGridSizeX   := OldGridSizeX;
    FGridSizeY   := OldGridSizeY;
    FGridOffsetX := OldGridOffsetX;
    FGridOffsetY := OldGridOffsetY;
    FGridColor   := OldGridColor;
    FGridType    := OldGridType;
  end;
  pbViewPort.Invalidate;}
end;

procedure TfmController.tbHideMarkerClick(Sender: TObject);
begin
  FShowMarker := False;
  pbViewPort.Invalidate;
end;

procedure TfmController.tbHidePortraitClick(Sender: TObject);
begin
  fmDisplay.PortraitFileName := '';
end;

procedure TfmController.tbHideTokensClick(Sender: TObject);
begin
  FShowTokens := tbHideTokens.Down;
  pbViewPort.Invalidate;
  fmDisplay.Invalidate;
end;

procedure TfmController.tbLibraryClick(Sender: TObject);
begin
  fmLibrary.Show;
  {FMapLib.SaveToFile(MAPLIBFILE);
  FTokenLib.SaveToFile(TOKENLIBFILE);
  FOverlayLib.SaveToFile(OVERLAYLIBFILE);

  UpdateMapList; // Maybe change just names here?
  UpdateTokenList;
  UpdateOverlayList;}
end;

procedure TfmController.tbMapZoomChange(Sender: TObject);
begin
  // Gives *0.2 at -100 and *5 at +100
  FZoomFactor := Power(5, (tbMapZoom.Position - 100) / 100);
  fmDisplay.MapZoom := FZoomFactor;
  lZoom.Caption := IntToStr(Round(100 * FZoomFactor)) + '%';
  UpdateViewPort;
end;

procedure TfmController.tbNextCombatantClick(Sender: TObject);
begin
  if not FCombatMode then
    Exit;
  lvInitiative.Items[CurInitiativeIndex].Caption := '';
  CurInitiativeIndex := CurInitiativeIndex + 1;
  lvInitiative.Items[CurInitiativeIndex].Caption := '>';
  fmDisplay.Invalidate;
end;

procedure TfmController.tbRefreshMapsClick(Sender: TObject);
begin
  UpdateMapList;
end;

procedure TfmController.tbRefreshTokensClick(Sender: TObject);
begin
  UpdateTokenList;
end;

procedure TfmController.tbRemoveFromInitiativeClick(Sender: TObject);
var
  i, NewIndex: Integer;
  tmpPic: TPicture;
begin
  if (lvInitiative.ItemIndex >= 0) and FCombatMode then
  begin
    NewIndex := FCurInitiativeIndex;
    if FCurInitiativeIndex > lvInitiative.ItemIndex then
      Dec(NewIndex);
    tmpPic := TPicture(FInitiativeList.Items[lvInitiative.ItemIndex]);
    FInitiativeList.Delete(lvInitiative.ItemIndex);
    tmpPic.Free;
    lvInitiative.Items.Delete(lvInitiative.ItemIndex);
    FCurInitiativeIndex := NewIndex;
    for i := 0 to lvInitiative.Items.Count - 1 do
      lvInitiative.Items[i].Caption := IfThen(i = NewIndex, '>', '');
    fmDisplay.Invalidate;
  end;
end;

procedure TfmController.tbSaveSessionClick(Sender: TObject);
var
  saveFile: TIniFile;
  i: Integer;
  tmpItem: TListItem;
  CurToken: TToken;
begin
  if sdSaveSession.Execute then
  begin
    try
      saveFile := TIniFile.Create(sdSaveSession.FileName);

      // Map data
      saveFile.WriteString(SAVESECTIONMAP, 'MapFile', FMapFileName);
      saveFile.WriteInteger(SAVESECTIONMAP, 'OffsetX', FViewRectXOffset);
      saveFile.WriteInteger(SAVESECTIONMAP, 'OffsetY', FViewRectYOffset);
      saveFile.WriteFloat(SAVESECTIONMAP, 'ZoomFactor', FZoomFactor);
      saveFile.WriteBool(SAVESECTIONMAP, 'MarkerVisible', FShowMarker);
      saveFile.WriteInteger(SAVESECTIONMAP, 'MarkerX', FMarkerPosX);
      saveFile.WriteInteger(SAVESECTIONMAP, 'MarkerY', FMarkerPosY);

      // Grid data
      saveFile.WriteInteger(SAVESECTIONGRID, 'Type', Ord(FGridType));
      saveFile.WriteBool(SAVESECTIONGRID, 'GridVisible', FShowGrid); 
      saveFile.WriteBool(SAVESECTIONGRID, 'Snap', FSnapTokensToGrid);
      saveFile.WriteFloat(SAVESECTIONGRID, 'SizeX', FGridSizeX);
      saveFile.WriteFloat(SAVESECTIONGRID, 'SizeY', FGridSizeY);
      saveFile.WriteFloat(SAVESECTIONGRID, 'OffsetX', FGridOffsetX);
      saveFile.WriteFloat(SAVESECTIONGRID, 'OffsetY', FGridOffsetY);
      saveFile.WriteInteger(SAVESECTIONGRID, 'Color', FGridColor);

      // Portrait
      saveFile.WriteString(SAVESECTIONPORTRAIT, 'FileName', fmDisplay.PortraitFileName);

      // Initiative
      saveFile.WriteBool(SAVESECTIONINITIATIVE, 'CombatMode', FCombatMode);
      saveFile.WriteInteger(SAVESECTIONINITIATIVE, 'CurIndex', FCurInitiativeIndex);
      for i := 0 to lvInitiative.Items.Count - 1 do
      begin
        tmpItem := lvInitiative.Items[i];
        saveFile.WriteString(SAVESECTIONINITIATIVE, 'Name' + IntToStr(i), tmpItem.SubItems[0]);
        saveFile.WriteString(SAVESECTIONINITIATIVE, 'Value' + IntToStr(i), tmpItem.SubItems[1]);
        saveFile.WriteString(SAVESECTIONINITIATIVE, 'Path' + IntToStr(i), tmpItem.SubItems[2]);
      end;

      // Tokens
      saveFile.WriteBool(SAVESECTIONTOKENS, 'TokenVisible', FShowTokens);
      for i := 0 to FTokenList.Count - 1 do
      begin
        CurToken := TToken(FTokenList[i]);
        saveFile.WriteString(SAVESECTIONTOKENS, 'Path' + IntToStr(i), CurToken.Path);
        saveFile.WriteInteger(SAVESECTIONTOKENS, 'XPos' + IntToStr(i), CurToken.XEndPos);
        saveFile.WriteInteger(SAVESECTIONTOKENS, 'YPos' + IntToStr(i), CurToken.YEndPos);
        saveFile.WriteInteger(SAVESECTIONTOKENS, 'Width' + IntToStr(i), CurToken.Width);
        saveFile.WriteInteger(SAVESECTIONTOKENS, 'Height' + IntToStr(i), CurToken.Height);
        saveFile.WriteFloat(SAVESECTIONTOKENS, 'Angle' + IntToStr(i), CurToken.Angle);
        saveFile.WriteInteger(SAVESECTIONTOKENS, 'Overlay' + IntToStr(i), CurToken.OverlayIdx);
        saveFile.WriteBool(SAVESECTIONTOKENS, 'Visible' + IntToStr(i), CurToken.Visible);
        saveFile.WriteInteger(SAVESECTIONTOKENS, 'XSlots' + IntToStr(i), CurToken.GridSlotsX);
        saveFile.WriteInteger(SAVESECTIONTOKENS, 'YSlots' + IntToStr(i), CurToken.GridSlotsY);
      end;

      saveFile.UpdateFile;
    finally
      saveFile.Free;
    end;
  end;

end;

procedure TfmController.tbLoadSessionClick(Sender: TObject);
var
  saveFile: TIniFile;
  i: Integer;
  tmpItem: TListItem;
  CurToken: TToken;
  path: string;
begin
  if odLoadSession.Execute then
  begin
    saveFile := TIniFile.Create(odLoadSession.FileName);
    try
      // Map data
      LoadMap(saveFile.ReadString(SAVESECTIONMAP, 'MapFile', ''));
      FViewRectXOffset := saveFile.ReadInteger(SAVESECTIONMAP, 'OffsetX', 0);
      FViewRectYOffset := saveFile.ReadInteger(SAVESECTIONMAP, 'OffsetY', 0);
      FZoomFactor := saveFile.ReadFloat(SAVESECTIONMAP, 'ZoomFactor', 1);
      FShowMarker := saveFile.ReadBool(SAVESECTIONMAP, 'MarkerVisible', False);
      FMarkerPosX := saveFile.ReadInteger(SAVESECTIONMAP, 'MarkerX', -1);      
      FMarkerPosy := saveFile.ReadInteger(SAVESECTIONMAP, 'MarkerY', -1);

      // Grid data
      FGridType := TGridType(saveFile.ReadInteger(SAVESECTIONGRID, 'Type', 0));
      FShowGrid := saveFile.ReadBool(SAVESECTIONGRID, 'GridVisible', True);
      FSnapTokensToGrid := saveFile.ReadBool(SAVESECTIONGRID, 'Snap', False);
      FGridSizeX := saveFile.ReadInteger(SAVESECTIONGRID, 'SizeX', 100);     
      FGridSizeY := saveFile.ReadInteger(SAVESECTIONGRID, 'SizeY', 100);     
      FGridOffsetX := saveFile.ReadInteger(SAVESECTIONGRID, 'OffsetX', 0);
      FGridOffsetY := saveFile.ReadInteger(SAVESECTIONGRID, 'OffsetY', 0);
      FGridColor := saveFile.ReadInteger(SAVESECTIONGRID, 'Color', clSilver);
       
      // Portrait
      fmDisplay.PortraitFileName := saveFile.ReadString(SAVESECTIONPORTRAIT, 'FileName', '');

      // Initiative
      i := 0;
      lvInitiative.BeginUpdate;
      lvInitiative.Items.Clear;
      while saveFile.ValueExists(SAVESECTIONINITIATIVE, 'Name' + IntToStr(i)) do
      begin
        tmpItem := lvInitiative.Items.Add;
        tmpItem.Caption := '';
        tmpItem.SubItems.Add(saveFile.ReadString(SAVESECTIONINITIATIVE, 'Name' + IntToStr(i), ''));
        tmpItem.SubItems.Add(saveFile.ReadString(SAVESECTIONINITIATIVE, 'Value' + IntToStr(i), '0'));
        tmpItem.SubItems.Add(saveFile.ReadString(SAVESECTIONINITIATIVE, 'Path' + IntToStr(i), ''));
        Inc(i);
      end;
      lvInitiative.EndUpdate;
      SetCombatMode(saveFile.ReadBool(SAVESECTIONINITIATIVE, 'CombatMode', False));
      FCurInitiativeIndex := saveFile.ReadInteger(SAVESECTIONINITIATIVE, 'CurIndex', 0);
      if FCombatMode then
        for i := 0 to lvInitiative.Items.Count - 1 do
          lvInitiative.Items[i].Caption := IfThen(i = FCurInitiativeIndex, '>', '');

      // Tokens

      for i := FTokenList.Count - 1 downto 0 do
      begin
        CurToken := TToken(FTokenList[i]);
        CurToken.Free;
        FTokenList.Delete(i);
      end;

      FShowTokens := saveFile.ReadBool(SAVESECTIONTOKENS, 'TokenVisible', True);

      i := 0;
      while saveFile.ValueExists(SAVESECTIONTOKENS, 'XPos' + IntToStr(i)) do
      begin
        path := saveFile.ReadString(SAVESECTIONTOKENS, 'Path' + IntToStr(i), '-');
        if FileExists(path) then
        begin
          CurToken := TToken.Create(path,
                                    saveFile.ReadInteger(SAVESECTIONTOKENS, 'XPos' + IntToStr(i), 0),
                                    saveFile.ReadInteger(SAVESECTIONTOKENS, 'YPos' + IntToStr(i), 0),
                                    saveFile.ReadInteger(SAVESECTIONTOKENS, 'Width' + IntToStr(i), 100),
                                    saveFile.ReadInteger(SAVESECTIONTOKENS, 'Height' + IntToStr(i), 100));
          CurToken.Angle := saveFile.ReadFloat(SAVESECTIONTOKENS, 'Angle' + IntToStr(i), 0);
          CurToken.OverlayIdx := saveFile.ReadInteger(SAVESECTIONTOKENS, 'Overlay' + IntToStr(i), -1);
          CurToken.Visible := saveFile.ReadBool(SAVESECTIONTOKENS, 'Visible' + IntToStr(i), FTokensStartInvisible);
          CurToken.GridSlotsX := saveFile.ReadInteger(SAVESECTIONTOKENS, 'XSlots' + IntToStr(i), 1);               
          CurToken.GridSlotsY := saveFile.ReadInteger(SAVESECTIONTOKENS, 'YSlots' + IntToStr(i), 1);

          FTokenList.Add(CurToken);
        end;
        Inc(i);
      end;

      pbViewPort.Invalidate;
      fmDisplay.Invalidate;

    finally
      saveFile.Free;
    end;

  end;
end;

procedure TfmController.tbSettingsClick(Sender: TObject);
begin
  fmSettings.eMapDirectory.Text := FMapDir;
  fmSettings.eTokenDirectory.Text := FTokenDir;
  fmSettings.eOverlayDirectory.Text := FOverlayDir;
  fmSettings.cbTokensStartInvisible.Checked := FTokensStartInvisible;
  fmSettings.cbInitiativeOrder.ItemIndex := IfThen(FInitiativeDesc, 0, 1);
  fmSettings.cbLanguage.Items := GetLanguages;
  fmSettings.cbLanguage.ItemIndex := fmSettings.cbLanguage.Items.IndexOf(LanguageID);
  fmSettings.Show;
end;

procedure TfmController.tbShowGridClick(Sender: TObject);
begin
  FShowGrid := tbShowGrid.Down;
  //fmDisplay.ShowGrid := FShowGrid;
  pbViewPort.Invalidate;
end;

procedure TfmController.tbSnapTokensToGridClick(Sender: TObject);
var i: Integer;
begin
  FSnapTokensToGrid := tbSnapTokensToGrid.Down;
  if FSnapTokensToGrid then
  begin
    for i := 0 to FTokenList.Count - 1 do
      TToken(FTokenList[i]).SnapToGrid(FGridSizeX, FGridSizeY, FGridOffsetX, FGridOffsetY, FGridType);
    pbViewPort.Invalidate;
    fmDisplay.Invalidate;
  end;
end;

procedure TfmController.tvTokensDeletion(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node.Data) then
  begin
    TTokenNodeData(Node.Data).Free;
    Node.Data := nil;
  end;
end;

procedure TfmController.tvTokensDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := False;
end;

procedure TfmController.UpdateMapList;
var
  i: Integer;
  FileList: TStringList;
  FileName: string;
  title: string;
begin
  lvMaps.Clear;
  FileList := TStringList.Create;
  try
    FindAllFiles(FileList, FMapDir, PICFILEFILTER, True);
    for i := 0 to FileList.Count - 1 do
    begin
      FileName := FileList[i];
      with lvMaps.Items.Add do
      begin
        if FMapLib.IndexOfName(FileName) >= 0 then
          title := FMapLib.Values[FileName]
        else
          title := ExtractFileName(FileName);
        Caption := title;
        SubItems.Add(FileName);
      end;
    end;
  finally
    //FileList.Free; // Moved to separate thread
  end;
  TPicLoaderThread.Create(False, FileList, ilMapIcons.Width, ilMapIcons.Height);
end;

procedure TfmController.UpdateTokenList;
  procedure ParseDir(Dir: string; ParentNode: TTreeNode);
  var
    FileList, DirList, ContentList: TStringList;
    tmp: string;
    i: Integer;
    tmpNode: TTreeNode;
    title: string;
    NodeData: TTokenNodeData;
  begin
    if DirectoryExists(Dir) then
    begin
      FileList := FindAllFiles(Dir, PICFILEFILTER, False);
      DirList := FindAllDirectories(Dir, False);
      tmp := DirList.CommaText;
      for i := 0 to FileList.Count - 1 do
      begin
        title := ExtractFilename(FileList[i]); 
        NodeData := TTokenNodeData.Create;
        if FTokenLib.IndexOfName(FileList[i]) >= 0 then
        begin
          ContentList := TStringList.Create;
          try
            ContentList.Delimiter := '|';
            ContentList.StrictDelimiter := True;
            ContentList.DelimitedText := FTokenLib.Values[FileList[i]];
            if Length(ContentList[0]) > 0 then
              title := ContentList[0];
            // TODO: Create template object with further token data
            NodeData.Name              := title;
            NodeData.BaseInitiative    := StrToIntDef(ContentList[1], 0);
            NodeData.DefaultWidth      := StrToIntDef(ContentList[2], Round(FGridSizeX));
            NodeData.DefaultHeight     := StrToIntDef(ContentList[3], Round(FGridSizeY));
            NodeData.DefaultGridSlotsX := StrToIntDef(ContentList[4], 1);
            NodeData.DefaultGridSlotsY := StrToIntDef(ContentList[5], 1);
            NodeData.DefaultAngle      := -DegToRad(StrToFloatDef(ContentList[6], 0.0));
          finally
            ContentList.Free;
          end;
        end
        else
        begin
          NodeData.Name := title;
          NodeData.BaseInitiative := 0;
          NodeData.DefaultWidth := Round(FGridSizeX);
          NodeData.DefaultHeight := Round(FGridSizeY);
          NodeData.DefaultGridSlotsX := 1;
          NodeData.DefaultGridSlotsY := 1;
          NodeData.DefaultAngle := 0.0;
        end;

        with tvTokens.Items.AddChild(ParentNode, title) do
        begin
          Data := NodeData;
          TTokenNodeData(data).FullPath := FileList[i];
          // show thumbnail in treeview?
        end;
      end;

      for i := 0 to DirList.Count - 1 do
      begin
        tmp := DirList[i];
        tmp := Copy(tmp, Length(IncludeTrailingPathDelimiter(ExtractFileDir(DirList[i]))) + 1, Length(tmp));
        tmpNode := tvTokens.Items.AddChild(ParentNode, tmp);
        ParseDir(DirList[i], tmpNode);
      end;

      FileList.Free;
      DirList.Free;
    end;
  end;

begin
  tvTokens.BeginUpdate;
  tvTokens.Items.Clear;
  ParseDir(FTokenDir, nil);
  tvTokens.EndUpdate;
end;

procedure TfmController.UpdateOverlayList;
var
  i: Integer;
  FilePath: string;
  ContentList: TStringList;
  FullPic, ScaledPic: TBGRABitmap;
  vWidth, vHeight: Integer;
begin
  ContentList := TStringList.Create;
  try
    ContentList.Delimiter := '|';
    ContentList.StrictDelimiter := True;

    for i := 0 to FOverlayLib.Count - 1 do
    begin
      FilePath := FOverlayLib.Names[i];
      FOverlayLib.Objects[i] := nil;
      if FileExists(FilePath) then
      begin
        ContentList.DelimitedText := FOverlayLib.Values[FilePath];
        if ContentList.Count = 3 then
        begin
          vWidth := StrToIntDef(ContentList[1], 32);
          vHeight := StrToIntDef(ContentList[2], 32);
          FullPic := TBGRABitmap.Create(FilePath, True);
          try
            ScaledPic := FullPic.Resample(vWidth, vHeight);
            FOverlayLib.Objects[i] := ScaledPic;
          finally
            FullPic.Free;
          end;
        end;
      end;
    end;

  finally
    ContentList.Free;
  end;
end;

function TfmController.GetToken(idx: Integer): TToken;
begin
  Result := nil;
  if (idx >= 0) and (idx < FTokenList.Count) then
    Result := TToken(FTokenList.Items[idx]);
end;

function TfmController.GetTokenCount: Integer;
begin
  Result := FTokenList.Count;
end;

function TfmController.GetOverlay(idx: Integer): TBGRABitmap;
begin
  Result := nil;
  if (idx >= 0) and (idx < FOverlayLib.Count) then
    Result := TBGRABitmap(FOverlayLib.Objects[idx]);
end;

procedure TfmController.RemoveToken(token: TToken);
begin
  FTokenList.Remove(token);
  pbViewPort.Invalidate;
  fmDisplay.Invalidate;
end;

function TfmController.GetInitiative(idx: Integer): TPicture;
begin
  Result := nil;
  if (idx >= 0) and (idx < FInitiativeList.Count) then
    Result := TPicture(FInitiativeList.Items[idx]);
end;

function TfmController.GetInitiativeCount: Integer;
begin
  Result := FInitiativeList.Count;
end;

function TfmController.GetCurInitiativeIdx: Integer;
begin
  Result := FCurInitiativeIndex;
end;

procedure TfmController.SnapAllTokensToGrid;
var
  i: Integer;
  CurToken: TToken;
begin
  if FSnapTokensToGrid then
  begin
    for i := 0 to FTokenlist.Count - 1 do
    begin
      CurToken := TToken(FTokenList[i]);
      CurToken.XPos := CurToken.XEndPos - Round(FOldGridOffsetX + FGridOffsetX);
      CurToken.YPos := CurToken.YEndPos - Round(FOldGridOffsetY + FGridOffsetY);
      CurToken.SnapToGrid(FGridSizeX, FGridSizeY, FGridOffsetX, FGridOffsetY, FGridType);
    end;
  end;
end;

procedure TfmController.SnapTokenToGrid(Token: TToken);
begin
  if Assigned(Token) and FSnapTokensToGrid then
    Token.SnapToGrid(FGridSizeX, FGridSizeY, FGridOffsetX, FGridOffsetY, FGridType);
end;

procedure TfmController.SaveLibraryData;
begin
  FMapLib.SaveToFile(MAPLIBFILE);
  FTokenLib.SaveToFile(TOKENLIBFILE);
  FOverlayLib.SaveToFile(OVERLAYLIBFILE);

  UpdateMapList; // Maybe change just names here?
  UpdateTokenList;
  UpdateOverlayList;
end;

procedure TfmController.SaveSettings;
begin
  if not SameText(FMapDir, fmSettings.eMapDirectory.Text) then
  begin
    FMapDir := fmSettings.eMapDirectory.Text;
    UpdateMapList;
  end;
  if not SameText(FTokenDir, fmSettings.eTokenDirectory.Text) then
  begin
    FTokenDir := fmSettings.eTokenDirectory.Text;
    UpdateTokenList;
  end;
  if not SameText(FOverlayDir, fmSettings.eOverlayDirectory.Text) then
  begin
    FOverlayDir := fmSettings.eOverlayDirectory.Text;
    UpdateOverlayList;
  end;
  FTokensStartInvisible := fmSettings.cbTokensStartInvisible.Checked;
  FInitiativeDesc := fmSettings.cbInitiativeOrder.ItemIndex = 0;
  LanguageID := fmSettings.cbLanguage.Items[fmSettings.cbLanguage.ItemIndex];
  // Save changes to ini
  FAppSettings.WriteString('Settings', 'MapDir', FMapDir);
  FAppSettings.WriteString('Settings', 'TokenDir', FTokenDir);
  FAppSettings.WriteString('Settings', 'OverlayDir', FOverlayDir);
  FAppSettings.WriteString('Settings', 'InitiativeDesc', BoolToStr(FInitiativeDesc));
  FAppSettings.WriteString('Settings', 'TokensStartInvisible', BoolToStr(FTokensStartInvisible));
  FAppSettings.WriteString('Settings', 'Language', LanguageID);
  FAppSettings.UpdateFile;
end;

procedure TfmController.SaveGridData;
begin
  FOldGridSizeX   := FGridSizeX;
  FOldGridSizeY   := FGridSizeY;
  FOldGridOffsetX := FGridOffsetX;
  FOldGridOffsetY := FGridOffsetY;
  FOldGridColor   := FGridColor;
  FOldGridType    := FGridType;
end;

procedure TfmController.RestoreGridData;
begin
  FGridSizeX   := FOldGridSizeX;
  FGridSizeY   := FOldGridSizeY;
  FGridOffsetX := FOldGridOffsetX;
  FGridOffsetY := FOldGridOffsetY;
  FGridColor   := FOldGridColor;
  FGridType    := FOldGridType;
  pbViewPort.Invalidate;
end;

procedure TfmController.AddToInitiative(pName, Path: string; Value: Integer);
var
  tmpItem: TListItem;
begin
  tmpItem := lvInitiative.Items.Add;
  tmpItem.Caption := '';
  tmpItem.SubItems.Add(pName);
  tmpItem.SubItems.Add(IntToStr(Value));
  tmpItem.SubItems.Add(Path);
end;

procedure TfmController.UpdateViewport;
var
  DisplayMapWidth, DisplayMapHeight: Integer;
begin
  DisplayMapWidth := fmDisplay.ClientWidth - HMARGIN - HMARGIN - PORTRAITWIDTH - HMARGIN;
  DisplayMapHeight := fmDisplay.ClientHeight - VMARGIN - VMARGIN;

  if Round(pbViewPort.Width / DisplayMapWidth * DisplayMapHeight) <= pbViewPort.Height then
  begin                                                 
    FDisplayScale := pbViewPort.Width / DisplayMapWidth;
    FViewRectWidth := pbViewPort.Width;
    FViewRectHeight := Round(FDisplayScale * DisplayMapHeight);
  end
  else
  begin
    FDisplayScale := pbViewPort.Height / DisplayMapHeight;
    FViewRectWidth := Round(FDisplayScale * DisplayMapWidth);
    FViewRectHeight := pbViewPort.Height;
  end;
  
  FViewRectMaxXOffset := 0;   
  FViewRectMaxYOffset := 0;
  if Assigned(FMapPic) then
  begin
    FViewRectMaxXOffset := Max(0, Round(FMapPic.Width * FDisplayScale * FZoomFactor) - FViewRectWidth);
    FViewRectMaxYOffset := Max(0, Round(FMapPic.Height * FDisplayScale * FZoomFactor) - FViewRectHeight);
  end;
  FViewRectXOffset := EnsureRange(FViewRectXOffset, 0, FViewRectMaxXOffset);
  FViewRectYOffset := EnsureRange(FViewRectYOffset, 0, FViewRectMaxYOffset);
  fmDisplay.MapOffsetX := Round(FViewRectXOffset / FDisplayScale);
  fmDisplay.MapOffsetY := Round(FViewRectYOffset / FDisplayScale);

  pbViewPort.Invalidate;
end;

procedure TfmController.bFullscreenClick(Sender: TObject);
begin
  if tbFullscreen.Down then
  begin
    fmDisplay.WindowState := wsFullScreen;
    fmDisplay.BorderStyle := bsNone;
  end
  else
  begin
    fmDisplay.WindowState := wsNormal;
    fmDisplay.BorderStyle := bsSizeable;
  end;     
  fmDisplay.FormResize(fmDisplay);
end;

procedure TfmController.bRefreshMapsClick(Sender: TObject);
begin
  UpdateMapList;
end;

procedure TfmController.bResetZoomClick(Sender: TObject);
begin
  tbMapZoom.Position := 100;
end;

procedure TfmController.FormCreate(Sender: TObject);
var LangID, FallbackLangID, LangName: string;
begin
  FMapPic := nil;
  FTokenList := TList.Create;
  FInitiativeList := TList.Create;
  FAppSettings := TIniFile.Create('Settings.ini', [ifoWriteStringBoolean]);

  FMapDir := FAppSettings.ReadString('Settings', 'MapDir', 'Content\Maps\');
  FTokenDir := FAppSettings.ReadString('Settings', 'TokenDir', 'Content\Tokens\');
  FOverlayDir := FAppSettings.ReadString('Settings', 'OverlayDir', 'Content\Overlays\');
  FInitiativeDesc := StrToBoolDef(FAppSettings.ReadString('Settings', 'InitiativeDesc', 'true'), True);
  FTokensStartInvisible := StrToBoolDef(FAppSettings.ReadString('Settings', 'TokensStartInvisible', 'true'), True);

  LangName := 'English';
  GetLanguageIDs(LangID, FallbackLangID);
  if SameText(FallbackLangID, 'de') then
    LangName := 'Deutsch';
  LanguageID := FAppSettings.ReadString('Settings', 'Language', LangName);

  FIsDragging := False;
  FIsDraggingToken := False;
  FIsRotatingToken := False;
  FZoomFactor := 1;
  FGridSizeX := 100;
  FGridSizeY := 100;
  FGridColor := clSilver;
  FShowGrid := True;
  FGridType := gtRect;
  FShowMarker := False;
  FShowTokens := True;
  FSnapTokensToGrid := False;
  FCombatMode := False;

  FMapLib := TStringList.Create;
  if FileExists(MAPLIBFILE) then
    FMapLib.LoadFromFile(MAPLIBFILE)
  else
    FMapLib.SaveToFile(MAPLIBFILE);
  FTokenLib := TStringList.Create;
  if FileExists(TOKENLIBFILE) then
    FTokenLib.LoadFromFile(TOKENLIBFILE)
  else
    FTokenlib.SaveToFile(TOKENLIBFILE);
  FOverlayLib := TStringList.Create;
  if FileExists(OVERLAYLIBFILE) then
    FOverlayLib.LoadFromFile(OVERLAYLIBFILE)
  else
    FOverlayLib.SaveToFile(OVERLAYLIBFILE);
end;

procedure TfmController.FormDestroy(Sender: TObject);
begin
  if Assigned(FMapPic) then
    FMapPic.Free;
  FTokenList.Free;
  FInitiativeList.Free;
  FAppSettings.WriteString('Settings', 'MapDir', FMapDir);
  FAppSettings.WriteString('Settings', 'TokenDir', FTokenDir);
  FAppSettings.WriteString('Settings', 'OverlayDir', FOverlayDir);
  FAppSettings.WriteString('Settings', 'InitiativeDesc', BoolToStr(FInitiativeDesc));
  FAppSettings.WriteString('Settings', 'TokensStartInvisible', BoolToStr(FTokensStartInvisible));
  FAppSettings.UpdateFile;
  FAppSettings.Free;
  FMapLib.Free;
  FTokenLib.Free;
  FOverlayLib.Free;
end;

procedure TfmController.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 122 then // VK_F11
  begin
    tbFullScreen.Down := not tbFullScreen.Down;
    bFullScreenClick(Sender);
  end
  else if Key = 32 then // VK_SPACE
  begin
    if FCombatMode then
      tbNextCombatantClick(self);
  end;
end;

procedure TfmController.FormResize(Sender: TObject);
begin
  UpdateViewport;
end;

{ TPicLoaderThread }

constructor TPicLoaderThread.Create(CreateSuspended: Boolean; FileList: TStringList; Width, Height: Integer);
begin
  FFileList := FileList;
  Thumbnail := TBitmap.Create;
  Thumbnail.Width := Width;
  Thumbnail.Height := Height;
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TPicLoaderThread.SetThumbnail;
var tmpItem: TListItem;
begin
  if (CurIdx < 0) or (CurIdx > fmController.lvMaps.Items.Count - 1) then
    Exit;
  tmpItem := fmController.lvMaps.Items[CurIdx];
  tmpItem.ImageIndex := fmController.ilMapIcons.Add(Thumbnail, nil);
  //tmpItem.StateIndex:= 0;
end;

procedure TPicLoaderThread.Execute;
var
  i: Integer;
  FullPic, ScaledPic: TBGRABitmap;
begin
  i := 0;
  FullPic := TBGRABitmap.Create(0, 0);
  while (not Terminated) and (i < FFileList.Count) do
  begin  
    FullPic.LoadFromFile(FFileList[i]);
    try
      ScaledPic := FullPic.Resample(Thumbnail.Width, Thumbnail.Height, rmSimpleStretch);
      ScaledPic.Draw(Thumbnail.Canvas, Rect(0, 0, Thumbnail.Width, Thumbnail.Height));
      //Thumbnail.Canvas.StretchDraw(Rect(0, 0, Thumbnail.Width, Thumbnail.Height), Fullpic.Graphic);

    finally
      ScaledPic.Free;
    end;
    CurIdx := i;
    Synchronize(@SetThumbnail);

    Inc(i);
  end;
  FullPic.Free;
  Thumbnail.Free;
  FFileList.Free;
end;

end.

