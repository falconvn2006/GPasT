unit ObjMon3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  ScktComp, syncobjs, MudUtil, HUtil32, Grobal2, Envir, EdCode, ObjBase,
  Event, objmon;

type
  // 분신 ---------------------------------------------------------------------
  TCloneMon = class(TATMonster)
  private
    bofirst: boolean;
    NextMPSpendTime: longword;
    MPSpendTickTime: longword;
  protected
    procedure ResetLevel;
    procedure RangeAttackTo(targ: TCreature);
    function AttackTarget: boolean; override;
    procedure BeforeRecalcAbility;
    procedure AfterRecalcAbility;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RecalcAbilitys; override;
    procedure Run; override;
  end;

  // 월령 ---------------------------------------------------------------------
  TAngelMon = class(TATMonster)
  private
    bofirst: boolean;
  protected
    procedure ResetLevel;
    procedure RangeAttackTo(targ: TCreature);
    function AttackTarget: boolean; override;
    procedure BeforeRecalcAbility;
    procedure AfterRecalcAbility;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RecalcAbilitys; override;
    procedure Run; override;
  end;

  // 화룡  --------------------------------------------------------------------
  TDragon = class(TATMonster)
  private
    bofirst:   boolean;
    ChildList: TList;
  protected
    procedure RangeAttack(targ: TCreature);
    procedure ResetLevel;
    procedure AttackAll(targ: TCreature);
  public
    constructor Create;
    destructor Destroy; override;
    procedure RecalcAbilitys; override;
    function AttackTarget: boolean; override;
    procedure Struck(hiter: TCreature); override;
    procedure Run; override;
  end;

  // 용몸 ---------------------------------------------------------------------
  TDragonBody = class(TATMonster)
  private
    bofirst: boolean;
  protected
    procedure RangeAttack(targ: TCreature);
    procedure ResetLevel;

  public
    constructor Create;
    procedure RecalcAbilitys; override;
    function AttackTarget: boolean; override;
    procedure Struck(hiter: TCreature); override;
    procedure Run; override;
  end;

  // 용석상 -------------------------------------------------------------------
  TDragonStatue = class(TATMonster)
  private
    bofirst: boolean;
  protected
    procedure RangeAttack(targ: TCreature);
    procedure ResetLevel;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RecalcAbilitys; override;
    function AttackTarget: boolean; override;
    procedure Run; override;
  end;


  TEyeProg = class(TATMonster)
  protected
    procedure RangeAttack(targ: TCreature);
  public
    constructor Create;
    function AttackTarget: boolean; override;
  end;

  TStoneSpider = class(TATMonster)
  protected
    procedure RangeAttack(targ: TCreature);
  public
    constructor Create;
    function AttackTarget: boolean; override;
  end;

  TGhostTiger = class(TMonster)
  private
    LastHideTime: longword;
    LastSitDownTime: longword;
    fSitDown: boolean;
    fHide:    boolean;
    fEnableSitDown: boolean;
  protected
    procedure RangeAttack(targ: TCreature);
  public
    constructor Create;
    function AttackTarget: boolean; override;
    procedure Run; override;
  end;

  TJumaThunder = class(TScultureMonster)
  protected
    procedure RangeAttack(targ: TCreature);
  public
    constructor Create;
    function AttackTarget: boolean; override;
  end;

  //수퍼오마(텔레포트,크리티컬)
  TSuperOma = class(TATMonster)
  private
  protected
  public
    RecentAttackTime: integer;
    TeleInterval:  integer;
    criticalpoint: integer;
    TargetTime:    longword;
    OldTargetCret: TCreature;
    constructor Create;
    function AttackTarget: boolean; override;
    procedure Attack(target: TCreature; dir: byte); override;
  end;

implementation

uses
  svMain, M2Share;

 {---------------------------------------------------------------------------}
 //천녀(월령):  소환수

constructor TAngelMon.Create;
begin
  inherited Create;

  bofirst    := True;
  HideMode   := True;
  RaceServer := RC_ANGEL;
  ViewRange  := 10;

end;

destructor TAngelMon.Destroy;
begin
  inherited Destroy;

end;


procedure TAngelMon.RecalcAbilitys;
begin
  beforeRecalcAbility;
  inherited RecalcAbilitys;
  AfterRecalcAbility;
  //   ResetLevel;   //지원 마법을 쓰면 에너지 차는 버그 수정(20031216)
end;

procedure TAngelMon.BeforeRecalcAbility;
begin
  case SlaveMakeLevel of
    1: begin
      Abil.MaxHP := 200;
      Abil.AC    := MakeWord(4, 5);
      Abil.MC    := MakeWord(11, 20);
    end;
    2: begin
      Abil.MaxHP := 300;
      Abil.AC    := MakeWord(5, 6);
      Abil.MC    := MakeWord(13, 23);
    end;
    3: begin
      Abil.MaxHP := 450;
      Abil.AC    := MakeWord(6, 9);
      Abil.MC    := MakeWord(18, 28);
    end;
    else begin
      Abil.MaxHP := 150;
      Abil.AC    := MakeWord(4, 4);
      Abil.MC    := MakeWord(10, 18);
    end;

  end;

  Abil.MAC   := MakeWord(4, 4);
  AddAbil.HP := 0;
