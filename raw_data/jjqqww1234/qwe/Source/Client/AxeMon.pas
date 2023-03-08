unit AxeMon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grobal2, DxDraws, CliUtil, ClFunc, magiceff, Actor, SoundUtil, ClEvent, ExtCtrls;

const
  DEATHEFFECTBASE   = 340;
  DEATHFIREEFFECTBASE = 2860;
  AXEMONATTACKFRAME = 6;
  KUDEGIGASBASE     = 1445;
  COWMONFIREBASE    = 1800;
  COWMONLIGHTBASE   = 1900;
  ZOMBILIGHTINGBASE = 350;
  ZOMBIDIEBASE      = 340;
  ZOMBILIGHTINGEXPBASE = 520;
  SCULPTUREFIREBASE = 1680;
  MOTHPOISONGASBASE = 3590;
  DUNGPOISONGASBASE = 3590;
  WARRIORELFFIREBASE = 820;
  SUPERIORGUARDEFFECTBASE = 760;
  ELECTRONICSCOPIONEFFECTBASE = 430;
  KINGBIGEFFECTBASE = 860;
  KINGOFSCOLPTUREKINGEFFECTBASE = 1380;
  KINGOFSCOLPTUREKINGDEATHEFFECTBASE = 1470;
  KINGOFSCOLPTUREKINGATTACKEFFECTBASE = 1490;
  // 2003/02/11
  TOXICPOISONGASBASE = 720;
  SAMURAIDIEBASE    = 350;
  SKELMUJANGDIEBASE = 1160;
  SKELSOLDIERDIEBASE = 1600;
  SKELSAMURAIDIEBASE = 1600;
  SKELARCHERDIEBASE = 1600;
  SKELETONKINGEFFECT1BASE = 2980;     //숨쉬기
  SKELETONKINGEFFECT2BASE = 3060;     //이동
  SKELETONKINGEFFECT3BASE = 3140;     //직접공격
  SKELETONKINGEFFECT4BASE = 3220;     //소환공격
  SKELETONKINGEFFECT5BASE = 3300;     //원거리공격
  SKELETONKINGEFFECT6BASE = 3380;     //맞기
  SKELETONKINGEFFECT7BASE = 3400;     //죽기
  SKELETONKINGEFFECT8BASE = 3570;     //날라가는 이펙트
  // 2003/03/04
  BANYAGUARDRIGHTDIEBASE = 2320;           //반야우사 죽기
  BANYAGUARDLEFTDIEBASE = 2870;           //반야좌사 죽기
  BANYAGUARDRIGHTHITBASE = 2230;           //반야우사 공격
  BANYAGUARDLEFTHITBASE = 2780;           //반야좌사 공격
  BANYAGUARDLEFTFLYBASE = 2960;           //반야우사 공격
  DEADCOWKINGHITBASE = 3490;           //사우천왕 공격
  DEADCOWKINGFLYBASE = 3580;           //사우천왕 원거리공격
  // 2003/07/15
  PBSTONE1IDLEBASE  = 2490;           //마계석1 숨쉬기
  PBSTONE1ATTACKBASE = 2500;           //마계석1 공격
  PBSTONE1DIEBASE   = 2530;           //마계석1 죽기
  PBSTONE2IDLEBASE  = 2620;           //마계석2 숨쉬기
  PBSTONE2ATTACKBASE = 2630;           //마계석2 공격
  PBSTONE2DIEBASE   = 2660;           //마계석2 죽기
  PBKINGATTACK1BASE = 3440;           //우마파천황 공격1
  PBKINGATTACK2BASE = 3520;           //우마파천황 공격2
  PBKINGDIEBASE     = 3120;           //우마파천황 죽기

  FOXWARRIOREFFECTBASE = 350;             //BlackFoxman
  FOXDEATHEFFECTBASE = 340;         //BlackFoxman

  FOXWIZARDATTACKEFFECTBASE = 780;         //RedFoxman
  FOXWIZARDEFFECTBASE = 790;             //RedFoxman
  FOXWIZARDMOVEEFFECTBASE = 800;          //RedFoxman

  FOXTAOAMULETEFFECTBASE = 1160;    //Whitefoxman
  FOXTAOSOULBANGEFFECTBASE = 1320;   //WhiteFoxman
  FOXTAOCURSEEFFECTBASE = 1330;     //Whitefoxman

  TRAPROCKEFFECTBASE = 1410;    //TrapRock

  GUARDROCKEFFECTBASE = 1410;    //GuardianRock

type
  TSkeletonOma = class(TActor)
  private
  protected
    EffectSurface: TDirectDrawSurface;
    ax, ay:  integer;
    SitDown: boolean;
  public
    constructor Create; override;
    //destructor Destroy; override;
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: boolean): integer; override;
    procedure LoadSurface; override;
    procedure Run; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
      blend: boolean; WingDraw: boolean); override;
  end;

  TDualAxeOma = class(TSkeletonOma)  //도끼던지는 몹
  private
  public
    procedure Run; override;
  end;

  TCatMon = class(TSkeletonOma)
  private
  public
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
      blend: boolean; WingDraw: boolean); override;
  end;

  TArcherMon = class(TCatMon)
  public
    procedure Run; override;
  end;

  TScorpionMon = class(TCatMon)
  public
  end;

  THuSuABi = class(TSkeletonOma)
  public
    procedure LoadSurface; override;
  end;

  TZombiDigOut = class(TSkeletonOma)
  public
    procedure RunFrameAction(frame: integer); override;
  end;

  TZombiZilkin = class(TSkeletonOma)
  public
  end;

  TWhiteSkeleton = class(TSkeletonOma)
  public
  end;


  TGasKuDeGi = class(TActor)
  protected
    AttackEffectSurface: TDirectDrawSurface;
    DieEffectSurface:    TDirectDrawSurface;
    BoUseDieEffect:      boolean;
    firedir, fire16dir, ax, ay, bx, by: integer;
  public
    constructor Create; override;
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: boolean): integer; override;
    procedure LoadSurface; override;
    procedure Run; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
      blend: boolean; WingDraw: boolean); override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
  end;

  TFireCowFaceMon = class(TGasKuDeGi)
  public
    function Light: integer; override;
  end;

  TCowFaceKing = class(TGasKuDeGi)
  public
    function Light: integer; override;
  end;

  TZombiLighting = class(TGasKuDeGi)
  protected
  public
  end;

  TSuperiorGuard = class(TGasKuDeGi)   //멋진 경비병
  public
  end;

  TExplosionSpider = class(TGasKuDeGi)  //폭주
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
  end;

  TFlyingSpider = class(TSkeletonOma)  //비독거미
  public
    procedure CalcActorFrame; override;
  end;

  TSculptureMon = class(TSkeletonOma)
  private
    AttackEffectSurface: TDirectDrawSurface;
    ax, ay, firedir:     integer;
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    function GetDefaultFrame(wmode: boolean): integer; override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
    procedure Run; override;
  end;

  TSculptureKingMon = class(TSculptureMon)
  public
  end;

  TSmallElfMonster = class(TSkeletonOma)
  public
  end;

  TWarriorElfMonster = class(TSkeletonOma)
  private
    oldframe: integer;
  public
    procedure RunFrameAction(frame: integer); override;
    //프래임마다 독특하게 해야할일
  end;

  TElectronicScolpionMon = class(TGasKuDeGi)   //뢰혈사(흑사왕)
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
  end;

  TBossPigMon = class(TGasKuDeGi)              //왕돈
  public
    procedure LoadSurface; override;
  end;

  TKingOfSculpureKingMon = class(TGasKuDeGi)   //주마본완(왕중왕)
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
  end;

  // 2003/02/11 신규 몹 추가
  TSkeletonKingMon = class(TGasKuDeGi)   //해골반왕
  public
    procedure Run; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
  end;

  TSamuraiMon = class(TGasKuDeGi)   //낭인귀
  public
  end;

  TSkeletonSoldierMon = class(TGasKuDeGi)   //해골무장,해골무사,해골병졸
  public
  end;

  TSkeletonArcherMon = class(TArcherMon)   //해골궁수
  protected
    DieEffectSurface: TDirectDrawSurface;
    BoUseDieEffect: boolean;
    bx, by: integer;
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure Run; override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
  end;

  // 2003/03/04 신규 몹 추가
  TBanyaGuardMon = class(TSkeletonArcherMon)   //반야우사,반야좌사,사우천왕
  protected
    AttackEffectSurface: TDirectDrawSurface;
  public
    constructor Create; override;
    procedure Run; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
  end;

  // 2003/07/15 과거비천 몹 추가...마계석
  TStoneMonster = class(TSkeletonArcherMon)
  protected
    AttackEffectSurface: TDirectDrawSurface;
  public
    constructor Create; override;
    procedure Run; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
  end;

  TPBOMA1Mon = class(TCatMon)
  public
    procedure Run; override;
  end;

  TPBOMA6Mon = class(TCatMon)
  public
    procedure Run; override;
  end;

  TAngel = class(TBanyaGuardMon)
    px2, py2:     integer;
    BodySurface2: TDirectDrawSurface;
  public
    procedure LoadSurface; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
      blend: boolean; WingDraw: boolean); override;
  end;

  TFireDragon = class(TSkeletonArcherMon)
    LightningTimer: TTimer;
  protected
    AttackEffectSurface: TDirectDrawSurface;
  public
    procedure LightningTimerTimer(Sender: TObject);
    constructor Create; override;
    destructor Destroy; override;
    procedure Run; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
  end;

  TDragonStatue = class(TSkeletonArcherMon) // 용석상
  protected
    AttackEffectSurface: TDirectDrawSurface;
  public
    constructor Create; override;
    procedure Run; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
  end;

  TJumaThunderMon = class(TSculptureMon) // 주마격뢰장
  public
    constructor Create; override;
    procedure LoadSurface; override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
    //      function  GetDefaultFrame (wmode: Boolean): integer; override;
    procedure CalcActorFrame; override;
    //      procedure Run; override;
    //      procedure  DrawChr (dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean; WingDraw: Boolean ); override;
  end;

  TFoxWarrior = class(TGasKuDeGi)   //BlackFoxman
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
  end;

  TFoxWizard = class(TSkeletonArcherMon) // RedFoxman
  protected
    AttackEffectSurface: TDirectDrawSurface;
  public
    constructor Create; override;
    procedure Run; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
  end;

  TFoxTao = class(TGasKuDeGi)   //WhiteFoxman
  public
    constructor Create; override;
    procedure Run; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
  end;

  TTrapRock = class(TSkeletonArcherMon) // TrapRock
  protected
    AttackEffectSurface: TDirectDrawSurface;
  public
    constructor Create; override;
    procedure Run; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
  end;

  TGuardRock = class(TSkeletonArcherMon) // GuardianRock
  protected
    AttackEffectSurface: TDirectDrawSurface;
  public
    constructor Create; override;
    procedure Run; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
  end;

  TElements = class(TBanyaGuardMon) // ThunderElement, CloudElement
  protected
    AttackEffectSurface: TDirectDrawSurface;
  public
    constructor Create; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure Run; override;
    function GetDefaultFrame(wmode: boolean): integer; override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
      blend: boolean; WingDraw: boolean); override;
  end;

  TKingElement = class(TBanyaGuardMon) // GreatFoxSpirit
  protected
    AttackEffectSurface: TDirectDrawSurface;
    px2, py2, Level:     integer;
    BodySurface2: TDirectDrawSurface;
  public
    constructor Create; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure Run; override;
    function GetDefaultFrame(wmode: boolean): integer; override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
      blend: boolean; WingDraw: boolean); override;
  end;

  TBigKekTal = class(TCatMon)
  public
    procedure Run; override;
  end;


implementation

uses
  ClMain, Wil;


{============================== TSkeletonOma =============================}

//      해골 오마(해골, 큰도끼해골, 해골전사)

{--------------------------}


constructor TSkeletonOma.Create;
begin
  inherited Create;
  EffectSurface := nil;
  BoUseEffect   := False;
end;

procedure TSkeletonOma.CalcActorFrame;
var
  pm: PTMonsterAction;
  haircount: integer;
