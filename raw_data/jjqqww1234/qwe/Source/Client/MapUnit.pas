unit MapUnit;

interface

uses
  Windows, Classes, SysUtils, Grobal2, HUtil32, DXDraws, CliUtil;

const
  MAPDIR = 'Map\';
  MAXX   = 40;
  MAXY   = 40;

type
  // -------------------------------------------------------------------------------
  // Map
  // -------------------------------------------------------------------------------

  TMapPrjInfo = record
    Ident:    string[16];
    ColCount: integer;
    RowCount: integer;
  end;

{  TMapHeader = record
     Width  : word;
     Height : word;
     Title: string[16];
     UpdateDate: TDateTime;
     Reserved  : array[0..19] of char;
  end;}

  TMapHeader = packed record
    Width:      word;
    Height:     word;
    Title:      string[20];
    UpdateDate: TDateTime;
    Reserved:   array[0..18] of char;
  end;

  TMapHeader_AntiHack = packed record //####
    Title:      string[30];
    Width:      word;
    CheckKey:   word; //체크값=43576
    Height:     word;
    UpdateDate: TDateTime;
    Reserved:   array[0..18] of char;
  end;

  TMapInfo = record
    BkImg: word;
    MidImg: word;
    FrImg: word;
    DoorIndex: byte;     //$80 (문짝), 문의 식별 인덱스
    DoorOffset: byte;    //닫힌 문의 그림의 상대 위치, $80 (열림/닫힘(기본))
    AniFrame: byte;      //$80(Draw Alpha) +  프래임 수
    AniTick: byte;
    Area:  byte;        //지역 정보
    light: byte;        //0..1..4 광원 효과
  end;
  PTMapInfo = ^TMapInfo;

  TMapInfoArr  = array[0..MaxListSize] of TMapInfo;
  PTMapInfoArr = ^TMapInfoArr;

  TMap = class
  private
    function loadmapinfo(mapfile: string; var Width, Height: integer): boolean;
    procedure updatemapseg(cx, cy: integer); //, maxsegx, maxsegy: integer);
    procedure updatemap(cx, cy: integer);
  public
    MapBase:   string;
    MArr:      array[0..MAXX * 3, 0..MAXY * 3] of TMapInfo;
    ClientRect: TRect;
    OldClientRect: TRect;
    BlockLeft, BlockTop: integer; //타일 좌표로 왼쪽, 꼭대기 좌표
    oldleft, oldtop: integer;
    oldmap:    string;
    CurUnitX, CurUnitY: integer;
    CurrentMap: string;
    Segmented: boolean;
    SegXCount, SegYCount: integer;
    constructor Create;
    destructor Destroy; override;
    procedure UpdateMapSquare(cx, cy: integer);
    procedure UpdateMapPos(mx, my: integer);
    procedure ReadyReload;
    procedure LoadMap(mapname: string; mx, my: integer);
    procedure MarkCanWalk(mx, my: integer; bowalk: boolean);
    function CanMove(mx, my: integer): boolean;
    function CanFly(mx, my: integer): boolean;
    function GetDoor(mx, my: integer): integer;
    function IsDoorOpen(mx, my: integer): boolean;
    function OpenDoor(mx, my: integer): boolean;
    function CloseDoor(mx, my: integer): boolean;
  end;

procedure DrawMiniMap;

implementation

uses
  ClMain;

constructor TMap.Create;
begin
  inherited Create;
  //GetMem (MInfoArr, sizeof(TMapInfo) * LOGICALMAPUNIT * 3 * LOGICALMAPUNIT * 3);
  ClientRect := Rect(0, 0, 0, 0);
  MapBase    := '.\Map\';
  CurrentMap := '';
  Segmented  := False;
  SegXCount  := 0;
  SegYCount  := 0;
  CurUnitX   := -1;
  CurUnitY   := -1;
  BlockLeft  := -1;
  BlockTop   := -1;
  oldmap     := '';
end;

destructor TMap.Destroy;
begin
  inherited Destroy;
end;

function TMap.loadmapinfo(mapfile: string; var Width, Height: integer): boolean;
var
  flname:  string;
  fhandle: integer;
  header:  TMapHeader;