end;

procedure TAngelMon.AfterRecalcAbility;
begin

  NextHitTime  := 3100 - (SlaveMakeLevel * 300);
  NextWalkTime := 600 - (SlaveMakeLevel * 50);
  WalkTime     := GetCurrentTime + 2000;

end;

procedure TAngelMon.ResetLevel;
begin
  //처음 초기화 되는부분...
  WAbil.HP := WAbil.MaxHP;

end;

procedure TAngelMon.RangeAttackTo(targ: TCreature); //반드시 target <> nil

  function GetPower1(power, trainrate: integer): integer;
  begin
    Result := Round((10 + trainrate * 0.9) * (power / 100));
  end;

  function CalcMagicPower: integer;
  begin
    Result := 8 + Random(20);
  end;

var
  i, pwr, dam: integer;
begin
  if targ = nil then
    exit;

  if IsProperTarget(Targ) then begin

    Self.Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
    SendRefMsg(RM_LIGHTING, self.Dir, CX, CY, integer(targ), '');

    pwr := GetAttackPower(GetPower1(CalcMagicPower, 0) + Lobyte(WAbil.MC),
      shortint(Hibyte(WAbil.MC) - Lobyte(WAbil.MC)) + 1);

    if targ.LifeAttrib = LA_UNDEAD then
      pwr := Round(pwr * 1.5);


    dam := targ.GetMagStruckDamage(self, pwr);

    if dam > 0 then begin
      Targ.StruckDamage(dam, self);
      Targ.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam,
        targ.WAbil.HP, targ.WAbil.MaxHP, longint(self), '', 800);
    end;

  end;
end;

function TAngelMon.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;

  if (TargetCret <> nil) and (Master <> nil) and (TargetCret <> Master) then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;

      if (abs(CX - TargetCret.CX) <= ViewRange) and
        (abs(CY - TargetCret.CY) <= ViewRange) and (not TargetCret.death) then begin
        RangeAttackTo(TargetCret);
        Result := True;
      end;
    end;
  end;

  //   LoseTarget;
  BoLoseTargetMoment := True;  //sonmg

end;

procedure TAngelMon.Run;
var
  i: integer;
begin
  try

    if bofirst then begin
      bofirst  := False;
      Dir      := 5;
      HideMode := False;
      SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
      RecalcAbilitys;
      ResetLevel;
    end;

    inherited Run;

  except
    MainOutMessage('EXCEPTION TANGEL');
  end;

end;


 {---------------------------------------------------------------------------}
 //분신:  소환수


constructor TCloneMon.Create;
begin
  inherited Create;
  bofirst    := True;
  HideMode   := False;
  RaceServer := RC_CLONE;
  ViewRange  := 10;
end;

destructor TCloneMon.Destroy;
begin
  inherited Destroy;
end;

procedure TCloneMon.RecalcAbilitys;
begin
  BeforeRecalcAbility;
  inherited RecalcAbilitys;
  AfterRecalcAbility;
end;

procedure TCloneMon.BeforeRecalcAbility;
begin
  case SlaveMakeLevel of
    1: begin
      Abil.MC := MakeWord(10, 22);
    end;
    2: begin
      Abil.MC := MakeWord(13, 25);
    end;
    3: begin
      Abil.MC := MakeWord(15, 30);
    end;
    else begin
      Abil.MC := MakeWord(9, 20);
    end;
  end;

  AddAbil.HP := 0;
end;

procedure TCloneMon.AfterRecalcAbility;
begin
  NextHitTime  := 3300 - (SlaveMakeLevel * 300);
  NextWalkTime := 500;
  WalkTime     := GetCurrentTime + 2000;
  NextMPSpendTime := GetTickCount;
  //   MPSpendTickTime := 600;
  MPSpendTickTime := 600 * 30;

  if Master <> nil then begin
    WAbil.MaxHP := Master.WAbil.MaxHP;
    WAbil.HP    := Master.WAbil.HP;
    WAbil.AC    := MakeWord(LOBYTE(master.Abil.AC) * 2 div 3,
      HIBYTE(master.Abil.AC) * 2 div 3);
    WAbil.MAC   := MakeWord(LOBYTE(master.Abil.MAC) * 2 div 3,
      HIBYTE(master.Abil.MAC) * 2 div 3);
    //      MPSpendTickTime := ( 600 - _MIN(400, Master.WAbil.Level * 10) );
  end;
end;

procedure TCloneMon.ResetLevel;
begin
  //처음만초기화되는부분...
end;