begin
  currentframe := -1;
  ReverseFrame := False;
  BoUseEffect  := False;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_TURN: begin
      if Race in [93, 100] then
        SitDown := False; // 환영한호, 이무기
      startframe := pm.ActStand.start + Dir * (pm.ActStand.frame +
        pm.ActStand.skip);
      endframe  := startframe + pm.ActStand.frame - 1;
      frametime := pm.ActStand.ftime;
      if Race in [93, 94] then
        frametime := 200; //환영한호,거미(신석독마주) 프레임속도
      starttime := GetTickCount;
      defframecount := pm.ActStand.frame;
      Shift(Dir, 0, 0, 1);
    end;
    SM_WALK, SM_BACKSTEP: begin
      if Race in [93, 100] then
        SitDown := False; // 환영한호, 이무기
      startframe := pm.ActWalk.start + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
      endframe  := startframe + pm.ActWalk.frame - 1;
      frametime := WalkFrameDelay; //pm.ActWalk.ftime;
      if Race in [93, 94] then
        frametime := 150; //환영한호,거미(신석독마주) 프레임속도
      starttime := GetTickCount;
      maxtick  := pm.ActWalk.UseTick;
      curtick  := 0;
      //WarMode := FALSE;
      movestep := 1;
      if CurrentAction = SM_WALK then
        Shift(Dir, movestep, 0, endframe - startframe + 1)
      else  //sm_backstep
        Shift(GetBack(Dir), movestep, 0, endframe - startframe + 1);
    end;
    SM_DIGUP: //걷기 없음, SM_DIGUP, 방향 없음.
    begin
      if Race in [93, 100] then
        SitDown := False;
      if (Race = 23) or (Race = 81) then begin
        //or (Race = 54) or (Race = 55) then begin
        //백골
        startframe := pm.ActDeath.start;
      end else begin
        startframe := pm.ActDeath.start + Dir *
          (pm.ActDeath.frame + pm.ActDeath.skip);
      end;
      endframe  := startframe + pm.ActDeath.frame - 1;
      frametime := pm.ActDeath.ftime;
      starttime := GetTickCount;
      //WarMode := FALSE;
      Shift(Dir, 0, 0, 1);
    end;
    SM_DIGDOWN: begin
      if Race = 55 then begin
        //신수1 인 경우 역변신
        startframe   := pm.ActCritical.start + Dir *
          (pm.ActCritical.frame + pm.ActCritical.skip);
        endframe     := startframe + pm.ActCritical.frame - 1;
        frametime    := pm.ActCritical.ftime;
        starttime    := GetTickCount;
        ReverseFrame := True;
        //WarMode := FALSE;
        Shift(Dir, 0, 0, 1);
      end;
      //           if Race = 93 then begin // 환영한호
      if Race in [93, 100] then begin // 환영한호 //####
        //      DScreen.AddChatBoardString ('SM_DIGDOWN: //환영한호 Dir=> '+IntToStr(Dir), clYellow, clRed);
        SitDown    := True;
        startframe := 420 + Dir * 10;
        endframe   := startframe + 3;
        frametime  := 300;
        starttime  := GetTickCount;
        //               ReverseFrame := TRUE;
        //WarMode := FALSE;
        Shift(Dir, 0, 0, 1);
      end;
    end;
    SM_HIT,
    SM_LIGHTING: begin
      startframe  := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe    := startframe + pm.ActAttack.frame - 1;
      frametime   := pm.ActAttack.ftime;
      starttime   := GetTickCount;
      //WarMode := TRUE;
      WarModeTime := GetTickCount;
      if (Race = 16) or (Race = 54) then
        BoUseEffect := True;
      Shift(Dir, 0, 0, 1);
    end;
    SM_FLYAXE: begin
    if (Race = 110) or (Race = 111) then begin
      startframe  := pm.ActCritical.start + Dir *
        (pm.ActCritical.frame + pm.ActCritical.skip);
      endframe    := startframe + pm.ActCritical.frame - 1;
      frametime   := pm.ActCritical.ftime;
      end else begin
      startframe  := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe    := startframe + pm.ActAttack.frame - 1;
      frametime   := pm.ActAttack.ftime;
      end;
      starttime   := GetTickCount;
      //WarMode := TRUE;
      WarModeTime := GetTickCount;
      if (Race = 16) or (Race = 54) then
        BoUseEffect := True;
      Shift(Dir, 0, 0, 1);
    end;
    SM_STRUCK: begin
      if Race = 93 then
        SitDown := False;
      startframe := pm.ActStruck.start + Dir *
        (pm.ActStruck.frame + pm.ActStruck.skip);
      endframe  := startframe + pm.ActStruck.frame - 1;
      frametime := struckframetime; //pm.ActStruck.ftime;
      if Race = 93 then
        frametime := 110; //환영한호 프레임속도
      if Race = 94 then
        frametime := 130; //거미(신석독마주) 프레임속도
      starttime := GetTickCount;
    end;
    SM_DEATH: begin
      if Race = 92 then
        BoUseEffect := False; //주마격뢰장인경우
      startframe := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      startframe := endframe;
      frametime  := pm.ActDie.ftime;
      if Race = 93 then
        frametime := 160; //환영한호 프레임속도
      if Race = 94 then
        frametime := 110; //거미(신석독마주) 프레임속도
      starttime := GetTickCount;
    end;
    SM_NOWDEATH: begin
      startframe := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;
      if Race <> 22 then
        BoUseEffect := True;
      if Race = 92 then
        BoUseEffect := False; //주마격뢰장인경우
    end;
    SM_SKELETON: begin
      startframe := pm.ActDeath.start;
      endframe   := startframe + pm.ActDeath.frame - 1;
      frametime  := pm.ActDeath.ftime;
      starttime  := GetTickCount;
    end;
{      SM_ALIVE:  //####Org
         begin
            startframe := pm.ActDeath.start + Dir * (pm.ActDeath.frame + pm.ActDeath.skip);
            endframe := startframe + pm.ActDeath.frame - 1;
            frametime := pm.ActDeath.ftime;
            starttime := GetTickCount;
         end;}
  end;
end;

function TSkeletonOma.GetDefaultFrame(wmode: boolean): integer;
var
  cf, dr: integer;
  pm:     PTMonsterAction;
begin
  Result := 0;
  pm     := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  if Death then begin
    //우면귀일 경우
    if Appearance in [30..34, 151] then
      //우면귀인 경우 시체가 사람을 덮는 것을 막기 위해
      DownDrawLevel := 1;

    if Skeleton then
      Result := pm.ActDeath.start
    else
      Result := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip) +
        (pm.ActDie.frame - 1);
  end else begin
    if SitDown and (Race in [93, 100]) then begin //이무기 ####
      //      DScreen.AddChatBoardString ('GetDefaultFrame : SitDown and (Race = 93)', clYellow, clRed);
      defframecount := 4;
      if currentdefframe < 0 then
        cf := 0
      else if currentdefframe >= 4 then
        cf := 0
      else
        cf := currentdefframe;
      Result := 420 + Dir * 10 + cf;
    end else begin
      defframecount := pm.ActStand.frame;
      if currentdefframe < 0 then
        cf := 0
      else if currentdefframe >= pm.ActStand.frame then
        cf := 0
      else
        cf := currentdefframe;
      Result := pm.ActStand.start + Dir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
    end;
  end;
end;

procedure TSkeletonOma.LoadSurface;
begin
  inherited LoadSurface;
  case Race of
    //몬스터
    14, 15, 17, 22, 53: begin
      if BoUseEffect then
        EffectSurface :=
          FrmMain.WMon3Img.GetCachedImage(DEATHEFFECTBASE + currentframe -
          startframe, ax, ay);
    end;
    23: begin
      if CurrentAction = SM_DIGUP then begin
        BodySurface   := nil;
        EffectSurface :=
          FrmMain.WMon4Img.GetCachedImage(BodyOffset + currentframe, ax, ay);
        BoUseEffect   := True;
      end else
        BoUseEffect := False;
    end;
  end;
end;

procedure TSkeletonOma.Run;
var
  prv:   integer;
  frametimetime: longword;
  bofly: boolean;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction := 0; //동작 완료
        BoUseEffect   := False;
      end;
    end;

    if Race = 92 then begin
      if (CurrentAction = SM_LIGHTING) and (currentframe - startframe = 4) then begin
        PlayScene.NewMagic(self, MAGIC_DUN_THUNDER, MAGIC_DUN_THUNDER,
          XX, YY, TargetX, TargetY, TargetRecog, mtThunder, False, 30, bofly);
        PlaySound(8301);
      end;
    end;

    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;

end;


procedure TSkeletonOma.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend: boolean; WingDraw: boolean);
var
  idx:  integer;
  d:    TDirectDrawSurface;
  ceff: TColorEffect;
begin
  if not (Dir in [0..7]) then
    exit;
  if GetTickCount - loadsurfacetime > 60 * 1000 then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
    //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
  end;

  ceff := GetDrawEffectValue;

  if BodySurface <> nil then begin
    DrawEffSurface(dsurface, BodySurface, dx + px + ShiftX, dy +
      py + ShiftY, blend, ceff);
  end;

  if BoUseEffect and (Race <> 92) then //주마격뢰장이 아니면..
    if EffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        EffectSurface, 1);
    end;
end;




{============================== TSkeletonOma =============================}

//      해골 오마(해골, 큰도끼해골, 해골전사)

{--------------------------}


procedure TDualAxeOma.Run;
var
  prv:  integer;
  frametimetime: longword;
  meff: TFlyingAxe;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  //프래임마다 해야 할일
  RunFrameAction(currentframe - startframe);

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction := 0; //동작 완료
        BoUseEffect   := False;
      end;
      if (CurrentAction = SM_FLYAXE) and (currentframe - startframe =
        AXEMONATTACKFRAME - 4) then begin //도끼를 던질 시점
        //마법 발사
        meff := TFlyingAxe(PlayScene.NewFlyObject(self, XX, YY,
          TargetX, TargetY, TargetRecog, mtFlyAxe));
        if meff <> nil then begin
          meff.ImgLib := FrmMain.WMon3Img;
          case Race of
            15: meff.FlyImageBase := FLYOMAAXEBASE;
            22: meff.FlyImageBase := THORNBASE;
          end;
        end;
      end;
    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;

end;


{============================== TWarriorElfMonster =============================}

//         TCatMon : 괭이,  프래임은 해골이랑 같고, 터지는 애니가 없음.


procedure TWarriorElfMonster.RunFrameAction(frame: integer);
//프래임마다 독특하게 해야할일
var
  meff:  TMapEffect;
  event: TClEvent;
begin
  if CurrentAction = SM_HIT then begin
    if (frame = 5) and (oldframe <> frame) then begin
      meff := TMapEffect.Create(WARRIORELFFIREBASE + 10 * Dir + 1, 5, XX, YY);
      meff.ImgLib := FrmMain.WMon18Img;
      meff.NextFrameTime := 100;
      PlayScene.EffectList.Add(meff);
    end;
    oldframe := frame;
  end;
end;

{============================== TCatMon =============================}

//         TCatMon : 괭이,  프래임은 해골이랑 같고, 터지는 애니가 없음.

{--------------------------}


procedure TCatMon.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend: boolean; WingDraw: boolean);
var
  idx:  integer;
  d:    TDirectDrawSurface;
  ceff: TColorEffect;
begin
  if not (Dir in [0..7]) then
    exit;
  if GetTickCount - loadsurfacetime > 60 * 1000 then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
    //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
  end;

  ceff := GetDrawEffectValue;

  if BodySurface <> nil then
    if Race = 81 then //월령
      DrawEffSurface(dsurface, BodySurface, dx + px + ShiftX, dy +
        py + ShiftY, False, cliUtil.ceNone)
    else
      DrawEffSurface(dsurface, BodySurface, dx + px + ShiftX, dy +
        py + ShiftY, blend, ceff);
end;


{============================= TArcherMon =============================}


procedure TArcherMon.Run;
var
  prv:  integer;
  frametimetime: longword;
  meff: TFlyingAxe;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  //프래임마다 해야 할일
  RunFrameAction(currentframe - startframe);

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction := 0; //동작 완료
        BoUseEffect   := False;
      end;
      if (CurrentAction = SM_FLYAXE) and (currentframe - startframe = 4) then begin
        //화살 나감
        //(** 6월패치

        meff := TFlyingArrow(PlayScene.NewFlyObject(self, XX,
          YY, TargetX, TargetY, TargetRecog, mtFlyArrow));
        if meff <> nil then begin
          meff.ImgLib := FrmMain.WEffectImg;
          meff.NextFrameTime := 30;
          meff.FlyImageBase := ARCHERBASE2;
        end;
        //**)
