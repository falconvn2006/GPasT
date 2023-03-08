unit HerbActor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grobal2, DxDraws, CliUtil, magiceff, Actor, SoundUtil, clEvent, ExtCtrls, ClFunc;

const
  BEEQUEENBASE = 600;
  DOORDEATHEFFECTBASE = 120;
  WALLLEFTBROKENEFFECTBASE = 224;
  WALLRIGHTBROKENEFFECTBASE = 240;

type
  TDoorState = (dsOpen, dsClose, dsBroken);

  TKillingHerb = class(TActor)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: boolean): integer; override;
  end;

  TMineMon = class(TKillingHerb)
  private
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: boolean): integer; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
      blend: boolean; WingDraw: boolean); override;
  end;

  TBeeQueen = class(TActor)
  private
  public
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: boolean): integer; override;
  end;

  TCentipedeKingMon = class(TKillingHerb)
  private
    AttackEffectSurface: TDirectDrawSurface;
    BoReadyEffect: boolean;
    ax, ay: integer;
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure LoadEffectSurface;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
    procedure Run; override;
  end;

  TBigHeartMon = class(TKillingHerb)
  private
  public
    procedure CalcActorFrame; override;
  end;

  TSpiderHouseMon = class(TKillingHerb)
  public
    procedure CalcActorFrame; override;
  end;


  TCastleDoor = class(TActor)
  private
    EffectSurface: TDirectDrawSurface;
    ax, ay: integer;
    oldunitx, oldunity: integer;
    procedure ApplyDoorState(dstate: TDoorState);
  public
    BoDoorOpen: boolean;
    constructor Create; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    function GetDefaultFrame(wmode: boolean): integer; override;
    procedure ActionEnded; override;
    procedure Run; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
      blend: boolean; WingDraw: boolean); override;
  end;

  TWallStructure = class(TActor)
  private
    EffectSurface:  TDirectDrawSurface;
    BrokenSurface:  TDirectDrawSurface;
    ax, ay, bx, by: integer;
    deathframe:     integer;
    bomarkpos:      boolean;  //못가게 막고 있는지
  public
    constructor Create; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    function GetDefaultFrame(wmode: boolean): integer; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
      blend: boolean; WingDraw: boolean); override;
    procedure Run; override;
  end;

  TSoccerBall = class(TActor)
  public

  end;

  TDragonBody = class(TKillingHerb) // 화룡몸 FireDragon
  private
  public
    procedure LoadSurface; override;
    procedure CalcActorFrame; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
      blend: boolean; WingDraw: boolean); override;
  end;



implementation

uses
  ClMain, Wil;


{============================== TKillingHerb =============================}

//        식인초

{--------------------------}


constructor TKillingHerb.Create;
begin
  inherited Create;
end;

destructor TKillingHerb.Destroy;
begin
  inherited Destroy;
end;

procedure TKillingHerb.CalcActorFrame;
var
  pm: PTMonsterAction;
  haircount: integer;
begin
  BoUseMagic   := False;
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_TURN: //방향이 없음...
    begin
      startframe    := pm.ActStand.start;
      // + Dir * (pm.ActStand.frame + pm.ActStand.skip);
      endframe      := startframe + pm.ActStand.frame - 1;
      frametime     := pm.ActStand.ftime;
      starttime     := GetTickCount;
      defframecount := pm.ActStand.frame;
      Shift(Dir, 0, 0, 1);
    end;
    SM_DIGUP: //걷기 없음, SM_DIGUP, 방향 없음.
    begin
      startframe := pm.ActWalk.start;
      // + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
      endframe   := startframe + pm.ActWalk.frame - 1;
      frametime  := pm.ActWalk.ftime;
      starttime  := GetTickCount;
      maxtick    := pm.ActWalk.UseTick;
      curtick    := 0;
      //WarMode := FALSE;
      movestep   := 1;
      Shift(Dir, 0, 0, 1); //movestep, 0, endframe-startframe+1);
    end;
    SM_HIT: begin
      startframe  := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe    := startframe + pm.ActAttack.frame - 1;
      frametime   := pm.ActAttack.ftime;
      starttime   := GetTickCount;
      //WarMode := TRUE;
      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
    end;
    SM_STRUCK: begin
      startframe := pm.ActStruck.start + Dir *
        (pm.ActStruck.frame + pm.ActStruck.skip);
      endframe   := startframe + pm.ActStruck.frame - 1;
      frametime  := struckframetime; //pm.ActStruck.ftime;
      starttime  := GetTickCount;
    end;
    SM_DEATH: begin
      startframe := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      startframe := endframe;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;
    end;
    SM_NOWDEATH: begin
      startframe := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;
    end;
    SM_DIGDOWN: begin
      startframe := pm.ActDeath.start;
      endframe   := startframe + pm.ActDeath.frame - 1;
      frametime  := pm.ActDeath.ftime;
      starttime  := GetTickCount;
      BoDelActionAfterFinished := True;  //이동작이 끝나면 액터 지음
    end;
  end;