procedure TCloneMon.RangeAttackTo(targ: TCreature); //반드시 target <> nil

  function GetPower1(power, trainrate: integer): integer;
  begin
    Result := Round((10 + trainrate * 0.9) * (power / 100));
  end;

  function CalcMagicPow: integer;
  begin
    Result := 8 + random(20);
  end;

var
  i, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;
begin
  if targ = nil then
    exit;

  if IsProperTarget(targ) then begin
    if targ.AntiMagic <= Random(50) then begin
      pwr := GetAttackPower(GetPower1(CalcMagicPow, 0) + Lobyte(WAbil.MC),
        shortint(Hibyte(WAbil.MC) - Lobyte(WAbil.MC)) + 1);

      if targ.LifeAttrib = LA_UNDEAD then
        pwr := Round(pwr * 1.5);

      SendDelayMsg(self, RM_DELAYMAGIC, pwr, MakeLong(Targ.CX, Targ.CY),
        2, integer(targ), '', 600);
      SendRefMsg(RM_MAGICFIRE, 0, MakeWord(7, 9), MakeLong(Targ.CX, Targ.CY),
        integer(targ), '');

    end;

  end;

end;

function TCloneMon.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;

  if (TargetCret <> nil) and (Master <> nil) and (TargetCret <> Master) then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;

      if (abs(CX - TargetCret.CX) <= ViewRange) and
        (abs(CY - TargetCret.CY) <= ViewRange) and (not TargetCret.death) then begin
        if IsProperTarget(TargetCret) then begin
          //마법 준비동작을 먼저 보냄
          SendRefMsg(RM_SPELL, 9, TargetCret.CX, TargetCret.CY, 11, '');
          // 강격이미지
          RangeAttackTo(TargetCret);
          Result := True;
        end;
      end;

    end;
  end;

  //   LoseTarget;
  BoLoseTargetMoment := True;  //sonmg

end;

procedure TCloneMon.Run;
var
  i: integer;
  plus, finalplus: integer;
begin
  plus := 0;
  try
    if bofirst then begin
      bofirst  := False;
      Dir      := 5;
      HideMode := False;
      SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
      RecalcAbilitys;
      ResetLevel;
    end;

    if Death then begin  //분신은 시체가 없다.
      if GetTickCount - DeathTime > 1500 then begin
        MakeGhost(8);
      end;
    end else begin

      if (not BoDisapear) and (not BoGhost) and (self.WAbil.HP > 0) and
        (Master <> nil) and (not Master.BoGhost) and (not Master.death) then begin

        // 마력이 회복되지 않게 한다.(sonmg 2005/02/15)
        Master.SpellTick := 0;
        // 분신에게 주인의 체력을 보강해준다.(sonmg 2005/03/09)
        Self.WAbil.HP    := Master.WAbil.HP;

        if Master.WAbil.MP < 200 then begin
          // MP 가 200 보다 작으면 자동사라짐
          Master.SysMsg('Your clone is destroyed due to lack of MP.', 0);
          Self.BoDisapear := True;
          self.WAbil.HP   := 0;
        end;

        if (GetTickCount >= NextMPSpendTime + MPSpendTickTime) then begin
          NextMPSpendTime := GetTickCount;

          if Master.wabil.MP >= 200{170} then begin
            //                  Self.WAbil.HP := Master.WAbil.HP;
            //                  Master.WAbil.MP := Master.WAbil.MP - ( 1 + SlaveMakeLevel div 2 );
            //----------------------------------------------------------
            // 분신이 소환되었을 경우 마력 차는 공식 별도 적용
            // 캐릭의 마력 공식이 변경되면 이 부분도 변경되어야 함.
            plus      := Master.WAbil.MaxMP div 18 + 1;
            finalplus := -((1 + SlaveMakeLevel div 2) * 64) +
              plus + ((plus * Master.SpellRecover) div 10);
            // 더해지는 값이 양수인지 음수인지에 따라 구분
            if finalplus >= 0 then begin
              if Master.WAbil.MP + finalplus > Master.WAbil.MaxMP then
                Master.WAbil.MP := Master.WAbil.MaxMP
              else
                Master.WAbil.MP := Master.WAbil.MP + finalplus;
            end else begin
              if Master.WAbil.MP < -finalplus then
                Master.WAbil.MP := 0
              else
                Master.WAbil.MP := Master.WAbil.MP + finalplus;
            end;
            //----------------------------------------------------------
{
               end else begin
                  // MP 가 200 보다 작으면 자동사라짐
                  Master.SysMsg('Your clone is destroyed due to lack of MP.',0);
                  Self.BoDisapear := true;
                  self.WAbil.HP := 0;
}
          end;

          // 분신에서 수동으로 마력을 Refresh 시켜준다.(sonmg 2005/02/15)
          Master.HealthSpellChanged;

        end;

      end else begin
        Self.WAbil.HP := 0;
      end;

    end;

    inherited Run;
  except
    MainOutMessage('EXCEPT TCLONE');
  end;

end;

//==============================================================================
constructor TDragon.Create;
var
  pdefm: PTDefMagic;

