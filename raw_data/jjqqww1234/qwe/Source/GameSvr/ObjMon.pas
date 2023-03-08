unit ObjMon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  ScktComp, syncobjs, MudUtil, HUtil32, Grobal2, Envir, EdCode, ObjBase,
  Event;

type
  TMonster = class(TAnimal)
  private
    thinktime: longword;
  protected
    RunDone: boolean;
    DupMode: boolean;
    function AttackTarget: boolean; dynamic;
  public
    constructor Create;
    destructor Destroy; override;
    function MakeClone(mname: string; src: TCreature): TCreature;
    procedure RunMsg(msg: TMessageInfo); override;
    procedure Run; override;
    function Think: boolean;
    procedure RecalcAbilitys; override;
  end;

  TChickenDeer = class(TMonster)
  public
    constructor Create;
    procedure Run; override;
  end;


  TATMonster = class(TMonster)
  private
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Run; override;
  end;

  TSlowATMonster = class(TATMonster)
  public
    constructor Create;
  end;

  TScorpion = class(TATMonster)
  private
  public
    constructor Create;
  end;

  TSpitSpider = class(TATMonster)
  private
  public
    BoUsePoison: boolean;
    constructor Create;
    procedure SpitAttack(dir: byte);
    function AttackTarget: boolean; override;
  end;

  THighRiskSpider = class(TSpitSpider)
  public
    constructor Create;
  end;

  TBigPoisionSpider = class(TSpitSpider)
  public
    constructor Create;
  end;

  TGasAttackMonster = class(TATMonster)
  private
  public
    constructor Create;
    function GasAttack(dir: byte): TCreature; dynamic;
    function AttackTarget: boolean; override;
  end;

  TCowMonster = class(TATMonster)
  public
    constructor Create;
  end;

  TMagCowMonster = class(TATMonster)
  private
  public
    constructor Create;
    procedure MagicAttack(dir: byte);
    function AttackTarget: boolean; override;
  end;

  TCowKingMonster = class(TAtMonster)
  private
    JumpTime:      longword;  //순간이동을 한다.
    CrazyReadyMode: boolean;
    CrazyKingMode: boolean;
    CrazyCount:    integer;
    crazyready:    longword;
    crazytime:     longword;
    oldhittime:    integer;
    oldwalktime:   integer;
  public
    constructor Create;
    procedure Attack(target: TCreature; dir: byte); override;
    procedure Initialize; override;
    procedure Run; override;
  end;

  TLightingZombi = class(TMonster) //도망가지 않고 공격함,
  private
  public
    constructor Create;
    procedure LightingAttack(dir: integer);
    procedure Run; override;
  end;


  TDigOutZombi = class(TMonster)
  protected
    procedure ComeOut;
  public
    constructor Create;
    procedure Run; override;
  end;

  TZilKinZombi = class(TATMonster)
  private
    deathstart: longword;
    LifeCount:  integer; //남은 재생
    RelifeTime: longword;
  public
    constructor Create;
    procedure Run; override;
    procedure Die; override;
  end;

  TWhiteSkeleton = class(TATMonster)
  private
    bofirst: boolean;
  public
    constructor Create;
    procedure RecalcAbilitys; override;
    procedure ResetSkeleton;
    procedure Run; override;
  end;



  TScultureMonster = class(TMonster)
  private
  public
    constructor Create;
    procedure MeltStone;
    procedure MeltStoneAll;
    procedure Run; override;
  end;

  TScultureKingMonster = class(TMonster)
  private
    DangerLevel: integer;
    childlist:   TList;  //만들어 낸 부하의 리스트
  public
    BoCallFollower: boolean;
    constructor Create;
    destructor Destroy; override;
    procedure CallFollower; dynamic;
    procedure MeltStone;
    procedure Attack(target: TCreature; dir: byte); override;
    procedure Run; override;
  end;

  TGasMothMonster = class(TGasAttackMonster)
  public
    constructor Create;
    procedure Run; override;
    function GasAttack(dir: byte): TCreature; override;
  end;

  TGasDungMonster = class(TGasAttackMonster)
  public
    constructor Create;
  end;

  TElfMonster = class(TMonster)
  private
    bofirst: boolean;
  public
    constructor Create;
    procedure RecalcAbilitys; override;
    procedure ResetElfMon;
    procedure AppearNow;
    procedure Run; override;
  end;

  TElfWarriorMonster = class(TSpitSpider)
  private
    bofirst: boolean;
    changefacetime: longword;
  public
    constructor Create;
    procedure RecalcAbilitys; override;
    procedure ResetElfMon;
    procedure AppearNow;
    procedure Run; override;
  end;

  TCriticalMonster = class(TATMonster)   ///강력한 크리티컬을 가하는 몬스터
  public
    criticalpoint: integer;
    constructor Create;
    procedure Attack(target: TCreature; dir: byte); override;
  end;

  TDoubleCriticalMonster = class(TATMonster)   ///강력한 두칸 크리티컬을 가하는 몬스터
  public
    criticalpoint: integer;
    constructor Create;
    procedure DoubleCriticalAttack(dam: integer; dir: byte);
    procedure Attack(target: TCreature; dir: byte); override;
  end;

  // 2003/02/11 해골반왕, 해골병졸 (원거리 직접공격)
  TSkeletonKingMonster = class(TScultureKingMonster)
  public
    RunDone:   boolean;
    ChainShot: integer;
    ChainShotCount: integer;
    constructor Create;
    procedure CallFollower; override;
    procedure Attack(target: TCreature; dir: byte); override;
    procedure Run; override;
    procedure RangeAttack(targ: TCreature); dynamic;
    procedure RangeAttack2(targ: TCreature); dynamic;
    procedure MoveSelf; dynamic;
    function AttackTarget: boolean; override;
  end;
  // 2003/02/11 해골병졸 (원거리 직접공격)
  TSkeletonSoldier = class(TATMonster)
  private
  public
    constructor Create;
    procedure RangeAttack(dir: byte);
    function AttackTarget: boolean; override;
  end;

  // 2003/03/04 사우천왕 (근거리 직접공격, 원거리 마법공격, 스플레쉬 데미지)
  TDeadCowKingMonster = class(TSkeletonKingMonster)
  public
    constructor Create;
    procedure Attack(target: TCreature; dir: byte); override;
    procedure RangeAttack(targ: TCreature); override;
    function AttackTarget: boolean; override;
  end;
  // 2003/03/04 반야좌/우사 (근거리 마법공격, 원거리 마법공격)
  TBanyaGuardMonster = class(TSkeletonKingMonster)
  public
    constructor Create;
    procedure Attack(target: TCreature; dir: byte); override;
    procedure RangeAttack(targ: TCreature); override;
    function AttackTarget: boolean; override;
  end;

  // 2003/07/15 과거비천 마계석
  TStoneMonster = class(TMonster)
  public
    constructor Create;
    procedure Run; override;
  end;

  TPBKingMonster = class(TDeadCowKingMonster)
  public
    constructor Create;
    procedure Attack(target: TCreature; dir: byte); override;
    procedure RangeAttack(targ: TCreature); override;
    function AttackTarget: boolean; override;
    procedure Run; override;
  end;

  TGoldenImugi = class(TATMonster)
  public
    DontAttack:   boolean;
    DontAttackCheck: boolean;
    AttackState:  boolean;
    InitialState: boolean;
    ChildMobRecalled: boolean;
    FinalWarp:    boolean;
    FirstCheck:   boolean;
    TwinGenDelay: integer;
    sectick:      longword;
    RevivalTime:  longword;
    WarpTime:     longword;
    TargetTime:   longword;
    RangeAttackTime: longword;
    OldTargetCret: TCreature;
    constructor Create;
    procedure Attack(targ: TCreature; dir: byte); override;
    procedure RangeAttack(targ: TCreature);
    procedure RangeAttack2(targ: TCreature);
    function AttackTarget: boolean; override;
    procedure Struck(hiter: TCreature); override;
    procedure RunMsg(msg: TMessageInfo); override;
    procedure Run; override;
    procedure Die; override;
  end;

  TFoxWizard = class(TSkeletonKingMonster)
  public
    constructor Create;
    procedure Attack(target: TCreature; dir: byte); override;
    procedure RangeAttack(targ: TCreature); override;
    procedure RangeAttack2(targ: TCreature); override;
    procedure MoveSelf; override;
    function AttackTarget: boolean; override;
  end;

  TFoxTao = class(TSkeletonKingMonster)           //WhiteFoxman
  public
    constructor Create;
    procedure Attack(target: TCreature; dir: byte); override;
    procedure CallFollower; override;
    procedure RangeAttack(targ: TCreature); override;
    procedure RangeAttack2(targ: TCreature); override;
    procedure MoveSelf; override;
    function AttackTarget: boolean; override;
  end;

  TFakeRock = class(TAnimal)
  protected
    RunDone:      boolean;
    DigupRange:   integer;
    DigdownRange: integer;
    function AttackTarget: boolean; dynamic;
    procedure ComeOut; dynamic;
    procedure ComeDown; dynamic;
    procedure CheckComeOut; dynamic;
  public
    constructor Create;
    procedure Struck(hiter: TCreature); override;
    procedure Run; override;
  end;

  TGuardRock = class(TATMonster)   ///GuardianRock
  public
    constructor Create;
    procedure Attack(target: TCreature; dir: byte); override;
    procedure Run; override;
    procedure Struck(hiter: TCreature); override;
    procedure RangeAttack(target: TCreature); dynamic;
    function AttackTarget: boolean; override;
  end;

  TElementOfThunder = class(TATMonster)   ///ThunderElement
  public
    constructor Create;
    procedure Attack(target: TCreature; dir: byte); override;
    procedure Run; override;
    procedure Struck(hiter: TCreature); override;
    procedure RangeAttack(target: TCreature); dynamic;
    function AttackTarget: boolean; override;
  end;

  TElementOfPoison = class(TElementOfThunder)   ///ThunderElement
  public
    procedure RangeAttack(target: TCreature); override;
  end;

  TKingElement = class(TATMonster)   ///GreatFoxSpirit
  protected
    rocklist: TList;
    CheckRocks: boolean;
  public
    constructor Create;
  //  procedure RecalcAbilitys; override;
    procedure Die; override;
    procedure Attack(target: TCreature; dir: byte); override;
    procedure Run; override;
    procedure Struck(hiter: TCreature); override;
    procedure RangeAttack(target: TCreature); dynamic;
    procedure RangeAttack2(target: TCreature); dynamic;
    procedure MassAttack(target: TCreature); dynamic;
    function AttackTarget: boolean; override;
  end;

implementation

uses
  svMain, M2Share;

constructor TMonster.Create;
begin
  inherited Create;
  DupMode     := False;
  RunDone     := False;
  thinktime   := GetTickCount;
  ViewRange   := 5;
  RunNextTick := 250;
  SearchRate  := 3000 + longword(Random(2000));
  SearchTime  := GetTickCount;
  RaceServer  := RC_MONSTER;
end;

destructor TMonster.Destroy;
begin
  inherited Destroy;
end;

function TMonster.MakeClone(mname: string; src: TCreature): TCreature;
var
  mon: TCreature;
begin
  Result := nil;
  mon    := UserEngine.AddCreatureSysop(src.PEnvir.MapName, src.CX, src.CY, mname);
  if mon <> nil then begin
    mon.Master := src.Master;
    mon.MasterRoyaltyTime := src.MasterRoyaltyTime;
    mon.SlaveMakeLevel := src.SlaveMakeLevel;
    mon.SlaveExpLevel := src.SlaveExpLevel;
    mon.RecalcAbilitys; //ApplySlaveLevelAbilitys;
    mon.ChangeNameColor;
    if src.Master <> nil then begin
      src.Master.SlaveList.Add(mon);
    end;

    //능력치, 상태 복사
    mon.WAbil := src.WAbil;
    Move(src.StatusArr, mon.StatusArr, sizeof(word) * STATUSARR_SIZE);
    Move(src.StatusValue, mon.StatusValue, sizeof(byte) * STATUSARR_SIZE);
    mon.TargetCret := src.TargetCret;
    mon.TargetFocusTime := src.TargetFocusTime;
    mon.LastHiter := src.LastHiter;
    mon.LastHitTime := src.LastHitTime;
    mon.Dir := src.Dir;

    Result := mon;
  end;
end;

procedure TMonster.RunMsg(msg: TMessageInfo);
begin
  //case msg.Ident of
  //   RM_DELAYATTACK:
  //     begin
  //        attack (TCreature(msg.lparam1), msg.wparam);
  //     end;
  //  else
  inherited RunMsg(msg);
  //end;
end;

function TMonster.Think: boolean;
var
  oldx, oldy: integer;
begin
  Result := False;
  if GetTickCount - ThinkTime > 3000 then begin
    ThinkTime := GetTickCount;
    if PEnvir.GetDupCount(CX, CY) >= 2 then begin
      DupMode := True;
    end;
    if not IsProperTarget(TargetCret) then
      TargetCret := nil;
  end;

  //자리가 중복된 경우 자리를 피한다.
  // 고정몬스터는 자리를 움지이지 않는다. not BoDontMove
  if DupMode and (not BoDontMove) then begin
    oldx := self.CX;
    oldy := self.CY;
    WalkTo(Random(8), False);
    if (oldx <> self.CX) or (oldy <> self.CY) then begin
      DupMode := False;
      Result  := True;
    end;
  end;

end;

function TMonster.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if TargetCret <> nil then begin
    if TargetInAttackRange(TargetCret, targdir) then begin
      if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
        HitTime := GetCurrentTime;
        TargetFocusTime := GetTickCount;
        Attack(TargetCret, targdir);
        BreakHolySeize;
      end;
      Result := True;
    end else begin
      if TargetCret.MapName = self.MapName then
        SetTargetXY(TargetCret.CX, TargetCret.CY)
      else
        LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
    end;
  end;
end;

procedure TMonster.Run;
var
  rx, ry, bx, by: integer;
