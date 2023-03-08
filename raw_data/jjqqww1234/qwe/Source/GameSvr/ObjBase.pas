{
   2003/01/14 Mine2 추가
   2003/01/15 세트 아이템 추가...세륜셋, 녹취셋, 도부셋
   2003/01/22 NPC 체크 시간 5분에서 10분으로 변경
   2003/02/11 서버 옵티마이즈, 신규 몹 추가, 오륜셋, 초혼셋 기능 추가
   2003/03/04 서버 옵티마이즈
   2003/03/15 아이템 인벤토리 확장
   2003/04/01 아이템 내구 조정
}
unit ObjBase;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  ScktComp, syncobjs, MudUtil, HUtil32, Grobal2, Envir, EdCode, CmdMgr,
  MaketSystem, Relationship;

const
  HEALTHFILLTICK: integer = 300; //1500;  //테스트 서버인 경우
  SPELLFILLTICK: integer = 800;  //1000;
  MAXGOLD  = 2000000000;
  BAGGOLD  = 50000000;
  DEFHIT   = 5;
{$IFDEF FOR_ABIL_POINT}
//4/16일부터 적용
   DEFSPEED = 14;
{$ELSE}
  DEFSPEED = 15;
{$ENDIF}
  // 2004/04/22 체험판 레벨 조정
  EXPERIENCELEVEL = 20;   //7

  GET_A_CMD     = 6001001;
  GET_SA_CMD    = 6001010;
  GET_A_PASSWD  = 31490000;
  GET_SA_PASSWD = 31490001;
  CHG_ECHO_PASSWD = 31490100;
  GET_INFO_PASSWD = 31490200;
  KIL_SERVER_PASSWD = 231493149;

  TAIWANEVENTITEM = 51;  //죽거나 접속끊으면 떨굼. 거래, 교환, 버리기, 맡기기 못함..

  DEFHP      = 14;
  DEFMP      = 11;
  DEF_STARTX = 334;
  DEF_STARTY = 266;
  BADMANHOMEMAP = '3';
  BADMANSTARTX = 845;
  BADMANSTARTY = 674;
  MAXSAVELIMIT = 80; // 80 개로 변경 // 40개만 맡길 수 있다.
  MAXDEALITEM = 10;  //12;  //수정 sonmg(2004/12/24)
  MAXSLAVE   = 1;
  BODYLUCKUNIT = 5000;
  GROUPMAX   = 11;
  ANTI_MUKJA_DELAY = 2 * 60 * 1000;

  MAXGUILDMEMBER = 400;
  MINAGITMEMBER  = 20;

  //밝기
  BRIGHT_DAY   = 0;
  BRIGHT_NIGHT = 1;
  BRIGHT_DAWN  = 2;

  RING_TRANSPARENT_ITEM = 111;
  RING_SPACEMOVE_ITEM   = 112;
  RING_MAKESTONE_ITEM   = 113;
  RING_REVIVAL_ITEM     = 114;
  RING_FIREBALL_ITEM    = 115;
  RING_HEALING_ITEM     = 116;
  RING_ANGERENERGY_ITEM = 117;
  RING_MAGICSHIELD_ITEM = 118;
  RING_SUPERSTRENGTH_ITEM = 119;
  NECTLACE_FASTTRAINING_ITEM = 120;
  NECTLACE_SEARCH_ITEM  = 121;

  RING_CHUN_ITEM   = 122;
  NECKLACE_GI_ITEM = 123;
  ARMRING_HAP_ITEM = 124;
  HELMET_IL_ITEM   = 125;

  RING_OF_UNKNOWN     = 130;
  BRACELET_OF_UNKNOWN = 131;
  HELMET_OF_UNKNOWN   = 132;

  RING_OF_MANATOHEALTH     = 133;          //마력을 체력으로 전환
  BRACELET_OF_MANATOHEALTH = 134;
  NECKLACE_OF_MANATOHEALTH = 135;

  RING_OF_SUCKHEALTH     = 136;            //체력 흡수 아이템
  BRACELET_OF_SUCKHEALTH = 137;
  NECKLACE_OF_SUCKHEALTH = 138;

  // 2003/01/15 세트 아이템 추가...세륜셋, 녹취셋, 도부셋
  RING_OF_HPUP  = 140;            // HP, MP, HP/MP 상승 셋트 아이템
  BRACELET_OF_HPUP = 141;
  RING_OF_MPUP  = 142;
  BRACELET_OF_MPUP = 143;
  RING_OF_HPMPUP = 144;
  BRACELET_OF_HPMPUP = 145;
  // 2003/02/11 세트 아이템 추가...오현셋, 초혼셋
  NECKLACE_OF_HPPUP = 146;
  BRACELET_OF_HPPUP = 147;
  RING_OH_HPPUP = 148;
  CCHO_WEAPON   = 23;
  CCHO_NECKLACE = 149;
  CCHO_RING     = 150;
  CCHO_HELMET   = 151;
  CCHO_BRACELET = 152;
  // 2003/03/04 세트 아이템 추가...파쇄셋, 환마석셋, 영령옥셋
  PSET_NECKLACE_SHAPE = 153;
  PSET_BRACELET_SHAPE = 154;
  PSET_RING_SHAPE = 155;
  HSET_NECKLACE_SHAPE = 156;
  HSET_BRACELET_SHAPE = 157;
  HSET_RING_SHAPE = 158;
  YSET_NECKLACE_SHAPE = 159;
  YSET_BRACELET_SHAPE = 160;
  YSET_RING_SHAPE = 161;

  // 2003/11/17 제조 전용 세트 아이템 추가(sonmg)
  // 뼈다귀셋,벌레셋,백금셋,연옥셋,홍옥셋,강화백금셋,강화연옥셋,강화홍옥셋.
  // 뼈다귀 세트(Bone)
  BONESET_WEAPON_SHAPE  = 4;
  BONESET_HELMET_SHAPE  = 162;
  BONESET_DRESS_SHAPE   = 2;
  // 벌레 세트(Bug)
  BUGSET_NECKLACE_SHAPE = 163;
  BUGSET_RING_SHAPE     = 164;
  BUGSET_BRACELET_SHAPE = 165;
  // 백금 세트(Platinum)
  PTSET_BELT_SHAPE      = 166;
  PTSET_BOOTS_SHAPE     = 167;
  PTSET_NECKLACE_SHAPE  = 168;
  PTSET_BRACELET_SHAPE  = 169;
  PTSET_RING_SHAPE      = 170;
  // 연옥 세트(Kidney Stone)
  KSSET_BELT_SHAPE      = 176;
  KSSET_BOOTS_SHAPE     = 177;
  KSSET_NECKLACE_SHAPE  = 178;
  KSSET_BRACELET_SHAPE  = 179;
  KSSET_RING_SHAPE      = 180;
  // 홍옥 세트(Ruby)
  RUBYSET_BELT_SHAPE    = 171;
  RUBYSET_BOOTS_SHAPE   = 172;
  RUBYSET_NECKLACE_SHAPE = 173;
  RUBYSET_BRACELET_SHAPE = 174;
  RUBYSET_RING_SHAPE    = 175;
  // 강화백금 세트
  STRONG_PTSET_BELT_SHAPE = 181;
  STRONG_PTSET_BOOTS_SHAPE = 182;
  STRONG_PTSET_NECKLACE_SHAPE = 183;
  STRONG_PTSET_BRACELET_SHAPE = 184;
  STRONG_PTSET_RING_SHAPE = 185;
  // 강화연옥 세트
  STRONG_KSSET_BELT_SHAPE = 191;
  STRONG_KSSET_BOOTS_SHAPE = 192;
  STRONG_KSSET_NECKLACE_SHAPE = 193;
  STRONG_KSSET_BRACELET_SHAPE = 194;
  STRONG_KSSET_RING_SHAPE = 195;
  // 강화홍옥 세트
  STRONG_RUBYSET_BELT_SHAPE = 186;
  STRONG_RUBYSET_BOOTS_SHAPE = 187;
  STRONG_RUBYSET_NECKLACE_SHAPE = 188;
  STRONG_RUBYSET_BRACELET_SHAPE = 189;
  STRONG_RUBYSET_RING_SHAPE = 190;

  //2003-10-01 천의무봉 아이템쉐이프
  DRESS_SHAPE_WING   = 9;
  //2004-06-29 신규갑옷(파황천마의) 셰이프
  DRESS_SHAPE_PBKING = 11;

  //갑옷의 StdMode
  DRESS_STDMODE_MAN   = 10;
  DRESS_STDMODE_WOMAN = 11;

  //2004/01/08 용아이템 아이템 Shape (sonmg)
  // 2004/01/09 용 세트 아이템 추가(sonmg)
  DRAGON_RING_SHAPE     = 198;
  DRAGON_BRACELET_SHAPE = 199;
  DRAGON_NECKLACE_SHAPE = 200;
  DRAGON_DRESS_SHAPE    = 10;
  DRAGON_HELMET_SHAPE   = 201;
  DRAGON_WEAPON_SHAPE   = 37;
  DRAGON_BOOTS_SHAPE    = 203;
  DRAGON_BELT_SHAPE     = 204;

  // 2004/03/05 막대사탕 - 화이트데이 이벤트 추가(sonmg)
  LOLLIPOP_SHAPE      = 1;
  // 2004/08/16 금메달,은메달,동메달 - 아테네 올림픽 이벤트 추가(sonmg)
  GOLDMEDAL_SHAPE     = 2;
  SILVERMEDAL_SHAPE   = 3;
  BRONZEMEDAL_SHAPE   = 4;
  //복조리 (sonmg 2005/02/02)
  SHAPE_OF_LUCKYLADLE = 5;

  //무기의 StdMode(sonmg)
  WEAPON_STDMODE1 = 5;
  WEAPON_STDMODE2 = 6;

  FASTFILL_ITEM     = 1;        //물약의 shape 분류 번호
  FREE_UNKNOWN_ITEM = 2;

  //stdmode = 2 (음식류)
  SHAPE_BUNCH_OF_FLOWERS = 1;    //꽃다발

  //stdmode = 3 (전서류)
  INSTANTABILUP_DRUG = 12;
  INSTANT_EXP_DRUG   = 13;  //먹으면 경험치가 상승한다. (AC * 100 만큼 경험치 참)

  //연인
  SHAPE_COUPLE_ALIVE_STONE = 7; //연인부활석
  SHAPE_ADV_COUPLERING = 205; //고급커플반지
  SHAPE_COUPLERING = 206; //커플반지

  //stdmode = 7, 8
  SHAPE_OF_CORD      = 0;   //노끈 Shape (sonmg)
  SHAPE_OF_INVITATION = 0;   //초대장 Shape (sonmg)
  SHAPE_OF_TELEPORTTAG = 1;  //마패 Shape (sonmg - ResStdItems에 맵이름필드 추가)
  SHAPE_OF_GIFTBOX   = 2;      //선물상자 Shape (sonmg)
  SHAPE_OF_EASTEREGG = 3;      //부활절 달걀 Shape (sonmg)
  //장원꾸미기 stdmode = 9
  STDMODE_OF_DECOITEM = 9;  //상현주머니 StdMode (sonmg)
  SHAPE_OF_DECOITEM  = 1;   //상현주머니 Shape (sonmg)
  NAME_OF_DECOITEM   = 'DreamPouch';
  DEFAULT_DECOITEM_PRICE = 10000;

  //바느질용품, 뼈망치(sonmg) + 노끈(2004/05/03)
  SHAPE_OF_NEEDLE = 20;
  SHAPE_OF_HAMMER = 21;

  SHAPE_AMULET_BUNCH = 111;  //부적묶음

  AM_FIREBALL = 1;
  AM_HEALING  = 2;

  NAME_OF_FIREBALL = 'Fireball';
  NAME_OF_HEALING  = 'Healing';

  //50레벨 지원
  EFFECTIVE_HIGHLEVEL = 50;

  //임시 테스트 코드(sonmg)
  //   MAX_OVERLAPITEM = 100;  // 삭제 요망(Global2에 있음)

  // 카운트 아이템 Overflow 제한값(65000으로 해야함).
  MAX_OVERFLOW = 65000;

  //아이템 인덱스 지정
  INDEX_CHOCOLATE = 1;  //초콜렛
  INDEX_CANDY     = 556;      //사탕
  INDEX_LOLLIPOP  = 557;   //막대사탕
  INDEX_MIRBOOTS  = 1;   //천룡신행보

  //연인 해제 위자료(10만전)
  COMPENSATORY_PAYMENT = 100000;
  //일방적인 연인 해제 위자료(30만전)
  COMPENSATORY_PAYMENT_ONEWAY = 300000;

  NONPKLEVEL = 10;  //PK 불가 레벨(10이하)

type
  // 없그레이드 확률 구조체
  TUpgradeProb = record
    iValue: array [0..5] of integer;
    iBase:  integer;
  end;

  TSlaveInfo = record
    SlaveName: string[20];   //Monster name length
    SlaveExp: integer;
    SlaveExpLevel: byte;
    SlaveMakeLevel: byte;
    RemainRoyalty: integer;  //초단위
    HP: integer;
    MP: integer;
  end;
  PTSlaveInfo = ^TSlaveInfo;

  TPkHiterInfo = record  //정당방위
    hiter:   TObject;
    hittime: longword;
  end;
  PTPkHiterInfo = ^TPkHiterInfo;

  TCreature = class
    //저장되는 변수
    MapName: string[16];
    UserName: string[20];      //Monster name length
    CX:      integer;
    CY:      integer;
    Dir:     byte;
    Sex:     byte;
    Hair:    byte;
    HairColorR: byte;    //머리색깔이 아님. 각종 Bit Flag로 사용. (sonmg 2005/03/17)
    HairColorG: byte;    //Empty (sonmg 2005/03/17)
    HairColorB: byte;    //Empty (sonmg 2005/03/17)
    Job:     byte;       //0:warrior  1:wizard  2:taoist 3: assassin
    Gold:    integer;    //돈
    Abil:    TAbility;
    CharStatus: integer;
    StatusArr: array[0..STATUSARR_SIZE - 1] of word;  //각 상태의 남은 시간(초)표시
    HomeMap: string[16];
    HomeX:   integer;
    HomeY:   integer;
    NeckName: string[20];
    PlayerKillingPoint: integer;
    AllowGroup: boolean;
    GroupRequester: string;       //그룹 요청자(sonmg)
    GroupRequestTime: longword;   //그룹 요청 받은 시간(sonmg)
    AllowEnterGuild: boolean;     //문파 가입을 허용

    FreeGulityCount: byte;   //면죄해준 횟수
    IncHealth:     integer;  //체력 먹은양
    IncSpell:      integer;  //마약 먹은양
    IncHealing:    integer;
    FightZoneDieCount: integer;  //문파대전 이벤트 맵에서 죽은 횟수, 방을 나가면 초기화
    DBVersion:     integer;
    //DB의 일부 내용을 변경한 버전, 2001-3-21 경치,빨갱이 수치 변경
    BonusApply:    byte;  //Bonuspoint를 적용했는지 여부
    BonusAbil:     TNakedAbility;  //렙업마다 올리는 능력치
    CurBonusAbil:  TNakedAbility;  //(현재 남은 셋팅)
    BonusPoint:    integer;
    HungryState:   longword;
    TestServerResetCount: byte;   //테스트 서버에서 리셋한 횟수
    BodyLuck:      real;          //몹의 행운치
    BodyLuckLevel: integer;       //계산되는 값 (저장 안됨)
    CGHIUseTime:   word;          //초
    BoEnableRecall: boolean;      //천지합일로 소환 되는지 여부
    BoEnableAgitRecall: boolean;  //문파 장원 소환 되는지 여부

    DailyQuestNumber:  word;   //일일 퀘스트 번호
    DailyQuestGetDate: word;   //일일 퀘스트를 받은 날, mon*31 + day

    QuestIndexOpenStates: array[0..MAXQUESTINDEXBYTE - 1] of byte;
    //unit의 오픈 여부 상태
    QuestIndexFinStates: array[0..MAXQUESTINDEXBYTE - 1] of byte;
    //unit의 오픈 여부 상태
    QuestStates: array[0..MAXQUESTBYTE - 1] of byte;

    //저장안되는 변수
    CharStatusEx: integer;
    FightExp:  integer;    //싸워서 얻은 경험치
    WAbil:     TAbility;   //레벨,경험치는 Abil, 나머지는WAbil
    AddAbil:   TAddAbility;
    ViewRange: integer;
    StatusValue: array[0..STATUSARR_SIZE - 1] of byte;
    //상태의 능력치 추가(sonmg 2005/06/03)
    StatusTimes: array[0..STATUSARR_SIZE - 1] of longword;  //상태의 시간 체크
    ExtraAbil: array[0..EXTRAABIL_SIZE - 1] of byte;  //상승 능력치 값
    ExtraAbilFlag: array[0..EXTRAABIL_SIZE - 1] of byte; //플래그(Byte)
    ExtraAbilTimes: array[0..EXTRAABIL_SIZE - 1] of longword;
    //일정시간동안, 파괴,마력,도력,공속,체력,마력 상승

    Appearance:    word;   //몬스터에 쓰임
    RaceServer:    byte;
    RaceImage:     byte;
    AccuracyPoint: byte;      //명중력, 무공에 의해서 계산된다.
    HitPowerPlus:  byte;      //전사의 무공의 파워가 업됨.. (1/3으로 고정)
    HitDouble:     byte;      //10 = +100% 25는 +250%
    CGHIstart:     longword;  //0
    BoCGHIEnable:  boolean;
    BoOldVersionUser_Italy: boolean;  //이탈리아 이전 버젼 보정
    BoReadyAdminPassword: boolean;
    BoReadySuperAdminPassword: boolean;

    HealthRecover: byte;  //체력회복력
    SpellRecover: byte;   //마력회복력
    AntiPoison: byte;     //독에 안 걸릴 확률.... (특별한 아이템을 착용하면 됨)
    PoisonRecover: byte;  //독에서 회복되는 시간
    AntiMagic: byte;      //마법에 안맞는 회피율
    Luck:      integer;   //행운
    PerHealth: integer;
    PerHealing: integer;
    PerSpell:  integer;
    IncHealthSpellTime: longword;
    RedPoisonLevel: byte;   //빨독에 중독되었을때의 강도(0~256)
    PoisonLevel: byte;      //중독되었을때 독의 강도 (0..3) (0~256)
    AvailableGold: integer; //들 수 있는 돈 (체험판인 경우 1만원 이하임)

    SpeedPoint: byte; //회피력, 무공에 의해서, 무기가 너무 무거우면 떨어진다.
    UserDegree: byte;
    HitSpeed:   shortint; //공격 속도 0:기본 (-)느림 (+)빠름
    LifeAttrib: byte;     //생명 0, 언데드 1,
    CoolEye:    byte;     //은신을 볼 확률 0(못봄) 100(완전히 봄)

    GroupOwner:     TCreature;   //그룹짱
    GroupMembers:   TStringList; //그룹의 맵버들
    BoHearWhisper:  boolean;     //귓속말을 듣기 허용여부
    BoHearCry:      boolean;     //외치기를 듣는지 여부
    BoHearGuildMsg: boolean;     //문파전음 듣는 여부
    BoExchangeAvailable: boolean;
    WhisperBlockList: TStringList;
    LatestCryTime:  longword;  //마지막으로 외치기를 한 시간

    Master:    TCreature;        //주인 (소환수인 경우 사용)
    MasterRoyaltyTime: longword; //주인에 대한 충성을 유지하는 시간
    SlaveLifeTime: longword;     //꼬셔진 시간으로 부터 시간, 일정시간 지나면 죽는다.
    SlaveExp:  integer;
    SlaveExpLevel: byte;    //부하의 레벨, 경험을 쌓으면 레벨이 오른다.
    SlaveMakeLevel: byte;   //소환수의 레벨 3단계
    SlaveList: TList;       //내가 소환한 몹
    BoSlaveRelax: boolean;  //TRUE이면 휴식모드, FALSE이면 공격모드

    HumAttackMode: byte;  //사람, 공격 형태 설정
    DefNameColor: byte;
    Light: integer;  //나의 밝기....  0..5 기본 사람 기본 2
    BoGuildWarArea: boolean;  //현재 문파전,공성전 중이다.

    Castle: TObject;  //소속되어 있는 성(npc인 경우에 사용)
    BoCrimeforCastle: boolean;  //성을 공격한 경우
    CrimeforCastleTime: longword;

    NeverDie:     boolean;      //절대 죽지 않음.. NPC
    HoldPlace:    boolean;      //자리를 점유하고 있는지 여부
    BoFearFire:   boolean;      //불을 무서워하는 속성, 불이 붙어 있으면 전진을 안한다.
    BoAnimal:     boolean;      //동물..(썰면 고기가 나오는 종류?)
    BoNoItem:     boolean;      //true(죽어도 아이템이 안떨어짐)
    HideMode:     boolean;      //생성당시 숨어있는 모드
    StickMode:    boolean;      //움직일 수 없는 몹
    RushMode:     boolean;      //마법에 맞아도 움직인다.
    NoAttackMode: boolean;      //공격당해도 대응을 안함(공격 프로그램이 없음)
    NoMaster:     boolean;      //꼬실 수 없음

    BoSkeleton:   boolean;  //뼈만 남았지 여부
    MeatQuality:  integer;  //고기의 질
    BodyLeathery: integer;  //질긴 정도

    BoHolySeize:     boolean; //마법에 걸려서 이동을 못함. (몬스터에게만 적용)
    HolySeizeStart:  longword;
    HolySeizeTime:   longword;  //지속시간(초)
    BoCrazyMode:     boolean;   //미친상태
    BoGoodCrazyMode: boolean;   //곱게미친상태(유저는 공격하지 않음. 2004/07/13 sonmg)
    CrazyModeStart:  longword;  //시작시간
    CrazyModeTime:   longword;  //지속시간
    BoOpenHealth:    boolean;   //탐기파연으로 체력이 공개됨
    OpenHealthStart: longword;
    OpenHealthTime:  longword;


    BoDuplication: boolean;  //다른 캐릭과 겹쳐진 상태
    DupStartTime:  longword; //겹쳐진 시작 시간

    PEnvir:     TEnvirnoment;
    BoGhost:    boolean;
    GhostTime:  longword;
    Death:      boolean;
    DeathTime:  longword;
    DeathState: byte;   //0 기본,  1: 뼈만 남음.
    StruckTime: longword;
    WantRefMsg: boolean;
    ErrorOnInit: boolean;
    SpaceMoved: boolean;
    BoDealing:  boolean; //거래중인지 여부
    DealItemChangeTime: longword;
    //마지막으로 교환품을 변경한 시간, 거래전 1초이전에 물품 변경이 있었으면 거래 취소
    DealCret:   TCreature; //거래중인 상대방, nil검사해야함.
    MyGuild:    TObject;  //문파....
    GuildRank:  integer;  //문파내에서의 서열 1:문주
    GuildRankName: string;  //문파안에서의 내 직책이름
    LatestNpcCmd: string;  //마지막으로 NPC와 대화한 커맨드
    AttackSkillCount: integer;  //공격 카운드...(예도검법에 사용)
    AttackSkillPointCount: integer; //공격 카운드 중에서 예도검이 나갈 번째

    //HasTargetedCount: integer;  //내를 공격목표로 찍은 놈의 수, 10분마다 리셋
    //StoneTargetFocusCount: integer;  //
    BoHasMission:  boolean;    //이벤트용, 미션이 있는지
    Mission_X:     integer;
    Mission_Y:     integer;
    BoHumHideMode: boolean;    //몬스터는 안보이는 모드
    UseBlizzard: boolean;
    PFTime, PFUseTime: integer; //ProtectionField Variables
    RevivalMode: boolean;
    RevivalTarget: TCreature;
    BoStoneMode:   boolean;    //석상으로 굳어 있는 모드(공격안됨,보이기는함)
    BoViewFixedHide: boolean;  //은신을 봄
    BoNextTimeFreeCurseItem: boolean;
    //다음 한번 떨이지지않는 아이템을 떼어 낼수 있다.

    BoFixedHideMode: boolean;
    //한자리에서만 은신 가능 모드 (은신술을 사용했을때, 이동하면 풀림)
    BoSysopMode: boolean;      //운영자 모드
    BoSuperviserMode: boolean; //감시자 모드
    BoEcho: boolean;
    BoTaiwanEventUser: boolean;   //대만식,  이벤트 아이템을 갖고 있는 사람
    TaiwanEventItemName: string;

    BoAbilSpaceMove: boolean;
    BoAbilMakeStone: boolean;   //마비의반지
    BoAbilRevival: boolean;     //재생의반지
    LatestRevivalTime: longword;
    BoAddMagicFireball: boolean;   //화염의반지, 화염장을 사용할 수 있다.
    BoAddMagicHealing: boolean;    //회복의반지, 회복술을 사용할 수 있다.
    BoAbilAngerEnergy: boolean;    //분노의반지
    BoMagicShield: boolean;        //보호의반지
    BoAbilSuperStrength: boolean;  //완력의반지
    BoFastTraining: boolean;       //수련의반지
    BoAbilSearch: boolean;
    BoAbilSeeHealGauge: boolean;   //탐기파연 1단계 이상을 수련한 도사
    BoAbilMagBubbleDefence: boolean;
    MagBubbleDefenceLevel: byte;

    SearchRate:  longword;
    SearchTime:  longword;
    RunTime:     integer; //longword;
    RunNextTick: integer; //longword;   //다음 틱시간
    HealthTick:  integer;
    SpellTick:   integer;

    TargetCret:    TCreature;
    TargetFocusTime: longword;
    LastHiter:     TCreature; //마지막에 공격한사람
    LastHiterRace: integer;   //마지막에 공격한사람 종족(2004/07/16)
    SlaveHiter:    TCreature; // 거느리는 슬레이브를 공격한넘
    LastHitTime:   longword;
    ExpHiter:      TCreature; //경험치를 먹는 사람
    ExpHitTime:    longword;
    LatestSpaceMoveTime: longword;
    LatestSpaceScrollTime: longword;
    LatestSearchWhoTime: longword;
    MapMoveTime:   longword; //맵 이동을 한후 3초간 공격을 안당하게 하기 위해
    BoIllegalAttack: boolean;
    IllegalAttackTime: longword;

    ManaToHealthPoint: integer;
    //이 포인트 만큼 마력을 체력으로 바꿈, (-)이면 체력이 마력으로
    SuckupEnemyHealthRate: integer;  //이 % 만큼 상대의 체력을 빼앗아 옴
    SuckupEnemyHealth: real;  //상대의 체력을 빼앗아 옴
    // 2003/03/04
    RefObjCount: integer;
    // 이 Object을 시야내에 두고 있는 Object의 숫자, 0 이상일때 AI 작동

    poisontime: longword;
    time4hour: longword; //4시간에 한번씩
    time10min: longword; //10분에 한번씩
    time500ms: longword;
    time30sec: longword;
    time10sec: longword;
    time5sec: longword;
    ticksec:  longword;
    FAlreadyDisapper: boolean;
    MasterFeature: longint; // 주인의 모습
    ForceMoveToMaster: boolean;
    BoDontMove: boolean;
    BoDisapear: boolean;
    DontBagItemDrop: boolean;
    DontBagGoldDrop: boolean;
    DontUseItemDrop: boolean;
    // newly added by sonmg.
    Tame:     integer;
    AntiPush: integer;
    AntiUndead: integer;
    SizeRate: integer;
    AntiStop: integer;

    BoLoseTargetMoment: boolean;   //잠시 목표를 잃음(sonmg)

    BoHighLevelEffect: boolean;  //50레벨 효과 표시/숨김(sonmg)
    BoGuildAgitDealTry: boolean; //문파장원 거래시도인지 아닌지(sonmg)
    MeltArea: integer;
    bStealth: boolean;
    //순간 경험치 두 배 지속 시간(2005/12/14)
    InstantExpDoubleTime: longword;
  private
    MsgList:      TList;  {synchronize}
    MsgTargetList: TStringList;                 // 내가 행동을 보내주는 객체들
    VisibleItems: TList;
    VisibleEvents: TList;
    WatchTime:    longword;
    FBoInFreePKArea: boolean;  //지금 있는 곳이 프리 피케이 존이다.

    PKHiterList: TList; //나를 먼저 공격한 놈들 리스트, 사람에만 해당

    procedure SetBoInFreePKArea(flag: boolean);

  protected
    FindPathRate: integer;
    FindpathTime: longword;
    HitTime:      integer;
    WalkTime:     integer;
    SearchEnemyTime: longword;

    AreaStateOrNameChanged: boolean;  //이번에 지역상태와 이름이 바뀌어야 한다.

  public
    VisibleActors: TList;   //다른 스래드에서 사용하면 안된다.
    ItemList:      TList;   //list of  PTUserItem 다른 스레드에서 사용하면 안된다.
    DealList:      TList;   //Deal중인 아이템 리스트 PTUserItem
    DealGold:      integer;
    BoDealSelect:  boolean; //교환 버튼 누름 여부
    MagicList:     TList;  //list of PTUserMagic
    // 2003/03/15 아이템 인벤토리 확장
    UseItems:      array[0..12] of TUserItem;    // 8 -> 12
    SaveItems:     TList; //list of PTUserItem;
    NextWalkTime:  integer;
    WalkStep:      integer;
    WalkCurStep:   integer;
    WalkWaitTime:  integer;
    WalkWaitCurTime: longword;
    BoWalkWaitMode: boolean;
    NextHitTime:   integer;

    PSwordSkill:    PTUserMagic;  //기본으로 쓰는 검법, 마법이 지워질때 조심
    PPowerHitSkill: PTUserMagic;  //가끔(1/3) 힘주어 때리는 검법
    PslashhitSkill: PTUserMagic;  //Slash
    PLongHitSkill:  PTUserMagic;   //어검술
    PWideHitSkill:  PTUserMagic;   //반월검법
    PWideHit2Skill:  PTUserMagic;   //Assassin Skill 2
    PFireHitSkill:  PTUserMagic;   //염화결
    // 2003/03/15 신규무공
    PCrossHitSkill: PTUserMagic;  //광풍참
    PTwinHitSkill:  PTUserMagic;   //쌍룡참
    PStoneHitSkill: PTUserMagic;  //사자후

    BoAllowPowerHit:    boolean; //예도검법
    BoAllowslashhit:    boolean; //Slash
    BoAllowLongHit:     boolean;  //어검술
    BoAllowWideHit:     boolean;  //반월검법
    BoAllowWideHit2:     boolean;  //Assassin Skill 2
    BoAllowFireHit:     boolean;  //염화결
    // 2003/03/15 신규무공
    BoAllowCrossHit:    boolean;  //광풍참
    BoAllowTwinHit:     integer;   //쌍룡참
    BoAllowStoneHit:    boolean;   //사자후
    LatestFireHitTime:  longword;
    LatestTwinHitTime:  longword;
    LatestRushRushTime: longword;
    LatestStoneHitTime: longword;

    constructor Create;
    destructor Destroy; override;
    procedure SendFastMsg(Sender: TCreature; Ident, wparam: word;
      lParam1, lParam2, lParam3: longint; str: string);
    procedure SendMsg(Sender: TCreature; Ident, wparam: word;
      lParam1, lParam2, lParam3: longint; str: string);
    procedure SendDelayMsg(Sender: TCreature; Ident, wparam: word;
      lParam1, lParam2, lParam3: longint; str: string; delay: integer{ms});
    procedure UpdateDelayMsg(Sender: TCreature; Ident, wparam: word;
      lParam1, lParam2, lParam3: longint; str: string; delay: integer{ms});
    procedure UpdateDelayMsgCheckParam1(Sender: TCreature;
      Ident, wparam: word; lParam1, lParam2, lParam3: longint; str: string;
      delay: integer{ms});
    procedure UpdateMsg(Sender: TCreature; Ident, wparam: word;
      lParam1, lParam2, lParam3: longint; str: string);
    function GetMsg(var msg: TMessageInfo): boolean; dynamic;
    function GetMapCreatures(penv: TEnvirnoment; x, y, area: integer;
      rlist: TList): boolean;
    function GetObliqueMapCreatures(penv: TEnvirnoment;
      x, y, area, dir: integer; rlist: TList): boolean;
    procedure SendRefMsg(msg, wparam: word; lParam1, lParam2, lParam3: longint;
      str: string);
    procedure UpdateVisibleGay(cret: TCreature);
    procedure UpdateVisibleItems(xx, yy: word; pmi: PTMapItem);
    procedure UpdateVisibleEvents(xx, yy: integer; mevent: TObject);
    procedure SearchViewRange;
    function Feature: integer;
    function GetRelFeature(who: TCreature): integer;
    //상대방에 따라서 모습이 달라 보일 수 있음
    function GetCharStatus: integer;
    procedure InitValues;
    procedure Initialize; dynamic;
    procedure Finalize; dynamic;
    function GetMasterRace: integer; //주인이 어떤 종족인지 얻는다.
    procedure RunMsg(msg: TMessageInfo); dynamic;
    procedure UseLamp;
    procedure Run; dynamic;
    procedure FeatureChanged;
    procedure CharStatusChanged;
    procedure UserNameChanged;
    function Appear: boolean;
    function Disappear(num: integer): boolean;
    procedure KickException;
    function Walk(msg: integer): boolean;
    function EnterAnotherMap(enterenvir: TEnvirnoment;
      enterx, entery: integer): boolean;
    procedure Turn(dir: byte);
    function RunTo(dir: integer; allowdup: boolean): boolean;
    function WalkTo(dir: integer; allowdup: boolean): boolean;
    procedure Say(saystr: string); dynamic;
    procedure SysMsg(str: string; mode: integer);
    procedure BoxMsg(str: string; mode: integer);
    procedure NilMsg(str: string);
    procedure GroupMsg(str: string);
    procedure MakeGhost(num: integer); //사라짐..
    procedure ScatterBagItems(itemownership: TObject);
    procedure DropEventItems;
    procedure ScatterGolds(itemownership: TObject);
    procedure ApplyMeatQuality;
    function TakeCretBagItems(target: TCreature): boolean;
    procedure DropUseItems(itemownership: TObject; DieFromMob: boolean);
    procedure Die; dynamic;
    procedure Alive; dynamic; //다시 살아나다.
    procedure SetLastHiter(hiter: TCreature);
    procedure AddPkHiter(hiter: TCreature); //나를 먼저 공격한 놈, 사람에만 해당
    procedure CheckTimeOutPkHiterList;
    procedure ClearPkHiterList;
    function IsGoodKilling(target: TCreature): boolean; //정당방위 인지
    procedure SetAllowLongHit(boallow: boolean);
    procedure SetAllowWideHit(boallow: boolean);
    procedure SetAllowWideHit2(boallow: boolean);    //Assassin Skill 2
    function SetAllowFireHit: boolean;
    // 2003/03/15 신규무공
    procedure SetAllowCrossHit(boallow: boolean);
    function SetAllowTwinHit: boolean;
    function GetNextHitTime: longint;
    function GetNextWalkTime: longint;

    procedure IncHealthSpell(hp, mp: integer);
    procedure RandomSpaceMove(mname: string; mtype: integer);
    procedure RandomSpaceMoveInRange(mtype, InRange, OutRange: integer);
    procedure SpaceMove(mname: string; nx, ny, mtype: integer);
    procedure UserSpaceMove(mname, xstr, ystr: string);
    function UseScroll(Shape: integer): boolean;
    function MakeWeaponGoodLock: boolean;
    function RepaireWeaponNormaly: boolean;
    function RepaireWeaponPerfect: boolean;
    function RepairItemNormaly(psSeed: PTStdItem; puSeed: PTUserItem): boolean;
    function UseLotto: boolean;
    procedure MakeHolySeize(htime: integer);
    procedure BreakHolySeize;
    procedure MakeCrazyMode(csec: integer);
    procedure MakeGoodCrazyMode(csec: integer);
    procedure BreakCrazyMode;
    procedure MakeOpenHealth;
    procedure BreakOpenHealth;
    function GetHitStruckDamage(hiter: TCreature; damage: integer): integer;
    //내 방어력을 감안하여 데미지 계산
    function GetMagStruckDamage(hiter: TCreature; damage: integer): integer;
    //내 마항력을 감안하여 데미지 계산
    procedure StruckDamage(damage: integer; hiter: TCreature = nil);
    //맞았을때의 데미지... (칼 또는 마법)
    procedure DamageHealth(damage, minimum: integer);
    procedure DamageSpell(val: integer);
    function CalcGetExp(targlevel, targhp: integer): integer;
    procedure GainExp(exp: longword);
    procedure GainSlaveExp(exp: integer); //부하인경우도 경험치가 쌓임
    procedure ApplySlaveLevelAbilitys;
    procedure WinExp(exp: longword);
    procedure HasLevelUp(prevlevel: integer);
    function IncGold(igold: integer): boolean;
    function DecGold(igold: integer): boolean;
    function CalcBagWeight: integer;
    function CalcWearWeightEx(windex: integer): integer;
    //windex를 제외한 착용아이템의 무게
    procedure RecalcLevelAbilitys;
    //procedure  RecalcLevelAbilitys_old;
    procedure RecalcHitSpeed;
    procedure AddMagicWithItem(magic: integer);
    procedure DelMagicWithItem(magic: integer);
    procedure ItemDamageRevivalRing;
    procedure RecalcAbilitys; dynamic;
    function IsGroupGenderDiffernt(cret: TCreature): boolean;
    procedure ApplyItemParameters(uitem: TUserItem; var aabil: TAddAbility);
    // 2003/03/15 아이템 인벤토리 확장
    procedure ApplyItemParametersEx(uitem: TUserItem; var AWabil: TAbility);
    // 직업에 따른 용 아이템 능력치 차등 적용(2004/01/08 sonmg)
    procedure ApplyItemParametersByJob(uitem: TUserItem; var std: TStdItem);

    function GetMyAbility: TAbility;
    function GetNextLevelExp(lv: integer): longword;
    function MakeWeaponUnlock: boolean; //착용무기를 불운으로 만든다.
    procedure TrainSkill(pum: PTUserMagic; train: integer);
    function GetMyLight: integer;

    procedure ChangeLevel(level: integer);
    function InSafeZone: boolean;
    function InGuildWarSafeZone: boolean;
    function PKLevel: integer;
    procedure ChangeNameColor;
    function MyColor: byte;
    function GetThisCharColor(cret: TCreature): byte;
    function GetGuildRelation(onecret, twocret: TCreature): integer;
    function IsGuildMaster: boolean;
    function IsMyGuildMaster: boolean;      //sonmg(2004/04/08)
    function GetGuildNameHereAgit: string;  //현재 장원의 문파명을 얻어옴.
    function GetGuildMasterNameHereAgit: string;  //현재 장원의 문주명을 얻어옴.
    procedure IncPKPoint(point: integer);
    procedure DecPKPoint(point: integer);
    function GetPKTimeMin: string;
    procedure AddBodyLuck(r: real);
    function GetUserName: string;
    function GetHungryState: integer;
    function GetQuestMark(idx: integer): integer;  //0 or not zero
    procedure SetQuestMark(idx, Value: integer);   // value: 0 or 1
    function GetQuestOpenIndexMark(idx: integer): integer;  //0 or not zero
    procedure SetQuestOpenIndexMark(idx, Value: integer);
    function GetQuestFinIndexMark(idx: integer): integer;  //0 or not zero
    procedure SetQuestFinIndexMark(idx, Value: integer);

    procedure DoDamageWeapon(wdam: integer);
    function GetAttackPower(damage, ranval: integer): integer;
    function _Attack(hitmode: word; targ: TCreature): boolean;
    procedure HitHit(target: TCreature; hitmode, dir: word);
    procedure HitMotion(hitmsg: integer; hitdir: byte; x, y: integer);
    procedure HitHit2(target: TCreature; hitpwr, magpwr: integer; all: boolean);
    procedure HitHitEx2(target: TCreature; rmmsg, hitpwr, magpwr: integer;
      all: boolean);
    procedure CmdCallMakeSlaveMonster(monname, param: string; makelv, explv: byte);
    function CharPushed(ndir, pushcount: integer): integer;
    function CharRushRush(ndir, rushlevel: integer; isHumanSkill: boolean): boolean;
    //무태보
    function CharDrawingRush(ndir, rushlevel: integer;
      isHumanSkill: boolean): boolean;  //끌어당김
    function SiegeCount: integer;       //몇 마리한테 둘러 쌓여져 있는지
    function SiegeLockCount: integer;   //구석에 갖혔는지?
    function MakePoison(poison, sec, poisonlv: integer): boolean;
    procedure ClearPoison(poison: integer);
    function CheckAttackRule2(target: TCreature): boolean; dynamic;
    function _IsProperTarget(target: TCreature): boolean; dynamic;
    function IsProperTarget(target: TCreature): boolean; dynamic;
    function IsProperFriend(target: TCreature): boolean; dynamic;
    procedure SelectTarget(target: TCreature); dynamic;
    procedure LoseTarget; dynamic;
    function GetPurity: integer;

    function TargetInAttackRange(target: TCreature; var targdir: byte): boolean;
    function TargetInSpitRange(target: TCreature; var targdir: byte): boolean;
    function TargetInCrossRange(target: TCreature; var targdir: byte): boolean;
    function GetFrontCret: TCreature;
    function GetBackCret: TCreature;
    function CretInNearXY(tagcret: TCreature; xx, yy: integer): boolean;
    function MakeSlave(sname: string;
      slevel, max_slave, royaltysec: integer): TCreature;

    // 2003/06/12 슬레이브 패치
    procedure ClearAllSlaves;
    procedure KillAllSlaves;
    function ExistAttackSlaves: boolean; //공격중인 소환수가 있는지 검사
    function GetExistSlave(MonName_: string): TCreature;
    function EnableRecallMob(TargetMob: TCreature; SkillLevel: integer): boolean;

    function IsGroupMember(cret: TCreature): boolean;
    function CheckGroupValid: boolean;
    procedure DelGroupMember(who: TCreature);
    procedure EnterGroup(gowner: TCreature);
    procedure LeaveGroup;
    procedure DenyGroup;

    function IsEnoughBag: boolean;
    procedure WeightChanged;
    procedure GoldChanged;
    procedure HealthSpellChanged;
    function IsAddWeightAvailable(addweight: integer): boolean;
    function FindItemName(iname: string): PTUserItem;
    function FindItemNameEx(iname: string;
      var Count, durasum, duratop: integer): PTUserItem;
    function FindItemEventGrade(grade, Count: integer): boolean;
    function FindItemWear(iname: string; var Count: integer): PTUserItem;
    function CanAddItem: boolean;
    function AddItem(pu: PTUserItem): boolean; //실패했을 경우도 유의해야 함.
    function DelItem(svindex: integer; iname: string): boolean;
    function DelItemIndex(bagindex: integer): boolean;
    function DeletePItemAndSend(pcheckitem: PTUserItem): boolean;
    function DeletePItemAndSendWithFlag(pcheckitem: PTUserItem;
      wBreakdown: word): boolean;
    function CanTakeOn(index: integer; ps: PTStdItem): boolean;
    function GetDropPosition(x, y, wide: integer; var dx, dy: integer): boolean;
    function GetRecallPosition(x, y, wide: integer; var dx, dy: integer): boolean;
    function DropItemDown(ui: TUserItem; scatterrange: integer;
      diedrop: boolean; ownership, droper: TObject; IsDropFromBag: integer): boolean;
    function DropGoldDown(goldcount: integer; diedrop: boolean;
      ownership, droper: TObject): boolean;
    function UserDropItem(itmname: string; ItemIndex: integer): boolean;
    function UserDropGold(dropgold: integer): boolean;
    // 카운트 아이템
    function UserDropCountItem(itmname: string; dropidx, dropcnt: integer): boolean;
    function UserCounterItemAdd(StdMode, Looks, Cnt: integer;
      iName: string; bEnforce: boolean; ExceptMakeIndex: integer = -1): boolean;
    function UserCounterDealItemAdd(StdMode, Looks, Cnt: integer;
      iName: string): integer;
    function PickUp: boolean;
    function EatItem(std: TStdItem; pu: PTUserItem): boolean;
    function IsMyMagic(magid: integer): boolean;
    function ReadBook(std: TStdItem): boolean;
    function DoSpell(pum: PTUserMagic; xx, yy: integer; target: TCreature): boolean;
    function GetSpellPoint(pum: PTUserMagic): integer;
    function MagPassThroughMagic(sx, sy, tx, ty, ndir, magpwr: integer;
      undeadattack: boolean): integer;
    function MagCanHitTarget(sx, sy: integer; target: TCreature): boolean;
    function MagDefenceUp(sec, Value: integer): boolean;
    function MagHitSpeedUp(sec, Value: integer): boolean;
    function MagMagDefenceUp(sec, Value: integer): boolean;
    function MagMakeDefenceArea(xx, yy, range, sec: integer;
      BoMag: boolean): integer;
    function MagMakePoisonArea(xx, yy, range, pwr, sec: integer;
      BoMag: boolean): integer;
    function MagMakeCurseArea(xx, yy, range, sec, pwr, skilllevel: integer;
      BoMag: boolean): integer;
    function MagDcUp(sec, pwr: integer): boolean;
    function MagMakePoison(sec, pwr: integer; cret: TCreature): boolean;
    procedure MagCurse(sec, pwrrate: integer);
    function MagBubbleDefenceUp(mlevel, sec: integer): boolean;
    procedure DamageBubbleDefence;
    function CheckMagicLevelup(pum: PTUserMagic): boolean;
    procedure CheckMagicSpecialAbility(pum: PTUserMagic);

    //*dq
    function GetDailyQuest: integer;
    //현재 받고 있는 일일퀘스트 값을 얻어 온다. 지났거나, 없으면 0
    procedure SetDailyQuest(qnumber: integer);  //새로히 일일퀘스트를 설정한다.

    property BoInFreePKArea: boolean Read FBoInFreePKArea Write SetBoInFreePKArea;

    //2003/03/18
    procedure DecRefObjCount;
    function ItemOptionToStr(optiondata: array of byte): string;
    function UpgradeResultToStr(iSum: integer; strOpt: string;
      iBefore, iAfter: integer; fProb: double; iJewelStdMode: integer): string;

    function IsMoveAble: boolean;
    procedure ChangeItemWithLevel(var citem: TClientItem; lv: integer);

    //2004/01/09
    procedure ChangeItemByJob(var citem: TClientItem; lv: integer);

    //2004/05/03(sonmg)
    function CheckUnbindItem(itemname: string): boolean;
    procedure DeleteItemFromBag(psDel: PTStdItem; puDel: PTUserItem);
    //2004/03/17(sonmg)
    function FindItemToBindFromBag(Count: integer; itemname: string;
      var dellist: TStringList): integer;

    // 초대장 아이템 셋팅.
    function GuildAgitInvitationItemSet(pu: PTUserItem): boolean;
    // 초대장 유효기간 체크.
    function GuildAgitInvitationTimeOutCheck(pu: PTUserItem): boolean;

    // 상현주머니 아이템 셋팅.
    function GuildAgitDecoItemSet(pu: PTUserItem; Number: integer): boolean;

    //선물상자
    procedure GetGiftFromBox;
    //부활절 달걀
    procedure GetGiftFromEgg;

    //순간 능력치 상승
    procedure EnhanceExtraAbility(kind, amount: integer; min, sec: DWORD);
  end;

  TAnimal = class(TCreature)
  private
  public
    TargetX:      integer;
    TargetY:      integer;
    BoRunAwayMode: boolean; //달아나는 모드
    RunAwayStart: longword;
    RunAwayTime:  integer;
    constructor Create;
    procedure RunMsg(msg: TMessageInfo); override;
    procedure Run; override;
    function GetNearMonster: TCreature;   //가장 가까운 생물체 얻어오기...
    procedure MonsterNormalAttack;
    procedure MonsterDetecterAttack;
    procedure SetTargetXY(x, y: integer); dynamic;
    procedure GotoTargetXY; dynamic;
    procedure Wondering; dynamic;
    procedure Attack(target: TCreature; dir: byte); dynamic;
    procedure Struck(hiter: TCreature); dynamic;
    procedure CmdCallMakeSlaveMonster(monname, param: string; makelv, explv: byte);
    procedure LoseTarget; override;
  end;

  TUserHuman = class(TAnimal)
  private
    Def: TDefaultMessage;
    SendBuffers: TList;

    LatestSayStr:     string;  //도배 금지
    BombSayCount:     integer;
    BombSayTime:      longword;
    BoShutUpMouse:    boolean;
    ShutUpMouseTime:  longword;
    operatetime:      longword;
    operatetime_30sec: longword;
    operatetime_sec:  longword;
    operatetime_500m: longword;
    boGuildwarsafezone: boolean;

    FirstClientTime: longword;
    FirstServerTime: longword;

    //위탁상점관련 데이터.
    FUserMarket: TMarketItemManager;
    FMarketNpc:  TCreature;
    BoFlagUserMarket: boolean;
    // 위탁 기능을 한꺼번에 여러 번 요청 할 수 없도록 Flag설정(sonmg 2005/01/31)
    FlagReadyToSellCheck: boolean;
    // 위탁 가능한지 체크했을 때 Flag설정(sonmg 2005/08/10)

    function TurnXY(x, y, dir: integer): boolean;
    function WalkXY(x, y: integer): boolean;
    function RunXY(x, y: integer): boolean;
    procedure GetRandomMineral;
    procedure GetRandomGems;
    procedure GetRandomMineral3;
    function DigUpMine(x, y: integer): boolean;
    //      function  TargetInSwordLongAttackRange: Boolean;
    function HitXY(hitid, x, y, dir: integer): boolean;
    function GetMagic(mid: integer): PTUserMagic;
    function SpellXY(magid, targetx, targety, targcret: integer): boolean;
    function SitdownXY(x, y, dir: integer): boolean;


    procedure GetQueryUserName(target: TCreature; x, y: integer);
    procedure ServerSendAdjustBonus;
    procedure ServerGetOpenDoor(dx, dy: integer);
    procedure ServerGetTakeOnItem(where: byte; svindex: integer; itmname: string);
    procedure ServerGetTakeOffItem(where: byte; svindex: integer; itmname: string);
    function BindPotionUnit(iShape, iCount: integer): boolean;
    procedure ServerGetEatItem(svindex: integer; itmname: string);
    procedure ServerGetButch(animal: TCreature; x, y, ndir: integer);
    procedure ServerGetMagicKeyChange(magid, key: integer);
    procedure ServerGetClickNpc(clickid: integer);
    procedure ServerGetMerchantDlgSelect(npcid: integer; clickstr: string);
    procedure ServerGetMerchantQuerySellPrice(npcid, ItemIndex: integer;
      itemname: string);
    procedure ServerGetMerchantQueryRepairPrice(npcid, ItemIndex: integer;
      itemname: string);
    procedure ServerGetUserSellItem(npcid, ItemIndex, sellcnt: integer;
      itemname: string);
    procedure ServerGetUserRepairItem(npcid, ItemIndex: integer; itemname: string);
    procedure ServerSendStorageItemList(npcid: integer);
    procedure ServerGetUserStorageItem(npcid, ItemIndex, Count: integer;
      itemname: string);
    procedure ServerGetMakeDrug(npcid: integer; itemname: string);
    procedure ServerGetMakeItemSel(npcid: integer; itemname: string);
    procedure ServerGetMakeItem(npcid: integer; itemname: string);
    procedure ServerGetUserMenuBuy(msg, npcid, MakeIndex, menuindex: integer;
      itemname: string);
    procedure RefreshGroupMembers;
    procedure ServerGetCreateGroup(withwho: string);
    procedure ServerGetCreateGroupRequestOk(withwho: string);
    procedure ServerGetCreateGroupRequestFail;
    procedure ServerGetAddGroupMember(withwho: string);
    procedure ServerGetAddGroupMemberRequestOk(withwho: string);
    procedure ServerGetAddGroupMemberRequestFail;
    procedure ServerGetDelGroupMember(withwho: string);
    procedure ServerGetDealTry(withwho: string);
    procedure ServerGetDealAddItem(iidx, Count: integer; iname: string);
    procedure ServerGetDealDelItem(iidx: integer; iname: string);
    procedure ServerGetDealChangeGold(dgold: integer);
    procedure ServerGetDealEnd;
    procedure ServerGetTakeBackStorageItem(npcid, itemserverindex,
      TakeBackCnt: integer; iname: string);
    procedure ServerGetWantMiniMap;
    procedure SendChangeGuildName;
    procedure ServerGetQueryUserState(who: TCreature; xx, yy: integer);
    procedure ServerGetOpenGuildDlg;
    procedure ServerGetGuildHome;
    procedure ServerGetGuildMemberList;
    procedure ServerGetGuildAddMember(who: string);
    procedure ServerGetGuildDelMember(who: string);
    procedure ServerGetGuildUpdateNotice(body: string);
    procedure ServerGetGuildUpdateRanks(body: string);
    procedure ServerGetAdjustBonus(remainbonus: integer; bodystr: string);
    procedure ServerGetGuildMakeAlly;
    procedure ServerGetGuildBreakAlly(gname: string);

    procedure RmMakeSlaveProc(pslave: PTSlaveInfo);
    // 카운트 아이템
    procedure ServerSendItemCountChanged(mindex, icount, increase: integer;
      itmname: string);
    procedure ServerGetSumCountItem(org_mindex, ex_mindex: integer; itmnames: string);
    // 업그레이드용 내부함수(sonmg)
    function GetTotalValueOfOption(pu: PTUserItem; pstd, psJewelry: PTStdItem;
      var strResult, strEtc: string): integer;

    procedure SendLoginNotice;
    procedure ServerGetNoticeOk;
    // RelationShip ....
    procedure ServerGetRelationOptionChange(OptionType: integer; Enable: integer);
    procedure ServerGetRelationRequest(ReqType: integer; ReqSeq: integer);
    procedure ServerGetRelationDelete(ReqType: integer; OtherName: string);
    procedure ServerGetRelationDeleteRequestOk(ReqType: integer; OtherName: string);
    procedure ServerGetRelationDeleteRequestFail(ReqType: integer;
      OtherName: string);
    procedure ServerSetRelationDBWantList(body: string);
    procedure ServerSetRelationDBAdd(body: string);
    procedure ServerSetRelationDBEdit(body: string);
    procedure ServerSetRelationDBDelete(body: string);
    procedure ServerGetRelationDBGetList(body: string);
    procedure ServerGetLoverLogout;
    function GetCharMapInfo(charname: string): string;
    // User Market 위탁판매
    procedure ServerGetMarketList(MarketNpc: TCreature; page_: integer;
      body: string);
    procedure ServerGetMarketSell(MarketNpc: TCreature; count_: integer;
      makeindex_: integer; body: string);
    procedure ServerGetMarketBuy(MarketNpc: TCreature; SellIndex_: integer);
    procedure ServerGetMarketCancel(MarketNpc: TCreature; SellIndex_: integer);
    procedure ServerGetMarketGetPay(MarketNpc: TCreature; SellIndex_: integer);
    procedure ServerGetMarketClose;

    // 문파장원
    procedure ServerGetGuildAgitList(page: integer);  //장원 목록
    function ServerGetGuildAgitTag(who: TCreature; body: string): boolean;
    // 장원 쪽지
    function ExecuteGuildAgitTrade: integer; //장원 거래 성사.
    // 장원게시판
    procedure ServerGetGaBoardList(page: integer);  //장원게시판 목록
    procedure ServerGetGaBoardRead(NumSeries: string);
    procedure ServerGetGaBoardAdd(nKind, nCurPage: integer; body: string);
    procedure ServerGetGaBoardDel(nCurPage: integer; body: string);
    procedure ServerGetGaBoardEdit(nCurPage: integer; body: string);
    procedure ServerGetGaBoardNoticeCheck;
    // 장원꾸미기
    procedure ServerGetDecoItemBuy(msg, npcid, ItemIndex: integer; itemname: string);

  public
    UserId:      string[20];
    UserAddress: string;
    UserHandle:  integer;
    UserGateIndex: integer;  //Gate에서의 UserIndex 게이트의 속도 향상을 위해
    //SocData: string;
    LastSocTime: longword;
    GateIndex:   integer;
    ClientVersion: integer;
    LoginClientVersion: integer;
    ClientCheckSum: integer;
    LoginDateTime: TDateTime;  //최초 접속 시간
    LoginTime:   longword;     //최소 접속 시간

    ServerShiftTime: longword; //서버 이동 클럭(sonmg 2005/05/02)

    ReadyRun:      boolean;
    Certification: integer;
    ApprovalMode:  integer;  //1:체험판사용자 2:정식사용자 3:무료사용자
    AvailableMode: integer;
    //1:개인정액 2:개인정량 3:겜방정액 4:겜방정량 5:무료사용자 6:미르2정량사용자

    UserConnectTime: longword;
    ChangeToServerNumber: integer;
    EmergencyClose: boolean;  //강제로 접속이 끊어져야 하는경우
    UserSocketClosed: boolean;
    //사용자가 강제로 접속을 끊은경우 (전투중이면 5초동안 캐릭이 남는다)
    UserRequestClose: boolean;
    SoftClosed: boolean;
    BoSaveOk:   boolean;
    // 2003/06/12 슬레이브 패치
    PrevServerSlaves: TList;  //list of PTSlaveInfo;
    TempStr:    string;
    BoChangeServerOK: boolean;

    BoChangeServer:     boolean;
    WriteChangeServerInfoCount: integer;
    ChangeMapName:      string;
    ChangeCX, ChangeCY: integer;
    BoChangeServerNeedDelay: boolean;
    ChangeServerDelayTime: longword;

    HumStruckTime:      longword;
    ClientMsgCount:     integer;
    ClientSpeedHackDetect: integer;
    LatestSpellTime:    longword;
    LatestSpellDelay:   integer;
    LatestHitTime:      longword;
    LatestWalkTime:     longword;
    LatestDropTime:     longword;
    //마지막으로 아이템 또는 금전을 떨군 시간.(서버 랙 아이템 복사 관련 sonmg)
    HitTimeOverCount:   integer;
    HitTimeOverSum:     integer;
    SpellTimeOverCount: integer;
    WalkTimeOverCount:  integer;
    WalkTimeOverSum:    integer;
    SpeedHackTimerOverCount: integer;
    MustRandomMove:     boolean;  //재접할때 맵에서 아무곳에서나 떨어지게..

    CurQuest:    pointer;  //PTQuestRecord;
    CurQuestNpc: TCreature;
    CurSayProc:  pointer;
    QuestParams: array[0..9] of integer;
    DiceParams:  array[0..9] of integer;

    BoTimeRecall:      boolean;  //시간이 되면 원위치로 돌아오옴
    BoTimeRecallGroup: boolean;  //시간이 되면 그룹 전체가 원위치로 돌아옴
    TimeRecallEnd:     longword;
    TimeRecallMap:     string;
    TimeRecallX, TimeRecallY: integer;

    PriviousCheckCode: byte;
    CrackWanrningLevel: integer;
    LastSaveTime: longword;
    Bright:    integer;  //맵의 밝기,
    FirstTimeConnection: boolean;  //캐릭터를 처음 만들어서 접속함,
    BoSendNotice: boolean;
    LoginSign: boolean;
    BoServerShifted: boolean;  //서버 이동으로 재접
    BoAccountExpired: boolean;

    LineNoticeTime:   longword;
    LineNoticeNumber: integer;

    NotReadTag: integer;
    // 연인 사제
    fLover:     TRelationShipMgr;
    //      fMaster   : TRelationShipMgr;

    FExpireTime:  longword; // TEST integer;
    FExpireCount: integer;

    constructor Create;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Finalize; override;
    procedure ResetCharForRevival;  //죽은 경우 상태 리셋
    procedure Clear_5_9_bugitems;
    procedure Reset_6_28_bugitems;
    function GetUserMassCount: integer;
    procedure WriteConLog;
    procedure SendSocket(pmsg: PTDefaultMessage; body: string);
    procedure SendDefMessage(msg, recog, param, tag, series: integer; addstr: string);
    procedure GuildRankChanged(rank: integer; rname: string);
    //운영자 명령어
    procedure ChangeSkillLevel(magname: string; lv: byte);
    procedure CmdMakeFullSkill(magname: string; lv: byte);
    procedure CmdMakeOtherChangeSkillLevel(who, magname: string; lv: byte);
    function CmdDeletePKPoint(whostr: string): boolean;
    procedure CmdSendPKPoint(whostr: string; Value: integer);
    procedure CmdChangeJob(jobname: string);
    procedure CmdChangeSex;
    procedure CmdCallMakeMonster(monname, param: string);
    procedure CmdCallMakeSlaveMonster(monname, param: string; makelv, explv: byte);
    procedure CmdMissionSetting(xstr, ystr: string);
    procedure CmdCallMakeMonsterXY(xstr, ystr, monname, countstr: string);
    procedure CmdMakeItem(itmname: string; Count: integer);
    procedure CmdRefineWeapon(dc, mc, sc, acc: integer);
    procedure CmdDeleteUserGold(whostr, goldstr: string);
    procedure CmdAddUserGold(whostr, goldstr: string);
    procedure RCmdUserChangeGoldOk(whostr: string; igold: integer);
    procedure CmdFreeSpaceMove(map, xstr, ystr: string);
    procedure CmdCharSpaceMove(CharName_: string);
    procedure CmdBreakLoverRelation;
    procedure CmdStealth;
    procedure CmdCharMove(CharName_: string; MapName: string);
    procedure CmdRushAttack;
    procedure CmdManLevelChange(man: string; level: integer);
    procedure CmdManExpChange(man: string; exp: integer);
    procedure CmdEraseItem(itmname, countstr: string);
    procedure CmdRecallMan(man, map: string);
    procedure CmdRecallMap(MapFrom: string);
    procedure GuildMasterRecallMan(man: string; bPersonal: boolean);
    //장원 소환(2004/04/13)
    procedure CmdReconnection(saddr, sport: string);
    procedure CmdReloadGuild(gname: string);
    procedure CmdReloadGuildAll(gname: string);
    procedure CmdReloadGuildAgit;
    procedure CmdKickUser(uname: string);
    procedure CmdTingUser(uname: string);
    procedure CmdTingRangeUser(uname, rangestr: string);
    procedure CmdCreateGuild(gname, mastername: string);
    procedure CmdDeleteGuild(gname: string);
    procedure CmdGetGuildMatchPoint(gname: string);
    procedure CmdStartGuildMatch;
    procedure CmdEndGuildMatch;
    procedure CmdAnnounceGuildMembersMatchPoint(gname: string);
    function GetLevelInfoString(cret: TCreature): string;
    procedure CmdSendUserLevelInfos(whostr: string);
    procedure CmdSendMonsterLevelInfos;
    procedure CmdSendKingMonsterInfos(monname: string);  //sonmg(2004/02/06)
    procedure CmdChangeUserCastleOwner(gldname: string; pass: boolean);
    procedure CmdReloadNpc(cmdstr: string);
    procedure CmdOpenCloseUserCastleMainDoor(cmdstr: string);
    procedure CmdAddShutUpList(whostr, minstr: string; pass: boolean);
    procedure CmdDelShutUpList(whostr: string; pass: boolean);
    procedure CmdSendShutUpList;
    procedure CmdOneKillMob;
    procedure CmdAgitDecoMonCount(agitnum: integer);
    procedure CmdAgitDecoMonCountHere;
    procedure CmdUserMarketDebug(strParam: string);
    // 2003/09/15 채팅로그 관련 명령어 추가
    procedure CmdAddChatLogList(whostr: string; pass: boolean);
    procedure CmdDelChatLogList(whostr: string; pass: boolean);
    procedure CmdSendChatLogList;
    // 문파장원 관련 운영자 명령어(sonmg)
    procedure CmdGuildAgitRegistration;
    procedure CmdGuildAgitAutoMove;
    procedure CmdGuildAgitDelete;
    procedure CmdGuildAgitExtendTime(Count: integer);
    procedure CmdGuildAgitRemainTime;
    procedure CmdGuildAgitRecall(man: string; WholeRecall: boolean);
    procedure CmdGuildAgitFreeMove(AgitNum: integer);
    // 문파장원 판매관련
    procedure CmdGuildAgitSale(StrForSaleGold: string);
    procedure CmdGuildAgitSaleCancel;
    procedure CmdGuildAgitBuy(page: integer);
    procedure CmdTryGuildAgitTrade;
    // 문파장원 자기 자신 추방(sonmg)
    procedure CmdGuildAgitExpulsionMyself;
    // 장원 기부금
    procedure CmdGuildAgitDonate(goldstr: string);
    procedure CmdGuildAgitViewDonation;
    function GetGuildAgitDonation: integer;
    function DecGuildAgitDonation(igold: integer): boolean;
    // 장원 파일 버전
    procedure CmdGetGuildAgitFileVersion;

    //공통 명령어
    procedure CmdEraseMagic(magname: string);
    procedure CmdThisManEraseMagic(whostr, magname: string);
    function GuildDeclareWar(gname: string): boolean;

    //Send??
    procedure SendAddItem(ui: TUserItem); //아이템이 추가됨
    procedure SendUpdateItem(ui: TUserItem);
    procedure SendUpdateItemWithLevel(ui: TUserItem; lv: integer);
    // 용아이템(sonmg)
    procedure SendUpdateItemByJob(ui: TUserItem; lv: integer);

    procedure SendDelItem(ui: TUserItem);
    procedure SendDelItemWithFlag(ui: TUserItem; wBreakdown: word);
    procedure SendDelItems(ilist: TStringList);
    procedure SendBagItems;
    procedure SendUseItems;
    procedure SendAddMagic(pum: PTUserMagic);
    procedure SendDelMagic(pum: PTUserMagic);
    procedure SendMyMagics;
    //**
    procedure Whisper(whostr, saystr: string);
    procedure LoverWhisper(whostr, saystr: string);
    procedure WhisperRe(saystr: string; IsGM: boolean);
    procedure LoverWhisperRe(saystr: string);
    procedure BlockWhisper(whostr: string);
    function IsBlockWhisper(whostr: string): boolean;
    procedure Say(saystr: string); override;
    procedure ThinkEtc;
    procedure ReadySave;
    procedure SendLogon;
    procedure SendAreaState;
    procedure DoStartupQuestNow;
    procedure Operate;
    procedure RunNotice;
    procedure GetGetNotices;
    function GetStartX: integer;
    function GetStartY: integer;
    procedure CheckHomePos;
    procedure GuildSecession;
    procedure CmdSendTestQuestDiary(unitnum: integer);

    procedure ResetDeal;
    procedure StartDeal(who: TUserHuman);
    procedure BrokeDeal;
    procedure ServerGetDealCancel;
    procedure AddDealItem(uitem: TUserItem; remain: integer);
    procedure DelDealItem(uitem: TUserItem);
    // 카운트 아이템.
    procedure AddDealCounterItem(uitem: TUserItem; remain: integer);
    procedure DelDealCounterItem(uitem: TUserItem);

    function IsReservedMakingSlave: boolean;
    //서버이동으로 RM_MAKE_SLAVE가 예약되어 있는지 여부
    // RelationShip
    function RelationShipDeleteOther(ReqType: integer; OtherName: string): boolean;

    //////////////////////////
    // 운영자 명령어 added by sonmg.2003/10/02
    function CheckSeedItem(psSeed, psJewelry: PTStdItem): integer;
    function CheckJewelryItem(iStdMode: integer): boolean;
    function SumOfOptions(puSeedItem: PTUserItem; psSeedItem: PTStdItem): integer;
    function CalcUpgradeProbability(puSeedItem, puJewelryItem: PTUserItem;
      psSeedItem, psJewelryItem: PTStdItem; iExecCount: integer;
      var iRetSum: integer; var fRetProb: double): integer;
    procedure CmdUpgradeItem(seedname, jewelryname: string;
      seedindex, jewelryindex, ExecCount: integer);
    procedure CmdMakeAllJewelryItem(nSelect: integer);
    function DoUpgradeItem(puSeed: PTUserItem;
      psSeed, psJewelry: PTStdItem): integer;
    //////////////////////////

    function SetExpiredTime(min_: integer): boolean;
    procedure CheckExpiredTime;

    // 위탁상점---------------------------------------------------------------

    // 위탁상점에 요청
    procedure RequireLoadRefresh;
    procedure RequireLoadUserMarket(MarketName: string; ItemType: integer;
      UserMode: integer; OtherName: string; ItemName_: string);
    procedure RequireSellUserMarket(MakeIndex_: integer; SellCount_: integer;
      SellPrice_: integer);
    procedure RequireBuyUserMarket(MarketNpc: TCreature; SellIndex_: integer);
    procedure RequireCancelUserMarket(MarketNpc: TCreature; SellIndex_: integer);
    procedure RequireGetPayUserMarket(MarketNpc: TCreature; SellIndex_: integer);

    // 클리이언트에 요청
    function IsExistBagItem(makeindex_: integer): PTUserItem;
    function IsFullBagCount: boolean;
    function IsEnableUseMarket: boolean;
    function DeleteFromBagItem(MakeIndex_: integer; SellCount_: integer): boolean;
    function AddToBagItem(UserItem_: TUserItem): boolean;
    function GetMarketName: string;
    procedure SendUserMarketSellReady(MarketNpc: TCreature);
    procedure SendUserMarketCloseMsg;

    // 실제로 아이템 변경
    procedure GetMarketData(pInfo: PTSearchSellItem);
    procedure SendUserMarketList(NextPage: integer);
    procedure SellUserMarket(pSellItem: PTMarketLoad);
    procedure ReadyToSellUserMarket(pReadyItem: PTMarketLoad);
    procedure BuyUserMarket(pBuyItem: PTMarketLoad);
    procedure CancelUserMarket(pCancelItem: PTMarketLoad);
    procedure GetPayUserMarket(pGetpayItem: PTMarketLoad);

    //장원게시판--------------------------------------------------------------

    // 장원게시판 요청
    procedure CmdReloadGaBoardList(gname: string; nPage: integer);
    procedure CmdGaBoardList(nPage: integer);

    //장원꾸미기--------------------------------------------------------------
    procedure CmdBuyDecoItem(nObjNum: integer);
    procedure SendDecoItemList;
  end;


implementation

uses
  svMain, M2Share, ObjNpc, Magic, LocalDB, Guild, UsrEngn, Event,
  IdSrvClient, usermgr, sqlengn;

procedure InitializeObjBase;
begin
end;

constructor TCreature.Create;
begin
  BoGhost  := False;
  GhostTime := 0;
  Death    := False;
  DeathTime := 0;
  WatchTime := GetTickCount;
  Dir      := DR_DOWN;
  RaceServer := RC_ANIMAL;
  RaceImage := 0;
  Hair     := 0;
  Job      := 0;  //warrior 1:wizard  2: taoist
  Gold     := 0;  //가지고 있는 돈
  Appearance := 0;
  HoldPlace := True;
  ViewRange := 5;
  HomeMap  := '0'; //기본맵
  NeckName := '';
  UserDegree := 0;
  Light    := 0;
  DefNameColor := 255;
  HitPowerPlus := 0;
  HitDouble := 0;
  BodyLuck := 0;
  CGHIUseTime := 0;
  CGHIstart := GetTickCount;
  BoCGHIEnable := False;
  BoOldVersionUser_Italy := False;
  BoReadyAdminPassword := False;
  BoReadySuperAdminPassword := False;


  BoFearFire := False;
  BoAbilSeeHealGauge := False;

  BoAllowPowerHit := False;  //true: 다음에 한번 HitPowerPlus가 가능함
  BoAllowslashhit := False;
  BoAllowLongHit  := False;
  BoAllowWideHit  := False;
  BoAllowWideHit2  := False;
  BoAllowFireHit  := False;
  // 2003/03/15 신규무공
  BoAllowCrossHit := False;
  BoAllowTwinHit  := 0;
  BoAllowStoneHit := False;

  AccuracyPoint := DEFHIT;
  SpeedPoint := DEFSPEED;
  HitSpeed  := 0;
  LifeAttrib := LA_CREATURE; //일반 생명있는 몬스터
  AntiPoison := 0;
  PoisonRecover := 0;
  HealthRecover := 0;
  SpellRecover := 0;
  AntiMagic := 0;
  Luck      := 0;
  IncSpell  := 0;
  IncHealth := 0;
  IncHealing := 0;
  PerHealth := 5;
  PerHealing := 5;
  PerSpell  := 5;
  IncHealthSpellTime := GetTickCount;
  RedPoisonLevel := 0;
  PoisonLevel := 0;
  FightZoneDieCount := 0;
  AvailableGold := BAGGOLD;

  CharStatus   := 0;
  CharStatusEx := 0;
  FillChar(StatusArr, sizeof(word) * STATUSARR_SIZE, #0);
  FillChar(StatusValue, sizeof(byte) * STATUSARR_SIZE, #0);
  FillChar(BonusAbil, sizeof(TNakedAbility), #0);
  FillChar(CurBonusAbil, sizeof(TNakedAbility), #0);
  FillChar(ExtraAbil, sizeof(byte) * EXTRAABIL_SIZE, #0);
  FillChar(ExtraAbilFlag, sizeof(byte) * EXTRAABIL_SIZE, #0);
  FillChar(ExtraAbilTimes, sizeof(longword) * EXTRAABIL_SIZE, #0);

  AllowGroup      := False;
  GroupRequester  := '';
  AllowEnterGuild := False;
  FreeGulityCount := 0;

  HumAttackMode    := HAM_ALL;
  FBoInFreePKArea  := False;
  BoGuildWarArea   := False;
  BoCrimeforCastle := False;

  NeverDie     := False;
  BoSkeleton   := False;  //죽어서 뼈만 남았는지 여부
  RushMode     := False;
  BoHolySeize  := False;
  BoCrazyMode  := False;
  BoGoodCrazyMode := False;
  BoOpenHealth := False;

  BoDuplication := False;

  //동물인경우 잡아서 고기가 나온다.
  BoAnimal     := False;
  BoNoItem     := False;
  BodyLeathery := 50; //기본값
  HideMode     := False;
  StickMode    := False;
  NoAttackMode := False;
  NoMaster     := False;
  BoIllegalAttack := False;

  ManaToHealthPoint     := 0;
  SuckupEnemyHealthRate := 0;
  SuckupEnemyHealth     := 0;

  FillChar(AddAbil, sizeof(TAddAbility), 0);

  MsgList     := TList.Create;
  MsgTargetList := TStringList.Create;
  PKHiterList := TList.Create;

  VisibleActors := TList.Create;
  VisibleItems  := TList.Create;
  VisibleEvents := TList.Create;
  ItemList      := TList.Create;
  DealList      := TList.Create;
  DealGold      := 0;
  MagicList     := TList.Create;
  SaveItems     := TList.Create;
  // 2003/03/15 아이템 인벤토리 확장
  FillChar(UseItems, sizeof(TUserItem) * 13, #0);   // 9->13

  PSwordSkill    := nil;
  PPowerHitSkill := nil;
  PslashhitSkill := nil;
  PLongHitSkill  := nil;
  PWideHitSkill  := nil;
  PWideHit2Skill  := nil;
  PFireHitSkill  := nil;
  // 2003/03/15 신규무공
  PCrossHitSkill := nil;
  PTwinHitSkill  := nil;
  PStoneHitSkill := nil;

  GroupOwner := nil;
  Castle     := nil;

  Master   := nil;
  SlaveExp := 0;
  SlaveExpLevel := 0;
  BoSlaveRelax := False; //기본 상태, 보이면 공격 모드

  GroupMembers   := TStringList.Create;
  BoHearWhisper  := True;
  BoHearCry      := True;
  BoHearGuildMsg := True;
  BoExchangeAvailable := True;
  BoEnableRecall := False;
  BoEnableAgitRecall := False;
  DailyQuestNumber := 0;  ///설정 안되었음    //*dq
  DailyQuestGetDate := 0;

  WhisperBlockList := TStringList.Create;
  SlaveList := TList.Create;
  FillChar(QuestStates, sizeof(QuestStates), #0);
  FillChar(QuestIndexOpenStates, sizeof(QuestIndexOpenStates), #0);
  FillChar(QuestIndexFinStates, sizeof(QuestIndexFinStates), #0);

  PFTime := GetTickCount;
  PFUseTime := 0;

  with Abil do begin
    Level  := 1;
    AC     := 0;
    MAC    := 0;
    DC     := MakeWord(1, 4);  //동물의 기본 공격
    MC     := MakeWord(1, 2);
    SC     := MakeWord(1, 2);
    MP     := 15;
    HP     := 15;
    MaxHP  := 15;
    MaxMP  := 15;
    Exp    := 0;
    MaxExp := 50;
    Weight := 0;
    MaxWeight := 100;
  end;

  WantRefMsg   := False;
  BoDealing    := False;
  DealCret     := nil;
  MyGuild      := nil;
  GuildRank    := 0;
  GuildRankName := '';
  LatestNpcCmd := '';

  BoHasMission    := False;
  BoHumHideMode   := False;
  BoStoneMode     := False;
  RevivalMode     := False;
  BoViewFixedHide := False;
  BoNextTimeFreeCurseItem := False;

  BoFixedHideMode := False;
  BoSysopMode := False;
  BoSuperviserMode := False;
  BoEcho := True;
  BoTaiwanEventUser := False;

  RunTime     := GetCurrentTime + Random(1500);
  RunNextTick := 250;
  SearchRate  := 2000 + longword(Random(2000));
  SearchTime  := GetTickCount;
  time4hour   := GetTickCount;
  time10min   := GetTickCount;
  time500ms   := GetTickCount;
  poisontime  := GetTickCount;
  time30sec   := GetTickCount;
  time10sec   := GetTickCount;
  time5sec    := GetTickCount;
  ticksec     := GetTickCount;
  LatestCryTime := 0; //GetTickCount;
  LatestSpaceMoveTime := 0;
  LatestSpaceScrollTime := 0;
  LatestSearchWhoTime := 0;
  MapMoveTime := GetTickCount;
  SlaveLifeTime := 0;

  NextWalkTime    := 1400;
  NextHitTime     := 3000;
  WalkCurStep     := 0;
  WalkWaitCurTime := GetTickCount;
  BoWalkWaitMode  := False;

  HealthTick := 0;
  SpellTick  := 0;

  TargetCret    := nil;
  LastHiter     := nil;
  LastHiterRace := -1;
  SlaveHiter    := nil;
  ExpHiter      := nil;
  // 2003/03/04
  RefObjCount   := 0;
  FAlreadyDisapper := False;

  ForceMoveToMaster := False;
  BoDontMove := False;
  BoDisapear := False;
  DontBagItemDrop := False;
  DontBagGoldDrop := False;
  MasterFeature := 0;
  bStealth := False;

  InstantExpDoubleTime := 0;

  BoLoseTargetMoment := False; //sonmg

  BoHighLevelEffect  := True;   //50레벨 효과 표시/숨김(sonmg)
  BoGuildAgitDealTry := False;

  MeltArea := 2;
end;

destructor TCreature.Destroy;
var
  i: integer;
begin
  try
    for i := 0 to MsgList.Count - 1 do begin
      //메모리를 추가로 해제해야 하는 경우
      if PTMessageInfoPtr(MsgList[i]).Ident = RM_DELITEMS then
        if PTMessageInfoPtr(MsgList[i]).lparam1 <> 0 then
          TStringList(PTMessageInfoPtr(MsgList[i]).lparam1).Free;
      if PTMessageInfoPtr(MsgList[i]).Ident = RM_MAKE_SLAVE then
        if PTMessageInfoPtr(MsgList[i]).lparam1 <> 0 then
          Dispose(PTSlaveInfo(PTMessageInfoPtr(MsgList[i]).lparam1));
      if PTMessageInfoPtr(MsgList[i]).descptr <> nil then
        FreeMem(PTMessageInfoPtr(MsgList[i]).descptr);
      Dispose(PTMessageInfoPtr(MsgList[i]));
    end;
    MsgList.Free;
    MsgTargetList.Free;
    for i := 0 to PKHiterList.Count - 1 do
      Dispose(PTPkHiterInfo(PKHiterList[i]));
    PKHiterList.Free;
    // 2003/03/18
    i := 0;
    while True do begin
      if i >= VisibleActors.Count then
        break;
         {
         if RaceServer = RC_USERHUMAN then begin
         try
            if(PTVisibleActor(VisibleActors[i]).cret <> nil) then
               TCreature (PTVisibleActor(VisibleActors[i]).cret).DecRefObjCount;
         except
            MainOutMessage ('[Exception] TCreatre.Destroy : Visible Actor Dec RefObjCount');
            end;
         end;
         }
      Dispose(PTVisibleActor(VisibleActors[i]));
      VisibleActors.Delete(i);
      //       Inc(i);
    end;
    VisibleActors.Free;
    for i := 0 to VisibleItems.Count - 1 do
      Dispose(PTVisibleItemInfo(VisibleItems[i]));
    VisibleItems.Free;
    VisibleEvents.Free;

    for i := 0 to ItemList.Count - 1 do
      Dispose(PTUserItem(ItemList[i]));
    ItemList.Free;
    for i := 0 to DealList.Count - 1 do
      Dispose(PTUserItem(DealList[i]));
    DealList.Free;
    for i := 0 to MagicList.Count - 1 do
      Dispose(PTUserMagic(MagicList[i]));
    MagicList.Free;
    for i := 0 to SaveItems.Count - 1 do
      Dispose(PTUserItem(SaveItems[i]));
    SaveItems.Free;
    GroupMembers.Free;
    WhisperBlockList.Free;
    SlaveList.Free;
  except
    MainOutMessage('[Exception] TCreature.Destroy ' + UserName);
  end;

  inherited Destroy;
end;

procedure TCreature.SetBoInFreePKArea(flag: boolean);
begin
  if FBoInFreePKArea <> flag then begin
    FBoInFreePKArea := flag;
    AreaStateOrNameChanged := True;
  end;
end;

function TCreature.GetNextHitTime: longint;
begin
  if StatusArr[POISON_SLOW] > 0 then
    Result := NextHitTime + NextHitTime div 2
  else
    Result := NextHitTime;
end;

function TCreature.GetNextWalkTime: longint;
begin
  if StatusArr[POISON_SLOW] > 0 then
    Result := NextWalkTime + NextWalkTime div 2
  else
    Result := NextWalkTime;
end;

// 움직일수 있나 체크함
function TCreature.IsMoveAble: boolean;
begin
  if (not BoGhost) and // 맵상에 있고
    (not Death) and    // 죽지 않고
    (StatusArr[POISON_STONE] = 0) and // 상태 이상이 아니고
    (StatusArr[POISON_ICE] = 0) and (StatusArr[POISON_STUN] = 0) and
    (StatusArr[POISON_DONTMOVE] = 0) then
    Result := True
  else
    Result := False;

end;

procedure TCreature.ChangeItemWithLevel(var citem: TClientItem; lv: integer);
begin
  //천의무봉이면
  if (citem.s.Shape = DRESS_SHAPE_WING) and
    ((citem.S.StdMode = DRESS_STDMODE_MAN) or (citem.S.StdMode = DRESS_STDMODE_WOMAN))
  then begin

    if Lv >= 20 then // 레벨에따른 값 변경
    begin

      if (lv < 30) then // 20 ~ 29
      begin
        // 기본값으로 설정
      end else if (lv < 40) then // 30 ~ 39
      begin
        citem.S.DC  := citem.S.DC + MakeWord(0, 1); // 공격
        citem.S.MC  := citem.S.MC + MakeWord(0, 2); // 마력
        citem.S.SC  := citem.S.SC + MakeWord(0, 2); // 도력
        citem.S.AC  := citem.S.AC + MakeWord(2, 3); // 방어
        citem.S.MAC := citem.S.MAC + MakeWord(0, 2); // 마방
      end else if (Lv < 50) then  // 40 ~ 49
      begin
        citem.S.DC  := citem.S.DC + MakeWord(0, 3); // 공격
        citem.S.MC  := citem.S.MC + MakeWord(0, 4); // 마력
        citem.S.SC  := citem.S.SC + MakeWord(0, 4); // 도력
        citem.S.AC  := citem.S.AC + MakeWord(5, 5); // 방어
        citem.S.MAC := citem.S.MAC + MakeWord(1, 2); // 마방
      end else// 50~
      begin
        citem.S.DC  := citem.S.DC + MakeWord(0, 5);  // 공격
        citem.S.MC  := citem.S.MC + MakeWord(0, 6);  // 마력
        citem.S.SC  := citem.S.SC + MakeWord(0, 6);  // 도력
        citem.S.AC  := citem.S.AC + MakeWord(9, 7);  // 방어
        citem.S.MAC := citem.S.MAC + MakeWord(2, 4); // 마방
      end;

    end;

  end;
end;

//직업에 따른 능력치 적용(sonmg)
procedure TCreature.ChangeItemByJob(var citem: TClientItem; lv: integer);
begin
  // 주의 : ApplyItemParametersByJob 과 동일한 값을 가져야 함(sonmg)

  //////////////////////////////////////
  //--------------
  //반지
  if (citem.S.StdMode = 22) and (citem.S.Shape = DRAGON_RING_SHAPE) then begin
    case Job of
      0: //warrior
      begin
        citem.S.DC := MakeWord(Lobyte(citem.S.DC),
          _MIN(255, Hibyte(citem.S.DC) + 4));   //하드코딩
        citem.S.MC := 0;
        citem.S.SC := 0;
      end;
      1: //wizard
      begin
        citem.S.DC := 0;
        //그대로               citem.S.MC := 0;
        citem.S.SC := 0;
      end;
      2: //taoist
      begin
        //               citem.S.DC := 0;
        citem.S.MC := 0;
        //               citem.S.SC := 0;
      end;
      3: //assassin
      begin
        citem.S.DC := MakeWord(Lobyte(citem.S.DC),
          _MIN(255, Hibyte(citem.S.DC) + 4));   //하드코딩
        citem.S.MC := 0;
        citem.S.SC := 0;
      end;
    end;//case
        //--------------
        //팔찌26
  end else if (citem.S.StdMode = 26) and (citem.S.Shape = DRAGON_BRACELET_SHAPE) then
  begin
    case Job of
      0: //warrior
      begin
        citem.S.DC := MakeWord(Lobyte(citem.S.DC) + 1,
          _MIN(255, Hibyte(citem.S.DC) + 2));   //하드코딩
        citem.S.MC := 0;
        citem.S.SC := 0;
        citem.S.AC := MakeWord(Lobyte(citem.S.AC),
          _MIN(255, Hibyte(citem.S.AC) + 1));   //하드코딩
      end;
      1: //wizard
      begin
        citem.S.DC := 0;
        //               citem.S.MC := 0;
        citem.S.SC := 0;
        citem.S.AC := MakeWord(Lobyte(citem.S.AC),
          _MIN(255, Hibyte(citem.S.AC) + 1));   //하드코딩
      end;
      2: //taoist
      begin
        //               citem.S.DC := 0;
        citem.S.MC := 0;
        //               citem.S.SC := 0;
        //               citem.S.AC := 0;
      end;
      3: //assassin
      begin
        citem.S.DC := MakeWord(Lobyte(citem.S.DC) + 1,
          _MIN(255, Hibyte(citem.S.DC) + 2));   //하드코딩
        citem.S.MC := 0;
        citem.S.SC := 0;
        citem.S.AC := MakeWord(Lobyte(citem.S.AC),
          _MIN(255, Hibyte(citem.S.AC) + 1));   //하드코딩
      end;
    end;//case
        //--------------
        //목걸이
  end else if (citem.S.StdMode = 19) and (citem.S.Shape = DRAGON_NECKLACE_SHAPE) then
  begin
    case Job of
      0: //warrior
      begin
        //               citem.S.DC := 0;
        citem.S.MC := 0;
        citem.S.SC := 0;
      end;
      1: //wizard
      begin
        citem.S.DC := 0;
        //               citem.S.MC := 0;
        citem.S.SC := 0;
      end;
      2: //taoist
      begin
        citem.S.DC := 0;
        citem.S.MC := 0;
        //               citem.S.SC := 0;
      end;
      3: //assassin
      begin
        //               citem.S.DC := 0;
        citem.S.MC := 0;
        citem.S.SC := 0;
      end;
    end;//case
        //--------------
        //옷
  end else if ((citem.S.StdMode = 10) or (citem.S.StdMode = 11)) and
    (citem.S.Shape = DRAGON_DRESS_SHAPE) then begin
    case Job of
      0: //warrior
      begin
        //               citem.S.DC := 0;
        citem.S.MC := 0;
        citem.S.SC := 0;
      end;
      1: //wizard
      begin
        citem.S.DC := 0;
        //               citem.S.MC := 0;
        citem.S.SC := 0;
      end;
      2: //taoist
      begin
        citem.S.DC := 0;
        citem.S.MC := 0;
        //               citem.S.SC := 0;
      end;
      3: //assassin
      begin
        //               citem.S.DC := 0;
        citem.S.MC := 0;
        citem.S.SC := 0;
      end;
    end;//case
        //--------------
        //투구
  end else if (citem.S.StdMode = 15) and (citem.S.Shape = DRAGON_HELMET_SHAPE) then
  begin
    case Job of
      0: //warrior
      begin
        //               citem.S.DC := 0;
        citem.S.MC := 0;
        citem.S.SC := 0;
      end;
      1: //wizard
      begin
        citem.S.DC := 0;
        //               citem.S.MC := 0;
        citem.S.SC := 0;
      end;
      2: //taoist
      begin
        citem.S.DC := 0;
        citem.S.MC := 0;
        //               citem.S.SC := 0;
      end;
      3: //assassin
      begin
        //               citem.S.DC := 0;
        citem.S.MC := 0;
        citem.S.SC := 0;
      end;
    end;//case
        //--------------
        //무기
  end else if ((citem.S.StdMode = 5) or (citem.S.StdMode = 6)) and
    (citem.S.Shape = DRAGON_WEAPON_SHAPE) then begin
    case Job of
      0: //warrior
      begin
        citem.S.DC := MakeWord(Lobyte(citem.S.DC) + 1,
          _MIN(255, Hibyte(citem.S.DC) + 28));   //하드코딩
        citem.S.MC := 0;
        citem.S.SC := 0;
        // 행운에서 2를 뺀다. 즉, Lo(AC)에서 2를 뺀다.
        citem.S.AC := MakeWord(LOBYTE(citem.S.AC) - 2, HIBYTE(citem.S.AC));

        // 행운을 공속으로 바꾸고 행운을 없앤다.
        // Lo(AC)를 Hi(MAC)에 집어 넣는다.
        //               std.MAC := MakeWord(LOBYTE(std.MAC), LOBYTE(std.AC) + 10);
        //               std.AC := MakeWord(0, HIBYTE(std.AC));
      end;
      1: //wizard
      begin
        //               citem.S.DC := 0;
        //               citem.S.MC := 0;
        citem.S.SC := 0;
        // 공속에서 12를 빼고 행운값은 반영한다.
        if HIBYTE(citem.S.MAC) > 12 then
          citem.S.MAC := MakeWord(LOBYTE(citem.S.MAC), HIBYTE(citem.S.MAC) - 12)
        else
          citem.S.MAC := MakeWord(LOBYTE(citem.S.MAC), 0);

      end;
      2: //taoist
      begin
        citem.S.DC := MakeWord(Lobyte(citem.S.DC) + 2,
          _MIN(255, Hibyte(citem.S.DC) + 10));   //하드코딩
        citem.S.MC := 0;
        //               citem.S.SC := 0;
        // 행운에서 2를 뺀다. 즉, Lo(AC)에서 2를 뺀다.
        citem.S.AC := MakeWord(LOBYTE(citem.S.AC) - 2, HIBYTE(citem.S.AC));

        // 행운을 공속으로 바꾸고 행운을 없앤다.
        // Lo(AC)를 Hi(MAC)에 집어 넣는다.
        //               std.MAC := MakeWord(LOBYTE(std.MAC), LOBYTE(std.AC) + 10);
        //               std.AC := MakeWord(0, HIBYTE(std.AC));
      end;
      3: //assassin
      begin
        citem.S.DC := MakeWord(Lobyte(citem.S.DC) + 1,
          _MIN(255, Hibyte(citem.S.DC) + 28));   //하드코딩
        citem.S.MC := 0;
        citem.S.SC := 0;
        // 행운에서 2를 뺀다. 즉, Lo(AC)에서 2를 뺀다.
        citem.S.AC := MakeWord(LOBYTE(citem.S.AC) - 2, HIBYTE(citem.S.AC));

        // 행운을 공속으로 바꾸고 행운을 없앤다.
        // Lo(AC)를 Hi(MAC)에 집어 넣는다.
        //               std.MAC := MakeWord(LOBYTE(std.MAC), LOBYTE(std.AC) + 10);
        //               std.AC := MakeWord(0, HIBYTE(std.AC));
      end;
    end;//case
        //--------------
        //수호석(막대사탕)
  end else if (citem.S.StdMode = 53) then begin
    if (citem.S.Shape = LOLLIPOP_SHAPE) then begin
      case Job of
        0: //warrior
        begin
          citem.S.DC :=
            MakeWord(Lobyte(citem.S.DC), _MIN(255, Hibyte(citem.S.DC) + 2));  //하드코딩
          citem.S.MC := 0;
          citem.S.SC := 0;
        end;
        1: //wizard
        begin
          citem.S.DC := 0;
          citem.S.MC :=
            MakeWord(Lobyte(citem.S.MC), _MIN(255, Hibyte(citem.S.MC) + 2));  //하드코딩
          citem.S.SC := 0;
        end;
        2: //taoist
        begin
          citem.S.DC := 0;
          citem.S.MC := 0;
          citem.S.SC :=
            MakeWord(Lobyte(citem.S.SC), _MIN(255, Hibyte(citem.S.SC) + 2));  //하드코딩
        end;
        3: //assassin
        begin
          citem.S.DC :=
            MakeWord(Lobyte(citem.S.DC), _MIN(255, Hibyte(citem.S.DC) + 2));  //하드코딩
          citem.S.MC := 0;
          citem.S.SC := 0;
        end;
      end;//case
    end else if (citem.S.Shape = GOLDMEDAL_SHAPE) or
      (citem.S.Shape = SILVERMEDAL_SHAPE) or (citem.S.Shape = BRONZEMEDAL_SHAPE) then
    begin
      case Job of
        0: //warrior
        begin
          citem.S.DC :=
            MakeWord(Lobyte(citem.S.DC), _MIN(255, Hibyte(citem.S.DC)));
          citem.S.MC := 0;
          citem.S.SC := 0;
        end;
        1: //wizard
        begin
          citem.S.DC := 0;
          citem.S.MC :=
            MakeWord(Lobyte(citem.S.MC), _MIN(255, Hibyte(citem.S.MC)));
          citem.S.SC := 0;
        end;
        2: //taoist
        begin
          citem.S.DC := 0;
          citem.S.MC := 0;
          citem.S.SC :=
            MakeWord(Lobyte(citem.S.SC), _MIN(255, Hibyte(citem.S.SC)));
        end;
        3: //assassin
        begin
          citem.S.DC :=
            MakeWord(Lobyte(citem.S.DC), _MIN(255, Hibyte(citem.S.DC)));
          citem.S.MC := 0;
          citem.S.SC := 0;
        end;
      end;//case
    end;
  end;//if series
      //////////////////////////////////////
      // 2004-06-29 신규갑옷(파황천마의) 직업별 능력치
  if ((citem.S.StdMode = 10) or (citem.S.StdMode = 11)) and
    (citem.S.Shape = DRESS_SHAPE_PBKING) then begin
    case Job of
      0: //warrior
      begin
        citem.S.DC    := MakeWord(Lobyte(citem.S.DC),
          _MIN(255, Hibyte(citem.S.DC) + 2));   //하드코딩
        citem.S.MC    := 0;
        citem.S.SC    := 0;
        citem.S.AC    := MakeWord(Lobyte(citem.S.AC) + 2,
          _MIN(255, Hibyte(citem.S.AC) + 4));   //하드코딩
        //               citem.S.MAC := 0;
        citem.S.MpAdd := citem.S.MpAdd + 30;   //하드코딩
      end;
      1: //wizard
      begin
        citem.S.DC    := 0;
        //               citem.S.MC := 0;
        citem.S.SC    := 0;
        //               citem.S.AC := 0;
        citem.S.MAC   := MakeWord(Lobyte(citem.S.MAC) + 1,
          _MIN(255, Hibyte(citem.S.MAC) + 2));   //하드코딩
        citem.S.HpAdd := citem.S.HpAdd + 30;     //하드코딩
      end;
      2: //taoist
      begin
        citem.S.DC    := MakeWord(Lobyte(citem.S.DC) + 1,
          _MIN(255, Hibyte(citem.S.DC)));   //하드코딩
        citem.S.MC    := 0;
        //               citem.S.SC := 0;
        citem.S.AC    := MakeWord(Lobyte(citem.S.AC) + 1,
          _MIN(255, Hibyte(citem.S.AC)));   //하드코딩
        citem.S.MAC   := MakeWord(Lobyte(citem.S.MAC) + 1,
          _MIN(255, Hibyte(citem.S.MAC)));     //하드코딩
        citem.S.HpAdd := citem.S.HpAdd + 20;   //하드코딩
        citem.S.MpAdd := citem.S.MpAdd + 10;   //하드코딩
      end;
      3: //assassin
      begin
        citem.S.DC    := MakeWord(Lobyte(citem.S.DC),
          _MIN(255, Hibyte(citem.S.DC) + 2));   //하드코딩
        citem.S.MC    := 0;
        citem.S.SC    := 0;
        citem.S.AC    := MakeWord(Lobyte(citem.S.AC) + 2,
          _MIN(255, Hibyte(citem.S.AC) + 4));   //하드코딩
        //               citem.S.MAC := 0;
        citem.S.MpAdd := citem.S.MpAdd + 30;   //하드코딩
      end;
    end;//case
  end;

end;

function TCreature.CheckUnbindItem(itemname: string): boolean;
var
  i: integer;
begin
  Result := False;

  for i := 0 to UnbindItemList.Count - 1 do begin
    if CompareText(itemname, UnbindItemList[i]) = 0 then begin
      Result := True;
      break;
    end;
  end;
end;

procedure TCreature.DeleteItemFromBag(psDel: PTStdItem; puDel: PTUserItem);
var
  i, j: integer;
  ps:   PTStdItem;
  pu:   PTUserItem;
  hum:  TUserHuman;
begin
  for i := 0 to Itemlist.Count - 1 do begin
    if PTUserItem(ItemList[i]).MakeIndex = puDel.MakeIndex then begin
      ps := UserEngine.GetStdItem(PTUserItem(Itemlist[i]).Index);
      pu := PTUserItem(Itemlist[i]);

      //갯수 아이템인 경우
      if ps.OverlapItem >= 1 then begin
        if pu.Dura > 0 then begin
          pu.Dura := pu.Dura - 1;

          if pu.Dura <= 0 then begin
            if RaceServer = RC_USERHUMAN then begin
              hum := TUserHuman(self);
              hum.SendDelItem(PTUserItem(ItemList[i])^);
            end;
            Dispose(PTUserItem(ItemList[i]));
            ItemList.Delete(i);
          end else begin
            SendMsg(self, RM_COUNTERITEMCHANGE, 0, pu.MakeIndex,
              pu.Dura, 0, ps.Name);
          end;
        end else begin
          if RaceServer = RC_USERHUMAN then begin
            hum := TUserHuman(self);
            hum.SendDelItem(PTUserItem(ItemList[i])^);
          end;
          Dispose(PTUserItem(ItemList[i]));
          ItemList.Delete(i);
        end;
      end else begin
        //갯수 아이템이 아닌 경우.
        if RaceServer = RC_USERHUMAN then begin
          hum := TUserHuman(self);
          hum.SendDelItem(PTUserItem(ItemList[i])^);
        end;
        Dispose(PTUserItem(ItemList[i]));
        ItemList.Delete(i);
      end;
      break;
    end;
  end;

  WeightChanged;
end;

// 2004/03/17 (sonmg)
function TCreature.FindItemToBindFromBag(Count: integer; itemname: string;
  var dellist: TStringList): integer;
var
  i, j, k: integer;
  pu:      PTUserItem;
  pstd:    PTStdItem;
  itemcount, delcount: integer;
  strItemName: string;
  hum:     TUserHuman;
begin
  Result  := -1;
  dellist := nil;

  if itemname <> '' then begin
    if CheckUnbindItem(itemname) = False then begin
      exit;
    end;
  end;

  try
    // UnbindItemList에 해당하는 아이템이 몇 개 있는지 가방창에서 검사.
    for i := 0 to UnbindItemList.Count - 1 do begin
      if itemname <> '' then begin
        if CompareText(itemname, UnbindItemList[i]) <> 0 then
          continue;
      end;

      itemcount := 0;
      for j := 0 to Itemlist.Count - 1 do begin
        pstd := UserEngine.GetStdItem(PTUserItem(Itemlist[j]).Index);
        if pstd <> nil then begin
          if CompareText(pstd.Name, UnbindItemList[i]) = 0 then begin
            Inc(itemcount);
          end;
        end;
      end;
      // Bind할 아이템 개수를 충족하면...
      if itemcount >= Count then begin
        strItemName := UnbindItemList[i];
        Result      := integer(UnbindItemList.Objects[i]);
        break;
      end;
    end;

    // Bind할 아이템 삭제.
    if Result >= 0 then begin
      delcount := 0;
      for i := 0 to ItemList.Count - 1 do begin
        pu := PTUserItem(ItemList[i]);
        if CompareText(UserEngine.GetStdItemName(pu.Index), strItemName) = 0 then
        begin
          if RaceServer = RC_USERHUMAN then begin
            if dellist = nil then
              dellist := TStringList.Create;
            //떨어뜨린 아이템을 클라이언트에 알림.
            dellist.AddObject(UserEngine.GetStdItemName(pu.Index),
              TObject(pu.MakeIndex));
          end;
          Inc(delcount);
          if delcount >= Count then
            break;
        end;
      end;
    end;
  except
    MainOutMessage('[Exception] TUserHuman.FindItemToBindFromBag');
  end;
end;

function TCreature.GuildAgitInvitationItemSet(pu: PTUserItem): boolean;
var
  ayear, amon, aday, ahour, amin, asec, amsec: word;
  nowdate: TDateTime;
  AgitNum: integer;
  gname:   string;
  guildagit, myguildagit: TGuildAgit;
begin
  Result  := False;
  AgitNum := 0;

  gname     := GetGuildNameHereAgit;
  guildagit := GuildAgitMan.GetGuildAgit(gname);
  if guildagit = nil then
    exit;

  // 운영자가 아니면 장원이 일치하는지 검사한다.
  if UserDegree < UD_ADMIN then begin
    // 일반 유저는 해당 장원에서만 초대장을 얻을 수 있다.
    if MyGuild = nil then
      exit;
    myguildagit := GuildAgitMan.GetGuildAgit(TGuild(MyGuild).GuildName);
    if myguildagit = nil then
      exit;

    //현재 맵이 할당된 장원이 없거나 자신의 문파가 장원을 소유하고 있지 않으면...
    if (guildagit.GuildAgitNumber <= 0) or (myguildagit.GuildAgitNumber <= 0) then
      exit;

    //현재 맵의 장원번호와 자신의 문파 장원번호가 일치하지 않으면 얻을 수 없다.
    if guildagit.GuildAgitNumber <> myguildagit.GuildAgitNumber then
      exit;
  end;

  // 장원번호 할당.
  AgitNum := guildagit.GuildAgitNumber;

  // 현재 시각
  nowdate := Now;
  DecodeDate(nowdate, ayear, amon, aday);
  DecodeTime(nowdate, ahour, amin, asec, amsec);

  // 장원 번호를 기록한다.
  pu.Dura := AgitNum;

  // 생성 일시(년월일시)를 기록한다.
  pu.DuraMax := ayear;
  pu.Desc[0] := amon;
  pu.Desc[1] := aday;
  pu.Desc[2] := ahour;

  Result := True;
end;

function TCreature.GuildAgitDecoItemSet(pu: PTUserItem; Number: integer): boolean;
var
  nowdate:   TDateTime;
  gname:     string;
  guildagit: TGuildAgit;
begin
  Result := False;

  // Number를 설정한다.
  pu.Dura := Number;

  Result := True;
end;

function TCreature.GuildAgitInvitationTimeOutCheck(pu: PTUserItem): boolean;
var
  nowdate: TDateTime;
  exdate, extime, exdatetime: TDateTime;
  cYear, cMon, cDay, cHour, cMin, cSec, cMSec: word;
begin
  Result := False;

  try
    // 현재 시각
    nowdate := Now;

    // 생성일시 입력.
    cYear := pu.DuraMax;
    cMon  := MakeWord(pu.Desc[0], 0);
    cDay  := MakeWord(pu.Desc[1], 0);
    cHour := MakeWord(pu.Desc[2], 0);
    cMin  := 0;
    cSec  := 0;
    cMSec := 0;

    // 에러
    if (cMon = 0) or (cDay = 0) then
      exit;

    // 마감 시간 = 생성일시 + 1일.
    exdate     := Trunc(EncodeDate(cYear, cMon, cDay));
    extime     := EncodeTime(cHour, cMin, cSec, cMSec);
    exdatetime := exdate + extime + 1;

    // 비교
    if nowdate <= exdatetime then begin
      Result := True;
    end;
  except
    MainOutMessage('[Exception]TCreature.GuildAgitInvitationTimeOutCheck');
  end;
end;

//2003/03/18
procedure TCreature.DecRefObjCount;
var
  i:   integer;
  pva: PTVisibleActor;
begin
{
   //2003/04/21
   if RaceServer = RC_USERHUMAN then exit;
   try
      Dec(RefObjCount);
      if(RefObjCount <= 0) then begin
         RefObjCount := 0;
         if(VisibleActors.Count > 0) then begin
            i := 0;
            while TRUE do begin
               if i >= VisibleActors.Count then break;
               pva := PTVisibleActor(VisibleActors[i]);
               VisibleActors.Delete (i);
               Dispose (pva);
//             Inc(i);
               continue;
            end;
         end;
      end;
   except
      MainOutMessage ('[Exception] TCreature.DecRefObjCount ('+UserName+'/'+IntToStr(RefObjCount)+')');
   end;
}
end;

function TCreature.ItemOptionToStr(optiondata: array of byte): string;
var
  i:     integer;
  rtstr: string;
begin
  rtstr := '';
  try
    for i := 0 to 13 do begin
      rtstr := rtstr + IntToStr(optiondata[i]);
    end;
  except
    MainOutMessage('DO NOT MAKE STRING ITEMOPTION');
  end;
  Result := rtstr;
end;

function TCreature.UpgradeResultToStr(iSum: integer; strOpt: string;
  iBefore, iAfter: integer; fProb: double; iJewelStdMode: integer): string;
var
  rtstr: string[20];
  strJewelType: string;
begin
  rtstr := '';
  if iJewelStdMode = 60 then begin
    strJewelType := 'GEM';
  end else if iJewelStdMode = 61 then begin
    strJewelType := 'ORB';
  end;
  try
    rtstr := IntToStr(iSum) + ',' + strJewelType + ',' + strOpt +
      ',' + IntToStr(iBefore) + ',' + IntToStr(iAfter) + ',' + FloatToStr(fProb);

{$IFDEF DEBUG} //sonmg
      // For Debug
      SysMsg(rtstr, 0);
{$ENDIF}
  except
    MainOutMessage('[Exception!] TCreature.UpgradeResultToStr Cannot Make Log String');
  end;
  Result := rtstr;
end;

procedure TCreature.SendFastMsg(Sender: TCreature; Ident, wparam: word;
  lParam1, lParam2, lParam3: longint; str: string);
var
  pmsg: PTMessageInfoPtr;
begin
  try
    csObjMsgLock.Enter;
    if not BoGhost then begin
      new(pmsg);
      pmsg.Ident   := Ident;
      pmsg.wparam  := wparam;
      pmsg.lparam1 := lparam1;
      pmsg.lparam2 := lparam2;
      pmsg.lParam3 := lparam3;
      pmsg.Sender  := Sender;
      if str <> '' then begin
        try
          GetMem(pmsg.descptr, Length(str) + 1);
          Move(str[1], pmsg.descptr^, Length(str) + 1);
        except
          pmsg.descptr := nil;
        end;
      end else
        pmsg.descptr := nil;
      MsgList.Insert(0, pmsg);
    end;
  finally
    csObjMsgLock.Leave;
  end;
end;

procedure TCreature.SendMsg(Sender: TCreature; Ident, wparam: word;
  lParam1, lParam2, lParam3: longint; str: string);
var
  pmsg: PTMessageInfoPtr;
begin
  try
    csObjMsgLock.Enter;
    if not BoGhost then begin
      new(pmsg);
      pmsg.Ident   := Ident;
      pmsg.wparam  := wparam;
      pmsg.lparam1 := lparam1;
      pmsg.lparam2 := lparam2;
      pmsg.lParam3 := lparam3;
      pmsg.deliverytime := 0;
      pmsg.Sender  := Sender;
      if str <> '' then begin
        try
          GetMem(pmsg.descptr, Length(str) + 1);
          Move(str[1], pmsg.descptr^, Length(str) + 1);
        except
          pmsg.descptr := nil;
        end;
      end else
        pmsg.descptr := nil;
      MsgList.Add(pmsg);
    end;
  finally
    csObjMsgLock.Leave;
  end;
end;

procedure TCreature.SendDelayMsg(Sender: TCreature; Ident, wparam: word;
  lParam1, lParam2, lParam3: longint; str: string; delay: integer{ms});
var
  pmsg: PTMessageInfoPtr;
begin
  try
    csObjMsgLock.Enter;
    if not BoGhost then begin
      new(pmsg);
      pmsg.Ident   := Ident;
      pmsg.wparam  := wparam;
      pmsg.lparam1 := lparam1;
      pmsg.lparam2 := lparam2;
      pmsg.lParam3 := lparam3;
      pmsg.deliverytime := GetTickCount + longword(delay);
      pmsg.Sender  := Sender;
      if str <> '' then begin
        try
          GetMem(pmsg.descptr, Length(str) + 1);
          Move(str[1], pmsg.descptr^, Length(str) + 1);
        except
          pmsg.descptr := nil;
        end;
      end else
        pmsg.descptr := nil;
      MsgList.Add(pmsg);
    end;
  finally
    csObjMsgLock.Leave;
  end;
end;

procedure TCreature.UpdateDelayMsg(Sender: TCreature; Ident, wparam: word;
  lParam1, lParam2, lParam3: longint; str: string; delay: integer{ms});
var
  i:    integer;
  pmsg: PTMessageInfoPtr;
begin
  csObjMsgLock.Enter;
  try
    i := 0;
    while True do begin
      if i >= MsgList.Count then
        break;
      if PTMessageInfoPtr(MsgList[i]).Ident = Ident then begin
        pmsg := PTMessageInfoPtr(MsgList[i]);
        MsgList.Delete(i);
        if pmsg.descptr <> nil then
          FreeMem(pmsg.descptr);
        Dispose(pmsg);
      end else
        Inc(i);
    end;
  finally
    csObjMsgLock.Leave;
  end;
  SendDelayMsg(Sender, Ident, wparam, lParam1, lParam2, lParam3, str, delay);
end;

procedure TCreature.UpdateDelayMsgCheckParam1(Sender: TCreature;
  Ident, wparam: word; lParam1, lParam2, lParam3: longint; str: string;
  delay: integer{ms});
var
  i:    integer;
  pmsg: PTMessageInfoPtr;
begin
  csObjMsgLock.Enter;
  try
    i := 0;
    while True do begin
      if i >= MsgList.Count then
        break;
      if (PTMessageInfoPtr(MsgList[i]).Ident = Ident) and
        (PTMessageInfoPtr(MsgList[i]).lparam1 = lparam1) then begin
        pmsg := PTMessageInfoPtr(MsgList[i]);
        MsgList.Delete(i);
        if pmsg.descptr <> nil then
          FreeMem(pmsg.descptr);
        Dispose(pmsg);
      end else
        Inc(i);
    end;
  finally
    csObjMsgLock.Leave;
  end;
  SendDelayMsg(Sender, Ident, wparam, lParam1, lParam2, lParam3, str, delay);
end;

procedure TCreature.UpdateMsg(Sender: TCreature; Ident, wparam: word;
  lParam1, lParam2, lParam3: longint; str: string);
var
  i:    integer;
  pmsg: PTMessageInfoPtr;
begin
  csObjMsgLock.Enter;
  try
    i := 0;
    while True do begin
      if i >= MsgList.Count then
        break;
      if PTMessageInfoPtr(MsgList[i]).Ident = Ident then begin
        pmsg := PTMessageInfoPtr(MsgList[i]);
        MsgList.Delete(i);
        if pmsg.descptr <> nil then
          FreeMem(pmsg.descptr);
        Dispose(pmsg);
      end else
        Inc(i);
    end;
  finally
    csObjMsgLock.Leave;
  end;
  SendMsg(Sender, Ident, wparam, lParam1, lParam2, lParam3, str);
end;

function TCreature.GetMsg(var msg: TMessageInfo): boolean;
var
  pmsg: PTMessageInfoPtr;
  n:    integer;
begin
  Result := False;
  try
    csObjMsgLock.Enter;
    n := 0;
    msg.Ident := 0;
    while MsgList.Count > n do begin
      pmsg := MsgList[n];
      if pmsg.deliverytime <> 0 then begin
        if GetTickCount < pmsg.deliverytime then begin
          Inc(n);
          continue;
        end;
      end;
      MsgList.Delete(n);
      msg.Ident   := pmsg.Ident;
      msg.wparam  := pmsg.wparam;
      msg.lparam1 := pmsg.lparam1;
      msg.lparam2 := pmsg.lparam2;
      msg.lParam3 := pmsg.lparam3;
      msg.Sender  := pmsg.Sender;
      if pmsg.descptr <> nil then begin
        msg.Description := StrPas(pmsg.descptr);
        FreeMem(pmsg.descptr);
      end else
        msg.Description := '';
      Dispose(pmsg);
      Result := True;
      break;
    end;
  finally
    csObjMsgLock.Leave;
  end;
end;


function TCreature.GetMapCreatures(penv: TEnvirnoment; x, y, area: integer;
  rlist: TList): boolean;
var
  i, j, k, stx, sty, enx, eny: integer;
  cret:    TCreature;
  pm:      PTMapInfo;
  inrange: boolean;
begin
  Result := False;
  if rlist = nil then
    exit;
  try
    stx := x - area;
    enx := x + area;
    sty := y - area;
    eny := y + area;

    for i := stx to enx do begin
      for j := sty to eny do begin
        inrange := PEnvir.GetMapXY(i, j, pm);
        if inrange then begin
          if pm.ObjList <> nil then begin
            for k := pm.ObjList.Count - 1 downto 0 do begin
              //creature//
              if pm.ObjList[k] <> nil then begin
                if PTAThing(pm.ObjList[k]).Shape = OS_MOVINGOBJECT then begin
                  cret := TCreature(PTAThing(pm.ObjList[k]).AObject);
                  if cret <> nil then begin
                    if (not cret.BoGhost) then begin
                      rlist.Add(cret);
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage('[TCreature] GetMapCreatures exception');
  end;
  Result := True;
end;

// 대각선 방향의 맵에서 생물체 얻어내기.
function TCreature.GetObliqueMapCreatures(penv: TEnvirnoment;
  x, y, area, dir: integer; rlist: TList): boolean;
var
  i, j, k, stx, sty, enx, eny: integer;
  cret:    TCreature;
  pm:      PTMapInfo;
  inrange: boolean;
begin
  Result := False;
  if rlist = nil then
    exit;
  try
    case dir of
      1: begin
        stx := x - area - area;
        enx := x + area;
        sty := y - area;
        eny := y + area + area;
      end;
      3: begin
        stx := x - area - area;
        enx := x + area;
        sty := y - area - area;
        eny := y + area;
      end;
      5: begin
        stx := x - area;
        enx := x + area + area;
        sty := y - area - area;
        eny := y + area;
      end;
      7: begin
        stx := x - area;
        enx := x + area + area;
        sty := y - area;
        eny := y + area + area;
      end;
      else
        //방향이 대각선이 아닐때...
        exit;
    end;//case

    for i := stx to enx do begin
      for j := sty to eny do begin
        if ((dir in [3, 7]) and (abs((x - i) - (y - j)) <= area)) or
          ((dir in [1, 5]) and (abs((x - i) + (y - j)) <= area)) then begin
          inrange := PEnvir.GetMapXY(i, j, pm);
          if inrange then begin
            if pm.ObjList <> nil then begin
              for k := pm.ObjList.Count - 1 downto 0 do begin
                //creature//
                if pm.ObjList[k] <> nil then begin
                  if PTAThing(pm.ObjList[k]).Shape = OS_MOVINGOBJECT then begin
                    cret := TCreature(PTAThing(pm.ObjList[k]).AObject);
                    if cret <> nil then begin
                      if (not cret.BoGhost) then begin
                        rlist.Add(cret);
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage('[TCreature] GetObliqueMapCreatures exception');
  end;
  Result := True;
end;


{%%%%%%%%%%%%%%%%%%% *SendRefMsg* %%%%%%%%%%%%%%%%%%%%}

procedure TCreature.SendRefMsg(msg, wparam: word; lParam1, lParam2, lParam3: longint;
  str: string);
var
  i, j, k, stx, sty, enx, eny: integer;
  cret:    TCreature;
  pm:      PTMapInfo;
  inrange: boolean;
  objshape: byte;
begin
  if BoSuperviserMode or HideMode then begin
    exit;
  end;
  objshape := 0;

  //   csSendMsgLock.Enter;
  //   try
  if (GetTickCount - WatchTime >= 500) or (MsgTargetList.Count = 0) then begin
    WatchTime := GetTickCount;
    MsgTargetList.Clear;
    stx := CX - 12;
    enx := CX + 12;
    sty := CY - 12;
    eny := CY + 12;
    for i := stx to enx do begin
      for j := sty to eny do begin
        inrange := PEnvir.GetMapXY(i, j, pm);
        if inrange then begin
          if pm.ObjList <> nil then begin
            for k := pm.ObjList.Count - 1 downto 0 do begin
              //creature//
              if pm.ObjList[k] <> nil then begin

                try // 문제가 있는 메모리는 넘어가자..
                  objshape := PTAThing(pm.ObjList[k]).Shape;
                except
                  MainOutMessage(
                    '[Exception] Memory Check Error - SendRefMsg');
                  continue;
                end;

                if objshape = OS_MOVINGOBJECT then begin
                  if GetTickCount - PTAThing(pm.ObjList[k]).ATime >=
                    5 * 60 * 1000 then begin
                    //잔상 검사하여 지운다.
                    try // 2003-08-21 PDS - 메모리삭제시 에러난 경우
                      Dispose(PTAThing(pm.ObjList[k]));
                    except
                      MainOutMessage(
                        '[Exception] Dispose Error - SendRefMsg');
                    end;
                    pm.ObjList.Delete(k);
                    if pm.ObjList.Count <= 0 then begin
                      pm.ObjList.Free;
                      pm.ObjList := nil;
                      break;
                    end;
                  end else begin
                    try
                      cret := TCreature(PTAThing(pm.ObjList[k]).AObject);
                      if cret <> nil then begin
                        if (not cret.BoGhost) then begin
                          if cret.RaceServer = RC_USERHUMAN then begin
                            cret.SendMsg(self, msg,
                              wparam, lparam1, lparam2, lparam3, str);
                            MsgTargetList.AddObject('', cret);
                            //cashing..
                          end else begin
                            if cret.WantRefMsg then
                              if (msg = RM_STRUCK) or
                                (msg = RM_HEAR) or (msg = RM_DEATH) then begin
                                cret.SendMsg(self,
                                  msg, wparam, lparam1, lparam2, lparam3, str);
                                MsgTargetList.AddObject('', cret);
                                //cashing..
                              end;
                          end;
                        end;
                      end;
                    except
                      pm.ObjList.Delete(k);
                      if pm.ObjList.Count <= 0 then begin
                        pm.ObjList.Free;
                        pm.ObjList := nil;
                      end;
                      MainOutMessage('[Exception] TCreatre.SendRefMsg');
                      break;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end else begin
    if MsgTargetList.Count > 0 then
      for i := 0 to MsgTargetList.Count - 1 do begin
        cret := TCreature(MsgTargetList.Objects[i]);
        try

          if not cret.BoGhost then begin
            if (cret.MapName = self.MapName) and
              (Abs(cret.CX - self.CX) <= 11) and (Abs(cret.CY - self.CY) <= 11) then
            begin
              if cret.RaceServer = RC_USERHUMAN then begin
                cret.SendMsg(self, msg, wparam, lparam1,
                  lparam2, lparam3, str);
              end else begin
                if cret.WantRefMsg and ((msg = RM_STRUCK) or
                  (msg = RM_HEAR) or (msg = RM_DEATH)) then
                  cret.SendMsg(self, msg, wparam, lparam1,
                    lparam2, lparam3, str);
              end;
            end;
          end;

        except
          // 타겟리스트의 오브젝트가 깨진경우 삭제한다.
          // 메모리가 삭제된넘을 가지고 있을 경우도 있으니 메모리 삭제는 하지말고
          // 리스트에서만 삭제
          // 루프가 깨질수 있으니.. 그냥 Break 로 넘어가자 ( 메세지 전송이 안될수 있음. )
          // 2003-08-07 : PDS
          MainOutMessage('[Exception] TCreatre.SendRefMsg : Target Wrong :' +
            Self.UserName);
          MsgTargetList.Delete(i);
          break;
        end;

      end; // for end...
  end;
  //  finally
  //      csSendMsgLock.Leave;
  //  end;
end;

procedure TCreature.UpdateVisibleGay(cret: TCreature);
var
  i:    integer;
  flag: boolean;
  va:   PTVisibleActor;
begin
  flag := False;
  try
    for i := 0 to VisibleActors.Count - 1 do
      if cret = TCreature(PTVisibleActor(VisibleActors[i]).cret) then begin
        PTVisibleActor(VisibleActors[i]).check := 1;  //update
        flag := True;
        break;
      end;
  except
    MainOutMessage('[TCreature] UpdateVisibleGay exception');
  end;
  try
    if not flag then begin
      new(va);
      va.check := 2;
      va.cret  := cret;
      VisibleActors.Add(va);    // '2' : new
      // 2003/04/21 플레이어는 제외
      if (cret.RaceServer <> RC_USERHUMAN) and (not cret.Death) then
        // 2003/03/18
        Inc(cret.RefObjCount);
    end;
  except
    MainOutMessage('[TCreature] UpdateVisibleGay-2 exception');
  end;
end;

procedure TCreature.UpdateVisibleItems(xx, yy: word; pmi: PTMapItem);
var
  i:      integer;
  pvitem: PTVisibleItemInfo;
  flag:   boolean;
begin
  flag := False;
  for i := 0 to VisibleItems.Count - 1 do begin
    pvitem := PTVisibleItemInfo(VisibleItems[i]);
    if (pvitem.Id = longint(pmi)) then begin
      pvitem.check := 1; //update mark
      flag := True;
      break;
    end;
  end;
  if not flag then begin
    New(pvitem);
    pvitem.check := 2;  //new mark
    pvitem.x     := xx;
    pvitem.y     := yy;
    pvitem.Id    := longint(pmi);
    pvitem.Name  := pmi.Name;
    pvitem.looks := pmi.Looks;
    VisibleItems.Add(pvitem);
  end;
end;

procedure TCreature.UpdateVisibleEvents(xx, yy: integer; mevent: TObject);
var
  i:     integer;
  event: TEvent;
  flag:  boolean;
begin
  flag := False;
  for i := 0 to VisibleEvents.Count - 1 do begin
    event := TEvent(VisibleEvents[i]);
    if event = mevent then begin
      event.check := 1;  //update mark
      flag := True;
      break;
    end;
  end;
  if not flag then begin
    TEvent(mevent).check := 2; //new
    TEvent(mevent).X     := xx;
    TEvent(mevent).Y     := yy;
    VisibleEvents.Add(mevent);
  end;
end;

procedure TCreature.SearchViewRange;
var
  stx, enx, sty, eny, i, j, k, down: integer;
  rstx, renx, rsty, reny: integer;
  pm:      PTMapInfo;
  pvi:     PTVisibleItemInfo;
  pva:     PTVisibleActor;
  pmi:     PTMapEventInfo;
  pmapitem: PTMapItem;
  pd:      PTDoorInfo;
  event:   TEvent;
  cret:    TCreature;
  inrange: boolean;
  uname:   string;
  // 2004/04/21 AI 변경
  hmcount: integer;      // 시야내 사용자 케릭터의 수
  hmcheck: boolean;
  ObjShape: byte;
  pvacheck: integer;
  ps:      PTStdItem;
label
  err_exception;
begin
  down     := 0;
  objshape := 0;
  if PEnvir = nil then begin
    MainOutMessage('nil PEnvir');
    exit;
  end;

  stx := CX - ViewRange;
  enx := CX + ViewRange;
  sty := CY - ViewRange;
  eny := CY + ViewRange;

  // 2003/02/11 SearchView Optimize
  // 1. 일단 검색범위중 맵범위를 넘어가는 부분은 검색하지 않도록 한다...맵경계시에 이득
  if (stx < 0) then
    stx := 0;
  if (enx > PEnvir.MapWidth - 1) then
    enx := PEnvir.MapWidth - 1;
  if (sty < 0) then
    sty := 0;
  if (eny > PEnvir.MapHeight - 1) then
    eny := PEnvir.MapHeight - 1;

  // 2004/04/21 시야 범위 10번에 1번꼴로 전체화면으로 확대
  hmcount := 0;
  hmcheck := False;
{
   if RaceServer <> RC_USERHUMAN then begin
      if RefObjCount > 10 then begin
         hmcheck := TRUE;
         RefObjCount := 1;
         // 시야범위 확대
         rstx := stx;   stx := CX-12;
         renx := enx;   enx := CX+12;
         rsty := sty;   sty := CY-12;
         reny := eny;   eny := CY+12;
         if(stx < 0) then stx := 0;
         if(enx > PEnvir.MapWidth-1)  then enx := PEnvir.MapWidth-1;
         if(sty < 0) then sty := 0;
         if(eny > PEnvir.MapHeight-1) then eny := PEnvir.MapHeight-1;
      end else
         Inc(RefObjCount);
   end;
}
  try
    for i := 0 to VisibleItems.Count - 1 do
      PTVisibleItemInfo(VisibleItems[i]).Check := 0;    //'0' -> mark
    for i := 0 to VisibleEvents.Count - 1 do
      TEvent(VisibleEvents[i]).Check := 0;    //'0' -> mark
    // 2004/04/21 시야 범위 확대검색시에는 초기화 및 추가하지 않음
    if not hmcheck then
      for i := 0 to VisibleActors.Count - 1 do
        PTVisibleActor(VisibleActors[i]).Check := 0;
  except
    MainOutMessage('ObjBase SearchViewRange 0');
    KickException;
  end;

  try
    for i := stx to enx do begin
      for j := sty to eny do begin
        inrange := PEnvir.GetMapXY(i, j, pm);
        if inrange then begin
          if pm.ObjList <> nil then begin
            down := 1;
            k    := 0;
            while True do begin
              if k >= pm.ObjList.Count then
                break; //-1 do begin //downto 0 do begin
              if pm.ObjList[k] <> nil then begin
                // Check Object wrong Memory 2003-09-15 PDS
                try
                  // 메모리에서 에러가 있으면 익셉션 걸리구
                  ObjShape := PTAThing(pm.ObjList[k]).Shape;
                except
                  // 오브젝트에서 빼버리자.
                  MainOutMessage('DELOBJ-WRONG MEMORY:' +
                    MapName + ',' + IntToStr(CX) + ',' + IntToStr(CY));
                  pm.ObjList.Delete(k);
                  continue;
                end;
                {creature}
                if ObjShape = OS_MOVINGOBJECT then begin

                  // 잔상 검사하여 지운다.
                  // 2003/01/22 시간 5분에서 10분으로 변경...NPC 깜박임 방지
                  if GetTickCount - PTAThing(pm.ObjList[k]).ATime >=
                    10 * 60 * 1000 then begin
                    try
                      Dispose(PTAThing(pm.ObjList[k]));
                    finally
                      pm.ObjList.Delete(k);
                    end;

                    down := 2;
                    if pm.ObjList.Count <= 0 then begin
                      down := 3;
                      pm.ObjList.Free;
                      pm.ObjList := nil;
                      break;
                    end;
                    continue;

                  end;

                  cret := TCreature(PTAThing(pm.ObjList[k]).AObject);
                  down := 4;
                  if (cret <> nil) and (not cret.BoGhost) and
                    (not cret.HideMode) and
                    (not cret.BoSuperviserMode) then begin
                    down := 5;
                    //몬스터는 제외 시킨다.
                    if (RaceServer < RC_ANIMAL) or   //몹이 아니거나
                      (Master <> nil) or            //주인이 있거나
                      (BoCrazyMode) or              //폭주상태거나
                      (BoGoodCrazyMode) or            //곱게미친상태거나
                      (WantRefMsg) or               //메세지가 필요함
                      ((cret.Master <> nil) and
                      (abs(cret.CX - CX) <= 3) and (abs(cret.CY - CY) <= 3)) or
                      //주인있는 몹은 다 본다.(사람처럼 간주)
                      (cret.RaceServer = RC_USERHUMAN)  //사람은 다 본다
                      // 2004/04/21 확대시야 검사중에는 추가하지 않는다
                      and (not hmcheck) then
                      UpdateVisibleGay(cret);
                    if cret.RaceServer = RC_USERHUMAN then
                      Inc(hmcount);
                  end;
                end;

                if RaceServer = RC_USERHUMAN then begin

                  {item}
                  down := 6;
                  if PTAThing(pm.ObjList[k]).Shape = OS_ITEMOBJECT then begin
                    down := 7;
                    if GetTickCount - PTAThing(pm.ObjList[k]).ATime >
                      60 * 60 * 1000 then begin
                      //장원꾸미기 아이템은 건드리지 않는다.
                      pmapitem :=
                        PTMapItem(PTAThing(pm.ObjList[k]).AObject);
                      ps := UserEngine.GetStdItem(pmapitem.UserItem.Index);
                      if ps <> nil then begin
                        if (ps.StdMode = STDMODE_OF_DECOITEM) and
                          (ps.Shape = SHAPE_OF_DECOITEM) then begin
                          if pmapitem <> nil then begin
                            UpdateVisibleItems(i, j, pmapitem);
                            //다음 아이템으로 넘어감...
                            Inc(k);
                            continue;
                          end;
                        end;
                      end;

                      //버린지 1시간이 지난건 없앤다. -PDS 잘못될 가능성 있음
                      // Dispose (PTMapItem (PTAThing (pm.ObjList[k]).AObject));

                      Dispose(PTAThing(pm.ObjList[k]));
                      pm.ObjList.Delete(k);
                      down := 8;
                      if pm.ObjList.Count <= 0 then begin
                        down := 9;
                        pm.ObjList.Free;
                        pm.ObjList := nil;
                        break;
                      end;
                      continue;
                    end else begin
                      down     := 10;
                      pmapitem :=
                        PTMapItem(PTAThing(pm.ObjList[k]).AObject);
                      if pmapitem <> nil then begin
                        UpdateVisibleItems(i, j, pmapitem);
                        if (pmapitem.Ownership <> nil) or
                          (pmapitem.Droper <> nil) then begin
                          if GetTickCount - pmapitem.Droptime >
                            ANTI_MUKJA_DELAY then begin
                            pmapitem.Ownership := nil;
                            pmapitem.Droper    := nil;
                          end else begin
                            //{주의} 먹자 보호 시간이 5분(죽은 캐릭 free 유예시간)을 초과하면
                            //이 부분에서 버그가 발생한다.
                            if pmapitem.Ownership <> nil then
                              if TCreature(
                                pmapitem.Ownership).BoGhost then
                                pmapitem.Ownership := nil;
                            if pmapitem.Droper <> nil then
                              if TCreature(pmapitem.Droper).BoGhost then
                                pmapitem.Droper := nil;
                          end;
                        end;
                      end;
                    end;
                  end;

                  {event}
                  down := 11;
                  if PTAThing(pm.ObjList[k]).Shape = OS_EVENTOBJECT then begin
                    event := TEvent(PTAThing(pm.ObjList[k]).AObject);
                    if event.Visible then
                      UpdateVisibleEvents(i, j, TObject(event));
                  end;
                end;
              end;

              Inc(k);

            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(UserName + ' ' + MapName + ',' + IntToStr(CX) +
      ',' + IntToStr(CY) + ' SearchViewRange 1-' + IntToStr(down));
    KickException;
  end;

  try
    i := 0;
    while True do begin
      if i >= VisibleActors.Count then
        break;
      pva := PTVisibleActor(VisibleActors[i]);

      try // 메모리 체크 2003-09-23 PDS
        pvacheck := pva.check;
      except
        VisibleActors.Delete(i);
        MainOutMessage('DELOBJ-WRONG2 MEMORY:' + MapName + ',' +
          IntToStr(CX) + ',' + IntToStr(CY));
        continue;
      end;

      if pva.check = 0 then begin
        if RaceServer = RC_USERHUMAN then begin
          cret := TCreature(pva.cret);
          if (Assigned(cret)) then begin
            if not cret.HideMode then
              //HideMode인 것은 RM_DIGDOWN 메세지를 보낸다....
              SendMsg(cret, RM_DISAPPEAR, 0, 0, 0, 0, '');
            // 2003/03/18
            // 2003/04/01 한번 활성화된 몹의 경우 SearchViewRange 내에서는 감소시키지 않는다
            // 2003/04/21
            //                cret.DecRefObjCount;
            //                SendMsg (cret, RM_DECREFOBJCOUNT, 0, 0, 0, 0, '');
          end;
        end;
        VisibleActors.Delete(i);
        Dispose(pva);
        continue;
      end else begin
        if RaceServer = RC_USERHUMAN then begin
          if pva.check = 2 then begin // new enterance creature
            cret := TCreature(pva.cret);
            if cret <> self then begin
              if cret.Death then begin
                if cret.BoSkeleton then
                  SendMsg(cret, RM_SKELETON, cret.Dir, cret.CX, cret.CY, 0, '')
                else
                  SendMsg(cret, RM_DEATH, cret.Dir, cret.CX, cret.CY, 0, '');
              end else begin
                uname := cret.GetUserName;
                SendMsg(cret, RM_TURN, cret.Dir, cret.CX, cret.CY, 0, uname);
                //처음보는 캐릭인 경우
              end;
              //SendMsg (cret, RM_USERNAME, 0, 0, 0, 0, cret.UserName);
            end;
          end;
        end;
      end;
      Inc(i);
    end;
  except
    MainOutMessage(MapName + ',' + IntToStr(CX) + ',' + IntToStr(CY) +
      ' SearchViewRange 2');
    KickException;
  end;

  try
    if RaceServer = RC_USERHUMAN then begin  // 사용자 한테만 전달
      i := 0;
      while True do begin
        if i >= VisibleItems.Count then
          break;
        if PTVisibleItemInfo(VisibleItems[i]).check = 0 then begin //사라짐
          pvi := PTVisibleItemInfo(VisibleItems[i]);
          SendMsg(self, RM_ITEMHIDE, 0, pvi.Id, pvi.x, pvi.y, '');
          VisibleItems.Delete(i);
          Dispose(pvi);
        end else begin
          if PTVisibleItemInfo(VisibleItems[i]).check = 2 then
          begin // new visible item
            pvi := PTVisibleItemInfo(VisibleItems[i]);
            SendMsg(self, RM_ITEMSHOW, pvi.looks, pvi.Id, pvi.x, pvi.y, pvi.Name);
          end;
          Inc(i);
        end;
      end;

      i := 0;
      while True do begin
        if i >= VisibleEvents.Count then
          break;
        event := TEvent(VisibleEvents[i]);
        if event.Check = 0 then begin
          SendMsg(self, RM_HIDEEVENT, 0, integer(event), event.X, event.Y, '');
          VisibleEvents.Delete(i);
          continue;
        end else begin
          if event.Check = 2 then begin
            SendMsg(self, RM_SHOWEVENT, event.EventType,
              integer(event), MakeLong(event.x, event.EventParam), event.y, '');
          end;
        end;
        Inc(i);
      end;
    end;
  except
    MainOutMessage(MapName + ',' + IntToStr(CX) + ',' + IntToStr(CY) +
      ' SearchViewRange 3');
    KickException;
  end;

end;

function TCreature.Feature: integer;
begin
  Result := GetRelFeature(nil);
end;

function TCreature.GetRelFeature(who: TCreature): integer;
var
  dress, weapon, face, r, a: integer;
  ps: PTStdItem;
  booldversion: boolean;
begin
  if RaceServer = RC_USERHUMAN then begin
    dress := 0;
    if UseItems[U_DRESS].Index > 0 then begin
      ps := UserEngine.GetStdItem(UseItems[U_DRESS].Index);
      if ps <> nil then begin
        dress := ps.Shape * 2;  //남자옷 여자옷이 따로 있음
      end;
    end;
    dress  := dress + Sex;
    weapon := 0;
    if UseItems[U_WEAPON].Index > 0 then begin
      ps := UserEngine.GetStdItem(UseItems[U_WEAPON].Index);
      if ps <> nil then begin
        weapon := ps.Shape * 2;
      end;
    end;
    weapon := weapon + Sex;
    face   := Hair * 2 + Sex;
    Result := MakeFeature(0, Dress, Weapon, Face);
  end else begin
    booldversion := False;
    // 2003/02/11 쓸모없는 로직 삭제...
{
      if who <> nil then begin
         if who.BoOldVersionUser_Italy then
            booldversion := TRUE;
      end;
      if booldversion then begin
         //이탈리아서버 이전 버젼 사용자 접속이 가능하도록
         r := RaceImage;
         a := Appearance;
         case a of
            160: //닭
               begin
                  r := 10;
                  a := 0;
               end;
            161: //사슴
               begin
                  r := 10;
                  a := 1;
               end;
            163: //침거미
               begin
                  r := 11;
                  a := 3;
               end;
            0: //경비병
               begin
                  r := 12;
                  a := 5;
               end;
            162: //욥
               begin
                  r := 11;
                  a := 6;
               end;
            1: //뭉코
               begin
                  r := 11;
                  a := 9;
               end;
         end;
         Result := MakeFeatureAp (r, DeathState, a);
      end else
}

    if (RaceServer = RC_CLONE) then // 분신이면 사람의 모습을 내려줌
    begin
      Result := MasterFeature;
    end else begin
      Result := MakeFeatureAp(RaceImage, DeathState, Appearance);
    end;
  end;
end;

function TCreature.GetCharStatus: integer;
var
  i, s: integer;
begin
  s := 0;
  for i := 0 to STATUSARR_SIZE - 1 do begin
    if StatusArr[i] > 0 then
      s := longword(s) or ($80000000 shr i);
  end;
  Result := s or (CharStatusEx and $0000FFFF); // sonmg 수정(2004/03/29)
end;

procedure TCreature.InitValues;
begin
  //능력치
  WAbil := Abil;
end;

procedure TCreature.Initialize;
var
  i, n: integer;
begin
  InitValues;
  //마법 검사
  for i := 0 to MagicList.Count - 1 do begin
    n := PTUserMagic(MagicList[i]).Level;
    if not (n in [0..3]) then
      PTUserMagic(MagicList[i]).Level := 0;
  end;
  //맵에 등장
  ErrorOnInit := True;
  if PEnvir.CanWalk(CX, CY, True{겹침허용}) then begin
    if Appear then begin
      ErrorOnInit := False;
    end;
  end;
  CharStatus := GetCharStatus;
  AddBodyLuck(0);
end;

procedure TCreature.Finalize;
begin

end;

function TCreature.GetMasterRace: integer; //주인이 어떤 종족인지 얻는다.
begin
  Result := -1;  // 주인이 없음

  if Master <> nil then begin
    // 주인이 있으면 종족 번호를 리턴함.
    Result := Master.RaceServer;
  end;
end;

procedure TCreature.FeatureChanged;
begin
  SendRefMsg(RM_FEATURECHANGED, 0, Feature, 0, 0, '');
end;

procedure TCreature.CharStatusChanged;
begin
  SendRefMsg(RM_CHARSTATUSCHANGED, HitSpeed{wparam}, CharStatus, 0, 0, '');
end;

function TCreature.Appear: boolean;
var
  outofrange: pointer;
begin
  outofrange := PEnvir.AddToMap(CX, CY, OS_MOVINGOBJECT, self);
  if outofrange = nil then begin
    Result := False;
  end else
    Result := True;
  if not HideMode then
    SendRefMsg(RM_TURN, Dir, CX, CY, 0, '');
  //레벨에 맞게 입장할 수 있는 맵인지 체크 해야 함
end;

function TCreature.Disappear(num: integer): boolean;
var
  rtn: integer;
begin
  // 서버간 이동시에는 먼저 사라지기 때문에.. 또다시 불리지 않게 처리한다.
  // 2003-09-25
  if FAlreadyDisapper then begin
    Result := True;
    Exit;
  end;

  rtn := PEnvir.DeleteFromMap(CX, CY, OS_MOVINGOBJECT, self);
  if rtn <> 1 then begin
    MainOutMessage('DeleteFromMapError[' + IntToStr(Rtn) + ']' +
      PEnvir.MapName + ',' + IntToStr(CX) + ',' + IntToStr(CY) + ':' + IntToStr(num));
    Result := False;
  end else begin
    SendRefMsg(RM_DISAPPEAR, 0, 0, 0, 0, '');
    Result := True;
  end;
end;

procedure TCreature.KickException;
var
  hum: TUserHuman;
begin
  if RaceServer = RC_USERHUMAN then begin
    MapName := HomeMap;
    CX      := HomeX;
    CY      := HomeY;
    hum     := TUserHuman(self);
    hum.EmergencyClose := True;
  end else begin
    Death     := True;
    DeathTime := GetTickCount;
    MakeGhost(3);
  end;
end;

 // mode = 0  walk
 //        1  run
function TCreature.Walk(msg: integer): boolean;
var
  i:      integer;
  pm:     PTMapInfo;
  pat:    PTAThing;
  pgate:  PTGateInfo;
  inrange: boolean;
  newenv: TEnvirnoment;
  newmap: string;
  hum:    TUserHuman;
  event:  TEvent;
  down:   integer;
label
  needholefinish;
begin
  Result := True;
  down   := 0;
  try
    inrange := PEnvir.GetMapXY(CX, CY, pm);
    pgate   := nil;
    event   := nil;
    if inrange then begin
      down := 1;
      if pm.ObjList <> nil then begin
        down := 2;
        for i := 0 to pm.ObjList.Count - 1 do begin
          down := 3;
          pat  := pm.ObjList[i];
          if pat.Shape = OS_GATEOBJECT then begin
            down  := 4;
            pgate := PTGateInfo(pat.AObject);
          end;
          if pat.Shape = OS_EVENTOBJECT then begin
            down := 5;
            if TEvent(pat.AObject).OwnCret <> nil then
              event := TEvent(pat.AObject);
            continue;
          end;
          if pat.Shape = OS_MAPEVENT then begin
            {???}
          end;
          if pat.Shape = OS_DOOR then begin
          end;
          if pat.Shape = OS_ROON then begin
            //   proon := PTRoonInfo (pat.AObject);
          end;

        end;
      end;
    end;

    down := 10;
    if event <> nil then begin
      down := 11;
      if event.OwnCret.IsProperTarget(self) then begin
        down := 12;
        SendMsg(event.OwnCret, RM_MAGSTRUCK_MINE, 0, event.Damage, 0, 0, '');
      end;
    end;

    down := 20;
    if Result and (pgate <> nil) then begin
      down := 21;
      if RaceServer = RC_USERHUMAN then begin //npc 는 문밖으로 안 나감
        if PEnvir.AroundDoorOpened(CX, CY) then begin
          //구울의방 인경우, 좀비가 나온 구멍이 있어야 들어 간다.
          if TEnvirnoment(pgate.EnterEnvir).NeedHole then begin
            if EventMan.FindEvent(PEnvir, CX, CY, ET_DIGOUTZOMBI) = nil then
              goto needholefinish;
          end;
          if ServerIndex = TEnvirnoment(pgate.EnterEnvir).Server then begin
            if not EnterAnotherMap(TEnvirnoment(pgate.EnterEnvir),
              pgate.EnterX, pgate.EnterY) then
              Result := False;
          end else begin
            hum := TUserHuman(self);
            if GetTickCount - hum.LatestDropTime > 1000 then begin
              //서버 이동 check disappear
              if Disappear(1) = True then begin
                SpaceMoved := True;
                hum := TUserHuman(self);
                hum.ChangeMapName := TEnvirnoment(pgate.EnterEnvir).MapName;
                hum.ChangeCX := pgate.EnterX;
                hum.ChangeCY := pgate.EnterY;
                hum.BoChangeServer := True;
                hum.ChangeToServerNumber :=
                  TEnvirnoment(pgate.EnterEnvir).Server;
                //UserEngine.UserServerChange (hum, TEnvirnoment(pgate.EnterEnvir).Server);
                hum.EmergencyClose := True;
                hum.SoftClosed := True;  //Certifycation을 만료시키지 않는다.
                hum.FAlreadyDisapper := True;
              end else
                Result := False;
            end else begin
              Result := False;
            end;

          end;
          needholefinish: ;
        end; //문이 잠김 Result=true 정상
      end else
        Result := False; // npc가 문을 막는것을 방지하기 위해서
    end else begin
      down := 22;
      if Result then
        SendRefMsg(msg, Dir, CX, CY, 0, '');
    end;
  except
    MainOutMessage('[TCreature] Walk exception ' + MapName + ' ' +
      IntToStr(CX) + ':' + IntToStr(CY) + '>' + IntToStr(down));
  end;
end;

function TCreature.EnterAnotherMap(enterenvir: TEnvirnoment;
  enterx, entery: integer): boolean;
var
  i, oldx, oldy: integer;
  pm: PTMapInfo;
  oldpenvir: TEnvirnoment;
begin
  Result := False;

  if enterenvir = nil then begin
    MainOutMessage('ERROR! EnterAnotherMap Enviroment is NIL');
    exit;
  end;

  try
    //1) 들어 갈 수 있는지, 적합한지
    if Abil.Level < enterenvir.NeedLevel then
      exit;

    if enterenvir.MapQuest <> nil then begin
      TMerchant(enterenvir.MapQuest).UserCall(self);
    end;

    if enterenvir.NeedSetNumber >= 0 then begin
      if GetQuestMark(enterenvir.NeedSetNumber) <> enterenvir.NeedSetValue then
        exit;
    end;

    if not enterenvir.GetMapXY(enterx, entery, pm) then
      exit;

    if enterenvir = UserCastle.CorePEnvir then begin //사북성의 내성인 경우
      if RaceServer = RC_USERHUMAN then
        if not UserCastle.CanEnteranceCoreCastle(CX, CY, TUserHuman(self)) then
          exit;  //들어갈 수 없음.
    end;

    oldpenvir := PEnvir;
    oldx      := CX;
    oldy      := CY;

    //2) 지금 맵에서 떠남, 변수 초기화
    // 만약 사라지지 않는다면 그냥 나간다.
    // if Disappear(2) = false then   Exit;
    Disappear(2);

    try
      MsgTargetList.Clear;
    except
      MainOutMessage('[Exception] MsgTargetList.Clear');
    end;
    try
      for i := 0 to VisibleItems.Count - 1 do
        Dispose(PTVisibleItemInfo(VisibleItems[i]));
    except
      MainOutMessage('[Exception] VisbleItems Dispose(..)');
    end;
    try
      VisibleItems.Clear;
    except
      MainOutMessage('[Exception] VisbleItems.Clear');
    end;
    try
      VisibleEvents.Clear;
    except
      MainOutMessage('[Exception] VisbleEvents.Clear');
    end;
    // 2003/03/18
    try
      i := 0;
      while True do begin
        if i >= VisibleActors.Count then
          break;
            {
            if RaceServer = RC_USERHUMAN then begin
            try
               if(PTVisibleActor(VisibleActors[i]).cret <> nil) then
                  TCreature (PTVisibleActor(VisibleActors[i]).cret).DecRefObjCount;
            except
               MainOutMessage ('[Exception] TCreatre.Destroy : Visible Actor Dec RefObjCount');
            end;
            end;
            }
        Dispose(PTVisibleActor(VisibleActors[i]));
        VisibleActors.Delete(i);
        //          Inc(i);
      end;
    except
      MainOutMessage('[Exception] VisbleActors Dispose(..)');
    end;
    try
      VisibleActors.Clear;
    except
      MainOutMessage('[Exception] VisbleActors.Clear');
    end;

    SendMsg(self, RM_CLEAROBJECTS, 0, 0, 0, 0, '');

    //3) 새맵에 등장
    PEnvir  := enterenvir;
    MapName := enterenvir.MapName;
    CX      := enterx;
    CY      := entery;
    SendMsg(self, RM_CHANGEMAP, 0, 0, 0, 0, enterenvir.GetGuildAgitRealMapName);

    if Appear then begin
      MapMoveTime := GetTickCount;
      SpaceMoved  := True; //WalkTo가 실패하지 않게 하려고..
      Result      := True;
    end else begin
      MapName := oldpenvir.MapName;
      PEnvir  := oldpenvir;   //샐패한경우
      CX      := oldx;
      CY      := oldy;
      if (nil = PEnvir.AddToMap(CX, CY, OS_MOVINGOBJECT, self)) then begin
        MainOutMessage('ERROR NOT ADDTOMAP EnterAnotherMap:' +
          MapName + ',' + IntToStr(CX) + ',' + IntToStr(CY));
      end;
    end;

    //문파대전장을 들어가거나 나갈 때
    if PEnvir.Fight3Zone and (PEnvir.Fight3Zone <> oldpenvir.Fight3Zone) then
      UserNameChanged;  //이름 색 변경

  except
    MainOutMessage('[TCreature] EnterAnotherMap exception');
  end;
end;

procedure TCreature.Turn(dir: byte);
begin
  self.Dir := dir;
  SendRefMsg(RM_TURN, Dir, CX, CY, 0, '');
end;

procedure TCreature.Say(saystr: string);
begin
  SendRefMsg(RM_HEAR, 0, clBlack, clWhite, 0, UserName + ': ' + saystr);
end;

procedure TCreature.SysMsg(str: string; mode: integer);
begin
  if RaceServer <> RC_USERHUMAN then begin
    //몬스터에게도 시스템 메시지가 전송되는 것을 막음(sonmg 2005/01/24)
    //      MainOutMessage('TCreature.SysMsg : not Human ' + IntToStr(RaceServer) + ', ' + IntToStr(mode) );
    exit;
  end;

  case mode of
    1: SendMsg(self, RM_SYSMESSAGE2, 0, 0, 0, 0, str);
    2: SendMsg(self, RM_SYSMSG_BLUE, 0, 0, 0, 0, str);
    3: SendMsg(self, RM_SYSMESSAGE3, 0, 0, 0, 0, str);
    4: SendMsg(self, RM_SYSMSG_REMARK, 0, 0, 0, 0, str);
    5: SendMsg(self, RM_SYSMSG_PINK, 0, 0, 0, 0, str);
    6: SendMsg(self, RM_SYSMSG_GREEN, 0, 0, 0, 0, str);
    else
      SendMsg(self, RM_SYSMESSAGE, 0, 0, 0, 0, str);
  end;
end;

procedure TCreature.BoxMsg(str: string; mode: integer);
begin
  if RaceServer <> RC_USERHUMAN then begin
    //몬스터에게는 메시지를 전송하지 않는다.(sonmg 2005/01/24)
    MainOutMessage('TCreature.BoxMsg : not Human');
    exit;
  end;

  SendMsg(self, RM_MENU_OK, 0, integer(self), 0, 0, str);
end;

procedure TCreature.GroupMsg(str: string);
var
  i: integer;
begin
  if GroupOwner <> nil then begin
    for i := 0 to GroupOwner.GroupMembers.Count - 1 do begin
      TCreature(GroupOwner.GroupMembers.Objects[i]).SendMsg(self,
        RM_GROUPMESSAGE, 0, 0, 0, 0, '-' + str);
    end;
  end;
end;

procedure TCreature.NilMsg(str: string);
begin
  SendMsg(nil, RM_HEAR, 0, 0, 0, 0, str);
end;

procedure TCreature.MakeGhost(num: integer);     //완전히 죽음, 사라질 예정
begin
  BoGhost   := True;
  GhostTime := GetTickCount;
  if Disappear(3) = False then begin
    MainOutMessage('Not MakeGhost: ' + self.UserName + ',' + self.MapName +
      ',' + IntToStr(self.cx) + ',' + IntToStr(self.cy) + ':' + IntToStr(num));
  end else begin
    self.FAlreadyDisapper := True;
  end;
end;

procedure TCreature.ApplyMeatQuality;  //동물(사슴)인 경우 고기품질..
var
  i:    integer;
  pstd: PTStdItem;
begin
  for i := 0 to ItemList.Count - 1 do begin
    pstd := UserEngine.GetStdItem(PTUserItem(ItemList[i]).Index);
    if pstd <> nil then begin
      if pstd.Stdmode = 40 then begin //고기덩어리인 경우
        PTUserItem(ItemList[i]).Dura := MeatQuality;
      end;
    end;
  end;
end;

//대상이 몬스터에게만 사용함
function TCreature.TakeCretBagItems(target: TCreature): boolean;
  //상대방의 가방에 물건을 모두 빼앗다.
var
  i:   integer;
  hum: TUserHuman;
  ps:  PTStdItem;
  IsAddNew: boolean;
begin
  Result := False;
  while True do begin
    if target.ItemList.Count <= 0 then
      break;

    ps := UserEngine.GetStdItem(PTUserItem(target.ItemList[0]).Index);
    //pu.Index);   // gadget: 카운트아이템
    if ps <> nil then begin
      IsAddNew := True;
      if ps.OverlapItem >= 1 then begin
        if PTUserItem(target.ItemList[0]).Dura > 0 then begin
          if UserCounterItemAdd(ps.StdMode, ps.Looks,
            PTUserItem(target.ItemList[0]).Dura, ps.Name, False) then begin
            IsAddNew := False;
            target.ItemList.Delete(0);
            Result := True;
          end;
        end else begin
          PTUserItem(target.ItemList[0]).Dura := 1; //sonmg
        end;
      end;
      if IsAddNew then begin
        if AddItem(PTUserItem(target.ItemList[0])) then begin
          if RaceServer = RC_USERHUMAN then begin
            if self is TUserHuman then begin
              hum := TUserHuman(self);
              TUserHuman(hum).SendAddItem(PTUserItem(target.ItemList[0])^);
              Result := True;
            end;
          end;
          target.ItemList.Delete(0);
        end else
          break;
      end;
    end else
      break;
  end;
end;

 //죽어서 가방에 아이템을 흘림.. 전부 흘린다.
 //itemownershiop : 아이템을 먹을 수 있는 사람, 몬스터에서 흘렸을 경우에만 적용된다.
 //                 몬스터의 아이템을 줒었는지 확인하는 용도로 사용된다.
procedure TCreature.ScatterBagItems(itemownership: TObject);
var
  i, dropwide: integer;
  drcount, icount: integer;
  pu, newpu: PTUserItem;
  pstd:      PTStdItem;
  dellist:   TStringList;
  boDropall: boolean;
begin
  dellist := nil;

  if DontBagItemDrop then begin
    DontBagItemDrop := False;
    Exit;
  end;

  boDropall := True;
  if RaceServer = RC_USERHUMAN then begin
    dropwide := 2;
    if PKLevel < 2 then
      boDropall := False; //사람은 1/3확률로 떨군다.
    //빨갱이는 다 떨군다.
  end else
    dropwide := 3;

  try
    for i := ItemList.Count - 1 downto 0 do begin
      pu   := PTUserItem(ItemList[i]);
      pstd := UserEngine.GetStdItem(pu.Index);

      if pstd = nil then
        continue;
      //죽었을때 상현주머니는 안떨구게...(sonmg 2004/08/09)
      if (pstd.StdMode = STDMODE_OF_DECOITEM) and
        (pstd.Shape = SHAPE_OF_DECOITEM) then
        continue;
      if (RaceServer = RC_USERHUMAN) and ((pstd.UniqueItem and $04) <> 0) then
        continue;
      //UNIQUEITEM 필드가 00000100(2진수)를 포함하면 떨굴 수 없는 아이템(sonmg 2005/03/14)

      //대만 요청으로 만든 부분,
      //stdmode = 51번은 죽을때 반드시 떨어짐... 또한 접속끊었을때 도 떨어짐
      if BoTaiwanEventUser then begin
        //대만 이벤트,  이벤트 유저가 죽었을때는 이벤트 아이템만 떨어진다.
        //다른 아이템은 떨어지지 않는다.
        if (pstd.StdMode = TAIWANEVENTITEM) then begin
          if DropItemDown(PTUserItem(ItemList[i])^, dropwide,
            True, itemownership, self, 0) then begin
            //                  pu := PTUserItem(ItemList[i]);
            if RaceServer = RC_USERHUMAN then begin
              if dellist = nil then
                dellist := TStringList.Create;
              //떨어뜨린 아이템을 클라이언트에 알림.
              dellist.AddObject(UserEngine.GetStdItemName(pu.Index),
                TObject(pu.MakeIndex));
            end;
            Dispose(PTUserItem(ItemList[i]));
            ItemList.Delete(i);
          end;
        end;
      end else begin
        if (PHILIPPINEVERSION and (Random(6) = 0)) or
          (not PHILIPPINEVERSION and (Random(3) = 0)) or boDropall then begin
          //갯수 아이템인 경우 일부만 떨어짐
          if pstd.OverlapItem >= 1 then begin
            icount  := pu.Dura;
            drcount := _MAX(1, Random(icount div 2));  //절대로 다 떨어지지 않음
            icount  := _MAX(0, icount - drcount);      //수정(sonmg)
            if drcount > 0 then begin
              new(newpu);
              if UserEngine.CopyToUserItemFromName(pstd.Name, newpu^) then begin
                newpu.Dura := drcount;

                if DropItemDown(newpu^, dropwide, True,
                  itemownership, self, 0) then begin
                  pu.Dura := icount;

                  if pu.Dura <= 0 then begin
                    pu := PTUserItem(ItemList[i]);
                    if RaceServer = RC_USERHUMAN then begin
                      if dellist = nil then
                        dellist := TStringList.Create;
                      //남은개수 0인 아이템을 지우기 위해 클라이언트에 알림.
                      dellist.AddObject(UserEngine.GetStdItemName(pu.Index),
                        TObject(pu.MakeIndex));
                    end;
                    Dispose(PTUserItem(ItemList[i]));
                    ItemList.Delete(i);
                  end else begin
                    SendMsg(self, RM_COUNTERITEMCHANGE, 0,
                      pu.MakeIndex, pu.Dura, 0, pstd.Name);
                  end;
                end;
              end;

              if newpu <> nil then
                Dispose(newpu);   // Memory Leak sonmg
            end;
          end else begin
            // 몬스터 드롭 광석 순도 조절.
            pu := PTUserItem(ItemList[i]);
            if RaceServer <> RC_USERHUMAN then begin
              if pstd.StdMode = 43 then begin
                pu.Dura := GetPurity;
              end;
            end;

            if DropItemDown(pu^, dropwide, True, itemownership, self, 0) then begin
              //                     pu := PTUserItem(ItemList[i]);
              if RaceServer = RC_USERHUMAN then begin
                if dellist = nil then
                  dellist := TStringList.Create;
                //떨어뜨린 아이템을 클라이언트에 알림.
                dellist.AddObject(UserEngine.GetStdItemName(pu.Index),
                  TObject(pu.MakeIndex));
              end;
              Dispose(PTUserItem(ItemList[i]));
              ItemList.Delete(i);
            end;
          end;
        end;
      end;
    end;
    if dellist <> nil then begin
      SendMsg(self, RM_DELITEMS, 0, integer(dellist), 0, 0, '');
      //dellist는 rm_delitem에서 free 시켜야 한다.
    end;
  except
    MainOutMessage('[Exception] TCreature.ScatterBagItems');
  end;
end;

procedure TCreature.DropEventItems;
//이벤트 아이템이 떨어지더라도 캐릭 색은 여기서 바꾸지 않는다.
var
  i, dropwide: integer;
  pu:      PTUserItem;
  pstd:    PTStdItem;
  dellist: TStringList;
begin
  dellist  := nil;
  dropwide := 3;
  try
    for i := ItemList.Count - 1 downto 0 do begin
      pstd := UserEngine.GetStdItem(PTUserItem(ItemList[i]).Index);
      //대만 요청으로 만든 부분,
      //stdmode = 51번은 죽을때 반드시 떨어짐... 또한 접속끊었을때 도 떨어짐
      if pstd <> nil then begin
        if (pstd.StdMode = TAIWANEVENTITEM) then begin
          if DropItemDown(PTUserItem(ItemList[i])^, dropwide,
            True, nil, self, 0) then begin
            //이때 떨어진 아이템은 주인 없는 아이템 임
            pu := PTUserItem(ItemList[i]);
            if RaceServer = RC_USERHUMAN then begin
              if dellist = nil then
                dellist := TStringList.Create;
              //떨어뜨린 아이템을 클라이언트에 알림.
              dellist.AddObject(UserEngine.GetStdItemName(pu.Index),
                TObject(pu.MakeIndex));
            end;
            Dispose(PTUserItem(ItemList[i]));
            ItemList.Delete(i);
          end;
        end;
      end;
    end;
    if dellist <> nil then begin
      SendMsg(self, RM_DELITEMS, 0, integer(dellist), 0, 0, '');
      //dellist는 rm_delitem에서 free 시켜야 한다.
    end;
  except
    MainOutMessage('[Exception] TCreature.DropEventItems');
  end;
end;

procedure TCreature.ScatterGolds(itemownership: TObject);
const
  dropmax = 2000;
var
  i, ngold: integer;
begin
  if DontBagGoldDrop then begin
    DontBagGoldDrop := False;
    Exit;
  end;

  if Gold > 0 then begin
    for i := 0 to 16 do begin
      if Gold > dropmax then begin
        ngold := dropmax;
        //            Gold := Gold - dropmax;
        DecGold(dropmax);
      end else begin
        ngold := Gold;
        Gold  := 0;
      end;
      if ngold > 0 then begin
        if not DropGoldDown(ngold, True, itemownership, self) then begin
          //               Gold := Gold + ngold;
          IncGold(ngold);
          break;
        end;
      end else
        break;
    end;
    GoldChanged;
  end;
end;

procedure TCreature.DropUseItems(itemownership: TObject; DieFromMob: boolean);
//죽어서 들고 있는 아이템을 흘림. 렌덤으로 흘린다.
var
  i, ran:  integer;
  dellist: TStringList;
  ps:      PTStdItem;
  iname:   string;
begin
  dellist := nil;
  try
    if (RaceServer = RC_USERHUMAN) and (not BoOldVersionUser_Italy) then begin
{   //이태리 버젼 삭제
         ps := UserEngine.GetStdItem (UseItems[U_CHARM].Index);
         if ps <> nil then begin
            // 발렌타인 이벤트
            if (UseItems[U_CHARM].Index = INDEX_CHOCOLATE) or // 초콜렛
               ( (ps.StdMode = 53) and (ps.Shape = SHAPE_OF_LUCKYLADLE) ) or
               // 화이트데이 이벤트
               (UseItems[U_CHARM].Index = INDEX_CANDY) or (UseItems[U_CHARM].Index = INDEX_LOLLIPOP) then // 사탕, 막대사탕
            begin
               // 초콜렛,사탕,막대사탕도 몹한테 죽은게 아니면 안사라짐(sonmg 2004/06/24)
               if DieFromMob then begin
                  if dellist = nil then dellist := TStringList.Create;
                  //버그 수정(sonmg 2005/03/17)
                  dellist.AddObject(UserEngine.GetStdItemName (UseItems[U_CHARM].Index), TObject(UseItems[U_CHARM].MakeIndex));
                  //로그 남겨야 함
                  AddUserLog ('16'#9 + //죽파_
                              MapName + ''#9 +
                              IntToStr(CX) + ''#9 +
                              IntToStr(CY) + ''#9 +
                              UserName + ''#9 +
                              ps.Name + ''#9 +
                              IntToStr(UseItems[U_CHARM].MakeIndex) + ''#9 +
                              IntToStr(BoolToInt(RaceServer = RC_USERHUMAN)) + ''#9 +
                              '0');

                  UseItems[U_CHARM].Index := 0;
               end;
               DontBagItemDrop := true;
               if dellist <> nil then begin
                  SendMsg (self, RM_DELITEMS, 0, integer(dellist), 0, 0, '');
                  //dellist는 rm_delitem에서 free 시켜야 한다.
               end;
               Exit;
            end;
         end;
}
      //초혼시리즈 사라짐
      // 2003/03/15 아이템 인벤토리 확장
      for i := 0 to 12 do begin     // 8->12
        // 몹한테 죽은게 아니면 안사라진다.
        if (i = U_CHARM) and (not DieFromMob) then
          continue;

        ps := UserEngine.GetStdItem(UseItems[i].Index);
        if ps <> nil then begin
          if (ps.ItemDesc and IDC_DIEANDBREAK) <> 0 then begin
            // 초혼시리즈도 몹한테 죽은게 아니면 안사라짐(sonmg 2004/06/24)
            if not DieFromMob then
              continue;

            if dellist = nil then
              dellist := TStringList.Create;
            //버그 수정(sonmg 2005/03/14)
            dellist.AddObject(UserEngine.GetStdItemName(UseItems[i].Index),
              TObject(UseItems[i].MakeIndex));
            //로그 남겨야 함
            AddUserLog('16'#9 + //죽파_
              MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
              ''#9 + UserName + ''#9 + ps.Name + ''#9 +
              IntToStr(UseItems[i].MakeIndex) + ''#9 +
              IntToStr(BoolToInt(RaceServer = RC_USERHUMAN)) + ''#9 + '0');

            UseItems[i].Index := 0;
          end;
        end;
      end;
    end;
    //아이템 떨굼(악성 빨갱이는 떨어질 확률 두 배)
    if PKLevel >= 3 then
      ran := 15
    else
      ran := 30;
    // 2003/03/15 아이템 인벤토리 확장
    for i := 0 to 12 do begin     // 8->12
      if Random(ran) = 0 then begin
        // 악성 빨갱이가 아닌 사람의 무기일 경우 떨어질 확률 1/2만큼 낮춤(2005/03/09)
        if (i = U_WEAPON) and (PKLevel < 3) then begin
          if Random(2) = 0 then
            continue;
        end;
        if DropItemDown(UseItems[i], 2, True, itemownership, self, 1) then begin
          ps := UserEngine.GetStdItem(UseItems[i].Index);
          if ps <> nil then begin
            //죽어도 떨어지지 않는 아이템은 제외
            if ps.ItemDesc and IDC_NEVERLOSE = 0 then begin
              if RaceServer = RC_USERHUMAN then begin
                if dellist = nil then
                  dellist := TStringList.Create;
                //떨어뜨린 아이템을 클라이언트에 알림.
                dellist.AddObject(UserEngine.GetStdItemName(UseItems[i].Index),
                  TObject(UseItems[i].MakeIndex));
              end;
              UseItems[i].Index := 0;
            end;
          end;
        end;
      end;
    end;
    if dellist <> nil then begin
      SendMsg(self, RM_DELITEMS, 0, integer(dellist), 0, 0, '');
      //dellist는 rm_delitem에서 free 시켜야 한다.
    end;
  except
    MainOutMessage('[Exception] TCreature.DropUseItems');
  end;
end;

procedure TCreature.Die;   //죽은 상태, 사람인경우만 재생할 수 있음.

  function BoolToChar(flag: boolean): char;
  begin
    if flag then
      Result := 'T'
    else
      Result := 'F';
  end;

var
  i, exp: integer;
  guildwarkill, flag: boolean;
  str:   string;
  ehiter, cret: TCreature;
  boBadKill, bogroupcall: boolean;
  questnpc: TMerchant;
  ps:    PTStdItem;
  KingMobLogFlag: boolean;
  hum:   TUserHuman;
  strFZNumber: string;
  svidx: integer;
  lovername: string;
begin
  if NeverDie then
    exit;
  Death     := True;
  DeathTime := GetTickCount;
  ClearPkHiterList;
  if Master <> nil then begin
    ExpHiter  := nil;
    LastHiter := nil;
  end;
  IncSpell   := 0;
  IncHealth  := 0;
  IncHealing := 0;

  try
    //몹을 죽인 경우.  경험치를 얻는다.(몬스터가 죽을 때)
    if (RaceServer <> RC_USERHUMAN) and (LastHiter <> nil) then begin
      //마지막 때린자가 사람이어야 함.
      if ExpHiter <> nil then begin //경험치를 먹는 사람.. 먼저 때리기 시작한 사람
        if ExpHiter.RaceServer = RC_USERHUMAN then begin
          //최대 체력 만큼, 상대의 레벨에 비례해서 경험치를 얻는다.
          exp := ExpHiter.CalcGetExp(self.Abil.Level, self.FightExp);
          if not BoVentureServer then begin
            ExpHiter.GainExp(exp);
          end else begin
            //모험서버에서는 점수가 올라간다.
          end;

          //맵퀘스트가 있는지
          if PEnvir.HasMapQuest then begin
            if ExpHiter.GroupOwner <> nil then begin
              //그룹을 하고 있으면 그룹원에게 똑 같이 적용된다.
              for i := 0 to ExpHiter.GroupOwner.GroupMembers.Count - 1 do begin
                cret := TCreature(ExpHiter.GroupOwner.GroupMembers.Objects[i]);
                if not cret.Death and (ExpHiter.PEnvir =
                  cret.PEnvir) and (abs(ExpHiter.CX - cret.CX) <= 12) and
                  (abs(ExpHiter.CY - cret.CY) <= 12) then begin
                  if cret = ExpHiter then
                    bogroupcall := False
                  else
                    bogroupcall := True;
                  questnpc :=
                    TMerchant(PEnvir.GetMapQuest(cret,
                    self.UserName{죽은 몬스터 이름}, '', bogroupcall));
                  if questnpc <> nil then
                    questnpc.UserCall(cret);
                end;
              end;
            end else begin
              //그룹을 안하고 있으면 본인 만
              questnpc :=
                TMerchant(PEnvir.GetMapQuest(ExpHiter, UserName, '', False));
              if questnpc <> nil then
                questnpc.UserCall(ExpHiter);
            end;
          end;

        end else begin
          if ExpHiter.Master <> nil then begin //때린놈이 소환몹
            //부하도 경험치를 먹음
            ExpHiter.GainSlaveExp(self.Abil.Level);  //상대의 레벨만큼 경험을 먹음
            //주인이 경험치를 먹는다.
            exp := ExpHiter.Master.CalcGetExp(self.Abil.Level, self.FightExp);
            if not BoVentureServer then begin
              ExpHiter.Master.GainExp(exp); //소환수를 부리는 사람이 먹는다.
            end else begin
              //모험서버에서는 점수가 올라간다.
            end;

            //-------부하몹이 죽였을 경우에도 맵퀘스트 수행--------(sonmg 2005/03/10)
            //맵퀘스트가 있는지
            if PEnvir.HasMapQuest then begin
              if ExpHiter.Master.GroupOwner <> nil then begin
                //그룹을 하고 있으면 그룹원에게 똑 같이 적용된다.
                for i := 0 to ExpHiter.Master.GroupOwner.GroupMembers.Count - 1 do
                begin
                  cret :=
                    TCreature(ExpHiter.Master.GroupOwner.GroupMembers.Objects[i]);
                  if not cret.Death and
                    (ExpHiter.Master.PEnvir = cret.PEnvir) and
                    (abs(ExpHiter.Master.CX - cret.CX) <= 12) and
                    (abs(ExpHiter.Master.CY - cret.CY) <= 12) then begin
                    if cret = ExpHiter.Master then
                      bogroupcall := False
                    else
                      bogroupcall := True;
                    questnpc :=
                      TMerchant(PEnvir.GetMapQuest(cret,
                      self.UserName{죽은 몬스터 이름}, '', bogroupcall));
                    if questnpc <> nil then
                      questnpc.UserCall(cret);
                  end;
                end;
              end else begin
                //그룹을 안하고 있으면 본인 만
                questnpc :=
                  TMerchant(PEnvir.GetMapQuest(ExpHiter.Master, UserName, '', False));
                if questnpc <> nil then
                  questnpc.UserCall(ExpHiter.Master);
              end;
            end;
            //----------------------------------

          end;
        end;
      end else if LastHiter.RaceServer = RC_USERHUMAN then begin
        //최대 체력 만큼, 상대의 레벨에 비례해서 경험치를 얻는다.
        exp := LastHiter.CalcGetExp(self.Abil.Level, self.FightExp);
        if not BoVentureServer then begin
          LastHiter.GainExp(exp);
        end else begin

        end;
      end;
    end;
    Master := nil;
  except
    MainOutMessage('[Exception] TCreature.Die 1');
  end;

  try
    boBadKill := False;
    if (not BoVentureServer) and (not PEnvir.FightZone) and
      (not PEnvir.Fight2Zone) and (not PEnvir.Fight3Zone) and
      (not PEnvir.Fight4Zone) then begin
      //PK금지 구역인 경우(사람이 죽을 때)
      if (RaceServer = RC_USERHUMAN) and (LastHiter <> nil) and (PKLevel < 2) then
      begin
        //죽은자가 사람, 때린자 있음, 죽은자가 PK아님
        if LastHiter.RaceServer = RC_USERHUMAN then begin
          boBadKill := True;
          if BoTaiwanEventUser then
            boBadKill := False;  //대만 이벤트 인경우 죽여되 됨
        end;
        if LastHiter.Master <> nil then
          if LastHiter.Master.RaceServer = RC_USERHUMAN then begin
            LastHiter := LastHiter.Master; //주인이 때린 것으로 간주
            boBadKill := True;
          end;
      end;
    end;

    if boBadKill and (LastHiter <> nil) then begin
      //사람이 죽은 경우, 모험서버에서는 해당안됨
      //사람이 선량한 사람을 죽임.

      //문파전으로 죽음
      guildwarkill := False;
      if (MyGuild <> nil) and (LastHiter.MyGuild <> nil) then begin
        //둘다 문파에 가입된 상태에서
        if GetGuildRelation(self, LastHiter) = 2 then  //문전(문파전)중임
          guildwarkill := True;  //문파전으로 죽음, 빨갱이 안됨
      end;

      //공성전으로 죽음
      if UserCastle.BoCastleUnderAttack then
        if (BoInFreePKArea) or (UserCastle.IsCastleWarArea(PEnvir, CX, CY)) then
          guildwarkill := True;

      if not guildwarkill then begin //문파전으로 죽음
        if not LastHiter.IsGoodKilling(self) then begin
          LastHiter.IncPkPoint(100);

          LastHiter.SysMsg(sYouCommitMurder, 0);
          SysMsg(Format(sYouAreMurdered, [LastHiter.UserName]), 0);

          /////////////////////////////////////////////////////////
          //연인에게 통보
          if TUserHuman(self).fLover <> nil then begin
            lovername := TUserHuman(self).fLover.GetLoverName;
            if lovername <> '' then begin
              hum := UserEngine.GetUserHuman(lovername);
              if hum <> nil then begin
                hum.SysMsg(Format(sYourLoverMurdered, [LastHiter.UserName]), 0);
              end else begin
                if UserEngine.FindOtherServerUser(lovername, svidx) then begin
                  UserEngine.SendInterMsg(ISM_LM_KILLED_MSG,
                    svidx, lovername + '/' + '[당신의 연인이 ' +
                    LastHiter.UserName + '님에게 살해 당했습니다.]');
                end;
              end;
            end;
          end;
          /////////////////////////////////////////////////////////

          //살인한 사람 행운 감소
          LastHiter.AddBodyLuck(-500);
          if PkLevel < 1 then //죽은 사람이 착한 사람
            if Random(5) = 0 then begin //살인을 하면 무기가 저주를 받는다.
              if LastHiter.MakeWeaponUnlock then begin
                ps := UserEngine.GetStdItem(LastHiter.UseItems[U_WEAPON].Index);
                //무기
                if ps <> nil then begin
                  //로그 남김
                  AddUserLog('43'#9 + //저주_(살인으로인한)
                    LastHiter.MapName + ''#9 +
                    IntToStr(LastHiter.CX) + ''#9 +
                    IntToStr(LastHiter.CY) + ''#9 +
                    LastHiter.UserName + ''#9 + ps.Name + ''#9 +
                    IntToStr(LastHiter.UseItems[U_WEAPON].MakeIndex) + ''#9 +
                    '1'#9 + '-1');
                end;
              end;
            end;
        end else begin
          LastHiter.SysMsg(sYouCommitLegalMurder, 1);
          SysMsg(Format(sYouAreLegalMurdered, [LastHiter.UserName]), 1);
        end;
      end;
    end;
  except
    MainOutMessage('[Exception] TCreature.Die 2');
  end;

  try
    if (not PEnvir.FightZone) and// (not PEnvir.Fight2Zone) and
      (not PEnvir.Fight3Zone) and// (not PEnvir.Fight4Zone) and
      (not BoAnimal) and (not PEnvir.LawFull) then begin
      //동물이면 썰어야 고기가 나온다.

      // 수호석 깨지는 문제 수정(sonmg 2004/06/11)
      // 사람과 몬스터 구별(2004/06/22)
      if RaceServer <> RC_USERHUMAN then begin
        ehiter := ExpHiter;
        if ExpHiter <> nil then
          if ExpHiter.Master <> nil then
            ehiter := ExpHiter.Master;
      end else begin
        ehiter := LastHiter;
        if LastHiter <> nil then
          if LastHiter.Master <> nil then
            ehiter := LastHiter.Master;
      end;

      if (RaceServer <> RC_USERHUMAN) then begin
        //(몹인 경우)
        DropUseItems(ehiter, False);
        if (Master = nil) and (not BoNoItem) then
          ScatterBagItems(ehiter);  //주인있는 몹은 물건을 흘리지 않음
        if (RaceServer >= RC_ANIMAL) and (Master = nil) and (not BoNoItem) then
          ScatterGolds(ehiter);  //사람은 돈을 흘리지 않는다.
      end else begin
        //(사람인 경우)
        //대련사냥터에서는 떨구지 않는다. 아이템을 떨구지 않는 맵인 경우도 마찬가지(sonmg 2005/03/14)
        if (not PEnvir.Fight2Zone) and (not PEnvir.NoDropItem) then begin
          if not ((PEnvir.Fight4Zone) and (ehiter <> nil) and
            (ehiter.RaceServer = RC_USERHUMAN)) then begin
            //사람한테 죽은 경우 착용 아이템을 흘리지 않는다.
            if ehiter <> nil then begin
              // 2003/06/20 이벤트몹에 의해 죽은 경우 흘리지 않는다.
              if (ehiter.RaceServer <> RC_USERHUMAN) and
                (not ehiter.BoHasMission) then begin
                //몹에 의해 죽은 경우
                DropUseItems(nil, True);

              end;
            end else begin
              // 기타의 경우
              DropUseItems(nil, False);
            end;

            // 변경된 상태를 알려줌(sonmg)
            FeatureChanged;

            // 2003/06/20 이벤트몹에 의해 죽은 경우 흘리지 않는다.
            if (ehiter <> nil) and (ehiter.BoHasMission) then
            else
              ScatterBagItems(nil);
            //죽은 경우 행운치 감소
            //2003/02/11 최대래밸 변경
            AddBodyLuck(-Abil.Level * 5);  //50 - (50
          end;
        end;
      end;
    end;

{
      //------------------------------------------------------------
      //대련 사냥터는 몬스터가 아이템을 떨군다.(sonmg 2004/12/23)
      if (PEnvir.Fight2Zone or PEnvir.Fight4Zone) and (not BoAnimal) then begin
         if (RaceServer <> RC_USERHUMAN) then begin
            ehiter := ExpHiter;
            if ExpHiter <> nil then
               if ExpHiter.Master <> nil then
                  ehiter := ExpHiter.Master;

            //몹이 죽을 때
            DropUseItems (ehiter, false);
            if (Master = nil) and (not BoNoItem) then
               ScatterBagItems (ehiter);  //주인있는 몹은 물건을 흘리지 않음
            if (RaceServer >= RC_ANIMAL) and (Master = nil) and (not BoNoItem) then
               ScatterGolds (ehiter);  //사람은 돈을 흘리지 않는다.
         end;
      end;
      //------------------------------------------------------------
}

    //문파 대전 중
    if PEnvir.Fight3Zone then begin
      //3번 죽어도 되는 대련인 경우
      Inc(FightZoneDieCount);
      if MyGuild <> nil then begin
        TGuild(MyGuild).TeamFightWhoDead(UserName);
      end;

      //점수 계산
      if (LastHiter <> nil) then begin
        if (LastHiter.MyGuild <> nil) and (MyGuild <> nil) then begin
          TGuild(LastHiter.MyGuild).TeamFightWhoWinPoint(LastHiter.UserName, 100);
          //matchpoint 증가, 개인성적 기록
          str := TGuild(LastHiter.MyGuild).GuildName + ':' +
            IntToStr(TGuild(LastHiter.MyGuild).MatchPoint) + '  ' +
            TGuild(MyGuild).GuildName + ':' + IntToStr(TGuild(MyGuild).MatchPoint);
          UserEngine.CryCry(RM_CRY, PEnvir, CX, CY, 10000, '- ' + str);
          //현맵 전체에게 알린다.
        end;
      end;
    end;

    //분신일경우에는 빨리 없엔다음에 이펙트 넣어준다.
    if (RaceServer = RC_CLONE) then begin
      //         SendRefMsg (RM_NORMALEFFECT, 0, CX, CY, NE_CLONEHIDE, '');
      SendRefMsg(RM_LOOPNORMALEFFECT, integer(self), 0, 0, NE_CLONEHIDE, '');
    end;


    //로그를 남긴다.(사람이 죽을 때)
    if RaceServer = RC_USERHUMAN then begin
      if LastHiter <> nil then begin
        if LastHiter.RaceServer = RC_USERHUMAN then
          str := LastHiter.UserName
        else if LastHiter.BoHasMission then
          str := '*' + LastHiter.UserName  // 이벤트몹 표시(sonmg 2005/01/24)
        else begin
          // 소환수일 때는 주인 이름을 남김(sonmg 2005/03/08)
          if LastHiter.Master <> nil then
            str := LastHiter.Master.UserName
          else
            str := '#' + LastHiter.UserName;
        end;
      end else
        str := '######';
      //-------------------------
      //대련장 종류 구분
      strFZNumber := '';
      if PEnvir.FightZone then
        strFZNumber := '1'
      else if PEnvir.Fight2Zone then
        strFZNumber := '2'
      else if PEnvir.Fight3Zone then
        strFZNumber := '3'
      else if PEnvir.Fight4Zone then
        strFZNumber := '4'
      else
        strFZNumber := 'F';
      //-------------------------
      //정당방위 구분
      if LastHiter <> nil then begin
        if LastHiter.IsGoodKilling(self) then
          strFZNumber := strFZNumber + '-R'
        else if self.PKLevel >= 2 then
          strFZNumber := strFZNumber + '-R';
      end;

      AddUserLog('19'#9 + //죽음_ +
        MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) + ''#9 +
        UserName + ''#9 +
        //                     'FZ-' + BoolToChar(PEnvir.FightZone) + '_F3-' + BoolToChar(PEnvir.Fight3Zone) + '_F2-' + BoolToChar(PEnvir.Fight2Zone) + ''#9 +
        'FZ-' + strFZNumber + ''#9 + '0'#9 + '1'#9 + str);
    end else begin    //(몬스터가 죽을 때)
      KingMobLogFlag := False;
      //레벨 60이상은 로그 남김.
      if (Abil.Level >= 60) then begin
        KingMobLogFlag := True;
      end;

      if KingMobLogFlag then begin
        if LastHiter <> nil then begin
          if LastHiter.RaceServer = RC_USERHUMAN then
            str := LastHiter.UserName
          else
            str := '#' + LastHiter.UserName;
        end else
          str := '######';
        //몬스터 왕죽음 로그 남김(sonmg. 2004/05/14)
        AddUserLog('42'#9 + //왕죽음_ +
          MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
          ''#9 + UserName + ''#9 + 'FZ-M' + ''#9 + '0'#9 + '0'#9 + str);
      end;
    end;

    SendRefMsg(RM_DEATH, Dir, CX, CY, 1, '');

  except
    MainOutMessage('[Exception] TCreature.Die 3');
  end;
end;

procedure TCreature.Alive;
begin
  //체력이 0이면 1 보충
  if Abil.HP = 0 then
    Abil.HP := 1;

  Death := False;
  SendRefMsg(RM_LOOPNORMALEFFECT, integer(self), 0, 0, NE_RELIVE, '');
  SendRefMsg(RM_ALIVE, Dir, CX, CY, 0, '');

  //능력치 재전송
  //   RecalcAbilitys;
  SendRefMsg(RM_CHANGELIGHT, 0, 0, 0, 0, '');
end;

procedure TCreature.SetLastHiter(hiter: TCreature);
begin
  LastHiter := hiter;
  // 마지막 때린넘 종족 기억(2004/07/16)
  if LastHiter <> nil then begin
    if LastHiter.Master <> nil then begin
      //주인이 있을 경우는 주인의 종족을 기억한다(2004/11/30)
      LastHiterRace := LastHiter.Master.RaceServer;
    end else begin
      LastHiterRace := LastHiter.RaceServer;
    end;
  end;
  LastHitTime := GetTickCount;
  if ExpHiter = nil then begin
    ExpHiter   := hiter;
    ExpHitTime := GetTickCount;
  end else if ExpHiter = hiter then
    ExpHitTime := GetTickCount;
end;

//자신이 사람한테 맞았을 때 호출 됨
procedure TCreature.AddPkHiter(hiter: TCreature); //사람인지 먼저 확인..
var
  i:  integer;
  pk: PTPkHiterInfo;
begin
  if (PkLevel < 2) and (hiter.PkLevel < 2) then begin
    //선량한 사람들한테만 적용 (자신이 선량한 사람)
    if (not PEnvir.FightZone) and (not PEnvir.Fight2Zone) and
      (not PEnvir.Fight3Zone) and (not PEnvir.Fight4Zone) then begin
      if not BoIllegalAttack then begin  //자신이 선재공격을 하지 않은 경우
        hiter.IllegalAttackTime := GetTickCount;
        if not hiter.BoIllegalAttack then begin
          hiter.BoIllegalAttack := True;
          hiter.ChangeNameColor;
        end;
      end;
    end;
      {end else begin
         for i:=0 to hiter.PKHiterList.Count-1 do begin //상대방을 내가 먼저 때렸는지 검사
            if PTPkHiterInfo(hiter.PKHiterList[i]).hiter = self then begin
               exit;  //내가 먼저 때린 경우
            end;
         end;
         for i:=0 to PKHiterList.Count-1 do begin
            if PTPkHiterInfo(PKHiterList[i]).hiter = hiter then begin
               PTPkHiterInfo(PKHiterList[i]).hittime := GetTickCount;
               exit;
            end;
         end;
         new (pk);
         pk.hiter := hiter;
         pk.hittime := GetTickCount;
         PKHiterList.Add (pk);
         hiter.ChangeNameColor;  //나와 정당방위인 경우 색이 바뀜
      end; }
  end;
end;

procedure TCreature.CheckTimeOutPkHiterList;
var
  i:   integer;
  hum: TUserHuman;
  DuringIllegalTime: longword;
begin
  DuringIllegalTime := 60 * 1000;

  //if BoTestServer then begin
  if BoIllegalAttack then begin
    if GetTickCount - IllegalAttackTime > DuringIllegalTime then begin
      BoIllegalAttack := False;
      ChangeNameColor;
    end;
  end;
   {end else begin
      for i:=0 to PKHiterList.Count-1 do begin
         if GetTickCount - PTPkHiterInfo(PKHiterList[i]).hittime > 60 * 1000 then begin
            hum := TUserHuman (PTPkHiterInfo(PKHiterList[i]).hiter);
            hum.ChangeNameColor;  //정방방위 해제..
            Dispose (PTPkHiterInfo(PKHiterList[i]));
            PKHiterList.Delete (i);
            break;
         end;
      end;
   end;}
end;

procedure TCreature.ClearPkHiterList;
var
  i: integer;
begin
  for i := 0 to PKHiterList.Count - 1 do
    Dispose(PTPkHiterInfo(PKHiterList[i]));
  PKHiterList.Clear;
end;

function TCreature.IsGoodKilling(target: TCreature): boolean;
var
  i: integer;
begin
  Result := False;
  //if BoTestServer then begin
  if target.BoIllegalAttack then
    Result := True;
   {end else begin
      for i:=0 to PKHiterList.Count-1 do begin
         if PTPkHiterInfo(PKHiterList[i]).hiter = target then begin
            Result := TRUE;
            break;
         end;
      end;
   end;}
end;

procedure TCreature.SetAllowLongHit(boallow: boolean);
begin
  BoAllowLongHit := boallow;
  if BoAllowLongHit then
    SysMsg(sUseThrusting, 1)
  else
    SysMsg(sNotUseThrusting, 1);
end;

procedure TCreature.SetAllowWideHit(boallow: boolean);
begin
  BoAllowWideHit := boallow;
  if BoAllowWideHit then
    SysMsg(sUseHalfMoon, 1)
  else
    SysMsg(sNotUseHalfMoon, 1);
end;

procedure TCreature.SetAllowWideHit2(boallow: boolean);
begin
  BoAllowWideHit2 := boallow;
  if BoAllowWideHit2 then
    SysMsg(sUseHalfMoon2, 1)
  else
    SysMsg(sNotUseHalfMoon2, 1);
end;

procedure TCreature.SetAllowCrossHit(boallow: boolean);
begin
  BoAllowCrossHit := boallow;
  if BoAllowCrossHit then
    SysMsg(sUseCrossHalfMoons, 1)
  else
    SysMsg(sNotUseCrossHalfMoons, 1);
end;

function TCreature.SetAllowFireHit: boolean;   //염화결
begin
  Result := False;
  if GetTickCount - LatestFireHitTime > 10 * 1000 then begin
    LatestFireHitTime := GetTickCount;
    BoAllowFireHit    := True;
    SysMsg(sYourWeaponHasFire, 1);
    Result := True;
  end else begin
    SysMsg(sYourWeaponNoFire, 0);
  end;
end;

function TCreature.SetAllowTwinHit: boolean;   //쌍룡참
begin
  Result := False;
  if GetTickCount - LatestTwinHitTime > 1000 then begin
    LatestTwinHitTime := GetTickCount;
    BoAllowTwinHit := 1;
    //    SysMsg ('쌍룡참이 발동되었습니다.', 1);
    Result := True;
    // end else begin
    //    SysMsg ('쌍룡참이 발동되지 않았습니다.', 0);
  end;
end;

//(+)만 허용
procedure TCreature.IncHealthSpell(hp, mp: integer);
begin
  if (hp >= 0) and (mp >= 0) then begin
    if WAbil.HP + hp < WAbil.MaxHP then
      WAbil.HP := WAbil.HP + hp
    else
      WAbil.HP := WAbil.MaxHP;
    if WAbil.MP + mp < Wabil.MaxMP then
      WAbil.MP := WAbil.MP + mp
    else
      WAbil.MP := WAbil.MaxMP;
    HealthSpellChanged;
    //UpdateMsg (self, RM_HEALTHSPELLCHANGED, 0, 0, 0, 0, '');
  end;
end;

//mapname의 맵은 항상 0번맵 혹은 아마나 갈 수 있는 바탕맵이다.
procedure TCreature.RandomSpaceMove(mname: string; mtype: integer);
var
  nx, ny, egdey:    integer;
  nenvir, oldenvir: TEnvirnoment;
  //  hum: TUserHuman;
begin
  oldenvir := PEnvir;
  nenvir   := GrobalEnvir.GetEnvir(mname);
  if nenvir <> nil then begin
    if nenvir.MapHeight < 150 then begin
      if nenvir.MapHeight < 30 then
        egdey := 2
      else
        egdey := 20;
    end else
      egdey := 50;
    nx := egdey + Random(nenvir.MapWidth - egdey - 1);
    ny := egdey + Random(nenvir.MapHeight - egdey - 1);
    SpaceMove(mname, nx, ny, mtype);

  end;
end;

 //mapname의 맵은 항상 0번맵 혹은 아마나 갈 수 있는 바탕맵이다.
 //현재 맵에서 반경이 InRange보다 크고 OutRange보다 작은 범위로 랜덤하게 이동.
procedure TCreature.RandomSpaceMoveInRange(mtype, InRange, OutRange: integer);
var
  ran, signX, signY, nx, ny: integer;
  moverange: integer;
begin
  //초기화.
  signX := 1;
  signY := 1;

  if PEnvir <> nil then begin
    ran := Random(100);
    ran := ran mod 4;

    case ran of
      0: begin
        signX := 1;
        signY := 1;
      end;
      1: begin
        signX := -1;
        signY := 1;
      end;
      2: begin
        signX := -1;
        signY := -1;
      end;
      3: begin
        signX := 1;
        signY := -1;
      end;
    end;

    nx := CX + signX * (InRange + Random(OutRange - InRange) + 1);
    // 지도의 사이즈보다 클 경우에 넘어가지 않도록 수정...
    // 넘어가면 SpaceMove 함수 안에서 랜덤하게 튕길 수 있다.
    if nx >= PEnvir.MapWidth then begin
      nx := PEnvir.MapWidth - 1;
    end else if nx < 0 then begin
      nx := 0;
    end;

    ny := CY + signY * (InRange + Random(OutRange - InRange) + 1);
    // 지도의 사이즈보다 클 경우에 넘어가지 않도록 수정...
    // 넘어가면 SpaceMove 함수 안에서 랜덤하게 튕길 수 있다.
    if ny >= PEnvir.MapHeight then begin
      ny := PEnvir.MapHeight - 1;
    end else if ny < 0 then begin
      ny := 0;
    end;

    SpaceMove(PEnvir.MapName, nx, ny, mtype);
  end;
end;

procedure TCreature.SpaceMove(mname: string; nx, ny, mtype: integer);

  function RandomEnvXY(env: TEnvirnoment; var nnx, nny: integer): boolean;
  var
    i, step, edge: integer;
  begin
    Result := False;
    if env.MapWidth < 80 then
      step := 3
    else
      step := 10;
    if env.MapHeight < 150 then begin
      if env.MapHeight < 50 then
        edge := 2
      else
        edge := 15;
    end else
      edge := 50;
    for i := 0 to 200 do begin
      if env.CanWalk(nnx, nny, True{겸침허용}) then begin
        Result := True;
        break;
      end else begin
        if nnx < env.MapWidth - edge - 1 then
          Inc(nnx, step)
        else begin
          nnx := Random(env.MapWidth); //edge;
          if nny < env.MapHeight - edge - 1 then
            Inc(nny, step)
          else
            nny := Random(env.MapHeight); //edge;
        end;
      end;
    end;
  end;

var
  i, oldx, oldy, step, edge: integer;
  nenvir, oldenvir: TEnvirnoment;
  outofrange: pointer;
  success: boolean;
  hum: TUserHuman;
begin
  nenvir := GrobalEnvir.GetEnvir(mname);
  if nenvir <> nil then begin
    if ServerIndex = nenvir.Server then begin  //같은 서버
      oldenvir := PEnvir;
      oldx     := CX;
      oldy     := CY;
      success  := False;

{
         //슬쩍 사라짐.
         if  1 <> PEnvir.DeleteFromMap (CX, CY, OS_MOVINGOBJECT, self) then
         begin
            // 사라지지 못했음..
            MainOutMessage('Error DeleteFromMap(1):'+PEnvir.MapName+','+IntToStr(CX)+','+IntToStr(CY));
            // exit;
         end;
}
      Disappear(6);  // (sonmg 2005/02/24)

      MsgTargetList.Clear;
      for i := 0 to VisibleItems.Count - 1 do
        Dispose(PTVisibleItemInfo(VisibleItems[i]));
      VisibleItems.Clear;
      // 2003/03/18
      i := 0;
      while True do begin
        if i >= VisibleActors.Count then
          break;
            {
            if RaceServer = RC_USERHUMAN then begin
            try
               if(PTVisibleActor(VisibleActors[i]).cret <> nil) then
                  TCreature (PTVisibleActor(VisibleActors[i]).cret).DecRefObjCount;
            except
               MainOutMessage ('[Exception] TCreatre.Destroy : Visible Actor Dec RefObjCount');
               end;
            end;
            }
        Dispose(PTVisibleActor(VisibleActors[i]));
        VisibleActors.Delete(i);
        //          Inc(i);
      end;
      VisibleActors.Clear;

      //새맵에 뽕 등장
      PEnvir  := nenvir;
      MapName := nenvir.MapName;
      CX      := nx; //2 + Random(PEnvir.MapWidth-4);
      CY      := ny; //2 + Random(PEnvir.MapHeight-4);
      if RandomEnvXY(PEnvir, CX, CY) then begin
        if (nil <> PEnvir.AddToMap(CX, CY, OS_MOVINGOBJECT, self)) then begin

          SendMsg(self, RM_CLEAROBJECTS, 0, 0, 0, 0, '');
          SendMsg(self, RM_CHANGEMAP, 0, 0, 0, 0, nenvir.GetGuildAgitRealMapName);
          case mtype of
            1: SendRefMsg(RM_SPACEMOVE_SHOW2, Dir, CX, CY, 0, '');
            else
              SendRefMsg(RM_SPACEMOVE_SHOW, Dir, CX, CY, 0, '');
          end;
          MapMoveTime := GetTickCount;
          SpaceMoved  := True; //WalkTo가 실패하지 않게 하려고..
          success     := True;

        end;
      end;

      if not success then begin
        PEnvir := oldenvir;
        CX     := oldx;
        CY     := oldy;
        if (nil = PEnvir.AddToMap(CX, CY, OS_MOVINGOBJECT, self)) then begin
          MainOutMessage('Error DeleteFromMap(2):' + PEnvir.MapName +
            ',' + IntToStr(CX) + ',' + IntToStr(CY));
        end;
      end;

    end else begin  //다른 서버임... 서버이동
      //서버 이동
      if RandomEnvXY(nenvir, nx, ny) then begin
        if RaceServer = RC_USERHUMAN then begin
          if Disappear(4) = True then begin
            SpaceMoved := True;
            hum := TUserHuman(self);
            hum.ChangeMapName := nenvir.MapName;
            hum.ChangeCX := nx;
            hum.ChangeCY := ny;
            hum.BoChangeServer := True;  //서버이동
            hum.ChangeToServerNumber := nenvir.Server;
            hum.EmergencyClose := True;
            hum.SoftClosed := True;  //Certifycation을 만료시키지 않는다.
            hum.FAlreadyDisapper := True;
          end;
          // 사라지지 않는다면 어떻게 해야하나...PDS
        end else begin
          KickException;  //사라진다.
        end;
      end;
    end;
  end;
end;

procedure TCreature.UserSpaceMove(mname, xstr, ystr: string);
var
  xx, yy:   integer;
  oldenvir: TEnvirnoment;
  hum:      TUserHuman;
begin
  oldenvir := PEnvir;
  if mname = '' then
    mname := MapName;
  if (xstr <> '') and (ystr <> '') then begin
    xx := Str_ToInt(xstr, 0);
    yy := Str_ToInt(ystr, 0);
    SpaceMove(mname, xx, yy, 0);
  end else
    RandomSpaceMove(mname, 0);

  if oldenvir <> PEnvir then begin  //실질적으로 다른 맵으로 이동 하였음
    if RaceServer = RC_USERHUMAN then begin
      hum := TUserHuman(self);
      hum.BoTimeRecall := False;    //TimeRecall 취소
      hum.BoTimeRecallGroup := False;
    end;
  end;
end;

function TCreature.UseScroll(Shape: integer): boolean;
var
  hum:      TUserHuman;
  guildagit: TGuildAgit;
  AgitFlag: boolean;
begin
  Result := False;
  case Shape of
    1: //순간이동주문서: 0번 맵으로 돌아간다.
      if not BoTaiwanEventUser then begin
        if not (PEnvir.NoEscapeMove or PEnvir.NoTeleportMove) then
        begin  //아공전서 사용불가(sonmg)
          SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
          UserSpaceMove(HomeMap, '', ''); //무작위 공간이동  //'0'
          Result := True;
        end;
      end else
        SysMsg(sYouCannotUse, 0);
{      2: //현재 맵에서 무작위로 점프
         if not BoTaiwanEventUser then begin
            if not PEnvir.NoRandomMove then begin
               SendRefMsg (RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
               UserSpaceMove (MapName, '', ''); //무작위 공간이동
               Result := TRUE;
            end;
         end else
            SysMsg (sYouCannotUse, 0);
}
    2: //현재 맵에서 무작위로 점프
      if not BoTaiwanEventUser then begin
        if not (PEnvir.NoRandomMove or PEnvir.NoTeleportMove) then
        begin  //아공도약서 사용불가(sonmg)
               //공성전 중인 내성의 경우
          if (UserCastle.BoCastleUnderAttack) and
            (PEnvir = UserCastle.CorePEnvir) then begin
            if GetTickCount - LatestSpaceScrollTime > 10 * 1000 then begin
              LatestSpaceScrollTime := GetTickCount;

              SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
              UserSpaceMove(MapName, '', ''); //무작위 공간이동
              Result := True;
            end else begin
              SysMsg(Format(sYouCanUseLater,
                [10 - (GetTickCount - LatestSpaceScrollTime) div 1000]), 0);
              Result := False;
            end;

          end else begin
            SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
            UserSpaceMove(MapName, '', ''); //무작위 공간이동
            Result := True;
          end;
        end;
      end else
        SysMsg(sYouCannotUse, 0);


    3: //귀환주문서(초공전서)
      if not BoTaiwanEventUser then begin
        SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
        if PKLevel < 2 then begin
          UserSpaceMove(HomeMap, IntToStr(HomeX), IntToStr(HomeY));
        end else begin
          UserSpaceMove(BADMANHOMEMAP, IntToStr(BADMANSTARTX),
            IntToStr(BADMANSTARTY));
        end;
        Result := True;
      end else
        SysMsg(sYouCannotUse, 0);
    4: //축복의기름...  무기에 행운을 준다.
    begin
      if MakeWeaponGoodLock then begin
        Result := True;
      end;
    end;
    5: //사북귀환주문서,귀성전서
      if not BoTaiwanEventUser then begin
        if MyGuild <> nil then begin
          if not BoInFreePKArea then begin
            //not UserCastle.BoCastleUnderAttack then begin
            if UserCastle.IsOurCastle(TGuild(MyGuild)) then begin
              //우리문파가 사북성을 점령
              UserSpaceMove(UserCastle.CastleMap,
                IntToStr(UserCastle.GetCastleStartX),
                IntToStr(UserCastle.GetCastleStartY));
            end else
              SysMsg(sItemNoEffect, 0);
            Result := True;
          end else
            SysMsg(sYouCannotUseHere, 0);
        end;
      end else
        SysMsg(sYouCannotUse, 0);
    6: //귀환전서(장원으로 귀환) -> 해당 장원이 없으면 초공전서와 동일한 기능.
       //장원으로 귀환
    begin
      AgitFlag := False;
      if not BoTaiwanEventUser then begin
        if RaceServer = RC_USERHUMAN then begin
          hum := TUserHuman(self);
          if hum.MyGuild <> nil then begin
            // 문파의 장원 번호와 현재 있는 맵의 장원번호가 일치하면 장원으로 이동.
            guildagit :=
              GuildAgitMan.GetGuildAgit(TGuild(hum.MyGuild).GuildName);
            if guildagit <> nil then begin
              if guildagit.GuildAgitNumber > -1 then begin
                hum.CmdGuildAgitFreeMove(guildagit.GuildAgitNumber);
                AgitFlag := True;
                Result   := True;
              end;
            end;
          end;

          if AgitFlag = False then begin
            //아니면... 초공전서와 같은 기능
            SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
            if PKLevel < 2 then begin
              UserSpaceMove(HomeMap, IntToStr(HomeX), IntToStr(HomeY));
            end else begin
              UserSpaceMove(BADMANHOMEMAP, IntToStr(BADMANSTARTX),
                IntToStr(BADMANSTARTY));
            end;
            Result := True;
          end;
        end;
      end else
        SysMsg(sYouCannotUse, 0);
    end;
    9: //수리기름... 현재 무기의 내구력회복 (일반수리)
    begin
      if RepaireWeaponNormaly then begin
        Result := True;
      end;
    end;
    10: //무신의기름... 현재 무기의 내구력회복 (특수수리)
    begin
      if RepaireWeaponPerfect then begin
        Result := True;
      end;
    end;

    11: //복권
    begin
      if UseLotto then begin
        Result := True;
      end;
    end;

  end;
end;

function TCreature.MakeWeaponGoodLock: boolean;
var
  difficulty: integer;
  flag: boolean;
  pstd: PTStdItem;
  // 2003/06/13 로그 추가
  Delta, Old: integer;
  hum:  TUserHuman;
begin
  // 2003/06/13 로그 추가
  Delta := 0;
  if UseItems[U_WEAPON].Desc[4] > 0 then
    Old := -UseItems[U_WEAPON].Desc[4]  //저주는 음수
  else
    Old := UseItems[U_WEAPON].Desc[3];

  Result := False;
  if UseItems[U_WEAPON].Index <> 0 then begin
    difficulty := 0;
    pstd := UserEngine.GetStdItem(UseItems[U_WEAPON].Index);
    if pstd <> nil then begin  //랜덤치가 클수록 행운이 붙기 힘들다.
      difficulty := abs(Hibyte(pstd.DC) - Lobyte(pstd.DC)) div 5;
      // 2003/06/13 로그 추가
    end else
      exit;

    if Random(20) = 1 then begin
      if MakeWeaponUnlock then begin  //저주에 걸림...
        Delta := -1;
      end;
    end else begin
      flag := False;
      if UseItems[U_WEAPON].Desc[4] > 0 then begin
        UseItems[U_WEAPON].Desc[4] := UseItems[U_WEAPON].Desc[4] - 1;
        //불운(저주) 감소
        SysMsg(sWeaponGainLuck, 1);
        Delta := 1;
        flag  := True;
      end else begin
        if (UseItems[U_WEAPON].Desc[3] < 1) then begin
          UseItems[U_WEAPON].Desc[3] := UseItems[U_WEAPON].Desc[3] + 1; //행운
          SysMsg(sWeaponGainLuck, 1);
          Delta := 1;
          flag  := True;
        end else begin
          if (UseItems[U_WEAPON].Desc[3] < 3) and (Random(6 + difficulty) = 1) then
          begin
            UseItems[U_WEAPON].Desc[3] := UseItems[U_WEAPON].Desc[3] + 1; //행운
            SysMsg(sWeaponGainLuck, 1);
            Delta := 1;
            flag  := True;
          end else begin
            if (UseItems[U_WEAPON].Desc[3] < 7) and
              (Random(30 + difficulty * 5) = 1) then begin
              UseItems[U_WEAPON].Desc[3] := UseItems[U_WEAPON].Desc[3] + 1; //행운
              SysMsg(sWeaponGainLuck, 1);
              Delta := 1;
              flag  := True;
            end;
          end;
        end;
      end;
      if RaceServer = RC_USERHUMAN then begin
        RecalcAbilitys;
        hum := TUserHuman(self);   //added by sonmg(2003/11/07)
        hum.SendUpdateItem(UseItems[U_WEAPON]);   //added by sonmg(2003/11/07)
        SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
        SendMsg(self, RM_SUBABILITY, 0, 0, 0, 0, '');
      end;
      if not flag then
        SysMsg(sWeaponNoLuck, 1);
    end;
    // 2003/06/13 로그 추가
    //      if Delta <> 0 then begin    //불변 로그도 남기도록(sonmg 2005/04/13)
    //로그 남겨야 함
    AddUserLog('29'#9 + //축기_(사용)
      MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) + ''#9 +
      UserName + ''#9 + pstd.Name + ''#9 + IntToStr(UseItems[U_WEAPON].MakeIndex) +
      ''#9 + '0' + ''#9 + IntToStr(Delta) + '(' + IntToStr(Old) +
      '->' + IntToStr(Old + Delta) + ')'
      );
    //      end;
    Result := True;
  end;
end;

function TCreature.RepaireWeaponNormaly: boolean;
var
  repair: integer;
  ps:     PTStdItem;
  WeaponName: string;
begin
  Result := False;
  if UseItems[U_WEAPON].Index > 0 then begin
    ps := UserEngine.GetStdItem(UseItems[U_WEAPON].Index);
    if ps <> nil then begin
      // 유니크아이템 필드가 3이면 수리불가.
      if ps.UniqueItem = 3 then begin
        SysMsg(sWeaponCantRepair, 0);
        Result := False;
        exit;
      end;
      WeaponName := ps.Name;
    end;

    repair := _MIN(5000, _MAX(0, UseItems[U_WEAPON].DuraMax -
      UseItems[U_WEAPON].Dura));
    //DURAMAX수정
    if repair > 0 then begin
      UseItems[U_WEAPON].DuraMax :=
        _MAX(0, UseItems[U_WEAPON].DuraMax - (repair div 30));   //DURAMAX수정
      UseItems[U_WEAPON].Dura    :=
        _MIN(UseItems[U_WEAPON].Dura + repair, UseItems[U_WEAPON].DuraMax);
      SendMsg(self, RM_DURACHANGE, U_WEAPON, UseItems[U_WEAPON].Dura,
        UseItems[U_WEAPON].DuraMax, 0, '');
      RecalcAbilitys;//sonmg 추가
      SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');   //added by sonmg(2004/04/02)
      SendMsg(self, RM_SUBABILITY, 0, 0, 0, 0, '');   //added by sonmg(2004/04/02)
      //         SysMsg ('Weapon is partially repaired.', 1);
      SysMsg(Format(sWeaponRepaired, [WeaponName]), 1);
      Result := True;
    end else begin
      SysMsg(sWeaponNeedNotRepair, 0);
    end;
  end;
end;

function TCreature.RepaireWeaponPerfect: boolean;
var
  ps: PTStdItem;
begin
  Result := False;
  if UseItems[U_WEAPON].Index > 0 then begin
    ps := UserEngine.GetStdItem(UseItems[U_WEAPON].Index);
    if ps <> nil then begin
      // 유니크아이템 필드가 3이면 수리불가.
      if ps.UniqueItem = 3 then begin
        SysMsg(sWeaponCantRepair, 0);
        Result := False;
        exit;
      end;
    end;

    UseItems[U_WEAPON].Dura := UseItems[U_WEAPON].DuraMax;
    SendMsg(self, RM_DURACHANGE, U_WEAPON, UseItems[U_WEAPON].Dura,
      UseItems[U_WEAPON].DuraMax, 0, '');
    RecalcAbilitys;//sonmg 추가
    SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');   //added by sonmg(2004/04/02)
    SendMsg(self, RM_SUBABILITY, 0, 0, 0, 0, '');   //added by sonmg(2004/04/02)
    SysMsg(sWeaponRepairedFull, 1);
    Result := True;
  end;
end;

// 일반 아이템 수리(2004/03/17).
function TCreature.RepairItemNormaly(psSeed: PTStdItem; puSeed: PTUserItem): boolean;
var
  repair: integer;
  hum:    TUserHuman;
begin
  Result := False;

  if psSeed <> nil then begin
    // 유니크아이템 필드가 3이면 수리불가.
    if psSeed.UniqueItem = 3 then begin
      SysMsg(sItemCantRepair, 0);
      Result := False;
      exit;
    end;

    repair := _MIN(5000, _MAX(0, puSeed.DuraMax - puSeed.Dura));   //DURAMAX수정
    if repair > 0 then begin
      puSeed.DuraMax := _MAX(0, puSeed.DuraMax - (repair div 30));   //DURAMAX수정
      puSeed.Dura    := _MIN(puSeed.Dura + repair, puSeed.DuraMax);
      if RaceServer = RC_USERHUMAN then begin
        hum := TUserHuman(self);
        hum.SendUpdateItem(puSeed^);
      end;
      SysMsg(Format(sItemRepaired, [psSeed.Name]), 1);
      Result := True;
    end else begin
      SysMsg(sItemNeedNotRepair, 0);
    end;
  end;
end;

//복권을 긁는다.
function TCreature.UseLotto: boolean;
var
  ngold, grade: integer;
begin
  ngold := 0;
  grade := 0;
  case Random(30000) of  //500*25000 = 12,500,000 (11,500,000)
    0..4999: //500 * 5000 = 2,500,000
      if LottoSuccess < LottoFail then begin
        ngold := 500;
        grade := 6;
        Inc(Lotto6);
      end;
    14000..15999:  //1000 * 2000 = 2,000,000
      if LottoSuccess < LottoFail then begin
        ngold := 1000;
        grade := 5;
        Inc(Lotto5);
      end;
    16000..16149:  //10000 * 200 = 2,000,000
      if LottoSuccess < LottoFail then begin
        ngold := 10000;
        grade := 4;
        Inc(Lotto4);
      end;
    16150..16169:  //100000 * 20 = 2,000,000
      if LottoSuccess < LottoFail then begin
        ngold := 100000;
        grade := 3;
        Inc(Lotto3);
      end;
    16170..16179: //200000 * 10 = 2,000,000
      if LottoSuccess < LottoFail then begin
        ngold := 200000;
        grade := 2;
        Inc(Lotto2);
      end;
    18000:    //1000000 (1등)
      if LottoSuccess < LottoFail then begin
        ngold := 1000000;
        grade := 1;
        Inc(Lotto1);
      end;

  end;
  if ngold > 0 then begin
    LottoSuccess := LottoSuccess + ngold;
    case grade of
      1: SysMsg(sLottoWin1st, 1);
      2: SysMsg(sLottoWin2nd, 1);
      3: SysMsg(sLottoWin3rd, 1);
      4: SysMsg(sLottoWin4th, 1);
      5: SysMsg(sLottoWin5th, 1);
      6: SysMsg(sLottoWin6th, 1);
      7: SysMsg(sLottoWin7th, 1);
      8: SysMsg(sLottoWin8th, 1);
    end;
    if IncGold(ngold) then begin
      GoldChanged;
    end else begin
      DropGoldDown(ngold, True, nil, nil);
    end;
  end else begin
    LottoFail := LottoFail + 500;
    SysMsg(sLottoFail, 0);
  end;
  Result := True;
end;


procedure TCreature.MakeHolySeize(htime: integer);
begin
  BoHolySeize    := True;
  HolySeizeStart := GetTickCount;
  HolySeizeTime  := htime;
  ChangeNameColor;
end;

procedure TCreature.BreakHolySeize;
begin
  BoHolySeize := False;
  ChangeNameColor;
end;

procedure TCreature.MakeCrazyMode(csec: integer);
begin
  BoCrazyMode    := True;
  CrazyModeStart := GetTickCount;
  CrazyModeTime  := csec * 1000;
  ChangeNameColor;
end;

procedure TCreature.MakeGoodCrazyMode(csec: integer);
begin
  BoGoodCrazyMode := True;
  CrazyModeStart  := GetTickCount;
  CrazyModeTime   := csec * 1000;
  ChangeNameColor;
end;

procedure TCreature.BreakCrazyMode;
begin
  if BoCrazyMode or BoGoodCrazyMode then begin
    BoCrazyMode     := False;
    BoGoodCrazyMode := False;
    ChangeNameColor;
  end;
end;

procedure TCreature.MakeOpenHealth;
begin
  BoOpenHealth := True;
  CharStatusEx := CharStatusEx or STATE_OPENHEATH;
  CharStatus   := GetCharStatus;
  SendRefMsg(RM_OPENHEALTH, 0, WAbil.HP{lparam1}, WAbil.MaxHP{lparam2}, 0, '');
end;

procedure TCreature.BreakOpenHealth;
begin
  if BoOpenHealth then begin
    BoOpenHealth := False;
    CharStatusEx := CharStatusEx xor STATE_OPENHEATH;
    CharStatus   := GetCharStatus;
    SendRefMsg(RM_CLOSEHEALTH, 0, 0, 0, 0, '');
  end;
end;

//hiter는 nil일 수 있음
function TCreature.GetHitStruckDamage(hiter: TCreature; damage: integer): integer;
  //내 방어력을 감안하여 데미지 계산
var
  armor: integer;
begin
  //   armor := Lobyte(WAbil.AC) + Random(ShortInt(Hibyte(WAbil.AC)-Lobyte(WAbil.AC)) + 1);
  armor  := Lobyte(WAbil.AC) + Random(integer(Hibyte(WAbil.AC) - Lobyte(WAbil.AC)) + 1);
  damage := _MAX(0, damage - armor);
  if (LifeAttrib = LA_UNDEAD) and (hiter <> nil) then begin
    damage := damage + hiter.AddAbil.UndeadPower;
  end;
  if damage > 0 then begin
    if BoAbilMagBubbleDefence then begin
      damage := Round(damage / 100 * (MagBubbleDefenceLevel + 2) * 8);
      DamageBubbleDefence;
    end;
  end;
  Result := damage;
end;

//hiter는 nil일 수 있음
function TCreature.GetMagStruckDamage(hiter: TCreature; damage: integer): integer;
  //내 마항력을 감안하여 데미지 계산
var
  armor: integer;
begin
  //   armor := Lobyte(WAbil.MAC) + Random(ShortInt(Hibyte(WAbil.MAC)-Lobyte(WAbil.MAC)) + 1);
  armor  := Lobyte(WAbil.MAC) + Random(integer(Hibyte(WAbil.MAC) -
    Lobyte(WAbil.MAC)) + 1);
  damage := _MAX(0, damage - armor);
  if (LifeAttrib = LA_UNDEAD) and (hiter <> nil) then begin
    damage := damage + hiter.AddAbil.UndeadPower;
  end;
  if damage > 0 then begin
    if BoAbilMagBubbleDefence then begin
      damage := Round(damage / 100 * (MagBubbleDefenceLevel + 2) * 8);
      DamageBubbleDefence;
    end;
  end;
  Result := damage;
end;

procedure TCreature.StruckDamage(damage: integer; hiter: TCreature);
var
  i, wdam, adura, old: integer;
  bocalc: boolean;
  hum:    TUserHuman;
  ps:     PTStdItem;
begin
  if damage > 0 then begin
    // 2003/03/04 마지막 히터 수정
    if (hiter <> nil) then
      SetLastHiter(hiter);

    //피해를 입음.
    //장비에 피해를 입는다.
    wdam := Random(10) + 5;

    if StatusArr[POISON_DAMAGEARMOR] > 0 then begin
      //방어력이 떨어지는 독, 장비가 빨리 깨진다.
      //damage는 20% 늘어난다.
      //         wdam := Round(wdam * 1.2);
      //         damage := Round(damage * 1.2);
      //level에 따라 다르게 적용
      wdam   := Round(wdam * ((10 + RedPoisonLevel) / 10));
      damage := Round(damage * ((10 + RedPoisonLevel) / 10));
    end;
    // 스턴중일 경우 데미지는 1.2배 상승
    if StatusArr[POISON_STUN] > 0 then begin
      //       MainOutMessage ('[상태이상] 스턴시 데미지 1.2배');
      damage := Round(damage * 1.2);
    end;

    bocalc := False;
    if (UseItems[U_DRESS].Index > 0) and (UseItems[U_DRESS].Dura > 0) then
    begin //옷은 기본으로 닳는다.
      adura := UseItems[U_DRESS].Dura;
      old   := Round(adura / 1000);
      adura := adura - wdam;
      if adura <= 0 then begin
            (*if RaceServer = RC_USERHUMAN then begin
               hum := TUserHuman(self);
               hum.SendDelItem (UseItems[U_DRESS]); //클라이언트에 없어진거 보냄
               //닳아 없어진거 로그 남김
               AddUserLog ('3'#9 +  //닳음_ +
                           MapName + ''#9 +
                           IntToStr(CX) + ''#9 +
                           IntToStr(CY) + ''#9 +
                           UserName + ''#9 +
                           UserEngine.GetStdItemName (UseItems[U_DRESS].Index) + ''#9 +
                           IntToStr(UseItems[U_DRESS].MakeIndex) + ''#9 +
                           IntToStr(BoolToInt(RaceServer = RC_USERHUMAN)) + ''#9 +
                           '0');

               UseItems[U_DRESS].Index := 0;
               hum.FeatureChanged;
            end;
            UseItems[U_DRESS].Dura := 0;
            UseItems[U_DRESS].Index := 0;    *)

        SysMsg(Format(sItemDuraZero,
          [UserEngine.GetStdItemName(UseItems[U_DRESS].Index)]), 0);
        UseItems[U_DRESS].Dura := 0;
        SendMsg(self, RM_DURACHANGE, U_DRESS, UseItems[U_DRESS].Dura,
          UseItems[U_DRESS].DuraMax, 0, '');
        bocalc := True;
      end else
        UseItems[U_DRESS].Dura := adura;

      if old <> Round(adura / 1000) then begin
        //내구성이 변함
        SendMsg(self, RM_DURACHANGE, U_DRESS, adura,
          UseItems[U_DRESS].DuraMax, 0, '');
      end;
    end;
    // 2003/03/15 아이템 인벤토리 확장
    // 2003/04/01 아이템 내구 조정
    for i := 1 to 11 do begin  // 8->11...수호석은 내구 없음, 부적도 내구 않닳음
      if (UseItems[i].Index > 0) and (UseItems[i].Dura > 0) and
        (Random(8) = 0) and (i <> U_BUJUK) then begin
        //왼쪽 팔에 찬 부적,독가루일 경우 내구가 닳지 않는다(sonmg 2004/06/30)
        if i = U_ARMRINGL then begin
          ps := UserEngine.GetStdItem(UseItems[i].Index);
          if ps <> nil then begin
            //부적,독가루
            if ps.StdMode = 25 then
              continue;
          end;
        end;
        adura := UseItems[i].Dura;
        old   := Round(adura / 1000);
        adura := adura - wdam;
        if adura <= 0 then begin
               (*if RaceServer = RC_USERHUMAN then begin
                  hum := TUserHuman(self);
                  hum.SendDelItem (UseItems[i]); //클라이언트에 없어진거 보냄
                  //닳아 없어진거 로그 남김
                  AddUserLog ('3'#9 +  //닳음_ +
                           MapName + ''#9 +
                           IntToStr(CX) + ''#9 +
                           IntToStr(CY) + ''#9 +
                           UserName + ''#9 +
                           UserEngine.GetStdItemName (UseItems[i].Index) + ''#9 +
                           IntToStr(UseItems[i].MakeIndex) + ''#9 +
                           IntToStr(BoolToInt(RaceServer = RC_USERHUMAN)) + ''#9 +
                           '0');
                  UseItems[i].Index := 0;
                  hum.FeatureChanged;
               end;
               UseItems[i].Dura := 0;
               UseItems[i].Index := 0; *)

          SysMsg(Format(sItemDuraZero,
            [UserEngine.GetStdItemName(UseItems[i].Index)]), 0);
          UseItems[i].Dura := 0;
          SendMsg(self, RM_DURACHANGE, i, UseItems[i].Dura,
            UseItems[i].DuraMax, 0, '');
          bocalc := True;
        end else
          UseItems[i].Dura := adura;

        if old <> Round(adura / 1000) then begin
          //내구성이 변함
          SendMsg(self, RM_DURACHANGE, i, adura, UseItems[i].DuraMax, 0, '');
        end;
      end;
    end;
    if bocalc then begin
      RecalcAbilitys; //무기가 다 닳았으면 능력치 다시 계산
      SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
      SendMsg(self, RM_SUBABILITY, 0, 0, 0, 0, '');
    end;
    //체력이 닳는다.

    try

      if RaceServer = RC_CLONE then begin
        if (not Death) and (not BoGhost) and (Master <> nil) and
          (Master.RaceServer = RC_USERHUMAN) and (not Master.BoGhost) and
          (not Master.Death) and (Master.WAbil.MP > 0) then begin
          if (Master.WAbil.MP >= (damage div 5)) then begin
            Master.WAbil.MP := Master.Wabil.MP - (damage div 5);
          end else begin
            Master.WAbil.MP := 0;
          end;

          Master.healthspellchanged;

        end;
      end;

      // 인간이 아닐때 스톤이 되고 맞으면 풀린다.
      if (RaceServer <> RC_USERHUMAN) and (StatusArr[POISON_DONTMOVE] > 1) then
        StatusArr[POISON_DONTMOVE] := 1;

    except
      MainOutMessage('EXCEPTION CLONE HP CACULATE');
    end;

    DamageHealth(damage, 0);
  end;
UseBlizzard := False;
RevivalMode := False;
end;

 //damage : if (+) damage health
 //         if (-) healing health
procedure TCreature.DamageHealth(damage, minimum: integer);
var
  spdam: integer;
begin
  if BoMagicShield and (damage > 0) and (WAbil.MP > 0) then begin
    spdam := Round(damage * 1.5);
    if integer(WAbil.MP) >= spdam then begin
      WAbil.MP := WAbil.MP - spdam;
      spdam    := 0;
    end else begin
      spdam    := spdam - WAbil.MP;
      WAbil.MP := 0;
    end;
    damage := Round(spdam / 1.5);
    HealthSpellChanged;
  end;
  if damage > 0 then begin
    if integer(WAbil.HP) - damage > 0 then
      WAbil.HP := WAbil.HP - damage
    else
      WAbil.HP := _MAX(minimum, 0);  // 2004/07/14 sonmg
  end else begin
    if integer(WAbil.HP) - damage < WAbil.MaxHP then
      WAbil.HP := WAbil.HP - damage
    else
      WAbil.HP := WAbil.MaxHP;
  end;
end;

 //val : (+) dec spell
 //      (-) inc spell
procedure TCreature.DamageSpell(val: integer);
begin
  if val > 0 then begin
    if WAbil.MP - val > 0 then
      WAbil.MP := WAbil.MP - val
    else
      WAbil.MP := 0;
  end else begin
    if WAbil.MP - val < WAbil.MaxMP then
      WAbil.MP := WAbil.MP - val
    else
      WAbil.MP := WAbil.MaxMP;
  end;
end;

//내 기준으로 잡은 몹의 경험치를 계산
function TCreature.CalcGetExp(targlevel, targhp: integer): integer;
begin
  if Abil.Level < (targlevel + 10) then
    Result := targhp
  else
    Result := targhp - Round((targhp / 15) * (Abil.Level - (targlevel + 10)));
  if Result <= 0 then
    Result := 1;
end;

{
<그룹원 수에 따른 경험치 증가치>
명수   : 2    3    4    5    6    7    8    9  10   11
증가치 : 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.1, 2.2

<수식>
경험치 X 그룹원수에따른 경험치증가분 X 자신의 레벨 / 그룹원 전체레벨의 합

<설명>
그룹원 전체의 레벨의 합 중 자신이 차지하는 레벨만큼 증가된 경험치를 나눠가짐
}
procedure TCreature.GainExp(exp: longword);
var
  i, n, sumlv: integer;
  dexp, iexp: longword;
  cret: TCreature;
const
  bonus: array[0..GROUPMAX] of real =
    (1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2, 2.1, 2.2);
begin
  try
    if GroupOwner <> nil then begin
      sumlv := 0;
      n     := 0;
      for i := 0 to GroupOwner.GroupMembers.Count - 1 do begin
        cret := TCreature(GroupOwner.GroupMembers.Objects[i]);
        if not cret.Death and (PEnvir = cret.PEnvir) and
          (abs(CX - cret.CX) <= 12) and (abs(CY - cret.CY) <= 12) then begin
          sumlv := sumlv + cret.Abil.Level;
          Inc(n);
        end;
      end;
      if (sumlv > 0) and (n > 1) then begin
        dexp := 0;
        if n in [0..GROUPMAX] then
          dexp := Round(exp * bonus[n]);
        for i := 0 to GroupOwner.GroupMembers.Count - 1 do begin
          cret := TCreature(GroupOwner.GroupMembers.Objects[i]);
          if not cret.Death and (PEnvir = cret.PEnvir) and
            (abs(CX - cret.CX) <= 12) and (abs(CY - cret.CY) <= 12) then begin
            iexp := Round(dexp / sumlv * cret.Abil.Level);
            if iexp > exp then
              iexp := exp;
            cret.WinExp(iexp);
          end;
        end;
      end else
        WinExp(exp);
    end else
      WinExp(exp);
  except
    MainOutMessage('[Exception] TCreature.GainExp');
  end;
end;

//몬스터도 부하인 경우 경험치를 먹음
procedure TCreature.GainSlaveExp(exp: integer);

  function NextExp: integer;
  const
    slaveupexp: array[0..6] of integer = (0, 0, 50, 100, 200, 300, 600);
  var
    more: integer;
  begin
    if SlaveExpLevel in [0..6] then
      more := slaveupexp[SlaveExpLevel]
    else
      more := 0;
    Result := 100 + (Abil.Level * 15) + more;
    //+ more
    //+ (Abil.MaxHP div 100) * 30;  //체력에 따라
  end;

begin

  // 월령 또는 분신일 경우에는 경험치를 먹지 않는다.
  if (RaceServer = RC_CLONE) or (RaceServer = RC_ANGEL) then
    Exit;

  SlaveExp := SlaveExp + exp;
  if SlaveExp > NextExp then begin
    SlaveExp := SlaveExp - NextExp;
    if SlaveExpLevel < (SlaveMakeLevel * 2 + 1) then begin
      Inc(SlaveExpLevel);
      RecalcAbilitys; //ApplySlaveLevelAbilitys;
      ChangeNameColor;
    end;
  end;
end;

//[주의] 리셋 상태에서 포인트를 올린다.
procedure TCreature.ApplySlaveLevelAbilitys;
var
  i, chp: integer;
begin

  if (RaceServer = RC_ANGEL) or (RaceServer = RC_CLONE) then
    Exit;

  chp := 0;
  if (RaceServer = RC_WHITESKELETON) or //백골
    (RaceServer = RC_ELFMON) or (RaceServer = RC_ELFWARRIORMON) then begin

    WAbil.DC := MakeWord(Lobyte(WAbil.DC), Hibyte(Abil.DC));

    WAbil.DC := MakeWord(Lobyte(WAbil.DC), Round(Hibyte(WAbil.DC) +
      (3 * (0.3 + SlaveExpLevel * 0.1) * SlaveExpLevel)));
    chp      := chp + Round(Abil.MaxHP * (0.3 + SlaveExpLevel * 0.1)) * SlaveExpLevel;

    chp := Abil.MaxHP + chp;
    if SlaveExpLevel > 0 then begin
      WAbil.MaxHP := chp; //_MIN(Round(Abil.MaxHP + 60 * SlaveExpLevel), chp);
      //Round(Abil.MaxHP * SlaveExpLevel * 1.2))
    end else
      WAbil.MaxHP := Abil.MaxHP;
    //2003/03/15 신규무공 추가
    WAbil.DC := MakeWord(Lobyte(WAbil.DC), Hibyte(WAbil.DC) +
      ExtraAbil[EABIL_DCUP]);
  end else begin   //술사가 꼬신몹
    if Master <> nil then // 술사가 꼬신거는 Master 가 nil 이 아님
    begin

      chp := Abil.MaxHP;

      WAbil.DC := MakeWord(Lobyte(WAbil.DC), Hibyte(Abil.DC));

      WAbil.DC := MakeWord(Lobyte(WAbil.DC), Round(Hibyte(WAbil.DC) +
        (2 * SlaveExpLevel)));
      chp      := chp + Round(Abil.MaxHP * 0.15) * SlaveExpLevel;

      WAbil.MaxHP := _MIN(Round(Abil.MaxHP + 60 * SlaveExpLevel), chp);
      WAbil.MAC   := 0;  //테이밍몹은 마법에 약함
      //Round(Abil.MaxHP * SlaveExpLevel * 1.2))
    end;

  end;

  AccuracyPoint := 15; //정확도,.. (테이밍몹,소환몹은 정확이 15로 고정)

end;

//경험치를 얻음, 레벨업 체크
procedure TCreature.WinExp(exp: longword);
var
  ExpRate:  integer;
  exptotal: longword;
begin
  // 경험치 오류 문제
  if exp >= 60000 then
    exp := 60000;

  // 경험치 적용
  ExpRate := 100;

  // 순간 경험치 두 배 적용(2005/12/14)
  if InstantExpDoubleTime > GetTickCount then begin
    ExpRate := ExpRate * 2;
  end;

  case ExpRate of
    100: begin
      Abil.Exp := Abil.Exp + exp;
      exptotal := exp;
    end;
    120: begin
      Abil.Exp := Abil.Exp + exp + (exp div 5);
      exptotal := exp + (exp div 5);
    end;
    130: begin
      Abil.Exp := Abil.Exp + exp + (exp div 3);
      exptotal := exp + (exp div 3);
    end;
    150: begin
      Abil.Exp := Abil.Exp + exp + (exp div 2);
      exptotal := exp + (exp div 2);
    end;
    200: begin
      Abil.Exp := Abil.Exp + exp + exp;
      exptotal := exp + exp;
    end;
{
   300 : begin
           Abil.Exp := Abil.Exp + exp + exp + exp;
           exptotal := exp + exp + exp;
         end;
}
    else begin
      Abil.Exp := Abil.Exp + exp * longword(ExpRate div 100);
      exptotal := exp * longword(ExpRate div 100);
    end;
  end;

  //경험치 한계(65000) sonmg 2005/12/09
  exptotal := _MIN(65000, exptotal);


  //클라이언트에 획득한 경험치 전송
  SendMsg(self, RM_WINEXP, 0, exptotal, 0, 0, '');


  //경험치 먹을 때마다 행운치 오름
  AddBodyLuck(exp * 0.002);

  if Abil.Exp >= Abil.MaxExp then begin
    Abil.Exp := Abil.Exp - Abil.MaxExp;
    Inc(Abil.Level);
    HasLevelUp(Abil.Level - 1);
    AddBodyLuck(100);   //렙업때마다 행운 값이 오른다.
    AddUserLog('12'#9 + //렙업_ +
      MapName + ''#9 + IntToStr(Abil.Level) + ''#9 + IntToStr(Abil.Exp) +
      ''#9 + UserName + ''#9 + '0'#9 + '0'#9 + '1'#9 + '0');
    //렙업하면 체력이 만땅참,  9/25일부터 적용
    IncHealthSpell(2000, 2000);
  end;
end;

procedure TCreature.HasLevelUp(prevlevel: integer);
begin
  Abil.MaxExp := GetNextLevelExp(Abil.Level);  //다음 레벨을 올리는데 필요한 경험치
  //if prevlevel <> 0 then begin
  RecalcLevelAbilitys;  //레벨에 따른 능력치를 계산한다.
  //end else
  //RecalcLevelAbilitys_old;

{$IFDEF FOR_ABIL_POINT}
//4/16일 부터 적용
   if prevlevel + 1 = Abil.Level then begin
      BonusPoint := BonusPoint + GetBonusPoint (Job, Abil.Level);  //렙업에 따른 보너스
      SendMsg (self, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
   end else begin
      if prevlevel <> Abil.Level then begin
         //보너스 포인트를 처음부터 다시 계산한다.
         BonusPoint := GetLevelBonusSum (Job, Abil.Level);
         FillChar (BonusAbil, sizeof(TNakedAbility), #0);
         FillChar (CurBonusAbil, sizeof(TNakedAbility), #0);
         //if prevlevel <> 0 then begin
         RecalcLevelAbilitys;  //레벨에 따른 능력치를 계산한다.
         //end else begin
         //   RecalcLevelAbilitys_old;
         //   BonusPoint := 0;
         //end;
         SendMsg (self, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
      end;
   end;
{$ENDIF}

  RecalcAbilitys;
  SendRefMsg(RM_LOOPNORMALEFFECT, integer(self), 0, 0, NE_LEVELUP, '');
  SendMsg(self, RM_LEVELUP, 0, Abil.Exp, 0, 0, '');

  //체험판 사용자는 체험판 레벨이상 올릴 수 없다.(sonmg 2005/03/17)
  if RaceServer = RC_USERHUMAN then begin
    if TUserHuman(self).ApprovalMode = 1 then begin
      if Abil.Level > EXPERIENCELEVEL then begin
        SysMsg(Format(sTrialModeUp, [EXPERIENCELEVEL]), 0);
        SysMsg(sConnectionTerminated, 0);
        TUserHuman(self).EmergencyClose := True;
      end;
    end;
  end;
end;

function TCreature.GetNextLevelExp(lv: integer): longword;  //상수로 정하기로 함
begin
  if lv in [1..MAXLEVEL] then
    Result := NEEDEXPS[lv]
  else
    Result := $7FFFFFFF;  // 수정 (sonmg 2005/05/13)
end;

procedure TCreature.ChangeLevel(level: integer);
begin
  if level in [1..40] then
    Abil.Level := level;
end;

//싸움을 못하는 안전지대
function TCreature.InSafeZone: boolean;
var
  i: integer;
  mp: PTMapPoint;
begin
  Result := PEnvir.Lawfull;
  if not Result then begin
    Result := (PEnvir.MapName = BADMANHOMEMAP) and
      ((abs(CX - BADMANSTARTX) <= 10) and (abs(CY - BADMANSTARTY) <= 10));
    if not Result then begin
      // 스타트 포인트는 안전지대
      for i := 0 to StartPoints.Count - 1 do begin
        mp := PTMapPoint(StartPoints[i]);
        if (mp.MapName = PEnvir.MapName) and ((abs(CX - mp.PointX) <= mp.Scope) and
          (abs(CY - mp.PointY) <= mp.Scope)) then begin
          Result := True;
          break;
        end;
      end;

      // 세이프 포인트도 안전지대
      for i := 0 to SafePoints.Count - 1 do begin
        mp := PTMapPoint(SafePoints[i]);
        if (mp.MapName = PEnvir.MapName) and ((abs(CX - mp.PointX) <= mp.Scope) and
          (abs(CY - mp.PointY) <= mp.Scope)) then begin
          Result := True;
          break;
        end;
      end;

    end;
  end;
end;

//문파전을 못하는 안전 지대
function TCreature.InGuildWarSafeZone: boolean;
var
  i: integer;
  mp: PTMapPoint;
begin
  Result := PEnvir.Lawfull;
  if not Result then begin
    if not Result then begin
      for i := 0 to StartPoints.Count - 1 do begin
        mp := PTMapPoint(StartPoints[i]);
        if (mp.MapName = PEnvir.MapName) and ((abs(CX - mp.PointX) <= 60) and (abs(CY - mp.PointY) <= 60))
        then begin
          Result := True;
          break;
        end;
      end;
    end;
  end;
end;

function TCreature.PKLevel: integer;       //PK 레벨 1이상으면 PK범 이다.
begin
  Result := PlayerKillingPoint div 100;
end;

procedure TCreature.UserNameChanged;
begin
  SendRefMsg(RM_USERNAME, 0, 0, 0, 0, GetUserName);
end;

procedure TCreature.ChangeNameColor;
begin
  SendRefMsg(RM_CHANGENAMECOLOR, 0, 0, 0, 0, '');
end;

function TCreature.MyColor: byte;
begin
  Result := DefNameColor;
  if PKLevel = 1 then
    Result := 251; //yellow
  if PKLevel >= 2 then
    Result := 249;  //red
end;

//self가 cret을 봤을때 cret의 색을 리턴한다(sonmg 2005/11/29)
function TCreature.GetThisCharColor(cret: TCreature): byte;
const
  SlaveColors: array[0..7] of byte = (255, 254, 147, 154, 229, 168, 180, 252);
var
  relat:  integer;
  pkarea: boolean;
  CheckAllyGuild: boolean;
begin
  Result := cret.MyColor;
  if cret.RaceServer = RC_USERHUMAN then begin //사람
    if PKLevel < 2 then begin  //흰둥이=0(또는 노랭이=1) 인 경우

      if cret.BoIllegalAttack then
        Result := 47; //갈색계열

      relat := GetGuildRelation(self, cret);
      case relat of
        1, 3: Result := 180; //푸른계열 (우리편)
        2: Result    := 69;  //주황색계열
      end;

      if cret.PEnvir.Fight3Zone then begin  //문파 대련장 안에 있음
        if MyGuild = cret.MyGuild then  //같은편
          Result := 180 //푸른계열
        else  //다른 편
          Result := 69;  //주황색계열
      end;
    end;

    //공성전 관련 색
    if UserCastle.BoCastleUnderAttack then begin  //공성전 중인 경우
      if BoInFreePKArea and cret.BoInFreePKArea then begin
        //프리피케이존(전쟁터)에 있음, 공성 지역에 있음
        Result := 221;  //적도아니고 우리편도 아니면 녹색으로 보인다.
        BoGuildWarArea := True; //공성전 지역

        if (UserCastle.OwnerGuild <> nil) and (MyGuild <> nil) then
          CheckAllyGuild :=
            TGuild(UserCastle.OwnerGuild).IsAllyGuild(TGuild(MyGuild))
        else
          CheckAllyGuild := False;

        // 2003/06/12 수성 문파 뿐만 아니라 수성문파 연합 문파인경우도 해당되도록 수정
        //          if UserCastle.IsOurCastle (TGuild(MyGuild)) then begin
        if UserCastle.IsOurCastle(TGuild(MyGuild)) or CheckAllyGuild then begin
          //성을 지키는 입장
          if (MyGuild = cret.MyGuild) or
            TGuild(MyGuild).IsAllyGuild(TGuild(cret.MyGuild)) then  //우리문파,동맹문파
            Result := 180 //푸른계열 (우리편)
          else if UserCastle.IsRushCastleGuild(TGuild(cret.MyGuild)) then
            Result := 69;   //공격하고 있는 문파, 적
        end else begin
          //성을 공격하는 입장
          if UserCastle.IsRushCastleGuild(TGuild(MyGuild)) then begin
            //우립문파가 공격하고 있음
            if (MyGuild = cret.MyGuild) or TGuild(
              MyGuild).IsAllyGuild(TGuild(cret.MyGuild)) then begin
              //우리 문파원 임, 동맹 문파원
              Result := 180; //푸른계열 (우리편)
            end else begin
              if UserCastle.IsCastleMember(TUserHuman(cret)) then
                Result := 69; //성을 차지한 문파는 적으로 보인다.
            end;
          end;
        end;
      end;
    end;

  end else begin  //몬스터

    try
      if (cret.RaceServer = RC_CLONE) then begin
        if (cret.Master <> nil) and (cret.Master.RaceServer = RC_USERHUMAN) then
        begin
          Result := cret.Master.MyColor;
        end;
      end else begin
        if cret.SlaveExpLevel in [0..7] then
          Result := SlaveColors[cret.SlaveExpLevel];
        if cret.BoCrazyMode then
          Result := 249;  //red 폭주상태
        if cret.BoGoodCrazyMode then
          Result := 253;  //violet 곱게미친상태 (색깔조정)
        if cret.BoHolySeize then
          Result := 125;
      end;
    except
      MainOutMessage('EXCEPT CHARCOLOR');
    end;

  end;
end;

 // 0: 상관관계없음
 // 1: 우리 문파
 // 2: 적대 관계
 // 3: 동맹관계
function TCreature.GetGuildRelation(onecret, twocret: TCreature): integer;
begin
  Result := 0;
  BoGuildWarArea := False;
  if (onecret.MyGuild <> nil) and (twocret.MyGuild <> nil) then begin
    if onecret.InGuildWarSafeZone or twocret.InGuildWarSafeZone then begin
      Result := 0;  //문파전 금지 구역
    end else begin
      if TGuild(onecret.MyGuild).KillGuilds.Count > 0 then begin
        BoGuildWarArea := True;
        if TGuild(onecret.MyGuild).IsHostileGuild(TGuild(twocret.MyGuild)) and
          TGuild(twocret.MyGuild).IsHostileGuild(TGuild(onecret.MyGuild))
        then begin
          Result := 2; //69;  //주황색계열, 적
        end;
        if TGuild(onecret.MyGuild) = TGuild(twocret.MyGuild) then begin
          Result := 1; //180; //푸른계열 (우리편)
        end;
        if (TGuild(onecret.MyGuild).IsAllyGuild(TGuild(twocret.MyGuild))) and
          (TGuild(twocret.MyGuild).IsAllyGuild(TGuild(onecret.MyGuild))) then
          Result := 3;  //동맹관계
      end;
    end;
  end;
end;

function TCreature.IsGuildMaster: boolean;
begin
  if (MyGuild <> nil) and (GuildRank = 1) then
    Result := True
  else
    Result := False;
end;

function TCreature.IsMyGuildMaster: boolean;
var
  guildagit: TGuildAgit;
begin
  Result := False;

  if (MyGuild <> nil) and (GuildRank = 1) then begin
    //다른 문주이면 FALSE.
    // 문주의 장원 번호와 현재 있는 맵의 장원번호가 일치 해야함.
    guildagit := GuildAgitMan.GetGuildAgit(TGuild(MyGuild).GuildName);
    if guildagit <> nil then begin
      if (guildagit.GuildAgitNumber > -1) and
        (guildagit.GuildAgitNumber = PEnvir.GuildAgit) then begin
        Result := True;
      end;
    end;
  end;
end;

function TCreature.GetGuildNameHereAgit: string;
var
  guildagit: TGuildAgit;
begin
  Result := '';

  // 현재 있는 맵의 장원 문파를 얻는다.
  if PEnvir.GuildAgit > -1 then begin
    Result := GuildAgitMan.GetGuildNameFromAgitNum(PEnvir.GuildAgit);
  end;

{
   if MyGuild <> nil then begin
      // 가입된 문파와 현재 있는 맵의 장원의 문파가 일치 해야함.
      guildagit := GuildAgitMan.GetGuildAgit( TGuild(MyGuild).GuildName );
      if guildagit <> nil then begin
         if (guildagit.GuildAgitNumber > -1 ) and (guildagit.GuildAgitNumber = PEnvir.GuildAgit) then begin
            Result := TRUE;
         end;
      end;
   end;
}
end;

function TCreature.GetGuildMasterNameHereAgit: string;
var
  guildagit: TGuildAgit;
begin
  Result := '';

  // 현재 있는 맵의 장원 문파를 얻는다.
  if PEnvir.GuildAgit > -1 then begin
    Result := GuildAgitMan.GetGuildMasterNameFromAgitNum(PEnvir.GuildAgit);
  end;
end;

procedure TCreature.IncPKPoint(point: integer);
var
  old: integer;
begin
  old := PKLevel;
  //if old >= 2 then point := point * 2; //가중처벌
  //PkPoint 100만으로 제한(sonmg 2005/04/14)
  PlayerKillingPoint := _MIN(1000000, PlayerKillingPoint + point);
  if (old <> PKLevel) and (PKLevel <= 2) then begin
    ChangeNameColor;
  end;
end;

procedure TCreature.DecPKPoint(point: integer);
var
  old: integer;
begin
  old := PKLevel;
  PlayerKillingPoint := PlayerKillingPoint - point;
  if PlayerKillingPoint < 0 then
    PlayerKillingPoint := 0;
  if (old <> PKLevel) and (old > 0) and (old <= 2) then begin
    ChangeNameColor;
  end;
end;

function TCreature.GetPKTimeMin: string;
begin
{
   //틀린 코드... 2를 곱해야 함.
   if PlayerKillingPoint  < (60 * 24) then
      result := '24시간이내'
   else if PlayerKillingPoint  < ( 60 * 24  * 7 )then
      result := '1~7 일이내'
   else if PlayerKillingPoint  < ( 60 * 24  * 14) then
      result := '8~14 일이내'
   else if PlayerKillingPoint  < ( 60 * 24  * 30) then
      result := '15~30 일이내'
   else result := '한달이상'
}
  //PkPoint 1점 감소되는데 2분 소요.
  Result := IntToStr(Round((PlayerKillingPoint * 2) / 60)) + ' Hours';
end;

procedure TCreature.AddBodyLuck(r: real);
var
  n: integer;
begin
  if (r > 0) and (BodyLuck < 5 * BODYLUCKUNIT) then
    BodyLuck := BodyLuck + r;
  if (r < 0) and (BodyLuck > -(5 * BODYLUCKUNIT)) then
    BodyLuck := BodyLuck + r;

  n := Trunc(BodyLuck / BODYLUCKUNIT);
  if n > 5 then
    n := 5;
  if n < -10 then
    n := -10;
  BodyLuckLevel := n;
end;

function TCreature.IncGold(igold: integer): boolean;
begin
  Result := False;
  if igold < 0 then
    exit; // (sonmg 2005/06/22)

  if int64(Gold) + igold <= AvailableGold then begin
    Gold   := Gold + igold;
    Result := True;
  end;
end;

function TCreature.DecGold(igold: integer): boolean;
begin
  Result := False;
  if igold < 0 then
    Exit;

  if int64(Gold) - igold >= 0 then begin
    Gold   := Gold - igold;
    Result := True;
  end;
end;

function TCreature.CalcBagWeight: integer;
var
  i, w, temp: integer;
  ps: PTStdItem;
begin
  w := 0;
  for i := 0 to ItemList.Count - 1 do begin
    ps := UserEngine.GetStdItem(PTUserItem(Itemlist[i]).Index);
    if ps <> nil then begin
      if ps.OverlapItem = 1 then begin
        temp := PTUserItem(Itemlist[i]).Dura;
        w    := w + (temp div 10);   // 카운트 아이템(1)은 10개당 무게 1
      end else if ps.OverlapItem >= 2 then begin
        temp := PTUserItem(Itemlist[i]).Dura; // 카운트 아이템(2이상)은 1개당 무게 1
        w    := w + temp * ps.Weight;
      end else begin
        w := w + ps.Weight;
      end;
    end;
  end;
  Result := w;
end;

function TCreature.CalcWearWeightEx(windex: integer): integer;
var
  i, w: integer;
  ps:   PTStdItem;
begin
  w := 0;
  // 2003/03/15 아이템 인벤토리 확장
  for i := 0 to 12 do begin  //8->12
    if (windex = -1) or (i <> windex) and (i <> U_WEAPON) and (i <> U_RIGHTHAND) then
    begin
      ps := UserEngine.GetStdItem(UseItems[i].Index);
      if ps <> nil then
        w := w + ps.Weight;
    end;
  end;
  Result := w;
end;

{$IFDEF FOR_ABIL_POINT}
//4/16일부터 적용

//자신의 레벨에 맞는 능력치
//사용안함.
procedure TCreature.RecalcLevelAbilitys;  //보너스 포인트 적용시
var
   n, mlevel: integer;
begin
{  보너스 포인트에 대한 능력치 조정
   현재, 사용하지 않음  }
   if Abil.Level > ADJ_LEVEL then mlevel := ADJ_LEVEL
   else mlevel := Abil.Level;
   case Job of
      0: //warrior
         begin
            Abil.MaxWeight := 50 + Round((Abil.Level / 3) * Abil.Level);
            Abil.MaxWearWeight := _MIN(255, 15 + Round((Abil.Level / 20) * Abil.Level));
            // 2003/02/11 최대무게 255로 제한
            if( (12 + Round((Abil.Level / 13) * Abil.Level)) > 255 ) then Abil.MaxHandWeight := 255
            else
               Abil.MaxHandWeight := 12 + Round((Abil.Level / 13) * Abil.Level);
            Abil.MaxHP := DEFHP + Round((mlevel / 4 + 4) * mlevel);
            Abil.MaxMP := DEFMP + mlevel * 2;
            Abil.DC := MakeWord(_MAX(mlevel div 7 - 1, 1), _MAX(1, mlevel div 5));
            Abil.SC := 0;
            Abil.MC := 0;
            Abil.AC := MakeWord(0, mlevel div 7);
            Abil.MAC := 0;
         end;
      1: //wizard
         begin
            Abil.MaxWeight := 50 + Round((Abil.Level / 5{4.2}) * Abil.Level);
            Abil.MaxWearWeight := 15 + Round((Abil.Level / 100) * Abil.Level);
            Abil.MaxHandWeight := 12 + Round((Abil.Level / 90) * Abil.Level);
            Abil.MaxHP := DEFHP + Round((mlevel / 15{18/30} + 1.8) * mlevel);
            Abil.MaxMP := DEFMP + Round((mlevel / 5 + 2)*2.2 * mlevel);
            n := mlevel div 7;
            Abil.DC := MakeWord(_MAX(n-1, 0), _MAX(1, n));
            Abil.MC := MakeWord(_MAX(n-1, 0), _MAX(1, n));
            Abil.SC := 0;
            Abil.AC := 0;
            Abil.MAC := 0;
         end;
      2: //taoist
         begin
            Abil.MaxWeight := 50 + Round((Abil.Level / 4{3.5}) * Abil.Level);
            Abil.MaxWearWeight := 15 + Round((Abil.Level / 50) * Abil.Level);
            Abil.MaxHandWeight := 12 + Round((Abil.Level / 42) * Abil.Level);
            Abil.MaxHP := DEFHP + Round((mlevel / 6{13} + 2.5) * mlevel);
            Abil.MaxMP := DEFMP + Round((mlevel / 8)*2.2 * mlevel);
            n := mlevel div 7;
            Abil.DC := MakeWord(_MAX(n-1, 0), _MAX(1, n));
            Abil.MC := 0;
            Abil.SC := MakeWord(_MAX(n-1, 0), _MAX(1, n));
            Abil.AC := 0;
            n := Round(mlevel / 6);
            Abil.MAC := MakeWord(n div 2, n+1);
         end;
      3: //assassin
         begin
            Abil.MaxWeight := 50 + Round((Abil.Level / 3) * Abil.Level);
            Abil.MaxWearWeight := _MIN(255, 15 + Round((Abil.Level / 20) * Abil.Level));
            // 2003/02/11 최대무게 255로 제한
            if( (12 + Round((Abil.Level / 13) * Abil.Level)) > 255 ) then Abil.MaxHandWeight := 255
            else
               Abil.MaxHandWeight := 12 + Round((Abil.Level / 13) * Abil.Level);
            Abil.MaxHP := DEFHP + Round((mlevel / 4 + 4) * mlevel);
            Abil.MaxMP := DEFMP + mlevel * 2;
            Abil.DC := MakeWord(_MAX(mlevel div 7 - 1, 1), _MAX(1, mlevel div 5));
            Abil.SC := 0;
            Abil.MC := 0;
            Abil.AC := MakeWord(0, mlevel div 7);
            Abil.MAC := 0;
         end;
   end;
   Abil.MaxHP := Abil.MaxHP + BonusAbil.HP;
   Abil.MaxMP := Abil.MaxMP + BonusAbil.MP;
   Abil.DC := MakeWord(Lobyte(Abil.DC) + Lobyte(BonusAbil.DC), Hibyte(Abil.DC) + Hibyte(BonusAbil.DC));
   Abil.SC := MakeWord(Lobyte(Abil.SC) + Lobyte(BonusAbil.SC), Hibyte(Abil.SC) + Hibyte(BonusAbil.SC));
   Abil.MC := MakeWord(Lobyte(Abil.MC) + Lobyte(BonusAbil.MC), Hibyte(Abil.MC) + Hibyte(BonusAbil.MC));
   Abil.AC  := MakeWord(Lobyte(Abil.AC) + Lobyte(BonusAbil.AC), Hibyte(Abil.AC) + Hibyte(BonusAbil.AC));
   Abil.MAC := MakeWord(Lobyte(Abil.MAC) + Lobyte(BonusAbil.MAC), Hibyte(Abil.MAC) + Hibyte(BonusAbil.MAC));

   if Abil.HP > Abil.MaxHP then Abil.HP := Abil.MaxHP;
   if Abil.MP > Abil.MaxMP then Abil.MP := Abil.MaxMP;

end;

{$ELSE}

procedure TCreature.RecalcLevelAbilitys;
//procedure TCreature.RecalcLevelAbilitys_old;
var
  n: integer;
begin
  //Abil 계산
  //전사인 경우
  case Job of
    0: //warrior
    begin
      Abil.MaxHP     := 14 + Round((Abil.Level / 4 + 4.5 + (Abil.Level / 20)) *
        Abil.Level);
      Abil.MaxMP     := 11 + Round(Abil.Level * 3.5);
      //Abil.MaxHP := 14 + Round((Abil.Level / 4 + 4) * Abil.Level);
      //Abil.MaxMP := 11 + Abil.Level * 2;
      Abil.MaxWeight := 50 + Round((Abil.Level / 3) * Abil.Level);
      Abil.MaxWearWeight := _MIN(255, 15 + Round((Abil.Level / 20) * Abil.Level));
      // 2003/02/11 최대무게 255로 제한
      if ((12 + Round((Abil.Level / 13) * Abil.Level)) > 255) then
        Abil.MaxHandWeight := 255
      else
        Abil.MaxHandWeight := 12 + Round((Abil.Level / 13) * Abil.Level);
      Abil.DC := MakeWord(_MAX(Abil.Level div 5 - 1, 1),
        _MAX(1, Abil.Level div 5));
      //Abil.DC := MakeWord(_MAX(Abil.Level div 7 - 1, 1), _MAX(1, Abil.Level div 5));
      Abil.SC  := 0;
      Abil.MC  := 0;
      Abil.AC  := MakeWord(0, Abil.Level div 7);
      Abil.MAC := 0;
    end;
    1: //wizard
    begin
      Abil.MaxHP := 14 + Round((Abil.Level / 15{18/30} + 1.8) * Abil.Level);
      //Abil.MaxHP := 14 + Round((Abil.Level / 18 + 1.5) * Abil.Level);
      Abil.MaxMP := 13 + Round((Abil.Level / 5 + 2) * 2.2 * Abil.Level);
      Abil.MaxWeight := 50 + Round((Abil.Level / 5{4.2}) * Abil.Level);
      Abil.MaxWearWeight := 15 + Round((Abil.Level / 100) * Abil.Level);
      Abil.MaxHandWeight := 12 + Round((Abil.Level / 90) * Abil.Level);
      n := Abil.Level div 7;
      Abil.DC := MakeWord(_MAX(n - 1, 0), _MAX(1, n));
      Abil.MC := MakeWord(_MAX(n - 1, 0), _MAX(1, n));
      Abil.SC := 0;
      Abil.AC := 0;
      Abil.MAC := 0; //MakeWord(_MAX(n-1, 0), n);
    end;
    2: //taoist
    begin
      Abil.MaxHP := 14 + Round((Abil.Level / 6{13} + 2.5) * Abil.Level);
      //Abil.MaxHP := 14 + Round((Abil.Level / 13 + 2.5) * Abil.Level);
      Abil.MaxMP := 13 + Round((Abil.Level / 8) * 2.2 * Abil.Level);
      Abil.MaxWeight := 50 + Round((Abil.Level / 4{3.5}) * Abil.Level);
      Abil.MaxWearWeight := 15 + Round((Abil.Level / 50) * Abil.Level);
      Abil.MaxHandWeight := 12 + Round((Abil.Level / 42) * Abil.Level);
      n := Abil.Level div 7;
      Abil.DC := MakeWord(_MAX(n - 1, 0), _MAX(1, n));
      Abil.MC := 0;
      Abil.SC := MakeWord(_MAX(n - 1, 0), _MAX(1, n));
      Abil.AC := 0; //MakeWord(_MAX(n-1, 0), n);
      n := Round(Abil.Level / 6);
      Abil.MAC := MakeWord(n div 2, n + 1);
    end;
    3: //assassin
    begin
      Abil.MaxHP     := 14 + Round((Abil.Level / 4 + 4.5 + (Abil.Level / 20)) *
        Abil.Level);
      Abil.MaxMP     := 11 + Round(Abil.Level * 3.5);
      //Abil.MaxHP := 14 + Round((Abil.Level / 4 + 4) * Abil.Level);
      //Abil.MaxMP := 11 + Abil.Level * 2;
      Abil.MaxWeight := 50 + Round((Abil.Level / 3) * Abil.Level);
      Abil.MaxWearWeight := _MIN(255, 15 + Round((Abil.Level / 20) * Abil.Level));
      // 2003/02/11 최대무게 255로 제한
      if ((12 + Round((Abil.Level / 13) * Abil.Level)) > 255) then
        Abil.MaxHandWeight := 255
      else
        Abil.MaxHandWeight := 12 + Round((Abil.Level / 13) * Abil.Level);
      Abil.DC := MakeWord(_MAX(Abil.Level div 5 - 1, 1),
        _MAX(1, Abil.Level div 5));
      //Abil.DC := MakeWord(_MAX(Abil.Level div 7 - 1, 1), _MAX(1, Abil.Level div 5));
      Abil.SC  := 0;
      Abil.MC  := 0;
      Abil.AC  := MakeWord(0, Abil.Level div 7);
      Abil.MAC := 0;
    end;
  end;

  if Abil.HP > Abil.MaxHP then
    Abil.HP := Abil.MaxHP;
  if Abil.MP > Abil.MaxMP then
    Abil.MP := Abil.MaxMP;

end;

{$ENDIF}

 //정확도, 회피력 재설정..
 //MagicList 에서 기본검술을 찾아서 재설정함..
 //기본검술은 업그레이드되면 하나이다.
procedure TCreature.RecalcHitSpeed;
var
  i:   integer;
  pum: PTUserMagic;
  fin: boolean;
begin
  fin := False;
  AccuracyPoint := DEFHIT + BonusAbil.Hit;
  HitPowerPlus := 0;
  HitDouble := 0;
  case Job of
    2: SpeedPoint := DEFSPEED + BonusAbil.Speed + 3;  //도사는 기본 민첩이 높다.
    else
      SpeedPoint := DEFSPEED + BonusAbil.Speed;
  end;
  PSwordSkill    := nil;
  PPowerHitSkill := nil;
  PslashhitSkill := nil;
  PLongHitSkill  := nil;
  PWideHitSkill  := nil;
  PWideHit2Skill  := nil;
  PFireHitSkill  := nil;
  // 2003/03/15 신규무공
  PCrossHitSkill := nil;
  PTwinHitSkill  := nil;
  PStoneHitSkill := nil;
  for i := 0 to MagicList.Count - 1 do begin
    pum := PTUserMagic(MagicList[i]);
    case pum.MagicId of
      3: //외수검법 (전사 기초 검법)
      begin
        PSwordSkill := pum;  //무공 삭제시 주의해야 한다.
        if pum.Level > 0 then
          AccuracyPoint := AccuracyPoint + Round(9 / 3 * pum.Level);
      end;

      7: //예도검법 (전사의 공격 검법)
      begin
        PPowerHitSkill := pum;
        if pum.Level > 0 then
          AccuracyPoint := AccuracyPoint + Round(3 / 3 * pum.Level);
        HitPowerPlus := 5 + pum.Level;  //파워 5, 6, 7, 8
        AttackSkillCount      := 7 - PPowerHitSkill.Level;
        AttackSkillPointCount := Random(AttackSkillCount);
      end;

      12: //어검술
      begin
        PLongHitSkill := pum;
      end;

      25: //반월검법
      begin
        PWideHitSkill := pum;
      end;

      26: //염화결
      begin
        PFireHitSkill := pum;
        HitDouble     := 4 + pum.Level * 4;  //+40% ~ +160%
      end;

          // 2003/03/15 신규무공
      34: //광풍참
      begin
        HitPowerPlus   := 5 + pum.Level;  //파워 5, 6, 7, 8
        PCrossHitSkill := pum;
      end;

      38: //쌍룡참
      begin
        HitPowerPlus  := pum.Level;  //파워 0, 1, 2, 3
        PTwinHitSkill := pum;
      end;

      43: //사자후
      begin
        HitPowerPlus   := pum.Level;  //파워 0, 1, 2, 3
        PStoneHitSkill := pum;
      end;

      4: //일광검법 (도사 기초검법)
      begin
        PSwordSkill := pum;  //무공 삭제시 주의해야 한다.
        if pum.Level > 0 then
          AccuracyPoint := AccuracyPoint + Round(8 / 3 * pum.Level);
      end;

      59: //Slash
      begin
        PslashhitSkill := pum;
        if pum.Level > 0 then
          AccuracyPoint := AccuracyPoint + Round(3 / 3 * pum.Level);
        HitPowerPlus := 5 + pum.Level;  //파워 5, 6, 7, 8
        AttackSkillCount      := 7 - PslashhitSkill.Level;
        AttackSkillPointCount := Random(AttackSkillCount);
      end;

      60: //Assassin Skill 2
      begin
        PWideHit2Skill := pum;
      end;

    end;
  end;
end;

procedure TCreature.AddMagicWithItem(magic: integer);  //아이템을 착용해서 얻는 마법
var
  pdm: PTDefMagic;
  pum: PTUserMagic;
  hum: TUserHuman;
begin
  pdm := nil;
  if magic = AM_FIREBALL then begin  //화염장
    pdm := UserEngine.GetDefMagic(NAME_OF_FIREBALL);
  end;
  if magic = AM_HEALING then begin
    pdm := UserEngine.GetDefMagic(NAME_OF_HEALING);
  end;
  if pdm <> nil then begin
    if not IsMyMagic(pdm.MagicId) then begin
      new(pum);
      pum.pDef     := pdm;
      pum.MagicId  := pdm.MagicId;
      pum.Key      := #0;
      pum.Level    := 1;
      pum.CurTrain := 0;
      MagicList.Add(pum);   //마법을 새로 배움..
      if RaceServer = RC_USERHUMAN then begin
        hum := TUserHuman(self);
        hum.SendAddMagic(pum);    //마법 추가를 클라이언트에 알림
      end;
    end;
  end;
end;

procedure TCreature.DelMagicWithItem(magic: integer);

  procedure DelMagicByName(mname: string);
  var
    i:   integer;
    hum: TUserHuman;
  begin
    if self.RaceServer = RC_USERHUMAN then   //PDS
    begin
      for i := MagicList.Count - 1 downto 0 do begin
        if PTUserMagic(MagicList[i]).pDef.MagicName = mname then begin
          hum := TUserHuman(self);
          hum.SendDelMagic(PTUserMagic(MagicList[i]));
          Dispose(PTUserMagic(MagicList[i]));
          MagicList.Delete(i);
          break;
        end;
      end;
    end;
  end;

begin
  if RaceServer <> RC_USERHUMAN then
    exit;
  if magic = AM_FIREBALL then begin
    if (Job <> 1) then begin  //술사가 아니면
      DelMagicByName(NAME_OF_FIREBALL);
    end;
  end;
  if magic = AM_HEALING then begin
    if (Job <> 2) then begin  //도사가 아니면
      DelMagicByName(NAME_OF_HEALING);
    end;
  end;
end;

//재생의반지의 내구력이 닳는다.
procedure TCreature.ItemDamageRevivalRing;
var
  i, idura, olddura: integer;
  pstd: PTStdItem;
  hum:  TUserHuman;
begin
  // 2003/03/15 아이템 인벤토리 확장
  for i := 0 to 12 do begin    // 8->12
    if UseItems[i].Index > 0 then begin
      pstd := UserEngine.GetStdItem(UseItems[i].Index);
      if pstd <> nil then begin
        if (i = U_RINGR) or (i = U_RINGL) then begin
          if pstd.Shape = RING_REVIVAL_ITEM then begin
            idura   := UseItems[i].Dura;
            //Dura는 word값이기 때문에... idura(integer)로 계산했음
            olddura := Round(idura / 1000);
            idura   := idura - 1000; //한번 사용할때 1000씩 닳는다.
            if idura <= 0 then begin
              idura := 0;
              UseItems[i].Dura := idura;
              //다 닮면 없어진다.
              if RaceServer = RC_USERHUMAN then begin
                hum := TUserHuman(self);
                hum.SendDelItem(UseItems[i]); //클라이언트에 없어진거 보냄
                hum.SysMsg(pstd.Name + 'is destroyed.', 0);
                //재생의반지 파괴 메시지(2004/11/18)
              end;

              //로그 남겨야 함(재생의반지)
              AddUserLog('16'#9 + //죽파_
                MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
                ''#9 + UserName + ''#9 + pstd.Name + ''#9 +
                IntToStr(UseItems[i].MakeIndex) + ''#9 +
                IntToStr(BoolToInt(RaceServer = RC_USERHUMAN)) + ''#9 + '0');

              UseItems[i].Index := 0;
              RecalcAbilitys;
            end else
              UseItems[i].Dura := idura;
            if olddura <> Round(idura / 1000) then
              SendMsg(self, RM_DURACHANGE, i, idura, UseItems[i].DuraMax, 0, '');
            break;
          end;
        end;
      end;
    end;
  end;
end;

//착용 능력치로 계산
procedure TCreature.RecalcAbilitys;
var
  i, oldlight, n, m: integer;
  cghi:     array[0..3] of boolean;
  pstd:     PTStdItem;
  temp:     TAbility;
  fastmoveflag: boolean;
  oldhmode: boolean;
  mh_ring, mh_bracelet, mh_necklace: boolean;
  sh_ring, sh_bracelet, sh_necklace: boolean;
  // 2003/01/15 세트 아이템 추가...세륜셋, 녹취셋, 도부셋
  hp_ring, hp_bracelet: boolean;
  mp_ring, mp_bracelet: boolean;
  hpmp_ring, hpmp_bracelet: boolean;
  // 2003/02/11 세트 아이템 추가...오현셋, 초혼셋
  hpp_necklace, hpp_bracelet, hpp_ring: boolean;
  cho_weapon, cho_necklace, cho_ring, cho_helmet, cho_bracelet: boolean;
  // 2003/03/04 세트 아이템 추가...파쇄셋, 환마석셋, 영령옥셋
  pset_necklace, pset_bracelet, pset_ring: boolean;
  hset_necklace, hset_bracelet, hset_ring: boolean;
  yset_necklace, yset_bracelet, yset_ring: boolean;
  dset_wingdress: boolean;
  // 2003/11/17 제조 전용 세트 아이템 추가
  // 뼈다귀셋,벌레셋,백금셋,연옥셋,홍옥셋,강화백금셋,강화연옥셋,강화홍옥셋.
  boneset_weapon, boneset_helmet, boneset_dress: boolean;
  bugset_necklace, bugset_ring, bugset_bracelet: boolean;
  ptset_belt, ptset_boots, ptset_necklace, ptset_bracelet, ptset_ring: boolean;
  ksset_belt, ksset_boots, ksset_necklace, ksset_bracelet, ksset_ring: boolean;
  rubyset_belt, rubyset_boots, rubyset_necklace, rubyset_bracelet,
  rubyset_ring: boolean;
  strong_ptset_belt, strong_ptset_boots, strong_ptset_necklace,
  strong_ptset_bracelet, strong_ptset_ring: boolean;
  strong_ksset_belt, strong_ksset_boots, strong_ksset_necklace,
  strong_ksset_bracelet, strong_ksset_ring: boolean;
  strong_rubyset_belt, strong_rubyset_boots, strong_rubyset_necklace,
  strong_rubyset_bracelet, strong_rubyset_ring: boolean;

  // 2004/01/09 용 세트 아이템 추가(sonmg)
  dragonset_ring_left, dragonset_ring_right, dragonset_bracelet_left,
  dragonset_bracelet_right, dragonset_necklace, dragonset_dress,
  dragonset_helmet, dragonset_weapon, dragonset_boots, dragonset_belt: boolean;

begin
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

  ManaToHealthPoint := 0; //마력 -> 체력
  mh_ring     := False;
  mh_bracelet := False;
  mh_necklace := False;

  SuckupEnemyHealthRate := 0; //체력 흡수
  SuckupEnemyHealth := 0;
  sh_ring      := False;
  sh_bracelet  := False;
  sh_necklace  := False;
  // 2003/01/15 세트 아이템 추가...세륜셋, 녹취셋, 도부셋
  hp_ring      := False;
  hp_bracelet  := False;
  mp_ring      := False;
  mp_bracelet  := False;
  hpmp_ring    := False;
  hpmp_bracelet := False;
  // 2003/02/11 세트 아이템 추가...오현셋, 초혼셋
  hpp_necklace := False;
  hpp_bracelet := False;
  hpp_ring     := False;
  cho_weapon   := False;
  cho_necklace := False;
  cho_ring     := False;
  cho_helmet   := False;
  cho_bracelet := False;
  // 2003/02/11 초혼 풀세트 착용여부 플레그로 용도 변경하여 사용
  BoOldVersionUser_Italy := False;
  // 2003/03/04 세트 아이템 추가...파쇄셋, 환마석셋, 영령옥셋
  pset_necklace := False;
  pset_bracelet := False;
  pset_ring    := False;
  hset_necklace := False;
  hset_bracelet := False;
  hset_ring    := False;
  yset_necklace := False;
  yset_bracelet := False;
  yset_ring    := False;

  // 2003/11/17 제조 전용 세트 아이템 추가(sonmg)
  // 뼈다귀셋,벌레셋,백금셋,연옥셋,홍옥셋,강화백금셋,강화연옥셋,강화홍옥셋.
  boneset_weapon  := False;
  boneset_helmet  := False;
  boneset_dress   := False;
  bugset_necklace := False;
  bugset_ring     := False;
  bugset_bracelet := False;
  ptset_belt      := False;
  ptset_boots     := False;
  ptset_necklace  := False;
  ptset_bracelet  := False;
  ptset_ring      := False;
  ksset_belt      := False;
  ksset_boots     := False;
  ksset_necklace  := False;
  ksset_bracelet  := False;
  ksset_ring      := False;
  rubyset_belt    := False;
  rubyset_boots   := False;
  rubyset_necklace := False;
  rubyset_bracelet := False;
  rubyset_ring    := False;
  strong_ptset_belt := False;
  strong_ptset_boots := False;
  strong_ptset_necklace := False;
  strong_ptset_bracelet := False;
  strong_ptset_ring := False;
  strong_ksset_belt := False;
  strong_ksset_boots := False;
  strong_ksset_necklace := False;
  strong_ksset_bracelet := False;
  strong_ksset_ring := False;
  strong_rubyset_belt := False;
  strong_rubyset_boots := False;
  strong_rubyset_necklace := False;
  strong_rubyset_bracelet := False;
  strong_rubyset_ring := False;

  // 2004/01/09 용 세트 아이템 추가(sonmg)
  dragonset_ring_left := False;
  dragonset_ring_right := False;
  dragonset_bracelet_left := False;
  dragonset_bracelet_right := False;
  dragonset_necklace := False;
  dragonset_dress    := False;
  dragonset_helmet   := False;
  dragonset_weapon   := False;
  dragonset_boots    := False;
  dragonset_belt     := False;

  BoCGHIEnable := False;  //천지합일
  cghi[0]      := False;
  cghi[1]      := False;
  cghi[2]      := False;
  cghi[3]      := False;

  dset_wingdress := False; // 천의무봉

  // 2003/03/04 사람의 경우만 아이템 착용여부 검사토록 변경
  if (RaceServer = RC_USERHUMAN) {or (Master <> nil)} then begin
    // 2003/03/15 아이템 인벤토리 확장
    for i := 0 to 12 do begin // 8 -> 12
      if (UseItems[i].Index > 0) {and (UseItems[i].Dura > 0)} then begin
        //----------------------------------------------------------
        // 아이템 내구가 0이면 능력치 계산 안하고 무게만 계산함.(sonmg 2005/03/31)
        if UseItems[i].Dura = 0 then begin
          pstd := UserEngine.GetStdItem(UseItems[i].Index);
          if pstd <> nil then begin
            if (i = U_WEAPON) or (i = U_RIGHTHAND) then begin
              WAbil.HandWeight := WAbil.HandWeight + pstd.Weight;
              //손에 들고 있는 무게
            end else begin
              WAbil.WearWeight := WAbil.WearWeight + pstd.Weight;
              //입고 있거나 착용한 무게.
            end;
          end;
          continue;
        end;
        //----------------------------------------------------------

        ApplyItemParameters(UseItems[i], AddAbil);
        // 2003/03/15 아이템 인벤토리 확장
        ApplyItemParametersEx(UseItems[i], WAbil);

        pstd := UserEngine.GetStdItem(UseItems[i].Index);
        if pstd <> nil then begin
          if (i = U_WEAPON) or (i = U_RIGHTHAND) then begin
            WAbil.HandWeight := WAbil.HandWeight + pstd.Weight;
            //손에 들고 있는 무게
          end else begin
            WAbil.WearWeight := WAbil.WearWeight + pstd.Weight;
            //입고 있거나 착용한 무게.
          end;
          //               WAbil.Weight := WAbil.Weight + pstd.Weight; //전체의 무게
          //무기인 경우 강도
          if (i = U_WEAPON) or (i = U_ARMRINGL) or (i = U_ARMRINGR) then begin
{//ApplyParameters로 옮김(sonmg).
                  if pstd.SpecialPwr in [1..10] then
                     AddAbil.WeaponStrong := pstd.SpecialPwr;  //무기의 강도, 강도가 높으면 잘 안뽀개짐
}
            if (pstd.SpecialPwr <= -1) and (pstd.SpecialPwr >= -50) then
              AddAbil.UndeadPower := AddAbil.UndeadPower + (-pstd.SpecialPwr);
            //언데드 공격 효과 상승
            if (pstd.SpecialPwr <= -51) and (pstd.SpecialPwr >= -100) then
              AddAbil.UndeadPower := AddAbil.UndeadPower + (pstd.SpecialPwr + 50);
            //언데드 공격 효과 감소

            if pstd.Shape = CCHO_WEAPON then
              cho_weapon := True;
            // 2003/11/19 세트 아이템 추가(sonmg)
            // 별도 구분 필요
            if (pstd.Shape = BONESET_WEAPON_SHAPE) and (pstd.StdMode = 6) then
              boneset_weapon := True;
            // 2004/01/09 용 세트 아이템 추가(sonmg)
            if pstd.Shape = DRAGON_WEAPON_SHAPE then
              dragonset_weapon := True;
          end;
          //목걸이
          if i = U_NECKLACE then begin
            if pstd.Shape = NECTLACE_FASTTRAINING_ITEM then begin  //수련의목걸이
              BoFastTraining := True;
            end;
            if pstd.Shape = NECTLACE_SEARCH_ITEM then begin
              BoAbilSearch := True;
            end;
            if pstd.Shape = NECKLACE_GI_ITEM then begin  //천지합일 (지)
              cghi[1] := True;
            end;
            if pstd.Shape = NECKLACE_OF_MANATOHEALTH then begin //마력 -> 체력
              mh_necklace := True;
              ManaToHealthPoint := ManaToHealthPoint + pstd.AniCount;
            end;
            if pstd.Shape = NECKLACE_OF_SUCKHEALTH then begin  //상대 체력 흡수
              sh_necklace := True;
              SuckupEnemyHealthRate := SuckupEnemyHealthRate + pstd.AniCount;
            end;
            if pstd.Shape = NECKLACE_OF_HPPUP then begin  //HP PERCENT UP
              hpp_necklace := True;
            end;
            if pstd.Shape = CCHO_NECKLACE then
              cho_necklace := True;
            // 2003/03/04 세트 아이템 추가...파쇄셋, 환마석셋, 영령옥셋
            if pstd.Shape = PSET_NECKLACE_SHAPE then
              pset_necklace := True;
            if pstd.Shape = HSET_NECKLACE_SHAPE then
              hset_necklace := True;
            if pstd.Shape = YSET_NECKLACE_SHAPE then
              yset_necklace := True;
            // 2003/11/19 세트 아이템 추가(sonmg)
            if pstd.Shape = BUGSET_NECKLACE_SHAPE then
              bugset_necklace := True;
            if pstd.Shape = PTSET_NECKLACE_SHAPE then
              ptset_necklace := True;
            if pstd.Shape = KSSET_NECKLACE_SHAPE then
              ksset_necklace := True;
            if pstd.Shape = RUBYSET_NECKLACE_SHAPE then
              rubyset_necklace := True;
            if pstd.Shape = STRONG_PTSET_NECKLACE_SHAPE then
              strong_ptset_necklace := True;
            if pstd.Shape = STRONG_KSSET_NECKLACE_SHAPE then
              strong_ksset_necklace := True;
            if pstd.Shape = STRONG_RUBYSET_NECKLACE_SHAPE then
              strong_rubyset_necklace := True;
            // 2004/01/09 용 세트 아이템 추가(sonmg)
            if pstd.Shape = DRAGON_NECKLACE_SHAPE then
              dragonset_necklace := True;
          end;
          //반지
          if (i = U_RINGR) or (i = U_RINGL) then begin
            if pstd.Shape = RING_TRANSPARENT_ITEM then begin
              StatusArr[STATE_TRANSPARENT] := 60000;  //타임아웃 없음..
              BoHumHideMode := True;   //투명모드
            end;
            if pstd.Shape = RING_SPACEMOVE_ITEM then begin
              BoAbilSpaceMove := True;
            end;
            if pstd.Shape = RING_MAKESTONE_ITEM then begin
              BoAbilMakeStone := True;
            end;
            if pstd.Shape = RING_REVIVAL_ITEM then begin
              BoAbilRevival := True;
            end;
            if pstd.Shape = RING_FIREBALL_ITEM then begin
              BoAddMagicFireBall := True;
            end;
            if pstd.Shape = RING_HEALING_ITEM then begin
              BoAddMagicHealing := True;
            end;
            if pstd.Shape = RING_ANGERENERGY_ITEM then begin
              BoAbilAngerEnergy := True;
            end;
            if pstd.Shape = RING_MAGICSHIELD_ITEM then begin
              BoMagicShield := True;
            end;
            if pstd.Shape = RING_SUPERSTRENGTH_ITEM then begin
              BoAbilSuperStrength := True;
            end;
            if pstd.Shape = RING_CHUN_ITEM then begin  //천지합일 (천)
              cghi[0] := True;
            end;
            if pstd.Shape = RING_OF_MANATOHEALTH then begin  //마력 -> 체력
              mh_ring := True;
              ManaToHealthPoint := ManaToHealthPoint + pstd.AniCount;
            end;
            if pstd.Shape = RING_OF_SUCKHEALTH then begin  //상대 체력 흡수
              sh_ring := True;
              SuckupEnemyHealthRate := SuckupEnemyHealthRate + pstd.AniCount;
            end;
            // 2003/01/15 세트 아이템 추가...세륜셋, 녹취셋, 도부셋
            if pstd.Shape = RING_OF_HPUP then begin  //HP증가
              hp_ring := True;
            end;
            if pstd.Shape = RING_OF_MPUP then begin  //MP증가
              mp_ring := True;
            end;
            if pstd.Shape = RING_OF_HPMPUP then begin  //HP/MP 증가
              hpmp_ring := True;
            end;
            if pstd.Shape = RING_OH_HPPUP then begin  //HP PERCENT 증가
              hpp_ring := True;
            end;
            if pstd.Shape = CCHO_RING then
              cho_ring := True;
            // 2003/03/04 세트 아이템 추가...파쇄셋, 환마석셋, 영령옥셋
            if pstd.Shape = PSET_RING_SHAPE then
              pset_ring := True;
            if pstd.Shape = HSET_RING_SHAPE then
              hset_ring := True;
            if pstd.Shape = YSET_RING_SHAPE then
              yset_ring := True;
            // 2003/11/19 세트 아이템 추가(sonmg)
            if pstd.Shape = BUGSET_RING_SHAPE then
              bugset_ring := True;
            if pstd.Shape = PTSET_RING_SHAPE then
              ptset_ring := True;
            if pstd.Shape = KSSET_RING_SHAPE then
              ksset_ring := True;
            if pstd.Shape = RUBYSET_RING_SHAPE then
              rubyset_ring := True;
            if pstd.Shape = STRONG_PTSET_RING_SHAPE then
              strong_ptset_ring := True;
            if pstd.Shape = STRONG_KSSET_RING_SHAPE then
              strong_ksset_ring := True;
            if pstd.Shape = STRONG_RUBYSET_RING_SHAPE then
              strong_rubyset_ring := True;
            // 2004/01/09 용 세트 아이템 추가(sonmg)
            if pstd.Shape = DRAGON_RING_SHAPE then begin
              if (i = U_RINGL) then
                dragonset_ring_left := True;
              if (i = U_RINGR) then
                dragonset_ring_right := True;
            end;
          end;
          //팔찌
          if (i = U_ARMRINGL) or (i = U_ARMRINGR) then begin
            if pstd.Shape = ARMRING_HAP_ITEM then begin  //천지합일 (합)
              cghi[2] := True;
            end;
            if pstd.Shape = BRACELET_OF_MANATOHEALTH then begin  //마력 -> 체력
              mh_bracelet := True;
              ManaToHealthPoint := ManaToHealthPoint + pstd.AniCount;
            end;
            if pstd.Shape = BRACELET_OF_SUCKHEALTH then begin  //상대 체력 흡수
              sh_bracelet := True;
              SuckupEnemyHealthRate := SuckupEnemyHealthRate + pstd.AniCount;
            end;
            // 2003/01/15 세트 아이템 추가...세륜셋, 녹취셋, 도부셋
            if pstd.Shape = BRACELET_OF_HPUP then begin  //HP증가
              hp_bracelet := True;
            end;
            if pstd.Shape = BRACELET_OF_MPUP then begin  //MP증가
              mp_bracelet := True;
            end;
            if pstd.Shape = BRACELET_OF_HPMPUP then begin  //HP/MP증가
              hpmp_bracelet := True;
            end;
            if pstd.Shape = BRACELET_OF_HPPUP then begin  //HP PERCENT 증가
              hpp_bracelet := True;
            end;
            if pstd.Shape = CCHO_BRACELET then
              cho_bracelet := True;
            // 2003/03/04 세트 아이템 추가...파쇄셋, 환마석셋, 영령옥셋
            if pstd.Shape = PSET_BRACELET_SHAPE then
              pset_bracelet := True;
            if pstd.Shape = HSET_BRACELET_SHAPE then
              hset_bracelet := True;
            if pstd.Shape = YSET_BRACELET_SHAPE then
              yset_bracelet := True;
            // 2003/11/19 세트 아이템 추가(sonmg)
            if pstd.Shape = BUGSET_BRACELET_SHAPE then
              bugset_bracelet := True;
            if pstd.Shape = PTSET_BRACELET_SHAPE then
              ptset_bracelet := True;
            if pstd.Shape = KSSET_BRACELET_SHAPE then
              ksset_bracelet := True;
            if pstd.Shape = RUBYSET_BRACELET_SHAPE then
              rubyset_bracelet := True;
            if pstd.Shape = STRONG_PTSET_BRACELET_SHAPE then
              strong_ptset_bracelet := True;
            if pstd.Shape = STRONG_KSSET_BRACELET_SHAPE then
              strong_ksset_bracelet := True;
            if pstd.Shape = STRONG_RUBYSET_BRACELET_SHAPE then
              strong_rubyset_bracelet := True;
            // 2004/01/09 용 세트 아이템 추가(sonmg)
            if pstd.Shape = DRAGON_BRACELET_SHAPE then begin
              if (i = U_ARMRINGL) then
                dragonset_bracelet_left := True;
              if (i = U_ARMRINGR) then
                dragonset_bracelet_right := True;
            end;
          end;
          //투구
          if (i = U_HELMET) then begin
            if pstd.Shape = HELMET_IL_ITEM then begin
              cghi[3] := True;
            end;
            if pstd.Shape = CCHO_HELMET then
              cho_helmet := True;
            // 2003/11/19 세트 아이템 추가(sonmg)
            if pstd.Shape = BONESET_HELMET_SHAPE then
              boneset_helmet := True;
            // 2004/01/09 용 세트 아이템 추가(sonmg)
            if pstd.Shape = DRAGON_HELMET_SHAPE then
              dragonset_helmet := True;
          end;
          // 옷
          if (i = U_DRESS) then begin
            if pstd.Shape = DRESS_SHAPE_WING then begin
              dset_wingdress := True;
            end;
            // 2003/11/19 세트 아이템 추가(sonmg)
            // 별도 구분 필요
            if (pstd.Shape = BONESET_DRESS_SHAPE) and
              ((UPPERCASE(pstd.Name) = 'BONEROBE(M)') or
              (UPPERCASE(pstd.Name) = 'BONEROBE(F)')) then
              boneset_dress := True;

            // 2004/01/09 용 세트 아이템 추가(sonmg)
            if pstd.Shape = DRAGON_DRESS_SHAPE then
              dragonset_dress := True;
          end;
          // 벨트(sonmg)
          if (i = U_BELT) then begin
            // 2003/11/19 세트 아이템 추가(sonmg)
            if pstd.Shape = PTSET_BELT_SHAPE then
              ptset_belt := True;
            if pstd.Shape = KSSET_BELT_SHAPE then
              ksset_belt := True;
            if pstd.Shape = RUBYSET_BELT_SHAPE then
              rubyset_belt := True;
            if pstd.Shape = STRONG_PTSET_BELT_SHAPE then
              strong_ptset_belt := True;
            if pstd.Shape = STRONG_KSSET_BELT_SHAPE then
              strong_ksset_belt := True;
            if pstd.Shape = STRONG_RUBYSET_BELT_SHAPE then
              strong_rubyset_belt := True;
            // 2004/01/09 용 세트 아이템 추가(sonmg)
            if pstd.Shape = DRAGON_BELT_SHAPE then
              dragonset_belt := True;
          end;
          // 신발(sonmg)
          if (i = U_BOOTS) then begin
            // 2003/11/19 세트 아이템 추가(sonmg)
            if pstd.Shape = PTSET_BOOTS_SHAPE then
              ptset_boots := True;
            if pstd.Shape = KSSET_BOOTS_SHAPE then
              ksset_boots := True;
            if pstd.Shape = RUBYSET_BOOTS_SHAPE then
              rubyset_boots := True;
            if pstd.Shape = STRONG_PTSET_BOOTS_SHAPE then
              strong_ptset_boots := True;
            if pstd.Shape = STRONG_KSSET_BOOTS_SHAPE then
              strong_ksset_boots := True;
            if pstd.Shape = STRONG_RUBYSET_BOOTS_SHAPE then
              strong_rubyset_boots := True;
            // 2004/01/09 용 세트 아이템 추가(sonmg)
            if pstd.Shape = DRAGON_BOOTS_SHAPE then
              dragonset_boots := True;
          end;
          // 수호석(sonmg)
          if (i = U_CHARM) then begin
            if (pstd.StdMode = 53) and (pstd.Shape = SHAPE_OF_LUCKYLADLE) then
            begin
              // 복조리이면 행운 +1 시킨다.
              AddAbil.Luck := _MIN(255, AddAbil.Luck + 1);
            end;
          end;
        end;
      end;
    end;

    //-----세트 아이템
    //천지합일 검사
    if cghi[0] and cghi[1] and cghi[2] and cghi[3] then begin  //천지합일을 다 찼음
      BoCGHIEnable := True;
    end;

    //마력 -> 체력으로 세트 (적난 세트)
    if mh_necklace and mh_bracelet and mh_ring then begin
      ManaToHealthPoint := ManaToHealthPoint + 50;   //보너스 50
    end;

    //상대 체력흡수 세트 (밀화 세트)
    if sh_necklace and sh_bracelet and sh_ring then begin
      AddAbil.HIT := AddAbil.HIT + 2;  //보너스로 정확이 2 증가
    end;

    // 2003/01/15 세트 아이템 추가...세륜셋, 녹취셋, 도부셋
    if hp_bracelet and hp_ring then begin
      AddAbil.HP := AddAbil.HP + 50;  //보너스로 HP 50 증가
    end;
    if mp_bracelet and mp_ring then begin
      AddAbil.MP := AddAbil.MP + 50;  //보너스로 MP 50 증가
    end;
    if hpmp_bracelet and hpmp_ring then begin
      AddAbil.HP := AddAbil.HP + 30;  //보너스로 HP 30 증가
      AddAbil.MP := AddAbil.MP + 30;  //보너스로 MP 30 증가
    end;

    // 2003/02/11 세트 아이템 추가...오현셋, 초혼셋
    if hpp_necklace and hpp_bracelet and hpp_ring then begin
      AddAbil.HP := AddAbil.HP + ((WAbil.MaxHP * 30) div 100);
      // 보너스로 HP의 30% 증가
      AddAbil.AC := AddAbil.AC + MAKEWORD(2, 2);
    end;

    if cho_weapon and cho_necklace and cho_ring and cho_helmet and cho_bracelet then
    begin
         {//<초혼세트효과 : +4 (실제공속 +2)>
         //*초혼도(공속-1) + 4 = +3 (실제공속:1)
         //*초혼도(공속 0) + 4 = +4 (실제공속:2)
         //*초혼도(공속+1) + 4 = +5 (실제공속:2)
         //*초혼도(공속+2) + 4 = +6 (실제공속:3)}
      AddAbil.HitSpeed := AddAbil.HitSpeed + 4;  //셋트 공속 수정(sonmg 2004/12/30)
      AddAbil.DC := AddAbil.DC + MakeWord(2, 5); // 보너스로 최소파괴 +2, 최대파괴 +5
      BoOldVersionUser_Italy := True;            // 풀셋 착용 세트
    end;
    // 2003/03/04 세트 아이템 추가...파쇄셋, 환마석셋, 영령옥셋
    if pset_bracelet and pset_ring then begin          // 보너스로 공속 +1
      AddAbil.HitSpeed := AddAbil.HitSpeed + 2; //sonmg(2004/02/02)
      if pset_necklace then begin                     // 보너스로 파괴1-3
        AddAbil.DC := AddAbil.DC + MakeWord(1, 3);
      end;
    end;
      {
      // 무게 초기화
      case Job of
         0: //전사
            begin
               Abil.MaxWeight := 50 + Round((Abil.Level / 3) * Abil.Level);
               Abil.MaxWearWeight := 15 + Round((Abil.Level / 20) * Abil.Level);
            end;
         1: //술사인경우
            begin
               Abil.MaxWeight := 50 + Round((Abil.Level / 5{) * Abil.Level);
               Abil.MaxWearWeight := 15 + Round((Abil.Level / 100) * Abil.Level);
            end;
         2: //도사인 경우
            begin
               Abil.MaxWeight := 50 + Round((Abil.Level / 4) * Abil.Level);
               Abil.MaxWearWeight := 15 + Round((Abil.Level / 50) * Abil.Level);
            end;
      end;
      }
    if hset_bracelet and hset_ring then begin          // 보너스로 착용+5, 가방+20
      WAbil.MaxWeight     := WAbil.MaxWeight + 20;
      WAbil.MaxWearWeight := _MIN(255, WAbil.MaxWearWeight + 5);
      if hset_necklace then begin                     // 보너스로 마법1-2
        AddAbil.MC := AddAbil.MC + MakeWord(1, 2);
      end;
    end;
    if yset_bracelet and yset_ring then begin          // 보너스로 신성+3
      AddAbil.UndeadPower := AddAbil.UndeadPower + 3;
      if yset_necklace then begin                     // 보너스로 도력1-2
        AddAbil.SC := AddAbil.SC + MakeWord(1, 2);
      end;
    end;

    // 2003/11/19 세트 아이템 추가(sonmg)
    // 뼈다귀 세트
    if boneset_weapon and boneset_helmet and boneset_dress then begin
      // 보너스로 방어+2, 마력+1, 도력+1
      AddAbil.AC := AddAbil.AC + MakeWord(0, 2);
      AddAbil.MC := AddAbil.MC + MakeWord(0, 1);
      AddAbil.SC := AddAbil.SC + MakeWord(0, 1);
    end;
    // 벌레 세트
    if bugset_necklace and bugset_ring and bugset_bracelet then begin
      // 보너스로 파괴+1, 마력+1, 도력+1, 마법저항+1, 중독저항+1
      AddAbil.DC := AddAbil.DC + MakeWord(0, 1);
      AddAbil.MC := AddAbil.MC + MakeWord(0, 1);
      AddAbil.SC := AddAbil.SC + MakeWord(0, 1);
      AddAbil.AntiMagic := AddAbil.AntiMagic + 1;
      AddAbil.AntiPoison := AddAbil.AntiPoison + 1;
    end;
    // 백금 세트
    if ptset_belt and ptset_boots and ptset_necklace and ptset_bracelet and
      ptset_ring then begin
      // 보너스로 파괴+2, 방어+2, 양손+1, 착용+2
      AddAbil.DC := AddAbil.DC + MakeWord(0, 2);
      AddAbil.AC := AddAbil.AC + MakeWord(0, 2);
      WAbil.MaxHandWeight := _MIN(255, WAbil.MaxHandWeight + 1);
      WAbil.MaxWearWeight := _MIN(255, WAbil.MaxWearWeight + 2);
    end;
    // 연옥 세트
    if ksset_belt and ksset_boots and ksset_necklace and ksset_bracelet and
      ksset_ring then begin
      // 보너스로 도력+2, 방어+1, 마항+1, 민첩+1, 양손+1, 착용+2
      AddAbil.SC    := AddAbil.SC + MakeWord(0, 2);
      AddAbil.AC    := AddAbil.AC + MakeWord(0, 1);
      AddAbil.MAC   := AddAbil.MAC + MakeWord(0, 1);
      AddAbil.SPEED := AddAbil.SPEED + 1;
      WAbil.MaxHandWeight := _MIN(255, WAbil.MaxHandWeight + 1);
      WAbil.MaxWearWeight := _MIN(255, WAbil.MaxWearWeight + 2);
    end;
    // 홍옥 세트
    if rubyset_belt and rubyset_boots and rubyset_necklace and
      rubyset_bracelet and rubyset_ring then begin
      // 보너스로 마력+2, 마항+2, 양손+1, 착용+2
      AddAbil.MC  := AddAbil.MC + MakeWord(0, 2);
      AddAbil.MAC := AddAbil.MAC + MakeWord(0, 2);
      WAbil.MaxHandWeight := _MIN(255, WAbil.MaxHandWeight + 1);
      WAbil.MaxWearWeight := _MIN(255, WAbil.MaxWearWeight + 2);
    end;
    // 강화백금 세트
    if strong_ptset_belt and strong_ptset_boots and strong_ptset_necklace and
      strong_ptset_bracelet and strong_ptset_ring then begin
      // 보너스로 파괴+3, HP +30, 공속+1, 착용+2
      AddAbil.DC := AddAbil.DC + MakeWord(0, 3);
      AddAbil.HP := AddAbil.HP + 30;
      AddAbil.HitSpeed := AddAbil.HitSpeed + 2;
      WAbil.MaxWearWeight := _MIN(255, WAbil.MaxWearWeight + 2);
    end;
    // 강화연옥 세트
    if strong_ksset_belt and strong_ksset_boots and strong_ksset_necklace and
      strong_ksset_bracelet and strong_ksset_ring then begin
      // 보너스로 도력+2, HP +15, MP +20, 신성+1, 정확+1, 민첩+1, 착용+2
      AddAbil.SC    := AddAbil.SC + MakeWord(0, 2);
      AddAbil.HP    := AddAbil.HP + 15;
      AddAbil.MP    := AddAbil.MP + 20;
      AddAbil.UndeadPower := AddAbil.UndeadPower + 1;
      AddAbil.HIT   := AddAbil.HIT + 1;
      AddAbil.SPEED := AddAbil.SPEED + 1;
      WAbil.MaxWearWeight := _MIN(255, WAbil.MaxWearWeight + 2);
    end;
    // 강화홍옥 세트
    if strong_rubyset_belt and strong_rubyset_boots and
      strong_rubyset_necklace and strong_rubyset_bracelet and strong_rubyset_ring then
    begin
      // 보너스로 마력+2, MP +40, 민첩+2, 착용+2
      AddAbil.MC    := AddAbil.MC + MakeWord(0, 2);
      AddAbil.MP    := AddAbil.MP + 40;
      AddAbil.SPEED := AddAbil.SPEED + 2;
      WAbil.MaxWearWeight := _MIN(255, WAbil.MaxWearWeight + 2);
    end;

    //--------------------------------
    // 2004/01/09 용 세트 검사(sonmg)
    //--------------------------------
    //용 세트 (전부)
    if dragonset_ring_left and dragonset_ring_right and
      dragonset_bracelet_left and dragonset_bracelet_right and
      dragonset_necklace and dragonset_dress and dragonset_helmet and
      dragonset_weapon and dragonset_boots and dragonset_belt then begin
      //방어+(1-4) / 마방+(1-4) / 행운+2 / 공속+2 / 마법회피 +6% / 중독회피 +6%
      //양손무게+34 / 착용무게+27 / 가방무게+120 / +HP+70 / +MP+80 / 특수무공(?)
      //민첩+1 / 공격(1-4) / 마법(1-3) / 도력(1-3)
      AddAbil.AC      := MakeWord(LoByte(AddAbil.AC) + 1,
        _MIN(255, HiByte(AddAbil.AC) + 4));
      AddAbil.MAC     := MakeWord(LoByte(AddAbil.MAC) + 1,
        _MIN(255, HiByte(AddAbil.MAC) + 4));
      AddAbil.Luck    := _MIN(255, AddAbil.Luck + 2);
      AddAbil.HitSpeed := AddAbil.HitSpeed + 2; //공속+2
      AddAbil.AntiMagic := AddAbil.AntiMagic + 6;
      AddAbil.AntiPoison := AddAbil.AntiPoison + 6;
      WAbil.MaxHandWeight := _MIN(255, WAbil.MaxHandWeight + 34);
      WAbil.MaxWearWeight := _MIN(255, WAbil.MaxWearWeight + 27);
      WAbil.MaxWeight := WAbil.MaxWeight + 120;
      WAbil.MaxHP     := WAbil.MaxHP + 70;
      WAbil.MaxMP     := WAbil.MaxMP + 80;
      AddAbil.SPEED   := AddAbil.SPEED + 1;
      AddAbil.DC      := MakeWord(LoByte(AddAbil.DC) + 1,
        _MIN(255, HiByte(AddAbil.DC) + 4));
      AddAbil.MC      := MakeWord(LoByte(AddAbil.MC) + 1,
        _MIN(255, HiByte(AddAbil.MC) + 3));
      AddAbil.SC      := MakeWord(LoByte(AddAbil.SC) + 1,
        _MIN(255, HiByte(AddAbil.SC) + 3));
    end else begin
      //-----------------
      //용 세트 (Type B)
      //-----------------
      //용 세트(B-3)
      if dragonset_dress and dragonset_helmet and dragonset_weapon and
        dragonset_boots and dragonset_belt then begin
        //양손무게+34 / 가방무게+50 / 민첩+1 / 공격(1-4) / 마법(1-3) / 도력(1-3)
        WAbil.MaxHandWeight := _MIN(255, WAbil.MaxHandWeight + 34);
        WAbil.MaxWeight := WAbil.MaxWeight + 50;
        AddAbil.SPEED := AddAbil.SPEED + 1;
        AddAbil.DC    := MakeWord(LoByte(AddAbil.DC) + 1,
          _MIN(255, HiByte(AddAbil.DC) + 4));
        AddAbil.MC    := MakeWord(LoByte(AddAbil.MC) + 1,
          _MIN(255, HiByte(AddAbil.MC) + 3));
        AddAbil.SC    := MakeWord(LoByte(AddAbil.SC) + 1,
          _MIN(255, HiByte(AddAbil.SC) + 3));
        //용 세트(B-2)
      end else if dragonset_dress and dragonset_boots and dragonset_belt then  begin
        //양손무게+17 / 가방무게+30 / 공격(0-1) / 마법(0-1) / 도력(0-1)
        WAbil.MaxHandWeight := _MIN(255, WAbil.MaxHandWeight + 17);
        WAbil.MaxWeight := WAbil.MaxWeight + 30;
        AddAbil.DC := MakeWord(LoByte(AddAbil.DC),
          _MIN(255, HiByte(AddAbil.DC) + 1));
        AddAbil.MC := MakeWord(LoByte(AddAbil.MC),
          _MIN(255, HiByte(AddAbil.MC) + 1));
        AddAbil.SC := MakeWord(LoByte(AddAbil.SC),
          _MIN(255, HiByte(AddAbil.SC) + 1));
        //용 세트(B-1)
      end else if dragonset_dress and dragonset_helmet and dragonset_weapon then
      begin
        //공격(0-2) / 마법(0-1) / 도력(0-1) / 민첩 +1
        AddAbil.DC    := MakeWord(LoByte(AddAbil.DC),
          _MIN(255, HiByte(AddAbil.DC) + 2));
        AddAbil.MC    := MakeWord(LoByte(AddAbil.MC),
          _MIN(255, HiByte(AddAbil.MC) + 1));
        AddAbil.SC    := MakeWord(LoByte(AddAbil.SC),
          _MIN(255, HiByte(AddAbil.SC) + 1));
        AddAbil.SPEED := AddAbil.SPEED + 1;
      end;

      //-----------------
      //용 세트 (Type A)
      //-----------------
      //용 세트(A-6)
      if dragonset_ring_left and dragonset_ring_right and
        dragonset_bracelet_left and dragonset_bracelet_right and
        dragonset_necklace then begin
        //착용무게+27 / 가방무게+50 / 방어(1-3) / 마방(1-3)
        WAbil.MaxWearWeight := _MIN(255, WAbil.MaxWearWeight + 27);
        WAbil.MaxWeight := WAbil.MaxWeight + 50;
        AddAbil.AC  := MakeWord(LoByte(AddAbil.AC) + 1,
          _MIN(255, HiByte(AddAbil.AC) + 3));
        AddAbil.MAC := MakeWord(LoByte(AddAbil.MAC) + 1,
          _MIN(255, HiByte(AddAbil.MAC) + 3));
        //용 세트(A-5)
      end else if (dragonset_ring_left or dragonset_ring_right) and
        dragonset_bracelet_left and dragonset_bracelet_right and
        dragonset_necklace then begin
        //A-3 + [A-2]
        //착용무게+17 / 가방무게+30 / 방어(0-1) / 마방(0-1) + [방어(1-0) / 마방(1-0)]
        WAbil.MaxWearWeight := _MIN(255, WAbil.MaxWearWeight + 17);
        WAbil.MaxWeight := WAbil.MaxWeight + 30;
        AddAbil.AC  := MakeWord(LoByte(AddAbil.AC) + 1,
          _MIN(255, HiByte(AddAbil.AC) + 1));
        AddAbil.MAC := MakeWord(LoByte(AddAbil.MAC) + 1,
          _MIN(255, HiByte(AddAbil.MAC) + 1));
        //용 세트(A-4)
      end else if dragonset_ring_left and dragonset_ring_right and
        (dragonset_bracelet_left or dragonset_bracelet_right) and
        dragonset_necklace then begin
        //A-3 + [A-1]
        //착용무게+17 / 가방무게+30 / 방어(0-1) / 마방(0-1) + [방어(0-1) / 마방(0-1)]
        WAbil.MaxWearWeight := _MIN(255, WAbil.MaxWearWeight + 17);
        WAbil.MaxWeight := WAbil.MaxWeight + 30;
        AddAbil.AC  := MakeWord(LoByte(AddAbil.AC),
          _MIN(255, HiByte(AddAbil.AC) + 2));
        AddAbil.MAC := MakeWord(LoByte(AddAbil.MAC),
          _MIN(255, HiByte(AddAbil.MAC) + 2));
        //용 세트(A-3)
      end else if (dragonset_ring_left or dragonset_ring_right) and
        (dragonset_bracelet_left or dragonset_bracelet_right) and
        dragonset_necklace then begin
        //착용무게+17 / 가방무게+30 / 방어(0-1) / 마방(0-1)
        WAbil.MaxWearWeight := _MIN(255, WAbil.MaxWearWeight + 17);
        WAbil.MaxWeight := WAbil.MaxWeight + 30;
        AddAbil.AC  := MakeWord(LoByte(AddAbil.AC),
          _MIN(255, HiByte(AddAbil.AC) + 1));
        AddAbil.MAC := MakeWord(LoByte(AddAbil.MAC),
          _MIN(255, HiByte(AddAbil.MAC) + 1));
      end else begin
        //용 세트(A-2)
        if dragonset_bracelet_left and dragonset_bracelet_right then begin
          //방어(1-0) / 마방(1-0)
          AddAbil.AC  := MakeWord(LoByte(AddAbil.AC) + 1,
            _MIN(255, HiByte(AddAbil.AC)));
          AddAbil.MAC := MakeWord(LoByte(AddAbil.MAC) + 1,
            _MIN(255, HiByte(AddAbil.MAC)));
        end;
        //용 세트(A-1)
        if dragonset_ring_left and dragonset_ring_right then begin
          //방어(0-1) / 마방(0-1)
          AddAbil.AC  := MakeWord(LoByte(AddAbil.AC),
            _MIN(255, HiByte(AddAbil.AC) + 1));
          AddAbil.MAC := MakeWord(LoByte(AddAbil.MAC),
            _MIN(255, HiByte(AddAbil.MAC) + 1));
        end;
      end;
    end;
    // 용 세트 검사 끝.
    //--------------------------------

    //-----세트 아이템 끝

    // 천의무봉 --------------------------------------------------------------
    if dset_wingdress and (Abil.Level >= 20) then begin
      // 기본적으로 행운+1
      //        AddAbil.Luck:= AddAbil.Luck + 1;   //--->ApplyItemParameters 에서 처리...

      if (Abil.Level < 30) then begin
        // 기본값으로 설정
      end else if (Abil.Level < 40) then begin
        AddAbil.DC  := AddAbil.DC + MakeWord(0, 1);  // 공격
        AddAbil.MC  := AddAbil.MC + MakeWord(0, 2);  // 마력
        AddAbil.SC  := AddAbil.SC + MakeWord(0, 2);  // 도력
        AddAbil.AC  := AddAbil.AC + MakeWord(2, 3);  // 방어
        AddAbil.MAC := AddAbil.MAC + MakeWord(0, 2); // 마방
      end else if (Abil.Level < 50) then begin
        AddAbil.DC  := AddAbil.DC + MakeWord(0, 3); // 공격
        AddAbil.MC  := AddAbil.MC + MakeWord(0, 4); // 마력
        AddAbil.SC  := AddAbil.SC + MakeWord(0, 4); // 도력
        AddAbil.AC  := AddAbil.AC + MakeWord(5, 5); // 방어
        AddAbil.MAC := AddAbil.MAC + MakeWord(1, 2); // 마방
      end else// 50
      begin
        AddAbil.DC  := AddAbil.DC + MakeWord(0, 5);  // 공격
        AddAbil.MC  := AddAbil.MC + MakeWord(0, 6);  // 마력
        AddAbil.SC  := AddAbil.SC + MakeWord(0, 6);  // 도력
        AddAbil.AC  := AddAbil.AC + MakeWord(9, 7);  // 방어
        AddAbil.MAC := AddAbil.MAC + MakeWord(2, 4); // 마방
      end;
    end;

    WAbil.Weight := {WAbil.Weight +} CalcBagWeight;
    // 2003/03/04 사람의 경우만 아이템 착용여부 검사토록 변경
  end;
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

  // 여기에 추가(위치 중요)
  //공격속도 값 1/2로 적용(sonmg 2003/12/22->수정)
  if AddAbil.HitSpeed >= 0 then
    AddAbil.HitSpeed := shortint(integer(AddAbil.HitSpeed) div 2)
  else  //음수일때 1씩 빼서 처리(sonmg 2004/01/13->수정)
    AddAbil.HitSpeed := shortint(integer(AddAbil.HitSpeed - 1) div 2);
  //공격속도 합계 제한(added by sonmg)
  AddAbil.HitSpeed := _MIN(15, AddAbil.HitSpeed);

  //초,횃불
  oldlight := Light;
  Light    := GetMyLight;
  if oldlight <> light then
    SendRefMsg(RM_CHANGELIGHT, 0, 0, 0, 0, '');

  //AddAbil과 2중으로 되어 있음(sonmg)
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

  WAbil.AC  := MakeWord(_MIN(255, Lobyte(AddAbil.AC) + Lobyte(Abil.AC)),
    _MIN(255, Hibyte(AddAbil.AC) + Hibyte(Abil.AC)));
  WAbil.MAC := MakeWord(_MIN(255, Lobyte(AddAbil.MAC) + Lobyte(Abil.MAC)),
    _MIN(255, Hibyte(AddAbil.MAC) + Hibyte(Abil.MAC)));
  WAbil.DC  := MakeWord(_MIN(255, Lobyte(AddAbil.DC) + Lobyte(Abil.DC)),
    _MIN(255, Hibyte(AddAbil.DC) + Hibyte(Abil.DC)));
  WAbil.MC  := MakeWord(_MIN(255, Lobyte(AddAbil.MC) + Lobyte(Abil.MC)),
    _MIN(255, Hibyte(AddAbil.MC) + Hibyte(Abil.MC)));
  WAbil.SC  := MakeWord(_MIN(255, Lobyte(AddAbil.SC) + Lobyte(Abil.SC)),
    _MIN(255, Hibyte(AddAbil.SC) + Hibyte(Abil.SC)));

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

  if ExtraAbil[EABIL_PWRRATE] > 0 then begin
    WAbil.DC := MakeWord((Lobyte(WAbil.DC) * ExtraAbil[EABIL_PWRRATE]) div
      100, (Hibyte(WAbil.DC) * ExtraAbil[EABIL_PWRRATE]) div 100);
    WAbil.MC := MakeWord((Lobyte(WAbil.MC) * ExtraAbil[EABIL_PWRRATE]) div
      100, (Hibyte(WAbil.MC) * ExtraAbil[EABIL_PWRRATE]) div 100);
    WAbil.SC := MakeWord((Lobyte(WAbil.SC) * ExtraAbil[EABIL_PWRRATE]) div
      100, (Hibyte(WAbil.SC) * ExtraAbil[EABIL_PWRRATE]) div 100);
  end;


  //반지의 특수한 능력,... 화염의반지(화염장), 회복의반지(회복술)
  if BoAddMagicFireBall then begin
    AddMagicWithItem(AM_FIREBALL);
  end else begin
    DelMagicWithItem(AM_FIREBALL);
  end;

  if BoAddMagicHealing then begin
    AddMagicWithItem(AM_HEALING);
  end else begin
    DelMagicWithItem(AM_HEALING);
  end;

  if BoAbilSuperStrength then begin
    WAbil.MaxWeight     := WAbil.MaxWeight * 2;
    WAbil.MaxWearWeight := _MIN(255, WAbil.MaxWearWeight * 2);
    if (WAbil.MaxHandWeight * 2 > 255) then
      WAbil.MaxHandWeight := 255
    else
      WAbil.MaxHandWeight := WAbil.MaxHandWeight * 2;
  end;

  //적난 세트 마력->체력
  if ManaToHealthPoint > 0 then begin
    if ManaToHealthPoint >= WAbil.MaxMp then
      ManaToHealthPoint := WAbil.MaxMp - 1; //MaxMP는 0이 아님
    WAbil.MaxMP := WAbil.MaxMP - ManaToHealthPoint;
    WAbil.MaxHP := WAbil.MaxHP + ManaToHealthPoint;
    if (RaceServer = RC_USERHUMAN) and (WAbil.HP > WAbil.MaxHP) then
      WAbil.HP := WAbil.MaxHP;
  end;

  if (RaceServer = RC_USERHUMAN) and (WAbil.HP > WAbil.MaxHP) and
    ((not mh_necklace) and (not mh_bracelet) and (not mh_ring)) then
    WAbil.HP := WAbil.MaxHP;
  if (RaceServer = RC_USERHUMAN) and (WAbil.MP > WAbil.MaxMP) then
    WAbil.MP := WAbil.MaxMP;

  if RaceServer = RC_USERHUMAN then begin
    fastmoveflag := False;

    if PHILIPPINEVERSION then begin
      //질주 신발
      if (UseItems[U_BOOTS].Dura > 0) and (UseItems[U_BOOTS].Index = 601) then
        fastmoveflag := True;

      //질주 옷
      if (UseItems[U_DRESS].Dura > 0) and
        ((UseItems[U_DRESS].Index = 602) or (UseItems[U_DRESS].Index = 603)) then
        fastmoveflag := True;

      //질주 수호석
      if (UseItems[U_CHARM].Dura > 0) and (UseItems[U_CHARM].Index = 604) then
        fastmoveflag := True;

      //필리핀 항상 빨리 달리도록(sonmg 2005/12/05)
      fastmoveflag := True;
    end;

    // 찬룡신행보 질주기능 추가
    if (UseItems[U_BOOTS].Dura > 0) and (UseItems[U_BOOTS].Index =
      INDEX_MIRBOOTS) then
      fastmoveflag := True;


    if fastmoveflag then
      StatusArr[STATE_FASTMOVE] := 60000
    else
      StatusArr[STATE_FASTMOVE] := 0;

    // 50레벨 지원 - (sonmg 2004/03/22)
    if (Abil.Level >= EFFECTIVE_HIGHLEVEL) then begin
      if BoHighLevelEffect then begin
        StatusArr[STATE_50LEVELEFFECT] := 60000;
      end else begin
        StatusArr[STATE_50LEVELEFFECT] := 0;
      end;
    end else begin
      StatusArr[STATE_50LEVELEFFECT] := 0;
    end;

    CharStatus := GetCharStatus;
    CharStatusChanged;
  end;

  if RaceServer = RC_USERHUMAN then begin
    UpdateMsg(self, RM_CHARSTATUSCHANGED, HitSpeed{wparam}, CharStatus, 0, 0, '');
  end;

  if RaceServer >= RC_ANIMAL then begin
    //if Master <> nil then
    ApplySlaveLevelAbilitys;
  end;
end;

function TCreature.IsGroupGenderDiffernt(cret: TCreature): boolean;
var
  hum1, hum2: TCreature;
begin
  Result := False;
  if (Cret <> nil) and (Cret.GroupMembers.Count = 2) then begin
    hum1 := TCreature(Cret.GroupMembers.Objects[0]);
    hum2 := TCreature(Cret.GroupMembers.Objects[1]);

    if (hum1 <> nil) and (hum2 <> nil) and (hum1.RaceServer = RC_USERHUMAN) and
      (hum2.RaceServer = RC_USERHUMAN) then begin
      if (hum1.sex <> hum2.sex) then begin
        Result := True;
      end;
    end;
  end;

end;

//아이템의 능력치를 합
procedure TCreature.ApplyItemParameters(uitem: TUserItem; var aabil: TAddAbility);
var
  ps:  PTStdItem;
  std: TStdItem;
begin
  ps := UserEngine.GetStdItem(uitem.Index);
  if ps <> nil then begin
    std := ps^;
    ItemMan.GetUpgradeStdItem(uitem, std); //무기의 업그레이드된 능력치를 얻어온다.

    // 직업에 따른 용 아이템 능력치 차등 적용(2004/01/08 sonmg)
    ApplyItemParametersByJob(uitem, std);

    case ps.StdMode of
      5, 6: //무기류 AC:정확  MAC:민첩
      begin
        aabil.HIT := aabil.HIT + Hibyte(std.AC);

        //공격속도 적용
        aabil.HitSpeed := aabil.HitSpeed + ItemMan.RealAttackSpeed(
          HIBYTE(std.MAC));

{
            if Hibyte(std.MAC) > 10 then
               aabil.HitSpeed := aabil.HitSpeed + (Hibyte(std.MAC) - 10) //공격속도 (+)
            else
               aabil.HitSpeed := aabil.HitSpeed - Hibyte(std.MAC); //공격속도 (-)
}
        aabil.Luck     := aabil.Luck + Lobyte(std.AC);   //게임상의 이벤트를 통해 붙음
        aabil.UnLuck   := aabil.UnLuck + Lobyte(std.MAC);
        //게임상의 이벤트를 통해 붙음(피케이)
        aabil.Slowdown := aabil.Slowdown + std.Slowdown;
        aabil.Poison   := aabil.Poison + std.Tox;

        // 강도(무기, 팔찌에 적용)
        if std.SpecialPwr in [1..10] then
          aabil.WeaponStrong := std.SpecialPwr;
        //무기의 강도, 강도가 높으면 잘 안뽀개짐
      end;
      10, 11: //옷(added by sonmg)
      begin
        aabil.AC  := MakeWord(Lobyte(aabil.AC) + Lobyte(std.AC),
          Hibyte(aabil.AC) + Hibyte(std.AC));
        aabil.MAC := MakeWord(Lobyte(aabil.MAC) + Lobyte(std.MAC),
          Hibyte(aabil.MAC) + Hibyte(std.MAC));

        aabil.SPEED      := aabil.SPEED + std.Agility;
        aabil.AntiMagic  := aabil.AntiMagic + std.MgAvoid;
        aabil.AntiPoison := aabil.AntiPoison + std.ToxAvoid;

        // 2004/07/06(sonmg)
        aabil.HP := aabil.HP + std.HpAdd;
        aabil.MP := aabil.MP + std.MpAdd;

        // 용아이템 효과 새로추가(sonmg)
        if std.EffType1 > 0 then begin
          case std.EffType1 of
            EFFTYPE_HP_MP_ADD: //HP 획복량, MP 회복량
            begin
              //HP 획복량
              if (aabil.HealthRecover + std.EffRate1 > 65000) then
                aabil.HealthRecover := 65000
              else
                aabil.HealthRecover := aabil.HealthRecover + std.EffRate1;

              //MP 획복량
              if (aabil.SpellRecover + std.EffValue1 > 65000) then
                aabil.SpellRecover := 65000
              else
                aabil.SpellRecover := aabil.SpellRecover + std.EffValue1;
            end;
          end;
        end;
        if std.EffType2 > 0 then begin
          case std.EffType2 of
            EFFTYPE_HP_MP_ADD: //HP 획복량, MP 회복량
            begin
              //HP 획복량
              if (aabil.HealthRecover + std.EffRate2 > 65000) then
                aabil.HealthRecover := 65000
              else
                aabil.HealthRecover := aabil.HealthRecover + std.EffRate2;

              //MP 획복량
              if (aabil.SpellRecover + std.EffValue2 > 65000) then
                aabil.SpellRecover := 65000
              else
                aabil.SpellRecover := aabil.SpellRecover + std.EffValue2;
            end;
          end;
        end;

        // 옷 행운치 적용
        if std.EffType1 = EFFTYPE_LUCK_ADD then begin
          if aabil.Luck + std.EffValue1 > 255 then
            aabil.Luck := 255
          else
            aabil.Luck := aabil.Luck + std.EffValue1;   //옷에 붙은 행운
        end else if std.EffType2 = EFFTYPE_LUCK_ADD then begin
          if aabil.Luck + std.EffValue2 > 255 then
            aabil.Luck := 255
          else
            aabil.Luck := aabil.Luck + std.EffValue2;   //옷에 붙은 행운
        end;

      end;
      15: //투구(added by sonmg)
      begin
        aabil.AC  := MakeWord(Lobyte(aabil.AC) + Lobyte(std.AC),
          Hibyte(aabil.AC) + Hibyte(std.AC));
        aabil.MAC := MakeWord(Lobyte(aabil.MAC) + Lobyte(std.MAC),
          Hibyte(aabil.MAC) + Hibyte(std.MAC));

        aabil.HIT := aabil.HIT + std.Accurate;
        aabil.AntiMagic := aabil.AntiMagic + std.MgAvoid;
        aabil.AntiPoison := aabil.AntiPoison + std.ToxAvoid;
      end;
      19: //목걸이
      begin
        aabil.AntiMagic := aabil.AntiMagic + Hibyte(std.AC);
        aabil.UnLuck    := aabil.UnLuck + Lobyte(std.MAC);
        aabil.Luck      := aabil.Luck + Hibyte(std.MAC);

        aabil.HitSpeed := aabil.HitSpeed + std.AtkSpd;
        aabil.HIT      := aabil.HIT + std.Accurate;
        aabil.Slowdown := aabil.Slowdown + std.Slowdown;
        aabil.Poison   := aabil.Poison + std.Tox;
      end;
      20: //목걸이
      begin
        aabil.HIT   := aabil.HIT + Hibyte(std.AC);
        aabil.SPEED := aabil.SPEED + Hibyte(std.MAC);

        aabil.HitSpeed  := aabil.HitSpeed + std.AtkSpd;
        aabil.AntiMagic := aabil.AntiMagic + std.MgAvoid;
        aabil.Slowdown  := aabil.Slowdown + std.Slowdown;
        aabil.Poison    := aabil.Poison + std.Tox;
      end;
      21: //목걸이
      begin
        aabil.HealthRecover := aabil.HealthRecover + Hibyte(std.AC);
        aabil.SpellRecover  := aabil.SpellRecover + Hibyte(std.MAC);
        aabil.HitSpeed      := aabil.HitSpeed + Lobyte(std.AC);
        aabil.HitSpeed      := aabil.HitSpeed - Lobyte(std.MAC);

        aabil.HitSpeed := aabil.HitSpeed + std.AtkSpd;
        aabil.HIT      := aabil.HIT + std.Accurate;
        aabil.AntiMagic := aabil.AntiMagic + std.MgAvoid;
        aabil.Slowdown := aabil.Slowdown + std.Slowdown;
        aabil.Poison   := aabil.Poison + std.Tox;
      end;
      22: //반지
      begin
        aabil.AC  := MakeWord(Lobyte(aabil.AC) + Lobyte(std.AC),
          Hibyte(aabil.AC) + Hibyte(std.AC));
        aabil.MAC := MakeWord(Lobyte(aabil.MAC) + Lobyte(std.MAC),
          Hibyte(aabil.MAC) + Hibyte(std.MAC));

        aabil.HitSpeed := aabil.HitSpeed + std.AtkSpd;
        aabil.Slowdown := aabil.Slowdown + std.Slowdown;
        aabil.Poison   := aabil.Poison + std.Tox;

        //용아이템 효과 추가(sonmg)
        aabil.HIT := aabil.HIT + std.Accurate; //정확
        aabil.HP  := aabil.HP + std.HpAdd;   //HP
      end;
      23: //반지23
      begin
        aabil.AntiPoison    := aabil.AntiPoison + Hibyte(std.AC);
        aabil.PoisonRecover := aabil.PoisonRecover + Hibyte(std.MAC);
        aabil.HitSpeed      := aabil.HitSpeed + Lobyte(std.AC);
        aabil.HitSpeed      := aabil.HitSpeed - Lobyte(std.MAC);

        aabil.HitSpeed := aabil.HitSpeed + std.AtkSpd;
        aabil.Slowdown := aabil.Slowdown + std.Slowdown;
        aabil.Poison   := aabil.Poison + std.Tox;
      end;
      24, 26://팔찌
      begin
        // 강도(무기, 팔찌에 적용)
        if std.SpecialPwr in [1..10] then
          aabil.WeaponStrong := std.SpecialPwr;
        //무기의 강도, 강도가 높으면 잘 안뽀개짐

        case ps.StdMode of
          24: //팔찌24
          begin
            aabil.HIT   := aabil.HIT + Hibyte(std.AC);
            aabil.SPEED := aabil.SPEED + Hibyte(std.MAC);
          end;
          26: //팔찌26(added by sonmg)
          begin
            aabil.AC  := MakeWord(Lobyte(aabil.AC) + Lobyte(std.AC),
              Hibyte(aabil.AC) + Hibyte(std.AC));
            aabil.MAC :=
              MakeWord(Lobyte(aabil.MAC) + Lobyte(std.MAC), Hibyte(aabil.MAC) +
              Hibyte(std.MAC));

            aabil.HIT   := aabil.HIT + std.Accurate;
            aabil.SPEED := aabil.SPEED + std.Agility;

            //용아이템 효과 추가(sonmg)
            aabil.MP := aabil.MP + std.MpAdd;   //MP
          end;
        end;
      end;
      52: //신발(sonmg)
      begin
        aabil.AC  := MakeWord(Lobyte(aabil.AC) + Lobyte(std.AC),
          Hibyte(aabil.AC) + Hibyte(std.AC));
        aabil.MAC := MakeWord(Lobyte(aabil.MAC) + Lobyte(std.MAC),
          Hibyte(aabil.MAC) + Hibyte(std.MAC));

        aabil.SPEED := aabil.SPEED + std.Agility;
      end;
      54: //벨트(sonmg)
      begin
        aabil.AC  := MakeWord(Lobyte(aabil.AC) + Lobyte(std.AC),
          Hibyte(aabil.AC) + Hibyte(std.AC));
        aabil.MAC := MakeWord(Lobyte(aabil.MAC) + Lobyte(std.MAC),
          Hibyte(aabil.MAC) + Hibyte(std.MAC));

        aabil.HIT   := aabil.HIT + std.Accurate;
        aabil.SPEED := aabil.SPEED + std.Agility;
        aabil.AntiPoison := aabil.AntiPoison + std.ToxAvoid;
      end;
          // 2003/03/15 아이템 인벤토리 확장
      53: //수호석
      begin
        aabil.HP := aabil.HP + std.HpAdd;
        aabil.MP := aabil.MP + std.MpAdd;
      end;
      else begin
        aabil.AC  := MakeWord(Lobyte(aabil.AC) + Lobyte(std.AC),
          Hibyte(aabil.AC) + Hibyte(std.AC));
        aabil.MAC := MakeWord(Lobyte(aabil.MAC) + Lobyte(std.MAC),
          Hibyte(aabil.MAC) + Hibyte(std.MAC));
      end;
    end;
    aabil.DC := MakeWord(Lobyte(aabil.DC) + Lobyte(std.DC),
      _MIN(255, Hibyte(aabil.DC) + Hibyte(std.DC)));
    aabil.MC := MakeWord(Lobyte(aabil.MC) + Lobyte(std.MC),
      _MIN(255, Hibyte(aabil.MC) + Hibyte(std.MC)));
    aabil.SC := MakeWord(Lobyte(aabil.SC) + Lobyte(std.SC),
      _MIN(255, Hibyte(aabil.SC) + Hibyte(std.SC)));
  end;
end;

 ////////////////////////////////////////////////////////////////////////////
 // 직업에 따른 용 아이템 능력치 차별 적용
procedure TCreature.ApplyItemParametersByJob(uitem: TUserItem; var std: TStdItem);
var
  ps: PTStdItem;
begin
  ps := UserEngine.GetStdItem(uitem.Index);
  if ps <> nil then begin

    // 주의 : ChangeItemByJob 과 동일한 값을 가져야 함(sonmg)

    //////////////////////////////////////
    //--------------
    //반지
    if (ps.StdMode = 22) and (ps.Shape = DRAGON_RING_SHAPE) then begin
      case Job of
        0: //warrior
        begin
          std.DC := MakeWord(Lobyte(std.DC), _MIN(255, Hibyte(std.DC) + 4));
          //하드코딩
          std.MC := 0;
          std.SC := 0;
        end;
        1: //wizard
        begin
          std.DC := 0;
          //그대로               std.MC := 0;
          std.SC := 0;
        end;
        2: //taoist
        begin
          //               std.DC := 0;
          std.MC := 0;
          //               std.SC := 0;
        end;
        3: //assassin
        begin
          std.DC := MakeWord(Lobyte(std.DC), _MIN(255, Hibyte(std.DC) + 4));
          //하드코딩
          std.MC := 0;
          std.SC := 0;
        end;
      end;//case
          //--------------
          //팔찌26
    end else if (ps.StdMode = 26) and (ps.Shape = DRAGON_BRACELET_SHAPE) then begin
      case Job of
        0: //warrior
        begin
          std.DC := MakeWord(Lobyte(std.DC) + 1, _MIN(255, Hibyte(std.DC) + 2));
          //하드코딩
          std.MC := 0;
          std.SC := 0;
          std.AC := MakeWord(Lobyte(std.AC), _MIN(255, Hibyte(std.AC) + 1));
          //하드코딩
        end;
        1: //wizard
        begin
          std.DC := 0;
          //               std.MC := 0;
          std.SC := 0;
          std.AC := MakeWord(Lobyte(std.AC), _MIN(255, Hibyte(std.AC) + 1));
          //하드코딩
        end;
        2: //taoist
        begin
          //               std.DC := 0;
          std.MC := 0;
          //               std.SC := 0;
          //               std.AC := 0;
        end;
        3: //assassin
        begin
          std.DC := MakeWord(Lobyte(std.DC) + 1, _MIN(255, Hibyte(std.DC) + 2));
          //하드코딩
          std.MC := 0;
          std.SC := 0;
          std.AC := MakeWord(Lobyte(std.AC), _MIN(255, Hibyte(std.AC) + 1));
          //하드코딩
        end;
      end;//case
          //--------------
          //목걸이
    end else if (ps.StdMode = 19) and (ps.Shape = DRAGON_NECKLACE_SHAPE) then begin
      case Job of
        0: //warrior
        begin
          //               std.DC := 0;
          std.MC := 0;
          std.SC := 0;
        end;
        1: //wizard
        begin
          std.DC := 0;
          //               std.MC := 0;
          std.SC := 0;
        end;
        2: //taoist
        begin
          std.DC := 0;
          std.MC := 0;
          //               std.SC := 0;
        end;
        3: //assassin
        begin
          //               std.DC := 0;
          std.MC := 0;
          std.SC := 0;
        end;
      end;//case
          //--------------
          //옷
    end else if ((ps.StdMode = 10) or (ps.StdMode = 11)) and
      (ps.Shape = DRAGON_DRESS_SHAPE) then begin
      case Job of
        0: //warrior
        begin
          //               std.DC := 0;
          std.MC := 0;
          std.SC := 0;
        end;
        1: //wizard
        begin
          std.DC := 0;
          //               std.MC := 0;
          std.SC := 0;
        end;
        2: //taoist
        begin
          std.DC := 0;
          std.MC := 0;
          //               std.SC := 0;
        end;
        3: //assassin
        begin
          //               std.DC := 0;
          std.MC := 0;
          std.SC := 0;
        end;
      end;//case
          //--------------
          //투구
    end else if (ps.StdMode = 15) and (ps.Shape = DRAGON_HELMET_SHAPE) then begin
      case Job of
        0: //warrior
        begin
          //               std.DC := 0;
          std.MC := 0;
          std.SC := 0;
        end;
        1: //wizard
        begin
          std.DC := 0;
          //               std.MC := 0;
          std.SC := 0;
        end;
        2: //taoist
        begin
          std.DC := 0;
          std.MC := 0;
          //               std.SC := 0;
        end;
        3: //assassin
        begin
          //               std.DC := 0;
          std.MC := 0;
          std.SC := 0;
        end;
      end;//case
          //--------------
          //무기
    end else if ((ps.StdMode = 5) or (ps.StdMode = 6)) and
      (ps.Shape = DRAGON_WEAPON_SHAPE) then begin
      case Job of
        0: //warrior
        begin
          std.DC := MakeWord(Lobyte(std.DC) + 1, _MIN(255, Hibyte(std.DC) + 28));
          //하드코딩
          std.MC := 0;
          std.SC := 0;
          // 행운에서 2를 뺀다. 즉, Lo(AC)에서 2를 뺀다.
          std.AC := MakeWord(LOBYTE(std.AC) - 2, HIBYTE(std.AC));

          // 행운을 공속으로 바꾸고 행운을 없앤다.
          // Lo(AC)를 Hi(MAC)에 집어 넣는다.
          //               std.MAC := MakeWord(LOBYTE(std.MAC), LOBYTE(std.AC) + 10);
          //               std.AC := MakeWord(0, HIBYTE(std.AC));
        end;
        1: //wizard
        begin
          //               std.DC := 0;
          //               std.MC := 0;
          std.SC := 0;
          // 공속에서 12를 빼고 행운값은 반영한다.
          if HIBYTE(std.MAC) > 12 then
            std.MAC := MakeWord(LOBYTE(std.MAC), HIBYTE(std.MAC) - 12)
          else
            std.MAC := MakeWord(LOBYTE(std.MAC), 0);

        end;
        2: //taoist
        begin
          std.DC := MakeWord(Lobyte(std.DC) + 2, _MIN(255, Hibyte(std.DC) + 10));
          //하드코딩
          std.MC := 0;
          //               std.SC := 0;
          // 행운에서 2를 뺀다. 즉, Lo(AC)에서 2를 뺀다.
          std.AC := MakeWord(LOBYTE(std.AC) - 2, HIBYTE(std.AC));

          // 행운을 공속으로 바꾸고 행운을 없앤다.
          // Lo(AC)를 Hi(MAC)에 집어 넣는다.
          //               std.MAC := MakeWord(LOBYTE(std.MAC), LOBYTE(std.AC) + 10);
          //               std.AC := MakeWord(0, HIBYTE(std.AC));
        end;
        3: //assassin
        begin
          std.DC := MakeWord(Lobyte(std.DC) + 1, _MIN(255, Hibyte(std.DC) + 28));
          //하드코딩
          std.MC := 0;
          std.SC := 0;
          // 행운에서 2를 뺀다. 즉, Lo(AC)에서 2를 뺀다.
          std.AC := MakeWord(LOBYTE(std.AC) - 2, HIBYTE(std.AC));

          // 행운을 공속으로 바꾸고 행운을 없앤다.
          // Lo(AC)를 Hi(MAC)에 집어 넣는다.
          //               std.MAC := MakeWord(LOBYTE(std.MAC), LOBYTE(std.AC) + 10);
          //               std.AC := MakeWord(0, HIBYTE(std.AC));
        end;
      end;//case
          //--------------
          //수호석(막대사탕)
    end else if (ps.StdMode = 53) then begin
      if (ps.Shape = LOLLIPOP_SHAPE) then begin
        case Job of
          0: //warrior
          begin
            std.DC := MakeWord(Lobyte(std.DC), _MIN(255, Hibyte(std.DC) + 2));
            //하드코딩
            std.MC := 0;
            std.SC := 0;
          end;
          1: //wizard
          begin
            std.DC := 0;
            std.MC := MakeWord(Lobyte(std.MC), _MIN(255, Hibyte(std.MC) + 2));
            //하드코딩
            std.SC := 0;
          end;
          2: //taoist
          begin
            std.DC := 0;
            std.MC := 0;
            std.SC := MakeWord(Lobyte(std.SC), _MIN(255, Hibyte(std.SC) + 2));
            //하드코딩
          end;
          3: //assassin
          begin
            std.DC := MakeWord(Lobyte(std.DC), _MIN(255, Hibyte(std.DC) + 2));
            //하드코딩
            std.MC := 0;
            std.SC := 0;
          end;
        end;//case
      end else if (std.Shape = GOLDMEDAL_SHAPE) or (std.Shape = SILVERMEDAL_SHAPE) or
        (std.Shape = BRONZEMEDAL_SHAPE) then begin
        case Job of
          0: //warrior
          begin
            std.DC := MakeWord(Lobyte(std.DC), _MIN(255, Hibyte(std.DC)));
            std.MC := 0;
            std.SC := 0;
          end;
          1: //wizard
          begin
            std.DC := 0;
            std.MC := MakeWord(Lobyte(std.MC), _MIN(255, Hibyte(std.MC)));
            std.SC := 0;
          end;
          2: //taoist
          begin
            std.DC := 0;
            std.MC := 0;
            std.SC := MakeWord(Lobyte(std.SC), _MIN(255, Hibyte(std.SC)));
          end;
          3: //assassin
          begin
            std.DC := MakeWord(Lobyte(std.DC), _MIN(255, Hibyte(std.DC)));
            std.MC := 0;
            std.SC := 0;
          end;
        end;//case
      end;
    end;//if series
        //////////////////////////////////////
        // 2004-06-29 신규갑옷(파황천마의) 직업별 능력치
    if ((ps.StdMode = 10) or (ps.StdMode = 11)) and (ps.Shape = DRESS_SHAPE_PBKING)
    then begin
      case Job of
        0: //warrior
        begin
          std.DC    := MakeWord(Lobyte(std.DC), _MIN(255, Hibyte(std.DC) + 2));
          //하드코딩
          std.MC    := 0;
          std.SC    := 0;
          std.AC    := MakeWord(Lobyte(std.AC) + 2, _MIN(255, Hibyte(std.AC) + 4));
          //하드코딩
          //               std.MAC := 0;
          std.MpAdd := std.MpAdd + 30;   //하드코딩
        end;
        1: //wizard
        begin
          std.DC    := 0;
          //               std.MC := 0;
          std.SC    := 0;
          //               std.AC := 0;
          std.MAC   := MakeWord(Lobyte(std.MAC) + 1, _MIN(255, Hibyte(std.MAC) + 2));
          //하드코딩
          std.HpAdd := std.HpAdd + 30;   //하드코딩
        end;
        2: //taoist
        begin
          std.DC    := MakeWord(Lobyte(std.DC) + 1, _MIN(255, Hibyte(std.DC)));
          //하드코딩
          std.MC    := 0;
          //               std.SC := 0;
          std.AC    := MakeWord(Lobyte(std.AC) + 1, _MIN(255, Hibyte(std.AC)));
          //하드코딩
          std.MAC   := MakeWord(Lobyte(std.MAC) + 1, _MIN(255, Hibyte(std.MAC)));
          //하드코딩
          std.HpAdd := std.HpAdd + 20;   //하드코딩
          std.MpAdd := std.MpAdd + 10;   //하드코딩
        end;
        3: //assassin
        begin
          std.DC    := MakeWord(Lobyte(std.DC), _MIN(255, Hibyte(std.DC) + 2));
          //하드코딩
          std.MC    := 0;
          std.SC    := 0;
          std.AC    := MakeWord(Lobyte(std.AC) + 2, _MIN(255, Hibyte(std.AC) + 4));
          //하드코딩
          //               std.MAC := 0;
          std.MpAdd := std.MpAdd + 30;   //하드코딩
        end;
      end;//case
    end;

  end;//if
end;

// 2003/03/15 아이템 인벤토리 확장
procedure TCreature.ApplyItemParametersEx(uitem: TUserItem; var AWabil: TAbility);
var
  ps:  PTStdItem;
  std: TStdItem;
begin
  ps := UserEngine.GetStdItem(uitem.Index);
  if ps <> nil then begin
    std := ps^;
    ItemMan.GetUpgradeStdItem(uitem, std); //무기의 업그레이드된 능력치를 얻어온다.
    case ps.StdMode of
      52: //신발류
      begin
        if std.EffType1 > 0 then begin
          case std.EffType1 of
            EFFTYPE_TWOHAND_WEHIGHT_ADD: if (AWabil.MaxHandWeight +
                std.EffValue1 > 255) then
                AWabil.MaxHandWeight := 255
              else
                AWabil.MaxHandWeight := AWabil.MaxHandWeight + std.EffValue1;
            // Overflow 방지를 위해 수정(sonmg)
            EFFTYPE_EQUIP_WHEIGHT_ADD: if (AWabil.MaxWearWeight +
                std.EffValue1 > 255) then
                AWabil.MaxWearWeight := 255
              else
                AWabil.MaxWearWeight := AWabil.MaxWearWeight + std.EffValue1;
          end;
        end;
        if std.EffType2 > 0 then begin
          case std.EffType2 of
            EFFTYPE_TWOHAND_WEHIGHT_ADD: if (AWabil.MaxHandWeight +
                std.EffValue2 > 255) then
                AWabil.MaxHandWeight := 255
              else
                AWabil.MaxHandWeight := AWabil.MaxHandWeight + std.EffValue2;
            // Overflow 방지를 위해 수정(sonmg)
            EFFTYPE_EQUIP_WHEIGHT_ADD: if (AWabil.MaxWearWeight +
                std.EffValue2 > 255) then
                AWabil.MaxWearWeight := 255
              else
                AWabil.MaxWearWeight := AWabil.MaxWearWeight + std.EffValue2;
          end;
        end;
      end;
      54: //벨트
      begin
        if std.EffType1 > 0 then begin
          case std.EffType1 of
            EFFTYPE_BAG_WHIGHT_ADD: if (AWabil.MaxWeight +
                std.EffValue1 > 65000) then
                AWabil.MaxWeight := 65000
              else
                AWabil.MaxWeight := AWabil.MaxWeight + std.EffValue1;
          end;
        end;
        if std.EffType2 > 0 then begin
          case std.EffType2 of
            EFFTYPE_BAG_WHIGHT_ADD: if (AWabil.MaxWeight +
                std.EffValue2 > 65000) then
                AWabil.MaxWeight := 65000
              else
                AWabil.MaxWeight := AWabil.MaxWeight + std.EffValue2;
          end;
        end;
      end;

    end; //case
  end;
end;

function TCreature.MakeWeaponUnlock: boolean;
var
  hum: TUserHuman;
begin
  Result := False;

  if UseItems[U_WEAPON].Index <> 0 then begin
    if UseItems[U_WEAPON].Desc[3] > 0 then begin
      UseItems[U_WEAPON].Desc[3] := UseItems[U_WEAPON].Desc[3] - 1; //행운 감소
      SysMsg('A curse dwells in your weapon', 0);
      Result := True;
    end else begin
      if UseItems[U_WEAPON].Desc[4] < 10 then begin
        UseItems[U_WEAPON].Desc[4] := UseItems[U_WEAPON].Desc[4] + 1; //불운
        SysMsg('A curse dwells in your weapon', 0);
        Result := True;
      end;
    end;
    if RaceServer = RC_USERHUMAN then begin
      RecalcAbilitys;
      hum := TUserHuman(self);   //added by sonmg(2003/11/07)
      hum.SendUpdateItem(UseItems[U_WEAPON]);   //added by sonmg(2003/11/07)
      SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
      SendMsg(self, RM_SUBABILITY, 0, 0, 0, 0, '');
      //         Result := TRUE;
    end;
  end;
end;

procedure TCreature.TrainSkill(pum: PTUserMagic; train: integer);
begin
  if BoFastTraining then
    train := train * 3;
  pum.CurTrain := pum.CurTrain + train;
end;

//능력치의 합을 보낸다.
function TCreature.GetMyAbility: TAbility;
begin
  Result     := Abil;
  Result.HP  := AddAbil.HP + Abil.HP;
  Result.MP  := AddAbil.MP + Abil.MP;
  Result.AC  := MakeWord(_MIN(255, Lobyte(AddAbil.AC) + Lobyte(Abil.AC)),
    _MIN(255, Hibyte(AddAbil.AC) + Hibyte(Abil.AC)));
  Result.MAC := MakeWord(_MIN(255, Lobyte(AddAbil.MAC) + Lobyte(Abil.MAC)),
    _MIN(255, Hibyte(AddAbil.MAC) + Hibyte(Abil.MAC)));
  Result.DC  := MakeWord(_MIN(255, Lobyte(AddAbil.DC) + Lobyte(Abil.DC)),
    _MIN(255, Hibyte(AddAbil.DC) + Hibyte(Abil.DC)));
  Result.MC  := MakeWord(_MIN(255, Lobyte(AddAbil.MC) + Lobyte(Abil.MC)),
    _MIN(255, Hibyte(AddAbil.MC) + Hibyte(Abil.MC)));
  Result.SC  := MakeWord(_MIN(255, Lobyte(AddAbil.SC) + Lobyte(Abil.SC)),
    _MIN(255, Hibyte(AddAbil.SC) + Hibyte(Abil.SC)));
end;


function TCreature.GetMyLight: integer;

  function CheckLightValue: integer;
  var
    i:   integer;
    ps:  PTStdItem;
    CurrentLight: integer;
    hum: TUserHuman;
  begin
    CurrentLight := 0;

    if RaceServer = RC_USERHUMAN then begin
      hum := TUserHuman(self);
      if hum <> nil then begin
        // 50레벨 이펙트 발현시 1주자(기본 밝기 버그 수정 sonmg)
        if BoHighLevelEffect then begin
          if Abil.Level >= EFFECTIVE_HIGHLEVEL then begin
            CurrentLight := 1;
          end;
        end;
      end;
    end;

    // 모든착용아이템에 대하여 검사한다.
    for i := U_DRESS to U_CHARM do begin
      if (UseItems[i].Index > 0) and (UseItems[i].Dura > 0) then begin
        ps := UserEngine.GetStdItem(UseItems[i].Index);
        if ps <> nil then begin
          if CurrentLight < ps.light then begin
            CurrentLight := ps.Light;
          end;
        end;
      end;
    end;
    Result := CurrentLight;
  end;

{
    function checkLightIndex( index_ :integer ) :Boolean;
    begin
        case index_ of
        464, //형광수영복(남)
        465, //형광수영복(여)
        470, //여름의 전설
        471, //파도의 전설
        529, //천의무봉(남)
        530, //천의무봉(여)
        531, //무황성의(남)
        532, //무황성의(여)
        635, //천룡혼세환
        636, //천룡광마륜
        637, //천룡연월신
        638, //천룡불사의 (남)
        639, //천룡불사의 (여)
        640, //천룡추혼모
        641, //천룡신형탈명검
        642, //천룡신행보
        643  //천룡반향대
        : result := true
        else
          result := false;
        end;
    end;
}
var
  DressIndex: integer;
begin
  if BoTaiwanEventUser then begin
    Result := 4;
  end else begin
{
       //옷에 대한 인덱스 얻음.
       DressIndex := UseItems[U_DRESS].Index;
       if UseItems[U_DRESS].Dura <= 0 then DressIndex := 0;

       // 2003/07/03 이벤트용 코드 수영복들...
       if CheckLightIndex( DressIndex ) then
       begin
          Result := 5
       end
       else
       begin
          if (UseItems[U_RIGHTHAND].Index > 0) and (UseItems[U_RIGHTHAND].Dura > 0) then
             Result := 3 //초 밝기
          else
             Result := 0;
       end;
}
    Result := CheckLightValue;
  end;

end;


function TCreature.GetUserName: string;
begin
  if RaceServer <> RC_USERHUMAN then begin
    GetValidStrNoVal(UserName, Result);   //숫자 이름은 안나오게 한다.

    if Master <> nil then begin  //주인이 있으면..
      if not Master.BoSuperviserMode then begin
        //분신
        if RaceServer = RC_CLONE then begin
          if Master.RaceServer = RC_USERHUMAN then
            Result := Master.UserName;
        end else begin
          //감시자가 아니면
          Result := Result + '(' + Master.UserName + ')';
        end;
      end;
    end;

  end else begin
    Result := UserName;

    if BoTaiwanEventUser then  //대만 아이템 이벤트
      Result := Result + '(' + TaiwanEventItemName + ')';

    if MyGuild <> nil then begin
      if UserCastle.IsOurCastle(TGuild(MyGuild)) then begin //우리문파가 사북성을 점령
        Result := Result + '\' +  //클라이언트에서는 반대로 이름이 맨 나중에 써진다.
          TGuild(MyGuild).GuildName + '(' + UserCastle.CastleName + ')';
      end else begin
        if UserCastle.BoCastleUnderAttack then
          if (BoInFreePKArea) or (UserCastle.IsCastleWarArea(PEnvir, CX, CY)) then
            Result := Result + '\' + TGuild(MyGuild).GuildName;
      end;
    end;

  end;
end;

function TCreature.GetHungryState: integer;
begin
  Result := HungryState div 1000;
  if Result > 4 then
    Result := 4; //0, 1, 2, 3, 4
end;

function TCreature.GetQuestMark(idx: integer): integer;
var
  dcount, mcount: integer;
begin
  Result := 0;
  idx    := idx - 1;
  if idx >= 0 then begin
    dcount := idx div 8;
    mcount := idx mod 8;
    if dcount in [0..MAXQUESTBYTE - 1] then begin
      if QuestStates[dcount] and ($80 shr mcount) <> 0 then
        Result := 1
      else
        Result := 0;
    end;
  end;
end;

procedure TCreature.SetQuestMark(idx, Value: integer); // value: 0 or 1
var
  dcount, mcount: integer;
  val: byte;
begin
  idx := idx - 1;
  if idx >= 0 then begin
    dcount := idx div 8;
    mcount := idx mod 8;
    if dcount in [0..MAXQUESTBYTE - 1] then begin
      val := QuestStates[dcount];
      if Value = 0 then
        QuestStates[dcount] := val and (not ($80 shr mcount))
      else
        QuestStates[dcount] := val or ($80 shr mcount);
    end;
  end;
end;

function TCreature.GetQuestOpenIndexMark(idx: integer): integer;
var
  dcount, mcount: integer;
begin
  Result := 0;
  idx    := idx - 1;
  if idx >= 0 then begin
    dcount := idx div 8;
    mcount := idx mod 8;
    if dcount in [0..MAXQUESTINDEXBYTE - 1] then begin
      if QuestIndexOpenStates[dcount] and ($80 shr mcount) <> 0 then
        Result := 1
      else
        Result := 0;
    end;
  end;
end;

procedure TCreature.SetQuestOpenIndexMark(idx, Value: integer);
var
  dcount, mcount: integer;
  val: byte;
begin
  idx := idx - 1;
  if idx >= 0 then begin
    dcount := idx div 8;
    mcount := idx mod 8;
    if dcount in [0..MAXQUESTINDEXBYTE - 1] then begin
      val := QuestIndexOpenStates[dcount];
      if Value = 0 then
        QuestIndexOpenStates[dcount] := val and (not ($80 shr mcount))
      else
        QuestIndexOpenStates[dcount] := val or ($80 shr mcount);
    end;
  end;
end;

function TCreature.GetQuestFinIndexMark(idx: integer): integer;
var
  dcount, mcount: integer;
begin
  Result := 0;
  idx    := idx - 1;
  if idx >= 0 then begin
    dcount := idx div 8;
    mcount := idx mod 8;
    if dcount in [0..MAXQUESTINDEXBYTE - 1] then begin
      if QuestIndexFinStates[dcount] and ($80 shr mcount) <> 0 then
        Result := 1
      else
        Result := 0;
    end;
  end;
end;

procedure TCreature.SetQuestFinIndexMark(idx, Value: integer);
var
  dcount, mcount: integer;
  val: byte;
begin
  idx := idx - 1;
  if idx >= 0 then begin
    dcount := idx div 8;
    mcount := idx mod 8;
    if dcount in [0..MAXQUESTINDEXBYTE - 1] then begin
      val := QuestIndexFinStates[dcount];
      if Value = 0 then
        QuestIndexFinStates[dcount] := val and (not ($80 shr mcount))
      else
        QuestIndexFinStates[dcount] := val or ($80 shr mcount);
    end;
  end;
end;


procedure TCreature.DoDamageWeapon(wdam: integer);
var
  olddura, idura: integer;
  hum: TUserHuman;
begin
  if (UseItems[U_WEAPON].Index > 0) and (UseItems[U_WEAPON].Dura > 0) then begin
    idura   := UseItems[U_WEAPON].Dura;
    //Dura는 word값이기 때문에... idura(integer)로 계산했음
    olddura := Round(idura / 1000);
    idura   := idura - wdam;
    if idura <= 0 then begin
      idura := 0;
         (*
         UseItems[U_WEAPON].Dura := 0;
         //다 닮면 없어진다.
         if RaceServer = RC_USERHUMAN then begin
            hum := TUserHuman(self);
            hum.SendDelItem (UseItems[U_WEAPON]); //클라이언트에 없어진거 보냄
            //닳아 없어진거 로그 남김
            AddUserLog ('3'#9 +  //닳음_ +
                        MapName + ''#9 +
                        IntToStr(CX) + ''#9 +
                        IntToStr(CY) + ''#9 +
                        UserName + ''#9 +
                        UserEngine.GetStdItemName (UseItems[U_WEAPON].Index) + ''#9 +
                        IntToStr(UseItems[U_WEAPON].MakeIndex) + ''#9 +
                        IntToStr(BoolToInt(RaceServer = RC_USERHUMAN)) + ''#9 +
                        '0');
         end;
         UseItems[U_WEAPON].Index := 0; *)

      SysMsg(UserEngine.GetStdItemName(UseItems[U_WEAPON].Index) +
        '''s durability has dropped to 0.', 0);
      UseItems[U_WEAPON].Dura := 0;
      RecalcAbilitys;
      SendMsg(self, RM_DURACHANGE, U_WEAPON, UseItems[U_WEAPON].Dura,
        UseItems[U_WEAPON].DuraMax, 0, '');
      SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
      SendMsg(self, RM_SUBABILITY, 0, 0, 0, 0, '');
    end else
      UseItems[U_WEAPON].Dura := idura;

    if olddura <> Round(idura / 1000) then begin //내구성 수치 변경
      SendMsg(self, RM_DURACHANGE, U_WEAPON, UseItems[U_WEAPON].Dura,
        UseItems[U_WEAPON].DuraMax, 0, '');
    end;
  end;
end;

function TCreature.GetAttackPower(damage, ranval: integer): integer;
var
  v1, v2: integer;
begin
  if ranval < 0 then
    ranval := 0;
  if Luck > 0 then begin
    if Random(10 - _MIN(9, Luck)) = 0 then
      Result := damage + ranval //행운인경우
    else
      Result := damage + Random(ranval + 1);
  end else begin
    Result := damage + Random(ranval + 1);
    if Luck < 0 then begin
      //10보다 큰 불운인경우 100% 최소데미지 적용(sonmg 2004/08/16)
      if Random(_MAX(0, 10 - _MAX(0, -Luck))) = 0 then
        Result := damage;  //불운인경우
    end;
  end;
end;

// 2003/03/15 신규무공 추가로 루틴 변경

function TCreature._Attack(hitmode: word; targ: TCreature): boolean;


  function DirectAttack(target: TCreature; damage: integer): boolean;
  begin
    Result := False;
    if (RaceServer = RC_USERHUMAN) and (target.RaceServer = RC_USERHUMAN) and
      ((target.InSafeZone) or (InSafeZone)) then
      exit;  //안전지대
    if IsProperTarget(target) then begin
      if Random(target.SpeedPoint) < AccuracyPoint then begin
        target.StruckDamage(damage, self);
        target.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, damage{wparam},
          target.WAbil.HP{lparam1}, target.WAbil.MaxHP{lparam2},
          longint(self){hiter}, '', 500);
        //몬스터한테는 직접전달해야 함..
        if target.RaceServer <> RC_USERHUMAN then
          target.SendMsg(target, RM_STRUCK, damage, target.WAbil.HP,
            target.WAbil.MaxHP, longint(self), '');
        Result := True;
      end;
    end;
  end;


  //사자후의 개별공격
  function DirectStoneAttack(target: TCreature; damage: integer): boolean;
  begin
    Result := False;

    if IsProperTarget(target) then begin
      //맞는지 결정
      if (damage > 0) and  // 데미지가 있어 야 되고
        (target.Abil.Level < Self.Abil.Level + 4) and
        //자신의 레벨보다 4단계 미만만 되고
        (target.Abil.Level < 60) // 왕급몬스터에게는 통하지 않음
      then begin
        target.MakePoison(POISON_DONTMOVE, damage, 0);   //마비
        Result := True;
      end;

    end;
  end;

  // 돌 공격
  function StoneAttack(damage: integer): TCreature;
  var
    i, j, dir, xx, yy: integer;
    target: TCreature;
  begin
    Result := nil;
    for i := -2 to 2 do begin
      for j := -2 to 2 do begin
        xx     := CX + i;
        yy     := CY + j;
        target := TCreature(PEnvir.GetCreature(xx, yy, True));

        if (damage > 0) and (target <> nil) then begin
          if target.RaceServer <> RC_USERHUMAN then begin
            if (DirectStoneAttack(target, damage)) then begin
              Result := Target;
            end;
          end;
        end;

      end; // for j
    end; // for i
  end;


  function SwordLongAttack(damage: integer): boolean;
  var
    xx, yy: integer;
    target: TCreature;
  begin
    Result := False;
    if GetNextPosition(PEnvir, CX, CY, Dir, 2, xx, yy) then begin
      target := TCreature(PEnvir.GetCreature(xx, yy, True));
      if (damage > 0) and (target <> nil) then
        if IsProperTarget(target) then begin
          Result := DirectAttack(target, damage);
          SelectTarget(target);
        end;
    end;
  end;

  function SwordWideAttack(damage: integer): boolean;
  const
    valarr: array[0..2] of integer = (7, 1, 2);
  var
    i, ndir, xx, yy: integer;
    target: TCreature;
  begin
    Result := False;
    for i := 0 to 2 do begin
      ndir := (Dir + valarr[i]) mod 8;
      if GetNextPosition(PEnvir, CX, CY, ndir, 1, xx, yy) then begin
        target := TCreature(PEnvir.GetCreature(xx, yy, True));
        if (damage > 0) and (target <> nil) then
          if IsProperTarget(target) then begin
            Result := DirectAttack(target, damage);
            SelectTarget(target);
          end;
      end;
    end;
  end;
  // 2003/03/15 산규무공 추가로 루틴 변경
  function SwordCrossAttack(damage: integer): boolean;
  const
    valarr: array[0..6] of integer = (7, 1, 2, 3, 4, 5, 6);
  var
    i, ndir, xx, yy: integer;
    target: TCreature;
  begin
    Result := False;
    for i := 0 to 6 do begin
      ndir := (Dir + valarr[i]) mod 8;
      if GetNextPosition(PEnvir, CX, CY, ndir, 1, xx, yy) then begin
        target := TCreature(PEnvir.GetCreature(xx, yy, True));
        if (damage > 0) and (target <> nil) then
          if IsProperTarget(target) then begin
            if target.RaceServer <> RC_USERHUMAN then
              Result := DirectAttack(target, damage)
            else
              Result := DirectAttack(target, Round(damage * 0.8));
            SelectTarget(target);
          end;
      end;
    end;
  end;

{
   var
      ndir: byte;
      rx, ry, xx, yy: integer;
      target: TCreature;
      procedure __DAttack;
      begin
         if GetNextPosition (PEnvir, rx, ry, ndir, 1, xx, yy) then begin
            target := TCreature (PEnvir.GetCreature (xx, yy, TRUE));
            if (damage > 0) and (target <> nil) then
               Result := DirectAttack (target, damage);
         end;
      end;
   begin
      Result := FALSE;
      ndir := Dir; GetNextPosition (PEnvir, CX, CY, ndir, 1, rx, ry);
      //정면 앞
      __DAttack;
      //오른쪽
      ndir := GetTurnDir (Dir, 2);
      __DAttack;
      //왼쪽
      ndir := GetTurnDir (Dir, 6);
      __DAttack;
   end;
}
var
  dam, seconddam, armor, olddura, idura, weapondamage, n: integer;
  hum:     TUserHuman;
  addplus: boolean;
  Gap, MoC, Dur: integer;
begin
  Result := False;
  try
    addplus := False;  //풀러스 파워가 먹혔느지 여부
    weapondamage := 0;
    dam := 0;
    seconddam := 0;
    if targ <> nil then begin
      with WAbil do
        dam := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));
      //검법으로 향상된 파워
      if (hitmode = HM_POWERHIT) and (BoAllowPowerHit) then begin
        BoAllowPowerHit := False;
        dam     := dam + HitPowerPlus;
        addplus := True;
      end;
      if (hitmode = HM_slashhit) and (BoAllowslashhit) then begin
        BoAllowslashhit := False;
        dam     := dam + HitPowerPlus;
        addplus := True;
      end;
      if (hitmode = HM_FIREHIT) and (BoAllowFireHit) then begin
        BoAllowFireHit := False;
        with WAbil do
          dam := dam + Round(dam / 100 * (HitDouble * 10));
        //GetAttackPower (Lobyte(DC), ShortInt(Hibyte(DC)-Lobyte(DC)));
        addplus := True;
      end;
      // 2003/03/15 광풍참...재검토
{
         if (hitmode = HM_CROSSHIT) then begin
            BoAllowPowerHit := FALSE;
            dam := dam + HitPowerPlus;
            addplus := TRUE;
         end;
}
      // 여기다 넣어볼까? 둔화 / 중독 sonmg(2003/11/07)
      // ...둔화판정...
      //평화공격시 둔화/중독 걸리는 버그 수정(sonmg 2004/01/13)
      if IsProperTarget(targ) then begin
        if (targ.Abil.Level < 60) and (targ.StatusArr[POISON_SLOW] = 0) and
          (AddAbil.Slowdown > 0) and (Random(20) <= AddAbil.Slowdown) and
          (Random(50) > targ.AntiMagic) then begin // 100->50
          MoC := 1;
          Gap := targ.Abil.Level - Abil.Level;
          if Gap > 10 then
            Gap := 10;
          if Gap < -10 then
            Gap := -10;
          if targ.RaceServer = RC_USERHUMAN then
            MoC := 2;
          if Random(100) < (20 + (AddAbil.Slowdown - Gap) div Moc) then begin
            Dur := (900 * AddAbil.Slowdown + 3300) div 1000;
            targ.MakePoison(POISON_SLOW, Dur + 1, 1);
          end;
          // ...중독판정...
        end else if (targ.Abil.Level < 60) and (AddAbil.Poison > 0) and
          (Random(20) <= AddAbil.Poison) and (6 >= Random(7 + targ.AntiPoison)) then
        begin
          MoC := 1;
          Gap := targ.Abil.Level - Abil.Level;
          if Gap > 10 then
            Gap := 10;
          if Gap < -10 then
            Gap := -10;
          if targ.RaceServer = RC_USERHUMAN then
            MoC := 2;
          if Random(100) < (20 + (AddAbil.Poison - Gap) div Moc) then begin
            targ.SendDelayMsg(self, RM_MAKEPOISON, POISON_DECHEALTH{wparam},
              5{pwr(time)}, integer(self), AddAbil.Poison, '', 1000);
          end;
        end;
      end;

    end else begin
      with WAbil do
        dam := GetAttackPower(Lobyte(DC), shortint(Hibyte(DC) - Lobyte(DC)));
      //검법으로 향상된 파워
      if (hitmode = HM_POWERHIT) and (BoAllowPowerHit) then begin
        BoAllowPowerHit := False;
        dam     := dam + HitPowerPlus;
        addplus := True;
      end;
      if (hitmode = HM_slashhit) and (BoAllowslashhit) then begin
        BoAllowslashhit := False;
        dam     := dam + HitPowerPlus;
        addplus := True;
      end;
    end;

    //긴 거리 공격 (어검)
    if hitmode = HM_LONGHIT then begin
      seconddam := 0;
      if RaceServer = RC_USERHUMAN then begin
        if PLongHitSkill <> nil then
          seconddam := Round(dam / (PLongHitSkill.pDef.MaxTrainLevel + 2) *
            (PLongHitSkill.Level + 2));
      end else
        seconddam := dam;
      if seconddam > 0 then
        SwordLongAttack(seconddam);
    end;
    //주변 공격  (반월)
    if hitmode = HM_WIDEHIT then begin
      seconddam := 0;
      if RaceServer = RC_USERHUMAN then begin
        if PWideHitSkill <> nil then
          seconddam := Round(dam / (PWideHitSkill.pDef.MaxTrainLevel + 10) *
            (PWideHitSkill.Level + 2));
      end else
        seconddam := dam;
      if seconddam > 0 then
        SwordWideAttack(seconddam);
    end;
    //Assassin Skill 2
    if hitmode = HM_WIDEHIT2 then begin
      seconddam := 0;
      if RaceServer = RC_USERHUMAN then begin
        if PWideHit2Skill <> nil then
          seconddam := Round(dam / (PWideHit2Skill.pDef.MaxTrainLevel + 10) *
            (PWideHit2Skill.Level + 2));
      end else
        seconddam := dam;
      if seconddam > 0 then
        SwordWideAttack(seconddam);
    end;
    //크로스 공격 -> 광풍참
    if hitmode = HM_CROSSHIT then begin
      seconddam := 0;
      if RaceServer = RC_USERHUMAN then begin
        if PCrossHitSkill <> nil then
          seconddam := Round(dam / (PCrossHitSkill.pDef.MaxTrainLevel + 11) *
            (PCrossHitSkill.Level + 3));
      end else
        seconddam := dam;
      if seconddam > 0 then
        SwordCrossAttack(seconddam);
    end;
    //쌍룡참
    if (hitmode = HM_TWINHIT) and (targ <> nil) then begin
      dam := dam + HitPowerPlus;
      seconddam := dam;
      DirectAttack(targ, seconddam);
      // 상태이상...스턴판정
      if (targ.Abil.Level < 60) and (targ.StatusArr[POISON_STUN] = 0) and
        (Random(50) > targ.AntiMagic) then begin   // 100->50
        MoC := 1;
        //            Gap := targ.Abil.Level - Abil.Level;
        //            if Gap > 10 then Gap := 10;
        //            if Gap <-10 then Gap :=-10;
        if targ.RaceServer = RC_USERHUMAN then
          MoC := 2;
        if ((MoC = 1) and (Random(100) < 5 * (PTwinHitSkill.Level + 1))) or
          ((MoC = 2) and (Random(100) < 2 * (PTwinHitSkill.Level + 1))) then begin
          Dur := Round(1.5 + 0.8 * PTwinHitSkill.Level);
          targ.MakePoison(POISON_STUN, Dur, 1);
        end;
      end;
      if BoAllowTwinHit = 1 then begin  //쌍룡참 해제..
        //            SysMsg ('쌍룡참이 시전되었습니다.', 1);
        //              SysMsg ('TwinDrakeBlade is used.', 1);   //이태리측 요청으로 삭제(2004/09/22)
        BoAllowTwinHit := 2;
      end;
    end;

    try
      //주위몬스터 돌됨  -> 사자후
      if hitmode = HM_STONEHIT then begin
        seconddam := 0;
        if (RaceServer = RC_USERHUMAN) and (PStoneHitSkill <> nil) then begin
          //몬스터 돌되는 시간 설정
          case PStoneHitSkill.Level of
            0: seconddam := 5;
            1: seconddam := 6;
            2: seconddam := 7;
            3: seconddam := 8;
          end;

          targ := StoneAttack(seconddam);
          if targ <> nil then
            dam := 0;
        end;
      end;

    except
      MainOutMessage('EXCEPTION STONEHIT');
    end;

    if targ = nil then      //어검, 반월 자동수련을 막기 위해서
      exit;

    //어검,반월 등은 targ와 상관없이 _Attack안으로 들어온다.
    if IsProperTarget(targ) then begin
      if AccuracyPoint > Random(targ.SpeedPoint) then begin
        ;
      end else
        dam := 0;
    end else
      dam := 0;

    if dam > 0 then begin
      dam := targ.GetHitStruckDamage(self, dam);
      weapondamage := Random(5) + 2 - AddAbil.WeaponStrong;
      //단단한 무기는 내구가 잘 안단다.
    end;

    if (dam > 0) or (hitmode = HM_STONEHIT) then begin

      if (hitmode <> HM_STONEHIT) then begin
        targ.StruckDamage(dam, self);
        targ.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
          targ.WAbil.HP{lparam1}, targ.WAbil.MaxHP{lparam2},
          longint(self){hiter}, '', 200);

        //때리는자가 마비의반지를 끼고 있음
        if BoAbilMakeStone then begin
          if Random(5 + targ.AntiPoison) = 0 then
            targ.MakePoison(POISON_STONE, 5{시간}, 0);   //마비
        end;

        //때리는자가 밀화 세트를 끼고 있음 (체력 흡수)
        if SuckupEnemyHealthRate > 0 then begin
          SuckupEnemyHealth :=
            SuckupEnemyHealth + (dam / 100 * SuckupEnemyHealthRate);
          if SuckupEnemyHealth >= 2 then begin
            n := Trunc(SuckupEnemyHealth);
            SuckupEnemyHealth := SuckupEnemyHealth - n;
            DamageHealth(-n, 0);
          end;
        end;

      end;

      //검술 향상
      if (PSwordSkill <> nil) and (targ.RaceServer >= RC_ANIMAL) then begin
        if PSwordSkill.Level < 3 then begin
          if Abil.Level >= PSwordSkill.pDef.NeedLevel[PSwordSkill.Level] then begin
            TrainSkill(PSwordSkill, 1 + Random(3));
            if not CheckMagicLevelup(PSwordSkill) then
              SendDelayMsg(self, RM_MAGIC_LVEXP, 0,
                PSwordSkill.pDef.MagicId, PSwordSkill.Level,
                PSwordSkill.CurTrain, '', 3000);
          end;
        end;
      end;
      //검술 향상 2 (예도검법)
      if addplus then begin
        if (PPowerHitSkill <> nil) and (targ.RaceServer >= RC_ANIMAL) then begin
          if PPowerHitSkill.Level < 3 then begin
            if Abil.Level >= PPowerHitSkill.pDef.NeedLevel[
              PPowerHitSkill.Level] then begin
              TrainSkill(PPowerHitSkill, 1 + Random(3));
              if not CheckMagicLevelup(PPowerHitSkill) then
                SendDelayMsg(self, RM_MAGIC_LVEXP, 0,
                  PPowerHitSkill.pDef.MagicId, PPowerHitSkill.Level,
                  PPowerHitSkill.CurTrain, '', 3000);
            end;
          end;
        end;
      end;

      if addplus then begin
        if (PslashhitSkill <> nil) and (targ.RaceServer >= RC_ANIMAL) then begin
          if PslashhitSkill.Level < 3 then begin
            if Abil.Level >= PslashhitSkill.pDef.NeedLevel[
              PslashhitSkill.Level] then begin
              TrainSkill(PslashhitSkill, 1 + Random(3));
              if not CheckMagicLevelup(PslashhitSkill) then
                SendDelayMsg(self, RM_MAGIC_LVEXP, 0,
                  PslashhitSkill.pDef.MagicId, PslashhitSkill.Level,
                  PslashhitSkill.CurTrain, '', 3000);
            end;
          end;
        end;
        end;
      //검술 향상 3 (어검술)
      if (hitmode = HM_LONGHIT) and (PLongHitSkill <> nil) and
        (targ.RaceServer >= RC_ANIMAL) then begin
        if PLongHitSkill.Level < 3 then begin
          if Abil.Level >= PLongHitSkill.pDef.NeedLevel[PLongHitSkill.Level] then
          begin
            TrainSkill(PLongHitSkill, 1);
            if not CheckMagicLevelup(PLongHitSkill) then
              UpdateDelayMsgCheckParam1(self, RM_MAGIC_LVEXP,
                0, PLongHitSkill.pDef.MagicId, PLongHitSkill.Level,
                PLongHitSkill.CurTrain, '', 3000);
          end;
        end;
      end;
      //검술 향상 4 (반월검법)
      if (hitmode = HM_WIDEHIT) and (PWideHitSkill <> nil) and
        (targ.RaceServer >= RC_ANIMAL) then begin
        if PWideHitSkill.Level < 3 then begin
          if Abil.Level >= PWideHitSkill.pDef.NeedLevel[PWideHitSkill.Level] then
          begin
            TrainSkill(PWideHitSkill, 1);
            if not CheckMagicLevelup(PWideHitSkill) then
              UpdateDelayMsgCheckParam1(self, RM_MAGIC_LVEXP,
                0, PWideHitSkill.pDef.MagicId, PWideHitSkill.Level,
                PWideHitSkill.CurTrain, '', 3000);
          end;
        end;
      end;
      //Assassin Skill 2
      if (hitmode = HM_WIDEHIT2) and (PWideHit2Skill <> nil) and
        (targ.RaceServer >= RC_ANIMAL) then begin
        if PWideHit2Skill.Level < 3 then begin
          if Abil.Level >= PWideHit2Skill.pDef.NeedLevel[PWideHit2Skill.Level] then
          begin
            TrainSkill(PWideHit2Skill, 1);
            if not CheckMagicLevelup(PWideHit2Skill) then
              UpdateDelayMsgCheckParam1(self, RM_MAGIC_LVEXP,
                0, PWideHit2Skill.pDef.MagicId, PWideHit2Skill.Level,
                PWideHit2Skill.CurTrain, '', 3000);
          end;
        end;
      end;
      //검술 향상 5 (염화결)
      if (hitmode = HM_FIREHIT) and (PFireHitSkill <> nil) and
        (targ.RaceServer >= RC_ANIMAL) then begin
        if PFireHitSkill.Level < 3 then begin
          if Abil.Level >= PFireHitSkill.pDef.NeedLevel[PFireHitSkill.Level] then
          begin
            TrainSkill(PFireHitSkill, 1);
            if not CheckMagicLevelup(PFireHitSkill) then
              UpdateDelayMsgCheckParam1(self, RM_MAGIC_LVEXP,
                0, PFireHitSkill.pDef.MagicId, PFireHitSkill.Level,
                PFireHitSkill.CurTrain, '', 3000);
          end;
        end;
      end;
      //2003/03/15 신규무공
      //검술 향상 6 (광풍참)
      if (hitmode = HM_CROSSHIT) and (PCrossHitSkill <> nil) and
        (targ.RaceServer >= RC_ANIMAL) then begin
        if PCrossHitSkill.Level < 3 then begin
          if Abil.Level >= PCrossHitSkill.pDef.NeedLevel[PCrossHitSkill.Level] then
          begin
            TrainSkill(PCrossHitSkill, 1);
            if not CheckMagicLevelup(PCrossHitSkill) then
              UpdateDelayMsgCheckParam1(self, RM_MAGIC_LVEXP,
                0, PCrossHitSkill.pDef.MagicId, PCrossHitSkill.Level,
                PCrossHitSkill.CurTrain, '', 3000);
          end;
        end;
      end;
      //검술 향상 7 (쌍룡참)
      if (hitmode = HM_TWINHIT) and (PTwinHitSkill <> nil) and
        (targ.RaceServer >= RC_ANIMAL) then begin
        if PTwinHitSkill.Level < 3 then begin
          if Abil.Level >= PTwinHitSkill.pDef.NeedLevel[PTwinHitSkill.Level] then
          begin
            TrainSkill(PTwinHitSkill, 1);
            if not CheckMagicLevelup(PTwinHitSkill) then
              UpdateDelayMsgCheckParam1(self, RM_MAGIC_LVEXP,
                0, PTwinHitSkill.pDef.MagicId, PTwinHitSkill.Level,
                PTwinHitSkill.CurTrain, '', 3000);
          end;
        end;
      end;
      //검술향상 8 (사자후)
      if (hitmode = HM_STONEHIT) and (PStoneHitSkill <> nil) then begin
        if PStoneHitSkill.Level < 3 then begin
          if Abil.Level >= PStoneHitSkill.pDef.NeedLevel[PStoneHitSkill.Level] then
          begin
            TrainSkill(PStoneHitSkill, 1);
            if not CheckMagicLevelup(PStoneHitSkill) then
              UpdateDelayMsgCheckParam1(self, RM_MAGIC_LVEXP,
                0, PStoneHitSkill.pDef.MagicId, PStoneHitSkill.Level,
                PStoneHitSkill.CurTrain, '', 3000);
          end;
        end;
      end;

      //맞아야 성공
      Result := True;
    end;

    if weapondamage > 0 then begin
      if UseItems[U_WEAPON].Index > 0 then begin //무기를 차고 있으면
        DoDamageWeapon(weapondamage);
      end;
    end;

    //몬스터한테는 직접전달해야 함..
    if targ.RaceServer <> RC_USERHUMAN then
      targ.SendMsg(targ, RM_STRUCK, dam, targ.WAbil.HP, targ.WAbil.MaxHP,
        longint(self), '');
  except
    MainOutMessage('[Exception] TCreature._Attack');
  end;
end;


procedure TCreature.HitHit(target: TCreature; hitmode, dir: word);

  procedure IdentifyWeapon(var ui: TUserItem);
  begin
    if ui.Desc[0] + ui.Desc[1] + ui.Desc[2] < 20 then begin
      case ui.Desc[10] of
        10..13: ui.Desc[0] := ui.Desc[0] + (ui.Desc[10] - 9);
        20..23: ui.Desc[1] := ui.Desc[1] + (ui.Desc[10] - 19);
        30..33: ui.Desc[2] := ui.Desc[2] + (ui.Desc[10] - 29);
        1: ui.Index := 0;  //뽀개짐
      end;
    end else
      ui.Index := 0;
    ui.Desc[10] := 0;
  end;

  procedure CheckWeaponUpgradeResult;
  var
    oldweapon: TUserItem;
    hum: TUserHuman;
  begin
    if UseItems[U_WEAPON].Desc[10] <> 0 then begin
      //아이덴티파이가 안된 무기
      oldweapon := UseItems[U_WEAPON];
      IdentifyWeapon(UseItems[U_WEAPON]);
      if UseItems[U_WEAPON].Index = 0 then begin  //뽀사짐
        SysMsg('Your weapon is crushed to pieces.', 0);
        hum := TUserHuman(self);
        hum.SendDelItem(oldweapon); //클라이언트에 없어진거 보냄
        SendRefMsg(RM_BREAKWEAPON, 0, 0, 0, 0, '');
        //업그레이드 실패로 없어진거 로그 남김
        AddUserLog('21'#9 + //업실_ +
          MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
          ''#9 + UserName + ''#9 + UserEngine.GetStdItemName(oldweapon.Index) +
          ''#9 + IntToStr(oldweapon.MakeIndex) + ''#9 + '1'#9 +
          ItemOptionToStr(oldweapon.Desc)
          );
        FeatureChanged;
      end else begin  //업그레이드 성공
        SysMsg('Your weapon is enhanced.', 1);
        hum := TUserHuman(self);
        hum.SendUpdateItem(UseItems[U_WEAPON]);
        //업그레이드 성공 로그 남김
        AddUserLog('20'#9 + //업성_ +
          MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
          ''#9 + UserName + ''#9 + UserEngine.GetStdItemName(UseItems[U_WEAPON].Index) +
          ''#9 + IntToStr(UseItems[U_WEAPON].MakeIndex) + ''#9 +
          '1'#9 + ItemOptionToStr(UseItems[U_WEAPON].Desc)
          );
        RecalcAbilitys;
        SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
        SendMsg(self, RM_SUBABILITY, 0, 0, 0, 0, '');
      end;
    end;
  end;

  function GetSWSpell(pum: PTUserMagic): integer;
  begin
    Result := Round(pum.pDef.Spell / (pum.pDef.MaxTrainLevel + 1) * (pum.Level + 1));
  end;

var
  newdir, soundeff, msg: integer;
  targ: TCreature;
  bopower, bopower2, bofire: boolean;
begin
  if hitmode = HM_WIDEHIT then begin
    if PWideHitSkill <> nil then begin
      if WAbil.MP > 0 then begin
        DamageSpell(GetSWSpell(PWideHitSkill) + PWideHitSkill.pDef.DefSpell);
        HealthSpellChanged;
      end else
        hitmode := RM_HIT;  //마력없음...
    end;
  end;
  // Assassin Magic 2
  if hitmode = HM_WIDEHIT2 then begin
    if PWideHit2Skill <> nil then begin
      if WAbil.MP > 0 then begin
        DamageSpell(GetSWSpell(PWideHit2Skill) + PWideHit2Skill.pDef.DefSpell);
        HealthSpellChanged;
      end else
        hitmode := RM_HIT;  //마력없음...
    end;
  end;
  // 2003/03/15 신규무공
  if hitmode = HM_CROSSHIT then begin
    if PCrossHitSkill <> nil then begin
      if WAbil.MP > 0 then begin
        DamageSpell(GetSWSpell(PCrossHitSkill) + PCrossHitSkill.pDef.DefSpell);
        HealthSpellChanged;
      end else
        hitmode := RM_HIT;  //마력없음...
    end;
  end;
  if hitmode = HM_TWINHIT then begin
    if PTwinHitSkill <> nil then begin
      if WAbil.MP > 0 then begin
        DamageSpell(GetSWSpell(PTwinHitSkill) + PTwinHitSkill.pDef.DefSpell);
        HealthSpellChanged;
      end else
        hitmode := RM_HIT;  //마력없음...
    end;
  end;


  //방향으로 친다.
  self.Dir := dir;
  if target = nil then
    targ := GetFrontCret
  else
    targ := target;

  if targ <> nil then begin
    if UseItems[U_WEAPON].Index <> 0 then begin
      //제련이 끝난 무기의 테스트(성공여부)
      CheckWeaponUpgradeResult;
    end;
  end;

  bopower := BoAllowPowerHit;
  bopower2 := BoAllowslashhit;
  bofire  := BoAllowFireHit;    //_attack 에서 해제 됨

  if _Attack(hitmode, targ) then
    SelectTarget(targ);

  msg := RM_HIT;
  if RaceServer = RC_USERHUMAN then begin
    msg := RM_HIT;
    case hitmode of
      HM_HIT: msg      := RM_HIT;
      HM_HEAVYHIT: msg := RM_HEAVYHIT;
      HM_BIGHIT: msg   := RM_BIGHIT;
      HM_POWERHIT: if bopower then begin
          msg := RM_POWERHIT;
        end;
      HM_slashhit: if bopower2 then begin
          msg := RM_slashhit;
        end;
      HM_LONGHIT: if PLongHitSkill <> nil then begin
          msg := RM_LONGHIT;
        end;
      HM_WIDEHIT: if PWideHitSkill <> nil then begin
          msg := RM_WIDEHIT;
        end;
      HM_WIDEHIT2: if PWideHit2Skill <> nil then begin
          msg := RM_WIDEHIT2;
        end;
      HM_FIREHIT: if bofire then begin
          msg := RM_FIREHIT;
        end;
      // 2003/03/15 신규무공
      HM_CROSSHIT: if PCrossHitSkill <> nil then begin
          msg := RM_CROSSHIT;
        end;
      HM_TWINHIT: if PTwinHitSkill <> nil then begin
          msg := RM_TWINHIT;
        end;

    end;
  end;
  //SendRefMsg (msg, self.Dir, CX, CY, 0, '');
  HitMotion(msg, self.Dir, CX, CY);
end;

procedure TCreature.HitMotion(hitmsg: integer; hitdir: byte; x, y: integer);
begin
  SendRefMsg(hitmsg, hitdir, x, y, 0, '');
end;

procedure TCreature.HitHit2(target: TCreature; hitpwr, magpwr: integer; all: boolean);
begin
  HitHitEx2(target, RM_HIT, hitpwr, magpwr, all);
end;

procedure TCreature.HitHitEx2(target: TCreature; rmmsg, hitpwr, magpwr: integer;
  all: boolean);
var
  i, dam: integer;
  list:   TList;
  cret:   TCreature;
begin
  self.Dir := GetNextDirection(CX, CY, target.CX, target.CY);
  list     := TList.Create;
  PEnvir.GetAllCreature(target.CX, target.CY, True, list);
  for i := 0 to list.Count - 1 do begin
    cret := TCreature(list[i]);
    if IsProperTarget(cret) then begin
      dam := 0;
      dam := dam + cret.GetHitStruckDamage(self, hitpwr);
      dam := dam + cret.GetMagStruckDamage(self, magpwr);
      if dam > 0 then begin
        cret.StruckDamage(dam, self);
        cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
          cret.WAbil.HP{lparam1}, cret.WAbil.MaxHP{lparam2},
          longint(self){hiter}, '', 200);
      end;
    end;
  end;
  list.Free;
  SendRefMsg(rmmsg, self.Dir, CX, CY, 0, '');
end;

//Result: 실제로 밀린 칸
function TCreature.CharPushed(ndir, pushcount: integer): integer;
  //어떤 힘에 의해서 밀려나다.
var
  i, nx, ny, olddir, oldx, oldy, pwr, dam: integer;
  flag: boolean;
begin
  Result := 0;
  olddir := Dir;
  oldx   := CX;
  oldy   := CY;
  Dir    := ndir;
  flag   := False;

  for i := 0 to pushcount - 1 do begin
    GetFrontPosition(self, nx, ny);
    if PEnvir.CanWalk(nx, ny, False{겸침허용안함}) then begin
      if PEnvir.MoveToMovingObject(CX, CY, self, nx, ny, False) > 0 then begin
        CX := nx;
        CY := ny;
        SendRefMsg(RM_PUSH, GetBack(ndir), CX, CY, 0, '');
        Inc(Result);
        if RaceServer = (RC_ELEMENTOFTHUNDER) or (RC_ELEMENTOFPOISON) then begin
        if Random(2) = 0 then begin
          self.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            self.WAbil.HP{lparam1},
            self.WAbil.MaxHP{lparam2}, longint(self.lasthiter){hiter}, '', 800);
        WAbil.HP := 0;
        end else begin
          self.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            self.WAbil.HP{lparam1},
            self.WAbil.MaxHP{lparam2}, longint(self.lasthiter){hiter}, '', 800);
        end;
        end;
        if RaceServer >= RC_ANIMAL then
          WalkTime := WalkTime + 800; //밀리면서 늦게 때린다.
        flag := True;
      end else
        break;
    end else
      break;
  end;

  if flag then
    Dir := GetBack(ndir); //olddir;
end;

function TCreature.CharRushRush(ndir, rushlevel: integer;
  isHumanSkill: boolean): boolean;  //무태보

  function CanPush(cret: TCreature): boolean;
  var
    levelgap: integer;
  begin
    Result := False;
    if (Abil.Level > cret.Abil.Level) and (not cret.StickMode) then begin
      levelgap := Abil.Level - cret.Abil.Level;
      if (Random(20) < 6 + rushlevel * 3 + levelgap) then begin  //수련정도에 따라서
        if IsProperTarget(cret) then begin
          Result := True;
        end;
      end;
    end;
  end;

var
  i, nx, ny, damage, damagelevel, mydamagelevel: integer;
  cret, cret2, attackcret: TCreature;
  crash: boolean;
begin
  Result := False;
  crash  := True;
  Dir    := ndir;
  attackcret := nil;
  damagelevel := rushlevel + 1;
  mydamagelevel := damagelevel;
  cret   := GetFrontCret;

  if cret <> nil then begin
    for i := 0 to _MAX(2, rushlevel + 1) do begin
      cret := GetFrontCret;
      if cret <> nil then begin
        mydamagelevel := 0;
        if CanPush(cret) then begin
          if rushlevel >= 3 then
            if GetNextPosition(PEnvir, CX, CY, Dir, 2, nx, ny) then begin
              cret2 := TCreature(PEnvir.GetCreature(nx, ny, True));
              if cret2 <> nil then begin
                if CanPush(cret2) then begin
                  cret2.CharPushed(Dir, 1);
                end;
              end;
            end;
          attackcret := cret;
          if cret.CharPushed(Dir, 1) = 1 then begin
            GetFrontPosition(self, nx, ny);
            if PEnvir.MoveToMovingObject(CX, CY, self, nx, ny, False) > 0 then
            begin
              CX := nx;
              CY := ny;
              SendRefMsg(RM_RUSH, ndir, CX, CY, 0, '');
              crash  := False;
              Result := True;
            end;
            Dec(damagelevel);
          end else begin
            break;
          end;
        end else
          break;
      end;
    end;
  end else begin
    crash := False;
    for i := 0 to _MAX(2, rushlevel + 1) do begin
      GetFrontPosition(self, nx, ny);
      if PEnvir.MoveToMovingObject(CX, CY, self, nx, ny, False) > 0 then begin
        CX := nx;
        CY := ny;
        SendRefMsg(RM_RUSH, ndir, CX, CY, 0, '');
        Dec(mydamagelevel);
      end else begin  //벽에 부딯힌 경우
        if PEnvir.CanWalk(nx, ny, True) then
          mydamagelevel := 0  //사람때문에 못감
        else
          crash := True; //벽에 부딯힘
        break;
      end;
    end;
  end;

  if (attackcret <> nil) and isHumanSkill then begin
    if damagelevel < 0 then
      damagelevel := 0;
    damage := (1 + damagelevel) * 4 + Random((1 + damagelevel) * 5);
    with attackcret do begin
      damage := GetHitStruckDamage(self, damage);
      StruckDamage(damage);
      SendRefMsg(RM_STRUCK, damage{wparam}, WAbil.HP{lparam1},
        WAbil.MaxHP{lparam2}, longint(self){hiter}, '');
      //몬스터한테는 직접전달해야 함..
      if RaceServer <> RC_USERHUMAN then
        SendMsg(attackcret, RM_STRUCK, damage, WAbil.HP,
          WAbil.MaxHP, longint(self), '');
    end;
  end;

  if crash then begin
    //움직이는 시늉한다.
    GetFrontPosition(self, nx, ny);
    SendRefMsg(RM_RUSHKUNG, Dir, nx, ny, 0, '');
    //SendRefMsg (RM_TURN, Dir, CX, CY, 0, '');
    if isHumanSkill then
      SysMsg('Lack of pushing power.', 0);
  end;

  if (mydamagelevel > 0) and (isHumanSkill) then begin
    if damagelevel < 0 then
      damagelevel := 0;
    damage := (1 + damagelevel) * 5 + Random((1 + damagelevel) * 5);
    damage := GetHitStruckDamage(self, damage);
    StruckDamage(damage);
    if (crash) and (LastHiter <> nil) then
      LastHiter := nil;
    SendRefMsg(RM_STRUCK, damage{wparam}, WAbil.HP{lparam1},
      WAbil.MaxHP{lparam2}, 0{hiter}, '');
  end;
end;

function TCreature.CharDrawingRush(ndir, rushlevel: integer;
  isHumanSkill: boolean): boolean;  //끌어당김

  function CanPush(cret: TCreature): boolean;
  var
    levelgap: integer;
  begin
    Result := False;
    if (Abil.Level > cret.Abil.Level) and (not cret.StickMode) then begin
      levelgap := Abil.Level - cret.Abil.Level;
      if (Random(20) < 6 + rushlevel * 3 + levelgap) then begin  //수련정도에 따라서
        if IsProperTarget(cret) then begin
          Result := True;
        end;
      end;
    end;
  end;

var
  i, nx, ny, damage, damagelevel, mydamagelevel: integer;
  cret, cret2, attackcret: TCreature;
  crash: boolean;
begin
  Result := False;
  crash  := True;
  Dir    := ndir;
  attackcret := nil;
  damagelevel := rushlevel + 1;
  mydamagelevel := damagelevel;
  cret   := GetFrontCret;

  if cret <> nil then begin
    for i := 0 to _MAX(2, rushlevel + 1) do begin
      cret := GetFrontCret;
      if cret <> nil then begin
        mydamagelevel := 0;
        if CanPush(cret) then begin
          if rushlevel >= 3 then
            if GetNextPosition(PEnvir, CX, CY, Dir, 2, nx, ny) then begin
              cret2 := TCreature(PEnvir.GetCreature(nx, ny, True));
              if cret2 <> nil then begin
                if CanPush(cret2) then begin
                  cret2.CharPushed(Dir, 1);
                end;
              end;
            end;
          attackcret := cret;
          if cret.CharPushed(Dir, 1) = 1 then begin
            GetFrontPosition(self, nx, ny);
            if PEnvir.MoveToMovingObject(CX, CY, self, nx, ny, False) > 0 then
            begin
              CX := nx;
              CY := ny;
              SendRefMsg(RM_RUSH, ndir, CX, CY, 0, '');
              crash  := False;
              Result := True;
            end;
            Dec(damagelevel);
          end else begin
            break;
          end;
        end else
          break;
      end;
    end;
  end else begin
    crash := False;
    for i := 0 to _MAX(2, rushlevel + 1) do begin
      GetFrontPosition(self, nx, ny);
      if PEnvir.MoveToMovingObject(CX, CY, self, nx, ny, False) > 0 then begin
        CX := nx;
        CY := ny;
        SendRefMsg(RM_RUSH, ndir, CX, CY, 0, '');
        Dec(mydamagelevel);
      end else begin  //벽에 부딯힌 경우
        if PEnvir.CanWalk(nx, ny, True) then
          mydamagelevel := 0  //사람때문에 못감
        else
          crash := True; //벽에 부딯힘
        break;
      end;
    end;
  end;

  if (attackcret <> nil) and isHumanSkill then begin
    if damagelevel < 0 then
      damagelevel := 0;
    damage := (1 + damagelevel) * 4 + Random((1 + damagelevel) * 5);
    with attackcret do begin
      damage := GetHitStruckDamage(self, damage);
      StruckDamage(damage);
      SendRefMsg(RM_STRUCK, damage{wparam}, WAbil.HP{lparam1},
        WAbil.MaxHP{lparam2}, longint(self){hiter}, '');
      //몬스터한테는 직접전달해야 함..
      if RaceServer <> RC_USERHUMAN then
        SendMsg(attackcret, RM_STRUCK, damage, WAbil.HP,
          WAbil.MaxHP, longint(self), '');
    end;
  end;

  if crash then begin
    //움직이는 시늉한다.
    GetFrontPosition(self, nx, ny);
    SendRefMsg(RM_RUSHKUNG, Dir, nx, ny, 0, '');
    //SendRefMsg (RM_TURN, Dir, CX, CY, 0, '');
    if isHumanSkill then
      SysMsg('Lack of pushing power.', 0);
  end;

  if (mydamagelevel > 0) and (isHumanSkill) then begin
    if damagelevel < 0 then
      damagelevel := 0;
    damage := (1 + damagelevel) * 5 + Random((1 + damagelevel) * 5);
    damage := GetHitStruckDamage(self, damage);
    StruckDamage(damage);
    if (crash) and (LastHiter <> nil) then
      LastHiter := nil;
    SendRefMsg(RM_STRUCK, damage{wparam}, WAbil.HP{lparam1},
      WAbil.MaxHP{lparam2}, 0{hiter}, '');
  end;
end;

function TCreature.SiegeCount: integer;
var
  i:    integer;
  cret: TCreature;
begin
  Result := 0;
  for i := 0 to VisibleActors.Count - 1 do begin
    cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
    if not cret.Death then begin
      if (abs(CX - cret.CX) <= 1) and (abs(CY - cret.CY) <= 1) then
        Inc(Result);
    end;
  end;
end;

function TCreature.SiegeLockCount: integer;
var
  i, j, n: integer;
begin
  n := 0;
  for i := -1 to 1 do
    for j := -1 to 1 do begin
      if (not PEnvir.CanWalk(CX + i, CY + j, False)) and (not ((i = 0) and (j = 0))) then
        Inc(n);
    end;
  Result := n;
end;


//독으로 공격함.

function TCreature.MakePoison(poison, sec, poisonlv: integer): boolean;
var
  old: integer;
begin
  Result := False;
  //독에 중독되지 않을 조건이 있는가 검사..

  sec := sec - PoisonRecover;
  if sec <= 0 then
    Exit;

  if poison in [0..STATUSARR_SIZE - 1] then begin

    old := CharStatus;
    if StatusArr[poison] > 0 then begin
      if sec > StatusArr[poison] then
        StatusArr[poison] := sec;
    end else
      StatusArr[poison] := sec;
    StatusTimes[poison] := GetTickCount;
    CharStatus := GetCharStatus;
    if poison = POISON_DAMAGEARMOR then
      RedPoisonLevel := _MIN(poisonlv, 256);
    PoisonLevel := _MIN(poisonlv, 256);
    if old <> CharStatus then
      CharStatusChanged;
    if RaceServer = RC_USERHUMAN then
      SysMsg('You are poisoned.', 0);
    Result := True;
  end;
end;

procedure TCreature.ClearPoison(poison: integer);
var
  old: integer;
begin
  if poison in [0..STATUSARR_SIZE - 1] then begin
    old := CharStatus;
    if StatusArr[poison] > 0 then
      StatusArr[poison] := 0;
    CharStatus := GetCharStatus;
    if old <> CharStatus then
      CharStatusChanged;
  end;
end;


function TCreature.GetFrontCret: TCreature;
var
  fx, fy: integer;
begin
  Result := nil;
  if GetFrontPosition(self, fx, fy) then begin
    Result := TCreature(PEnvir.GetCreature(fx, fy, True));
  end;
end;

function TCreature.GetBackCret: TCreature;
var
  fx, fy: integer;
begin
  Result := nil;
  if GetBackPosition(self, fx, fy) then begin
    Result := TCreature(PEnvir.GetCreature(fx, fy, True));
  end;
end;

function TCreature.CretInNearXY(tagcret: TCreature; xx, yy: integer): boolean;
var
  i, j, k: longint;
  pm:      PTMapInfo;
  inrange: boolean;
  cret:    TCreature;
begin
  Result := False;
  for i := xx - 1 to xx + 1 do
    for j := yy - 1 to yy + 1 do begin
      inrange := PEnvir.GetMapXY(i, j, pm);
      if inrange then begin
        if pm.ObjList <> nil then
          for k := 0 to pm.ObjList.Count - 1 do
            {creature}
            if PTAThing(pm.ObjList[k]).Shape = OS_MOVINGOBJECT then begin
              cret := TCreature(PTAThing(pm.ObjList[k]).AObject);
              if cret <> nil then
                if (not cret.BoGhost) and (cret = tagcret) then begin
                  Result := True;
                  exit;
                end;
            end;
      end;
    end;
end;

function TCreature.MakeSlave(sname: string;
  slevel, max_slave, royaltysec: integer): TCreature;
var
  nx, ny:  integer;
  mon:     TCreature;
  AddPlus: integer;
begin
  Result := nil;

  try
    AddPlus := 0;
    if (GetExistSlave(__AngelMob) <> nil) or (sname = __AngelMob) then
      Addplus := 1
    else
      AddPlus := 0;

    if (SlaveList.Count < (max_slave + AddPlus)) then begin
      GetFrontPosition(self, nx, ny);
      mon := UserEngine.AddCreatureSysop(PEnvir.MapName, nx, ny, sname);
      if mon <> nil then begin
        mon.Master := self;
        mon.MasterRoyaltyTime := GetTickCount + longword(royaltysec) * 1000;
        mon.SlaveMakeLevel := slevel;
        mon.SlaveExpLevel := slevel;
        mon.MasterFeature := GetRelFeature(self); // 분신
        mon.RecalcAbilitys; //ApplySlaveLevelAbilitys;
        if mon.WAbil.HP < mon.WAbil.MaxHP then begin
          mon.WAbil.HP := mon.WAbil.HP + (mon.WAbil.MaxHP - mon.WAbil.HP) div 2;
        end;
        mon.ChangeNameColor;
        SlaveList.Add(mon);
        Result := mon;
      end;
    end;

  except
    MainOutMessage('EXCEPT MAKESLAVE');
  end;

end;

// 2003/06/12 슬레이브 패치
procedure TCreature.ClearAllSlaves;
var
  i: integer;
begin
  for i := 0 to SlaveList.Count - 1 do begin
    if not TCreature(SlaveList[i]).Death then begin
      TCreature(SlaveList[i]).BoDisapear := True;
      TCreature(SlaveList[i]).MakeGhost(4);
      //부하들을 완전히 없앤다. 주로 서버이동하는 경우 사용
    end;
  end;
end;

procedure TCreature.KillAllSlaves;
var
  i: integer;
begin
  for i := 0 to SlaveList.Count - 1 do begin
    if not TCreature(SlaveList[i]).Death then begin
      TCreature(SlaveList[i]).WAbil.HP := 0; //Die
    end;
  end;
end;

function TCreature.ExistAttackSlaves: boolean;
var
  i:    integer;
  cret: TCreature;
begin
  //공격 타겟이 있는 소환수가 있으면 TRUE 없으면 FALSE...
  Result := False;
  for i := 0 to SlaveList.Count - 1 do begin
    cret := TCreature(SlaveList[i]);
    if not cret.Death then begin
      if cret.TargetCret <> nil then begin
        if cret.TargetCret.RaceServer = RC_USERHUMAN then begin
          Result := True;
          break;
        end;
      end;
    end;
  end;
end;

// 꼬봉존재유무 판단.

function TCreature.GetExistSlave(MonName_: string): TCreature;
var
  TempCret: TCreature;
  i: integer;
begin
  Result := nil;
  try
    for i := 0 to SlaveList.Count - 1 do begin
      TempCret := TCreature(SlaveList[i]);
      if (TempCret <> nil) and (not TempCret.Death) and
        (not TempCret.BoDisapear) and (not TempCret.boGhost) and
        (comparetext(TempCret.UserName, MonName_) = 0) then begin
        Result := TempCret;
        Exit;
      end;
    end;
  except
    MainOutMessage('EXCEPTION GETExistSlave');
  end;
end;

function TCreature.EnableRecallMob(TargetMob: TCreature; SkillLevel: integer): boolean;
var
  i: integer;
  KingSlaveCount: integer;
  AddPlus: integer;
begin
  Result  := False;
  KingSlaveCount := 0;
  AddPlus := 0;
  if (not TargetMob.NoMaster) and (TargetMob.LifeAttrib = LA_CREATURE) and
    (TargetMob.RaceServer <> RC_CLONE) and (TargetMob.RaceServer <> RC_ANGEL) and
    (TargetMob.Abil.Level < MAXKINGLEVEL - 1) then begin

    // 유저 52레벨 문제 수정(sonmg 2004/09/08)
    // 몹의 레벨이 50이상인 몹은 한 마리만 꼬실 수 있다.(두 마리 이상은 확률적용)
    if TargetMob.Abil.Level >= 50 then begin
      for i := 0 to SlaveList.Count - 1 do begin
        if TCreature(SlaveList[i]).Abil.Level >= 50 then begin
          Inc(KingSlaveCount);
        end;
      end;
      //현재 소환몹 중에 레벨이 50이상인 몹의 수마다 1/3씩 확률 감소.
      if Random(3 * KingSlaveCount) > 0 then begin
        Result := False;
        exit;
      end;
    end;

    // 환영한호는 1마리만 소환된다.
    if Targetmob.RaceServer = RC_GHOST_TIGER then begin
      if SlaveList.Count > 0 then begin
        Result := False;
        Exit;
      end;
    end else begin
      // 환영한호는 다른넘이 꼬셔져 있으면... 꼬실수 없다.
      if SlaveList.Count = 1 then begin
        if TCreature(SlaveList[0]).RaceServer = RC_GHOST_TIGER then begin
          Result := False;
          Exit;
        end;
      end;
      // 일반적으로 꼬실수 있는 몬스터 수 체크
      if SlaveList.Count >= (2 + skilllevel + AddPlus) then begin
        Result := False;
        Exit;
      end;
    end;

    Result := True;
  end;

end;


{------------------------- 그룹 관련 -----------------------------}


function TCreature.IsGroupMember(cret: TCreature): boolean;
var
  i: integer;
begin
  Result := False;
  if GroupOwner <> nil then begin
    for i := 0 to GroupOwner.GroupMembers.Count - 1 do begin
      if GroupOwner.GroupMembers.Objects[i] = cret then begin
        Result := True;
        break;
      end;
    end;
  end;
end;

function TCreature.CheckGroupValid: boolean;
begin
  Result := True;
  if GroupMembers.Count <= 1 then begin
    //마지막에 남은 것은 그룹짱이다.
    GroupMsg('Your group is disorganized.');
    GroupMembers.Clear;
    GroupOwner := nil;
    Result     := False;
  end;
end;

procedure TCreature.DelGroupMember(who: TCreature);
var
  i:    integer;
  cret: TCreature;
  hum:  TUserHuman;
begin
  if GroupOwner <> who then begin
    for i := 0 to GroupMembers.Count - 1 do begin
      cret := TCreature(GroupMembers.Objects[i]);
      if cret = who then begin
        who.LeaveGroup;
        GroupMembers.Delete(i);
        break;
      end;
    end;

    if Self.RaceServer = RC_USERHUMAN then begin
      hum := TUserHuman(self);
      if not CheckGroupValid then begin
        //            hum.SendDefMessage (SM_GROUPCANCEL, 0, 0, 0, 0, '');
        hum.SendMsg(self, RM_GROUPCANCEL, 0, 0, 0, 0, '');
      end;

      hum.RefreshGroupMembers;
    end;

  end else begin
    //짱이 탈퇴, 그룹 해체됨
    for i := GroupMembers.Count - 1 downto 0 do begin
      hum := TUserHuman(GroupMembers.Objects[i]);
      if (hum <> nil) and (hum.RaceServer = RC_USERHUMAN) then begin
        //            hum.SendDefMessage (SM_GROUPCANCEL, 0, 0, 0, 0, '');  //버그 패치(sonmg)
        hum.SendMsg(self, RM_GROUPCANCEL, 0, 0, 0, 0, '');
        hum.LeaveGroup;
        GroupMembers.Delete(i);
      end;
    end;

    //그룹짱이 죽은 후에 로그아웃 할 때 그룹 해체 안되는 버그 수정
    if Self.RaceServer = RC_USERHUMAN then begin
      hum := TUserHuman(self);

      //마지막에 남은 것은 그룹짱이다.
      GroupMsg('Your group is disorganized.');
      GroupMembers.Clear;
      GroupOwner := nil;

      //         hum.SendDefMessage (SM_GROUPCANCEL, 0, 0, 0, 0, '');
      hum.SendMsg(self, RM_GROUPCANCEL, 0, 0, 0, 0, '');
      hum.RefreshGroupMembers;
    end;

  end;
end;

procedure TCreature.EnterGroup(gowner: TCreature);
begin
  GroupOwner := gowner;
  GroupMsg(UserName + ' joined group.');
end;

procedure TCreature.LeaveGroup;
begin
  GroupMsg(UserName + ' is out from group.');
  SendMsg(self, RM_GROUPCANCEL, 0, 0, 0, 0, '');
  GroupOwner := nil;

end;

procedure TCreature.DenyGroup;
begin
  if GroupOwner <> nil then begin
    if GroupOwner <> self then begin
      //탈퇴
      GroupOwner.DelGroupMember(self);
      AllowGroup := False;
    end else begin
      //안됨
      SysMsg('If you want to withdraw from group, use function of (del member)', 0);
    end;
  end else begin
    AllowGroup := False;
  end;
end;


{----------------------------------------------------------------}



function TCreature.TargetInAttackRange(target: TCreature; var targdir: byte): boolean;
begin
  Result := False;
  if (target.CX >= (self.CX - 1)) and (target.CX <= (self.CX + 1)) and
    (target.CY >= (self.CY - 1)) and (target.CY <= (self.CY + 1)) and
    not ((target.CX = self.CX) and (target.CY = self.CY)) then begin
    Result := True;
    while True do begin
      if (target.CX = (self.CX - 1)) and (target.CY = self.CY) then begin
        targdir := DR_LEFT;
        break;
      end;
      if (target.CX = (self.CX + 1)) and (target.CY = self.CY) then begin
        targdir := DR_RIGHT;
        break;
      end;
      if (target.CX = self.CX) and (target.CY = (self.CY - 1)) then begin
        targdir := DR_UP;
        break;
      end;
      if (target.CX = self.CX) and (target.CY = (self.CY + 1)) then begin
        targdir := DR_DOWN;
        break;
      end;
      if (target.CX = self.CX - 1) and (target.CY = self.CY - 1) then begin
        targdir := DR_UPLEFT;
        break;
      end;
      if (target.CX = self.CX + 1) and (target.CY = self.CY - 1) then begin
        targdir := DR_UPRIGHT;
        break;
      end;
      if (target.CX = self.CX - 1) and (target.CY = self.CY + 1) then begin
        targdir := DR_DOWNLEFT;
        break;
      end;
      if (target.CX = self.CX + 1) and (target.CY = self.CY + 1) then begin
        targdir := DR_DOWNRIGHT;
        break;
      end;
      targdir := 0; {예외, }
      break;
    end;
  end;
end;

function TCreature.TargetInSpitRange(target: TCreature; var targdir: byte): boolean;
var
  nx, ny: integer;
begin
  Result := False;
  if (abs(target.CX - CX) <= 2) and (abs(target.CY - CY) <= 2) then begin
    nx := target.CX - CX;
    ny := target.CY - CY;
    if (abs(nx) <= 1) and (abs(ny) <= 1) then begin
      TargetInAttackRange(target, targdir);
      Result := True;
    end else begin
      nx := nx + 2;
      ny := ny + 2;
      if (nx in [0..4]) and (ny in [0..4]) then begin
        targdir := GetNextDirection(CX, CY, target.CX, target.CY);
        if SpitMap[targdir, ny, nx] = 1 then begin
          Result := True;
        end;
      end;
    end;
  end;
end;

function TCreature.TargetInCrossRange(target: TCreature; var targdir: byte): boolean;
var
  nx, ny: integer;
begin
  Result := False;
  if (abs(target.CX - CX) <= 2) and (abs(target.CY - CY) <= 2) then begin
    nx := target.CX - CX;
    ny := target.CY - CY;
    if (abs(nx) <= 1) and (abs(ny) <= 1) then begin
      TargetInAttackRange(target, targdir);
      Result := True;
    end else begin
      nx := nx + 2;
      ny := ny + 2;
      if (nx in [0..4]) and (ny in [0..4]) then begin
        targdir := GetNextDirection(CX, CY, target.CX, target.CY);
        if CrossMap[targdir, ny, nx] = 1 then begin
          Result := True;
        end;
      end;
    end;
  end;
end;


function TCreature.WalkTo(dir: integer; allowdup: boolean): boolean;
var
  prx, pry, nwx, nwy, masx, masy: integer;
  hum:  TUserHuman;
  oldpenvir: TEnvirnoment;
  flag: boolean;
  down: integer;
begin
  Result := False;
  down   := 0;
  if BoHolySeize then begin  //이동 못함..
    exit;
  end;

  try
    down     := 1;
    prx      := CX;
    pry      := CY;
    oldpenvir := PEnvir;
    self.Dir := dir;
    nwx      := 0;
    nwy      := 0;
    case dir of
      DR_UP: begin
        nwx := CX;
        nwy := CY - 1;
      end;
      DR_DOWN: begin
        nwx := CX;
        nwy := CY + 1;
      end;
      DR_LEFT: begin
        nwx := CX - 1;
        nwy := CY;
      end;
      DR_RIGHT: begin
        nwx := CX + 1;
        nwy := CY;
      end;
      DR_UPLEFT: begin
        nwx := CX - 1;
        nwy := CY - 1;
      end;
      DR_UPRIGHT: begin
        nwx := CX + 1;
        nwy := CY - 1;
      end;
      DR_DOWNLEFT: begin
        nwx := CX - 1;
        nwy := CY + 1;
      end;
      DR_DOWNRIGHT: begin
        nwx := CX + 1;
        nwy := CY + 1;
      end;
    end;

    down := 2;
    if (nwx >= 0) and (nwx <= PEnvir.MapWidth - 1) and (nwy >= 0) and
      (nwy <= PEnvir.MapHeight - 1) then begin

      down := 3;
      flag := True;
      if BoFearFire then begin //불을 무서워함
        down := 4;
        if not PEnvir.CanSafeWalk(nwx, nwy) then
          flag := False;
      end;
      if Master <> nil then begin  //주인이 있는 몹, 주인의 앞을 가로 막지 않는다.
        down := 5;
        GetNextPosition(Master.PEnvir, Master.CX, Master.CY,
          Master.Dir, 1, masx, masy);
        if (nwx = masx) and (nwy = masy) then
          flag := False;
      end;
      if flag then begin
        down := 6;
        if PEnvir.MoveToMovingObject(CX, CY, self, nwx, nwy, allowdup) > 0 then
        begin
          CX := nwx;
          CY := nwy;
        end;
      end;
    end;

    if (prx <> CX) or (pry <> CY) then begin
      if Walk(RM_WALK) then begin
        down := 7;
        //은신술 해제
        if BoFixedHideMode then begin //고정 은신술..
          if BoHumHideMode then begin  //이동한경우에는 은신술이 풀린다.
            StatusArr[STATE_TRANSPARENT] := 1;
          end;
        end;

        Result := True;
      end else begin

        down := 8;
        if (1 = PEnvir.DeleteFromMap(CX, CY, OS_MOVINGOBJECT, self)) then begin
          PEnvir := oldpenvir;
          CX     := prx;
          CY     := pry;
          if (nil = PEnvir.AddToMap(CX, CY, OS_MOVINGOBJECT, self)) then begin
            MainOutMessage('NOT ADDTOMAP WorkTo:' + PEnvir.MapName +
              ',' + IntToStr(CX) + ',' + IntToStr(CY));
          end;
        end;

      end;
    end;
  except
    MainOutMessage('[Exception] TCreatre.WalkTo:' + Self.UserName +
      ',' + IntToStr(down) + ':' + IntToStr(CX) + ',' + IntToStr(CY) +
      ',' + IntToStr(dir));
  end;
end;

function TCreature.RunTo(dir: integer; allowdup: boolean): boolean;
var
  prx, pry: integer;
begin
  Result := False;
  try
    prx      := CX;
    pry      := CY;
    self.Dir := dir;
    case dir of
      DR_UP: begin
        if CY > 1 then
          if PEnvir.CanWalk(CX, CY - 1, allowdup) and
            (PEnvir.CanWalk(CX, CY - 2, allowdup)) then
            if PEnvir.MoveToMovingObject(CX, CY, self, CX, CY - 2, True) > 0 then
            begin
              CY := CY - 2;
            end;
      end;
      DR_DOWN: begin
        if CY < PEnvir.MapHeight - 2 then
          if PEnvir.CanWalk(CX, CY + 1, allowdup) and
            (PEnvir.CanWalk(CX, CY + 2, allowdup)) then
            if PEnvir.MoveToMovingObject(CX, CY, self, CX, CY + 2, True) > 0 then
            begin
              CY := CY + 2;
            end;
      end;
      DR_LEFT: begin
        if CX > 1 then
          if PEnvir.CanWalk(CX - 1, CY, allowdup) and
            (PEnvir.CanWalk(CX - 2, CY, allowdup)) then
            if PEnvir.MoveToMovingObject(CX, CY, self, CX - 2, CY, True) > 0 then
            begin
              CX := CX - 2;
            end;
      end;
      DR_RIGHT: begin
        if CX < PEnvir.MapWidth - 2 then
          if PEnvir.CanWalk(CX + 1, CY, allowdup) and
            (PEnvir.CanWalk(CX + 2, CY, allowdup)) then
            if PEnvir.MoveToMovingObject(CX, CY, self, CX + 2, CY, True) > 0 then
            begin
              CX := CX + 2;
            end;
      end;
      DR_UPLEFT: begin
        if (CX > 1) and (CY > 1) then
          if PEnvir.CanWalk(CX - 1, CY - 1, allowdup) and
            (PEnvir.CanWalk(CX - 2, CY - 2, allowdup)) then
            if PEnvir.MoveToMovingObject(CX, CY, self, CX - 2, CY - 2, True) >
              0 then begin
              CX := CX - 2;
              CY := CY - 2;
            end;
      end;
      DR_UPRIGHT: begin
        if (CX < PEnvir.MapWidth - 2) and (CY > 1) then
          if PEnvir.CanWalk(CX + 1, CY - 1, allowdup) and
            (PEnvir.CanWalk(CX + 2, CY - 2, allowdup)) then
            if PEnvir.MoveToMovingObject(CX, CY, self, CX + 2, CY - 2, True) >
              0 then begin
              CX := CX + 2;
              CY := CY - 2;
            end;
      end;
      DR_DOWNLEFT: begin
        if (CX > 1) and (CY < PEnvir.MapHeight - 2) then
          if PEnvir.CanWalk(CX - 1, CY + 1, allowdup) and
            (PEnvir.CanWalk(CX - 2, CY + 2, allowdup)) then
            if PEnvir.MoveToMovingObject(CX, CY, self, CX - 2, CY + 2, True) >
              0 then begin
              CX := CX - 2;
              CY := CY + 2;
            end;
      end;
      DR_DOWNRIGHT: begin
        if (CX < PEnvir.MapWidth - 2) and (CY < PEnvir.MapHeight - 2) then
          if PEnvir.CanWalk(CX + 1, CY + 1, allowdup) and
            (PEnvir.CanWalk(CX + 2, CY + 2, allowdup)) then
            if PEnvir.MoveToMovingObject(CX, CY, self, CX + 2, CY + 2, True) >
              0 then begin
              CX := CX + 2;
              CY := CY + 2;
            end;
      end;
    end;

    if (prx <> CX) or (pry <> CY) then begin
      if Walk(RM_RUN) then begin
        Result := True;
      end else begin
        CX := prx;  //실패..
        CY := pry;
        if PEnvir.MoveToMovingObject(prx, pry, self, CX, CY, True) <= 0 then begin
          MainOutMessage('ERROR DO NOT MOVINGOBJECT BACK :' +
            PEnvir.MapName + ':' + IntToStr(CX) + ':' + IntToStr(CY));
        end;
      end;
    end;

  except
    MainOutMessage('[Exception] TCreature.RunTo');
  end;
end;

function TCreature.IsEnoughBag: boolean;
begin
  if Itemlist.Count < MAXBAGITEM then
    Result := True
  else
    Result := False;
end;

procedure TCreature.WeightChanged;
begin
  WAbil.Weight := {CalcWearWeightEx (-1) +} CalcBagWeight;
  UpdateMsg(self, RM_WEIGHTCHANGED, 0, 0, 0, 0, '');
end;

procedure TCreature.GoldChanged;
begin
  if RaceServer = RC_USERHUMAN then
    UpdateMsg(self, RM_GOLDCHANGED, 0, 0, 0, 0, '');
end;

procedure TCreature.HealthSpellChanged;
begin
  if RaceServer = RC_USERHUMAN then
    UpdateMsg(self, RM_HEALTHSPELLCHANGED, 0, 0, 0, 0, '');
  if BoOpenHealth then
    SendRefMsg(RM_HEALTHSPELLCHANGED, 0, 0, 0, 0, '');
end;

function TCreature.IsAddWeightAvailable(addweight: integer): boolean;
begin
  if WAbil.Weight + addweight <= WAbil.MaxWeight then
    Result := True
  else
    Result := False;
end;

function TCreature.FindItemName(iname: string): PTUserItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ItemList.Count - 1 do begin
    if CompareText(UserEngine.GetStdItemName(PTUserItem(ItemList[i]).Index), iname) =
      0 then begin
      Result := PTUserItem(ItemList[i]);
      break;
    end;
  end;
end;

function TCreature.FindItemNameEx(iname: string;
  var Count, durasum, duratop: integer): PTUserItem;
var
  i:  integer;
  ps: PTStdItem;
  pu: PTUserItem;
begin
  Result  := nil;
  durasum := 0;
  duratop := 0;
  Count   := 0;
  ps      := nil;
  pu      := nil;
  for i := 0 to ItemList.Count - 1 do begin
    pu := PTUserItem(ItemList[i]);
    if pu <> nil then begin
      ps := UserEngine.GetStdItem(pu.Index);
      if ps <> nil then begin
        if CompareText(ps.Name, iname) = 0 then begin
          if ps.OverlapItem >= 1 then begin
            Count  := pu.Dura;
            Result := pu;
          end else begin
            //-----------------------------------------------------------
            //부적이면 개수를 체크해서 모자르면 다음 아이템으로 넘어감.
            if ps.Name = GetUnbindItemName(SHAPE_AMULET_BUNCH) then begin
              if pu.Dura < pu.DuraMax then
                continue;
            end;
            //-----------------------------------------------------------

            if pu.Dura > duratop then begin
              duratop := pu.Dura;
              Result  := pu;
            end;
            durasum := durasum + pu.Dura;
            if Result = nil then
              Result := pu;
            Inc(Count);
          end;
        end;
      end;
    end;
  end;
end;

function TCreature.FindItemEventGrade(grade, Count: integer): boolean;
var
  i:  integer;
  ps: PTStdItem;
  pu: PTUserItem;
  existcount: integer;
begin
  Result := False;
  ps     := nil;
  pu     := nil;
  existcount := 0;
  for i := 0 to ItemList.Count - 1 do begin
    pu := PTUserItem(ItemList[i]);
    if pu <> nil then begin
      ps := UserEngine.GetStdItem(pu.Index);
      if ps <> nil then begin
        if ps.EffType2 = EFFTYPE2_EVENT_GRADE then begin
          if ps.EffValue2 = grade then begin
            Inc(existcount);
          end;
        end;
      end;
    end;
  end;

  if existcount >= Count then
    Result := True;
end;

function TCreature.FindItemWear(iname: string; var Count: integer): PTUserItem;
var
  i: integer;
begin
  Result := nil;
  Count  := 0;
  for i := 0 to 8 do begin
    if CompareText(UserEngine.GetStdItemName(UseItems[i].Index), iname) = 0 then begin
      Result := @(UseItems[i]);
      Inc(Count);
    end;
  end;
end;

function TCreature.CanAddItem: boolean;
begin
  Result := False;
  if Itemlist.Count < MAXBAGITEM then
    Result := True;
end;

//pu는 새로 new해서 늘것(따로 new 하지 않음)
function TCreature.AddItem(pu: PTUserItem): boolean;
begin
  Result := False;
  if Itemlist.Count < MAXBAGITEM then begin
    Itemlist.Add(pu);
    WeightChanged;
    Result := True;
  end;
end;

function TCreature.DelItem(svindex: integer; iname: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to ItemList.Count - 1 do begin
    if PTUserItem(ItemList[i]).MakeIndex = svindex then begin
      if CompareText(UserEngine.GetStdItemName(PTUserItem(ItemList[i]).Index),
        iname) = 0 then begin
        Dispose(PTUserItem(ItemList[i]));
        ItemList.Delete(i);
        Result := True;
        break;
      end;
    end;
  end;
  if Result then
    WeightChanged;
end;

function TCreature.DelItemIndex(bagindex: integer): boolean;
var
  i: integer;
begin
  Result := False;
  if (bagindex >= 0) and (bagindex < ItemList.Count) then begin
    Dispose(PTUserItem(ItemList[bagindex]));
    ItemList.Delete(bagindex);
  end;
end;

function TCreature.DeletePItemAndSend(pcheckitem: PTUserItem): boolean;
var
  i:   integer;
  hum: TUserHuman;
begin
  Result := False;
  for i := 0 to ItemList.Count - 1 do begin
    if ItemList[i] = pcheckitem then begin
      if RaceServer = RC_USERHUMAN then begin
        hum := TUserHuman(self);
        hum.SendDelItem(PTUserItem(ItemList[i])^);
      end;
      Dispose(PTUserItem(ItemList[i]));
      ItemList.Delete(i);
      Result := True;
      exit;
    end;
  end;
  for i := 0 to 8 do begin
    if @(UseItems[i]) = pcheckitem then begin
      if RaceServer = RC_USERHUMAN then begin
        hum := TUserHuman(self);
        hum.SendDelItem(UseItems[i]);
      end;
      UseItems[i].Index := 0;
      Result := True;
    end;
  end;
end;

function TCreature.DeletePItemAndSendWithFlag(pcheckitem: PTUserItem;
  wBreakdown: word): boolean;
var
  i:   integer;
  hum: TUserHuman;
begin
  Result := False;
  for i := 0 to ItemList.Count - 1 do begin
    if ItemList[i] = pcheckitem then begin
      if RaceServer = RC_USERHUMAN then begin
        hum := TUserHuman(self);
        hum.SendDelItemWithFlag(PTUserItem(ItemList[i])^, wBreakdown);
      end;
      Dispose(PTUserItem(ItemList[i]));
      ItemList.Delete(i);
      Result := True;
      exit;
    end;
  end;
  for i := 0 to 8 do begin
    if @(UseItems[i]) = pcheckitem then begin
      if RaceServer = RC_USERHUMAN then begin
        hum := TUserHuman(self);
        hum.SendDelItemWithFlag(UseItems[i], wBreakdown);
      end;
      UseItems[i].Index := 0;
      Result := True;
    end;
  end;
end;

function TCreature.CanTakeOn(index: integer; ps: PTStdItem): boolean;
  //성별과 레벨, 직업에 맞는지 검사
begin
  Result := False;
  if ps.StdMode = 5 then
    if ps.Shape in [200, 201, 202, 203, 204, 205, 206, 207, 208, 209] then begin
    if Job <> 3 then begin
      SysMsg('It is for Assassin.', 0);
      exit;
    end;
    end;

  if ps.StdMode in [10, 11] then
    if ps.Shape in [206, 207, 208, 209, 210, 211] then begin
    if Job <> 3 then begin
      SysMsg('It is for Assassin.', 0);
      exit;
    end;
    end;
      
  if ps.StdMode = 10 then //남자 옷
    if Sex <> 0 then begin //남자가 아니면
      SysMsg('It is for a man.', 0);
      exit;
    end;
  if ps.StdMode = 11 then //여자옷
    if Sex <> 1 then begin
      SysMsg('It is for a woman.', 0);
      exit;
    end;

  //무게 검사  index:착용할곳
  if (index = U_WEAPON) or (index = U_RIGHTHAND) then begin
    if ps.Weight > WAbil.MaxHandWeight then begin //들 수 있는 무기 무게 초과
      SysMsg('It is too heavy.', 0);
      exit;
    end;
  end else begin
    if ps.Weight + CalcWearWeightEx(index) > WAbil.MaxWearWeight then
    begin //입고 있는 아이템의 무게 초과
      SysMsg('It is too heavy.', 0);
      exit;
    end;
  end;

  case ps.Need of
    0: //레벨 검사
    begin
      if Abil.Level >= ps.NeedLevel then
        Result := True;
    end;
    1: //DC
    begin
      if Hibyte(WAbil.DC) >= ps.NeedLevel then
        Result := True;
    end;
    2: //MC
    begin
      if Hibyte(WAbil.MC) >= ps.NeedLevel then
        Result := True;
    end;
    3: //SC
    begin
      if Hibyte(WAbil.SC) >= ps.NeedLevel then
        Result := True;
    end;
  end;
  if not Result then
    SysMsg('You cannot wear it.', 0);
end;

function TCreature.GetDropPosition(x, y, wide: integer; var dx, dy: integer): boolean;
var
  i, j, k, dropcount, icount, ssx, ssy: integer;
  pm: PTMapItem;
begin
  icount := 999;
  Result := False;
  ssx    := dx;
  ssy    := dy;
  for k := 1 to wide do begin
    for j := -k to k do begin
      for i := -k to k do begin
        dx := x + i;
        dy := y + j;
        if PEnvir.GetItemEx(dx, dy, dropcount) = nil then begin
          if PEnvir.BoCanGetItem then begin
            Result := True;
            break;
          end;
        end else begin
          if PEnvir.BoCanGetItem then begin
            if icount > dropcount then begin
              icount := dropcount;
              ssx    := dx;
              ssy    := dy;
            end;
          end;
        end;
      end;
      if Result then
        break;
    end;
    if Result then
      break;
  end;
  if not Result then begin //아니면 자기 자리...
    if icount < 8 then begin
      dx := ssx;
      dy := ssy;
    end else begin
      dx := x;// - wide + Random(wide*2+1);
      dy := y;// - wide + Random(wide*2+1);
    end;
  end;
end;

function TCreature.GetRecallPosition(x, y, wide: integer; var dx, dy: integer): boolean;
var
  i, j, k: integer;
  pm:      PTMapItem;
begin
  Result := False;
  if PEnvir.GetCreature(x, y, True) = nil then begin
    Result := True;
    dx     := x;
    dy     := y;
  end;
  if not Result then begin
    for k := 1 to wide do begin
      for j := -k to k do begin
        for i := -k to k do begin
          dx := x + i;
          dy := y + j;
          if PEnvir.GetCreature(dx, dy, True) = nil then begin
            Result := True;
            break;
          end;
        end;
        if Result then
          break;
      end;
      if Result then
        break;
    end;
  end;
  if not Result then begin //아니면 자기 자리...
    dx := x;// - wide + Random(wide*2+1);
    dy := y;// - wide + Random(wide*2+1);
  end;
end;

function TCreature.DropItemDown(ui: TUserItem; scatterrange: integer;
  diedrop: boolean; ownership, droper: TObject; IsDropFromBag: integer): boolean;
var
  dx, dy, idura, temp: integer;
  pmi, pr: PTMapItem;
  ps:      PTStdItem;
  logcap:  string;
  decoitem: TAgitDecoItem;
  pricestr: string;
  countstr: string;
begin
  Result   := False;
  countstr := '';

  ps := UserEngine.GetStdItem(ui.Index);
  if ps <> nil then begin

    if ps.StdMode = 40 then begin //고기를 땅에 떨어뜨린 경우 고기 품질이 떨어진다.
      idura := ui.Dura;           //word이므로.
      idura := idura - 2000;      //고기 품질이 떨어진다.
      if idura < 0 then
        idura := 0;
      ui.Dura := idura;
    end;

    new(pmi);
    pmi.UserItem := ui;

    // 카운트 아이템
    if (ps.OverlapItem >= 1) then begin
      temp := ui.Dura;
      if temp > 1 then begin
        countstr := '(' + IntToStr(temp) + ')';
        //로그를 위한 아이템 개수(sonmg 2005/01/07)
        pmi.Name := ps.Name + countstr;  // gadget :카운터아이템
      end else
        pmi.Name := ps.Name;
    end else
      pmi.Name := ps.Name;

    pmi.Looks := ps.Looks;
    if ps.StdMode = 45 then begin  //주사위, 목재
      pmi.Looks := GetRandomLook(pmi.Looks, ps.Shape);
    end;
    pmi.AniCount  := ps.AniCount;
    pmi.Reserved  := 0;
    pmi.Count     := 1;
    pmi.Ownership := ownership;
    pmi.Droptime  := GetTickCount;
    pmi.Droper    := droper;

    GetDropPosition(CX, CY, scatterrange, dx, dy);

    //-----------------------------------------
    //상현주머니를 맵에 떨어뜨리는 경우
    if (ps.StdMode = STDMODE_OF_DECOITEM) and (ps.Shape = SHAPE_OF_DECOITEM) then begin
      if ui.Dura <= DecoItemList.Count then begin
        //드롭 위치는 자기 자신의 위치로 설정.
        dx := CX;
        dy := CY;

        pmi.Name      := GuildAgitMan.GetDecoItemName(ui.Dura, pricestr) +
          '[' + IntToStr(Round(ui.DuraMax / 1000)) + ']' + '/' + '1';  //데코아이템
        pmi.Looks     := ui.Dura;
        pmi.AniCount  := ps.AniCount;
        pmi.Reserved  := 0;
        pmi.Count     := 1;
        pmi.Ownership := droper;  // 떨어뜨린 사람의 소유...
        pmi.Droptime  := GetTickCount;
        pmi.Droper    := droper;

        //상현주머니 속성 설정 및 List에 저장
        decoitem.Name  := GuildAgitMan.GetDecoItemName(ui.Dura, pricestr);
        decoitem.Looks := ui.Dura;
        decoitem.MapName := PEnvir.MapName;
        decoitem.x     := dx;
        decoitem.y     := dy;
        decoitem.Maker := UserName;
        decoitem.Dura  := ui.DuraMax;
      end else begin
        MainOutMessage('[DropItemDown] DecoItemList Error...');
      end;
    end else begin
      pmi.Name := pmi.Name + '/' + '0';  //일반아이템(데코아이템이 아님)
    end;
    //-----------------------------------------

    pr := Penvir.AddToMap(dx, dy, OS_ITEMOBJECT, TObject(pmi));
    //한셀에 5개 이상의 아이템이 있으면 실패한다.
    if pr = pmi then begin
      //상현주머니인 경우 맵에 제대로 추가가 되었으면...
      if (ps.StdMode = STDMODE_OF_DECOITEM) and (ps.Shape = SHAPE_OF_DECOITEM) then
      begin
        if GuildAgitMan.AddAgitDecoMon(decoitem) then begin
          // 장원꾸미기 오브젝트 개수 추가
          GuildAgitMan.IncAgitDecoMonCount(GetGuildNameHereAgit);
          //꾸미기 아이템 리스트를 저장한다.
          GuildAgitMan.SaveAgitDecoMonList;
        end else begin
          MainOutMessage('[ErrorMsg]TCreature.DropItemDown : AddAgitDecoMon Failure!!!');
        end;
      end;

      //아이템은 추가 아니면 실패..
      SendRefMsg(RM_ITEMSHOW, pmi.Looks, integer(pmi), dx, dy, pmi.Name);
      //떨어뜨림
      if diedrop then
        logcap := '15'#9  //떨굼_
      else begin
        logcap := '7'#9;  //버림_
        TUserHuman(self).LatestDropTime := GetTickCount;
      end;
      if not IsCheapStuff(ps.StdMode) then
        AddUserLog(logcap + MapName + ''#9 + IntToStr(CX) + ''#9 +
          IntToStr(CY) + ''#9 + UserName + ''#9 + UserEngine.GetStdItemName(ui.Index) +
          ''#9 + IntToStr(ui.MakeIndex) + ''#9 +
          IntToStr(BoolToInt(RaceServer = RC_USERHUMAN)) + ''#9 +
          IntToStr(IsDropFromBag) + countstr //개수로그(sonmg 2005/01/07)
          );
      Result := True;
    end else begin
      //실패인경우
      Dispose(pmi);
    end;
  end;
end;

 //Gold가 줄지는 않음.
 //diedrop = TRUE (죽어서 떨굼) FALSE (버림)
function TCreature.DropGoldDown(goldcount: integer; diedrop: boolean;
  ownership, droper: TObject): boolean;
var
  dx, dy:  integer;
  pmi, pr: PTMapItem;
  ps:      PTStdItem;
  logcap:  string;
begin
  Result := False;
  new(pmi);
  FillChar(pmi^, sizeof(TMapItem), #0);
  pmi.Name      := NAME_OF_GOLD{'금전'};
  pmi.Count     := goldcount;
  pmi.Looks     := GetGoldLooks(goldcount);
  pmi.Ownership := ownership;
  pmi.Droptime  := GetTickCount;
  pmi.Droper    := droper;

  GetDropPosition(CX, CY, 3, dx, dy);
  pr := PEnvir.AddToMap(dx, dy, OS_ITEMOBJECT, TObject(pmi));
  if pr <> nil then begin
    if pr <> pmi then begin
      Dispose(pmi);
      pmi := pr;
    end;
    SendRefMsg(RM_ITEMSHOW, pmi.Looks, integer(pmi), dx, dy,
      NAME_OF_GOLD{'금전'} + '/' + '0');   //장원꾸미기로 인해 추가정보 붙여서 보냄
    //떨어뜨림
    if RaceServer = RC_USERHUMAN then begin
      if diedrop then
        logcap := '15'#9  //떨굼_
      else begin
        logcap := '7'#9;  //버림_
        TUserHuman(self).LatestDropTime := GetTickCount;
      end;
      AddUserLog(logcap + MapName + ''#9 + IntToStr(CX) + ''#9 +
        IntToStr(CY) + ''#9 + UserName + ''#9 + NAME_OF_GOLD{'금전'} +
        ''#9 + IntToStr(goldcount) + ''#9 +
        IntToStr(BoolToInt(RaceServer = RC_USERHUMAN)) + ''#9 + '0');
    end;
    Result := True;
  end else begin
    //실패인경우
    Dispose(pmi);
  end;
end;

//땅바닥에 버림
function TCreature.UserDropItem(itmname: string; ItemIndex: integer): boolean;
var
  i:     integer;
  pu:    PTUserItem;
  pstd:  PTStdItem;
  hum:   TUserHuman;
  gname: string;
begin
  Result := False;
  // 아이템을 버릴 수 없음(sonmg 2005/03/14)
  if PEnvir.NoThrowItem then
    exit;

  if pos(' ', itmname) >= 0 then
    GetValidStr3(itmname, itmname, [' ']);
  if GetTickCount - DealItemChangeTime > 3000 then begin
    //교환창이 사라진 다음 아이템을 올리려다 땅에 떨구는 것을 방지
    for i := 0 to ItemList.Count - 1 do begin
      pu   := PTUserItem(ItemList[i]);
      pstd := UserEngine.GetStdItem(pu.Index);  //대만 이벤트, 버릴 수 없는 아이템
      if pstd = nil then
        continue;
      //         if (pstd.UniqueItem and $04) <> 0 then continue; //UNIQUEITEM 필드가 00000100(2진수)를 포함하면 떨굴 수 없는 아이템(sonmg 2005/03/14)
      if pstd.StdMode <> TAIWANEVENTITEM then begin  //이벤트 아이템은 못 버린다.
        if (pu.MakeIndex = ItemIndex) then begin
          if CompareText(UserEngine.GetStdItemName(pu.Index), itmname) = 0 then
          begin
            //UNIQUEITEM 필드가 00000100(2진수)를 포함하면 버리면 사라지는 아이템(sonmg 2005/03/14)
            if (pstd.UniqueItem and $04) <> 0 then begin
              Dispose(PTUserItem(ItemList[i]));
              ItemList.Delete(i);
              Result := True;
              break;
            end;

            //------------------------------------
            //장원꾸미기 아이템 맵에 설치(sonmg)
            if (pstd.StdMode = STDMODE_OF_DECOITEM) and
              (pstd.Shape = SHAPE_OF_DECOITEM) then begin
              if RaceServer = RC_USERHUMAN then begin
                hum := TUserHuman(self);

                // 장원인지 체크
                gname := hum.GetGuildNameHereAgit;
                if gname <> '' then begin
                  // 본인의 장원인지 체크
                  if MyGuild <> nil then begin
                    if TGuild(MyGuild).GuildName <> gname then begin
                      hum.SysMsg(
                        'You can use it only in your guild territory.', 0);
                      break;
                    end;
                    if not GuildAgitMan.IsAvailableDecoMonCount(gname) then
                    begin
                      hum.SysMsg('You cannot install any more.', 0);
                      break;
                    end;
                    if not GuildAgitMan.IsMatchDecoItemInOutdoor(
                      pu.Dura, MapName) then begin
                      hum.SysMsg('You cannot install here.', 0);
                      break;
                    end;
                    // 장원꾸미기 오브젝트 개수 추가(->위치가 부적절함 옮김 2004/09/01)
                    //                              GuildAgitMan.IncAgitDecoMonCount( GetGuildNameHereAgit );
                  end;
                end else begin
                  hum.SysMsg('You can use it only in your guild territory.', 0);
                  break;
                end;
              end;
            end;

            if DropItemDown(pu^, 1, False, nil, self, 0) then begin
              Dispose(PTUserItem(ItemList[i]));
              ItemList.Delete(i);
              Result := True;
              break;
            end;
          end;
        end;
      end;
    end;
    if Result then
      WeightChanged;
  end;
end;

function TCreature.UserDropGold(dropgold: integer): boolean;
begin
  Result := False;
  // 아이템을 버릴 수 없음(sonmg 2005/03/14)
  if PEnvir.NoThrowItem then
    exit;

  if (dropgold > 0) and (dropgold <= Gold) then begin
    //      Gold := Gold - dropgold;
    DecGold(dropgold);
    if not DropGoldDown(dropgold, False, nil, self) then begin
      //         Gold := Gold + dropgold;
      IncGold(dropgold);
    end;
    GoldChanged;
    Result := True;
  end;
end;

// 카운트 아이템
function TCreature.UserDropCountItem(itmname: string;
  dropidx, dropcnt: integer): boolean;
var
  i, remain, t: integer;
  pu, newpu: PTUserItem;
  ps: PTStdItem;
begin
  Result := False;
  // 아이템을 버릴 수 없음(sonmg 2005/03/14)
  if PEnvir.NoThrowItem then
    exit;

  if pos(' ', itmname) >= 0 then
    GetValidStr3(itmname, itmname, [' ']);
  if GetTickCount - DealItemChangeTime > 3000 then begin
    //교환창이 사라진 다음 아이템을 올리려다 땅에 떨구는 것을 방지
    for i := 0 to ItemList.Count - 1 do begin
      pu := PTUserItem(ItemList[i]);
      if pu.MakeIndex = dropidx then begin
        ps := UserEngine.GetStdItem(pu.Index);
        if ps <> nil then begin
          if ps.OverlapItem = 0 then
            continue;

          //               if (ps.UniqueItem and $04) <> 0 then continue; //UNIQUEITEM 필드가 00000100(2진수)를 포함하면 떨굴 수 없는 아이템(sonmg 2005/03/14)

          if CompareText(ps.Name, itmname) = 0 then begin
            t := pu.Dura;
            if dropcnt > t then
              dropcnt := pu.Dura;

            remain := t - dropcnt;

            if dropcnt > 0 then begin
              if remain > 0 then begin
                new(newpu);
                if UserEngine.CopyToUserItemFromName(itmname, newpu^) then begin
                  newpu.Dura := dropcnt;
                  //UNIQUEITEM 필드가 00000100(2진수)를 포함하면 버리면 사라지는 아이템(sonmg 2005/03/14)
                  if (ps.UniqueItem and $04) <> 0 then begin
                    pu.Dura := remain;
                    SendMsg(self, RM_COUNTERITEMCHANGE, 0,
                      pu.MakeIndex, remain {수량}, 0, itmname);
                    WeightChanged;
                    Dispose(newpu);
                    break;
                  end;
                  if DropItemDown(newpu^, 1, False, nil, self, 0) then begin
                    pu.Dura := remain;
                    SendMsg(self, RM_COUNTERITEMCHANGE, 0,
                      pu.MakeIndex, remain {수량}, 0, itmname);
                    WeightChanged;
                    Dispose(newpu);
                    break;
                  end else begin
                    Dispose(newpu);
                    break;
                  end;
                end else begin
                  Dispose(newpu);
                  break;
                end;
              end else begin
                //UNIQUEITEM 필드가 00000100(2진수)를 포함하면 버리면 사라지는 아이템(sonmg 2005/03/14)
                if (ps.UniqueItem and $04) <> 0 then begin
                  Dispose(PTUserItem(ItemList[i]));
                  ItemList.Delete(i);
                  WeightChanged;
                  Result := True;
                  break;
                end;
                if DropItemDown(pu^, 1, False, nil, self, 0) then begin
                  Dispose(PTUserItem(ItemList[i]));
                  ItemList.Delete(i);
                  WeightChanged;
                  Result := True;
                  break;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

 ////////////////////////////////////////////////////////////////////////////////
 // 카운트 아이템 개수 추가
 // 설명 : 가방창에서 해당 아이템을 찾아서 카운트를 합산.
 //        없을 경우나 최대 개수를 넘는 경우는 FALSE를 리턴.
 //        같은 아이템이 여럿 있다면 개수가 가장 작은 아이템에 합산하도록 수정.(2004/1/7)
function TCreature.UserCounterItemAdd(StdMode, Looks, Cnt: integer;
  iName: string; bEnforce: boolean; ExceptMakeIndex: integer): boolean;
var
  i:  integer;
  pu: PTUserItem;
  ps: PTStdItem;
  idxMinimum: integer;      // 가장 작은 개수의 아이템 인덱스.
  countMinimum, temp: word; // 가장 작은 개수
begin
  Result := False;

  // 값 초기화.
  idxMinimum := -1;
  countMinimum := 0;
  temp := 0;

  for i := 0 to Itemlist.Count - 1 do begin
    ps := UserEngine.GetStdItem(PTUserItem(Itemlist[i]).Index);

    if ps = nil then
      continue;
    if ps.OverlapItem = 0 then
      continue;
    // 카운트 아이템이면서 같은 종류의 아이템이면.
    if (ps.StdMode = StdMode) and (ps.Looks = Looks) and (ps.OverlapItem >= 1) then
    begin
      // 이름이 같으면
      if CompareText(ps.Name, iName) = 0 then begin
        pu := PTUserItem(Itemlist[i]);

{  // 무게 제한 없앰.
            if ps.OverlapItem = 1 then begin
               if ((WAbil.Weight + (cnt div 10)) > WAbil.MaxWeight) then exit;
            end else begin
               if (WAbil.Weight + (ps.Weight * cnt) > WAbil.MaxWeight) then exit;
            end;
}

        // 지정한 makeindex의 아이템은 제외.
        if (ExceptMakeIndex <> -1) and (pu.MakeIndex = ExceptMakeIndex) then
          continue;

        // 아이템의 개수를 최소값에 대입.
        // 처음에는 그냥 대입. 이후에는 값을 비교해서 작은 값을 대입.
        if idxMinimum = -1 then begin
          countMinimum := pu.Dura;
          idxMinimum   := i;
        end else begin
          if countMinimum > pu.Dura then begin
            countMinimum := pu.Dura;
            idxMinimum   := i;
          end;
        end;
      end;
    end;
  end;

  // 아이템이 없으면 exit
  if idxMinimum < 0 then
    exit;

  // 개수가 가장 작은 아이템.
  ps := UserEngine.GetStdItem(PTUserItem(Itemlist[idxMinimum]).Index);
  if ps = nil then
    exit;
  pu := PTUserItem(Itemlist[idxMinimum]);

  // MAX_OVERLAPITEM넘으면 FALSE 리턴.
  // 강제 옵션이 있으면 최대 개수 제한을 무시하고 무조건 합산.
  if (bEnforce = False) and (pu.Dura + Cnt > MAX_OVERLAPITEM) then
    exit;

  // MAX_OVERFLOW 넘으면 exit.
  if pu.Dura + Cnt > MAX_OVERFLOW then
    exit;

  // Dura를 Count로 사용.
  // 개수를 합산에서 대입.
  pu.Dura := _MIN(MAX_OVERFLOW, pu.Dura + Cnt);

  // 합산 결과를 클라이언트에 통보.
  if RaceServer = RC_USERHUMAN then begin
    SendMsg(self, RM_COUNTERITEMCHANGE, 0, pu.MakeIndex, pu.Dura {수량},
      1{증가}, ps.Name);
  end;

  Result := True;
end;


// 거래 목록 -> 카운트 아이템 개수 추가
function TCreature.UserCounterDealItemAdd(StdMode, Looks, Cnt: integer;
  iName: string): integer;
const
  FAIL      = 0;
  SUCCESS   = 1;
  OVERFLOW  = 2;
  OVERCOUNT = 3;
var
  i:  integer;
  pu: PTUserItem;
  ps: PTStdItem;
begin
  Result := FAIL;

  for i := 0 to DealList.Count - 1 do begin
    ps := UserEngine.GetStdItem(PTUserItem(DealList[i]).Index);

    if ps = nil then
      continue;
    if ps.OverlapItem = 0 then
      continue;
    if (ps.StdMode = StdMode) and (ps.Looks = Looks) and (ps.OverlapItem >= 1) then
    begin
      if CompareText(ps.Name, iName) = 0 then begin
        pu := PTUserItem(DealList[i]);

{  // 무게 제한 없앰.
            if ps.OverlapItem = 1 then begin
               if ((WAbil.Weight + (cnt div 10)) > WAbil.MaxWeight) then exit;
            end else begin
               if (WAbil.Weight + (ps.Weight * cnt) > WAbil.MaxWeight) then exit;
            end;
}

        // 거래할 때는 최대 개수가 넘어도 통합한다.
        if pu.Dura + Cnt > MAX_OVERLAPITEM then begin
          Result := OVERCOUNT;
          exit;
        end;

        // MAX_OVERFLOW 넘는 경우.
        if pu.Dura + Cnt > MAX_OVERFLOW then begin
          Result := OVERFLOW;
          exit;
        end;

        // Dura를 Count로 사용.
        pu.Dura := _MIN(MAX_OVERFLOW, pu.Dura + Cnt);
        if RaceServer = RC_USERHUMAN then begin
          SendMsg(self, RM_COUNTERITEMCHANGE, 0, pu.MakeIndex,
            pu.Dura {수량}, 0, ps.Name);
        end;
        Result := SUCCESS;
        break;
      end;
    end;
  end;
end;


function TCreature.PickUp: boolean;

  function canpickup(ownership: TObject): boolean;
  begin
    if (ownership = nil) or (ownership = self) then
      Result := True
    else
      Result := False;
  end;

  function cangrouppickup(ownership: TObject): boolean;
  var
    i:    integer;
    cret: TCreature;
  begin
    Result := False;
    if GroupOwner <> nil then
      for i := 0 to GroupOwner.GroupMembers.Count - 1 do begin
        cret := TCreature(GroupOwner.GroupMembers.Objects[i]);
        if (cret = ownership) then begin
          Result := True;
          break;
        end;
      end;
  end;

var
  i, wg: integer;
  pu:    PTUserItem;
  pmi:   PTMapItem;
  ps:    PTStdItem;
  hum:   TUserHuman;
  questnpc: TMerchant;
  dropername: string;
  flag:  boolean;
  decoitem: TAgitDecoItem;
  pricestr: string;
  countstr: string;
begin
  Result := False;
  wg     := 0;
  ps     := nil;
  countstr := '';

  if BoDealing then
    exit;  //교환중에는 물건을 주울 수 없다.
  hum := nil;
  pmi := PEnvir.GetItem(CX, CY);
  if pmi <> nil then begin
    //먹자 막는 루틴
    if (GetTickCount - pmi.droptime > ANTI_MUKJA_DELAY) then
      pmi.ownership := nil;

    if canpickup(pmi.ownership) or cangrouppickup(pmi.ownership) then begin
      if CompareText(pmi.Name, NAME_OF_GOLD{'금전'}) = 0 then begin
        if PEnvir.DeleteFromMap(CX, CY, OS_ITEMOBJECT, TObject(pmi)) = 1 then begin
          if IncGold(pmi.Count) then begin
            SendRefMsg(RM_ITEMHIDE, 0, integer(pmi), CX, CY, '');
            //로그남김
            AddUserLog('4'#9 + //줍기_
              MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
              ''#9 + UserName + ''#9 + NAME_OF_GOLD{'금전'} + ''#9 +
              IntToStr(pmi.Count) + ''#9 + '1'#9 + '0');
            GoldChanged;
            Dispose(pmi);
          end else
            PEnvir.AddToMap(CX, CY, OS_ITEMOBJECT, TObject(pmi));
        end;
      end else
        ps := UserEngine.GetStdItem(pmi.UserItem.Index); // gadget: 카운트아이템

      if ps <> nil then begin
        // 카운트 아이템이면 기존 아이템에 개수만 더한다.
        // 기존 아이템이 없으면 따로 생성한다.
        if ps.OverlapItem >= 1 then begin
          countstr := '(' + IntToStr(pmi.UserItem.Dura) + ')';
          //로그를 위한 아이템 개수(sonmg 2005/01/07)
          if PEnvir.DeleteFromMap(CX, CY, OS_ITEMOBJECT, TObject(pmi)) = 1 then
          begin
            if UserCounterItemAdd(ps.StdMode, ps.Looks,
              pmi.UserItem.Dura, ps.Name, False) then begin
              SendMsg(self, RM_ITEMHIDE, 0, integer(pmi), CX, CY, '');
              WeightChanged;
              Dispose(pmi);   //memory leak
              exit;
            end else begin
              PEnvir.AddToMap(CX, CY, OS_ITEMOBJECT, TObject(pmi));
            end;
          end;
        end;

        if IsEnoughBag then begin
          flag := True;
          //------상현주머니----------------------
          if (ps.StdMode = STDMODE_OF_DECOITEM) and
            (ps.Shape = SHAPE_OF_DECOITEM) then begin
            //소유자가 없으면 문주만 주울 수 있고, 소유자가 있으면 소유자만 주울 수 있다.
            if ((pmi.Ownership = nil) and (IsMyGuildMaster)) or
              ((pmi.Ownership <> nil) and (pmi.Ownership = self)) then begin
              //내구가 1이하이면 줍지 못한다.
              //                        if Round(pmi.UserItem.DuraMax/1000) > 1 then begin
              //리스트에서 삭제한다.
              if GuildAgitMan.DeleteAgitDecoMon(PEnvir.MapName, CX, CY) then
              begin
                GuildAgitMan.SaveAgitDecoMonList;
                //상현주머니를 줍는 경우 내구를 1씩 깎는다.
                //                              pmi.UserItem.DuraMax := pmi.UserItem.DuraMax - 1000;
                //장원꾸미기 오브젝트 개수 감소
                //                              GuildAgitMan.DecAgitDecoMonCount( GetGuildNameHereAgit );
                flag := True;
              end else begin
                flag := False;
              end;
              //                        end else begin
              //                           SysMsg('내구가 낮아서 집을 수 없습니다.', 0);
              //                           flag := FALSE;
              //                        end;
            end else begin
              flag := False;
            end;
          end;
          //--------------------------------------

          if flag then begin
            if PEnvir.DeleteFromMap(CX, CY, OS_ITEMOBJECT, TObject(pmi)) =
              1 then begin
              new(pu);
              pu^ := pmi.UserItem;
              ps  := UserEngine.GetStdItem(pu.Index);

              if ps <> nil then begin

                if ps.OverlapItem = 1 then
                  wg := (pmi.UserItem.Dura) div 10
                else if ps.OverlapItem >= 2 then
                  wg := (ps.Weight * pmi.UserItem.Dura)
                else
                  wg := ps.Weight;

              end;

              if (ps <> nil) { and IsAddWeightAvailable (wg) } then begin
                SendMsg(self, RM_ITEMHIDE, 0, integer(pmi), CX, CY, '');
                AddItem(pu);

                //맵퀘스트가 있는지
                if PEnvir.HasMapQuest then begin
                  dropername := '';
                  if pmi.Droper <> nil then
                    dropername := TCreature(pmi.Droper).UserName;
                  questnpc :=
                    TMerchant(PEnvir.GetMapQuest(self, dropername, ps.Name, False));
                  if questnpc <> nil then
                    questnpc.UserCall(self);
                end;


                //로그남김
                if not IsCheapStuff(ps.StdMode) then begin
                  AddUserLog('4'#9 + //줍기_
                    MapName + ''#9 + IntToStr(CX) + ''#9 +
                    IntToStr(CY) + ''#9 + UserName + ''#9 +
                    UserEngine.GetStdItemName(pu.Index) + ''#9 +
                    IntToStr(pu.MakeIndex) + ''#9 + '1'#9 + '0' + countstr);
                  //개수로그(sonmg 2005/01/07)
                end;

                if RaceServer = RC_USERHUMAN then begin
                  if self is TUserHuman then begin
                    hum := TUserHuman(self);
                    TUserHuman(hum).SendAddItem(pu^);
                  end;
                end;

                if ps.StdMode = TAIWANEVENTITEM then begin
                  //대만 이벤트, 이벤트 아이템을 주으면 표시남
                  if hum <> nil then begin
                    hum.TaiwanEventItemName := ps.Name;
                    hum.BoTaiwanEventUser := True;
                    //캐릭의 색깔을 바꾼다.
                    StatusArr[STATE_BLUECHAR] := 60000;  //타임 아웃 없음;
                    CharStatus := GetCharStatus;
                    CharStatusChanged;
                    Light := GetMyLight;
                    SendRefMsg(RM_CHANGELIGHT, 0, 0, 0, 0, '');
                    UserNameChanged;
                  end;
                end;

                Dispose(pmi);
                Result := True;
              end else begin
                Dispose(pu);
                PEnvir.AddToMap(CX, CY, OS_ITEMOBJECT, TObject(pmi));
              end;
            end;//if PEnvir.DeleteFromMap
          end;//flag
        end;
      end;
    end else begin
      SysMsg('You can not pick up during a decent time.', 0);
    end;
  end;
end;

function TCreature.EatItem(std: TStdItem; pu: PTUserItem): boolean;
var
  boneedrecalc: boolean;
  hum, humlover: TUserHuman;
  pstd: PTStdItem;
  i:    integer;
  flag: boolean;
begin
  pstd   := nil;
  Result := False;
  if PEnvir.NoDrug then begin
    ///MapName = '0137' then begin  //약을 먹을 수 없는 대련 맵
    SysMsg('You cannot use it here.', 0);
    exit;
  end;
  case std.StdMode of
    0: //시약류
    begin
      case std.Shape of
        FASTFILL_ITEM: //선화수
        begin
          IncHealthSpell(std.AC{+hp}, std.MAC{+mp});
          IncHealthSpell(WAbil.MaxHP * std.DC div 100{+hp%},
            WAbil.MaxMP * std.MC div 100{+mp%});
          // 체력,마력 %향상 추가(sonmg 2005/03/09)
          Result := True;
        end;
        FREE_UNKNOWN_ITEM: //미지의아이템을 장착해제 시킴
        begin
          BoNextTimeFreeCurseItem := True;
          Result := True;
        end;
        else begin
          // 500 -> 1000  2003-11-3 :PDS
          if (IncHealth + std.AC < 1000) and (std.AC > 0) then begin
            IncHealth := IncHealth + std.AC;
          end;
          // 500 -> 1000
          if (IncSpell + std.MAC < 1000) and (std.MAC > 0) then begin
            IncSpell := IncSpell + std.MAC;
          end;

          Result := True;
        end;
      end;
    end;
    1: //고기류
    begin
      Result := True;
    end;
    2: //식당 음식
    begin
      case std.Shape of
        SHAPE_BUNCH_OF_FLOWERS: begin
          SendRefMsg(RM_LOOPNORMALEFFECT, integer(self),
            10000, 0, NE_FLOWERSEFFECT, '');
        end;
      end;

      Result := True;
    end;
    3: //스크롤 류
    begin
      case std.Shape of
        INSTANTABILUP_DRUG:
              //능력치 상승 지속시간 분단위 추가(DCMAX) (sonmg 2005/01/13)
        begin //12, 순간적으로 능력치를 상승시키는 물약
          boneedrecalc := False;
          if lobyte(std.DC) > 0 then begin  //파괴 상승 물약
            ExtraAbil[EABIL_DCUP]      := lobyte(std.DC);
            ExtraAbilFlag[EABIL_DCUP]  := 0;
            ExtraAbilTimes[EABIL_DCUP] :=
              GetTickCount + HIBYTE(std.DC) * 60 * 1000{분단위} + hibyte(std.MAC) * 1000;
            //초단위
            //                        SysMsg ('Temporarily destructive power increased during ' + IntToStr(hibyte(std.MAC)) + 'seconds', 1);
            SysMsg('Temporarily destructive power increased during ' +
              IntToStr(HIBYTE(std.DC) + hibyte(std.MAC) div 60) +
              'min. ' + IntToStr(hibyte(std.MAC) mod 60) + 'sec.', 1);
            boneedrecalc := True;
          end;
          if lobyte(std.MC) > 0 then begin  //마력 상승 물약
            ExtraAbil[EABIL_MCUP]      := lobyte(std.MC);
            ExtraAbilFlag[EABIL_MCUP]  := 0;
            ExtraAbilTimes[EABIL_MCUP] :=
              GetTickCount + HIBYTE(std.DC) * 60 * 1000{분단위} + hibyte(std.MAC) * 1000;
            //초단위
            //                        SysMsg ('Temporarily magic power increased during ' + IntToStr(hibyte(std.MAC)) + 'seconds', 1);
            SysMsg('Temporarily magic power increased during ' +
              IntToStr(HIBYTE(std.DC) + hibyte(std.MAC) div 60) +
              'min. ' + IntToStr(hibyte(std.MAC) mod 60) + 'sec.', 1);
            boneedrecalc := True;
          end;
          if lobyte(std.SC) > 0 then begin  //도력 상승 물약
            ExtraAbil[EABIL_SCUP]      := lobyte(std.SC);
            ExtraAbilFlag[EABIL_SCUP]  := 0;
            ExtraAbilTimes[EABIL_SCUP] :=
              GetTickCount + HIBYTE(std.DC) * 60 * 1000{분단위} + hibyte(std.MAC) * 1000;
            //초단위
            //                        SysMsg ('Temporarily zen power increased during ' + IntToStr(hibyte(std.MAC)) + 'seconds', 1);
            SysMsg('Temporarily zen power increased during ' +
              IntToStr(HIBYTE(std.DC) + hibyte(std.MAC) div 60) +
              'min. ' + IntToStr(hibyte(std.MAC) mod 60) + 'sec.', 1);
            boneedrecalc := True;
          end;
          if hibyte(std.AC) > 0 then begin  //공격속도 상승 물약
            ExtraAbil[EABIL_HITSPEEDUP]      := hibyte(std.AC);
            ExtraAbilFlag[EABIL_HITSPEEDUP]  := 0;
            ExtraAbilTimes[EABIL_HITSPEEDUP] :=
              GetTickCount + HIBYTE(std.DC) * 60 * 1000{분단위} + hibyte(std.MAC) * 1000;
            //초단위
            //                        SysMsg ('Temporarily hitting speed increased during ' + IntToStr(hibyte(std.MAC)) + 'seconds', 1);
            SysMsg('Temporarily hitting speed increased during ' +
              IntToStr(HIBYTE(std.DC) + hibyte(std.MAC) div 60) +
              'min. ' + IntToStr(hibyte(std.MAC) mod 60) + 'sec.', 1);
            boneedrecalc := True;
          end;
          if lobyte(std.AC) > 0 then begin  //체력 상승 물약
            ExtraAbil[EABIL_HPUP]      := lobyte(std.AC);
            ExtraAbilFlag[EABIL_HPUP]  := 0;
            ExtraAbilTimes[EABIL_HPUP] :=
              GetTickCount + HIBYTE(std.DC) * 60 * 1000{분단위} + hibyte(std.MAC) * 1000;
            //초단위
            //                        SysMsg ('Temporarily HP increased during ' + IntToStr(hibyte(std.MAC)) + 'seconds', 1);
            SysMsg('Temporarily HP increased during ' +
              IntToStr(HIBYTE(std.DC) + hibyte(std.MAC) div 60) +
              'min. ' + IntToStr(hibyte(std.MAC) mod 60) + 'sec.', 1);
            boneedrecalc := True;
          end;
          if lobyte(std.MAC) > 0 then begin  //마력 상승 물약
            ExtraAbil[EABIL_MPUP]      := lobyte(std.MAC);
            ExtraAbilFlag[EABIL_MPUP]  := 0;
            ExtraAbilTimes[EABIL_MPUP] :=
              GetTickCount + HIBYTE(std.DC) * 60 * 1000{분단위} + hibyte(std.MAC) * 1000;
            //초단위
            //                        SysMsg ('Temporarily MP increased during ' + IntToStr(hibyte(std.MAC)) + 'seconds', 1);
            SysMsg('Temporarily MP increased during ' +
              IntToStr(HIBYTE(std.DC) + hibyte(std.MAC) div 60) +
              'min. ' + IntToStr(hibyte(std.MAC) mod 60) + 'sec.', 1);
            boneedrecalc := True;
          end;
          if boneedrecalc then begin
            RecalcAbilitys;
            SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
          end;
          Result := True;
        end;
        INSTANT_EXP_DRUG: begin
          WinExp(lobyte(std.AC) * 100);
          Result := True;
        end;
        SHAPE_COUPLE_ALIVE_STONE:  //연인부활석
        begin
          flag := False;
          //고급커플반지 착용 체크
          for i := 0 to 12 do begin
            pstd := UserEngine.GetStdItem(UseItems[i].Index);
            if pstd <> nil then begin
              if (pstd.StdMode = 22) and
                (pstd.Shape = SHAPE_ADV_COUPLERING) then begin
                flag := True;
                break;
              end;
            end;
          end;
          if flag then begin
            flag := False;
            //교제일 365일 이상 체크
            hum  := TUserHuman(self);
            if hum <> nil then begin
              //MainOutMessage('GetLoverDays(1) : ' + hum.fLover.GetLoverDays);
              if Str_ToInt(hum.fLover.GetLoverDays, 0) >= 365 then begin
                flag := True;
              end;
            end;
          end;
          if flag then begin
            flag := False;
            //연인과 1칸 옆에 있는지 체크
            hum  := TUserHuman(self);
            if hum <> nil then begin
              humlover := UserEngine.GetUserHuman(hum.fLover.GetLoverName);
              if humlover <> nil then begin
                if (Abs(hum.CX - humlover.CX) <= 1) and
                  (Abs(hum.CY - humlover.CY) <= 1) then begin
                  //모든 조건이 충족되면 죽은 연인 부활
                  if humlover.Death then begin
                    //연인의 체력 10% 보충
                    humlover.WAbil.HP := humlover.WAbil.MaxHP div 10;
                    humlover.Alive;
                    //자신의 체력 마력 90% 감소
                    hum.WAbil.HP := hum.WAbil.HP div 10;
                    hum.WAbil.MP := hum.WAbil.MP div 10;
                    Result := True;
                  end;
                end;
              end;
            end;
          end;
        end;
        else
          Result := UseScroll(std.Shape);
      end;
    end;
    8: //사용 아이템
    begin
      case std.Shape of
        SHAPE_OF_INVITATION: begin
          //초대장 기능 구현(sonmg).
          // 기간이 만료되었으면 이동하지 않음.
          // 기간이 유효하면 초대장에 써있는 장원 번호로 이동
          if RaceServer = RC_USERHUMAN then begin
            hum := TUserHuman(self);

            // 만료기간 체크
            if hum.GuildAgitInvitationTimeOutCheck(pu) then begin
              hum.CmdGuildAgitFreeMove(pu.Dura);
              // 해당번호의 장원으로 이동.
            end else begin
              hum.SysMsg('This item is expired.', 0);
            end;

            Result := True;
          end;
        end;
        SHAPE_OF_TELEPORTTAG:   //왕방 이동 마패
        begin
          UserSpaceMove(std.Reference, IntToStr(std.HpAdd),
            IntToStr(std.MpAdd));
          Result := True;
        end;
        SHAPE_OF_GIFTBOX: begin
          if IsEnoughBag then begin
            GetGiftFromBox;   //선물상자
            Result := True;
          end;
        end;
        SHAPE_OF_EASTEREGG: begin
          if IsEnoughBag then begin
            GetGiftFromEgg;   //부활절 달걀
            Result := True;
          end;
        end;
      end;
    end;
  end;
end;

function TCreature.IsMyMagic(magid: integer): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to MagicList.Count - 1 do begin
    if PTUserMagic(MagicList[i]).MagicId = magid then begin
      Result := True;
      break;
    end;
  end;
end;

function TCreature.ReadBook(std: TStdItem): boolean;
var
  pdm: PTDefMagic;
  pum: PTUserMagic;
  hum: TUserHuman;
begin
  Result := False;
  pdm    := UserEngine.GetDefMagic(std.Name);
  if pdm <> nil then begin
    if not IsMyMagic(pdm.MagicId) then begin
      if ((pdm.Job = 99) or (pdm.Job = Job)) and (Abil.Level >= pdm.NeedLevel[0]) then
      begin
        new(pum);
        pum.pDef     := pdm;
        pum.MagicId  := pdm.MagicId;
        pum.Key      := #0;
        pum.Level    := 0;
        pum.CurTrain := 0;
        MagicList.Add(pum);   //마법을 새로 배움..
        RecalcAbilitys;
        if RaceServer = RC_USERHUMAN then begin
          hum := TUserHuman(self);
          hum.SendAddMagic(pum);    //마법 추가를 클라이언트에 알림
        end;
        Result := True;
      end;
    end;
  end;
end;

function TCreature.GetSpellPoint(pum: PTUserMagic): integer;
begin
  //클라이언트와 일치시켜야 함(sonmg)
  Result := Round(pum.pDef.Spell / (pum.pDef.MaxTrainLevel + 1) * (pum.Level + 1)) +
    pum.pDef.DefSpell;
end;

//타겟의 적절함은 미리 검증해야함.
function TCreature.DoSpell(pum: PTUserMagic; xx, yy: integer;
  target: TCreature): boolean;
var
  spell: integer;
begin
  Result := False;
  if MagicMan.IsSwordSkill(pum.MagicId) then
    exit;

  //필요 Spell이 충분한가?
  spell := GetSpellPoint(pum);
  if (spell > 0) then begin
    if (WAbil.MP >= spell) then begin
      DamageSpell(spell);
      if pum.MagicId <> 42 then // 분신술이 아니면 전송
        HealthSpellChanged;
    end else
      exit;  //마력이 부족함.
  end;

  Result := MagicMan.SpellNow(self, pum, xx, yy, target, spell);

  if pum.MagicId = 42 then // 분신술이면 전송
  begin
    HealthSpellChanged;
  end;

end;


{------------------------------ 마법 효과 -----------------------------}

 //시작위치에서 다음 위치까지의 적에게 타격을 입힌다.
 //Result: 맞은 마리수
function TCreature.MagPassThroughMagic(sx, sy, tx, ty, ndir, magpwr: integer;
  undeadattack: boolean): integer;
var
  i, tcount, acpwr: integer;
  cret: TCreature;
begin
  tcount := 0;
  for i := 0 to 12 do begin
    cret := TCreature(PEnvir.GetCreature(sx, sy, True));
    if cret <> nil then begin
      //if (RaceServer = RC_USERHUMAN) and (cret.RaceServer = RC_USERHUMAN) and ((cret.InSafeZone) or (InSafeZone)) then
      //   continue;  //안전지대
      if IsProperTarget(cret) then begin
        if cret.AntiMagic <= Random(50) then begin  //마법 회피가 있음
          if undeadattack then  //언데드 몬스터에게 공격력 강화인 경우
            acpwr := Round(magpwr * 1.5)
          else
            acpwr := magpwr;
          cret.SendDelayMsg(self, RM_MAGSTRUCK, 0, acpwr, 0, 0, '', 600);
          Inc(tcount);
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
  Result := tcount;
end;

function TCreature.MagCanHitTarget(sx, sy: integer; target: TCreature): boolean;
var
  i, ndir, dis, olddis: integer;
begin
  Result := False;
  if target <> nil then begin
    olddis := (abs(sx - Target.CX) + abs(sy - Target.CY));
    for i := 0 to 12 do begin
      ndir := GetNextDirection(sx, sy, target.CX, target.CY);
      if not GetNextPosition(PEnvir, sx, sy, ndir, 1, sx, sy) then
        break;
      if not PEnvir.CanFireFly(sx, sy) then
        break;
      if (sx = target.CX) and (sy = target.CY) then begin
        Result := True;
        break;
      end;
      dis := (abs(sx - Target.CX) + abs(sy - Target.CY));
      if dis > olddis then begin
        Result := True;
        break;
      end;
      dis := olddis;
    end;
  end;
end;

function TCreature.MagDefenceUp(sec, Value: integer): boolean;  //걸리는 시간
begin
  Result := False;
  if StatusArr[STATE_DEFENCEUP] > 0 then begin
    if sec > StatusArr[STATE_DEFENCEUP] then begin
      StatusArr[STATE_DEFENCEUP] := sec;
      Result := True;
    end;
  end else begin
    StatusArr[STATE_DEFENCEUP] := sec;
    Result := True;
  end;
  StatusTimes[STATE_DEFENCEUP] := GetTickCount;
  StatusValue[STATE_DEFENCEUP] := _MIN(255, Value);
  SysMsg('Defense strength increases ' + IntToStr(sec) + ' seconds', 1);
  RecalcAbilitys;
  SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
end;

function TCreature.MagHitSpeedUp(sec, Value: integer): boolean;  //Assassin Skill 3
begin
  Result := False;
  if StatusArr[STATE_HITSPEEDUP] > 0 then begin
    if sec > StatusArr[STATE_HITSPEEDUP] then begin
      StatusArr[STATE_HITSPEEDUP] := sec;
      Result := True;
    end;
  end else begin
    StatusArr[STATE_HITSPEEDUP] := sec;
    Result := True;
  end;
  StatusTimes[STATE_HITSPEEDUP] := GetTickCount;
  StatusValue[STATE_HITSPEEDUP] := _MIN(255, Value);
  SysMsg('Temporarily hitting speed increased during ' + IntToStr(sec) + ' seconds', 1);
  RecalcAbilitys;
  SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
end;

function TCreature.MagMagDefenceUp(sec, Value: integer): boolean;  //걸리는 시간
begin
  Result := False;
  if StatusArr[STATE_MAGDEFENCEUP] > 0 then begin
    if sec > StatusArr[STATE_MAGDEFENCEUP] then begin
      StatusArr[STATE_MAGDEFENCEUP] := sec;
      Result := True;
    end;
  end else begin
    StatusArr[STATE_MAGDEFENCEUP] := sec;
    Result := True;
  end;
  StatusTimes[STATE_MAGDEFENCEUP] := GetTickCount;
  StatusValue[STATE_MAGDEFENCEUP] := _MIN(255, Value);
  SysMsg('Magical defense strength increases ' + IntToStr(sec) + ' seconds', 1);
  RecalcAbilitys;
  SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
end;

function TCreature.MagBubbleDefenceUp(mlevel, sec: integer): boolean;
var
  old: integer;
begin
  Result := False;
  if StatusArr[STATE_BUBBLEDEFENCEUP] = 0 then begin
    old := CharStatus;
    StatusArr[STATE_BUBBLEDEFENCEUP] := sec;
    StatusTimes[STATE_BUBBLEDEFENCEUP] := GetTickCount;
    CharStatus := GetCharStatus;
    if old <> CharStatus then
      CharStatusChanged;
    BoAbilMagBubbleDefence := True;
    MagBubbleDefenceLevel := mlevel;
    Result := True;
  end;
end;

procedure TCreature.DamageBubbleDefence;
begin
  if StatusArr[STATE_BUBBLEDEFENCEUP] > 0 then begin
    if StatusArr[STATE_BUBBLEDEFENCEUP] > 3 then
      StatusArr[STATE_BUBBLEDEFENCEUP] := StatusArr[STATE_BUBBLEDEFENCEUP] - 3
    else
      StatusArr[STATE_BUBBLEDEFENCEUP] := 1;
  end;
end;


 //주변에 사람들의 방어력 및 마법 방어력을 일시적으로 올려준다.
 //Result: 걸린 수
 //BoMag: TRUE(마법방어), FALSE(방어)
function TCreature.MagMakeDefenceArea(xx, yy, range, sec: integer;
  BoMag: boolean): integer;
var
  i, j, k, stx, sty, enx, eny, tcount: integer;
  pm:      PTMapInfo;
  inrange: boolean;
  cret:    TCreature;
begin
  tcount := 0;
  stx    := xx - range;
  enx    := xx + range;
  sty    := yy - range;
  eny    := yy + range;
  for i := stx to enx do begin
    for j := sty to eny do begin
      inrange := PEnvir.GetMapXY(i, j, pm);
      if inrange then
        if pm.ObjList <> nil then begin
          for k := 0 to pm.ObjList.Count - 1 do begin
            if PTAThing(pm.ObjList[k]).Shape = OS_MOVINGOBJECT then begin
              cret := TCreature(PTAThing(pm.ObjList[k]).AObject);
              if cret <> nil then begin
                if (not cret.BoGhost) then begin
                  if IsProperFriend(cret) then begin
                    if not BoMag then
                      cret.MagDefenceUp(sec, (LOBYTE(WAbil.SC) div 9) +
                        Random(HIBYTE(WAbil.SC) div 9))
                    else
                      cret.MagMagDefenceUp(sec, (LOBYTE(WAbil.SC) div 9) +
                        Random(HIBYTE(WAbil.SC) div 9));
                    Inc(tcount);
                  end;
                end;
              end;
            end;
          end;
        end;
    end;
  end;
  Result := tcount;
end;

function TCreature.MagMakePoisonArea(xx, yy, range, pwr, sec: integer;
  BoMag: boolean): integer;
var
  i, j, k, stx, sty, enx, eny, tcount: integer;
  pm:      PTMapInfo;
  inrange: boolean;
  cret:    TCreature;
  bhasitem: integer;
  bujuckcount: integer;
  pstd:     PTStdItem;
begin
  tcount := 0;
  stx    := xx - range;
  enx    := xx + range;
  sty    := yy - range;
  eny    := yy + range;
  for i := stx to enx do begin
    for j := sty to eny do begin
      inrange := PEnvir.GetMapXY(i, j, pm);
      if inrange then
        if pm.ObjList <> nil then begin
          for k := 0 to pm.ObjList.Count - 1 do begin
            if PTAThing(pm.ObjList[k]).Shape = OS_MOVINGOBJECT then begin
              cret := TCreature(PTAThing(pm.ObjList[k]).AObject);
              if cret <> nil then begin
                if (not cret.BoGhost) then begin
                  if IsProperTarget(cret) then begin
                    if not BoMag then
                cret.MagMakePoison(sec, pwr, cret)
                   else
                cret.MagMakePoison(sec, pwr, cret);
                Inc(tcount);
    end;
    end;
  end;
  end;
  end;
  end;
  end;
  end;
  Result := tcount;
end;

function TCreature.MagMakeCurseArea(xx, yy, range, sec, pwr, skilllevel: integer;
  BoMag: boolean): integer;
var
  i, j, k, stx, sty, enx, eny, tcount: integer;
  pm:      PTMapInfo;
  inrange: boolean;
  cret:    TCreature;
  isNormalAttack: boolean;
  isAttack: boolean;
  targetsec: integer;
begin
  tcount := 0;
  stx    := xx - range;
  enx    := xx + range;
  sty    := yy - range;
  eny    := yy + range;
  for i := stx to enx do begin
    for j := sty to eny do begin
      inrange := PEnvir.GetMapXY(i, j, pm);
      if inrange then
        if pm.ObjList <> nil then begin
          for k := 0 to pm.ObjList.Count - 1 do begin
            if PTAThing(pm.ObjList[k]).Shape = OS_MOVINGOBJECT then begin
              cret := TCreature(PTAThing(pm.ObjList[k]).AObject);
              if cret <> nil then begin
                if (not cret.BoGhost) and (not cret.Death) then begin
                  if IsProperTarget(cret) then begin
                    // 확률계산하구
                    isNormalAttack := True;
                    targetsec      := sec;
                    if cret.RaceServer = RC_USERHUMAN then begin
                      isNormalAttack := False;
                      //중독 회복
                      targetsec      := (sec div 6) - cret.PoisonRecover;
                    end else begin
                      if cret.Abil.Level >= 60 then begin
                        isNormalAttack := False;
                        targetsec      := (sec div 4);
                      end;
                    end;

                    // 일반몹확률: Random(70)<14+(skill_level+1)*5+lvgap
                    //  60레벨이상&유저확률: Random(40)<14+(skill_level+1)*5+lvgap
                    isAttack := False;
                    // AntiPoison := ;
                    if isNormalAttack then begin
                      if (Random(80) <
                        (14 + (skilllevel + 1) * 3 +
                        (integer(Abil.Level) - integer(cret.Abil.level)))) then
                        isAttack := True;
                    end else begin
                      if (Random(90 + (cret.AntiPoison * 2)) <
                        (14 + (skilllevel + 1) * 3 +
                        (integer(Abil.level) - integer(cret.Abil.Level)))) then
                        isAttack := True;
                    end;

                    if isAttack and (targetsec > 0) then begin
                      cret.SendDelayMsg(self, RM_CURSE,
                        targetsec, pwr, 0, 0, '', 1200);
                      cret.SendDelayMsg(cret, RM_STRUCK,
                        1, WAbil.HP, WAbil.MP, integer(self), '', 1200);

                      //cret.MagCurse (sec , pwr);
                      Inc(tcount);
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
    end;
  end;
  Result := tcount;
end;

//2003/03/15 신규무공 추가
function TCreature.MagDcUp(sec, pwr: integer): boolean;
var
  i, UpDC: integer;
  cret:    TCreature;
begin
  UpDC := pwr;//((Hibyte(WAbil.SC)-1) div 5) + 1;
  //if(UpDC > 8) then UpDC := 8;
{
   if      (WAbil.SC) <=  5 then UpDC := 1
   else if (WAbil.SC) <= 10 then UpDC := 2
   else if (WAbil.SC) <= 15 then UpDC := 3
   else if (WAbil.SC) <= 20 then UpDC := 4
   else if (WAbil.SC) <= 25 then UpDC := 5
   else if (WAbil.SC) <= 30 then UpDC := 6
   else if (WAbil.SC) <= 35 then UpDC := 7
   else                          UpDC := 8;
}
  ExtraAbil[EABIL_DCUP] := _MIN(255, _MAX(ExtraAbil[EABIL_DCUP], UpDC));
  ExtraAbilFlag[EABIL_DCUP] := 0;
  ExtraAbilTimes[EABIL_DCUP] :=
    _MAX(ExtraAbilTimes[EABIL_DCUP], GetTickCount + longword(sec * 1000)); //초단위
  if KOREANVERSION then begin
    SysMsg('파괴력 상승 ' + IntToStr(
      (ExtraAbilTimes[EABIL_DCUP] - GetTickCount) div 1000 div 60) +
      '분 ' + IntToStr((ExtraAbilTimes[EABIL_DCUP] - GetTickCount) div
      1000 mod 60) + '초', 1);
  end else begin
    SysMsg('Physical Attack Power Increased for ' + IntToStr(
      (ExtraAbilTimes[EABIL_DCUP] - GetTickCount) div 1000 div 60) +
      'min. ' + IntToStr((ExtraAbilTimes[EABIL_DCUP] - GetTickCount) div 1000 mod 60) +
      'sec.', 1);
  end;
  RecalcAbilitys;
  SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');

  if SlaveList.Count >= 1 then begin
    for i := 0 to SlaveList.Count - 1 do begin
      cret := TCreature(SlaveList[i]);
      if (cret <> nil) then begin
        cret.ExtraAbil[EABIL_DCUP]      := UpDC;
        cret.ExtraAbilFlag[EABIL_DCUP]  := 0;
        cret.ExtraAbilTimes[EABIL_DCUP] := GetTickCount + longword(sec * 1000);
        //초단위
        cret.ExtraAbil[EABIL_MCUP]      := UpDC;
        cret.ExtraAbilFlag[EABIL_MCUP]  := 0;
        cret.ExtraAbilTimes[EABIL_MCUP] := GetTickCount + longword(sec * 1000);
        //초단위
        cret.RecalcAbilitys;
      end;
    end;
  end;

  Result := True;
end;

function TCreature.MagMakePoison(sec, pwr: integer; cret: TCreature): boolean;
begin
cret.SendDelayMsg(self, RM_MAKEPOISON,
POISON_DECHEALTH{wparam}, sec, integer(self), pwr, '', 1000);
end;

procedure TCreature.MagCurse(sec, pwrrate: integer);
begin

  MakePoison(POISON_SLOW, sec, 1);

  if ExtraAbilTimes[EABIL_PWRRATE] < (GetTickCount + longword(sec * 1000)) then begin

    ExtraAbil[EABIL_PWRRATE]      := pwrrate;
    ExtraAbilTimes[EABIL_PWRRATE] := GetTickCount + longword(sec * 1000); //초단위

    if pwrrate < 100 then
      SysMsg('Attack Ability ' + IntToStr(100 - pwrrate) + '% decreased ' +
        IntToStr(sec) + 'Secs', 1)
    else
      SysMsg('Attack Ability ' + IntToStr(pwrrate - 100) + '% increased ' +
        IntToStr(sec) + 'Secs', 1);

    RecalcAbilitys;
    SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');

  end;

end;

function TCreature.CheckMagicLevelup(pum: PTUserMagic): boolean;
var
  lv: integer;
begin
  Result := False;
  if (pum.Level in [0..3]) and (pum.Level <= pum.pDef.MaxTrainLevel) then
    lv := pum.Level
  else
    lv := 0;

  if pum.Level < pum.pDef.MaxTrainLevel then begin
    if pum.CurTrain >= pum.pDef.MaxTrain[lv] then begin
      if pum.Level < pum.pDef.MaxTrainLevel then begin //레벨 올려야함.
        pum.CurTrain := pum.CurTrain - pum.pDef.MaxTrain[lv];
        pum.Level    := pum.Level + 1;
        UpdateDelayMsgCheckParam1(self, RM_MAGIC_LVEXP, 0,
          pum.pDef.MagicId, pum.Level, pum.CurTrain, '', 800);
        CheckMagicSpecialAbility(pum);
      end else begin //다 올렸음
        pum.CurTrain := pum.pDef.MaxTrain[lv];
      end;
      Result := True;
    end;
  end;
end;

procedure TCreature.CheckMagicSpecialAbility(pum: PTUserMagic);
begin
  if pum.pDef.MagicId = 28 then begin //탐기파연
    if pum.Level >= 2 then begin
      //탐기파연 2단계 이상 수련했을 경우
      BoAbilSeeHealGauge := True;
    end;
  end;
end;

function TCreature.GetDailyQuest: integer;
  //현재 받고 있는 일일퀘스트 값을 얻어 온다. 지났거나, 없으면 0
var
  ayear, amon, aday: word;
  calcdate: word;
begin
  DecodeDate(Date, ayear, amon, aday);
  calcdate := amon * 31 + aday;
  if (DailyQuestNumber = 0) or (DailyQuestGetDate <> calcdate) then
    Result := 0
  else
    Result := DailyQuestNumber;
end;

procedure TCreature.SetDailyQuest(qnumber: integer);  //새로히 일일퀘스트를 설정한다.
var
  ayear, amon, aday: word;
begin
  DecodeDate(Date, ayear, amon, aday);
  DailyQuestNumber  := qnumber;
  DailyQuestGetDate := amon * 31 + aday;
end;



{%%%%%%%%%%%%%%%%%%% *RunMsg* %%%%%%%%%%%%%%%%%%%%}

procedure TCreature.RunMsg(msg: TMessageInfo);
var
  str:  string;
  n, v1, v2, magx, magy, magpwr, range: integer;
  hiter, target: TCreature;
  test: integer;
begin
  test := 0;
  case msg.Ident of
    RM_REFMESSAGE: begin
      with msg do
        SendRefMsg(integer(Sender), wParam, lParam1, lParam2,
          lParam3, Description);
      if integer(msg.Sender) = RM_STRUCK then
        if RaceServer <> RC_USERHUMAN then begin
          with msg do
            SendMsg(self, integer(msg.Sender), wParam,
              lParam1, lParam2, lParam3, Description);
        end;
    end;
    RM_DELAYMAGIC: begin
      magpwr := msg.wParam;
      magx   := Loword(msg.lparam1);
      magy   := Hiword(msg.lparam1);
      range  := msg.lparam2;
      target := TCreature(msg.lparam3);
      if target <> nil then begin
        // 화룡일때는 스트럭트를 먹게 하자.
        if (Target.RaceServer = RC_FIREDRAGON) or
          (Target.RaceServer = RC_DRAGONBODY) then begin
          if (ABS(self.CX - target.CX) <= 8) and
            (ABS(self.CY - target.CY) <= 8) then begin
            target.SendMsg(self, RM_DRAGON_EXP, 0, random(3) + 1, 0, 0, '');
          end;
        end;

        n := target.GetMagStruckDamage(self, magpwr);
        //마항력을 적용했을때의 데미지로 검사
        if n > 0 then begin
          //                  SelectTarget (target);  //RM_DELAYMAGIC에서 RM_MAGSTRUCK으로 옮김(sonmg 2004/08/25)
          if target.RaceServer >= RC_ANIMAL then begin
            magpwr := Round(magpwr * 1.2);
            //동물(몬스터)인경우 마법 타격력이 120%
          end;
          if (abs(magx - target.CX) <= range) and
            (abs(magy - target.CY) <= range) then
            target.SendMsg(self, RM_MAGSTRUCK, 0, magpwr, 0, 0, '');
        end;
      end;
    end;
    RM_MAGSTRUCK,
    RM_MAGSTRUCK_MINE: begin
      //나의 마방 적용
      if (msg.Ident = RM_MAGSTRUCK) and (RaceServer >= RC_ANIMAL) and
        (not RushMode) then begin
        //마법으로 공격당하면 이동에 지연을 받는다.
        //2003/02/11 최대래밸 적용
        if Abil.Level < MAXKINGLEVEL - 1 then     //50
          WalkTime := WalkTime + 800 + Random(1000);
      end;

      //v1 := Lobyte(WAbil.MAC) + Random(ShortInt(Hibyte(WAbil.MAC)-Lobyte(WAbil.MAC)) + 1);
      //v1 := _MAX(msg.lparam1 - v1, 0);
      //if msg.Ident = RM_MAGSTRUCK_MINE then  //방어가 적용 안된경우
      v1 := GetMagStruckDamage(nil, msg.lparam1);

      if v1 > 0 then begin
        target := TCreature(msg.Sender);
        SelectTarget(target);
        //RM_DELAYMAGIC에서 RM_MAGSTRUCK으로 옮김(sonmg 2004/08/25)
        StruckDamage(v1);
        HealthSpellChanged;
        SendRefMsg(RM_STRUCK_MAG, v1, WAbil.HP, WAbil.MP,
          integer(msg.Sender), '');
        if RaceServer <> RC_USERHUMAN then begin
          if BoAnimal then begin //고기가 나오는 동물인 경우..
            MeatQuality := MeatQuality - v1 * 1000;
            //마법을 맞으면 고기질이 치명적으로 나빠진다.
          end;
          SendMsg(self, RM_STRUCK, v1, WAbil.HP, WAbil.MP,
            integer(msg.Sender), '');
        end;
      end;
    end;
    RM_MAGHEALING: begin
      if IncHealing + msg.lparam1 < 300 then begin
        if RaceServer = RC_USERHUMAN then begin
          IncHealing := IncHealing + msg.lparam1;
          PerHealing := 5;
        end else begin
          IncHealing := IncHealing + msg.lparam1;
          ///IncHealing := IncHealing + msg.lparam1 div 2;
          PerHealing := 5;
        end;
      end else
        IncHealing := 300;
      //v1 := msg.lparam1;
      //DamageHealth (-v1);
      //HealthSpellChanged;
    end;
    RM_MAKEPOISON: begin
      hiter := TCreature(msg.lparam2);
      test  := 1;
      if hiter <> nil then begin
        test := 2;
        if IsProperTarget(hiter) then begin
          test := 3;
          SelectTarget(hiter);
{
                  if (RaceServer = RC_USERHUMAN) and (hiter.RaceServer = RC_USERHUMAN) then begin
                     test := 4;
                     //정당방어를 위한 기록..
                     AddPkHiter (hiter);
                     SetLastHiter (hiter);
                     //testcode(녹독로그)
                     MainOutMessage('[TestCode1]갈피 : ' + UserName + ', Hiter : ' + hiter.UserName);
                  end else begin
}
          // 2003/06/12 왕급인 경우 녹독/적독으로 죽더라도 경험치를 주지 않는다...
          if Abil.Level < 60 then
            SetLastHiter(hiter);
          //                  end;
        end;
        if (RaceServer = RC_USERHUMAN) and (hiter.RaceServer = RC_USERHUMAN) then
        begin
          test := 5;
          //정당방어를 위한 기록..
          AddPkHiter(hiter);
          SetLastHiter(hiter);
        end else if (Master <> nil) then begin
          //중독된 소환몹의 주인이 때린사람이 아니면
          if Master <> hiter then begin
            //정당방어를 위한 기록..
            AddPkHiter(hiter);
            SetLastHiter(hiter);
          end;
        end;
        //중독
        MakePoison(msg.wparam{poison id}, msg.lparam1{time},
          msg.lparam3{poison level}); //POISON_DECHEALTH, 60);
      end else begin
        MakePoison(msg.wparam{poison id}, msg.lparam1{time},
          msg.lparam3{poison level}); //POISON_DECHEALTH, 60);
      end;
    end;
    RM_DOOPENHEALTH: begin
      MakeOpenHealth;
    end;
    RM_TRANSPARENT: begin
      MagicMan.MagMakePrivateTransparent(self, msg.lparam1);
    end;
    RM_RANDOMSPACEMOVE: begin
      RandomSpaceMove(msg.Description, msg.wParam);
    end;
    // 2003/04/01 A/I 변경
    RM_DECREFOBJCOUNT: begin
      DecRefObjCount;
    end;
    RM_DRAGON_EXP: begin
      if gFireDragon <> nil then begin
        gFireDragon.ChangeExp(msg.lParam1);
      end;
    end;
    RM_CURSE: begin
      MagCurse(msg.wParam, msg.lparam1);
    end;

  end;
end;

procedure TCreature.UseLamp;
var
  old, dura: integer;
  hum: TUserHuman;
begin
  try
    if UseItems[U_RIGHTHAND].Index > 0 then begin
      old  := Round(UseItems[U_RIGHTHAND].Dura / 1000);
      // 2003/03/04 0.5초에서 1초로 바뀜에 따라 내구를 -1에서 -2로 조정
      dura := integer(UseItems[U_RIGHTHAND].Dura) - 2;   //1;
      if dura <= 0 then begin
        UseItems[U_RIGHTHAND].Dura := 0;
        //초가 사라진다.
        if RaceServer = RC_USERHUMAN then begin
          hum := TUserHuman(self);
          hum.SendDelItem(UseItems[U_RIGHTHAND]); //클라이언트에 없어진거 보냄
        end;
        UseItems[U_RIGHTHAND].Index := 0;

        Light := GetMyLight;
        SendRefMsg(RM_CHANGELIGHT, 0, 0, 0, 0, '');
        SendMsg(self, RM_LAMPCHANGEDURA, 0, UseItems[U_RIGHTHAND].Dura, 0, 0, '');
      end else
        UseItems[U_RIGHTHAND].Dura := dura;
      if old <> Round(dura / 1000) then begin
        //내구성이 변함
        SendMsg(self, RM_LAMPCHANGEDURA, 0, UseItems[U_RIGHTHAND].Dura, 0, 0, '');
      end;
    end;
  except
    MainOutMessage('[Exception] TCreature.UseLamp');
  end;
end;

{%%%%%%%%%%%%%%%%%%%%% *Run* %%%%%%%%%%%%%%%%%%%%%}

procedure TCreature.Run;
var
  msg: TMessageInfo;
  i, n, hp, mp, ablmask, plus, waittime: integer;
  inchstime: longword;
  cret, lhiter, lmaster: TCreature;
  chg, needrecalc: boolean;
  test, identbackup: integer;
  bcheckDeath: boolean;
  DuringIllegalTime: longword;
begin
  test := 0;
  IdentBackup := 0;
  try
    {extract message to behavior and so ..}
    while GetMsg(msg) do begin
      IdentBackup := msg.Ident;
      RunMsg(msg);
    end;
  except
    MainOutMessage('[Exception] TCreature.Run 0 : ' + IntToStr(IdentBackup) +
      ':' + IntToStr(msg.Ident));
  end;

  try
    test := 1;
    if NeverDie then begin
      WAbil.HP := WAbil.MaxHP; //절대로 죽지 않음.  NPC
      WAbil.MP := WAbil.MaxMP;
    end;

    test := 2;

    n := (GetTickCount - ticksec) div 20;  //초당 50

    ticksec := GetTickCount;
    Inc(HealthTick, n);
    Inc(SpellTick, n);

    test := 4;
    if not Death then begin
      if WAbil.HP < WAbil.MaxHP then begin
        if HealthTick >= HEALTHFILLTICK then begin
          plus := WAbil.MaxHP div 75 + 1;  //plus := WAbil.MaxHP div 15 + 1;
          // HealthRecover 적용(sonmg 2004/02/20)
          plus := plus + ((plus * HealthRecover) div 10);
          if WAbil.HP + plus < WAbil.MaxHP then
            WAbil.HP := WAbil.HP + plus
          else
            WAbil.HP := WAbil.MaxHP;
          //UpdateMsg (self, RM_HEALTHSPELLCHANGED, 0, 0, 0, 0, '');
          HealthSpellChanged;
        end;
      end;
      test := 5;

      if WAbil.MP < WAbil.MaxMP then begin
        if SpellTick >= SPELLFILLTICK then begin
          plus := WAbil.MaxMP div 18 + 1;
          // SpellRecover 적용(sonmg 2004/02/20)
          plus := plus + ((plus * SpellRecover) div 10);
          if WAbil.MP + plus < WAbil.MaxMP then
            WAbil.MP := WAbil.MP + plus
          else
            WAbil.MP := WAbil.MaxMP;
          //UpdateMsg (self, RM_HEALTHSPELLCHANGED, 0, 0, 0, 0, '');
          HealthSpellChanged;
        end;
      end;

      test := 6;
      if WAbil.HP = 0 then begin
        if BoAbilRevival then begin //재생 능력이 있다.
          if GetTickCount - LatestRevivalTime > 60 * 1000 then begin
            LatestRevivalTime := GetTickCount;
            //반지를 닳게 한다.
            ItemDamageRevivalRing;
            WAbil.HP := WAbil.MaxHP;
            HealthSpellChanged;
            SysMsg('The force of ring revived your body', 1);
          end;
        end;
        if WAbil.HP = 0 then
          Die;
      end;
      if HealthTick >= HEALTHFILLTICK then
        HealthTick := 0;
      if SpellTick >= SPELLFILLTICK then
        SpellTick := 0;
    end else begin
      test := 7;

      if GetTickCount - DeathTime > 3 * 60 * 1000 then begin
        MakeGhost(5);
      end;
    end;
  except
    MainOutMessage('[Exception] TCreature.Run 1 > ' + IntToStr(Test));
  end;


  try
    if (not Death) and ((IncSpell > 0) or (IncHealth > 0) or (IncHealing > 0)) then
    begin
      inchstime := 600 - _MIN(400, Abil.Level * 10);
      if (GetTickCount - IncHealthSpellTime >= inchstime) and (not Death) then
      begin  //체약,마약을 먹으면 천천히 찬다.

        n := _MIN(200, (GetTickCount - IncHealthSpellTime) - inchstime);
        IncHealthSpellTime := GetTickCount + longword(n);

        if (IncHealth > 0) or (IncSpell > 0) or (PerHealing > 0) then begin
          if PerHealth <= 0 then
            PerHealth := 1;
          if PerSpell <= 0 then
            PerSpell := 1;
          if PerHealing <= 0 then
            PerHealing := 1;
          if IncHealth < PerHealth then begin
            hp := IncHealth;
            IncHealth := 0;
          end else begin
            hp := PerHealth;
            IncHealth := IncHealth - PerHealth;
          end;
          if IncSpell < PerSpell then begin
            mp := IncSpell;
            IncSpell := 0;
          end else begin
            mp := PerSpell;
            IncSpell := IncSpell - PerSpell;
          end;
          if IncHealing < PerHealing then begin
            hp := hp + IncHealing;
            IncHealing := 0;
          end else begin
            hp := hp + PerHealing;
            IncHealing := IncHealing - PerHealing;
          end;
          PerHealth  := 5 + (Abil.Level div 10);
          PerSpell   := 5 + (Abil.Level div 10);
          PerHealing := 5;

          IncHealthSpell(hp, mp);

          if WAbil.HP = WAbil.MaxHP then begin
            IncHealth  := 0;
            IncHealing := 0;
          end;
          if WAbil.MP = WAbil.MaxMP then begin
            IncSpell := 0;
          end;
        end;
      end;
    end else begin
      IncHealthSpellTime := GetTickCount;
    end;

    if HealthTick < -HEALTHFILLTICK then begin
      if WAbil.HP > 1 then begin
        WAbil.HP   := WAbil.HP - 1;
        HealthTick := HealthTick + HEALTHFILLTICK;
        //UpdateMsg (self, RM_HEALTHSPELLCHANGED, 0, 0, 0, 0, '');
        HealthSpellChanged;
      end;
    end;
  except
    MainOutMessage('[Exception] TCreature.Run 2');
  end;

  test := 0;
  try
    if TargetCret <> nil then begin
      if (GetTickCount - TargetFocusTime > 30 * 1000) or
        (TargetCret.Death) or (TargetCret.BoGhost) or
        (Abs(TargetCret.CX - CX) > 15) or (Abs(TargetCret.CY - CY) > 15) then begin
        TargetCret := nil;
      end;
    end;
    test := 1;
    if LastHiter <> nil then begin
      if RaceServer <> RC_USERHUMAN then
        DuringIllegalTime := 30 * 1000    //몬스터는 30초간 지속...
      else
        DuringIllegalTime := 60 * 1000;   //사람이면 1분간 지속...

      if (GetTickCount - LastHitTime > DuringIllegalTime) then begin
        LastHiter := nil;
      end else if (LastHiter.Death) or (LastHiter.BoGhost) then begin
        LastHiter := nil;
      end;
    end;
    test := 2;
    if ExpHiter <> nil then begin
      if (GetTickCount - ExpHitTime > 6 * 1000) or (ExpHiter.Death) or
        (ExpHiter.BoGoodCrazyMode) or  //sonmg(2004/07/02)
        (ExpHiter.BoGhost) then
        ExpHiter := nil;
    end;
    test := 3;
    if Master <> nil then begin
      BoNoItem := True;

      test     := 4;
      waittime := 1000;
      if Master.RaceServer = RC_USERHUMAN then begin
        if TUserHuman(Master).BoChangeServer then
          waittime := 15 * 1000;
      end;

      test := 5;
      if (Master.Death and (GetTickCount > 1000 + Master.DeathTime)) or
        (Master.BoGhost and (GetTickCount > longword(waittime) + Master.GhostTime))
      then begin
        WAbil.HP := 0; //Die;
        //Master := nil;
      end;
    end;
    for i := SlaveList.Count - 1 downto 0 do begin
      // nil 검사 추가  2003-09-18  PDS
      try // 에러나면 그냥 없에버림
        bcheckDeath := TCreature(SlaveList[i]).Death;
      except
        SlaveList.Delete(i);
        MainOutMessage('MEMORY CHECK ERROR! TCreature.Run 2:6');
        continue;
      end;

      if (SlaveList[i] = nil) or TCreature(SlaveList[i]).Death or
        TCreature(SlaveList[i]).BoGhost or
        (TCreature(SlaveList[i]).Master <> self) then begin
        SlaveList.Delete(i);
      end;

    end;
    test := 7;

    if BoHolySeize then begin
      if GetTickCount - HolySeizeStart > HolySeizeTime then begin
        BreakHolySeize;
      end;
    end;
    test := 8;

    if BoCrazyMode or BoGoodCrazyMode then begin
      if GetTickCount - CrazyModeStart > CrazyModeTime then begin
        BreakCrazyMode;
      end;
    end;
    test := 9;

    if BoOpenHealth then begin
      if GetTickCount - OpenHealthStart > OpenHealthTime then begin
        BreakOpenHealth;
      end;
    end;
  except
    MainOutMessage('[Exception] TCreature.Run 3:' + IntToStr(test));
  end;

  try
    //2분에 한번 틱
    if GetTickCount - time10min > 2 * 1000 * 60 then begin
      time10min := GetTickCount;

      //피케이 포인트를 1씩 낮춘다.
      if PlayerKillingPoint > 0 then begin
        DecPkPoint(1);
      end;

    end;

    //0.5초에 한번 틱
    // 2003/03/04 1초에 한번 틱으로 변경
    if GetTickCount - time500ms > 1000 then begin    // 500
      time500ms := time500ms + 1000;                // 500;
      if RaceServer = RC_USERHUMAN then begin
        //초가 타는 것..
        UseLamp;
        // 2003/03/04 5초에 한번쪽으로 이동
        //          CheckTimeOutPkHiterList;
      end;
      // 2003/07/15 상태이상 추가
      //         if StatusArr[POISON_SLOW] > 0 then begin
      //          MainOutMessage ('[상태이상] 슬로우 발생');
      //            WalkTime := WalkTime + 700;      //늦게 움직인다
      //            HitTime  := HitTime + 1500;      //늦게 때린다
      //         end;
    end;

    //5초에 한번
    if GetTickCount - time5sec > 5 * 1000 then begin
      time5sec := GetTickCount;
      // 2003/03/04 0.5초에 한번쪽에서 이동
      if RaceServer = RC_USERHUMAN then
        CheckTimeOutPkHiterList;
    end;

    //10초에 한번
    if GetTickCount - time10sec > 10 * 1000 then begin
      time10sec := GetTickCount;

      //if BoTestServer then begin
      //부하를 대리고 있으면, 마력이 소모된다.
      //if (SlaveList.Count >= 2) and not BoSlaveRelax then begin
      //   n := 0;
      //   for i:=0 to SlaveList.Count-1 do
      //      n := n + TCreature(SlaveList[i]).Abil.MaxHP;
      //   DamageSpell (n div 60);
      //   HealthSpellChanged;
      //end;
      //end;

      if Master <> nil then begin
        //배신 검사
        if GetTickCount > MasterRoyaltyTime then begin
          for i := Master.SlaveList.Count - 1 downto 0 do begin
            if Master.SlaveList[i] = self then begin
              Master.SlaveList.Delete(i);
              break;
            end;
          end;
          Master   := nil; //배신한다.
          WAbil.HP := WAbil.HP div 10;  //체력이 급격하게 감소한다.
          UserNameChanged;
        end;

        //죽을 시간 검사 (꼬셔진지 12시간이 지나면 죽는다.)
        if SlaveLifeTime <> 0 then
          if GetTickCount - SlaveLifeTime > 12 * 60 * 60 * 1000 then begin
            WAbil.HP   := 0;
            BoDisapear := True;
          end;
      end;

    end;

    //if BoTestServer then begin
    //   if Master <> nil then begin
    //      //주인의 마력이 다 떨어지면 배신한다.
    //      if Master.WAbil.MP = 0 then begin
    //         for i:=Master.SlaveList.Count-1 downto 0 do begin
    //            if Master.SlaveList[i] = self then begin
    //               Master.SlaveList.Delete (i);
    //               break;
    //            end;
    //         end;
    //         Master := nil; //배신한다.
    //         WAbil.HP := 0; //WAbil.HP div 3;  //체력이 급격하게 감소한다.
    //         UserNameChanged;
    //      end;
    //   end;
    //end;

    //30초에 한번
    if GetTickCount - time30sec > 30 * 1000 then begin
      time30sec := GetTickCount;
      if GroupOwner <> nil then
        if {GroupOwner.Death or} GroupOwner.BoGhost then begin
          GroupOwner := nil;
        end;
      if GroupOwner = self then
        for i := GroupMembers.Count - 1 downto 0 do begin
          cret := TCreature(GroupOwner.GroupMembers.Objects[i]);
          if cret.Death or cret.BoGhost then
            GroupMembers.Delete(i);
        end;
      if DealCret <> nil then
        if DealCret.BoGhost then begin
          DealCret := nil;
        end;

      PEnvir.VerifyMapTime(CX, CY, self);
    end;

  except
    MainOutMessage('[Exception] TCreature.Run 4');
  end;

  try
    //상태... 시간이 다 되었는지 확인함.
    chg := False;
    needrecalc := False;
    for i := 0 to STATUSARR_SIZE - 1 do begin
      if StatusArr[i] > 0 then begin
        if StatusArr[i] < 60000 then
          if GetTickCount - StatusTimes[i] > 1000 then begin
            StatusArr[i]   := StatusArr[i] - 1;
            StatusTimes[i] := StatusTimes[i] + 1000;
            if StatusArr[i] = 0 then begin
              chg := True;
              case i of
                STATE_DEFENCEUP: begin
                  needrecalc := True;
                  SysMsg('Defense strength is back to normal', 1);
                end;
                STATE_HITSPEEDUP: begin
                  needrecalc := True;
                  SysMsg('Temporarily hitting speed is back to normal', 1);
                end;
                STATE_MAGDEFENCEUP: begin
                  needrecalc := True;
                  SysMsg('Magical defense strength is back to normal', 1);
                end;
                STATE_TRANSPARENT: begin
                  BoHumHideMode := False;
                end;
                STATE_BUBBLEDEFENCEUP: begin
                  BoAbilMagBubbleDefence := False;
                end;
                else;
              end;
            end else if StatusArr[i] = 10 then begin
              // 10초전 메시지(sonmg 2005/02/23)
              case i of
                STATE_DEFENCEUP: begin
                  SysMsg('Defense strength will be back to normal in ' +
                    IntToStr(StatusArr[i]) + ' sec.', 1);
                end;
                STATE_HITSPEEDUP: begin
                  SysMsg('Temporarily hitting speed will be back to normal in ' +
                    IntToStr(StatusArr[i]) + ' sec.', 1);
                end;
                STATE_MAGDEFENCEUP: begin
                  SysMsg(
                    'Magical defense strength will be back to normal in ' +
                    IntToStr(StatusArr[i]) + ' sec.', 1);
                end;
              end;
            end;
          end;
      end;
    end;
    for i := 0 to EXTRAABIL_SIZE - 1 do begin
      if ExtraAbil[i] > 0 then begin
        if GetTickCount > ExtraAbilTimes[i] then begin
          ExtraAbil[i] := 0;
          ExtraAbilFlag[i] := 0;
          needrecalc := True;
          case i of
            EABIL_DCUP: SysMsg(
                'Removed temporarily increased destructive power', 1);
            EABIL_MCUP: SysMsg(
                'Removed temporarily increased magic power', 1);
            EABIL_SCUP: SysMsg(
                'Removed temporarily increased zen power', 1);
            EABIL_HITSPEEDUP: SysMsg(
                'Removed temporarily increased hitting speed', 1);
            EABIL_HPUP: SysMsg('Removed temporarily increased HP', 1);
            EABIL_MPUP: SysMsg('Removed temporarily increased MP', 1);
            EABIL_PWRRATE: SysMsg(
                'Removed temporarily decreased attack ability', 1);
          end;
        end else if (ExtraAbilFlag[i] = 0) and
          (GetTickCount > ExtraAbilTimes[i] - 10000) then begin
          ExtraAbilFlag[i] := 1;
          case i of
            EABIL_DCUP: SysMsg(
                'Removing temporarily increased destructive power in 10 sec.', 1);
            EABIL_MCUP: SysMsg(
                'Removing temporarily increased magic power in 10 sec.', 1);
            EABIL_SCUP: SysMsg(
                'Removing temporarily increased zen power in 10 sec.', 1);
            EABIL_HITSPEEDUP: SysMsg(
                'Removing temporarily increased hitting speed in 10 sec.', 1);
            EABIL_HPUP: SysMsg(
                'Removing temporarily increased HP in 10 sec.', 1);
            EABIL_MPUP: SysMsg(
                'Removing temporarily increased MP in 10 sec.', 1);
          end;
        end;
      end;
    end;
    if chg then begin
      CharStatus := GetCharStatus;
      CharStatusChanged;
    end;
    if needrecalc then begin
      RecalcAbilitys;
      SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
    end;
  except
    MainOutMessage('[Exception] TCreature.Run 5');
  end;
  try
    //상태... 중독(체력이 감소)
    if GetTickCount - poisontime > 2500 then begin
      poisontime := GetTickCount;
      if StatusArr[POISON_DECHEALTH] > 0 then begin
        if BoAnimal then begin //고기가 나오는 동물인 경우..
          MeatQuality := MeatQuality - 1000;  //고기질이 치명적으로 나빠진다.
        end;
        // 녹독 걸린 넘이 사람이고 날 때린 넘이 사람인데 체크할 수 없을 때...
        // 체력 1 이하로 깎이지 않게(죽지 않게) sonmg 2004/07/14
        if (RaceServer = RC_USERHUMAN) then begin
          if (LastHiter = nil) and (LastHiterRace = RC_USERHUMAN) then begin
            //마지막 때린 넘이 누군지 모르지만 사람일 때는 죽지 않는다.
            DamageHealth(1 + PoisonLevel, 1); //1 + Random(3));
          end else begin
            //마지막 때린 넘이 사람이 아닐 때...
            DamageHealth(1 + PoisonLevel, 0); //1 + Random(3));
          end;
        end else begin
          //몬스터가 중독되었을 때...
          DamageHealth(1 + PoisonLevel, 0); //1 + Random(3));
        end;

        HealthTick := 0;   //체력 회복 안됨
        SpellTick  := 0;   //마력 회복 안됨
        HealthSpellChanged;
        //if RaceServer = RC_USERHUMAN then //사람이면 독으로 죽은건 PK이로 인정 안함
        //   LastHiter := nil;
      end;
    end;
  except
    MainOutMessage('[Exception] TCreature.Run 6');
  end;

end;


function TCreature.CheckAttackRule2(target: TCreature): boolean;
var
  hum: TUserHuman;
begin
  Result := True;
  if target = nil then
    exit;

  if (InSafeZone) or (target.InSafeZone) then begin
    Result := False;
  end;

  if not target.BoInFreePKArea then begin  //공성전 지역에서는 제외 된다.
    if (PKLevel >= 2) and (Abil.Level > 10) then begin //고랩 빨갱이들
      if (target.Abil.Level <= 10) and (target.PKLevel < 2) then
        //저렙 착한 초보를 공격 못한다.
        Result := False;
    end;
    if (Abil.Level <= 10) and (PKLevel < 2) then begin //저렙 착한 초보
      if (target.PKLevel >= 2) and (target.Abil.Level > 10) then
        //고렙 빨갱이들을 공격못한다.
        Result := False;
    end;
  end;

  //맵 이동후 3초 동안은 공격 못하고 안 당함
  if (GetTickCount - MapMoveTime < 3000) or (GetTickCount -
    target.MapMoveTime < 3000) then
    Result := False;

   {
   // 2003/04/25 체험케릭은 사람을 공격 못하고 공격받지 않음
   hum := TUserHuman(self);
   if (hum.ApprovalMode <> 2) and (hum.ApprovalMode <> 3) then begin
      Result := FALSE;
      exit;
   end;
   hum := TUserHuman(target);
   if (hum.ApprovalMode <> 2) and (hum.ApprovalMode <> 3) then begin
      Result := FALSE;
      exit;
   end;
   }
end;

//target <> nil
function TCreature._IsProperTarget(target: TCreature): boolean;

  function GetNonPKServerRule(rslt: boolean): boolean;
  begin
    Result := rslt;
    if target.RaceServer = RC_USERHUMAN then begin
      if (not PEnvir.FightZone) and (not PEnvir.Fight2Zone) and
        (not PEnvir.Fight3Zone) and (not PEnvir.Fight4Zone) and
        (target.RaceServer = RC_USERHUMAN) then
        Result := False;
      if UserCastle.BoCastleUnderAttack then
        if (BoInFreePKArea) or (UserCastle.IsCastleWarArea(PEnvir, CX, CY)) then
          Result := True;
      if (MyGuild <> nil) and (target.MyGuild <> nil) then
        if GetGuildRelation(self, target) = 2 then //문전(문파전)중임
          Result := True;
    end;
  end;

begin
  Result := False;
  if target = nil then
    exit;
  if target = self then
    exit;
  if RaceServer >= RC_ANIMAL then begin  //자신이 동물
    if Master <> nil then begin
      //주인이 있는 몹
      //if (target.RaceServer >= RC_ANIMAL) and (target.Master = nil) then
      //   Result := TRUE;
      if (Master.LastHiter = target) or (Master.ExpHiter = target) or
        (Master.TargetCret = target) then
        Result := True;
      if target.TargetCret <> nil then begin
        if (target.TargetCret = Master) or  //주인을 공격
          (target.TargetCret.Master = Master) and (target.RaceServer <> 0)
        //동료를 공격, 사람인경우 제외
        then
          Result := True;
      end;
      if (target.TargetCret = self) and (target.RaceServer >= RC_ANIMAL) then
        //몹이면서 자신을 공격하는 자
        Result := True;
      if target.Master <> nil then begin  //상대가 소환몹
        if (target.Master = Master.LastHiter) or
          (target.Master = Master.TargetCret) then
          Result := True;
      end;
      if target.Master = Master then
        Result := False;  //주인이 같으면 공격안함
      if target.BoHolySeize then
        Result := False;  //결계에 걸려 있으면 공격안함
      if Master.BoSlaveRelax then
        Result := False;
      if target.BoGoodCrazyMode then
        Result := False; //상대가 곱게미친상태면 공격안함(sonmg)
      if target.RaceServer = RC_USERHUMAN then begin  //상대가 사람인 경우
        //상대 또는 자신이 안전지대에 있는 경우 sonmg(2004/10/04)
        if (InSafeZone) or (target.InSafeZone) then begin
          //상대가 안전지대에 있는 경우
          Result := False;
        end;
      end;
      // 타겟과 맵이 다르면 공격할 수 없다.(sonmg 2005/01/21 -> 2005/03/31재수정)
      if MapName <> target.MapName then
        Result := False;
      BreakCrazyMode;  //주인있는 몹..
    end else begin
      //일반 몹
      if target.RaceServer = RC_USERHUMAN then
        Result := True;
      if (RaceServer > RC_PEACENPC) and (RaceServer < RC_ANIMAL) then
      begin //공격력을 가진 NPC는 아무나 공격한다.
        Result := True;
      end;
      if target.Master <> nil then begin
        if target.Master.RaceServer = RC_USERHUMAN then
        Result := True;
        end;
    end;
    if BoCrazyMode then  //미침, 아무나 공격, 적 안가림... (소환몹에게도 통한다.)
      Result := True;
    if BoGoodCrazyMode then begin
      //곱게미친상태, 사람과 소환몹은 공격 안하고 다른 몬스터만 공격한다.
      if (target.RaceServer = RC_USERHUMAN) or (target.Master <> nil) then begin
        Result := False;
      end else begin
        Result := True;
      end;
    end;
  end else begin //npc혹은 사람인경우
    if RaceServer = RC_USERHUMAN then begin
      //공격형태 설정에 따라 다름
      case HumAttackMode of
        HAM_ALL: begin
          if not ((target.RaceServer >= RC_NPC) and
            (target.RaceServer <= RC_PEACENPC)) then
            Result := True;
          if BoNonPKServer then
            Result := GetNonPKServerRule(Result);
        end;
        HAM_PEACE: begin
          if target.RaceServer >= RC_ANIMAL then
            Result := True;
        end;
        HAM_GROUP: begin
          if not ((target.RaceServer >= RC_NPC) and
            (target.RaceServer <= RC_PEACENPC)) then
            Result := True;
          if target.RaceServer = RC_USERHUMAN then
            if IsGroupMember(target) then
              Result := False;
          if BoNonPKServer then
            Result := GetNonPKServerRule(Result);
        end;
        HAM_GUILD: begin
          if not ((target.RaceServer >= RC_NPC) and
            (target.RaceServer <= RC_PEACENPC)) then
            Result := True;
          if target.RaceServer = RC_USERHUMAN then
            if MyGuild <> nil then begin
              if TGuild(MyGuild).IsMember(target.UserName) then
                Result := False;
              if BoGuildWarArea and (target.MyGuild <> nil) then
              begin  //문파전,공성전 지역에 있음
                if TGuild(MyGuild).IsAllyGuild(TGuild(target.MyGuild)) then
                  Result := False;
              end;
            end;
          if BoNonPKServer then
            Result := GetNonPKServerRule(Result);
        end;
        HAM_PKATTACK: begin
          if not ((target.RaceServer >= RC_NPC) and
            (target.RaceServer <= RC_PEACENPC)) then
            Result := True;
          if target.RaceServer = RC_USERHUMAN then begin
            if self.PKLevel >= 2 then begin  //공격하는 자가 빨갱이
              if target.PKLevel < 2 then
                Result := True
              else
                Result := False;
            end else begin
              //공격하는 자가 흰둥이
              if target.PKLevel >= 2 then
                Result := True
              else
                Result := False;
            end;
          end;
          if BoNonPKServer then
            Result := GetNonPKServerRule(Result);
        end;
      end;
      //필리핀 : 레벨 10 이하는 PK 금지 및 PK 공격 안당함.(sonmg 2005/12/20)
      if PHILIPPINEVERSION and (target.RaceServer = RC_USERHUMAN) and
        ((self.Abil.Level <= NONPKLEVEL) or (target.Abil.Level <= NONPKLEVEL)) then begin
        Result := False;
      end;
    end else
      Result := True;
  end;

  // 추가 2004-1-7 숨어있는 넘들은 공격할 수 없다. target.HideMode 추가
  if target.BoSysopMode or target.BoStoneMode or target.HideMode then
    //운영자, 돌로된 상태
    Result := False;
end;


function TCreature.IsProperTarget(target: TCreature): boolean;
begin
  Result := False;
  if target = nil then
    exit;

  Result := _IsProperTarget(target);
  if Result then
    if (RaceServer = RC_USERHUMAN) and (target.RaceServer = RC_USERHUMAN) then begin
      Result := CheckAttackRule2(target);  //지역 따라서 PK 여부
      if target.BoTaiwanEventUser then
        //이벤트 아이템을 가지고 있는 유저는 공격이 됨
        Result := True;
    end;
  if (target <> nil) and (RaceServer = RC_USERHUMAN) then begin  //나는 사람
    if (target.Master <> nil) and (target.RaceServer <> RC_USERHUMAN) then
    begin  //주인이 있는 몬스터
           //대상이 몬스터
      if target.Master = self then begin  //내 부하
        if HumAttackMode <> HAM_ALL then  //모두 공격 일때만 부하가 공격됨
          Result := False;
      end else begin
        //다른 이의 부하
        Result := _IsProperTarget(target.Master);
        if (InSafeZone) or (target.InSafeZone) then begin
          Result := False;
        end;
      end;
    end;
  end;
end;


function TCreature.IsProperFriend(target: TCreature): boolean;

  function IsFriend(cret: TCreature): boolean;
  begin
    Result := False;
    if cret.RaceServer = RC_USERHUMAN then begin  //대상이 사람인 경우만
      //공격형태 설정에 따라 다름
      case HumAttackMode of
        HAM_ALL: Result   := True;
        HAM_PEACE: Result := True;
        HAM_GROUP: begin
          if cret = self then
            Result := True;
          if IsGroupMember(cret) then
            Result := True;
        end;
        HAM_GUILD: begin
          if cret = self then
            Result := True;
          if MyGuild <> nil then begin
            if TGuild(MyGuild).IsMember(cret.UserName) then
              Result := True;
            if BoGuildWarArea and (cret.MyGuild <> nil) then begin
              //문파전,공성전 지역에 있음
              if TGuild(MyGuild).IsAllyGuild(TGuild(cret.MyGuild)) then
                Result := True;
            end;
          end;
        end;
        HAM_PKATTACK: begin
          if cret = self then
            Result := True;
          if PKLevel >= 2 then begin //내가 빨갱이
            if cret.PKLevel >= 2 then
              Result := True;
          end else begin  //내가 흰둥이
            if cret.PKLevel < 2 then
              Result := True;
          end;
        end;
      end;
    end;
  end;

begin
  Result := False;
  if target = nil then
    exit;
  if RaceServer >= RC_ANIMAL then begin  //자신이 동물
    if target.RaceServer >= RC_ANIMAL then
      Result := True;
    if target.Master.RaceServer <> RC_USERHUMAN then  //소환몹은 힐,등이 안된다.
      Result := True;
  end else begin //npc혹은 사람인경우
    if RaceServer = RC_USERHUMAN then begin
      //공격형태 설정에 따라 다름
      Result := IsFriend(target);
      if target.RaceServer >= RC_ANIMAL then begin
        if target.Master = self then  //자기 부하인 경우.
          Result := True
        else if target.Master <> nil then
          Result := IsFriend(target.Master);
      end;
    end else
      Result := True;
  end;
end;

procedure TCreature.SelectTarget(target: TCreature);
begin
  TargetCret      := target;
  TargetFocusTime := GetTickCount;
end;

procedure TCreature.LoseTarget;
begin
  TargetCret := nil;
end;

function TCreature.GetPurity: integer;
begin
  //유저가 광석을 캘 때.
  if RaceServer = RC_USERHUMAN then begin
    //무기 내구가 0이면 광석 순도는 급격히 떨어진다.
    if UseItems[U_WEAPON].Dura = 0 then begin
      Result := 1000 + Random(5000);
    end else begin
      Result := 3000 + Random(13000);
      if Random(20) = 0 then
        Result := Result + Random(10000);
    end;
  end else begin
    //몬스터가 광석을 떨굴 때.
    Result := 3000 + Random(11000);
    if Random(20) = 0 then
      Result := Result + Random(10000);
  end;

  // 미네랄 이벤트
  //        Result := 6000 + Random(12000);
  //        if Random(10) = 0 then
  //           Result := Result + Random(10000);
end;


 //선물상자
 //변경(2005 크리스마스 이벤트)
procedure TCreature.GetGiftFromBox;
var
  pi:  PTUserItem;
  hum: TUserHuman;
begin
  if RaceServer <> RC_USERHUMAN then
    exit;
  hum := TUserHuman(self);
  if hum = nil then
    exit;

  if Itemlist.Count < MAXBAGITEM then begin
    case Random(300000) of
      1: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BraveryOrb', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      2: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('DemonicOrb', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      3: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('HolyOrb', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      4..7: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('GaleGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      8..12: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('EvasionGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      13..17: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('SharpnessGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      18..22: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('PoisonGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      23..27: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('ColdnessGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      28..32: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('AwakeningGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      33..37: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('EnduranceGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      38..46: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BraveryGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      47..56: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('DemonicGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      57..66: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('HolyGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      67..76: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('ProtectionGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      77..86: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('ExorcismGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      87..96: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('HardnessGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      97..6095: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BenedictionOil', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      6096..10594: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('Platinum', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      10595..15094: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('GoldOre', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      15095..18094: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('HealthStone(L)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      18095..21094: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('MagicStone(L)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      21095..24094: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('PowerStone(L)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      24095..27094: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('DCStone(L)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      27095..30094: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('MCStone(L)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      30095..33094: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('TaoStone(L)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      33095..37593: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('DeathGauntlet', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      37594..41313: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BronzeGlove', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      41314..45093: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('SpellBracelet', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      45094..48843: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BlackIronBrace', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      48844..52593: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('MoralRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      52594..56343: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('CharmRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      56344..60093: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('CoralRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      60094..63843: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('ExpelRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      63844..67593: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BlueJadeNeckl', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      67594..71343: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('ConvexLens', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      71344..75093: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BambooPipe', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      75094..88593: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(HP)DrugBundXL', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      88594..102093: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(MP)DrugBundXL', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      102094..120093: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('String', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      120094..142593: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(HP)DrugBundle', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      142594..165093: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(MP)DrugBundle', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      165094..171843: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('WarGodOil', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      171844..181968: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(HP)DrugXL', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      181969..192093: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(MP)DrugXL', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      192094..205593: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(HP)DrugLarge', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      205594..219093: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(MP)DrugLarge', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      219094..246093: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('SunPotion(M)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      246094..249093: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('Lotteryticket', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      else //나머지
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('SunPotion', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
    end;
  end;
end;

//부활절 달걀
procedure TCreature.GetGiftFromEgg;
var
  pi:  PTUserItem;
  hum: TUserHuman;
begin
  if RaceServer <> RC_USERHUMAN then
    exit;
  hum := TUserHuman(self);
  if hum = nil then
    exit;

  if Itemlist.Count < MAXBAGITEM then begin
    case Random(300000) of
      1..5: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('DragonSlayer', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      6..10: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('SoulSabre', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      11..15: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('DragonStaff', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      16  ..  65: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BraveryOrb', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      66  ..  115: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('DemonicOrb', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      116  ..  165: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('HolyOrb', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      166  ..  215: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('OmaSpiritRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      216  ..  265: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('NobleRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      266  ..  315: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('SoulRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      316  ..  515: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('RecallNecklace', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      516  ..  715: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('RecallRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      716  ..  915: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('RecallHelmet', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      916  ..  1115: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('RecallBracelet', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      1116  ..  1315: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('GaleGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      1316  ..  1515: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('EvasionGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      1516  ..  1715: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('SharpnessGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      1716  ..  1915: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('PoisonGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      1916  ..  2115: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('ColdnessGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      2116  ..  2315: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('AwakeningGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      2316  ..  2515: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('EnduranceGem)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      2516  ..  2715: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('VioletRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      2716  ..  2915: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('DragonRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      2916  ..  3115: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('TitanRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      3116  ..  3615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('HeroNecklace', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      3616  ..  4115: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('AdamantineNeck', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      4116  ..  4615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('RequiemNecklac', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      4616  ..  5115: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BraveryGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      5116  ..  5615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('DemonicGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      5616  ..  6115: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('HolyGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      6116  ..  6615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('ProtectionGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      6616  ..  7115: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('ExorcismGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      7116  ..  7615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('HardnessGem', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      7616  ..  8115: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BaekTaGlove', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      8116  ..  8615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('HolyTaoWheel', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      8616  ..  9115: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('SpiritReformer', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      9116  ..  16615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BenedictionOil', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      16616  ..  18615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('HealthStone(L)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      18616  ..  20615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('MagicStone(L)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      20616  ..  22615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('PowerStone(L)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      22616  ..  24615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('DCStone(L)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      24616  ..  26615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('MCStone(L)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      26616  ..  28615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('TaoStone(L)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      28616  ..  31615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BlackIronBrace', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      31616  ..  34615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('MoralRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      34616  ..  37615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('CharmRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      37616  ..  40615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('CoralRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      40616  ..  43615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('ExpelRing', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      43616  ..  46615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BlueJadeNeckl', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      46616  ..  49615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('ConvexLens', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      49616  ..  52615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('BambooPipe', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      52616  ..  67615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(HP)DrugBundXL', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      67616  ..  82615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(MP)DrugBundXL', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      82616  ..  100115: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(HP)DrugBundle', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      100116  ..  117615: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(MP)DrugBundle', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      117616  ..  124365: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('WarGodOil', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      124366  ..  141865: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(HP)DrugXL', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      141866  ..  159365: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(MP)DrugXL', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      159366  ..  179365: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(HP)DrugLarge', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      179366  ..  199365: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('(MP)DrugLarge', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      199366  ..  224365: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('SunPotion(M)', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      224366  ..  259365: begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('Lotteryticket', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      else begin
        new(pi);
        if UserEngine.CopyToUserItemFromName('SunPotion', pi^) then begin
          ItemList.Add(pi);
          WeightChanged;
          hum.SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
    end;
  end;

{
   if Itemlist.Count < MAXBAGITEM then begin
      case Random(300000) of
         1..25:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('BraveryOrb', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         26..50:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('DemonicOrb', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         51..75:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('HolyOrb', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         76..100:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('OmaSpiritRing', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         101..125: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('NobleRIng', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         126..150:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('SoulRing', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         151..225: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('GaleGem', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         226..325: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('EvasionGem', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         326..425: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('SharpnessGem', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         426..525: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('PoisonGem', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         526..625:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('ColdnessGem', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         626..725: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('AwakeningGem', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         726..825: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('EnduranceGem', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         826..925: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('VioletRing', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         926..1025:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('DrangonRingm', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         1026..1125: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('TitanRing', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         1126..1325:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('HeroNecklace', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         1326..1525: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('AdamantineNeck', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         1526..1725:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('RequiemNecklac', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         1726..1925: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('BraveryGem)', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         1926..2125:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('DemonicGem', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         2126..2325: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('HolyGem', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         2326..2525:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('ProtectionGem', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         2526..2725: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('ExorcismGem', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         2726..2925:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('HardnessGem', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         2926..3175:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('BaekTaGlove', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         3176..3425: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('HolyTaoWheel', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         3426..3675: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('SpiritReformer', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         3676..12675: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('BenedictionOil', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         12676..13675: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('HealthStone(L)', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         13676..14675: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('MagicStone(L)', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         14676..15675: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('PowerStone(L)', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         15676..16675: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('DCStone(L)', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         16676..17675: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('MCStone(L)', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         17676..18675: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('TaoStone(L)', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         18676..22425: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('BlackIronBrace', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         22426..26175:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('MoralRing', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         26176..29925: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('CharmRing', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         29926..33675: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('CoralRing', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         33676..37425: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('ExpelRing', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         37426..41175: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('BlueJadeNeckl', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         41176..44925:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('ConvexLens', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         44926..48675: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('BambooPipe', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         48676..62175: 
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('(HP)DrugBundXL', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         62176..75675:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('(MP)DrugBundXL', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         75676..98175:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('(HP)DrugBundle', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         98176..120675:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('(MP)DrugBundle', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         120676..127425:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('WarGodOil', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         127426..137550:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('(HP)DrugXL', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         137551..147675:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('(MP)DrugXL', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         147676..161175:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('(HP)DrugLarge', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         161176..174675:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('(MP)DrugLarge', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         174676..204675:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('SunPotion(M)', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         204676..234675:
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('Lotteryticket', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
         else
            begin
               new (pi);
               if UserEngine.CopyToUserItemFromName ('SunPotion', pi^) then begin
                  ItemList.Add (pi);
                  WeightChanged;
                  hum.SendAddItem (pi^);
               end else
                  Dispose (pi);
            end;
      end;
   end;
}
end;

 //순간 능력치 상승
 //파라미터 : 종류, 능력치, 분, 초
procedure TCreature.EnhanceExtraAbility(kind, amount: integer; min, sec: DWORD);
var
  currenttime: longword;
  headstr:     string;
begin
  if kind < 0 then
    exit;

  currenttime     := GetTickCount;
  ExtraAbil[kind] := _MIN(255, _MAX(ExtraAbil[kind], amount));
  ExtraAbilFlag[kind] := 0;
  ExtraAbilTimes[kind] := _MAX(ExtraAbilTimes[kind], currenttime +
    min * 60 * 1000{분단위} + sec * 1000); //초단위
  if RaceServer = RC_USERHUMAN then begin
    case kind of
      EABIL_DCUP: begin
        headstr := 'Temporarily destructive power increased during ';
      end;
      EABIL_MCUP: begin
        headstr := 'Temporarily magic power increased during ';
      end;
      EABIL_SCUP: begin
        headstr := 'Temporarily zen power increased during ';
      end;
      EABIL_HITSPEEDUP: begin
        headstr := 'Temporarily hitting speed increased during ';
      end;
      EABIL_HPUP: begin
        headstr := 'Temporarily HP increased during ';
      end;
      EABIL_MPUP: begin
        headstr := 'Temporarily MP increased during ';
      end;
      else begin
        headstr := 'Temporarily ability increased during ';
      end;
    end;
    SysMsg(headstr + IntToStr((ExtraAbilTimes[kind] - currenttime) div 1000 div 60) +
      'min. ' + IntToStr((ExtraAbilTimes[kind] - currenttime) div 1000 mod 60) +
      'sec.', 1);
    //      SysMsg (headstr + IntToStr(HIBYTE(std.DC) + hibyte(std.MAC) div 60) + 'min. ' + IntToStr(hibyte(std.MAC) mod 60) + 'sec.', 1);
  end;
end;


{%%%%%%%%%%%%%%%%%%%%%% *TAnimal* %%%%%%%%%%%%%%%%%%%}


constructor TAnimal.Create;
begin
  inherited Create;
  TargetX      := -1; //가야할 곳이 없음
  FindPathRate := 1000 + Random(4) * 500;
  FindpathTime := GetTickCount;
  RaceServer   := RC_ANIMAL;
  HitTime      := GetCurrentTime - Random(3000);
  WalkTime     := GetCurrentTime - Random(3000);
  SearchEnemyTime := GetTickCount;
  BoRunAwayMode := False;
  RunAwayStart := GetTickCount;
  RunAwayTime  := 0;

end;

procedure TAnimal.RunMsg(msg: TMessageInfo);
var
  str: string;
begin
  case msg.Ident of
    RM_STRUCK: begin
      if (msg.Sender = self) and (msg.lParam3 <> 0) then begin
        SetLastHiter(TCreature(msg.lparam3));
        Struck(TCreature(msg.lParam3));
        BreakHolySeize;
        if (Master <> nil) and (Master.RaceServer <> RC_FOXTAO) and (TCreature(msg.lparam3) <> Master) then
        begin //주인이 있는 몹
          if TCreature(msg.lparam3).RaceServer = RC_USERHUMAN then
          begin //주인에게 정당방위
                //정당방어를 위한 기록..
            Master.AddPkHiter(TCreature(msg.lparam3));
          end;
        end;
      end;
    end;
    else
      inherited RunMsg(msg);
  end;
end;

procedure TAnimal.Run;
begin
  inherited Run;
end;

procedure TAnimal.Attack(target: TCreature; dir: byte);
begin
  { inherited }
  HitHit(target, HM_HIT, dir);
end;


procedure TAnimal.Struck(hiter: TCreature);
var
  targdir: byte;
begin
  StruckTime := GetTickCount;
  if hiter <> nil then begin
    if (TargetCret = nil) or (not TargetInAttackRange(TargetCret, targdir)) or
      (Random(6) = 0) then
      if IsProperTarget(hiter) then
        SelectTarget(hiter);
  end;
  if BoAnimal then begin
    MeatQuality := MeatQuality - Random(300);
    //동물이 맞으면 맞을 수록 고기 품질이 떨어짐
    if MeatQuality < 0 then
      MeatQuality := 0;
  end;
  if Abil.Level < MAXKINGLEVEL - 1 then    //50
    HitTime := HitTime + (150 - _MIN(130, Abil.Level * 4)); //한방에 ms씩 늦게 때린다.
  //WalkTime := WalkTime + (300 - _MIN(200, (Abil.Level div 5) * 20));
end;

procedure TAnimal.LoseTarget;
begin
  inherited LoseTarget;
  TargetX := -1;
  TargetY := -1;
end;

function TAnimal.GetNearMonster: TCreature;   //가장 가까운 생물체 얻어오기...
var
  i, d, dis:      integer;
  cret, nearcret: TCreature;
begin
  Result   := nil;
  nearcret := nil;
  dis      := 999;
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

  Result := nearcret;
end;

procedure TAnimal.MonsterNormalAttack;   //여기서는 select만 한다....
var
  i, d, dis:      integer;
  cret, nearcret: TCreature;
begin
  nearcret := nil;
  dis      := 999;
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
  if nearcret <> nil then
    SelectTarget(nearcret);
end;

procedure TAnimal.MonsterDetecterAttack;
var
  i, d, dis:      integer;
  cret, nearcret: TCreature;
begin
  nearcret := nil;
  dis      := 999;
  for i := 0 to VisibleActors.Count - 1 do begin
    cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
    if (not cret.Death) and (IsProperTarget(cret)) then begin
      d := abs(CX - cret.CX) + abs(CY - cret.CY);
      if d < dis then begin
        dis      := d;
        nearcret := cret;
      end;
    end;
  end;
  if nearcret <> nil then
    SelectTarget(nearcret);
end;

procedure TAnimal.SetTargetXY(x, y: integer);
begin
  TargetX := x;
  TargetY := y;
end;

procedure TAnimal.GotoTargetXY;
var
  wantdir, i, targx, targy, oldx, oldy, rand: integer;
begin
  if BoDontMove then
    exit;

  //걸어갈 목표가 있는 경우
  //if GetCurrentTime - FindPathTime > FindPathRate then begin
  if (CX <> TargetX) or (CY <> TargetY) then begin
    targx   := TargetX;
    targy   := TargetY;
    //길 찾을 시간
    FindPathTime := GetCurrentTime;
    wantdir := DR_DOWN;
    while True do begin
      if targx > self.CX then begin
        wantdir := DR_RIGHT;
        if targy > self.CY then
          wantdir := DR_DOWNRIGHT;
        if targy < self.CY then
          wantdir := DR_UPRIGHT;
        break;
      end;
      if targx < self.CX then begin
        wantdir := DR_LEFT;
        if targy > self.CY then
          wantdir := DR_DOWNLEFT;
        if targy < self.CY then
          wantdir := DR_UPLEFT;
        break;
      end;
      if targy > self.CY then begin
        wantdir := DR_DOWN;
        break;
      end;
      if targy < self.CY then begin
        wantdir := DR_UP;
        break;
      end;
      break;
    end;

    oldx := self.CX;
    oldy := self.CY;
    WalkTo(wantdir, False);
    rand := Random(3);
    for i := 1 to 7 do begin
      if (oldx = self.CX) and (oldy = self.CY) then begin
        {앞이 막혀 있음}
        if rand <> 0 then
          Inc(wantdir)
        else if wantdir > 0 then
          Dec(wantdir)
        else
          wantdir := 7;
        if wantdir > 7 then
          wantdir := 0;
        WalkTo(wantdir, False);
      end else
        break;
    end;
  end;
end;

procedure TAnimal.Wondering;
begin
  if BoDontMove then
    exit;

  if Random(20) = 0 then begin
    if Random(4) = 1 then
      Turn(Random(8))  {8 direction}
    else begin
      {inherited}
      WalkTo(self.Dir, False);
    end;
  end;

end;


{%%%%%%%%%%%%%%%%%%%%%% *TUserHuman* %%%%%%%%%%%%%%%%%%%}


constructor TUserHuman.Create;
begin
  inherited Create;
  RaceServer   := RC_USERHUMAN;
  EmergencyClose := False;
  BoChangeServer := False;
  SoftClosed   := False;
  UserRequestClose := False;
  UserSocketClosed := False;
  ReadyRun     := False; //로딩,초기화,.. 완료되면 ReadyRun은 TRUE가 된다.
  PriviousCheckCode := 0;
  CrackWanrningLevel := 0; //패킷 duplication같은 장난을 치는지 여부..
  // 2003-08-08 :PDS
  // 사람이 몰릴때 대비 저장시간을 5분간격으로 랜덤 조정한다.
  // 처음접속한 사람은 15분까지 저장타임이 늘어날수 있다. 그후에는 10분에 한번씩 저장
  LastSaveTime := GetTickCount + longword(Random(5 * 60 * 1000));
  WantRefMsg   := True;
  BoSaveOk     := False;
  MustRandomMove := False;
  CurQuest     := nil;
  CurSayProc   := nil;

  BoTimeRecall := False;
  BoTimeRecallGroup := False;
  TimeRecallMap := '';
  TimeRecallX := 0;
  TimeRecallY := 0;

  RunTime     := GetCurrentTime;
  RunNextTick := 250;
  SearchRate  := 1000;
  SearchTime  := GetTickCount;
  ViewRange   := 12;
  FirstTimeConnection := False;
  LoginSign   := False;
  BoServerShifted := False;
  BoAccountExpired := False;

  BoSendNotice     := False;
  operatetime      := GetTickCount;
  operatetime_sec  := GetTickCount;
  operatetime_500m := GetTickCount;
  boGuildwarsafezone := False;

  ClientMsgCount     := 0;
  ClientSpeedHackDetect := 0;
  LatestSpellTime    := GetTickCount;
  LatestSpellDelay   := 0;
  LatestHitTime      := GetTickCount;
  LatestWalkTime     := GetTickCount;
  LatestDropTime     := GetTickCount;
  HitTimeOverCount   := 0;
  HitTimeOverSum     := 0;
  SpellTimeOverCount := 0;
  WalkTimeOverCount  := 0;
  WalkTimeOverSum    := 0;
  SpeedHackTimerOverCount := 0;

  SendBuffers      := TList.Create;
  // 2003/06/12 슬레이브 패치
  PrevServerSlaves := TList.Create; //서버 이동하면서 옮겨다니는 부하

  LatestSayStr    := '';
  BombSayCount    := 0;
  BombSayTime     := GetTickCount;
  BoShutUpMouse   := False;
  ShutUpMouseTime := GetTickCount;

  LoginDateTime := Now;
  LoginTime     := GetTickCount;
  ServerShiftTime := GetTickCount;

  FirstClientTime := 0;
  FirstServerTime := 0;

  BoChangeServer := False;
  BoChangeServerNeedDelay := False;
  WriteChangeServerInfoCount := 0;

  LineNoticeTime   := GetTickCount;
  LineNoticeNumber := 0;

  NotReadTag := 0;
  // 연인 사제
  fLover     := TRelationShipMgr.Create;
  //   fMaster := TRelationShipMgr.Create;

  FExpireTime  := 0;
  FExpirecount := 0;

  FUserMarket := TMarketItemManager.Create;

  FMarketNPC := nil;
  BoFlagUserMarket := False;
  FlagReadyToSellCheck := False;

end;

destructor TUserHuman.Destroy;
var
  i: integer;
begin
  for i := 0 to SendBuffers.Count - 1 do
    FreeMem(SendBuffers[i]);
  SendBuffers.Free;
  // 2003/06/12 슬레이브 패치
  PrevServerSlaves.Free;

  // 연인 사제 메모리 삭제
  fLover.Free;
  //   fMaster.Free;

  // 위탁상점 해제
  FUserMarket.Free;

  inherited Destroy;
end;

function TUserHuman.GetUserMassCount: integer;
begin
  Result := UserEngine.GetAreaUserCount(PEnvir, CX, CY, 10);
end;

procedure TUserHuman.ResetCharForRevival;  //죽은 경우 상태 리셋
begin
  FillChar(StatusArr, sizeof(word) * STATUSARR_SIZE, #0);  //상태 리셋
  FillChar(StatusValue, sizeof(byte) * STATUSARR_SIZE, #0);
  //상태 리셋 추가(sonmg 2005/06/03)
end;

procedure TUserHuman.Clear_5_9_bugitems;
var
  i: integer;
begin
  for i := ItemList.Count - 1 downto 0 do begin
    if PTUserItem(ItemList[i]).Index >= 164 then begin
      Dispose(PTUserItem(ItemList[i]));
      ItemList.Delete(i);
    end;
  end;
  for i := SaveItems.Count - 1 downto 0 do begin
    if PTUserItem(SaveItems[i]).Index >= 164 then begin
      Dispose(PTUserItem(SaveItems[i]));
      SaveItems.Delete(i);
    end;
  end;
end;

procedure TUserHuman.Reset_6_28_bugitems;
var
  i:  integer;
  ps: PTStdItem;
begin
  // 2003/03/15 아이템 인벤토리 확장
  for i := 0 to 12 do begin     // 8->12
    if UseItems[i].DuraMax = 0 then begin
      ps := UserEngine.GetStdItem(UseItems[i].Index);
      if ps <> nil then
        UseItems[i].DuraMax := ps.DuraMax;
    end;
  end;
  for i := ItemList.Count - 1 downto 0 do begin
    if PTUserItem(ItemList[i]).DuraMax = 0 then begin
      ps := UserEngine.GetStdItem(PTUserItem(ItemList[i]).Index);
      if ps <> nil then
        PTUserItem(ItemList[i]).DuraMax := ps.DuraMax;
    end;
  end;
  for i := SaveItems.Count - 1 downto 0 do begin
    if PTUserItem(SaveItems[i]).Index >= 164 then begin
      ps := UserEngine.GetStdItem(PTUserItem(SaveItems[i]).Index);
      if ps <> nil then
        PTUserItem(SaveItems[i]).DuraMax := ps.DuraMax;
      //Dispose (PTUserItem(SaveItems[i]));
      //SaveItems.Delete (i);
    end;
  end;
end;

procedure TUserHuman.Initialize;
var
  i, k, sidx: integer;
  iname, itmlist:  string;
  pi:     PTUserItem;
  u:      TUserItem;
  ps:     PTStdItem;
  plsave: PTSlaveInfo;
begin
  if BoTestServer then begin
    if Abil.Level < TestLevel then begin   //테스트 서버인경우
      Abil.Level := TestLevel;  //테스트 서버의 기본 레벨
    end;
    if Gold < TestGold then begin
      Gold := TestGold;   //테스트 서버의 기본 돈
    end;
  end;

  if BoTestServer or BoServiceMode then begin
    ApprovalMode := 3;  //무료 모드,... 시간 깍임 없음.
  end;

  MapMoveTime   := GetTickCount;
  LoginDateTime := Now;
  LoginTime     := GetTickCount;
  ServerShiftTime := GetTickCount;

  inherited Initialize;

  //아이템중에 사라진 아이템(Name='')이 없는지 확인해야 한다.
  for i := ItemList.Count - 1 downto 0 do begin
    if UserEngine.GetStdItemName(PTUserItem(ItemList[i]).Index) = '' then begin
      Dispose(PTUserItem(ItemList[i]));
      ItemList.Delete(i);
      continue;
    end;
    //Desc, 추가 능력치에 버그 발생...
    //pi := PTUserItem(ItemList[i]);
    //if (pi.Desc[0] > 10) or (pi.Desc[1] > 10) or (pi.Desc[2] > 10) or (pi.Desc[3] > 10) then
    //   FillChar (pi.Desc, 12, #0);
  end;
  //for i:=0 to 12 do begin   // 8->12
  //   pi := @UseItems[i];
  //   if pi.Index > 0 then
  //      if (pi.Desc[0] > 10) or (pi.Desc[1] > 10) or (pi.Desc[2] > 10) or (pi.Desc[3] > 10) then
  //         FillChar (pi.Desc, 12, #0);
  //end;

  // 가방에서 아이템 개수가 0 인 누적아이템 없에자
  for i := ItemList.Count - 1 downto 0 do begin
    ps := UserEngine.GetStdItem(PTUserItem(ItemList[i]).Index);
    if (ps <> nil) and (ps.OverlapItem >= 1) and (PTUserItem(ItemList[i]).dura = 0)
    then begin
      Dispose(PTUserItem(ItemList[i]));
      ItemList.Delete(i);
      continue;
    end;
  end;
  //창고 아이템 중에서 개수가 0 인 누적 아이템 없에자
  for i := SaveItems.Count - 1 downto 0 do begin
    ps := UserEngine.GetStdItem(PTUserItem(SaveItems[i]).Index);
    if (ps <> nil) and (ps.OverlapItem >= 1) and (PTUserItem(SaveItems[i]).dura = 0)
    then begin
      Dispose(PTUserItem(SaveItems[i]));
      SaveItems.Delete(i);
      continue;
    end;
  end;

  //캐릭터 상태 시간 변수 설정
  for i := 0 to STATUSARR_SIZE - 1 do begin
    if StatusArr[i] > 0 then begin
      StatusTimes[i] := GetTickCount;
    end;
  end;
  CharStatus := GetCharStatus; //상태 얻어옴

  //잘못된 아이템이 계속 착용되는것을 체크함
  // 2003/03/15 아이템 인벤토리 확장
  for i := 0 to 12 do begin     // 8->12
    if UseItems[i].Index > 0 then begin
      ps := UserEngine.GetStdItem(UseItems[i].Index);
      if ps <> nil then begin
        if not IsTakeOnAvailable(i, ps) then begin //(예)칼에 옷이 오지 못하게 검사
          new(pi);
          pi^ := UseItems[i];
          AddItem(pi);
          UseItems[i].Index := 0;
        end;
      end else
        UseItems[i].Index := 0;
    end;
  end;

  for i := 0 to ItemList.Count - 1 do begin  //이벤트 아이템 검사
    ps := UserEngine.GetStdItem(PTUserItem(ItemList[i]).Index);
    if ps <> nil then begin
      if not BoServerShifted then begin  //맨 접속
        if ps.StdMode = TAIWANEVENTITEM then begin
          //대만 이벤트 아이템은 죽으면 떨구기 때문에 접속시에 들 수 없다.
          Dispose(PTUserItem(ItemList[i]));
          ItemList.Delete(i);
          continue;
        end;
      end else begin //서버 이동으로 접속
        if ps.StdMode = TAIWANEVENTITEM then begin
          TaiwanEventItemName := ps.Name;
          BoTaiwanEventUser := True;
          StatusArr[STATE_BLUECHAR] := 60000;  //타임 아웃 없음;
          Light := GetMyLight;
          SendRefMsg(RM_CHANGELIGHT, 0, 0, 0, 0, '');
          CharStatus := GetCharStatus;
        end;
      end;
    end;
  end;

  //가방에 중복된 아이디의 아이템이 있는지 검사.
  //잘 못 된 아이템, 지워져야 할 아이템 삭제
  for i := ItemList.Count - 1 downto 0 do begin
    iname := UserEngine.GetStdItemName(PTUserItem(ItemList[i]).Index);
    sidx  := PTUserItem(ItemList[i]).MakeIndex;
    for k := i - 1 downto 0 do begin
      pi := PTUserItem(ItemList[k]);
      if (iname = UserEngine.GetStdItemName(pi.Index)) and (sidx = pi.MakeIndex) then
      begin
        Dispose(pi);
        ItemList.Delete(k);
        break;
      end;
    end;
  end;


  SendMsg(self, RM_LOGON, 0, 0, 0, 0, '');

{$IFDEF FOR_ABIL_POINT}
//4/16일부터 적용
   //보너스 포인트가 있으면
   if BonusPoint > 0 then
      SendMsg (self, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
{$ENDIF}

  //너무 많이 밀집되어 있으면 다른 곳으로 이동 시킨다.
  // 2004/04/22 체험판 레벨 변경
  if Abil.Level <= EXPERIENCELEVEL then begin   // 7
    if (GetUserMassCount >= 80) then begin
      // 일단 범위 수정.(sonmg 2004/06/23)
      //         RandomSpaceMove (PEnvir.MapName, 0);
      RandomSpaceMoveInRange(0, 15, 30);
    end;
  end;

  //문파 대련 이벤트 방에서 살아 난 경우
  if MustRandomMove then begin
    RandomSpaceMove(PEnvir.MapName, 0);
  end;

  //ReadyRun := TRUE;
  UserDegree := UserEngine.GetMyDegree(UserName);
  CheckHomePos;  //피케이는 피케이 땅에서 시작

  //마법 검사,..  마법의 특수 능력 검사
  for i := 0 to MagicList.Count - 1 do begin
    CheckMagicSpecialAbility(PTUserMagic(MagicList[i]));
  end;

  //처음 시작할때, 목검 1개 평민복 한벌씩, 돈 0전..
  if FirstTimeConnection then begin
    case Job of
      0: begin
        if (Sex = 0) then itmlist := __GiveItemWarMan
        else itmlist := __GiveItemWarWoman;
      end;
      1: begin
        if (Sex = 0) then itmlist := __GiveItemWizMan
        else itmlist := __GiveItemWizWoman;
      end;
      2: begin
        if (Sex = 0) then itmlist := __GiveItemTaoMan
        else itmlist := __GiveItemTaoWoman;
      end;
      3: begin
        if (Sex = 0) then itmlist := __GiveItemKillMan
        else itmlist := __GiveItemKillWoman;
      end;
    end;

    while True do begin
      if itmlist = '' then break;
      itmlist := GetValidStr3(itmlist, iname, [' ', ',', #9]);
      if iname <> '' then begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(iname, pi^) then
          ItemList.Add(pi)
        else
          Dispose(pi);
      end else
        break;
    end;

    {new(pi);
    if UserEngine.CopyToUserItemFromName(__Candle, pi^) then
      ItemList.Add(pi)
    else
      Dispose(pi);
    new(pi);
    if UserEngine.CopyToUserItemFromName(__BasicDrug, pi^) then
      ItemList.Add(pi)
    else
      Dispose(pi);
    new(pi);
    if UserEngine.CopyToUserItemFromName(__WoodenSword, pi^) then
      ItemList.Add(pi)
    else
      Dispose(pi);
    if Sex = 0 then begin //남자;
      new(pi);
      if UserEngine.CopyToUserItemFromName(__ClothsForMan, pi^) then
        ItemList.Add(pi)
      else
        Dispose(pi);
    end else begin
      new(pi);
      if UserEngine.CopyToUserItemFromName(__ClothsForWoman, pi^) then
        ItemList.Add(pi)
      else
        Dispose(pi);
    end;}
  end;

  RecalcLevelAbilitys;
  RecalcAbilitys;  //또 호출 해야 함..
  Abil.MaxExp  := GetNextLevelExp(Abil.Level);
  // TO PDS;
  Wabil.MaxExp := Abil.MaxExp;

  if FreeGulityCount = 0 then begin
    PlayerKillingPoint := 0;
    Inc(FreeGulityCount);
  end;

  //가방에 돈는 MAXGOLD전 까지 들 수 있다.
  if Gold > BAGGOLD * 2 then
    Gold := BAGGOLD * 2;

  if not BoServerShifted then begin
    if (ClientVersion < VERSION_NUMBER) or (ClientVersion <> LoginClientVersion) or
      ((ClientCheckSum <> ClientCheckSumValue1) and
      (ClientCheckSum <> ClientCheckSumValue2) and
      (ClientCheckSum <> ClientCheckSumValue3)) then begin

      SysMsg('Program version is not adequate', 0);

      if CHINAVERSION then
        SysMsg('(http://www.legendofmir.com.cn)', 0);
      if KOREANVERSION then
        SysMsg('(http://www.mir2.co.kr)', 0);
      if ENGLISHVERSION then
        SysMsg('(http://www.legendofmir.net)', 0);
      if PHILIPPINEVERSION then
        SysMsg('(http://www.mir2.com.ph)', 0);
      if TAIWANVERSION then
        SysMsg('(http://www.mir2.com.tw)', 0);
{$IFNDEF DEBUG}
      if not BoClientTest then begin
        SysMsg('Connection was terminated.', 0);
        EmergencyClose := True;
        exit;
      end;
{$ENDIF}
    end;

    case HumAttackMode of
      HAM_ALL: SysMsg('[attack mode : Attack all mode]', 1);
      HAM_PEACE: SysMsg('[attack mode : Peaceful attack mode]', 1);
      HAM_GROUP: SysMsg('[attack mode : Group unit attack mode]', 1);
      HAM_GUILD: SysMsg('[attack mode : Guild unit attack mode]', 1);
      HAM_PKATTACK: SysMsg('[attack mode : Red & White fight mode]', 1);
    end;
    SysMsg('Change to attack mode : CTRL-H', 1);

    if BoTestServer then begin
      SysMsg(
        'This is a Test Server.  For rules on server operation please refer to our home page',
        1);

      //인원 제한
      if UserEngine.GetUserCount > TestServerMaxUser then begin
        if UserDegree < UD_OBSERVER then begin
          SysMsg('permissible number of player is full.', 0);
          SysMsg('Connection was terminated', 0);
          EmergencyClose := True;
        end;
      end;
    end;

    if ApprovalMode = 1 then begin //체험판 사용자, 테스트 서버는 공짜
      // 2004/04/22 체험래밸 7->20, 10만전 -> 500만전
      if not BoServerShifted then
        SysMsg('You are connected in trial mode, you can use this mode up to level '
          + IntToStr(EXPERIENCELEVEL) +
          'but there will be restrictions in some functions.', 1);
      AvailableGold := 5000000;  // 100000;  //체험판 사용자는 들 수 있는 돈이 제한됨
      if (Abil.Level > EXPERIENCELEVEL) then begin  //체험판으로 접속이 안됨
        SysMsg('The trial mode can be used up to level ' + IntToStr(
          EXPERIENCELEVEL), 0);
        SysMsg('connection was terminated.', 0);
        EmergencyClose := True;
      end;
    end;
    // 2003/03/18 테스트 서버 인원 제한
    //    if ApprovalMode > 3 then begin //무료사용자, 20일 한정 사용자
    if ApprovalMode = 3 then begin //무료사용자, 20일 한정 사용자
      if not BoServerShifted then
        SysMsg('It is free mode connection.', 1);
    end;

    if BoVentureServer then begin  //모험서버
      SysMsg('Welcome to adventure server', 1);
    end;

  end;

  Bright := MirDayTime;
  SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
  SendMsg(self, RM_SUBABILITY, 0, 0, 0, 0, '');
  SendMsg(self, RM_DAYCHANGING, 0, 0, 0, 0, '');
  SendMsg(self, RM_SENDUSEITEMS, 0, 0, 0, 0, '');
  SendMsg(self, RM_SENDMYMAGIC, 0, 0, 0, 0, '');

  //문파에 가입되어 있는지..
  MyGuild := GuildMan.GetGuildFromMemberName(UserName);
  if MyGuild <> nil then begin  //길드에 가입되어 있는 경우
    GuildRankName := TGuild(MyGuild).MemberLogin(self, GuildRank);
    //SendMsg (self, RM_CHANGEGUILDNAME, 0, 0, 0, 0, '');
    for i := 0 to TGuild(MyGuild).KillGuilds.Count - 1 do begin
      SysMsg(TGuild(MyGuild).KillGuilds[i] + ' is on guild war with your guild.', 1);
    end;

    // 서버 이동이 아닌 새로 접속했을 때만 적용.
    if not BoServerShifted then begin
      // 문주/문파원이 접속했을 때 장원이 연체되어 있다면 지난기간/남은기간을 알려줌.
      if GuildAgitMan.IsDelayed(TGuild(MyGuild).GuildName) then
        CmdGuildAgitRemainTime;

      // 접속했을 때 문파메시지(sonmg 2005/08/05)
      TGuild(MyGuild).GuildMsg('(!)' + UserName + ' has connected.', UserName);
      UserEngine.SendInterMsg(ISM_GUILDMSG, ServerIndex,
        TGuild(MyGuild).GuildName + '/' + '(!)' + UserName + ' has connected.');
    end;
  end;

  // 문파 가입 여부에 상관없이...
  // 서버 이동이 아닌 새로 접속했을 때만 적용.
  if not BoServerShifted then begin
    // 검색하여 할당된 장원이 없는데 장원 맵 안에 있다면 지정 맵/좌표로 강제 이동시킴.
    CmdGuildAgitExpulsionMyself;

    //최초 접속하면 DecoItemList를 보내준다.
    SendDecoItemList;
  end;

  if PLongHitSkill <> nil then
    if not BoAllowLongHit then begin
      BoAllowLongHit := True;
      SendSocket(nil, '+LNG');  //원거리 공격을 하게 한다.
    end;
   {if PWideHitSkill <> nil then  //
      if not BoAllowWideHit then begin
         BoAllowWideHit := TRUE;
         SendSocket (nil, '+WID');  //
      end;}

  //재접이 안되는 맵(서버 이동시에는 튕기지 않도록 수정 sonmg 2005/03/11)
  if (PEnvir.NoReconnect) and (not BoServerShifted) then begin
    RandomSpaceMove(PEnvir.BackMap, 0);
  end;

  // 2003/06/12 슬레이브 패치
  //소환 몹 부른다.
  if PrevServerSlaves.Count > 0 then begin
    for i := 0 to PrevServerSlaves.Count - 1 do begin
      plsave := PTSlaveInfo(PrevServerSlaves[i]);
      RmMakeSlaveProc(plsave);
      Dispose(plsave);
    end;
    PrevServerSlaves.Clear;
  end;

  if not BoServerShifted then begin  ////
    SendMsg(self, RM_DOSTARTUPQUEST, 0, 0, 0, 0, '');

  end;

  // 읽지않은 쪽지가 있음을 전송
  if NotReadTag > 0 then begin
    // 클라이언트에 데이터 전송
    SendMsg(Self, RM_TAG_ALARM, 0, NotReadTag, 0, 0, '');

    NotReadTag := 0;
  end;
  //연인 사제 데이터 불르기
  SendMsg(Self, RM_LM_DBWANTLIST, 0, 0, 0, 0, '');
end;

procedure TUserHuman.Finalize;
begin
  try
    if ReadyRun then
      Disappear(5); //로그인 성공 했어야.
  except
  end;

  if BoFixedHideMode then begin //고정 은신술.. 이동한경우에는 은신술이 풀린다.
    if BoHumHideMode then begin  // 접속을 끊으면 투명이 풀림
      StatusArr[STATE_TRANSPARENT] := 0;
    end;
  end;
  if BoTaiwanEventUser then begin
    StatusArr[STATE_BLUECHAR] := 0;
  end;

  try
    //내가 그룹짱이 아니면...
    if GroupOwner <> nil then begin
      GroupOwner.DelGroupMember(self);
    end else begin
      //내가 그룹 짱이면...
      DelGroupMember(self);
    end;
  except
  end;

  try
    if MyGuild <> nil then
      TGuild(MyGuild).MemberLogout(self);
  except
  end;

  //접속 기록을 남긴다.
  WriteConLog;

  inherited Finalize;
end;

procedure TUserHuman.WriteConLog;    //접속 기록.........
var
  contime: longword;
begin
  if (ApprovalMode = 2) or (BoTestServer) then begin //유료사용자 (테스트 서버 테스트용)
    contime := (GetTickCount - LoginTime) div 1000;  //초 단위
  end else begin
    contime := 0;
  end;

  AddConLog(UserAddress + ''#9 + UserId + ''#9 + UserName + ''#9 +
    IntToStr(contime) + ''#9 + FormatDateTime('yyyy-mm-dd hh:mm:ss', LoginDateTime) +
    ''#9 + FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + ''#9 +
    IntToStr(AvailableMode));
end;

procedure TUserHuman.SendSocket(pmsg: PTDefaultMessage; body: string);
var
  packetlen: integer;
  header:    TMsgHeader;
  pbuf:      PAnsiChar;
begin
  pbuf := nil;
  try
    header.Code    := integer($aa55aa55);
    header.SNumber := Userhandle;
    header.UserGateIndex := UserGateIndex;
    header.Ident   := GM_DATA;

    if pmsg <> nil then begin
      if body <> '' then begin
        header.Length := sizeof(TDefaultMessage) + Length(body) + 1;
        packetlen     := sizeof(TMsgHeader) + header.Length;
        GetMem(pbuf, packetlen + 4);
        Move(packetlen, pbuf^, 4);
        Move(header, (@pbuf[4])^, sizeof(TMsgHeader));
        Move(pmsg^, (@pbuf[4 + sizeof(TMsgHeader)])^, sizeof(TDefaultMessage));
        Move((@body[1])^, (@pbuf[4 + sizeof(TMsgHeader) + sizeof(TDefaultMessage)])^,
          Length(body) + 1);
      end else begin
        header.Length := sizeof(TDefaultMessage);
        packetlen     := sizeof(TMsgHeader) + header.Length;
        GetMem(pbuf, packetlen + 4);
        Move(packetlen, pbuf^, 4);
        Move(header, (@pbuf[4])^, sizeof(TMsgHeader));
        Move(pmsg^, (@pbuf[4 + sizeof(TMsgHeader)])^, sizeof(TDefaultMessage));
      end;
    end else begin
      if body <> '' then begin  //간단한 메세지
        header.Length := -(Length(body) + 1);  //길이가 마이너스 값으로 넘어간다.
        packetlen     := sizeof(TMsgHeader) + abs(header.Length);
        GetMem(pbuf, packetlen + 4);
        Move(packetlen, pbuf^, 4);
        Move(header, (@pbuf[4])^, sizeof(TMsgHeader));
        Move((@body[1])^, (@pbuf[4 + sizeof(TMsgHeader)])^, Length(body) + 1);
      end;
    end;

    HumanLock.Enter;
    try
      RunSocket.SendUserSocket(GateIndex, pbuf);
    finally
      HumanLock.Leave;
    end;

  except
    MainOutMessage('Exception SendSocket..');
  end;
end;

procedure TUserHuman.SendDefMessage(msg, recog, param, tag, series: integer;
  addstr: string);
begin
  Def := MakeDefaultMsg(msg, recog, param, tag, series);
  if addstr <> '' then
    SendSocket(@Def, EncodeString(addstr))
  else
    SendSocket(@Def, '');
end;

procedure TUserHuman.GuildRankChanged(rank: integer; rname: string);
begin
  GuildRank     := rank;
  GuildRankName := rname;
  SendMsg(self, RM_CHANGEGUILDNAME, 0, 0, 0, 0, '');
end;


{----------------------------------------------}

function TUserHuman.TurnXY(x, y, dir: integer): boolean;
begin
  Result := False;
  if (x = self.CX) and (y = self.CY) then begin
    self.Dir := dir;
    if Walk(RM_TURN) then begin
      Result := True;
    end;
  end;
end;

function TUserHuman.WalkXY(x, y: integer): boolean;
var
  ndir, oldx, oldy, dis: integer;
  allowdup: boolean;
begin
  Result := False;

  if GetTickCount - LatestWalkTime < 600 then begin
    Inc(WalkTimeOverCount);
    Inc(WalkTimeOverSum);
  end else begin
    WalkTimeOverCount := 0;
    if WalkTimeOverSum > 0 then
      Dec(WalkTimeOverSum);
  end;

  //dis := GetTickCount - LatestWalkTime;
  //MainOutMessage (IntToStr(dis));

  LatestWalkTime := GetTickCount;

  if (WalkTimeOverCount < 4) and (WalkTimeOverSum < 6) then begin
    SpaceMoved := False;
    oldx := self.CX;
    oldy := self.CY;
    ndir := GetNextDirection(CX, CY, x, y);

    allowdup := True;  //평상시에는 뛸때 겹칠 수 있음
    //if UserCastle.BoCastleUnderAttack then begin  //공성전 중인 경우
    //   if BoInFreePKArea then //프리피케이존(전쟁터)에 있음, 공성 지역에 있음
    //      allowdup := FALSE;  //공성전 지역에서는 겹칠 수 없음
    //end;

    if WalkTo(ndir, allowdup) then begin  //겹쳐지지 않게 함.
      if SpaceMoved or (CX = x) and (CY = y) then
        Result := True;
      Dec(HealthTick, 10);   //20
    end else begin           //걷기 실패
      WalkTimeOverCount := 0;
      WalkTimeOverSum   := 0;
    end;
  end else begin
    Inc(SpeedHackTimerOverCount);
    if SpeedHackTimerOverCount > 8 then
      EmergencyClose := True;

    if BoViewHackCode then
      MainOutMessage('[11002-Walk] ' + UserName + ' ' + TimeToStr(Time));
  end;
end;

function TUserHuman.RunXY(x, y: integer): boolean;
var
  ndir:     byte;
  dis:      integer;
  allowdup: boolean;
begin
  Result := False;
  if GetTickCount - LatestWalkTime < 600 then begin
    Inc(WalkTimeOverCount);
    Inc(WalkTimeOverSum);
  end else begin
    WalkTimeOverCount := 0;
    if WalkTimeOverSum > 0 then
      Dec(WalkTimeOverSum);
  end;

  //dis := GetTickCount - LatestWalkTime;
  //MainOutMessage (IntToStr(dis));

  LatestWalkTime := GetTickCount;

  if (WalkTimeOverCount < 4) and (WalkTimeOverSum < 6) then begin
    SpaceMoved := False;
    ndir := GetNextDirection(CX, CY, x, y);

    allowdup := True;  //평상시에는 뛸때 겹칠 수 있음
    if UserCastle.BoCastleUnderAttack then begin  //공성전 중인 경우
      if BoInFreePKArea then //프리피케이존(전쟁터)에 있음, 공성 지역에 있음
        allowdup := False;  //공성전 지역에서는 겹칠 수 없음
    end;

    if RunTo(ndir, allowdup) then begin
      if BoFixedHideMode then begin //고정 은신술..
        if BoHumHideMode then begin  //이동한경우에는 은신술이 풀린다.
          StatusArr[STATE_TRANSPARENT] := 1;
        end;
      end;
      if SpaceMoved or (CX = x) and (CY = y) then
        Result := True;
      Dec(HealthTick, 60); //150
      Dec(SpellTick, 10);
      SpellTick := _MAX(0, SpellTick);
      Dec(PerHealth);
      Dec(PerSpell);
    end else begin
      WalkTimeOverCount := 0;
      WalkTimeOverSum   := 0;
    end;
  end else begin
    Inc(SpeedHackTimerOverCount);
    if SpeedHackTimerOverCount > 8 then
      EmergencyClose := True;
    if BoViewHackCode then
      MainOutMessage('[11002-Run] ' + UserName + ' ' + TimeToStr(Time));
  end;
end;

procedure TUserHuman.GetRandomMineral;
var
  pi: PTUserItem;
begin
  if Itemlist.Count < MAXBAGITEM then begin
    case Random(120) of
      1..2: //금광석
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__GoldStone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      3..20: //은광석
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__SilverStone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      21..45: //철광석
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__SteelStone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      46..56: //흑철
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__BlackStone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      else //동광석
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__CopperStone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
    end;
  end;
end;

procedure TUserHuman.GetRandomGems;
var
  pi: PTUserItem;
begin
  if Itemlist.Count < MAXBAGITEM then begin
    case Random(120) of
      1..2: //백금
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__Gem1Stone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      3..20: //연옥
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__Gem2Stone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      21..45: //홍옥석
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__Gem4Stone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      else //자수정
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__Gem3Stone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
    end;
  end;
end;

//새로 추가된 MINE3 속성에서 나오는 광석들...(2004/11/03)
procedure TUserHuman.GetRandomMineral3;
var
  pi: PTUserItem;
begin
  if Itemlist.Count < MAXBAGITEM then begin
    case Random(240) of
      //         1..4: //금광석
      1..6: //금광석
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__GoldStone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      //         5..22: //은광석
      7..30: //은광석
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__SilverStone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      //         23..47: //철광석
      31..66: //철광석
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__SteelStone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      //         48..67: //흑철
      67..91: //흑철
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__BlackStone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      //         68..140: //동광석
      92..131: //동광석
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__CopperStone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      //         141..144: //백금
      132..137: //백금
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__Gem1Stone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      //         145..162: //연옥
      138..161: //연옥
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__Gem2Stone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      //         163..187: //홍옥석
      162..197: //홍옥석
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__Gem4Stone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
      else //자수정
      begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(__Gem3Stone, pi^) then begin
          //광석의 순도 적용....
          pi.Dura := GetPurity;
          ItemList.Add(pi);
          WeightChanged;
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;
    end;
  end;
end;

//광석을 캐다.
function TUserHuman.DigUpMine(x, y: integer): boolean;
var
  event, ev2: TEvent;
  desc: string;
begin
  Result := False;
  desc   := '';
  event  := TEvent(PEnvir.GetEvent(x, y));
  if event <> nil then begin
    if (event.EventType = ET_MINE) or (event.EventType = ET_MINE2) or
      (event.EventType = ET_MINE3) then
      if TStoneMineEvent(event).MineCount > 0 then begin
        TStoneMineEvent(event).MineCount := TStoneMineEvent(event).MineCount - 1;
        if Random(4) = 0 then begin  //캐기 성공
          ev2 := TEvent(PEnvir.GetEvent(CX, CY));
          if ev2 = nil then begin
            ev2 := TPileStones.Create(PEnvir, CX, CY, ET_PILESTONES,
              5 * 60 * 1000, True);
            EventMan.AddEvent(ev2);
          end else begin
            if ev2.EventType = ET_PILESTONES then
              TPileStones(ev2).EnlargePile;
          end;
          if Random(12) = 0 then begin  //광석 캐기 성공
            if event.EventType = ET_MINE then
              GetRandomMineral
            else if event.EventType = ET_MINE2 then
              GetRandomGems
            else
              GetRandomMineral3;
          end;
          desc := '1';
          DoDamageWeapon(5 + Random(15));
          Result := True;
        end;
      end else begin
        if GetTickCount - TStoneMineEvent(event).RefillTime > 10 * 60 * 1000 then
          //10분
          TStoneMineEvent(event).Refill;
      end;
  end;
  SendRefMsg(RM_HEAVYHIT, self.Dir, CX, CY, 0, desc);
end;

{       // 함수가 안불려지는 관계로 삭제함 2003-09-23 PDS OBJ_TYPE 도 검사안함
function  TUserHuman.TargetInSwordLongAttackRange: Boolean;
var
   i, j, k, xx, yy: integer;
   pm: PTMapInfo;
   inrange: Boolean;
   cret: TCreature;
begin
   Result := FALSE;
   if GetNextPosition (PEnvir, CX, CY, Dir, 2, xx, yy) then begin //2칸앞
      for i:=xx-1 to xx+1 do
         for j:=yy-1 to yy+1 do begin
            inrange := PEnvir.GetMapXY (i, j, pm);
            if inrange then begin
               if pm.ObjList <> nil then
                  for k:=0 to pm.ObjList.Count-1 do begin      // OBJ_TYPE 을 체크안하는데 이함수 자체가 안불려짐
                     cret := TCreature (PTAThing (pm.ObjList[k]).AObject);
                     if cret <> nil then
                        if (not cret.BoGhost) and (not cret.Death) and (cret <> self) and ((abs(CX-cret.CX) >= 2) or (abs(CY-cret.CY) >= 2)) then begin
                           if IsProperTarget (cret) then begin
                              Result := TRUE;
                              exit;
                           end;
                        end;
                  end;
            end;
         end;
   end;
end;
}
function TUserHuman.HitXY(hitid, x, y, dir: integer): boolean;
var
  fx, fy: integer;
  pstd:   PTStdItem;
begin
  Result := False;
  //MainOutMessage ('Hit ' + IntToStr(GetTickCount - LatestHitTime));
  //   if GetTickCount - LatestHitTime < longword(900) - longword(HitSpeed * 60) then begin //600 then
  if (GetTickCount - LatestHitTime) < longword(900 - (HitSpeed * 60)) then
  begin //600 then
    Inc(HitTimeOverCount);
    Inc(HitTimeOverSum);
  end else begin
    HitTimeOverCount := 0;
    if HitTimeOverSum > 0 then
      Dec(HitTimeOverSum);
  end;

  if (HitTimeOverCount < 4) and (HitTimeOverSum < 6) then begin
    if not self.Death then begin
      if (x = self.CX) and (y = self.CY) then begin    //자기자리에서만 공격가능
        Result := True;
        LatestHitTime := GetTickCount; //hit이 성공했을때만

        if (hitid = CM_HEAVYHIT) and          //예도검법에
          (UseItems[U_WEAPON].Index > 0) and  //무기들 들고 있고
          GetFrontPosition(self, fx, fy)      //앞에 자리가 있음
        then begin
          if not PEnvir.CanWalk(fx, fy, False{겹침허용안함}) then
          begin  //앞이 막힌곳..
                 //곡괭이질인지 검사한다.
            pstd := UserEngine.GetStdItem(UseItems[U_WEAPON].Index);
            if pstd <> nil then begin
              if pstd.Shape = 19 then begin //곡괭이
                if DigUpMine(fx, fy) then //캐내다..
                  SendSocket(nil, '=DIG');
                Dec(HealthTick, 30); //50
                Dec(SpellTick, 50);
                SpellTick := _MAX(0, SpellTick);
                Dec(PerHealth, 2);
                Dec(PerSpell, 2);
                exit;
              end;
            end;
          end;
        end;
        if hitid = CM_HIT then
          {inherited} HitHit(nil, HM_HIT, dir);
        if hitid = CM_HEAVYHIT then
          {inherited} HitHit(nil, HM_HEAVYHIT, dir);
        if hitid = CM_BIGHIT then
          {inherited} HitHit(nil, HM_BIGHIT, dir);
        if hitid = CM_POWERHIT then
          {inherited} HitHit(nil, HM_POWERHIT, dir);
        if hitid = CM_slashhit then
          {inherited} HitHit(nil, HM_slashhit, dir);
        if hitid = CM_LONGHIT then
          {inherited} HitHit(nil, HM_LONGHIT, dir);
        if hitid = CM_WIDEHIT then
          {inherited} HitHit(nil, HM_WIDEHIT, dir);
        if hitid = CM_WIDEHIT2 then
          {inherited} HitHit(nil, HM_WIDEHIT2, dir);
        if hitid = CM_FIREHIT then
          {inherited} HitHit(nil, HM_FIREHIT, dir);
        // 2003/03/15 신규무공
        if hitid = CM_CROSSHIT then
          {inherited} HitHit(nil, HM_CROSSHIT, dir);
        if hitid = CM_TWINHIT then
          {inherited} HitHit(nil, HM_TWINHIT, dir);

        //Power Hit을 칠수 있는 검법을 익혔고, 검(무기)을 들고 있는 경우
        //나중에 검과, 도끼(5, 6)를 구분하여 검법을 만든다.
        if (PPowerHitSkill <> nil) and (UseItems[U_WEAPON].Index > 0) then begin
          Dec(AttackSkillCount);
          if AttackSkillPointCount = AttackSkillCount then begin
            BoAllowPowerHit := True;
            SendSocket(nil, '+PWR');
            //클라이언트에 다음번에 powerhit을 때리도로 함
          end;
          if AttackSkillCount <= 0 then begin
            AttackSkillCount      := 7 - PPowerHitSkill.Level;
            AttackSkillPointCount := Random(AttackSkillCount);
          end;
        end;

        if (PslashhitSkill <> nil) and (UseItems[U_WEAPON].Index > 0) then begin
          Dec(AttackSkillCount);
          if AttackSkillPointCount = AttackSkillCount then begin
            BoAllowslashhit := True;
            SendSocket(nil, '+SLS');
            //클라이언트에 다음번에 powerhit을 때리도로 함
          end;
          if AttackSkillCount <= 0 then begin
            AttackSkillCount      := 7 - PslashhitSkill.Level;
            AttackSkillPointCount := Random(AttackSkillCount);
          end;
        end;

        Dec(HealthTick, 30); //100
        Dec(SpellTick, 100);
        SpellTick := _MAX(0, SpellTick);
        Dec(PerHealth, 2);
        Dec(PerSpell, 2);
      end else
        Result := False;
    end;
  end else begin
    LatestHitTime := GetTickCount;

    Inc(SpeedHackTimerOverCount);
    if SpeedHackTimerOverCount > 8 then
      EmergencyClose := True;
    if BoViewHackCode then
      MainOutMessage('[11000-Hit] ' + UserName + ' ' + TimeToStr(Time));

    //SysMsg ('recorded as user of hacking program .', 0);
    //SysMsg ('Please be noted your account can be seizied .', 0);

    //SysMsg ('CODE=11000 Please contact to game master(support@legendofmir.net)', 0);
    //EmergencyClose := TRUE;
  end;
end;

function TUserHuman.GetMagic(mid: integer): PTUserMagic;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to MagicList.Count - 1 do begin
    if PTUserMagic(MagicList[i]).pDef.MagicId = mid then begin
      Result := PTUserMagic(MagicList[i]);
      break;
    end;
  end;
end;

function TUserHuman.SpellXY(magid, targetx, targety, targcret: integer): boolean;
var
  i, ndir, magnum, spell: integer;
  targ: TCreature;
  pum:  PTUserMagic;
  fail: boolean;
begin
  Result := False;
  //MainOutMessage ('Delay ' + InttoStr(GetTickCount - LatestSpellTime) + ' ' + IntToStr(LatestSpellDelay));
  if (StatusArr[POISON_STONE] <> 0) or (StatusArr[POISON_STUN] <> 0) or
    (StatusArr[POISON_ICE] <> 0) then begin  //마비된 상태인 경우
    exit;
  end;

  if GetTickCount - LatestSpellTime > longword(LatestSpellDelay) then
    SpellTimeOverCount := 0
  else
    Inc(SpellTimeOverCount);

  if SpellTimeOverCount < 2 then begin
    //magid로 magnum를 얻어옴.
    pum := nil;
    Dec(SpellTick, 450);
    SpellTick := _MAX(0, SpellTick);

    pum := GetMagic(magid);
    if pum <> nil then begin

      if MagicMan.IsSwordSkill(pum.MagicId) then
        LatestSpellDelay := 0 //pum.pDef.DelayTime + 200  //검법 딜레이
      else
        LatestSpellDelay := pum.pDef.DelayTime + 800; //마법 딜레이
      LatestSpellTime := GetTickCount;
      //마지막으로 마법을 쓴 시간이 이후로 부터 마법 딜레이
      //이후에 들어온 마법만을 허용한다.
      case pum.MagicId of
        SWD_LONGHIT:  //어검술
        begin
          if PLongHitSkill <> nil then begin
            if not BoAllowLongHit then begin
              SetAllowLongHit(True);
              SendSocket(nil, '+LNG');  //원거리 공격을 하게 한다.
            end else begin
              SetAllowLongHit(False);
              SendSocket(nil, '+ULNG');  //원거리 공격을 안하게 한다.
            end;
          end;
          Result := True;
        end;
        SWD_WIDEHIT:  //반월검법
        begin
          if PWideHitSkill <> nil then begin
            if not BoAllowWideHit then begin
              if BoAllowCrossHit then begin
                SetAllowCrossHit(False);
                SendSocket(nil, '+UCRS');  // 광풍참 사용안함
              end;
              SetAllowWideHit(True);
              SendSocket(nil, '+WID');  // 반월검법 사용
            end else begin
              SetAllowWideHit(False);
              SendSocket(nil, '+UWID');  // 반월검법 사용안함
            end;
          end;
          Result := True;
        end;
        SWD_WIDEHIT2:  //Assassin Skill 2
        begin
          if PWideHit2Skill <> nil then begin
            if not BoAllowWideHit2 then begin
              if BoAllowCrossHit then begin
                SetAllowCrossHit(False);
                SendSocket(nil, '+UCRS');  // 광풍참 사용안함
              end;
              SetAllowWideHit2(True);
              SendSocket(nil, '+WID2');  // 반월검법 사용
            end else begin
              SetAllowWideHit2(False);
              SendSocket(nil, '+UWID2');  // 반월검법 사용안함
            end;
          end;
          Result := True;
        end;
        SWD_FIREHIT:  //염화결
        begin
          if PFireHitSkill <> nil then begin
            if SetAllowFireHit then begin
              spell := GetSpellPoint(pum);
              if (WAbil.MP >= spell) then begin
                if (spell > 0) then begin
                  DamageSpell(spell);
                  HealthSpellChanged;
                end;
                SendSocket(nil, '+FIR');
              end else
              ;
            end;
            Result := True;
          end;
        end;
        SWD_RUSHRUSH:  //무태보
        begin
          Result := True;
          if GetTickCount - LatestRushRushTime > 3000 then begin
            LatestRushRushTime := GetTickCount;
            Dir   := targetx; //방향 전환
            //if GetTickCount - LatestRushRushTime >= 3000
            spell := GetSpellPoint(pum);
            if (spell > 0) then begin
              if (WAbil.MP >= spell) then begin
                DamageSpell(spell);
                HealthSpellChanged;
              end else
                exit;  //마력모자람
            end;
            if CharRushRush(Dir, pum.Level, True) then begin
              if (pum.Level < 3) then
                if Abil.Level >= pum.pDef.NeedLevel[pum.Level] then begin
                  //수련레벨에 도달한 경우
                  TrainSkill(pum, 1 + Random(3));
                  if not CheckMagicLevelup(pum) then
                    SendDelayMsg(self, RM_MAGIC_LVEXP,
                      0, pum.pDef.MagicId, pum.Level, pum.CurTrain, '', 1000);
                end;
            end;
          end;
        end;
        // 2003/03/15 신규무공
        SWD_CROSSHIT:   // 광풍참
        begin
          if PCrossHitSkill <> nil then begin
            if not BoAllowCrossHit then begin
              if BoAllowWideHit then begin
                SetAllowWideHit(False);
                SendSocket(nil, '+UWID');  // 반월검법 사용안함
              end;
              SetAllowCrossHit(True);
              SendSocket(nil, '+CRS');  // 광풍참 사용
            end else begin
              SetAllowCrossHit(False);
              SendSocket(nil, '+UCRS');  // 광풍참 사용안함
            end;
          end;
          Result := True;
        end;
        SWD_TWINHIT:  //쌍룡참
        begin
          if PTwinHitSkill <> nil then begin
            if SetAllowTwinHit then begin
              spell := GetSpellPoint(pum);
              if (WAbil.MP >= spell) then begin
                if (spell > 0) then begin
                  DamageSpell(spell);
                  HealthSpellChanged;
                end;
                SendSocket(nil, '+TWN');
              end else
              ;
            end;
            Result := True;
          end;
        end;

        else begin
          ndir := GetNextDirection(CX, CY, targetx, targety);
          Dir  := ndir;
          targ := nil;
          if CretInNearXY(TCreature(targcret), targetx, targety) then begin
            targ    := TCreature(targcret);
            targetx := targ.CX;
            targety := targ.CY;
          end;
          if not DoSpell(pum, targetx, targety, targ) then
            SendRefMsg(RM_MAGICFIRE_FAIL, 0, 0, 0, 0, '');
          Result := True;
        end;

      end;
    end;
  end else begin
    pum := GetMagic(magid);
    if pum <> nil then begin
      if MagicMan.IsSwordSkill(pum.MagicId) then begin
        SpellTimeOverCount := 0;
        exit;  //검법키..
      end;
    end;
    LatestSpellTime := GetTickCount;

    Inc(SpeedHackTimerOverCount);
    if SpeedHackTimerOverCount > 8 then
      EmergencyClose := True;

    if BoViewHackCode then
      MainOutMessage('[11001-Mag] ' + UserName + ' ' + TimeToStr(Time));

    //SysMsg ('recorded as user of hacking program .', 0);
    //SysMsg ('Please be noted your account can be seizied .', 0);
    //MakePoison (POISON_DECHEALTH, 30, 1);
    //MakePoison (POISON_STONE, 5, 0); //중독에 걸리게 함
    //SysMsg ('CODE=11001 Please contact to game master.(support@legendofmir.net)', 0);
    //EmergencyClose := TRUE;
  end;
end;

function TUserHuman.SitdownXY(x, y, dir: integer): boolean;
begin
  SendRefMsg(RM_SITDOWN, 0, 0, 0, 0, '');
  Result := True;
end;


{----------------------------------------------------------}

//운영자 명령어...

procedure TUserHuman.ChangeSkillLevel(magname: string; lv: byte);
var
  i: integer;
begin
  lv := _MIN(3, lv);
  for i := MagicList.Count - 1 downto 0 do begin
    if CompareText(PTUserMagic(MagicList[i]).pDef.MagicName, magname) = 0 then begin
      PTUserMagic(MagicList[i]).Level := lv;
      SendMsg(self, RM_MAGIC_LVEXP, 0,
        PTUserMagic(MagicList[i]).pDef.MagicId,
        PTUserMagic(MagicList[i]).Level,
        PTUserMagic(MagicList[i]).CurTrain,
        '');
      SysMsg(magname + ' training level' + IntToStr(lv) + ', was changed ', 1);
    end;
  end;
end;

procedure TUserHuman.CmdMakeFullSkill(magname: string; lv: byte);
begin
  ChangeSkillLevel(magname, lv);
end;

procedure TUserHuman.CmdMakeOtherChangeSkillLevel(who, magname: string; lv: byte);
var
  hum: TUserHuman;
begin
  hum := UserEngine.GetUserHuman(who);
  if hum <> nil then begin
    hum.ChangeSkillLevel(magname, lv);
  end else
    SysMsg(who + '  is not found.', 0);
end;

function TUserHuman.CmdDeletePKPoint(whostr: string): boolean;
var
  hum: TUserHuman;
begin
  Result := False;
  hum    := UserEngine.GetUserHuman(whostr);
  if hum <> nil then begin
    hum.PlayerKillingPoint := 0; //면죄
    hum.ChangeNameColor;
    SysMsg(whostr + ' : PK point = 0.', 1);
    Result := True;
  end else
    SysMsg(whostr + '  is not found.', 0);
end;

procedure TUserHuman.CmdSendPKPoint(whostr: string; Value: integer);
var
  hum: TUserHuman;
begin
  hum := UserEngine.GetUserHuman(whostr);
  if hum <> nil then begin
    if Value > 0 then
      hum.PlayerKillingPoint := Value;
    SysMsg(whostr + ' PK point = ' + IntToStr(hum.PlayerKillingPoint), 1);
  end else
    SysMsg(whostr + '  is not found.', 0);
end;

procedure TUserHuman.CmdChangeJob(jobname: string);
begin
  if CompareText(jobname, 'Warrior') = 0 then
    Job := 0;
  if CompareText(jobname, 'Wizard') = 0 then
    Job := 1;
  if CompareText(jobname, 'Taoist') = 0 then
    Job := 2;
  if CompareText(jobname, 'Assassin') = 0 then
    Job := 3;
end;

procedure TUserHuman.CmdChangeSex;
begin
  if Sex = 0 then
    Sex := 1
  else
    Sex := 0;
end;

procedure TUserHuman.CmdCallMakeMonster(monname, param: string);
var
  nx, ny, i, Count: integer;
begin
  // 마리수 맨처음자리에 0이 붙어있으면 에러.
  if param <> '' then begin
    if param[1] = '0' then
      exit;
  end;

  Count := _MIN(100, Str_ToInt(param, 1));


  GetFrontPosition(self, nx, ny);
  for i := 0 to Count - 1 do begin
    UserEngine.AddCreatureSysop(MapName, nx, ny, monname);
  end;
end;

procedure TUserHuman.CmdCallMakeSlaveMonster(monname, param: string;
  makelv, explv: byte);
var
  nx, ny, i, Count: integer;
  cret: TCreature;
begin
  Count := Str_ToInt(param, 1);
  if not (makelv in [0..7]) then
    makelv := 0;
  if not (explv in [0..7]) then
    explv := 0;
  for i := 0 to Count - 1 do begin
    if SlaveList.Count < 20 then begin
      GetFrontPosition(self, nx, ny);
      cret := UserEngine.AddCreatureSysop(MapName, nx, ny, monname);
      if cret <> nil then begin
        //if cret.LifeAttrib <> LA_UNDEAD then begin
        cret.Master := self;  //소환몹을 뺏어온다.
        cret.MasterRoyaltyTime := GetTickCount + 10 * 24 * 60 * 60 * 1000;
        cret.SlaveMakeLevel := makelv;
        cret.SlaveExpLevel := explv;
        cret.MasterFeature := GetRelFeature(self); // 분신
        cret.UserNameChanged;
        // 2003/03/04 리콜몹 능력치 재계산
        cret.RecalcAbilitys;

        SlaveList.Add(cret);
        //end;
      end;
    end;
  end;
end;

procedure TAnimal.CmdCallMakeSlaveMonster(monname, param: string;
  makelv, explv: byte);
var
  nx, ny, i, Count: integer;
  cret: TCreature;
begin
  Count := Str_ToInt(param, 1);
  if not (makelv in [0..7]) then
    makelv := 0;
  if not (explv in [0..7]) then
    explv := 0;
  for i := 0 to Count - 1 do begin
    if SlaveList.Count < 20 then begin
      GetFrontPosition(self, nx, ny);
      cret := UserEngine.AddCreatureSysop(MapName, nx, ny, monname);
      if cret <> nil then begin
        //if cret.LifeAttrib <> LA_UNDEAD then begin
        cret.Master := self;  //소환몹을 뺏어온다.
        cret.MasterRoyaltyTime := GetTickCount + 10 * 24 * 60 * 60 * 1000;
        cret.SlaveMakeLevel := makelv;
        cret.SlaveExpLevel := explv;
        cret.MasterFeature := GetRelFeature(self); // 분신
        cret.UserNameChanged;
        // 2003/03/04 리콜몹 능력치 재계산
        cret.RecalcAbilitys;

        SlaveList.Add(cret);
        //end;
      end;
    end;
  end;
end;

procedure TCreature.CmdCallMakeSlaveMonster(monname, param: string;
  makelv, explv: byte);
var
  nx, ny, i, Count: integer;
  cret: TCreature;
begin
  Count := Str_ToInt(param, 1);
  if not (makelv in [0..7]) then
    makelv := 0;
  if not (explv in [0..7]) then
    explv := 0;
  for i := 0 to Count - 1 do begin
    if SlaveList.Count < 20 then begin
      GetFrontPosition(self, nx, ny);
      cret := UserEngine.AddCreatureSysop(MapName, nx, ny, monname);
      if cret <> nil then begin
        //if cret.LifeAttrib <> LA_UNDEAD then begin
        cret.Master := self;  //소환몹을 뺏어온다.
        cret.MasterRoyaltyTime := GetTickCount + 10 * 24 * 60 * 60 * 1000;
        cret.SlaveMakeLevel := makelv;
        cret.SlaveExpLevel := explv;
        cret.MasterFeature := GetRelFeature(self); // 분신
        cret.UserNameChanged;
        // 2003/03/04 리콜몹 능력치 재계산
        cret.RecalcAbilitys;

        SlaveList.Add(cret);
        //end;
      end;
    end;
  end;
end;

procedure TUserHuman.CmdMissionSetting(xstr, ystr: string);
var
  xx, yy: integer;
begin
  if xstr = '' then begin
    BoSysHasMission := False;
    SysMsg('mission cancelled', 1);
  end else begin
    xx := Str_ToInt(xstr, 0);
    yy := Str_ToInt(ystr, 0);
    BoSysHasMission := True;
    SysMission_Map := MapName;
    SysMission_X := xx;
    SysMission_Y := yy;
    SysMsg('Mission: attack target' + MapName + ' ' + IntToStr(xx) +
      ':' + IntToStr(yy), 1);
  end;
end;

procedure TUserHuman.CmdCallMakeMonsterXY(xstr, ystr, monname, countstr: string);
var
  i, Count, xx, yy: integer;
  penv: TEnvirnoment;
  cret: TCreature;
begin
  if not BoSysHasMission then begin
    SysMsg('Mission not specified', 0);
    exit;
  end;
  Count := _MIN(500, Str_ToInt(countstr, 0));
  xx    := Str_ToInt(xstr, 0);
  yy    := Str_ToInt(ystr, 0);
  penv  := GrobalEnvir.GetEnvir(SysMission_Map);
  if (penv <> nil) and (Count > 0) and (xx > 0) and (yy > 0) then begin
    for i := 0 to Count - 1 do begin
      cret := UserEngine.AddCreatureSysop(SysMission_Map, xx, yy, monname);
      if (cret <> nil) and (BoSysHasMission) then begin
        cret.BoHasMission := True;
        cret.Mission_X    := SysMission_X;
        cret.Mission_Y    := SysMission_Y;
      end;
    end;
    SysMsg(SysMission_Map + ' ' + IntToStr(xx) + ':' + IntToStr(yy) +
      ' => ' + monname + ' ' + IntToStr(Count) + ' heads', 1);
  end else
    SysMsg('command error: X Y MobName Number', 0);
end;

procedure TUserHuman.CmdMakeItem(itmname: string; Count: integer);
var
  i:    integer;
  pu, putemp: PTUserItem;
  pstd: PTStdItem;
  Num:  integer;
begin
  //한번에 만들 수 있는 아이템 개수 제한.
  if Count > MAX_OVERLAPITEM then
    exit;

  for i := 0 to Count - 1 do begin
    if ItemList.Count >= MAXBAGITEM then
      break;
    new(pu);
    if UserEngine.CopyToUserItemFromName(itmname, pu^) then begin
      pstd := UserEngine.GetStdItem(pu.Index);

      if pstd <> nil then begin
        if pstd.Price >= 15000 then begin
          //가격이 15000원 이상은 superadmin만 만들 수 있다.
          if not BoTestServer and (UserDegree < UD_ADMIN) then begin
            Dispose(pu);
            exit;
          end;
        end;

        //pu.Dura := Round((pu.Dura / 100) * (100 + Random(100)));

        if Random(10) = 0 then
          UserEngine.RandomUpgradeItem(pu);

        //미지 시리즈 아이템인 경우
        if pstd.StdMode in [15, 19, 20, 21, 22, 23, 24, 26, 52, 53, 54] then begin
          if (pstd.Shape = RING_OF_UNKNOWN) or
            (pstd.Shape = BRACELET_OF_UNKNOWN) or
            (pstd.Shape = HELMET_OF_UNKNOWN) then begin
            UserEngine.RandomSetUnknownItem(pu);
          end;
        end;

        //초대장을 만드는 경우(sonmg)
        if pstd.StdMode = 8 then begin
          if pstd.Shape = SHAPE_OF_INVITATION then begin
            if GuildAgitInvitationItemSet(pu) = False then begin
              SysMsg(
                'You can get an Invitation only in your guild territory.', 0);
              Dispose(pu);
              exit;
            end;
          end;
        end;

        //상현주머니(DecoItem)를 만드는 경우(sonmg)
        if (pstd.StdMode = STDMODE_OF_DECOITEM) and
          (pstd.Shape = SHAPE_OF_DECOITEM) then begin
          // 임시로 설정.
          Num := Count;//Random(16);   //임시
          if GuildAgitDecoItemSet(pu, Num) = False then begin
            //                   SysMsg('등록된 장원에서만 아이템을 얻을 수 있습니다.', 0);
            Dispose(pu);
            exit;
          end;
        end;


        // gadget:카운트아이템
        if pstd.OverlapItem >= 1 then begin
          pu.Dura := Count;

          ItemList.Add(pu);
          SendAddItem(pu^);
        end else begin
          // 광석 순도 조절
          if pstd.StdMode = 43 then begin
            pu.Dura := GetPurity;
          end;

          ItemList.Add(pu);
          SendAddItem(pu^);
        end;

        if BoEcho then begin
          MainOutMessage('[MakeItem] ' + UserName + ' : ' + itmname +
            ' ' + IntToStr(pu.MakeIndex));
          //로그남김
          AddUserLog('5'#9 + //운만_
            MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
            ''#9 + UserName + ''#9 + UserEngine.GetStdItemName(pu.Index) +
            ''#9 + IntToStr(pu.MakeIndex) + ''#9 + '1'#9 + '0');
        end;

        // 카운트아이템은 1번만 만든다.
        if pstd.OverlapItem >= 1 then
          break;  // gadget:카운트아이템
        // 상현주머니도 1번만 만든다.
        if (pstd.StdMode = STDMODE_OF_DECOITEM) and
          (pstd.Shape = SHAPE_OF_DECOITEM) then
          break;
      end;
    end else begin
      Dispose(pu);
      break;
    end;
  end;

  WeightChanged;
end;

procedure TUserHuman.CmdRefineWeapon(dc, mc, sc, acc: integer);
begin
  if dc + mc + sc > 10 then
    exit;
  if UseItems[U_WEAPON].Index > 0 then begin
    UseItems[U_WEAPON].Desc[0] := dc;
    UseItems[U_WEAPON].Desc[1] := mc;
    UseItems[U_WEAPON].Desc[2] := sc;
    UseItems[U_WEAPON].Desc[5] := acc;
    SendUpdateItem(UseItems[U_WEAPON]);
    RecalcAbilitys;
    SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
    SendMsg(self, RM_SUBABILITY, 0, 0, 0, 0, '');
  end;
end;

procedure TUserHuman.CmdDeleteUserGold(whostr, goldstr: string);
var
  hum: TUserHuman;
  igold, svidx: integer;
begin
  hum   := UserEngine.GetUserHuman(whostr);
  igold := Str_ToInt(goldstr, 0);
  if igold <= 0 then
    exit;
  if hum <> nil then begin
    if hum.Gold > igold then //hum.Gold := hum.Gold - igold
      hum.DecGold(igold)
    else begin
      igold    := hum.Gold; //실제로 사라진양
      hum.Gold := 0;
    end;
    hum.GoldChanged;
    SysMsg(whostr + ' Gold of ' + IntToStr(igold) + ' Gold was deleted.', 1);
    //로그남김
    AddUserLog('13'#9 + //돈삭_
      MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) + ''#9 +
      UserName + ''#9 + NAME_OF_GOLD{'금전'} + ''#9 + IntToStr(igold) +
      ''#9 + '1'#9 + whostr);
  end else begin
    if UserEngine.FindOtherServerUser(whostr, svidx) then begin
      SysMsg(whostr + ' is ' + IntToStr(svidx) +
        ' no., he(she) is connected to that server.', 1);
    end else
      FrontEngine.ChangeUserInfos(UserName, whostr, -igold);
    //SysMsg (whostr + ' Gold of ' + IntToStr(igold) + ' gold was deleted. (excecute command of  DelGold)', 1);
  end;
end;

procedure TUserHuman.CmdAddUserGold(whostr, goldstr: string);
var
  hum: TUserHuman;
  igold, svidx: integer;
begin
  hum   := UserEngine.GetUserHuman(whostr);
  igold := Str_ToInt(goldstr, 0);
  if igold <= 0 then
    exit;
  if hum <> nil then begin
    if hum.Gold + igold < AvailableGold then //hum.Gold := hum.Gold + igold
      hum.IncGold(igold)
    else begin
      igold    := AvailableGold - hum.Gold; //실제로 사라진양
      hum.Gold := AvailableGold;
    end;
    hum.GoldChanged;
    SysMsg(whostr + ' Gold of ' + IntToStr(igold) + ' gold was added.', 1);
    //로그남김
    AddUserLog('14'#9 + //돈추_
      MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) + ''#9 +
      UserName + ''#9 + NAME_OF_GOLD{'금전'} + ''#9 + IntToStr(igold) +
      ''#9 + '1'#9 + whostr);
  end else begin
    if UserEngine.FindOtherServerUser(whostr, svidx) then begin
      SysMsg(whostr + ' is ' + IntToStr(svidx) +
        ' no., he(she) is connected to that server.', 1);
    end else
      FrontEngine.ChangeUserInfos(UserName, whostr, igold);
    //SysMsg ('  is not found.', 0);
  end;
end;

procedure TUserHuman.RCmdUserChangeGoldOk(whostr: string; igold: integer);
var
  cmdstr, msgstr: string;
begin
  if igold > 0 then begin
    cmdstr := '14'#9; //돈추_;
    msgstr := 'Added';
  end else begin
    cmdstr := '13'#9; //돈삭_;
    msgstr := 'Deleted';
    igold  := -igold;
  end;
  SysMsg(whostr + ' Gold of ' + IntToStr(igold) + 'Gold ' + msgstr, 1);
  //로그 남김
  AddUserLog(cmdstr + MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
    ''#9 + UserName + ''#9 + NAME_OF_GOLD{'금전'} + ''#9 + IntToStr(igold) +
    ''#9 + '1'#9 + whostr);
end;

procedure TUserHuman.CmdFreeSpaceMove(map, xstr, ystr: string);
var
  x, y: integer;
  pev:  TEnvirnoment;
begin
  pev := GrobalEnvir.GetEnvir(map);
  if pev <> nil then begin
    x := Str_ToInt(xstr, 0);
    y := Str_ToInt(ystr, 0);
    if pev.CanWalk(x, y, True) then begin
      SpaceMove(map, x, y, 0);
    end else
      SysMsg('Fail', 0);
  end else
    SysMsg('Fail', 0);
end;

procedure TUserHuman.CmdCharSpaceMove(CharName_: string);
var
  hum:   TUserHuman;
  svidx: integer;
begin
  hum := UserEngine.GetUserHuman(Charname_);

  if hum <> nil then begin
    SpaceMove(hum.PEnvir.MapName, hum.CX, hum.CY + 1, 0);
  end else begin
    if UserEngine.FindOtherServerUser(Charname_, svidx) then begin
      UserEngine.SendInterMsg(ISM_REQUEST_RECALL, svidx, Charname_ + '/' + UserName);
    end else begin
      SysMsg('Cannot Find ' + CharName_, 0);
    end;
  end;

end;

procedure TUserHuman.CmdBreakLoverRelation;
var
  svidx: integer;
  ReqType: integer;
  OtherName: string;
  hum: TUserHuman;
  strPayment: string;
begin
  // 위자료 낼 돈이 있는지 확인
  if Gold < COMPENSATORY_PAYMENT_ONEWAY then begin
    strPayment := IntToStr(COMPENSATORY_PAYMENT_ONEWAY div 10000);
    BoxMsg('To break the relationship with your lover, you need ' +
      strPayment + '0,000 Gold.', 0);
    exit;
  end;

  if fLover = nil then
    exit;

  OtherName := fLover.GetLoverName;
  if OtherName = '' then
    exit;

  ReqType := RsState_Lover;

  //연인 일방 해제(2004/12/13)
  if RelationShipDeleteOther(ReqType, OtherName) then begin

    //위자료 지불
    if Gold >= COMPENSATORY_PAYMENT_ONEWAY then begin
      DecGold(COMPENSATORY_PAYMENT_ONEWAY);
      GoldChanged;
    end;
    //상태 변경(둔화)
    MakePoison(POISON_SLOW, 3, 1);
    //HP, MP 변경(10%)
    WAbil.HP := _MAX(1, WAbil.HP div 10);
    WAbil.MP := _MAX(1, WAbil.MP div 10);

    //충격 메시지
    SysMsg('Lovers'' relationship broken. A shock caused by the end of the relationship is applied.', 0);

    hum := UserEngine.GetUserHuman(OtherName);
    if hum <> nil then begin
      hum.RelationShipDeleteOther(ReqType, UserName);

      //로그남김
      AddUserLog('47'#9 + //연인_
        MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) + ''#9 +
        UserName + ''#9 + '0'#9 + '0'#9 + '1'#9 +  //일방해제:1
        OtherName);
      ///////////////////////////////////////////////////////////
      //일방적인 해제인 경우에는 상대에게 충격이 전해지지 않음.
      ///////////////////////////////////////////////////////////
    end else begin
      if UserEngine.FindOtherServerUser(OtherName, svidx) then begin
        UserEngine.SendInterMsg(ISM_LM_DELETE, svidx, OtherName +
          '/' + UserName + '/' + IntToStr(ReqType));
      end;
    end;

  end else begin
    SendDefMessage(SM_LM_RESULT, ReqType, RsError_DontDelete, 0, 0, OtherName);
  end;
end;


procedure TUserHuman.CmdStealth;
begin
  bStealth := not bStealth;

  if bStealth then
    SysMsg('Stealth On', 0)
  else
    SysMsg('Stealth Off', 0);
end;

procedure TUserHuman.CmdCharMove(CharName_: string; MapName: string);
var
  hum: TUserHuman;
begin
  hum := UserEngine.GetUserHuman(CharName_);

  if hum <> nil then begin
    if GrobalEnvir.GetEnvir(MapName) <> nil then begin
      hum.SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
      hum.RandomSpaceMove(MapName, 0); //무작위 공간이동
    end;
  end else begin
    SysMsg('Cannot Find ' + CharName_, 0);
  end;

end;

procedure TUserHuman.CmdRushAttack;
begin
  CharRushRush(Dir, 3, True);
end;

procedure TUserHuman.CmdManLevelChange(man: string; level: integer);
var
  oldlv: integer;
  hum:   TUserHuman;
begin
  hum := UserEngine.GetUserHuman(man);
  if hum <> nil then begin
    MainOutMessage('ChgLv] ' + man + ' : ' + IntToStr(hum.Abil.Level) +
      ' -> ' + IntToStr(level) + ' by ' + UserName);
    oldlv := hum.Abil.Level;
    hum.ChangeLevel(level);
    hum.HasLevelUp(oldlv);
    //로그를 남긴다
    AddUserLog('17'#9 + //타레_
      man + ''#9 + IntToStr(oldlv) + ''#9 + IntToStr(level) + ''#9 +
      UserName + ''#9 + '0'#9 + '0'#9 + '1'#9 + '0');
    SysMsg('[AdjustLevel] ' + man + ' ' + IntToStr(oldlv) + '->' +
      IntToStr(level), 1);
  end;
end;

procedure TUserHuman.CmdManExpChange(man: string; exp: integer);
var
  hum:    TUserHuman;
  oldexp: integer;
begin
  hum := UserEngine.GetUserHuman(man);
  if hum <> nil then begin
    MainOutMessage('ChgExp] ' + man + ' : ' + IntToStr(hum.Abil.Exp) +
      ' -> ' + IntToStr(Exp) + ' by ' + UserName);
    oldexp := hum.Abil.Exp;
    hum.Abil.Exp := exp;  //ChangeLevel (level);
    hum.HasLevelUp(Abil.Level);
    //로그를 남긴다
    AddUserLog('18'#9 + //타경_
      man + ''#9 + IntToStr(oldexp) + ''#9 + IntToStr(exp) + ''#9 +
      UserName + ''#9 + '0'#9 + '0'#9 + '1'#9 + '0');
    SysMsg('[AdjustExpriencePoint] ' + man + ' ' + IntToStr(exp), 1);
  end;
end;

procedure TUserHuman.CmdEraseItem(itmname, countstr: string);
var
  i, k, Count: integer;
  pu: PTUserItem;
begin
  Count := Str_ToInt(countstr, 1);
  for k := 1 to Count do begin
    for i := 0 to ItemList.Count - 1 do begin
      pu := PTUserItem(ItemList[i]);
      if CompareText(UserEngine.GetStdItemName(pu.Index), itmname) = 0 then begin
        //로그남김
        AddUserLog('6'#9 + //운삭_ +
          MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
          ''#9 + UserName + ''#9 + UserEngine.GetStdItemName(pu.Index) +
          ''#9 + IntToStr(pu.MakeIndex) + ''#9 + '1'#9 + '0');
        SendDelItem(pu^);
        Dispose(pu);
        ItemList.Delete(i);
        break;
      end;
    end;
  end;
end;

procedure TUserHuman.CmdRecallMan(man, map: string);
var
  hum:   TUserHuman;
  nx, ny, dx, dy: integer;
  svidx: integer;
begin
  hum := UserEngine.GetUserHuman(man);
  if hum <> nil then begin
    //map이름이 있으면 같은 맵의 사람만 리콜한다.
    if map <> '' then begin
      if hum.MapName <> map then
        exit;
    end;

    if GetFrontPosition(self, nx, ny) then begin
      if GetRecallPosition(nx, ny, 3, dx, dy) then begin
        hum.SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
        hum.UserSpaceMove(MapName, IntToStr(dx), IntToStr(dy)); //공간이동
      end;
    end else
      SysMsg('Recall failed.', 0);
  end else begin
    if UserEngine.FindOtherServerUser(man, svidx) then begin
      if GetFrontPosition(self, nx, ny) then begin
        if GetRecallPosition(nx, ny, 3, dx, dy) then begin
          UserEngine.SendInterMsg(ISM_RECALL, svidx, man + '/' +
            IntToStr(dx) + '/' + IntToStr(dy) + '/' + MapName);
        end;
      end else
        SysMsg('Recall failed.', 0);
    end else begin
      SysMsg(man + '  is not found.', 0);
    end;
  end;
end;

// 지정한 맵에서 무작위로 10명의 유저를 자기자신이 있는 위치로 소환함.
procedure TUserHuman.CmdRecallMap(MapFrom: string);
var
  hum:   TUserHuman;
  nx, ny, dx, dy, k: integer;
  list:  TList;
  envir: TEnvirnoment;
begin
  if MapFrom = '' then
    exit;

  //부를 사람
  envir := GrobalEnvir.GetEnvir(MapFrom);
  if envir <> nil then begin
    list := TList.Create;
    UserEngine.GetAreaUsers(envir, 0, 0, 1000, list);
    for k := 0 to list.Count - 1 do begin
      hum := TUserHuman(list[k]);
      if hum <> nil then begin
        if GetFrontPosition(self, nx, ny) then begin
          if GetRecallPosition(nx, ny, 3, dx, dy) then begin
            hum.SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
            hum.UserSpaceMove(MapName, IntToStr(dx), IntToStr(dy)); //공간이동
          end;
        end;
      end;
      //10명만 소환
      if k >= (10 - 1) then
        break;
    end;
    list.Free;
  end;
end;

procedure TUserHuman.GuildMasterRecallMan(man: string; bPersonal: boolean);
var
  hum:   TUserHuman;
  nx, ny, dx, dy: integer;
  svidx: integer;
  guild: TGuild;
begin
  if man = '' then
    exit;

  // 자신의 문원인지 검사.
  guild := GuildMan.GetGuildFromMemberName(man);
  if MyGuild = guild then begin
    hum := UserEngine.GetUserHuman(man);
    if hum <> nil then begin
      // 소환 거부 검사.
      if hum.BoEnableAgitRecall then begin
        if GetFrontPosition(self, nx, ny) then begin
          if GetRecallPosition(nx, ny, 3, dx, dy) then begin
            hum.SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
            hum.UserSpaceMove(MapName, IntToStr(dx), IntToStr(dy)); //공간이동
          end;
        end else
          SysMsg('Recall failed.', 0);
      end else begin
        if bPersonal then
          SysMsg(man + ' is now rejecting guild master''s Recall.', 0);
      end;
    end else begin
      if GetFrontPosition(self, nx, ny) then begin
        if GetRecallPosition(nx, ny, 3, dx, dy) then begin
          if UserEngine.FindOtherServerUser(man, svidx) then begin
            UserEngine.SendInterMsg(ISM_GUILDMEMBER_RECALL,
              svidx, man + '/' + IntToStr(dx) + '/' + IntToStr(dy) + '/' + MapName);
          end else if bPersonal then
            SysMsg(man + ' is not found.', 0);
        end;
      end;
    end;
  end else begin
    SysMsg('The man is not member of your guild.', 0);
  end;
end;

procedure TUserHuman.CmdReconnection(saddr, sport: string);
begin
  if (saddr <> '') and (sport <> '') then
    SendMsg(self, RM_RECONNECT, 0, 0, 0, 0, saddr + '/' + sport);
end;

procedure TUserHuman.CmdReloadGuild(gname: string);
var
  g: TGuild;
begin
  if ServerIndex = 0 then begin
    g := GuildMan.GetGuild(gname);
    if g <> nil then begin
      g.LoadGuild;
      SysMsg(gname + ' : Update has been done in Guild ', 0);
      UserEngine.SendInterMsg(ISM_RELOADGUILD, ServerIndex, gname);
    end;
  end else
    SysMsg('This command can only be used in the master server.', 0);
end;

procedure TUserHuman.CmdReloadGuildAll(gname: string);
begin
  GuildMan.ClearGuildList;
  GuildMan.LoadGuildList;
  SysMsg('Read all information of Guild.', 1);
end;

procedure TUserHuman.CmdReloadGuildAgit;
begin
  GuildAgitMan.ClearGuildAgitList;
  GuildAgitMan.LoadGuildAgitList;

  UserEngine.SendInterMsg(ISM_RELOADGUILDAGIT, ServerIndex, '');
  GuildAgitBoardMan.LoadAllGaBoardList('');  //장원게시판
  SysMsg('Reloaded the GuildAgitList.', 1);
end;

procedure TUserHuman.CmdKickUser(uname: string);
var
  hum: TUserHuman;
begin
  hum := UserEngine.GetUserHuman(uname);
  if hum <> nil then begin
    hum.UserRequestClose := True;
  end;
end;

procedure TUserHuman.CmdTingUser(uname: string);
var
  hum: TUserHuman;
begin
  hum := UserEngine.GetUserHuman(uname);
  if hum <> nil then begin
    //hum.UserRequestClose := TRUE;
    hum.RandomSpaceMove(hum.HomeMap, 0);
  end else
    SysMsg(uname + '  is not found.', 0);
end;

procedure TUserHuman.CmdTingRangeUser(uname, rangestr: string);
var
  i, range: integer;
  hum:      TUserHuman;
  ulist:    TList;
begin
  hum   := UserEngine.GetUserHuman(uname);
  range := _MIN(Str_ToInt(rangestr, 2), 10);
  if hum <> nil then begin
    ulist := TList.Create;
    UserEngine.GetAreaUsers(hum.PEnvir, hum.CX, hum.CY, range, ulist);
    for i := 0 to ulist.Count - 1 do begin
      hum := TUserHuman(ulist[i]);
      hum.RandomSpaceMove(hum.HomeMap, 0);
    end;
    ulist.Free;
  end else
    SysMsg(uname + '  is not found.', 0);
end;

procedure TUserHuman.CmdEraseMagic(magname: string);
var
  i: integer;
begin
  for i := MagicList.Count - 1 downto 0 do begin
    if CompareText(PTUserMagic(MagicList[i]).pDef.MagicName, magname) = 0 then begin
      SendDelMagic(PTUserMagic(MagicList[i]));
      Dispose(PTUserMagic(MagicList[i]));
      MagicList.Delete(i);
      break;
    end;
  end;
  RecalcAbilitys;
end;

procedure TUserHuman.CmdThisManEraseMagic(whostr, magname: string);
var
  hum: TUserHuman;
begin
  hum := UserEngine.GetUserHuman(whostr);
  if hum <> nil then begin
    hum.CmdEraseMagic(magname);
  end else
    SysMsg(whostr + '  is not found.', 0);
end;

function TUserHuman.GuildDeclareWar(gname: string): boolean;
var
  guild: TGuild;
  pgw:   PTGuildWarInfo;
  flag:  boolean;
  BackResult: boolean;
begin
  Result := False;
  pgw    := nil;
  BackResult := False;
  if IsGuildMaster then begin //문주만 사용할 수 있는 명령
    if ServerIndex <> 0 then begin
      SysMsg('This command is not available on this server', 0);
      exit;
    end;
    guild := GuildMan.GetGuild(gname);
    if guild <> nil then begin
      flag := False;
      //자신의 문파와는 문파전을 할 수 없음(sonmg 2005/08/17)
      if guild = TGuild(MyGuild) then begin
        SysMsg('Failed. it''s your own guild.', 0);
        exit;
      end;
      pgw := TGuild(MyGuild).DeclareGuildWar(guild, BackResult);
      if BackResult = False then
        exit;
      if pgw <> nil then begin
        if guild.DeclareGuildWar(TGuild(MyGuild), BackResult) = nil then begin
          pgw.WarStartTime := 0;  //타임아웃
        end else begin
          if BackResult then
            flag := True;
        end;
      end;
      if flag then begin //성공
        UserEngine.SendInterMsg(ISM_RELOADGUILD, ServerIndex,
          TGuild(MyGuild).GuildName);
        UserEngine.SendInterMsg(ISM_RELOADGUILD, ServerIndex, gname);
        Result := True;
      end;
    end else
      SysMsg(gname + ' is not an existing guild', 0);
  end else
    SysMsg('Only guild master can make request.', 0);
end;

procedure TUserHuman.CmdCreateGuild(gname, mastername: string);
var
  hum:  TUserHuman;
  flag: boolean;
begin
  if ServerIndex <> 0 then begin
    SysMsg('This command can only be used in the master server.', 0);
    exit;
  end;
  flag := False;
  hum  := UserEngine.GetUserHuman(mastername);
  if hum <> nil then begin
    if GuildMan.GetGuildFromMemberName(mastername) = nil then begin
      if GuildMan.AddGuild(gname, mastername) then begin
        UserEngine.SendInterMsg(ISM_ADDGUILD, ServerIndex, gname +
          '/' + mastername);
        SysMsg('Add guild ' + gname + ' ' + 'Guild master' + ':' + mastername, 0);
        flag := True;
      end;
    end;

    //문파정보를 다시 읽는다.
    with hum do begin
      MyGuild := GuildMan.GetGuildFromMemberName(UserName);
      if MyGuild <> nil then begin  //길드에 가입되어 있는 경우
        hum.GuildRankName := TGuild(MyGuild).MemberLogin(self, hum.GuildRank);
        //SendMsg (self, RM_CHANGEGUILDNAME, 0, 0, 0, 0, '');
      end;
    end;
  end;
  if not flag then
    SysMsg('New guild creation Failed', 0);
end;

procedure TUserHuman.CmdDeleteGuild(gname: string);
begin
  if ServerIndex <> 0 then begin
    SysMsg('This command can only be used in the master server.', 0);
    exit;
  end;
  if GuildMan.DelGuild(gname) then begin
    UserEngine.SendInterMsg(ISM_DELGUILD, ServerIndex, gname);
    SysMsg('Delete guild' + gname, 0);
  end else
    SysMsg('Guild deletion failed', 0);
end;

//문파 대전의 점수를 알려준다.
procedure TUserHuman.CmdGetGuildMatchPoint(gname: string);
var
  guild: TGuild;
begin
  guild := GuildMan.GetGuild(gname);
  if guild <> nil then begin
    SysMsg(gname + '''s point : ' + IntToStr(guild.MatchPoint), 1);
  end else
    SysMsg(gname + ' is not valid guild name', 0);
end;

//문파대전을 위해서 변수를 초기화
procedure TUserHuman.CmdStartGuildMatch;
var
  i, k: integer;
  ulist, glist: TList;
  hum:  TUserHuman;
  flag: boolean;
  str:  string;
begin
  if PEnvir.Fight3Zone then begin
    ulist := TList.Create;
    glist := TList.Create;
    UserEngine.GetAreaUsers(PEnvir, CX, CY, 1000, ulist);  //현맵의 모든 사람
    for i := 0 to ulist.Count - 1 do begin
      hum := TUserHuman(ulist[i]);
      if not hum.BoSuperviserMode and not hum.BoSysopMode then begin
        //운영자모드로 있는 사람은 점수에게 제외
        hum.FightZoneDieCount := 0;  //죽은 카운트 초기화
        if hum.MyGuild <> nil then begin
          flag := False;
          for k := 0 to glist.Count - 1 do begin
            if glist[k] = hum.MyGuild then begin
              flag := True;
              break;
            end;
          end;
          if not flag then
            glist.Add(hum.MyGuild);
        end;
      end;
    end;
    SysMsg('Guild war started .', 1);
    UserEngine.CryCry(RM_CRY, PEnvir, CX, CY, 10000, ' -Guild war started .');
    str := '';
    for i := 0 to glist.Count - 1 do begin
      TGuild(glist[i]).TeamFightStart;  //문파대전변수초기화, 점수, 멤버
      for k := 0 to ulist.Count - 1 do begin
        hum := TUserHuman(ulist[k]);
        if hum.MyGuild = glist[i] then begin
          TGuild(glist[i]).TeamFightAdd(hum.UserName);  //문파대전멤버 자동 추가
        end;
      end;
      str := str + TGuild(glist[i]).GuildName + ' ';
    end;
    UserEngine.CryCry(RM_CRY, PEnvir, CX, CY, 10000, ' -Guild in contest: ' + str);
    ulist.Free;
    glist.Free;
  end else
    SysMsg('this command is not usable on this map!', 0);
end;

//문파대전 종료(끝)
procedure TUserHuman.CmdEndGuildMatch;
var
  i, k: integer;
  ulist, glist: TList;
  hum:  TUserHuman;
  flag: boolean;
begin
  if PEnvir.Fight3Zone then begin
    ulist := TList.Create;
    glist := TList.Create;
    UserEngine.GetAreaUsers(PEnvir, CX, CY, 1000, ulist);  //현맵의 모든 사람
    for i := 0 to ulist.Count - 1 do begin
      hum := TUserHuman(ulist[i]);
      if not hum.BoSuperviserMode and not hum.BoSysopMode then begin
        //운영자모드로 있는 사람은 점수에게 제외
        if hum.MyGuild <> nil then begin
          flag := False;
          for k := 0 to glist.Count - 1 do begin
            if glist[k] = hum.MyGuild then begin
              flag := True;
              break;
            end;
          end;
          if not flag then
            glist.Add(hum.MyGuild);
        end;
      end;
    end;
    for i := 0 to glist.Count - 1 do begin
      TGuild(glist[i]).TeamFightEnd;
      UserEngine.CryCry(RM_CRY, PEnvir, CX, CY, 10000, ' -' +
        TGuild(glist[i]).GuildName + 'Contest finished');
    end;
    ulist.Free;
    glist.Free;
  end;
end;

procedure TUserHuman.CmdAnnounceGuildMembersMatchPoint(gname: string);
var
  i, k, n: integer;
  hum:     TUserHuman;
  flag:    boolean;
  guild:   TGuild;
begin
  if PEnvir.Fight3Zone then begin
    guild := GuildMan.GetGuild(gname);
    if guild <> nil then begin
      UserEngine.CryCry(RM_CRY, PEnvir, CX, CY, 10000, ' -' +
        gname + ' Guild  contest point announcement.');
      for i := 0 to guild.FightMemberList.Count - 1 do begin
        n := integer(guild.FightMemberList.Objects[i]);
        UserEngine.CryCry(RM_CRY, PEnvir, CX, CY, 10000,
          ' -' + guild.FightMemberList[i] + ' : ' + IntToStr(Hiword(n)) +
          //Hiword: 얻은점수
          ' point / ' + IntToStr(Loword(n)) + ' dead'); //Loword: 죽은횟수
      end;
      UserEngine.CryCry(RM_CRY, PEnvir, CX, CY, 10000,
        ' -[' + guild.GuildName + '] ' + IntToStr(guild.MatchPoint));
      UserEngine.CryCry(RM_CRY, PEnvir, CX, CY, 10000,
        '------------------------------------');
    end;
  end else
    SysMsg('this command is not usable on this map!', 0);
end;

function TUserHuman.GetLevelInfoString(cret: TCreature): string;
begin
  Result := cret.UserName + ' Map' + cret.MapName + ' X' + IntToStr(cret.CX) +
    ' Y' + IntToStr(cret.CY) + ' Lv' + IntToStr(cret.Abil.Level) +
    ' Exp' + IntToStr(cret.Abil.Exp) + ' HP' + IntToStr(cret.WAbil.HP) +
    '/' + IntToStr(cret.WAbil.MaxHP) + ' MP' + IntToStr(cret.WAbil.MP) +
    '/' + IntToStr(cret.WAbil.MaxMP) + ' DC' + IntToStr(Lobyte(cret.WAbil.DC)) +
    '-' + IntToStr(Hibyte(cret.WAbil.DC)) + ' MC' + IntToStr(Lobyte(cret.WAbil.MC)) +
    '-' + IntToStr(Hibyte(cret.WAbil.MC)) + ' SC' + IntToStr(Lobyte(cret.WAbil.SC)) +
    '-' + IntToStr(Hibyte(cret.WAbil.SC)) + ' AC' + IntToStr(Lobyte(cret.WAbil.AC)) +
    '-' + IntToStr(Hibyte(cret.WAbil.AC)) + ' MAC' + IntToStr(Lobyte(cret.WAbil.MAC)) +
    '-' + IntToStr(Hibyte(cret.WAbil.MAC)) + ' Hit' + IntToStr(cret.AccuracyPoint) +
    ' Spd' + IntToStr(cret.SpeedPoint) +
    // 2003/03/04 추가부분
    ' HitSpeed' + IntToStr(cret.HitSpeed) + ' Holy' +
    IntToStr(cret.AddAbil.UndeadPower);
end;

procedure TUserHuman.CmdSendUserLevelInfos(whostr: string);
var
  hum: TUserHuman;
begin
  hum := UserEngine.GetUserHuman(whostr);
  if hum <> nil then begin
    SysMsg(GetLevelInfoString(hum), 1);
  end else
    SysMsg(whostr + '  is not found.', 0);
end;

procedure TUserHuman.CmdSendMonsterLevelInfos;
var
  i:    integer;
  list: TList;
  cret: TCreature;
begin
  list := TList.Create;
  PEnvir.GetCreatureInRange(CX, CY, 2, True, list);
  for i := 0 to list.Count - 1 do begin
    cret := TCreature(list[i]);
    SysMsg(GetLevelInfoString(cret), 1);
  end;
  list.Free;
end;

 ////////////////////////////////////////////////////
 //왕몹의 정보를 보내는 명령. sonmg(2004/02/06)
 ////////////////////////////////////////////////////
procedure TUserHuman.CmdSendKingMonsterInfos(monname: string);
var
  cret:   TCreature;
  ix, iy: integer;
begin

  try

    // 현재 맵 전체 좌표를 검색하여 각 좌표에 있는 첫(GetCreature) 몬스터 중에
    // 레벨이 60 이상인 몬스터에 대한 정보를 보냄.
    for ix := 0 to PEnvir.MapWidth - 1 do begin
      for iy := 0 to PEnvir.MapHeight - 1 do begin
        cret := TCreature(PEnvir.GetCreature(ix, iy, True));

        if cret <> nil then begin
          if monname = '' then begin
            if (cret.Abil.Level >= 60) and (cret.RaceServer <>
              RC_BAMTREE) and (cret.RaceServer <> RC_PBMSTONE1) and
              (cret.RaceServer <> RC_PBMSTONE2) and
              (cret.RaceServer > RC_ANIMAL) then
              SysMsg(GetLevelInfoString(cret), 1);
          end else begin
            if (cret.UserName = monname) then
              SysMsg(GetLevelInfoString(cret), 1);
          end;
        end;
      end;
    end;

  except
    MainOutMessage('[Exception]TUserHuman.CmdSendKingMonsterInfos');
  end;

end;

procedure TUserHuman.CmdChangeUserCastleOwner(gldname: string; pass: boolean);
var
  guild: TGuild;
begin
  guild := GuildMan.GetGuild(gldname);
  if guild <> nil then begin
    //로그남김
    AddUserLog('27'#9 + //사북_ +
      UserCastle.OwnerGuildName + ''#9 + '0'#9 + '0'#9 + gldname +
      ''#9 + UserName + ''#9 + '0'#9 + '1'#9 + '0');
    UserCastle.ChangeCastleOwner(guild);
    if pass then
      UserEngine.SendInterMsg(ISM_CHANGECASTLEOWNER, ServerIndex, gldname);
    SysMsg('Lord of Sabuk wall changed to : ' + gldname, 1);
  end else
    SysMsg(gldname + ' cannot be found.', 0);
end;

procedure TUserHuman.CmdReloadNpc(cmdstr: string);
var
  i, n: integer;
  list: TList;
begin
  if CompareText(cmdstr, 'all') = 0 then begin

    FrmDB.ReloadNpcs;  //추가된 npc, 삭제된 npc 적용
    FrmDB.ReloadMerchants;

    n := 0;
    for i := 0 to UserEngine.NpcList.Count - 1 do begin
      TNormNpc(UserEngine.NpcList[i]).ClearNpcInfos;
      TNormNpc(UserEngine.NpcList[i]).LoadNpcInfos;
      Inc(n);
    end;
    for i := 0 to UserEngine.MerchantList.Count - 1 do begin
      TMerchant(UserEngine.MerchantList[i]).ClearMerchantInfos;
      TMerchant(UserEngine.MerchantList[i]).LoadMerchantInfos;
      Inc(n);
    end;
    SysMsg('Reload npc information is successful : ' + IntToStr(n), 1);
  end else begin
    list := TList.Create;
    UserEngine.GetNpcXY(PEnvir, CX, CY, 9, list);  //화면에 보이는 npc
    for i := 0 to list.Count - 1 do begin
      TNormNpc(list[i]).ClearNpcInfos;
      TNormNpc(list[i]).LoadNpcInfos;
      SysMsg(TNormNpc(list[i]).UserName + ' is reloaded', 1);
    end;
    list.Clear;
    UserEngine.GetMerchantXY(PEnvir, CX, CY, 9, list);  //화면에 보이는 npc
    for i := 0 to list.Count - 1 do begin
      TMerchant(list[i]).ClearMerchantInfos;
      TMerchant(list[i]).LoadMerchantInfos;
      SysMsg(TNormNpc(list[i]).UserName + ' is reloaded', 1);
    end;
    list.Free;
  end;
end;


procedure TUserHuman.CmdOpenCloseUserCastleMainDoor(cmdstr: string);
begin
  if IsGuildMaster and (MyGuild = UserCastle.OwnerGuild) then begin
    if CompareText(cmdstr, 'Open') = 0 then begin

    end;
    if CompareText(cmdstr, 'Close') = 0 then begin

    end;
  end else
    SysMsg('This command available only for the Lord of Sabuk wall.', 0);
end;


//pass : true(다른 서버에 전달함, 주의)
procedure TUserHuman.CmdAddShutUpList(whostr, minstr: string; pass: boolean);
var
  idx, amin: integer;
begin
  amin := Str_ToInt(minstr, 5);
  if whostr <> '' then begin
    idx := ShutUpList.FFind(whostr);
    if idx >= 0 then begin
      ShutUpList.Objects[idx] :=
        TObject(integer(ShutUpList.Objects[idx]) + amin * 60 * 1000);
    end else begin
      ShutUpList.QAddObject(whostr, TObject(GetCurrentTime + (amin * 60 * 1000)));
    end;
    if pass then  //다른 서버에 전달할 것인지
      UserEngine.SendInterMsg(ISM_CHATPROHIBITION, ServerIndex,
        whostr + '/' + IntToStr(amin));
    SysMsg(whostr + ' was banned from chatting. +' + IntToStr(amin) + 'min', 1);
  end else
    SysMsg(whostr + '  is not found.', 0);
end;

procedure TUserHuman.CmdDelShutUpList(whostr: string; pass: boolean);
var
  hum: TUserHuman;
  idx: integer;
begin
  idx := ShutUpList.FFind(whostr);
  if idx >= 0 then begin
    ShutUpList.Delete(idx);
    hum := UserEngine.GetUserHuman(whostr);
    if hum <> nil then begin
      hum.SysMsg('Released from chatting', 1);
    end;
    if pass then  //다른 서버에 전달 여부
      UserEngine.SendInterMsg(ISM_CHATPROHIBITIONCANCEL, ServerIndex, whostr);
    SysMsg(whostr + ' ' + '', 1);
  end else
    SysMsg(whostr + '  is not found.', 0);
end;

procedure TUserHuman.CmdSendShutUpList;
var
  i: integer;
begin
  for i := 0 to ShutUpList.Count - 1 do begin
    SysMsg(ShutUpList[i] + ' ' + IntToStr(
      (integer(ShutUpList.Objects[i]) - GetCurrentTime) div 60000) + 'Min', 1);
  end;
end;

procedure TUserHuman.CmdOneKillMob;
var
  cret: TCreature;
begin
  cret := GetFrontCret;
  if (cret <> nil) and (cret.RaceServer >= RC_ANIMAL) then begin
    cret.Die;
  end;
end;

procedure TUserHuman.CmdAgitDecoMonCount(agitnum: integer);
var
  Count: integer;
begin
  Count := 0;
  Count := GuildAgitMan.GetAgitDecoMonCount(agitnum);

  SysMsg('The number of items used for decorating guild territory No. ' +
    IntToStr(agitnum) + '. : ' + IntToStr(Count), 0);
end;

procedure TUserHuman.CmdAgitDecoMonCountHere;
var
  agitnum: integer;
  Count:   integer;
begin
  agitnum := 0;
  Count   := 0;
  agitnum := GuildAgitMan.GetGuildAgitNumFromMapName(MapName);
  if agitnum > 0 then begin
    Count := GuildAgitMan.GetAgitDecoMonCount(agitnum);
    BoxMsg('The total number of decorative items in the guild territory is ' +
      IntToStr(Count) + '.', 0);
  end;
end;


//디버깅 명령어
procedure TUserHuman.CmdUserMarketDebug(strParam: string);
begin
  //여기에 디버깅 코드를 추가하십시오(sonmg)
end;

 ////////////////////////
 // SEED 아이템 체크.
function TUserHuman.CheckSeedItem(psSeed, psJewelry: PTStdItem): integer;
begin
  /////////////////////////////////////////////////////////////////////////////
  //바느질용품 또는 뼈망치.
  if psJewelry.StdMode = 61 then begin
    if psJewelry.Shape = SHAPE_OF_NEEDLE then begin
      //옷, 투구, 신발, 허리띠
      if psSeed.StdMode in [10, 11, 15, 52, 54] then
        Result := 11
      else
        Result := 10;
      exit;
    end else if psJewelry.Shape = SHAPE_OF_HAMMER then begin
      //목걸이, 반지, 팔찌
      if psSeed.StdMode in [19, 20, 21, 22, 23, 24, 26] then
        Result := 11
      else
        Result := 10;
      exit;
    end;
  end else if psJewelry.StdMode = 7 then begin
    if psJewelry.Shape = SHAPE_OF_CORD then begin
      //묶음 가능 아이템.
      if CheckUnbindItem(psSeed.Name) then
        Result := 21
      else
        Result := 20;
      exit;
    end;
  end;

  /////////////////////////////////////////////////////////////////////////////
  // 무기,옷,투구,목걸이,반지,팔찌, 신발,벨트.
  if psSeed.StdMode in [5, 6, 10, 11, 15, 19, 20, 21, 22, 23, 24, 26, 52, 54] then
    Result := 2
  else
    Result := 0;

  // 유니크 아이템 체크
  if psSeed.UniqueItem = 1 then begin
    Result := 3;
    exit;
  end;

  case psSeed.StdMode of
    5, 6: // 무기
    begin
      if (psJewelry.AC > 0) or (psJewelry.MAC > 0) or (psJewelry.Accurate > 0) or
        (psJewelry.Agility > 0) or (psJewelry.MgAvoid > 0) or
        (psJewelry.ToxAvoid > 0) then begin
        Result := 1;
      end;
    end;
    10, 11: // 옷
    begin
      if (psJewelry.DC > 0) or (psJewelry.MC > 0) or (psJewelry.SC > 0) or
        (psJewelry.Accurate > 0) or (psJewelry.AtkSpd > 0) or
        (psJewelry.Slowdown > 0) or (psJewelry.Tox > 0) then begin
        Result := 1;
      end;
    end;
    15: // 투구
    begin
      if (psJewelry.DC > 0) or (psJewelry.MC > 0) or (psJewelry.SC > 0) or
        (psJewelry.Agility > 0) or (psJewelry.AtkSpd > 0) or
        (psJewelry.Slowdown > 0) or (psJewelry.Tox > 0) then begin
        Result := 1;
      end;
    end;
    19, 20, 21: // 목걸이
    begin
      if (psJewelry.AC > 0) or (psJewelry.MAC > 0) or (psJewelry.Agility > 0) or
        (psJewelry.ToxAvoid > 0) then begin
        Result := 1;
      end;
    end;
    22: // 반지
    begin
      if (psJewelry.Accurate > 0) or (psJewelry.Agility > 0) or
        (psJewelry.MgAvoid > 0) or (psJewelry.ToxAvoid > 0) then begin
        Result := 1;
      end;
    end;
    23: // 반지23
    begin
      if (psJewelry.AC > 0) or (psJewelry.MAC > 0) or
        // 특정 반지에 방어,마항을 뺌(sonmg)
        (psJewelry.Accurate > 0) or (psJewelry.Agility > 0) or
        (psJewelry.MgAvoid > 0) or (psJewelry.ToxAvoid > 0) then begin
        Result := 1;
      end;
    end;
    24: // 팔찌24
    begin
      if (psJewelry.AC > 0) or (psJewelry.MAC > 0) or
        // 특정 팔찌에 방어,마항을 뺌(sonmg)
        (psJewelry.AtkSpd > 0) or (psJewelry.MgAvoid > 0) or
        (psJewelry.Slowdown > 0) or (psJewelry.Tox > 0) or
        (psJewelry.ToxAvoid > 0) then begin
        Result := 1;
      end;
    end;
    26: // 팔찌26
    begin
      if (psJewelry.AtkSpd > 0) or (psJewelry.MgAvoid > 0) or
        (psJewelry.Slowdown > 0) or (psJewelry.Tox > 0) or
        (psJewelry.ToxAvoid > 0) then begin
        Result := 1;
      end;
    end;
    52: // 신발
    begin
      if (psJewelry.DC > 0) or (psJewelry.MC > 0) or (psJewelry.SC > 0) or
        (psJewelry.Accurate > 0) or (psJewelry.AtkSpd > 0) or
        (psJewelry.MgAvoid > 0) or (psJewelry.Slowdown > 0) or
        (psJewelry.Tox > 0) or (psJewelry.ToxAvoid > 0) then begin
        Result := 1;
      end;
    end;
    54: // 벨트
    begin
      if (psJewelry.DC > 0) or (psJewelry.MC > 0) or (psJewelry.SC > 0) or
        (psJewelry.AtkSpd > 0) or (psJewelry.MgAvoid > 0) or
        (psJewelry.Slowdown > 0) or (psJewelry.Tox > 0) then begin
        Result := 1;
      end;
    end;
    else begin
      Result := 0;
    end;
  end;

end;

// 보옥류 아이템 체크.
function TUserHuman.CheckJewelryItem(iStdMode: integer): boolean;
begin
  // 보옥,신주,노끈.
  if iStdMode in [7, 60, 61] then
    Result := True
  else
    Result := False;
end;

 /////////////////////////
 // 기존 속성값의 합.
function TUserHuman.SumOfOptions(puSeedItem: PTUserItem;
  psSeedItem: PTStdItem): integer;
begin
  Result := 0;
  case psSeedItem.StdMode of
    5, 6:  // 무기
    begin
      Result := puSeedItem.Desc[0] + puSeedItem.Desc[1] +
        puSeedItem.Desc[2] + puSeedItem.Desc[5] + puSeedItem.Desc[12] +
        puSeedItem.Desc[13];
      // 공속 합산(무기).
      Result := Result + _MAX(0, ItemMan.RealAttackSpeed(puSeedItem.Desc[6]));
    end;
    10, 11, 15: // 옷, 투구
    begin
      Result := puSeedItem.Desc[0] + puSeedItem.Desc[1] +
        puSeedItem.Desc[11] + puSeedItem.Desc[12] + puSeedItem.Desc[13];
    end;
    19: // 목걸이19
    begin
      Result := puSeedItem.Desc[0] + puSeedItem.Desc[2] +
        puSeedItem.Desc[3] + puSeedItem.Desc[4] + puSeedItem.Desc[11] +
        puSeedItem.Desc[12] + puSeedItem.Desc[13];
      // 공속 합산.
      if puSeedItem.Desc[9] > 0 then
        Result := Result + puSeedItem.Desc[9];
    end;
    20: // 목걸이
    begin
      Result := puSeedItem.Desc[0] + puSeedItem.Desc[1] +
        puSeedItem.Desc[2] + puSeedItem.Desc[3] + puSeedItem.Desc[4] +
        puSeedItem.Desc[11] + puSeedItem.Desc[12] + puSeedItem.Desc[13];
      // 공속 합산.
      if puSeedItem.Desc[9] > 0 then
        Result := Result + puSeedItem.Desc[9];
    end;
    21: // 목걸이
    begin
      Result := puSeedItem.Desc[2] + puSeedItem.Desc[3] +
        puSeedItem.Desc[4] + puSeedItem.Desc[7] + puSeedItem.Desc[11] +
        puSeedItem.Desc[12] + puSeedItem.Desc[13];
      // 공속 합산.
      if puSeedItem.Desc[9] > 0 then
        Result := Result + puSeedItem.Desc[9];
    end;
    22: // 반지
    begin
      Result := puSeedItem.Desc[0] + puSeedItem.Desc[1] +
        puSeedItem.Desc[2] + puSeedItem.Desc[3] + puSeedItem.Desc[4] +
        puSeedItem.Desc[12] + puSeedItem.Desc[13];
      // 공속 합산.
      if puSeedItem.Desc[9] > 0 then
        Result := Result + puSeedItem.Desc[9];
    end;
    23: // 반지23
    begin
      Result := puSeedItem.Desc[0] + puSeedItem.Desc[2] +
        puSeedItem.Desc[3] + puSeedItem.Desc[4] + puSeedItem.Desc[12] +
        puSeedItem.Desc[13];
      // 공속 합산.
      if puSeedItem.Desc[9] > 0 then
        Result := Result + puSeedItem.Desc[9];
    end;
    24: // 팔찌24
    begin
      Result := puSeedItem.Desc[0] + puSeedItem.Desc[1] +
        puSeedItem.Desc[2] + puSeedItem.Desc[3] + puSeedItem.Desc[4];
    end;
    26: // 팔찌
    begin
      Result := puSeedItem.Desc[0] + puSeedItem.Desc[1] +
        puSeedItem.Desc[2] + puSeedItem.Desc[3] + puSeedItem.Desc[4] +
        puSeedItem.Desc[11] + puSeedItem.Desc[12];
    end;
    52: // 신발
    begin
      Result := puSeedItem.Desc[0] + puSeedItem.Desc[1] + puSeedItem.Desc[3];
    end;
    54: // 벨트
    begin
      Result := puSeedItem.Desc[0] + puSeedItem.Desc[1] +
        puSeedItem.Desc[2] + puSeedItem.Desc[3] + puSeedItem.Desc[13];
    end;
  end;

  // 내구력 합산.   //단계가 1000 -> 2000 으로 증가 2003-11-7 PDS
  Result := Result + _MAX(0, Round(
    (puSeedItem.DuraMax - psSeedItem.DuraMax) / 2000));
end;

 ///////////////////////////////////
 // 확률 계산 및 결과 리턴 함수.
function TUserHuman.CalcUpgradeProbability(puSeedItem, puJewelryItem: PTUserItem;
  psSeedItem, psJewelryItem: PTStdItem; iExecCount: integer;
  var iRetSum: integer; var fRetProb: double): integer;
var
  iSucceed, iFail: integer;
  iSum, iRandom: integer;
  UpProb: array [0..10] of TUpgradeProb;
  i, testSucceed, testNoChange, testFail: integer;

  /////////////////////////////////////////////
  // 확률값 초기화.(이렇게 해도 되나? sonmg)
  procedure InitProbability;
  begin
    with UpProb[0] do begin
      iBase     := 10000;
      iValue[0] := 5000;
      iValue[1] := 5000;
      iValue[2] := 5000;
      iValue[3] := integer(iValue[0] * 2);
      iValue[4] := integer(iValue[1] * 2);
      iValue[5] := integer(iValue[2] * 2);
    end;
    with UpProb[1] do begin
      iBase     := 10000;
      iValue[0] := 4500;
      iValue[1] := 3000;
      iValue[2] := 4000;
      iValue[3] := integer(iValue[0] * 2);
      iValue[4] := integer(iValue[1] * 2);
      iValue[5] := integer(iValue[2] * 2);
    end;
    with UpProb[2] do begin
      iBase     := 10000;
      iValue[0] := 4000;
      iValue[1] := 1000;
      iValue[2] := 3000;
      iValue[3] := integer(iValue[0] * 2);
      iValue[4] := integer(iValue[1] * 2);
      iValue[5] := integer(iValue[2] * 2);
    end;
    with UpProb[3] do begin
      iBase     := 10000;
      iValue[0] := 3500;
      iValue[1] := 500;
      iValue[2] := 1000;
      iValue[3] := integer(iValue[0] * 2);
      iValue[4] := integer(iValue[1] * 2);
      iValue[5] := integer(iValue[2] * 2);
    end;
    with UpProb[4] do begin
      iBase     := 10000;
      iValue[0] := 3000;
      iValue[1] := 100;
      iValue[2] := 500;
      iValue[3] := integer(iValue[0] * 2);
      iValue[4] := integer(iValue[1] * 2);
      iValue[5] := integer(iValue[2] * 2);
    end;
    with UpProb[5] do begin
      iBase     := 10000;
      iValue[0] := 1500;
      iValue[1] := 25;
      iValue[2] := 100;
      iValue[3] := integer(iValue[0] * 2);
      iValue[4] := integer(iValue[1] * 2);
      iValue[5] := integer(iValue[2] * 2);
    end;
    with UpProb[6] do begin
      iBase     := 10000;
      iValue[0] := 400;
      iValue[1] := 5;
      iValue[2] := 25;
      iValue[3] := integer(iValue[0] * 2);
      iValue[4] := integer(iValue[1] * 2);
      iValue[5] := integer(iValue[2] * 2);
    end;
    with UpProb[7] do begin
      iBase     := 10000;
      iValue[0] := 100;
      iValue[1] := 5;
      iValue[2] := 5;
      iValue[3] := integer(iValue[0] * 2);
      iValue[4] := integer(iValue[1] * 2);
      iValue[5] := integer(iValue[2] * 2);
    end;
    with UpProb[8] do begin
      iBase     := 10000;
      iValue[0] := 25;
      iValue[1] := 5;
      iValue[2] := 5;
      iValue[3] := integer(iValue[0] * 2);
      iValue[4] := integer(iValue[1] * 2);
      iValue[5] := integer(iValue[2] * 2);
    end;
    with UpProb[9] do begin
      iBase     := 10000;
      iValue[0] := 5;
      iValue[1] := 5;
      iValue[2] := 5;
      iValue[3] := integer(iValue[0] * 2);
      iValue[4] := integer(iValue[1] * 2);
      iValue[5] := integer(iValue[2] * 2);
    end;
    with UpProb[10] do begin
      iBase     := 10000;
      iValue[0] := 0;
      iValue[1] := 0;
      iValue[2] := 0;
      iValue[3] := 0;
      iValue[4] := 0;
      iValue[5] := 0;
    end;
  end;

begin
  Result  := 2;
  // 옵션합 10 이상은 무시. 옵션합 0이하는 0로 만든다.
  iSum    := _MIN(10, _MAX(0, SumOfOptions(puSeedItem, psSeedItem)));
  iRetSum := iSum;

  // 확률값 초기화.
  InitProbability;

  testSucceed := 0;
  testNoChange := 0;
  testFail := 0;
  iSucceed := 0;
  iFail   := 0;
  iRandom := 0;

  if iExecCount < 1 then
    iExecCount := 1;

  //확률 테스트
  for i := 0 to iExecCount - 1 do begin

    iRandom := Random(UpProb[iSum].iBase);

    if psJewelryItem.StdMode = 60 then begin
      if psSeedItem.StdMode in [5, 6] then begin //무기
        iSucceed := _MIN(UpProb[iSum].iBase, Round(
          UpProb[iSum].iValue[0] * ABS(
          (29 + BodyLuckLevel + (LOBYTE(psSeedItem.AC) + puSeedItem.Desc[3] -
          LOBYTE(psSeedItem.MAC) - puSeedItem.Desc[4]) / 2) / 30)));
      end else if psSeedItem.StdMode in [10, 11] then begin //옷
        iSucceed := _MIN(UpProb[iSum].iBase, Round(
          UpProb[iSum].iValue[0] * ABS((29 + BodyLuckLevel) / 30)));
      end else if psSeedItem.StdMode in [24, 26, 52] then begin  //팔찌,신발
        iSucceed := _MIN(UpProb[iSum].iBase, Round(
          UpProb[iSum].iValue[1] * ABS((29 + BodyLuckLevel) / 30)));
      end else if psSeedItem.StdMode = 19 then begin  //목걸이19
        iSucceed := _MIN(UpProb[iSum].iBase, Round(
          UpProb[iSum].iValue[2] * ABS((29 + BodyLuckLevel) / 30)));
      end else begin //기타
        iSucceed := _MIN(UpProb[iSum].iBase, Round(
          UpProb[iSum].iValue[2] * ABS((29 + BodyLuckLevel) / 30)));
      end;

      // 공속 확률 따로 적용.(sonmg 2003/12/22)
      if psJewelryItem.Shape = 9 then begin
        iSucceed := (iSucceed * 60) div 100;
      end;

      iFail := Round((UpProb[iSum].iBase - iSucceed) * 0.7);

      if (iRandom >= 0) and (iRandom < iSucceed) then
        Result := 2    //성공
      else if (iRandom >= iSucceed) and (iRandom < iSucceed + iFail) then
        Result := 1   //불변
      else
        Result := 0;   //파손
    end else if psJewelryItem.StdMode = 61 then begin
      if psSeedItem.StdMode in [5, 6] then begin //무기
        iSucceed := _MIN(UpProb[iSum].iBase, Round(
          UpProb[iSum].iValue[3] * ABS(
          (29 + BodyLuckLevel + (LOBYTE(psSeedItem.AC) + puSeedItem.Desc[3] -
          LOBYTE(psSeedItem.MAC) - puSeedItem.Desc[4]) / 2) / 30)));
      end else if psSeedItem.StdMode in [10, 11] then begin //옷
        iSucceed := _MIN(UpProb[iSum].iBase, Round(
          UpProb[iSum].iValue[3] * ABS((29 + BodyLuckLevel) / 30)));
      end else if psSeedItem.StdMode in [24, 26, 52] then begin  //팔찌,신발
        iSucceed := _MIN(UpProb[iSum].iBase, Round(
          UpProb[iSum].iValue[4] * ABS((29 + BodyLuckLevel) / 30)));
      end else if psSeedItem.StdMode = 19 then begin  //목걸이19
        iSucceed := _MIN(UpProb[iSum].iBase, Round(
          UpProb[iSum].iValue[5] * ABS((29 + BodyLuckLevel) / 30)));
      end else begin //기타
        iSucceed := _MIN(UpProb[iSum].iBase, Round(
          UpProb[iSum].iValue[5] * ABS((29 + BodyLuckLevel) / 30)));
      end;

      // 공속 확률 따로 적용.(sonmg 2003/12/22)
      if psJewelryItem.Shape = 9 then begin
        iSucceed := (iSucceed * 60) div 100;
      end;

      iFail := integer(Round(0.7 * (UpProb[iSum].iBase - iSucceed)));

      if (iRandom >= 0) and (iRandom < iSucceed) then
        Result := 2    //성공
      else
        Result := 1;   //불변
    end;

    fRetProb := iSucceed / UpProb[iSum].iBase;

    if Result = 2 then
      Inc(testSucceed)
    else if Result = 1 then
      Inc(testNoChange)
    else if Result = 0 then
      Inc(testFail);

    //확률 테스트
  end;

  //확률 테스트 결과 출력
  if iExecCount > 1 then
    SysMsg('Prob. Test(' + IntToStr(iExecCount) + ')times=>' +
      'Success:' + IntToStr(testSucceed) + ', NoChange:' +
      IntToStr(testNoChange) + ', Destruct:' + IntToStr(testFail), 0);

{
   if psJewelryItem.StdMode = 60 then begin
      MainOutMessage( '[UpgradeItem:확률] ' + UserName + ' ' + seedname + ' ' + jewelryname + '=> '
         + '옵션합:' + IntToStr(iSum) + ', 성공확률:' + IntToStr(iSucceed)
         + ', 불변확률:' + IntToStr(iFail) + ', 파손확률:' + IntToStr(UpProb[iSum].iBase-iSucceed-iFail)
         + ', iRandom:' + IntToStr(iRandom)
         + ', Body행운:' + IntToStr(BodyLuckLevel) + ', 무기행운:' + IntToStr(LOBYTE(psSeedItem.AC) + puSeedItem.Desc[3])
         + ', 무기불운:' + IntToStr(LOBYTE(psSeedItem.MAC) + puSeedItem.Desc[4]) );
   end else if psJewelryItem.StdMode = 61 then begin
      MainOutMessage( '[UpgradeItem:확률] ' + UserName + ' ' + seedname + ' ' + jewelryname + '=> '
         + '옵션합:' + IntToStr(iSum) + ', 성공확률:' + IntToStr(iSucceed)
         + ', 불변확률:' + IntToStr(UpProb[iSum].iBase-iSucceed)
         + ', iRandom:' + IntToStr(iRandom)
         + ', Body행운:' + IntToStr(BodyLuckLevel) + ', 무기행운:' + IntToStr(LOBYTE(psSeedItem.AC) + puSeedItem.Desc[3])
         + ', 무기불운:' + IntToStr(LOBYTE(psSeedItem.MAC) + puSeedItem.Desc[4]) );
   end;
}

{$IFDEF DEBUG}   //sonmg
   //옵션 합 출력(임시)
   if psJewelryItem.StdMode = 60 then begin
      SysMsg('Sum Opt.:' + IntToStr(iSum) + ', Prob.Success:' + IntToStr(iSucceed)
         + ', Prob.NoChange:' + IntToStr(iFail) + ', Prob.Destroy:' + IntToStr(UpProb[iSum].iBase-iSucceed-iFail)
         + ', iRandom:' + IntToStr(iRandom), 0);
   end else if psJewelryItem.StdMode = 61 then begin
      SysMsg('Sum Opt.:' + IntToStr(iSum) + ', Prob.Success:' + IntToStr(iSucceed)
         + ', Prob.NoChange:' + IntToStr(UpProb[iSum].iBase-iSucceed)
         + ', iRandom:' + IntToStr(iRandom), 0);
   end;
{$ENDIF}//sonmg
end;

 ///////////////////////////////////////////////////////////////
 //added by sonmg...
procedure TUserHuman.CmdUpgradeItem(seedname, jewelryname: string;
  seedindex, jewelryindex, ExecCount: integer);
var
  iResult: integer;
  i, j, k, iVal: integer;
  puSeed, puJewelry: PTUserItem;
  psSeed, psJewelry: PTStdItem;
  strResult, strEtc: string;
  iSumOfOption: integer;
  fProbability: double;
  iBeforeValue, iAfterValue: integer;
  iShape:  integer;
  dellist: TStringList;
begin
  puSeed      := nil;
  puJewelry   := nil;
  psSeed      := nil;
  psJewelry   := nil;
  iSumOfOption := 0;
  fProbability := 0;
  iBeforeValue := 0;
  iAfterValue := 0;

  try
    if seedname = '' then
      exit;
    if jewelryname = '' then
      exit;

    ///////////////////////////////////////////////////
    // 보옥류 검사
    // 운영자 명령을 위한 코드(운영자 명령일때는 Index값이 0으로 들어온다).
    if jewelryindex = 0 then begin
      for i := 0 to ItemList.Count - 1 do begin
        if UserEngine.GetStdItemIndex(jewelryname) =
          PTUserItem(ItemList[i]).Index then begin
          psJewelry    := UserEngine.GetStdItem(PTUserItem(Itemlist[i]).Index);
          jewelryindex := PTUserItem(ItemList[i]).MakeIndex;
          puJewelry    := PTUserItem(ItemList[i]);
          break;
        end;
      end;
      if i = ItemList.Count then
        exit;
    end else      // 운영자가 아닌 정상적인 경우.
    begin
      for i := 0 to ItemList.Count - 1 do begin
        if jewelryindex = PTUserItem(ItemList[i]).MakeIndex then begin
          psJewelry := UserEngine.GetStdItem(PTUserItem(Itemlist[i]).Index);
          puJewelry := PTUserItem(ItemList[i]);
          break;
        end;
      end;
      if i = ItemList.Count then
        exit;
    end;
    ///////////////////////////////////////////////////

    ///////////////////////////////////////////////////
    // SEED 검사
    // 운영자 명령을 위한 코드(운영자 명령일때는 Index값이 0으로 들어온다).
    if seedindex = 0 then begin
      for i := 0 to ItemList.Count - 1 do begin
        if UserEngine.GetStdItemIndex(seedname) = PTUserItem(ItemList[i]).Index then
        begin
          psSeed    := UserEngine.GetStdItem(PTUserItem(Itemlist[i]).Index);
          seedindex := PTUserItem(ItemList[i]).MakeIndex;
          puSeed    := PTUserItem(ItemList[i]);
          break;
        end;
      end;
      if i = ItemList.Count then
        exit;
    end else      // 운영자가 아닌 정상적인 경우.
    begin
      for i := 0 to ItemList.Count - 1 do begin
        if seedindex = PTUserItem(ItemList[i]).MakeIndex then begin
          psSeed := UserEngine.GetStdItem(PTUserItem(Itemlist[i]).Index);
          puSeed := PTUserItem(ItemList[i]);
          break;
        end;
      end;
      if i = ItemList.Count then
        exit;
    end;
    ///////////////////////////////////////////////////

    if puSeed.Index > 0 then begin
      if CheckJewelryItem(psJewelry.StdMode) then begin
        iVal := CheckSeedItem(psSeed, psJewelry);

        if iVal = 2 then begin
          iResult := CalcUpgradeProbability(puSeed, puJewelry,
            psSeed, psJewelry, ExecCount, iSumOfOption, fProbability);

          if (iResult <= 2) and (iResult >= 0) then begin
{
                  //업그레이드 전 로그 남김(sonmg) => 삭제...
                  AddUserLog ('30'#9 + //업전_ +
                              MapName + ''#9 +
                              IntToStr(CX) + ''#9 +
                              IntToStr(CY) + ''#9 +
                              UserName + ''#9 +
                              seedname + ''#9 +
                              IntToStr(seedindex) + ''#9 +
                              '0'#9 +
                              UpgradeResultToStr(puSeed.desc));
}
          end;

          // 업그레이드 이전 값을 얻어온다.
          iBeforeValue :=
            GetTotalValueOfOption(puSeed, psSeed, psJewelry, strResult, strEtc);

          case iResult of
            2: begin //성공
              // 아이템 업그레이드 실행.
              if DoUpgradeItem(puSeed, psSeed, psJewelry) = 0 then begin
                SysMsg('The attribute cannot be upgraded.', 0);
                exit;
              end;

              // 업그레이드 이후 값을 얻어온다.
              iAfterValue :=
                GetTotalValueOfOption(puSeed, psSeed, psJewelry, strResult, strEtc);

              // Jewelry 아이템 삭제.
              //                     SysMsg('삭제된 아이템 : ' + IntToStr(puJewelry.MakeIndex), 0);
              DeletePItemAndSend(puJewelry);

              // 임시 확인 메시지.
              //                     SysMsg (seedname + '(' + IntToStr(seedindex) + ')' + '에 '
              //                        + jewelryname + '(' + IntToStr(jewelryindex) + ')' + '을 발랐습니다.', 1);
              SysMsg(strResult + strEtc + ' upgraded to ' + seedname, 2);

              // 서버에 메시지를 남김.
              //                     MainOutMessage ('[UpgradeItem:성공] ' + UserName + ' ' + seedname + ' ' + jewelryname );

              //업그레이드 로그 남김(sonmg)
              AddUserLog('31'#9 + //업후_ +
                MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
                ''#9 + UserName + ''#9 + seedname + ''#9 + IntToStr(seedindex) +
                ''#9 + '2'#9 + UpgradeResultToStr(iSumOfOption,
                strResult, iBeforeValue, iAfterValue, fProbability, psJewelry.StdMode));

              //클라이언트로 결과 메시지 전송.
              SendDefMessage(SM_UPGRADEITEM_RESULT, seedindex,
                iResult, 0, 0, seedname);

            end;
            1: begin // 불변
              // 업그레이드 이후 값을 얻어온다.
              iAfterValue :=
                GetTotalValueOfOption(puSeed, psSeed, psJewelry, strResult, strEtc);

              // Jewelry 아이템 삭제.
              DeletePItemAndSend(puJewelry);

              // 임시 확인 메시지.
              //                     SysMsg (seedname + '(' + IntToStr(seedindex) + ')' + '에 '
              //                        + jewelryname + '(' + IntToStr(jewelryindex) + ')' + '을 발랐습니다.', 1);
              SysMsg(seedname + ' is not upgraded.', 1);

              // 서버에 메시지를 남김.
              //                     MainOutMessage ('[UpgradeItem:불변] ' + UserName + ' ' + seedname + ' ' + jewelryname );

              //업그레이드 로그 남김(sonmg)
              AddUserLog('31'#9 + //업후_ +
                MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
                ''#9 + UserName + ''#9 + seedname + ''#9 + IntToStr(seedindex) +
                ''#9 + '1'#9 + UpgradeResultToStr(iSumOfOption,
                strResult, iBeforeValue, iAfterValue, fProbability, psJewelry.StdMode));

              //클라이언트로 결과 메시지 전송.
              SendDefMessage(SM_UPGRADEITEM_RESULT, seedindex,
                iResult, 0, 0, seedname);

            end;
            0: begin // 실패(파괴)
              // 업그레이드 이후 값을 얻어온다.
              iAfterValue :=
                GetTotalValueOfOption(puSeed, psSeed, psJewelry, strResult, strEtc);

              // Jewelry 아이템 삭제.
              DeletePItemAndSend(puJewelry);
              // Seed 아이템 삭제.
              DeletePItemAndSendWithFlag(puSeed, word(True));
              // 파괴 효과를 위한 패킷

              // 임시 확인 메시지.
              //                     SysMsg (seedname + '(' + IntToStr(seedindex) + ')' + '에 '
              //                        + jewelryname + '(' + IntToStr(jewelryindex) + ')' + '을 발랐습니다.', 1);
              SysMsg('Item(' + seedname + ') is destroyed.', 0);

              // 서버에 메시지를 남김.
              //                     MainOutMessage ('[UpgradeItem:파괴] ' + UserName + ' ' + seedname + ' ' + jewelryname );

              //업그레이드 로그 남김(sonmg)
              AddUserLog('31'#9 + //업후_ +
                MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
                ''#9 + UserName + ''#9 + seedname + ''#9 + IntToStr(seedindex) +
                ''#9 + '0'#9 + UpgradeResultToStr(iSumOfOption,
                strResult, iBeforeValue, iAfterValue, fProbability, psJewelry.StdMode));

              //클라이언트로 결과 메시지 전송.
              SendDefMessage(SM_UPGRADEITEM_RESULT, seedindex,
                iResult, 0, 0, seedname);

            end;
            else begin
              // 서버에 메시지를 남김.
              MainOutMessage('[UpgradeItem] ' + UserName +
                ' DoUpgradeItem : Result value is abnormal.');
            end;
          end;  // end of case.
        end else if iVal = 1 then begin
          SysMsg('The attribute of this item cannot be upgraded.', 0);
        end else if iVal = 3 then begin
          SysMsg('The unique item cannot be upgraded.', 0);
          // 바느질용품, 뼈망치.
        end else if iVal = 11 then begin
          if RepairItemNormaly(psSeed, puSeed) then begin
            // 수리용품 아이템 삭제.
            DeletePItemAndSend(puJewelry);
          end;
        end else if iVal = 10 then begin
          SysMsg('This item cannot be repaired.', 0);
          // 노끈(2004/05/03 sonmg)
        end else if iVal = 21 then begin
          iShape := FindItemToBindFromBag(6, psSeed.Name, dellist);
          if iShape >= 0 then begin
            // 묶음 아이템 생성.
            if BindPotionUnit(iShape, 6) = True then begin
              // 노끈 하나 삭제.
              DeleteItemFromBag(psJewelry, puJewelry);

              //삭제목록에 추가된 바인드 아이템들 삭제.
              if dellist <> nil then begin
                for j := 0 to dellist.Count - 1 do begin
                  for k := 0 to Itemlist.Count - 1 do begin
                    if PTUserItem(ItemList[k]).MakeIndex =
                      integer(dellist.Objects[j]) then begin
                      Dispose(PTUserItem(ItemList[k]));
                      ItemList.Delete(k);
                      break;
                    end;
                  end;
                end;

                SendMsg(self, RM_DELITEMS, 0, integer(dellist), 0, 0, '');
                //dellist는 rm_delitem에서 free 시켜야 한다.

                WeightChanged;
              end;
            end else begin
              SysMsg('This item cannot be bound.', 0);
            end;

          end;
        end else if iVal = 20 then begin
          SysMsg('This item cannot be bound.', 0);
        end else
          SysMsg(seedname + ' : Cannot attach to this item.', 0);
      end;// else SysMsg (jewelryname + ' : 이 아이템으로는 업그레이드할 수 없습니다.', 0);
    end;

  except
    MainOutMessage('[Exception] TUserHuman.CmdUpgradeItem');
  end;
end;

// 인덱스로 기본값+업그레이드된값을 리턴하는 함수
function TUserHuman.GetTotalValueOfOption(pu: PTUserItem;
  pstd, psJewelry: PTStdItem; var strResult, strEtc: string): integer;
var
  iBaseValue, iUpgradeValue: integer;
  iOptionIndex: integer;
begin
  Result     := 0;
  iBaseValue := 0;
  iUpgradeValue := 0;
  iOptionIndex := 0;

  ////////////////////////////////////////////////
  // 업그레이드 옵션 확인
  // 결과 문자열 리턴.
  // 업그레이드 할 수 있는 옵션은 한번에 하나(맨 처음 나오는 옵션을 선택한다.)
  if psJewelry.DC > 0 then begin
    iOptionIndex := 100;
    strResult := 'DC';
    strEtc := ' ' + IntToStr(psJewelry.DC);
  end else if psJewelry.MC > 0 then begin
    iOptionIndex := 101;
    strResult := 'MC';
    strEtc := ' ' + IntToStr(psJewelry.MC);
  end else if psJewelry.SC > 0 then begin
    iOptionIndex := 102;
    strResult := 'SC';
    strEtc := ' ' + IntToStr(psJewelry.SC);
  end else if psJewelry.AC > 0 then begin
    iOptionIndex := 103;
    strResult := 'AC';
    strEtc := ' ' + IntToStr(psJewelry.AC);
  end else if psJewelry.MAC > 0 then begin
    iOptionIndex := 104;
    strResult := 'AMC';
    strEtc := ' ' + IntToStr(psJewelry.MAC);
  end else if psJewelry.DuraMax > 0 then begin
    iOptionIndex := 105;
    strResult := 'Dura';
    strEtc := ' ' + IntToStr(Round(psJewelry.DuraMax / 1000));
  end else if psJewelry.Accurate > 0 then begin
    iOptionIndex := 106;
    strResult := 'Acc';
    strEtc := ' ' + IntToStr(psJewelry.Accurate);
  end else if psJewelry.Agility > 0 then begin
    iOptionIndex := 107;
    strResult := 'Agil';
    strEtc := ' ' + IntToStr(psJewelry.Agility);
  end else if psJewelry.AtkSpd > 0 then begin
    iOptionIndex := 108;
    strResult := 'A.Spd';
    strEtc := ' ' + IntToStr(psJewelry.AtkSpd);
  end else if psJewelry.Slowdown > 0 then begin
    iOptionIndex := 109;
    strResult := 'Slowdown';
    strEtc := ' ' + IntToStr(psJewelry.Slowdown);
  end else if psJewelry.Tox > 0 then begin
    iOptionIndex := 110;
    strResult := 'Poisoning';
    strEtc := ' ' + IntToStr(psJewelry.Tox);
  end else if psJewelry.MgAvoid > 0 then begin
    iOptionIndex := 111;
    strResult := 'M.Resist';
    strEtc := ' ' + IntToStr(psJewelry.MgAvoid);
  end else if psJewelry.ToxAvoid > 0 then begin
    iOptionIndex := 112;
    strResult := 'P.Resist';
    strEtc := ' ' + IntToStr(psJewelry.ToxAvoid);
  end;
  ////////////////////////////////////////////////

  // iIndex값의 의미
  // 100:파괴, 101:마법, 102:도력, 103:방어, 104:마항, 105:내구
  // 106:정확, 107:민첩, 108:공속, 109:둔화, 110:중독, 111:마저항, 112:중저항
  case pstd.StdMode of
    ///////////////////////////////////////////////////////
    5, 6:  // 무기
    begin
      case iOptionIndex of
        100://파괴
        begin
          iBaseValue := HIBYTE(pstd.DC);
          iUpgradeValue := pu.Desc[0];
          Result := iBaseValue + iUpgradeValue;
        end;
        101://마법
        begin
          iBaseValue := HIBYTE(pstd.MC);
          iUpgradeValue := pu.Desc[1];
          Result := iBaseValue + iUpgradeValue;
        end;
        102://도력
        begin
          iBaseValue := HIBYTE(pstd.SC);
          iUpgradeValue := pu.Desc[2];
          Result := iBaseValue + iUpgradeValue;
        end;
        103://방어
        begin
        end;
        104://마항
        begin
        end;
        105://내구
        begin
          iBaseValue := Round(pstd.DuraMax / 1000);
          iUpgradeValue := Round(pu.DuraMax / 1000);
          Result := iUpgradeValue;   // 내구
        end;
        106://정확
        begin
          iBaseValue := HIBYTE(pstd.AC);
          iUpgradeValue := pu.Desc[5];
          Result := iBaseValue + iUpgradeValue;
        end;
        107://민첩
        begin
        end;
        108://공속
        begin
          iBaseValue := ItemMan.RealAttackSpeed(HIBYTE(pstd.MAC));
          iUpgradeValue := ItemMan.RealAttackSpeed(pu.Desc[6]);
{
                     //공속이 10보다 작을 때를 위한 처리.
                     if HiByte(pstd.MAC) > 10 then begin
                        iBaseValue := HiByte(pstd.MAC) - 10;
                        iUpgradeValue := pu.Desc[6];
                     end else begin
                        iBaseValue := - HIBYTE(pstd.MAC);
                        iUpgradeValue := pu.Desc[6];
                     end;
}
          Result := iBaseValue + iUpgradeValue;
        end;
        109://둔화
        begin
          iBaseValue := pstd.Slowdown;
          iUpgradeValue := pu.Desc[12];
          Result := iBaseValue + iUpgradeValue;
        end;
        110://중독
        begin
          iBaseValue := pstd.Tox;
          iUpgradeValue := pu.Desc[13];
          Result := iBaseValue + iUpgradeValue;
        end;
        111://마저항
        begin
        end;
        112://중저항
        begin
        end;
      end;//case iOptionIndex of
    end;
    ///////////////////////////////////////////////////////
    10, 11, 15: // 옷, 투구
    begin
      case iOptionIndex of
        100://파괴
        begin
          iBaseValue := HIBYTE(pstd.DC);
          iUpgradeValue := pu.Desc[2];
          Result := iBaseValue + iUpgradeValue;
        end;
        101://마법
        begin
          iBaseValue := HIBYTE(pstd.MC);
          iUpgradeValue := pu.Desc[3];
          Result := iBaseValue + iUpgradeValue;
        end;
        102://도력
        begin
          iBaseValue := HIBYTE(pstd.SC);
          iUpgradeValue := pu.Desc[4];
          Result := iBaseValue + iUpgradeValue;
        end;
        103://방어
        begin
          iBaseValue := HIBYTE(pstd.AC);
          iUpgradeValue := pu.Desc[0];
          Result := iBaseValue + iUpgradeValue;
        end;
        104://마항
        begin
          iBaseValue := HIBYTE(pstd.MAC);
          iUpgradeValue := pu.Desc[1];
          Result := iBaseValue + iUpgradeValue;
        end;
        105://내구
        begin
          iBaseValue := Round(pstd.DuraMax / 1000);
          iUpgradeValue := Round(pu.DuraMax / 1000);
          Result := iUpgradeValue;   // 내구
        end;
        106:  //정확
        begin // 투구에만 해당
          iBaseValue := pstd.Accurate;
          iUpgradeValue := pu.Desc[11];
          Result := iBaseValue + iUpgradeValue;
        end;
        107:  //민첩
        begin // 옷에만 해당
          iBaseValue := pstd.Agility;
          iUpgradeValue := pu.Desc[11];
          Result := iBaseValue + iUpgradeValue;
        end;
        108://공속
        begin
        end;
        109://둔화
        begin
        end;
        110://중독
        begin
        end;
        111://마저항
        begin
          iBaseValue := pstd.MgAvoid;
          iUpgradeValue := pu.Desc[12];
          Result := iBaseValue + iUpgradeValue;
        end;
        112://중저항
        begin
          iBaseValue := pstd.ToxAvoid;
          iUpgradeValue := pu.Desc[13];
          Result := iBaseValue + iUpgradeValue;
        end;
      end;//case iOptionIndex of
    end;
        ///////////////////////////////////////////////////////
    19: // 목걸이19
    begin
      case iOptionIndex of
        100://파괴
        begin
          iBaseValue := HIBYTE(pstd.DC);
          iUpgradeValue := pu.Desc[2];
          Result := iBaseValue + iUpgradeValue;
        end;
        101://마법
        begin
          iBaseValue := HIBYTE(pstd.MC);
          iUpgradeValue := pu.Desc[3];
          Result := iBaseValue + iUpgradeValue;
        end;
        102://도력
        begin
          iBaseValue := HIBYTE(pstd.SC);
          iUpgradeValue := pu.Desc[4];
          Result := iBaseValue + iUpgradeValue;
        end;
        103://방어
        begin
        end;
        104://마항
        begin
        end;
        105://내구
        begin
          iBaseValue := Round(pstd.DuraMax / 1000);
          iUpgradeValue := Round(pu.DuraMax / 1000);
          Result := iUpgradeValue;   // 내구
        end;
        106://정확
        begin
          iBaseValue := pstd.Accurate;
          iUpgradeValue := pu.Desc[11];
          Result := iBaseValue + iUpgradeValue;
        end;
        107://민첩
        begin
        end;
        108://공속
        begin
          iBaseValue := pstd.AtkSpd;
          iUpgradeValue := pu.Desc[9];
          Result := iBaseValue + iUpgradeValue;
        end;
        109://둔화
        begin
          iBaseValue := pstd.Slowdown;
          iUpgradeValue := pu.Desc[12];
          Result := iBaseValue + iUpgradeValue;
        end;
        110://중독
        begin
          iBaseValue := pstd.Tox;
          iUpgradeValue := pu.Desc[13];
          Result := iBaseValue + iUpgradeValue;
        end;
        111://마저항
        begin
          iBaseValue := HIBYTE(pstd.AC);
          iUpgradeValue := pu.Desc[0];
          Result := iBaseValue + iUpgradeValue;
        end;
        112://중저항
        begin
        end;
      end;//case iOptionIndex of
    end;
        ///////////////////////////////////////////////////////
    20: // 목걸이
    begin
      case iOptionIndex of
        100://파괴
        begin
          iBaseValue := HIBYTE(pstd.DC);
          iUpgradeValue := pu.Desc[2];
          Result := iBaseValue + iUpgradeValue;
        end;
        101://마법
        begin
          iBaseValue := HIBYTE(pstd.MC);
          iUpgradeValue := pu.Desc[3];
          Result := iBaseValue + iUpgradeValue;
        end;
        102://도력
        begin
          iBaseValue := HIBYTE(pstd.SC);
          iUpgradeValue := pu.Desc[4];
          Result := iBaseValue + iUpgradeValue;
        end;
        103://방어
        begin
        end;
        104://마항
        begin
        end;
        105://내구
        begin
          iBaseValue := Round(pstd.DuraMax / 1000);
          iUpgradeValue := Round(pu.DuraMax / 1000);
          Result := iUpgradeValue;   // 내구
        end;
        106://정확
        begin
          iBaseValue := HIBYTE(pstd.AC);
          iUpgradeValue := pu.Desc[0];
          Result := iBaseValue + iUpgradeValue;
        end;
        107://민첩
        begin
          iBaseValue := HIBYTE(pstd.MAC);
          iUpgradeValue := pu.Desc[1];
          Result := iBaseValue + iUpgradeValue;
        end;
        108://공속
        begin
          iBaseValue := pstd.AtkSpd;
          iUpgradeValue := pu.Desc[9];
          Result := iBaseValue + iUpgradeValue;
        end;
        109://둔화
        begin
          iBaseValue := pstd.Slowdown;
          iUpgradeValue := pu.Desc[12];
          Result := iBaseValue + iUpgradeValue;
        end;
        110://중독
        begin
          iBaseValue := pstd.Tox;
          iUpgradeValue := pu.Desc[13];
          Result := iBaseValue + iUpgradeValue;
        end;
        111://마저항
        begin
          iBaseValue := pstd.MgAvoid;
          iUpgradeValue := pu.Desc[11];
          Result := iBaseValue + iUpgradeValue;
        end;
        112://중저항
        begin
        end;
      end;//case iOptionIndex of
    end;
        ///////////////////////////////////////////////////////
    21: // 목걸이
    begin
      case iOptionIndex of
        100://파괴
        begin
          iBaseValue := HIBYTE(pstd.DC);
          iUpgradeValue := pu.Desc[2];
          Result := iBaseValue + iUpgradeValue;
        end;
        101://마법
        begin
          iBaseValue := HIBYTE(pstd.MC);
          iUpgradeValue := pu.Desc[3];
          Result := iBaseValue + iUpgradeValue;
        end;
        102://도력
        begin
          iBaseValue := HIBYTE(pstd.SC);
          iUpgradeValue := pu.Desc[4];
          Result := iBaseValue + iUpgradeValue;
        end;
        103://방어
        begin
        end;
        104://마항
        begin
        end;
        105://내구
        begin
          iBaseValue := Round(pstd.DuraMax / 1000);
          iUpgradeValue := Round(pu.DuraMax / 1000);
          Result := iUpgradeValue;   // 내구
        end;
        106://정확
        begin
          iBaseValue := pstd.Accurate;
          iUpgradeValue := pu.Desc[11];
          Result := iBaseValue + iUpgradeValue;
        end;
        107://민첩
        begin
        end;
        108://공속
        begin
          iBaseValue := LOBYTE(pstd.AC) - LOBYTE(pstd.MAC) + pstd.AtkSpd;
          iUpgradeValue := pu.Desc[9];
          Result := iBaseValue + iUpgradeValue;
        end;
        109://둔화
        begin
          iBaseValue := pstd.Slowdown;
          iUpgradeValue := pu.Desc[12];
          Result := iBaseValue + iUpgradeValue;
        end;
        110://중독
        begin
          iBaseValue := pstd.Tox;
          iUpgradeValue := pu.Desc[13];
          Result := iBaseValue + iUpgradeValue;
        end;
        111://마저항
        begin
          iBaseValue := pstd.MgAvoid;
          iUpgradeValue := pu.Desc[7];
          Result := iBaseValue + iUpgradeValue;
        end;
        112://중저항
        begin
        end;
      end;//case iOptionIndex of
    end;
        ///////////////////////////////////////////////////////
    22: // 반지
    begin
      case iOptionIndex of
        100://파괴
        begin
          iBaseValue := HIBYTE(pstd.DC);
          iUpgradeValue := pu.Desc[2];
          Result := iBaseValue + iUpgradeValue;
        end;
        101://마법
        begin
          iBaseValue := HIBYTE(pstd.MC);
          iUpgradeValue := pu.Desc[3];
          Result := iBaseValue + iUpgradeValue;
        end;
        102://도력
        begin
          iBaseValue := HIBYTE(pstd.SC);
          iUpgradeValue := pu.Desc[4];
          Result := iBaseValue + iUpgradeValue;
        end;
        103://방어
        begin
          iBaseValue := HIBYTE(pstd.AC);
          iUpgradeValue := pu.Desc[0];
          Result := iBaseValue + iUpgradeValue;
        end;
        104://마항
        begin
          iBaseValue := HIBYTE(pstd.MAC);
          iUpgradeValue := pu.Desc[1];
          Result := iBaseValue + iUpgradeValue;
        end;
        105://내구
        begin
          iBaseValue := Round(pstd.DuraMax / 1000);
          iUpgradeValue := Round(pu.DuraMax / 1000);
          Result := iUpgradeValue;   // 내구
        end;
        106://정확
        begin
        end;
        107://민첩
        begin
        end;
        108://공속
        begin
          iBaseValue := pstd.AtkSpd;
          iUpgradeValue := pu.Desc[9];
          Result := iBaseValue + iUpgradeValue;
        end;
        109://둔화
        begin
          iBaseValue := pstd.Slowdown;
          iUpgradeValue := pu.Desc[12];
          Result := iBaseValue + iUpgradeValue;
        end;
        110://중독
        begin
          iBaseValue := pstd.Tox;
          iUpgradeValue := pu.Desc[13];
          Result := iBaseValue + iUpgradeValue;
        end;
        111://마저항
        begin
        end;
        112://중저항
        begin
        end;
      end;//case iOptionIndex of
    end;
        ///////////////////////////////////////////////////////
    23: // 반지23
    begin
      case iOptionIndex of
        100://파괴
        begin
          iBaseValue := HIBYTE(pstd.DC);
          iUpgradeValue := pu.Desc[2];
          Result := iBaseValue + iUpgradeValue;
        end;
        101://마법
        begin
          iBaseValue := HIBYTE(pstd.MC);
          iUpgradeValue := pu.Desc[3];
          Result := iBaseValue + iUpgradeValue;
        end;
        102://도력
        begin
          iBaseValue := HIBYTE(pstd.SC);
          iUpgradeValue := pu.Desc[4];
          Result := iBaseValue + iUpgradeValue;
        end;
        103://방어
        begin
        end;
        104://마항
        begin
        end;
        105://내구
        begin
          iBaseValue := Round(pstd.DuraMax / 1000);
          iUpgradeValue := Round(pu.DuraMax / 1000);
          Result := iUpgradeValue;   // 내구
        end;
        106://정확
        begin
        end;
        107://민첩
        begin
        end;
        108://공속
        begin
          iBaseValue := LOBYTE(pstd.AC) - LOBYTE(pstd.MAC) + pstd.AtkSpd;
          iUpgradeValue := pu.Desc[9];
          Result := iBaseValue + iUpgradeValue;
        end;
        109://둔화
        begin
          iBaseValue := pstd.Slowdown;
          iUpgradeValue := pu.Desc[12];
          Result := iBaseValue + iUpgradeValue;
        end;
        110://중독
        begin
          iBaseValue := pstd.Tox;
          iUpgradeValue := pu.Desc[13];
          Result := iBaseValue + iUpgradeValue;
        end;
        111://마저항
        begin
        end;
        112://중저항
        begin
        end;
      end;//case iOptionIndex of
    end;
        ///////////////////////////////////////////////////////
    24: // 팔찌24
    begin
      case iOptionIndex of
        100://파괴
        begin
          iBaseValue := HIBYTE(pstd.DC);
          iUpgradeValue := pu.Desc[2];
          Result := iBaseValue + iUpgradeValue;
        end;
        101://마법
        begin
          iBaseValue := HIBYTE(pstd.MC);
          iUpgradeValue := pu.Desc[3];
          Result := iBaseValue + iUpgradeValue;
        end;
        102://도력
        begin
          iBaseValue := HIBYTE(pstd.SC);
          iUpgradeValue := pu.Desc[4];
          Result := iBaseValue + iUpgradeValue;
        end;
        103://방어
        begin
        end;
        104://마항
        begin
        end;
        105://내구
        begin
          iBaseValue := Round(pstd.DuraMax / 1000);
          iUpgradeValue := Round(pu.DuraMax / 1000);
          Result := iUpgradeValue;   // 내구
        end;
        106://정확
        begin
          iBaseValue := HIBYTE(pstd.AC);
          iUpgradeValue := pu.Desc[0];
          Result := iBaseValue + iUpgradeValue;
        end;
        107://민첩
        begin
          iBaseValue := HIBYTE(pstd.MAC);
          iUpgradeValue := pu.Desc[1];
          Result := iBaseValue + iUpgradeValue;
        end;
        108://공속
        begin
        end;
        109://둔화
        begin
        end;
        110://중독
        begin
        end;
        111://마저항
        begin
        end;
        112://중저항
        begin
        end;
      end;//case iOptionIndex of
    end;
        ///////////////////////////////////////////////////////
    26: // 팔찌
    begin
      case iOptionIndex of
        100://파괴
        begin
          iBaseValue := HIBYTE(pstd.DC);
          iUpgradeValue := pu.Desc[2];
          Result := iBaseValue + iUpgradeValue;
        end;
        101://마법
        begin
          iBaseValue := HIBYTE(pstd.MC);
          iUpgradeValue := pu.Desc[3];
          Result := iBaseValue + iUpgradeValue;
        end;
        102://도력
        begin
          iBaseValue := HIBYTE(pstd.SC);
          iUpgradeValue := pu.Desc[4];
          Result := iBaseValue + iUpgradeValue;
        end;
        103://방어
        begin
          iBaseValue := HIBYTE(pstd.AC);
          iUpgradeValue := pu.Desc[0];
          Result := iBaseValue + iUpgradeValue;
        end;
        104://마항
        begin
          iBaseValue := HIBYTE(pstd.MAC);
          iUpgradeValue := pu.Desc[1];
          Result := iBaseValue + iUpgradeValue;
        end;
        105://내구
        begin
          iBaseValue := Round(pstd.DuraMax / 1000);
          iUpgradeValue := Round(pu.DuraMax / 1000);
          Result := iUpgradeValue;   // 내구
        end;
        106://정확
        begin
          iBaseValue := pstd.Accurate;
          iUpgradeValue := pu.Desc[11];
          Result := iBaseValue + iUpgradeValue;
        end;
        107://민첩
        begin
          iBaseValue := pstd.Agility;
          iUpgradeValue := pu.Desc[12];
          Result := iBaseValue + iUpgradeValue;
        end;
        108://공속
        begin
        end;
        109://둔화
        begin
        end;
        110://중독
        begin
        end;
        111://마저항
        begin
        end;
        112://중저항
        begin
        end;
      end;//case iOptionIndex of
    end;
        ///////////////////////////////////////////////////////
    52: // 신발
    begin
      case iOptionIndex of
        100://파괴
        begin
        end;
        101://마법
        begin
        end;
        102://도력
        begin
        end;
        103://방어
        begin
          iBaseValue := HIBYTE(pstd.AC);
          iUpgradeValue := pu.Desc[0];
          Result := iBaseValue + iUpgradeValue;
        end;
        104://마항
        begin
          iBaseValue := HIBYTE(pstd.MAC);
          iUpgradeValue := pu.Desc[1];
          Result := iBaseValue + iUpgradeValue;
        end;
        105://내구
        begin
          iBaseValue := Round(pstd.DuraMax / 1000);
          iUpgradeValue := Round(pu.DuraMax / 1000);
          Result := iUpgradeValue;   // 내구
        end;
        106://정확
        begin
        end;
        107://민첩
        begin
          iBaseValue := pstd.Agility;
          iUpgradeValue := pu.Desc[3];
          Result := iBaseValue + iUpgradeValue;
        end;
        108://공속
        begin
        end;
        109://둔화
        begin
        end;
        110://중독
        begin
        end;
        111://마저항
        begin
        end;
        112://중저항
        begin
        end;
      end;//case iOptionIndex of
    end;
        ///////////////////////////////////////////////////////
    54: // 벨트
    begin
      case iOptionIndex of
        100://파괴
        begin
        end;
        101://마법
        begin
        end;
        102://도력
        begin
        end;
        103://방어
        begin
          iBaseValue := HIBYTE(pstd.AC);
          iUpgradeValue := pu.Desc[0];
          Result := iBaseValue + iUpgradeValue;
        end;
        104://마항
        begin
          iBaseValue := HIBYTE(pstd.MAC);
          iUpgradeValue := pu.Desc[1];
          Result := iBaseValue + iUpgradeValue;
        end;
        105://내구
        begin
          iBaseValue := Round(pstd.DuraMax / 1000);
          iUpgradeValue := Round(pu.DuraMax / 1000);
          Result := iUpgradeValue;   // 내구
        end;
        106://정확
        begin
          iBaseValue := pstd.Accurate;
          iUpgradeValue := pu.Desc[2];
          Result := iBaseValue + iUpgradeValue;
        end;
        107://민첩
        begin
          iBaseValue := pstd.Agility;
          iUpgradeValue := pu.Desc[3];
          Result := iBaseValue + iUpgradeValue;
        end;
        108://공속
        begin
        end;
        109://둔화
        begin
        end;
        110://중독
        begin
        end;
        111://마저항
        begin
        end;
        112://중저항
        begin
          iBaseValue := pstd.ToxAvoid;
          iUpgradeValue := pu.Desc[13];
          Result := iBaseValue + iUpgradeValue;
        end;
      end;//case iOptionIndex of
    end;
  end;

end;

procedure TUserHuman.CmdMakeAllJewelryItem(nSelect: integer);
begin
  if nSelect = 0 then begin
    CmdMakeItem('BraveryGem', 1);
    CmdMakeItem('MagicGem', 1);
    CmdMakeItem('SoulGem', 1);
    CmdMakeItem('ProtectionGem', 1);
    CmdMakeItem('EvilSlayerGem', 1);
    CmdMakeItem('DurabilityGem', 1);
    CmdMakeItem('AccuracyGem', 1);
    CmdMakeItem('AgilityGem', 1);
    CmdMakeItem('StormGem', 1);
    CmdMakeItem('FreezingGem', 1);
    CmdMakeItem('PoisonGem', 1);
    CmdMakeItem('DisillusionGem', 1);
    CmdMakeItem('EnduranceGem', 1);
  end else begin
    CmdMakeItem('BraveryOrb', 1);
    CmdMakeItem('MagicOrb', 1);
    CmdMakeItem('SoulOrb', 1);
    CmdMakeItem('ProtectionOrb', 1);
    CmdMakeItem('EvilSlayerOrb', 1);
    CmdMakeItem('DurabilityOrb', 1);
    CmdMakeItem('AccuracyOrb', 1);
    CmdMakeItem('AgilityOrb', 1);
    CmdMakeItem('StormOrb', 1);
    CmdMakeItem('FreezingOrb', 1);
    CmdMakeItem('PoisonOrb', 1);
    CmdMakeItem('DisillusionOrb', 1);
    CmdMakeItem('EnduranceOrb', 1);
  end;
end;

///////////////////////////////////////////////////////////////

// 2003/09/15 체팅로그 명령 추가

procedure TUserHuman.CmdAddChatLogList(whostr: string; pass: boolean);
var
  idx:    integer;
  bExist: boolean;
begin
  if whostr <> '' then begin
    bExist := UserEngine.FindChatLogList(whostr, idx);
    if not bExist then begin
      UserEngine.ChatLogList.Add(whostr);
      if pass then begin
        FrmDB.SaveChatLogFiles;
        UserEngine.SendInterMsg(ISM_RELOADCHATLOG, ServerIndex, '');
      end;
      SysMsg(whostr + ' is added to ChatLogList.', 1);
    end else
      SysMsg(whostr + ' exist in ChatLogList.', 0);
  end else
    SysMsg(whostr + ' is not found.', 0);
end;

procedure TUserHuman.CmdDelChatLogList(whostr: string; pass: boolean);
var
  idx:    integer;
  bExist: boolean;
begin
  bExist := UserEngine.FindChatLogList(whostr, idx);
  if bExist then begin
    UserEngine.ChatLogList.Delete(idx);
    if pass then begin
      FrmDB.SaveChatLogFiles;
      UserEngine.SendInterMsg(ISM_RELOADCHATLOG, ServerIndex, '');
    end;
    SysMsg(whostr + ' is deleted from ChatLogList.', 1);
  end else
    SysMsg(whostr + ' is not found.', 0);
end;

procedure TUserHuman.CmdSendChatLogList;
var
  i: integer;
begin
  for i := 0 to UserEngine.ChatLogList.Count - 1 do begin
    SysMsg(IntToStr(i + 1) + '=' + UserEngine.ChatLogList.Strings[i], 1);
  end;
end;


{-------문파장원 운영자 명령어---------------------------------------------}

procedure TUserHuman.CmdGuildAgitRegistration;
var
  agitnumber: integer;
begin
  if ServerIndex <> 0 then begin
    SysMsg('This command is not available on this server.', 0);
    exit;
  end;

  if IsGuildMaster then begin   // 문주이면
    if TGuild(MyGuild).GetTotalMemberCount <= MINAGITMEMBER then begin
      BoxMsg('You need at least ' + IntToStr(MINAGITMEMBER) +
        ' guild members for that.', 0);
      exit;
    end;

    // 대여하려는 문주가 장원 구입신청을 한 상태인지 검사
    if GuildAgitMan.IsExistInForSaleGuild(TGuild(MyGuild).GuildName) then begin
      BoxMsg('Purchase request has been already made.', 0);
      exit;
    end;

    if Gold >= GUILDAGITREGFEE then begin
      agitnumber := GuildAgitMan.AddGuildAgit(
        TGuild(MyGuild).GuildName, TGuild(MyGuild).GetGuildMaster,
        TGuild(MyGuild).GetAnotherGuildMaster);
      if agitnumber > -1 then begin
        DecGold(GUILDAGITREGFEE);
        GoldChanged;

        //로그남김
        AddUserLog('37'#9 + //장대여_
          MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
          ''#9 + UserName + ''#9 + TGuild(MyGuild).GuildName + ''#9 +
          IntToStr(agitnumber) + ''#9 + '1'#9 + IntToStr(GUILDAGITREGFEE));

        //장원게시판 리로드.
        GuildAgitBoardMan.LoadAllGaBoardList('');

        UserEngine.SendInterMsg(ISM_RELOADGUILDAGIT, ServerIndex, '');
        BoxMsg('You have rented a guild territory.', 1);
      end else begin
        BoxMsg('You can not rent a guild territory.', 0);
      end;
    end else
      BoxMsg('Lack of Gold.', 0);
  end else begin
    BoxMsg('Only guild master can use this command.', 0);
  end;
end;

procedure TUserHuman.CmdGuildAgitAutoMove;
var
  MapName:   string;
  guildagit: TGuildAgit;
begin
  if MyGuild = nil then begin
    BoxMsg('You cannot move into the guild territory.', 0);
    exit;
  end;
  if TGuild(MyGuild).GuildName = '' then begin
    BoxMsg('You cannot move into the guild territory.', 0);
    exit;
  end;

  guildagit := GuildAgitMan.GetGuildAgit(TGuild(MyGuild).GuildName);
  if guildagit <> nil then begin
    MapName := GuildAgitMan.GuildAgitMapName[0] + IntToStr(guildagit.GuildAgitNumber);
    if GrobalEnvir.GetEnvir(MapName) <> nil then begin
      SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
      //         RandomSpaceMove (MapName, 0); //무작위 공간이동
      //         SpaceMove (MapName, GuildAgitMan.EntranceX, GuildAgitMan.EntranceY, 0); //공간이동
      UserSpaceMove(MapName, IntToStr(GuildAgitMan.EntranceX),
        IntToStr(GuildAgitMan.EntranceY)); //공간이동
      SysMsg('You have moved into the guild territory.', 1);
    end;
  end else begin
    BoxMsg('Not Available.', 0);
  end;
end;

procedure TUserHuman.CmdGuildAgitDelete;
begin
  if ServerIndex <> 0 then begin
    SysMsg('This command is not available on this server.', 0);
    exit;
  end;

  if IsMyGuildMaster then begin   // 문주이면
    if GuildAgitMan.DelGuildAgit(TGuild(MyGuild).GuildName) then begin
      //장원게시판 리로드.
      GuildAgitBoardMan.LoadAllGaBoardList('');

      UserEngine.SendInterMsg(ISM_RELOADGUILDAGIT, ServerIndex, '');
      SysMsg('You returned the guild territory.', 1);
    end else begin
      SysMsg('You cannot return the guild territory.', 0);
    end;
  end else begin
    SysMsg('Only guild master can use this command.', 0);
  end;
end;

procedure TUserHuman.CmdGuildAgitExtendTime(Count: integer);
var
  agitnumber: integer;
begin
  if ServerIndex <> 0 then begin
    SysMsg('This command is not available on this server.', 0);
    exit;
  end;

  if IsMyGuildMaster then begin   // 문주이면
    if Gold >= GUILDAGITEXTENDFEE then begin
      agitnumber := GuildAgitMan.ExtendTime(Count, TGuild(MyGuild).GuildName);
      if agitnumber > -1 then begin
        DecGold(GUILDAGITEXTENDFEE);
        GoldChanged;

        //로그남김
        AddUserLog('38'#9 + //장연장_
          MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
          ''#9 + UserName + ''#9 + TGuild(MyGuild).GuildName + ''#9 +
          IntToStr(agitnumber) + ''#9 + '1'#9 + IntToStr(GUILDAGITEXTENDFEE));

        UserEngine.SendInterMsg(ISM_RELOADGUILDAGIT, ServerIndex, '');
        BoxMsg('The rent term has been extended.', 1);
      end else begin
        BoxMsg('The rent term can not be extended.', 0);
      end;
    end else
      BoxMsg('Lack of Gold.', 0);
  end else begin
    BoxMsg('Only guild master can use this command.', 0);
  end;
end;

procedure TUserHuman.CmdGuildAgitRemainTime;
var
  RemainDateTime, BaseDate, DiffDate: TDateTime;
  RemainDay: integer;
  Year, Month, Day: word;
  Hour, Min, Sec, MSec: word;
begin
  if MyGuild = nil then begin
    BoxMsg('You cannot check it up.', 0);
    exit;
  end;
  if TGuild(MyGuild).GuildName = '' then begin
    BoxMsg('You cannot check it up.', 0);
    exit;
  end;

  RemainDateTime := GuildAgitMan.GetRemainDateTime(TGuild(MyGuild).GuildName);

  // 에러 메시지.
{$IFNDEF UNDEF_DEBUG}//sonmg
  if RemainDateTime < -GUILDAGIT_DAYUNIT then begin
{$ELSE}
   if RemainDateTime < -(GUILDAGIT_DAYUNIT / 60 / 24) then begin
{$ENDIF}
    // 메시지 출력.
    BoxMsg('Not Available.', 0);
    exit;
  end;

  // 대여 기간이 지났을 경우(연체) 메시지.
  if RemainDateTime <= 0 then begin
{$IFNDEF UNDEF_DEBUG}//sonmg
    // 남은 날짜로 변환.
    RemainDateTime := GUILDAGIT_DAYUNIT + RemainDateTime;
    // 지난 날짜의 소수점 이하를 버림
    RemainDateTime := Trunc(RemainDateTime);
    // 메시지 출력.
    BoxMsg('The rent term is about to expire.\ \You have ' + FloatToStr(
      RemainDateTime) + ' day(s) to extend.', 0);
{$ELSE}
      // 남은 날짜로 변환.
      RemainDateTime := (GUILDAGIT_DAYUNIT / 60 / 24) + RemainDateTime;
      // 지난 날짜의 소수점 이하를 버림
      RemainDateTime := Trunc( RemainDateTime * 60 * 24 );
      // 메시지 출력.
      BoxMsg( 'The rent term is about to expire.\ \You have ' + FloatToStr( RemainDateTime ) + ' minute(s) to extend.', 0 );
{$ENDIF}

  end else begin
    // 날짜 분해.
    DecodeDate(RemainDateTime, Year, Month, Day);
    DecodeTime(RemainDateTime, Hour, Min, Sec, MSec);

    // 1899년 12월 31일 기준.
    BaseDate  := EncodeDate(1899, 12, 31);
    // 남은 일수 계산.
    DiffDate  := RemainDateTime - BaseDate + 1;
    RemainDay := Trunc(DiffDate);

    // 메시지 출력.
    BoxMsg('< ' + IntToStr(RemainDay) + 'day(s) ' + IntToStr(Hour) +
      'hour(s) ' + IntToStr(Min) + 'minute(s) > ' +
      ' remain until the rent term expires.', 1);
  end;
end;

procedure TUserHuman.CmdGuildAgitRecall(man: string; WholeRecall: boolean);
var
  i, k, n: integer;
  pgrank:  PTGuildRank;
  hum:     TUserHuman;
begin
  if IsMyGuildMaster then begin   // 문주이면
    // 전체소환.
    if WholeRecall then begin
      n := (GetTickCount - CGHIstart) div 1000;
      CGHIstart := CGHIstart + longword(n * 1000);
      if CGHIUseTime > n then
        CGHIUseTime := CGHIUseTime - n
      else
        CGHIUseTime := 0;
      if CGHIUseTime = 0 then begin
        if MyGuild <> nil then begin
          if TGuild(MyGuild).MemberList <> nil then begin
            for i := 0 to TGuild(MyGuild).MemberList.Count - 1 do begin
              pgrank := PTGuildRank(TGuild(MyGuild).MemberList[i]);
              for k := 0 to pgrank.MemList.Count - 1 do begin
                if pgrank.MemList.Objects[k] = self then
                  continue; // 자기 자신은 넘어감.

                GuildMasterRecallMan(pgrank.MemList[k], False);
              end;
              CGHIstart   := GetTickCount;
              CGHIUseTime := 3 * 60;
            end;
          end;
        end;
      end else begin
        SysMsg('After ' + IntToStr(CGHIUseTime) +
          ' second(s), you can use guild member recall.', 0);
      end;
      // 개인소환.
    end else begin
      GuildMasterRecallMan(man, True);
    end;
  end else begin
    BoxMsg('Only guild master can use this command.', 0);
  end;
end;

// 초대권 이동.
procedure TUserHuman.CmdGuildAgitFreeMove(AgitNum: integer);
var
  MapName:   string;
  guildagit: TGuildAgit;
  gname:     string;
begin
  if AgitNum <= 0 then
    exit;

  gname := GuildAgitMan.GetGuildNameFromAgitNum(AgitNum);

  guildagit := GuildAgitMan.GetGuildAgit(gname);
  if guildagit <> nil then begin
    MapName := GuildAgitMan.GuildAgitMapName[0] + IntToStr(guildagit.GuildAgitNumber);
    if GrobalEnvir.GetEnvir(MapName) <> nil then begin
      SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
      //         RandomSpaceMove (MapName, 0); //무작위 공간이동
      //         SpaceMove (MapName, GuildAgitMan.EntranceX, GuildAgitMan.EntranceY, 0); //공간이동
      UserSpaceMove(MapName, IntToStr(GuildAgitMan.EntranceX),
        IntToStr(GuildAgitMan.EntranceY)); //공간이동
      SysMsg('You have moved into the guild territory.', 1);
    end;
  end;
end;

procedure TUserHuman.CmdGuildAgitSale(StrForSaleGold: string);
var
  guildagit: TGuildAgit;
  salegold:  integer;
begin
  if ServerIndex <> 0 then begin
    SysMsg('This command is not available on this server.', 0);
    exit;
  end;

  if IsMyGuildMaster then begin   // 문주이면
    if Length(StrForSaleGold) > 10 then begin
      SysMsg('You either did not insert the sale price \ or inserted the amount that exceeds the limit.', 0);
      exit;
    end;

    salegold := Str_ToInt(StrForSaleGold, 0);

    if salegold <= 0 then begin
      SysMsg('You either did not insert the sale price \ or inserted the amount that exceeds the limit.', 0);
      exit;
    end;

    // 자기 자신의 문파 장원을 찾는다.
    guildagit := GuildAgitMan.GetGuildAgit(TGuild(MyGuild).GuildName);
    if guildagit <> nil then begin
      if guildagit.GetCurrentDelayStatus <= 0 then begin
        BoxMsg('The rent term is about to expire so you can sell the guild territory.',
          0);
        exit;
      end;

      // 판매중이 아니면
      if not guildagit.IsForSale then begin
        // 거래가 성사되지 않았으면
        if not guildagit.IsSoldOut then begin
          // 플래그 체크
          guildagit.ForSaleFlag  := 1;
          // 판매 금액 등록
          guildagit.ForSaleMoney := salegold;

          //로그남김
          AddUserLog('39'#9 + //장판매_
            MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
            ''#9 + UserName + ''#9 + TGuild(MyGuild).GuildName +
            ''#9 + IntToStr(guildagit.GuildAgitNumber) + ''#9 +
            '1'#9 + IntToStr(guildagit.ForSaleMoney));

          // 문파 장원 리스트 저장.
          GuildAgitMan.SaveGuildAgitList(False);

          UserEngine.SendInterMsg(ISM_RELOADGUILDAGIT, ServerIndex, '');

          // 메시지 출력.
          BoxMsg('The guild territory has been registered for sale at the price of '
            + GetGoldStr(salegold) + ' gold.', 1);
        end else begin
          BoxMsg('The transaction is finalized so it can not be sold again.', 0);
        end;
      end else begin
        BoxMsg('Your guild territory is currently on sale.', 0);
      end;
    end else begin
      BoxMsg('Not Available.', 0);
    end;
  end else begin
    BoxMsg('Only guild master can use this command.', 0);
  end;
end;

procedure TUserHuman.CmdGuildAgitSaleCancel;
var
  guildagit: TGuildAgit;
  salegold:  integer;
begin
  if ServerIndex <> 0 then begin
    SysMsg('This command is not available on this server.', 0);
    exit;
  end;

  if IsMyGuildMaster then begin   // 문주이면
    // 자기 자신의 문파 장원을 찾는다.
    guildagit := GuildAgitMan.GetGuildAgit(TGuild(MyGuild).GuildName);
    if guildagit <> nil then begin
      // 거래가 성사된 후에는 판매취소를 할 수 없다.
      if not guildagit.IsSoldOut then begin
        // 판매중이면
        if guildagit.IsForSale then begin
          // 판매취소한다.
          guildagit.ResetForSaleFields;

          //로그남김
          AddUserLog('40'#9 + //장취소_(장원판매취소)
            MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
            ''#9 + UserName + ''#9 + TGuild(MyGuild).GuildName +
            ''#9 + IntToStr(guildagit.GuildAgitNumber) + ''#9 + '1'#9 + '0');

          // 문파 장원 리스트 저장.
          GuildAgitMan.SaveGuildAgitList(False);

          UserEngine.SendInterMsg(ISM_RELOADGUILDAGIT, ServerIndex, '');

          BoxMsg('You canceled the sale offer of the guild territory.', 1);
        end else begin
          BoxMsg('Your guild territory is not on sale.', 0);
        end;
      end else begin
        BoxMsg('You can not cancel sale as the transaction is already completed.',
          0);
      end;
    end else begin
      BoxMsg('Not Available.', 0);
    end;
  end else begin
    BoxMsg('Only guild master can use this command.', 0);
  end;
end;

procedure TUserHuman.CmdGuildAgitBuy(page: integer);
const
  ONEPAGELINE = 10;
var
  salelist: TStringList;
  i, Count, startline, endline: integer;
  Data:     string;
begin
  //장원의 전체 리스트를 보내 줌.
  salelist := nil;
  Data     := '';
  Count    := 0;

  // 장원 판매 목록을 얻어온다.
  GuildAgitMan.GetGuildAgitSaleList(salelist);

  // 장원 목록이 없을 때
  if salelist = nil then begin
    BoxMsg('There is no registered guild territory.', 0);
    exit;
  end;

  // 페이지가 정상이면
  if page > 0 then begin
    // 시작줄
    startline := ONEPAGELINE * (page - 1);

    // 마지막줄 : 목록의 라인 수가 한 페이지의 최대 라인보다 크지 않게
    endline := _MIN(salelist.Count, ONEPAGELINE * page);

    // 시작줄부터 마지막줄까지 보냄
    for i := startline to endline - 1 do begin
      Data := Data + salelist[i] + '/';
      Inc(Count);
    end;

    if Count > 0 then begin
      // 리스트를 보냄
      SendMsg(self, RM_GUILDAGITLIST, 0, page, Count, 0, Data);
    end;
  end;

  // 목록을 메모리에서 해제시킨다.
  salelist.Free;
end;

procedure TUserHuman.CmdTryGuildAgitTrade;
begin
  if ServerIndex <> 0 then begin
    SysMsg('This command is not available on this server.', 0);
    exit;
  end;

  SendMsg(self, RM_GUILDAGITDEALTRY, 0, integer(self), 0, 0, '');
end;

procedure TUserHuman.CmdGuildAgitExpulsionMyself;
var
  guildagit: TGuildAgit;
begin
  //장원 내에 있는 사람만 추방.
  if (PEnvir.GetGuildAgitRealMapName = GuildAgitMan.GuildAgitMapName[0]) or
    (PEnvir.GetGuildAgitRealMapName = GuildAgitMan.GuildAgitMapName[1]) or
    (PEnvir.GetGuildAgitRealMapName = GuildAgitMan.GuildAgitMapName[2]) or
    (PEnvir.GetGuildAgitRealMapName = GuildAgitMan.GuildAgitMapName[3]) then begin
    // 문파가 없을 경우
    if (MyGuild = nil) or (TGuild(MyGuild).GuildName = '') then begin
      // 자기 자신을 강제 추방
      SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
      //         UserSpaceMove (GuildAgitMan.ReturnMapName, IntToStr(GuildAgitMan.ReturnX), IntToStr(GuildAgitMan.ReturnY));
      UserSpaceMove(HomeMap, IntToStr(HomeX), IntToStr(HomeY));
      exit;
    end;

    guildagit := GuildAgitMan.GetGuildAgit(TGuild(MyGuild).GuildName);
    // 장원이 없을 경우
    if guildagit = nil then begin
      if CompareLStr(PEnvir.MapName, GuildAgitMan.GuildAgitMapName[0], 3) or
        CompareLStr(PEnvir.MapName, GuildAgitMan.GuildAgitMapName[1], 3) or
        CompareLStr(PEnvir.MapName, GuildAgitMan.GuildAgitMapName[2], 3) or
        CompareLStr(PEnvir.MapName, GuildAgitMan.GuildAgitMapName[3], 3) then begin
        // 자기 자신을 강제 추방
        SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
        //               UserSpaceMove (GuildAgitMan.ReturnMapName, IntToStr(GuildAgitMan.ReturnX), IntToStr(GuildAgitMan.ReturnY));
        UserSpaceMove(HomeMap, IntToStr(HomeX), IntToStr(HomeY));
      end;
    end else begin
      // 장원이 있을 경우(sonmg 2005/02/23)
      // 남의 장원이거나 대여 기간이 만료되었으면 추방
      if (guildagit.GuildAgitNumber <> PEnvir.GuildAgit) or (guildagit.IsExpired) then
      begin
        // 자기 자신을 강제 추방
        SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
        //            UserSpaceMove (GuildAgitMan.ReturnMapName, IntToStr(GuildAgitMan.ReturnX), IntToStr(GuildAgitMan.ReturnY));
        UserSpaceMove(HomeMap, IntToStr(HomeX), IntToStr(HomeY));
      end;
    end;
  end;
end;

procedure TUserHuman.CmdGuildAgitDonate(goldstr: string);
var
  GoldDonate: integer;
  gname:      string;
  guildagit:  TGuildAgit;
begin
  gname := GetGuildNameHereAgit;
  if gname = '' then begin
    BoxMsg('Cannot pay.', 0);
    exit;
  end;

  guildagit := GuildAgitMan.GetGuildAgit(gname);
  if guildagit <> nil then begin
    GoldDonate := Str_ToInt(goldstr, 0);

    if Gold < GoldDonate then begin
      BoxMsg('Lack of Gold.', 0);
      exit;
    end;
    if guildagit.GuildAgitTotalGold + GoldDonate > GUILDAGITMAXGOLD then begin
      BoxMsg('Donation limit exceeded.\\The total sum of donation cannot exceed ' +
        GetGoldStr(GUILDAGITMAXGOLD) + ' Gold.', 0);
      exit;
    end;

    // 가방창에서 금전을 감소시킴.
    if DecGold(GoldDonate) then begin
      GoldChanged;

      // 장원 기부금에 돈을 추가함.
      guildagit.GuildAgitTotalGold := guildagit.GuildAgitTotalGold + GoldDonate;
      BoxMsg(GetGoldStr(GoldDonate) + 'Gold donated.\\Your balance is ' +
        GetGoldStr(guildagit.GuildAgitTotalGold) + ' Gold.', 0);

      //로그남김
      AddUserLog('46'#9 + //기부_
        MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) + ''#9 +
        UserName + ''#9 + NAME_OF_GOLD{'금전'} + ''#9 + IntToStr(GoldDonate) +
        ''#9 + '0'#9 + '0');

      // 문파 장원 리스트 저장.
      GuildAgitMan.SaveGuildAgitList(False);
    end else begin
      BoxMsg('Cannot pay.', 0);
    end;
  end else begin
    BoxMsg('Cannot pay.', 0);
  end;
end;

procedure TUserHuman.CmdGuildAgitViewDonation;
var
  gname:     string;
  guildagit: TGuildAgit;
begin
  gname := GetGuildNameHereAgit;
  if gname = '' then begin
    BoxMsg('Cannot look up.', 0);
    exit;
  end;

  guildagit := GuildAgitMan.GetGuildAgit(gname);
  if guildagit <> nil then begin
    BoxMsg('The amount of remaining donation is ' + GetGoldStr(
      guildagit.GuildAgitTotalGold) + ' Gold.', 0);
  end;
end;

function TUserHuman.GetGuildAgitDonation: integer;
var
  gname:     string;
  guildagit: TGuildAgit;
begin
  Result := 0;
  gname  := GetGuildNameHereAgit;
  if gname = '' then begin
    exit;
  end;

  guildagit := GuildAgitMan.GetGuildAgit(gname);
  if guildagit <> nil then begin
    Result := guildagit.GuildAgitTotalGold;
  end;
end;

function TUserHuman.DecGuildAgitDonation(igold: integer): boolean;
var
  gname:     string;
  guildagit: TGuildAgit;
begin
  Result := False;

  gname := GetGuildNameHereAgit;
  if gname = '' then begin
    exit;
  end;

  guildagit := GuildAgitMan.GetGuildAgit(gname);
  if guildagit <> nil then begin
    if guildagit.GuildAgitTotalGold < igold then
      exit;

    guildagit.GuildAgitTotalGold := guildagit.GuildAgitTotalGold - igold;
    Result := True;
  end;
end;

procedure TUserHuman.CmdGetGuildAgitFileVersion;
begin
  SysMsg('Version=' + IntToStr(GuildAgitMan.GuildAgitFileVersion), 0);
end;


 {----------------------------------------------------------}
 // Send????

procedure TUserHuman.SendAddItem(ui: TUserItem);
var
  citem: TClientItem;
  ps:    PTStdItem;
  std:   TStdItem;
  opt:   integer;
begin
  ps := UserEngine.GetStdItem(ui.Index);
  if ps <> nil then begin
    std := ps^;
    opt := ItemMan.GetUpgradeStdItem(ui, std);
    Move(std, citem.S, sizeof(TStdItem));
    citem.MakeIndex := ui.MakeIndex;
    citem.Dura      := ui.Dura;
    citem.DuraMax   := ui.DuraMax;
    citem.UpgradeOpt := opt;

    if std.StdMode = 50 then begin  //상품권
      citem.S.Name := citem.S.Name + ' #' + IntToStr(ui.Dura);
    end;
    //미지의속성 프리된 것들
    // 2003/03/15 아이템 인벤토리 확장
    if std.StdMode in [15, 19, 20, 21, 22, 23, 24, 26, 52, 53, 54] then begin
      if ui.Desc[8] = 0 then //속성이 프리됨
        citem.S.Shape := 0
      else
        citem.S.Shape := RING_OF_UNKNOWN;
    end;

    Def := MakeDefaultMsg(SM_ADDITEM, integer(self), 0, 0, 1{수량});
    SendSocket(@Def, EncodeBuffer(@citem, sizeof(TClientItem)));
  end;
end;

procedure TUserHuman.SendUpdateItem(ui: TUserItem);
var
  citem: TClientItem;
  ps:    PTStdItem;
  std:   TStdItem;
  opt:   integer;
begin
  ps := UserEngine.GetStdItem(ui.Index);
  if ps <> nil then begin
    std := ps^;
    opt := ItemMan.GetUpgradeStdItem(ui, std);
    Move(std, citem.S, sizeof(TStdItem));
    citem.MakeIndex := ui.MakeIndex;
    citem.Dura      := ui.Dura;
    citem.DuraMax   := ui.DuraMax;
    citem.UpgradeOpt := opt;
    if std.StdMode = 50 then begin  //상품권
      citem.S.Name := citem.S.Name + ' #' + IntToStr(ui.Dura);
    end;

    //용아이템
    ChangeItemByJob(citem, Abil.Level);

    Def := MakeDefaultMsg(SM_UPDATEITEM, integer(self), 0, 0, 1{수량});
    SendSocket(@Def, EncodeBuffer(@citem, sizeof(TClientItem)));
  end;
end;


procedure TUserHuman.SendUpdateItemWithLevel(ui: TUserItem; lv: integer);
var
  citem: TClientItem;
  ps:    PTStdItem;
  std:   TStdItem;
  opt:   integer;
begin
  ps := UserEngine.GetStdItem(ui.Index);
  if ps <> nil then begin
    std := ps^;
    opt := ItemMan.GetUpgradeStdItem(ui, std);
    Move(std, citem.S, sizeof(TStdItem));
    citem.MakeIndex := ui.MakeIndex;
    citem.Dura      := ui.Dura;
    citem.DuraMax   := ui.DuraMax;
    citem.UpgradeOpt := opt;
    //천의무봉 체크
    ChangeItemWithLevel(citem, lv);

    Def := MakeDefaultMsg(SM_UPDATEITEM, integer(self), 0, 0, 1{수량});
    SendSocket(@Def, EncodeBuffer(@citem, sizeof(TClientItem)));

  end;

end;

//용아이템 착용할때 직업별로 날려주는 아이템 정보(sonmg)
procedure TUserHuman.SendUpdateItemByJob(ui: TUserItem; lv: integer);
var
  citem: TClientItem;
  ps:    PTStdItem;
  std:   TStdItem;
  opt:   integer;
begin
  ps := UserEngine.GetStdItem(ui.Index);
  if ps <> nil then begin
    std := ps^;
    opt := ItemMan.GetUpgradeStdItem(ui, std);
    Move(std, citem.S, sizeof(TStdItem));
    citem.MakeIndex := ui.MakeIndex;
    citem.Dura      := ui.Dura;
    citem.DuraMax   := ui.DuraMax;
    citem.UpgradeOpt := opt;

    //용아이템
    ChangeItemByJob(citem, lv);

    Def := MakeDefaultMsg(SM_UPDATEITEM, integer(self), 0, 0, 1{수량});
    SendSocket(@Def, EncodeBuffer(@citem, sizeof(TClientItem)));

  end;

end;

procedure TUserHuman.SendDelItem(ui: TUserItem);
var
  citem: TClientItem;
  ps:    PTStdItem;
  std:   TStdItem;
  opt:   integer;
begin
  ps := UserEngine.GetStdItem(ui.Index);
  if ps <> nil then begin
    std := ps^;
    opt := ItemMan.GetUpgradeStdItem(ui, std);
    Move(std, citem.S, sizeof(TStdItem));
    citem.Dura      := ui.Dura;
    citem.DuraMax   := ui.DuraMax;
    citem.MakeIndex := ui.MakeIndex;
    citem.UpgradeOpt := opt;
    if std.StdMode = 50 then begin  //상품권
      citem.S.Name := citem.S.Name + ' #' + IntToStr(ui.Dura);
    end;
    Def := MakeDefaultMsg(SM_DELITEM, integer(self), 0, 0, 1{수량});
    SendSocket(@Def, EncodeBuffer(@citem, sizeof(TClientItem)));
  end;
end;

// 아이템 업그레이드 파괴 효과를 위한 DelItem함수
procedure TUserHuman.SendDelItemWithFlag(ui: TUserItem; wBreakdown: word);
var
  citem: TClientItem;
  ps:    PTStdItem;
  std:   TStdItem;
  opt:   integer;
begin
  ps := UserEngine.GetStdItem(ui.Index);
  if ps <> nil then begin
    std := ps^;
    opt := ItemMan.GetUpgradeStdItem(ui, std);
    Move(std, citem.S, sizeof(TStdItem));
    citem.Dura      := ui.Dura;
    citem.DuraMax   := ui.DuraMax;
    citem.MakeIndex := ui.MakeIndex;
    citem.UpgradeOpt := opt;
    if std.StdMode = 50 then begin  //상품권
      citem.S.Name := citem.S.Name + ' #' + IntToStr(ui.Dura);
    end;
    Def := MakeDefaultMsg(SM_DELITEM, integer(self), 0, wBreakdown, 1{수량});
    SendSocket(@Def, EncodeBuffer(@citem, sizeof(TClientItem)));
  end;
end;

procedure TUserHuman.SendDelItems(ilist: TStringList);
var
  i:    integer;
  Data: string;
begin
  Data := '';
  for i := 0 to ilist.Count - 1 do begin
    Data := Data + ilist[i] + '/' + IntToStr(integer(ilist.objects[i])) + '/';
  end;
  Def := MakeDefaultMsg(SM_DELITEMS, 0, 0, 0, ilist.Count);
  SendSocket(@Def, EncodeString(Data));
end;

procedure TUserHuman.SendBagItems;
var
  i:     integer;
  pu:    PTUserItem;
  citem: TClientItem;
  ps:    PTStdItem;
  std:   TStdItem;
  Data:  string;
  opt:   integer;
begin
  Data := '';
  for i := 0 to ItemList.Count - 1 do begin
    pu := PTUserItem(ItemList[i]);
    ps := UserEngine.GetStdItem(pu.Index);
    if ps <> nil then begin
      std := ps^;
      opt := ItemMan.GetUpgradeStdItem(pu^, std);
      Move(std, citem.S, sizeof(TStdItem));
      citem.Dura      := pu.Dura;
      citem.DuraMax   := pu.DuraMax;
      citem.MakeIndex := pu.MakeIndex;
      citem.UpgradeOpt := opt;
      if std.StdMode = 50 then begin  //상품권
        citem.S.Name := citem.S.Name + ' #' + IntToStr(pu.Dura);
      end;
      Data := Data + EncodeBuffer(@citem, sizeof(TClientItem)) + '/';
    end;
  end;
  if Data <> '' then begin
    Def := MakeDefaultMsg(SM_BAGITEMS, integer(self), 0, 0, ItemList.Count{수량});
    SendSocket(@Def, Data);
  end;
end;

procedure TUserHuman.SendUseItems;
var
  i:     integer;
  citem: TClientItem;
  ps:    PTStdItem;
  std:   TStdItem;
  Data:  string;
  opt:   integer;
begin
  Data := '';
  // 2003/03/15 아이템 인벤토리 확장
  for i := 0 to 12 do begin    // 8->12
    if UseItems[i].Index > 0 then begin
      ps := UserEngine.GetStdItem(UseItems[i].Index);
      if ps <> nil then begin
        std := ps^;
        opt := ItemMan.GetUpgradeStdItem(UseItems[i], std);
        Move(std, citem.S, sizeof(TStdItem));
        citem.Dura      := UseItems[i].Dura;
        citem.DuraMax   := UseItems[i].DuraMax;
        citem.MakeIndex := UseItems[i].MakeIndex;
        citem.UpgradeOpt := opt;

        //천의무봉일 경우에는 능력치가 바뀐다.
        if (i = U_DRESS) then
          ChangeItemWithLevel(citem, Abil.Level);

        //용아이템일 경우 능력치가 바뀐다.
        ChangeItemByJob(citem, Abil.Level);

        Data := Data + IntToStr(i) + '/' + EncodeBuffer(@citem,
          sizeof(TClientItem)) + '/';
      end;
    end;
  end;
  if Data <> '' then begin
    Def := MakeDefaultMsg(SM_SENDUSEITEMS, 0, 0, 0, 0);
    SendSocket(@Def, Data);
  end;
end;

 {----------------------------------------------------------}
 //Magic

procedure TUserHuman.SendAddMagic(pum: PTUserMagic);
var
  cmag: TClientMagic;
begin
  cmag.Key := pum.Key;
  cmag.Level := pum.Level;
  cmag.CurTrain := pum.CurTrain;
  cmag.Def := pum.pDef^;
  Def := MakeDefaultMsg(SM_ADDMAGIC, 0, 0, 0, 1);
  SendSocket(@Def, EncodeBuffer(@cmag, sizeof(TClientMagic)));
end;

procedure TUserHuman.SendDelMagic(pum: PTUserMagic);
begin
  Def := MakeDefaultMsg(SM_DELMAGIC, pum.MagicId, 0, 0, 1);
  SendSocket(@Def, '');
end;

procedure TUserHuman.SendMyMagics;
var
  i, mdelay: integer;
  Data: string;
  pum:  PTUserMagic;
  cmag: TClientMagic;
begin
  Data   := '';
  mdelay := 0;
  for i := 0 to MagicList.Count - 1 do begin
    pum      := PTUserMagic(MagicList[i]);
    cmag.Key := pum.Key;
    cmag.Level := pum.Level;
    cmag.CurTrain := pum.CurTrain;
    cmag.Def := pum.pDef^;
    mdelay   := mdelay + pum.pDef.DelayTime;

    Data := Data + EncodeBuffer(@cmag, sizeof(TClientMagic)) + '/';
  end;
  Def := MakeDefaultMsg(SM_SENDMYMAGIC, (mdelay xor $773F1A34) xor
    $4BBC2255, 0, 0, MagicList.Count);
  SendSocket(@Def, Data);
end;


{----------------------------------------------------------}

procedure TUserHuman.LoverWhisper(whostr, saystr: string);
var
  hum:   TUserHuman;
  svidx: integer;
begin
  hum := TUserHuman(UserEngine.GetUserHuman(whostr));
  if hum <> nil then begin
    // 스텔스 모드일경우에는 없는것처럼 속이자
    if hum.bStealth then begin
      SysMsg('Cannot Find ' + whostr, 0);
      Exit;
    end;

    if not hum.ReadyRun then begin
      SysMsg(whostr + ' cannot receive the message.', 0);
      exit;
    end;
    if not hum.BoHearWhisper or hum.IsBlockWhisper(UserName) then begin
      SysMsg(whostr + ' is rejecting whispering', 0);
      exit;
    end;

    //      hum.SendMsg (self, RM_LM_WHISPER, 0, 0, 0, 0, '♡' + UserName + '=> ' + saystr);
    hum.SendMsg(self, RM_LM_WHISPER, 0, 0, 0, 0, ':)' + UserName + '=> ' + saystr);
  end else begin
    if UserEngine.FindOtherServerUser(whostr, svidx) then begin
      //         UserEngine.SendInterMsg (ISM_LM_WHISPER, svidx, whostr + '/' + '♡' + UserName + '=> ' + saystr);
      UserEngine.SendInterMsg(ISM_LM_WHISPER, svidx, whostr +
        '/' + ':)' + UserName + '=> ' + saystr);
    end else
      SysMsg('Cannot Find ' + whostr, 0);
  end;
end;

procedure TUserHuman.Whisper(whostr, saystr: string);
var
  hum:   TUserHuman;
  svidx: integer;
begin
  hum := TUserHuman(UserEngine.GetUserHuman(whostr));
  if hum <> nil then begin
    // 스텔스 모드일경우에는 없는것처럼 속이자
    if hum.bStealth then begin
      SysMsg(whostr + '  is not found.', 0);
      Exit;
    end;

    if not hum.ReadyRun then begin
      SysMsg(whostr + ' cannot receive the message.', 0);
      exit;
    end;
    if not hum.BoHearWhisper or hum.IsBlockWhisper(UserName) then begin
      SysMsg(whostr + ' is rejecting whispering', 0);
      exit;
    end;

    //운영자 또는 감시자 모드이면 별도 처리...
    if BoSuperviserMode or BoSysopMode then
      hum.SendMsg(self, RM_GMWHISPER, 0, 0, 0, 0, UserName + '=> ' + saystr)
    else
      hum.SendMsg(self, RM_WHISPER, 0, 0, 0, 0, UserName + '=> ' + saystr);
  end else begin
    if UserEngine.FindOtherServerUser(whostr, svidx) then begin
      //운영자 또는 감시자 모드이면 별도 처리...
      if BoSuperviserMode or BoSysopMode then
        UserEngine.SendInterMsg(ISM_GMWHISPER, svidx, whostr +
          '/' + UserName + '=> ' + saystr)
      else
        UserEngine.SendInterMsg(ISM_WHISPER, svidx, whostr + '/' +
          UserName + '=> ' + saystr);
    end else
      SysMsg(whostr + '  is not found.', 0);
  end;
end;

procedure TUserHuman.WhisperRe(saystr: string; IsGM: boolean);
var
  sendwho: string;
begin
  GetValidStr3(saystr, sendwho, [' ', '=', '>']);
  if BoHearWhisper and (not IsBlockWhisper(sendwho)) then begin
    if IsGM then
      SendMsg(self, RM_GMWHISPER, 0, 0, 0, 0, saystr)
    else
      SendMsg(self, RM_WHISPER, 0, 0, 0, 0, saystr);
  end;
end;

procedure TUserHuman.LoverWhisperRe(saystr: string);
var
  sendwho: string;
begin
  GetValidStr3(saystr, sendwho, [' ', '=', '>']);
  if BoHearWhisper and (not IsBlockWhisper(sendwho)) then begin
    SendMsg(self, RM_LM_WHISPER, 0, 0, 0, 0, saystr);
  end;
end;

procedure TUserHuman.BlockWhisper(whostr: string);
var
  i: integer;
begin
  for i := 0 to WhisperBlockList.Count - 1 do
    if CompareText(whostr, WhisperBlockList[i]) = 0 then begin
      WhisperBlockList.Delete(i);
      SysMsg('[release from ban whisper: ' + whostr + ']', 1);
      exit;
    end;
  WhisperBlockList.Add(whostr);
  SysMsg('[ban whisper: ' + whostr + ']', 0);
end;

function TUserHuman.IsBlockWhisper(whostr: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to WhisperBlockList.Count - 1 do
    if CompareText(whostr, WhisperBlockList[i]) = 0 then begin
      Result := True;
      break;
    end;
end;

procedure TUserHuman.GuildSecession;
begin
  if (MyGuild <> nil) and (GuildRank > 1) then begin  //문주는 안됨
    if TGuild(MyGuild).IsMember(UserName) then
      if TGuild(MyGuild).DelMember(UserName) then begin
        ////////////////////////////////////
        //문파전 중에는 문파탈퇴할 수 없음.(sonmg)
        if LastHiter <> nil then begin
          if LastHiter.MyGuild <> nil then begin
            //둘다 문파에 가입된 상태에서
            if GetGuildRelation(self, LastHiter) = 2 then begin //문전(문파전)중임
              SysMsg('You cannot secede now.', 0);
              exit;
            end;
          end;
        end;
        ////////////////////////////////////

        UserEngine.SendInterMsg(ISM_RELOADGUILD, ServerIndex,
          TGuild(MyGuild).GuildName);
        MyGuild := nil;
        GuildRankChanged(0, '');
        SysMsg('Seceded.', 1);

        ChangeNameColor;  //이름색 업데이트(sonmg 2004/12/29)
      end;
  end else
    SysMsg('Cancelled.', 0);
end;

procedure TUserHuman.CmdSendTestQuestDiary(unitnum: integer);
var
  i, k: integer;
  str:  string;
  list: TList;
  pqdd: PTQDDinfo;
begin
  if unitnum = 0 then begin
    for i := 0 to QuestDiaryList.Count - 1 do begin
      list := TList(QuestDiaryList[i]);
      if list <> nil then begin
        if list.Count > 0 then begin
          if GetQuestOpenIndexMark(i + 1) = 1 then
            str := ' (Start)'
          else
            str := ' (Ready)';
          if GetQuestFinIndexMark(i + 1) = 1 then
            str := str + ' (Complete)'
          else
            str := str + ' (Progress)';
          SysMsg('[' + IntToStr(PTQDDinfo(list[0]).index) + '] ' +
            PTQDDinfo(list[0]).title + str, 1);
        end;
      end;
    end;
  end else begin
    unitnum := unitnum - 1;  //유닛을 나타낼 때는 1이 0임
    if unitnum < QuestDiaryList.Count then begin
      list := TList(QuestDiaryList[unitnum]);
      if list <> nil then begin
        for i := 0 to list.Count - 1 do begin
          pqdd := PTQDDinfo(list[i]);
          if GetQuestMark(pqdd.index) = 1 then
            str := ' (Finish)'
          else
            str := ' (Unfinish)';
          SysMsg('[' + IntToStr(pqdd.index) + '] ' + pqdd.title + str, 2);
          for k := 0 to pqdd.SList.Count - 1 do
            SysMsg(pqdd.SList[k], 1);
        end;
      end;
    end;
  end;
end;




procedure TUserHuman.Say(saystr: string);
var
  str, cmd, param1, param2, param3, param4, param5, param6, param7: string;
  hum:      TUserhuman;
  pstd:     PTStdItem;
  i, idx, n: integer;
  boshutup: boolean;
begin
  if saystr = '' then
    exit;

  if BoReadyAdminPassword then begin
    BoReadyAdminPassword := False;
    if Str_ToInt(saystr, 0) = GET_A_PASSWD then begin
      UserDegree := UD_ADMIN;
      SysMsg('success', 0);
      MainOutMessage('[AdminLog1] '); //adminlog
    end;
    exit;
  end;

  if BoReadySuperAdminPassword then begin
    BoReadySuperAdminPassword := False;
    if KOREANVERSION then begin
      if BoTestServer then begin
        if saystr = 'wemade09' then begin  //테섭
          UserDegree := UD_ADMIN;
          MainOutMessage('[AdminLog2] '); //adminlog
        end else
          SysMsg('Fail', 0);
      end else begin
        if saystr = 'Le&end0f#ir' then begin
          UserDegree := UD_ADMIN;
          MainOutMessage('[AdminLog2] '); //adminlog
        end else
          SysMsg('Fail', 0);
      end;
    end;
    if CHINAVERSION then begin
      if saystr = 'Le&end0f#ir' then begin   //중국
        UserDegree := UD_ADMIN;
        MainOutMessage('[AdminLog2] '); //adminlog
      end else
        SysMsg('Fail', 0);
    end;
    if TAIWANVERSION then begin
      if saystr = 'TGL&S0ftW0rld' then begin   //대만
        UserDegree := UD_ADMIN;
        MainOutMessage('[AdminLog2] '); //adminlog
      end else
        SysMsg('Fail', 0);
    end;
    if ENGLISHVERSION then begin
      if saystr = 'Le&end0f#ir' then begin   //이탈리아
        UserDegree := UD_ADMIN;
        MainOutMessage('[AdminLog2] '); //adminlog
      end else
        SysMsg('Fail', 0);
    end;
    if PHILIPPINEVERSION then begin
      if saystr = 'PL2g&OfMir2' then begin   //필리핀
        UserDegree := UD_ADMIN;
        MainOutMessage('[AdminLog2] '); //adminlog
      end else
        SysMsg('Fail', 0);
    end;

    exit;
  end;

  //채팅로그
  for i := 0 to UserEngine.ChatLogList.Count - 1 do begin
    if (UserName = UserEngine.ChatLogList.Strings[i]) then begin
      //로그남김
      AddChatLog('28'#9 + //대화_ 채팅_
        MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) + ''#9 +
        UserName + ''#9 + saystr + ''#9 + DateTimeToStr(now) + ''#9 + '1'#9 + '0');
      break;
    end;
  end;

  if saystr[1] = '@' then begin
    str := Copy(saystr, 2, Length(saystr) - 1);
    str := GetValidStr3(str, cmd, [' ', ',', ':']);
    str := GetValidStr3(str, param1, [' ', ',', ':']);
    if str <> '' then
      str := GetValidStr3(str, param2, [' ', ',', ':']);
    if str <> '' then
      str := GetValidStr3(str, param3, [' ', ',', ':']);
    if str <> '' then
      str := GetValidStr3(str, param4, [' ', ',', ':']);
    if str <> '' then
      str := GetValidStr3(str, param5, [' ', ',', ':']);
    if str <> '' then
      str := GetValidStr3(str, param6, [' ', ',', ':']);
    if str <> '' then
      str := GetValidStr3(str, param7, [' ', ',', ':']);

      {
      if BoTestServer and KoreanVersion then begin
         if CompareText (cmd, 'admins') = 0 then begin
            for i:=0 to UserEngine.AdminList.Count-1 do
               SysMsg (UserEngine.AdminList[i], 1);
            exit;
         end;
      end;  }

    if (CompareText(cmd, 'RejectWhisper') = 0) or
      (CompareText(cmd, 'RejectWhisper') = 0) then begin
      BoHearWhisper := not BoHearWhisper;
      if BoHearWhisper then
        SysMsg('[Allow whisper ]', 1)
      else
        SysMsg('[Reject whisper]', 1);
      exit;
    end;
    if (CompareText(cmd, 'AllowWhisper') = 0) or
      (CompareText(cmd, 'AllowWhisper') = 0) then begin
      BoHearWhisper := True;
      SysMsg('[Allow whisper ]', 1);
      exit;
    end;
    if (CompareText(cmd, 'Interception') = 0) then begin //귀엣말차단
      if param1 <> '' then
        BlockWhisper(param1);
      if param2 <> '' then
        BlockWhisper(param2);
      if param3 <> '' then
        BlockWhisper(param3);
      exit;
    end;
    if (CompareText(cmd, 'RejectShouting') = 0) or
      (CompareText(cmd, 'InterceptShouting') = 0) then begin
      BoHearCry := not BoHearCry;
      if BoHearCry then
        SysMsg('[Accept shouts]', 1)
      else
        SysMsg('[Reject shouts]', 1);
      exit;
    end;
    if CompareText(cmd, 'RejectTrade') = 0 then begin
      BoExchangeAvailable := not BoExchangeAvailable;
      if BoExchangeAvailable then
        SysMsg('[enable trading]', 1)
      else
        SysMsg('[reject trading]', 1);
      exit;
    end;
    if CompareText(cmd, 'AllowGuild') = 0 then begin
      AllowEnterGuild := not AllowEnterGuild;
      if AllowEnterGuild then
        SysMsg('[Allow guild membership]', 1)
      else
        SysMsg('[reject guild membership]', 1);
      exit;
    end;
    if CompareText(cmd, 'AllowAlliance') = 0 then begin
      if IsGuildMaster then begin
        TGuild(MyGuild).AllowAllyGuild := not TGuild(MyGuild).AllowAllyGuild;
        if TGuild(MyGuild).AllowAllyGuild then
          SysMsg('[Allow Alliance]', 1)
        else
          SysMsg('[Reject Alliance]', 1);
      end;
      exit;
    end;
    if CompareText(cmd, 'Alliance') = 0 then begin
      if IsGuildMaster then begin
        ServerGetGuildMakeAlly;
      end;
      exit;
    end;
    if (CompareText(cmd, 'CancelAlliance') = 0) or
      (CompareText(cmd, 'CancleAlliance') = 0) then begin
      if IsGuildMaster then begin
        ServerGetGuildBreakAlly(param1);
      end;
      exit;
    end;
    if CompareText(cmd, 'LeaveGuild') = 0 then begin
      GuildSecession;
      exit;
    end;
    if (CompareText(cmd, 'InterceptGuildChat') = 0) or
      (CompareText(cmd, 'RejectGuildChat') = 0) then begin
      BoHearGuildMsg := not BoHearGuildMsg;
      if BoHearGuildMsg then
        SysMsg('Allow Guild Chat', 1)
      else
        SysMsg('Intercept Guild Chat', 1);
      exit;
    end;
    if (UpperCase(cmd) = 'H') or (UpperCase(cmd) = 'HELP') then begin
      for i := 0 to LineHelpList.Count - 1 do
        SysMsg(LineHelpList[i], 1);
      exit;
    end;


    //50레벨 효과 표시/숨김(sonmg 2004/03/12)
    if (CompareText(cmd, 'Energy') = 0) then begin
      if (Abil.Level >= EFFECTIVE_HIGHLEVEL) then begin
        BoHighLevelEffect := not BoHighLevelEffect;
        if BoHighLevelEffect then begin
          RecalcAbilitys;
          SysMsg('Show Energy.', 1);
        end else begin
          RecalcAbilitys;
          SysMsg('Hide Energy.', 1);
        end;
      end;
      exit;
    end;

    //퀘스트 일지 테스트
    if CompareText(cmd, 'diary') = 0 then begin
      CmdSendTestQuestDiary(Str_ToInt(param1, 0));
      exit;
    end;

    if CompareText(cmd, 'AttackMode') = 0 then begin  //공격방식을 바꾼다.
      if HumAttackMode < HAM_MAXCOUNT - 1 then
        Inc(HumAttackMode)
      else
        HumAttackMode := 0;
      case HumAttackMode of
        HAM_ALL: SysMsg('[enable attack all]', 1);
        HAM_PEACE: SysMsg('[Peaceful attack mode]', 1);
        HAM_GROUP: SysMsg('[Group unit attack mode]', 1);
        HAM_GUILD: SysMsg('[Guild unit attack mode]', 1);
        HAM_PKATTACK: SysMsg('[Red & White fight mode]', 1);
      end;
      exit;
    end;
    if CompareText(cmd, 'Rest') = 0 then begin  //공격 or 휴식
      if SlaveList.Count > 0 then begin
        BoSlaveRelax := not BoSlaveRelax;
        if BoSlaveRelax then
          SysMsg('action of subordinate : rest', 1)
        else
          SysMsg('action of subordinate : attack', 1);
      end;
      exit;
    end;

    if Str_ToInt(cmd, 0) = GET_A_CMD then begin
      SendMsg(self, RM_NEXTTIME_PASSWORD, 0, 0, 0, 0, '');
      SysMsg('Please enter the password', 1);
      BoReadyAdminPassword := True;
      exit;
    end;
    if UserDegree >= UD_SYSOP then begin
      if CompareText(cmd, 'gsa') = 0 then begin
        SendMsg(self, RM_NEXTTIME_PASSWORD, 0, 0, 0, 0, '');
        SysMsg('Enter The Password.', 1);
        BoReadySuperAdminPassword := True;
        exit;
      end;
      if Str_ToInt(cmd, 0) = GET_SA_CMD then begin
        SendMsg(self, RM_NEXTTIME_PASSWORD, 0, 0, 0, 0, '');
        SysMsg('Enter the Password.', 1);
        BoReadySuperAdminPassword := True;
        exit;
      end;
    end;

    if (MyGuild = UserCastle.OwnerGuild) and (MyGuild <> nil) then begin
      if CompareText(cmd, 'Sabukwallgate') = 0 then begin
        CmdOpenCloseUserCastleMainDoor(param1);  //닫힘,열림
        exit;
      end;

    end;


    //순간이동 반지를 끼고 있으면... 살아있으면
    if BoAbilSpaceMove and (WAbil.HP > 0) then begin
      if not BoTaiwanEventUser then begin
        if not PEnvir.NoPositionMove then begin
          if CompareText(cmd, 'Move') = 0 then begin
            if GetTickCount - LatestSpaceMoveTime > 10 * 1000 then begin
              LatestSpaceMoveTime := GetTickCount;
              SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
              UserSpaceMove('', param1, param2);
            end else
              SysMsg(IntToStr(10 - (GetTickCount - LatestSpaceMoveTime) div
                1000) + '  second left for next command.', 0);
            exit;
          end;
        end else begin
          //순간이동반지 사용 불가능 지역
          SysMsg('You cannot use it here.', 0);
          exit;
        end;
      end else
        SysMsg('You cannot use it.', 0);
    end;
    //탐색의목걸이를 끼고 있으면
    if BoAbilSearch or (UserDegree >= UD_SYSOP) then begin
      if CompareText(cmd, 'Searching') = 0 then begin
        if (GetTickCount - LatestSearchWhoTime > 10 * 1000) or
          (UserDegree >= UD_SYSOP) then begin
          LatestSearchWhoTime := GetTickCount;
          hum := UserEngine.GetUserHuman(param1);
          if hum <> nil then begin
            if hum.PEnvir = PEnvir then begin
              SysMsg(param1 + ' is ' + IntToStr(hum.CX) + ' ' +
                IntToStr(hum.CY) + '. this is  his(her) position on this map.', 1);
            end else
              SysMsg(param1 + ' is at another place.', 1);
          end else
            SysMsg(param1 + '  cannot be searched.', 1);
        end else
          SysMsg(IntToStr(10 - (GetTickCount - LatestSearchWhoTime) div 1000) +
            '  second left for next command.', 0);
        exit;
      end;
    end;
    //천지합일
    if (CompareText(cmd, 'DisableGroupRecall') = 0) or
      (CompareText(cmd, 'EnableGroupRecall') = 0) then begin
      BoEnableRecall := not BoEnableRecall;
      if BoEnableRecall then
        SysMsg('[Enable GroupRecall]', 1)
      else
        SysMsg('[Disable GroupRecall]', 1);
    end;
    //문파장원 소환
    if (CompareText(cmd, 'DisableGuildRecall') = 0) or
      (CompareText(cmd, 'EnableGuildRecall') = 0) then begin
      BoEnableAgitRecall := not BoEnableAgitRecall;
      if BoEnableAgitRecall then
        SysMsg('[Enable GuildRecall]', 1)
      else
        SysMsg('[Disable GuildRecall]', 1);
    end;
    if BoCGHIEnable or (UserDegree >= UD_SYSOP) then begin
      if CompareText(cmd, 'GroupRecall') = 0 then begin
        if not PEnvir.NoRecall then begin
          n := (GetTickCount - CGHIstart) div 1000;
          CGHIstart := CGHIstart + longword(n * 1000);
          if CGHIUseTime > n then
            CGHIUseTime := CGHIUseTime - n
          else
            CGHIUseTime := 0;
          if CGHIUseTime = 0 then begin
            if GroupOwner = self then begin //자신이 그룹짱
              for i := 1 to GroupMembers.Count - 1 do begin  //자신 빼고
                if TUserHuman(GroupOwner.GroupMembers.Objects[i]).BoEnableRecall then
                  CmdRecallMan(GroupMembers[i], '')
                else
                  SysMsg(GroupMembers[i] +
                    ' is now rejecting GroupRecall.', 0);
              end;
              CGHIstart   := GetTickCount;
              CGHIUseTime := 3 * 60;
            end;
          end else begin
            SysMsg(' GroupRecall failed. after ' + IntToStr(CGHIUseTime) +
              ' seconds, You can use it again.', 0);
          end;
        end else begin
          SysMsg('You cannot use it here.', 0);
        end;
      end;
    end;

    if UserDegree >= UD_OBSERVER then begin
      if Length(saystr) > 2 then begin
        if (saystr[2] = '!') then begin  //"@!" 운영자 전음
          str := Copy(saystr, 3, length(saystr) - 2);
          UserEngine.SysMsgAll('(*)' + str);
          UserEngine.SendInterMsg(ISM_SYSOPMSG, ServerIndex, '(*)' + str);
          exit;
        end;
        if (saystr[2] = '$') then begin  //"@$" 운영자 전음, 현서버에서만 전달
          str := Copy(saystr, 3, length(saystr) - 2);
          UserEngine.SysMsgAll('(!)' + str);
          exit;
        end;
        if (saystr[2] = '#') then begin  //"@#" 운영자 전음, 현맵에만 전달
          str := Copy(saystr, 3, length(saystr) - 2);
          UserEngine.CryCry(RM_SYSMESSAGE, PEnvir, CX, CY, 10000, '(#)' + str);
          exit;
        end;
      end;
    end;

    if UserDegree >= UD_SYSOP then begin
      if CompareText(cmd, 'Move') = 0 then begin
        if GrobalEnvir.GetEnvir(param1) <> nil then begin
          SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
          RandomSpaceMove(param1, 0); //무작위 공간이동
        end;
        exit;
      end;
      if (CompareText(cmd, 'PositionMove') = 0) or (CompareText(cmd, 'PMove') = 0)
      then begin
        CmdFreeSpaceMove(param1, param2, param3);
        exit;
      end;

      if CompareText(cmd, 'Stealth') = 0 then begin
        CmdStealth;
        exit;
      end;

      if CompareText(cmd, 'CharMove') = 0 then begin
        CmdCharMove(param1, param2);
        exit;
      end;

      if CompareText(cmd, 'Goto') = 0 then begin
        CmdCharSpaceMove(param1);
        exit;
      end;

      if CompareText(cmd, 'DragonExp') = 0 then begin
        if param1 = '' then begin
          SysMsg('Dragon Exp= ' + IntToStr(gFireDragon.Exp), 0);
          SysMsg('Dragon Level= ' + IntToStr(gFireDragon.Level), 0);
          SysMsg('Dragon ExpDvider= ' + IntToStr(gFireDragon.ExpDivider), 0);

        end else begin
          gFireDragon.ExpDivider := str_ToInt(param1, 1);
          SysMsg('Set Dragon Exp Divider = ' + IntToStr(
            gFireDragon.ExpDivider), 0);
        end;
        exit;
      end;

      if CompareText(cmd, 'Info') = 0 then begin
        CmdSendUserLevelInfos(param1);
        exit;
      end;
      if (CompareText(cmd, 'MobLevel') = 0) or (CompareText(cmd, '몹레벨') = 0) then
      begin
        CmdSendMonsterLevelInfos;
        exit;
      end;
      if (CompareText(cmd, 'KingMob') = 0) or (CompareText(cmd, '왕몹') = 0) then begin
        CmdSendKingMonsterInfos(param1);
        exit;
      end;
      if (CompareText(cmd, 'MobCount') = 0) or (CompareText(cmd, '몹수') = 0) then
      begin
        SysMsg(param1 + 'no.of Mob=' + IntToStr(
          UserEngine.GetMapMons(GrobalEnvir.GetEnvir(param1), nil)), 1);
        exit;
      end;
      if CompareText(cmd, 'Human') = 0 then begin
        if param1 = '' then
          param1 := PEnvir.MapName;
        SysMsg(param1 + 'No.of human=' +
          IntToStr(UserEngine.GetHumCount(param1)), 1);
      end;
      if (CompareText(cmd, 'Map') = 0) or (CompareText(cmd, '맵') = 0) then begin
        SysMsg('Map: ' + MapName, 0);
        exit;
      end;
      if (CompareText(cmd, 'Kick') = 0) or (CompareText(cmd, 'Kick') = 0) then begin
        CmdKickUser(param1);
        exit;
      end;
      if (CompareText(cmd, 'Ting') = 0) or (CompareText(cmd, '팅') = 0) then begin
        CmdTingUser(param1);
        exit;
      end;
      if (CompareText(cmd, 'SuperTing') = 0) or (CompareText(cmd, '왕팅') = 0) then
      begin
        CmdTingRangeUser(param1, param2);
        exit;
      end;
      if (CompareText(cmd, 'Shutup') = 0) or (CompareText(cmd, '채금') = 0) then begin
        CmdAddShutUpList(param1, param2, True);
        exit;
      end;
      if (CompareText(cmd, 'ReleaseShutup') = 0) or
        (CompareText(cmd, '채금해제') = 0) then begin
        CmdDelShutUpList(param1, True);
        exit;
      end;
      if (CompareText(cmd, 'ShutupList') = 0) or (CompareText(cmd, '채금자') = 0) then
      begin
        CmdSendShutUpList;
        exit;
      end;
      // 2003/08/28 채팅로그
      if (CompareText(cmd, 'ReloadChatLog') = 0) or
        (CompareText(cmd, '채팅로그재적용') = 0) then begin
        FrmDB.LoadChatLogFiles;
        UserEngine.SendInterMsg(ISM_RELOADCHATLOG, ServerIndex, '');
        SysMsg(cmd + ' is reloaded to whole server.', 1);
        exit;
      end;
      // 2003/09/15 채팅로그 추가/삭제
      if (CompareText(cmd, 'AddChatLog') = 0) or
        (CompareText(cmd, '채팅로그추가') = 0) then begin
        CmdAddChatLogList(param1, True);
        exit;
      end;
      if (CompareText(cmd, 'ReleaseChatLog') = 0) or
        (CompareText(cmd, '채팅로그삭제') = 0) then begin
        CmdDelChatLogList(param1, True);
        exit;
      end;
      if (CompareText(cmd, 'ChatLogList') = 0) or
        (CompareText(cmd, '채팅로그자') = 0) then begin
        CmdSendChatLogList;
        exit;
      end;

      if (CompareText(cmd, 'GameMaster') = 0) or (CompareText(cmd, '운영자') = 0) then
      begin
        BoSysopMode := not BoSysopMode;
        if BoSysopMode then
          SysMsg('Game master mode', 1)
        else
          SysMsg('Release  game master mode ', 1);
        exit;
      end;
      if (CompareText(cmd, 'Observer') = 0) or (CompareText(cmd, 'Ob') = 0) or
        (CompareText(cmd, '감시자') = 0) then begin
        BoSuperviserMode := not BoSuperviserMode;
        if BoSuperviserMode then
          SysMsg('Observer mode', 1)
        else
          SysMsg('Release  observer mode', 1);
        exit;
      end;
      if (CompareText(cmd, 'Superman') = 0) or (CompareText(cmd, '무적') = 0) then
      begin
        NeverDie := not NeverDie;
        if NeverDie then
          SysMsg('Invincible Mode', 1)
        else
          SysMsg('Normal mode', 1);
        exit;
      end;
      if (CompareText(cmd, 'Level') = 0) or (CompareText(cmd, '레벨조정') = 0) then
      begin
        Abil.Level := _MIN(40, Str_ToInt(param1, 1));
        HasLevelUp(1);
        exit;
      end;
      if CompareText(cmd, 'SabukWallGold') = 0 then begin
        SysMsg('SabukWall Fund:' + IntToStr(UserCastle.TotalGold) +
          ',  Todays income:' + IntToStr(UserCastle.TodayIncome), 1);
        exit;
      end;
      if (CompareText(cmd, 'Recall') = 0) or (CompareText(cmd, '소환') = 0) then begin
        CmdRecallMan(param1, '');
        exit;
      end;
      // 특정 맵에 있는 사람들을 자신의 앞으로 소환한다(인원수는 함수내 고정).
      if (CompareText(cmd, 'RecallMap') = 0) or (CompareText(cmd, '맵소환') = 0) then
      begin
        CmdRecallMap(param1);
        exit;
      end;
      if CompareText(cmd, 'flag') = 0 then begin
        hum := UserEngine.GetUserHuman(param1);
        if hum <> nil then begin
          idx := Str_ToInt(param2, 0);
          if hum.GetQuestMark(idx) = 1 then
            SysMsg(hum.UserName + ':  [' + IntToStr(idx) + '] = ON', 1)
          else
            SysMsg(hum.UserName + ':  [' + IntToStr(idx) + '] = OFF', 1);
        end else
          SysMsg('@flag user_name number_of_flag', 0);
      end;
      if CompareText(cmd, 'showopen') = 0 then begin
        hum := UserEngine.GetUserHuman(param1);
        if hum <> nil then begin
          idx := Str_ToInt(param2, 0);
          if hum.GetQuestOpenIndexMark(idx) = 1 then
            SysMsg(hum.UserName + ':  [' + IntToStr(idx) + '] = ON', 1)
          else
            SysMsg(hum.UserName + ':  [' + IntToStr(idx) + '] = OFF', 1);
        end else
          SysMsg('@showopen user_name number_of_unit', 0);
      end;
      if CompareText(cmd, 'showunit') = 0 then begin
        hum := UserEngine.GetUserHuman(param1);
        if hum <> nil then begin
          idx := Str_ToInt(param2, 0);
          if hum.GetQuestFinIndexMark(idx) = 1 then
            SysMsg(hum.UserName + ':  [' + IntToStr(idx) + '] = ON', 1)
          else
            SysMsg(hum.UserName + ':  [' + IntToStr(idx) + '] = OFF', 1);
        end else
          SysMsg('@showunit user_name number_of_unit', 0);
      end;

      // 운영자 맘대루 친구등록
      if (CompareText(cmd, 'addfriend') = 0) or (CompareText(cmd, '친구등록') = 0)
      then begin
        if param1 <> '' then begin
          SendMsg(self, CM_FRIEND_ADD, 0, RT_FRIENDS, 1, 0, param1);
        end;
      end;


      //연인 만남
      if (CompareText(cmd, 'MeetCouple') = 0) or (CompareText(cmd, '만남') = 0) then
      begin
        if fLover <> nil then begin
          //만난지 100일 이상 되어야 사용 가능
          if fLover.GetLoverName <> '' then begin
            //MainOutMessage('GetLoverDays(2) : ' + fLover.GetLoverDays);
            if Str_ToInt(fLover.GetLoverDays, 0) >= 100 then begin
              CmdCharSpaceMove(fLover.GetLoverName);
            end else begin
              SysMsg(
                'Can be used after 100 days have passed from the first day of relationship.',
                0);
            end;
          end;
        end;
        exit;
      end;

      //명령어 추가
      if (CompareText(cmd, '안전') = 0) or (CompareText(cmd, 'safezone') = 0) then
      begin
        if InSafeZone then
          SysMsg('Safe Zone.', 2)
        else
          SysMsg('Not Safe Zone.', 0);
      end;
    end;

    if UserDegree >= UD_ADMIN then begin
      if CompareText(cmd, 'attack') = 0 then begin
        hum := UserEngine.GetUserHuman(param1);
        if hum <> nil then begin
          SelectTarget(hum);
        end;
        exit;
      end;
      if CompareText(cmd, 'Mob') = 0 then begin
        CmdCallMakeMonster(param1, param2);
        exit;
      end;
      if CompareText(cmd, 'RecallMob') = 0 then begin
        CmdCallMakeSlaveMonster(param1, param2, Str_ToInt(param3, 0),
          Str_ToInt(param4, 0));
        exit;
      end;
      if CompareText(cmd, 'LuckyPoint') = 0 then begin
        hum := UserEngine.GetUserHuman(param1);
        if hum <> nil then
          SysMsg(param1 + ': BodyLuck= ' + IntToStr(hum.BodyLuckLevel) +
            '/' + FloatToStr(hum.BodyLuck) + ' Luck = ' + IntToStr(hum.Luck), 1);
        exit;
      end;
      if CompareText(cmd, 'Lottery ticket') = 0 then begin
        SysMsg('won a prize ' + IntToStr(LottoSuccess) + ', ' +
          'Nothing ' + IntToStr(LottoFail) + ', ' + '1st prize ' +
          IntToStr(Lotto1) + ', ' + '2nd prize ' + IntToStr(Lotto2) +
          ', ' + '3rd prize ' + IntToStr(Lotto3) + ', ' + '4th prize ' +
          IntToStr(Lotto4) + ', ' + '5th prize ' + IntToStr(Lotto5) +
          ', ' + '6th prize ' + IntToStr(Lotto6)
          , 1);
        exit;
      end;
      if CompareText(cmd, 'ReloadGuild') = 0 then begin
        CmdReloadGuild(param1);
        exit;
      end;
      if CompareText(cmd, 'ReloadLineNotice') = 0 then begin
        if LoadLineNotice(LINENOTICEFILE) then begin
          SysMsg(LINENOTICEFILE + ' file is reloaded...', 1);
        end;
        exit;
      end;
      if CompareText(cmd, 'ReadAbuseInformation') = 0 then begin
        LoadAbusiveList('!Abuse.txt');
        SysMsg('reread abuse language information ', 1);
        exit;
      end;
      if CompareText(cmd, 'Back') = 0 then begin
        CharPushed(GetBack(Dir), 1);
        exit;
      end;
      if CompareText(cmd, 'EnergyWave') = 0 then begin
        CmdRushAttack;
        exit;
      end;
      if CompareText(cmd, 'FreePenalty') = 0 then begin
        CmdDeletePKPoint(param1);
        exit;
      end;
      if CompareText(cmd, 'PKpoint') = 0 then begin
        CmdSendPKPoint(param1, str_ToInt(param2, 0));
        exit;
      end;
      if CompareText(cmd, 'PKPointIncreased') = 0 then begin
        IncPkPoint(100);
        exit;
      end;
      if CompareText(cmd, 'ChangeLuck') = 0 then begin
        BodyLuck := Str_ToFloat(param1);
        AddBodyLuck(0);
        exit;
      end;
      if CompareText(cmd, 'Hunger') = 0 then begin
        HungryState := Str_ToInt(param1, 0);
        SendMsg(self, RM_MYSTATUS, 0, 0, 0, 0, '');
        exit;
      end;
      if cmd = 'hair' then begin
        hair := Str_ToInt(param1, 0);
        FeatureChanged;
        exit;
      end;
      if CompareText(cmd, 'Training') = 0 then begin
        CmdMakeFullSkill(param1, Str_ToInt(param2, 1));
        exit;
      end;
      if CompareText(cmd, 'DeleteSkill') = 0 then begin
        CmdEraseMagic(param1);
        exit;
      end;
      if CompareText(cmd, 'ChangeJob') = 0 then begin
        CmdChangeJob(param1);
        SysMsg(cmd, 1);
        HasLevelUp(1);  //능력치가 변경되게 하려구 함..
        exit;
      end;
      if CompareText(cmd, 'ChangeGender') = 0 then begin
        CmdChangeSex;
        SysMsg(cmd, 1);
        exit;
      end;
      if CompareText(cmd, 'NameColor') = 0 then begin
        DefNameColor := Str_ToInt(param1, 255);
        ChangeNameColor;
        exit;
      end;
      if CompareText(cmd, 'Mission') = 0 then begin
        CmdMissionSetting(param1, param2);
      end;
      if CompareText(cmd, 'MobPlace') = 0 then begin
        CmdCallMakeMonsterXY(param1{x}, param2{y}, param3{몹이름}, param4{마리수});
        exit;
      end;
      if (CompareText(cmd, 'Transparency') = 0) or (CompareText(cmd, 'tp') = 0) then
      begin
        BoHumHideMode := not BoHumHideMode;
        if BoHumHideMode then
          StatusArr[STATE_TRANSPARENT] := 60 * 60
        else
          StatusArr[STATE_TRANSPARENT] := 0;
        CharStatus := GetCharStatus;
        CharStatusChanged;
        exit;
      end;
      if CompareText(cmd, 'DeleteItem') = 0 then begin
        CmdEraseItem(param1, param2);
        exit;
      end;
      if CompareText(cmd, 'LevelAdjust0') = 0 then begin
        Abil.Level := _MIN(40, Str_ToInt(param1, 1));
        HasLevelUp(0);
        exit;
      end;
      if CompareText(cmd, 'Nullifingquest') = 0 then begin
        FillChar(QuestStates, sizeof(QuestStates), #0);
        exit;
      end;
      if CompareText(cmd, 'setflag') = 0 then begin
        hum := UserEngine.GetUserHuman(param1);
        if hum <> nil then begin
          idx := Str_ToInt(param2, 0);
          n   := Str_ToInt(param3, 0);
          hum.SetQuestMark(idx, n);
          if hum.GetQuestMark(idx) = 1 then
            SysMsg(hum.UserName + ':  [' + IntToStr(idx) + '] = ON', 1)
          else
            SysMsg(hum.UserName + ':  [' + IntToStr(idx) + '] = OFF', 1);
        end else
          SysMsg('@setflag user_name number_of_flag set_value', 0);
      end;
      if CompareText(cmd, 'setopen') = 0 then begin
        hum := UserEngine.GetUserHuman(param1);
        if hum <> nil then begin
          idx := Str_ToInt(param2, 0);
          n   := Str_ToInt(param3, 0);
          hum.SetQuestOpenIndexMark(idx, n);
          if hum.GetQuestOpenIndexMark(idx) = 1 then
            SysMsg(hum.UserName + ':  unit open [' + IntToStr(idx) + '] = ON', 1)
          else
            SysMsg(hum.UserName + ':  unit open [' + IntToStr(idx) +
              '] = OFF', 1);
        end else
          SysMsg('@setopen user_name number_of_unit set_value', 0);
      end;
      if CompareText(cmd, 'setunit') = 0 then begin
        hum := UserEngine.GetUserHuman(param1);
        if hum <> nil then begin
          idx := Str_ToInt(param2, 0);
          n   := Str_ToInt(param3, 0);
          hum.SetQuestFinIndexMark(idx, n);
          if hum.GetQuestFinIndexMark(idx) = 1 then
            SysMsg(hum.UserName + ':  unit set [' + IntToStr(idx) + '] = ON', 1)
          else
            SysMsg(hum.UserName + ':  unit set [' + IntToStr(idx) + '] = OFF', 1);
        end else
          SysMsg('@setunit user_name number_of_unit set_value', 0);
      end;
      if CompareText(cmd, 'Reconnection') = 0 then begin
        CmdReconnection(param1, param2); //addr, port
      end;
      //사북성 관련 명령어

         {if CompareText(cmd, 'Wallconquestwarmode') = 0 then begin
            UserCastle.BoCastleWarMode := not UserCastle.BoCastleWarMode;
            if UserCastle.BoCastleWarMode then SysMsg ('test mode change for wall conquest war', 1)
            else Sysmsg ('test mode cancel for wall conquest war', 1);
            UserCastle.ActivateDefeseUnits (UserCastle.BoCastleWarMode);
            exit;
         end;}

      if CompareText(cmd, 'DisableFilter') = 0 then begin
        BoEnableAbusiveFilter := not BoEnableAbusiveFilter;
        if BoEnableAbusiveFilter then
          SysMsg('[able filter for abuse language]', 1)
        else
          SysMsg('[Disable filter for abuse language]', 1);
      end;
      if cmd = 'CHGUSERFULL' then begin
        UserFullCount := _MAX(250, Str_ToInt(param1, 0));
        SysMsg('USERFULL ' + IntToStr(UserFullCount), 1);
        exit;
      end;
      if cmd = 'CHGZENFASTSTEP' then begin
        ZenFastStep := _MAX(100, Str_ToInt(param1, 0));
        SysMsg('ZENFASTSTEP ' + IntToStr(ZenFastStep), 1);
        exit;
      end;

      if Str_ToInt(cmd, 0) = GET_INFO_PASSWD then begin
        SysMsg('current monthly ' + IntToStr(CurrentMonthlyCard), 1);
        SysMsg('total timeusage ' + IntToStr(TotalTimeCardUsage), 1);
        SysMsg('last mon totalu ' + IntToStr(LastMonthTotalTimeCardUsage), 1);
        SysMsg('gross total cnt ' + IntToStr(GrossTimeCardUsage), 1);
        SysMsg('gross reset cnt ' + IntToStr(GrossResetCount), 1);
        exit;
      end;
      if Str_ToInt(cmd, 0) = CHG_ECHO_PASSWD then begin
        BoEcho := not BoEcho;
        if BoEcho then
          SysMsg('Echo on', 1)
        else
          SysMsg('Echo off', 1);
        MainOutMessage('...... '); //adminlog
      end;
      if not BoEcho then
        if Str_ToInt(cmd, 0) = KIL_SERVER_PASSWD then begin  //kill server
          MainOutMessage('  '); //adminlog
          if Random(4) = 0 then begin
            BoGetGetNeedNotice := True;
            GetGetNoticeTime   := GetTickCount + longword(Random(60 * 60 * 1000));
            SysMsg('timer set up...', 0);
            MainOutMessage('   '); //adminlog
          end;
        end;

      //문파 대전 관련 명령어

      if CompareText(cmd, 'ContestPoint') = 0 then begin
        CmdGetGuildMatchPoint(param1);
        exit;
      end;
      if CompareText(cmd, 'StartContest') = 0 then begin
        //대련 전용맵에서만 사용할 수 있다.
        CmdStartGuildMatch;
        exit;
      end;
      if CompareText(cmd, 'EndContest') = 0 then begin
        //대련 전용맵에서만 사용할 수 있다.
        CmdEndGuildMatch;
        exit;
      end;
      if CompareText(cmd, 'Announcement') = 0 then begin
        CmdAnnounceGuildMembersMatchPoint(param1);
      end;

      //O/X 퀴즈 방 명령어 (사용자는 외치기를 할 수 없다.)
      if CompareText(cmd, 'OXQuizRoom') = 0 then begin

      end;

      //////////

      if (UserDegree >= UD_ADMIN) or BoTestServer then begin
        if CompareText(cmd, 'Make') = 0 then begin
          CmdMakeItem(param1, Str_ToInt(param2, 1));
          exit;
        end;
        if CompareText(cmd, 'DelGold') = 0 then begin
          CmdDeleteUserGold(param1, param2);
          exit;
        end;
        if CompareText(cmd, 'AddGold') = 0 then begin
          CmdAddUserGold(param1, param2);
          exit;
        end;
        if cmd = 'Test_GOLD_Change' then begin
          if BoEcho then
            MainOutMessage('[MakeGold] ' + UserName + ' ' + param1);
          Gold := _MIN(BAGGOLD, Str_ToInt(param1, 0));
          GoldChanged;
          exit;
        end;
        if CompareText(cmd, 'WeaponRefinery') = 0 then begin
          CmdRefineWeapon(Str_ToInt(param1, 0), Str_ToInt(param2, 0),
            Str_ToInt(param3, 0), Str_ToInt(param4, 0));
          if BoEcho then
            MainOutMessage('[Refine] ' + UserName + ' ' + param1 +
              ' ' + param2 + ' ' + param3 + ' ' + param4);
          exit;
        end;
        if CompareText(cmd, 'ReloadAdmin') = 0 then begin
          FrmDB.LoadAdminFiles;
          UserEngine.SendInterMsg(ISM_RELOADADMIN, ServerIndex, '');
          SysMsg(cmd + ' It applied to all servers', 1);
          exit;
        end;
        if CompareText(cmd, 'MarketOpen') = 0 then begin
          SqlEngine.Open(True);
          UserEngine.SendInterMsg(ISM_MARKETOPEN, ServerIndex, '');
          SysMsg(cmd + ' Commission merchant system is opened.', 1);
          exit;
        end;
        if CompareText(cmd, 'MarketClose') = 0 then begin
          SqlEngine.Open(False);
          UserEngine.SendInterMsg(ISM_MARKETCLOSE, ServerIndex, '');
          SysMsg(cmd + ' Commission merchant system is closed.', 1);
          exit;
        end;
        if CompareText(cmd, 'ReloadNpc') = 0 then begin
          //자신의 주면에 있는 npc 정보를 리로드 시킨다.
          CmdReloadNpc(param1);
          exit;
        end;
        if CompareText(cmd, 'ReloadMonItems') = 0 then begin
          UserEngine.ReloadAllMonsterItems;
          SysMsg('monsters item information is all reloaded.', 1);
          exit;
        end;
        if CompareText(cmd, 'ReloadDiary') = 0 then begin
          if FrmDB.LoadQuestDiary < 0 then
            SysMsg('QuestDiarys reload failure...', 0)
          else
            SysMsg('QuestDiarys reload successful', 1);
          exit;
        end;
        if CompareText(cmd, 'AdjustLevel') = 0 then begin
          CmdManLevelChange(param1, Str_ToInt(param2, 1));
          exit;
        end;
        if CompareText(cmd, 'AdjustExp') = 0 then begin
          CmdManExpChange(param1, Str_ToInt(param2, 1));
          exit;
        end;
        if CompareText(cmd, 'AddGuild') = 0 then begin
          CmdCreateGuild(param1, param2);
          exit;
        end;
        if CompareText(cmd, 'DelGuild') = 0 then begin
          CmdDeleteGuild(param1);
          exit;
        end;
        if CompareText(cmd, 'ChangeSabukLord') = 0 then begin
          CmdChangeUserCastleOwner(param1, True);
          exit;
        end;
        if CompareText(cmd, 'ForcedWallconquestWar') = 0 then begin
          UserCastle.BoCastleUnderAttack := not UserCastle.BoCastleUnderAttack;
          if UserCastle.BoCastleUnderAttack then begin
            UserCastle.CastleAttackStarted := GetTickCount;
            UserCastle.StartCastleWar;
          end else begin
            UserCastle.FinishCastleWar;
          end;
          exit;
        end;
        if CompareText(cmd, 'AddToItemEvent') = 0 then begin
          if param1 <> '' then begin
            EventItemList.AddObject(param1, TObject(EventItemGifeBaseNumber +
              EventItemList.Count));
            SysMsg('AddToItemEvent ' + param1, 1);
          end;
          if param2 <> '' then begin
            EventItemList.AddObject(param2, TObject(EventItemGifeBaseNumber +
              EventItemList.Count));
            SysMsg('AddToItemEvent ' + param2, 1);
          end;
          if param3 <> '' then begin
            EventItemList.AddObject(param3, TObject(EventItemGifeBaseNumber +
              EventItemList.Count));
            SysMsg('AddToItemEvent ' + param3, 1);
          end;
          if param4 <> '' then begin
            EventItemList.AddObject(param4, TObject(EventItemGifeBaseNumber +
              EventItemList.Count));
            SysMsg('AddToItemEvent ' + param4, 1);
          end;
          if param5 <> '' then begin
            EventItemList.AddObject(param5, TObject(EventItemGifeBaseNumber +
              EventItemList.Count));
            SysMsg('AddToItemEvent ' + param5, 1);
          end;
          exit;
        end;
        if CompareText(cmd, 'AddToItemEventAsPieces') = 0 then begin
          n := Str_ToInt(param2, 1);
          for i := 1 to n do begin
            EventItemList.AddObject(param1,
              TObject(EventItemGifeBaseNumber + EventItemList.Count));
            SysMsg('AddToItemEvent ' + param1, 1);
          end;
          exit;
        end;
        if CompareText(cmd, 'ItemEventList') = 0 then begin
          SysMsg('[Item event list]', 1);
          for i := 0 to EventItemList.Count - 1 do begin
            SysMsg(EventItemList[i] + ' ' + IntToStr(
              integer(EventItemList.Objects[i])), 1);
          end;
          exit;
        end;
        if CompareText(cmd, 'StartingGiftNo') = 0 then begin
          EventItemGifeBaseNumber := Str_ToInt(param1, 0);
          SysMsg('Starting no. of gift certificate ' +
            IntToStr(EventItemGifeBaseNumber), 1);
          exit;
        end;
        if CompareText(cmd, 'DeleteAllItemEven') = 0 then begin
          EventItemList.Clear;
          SysMsg('DeleteAllItemOfItemEvent', 1);
          exit;
        end;
        if CompareText(cmd, 'StartItemEvent') = 0 then begin
          UserEngine.BoUniqueItemEvent := not UserEngine.BoUniqueItemEvent;
          if UserEngine.BoUniqueItemEvent then
            SysMsg('start of item event', 1)
          else
            SysMsg('end of item event', 1);
          exit;
        end;
        if CompareText(cmd, 'ItemEventTerm') = 0 then begin
          UserEngine.UniqueItemEventInterval := Str_ToInt(param1, 30) * 60 * 1000;
          SysMsg('term of item event = ' + IntToStr(Str_ToInt(param1, 30)) +
            'Min', 1);
          exit;
        end;
        if CompareText(cmd, 'AdjustTestLevel') = 0 then begin
          Abil.Level := _MIN(MAXLEVEL - 1, Str_ToInt(param1, 1));    //50
          HasLevelUp(1);
          exit;
        end;
        if CompareText(cmd, 'OPTraining') = 0 then begin
          CmdMakeOtherChangeSkillLevel(param1, param2, Str_ToInt(param3, 1));
          exit;
        end;
        if CompareText(cmd, 'OPDeleteSkill') = 0 then begin
          CmdThisManEraseMagic(param1, param2);
        end;
        if CompareText(cmd, 'ChangeWeaponDura') = 0 then begin
          n := _MIN(65, _MAX(0, Str_ToInt(param1, 0)));
          if (UseItems[U_WEAPON].Index <> 0) and (n > 0) then begin
            UseItems[U_WEAPON].DuraMax := n * 1000;
            SendMsg(self, RM_DURACHANGE, U_WEAPON, UseItems[U_WEAPON].Dura,
              UseItems[U_WEAPON].DuraMax, 0, '');
          end;
          exit;
        end;
        ///////////////////////
        // added by sonmg...
        if CompareText(cmd, 'Upgrade') = 0 then begin
          CmdUpgradeItem(param1, param2, 0, 0, Str_ToInt(param3, 0));
          exit;
        end;
        if CompareText(cmd, 'allgem') = 0 then begin
          CmdMakeAllJewelryItem(0);
          exit;
        end;
        if CompareText(cmd, 'allorb') = 0 then begin
          CmdMakeAllJewelryItem(1);
          exit;
        end;
        if CompareText(cmd, 'ReloadMakeItemList') = 0 then begin
          //제조 재료 목록을 리로드 시킨다.
          FrmDB.LoadMakeItemList;
          UserEngine.SendInterMsg(ISM_RELOADMAKEITEMLIST, ServerIndex, '');
          SysMsg(cmd + ' is reloaded to whole server.', 1);
          exit;
        end;
        ///////////////////////
        if (CompareText(cmd, 'AgitDecoMonCount') = 0) or
          (CompareText(cmd, '꾸미기개수') = 0) then begin
          CmdAgitDecoMonCount(Str_ToInt(param1, 1));
          exit;
        end;
        if (CompareText(cmd, 'AgitDecoMonCountHere') = 0) or
          (CompareText(cmd, '상현개수') = 0) then begin
          CmdAgitDecoMonCountHere;
          exit;
        end;
      end;
{
         if CompareText (cmd, 'ReloadGuildAll') = 0 then begin
            CmdReloadGuildAll (param1);
            exit;
         end;
}
      if CompareText(cmd, 'ReloadGuildAgit') = 0 then begin
        CmdReloadGuildAgit;
        exit;
      end;
      // 앞에 있는 몹을 한방에 죽임.
      if BoTestServer and (CompareText(cmd, 'OneKill') = 0) then begin
        CmdOneKillMob;
        exit;
      end;

    end;
    exit;
  end else begin
    //NoChat 맵속성 추가(sonmg 2004/10/12)
    if PEnvir.NoChat then begin
      SysMsg('You cannot chat on this map.', 0);
      exit;
    end;

    //도배 방지 루틴
    if (saystr = LatestSayStr) and (GetTickCount - BombSayTime < 3000) then begin
      Inc(BombSayCount);
      if BombSayCount >= 2 then begin
        BoShutUpMouse   := True;
        ShutUpMouseTime := GetTickCount + 60 * 1000;
        SysMsg('[spamming protection rule applied : banned from dialogue for 1 min]',
          0);
      end;
    end else begin
      LatestSayStr := saystr;
      BombSayTime  := GetTickCount;
      BombSayCount := 0;
    end;

    //도배로 채팅 금지를 해제
    if GetTickCount > ShutUpMouseTime then
      BoShutUpMouse := False;
    boshutup := BoShutUpMouse;

    //운영자에 의해 채팅금지 됨
    if ShutUpList.FFind(UserName) >= 0 then begin
      boshutup := True;
    end;

    if not boshutup then begin

      if saystr[1] = '/' then begin
        str := Copy(saystr, 2, length(saystr) - 1);

        if (UserDegree >= UD_SYSOP) then begin
          if CompareText(str, 'who ') = 0 then begin
            NilMsg('No. of user: ' + IntToStr(UserEngine.GetUserCount));
            exit;
          end;
          if UserDegree >= UD_ADMIN then begin
            if (CompareText(str, 'total ') = 0) then begin
              NilMsg('Total  number of  user of all server: ' +
                IntToStr(TotalUserCount));
              exit;
            end;
          end;
        end;
        str := GetValidStr3(str, param1, [' ']);
        Whisper(param1, str);  //귓속말
        exit;
      end;
      // 2003/08/28 채팅로그 이전자리

      if saystr[1] = '!' then begin
        if Length(saystr) >= 2 then begin
          if saystr[2] = '!' then begin  //그룹 메세지
            str := Copy(saystr, 3, length(saystr) - 2);
            GroupMsg(UserName + ': ' + str);
            exit;
          end;
          if (saystr[2] = '~') or (saystr[2] = '&') then begin  //문파 메세지
            if MyGuild <> nil then begin
              str := Copy(saystr, 3, length(saystr) - 2);
              TGuild(MyGuild).GuildMsg(UserName + ':' + str);
              UserEngine.SendInterMsg(ISM_GUILDMSG, ServerIndex,
                TGuild(MyGuild).GuildName + '/' + UserName + ':' + str);
            end;
            exit;
          end;
        end;
        if not PEnvir.QuizZone then begin  //퀴즈방에서는 외치기가 안된다.
          if GetTickCount - LatestCryTime > 10 * 1000 then begin
            if Abil.Level <= 7 then begin //외치기 제약 레벨 7 이상
              SysMsg('Shouting allowed over level   8.', 0);
            end else begin
              // 문주 장원내 공지(sonmg)
              if IsMyGuildMaster then begin
                //시간 Delay 없음.
                //                        LatestCryTime := GetTickCount;
                str := Copy(saystr, 2, length(saystr) - 1);
                UserEngine.GuildAgitCry(RM_CRY, PEnvir, CX,
                  CY, 50{wide}, '(!)' + UserName + ':' + str);
              end else begin
                LatestCryTime := GetTickCount;
                str := Copy(saystr, 2, length(saystr) - 1);
                UserEngine.CryCry(RM_CRY, PEnvir, CX, CY,
                  50{wide}, '(!)' + UserName + ':' + str);
              end;
            end;
          end else begin
            SysMsg(IntToStr(10 - ((GetTickCount - LatestCryTime) div 1000)) +
              '  seconds remaining for next shouting.', 0);
          end;
        end else
          SysMsg('You cannot use it.', 0);
        exit;
      end else begin
        //            if CompareLStr(saystr, '♡', 2) then begin  //연인 메세지
        if CompareLStr(saystr, ':)', 2) then begin  //연인 메세지
          //연인이 있는 사람만...
          if fLover.GetLoverName <> '' then begin
            str := Copy(saystr, 3, length(saystr) - 2);
            LoverWhisper(fLover.GetLoverName, str);  //연인 귓속말
            exit;
          end;
        end;
      end;
      inherited Say(saystr);
    end else
      SysMsg('Chatting is not allowed.', 0); //도배 금지...

  end;
end;

procedure TUserHuman.ThinkEtc;
begin
  if Bright <> MirDayTime then begin
    Bright := MirDayTime;
    SendMsg(self, RM_DAYCHANGING, 0, 0, 0, 0, '');
  end;
end;

procedure TUserHuman.ReadySave;
begin
  Abil.HP := WAbil.HP;
  BrokeDeal;
end;

{----------------------------------------------}

procedure TUserHuman.SendLogon;
var
  wl: TMessageBodyWL;
begin
  Def := MakeDefaultMsg(SM_LOGON, integer(self), CX, CY, MakeWord(Dir, Light));
  wl.lParam1 := Feature;
  wl.lParam2 := CharStatus;
  if AllowGroup then
    wl.lTag1 := MakeLong(MakeWord(1, 0), 0)
  else
    wl.lTag1 := 0;
  wl.lTag2 := 0;
  SendSocket(@Def, EncodeBuffer(@wl, sizeof(TMessageBodyWL)));
end;

procedure TUserHuman.SendAreaState;
var
  n: integer;
begin
  n := 0;
  if PEnvir.FightZone then
    n := n or AREA_FIGHT;
  if PEnvir.Fight2Zone then
    n := n or AREA_FIGHT;  //sonmg (2004/12/23)
  if PEnvir.LawFull then
    n := n or AREA_SAFE;
  if BoInFreePKArea then
    n := n or AREA_FREEPK;
  SendDefMessage(SM_AREASTATE, n, 0, 0, 0, '');
end;

procedure TUserHuman.DoStartupQuestNow;
begin
  if StartupQuestNpc <> nil then begin
    TMerchant(StartupQuestNpc).UserCall(self);
  end;

end;


procedure TUserHuman.Operate;
var
  msg:    TMessageInfo;
  cdesc:  TCharDesc;
  wl:     TMessageBodyWL;
  mbw:    TMessageBodyW;
  smsg:   TShortMessage;
  str:    string;
  strupgrade: string;
  wd, ahour, amin, asec, amsec: word;
  i, n, m, oldcolor, cltime, svtime: integer;
  r:      real;
  flag:   boolean;
  ps:     PTStdItem;
  Cret:   TCreature;
  identbackup: integer;
  DefMsg: TDefaultMessage;
  hum:    TUserHuman;
  lovername: string;
  svidx:  integer;
begin
  try
    if BoDealing then begin
      //벽보고 거래해서 돈복사되는 버그를 고침
      if (GetFrontCret <> DealCret) or (DealCret = self) or (DealCret = nil) then
      begin
        BrokeDeal;
      end;
    end;

    // 계정시간 만료에 의한 시간체크및 메세지전송 2003-01-17 : PDS
    CheckExpiredTime;

    if BoAccountExpired then begin
      SysMsg('Your account expired.', 0);
      SysMsg('Connection was terminated', 0);
      MainOutMessage('[AccountExpired] ' + UserName + ' (' +
        IntToStr(AvailableMode) + ')');
      EmergencyClose   := True;
      BoAccountExpired := False;  //메세지는 한번 만
    end;

    if BoAllowFireHit then begin  //염화결 해제..
      if GetTickCount - LatestFireHitTime > 20 * 1000 then begin
        BoAllowFireHit := False;
        SysMsg('The spirits of fire disappeared.', 0);
        SendSocket(nil, '+UFIR');

        if BoGetGetNeedNotice then    /////////////////////
          if GetTickCount - GetGetNoticeTime > 2 * 60 * 60 * 1000 then
            GetGetNotices;
      end;
    end;
    if BoAllowTwinHit = 2 then begin  //쌍룡참 해제..
      BoAllowTwinHit := 0;
      //       SysMsg ('쌍룡참이 해제되었습니다.', 0);
      SendSocket(nil, '+UTWN');
    end;

    if BoTimeRecallGroup then begin
      if GetTickCount > TimeRecallEnd then begin
        BoTimeRecall      := False;
        BoTimeRecallGroup := False;
        SpaceMove(TimeRecallMap, TimeRecallX, TimeRecallY, 0);
      end;
    end else if BoTimeRecall then begin
      if GetTickCount > TimeRecallEnd then begin
        BoTimeRecall := False;
        SpaceMove(TimeRecallMap, TimeRecallX, TimeRecallY, 0);
      end;
    end;

    if GetTickCount - operatetime_30sec > 20 * 1000 then begin
      operatetime_30sec := GetTickCount;

      if BoTaiwanEventUser then begin   //주변 사람들에게 자신의 위치를 알린다.
        UserEngine.CryCry(RM_CRY, PEnvir, CX, CY, 1000,
          UserName + ' is ' + IntToStr(CX) + ' ' + IntToStr(CY) +
          ' (' + TaiwanEventItemName + ')');
      end;
    end;

    if GetTickCount - operatetime > 3000 then begin
      operatetime := GetTickCount;

      //스패드핵(speedhack) 검사
      ///SendDefMessage (SM_TIMECHECK_MSG, GetTickCount, 0, 0, 0, '');

      CheckHomePos;

      //다른 캐릭과 겹쳐졌는지를 검사한다.
      n := PEnvir.GetDupCount(CX, CY);
      if n >= 2 then begin
        if not BoDuplication then begin
          BoDuplication := True;
          DupStartTime  := GetTickCount;
        end;
      end else
        BoDuplication := False;
      if (n >= 3) and (GetTickCount - DupStartTime > 3000) or
        (n = 2) and (GetTickCount - DupStartTime > 10000) then begin
        if GetTickCount - DupStartTime < 20000 then begin
          CharPushed(Random(8), 1);
        end;// else
            //RandomSpaceMove (PEnvir.MapName, 0);
      end;

    end;

    //공성전 중인 경우
    if UserCastle.BoCastleUnderAttack then begin
      //공성전 지역내에서는 프리피케이 지역
      BoInFreePKArea := UserCastle.IsCastleWarArea(PEnvir, CX, CY);
    end;

    if GetTickCount - operatetime_sec > 1000 then begin
      operatetime_sec := GetTickCount;

      //접속 로그를 남김
      //할인 시간의 경계에는 로그를 남김.
      DecodeTime(Time, ahour, amin, asec, amsec);
      //할인 시간 시작 혹은 끝
      if DiscountForNightTime then begin
        if ((ahour = HalfFeeStart) or (ahour = HalfFeeEnd)) and
          (amin = 0) and (asec <= 30) then begin
          //할인 시간이 시작되는 때
          if GetTickCount - LoginTime > 60 * 1000 then begin
            //할인시간시작때 기록을 하지 않은 경우
            //할인 시간 이전에 접속한 경우임
            WriteConLog;
            LoginTime     := GetTickCount;
            LoginDateTime := Now;
          end;
        end;
      end;

      //문파전으로 지역에 따라서 이름이 색깔이 변경될 경우가 있음
      if MyGuild <> nil then begin
        if TGuild(MyGuild).GuildName <> '' then begin   // 2004/04/28(sonmg)
          if TGuild(MyGuild).KillGuilds.Count > 0 then begin //문파전 중임
            flag := InGuildWarSafeZone;
            if boGuildwarsafezone <> flag then begin
              boGuildwarsafezone := flag;  //지역에 따라서 이름색이 변경됨
              ChangeNameColor;
            end;
          end;
        end;
      end;

      //공성전 중인 경우
      if UserCastle.BoCastleUnderAttack then begin

        //사북성의 내성을 점령하면 성을 차지하게 된다.
        if PEnvir = UserCastle.CorePEnvir then begin  //내성안에 있는 경우
          if (MyGuild <> nil) and not UserCastle.IsCastleMember(self) then begin
            //성을 공격하는 문파가 점령한 경우
            if UserCastle.IsRushCastleGuild(TGuild(MyGuild)) then begin
              //공성전을 신청한 문파원이 내성 안에 있음
              if UserCastle.CheckCastleWarWinCondition(TGuild(MyGuild)) then
              begin
                //내성 점령 성공
                UserCastle.ChangeCastleOwner(TGuild(MyGuild));
                //다른 서버에 알림
                UserEngine.SendInterMsg(ISM_CHANGECASTLEOWNER,
                  ServerIndex, TGuild(MyGuild).GuildName);

                //공성전은 종료됨, 승리문 이외에 모든 사람은 다른 곳으로 날라감
                if UserCastle.GetRushGuildCount <= 1 then
                  UserCastle.FinishCastleWar;
                //공격자가 2문파 이상이면 3시간이 끝나야 종료됨

              end;
            end;

          end;
        end;

      end else begin
        BoInFreePKArea := False;
      end;

      if AreaStateOrNameChanged then begin
        AreaStateOrNameChanged := False;
        SendAreaState;
        UserNameChanged;
      end;

      // 20003/02/11 그룹원 위치 전달
      if GroupOwner <> nil then begin
        for i := 0 to GroupOwner.GroupMembers.Count - 1 do begin
          cret := TCreature(GroupOwner.GroupMembers.Objects[i]);
          //              if (cret <> self) and (cret.MapName = MapName) then
          if (cret.MapName = MapName) then begin
            cret.SendMsg(self, RM_GROUPPOS, dir, CX, CY, RaceServer, '');
            cret.SendMsg(self, RM_HEALTHSPELLCHANGED, 0, 0, 0, 0, '');
          end;
        end;
      end;
      if SlaveList.Count >= 1 then begin
        for i := 0 to SlaveList.Count - 1 do begin
          cret := TCreature(SlaveList[i]);
          if (cret <> nil) and (cret.MapName = MapName) then begin
            SendMsg(cret, RM_GROUPPOS, cret.dir, cret.CX,
              cret.CY, cret.RaceServer, '');
            SendMsg(cret, RM_HEALTHSPELLCHANGED, 0, 0, 0, 0, '');
            //                 cret.SendMsg(self, RM_HEALTHSPELLCHANGED, 0, 0, 0, 0, '');
          end;
        end;
      end;

    end;

    if GetTickCount - operatetime_500m >= 500 then begin
      operatetime_500m := GetTickCount;

      //대만 이벤트 관련
      if BoTaiwanEventUser then begin  //이벤트 해제.....
        flag := False;
        for i := 0 to ItemList.Count - 1 do begin
          ps := UserEngine.GetStdItem(PTUserItem(ItemList[i]).Index);
          if ps <> nil then begin
            if ps.StdMode = TAIWANEVENTITEM then begin
              //대만 이벤트, 이벤트 아이템을 주으면 표시남
              flag := True;
            end;
          end;
        end;
        if not flag then begin  //이벤트 해제.....
          TaiwanEventItemName := '';
          BoTaiwanEventUser := False;
          //캐릭의 색깔을 바꾼다.
          StatusArr[STATE_BLUECHAR] := 1;  //타임 아웃
          Light := GetMyLight;
          SendRefMsg(RM_CHANGELIGHT, 0, 0, 0, 0, '');
          CharStatus := GetCharStatus;
          CharStatusChanged;
          UserNameChanged;
        end;
      end;

    end;

      (*if GetTickCount - ClientMsgTime > 1000 * 2 then begin
         r := ClientMsgCount / (GetTickCount - ClientMsgTime) * 1000;
         //SysMsg (FloatToStr(r), 0);
         ClientMsgTime := GetTickCount;
         if r >= 1.8 then begin
            Inc (ClientSpeedHackDetect);
            if ClientSpeedHackDetect >= 3 then begin
               MainOutMessage ('[using hacking program] ' + UserName);
               SysMsg ('=====================================================', 0);
               SysMsg ('recorded as user of hacking program .', 0);
               SysMsg ('Please be noted that you may have sanction  as like account seizure.', 0);
               SysMsg ('Connection was terminated by force.', 0);
               SysMsg ('=====================================================', 0);
               UserSocketClosed := TRUE;
            end;
         end else
            ClientSpeedHackDetect := 0;
         ClientMsgCount := 0;
      end; *)

  except
    MainOutMessage('[Exception] TUserHuman.Operate 1');
  end;

  IdentBackup := 0;

  try
    while GetMsg(msg) do begin

      IdentBackup := msg.Ident;

      case msg.Ident of
        //클라이언트가 보내는 메세지 처리
        CM_CLIENT_CHECKTIME: begin
          ;
        end;
        CM_TURN: with msg do begin
            if self.Death or not TurnXY(lParam1{x}, lParam2{y},
              msg.wParam{dir}) then
              SendSocket(nil, '+FAIL/' + IntToStr(GetTickCount))
            else
              SendSocket(nil, '+GOOD/' + IntToStr(GetTickCount));
          end;
        CM_WALK: with msg do begin
            if self.Death or not WalkXY(msg.lParam1{x}, msg.lParam2{y}) then begin
              SendSocket(nil, '+FAIL/' + IntToStr(GetTickCount));
            end else begin
              SendSocket(nil, '+GOOD/' + IntToStr(GetTickCount));
              Inc(ClientMsgCount);
            end;
          end;
        CM_RUN: with msg do begin
            if self.Death or not RunXY(msg.lParam1{x}, msg.lParam2{y}) then
              SendSocket(nil, '+FAIL/' + IntToStr(GetTickCount))
            else begin
              SendSocket(nil, '+GOOD/' + IntToStr(GetTickCount));
              Inc(ClientMsgCount);
            end;
          end;
        CM_HIT,
        CM_HEAVYHIT,
        CM_BIGHIT,
        CM_POWERHIT,
        CM_slashhit,
        CM_LONGHIT,
        CM_WIDEHIT,
        CM_WIDEHIT2,
        // 2003/03/15 신규무공
        CM_CROSSHIT,
        CM_TWINHIT,
        CM_FIREHIT: begin
          if not self.Death then begin
            with msg do
              if HitXY(Ident, lparam1{X}, lparam2{Y}, wParam{DIR}) then
              begin  //wParam = 방향
                //                           SendSocket (nil, '+GOOD/' + IntToStr(GetTickCount));
                SendSocket(nil, '+GOOD/' + IntToStr(GetTickCount) +
                  '/' + IntToStr(HitSpeed));//해킹툴체크(sonmg)
                Inc(ClientMsgCount);
              end else
                SendSocket(nil, '+FAIL/' + IntToStr(GetTickCount));
          end else
            SendSocket(nil, '+FAIL/' + IntToStr(GetTickCount));
        end;
        CM_THROW: begin
          if not self.Death then begin
            with msg do
              //if HitXY (Ident, lparam1{X}, lparam2{Y}, wParam{DIR}) then begin  //wParam = 방향
              SendSocket(nil, '+GOOD/' + IntToStr(GetTickCount));
            //   Inc (ClientMsgCount);
            //end else
            //   SendSocket (nil, '+FAIL/' + IntToStr(GetTickCount));
          end;
        end;
        CM_SPELL: begin
          if not self.Death then begin
            with msg do
              if SpellXY(wParam{magid}, lparam1{targetx},
                lparam2{targety}, lparam3{target cret}) then begin
                SendSocket(nil, '+GOOD/' + IntToStr(GetTickCount));
                Inc(ClientMsgCount);
              end else begin
                //호혼석 버그로 인해 삭제(sonmg 2005/10/06) 테스트 요망(부작용)
                SendSocket(nil, '+FAIL/' + IntToStr(GetTickCount));
              end;
          end else
            SendSocket(nil, '+FAIL/' + IntToStr(GetTickCount));
        end;
        CM_SITDOWN: begin
          if not self.Death then begin
            with msg do
              SitdownXY(lparam1{x}, lparam2{y}, wParam{dir});
            SendSocket(nil, '+GOOD/' + IntToStr(GetTickCount));
          end else
            SendSocket(nil, '+FAIL/' + IntToStr(GetTickCount));
        end;
        CM_SAY: begin
          if msg.description <> '' then
            Say(msg.description);
        end;

        CM_DROPITEM: begin
          if UserDropItem(msg.Description, msg.lparam1) then
            SendDefMessage(SM_DROPITEM_SUCCESS, msg.lparam1, 0, 0, 0, msg.Description)
          else
            SendDefMessage(SM_DROPITEM_FAIL, msg.lparam1, 0, 0, 0, msg.Description);
        end;

        // 카운트 아이템
        CM_DROPCOUNTITEM: begin
          if msg.lparam2 > 0 then
            if UserDropCountItem(msg.Description, msg.lparam1, msg.lparam2) then
              SendDefMessage(SM_DROPITEM_SUCCESS, msg.lparam1, 0,
                0, 0, msg.Description);
        end;

        CM_PICKUP: begin
          if (CX = msg.lParam2{x}) and (CY = msg.lparam3{y}) then
            PickUp;
        end;

        CM_QUERYUSERNAME: begin
          GetQueryUserName(TCreature(msg.lparam1){cret},
            msg.lparam2{x}, msg.lparam3{y});
        end;
        CM_QUERYBAGITEMS: begin
          SendBagItems;
        end;

        CM_OPENDOOR: begin
          ServerGetOpenDoor(msg.lparam2{x}, msg.lparam3{y});
        end;

        CM_TAKEONITEM: begin
          ServerGetTakeOnItem(msg.lparam2{where?},
            msg.lparam1{item's sindex}, msg.Description{item name});
        end;

        CM_TAKEOFFITEM: begin
          ServerGetTakeOffItem(msg.lparam2{where?},
            msg.lparam1{item's sindex}, msg.Description{item name});
        end;

        CM_EXCHGTAKEONITEM: begin
        end;

        CM_EAT: begin
          ServerGetEatItem(msg.lparam1{item's sindex}, msg.Description);
        end;

        CM_BUTCH: begin
          ServerGetButch(TCreature(msg.lparam1){targer},
            msg.lparam2{x}, msg.lparam3{y}, msg.wparam);
        end;

        CM_MAGICKEYCHANGE: begin
          ServerGetMagicKeyChange(msg.lparam1{magid}, msg.lparam2);
        end;

        CM_SOFTCLOSE: begin
          SoftClosed := True;  //캐릭터 선택을 다시하기 위해 나간 것임...
          UserSocketClosed := True;  //접속을 끊음.
        end;

        CM_CANCLOSE: begin
          //꼬봉몹의 공격대상이 있을 경우는 로그아웃 할 수 없도록 함.
          if ExistAttackSlaves then begin
            SendMsg(self, RM_CANCLOSE_FAIL, 0, 0, 0, 0, '');
          end else begin
            SendMsg(self, RM_CANCLOSE_OK, 0, 0, 0, 0, '');
          end;
        end;

        CM_CLICKNPC:  //NPC,상인을 클릭함.
        begin
          ServerGetClickNpc(msg.lParam1);
        end;

        CM_MERCHANTDLGSELECT: begin
          ServerGetMerchantDlgSelect(msg.lparam1, msg.Description);
        end;

        CM_MERCHANTQUERYSELLPRICE: begin
          ServerGetMerchantQuerySellPrice(msg.lparam1,
            MakeLong(msg.lparam2, msg.lparam3), msg.Description);
        end;
        CM_MERCHANTQUERYREPAIRCOST: begin
          ServerGetMerchantQueryRepairPrice(msg.lparam1,
            MakeLong(msg.lparam2, msg.lparam3), msg.Description);
        end;

        CM_USERSELLITEM: begin
          // 카운트 아이템
          ServerGetUserSellItem(msg.lparam1,
            MakeLong(msg.lparam2, msg.lparam3), msg.wparam, msg.Description);
        end;
        CM_USERREPAIRITEM: begin
          ServerGetUserRepairItem(msg.lparam1,
            MakeLong(msg.lparam2, msg.lparam3), msg.Description);
        end;
        CM_USERSTORAGEITEM: begin
          ServerGetUserStorageItem(msg.lparam1,
            MakeLong(msg.lparam2, msg.lparam3), abs(msg.wparam), msg.Description);
        end;

        CM_USERGETDETAILITEM: //상세 메뉴
          ServerGetUserMenuBuy(msg.Ident, msg.lparam1{merchant},
            0, msg.lparam2, msg.Description);
        CM_USERBUYITEM:  //산다
          ServerGetUserMenuBuy(msg.Ident, msg.lparam1{merchant},
            MakeLong(msg.lparam2, msg.lparam3), msg.wParam, msg.Description);

        CM_DROPGOLD: begin
          if msg.lparam1 > 0 then begin
            UserDropGold(msg.lparam1);
          end;
        end;

        CM_TEST: SendDefMessage(SM_TEST, 0, 0, 0, 0, '');

        CM_GROUPMODE: begin
          if msg.lparam2 = 0 then
            DenyGroup  //AllowGroup := FALSE;
          else
            AllowGroup := True;
          //상태 보내여함..
          if AllowGroup then
            SendDefMessage(SM_GROUPMODECHANGED, 0, 1, 0, 0, '')
          else
            SendDefMessage(SM_GROUPMODECHANGED, 0, 0, 0, 0, '');
        end;

        // 아이템 업그레이드 by sonmg...
        CM_UPGRADEITEM: begin
          try
            //SeedName과 JewelryName분리
            strupgrade := GetValidStr3(msg.Description, msg.Description, ['/']);
            //업그레이드
            CmdUpgradeItem(msg.Description, strupgrade, msg.lparam1,
              MakeLong(msg.lparam2, msg.lparam3), 0);
          except
            MainOutMessage('UPGRADE ERROR');
          end;
        end;
        CM_CREATEGROUP: ServerGetCreateGroup(Trim(msg.Description));
        CM_CREATEGROUPREQ_OK: ServerGetCreateGroupRequestOk
          (Trim(msg.Description));
        CM_CREATEGROUPREQ_FAIL: ServerGetCreateGroupRequestFail;
        CM_ADDGROUPMEMBER: ServerGetAddGroupMember(Trim(msg.Description));
        CM_ADDGROUPMEMBERREQ_OK: ServerGetAddGroupMemberRequestOk(
            Trim(msg.Description));
        CM_ADDGROUPMEMBERREQ_FAIL: ServerGetAddGroupMemberRequestFail;
        CM_DELGROUPMEMBER: ServerGetDelGroupMember(Trim(msg.Description));

        RM_GUILDAGITDEALTRY, // 장원거래시도(sonmg)
        CM_DEALTRY: ServerGetDealTry(Trim(msg.Description));
        CM_DEALADDITEM: ServerGetDealAddItem(msg.lparam1,
            msg.wparam, msg.Description);
        CM_DEALDELITEM: ServerGetDealDelItem(msg.lparam1, msg.Description);
        CM_DEALCANCEL: ServerGetDealCancel;
        CM_DEALCHGGOLD: ServerGetDealChangeGold(msg.lparam1);
        CM_DEALEND: ServerGetDealEnd;

        CM_USERTAKEBACKSTORAGEITEM: ServerGetTakeBackStorageItem
          (msg.lparam1, MakeLong(msg.lparam2, msg.lparam3), msg.wparam, msg.Description);

        CM_WANTMINIMAP: ServerGetWantMiniMap;

        CM_USERMAKEDRUGITEM: ServerGetMakeDrug(msg.lparam1, msg.Description);

        // 아이템 제조
        CM_USERMAKEITEMSEL: ServerGetMakeItemSel(msg.lparam1, msg.Description);
        CM_USERMAKEITEM: ServerGetMakeItem(msg.lparam1, msg.Description);

        // 카운트 아이템 통합.
        CM_ITEMSUMCOUNT: ServerGetSumCountItem(msg.lparam1,
            MakeLong(msg.lparam2, msg.lparam3), msg.Description);

        CM_QUERYUSERSTATE: ServerGetQueryUserState(TCreature(msg.lparam1){cret},
            msg.lparam2{x}, msg.lparam3{y});

        CM_OPENGUILDDLG: ServerGetOpenGuildDlg;

        CM_GUILDHOME: ServerGetGuildHome;

        CM_GUILDMEMBERLIST: ServerGetGuildMemberList;

        CM_GUILDADDMEMBER: ServerGetGuildAddMember(msg.Description);

        CM_GUILDDELMEMBER: ServerGetGuildDelMember(msg.Description);

        CM_GUILDUPDATENOTICE: ServerGetGuildUpdateNotice(msg.Description);

        CM_GUILDUPDATERANKINFO: ServerGetGuildUpdateRanks(msg.Description);

        CM_GUILDMAKEALLY: ServerGetGuildMakeAlly;  //상대편 문주와 마주보고

        CM_GUILDBREAKALLY: ServerGetGuildBreakAlly(msg.Description);


        CM_SPEEDHACKUSER: MainOutMessage('[Using hacking program(client)] ' +
            UserName); //speedhack 유저 로그를 남긴다.

        CM_ADJUST_BONUS: ServerGetAdjustBonus(msg.lparam1, msg.Description);

        CM_FRIEND_ADD: begin

          DefMsg.Recog  := integer(msg.Sender);
          DefMsg.Ident  := msg.Ident;
          DefMsg.Param  := msg.lParam1;
          DefMsg.Tag    := msg.lParam2;
          DefMsg.Series := msg.lParam3;

          UserMgrEngine.ExternSendMsg(stInterServer, ServerIndex,
            GateIndex, UserGateIndex, userhandle, UserName, DefMsg, msg.description);
        end;
        // 연인사제
        CM_LM_REQUEST: ServerGetRelationRequest(msg.lparam1, msg.lparam2);
        CM_LM_OPTION: ServerGetRelationOptionChange(msg.lparam1, msg.lparam2);
        CM_LM_DELETE: ServerGetRelationDelete(msg.lparam1, msg.Description);
        CM_LM_DELETE_REQ_OK: ServerGetRelationDeleteRequestOk(
            msg.lparam1, msg.Description);
        CM_LM_DELETE_REQ_FAIL: ServerGetRelationDeleteRequestFail(
            msg.lparam1, msg.Description);
        // 위탁판매 UserMarket
        CM_MARKET_LIST: ServerGetMarketList(
            TCreature(msg.lparam1), msg.lParam2, msg.description);
        CM_MARKET_SELL: ServerGetMarketSell(
            TCreature(msg.lparam1), msg.wParam, MakeLong(msg.lparam2, msg.lparam3),
            msg.description);
        CM_MARKET_BUY: ServerGetMarketBuy(
            TCreature(msg.lparam1), MakeLong(msg.lparam2, msg.lparam3));
        CM_MARKET_CANCEL: ServerGetMarketCancel(
            TCreature(msg.lparam1), MakeLong(msg.lparam2, msg.lparam3));
        CM_MARKET_GETPAY: ServerGetMarketGetPay(
            TCreature(msg.lparam1), MakeLong(msg.lparam2, msg.lparam3));
        CM_MARKET_CLOSE: ServerGetMarketClose;

        // 장원 목록
        CM_GUILDAGITLIST: ServerGetGuildAgitList(msg.lparam1);
        CM_GUILDAGIT_TAG_ADD: begin
          if ServerGetGuildAgitTag(TCreature(msg.Sender), msg.description) then
          begin
            DefMsg.Recog  := integer(msg.Sender);
            DefMsg.Ident  := CM_TAG_ADD_DOUBLE;
            DefMsg.Param  := msg.lParam1;
            DefMsg.Tag    := msg.lParam2;
            DefMsg.Series := msg.lParam3;

            UserMgrEngine.ExternSendMsg(stInterServer, ServerIndex,
              GateIndex, UserGateIndex, userhandle, UserName, DefMsg, msg.description);
          end;
        end;
        // 장원게시판
        CM_GABOARD_LIST: ServerGetGaBoardList(msg.lparam1);
        CM_GABOARD_READ: ServerGetGaBoardRead(msg.description);
        CM_GABOARD_ADD: ServerGetGaBoardAdd(
            msg.lparam1{글종류}, msg.lparam2, msg.description);
        CM_GABOARD_DEL: ServerGetGaBoardDel(
            msg.lparam2, msg.description{글번호});
        CM_GABOARD_EDIT: ServerGetGaBoardEdit(
            msg.lparam2, msg.description{글번호});
        CM_GABOARD_NOTICE_CHECK: ServerGetGaBoardNoticeCheck;
        // 장원꾸미기
        CM_DECOITEM_BUY: ServerGetDecoItemBuy(msg.Ident,
            msg.lparam1{merchant}, MakeLong(msg.lparam2, msg.lparam3), msg.Description);

        {-------------------------------------------------------------}

        RM_LM_DBWANTLIST: ServerSetRelationDBWantList(msg.description);
        RM_LM_DBADD: ServerSetRelationDBAdd(msg.description);
        RM_LM_DBEDIT: ServerSetRelationDBEdit(msg.description);
        RM_LM_DBDELETE: ServerSetRelationDBDelete(msg.description);
        RM_LM_DBGETLIST: ServerGetRelationDBGetList(msg.description);
        RM_LM_LOGOUT: ServerGetLoverLogout;
        {-------------------------------------------------------------}
        //서버에서 서버로 보내는 메세지, 지연 처리 경우

        RM_MAKE_SLAVE: begin
          if msg.lparam1 <> 0 then begin
            RmMakeSlaveProc(PTSlaveInfo(msg.lparam1));
            Dispose(PTSlaveInfo(msg.lparam1));
          end;
        end;

        {-------------------------------------------------------------}
        //서버에서 보내는 메세지 처리
        RM_TAG_ALARM: // 쪽지 왔음 알림
        begin
          SendDefMessage(SM_TAG_ALARM, 0, msg.lParam1, 0, 0, '');
        end;
        RM_LOGON: begin
          if PEnvir.Darkness then
            n := BRIGHT_NIGHT//1
          else if PEnvir.Dawn then
            n := BRIGHT_DAWN//2  //새벽추가
          else
            case Bright of
              1: n := BRIGHT_DAY;  //0;  //낮
              3: n := BRIGHT_NIGHT;//1;  //밤
              else
                n := BRIGHT_DAWN;//2;  //새벽,저녁
            end;
          if PEnvir.DayLight then
            n := 0;

          //에러 표시
          if (n > 256) or (PEnvir.AutoAttack > 256) then
            MainOutMessage(
              '[Caution!] Over size of BYTE in TUserHuman.Operate(RM_LOGON)');

          //                  Def := MakeDefaultMsg (SM_NEWMAP, integer(self), CX, CY, n);
          Def := MakeDefaultMsg(SM_NEWMAP, integer(self), CX,
            CY, MakeWord(LOBYTE(n), LOBYTE(PEnvir.AutoAttack)));
          SendSocket(@Def, EncodeString(PEnvir.GetGuildAgitRealMapName));

          SendLogon;
                  {Def := MakeDefaultMsg (SM_LOGON, Integer(self), CX, CY, MakeWord(Dir,Light));
                  wl.lParam1 := Feature;
                  wl.lParam2 := CharStatus;
                  if AllowGroup then wl.lTag1 := MakeLong(MakeWord(1, 0), 0)
                  else wl.lTag1 := 0;
                  wl.lTag2 := 0;
                  SendSocket (@Def, EncodeBuffer (@wl, sizeof(TMessageBodyWL)));}

          //이름보냄
          GetQueryUserName(self, CX, CY);

          //지역 상태 표시
          SendAreaState;

          //맵 이름 보내기
          SendDefMessage(SM_MAPDESCRIPTION, 0, 0, 0, 0, PEnvir.MapTitle);

          //클라이언트 체크섬 보내기
          Def      := MakeDefaultMsg(SM_CHECK_CLIENTVALID,
            ClientCheckSumValue1, Loword(ClientCheckSumValue2),
            Hiword(ClientCheckSumValue2), 0);
          smsg.Ident := Loword(ClientCheckSumValue3);
          smsg.msg := Hiword(ClientCheckSumValue3);
          SendSocket(@Def, EncodeBuffer(@smsg, sizeof(TShortMessage)));
        end;
        RM_CHANGEMAP: begin
          //NoGroup 맵속성이 있는 맵일 경우 그룹 해체(sonmg 2004/10/13)
          if PEnvir.NoGroup then begin
            try
              //내가 그룹짱이 아니면...
              if GroupOwner <> nil then begin
                GroupOwner.DelGroupMember(self);
              end else begin
                //내가 그룹 짱이면...
                DelGroupMember(self);
              end;
            except
            end;
          end;

          if PEnvir.Darkness then
            n := BRIGHT_NIGHT//1
          else if PEnvir.Dawn then
            n := BRIGHT_DAWN//2  //새벽추가
          else
            case Bright of
              1: n := BRIGHT_DAY;  //0;  //낮
              3: n := BRIGHT_NIGHT;//1;  //밤
              else
                n := BRIGHT_DAWN;//2;  //새벽,저녁
            end;
          if PEnvir.DayLight then
            n := 0;

          //에러 표시
          if (n > 256) or (PEnvir.AutoAttack > 256) then
            MainOutMessage(
              '[Caution!] Over size of BYTE in TUserHuman.Operate(RM_CHANGEMAP)');

          SendDefMessage(SM_CHANGEMAP, integer(self), CX,
            CY, MakeWord(LOBYTE(n), LOBYTE(PEnvir.AutoAttack)), msg.Description);
          //지역 상태 표시
          SendAreaState;

          SendDefMessage(SM_MAPDESCRIPTION, 0, 0, 0, 0, PEnvir.MapTitle);
        end;
        RM_DAYCHANGING: begin
          if PEnvir.Darkness then
            n := BRIGHT_NIGHT//1
          else if PEnvir.Dawn then
            n := BRIGHT_DAWN//2  //새벽추가
          else
            case Bright of
              1: n := BRIGHT_DAY;  //0;  //낮
              3: n := BRIGHT_NIGHT;//1;  //밤
              else
                n := BRIGHT_DAWN;//2;  //새벽,저녁
            end;
          if PEnvir.DayLight then
            n := 0;
          Def := MakeDefaultMsg(SM_DAYCHANGING, 0, Bright, n, 0);
          SendSocket(@Def, '');
        end;

        RM_ABILITY: begin
          Def := MakeDefaultMsg(SM_ABILITY, Gold, Job, 0, 0);
          SendSocket(@Def, EncodeBuffer(@WAbil, sizeof(TAbility)));
        end;

        RM_SUBABILITY: begin
          SendDefMessage(SM_SUBABILITY, MakeLong(MakeWord(AntiMagic, 0), 0),
            MakeWord(AccuracyPoint, SpeedPoint), MakeWord(AntiPoison, PoisonRecover),
            MakeWord(HealthRecover, SpellRecover), '');
        end;

        RM_MYSTATUS: begin
          SendDefMessage(SM_MYSTATUS, 0, GetHungryState, 0, 0, '');
          //배고픔 등..
        end;

        RM_ADJUST_BONUS: begin
          ServerSendAdjustBonus;
        end;

        RM_HEALTHSPELLCHANGED: begin
          Def := MakeDefaultMsg(SM_HEALTHSPELLCHANGED,
            integer(msg.Sender), TCreature(msg.Sender).WAbil.HP,
            TCreature(msg.Sender).WAbil.MP, TCreature(
            msg.Sender).WAbil.MaxHP);
          SendSocket(@Def, '');
        end;

        RM_MOVEFAIL: begin
          Def := MakeDefaultMsg(SM_MOVEFAIL, integer(self), self.CX,
            self.CY, self.Dir);
          cdesc.Feature := Feature;
          cdesc.Status := CharStatus;
          SendSocket(@Def, EncodeBuffer(@cdesc, sizeof(TCharDesc)));
        end;


        RM_TURN, RM_PUSH, RM_RUSH, RM_RUSHKUNG: begin
          if (msg.Sender <> self) or (msg.Ident = RM_PUSH) or
            (msg.Ident = RM_RUSH) or (msg.Ident = RM_RUSHKUNG) then begin
            //msg.wParam : 방향
            case msg.Ident of
              RM_PUSH: Def :=
                  MakeDefaultMsg(SM_BACKSTEP, integer(msg.Sender),
                  msg.lParam1{x}, msg.lParam2{y},
                  MakeWord(msg.wParam{dir}, TCreature(msg.Sender).Light));
              RM_RUSH: Def :=
                  MakeDefaultMsg(SM_RUSH, integer(msg.Sender),
                  msg.lParam1{x}, msg.lParam2{y},
                  MakeWord(msg.wParam{dir}, TCreature(msg.Sender).Light));
              RM_RUSHKUNG: Def :=
                  MakeDefaultMsg(SM_RUSHKUNG, integer(msg.Sender),
                  msg.lParam1{x}, msg.lParam2{y},
                  MakeWord(msg.wParam{dir}, TCreature(msg.Sender).Light))
              else
                Def :=
                  MakeDefaultMsg(SM_TURN, integer(msg.Sender),
                  msg.lParam1{x}, msg.lParam2{y},
                  MakeWord(msg.wParam{dir}, TCreature(msg.Sender).Light));
            end;
            cdesc.Feature := TCreature(msg.Sender).GetRelFeature(self);
            cdesc.Status := TCreature(msg.Sender).CharStatus;
            str := EncodeBuffer(@cdesc, sizeof(TCharDesc));
            n   := GetThisCharColor(TCreature(msg.Sender));
            if msg.Description <> '' then
              str := str + EncodeString(msg.Description + '/' +  //캐릭 이름
                IntToStr(n) //이름색깔
                );

            SendSocket(@Def, str);
          end;
        end;

        RM_WALK: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_WALK, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, MakeWord(
              msg.wParam{dir}, TCreature(msg.Sender).Light));
            cdesc.Feature := TCreature(msg.Sender).GetRelFeature(self);
            cdesc.Status := TCreature(msg.Sender).CharStatus;
            SendSocket(@Def, EncodeBuffer(@cdesc, sizeof(TCharDesc)));
          end;
        end;

        RM_RUN: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_RUN, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, MakeWord(
              msg.wParam{dir}, TCreature(msg.Sender).Light));
            cdesc.Feature := TCreature(msg.Sender).GetRelFeature(self);
            cdesc.Status := TCreature(msg.Sender).CharStatus;
            SendSocket(@Def, EncodeBuffer(@cdesc, sizeof(TCharDesc)));
          end;
        end;


        RM_BUTCH: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_BUTCH, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, '');
          end;
        end;

        RM_HIT: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_HIT, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, '');
          end;
        end;

        RM_POWERHIT: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_POWERHIT, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, '');
          end;
        end;

        RM_slashhit: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_slashhit, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, '');
          end;
        end;

        RM_LONGHIT: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_LONGHIT, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, '');
          end;
        end;

        RM_WIDEHIT: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_WIDEHIT, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, '');
          end;
        end;

        //Assassin Skill 2
        RM_WIDEHIT2: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_WIDEHIT2, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, '');
          end;
        end;
        // 2003/03/15 신규무공
        RM_CROSSHIT: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_CROSSHIT, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, '');
          end;
        end;
        RM_TWINHIT: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_TWINHIT, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, '');
          end;
        end;

        RM_HEAVYHIT: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_HEAVYHIT, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, msg.Description);
          end;
        end;

        RM_BIGHIT: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_BIGHIT, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, '');
          end;
        end;

        RM_FIREHIT: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_FIREHIT, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, '');
          end;
        end;
        RM_WINDCUT: begin
          //                  if msg.Sender <> self then begin
          Def := MakeDefaultMsg(SM_WINDCUT, integer(msg.Sender),
            msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
          SendSocket(@Def, '');
          //                  end;
        end;
        //신규무공(2004/06/23)
        RM_PULLMON: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_PULLMON, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, '');
          end;
        end;
        RM_SUCKBLOOD: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_SUCKBLOOD, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, msg.wParam{Dir});
            SendSocket(@Def, '');
          end;
        end;

        RM_SPELL: begin
          if msg.Sender <> self then begin
            Def := MakeDefaultMsg(SM_SPELL, integer(msg.Sender),
              msg.lparam1{tx}, msg.lparam2{ty}, msg.wParam{effect});
            SendSocket(@Def, IntToStr(msg.lparam3){magicid});
          end;
        end;
        RM_MAGICFIRE: begin
          Def := MakeDefaultMsg(SM_MAGICFIRE, integer(msg.Sender),
            Loword(msg.lparam2){x}, Hiword(msg.lparam2){y}, msg.lparam1);
          SendSocket(@Def, EncodeBuffer(@(msg.lparam3), sizeof(integer)));
        end;
        RM_MAGICFIRE_FAIL: begin
          SendDefMessage(SM_MAGICFIRE_FAIL, integer(msg.Sender), 0, 0, 0, '');
        end;

        RM_STRUCK,
        RM_STRUCK_MAG: begin
          if msg.wParam > 0 then begin //damage
            if msg.Sender = self then begin //내가 맞은 것만.
              if TCreature(msg.lparam3) <> nil then begin
                if TCreature(msg.lparam3).RaceServer = RC_USERHUMAN then begin
                  //정당방어를 위한 기록..
                  AddPkHiter(TCreature(msg.lparam3));
                end;
                SetLastHiter(TCreature(msg.lparam3));
              end;

              //빨갱이들은 맞아도 재접 못함
              if PKLevel >= 2 then
                HumStruckTime := GetTickCount;

              //성의 문원을 때린 경우, 궁병이 공격함
              if UserCastle.IsOurCastle(TGuild(MyGuild)) then begin
                if msg.lparam3 <> 0 then begin
                  TCreature(msg.lparam3).BoCrimeforCastle := True;
                  TCreature(msg.lparam3).CrimeforCastleTime := GetTickCount;
                end;
              end;

              HealthTick := 0; //맞으면 회복이 안된다.
              SpellTick  := 0;
              Dec(PerHealth);
              Dec(PerSpell);
            end;
            if msg.Sender <> nil then begin
              Def      :=
                MakeDefaultMsg(SM_STRUCK, integer(msg.Sender),
                TCreature(msg.Sender).WAbil.HP,
                TCreature(msg.Sender).WAbil.MaxHP, msg.wparam);
              wl.lParam1 := TCreature(msg.Sender).GetRelFeature(self);
              wl.lParam2 := TCreature(msg.Sender).CharStatus;
              wl.lTag1 := msg.lparam3;  //때린놈
            end;
            if msg.Ident = RM_STRUCK_MAG then
              wl.lTag2 := 1     //마법으로 맞는 사운드 효과
            else
              wl.lTag2 := 0;
            SendSocket(@Def, EncodeBuffer(@wl, sizeof(TMessageBodyWL)));
          end;
        end;

        RM_DEATH: begin
          if TCreature(msg.Sender).RaceServer <> RC_CLONE then begin
            if msg.lparam3 = 1 then
              Def := MakeDefaultMsg(SM_NOWDEATH, integer(msg.Sender),
                msg.lparam1{x}, msg.lparam2{y}, msg.wparam{Dir})
            else
              Def := MakeDefaultMsg(SM_DEATH, integer(msg.Sender),
                msg.lparam1{x}, msg.lparam2{y}, msg.wparam{Dir});
            cdesc.Feature := TCreature(msg.Sender).GetRelFeature(self);
            cdesc.Status := TCreature(msg.Sender).CharStatus;
            SendSocket(@Def, EncodeBuffer(@cdesc, sizeof(TCharDesc)));
          end;
        end;
        RM_SKELETON: begin
          Def := MakeDefaultMsg(SM_SKELETON, integer(msg.Sender),
            msg.lparam1{x}, msg.lparam2{y}, msg.wparam{Dir});
          cdesc.Feature := TCreature(msg.Sender).GetRelFeature(self);
          cdesc.Status := TCreature(msg.Sender).CharStatus;
          SendSocket(@Def, EncodeBuffer(@cdesc, sizeof(TCharDesc)));
        end;
        RM_ALIVE: begin
          Def := MakeDefaultMsg(SM_ALIVE, integer(msg.Sender),
            msg.lparam1{x}, msg.lparam2{y}, msg.wparam{Dir});
          cdesc.Feature := TCreature(msg.Sender).GetRelFeature(self);
          cdesc.Status := TCreature(msg.Sender).CharStatus;
          SendSocket(@Def, EncodeBuffer(@cdesc, sizeof(TCharDesc)));
        end;
        RM_CHANGEFACE: begin
          //msg.lparam1 변신전
          //msg.lparam2 변신후
          if (msg.lparam1 <> 0) and (msg.lparam2 <> 0) then begin
            Def := MakeDefaultMsg(SM_CHANGEFACE, msg.lparam1,
              Loword(msg.lparam2), Hiword(msg.lparam2), 0);
            cdesc.Feature := TCreature(msg.lparam2).GetRelFeature(self);
            cdesc.Status := TCreature(msg.lparam2).CharStatus;
            SendSocket(@Def, EncodeBuffer(@cdesc, sizeof(TCharDesc)));
          end;
        end;

        RM_RECONNECT: begin
          SoftClosed := True;  //재접을 위해서 접속종료함.
          SendDefMessage(SM_RECONNECT, 0, 0, 0, 0, msg.Description);
        end;

        RM_SPACEMOVE_SHOW,
        RM_SPACEMOVE_SHOW2: begin
          //msg.wParam : 방향
          if msg.Ident = RM_SPACEMOVE_SHOW then
            Def := MakeDefaultMsg(SM_SPACEMOVE_SHOW, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, MakeWord(msg.wParam{dir},
              TCreature(msg.Sender).Light))
          else
            Def := MakeDefaultMsg(SM_SPACEMOVE_SHOW2, integer(msg.Sender),
              msg.lParam1{x}, msg.lParam2{y}, MakeWord(msg.wParam{dir},
              TCreature(msg.Sender).Light));
          cdesc.Feature := TCreature(msg.Sender).GetRelFeature(self);
          cdesc.Status := TCreature(msg.Sender).CharStatus;
          str := EncodeBuffer(@cdesc, sizeof(TCharDesc));
          n   := GetThisCharColor(TCreature(msg.Sender));
          if msg.Description <> '' then
            str := str + EncodeString(msg.Description + '/' + IntToStr(n));
          //캐릭 이름 + 이름색깔
          SendSocket(@Def, str);
        end;

        RM_SPACEMOVE_HIDE,
        RM_SPACEMOVE_HIDE2: begin
          if msg.Ident = RM_SPACEMOVE_HIDE then
            Def := MakeDefaultMsg(SM_SPACEMOVE_HIDE,
              integer(msg.Sender), 0, 0, 0)
          else
            Def := MakeDefaultMsg(SM_SPACEMOVE_HIDE2,
              integer(msg.Sender), 0, 0, 0);
          SendSocket(@Def, '');
        end;

        RM_DISAPPEAR: begin
          Def := MakeDefaultMsg(SM_DISAPPEAR, integer(msg.Sender), 0, 0, 0);
          SendSocket(@Def, '');
        end;

        RM_DIGUP: begin
          Def      := MakeDefaultMsg(SM_DIGUP, integer(msg.Sender),
            msg.lparam1, msg.lparam2, MakeWord(msg.wParam{dir},
            TCreature(msg.Sender).Light));
          wl.lParam1 := TCreature(msg.Sender).GetRelFeature(self);
          wl.lParam2 := TCreature(msg.Sender).CharStatus;
          wl.lTag1 := msg.lparam3;  //이벤트
          wl.lTag1 := 0;
          str      := EncodeBuffer(@wl, sizeof(TMessageBodyWL));
          SendSocket(@Def, str);
        end;
        RM_DIGDOWN: begin
          Def := MakeDefaultMsg(SM_DIGDOWN, integer(msg.Sender),
            msg.lparam1, msg.lparam2, msg.wParam);
          SendSocket(@Def, '');
        end;
        RM_SHOWEVENT: begin
          smsg.Ident := Hiword(msg.lParam2); //EventParam
          smsg.msg := 0;
          Def := MakeDefaultMsg(SM_SHOWEVENT, integer(msg.lparam1),
            msg.wParam, Loword(msg.lParam2), msg.lParam3);
          str := EncodeBuffer(@smsg, sizeof(TShortMessage));
          SendSocket(@Def, str);
        end;
        RM_HIDEEVENT: begin
          SendDefMessage(SM_HIDEEVENT, integer(msg.lparam1),
            msg.wParam, msg.lParam2, msg.lParam3, '');
        end;

        RM_FLYAXE: begin
          if msg.lparam3 <> 0 then begin
            mbw.Param1 := TCreature(msg.lparam3).CX;
            mbw.Param2 := TCreature(msg.lparam3).CY;
            mbw.Tag1 := Loword(msg.lparam3);
            mbw.Tag2 := Hiword(msg.lparam3);
            Def := MakeDefaultMsg(SM_FLYAXE, integer(msg.Sender),
              msg.lparam1, msg.lparam2, msg.wParam{Dir});
            str := EncodeBuffer(@mbw, sizeof(TMessageBodyW));
            SendSocket(@Def, str);
          end;
        end;

        RM_FLYAXE_2: begin
          if msg.lparam3 <> 0 then begin
            mbw.Param1 := TCreature(msg.lparam3).CX;
            mbw.Param2 := TCreature(msg.lparam3).CY;
            mbw.Tag1 := Loword(msg.lparam3);
            mbw.Tag2 := Hiword(msg.lparam3);
            Def := MakeDefaultMsg(SM_FLYAXE_2, integer(msg.Sender),
              msg.lparam1, msg.lparam2, msg.wParam{Dir});
            str := EncodeBuffer(@mbw, sizeof(TMessageBodyW));
            SendSocket(@Def, str);
          end;
        end;

        RM_LIGHTING: begin
          if msg.lparam3 <> 0 then begin
            wl.lParam1 := TCreature(msg.lparam3).CX;
            wl.lParam2 := TCreature(msg.lparam3).CY;
          end;
          wl.lTag1 := msg.lparam3;
          wl.lTag2 := msg.wparam; //마법 번호
          Def      := MakeDefaultMsg(SM_LIGHTING, integer(msg.Sender),
            msg.lparam1, msg.lparam2, TCreature(msg.Sender).Dir);
          str      := EncodeBuffer(@wl, sizeof(TMessageBodyWL));
          SendSocket(@Def, str);
        end;

        RM_LIGHTING_1: begin
          if msg.lparam3 <> 0 then begin
            wl.lParam1 := TCreature(msg.lparam3).CX;
            wl.lParam2 := TCreature(msg.lparam3).CY;
          end;
          wl.lTag1 := msg.lparam3;
          wl.lTag2 := msg.wparam; //마법 번호
          Def      := MakeDefaultMsg(SM_LIGHTING_1, integer(msg.Sender),
            msg.lparam1, msg.lparam2, TCreature(msg.Sender).Dir);
          str      := EncodeBuffer(@wl, sizeof(TMessageBodyWL));
          SendSocket(@Def, str);
        end;

        RM_LIGHTING_2: begin
          if msg.lparam3 <> 0 then begin
            wl.lParam1 := TCreature(msg.lparam3).CX;
            wl.lParam2 := TCreature(msg.lparam3).CY;
          end;
          wl.lTag1 := msg.lparam3;
          wl.lTag2 := msg.wparam; //마법 번호
          Def      := MakeDefaultMsg(SM_LIGHTING_2, integer(msg.Sender),
            msg.lparam1, msg.lparam2, TCreature(msg.Sender).Dir);
          str      := EncodeBuffer(@wl, sizeof(TMessageBodyWL));
          SendSocket(@Def, str);
        end;

        RM_DRAGON_FIRE1: begin
          if msg.lparam3 <> 0 then begin
            wl.lParam1 := TCreature(msg.lparam3).CX;
            wl.lParam2 := TCreature(msg.lparam3).CY;
          end;
          wl.lTag1 := msg.lparam3;
          wl.lTag2 := msg.wparam; //마법 번호
          Def      := MakeDefaultMsg(SM_DRAGON_FIRE1, integer(msg.Sender),
            msg.lparam1, msg.lparam2, TCreature(msg.Sender).Dir);
          str      := EncodeBuffer(@wl, sizeof(TMessageBodyWL));
          SendSocket(@Def, str);
        end;
        RM_DRAGON_FIRE2: begin
          if msg.lparam3 <> 0 then begin
            wl.lParam1 := TCreature(msg.lparam3).CX;
            wl.lParam2 := TCreature(msg.lparam3).CY;
          end;
          wl.lTag1 := msg.lparam3;
          wl.lTag2 := msg.wparam; //마법 번호
          Def      := MakeDefaultMsg(SM_DRAGON_FIRE2, integer(msg.Sender),
            msg.lparam1, msg.lparam2, TCreature(msg.Sender).Dir);
          str      := EncodeBuffer(@wl, sizeof(TMessageBodyWL));
          SendSocket(@Def, str);
        end;
        RM_DRAGON_FIRE3: begin
          if msg.lparam3 <> 0 then begin
            wl.lParam1 := TCreature(msg.lparam3).CX;
            wl.lParam2 := TCreature(msg.lparam3).CY;
          end;
          wl.lTag1 := msg.lparam3;
          wl.lTag2 := msg.wparam; //마법 번호
          Def      := MakeDefaultMsg(SM_DRAGON_FIRE3, integer(msg.Sender),
            msg.lparam1, msg.lparam2, TCreature(msg.Sender).Dir);
          str      := EncodeBuffer(@wl, sizeof(TMessageBodyWL));
          SendSocket(@Def, str);
        end;

        RM_NORMALEFFECT: begin
          SendDefMessage(SM_NORMALEFFECT,
            integer(msg.Sender),  //recog
            msg.lparam1, //xx
            msg.lparam2, //yy
            msg.lparam3, //효과 종류
            '');
        end;
        RM_LOOPNORMALEFFECT: begin
          SendDefMessage(SM_LOOPNORMALEFFECT,
            integer(msg.Sender),  //recog
            msg.lparam1, //시간(초)
            msg.lparam2, //사용안함.
            msg.lparam3, //효과 종류
            '');
        end;

        RM_OPENHEALTH: begin
          SendDefMessage(SM_OPENHEALTH,
            integer(msg.Sender),
            TCreature(msg.Sender).WAbil.HP,
            TCreature(msg.Sender).WAbil.MaxHP,
            0, '');
        end;

        RM_CLOSEHEALTH: begin
          SendDefMessage(SM_CLOSEHEALTH, integer(msg.Sender), 0, 0, 0, '');
        end;
        RM_INSTANCEHEALGUAGE: begin
          SendDefMessage(SM_INSTANCEHEALGUAGE, integer(msg.Sender),
            TCreature(msg.Sender).WAbil.HP,
            TCreature(msg.Sender).WAbil.MaxHP,
            0, '');
        end;

        RM_BREAKWEAPON: begin
          SendDefMessage(SM_BREAKWEAPON, integer(msg.Sender), 0, 0, 0, '');
        end;
        // 2003/03/04 탐기
        RM_GROUPPOS:    // gadget
        begin
          Def := MakeDefaultMsg(SM_GROUPPOS, integer(msg.Sender),
            msg.lParam1 {x}, msg.lParam2 {y}, msg.lParam3);
          SendSocket(@Def, '');
        end;
        RM_CHANGENAMECOLOR: begin
          //색변경..
          //나와의 관계에 따라서 색이 다르게 보인다.
          n := GetThisCharColor(TCreature(msg.Sender));
          SendDefMessage(SM_CHANGENAMECOLOR, integer(msg.Sender), n, 0, 0, '');
        end;
        RM_USERNAME:  //서버에서 가제적으로 이름을 보내려고 할때
        begin
          Def := MakeDefaultMsg(SM_USERNAME, integer(msg.Sender),
            GetThisCharColor(TCreature(msg.Sender)), 0, 0);
          SendSocket(@Def, EncodeString(msg.Description));
        end;

        RM_WINEXP: begin
          Def := MakeDefaultMsg(SM_WINEXP, Abil.Exp,
            msg.lparam1{얻은경험치}, 0, 0);
          SendSocket(@Def, '');
        end;

        RM_LEVELUP: begin
          Def := MakeDefaultMsg(SM_LEVELUP, Abil.Exp, Abil.Level, 0, 0);
          SendSocket(@Def, '');
          Def := MakeDefaultMsg(SM_ABILITY, Gold, Job, Gold, 0);
          SendSocket(@Def, EncodeBuffer(@WAbil, sizeof(TAbility)));
          SendDefMessage(SM_SUBABILITY, MakeLong(MakeWord(AntiMagic, 0), 0),
            MakeWord(AccuracyPoint, SpeedPoint), MakeWord(AntiPoison, PoisonRecover),
            MakeWord(HealthRecover, SpellRecover), '');
        end;

        RM_HEAR,
        RM_CRY,
        RM_WHISPER,
        RM_GMWHISPER,
        RM_LM_WHISPER,
        RM_SYSMESSAGE,
        RM_SYSMESSAGE2,
        RM_SYSMESSAGE3,
        RM_SYSMSG_BLUE,
        RM_SYSMSG_PINK,
        RM_SYSMSG_GREEN,
        RM_SYSMSG_REMARK,
        RM_GROUPMESSAGE,
        RM_GUILDMESSAGE,
        RM_MERCHANTSAY: begin
          case msg.Ident of
            RM_HEAR: Def    :=
                MakeDefaultMsg(SM_HEAR, integer(msg.Sender), MakeWord(0, 255), 0, 1);
            RM_CRY: Def     :=
                MakeDefaultMsg(SM_HEAR, integer(msg.Sender), MakeWord(0, 151), 0, 1);
            RM_WHISPER: Def :=
                MakeDefaultMsg(SM_WHISPER, integer(msg.Sender),
                MakeWord(252, 255), 0, 1);
            RM_GMWHISPER: Def :=
                MakeDefaultMsg(SM_WHISPER, integer(msg.Sender),
                MakeWord(249, 255), 0, 1);
            RM_LM_WHISPER: Def :=
                MakeDefaultMsg(SM_WHISPER, integer(msg.Sender),
                MakeWord(253{70}, 255), 0, 1);
            RM_SYSMESSAGE: Def :=
                MakeDefaultMsg(SM_SYSMESSAGE, integer(msg.Sender),
                MakeWord(255, 56), 0, 1);
            RM_SYSMESSAGE2: Def :=
                MakeDefaultMsg(SM_SYSMESSAGE, integer(msg.Sender),
                MakeWord(219, 255), 0, 1);
            RM_SYSMESSAGE3: Def :=
                MakeDefaultMsg(SM_SYSMESSAGE, integer(msg.Sender),
                MakeWord(56, 255), 0, 1);
            RM_SYSMSG_BLUE: Def :=
                MakeDefaultMsg(SM_SYSMESSAGE, integer(msg.Sender),
                MakeWord(255, 252), 0, 1);
            RM_SYSMSG_PINK: Def :=
                MakeDefaultMsg(SM_SYSMESSAGE, integer(msg.Sender),
                MakeWord(255, 253), 0, 1);
            //연인축하메시지
            RM_SYSMSG_GREEN: Def :=
                MakeDefaultMsg(SM_SYSMESSAGE, integer(msg.Sender),
                MakeWord(255, 220), 0, 1);
            RM_SYSMSG_REMARK: Def :=
                MakeDefaultMsg(SM_SYSMSG_REMARK, integer(msg.Sender),
                MakeWord(219, 255), 0, 1);
            RM_GROUPMESSAGE: Def :=
                MakeDefaultMsg(SM_SYSMESSAGE, integer(msg.Sender),
                MakeWord(196, 255), 0, 1);
            //                     RM_GUILDMESSAGE: Def := MakeDefaultMsg (SM_GUILDMESSAGE, integer(msg.sender), MakeWord(212, 255), 0, 1);
            RM_GUILDMESSAGE: Def :=
                MakeDefaultMsg(SM_GUILDMESSAGE, integer(msg.Sender),
                MakeWord(211, 255), 0, 1);
            RM_MERCHANTSAY: Def :=
                MakeDefaultMsg(SM_MERCHANTSAY, integer(msg.Sender), 0, 0, 1);
          end;
          str := EncodeString(msg.description);
          SendSocket(@Def, str);
        end;
        RM_MERCHANTDLGCLOSE: begin
          SendDefMessage(SM_MERCHANTDLGCLOSE, msg.lparam1, 0, 0, 0, '');
        end;
        RM_SENDGOODSLIST: begin
          SendDefMessage(SM_SENDGOODSLIST, msg.lparam1{merchant id},
            msg.lparam2{count}, 0, 0, msg.Description);
        end;
        RM_SENDUSERSELL: begin
          SendDefMessage(SM_SENDUSERSELL, msg.lparam1{merchant id},
            msg.lparam2{count}, 0, 0, '');
        end;
        RM_SENDUSERREPAIR,
        RM_SENDUSERSPECIALREPAIR: begin
          SendDefMessage(SM_SENDUSERREPAIR, msg.lparam1{merchant id},
            msg.lparam2{count}, 0, 0, '');
        end;
        RM_SENDUSERSTORAGEITEM: begin
          SendDefMessage(SM_SENDUSERSTORAGEITEM, msg.lparam1{merchant id},
            msg.lparam2{count}, 0, 0, '');
        end;
        RM_SENDUSERSTORAGEITEMLIST: begin
          ServerSendStorageItemList(msg.lparam1);
        end;
        RM_SENDUSERMAKEDRUGITEMLIST: begin
          SendDefMessage(SM_SENDUSERMAKEDRUGITEMLIST,
            msg.lparam1{merchant id}, msg.lparam2{count}, 0, 0, msg.Description);
        end;
        RM_SENDBUYPRICE: begin
          SendDefMessage(SM_SENDBUYPRICE, msg.lparam1{buy price}, 0, 0, 0, '');
        end;
        RM_USERSELLITEM_OK: SendDefMessage(
            SM_USERSELLITEM_OK, msg.lparam1{chg gold}, 0, 0, 0, '');
        RM_USERSELLITEM_FAIL: SendDefMessage(
            SM_USERSELLITEM_FAIL, msg.lparam1, 0, 0, 0, '');
        // 카운트아이템
        RM_USERSELLCOUNTITEM_OK:          // gadget : 카운트아이템
          SendDefMessage(SM_USERSELLCOUNTITEM_OK, msg.lparam1 {chg gold},
            msg.lparam2, msg.lparam3, 0, '');
        RM_USERSELLCOUNTITEM_FAIL:          // gadget : 카운트아이템
          SendDefMessage(SM_USERSELLCOUNTITEM_FAIL, msg.lparam1, 0, 0, 0, '');
        // 아이템 제조
        RM_SENDUSERMAKEITEMLIST: begin
          SendDefMessage(SM_SENDUSERMAKEITEMLIST,
            msg.lparam1{merchant id}, msg.lparam2{count}, 0, 0, msg.Description);
        end;

        RM_BUYITEM_SUCCESS: SendDefMessage(
            SM_BUYITEM_SUCCESS, msg.lparam1{chg gold}, Loword(msg.lparam2),
            Hiword(msg.lparam2), 0, '');
        RM_BUYITEM_FAIL: SendDefMessage(SM_BUYITEM_FAIL,
            msg.lparam1{error code}, 0, 0, 0, '');
        RM_MAKEDRUG_SUCCESS: SendDefMessage(
            SM_MAKEDRUG_SUCCESS, msg.lparam1{chg gold}, 0, 0, 0, '');
        RM_MAKEDRUG_FAIL: SendDefMessage(SM_MAKEDRUG_FAIL,
            msg.lparam1{chg gold}, 0, 0, 0, '');
        RM_SENDDETAILGOODSLIST: SendDefMessage
          (SM_SENDDETAILGOODSLIST, msg.lparam1{merchant id}, msg.lparam2{count},
            msg.lparam3{menuindex}, 0, msg.Description);

        RM_USERREPAIRITEM_OK: SendDefMessage(
            SM_USERREPAIRITEM_OK, msg.lparam1{cost}, msg.lparam2{dura},
            msg.lparam3{maxdura}, 0, '');
        RM_USERREPAIRITEM_FAIL: SendDefMessage
          (SM_USERREPAIRITEM_FAIL, msg.lparam1{cost}, 0, 0, 0, '');
        RM_SENDREPAIRCOST: SendDefMessage(
            SM_SENDREPAIRCOST, msg.lparam1{cost}, 0, 0, 0, '');
        //위탁판매
        RM_MARKET_LIST: SendDefMessage(SM_MARKET_LIST,
            msg.lparam1, msg.lparam2, msg.lparam3, 0, msg.Description);
        RM_MARKET_RESULT: SendDefMessage(SM_MARKET_RESULT,
            msg.lparam1, msg.lparam2, msg.lparam3, 0, '');

        RM_ITEMSHOW: begin
          SendDefMessage(SM_ITEMSHOW, msg.lparam1{pointer},
            msg.lparam2{x}, msg.lparam3{y}, msg.wParam{looks}, msg.Description);
        end;
        RM_ITEMHIDE: begin
          SendDefMessage(SM_ITEMHIDE, msg.lparam1{pointer},
            msg.lparam2{x}, msg.lparam3{y}, 0, '');
        end;
        RM_DELITEMS: begin
          if msg.lparam1 <> 0 then begin
            SendDelItems(TStringList(msg.lparam1));
            TStringList(msg.lparam1).Free; //여기서 Free해야 함...
          end;
        end;

        // 문파 장원
        RM_GUILDAGITLIST: begin
          SendDefMessage(SM_GUILDAGITLIST, msg.lparam1{page},
            msg.lparam2{count}, 0, 0, msg.Description);
        end;
        RM_GABOARD_LIST: // 장원게시판
        begin
          SendDefMessage(SM_GABOARD_LIST, msg.lparam1{page},
            msg.lparam2{count}, msg.lparam3{allpage}, 0, msg.Description);
        end;
        RM_GABOARD_NOTICE_OK: // 장원게시판
        begin
          SendDefMessage(SM_GABOARD_NOTICE_OK, msg.lparam1,
            msg.lparam2, msg.lparam3, 0, msg.Description);
        end;
        RM_GABOARD_NOTICE_FAIL: // 장원게시판
        begin
          SendDefMessage(SM_GABOARD_NOTICE_FAIL, msg.lparam1,
            msg.lparam2, msg.lparam3, 0, msg.Description);
        end;
        //--------------------------------
        // 장원꾸미기
        RM_DECOITEM_LIST: begin
          SendDefMessage(SM_DECOITEM_LIST, msg.lparam1{merchant id},
            msg.lparam2{count}, 0, 0, msg.Description);
        end;
        RM_DECOITEM_LISTSHOW: begin
          SendDefMessage(SM_DECOITEM_LISTSHOW, msg.lparam1{merchant id},
            msg.lparam2{count}, 0, 0, msg.Description);
        end;
        //--------------------------------

        RM_CANCLOSE_OK: SendDefMessage(SM_CANCLOSE_OK,
            msg.lparam1, 0, 0, 0, msg.Description);
        RM_CANCLOSE_FAIL: SendDefMessage(SM_CANCLOSE_FAIL,
            msg.lparam1, 0, 0, 0, msg.Description);

        RM_OPENDOOR_OK: begin
          SendDefMessage(SM_OPENDOOR_OK, 0, msg.lparam1, msg.lparam2, 0, '');
        end;
        RM_CLOSEDOOR: begin
          SendDefMessage(SM_CLOSEDOOR, 0, msg.lparam1, msg.lparam2, 0, '');
        end;

        RM_SENDUSEITEMS: begin
          SendUseItems;
        end;

        RM_SENDMYMAGIC: begin
          SendMyMagics;
        end;

        RM_WEIGHTCHANGED: begin
          SendDefMessage(SM_WEIGHTCHANGED,
            WAbil.Weight,
            WAbil.WearWeight,
            WAbil.HandWeight,
            (((WAbil.Weight + WAbil.WearWeight + WAbil.HandWeight) xor
            $3A5F) xor $1F35) xor $aa21, '');
        end;
        RM_GOLDCHANGED: begin
          SendDefMessage(SM_GOLDCHANGED, Gold, 0, 0, 0, '');
        end;
        RM_FEATURECHANGED: begin
          SendDefMessage(SM_FEATURECHANGED, integer(msg.Sender),
            Loword(msg.lParam1), Hiword(msg.lparam1), 0, '');
        end;
        RM_CHARSTATUSCHANGED: begin
          SendDefMessage(SM_CHARSTATUSCHANGED, integer(msg.Sender),
            Loword(msg.lParam1), Hiword(msg.lparam1), msg.wparam, '');
        end;

        RM_CLEAROBJECTS: begin
          SendDefMessage(SM_CLEAROBJECTS, 0, 0, 0, 0, '');
        end;

        RM_MAGIC_LVEXP: begin
          SendDefMessage(SM_MAGIC_LVEXP, msg.lparam1,
            msg.lparam2{lv}, Loword(msg.lparam3), Hiword(msg.lparam3), '');
        end;
        RM_SOUND: begin
          SendDefMessage(SM_SOUND, 0, msg.lparam1, 0, 0, '');
        end;
        RM_DURACHANGE: begin
          SendDefMessage(SM_DURACHANGE, msg.lparam1, msg.wparam,
            Loword(msg.lparam2), Hiword(msg.lparam2), '');
        end;
        //RM_ITEMDURACHANGE:
        //   begin
        //      SendDefMessage (SM_ITEMDURACHANGE, msg.lparam1, msg.lparam2{dura}, msg.lparam3{duramax}, 0, '');
        //   end;
        RM_CHANGELIGHT: begin
          SendDefMessage(SM_CHANGELIGHT, integer(msg.Sender),
            TCreature(msg.Sender).Light, 0, 0, '');
        end;
        RM_LAMPCHANGEDURA: begin
          SendDefMessage(SM_LAMPCHANGEDURA, msg.lparam1, 0, 0, 0, '');
        end;

        // 카운트 아이템
        RM_COUNTERITEMCHANGE: begin
          ServerSendItemCountChanged(msg.lParam1, msg.lParam2,
            msg.lParam3, msg.Description);
        end;

        RM_GROUPCANCEL: begin
          SendDefMessage(SM_GROUPCANCEL, 0, 0, 0, 0, '');
        end;

        RM_CHANGEGUILDNAME: begin
          SendChangeGuildName;
        end;

        RM_BUILDGUILD_OK: SendDefMessage(SM_BUILDGUILD_OK, 0, 0, 0, 0, '');

        RM_BUILDGUILD_FAIL: SendDefMessage(SM_BUILDGUILD_FAIL,
            msg.lparam1, 0, 0, 0, '');

        RM_DONATE_OK: SendDefMessage(SM_DONATE_OK, msg.lparam1, 0, 0, 0, '');

        RM_DONATE_FAIL: SendDefMessage(SM_DONATE_FAIL, msg.lparam1, 0, 0, 0, '');

        RM_MENU_OK: SendDefMessage(SM_MENU_OK, msg.lparam1, 0,
            0, 0, msg.Description);

        RM_NEXTTIME_PASSWORD: SendDefMessage(SM_NEXTTIME_PASSWORD, 0, 0, 0, 0, '');

        RM_DOSTARTUPQUEST: DoStartupQuestNow;

        RM_PLAYDICE: begin
          wl.lParam1 := msg.lparam1;
          wl.lParam2 := msg.lparam2;
          wl.lTag1 := msg.lparam3;
          Def := MakeDefaultMsg(SM_PLAYDICE, integer(msg.Sender),
            msg.wparam, 0, 0);

          SendSocket(@Def, EncodeBuffer(@wl, sizeof(TMessageBodyWL)) +
            EncodeString(msg.Description));

        end;
        RM_PLAYROCK: begin
          wl.lParam1 := msg.lparam1;
          wl.lParam2 := msg.lparam2;
          wl.lTag1 := msg.lparam3;
          Def := MakeDefaultMsg(SM_PLAYROCK, integer(msg.Sender),
            msg.wparam, 0, 0);

          SendSocket(@Def, EncodeBuffer(@wl, sizeof(TMessageBodyWL)) +
            EncodeString(msg.Description));

        end;

        else
          inherited RunMsg(msg);
      end;
    end;

    //-----------------------------------------
    // 서버 이동 또는 접속 종료(로그아웃)
    // BoChangeServer로 구분(sonmg)
    //-----------------------------------------
    if EmergencyClose or UserRequestClose or UserSocketClosed then begin
      if not BoChangeServer then begin //접속종료 되면 떨어지는이벤트 아이템을 떨군다.
        //접속종료시에 소환몬스터를 모두 죽인다(sonmg 2004/12/01)
        KillAllSlaves;  //소환 몬스터를 모두 없앰.

        //접속종료시에 연인에게 알려줌.
        lovername := fLover.GetLoverName;
        hum := UserEngine.GetUserHuman(lovername);
        if hum <> nil then begin
          hum.SendMsg(hum, RM_LM_LOGOUT, 0, 0, 0, 0, '');
        end else begin
          if UserEngine.FindOtherServerUser(lovername, svidx) then begin
            UserEngine.SendInterMsg(ISM_LM_LOGOUT, svidx,
              UserName + '/' + lovername);
          end;
        end;

        DropEventItems;
      end;

      MakeGhost(6);

      if BoChangeServer then begin
        MapName := ChangeMapName;
        CX      := ChangeCX;
        CY      := ChangeCY;

        //테스트
        //MakeDefaultMsg (SM_SYSMESSAGE, integer(self), MakeWord(255, 56), 0, 1);
        //SendSocket (@Def, EncodeString ('change server 1'));
      end;

      if UserRequestClose then
        SendDefMessage(SM_OUTOFCONNECTION, 0, 0, 0, 0, '');

      if not SoftClosed and UserSocketClosed then begin
        //캐릭터 선택으로 빠진것이 아니면
        //다른 서버에 알린다.
        FrmIDSoc.SendUserClose(UserId, Certification);
      end;

      exit;
    end;

  except
    MainOutMessage('[Exception] Operate 2 #' + UserName + ' Identback:' +
      IntToStr(IdentBackup) + ' Ident:' + IntToStr(msg.Ident) +
      ' Sender:' + IntToStr(integer(msg.Sender)) + ' wP:' +
      IntToStr(msg.wParam) + ' lP1:' + IntToStr(msg.lParam1) +
      ' lP2:' + IntToStr(msg.lParam2) + ' lP3:' + IntToStr(msg.lParam3));
  end;

  inherited Run;
end;


{-------------------- 공지사항 알리기 ---------------------}

//공지사항 리스트는 5분에 한번씩 리프래쉬 한다.


procedure TUserHuman.SendLoginNotice;
var
  i:    integer;
  strlist: TStringList;
  Data: string;
begin
  strlist := TStringList.Create;
  NoticeMan.GetNoticList('Notice', strlist);
  Data := '';
  for i := 0 to strlist.Count - 1 do begin
    Data := Data + strlist[i] + ' '#27;
  end;
  strlist.Free;
  SendDefMessage(SM_SENDNOTICE, 0, 0, 0, 0, Data);
end;

procedure TUserHuman.RunNotice;
var
  msg: TMessageInfo;
begin
  if EmergencyClose or UserRequestClose or UserSocketClosed then begin
    if UserRequestClose then
      SendDefMessage(SM_OUTOFCONNECTION, 0, 0, 0, 0, '');
    MakeGhost(7);
    //BoGhost := TRUE;
    //GhostTime := GetTickCount;
    exit;
  end;
  try
    //로그인 전에 공지사항을 보낸다.
    if not BoSendNotice then begin
      SendLoginNotice;
      BoSendNotice := True;
    end else begin
      while GetMsg(msg) do begin
        case msg.Ident of
          CM_LOGINNOTICEOK: ServerGetNoticeOk;
        end;
      end;
    end;
  except
    MainOutMessage('[Exception] TUserHuman.RunNotice');
  end;
end;

procedure TUserHuman.GetGetNotices;
begin
  if BoGetGetNeedNotice then
    GetGetNotices;
end;

procedure TUserHuman.ServerGetNoticeOk;
begin
  LoginSign := True;
end;


function TUserHuman.GetStartX: integer;
begin
  Result := HomeX - 2 + Random(3);
end;

function TUserHuman.GetStartY: integer;
begin
  Result := HomeY - 2 + Random(3);
end;

procedure TUserHuman.CheckHomePos;  //시작하는 마을을 바꿀지 결정
var
  i:    integer;
  flag: boolean;
  mp: PTMapPoint;
begin
  flag := False;
  for i := 0 to StartPoints.Count - 1 do begin
    mp := PTMapPoint(StartPoints[i]);
    if PEnvir.MapName = mp.MapName then begin
      if (Abs(CX - mp.PointX) < 50) and
        (Abs(CY - mp.PointY) < 50) then begin
        HomeMap := mp.MapName;
        HomeX   := mp.PointX;
        HomeY   := mp.PointY;
        flag    := True;
      end;
    end;
  end;
  if PKLevel >= 2 then begin  //빨갱이는 빨갱이 마을로
    HomeMap := BADMANHOMEMAP;
    HomeX   := BADMANSTARTX;
    HomeY   := BADMANSTARTY;
  end;
end;


{-------------------- 클라이언트의 메세지를 처리함 ---------------------}

procedure TUserHuman.GetQueryUserName(target: TCreature; x, y: integer);
var
  uname:    string;
  tagcolor: integer;
begin
  if CretInNearXY(target, x, y) then begin
    tagcolor := GetThisCharColor(target);
    Def      := MakeDefaultMsg(SM_USERNAME, integer(target), tagcolor, 0, 0);
    uname    := target.GetUserName;
    SendSocket(@Def, EncodeString(uname));
  end else
    SendDefMessage(SM_GHOST, integer(target), x, y, 0, '');
end;

//클라이언트에 보너스 포인트를 조정하라고 신호를 보낸다.
procedure TUserHuman.ServerSendAdjustBonus;
var
  str: string;
  na:  TNakedAbility;
begin
  Def := MakeDefaultMsg(SM_ADJUST_BONUS, integer(BonusPoint), 0, 0, 0);
  str := '';
  na  := BonusAbil;
  case Job of
    0: str := EncodeBuffer(@WarriorBonus, sizeof(TNakedAbility)) +
        '/' + EncodeBuffer(@CurBonusAbil, sizeof(TNakedAbility)) +
        '/' + EncodeBuffer(@na, sizeof(TNakedAbility));
    1: str := EncodeBuffer(@WizzardBonus, sizeof(TNakedAbility)) +
        '/' + EncodeBuffer(@CurBonusAbil, sizeof(TNakedAbility)) +
        '/' + EncodeBuffer(@na, sizeof(TNakedAbility));
    2: str := EncodeBuffer(@PriestBonus, sizeof(TNakedAbility)) +
        '/' + EncodeBuffer(@CurBonusAbil, sizeof(TNakedAbility)) +
        '/' + EncodeBuffer(@na, sizeof(TNakedAbility));
    3: str := EncodeBuffer(@KillerBonus, sizeof(TNakedAbility)) +
        '/' + EncodeBuffer(@CurBonusAbil, sizeof(TNakedAbility)) +
        '/' + EncodeBuffer(@na, sizeof(TNakedAbility));
  end;
  SendSocket(@Def, str);
end;

procedure TUserHuman.ServerGetOpenDoor(dx, dy: integer);
var
  pd: PTDoorInfo;
begin
  if PEnvir = UserCastle.CastlePEnvir then begin
    pd := PEnvir.FindDoor(dx, dy);
    if UserCastle.CoreCastlePDoorCore = pd.pCore then begin  //사북성의 내성문
      if RaceServer = RC_USERHUMAN then
        if not UserCastle.CanEnteranceCoreCastle(CX, CY, TUserHuman(self)) then
          exit;  //들어갈 수 없음.
    end;
  end;

  UserEngine.OpenDoor(PEnvir, dx, dy);
end;

procedure TUserHuman.ServerGetTakeOnItem(where: byte; svindex: integer;
  itmname: string);
var
  i, bagindex, ecount: integer;
  ps, ps2: PTStdItem;
  std:     TStdItem;
  targpu, pu: PTUserItem;
label
  finish;
begin
  ps     := nil;
  targpu := nil;
  bagindex := -1;
  for i := 0 to Itemlist.Count - 1 do begin
    if PTUserItem(ItemList[i]).MakeIndex = svindex then begin
      ps := UserEngine.GetStdItem(PTUserItem(ItemList[i]).Index);
      if ps <> nil then
        if CompareText(ps.Name, itmname) = 0 then begin
          bagindex := i;
          targpu   := PTUserItem(ItemList[i]);

          break;
        end;
    end;
  end;

  ecount := 0;
  if (ps <> nil) and (targpu <> nil) then begin
    if IsTakeOnAvailable(where, ps) then begin //착용할 수 있는 바른 아이템인가?
      std := ps^;
      ItemMan.GetUpgradeStdItem(targpu^, std);
      //무기의 업그레이드된 능력치를 얻어온다.
      if CanTakeOn(where, @std) then begin //내가 능력이 되는가?

        pu := nil;
        if UseItems[where].Index > 0 then begin //이미 착용하고 있음.
          //벗지 못하는 아이템이 아닌경우 (미지수로 벗을 수 있음)
          ps2 := UserEngine.GetStdItem(UseItems[where].Index);
          // 2003/03/15 아이템 인벤토리 확장
          if ps2.StdMode in [15, 19, 20, 21, 22, 23, 24, 26, 52, 53, 54] then begin
            if not BoNextTimeFreeCurseItem and (UseItems[where].Desc[7] <> 0) then
            begin
              //벗을 수 없는 아이템
              SysMsg('The item cannot be taken off.', 0);
              ecount := -4;
              goto finish;
            end;
          end;
          if not BoNextTimeFreeCurseItem and (ps2.ItemDesc and
            IDC_UNABLETAKEOFF <> 0) then begin
            //벗을 수 없는 아이템
            SysMsg('The item cannot be taken off.', 0);
            ecount := -4;
            goto finish;
          end;
          //절대로 벗지 못하는 아이템
          if ps2.ItemDesc and IDC_NEVERTAKEOFF <> 0 then begin
            SysMsg('The item cannot be taken off.', 0);
            ecount := -4;
            goto finish;
          end;
          new(pu);
          pu^ := UseItems[where];
        end;

        //미지의 속성을 가지고 있는 아이템인 경우 한번 착용하면 풀림
        // 2003/03/15 아이템 인벤토리 확장
        if ps.StdMode in [15, 19, 20, 21, 22, 23, 24, 26, 52, 53, 54] then begin
          if targpu.Desc[8] <> 0 then
            targpu.Desc[8] := 0; //미지속성 풀림;
        end;

        UseItems[where] := targpu^;
        DelItemIndex(bagindex);  //DelItem (svindex, itmname);
        if pu <> nil then begin
          AddItem(pu); //가방에 추가되는 아이템 보낸다.(있으면)
          SendAddItem(pu^);
        end;
        try
          RecalcAbilitys;     //능력치 재조정 한다.
        except
          MainOutMessage('ItemTakeOn Ability Error ');
        end;
        SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
        SendMsg(self, RM_SUBABILITY, 0, 0, 0, 0, '');
        SendDefMessage(SM_TAKEON_OK, Feature, 0, 0, 0, '');
        //착용 성공 보낸다. 변경된 모습을 보낸다.
        FeatureChanged;

        // 날개옷일경우에는 레벨에 따른 능력치를 바꿔준다.(sonmg 수정 2004/04/02)
        if (ps.StdMode = DRESS_STDMODE_MAN) or
          (ps.StdMode = DRESS_STDMODE_WOMAN) then begin
          if ps.Shape = DRESS_SHAPE_WING then begin
            SendUpdateItemWithLevel(UseItems[where], Abil.Level);
          end else if ps.Shape = DRAGON_DRESS_SHAPE then begin
            SendUpdateItemByJob(UseItems[where], Abil.Level);
          end else if ps.Shape = DRESS_SHAPE_PBKING then begin
            SendUpdateItemByJob(UseItems[where], Abil.Level);
          end;
        end else begin
          SendUpdateItem(UseItems[where]);
        end;

        ecount := 1;
      end else
        ecount := -1;
    end else
      ecount := -2;
  end;
  finish: if ecount <= 0 then
      SendDefMessage(SM_TAKEON_FAIL, ecount, 0, 0, 0, '');
end;

procedure TUserHuman.ServerGetTakeOffItem(where: byte; svindex: integer;
  itmname: string);
var
  ecount: integer;
  ps:     PTStdItem;
  pu:     PTUserItem;
label
  finish;
begin
  ecount := 0;
  // 2003/03/15 아이템 인벤토리 확장
  if (not BoDealing) and (where in [0..12]) then begin
    //교환중에는 아이템을 못 벗는다. 8->12
    if UseItems[where].Index > 0 then begin //착용하고 있어야 벗을 수 있음.
      if UseItems[where].MakeIndex = svindex then begin
        ps := UserEngine.GetStdItem(UseItems[where].Index);

        //벗지 못하는 아이템이 아닌경우
        // 2003/03/15 아이템 인벤토리 확장
        if ps.StdMode in [15, 19, 20, 21, 22, 23, 24, 26, 52, 53, 54] then begin
          if not BoNextTimeFreeCurseItem and (UseItems[where].Desc[7] <> 0) then
          begin
            //벗을 수 없는 아이템
            SysMsg('The item cannot be taken off.', 0);
            ecount := -4;
            goto finish;
          end;
        end;
        if not BoNextTimeFreeCurseItem and (ps.ItemDesc and
          IDC_UNABLETAKEOFF <> 0) then begin
          //벗을 수 없는 아이템
          SysMsg('The item cannot be taken off.', 0);
          ecount := -4;
          goto finish;
        end;
        //절대로 벗지 못하는 아이템
        if ps.ItemDesc and IDC_NEVERTAKEOFF <> 0 then begin
          SysMsg('The item cannot be taken off.', 0);
          ecount := -4;
          goto finish;
        end;

        if CompareText(ps.Name, itmname) = 0 then begin
          new(pu);
          pu^ := UseItems[where];
          if AddItem(pu) then begin     //가방에 추가되는 아이템 보낸다.
            UseItems[where].Index := 0; //지움..
            SendDefMessage(SM_TAKEOFF_OK, Feature, 0, 0, 0, '');
            SendAddItem(pu^);
            RecalcAbilitys;     //능력치 재조정 한다.
            SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
            SendMsg(self, RM_SUBABILITY, 0, 0, 0, 0, '');
            FeatureChanged;
          end else begin
            Dispose(pu);
            ecount := -3;
          end;
        end;
      end;
    end else
      ecount := -2;
  end else
    ecount := -1;

  finish: if ecount <= 0 then
      SendDefMessage(SM_TAKEOFF_FAIL, ecount, 0, 0, 0, '');
end;

//------------------------------
function TUserHuman.BindPotionUnit(iShape, iCount: integer): boolean;
var
  strItemName: string;
  hum: TUserHuman;
  pui: PTUserItem;
begin
  Result := False;

  // 부적은 묶을 수 없다.(sonmg)
  if iShape = SHAPE_AMULET_BUNCH then
    exit; // 부적묶음

  try
    strItemName := UserEngine.GetStdItemNameByShape(31, iShape);
    // 묶음아이템 StdMode, Shape

    new(pui);
    if UserEngine.CopyToUserItemFromName(strItemName, pui^) then begin
      ItemList.Add(pui);
      if RaceServer = RC_USERHUMAN then begin
        hum := TUserHuman(self);
        hum.SendAddItem(pui^);
      end;
      Result := True;
    end else
      Dispose(pui);
  except
  end;
end;

procedure TUserHuman.ServerGetEatItem(svindex: integer; itmname: string);

  function UnbindPotionUnit(itmname: string; Count: integer): boolean;
  var
    i:   integer;
    hum: TUserHuman;
    pui: PTUserItem;
  begin
    Result := False;
    for i := 0 to Count - 1 do begin
      new(pui);
      if UserEngine.CopyToUserItemFromName(itmname, pui^) then begin
        ItemList.Add(pui);
        if RaceServer = RC_USERHUMAN then begin
          hum := TUserHuman(self);
          hum.SendAddItem(pui^);
        end;
      end else
        Dispose(pui);
    end;
    Result := True;
  end;

var
  i, j:    integer;
  flag:    boolean;
  ps:      PTStdItem;
  ui:      TUserItem;
  WantLog: boolean;
  pu:      PTUserItem;
  iShape:  integer;
  dellist: TStringList;
begin
  dellist := nil;
  flag    := False;
  WantLog := True;
  if not Death then begin
    for i := 0 to Itemlist.Count - 1 do begin
      if PTUserItem(ItemList[i]).MakeIndex = svindex then begin
        //if UserEngine.GetStdItemName (PTUserItem(ItemList[i]).Index) = itmname then begin
        ps := UserEngine.GetStdItem(PTUserItem(Itemlist[i]).Index);
        ui := PTUserItem(Itemlist[i])^;
        pu := PTUserItem(Itemlist[i]);
        case ps.StdMode of
          0, 1, 2, 3: //시약, 고기류, 음식, 스크롤
            if EatItem(ps^, PTUserItem(ItemList[i])) then begin
              Dispose(PTUserItem(ItemList[i]));
              ItemList.Delete(i);
              flag := True;

              WantLog := False;
              if (ps.StdMode = 3) and (ps.Shape <> 2) then begin
                WantLog := True;
              end;

            end;
          4: //책
            if ReadBook(ps^) then begin
              Dispose(PTUserItem(ItemList[i]));
              ItemList.Delete(i);
              flag := True;
              //어검술
              if PLongHitSkill <> nil then
                if not BoAllowLongHit then begin
                  SetAllowLongHit(True);
                  SendSocket(nil, '+LNG');  //원거리 공격을 하게 한다.
                end;
              //반월검법
              if PWideHitSkill <> nil then
                if not BoAllowWideHit then begin
                  SetAllowWideHit(True);
                  SendSocket(nil, '+WID');
                end;
              //Assassin Skill 2
              if PWideHit2Skill <> nil then
                if not BoAllowWideHit2 then begin
                  SetAllowWideHit2(True);
                  SendSocket(nil, '+WID2');
                end;
              // 2003/03/15 신규무공
              // 광풍참
              if PCrossHitSkill <> nil then
                if not BoAllowCrossHit then begin
                  SetAllowCrossHit(True);
                  SendSocket(nil, '+CRS');
                end;
            end;
          8: //먹는(사용) 아이템, 벨트창에 착용할 수 없음 (초대장) (2004/05/06)
            if ps.Shape = SHAPE_OF_INVITATION then begin
              if EatItem(ps^, PTUserItem(ItemList[i])) then begin
                Dispose(PTUserItem(ItemList[i]));
                ItemList.Delete(i);
                flag := True;

                WantLog := False;
                if (ps.StdMode = 3) and (ps.Shape <> 2) then begin
                  WantLog := True;
                end;

              end;
            end else if EatItem(ps^, PTUserItem(ItemList[i])) then begin
              Dispose(PTUserItem(ItemList[i]));
              ItemList.Delete(i);
              flag := True;
            end;
          31: begin
            if ItemList.Count + 6 - 1 <= MAXBAGITEM then begin
              Dispose(PTUserItem(ItemList[i]));
              ItemList.Delete(i);
              UnbindPotionUnit(GetUnbindItemName(ps.Shape), 6);
              flag := True;

              //묶음 푸는거 로그 안남김 
              WantLog := False;
            end;
          end;
        end;
        break;
        //end;
      end;
    end;
  end;

  if flag then begin
    //삭제목록에 추가된 바인드 아이템들 삭제.
    if dellist <> nil then begin
      for j := 0 to dellist.Count - 1 do begin
        for i := 0 to Itemlist.Count - 1 do begin
          pu := PTUserItem(ItemList[i]);
          if pu.MakeIndex = integer(dellist.Objects[j]) then begin
            Dispose(pu);
            ItemList.Delete(i);
            break;
          end;
        end;
      end;

      SendMsg(self, RM_DELITEMS, 0, integer(dellist), 0, 0, '');
      //dellist는 rm_delitem에서 free 시켜야 한다.
    end;

    WeightChanged;
    SendDefMessage(SM_EAT_OK, 0, 0, 0, 0, '');
    //물건을 사용하여 없어짐
    AddUserLog('11'#9 + //사용_ +
      MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) + ''#9 +
      UserName + ''#9 + UserEngine.GetStdItemName(ui.Index) + ''#9 +
      IntToStr(ui.MakeIndex) + ''#9 + IntToStr(BoolToInt(RaceServer = RC_USERHUMAN)) +
      ''#9 + '0');
  end else
    SendDefMessage(SM_EAT_FAIL, 0, 0, 0, 0, '');
end;

{ original
procedure TUserHuman.ServerGetButch (animal: TCreature; x, y, ndir: integer);
var
   n, m: integer;
begin
   if (abs(x-CX) <= 2) and (abs(y-CY) <= 2) then begin  //바로 옆칸만 썰 수 있음
      if PEnvir.IsValidCreature (x, y, 2, animal) then begin  //
         if (animal.Death) and (not animal.BoSkeleton) and (animal.BoAnimal) then begin
            //자신의 도축 기술에 따라서 도축 포인트가 다르게 적용된다.
            //기술이 없는 경우, 5-20 사이이며, 고기의 질도 10-20씩 떨어진다.
            n := 5 + Random(16);
            m := 100 + Random(201);
            animal.BodyLeathery := animal.BodyLeathery - n;
            animal.MeatQuality := animal.MeatQuality - m;   //칼질을 할 수록 고기질은 조금씩 떨어짐
            if animal.MeatQuality < 0 then animal.MeatQuality := 0;
            if animal.BodyLeathery <= 0 then begin
               if (animal.RaceServer >= RC_ANIMAL) and (animal.RaceServer < RC_MONSTER) then begin  //사슴같이 고기를주는 것만, 해골로 변함
                  animal.BoSkeleton := TRUE;
                  animal.ApplyMeatQuality;
                  animal.SendRefMsg (RM_SKELETON, animal.Dir, animal.CX, animal.CY, 0, '')
               end;
               if not TakeCretBagItems (animal) then
                  SysMsg ('Nothing found.', 0);
               animal.BodyLeathery := 50; //메세지가 연속으로 나오는 것을 막음.
            end;
            DeathTime := GetTickCount;  //도축하고 있는도중에 고기는 사라지지 않음.
         end;
      end;
      Dir := ndir;
   end;
   SendRefMsg (RM_BUTCH, Dir, CX, CY, 0, '');
end;
}

procedure TUserHuman.ServerGetButch(animal: TCreature; x, y, ndir: integer);
var
  n, m: integer;
  cret: TObject;
begin
  cret := nil;
  if (abs(x - CX) <= 2) and (abs(y - CY) <= 2) then begin  //두 칸 옆까지 썰 수 있음
    if PEnvir.IsValidFrontCreature(x, y, 2, cret) then begin  // (sonmg 2004/12/28)
      if cret <> nil then begin
        animal := TCreature(cret); // (sonmg 2004/12/28)
        if (animal.Death) and (not animal.BoSkeleton) and (animal.BoAnimal) then
        begin
          //자신의 도축 기술에 따라서 도축 포인트가 다르게 적용된다.
          //기술이 없는 경우, 5-20 사이이며, 고기의 질도 10-20씩 떨어진다.
          n := 5 + Random(16);
          m := 100 + Random(201);
          animal.BodyLeathery := animal.BodyLeathery - n;
          animal.MeatQuality := animal.MeatQuality - m;
          //칼질을 할 수록 고기질은 조금씩 떨어짐
          if animal.MeatQuality < 0 then
            animal.MeatQuality := 0;
          if animal.BodyLeathery <= 0 then begin
            if (animal.RaceServer >= RC_ANIMAL) and
              (animal.RaceServer < RC_MONSTER) then begin
              //사슴같이 고기를주는 것만, 해골로 변함
              animal.BoSkeleton := True;
              animal.ApplyMeatQuality;
              animal.SendRefMsg(RM_SKELETON, animal.Dir,
                animal.CX, animal.CY, 0, '');
            end;
            if not TakeCretBagItems(animal) then
              SysMsg('Nothing found.', 0);
            animal.BodyLeathery := 50; //메세지가 연속으로 나오는 것을 막음.
          end;
          DeathTime := GetTickCount;  //도축하고 있는도중에 고기는 사라지지 않음.
        end;
      end;
    end;
    Dir := ndir;
  end;
  SendRefMsg(RM_BUTCH, Dir, CX, CY, 0, '');
end;

procedure TUserHuman.ServerGetMagicKeyChange(magid, key: integer);
var
  i: integer;
begin
  for i := 0 to MagicList.Count - 1 do begin
    if PTUserMagic(MagicList[i]).pDef.MagicId = magid then begin
      PTUserMagic(MagicList[i]).Key := AnsiChar(key);
      break;
    end;
  end;
end;

procedure TUserHuman.ServerGetClickNpc(clickid: integer);
var
  npc: TCreature;
begin
  if BoDealing then
    exit;  //교환중에는 npc를 클릭할 수 없다.

  //NPC등, 상인들 검사
  npc := UserEngine.GetMerchant(clickid);
  if npc = nil then
    npc := UserEngine.GetNpc(clickid);
  if npc <> nil then begin
    if (npc.PEnvir = PEnvir) and (abs(npc.CX - CX) <= 15) and
      (abs(npc.CY - CY) <= 15) then  begin
      TNormNpc(npc).UserCall(self);
    end;
  end;
end;

procedure TUserHuman.ServerGetMerchantDlgSelect(npcid: integer; clickstr: string);
var
  npc: TNormNpc;
begin
  npc := TNormNpc(UserEngine.GetMerchant(npcid));
  if npc = nil then
    npc := TNormNpc(UserEngine.GetNpc(npcid));
  if npc <> nil then begin
    //npc.BoInvisible => 맵 퀘스트인 경우
    if (npc.PEnvir = PEnvir) and (abs(npc.CX - CX) <= 15) and
      (abs(npc.CY - CY) <= 15) or (npc.BoInvisible) then begin

      TNormNpc(npc).UserSelect(self, clickstr);

    end;
  end;
end;

procedure TUserHuman.ServerGetMerchantQuerySellPrice(npcid, ItemIndex: integer;
  itemname: string);
var
  i:   integer;
  npc: TCreature;
  pu:  PTuserItem;
begin
  pu := nil;
  //내 가방의 아이템에서 itemindex의 아이템을 찾는다.
  for i := 0 to ItemList.Count - 1 do begin
    if PTUserItem(ItemList[i]).MakeIndex = ItemIndex then begin
      if CompareText(UserEngine.GetStdItemName(PTUserItem(ItemList[i]).Index),
        itemname) = 0 then begin
        pu := PTUserItem(ItemList[i]);
        break;
      end;
    end;
  end;

  if pu <> nil then begin
    npc := UserEngine.GetMerchant(npcid);
    if npc <> nil then begin
      if (npc.PEnvir = PEnvir) and (abs(npc.CX - CX) <= 15) and
        (abs(npc.CY - CY) <= 15) then begin
        TMerchant(npc).QueryPrice(self, pu^);
      end;
    end;
  end;
end;

procedure TUserHuman.ServerGetMerchantQueryRepairPrice(npcid, ItemIndex: integer;
  itemname: string);
var
  i:   integer;
  npc: TCreature;
  pu:  PTuserItem;
begin
  pu := nil;
  //내 가방의 아이템에서 itemindex의 아이템을 찾는다.
  for i := 0 to ItemList.Count - 1 do begin
    if PTUserItem(ItemList[i]).MakeIndex = ItemIndex then begin
      if CompareText(UserEngine.GetStdItemName(PTUserItem(ItemList[i]).Index),
        itemname) = 0 then begin
        pu := PTUserItem(ItemList[i]);
        break;
      end;
    end;
  end;

  if pu <> nil then begin
    npc := UserEngine.GetMerchant(npcid);
    if npc <> nil then begin
      if (npc.PEnvir = PEnvir) and (abs(npc.CX - CX) <= 15) and
        (abs(npc.CY - CY) <= 15) then begin
        TMerchant(npc).QueryRepairCost(self, pu^);
      end;
    end;
  end;
end;

procedure TUserHuman.ServerGetUserSellItem(npcid, ItemIndex, sellcnt: integer;
  itemname: string);
var
  i, temp: integer;
  npc:     TCreature;
  pu:      PTuserItem;
  pstd:    PTStdItem;
begin
  pu := nil;
  //내 가방의 아이템에서 itemindex의 아이템을 찾는다.
  for i := 0 to ItemList.Count - 1 do begin
    if PTUserItem(ItemList[i]).MakeIndex = ItemIndex then begin
      if CompareText(UserEngine.GetStdItemName(PTUserItem(ItemList[i]).Index),
        itemname) = 0 then begin
        pu   := PTUserItem(ItemList[i]);
        npc  := UserEngine.GetMerchant(npcid);
        pstd := UserEngine.GetStdItem(pu.Index);
        if (npc <> nil) and (pu <> nil) and (pstd <> nil) then begin
          if (npc.PEnvir = PEnvir) and (abs(npc.CX - CX) <= 15) and
            (abs(npc.CY - CY) <= 15) then begin
            if pstd <> nil then begin
              if pstd.StdMode <> TAIWANEVENTITEM then begin
                //대만 이벤트용 아이템은 팔 수 없다
                if pstd.OverlapItem >= 1 then begin    // gadget : 카운트아이템
                  temp := pu.Dura;
                  if (sellcnt > 0) and (temp >= sellcnt) then begin
                    if TMerchant(npc).UserCountSellItem(self,
                      pu^, sellcnt) then begin
                      if temp - sellcnt <= 0 then begin
                        Dispose(PTUserItem(ItemList[i]));
                        ItemList.Delete(i);
                      end else begin
                        PTUserItem(ItemList[i]).Dura := temp - sellcnt;
                      end;
                    end;
                    WeightChanged;
                  end;
                end else begin
                  if TMerchant(npc).UserSellItem(self, pu^) then begin
                    //판매한 아이템을 없앤다.
                    Dispose(PTUserItem(ItemList[i]));
                    ItemList.Delete(i);
                    WeightChanged;
                  end;// else
                  //                              SendMsg (self, RM_USERSELLITEM_FAIL, 0, 0, 0, 0, '');
                end;
              end;
            end;
          end;
        end;
        break;
      end;
    end;
  end;
end;

procedure TUserHuman.ServerGetUserRepairItem(npcid, ItemIndex: integer;
  itemname: string);
var
  i:   integer;
  npc: TCreature;
  pu:  PTuserItem;
begin
  pu := nil;
  //내 가방의 아이템에서 itemindex의 아이템을 찾는다.
  for i := 0 to ItemList.Count - 1 do begin
    if PTUserItem(ItemList[i]).MakeIndex = ItemIndex then begin
      if CompareText(UserEngine.GetStdItemName(PTUserItem(ItemList[i]).Index),
        itemname) = 0 then begin
        pu  := PTUserItem(ItemList[i]);
        npc := UserEngine.GetMerchant(npcid);
        if (npc <> nil) and (pu <> nil) then begin
          if (npc.PEnvir = PEnvir) and (abs(npc.CX - CX) <= 15) and
            (abs(npc.CY - CY) <= 15) then begin
            //수리한다.
            if TMerchant(npc).UserRepairItem(self, pu) then begin
              ;
            end;
          end;
        end;
        break;
      end;
    end;
  end;
end;

procedure TUserHuman.ServerSendStorageItemList(npcid: integer);
var
  i, j:  integer;
  Data:  string;
  pu:    PTUserItem;
  ps:    PTStdItem;
  std:   TStdItem;
  citem: TClientItem;
  page:  integer;
  startcount, endcount, maxcount: integer;
begin
  Data     := '';
  maxcount := SaveItems.Count;
  page     := maxcount div 50;

  for j := 0 to page do begin
    startcount := j * 50;
    endcount   := startcount + 50;
    if endcount > maxcount then
      endcount := maxcount;
    Data := '';
    for i := startcount to endcount - 1 do begin
      pu := PTUserItem(SaveItems[i]);
      ps := UserEngine.GetStdItem(pu.Index);
      if ps <> nil then begin
        std     := ps^;
        citem.UpgradeOpt := ItemMan.GetUpgradeStdItem(pu^, std);
        citem.S := std;

        citem.Dura := pu.Dura;
        citem.DuraMax := pu.DuraMax;
        citem.MakeIndex := pu.MakeIndex;
        Data := Data + EncodeBuffer(@citem, sizeof(TClientItem)) + '/';
      end;
    end;
    Def := MakeDefaultMsg(SM_SAVEITEMLIST, npcid, 0, j, page{, SaveItems.Count}{수량});
    SendSocket(@Def, Data);

  end;
end;

procedure TUserHuman.ServerGetUserStorageItem(npcid, ItemIndex, Count: integer;
  itemname: string);

  function SaveCountItemAdd(uitem: PTUserItem; cnt: integer;
  var bak_ui: TUserItem): integer;  // gadget
  var
    i:     integer;
    total: word;
    ps, ps2: PTStdItem;
  begin
    Result := 0;
    ps     := UserEngine.GetStdItem(uitem.Index);
    if ps <> nil then begin
      for i := 0 to SaveItems.Count - 1 do begin
        ps2 := UserEngine.GetStdItem(PTUserItem(SaveItems[i]).Index);
        if ps2 <> nil then begin
          if (ps.StdMode = ps2.StdMode) and (ps.Looks = ps2.Looks) and
            (ps2.OverlapItem >= 1) then begin
            if CompareText(ps.Name, ps2.Name) = 0 then begin
              if PTUserItem(SaveItems[i]).Dura + cnt <= 1000 then begin
                bak_ui.Index := PTUserItem(SaveItems[i]).Index;
                //bug fix (sonmg 2005/01/07)
                bak_ui.MakeIndex := PTUserItem(SaveItems[i]).MakeIndex;
                //bug fix (sonmg 2005/01/07)
                total  := PTUserItem(SaveItems[i]).Dura + cnt;
                PTUserItem(SaveItems[i]).Dura := total;
                Result := 1;
                break;
              end else begin
                Result := 2;   // 카운트 아이템 개수 제한에 걸림
              end;
            end;
          end;
        end;
      end;
    end;
  end;

var
  i, remain: integer;
  npc:      TCreature;
  pu, newpu: PTUserItem;
  bak_ui:   TUserItem;
  pstd:     PTStdItem;
  flag:     boolean;
  iRetVal:  integer;
  countstr: string;
begin
  pu     := nil;
  newpu  := nil;
  remain := 0;
  countstr := '';

  //내 가방의 아이템에서 itemindex의 아이템을 찾는다.
  flag := False;
  if pos(' ', itemname) >= 0 then
    GetValidStr3(itemname, itemname, [' ']);
  if ApprovalMode <> 1 then begin //체험모드는 물건을 못 맡긴다.
    for i := 0 to ItemList.Count - 1 do begin
      if PTUserItem(ItemList[i]).MakeIndex = ItemIndex then begin
        if CompareText(UserEngine.GetStdItemName(PTUserItem(ItemList[i]).Index),
          itemname) = 0 then begin
          pu   := PTUserItem(ItemList[i]);
          npc  := UserEngine.GetMerchant(npcid);
          pstd := UserEngine.GetStdItem(pu.Index);
          if (npc <> nil) and (pu <> nil) and (pstd <> nil) then begin
            if (npc.PEnvir = PEnvir) and (abs(npc.CX - CX) <= 15) and
              (abs(npc.CY - CY) <= 15) then begin

              if pstd.StdMode <> TAIWANEVENTITEM then begin
                //대만 이벤트용 아이템, 맡길수 없다

                //보관한다.
                //갯수 아이템은 보관된 아이템에서 중복으로 추가함.
                if pstd.OverlapItem >= 1 then begin
                  if Count > 1000 then
                    break;   // 카운트 아이템 개수 제한

                  if Count <= 0 then
                    Count := 1;
                  if Count > pu.Dura then
                    Count := pu.Dura;
                  remain := pu.Dura - Count;
                  countstr := '(' + IntToStr(Count) + ')';
                  //로그를 위한 아이템 개수(sonmg 2005/01/07)
                  iRetVal  := SaveCountItemAdd(pu, Count, bak_ui);
                  if iRetVal = 1 then begin
                    pu.Dura := remain;
                    flag    := True;
                  end else if iRetVal = 2 then begin
                    break;
                  end else begin
                    // 새로운 아이템 추가
                    if SaveItems.Count < MAXSAVELIMIT then begin
                      new(newpu);
                      if UserEngine.CopyToUserItemFromName(itemname, newpu^)
                      then begin
                        newpu.Dura := Count;
                        SaveItems.Add(newpu);
                        pu.Dura := remain;
                        flag    := True;
                      end else begin
                        Dispose(newpu);
                      end;
                    end;
                  end;
                  if pu.Dura = 0 then begin
                    Dispose(PTUserItem(ItemList[i]));    // memory leak
                    ItemList.Delete(i);
                    pu := newpu;   //bug fix (sonmg 2005/01/07)
                  end;
                end else begin
                  if SaveItems.Count < MAXSAVELIMIT then begin
                    SaveItems.Add(pu);  //보관
                    ItemList.Delete(i);
                    flag := True;
                  end;
                end;

                if flag then begin
                  WeightChanged;
                  SendDefMessage(SM_STORAGE_OK, 0, remain, Count, 0, '');
                  if pu <> nil then begin
                    //로그남김
                    AddUserLog('1'#9 + //보관_ +
                      MapName + ''#9 + IntToStr(CX) + ''#9 +
                      IntToStr(CY) + ''#9 + UserName + ''#9 +
                      UserEngine.GetStdItemName(pu.Index) + ''#9 +
                      IntToStr(pu.MakeIndex) + ''#9 + '1'#9 + '0' + countstr);
                    //개수로그(sonmg 2005/01/07)
                  end else begin
                    //로그남김
                    AddUserLog('1'#9 + //보관_ +
                      MapName + ''#9 + IntToStr(CX) + ''#9 +
                      IntToStr(CY) + ''#9 + UserName + ''#9 +
                      UserEngine.GetStdItemName(bak_ui.Index) + ''#9 +
                      IntToStr(bak_ui.MakeIndex) + ''#9 + '1'#9 + '0' + countstr);
                    //개수로그(sonmg 2005/01/07)
                  end;
                end else //더 이상 보관 못함
                  SendDefMessage(SM_STORAGE_FULL, 0, 0, 0, 0, '');
                flag := True;
              end;
            end;
          end;
          break;
        end;
      end;
    end;
  end else
    SysMsg('You cannot use the warehouse in trial mode', 0);
  if not flag then
    SendDefMessage(SM_STORAGE_FAIL, 0, 0, 0, 0, '');
end;

procedure TUserHuman.ServerGetTakeBackStorageItem(npcid, itemserverindex,
  TakeBackCnt: integer; iname: string);
var
  I:      integer;
  flag:   boolean;
  pu, newpu: PTUserItem;
  bak_ui: TUserItem;
  npc:    TCreature;
  ps:     PTStdItem;
  remain: integer;
  CheckWeight: integer;
  countstr: string;
begin
  remain   := 0;
  countstr := '';
  flag     := False;
  if ApprovalMode <> 1 then begin //체험모드는 물건을 못 찾는다.
    for i := 0 to SaveItems.Count - 1 do begin
      if PTUserItem(SaveItems[i]).MakeIndex = itemserverindex then begin
        if CompareText(UserEngine.GetStdItemName(PTUserItem(SaveItems[i]).Index),
          iname) = 0 then begin
          pu  := PTUserItem(SaveItems[i]);
          npc := UserEngine.GetMerchant(npcid);
          if (npc <> nil) and (pu <> nil) then begin
            ps := UserEngine.GetStdItem(pu.Index);

            if ps <> nil then begin
              // 카운트아이템
              if ps.OverlapItem = 1 then
                CheckWeight := ps.Weight + ps.Weight * (TakeBackCnt div 10)
              else if ps.OverlapItem >= 2 then
                CheckWeight := ps.Weight * TakeBackCnt
              else
                CheckWeight := ps.Weight;

              if IsAddWeightAvailable(CheckWeight) then begin
                if (npc.PEnvir = PEnvir) and (abs(npc.CX - CX) <= 15) and
                  (abs(npc.CY - CY) <= 15) then begin
                  //맡긴물건을 찾는다.
                  if ps = nil then
                    break;
                  if ps.OverlapItem >= 1 then begin
                    // gadget:카운트아이템
                    if TakeBackCnt <= 0 then
                      TakeBackCnt := 1;
                    if TakeBackCnt > pu.Dura then
                      TakeBackCnt := pu.Dura;
                    remain := pu.Dura - TakeBackCnt;
                    countstr := '(' + IntToStr(TakeBackCnt) + ')';
                    //로그를 위한 아이템 개수(sonmg 2005/01/07)
                    if UserCounterItemAdd(ps.StdMode, ps.Looks,
                      TakeBackCnt, ps.Name, False) then begin
                      if remain > 0 then begin // memory leak
                        pu.Dura := remain;
                      end else begin
                        bak_ui.Index     := pu.Index;
                        //bug fix (sonmg 2005/01/07)
                        bak_ui.MakeIndex := pu.MakeIndex;
                        //bug fix (sonmg 2005/01/07)
                        Dispose(PTUserItem(SaveItems[i]));
                        SaveItems.Delete(i);
                        pu := nil;
                      end;
                    end else begin
                      new(newpu);
                      if UserEngine.CopyToUserItemFromName(iname, newpu^) then
                      begin
                        newpu.Dura := TakeBackCnt;
                        if AddItem(newpu) then begin
                          SendAddItem(newpu^);
                          if remain > 0 then begin // memory leak
                            pu.Dura := remain;
                          end else begin
                            if newpu <> nil then
                              pu := newpu;   //bug fix (sonmg 2005/01/07)
                            Dispose(PTUSerItem(SaveItems[i]));
                            SaveItems.Delete(i);
                          end;
                        end else begin
                          Dispose(newpu);   // Memory Leak sonmg
                          SendDefMessage(SM_TAKEBACKSTORAGEITEM_FULLBAG,
                            0, 0, 0, 0, ''); //가방 꽉 찼음
                          break;
                        end;
                      end else begin
                        Dispose(newpu);
                      end;
                    end;
                  end else begin
                    if AddItem(pu) then begin  //가방으로 옮기고
                      SendAddItem(pu^);  //클라이언트에 보냄
                      SaveItems.Delete(i);
                    end else begin
                      SendDefMessage(SM_TAKEBACKSTORAGEITEM_FULLBAG,
                        0, 0, 0, 0, ''); //가방 꽉 찼음
                      break;
                    end;
                  end;

                  SendDefMessage(SM_TAKEBACKSTORAGEITEM_OK,
                    itemserverindex, remain, TakeBackCnt, 0, '');
                  if pu <> nil then begin
                    //로그남김
                    AddUserLog('0'#9 + //찾기_ +
                      MapName + ''#9 + IntToStr(CX) + ''#9 +
                      IntToStr(CY) + ''#9 + UserName + ''#9 +
                      UserEngine.GetStdItemName(pu.Index) + ''#9 +
                      IntToStr(pu.MakeIndex) + ''#9 + '1'#9 + '0' + countstr);
                  end else begin
                    //로그남김
                    AddUserLog('0'#9 + //찾기_ +
                      MapName + ''#9 + IntToStr(CX) + ''#9 +
                      IntToStr(CY) + ''#9 + UserName + ''#9 +
                      UserEngine.GetStdItemName(bak_ui.Index) + ''#9 +
                      IntToStr(bak_ui.MakeIndex) + ''#9 + '1'#9 + '0' + countstr);
                  end;
                  flag := True;
                end;
              end else
                SysMsg('You cannot carry any more.', 0);
              WeightChanged;
            end;
          end;
          break;
        end;
      end;
    end;
  end else
    SysMsg('You cannot use the warehouse in trial mode', 0);
  if not flag then
    SendDefMessage(SM_TAKEBACKSTORAGEITEM_FAIL, 0, 0, 0, 0, ''); //가방 꽉 찼음
end;

procedure TUserHuman.ServerGetUserMenuBuy(msg, npcid, MakeIndex, menuindex: integer;
  itemname: string);
var
  i:   integer;
  npc: TCreature;
begin
  if BoDealing then
    exit;  //교환중에는 물건을 살 수 없다.
  npc := UserEngine.GetMerchant(npcid);
  if npc <> nil then begin
    if (npc.PEnvir = PEnvir) and (abs(npc.CX - CX) <= 15) and
      (abs(npc.CY - CY) <= 15) then  begin
      if msg = CM_USERBUYITEM then begin
        if menuindex > 0 then
          TMerchant(npc).UserBuyItem(self, itemname, MakeIndex, menuindex)
        //menuindex:갯수; 상세아이템 or 시약류..
        else
          TMerchant(npc).UserBuyItem(self, itemname, MakeIndex, 1);
        // gadget : 갯수 아이템 사기
        //            TMerchant(npc).UserBuyItem (self, itemname, MakeIndex);  //상세아이템 or 시약류..
      end;
      if msg = CM_USERGETDETAILITEM then begin
        TMerchant(npc).UserWantDetailItems(self, itemname, menuindex);
      end;
    end;
  end;
end;

procedure TUserHuman.ServerGetMakeDrug(npcid: integer; itemname: string);
var
  i:   integer;
  npc: TCreature;
begin
  npc := UserEngine.GetMerchant(npcid);
  if npc <> nil then begin
    if (npc.PEnvir = PEnvir) and (abs(npc.CX - CX) <= 15) and
      (abs(npc.CY - CY) <= 15) then  begin
      TMerchant(npc).UserMakeNewItem(self, itemname);
    end;
  end;
end;

procedure TUserHuman.ServerGetMakeItemSel(npcid: integer; itemname: string);
var
  i:   integer;
  npc: TCreature;
begin
  npc := UserEngine.GetMerchant(npcid);
  if npc <> nil then begin
    if (npc.PEnvir = PEnvir) and (abs(npc.CX - CX) <= 15) and
      (abs(npc.CY - CY) <= 15) then  begin
      TMerchant(npc).SayMakeItemMaterials(self, itemname);
    end;
  end;
end;

procedure TUserHuman.ServerGetMakeItem(npcid: integer; itemname: string);
var
  i:   integer;
  npc: TCreature;
begin
  npc := UserEngine.GetMerchant(npcid);
  if npc <> nil then begin
    if (npc.PEnvir = PEnvir) and (abs(npc.CX - CX) <= 15) and
      (abs(npc.CY - CY) <= 15) then  begin
      TMerchant(npc).UserManufactureItem(self, itemname);
    end;
  end;
end;

//그룹원이 변경되어 그룹원리스트를 그룹원들에게 보냄
procedure TUserHuman.RefreshGroupMembers;
var
  i:    integer;
  Data: string;
  cret: TCreature;
  hum:  TUserHuman;
begin
  Data := '';
  for i := 0 to GroupMembers.Count - 1 do begin
    cret := TCreature(GroupMembers.Objects[i]);
    Data := Data + cret.UserName + '/';
  end;

  for i := 0 to GroupMembers.Count - 1 do begin
    hum := TUserHuman(GroupMembers.Objects[i]);
    if hum.RaceServer = RC_USERHUMAN then begin
      hum.SendDefMessage(SM_GROUPMEMBERS, 0, 0, 0, 0, Data);

    end else begin
      MainOutMessage('ERROR NOT HUMAN RefreshGroupMember');
    end;
  end;

end;

//그룹 만들기
procedure TUserHuman.ServerGetCreateGroup(withwho: string);
var
  who: TUserHuman;
begin
  who := UserEngine.GetUserHuman(withwho);

  if GroupOwner <> nil then begin
    SendDefMessage(SM_CREATEGROUP_FAIL, -1, 0, 0, 0, '');
    exit;
  end;
  if (who = nil) or (who = self) then begin
    SendDefMessage(SM_CREATEGROUP_FAIL, -2, 0, 0, 0, '');
    exit;
  end;

  //위치 변경(2004/11/18)
  //그룹 안되는 맵 속성 추가(sonmg 2004/10/13)
  if PEnvir.NoGroup then begin
    SysMsg('You cannot organize a group here.', 0);
    exit;
  end;
  //그룹 안되는 맵 속성 추가(sonmg 2004/10/13)
  if who.PEnvir.NoGroup then begin
    SysMsg('The man is in place where cannot join the group.', 0);
    exit;
  end;

  // 2003/07/23
  if (self.LoginSign = False) or (who.LoginSign = False) then begin
    SendDefMessage(SM_CREATEGROUP_FAIL, -2, 0, 0, 0, '');
    exit;
  end;

  if who.GroupOwner <> nil then begin
    SendDefMessage(SM_CREATEGROUP_FAIL, -3, 0, 0, 0, '');
    exit;
  end;
  if not who.AllowGroup then begin
    SendDefMessage(SM_CREATEGROUP_FAIL, -4, 0, 0, 0, '');
    exit;
  end;

  ////////////////////////////////////////////////////////////////
  //40초 이상 경과하면 그룹 요청자와 시간을 초기화 시킨다.(sonmg)
  if (GetTickCount < who.GroupRequestTime) or (GetTickCount -
    who.GroupRequestTime > 40 * 1000) then begin
    who.GroupRequester := '';
  end;

  // 그룹 요청을 받고 있는 중(sonmg)
  if who.GroupRequester <> '' then begin
    SendDefMessage(SM_CREATEGROUP_FAIL, -5, 0, 0, 0, '');
    exit;
  end;

  //그룹 요청자 기록
  who.GroupRequester   := UserName;
  //그룹 요청 받은 시간 기록
  who.GroupRequestTime := GetCurrentTime;

  who.SendDefMessage(SM_CREATEGROUPREQ, 0, 0, 0, 0, UserName);

  ////////////////////////
  exit;       ////////////
  ////////////////////////
  ////////////////////////////////////////////////////////////////

{
   GroupMembers.Clear;
   GroupMembers.AddObject (UserName, self);
   GroupMembers.AddObject (withwho, who);
   EnterGroup (self);
   who.EnterGroup (self);
   AllowGroup := TRUE;

   SendDefMessage (SM_CREATEGROUP_OK, 0, 0, 0, 0, '');
   RefreshGroupMembers;
}
end;

procedure TUserHuman.ServerGetCreateGroupRequestOk(withwho: string);
var
  who: TUserHuman;
begin
  who := UserEngine.GetUserHuman(withwho);
  if who = nil then
    exit;

  if who.GroupOwner <> nil then begin
    who.SendDefMessage(SM_CREATEGROUP_FAIL, -1, 0, 0, 0, '');
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;
  if (who = nil) or (who = self) then begin
    who.SendDefMessage(SM_CREATEGROUP_FAIL, -2, 0, 0, 0, '');
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;

  //위치 변경(2004/11/18)
  //그룹 안되는 맵 속성 추가(sonmg 2004/10/13)
  if who.PEnvir.NoGroup then begin
    who.SysMsg('You cannot organize a group here.', 0);
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;
  //그룹 안되는 맵 속성 추가(sonmg 2004/10/13)
  if PEnvir.NoGroup then begin
    who.SysMsg('The man is in place where cannot join the group.', 0);
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;

  // 2003/07/23
  if (who.LoginSign = False) or (self.LoginSign = False) then begin
    who.SendDefMessage(SM_CREATEGROUP_FAIL, -2, 0, 0, 0, '');
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;

  if who.GroupOwner <> nil then begin
    who.SendDefMessage(SM_CREATEGROUP_FAIL, -3, 0, 0, 0, '');
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;
  if not AllowGroup then begin
    who.SendDefMessage(SM_CREATEGROUP_FAIL, -4, 0, 0, 0, '');
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;

  ////////////////////////////////////////////////////////////////
  // 파라미터로 온 그룹 요청자가 저장된 요청자와 다르면 실패(sonmg)
  if (GroupRequester = '') or (withwho <> GroupRequester) then begin
    who.SendDefMessage(SM_CREATEGROUP_FAIL, -2, 0, 0, 0, '');
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;

  //그룹 요청자 해제
  GroupRequester := '';
  ////////////////////////////////////////////////////////////////

  who.GroupMembers.Clear;
  who.GroupMembers.AddObject(withwho, who);
  who.GroupMembers.AddObject(UserName, self);
  who.EnterGroup(who);
  EnterGroup(who);
  who.AllowGroup := True;

  who.SendDefMessage(SM_CREATEGROUP_OK, 0, 0, 0, 0, '');
  who.RefreshGroupMembers;
end;

procedure TUserHuman.ServerGetCreateGroupRequestFail;
var
  who: TUserHuman;
begin
  who := UserEngine.GetUserHuman(GroupRequester);

  //그룹 요청자 해제
  GroupRequester := '';

  if who = nil then
    exit;

  //그룹 거부 메시지
  who.SysMsg(UserName + ' has refused to join the group.', 3);
end;

//그룹에 참가
procedure TUserHuman.ServerGetAddGroupMember(withwho: string);
var
  who: TUserHuman;
  i:   integer;
begin
  who := UserEngine.GetUserHuman(withwho);
  if GroupOwner <> self then begin
    SendDefMessage(SM_GROUPADDMEM_FAIL, -1, 0, 0, 0, '');
    exit;
  end;
  if GroupMembers.Count >= GROUPMAX then begin
    SendDefMessage(SM_GROUPADDMEM_FAIL, -5, 0, 0, 0, ''); //full
    exit;
  end;

  if (who = nil) or (who = self) then begin
    SendDefMessage(SM_GROUPADDMEM_FAIL, -2, 0, 0, 0, '');
    exit;
  end;
  // 2003/07/23
  if (self.LoginSign = False) or (who.LoginSign = False) then begin
    SendDefMessage(SM_GROUPADDMEM_FAIL, -2, 0, 0, 0, '');
    exit;
  end;

  // 2003/05/02 그룹 중복 버그 패치
  for i := 0 to GroupMembers.Count - 1 do begin // 버그패치
    // PDS -- Nil Check
    if (GroupMembers.Objects[i] = nil) then begin
      svMain.MainOutMessage('ERROR: GROUP MEMBER IS NIL');
    end else begin
      if CompareText(TCreature(GroupMembers.Objects[i]).UserName, who.UserName) =
        0 then begin
        SendDefMessage(SM_GROUPADDMEM_FAIL, -3, 0, 0, 0, ''); //이미 있음
        exit;
      end;
    end;
  end;

  if (who.GroupOwner <> nil) or (who.LoginSign = False) then begin
    SendDefMessage(SM_GROUPADDMEM_FAIL, -3, 0, 0, 0, ''); //이미 있음
    exit;
  end;
  if not who.AllowGroup then begin
    SendDefMessage(SM_GROUPADDMEM_FAIL, -4, 0, 0, 0, '');
    exit;
  end;

  ////////////////////////////////////////////////////////////////
  //40초 이상 경과하면 그룹 요청자와 시간을 초기화 시킨다.(sonmg)
  if (GetTickCount < who.GroupRequestTime) or (GetTickCount -
    who.GroupRequestTime > 40 * 1000) then begin
    who.GroupRequester := '';
  end;

  // 그룹 요청을 받고 있는 중(sonmg)
  if who.GroupRequester <> '' then begin
    SendDefMessage(SM_CREATEGROUP_FAIL, -5, 0, 0, 0, '');
    exit;
  end;

  //그룹 요청자 기록
  who.GroupRequester   := UserName;
  //그룹 요청 받은 시간 기록
  who.GroupRequestTime := GetCurrentTime;

  who.SendDefMessage(SM_ADDGROUPMEMBERREQ, 0, 0, 0, 0, UserName);

  ////////////////////////
  exit;       ////////////
  ////////////////////////
  ////////////////////////////////////////////////////////////////

{
   GroupMembers.AddObject (withwho, who);
   who.EnterGroup (self);
   SendDefMessage (SM_GROUPADDMEM_OK, 0, 0, 0, 0, '');
   RefreshGroupMembers;
}
end;

procedure TUserHuman.ServerGetAddGroupMemberRequestOk(withwho: string);
var
  who: TUserHuman;
  i:   integer;
begin
  who := UserEngine.GetUserHuman(withwho);
  if who = nil then
    exit;

  if who.GroupOwner <> who then begin
    who.SendDefMessage(SM_GROUPADDMEM_FAIL, -1, 0, 0, 0, '');
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;
  if who.GroupMembers.Count >= GROUPMAX then begin
    who.SendDefMessage(SM_GROUPADDMEM_FAIL, -5, 0, 0, 0, ''); //full
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;

  if (who = nil) or (who = self) then begin
    who.SendDefMessage(SM_GROUPADDMEM_FAIL, -2, 0, 0, 0, '');
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;
  // 2003/07/23
  if (who.LoginSign = False) or (self.LoginSign = False) then begin
    who.SendDefMessage(SM_GROUPADDMEM_FAIL, -2, 0, 0, 0, '');
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;

  // 2003/05/02 그룹 중복 버그 패치
  for i := 0 to who.GroupMembers.Count - 1 do begin // 버그패치
    // PDS -- Nil Check
    if (who.GroupMembers.Objects[i] = nil) then begin
      svMain.MainOutMessage('ERROR: GROUP MEMBER IS NIL');
    end else begin
      if CompareText(TCreature(who.GroupMembers.Objects[i]).UserName, UserName) =
        0 then begin
        who.SendDefMessage(SM_GROUPADDMEM_FAIL, -3, 0, 0, 0, ''); //이미 있음
        //그룹 요청자 해제
        GroupRequester := '';
        exit;
      end;
    end;
  end;

  if (GroupOwner <> nil) or (LoginSign = False) then begin
    who.SendDefMessage(SM_GROUPADDMEM_FAIL, -3, 0, 0, 0, ''); //이미 있음
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;
  if not AllowGroup then begin
    who.SendDefMessage(SM_GROUPADDMEM_FAIL, -4, 0, 0, 0, '');
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;

  ////////////////////////////////////////////////////////////////
  // 파라미터로 온 그룹 요청자가 저장된 요청자와 다르면 실패(sonmg)
  if (GroupRequester = '') or (withwho <> GroupRequester) then begin
    who.SendDefMessage(SM_CREATEGROUP_FAIL, -2, 0, 0, 0, '');
    //그룹 요청자 해제
    GroupRequester := '';
    exit;
  end;

  //그룹 요청자 해제
  GroupRequester := '';
  ////////////////////////////////////////////////////////////////

  who.GroupMembers.AddObject(UserName, self);
  EnterGroup(who);
  who.SendDefMessage(SM_GROUPADDMEM_OK, 0, 0, 0, 0, '');
  who.RefreshGroupMembers;
end;

procedure TUserHuman.ServerGetAddGroupMemberRequestFail;
var
  who: TUserHuman;
begin
  who := UserEngine.GetUserHuman(GroupRequester);

  //그룹 요청자 해제
  GroupRequester := '';

  if who = nil then
    exit;

  //그룹 거부 메시지
  who.SysMsg(UserName + ' has refused to join the group.', 3);
end;

procedure TUserHuman.ServerGetDelGroupMember(withwho: string);
var
  i:   integer;
  who: TUserHuman;
begin
  who := UserEngine.GetUserHuman(withwho);
  if GroupOwner <> self then begin
    SendDefMessage(SM_GROUPDELMEM_FAIL, -1, 0, 0, 0, '');
    exit;
  end;
  if who = nil then begin
    SendDefMessage(SM_GROUPDELMEM_FAIL, -2, 0, 0, 0, '');
    exit;
  end;
  if not IsGroupMember(who) then begin
    SendDefMessage(SM_GROUPDELMEM_FAIL, -3, 0, 0, 0, '');
    exit;
  end;
  DelGroupMember(who);
  SendDefMessage(SM_GROUPDELMEM_OK, 0, 0, 0, 0, withwho);
end;

procedure TUserHuman.ServerGetDealTry(withwho: string);
var
  cret: TCreature;
begin
  if BoDealing then
    exit; //이미 거래중
  cret := GetFrontCret;
  if (cret <> nil) and (cret <> self) and (not cret.BoGhost) and (not cret.Death) then
  begin //앞에 누가 있어야하고
    if (cret.GetFrontCret = self) and (not cret.BoDealing) then begin
      //마주보고 있어야하고, 이미 거래중이면 안됨.
      if cret.RaceServer = RC_USERHUMAN then begin
        if cret.BoExchangeAvailable then begin
          if BoGuildAgitDealTry then begin // 장원 거래 시도(sonmg)
            if IsGuildMaster then begin   // 문주이면
              if cret.IsGuildMaster then begin
                //상대방 장원 거래 플래그 체크(sonmg)
                cret.BoGuildAgitDealTry := True;
                // 메시지 박스를 띄운다.
                cret.BoxMsg(UserName +
                  ' and you have begun a transaction of guild territory.', 0);
                BoxMsg(cret.UserName +
                  ' and you have begun a transaction of guild territory.', 0);
                StartDeal(TUserHuman(cret));
                TUserHuman(cret).StartDeal(self);
              end else begin
                cret.SysMsg('Only guild master can use this command.', 0);
                SysMsg('This person is not a guild master.', 0);
                BoGuildAgitDealTry := False;  //장원거래취소.
              end;
            end else begin
              SysMsg('Only guild master can use this command.', 0);
              cret.SysMsg('This person is not a guild master.', 0);
              BoGuildAgitDealTry := False;  //장원거래취소.
            end;
          end else begin
            //교환 다이얼로그 보낸다.
            cret.SysMsg(UserName + ' and you have begun a transaction.', 1);
            SysMsg(cret.UserName + ' and you have begun a transaction.', 1);
            StartDeal(TUserHuman(cret));
            TUserHuman(cret).StartDeal(self);
          end;
        end else
          SysMsg('Trade refused by the opponent.', 1);
      end;
    end else
      SendDefMessage(SM_DEALTRY_FAIL, 0, 0, 0, 0, '');
  end else
    SendDefMessage(SM_DEALTRY_FAIL, 0, 0, 0, 0, '');
end;

procedure TUserHuman.ResetDeal;
var
  i, temp: integer;
  ps:      PTStdItem;
begin
  if DealList.Count > 0 then begin
    for i := DealList.Count - 1 downto 0 do begin
      ps := UserEngine.GetStdItem(PTUserItem(DealList[i]).Index);
      if ps = nil then
        continue;

      //sonmg 추가
      if ps.OverlapItem <= 0 then
        ItemList.Add(DealList[i]); //그래로 위치 이동
    end;
    DealList.Clear;
  end;
  //   Gold := Gold + DealGold;
  IncGold(DealGold);
  DealGold     := 0;
  BoDealSelect := False;
end;

procedure TUserHuman.StartDeal(who: TUserHuman);
begin
  BoDealing := True;
  DealCret  := who;
  ResetDeal;
  if BoGuildAgitDealTry then begin
    SendDefMessage(SM_GUILDAGITDEALMENU, 0, 0, 0, 0, who.UserName);
  end else begin
    SendDefMessage(SM_DEALMENU, 0, 0, 0, 0, who.UserName);
  end;
  DealItemChangeTime := GetTickCount;
end;

procedure TUserHuman.BrokeDeal;
var
  pu, pu_org: PTUserItem;
  ps, ps_org: PTStdItem;
  i, j: integer;
begin
  if BoDealing then begin
    BoDealing := False;
    SendDefMessage(SM_DEALCANCEL, 0, 0, 0, 0, '');

    ///////////////////////
    // sonmg 추가.
    if DealList.Count > 0 then begin
      for i := DealList.Count - 1 downto 0 do begin
        pu := PTUserItem(DealList[i]);
        ps := UserEngine.GetStdItem(pu.Index);
        if ps = nil then
          continue;

        // 2003/12/22 갑작스런 버그 패치
        // 가방이 꽉 차있고 거래 취소된 아이템이 카운트 아이템이면...(sonmg)
        if (ps.OverlapItem >= 1) then begin
          // 가방창에 있는 해당 아이템에 카운트를 합산한다.
          if UserCounterItemAdd(ps.StdMode, ps.Looks, pu.Dura, ps.Name, True) then
          begin

{
               // 가방창을 검색해서 같은 이름을 찾아낸다.
               for j:=0 to ItemList.Count-1 do begin
                  pu_org := PTUserItem(ItemList[j]);
                  ps_org := UserEngine.GetStdItem (pu_org.Index);
                  if ps_org <> nil then begin
                     // 아이템 이름이 같으면...
                     if CompareText(ps_org.Name, ps.Name) = 0 then begin
                        // 그 아이템에 카운트를 합친다.
                        pu_org.Dura := pu_org.Dura + pu.Dura;  // 카운트 통합
                        SendMsg(self, RM_COUNTERITEMCHANGE, 0, pu_org.MakeIndex, pu_org.Dura, 0, ps_org.Name);
                        break;
                     end;
                  end;
               end;
}

            // 해당 이름의 아이템이 없거나 실패했으면 아이템 리스트에 새로 추가.
            // 주의 : 가방이 가득찼을때는...
            // (예 : 카운트 아이템의 MAX를 올렸을 경우)
            //               if j = ItemList.Count then begin
          end else begin
            ItemList.Add(DealList[i]); //그래로 위치 이동
            SendAddItem(TUserItem(DealList[i]^));
          end;
        end;
      end;
    end;
    ///////////////////////

    if DealCret <> nil then begin
      TUserHuman(DealCret).DealCret := nil;
      if DealCret <> nil then
        TUserHuman(DealCret).BrokeDeal;
    end;
    DealCret := nil;
    ResetDeal;
    SysMsg('Trade cancelled .', 1);
    DealItemChangeTime := GetTickCount;

    BoGuildAgitDealTry := False;  //장원거래취소.
  end;
end;

procedure TUserHuman.ServerGetDealCancel;
begin
  BrokeDeal;
end;

procedure TUserHuman.AddDealItem(uitem: TUserItem; remain: integer);
var
  citem: TClientItem;
  ps:    PTStdItem;
  std:   TStdItem;
begin
  SendDefMessage(SM_DEALADDITEM_OK, uitem.MakeIndex, remain, 0, 0, '');
  if DealCret <> nil then begin
    ps := UserEngine.GetStdItem(uitem.Index);
    if ps <> nil then begin
      std     := ps^;
      citem.UpgradeOpt := ItemMan.GetUpgradeStdItem(uitem, std);
      citem.S := std;
      citem.MakeIndex := uitem.MakeIndex;
      citem.Dura := uitem.Dura;
      citem.DuraMax := uitem.DuraMax;
    end;
    Def := MakeDefaultMsg(SM_DEALREMOTEADDITEM, integer(self), 0, 0, 1);
    TUserHuman(DealCret).SendSocket(@Def, EncodeBuffer(@citem, sizeof(TClientItem)));
    TUserHuman(DealCret).DealItemChangeTime := GetTickCount;
    DealItemChangeTime := GetTickCount;
  end;
end;

procedure TUserHuman.DelDealItem(uitem: TUserItem);
var
  citem: TClientItem;
  ps:    PTStdItem;
begin
  SendDefMessage(SM_DEALDELITEM_OK, 0, 0, 0, 0, '');
  if DealCret <> nil then begin
    ps := UserEngine.GetStdItem(uitem.Index);
    if ps <> nil then begin
      citem.S    := ps^;
      citem.UpgradeOpt := 0;
      citem.MakeIndex := uitem.MakeIndex;
      citem.Dura := uitem.Dura;
      citem.DuraMax := uitem.DuraMax;
    end;
    Def := MakeDefaultMsg(SM_DEALREMOTEDELITEM, integer(self), 0, 0, 1);
    TUserHuman(DealCret).SendSocket(@Def, EncodeBuffer(@citem, sizeof(TClientItem)));
    TUserHuman(DealCret).DealItemChangeTime := GetTickCount;
    DealItemChangeTime := GetTickCount;
  end;
end;

procedure TUserHuman.AddDealCounterItem(uitem: TUserItem; remain: integer);
var
  i:     integer;
  puAdd: PTUserItem;
  ps, psAdd: PTStdItem;
begin
  puAdd := nil;
  psAdd := nil;

  if DealCret <> nil then begin
    psAdd := UserEngine.GetStdItem(uitem.Index);
    if psAdd <> nil then begin
      for i := 0 to DealList.Count - 1 do begin
        ps := UserEngine.GetStdItem(PTUserItem(DealList[i]).Index);

        if ps = nil then
          continue;
        if ps.OverlapItem = 0 then
          continue;
        if (ps.StdMode = psAdd.StdMode) and (ps.Looks = psAdd.Looks) and
          (ps.OverlapItem >= 1) then begin
          if CompareText(ps.Name, psAdd.Name) = 0 then begin
            puAdd := PTUserItem(DealList[i]);
            break;
          end;
        end;
      end;

      if puAdd <> nil then begin
        Def := MakeDefaultMsg(SM_COUNTERITEMCHANGE, puAdd.MakeIndex,
          puAdd.Dura, 0, 0);
        TUserHuman(DealCret).SendSocket(@Def, EncodeString(psAdd.Name));

        TUserHuman(DealCret).DealItemChangeTime := GetTickCount;
        DealItemChangeTime := GetTickCount;
      end;
    end;
  end;
end;

procedure TUserHuman.DelDealCounterItem(uitem: TUserItem);
var
  ps: PTStdItem;
begin
  if DealCret <> nil then begin
    ps := UserEngine.GetStdItem(uitem.Index);
    if ps <> nil then begin

      Def := MakeDefaultMsg(SM_COUNTERITEMCHANGE, uitem.MakeIndex, uitem.Dura, 0, 0);
      TUserHuman(DealCret).SendSocket(@Def, EncodeString(ps.Name));

      TUserHuman(DealCret).DealItemChangeTime := GetTickCount;
      DealItemChangeTime := GetTickCount;
    end;
  end;
end;


function TUserHuman.IsReservedMakingSlave: boolean;
var
  i:    integer;
  pmsg: PTMessageInfoPtr;
begin
  Result := False;
  // 2003/06/12 슬레이브 패치
  if PrevServerSlaves.Count > 0 then   //소환 해야할 부하가 있음
    Result := True;
    {
    for i:=0 to MsgList.Count-1 do begin
       pmsg := MsgList[i];
       if pmsg.Ident = RM_MAKE_SLAVE then begin
          Result := TRUE;
          break;
       end;
    end;
    }
end;


procedure TUserHuman.ServerGetDealAddItem(iidx, Count: integer; iname: string);
var
  i, k, iOldCount: integer;
  flag:  boolean;
  pstd, psDeal: PTStdItem;
  newpu: PTUserItem;
  iRet:  integer;
begin
  iRet := 0;

  //교환 상대가 앞에 있는지, 없으면 거래 취소
  if (DealCret <> nil) then begin
    if pos(' ', iname) >= 0 then
      GetValidStr3(iname, iname, [' ']);
    flag := False;
    if not DealCret.BoDealSelect then
      for i := 0 to ItemList.Count - 1 do begin
        pstd := UserEngine.GetStdItem(PTUserItem(ItemList[i]).Index);
        if pstd <> nil then begin   //교환이 안되는 이벤트 아이템은 제외
          if (pstd.UniqueItem and $08) <> 0 then
            continue;
          //UNIQUEITEM 필드가 00001000(2진수)를 포함하면 교환할 수 없는 아이템(sonmg 2005/03/14)
          if pstd.StdMode <> TAIWANEVENTITEM then begin
            if PTUserItem(ItemList[i]).MakeIndex = iidx then
              if CompareText(UserEngine.GetStdItemName(
                PTUserItem(ItemList[i]).Index), iname) = 0 then begin
                if DealList.Count < MAXDEALITEM then begin
                  //카운트 아이템.
                  if pstd.OverlapItem >= 1 then begin
                    if (Count > 0) and (Count <= MAX_OVERLAPITEM) then begin
                      psDeal    :=
                        UserEngine.GetStdItem(PTUserItem(ItemList[i]).Index);
                      iOldCount := PTUserItem(ItemList[i]).Dura;

                      iRet :=
                        UserCounterDealItemAdd(psDeal.StdMode,
                        psDeal.Looks, Count, psDeal.Name);
                      if iRet = 1 then begin  // Success
                        //Deal창에 해당 카운트 아이템이 있으면...
                        // 일부 추가
                        if iOldCount - Count > 0 then begin
                          //가방 창에 있는 아이템의 Count를 감소시킨다.
                          PTUserItem(ItemList[i]).Dura := iOldCount - Count;
                          AddDealCounterItem(PTUserItem(ItemList[i])^, 0);
                          // 전부 추가
                        end else if iOldCount - Count = 0 then begin
                          AddDealCounterItem(PTUserItem(ItemList[i])^, 0);
                          //가방 창에 있는 아이템 삭제
                          ItemList.Delete(i);
                        end else begin
                        end;

                        flag := True;
                        CalcBagWeight;
                        break;
                        // MAX_OVERFLOW를 넘었을 때
                      end else if iRet = 2 then begin  // Overflow
                        flag := False;
                        break;
                        // 최대 아이템 개수를 넘었을 때
                      end else if iRet = 3 then begin  // OverCount
                        flag := False;
                        SysMsg('The maximum count is ' +
                          IntToStr(MAX_OVERLAPITEM) + '.', 0);
                        break;
                      end else begin
                        //DealList에 해당 카운트 아이템이 없으면...
                        // 처음 일부 추가
                        if iOldCount - Count > 0 then begin
                          new(newpu);
                          if UserEngine.CopyToUserItemFromName(iname,
                            newpu^) then begin
                            newpu.Dura := Count;
                            DealList.Add(newpu);
                            PTUserItem(ItemList[i]).Dura :=
                              iOldCount - Count;
                            AddDealItem(newpu^, iOldCount - Count);
                          end else begin
                            Dispose(newpu);
                          end;
                          // 처음 전부 추가
                        end else if iOldCount - Count = 0 then begin
                          DealList.Add(ItemList[i]);
                          AddDealItem(PTUserItem(ItemList[i])^, 0);
                          ItemList.Delete(i);
                        end;
                      end;
                    end else begin
                      // count가 MAX_OVERLAPITEM보다 크면 메시지 보냄.
                      if Count > MAX_OVERLAPITEM then
                        SysMsg('The maximum count is ' +
                          IntToStr(MAX_OVERLAPITEM), 0);

                      // count가 0 이하이면 메시지를 보이지 않고 그냥 빠져나감.
                      break;
                    end;
                    //일반 아이템.
                  end else begin
                    DealList.Add(ItemList[i]);
                    AddDealItem(PTUserItem(ItemList[i])^, 0);
                    ItemList.Delete(i);
                  end;
                  flag := True;
                  CalcBagWeight;
                  break;
                end;
              end;
          end;
        end;
      end;
    if not flag then
      SendDefMessage(SM_DEALADDITEM_FAIL, 0, 0, 0, 0, '');
  end;
end;

procedure TUserHuman.ServerGetDealDelItem(iidx: integer; iname: string);
var
  i, temp: integer;
  flag:    boolean;
  pu:      PTUserItem;
  ps:      PTStdItem;
begin
  //교환 상대가 앞에 있는지, 없으면 거래 취소
  if (DealCret <> nil) then begin
    if pos(' ', iname) >= 0 then
      GetValidStr3(iname, iname, [' ']);
    flag := False;
    if not DealCret.BoDealSelect then
      for i := 0 to DealList.Count - 1 do begin
        pu := PTUserItem(DealList[i]);
        if pu.MakeIndex = iidx then
          if CompareText(UserEngine.GetStdItemName(pu.Index), iname) = 0 then
          begin
            ps := UserEngine.GetStdItem(pu.Index);
            if ps <> nil then begin
              //카운트 아이템.
              if ps.OverlapItem >= 1 then begin
                // 같은 종류의 최소 개수 아이템에 합산.
                // 들고 있는 아이템은 최소 개수 아이템 검사에서 제외.
                if UserCounterItemAdd(ps.StdMode, ps.Looks,
                  pu.Dura, ps.Name, True, pu.MakeIndex) then begin
                  DelDealItem(pu^);
                  DealList.Delete(i);
                  flag := True;
                  break;
                end else begin
                  ItemList.Add(DealList[i]); //그래로 위치 이동
                  SendAddItem(TUserItem(DealList[i]^));
                  DelDealItem(pu^);
                  DealList.Delete(i);
                  flag := True;
                  break;
                end;
              end else begin
                ItemList.Add(DealList[i]);
                DelDealItem(pu^);
                DealList.Delete(i);
                flag := True;
                break;
              end;
            end;
          end;
      end;
    if not flag then
      SendDefMessage(SM_DEALDELITEM_FAIL, 0, 0, 0, 0, '');
  end;
end;

procedure TUserHuman.ServerGetDealChangeGold(dgold: integer);
var
  flag: boolean;
begin
  // sonmg 2005/06/22
  if not BoDealing then
    exit;

  if dgold < 0 then begin
    SendDefMessage(SM_DEALCHGGOLD_FAIL, DealGold, Loword(Gold), Hiword(Gold), 0, '');
    exit;
  end;

  if DealGold > 0 then begin
    boxmsg('You cannot change the gold in trade.', 1);
    exit;
  end;

  flag := False;
  if (GetFrontCret = DealCret) and (DealCret <> nil) and
    (UserName <> DealCret.UserName) then
    if not DealCret.BoDealSelect then begin //상대방이 선택 완료
      if self.Gold + DealGold >= dgold then begin
        //            self.Gold := (self.Gold + DealGold) - dgold;
        self.IncGold(DealGold);
        self.DecGold(dgold);
        DealGold := dgold;
        SendDefMessage(SM_DEALCHGGOLD_OK, DealGold, Loword(Gold),
          Hiword(Gold), 0, '');
        if DealCret <> nil then begin
          TUserHuman(DealCret).SendDefMessage(SM_DEALREMOTECHGGOLD,
            DealGold, 0, 0, 0, '');
          TUserHuman(DealCret).DealItemChangeTime := GetTickCount;
        end;
        flag := True;
        DealItemChangeTime := GetTickCount;
      end;
    end;
  if not flag then
    SendDefMessage(SM_DEALCHGGOLD_FAIL, DealGold, Loword(Gold), Hiword(Gold), 0, '');
end;

procedure TUserHuman.ServerGetDealEnd;
var
  i, temp, j: integer;
  pu, pu_org: PTUserItem;
  ps, ps_org: PTStdItem;
  flag: boolean;
  agitnumber: integer;
begin
  BoDealSelect := True; //교환 버튼을 누름
  if DealCret <> nil then begin
    if (GetTickCount - DealItemChangeTime < 1000) or
      (GetTickCount - DealCret.DealItemChangeTime < 1000) then begin
      //거래 직전 1초이전에 물건의 이동이 있었음.
      SysMsg('You pressed the confirm the button too early.', 0);
      BrokeDeal;  //거래가 취소
      exit;
    end;
    if DealCret.BoDealSelect then begin //둘다 누름, 교환 시작..
      flag := True;
      //내가 교환품을 받을 만큼 가방에 룸이 있는지 검사..
      if MAXBAGITEM - Itemlist.Count < TUserHuman(DealCret).DealList.Count then
        flag := False;
      if AvailableGold - Gold < TUserHuman(DealCret).DealGold then
        flag := False;
      //상대가 교환품을 받을 만큼 가방에 룸이 있는지 검사..
      if MAXBAGITEM - TUserHuman(DealCret).Itemlist.Count < DealList.Count then
        flag := False;
      if TUserHuman(DealCret).AvailableGold - TUserHuman(DealCret).Gold <
        DealGold then
        flag := False;

      if flag then begin
        //장원 거래.
        if BoGuildAgitDealTry then begin
          agitnumber := ExecuteGuildAgitTrade;
          if agitnumber > -1 then begin
            //로그남김
            AddUserLog('41'#9 + //장거래_
              MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
              ''#9 + UserName + ''#9 + TGuild(MyGuild).GuildName +
              ''#9 + IntToStr(agitnumber) + ''#9 + '1'#9 + DealCret.UserName);
            //                              TGuild(DealCret.MyGuild).GuildName);

            UserEngine.SendInterMsg(ISM_RELOADGUILDAGIT, ServerIndex, '');
            BoGuildAgitDealTry := False;  //장원거래완료.
          end else begin
            BrokeDeal;  //거래가 취소
            exit;
          end;
        end;

        //내 교환품을 상대에게 줌.
        for i := 0 to DealList.Count - 1 do begin
          pu := PTUserItem(DealList[i]);
          TUserHuman(DealCret).AddItem(pu);
          TUserHuman(DealCret).SendAddItem(pu^);
          ps := UserEngine.GetStdItem(pu.Index);
          if ps <> nil then begin
            //로그남김
            if not IsCheapStuff(ps.StdMode) then
              AddUserLog('8'#9 + //교환_ +
                MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
                ''#9 + UserName + ''#9 + UserEngine.GetStdItemName(pu.Index) +
                ''#9 + IntToStr(pu.MakeIndex) + ''#9 + '1'#9 +
                DealCret.UserName);
          end;
        end;
        if DealGold > 0 then begin
          //               DealCret.Gold := DealCret.Gold + DealGold;
          DealCret.IncGold(DealGold);
          DealCret.GoldChanged;
          //로그남김
          AddUserLog('8'#9 + //교환_ +
            MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
            ''#9 + UserName + ''#9 + NAME_OF_GOLD{'금전'} + ''#9 +
            IntToStr(DealGold) + ''#9 + '1'#9 + DealCret.UserName);
        end;
        //상대의 교환품을 갖는다.
        for i := 0 to DealCret.DealList.Count - 1 do begin
          pu := PTUserItem(DealCret.DealList[i]);
          AddItem(pu);
          SendAddItem(pu^);
          ps := UserEngine.GetStdItem(pu.Index);
          if ps <> nil then begin
            //로그남김
            if not IsCheapStuff(ps.StdMode) then
              AddUserLog('8'#9 + //교환_ +
                DealCret.MapName + ''#9 + IntToStr(DealCret.CX) +
                ''#9 + IntToStr(DealCret.CY) + ''#9 + DealCret.UserName +
                ''#9 + UserEngine.GetStdItemName(pu.Index) +
                ''#9 + IntToStr(pu.MakeIndex) + ''#9 + '1'#9 + UserName);
          end;
        end;
        if DealCret.DealGold > 0 then begin
          //               Gold := Gold + DealCret.DealGold;
          IncGold(DealCret.DealGold);
          GoldChanged;
          //로그남김
          AddUserLog('8'#9 + //교환_ +
            DealCret.MapName + ''#9 + IntToStr(DealCret.CX) +
            ''#9 + IntToStr(DealCret.CY) + ''#9 + DealCret.UserName +
            ''#9 + NAME_OF_GOLD{'금전'} + ''#9 + IntToStr(DealCret.DealGold) +
            ''#9 + '1'#9 + UserName);
        end;


        with TUserHuman(DealCret) do begin
          SendDefMessage(SM_DEALSUCCESS, 0, 0, 0, 0, '');
          SysMsg('Trading done successfully  .', 1);
          DealCret  := nil;
          BoDealing := False;
          DealList.Clear;
          DealGold := 0;
          WeightChanged; //무게 변동 반영(2004/08/30)
        end;
        SendDefMessage(SM_DEALSUCCESS, 0, 0, 0, 0, '');
        SysMsg('Trading done successfully  .', 1);
        DealCret  := nil;
        BoDealing := False;
        DealList.Clear;
        DealGold := 0;
        WeightChanged; //무게 변동 반영(2004/08/30)
      end else begin
        BrokeDeal;  //거래가 취소
      end;
    end else begin
      SysMsg('You asked opponent to confirm.', 1);
      DealCret.SysMsg(
        'Your opponent is asking for confirmation. Make sure everything is ok and then press  [Deal] button.',
        1);
    end;
  end;
end;

procedure TUserHuman.ServerGetWantMiniMap;
var
  i, mini: integer;
begin
  mini := PEnvir.MiniMap;

  if mini > 0 then
    SendDefMessage(SM_READMINIMAP_OK, 0, mini, 0, 0, '')
  else
    SendDefMessage(SM_READMINIMAP_FAIL, 0, 0, 0, 0, '');
end;

procedure TUserHuman.SendChangeGuildName;
begin
  if MyGuild <> nil then begin
    SendDefMessage(SM_CHANGEGUILDNAME, 0, 0, 0, 0, TGuild(MyGuild).GuildName +
      '/' + GuildRankName);
  end else
    SendDefMessage(SM_CHANGEGUILDNAME, 0, 0, 0, 0, '');
end;

procedure TUserHuman.ServerGetQueryUserState(who: TCreature; xx, yy: integer);
var
  i:      integer;
  ustate: TUserStateInfo;
  ps:     PTStdItem;
  std:    TStdItem;
  citem:  TClientItem;
  backupWho: TCreature;
  opt:    integer;
begin
  try
    if CretInNearXY(who, xx, yy) then begin
      backupWho := who;

      //분신
      if (who.RaceServer = RC_CLONE) and (Who.Master <> nil) then begin
        if (Who.Master.RaceServer = RC_USERHUMAN) then begin
          backupWho := Who.Master;
        end else begin
          MainOutMessage('ERROR WANT STATE NOT HUMAN');
          Exit;
        end;
      end;

      FillChar(ustate, sizeof(TUserStateInfo), #0);
      ustate.Feature   := backupwho.GetRelFeature(self);
      ustate.UserName  := backupwho.UserName;
      ustate.NameColor := GetThisCharColor(backupwho);
      if backupwho.MyGuild <> nil then
        ustate.GuildName := TGuild(backupwho.MyGuild).GuildName;
      ustate.GuildRankName := backupwho.GuildRankName;
      ustate.bExistLover := boolean(TUserHuman(backupwho).fLover.GetLoverCount);
      //연인 상태
      ustate.LoverName   := TUserHuman(backupwho).fLover.GetLoverName;  //연인 이름

      // 2003/03/15 아이템 인벤토리 확장
      for i := 0 to 12 do begin    // 8->12
        if backupwho.UseItems[i].Index > 0 then begin
          ps := UserEngine.GetStdItem(backupwho.UseItems[i].Index);
          if ps <> nil then begin
            std := ps^;
            opt := ItemMan.GetUpgradeStdItem(backupwho.UseItems[i], std);
            Move(std, citem.S, sizeof(TStdItem));
            citem.MakeIndex := backupwho.UseItems[i].MakeIndex;
            citem.Dura      := backupwho.UseItems[i].Dura;
            citem.DuraMax   := backupwho.UseItems[i].DuraMax;
            citem.UpgradeOpt := opt;

            //천의무봉
            if (i = U_DRESS) then
              backupwho.ChangeItemWithLevel(citem, backupwho.Abil.Level);

            //용아이템일 경우 능력치가 바뀐다.
            backupwho.ChangeItemByJob(citem, backupwho.Abil.Level);

            ustate.UseItems[i] := citem;
          end;
        end;
      end;
      Def := MakeDefaultMsg(SM_SENDUSERSTATE, 0, 0, 0, 1);
      SendSocket(@Def, EncodeBuffer(@ustate, sizeof(TUserStateInfo)));
    end;

  except
    MainOutMessage('EXCEPT : ServerQueryUserState');
  end;

end;

procedure TUserHuman.ServerGetOpenGuildDlg;
var
  i:    integer;
  Data: string;
begin
  if MyGuild <> nil then begin
    Data := TGuild(MyGuild).GuildName + #13;
    Data := Data + ' '#13; //문파깃말 파일 이름
    if GuildRank = 1 then
      Data := Data + '1'#13  //문주
    else
      Data := Data + '0'#13;  //일반

    //NoticeList
    Data := Data + '<Notice>'#13;
    if TGuild(MyGuild).NoticeList <> nil then
      for i := 0 to TGuild(MyGuild).NoticeList.Count - 1 do begin
        if Length(Data) > 5000 then
          break;
        Data := Data + TGuild(MyGuild).NoticeList[i] + #13;
      end;
    //KillGuilds
    Data := Data + '<KillGuilds>'#13;
    if TGuild(MyGuild).KillGuilds <> nil then
      for i := 0 to TGuild(MyGuild).KillGuilds.Count - 1 do begin
        if Length(Data) > 5000 then
          break;
        Data := Data + TGuild(MyGuild).KillGuilds[i] + #13;
      end;
    //AllyGuilds
    Data := Data + '<AllyGuilds>'#13;
    if TGuild(MyGuild).AllyGuilds <> nil then
      for i := 0 to TGuild(MyGuild).AllyGuilds.Count - 1 do begin
        if Length(Data) > 5000 then
          break;
        Data := Data + TGuild(MyGuild).AllyGuilds[i] + #13;
      end;

    Def := MakeDefaultMsg(SM_OPENGUILDDLG, 0, 0, 0, 1);
    SendSocket(@Def, EncodeString(Data));
  end else
    SendDefMessage(SM_OPENGUILDDLG_FAIL, 0, 0, 0, 0, '');
end;

procedure TUserHuman.ServerGetGuildHome;
begin
  ServerGetOpenGuildDlg;
end;

procedure TUserHuman.ServerGetGuildMemberList;
var
  i, k:   integer;
  Data:   string;
  pgrank: PTGuildRank;
begin
  if MyGuild <> nil then begin
    Data := '';
    if TGuild(MyGuild).MemberList <> nil then begin
      for i := 0 to TGuild(MyGuild).MemberList.Count - 1 do begin
        pgrank := TGuild(MyGuild).MemberList[i];
        Data   := Data + '#' + IntToStr(pgrank.Rank) + '/*' + pgrank.RankName + '/';
        for k := 0 to pgrank.MemList.Count - 1 do begin
          if Length(Data) > 5000 then
            break;
          Data := Data + pgrank.MemList[k] + '/';
        end;
      end;
    end;

    Def := MakeDefaultMsg(SM_SENDGUILDMEMBERLIST, 0, 0, 0, 1);
    SendSocket(@Def, EncodeString(Data));
  end;
end;

procedure TUserHuman.ServerGetGuildAddMember(who: string);
var
  error: integer;
  hum:   TUserHuman;
begin
  error := 1; //문주만 사용가능
  if IsGuildMaster then begin  //문주만 가능
    hum := UserEngine.GetUserHuman(who);
    if hum <> nil then begin
      if hum.GetFrontCret = self then begin
        if hum.AllowEnterGuild then begin
          if not TGuild(MyGuild).IsMember(who) then begin
            if (hum.MyGuild = nil) and  //가입문파 없을 때
              (TGuild(MyGuild).MemberList.Count < MAXGUILDMEMBER)  //인원 제한
            then begin
              TGuild(MyGuild).AddMember(hum);
              UserEngine.SendInterMsg(ISM_RELOADGUILD, ServerIndex,
                TGuild(MyGuild).GuildName);

              //새 맵버를 문파에 가입시킴
              hum.MyGuild := MyGuild;
              hum.GuildRankName :=
                TGuild(MyGuild).MemberLogin(hum, hum.GuildRank);
              //hum.SendMsg (self, RM_CHANGEGUILDNAME, 0, 0, 0, 0, '');

              ChangeNameColor;  //이름색 업데이트(sonmg 2004/12/29)
              error := 0;
            end else
              error := 4;  //다른 문파에 가입되어 있음.
          end else
            error := 3; //이미 가입되어 있음.
        end else begin
          error := 5; //상대방이 문파 가입을 허용안함.
          hum.SysMsg(
            'You refused to join the Guild . [command to change permission status: @AllowGuild]',
            0);
        end;
      end else
        error := 2;
    end else
      error := 2; //접속하고 마주보고 있어야 함.
  end;
  if error = 0 then
    SendDefMessage(SM_GUILDADDMEMBER_OK, 0, 0, 0, 0, '')
  else
    SendDefMessage(SM_GUILDADDMEMBER_FAIL, error, 0, 0, 0, '');
end;

procedure TUserHuman.ServerGetGuildDelMember(who: string);
var
  error: integer;
  hum:   TUserHuman;
  gname: string;
begin
  error := 1; //문주만 사용가능
  if IsGuildMaster then begin  //문주만 가능
    if TGuild(MyGuild).IsMember(who) then begin
      if self.UserName <> who then begin
        if TGuild(MyGuild).DelMember(who) then begin
          hum := UserEngine.GetUserHuman(who);
          if hum <> nil then begin
            hum.MyGuild := nil;
            hum.GuildRankChanged(0, '');
          end;
          UserEngine.SendInterMsg(ISM_RELOADGUILD, ServerIndex,
            TGuild(MyGuild).GuildName);
          error := 0;
        end else
          error := 4; //할 수 없음.
      end else begin
        error := 3; //문주 본인은 탈퇴 안됨.
        //문주본인이 탈퇴하려면 문원이 아무도 없는상태에서 자신을 빼면됨, 문파도 깨짐
        gname := TGuild(MyGuild).GuildName;
        if TGuild(MyGuild).DelGuildMaster(who) then begin
          GuildMan.DelGuild(gname);  //문파가 사라진다.
          UserEngine.SendInterMsg(ISM_DELGUILD, ServerIndex, gname);
          //UserEngine.SendInterMsg (ISM_RELOADGUILD, ServerIndex, TGuild(MyGuild).GuildName);
          MyGuild := nil;
          GuildRankChanged(0, '');
          SysMsg('"' + gname + '" Guild has been removed.', 0);
          error := 0;
        end;
      end;
    end else
      error := 2; //문원이 아님
  end;
  if error = 0 then begin
    SendDefMessage(SM_GUILDDELMEMBER_OK, 0, 0, 0, 0, '');
  end else
    SendDefMessage(SM_GUILDDELMEMBER_FAIL, error, 0, 0, 0, '');
end;

procedure TUserHuman.ServerGetGuildUpdateNotice(body: string);
var
  Data: string;
begin
  if MyGuild = nil then
    exit;
  if GuildRank <> 1 then
    exit; //문파의 문주만 변경 가능

  TGuild(MyGuild).NoticeList.Clear;

  while True do begin
    if body = '' then
      break;
    body := GetValidStr3(body, Data, [#13]);
    TGuild(MyGuild).NoticeList.Add(Data);
  end;
  TGuild(MyGuild).SaveGuild;
  UserEngine.SendInterMsg(ISM_RELOADGUILD, ServerIndex, TGuild(MyGuild).GuildName);

  ServerGetOpenGuildDlg;
end;

procedure TUserHuman.ServerGetGuildUpdateRanks(body: string);
var
  error: integer;
begin
  if MyGuild = nil then
    exit;
  if GuildRank <> 1 then
    exit; //문파의 문주만 변경 가능

  error := TGuild(MyGuild).UpdateGuildRankStr(body);
  if error = 0 then begin
    UserEngine.SendInterMsg(ISM_RELOADGUILD, ServerIndex, TGuild(MyGuild).GuildName);
    ServerGetGuildMemberList;
  end else if error <= -2 then
    SendDefMessage(SM_GUILDRANKUPDATE_FAIL, error, 0, 0, 0, '');
  //-1: 이전과 같음.. 처리하지 않는다.
end;

//상대편 문주와 마주보고
procedure TUserHuman.ServerGetGuildMakeAlly;
var
  error: integer;
  hum:   TUserHuman;
begin
  error := -1; //문주만 사용가능
  hum   := TUserHuman(GetFrontCret);
  if hum <> nil then begin
    if hum.RaceServer = RC_USERHUMAN then begin
      if hum.GetFrontCret = self then begin  //얼굴을 마주보고 있는지
        if TGuild(hum.MyGuild).AllowAllyGuild then begin
          if IsGuildMaster and hum.IsGuildMaster then begin  //문주만 가능
            if TGuild(MyGuild).CanAlly(TGuild(hum.MyGuild)) and
              TGuild(hum.MyGuild).CanAlly(TGuild(MyGuild)) then begin
              //동맹 조건 충족
              TGuild(MyGuild).MakeAllyGuild(TGuild(hum.MyGuild));
              TGuild(hum.MyGuild).MakeAllyGuild(TGuild(MyGuild));
              TGuild(MyGuild).GuildMsg(TGuild(hum.MyGuild).GuildName +
                'allied with ');
              TGuild(hum.MyGuild).GuildMsg(TGuild(MyGuild).GuildName +
                'allied with ');

              TGuild(MyGuild).MemberNameChanged;
              TGuild(hum.MyGuild).MemberNameChanged;

              //다른 서버에 적용
              UserEngine.SendInterMsg(ISM_RELOADGUILD, ServerIndex,
                TGuild(MyGuild).GuildName);
              UserEngine.SendInterMsg(ISM_RELOADGUILD, ServerIndex,
                TGuild(hum.MyGuild).GuildName);
              error := 0;
            end else
              error := -2;  //동맹 실패
          end else
            error := -3;  //문주끼리 마주보고 해야 한다.
        end else
          error := -4;  //상대가 동맹을 허용하지 않고 있음.
      end;
    end;
  end;
  if error = 0 then  //성공
    SendDefMessage(SM_GUILDMAKEALLY_OK, 0, 0, 0, 0, '')
  else
    SendDefMessage(SM_GUILDMAKEALLY_FAIL, error, 0, 0, 0, '');
end;

procedure TUserHuman.ServerGetGuildBreakAlly(gname: string);
var
  aguild: TGuild;
  error:  integer;
begin
  error := -1;
  if IsGuildMaster then begin
    aguild := GuildMan.GetGuild(gname);
    if aguild <> nil then begin
      if TGuild(MyGuild).IsAllyGuild(aguild) then begin
        TGuild(MyGuild).BreakAlly(aguild);
        aguild.BreakAlly(TGuild(MyGuild));
        TGuild(MyGuild).GuildMsg(aguild.GuildName + ' broke the alliance with ');
        aguild.GuildMsg(TGuild(MyGuild).GuildName + ' broke the alliance.');

        TGuild(MyGuild).MemberNameChanged;
        aguild.MemberNameChanged;

        //다른 서버에 적용
        UserEngine.SendInterMsg(ISM_RELOADGUILD, ServerIndex,
          TGuild(MyGuild).GuildName);
        UserEngine.SendInterMsg(ISM_RELOADGUILD, ServerIndex, aguild.GuildName);
        error := 0;
      end else
        error := -2;  //동맹중 아님
    end else
      error := -3; //그런 문파 없음
  end;
  if error = 0 then  //성공
    SendDefMessage(SM_GUILDBREAKALLY_OK, 0, 0, 0, 0, '')
  else
    SendDefMessage(SM_GUILDBREAKALLY_FAIL, error, 0, 0, 0, '');
end;

procedure TUserHuman.ServerGetAdjustBonus(remainbonus: integer; bodystr: string);

  function CalcLoHi(abil, point: word): word;
  var
    i, lo, hi: integer;
  begin
    lo := Lobyte(abil);
    hi := Hibyte(abil);
    for i := 1 to point do begin
      if lo + 1 < hi then
        Inc(lo)
      else
        Inc(hi);
    end;
    Result := MakeWord(lo, hi);
  end;

var
  cha: TNakedAbility;
  sum: integer;
  ptk: PTNakedAbility;
begin
{$IFDEF FOR_ABIL_POINT}
//4/16일부터 적용
   if (remainbonus >= 0) and (remainbonus < BonusPoint) then begin
      DecodeBuffer (bodystr, @cha, sizeof(TNakedAbility));
      //검증...
      sum := cha.DC + cha.MC + cha.SC + cha.AC + cha.MAC + cha.HP + cha.MP + cha.Hit + cha.Speed;
      ptk := nil;
      case Job of
         0: ptk := @WarriorBonus;
         1: ptk := @WizzardBonus;
         2: ptk := @PriestBonus;
         3: ptk := @KillerBonus;
      end;
      if (ptk <> nil) and (sum = (BonusPoint - remainbonus)) then begin
         BonusPoint := remainbonus;
         CurBonusAbil.DC := CurBonusAbil.DC + cha.DC;
         CurBonusAbil.MC := CurBonusAbil.MC + cha.MC;
         CurBonusAbil.SC := CurBonusAbil.SC + cha.SC;
         CurBonusAbil.AC := CurBonusAbil.AC + cha.AC;
         CurBonusAbil.MAC := CurBonusAbil.MAC + cha.MAC;
         CurBonusAbil.HP := CurBonusAbil.HP + cha.HP;
         CurBonusAbil.MP := CurBonusAbil.MP + cha.MP;
         CurBonusAbil.Hit := CurBonusAbil.Hit + cha.Hit;
         CurBonusAbil.Speed := CurBonusAbil.Speed + cha.Speed;

         BonusAbil.DC := CalcLoHi (BonusAbil.DC, CurBonusAbil.DC div ptk.DC);
         CurBonusAbil.DC := CurBonusAbil.DC mod ptk.DC;

         BonusAbil.MC := CalcLoHi (BonusAbil.MC, CurBonusAbil.MC div ptk.MC);
         CurBonusAbil.MC := CurBonusAbil.MC mod ptk.MC;

         BonusAbil.SC := CalcLoHi (BonusAbil.SC, CurBonusAbil.SC div ptk.SC);
         CurBonusAbil.SC := CurBonusAbil.SC mod ptk.SC;

         BonusAbil.AC := MakeWord(0, Hibyte(BonusAbil.AC) + CurBonusAbil.AC div ptk.AC);   //CalcLoHi (BonusAbil.AC, CurBonusAbil.AC div ptk.AC);
         CurBonusAbil.AC := CurBonusAbil.AC mod ptk.AC;

         BonusAbil.MAC := MakeWord(0, Hibyte(BonusAbil.MAC) + CurBonusAbil.MAC div ptk.MAC);//CalcLoHi (BonusAbil.MAC, CurBonusAbil.MAC div ptk.MAC);
         CurBonusAbil.MAC := CurBonusAbil.MAC mod ptk.MAC;

         BonusAbil.HP := BonusAbil.HP + CurBonusAbil.HP div ptk.HP;
         CurBonusAbil.HP := CurBonusAbil.HP mod ptk.HP;

         BonusAbil.MP := BonusAbil.MP + CurBonusAbil.MP div ptk.MP;
         CurBonusAbil.MP := CurBonusAbil.MP mod ptk.MP;

         BonusAbil.Hit := BonusAbil.Hit + CurBonusAbil.Hit div ptk.Hit;
         CurBonusAbil.Hit := CurBonusAbil.Hit mod ptk.Hit;

         BonusAbil.Speed := BonusAbil.Speed + CurBonusAbil.Speed div ptk.Speed;
         CurBonusAbil.Speed := CurBonusAbil.Speed mod ptk.Speed;

         RecalcLevelAbilitys;
         RecalcAbilitys;
         SendMsg (self, RM_ABILITY, 0, 0, 0, 0, '');
         SendMsg (self, RM_SUBABILITY, 0, 0, 0, 0, '');
      end;
      ServerSendAdjustBonus;  //보너스 포인트를 다시 보내준다.
   end;
{$ENDIF}
end;


procedure TUserHuman.RmMakeSlaveProc(pslave: PTSlaveInfo);
var
  cret:     TCreature;
  maxcount: integer;
begin
  if Job = 2 then  //도사인경우
    maxcount := 1
  else
    maxcount := 5;
  cret := MakeSlave(pslave.SlaveName, pslave.SlaveMakeLevel, maxcount,
    pslave.RemainRoyalty);
  if cret <> nil then begin
    cret.SlaveExp      := pslave.SlaveExp;
    cret.SlaveExpLevel := pslave.SlaveExpLevel;
    cret.WAbil.HP      := pslave.HP;
    cret.WAbil.MP      := pslave.MP;


    if cret.NextWalkTime > 1500 - (pslave.SlaveMakeLevel * 200) then
      cret.NextWalkTime := 1500 - (pslave.SlaveMakeLevel * 200);
    if cret.NextHitTime > 2000 - (pslave.SlaveMakeLevel * 200) then
      cret.NextHitTime := 2000 - (pslave.SlaveMakeLevel * 200);

    cret.RecalcAbilitys;

  end;
end;

// 연인사제 옵션변경
procedure TUserHuman.ServerGetRelationOptionChange(OptionType: integer;
  Enable: integer);
begin

  case OptionType of
    1: begin // 연인일 경우에
      // 이전의 상태의 반전을 한다.
      if 1 = Self.fLover.GetEnable(RsState_Lover) then
        Self.fLover.SetEnable(RsState_Lover, 0)
      else
        Self.fLover.SetEnable(RsState_Lover, 1);
      SendDefMessage(SM_LM_OPTION, 0, OPtionType,
        Self.flover.GetEnable(RsState_Lover), 0, '');
    end;
  end;
end;

// 연인사제 관계 요청
procedure TUserHuman.ServerGetRelationRequest(ReqType: integer; ReqSeq: integer);
var
  cert: TCreature;
  Target: TUserHuman;
  ListCount: integer;
  msgstr: string;
  Date: string;
  str: string;
  CheckResult: integer;
begin
  // 앞에 있는 상대를 얻는다.
  cert := GetFrontCret;
  // 타겟이 없거나 , 마주보고 있지 않거나 , 인간이 아니면 나간다.
  if (cert = nil) or (cert.GetFrontCret <> Self) or
    (cert.RaceServer <> RC_USERHUMAN) then begin
    BoxMsg('You must be facing each other.', 0);
    Exit;
  end;

  // human 으로 타입 바꿈
  Target := TUserHuman(cert);

  // 조건체크
  case ReqType of
    RsState_Lover: // 연인의 경우 조건 체크
    begin
      // 자신의 레벨체크
      if Self.WAbil.Level < 22 then begin
        SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_LessLevelMe, 0, '');
        Exit;
      end;
      // 상대방의 레벨 체크
      if Target.WAbil.Level < 22 then begin
        SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_LessLevelOther,
          0, Target.UserName);
        Exit;
      end;
      // 상대방과의 성별 체크
      if Self.Sex = Target.Sex then begin
        SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_EqualSex, 0, '');
        Exit;
      end;
      // 교제가능 조건 체크 (체크 순서 조정)
      CheckResult := Self.fLover.GetEnableJoin(ReqType);
      if CheckResult = 1 then begin
        //교제가능 상태가 아님
        SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_RejectMe, 0, '');
        Exit;
      end else if CheckResult = 2 then begin
        //이미 교제중인 사람이 있음
        SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_FullUser, 0, UserName);
        Exit;
      end else if CheckResult <> 0 then begin
        Exit;
      end;
      // 나의 교제가능 상태 체크
      if not Self.fLover.EnableJoinLover then begin
        SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_RejectMe, 0, '');
        Exit;
      end;
      // 상대방의 교제가능상태 체크
      if not Target.fLover.EnableJoinLover then begin
        SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_RejectOther,
          0, Target.UserName);
        Exit;
      end;
    end;
      // 연인이 아닐경우의 조건체크
    else
      Exit;
  end;

  // 참여 시퀀스 변화 ...
  case ReqSeq of
    RsReq_None: ; // 기본상태
    RsReq_WantToJoinOther: // 누구에게 참가신청을 함
    begin
      if not Self.fLover.GetEnableJoinReq(ReqType) then begin
        // 내가 상대방에게 참여할수 없는 상태이다.
        SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_DontJoin,
          0, Target.UserName);
      end else begin
        // 참여가능한지 검토
        CheckResult := Target.fLover.GetEnableJoin(ReqType);
        if CheckResult = 1 then begin
          //교제가능 상태가 아님
          SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_RejectOther,
            0, Target.UserName);
        end else if CheckResult = 2 then begin
          //이미 교제중인 사람이 있음
          SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_FullUser,
            0, Target.UserName);
        end else if CheckResult = 0 then begin
          // 상대방이 다른 요구를 받고 있는상태가 아니면
          if Target.fLover.ReqSequence = RsReq_None then begin
            // 누군가 신청했다고 알림
            target.SendDefMessage(SM_LM_REQUEST, 0, ReqType,
              RsReq_WhoWantJoin, 0, Self.UserName);
            // 나는 대답을 기다리는 상태이고
            Self.fLover.ReqSequence   := RsReq_WaitAnser;
            // 상대방은 대답을 해줘야 하는 상태
            Target.flover.ReqSequence := RsReq_WhoWantJoin;
          end else begin
            // 상대방이 현재 다른 응답 상태이다.
            SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_DontJoin,
              0, Target.UserName);
          end;
        end; // if not Target.fLover.GetEnableJoin

      end; // if not Self.fLover.GetEnableJoinReq
    end;
    RsReq_AloowJoin: // 참가를 허락함
    begin
      if Target.fLover.ReqSequence = RsReq_WaitAnser then begin
        // 타겟을 등록한다.
        Date := '';
        Self.fLover.ReqSequence := RsREq_None;
        self.flover.Add(Self.UserName, Target.Username, ReqType,
          Target.WAbil.Level, Target.Sex, Date, '');
        msgstr := Self.fLover.GetListmsg(ReqType, listCount);
        SendDefMessage(SM_LM_LIST, 0, ListCount, 0, 0, msgstr);
        SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_SuccessJoin,
          0, Target.UserName);

        // 자신을 타겟에 등록한다.
        Target.fLover.ReqSequence := RsREq_None;
        Target.flover.Add(Target.UserName, Self.Username,
          ReqType, Self.WAbil.Level, Self.Sex, Date, '');
        msgstr := Target.fLover.GetListmsg(ReqType, listCount);
        Target.SendDefMessage(SM_LM_LIST, 0, ListCount, 0, 0, msgstr);
        Target.SendDefMessage(SM_LM_RESULT, 0, ReqType,
          RsError_SuccessJoined, 0, Self.UserName);

        // DB 에 저장한다. 한명만 저장하면 나머지사람은 알아서 저장된다.
        SendMsg(Self, RM_LM_DBADD, 0, 0, 0, 0,
          Target.UserName + ':' + IntToStr(ReqType) + ':' + Date + '/');

        // 주변에 외치기
        str := 'Congratulations! "' + UserName + '" and "' +
          target.UserName + '" became lovers!';
        //            UserEngine.CryCry (RM_SYSMSG_PINK, PEnvir, CX, CY, 300, '♡' + str);
        UserEngine.CryCry(RM_SYSMSG_PINK, PEnvir, CX, CY, 300, ':)' + str);

        //로그남김
        AddUserLog('47'#9 + //연인_   //LastLogNumber
          MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
          ''#9 + UserName + ''#9 + '0'#9 + '0'#9 + '0'#9 +  //맺음:0
          target.UserName);

      end else begin
        // 상대방이 현재 다른 응답 상태이다. 따라서 취소시킨다.
        self.fLover.ReqSequence := RsReq_None;
        SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_CancelJoin, 0,
          Target.UserName);

        target.fLover.ReqSequence := RsReq_None;
        Target.SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_CancelJoin,
          0, Self.UserName);
      end;
    end;
    RsReq_DenyJoin: // 참가를 거절함
    begin
      self.fLover.ReqSequence := RsReq_None;
      SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_CancelJoin,
        0, Target.UserName);

      target.fLover.ReqSequence := RsReq_None;
      target.SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_DenyJoin, 0,
        Self.UserName);
    end;
    RsReq_Cancel: // 취소
    begin
      self.fLover.ReqSequence := RsReq_None;
      SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_CancelJoin,
        0, Target.UserName);

      target.fLover.ReqSequence := RsReq_None;
      target.SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_CancelJoin,
        0, Self.UserName);
    end;
  end;

end;

// 연인 사제 삭제
procedure TUserHuman.ServerGetRelationDelete(ReqType: integer; OtherName: string);
var
  svidx: integer;
  hum:   TUserHuman;
  cert:  TCreature;
  strPayment: string;
begin
  //연인 관계일 경우...
  if ReqType = RsState_Lover then begin
    // 앞에 있는 상대를 얻는다.
    cert := GetFrontCret;
    // 타겟이 없거나 , 마주보고 있지 않거나 , 인간이 아니면 나간다.
    if (cert = nil) or (cert.GetFrontCret <> Self) or
      (cert.RaceServer <> RC_USERHUMAN) then begin
      BoxMsg('To break the lovers'' relationship, you must face each other.', 0);
      Exit;
    end;

    // human 으로 타입 바꿈
    hum := TUserHuman(cert);
    if hum = nil then
      exit;

    // 상대방이 나의 연인인지 체크
    if not ((hum.fLover.GetLoverName = UserName) and
      (fLover.GetLoverName = hum.UserName)) then begin
      BoxMsg('It is not your lover.', 0);
      Exit;
    end;

    // 위자료 낼 돈이 있는지 확인
    if Gold < COMPENSATORY_PAYMENT then begin
      strPayment := IntToStr(COMPENSATORY_PAYMENT div 10000);
      BoxMsg('To break the relationship with your lover, you need ' +
        strPayment + '0,000 Gold.', 0);
      exit;
    end;

    //-------------------
    //연인 해제 확인
    hum.SendDefMessage(SM_LM_DELETE_REQ, 0, 0, 0, 0, UserName);
    /////////////////////
    exit;
    //-------------------
  end;

  if RelationShipDeleteOther(ReqType, OtherName) then begin
    hum := UserEngine.GetUserHuman(OtherName);
    if hum <> nil then begin
      hum.RelationShipDeleteOther(ReqType, UserName);
    end else begin
      if UserEngine.FindOtherServerUser(OtherName, svidx) then begin
        UserEngine.SendInterMsg(ISM_LM_DELETE, svidx, OtherName +
          '/' + UserName + '/' + IntToStr(ReqType));
      end;
    end;

  end else begin
    SendDefMessage(SM_LM_RESULT, ReqType, RsError_DontDelete, 0, 0, OtherName);
  end;

end;

procedure TUserHuman.ServerGetRelationDeleteRequestOk(ReqType: integer;
  OtherName: string);
var
  svidx: integer;
  hum:   TUserHuman;
  cert:  TCreature;
  strPayment: string;
begin
  //연인 관계일 경우...
  if ReqType = RsState_Lover then begin
    // 앞에 있는 상대를 얻는다.
    cert := GetFrontCret;
    // 타겟이 없거나 , 마주보고 있지 않거나 , 인간이 아니면 나간다.
    if (cert = nil) or (cert.GetFrontCret <> Self) or
      (cert.RaceServer <> RC_USERHUMAN) then begin
      BoxMsg('To break the lovers'' relationship, you must face each other.', 0);
      Exit;
    end;

    // human 으로 타입 바꿈
    hum := TUserHuman(cert);
    if hum = nil then
      exit;

    // 상대방이 나의 연인인지 체크
    if not ((hum.fLover.GetLoverName = UserName) and
      (fLover.GetLoverName = hum.UserName)) then begin
      BoxMsg('It is not your lover.', 0);
      Exit;
    end;

    // 위자료 낼 돈이 있는지 확인
    if Gold < COMPENSATORY_PAYMENT then begin
      strPayment := IntToStr(COMPENSATORY_PAYMENT div 10000);
      BoxMsg('To break the relationship with your lover, you need ' +
        strPayment + '0,000 Gold.', 0);
      exit;
    end;
  end;

  if RelationShipDeleteOther(ReqType, OtherName) then begin

    if ReqType = RsState_Lover then begin
      //위자료 지불
      if Gold >= COMPENSATORY_PAYMENT then begin
        DecGold(COMPENSATORY_PAYMENT);
        GoldChanged;
      end;
      //상태 변경(둔화)
      MakePoison(POISON_SLOW, 3, 1);
      //HP, MP 변경(50%)
      WAbil.HP := _MAX(1, WAbil.HP div 2);
      WAbil.MP := _MAX(1, WAbil.MP div 2);

      //충격 메시지
      SysMsg('Lovers'' relationship broken. A shock caused by the end of the relationship is applied.', 0);

      //로그남김
      AddUserLog('47'#9 + //연인_   //LastLogNumber
        MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) + ''#9 +
        UserName + ''#9 + '0'#9 + '0'#9 + '2'#9 +  //해제:2
        OtherName);
    end;

    hum := UserEngine.GetUserHuman(OtherName);
    if hum <> nil then begin
      if hum.RelationShipDeleteOther(ReqType, UserName) then begin
        if ReqType = RsState_Lover then begin
          //위자료 지불
          if hum.Gold >= COMPENSATORY_PAYMENT then begin
            hum.DecGold(COMPENSATORY_PAYMENT);
            hum.GoldChanged;
          end;
          //상태 변경(둔화)
          hum.MakePoison(POISON_SLOW, 3, 1);
          //HP, MP 변경(50%)
          hum.WAbil.HP := _MAX(1, hum.WAbil.HP div 2);
          hum.WAbil.MP := _MAX(1, hum.WAbil.MP div 2);

          //충격 메시지
          hum.SysMsg(
            'Lovers'' relationship broken. A shock caused by the end of the relationship is applied.',
            0);

          //로그남김
          AddUserLog('47'#9 + //연인_   //LastLogNumber
            hum.MapName + ''#9 + IntToStr(hum.CX) + ''#9 +
            IntToStr(hum.CY) + ''#9 + hum.UserName + ''#9 + '0'#9 +
            '0'#9 + '2'#9 +  //해제:2
            UserName);
        end;
      end;
    end else begin
      if UserEngine.FindOtherServerUser(OtherName, svidx) then begin
        UserEngine.SendInterMsg(ISM_LM_DELETE, svidx, OtherName +
          '/' + UserName + '/' + IntToStr(ReqType));
      end;
    end;

  end else begin
    SendDefMessage(SM_LM_RESULT, ReqType, RsError_DontDelete, 0, 0, OtherName);
  end;
end;

procedure TUserHuman.ServerGetRelationDeleteRequestFail(ReqType: integer;
  OtherName: string);
var
  hum: TUserHuman;
begin
  hum := UserEngine.GetUserHuman(OtherName);
  if hum = nil then
    exit;

  //교제 거부 메시지
  hum.SysMsg(UserName + ' has refused to break the relationship.', 3);
end;

// 상대방이 자신을 관계해제 시켰을 경우
function TUserHuman.RelationShipDeleteOther(ReqType: integer;
  OtherName: string): boolean;
begin
  Result := False;
  if fLover.Find(OtherName) then begin
    fLover.Delete(OtherName);
    SendDefMessage(SM_LM_DELETE, 0, ReqType, 0, 0, OtherName);
    SendDefMessage(SM_LM_RESULT, 0, ReqType, RsError_SuccessDelete, 0, OtherName);
    // DB에서 삭제한다.
    SendMsg(Self, RM_LM_DBDELETE, 0, 0, 0, 0, OtherName + '/');
    Result := True;
  end;

end;

procedure TUserHuman.ServerSetRelationDBWantList(body: string);
var
  msg: TDefaultMessage;
begin
  msg.Recog  := 0;
  msg.Ident  := DB_LM_LIST;
  msg.Param  := 0;
  msg.Tag    := 0;
  msg.Series := 0;

  UserMgrEngine.ExternSendMsg(stDbServer, 0, 0, 0, 0, Self.UserName, msg, Body);
end;

procedure TUserHuman.ServerSetRelationDBAdd(body: string);
var
  msg: TDefaultMessage;
begin
  msg.Recog  := 0;
  msg.Ident  := DB_LM_ADD;
  msg.Param  := 0;
  msg.Tag    := 0;
  msg.Series := 0;

  UserMgrEngine.ExternSendMsg(stDbServer, 0, 0, 0, 0, Self.UserName, msg, Body);
end;

procedure TUserHuman.ServerSetRelationDBEdit(body: string);
var
  msg: TDefaultMessage;
begin
  msg.Recog  := 0;
  msg.Ident  := DB_LM_EDIT;
  msg.Param  := 0;
  msg.Tag    := 0;
  msg.Series := 0;

  UserMgrEngine.ExternSendMsg(stDbServer, 0, 0, 0, 0, Self.UserName, msg, Body);
end;

procedure TUserHuman.ServerSetRelationDBDelete(body: string);
var
  msg: TDefaultMessage;
begin
  msg.Recog  := 0;
  msg.Ident  := DB_LM_DELETE;
  msg.Param  := 0;
  msg.Tag    := 0;
  msg.Series := 0;

  UserMgrEngine.ExternSendMsg(stDbServer, 0, 0, 0, 0, Self.UserName, msg, Body);
end;

// 관계시스템등에서 맵정보를 알아온다.
function TUserHuman.GetCharMapInfo(charname: string): string;
var
  userinfo: TUserHuman;
begin
  Result   := '';
  userinfo := nil;
  if charname = '' then
    exit;

  userinfo := userengine.GetUserHuman(charname);
  if (userinfo <> nil) and (userinfo.penvir <> nil) then begin
    Result := userinfo.penvir.MapTitle;
  end;
end;

// 관계시스템에서 리스트를 DB 에서 얻어왔을경우
procedure TUserHuman.ServerGetRelationDBGetList(body: string);
var
  Count, i: integer;
  msgstr:   string;
  ListCnt:  integer;
  str:      string;
  datastr:  string;
  tempstr:  string;
  _Name:    string;
  _State:   integer;
  _Msg:     integer;
  _Date:    string;
  _Level:   integer;
  _Sex:     integer;
  hum:      TUserHuman;
  svidx:    integer;
  lovername: string;
begin
  // Count / 케릭터이름:등록상태:메세지:등록일자:레벨:성별/...

  str    := GetValidStr3(Body, Datastr, ['/']);
  Count  := Str_ToInt(DataStr, 0);
  _State := 0;

  for i := 0 to Count - 1 do begin
    str := GetValidStr3(str, Datastr, ['/']);
    if datastr <> '' then begin
      datastr := GetValidStr3(datastr, _Name, [':']);
      datastr := GetValidStr3(datastr, tempstr, [':']);
      _State  := Str_ToInt(tempstr, 0);
      datastr := GetValidStr3(datastr, tempstr, [':']);
      _msg    := Str_ToInt(tempstr, 0);
      datastr := GetValidStr3(datastr, _Date, [':']);
      datastr := GetValidStr3(datastr, tempstr, [':']);
      _Level  := Str_ToInt(tempstr, 0);
      _Sex    := Str_ToInt(datastr, 0);


      case _State of
        rsState_Lover:// 연인
        begin
          FLover.Add(UserName, _Name, _State, _Level, _Sex,
            _Date, GetCharMapInfo(_Name));
        end;
        RsState_LoverEnd:// 연인탈퇴
        begin
          SendDefMessage(SM_LM_RESULT, 0, rsState_Lover,
            RsError_SuccessDelete, 0, _Name);
          // DB에서 삭제한다.
          SendMsg(Self, RM_LM_DBDELETE, 0, 0, 0, 0, _Name + '/');
        end;

      end;
    end;
  end; // for

  msgstr := Self.fLover.GetListmsg(_State, ListCnt);
  if (ListCnt > 0) then begin
    SendDefMessage(SM_LM_LIST, 0, ListCnt, 0, 0, msgstr);
  end;

  //최초 접속시 연인에게도 보냄(sonmg)
  if not BoServerShifted then begin
    lovername := fLover.GetLoverName;
    hum := UserEngine.GetUserHuman(lovername);
    if hum <> nil then begin
      if hum.fLover.GetLoverName <> '' then begin
        hum.SysMsg(UserName + ' has entered ' + GetCharMapInfo(UserName) + '.', 6);
        SysMsg(hum.UserName + ' is currently in ' +
          GetCharMapInfo(hum.UserName) + '.', 6);
      end;
    end else begin
      if UserEngine.FindOtherServerUser(lovername, svidx) then begin
        UserEngine.SendInterMsg(ISM_LM_LOGIN, svidx, UserName +
          '/' + lovername + '/' + GetCharMapInfo(UserName));
      end;
    end;
  end;

  GetQueryUsername(self, CX, CY);   //연인 표시

end;

procedure TUserHuman.ServerGetLoverLogout;
begin
  if fLover = nil then
    exit;

  SysMsg(fLover.GetLoverName + ' has exited from the game.', 5);
end;

procedure TUserHuman.ServerSendItemCountChanged(mindex, icount, increase: integer;
  itmname: string);
begin
  if icount <= 0 then
    MainOutMessage('[Caution!] icount <= 0 in TUserHuman.ServerSendItemCountChanged');

  Def := MakeDefaultMsg(SM_COUNTERITEMCHANGE, mindex, icount, increase, 0);
  SendSocket(@Def, EncodeString(itmname));
end;

// added by sonmg.
function TUserHuman.DoUpgradeItem(puSeed: PTUserItem;
  psSeed, psJewelry: PTStdItem): integer;
begin
  Result := 1;

  // 업그레이드 값 반영.
  case psSeed.StdMode of
    5, 6: // 무기
    begin
      puSeed.Desc[0] := puSeed.Desc[0] + psJewelry.DC;
      puSeed.Desc[1] := puSeed.Desc[1] + psJewelry.MC;
      puSeed.Desc[2] := puSeed.Desc[2] + psJewelry.SC;

      if psJewelry.AtkSpd > 0 then begin
        // 공속 업그레이드
        puSeed.Desc[6] :=
          ItemMan.UpgradeAttackSpeed(puSeed.Desc[6], psJewelry.AtkSpd);

{
               // 공속의 실제값이 1보다 크면
               if HiByte(psSeed.MAC) > 10 then begin
                  puSeed.Desc[6] := puSeed.Desc[6] + psJewelry.AtkSpd;
               end else begin // 공속이 음수이면
                  puSeed.Desc[6] := puSeed.Desc[6] + psJewelry.AtkSpd;
               end;
}
        // 공속 한계를 넘을 경우 한계값을 대입함.
        puSeed.Desc[6] := _MIN(15 + 10, puSeed.Desc[6]);
      end;
      puSeed.Desc[12] := puSeed.Desc[12] + psJewelry.Slowdown;
      puSeed.Desc[13] := puSeed.Desc[13] + psJewelry.Tox;
    end;
    10, 11: // 옷
    begin
      puSeed.Desc[0]  := puSeed.Desc[0] + psJewelry.AC;
      puSeed.Desc[1]  := puSeed.Desc[1] + psJewelry.MAC;
      puSeed.Desc[11] := puSeed.Desc[11] + psJewelry.Agility;
      puSeed.Desc[12] := puSeed.Desc[12] + psJewelry.MgAvoid;
      puSeed.Desc[13] := puSeed.Desc[13] + psJewelry.ToxAvoid;
    end;
    15: // 투구
    begin
      puSeed.Desc[0]  := puSeed.Desc[0] + psJewelry.AC;
      puSeed.Desc[1]  := puSeed.Desc[1] + psJewelry.MAC;
      puSeed.Desc[11] := puSeed.Desc[11] + psJewelry.Accurate;
      puSeed.Desc[12] := puSeed.Desc[12] + psJewelry.MgAvoid;
      puSeed.Desc[13] := puSeed.Desc[13] + psJewelry.ToxAvoid;
    end;
    19: // 목걸이19
    begin
      puSeed.Desc[2] := puSeed.Desc[2] + psJewelry.DC;
      puSeed.Desc[3] := puSeed.Desc[3] + psJewelry.MC;
      puSeed.Desc[4] := puSeed.Desc[4] + psJewelry.SC;

      // 정확
      puSeed.Desc[11] := puSeed.Desc[11] + psJewelry.Accurate;
      //마법저항
      puSeed.Desc[0]  := puSeed.Desc[0] + psJewelry.MgAvoid;

      if psJewelry.AtkSpd > 0 then begin
        puSeed.Desc[9] := puSeed.Desc[9] + psJewelry.AtkSpd;
        // 공속 한계를 넘을 경우 한계값을 대입함.
        puSeed.Desc[9] := _MIN(15, puSeed.Desc[9]);
      end;
      puSeed.Desc[12] := puSeed.Desc[12] + psJewelry.Slowdown;
      puSeed.Desc[13] := puSeed.Desc[13] + psJewelry.Tox;
    end;
    20: // 목걸이
    begin
      puSeed.Desc[2] := puSeed.Desc[2] + psJewelry.DC;
      puSeed.Desc[3] := puSeed.Desc[3] + psJewelry.MC;
      puSeed.Desc[4] := puSeed.Desc[4] + psJewelry.SC;

      // 정확
      puSeed.Desc[0]  := puSeed.Desc[0] + psJewelry.Accurate;
      // 민첩
      puSeed.Desc[1]  := puSeed.Desc[1] + psJewelry.Agility;
      //마법저항
      puSeed.Desc[11] := puSeed.Desc[11] + psJewelry.MgAvoid;

      if psJewelry.AtkSpd > 0 then begin
        puSeed.Desc[9] := puSeed.Desc[9] + psJewelry.AtkSpd;
        // 공속 한계를 넘을 경우 한계값을 대입함.
        puSeed.Desc[9] := _MIN(15, puSeed.Desc[9]);
      end;
      puSeed.Desc[12] := puSeed.Desc[12] + psJewelry.Slowdown;
      puSeed.Desc[13] := puSeed.Desc[13] + psJewelry.Tox;
    end;
    21: // 목걸이
    begin
      puSeed.Desc[2] := puSeed.Desc[2] + psJewelry.DC;
      puSeed.Desc[3] := puSeed.Desc[3] + psJewelry.MC;
      puSeed.Desc[4] := puSeed.Desc[4] + psJewelry.SC;

      //마법저항
      puSeed.Desc[7]  := puSeed.Desc[7] + psJewelry.MgAvoid;
      // 정확
      puSeed.Desc[11] := puSeed.Desc[11] + psJewelry.Accurate;

      if psJewelry.AtkSpd > 0 then begin
        puSeed.Desc[9] := puSeed.Desc[9] + psJewelry.AtkSpd;
        // 공속 한계를 넘을 경우 한계값을 대입함.
        puSeed.Desc[9] := _MIN(15, puSeed.Desc[9]);
      end;
      puSeed.Desc[12] := puSeed.Desc[12] + psJewelry.Slowdown;
      puSeed.Desc[13] := puSeed.Desc[13] + psJewelry.Tox;
    end;
    22: // 반지
    begin
      puSeed.Desc[0] := puSeed.Desc[0] + psJewelry.AC;
      puSeed.Desc[1] := puSeed.Desc[1] + psJewelry.MAC;
      puSeed.Desc[2] := puSeed.Desc[2] + psJewelry.DC;
      puSeed.Desc[3] := puSeed.Desc[3] + psJewelry.MC;
      puSeed.Desc[4] := puSeed.Desc[4] + psJewelry.SC;
      if psJewelry.AtkSpd > 0 then begin
        puSeed.Desc[9] := puSeed.Desc[9] + psJewelry.AtkSpd;
        // 공속 한계를 넘을 경우 한계값을 대입함.
        puSeed.Desc[9] := _MIN(15, puSeed.Desc[9]);
      end;
      puSeed.Desc[12] := puSeed.Desc[12] + psJewelry.Slowdown;
      puSeed.Desc[13] := puSeed.Desc[13] + psJewelry.Tox;
    end;
    23: // 반지23
    begin
      puSeed.Desc[2] := puSeed.Desc[2] + psJewelry.DC;
      puSeed.Desc[3] := puSeed.Desc[3] + psJewelry.MC;
      puSeed.Desc[4] := puSeed.Desc[4] + psJewelry.SC;
      if psJewelry.AtkSpd > 0 then begin
        puSeed.Desc[9] := puSeed.Desc[9] + psJewelry.AtkSpd;
        // 공속 한계를 넘을 경우 한계값을 대입함.
        puSeed.Desc[9] := _MIN(15, puSeed.Desc[9]);
      end;
      puSeed.Desc[12] := puSeed.Desc[12] + psJewelry.Slowdown;
      puSeed.Desc[13] := puSeed.Desc[13] + psJewelry.Tox;
    end;
    24: // 팔찌24
    begin
      puSeed.Desc[0] := puSeed.Desc[0] + psJewelry.Accurate; //정확
      puSeed.Desc[1] := puSeed.Desc[1] + psJewelry.Agility;  //민첩
      puSeed.Desc[2] := puSeed.Desc[2] + psJewelry.DC;
      puSeed.Desc[3] := puSeed.Desc[3] + psJewelry.MC;
      puSeed.Desc[4] := puSeed.Desc[4] + psJewelry.SC;
    end;
    26: // 팔찌26
    begin
      puSeed.Desc[0] := puSeed.Desc[0] + psJewelry.AC;
      puSeed.Desc[1] := puSeed.Desc[1] + psJewelry.MAC;
      puSeed.Desc[2] := puSeed.Desc[2] + psJewelry.DC;
      puSeed.Desc[3] := puSeed.Desc[3] + psJewelry.MC;
      puSeed.Desc[4] := puSeed.Desc[4] + psJewelry.SC;

      // 정확
      puSeed.Desc[11] := puSeed.Desc[11] + psJewelry.Accurate;
      // 민첩
      puSeed.Desc[12] := puSeed.Desc[12] + psJewelry.Agility;
    end;
    52: // 신발
    begin
      puSeed.Desc[0] := puSeed.Desc[0] + psJewelry.AC;
      puSeed.Desc[1] := puSeed.Desc[1] + psJewelry.MAC;

      // 민첩
      puSeed.Desc[3] := puSeed.Desc[3] + psJewelry.Agility;
    end;
    54: // 벨트
    begin
      puSeed.Desc[0] := puSeed.Desc[0] + psJewelry.AC;
      puSeed.Desc[1] := puSeed.Desc[1] + psJewelry.MAC;

      // 정확
      puSeed.Desc[2] := puSeed.Desc[2] + psJewelry.Accurate;
      // 민첩
      puSeed.Desc[3] := puSeed.Desc[3] + psJewelry.Agility;

      puSeed.Desc[13] := puSeed.Desc[13] + psJewelry.ToxAvoid;
    end;
    else begin
      Result := 0;
      exit;
    end;
  end;

  // 최대내구력 업그레이드
  puSeed.DuraMax := _MIN(65000, puSeed.DuraMax + psJewelry.DuraMax);

  SendUpdateItem(puSeed^);
  SendMsg(self, RM_ABILITY, 0, 0, 0, 0, '');
  SendMsg(self, RM_SUBABILITY, 0, 0, 0, 0, '');
end;

// 카운트 아이템 통합.
procedure TUserHuman.ServerGetSumCountItem(org_mindex, ex_mindex: integer;
  itmnames: string);
var
  flag: boolean;
  i:    integer;
  pu_org, pu_ex: PTUserItem;
  ps_org, ps_ex: PTStdItem;
  org_itmname, ex_itmname: string;
begin
  pu_org := nil;
  pu_ex  := nil;
  ps_org := nil;
  ps_ex  := nil;

  flag := False;
  // RightStr := GetValidStr3 (OrgStr, LeftStr of Separator, Separator);
  ex_itmname := GetValidStr3(itmnames, org_itmname, ['/']);

  // Ex 아이템 검색.
  for i := 0 to ItemList.Count - 1 do begin
    if PTUserItem(ItemList[i]).MakeIndex = ex_mindex then begin
      if CompareText(UserEngine.GetStdItemName(PTUserItem(ItemList[i]).Index),
        ex_itmname) = 0 then begin
        pu_ex := PTUserItem(ItemList[i]);

        if pu_ex <> nil then begin
          ps_ex := UserEngine.GetStdItem(pu_ex.Index);

          if ps_ex <> nil then begin
            if ps_ex.OverlapItem >= 1 then begin
              flag := True;
              break;
            end;
          end;
        end;
      end;
    end;
  end;

  if flag = False then
    exit;

  if ps_ex = nil then
    exit;

  flag := False;

  // 가방창에 있는 해당 아이템에 카운트를 합산한다.
  // Org 아이템을 검색해서 카운트 변경.
  for i := 0 to ItemList.Count - 1 do begin
    if PTUserItem(ItemList[i]).MakeIndex = org_mindex then begin
      if CompareText(UserEngine.GetStdItemName(PTUserItem(ItemList[i]).Index),
        org_itmname) = 0 then begin
        pu_org := PTUserItem(ItemList[i]);

        if pu_org <> nil then begin
          ps_org := UserEngine.GetStdItem(pu_org.Index);

          if ps_org <> nil then begin
            if (ps_org.OverlapItem >= 1) and (ps_ex.OverlapItem >= 1) then begin
              if CompareText(ps_org.Name, ps_ex.Name) = 0 then begin
                if pu_org.MakeIndex <> pu_ex.MakeIndex then begin

                  // 최대 개수 제한 (sonmg)
                  if pu_org.Dura + pu_ex.Dura > MAX_OVERLAPITEM then
                    break;

                  // 합이 MAX_OVERFLOW가 넘으면 따로 생성하거나 같은 종류의 아이템에 합산.
                  if pu_org.Dura + pu_ex.Dura > MAX_OVERFLOW then begin
                    // 같은 종류의 최소 개수 아이템에 합산.
                    // 들고 있는 아이템은 최소 개수 아이템 검사에서 제외.
                    if UserCounterItemAdd(ps_ex.StdMode,
                      ps_ex.Looks, pu_ex.Dura, ps_ex.Name, True, pu_ex.MakeIndex) then
                    begin
                      flag := True;
                      break;
                    end else begin
                      // 이런 경우는 없어야 겠지만 최악의 경우
                      // 가방창 목록을 클라이언트로 보낸다.
                      // 가방창의 아이템 위치가 바뀔 수 있음.
                      SendBagItems;
                      break;
                    end;
                  end else begin
                    // 합이 MAX_OVERFLOW가 안되면 그냥 합침.
                    pu_org.Dura := pu_org.Dura + pu_ex.Dura;  // 카운트 통합
                  end;
                  flag := True;
                end;
                SendMsg(self, RM_COUNTERITEMCHANGE, 0,
                  pu_org.MakeIndex, pu_org.Dura, 0, ps_org.Name);
                break;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  if flag = False then
    exit;

  // Ex 아이템 삭제
  DeletePItemAndSend(pu_ex);

end;

function TuserHuman.SetExpiredTime(min_: integer): boolean;
begin
  Result := False;
  if Abil.Level > EXPERIENCELEVEL then begin
    FExpireTime := GetTickCount + (60 * 1000);
    FExpireCount := min_;
    Result := True;
  end;
end;

procedure TuserHuman.CheckExpiredTime;
begin
  if FExpireTime > 0 then begin
    if (FExpireTime < GetTickCount) then begin
      FExpireCount := FExpireCount - 1;
      if FExpireCount > 0 then begin
        SysMsg('Your time account expired. You are going to be disconnected ' +
          IntToStr(FExpireCount) + 'minute service time later.', 0);
        FExpireTime := GetTickCount + (60 * 1000);
      end else begin
        FExpireTime      := 0;
        FExpireCount     := 0;
        BoAccountExpired := True;
      end;
    end;
  end;
end;

 // 데이터 베이스로 요청하는 부분 -----------------------------------------------
 // Page_ = 0 처음페이지 , 1=다음페이지
procedure TUserHuman.ServerGetMarketList(MarketNpc: TCreature;
  page_: integer; body: string);
var
  ItemName_: string;
begin
  if MarketNpc <> nil then
    FMarketNPC := MarketNpc;

  case Page_ of
    0: begin
      RequireLoadRefresh;
    end;
    1: SendUserMarketList(page_);
    2: begin
      ItemName_ := body;
      if (ItemName_ <> '') and (UserEngine.GetStdItemIndex(ItemName_) <> -1) then
      begin
        RequireLoadUserMarket(GetMarketName, USERMARKET_TYPE_ITEMNAME,
          1, '', ItemName_);
      end else begin
        SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_NoItem, 0, '');
        BoxMsg('The item name is wrong.', 1);
      end;
    end;
  end;
end;

procedure TUserHuman.ServerGetMarketSell(MarketNpc: TCreature;
  count_: integer; makeindex_: integer; body: string);
var
  buffer1, buffer2: string;
  money: integer;
begin

  if MarketNpc <> nil then
    FMarketNPC := MarketNpc;

  buffer1 := body;
  buffer1 := GetValidStr3(buffer1, buffer2, ['/']);
  money   := Str_ToInt(buffer2, 0);

  RequireSellUserMarket(MakeIndex_, count_, money);
end;

procedure TUserHuman.ServerGetMarketBuy(MarketNpc: TCreature; SellIndex_: integer);
begin
  if MarketNpc <> nil then
    FMarketNPC := MarketNpc;

  RequireBuyUserMarket(MarketNpc, SellIndex_);
end;

procedure TUserHuman.ServerGetMarketCancel(MarketNpc: TCreature; SellIndex_: integer);
begin
  if MarketNpc <> nil then
    FMarketNPC := MarketNpc;

  RequireCancelUserMarket(MarketNpc, SellIndex_);
end;

procedure TUserHuman.ServerGetMarketGetPay(MarketNpc: TCreature; SellIndex_: integer);
begin
  if MarketNpc <> nil then
    FMarketNPC := MarketNpc;

  RequireGetPayUserMarket(MarketNpc, SellIndex_);
end;

procedure TUserHuman.ServerGetMarketClose;
begin
  FUserMarket.Clear;

{$IFDEF DEBUG}
   MainOutMessage('MarketClear :'+ UserName);
{$ENDIF}

end;

// 장원 목록 페이지 변경 메시지 처리.
procedure TUserHuman.ServerGetGuildAgitList(page: integer);
begin
  CmdGuildAgitBuy(page);
end;

function TUserHuman.ServerGetGuildAgitTag(who: TCreature; body: string): boolean;
  // 장원 쪽지
var
  hum: TUserHuman;
begin
  Result := False;

  hum := UserEngine.GetUserHuman(who.UserName);
  if hum <> nil then begin
    //      if TGuild(hum.MyGuild).GetTotalMemberCount > MINAGITMEMBER then begin
    if hum.IsGuildMaster then begin
      //         SysMsg('문주입니다.', 0);
      Result := True;
    end else begin
      BoxMsg('Only guild master can use it.', 0);
    end;
  end;
end;

// 장원 게시판 목록 페이지 변경 메시지.
procedure TUserHuman.ServerGetGaBoardList(page: integer);  //장원게시판 목록
begin
  CmdGaBoardList(page);
end;

// 장원 게시판 글읽기.
procedure TUserHuman.ServerGetGaBoardRead(NumSeries: string);
var
  gname, gnameHere, Data: string;
begin
  if MyGuild = nil then
    exit;
  if TGuild(MyGuild).GuildName = '' then
    exit;

  //문파명 복사.
  gname     := TGuild(MyGuild).GuildName;
  gnameHere := GetGuildNameHereAgit;

  // 현재 장원의 문파가 아니면...
  if gname <> gnameHere then begin
    // 운영자는 모든 게시판을 볼 수 있음.
    if UserDegree >= UD_ADMIN then begin
      gname := gnameHere;
    end else begin
      SysMsg('You cannot read the article.', 0);
      exit;
    end;
  end;

  Data := GuildAgitBoardMan.GetArticle(gname, NumSeries);

  //   SysMsg(data, 2);//테스트 게시판
  Def := MakeDefaultMsg(SM_GABOARD_READ, 0, 0, 0, 0);
  SendSocket(@Def, EncodeString(Data));
end;

// 장원 게시판 글쓰기.
procedure TUserHuman.ServerGetGaBoardAdd(nKind, nCurPage: integer; body: string);
var
  GuildAgitNum: integer;
  guildagit: TGuildAgit;
  strTemp: string;
  OrgNum: integer;
begin
  GuildAgitNum := 0;

  if nKind = KIND_NOTICE then begin
    if not IsMyGuildMaster then begin
      SysMsg('Only guild master can write it.', 0);
      exit;
    end;
  end;

  if MyGuild = nil then
    exit;
  if TGuild(MyGuild).GuildName = '' then
    exit;

  //쿼리에 들어가서는 안되는 글자.
  if StrScan(PChar(body), '''') <> nil then
    exit;

  guildagit := GuildAgitMan.GetGuildAgit(TGuild(MyGuild).GuildName);
  if guildagit <> nil then begin
    GuildAgitNum := guildagit.GuildAgitNumber;
  end;

  // 내용 앞에 유저이름 추가.
  if GuildAgitBoardMan.AddArticle(TGuild(MyGuild).GuildName, nKind,
    GuildAgitNum, UserName, body) then begin
    if nKind = KIND_NOTICE then begin
      // 클라이언트로 게시판 내용 갱신.
      CmdReloadGaBoardList(TGuild(MyGuild).GuildName, nCurPage{현재페이지});
    end else begin
      // OrgNum 추출.
      GetValidStr3(body, strTemp, ['/', #0]);
      OrgNum := Str_ToInt(strTemp, -1);

      // 원본 글쓰기이면 첫페이지...
      if OrgNum = 0 then begin
        // 클라이언트로 게시판 내용 갱신.
        CmdReloadGaBoardList(TGuild(MyGuild).GuildName, 1{첫페이지});
      end else begin
        // 아니면 현재페이지...
        // 클라이언트로 게시판 내용 갱신.
        CmdReloadGaBoardList(TGuild(MyGuild).GuildName, nCurPage{현재페이지});
      end;
    end;
  end;
end;

// 장원 게시판 글삭제.
procedure TUserHuman.ServerGetGaBoardDel(nCurPage: integer; body: string);
var
  GuildAgitNum: integer;
  guildagit:    TGuildAgit;
begin
  GuildAgitNum := 0;

  if MyGuild = nil then
    exit;
  if TGuild(MyGuild).GuildName = '' then
    exit;

  //쿼리에 들어가서는 안되는 글자.
  if StrScan(PChar(body), '''') <> nil then
    exit;

  guildagit := GuildAgitMan.GetGuildAgit(TGuild(MyGuild).GuildName);
  if guildagit <> nil then begin
    GuildAgitNum := guildagit.GuildAgitNumber;
  end;

  // 내용 앞에 유저이름 추가.
  if GuildAgitBoardMan.DelArticle(TGuild(MyGuild).GuildName, UserName, body) then begin
    // 클라이언트로 게시판 내용 갱신.
    CmdReloadGaBoardList(TGuild(MyGuild).GuildName, nCurPage{현재페이지});
  end;
end;

// 장원 게시판 글수정.
procedure TUserHuman.ServerGetGaBoardEdit(nCurPage: integer; body: string);
var
  GuildAgitNum: integer;
  guildagit:    TGuildAgit;
begin
  GuildAgitNum := 0;

  if MyGuild = nil then
    exit;
  if TGuild(MyGuild).GuildName = '' then
    exit;

  //쿼리에 들어가서는 안되는 글자.
  if StrScan(PChar(body), '''') <> nil then
    exit;

  guildagit := GuildAgitMan.GetGuildAgit(TGuild(MyGuild).GuildName);
  if guildagit <> nil then begin
    GuildAgitNum := guildagit.GuildAgitNumber;
  end;

  // 내용 앞에 유저이름 추가.
  if GuildAgitBoardMan.EditArticle(TGuild(MyGuild).GuildName, UserName, body) then begin
    // 클라이언트로 게시판 내용 갱신.
    CmdReloadGaBoardList(TGuild(MyGuild).GuildName, nCurPage{현재페이지});
  end;
end;

//장원 문주 체크.
procedure TUserHuman.ServerGetGaBoardNoticeCheck;
begin
  if IsMyGuildMaster then begin
    SendMsg(self, RM_GABOARD_NOTICE_OK, 0, 0, 0, 0, UserName);
  end else begin
    SendMsg(self, RM_GABOARD_NOTICE_FAIL, 0, 0, 0, 0, UserName);
  end;
end;

//장원꾸미기 아이템 구입
procedure TUserHuman.ServerGetDecoItemBuy(msg, npcid, ItemIndex: integer;
  itemname: string);
var
  i:   integer;
  npc: TCreature;
begin
  if BoDealing then
    exit;  //교환중에는 물건을 살 수 없다.
  npc := UserEngine.GetMerchant(npcid);
  if npc <> nil then begin
    if (npc.PEnvir = PEnvir) and (abs(npc.CX - CX) <= 15) and
      (abs(npc.CY - CY) <= 15) then  begin
      if msg = CM_DECOITEM_BUY then begin
        if ItemIndex >= 0 then
          CmdBuyDecoItem(ItemIndex);
      end;
    end;
  end;
end;

 // 장원 거래 성사 -> 장원 목록에 기록.
 // 리턴값 : 장원번호 (-1 이면 Error)
function TUserHuman.ExecuteGuildAgitTrade: integer;
var
  gname, mastername, deal_gname, deal_mastername: string;
  guildagit, deal_guildagit: TGuildAgit;
begin
  Result := -1;

  if IsGuildMaster then begin   // 문주이면
    if DealCret.IsGuildMaster then begin   // 상대방도 문주이면
      gname      := TGuild(MyGuild).GuildName;
      mastername := UserName;
      deal_gname := TGuild(DealCret.MyGuild).GuildName;
      deal_mastername := DealCret.UserName;

      // 자기 자신의 문파 장원을 찾는다.
      guildagit      := GuildAgitMan.GetGuildAgit(gname);
      deal_guildagit := GuildAgitMan.GetGuildAgit(deal_gname);

      // 둘 다 장원을 소유하고 있으면
      if (guildagit <> nil) and (deal_guildagit <> nil) then begin
        BoxMsg('The other party already owns another guild territory.', 0);
        DealCret.BoxMsg('The other party already owns another guild territory.', 0);
        exit;
      end;

      if guildagit <> nil then begin
        if guildagit.GetCurrentDelayStatus <= 0 then begin
          BoxMsg('The rent term is about to expire so you can sell the guild territory.',
            0);
          DealCret.BoxMsg(
            'The rent term is about to expire so you can sell the guild territory.', 0);
          exit;
        end;
        if (guildagit.IsForSale = False) or guildagit.IsSoldOut then begin
          BoxMsg('The guild territory is currently not on sale.', 0);
          DealCret.BoxMsg('The guild territory is not on sale.', 0);
          exit;
        end;
        if GuildAgitMan.IsExistInForSaleGuild(
          TGuild(DealCret.MyGuild).GuildName) then begin
          BoxMsg('The other party has already made a purchase request.', 0);
          DealCret.BoxMsg('Purchase request has been already made.', 0);
          exit;
        end;
        if TGuild(DealCret.MyGuild).GetTotalMemberCount <= MINAGITMEMBER then begin
          BoxMsg('The other party should have at least ' +
            IntToStr(MINAGITMEMBER) + ' guild members.', 0);
          DealCret.BoxMsg('You need at least ' + IntToStr(MINAGITMEMBER) +
            ' guild members for that.', 0);
          exit;
        end;
        // 장원 거래 성사
        if GuildAgitMan.GuildAgitTradeOk(gname, deal_gname, deal_mastername) then
        begin
          DealCret.BoxMsg('The deal for guild territory is made. After ' +
            IntToStr(GUILDAGIT_SALEWAIT_DAYUNIT) +
            ' days, the ownership is transferred.\ \The remaining rental period of this guild territory is '
            + IntToStr(GuildAgitMan.GetTradingRemainDate(gname)) + ' days.', 0);
          Result := guildagit.GuildAgitNumber;
        end;
      end else begin
        if deal_guildagit <> nil then begin
          if deal_guildagit.GetCurrentDelayStatus <= 0 then begin
            BoxMsg('The rent term is about to expire so you can sell the guild territory.', 0);
            DealCret.BoxMsg(
              'The rent term is about to expire so you can sell the guild territory.',
              0);
            exit;
          end;
          if (deal_guildagit.IsForSale = False) or deal_guildagit.IsSoldOut then
          begin
            BoxMsg('The guild territory is not on sale.', 0);
            DealCret.BoxMsg('The guild territory is currently not on sale.', 0);
            exit;
          end;
          if GuildAgitMan.IsExistInForSaleGuild(TGuild(MyGuild).GuildName) then
          begin
            BoxMsg('Purchase request has been already made.', 0);
            DealCret.BoxMsg(
              'The other party has already made a purchase request.', 0);
            exit;
          end;
          if TGuild(MyGuild).GetTotalMemberCount <= MINAGITMEMBER then begin
            BoxMsg('You need at least ' + IntToStr(MINAGITMEMBER) +
              ' guild members for that.', 0);
            DealCret.BoxMsg('The other party should have at least ' +
              IntToStr(MINAGITMEMBER) + ' guild members.', 0);
            exit;
          end;
          // 장원 거래 성사
          if GuildAgitMan.GuildAgitTradeOk(deal_gname, gname, mastername) then
          begin
            BoxMsg('The deal for guild territory is made. After ' +
              IntToStr(GUILDAGIT_SALEWAIT_DAYUNIT) +
              ' days, the ownership is transferred.\ \The remaining rental period of this guild territory is '
              + IntToStr(GuildAgitMan.GetTradingRemainDate(deal_gname)) + ' days.', 0);
            Result := deal_guildagit.GuildAgitNumber;
          end;
        end else begin
          BoxMsg('Not Available.', 0);
          DealCret.BoxMsg('Not Available.', 0);
        end;
      end;
    end else begin
      SysMsg('This person is not a guild master.', 0);
    end;
  end else begin
    SysMsg('Only guild master can use this command.', 0);
  end;
end;

procedure TUserHuman.SendUserMarketCloseMsg;
begin
  SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_MarketNotReady, 0, '');
  BoxMsg('You cannot use commission merchant system.', 1);
end;

procedure TUserHuman.RequireLoadRefresh;
begin

  if not SqlEngine.RequestLoadPageUserMarket(FUserMarket.REqInfo) then begin
    SendUserMarketCloseMsg;
    Exit;
  end;

end;
//위탁판매 리스트 읽기.
procedure TUserHuman.RequireLoadUserMarket(MarketName: string;
  // 마켓이름 : 서버+NPC 이름
  ItemType: integer;  // 아이템 종류 구분자
  UserMode: integer;  // 유저의 작업 종류
  OtherName: string;    // 다른사람의 이름으로 검색할때 사용 : 현재 미사용
  ItemName_: string);
var
  isok: boolean;
begin

  FUserMarket.ReqInfo.UserName   := UserName;
  FUserMarket.ReqInfo.MarketName := MarketName;
  FUserMarket.ReqInfo.SearchWho  := OtherName;
  FUserMarket.ReqInfo.SearchItem := ItemName_;
  FUserMarket.ReqInfo.ItemType   := ItemType;
  FUserMarket.ReqInfo.ItemSet    := 0;
  FUserMarket.ReqInfo.UserMode   := UserMode;

  isOk := False;

  case ItemType of

    USERMARKET_TYPE_ALL,              // 모두
    USERMARKET_TYPE_WEAPON,           // 무기
    USERMARKET_TYPE_NECKLACE,         // 목걸이
    USERMARKET_TYPE_RING,             // 반지     ㄱ
    USERMARKET_TYPE_BRACELET,         // 팔찌,장갑
    USERMARKET_TYPE_CHARM,            // 수호석
    USERMARKET_TYPE_HELMET,           // 투구
    USERMARKET_TYPE_BELT,             // 허리띠
    USERMARKET_TYPE_SHOES,            // 신발
    USERMARKET_TYPE_ARMOR,            // 갑옷
    USERMARKET_TYPE_DRINK,            // 시약
    USERMARKET_TYPE_JEWEL,            // 보옥,신주
    USERMARKET_TYPE_BOOK,             // 책
    USERMARKET_TYPE_MINERAL,          // 광석
    USERMARKET_TYPE_QUEST,            // 퀘스트
    USERMARKET_TYPE_ETC,              // 기타
    USERMARKET_TYPE_OTHER,            // 다른사람이 판물건
    USERMARKET_TYPE_ITEMNAME:         // 아이템 이름으로 검색
    begin
      IsOk := True;
    end;
    // 셋트류
    USERMARKET_TYPE_SET:         // 셋트 아이템
    begin
      FUserMarket.ReqInfo.ItemSet := 1;
      IsOk := True;
    end;
    // 유저류
    USERMARKET_TYPE_MINE:         // 자신이판물건
    begin
      FUserMarket.ReqInfo.SearchWho := UserName;
      IsOk := True;
    end;

  end;
  if IsOk then begin
    if not SqlEngine.RequestLoadPageUserMarket(FUserMarket.ReqInfo) then begin
      SendUserMarketCloseMsg;
      Exit;
    end;
  end;

end;

 // 클라이언트에 요청함 ---------------------------------------------------------
 // 가방에 존재하나 검사
function TUserHUman.IsExistBagItem(makeindex_: integer): PTUserItem;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ItemList.Count - 1 do begin
    if PTUserItem(ItemList[i]).MakeIndex = makeindex_ then begin
      Result := ItemList[i];
      Exit;
    end;
  end;
end;

// 가방이 꽉찼나 검사 임시로...
function TUserHuman.IsFullBagCount: boolean;
begin
  Result := True;
  if ItemList.Count < MAXBAGITEM then
    Result := False;
end;

//위탁상점을 사용할수 있는 지 레벨등을 검사
function TUserHUman.IsEnableUseMarket: boolean;
begin
  Result := False;

  //---------위탁복사버그 수정----------
  // 현재 요청 중인 상태이면 이용할 수 없다.
  if BoFlagUserMarket then
    exit;

  if FMarketNPC <> nil then begin
    // 위탁 NPC와 다른 맵에 있으면 위탁 기능을 이용할 수 없다.
    if MapName <> FMarketNPC.MapName then
      exit;

    // 위탁 NPC로부터 일정 거리를 벗어나면 위탁 기능을 이용할 수 없다.
    if not ((abs(CX - FMarketNPC.CX) <= 8) and (abs(CY - FMarketNPC.CY) <= 8)) then
      exit;
  end else begin
    // 위탁 NPC가 존재하지 않으면 위탁 기능을 이용할 수 없다.
    exit;
  end;
  //------------------------------------

  // 레벨 검사
  if Abil.Level >= MARKET_ALLOW_LEVEL then begin
    Result := True;
  end else begin
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_NoItem, 0, '');
    BoxMsg('Only level ' + IntToStr(MARKET_ALLOW_LEVEL) +
      ' character or higher is allowed.', 1);
  end;

end;

//아이템 삭제 및 전송....
function TUserHuman.DeleteFromBagItem(MakeIndex_: integer;
  SellCount_: integer): boolean;
var
  i:      integer;
  ui, pi: PTUserItem;
  pstd:   PTStdItem;
  rmcount: integer;
  rmItemName: string;
begin
  Result := False;
  for i := ItemList.Count - 1 downto 0 do begin
    ui := PTUserItem(ItemList[i]);
    if (ui <> nil) and (ui.MakeIndex = MakeIndex_) then begin
      pStd := UserEngine.GetStdItem(ui.Index);

      // 겹치기 아이템이 분리가 필요한 경우에는 나머지 아이템 개수를 얻고
      rmCount := 0;
      if (pStd.OverlapItem >= 1) and (ui.Dura > SellCount_) then begin
        rmCount    := ui.Dura - SellCount_;
        rmItemName := pStd.Name;
      end;

      // 아이템 삭제하고
      SendDelItem(ui^);
      Dispose(ui);
      ItemList.Delete(i);

      // 겹치기인 경우 나머지 값을 새로운 아이템으로 넣어준다.
      if (pStd.OverlapItem >= 1) and (rmCount > 0) then begin
        new(pi);
        if UserEngine.CopyToUserItemFromName(rmItemName, pi^) then begin
          //아이템 개수 적용(광석의 순도 적용)....
          pi.Dura := rmCount;
          ItemList.Add(pi);
          SendAddItem(pi^);
        end else
          Dispose(pi);
      end;

      WeightChanged;

      Result := True;
      Exit;
    end;
  end;
end;

// 마켓이름을 얻어오자.
function TUserHuman.GetMarketName: string;
begin
  if FMarketNPC <> nil then
    Result := ServerName + '_' + FMarketNPC.UserName
  else
    Result := ServerName + '_' + 'NO_NPC';
end;

// 가방에 아이템 넣기
function TUserHuman.AddToBagItem(UserItem_: TUserItem): boolean;
var
  pu: PTuserItem;
begin
  Result := False;
  // 가방에 들어갈수 있나 검사
  if not IsFullBagCount then begin
    new(pu);
    pu^    := UserItem_;
    Result := AddItem(pu);

    if Result then begin
      WeightChanged;
      SendAddItem(pu^);
    end else begin
      dispose(pu);
    end;
  end;
end;

// 아이템을 팔수 있는 창을 띄우라고 클라이언트에 알림
procedure TUserHuman.SendUserMarketSellReady(MarketNpc: TCreature);
begin
  if MarketNpc <> nil then
    FMarketNPC := MarketNpc;

  if not IsEnableUseMarket then begin
    BoxMsg('Commission merchant function is not available.', 0);
    Exit;
  end;

  //   0,Recog , param , tag
  //   SendMsg(self, RM_MARKET_RESULT, 0,1,2,3, '');
  //   SendMsg(self, RM_MARKET_RESULT, 0,integer(Npc_),UMResult_ReadyToSell,0,'');

  //위탁취소
  if not SqlEngine.RequestReadyToSellUserMarket(
    UserName, GetMarketName, UserName) then
  begin
    SendUserMarketCloseMsg;
    Exit;
  end;
end;

// 아이템 --> 위탁판매
procedure TUserHuman.RequireSellUserMarket(MakeIndex_: integer;  // 위탁할 아이템
  SellCount_: integer;  // 개수
  SellPrice_: integer); // 위탁금액
var
  pInfo: PTMarketLoad;
  pUserItem: PTUserITem;
  ps: PTStdItem;
begin
  if not IsEnableUseMarket then begin
    BoxMsg('Commission merchant function is not available.', 0);
    Exit;
  end;

  //위탁금액이 위탁시 뺏는  금액보다는 커야됨
  if (SellPrice_ < MARKET_CHARGE_MONEY) then begin
    // 위탁금액이 너무 작음
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_LessTrustMoney, 0, '');
    BoxMsg('Minimum limit is ' + IntToStr(MARKET_CHARGE_MONEY) + ' gold.', 1);
    Exit;
  end;

  //최대 금액보다 클수는 없다.
  if SellPrice_ > MARKET_MAX_TRUST_MONEY then begin
    // 위탁금액이  너무 큼
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_MaxTrustMoney, 0, '');
    BoxMsg('Maximum limit is ' + IntToStr(MARKET_MAX_TRUST_MONEY) + ' gold.', 1);
    Exit;
  end;

  //가지고 있는 돈이 필요금액보다 커야됨
  if Gold < MARKET_CHARGE_MONEY then begin
    //돈이 부족하다.
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_LessMoney, 0, '');
    BoxMsg('Lack of Gold.', 1);
    Exit;
  end;

  // 아이템이 있나 검사하자.
  pUserItem := IsExistBagItem(MakeIndex_);
  if nil = pUserItem then begin
    // 아이템이 없군..
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_NoItem, 0, '');
    BoxMsg('No item found.', 1);
    Exit;
  end;

  // 아이템을 데이터 베이스에 저장하자.
  // 데이터 베이스에 저장된것은 임시로 저장되고나서 다시 게임쪽에서
  // 인증을 해야 정상적으로 처리된다.. 서버다운시 고려해야됨.


  ps := UserEngine.GetStdItem(pUserItem.Index);
  if ps = nil then begin
    Exit;
  end;

  if ps.ItemType = 0 then begin
    // 아이템이 없군..
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_DontSell, 0, '');
    //      BoxMsg ('위탁할 수 없는 아이템입니다.', 1);
    Exit;
  end;

  // 겹치기 아이템일 경우
  if ps.OverlapItem >= 1 then begin
    // 가지고 있는 최대 개수를 넘을수는 없다.
    if (pUserItem.Dura < SellCount_) or (SellCount_ <= 0) then begin
      // 아이템이 없군..
      SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_DontSell, 0, '');
      //         BoxMsg ('위탁할 수 없는 아이템입니다.', 1);
      Exit;
    end;
  end else begin
    SellCount_ := 0;
  end;

  New(pInfo);
  pInfo.UserItem   := pUserItem^;
  pInfo.SellPrice  := SellPrice_;
  pInfo.MarketName := GetMarketName;
  pInfo.ItemName   := ps.Name;
  pInfo.MarketType := ps.ItemType;
  pInfo.Index      := 0;
  pInfo.SetType    := ps.ItemSet;
  pInfo.SellWho    := UserName;
  pInfo.SellCount  := SellCount_;

  // 겹치기 아이템이고 개수가 분리되어야 될 경우이면
  if (ps.OverlapItem >= 1) and (SellCount_ > 0) then begin
    pInfo.UserItem.dura := SellCount_;
  end;

  if not SqlEngine.RequestSellItemUserMarket(UserName, pInfo) then begin
    Dispose(pInfo);
    SendUserMarketCloseMsg;
    BoFlagUserMarket := False;
    Exit;
  end;

  BoFlagUserMarket := True;
end;

// 위탁판매 --> 아이템 , 돈감소
procedure TUserHuman.RequireBuyUserMarket(MarketNpc: TCreature; SellIndex_: integer);
var
  rMoney: integer;
begin
  if not IsEnableUseMarket then begin
    BoxMsg('Commission merchant function is not available.', 0);
    Exit;
  end;

  if not FuserMarket.IsExistIndex(SellIndex_, rMoney) then begin
    // 인덱스가 존재하지 않습니다.
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_NoItem, 0, '');
    BoxMsg('The item does not exist.', 1);
    Exit;
  end;

  if Gold < (rMoney) then begin
    //돈이 부족하다.
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_LessMoney, 0, '');
    BoxMsg('Lack of Gold.', 1);  //Not enough Gold.
    Exit;
  end;

  // 가방이 꽉찼나 검사
  if IsFullBagCount then begin
    // 가방이 꽉찼군.
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_MaxBagItemCount, 0, '');
    BoxMsg('The bag is full.', 1);
    Exit;
  end;

  if FUserMarket.IsMyItem(SellIndex_, UserName) then begin
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_DontBuy, 0, '');
    BoxMsg('You can not purchase the item you listed for sale.', 1);
    Exit;
  end;

  // 위탁물품 사기
  if not SqlEngine.RequestBuyItemUserMarket(UserName, GetMarketName,
    UserName, SellIndex_) then begin
    SendUserMarketCloseMsg;
    BoFlagUserMarket := False;
    Exit;
  end;

  BoFlagUserMarket := True;
end;

// 위탁판매 --> 아이템 , 돈 변화없음.
procedure TUserHuman.RequireCancelUserMarket(MarketNpc: TCreature; SellIndex_: integer);
begin
  if not IsEnableUseMarket then begin
    BoxMsg('Commission merchant function is not available.', 0);
    Exit;
  end;

  if not FUserMarket.IsMyItem(SellIndex_, Self.UserName) then begin
    // 아이템의 판매자가 일치하지 않음.
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_CancelFail, 0, '');
    BoxMsg('The ownership of the item contradicts with the current owner.', 1);
    Exit;
  end;

  // 가방이 꽉찼나 검사
  if IsFullBagCount then begin
    // 가방이 꽉찼군.
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_MaxBagItemCount, 0, '');
    boxMsg('The bag is full.', 1);
    Exit;
  end;

  //위탁취소
  if not SqlEngine.RequestCancelSellUserMarket(
    UserName, GetMarketName, UserName, SellIndex_) then begin
    SendUserMarketCloseMsg;
    BoFlagUserMarket := False;
    Exit;
  end;

  BoFlagUserMarket := True;
end;

// 위탁판매 --> 돈
procedure TUserHuman.RequireGetPayUserMarket(MarketNpc: TCreature; SellIndex_: integer);
var
  rMoney: integer;
begin
  if not IsEnableUseMarket then begin
    BoxMsg('Commission merchant function is not available.', 0);
    Exit;
  end;

  // 아이템이 내껀가 검사
  if not FUserMarket.IsMyItem(SellIndex_, Self.UserName) then begin
    // 아이템의 판매자가 일치하지 않음.
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_CancelFail, 0, '');
    BoxMsg('The ownership of the item contradicts with the current owner.', 1);
    Exit;
  end;

  // 인덱스가 존재하는지 검사
  if not FuserMarket.IsExistIndex(SellIndex_, rMoney) then begin
    // 아이템의 판매자가 일치하지 않음.
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_NoItem, 0, '');
    BoxMsg('There is no item.', 1);
    Exit;
  end;

  // 소유할수 있는 최대금액 검사.
  if Gold + rMoney > AvailableGold then begin
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_OverMoney, 0, '');
    BoxMsg('Maximum gold limit has exceeded.', 1);
    Exit;
  end;

  //금액 회수
  //위탁취소
  if not SqlEngine.RequestGetPayUserMarket(UserName, GetMarketName,
    UserName, SellIndex_) then begin
    SendUserMarketCloseMsg;
    BoFlagUserMarket := False;
    Exit;
  end;

  BoFlagUserMarket := True;
end;

//실제로 데이터가 전송 및 변화되는 부분 -----------------------------------------

procedure TUserHuman.GetMarketData(pInfo: PTSearchSellItem);
var
  pMarketInfo: PTMarketItem;
  pDbInfo: PTMarketLoad;
  i:   integer;
  ps:  PTStdItem;
  std: TStdItem;
begin
  if pInfo.IsOK <> UMRESULT_SUCCESS then
    Exit;

  if pInfo.pList <> nil then begin
    //일단 지우고...
    FUserMarket.Clear;
    // 유저모드를 다시지정
    FUserMarket.UserMode := pInfo.UserMode;
    // 아이템 타입을 다시지정
    FUserMarket.ItemType := pInfo.ItemType;

    for i := 0 to pInfo.pList.Count - 1 do begin
      pDBInfo := pInfo.pList.Items[i];

      if pDBInfo <> nil then begin
        ps := UserEngine.GetStdItem(pDBInfo.UserItem.Index);
        if ps <> nil then begin
          new(pMarketinfo);
          std := ps^;

          pMarketinfo.UpgCount :=
            ItemMan.GetUpgradeStdItem(pDBInfo.UserItem, std);
          Move(std, pMarketinfo.item.S, sizeof(TStdItem));

          pMarketinfo.item.MakeIndex := pDBInfo.UserItem.MakeIndex;
          pMarketinfo.item.Dura      := pDBInfo.UserItem.Dura;
          pMarketinfo.item.DuraMax   := pDBInfo.UserItem.DuraMax;

          pMarketinfo.Index     := pDBInfo.Index;
          pMarketinfo.SellPrice := pDBInfo.SellPrice;
          pMarketinfo.SellDate  := pDBInfo.Selldate;
          pMarketinfo.SellState := pDBInfo.SellState;
          pMarketinfo.SellWho   := pDBInfo.SellWho;


          FUserMarket.Add(pMarketInfo);
        end;
      end;
    end;   // for

  end;
end;
//위탁판매 리스트 전송
procedure TUserHuman.SendUserMarketList(NextPage: integer);
var
  marketitem: PTMarketItem;
  Count:   integer;
  i, cnt:  integer;
  Buffer:  string;
  cnt_start: integer;
  cnt_end: integer;
  bFirstSend: integer;
  page:    integer;
  maxpage: integer;
begin

  //데이터를 모아서...
  Buffer := '';
  cnt    := 0;
  page   := 0;

  // page = 0 이면 처음 전송하는것으로 판단한다.
  if NextPage = 0 then begin
    //클라이언트에게 초기화를 요구
    bFirstSend := 1;
    page := 1;
  end else begin
    //클라이언트에게 초기화 하지 말기를 요구
    bFirstSend := 0;
  end;

  //다음페이지 요구
  if (NextPage = 1) then
    page := FUserMarket.CurrPage + 1;

  //페이지 설정
  FUserMarket.CurrPage := page;
  maxpage   := FUserMarket.PageCount;
  // 시작위치 얻기
  cnt_start := (page - 1) * MAKET_ITEMCOUNT_PER_PAGE;
  // 끝 위치 얻기
  cnt_end   := cnt_start + MAKET_ITEMCOUNT_PER_PAGE - 1;
  // 범위검사
  if cnt_end >= FUserMarket.Count then
    cnt_end := FUserMarket.Count - 1;

  // 데이터 만들기...
  for i := cnt_start to cnt_end do begin
    marketitem := FUserMarket.GetItem(i);

    if marketitem <> nil then begin
{$IFDEF DEBUG}
         MainOutMessage('LIST :'+ marketitem.SellWho+','+marketitem.Item.S.Name);
{$ENDIF}
      Inc(cnt);
      buffer := Buffer + EncodeBuffer(pointer(marketitem),
        sizeof(TMarketItem)) + '/';
    end;
  end;

  buffer := IntToStr(cnt) + '/' + IntToStr(Page) + '/' + IntToStr(maxpage) +
    '/' + Buffer;
  // 데이터 전송
  SendMsg(self, RM_MARKET_LIST, 0, FUserMarket.UserMode, FUsermarket.Itemtype,
    bFirstSend, buffer);

end;

// 아이템 --> 위탁판매
procedure TUserHuman.SellUserMarket(pSellItem: PTMarketLoad);
var
  _makeindex: integer;
  _SellCount: integer;
  countstr:   string;
begin
  countstr := '';
  if pSellItem.IsOK <> UMRESULT_SUCCESS then
    Exit;

  _makeindex := pSellItem.UserItem.MakeIndex;
  _SellCount := pSellItem.SellCount;

  if not FlagReadyToSellCheck then begin
    // 아이템이 없음 잘못되었음을 DB에 알려주자
    SqlEngine.CheckToDB(UserName, pSellItem.MarketName, pSellItem.SellWho,
      _MakeIndex, 0, MARKET_CHECKTYPE_SELLFAIL);

    AddUserLog('32'#9 + //위맞_
      MapName + ''#9 + IntToStr(0) + ''#9 + IntToStr(0) + ''#9 +
      UserName + ''#9 + pSellItem.ItemName + ''#9 + IntToStr(_makeindex) +
      ''#9 + '1'#9 + '1');
    exit;
  end;

  // 아이템 삭제하자.
  if DeleteFromBagItem(_makeindex, _SellCount) then begin
    countstr := '(' + IntToStr(_SellCount) + ')';
    // 위탁금액 빼자.
    DecGold(MARKET_CHARGE_MONEY);
    GoldChanged;

    // 잘 받았다고 DB에 알려준다.
    SqlEngine.CheckToDB(UserName, pSellItem.MarketName, pSellItem.SellWho,
      _MakeIndex, 0, MARKET_CHECKTYPE_SELLOK);

    // 아이템을 잘 위탁하였음
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_SellOK, 0, '');
    //      BoxMsg ('아이템을 위탁하였습니다.', 1);

    AddUserLog('32'#9 + //위맞_
      MapName + ''#9 + IntToStr(MARKET_CHARGE_MONEY) + ''#9 +
      IntToStr(Gold) + ''#9 + UserName + ''#9 + pSellItem.ItemName +
      ''#9 + IntToStr(_makeindex) + ''#9 + '1'#9 + '0' + countstr);
    //개수로그(sonmg 2005/01/07)

  end else begin
    // 아이템이 없음 잘못되었음을 DB에 알려주자
    SqlEngine.CheckToDB(UserName, pSellItem.MarketName, pSellItem.SellWho,
      _MakeIndex, 0, MARKET_CHECKTYPE_SELLFAIL);

    AddUserLog('32'#9 + //위맞_
      MapName + ''#9 + IntToStr(0) + ''#9 + IntToStr(0) + ''#9 +
      UserName + ''#9 + pSellItem.ItemName + ''#9 + IntToStr(_makeindex) +
      ''#9 + '1'#9 + '1');

  end;

  BoFlagUserMarket     := False;
  FlagReadyToSellCheck := False;
end;

// 위탁판매 가능한지 검토
procedure TUserHuman.ReadyToSellUserMarket(pReadyItem: PTMarketLoad);
begin
  if pReadyItem.IsOK <> UMRESULT_SUCCESS then
    Exit;

  if pReadyItem.SellCount < MARKET_MAX_SELL_COUNT then begin
    // 아이템을 위탁할수 있습니다.
    SendMsg(self, RM_MARKET_RESULT, 0, integer(FMarketNpc),
      UMResult_ReadyToSell, 0, '');
  end else begin
    // 아이템을 위탁할 수 없습니다.
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_OverSellCount, 0, '');
    //      BoxMsg ('아이템위탁 개수가 초과하여 위탁할 수 없습니다.', 1);
  end;

  FlagReadyToSellCheck := True;
end;

// 위탁판매 --> 아이템 , 돈감소
procedure TUserHuman.BuyUserMarket(pBuyItem: PTMarketLoad);
var
  pu: PTUserItem;
  ps: PTStdItem;
  countstr: string;
begin
  countstr := '';
  pu := nil;
  ps := nil;

  if pBuyItem.IsOK <> UMResult_Success then begin
    BoxMsg('Failed to buy the item.', 1);
    Exit;
  end;

  // 위탁 디버그(sonmg 2005/01/31)
  if Gold < pBuyItem.SellPrice then
    MainOutMessage('TUserHuman.BuyUserMarket : The Lack of Gold');

  // 아이템을 등록하구 나서
  if AddToBagItem(pBuyItem.UserItem) then begin
    ps := UserEngine.GetStdItem(pBuyItem.UserItem.Index);
    if ps <> nil then begin
      countstr := '(' + IntToStr(pBuyItem.UserItem.Dura) + ')';
    end;

    // 돈을 감소시키고 나서
    DecGold(pBuyItem.SellPrice);
    GoldChanged;

    // 잘 받았다고 DB 에 알려준다.
    SqlEngine.CheckToDB(UserName, pBuyItem.MarketName, UserName, 0,
      pBuyItem.Index, MARKET_CHECKTYPE_BUYOK);


    // 아이템을 잘 구입하였음.
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_BuyOK, 0, '');
    //      BoxMsg (pBuyItem.ItemName+ ' 아이템을 구입하였습니다.', 1);

    RequireLoadRefresh;

    AddUserLog('33'#9 + //위구입_(위찾)
      MapName + ''#9 + IntToStr(pBuyItem.SellPrice) + ''#9 +
      IntToStr(Gold) + ''#9 + UserName + ''#9 + pBuyItem.ItemName +
      ''#9 + IntToStr(pBuyItem.UserItem.MakeIndex) + ''#9 + '1'#9 + '0' + countstr);
    //개수로그(sonmg 2005/01/07)

  end else begin
    // 아이템 저장이 실패
    if pu <> nil then
      dispose(pu);

    SqlEngine.CheckToDB(UserName, pBuyItem.MarketName, pBuyItem.SellWho, 0,
      pBuyItem.Index, MARKET_CHECKTYPE_BUYFAIL);

    AddUserLog('33'#9 + //위구입_(위찾)
      MapName + ''#9 + IntToStr(0) + ''#9 + IntToStr(0) + ''#9 +
      UserName + ''#9 + pBuyItem.ItemName + ''#9 +
      IntToStr(pBuyItem.UserItem.MakeIndex) + ''#9 + '1'#9 + '1');

  end;

  BoFlagUserMarket := False;
end;
// 위탁판매 --> 아이템 , 돈같음
procedure TUserHuman.CancelUserMarket(pCancelItem: PTMarketLoad);
begin
  if pCancelItem.IsOK <> UMResult_Success then begin
    BoxMsg('Failed to cancel the item sale.', 1);
    Exit;
  end;

  // 아이템을 등록하구 나서.
  if AddToBagItem(pCancelItem.UserItem) then begin

    // 돈의 변화는 없고

    // 잘 받았다고 DB 에 알려준다.
    SqlEngine.CheckToDB(UserName, pCancelItem.MarketName,
      pCancelItem.SellWho, 0, pCancelItem.Index, MARKET_CHECKTYPE_CANCELOK);
    RequireLoadRefresh;
    // 아이템을 잘 취소하였음.
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_CancelOK, 0, '');
    //      BoxMsg ('위탁한 '+pCancelItem.ItemName+' 아이템을 취소하였습니다.', 1);

    AddUserLog('34'#9 + //위취_
      MapName + ''#9 + IntToStr(0) + ''#9 + IntToStr(0) + ''#9 +
      UserName + ''#9 + pCancelItem.ItemName + ''#9 +
      IntToStr(pCancelItem.UserItem.MakeIndex) + ''#9 + '1'#9 + '0');

  end else begin

    SqlEngine.CheckToDB(UserName, pCancelItem.MarketName,
      pCancelItem.SellWho, 0, pCancelItem.Index, MARKET_CHECKTYPE_CANCELFAIL);

    AddUserLog('34'#9 + //위취_
      MapName + ''#9 + IntToStr(0) + ''#9 + IntToStr(0) + ''#9 +
      UserName + ''#9 + pCancelItem.ItemName + ''#9 +
      IntToStr(pCancelItem.UserItem.MakeIndex) + ''#9 + '1'#9 + '1');

  end;

  BoFlagUserMarket := False;
end;

// 위탁판매 --> 돈
procedure TUserHuman.GetPayUserMarket(pGetpayItem: PTMarketLoad);
var
  commision: integer;
begin
  if pGetpayItem.IsOK <> UMResult_Success then begin
    BoxMsg('Failed to get back the money.', 1);
    Exit;
  end;

  if (pGetpayItem.SellPrice >= 0) then begin

    commision := pGetpayItem.SellPrice * MARKET_COMMISION div 1000;
    // 돈을 더하고 + 수수료는 떼고
    IncGold(pGetpayItem.SellPrice);
    DecGold(commision);
    GoldChanged;
    // 잘 받았다고 DB 에 알려준다.
    SqlEngine.CheckToDB(UserName, pGetpayItem.MarketName,
      pGetPayItem.SellWho, 0, pGetPayItem.Index, MARKET_CHECKTYPE_GETPAYOK);

    RequireLoadRefresh;
    // 아이템을 잘 취소하였음.
    SendMsg(self, RM_MARKET_RESULT, 0, 0, UMResult_GetPayOK, 0, '');
    BoxMsg(IntToStr(pGetpayItem.SellPrice) + ' gold is received after paying ' +
      IntToStr(commision) + ' gold for commission.', 1);

    AddUserLog('35'#9 + //위돈찾_ +
      MapName + ''#9 + IntToStr(pGetpayItem.SellPrice - Commision) +
      ''#9 + IntToStr(Gold) + ''#9 + UserName + ''#9 + pGetpayItem.ItemName +
      ''#9 + IntToStr(pGetpayItem.UserItem.MakeIndex) + ''#9 + '1'#9 + '0');

  end else begin
    // 잘 못 받았다고 DB 에 알려준다.
    SqlEngine.CheckToDB(UserName, pGetpayItem.MarketName,
      pGetPayItem.SellWho, 0, pGetPayItem.Index, MARKET_CHECKTYPE_GETPAYFAIL);

    AddUserLog('35'#9 + //위돈찾_ +
      MapName + ''#9 + IntToStr(0) + ''#9 + IntToStr(0) + ''#9 +
      UserName + ''#9 + pGetpayItem.ItemName + ''#9 +
      IntToStr(pGetpayItem.UserItem.MakeIndex) + ''#9 + '1'#9 + '1');

  end;

  BoFlagUserMarket := False;
end;

procedure TUserHuman.CmdReloadGaBoardList(gname: string; nPage: integer);
begin
  if MyGuild = nil then
    exit;
  if TGuild(MyGuild).GuildName = '' then
    exit;

  if TGuild(MyGuild).GuildName = gname then begin
    CmdGaBoardList(nPage);
  end;
end;

//장원게시판
procedure TUserHuman.CmdGaBoardList(nPage: integer);
const
  ENDOFLINEFLAG = 100;
var
  i, orgnum:      integer;
  strOrgnum, strIndent: string;
  gname, gnameHere, Data: string;
  subjectlist:    TStringList;
  allpage, Count: integer; //전체페이지, 라인넘버
  startline, lastline: integer;
begin
  Data := '';

  if MyGuild <> nil then begin
    if TGuild(MyGuild).GuildName <> '' then begin
      //문파명 복사.
      gname     := TGuild(MyGuild).GuildName;
      gnameHere := GetGuildNameHereAgit;

      // 현재 장원의 문파가 아니면...
      if gname <> gnameHere then begin
        // 운영자는 모든 게시판을 볼 수 있음.
        if UserDegree >= UD_ADMIN then begin
          gname := gnameHere;
        end else begin
          SysMsg('You cannot browse the bulletin.', 0);
          exit;
        end;
      end;

      subjectlist := TStringList.Create;

      GuildAgitBoardMan.GetPageList(UserName, gname, nPage, allpage, subjectlist);

      if subjectlist.Count = 0 then begin
        SysMsg('There is no list.', 0);
      end else begin
        if subjectlist.Count < GABOARD_NOTICE_LINE then begin
          MainOutMessage('[Caution] TUserHuman.CmdGaBoardList : subjectlist < 3');
        end else begin
          Count := 0;
          for i := 0 to subjectlist.Count - 1 do begin
            Inc(Count);
            if i = subjectlist.Count - 1 then
              Count := ENDOFLINEFLAG;

            // 데이터 조합.
            Data := gname + '/' + subjectlist[i];
            // 리스트를 보냄
            SendMsg(self, RM_GABOARD_LIST, 0, nPage, Count, allpage, Data);
            //                  SysMsg(data, 2);  //테스트 게시판
          end;
        end;
      end;

      subjectlist.Free;
    end else begin
      SysMsg('You cannot browse the bulletin.', 0);
    end;
  end else begin
    SysMsg('You cannot browse the bulletin.', 0);
  end;
end;

procedure TUserHuman.CmdBuyDecoItem(nObjNum: integer);
var
  pu:   PTUserItem;
  pstd: PTStdItem;
  pricestr: string;
  sellprice: integer;
  guildagit: TGuildAgit;
  gnamehere: string;
  flag: boolean;
begin
  if nObjNum < 0 then
    exit;
  if ItemList.Count >= MAXBAGITEM then begin
    SysMsg('The bag is full.', 0);
    exit;
  end;

  // 자신의 장원이 아니면 구입할 수 없다.
  flag      := False;
  gnamehere := GetGuildNameHereAgit;
  if gnamehere <> '' then begin
    if MyGuild <> nil then begin
      if TGuild(MyGuild).GuildName = gnamehere then
        flag := True;
    end;
  end;
  if not flag then begin
    BoxMsg('Only guild member of ' + gnamehere + ' may purchase it.', 0);
    exit;
  end;

  new(pu);
  if UserEngine.CopyToUserItemFromName(NAME_OF_DECOITEM, pu^) then begin
    pstd := UserEngine.GetStdItem(pu.Index);

    GuildAgitMan.GetDecoItemName(nObjNum, pricestr);
    sellprice := Str_ToInt(pricestr, DEFAULT_DECOITEM_PRICE);

    if pstd <> nil then begin
      //상현주머니(DecoItem)를 구입한다.
      if (Gold >= sellprice) and (sellprice > 0) then begin
        if GuildAgitDecoItemSet(pu, nObjNum) then begin
          if AddItem(pu) then begin
            DecGold(sellprice);
            GoldChanged;
            SendAddItem(pu^);
            //로그남김
            AddUserLog('9'#9 + //구입_
              MapName + ''#9 + IntToStr(CX) + ''#9 + IntToStr(CY) +
              ''#9 + UserName + ''#9 + UserEngine.GetStdItemName(pu.Index) +
              ''#9 + IntToStr(pu.MakeIndex) + ''#9 + '1'#9 + UserName);
          end else begin
            Dispose(pu);
          end;
        end else begin
          SysMsg('Items can be bought only in the registered guild territories.',
            0);
          Dispose(pu);
        end;
      end else begin
        SysMsg('Lack of Gold.', 0);
        Dispose(pu);
      end;
    end else begin
      Dispose(pu);
    end;
  end else begin
    Dispose(pu);
  end;
end;

//장원꾸미기 아이템 목록 보내기
procedure TUserHuman.SendDecoItemList;
var
  i, Count: integer;
  cg:    TClientGoods;
  l:     TList;
  pstd:  PTStdItem;
  pu:    PTUserItem;
  Data:  string;
  Name, pricestr: string;
  num, kind: word;
  price: integer;
begin
  //리스트에 내용이 없으면 보내지 않음.
  if DecoItemList.Count <= 0 then
    exit;

  Data  := '';
  Count := 0;
  for i := 0 to DecoItemList.Count - 1 do begin
    Name     := DecoItemList[i];
    //가격 추출
    pricestr := GetValidStr3(Name, Name, ['/']);
    price    := Str_ToInt(pricestr, DEFAULT_DECOITEM_PRICE);
    num      := Loword(integer(DecoItemList.Objects[i]));
    kind     := Hiword(integer(DecoItemList.Objects[i]));

    //이름/인덱스/가격/종류
    Data := Data + Name + '/' + IntToStr(num) + '/' + IntToStr(price) +
      '/' + IntToStr(kind) + '/';
    Inc(Count);
  end;
  SendMsg(self, RM_DECOITEM_LIST, 0, integer(self), Count, 0, Data);
end;

end.