begin
  inherited Create;
  bofirst    := True;
  HideMode   := True;
  RaceServer := RC_FIREDRAGON;
  ViewRange  := 12;
  BoWalkWaitMode := True;
  BoDontMove := True;

  ChildList := TList.Create;
end;

destructor TDragon.Destroy;
var
  mon: TCreature;
  i:   integer;
begin
  if ChildList <> nil then begin
    for i := ChildList.Count - 1 downto 0 do begin
      mon := TCreature(ChildList[0]);
      mon.Wabil.HP := 0;
      ChildList.Delete(0);
    end;
    ChildList.Free;
  end;

  inherited Destroy;
end;


procedure TDragon.RecalcAbilitys;
begin
  inherited RecalcAbilitys;
  ResetLevel;
end;

procedure TDragon.ResetLevel;
const
  bodypos: array[0..41, 0..1] of integer = (
    (0, -5), (1, -5),
    (-1, -4), (0, -4), (1, -4), (2, -4),
    (-2, -3), (-1, -3), (0, -3), (1, -3), (2, -3),
    (-3, -2), (-2, -2), (-1, -3), (0, -2), (1, -2), (2, -2),
    (-3, -1), (-2, -1), (-1, -1), (0, -1), (1, -1), (2, -1),
    (-3, 0), (-2, 0), (-1, 0), (0, 0), (1, 0), (2, 0), (3, 0),
    (-2, 1), (-1, 1), (0, 1), (1, 1), (2, 1), (3, 1),
    (-1, 2), (0, 2), (1, 2), (2, 2),
    (0, 3), (1, 3));

var
  mon:  TCreature;
  i, j: integer;
begin

  if pEnvir <> nil then begin

    for  i := 0 to 41 do begin
      if (bodypos[i][0] <> 0) or (bodypos[i][1] <> 0) then begin
        // 파천마룡몸이 00
        mon := UserEngine.AddCreatureSysop(pEnvir.MapName, CX +
          bodypos[i][0], CY + bodypos[i][1], '00');
        if mon <> nil then begin
          childlist.Add(mon);
        end;
      end; //if  i <> cx
    end; // for i

  end;

end;

procedure TDragon.RangeAttack(targ: TCreature); //반드시 target <> nil

  function MPow(pum: PTUserMagic): integer;
  begin
    Result := pum.pDef.MinPower + Random(pum.pDef.MaxPower - pum.pDef.MinPower);
  end;

var
  i, pwr, dam: integer;
  sx, sy, tx, ty, TempDir: integer;
  ix, iy, ixf, iyf, ixt, iyt: integer;
  cret: TCreature;
  list: TList;
begin
  if targ = nil then
    exit;

  TempDir := GetNextDirection(CX, CY, targ.CX, targ.CY);

  case TempDir of
    0, 1, 6, 7: SendRefMsg(RM_DRAGON_FIRE3, TempDir, CX, CY, integer(targ), '');
    5: SendRefMsg(RM_DRAGON_FIRE2, TempDir, CX, CY, integer(targ), '');
    2, 3, 4: SendRefMsg(RM_DRAGON_FIRE1, TempDir, CX, CY, integer(targ), '');
  end;

  with WAbil do begin
    pwr := random(Hibyte(Wabil.DC)) + LoByte(Wabil.DC) + random(Lobyte(WAbil.MC));
    pwr := pwr * (random(2) + 1);
  end;

  if targ.LifeAttrib = LA_UNDEAD then
    pwr := Round(pwr * 1.5);



  ixf := _MAX(0, Targ.CX - 2);
  ixt := _MIN(pEnvir.MapWidth - 1, Targ.CX + 2);
  iyf := _MAX(0, Targ.CY - 2);
  iyt := _MIN(pEnvir.MapHeight - 1, Targ.CY + 2);

  for ix := ixf to ixt do begin
    for iy := iyf to iyt do begin
      list := TList.Create;
      PEnvir.GetAllCreature(ix, iy, True, list);
      for i := 0 to list.Count - 1 do begin
        cret := TCreature(list[i]);
        if IsProperTarget(cret) then begin
          dam := cret.GetMagStruckDamage(self, pwr);

          if cret.LifeAttrib = LA_UNDEAD then
            pwr := Round(pwr * 1.5);

          if dam > 0 then begin
            cret.StruckDamage(dam, self);
            cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
              cret.WAbil.HP{lparam1},
              cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '',
              600 + _MAX(Abs(CX - cret.CX), Abs(CY - cret.CY)) * 70);
          end;
        end;
      end;
      list.Free;
    end;
  end;

end;

procedure TDragon.AttackAll(Targ: TCreature); //반드시 target <> nil

  function MPow(pum: PTUserMagic): integer;
  begin
    Result := pum.pDef.MinPower + Random(pum.pDef.MaxPower - pum.pDef.MinPower);
  end;

var
  ix, iy, ixf, ixt, iyf, iyt, dam, pwr, i: integer;
  list: TList;
  cret: TCreature;