(** 이전
            meff := TFlyingArrow (PlayScene.NewFlyObject (self,
                             XX,
                             YY,
                             TargetX,
                             TargetY,
                             TargetRecog,
                             mtFlyAxe));
            if meff <> nil then begin
               meff.ImgLib := FrmMain.WMon5Img;
               meff.NextFrameTime := 30;
               meff.FlyImageBase := ARCHERBASE;
            end;
//**)
      end;
    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;

end;


{============================= TZombiDigOut =============================}


procedure TZombiDigOut.RunFrameAction(frame: integer);
var
  clevent: TClEvent;
begin
  if CurrentAction = SM_DIGUP then begin
    if frame = 6 then begin
      clevent     := TClEvent.Create(CurrentEvent, XX, YY, ET_DIGOUTZOMBI);
      clevent.Dir := Dir;
      EventMan.AddEvent(clevent);
      //pdo.DSurface := FrmMain.WMon6Img.GetCachedImage (ZOMBIDIGUPDUSTBASE+Dir, pdo.px, pdo.py);
    end;
  end;
end;


{============================== THuSuABi =============================}

//      허수아비

{--------------------------}


procedure THuSuABi.LoadSurface;
begin
  inherited LoadSurface;
  if BoUseEffect then
    EffectSurface := FrmMain.WMon3Img.GetCachedImage(DEATHFIREEFFECTBASE +
      currentframe - startframe, ax, ay);
end;


 {============================== TGasKuDeGi =============================}
 //      대형구데기 (가스쏘는 구데기)
 {--------------------------}
constructor TGasKuDeGi.Create;
begin
  inherited Create;
  AttackEffectSurface := nil;
  DieEffectSurface := nil;
  BoUseEffect    := False;
  BoUseDieEffect := False;
end;

procedure TGasKuDeGi.CalcActorFrame;
var
  pm:    PTMonsterAction;
  actor: TActor;
  haircount, scx, scy, stx, sty: integer;
  meff:  TCharEffect;
begin
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_TURN: begin
      startframe    := pm.ActStand.start + Dir *
        (pm.ActStand.frame + pm.ActStand.skip);
      endframe      := startframe + pm.ActStand.frame - 1;
      frametime     := pm.ActStand.ftime;
      starttime     := GetTickCount;
      defframecount := pm.ActStand.frame;
      Shift(Dir, 0, 0, 1);
    end;
    SM_WALK: begin
      startframe := pm.ActWalk.start + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
      endframe   := startframe + pm.ActWalk.frame - 1;
      frametime  := WalkFrameDelay; //pm.ActWalk.ftime;
      starttime  := GetTickCount;
      maxtick    := pm.ActWalk.UseTick;
      curtick    := 0;
      //WarMode := FALSE;
      movestep   := 1;
      if CurrentAction = SM_WALK then
        Shift(Dir, movestep, 0, endframe - startframe + 1)
      else  //sm_backstep
        Shift(GetBack(Dir), movestep, 0, endframe - startframe + 1);
    end;
    SM_HIT,
    SM_LIGHTING: begin
      startframe  := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe    := startframe + pm.ActAttack.frame - 1;
      frametime   := pm.ActAttack.ftime;
      starttime   := GetTickCount;
      //WarMode := TRUE;
      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      firedir     := Dir;

      effectframe := startframe;
      effectstart := startframe;

      if Race = 20 then
        effectend := endframe + 1
      else
        effectend := endframe;

      effectstarttime := GetTickCount;
      effectframetime := frametime;

      //16방향인 마법 설정
      actor := PlayScene.FindActor(TargetRecog);
      if actor <> nil then begin
        PlayScene.ScreenXYfromMCXY(XX, YY, scx, scy);
        PlayScene.ScreenXYfromMCXY(actor.XX, actor.YY, stx, sty);
        fire16dir := GetFlyDirection16(scx, scy, stx, sty);
        //meff := TCharEffect.Create (ZOMBILIGHTINGEXPBASE, 12, actor);  //맞는 사람 효과
        //meff.ImgLib := FrmMain.WMon5Img;
        //meff.NextFrameTime := 50;
        //PlayScene.EffectList.Add (meff);
      end else
        fire16dir := firedir * 2;
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
      // 2003/02/11
      if (Race = 40) or (Race = 65) or (Race = 66) or (Race = 67) or
        (Race = 68) or (Race = 69) then  //마법 좀비
        BoUseDieEffect := True;
    end;
    SM_SKELETON: begin
      startframe := pm.ActDeath.start;
      endframe   := startframe + pm.ActDeath.frame - 1;
      frametime  := pm.ActDeath.ftime;
      starttime  := GetTickCount;
    end;
  end;
end;

function TGasKuDeGi.GetDefaultFrame(wmode: boolean): integer;
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
    else if Race = 95 then
      Result := 3580
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
    Result := pm.ActStand.start + Dir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
  end;
end;

procedure TGasKuDeGi.LoadSurface;
begin
  inherited LoadSurface;
  case Race of
        //몬스터
    24: //멋진 경비병,  TActor를 상속받은 경비병은 공격에 효과가 없음
    begin
      if BoUseEffect then
        AttackEffectSurface :=
          FrmMain.WMonImg.GetCachedImage(SUPERIORGUARDEFFECTBASE +
          Dir * 8 + effectframe - effectstart, ax, ay);
    end;
    16: begin
      if BoUseEffect then
        AttackEffectSurface :=
          FrmMain.WMon3Img.GetCachedImage(KUDEGIGASBASE - 1 +
          (firedir * 10) + effectframe - effectstart, //가스는 처음 한프레음 늦게 시작함.
          ax, ay);
    end;
    20: begin
      if BoUseEffect then
        AttackEffectSurface :=
          FrmMain.WMon4Img.GetCachedImage(COWMONFIREBASE +
          (firedir * 10) + effectframe - effectstart, ax, ay);
    end;
    21: begin
      if BoUseEffect then
        AttackEffectSurface :=
          FrmMain.WMon4Img.GetCachedImage(COWMONLIGHTBASE +
          (firedir * 10) + effectframe - effectstart, ax, ay);
    end;
    40: begin
      if BoUseEffect then begin
        AttackEffectSurface :=
          FrmMain.WMon5Img.GetCachedImage(ZOMBILIGHTINGBASE +
          (fire16dir * 10) + effectframe - effectstart, ax, ay);
      end;
      if BoUseDieEffect then begin
        DieEffectSurface :=
          FrmMain.WMon5Img.GetCachedImage(ZOMBIDIEBASE + currentframe -
          startframe, bx, by);
      end;
    end;
    52, 95: begin
      if BoUseEffect then
        AttackEffectSurface :=
          FrmMain.WMon4Img.GetCachedImage(MOTHPOISONGASBASE +
          (firedir * 10) + effectframe - effectstart, ax, ay);
    end;
    53: begin
      if BoUseEffect then
        AttackEffectSurface :=
          FrmMain.WMon3Img.GetCachedImage(DUNGPOISONGASBASE +
          (firedir * 10) + effectframe - effectstart, ax, ay);
    end;
    // 2003/02/11 낭인귀, 부식귀, 해골무장, 해골병졸, 해골무사, 해골궁수 추가
    64: begin
      if BoUseEffect then
        AttackEffectSurface :=
          FrmMain.WMon20Img.GetCachedImage(TOXICPOISONGASBASE +
          (firedir * 10) + effectframe - effectstart, ax, ay);
    end;
    65: begin
      if BoUseDieEffect then begin
        DieEffectSurface :=
          FrmMain.WMon20Img.GetCachedImage(SAMURAIDIEBASE +
          currentframe - startframe, bx, by);
      end;
    end;
    66: begin
      if BoUseDieEffect then begin
        DieEffectSurface :=
          FrmMain.WMon20Img.GetCachedImage(SKELSAMURAIDIEBASE +
          currentframe - startframe, bx, by);
      end;
    end;
    67: begin
      if BoUseDieEffect then begin
        DieEffectSurface :=
          FrmMain.WMon20Img.GetCachedImage(SKELMUJANGDIEBASE +
          dir * 10 + currentframe - startframe, bx, by);
      end;
    end;
    68: begin
      if BoUseDieEffect then begin
        DieEffectSurface :=
          FrmMain.WMon20Img.GetCachedImage(SKELSOLDIERDIEBASE +
          currentframe - startframe, bx, by);
      end;
    end;
  end;
end;

procedure TGasKuDeGi.Run;
var
  prv: integer;
  effectframetimetime, frametimetime: longword;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  if BoUseEffect then begin
    if msgmuch then
      effectframetimetime := Round(effectframetime * 2 / 3)
    else
      effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
        BoUseEffect := False;
      end;
    end;
  end;

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction  := 0; //동작 완료
        BoUseDieEffect := False;
      end;

    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;

end;


procedure TGasKuDeGi.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend: boolean; WingDraw: boolean);
var
  idx:  integer;
  d:    TDirectDrawSurface;
  ceff: TColorEffect;
begin
  if not (Dir in [0..7]) then
    exit;
  if GetTickCount - loadsurfacetime > 60 * 1000 then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
    //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
  end;

  ceff := GetDrawEffectValue;

  if (Race = 95) and Death then begin
    BodySurface := FrmMain.WMon4Img.GetCachedImage(3580, px, py);
    blend := True;
    if BodySurface <> nil then
      DrawEffSurface(dsurface, BodySurface, dx + px + ShiftX, dy +
        py + ShiftY, blend, ceff);
  end else if BodySurface <> nil then
    DrawEffSurface(dsurface, BodySurface, dx + px + ShiftX, dy +
      py + ShiftY, blend, ceff);

end;

procedure TGasKuDeGi.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
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
  if BoUseDieEffect then
    if DieEffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + bx + ShiftX,
        dy + by + ShiftY,
        DieEffectSurface, 1);
    end;
end;




 {-----------------------------------------------------------}
 //폭주


procedure TExplosionSpider.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  inherited CalcActorFrame;

  //pm := RaceByPm (Race, Appearance);
  //if pm = nil then exit;

  case CurrentAction of
    SM_HIT: begin
      BoUseEffect := False;
    end;
    SM_NOWDEATH: begin
      effectstart := startframe;
      effectframe := startframe;
      effectstarttime := GetTickCount;
      effectframetime := frametime; //pm.ActDie.ftime;
      effectend   := endframe;
      BoUseEffect := True;
    end;
  end;
end;

procedure TExplosionSpider.LoadSurface;
begin
  inherited LoadSurface;
  if BoUseEffect then begin
    AttackEffectSurface := FrmMain.WMon14Img.GetCachedImage(
      730 + effectframe - effectstart, ax, ay);
  end;
end;



 {-----------------------------------------------------------}
 //비독거미


procedure TFlyingSpider.CalcActorFrame;
var
  pm:   PTMonsterAction;
  meff: TMagicEff;
begin
  inherited CalcActorFrame;

  case CurrentAction of
    SM_NOWDEATH: begin
      //effectstart := startframe;
      //effectframe := startframe;
      //effectstarttime := GetTickCount;
      //effectframetime := frametime; //pm.ActDie.ftime;
      //effectend := endframe + 5;
      //BoUseEffect := TRUE;
      meff := TNormalDrawEffect.Create(XX, YY, FrmMain.WMon12Img,
        1420,       //시작 위치
        20,         //프래임
        frametime,  //딜레이
        True);

      if meff <> nil then begin
        meff.MagOwner := Myself;  //내 기준으로
        PlayScene.EffectList.Add(meff);
      end;
    end;
  end;
end;



{-----------------------------------------------------------}


function TFireCowFaceMon.Light: integer;
var
  l: integer;
begin
  l := ChrLight;
  if l < 2 then begin
    if BoUseEffect then
      l := 2;
  end;
  Result := l;
end;

function TCowFaceKing.Light: integer;
var
  l: integer;
begin
  l := ChrLight;
  if l < 2 then begin
    if BoUseEffect then
      l := 2;
  end;
  Result := l;
end;


{-----------------------------------------------------------}

//procedure TZombiLighting.Run;


{-----------------------------------------------------------}


procedure TSculptureMon.CalcActorFrame;
var
  pm: PTMonsterAction;
  haircount: integer;
begin
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;
  BoUseEffect := False;

  case CurrentAction of
    SM_TURN: begin
      if (State and STATE_STONE_MODE) <> 0 then begin
        if (Race = 48) or (Race = 49) then
          startframe :=
            pm.ActDeath.start // + Dir * (pm.ActDeath.frame + pm.ActDeath.skip)
        else
          startframe :=
            pm.ActDeath.start + Dir * (pm.ActDeath.frame + pm.ActDeath.skip);
        endframe := startframe;
        frametime     := pm.ActDeath.ftime;
        starttime     := GetTickCount;
        defframecount := pm.ActDeath.frame;
      end else begin
        startframe    := pm.ActStand.start + Dir *
          (pm.ActStand.frame + pm.ActStand.skip);
        endframe      := startframe + pm.ActStand.frame - 1;
        frametime     := pm.ActStand.ftime;
        starttime     := GetTickCount;
        defframecount := pm.ActStand.frame;
      end;
      Shift(Dir, 0, 0, 1);
    end;
    SM_WALK, SM_BACKSTEP: begin
      startframe := pm.ActWalk.start + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
      endframe   := startframe + pm.ActWalk.frame - 1;
      frametime  := WalkFrameDelay; //pm.ActWalk.ftime;
      starttime  := GetTickCount;
      maxtick    := pm.ActWalk.UseTick;
      curtick    := 0;
      //WarMode := FALSE;
      movestep   := 1;
      if CurrentAction = SM_WALK then
        Shift(Dir, movestep, 0, endframe - startframe + 1)
      else  //sm_backstep
        Shift(GetBack(Dir), movestep, 0, endframe - startframe + 1);
    end;
    SM_DIGUP: //걷기 없음, SM_DIGUP, 방향 없음.
    begin
      if (Race = 48) or (Race = 49) then begin
        startframe := pm.ActDeath.start;
      end else begin
        startframe := pm.ActDeath.start + Dir *
          (pm.ActDeath.frame + pm.ActDeath.skip);
      end;
      endframe  := startframe + pm.ActDeath.frame - 1;
      frametime := pm.ActDeath.ftime;
      starttime := GetTickCount;
      //WarMode := FALSE;
      Shift(Dir, 0, 0, 1);
    end;
    SM_HIT: begin
      startframe := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe   := startframe + pm.ActAttack.frame - 1;
      frametime  := pm.ActAttack.ftime;
      starttime  := GetTickCount;
      if Race = 49 then begin
        BoUseEffect := True;
        firedir     := Dir;
        effectframe := 0; //startframe;
        effectstart := 0; //startframe;
        effectend   := effectstart + 8;
        effectstarttime := GetTickCount;
        effectframetime := frametime;
      end;
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
  end;
end;

procedure TSculptureMon.LoadSurface;
begin
  inherited LoadSurface;
  case Race of
    48, 49: begin
      if BoUseEffect then
        AttackEffectSurface :=
          FrmMain.WMon7Img.GetCachedImage(SCULPTUREFIREBASE +
          (firedir * 10) + effectframe - effectstart, ax, ay);
    end;
  end;
end;

function TSculptureMon.GetDefaultFrame(wmode: boolean): integer;
var
  cf, dr: integer;
  pm:     PTMonsterAction;
  effectframetimetime, frametimetime: longword;
begin
  Result := 0;
  pm     := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  if Death then begin
    Result := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip) +
      (pm.ActDie.frame - 1);
  end else begin
    if (State and STATE_STONE_MODE) <> 0 then begin
      case Race of
        47: Result     := pm.ActDeath.start + Dir *
            (pm.ActDeath.frame + pm.ActDeath.skip);
        48, 49: Result := pm.ActDeath.start;
        92: begin
          BoUseEffect := False;
          Result      := 420 + Dir * 10;
        end;
      end;
    end else begin
      defframecount := pm.ActStand.frame;
      if currentdefframe < 0 then
        cf := 0
      else if currentdefframe >= pm.ActStand.frame then
        cf := 0
      else
        cf := currentdefframe;
      Result := pm.ActStand.start + Dir * (pm.ActStand.frame + pm.ActStand.skip) + cf;

      if Race = 92 then begin
        if not BoUseEffect then begin
          effectframe := 940 + Dir * 10;
          effectstart := 940 + Dir * 10;
          effectend   := effectstart + pm.ActStand.frame - 1;//endframe;
          effectstarttime := GetTickCount;
          effectframetime := pm.ActStand.ftime + 50;
        end;

        BoUseEffect := True;
        effectframetimetime := effectframetime;
        if GetTickCount - effectstarttime > effectframetimetime - 50 then begin
          // 50빼는 이유는 run에서도 effectstarttime 값이 변하기 때문에 먼저 루틴을 타기위해..
          effectstarttime := GetTickCount;
          if effectframe < effectend then begin
            Inc(effectframe);
          end else begin
            BoUseEffect := False;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSculptureMon.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
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

procedure TSculptureMon.Run;
var
  effectframetimetime, frametimetime: longword;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;
  if BoUseEffect then begin
    effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
        //            if Race <> 92 then BoUseEffect := FALSE; // 주마격뢰장이 아니면..
        BoUseEffect := False;
      end;
    end;
  end;
  inherited Run;
end;


 //----------------------------------------------------------------------------
 //  TElectronicScolpionMon  뢰혈사 (흑사왕)


procedure TElectronicScolpionMon.CalcActorFrame;
var
  pm:    PTMonsterAction;
  actor: TActor;
  haircount, scx, scy, stx, sty: integer;
  meff:  TCharEffect;
begin
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_HIT: begin
      startframe := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe   := startframe + pm.ActAttack.frame - 1;
      frametime  := pm.ActAttack.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      {      BoUseEffect := TRUE;
            firedir := Dir;

            effectframe := startframe;
            effectstart := startframe;
            effectend := endframe;

            effectstarttime := GetTickCount;
            effectframetime := frametime;  }
    end;
    SM_LIGHTING:   //크리틱컬 공격
    begin
      startframe := pm.ActCritical.start + Dir *
        (pm.ActCritical.frame + pm.ActCritical.skip);
      endframe   := startframe + pm.ActCritical.frame - 1;
      frametime  := pm.ActCritical.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      firedir     := Dir;

      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;
    else
      inherited CalcActorFrame;
  end;

end;

procedure TElectronicScolpionMon.LoadSurface;
begin
  inherited LoadSurface;
  case Race of
    60: begin
      if BoUseEffect then
        case CurrentAction of
          SM_HIT: ;
          SM_LIGHTING: AttackEffectSurface :=
              FrmMain.WMon19Img.GetCachedImage(
              ELECTRONICSCOPIONEFFECTBASE + (firedir * 10) +
              effectframe - effectstart, ax, ay);
        end;
    end;

  end;