begin
  //   if (not BoGhost) and (not Death) and (not HideMode) and (not BoStoneMode) and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if not HideMode and not BoStoneMode and IsMoveAble then begin
    if Think then begin //겹치지 않게 함
      inherited Run;
      exit;
    end;
    if BoWalkWaitMode then begin
      if integer(GetTickCount - WalkWaitCurTime) > WalkWaitTime then
        BoWalkWaitMode := False;
    end;

    if not BoWalkWaitMode and (GetCurrentTime - WalkTime > GetNextWalkTime) then begin
      WalkTime := GetCurrentTime;
      Inc(WalkCurStep);
      if WalkCurStep > WalkStep then begin
        WalkCurStep     := 0;
        BoWalkWaitMode  := True;
        WalkWaitCurTime := GetTickCount;
      end;

      if not BoRunAwayMode then begin
        if not NoAttackMode then begin
          if TargetCret <> nil then begin
            if AttackTarget then begin
              //---------------------(sonmg 2004/12/27)
              if (Master <> nil) then begin
                //공격중에 주인이 강제로 부르면
                if ForceMoveToMaster then begin
                  ForceMoveToMaster := False;
                  GetBackPosition(Master, bx, by);  //주인의 뒤로 감
                  TargetX := bx;
                  TargetY := by;
                  SpaceMove(Master.PEnvir.MapName, TargetX, TargetY, 1);
                end;
              end;
              //---------------------
              inherited Run;
              exit;
            end;
          end else begin
            TargetX := -1;
            if BoHasMission then begin
              TargetX := Mission_X;
              TargetY := Mission_Y;
            end;
          end;
        end;
        if (Master <> nil) then begin
          //소환수가 공격 중일 때는 왜 Master를 인식할 수 없을까? AttackTarget다음에 차단되기 때문...
          if (TargetCret = nil) or (BoLoseTargetMoment) then begin
            //주인이 있으면 주인을 따라간다.
            BoLoseTargetMoment := False;
            GetBackPosition(Master, bx, by);  //주인의 뒤로 감
            if (abs(TargetX - bx) > 1) or (abs(TargetY - bx) > 1) then begin
              TargetX := bx;
              TargetY := by;
              if (abs(CX - bx) <= 2) and (abs(CY - by) <= 2) then begin
                if PEnvir.GetCreature(bx, by, True) <> nil then begin
                  TargetX := CX;  //더 이상 움직이지 않는다.
                  TargetY := CY;
                end;
              end;
            end;
          end;
          //주인과 너무 떨어져 있으면...
          if ForceMoveToMaster or ((not Master.BoSlaveRelax) and
            ((PEnvir <> Master.PEnvir) or (abs(CX - Master.CX) > 20) or
            (abs(CY - Master.CY) > 20))) then begin
            ForceMoveToMaster := False;
            //-------------(sonmg 2004/12/24)
            GetBackPosition(Master, bx, by);  //주인의 뒤로 감
            TargetX := bx;
            TargetY := by;
            //-------------
            SpaceMove(Master.PEnvir.MapName, TargetX, TargetY, 1);
          end;
        end;
      end else begin
        //도망가는 모드이면 TargetX, TargetY로 도망감...
        if RunAwayTime > 0 then begin  //시간 제한이 있음
          if GetTickCount - RunAwayStart > longword(RunAwayTime) then begin
            BoRunAwayMode := False;
            RunAwayTime   := 0;
          end;
        end;
      end;

      if Master <> nil then begin
        if Master.BoSlaveRelax then begin
          //주인이 휴식하라고 함...
          inherited Run;
          exit;
        end;
      end;

      if TargetX <> -1 then begin //가야할 곳이 있음
        GotoTargetXY;
      end else begin
        // 2003/03/18 시야내에 아무도 없으면 배회하지 않음
        if (TargetCret = nil) and ((RefObjCount > 0) or (HideMode)) then
          //          if (TargetCret = nil) then
          Wondering; //배회함
      end;
    end;
  end;

  inherited Run;
end;

procedure TMonster.RecalcAbilitys;
var
  i, oldlight, n, m: integer;
  cghi:     array[0..3] of boolean;
  pstd:     PTStdItem;
  temp:     TAbility;
  oldhmode: boolean;
begin
  // MainOutMessage ('[TMonster.RecalcAbilitys] ' + UserName );
  FillChar(AddAbil, sizeof(TAddAbility), 0);
  temp      := WAbil;
  WAbil     := Abil;
  WAbil.HP  := temp.HP;
  WAbil.MP  := temp.MP;
  WAbil.Weight := 0;
  WAbil.WearWeight := 0;
  WAbil.HandWeight := 0;
  AntiPoison := 0; //기본 2%(sonmg)
  PoisonRecover := 0;
  HealthRecover := 0;
  SpellRecover := 0;
  AntiMagic := 1;   //기본 10% => 2%
  Luck      := 0;
  HitSpeed  := 0;
  oldhmode  := BoHumHideMode;
  BoHumHideMode := False;

  //특수한 능력
  BoAbilSpaceMove := False;
  BoAbilMakeStone := False;
  BoAbilRevival := False;
  BoAddMagicFireball := False;
  BoAddMagicHealing := False;
  BoAbilAngerEnergy := False;
  BoMagicShield := False;
  BoAbilSuperStrength := False;
  BoFastTraining := False;
  BoAbilSearch := False;

  if (BoFixedHideMode) and (StatusArr[STATE_TRANSPARENT] > 0) then  //은신술
    BoHumHideMode := True;

  if BoHumHideMode then begin
    if not oldhmode then begin
      CharStatus := GetCharStatus;
      CharStatusChanged;
    end;
  end else begin
    if oldhmode then begin
      StatusArr[STATE_TRANSPARENT] := 0;
      CharStatus := GetCharStatus;
      CharStatusChanged;
    end;
  end;

  //AccuracyPoint, SpeedPoint 저설정, 무술로 올라간다.
  RecalcHitSpeed;

  SpeedPoint := SpeedPoint + AddAbil.SPEED;
  AccuracyPoint := AccuracyPoint + AddAbil.HIT;
  AntiPoison := AntiPoison + AddAbil.AntiPoison;
  PoisonRecover := PoisonRecover + AddAbil.PoisonRecover;
  HealthRecover := HealthRecover + AddAbil.HealthRecover;
  SpellRecover := SpellRecover + AddAbil.SpellRecover;
  AntiMagic := AntiMagic + AddAbil.AntiMagic;
  Luck     := Luck + AddAbil.Luck;
  Luck     := Luck - AddAbil.UnLuck;
  HitSpeed := AddAbil.HitSpeed;

  WAbil.MaxHP := Abil.MaxHP + AddAbil.HP;
  WAbil.MaxMP := Abil.MaxMP + AddAbil.MP;

  WAbil.AC  := MakeWord(Lobyte(AddAbil.AC) + Lobyte(Abil.AC),
    Hibyte(AddAbil.AC) + Hibyte(Abil.AC));
  WAbil.MAC := MakeWord(Lobyte(AddAbil.MAC) + Lobyte(Abil.MAC),
    Hibyte(AddAbil.MAC) + Hibyte(Abil.MAC));
  WAbil.DC  := MakeWord(Lobyte(AddAbil.DC) + Lobyte(Abil.DC),
    Hibyte(AddAbil.DC) + Hibyte(Abil.DC));
  WAbil.MC  := MakeWord(Lobyte(AddAbil.MC) + Lobyte(Abil.MC),
    Hibyte(AddAbil.MC) + Hibyte(Abil.MC));
  WAbil.SC  := MakeWord(Lobyte(AddAbil.SC) + Lobyte(Abil.SC),
    Hibyte(AddAbil.SC) + Hibyte(Abil.SC));

  //마법으로 걸린 설정
  if StatusArr[STATE_DEFENCEUP] > 0 then begin //방어력 상승
{
      WAbil.AC := MakeWord ( Lobyte(WAbil.AC), // + 2 + (Abil.Level div 8),
                             Hibyte(WAbil.AC) + 2 + (Abil.Level div 7) );
}
    //새 공식(sonmg 2005/06/03)
    WAbil.AC := MakeWord(Lobyte(WAbil.AC), _MIN(
      255, Hibyte(WAbil.AC) + (Abil.Level div 7) + StatusValue[STATE_DEFENCEUP]));
  end;
  if StatusArr[STATE_HITSPEEDUP] > 0 then begin //Assassin Skill 3
    HitSpeed := HitSpeed + StatusValue[STATE_HITSPEEDUP];
  end;
  if StatusArr[STATE_MAGDEFENCEUP] > 0 then begin //마항력 상승
{
      WAbil.MAC := MakeWord ( Lobyte(WAbil.MAC), // + 2 + (Abil.Level div 8),
                              Hibyte(WAbil.MAC) + 2 + (Abil.Level div 7) );
}
    //새 공식(sonmg 2005/06/03)
    WAbil.MAC := MakeWord(Lobyte(WAbil.MAC), _MIN(
      255, Hibyte(WAbil.MAC) + (Abil.Level div 7) + StatusValue[STATE_MAGDEFENCEUP]));
  end;

  //물약으로 증사한 능력 설정
  if ExtraAbil[EABIL_DCUP] > 0 then begin
    WAbil.DC := MakeWord(Lobyte(WAbil.DC), Hibyte(WAbil.DC) +
      ExtraAbil[EABIL_DCUP]);
  end;
  if ExtraAbil[EABIL_MCUP] > 0 then begin
    WAbil.MC := MakeWord(Lobyte(WAbil.MC), Hibyte(WAbil.MC) +
      ExtraAbil[EABIL_MCUP]);
  end;
  if ExtraAbil[EABIL_SCUP] > 0 then begin
    WAbil.SC := MakeWord(Lobyte(WAbil.SC), Hibyte(WAbil.SC) +
      ExtraAbil[EABIL_SCUP]);
  end;
  if ExtraAbil[EABIL_HITSPEEDUP] > 0 then begin
    HitSpeed := HitSpeed + ExtraAbil[EABIL_HITSPEEDUP];
  end;
  if ExtraAbil[EABIL_HPUP] > 0 then begin
    WAbil.MaxHP := WAbil.MaxHP + ExtraAbil[EABIL_HPUP];
  end;
  if ExtraAbil[EABIL_MPUP] > 0 then begin
    WAbil.MaxMP := WAbil.MaxMP + ExtraAbil[EABIL_MPUP];
  end;

  if RaceServer >= RC_ANIMAL then begin
    //if Master <> nil then
    ApplySlaveLevelAbilitys;
  end;
end;

{----------------------------------------------------------------------}


constructor TChickenDeer.Create;
begin
  inherited Create;
  ViewRange := 5;
end;

procedure TChickenDeer.Run;
var
  i, d, dis, ndir, runx, runy: integer;
  cret, nearcret: TCreature;
begin
  dis      := 9999;
  nearcret := nil;
  //   if not Death and not RunDone and not BoGhost and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if not RunDone and IsMoveAble then begin
    if GetCurrentTime - WalkTime > GetNextWalkTime then begin
      //상속받은 run 에서 WalkTime 재설정함.
      for i := 0 to VisibleActors.Count - 1 do begin
        cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
        if (not cret.Death) and (IsProperTarget(cret)) and
          (not cret.BoHumHideMode or BoViewFixedHide) then begin
          d := abs(CX - cret.CX) + abs(CY - cret.CY);
          if d < dis then begin
            dis      := d;
            nearcret := cret;
          end;
        end;
      end;
      if nearcret <> nil then begin
        BoRunAwayMode := True; //달아나는 모드
        TargetCret    := nearcret;
      end else begin
        BoRunAwayMode := False;
        TargetCret    := nil;
      end;
    end;
    if BoRunAwayMode and (TargetCret <> nil) then begin
      if GetCurrentTime - WalkTime > GetNextWalkTime then begin
        //상속받은 run에서 WalkTime 재설정함
        if (abs(CX - TargetCret.CX) <= 6) and (abs(CY - TargetCret.CY) <= 6) then begin
          //도망감.
          ndir := GetNextDirection(TargetCret.CX, TargetCret.CY, CX, CY);
          GetNextPosition(PEnvir, TargetCret.CX, TargetCret.CY,
            ndir, 5, TargetX, TargetY);
        end;
      end;
    end;
  end;
  inherited Run;
end;

{------------------- TATMonster -------------------}

constructor TATMonster.Create;
begin
  inherited Create;
  SearchRate := 1500 + longword(Random(1500));
end;

destructor TATMonster.Destroy;
begin
  inherited Destroy;
end;

procedure TATMonster.Run;   //가장 가까운 놈부터 공격한다.
begin
  //   if not Death and not RunDone and not BoGhost and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if not RunDone and IsMoveAble then begin
    if (GetTickCount - SearchEnemyTime > 8000) or
      ((GetTickCount - SearchEnemyTime > 1000) and (TargetCret = nil)) then begin
      SearchEnemyTime := GetTickCount;
      MonsterNormalAttack;
    end;
  end;
  inherited Run;
end;


{---------------------------------------------------------------------------}

constructor TSlowATMonster.Create;
begin
  inherited Create;
end;


{---------------------------------------------------------------------------}

//TScorpion  (전갈)


constructor TScorpion.Create;
begin
  inherited Create;
  BoAnimal := True;  //썰면 전갈꼬리가 나옴
end;


{---------------------------------------------------------------------------}

//TSpitSpider (침뱉는 거미)

constructor TSpitSpider.Create;
begin
  inherited Create;
  SearchRate  := 1500 + longword(Random(1500));
  BoAnimal    := True;  //썰면 침거미이빨이 나옴
  BoUsePoison := True;
end;

 //침뱉는 몬스터의 공격
 //몬스터만 사용함
procedure TSpitSpider.SpitAttack(dir: byte);
var
  i, k, mx, my, dam, armor: integer;
  cret: TCreature;
begin
  self.Dir := dir;
  with WAbil do
    dam := Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1);
  if dam <= 0 then
    exit;

  SendRefMsg(RM_HIT, self.Dir, CX, CY, 0, '');

  for i := 0 to 4 do
    for k := 0 to 4 do begin
      if SpitMap[dir, i, k] = 1 then begin
        mx   := CX - 2 + k;
        my   := CY - 2 + i;
        cret := TCreature(PEnvir.GetCreature(mx, my, True));
        if (cret <> nil) and (cret <> self) then begin
          if IsProperTarget(cret) then begin
            //cret.RaceServer = RC_USERHUMAN then begin
            //맞는지 결정
            if Random(cret.SpeedPoint) < AccuracyPoint then begin
              //침거미 침은 마법방어력에 효과 있음.
              //armor := (Lobyte(cret.WAbil.MAC) + Random(ShortInt(Hibyte(cret.WAbil.MAC)-Lobyte(cret.WAbil.MAC)) + 1));
              //dam := dam - armor;
              //if dam <= 0 then
              //   if dam > -10 then dam := 1;
              dam := cret.GetMagStruckDamage(self, dam);
              if dam > 0 then begin
                cret.StruckDamage(dam, self);
                cret.SendDelayMsg(TCreature(RM_STRUCK),
                  RM_REFMESSAGE, dam{wparam},
                  cret.WAbil.HP{lparam1}, cret.WAbil.MaxHP{lparam2},
                  longint(self){hiter}, '',
                  300);

                if BoUsePoison then begin
                  //체력이 감소하는 독에 중독 된다.
                  if Random(20 + cret.AntiPoison) = 0 then
                    cret.MakePoison(POISON_DECHEALTH, 30, 1);   //체력이 감소
                  //if Random(2) = 0 then
                  //   cret.MakePoison (POISON_STONE, 5);   //마비
                end;
              end;
            end;

          end;
        end;
      end;
    end;

end;

function TSpitSpider.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if (TargetCret <> nil) and (TargetCret <> Master) then begin
    if TargetInSpitRange(TargetCret, targdir) then begin
      if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
        HitTime := GetCurrentTime;
        TargetFocusTime := GetTickCount;
        SpitAttack(targdir);
        BreakHolySeize;
      end;
      Result := True;
    end else begin
      if TargetCret.MapName = self.MapName then
        SetTargetXY(TargetCret.CX, TargetCret.CY)
      else
        LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
    end;
  end;
end;


{---------------------------------------------------------------------------}

// 거대 거미



constructor THighRiskSpider.Create;
begin
  inherited Create;
  BoAnimal    := False;
  BoUsePoison := False;
end;


{---------------------------------------------------------------------------}

// 거대 독거미

constructor TBigPoisionSpider.Create;
begin
  inherited Create;
  BoAnimal    := False;
  BoUsePoison := True;
end;


{---------------------------------------------------------------------------}

//TGasAttackMonster (가스 쏘는 구데기)


constructor TGasAttackMonster.Create;
begin
  inherited Create;
  SearchRate := 1500 + longword(Random(1500));
  BoAnimal   := True;  //썰면 구룡환이 나옴
end;

function TGasAttackMonster.GasAttack(dir: byte): TCreature;
var
  i, k, mx, my, dam, armor: integer;
  cret: TCreature;