end;


function TKillingHerb.GetDefaultFrame(wmode: boolean): integer;
var
  cf, dr: integer;
  pm:     PTMonsterAction;
begin
  Result := 0;
  pm     := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  if Death then begin
    if Skeleton then
      Result := pm.ActDeath.start
    else
      Result := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip) +
        (pm.ActDie.frame - 1);
  end else begin
    defframecount := pm.ActStand.frame;
    if currentdefframe < 0 then
      cf := 0
    else if currentdefframe >= pm.ActStand.frame then
      cf := 0
    else
      cf := currentdefframe;
    Result := pm.ActStand.start + cf; //방향이 없음..
  end;
end;


// 행운의지뢰  =================================================================
constructor TMineMon.Create;
begin
  inherited Create;
end;

destructor TMineMon.Destroy;
begin
  inherited Destroy;
end;

procedure TMineMon.CalcActorFrame;
var
  pm: PTMonsterAction;
  haircount: integer;
begin
  Dir := 0; //####3 방향 없음
  BoUseMagic := False;
  currentframe := -1;
  BoUseEffect := True;
  BodyOffset := GetOffset(Appearance);
  pm  := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_TURN: //방향이 없음...
    begin
      startframe    := pm.ActStand.start;
      // + Dir * (pm.ActStand.frame + pm.ActStand.skip);
      endframe      := startframe + pm.ActStand.frame - 1;
      frametime     := pm.ActStand.ftime;
      starttime     := GetTickCount;
      defframecount := pm.ActStand.frame;
      Shift(Dir, 0, 0, 1);
    end;
    SM_DIGUP: //걷기 없음, SM_DIGUP, 방향 없음.
    begin
      startframe := pm.ActWalk.start;
      // + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
      endframe   := startframe + pm.ActWalk.frame - 1;
      frametime  := pm.ActWalk.ftime;
      starttime  := GetTickCount;
      maxtick    := pm.ActWalk.UseTick;
      curtick    := 0;
      //WarMode := FALSE;
      movestep   := 1;
      Shift(Dir, 0, 0, 1); //movestep, 0, endframe-startframe+1);
    end;
    SM_HIT: begin
      startframe    := pm.ActStand.start;
      // + Dir * (pm.ActStand.frame + pm.ActStand.skip);
      endframe      := startframe + pm.ActStand.frame - 1;
      frametime     := pm.ActStand.ftime;
      starttime     := GetTickCount;
      defframecount := pm.ActStand.frame;
      Shift(Dir, 0, 0, 1);
    end;
    SM_STRUCK: begin
      startframe    := pm.ActStand.start;
      // + Dir * (pm.ActStand.frame + pm.ActStand.skip);
      endframe      := startframe + pm.ActStand.frame - 1;
      frametime     := pm.ActStand.ftime;
      starttime     := GetTickCount;
      defframecount := pm.ActStand.frame;
      Shift(Dir, 0, 0, 1);
    end;
    SM_DEATH: begin
      startframe := pm.ActDie.start;//+ (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      startframe := endframe;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;
    end;
    SM_NOWDEATH: begin
      startframe := pm.ActDie.start;//+ (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;
    end;
    SM_DIGDOWN: begin
      startframe := pm.ActDeath.start;
      endframe   := startframe + pm.ActDeath.frame - 1;
      frametime  := pm.ActDeath.ftime;
      starttime  := GetTickCount;
      BoDelActionAfterFinished := True;  //이동작이 끝나면 액터 지음
    end;
  end;
end;


function TMineMon.GetDefaultFrame(wmode: boolean): integer;
begin
  Result := inherited GetDefaultFrame(wmode);

end;

procedure TMineMon.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend: boolean; WingDraw: boolean);

