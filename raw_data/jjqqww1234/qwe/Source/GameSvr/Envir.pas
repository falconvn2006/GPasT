unit Envir;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  ScktComp, SyncObjs, MudUtil, HUtil32, Grobal2;

const
  MAX_MINIMAP  = 65;
  NAME_OF_GOLD = 'Gold';

type
  TMiniMapInfo = record
    Map: string;
    Idx: integer;
  end;

  TDoorCore = record
    DoorOpenState: boolean; //true: open  false: closed
    Lock:     boolean;
    LockKey:  integer;
    OpenTime: longword; //door open time
    RefCount: integer;
  end;
  PTDoorCore = ^TDoorCore;

  TDoorInfo = record
    DoorX:      integer;
    DoorY:      integer;
    DoorNumber: integer; //중복 가능함, 좌표와 함께 검사해야함
    PCore:      PTDoorCore;
  end;
  PTDoorInfo = ^TDoorInfo;

  TMapPrjInfo = record
    Ident:    string[16];
    ColCount: integer;
    RowCount: integer;
  end;

{
   TMapHeader = record
      Width  : word;
      Height : word;
      Title: string[16];
      UpdateDate: TDouble; //TDateTime;
      Reserved  : array[0..19] of AnsiChar;
   end;
}

  TMapHeader = packed record
    Width:      word;
    Height:     word;
    Title:      string[20];
    UpdateDate: TDateTime;
    Reserved:   array[0..18] of AnsiChar;
  end;

  TMapHeader_AntiHack = packed record
    Title:      string[30];
    Width:      word;
    CheckKey:   word; //체크값=43576
    Height:     word;
    UpdateDate: TDateTime;
    Reserved:   array[0..18] of AnsiChar;
  end;

  TMapFileInfo = record
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
  PTMapFileInfo = ^TMapFileInfo;

  TMapFileInfoArr  = array[0..MaxListSize] of TMapFileInfo;
  PTMapFileInfoArr = ^TMapFileInfoArr;

  TMapInfoArr  = array[0..MaxListSize] of TMapInfo;
  PTMapInfoArr = ^TMapInfoArr;

  //멥 퀘스트
  TMapQuestInfo = record
    SetNumber: integer;
    Value:     integer;
    MonName:   string;
    ItemName:  string;
    EnableGroup: boolean;
    QuestNpc:  TObject;
  end;

  PTMapQuestInfo = ^TMapQuestInfo;


  TEnvirnoment = class
  private
    procedure ResizeMap(xsize, ysize: longint);
  public
    MapName:   string;
    MapTitle:  string;
    MMap:      PTMapInfoArr;
    MiniMap:   integer;
    Server:    integer;
    NeedLevel: integer;
    MapWidth:  integer;
    MapHeight: integer;
    Darkness:  boolean;
    Dawn:      boolean;
    DayLight:  boolean;
    DoorList:  TList;
    BoCanGetItem: boolean;
    LawFull:   boolean;
    FightZone: boolean;
    Fight2Zone: boolean; //대련사냥터
    Fight3Zone: boolean; //3번까지 다시 살아난다.
    Fight4Zone: boolean;
    QuizZone:  boolean;  //이맵에서는 외치기를 할 수 없음..
    NoReconnect: boolean;
    NeedHole:  boolean;
    NoRecall:  boolean;
    NoRandomMove: boolean;
    NoEscapeMove: boolean;    // newly added by sonmg 2003/12/15...
    NoTeleportMove: boolean;  // newly added by sonmg 2003/12/15...
    NoDrug:    boolean;
    MineMap:   integer;
    NoPositionMove: boolean;
    BackMap:   string;
    MapQuest:  TObject;  //npc,  <> nil이면 맵에 들어가기 전에 퀘스트를 거친다.
    NeedSetNumber: integer;
    NeedSetValue: integer;
    AutoAttack: integer;
    GuildAgit: integer;
    NoChat:    boolean;   //채팅을 할 수 없는 맵 (sonmg 2004/10/12)
    NoGroup:   boolean;
    //그룹을 결성할 수 없는 맵(그룹이 된 멤버는 그룹 해제가 된다) (sonmg 2004/10/12)
    NoThrowItem: boolean;   //유저가 아이템을 버릴 수 없는 맵
    NoDropItem: boolean;   //유저가 죽어도 아이템을 떨구거나 깨지지 않는 맵

    MapQuestList: TList;

    MapQuestParams: array [0..9] of integer; //2004/08/27 맵 지역변수 추가(sonmg)

    constructor Create;
    destructor Destroy; override;
    function LoadMap(map: string): boolean;
    function GetMapXY(x, y: integer; var pm: PTMapInfo): boolean;
    function GetCreature(x, y: integer; aliveonly: boolean): TObject;
    function GetAllCreature(x, y: integer; aliveonly: boolean; list: TList): integer;
    function GetCreatureInRange(x, y, wide: integer; aliveonly: boolean;
      list: TList): integer;
    function IsValidCreature(x, y, checkrange: integer; cret: TObject): boolean;
    function IsValidFrontCreature(x, y, checkrange: integer;
      var cret: TObject): boolean;   // (sonmg 2004/12/28)
    function GetItem(x, y: integer): PTMapItem;
    function GetItemEx(x, y: integer; var itemcount: integer): PTMapItem;
    function GetEvent(x, y: integer): TObject;
    function GetDupCount(x, y: integer): integer;
    procedure GetMarkMovement(x, y: integer; bocanmove: boolean);
    function CanWalk(x, y: integer; allowdup: boolean): boolean;
    function CanFireFly(x, y: integer): boolean;
    function CanFly(x, y, dx, dy: integer): boolean;
    function CanSafeWalk(x, y: integer): boolean;
    function MoveToMovingObject(x, y: integer; obj: TObject;
      nx, ny: integer; allowdup: boolean): integer;
    function AddToMap(x, y: integer; objtype: byte; obj: TObject): pointer;
    function AddToMapMineEvnet(x, y: integer; objtype: byte; obj: TObject): pointer;
    function AddToMapTreasure(x, y: integer; objtype: byte; obj: TObject): pointer;
    function DeleteFromMap(x, y: integer; objtype: byte; obj: TObject): integer;
    //Boolean;
    procedure VerifyMapTime(x, y: integer; obj: TObject);
    procedure ApplyDoors;
    function FindDoor(x, y: integer): PTDoorInfo;
    function AroundDoorOpened(x, y: integer): boolean;
    function AddMapQuest(set1, val1: integer; monname, itemname, qfile: string;
      enablegroup: boolean): boolean;
    function HasMapQuest: boolean;
    function GetMapQuest(who: TObject; monname, itemname: string;
      groupcall: boolean): TObject;
    function GetGuildAgitRealMapName: string;
  end;

  TEnvirList = class(TList)
  private
  public
    ServerIndex: integer;
    constructor Create;
    destructor Destroy; override;
    function AddEnvir(mapname, title: string; serverindex: integer;
      npc: TObject; PFlag: PTMapFlag): TEnvirnoment;
    function AddGate(map: string; x, y: integer; entermap: string;
      enterx, entery: integer): boolean;
    function GetEnvir(mapname: string): TEnvirnoment;
    function ServerGetEnvir(server: integer; mapname: string): TEnvirnoment;
    function GetServer(mapname: string): integer;
    procedure InitEnvirnoments;
  end;