begin
  Result   := nil;
  self.Dir := dir;
  with WAbil do
    dam := Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1);
  if dam <= 0 then
    exit;

  SendRefMsg(RM_HIT, self.Dir, CX, CY, 0, '');

  cret := GetFrontCret;
  if cret <> nil then begin
    if IsProperTarget(cret) then begin
      //맞는지 결정
      if Random(cret.SpeedPoint) < AccuracyPoint then begin
        //구더기 가스는 마법방어력에 효과 있음.
        //armor := (Lobyte(cret.WAbil.MAC) + Random(ShortInt(Hibyte(cret.WAbil.MAC)-Lobyte(cret.WAbil.MAC)) + 1));
        //dam := dam - armor;
        //if dam <= 0 then
        //   if dam > -10 then dam := 1;
        dam := cret.GetMagStruckDamage(self, dam);
        if dam > 0 then begin
          cret.StruckDamage(dam, self);
          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1}, cret.WAbil.MaxHP{lparam2},
            longint(self){hiter}, '',
            300);

          //마비 되는 독에 중독 된다.
          if RaceServer = RC_TOXICGHOST then begin
            if Random(20 + cret.AntiPoison) = 0 then
              cret.MakePoison(POISON_DECHEALTH, 30, 1);   //체력감소
          end else begin
            if Random(20 + cret.AntiPoison) = 0 then
              cret.MakePoison(POISON_STONE, 5, 0);   //마비
          end;
          Result := cret;
        end;
      end;

    end;
  end;
end;

function TGasAttackMonster.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if TargetCret <> nil then begin
    if TargetInAttackRange(TargetCret, targdir) then begin
      if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
        HitTime := GetCurrentTime;
        TargetFocusTime := GetTickCount;
        GasAttack(targdir);
        BreakHolySeize;
      end;
      Result := True;
    end else begin
      if TargetCret.MapName = self.MapName then
        SetTargetXY(TargetCret.CX, TargetCret.CY)
      else
        LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
    end;
  end;
end;


{---------------------------------------------------------------------------}

// 우면귀

constructor TCowMonster.Create;
begin
  inherited Create;
  SearchRate := 1500 + longword(Random(1500));
end;


// TMagCowMonster   마법쏘는 우면귀


constructor TMagCowMonster.Create;
begin
  inherited Create;
  SearchRate := 1500 + longword(Random(1500));
end;

procedure TMagCowMonster.MagicAttack(dir: byte);
var
  i, k, mx, my, dam, armor: integer;
  cret: TCreature;
begin
  self.Dir := dir;
  with WAbil do
    dam := Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1);
  if dam <= 0 then
    exit;

  SendRefMsg(RM_HIT, self.Dir, CX, CY, 0, '');

  cret := GetFrontCret;
  if cret <> nil then begin
    if IsProperTarget(cret) then begin
      //.RaceServer = RC_USERHUMAN then begin //사람만 공격함
      //맞는지 결정 (마법 회피로 결정)
      if cret.AntiMagic <= Random(50) then begin
        //마법방어력에 효과 있음.
        //armor := (Lobyte(cret.WAbil.MAC) + Random(ShortInt(Hibyte(cret.WAbil.MAC)-Lobyte(cret.WAbil.MAC)) + 1));
        //dam := dam - armor;
        //if dam <= 0 then
        //   if dam > -10 then dam := 1;
        dam := cret.GetMagStruckDamage(self, dam);
        if dam > 0 then begin
          cret.StruckDamage(dam, self);
          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1}, cret.WAbil.MaxHP{lparam2},
            longint(self){hiter}, '',
            300);
        end;
      end;

    end;
  end;
end;

function TMagCowMonster.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if TargetCret <> nil then begin
    if TargetInAttackRange(TargetCret, targdir) then begin
      if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
        HitTime := GetCurrentTime;
        TargetFocusTime := GetTickCount;
        MagicAttack(targdir);
        BreakHolySeize;
      end;
      Result := True;
    end else begin
      if TargetCret.MapName = self.MapName then
        SetTargetXY(TargetCret.CX, TargetCret.CY)
      else
        LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
    end;
  end;
end;


{---------------------------------------------------------------------------}

// TCowKingMonster    우면귀왕

constructor TCowKingMonster.Create;
begin
  inherited Create;
  SearchRate    := 500 + longword(Random(1500));
  JumpTime      := GetTickCount;
  RushMode      := True; //마법에 맞아도 돌진한다.
  CrazyCount    := 0;
  CrazyReadyMode := False;
  CrazyKingMode := False;
end;

procedure TCowKingMonster.Attack(target: TCreature; dir: byte);
var
  pwr: integer;
begin
  with WAbil do
    pwr := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));
  { inherited} HitHit2(target, pwr div 2, pwr div 2, True);
end;

procedure TCowKingMonster.Initialize;
begin
  oldhittime  := NextHitTime;
  oldwalktime := NextWalkTime;
  inherited Initialize;
end;

procedure TCowKingMonster.Run;
var
  nn, nx, ny, old: integer;
  ncret: TCreature;
begin
  if not Death and not RunDone and not BoGhost then begin
    if GetTickCount - JumpTime > 30 * 1000 then begin
      JumpTime := GetTickCount;
      if (TargetCret <> nil) and (SiegeLockCount >= 5) then begin  //4명에게 둘러 쌓임
        //nn := Random(VisibleActors.Count-2) + 1;
        //ncret := TCreature (PTVisibleActor(VisibleActors[nn]).cret);
        //if ncret <> nil then SelectTarget (ncret);
        GetBackPosition(TargetCret, nx, ny);
        if PEnvir.CanWalk(nx, ny, False) then begin
          SpaceMove(PEnvir.MapName, nx, ny, 0);
        end else
          RandomSpaceMove(PEnvir.MapName, 0);
        exit;
      end;
    end;
    old := CrazyCount;
    CrazyCount := 7 - WAbil.HP div (WAbil.MaxHP div 7);

    if (CrazyCount >= 2) and (CrazyCount <> old) then begin
      CrazyReadyMode := True;
      CrazyReady     := GetTickCount;
    end;

    if CrazyReadyMode then begin  //맞고만 있음
      if GetTickCount - CrazyReady < 8 * 1000 then begin
        NextHitTime := 10000;
      end else begin
        CrazyReadyMode := False;
        CrazyKingMode  := True;
        CrazyTime      := GetTickCount;
      end;
    end;
    if CrazyKingMode then begin  //폭주
      if GetTickCount - CrazyTime < 8 * 1000 then begin
        NextHitTime  := 500;
        NextWalkTime := 400;
      end else begin
        CrazyKingMode := False;
        NextHitTime   := oldhittime;
        NextWalkTime  := oldwalktime;
      end;
    end;

  end;
  inherited Run;
end;


 {---------------------------------------------------------------------------}
 // 주술좀비, 라이트닝 좀비

constructor TLightingZombi.Create;
begin
  inherited Create;
  SearchRate := 1500 + longword(Random(1500));
end;

//TargetCret <> nil
procedure TLightingZombi.LightingAttack(dir: integer);
var
  i, k, sx, sy, tx, ty, mx, my, pwr: integer;
begin
  self.Dir := dir;

  SendRefMsg(RM_LIGHTING, 1, CX, CY, integer(TargetCret), '');

  if GetNextPosition(PEnvir, CX, CY, dir, 1, sx, sy) then begin
    GetNextPosition(PEnvir, CX, CY, dir, 9, tx, ty);
    with WAbil do
      pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));
    MagPassThroughMagic(sx, sy, tx, ty, dir, pwr, True);
  end;

  BreakHolySeize;

end;

procedure TLightingZombi.Run;
var
  i, dis, d, targdir: integer;
  cret, nearcret:     TCreature;
begin
  dis      := 9999;
  nearcret := nil;
  //   if not Death and not RunDone and not BoGhost and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if not RunDone and IsMoveAble then begin
    if (GetTickCount - SearchEnemyTime > 8000) or
      ((GetTickCount - SearchEnemyTime > 1000) and (TargetCret = nil)) then begin
      SearchEnemyTime := GetTickCount;
      MonsterNormalAttack;
    end;
    if GetCurrentTime - WalkTime > GetNextWalkTime then begin
      //상속받은 run에서 WalkTime 재설정함
      if TargetCret <> nil then
        if (abs(CX - TargetCret.CX) <= 4) and (abs(CY - TargetCret.CY) <= 4) then begin
          if (abs(CX - TargetCret.CX) <= 2) and (abs(CY - TargetCret.CY) <= 2) then
            //너무 가까우면, 잘 도망 안감.
            if Random(3) <> 0 then begin
              inherited Run;
              exit;
            end;
          //도망감.
          GetBackPosition(self, TargetX, TargetY);
        end;
    end;
    if TargetCret <> nil then begin
      if (abs(CX - TargetCret.CX) < 6) and (abs(CY - TargetCret.CY) < 6) then begin
        if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
          HitTime := GetCurrentTime;
          targdir := GetNextDirection(CX, CY, TargetCret.CX, TargetCret.CY);
          LightingAttack(targdir);
        end;
      end;
    end;
  end;
  inherited Run;
end;


 {---------------------------------------------------------------------------}
 //땅파고 나오는 좀비


constructor TDigOutZombi.Create;
begin
  inherited Create;
  RunDone    := False;
  ViewRange  := 7;
  SearchRate := 2500 + longword(Random(1500));
  SearchTime := GetTickCount;
  RaceServer := RC_DIGOUTZOMBI;
  HideMode   := True;
end;

procedure TDigOutZombi.ComeOut;
var
  event: TEvent;
begin
  event := TEvent.Create(PEnvir, CX, CY, ET_DIGOUTZOMBI, 5 * 60 * 1000, True);
  if (event <> nil) and (event.IsAddToMap = True) then begin
    EventMan.AddEvent(event);
    HideMode := False;
    SendRefMsg(RM_DIGUP, Dir, CX, CY, integer(event), '');
    Exit;
  end;

  if event <> nil then
    event.Free;
end;

procedure TDigOutZombi.Run;
var
  i, dis, d, targdir: integer;
  cret, nearcret:     TCreature;
begin
  //   if (not BoGhost) and (not Death) and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if IsMoveAble then begin
    if GetCurrentTime - WalkTime > GetNextWalkTime then begin
      nearcret := nil;
      //WalkTime := GetTickCount;  상속받은 run에서 재설정함
      if HideMode then begin //아직 모습을 나타내지 않았음.
        for i := 0 to VisibleActors.Count - 1 do begin
          cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
          if (not cret.Death) and (IsProperTarget(cret)) and
            (not cret.BoHumHideMode or BoViewFixedHide) then begin
            if (abs(CX - cret.CX) <= 3) and (abs(CY - cret.CY) <= 3) then begin
              ComeOut; //밖으로 나오다. 보인다.
              WalkTime := GetCurrentTime + 1000;
              break;
            end;
          end;
        end;
      end else begin
        if (GetTickCount - SearchEnemyTime > 8000) or
          ((GetTickCount - SearchEnemyTime > 1000) and (TargetCret = nil)) then begin
          SearchEnemyTime := GetTickCount;
          MonsterNormalAttack;
        end;
      end;
    end;
  end;
  inherited Run;
end;


 {---------------------------------------------------------------------------}
 //죽었다 깨어나는 좀비


constructor TZilKinZombi.Create;
begin
  inherited Create;
  ViewRange  := 6;
  SearchRate := 2500 + longword(Random(1500));
  SearchTime := GetTickCount;
  RaceServer := RC_ZILKINZOMBI;
  LifeCount  := 0;
  if Random(3) = 0 then
    LifeCount := 1 + Random(3);
end;

procedure TZilKinZombi.Die;
begin
  inherited Die;
  if LifeCount > 0 then begin
    deathstart := GetTickCount;
    RelifeTime := (4 + Random(20)) * 1000;
  end;
  Dec(LifeCount);
end;

procedure TZilKinZombi.Run;
begin
  // 특별한 경우라 IsMoveAble 싸용할수 없음
  if Death and (not BoGhost) and (LifeCount >= 0) and
    (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
    (StatusArr[POISON_STUN] = 0) and (StatusArr[POISON_DONTMOVE] = 0) then
  begin  //죽었음, 고스트상태는 아님
    if VisibleActors.Count > 0 then begin
      if GetTickCount - deathstart >= RelifeTime then begin
        Abil.MaxHP := Abil.MaxHP div 2;
        FightExp   := FightExp div 2;
        Abil.HP    := Abil.MaxHP;
        WAbil.HP   := Abil.MaxHP;
        Alive;
        WalkTime := GetCurrentTime + 1000;
      end;
    end;
  end;
  inherited Run;
end;


 {---------------------------------------------------------------------------}
 //백골:  소환수


constructor TWhiteSkeleton.Create;
begin
  inherited Create;
  bofirst    := True;
  HideMode   := True;
  RaceServer := RC_WHITESKELETON;
  ViewRange  := 6;
end;

procedure TWhiteSkeleton.RecalcAbilitys;
begin
  inherited RecalcAbilitys;
  //   ResetSkeleton;
  //   ApplySlaveLevelAbilitys;
end;

procedure TWhiteSkeleton.ResetSkeleton;
begin
  NextHitTime  := 3000 - (SlaveMakeLevel * 600);
  NextWalkTime := 1200 - (SlaveMakeLevel * 250);
  //WAbil.DC := MakeWord(Lobyte(WAbil.DC), Hibyte(WAbil.DC) + SlaveMakeLevel);
  //WAbil.MaxHP := WAbil.MaxHP + SlaveMakeLevel * 5;
  //WAbil.HP := WAbil.MaxHP;
  //AccuracyPoint := 11 + SlaveMakeLevel;
  WalkTime     := GetCurrentTime + 2000;
end;

procedure TWhiteSkeleton.Run;
var
  i: integer;
begin
  if bofirst then begin
    bofirst  := False;
    Dir      := 5;
    HideMode := False;
    SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
    ResetSkeleton;
  end;
  inherited Run;
end;

 {---------------------------------------------------------------------------}
 //석상몬트숱: 염소장군, 염소대장


constructor TScultureMonster.Create;
begin
  inherited Create;
  SearchRate   := 1500 + longword(Random(1500));
  ViewRange    := 7;
  BoStoneMode  := True; //처음에는 돌로 굳어져 있음...
  CharStatusEx := STATE_STONE_MODE;
  BoDontMove   := True;
  MeltArea     := 2;
end;

procedure TScultureMonster.MeltStone;
begin
  CharStatusEx := 0;
  CharStatus   := GetCharStatus;
  SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');  //녹는 애니메이션
  BoStoneMode := False;
  BoDontMove  := False;
end;

procedure TScultureMonster.MeltStoneAll;
var
  i:     integer;
  cret:  TCreature;
  rlist: TList;
begin
  MeltStone;
  rlist := TList.Create;
  GetMapCreatures(PEnvir, CX, CY, 7, rlist);
  for i := 0 to rlist.Count - 1 do begin
    cret := TCreature(rlist[i]);
    if cret.BoStoneMode then begin
      if cret is TScultureMonster then
        TScultureMonster(cret).MeltStone;
    end;
  end;
  rlist.Free;
end;

procedure TScultureMonster.Run;
var
  i, dis, d, targdir: integer;
  cret, nearcret:     TCreature;
begin
  //   if (not BoGhost) and (not Death) and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if IsMoveAble then begin
    if GetCurrentTime - WalkTime > GetNextWalkTime then begin
      nearcret := nil;
      //WalkTime := GetTickCount;  상속받은 run에서 재설정함
      if BoStoneMode then begin //아직 모습을 나타내지 않았음.
        for i := 0 to VisibleActors.Count - 1 do begin
          cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
          if (not cret.Death) and (IsProperTarget(cret)) and
            (not cret.BoHumHideMode or BoViewFixedHide) then begin
            if (abs(CX - cret.CX) <= MeltArea) and (abs(CY - cret.CY) <= MeltArea) then
            begin
              MeltStoneAll; //석상상태에서 녹는다, 주의동료들도 함께 녹는다.
              WalkTime := GetCurrentTime + 1000;
              break;
            end;
          end;
        end;
      end else begin
        if (GetTickCount - SearchEnemyTime > 8000) or
          ((GetTickCount - SearchEnemyTime > 1000) and (TargetCret = nil)) then begin
          SearchEnemyTime := GetTickCount;
          MonsterNormalAttack;
        end;
      end;
    end;
  end;
  inherited Run;
end;


 {---------------------------------------------------------------------------}
 //주마왕


constructor TScultureKingMonster.Create;
begin
  inherited Create;
  SearchRate := 1500 + longword(Random(1500));
  ViewRange := 8;
  BoStoneMode := True; //처음에는 돌로 굳어져 있음...
  CharStatusEx := STATE_STONE_MODE;
  Dir := 5;
  DangerLevel := 5; //5번의 위기..
  childlist := TList.Create;
  BoCallFollower := True;
end;

destructor TScultureKingMonster.Destroy;
begin
  childlist.Free;
  inherited Destroy;
end;

procedure TScultureKingMonster.MeltStone;
var
  i:     integer;
  cret:  TCreature;
  event: TEvent;
begin
  event := TEvent.Create(PEnvir, CX, CY, ET_SCULPEICE, 5 * 60 * 1000, True);
  if (event <> nil) and (event.IsAddToMap = True) then begin
    CharStatusEx := 0;
    CharStatus   := GetCharStatus;
    SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
    BoStoneMode := False;
    EventMan.AddEvent(event);
    Exit;
  end;

  if event <> nil then
    event.Free;
end;

procedure TScultureKingMonster.CallFollower;
const
  MAX_FOLLOWERS = 4;
var
  i, Count, nx, ny: integer;
  monname: string;
  mon:     TCreature;
  followers: array[0..MAX_FOLLOWERS - 1] of string;
  // = (주마호법', 주마신장', 마궁사', 쐐기나방');
begin
  Count := 6 + Random(6);
  GetFrontPosition(self, nx, ny);

  followers[0] := __ZumaMonster1;
  followers[1] := __ZumaMonster2;
  followers[2] := __ZumaMonster3;
  followers[3] := __ZumaMonster4;

  for i := 1 to Count do begin
    if childlist.Count < 30 then begin
      monname := followers[Random(MAX_FOLLOWERS)];
      mon     := UserEngine.AddCreatureSysop(MapName, nx, ny, monname);
      if mon <> nil then
        childlist.Add(mon);
    end;
  end;
end;

procedure TScultureKingMonster.Attack(target: TCreature; dir: byte);
var
  pwr: integer;
begin
  with WAbil do
    pwr := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));
  {inherited} HitHit2(target, 0, pwr, True);