end;


//----------------------------------------------------------------------------

//  TBossPigMon  왕돈,  귀돈왕


procedure TBossPigMon.LoadSurface;
begin
  inherited LoadSurface;
  case Race of
    61: begin
      if BoUseEffect then
        AttackEffectSurface :=
          FrmMain.WMon19Img.GetCachedImage(KINGBIGEFFECTBASE +
          (firedir * 10) + effectframe - effectstart, ax, ay);
    end;

  end;
end;



 //----------------------------------------------------------------------------
 //  TKingOfSculpureKingMon  흑천마왕 (왕중왕)
procedure TKingOfSculpureKingMon.CalcActorFrame;
var
  pm:    PTMonsterAction;
  actor: TActor;
  haircount, scx, scy, stx, sty: integer;
  meff:  TCharEffect;
begin
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_HIT: begin
      startframe := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe   := startframe + pm.ActAttack.frame - 1;
      frametime  := pm.ActAttack.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      firedir     := Dir;

      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;
    SM_LIGHTING:   //크리틱컬 공격
    begin
      startframe := pm.ActCritical.start + Dir *
        (pm.ActCritical.frame + pm.ActCritical.skip);
      endframe   := startframe + pm.ActCritical.frame - 1;
      frametime  := pm.ActCritical.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      firedir     := Dir;

      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;
    SM_NOWDEATH: begin
      startframe := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;

      effectframe := pm.ActDie.start;
      effectstart := pm.ActDie.start;
      effectend   := pm.ActDie.start + pm.ActDie.frame - 1;

      effectstarttime := GetTickCount;
      effectframetime := frametime;

      BoUseEffect := True;
    end;
    else
      inherited CalcActorFrame;
  end;

end;

procedure TKingOfSculpureKingMon.LoadSurface;
begin
  inherited LoadSurface;
  case Race of
    62: begin
      if BoUseEffect then
        case CurrentAction of
          SM_HIT: AttackEffectSurface      :=
              FrmMain.WMon19Img.GetCachedImage(
              KINGOFSCOLPTUREKINGATTACKEFFECTBASE + (firedir * 10) +
              effectframe - effectstart, ax, ay);
          SM_LIGHTING: AttackEffectSurface :=
              FrmMain.WMon19Img.GetCachedImage(
              KINGOFSCOLPTUREKINGEFFECTBASE + (firedir * 10) +
              effectframe - effectstart, ax, ay);
          SM_NOWDEATH: AttackEffectSurface :=
              FrmMain.WMon19Img.GetCachedImage(
              KINGOFSCOLPTUREKINGDEATHEFFECTBASE + effectframe -
              effectstart, ax, ay);
        end;
    end;
  end;
end;

 //----------------------------------------------------------------------------
 // 2003/02/11
 //  TSkeletonKingMon  해골반왕
procedure TSkeletonKingMon.CalcActorFrame;
var
  pm:    PTMonsterAction;
  actor: TActor;
  haircount, scx, scy, stx, sty: integer;
  meff:  TCharEffect;
begin
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of

    SM_WALK, SM_BACKSTEP: begin
      startframe  := pm.ActWalk.start + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
      endframe    := startframe + pm.ActWalk.frame - 1;
      frametime   := pm.ActWalk.ftime;
      starttime   := GetTickCount;
      effectframe := pm.ActWalk.start;
      effectstart := pm.ActWalk.start;
      effectend   := pm.ActWalk.start + pm.ActWalk.frame - 1;
      effectstarttime := GetTickCount;
      effectframetime := frametime;
      BoUseEffect := True;

      maxtick  := pm.ActWalk.UseTick;
      curtick  := 0;
      movestep := 1;
      if CurrentAction = SM_WALK then
        Shift(Dir, movestep, 0, endframe - startframe + 1)
      else  //sm_backstep
        Shift(GetBack(Dir), movestep, 0, endframe - startframe + 1);
    end;
    SM_STRUCK: begin
      startframe := pm.ActStruck.start + Dir *
        (pm.ActStruck.frame + pm.ActStruck.skip);
      endframe   := startframe + pm.ActStruck.frame - 1;
      frametime  := pm.ActStruck.ftime;
      starttime  := GetTickCount;

      effectframe := pm.ActStruck.start;
      effectstart := pm.ActStruck.start;
      effectend   := pm.ActStruck.start + pm.ActStruck.frame - 1;

      effectstarttime := GetTickCount;
      effectframetime := frametime;

      BoUseEffect := True;
    end;

    SM_HIT: begin
      startframe := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe   := startframe + pm.ActAttack.frame - 1;
      frametime  := pm.ActAttack.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      firedir     := Dir;

      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;
    SM_FLYAXE:     //원거리공격
    begin
      startframe := pm.ActCritical.start + Dir *
        (pm.ActCritical.frame + pm.ActCritical.skip);
      endframe   := startframe + pm.ActCritical.frame - 1;
      frametime  := pm.ActCritical.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      firedir     := Dir;

      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;
    SM_LIGHTING:   //소환공격
    begin
      startframe := pm.ActAttack.start + 80 + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe   := startframe + pm.ActAttack.frame - 1;
      frametime  := pm.ActAttack.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      firedir     := Dir;

      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;
    SM_NOWDEATH: begin
      startframe := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;

      effectframe := pm.ActDie.start;
      effectstart := pm.ActDie.start;
      effectend   := pm.ActDie.start + pm.ActDie.frame - 1;

      effectstarttime := GetTickCount;
      effectframetime := frametime;

      BoUseEffect := True;
    end;
    else
      inherited CalcActorFrame;
  end;

end;

procedure TSkeletonKingMon.LoadSurface;
begin
  inherited LoadSurface;
  case Race of
    63: begin
      if BoUseEffect then
        case CurrentAction of
          SM_WALK: AttackEffectSurface     :=
              FrmMain.WMon20Img.GetCachedImage(SKELETONKINGEFFECT2BASE +
              (Dir * 10) + effectframe - effectstart, ax, ay);
          SM_STRUCK: AttackEffectSurface   :=
              FrmMain.WMon20Img.GetCachedImage(SKELETONKINGEFFECT6BASE +
              (Dir * 2) + effectframe - effectstart, ax, ay);
          SM_HIT: AttackEffectSurface      :=
              FrmMain.WMon20Img.GetCachedImage(SKELETONKINGEFFECT3BASE +
              (firedir * 10) + effectframe - effectstart, ax, ay);
          SM_FLYAXE: AttackEffectSurface   :=
              FrmMain.WMon20Img.GetCachedImage(SKELETONKINGEFFECT5BASE +
              (firedir * 10) + effectframe - effectstart, ax, ay);
          SM_LIGHTING: AttackEffectSurface :=
              FrmMain.WMon20Img.GetCachedImage(SKELETONKINGEFFECT4BASE +
              (firedir * 10) + effectframe - effectstart, ax, ay);
          SM_NOWDEATH: AttackEffectSurface :=
              FrmMain.WMon20Img.GetCachedImage(SKELETONKINGEFFECT7BASE +
              dir * 20 + effectframe - effectstart, ax, ay);
        end;
    end;
  end;
end;

procedure TSkeletonKingMon.Run;
var
  prv:  integer;
  effectframetimetime, frametimetime: longword;
  meff: TFlyingAxe;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  if BoUseEffect then begin
    if msgmuch then
      effectframetimetime := Round(effectframetime * 2 / 3)
    else
      effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
        BoUseEffect := False;
      end;
    end;
  end;

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction  := 0; //동작 완료
        BoUseEffect    := False;
        BoUseDieEffect := False;
      end;
      if (CurrentAction = SM_FLYAXE) and (currentframe - startframe = 4) then begin
        meff := TFlyingFireBall(PlayScene.NewFlyObject(self, XX,
          YY, TargetX, TargetY, TargetRecog, mtFireBall));

        if meff <> nil then begin
          meff.ImgLib := FrmMain.WMon20Img; //WMon5Img;
          meff.NextFrameTime := 40;
          meff.FlyImageBase := SKELETONKINGEFFECT8BASE;
        end;
      end;
    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;
end;

// 2003/02/11
procedure TSkeletonArcherMon.LoadSurface;
begin
  inherited LoadSurface;
  if BoUseDieEffect then begin
    DieEffectSurface := FrmMain.WMon20Img.GetCachedImage(
      SKELARCHERDIEBASE + currentframe - startframe, bx, by);
  end;
end;

procedure TSkeletonArcherMon.CalcActorFrame;
begin
  inherited CalcActorFrame;
  case CurrentAction of
    SM_NOWDEATH: begin
      if (Race <> 72) then
        BoUseDieEffect := True;
      if Race in [91, 94] then
        BoUseDieEffect := False; // 설인대충이면 죽는 임펙트 안나옴
    end;
  end;
end;

procedure TSkeletonArcherMon.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
begin
  inherited DrawEff(dsurface, dx, dy);
  if BoUseDieEffect then
    if DieEffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + bx + ShiftX,
        dy + by + ShiftY,
        DieEffectSurface, 1);
    end;
end;

procedure TSkeletonArcherMon.Run;
var
  frametimetime: longword;
begin
  if msgmuch then
    frametimetime := Round(frametime * 2 / 3)
  else
    frametimetime := frametime;

  if CurrentAction <> 0 then begin
    if GetTickCount - starttime > frametimetime then begin
      if currentframe >= endframe then begin
        //동작이 끝남.
        CurrentAction  := 0; //동작 완료
        BoUseDieEffect := False;
      end;
    end;
  end;
  inherited Run;
end;

// 2003/03/04
constructor TBanyaGuardMon.Create;
begin
  inherited Create;
  AttackEffectSurface := nil;
end;

procedure TBanyaGuardMon.LoadSurface;
begin
  inherited LoadSurface;
  if BoUseDieEffect then begin
    case Race of
      70: DieEffectSurface :=
          FrmMain.WMon21Img.GetCachedImage(BANYAGUARDRIGHTDIEBASE +
          currentframe - startframe, bx, by);
      71: DieEffectSurface :=
          FrmMain.WMon21Img.GetCachedImage(BANYAGUARDLEFTDIEBASE +
          (Dir * 10) + currentframe - startframe, bx, by);
      78: DieEffectSurface :=
          FrmMain.WMon22Img.GetCachedImage(PBKINGDIEBASE + (Dir * 20) +
          currentframe - startframe, bx, by);
      93: begin //환영한호
        DieEffectSurface :=
          FrmMain.WMon23Img.GetCachedImage(1790 + currentframe -
          startframe, bx, by);
      end;
      100: begin //황금이무기 //#### 환미룡사, 청영사
        DieEffectSurface :=
          FrmMain.WMon23Img.GetCachedImage(2900 + currentframe -
          startframe, bx, by);
      end;

    end;
  end else if BoUseEffect then begin
    case Race of
      70: begin
        case CurrentAction of
          SM_HIT: AttackEffectSurface :=
              FrmMain.WMon21Img.GetCachedImage(BANYAGUARDRIGHTHITBASE +
              (Dir * 10) + effectframe - effectstart, ax, ay);
        end;
      end;
      71: begin
        case CurrentAction of
          SM_HIT: AttackEffectSurface    :=
              FrmMain.WMon21Img.GetCachedImage(BANYAGUARDLEFTHITBASE +
              (Dir * 10) + effectframe - effectstart, ax, ay);
          SM_LIGHTING,
          SM_FLYAXE: AttackEffectSurface :=
              FrmMain.WMon21Img.GetCachedImage(BANYAGUARDLEFTFLYBASE +
              (Dir * 10) + effectframe - effectstart, ax, ay);
        end;
      end;
      72: begin
        case CurrentAction of
          SM_HIT: AttackEffectSurface :=
              FrmMain.WMon21Img.GetCachedImage(DEADCOWKINGHITBASE +
              (Dir * 10) + effectframe - effectstart, ax, ay);
        end;
      end;
      78: begin
        case CurrentAction of
          SM_HIT: AttackEffectSurface :=
              FrmMain.WMon22Img.GetCachedImage(PBKINGATTACK1BASE +
              (Dir * 10) + effectframe - effectstart, ax, ay);
        end;
      end;
      94: // 거미
      begin
        if CurrentAction = SM_LIGHTING then begin
          BoUseEffect := True;
          AttackEffectSurface :=
            FrmMain.WMon23Img.GetCachedImage(2230 + (Dir * 10) +
            effectframe - effectstart, ax, ay);
        end else
          BoUseEffect := False;
      end;
      100: //####
        if CurrentAction in [SM_LIGHTING, SM_LIGHTING_1] then begin
          BoUseEffect := True;
          AttackEffectSurface :=
            FrmMain.WMon23Img.GetCachedImage(2820 + (Dir * 10) +
            effectframe - effectstart, ax, ay);
        end else
          BoUseEffect := False;

    end;
  end;
end;

procedure TBanyaGuardMon.CalcActorFrame;
var
  pm:    PTMonsterAction;
  actor: TActor;
  haircount, scx, scy, stx, sty: integer;
  meff:  TCharEffect;