begin
  if not (Dir in [0..7]) then
    exit;
  if GetTickCount - loadsurfacetime > 60 * 1000 then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
    //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
  end;

  if BodySurface <> nil then begin
    Drawblend(dsurface, dx + px + ShiftX, dy + py + ShiftY, BodySurface, 1);
  end;

end;


 {----------------------------------------------------------------------}
 //비막원충


procedure TBeeQueen.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  BoUseMagic   := False;
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_TURN: //방향이 없음...
    begin
      startframe    := pm.ActStand.start;
      // + Dir * (pm.ActStand.frame + pm.ActStand.skip);
      endframe      := startframe + pm.ActStand.frame - 1;
      frametime     := pm.ActStand.ftime;
      starttime     := GetTickCount;
      defframecount := pm.ActStand.frame;
      Shift(Dir, 0, 0, 1);
    end;
    SM_HIT: begin
      startframe  := pm.ActAttack.start;
      // + Dir * (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe    := startframe + pm.ActAttack.frame - 1;
      frametime   := pm.ActAttack.ftime;
      starttime   := GetTickCount;
      //WarMode := TRUE;
      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
    end;
    SM_STRUCK: begin
      startframe := pm.ActStruck.start;
      // + Dir * (pm.ActStruck.frame + pm.ActStruck.skip);
      endframe   := startframe + pm.ActStruck.frame - 1;
      frametime  := struckframetime; //pm.ActStruck.ftime;
      starttime  := GetTickCount;
    end;
    SM_DEATH: begin
      startframe := pm.ActDie.start; // + Dir * (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      startframe := endframe;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;
    end;
    SM_NOWDEATH: begin
      startframe := pm.ActDie.start; // + Dir * (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;
    end;
  end;
end;

function TBeeQueen.GetDefaultFrame(wmode: boolean): integer;
var
  pm: PTMonsterAction;
  cf: integer;
begin
  Result := 0;
  pm     := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  if Death then begin
    Result := pm.ActDie.start + (pm.ActDie.frame - 1);
  end else begin
    defframecount := pm.ActStand.frame;
    if currentdefframe < 0 then
      cf := 0
    else if currentdefframe >= pm.ActStand.frame then
      cf := 0
    else
      cf := currentdefframe;
    Result := pm.ActStand.start + cf; //방향이 없음..
  end;
end;


 {----------------------------------------------------------------------}
 //지네왕, 촉룡신


procedure TCentipedeKingMon.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  BoUseMagic    := False;
  BoUseEffect   := False;
  BoReadyEffect := False;
  currentframe  := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_TURN: //방향이 없음...
    begin
      Dir := 0;
      inherited CalcActorFrame;
    end;
    SM_HIT:   //원거리공격
    begin
      //case Dir of
      //   7, 6: Dir := 0;
      //   0, 1, 2, 5: Dir := 1;
      //   else Dir := 2;
      //end;
      Dir := 0;
      //inherited CalcActorFrame;

      startframe := pm.ActCritical.start + Dir *
        (pm.ActCritical.frame + pm.ActCritical.skip);
      endframe   := startframe + pm.ActCritical.frame - 1;
      frametime  := pm.ActCritical.ftime;
      starttime  := GetTickCount;

      BoReadyEffect := True;
      //BoUseEffect := TRUE;
      //firedir := Dir;
      effectframe   := 0; //startframe;
      effectstart   := 0; //startframe;
      effectend     := effectstart + 9;
      //effectstarttime := GetTickCount;
      effectframetime := 50; //frametime;

      Shift(Dir, 0, 0, 1);
    end;
    //SM_SPITPOISON:
    //   begin
    //   end;
    SM_DIGDOWN: begin
      startframe := pm.ActDeath.start;
      endframe   := startframe + pm.ActDeath.frame - 1;
      frametime  := pm.ActDeath.ftime;
      starttime  := GetTickCount;
      BoDelActionAfterFinished := True;  //이 동작이 끝나면 액터 지음
    end;
    else begin
      Dir := 0;
      inherited CalcActorFrame;
    end;
  end;
end;

procedure TCentipedeKingMon.LoadSurface;
begin
  inherited LoadSurface;
  LoadEffectSurface;
end;

procedure TCentipedeKingMon.LoadEffectSurface;
begin
  if BoUseEffect then
    AttackEffectSurface := FrmMain.WMon15Img.GetCachedImage(
      100 + effectframe - effectstart, ax, ay);
end;