end;

procedure TScultureKingMonster.Run;
var
  i, dis, d, targdir: integer;
  cret, nearcret:     TCreature;
begin
  //   if (not BoGhost) and (not Death) and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if IsMoveAble then begin
    if GetCurrentTime - WalkTime > GetNextWalkTime then begin
      nearcret := nil;
      //WalkTime := GetTickCount;  상속받은 run에서 재설정함
      if BoStoneMode then begin //아직 모습을 나타내지 않았음.
        for i := 0 to VisibleActors.Count - 1 do begin
          cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
          if (not cret.Death) and (IsProperTarget(cret)) and
            (not cret.BoHumHideMode or BoViewFixedHide) then begin
            if (abs(CX - cret.CX) <= 2) and (abs(CY - cret.CY) <= 2) then begin
              MeltStone; //석상상태에서 녹는다
              WalkTime := GetCurrentTime + 2000;
              break;
            end;
          end;
        end;
      end else begin
        if (GetTickCount - SearchEnemyTime > 8000) or
          ((GetTickCount - SearchEnemyTime > 1000) and (TargetCret = nil)) then begin
          SearchEnemyTime := GetTickCount;
          MonsterNormalAttack;
        end;

        if BoCallFollower then begin
          //5번의 시련
          if ((WAbil.HP / WAbil.MaxHP * 5) < DangerLevel) and (DangerLevel > 0) then
          begin
            Dec(DangerLevel);
            CallFollower;
          end;
          if WAbil.HP = WAbil.MaxHP then
            DangerLevel := 5;  //초기화
        end;

      end;

      for i := childlist.Count - 1 downto 0 do begin
        if (TCreature(childlist[i]).Death) or (TCreature(childlist[i]).BoGhost) then
        begin
          childlist.Delete(i);
        end;
      end;
    end;
  end;
  inherited Run;
end;


 {---------------------------------------------------------------------------}
 //쐐기나방, 숨은 사람을 볼 수 있음, 가스(디텍트)

constructor TGasMothMonster.Create;
begin
  inherited Create;
  ViewRange := 7;
end;

function TGasMothMonster.GasAttack(dir: byte): TCreature;
var
  cret: TCreature;
begin
  cret := inherited GasAttack(dir);
  if cret <> nil then begin  //이 가스는 은신이 풀린다.
    if Random(3) = 0 then begin
      //if cret.BoFixedHideMode then begin //고정 은신술, 투명반지도 풀림
      if cret.BoHumHideMode then begin
        cret.StatusArr[STATE_TRANSPARENT] := 1;
      end;
      //end;
    end;
  end;
  Result := cret;
end;

procedure TGasMothMonster.Run;   //가장 가까운 놈부터 공격한다.
var
  i, dis, d:      integer;
  cret, nearcret: TCreature;
begin
  dis      := 9999;
  nearcret := nil;
  //   if not Death and not RunDone and not BoGhost and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if not RunDone and IsMoveAble then begin
    if (GetTickCount - SearchEnemyTime > 8000) or
      ((GetTickCount - SearchEnemyTime > 1000) and (TargetCret = nil)) then begin
      SearchEnemyTime := GetTickCount;
      MonsterDetecterAttack;   //숨어있는 몹을 볼 수 있다.
    end;
  end;
  inherited Run;
end;


 {---------------------------------------------------------------------------}
 //둥, 가스(마비)

constructor TGasDungMonster.Create;
begin
  inherited Create;
  ViewRange := 7;
end;


 {---------------------------------------------------------------------------}
 //신수 (변신 전)

constructor TElfMonster.Create;
begin
  inherited Create;
  ViewRange    := 6;
  HideMode     := True;
  NoAttackMode := True;
  bofirst      := True;
end;

procedure TElfMonster.RecalcAbilitys;
begin
  inherited RecalcAbilitys;
  ResetElfMon;
end;

procedure TElfMonster.ResetElfMon;
begin
  //NextHitTime := 3000 - (SlaveMakeLevel * 600);  //공격 안함
  NextWalkTime := 500 - (SlaveMakeLevel * 50);
  WalkTime     := GetCurrentTime + 2000;
end;

procedure TElfMonster.AppearNow;
begin
  bofirst  := False;
  HideMode := False;
  //SendRefMsg (RM_TURN, Dir, CX, CY, 0, '');
  //Appear;
  //ResetElfMon;
  RecalcAbilitys;
  WalkTime := WalkTime + 800; //변신후 약간 딜레이 있음
end;

procedure TElfMonster.Run;
var
  cret: TCreature;
  bochangeface: boolean;
begin
  if bofirst then begin
    bofirst  := False;
    HideMode := False;
    SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
    ResetElfMon;
  end;
  if Death then begin  //신수는 시체가 없다.
    if GetTickCount - DeathTime > 2 * 1000 then begin
      MakeGhost(1);
    end;
  end else begin
    bochangeface := False;
    if TargetCret <> nil then
      bochangeface := True;
    if Master <> nil then
      if (Master.TargetCret <> nil) or (Master.LastHiter <> nil) then
        bochangeface := True;

    if bochangeface then begin  //공격 대상이 있는 경우->변신
      cret := MakeClone(__ShinSu1, self);
      if cret <> nil then begin
        //SendRefMsg (RM_CHANGEFACE, 0, integer(self), integer(cret), 0, '');
        if cret is TElfWarriorMonster then
          TElfWarriorMonster(cret).AppearNow;
        Master := nil;
        KickException;
      end;
    end;
  end;
  inherited Run;
end;


 {---------------------------------------------------------------------------}
 //신수 (변신 후)


constructor TElfWarriorMonster.Create;
begin
  inherited Create;
  ViewRange   := 6;
  HideMode    := True;
  //NoAttackMode := TRUE;
  bofirst     := True;
  BoUsePoison := False;
end;

procedure TElfWarriorMonster.RecalcAbilitys;
begin
  inherited RecalcAbilitys;
  //   ResetElfMon;
end;

procedure TElfWarriorMonster.ResetElfMon;
begin
  //NextHitTime := 3000 - (SlaveMakeLevel * 600);
  //NextWalkTime := 1200 - (SlaveMakeLevel * 250);
  NextHitTime  := 1500 - (SlaveMakeLevel * 100);
  NextWalkTime := 500 - (SlaveMakeLevel * 50);
  WalkTime     := GetCurrentTime + 2000;
end;

procedure TElfWarriorMonster.AppearNow;
begin
  bofirst  := False;
  HideMode := False;
  SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
  RecalcAbilitys;
  ResetElfMon;
  WalkTime := WalkTime + 800; //변신후 약간 딜레이 있음
  changefacetime := GetTickCount;
end;

procedure TElfWarriorMonster.Run;
var
  cret: TCreature;
  bochangeface: boolean;
begin
  if bofirst then begin
    bofirst  := False;
    HideMode := False;
    SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
    ResetElfMon;
  end;
  if Death then begin  //신수는 시체가 없다.
    if GetTickCount - DeathTime > 2 * 1000 then begin
      MakeGhost(2);
    end;
  end else begin
    bochangeface := True;
    if TargetCret <> nil then
      bochangeface := False;
    if Master <> nil then
      if (Master.TargetCret <> nil) or (Master.LastHiter <> nil) then
        bochangeface := False;

    if bochangeface then begin  //공격 대상이 있는 경우->변신
      if GetTickCount - changefacetime > 60 * 1000 then begin
        cret := MakeClone(__ShinSu, self);
        if cret <> nil then begin
          SendRefMsg(RM_DIGDOWN, {Dir}0, CX, CY, 0, '');
          //변신이 끝난 후에 사라진다.
          SendRefMsg(RM_CHANGEFACE, 0, integer(self), integer(cret), 0, '');
          if cret is TElfMonster then begin
            TElfMonster(cret).AppearNow;
          end;
          Master := nil;
          KickException;
        end;
      end;
    end else
      changefacetime := GetTickCount;
  end;
  inherited Run;
end;


 {---------------------------------------------------------------------------}
 // 강력한 크리티컬 공격을 하는 몬스터


constructor TCriticalMonster.Create;
begin
  inherited Create;
  criticalpoint := 0;
end;

procedure TCriticalMonster.Attack(target: TCreature; dir: byte);
var
  pwr: integer;
begin
  with WAbil do
    pwr := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));
  Inc(criticalpoint);

  if (criticalpoint > 5) or (Random(10) = 0) then begin
    criticalpoint := 0;
    pwr := Round(pwr * (Abil.MaxMP / 10));
    {inherited} HitHitEx2(target, RM_LIGHTING, 0, pwr, True);
  end else
    {inherited} HitHit2(target, 0, pwr, True);
end;


 {---------------------------------------------------------------------------}
 // 강력한 두칸 크리티컬 공격을 하는 몬스터


constructor TDoubleCriticalMonster.Create;
begin
  inherited Create;
  criticalpoint := 0;
end;

procedure TDoubleCriticalMonster.DoubleCriticalAttack(dam: integer; dir: byte);
var
  i, k, mx, my, armor: integer;
  cret: TCreature;
begin
  self.Dir := dir;
  if dam <= 0 then
    exit;

  SendRefMsg(RM_LIGHTING, self.Dir, CX, CY, 0, '');

  for i := 0 to 4 do
    for k := 0 to 4 do begin
      if SpitMap[dir, i, k] = 1 then begin
        mx   := CX - 2 + k;
        my   := CY - 2 + i;
        cret := TCreature(PEnvir.GetCreature(mx, my, True));
        if (cret <> nil) and (cret <> self) then begin
          if IsProperTarget(cret) then begin
            //cret.RaceServer = RC_USERHUMAN then begin
            //맞는지 결정
            if Random(cret.SpeedPoint) < AccuracyPoint then begin
              //침거미 침은 마법방어력에 효과 있음.
              //armor := (Lobyte(cret.WAbil.MAC) + Random(ShortInt(Hibyte(cret.WAbil.MAC)-Lobyte(cret.WAbil.MAC)) + 1));
              //dam := dam - armor;
              //if dam <= 0 then
              //   if dam > -10 then dam := 1;
              dam := cret.GetMagStruckDamage(self, dam);
              if dam > 0 then begin
                cret.StruckDamage(dam, self);
                cret.SendDelayMsg(TCreature(RM_STRUCK),
                  RM_REFMESSAGE, dam{wparam},
                  cret.WAbil.HP{lparam1}, cret.WAbil.MaxHP{lparam2},
                  longint(self){hiter}, '',
                  300);

              end;
            end;

          end;
        end;
      end;
    end;
end;

procedure TDoubleCriticalMonster.Attack(target: TCreature; dir: byte);
var
  pwr: integer;
begin
  with WAbil do
    pwr := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));
  Inc(criticalpoint);

  if (criticalpoint > 5) or (Random(10) = 0) then begin
    criticalpoint := 0;
    pwr := Round(pwr * (Abil.MaxMP / 10));
    DoubleCriticalAttack(pwr, Dir);
  end else
    {inherited} HitHit2(target, 0, pwr, True);
end;

// 2003/02/11 해골병사
constructor TSkeletonSoldier.Create;
begin
  inherited Create;
end;

procedure TSkeletonSoldier.RangeAttack(dir: byte);
var
  i, k, mx, my, dam, armor: integer;
  cret: TCreature;
  pwr:  integer;
begin
  self.Dir := dir;
  with WAbil do
    dam := Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1);
  if dam <= 0 then
    exit;

  SendRefMsg(RM_HIT, self.Dir, CX, CY, 0, '');

  with WAbil do
    pwr := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));
  for i := 0 to 4 do
    for k := 0 to 4 do begin
      if SpitMap[dir, i, k] = 1 then begin
        mx   := CX - 2 + k;
        my   := CY - 2 + i;
        cret := TCreature(PEnvir.GetCreature(mx, my, True));
        if (cret <> nil) and (cret <> self) then begin
          if IsProperTarget(cret) then begin
            //cret.RaceServer = RC_USERHUMAN then begin
            //맞는지 결정
            if Random(cret.SpeedPoint) < AccuracyPoint then begin
              {inherited} HitHit2(cret, 0, pwr, True);
            end;
          end;
        end;
      end;
    end;
end;

function TSkeletonSoldier.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if TargetCret <> nil then begin
    if TargetInSpitRange(TargetCret, targdir) then begin
      if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
        HitTime := GetCurrentTime;
        TargetFocusTime := GetTickCount;
        RangeAttack(targdir);
        BreakHolySeize;
      end;
      Result := True;
    end else begin
      if TargetCret.MapName = self.MapName then
        SetTargetXY(TargetCret.CX, TargetCret.CY)
      else
        LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
    end;
  end;
end;

constructor TSkeletonKingMonster.Create;
begin
  inherited Create;
  ChainShotCount := 6;
  BoStoneMode    := False;
  CharStatusEx   := 0;
  CharStatus     := GetCharStatus;
end;

procedure TSkeletonKingMonster.CallFollower;
const
  MAX_SKELFOLLOWERS = 3;