begin
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_HIT:         // 근거리 공격
    begin
      if Race in [93, 100] then
        SitDown := False; //이무기 ####
      startframe := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe  := startframe + pm.ActAttack.frame - 1;
      frametime := pm.ActAttack.ftime;
      if Race = 93 then
        frametime := 80; //환영한호 프레임속도
      if Race = 94 then
        frametime := 130; //거미(신석독마주) 프레임속도
      if Race = 100 then
        frametime := 100; //이무기
      starttime := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;

      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;
    //    SM_FLYAXE,     //원거리공격...
    SM_LIGHTING_1,
    SM_LIGHTING: begin
      if Race in [93, 100] then
        SitDown := False; //이무기
      startframe := pm.ActCritical.start + Dir *
        (pm.ActCritical.frame + pm.ActCritical.skip);
      endframe    := startframe + pm.ActCritical.frame - 1;
      frametime   := pm.ActCritical.ftime;
      starttime   := GetTickCount;
      CurEffFrame := 0;
      BoUseMagic  := True;
      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);

      if (Race = 71) then begin //반야 좌사만 이펙트가 있음
        BoUseEffect := True;
        effectframe := startframe;
        effectstart := startframe;
        effectend   := endframe;
        effectstarttime := GetTickCount;
        effectframetime := frametime;
      end else if Race = 94 then begin //New거미 마법 임펙트, 이무기
        BoUseEffect := True;
        effectframe := 420 + Dir * 10;
        effectstart := effectframe;
        effectend   := effectframe + 9;
        effectstarttime := GetTickCount;
        effectframetime := frametime;
      end else if Race = 100 then begin //New거미 마법 임펙트, 이무기
        BoUseEffect := True;
        effectframe := 500 + Dir * 10;
        effectstart := effectframe;
        effectend   := effectframe + 5;
        effectstarttime := GetTickCount;
        effectframetime := frametime;
{               if CurrentAction = SM_LIGHTING_1 then
      DScreen.AddChatBoardString ('CalcActorFrame 이무기-SM_LIGHTING_1', clYellow, clRed)
               else
      DScreen.AddChatBoardString ('CalcActorFrame 이무기-SM_LIGHTING', clYellow, clRed); //####}
      end;
    end;

    else
      inherited CalcActorFrame;
  end;
end;

procedure TBanyaGuardMon.Run;
var
  prv:   integer;
  effectframetimetime, frametimetime: longword;
  meff:  TFlyingAxe;
  bofly: boolean;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  if BoUseEffect then begin
    if msgmuch then
      effectframetimetime := Round(effectframetime * 2 / 3)
    else
      effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
        BoUseEffect := False;
      end;
    end;
  end;

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction  := 0; //동작 완료
        BoUseEffect    := False;
        BoUseDieEffect := False;
      end;

      if (CurrentAction = SM_LIGHTING_1) and (currentframe - startframe = 4) then begin
        if (Race = 100) then begin    //이무기 멸천화
          //      DScreen.AddChatBoardString ('이무기-SM_LIGHTING_1 //이무기 멸천화', clYellow, clRed);
          PlayScene.NewMagic(self,
            MAGIC_SERPENT_1,
            MAGIC_SERPENT_1,
            XX,
            YY,
            TargetX,
            TargetY,
            TargetRecog,
            mtThunder,
            False,
            30,
            bofly);
          PlaySound(8101);
        end;
      end else if (CurrentAction = SM_LIGHTING) and
        (currentframe - startframe = 4) then begin
        if (Race = 70) or (Race = 81) then begin    //강격
          PlayScene.NewMagic(self,
            MagicNum, //11,
            8,
            XX,
            YY,
            TargetX,
            TargetY,
            TargetRecog,
            mtThunder,
            False,
            30,
            bofly);
          PlaySound(10112);
        end;
        if (Race = 71) then begin    //화이어볼
          PlayScene.NewMagic(self,
            1, //11,
            1,
            XX,
            YY,
            TargetX,
            TargetY,
            TargetRecog,
            mtFly,
            True,
            30,
            bofly);
          PlaySound(10012);
        end;

        if (Race = 72) then begin    //마법진
          PlayScene.NewMagic(self,
            11,
            32,
            XX,
            YY,
            TargetX,
            TargetY,
            TargetRecog,
            mtGroundEffect,
            False,
            30,
            bofly);
          PlaySound(2276);
        end;
        if (Race = 78) then begin    //마법진
          PlayScene.NewMagic(self,
            11,
            37,
            XX,
            YY,
            XX,       //TargetX,
            YY,       //TargetY,
            RecogId,  //TargetRecog,
            mtGroundEffect,
            False,
            30,
            bofly);
          PlaySound(2396);
        end;
        if (Race = 93) then begin    //결빙장  //환영한호
          PlayScene.NewMagic(self,
            39,
            39,
            XX,
            YY,
            TargetX,
            TargetY,
            TargetRecog,
            mtFly,
            True,
            30,
            bofly);
          PlaySound(10390);
        end;
        if (Race = 94) then begin
          //      DScreen.AddChatBoardString ('SM_LIGHTING: (Race = 94)//거미=> PlaySound (2437);', clYellow, clRed);
          PlaySound(2437);  //거미
        end;
      end;
    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;
end;

procedure TBanyaGuardMon.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
begin
  inherited DrawEff(dsurface, dx, dy);
  if BoUseEffect then
    if AttackEffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        AttackEffectSurface, 1);
    end;
end;

constructor TStoneMonster.Create;
begin
  inherited Create;
  AttackEffectSurface := nil;
  BoUseEffect    := False;
  BoUseDieEffect := False;
end;

procedure TStoneMonster.LoadSurface;
begin
  inherited LoadSurface;
  if BoUseDieEffect then begin
    case Race of
      75: DieEffectSurface :=
          FrmMain.WMon22Img.GetCachedImage(PBSTONE1DIEBASE +
          effectframe - effectstart, bx, by);
      77: DieEffectSurface :=
          FrmMain.WMon22Img.GetCachedImage(PBSTONE2DIEBASE +
          effectframe - effectstart, bx, by);
    end;
  end else if BoUseEffect then begin
    case Race of
      75: begin
        case CurrentAction of
          SM_HIT: AttackEffectSurface  :=
              FrmMain.WMon22Img.GetCachedImage(PBSTONE1ATTACKBASE +
              effectframe - effectstart, ax, ay);
          SM_TURN: AttackEffectSurface :=
              FrmMain.WMon22Img.GetCachedImage(PBSTONE1IDLEBASE +
              effectframe - effectstart, ax, ay);
        end;
      end;
      77: begin
        case CurrentAction of
          SM_HIT: AttackEffectSurface  :=
              FrmMain.WMon22Img.GetCachedImage(PBSTONE2ATTACKBASE +
              effectframe - effectstart, ax, ay);
          SM_TURN: AttackEffectSurface :=
              FrmMain.WMon22Img.GetCachedImage(PBSTONE2IDLEBASE +
              effectframe - effectstart, ax, ay);
        end;
      end;
    end;
  end;
end;

procedure TStoneMonster.CalcActorFrame;
var
  pm:    PTMonsterAction;
  actor: TActor;
  haircount, scx, scy, stx, sty: integer;
  meff:  TCharEffect;
begin
  BoUseMagic   := False;
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  Dir := 0;
  case CurrentAction of
    SM_TURN: begin
      startframe    := pm.ActStand.start;
      endframe      := startframe + pm.ActStand.frame - 1;
      frametime     := pm.ActStand.ftime;
      starttime     := GetTickCount;
      defframecount := pm.ActStand.frame;
      if not BoUseEffect then begin
        BoUseEffect := True;
        effectframe := startframe;
        effectstart := startframe;
        effectend   := endframe;
        effectstarttime := GetTickCount;
        effectframetime := 300;
      end;
    end;
    SM_HIT: begin
      startframe := pm.ActAttack.start;
      endframe   := startframe + pm.ActAttack.frame - 1;
      frametime  := pm.ActAttack.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      if not BoUseEffect then begin
        BoUseEffect := True;
        effectframe := startframe;
        effectstart := startframe;
        effectend   := startframe + 25;
        effectstarttime := GetTickCount;
        effectframetime := 150;
      end;
    end;
    SM_STRUCK: begin
      startframe := pm.ActStruck.start;
      endframe   := startframe + pm.ActStruck.frame - 1;
      frametime  := struckframetime; //pm.ActStruck.ftime;
      starttime  := GetTickCount;
    end;
    SM_DEATH: begin
      startframe := pm.ActDie.start;
      endframe   := startframe + pm.ActDie.frame - 1;
      startframe := endframe;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;
    end;
    SM_NOWDEATH: begin
      startframe  := pm.ActDie.start;
      endframe    := startframe + pm.ActDie.frame - 1;
      frametime   := pm.ActDie.ftime;
      starttime   := GetTickCount;
      BoUseDieEffect := True;
      effectframe := startframe;
      effectstart := startframe;
      effectend   := startframe + 19;
      effectstarttime := GetTickCount;
      effectframetime := 80;
    end;
      {
      SM_SKELETON:
         begin
            startframe := pm.ActDeath.start;
            endframe   := startframe + pm.ActDeath.frame - 1;
            frametime  := pm.ActDeath.ftime;
            starttime  := GetTickCount;
         end;
      }
  end;
end;

procedure TStoneMonster.Run;
var
  prv, prv2: integer;
  effectframetimetime, frametimetime: longword;
  bofly:     boolean;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  prv2 := effectframe;
  if BoUseEffect or BoUseDieEffect then begin
    if msgmuch then
      effectframetimetime := Round(effectframetime * 2 / 3)
    else
      effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
        if BoUseEffect then
          BoUseEffect := False;
        if BoUseDieEffect then
          BoUseDieEffect := False;
      end;
    end;
  end;

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        CurrentAction := 0; //동작 완료
      end;
    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if (prv <> currentframe) or (prv2 <> effectframe) then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;
end;

procedure TStoneMonster.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
begin
  inherited DrawEff(dsurface, dx, dy);
  if BoUseEffect then
    if AttackEffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        AttackEffectSurface, 1);
    end;
end;

procedure TPBOMA1Mon.Run;
var
  prv:  integer;
  frametimetime: longword;
  meff: TFlyingBug;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;
  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        CurrentAction := 0; //동작 완료
        BoUseEffect   := False;
      end;                                                       // 4
      if (CurrentAction = SM_FLYAXE) and (currentframe - startframe = 4) then begin
        meff := TFlyingBug(PlayScene.NewFlyObject(self, XX, YY,
          TargetX, TargetY, TargetRecog, mtFlyBug));
        if meff <> nil then begin
          meff.ImgLib := FrmMain.WMon22Img;
          meff.NextFrameTime := 50; // 50
          meff.FlyImageBase := 350;
          meff.MagExplosionBase := 430;
        end;
      end;
    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;
end;

procedure TPBOMA6Mon.Run;
var
  prv:  integer;
  frametimetime: longword;
  meff: TFlyingAxe;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;
  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        CurrentAction := 0; //동작 완료
        BoUseEffect   := False;
      end;
      if (CurrentAction = SM_FLYAXE) and (currentframe - startframe = 4) then begin
        meff := TFlyingAxe(PlayScene.NewFlyObject(self, XX, YY,
          TargetX, TargetY, TargetRecog, mtFlyBolt));
        if meff <> nil then begin
          meff.ImgLib := FrmMain.WMon22Img;
          meff.NextFrameTime := 30;
          meff.FlyImageBase := 1989;
        end;
      end;
    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;
end;

//천 녀 (월령)------------------------------------------------------------------------

procedure TAngel.LoadSurface;
var
  mimg: TWMImages;
begin

  mimg := GetMonImg(Appearance);
  if mimg <> nil then begin
    if (not ReverseFrame) then begin
      BodySurface  := mimg.GetCachedImage(GetOffset(Appearance) +
        currentframe, px, py);
      BodySurface2 := mimg.GetCachedImage(1280 + currentframe, px2, py2);
      // 투명아닌 이미지
    end else begin
      BodySurface  := mimg.GetCachedImage(GetOffset(Appearance) +
        endframe - (currentframe - startframe), px, py);
      BodySurface2 := mimg.GetCachedImage(1280 + endframe -
        (currentframe - startframe), px2, py2);
    end;
  end;
end;

procedure TAngel.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend: boolean; WingDraw: boolean);
var
  nx, ny: integer;
  ceff:   TColorEffect;
begin
  if not (Dir in [0..7]) then
    exit;
  if GetTickCount - loadsurfacetime > 60 * 1000 then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
    //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
  end;

  ceff := GetDrawEffectValue;
  if (BodySurface <> nil) and (BodySurface2 <> nil) then begin
    Drawblend(dsurface, dx + px + ShiftX, dy + py + ShiftY, BodySurface, 1);
    blend := False;
    DrawEffSurface(dsurface, BodySurface2, dx + px2 + ShiftX, dy +
      py2 + ShiftY, blend, ceff);
  end;

end;

//파천마룡(화룡) -------------------------------------------------------------------------------
constructor TFireDragon.Create;
begin
  inherited Create;

  AttackEffectSurface := nil;
  LightningTimer      := TTimer.Create(nil);
  LightningTimer.Interval := 70;
  LightningTimer.Tag  := 0;
  LightningTimer.OnTimer := LightningTimerTimer;
  LightningTimer.Enabled := False; //FireDragon
end;

destructor TFireDragon.Destroy;
begin

  if LightningTimer <> nil then
    LightningTimer.Free;

  inherited Destroy;

end;

procedure TFireDragon.LoadSurface;
var
  mimg: TWMImages;
begin
  mimg := FrmMain.WDragonImg;

  if mimg <> nil then begin
    if (not ReverseFrame) then begin

      case CurrentAction of
        SM_LIGHTING: BodySurface :=
            FrmMain.WDragonImg.GetCachedImage(40 + currentframe, px, py);
        SM_DRAGON_FIRE1: // FireDragon
          BodySurface :=
            FrmMain.WDragonImg.GetCachedImage(10 + currentframe, px, py);
        SM_DRAGON_FIRE2: BodySurface :=
            FrmMain.WDragonImg.GetCachedImage(20 + currentframe, px, py);
        SM_DRAGON_FIRE3: BodySurface :=
            FrmMain.WDragonImg.GetCachedImage(30 + currentframe, px, py);
        else
          BodySurface :=
            mimg.GetCachedImage(GetOffset(Appearance) + currentframe, px, py);
      end;
    end else begin
      case CurrentAction of
        SM_LIGHTING: BodySurface :=
            FrmMain.WDragonImg.GetCachedImage(40 + endframe - currentframe, ax, ay);
        SM_DRAGON_FIRE1: // FireDragon
          BodySurface :=
            FrmMain.WDragonImg.GetCachedImage(10 + endframe - currentframe, ax, ay);
        SM_DRAGON_FIRE2: BodySurface :=
            FrmMain.WDragonImg.GetCachedImage(20 + endframe - currentframe, ax, ay);
        SM_DRAGON_FIRE3: BodySurface :=
            FrmMain.WDragonImg.GetCachedImage(30 + endframe - currentframe, ax, ay);
        else
          BodySurface :=
            mimg.GetCachedImage(GetOffset(Appearance) + endframe - currentframe, px, py);
      end;
    end;
  end;

  if BoUseEffect then begin
    begin
      case CurrentAction of
        SM_LIGHTING: AttackEffectSurface :=
            FrmMain.WDragonImg.GetCachedImage(60 + effectframe, ax, ay);
        SM_DRAGON_FIRE1: // FireDragon
          AttackEffectSurface :=
            FrmMain.WDragonImg.GetCachedImage(90 + effectframe, ax, ay);
        SM_DRAGON_FIRE2: AttackEffectSurface :=
            FrmMain.WDragonImg.GetCachedImage(100 + effectframe, ax, ay);
        SM_DRAGON_FIRE3: AttackEffectSurface :=
            FrmMain.WDragonImg.GetCachedImage(110 + effectframe, ax, ay);
      end;
    end;
  end;
  px := px - 14;
  py := py - 15;
  ax := ax - 14;
  ay := ay - 15;