begin
  if targ = nil then
    exit;

  SendRefMsg(RM_LIGHTING, Self.Dir, CX, CY, integer(self), '');
  with WAbil do begin
    pwr := random(Hibyte(Wabil.DC)) + LoByte(Wabil.DC) + random(Lobyte(WAbil.MC));
    pwr := pwr * (random(5) + 1);

  end;

  ixf := _MAX(0, targ.CX - 10);
  ixt := _MIN(pEnvir.MapWidth - 1, targ.CX + 10);
  iyf := _MAX(0, targ.CY - 10);
  iyt := _MIN(pEnvir.MapHeight - 1, targ.CY + 10);

  for ix := ixf to ixt do begin
    for iy := iyf to iyt do begin
      list := TList.Create;
      PEnvir.GetAllCreature(ix, iy, True, list);
      for i := 0 to list.Count - 1 do begin
        cret := TCreature(list[i]);
        if IsProperTarget(cret) then begin
          dam := cret.GetMagStruckDamage(self, pwr);

          if cret.LifeAttrib = LA_UNDEAD then
            pwr := Round(pwr * 1.5);

          if dam > 0 then begin
            cret.StruckDamage(dam, self);
            cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
              cret.WAbil.HP{lparam1},
              cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '',
              600);
          end;
        end;
      end;
      list.Free;
    end;
  end;

end;

function TDragon.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if (TargetCret <> nil) and (TargetCret <> Master) then begin

    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;

      if (abs(CX - TargetCret.CX) <= ViewRange) and
        (abs(CY - TargetCret.CY) <= ViewRange) and (not TargetCret.death) and
        (not TargetCret.boghost) then begin
        if Random(5) = 0 then
          AttackAll(TargetCret)   //모두공격
        else
          RangeAttack(TargetCret);
        Result := True;
      end;

      LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
    end;

  end;
end;

procedure TDragon.Struck(hiter: TCreature);
begin
  inherited;
  if hiter <> nil then begin
    // 파천마룡은 범위가 8 이하일경우에만 경험치를 증가시킨다.
    // 멀리서 얍삽하게 공격하는 술사 방지
    if (ABS(hiter.CX - CX) <= 8) and (ABS(hiter.CY - CY) <= 8) then begin
      SendMsg(self, RM_DRAGON_EXP, 0, Random(3) + 1, 0, 0, '');
    end;
  end;
end;

procedure TDragon.Run;
var
  i: integer;
begin
  if bofirst then begin
    bofirst  := False;
    Dir      := 5;
    HideMode := False;
    SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
    ResetLevel;
  end;
  inherited Run;
end;

//==============================================================================
constructor TDragonBody.Create;
begin
  inherited Create;
  bofirst    := True;
  HideMode   := True;
  RaceServer := RC_DRAGONBODY;
  ViewRange  := 0;
  BoWalkWaitMode := True;
  BoDontMove := True;

end;



procedure TDragonBody.RecalcAbilitys;
begin
  inherited RecalcAbilitys;
  ResetLevel;
end;

procedure TDragonBody.ResetLevel;
begin
end;

function TDragonBody.AttackTarget: boolean;
begin
  Result := False;
end;

procedure TDragonBody.RangeAttack(targ: TCreature);
begin
end;

procedure TDragonBody.Struck(hiter: TCreature);
begin
  if hiter <> nil then begin
    // 파천마룡의 몸은 범위가 8 이하일경우에만 경험치를 증가시킨다.
    // 멀리서 얍삽하게 공격하는 술사 방지
    if (ABS(hiter.CX - CX) <= 8) and (ABS(hiter.CY - CY) <= 8) then begin
      SendMsg(self, RM_DRAGON_EXP, 0, Random(3) + 1, 0, 0, '');
    end;
  end;
  inherited;
end;

procedure TDragonBody.Run;
var
  i: integer;
begin
  if bofirst then begin
    bofirst  := False;
    Dir      := 5;
    HideMode := False;
    SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
    ResetLevel;
  end;
  inherited Run;
end;

//==============================================================================
constructor TDragonStatue.Create;
begin
  inherited Create;
  bofirst    := True;
  HideMode   := True;
  RaceServer := RC_DRAGONSTATUE;
  ViewRange  := 12;
  BoWalkWaitMode := True;
  BoDontMove := True;
end;

destructor TDragonStatue.Destroy;
begin
  inherited Destroy;
end;


procedure TDragonStatue.RecalcAbilitys;
begin
  inherited RecalcAbilitys;
  ResetLevel;
end;

procedure TDragonStatue.ResetLevel;
begin

end;

procedure TDragonStatue.RangeAttack(targ: TCreature); //반드시 target <> nil

  function MPow(pum: PTUserMagic): integer;
  begin
    Result := pum.pDef.MinPower + Random(pum.pDef.MaxPower - pum.pDef.MinPower);
  end;