var
  i, Count, nx, ny: integer;
  monname: string;
  mon:     TCreature;
  followers: array[0..MAX_SKELFOLLOWERS - 1] of string;
  // = (해골무장, 해골궁수, 해골병졸);
begin
  SendRefMsg(RM_LIGHTING, self.Dir, CX, CY, 0, '');
  Count := 4 + Random(4);
  GetFrontPosition(self, nx, ny);

  //젠시킬 몬스터이름
  followers[0] := 'BoneCaptain';
  followers[1] := 'BoneArcher';
  followers[2] := 'BoneSpearman';

  for i := 1 to Count do begin
    if childlist.Count < 20 then begin
      monname := followers[Random(MAX_SKELFOLLOWERS)];
      mon     := UserEngine.AddCreatureSysop(MapName, nx, ny, monname);
      if mon <> nil then
        childlist.Add(mon);
    end;
  end;
end;

procedure TSkeletonKingMonster.Attack(target: TCreature; dir: byte);
var
  pwr: integer;
begin
  with WAbil do
    pwr := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));
  {inherited} HitHit2(target, 0, pwr, True);
end;

procedure TSkeletonKingMonster.Run;
var
  i, dis, d, targdir: integer;
  cret: TCreature;
begin
  inherited Run;
end;

procedure TSkeletonKingMonster.RangeAttack(targ: TCreature); //반드시 target <> nil
var
  dam, armor: integer;
begin
  if targ = nil then
    exit;

  if PEnvir.CanFly(CX, CY, targ.CX, targ.CY) then begin //도끼가 날아갈수 있는지.
    Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
    with WAbil do
      dam := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));
    if dam > 0 then begin
      dam := targ.GetHitStruckDamage(self, dam);
    end;
    if dam > 0 then begin
      targ.StruckDamage(dam, self);
      targ.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
        targ.WAbil.HP{lparam1}, targ.WAbil.MaxHP{lparam2},
        longint(self){hiter}, '', 600 + _MAX(Abs(CX - targ.CX), Abs(CY - targ.CY)) * 50);
    end;
    SendRefMsg(RM_FLYAXE, Dir, CX, CY, integer(targ), '');
  end;
end;

procedure TSkeletonKingMonster.RangeAttack2(targ: TCreature);
begin;
end;

procedure TSkeletonKingMonster.MoveSelf;
begin;
end;

function TSkeletonKingMonster.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if TargetCret <> nil then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;
      if (abs(CX - TargetCret.CX) <= 7) and (abs(CY - TargetCret.CY) <= 7) then begin
        if TargetInAttackRange(TargetCret, targdir) then begin
          TargetFocusTime := GetTickCount;
          Attack(TargetCret, targdir);
          Result := True;
        end else begin
          if ChainShot < ChainShotCount - 1 then begin
            Inc(ChainShot);
            TargetFocusTime := GetTickCount;
            RangeAttack(TargetCret);
          end else begin
            if Random(5) = 0 then
              ChainShot := 0;
          end;
          Result := True;
        end;
      end else begin
        if TargetCret.MapName = self.MapName then begin
          if (abs(CX - TargetCret.CX) <= 11) and (abs(CY - TargetCret.CY) <= 11) then
          begin
            SetTargetXY(TargetCret.CX, TargetCret.CY);
          end;
        end else begin
          LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
        end;
      end;
    end;
  end;
end;

// 2003/03/04 반야좌사, 반야우사
constructor TBanyaGuardMonster.Create;
begin
  inherited Create;
  ChainShotCount := 6;
  BoCallFollower := False;
end;

procedure TBanyaGuardMonster.Attack(target: TCreature; dir: byte);
var
  pwr: integer;
begin
  with WAbil do
    pwr := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));
  {inherited} HitHit2(target, 0, pwr, True);
end;

procedure TBanyaGuardMonster.RangeAttack(targ: TCreature); //반드시 target <> nil
var
  i, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;
begin
  if targ = nil then
    exit;

  Self.Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
  SendRefMsg(RM_LIGHTING, self.Dir, CX, CY, integer(targ), '');
  if GetNextPosition(PEnvir, CX, CY, dir, 1, sx, sy) then begin
    GetNextPosition(PEnvir, CX, CY, dir, 9, tx, ty);
    with WAbil do
      pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

    list := TList.Create;
    PEnvir.GetAllCreature(targ.CX, targ.CY, True, list);
    for i := 0 to list.Count - 1 do begin
      cret := TCreature(list[i]);
      if IsProperTarget(cret) then begin
        dam := cret.GetMagStruckDamage(self, pwr);
        if dam > 0 then begin
          cret.StruckDamage(dam, self);
          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1},
            cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '', 800);
        end;
      end;
    end;
    list.Free;
  end;
end;

function TBanyaGuardMonster.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if TargetCret <> nil then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;
      if (abs(CX - TargetCret.CX) <= 7) and (abs(CY - TargetCret.CY) <= 7) then begin
        if (TargetInAttackRange(TargetCret, targdir)) and (Random(3) <> 0) then begin
          TargetFocusTime := GetTickCount;
          Attack(TargetCret, targdir);
          Result := True;
        end else begin
          if ChainShot < ChainShotCount - 1 then begin
            Inc(ChainShot);
            TargetFocusTime := GetTickCount;
            RangeAttack(TargetCret);
          end else begin
            if Random(5) = 0 then
              ChainShot := 0;
          end;
          Result := True;
        end;
      end else begin
        if TargetCret.MapName = self.MapName then begin
          if (abs(CX - TargetCret.CX) <= 11) and (abs(CY - TargetCret.CY) <= 11) then
          begin
            SetTargetXY(TargetCret.CX, TargetCret.CY);
          end;
        end else begin
          LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
        end;
      end;
    end;
  end;
end;

// 2003/03/04 사우천왕
constructor TDeadCowKingMonster.Create;
begin
  inherited Create;
  ChainShotCount := 6;
  BoCallFollower := False;
end;

procedure TDeadCowKingMonster.Attack(target: TCreature; dir: byte);
var
  pwr:  integer;
  i, ix, iy, ixf, ixt, iyf, iyt, dam: integer;
  list: TList;
  cret: TCreature;
begin
  Self.Dir := GetNextDirection(CX, CY, target.CX, target.CY);
  with WAbil do
    pwr := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));

  ixf := _MAX(0, CX - 1);
  ixt := _MIN(pEnvir.MapWidth - 1, CX + 1);
  iyf := _MAX(0, CY - 1);
  iyt := _MIN(pEnvir.MapHeight - 1, CY + 1);

  for ix := ixf to ixt do begin
    for iy := iyf to iyt do begin
      list := TList.Create;
      PEnvir.GetAllCreature(ix, iy, True, list);
      for i := 0 to list.Count - 1 do begin
        cret := TCreature(list[i]);
        if IsProperTarget(cret) then begin
          dam := cret.GetMagStruckDamage(self, pwr);
          if dam > 0 then begin
            cret.StruckDamage(dam, self);
            cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
              cret.WAbil.HP{lparam1},
              cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '', 200);
          end;
        end;
      end;
      list.Free;
    end;
  end;
  SendRefMsg(RM_HIT, self.Dir, CX, CY, integer(target), '');
  // inherited HitHit2 (target, 0, pwr, TRUE);
end;

procedure TDeadCowKingMonster.RangeAttack(targ: TCreature); //반드시 target <> nil
var
  i, ix, iy, ixf, ixt, iyf, iyt, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;
begin
  if targ = nil then
    exit;

  Self.Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
  SendRefMsg(RM_LIGHTING, self.Dir, CX, CY, integer(targ), '');
  if GetNextPosition(PEnvir, CX, CY, dir, 1, sx, sy) then begin
    GetNextPosition(PEnvir, CX, CY, dir, 9, tx, ty);
    with WAbil do
      pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

    ixf := _MAX(0, targ.CX - 2);
    ixt := _MIN(pEnvir.MapWidth - 1, targ.CX + 2);
    iyf := _MAX(0, targ.CY - 2);
    iyt := _MIN(pEnvir.MapHeight - 1, targ.CY + 2);

    for ix := ixf to ixt do begin
      for iy := iyf to iyt do begin
        list := TList.Create;
        PEnvir.GetAllCreature(ix, iy, True, list);
        for i := 0 to list.Count - 1 do begin
          cret := TCreature(list[i]);
          if IsProperTarget(cret) then begin
            dam := cret.GetMagStruckDamage(self, pwr);
            if dam > 0 then begin
              cret.StruckDamage(dam, self);
              cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
                cret.WAbil.HP{lparam1},
                cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '', 800);
            end;
          end;
        end;
        list.Free;
      end;
    end;
  end;
end;

function TDeadCowKingMonster.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if TargetCret <> nil then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;
      if (abs(CX - TargetCret.CX) <= 7) and (abs(CY - TargetCret.CY) <= 7) then begin
        if (TargetInAttackRange(TargetCret, targdir)) and (Random(3) <> 0) then begin
          TargetFocusTime := GetTickCount;
          Attack(TargetCret, targdir);
          Result := True;
        end else begin
          if ChainShot < ChainShotCount - 1 then begin
            Inc(ChainShot);
            TargetFocusTime := GetTickCount;
            RangeAttack(TargetCret);
          end else begin
            if Random(5) = 0 then
              ChainShot := 0;
          end;
          Result := True;
        end;
      end else begin
        if TargetCret.MapName = self.MapName then begin
          if (abs(CX - TargetCret.CX) <= 11) and (abs(CY - TargetCret.CY) <= 11) then
          begin
            SetTargetXY(TargetCret.CX, TargetCret.CY);
          end;
        end else begin
          LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
        end;
      end;
    end;
  end;
end;

// 2003/07/15 과거비천 마계석
constructor TStoneMonster.Create;
begin
  inherited Create;
  ViewRange := 7;
  StickMode := True;
end;

procedure TStoneMonster.Run;
var
  boidle:   boolean;
  i, ix, iy: integer;
  cret:     TCreature;
  pva:      PTVisibleActor;
  BoRecalc: boolean;
  ixf, ixt, iyf, iyt: integer;
  list:     TList;
begin
  if (not BoGhost) and (not Death) then begin
    // 5초마다 한번씩 발동
    if GetCurrentTime - WalkTime > 5000 {NextWalkTime} then begin
      WalkTime := GetCurrentTime;

      ixf := _MAX(0, CX - 3);
      ixt := _MIN(pEnvir.MapWidth - 1, CX + 3);
      iyf := _MAX(0, CY - 3);
      iyt := _MIN(pEnvir.MapHeight - 1, CY + 3);

      list := TList.Create;
      for ix := ixf to ixt do begin
        for iy := iyf to iyt do begin
          list.Clear;
          PEnvir.GetAllCreature(ix, iy, True, list);
          for i := 0 to list.Count - 1 do begin
            cret     := TCreature(list[i]);
            BoRecalc := False;
            if (cret <> nil) and (cret.RaceServer <> RC_USERHUMAN) and
              (cret.Master = nil) and (not cret.BoGhost) and (not cret.Death) then begin
              if RaceServer = RC_PBMSTONE1 then begin  // 공격력 강화 마계석
                if cret.ExtraAbil[EABIL_DCUP] = 0 then begin
                  BoRecalc := True;
                  cret.ExtraAbil[EABIL_DCUP] := 15;
                  cret.ExtraAbilFlag[EABIL_DCUP] := 0;
                  cret.ExtraAbilTimes[EABIL_DCUP] := GetTickCount + 15100;
                end;
              end else begin
                if cret.StatusArr[STATE_DEFENCEUP] = 0 then begin
                  BoRecalc := True;
                  cret.StatusArr[STATE_DEFENCEUP] := 8;
                  cret.StatusTimes[STATE_DEFENCEUP] := GetTickCount;
                end;

                if cret.StatusArr[STATE_HITSPEEDUP] = 0 then begin
                  BoRecalc := True;
                  cret.StatusArr[STATE_HITSPEEDUP] := 8;
                  cret.StatusTimes[STATE_HITSPEEDUP] := GetTickCount;
                end;

                if cret.StatusArr[STATE_MAGDEFENCEUP] = 0 then begin
                  BoRecalc := True;
                  cret.StatusArr[STATE_MAGDEFENCEUP] := 8;
                  cret.StatusTimes[STATE_MAGDEFENCEUP] := GetTickCount;
                end;
              end;
              if BoRecalc then begin
                cret.RecalcAbilitys;
              end;
            end;
            if (Random(6) = 0) and BoRecalc then
              SendRefMsg(RM_HIT, 0, CX, CY, 0, '');
          end;
        end;
      end;
      list.Free;
      if Random(2) = 0 then
        SendRefMsg(RM_TURN, 0, CX, CY, 0, '');
    end;
  end;
  inherited Run;
end;

//파황마신 =====================================================================
constructor TPBKingMonster.Create;
begin
  inherited Create;
  ChainShotCount := 3;
  ViewRange      := 12;
end;


procedure TPBKingMonster.Run;
begin
  // 파황마신을 맵가장자리로 데리구 가서죽이는거 방지
  if PEnvir <> nil then begin
    // 맵의 외곽애 위치해 있다면. 간단한 계산이므로 계속 생각하게 해도된다.
    // 파황마신이 있는 66 맵은 300 x 300 맵이다.
    if (CX < 50) or (CX > PEnvir.MapWidth - 70) or (CY < 40) or
      (CY > PEnvir.MapHeight - 70) then begin
      // 타겟이 있으면 없엔후에
      LoseTarget;
      // 내부 안쪽으로 이동... 10타일 안쪽에서 나타나게 하자. 경계부분은 안좋음
      SpaceMove(PEnvir.MapName,
        random(PEnvir.MapWidth - 140) + 60,
        random(PEnvir.MapHeight - 130) + 50,
        1);
    end;
  end;

  // 기존 실행을 한다.
  inherited Run;
end;

procedure TPBKingMonster.Attack(target: TCreature; dir: byte);
var
  i, ix, iy, ix2, iy2, levelgap, push: integer;
  ixf, ixt, iyf, iyt, pwr, dam: integer;
  list: TList;
  cret: TCreature;
