unit PlayScn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, DirectX, IntroScn, Grobal2, CliUtil, HUtil32,
  Actor, HerbActor, AxeMon, SoundUtil, ClEvent, Wil,
  StdCtrls, clFunc, magiceff, ExtCtrls;

const
  MAPSURFACEWIDTH = 800;
  MAPSURFACEHEIGHT = 550;
  LONGHEIGHT_IMAGE = 35;
  FLASHBASE = 410;
  AAX   = 16;
  SOFFX = 0;
  SOFFY = 0;
  LMX   = 30;
  LMY   = 26;

  SCREENWIDTH  = 800;
  SCREENHEIGHT = 600;

  MAXLIGHT = 5;
  LightFiles: array[0..MAXLIGHT] of string = (
    'Data\lig0a.dat',
    'Data\lig0b.dat',
    'Data\lig0c.dat',
    'Data\lig0d.dat',
    'Data\lig0e.dat',
    'Data\lig0f.dat'
    );
  LightSizes: array[0..MAXLIGHT] of integer = (
    34496,
    161280,
    327360,
    405920,
    542976,
    713632
    );

  LightMask0: array[0..2, 0..2] of shortint = (
    (0, 1, 0),
    (1, 3, 1),
    (0, 1, 0)
    );
  LightMask1: array[0..4, 0..4] of shortint = (
    (0, 1, 1, 1, 0),
    (1, 1, 3, 1, 1),
    (1, 3, 4, 3, 1),
    (1, 1, 3, 1, 1),
    (0, 1, 2, 1, 0)
    );
  LightMask2: array[0..8, 0..8] of shortint = (
    (0, 0, 0, 1, 1, 1, 0, 0, 0),
    (0, 0, 1, 2, 3, 2, 1, 0, 0),
    (0, 1, 2, 3, 4, 3, 2, 1, 0),
    (1, 2, 3, 4, 4, 4, 3, 2, 1),
    (1, 3, 4, 4, 4, 4, 4, 3, 1),
    (1, 2, 3, 4, 4, 4, 3, 2, 1),
    (0, 1, 2, 3, 4, 3, 2, 1, 0),
    (0, 0, 1, 2, 3, 2, 1, 0, 0),
    (0, 0, 0, 1, 1, 1, 0, 0, 0)
    );
  LightMask3: array[0..10, 0..10] of shortint = (
    (0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0),
    (0, 0, 0, 1, 2, 2, 2, 1, 0, 0, 0),
    (0, 0, 1, 2, 3, 3, 3, 2, 1, 0, 0),
    (0, 1, 2, 3, 4, 4, 4, 3, 2, 1, 0),
    (1, 2, 3, 4, 4, 4, 4, 4, 3, 2, 1),
    (2, 3, 4, 4, 4, 4, 4, 4, 4, 3, 2),
    (1, 2, 3, 4, 4, 4, 4, 4, 3, 2, 1),
    (0, 1, 2, 3, 4, 4, 4, 3, 2, 1, 0),
    (0, 0, 1, 2, 3, 3, 3, 2, 1, 0, 0),
    (0, 0, 0, 1, 2, 2, 2, 1, 0, 0, 0),
    (0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0)
    );

  LightMask4: array[0..14, 0..14] of shortint = (
    (0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 1, 1, 2, 2, 2, 1, 1, 0, 0, 0, 0),
    (0, 0, 0, 1, 1, 2, 3, 3, 3, 2, 1, 1, 0, 0, 0),
    (0, 0, 1, 1, 2, 3, 4, 4, 4, 3, 2, 1, 1, 0, 0),
    (0, 1, 1, 2, 3, 4, 4, 4, 4, 4, 3, 2, 1, 1, 0),
    (1, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1, 1),
    (1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1),
    (1, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1, 1),
    (0, 1, 1, 2, 3, 4, 4, 4, 4, 4, 3, 2, 1, 1, 0),
    (0, 0, 1, 1, 2, 3, 4, 4, 4, 3, 2, 1, 1, 0, 0),
    (0, 0, 0, 1, 1, 2, 3, 3, 3, 2, 1, 1, 0, 0, 0),
    (0, 0, 0, 0, 1, 1, 2, 2, 2, 1, 1, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0)
    );

  LightMask5: array[0..16, 0..16] of shortint = (
    (0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 1, 2, 4, 4, 4, 2, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 1, 2, 4, 4, 4, 4, 4, 2, 1, 0, 0, 0, 0),
    (0, 0, 0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0, 0, 0),
    (0, 0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0, 0),
    (0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0),
    (1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1),
    (1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1),
    (1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1),
    (0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0),
    (0, 0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0, 0),
    (0, 0, 0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0, 0, 0),
    (0, 0, 0, 0, 1, 2, 4, 4, 4, 4, 4, 2, 1, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 1, 2, 4, 4, 4, 2, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0)
     { (0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0),
      (0,0,0,0,0,0,0,1,2,2,2,1,0,0,0,0,0,0,0),
      (0,0,0,0,0,0,1,2,4,4,4,2,1,0,0,0,0,0,0),
      (0,0,0,0,0,1,2,4,4,4,4,4,2,1,0,0,0,0,0),
      (0,0,0,0,1,2,4,4,4,4,4,4,4,2,1,0,0,0,0),
      (0,0,0,1,2,4,4,4,4,4,4,4,4,4,2,1,0,0,0),
      (0,0,1,2,4,4,4,4,4,4,4,4,4,4,4,2,1,0,0),
      (0,1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1,0),
      (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
      (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
      (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
      (0,1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1,0),
      (0,0,1,2,4,4,4,4,4,4,4,4,4,4,4,2,1,0,0),
      (0,0,0,1,2,4,4,4,4,4,4,4,4,4,2,1,0,0,0),
      (0,0,0,0,1,2,4,4,4,4,4,4,4,2,1,0,0,0,0),
      (0,0,0,0,0,1,2,4,4,4,4,4,2,1,0,0,0,0,0),
      (0,0,0,0,0,0,1,2,4,4,4,2,1,0,0,0,0,0,0),
      (0,0,0,0,0,0,0,1,2,2,2,1,0,0,0,0,0,0,0),
      (0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0) }
    );

type
  PShoftInt = ^shortint;

  TLightEffect = record
    Width:  integer;
    Height: integer;
    PFog:   Pbyte;
  end;

  TLightMapInfo = record
    ShiftX: integer;
    ShiftY: integer;
    light:  integer;
    bright: integer;
  end;

  TPlayScene = class(TScene)
  private
    MapSurface: TDirectDrawSurface;
    ObjSurface: TDirectDrawSurface;

    FogScreen:  array[0..MAPSURFACEHEIGHT, 0..MAPSURFACEWIDTH] of byte;
    PFogScreen: PByte;
    FogWidth, FogHeight: integer;
    Lights:     array[0..MAXLIGHT] of TLightEffect;
    MoveTime:   longword;
    MoveStepCount: integer;
    AniTime:    longword;
    DefXX, DefYY: integer;
    MainSoundTimer: TTimer;

    MsgList:  TList;
    LightMap: array[0..LMX, 0..LMY] of TLightMapInfo;
    procedure DrawTileMap;
    procedure LoadFog;
    procedure ClearLightMap;
    procedure AddLight(x, y, shiftx, shifty, light: integer; nocheck: boolean);
    procedure UpdateBright(x, y, light: integer);
    function CheckOverLight(x, y, light: integer): boolean;
    procedure ApplyLightMap;
    procedure DrawLightEffect(lx, ly, bright: integer);
    procedure EdChatKeyPress(Sender: TObject; var Key: char);
    procedure SoundOnTimer(Sender: TObject);
  public
    EdChat:     TEdit;
    ActorList, TempList: TList;
    GroundEffectList: TList;  //바닥에 깔리는 마법 리스트
    EffectList: TList;  //마법효과 리스트
    FlyList:    TList;  //날아다니는 것 (던진도끼, 창, 화살)
    BlinkTime:  longword;
    ViewBlink:  boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Finalize; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure OpeningScene; override;
    procedure DrawMiniMap(surface: TDirectDrawSurface; transparent: boolean);
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
    function ButchAnimal(x, y: integer): TActor;

    function FindActor(id: integer): TActor;
    function FindActorXY(x, y: integer): TActor;
    function IsValidActor(actor: TActor): boolean;
    function NewActor(chrid: integer; cx, cy, cdir: word;
      cfeature, cstate: integer): TActor;
    procedure ActorDied(actor: TObject); //죽은 actor는 맨 위로
    procedure SetActorDrawLevel(actor: TObject; level: integer);
    procedure ClearActors;
    function DeleteActor(id: integer): TActor;
    procedure DelActor(actor: TObject);
    procedure SendMsg(ident, chrid, x, y, cdir, feature, state, param: integer;
      str: string);

    procedure NewMagic(aowner: TActor;
      magid, magnumb, cx, cy, tx, ty, targetcode: integer; mtype: TMagicType;
      Recusion: boolean; anitime: integer; var bofly: boolean);
    procedure DelMagic(magid: integer);
    function NewFlyObject(aowner: TActor; cx, cy, tx, ty, targetcode: integer;
      mtype: TMagicType): TMagicEff;
    //function  NewStaticMagic (aowner: TActor; tx, ty, targetcode, effnum: integer);

    procedure ScreenXYfromMCXY(cx, cy: integer; var sx, sy: integer);
    procedure CXYfromMouseXY(mx, my: integer; var ccx, ccy: integer);
    procedure CXYfromMouseXYMid(mx, my: integer; var ccx, ccy: integer);
    function GetCharacter(x, y, wantsel: integer; var nowsel: integer;
      liveonly: boolean): TActor;
    function GetAttackFocusCharacter(x, y, wantsel: integer;
      var nowsel: integer; liveonly: boolean): TActor;
    function IsSelectMyself(x, y: integer): boolean;
    function GetDropItems(x, y: integer; var inames: string): PTDropItem;
    procedure DropItemsShow;
    function CanRun(sx, sy, ex, ey: integer): boolean;
    function CanWalk(mx, my: integer): boolean;
    function CrashMan(mx, my: integer): boolean; //사람끼리 겹치는가?
    function CanFly(mx, my: integer): boolean;
    procedure RefreshScene;
    procedure CleanObjects;
  end;


implementation

uses
  ClMain, FState, Relationship;

constructor TPlayScene.Create;
begin
  MapSurface := nil;
  ObjSurface := nil;
  MsgList    := TList.Create;
  ActorList  := TList.Create;
  TempList   := TList.Create;
  GroundEffectList := TList.Create;
  EffectList := TList.Create;
  FlyList    := TList.Create;
  BlinkTime  := GetTickCount;
  ViewBlink  := False;

  EdChat := TEdit.Create(FrmMain.Owner);
  with EdChat do begin
    Parent := FrmMain;
    BorderStyle := bsNone;
    OnKeyPress := EdChatKeyPress;
    Visible := False;
    MaxLength := 70;
    Ctl3D  := False;
    Left   := 208;
    Top    := SCREENHEIGHT - 19;
    Height := 12;
    Width  := 387;
    Color  := clSilver;
  end;
  MoveTime     := GetTickCount;
  AniTime      := GetTickCount;
  MainAniCount := 0;
  MoveStepCount := 0;
  MainSoundTimer := TTimer.Create(FrmMain.Owner);
  with MainSoundTimer do begin
    OnTimer  := SoundOnTimer;
    Interval := 1;
    Enabled  := False;
  end;
end;

destructor TPlayScene.Destroy;
var
  i: Integer;
begin
  MsgList.Free;

  for i:=0 to ActorList.Count - 1 do
    TActor(ActorList[i]).Free;
  ActorList.Free;
  
  TempList.Free;
  GroundEffectList.Free;
  EffectList.Free;
  FlyList.Free;
  inherited Destroy;
end;

procedure TPlayScene.SoundOnTimer(Sender: TObject);
begin
  PlaySound(s_main_theme);
  MainSoundTimer.Interval := 46 * 1000;
end;

procedure TPlayScene.EdChatKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then begin
    FrmMain.SendSay(EdChat.Text);
    EdChat.Text := '';
    EdChat.Visible := False;
    Key := #0;
    SetImeMode(EdChat.Handle, imSAlpha);
  end;
  if Key = #27 then begin
    EdChat.Text := '';
    EdChat.Visible := False;
    Key := #0;
    SetImeMode(EdChat.Handle, imSAlpha);
  end;
end;

procedure TPlayScene.Initialize;
var
  i: integer;
begin
  MapSurface := TDirectDrawSurface.Create(FrmMain.DXDraw1.DDraw);
  MapSurface.SystemMemory := True;
  MapSurface.SetSize(MAPSURFACEWIDTH + UNITX * 4 + 30, MAPSURFACEHEIGHT + UNITY * 4);
  ObjSurface := TDirectDrawSurface.Create(FrmMain.DXDraw1.DDraw);
  ObjSurface.SystemMemory := True;
  ObjSurface.SetSize(MAPSURFACEWIDTH - SOFFX * 2, MAPSURFACEHEIGHT);

  FogWidth   := MAPSURFACEWIDTH - SOFFX * 2;
  FogHeight  := MAPSURFACEHEIGHT;
  PFogScreen := @FogScreen;
  //PFogScreen := AllocMem (FogWidth * FogHeight);
  ZeroMemory(PFogScreen, MAPSURFACEHEIGHT * MAPSURFACEWIDTH);

  ViewFog := False;
  for i := 0 to MAXLIGHT do
    Lights[i].PFog := nil;
  LoadFog;
end;

procedure TPlayScene.Finalize;
var
  i: integer;
begin
  if MapSurface <> nil then begin
    MapSurface.Free;
    MapSurface := nil;
  end;

  if ObjSurface <> nil then begin
    ObjSurface.Free;
    ObjSurface := nil;
  end;

  for i := 0 to MAXLIGHT do begin
    if Lights[i].PFog <> nil then
      FreeMem(Lights[i].PFog);
  end;
end;

procedure TPlayScene.OpenScene;
begin
  FrmMain.WProgUse.ClearCache;  //로그인 이미지 캐시를 지운다.
  FrmDlg.ViewBottomBox(True);
  //EdChat.Visible := TRUE;
  //EdChat.SetFocus;
  SetImeMode(FrmMain.Handle, LocalLanguage);
  //MainSoundTimer.Interval := 1000;
  //MainSoundTimer.Enabled := TRUE;
end;

procedure TPlayScene.CloseScene;
begin
  //MainSoundTimer.Enabled := FALSE;
  SilenceSound;

  EdChat.Visible := False;
  FrmDlg.ViewBottomBox(False);
end;

procedure TPlayScene.OpeningScene;
begin
end;

procedure TPlayScene.RefreshScene;
var
  i: integer;
begin
  Map.OldClientRect.Left := -1;
  for i := 0 to ActorList.Count - 1 do
    TActor(ActorList[i]).LoadSurface;
end;

procedure TPlayScene.CleanObjects; //맵을 옮김, 자신 빼고 초기화
var
  i: integer;
begin
  for i := ActorList.Count - 1 downto 0 do begin
    if TActor(ActorList[i]) <> Myself then begin
      TActor(ActorList[i]).Free;
      ActorList.Delete(i);
    end;
  end;
  MsgList.Clear;
  TargetCret  := nil;
  FocusCret   := nil;
  MagicTarget := nil;
  //마법도 초기화 해야함.
  for i := 0 to GroundEffectList.Count - 1 do
    TMagicEff(GroundEffectList[i]).Free;
  GroundEffectList.Clear;
  for i := 0 to EffectList.Count - 1 do
    TMagicEff(EffectList[i]).Free;
  EffectList.Clear;
end;

{---------------------- Draw Map -----------------------}

procedure TPlayScene.DrawTileMap;
var
  i, j, m, n, imgnum: integer;
  DSurface: TDirectDrawSurface;
begin
  with Map do
    if (ClientRect.Left = OldClientRect.Left) and
      (ClientRect.Top = OldClientRect.Top) then
      exit;
  Map.OldClientRect := Map.ClientRect;
  MapSurface.Fill(0);

  with Map.ClientRect do begin
    m := -UNITY * 2;
    for j := (Top - Map.BlockTop - 1) to (Bottom - Map.BlockTop + 1) do begin
      n := AAX + 14 - UNITX;
      for i := (Left - Map.BlockLeft - 2) to (Right - Map.BlockLeft + 1) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and
          (j < LOGICALMAPUNIT * 3) then begin
          imgnum := (Map.MArr[i, j].BkImg and $7FFF);
          if imgnum > 0 then begin
            if (i mod 2 = 0) and (j mod 2 = 0) then begin
              imgnum   := imgnum - 1;
              DSurface := FrmMain.WTiles.Images[imgnum];
              if Dsurface <> nil then
                MapSurface.Draw(n, m, DSurface.ClientRect, DSurface, False);
            end;
          end;
        end;
        Inc(n, UNITX);
      end;
      Inc(m, UNITY);
    end;
  end;

  with Map.ClientRect do begin
    m := -UNITY;
    for j := (Top - Map.BlockTop - 1) to (Bottom - Map.BlockTop + 1) do begin
      n := AAX + 14 - UNITX;
      for i := (Left - Map.BlockLeft - 2) to (Right - Map.BlockLeft + 1) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and
          (j < LOGICALMAPUNIT * 3) then begin
          imgnum := Map.MArr[i, j].MidImg;
          if imgnum > 0 then begin
            imgnum   := imgnum - 1;
            DSurface := FrmMain.WSmTiles.Images[imgnum];
            if Dsurface <> nil then
              MapSurface.Draw(n, m, DSurface.ClientRect, DSurface, True);
          end;
        end;
        Inc(n, UNITX);
      end;
      Inc(m, UNITY);
    end;
  end;

end;

{----------------------- 포그, 라이트 처리 -----------------------}


procedure TPlayScene.LoadFog;  //라이트 데이타 읽기
var
  i, fhandle, w, h, prevsize: integer;
  cheat: boolean;
begin
  prevsize := 0; //조작 체크
  cheat    := False;
  for i := 0 to MAXLIGHT do begin
    if FileExists(LightFiles[i]) then begin
      fhandle := FileOpen(LightFiles[i], fmOpenRead or fmShareDenyNone);
      FileRead(fhandle, w, sizeof(integer));
      FileRead(fhandle, h, sizeof(integer));
      Lights[i].Width  := w;
      Lights[i].Height := h;
      Lights[i].PFog   := AllocMem(w * h + 8);
      if prevsize < w * h then begin
        FileRead(fhandle, Lights[i].PFog^, w * h);
      end else
        cheat := True;
      prevsize := w * h;
      if LightSizes[i] <> prevsize then
        cheat := True;
      FileClose(fhandle);
    end;
  end;
  if cheat then
    for i := 0 to MAXLIGHT do begin
      if Lights[i].PFog <> nil then
        FillChar(Lights[i].PFog^, Lights[i].Width * Lights[i].Height + 8, #0);
    end;
end;

procedure TPlayScene.ClearLightMap;
var
  i, j: integer;
begin
  FillChar(LightMap, (LMX + 1) * (LMY + 1) * sizeof(TLightMapInfo), 0);
  for i := 0 to LMX do
    for j := 0 to LMY do
      LightMap[i, j].Light := -1;
end;

procedure TPlayScene.UpdateBright(x, y, light: integer);
var
  i, j, r, lx, ly: integer;
  pmask: ^shortint;
begin
  r := -1;
  case light of
    0: begin
      r     := 2;
      pmask := @LightMask0;
    end;
    1: begin
      r     := 4;
      pmask := @LightMask1;
    end;
    2: begin
      r     := 8;
      pmask := @LightMask2;
    end;
    3: begin
      r     := 10;
      pmask := @LightMask3;
    end;
    4: begin
      r     := 14;
      pmask := @LightMask4;
    end;
    5: begin
      r     := 16;
      pmask := @LightMask5;
    end;
  end;
  for i := 0 to r do
    for j := 0 to r do begin
      lx := x - (r div 2) + i;
      ly := y - (r div 2) + j;
      if (lx in [0..LMX]) and (ly in [0..LMY]) then
        LightMap[lx, ly].bright :=
          LightMap[lx, ly].bright + PShoftInt(integer(pmask) +
          (i * (r + 1) + j) * sizeof(shortint))^;
    end;
end;

function TPlayScene.CheckOverLight(x, y, light: integer): boolean;
var
  i, j, r, mlight, lx, ly, Count, check: integer;
  pmask: ^shortint;
begin
  r := -1;
  case light of
    0: begin
      r     := 2;
      pmask := @LightMask0;
      check := 0;
    end;
    1: begin
      r     := 4;
      pmask := @LightMask1;
      check := 4;
    end;
    2: begin
      r     := 8;
      pmask := @LightMask2;
      check := 8;
    end;
    3: begin
      r     := 10;
      pmask := @LightMask3;
      check := 18;
    end;
    4: begin
      r     := 14;
      pmask := @LightMask4;
      check := 30;
    end;
    5: begin
      r     := 16;
      pmask := @LightMask5;
      check := 40;
    end;
  end;
  Count := 0;
  for i := 0 to r do
    for j := 0 to r do begin
      lx := x - (r div 2) + i;
      ly := y - (r div 2) + j;
      if (lx in [0..LMX]) and (ly in [0..LMY]) then begin
        mlight := PShoftInt(integer(pmask) + (i * (r + 1) + j) * sizeof(shortint))^;
        if LightMap[lx, ly].bright < mlight then begin
          Inc(Count, mlight - LightMap[lx, ly].bright);
          if Count >= check then begin
            Result := False;
            exit;
          end;
        end;
      end;
    end;
  Result := True;
end;

procedure TPlayScene.AddLight(x, y, shiftx, shifty, light: integer; nocheck: boolean);
var
  lx, ly: integer;
begin
  lx := x - Myself.Rx + LMX div 2;
  ly := y - Myself.Ry + LMY div 2;
  if (lx >= 1) and (lx < LMX) and (ly >= 1) and (ly < LMY) then begin
    if LightMap[lx, ly].light < light then begin
      if not CheckOverLight(lx, ly, light) or nocheck then begin
        // > LightMap[lx, ly].light then begin
        UpdateBright(lx, ly, light);
        LightMap[lx, ly].light  := light;
        LightMap[lx, ly].Shiftx := shiftx;
        LightMap[lx, ly].Shifty := shifty;
      end;
    end;
  end;
end;

procedure TPlayScene.ApplyLightMap;
var
  i, j, light, defx, defy, lx, ly, lxx, lyy, lcount: integer;
begin
  defx   := -UNITX * 2 + AAX + 14 - Myself.ShiftX;
  defy   := -UNITY * 3 - Myself.ShiftY;
  lcount := 0;
  for i := 1 to LMX - 1 do
    for j := 1 to LMY - 1 do begin
      light := LightMap[i, j].light;
      if light >= 0 then begin
        lx  := (i + Myself.Rx - LMX div 2);
        ly  := (j + Myself.Ry - LMY div 2);
        lxx := (lx - Map.ClientRect.Left) * UNITX + defx + LightMap[i, j].ShiftX;
        lyy := (ly - Map.ClientRect.Top) * UNITY + defy + LightMap[i, j].ShiftY;

        FogCopy(Lights[light].PFog,
          0,
          0,
          Lights[light].Width,
          Lights[light].Height,
          PFogScreen,
          lxx - (Lights[light].Width - UNITX) div 2,
          lyy - (Lights[light].Height - UNITY) div 2 - 5,
          FogWidth,
          FogHeight,
          20);
        Inc(lcount);
      end;
    end;
end;

procedure TPlayScene.DrawLightEffect(lx, ly, bright: integer);
begin
  if (bright > 0) and (bright <= MAXLIGHT) then
    FogCopy(Lights[bright].PFog,
      0,
      0,
      Lights[bright].Width,
      Lights[bright].Height,
      PFogScreen,
      lx - (Lights[bright].Width - UNITX) div 2,
      ly - (Lights[bright].Height - UNITY) div 2,
      FogWidth,
      FogHeight,
      15);
end;

{-----------------------------------------------------------------------}

procedure TPlayScene.DrawMiniMap(surface: TDirectDrawSurface; transparent: boolean);
var
  d:     TDirectDrawSurface;
  v:     boolean;
  i, k, cl, ix, mx, my: integer;
  rc:    TRect;
  actor: TActor;
begin
  // 2003/02/11 깜박거리지 않게 함...
  //   if GetTickCount > BlinkTime + 300 then begin
  //      BlinkTime := GetTickCount;
  //      ViewBlink := not ViewBlink;
  //   end;

  d := FrmMain.WMMap.Images[MiniMapIndex];
  if d <> nil then begin
    mx      := (Myself.XX * 48) div 32;
    my      := (Myself.YY * 32) div 32;
    rc.Left := _MAX(0, mx - 60);
    rc.Top  := _MAX(0, my - 60);
    rc.Right := _MIN(d.ClientRect.Right, rc.Left + 120);
    rc.Bottom := _MIN(d.ClientRect.Bottom, rc.Top + 120);

    if transparent then
      DrawBlendEx(surface, (SCREENWIDTH - 120), 0, d, rc.Left, rc.Top, 120, 120, 0)
    else
      surface.Draw((SCREENWIDTH - 120), 0, rc, d, False);

    //    if ViewBlink then begin
    ix := (SCREENWIDTH - 120) - rc.Left;
    // 2003/02/11 미니맵상에 다른 오브잭트들 출력
    if ActorList.Count > 0 then begin
      for i := 0 to ActorList.Count - 1 do begin
        mx := ix + (TActor(ActorList[i]).XX * 48) div 32;
        my := (TActor(ActorList[i]).YY * 32) div 32 - rc.Top;
        cl := 0;
        case TActor(ActorList[i]).Race of
          RC_USERHUMAN: if (TActor(ActorList[i]) = Myself) then
              cl := 255
            else if (nil <> fLover) and
              (Length(Trim(TActor(ActorList[i]).UserName)) > 0) and
              (TActor(ActorList[i]).UserName =
              Copy(fLover.GetDisplay(0), length(STR_LOVER) + 1, 20)) and
              (not TActor(ActorList[i]).BoOpenHealth) then begin
              //      DScreen.AddChatBoardString ('TActor(ActorList[i]).UserName=> '+TActor(ActorList[i]).UserName, clYellow, clRed);
              //      DScreen.AddChatBoardString ('fLover.GetDisplay(0)=> '+fLover.GetDisplay(0), clYellow, clRed);
              cl := 253;
            end else
              cl := 0;  // 사람 출력하지 않음...그룹원은 ViewList에서 출력

          RCC_GUARD,
          RCC_GUARD2,
          RCC_MERCHANT: cl := 251;
          54, 55: cl := 0;
          // 신수 출력하지 않음...ViewList에서 출력...250
          98, 99: cl := 0;
          else
            if ((TActor(ActorList[i]).Visible) and (not TActor(ActorList[i]).Death) and
              (pos('(', TActor(ActorList[i]).UserName) = 0)) then
              cl := 249;
        end;

        if (mx > 680) and (my < 119) then begin //@@@@old
          if cl > 0 then begin
            surface.Pixels[mx - 1, my - 1] := cl;
            surface.Pixels[mx, my - 1] := cl;
            surface.Pixels[mx + 1, my - 1] := cl;
            surface.Pixels[mx - 1, my] := cl;
            surface.Pixels[mx, my]     := cl;
            surface.Pixels[mx + 1, my] := cl;
            surface.Pixels[mx - 1, my + 1] := cl;
            surface.Pixels[mx, my + 1] := cl;
            surface.Pixels[mx + 1, my + 1] := cl;
          end;
        end;
      end;
    end;
    if ViewListCount > 0 then begin
      for i := 1 to ViewListCount do begin
        if ((abs(ViewList[i].x - Myself.XX) < 40) and
          (abs(ViewList[i].y - Myself.YY) < 40)) then begin
          mx := ix + (ViewList[i].x * 48) div 32;
          my := (ViewList[i].y * 32) div 32 - rc.Top;
          if (mx > 680) and (my < 119) then begin //@@@@old
            cl := 252;
            surface.Pixels[mx - 1, my - 1] := cl;
            surface.Pixels[mx, my - 1] := cl;
            surface.Pixels[mx + 1, my - 1] := cl;
            surface.Pixels[mx - 1, my] := cl;
            surface.Pixels[mx, my] := cl;
            surface.Pixels[mx + 1, my] := cl;
            surface.Pixels[mx - 1, my + 1] := cl;
            surface.Pixels[mx, my + 1] := cl;
            surface.Pixels[mx + 1, my + 1] := cl;
          end;
        end;
        // 오래됐으니 지우자...
        if (((GetTickCount - ViewList[i].LastTick) > 5000) and
          (ViewList[i].Index > 0)) then begin
          // 2003/03/04 그룹원 탐기파연 설정
          actor := FindActor(ViewList[i].Index);
          if actor <> nil then begin
            actor.BoOpenHealth := False;
            if GroupIdList.Count > 0 then
              for k := 0 to GroupIdList.Count - 1 do begin  // MonOpenHp
                if integer(GroupIdList[k]) = actor.RecogId then begin
                  GroupIdList.Delete(k);
                  Break;
                end;
              end;
          end;
          // 아직 남은게 있다면 이동
          if (ViewListCount > 0) then begin
            ViewList[i].Index := ViewList[ViewListCount].Index;
            ViewList[i].x     := ViewList[ViewListCount].x;
            ViewList[i].y     := ViewList[ViewListCount].y;
            ViewList[i].LastTick := ViewList[ViewListCount].LastTick;
            ViewList[ViewListCount].Index := 0;
            ViewList[ViewListCount].x := 0;
            ViewList[ViewListCount].y := 0;
            ViewList[ViewListCount].LastTick := 0;
          end;
          Dec(ViewListCount);
        end;
      end;
    end;
    //    end;
  end;
end;


{-----------------------------------------------------------------------}


procedure TPlayScene.PlayScene(MSurface: TDirectDrawSurface);

  function CheckOverlappedObject(myrc, obrc: TRect): boolean;
  begin
    if (obrc.Right > myrc.Left) and (obrc.Left < myrc.Right) and
      (obrc.Bottom > myrc.Top) and (obrc.Top < myrc.Bottom) then
      Result := True
    else
      Result := False;
  end;

var
  i, j, k, n, m, mmm, ix, iy, line, defx, defy, wunit, fridx, ani,
  anitick, ax, ay, idx, drawingbottomline: integer;
  DSurface, d: TDirectDrawSurface;
  blend, movetick: boolean;
  //myrc, obrc: TRect;
  pd:     PTDropItem;
  evn:    TClEvent;
  actor:  TActor;
  meff:   TMagicEff;
  msgstr: string;
  px, py, ImgPosX, ImgPosY: integer;
begin
  if (Myself = nil) then begin
    msgstr := 'Please wait just for a little while.';
    with MSurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      BoldTextOut(MSurface, (SCREENWIDTH - TextWidth(msgstr)) div 2, 200,
        clWhite, clBlack, msgstr);
      Release;
    end;
    exit;
  end;

  DoFastFadeOut := False;

  //캐릭터에들에게 메세지를 전달    07/03
  movetick := False;
  if GetTickCount - MoveTime >= 100 then begin
    MoveTime := GetTickCount;   //이동의 동기화
    movetick := True;           //이동 틱
    Inc(MoveStepCount);
    if MoveStepCount > 1 then
      MoveStepCount := 0;
  end;
  if GetTickCount - AniTime >= 50 then begin
    AniTime := GetTickCount;
    Inc(MainAniCount);
    if MainAniCount > 1000000 then
      MainAniCount := 0;
  end;

  try
    i := 0;                          //여기는 메세지만 처리함
    while True do begin              //Frame 처리는 여기서 안함.
      if i >= ActorList.Count then
        break;
      actor := ActorList[i];
      if movetick then
        actor.LockEndFrame := False;
      if not actor.LockEndFrame then begin
        actor.ProcMsg;   //메세지 처리하면서 actor가 지워질 수 있음.
        if movetick then
          if actor.Move(MoveStepCount) then begin  //동기화해서 움직임
            Inc(i);
            continue;
          end;
        actor.Run;    //캐릭터들을 움직이게 함.
        if actor <> Myself then
          actor.ProcHurryMsg;
      end;
      if actor = Myself then
        actor.ProcHurryMsg;
      //변신인 경우
      if actor.WaitForRecogId <> 0 then begin
        if actor.IsIdle then begin
          DelChangeFace(actor.WaitForRecogId);
          NewActor(actor.WaitForRecogId, actor.XX, actor.YY,
            actor.Dir, actor.WaitForFeature, actor.WaitForStatus);
          actor.WaitForRecogId := 0;
          actor.BoDelActor     := True;
        end;
      end;
      if actor.BoDelActor then begin
        //actor.Free;
        FreeActorList.Add(actor);
        ActorList.Delete(i);
        if TargetCret = actor then
          TargetCret := nil;
        if FocusCret = actor then
          FocusCret := nil;
        if MagicTarget = actor then
          MagicTarget := nil;
      end else
        Inc(i);
    end;
  except
    DebugOutStr('101');
  end;

  try
    i := 0;
    while True do begin
      if i >= GroundEffectList.Count then
        break;
      meff := GroundEffectList[i];
      if meff.Active then begin
        if not meff.Run then begin //마법효과
          meff.Free;
          GroundEffectList.Delete(i);
          continue;
        end;
      end;
      Inc(i);
    end;
    i := 0;
    while True do begin
      if i >= EffectList.Count then
        break;
      meff := EffectList[i];
      if meff.Active then begin
        if not meff.Run then begin //마법효과
          meff.Free;
          EffectList.Delete(i);
          continue;
        end;
      end;
      Inc(i);
    end;
    i := 0;
    while True do begin
      if i >= FlyList.Count then
        break;
      meff := FlyList[i];
      if meff.Active then begin
        if not meff.Run then begin //도끼,화살등 날아가는것
          meff.Free;
          FlyList.Delete(i);
          continue;
        end;
      end;
      Inc(i);
    end;

    EventMan.Execute;
  except
    DebugOutStr('102');
  end;

  try
    //사라진 아이템 체크
    for k := 0 to DropedItemList.Count - 1 do begin
      pd := PTDropItem(DropedItemList[k]);
      if pd <> nil then begin
        if (Abs(pd.x - Myself.XX) > 30) and (Abs(pd.y - Myself.YY) > 30) then begin
          Dispose(PTDropItem(DropedItemList[k]));
          DropedItemList.Delete(k);
          break;  //한번에 한개씩..
        end;
      end;
    end;
    //사라진 다이나믹오브젝트 검사
    for k := 0 to EventMan.EventList.Count - 1 do begin
      evn := TClEvent(EventMan.EventList[k]);
      if (Abs(evn.X - Myself.XX) > 30) and (Abs(evn.Y - Myself.YY) > 30) then begin
        evn.Free;
        EventMan.EventList.Delete(k);
        break;  //한번에 한개씩
      end;
    end;
  except
    DebugOutStr('103');
  end;

  try
    with Map.ClientRect do begin
      Left   := MySelf.Rx - 9;
      Top    := MySelf.Ry - 9;
      Right  := MySelf.Rx + 9;                         // 오른쪽 짜투리 그림
      Bottom := MySelf.Ry + 8;
    end;
    Map.UpdateMapPos(Myself.Rx, Myself.Ry);

    ///////////////////////
    //ViewFog := FALSE;
    ///////////////////////

    if NoDarkness or (Myself.Death) then begin
      ViewFog := False;
    end;

    if ViewFog then begin //포그
      ZeroMemory(PFogScreen, MAPSURFACEHEIGHT * MAPSURFACEWIDTH);
      ClearLightMap;
    end;

    drawingbottomline := 450;
    ObjSurface.Fill(0);
    DrawTileMap;
    ObjSurface.Draw(0, 0,
      Rect(UNITX * 3 + Myself.ShiftX, UNITY * 2 + Myself.ShiftY,
      UNITX * 3 + Myself.ShiftX + MAPSURFACEWIDTH, UNITY * 2 +
      Myself.ShiftY + MAPSURFACEHEIGHT),
      MapSurface,
      False);

  except
    DebugOutStr('104');
  end;

  defx  := -UNITX * 2 - Myself.ShiftX + AAX + 14;
  defy  := -UNITY * 2 - Myself.ShiftY;
  DefXX := defx;
  DefYY := defy;

  try
    m := defy - UNITY;
    for j := (Map.ClientRect.Top - Map.BlockTop)
      to (Map.ClientRect.Bottom - Map.BlockTop + LONGHEIGHT_IMAGE) do begin
      if j < 0 then begin
        Inc(m, UNITY);
        continue;
      end;
      n := defx - UNITX * 2;
      //*** 48*32 타일형 오브젝트 그리기
      for i := (Map.ClientRect.Left - Map.BlockLeft - 2)
        to (Map.ClientRect.Right - Map.BlockLeft + 2) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and
          (j < LOGICALMAPUNIT * 3) then begin
          fridx := (Map.MArr[i, j].FrImg) and $7FFF;
          if fridx > 0 then begin
            ani   := Map.MArr[i, j].AniFrame;
            wunit := Map.MArr[i, j].Area;
            if (ani and $80) > 0 then begin
              blend := True;
              ani   := ani and $7F;
            end;
            if ani > 0 then begin
              anitick := Map.MArr[i, j].AniTick;
              fridx   := fridx + (MainAniCount mod (ani + (ani * anitick))) div
                (1 + anitick);
            end;
            if (Map.MArr[i, j].DoorOffset and $80) > 0 then begin //열림
              if (Map.MArr[i, j].DoorIndex and $7F) > 0 then  //문으로 표시된 것만
                fridx := fridx + (Map.MArr[i, j].DoorOffset and $7F); //열린 문
            end;
            fridx    := fridx - 1;
            // 물체 그림
            DSurface := FrmMain.GetObjs(wunit, fridx);
            if DSurface <> nil then begin
              if (DSurface.Width = 48) and (DSurface.Height = 32) then begin
                mmm := m + UNITY - DSurface.Height;
                if (n + DSurface.Width > 0) and (n <= SCREENWIDTH) and
                  (mmm + DSurface.Height > 0) and (mmm < drawingbottomline) then begin
                  ObjSurface.Draw(n, mmm, DSurface.ClientRect, Dsurface, True);
                end else begin
                  if mmm < drawingbottomline then begin
                    //불필요하게 그리는 것을 피함
                    ObjSurface.Draw(n, mmm, DSurface.ClientRect, DSurface, True);
                  end;
                end;
              end;
            end;
          end;
        end;
        Inc(n, UNITX);
      end;
      Inc(m, UNITY);
    end;

    //땅바닥에 그려지는 마법
    for k := 0 to GroundEffectList.Count - 1 do begin
      meff := TMagicEff(GroundEffectList[k]);
      //if j = (meff.Ry - Map.BlockTop) then begin
      meff.DrawEff(ObjSurface);
      if ViewFog then begin
        AddLight(meff.Rx, meff.Ry, 0, 0, meff.light, False);
      end;
    end;

  except
    DebugOutStr('105');
  end;

  try
    m := defy - UNITY;
    for j := (Map.ClientRect.Top - Map.BlockTop)
      to (Map.ClientRect.Bottom - Map.BlockTop + LONGHEIGHT_IMAGE) do begin
      if j < 0 then begin
        Inc(m, UNITY);
        continue;
      end;
      n := defx - UNITX * 2;
      //*** 배경오브젝트 그리기
      for i := (Map.ClientRect.Left - Map.BlockLeft - 2)
        to (Map.ClientRect.Right - Map.BlockLeft + 2) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and
          (j < LOGICALMAPUNIT * 3) then begin
          fridx := (Map.MArr[i, j].FrImg) and $7FFF;
          if fridx > 0 then begin
            blend := False;
            wunit := Map.MArr[i, j].Area;
            //에니메이션
            ani   := Map.MArr[i, j].AniFrame;
            if (ani and $80) > 0 then begin
              blend := True;
              ani   := ani and $7F;
            end;
            if ani > 0 then begin
              anitick := Map.MArr[i, j].AniTick;
              fridx   := fridx + (MainAniCount mod (ani + (ani * anitick))) div
                (1 + anitick);
            end;
            if (Map.MArr[i, j].DoorOffset and $80) > 0 then begin //열림
              if (Map.MArr[i, j].DoorIndex and $7F) > 0 then  //문으로 표시된 것만
                fridx := fridx + (Map.MArr[i, j].DoorOffset and $7F); //열린 문
            end;
            fridx := fridx - 1;
            // 물체 그림
            if not blend then begin
              DSurface := FrmMain.GetObjs(wunit, fridx);
              if DSurface <> nil then begin
                if (DSurface.Width <> 48) or (DSurface.Height <> 32) then begin
                  mmm := m + UNITY - DSurface.Height;
                  if (n + DSurface.Width > 0) and (n <= SCREENWIDTH) and
                    (mmm + DSurface.Height > 0) and (mmm < drawingbottomline) then begin
                    ObjSurface.Draw(n, mmm, DSurface.ClientRect, Dsurface, True);
                  end else begin
                    if mmm < drawingbottomline then begin
                      //불필요하게 그리는 것을 피함
                      ObjSurface.Draw(n, mmm, DSurface.ClientRect,
                        DSurface, True);
                    end;
                  end;
                end;
              end;
            end else begin
              DSurface := FrmMain.GetObjsEx(wunit, fridx, ax, ay);
              if DSurface <> nil then begin
                mmm := m + ay - 68; //UNITY - DSurface.Height;
                if (n > 0) and (mmm + DSurface.Height > 0) and
                  (n + Dsurface.Width < SCREENWIDTH) and (mmm < drawingbottomline) then
                begin
                  DrawBlend(ObjSurface, n + ax - 2, mmm, DSurface, 1);
                end else begin
                  if mmm < drawingbottomline then begin
                    //불필요하게 그리는 것을 피함
                    DrawBlend(ObjSurface, n + ax - 2, mmm, DSurface, 1);
                  end;
                end;
              end;
            end;
          end;

        end;
        Inc(n, UNITX);
      end;

      if (j <= (Map.ClientRect.Bottom - Map.BlockTop)) and (not BoServerChanging) then
      begin

        //*** 바닥에 변경된 흙의 흔적
        for k := 0 to EventMan.EventList.Count - 1 do begin
          evn := TClEvent(EventMan.EventList[k]);
          if j = (evn.Y - Map.BlockTop) then begin
            evn.DrawEvent(ObjSurface,
              (evn.X - Map.ClientRect.Left) * UNITX + defx,
              m);
          end;
        end;

        //*** 바닥에 떨어진 아이템 그리기
        for k := 0 to DropedItemList.Count - 1 do begin
          pd := PTDropItem(DropedItemList[k]);
          if pd <> nil then begin

            if j = (pd.y - Map.BlockTop) then begin
              if pd.BoDeco then
                d := FrmMain.WDecoImg.Images[pd.Looks]
              else
                d := FrmMain.WDnItem.Images[pd.Looks];

              if d <> nil then begin
                ix := (pd.x - Map.ClientRect.Left) * UNITX + defx + SOFFX;
                // + actor.ShiftX;
                iy := m; // + actor.ShiftY;
                if pd.BoDeco then begin
                  FrmMain.WDecoImg.GetCachedImage(pd.Looks, px, py);
                  ImgPosX := ix + px;
                  ImgPosY := iy + py;
                end else begin
                  ImgPosX := ix + HALFX - (d.Width div 2);
                  ImgPosY := iy + HALFY - (d.Height div 2);
                end;
                if pd = FocusItem then begin
                  if (d.Width > ImgMixSurface.Width) or
                    (d.Height > ImgMixSurface.Height) then begin
                    ImgLargeMixSurface.Draw(0, 0, d.ClientRect, d, False);
                    DrawEffect(0, 0, d.Width, d.Height,
                      ImgLargeMixSurface, ceBright);
                    ObjSurface.Draw(ImgPosX, ImgPosY,
                      d.ClientRect,
                      ImgLargeMixSurface, True);
                  end else begin
                    ImgMixSurface.Draw(0, 0, d.ClientRect, d, False);
                    DrawEffect(0, 0, d.Width, d.Height, ImgMixSurface, ceBright);
                    //                        ObjSurface.Draw (ix + HALFX-(d.Width div 2),
                    //                                      iy + HALFY-(d.Height div 2),
                    //                                      d.ClientRect,
                    //                                      ImgMixSurface, TRUE);
                    ObjSurface.Draw(ImgPosX, ImgPosY,
                      d.ClientRect,
                      ImgMixSurface, True);
                  end;
                end else
                  //                        ObjSurface.Draw (ix + HALFX-(d.Width div 2),
                  //                                      iy + HALFY-(d.Height div 2),
                  //                                      d.ClientRect,
                  //                                      d, TRUE);
                  ObjSurface.Draw(ImgPosX, ImgPosY,
                    d.ClientRect,
                    d, True);

              end;
            end;
          end;
        end;

        //*** 캐릭터 그리기
        for k := 0 to ActorList.Count - 1 do begin
          actor := ActorList[k];
          if actor.Race = 81 then begin  // 월령(천녀)
            if actor.State and $00800000 = 0 then begin//투명이 아니면
              actor.DrawChr(ObjSurface,
                (actor.Rx - Map.ClientRect.Left) * UNITX + defx,
                (actor.Ry - Map.ClientRect.Top - 1) * UNITY + defy, True, False);
            end;
          end;

          if (j = actor.Ry - Map.BlockTop - actor.DownDrawLevel) then begin
            actor.SayX := (actor.Rx - Map.ClientRect.Left) * UNITX +
              defx + actor.ShiftX + 24;
            if actor.Death then
              actor.SayY :=
                m + UNITY + actor.ShiftY + 16 - 60 + (actor.DownDrawLevel * UNITY)
            else
              actor.SayY := m + UNITY + actor.ShiftY + 16 - 95 +
                (actor.DownDrawLevel * UNITY);
            actor.DrawChr(ObjSurface, (actor.Rx - Map.ClientRect.Left) * UNITX + defx,
              m + (actor.DownDrawLevel * UNITY),
              False, True);
          end;
        end;
        for k := 0 to FlyList.Count - 1 do begin
          meff := TMagicEff(FlyList[k]);
          if j = (meff.Ry - Map.BlockTop) then
            meff.DrawEff(ObjSurface);
        end;

      end;
      Inc(m, UNITY);
    end;
  except
    DebugOutStr('106');
  end;


  try
    if ViewFog then begin
      m := defy - UNITY * 4;
      for j := (Map.ClientRect.Top - Map.BlockTop - 4)
        to (Map.ClientRect.Bottom - Map.BlockTop + LONGHEIGHT_IMAGE) do begin
        if j < 0 then begin
          Inc(m, UNITY);
          continue;
        end;
        n := defx - UNITX * 5;
        //배경 포그 그리기
        for i := (Map.ClientRect.Left - Map.BlockLeft - 5)
          to (Map.ClientRect.Right - Map.BlockLeft + 5) do begin
          if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and
            (j < LOGICALMAPUNIT * 3) then begin
            idx := Map.MArr[i, j].Light;
            if idx > 0 then begin
              AddLight(i + Map.BlockLeft, j + Map.BlockTop, 0, 0, idx, False);
            end;
          end;
          Inc(n, UNITX);
        end;
        Inc(m, UNITY);
      end;

      //캐릭터 포그 그리기
      if ActorList.Count > 0 then begin
        for k := 0 to ActorList.Count - 1 do begin
          actor := ActorList[k];
          if (actor = Myself) or (actor.Light > 0) then
            AddLight(actor.Rx, actor.Ry, actor.ShiftX, actor.ShiftY,
              actor.Light, actor = Myself);
        end;
      end else begin
        if Myself <> nil then
          AddLight(Myself.Rx, Myself.Ry, Myself.ShiftX, Myself.ShiftY,
            Myself.Light, True);
      end;
    end;
  except
    DebugOutStr('107');
  end;

  if not BoServerChanging then begin
    try
      if (MagicTarget <> nil) then begin
        //         if IsValidActor (MagicTarget) and (MagicTarget <> Myself) then
        //         if IsValidActor (MagicTarget) and (MagicTarget <> Myself) and ((actor.Race <> 81)) then
        if IsValidActor(MagicTarget) and (MagicTarget <> Myself) and
          ((MagicTarget.Race <> 81)) then
          if MagicTarget.State and $00800000 = 0 then //투명이 아니면
            MagicTarget.DrawChr(ObjSurface,
              (MagicTarget.Rx - Map.ClientRect.Left) * UNITX + defx,
              (MagicTarget.Ry - Map.ClientRect.Top - 1) * UNITY + defy,
              True, False);
      end;

      //**** 주인공 캐릭터 그리기
      //      if not CheckBadMapMode then
      //         if ( Myself.State and $00800000 = 0 ) then //투명이 아니면 1번모드일때에는 풀어줌
      //         begin
      Myself.DrawChr(ObjSurface, (Myself.Rx - Map.ClientRect.Left) * UNITX + defx,
        (Myself.Ry - Map.ClientRect.Top - 1) * UNITY + defy, True, False);
      //         end;

      //**** 마우스를 갖다대고 있는 캐릭터
      if (FocusCret <> nil) then begin
        //         if IsValidActor (FocusCret) and (FocusCret <> Myself) then
        //         if IsValidActor (FocusCret) and (FocusCret <> Myself) and (actor.Race <> 81) then
        if IsValidActor(FocusCret) and (FocusCret <> Myself) and
          (FocusCret.Race <> 81) then
          if FocusCret.State and $00800000 = 0 then //투명이 아니면
            FocusCret.DrawChr(ObjSurface,
              (FocusCret.Rx - Map.ClientRect.Left) * UNITX + defx,
              (FocusCret.Ry - Map.ClientRect.Top - 1) * UNITY + defy, True, False);
      end;
    except
      DebugOutStr('108');
    end;
  end;

  try
    //**** 마법 효과
    for k := 0 to ActorList.Count - 1 do begin
      actor := ActorList[k];
      actor.DrawEff(ObjSurface,
        (actor.Rx - Map.ClientRect.Left) * UNITX + defx,
        (actor.Ry - Map.ClientRect.Top - 1) * UNITY + defy);
    end;
    for k := 0 to EffectList.Count - 1 do begin
      meff := TMagicEff(EffectList[k]);
      //if j = (meff.Ry - Map.BlockTop) then begin
      meff.DrawEff(ObjSurface);
      if ViewFog then begin
        AddLight(meff.Rx, meff.Ry, 0, 0, meff.Light, False);
      end;
    end;
    if ViewFog then begin
      for k := 0 to EventMan.EventList.Count - 1 do begin
        evn := TClEvent(EventMan.EventList[k]);
        if evn.light > 0 then
          AddLight(evn.X, evn.Y, 0, 0, evn.light, False);
      end;
    end;
  except
    DebugOutStr('109');
  end;

  //땅에 떨어진 아이템 빤짝거리는 거
  try
    for k := 0 to DropedItemList.Count - 1 do begin
      pd := PTDropItem(DropedItemList[k]);
      if (pd <> nil) and (not pd.BoDeco) then begin
        if GetTickCount - pd.FlashTime > 5 * 1000 then begin
          pd.FlashTime := GetTickCount;
          pd.BoFlash   := True;
          pd.FlashStepTime := GetTickCount;
          pd.FlashStep := 0;
        end;
        if pd.BoFlash then begin
          //               if GetTickCount - pd.FlashStepTime >= 20 then begin
          if GetTickCount - pd.FlashStepTime >= 50 then begin
            pd.FlashStepTime := GetTickCount;
            Inc(pd.FlashStep);
          end;
          ix := (pd.x - Map.ClientRect.Left) * UNITX + defx + SOFFX;
          iy := (pd.y - Map.ClientRect.Top - 1) * UNITY + defy + SOFFY;
          if (pd.FlashStep >= 0) and (pd.FlashStep < 10) then begin
            DSurface := FrmMain.WProgUse.GetCachedImage(
              FLASHBASE + pd.FlashStep, ax, ay);
            DrawBlend(ObjSurface, ix + ax, iy + ay, DSurface, 1);
          end else
            pd.BoFlash := False;
        end;
      end;
    end;
  except
    DebugOutStr('110');
  end;

  try
    if ViewFog then begin
      ApplyLightMap;
      DrawFog(ObjSurface, PFogScreen, FogWidth);
      MSurface.Draw(SOFFX, SOFFY, ObjSurface.ClientRect, ObjSurface, False);
    end else begin
      if Myself.Death then
        DrawEffect(0, 0, ObjSurface.Width, ObjSurface.Height, ObjSurface, ceGrayScale);
      //오브젝트 레이어와  배경과 합성
      MSurface.Draw(SOFFX, SOFFY, ObjSurface.ClientRect, ObjSurface, False);
    end;
  except
    DebugOutStr('111');
  end;

  if ViewMiniMapStyle > 0 then begin
    if ViewMiniMapStyle = 1 then
      DrawMiniMap(MSurface, True)
    else
      DrawMiniMap(MSurface, False);
  end;

end;

{-------------------------------------------------------}

//cx, cy, tx, ty : 맵의 좌표
procedure TPlayScene.NewMagic(aowner: TActor;
  magid, magnumb, cx, cy, tx, ty, targetcode: integer; mtype: TMagicType;
  Recusion: boolean; anitime: integer; var bofly: boolean);
var
  i, scx, scy, sctx, scty, effnum: integer;
  meff:   TMagicEff;
  target: TActor;
  wimg:   TWMImages;
begin
  bofly := False;
  if (magid <> 111) and (not (magid in [SM_DRAGON_LIGHTING, 70, 71, 72, 73, 74])) then
    //발사 마법은 중복됨. // FireDragon
    for i := 0 to EffectList.Count - 1 do
      if TMagicEff(EffectList[i]).ServerMagicId = magid then
        exit; //이미 있음..
  if magnumb in [52, 53] then begin
  ScreenXYfromMCXY(cx, cy, scx, scy);
  ScreenXYfromMCXY(tx, ty - 20, sctx, scty);
  end else begin
  ScreenXYfromMCXY(cx, cy, scx, scy);
  ScreenXYfromMCXY(tx, ty, sctx, scty);
  end;
  if magnumb > 0 then
    GetEffectBase(magnumb - 1, 0, wimg, effnum)
  else
    effnum := -magnumb;
  target := FindActor(targetcode);

  meff := nil;
  case mtype of
    mtReady, mtFly, mtFlyAxe: begin
      meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
        scty, mtype, Recusion, anitime);
      meff.TargetActor := target;

      meff.ImgLib := wimg;

      bofly := True;
    end;
    mtFlyBug: begin
      meff  := TFlyingBug.Create(magid, effnum, scx, scy, sctx,
        scty, mtype, Recusion, anitime);
      meff.TargetActor := target;
      //if effnum = 38 then
      //   meff.ImgLib := FrmMain.WMagic2;
      bofly := True;
    end;
    mtFlySoulBang: begin
      meff  := TFlyingSoulBang.Create(magid, effnum, scx, scy, sctx,
        scty, mtype, Recusion, anitime);
      meff.TargetActor := target;
      //if effnum = 38 then
      //   meff.ImgLib := FrmMain.WMagic2;
      bofly := True;
    end;
    mtRockPull: begin
      meff  := TRockPull.Create(magid, effnum, scx, scy, sctx,
        scty, mtype, Recusion, anitime);
      meff.TargetActor := target;
      bofly := True;
    end;
    mtFlyCurse: begin
      meff  := TFlyingCurse.Create(magid, effnum, scx, scy, sctx,
        scty, mtype, Recusion, anitime);
      meff.TargetActor := target;
      //if effnum = 38 then
      //   meff.ImgLib := FrmMain.WMagic2;
      bofly := True;
    end;

    mtExplosion: case magnumb of
        18: begin //뢰혼격
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 1570;
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
        end;
        21: begin //폭열파
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 1660;
          meff.TargetActor := nil; //target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 20;
          meff.Light := 3;
        end;
        26: begin //탐기파연
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 3990;
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 10;
          meff.Light := 2;
        end;
        27: begin //대회복술
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 1800;
          meff.TargetActor := nil; //target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 10;
          meff.Light := 3;
        end;
        30: begin //사자윤회
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 3930;
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 16;
          meff.Light := 3;
        end;
        31: begin //빙설풍
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 3850;
          meff.TargetActor := nil; //target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 20;
          meff.Light := 3;
        end;
        40: begin //정화술
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 620;
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 10;
          meff.Light := 3;
          meff.ImgLib := wimg;
        end;
        47: begin //포승검
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 1010;
          meff.TargetActor := target;
          meff.NextFrameTime := 120;
          meff.ExplosionFrame := 10;
          meff.Light := 2;
          meff.ImgLib := wimg;
        end;
        52: begin //Blizzard
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 1550;
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 30;
          meff.Light := 2;
          wimg   := FrmMain.WMagic2;
          meff.ImgLib := wimg;
          PlaySound(10523);
          meff.TargetActor := nil
        end;
        53: begin //MeteorStrike
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 1610;
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 30;
          meff.Light := 2;
          wimg   := FrmMain.WMagic2;
          meff.ImgLib := wimg;
          PlaySound(10532);
          PlaySound(10533);
          meff.TargetActor := nil;
        end;
        90: begin // 용석상 지염 FireDragon
          wimg   := FrmMain.WDragonImg;
          meff.ImgLib := wimg;
          effnum := 350;
          meff   := TMagicEff.Create(magid, effnum, scx, scy,
            sctx, scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 350;
          meff.ExplosionFrame := 30;
          meff.TargetActor := nil; //target;
          meff.NextFrameTime := 100;
          meff.Light := 3;
        end;

        else begin  //회복등..
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
        end;
      end;
    mtFireWind: meff := nil;  //효과 없음
    mtFireGun: //화염방사
      meff := TFireGunEffect.Create(930, scx, scy, sctx, scty);
    mtThunder: begin
      if magnumb = SM_DRAGON_LIGHTING then begin
        meff := TThuderEffectEx.Create(230, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 5;
        //               meff.MagExplosionBase := 250;
        meff.ImgLib := FrmMain.WDragonImg;
        meff.NextFrameTime := 80;
      end else if magnumb = MAGIC_DUN_THUNDER then begin
        meff := TThuderEffectEx.Create(400, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 5;
        meff.ImgLib := FrmMain.WDragonImg;
        meff.NextFrameTime := 100;
      end else if magnumb = MAGIC_ROCK_PULL then begin
        meff := TThuderEffectEx.Create(1410, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 10;
        meff.ImgLib := FrmMain.WMon24Img;
        meff.NextFrameTime := 100;
      end else if magnumb = MAGIC_FOX_THUNDER then begin
        meff := TThuderEffectEx.Create(FOXWIZARDATTACKEFFECTBASE, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 10;
        meff.ImgLib := FrmMain.WMon24Img;
        meff.NextFrameTime := 100;
      end else if magnumb = MAGIC_FOX_BANG then begin
        meff := TThuderEffectEx.Create(790, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 10;
        meff.ImgLib := FrmMain.WMon24Img;
        meff.NextFrameTime := 100;
      end else if magnumb = MAGIC_DUN_FIRE1 then begin
        //      DScreen.AddChatBoardString ('magnumb = MAGIC_DUN_THUNDER', clYellow, clRed);
        meff := TThuderEffectEx.Create(440, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 20;
        meff.ImgLib := FrmMain.WDragonImg;
        meff.NextFrameTime := 90;
      end else if magnumb = MAGIC_DUN_FIRE2 then begin
        meff := TThuderEffectEx.Create(470, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 10;
        meff.ImgLib := FrmMain.WDragonImg;
        meff.NextFrameTime := 90;
      end else if magnumb = MAGIC_DRAGONFIRE then begin
        meff := TThuderEffectEx.Create(200, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 20;
        meff.ImgLib := FrmMain.WDragonImg;
        meff.NextFrameTime := 120;
      end else if magnumb = MAGIC_FIREBURN then begin
        meff := TThuderEffectEx.Create(350, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 35;
        meff.ImgLib := FrmMain.WDragonImg;
        meff.NextFrameTime := 100;
      end else if magnumb = MAGIC_SERPENT_1 then begin
        meff := TThuderEffectEx.Create(1250, sctx, scty, nil, magnumb);
        //target);
        meff.ExplosionFrame := 15;
        meff.ImgLib := FrmMain.WMagic2;
        meff.NextFrameTime := 90;
      end else begin
        meff := TThuderEffect.Create(10, sctx, scty, nil); //target);
        meff.ExplosionFrame := 6;
        meff.ImgLib := FrmMain.WMagic2;
      end;
    end;
    // 2003/03/15 신규무공 추가
    mtFireThunder: begin
      meff := TThuderEffect.Create(140, sctx, scty, nil); //target);
      meff.ExplosionFrame := 10;
      meff.ImgLib := FrmMain.WMagic2;
    end;

    mtLightingThunder: meff :=
        TLightingThunder.Create(970, scx, scy, sctx, scty, target);
    mtExploBujauk: begin
      case magnumb of
        10: begin  //폭살계
          meff := TExploBujaukEffect.Create(1160, magnumb, scx,
            scy, sctx, scty, target);
          meff.MagExplosionBase := 1360;
        end;
        17: begin  //대은신
          meff := TExploBujaukEffect.Create(1160, magnumb, scx,
            scy, sctx, scty, target);
          meff.MagExplosionBase := 1540;
        end;
        49: begin  //맹안술
          meff := TExploBujaukEffect.Create(1160, magnumb, scx,
            scy, sctx, scty, target);
          meff.MagExplosionBase := 1110;
          meff.ExplosionFrame := 10;
          //                  meff.ImgLib := FrmMain.WMagic2;
        end;
      end;
      bofly := True;
    end;
    // 2003/03/04
    mtGroundEffect: begin
      meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
        scty, mtype, Recusion, anitime);
      if meff <> nil then begin
        case magnumb of
          32: begin  //마법진1
            meff.ImgLib := FrmMain.WMon21Img;
            meff.MagExplosionBase := 3580;
            meff.TargetActor := target;
            meff.Light := 3;
            meff.ExplosionFrame := 20;
          end;
          37: begin
            meff.ImgLib := FrmMain.WMon22Img;
            meff.MagExplosionBase := 3520;
            meff.TargetActor := target;
            meff.Light := 5;
            meff.ExplosionFrame := 20;
          end;
        end;
      end;
      //          bofly := TRUE;
    end;
    mtBujaukGroundEffect: begin
      meff := TBujaukGroundEffect.Create(1160, magnumb, scx, scy, sctx, scty);
      case magnumb of
        11: meff.ExplosionFrame := 16; //항마진법
        12: meff.ExplosionFrame := 16; //대지원호
        46: meff.ExplosionFrame := 24; //저주술
        55: begin
            meff.ExplosionFrame := 20; //PoisonCloud
            PlaySound(10553);
            meff.TargetActor := nil;
            end;
      end;
      bofly := True;
    end;
    mtKyulKai: begin
      meff := nil; //TKyulKai.Create (1380, scx, scy, sctx, scty);
    end;
  end;
  if meff = nil then
    exit;

  meff.TargetRx := tx;
  meff.TargetRy := ty;
  if meff.TargetActor <> nil then begin
    meff.TargetRx := TActor(meff.TargetActor).XX;
    meff.TargetRy := TActor(meff.TargetActor).YY;
  end;
  meff.MagOwner := aowner;
  EffectList.Add(meff);
end;

procedure TPlayScene.DelMagic(magid: integer);
var
  i: integer;
begin
  for i := 0 to EffectList.Count - 1 do begin
    if TMagicEff(EffectList[i]).ServerMagicId = magid then begin
      TMagicEff(EffectList[i]).Free;
      EffectList.Delete(i);
      break;
    end;
  end;
end;

//cx, cy, tx, ty : 맵의 좌표
function TPlayScene.NewFlyObject(aowner: TActor; cx, cy, tx, ty, targetcode: integer;
  mtype: TMagicType): TMagicEff;
var
  i, scx, scy, sctx, scty: integer;
  meff: TMagicEff;
begin
  ScreenXYfromMCXY(cx, cy, scx, scy);
  ScreenXYfromMCXY(tx, ty, sctx, scty);
  case mtype of
    mtFlyArrow: meff := TFlyingArrow.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    mtFlySpikes: meff := TFlyingArrow.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    mtFlyBug: meff   := TFlyingBug.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    mtFlySoulBang: meff   := TFlyingSoulBang.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    mtRockPull: meff   := TRockPull.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    mtFlyCurse: meff   := TFlyingCurse.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    mtFireBall: meff := TFlyingFireBall.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    else
      meff := TFlyingAxe.Create(1, 1, scx, scy, sctx, scty, mtype, True, 0);
  end;
  meff.TargetRx    := tx;
  meff.TargetRy    := ty;
  meff.TargetActor := FindActor(targetcode);
  meff.MagOwner    := aowner;
  FlyList.Add(meff);
  Result := meff;
end;

 //전기쏘는 좀비의 마법처럼 길게 나가는 마법
 //effnum: 각 번호마다 Base가 다 다르다.
{function  NewStaticMagic (aowner: TActor; tx, ty, targetcode, effnum: integer);
var
   i, scx, scy, sctx, scty, effbase: integer;
   meff: TMagicEff;
begin
   ScreenXYfromMCXY (cx, cy, scx, scy);
   ScreenXYfromMCXY (tx, ty, sctx, scty);
   case effnum of
      1: effbase := 340;   //좀비의 라이트닝의 시작 위치
      else exit;
   end;

   meff := TLightingEffect.Create (effbase, 1, 1, scx, scy, sctx, scty, mtype, TRUE, 0);
   meff.TargetRx := tx;
   meff.TargetRy := ty;
   meff.TargetActor := FindActor (targetcode);
   meff.MagOwner := aowner;
   FlyList.Add (meff);
   Result := meff;
end;  }

{-------------------------------------------------------}

//맵 좌표계로 셀 중앙의 스크린 좌표를 얻어냄
{procedure TPlayScene.ScreenXYfromMCXY (cx, cy: integer; var sx, sy: integer);
begin
   if Myself = nil then exit;
   sx := -UNITX*2 - Myself.ShiftX + AAX + 14 + (cx - Map.ClientRect.Left) * UNITX + UNITX div 2;
   sy := -UNITY*3 - Myself.ShiftY + (cy - Map.ClientRect.Top) * UNITY + UNITY div 2;
end; }

procedure TPlayScene.ScreenXYfromMCXY(cx, cy: integer; var sx, sy: integer);
begin
  if Myself = nil then
    exit;
  sx := (cx - Myself.Rx) * UNITX + 364 + UNITX div 2 - Myself.ShiftX;
  sy := (cy - Myself.Ry) * UNITY + 192 + UNITY div 2 - Myself.ShiftY;
end;

//스크린의 mx, my로 맵의 ccx, ccy좌표를 얻어냄
procedure TPlayScene.CXYfromMouseXY(mx, my: integer; var ccx, ccy: integer);
begin
  if Myself = nil then
    exit;
  ccx := UpInt((mx - 364 + Myself.ShiftX - UNITX) / UNITX) + Myself.Rx;
  ccy := UpInt((my - 192 + Myself.ShiftY - UNITY) / UNITY) + Myself.Ry;
end;

procedure TPlayScene.CXYfromMouseXYMid(mx, my: integer; var ccx, ccy: integer);
// 마법을 좀더 정확한 위치에 뿌리기 위해..
begin
  if Myself = nil then
    exit;
  ccx := UpInt((mx - 364 + Myself.ShiftX - UNITX) / UNITX) + Myself.Rx;
  ccy := UpInt((my - (192 - 20) + Myself.ShiftY - UNITY) / UNITY) + Myself.Ry;

end;

//화면좌표로 캐릭터, 픽셀 단위로 선택..
function TPlayScene.GetCharacter(x, y, wantsel: integer; var nowsel: integer;
  liveonly: boolean): TActor;
var
  k, i, ccx, ccy, dx, dy: integer;
  a: TActor;
begin
  Result := nil;
  nowsel := -1;
  CXYfromMouseXY(x, y, ccx, ccy);
  for k := ccy + 8 downto ccy - 1 do begin
    for i := ActorList.Count - 1 downto 0 do
      if TActor(ActorList[i]) <> Myself then begin
        a := TActor(ActorList[i]);
        if (not liveonly or not a.Death) and (a.BoHoldPlace) and (a.Visible) then
        begin
          if a.YY = k then begin
            //더 넓은 범위로 선택되게
            dx := (a.Rx - Map.ClientRect.Left) * UNITX + DefXX + a.px + a.ShiftX;
            dy := (a.Ry - Map.ClientRect.Top - 1) * UNITY + DefYY + a.py + a.ShiftY;
            if a.CheckSelect(x - dx, y - dy) then begin
              Result := a;
              Inc(nowsel);
              if nowsel >= wantsel then
                exit;
            end;
          end;
        end;
      end;
  end;
end;

//마우스가 캐릭터의 근처에만 있어도 선택되도록....
function TPlayScene.GetAttackFocusCharacter(x, y, wantsel: integer;
  var nowsel: integer; liveonly: boolean): TActor;
var
  k, i, ccx, ccy, dx, dy, centx, centy: integer;
  a: TActor;
begin
  Result := GetCharacter(x, y, wantsel, nowsel, liveonly);
  if Result = nil then begin
    nowsel := -1;
    CXYfromMouseXY(x, y, ccx, ccy);
    for k := ccy + 8 downto ccy - 1 do begin
      for i := ActorList.Count - 1 downto 0 do
        if TActor(ActorList[i]) <> Myself then begin
          a := TActor(ActorList[i]);
          if (not liveonly or not a.Death) and (a.BoHoldPlace) and (a.Visible) then
          begin
            if a.YY = k then begin

              dx := (a.Rx - Map.ClientRect.Left) * UNITX + DefXX + a.px + a.ShiftX;
              dy := (a.Ry - Map.ClientRect.Top - 1) * UNITY + DefYY + a.py + a.ShiftY;
              if a.CharWidth > 40 then
                centx := (a.CharWidth - 40) div 2
              else
                centx := 0;
              if a.CharHeight > 70 then
                centy := (a.CharHeight - 70) div 2
              else
                centy := 0;
              if (x - dx >= centx) and (x - dx <= a.CharWidth - centx) and
                (y - dy >= centy) and (y - dy <= a.CharHeight - centy) then begin
                Result := a;
                Inc(nowsel);
                if nowsel >= wantsel then
                  exit;
              end;
            end;
          end;
        end;
    end;
  end;
end;

function TPlayScene.IsSelectMyself(x, y: integer): boolean;
var
  k, i, ccx, ccy, dx, dy: integer;
begin
  Result := False;
  CXYfromMouseXY(x, y, ccx, ccy);
  for k := ccy + 2 downto ccy - 1 do begin
    if Myself.YY = k then begin
      //더 넓은 범위로 선택되게
      dx := (Myself.Rx - Map.ClientRect.Left) * UNITX + DefXX + Myself.px +
        Myself.ShiftX;
      dy := (Myself.Ry - Map.ClientRect.Top - 1) * UNITY + DefYY +
        Myself.py + Myself.ShiftY;
      if Myself.CheckSelect(x - dx, y - dy) then begin
        Result := True;
        exit;
      end;
    end;
  end;
end;

function TPlayScene.GetDropItems(x, y: integer; var inames: string): PTDropItem;
var
  k, i, ccx, ccy, ssx, ssy, dx, dy: integer;
  d: PTDropItem;
  s: TDirectDrawSurface;
  c: byte;
begin
  Result := nil;
  CXYfromMouseXY(x, y, ccx, ccy);
  ScreenXYfromMCXY(ccx, ccy, ssx, ssy);
  dx     := x - ssx;
  dy     := y - ssy;
  inames := '';
  for i := 0 to DropedItemList.Count - 1 do begin
    d := PTDropItem(DropedItemList[i]);
    if (d.X = ccx) and (d.Y = ccy) then begin
      if d.BoDeco then
        s := FrmMain.WDecoImg.Images[d.Looks]
      else
        s := FrmMain.WDnItem.Images[d.Looks];
      if s = nil then
        continue;
      dx := (x - ssx) + (s.Width div 2) - 3;
      dy := (y - ssy) + (s.Height div 2);
      c  := s.Pixels[dx, dy];
      if (c <> 0) or d.BoDeco then begin
        //장원꾸미기 Deco아이템인 경우 이름 뜨는 범위 확장
        if Result = nil then
          Result := d;
        inames := inames + d.Name + '\';
        //break;
      end;
    end;
  end;
end;

procedure TPlayScene.DropItemsShow; //@@@@
var
  i, k, mx, my, HintX, HintY, HintWidth, HintHeight: integer;
  d:   PTDropItem;
  dds: TDirectDrawSurface;
begin

  dds := FrmMain.WProgUse.Images[394];
  for i := 0 to DropedItemList.Count - 1 do begin
    d := PTDropItem(DropedItemList[i]);
    if d <> nil then begin
      ScreenXYfromMCXY(d.X, d.Y, mx, my);
      if dds <> nil then begin
        HintWidth := FrmMain.Canvas.TextWidth(d.Name) + 4 * 2;
        if HintWidth > dds.Width then
          HintWidth := dds.Width;
        HintHeight := (FrmMain.Canvas.TextHeight('A') + 1) + 3 * 2;
        DrawBlendEx(FrmMain.DxDraw1.Surface, mx + 2 - ((Length(d.Name) div 2) * 6),
          my - 26 - 3, dds, 0, 0, HintWidth, HintHeight, 0);
      end;
    end;
  end;

  SetBkMode(FrmMain.DxDraw1.Surface.Canvas.Handle, TRANSPARENT);
  FrmMain.DxDraw1.Surface.Canvas.Font.Color := clWhite;

  for k := 0 to DropedItemList.Count - 1 do begin
    d := PTDropItem(DropedItemList[k]);
    if d <> nil then begin
      ScreenXYfromMCXY(d.X, d.Y, mx, my);
      FrmMain.DxDraw1.Surface.Canvas.TextOut(mx + 2 - ((Length(d.Name) div 2) * 6) + 4,
        my - 26, d.Name);
    end;
  end;
  FrmMain.DxDraw1.Surface.Canvas.Release;
end;

function TPlayScene.CanRun(sx, sy, ex, ey: integer): boolean;
var
  ndir, rx, ry: integer;
begin
  ndir := GetNextDirection(sx, sy, ex, ey);
  rx   := sx;
  ry   := sy;
  GetNextPosXY(ndir, rx, ry);
  if CanWalk(rx, ry) and CanWalk(ex, ey) then
    Result := True
  else
    Result := False;
end;

function TPlayScene.CanWalk(mx, my: integer): boolean;
begin
  Result := False;
  if Map.CanMove(mx, my) then
    Result := not CrashMan(mx, my);
end;

function TPlayScene.CrashMan(mx, my: integer): boolean;
var
  i: integer;
  a: TActor;
begin
  Result := False;
  for i := 0 to ActorList.Count - 1 do begin
    a := TActor(ActorList[i]);
    if (a.Visible) and (a.BoHoldPlace) and (not a.Death) and
      (a.XX = mx) and (a.YY = my) then begin
      Result := True;
      break;
    end;
  end;
end;

function TPlayScene.CanFly(mx, my: integer): boolean;
begin
  Result := Map.CanFly(mx, my);
end;


{------------------------ Actor ------------------------}

function TPlayScene.FindActor(id: integer): TActor;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ActorList.Count - 1 do begin
    if TActor(ActorList[i]).RecogId = id then begin
      Result := TActor(ActorList[i]);
      break;
    end;
  end;
end;

function TPlayScene.FindActorXY(x, y: integer): TActor;  //맵 좌표로 actor 얻음
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ActorList.Count - 1 do begin
    if (TActor(ActorList[i]).XX = x) and (TActor(ActorList[i]).YY = y) then begin
      Result := TActor(ActorList[i]);
      if not Result.Death and Result.Visible and Result.BoHoldPlace then
        break;
    end;
  end;
end;

function TPlayScene.IsValidActor(actor: TActor): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to ActorList.Count - 1 do begin
    if TActor(ActorList[i]) = actor then begin
      Result := True;
      break;
    end;
  end;
end;

function TPlayScene.NewActor(chrid: integer; cx: word; //x
  cy: word; //y
  cdir: word; cfeature: integer; //race, hair, dress, weapon
  cstate: integer): TActor;
var
  i:     integer;
  actor: TActor;
  pm:    PTMonsterAction;
begin
  Result := nil;
  for i := 0 to ActorList.Count - 1 do
    if TActor(ActorList[i]).RecogId = chrid then begin
      Result := TActor(ActorList[i]);
      exit; //이미 있음
    end;
  if IsChangingFace(chrid) then
    exit;  //변신중...

  case RACEfeature(cfeature) of
    0: actor := THumActor.Create;
    9: actor := TSoccerBall.Create;  //축구공

    13: actor := TKillingHerb.Create;
    14: actor := TSkeletonOma.Create;
    15: actor := TDualAxeOma.Create;

    16: actor := TGasKuDeGi.Create;  //가스쏘는 구데기

    17: actor := TCatMon.Create;   //괭이, 우면귀(우면귀,창든우면귀,철퇴우면귀)
    18: actor := THuSuABi.Create;
    19: actor := TCatMon.Create;   //우면귀(우면귀,창든우면귀,철퇴든우면귀)

    20: actor := TFireCowFaceMon.Create;
    21: actor := TCowFaceKing.Create;
    22: actor := TDualAxeOma.Create;     //침쏘는 다크
    23: actor := TWhiteSkeleton.Create;  //소환백골

    24: actor := TSuperiorGuard.Create;  //멋있는 경비병

    30: actor := TCatMon.Create;      //날개짓
    31: actor := TCatMon.Create;      //날개짓
    32: actor := TScorpionMon.Create; //공격이 2동작

    33: actor     := TCentipedeKingMon.Create;  //지네왕, 촉룡신
    34, 97: actor := TBigHeartMon.Create;       //적월마, 심장, 밤나무, 보물함
    35: actor     := TSpiderHouseMon.Create;    //폭안거미
    36: actor     := TExplosionSpider.Create;   //폭주
    37: actor     := TFlyingSpider.Create;      //비독거미

    40: actor := TZombiLighting.Create;  //좀비 1 (전기 마법 좀비)
    41: actor := TZombiDigOut.Create;    //땅파고 나오는 좀비
    42: actor := TZombiZilkin.Create;

    43: actor := TBeeQueen.Create;

    45: actor := TArcherMon.Create;
    47: actor := TSculptureMon.Create;  //염소장군, 염소대장
    48: actor := TSculptureMon.Create;
    49: actor := TSculptureKingMon.Create;  //주마왕

    50: actor := TNpcActor.Create;

    52, 53: actor := TGasKuDeGi.Create;  //가스쏘는 쐐기나방, 둥
    54: actor     := TSmallElfMonster.Create;
    55: actor     := TWarriorElfMonster.Create;

    60: actor     := TElectronicScolpionMon.Create;   //뢰혈사
    61: actor     := TBossPigMon.Create;              //왕돈
    62: actor     := TKingOfSculpureKingMon.Create;   //주마본왕(왕중왕)
    // 2003/02/11 신규 몹 추가 .. 해골본왕, 부식귀
    63: actor     := TSkeletonKingMon.Create;
    64: actor     := TGasKuDeGi.Create;
    65: actor     := TSamuraiMon.Create;
    66: actor     := TSkeletonSoldierMon.Create;
    67: actor     := TSkeletonSoldierMon.Create;
    68: actor     := TSkeletonSoldierMon.Create;
    69: actor     := TSkeletonArcherMon.Create;
    70: actor     := TBanyaGuardMon.Create;           //반야우사
    71: actor     := TBanyaGuardMon.Create;           //반야좌사
    72: actor     := TBanyaGuardMon.Create;           //사우천왕
    // 2003/07/15 과거비천 몹 추가
    73: actor     := TPBOMA1Mon.Create;               //비익오마
    74: actor     := TCatMon.Create;                  //오마검병/참병/중위병/친위병
    75: actor     := TStoneMonster.Create;            //마계석1
    76: actor     := TSuperiorGuard.Create;           //과거비천경비
    77: actor     := TStoneMonster.Create;            //마계석2
    78: actor     := TBanyaGuardMon.Create;           //파황마신
    79: actor     := TPBOMA6Mon.Create;               //오마석궁병
    80, 96: actor := TMineMon.Create;             //도깨비불

    81: actor := TAngel.Create;          //월령(천녀)
    83: actor := TFireDragon.Create;     //파천마룡
    84, 85, 86, 87, 88, 89: actor := TDragonStatue.Create; //용석상
    90: actor := TDragonBody.Create;              //파천마룡 투명몸
    91: actor := TBanyaGuardMon.Create;  //설인대충
    92: actor := TJumaThunderMon.Create; //주마격뢰장  TSculptureMon 상속받음
    93: actor := TBanyaGuardMon.Create;  //환영한호
    94: actor := TBanyaGuardMon.Create;  //거미(신석독마주)
    95: actor := TGasKuDeGi.Create;      //이벤트나방 96:꽃눈 97:보물함

    98: actor := TWallStructure.Create;
    99: actor := TCastleDoor.Create;  //성문...

    100: actor := TBanyaGuardMon.Create;   //황금이무기
    101: actor := TCatMon.Create;   //백사(청영사)

    102: actor := TFoxWarrior.Create;   //BlackFoxman
    103: actor := TFoxWizard.Create;    //RedFoxman
    104: actor := TFoxTao.Create;   //WhiteFoxman
    105: actor := TTrapRock.Create;    //TrapRock
    106: actor := TGuardRock.Create;    //GuardianRock
    107, 108: actor := TElements.Create;   //ThunderElement, CloudElement
    109: actor := TKingElement.Create;    //GreatFoxSpirit
    110, 111: actor := TBigKekTal.Create;  //Big KekTals

    else
      actor := TActor.Create;
  end;

  with actor do begin
    RecogId := chrid;
    XX      := cx;
    YY      := cy;
    Rx      := XX;
    Ry      := YY;
    Dir     := cdir;
    Feature := cfeature;
    Race    := RACEfeature(cfeature);         //changefeature가 있을때만
    hair    := HAIRfeature(cfeature);         //변경된다.
    dress   := DRESSfeature(cfeature);
    weapon  := WEAPONfeature(cfeature);
    Appearance := APPRfeature(cfeature);

    pm := RaceByPm(Race, Appearance);
    if pm <> nil then
      WalkFrameDelay := pm.ActWalk.ftime;

    if Race = 0 then begin
      Sex := dress mod 2;   //0:남자 1:여자
    end else
      Sex := 0;
    state := cstate;
    Saying[0] := '';
  end;
  ActorList.Add(actor);
  Result := actor;
end;

procedure TPlayScene.ActorDied(actor: TObject);
var
  i:    integer;
  flag: boolean;
begin
  for i := 0 to ActorList.Count - 1 do
    if ActorList[i] = actor then begin
      ActorList.Delete(i);
      break;
    end;
  flag := False;
  for i := 0 to ActorList.Count - 1 do
    if not TActor(ActorList[i]).Death then begin
      ActorList.Insert(i, actor);
      flag := True;
      break;
    end;
  if not flag then
    ActorList.Add(actor);
end;

procedure TPlayScene.SetActorDrawLevel(actor: TObject; level: integer);
var
  i: integer;
begin
  if level = 0 then begin  //맨 처음에 그리도록 함
    for i := 0 to ActorList.Count - 1 do
      if ActorList[i] = actor then begin
        ActorList.Delete(i);
        ActorList.Insert(0, actor);
        break;
      end;
  end;
end;

procedure TPlayScene.ClearActors;  //로그아웃만 사용
var
  i: integer;
begin
  for i := 0 to ActorList.Count - 1 do
    TActor(ActorList[i]).Free;
  ActorList.Clear;
  Myself      := nil;
  TargetCret  := nil;
  FocusCret   := nil;
  MagicTarget := nil;

  //마법도 초기화 해야함.
  for i := 0 to EffectList.Count - 1 do
    TMagicEff(EffectList[i]).Free;
  EffectList.Clear;
end;

function TPlayScene.DeleteActor(id: integer): TActor;
var
  i: integer;
begin
  Result := nil;
  i      := 0;
  while True do begin
    if i >= ActorList.Count then
      break;
    if TActor(ActorList[i]).RecogId = id then begin
      if TargetCret = TActor(ActorList[i]) then
        TargetCret := nil;
      if FocusCret = TActor(ActorList[i]) then
        FocusCret := nil;
      if MagicTarget = TActor(ActorList[i]) then
        MagicTarget := nil;
      TActor(ActorList[i]).DeleteTime := GetTickCount;
      FreeActorList.Add(ActorList[i]);
      //TActor(ActorList[i]).Free;
      ActorList.Delete(i);
    end else
      Inc(i);
  end;
end;

procedure TPlayScene.DelActor(actor: TObject);
var
  i: integer;
begin
  for i := 0 to ActorList.Count - 1 do
    if ActorList[i] = actor then begin
      TActor(ActorList[i]).DeleteTime := GetTickCount;
      FreeActorList.Add(ActorList[i]);
      ActorList.Delete(i);
      break;
    end;
end;

function TPlayScene.ButchAnimal(x, y: integer): TActor;
var
  i: integer;
  a: TActor;
begin
  Result := nil;
  for i := 0 to ActorList.Count - 1 do begin
    a := TActor(ActorList[i]);
    if a.Death and (a.Race <> 0) then begin //동물 시체
      if (abs(a.XX - x) <= 1) and (abs(a.YY - y) <= 1) then begin
        Result := a;
        break;
      end;
    end;
  end;
end;


{------------------------- Msg -------------------------}


 //메세지를 버퍼링하는 이유는 ?
 //캐릭터의 메세지 버퍼에 메세지가 남아 있는 상태에서
 //다음 메세지가 처리되면 안되기 때문임.
procedure TPlayScene.SendMsg(ident, chrid, x, y, cdir, feature, state, param: integer;
  str: string);
var
  actor: TActor;
  meff:  TMagicEff;
begin
  case ident of
    SM_TEST: begin
      actor  := NewActor(111, 254{x}, 214{y}, 0, 0, 0);
      Myself := THumActor(actor);
      Map.LoadMap('0', Myself.XX, Myself.YY);
    end;
    SM_CHANGEMAP,
    SM_NEWMAP: begin
      Map.LoadMap(str, x, y);
      DarkLevel := cdir;
      //DayBright_fake := msg.Param;

      DarkLevel_fake   := cdir;
      pDarkLevelCheck^ := cdir;

      if DarkLevel = 0 then
        ViewFog := False
      else
        ViewFog := True;
      if (ident = SM_NEWMAP) and (Myself <> nil) then begin
        //서버이동 할때 부드럽게 맵이동을 하게 만들려고
        Myself.XX := x;
        Myself.YY := y;
        Myself.RX := x;
        Myself.RY := y;
        DelActor(Myself);
      end;

      //BoViewMiniMap := FALSE;
      if BoWantMiniMap then begin
        if ViewMiniMapStyle > 0 then
          PrevVMMStyle := ViewMiniMapStyle;
        ViewMiniMapStyle := 0;
        FrmMain.SendWantMiniMap;
      end;

    end;
    SM_LOGON: begin
      actor := FindActor(chrid);
      if actor = nil then begin
        actor := NewActor(chrid, x, y, Lobyte(cdir), feature, state);
        actor.ChrLight := Hibyte(cdir);
        cdir  := Lobyte(cdir);
        actor.SendMsg(SM_TURN, x, y, cdir, feature, state, '', 0);
      end;
      if Myself <> nil then begin
        Myself := nil;
      end;
      Myself := THumActor(actor);
    end;
    SM_HIDE: begin
      actor := FindActor(chrid);
      if actor <> nil then begin
        if actor.BoDelActionAfterFinished then begin
          //땅으로 사라지는 애니메이션이 끝나면 자동으로 사라짐.
          exit;
        end;
        if actor.WaitForRecogId <> 0 then begin
          //변신중.. 변신이 끝나면 자동으로 사라짐
          exit;
        end;
      end;
      DeleteActor(chrid);
    end;
    else begin
      actor := FindActor(chrid);
      if (ident = SM_TURN) or (ident = SM_RUN) or (ident = SM_WALK) or
        (ident = SM_BACKSTEP) or (ident = SM_DEATH) or
        (ident = SM_SKELETON) or (ident = SM_DIGUP) or (ident = SM_ALIVE) then begin
        if actor = nil then
          actor := NewActor(chrid, x, y, Lobyte(cdir), feature, state);
        if actor <> nil then begin
          actor.ChrLight := Hibyte(cdir);
          cdir := Lobyte(cdir);
          if ident = SM_SKELETON then begin
            actor.Death    := True;
            actor.Skeleton := True;
          end else if ident = SM_ALIVE then begin  //2005/05/11 부활 //####
            actor.Feature := feature;
            actor.FeatureChanged;
            if DarkLevel = 0 then
              ViewFog := False
            else
              ViewFog := True;
            actor.Death := False;
            actor.Skeleton := False;
          end;

        end;
      end;
      if actor = nil then
        exit;
      case ident of
        SM_FEATURECHANGED: begin
          actor.Feature := feature;
          actor.FeatureChanged;
        end;
        SM_CHARSTATUSCHANGED: begin
          actor.State    := Feature;
          actor.HitSpeed := state;
          if actor = Myself then begin
            ChangeWalkHitValues(Myself.Abil.Level
              , Myself.HitSpeed
              , Myself.Abil.Weight + Myself.Abil.MaxWeight +
              Myself.Abil.WearWeight + Myself.Abil.MaxWearWeight +
              Myself.Abil.HandWeight + Myself.Abil.MaxHandWeight
              , RUN_STRUCK_DELAY
              );
            //                        if Myself.State and $10000000 <> 0 then begin        //POISON_STUN
            //                           DizzyDelayStart := GetTickCount;
            //                           DizzyDelayTime  := 1500; //딜레이
            //                        end;
          end;
          // 2003/07/15 스턴에 대한 상태이상 이펙트 추가
          if Feature and $10000000 <> 0 then begin        //POISON_STUN
            meff := TCharEffect.Create(380, 6, actor);
            meff.NextFrameTime := 100;
            meff.ImgLib := FrmMain.WMagic2;
            meff.RepeatUntil := GetTickCount + 2000;
            EffectList.Add(meff);
          end;
        end;
        else begin
          if ident = SM_TURN then begin
            if str <> '' then
              actor.UserName := str;
          end;
          if ident = SM_WALK then begin
            if param > 0 then
              actor.WalkFrameDelay := param;
          end;
          actor.SendMsg(ident, x, y, cdir, feature, state, '', 0);
        end;
      end;
    end;
  end;

end;


end.