var
  i, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  ix, iy, ixf, iyf, ixt, iyt: integer;
  cret: TCreature;
  list: TList;

begin
  if targ = nil then
    exit;

  SendRefMsg(RM_LIGHTING, Self.Dir, CX, CY, integer(targ), '');

  with WAbil do begin
    pwr := random(Hibyte(Wabil.DC)) + LoByte(Wabil.DC) + random(Lobyte(WAbil.MC));
  end;


  ixf := _MAX(0, Targ.CX - 2);
  ixt := _MIN(pEnvir.MapWidth - 1, Targ.CX + 2);
  iyf := _MAX(0, Targ.CY - 2);
  iyt := _MIN(pEnvir.MapHeight - 1, Targ.CY + 2);

  for ix := ixf to ixt do begin
    for iy := iyf to iyt do begin
      list := TList.Create;
      PEnvir.GetAllCreature(ix, iy, True, list);
      for i := 0 to list.Count - 1 do begin
        cret := TCreature(list[i]);
        if IsProperTarget(cret) then begin
          dam := cret.GetMagStruckDamage(self, pwr);

          if cret.LifeAttrib = LA_UNDEAD then
            pwr := Round(pwr * 1.5);

          if dam > 0 then begin
            cret.StruckDamage(dam, self);
            cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
              cret.WAbil.HP{lparam1},
              cret.WAbil.MaxHP{lparam2}, longint(self){hiter}, '',
              600 + _MAX(Abs(CX - cret.CX), Abs(CY - cret.CY)) * 50);
          end;
        end;
      end;
      list.Free;
    end;
  end;

end;

function TDragonStatue.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if (TargetCret <> nil) and (TargetCret <> Master) then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;

      if (abs(CX - TargetCret.CX) <= ViewRange) and
        (abs(CY - TargetCret.CY) <= ViewRange) and (not TargetCret.death) and
        (not TargetCret.BoGhost) then begin
        RangeAttack(TargetCret);

        Result := True;
      end;

      LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
    end;
  end;
end;

procedure TDragonStatue.Run;
var
  i: integer;
begin
  if bofirst then begin
    bofirst  := False;
    Dir      := 5;
    HideMode := False;
    SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
    ResetLevel;
  end;
  inherited Run;
end;

//==============================================================================
constructor TEyeProg.Create;
begin
  inherited Create;
  SearchRate := 1500 + longword(Random(1500));
  ViewRange  := 11;
end;

procedure TEyeProg.RangeAttack(targ: TCreature);
var
  levelgap, rush, rushdir, rushDist: integer;
begin
  // 멀리있는 적을 끌어당긴다.
  Self.Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
  SendRefMsg(RM_LIGHTING, self.Dir, CX, CY, integer(targ), '');

  rushDir  := ((Self.Dir + 4) mod 8);
  rushDist := _MIN(abs(CX - targ.CX), abs(CY - targ.CY));

  if IsProperTarget(targ) then begin
    if (not targ.Death) and ((targ.RaceServer = RC_USERHUMAN) or (targ.Master <> nil))
    then begin
      levelgap := (targ.AntiMagic * 5) + HIBYTE(targ.Wabil.AC) div 2;
      if (Random(40) > levelgap) then begin
        // 직선에 있는넘만 땡긴다.
        if (CX = targ.CX) or (CY = targ.CY) or
          (abs(CX - targ.CX) = abs(CY - targ.CY)) then begin
          rush := RushDist;
          targ.CharRushRush(RushDir, rush, False);
        end;

        targ.MakePoison(POISON_DECHEALTH, 30, random(10) + 5);
      end;
    end;
  end;

end;

function TEyeProg.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;

  // 근접해 일을때에는 근접 힘 공격을
  // 원거리 일때는 원거리 마법공격을 한다.
  if TargetCret <> nil then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;

      if (abs(CX - TargetCret.CX) <= 5) and (abs(CY - TargetCret.CY) <= 5) then begin
        if (TargetInAttackRange(TargetCret, targdir)) then begin
          TargetFocusTime := GetTickCount;
          Attack(TargetCret, targdir);
          Result := True;
        end else begin
          if Random(2) = 0 then begin
            RangeAttack(TargetCret);
            Result := True;
          end else
            Result := inherited AttackTarget;
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

//==============================================================================
constructor TStoneSpider.Create;
begin
  inherited Create;
  SearchRate := 1500 + longword(Random(1500));
  ViewRange  := 11;
end;

procedure TStoneSpider.RangeAttack(targ: TCreature);
var

  i, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  cret: TCreature;
  ndir: integer;