begin
  Self.Dir := GetNextDirection(CX, CY, target.CX, target.CY);
  with WAbil do
    pwr := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));

  ixf := _MAX(0, CX - 2);
  ixt := _MIN(pEnvir.MapWidth - 1, CX + 2);
  iyf := _MAX(0, CY - 2);
  iyt := _MIN(pEnvir.MapHeight - 1, CY + 2);

  for ix := ixf to ixt do begin
    for iy := iyf to iyt do begin
      list := TList.Create;
      PEnvir.GetAllCreature(ix, iy, True, list);
      for i := 0 to list.Count - 1 do begin
        cret := TCreature(list[i]);
        if IsProperTarget(cret) then begin
          dam := cret.GetMagStruckDamage(self, pwr);
          if dam > 0 then begin
            cret.StruckDamage(dam, self);
            cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
              cret.WAbil.HP{lparam1},
              cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '', 200);
            if Random(10) = 0 then
              cret.MakePoison(POISON_STONE, 5, 0);
          end;
        end;
      end;
      list.Free;
    end;
  end;
  SendRefMsg(RM_HIT, self.Dir, CX, CY, integer(target), '');
  // 밀어낼 방향 확인
  ix  := 0;
  iy  := 0;
  ix2 := 0;
  iy2 := 0;
  case self.Dir of
    0: begin
      ix  := CX;
      iy  := _MAX(0, CY - 1);
      ix2 := CX;
      iy2 := _MAX(0, CY - 2);
    end;
    1: begin
      ix  := _MIN(pEnvir.MapWidth - 1, CX + 1);
      iy  := _MAX(0, CY - 1);
      ix2 := _MIN(pEnvir.MapWidth - 1, CX + 2);
      iy2 := _MAX(0, CY - 2);
    end;
    2: begin
      ix  := _MIN(pEnvir.MapWidth - 1, CX + 1);
      iy  := CY;
      ix2 := _MIN(pEnvir.MapWidth - 1, CX + 2);
      iy2 := CY;
    end;
    3: begin
      ix  := _MIN(pEnvir.MapWidth - 1, CX + 1);
      iy  := _MIN(pEnvir.MapHeight - 1, CY + 1);
      ix2 := _MIN(pEnvir.MapWidth - 1, CX + 2);
      iy2 := _MIN(pEnvir.MapHeight - 1, CY + 2);
    end;
    4: begin
      ix  := CX;
      iy  := _MIN(pEnvir.MapHeight - 1, CY + 1);
      ix2 := CX;
      iy2 := _MIN(pEnvir.MapHeight - 1, CY + 2);
    end;
    5: begin
      ix  := _MAX(0, CX - 1);
      iy  := _MIN(pEnvir.MapHeight - 1, CY + 1);
      ix2 := _MAX(0, CX - 2);
      iy2 := _MIN(pEnvir.MapHeight - 1, CY + 2);
    end;
    6: begin
      ix  := _MAX(0, CX - 1);
      iy  := CY;
      ix2 := _MAX(0, CX - 2);
      iy2 := CY;
    end;
    7: begin
      ix  := _MAX(0, CX - 1);
      iy  := _MAX(0, CY - 1);
      ix2 := _MAX(0, CX - 2);
      iy2 := _MAX(0, CY - 2);
    end;
  end;

  list := TList.Create;
  list.Clear;
  PEnvir.GetAllCreature(ix, iy, True, list);
  // MainOutMessage ('[TPBKingMonster] ix,iy,Count=' + IntToStr(ix)+'/'+IntToStr(iy)+'/'+IntToStr(list.Count));
  for i := 0 to list.Count - 1 do begin
    cret := TCreature(list[i]);
    if IsProperTarget(cret) then begin
      if (not cret.Death) and ((cret.RaceServer = RC_USERHUMAN) or
        (cret.Master <> nil)) then begin
        levelgap := 60 - cret.Abil.Level;
        if (Random(20) < 4 + levelgap) then begin
          push := 3 + Random(3);
          cret.CharPushed(Self.Dir, push);
        end;
      end;
    end;
  end;
  list.Free;

  list := TList.Create;
  PEnvir.GetAllCreature(ix2, iy2, True, list);
  // MainOutMessage ('[TPBKingMonster] ix2,iy2,Count=' + IntToStr(ix2)+'/'+IntToStr(iy2)+'/'+IntToStr(list.Count));
  for i := 0 to list.Count - 1 do begin
    cret := TCreature(list[i]);
    if IsProperTarget(cret) then begin
      if (not cret.Death) and ((cret.RaceServer = RC_USERHUMAN) or
        (cret.Master <> nil)) then begin
        levelgap := 60 - cret.Abil.Level;
        if (Random(20) < 4 + levelgap) then begin
          push := 3 + Random(3);
          cret.CharPushed(Self.Dir, push);
        end;
      end;
    end;
  end;
  list.Free;
end;

procedure TPBKingMonster.RangeAttack(targ: TCreature); //반드시 target <> nil
var
  i, ix, iy, ixf, ixt, iyf, iyt, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;
begin
  inherited RangeAttack(targ);
  // 시야내 모든 케릭/소환몹 피깍음
  for i := 0 to VisibleActors.Count - 1 do begin
    cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
    if IsProperTarget(cret) then begin
      if (cret.RaceServer = RC_USERHUMAN) or (cret.Master <> nil) then begin
        dam := (cret.WAbil.HP div 4);
        cret.DamageHealth(dam, 0); //보호의반지적용 2004-01-17
        cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
          cret.WAbil.HP{lparam1}, cret.WAbil.MaxHP{lparam2},
          longint(self){hiter}, '', 800);
      end;
    end;
  end;
end;

function TPBKingMonster.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if TargetCret <> nil then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;
      if (abs(CX - TargetCret.CX) <= 12) and (abs(CY - TargetCret.CY) <= 12) then begin
        if (TargetInSpitRange(TargetCret, targdir)) and (Random(3) <> 0) then begin
          TargetFocusTime := GetTickCount;
          Attack(TargetCret, targdir);

          try
            if ((random(3) = 0) and (VisibleActors.Count > 0)) then begin
              TargetCret :=
                TCreature(PTVisibleActor(
                VisibleActors[Random(VisibleActors.Count)]).cret);
              if (TargetCret <> nil) then begin
                SetTargetXY(TargetCret.CX, TargetCret.CY);
              end;
            end;
          except
            MainOutMessage(
              '[Exception] TPBKingMonster.AttackTarget fail target change 1');
          end;

          Result := True;
        end else begin
          if ChainShot < ChainShotCount - 1 then begin
            Inc(ChainShot);
            TargetFocusTime := GetTickCount;
            RangeAttack(TargetCret);
          end else begin
            if Random(5) = 0 then
              ChainShot := 0;
            // 3초
            try

              if (GetCurrentTime > longint(3000 + TargetFocusTime)) and
                (VisibleActors.Count > 0) then begin
                TargetCret :=
                  TCreature(PTVisibleActor(
                  VisibleActors[Random(VisibleActors.Count)]).cret);
                if (TargetCret <> nil) then begin
                  SetTargetXY(TargetCret.CX, TargetCret.CY);
                  TargetFocusTime := GetTickCount;
                end;
              end;

            except
              MainOutMessage(
                '[Exception] TPBKingMonster.AttackTarget fail target change 2');
            end;
          end;
          Result := True;
        end;
      end else begin
        if TargetCret.MapName = self.MapName then begin
          if (abs(CX - TargetCret.CX) <= 11) and (abs(CY - TargetCret.CY) <= 11) then
          begin
            SetTargetXY(TargetCret.CX, TargetCret.CY);
          end;
        end else begin
          LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
        end;
      end;
    end;
  end;
end;

//황금이무기(부룡금사) =====================================================================
constructor TGoldenImugi.Create;
begin
  inherited Create;
  ViewRange    := 12;
  TwinGenDelay := 100;  //3초단위
  sectick      := GetTickCount;
  DontBagItemDrop := True;
  DontBagGoldDrop := True;
  FirstCheck   := True;

  DontAttack := True;
  DontAttackCheck := False;
  AttackState := False;
  InitialState := False;
  ChildMobRecalled := False;
  FinalWarp := False;

  RevivalTime := GetTickCount;
  WarpTime    := GetTickCount;

  TargetTime      := GetTickCount;
  RangeAttackTime := GetTickCount;
  OldTargetCret   := nil;
end;

procedure TGoldenImugi.RunMsg(msg: TMessageInfo);
begin
  case msg.Ident of
    RM_MAKEPOISON: begin
      DontAttack := False;
    end;
  end;

  inherited RunMsg(msg);
end;

procedure TGoldenImugi.Run;
var
  ix, iy, ndir: integer;
  nx, ny: integer;
  cret:   TCreature;
  imugicount, snakecount: integer;
begin
  cret := nil;
  snakecount := 0;
  // 짝이무기 생성 조건
  // 3초에 한번씩 검사
  if GetTickCount - sectick > 3000 then begin
    BreakHolySeize;
    imugicount := 0;
    sectick    := GetTickCount;
    if PEnvir <> nil then begin
      for ix := 0 to PEnvir.MapWidth - 1 do begin
        for iy := 0 to PEnvir.MapHeight - 1 do begin
          cret := TCreature(PEnvir.GetCreature(ix, iy, True));
          if cret <> nil then begin
            if (not cret.Death) and (cret.RaceServer = RC_GOLDENIMUGI) then begin
              if not self.Death then begin
                if DontAttackCheck then
                  TGoldenImugi(cret).DontAttack := False
                else if DontAttack = False then
                  DontAttackCheck := True;
              end;
              Inc(imugicount);
              if imugicount > 2 then begin
                cret.MakeGhost(8);
              end;
              // 이 부분은 두번째 이무기만 생각하는 부분.
              if (imugicount = 2) and (cret <> self) then begin
                // 일정 범위 이상 떨어져 있으면 짝이무기 자리로 이동한다.
                if (abs(cret.CX - self.CX) >= 10) or
                  (abs(cret.CY - self.CY) >= 10) then begin
                  // 내가 WarpTime이 오래됐으면 내가 워프한다.
                  if self.WarpTime < TGoldenImugi(cret).WarpTime then begin
                    // 워프 NormalEffect
                    SendRefMsg(RM_NORMALEFFECT, 0, CX, CY,
                      NE_SN_MOVEHIDE, '');
                    SpaceMove(cret.PEnvir.MapName, cret.CX, cret.CY, 0);
                    WarpTime := GetTickCount;
                    SendRefMsg(RM_NORMALEFFECT, 0, CX, CY,
                      NE_SN_MOVESHOW, '');
                  end else begin
                    // 내가 WarpTime이 최근이면 WarpTime이 오래된 이무기가 워프한다.
                    // 워프 NormalEffect
                    cret.SendRefMsg(RM_NORMALEFFECT, 0,
                      cret.CX, cret.CY, NE_SN_MOVEHIDE, '');
                    cret.SpaceMove(self.PEnvir.MapName, self.CX, self.CY, 0);
                    TGoldenImugi(cret).WarpTime := GetTickCount;
                    cret.SendRefMsg(RM_NORMALEFFECT, 0,
                      cret.CX, cret.CY, NE_SN_MOVESHOW, '');
                  end;
                end;
                // 너무 가까이 있으면 떨어뜨린다.
                if (abs(cret.CX - self.CX) <= 2) and
                  (abs(cret.CY - self.CY) <= 2) then begin
                  //도망감.
                  if Random(3) = 0 then begin
                    ndir :=
                      GetNextDirection(cret.CX, cret.CY, self.CX, self.CY);
                    GetNextPosition(PEnvir, cret.CX, cret.CY,
                      ndir, 5, self.TargetX, self.TargetY);
                  end;
                end;
              end;
            end;
            if (not cret.Death) and (cret.UserName = __WhiteSnake) then begin
              Inc(snakecount);
            end;
          end;
        end;
      end;
    end;

    //처음 체크인 경우
    if FirstCheck then begin
      FirstCheck   := False;
      TwinGenDelay := 1;
    end;

    // 이무기가 혼자 있으면 짝이무기를 생성한다.(부활)
    if imugicount = 1 then begin
      if TwinGenDelay <= 0 then begin
        cret := UserEngine.AddCreatureSysop(PEnvir.MapName,
          _MIN(CX + 2, PEnvir.MapWidth - 1), CY, __GoldenImugi);
        if cret <> nil then begin
          if not DontAttack then
            UserEngine.CryCry(RM_CRY, PEnvir, CX, CY, 10000,
              ' -' + __GoldenImugi + ' has recalled its clone.');
          // 부활 시킨 시간
          RevivalTime := GetTickCount;

          // 부활 시전 NormalEffect
          SendRefMsg(RM_LIGHTING, self.Dir, self.CX, self.CY, integer(self), '');
          // 부활 NormalEffect
          cret.SendRefMsg(RM_NORMALEFFECT, 0, cret.CX, cret.CY, NE_SN_RELIVE, '');
          // 체력 조정
          if not DontAttack then begin
            cret.WAbil.HP := (cret.WAbil.MaxHP div 3) * 2;
          end;

          if DontAttack then begin
            //공격 상태가 아니면 부활 시킨 후에 다시 잠든다.
            InitialState := False;
          end;
        end;
        TwinGenDelay := 100;
      end;
      Dec(TwinGenDelay);

      //이무기가 한마리 남아 있으면 시체를 만들지 않는다.
      if Death then begin
        MakeGhost(8);
      end;
    end else if imugicount >= 2 then begin
      FirstCheck   := False;
      TwinGenDelay := 100;
    end;
  end;

  if DontAttack = False then begin
    if AttackState = False then begin
      SendRefMsg(RM_TURN, Dir, CX, CY, 0, '');
      AttackState := True;
      BoDontMove  := False;
    end;
  end else begin
    if InitialState = False then begin
      SendRefMsg(RM_DIGDOWN, Dir, CX, CY, 0, '');
      InitialState := True;
      BoDontMove   := True;
    end;
  end;

  //백사 마리수 * 체력 회복량
  if snakecount > 0 then begin
    AddAbil.HealthRecover := snakecount * 2;
    HealthRecover := AddAbil.HealthRecover;
  end else begin
    AddAbil.HealthRecover := 0;
    HealthRecover := AddAbil.HealthRecover;
  end;

  //체력이 50% 남았을때 백사 소환
  if WAbil.HP <= WAbil.MaxHP div 2 then begin
    if not ChildMobRecalled then begin
      GetFrontPosition(self, nx, ny);
      UserEngine.AddCreatureSysop(PEnvir.MapName, nx, ny, __WhiteSnake);
      UserEngine.AddCreatureSysop(PEnvir.MapName, nx, ny, __WhiteSnake);
      ChildMobRecalled := True;
    end;
  end;

  //체력이 10% 남았을때 랜덤 워프
  if WAbil.HP <= WAbil.MaxHP div 10 then begin
    if not FinalWarp then begin
      //60초 동안 방어력/마방력 증가
      MagDefenceUp(60, 20);
      MagMagDefenceUp(60, 20);
      LoseTarget;

      // 워프 NormalEffect
      SendRefMsg(RM_NORMALEFFECT, 0, CX, CY, NE_SN_MOVEHIDE, '');
      //         SpaceMove (PEnvir.MapName, Random(PEnvir.MapWidth), Random(PEnvir.MapHeight), 0);
      RandomSpaceMoveInRange(0, 30, 80);
      WarpTime := GetTickCount;
      SendRefMsg(RM_NORMALEFFECT, 0, CX, CY, NE_SN_MOVESHOW, '');
      FinalWarp := True;
    end;
  end;

  // 기존 실행을 한다.
  inherited Run;
end;

procedure TGoldenImugi.Attack(targ: TCreature; dir: byte);
var
  i, k, mx, my, dam, armor: integer;
  cret: TCreature;
  pwr:  integer;
begin
  //targ는 쓰이지 않음

  self.Dir := dir;
  with WAbil do
    dam := Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1);
  if dam <= 0 then
    exit;

  SendRefMsg(RM_HIT, self.Dir, CX, CY, 0, '');

  with WAbil do
    pwr := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));
  for i := 0 to 4 do
    for k := 0 to 4 do begin
      if SpitMap[dir, i, k] = 1 then begin
        mx   := CX - 2 + k;
        my   := CY - 2 + i;
        cret := TCreature(PEnvir.GetCreature(mx, my, True));
        if (cret <> nil) and (cret <> self) then begin
          if IsProperTarget(cret) then begin
            //cret.RaceServer = RC_USERHUMAN then begin
            //맞는지 결정
            if Random(cret.SpeedPoint) < AccuracyPoint then begin
              {inherited} HitHit2(cret, 0, pwr, True);
            end;
          end;
        end;
      end;
    end;
end;

procedure TGoldenImugi.RangeAttack(targ: TCreature); //반드시 target <> nil
var
  i, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;