procedure TCentipedeKingMon.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
var
  idx:  integer;
  d:    TDirectDrawSurface;
  ceff: TColorEffect;
begin
  if BoUseEffect then
    if AttackEffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        AttackEffectSurface, 1);
    end;
end;

procedure TCentipedeKingMon.Run;
var
  effectframetimetime, frametimetime: longword;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;
  if BoReadyEffect then begin
    if currentframe - startframe >= 5 then begin
      BoReadyEffect   := False;
      BoUseEffect     := True;
      effectstarttime := GetTickCount;
      effectframe     := 0;
      LoadEffectSurface;
    end;
  end;
  if BoUseEffect then begin
    effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
        LoadEffectSurface;
      end else begin
        BoUseEffect := False;
      end;
    end;
  end;
  inherited Run;
end;




 {----------------------------------------------------------------------}
 //혈거인왕, 심장


procedure TBigHeartMon.CalcActorFrame;
begin
  Dir := 0;
  inherited CalcActorFrame;
end;




 {----------------------------------------------------------------------}
 //폭안거미


procedure TSpiderHouseMon.CalcActorFrame;
begin
  Dir := 0;
  inherited CalcActorFrame;
end;




 {----------------------------------------------------------------------}
 //성벽, 성문

constructor TCastleDoor.Create;
begin
  inherited Create;
  Dir := 0;
  EffectSurface := nil;
  DownDrawLevel := 1;  //1셀 먼저 그림. (사람 머리가 성문 밑으로 들어가는 것을 막음)
end;

procedure TCastleDoor.ApplyDoorState(dstate: TDoorState);
var
  bowalk: boolean;
begin
  Map.MarkCanWalk(XX, YY - 2, True);
  Map.MarkCanWalk(XX + 1, YY - 1, True);
  Map.MarkCanWalk(XX + 1, YY - 2, True);
  if dstate = dsClose then
    bowalk := False
  else
    bowalk := True;

  Map.MarkCanWalk(XX, YY, bowalk);
  Map.MarkCanWalk(XX, YY - 1, bowalk);
  Map.MarkCanWalk(XX, YY - 2, bowalk);
  Map.MarkCanWalk(XX + 1, YY - 1, bowalk);
  Map.MarkCanWalk(XX + 1, YY - 2, bowalk);
  Map.MarkCanWalk(XX - 1, YY - 1, bowalk);
  Map.MarkCanWalk(XX - 1, YY, bowalk);
  Map.MarkCanWalk(XX - 1, YY + 1, bowalk);
  Map.MarkCanWalk(XX - 2, YY, bowalk);

  if dstate = dsOpen then begin
    Map.MarkCanWalk(XX, YY - 2, False);
    Map.MarkCanWalk(XX + 1, YY - 1, False);
    Map.MarkCanWalk(XX + 1, YY - 2, False);
  end;
end;

procedure TCastleDoor.LoadSurface;
var
  mimg: TWMImages;
begin
  inherited LoadSurface;
  mimg := GetMonImg(Appearance);
  if BoUseEffect then
    EffectSurface := mimg.GetCachedImage(DOORDEATHEFFECTBASE +
      (currentframe - startframe), ax, ay);
end;

procedure TCastleDoor.CalcActorFrame;
var
  pm: PTMonsterAction;
  haircount: integer;