begin
  // 뢰인장 쓰자
  Self.Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
  SendRefMsg(RM_LIGHTING, self.Dir, CX, CY, integer(targ), '');

  with WAbil do
    pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

  nDir := self.dir;
  GetNextPosition(PEnvir, Cx, Cy, ndir, 1, sx, sy);
  GetNextPosition(PEnvir, CX, CY, ndir, 8, tx, ty);

  for i := 0 to 12 do begin
    cret := TCreature(PEnvir.GetCreature(sx, sy, True));
    if cret <> nil then begin
      if IsProperTarget(cret) then begin
        if (random(18) > (cret.AntiMagic * 3)) then begin  //마법 회피가 있음
          dam := cret.GetMagStruckDamage(self, pwr);
          cret.SendDelayMsg(self, RM_MAGSTRUCK, 0, dam, 0, 0, '', 600);
        end;
      end;
    end;
    if not ((abs(sx - tx) <= 0) and (abs(sy - ty) <= 0)) then begin
      ndir := GetNextDirection(sx, sy, tx, ty);
      if not GetNextPosition(PEnvir, sx, sy, ndir, 1, sx, sy) then
        break;
    end else
      break;
  end;

end;

function TStoneSpider.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  // 근접해 일을때에는 근접 힘 공격을
  // 원거리 일때는 원거리 마법공격을 한다.

  if TargetCret <> nil then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;

      if (abs(CX - TargetCret.CX) <= ViewRange) and
        (abs(CY - TargetCret.CY) <= ViewRange) then begin
        if (TargetInAttackRange(TargetCret, targdir)) then begin
          TargetFocusTime := GetTickCount;
          Attack(TargetCret, targdir);

          //근접일때 독 걸리게...
          if random(3) = 0 then
            TargetCret.MakePoison(POISON_DECHEALTH, 30, random(10) + 5);

          Result := True;
        end else begin
          if Random(3) = 0 then begin
            RangeAttack(TargetCret);
            Result := True;
          end else begin
            Result := inherited AttackTarget;
          end;

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

//==============================================================================
constructor TGhostTiger.Create;
begin
  inherited Create;
  SearchRate := 1500 + longword(Random(1500));
  LastHideTime := GetTickCount + 10000;
  LastSitDownTime := GetTickCount + 10000;
  fSitDown  := False;
  fHide     := False;
  fEnableSitDown := False;
  ViewRange := 11;
end;

procedure TGhostTiger.RangeAttack(targ: TCreature);
var

  i, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list:     TList;
  cret:     TCreature;
  slowtime: integer;

begin
  // 얼음쏘자
  Self.Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
  SendRefMsg(RM_LIGHTING, self.Dir, CX, CY, integer(targ), '');

  with WAbil do
    pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

  list := TList.Create;
  GetMapCreatures(PEnvir, targ.CX, targ.CY, 1, list);

  for i := 0 to list.Count - 1 do begin
    cret := TCreature(list[i]);
    if IsProperTarget(cret) then begin

      if (random(18) > (cret.AntiMagic * 3)) then begin

        dam := cret.GetMagStruckDamage(self, pwr);

        if (cret <> targ) then
          dam := dam div 2;

        if dam > 0 then begin
          cret.StruckDamage(dam, self);

          slowtime := dam div 10;
          if slowtime > 0 then
            cret.MakePoison(POISON_SLOW, slowtime, 1);

          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1}, cret.WAbil.MaxHP{lparam2},
            longint(self){hiter}, '', 800);
        end;
      end;
    end;
  end;

  list.Free;

end;

function TGhostTiger.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  // 근접해 일을때에는 근접 힘 공격을
  // 원거리 일때는 원거리 마법공격을 한다.

  if TargetCret <> nil then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;

      if (abs(CX - TargetCret.CX) <= ViewRange) and
        (abs(CY - TargetCret.CY) <= ViewRange) then begin
        if (TargetInAttackRange(TargetCret, targdir)) then begin
          TargetFocusTime := GetTickCount;
          Attack(TargetCret, targdir);
          if fSitDown = False then
            LastSitDownTime := GetTickCount + 10000;
          Result := True;
        end else begin
          if Random(3) = 0 then begin
            RangeAttack(TargetCret);
            if fSitDown = False then
              LastSitDownTime := GetTickCount + 10000;
            Result := True;
          end else begin
            Result := inherited AttackTarget;
          end;

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

procedure TGhostTiger.Run;
begin

  if GetTickCount >= LastHideTime then begin
    if fHide then begin

      StatusArr[STATE_TRANSPARENT] := 0;
      LasthideTime := GetTickCount + longword(random(3000)) + 9000;
      fHide := False;
    end else begin
      if (not BoGhost) and (not death) then begin

        StatusArr[STATE_TRANSPARENT] := 60000;
        LasthideTime := GetTickCount + longword(random(3000)) + 9000;
        fHide := True;

      end;
    end;

    CharStatus := GetCharStatus;
    CharStatusChanged;
  end;

  fenableSitDown := False;
  if master <> nil then begin
    if Master.BoSlaveRelax then
      fenableSitDown := True;

    if not RunDone and IsMoveAble then begin
      if (GetTickCount - SearchEnemyTime > 8000) or
        ((GetTickCount - SearchEnemyTime > 1000) and (TargetCret = nil)) then begin
        SearchEnemyTime := GetTickCount;
        MonsterNormalAttack;
      end;
    end;

  end else begin
    if TargetX = -1 then
      fenableSitDown := True;
  end;

  if (BoGhost) or (death) then
    fenableSitDown := False;

  if (fenableSitDown or fSitDown) and (LastSitDownTime < GetTickCount) then begin
    if fSitDown then  // 앉아있다.
    begin
      SendRefMsg(RM_TURN, Dir, CX, CY, 0, '');
      LastSitDownTime := GetTickCount + longword(random(5000)) + 15000;
      fSitDown   := False;
      BoDontMove := False;
    end else    // 서있다.
    begin
      SendRefMsg(RM_DIGDOWN, Dir, CX, CY, 0, '');
      LastSitDownTime := GetTickCount + longword(random(3000)) + 9000;
      fSitDown   := True;
      BoDontMove := True;
    end;
  end;

  inherited run;