begin
  if targ = nil then
    exit;

  Self.Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
  SendRefMsg(RM_LIGHTING_1, self.Dir, CX, CY, integer(targ), '');
  if GetNextPosition(PEnvir, CX, CY, dir, 1, sx, sy) then begin
    GetNextPosition(PEnvir, CX, CY, dir, 9, tx, ty);
    with WAbil do
      pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

    list := TList.Create;
    PEnvir.GetCreatureInRange(targ.CX, targ.CY, 1, True, list);
    for i := 0 to list.Count - 1 do begin
      cret := TCreature(list[i]);
      if IsProperTarget(cret) then begin
        dam := cret.GetMagStruckDamage(self, pwr);
        if dam > 0 then begin
          cret.StruckDamage(dam, self);
          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1},
            cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '', 800);
        end;
      end;
    end;
    list.Free;
  end;
end;

procedure TGoldenImugi.RangeAttack2(targ: TCreature); //반드시 target <> nil
var
  i, ix, iy, ixf, ixt, iyf, iyt, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;
begin
  if targ = nil then
    exit;

  // 독안개 NormalEffect
  SendRefMsg(RM_LIGHTING, self.Dir, CX, CY, integer(self), '');
  SendRefMsg(RM_NORMALEFFECT, 0, CX, CY, NE_POISONFOG, '');

  // 시야내 모든 캐릭/소환몹 중독
  for i := 0 to VisibleActors.Count - 1 do begin
    cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
    if (not cret.Death) and IsProperTarget(cret) then begin
      if (cret.RaceServer = RC_USERHUMAN) or (cret.Master <> nil) then begin
        //방어력이 감소하는 독에 중독 된다.
        if Random(2 + cret.AntiPoison) = 0 then
          cret.MakePoison(POISON_DAMAGEARMOR, 60, 5);
      end;
    end;
  end;
end;

function TGoldenImugi.AttackTarget: boolean;
var
  targdir: byte;
  cret:    TCreature;
begin
  Result := False;
  cret   := nil;
  if DontAttack then begin
    LoseTarget;
    exit;
  end;

  if (GetCurrentTime < longint(longword(Random(3000) + 4000) + TargetTime)) then begin
    if OldTargetCret <> nil then
      TargetCret := OldTargetCret;
  end;

  if TargetCret <> nil then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;
      if (abs(CX - TargetCret.CX) <= 11) and (abs(CY - TargetCret.CY) <= 11) then begin
        if ((TargetInSpitRange(TargetCret, targdir)) and (Random(3) < 2)) or
          (GetTickCount - RevivalTime < 3000) then begin
          TargetFocusTime := GetTickCount;
          Dir := GetNextDirection(CX, CY, TargetCret.CX, TargetCret.CY);
          Attack(TargetCret, targdir);

          //UserEngine.CryCry (RM_CRY, PEnvir, CX, CY, 10000, ' Attack : ' + TargetCret.UserName);//test

          Result := True;
        end else begin
          if (GetCurrentTime < longint(8000 + TargetTime)) then begin
            TargetFocusTime := GetTickCount;
            if (GetCurrentTime < longint(30000 + RangeAttackTime)) and
              (Random(10) < 8) then begin
              RangeAttack(TargetCret);
              //UserEngine.CryCry (RM_CRY, PEnvir, CX, CY, 10000, ' RangeAttack : ' + TargetCret.UserName);//test
            end else begin
              RangeAttack2(TargetCret);
              RangeAttackTime := GetTickCount;
              //UserEngine.CryCry (RM_CRY, PEnvir, CX, CY, 10000, ' RangeAttack (2)');//test
            end;
          end else begin
            try
              if (VisibleActors.Count > 0) then begin
                cret :=
                  TCreature(PTVisibleActor(
                  VisibleActors[Random(VisibleActors.Count)]).cret);
                if cret <> nil then begin
                  if not cret.Death then begin
                    TargetCret    := cret;
                    OldTargetCret := TargetCret;
                    //UserEngine.CryCry (RM_CRY, PEnvir, CX, CY, 10000, ' Targeting : ' + TargetCret.UserName);//test
                    SetTargetXY(TargetCret.CX, TargetCret.CY);
                    TargetFocusTime := GetTickCount;
                    TargetTime      := GetTickCount;
                  end;
                end;
              end;
            except
              MainOutMessage(
                '[Exception] TGoldenImugi.AttackTarget fail target change 3');
            end;
          end;
          Result := True;
        end;
      end else begin
        if TargetCret.MapName = self.MapName then begin
          if (abs(CX - TargetCret.CX) <= ViewRange) and
            (abs(CY - TargetCret.CY) <= ViewRange) then begin
            SetTargetXY(TargetCret.CX, TargetCret.CY);
          end;
        end else begin
          LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
        end;
      end;
    end;
  end;
end;

procedure TGoldenImugi.Struck(hiter: TCreature);
begin
  // 맞으면 공격모드로 변경
  DontAttack := False;
end;

procedure TGoldenImugi.Die;
var
  ix, iy: integer;
  cret:   TCreature;
  imugicount: integer;
begin
  imugicount := 0;
  //내가 마지막 이무기이면 아이템을 떨군다.
  if PEnvir <> nil then begin
    for ix := 0 to PEnvir.MapWidth - 1 do begin
      for iy := 0 to PEnvir.MapHeight - 1 do begin
        cret := TCreature(PEnvir.GetCreature(ix, iy, True));
        if cret <> nil then begin
          if (not cret.Death) and (cret.RaceServer = RC_GOLDENIMUGI) then begin
            Inc(imugicount);
          end;
        end;
      end;
    end;
  end;
  if imugicount = 1 then begin
    DontBagItemDrop := False;
    DontBagGoldDrop := False;
  end;

  inherited Die;
end;


//RedFoxman ==================================================================
constructor TFoxWizard.Create;
begin
  inherited Create;
  ChainShotCount := 6;
  BoCallFollower := False;
end;

procedure TFoxWizard.Attack(target: TCreature; dir: byte);
begin
end;

procedure TFoxWizard.RangeAttack(targ: TCreature); //반드시 target <> nil
var
  i, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;
begin
  if targ = nil then
    exit;

  if (Random(10)=0) then
  RangeAttack2(TargetCret);

  Self.Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
  SendRefMsg(RM_LIGHTING, self.Dir, CX, CY, integer(targ), '');
  if GetNextPosition(PEnvir, CX, CY, dir, 1, sx, sy) then begin
    GetNextPosition(PEnvir, CX, CY, dir, 9, tx, ty);
    with WAbil do
      pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

    list := TList.Create;
    PEnvir.GetAllCreature(targ.CX, targ.CY, True, list);
    for i := 0 to list.Count - 1 do begin
      cret := TCreature(list[i]);
      if IsProperTarget(cret) then begin
        dam := cret.GetMagStruckDamage(self, pwr);
        if dam > 0 then begin
          cret.StruckDamage(dam, self);
          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1},
            cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '', 800);
        end;
      end;
    end;
    list.Free;
  end;
end;

procedure TFoxWizard.RangeAttack2(targ: TCreature); //반드시 target <> nil
var
  i, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;
begin
  if targ = nil then
    exit;

  Self.Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
  SendRefMsg(RM_LIGHTING_1, self.Dir, CX, CY, integer(targ), '');
  if GetNextPosition(PEnvir, CX, CY, dir, 1, sx, sy) then begin
    GetNextPosition(PEnvir, CX, CY, dir, 9, tx, ty);
    with WAbil do
      pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

    list := TList.Create;
    PEnvir.GetAllCreature(targ.CX, targ.CY, True, list);
    for i := 0 to list.Count - 1 do begin
      cret := TCreature(list[i]);
      if IsProperTarget(cret) then begin
        dam := cret.GetMagStruckDamage(self, pwr);
        if dam > 0 then begin
          cret.StruckDamage(dam, self);
          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1},
            cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '', 800);
        end;
      end;
    end;
    list.Free;
  end;
end;

procedure TFoxWizard.MoveSelf;
begin;
SendRefMsg(RM_NORMALEFFECT, 0, self.CX, self.CY, FOX_SN_MOVEHIDE, '');
RandomSpaceMoveInRange(0, 5, 5);
SendRefMsg(RM_NORMALEFFECT, 0, self.CX, self.CY, FOX_SN_MOVESHOW, '');
end;

function TFoxWizard.AttackTarget: boolean;
var
  targdir: byte;
  cret: TCreature;
begin
  Result := False;
  if TargetCret <> nil then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;
      if (abs(CX - TargetCret.CX) <= 7) and (abs(CY - TargetCret.CY) <= 7) then begin
        if (TargetInAttackRange(TargetCret, targdir)) and (Random(20) = 0) then begin
          TargetFocusTime := GetTickCount;
          MoveSelf;
        end else begin
          if ChainShot < ChainShotCount - 1 then begin
            Inc(ChainShot);
            TargetFocusTime := GetTickCount;
            RangeAttack(TargetCret);
          end else begin
            if Random(5) = 0 then
              ChainShot := 0;
          end;
          Result := True;
        end;
      end else begin
        if TargetCret.MapName = self.MapName then begin
          if (abs(CX - TargetCret.CX) <= 11) and (abs(CY - TargetCret.CY) <= 11) then
          begin
            SetTargetXY(TargetCret.CX, TargetCret.CY);
          end;
        end else begin
          LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
        end;
      end;
    end;
  end;
end;

//WhiteFoxman ==================================================================
constructor TFoxTao.Create;
begin
  inherited Create;
  ChainShotCount := 9;
  BoCallFollower := False;
end;

procedure TFoxTao.Attack(target: TCreature; dir: byte);
var
pwr: integer;
begin
  with WAbil do
    pwr := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));
    {inherited} HitHit2(target, 0, pwr, True);
end;

procedure TFoxTao.CallFollower;
var
targ: TCreature;
begin
if (self.GetExistSlave(__Shinsu) = nil) and
(self.GetExistSlave(__Shinsu1) = nil) then begin
SendRefMsg(RM_LIGHTING_1, Dir, CX, CY, integer(targ), '');
SendRefMsg(RM_NORMALEFFECT, 0, self.CX, self.CY, FOX_SN_SUMMON, '');
self.MakeSlave(__ShinSu, 0, 1, 10 * 24 * 60 * 60)
end else exit;
end;

procedure TFoxTao.RangeAttack(targ: TCreature); //반드시 target <> nil
var
  dam, armor: integer;
begin
  if targ = nil then
    exit;

  if (Random(10)=0) then
  RangeAttack2(TargetCret);

  if PEnvir.CanFly(CX, CY, targ.CX, targ.CY) then begin //도끼가 날아갈수 있는지.
    Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
    with WAbil do
      dam := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));
    if dam > 0 then begin
      dam := targ.GetHitStruckDamage(self, dam);
    end;
    if dam > 0 then begin
      targ.StruckDamage(dam, self);
      targ.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
        targ.WAbil.HP{lparam1}, targ.WAbil.MaxHP{lparam2},
        longint(self){hiter}, '', 600 + _MAX(Abs(CX - targ.CX), Abs(CY - targ.CY)) * 50);
    end;
    SendRefMsg(RM_FLYAXE, Dir, CX, CY, integer(targ), '');
  end;
end;

procedure TFoxTao.RangeAttack2(targ: TCreature); //반드시 target <> nil
var
  i, ix, iy, ixf, ixt, iyf, iyt, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;
begin
  if targ = nil then
    exit;

  Self.Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
  SendRefMsg(RM_LIGHTING, self.Dir, CX, CY, integer(targ), '');
  if GetNextPosition(PEnvir, CX, CY, dir, 1, sx, sy) then begin
    GetNextPosition(PEnvir, CX, CY, dir, 9, tx, ty);
    with WAbil do
      pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

    ixf := _MAX(0, targ.CX - 2);
    ixt := _MIN(pEnvir.MapWidth - 1, targ.CX + 2);
    iyf := _MAX(0, targ.CY - 2);
    iyt := _MIN(pEnvir.MapHeight - 1, targ.CY + 2);

    for ix := ixf to ixt do begin
      for iy := iyf to iyt do begin
        list := TList.Create;
        PEnvir.GetAllCreature(ix, iy, True, list);
        for i := 0 to list.Count - 1 do begin
          cret := TCreature(list[i]);
          if IsProperTarget(cret) then begin
            dam := cret.GetMagStruckDamage(self, pwr);
            if dam > 0 then begin
         //  if Random(20 + cret.AntiPoison) = 0 then
            cret.MakePoison(POISON_SLOW, 3, 1);
              end;
            end;
          end;
        end;
        list.Free;
      end;
    end;
  end;

procedure TFoxTao.MoveSelf;
begin;
end;

function TFoxTao.AttackTarget: boolean;
var
  targdir: byte;
  i, ix, iy: integer;
begin
  Result := False;
 // if (TargetCret.UserName = __ShinSu) or (TargetCret.UserName = __ShinSu1) then begin
 // LoseTarget
  if TargetCret <> nil then begin
   if (Random(20) = 0) then begin
   CallFollower;
   end else
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;
      if (abs(CX - TargetCret.CX) <= 7) and (abs(CY - TargetCret.CY) <= 7) then begin
        if (TargetInAttackRange(TargetCret, targdir)) then begin
          TargetFocusTime := GetTickCount;
          Attack(TargetCret, targdir);
        end else begin
          if (ChainShot < ChainShotCount - 1) then begin
            Inc(ChainShot);
            TargetFocusTime := GetTickCount;
            RangeAttack(TargetCret);
          end else begin
            if Random(5) = 0 then
              ChainShot := 0;
          end;
          Result := True;
        end;
      end else begin
        if TargetCret.MapName = self.MapName then begin
          if (abs(CX - TargetCret.CX) <= 11) and (abs(CY - TargetCret.CY) <= 11) then
          begin
            SetTargetXY(TargetCret.CX, TargetCret.CY);
          end;
        end else begin
          LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
        end;
      end;
    end;
  end;
end;

//Fake TrapRock ===============================================================
constructor TFakeRock.Create;
begin
  inherited Create;
  RunDone      := False;
  ViewRange    := 1;
  RunNextTick  := 250;
  SearchRate   := 2500 + longword(Random(1500));
  SearchTime   := GetTickCount;
  RaceServer   := RC_FAKEROCK;
  DigupRange   := 1;
  DigdownRange := 1;
  HideMode     := True;
  StickMode    := True;
  BoAnimal     := False;  //썰면 식인초잎, 식인초열매가 나옴.
end;


function TFakeRock.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if TargetCret <> nil then begin
    if TargetInAttackRange(TargetCret, targdir) then begin
      if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
        HitTime := GetCurrentTime;
        TargetFocusTime := GetTickCount;
        Attack(TargetCret, targdir);
      end;
      Result := True;
    end else begin
      if TargetCret.MapName = self.MapName then
        SetTargetXY(TargetCret.CX, TargetCret.CY)
      else
        LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
    end;
  end;
end;

procedure TFakeRock.ComeOut;
begin
  HideMode := False;
  SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
end;


procedure TFakeRock.CheckComeOut;
var
targdir: byte;
begin
          if TargetInAttackRange(TargetCret, targdir) then
          begin
        ComeOut; //밖으로 나오다. 보인다.
        end;
end;

procedure TFakeRock.ComeDown;
begin
WAbil.HP := 0;
end;

procedure TFakeRock.Run;
var
  boidle: boolean;
begin
  //   if (not BoGhost) and (not Death) and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if IsMoveAble then begin
    if GetCurrentTime - WalkTime > GetNextWalkTime then begin
      WalkTime := GetCurrentTime;
      if HideMode then begin //아직 모습을 나타내지 않았음.
        CheckComeOut;
      end else begin
        if integer(GetCurrentTime - HitTime) > GetNextHitTime then
        begin //상속받은 run 에서 HitTime 재설정함.
              ///HitTime := GetTickCount; //아래 AttackTarget에서 함.
          MonsterNormalAttack;
        end;

        boidle := False;
        if TargetCret <> nil then begin
          if (abs(TargetCret.CX - CX) > DigdownRange) or
            (abs(TargetCret.CY - CY) > DigdownRange) then
            boidle := True;
        end else
          boidle := True;

        if boidle then
          ComeDown //다시 들어간다.
        else if AttackTarget then begin
          inherited Run;
          exit;
        end;
      end;
    end;
  end;

  inherited Run;