end;

procedure TFireDragon.CalcActorFrame;
var
  pm:    PTMonsterAction;
  actor: TActor;
  haircount, scx, scy, stx, sty: integer;
  meff:  TCharEffect;
  //   startframe2: integer;
begin
  Dir := 0;
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_LIGHTING: //      SM_DRAGON_LIGHTING:
    begin
      startframe := 0;
      endframe   := 19;
      frametime  := 150;

      starttime := GetTickCount;

      BoUseEffect := True;
      effectframe := 0;
      effectstart := 0;

      effectend := 19;
      effectstarttime := GetTickCount;
      effectframetime := 150;

      CurEffFrame := 0;
      BoUseMagic  := True;
      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
    end;
    SM_DRAGON_FIRE1, SM_DRAGON_FIRE2, SM_DRAGON_FIRE3: begin
      startframe := 0;
      endframe   := 5;
      frametime  := 150;
      starttime  := GetTickCount;

      BoUseEffect := True;
      effectframe := 0;
      effectstart := 0;

      effectend := 10;
      effectstarttime := GetTickCount;
      effectframetime := 150;

      CurEffFrame := 0;
      BoUseMagic  := True;
      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
    end;
    SM_STRUCK: begin
      startframe := 0;
      endframe   := 9;
      frametime  := 300; //pm.ActStruck.ftime;
      starttime  := GetTickCount;
    end;
    SM_DIGUP: //걷기 없음, SM_DIGUP, 방향 없음.
    begin
      //WarMode := FALSE;
      Shift(0, 0, 0, 1);
      startframe := 0;
      endframe   := 9;
      frametime  := 300;
      starttime  := GetTickCount;
    end;
  end;
end;


procedure TFireDragon.Run;
var
  prv:   integer;
  effectframetimetime, frametimetime: longword;
  meff:  TFlyingAxe;
  bofly: boolean;
  tx, ty, i: integer;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  if borunsound then begin
    PlaySound(8201);
    borunsound := False;
  end;

  if BoUseEffect then begin
    if msgmuch then
      effectframetimetime := Round(effectframetime * 2 / 3)
    else
      effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
        BoUseEffect := False;
      end;
    end;
  end;

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction  := 0; //동작 완료
        BoUseEffect    := False;
        BoUseDieEffect := False;
      end;

      if (CurrentAction = SM_LIGHTING) and (currentframe = 4) then begin
        PlaySound(8202);
        LightningTimer.Enabled := True;
      end else if ((CurrentAction = SM_DRAGON_FIRE1) or
        (CurrentAction = SM_DRAGON_FIRE2) or (CurrentAction = SM_DRAGON_FIRE3)) and
        (currentframe - startframe = 4) then begin

        PlayScene.NewMagic(self,
          CurrentAction, //11,
          CurrentAction,
          XX,
          YY,
          TargetX,
          TargetY,
          TargetRecog,
          mtFly,
          True,
          30,
          bofly);
        PlaySound(8203);
      end;
    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;
end;


procedure TFireDragon.LightningTimerTimer(Sender: TObject);
var
  tx, ty, n, kx, ky: integer;
  bofly: boolean;
begin

  if LightningTimer.Tag = 0 then begin
    LightningTimer.Tag      := LightningTimer.Tag + 1;
    LightningTimer.Interval := 800;
    Exit;
  end else
    LightningTimer.Interval := 70;
  tx := XX - 5;
  ty := YY + 3;

  Randomize;
  if LightningTimer.Tag = 0 then begin
    PlayScene.NewMagic(self, SM_DRAGON_LIGHTING, SM_DRAGON_LIGHTING,
      XX, YY, tx - 3, ty + 3, 0, mtThunder, False, 30, bofly);
    PlayScene.NewMagic(self, SM_DRAGON_LIGHTING, SM_DRAGON_LIGHTING,
      XX, YY, tx - 3, ty - 3, 0, mtThunder, False, 30, bofly);
  end;

  n  := random(4);
  kx := random(7);
  ky := random(5);
  case n of
    0: PlayScene.NewMagic(self, SM_DRAGON_LIGHTING, SM_DRAGON_LIGHTING,
        XX, YY, tx + kx - 2, ty - ky + 1, 0, mtThunder, False, 30, bofly);
    1: PlayScene.NewMagic(self, SM_DRAGON_LIGHTING, SM_DRAGON_LIGHTING,
        XX, YY, tx - kx, ty + ky, 0, mtThunder, False, 30, bofly);
    2: PlayScene.NewMagic(self, SM_DRAGON_LIGHTING, SM_DRAGON_LIGHTING,
        XX, YY, tx - kx, ty - ky + 1, 0, mtThunder, False, 30, bofly);
    3: PlayScene.NewMagic(self, SM_DRAGON_LIGHTING, SM_DRAGON_LIGHTING,
        XX, YY, tx + kx - 2, ty + ky, 0, mtThunder, False, 30, bofly);
  end;

  if (LightningTimer.Tag mod 3) = 0 then
    PlaySound(8206);
  LightningTimer.Interval := LightningTimer.Interval + 15;
  LightningTimer.Tag      := LightningTimer.Tag + 1;

  if LightningTimer.Tag > 7 then begin
    LightningTimer.Interval := 70;
    LightningTimer.Tag      := 0;
    LightningTimer.Enabled  := False;
  end;
end;

procedure TFireDragon.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
begin
  inherited DrawEff(dsurface, dx, dy);
  if BoUseEffect then
    if AttackEffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        AttackEffectSurface, 1);
    end;
end;

// 용조신상(용석상) -----------------------------------------------------------------------------

constructor TDragonStatue.Create;
begin
  inherited Create;
  AttackEffectSurface := nil;
end;

procedure TDragonStatue.LoadSurface;
var
  mimg: TWMImages;
begin
  mimg := FrmMain.WDragonImg;

  if mimg <> nil then
    BodySurface := mimg.GetCachedImage(GetOffset(Appearance), px, py);

  if BoUseEffect then begin
    case Race of
      84, 85, 86: begin // 용석상우
        EffectSurface := FrmMain.WDragonImg.GetCachedImage(
          310 + effectframe, ax, ay);
      end;
      87, 88, 89: begin // 용석상좌
        EffectSurface := FrmMain.WDragonImg.GetCachedImage(
          330 + effectframe, ax, ay);
      end;
    end;
  end;

end;

procedure TDragonStatue.CalcActorFrame;
var
  pm:    PTMonsterAction;
  actor: TActor;
  haircount, scx, scy, stx, sty: integer;
  meff:  TCharEffect;
begin
  Dir := 0;
  currentframe := -1;
  BodyOffset := GetOffset(Appearance);
  pm  := RaceByPm(Race, Appearance);

  case CurrentAction of
    SM_LIGHTING: begin
      startframe := 0;
      endframe   := 9;
      frametime  := 100;
      starttime  := GetTickCount;

      BoUseEffect := True;
      effectstart := 0;
      effectframe := 0;
      effectend   := 9;
      effectstarttime := GetTickCount;
      effectframetime := 100;
    end;
    SM_DIGUP: //걷기 없음, SM_DIGUP, 방향 없음.
    begin
      Shift(0, 0, 0, 1);
      startframe := 0;
      endframe   := 9;
      frametime  := 100;
      starttime  := GetTickCount;
    end;
  end;
end;

procedure TDragonStatue.Run;
var
  prv:   integer;
  effectframetimetime, frametimetime: longword;
  meff:  TFlyingAxe;
  bofly: boolean;
  tx, ty, i: integer;
begin
  Dir := 0;
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  if BoUseEffect then begin
    if msgmuch then
      effectframetimetime := Round(effectframetime * 2 / 3)
    else
      effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
        BoUseEffect := False;
      end;
    end;
  end;

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction  := 0; //동작 완료
        BoUseEffect    := False;
        BoUseDieEffect := False;
      end;

      if (CurrentAction = SM_LIGHTING) and (currentframe = 4) then begin
        PlayScene.NewMagic(self, MAGIC_FIREBURN, MAGIC_FIREBURN,
          XX, YY, TargetX, TargetY, 0, mtThunder, False, 30, bofly);
        PlaySound(8222);
      end;
    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;
end;

procedure TDragonStatue.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
begin
  inherited DrawEff(dsurface, dx, dy);
  if BoUseEffect then
    if EffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        EffectSurface, 1);
    end;
end;

// 주마격뢰장 -----------------------------------------------------------------------------------------

constructor TJumaThunderMon.Create;
begin
  inherited Create;
  BoUseEffect := True;
  AttackEffectSurface := nil;
end;

procedure TJumaThunderMon.LoadSurface;
begin
  inherited LoadSurface;
  case Race of
    //몬스터
    92: begin
      if BoUseEffect then begin
        EffectSurface := FrmMain.WMon23Img.GetCachedImage(effectframe, ax, ay);
        //               DScreen.AddChatBoardString ('$$LoadSurface$$  effectframe=> '+IntToStr(effectframe), clYellow, clRed);
      end;
    end;
  end;
end;

procedure TJumaThunderMon.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
var
  idx:  integer;
  d:    TDirectDrawSurface;
  ceff: TColorEffect;
begin
  if BoUseEffect then
    if EffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        EffectSurface, 1);
    end;
end;

procedure TJumaThunderMon.CalcActorFrame;
var
  pm:    PTMonsterAction;
  actor: TActor;
  haircount, scx, scy, stx, sty: integer;
  meff:  TCharEffect;
begin
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_HIT, // 근거리 공격
    SM_FLYAXE: begin
      BoUseEffect := True;
      startframe  := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe    := startframe + pm.ActAttack.frame - 1;
      frametime   := 110;
      starttime   := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;

      effectframe := 1100 + Dir * 10;
      effectstart := 1100 + Dir * 10;
      effectend   := effectstart + pm.ActAttack.frame - 1;//endframe;
      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;

    SM_TURN: begin
      if (State and STATE_STONE_MODE) <> 0 then begin
        BoUseEffect   := False;
        startframe    := 420 + Dir * 10;
        endframe      := startframe;
        frametime     := 100;
        starttime     := GetTickCount;
        defframecount := 6;
      end else begin
        BoUseEffect   := True;
        startframe    := pm.ActStand.start + Dir *
          (pm.ActStand.frame + pm.ActStand.skip);
        endframe      := startframe + pm.ActStand.frame - 1;
        frametime     := 250;
        starttime     := GetTickCount;
        defframecount := pm.ActStand.frame;

        effectframe := 940 + Dir * 10;
        effectstart := 940 + Dir * 10;
        effectend   := effectstart + pm.ActStand.frame - 1;//endframe;
        effectstarttime := GetTickCount;
        effectframetime := frametime;
      end;
      Shift(Dir, 0, 0, 1);
    end;
    SM_WALK, SM_BACKSTEP: begin
      BoUseEffect := True;
      startframe  := pm.ActWalk.start + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
      endframe    := startframe + pm.ActWalk.frame - 1;
      frametime   := 160; //pm.ActWalk.ftime;
      starttime   := GetTickCount;
      maxtick     := pm.ActWalk.UseTick;
      curtick     := 0;

      effectframe := 1020 + Dir * 10;
      ;
      effectstart := 1020 + Dir * 10;
      ;
      effectend := effectstart + pm.ActWalk.frame - 1;//endframe;
      effectstarttime := GetTickCount;
      effectframetime := frametime;

      //WarMode := FALSE;
      movestep := 1;
      if CurrentAction = SM_WALK then begin
        Shift(Dir, movestep, 0, endframe - startframe + 1);
      end else begin  //sm_backstep
        Shift(GetBack(Dir), movestep, 0, endframe - startframe + 1);
      end;
    end;

    //      SM_ALIVE,
    SM_DIGUP: //걷기 없음, SM_DIGUP, 방향 없음.
    begin
      startframe := 420 + Dir * 10;
      endframe   := startframe + 5;
      frametime  := 150;
      starttime  := GetTickCount;
      //WarMode := FALSE;
      Shift(Dir, 0, 0, 1);
    end;

    SM_STRUCK: begin
      BoUseEffect := True;
      startframe  := pm.ActStruck.start + Dir *
        (pm.ActStruck.frame + pm.ActStruck.skip);
      endframe    := startframe + pm.ActStruck.frame - 1;
      frametime   := 90; //pm.ActStruck.ftime;
      starttime   := GetTickCount;

      effectframe := 1180 + Dir * 10;
      effectstart := 1180 + Dir * 10;
      effectend   := effectstart + pm.ActStruck.frame - 1;//endframe;
      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;

    SM_DEATH: begin
      BoUseEffect := False;
      startframe  := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip);
      endframe    := startframe + pm.ActDie.frame - 1;
      startframe  := endframe;
      frametime   := 100;
      starttime   := GetTickCount;
    end;

    SM_LIGHTING: begin
      BoUseEffect := True;
      //            startframe := 770 + Dir * 10;
      startframe  := 340 + Dir * 10;
      endframe    := startframe + 5;
      frametime   := 180;
      starttime   := GetTickCount;
      CurEffFrame := 0;
      BoUseMagic  := True;
      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);

      effectframe := 1200 + Dir * 10;
      effectstart := 1200 + Dir * 10;
      effectend   := effectstart + 5;//endframe;
      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;
    else
      inherited CalcActorFrame;
  end;
end;

 //----------------------------------------------------------------------------
 //  TFoxWarrior  BlackFoxman
procedure TFoxWarrior.CalcActorFrame;
var
  pm:    PTMonsterAction;
  actor: TActor;
  haircount, scx, scy, stx, sty: integer;
  meff:  TCharEffect;
begin
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_HIT: begin
      startframe := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe   := startframe + pm.ActAttack.frame - 1;
      frametime  := pm.ActAttack.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      {      BoUseEffect := TRUE;
            firedir := Dir;

            effectframe := startframe;
            effectstart := startframe;
            effectend := endframe;

            effectstarttime := GetTickCount;
            effectframetime := frametime;  }
    end;
    SM_LIGHTING:   //크리틱컬 공격
    begin
      startframe := pm.ActCritical.start + Dir *
        (pm.ActCritical.frame + pm.ActCritical.skip);
      endframe   := startframe + pm.ActCritical.frame - 1;
      frametime  := pm.ActCritical.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      firedir     := Dir;

      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;
    SM_NOWDEATH: begin
      startframe := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;

      effectframe := pm.ActDie.start;
      effectstart := pm.ActDie.start;
      effectend   := pm.ActDie.start + pm.ActDie.frame - 1;

      effectstarttime := GetTickCount;
      effectframetime := frametime;

      BoUseEffect := True;
    end;
    else
      inherited CalcActorFrame;
  end;