begin
  BoUseEffect  := False;
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;
  UserName := ' ';

  case CurrentAction of
    SM_NOWDEATH: begin
      startframe := pm.ActDie.start;
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      ApplyDoorState(dsBroken);  //움직일 수 있게
    end;
    SM_STRUCK: begin
      startframe := pm.ActStruck.start + Dir *
        (pm.ActStruck.frame + pm.ActStruck.skip);
      endframe   := startframe + pm.ActStruck.frame - 1;
      frametime  := pm.ActStand.ftime;
      starttime  := GetTickCount;
      Shift(Dir, 0, 0, 1);
    end;
    SM_DIGUP:  //문 열림
    begin
      startframe := pm.ActAttack.start;
      endframe   := startframe + pm.ActAttack.frame - 1;
      frametime  := pm.ActAttack.ftime;
      starttime  := GetTickCount;
      ApplyDoorState(dsOpen);  //움직일 수 있게
    end;
    SM_DIGDOWN:  //문 닫힘
    begin
      startframe  := pm.ActCritical.start;
      endframe    := startframe + pm.ActCritical.frame - 1;
      frametime   := pm.ActCritical.ftime;
      starttime   := GetTickCount;
      BoDoorOpen  := False;
      BoHoldPlace := True;
      ApplyDoorState(dsClose);  //못움직임
    end;
    SM_DEATH: begin
      startframe    := pm.ActDie.start + pm.ActDie.frame - 1;
      endframe      := startframe;
      defframecount := 0;
      ApplyDoorState(dsBroken);  //움직일 수 있게
    end;
    else  //방향이 없음...
    begin
      if Dir < 3 then begin
        startframe    := pm.ActStand.start + Dir *
          (pm.ActStand.frame + pm.ActStand.skip);
        endframe      := startframe; // + pm.ActStand.frame - 1;
        frametime     := pm.ActStand.ftime;
        starttime     := GetTickCount;
        defframecount := 0; //pm.ActStand.frame;
        Shift(Dir, 0, 0, 1);
        BoDoorOpen  := False;
        BoHoldPlace := True;
        ApplyDoorState(dsClose);  //못움직이게
      end else begin
        startframe    := pm.ActCritical.start;  //열려있는 상태
        endframe      := startframe;
        defframecount := 0;

        BoDoorOpen  := True;
        BoHoldPlace := False;
        ApplyDoorState(dsOpen);  //걸을 수 있음
      end;
    end;
  end;
end;

function TCastleDoor.GetDefaultFrame(wmode: boolean): integer;
var
  pm: PTMonsterAction;
begin
  Result := 0;
  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;
  if Death then begin
    Result := pm.ActDie.start + pm.ActDie.frame - 1;
    DownDrawLevel := 2;
  end else begin
    if BoDoorOpen then begin
      DownDrawLevel := 2;
      Result := pm.ActCritical.start;
      // + Dir * (pm.ActStand.frame + pm.ActStand.skip);
    end else begin
      DownDrawLevel := 1;
      Result := pm.ActStand.start + Dir * (pm.ActStand.frame + pm.ActStand.skip);
    end;
  end;
end;

procedure TCastleDoor.ActionEnded;
begin
  if CurrentAction = SM_DIGUP then begin  //문열림
    BoDoorOpen  := True;
    BoHoldPlace := False;
  end;
  //   if CurrentAction = SM_DIGDOWN then
  //      DefaultMotion;
end;

procedure TCastleDoor.Run;
begin
  if (Map.CurUnitX <> oldunitx) or (Map.CurUnitY <> oldunity) then begin
    if Death then
      ApplyDoorState(dsBroken)
    else if BoDoorOpen then
      ApplyDoorState(dsOpen)
    else
      ApplyDoorState(dsClose);
  end;
  oldunitx := Map.CurUnitX;
  oldunity := Map.CurUnitY;
  inherited Run;
end;

procedure TCastleDoor.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend: boolean; WingDraw: boolean);
begin
  inherited DrawChr(dsurface, dx, dy, blend, WingDraw);
  if BoUseEffect and not blend then
    if EffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        EffectSurface, 1);
    end;
end;



 {----------------------------------------------------------------------}
 //성벽


constructor TWallStructure.Create;
begin
  inherited Create;
  Dir := 0;
  EffectSurface := nil;
  BrokenSurface := nil;
  bomarkpos := False;
  //DownDrawLevel := 1;
end;

procedure TWallStructure.CalcActorFrame;
var
  pm: PTMonsterAction;
  haircount: integer;
begin
  BoUseEffect  := False;
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;
  UserName    := ' ';
  deathframe  := 0;
  BoUseEffect := False;

  case CurrentAction of
    SM_NOWDEATH: begin
      startframe := pm.ActDie.start;
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;
      deathframe := pm.ActStand.start + Dir;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
    end;
    SM_DEATH: begin
      startframe    := pm.ActDie.start + pm.ActDie.frame - 1;
      endframe      := startframe;
      defframecount := 0;
    end;
    SM_DIGUP:  //모습이 변경될때 마다
    begin
      startframe  := pm.ActDie.start;
      endframe    := startframe + pm.ActDie.frame - 1;
      frametime   := pm.ActDie.ftime;
      starttime   := GetTickCount;
      deathframe  := pm.ActStand.start + Dir;
      BoUseEffect := True;
    end;
    else  //방향이 없음...
    begin
      startframe    := pm.ActStand.start + Dir;
      // * (pm.ActStand.frame + pm.ActStand.skip);
      endframe      := startframe; // + pm.ActStand.frame - 1;
      frametime     := pm.ActStand.ftime;
      starttime     := GetTickCount;
      defframecount := 0; //pm.ActStand.frame;
      Shift(Dir, 0, 0, 1);
      BoHoldPlace := True;
    end;
  end;