end;

procedure TFakeRock.Struck(hiter: TCreature);
begin
  if hiter <> nil then begin
    WAbil.HP := WAbil.MaxHP;
    hiter := nil;
    lasthiter := nil;
    exphiter := nil;
  end;

end;




 {---------------------------------------------------------------------------}
 //GuardianRock


constructor TGuardRock.Create;
begin
  inherited Create;
  StickMode    := True;
  BoDontMove    := True;
  BoAnimal     := False;
end;

procedure TGuardRock.Attack(target: TCreature; dir: byte);
begin
end;

procedure TGuardRock.RangeAttack(target: TCreature);
var
  pwr: integer;
  ndir: byte;
begin
  with WAbil do
    pwr := 0;

 if (abs(CX - TargetCret.CX) <= 5) and (abs(CY - TargetCret.CY) <= 5) then begin
//     SendRefMsg(RM_LIGHTING, 0, CX, CY, integer(target), '');
     inherited HitHit2(target, pwr, 0, True);
      ndir := GetNextDirection(target.CX, target.CY, self.CX, self.CY);
target.SendRefMsg(RM_LOOPNORMALEFFECT, integer(target), 0, 0, NE_ROCKPULLEFFECT, '');
      target.CharPushed(ndir, 2);
    SendRefMsg(RM_NORMALEFFECT, 0, self.CX, self.CY, ROCK_SN_PULL, '');
    end;
 end;

procedure TGuardRock.Run;
begin
inherited Run;
end;

procedure TGuardRock.Struck(hiter: TCreature);
begin
WAbil.HP := WAbil.MaxHP;
end;

function TGuardRock.AttackTarget: boolean;
var
  targdir: byte;
  i, ix, iy: integer;
begin
  Result := False;
 // if (TargetCret.UserName = __ShinSu) or (TargetCret.UserName = __ShinSu1) then begin
 // LoseTarget
  if TargetCret <> nil then begin
    if integer(GetCurrentTime - HitTime) > (GetNextHitTime * 10) then begin
      HitTime := GetCurrentTime;
      if (abs(CX - TargetCret.CX) <= 7) and (abs(CY - TargetCret.CY) <= 7) then begin
      if WAbil.MaxHP > 100 then begin
          TargetFocusTime := GetTickCount;
          RangeAttack(TargetCret);
        end else begin
          Result := True;
        end;
        end;
        if TargetCret.MapName = self.MapName then begin
          if (abs(CX - TargetCret.CX) <= 11) and (abs(CY - TargetCret.CY) <= 11) then
          begin
            SetTargetXY(TargetCret.CX, TargetCret.CY);
          end;
        end else begin
          LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
        end;
      end;
    end;
  end;

 {---------------------------------------------------------------------------}
 //ThunderElement


constructor TElementOfThunder.Create;
begin
  inherited Create;
  BoAnimal     := False;
  ViewRange    := 7;
end;

procedure TElementOfThunder.Attack(target: TCreature; dir: byte);
begin
end;

procedure TElementOfThunder.RangeAttack(target: TCreature);
var
  i, ix, iy, ixf, ixt, iyf, iyt, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;
begin
  if target = nil then
    exit;

  SendRefMsg(RM_LIGHTING, 0, CX, CY, integer(self), '');
    with WAbil do
      pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

    ixf := _MAX(0, self.CX - 2);
    ixt := _MIN(pEnvir.MapWidth - 1, self.CX + 2);
    iyf := _MAX(0, self.CY - 2);
    iyt := _MIN(pEnvir.MapHeight - 1, self.CY + 2);

    for ix := ixf to ixt do begin
      for iy := iyf to iyt do begin
        list := TList.Create;
        PEnvir.GetAllCreature(ix, iy, True, list);
        for i := 0 to list.Count - 1 do begin
          cret := TCreature(list[i]);
          if IsProperTarget(cret) then begin
            dam := cret.GetMagStruckDamage(self, pwr);
            if dam > 0 then begin
          cret.StruckDamage(dam, self);
          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1},
            cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '', 800);
         //  if Random(20 + cret.AntiPoison) = 0 then
          //  cret.MakePoison(POISON_SLOW, 3, 1);
              end;
            end;
          end;
        end;
        list.Free;
      end;
    end;

procedure TElementOfThunder.Run;
begin
inherited Run;
end;

procedure TElementOfThunder.Struck(hiter: TCreature);
begin
WAbil.HP := WAbil.MaxHP;
end;

function TElementOfThunder.AttackTarget: boolean;
var
  targdir: byte;
  i, ix, iy: integer;
begin
  Result := False;
 // if (TargetCret.UserName = __ShinSu) or (TargetCret.UserName = __ShinSu1) then begin
 // LoseTarget
  if TargetCret <> nil then begin
    if integer(GetCurrentTime - HitTime) > (GetNextHitTime) then begin
      HitTime := GetCurrentTime;
      if (abs(CX - TargetCret.CX) <= 2) and (abs(CY - TargetCret.CY) <= 2) then begin
          RangeAttack(TargetCret);
        end else begin
          Result := True;
        end;
      if (abs(CX - TargetCret.CX) <= 7) and (abs(CY - TargetCret.CY) <= 7) then begin
                    TargetFocusTime := GetTickCount;
          SetTargetXY(TargetCret.CX, TargetCret.CY);
        end;
        if TargetCret.MapName <> self.MapName then begin
          LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
        end;
      end;
    end;
  end;

 {---------------------------------------------------------------------------}
 //CloudElement

procedure TElementOfPoison.RangeAttack(target: TCreature);
var
  i, ix, iy, ixf, ixt, iyf, iyt, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;
begin
  if target = nil then
    exit;

  SendRefMsg(RM_LIGHTING, 0, CX, CY, integer(self), '');
    with WAbil do
      pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

    ixf := _MAX(0, self.CX - 2);
    ixt := _MIN(pEnvir.MapWidth - 1, self.CX + 2);
    iyf := _MAX(0, self.CY - 2);
    iyt := _MIN(pEnvir.MapHeight - 1, self.CY + 2);

    for ix := ixf to ixt do begin
      for iy := iyf to iyt do begin
        list := TList.Create;
        PEnvir.GetAllCreature(ix, iy, True, list);
        for i := 0 to list.Count - 1 do begin
          cret := TCreature(list[i]);
          if IsProperTarget(cret) then begin
            dam := cret.GetMagStruckDamage(self, pwr);
            if dam > 0 then begin
          cret.StruckDamage(dam, self);
          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1},
            cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '', 800);
           if Random(20 + cret.AntiPoison) = 0 then
            cret.MakePoison(POISON_DECHEALTH, 5, 1);
              end;
            end;
          end;
        end;
        list.Free;
      end;
    end;

 {---------------------------------------------------------------------------}
 //GreatFoxSpirit


constructor TKingElement.Create;
begin
  inherited Create;
  BoAnimal     := False;
  ViewRange    := 20;
  BoDontMove   := True;
  StickMode    := True;
  CheckRocks   := False;
end;


procedure TKingElement.Die;
var
j: integer;
cret: TCreature;
begin
 inherited Die;
  for j := 0 to rocklist.Count - 1 do begin
    cret := TCreature(rocklist[j]);
    cret.WAbil.MaxHP := 100;
  end;
  rocklist.free;
end;

procedure TKingElement.Attack(target: TCreature; dir: byte);
begin
end;

procedure TKingElement.RangeAttack(target: TCreature);
var
  i, ix, iy, ixf, ixt, iyf, iyt, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;
begin
  if target = nil then
    exit;

  if Random(5) = 0 then
  MassAttack(target);

 // SendRefMsg(RM_LIGHTING, 0, CX, CY, integer(self), '');
  SendRefMsg(RM_NORMALEFFECT, 0, self.CX, self.CY, SPIRIT_SN_THUNDER, '');
    with WAbil do
      pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

    ixf := _MAX(0, self.CX - 2);
    ixt := _MIN(pEnvir.MapWidth - 1, self.CX + 2);
    iyf := _MAX(0, self.CY - 2);
    iyt := _MIN(pEnvir.MapHeight - 1, self.CY + 2);

    for ix := ixf to ixt do begin
      for iy := iyf to iyt do begin
        list := TList.Create;
        PEnvir.GetAllCreature(ix, iy, True, list);
        for i := 0 to list.Count - 1 do begin
          cret := TCreature(list[i]);
          if IsProperTarget(cret) then begin
            dam := cret.GetMagStruckDamage(self, pwr);
            if dam > 0 then begin
          cret.StruckDamage(dam, self);
          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1},
            cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '', 800);
         //  if Random(20 + cret.AntiPoison) = 0 then
          //  cret.MakePoison(POISON_SLOW, 3, 1);
              end;
            end;
          end;
        end;
        list.Free;
      end;
    end;

procedure TKingElement.RangeAttack2(target: TCreature);
var
  i, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;
begin
  if target = nil then
    exit;

//  SendRefMsg(RM_LIGHTING, 0, CX, CY, integer(target), '');
  target.SendRefMsg(RM_LOOPNORMALEFFECT, integer(target), 0, 0, NE_SPIRITEFFECT, '');
  if GetNextPosition(PEnvir, CX, CY, dir, 1, sx, sy) then begin
    GetNextPosition(PEnvir, CX, CY, dir, 9, tx, ty);
    with WAbil do
      pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

    list := TList.Create;
    PEnvir.GetAllCreature(target.CX, target.CY, True, list);
    for i := 0 to list.Count - 1 do begin
      cret := TCreature(list[i]);
      if IsProperTarget(cret) then begin
        dam := cret.GetMagStruckDamage(self, pwr);
        if dam > 0 then begin
          cret.StruckDamage(dam, self);
          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1},
            cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '', 800);
        end;
      end;
    end;
    list.Free;
  end;
end;

procedure TKingElement.MassAttack(target: TCreature);
var
  i, ix, iy, ixf, ixt, iyf, iyt, ima, pwr, dam: integer;
  sx, sy, tx, ty, mx, my: integer;
  list: TList;
  cret: TCreature;
  MassEffect: integer;
begin
  if target = nil then
    exit;

  if random(10) = 0 then
  RangeAttack2(TargetCret);

//  SendRefMsg(RM_LIGHTING, 0, CX, CY, integer(self), '');
  SendRefMsg(RM_NORMALEFFECT, 0, self.CX + Random(5), self.CY + Random(5), SPIRIT_SN_MASS1S, '');
  for ima := 0 to 10 do begin
    case Random(5) of
  0:
  begin
  MassEffect := SPIRIT_SN_MASS1
  end;
  1:
  begin
  MassEffect := SPIRIT_SN_MASS2
  end;
  2:
  begin
  MassEffect := SPIRIT_SN_MASS3
  end;
  3:
  begin
  MassEffect := SPIRIT_SN_MASS4
  end;
  4:
  begin
  MassEffect := SPIRIT_SN_MASS5
  end;
  end;
  case Random(2) of
  0:
  begin
  mx := self.CX + Random(7)
  end;
  1:
  begin
  mx := self.CX - Random(7)
  end;
  end;
  Case Random(2) of
  0:
  begin
  my := self.CY + Random(7)
  end;
  1:
  begin
  my := self.CY - Random(7)
  end;
  end;

    SendRefMsg(RM_NORMALEFFECT, 0, mx, my, MassEffect, '');
  end;

    with WAbil do
      pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

    ixf := _MAX(0, self.CX - 2);
    ixt := _MIN(pEnvir.MapWidth - 1, self.CX + 6);
    iyf := _MAX(0, self.CY - 2);
    iyt := _MIN(pEnvir.MapHeight - 1, self.CY + 6);

    for ix := ixf to ixt do begin
      for iy := iyf to iyt do begin
        list := TList.Create;
        PEnvir.GetAllCreature(ix, iy, True, list);
        for i := 0 to list.Count - 1 do begin
          cret := TCreature(list[i]);
          if IsProperTarget(cret) then begin
            dam := cret.GetMagStruckDamage(self, pwr);
            if dam > 0 then begin
          cret.StruckDamage(dam, self);
          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1},
            cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '', 800);
           if Random(2) = 0 then begin
            cret.SendRefMsg(RM_LOOPNORMALEFFECT, integer(cret), 0, 0, NE_SPIRITMASS, '');
              end;
              end;
            end;
          end;
        end;
        list.Free;
      end;
    end;

procedure TKingElement.Run;
var
monlist: TList;
cret: TCreature;
i, j: integer;
mon, mon2, mon3: TCreature;
begin
inherited Run;
if CheckRocks = False then begin
  monlist := TList.Create;
  rocklist := TList.Create;
  GetMapCreatures(PEnvir, CX, CY, 7, monlist);
  if monlist.Count > 0 then begin
  for i := 0 to monlist.Count - 1 do begin
    cret := TCreature(monlist[i]);
    if cret.RaceServer = RC_GUARDROCK then begin
        rocklist.add(cret);
  end;
  end;
  end;
  monlist.Free;
  if rocklist.Count < 3 then begin
//  if rocklist.Count > 0 then begin
//  for j := 0 to rocklist.Count - 1 do begin
//    cret := TCreature(rocklist[j]);
//    cret.MakeGhost(8);
//  end;
//  end else begin
      mon := UserEngine.AddCreatureSysop(MapName, self.CX, self.CY-7, 'GuardianRock');
      mon2 := UserEngine.AddCreatureSysop(MapName, self.CX+7, self.CY-1, 'GuardianRock');
      mon3 := UserEngine.AddCreatureSysop(MapName, self.CX-7, self.CY-1, 'GuardianRock');
      mon.WAbil.MaxHP := 1000;
      mon2.WAbil.MaxHP := 1000;
      mon3.WAbil.MaxHP := 1000;
      rocklist.Add(mon);
      rocklist.Add(mon2);
      rocklist.Add(mon3);
  CheckRocks := True;
//  end;
  end else begin
  for j := 0 to rocklist.Count - 1 do begin
    cret := TCreature(rocklist[j]);
    cret.WAbil.MaxHP := 1000;
  CheckRocks := True;
  end;
  end;
  end;
end;

procedure TKingElement.Struck(hiter: TCreature);
begin
end;

function TKingElement.AttackTarget: boolean;
var
  targdir: byte;
  i, ix, iy: integer;
begin
  Result := False;
 // if (TargetCret.UserName = __ShinSu) or (TargetCret.UserName = __ShinSu1) then begin
 // LoseTarget
  if TargetCret <> nil then begin
    if integer(GetCurrentTime - HitTime) > (GetNextHitTime * 2) then begin
      HitTime := GetCurrentTime;
      if (abs(CX - TargetCret.CX) <= 6) and (abs(CY - TargetCret.CY) <= 6) then begin
      if (abs(CX - TargetCret.CX) <= 2) and (abs(CY - TargetCret.CY) <= 2) then begin
          RangeAttack(TargetCret);
        end else begin
          MassAttack(TargetCret);
        end;
        end else begin
          TargetCret.SpaceMove(MapName, self.CX, self.CY+1, 0);
          SendRefMsg(RM_LIGHTING_1, 0, CX, CY, integer(self), '');
          Result := True;
        end;
        if TargetCret.MapName <> self.MapName then begin
          LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
        end;
      end;
    end;
  end;

end.