implementation

uses
  svMain, ObjBase, Event, ObjNpc, LocalDB;

constructor TEnvirnoment.Create;
begin
  MapName   := '';
  Server    := 0;
  MMap      := nil;
  MiniMap   := 0;
  MapWidth  := 0;
  MapHeight := 0;
  Darkness  := False;
  Dawn      := False; //새벽추가
  DayLight  := False;
  DoorList  := TList.Create;
  MapQuestList := TList.Create;
  FillChar(MapQuestParams, sizeof(MapQuestParams), #0);
end;

destructor TEnvirnoment.Destroy;
var
  i, j, k: Integer;
  pm:      PTMapInfo;
  pat:     PTAThing;
  pd:      PTDoorInfo;
begin
  if MMap <> nil then begin
    for i := 0 to MapWidth - 1 do begin
      for j := 0 to MapHeight - 1 do begin
        pm := @MMap[i * MapHeight + j];
        if pm.ObjList <> nil then begin
          for k := 0 to pm.ObjList.Count - 1 do begin
            pat := PTAThing(pm.ObjList[k]);
            case pat.Shape of
              OS_ITEMOBJECT: Dispose(PTMapItem(pat.AObject));
              OS_GATEOBJECT: Dispose(PTGateInfo(pat.AObject));

              // Get freed by EventManager. Do not double free here.
              //OS_EVENTOBJECT: TEvent(pat.AObject).Free;
            end;
            Dispose(pat);
          end;
          pm.ObjList.Free;
        end;
      end;
    end;

    FreeMem(Pointer(MMap));
    Pointer(MMap) := nil;
  end;

  for i := 0 to DoorList.Count - 1 do begin
    pd := PTDoorInfo(DoorList[i]);
    Dec(pd.pCore.RefCount);
    if pd.pCore.RefCount <= 0 then Dispose(pd.pCore);
    Dispose(pd);
  end;
  DoorList.Free;

  for i := 0 to MapQuestList.Count - 1 do
    Dispose(PTMapQuestInfo(MapQuestList[i]));
  MapQuestList.Free;

  inherited Destroy;
end;

procedure TEnvirnoment.ResizeMap(xsize, ysize: longint);
var
  i, j: integer;
begin
  if (xsize > 1) and (ysize > 1) then begin
    if MMap <> nil then begin
      for i := 0 to MapWidth - 1 do
        for j := 0 to MapHeight - 1 do
          if MMap[i * MapHeight + j].ObjList <> nil then
            MMap[i * MapHeight + j].ObjList.Free;
      FreeMem(Pointer(MMap));
      Pointer(MMap) := nil;
    end;
    MapWidth      := xsize;
    MapHeight     := ysize;
    Pointer(MMap) := AllocMem(MapWidth * MapHeight * sizeof(TMapInfo));
  end;
end;

function TEnvirnoment.LoadMap(map: string): boolean;
var
  i, j, k, fhandle, t, h, door: integer;
  header:  TMapHeader;
  header2: TMapHeader_AntiHack;
  mbuf:    PTMapFileInfoArr;
  pm:      PTMapInfo;
  pd:      PTDoorInfo;
  pc:      PTDoorCore;
  TempStr: string;
  EncodeMap: boolean;
begin
  Result    := False;
  Tempstr   := UpperCase(MapName);
  EncodeMap := False;

  if (Tempstr = 'LABY01') or (Tempstr = 'LABY02') or (Tempstr = 'LABY03') or
    (Tempstr = 'LABY04') or (Tempstr = 'SNAKE') then
    EncodeMap := True;

  if FileExists(map) then begin
    fhandle := FileOpen(map, fmOpenRead or fmShareExclusive);
    if fhandle > 0 then begin
      if EncodeMap then begin
        FileRead(fhandle, header2, sizeof(TMapHeader_AntiHack));
        header2.Width := header2.Width xor header2.CheckKey;
        header2.Height := header2.Height xor header2.CheckKey;
        MapWidth  := header2.Width;
        MapHeight := header2.Height;
      end else begin
        FileRead(fhandle, header, sizeof(TMapHeader));
        MapWidth  := header.Width;
        MapHeight := header.Height;
      end;
      ResizeMap(MapWidth, MapHeight);

      t    := SizeOf(TMapFileInfo) * MapWidth * MapHeight;
      mbuf := AllocMem(t);
      FileRead(fhandle, mbuf^, t);

      for i := 0 to MapWidth - 1 do begin
        h := i * MapHeight;
        for j := 0 to MapHeight - 1 do begin
          if EncodeMap then begin
            mbuf[h + j].BkImg  := mbuf[h + j].BkImg xor header2.CheckKey;
            mbuf[h + j].MidImg := mbuf[h + j].MidImg xor header2.CheckKey;
            mbuf[h + j].FrImg  := mbuf[h + j].FrImg xor header2.CheckKey;
          end;

          if (mbuf[h + j].BkImg and $8000) <> 0 then begin
            pm := @MMap[h + j];
            pm.MoveAttr := 1;
          end;
          if (mbuf[h + j].FrImg and $8000) <> 0 then begin
            pm := @MMap[h + j];
            pm.MoveAttr := 2;
          end;
          if (mbuf[h + j].DoorIndex and $80) <> 0 then begin
            door := mbuf[h + j].DoorIndex and $7F;
            if door > 0 then begin
              new(pd);
              pd.DoorX      := i;
              pd.DoorY      := j;
              pd.DoorNumber := door;
              pd.PCore      := nil;
              for k := 0 to DoorList.Count - 1 do begin //같은 Door 처리
                if (Abs(pd.DoorX - PTDoorInfo(DoorList[k]).DoorX) <= 10) and
                  (Abs(pd.DoorY - PTDoorInfo(DoorList[k]).DoorY) <= 10) and
                  (door = PTDoorInfo(DoorList[k]).DoorNumber) then begin
                  pd.pCore := PTDoorInfo(DoorList[k]).pCore;
                  Inc(pd.pCore.RefCount);
                  break;
                end;
              end;
              if pd.PCore = nil then begin
                new(pd.PCore);
                pd.pCore.DoorOpenState := False;
                pd.pCore.Lock     := False;
                pd.pCore.LockKey  := 0; //비밀 번호가 없음..
                pd.pCore.OpenTime := 0; //열리면 시간 설정 됨.
                pd.pCore.RefCount := 1;
              end;
              DoorList.Add(pd);
            end;
          end;
        end;
      end;

      Dispose(mbuf);
      FileClose(fhandle);
      Result := True;
    end;
  end;
end;

function TEnvirnoment.GetMapXY(x, y: integer; var pm: PTMapInfo): boolean;
begin
  pm     := nil;
  Result := False;

  if (x >= 0) and (x < MapWidth) and (y >= 0) and (y < MapHeight) then begin
    pm := @MMap[x * MapHeight + y];
    if (pm <> nil) then begin
      Result := True;
    end;
  end;

end;

function TEnvirnoment.GetCreature(x, y: integer; aliveonly: boolean): TObject;
var
  pm:   PTMapInfo;
  i:    integer;
  inrange: boolean;
  cret: TCreature;
begin
  Result  := nil;
  inrange := GetMapXY(x, y, pm);
  if inrange then begin
    if pm.ObjList <> nil then
      for i := pm.ObjList.Count - 1 downto 0 do
        if (PTAThing(pm.ObjList[i]).Shape = OS_MOVINGOBJECT) then begin
          cret := TCreature(PTAThing(pm.ObjList[i]).AObject);
          if cret <> nil then begin
            if (not cret.BoGhost) and (cret.HoldPlace) and
              (not aliveonly or not cret.Death) then begin
              Result := cret;
              break;
            end;
          end;
        end;
  end;
end;

function TEnvirnoment.GetAllCreature(x, y: integer; aliveonly: boolean;
  list: TList): integer;
var
  pm:   PTMapInfo;
  i:    integer;
  inrange: boolean;
  cret: TCreature;
begin
  inrange := GetMapXY(x, y, pm);
  if inrange then begin
    if pm.ObjList <> nil then
      for i := pm.ObjList.Count - 1 downto 0 do
        if (PTAThing(pm.ObjList[i]).Shape = OS_MOVINGOBJECT) then begin
          cret := TCreature(PTAThing(pm.ObjList[i]).AObject);
          if cret <> nil then begin
            if (not cret.BoGhost) and (cret.HoldPlace) and
              (not aliveonly or not cret.Death) then begin
              list.Add(cret);
              //break;
            end;
          end;
        end;
  end;
  Result := list.Count;
end;

function TEnvirnoment.GetCreatureInRange(x, y, wide: integer;
  aliveonly: boolean; list: TList): integer;
var
  pm:      PTMapInfo;
  i, k:    integer;
  inrange: boolean;
  cret:    TCreature;
begin
  Result := 0;
  for i := x - wide to x + wide do begin
    for k := y - wide to y + wide do begin
      GetAllCreature(i, k, aliveonly, list);
    end;
  end;
  Result := list.Count;
end;

function TEnvirnoment.IsValidCreature(x, y, checkrange: integer;
  cret: TObject): boolean;
var
  pm:      PTMapInfo;
  k, m, i: integer;
  inrange: boolean;
begin
  Result := False;
  for k := x - checkrange to x + checkrange do begin
    for m := y - checkrange to y + checkrange do begin
      inrange := GetMapXY(k, m, pm);
      if inrange then begin
        if pm.ObjList <> nil then
          for i := pm.ObjList.Count - 1 downto 0 do
            if (PTAThing(pm.ObjList[i]).Shape = OS_MOVINGOBJECT) then begin
              if PTAThing(pm.ObjList[i]).AObject = cret then begin
                Result := True;
                exit;
              end;
            end;
      end;
    end;
  end;
end;

// (sonmg 2004/12/28 -> 2005/02/24 재수정)
function TEnvirnoment.IsValidFrontCreature(x, y, checkrange: integer;
  var cret: TObject): boolean;
var
  pm:      PTMapInfo;
  k, m, i: integer;
  inrange: boolean;
  cretobj: TCreature;
begin
  cretobj := nil;
  Result  := False;
  for k := x - checkrange to x + checkrange do begin
    for m := y - checkrange to y + checkrange do begin
      inrange := GetMapXY(k, m, pm);
      if inrange then begin
        if pm.ObjList <> nil then begin
          for i := pm.ObjList.Count - 1 downto 0 do begin
            if (PTAThing(pm.ObjList[i]).Shape = OS_MOVINGOBJECT) then begin
              cretobj := TCreature(PTAThing(pm.ObjList[i]).AObject);
              if (TCreature(cretobj).BoAnimal) and
                (TCreature(cretobj).Death) and (not TCreature(cretobj).BoSkeleton) then
              begin
                // 가방에 아이템이 있거나 마지막 시체이면 그 시체를 넘겨줌 아니면 다음 시체 검사.
                if (TCreature(cretobj).ItemList.Count > 0) then begin
                  cret   := TObject(cretobj);
                  Result := True;
                  exit;
                end else begin
                  // 이전 검색한 시체를 넣어줌
                  cret   := TObject(cretobj);
                  Result := True;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetItem(x, y: integer): PTMapItem;
var
  pm:  PTMapInfo;
  i:   integer;
  inrange: boolean;
  obj: TObject;
begin
  Result  := nil;
  BoCanGetItem := False;
  inrange := GetMapXY(x, y, pm);
  if inrange then begin
    if pm.MoveAttr = MP_CANMOVE then begin
      BoCanGetItem := True;
      if pm.ObjList <> nil then begin
        for i := pm.ObjList.Count - 1 downto 0 do begin
          if (PTAThing(pm.ObjList[i]).Shape = OS_ITEMOBJECT) then begin
            Result := PTMapItem(PTAThing(pm.ObjList[i]).AObject);
            break;
          end;
          if (PTAThing(pm.ObjList[i]).Shape = OS_GATEOBJECT) then begin
            BoCanGetItem := False;  //아이템이 문에 끼지 못하게...
          end;
          if (PTAThing(pm.ObjList[i]).Shape = OS_MOVINGOBJECT) then begin
            obj := PTAThing(pm.ObjList[i]).AObject;
            if not TCreature(obj).Death then begin
              BoCanGetItem := False;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetItemEx(x, y: integer; var itemcount: integer): PTMapItem;
var
  pm:  PTMapInfo;
  i:   integer;
  inrange: boolean;
  obj: TObject;
begin
  Result    := nil;
  itemcount := 0;
  BoCanGetItem := False;
  inrange   := GetMapXY(x, y, pm);
  if inrange then begin
    if pm.MoveAttr = MP_CANMOVE then begin
      BoCanGetItem := True;
      if pm.ObjList <> nil then begin
        for i := 0 to pm.ObjList.Count - 1 do begin
          if (PTAThing(pm.ObjList[i]).Shape = OS_ITEMOBJECT) then begin
            Result := PTMapItem(PTAThing(pm.ObjList[i]).AObject);
            Inc(itemcount);
            //break;
          end;
          if (PTAThing(pm.ObjList[i]).Shape = OS_GATEOBJECT) then begin
            BoCanGetItem := False;  //아이템이 문에 끼지 못하게...
          end;
          if (PTAThing(pm.ObjList[i]).Shape = OS_MOVINGOBJECT) then begin
            obj := PTAThing(pm.ObjList[i]).AObject;
            if not TCreature(obj).Death then begin
              BoCanGetItem := False;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.GetEvent(x, y: integer): TObject;
var
  pm:  PTMapInfo;
  i:   integer;
  inrange: boolean;
  obj: TObject;
begin
  Result  := nil;
  BoCanGetItem := False;
  inrange := GetMapXY(x, y, pm);
  if inrange and (pm.ObjList <> nil) then begin
    for i := pm.ObjList.Count - 1 downto 0 do begin
      if (PTAThing(pm.ObjList[i]).Shape = OS_EVENTOBJECT) then begin
        Result := PTAThing(pm.ObjList[i]).AObject;
        break;
      end;
    end;
  end;
end;

function TEnvirnoment.GetDupCount(x, y: integer): integer;
var
  pm:      PTMapInfo;
  i, arr:  integer;
  inrange: boolean;
  obj:     TObject;
begin
  Result  := 0;
  arr     := 0;
  inrange := GetMapXY(x, y, pm);
  if inrange then begin
    if pm.ObjList <> nil then
      for i := 0 to pm.ObjList.Count - 1 do
        if (PTAThing(pm.ObjList[i]).Shape = OS_MOVINGOBJECT) then begin
          obj := PTAThing(pm.ObjList[i]).AObject;
          if (not TCreature(obj).BoGhost) and (TCreature(obj).HoldPlace) and
            //자리 차지
            (not TCreature(obj).Death) and (not TCreature(obj).HideMode) and
            //안보이고 숨어 있는 모드
            (not TCreature(obj).BoSuperviserMode)  //감시자모드
          then begin
            Inc(arr);
          end;
        end;
  end;
  Result := arr;
end;

procedure TEnvirnoment.GetMarkMovement(x, y: integer; bocanmove: boolean);
var
  pm: PTMapInfo;
  i:  integer;
  inrange: boolean;
begin
  inrange := GetMapXY(x, y, pm);
  if inrange then begin
    if bocanmove then
      pm.MoveAttr := MP_CANMOVE  //움직일 수 있게
    else
      pm.MoveAttr := MP_HIGHWALL;  //못 움직이게
  end;
end;

function TEnvirnoment.CanWalk(x, y: integer; allowdup: boolean): boolean;
var
  pm:   PTMapInfo;
  i:    integer;
  cret: TCreature;
  inrange: boolean;
begin
  Result  := False; {out of range}
  inrange := GetMapXY(x, y, pm);
  if inrange then begin
    if (pm.MoveAttr = MP_CANMOVE) then begin
      Result := True;
      if not allowdup then begin
        if pm.ObjList <> nil then begin
          for i := 0 to pm.ObjList.Count - 1 do begin
            if (PTAThing(pm.ObjList[i]).Shape = OS_MOVINGOBJECT) then begin
              cret := TCreature(PTAThing(pm.ObjList[i]).AObject);
              if cret <> nil then
                if (not cret.BoGhost) and (cret.HoldPlace) and
                  //자리 차지
                  (not cret.Death) and (not cret.HideMode) and
                  //안보이고 숨어 있는 모드
                  (not cret.BoSuperviserMode)  //감시자모드
                then begin
                  Result := False;
                  break;
                end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TEnvirnoment.CanFireFly(x, y: integer): boolean;
var
  pm:   PTMapInfo;
  i:    integer;
  cret: TCreature;
  inrange: boolean;
begin
  Result  := True;
  inrange := GetMapXY(x, y, pm);
  if inrange then begin
    if (pm.MoveAttr = MP_HIGHWALL) then begin
      Result := False;
    end;
  end;
end;

function TEnvirnoment.CanFly(x, y, dx, dy: integer): boolean;
var
  i, j, rx, ry: integer;
  stepx, stepy: real;
begin
  Result := True;
  stepx  := (dx - x) / 10;
  stepy  := (dy - y) / 10;
  for i := 0 to 9 do begin
    rx := Round(x + stepx);
    ry := Round(y + stepy);
    if not CanWalk(rx, ry, True) then begin
      Result := False;
      break;
    end;
  end;
end;

function TEnvirnoment.CanSafeWalk(x, y: integer): boolean;
var
  pm:    PTMapInfo;
  i:     integer;
  inrange: boolean;
  obj:   TObject;
  event: TEvent;
begin
  Result  := True;
  inrange := GetMapXY(x, y, pm);
  if inrange and (pm.ObjList <> nil) then begin
    for i := pm.ObjList.Count - 1 downto 0 do begin
      if (PTAThing(pm.ObjList[i]).Shape = OS_EVENTOBJECT) then begin
        event := TEvent(PTAThing(pm.ObjList[i]).AObject);
        if event.Damage > 0 then
          Result := False;
      end;
    end;
  end;
end;

{ -1: can't move(map don't movable),  0: can't move,  1: can move}
function TEnvirnoment.MoveToMovingObject(x, y: integer; obj: TObject;
  nx, ny: integer; allowdup: boolean): integer;
var
  pm:     PTMapInfo;
  pthing: PTAThing;
  inrange, canmove: boolean;
  i:      integer;
  cret:   TCreature;
  Down:   integer;
begin
  Result := 0;
  Down   := 0;
  try
    canmove := True;
    if not allowdup then begin
      inrange := GetMapXY(nx, ny, pm);  //이동할 자리가 유효한지 검사
      if (inrange) and (pm <> nil) then begin
        Down := 1;
        if pm.MoveAttr = MP_CANMOVE then begin
          Down := 2;
          if pm.ObjList <> nil then begin
            Down := 3;
            for i := 0 to pm.ObjList.Count - 1 do begin
              Down := 4;
              if (PTAThing(pm.ObjList[i]).Shape = OS_MOVINGOBJECT) then begin
                Down := 5;
                cret := TCreature(PTAThing(pm.ObjList[i]).AObject);
                if cret <> nil then begin
                  Down := 6;
                  if (not cret.BoGhost) and (cret.HoldPlace) and
                    //자리를 차지하는 모드
                    (not cret.Death) and (not cret.HideMode) and
                    //땅속좀비등 (안보이는 모드)
                    (not cret.BoSuperviserMode)   //감시자 모드
                  then begin
                    canmove := False;
                    break;
                  end;
                end;
              end;
            end;
          end;
        end else begin
          Result  := -1;
          canmove := False;
        end;
      end;
    end;

    Down := 10;
    if canmove then begin
      inrange := GetMapXY(nx, ny, pm);
      if (not inrange) or (pm.MoveAttr <> MP_CANMOVE) then begin
        Result := -1;
      end else begin
        Down    := 11;
        inrange := GetMapXY(x, y, pm);
        if inrange then begin
          Down := 12;
          if pm.ObjList <> nil then begin
            i := 0;
            while True do begin
              Down := 13;
              if i >= pm.ObjList.Count then
                break;
              pthing := pm.ObjList[i];
              if (pthing.Shape = OS_MOVINGOBJECT) and (pthing.AObject = obj) then
              begin
                Down := 14;
                pm.ObjList.Delete(i);
                Down := 142;
                try
                  Dispose(PTAThing(pthing));
                except
                  MainOutMessage('DO NOT DISPOSE pthing');
                end;

                if pm.ObjList.Count <= 0 then begin
                  Down := 15;
                  try
                    pm.ObjList.Free;
                  finally
                    pm.ObjList := nil;
                  end;
                  break;
                end;
                continue;
              end;
              Inc(i);
            end;
          end;
        end;
        inrange := GetMapXY(nx, ny, pm);
        if inrange then begin
          Down := 16;
          if pm.ObjList = nil then
            pm.ObjList := TList.Create;
          Down := 17;

          try  // 여기서 에러가 나는 경우가 발생
            New(pthing);
          except
            MainOutMessage('DO NOT MEW PTHING');
            pthing := nil;
          end;

          if pthing <> nil then begin
            pthing.Shape := OS_MOVINGOBJECT;
            Down := 18;
            pthing.AObject := obj;
            pthing.ATime := GetTickCount; {맵에 추가된 시간}
            Down := 19;
            pm.ObjList.Add(pthing);
            Result := 1; {이동 가능}
          end;

        end;
      end;
    end;
  except
    MainOutMessage('[TEnvirnoment] MoveToMovingObject exception ' +
      MapName + '<' + IntToStr(nx) + ':' + IntToStr(ny) + '>' + IntToStr(down));
  end;
end;

function TEnvirnoment.AddToMap(x, y: integer; objtype: byte; obj: TObject): pointer;
var
  pm:     PTMapInfo;
  pthing, pthingtemp: PTAThing;
  pmitem: PTMapItem;
  inrange, flag: boolean;
  i, cnt: integer;
  ps:     PTStdItem;
  ItemObjCount: integer;
begin
  Result := nil; {out of range 이거나, 실패 했을 경우}
  ps     := nil;
  try
    inrange := GetMapXY(x, y, pm);
    flag    := False;

    if inrange then begin
      if pm.MoveAttr = MP_CANMOVE then begin
        if pm.ObjList = nil then
          pm.ObjList := TList.Create
        else begin
          if objtype = OS_ITEMOBJECT then begin
            if PTMapItem(obj).Name = NAME_OF_GOLD{'금전'} then begin
              for i := 0 to pm.ObjList.Count - 1 do begin
                pthing := pm.ObjList[i];
                if pthing.Shape = OS_ITEMOBJECT then begin
                  pmitem := PTMapItem(PTAThing(pm.ObjList[i]).AObject);
                  if pmitem.Name = NAME_OF_GOLD{'금전'} then begin
                    cnt := pmitem.Count + PTMapItem(obj).Count;
                    if cnt <= BAGGOLD then begin
                      pmitem.Count := cnt;
                      pmitem.Looks := GetGoldLooks(cnt);
                      pmitem.AniCount := 0;
                      pmitem.Reserved := 0;
                      pthing.ATime := GetTickCount; //시간 재설정
                      Result := pmitem;
                      //이미 있는 것이면 그 포인터를 결과값으로 보냄
                      flag   := True;
                    end;
                  end;
                end;
              end;
            end;
            if not flag then
              ps := UserEngine.GetStdItem(PTMapItem(obj).UserItem.Index);
            if (ps <> nil) and (ps.StdMode = STDMODE_OF_DECOITEM) and
              (ps.Shape = SHAPE_OF_DECOITEM) then begin
              ItemObjCount := 0;
              for i := 0 to pm.ObjList.Count - 1 do begin
                pthingtemp := pm.ObjList[i];
                if pthingtemp.Shape = OS_ITEMOBJECT then
                  Inc(ItemObjCount);
              end;
              //상현주머니는 1개 이상 못 쌓는다.
              if ItemObjCount >= 1 then begin //1개 이상 못 쌓는다.
                Result := nil;
                //PTMapItem(PTAThing(pm.ObjList[i]).AObject); //에러임..
                flag   := True;
              end;
            end else begin
              ItemObjCount := 0;
              for i := 0 to pm.ObjList.Count - 1 do begin
                pthingtemp := pm.ObjList[i];
                if pthingtemp.Shape = OS_ITEMOBJECT then
                  Inc(ItemObjCount);
              end;
              //일반 아이템은 5개 이상 못 쌓는다.
              if ItemObjCount >= 5 then begin //더 이상 못 쌓는다.(5개 제한)
                Result := nil;
                //PTMapItem(PTAThing(pm.ObjList[i]).AObject); //에러임..
                flag   := True;
              end;
            end;
          end;
          if objtype = OS_EVENTOBJECT then begin
          end;
        end;

        if not flag then begin
          New(pthing);
          pthing.Shape   := objtype;
          pthing.AObject := obj;          {TCreature(obj), PTUseItem(obj)}
          pthing.ATime   := GetTickCount; {맵에 추가된 시간}
          pm.ObjList.Add(pthing);
          Result := obj;
        end;
      end;
    end;
  except
    MainOutMessage('[TEnvirnoment] AddToMap exception');
  end;
end;

function TEnvirnoment.AddToMapMineEvnet(x, y: integer; objtype: byte;
  obj: TObject): pointer;
var
  pm:     PTMapInfo;
  pthing: PTAThing;
  pmitem: PTMapItem;
  inrange, flag: boolean;
  i, cnt: integer;
begin
  Result := nil; {out of range 이거나, 실패 했을 경우}
  try
    inrange := GetMapXY(x, y, pm);
    flag    := False;

    if inrange then begin //이동 못하는 곳에도 심는다.
      if pm.MoveAttr <> MP_CANMOVE then begin
        if pm.ObjList = nil then
          pm.ObjList := TList.Create
        else begin
          if objtype = OS_EVENTOBJECT then begin
          end;
        end;

        if not flag then begin
          New(pthing);
          pthing.Shape   := objtype;
          pthing.AObject := obj;          {TCreature(obj), PTUseItem(obj)}
          pthing.ATime   := GetTickCount; {맵에 추가된 시간}
          pm.ObjList.Add(pthing);
          Result := obj;
        end;
      end;
    end;
  except
    MainOutMessage('[TEnvirnoment] AddToMapMineEvent exception');
  end;
end;

function TEnvirnoment.AddToMapTreasure(x, y: integer; objtype: byte;
  obj: TObject): pointer;
var
  pm:     PTMapInfo;
  pthing: PTAThing;
  pmitem: PTMapItem;
  inrange, flag: boolean;
  i, cnt: integer;
begin
  Result := nil; {out of range 이거나, 실패 했을 경우}
  try
    inrange := GetMapXY(x, y, pm);
    flag    := False;

    if inrange then begin //이동 못하는 곳에도 심는다.
      if pm.ObjList = nil then
        pm.ObjList := TList.Create
      else begin
        if objtype = OS_EVENTOBJECT then begin
        end;
      end;

      if not flag then begin
        New(pthing);
        pthing.Shape   := objtype;
        pthing.AObject := obj;          {TCreature(obj), PTUseItem(obj)}
        pthing.ATime   := GetTickCount; {맵에 추가된 시간}
        pm.ObjList.Add(pthing);
        Result := obj;
      end;
    end;
  except
    MainOutMessage('[TEnvirnoment] AddToMapMineEvent exception');
  end;
end;


function TEnvirnoment.DeleteFromMap(x, y: integer; objtype: byte;
  obj: TObject): integer;
var
  pm:     PTMapInfo;
  i:      integer;
  pthing: PTAThing;
  inrange: boolean;
begin
  Result := -1; //FALSE;
  try
    inrange := GetMapXY(x, y, pm);

    if inrange then begin
      if pm <> nil then begin
        try
          if pm.ObjList <> nil then begin
            i := 0;
            while True do begin
              if i >= pm.ObjList.Count then
                break;
              pthing := pm.ObjList[i];
              if pthing <> nil then begin
                if (objtype = pthing.Shape) and (obj = pthing.AObject) then begin
                  pm.ObjList.Delete(i);
                  Dispose(PTAThing(pthing));
                  Result := 1; //TRUE;
                  if pm.ObjList.Count <= 0 then begin
                    pm.ObjList.Free;
                    pm.ObjList := nil;
                    break;
                  end;
                  Continue;
                end;
              end else begin
                pm.ObjList.Delete(i);
                if pm.ObjList.Count <= 0 then begin
                  pm.ObjList.Free;
                  pm.ObjList := nil;
                  break;
                end;
                continue;
              end;
              Inc(i);
            end;
          end else
            Result := -2;
        except
          pm := nil;
          MainOutMessage('[TEnvirnoment] DeleteFromMap -> Except 1 **' +
            IntToStr(objtype));
        end;
      end else
        Result := -3;
    end else
      Result := 0;
  except
    MainOutMessage('[TEnvirnoment] DeleteFromMap -> Except 2 **' + IntToStr(objtype));
  end;
end;

procedure TEnvirnoment.VerifyMapTime(x, y: integer; obj: TObject);
var
  pm:     PTMapInfo;
  i:      integer;
  pthing: PTAThing;
  inrange: boolean;
begin
  try
    inrange := GetMapXY(x, y, pm);
    if inrange then begin
      if pm <> nil then begin
        if pm.ObjList <> nil then begin
          for i := 0 to pm.ObjList.Count - 1 do begin
            pthing := pm.ObjList[i];
            if (pthing.Shape = OS_MOVINGOBJECT) and (pthing.AObject = obj) then
            begin
              PTAThing(pthing).ATime := GetTickCount;
              //맵에 추가된 시간을 재설정함
              break;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage('[TEnvirnoment] VerifyMapTime exception');
  end;
end;


procedure TEnvirnoment.ApplyDoors;
var
  i:  integer;
  pd: PTDoorInfo;
begin
  for i := 0 to DoorList.Count - 1 do begin
    pd := PTDoorInfo(DoorList[i]);
    if (nil = AddToMap(pd.DoorX, pd.DoorY, OS_DOOR, TObject(pd))) then begin
      // MainOutMessage('NOT ApplyDoors'+MapName+','+IntTostr(pd.DoorX)+','+IntTostr( pd.DoorY ));
    end;
  end;
end;

function TEnvirnoment.FindDoor(x, y: integer): PTDoorInfo;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to DoorList.Count - 1 do begin
    if (PTDoorInfo(DoorList[i]).DoorX = x) and (PTDoorInfo(DoorList[i]).DoorY = y) then
    begin
      Result := PTDoorInfo(DoorList[i]);
      break;
    end;
  end;
end;

function TEnvirnoment.AroundDoorOpened(x, y: integer): boolean;
var
  i, j: integer;
begin
  Result := True;
  try
    for i := 0 to DoorList.Count - 1 do begin
      if (Abs(PTDoorInfo(DoorList[i]).DoorX - x) <= 1) and
        (Abs(PTDoorInfo(DoorList[i]).DoorY - y) <= 1) then begin
        if not PTDoorInfo(DoorList[i]).pCore.DoorOpenState then begin
          Result := False;
          break;
        end;
      end;
    end;
  except
    MainOutMessage('[TEnvirnoment] AroundDoorOpened exception');
  end;
end;

function TEnvirnoment.AddMapQuest(set1, val1: integer;
  monname, itemname, qfile: string; enablegroup: boolean): boolean;
var
  mqi: PTMapQuestInfo;
  npc: TMerchant;
begin
  Result := False;
  if set1 >= 0 then begin
    new(mqi);
    mqi.SetNumber := set1;
    if val1 > 1 then
      val1 := 1;
    mqi.Value := val1;
    if monname = '*' then
      monname := '';
    mqi.MonName := monname;
    if itemname = '*' then
      itemname := '';
    mqi.ItemName := itemname;
    if qfile = '*' then
      qfile := '';
    mqi.EnableGroup := enablegroup;

    npc    := TMerchant.Create;
    npc.MapName := '0';
    npc.CX := 0;
    npc.CY := 0;
    npc.UserName := qfile;
    npc.NpcFace := 0;
    npc.Appearance := 0;
    npc.DefineDirectory := MAPQUESTDIR;
    npc.BoInvisible := True;
    npc.BoUseMapFileName := False;

    UserEngine.NpcList.Add(npc);

    mqi.QuestNpc := npc;
    MapQuestList.Add(mqi);

    Result := True;
  end;
end;

function TEnvirnoment.HasMapQuest: boolean;
begin
  if MapQuestList.Count > 0 then
    Result := True
  else
    Result := False;
end;

function TEnvirnoment.GetMapQuest(who: TObject; monname, itemname: string;
  groupcall: boolean): TObject;
var
  i, qval: integer;
  mqi:     PTMapQuestInfo;
  flag:    boolean;
begin
  Result := nil;
  for i := 0 to MapQuestList.Count - 1 do begin
    mqi := PTMapQuestInfo(MapQuestList[i]);

    qval := TCreature(who).GetQuestMark(mqi.SetNumber);
    if (qval = mqi.Value) and ((groupcall = mqi.EnableGroup) or (not groupcall)) then
    begin
      flag := False;
      if (mqi.MonName <> '') and (mqi.ItemName <> '') then begin  //die or pickup
        if (mqi.MonName = monname) and (mqi.ItemName = itemname) then
          flag := True;
      end;
      if (mqi.MonName <> '') and (mqi.ItemName = '') then begin  //die
        if (mqi.MonName = monname) and (itemname = '') then
          flag := True;
        // (sonmg 2005/06/29)
        if (mqi.MonName = '~') and (monname = '') then
          flag := True;
      end;
      if (mqi.MonName = '') and (mqi.ItemName <> '') then begin  //pickup
        if (mqi.ItemName = itemname) then
          flag := True;
        // (sonmg 2005/06/29)
        if (mqi.ItemName = '~') and (itemname = '') then
          flag := True;
      end;

      if flag then begin
        Result := mqi.QuestNpc;
        break;
      end;
    end;

  end;
end;


function TEnvirnoment.GetGuildAgitRealMapName: string;
begin
  Result := MapName;

  if GuildAgit > -1 then begin
    Result := MapName[1] + MapName[2] + MapName[3];
  end;
end;



{%%%%%%%%%%%%%%%%%%%% *TEnvirList* %%%%%%%%%%%%%%%%%%}



constructor TEnvirList.Create;
begin
  inherited Create;
end;

destructor TEnvirList.Destroy;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    TEnvirnoment(Items[i]).Free;

  inherited Destroy;
end;

procedure TEnvirList.InitEnvirnoments;
var
  i: integer;
begin
  //모든 맵을 다 읽은 후..
  for i := 0 to Count - 1 do
    TEnvirnoment(Items[i]).ApplyDoors;
end;

 //canattack : FALSE (공격을 못함, 상점등)
 //gameroom  : TRUE (대련장, 죽어도 무해함)
 //ghost : TRUE (유령의집, 사람이 투명임)
 //norecon : 재접 가능 여부
function TEnvirList.AddEnvir(mapname, title: string; serverindex: integer;
  npc: TObject; PFlag: PTMapFlag): TEnvirnoment;
var
  envir: TEnvirnoment;
  i:     integer;
begin
  Result     := nil;
  envir      := TEnvirnoment.Create;
  envir.MapName := mapname;
  envir.MapTitle := title;
  envir.Server := serverindex;
  envir.LawFull := PFlag.LawFull;
  envir.FightZone := PFlag.FightZone;
  envir.Fight2Zone := PFlag.Fight2Zone;
  envir.Fight3Zone := PFlag.Fight3Zone;
  envir.Fight4Zone := PFlag.Fight4Zone;
  envir.Darkness := PFlag.Darkness;
  envir.Dawn := PFlag.Dawn;  //새벽추가
  envir.DayLight := PFlag.DayLight;
  envir.QuizZone := PFlag.QuizZone;
  envir.NoReconnect := PFlag.NoReconnect;
  envir.NeedHole := PFlag.NeedHole;
  envir.NoRecall := PFlag.NoRecall;
  envir.NoRandomMove := PFlag.NoRandomMove;
  envir.NoEscapeMove := PFlag.NoEscapeMove; // sonmg
  envir.NoTeleportMove := PFlag.NoTeleportMove;   // sonmg
  envir.NoDrug := PFlag.NoDrug;
  envir.MineMap := PFlag.MineMap;
  envir.NoPositionMove := PFlag.NoPositionMove;
  envir.BackMap := PFlag.BackMap;
  envir.MapQuest := npc;
  envir.NeedSetNumber := PFlag.NeedSetNumber;
  envir.NeedSetValue := PFlag.NeedSetValue;
  envir.AutoAttack := PFlag.AutoAttack;
  envir.GuildAgit := PFlag.GuildAgit;
  envir.NoChat := PFlag.NoChat;
  envir.NoGroup := PFlag.NoGroup;
  envir.NoThrowItem := PFlag.NoThrowItem;
  envir.NoDropItem := PFlag.NoDropItem;


  for i := 0 to MiniMapList.Count - 1 do
    if CompareText(MiniMapList[i], MapName) = 0 then begin
      envir.MiniMap := integer(MiniMapList.Objects[i]);
      break;
    end;

  if PFlag.GuildAgit > -1 then begin
    if envir.LoadMap(MAPDIR + envir.GetGuildAgitRealMapName + '.map') then begin
      Result := envir;
      Add(envir);
    end else begin
      envir.Free;
      //envir.ResizeMap (1, 1);
      ShowMessage('file not found..  ' + MAPDIR + mapname + '.map');
    end;
  end else begin
    if envir.LoadMap(MAPDIR + mapname + '.map') then begin
      Result := envir;
      Add(envir);
    end else begin
      envir.Free;
      //envir.ResizeMap (1, 1);
      ShowMessage('file not found..  ' + MAPDIR + mapname + '.map');
    end;
  end;

end;

function TEnvirList.AddGate(map: string; x, y: integer; entermap: string;
  enterx, entery: integer): boolean;
var
  envir, enter: TEnvirnoment;
  pg: PTGateInfo;
begin
  Result := False;
  envir  := GetEnvir(map);
  enter  := GetEnvir(entermap);
  if (envir <> nil) and (enter <> nil) then begin
    new(pg);
    pg.GateType   := 0;
    pg.EnterEnvir := enter;
    pg.EnterX     := enterx;
    pg.EnterY     := entery;
    if (nil <> envir.AddToMap(x, y, OS_GATEOBJECT, TObject(pg))) then begin
      Result := True;
    end else begin
      if pg <> nil then
        dispose(pg);
      Result := False;
    end;
  end;
end;

// map 이름의 Envirnoment를 얻어옴   (one Map, one Envirnoment)
function TEnvirList.GetEnvir(mapname: string): TEnvirnoment;
var
  i: integer;
begin
  Result := nil;
  try
    csShare.Enter;
    for i := 0 to Count - 1 do begin
      if CompareText(TEnvirnoment(Items[i]).MapName, mapname) = 0 then begin
        Result := TEnvirnoment(Items[i]);
        exit;
      end;
    end;
  finally
    csShare.Leave;
  end;
end;

function TEnvirList.ServerGetEnvir(server: integer; mapname: string): TEnvirnoment;
var
  i: integer;
begin
  Result := nil;
  try
    csShare.Enter;
    for i := 0 to Count - 1 do begin
      if (TEnvirnoment(Items[i]).Server = server) and
        (CompareText(TEnvirnoment(Items[i]).MapName, mapname) = 0) then begin
        Result := TEnvirnoment(Items[i]);
        exit;
      end;
    end;
  finally
    csShare.Leave;
  end;
end;

function TEnvirList.GetServer(mapname: string): integer;
var
  i: integer;
begin
  Result := 0;
  try
    csShare.Enter;
    for i := 0 to Count - 1 do begin
      if (CompareText(TEnvirnoment(Items[i]).MapName, mapname) = 0) then begin
        Result := TEnvirnoment(Items[i]).Server;
        exit;
      end;
    end;
  finally
    csShare.Leave;
  end;
end;


end.