begin
  Result := False;
  flname := MapBase + mapfile;
  if FileExists(flname) then begin
    fhandle := FileOpen(flname, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then begin
      FileRead(fhandle, header, sizeof(TMapHeader));
      Width  := header.Width;
      Height := header.Height;
    end;
    FileClose(fhandle);
  end;
end;

//segmented map 인 경우
procedure TMap.updatemapseg(cx, cy: integer); //, maxsegx, maxsegy: integer);
begin

end;

{procedure TMap.updatemap (cx, cy: integer);
var
   fhandle, i, k, aline, lx, rx, ty, by: integer;
   header: TMapHeader;
   flname: string;
begin
   FillChar (MArr, sizeof(MArr), 0);
   flname := MapBase + CurrentMap + '.map';
   if FileExists (flname) then begin
      fhandle := FileOpen (flname, fmOpenRead or fmShareDenyNone);
      if fhandle > 0 then begin
         FileRead (fhandle, header, sizeof(TMapHeader));
         lx := (cx - 1) * LOGICALMAPUNIT;
         rx := (cx + 2) * LOGICALMAPUNIT;    //rx
         ty := (cy - 1) * LOGICALMAPUNIT;
         by := (cy + 2) * LOGICALMAPUNIT;
         if lx < 0 then lx := 0;
         if ty < 0 then ty := 0;
         if by >= header.Height then by := header.Height;
         aline := sizeof(TMapInfo) * header.Height;
         for i:=lx to rx-1 do begin
            if (i >= 0) and (i < header.Width) then begin
               FileSeek (fhandle, sizeof(TMapHeader) + (aline * i) + (sizeof(TMapInfo) * ty), 0);
               FileRead (fhandle, MArr[i-lx, 0], sizeof(TMapInfo) * (by-ty));
            end;
         end;
         FileClose (fhandle);
      end;
   end;
end;}

//single map인 경우
procedure TMap.updatemap(cx, cy: integer);
var
  fhandle, i, j, k, aline, lx, rx, ty, by: integer;
  header:  TMapHeader;
  header2: TMapHeader_AntiHack;
  flname, Tempstr: string;
begin
  FillChar(MArr, sizeof(MArr), 0);
  flname  := MapBase + CurrentMap + '.map';
  Tempstr := UpperCase(CurrentMap);
  if FileExists(flname) then begin
    if (Tempstr = 'LABY01') or (Tempstr = 'LABY02') or (Tempstr = 'LABY03') or
      (Tempstr = 'LABY04') or (Tempstr = 'SNAKE') then begin
      fhandle := FileOpen(flname, fmOpenRead or fmShareDenyNone);
      if fhandle > 0 then begin
        FileRead(fhandle, header2, sizeof(TMapHeader_AntiHack));
        header2.Width  := header2.Width xor header2.CheckKey;
        header2.Height := header2.Height xor header2.CheckKey;

        lx := (cx - 1) * LOGICALMAPUNIT;
        rx := (cx + 2) * LOGICALMAPUNIT;    //rx
        ty := (cy - 1) * LOGICALMAPUNIT;
        by := (cy + 2) * LOGICALMAPUNIT;
        if lx < 0 then
          lx := 0;
        if ty < 0 then
          ty := 0;
        if by >= header2.Height then
          by := header2.Height;
        aline := sizeof(TMapInfo) * header2.Height;
        for i := lx to rx - 1 do begin
          for j := ty to by do begin
            //                  if (i >= 0) and (i < header.Width) then begin
            FileSeek(fhandle, sizeof(TMapHeader_AntiHack) + (aline * i) +
              (sizeof(TMapInfo) * j), 0);
            FileRead(fhandle, MArr[i - lx, j - ty], sizeof(TMapInfo));
            MArr[i - lx, j - ty].BkImg  :=
              MArr[i - lx, j - ty].BkImg xor header2.CheckKey;
            MArr[i - lx, j - ty].MidImg :=
              MArr[i - lx, j - ty].MidImg xor header2.CheckKey;
            MArr[i - lx, j - ty].FrImg  :=
              MArr[i - lx, j - ty].FrImg xor header2.CheckKey;
            //                  end;
          end;
        end;
        FileClose(fhandle);
      end;
    end else begin
      fhandle := FileOpen(flname, fmOpenRead or fmShareDenyNone);
      if fhandle > 0 then begin
        FileRead(fhandle, header, sizeof(TMapHeader));
        lx := (cx - 1) * LOGICALMAPUNIT;
        rx := (cx + 2) * LOGICALMAPUNIT;    //rx
        ty := (cy - 1) * LOGICALMAPUNIT;
        by := (cy + 2) * LOGICALMAPUNIT;
        if lx < 0 then
          lx := 0;
        if ty < 0 then
          ty := 0;
        if by >= header.Height then
          by := header.Height;
        aline := sizeof(TMapInfo) * header.Height;
        for i := lx to rx - 1 do begin
          if (i >= 0) and (i < header.Width) then begin
            FileSeek(fhandle, sizeof(TMapHeader) + (aline * i) +
              (sizeof(TMapInfo) * ty), 0);
            FileRead(fhandle, MArr[i - lx, 0], sizeof(TMapInfo) * (by - ty));
          end;
        end;
        FileClose(fhandle);
      end;
    end;
  end;
end;

procedure TMap.ReadyReload;
begin
  CurUnitX := -1;
  CurUnitY := -1;
end;

//cx, cy: 중앙, Counted by unit..
procedure TMap.UpdateMapSquare(cx, cy: integer);
begin
  if (cx <> CurUnitX) or (cy <> CurUnitY) then begin
    if Segmented then
      updatemapseg(cx, cy)
    else
      updatemap(cx, cy);
    CurUnitX := cx;
    CurUnitY := cy;
  end;
end;

//주캐릭이 이동시 빈번이 호출..
procedure TMap.UpdateMapPos(mx, my: integer);
var
  cx, cy: integer;

  procedure Unmark(xx, yy: integer);
  var
    ax, ay: integer;
  begin
    if (cx = xx div LOGICALMAPUNIT) and (cy = yy div LOGICALMAPUNIT) then begin
      ax := xx - BlockLeft;
      ay := yy - BlockTop;
      MArr[ax, ay].FrImg := MArr[ax, ay].FrImg and $7FFF;
      MArr[ax, ay].BkImg := MArr[ax, ay].BkImg and $7FFF;
    end;
  end;

begin
  cx := mx div LOGICALMAPUNIT;
  cy := my div LOGICALMAPUNIT;
  BlockLeft := _MAX(0, (cx - 1) * LOGICALMAPUNIT);
  BlockTop := _MAX(0, (cy - 1) * LOGICALMAPUNIT);

  UpdateMapSquare(cx, cy);

  if (oldleft <> BlockLeft) or (oldtop <> BlockTop) or (oldmap <> CurrentMap) then begin
    //3번맵 성벽자리 버그 보정 (2001-7-3)
    if CurrentMap = '3' then begin
      Unmark(624, 278);
      Unmark(627, 278);
      Unmark(634, 271);

      Unmark(564, 287);
      Unmark(564, 286);
      Unmark(661, 277);
      Unmark(578, 296);
    end;
  end;
  oldleft := BlockLeft;
  oldtop  := BlockTop;
end;

//맵변경시 처음 한번 호출..
procedure TMap.LoadMap(mapname: string; mx, my: integer);
begin
  CurUnitX   := -1;
  CurUnitY   := -1;
  CurrentMap := mapname;
  Segmented  := False; //Segmented 되어 있는지 검사한다.
  UpdateMapPos(mx, my);
  oldmap := CurrentMap;
end;

procedure TMap.MarkCanWalk(mx, my: integer; bowalk: boolean);
var
  cx, cy: integer;
begin
  cx := mx - BlockLeft;
  cy := my - BlockTop;
  if (cx < 0) or (cy < 0) then
    exit;
  if bowalk then //걸을 수 있음
    Map.MArr[cx, cy].FrImg := Map.MArr[cx, cy].FrImg and $7FFF
  else //막혔음
    Map.MArr[cx, cy].FrImg := Map.MArr[cx, cy].FrImg or $8000;  //못움직이게 한다.
end;

function TMap.CanMove(mx, my: integer): boolean;
var
  cx, cy: integer;
begin
  Result := False;
  cx     := mx - BlockLeft;
  cy     := my - BlockTop;
  if (cx < 0) or (cy < 0) then
    exit;
  Result := ((Map.MArr[cx, cy].BkImg and $8000) +
    (Map.MArr[cx, cy].FrImg and $8000)) = 0;
  if Result then begin //문검사
    if Map.MArr[cx, cy].DoorIndex and $80 > 0 then begin  //문짝이 있음
      if (Map.MArr[cx, cy].DoorOffset and $80) = 0 then
        Result := False; //문이 안 열렸음.
    end;
  end;
end;

function TMap.CanFly(mx, my: integer): boolean;
var
  cx, cy: integer;
begin
  Result := False;
  cx     := mx - BlockLeft;
  cy     := my - BlockTop;
  if (cx < 0) or (cy < 0) then
    exit;
  Result := (Map.MArr[cx, cy].FrImg and $8000) = 0;
  if Result then begin //문검사
    if Map.MArr[cx, cy].DoorIndex and $80 > 0 then begin  //문짝이 있음
      if (Map.MArr[cx, cy].DoorOffset and $80) = 0 then
        Result := False; //문이 안 열렸음.
    end;
  end;
end;

function TMap.GetDoor(mx, my: integer): integer;
var
  cx, cy: integer;
begin
  Result := 0;
  cx     := mx - BlockLeft;
  cy     := my - BlockTop;
  if Map.MArr[cx, cy].DoorIndex and $80 > 0 then begin
    Result := Map.MArr[cx, cy].DoorIndex and $7F;
  end;
end;

function TMap.IsDoorOpen(mx, my: integer): boolean;
var
  cx, cy: integer;
begin
  Result := False;
  cx     := mx - BlockLeft;
  cy     := my - BlockTop;
  if Map.MArr[cx, cy].DoorIndex and $80 > 0 then begin
    Result := (Map.MArr[cx, cy].DoorOffset and $80 <> 0);
  end;
end;

function TMap.OpenDoor(mx, my: integer): boolean;
var
  i, j, cx, cy, idx: integer;
begin
  Result := False;
  cx     := mx - BlockLeft;
  cy     := my - BlockTop;
  if (cx < 0) or (cy < 0) then
    exit;
  if Map.MArr[cx, cy].DoorIndex and $80 > 0 then begin
    idx := Map.MArr[cx, cy].DoorIndex and $7F;
    for i := cx - 10 to cx + 10 do
      for j := cy - 10 to cy + 10 do begin
        if (i > 0) and (j > 0) then
          if (Map.MArr[i, j].DoorIndex and $7F) = idx then
            Map.MArr[i, j].DoorOffset := Map.MArr[i, j].DoorOffset or $80;
      end;
  end;
end;

function TMap.CloseDoor(mx, my: integer): boolean;
var
  i, j, cx, cy, idx: integer;
begin
  Result := False;
  cx     := mx - BlockLeft;
  cy     := my - BlockTop;
  if (cx < 0) or (cy < 0) then
    exit;
  if Map.MArr[cx, cy].DoorIndex and $80 > 0 then begin
    idx := Map.MArr[cx, cy].DoorIndex and $7F;
    for i := cx - 8 to cx + 10 do
      for j := cy - 8 to cy + 10 do begin
        if (Map.MArr[i, j].DoorIndex and $7F) = idx then
          Map.MArr[i, j].DoorOffset := Map.MArr[i, j].DoorOffset and $7F;
      end;
  end;
end;


const
  SCALE = 4;

procedure DrawMiniMap;
var
  sx, sy, ex, ey, i, j, imgnum, wunit, ani, ny, oheight, MX, MY: integer;
  d: TDirectDrawSurface;
begin
  MiniMapSurface.Fill(0);
  MX := UNITX div SCALE;
  MY := UNITY div SCALE;
  sx := _MAX(0, (Myself.XX - Map.BlockLeft) div 2 * 2 - 22);
  ex := _MIN(MAXX * 3, (Myself.XX - Map.BlockLeft) div 2 * 2 + 22);
  sy := _MAX(0, (Myself.YY - Map.BlockTop) div 2 * 2 - 22);
  ey := _MIN(MAXY * 3, (Myself.YY - Map.BlockTop) div 2 * 2 + 22);

  for i := 0 to ex - sx do begin
    for j := 0 to ey - sy do begin
      if (i >= 0) and (j < MAXY * 3) and ((i + sx) mod 2 = 0) and
        ((j + sy) mod 2 = 0) then  begin
        imgnum := (Map.MArr[sx + i, sy + j].BkImg and $7FFF);
        if imgnum > 0 then begin
          imgnum := imgnum - 1;
          d      := FrmMain.WTiles.Images[imgnum];
          if d <> nil then
            MiniMapSurface.StretchDraw(
              Rect(i * MX, j * MY, i * MX + d.Width div SCALE,
              j * MY + d.Height div SCALE),
              d.ClientRect,
              d,
              False);
        end;
      end;
    end;
  end;
  for i := 0 to ex - sx - 1 do begin
    for j := 0 to ey - sy - 1 do begin
      imgnum := Map.MArr[sx + i, sy + j].MidImg;
      if imgnum > 0 then begin
        imgnum := imgnum - 1;
        d      := FrmMain.WSmTiles.Images[imgnum];
        if d <> nil then
          MiniMapSurface.StretchDraw(
            Rect(i * MX, j * MY, i * MX + d.Width div SCALE, j *
            MY + d.Height div SCALE),
            d.ClientRect,
            d,
            True);
      end;
    end;
  end;
  for j := 0 to ey - sy - 1 + 25 do begin
    for i := 0 to ex - sx do begin
      if (i >= 0) and (i < MAXX * 3) and (j < MAXY * 3) then begin
        imgnum := (Map.MArr[sx + i, sy + j].FrImg and $7FFF);
        if imgnum > 0 then begin
          wunit := Map.MArr[sx + i, sy + j].Area;
          ani   := Map.MArr[sx + i, sy + j].AniFrame;
          if (ani and $80) > 0 then begin
            continue;
          end;
          imgnum := imgnum - 1;
          d      := FrmMain.GetObjs(wunit, imgnum);
          if d <> nil then begin
            ny := j * MY - d.Height div SCALE + MY;
            if ny < 360 then
              MiniMapSurface.StretchDraw(
                Rect(i * MX, ny, i * MX + d.Width div SCALE,
                ny + d.Height div SCALE),
                d.ClientRect,
                d,
                True);
          end;
        end;
      end;
    end;
  end;
  //DrawEffect (0, 0, MiniMapSurface.Width, MiniMapSurface.Height, MiniMapSurface, ceGrayScale);
end;


end.