end;

procedure TWallStructure.LoadSurface;
var
  mimg: TWMImages;
begin
  mimg := GetMonImg(Appearance);
  if deathframe > 0 then begin
    //(CurrentAction = SM_NOWDEATH) or (CurrentAction = SM_DEATH) then begin
    BodySurface := mimg.GetCachedImage(GetOffset(Appearance) + deathframe, px, py);
  end else begin
    inherited LoadSurface;
  end;
  BrokenSurface := mimg.GetCachedImage(GetOffset(Appearance) + 8 + Dir, bx, by);

  if BoUseEffect then begin
    if Appearance = 901 then
      EffectSurface := mimg.GetCachedImage(WALLLEFTBROKENEFFECTBASE +
        (currentframe - startframe), ax, ay)
    else
      EffectSurface := mimg.GetCachedImage(WALLRIGHTBROKENEFFECTBASE +
        (currentframe - startframe), ax, ay);
  end;
end;

function TWallStructure.GetDefaultFrame(wmode: boolean): integer;
var
  pm: PTMonsterAction;
begin
  Result := 0;
  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;
  Result := pm.ActStand.start + Dir; // * (pm.ActStand.frame + pm.ActStand.skip);
end;

procedure TWallStructure.DrawChr(dsurface: TDirectDrawSurface;
  dx, dy: integer; blend: boolean; WingDraw: boolean);
begin
  inherited DrawChr(dsurface, dx, dy, blend, WingDraw);
  if (BrokenSurface <> nil) and (not blend) then begin
    dsurface.Draw(dx + bx + ShiftX,
      dy + by + ShiftY,
      BrokenSurface.ClientRect,
      BrokenSurface, True);
  end;
  if BoUseEffect and (not blend) then begin
    if EffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        EffectSurface, 1);
    end;
  end;
end;

procedure TWallStructure.Run;
begin
  if Death then begin
    if bomarkpos then begin
      Map.MarkCanWalk(XX, YY, True);
      bomarkpos := False;
    end;
  end else begin
    if not bomarkpos then begin
      Map.MarkCanWalk(XX, YY, False);
      bomarkpos := True;
    end;
  end;
  PlayScene.SetActorDrawLevel(self, 0);
  inherited Run;
end;

// 화룡몸 ------------------------------------------------------------------------------

procedure TDragonBody.LoadSurface;
var
  mimg: TWMImages;
begin
  mimg := FrmMain.WDragonImg;
  if mimg <> nil then
    BodySurface := mimg.GetCachedImage(GetOffset(Appearance), px, py);
end;

procedure TDragonBody.CalcActorFrame;
var
  pm: PTMonsterAction;
  haircount: integer;
begin
  Dir := 0;
  BoUseMagic := False;
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    //      SM_TURN: //방향이 없음...
    //         begin
    //            defframecount := 400;
    //            Shift (Dir, 0, 0, 1);
    //         end;
    SM_DIGUP: //걷기 없음, SM_DIGUP, 방향 없음.
    begin
      maxtick  := pm.ActWalk.UseTick;
      curtick  := 0;
      //WarMode := FALSE;
      movestep := 1;
      Shift(Dir, 0, 0, 1); //movestep, 0, endframe-startframe+1);
    end;
  end;
  startframe := 0;
  endframe   := 1;
  frametime  := 400;
  starttime  := GetTickCount;

end;


procedure TDragonBody.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend: boolean; WingDraw: boolean);
var
  idx, ax, ay: integer;
  d:    TDirectDrawSurface;
  ceff: TColorEffect;
  wimg: TWMImages;
begin
  if not (Dir in [0..7]) then
    exit;
  if GetTickCount - loadsurfacetime > 60 * 1000 then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
    //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
  end;
  //   ceff := GetDrawEffectValue;

  if BodySurface <> nil then begin
    Drawblend(dsurface, dx + px + ShiftX, dy + py + ShiftY, BodySurface, 1);
    //      DrawEffSurface (dsurface, BodySurface, dx + px + ShiftX, dy + py + ShiftY, blend, ceNone);
  end;

end;


end.