end;

procedure TFoxWarrior.LoadSurface;
begin
  inherited LoadSurface;
  case Race of
    102: begin
      if BoUseEffect then
        case CurrentAction of
          SM_HIT: ;
          SM_LIGHTING: AttackEffectSurface :=
              FrmMain.WMon24Img.GetCachedImage(
              FOXWARRIOREFFECTBASE + (firedir * 10) +
              effectframe - effectstart, ax, ay);
          SM_NOWDEATH: AttackEffectSurface :=
              FrmMain.WMon24Img.GetCachedImage(
              FOXDEATHEFFECTBASE + effectframe -
              effectstart, ax, ay);
        end;
    end;

  end;
end;

//RedFoxman ==================================================================
constructor TFoxWizard.Create;
begin
  inherited Create;
  AttackEffectSurface := nil;
end;

procedure TFoxWizard.LoadSurface;
begin
  inherited LoadSurface;
  if BoUseDieEffect then begin
    case Race of
      103: DieEffectSurface :=
          FrmMain.WMon24Img.GetCachedImage(FOXDEATHEFFECTBASE +
          currentframe - startframe, bx, by);
      end;

    end;
  end;

procedure TFoxWizard.CalcActorFrame;
var
  pm:    PTMonsterAction;
  actor: TActor;
  haircount, scx, scy, stx, sty: integer;
  meff:  TCharEffect;
begin
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_LIGHTING_1,
    SM_LIGHTING: begin
      if Race = 103 then
        SitDown := False; //이무기
      startframe := pm.ActCritical.start + Dir *
        (pm.ActCritical.frame + pm.ActCritical.skip);
      endframe    := startframe + pm.ActCritical.frame - 1;
      frametime   := pm.ActCritical.ftime;
      starttime   := GetTickCount;
      CurEffFrame := 0;
      BoUseMagic  := True;
      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;
      effectstarttime := GetTickCount;
      effectframetime := frametime;
      end;

  else
      inherited CalcActorFrame;
  end;
end;

procedure TFoxWizard.Run;
var
  prv:   integer;
  effectframetimetime, frametimetime: longword;
  meff:  TFlyingAxe;
  bofly: boolean;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  if BoUseEffect then begin
    if msgmuch then
      effectframetimetime := Round(effectframetime * 2 / 3)
    else
      effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
        BoUseEffect := False;
      end;
    end;
  end;

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction  := 0; //동작 완료
        BoUseEffect    := False;
        BoUseDieEffect := False;
      end;

      if (CurrentAction = SM_LIGHTING_1) and (currentframe - startframe = 4) then begin
        if (Race = 103) then begin    //이무기 멸천화
          //      DScreen.AddChatBoardString ('이무기-SM_LIGHTING_1 //이무기 멸천화', clYellow, clRed);
          PlayScene.NewMagic(self,
            MAGIC_FOX_BANG,
            MAGIC_FOX_BANG,
            XX,
            YY,
            TargetX,
            TargetY,
            TargetRecog,
            mtThunder,
            False,
            30,
            bofly);
          PlaySound(8101);
        end;
      end else if (CurrentAction = SM_LIGHTING) and
        (currentframe - startframe = 4) then begin
        if (Race = 103) then begin    //강격
          PlayScene.NewMagic(self,
            MAGIC_FOX_THUNDER,
            MAGIC_FOX_THUNDER,
            XX,
            YY,
            TargetX,
            TargetY,
            TargetRecog,
            mtThunder,
            False,
            30,
            bofly);
          PlaySound(10112);
        end;
      end;
    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;
end;

procedure TFoxWizard.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
begin
  inherited DrawEff(dsurface, dx, dy);
  if BoUseEffect then
    if AttackEffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        AttackEffectSurface, 1);
    end;
end;

 //  WhiteFoxman =============================================================
 constructor TFoxTao.Create;
begin
  inherited Create;
  AttackEffectSurface := nil;
end;

 procedure TFoxTao.CalcActorFrame;
var
  pm:    PTMonsterAction;
  actor: TActor;
  haircount, scx, scy, stx, sty: integer;
  meff:  TCharEffect;
begin
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of

    SM_WALK, SM_BACKSTEP: begin
      startframe  := pm.ActWalk.start + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
      endframe    := startframe + pm.ActWalk.frame - 1;
      frametime   := pm.ActWalk.ftime;
      starttime   := GetTickCount;
      effectframe := pm.ActWalk.start;
      effectstart := pm.ActWalk.start;
      effectend   := pm.ActWalk.start + pm.ActWalk.frame - 1;
      effectstarttime := GetTickCount;
      effectframetime := frametime;
      BoUseEffect := True;

      maxtick  := pm.ActWalk.UseTick;
      curtick  := 0;
      movestep := 1;
      if CurrentAction = SM_WALK then
        Shift(Dir, movestep, 0, endframe - startframe + 1)
      else  //sm_backstep
        Shift(GetBack(Dir), movestep, 0, endframe - startframe + 1);
    end;
    SM_STRUCK: begin
      startframe := pm.ActStruck.start + Dir *
        (pm.ActStruck.frame + pm.ActStruck.skip);
      endframe   := startframe + pm.ActStruck.frame - 1;
      frametime  := pm.ActStruck.ftime;
      starttime  := GetTickCount;

      effectframe := pm.ActStruck.start;
      effectstart := pm.ActStruck.start;
      effectend   := pm.ActStruck.start + pm.ActStruck.frame - 1;

      effectstarttime := GetTickCount;
      effectframetime := frametime;

      BoUseEffect := True;
    end;

    SM_FLYAXE: begin
      startframe := pm.ActCritical.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe   := startframe + pm.ActAttack.frame - 1;
      frametime  := pm.ActAttack.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      firedir     := Dir;

      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;
    SM_LIGHTING:     //원거리공격
    begin
      startframe := pm.ActCritical.start + Dir *
        (pm.ActCritical.frame + pm.ActCritical.skip);
      endframe   := startframe + pm.ActCritical.frame - 1;
      frametime  := pm.ActCritical.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      firedir     := Dir;

      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;
    SM_LIGHTING_1:     //원거리공격
    begin
      startframe := pm.ActDeath.start + Dir *
        (pm.ActDeath.frame + pm.ActDeath.skip);
      endframe   := startframe + pm.ActDeath.frame - 1;
      frametime  := pm.ActDeath.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      firedir     := Dir;

      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;
    SM_HIT:     //원거리공격
    begin
      startframe := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe   := startframe + pm.ActAttack.frame - 1;
      frametime  := pm.ActAttack.ftime;
      starttime  := GetTickCount;

      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      BoUseEffect := True;
      firedir     := Dir;

      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectstarttime := GetTickCount;
      effectframetime := frametime;
    end;
    SM_NOWDEATH: begin
      startframe := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;

      effectframe := pm.ActDie.start;
      effectstart := pm.ActDie.start;
      effectend   := pm.ActDie.start + pm.ActDie.frame - 1;

      effectstarttime := GetTickCount;
      effectframetime := frametime;

      BoUseEffect := True;
      BoUseDieEffect := True
    end;
    else
      inherited CalcActorFrame;
  end;

end;

procedure TFoxTao.LoadSurface;
begin
  inherited LoadSurface;
  if BoUseDieEffect then begin
    case Race of
      104: DieEffectSurface :=
          FrmMain.WMon24Img.GetCachedImage(FOXDEATHEFFECTBASE +
          currentframe - startframe, bx, by);
      end;

    end;
end;

procedure TFoxTao.Run;
var
  prv:  integer;
  effectframetimetime, frametimetime: longword;
  meff: TFlyingSoulBang;
  meff2: TFlyingCurse;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  if BoUseEffect then begin
    if msgmuch then
      effectframetimetime := Round(effectframetime * 2 / 3)
    else
      effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
        BoUseEffect := False;
      end;
    end;
  end;

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction  := 0; //동작 완료
        BoUseEffect    := False;
        BoUseDieEffect := False;
      end;
      if (CurrentAction = SM_LIGHTING) and (currentframe - startframe = 4) then begin
        meff2 := TFlyingCurse(PlayScene.NewFlyObject(self, XX,
          YY, TargetX, TargetY, TargetRecog, mtFlyCurse));

        if meff2 <> nil then begin
          meff2.ImgLib := FrmMain.WMagic;
          meff2.ImgLib2:= FrmMain.WMon24Img;
          meff2.NextFrameTime := 60;
          meff2.FlyImageBase := FOXTAOAMULETEFFECTBASE;
          meff2.MagExplosionBase := FOXTAOCURSEEFFECTBASE;
        end;
      end;
      if (CurrentAction = SM_FLYAXE) and (currentframe - startframe = 4) then begin
        meff := TFlyingSoulBang(PlayScene.NewFlyObject(self, XX,
          YY, TargetX, TargetY, TargetRecog, mtFlySoulBang));

        if meff <> nil then begin
          meff.ImgLib := FrmMain.WMagic;
          meff.ImgLib2:= FrmMain.WMon24Img;
          meff.NextFrameTime := 40;
          meff.FlyImageBase := FOXTAOAMULETEFFECTBASE;
          meff.MagExplosionBase := FOXTAOSOULBANGEFFECTBASE;
        end;
      end;
    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;
end;

// TrapRock =================================================================
constructor TTrapRock.Create;
begin
  inherited Create;
  AttackEffectSurface := nil;
end;

procedure TTrapRock.LoadSurface;
begin
  inherited LoadSurface;
  end;

procedure TTrapRock.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  BoUseMagic    := False;
  BoUseEffect   := False;
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

      startframe := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe   := startframe + pm.ActAttack.frame - 1;
      frametime  := pm.ActAttack.ftime;
      starttime  := GetTickCount;

      //BoUseEffect := TRUE;
      //firedir := Dir;
      effectframe   := 0; //startframe;
      effectstart   := 0; //startframe;
      effectend     := effectstart + 9;
      //effectstarttime := GetTickCount;
      effectframetime := 50; //frametime;

      Shift(Dir, 0, 0, 1);
    end;
    SM_DIGUP:   //원거리공격
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

      //BoUseEffect := TRUE;
      //firedir := Dir;
      effectframe   := 0; //startframe;
      effectstart   := 0; //startframe;
      effectend     := effectstart + 9;
      //effectstarttime := GetTickCount;
      effectframetime := 50; //frametime;

      Shift(Dir, 0, 0, 1);
    end;
    SM_NOWDEATH:   //원거리공격
    begin
      //case Dir of
      //   7, 6: Dir := 0;
      //   0, 1, 2, 5: Dir := 1;
      //   else Dir := 2;
      //end;
      Dir := 0;
      //inherited CalcActorFrame;

      startframe := pm.ActDie.start + Dir *
        (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;

      //BoUseEffect := TRUE;
      //firedir := Dir;
      effectframe   := 0; //startframe;
      effectstart   := 0; //startframe;
      effectend     := effectstart + 9;
      //effectstarttime := GetTickCount;
      effectframetime := 50; //frametime;

      Shift(Dir, 0, 0, 1);
    end;
    else begin
      Dir := 0;
      inherited CalcActorFrame;
    end;
  end;
end;

procedure TTrapRock.Run;
var
  prv:   integer;
  effectframetimetime, frametimetime: longword;
  meff:  TRockPull;
  bofly: boolean;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  if BoUseEffect then begin
    if msgmuch then
      effectframetimetime := Round(effectframetime * 2 / 3)
    else
      effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
        BoUseEffect := False;
      end;
    end;
  end;

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction  := 0; //동작 완료
        BoUseEffect    := False;
        BoUseDieEffect := False;
      end;
    //  end else if (CurrentAction = SM_HIT) and
    //    (currentframe - startframe = 4) then begin
    //    if (Race = 106) then begin    //강격
    //      PlayScene.NewMagic(self,
      //      MAGIC_ROCK_POISON,
//            MAGIC_ROCK_POISON,
  //          XX,
    //        YY,
      //      TargetX,
        //    TargetY,
          //  TargetRecog,
            //mtThunder,
//            False,
  //          30,
    //        bofly);
      //    PlaySound(157);
    //    end;
      end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;
end;

procedure TTrapRock.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
begin
  inherited DrawEff(dsurface, dx, dy);
  if BoUseEffect then
    if AttackEffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        AttackEffectSurface, 1);
    end;
end;

// GuardianRock =================================================================
constructor TGuardRock.Create;
begin
  inherited Create;
  AttackEffectSurface := nil;
end;

procedure TGuardRock.LoadSurface;
begin
  inherited LoadSurface;
if BoUseEffect then begin
    case Race of
      106: begin
        case CurrentAction of
          SM_HIT: AttackEffectSurface  :=
              FrmMain.WMon24Img.GetCachedImage(1435 +
              effectframe - effectstart, ax, ay);
  end;
  end;
  end;
  end;
  end;

procedure TGuardRock.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  BoUseMagic    := False;
  BoUseEffect   := False;
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

      BoUseEffect := TRUE;
      //firedir := Dir;
      effectframe   := 0; //startframe;
      effectstart   := 0; //startframe;
      effectend     := effectstart + 9;
      //effectstarttime := GetTickCount;
      effectframetime := 50; //frametime;

      Shift(Dir, 0, 0, 1);
    end;
    SM_STRUCK:   //원거리공격
    begin
      //case Dir of
      //   7, 6: Dir := 0;
      //   0, 1, 2, 5: Dir := 1;
      //   else Dir := 2;
      //end;
      Dir := 0;
      //inherited CalcActorFrame;

      startframe := pm.ActDeath.start + Dir *
        (pm.ActDeath.frame + pm.ActDeath.skip);
      endframe   := startframe + pm.ActDeath.frame - 1;
      frametime  := pm.ActDeath.ftime;
      starttime  := GetTickCount;

      //BoUseEffect := TRUE;
      //firedir := Dir;
      effectframe   := 0; //startframe;
      effectstart   := 0; //startframe;
      effectend     := effectstart + 9;
      //effectstarttime := GetTickCount;
      effectframetime := 50; //frametime;

      Shift(Dir, 0, 0, 1);
    end;
    else begin
      Dir := 0;
      inherited CalcActorFrame;
    end;
  end;
end;