end;


//==============================================================================
constructor TJumaThunder.Create;
begin
  inherited Create;
  ViewRange := 11;
  MeltArea  := 5;
end;

procedure TJumaThunder.RangeAttack(targ: TCreature);
var

  i, pwr, dam: integer;
  sx, sy, tx, ty: integer;
  list: TList;
  cret: TCreature;

begin
  // 붉은 강격을 날린다.
  Self.Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
  SendRefMsg(RM_LIGHTING, self.Dir, CX, CY, integer(targ), '');

  with WAbil do
    pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

  list := TList.Create;
  GetMapCreatures(PEnvir, targ.CX, targ.CY, 1, list);

  for i := 0 to list.Count - 1 do begin
    cret := TCreature(list[i]);
    if IsProperTarget(cret) then begin

      if (random(18) > (cret.AntiMagic * 3)) then begin

        dam := cret.GetMagStruckDamage(self, pwr);

        if (cret <> targ) then
          dam := dam div 2;

        if dam > 0 then begin
          cret.StruckDamage(dam, self);
          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1}, cret.WAbil.MaxHP{lparam2},
            longint(self){hiter}, '', 800);
        end;
      end;
    end;
  end;

  list.Free;

end;

function TJumaThunder.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  // 근접해 일을때에는 근접 힘 공격을
  // 원거리 일때는 원거리 마법공격을 한다.

  if TargetCret <> nil then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;

      if (abs(CX - TargetCret.CX) <= ViewRange) and
        (abs(CY - TargetCret.CY) <= ViewRange) then begin
        if (TargetInAttackRange(TargetCret, targdir)) then begin
          TargetFocusTime := GetTickCount;
          Attack(TargetCret, targdir);
          Result := True;
        end else begin
          if Random(3) = 0 then begin
            RangeAttack(TargetCret);
            Result := True;
          end else begin
            Result := inherited AttackTarget;
          end;

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


 //==============================================================================
 //수퍼오마
constructor TSuperOma.Create;
begin
  RecentAttackTime := GetTickCount;
  TeleInterval  := 10;  //sec
  criticalpoint := 0;
  TargetTime    := GetTickCount;
  OldTargetCret := nil;
  inherited Create;
end;

function TSuperOma.AttackTarget: boolean;
var
  targdir: byte;
  nx, ny:  integer;
begin
  Result := False;

  if (GetCurrentTime < longint(longword(Random(3000) + 4000) + TargetTime)) then begin
    if OldTargetCret <> nil then
      TargetCret := OldTargetCret;
  end;

  if TargetCret <> nil then begin
    OldTargetCret := TargetCret;
    if TargetInAttackRange(TargetCret, targdir) then begin
      if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
        HitTime := GetCurrentTime;
        TargetFocusTime := GetTickCount;
        RecentAttackTime := GetTickCount;
        Attack(TargetCret, targdir);
        BreakHolySeize;
      end;
      Result := True;
    end else begin
      if GetCurrentTime - RecentAttackTime > (TeleInterval + Random(5)) * 1000 then
      begin
        if Random(2) = 0 then begin
          //타겟의 앞으로
          GetFrontPosition(TargetCret, nx, ny);
          //텔레포트
          SpaceMove(PEnvir.MapName, nx, ny, 0);
          RecentAttackTime := GetTickCount;
        end;
      end else begin
        if TargetCret.MapName = self.MapName then
          SetTargetXY(TargetCret.CX, TargetCret.CY)
        else
          LoseTarget;  //<!!주의> TargetCret := nil로 바뀜
      end;
    end;
  end;
end;

procedure TSuperOma.Attack(target: TCreature; dir: byte);
var
  pwr: integer;
begin
  with WAbil do
    pwr := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));
  Inc(criticalpoint);

  if (criticalpoint > 3) or (Random(20) = 0) then begin
    criticalpoint := 0;
    pwr := Round(pwr * 3);
    {inherited} HitHitEx2(target, RM_LIGHTING, 0, pwr, True);
  end else
    {inherited} HitHit2(target, 0, pwr, True);
end;

end.