procedure TGuardRock.Run;
var
  prv:   integer;
  effectframetimetime, frametimetime: longword;
  meff:  TRockPull;
  bofly: boolean;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  if BoUseEffect then begin
    if msgmuch then
      effectframetimetime := Round(effectframetime * 2 / 3)
    else
      effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
        BoUseEffect := False;
      end;
    end;
  end;

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction  := 0; //동작 완료
        BoUseEffect    := False;
        BoUseDieEffect := False;
      end;
      end else if (CurrentAction = SM_HIT) and
        (currentframe - startframe = 4) then begin
        if (Race = 106) then begin    //강격
          PlayScene.NewMagic(self,
            MAGIC_ROCK_PULL,
            MAGIC_ROCK_PULL,
            XX,
            YY,
            TargetX,
            TargetY,
            TargetRecog,
            mtThunder,
            False,
            30,
            bofly);
          PlaySound(157);
        end;
    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;
end;

procedure TGuardRock.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
begin
  inherited DrawEff(dsurface, dx, dy);
  if BoUseEffect then
    if AttackEffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        AttackEffectSurface, 1);
    end;
end;

// ThunderElement, CloudElement================================================
constructor TElements.Create;
begin
  inherited Create;
  AttackEffectSurface := nil;
  Dir := 0;
end;

procedure TElements.LoadSurface;
begin
  inherited LoadSurface;
  case Race of
    107: begin
      if BoUseEffect then
        case CurrentAction of
          SM_TURN: AttackEffectSurface   :=
              FrmMain.WMon24Img.GetCachedImage(1500 + currentframe, ax, ay);
          SM_WALK, SM_BACKSTEP: AttackEffectSurface     :=
              FrmMain.WMon24Img.GetCachedImage(1500 + currentframe, ax, ay);
          SM_STRUCK: AttackEffectSurface   :=
              FrmMain.WMon24Img.GetCachedImage(1500 + currentframe, ax, ay);
          SM_LIGHTING: AttackEffectSurface      :=
              FrmMain.WMon24Img.GetCachedImage(1500 + currentframe, ax, ay);
          SM_NOWDEATH: AttackEffectSurface :=
              FrmMain.WMon24Img.GetCachedImage(1540 + effectframe - effectstart, ax, ay);
        end;
       end; 
     108: begin
      if BoUseEffect then
        case CurrentAction of
          SM_TURN: AttackEffectSurface   :=
              FrmMain.WMon24Img.GetCachedImage(1610 + currentframe, ax, ay);
          SM_WALK, SM_BACKSTEP: AttackEffectSurface     :=
              FrmMain.WMon24Img.GetCachedImage(1610 + currentframe, ax, ay);
          SM_STRUCK: AttackEffectSurface   :=
              FrmMain.WMon24Img.GetCachedImage(1610 + currentframe, ax, ay);
          SM_LIGHTING: AttackEffectSurface      :=
              FrmMain.WMon24Img.GetCachedImage(1610 + currentframe, ax, ay);
          SM_NOWDEATH: AttackEffectSurface :=
              FrmMain.WMon24Img.GetCachedImage(1650 + effectframe - effectstart, ax, ay);
        end;
   end;
 end;
end;

procedure TElements.CalcActorFrame;
var
  pm: PTMonsterAction;
  Dir2: byte;
  meff: TCharEffect;
begin
  BoUseMagic    := False;
  BoUseEffect   := False;
  currentframe  := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of

    SM_TURN: //방향이 없음...
    begin
    Dir := 0;
      startframe := pm.ActStand.start;
      endframe   := startframe + pm.ActStand.frame - 1;
      frametime  := pm.ActStand.ftime;
      starttime  := GetTickCount;

      BoUseEffect := TRUE;
      effectframe := pm.ActStand.start;
      effectstart := pm.ActStand.start;
      effectend   := pm.ActStand.start + pm.ActStand.frame - 1;

      effectframetime := frametime;
    end;
    SM_WALK, SM_BACKSTEP: begin
      startframe  := pm.ActWalk.start;
      endframe    := startframe + pm.ActWalk.frame - 1;
      frametime   := pm.ActWalk.ftime;
      starttime   := GetTickCount;

      effectframe := pm.ActWalk.start;
      effectstart := pm.ActWalk.start;
      effectend   := pm.ActWalk.start + pm.ActWalk.frame - 1;
      effectstarttime := GetTickCount;

      effectframetime := frametime;
      BoUseEffect := True;

      maxtick := pm.ActWalk.usetick;
      curtick := 0;
      movestep := 1;
   //   if CurrentAction = SM_WALK then
   //     Shift(Dir, movestep, 0, endframe - startframe + 1)
   //      else  //sm_backstep
   //     Shift(GetBack(Dir), movestep, 0, endframe - startframe + 1);
    end;
    SM_LIGHTING:   //원거리공격
    begin
      //inherited CalcActorFrame;
      Dir := 0;
      startframe := pm.ActAttack.start;
      endframe   := startframe + pm.ActAttack.frame - 1;
      frametime  := pm.ActAttack.ftime;
      starttime  := GetTickCount;

      BoUseEffect := TRUE;
      effectframe := pm.ActAttack.start;
      effectstart := pm.ActAttack.start;
      effectend   := pm.ActAttack.start + pm.ActAttack.frame - 1;

      effectframetime := frametime;
    end;
    SM_NOWDEATH:   //원거리공격
    begin
      //inherited CalcActorFrame;
      Dir := 0;
      startframe := pm.ActDie.start;
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;

      BoUseEffect := TRUE;
      effectframe := pm.ActDie.start;
      effectstart := pm.ActDie.start;
      effectend   := pm.ActDie.start + pm.ActDie.frame;

      effectframetime := frametime;

    end;
    SM_STRUCK:   //원거리공격
    begin
    Dir := 0;
      //inherited CalcActorFrame;

      startframe := pm.ActStruck.start;
      endframe   := startframe + pm.ActStruck.frame - 1;
      frametime  := pm.ActStruck.ftime;
      starttime  := GetTickCount;

      BoUseEffect := TRUE;
      effectframe := pm.ActStruck.start;
      effectstart := pm.ActStruck.start;
      effectend   := pm.ActStruck.start + pm.ActStruck.frame - 1;

      effectframetime := frametime;

    end;
    else begin
    Dir := 0;
  //  inherited CalcActorFrame;
    end;
  end;
end;

procedure TElements.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
begin
  inherited DrawEff(dsurface, dx, dy);
  if BoUseEffect then
    if AttackEffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + self.ShiftX,
        dy + ay + self.ShiftY,
        AttackEffectSurface, 1);
    end;
    end;

procedure TElements.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend: boolean; WingDraw: boolean);
var
  nx, ny: integer;
  ceff:   TColorEffect;
begin
  if not (Dir in [0..7]) then
    exit;
  if GetTickCount - loadsurfacetime > 60 * 1000 then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
    //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
  end;

  ceff := GetDrawEffectValue;
  if (BodySurface <> nil) then begin
    blend := False;
    DrawEffSurface(dsurface, BodySurface, dx + px + ShiftX, dy +
      py + ShiftY, blend, ceff);
  end;

end;

function TElements.GetDefaultFrame(wmode: boolean): integer;
var
  cf, dr: integer;
  pm:     PTMonsterAction;
begin
  Result := 0;
  pm     := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  if Death then begin
      Result := pm.ActDie.start +
        (pm.ActDie.frame - 1);
  end else begin
    defframecount := pm.ActStand.frame;
    if currentdefframe < 0 then
      cf := 0
    else if currentdefframe >= pm.ActStand.frame then
      cf := 0
    else
      cf := currentdefframe;
    Result := pm.ActStand.start + cf;
  end;
end;

procedure TElements.Run;
var
  prv: integer;
  effectframetimetime, frametimetime: longword;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  if BoUseEffect then begin
    if msgmuch then
      effectframetimetime := Round(effectframetime * 2 / 3)
    else
      effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
      if Death then
      BoUseEffect := False
      else if
      Race = 107 then
      AttackEffectSurface   := FrmMain.WMon24Img.GetCachedImage(1500 + currentframe, ax, ay)
      else
      AttackEffectSurface   := FrmMain.WMon24Img.GetCachedImage(1610 + currentframe, ax, ay);
      end;
    end;
  end;

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction  := 0; //동작 완료
        BoUseDieEffect := False;
      end;

    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > frametime then begin
      if GetTickCount - defframetime > frametime then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;

end;

// GreatFoxSpirit ================================================
constructor TKingElement.Create;
begin
  inherited Create;
  AttackEffectSurface := nil;
  Dir := 0;
end;

procedure TKingElement.LoadSurface;
begin
  inherited LoadSurface;
  case Race of
    109: begin
      if BoUseEffect then
        case CurrentAction of
          SM_TURN, SM_LIGHTING: AttackEffectSurface   :=
              FrmMain.WMon24Img.GetCachedImage(1710 + currentframe, ax, ay);
          SM_STRUCK: AttackEffectSurface   :=
              FrmMain.WMon24Img.GetCachedImage(1710 + currentframe, ax, ay);
          SM_NOWDEATH: AttackEffectSurface :=
              FrmMain.WMon24Img.GetCachedImage(2090 + effectframe - effectstart, ax, ay);
        end;
   end;
 end;
end;

procedure TKingElement.CalcActorFrame;
var
  pm: PTMonsterAction;
  Dir2: byte;
  meff: TCharEffect;
begin
  BoUseMagic    := False;
  BoUseEffect   := True;
  currentframe  := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of

    SM_TURN, SM_LIGHTING: //방향이 없음...
    begin
    Dir := 0;
      startframe := pm.ActStand.start + (Level * 80);
      endframe   := startframe + pm.ActStand.frame - 1;
      frametime  := pm.ActStand.ftime;
      starttime  := GetTickCount;

      BoUseEffect := TRUE;
      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectframetime := frametime;
    end;
    SM_NOWDEATH:   //원거리공격
    begin
      //inherited CalcActorFrame;
      Dir := 0;
      startframe := pm.ActDie.start;
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;

      BoUseEffect := TRUE;
      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectframetime := frametime;

    end;
    SM_STRUCK:   //원거리공격
    begin
    Dir := 0;
      //inherited CalcActorFrame;

      startframe := pm.ActStruck.start + (Level * 80);
      endframe   := startframe + pm.ActStruck.frame - 1;
      frametime  := pm.ActStruck.ftime;
      starttime  := GetTickCount;

      BoUseEffect := TRUE;
      effectframe := startframe;
      effectstart := startframe;
      effectend   := endframe;

      effectframetime := frametime;

    end;
    else begin
    Dir := 0;
  //  inherited CalcActorFrame;
    end;
  end;
end;

procedure TKingElement.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
begin
  inherited DrawEff(dsurface, dx, dy);
  if BoUseEffect then
    if AttackEffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + self.ShiftX,
        dy + ay + self.ShiftY,
        AttackEffectSurface, 1);
    end;
    end;

procedure TKingElement.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend: boolean; WingDraw: boolean);
var
  nx, ny: integer;
  ceff:   TColorEffect;
begin
  if not (Dir in [0..7]) then
    exit;
  if GetTickCount - loadsurfacetime > 60 * 1000 then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
    //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
  end;

  ceff := GetDrawEffectValue;
  if (BodySurface <> nil) then begin
    blend := False;
    DrawEffSurface(dsurface, BodySurface, dx + px + ShiftX, dy +
      py + ShiftY, blend, ceff);
  end;

end;

function TKingElement.GetDefaultFrame(wmode: boolean): integer;
var
  cf, dr: integer;
  pm:     PTMonsterAction;
begin
  Result := 0;
  pm     := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  if Death then begin
      Result := pm.ActDie.start +
        (pm.ActDie.frame - 1);
  end else begin
    defframecount := pm.ActStand.frame;
    if currentdefframe < 0 then
      cf := 0
    else if currentdefframe >= pm.ActStand.frame then
      cf := 0
    else
      cf := currentdefframe;
    Result := pm.ActStand.start + (Level * 80) + cf;
  end;
end;

procedure TKingElement.Run;
var
  prv: integer;
  effectframetimetime, frametimetime: longword;
begin
if self.Abil.HP < self.Abil.MaxHP * 0.20 then
Level := 4
else
if self.Abil.HP < self.Abil.MaxHP * 0.40 then
Level := 3
else
if self.Abil.HP < self.Abil.MaxHP * 0.60 then
Level := 2
else
if self.Abil.HP < self.Abil.MaxHP * 0.80 then
Level := 1
else

  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;


  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  if BoUseEffect then begin
    if msgmuch then
      effectframetimetime := Round(effectframetime * 2 / 3)
    else
      effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
      if Death then
      BoUseEffect := False
      else
      AttackEffectSurface   := FrmMain.WMon24Img.GetCachedImage(1710 + currentframe, ax, ay)
      end;
    end;
  end;

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction  := 0; //동작 완료
        BoUseDieEffect := False;
      end;

    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > frametime then begin
      if GetTickCount - defframetime > frametime then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;

end;

{============================= Big Kektals =============================}

procedure TBigKekTal.Run;
var
  prv:  integer;
  frametimetime: longword;
  meff: TFlyingAxe;
begin
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) then
    exit;

  msgmuch := False;
  if MsgList.Count >= 2 then
    msgmuch := True;

  //사운드 효과
  RunActSound(currentframe - startframe);
  //프래임마다 해야 할일
  RunFrameAction(currentframe - startframe);

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        Inc(currentframe);
        starttime := GetTickCount;
      end else begin
        //동작이 끝남.
        CurrentAction := 0; //동작 완료
        BoUseEffect   := False;
      end;
      if (CurrentAction = SM_FLYAXE) and (currentframe - startframe = 4) then begin
        //화살 나감
        //(** 6월패치

        meff := TFlyingArrow(PlayScene.NewFlyObject(self, XX,
          YY, TargetX, TargetY, TargetRecog, mtFlySpikes));
        if meff <> nil then begin
          meff.ImgLib := FrmMain.WMon24Img;
          meff.NextFrameTime := 30;
        if Race = 110 then
          meff.FlyImageBase := 2356
          else
          meff.FlyImageBase := 2786
        end;
        //**)
(** 이전
            meff := TFlyingArrow (PlayScene.NewFlyObject (self,
                             XX,
                             YY,
                             TargetX,
                             TargetY,
                             TargetRecog,
                             mtFlyAxe));
            if meff <> nil then begin
               meff.ImgLib := FrmMain.WMon5Img;
               meff.NextFrameTime := 30;
               meff.FlyImageBase := ARCHERBASE;
            end;
//**)
      end;
    end;
    currentdefframe := 0;
    defframetime    := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;

end;

end.
