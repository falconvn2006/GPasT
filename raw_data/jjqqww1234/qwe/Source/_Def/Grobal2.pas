unit Grobal2;

interface

uses
  Windows, SysUtils, Classes, Hutil32;

type
  TMsgHeader = record       //����Ʈ�� ���� ��ſ� ���
    Code:    integer;       //$aa55aa55;
    SNumber: integer;       //socket number
    UserGateIndex: word;    //Gate������ Index
    Ident:   word;
    UserListIndex: word;    //������ UserList������ Index
    temp:    word;
    length:  integer;  //body binary �� ����
  end;
  PTMsgHeader = ^TMsgHeader;

  TDefaultMessage = record
    Recog:  integer;       //4
    Ident:  word;          //2
    Param:  word;          //2
    Tag:    word;          //2
    Series: word;          //2
  end;
  PTDefaultMessage = ^TDefaultMessage;

  //Ŭ���̾�Ʈ���� ���
  TChrMsg = record
    ident:  integer;
    x:      integer;
    y:      integer;
    dir:    integer;
    feature: integer;
    state:  integer;
    saying: string;
    sound:  integer;
  end;
  PTChrMsg = ^TChrMsg;

  //�������� ���
  TMessageInfo = record
    Ident:   word;
    wParam:  word;
    lParam1: longint;
    lParam2: longint;
    lParam3: longint;
    Sender:  TObject;
    target:  TObject;
    description: string;
  end;
  PTMessageInfo = ^TMessageInfo;

  TMessageInfoPtr = record
    Ident:   word;
    wParam:  word;
    lParam1: longint;
    lParam2: longint;
    lParam3: longint;
    Sender:  TObject;
    //target  : TObject;
    deliverytime: longword;  //���� �ð�...
    descptr: PChar;
  end;
  PTMessageInfoPtr = ^TMessageInfoPtr;

  TShortMessage = record
    Ident: word;
    msg:   word;
  end;

  TMessageBodyW = record
    Param1: word;
    Param2: word;
    Tag1:   word;
    Tag2:   word;
  end;

  TMessageBodyWL = record
    lParam1: longint;
    lParam2: longint;
    lTag1:   longint;
    lTag2:   longint;
  end;

  TCharDesc = record                  // sm_walk �� �̵� ����
    Feature: integer;                 // 4 = (9)
    Status:  integer;
  end;

  TPowerClass = record
    Min:   byte;
    Ever:  byte;
    Max:   byte;
    dummy: byte;
  end;

  TNakedAbility = record
    DC:    word;
    MC:    word;
    SC:    word;
    AC:    word;
    MAC:   word;
    HP:    word;
    MP:    word;
    Hit:   word;
    Speed: word;
    Reserved: word;
  end;
  PTNakedAbility = ^TNakedAbility;

  TChgAttr = record
    attr: byte;          //����� �Ӽ� �ĺ� 1:AC 2:MAC 3:DC 4:MC 5:SC
    min:  byte;
    //DC,MC,SC�� min/max  AC,MAC�ΰ�� MakeWord(min,max)����
    max:  byte;
  end;

{$ifdef MIR2EI}  //ei���� ���� �Ǵ� �͵�

   //ei
   TStdItem = record
      Name		    : string[30];        //14, ����  ������ �̸� (õ�����ϰ�)
      StdMode      : byte;              //
      Shape 	   : byte;              // ���º� �̸� (ö��)
      CharLooks    : byte;              // gadget
      Weight       : byte;              // ����
      AniCount     : byte;              // 1���� ũ�� �ִϸ��̼� �Ǵ� ������ (�ٸ� �뵵�� ���� ����)
      SpecialPwr   : shortint;          // +�̸� ��������+�ɷ�, -�̸� �𵥵����+
                                        //1~10 ����
                                        //-50~-1 �𵥵� �ɷ�ġ ���
                                        //-100~-51 �𵥵� �ɷ�ġ ����
      ItemDesc     : byte;              //$01 IDC_UNIDENTIFIED  (���̴�Ƽ���� �� �� ��, Ŭ���̾�Ʈ������ ����)
                                        //$02 IDC_UNABLETAKEOFF (�տ��� �������� ����, ������ ��� ����)
                                        //$04 IDC_NEVERTAKEOFF  (�տ��� �������� ����, ������ ��� �Ұ���)
                                        //$08 IDC_DIEANDBREAK   (������ ������ �Ӽ�)
                                        //$10 IDC_NEVERLOSE     (�׾�� �������� ����)
      Looks        : word;              // �׸� ��ȣ
      DuraMax      : word;
      AC           : word;              // ����
      MACType      : byte;
      MAC          : word;              // ���׷�
      DC           : word;              // ������
      MCType       : byte;
      MC           : word;              // ������ ���� �Ŀ�
      AtomDCType   : byte;
      AtomDC       : word;
//      SCType       : byte;
//      SC           : word;              // ������ ���ŷ� gadget
      Need         : byte;              // 0:Level, 1:DC, 2:MC, 3:SC
      NeedLevel    : byte;              // 1..60 level value...
      Price        : integer;
      FuncType     : byte;
      Throw        : byte;              // 1: �׾����� �ȶ��� (gagdet)
                                        // 2: ī��Ʈ�� ������ (gadget)
      Reserved     : array[0..11] of byte;
   end;
   PTStdItem = ^TStdItem;

    TStdItemPack = packed record         // Gadget
        Name	    : array[0..29] of AnsiChar;       // ������ �̸� (õ�����ϰ�)
        StdMode     : byte;              //
        Shape       : byte;             // ���º� �̸� (ö��)
        Weight      : byte;              // ����
        AniCount    : byte;              // 1���� ũ�� �ִϸ��̼� �Ǵ� ������ (�ٸ� �뵵�� ���� ����)
        SpecialPwr  : shortint;          // +�̸� ��������+�ɷ�, -�̸� �𵥵����+
                                        //1~10 ����
                                        //-50~-1 �𵥵� �ɷ�ġ ���
                                        //-100~-51 �𵥵� �ɷ�ġ ����
        ItemDesc     : byte;              //$01 IDC_UNIDENTIFIED  (���̴�Ƽ���� �� �� ��, Ŭ���̾�Ʈ������ ����)
                                        //$02 IDC_UNABLETAKEOFF (�տ��� �������� ����, ������ ��� ����)
                                        //$04 IDC_NEVERTAKEOFF  (�տ��� �������� ����, ������ ��� �Ұ���)
                                        //$08 IDC_DIEANDBREAK   (������ ������ �Ӽ�)
                                        //$10 IDC_NEVERLOSE     (�׾�� �������� ����)
        Looks        : word;              // �׸� ��ȣ
        DuraMax      : word;
        AC           : word;              // ����
        MACType      : byte;
        MAC          : word;              // ���׷�
        DC           : word;              // ������
        MCType       : byte;
        MC           : word;              // ������ ���� �Ŀ�
        AtomDCType   : byte;
        AtomDC       : word;
        Need         : byte;              // 0:Level, 1:DC, 2:MC, 3:SC
        NeedLevel    : byte;              // 1..60 level value...
        Price        : integer;
        FuncType     : byte;
        Throw        : byte;                // 1: �׾����� �ȶ��� (gagdet)
                                            // 2: ī��Ʈ�� ������ (gadget)
    end;
   PTStdItemPack = ^TStdItemPack;

   //ei
   TUserItem = packed record // gadget
      MakeIndex  : integer;      //���������� ������ �ε���(����� ���� �ε��� �Ű���, �ߺ�����)
      Index        : word;          //ǥ�ؾ������� �ε���  0:����, 1���� ������..
      Dura         : word;
      DuraMax      : word;          //����� ������ �ִ밪
      Desc         : array[0..13] of byte;
           //0..7 ������ ���׷��̵� ����
           //10 0:���׷��̵�� ��� ����
           //   1:�ı��� ���׷��̵� ���̴�Ƽ���� �� �Ǿ���
           //   2:���� (�ڿ���) ���׷��̵� ���̴�Ƽ���� �� �Ǿ���
           //   3:���� ���׷��̵� ���̴�Ƽ���� �� �Ǿ��� - Mir2
           //   3:���� (��ȥ��) ���׷��̵� ���̵�Ƽ���� �� �Ǿ��� - Mir3
           //   5:���ݼӵ� ���׷��̵� ���̴�Ƽ���� �� �Ǿ���
           //   9:����, ������
           //11 MAC_TYPE : gadget
           //12 MC_TYPE : gadget
      ColorR       : byte;
      ColorG       : byte;
      ColorB       : byte;
      Prefix       : array [0..12] of AnsiChar;
   end;
   PTUserItem = ^TUserItem;

   //ei (gadget)
   TAbility = packed record
      Level       : byte;
//      reserved1   : byte;     // remaek by gadget
      AC          : word;     //armor class

//      MAC         : word;     //magic armor class
      DC          : word;    //damage class  -> makeword(min/max)

//      MC          : word;    //magic power class   -> makeword(min/max)
//      SC          : word;    //sprite energy class    -> makeword(min/max)

      HP          : word;     //health point
      MP          : word;     //magic point

      MaxHP       : word;     //max health point
      MaxMP       : word;     //max magic point

//      ExpCount    : byte;   //������ , ����
//      ExpMaxCount : byte;   //������ , ����

      Exp         : longword;  //���� ����ġ
      MaxExp      : longword;  //���� �ִ� ����ġ

      Weight      : word;  //���� ����
      MaxWeight   : word;  //�� �� �ִ� �ִ� ����

      WearWeight    : byte;
      MaxWearWeight : byte;  //���� ������ ���� ������ �������� ���� (�ʰ��ϸ� ������ ������ 2-3�����)
      HandWeight    : byte;
      MaxHandWeight : byte;  //�� �� �ִ� ���� ���� (���Ը� �ʰ��ϸ� ������ ������ �����Ѵ� 2-3�����)

      //ei �߰�
{      FameLevel      : byte;  //����
      MiningLevel    : byte;  //���� ����
      FramingLevel   : byte;  //����
      FishingLevel   : byte;  //����

      FameExp        : integer;
      FameMaxExp     : integer;
      MiningExp      : integer;
      MiningMaxExp   : integer;
      FramingExp     : integer;
      FramingMaxExp  : integer;
      FishingExp     : integer;
      FishingMaxExp  : integer;                      }

      ATOM_DC        : array [0.._MAX_ATOM_] of word;
      ATOM_MC        : array [0.._MAX_ATOM_] of word;   // 0: Fire
                                                        // 1: Ice
                                                        // 2: Light
                                                        // 3: Wind
                                                        // 4: Holy
                                                        // 5: Dark
                                                        // 6: Phantom
      ATOM_MAC       : array [0.._MAX_ATOM_] of word;
   end;

   //ei
   TAddAbility = record       //������ �������� �þ�� �ɷ�ġ
      HP          : word;
      MP          : word;
      HIT         : word;
      SPEED       : word;
      AC          : word;
//      MAC         : word;
      DC          : word;
//      MC          : word;
//      SC          : word;
      AntiPoison  : word;    //%
      PoisonRecover : word;  //%
      HealthRecover : word;  //%
      SpellRecover : word;   //%
      AntiMagic   : word; //���� ȸ���� %
      Luck        : byte; //��� ����Ʈ
      UnLuck      : byte; //���� ����Ʈ
      WeaponStrong : byte;
      UndeadPower : byte;
      HitSpeed    : shortint;
      ATOM_DC        : array [0.._MAX_ATOM_] of word;
      ATOM_MC        : array [0.._MAX_ATOM_] of word;
      ATOM_MAC       : array [0.._MAX_ATOM_] of word;
   end;

{$else}

  //�̸�2
  TStdItem = record
    Name:    string[20];        // ������ �̸� (õ�����ϰ�)
    StdMode: byte;
    Shape:   byte;              // ���º� �̸� (ö��)
    Weight:  byte;              // ����
    AniCount: byte;
    // 1���� ũ�� �ִϸ��̼� �Ǵ� ������ (�ٸ� �뵵�� ���� ����)
    SpecialPwr: shortint;          // +�̸� ��������+�ɷ�, -�̸� �𵥵����+
    //1~10 ����
    //-50~-1 �𵥵� �ɷ�ġ ���
    //-100~-51 �𵥵� �ɷ�ġ ����
    ItemDesc: byte;
    //$01 IDC_UNIDENTIFIED  (���̴�Ƽ���� �� �� ��, Ŭ���̾�Ʈ������ ����)
    //$02 IDC_UNABLETAKEOFF (�տ��� �������� ����, ������ ��� ����)
    //$04 IDC_NEVERTAKEOFF  (�տ��� �������� ����, ������ ��� �Ұ���)
    //$08 IDC_DIEANDBREAK   (��������ۿ��� ������ ������ �Ӽ�)
    //$10 IDC_NEVERLOSE     (��������ۿ��� �׾ �������� ����)
    Looks:   word;              // �׸� ��ȣ
    DuraMax: word;
    AC:      word;              // ����
    MAC:     word;              // ���׷�
    DC:      word;              // ������
    MC:      word;              // ������ ���� �Ŀ�
    SC:      word;              // ������ ���ŷ�
    Need:    byte;              // 0:Level, 1:DC, 2:MC, 3:SC
    NeedLevel: byte;              // 1..60 level value...
    Price:   integer;           // ����
    Stock:   integer;           // ������
    AtkSpd:  byte;              // ���ݼӵ�
    Agility: byte;              // ��ø
    Accurate: byte;              // ��Ȯ
    MgAvoid: byte;              // ����ȸ�� -> ��������(sonmg)
    Strong:  byte;              // ����
    Undead:  byte;              // ����
    HpAdd:   integer;           // �߰�HP
    MpAdd:   integer;           // �߰�MP
    ExpAdd:  integer;           // �߰� ����ġ
    EffType1: byte;              // ȿ������1
    EffRate1: byte;              // ȿ��Ȯ��1
    EffValue1: byte;              // ȿ����1
    EffType2: byte;              // ȿ������2
    EffRate2: byte;              // ȿ��Ȯ��2
    EffValue2: byte;              // ȿ����2
    {--------------------}
    // added by sonmg
    Slowdown: byte;              // ��ȭ
    Tox:     byte;              // �ߵ�
    ToxAvoid: byte;              // �ߵ�����
    UniqueItem: byte;              // ����ũ�Ӽ�
    // ����ũ --- $01:����/���׷��̵� �ȵ�
    // ����ũ --- $02:�����Ұ�
    // ����ũ --- $04:����������(����â���� ������ ����)
    // ����ũ --- $08:��ȯ�Ұ�(12=4+8 : ��ȯ�Ұ�,�����Ұ�)
    OverlapItem: byte;              // �ߺ����
    light:   byte;              // �������� ������
    {--------------------}
    ItemType: byte;              // �������� ����
    ItemSet: word;              // ��Ʈ ������ ����
    Reference: string[14];        // ���� ���ڿ�
  end;

  PTStdItem = ^TStdItem;

  //�̸�2
  TUserItem = packed record
    MakeIndex: integer;
    //���������� ������ �ε���(����� ���� �ε��� �Ű���, �ߺ�����)
    Index:     word;          //ǥ�ؾ������� �ε���  0:����, 1���� ������..
    Dura:      word;
    DuraMax:   word;          //����� ������ �ִ밪
    Desc:      array[0..13] of byte;
    //0..7 ������ ���׷��̵� ����
    //10 0:���׷��̵�� ��� ����
    //   1:�ı��� ���׷��̵� ���̴�Ƽ���� �� �Ǿ���
    //   2:���� ���׷��̵� ���̴�Ƽ���� �� �Ǿ���
    //   3:���� ���׷��̵� ���̴�Ƽ���� �� �Ǿ���
    //   5:���ݼӵ� ���׷��̵� ���̴�Ƽ���� �� �Ǿ���
    //   9:����, ������
    ColorR:    byte;
    ColorG:    byte;
    ColorB:    byte;
    Prefix:    array [0..12] of AnsiChar;
  end;
  PTUserItem = ^TUserItem;

  //�̸�2
  TAbility = record
    Level:  byte;
    reserved1: byte;
    AC:     word;        //armor class
    MAC:    word;        //magic armor class
    DC:     word;        //damage class  -> makeword(min/max)
    MC:     word;        //magic power class   -> makeword(min/max)
    SC:     word;        //sprite energy class    -> makeword(min/max)
    HP:     word;        //health point
    MP:     word;        //magic point
    MaxHP:  word;        //max health point
    MaxMP:  word;        //max magic point
    ExpCount: byte;      //������
    ExpMaxCount: byte;   //������
    Exp:    longword;    //���� ����ġ
    MaxExp: longword;    //���� �ִ� ����ġ
    Weight: word;        //���� ����
    MaxWeight: word;     //�� �� �ִ� �ִ� ����
    WearWeight: byte;
    MaxWearWeight: byte;
    //���� ������ ���� ������ �������� ���� (�ʰ��ϸ� ������ ������ 2-3�����)
    HandWeight: byte;
    MaxHandWeight: byte;
    //�� �� �ִ� ���� ���� (���Ը� �ʰ��ϸ� ������ ������ �����Ѵ� 2-3�����)
  end;

  //�̸�2
  TAddAbility = record       //������ �������� �þ�� �ɷ�ġ
    HP:     word;
    MP:     word;
    HIT:    word;   // ��Ȯ
    SPEED:  word;   // ��ø
    AC:     word;
    MAC:    word;
    DC:     word;
    MC:     word;
    SC:     word;
    AntiPoison: word;    //%  // �ߵ�����
    PoisonRecover: word;  //%
    HealthRecover: word;  //%
    SpellRecover: word;   //%
    AntiMagic: word; //���� ȸ���� % // => ��������
    Luck:   byte; //��� ����Ʈ
    UnLuck: byte; //���� ����Ʈ
    WeaponStrong: byte;
    UndeadPower: byte;
    HitSpeed: shortint;
    // added by sonmg
    Slowdown: byte;
    Poison: byte;
  end;

{$endif}//�̸�2


  TPricesInfo = record            //���� ����
    Index:     word;       //ǥ�� �������� �ε���
    SellPrice: integer;    //�⺻ ����, BuyPrice�� SellPrice�� ����
  end;
  PTPricesInfo = ^TPricesInfo;

  TClientGoods = record
    Name:    string[20];
    SubMenu: byte;
    Price:   integer;
    Stock:   integer;  //�����������ΰ��, Item�� ServerIndex ��
    //Dura        : word;
    //DuraMax     : word;
    Grade:   shortint;     //����
  end;
  PTClientGoods = ^TClientGoods;

  TClientJangwon = record //��� ����Ʈ
    Num: integer;
    GuildName: string[20];
    CaptaineName1: string[14];
    CaptaineName2: string[14];
    SellPrice: integer;
    SellState: string[10];
  end;
  PTClientJangwon = ^TClientJangwon;

  TClientGABoard = record //��� �Խ��� ����Ʈ
    WrigteUser: string[14];
    TitleMsg:   string[40];
    IndexType1: integer;
    IndexType2: integer;
    IndexType3: integer;
    IndexType4: integer;
    ReplyCount: integer;
  end;
  PTClientGABoard = ^TClientGABoard;

  TClientGADecoration = record //��� �ٹ̱�
    Num:      integer;
    Name:     string[25];
    Price:    integer;
    ImgIndex: integer;
    CaseNum:  integer;
    //      Hint      : string[40];
  end;
  PTClientGADecoration = ^TClientGADecoration;


  TClientItem = record      //Ŭ���̾�Ʈ���� �ʿ��� ����
    S:    TStdItem;  //����� �ɷ�ġ�� ���⿡ �����.
    MakeIndex: integer;
    Dura: word;
    DuraMax: word;
    UpgradeOpt: integer;    //���׷��̵� �� ����
  end;
  PTClientItem = ^TClientItem;

  TUserStateInfo = record
    Feature:     integer;
    UserName:    string[20];   //CO19
    NameColor:   integer;
    GuildName:   string[20];//[14]; //����(2004/12/22)
    GuildRankName: string[14];
    UseItems:    array[0..12] of TClientItem;    // 8->12
    bExistLover: boolean;     //���� ����(2004/10/27)
    LoverName:   string[14];  //���� �̸�(2004/11/03)
  end;
  PTUserStateInfo = ^TUserStateInfo;

  TDropItem = record  //Ŭ���̾�Ʈ���� ���
    Id:     integer;
    X:      word;
    Y:      word;
    Looks:  word;
    FlashTime: longword; //���������� ��¦�Ÿ� �ð�
    BoFlash: boolean;
    FlashStepTime: longword;
    FlashStep: integer;
    Name:   string[25];
    BoDeco: boolean;
  end;
  PTDropItem = ^TDropItem;

  TDefMagic = record
    MagicId:  word;
    MagicName: string[14];       //ĭ �ø��� 12 -> 14
    EffectType: byte;
    Effect:   byte;
    Spell:    word;
    MinPower: word;
    NeedLevel: array[0..3] of byte;
    MaxTrain: array[0..3] of integer;
    MaxTrainLevel: byte;    //���� ����
    Job:      byte;         //0: ���� 1:����  2:����   99:��ΰ���
    DelayTime: integer;     //�ѹ� ������� ���� ������ �� �� �ִµ� �ɸ��� �ð�
    DefSpell: byte;
    DefMinPower: byte;
    MaxPower: word;
    DefMaxPower: byte;
    Desc:     string[15];
  end;
  PTDefMagic = ^TDefMagic;

  TUserMagic = record
    pDef:     PTDefMagic;  //�ݵ�� nil�� �ƴϾ�� �Ѵ�.
    MagicId:  word;
    //Magic Index ����. ����ũ�ؾ��ϸ�, �����Ǹ� �ȵ�, �׻� 0���� ũ��.
    Level:    byte;
    Key:      AnsiChar;     //����ڰ� ������ Ű
    CurTrain: integer;  //���� ����ġ
  end;
  PTUserMagic = ^TUserMagic;

  TClientMagic = record
    Key:      AnsiChar;
    Level:    byte;
    CurTrain: integer;
    Def:      TDefMagic;
  end;
  PTClientMagic = ^TClientMagic;

  // 2003/04/15 ģ��, ����
  TFriend = record
    CharID: string;
    Status: byte;
    Memo:   string;
  end;
  PTFriend = ^TFriend;

  TMail = record
    Sender: string;
    Date:   string;
    Mail:   string;
    Status: byte;
  end;
  PTMail = ^TMail;

  TRelationship = record
    CharID: string;
    Level:  byte;
    Sex:    byte;
    Status: byte;
    Date:   string;
  end;
  PTRelationship = ^TRelationship;

  TSkillInfo = record
    SkillIndex: word;
    Reserved:   word;
    CurTrain:   integer;
  end;
  PTSkillInfo = ^TSkillInfo;

  TMapItem = record
    UserItem:  TUserItem;
    Name:      string[25];
    Looks:     word;
    AniCount:  byte;
    Reserved:  byte;
    Count:     integer;
    Ownership: TObject;  //������ ���� �� �ִ� ���
    Droptime:  longword; //������ �기 �ð�
    Droper:    TObject;  //������ ����߸� �� (���? ����?)
  end;
  PTMapItem = ^TMapItem;

  //����ٹ̱� ������(sonmg)
  TAgitDecoItem = record
    Name:  string[25];
    Looks: word;
    MapName: string[14];
    x:     word;
    y:     word;
    Maker: string[14];
    Dura:  word;
  end;
  PTAgitDecoItem = ^TAgitDecoItem;

  {map�� ������}
  TVisibleItemInfo = record
    check: byte;
    x:     word;
    y:     word;
    Id:    longint;
    Name:  string[25];
    looks: word;
  end;
  PTVisibleItemInfo = ^TVisibleItemInfo;

  TVisibleActor = record
    check: byte;
    cret:  TObject;
  end;
  PTVisibleActor = ^TVisibleActor;

  {�� ���� �Ͼ�� �̺�Ʈ, activate���Ѿ߸� �̺�Ʈ�� �߻��Ѵ�.}
  TMapEventInfo = record
    check: byte;
    X:     integer;
    Y:     integer;
    EventObject: TObject;  {TMapEvent}
  end;
  PTMapEventInfo = ^TMapEventInfo;

  TGateInfo = record
    GateType:   byte;
    EnterEnvir: TObject;  //TEnvirnoment;
    EnterX:     integer;
    EnterY:     integer;
  end;
  PTGateInfo = ^TGateInfo;

  //�ʿ� ���õ� ���ڵ�
  TAThing = record
    Shape:   byte;
    AObject: TObject;
    ATime:   longword;
  end;
  PTAThing = ^TAThing;

  TMapInfo = record
    MoveAttr: byte;    //0: can move  1: can't move  2: can't move and cant't fly
    Door:     boolean; //��������, OBJList�߿� �� ����
    Area:     byte;    //���� ���� (����,������,���)
    Reserved: byte;    //�̻��
    OBJList:  TList;   // list of TAThing
  end;
  PTMapInfo = ^TMapInfo;


  TUserEntryInfo = record              // ����� �������, logon���� ����
    LoginId:  string[10];
    Password: string[10];
    UserName: string[20];     //*
    SSNo:     string[14];     //* 721109-1476110
    Phone:    string[14];     //����ȭ ��ȣ
    Quiz:     string[20];     //*
    Answer:   string[12];     //*
    EMail:    string[40];     //25];
  end;

  TUserEntryAddInfo = record
    //temp     : array[0..14] of byte;
    Quiz2:    string[20];     //*
    Answer2:  string[12];     //*
    Birthday: string[10];     //* 1972/11/09
    MobilePhone: string[13];   //017-6227-1234
    Memo1:    string[20];    //*
    Memo2:    string[20];    //*
  end;

  TUserCharacterInfo = record          // ���󼼰迡 ������ ���� ����ڿ��� ���޵Ǵ�
    EncName: string[20];               // �ɷ��� ����
    Sex:     byte;
    Hair:    byte;
    Job:     byte;                 //0:���� 1: ���� 2:����
    Level:   byte;
    Feature: integer;
    EncEncName: string[30];              // �ɷ��� ����
  end;
  PTUserCharacterInfo = ^TUserCharacterInfo;

  TLoadHuman = packed record
    UsrId:   array [0..20] of AnsiChar;
    ChrName: array [0..19] of AnsiChar; // 13 -> 19
    UsrAddr: array [0..14] of AnsiChar;
    CertifyCode: integer;
  end;
  PTLoadHuman = ^TLoadHuman;

  TMonsterInfo = record
    Name:    string[20]; //Monster Name Length
    Race:    byte;   //������ AI ���α׷�
    RaceImg: byte;   //Ŭ���̾�Ʈ ������ �ĺ�
    Appr:    word;   //�̹��� ��ȣ
    Level:   byte;
    LifeAttrib: byte;
    CoolEye: byte;  //���� ����, 100% �̸� ������ ��, 50%�̸� ������ �� Ȯ���� 50%
    Exp:     word;
    HP:      word;
    MP:      word;
    AC:      byte;
    MAC:     byte;
    DC:      byte;
    MaxDC:   byte;
    MC:      byte;
    SC:      byte;
    Speed:   byte;
    Hit:     byte;
    WalkSpeed: word;
    WalkStep: word;
    WalkWait: word;
    AttackSpeed: word;
    //////////////////////////
    // newly added by sonmg.
    Tame:    word;
    AntiPush: word;
    AntiUndead: word;
    SizeRate: word;
    AntiStop: word;
    //////////////////////////
    ItemList: TList;
  end;
  PTMonsterInfo = ^TMonsterInfo;

  TZenInfo = record
    MapName: string[14];
    X:     integer;
    Y:     integer;
    MonName: string[20];  //Monster Name Length
    MonRace: integer;
    Area:  integer;  //���� +area, -area rectangle
    Count: integer;
    MonZenTime: longword; //�и������� ����
    StartTime: longword;
    Mons:  TList;
    SmallZenRate: integer;
    // 2003/06/20 �̺�Ʈ�� �� ó��
    TX:    integer;
    TY:    integer;
    ZenShoutType: integer;
    ZenShoutMsg: integer;
  end;
  PTZenInfo = ^TZenInfo;

  TMonItemInfo = record
    SelPoint: integer;
    MaxPoint: integer;
    ItemName: string[20];
    Count:    integer;  //����,
  end;
  PTMonItemInfo = ^TMonItemInfo;

  TMarketProduct = record
    GoodsName: string[20];
    Count:     integer;
    ZenHour:   integer;  //hour
    ZenTime:   longword; //�ֱٿ� ����Ų �ð�
  end;
  PTMarketProduct = ^TMarketProduct;

  //QuestDiary��
  TQDDinfo = record
    Index: integer;
    Title: string;
    SList: TStringList;
  end;
  PTQDDinfo = ^TQDDinfo;

  // ��Ź�Ǹſ� ������ --------------------------------------------------------
  TMarketItem = record
    Item:      TClientItem;  // ����� �ɷ�ġ�� ���⿡ �����.
    UpgCount:  integer;      // �߰��� ���׷��̵� �� ����
    Index:     integer;      // �ǸŹ�ȣ
    SellPrice: integer;      // �Ǹ� ����
    SellWho:   string[20];   // �Ǹ���
    Selldate:  string[10];   // �Ǹų�¥(0312311210 = 2003-12-31 12:10 )
    SellState: word          // 1 = �Ǹ��� , 2 = �ǸſϷ�
  end;
  PTMarketItem = ^TMarketItem;

  // ��Ź�Ǹ� �б�� ----------------------------------------------------------
  TMarketLoad = record
    UserItem: TUserItem;      // DB �����
    Index: integer;           // DB �ε���
    MarketType: integer;      // �и��� ������ ����
    SetType: integer;         // ��Ʈ ������ ����
    SellCount: integer;
    SellPrice: integer;      // �Ǹ� ����
    ItemName: string[30];   // �������̸�
    MarketName: string[30];   // �Ǹ��ڸ�
    SellWho: string[20];  // �Ǹ���
    Selldate: string[10];   // �Ǹų�¥(0312311210 = 2003-12-31 12:10 )
    SellState: word;         // 1 = �Ǹ��� , 2 = �ǸſϷ�
    IsOK: integer;      // �����
  end;
  PTMarketLoad = ^TMarketLoad;

  //������ �˻��� ------------------------------------------------------------
  TSearchSellItem = record
    MarketName: string[25];   // �����̸�_NPC  �̸��� ����
    Who:      string[25];     // ������ �Ǹ��� �˻��� ��� ,
    ItemName: string[25];     // ������ �̸� �˻��� ���
    MakeIndex: integer;       // �������� ����ũ ��ȣ  
    ItemType: integer;        // ������ ���� �˻��� ���
    ItemSet:  integer;        // ������ ��Ʈ ��ȸ�� ���
    SellIndex: integer;       // �Ǹ� �ε��� ������ �춧 , ��� , �ݾ�ȸ��� ���
    CheckType: integer;       // DB �� üũŸ��
    IsOK:     integer;        // �����
    UserMode: integer;        // 1= ������ ���  , 2= �ڽ��� ������ �˻�
    pList:    TList;          // ��Ź�������� ����Ʈ
  end;
  PTSearchSellItem = ^TSearchSellItem;

  //��Ź�˻��....------------------------------------------------------------
  TMarKetReqInfo = record
    UserName:   string[30];
    MarketName: string[30];
    SearchWho:  string[30];
    SearchItem: string[30];
    ItemType:   integer;
    ItemSet:    integer;
    UserMode:   integer;
  end;

  //����Խ��� ����Ʈ �˻���....------------------------------------------------------------
  TSearchGaBoardList = record
    AgitNum:   integer;      // �̻��
    GuildName: string[30];
    OrgNum:    integer;      // �̻��
    SrcNum1:   integer;      // �̻��
    SrcNum2:   integer;      // �̻��
    SrcNum3:   integer;      // �̻��
    Kind:      integer;
    UserName:  string[20];     // �̻��
    ArticleList: TList;        // �Խ��� ����Ʈ
  end;
  PTSearchGaBoardList = ^TSearchGaBoardList;

{
    //����Խ��� ���� ����Ʈ��....------------------------------------------------------------
    TGaBoardListLoad  = Record
        AgitNum     :   integer;
        GuildName   :   string[30];
        OrgNum      :   integer;
        SrcNum      :   integer;
        Kind        :   integer;
        UserName    :   string[20];
        Subject     :   array [0..40] of AnsiChar;
    end;
    PTGaBoardListLoad = ^TGaBoardListLoad;
}

  //����Խ��� �۳���....------------------------------------------------------------
  TGaBoardArticleLoad = record
    AgitNum:   integer;
    GuildName: string[30];
    OrgNum:    integer;
    SrcNum1:   integer;
    SrcNum2:   integer;
    SrcNum3:   integer;
    Kind:      integer;
    UserName:  string[20];
    Content:   array [0..500] of AnsiChar;
  end;
  PTGaBoardArticleLoad = ^TGaBoardArticleLoad;

  TMapPoint = record
    MapName: string;
    Scope: Integer;
    PointX: Integer;
    PointY: Integer;
  end;
  PTMapPoint=^TMapPoint;

  TMapFlag = record
    LawFull: Boolean;
    FightZone: Boolean;
    Fight2Zone: Boolean;
    Fight3Zone: Boolean;
    Fight4Zone: Boolean;
    Darkness: Boolean;
    Dawn: Boolean;
    DayLight: Boolean;
    QuizZone: Boolean;
    NoReconnect: Boolean;
    NeedLevel: Integer;
    NeedHole: Boolean;
    NoRecall: Boolean;
    NoRandomMove: Boolean;
    NoEscapeMove: Boolean;
    NoTeleportMove: Boolean;
    NoDrug: Boolean;
    MineMap: Integer;
    NoPositionMove: Boolean;
    BackMap: string;
    MapQuest: Boolean;
    NeedSetNumber: Integer;
    NeedSetValue: Integer;
    AutoAttack: Integer;
    GuildAgit: Integer;
    NoChat: Boolean;
    NoGroup: Boolean;
    NoThrowItem: Boolean;
    NoDropItem: Boolean;
  end;
  PTMapFlag=^TMapFlag;

const
  DEFBLOCKSIZE = 16;

{$ifdef MIR2EI}

   MAXBAGITEM = 46;
   MAXHORSEBAG = 30;
   MAXUSERMAGIC = 20;
   MAXSAVEITEM = 100;

   MAXQUESTINDEXBYTE = 24; //ei��
   MAXQUESTBYTE = 176; //ei��

{$else}//���� �̸�2

  MAXBAGITEM   = 46;
  MAXHORSEBAG  = 30;
  MAXUSERMAGIC = 20;
  MAXSAVEITEM  = 100;

  MAXQUESTINDEXBYTE = 24;            // To PDS:13;  //100;
  MAXQUESTBYTE      = 176;           // TO PDS:100; //13;

{$endif}

  //Ŭ���̾�Ʈ���� ����
  LOGICALMAPUNIT = 40;
  UNITX = 48;
  UNITY = 32;
  HALFX = 24;
  HALFY = 16;

  OS_MOVINGOBJECT = 1;
  OS_ITEMOBJECT = 2;
  OS_EVENTOBJECT = 3;
  OS_GATEOBJECT = 4;
  OS_SWITCHOBJECT = 5;
  OS_MAPEVENT = 6;
  OS_DOOR = 7;
  OS_ROON = 8;

  // StatusArr Size ����(sonmg 2004/03/19)
  STATUSARR_SIZE  = 16;
  EXTRAABIL_SIZE  = 7;
  // 2003/07/15 �����̻� �߰�
  POISON_DECHEALTH = 0;   //$80000000
  POISON_DAMAGEARMOR = 1;   //$40000000
  POISON_ICE      = 2;   //$20000000
  POISON_STUN     = 3;   //$10000000
  POISON_SLOW     = 4;   //$08000000
  POISON_STONE    = 5;   //$04000000
  POISON_DONTMOVE = 6;   //$02000000

  STATE_BLUECHAR     = 2;
  STATE_FASTMOVE     = 7;     //$01000000
  STATE_TRANSPARENT  = 8;     //$00800000
  STATE_DEFENCEUP    = 9;     //$00400000
  STATE_MAGDEFENCEUP = 10;    //$00200000
  STATE_BUBBLEDEFENCEUP = 11; //$00100000
  STATE_HITSPEEDUP    = 13;

  // 2004/03/19 ĳ���� ȿ�� �߰�(sonmg)
  STATE_50LEVELEFFECT = 12;  //$00080000


  EABIL_DCUP    = 0;   //���������� �ı����� �ø� (���� �ð�)
  EABIL_MCUP    = 1;
  EABIL_SCUP    = 2;
  EABIL_HITSPEEDUP = 3;
  EABIL_HPUP    = 4;
  EABIL_MPUP    = 5;
  EABIL_PWRRATE = 6;   // ���ݷ� ����Ʈ ���� 

  //ItemDesc �� �Ӽ�
  IDC_UNIDENTIFIED  = $01;   //�ɷ� Ȯ�� �ȵ�
  IDC_UNABLETAKEOFF = $02;   //�տ��� �������� ����, ������ ������� ������
  IDC_NEVERTAKEOFF  = $04;   //�տ��� ����� �������� ����
  IDC_DIEANDBREAK   = $08;   //������ ����
  IDC_NEVERLOSE     = $10;   //�׾ �Ҿ������ ����


  STATE_STONE_MODE = $00000001;  //��������� ���(�������� ����)
  STATE_OPENHEATH  = $00000002;  //ü�� ��������


  HAM_ALL      = 0;  //��� ����
  HAM_PEACE    = 1;  //��ȭ���, ���͸� ����
  HAM_GROUP    = 2;  //�׷�� �̿� �ƹ��� ����
  HAM_GUILD    = 3;  //���� �̿� �ƹ��� ����
  HAM_PKATTACK = 4;  //������ �� �����

  HAM_MAXCOUNT = 5;


  AREA_FIGHT  = $01;
  AREA_SAFE   = $02;
  AREA_FREEPK = $04;


  HM_HIT      = 0;
  HM_HEAVYHIT = 1;
  HM_BIGHIT   = 2;
  HM_POWERHIT = 3;
  HM_LONGHIT  = 4;
  HM_WIDEHIT  = 5;
  // 2003/03/15 �űԹ���
  HM_CROSSHIT = 6;  //4 �� ���� -> 8�� ����
  HM_FIREHIT  = 7;
  HM_TWINHIT  = 8;  //2�� ����
  HM_STONEHIT = 9;  //4 �� ���� -> 8�� ����
  //Assassin Magics
  HM_slashhit = 10;    //Slash
  HM_WIDEHIT2 = 11;    //Assassin Skill 2

  {----------------------------}

  //SM_??    ���� -> Ŭ���̾�Ʈ��
  //  1 ~ 2000
  SM_TEST = 1;
  //�帧���� ����
  SM_STOPACTIONS = 2;  //��� ĳ����/������ ������ �����.
  //�ٸ� �ʿ� �� ���,

  //�ൿ�� ���� ����
  SM_ACTION_MIN = 5;
  SM_THROW    = 5;
  SM_RUSH     = 6;  //������ ����
  SM_RUSHKUNG = 7;  //������ ��������
  SM_FIREHIT  = 8;  //��ȭ��
  SM_BACKSTEP = 9;  //�ް�����,
  SM_TURN     = 10;
  SM_WALK     = 11;
  SM_SITDOWN  = 12;
  SM_RUN      = 13;
  SM_HIT      = 14;
  SM_HEAVYHIT = 15;
  SM_BIGHIT   = 16;
  SM_SPELL    = 17;
  SM_POWERHIT = 18;
  SM_LONGHIT  = 19;  //�� ���� ����
  SM_DIGUP    = 20;  //���İ� ������.
  SM_DIGDOWN  = 21;  //���İ� �� ����.
  SM_FLYAXE   = 22;
  SM_LIGHTING = 23;  //���� ���
  SM_WIDEHIT  = 24;
  SM_ACTION_MAX = 25;
  SM_FLYAXE_2   = 26;

  //Assassin Magics
  SM_slashhit = 47;   //Slash
  SM_WIDEHIT2 = 48;   //Skill 2

  // 2003/03/15 �űԹ���
  SM_CROSSHIT   = 35;  //��ǳ��, �ֺ�8Ÿ�� ����
  SM_TWINHIT    = 36;  //�ַ���, ������ 2�� ����
  SM_STONEHIT   = 37;  //������, �ֺ�8Ÿ�� ���θ���
  SM_WINDCUT    = 38;  //���ļ�,  ��Ÿ�� 9�� ����
  SM_DRAGONFIRE = 39; // õ��⿰(ȭ��⿰)  �ڽ��ֺ� Ÿ�� 25�� ����
  SM_CURSE      = 40; // ���ּ�
  // 2004/06/22 �űԹ���(���°�, ������, �;ȼ�)
  SM_PULLMON    = 41;  //���°�, ������
  SM_SUCKBLOOD  = 42;  //������, �Ǹ� ���Ƶ���
  SM_BLINDMON   = 43;  //�;ȼ�, ���� �þ߸� ����

  // FireDragon ------------------------ by Leekg...2003/11/27
  MAGIC_DUN_THUNDER = 70; //����� ����  // FireDragon
  MAGIC_DUN_FIRE1   = 71; //����� ��� ���
  MAGIC_DUN_FIRE2   = 72; //����� ��� ����Ʈ
  MAGIC_DRAGONFIRE  = 73; //��Ұ��� ����
  MAGIC_FIREBURN    = 74; //�뼮����� ���� Ÿ����

  MAGIC_SERPENT_1 = 75; //�̹��� ��õȭ

  SM_DRAGON_LIGHTING = 80;
  SM_DRAGON_FIRE1    = 81;
  SM_DRAGON_FIRE2    = 82;
  SM_DRAGON_FIRE3    = 83;

  SM_DRAGON_STRUCK   = 85;
  SM_DRAGON_DROPITEM = 86;
  SM_LIGHTING_1      = 87; //����_1:�̹��� ��õȭ
  SM_LIGHTING_2      = 88;
  MAGIC_FOX_THUNDER  = 89;
  MAGIC_FOX_BANG     = 90;
  MAGIC_ROCK_PULL  = 91;  

  SM_ACTION2_MIN = 1000;
  //SM_READYFIREHIT         = 1000;  //Ŭ���̾�Ʈ������ ����, ��ȭ�� �غ�

  SM_ACTION2_MAX = 1099;

  SM_DIE      = 26; //��� ��
  SM_ALIVE    = 27;
  SM_MOVEFAIL = 28;
  SM_HIDE     = 29;
  SM_DISAPPEAR = 30;
  SM_STRUCK   = 31;
  SM_DEATH    = 32;
  SM_SKELETON = 33;
  SM_NOWDEATH = 34;

  SM_HEAR     = 40;
  SM_FEATURECHANGED = 41;
  SM_USERNAME = 42;
  SM_WINEXP   = 44;
  SM_LEVELUP  = 45;
  SM_DAYCHANGING = 46;

  SM_LOGON   = 50;
  SM_NEWMAP  = 51;
  SM_ABILITY = 52;
  SM_HEALTHSPELLCHANGED = 53;
  SM_MAPDESCRIPTION = 54;

  SM_SYSMESSAGE = 100;
  SM_GROUPMESSAGE = 101;
  SM_CRY     = 102;
  SM_WHISPER = 103;
  SM_GUILDMESSAGE = 104;
  SM_SYSMSG_REMARK = 105;

  //ITEM ?
  SM_ADDITEM     = 200;  //�������� ���� ����  Series(����)
  SM_BAGITEMS    = 201;  //������ ��� ������
  SM_DELITEM     = 202;  //��Ƽ� �������� ���� ������ ������
  SM_UPDATEITEM  = 203;  //�������� ����� ����
  //Magic
  SM_ADDMAGIC    = 210;
  SM_SENDMYMAGIC = 211;
  SM_DELMAGIC    = 212;

  SM_VERSION_AVAILABLE = 500;
  SM_VERSION_FAIL  = 501;
  SM_PASSWD_SUCCESS = 502;
  SM_PASSWD_FAIL   = 503;
  SM_NEWID_SUCCESS = 504;  //�����̵� �� ����� ����
  SM_NEWID_FAIL    = 505;  //�����̵� ����� ����
  SM_CHGPASSWD_SUCCESS = 506;
  SM_CHGPASSWD_FAIL = 507;
  SM_QUERYCHR      = 520;  //ĳ������Ʈ
  SM_NEWCHR_SUCCESS = 521;
  SM_NEWCHR_FAIL   = 522;
  SM_DELCHR_SUCCESS = 523;
  SM_DELCHR_FAIL   = 524;
  SM_STARTPLAY     = 525;
  SM_STARTFAIL     = 526;
  SM_QUERYCHR_FAIL = 527;
  SM_OUTOFCONNECTION = 528;  //���� ������
  SM_PASSOK_SELECTSERVER = 529;
  SM_SELECTSERVER_OK = 530;
  SM_NEEDUPDATE_ACCOUNT = 531;  //������ ������ �ٽ� �Է��ϱ� �ٶ� â..
  SM_UPDATEID_SUCCESS = 532;
  SM_UPDATEID_FAIL = 533;
  SM_PASSOK_WRONGSSN = 534;
  SM_NOT_IN_SERVICE = 535;


  SM_DROPITEM_SUCCESS = 600;  //������ ������ ����
  SM_DROPITEM_FAIL = 601;
  SM_ITEMSHOW   = 610;
  SM_ITEMHIDE   = 611;
  SM_OPENDOOR_OK = 612;
  SM_OPENDOOR_LOCK = 613;
  SM_CLOSEDOOR  = 614;
  SM_TAKEON_OK  = 615;       //���� ����, + New Feature
  SM_TAKEON_FAIL = 616;      //���� ����
  SM_EXCHGTAKEON_OK = 617;   //��������� ��ȯ ����
  SM_EXCHGTAKEON_FAIL = 618; //��������� ��ȯ ����
  SM_TAKEOFF_OK = 619;       //���� ����, + New Feature
  SM_TAKEOFF_FAIL = 620;
  SM_SENDUSEITEMS = 621; //���� ������ ��� ����
  SM_WEIGHTCHANGED = 622;
  SM_CLEAROBJECTS = 633;
  SM_CHANGEMAP  = 634;
  SM_EAT_OK     = 635;
  SM_EAT_FAIL   = 636;
  SM_BUTCH      = 637;
  SM_MAGICFIRE  = 638; //���� �߻��  CM_SPELL -> SM_SPELL + SM_MAGICFIRE
  SM_MAGICFIRE_FAIL = 639;
  SM_MAGIC_LVEXP = 640;
  SM_SOUND      = 641;
  SM_DURACHANGE = 642;
  SM_MERCHANTSAY = 643;
  SM_MERCHANTDLGCLOSE = 644;
  SM_SENDGOODSLIST = 645;
  SM_SENDUSERSELL = 646;
  SM_SENDBUYPRICE = 647;
  SM_USERSELLITEM_OK = 648;
  SM_USERSELLITEM_FAIL = 649;
  SM_BUYITEM_SUCCESS = 650;
  SM_BUYITEM_FAIL = 651;
  SM_SENDDETAILGOODSLIST = 652;
  SM_GOLDCHANGED = 653;
  SM_CHANGELIGHT = 654;
  SM_LAMPCHANGEDURA = 655;
  SM_CHANGENAMECOLOR = 656;
  SM_CHARSTATUSCHANGED = 657;
  SM_SENDNOTICE = 658;
  SM_GROUPMODECHANGED = 659;
  SM_CREATEGROUP_OK = 660;
  SM_CREATEGROUP_FAIL = 661;
  SM_GROUPADDMEM_OK = 662;
  SM_GROUPDELMEM_OK = 663;
  SM_GROUPADDMEM_FAIL = 664;
  SM_GROUPDELMEM_FAIL = 665;
  SM_GROUPCANCEL = 666;
  SM_GROUPMEMBERS = 667;
  SM_SENDUSERREPAIR = 668;
  SM_USERREPAIRITEM_OK = 669;
  SM_USERREPAIRITEM_FAIL = 670;
  SM_SENDREPAIRCOST = 671;
  SM_DEALMENU   = 673;
  SM_DEALTRY_FAIL = 674;
  SM_DEALADDITEM_OK = 675;
  SM_DEALADDITEM_FAIL = 676;
  SM_DEALDELITEM_OK = 677;
  SM_DEALDELITEM_FAIL = 678;
  //SM_DEALREMOTEADDITEM_OK = 679;
  //SM_DEALREMOTEDELITEM_OK = 680;
  SM_DEALCANCEL = 681; //���߿� �ŷ� ��ҵ�
  SM_DEALREMOTEADDITEM = 682; //������ ��ȯ �������� �߰�
  SM_DEALREMOTEDELITEM = 683; //������ ��ȯ �������� ��
  SM_DEALCHGGOLD_OK = 684;
  SM_DEALCHGGOLD_FAIL = 685;
  SM_DEALREMOTECHGGOLD = 686;
  SM_DEALSUCCESS = 687;
  SM_SENDUSERSTORAGEITEM = 700;
  SM_STORAGE_OK = 701;
  SM_STORAGE_FULL = 702; //�� ���� �� ��.
  SM_STORAGE_FAIL = 703; //���� ����
  SM_SAVEITEMLIST = 704;
  SM_TAKEBACKSTORAGEITEM_OK = 705;
  SM_TAKEBACKSTORAGEITEM_FAIL = 706;
  SM_TAKEBACKSTORAGEITEM_FULLBAG = 707;
  SM_AREASTATE  = 708; //����,���,�Ϲ�..
  SM_DELITEMS   = 709;
  SM_READMINIMAP_OK = 710;
  SM_READMINIMAP_FAIL = 711;
  SM_SENDUSERMAKEDRUGITEMLIST = 712;
  SM_MAKEDRUG_SUCCESS = 713;
  SM_MAKEDRUG_FAIL = 714;
  SM_ALLOWPOWERHIT = 715;
  SM_NORMALEFFECT = 716;  //�⺻ ȿ��
  // ������ ����
  SM_SENDUSERMAKEITEMLIST = 717;
  SM_ALLOWslashhit = 718;

  SM_CHANGEGUILDNAME = 750;  //����� �̸� Ȥ�� ��峻�� ��å�̸��� ����
  SM_SENDUSERSTATE = 751;
  SM_SUBABILITY = 752;
  SM_OPENGUILDDLG = 753;
  SM_OPENGUILDDLG_FAIL = 754;
  SM_SENDGUILDHOME = 755;
  SM_SENDGUILDMEMBERLIST = 756;
  SM_GUILDADDMEMBER_OK = 757;
  SM_GUILDADDMEMBER_FAIL = 758;
  SM_GUILDDELMEMBER_OK = 759;
  SM_GUILDDELMEMBER_FAIL = 760;
  SM_GUILDRANKUPDATE_FAIL = 761;
  SM_BUILDGUILD_OK = 762;
  SM_BUILDGUILD_FAIL = 763;
  SM_DONATE_FAIL = 764;
  SM_DONATE_OK = 765;
  SM_MYSTATUS  = 766;
  SM_MENU_OK   = 767;  //description���� �޼��� ����
  SM_GUILDMAKEALLY_OK = 768;
  SM_GUILDMAKEALLY_FAIL = 769;
  SM_GUILDBREAKALLY_OK = 770;
  SM_GUILDBREAKALLY_FAIL = 771;
  SM_DLGMSG    = 772;

  SM_SPACEMOVE_HIDE = 800;  //�����̵� �����
  SM_SPACEMOVE_SHOW = 801;  //��Ÿ��
  SM_RECONNECT = 802;
  SM_GHOST     = 803;  //ȭ�鿡 ��Ÿ�� �ܻ���
  SM_SHOWEVENT = 804;
  SM_HIDEEVENT = 805;
  SM_SPACEMOVE_HIDE2 = 806;    //�����̵� �����
  SM_SPACEMOVE_SHOW2 = 807;    //��Ÿ��
  SM_SPACEMOVE_SHOW_NO = 808;  //��Ÿ��(����Ʈ ����)

  SM_TIMECHECK_MSG = 810;  //Ŭ���̾�Ʈ���� �ð�
  SM_ADJUST_BONUS = 811;  //���ʽ� ����Ʈ�� �����϶�.
  // Frined System -------------
  SM_FRIEND_DELETE = 812;   //ģ�� ����
  SM_FRIEND_INFO = 813;   //ģ�� �߰� �� ��������
  SM_FRIEND_RESULT = 814;   //ģ������ ����� ����
  // Tag System ----------------
  SM_TAG_ALARM   = 815;   //�������� �˸�
  SM_TAG_LIST    = 816;   //��������Ʈ
  SM_TAG_INFO    = 817;   //�������� ����
  SM_TAG_REJECT_LIST = 818;   //�ź��� ����Ʈ
  SM_TAG_REJECT_ADD = 819;   //�ź��� �߰�
  SM_TAG_REJECT_DELETE = 820;   //�ź��� ����
  SM_TAG_RESULT  = 821;   //�������� ����� ����
  // User System ---------------
  SM_USER_INFO   = 822;   //������ ���ӻ��¹� ����������
  // RelationShip --------------
  SM_LM_LIST     = 823;   //���� ����Ʈ
  SM_LM_OPTION   = 824;   //���� �ɼ�
  SM_LM_REQUEST  = 825;   //���� ���� �䱸
  SM_LM_DELETE   = 826;   //���� ����
  SM_LM_RESULT   = 827;   //���� ����� ����
  // ��Ź�Ǹ� ---------------------
  SM_MARKET_LIST = 828;   // ��Ź����Ʈ����
  SM_MARKET_RESULT = 829;   // ��Ź���  ����

  // ������� ---------------------
  SM_GUILDAGITLIST     = 830;   //��� �Ǹ� ���
  SM_GUILDAGITDEALMENU = 831;   //����ŷ�

  // ����Խ���
  SM_GABOARD_LIST      = 832;  // ����Խ��� ����Ʈ
  SM_GABOARD_READ      = 833;  // ����Խ��� ���б�
  SM_GABOARD_NOTICE_OK = 834;  // ����Խ��� �������� ���� OK
  SM_GABOARD_NOTICE_FAIL = 835;  // ����Խ��� �������� ���� FAIL

  // ����ٹ̱�
  SM_DECOITEM_LIST     = 836;  // ����ٹ̱� ������ ����Ʈ
  SM_DECOITEM_LISTSHOW = 837;  // ����ٹ̱� ������ ����Ʈ

  // �׷� �Ἲ Ȯ��
  SM_CREATEGROUPREQ    = 838;   //�׷� �Ἲ Ȯ��
  SM_ADDGROUPMEMBERREQ = 839;   //�׷� �Ἲ Ȯ��
  // RelationShip (cont.)--------------
  SM_LM_DELETE_REQ     = 840;   //���� ���� Ȯ��

  //1000 ~ 1099  �׼����� ����

  SM_OPENHEALTH  = 1100;  //ü���� ���濡 ����
  SM_CLOSEHEALTH = 1101;  //ü���� ���濡�� ������ ����
  SM_BREAKWEAPON = 1102;
  SM_INSTANCEHEALGUAGE = 1103;
  SM_CHANGEFACE  = 1104;  //����...
  SM_NEXTTIME_PASSWORD = 1105;  //���������� ��й�ȣ �Է� ����̴�.
  SM_CHECK_CLIENTVALID = 1106;  //Ŭ���̾�Ʈ�� ���� ���� Ȯ��

  SM_LOOPNORMALEFFECT = 1107;  //���� ����Ʈ ȿ��
  SM_LOOPSCREENEFFECT = 1108;  //ȭ�� ����Ʈ

  SM_PLAYDICE = 1200;
  SM_PLAYROCK = 1201;
  // 2003/02/11 �׷�� ��ġ ����
  SM_GROUPPOS = 1312;

  // UpgradeItem_Result ---------------- by sonmg...2003/10/02
  SM_UPGRADEITEM_RESULT     = 1300;
  // ��ġ��
  SM_COUNTERITEMCHANGE      = 1301;
  SM_USERSELLCOUNTITEM_OK   = 1302;
  SM_USERSELLCOUNTITEM_FAIL = 1303;

  SM_CANCLOSE_OK   = 1304;
  SM_CANCLOSE_FAIL = 1305;


  //CM_??   Ŭ���̾�Ʈ -> ������
  //  2000 ~ 4000
  CM_PROTOCOL   = 2000;
  CM_IDPASSWORD = 2001;
  CM_ADDNEWUSER = 2002;
  CM_CHANGEPASSWORD = 2003;
  CM_UPDATEUSER = 2004;

  {----------------------------}

  CM_QUERYCHR = 100;
  CM_NEWCHR   = 101;
  CM_DELCHR   = 102;
  CM_SELCHR   = 103;
  CM_SELECTSERVER = 104;  //������ ���� (+ �����̸�)

  //3000 - 3099 Ŭ���̾�Ʈ �̵� �޼����� ����
  //�������� �̵� �޼����� 0..99 ���� �̾�� �Ѵ�.
  CM_THROW    = 3005;
  CM_TURN     = 3010;    //CM_TURN - 3000 = SM_TURN ��Ģ�� �ݵ�� ���Ѿ� ��
  CM_WALK     = 3011;
  CM_SITDOWN  = 3012;
  CM_RUN      = 3013;
  CM_HIT      = 3014;
  CM_HEAVYHIT = 3015;
  CM_BIGHIT   = 3016;
  CM_SPELL    = 3017;
  CM_POWERHIT = 3018;  //�� ���� ����
  CM_LONGHIT  = 3019;  //�� ���� ����
  CM_WIDEHIT  = 3024;
  CM_FIREHIT  = 3025;
  CM_SAY      = 3030;
  // 2003/03/15 �űԹ���
  CM_CROSSHIT = 3035;
  CM_TWINHIT  = 3036;
  //Assassin Magics
  CM_slashhit = 3047;  //Slash
  CM_WIDEHIT2 = 3048;  //Skill 2

  CM_QUERYUSERNAME  = 80;  //QUERY �ø��� ���ɾ�
  CM_QUERYBAGITEMS  = 81;
  CM_QUERYUSERSTATE = 82;  //Ÿ���� ���� ����

  CM_DROPITEM = 1000;
  CM_PICKUP   = 1001;
  CM_OPENDOOR = 1002;
  CM_TAKEONITEM = 1003;  //������ ����
  CM_TAKEOFFITEM = 1004;  //������ ���´�
  CM_EXCHGTAKEONITEM = 1005;  //������ �������� �¿츦 �ٲ۴�.(����,����)
  CM_EAT      = 1006;  //�Դ�, ���ô�
  CM_BUTCH    = 1007;  //�����ϴ�
  CM_MAGICKEYCHANGE = 1008;
  CM_SOFTCLOSE = 1009;
  CM_CLICKNPC = 1010;
  CM_MERCHANTDLGSELECT = 1011;
  CM_MERCHANTQUERYSELLPRICE = 1012;
  CM_USERSELLITEM = 1013;  //������ �ȱ�
  CM_USERBUYITEM = 1014;
  CM_USERGETDETAILITEM = 1015;
  CM_DROPGOLD = 1016;
  CM_TEST     = 1017;  //�׽�Ʈ
  CM_LOGINNOTICEOK = 1018;
  CM_GROUPMODE = 1019;
  CM_CREATEGROUP = 1020;
  CM_ADDGROUPMEMBER = 1021;
  CM_DELGROUPMEMBER = 1022;
  CM_USERREPAIRITEM = 1023;
  CM_MERCHANTQUERYREPAIRCOST = 1024;
  CM_DEALTRY  = 1025;
  CM_DEALADDITEM = 1026;
  CM_DEALDELITEM = 1027;
  CM_DEALCANCEL = 1028;
  CM_DEALCHGGOLD = 1029; //��ȯ�ϴ� ���� �����
  CM_DEALEND  = 1030;
  CM_USERSTORAGEITEM = 1031;
  CM_USERTAKEBACKSTORAGEITEM = 1032;
  CM_WANTMINIMAP = 1033;
  CM_USERMAKEDRUGITEM = 1034;
  CM_OPENGUILDDLG = 1035;
  CM_GUILDHOME = 1036;
  CM_GUILDMEMBERLIST = 1037;
  CM_GUILDADDMEMBER = 1038;
  CM_GUILDDELMEMBER = 1039;
  CM_GUILDUPDATENOTICE = 1040;
  CM_GUILDUPDATERANKINFO = 1041;
  CM_SPEEDHACKUSER = 1042;
  CM_ADJUST_BONUS = 1043;
  CM_GUILDMAKEALLY = 1044;
  CM_GUILDBREAKALLY = 1045;
  // Frined System---------------
  CM_FRIEND_ADD = 1046;  // ģ���߰�
  CM_FRIEND_DELETE = 1047;  // ģ������
  CM_FRIEND_EDIT = 1048;  // ģ������ ����
  CM_FRIEND_LIST = 1049;  // ģ�� ����Ʈ ��û
  // Tag System -----------------
  CM_TAG_ADD  = 1050;  // ���� �߰�
  CM_TAG_DELETE = 1051;  // ���� ����
  CM_TAG_SETINFO = 1052;  // ���� ���� ����
  CM_TAG_LIST = 1053;  // ���� ����Ʈ ��û
  CM_TAG_NOTREADCOUNT = 1054;  // �������� ���� ���� ��û
  CM_TAG_REJECT_LIST = 1055;  // �ź��� ����Ʈ
  CM_TAG_REJECT_ADD = 1056;  // �ź��� �߰�
  CM_TAG_REJECT_DELETE = 1057;  // �ź��� ����
  // Relationship ---------------
  CM_LM_OPTION = 1058;  // ���� Ȱ�� / ��Ȱ��
  CM_LM_REQUEST = 1059;  // ���� ��� ��û
  CM_LM_Add   = 1060;  // ���� �߰� ( ���������� ���� )
  CM_LM_EDIT  = 1061;  // ���� ����
  CM_LM_DELETE = 1062;  // ���� �ı�
  // UpgradeItem ---------------- by sonmg...2003/10/02
  CM_UPGRADEITEM = 1063;  // ������ ���׷��̵� ��û
  // ī��Ʈ ������
  CM_DROPCOUNTITEM = 1064;  // ��ġ�� ������ ����߸�
  // ������ ����
  CM_USERMAKEITEMSEL = 1065;
  CM_USERMAKEITEM = 1066;
  CM_ITEMSUMCOUNT = 1067;

  // ��Ź�Ǹ� -------------------
  CM_MARKET_LIST   = 1068;  // ��Ź�Ǹ� ����Ʈ ��û
  CM_MARKET_SELL   = 1069;  // ��Ź�Ǹ� ���� -> NPC
  CM_MARKET_BUY    = 1070;  // ��Ź��� NPC -> ����
  CM_MARKET_CANCEL = 1071;  // ��Ź��� NPC -> ����
  CM_MARKET_GETPAY = 1072;  // ��Ź��ȸ�� NPC -> ����
  CM_MARKET_CLOSE  = 1073;  // ��Ź���� �̿� ��

  // ��� �Ǹ� ���
  CM_GUILDAGITLIST     = 1074;
  CM_GUILDAGIT_TAG_ADD = 1075;  // ��� ���� ������

  // ����Խ���
  CM_GABOARD_LIST = 1076;  // ����Խ��� ����Ʈ
  CM_GABOARD_ADD  = 1077;  // ����Խ��� �۾���
  CM_GABOARD_READ = 1078;  // ����Խ��� ���б�
  CM_GABOARD_EDIT = 1079;  // ����Խ��� �ۼ���
  CM_GABOARD_DEL  = 1080;  // ����Խ��� �ۻ���
  CM_GABOARD_NOTICE_CHECK = 1081;  // ����Խ��� �������� ���� üũ

  CM_TAG_ADD_DOUBLE = 1082;  // �θ� ���� ���� �߰�

  // ����ٹ̱� -------------------
  CM_DECOITEM_BUY = 1083;  // ����ٹ̱� ������ ����

  //�׷� �Ἲ Ȯ��
  CM_CREATEGROUPREQ_OK   = 1084;  //�׷� �Ἲ Ȯ��
  CM_CREATEGROUPREQ_FAIL = 1085;  //�׷� �Ἲ Ȯ��

  CM_ADDGROUPMEMBERREQ_OK   = 1086;  //�׷� �Ἲ Ȯ��
  CM_ADDGROUPMEMBERREQ_FAIL = 1087;  //�׷� �Ἲ Ȯ��

  // Relationship (cont.)---------------
  CM_LM_DELETE_REQ_OK   = 1088;  // ���� �ı� OK
  CM_LM_DELETE_REQ_FAIL = 1089;  // ���� �ı� FAIL

  CM_CLIENT_CHECKTIME = 1100;
  CM_CANCLOSE = 1101;

  {----------------------------}

  RM_TURN     = 10001;
  RM_WALK     = 10002;
  RM_RUN      = 10003;
  RM_HIT      = 10004;
  RM_HEAVYHIT = 10005;
  RM_BIGHIT   = 10006;
  RM_SPELL    = 10007;
  RM_POWERHIT = 10008;
  RM_SITDOWN  = 10009;
  RM_MOVEFAIL = 10010;
  RM_LONGHIT  = 10011;
  RM_WIDEHIT  = 10012;
  RM_PUSH     = 10013;
  RM_FIREHIT  = 10014;
  RM_RUSH     = 10015;
  RM_RUSHKUNG = 10016;
  // 2003/03/15 �űԹ���
  RM_CROSSHIT = 10017;
  RM_TWINHIT  = 10019;
  RM_DECREFOBJCOUNT = 10018;

  //Assassin Magics
  RM_slashhit = 10057; //Slash
  RM_WIDEHIT2 = 10058; //Assassin Skill 2

  RM_STRUCK     = 10020;
  RM_DEATH      = 10021;
  RM_DISAPPEAR  = 10022;
  //   RM_HIDE                 = 10023;
  RM_SKELETON   = 10024;
  RM_MAGSTRUCK  = 10025;      //ü���� �� �������� ��´�.
  RM_MAGHEALING = 10026;      //����
  RM_STRUCK_MAG = 10027;      //�������� ����
  RM_MAGSTRUCK_MINE = 10028;  //���ړP��
  RM_STONEHIT   = 10029;

  RM_HEAR    = 10030;
  RM_WHISPER = 10031;
  RM_CRY     = 10032;

  RM_WINDCUT    = 10040; // ���ļ�
  RM_DRAGONFIRE = 10041; // õ��⿰(->ȭ��⿰)
  RM_CURSE      = 10042; // ���ּ�

  RM_LOGON   = 10050;
  RM_ABILITY = 10051;
  RM_HEALTHSPELLCHANGED = 10052;
  RM_DAYCHANGING = 10053;

  RM_USERNAME = 10043;
  RM_WINEXP   = 10044;
  RM_LEVELUP  = 10045;
  RM_CHANGENAMECOLOR = 10046;

  //2004/06/22 �űԹ���(���°�, ������, �;ȼ�)
  RM_PULLMON   = 10047;  //���°�, ������
  RM_SUCKBLOOD = 10048;  //������, �Ǹ� ���Ƶ���
  RM_BLINDMON  = 10049;  //�;ȼ�, ���� �þ߸� ����

  RM_GMWHISPER  = 10055;    //��� ����� �� �Ӹ�(2004/11/18)
  RM_LM_WHISPER = 10056;    //���� �ӼӸ�

  RM_SYSMESSAGE    = 10100;
  RM_REFMESSAGE    = 10101;
  RM_GROUPMESSAGE  = 10102;
  RM_SYSMESSAGE2   = 10103;
  RM_GUILDMESSAGE  = 10104;
  RM_SYSMSG_BLUE   = 10105;
  RM_SYSMESSAGE3   = 10106;
  RM_SYSMSG_REMARK = 10107;
  RM_SYSMSG_PINK   = 10108;
  RM_SYSMSG_GREEN  = 10109;

  RM_ITEMSHOW   = 10110;
  RM_ITEMHIDE   = 10111;
  RM_OPENDOOR_OK = 10112;
  RM_CLOSEDOOR  = 10113;
  RM_SENDUSEITEMS = 10114;
  RM_WEIGHTCHANGED = 10115;
  RM_FEATURECHANGED = 10116;
  RM_CLEAROBJECTS = 10117;
  RM_CHANGEMAP  = 10118;
  RM_BUTCH      = 10119;
  RM_MAGICFIRE  = 10120;
  RM_MAGICFIRE_FAIL = 10121;
  RM_SENDMYMAGIC = 10122;
  RM_MAGIC_LVEXP = 10123;
  RM_SOUND      = 10124;
  RM_DURACHANGE = 10125;
  RM_MERCHANTSAY = 10126;
  RM_MERCHANTDLGCLOSE = 10127;
  RM_SENDGOODSLIST = 10128;
  RM_SENDUSERSELL = 10129;
  RM_SENDBUYPRICE = 10130;  //�������� ������� �������� ��� ����
  RM_USERSELLITEM_OK = 10131;
  RM_USERSELLITEM_FAIL = 10132;
  RM_BUYITEM_SUCCESS = 10133;
  RM_BUYITEM_FAIL = 10134;
  RM_SENDDETAILGOODSLIST = 10135;
  RM_GOLDCHANGED = 10136;
  RM_CHANGELIGHT = 10137;
  RM_LAMPCHANGEDURA = 10138;
  RM_CHARSTATUSCHANGED = 10139;
  RM_GROUPCANCEL = 10140;
  RM_SENDUSERREPAIR = 10141;
  RM_SENDREPAIRCOST = 10142;
  RM_USERREPAIRITEM_OK = 10143;
  RM_USERREPAIRITEM_FAIL = 10144;
  //RM_ITEMDURACHANGE       = 10145;
  RM_SENDUSERSTORAGEITEM = 10146;
  RM_SENDUSERSTORAGEITEMLIST = 10147;
  RM_DELITEMS   = 10148;  //������ �о� ����, Ŭ���̾��׿� �˸�.
  RM_SENDUSERMAKEDRUGITEMLIST = 10149;
  RM_MAKEDRUG_SUCCESS = 10150;
  RM_MAKEDRUG_FAIL = 10151;
  RM_SENDUSERSPECIALREPAIR = 10152;
  RM_ALIVE      = 10153;
  RM_DELAYMAGIC = 10154;
  RM_RANDOMSPACEMOVE = 10155;
  // ������ ����
  RM_SENDUSERMAKEITEMLIST = 10156;

  RM_DIGUP      = 10200;
  RM_DIGDOWN    = 10201;
  RM_FLYAXE     = 10202;
  RM_ALLOWPOWERHIT = 10203;
  RM_ALLOWslashhit = 10212;  
  RM_LIGHTING   = 10204;
  RM_NORMALEFFECT = 10205;  //�⺻ ȿ��
  RM_DRAGON_FIRE1 = 10206;
  RM_DRAGON_FIRE2 = 10207;
  RM_DRAGON_FIRE3 = 10208;
  RM_LIGHTING_1 = 10209;
  RM_LIGHTING_2 = 10210;
  RM_FLYAXE_2     = 10211;

  RM_MAKEPOISON  = 10300;
  RM_CHANGEGUILDNAME = 10301; //����� �̸�, ��峻 ��å�̸� ����
  RM_SUBABILITY  = 10302;
  RM_BUILDGUILD_OK = 10303;
  RM_BUILDGUILD_FAIL = 10304;
  RM_DONATE_FAIL = 10305;
  RM_DONATE_OK   = 10306;
  RM_MYSTATUS    = 10307;
  RM_TRANSPARENT = 10308;
  RM_MENU_OK     = 10309;

  RM_SPACEMOVE_HIDE = 10330;
  RM_SPACEMOVE_SHOW = 10331;
  RM_RECONNECT   = 10332;
  RM_HIDEEVENT   = 10333;
  RM_SHOWEVENT   = 10334;
  RM_SPACEMOVE_HIDE2 = 10335;
  RM_SPACEMOVE_SHOW2 = 10336;
  RM_ZEN_BEE     = 10337;  //�񸷿����� ������ ����� ����.
  RM_DELAYATTACK = 10338;  //Ÿ�� ������ ���߱� ���ؼ�
  RM_SPACEMOVE_SHOW_NO = 10339;  //����Ʈ ���� ��Ÿ��

  RM_ADJUST_BONUS = 10400;  //���ʽ� ����Ʈ�� �����϶�.
  RM_MAKE_SLAVE   = 10401;  //�����̵����� ���ϰ� ����´�.

  RM_OPENHEALTH     = 10410;  //ü���� ���濡 ����
  RM_CLOSEHEALTH    = 10411;  //ü���� ���濡�� ������ ����
  RM_DOOPENHEALTH   = 10412;
  RM_BREAKWEAPON    = 10413;  //���Ⱑ ����, �̸ֹ��̼� ȿ��
  RM_INSTANCEHEALGUAGE = 10414;
  RM_CHANGEFACE     = 10415;     //����...
  RM_NEXTTIME_PASSWORD = 10416;  //���� �ѹ��� ��й�ȣ�Է� ���
  RM_DOSTARTUPQUEST = 10417;
  RM_TAG_ALARM      = 10418;  //���������� ���������˸�

  RM_LM_DBWANTLIST = 10420;  // ���λ��� ����Ʈ����
  RM_LM_DBADD      = 10421;  // ���λ��� ����Ʈ����
  RM_LM_DBEDIT     = 10422;  // ���λ��� ����Ʈ����
  RM_LM_DBDELETE   = 10423;  // ���λ��� ����Ʈ����
  RM_LM_DBGETLIST  = 10424;  // ���λ��� ����Ʈ����
  RM_LM_LOGOUT     = 10425;  // ���� ���Ḧ �˷���

  RM_DRAGON_EXP = 10430;  // ��ý��ۿ� ����ġ �ش�.

  RM_LOOPNORMALEFFECT = 10431;  //���� ����Ʈ ȿ��
  RM_LOOPSCREENEFFECT = 10432;  //ȭ�� ����Ʈ

  RM_PLAYDICE = 10500;
  RM_PLAYROCK = 10501;
  //2003/02/11 �׷�� ��ġ ����
  RM_GROUPPOS = 11008;

  // ī��Ʈ ������
  RM_COUNTERITEMCHANGE = 11011;
  RM_USERSELLCOUNTITEM_OK = 11012;
  RM_USERSELLCOUNTITEM_FAIL = 11013;
  // ������ ����
  RM_SENDUSERMAKEFOODLIST = 11014;
  // ������ ��Ź�Ǹ�
  RM_MARKET_LIST   = 11015;
  RM_MARKET_RESULT = 11016;

  // ��� �Ǹ� ���
  RM_GUILDAGITLIST    = 11017;
  RM_GUILDAGITDEALTRY = 11018;

  // ����Խ���
  RM_GABOARD_LIST      = 11019;  // ����Խ��� ����Ʈ
  RM_GABOARD_NOTICE_OK = 11020;  // ����Խ��� �������� ���� OK
  RM_GABOARD_NOTICE_FAIL = 11021;  // ����Խ��� �������� ���� FAIL

  // ����ٹ̱�
  RM_DECOITEM_LIST     = 11022;  // ����ٹ̱� ������ ����Ʈ
  RM_DECOITEM_LISTSHOW = 11023;  // ����ٹ̱� ������ ����Ʈâ ����

  RM_CANCLOSE_OK   = 11024;
  RM_CANCLOSE_FAIL = 11025;



  {----------------------------}
  //������ �޼��������� ��ġ�� ���� �޼�¡

  ISM_PASSWDSUCCESS  = 100;   //�н����� ���, Certification+ID
  ISM_CANCELADMISSION = 101;  //Certification �������..
  ISM_USERCLOSED     = 102;   //����� ���� ����
  ISM_USERCOUNT      = 103;   //�� ������ ����� ��
  ISM_TOTALUSERCOUNT = 104;
  ISM_SHIFTVENTURESERVER = 110;
  ISM_ACCOUNTEXPIRED = 111;
  ISM_GAMETIMEOFTIMECARDUSER = 112;
  ISM_USAGEINFORMATION = 113;
  ISM_FUNC_USEROPEN  = 114;
  ISM_FUNC_USERCLOSE = 115;
  ISM_CHECKTIMEACCOUNT = 116;

  {----------------------------}

  ISM_USERSERVERCHANGE = 200;
  ISM_USERLOGON   = 201;
  ISM_USERLOGOUT  = 202;
  ISM_WHISPER     = 203;
  ISM_SYSOPMSG    = 204;
  ISM_ADDGUILD    = 205;
  ISM_DELGUILD    = 206;
  ISM_RELOADGUILD = 207;
  ISM_GUILDMSG    = 208;
  ISM_CHATPROHIBITION = 209;        //ä��
  ISM_CHATPROHIBITIONCANCEL = 210;  //ä������
  ISM_CHANGECASTLEOWNER = 211;      //��ϼ� ���� ����
  ISM_RELOADCASTLEINFO = 212;       //��ϼ������� �����
  ISM_RELOADADMIN = 213;

  // Friend System -------------
  ISM_FRIEND_INFO   = 214;    // ģ������ �߰�
  ISM_FRIEND_DELETE = 215;    // ģ�� ����
  ISM_FRIEND_OPEN   = 216;    // ģ�� �ý��� ����
  ISM_FRIEND_CLOSE  = 217;    // ģ�� �ý��� �ݱ�
  ISM_FRIEND_RESULT = 218;    // ����� ����
  // Tag System ----------------
  ISM_TAG_SEND      = 219;    // ���� ����
  ISM_TAG_RESULT    = 220;    // ����� ����
  // User System --------------
  ISM_USER_INFO     = 221;    // ������ ���ӻ��� ����
  // 2003/06/12 �����̺� ��ġ
  ISM_CHANGESERVERRECIEVEOK = 222;
  // 2003/08/28 ä�÷α�
  ISM_RELOADCHATLOG = 223;
  // ��Ź�Ǹ� ���� ����
  ISM_MARKETOPEN    = 224;
  ISM_MARKETCLOSE   = 225;
  // relationship --------------
  //   ISM_LM_INFO             = 224;   // ���� ���� ����
  //   ISM_LM_LEVELINFO        = 225;   // ���� �������� ����
  ISM_LM_DELETE     = 226;

  // ���� ��� ��� ------------(sonmg)
  ISM_RELOADMAKEITEMLIST = 227;   // ���� ��� ��� ���ε�

  // ������ȯ ------------(sonmg)
  ISM_GUILDMEMBER_RECALL = 228;   // ������ȯ
  ISM_RELOADGUILDAGIT    = 229;   // ����������� ���ε�.

  //����
  ISM_LM_WHISPER = 230;
  ISM_GMWHISPER  = 231;   //��� �Ӹ�
  //����(sonmg 2005/04/04)
  ISM_LM_LOGIN   = 232;   //���� �α���
  ISM_LM_LOGOUT  = 233;   //���� �α׾ƿ�
  ISM_REQUEST_RECALL = 234;   //��ȯ ��û
  ISM_RECALL     = 235;   //������ ��ȯ
  ISM_LM_LOGIN_REPLY = 236;   //�α��� ���� �� ������ ��ġ����
  ISM_LM_KILLED_MSG = 237;   //���� ���� �޽���

  {----------------------------}

  DB_LOADHUMANRCD = 100;
  DB_SAVEHUMANRCD = 101;
  DB_SAVEANDCHANGE = 102;
  DB_IDPASSWD    = 103;
  DB_NEWUSERID   = 104;
  DB_CHANGEPASSWD = 105;
  DB_QUERYCHR    = 106;
  DB_NEWCHR      = 107;
  DB_GETOTHERNAMES = 108;
  DB_ISVALIDUSER = 111;
  DB_DELCHR      = 112;
  DB_ISVALIDUSERWITHID = 113;
  DB_CONNECTIONOPEN = 114;
  DB_CONNECTIONCLOSE = 115;
  DB_SAVELOGO    = 116;
  DB_GETACCOUNT  = 117;
  DB_SAVESPECFEE = 118;
  DB_SAVELOGO2   = 119;
  DB_GETSERVER   = 120;
  DB_CHANGESERVER = 121;
  DB_LOGINCLOSEUSER = 122;
  DB_RUNCLOSEUSER = 123;
  DB_UPDATEUSERINFO = 124;
  // Friend System -------------
  DB_FRIEND_LIST = 125;   // ģ�� ����Ʈ �䱸
  DB_FRIEND_ADD  = 126;   // ģ�� �߰�
  DB_FRIEND_DELETE = 127;   // ģ�� ����
  DB_FRIEND_OWNLIST = 128;   // ģ���� ����� ��� ����Ʈ �䱸
  DB_FRIEND_EDIT = 129;   // ģ�� ���� ����
  // Tag System ----------------
  DB_TAG_ADD     = 130;   // ���� �߰�
  DB_TAG_DELETE  = 131;   // ���� ����
  DB_TAG_DELETEALL = 132;   // ���� ���� ���� ( �����Ѱ͸� )
  DB_TAG_LIST    = 133;   // ���� ����Ʈ �߰�
  DB_TAG_SETINFO = 134;   // ���� ���� ����
  DB_TAG_REJECT_ADD = 135;   // �ź��� �߰�
  DB_TAG_REJECT_DELETE = 136;   // �ź��� ����
  DB_TAG_REJECT_LIST = 137;   // �ź��� ����Ʈ ��û
  DB_TAG_NOTREADCOUNT = 138;   // �������� ���� ���� ��û
  // RelationShip --------------
  DB_LM_LIST     = 139;   // ������ ����Ʈ �䱸
  DB_LM_ADD      = 140;   // ������ �߰�
  DB_LM_EDIT     = 141;   // ������ ���� ����
  DB_LM_DELETE   = 142;   // ������ ����

  DBR_LOADHUMANRCD = 1100;
  DBR_SAVEHUMANRCD = 1101;
  DBR_IDPASSWD    = 1103;
  DBR_NEWUSERID   = 1104;
  DBR_CHANGEPASSWD = 1105;
  DBR_QUERYCHR    = 1106;
  DBR_NEWCHR      = 1107;
  DBR_GETOTHERNAMES = 1108;
  DBR_ISVALIDUSER = 1111;
  DBR_DELCHR      = 1112;
  DBR_ISVALIDUSERWITHID = 1113;
  DBR_GETACCOUNT  = 1117;
  DBR_GETSERVER   = 1200;
  DBR_CHANGESERVER = 1201;
  DBR_UPDATEUSERINFO = 1202;
  // Friend System ---------------
  DBR_FRIEND_LIST = 1203; // ģ�� ����Ʈ ����
  DBR_FRIEND_WONLIST = 1204; // ģ���� ����� ��� ����
  DBR_FRIEND_RESULT = 1205; // ���ɾ ���� �����
  // Tag System ------------------
  DBR_TAG_LIST    = 1206; // ���� ����Ʈ ����
  DBR_TAG_REJECT_LIST = 1207; // �ź��� ����Ʈ ����
  DBR_TAG_NOTREADCOUNT = 1208; // �������� ���� ���� ����
  DBR_TAG_RESULT  = 1209; // ��ɿ� ���� �����
  // RelationShip ---------------
  DBR_LM_LIST     = 1210; // ���� ����Ʈ ������
  DBR_LM_RESULT   = 1211; // ���ɾ ���� �����

  DBR_FAIL = 2000;
  DBR_NONE = 2000;

  {----------------------------}

  MSM_LOGIN      = 1;
  MSM_GETUSERKEY = 100;
  MSM_SELECTUSERKEY = 101;
  MSM_GETGROUPKEY = 102;
  MSM_SELECTGROUPKEY = 103;
  MSM_UPDATEFEERCD = 120;
  MSM_DELETEFEERCD = 121;
  MSM_ADDFEERCD  = 122;
  MSM_GETTIMEOUTLIST = 123;

  MCM_PASSWDSUCCESS = 10;
  MCM_PASSWDFAIL   = 11;
  MCM_IDONUSE      = 12;
  MCM_GETFEERCD    = 1000;
  MCM_ADDFEERCD    = 1001;
  MCM_ENDTIMEOUT   = 1002;
  MCM_ONUSETIMEOUT = 1003;


  //����Ʈ�� �������� ���

  GM_OPEN  = 1;
  GM_CLOSE = 2;
  GM_CHECKSERVER = 3;     //�������� äũ ��ȣ�� ����
  GM_CHECKCLIENT = 4;     //Ŭ���̾�Ʈ���� äũ ��ȣ�� ����
  GM_DATA  = 5;
  GM_SERVERUSERINDEX = 6;
  GM_RECEIVE_OK = 7;
  GM_TEST  = 20;

  {----------------------------}


  //����
  RC_USERHUMAN = 0;           //����ġ�� ���� �� ����
  RC_NPC      = 10;
  RC_DOORGUARD = 11;          //������ ���
  RC_PEACENPC = 15;

  RC_ARCHERPOLICE = 20;

  RC_ANIMAL   = 50;
  RC_HEN      = 51;       //��
  RC_DEER     = 52;       //�罿...
  RC_WOLF     = 53;       //����
  RC_RUNAWAYHEN = 54;     //�޾Ƴ��� ��
  RC_TRAINER  = 55;       //��������
  RC_MONSTER  = 80;       //�񼱸�
  RC_OMA      = 81;
  RC_SPITSPIDER = 82;
  RC_SLOWMONSTER = 83;
  RC_SCORPION = 84;          //����
  RC_KILLINGHERB = 85;       //������
  RC_SKELETON = 86;          //�ذ�
  RC_DUALAXESKELETON = 87;   //�ֵ����ذ�
  RC_HEAVYAXESKELETON = 88;  //ū�����ذ�
  RC_KNIGHTSKELETON = 89;    //�ذ�����
  RC_BIGKUDEKI = 90;
  RC_MAGCOWFACEMON = 91;
  RC_COWFACEKINGMON = 92;
  RC_THORNDARK = 93;
  RC_LIGHTINGZOMBI = 94;
  RC_DIGOUTZOMBI = 95;
  RC_ZILKINZOMBI = 96;
  RC_COWMON   = 97;        //����
  RC_WHITESKELETON = 100;  //���
  RC_SCULTUREMON = 101;    //�������
  RC_SCULKING = 102;       //�ָ���
  RC_BEEQUEEN = 103;       //����
  RC_ARCHERMON = 104;      //���û�, �ذ�ü�
  RC_GASMOTH  = 105;
  RC_DUNG     = 106;       //��, ����
  RC_CENTIPEDEKING = 107;  //���׿�
  RC_BLACKPIG = 108;       //�海
  RC_CASTLEDOOR = 110;     //��ϼ���, ����,..
  RC_WALL     = 111;       //��ϼ���, ����,..
  RC_ARCHERGUARD = 112;    //�ü����
  RC_ELFMON   = 113;
  RC_ELFWARRIORMON = 114;
  RC_BIGHEARTMON = 115;       //������ �� ū ����
  RC_SPIDERHOUSEMON = 116;    //���ȰŹ�
  RC_EXPLOSIONSPIDER = 117;   //����
  RC_HIGHRISKSPIDER = 118;    //�Ŵ� �Ź�
  RC_BIGPOISIONSPIDER = 119;  //�Ŵ� ���Ź�
  RC_SOCCERBALL = 120;        //�౸��
  RC_BAMTREE  = 121;

  RC_SCULKING_2 = 122;  //¦�� �ָ���
  RC_BLACKSNAKEKING = 123;  //����
  RC_NOBLEPIGKING = 124;   //�͵���
  RC_FEATHERKINGOFKING = 125; //��õ����
  // 2003/02/11 �߰� ��
  RC_SKELETONKING = 126; //�ذ�ݿ�
  RC_TOXICGHOST = 127; //�νı�
  RC_SKELETONSOLDIER = 128; //�ذ���
  // 2003/03/04 �߰� ��
  RC_BANYAGUARD = 129; //�ݾ��»�/�ݾ߿��
  RC_DEADCOWKING = 130; //���õ��
  // 2003/07/15 �߰� ��
  RC_PBOMA1    = 131; //��������
  RC_PBOMA2    = 132; //�蹶ġ��޿���
  RC_PBOMA3    = 133; //�����̻�޿���
  RC_PBOMA4    = 134; //Į�ϱ޿���
  RC_PBOMA5    = 135; //�����ϱ޿���
  RC_PBOMA6    = 136; //Ȱ�ϱ޿���
  RC_PBGUARD   = 137; //���ź�õ â���
  RC_PBMSTONE1 = 138; //���輮1
  RC_PBMSTONE2 = 139; //���輮2
  RC_PBKING    = 140; //������õȲ(��Ȳ����)
  RC_MINE      = 141; //����

  RC_ANGEL      = 142;   //����(õ��)
  RC_CLONE      = 143;   //�н�
  RC_FIREDRAGON = 144;   //��õ���� (ȭ��)
  RC_DRAGONBODY = 145;   //ȭ���
  RC_DRAGONSTATUE = 146; //�뼮��

  RC_EYE_PROG     = 147; //���δ���
  RC_STON_SPIDER  = 148; //�ż�������
  RC_GHOST_TIGER  = 149; //ȯ����ȣ
  RC_JUMA_THUNDER = 150; //�ָ��ݷ���

  RC_GOLDENIMUGI = 151; //Ȳ���̹���

  RC_ARCHERMASTER = 161;  //�ü�ȣ����(2005/08)

  //2005/11/01
  RC_SUPEROMA = 181; //���ۿ���

  RC_FOXWARRIOR = 182; //BlackFoxman
  RC_FOXWIZARD = 183;  //RedFoxman
  RC_FOXTAO = 184; //WhiteFoxman
  RC_TRAPROCK = 185;  //TrapRock
  RC_FAKEROCK = 186;  //Fake TrapRock
  RC_GUARDROCK = 187;  //GuardianRock
  RC_ELEMENTOFTHUNDER = 188;  //ThunderElement
  RC_ELEMENTOFPOISON = 189;  //CloudElement
  RC_KINGELEMENT = 190;  //GreatFoxSpirit
  RC_BIGKEKTAL = 191;  //GreatFoxSpirit  


  //Ŭ���̾�Ʈ ����...
  RCC_HUMAN      = 0;
  RCC_GUARD      = 12;
  RCC_GUARD2     = 24;
  RCC_MERCHANT   = 50;
  RCC_FIREDRAGON = 83; // ��õ���� (ȭ��)

  LA_CREATURE = 0;
  LA_UNDEAD   = 1;


  MP_CANMOVE  = 0;
  MP_WALL     = 1;
  MP_HIGHWALL = 2;

  DR_UP      = 0;
  DR_UPRIGHT = 1;
  DR_RIGHT   = 2;
  DR_DOWNRIGHT = 3;
  DR_DOWN    = 4;
  DR_DOWNLEFT = 5;
  DR_LEFT    = 6;
  DR_UPLEFT  = 7;

  U_DRESS     = 0;
  U_WEAPON    = 1;
  U_RIGHTHAND = 2;
  U_NECKLACE  = 3;
  U_HELMET    = 4;
  U_ARMRINGL  = 5;
  U_ARMRINGR  = 6;
  U_RINGL     = 7;
  U_RINGR     = 8;
  // 2003/03/15 ������ �κ��丮 Ȯ��
  U_BUJUK     = 9;
  U_BELT      = 10;
  U_BOOTS     = 11;
  U_CHARM     = 12;

  UD_USER     = 0;
  UD_USER2    = 1;
  UD_OBSERVER = 2;    // '2' ���
  UD_SYSOP    = 3;    // '1' ���
  UD_ADMIN    = 4;    // '*' ���

  ET_DIGOUTZOMBI = 1;  //���� ���İ� ���� ����
  ET_MINE      = 2;    //������ ����Ǿ� ����
  ET_PILESTONES = 3;   //��������
  ET_HOLYCURTAIN = 4;  //���
  ET_FIRE      = 5;
  ET_SCULPEICE = 6;   //�ָ����� ������ ����
  ET_HEARTPALP = 7;   //������ ��(����)���� �˼� ����
  ET_MINE2     = 8;   //������ ����Ǿ� ����
  ET_JUMAPEICE = 9;   //�ָ��ݷ��� ���� ����
  ET_MINE3     = 10;  //�̺�Ʈ�� ���� �� ������ ����Ǿ� ����(2004/11/03)
  ET_BLIZZARD  = 11;  //Blizzard
  ET_METEOR  = 12;  //MeteorStrike

  NE_HEARTPALP = 1;  //�⺻ ȿ�� �ø���, 1�� �˼�����
  NE_CLONESHOW = 2;  //�нų�Ÿ��
  NE_CLONEHIDE = 3;  //�нŻ����
  NE_THUNDER   = 4;  //����� ����
  NE_FIRE      = 5;  //����� ���
  NE_DRAGONFIRE = 6;  //��Ұ��� ����
  NE_FIREBURN  = 7;  //�뼮����� ���� Ÿ����
  NE_FIRECIRCLE = 8;  //ȭ��⿰
  //2004/06/22 �űԹ��� ����Ʈ.
  NE_MONCAPTURE = 9;  //���°�-��ȹ ����Ʈ
  NE_BLOODSUCK = 10; //������-���� ����Ʈ
  NE_BLINDEFFECT = 11; //�;ȼ� ����Ʈ
  NE_FLOWERSEFFECT = 12; //���� ����Ʈ
  NE_LEVELUP   = 13; //������ ����Ʈ
  NE_RELIVE    = 14; //��Ȱ ����Ʈ
  NE_POISONFOG = 15; //�̹��� ���Ȱ� ����Ʈ
  NE_SN_MOVEHIDE = 16; //�̹��� ���� �����������Ʈ
  NE_SN_MOVESHOW = 17; //�̹��� ���� ��Ÿ��������Ʈ
  NE_SN_RELIVE = 18; //�̹��� ��Ȱ ����Ʈ
  NE_BIGFORCE  = 19; //UltimaEnhancer
  NE_JW_EFFECT1 = 20; //��� ����Ʈ
  NE_FOX_MOVEHIDE = 21; //���������� �����̵� ����Ʈ
  NE_FOX_FIRE  = 22; //���������� ȭ�� ���� ����Ʈ
  NE_FOX_MOVESHOW = 23; //���������� ��Ÿ���� ����Ʈ
  NE_SOULSTONE_HIT = 24; //ȣȥ�� ���� ����Ʈ
  NE_KINGSTONE_RECALL_1 = 25; //���õ�� ��ȯ ���õ�ֿ��� �ѷ���
  NE_KINGSTONE_RECALL_2 = 26; //���õ�� ��ȯ ĳ������ �ѷ���
  NE_SIDESTONE_PULL = 27; //ȣȥ�⼮ ����
  NE_HAPPYBIRTHDAY = 28; //�����̾� ���� ����Ʈ
  NE_KINGTURTLE_MOBSHOW = 29; //�������� ��ȯ�� ��Ÿ��������Ʈ
  NE_USERHEALING = 30; //�ʺ������� NPC�� ����Ʈ
  FOX_SN_MOVEHIDE = 31; //Redfoxman Teleport
  FOX_SN_MOVESHOW = 32; //Redfoxman Teleport
  FOX_SN_SUMMON = 33; //Whitefoxman Summon
  ROCK_SN_POISON = 34; //TrapRock Attack
  ROCK_SN_PULL = 35; //GuardianRock Attack
  NE_ROCKPULLEFFECT = 36; //GuardianRock Attack
  SPIRIT_SN_THUNDER = 37; //GreatFoxSpirit Attack
  NE_SPIRITEFFECT = 38; //GreatFoxSpirit Attack
  SPIRIT_SN_MASS1S = 39; //GreatFoxSpirit Attack
  SPIRIT_SN_MASS1 = 40; //GreatFoxSpirit Attack
  SPIRIT_SN_MASS2 = 41; //GreatFoxSpirit Attack
  SPIRIT_SN_MASS3 = 42; //GreatFoxSpirit Attack
  SPIRIT_SN_MASS4 = 43; //GreatFoxSpirit Attack
  SPIRIT_SN_MASS5 = 44; //GreatFoxSpirit Attack
  NE_SPIRITMASS = 45; //GreatFoxSpirit Attack
  NE_BLIZZARDEFFECT  = 46; //Blizzard
  NE_REVIVALCHARGE = 47; //Reincarnation

  SWD_LONGHIT  = 12; //��˼�
  SWD_WIDEHIT  = 25; //�ݿ��˹�
  SWD_FIREHIT  = 26; //��ȭ��
  SWD_RUSHRUSH = 27; //���º�
  // 2003/03/15 �űԹ���
  SWD_CROSSHIT = 34; //��ǳ��
  SWD_TWINHIT  = 38; //�ַ���
  SWD_STONEHIT = 43; //������
  SWD_WIDEHIT2  = 60; //Assassin Skill 2

  //����Ʈ ����
  //IF
  QI_CHECK      = 1;  //101�̻�
  QI_RANDOM     = 2;
  QI_GENDER     = 3;     //MAN or WOMAN
  QI_DAYTIME    = 4;     //SUNRAISE DAY SUNSET NIGHT
  QI_CHECKOPENUNIT = 5;  //����üũ
  QI_CHECKUNIT  = 6;     //����üũ
  QI_CHECKLEVEL = 7;
  QI_CHECKJOB   = 8;  //Warrior, Wizard, Taoist
  QI_CHECKITEM  = 20;
  QI_CHECKITEMW = 21;
  QI_CHECKGOLD  = 22;
  QI_ISTAKEITEM = 23;  //������� ���� �������� �������� �˻�
  QI_CHECKDURA  = 24;  //�������� �������� ��� ����(dura / 1000) �˻�
  //������ �ִ� ��� �ְ� ������ �˻�
  QI_CHECKDURAEVA = 25;
  QI_DAYOFWEEK  = 26;  //���� �˻�
  QI_TIMEHOUR   = 27;  //�ð����� �˻�(0..23)
  QI_TIMEMIN    = 28;  //�� �˻�
  QI_CHECKPKPOINT = 29;
  QI_CHECKLUCKYPOINT = 30;
  QI_CHECKMON_MAP = 31;   //���� �ʿ� ���� �ִ���
  QI_CHECKMON_AREA = 32;  //Ư�� ������ ���� �ִ���
  QI_CHECKHUM   = 33;
  QI_CHECKBAGGAGE = 34;  //����ڿ��� �� �� �ִ���?
  //6-11
  QI_CHECKNAMELIST = 35;
  QI_CHECKANDDELETENAMELIST = 36;
  QI_CHECKANDDELETEIDLIST = 37;
  //*dq
  QI_IFGETDAILYQUEST = 40;  //���� ����Ʈ�� �޾Ҵ��� �˻�, ��ȿ�Ⱓ �˻� ����
  QI_CHECKDAILYQUEST = 41;  //Ư�� ��ȣ�� ����Ʈ�� ���������� �˻�, ��ȿ�Ⱓ �˻� ����
  QI_RANDOMEX   = 42;  //�Ķ��Ÿ  5 100   5%��...

  QI_CHECKMON_NORECALLMOB_MAP = 43;   //���� �ʿ� �ִ� �� ��(��ȯ�� ����)
  QI_CHECKBAGREMAIN = 44;  //���� ������ ������ N�� ���� �ִ���

  QI_CHECKGRADEITEM = 50;

  QI_EQUALVAR = 51;   //EQUALV D1 P1  //D1�� P1�� ������

  QI_EQUAL = 135;  //EQUAL P1 10   //P1�� 10����
  QI_LARGE = 136;  //LARGE P1 10   //P1�� 10���� ū��
  QI_SMALL = 137;  //SMALL P1 10   //P1�� 10���� ������ �˻�

  QI_ISGROUPOWNER   = 138;  //�׷� ���������� �ƴ��� �˻�
  QI_ISEXPUSER      = 139;  //ü���� ��������� �˻�
  QI_CHECKLOVERFLAG = 140;
  //������ �÷��װ� TRUE���� �˻�(���������� ã�� �� ������ FALSE ����)
  QI_CHECKLOVERRANGE = 141;  //������ ���� ���� �ȿ� �ִ���
  QI_CHECKLOVERDAY  = 142;  //���ΰ��� �������� ������ �̻� �Ǵ���
  //�����α�
  QI_CHECKDONATION  = 146;    // ���� ��α� �ܾ� üũ
  QI_ISGUILDMASTER  = 147;    // Guildmaster���� üũ
  QI_CHECKWEAPONBADLUCK = 148;     //������ ���� üũ
  QI_CHECKPREMIUMGRADE = 149;    // �����̾� ��� üũ
  QI_CHECKCHILDMOB  = 150;    // ��ȯ���� ���� �̸����� üũ

  QI_CHECKGROUPJOBBALANCE = 151;    // �׷쿡 ����, ����, ���� ���� ������ üũ

  //Action

  QA_SET      = 1;   //101�̻�
  QA_TAKE     = 2;   //�������� �޴�
  QA_GIVE     = 3;
  QA_TAKEW    = 4;   //�����ϰ� �ִ� �������� �޴�
  QA_CLOSE    = 5;   //��ȭâ�� ����
  QA_RESET    = 6;
  QA_OPENUNIT = 7;
  QA_SETUNIT  = 8;   //���ּ�  1..100
  QA_RESETUNIT = 9;  //���ָ���   1..100
  QA_BREAK    = 10;
  QA_TIMERECALL = 11;  // ������ �ð��� ������ ���� ��ҷ� ��ȯ �ȴ�.
  QA_PARAM1   = 12;
  QA_PARAM2   = 13;
  QA_PARAM3   = 14;
  QA_PARAM4   = 15;
  QA_MAPMOVE  = 20;
  QA_MAPRANDOM = 21;
  QA_TAKECHECKITEM = 22;  //CHECK�׸񿡼� �˻�� �������� �޴´�.
  QA_MONGEN   = 23;       //���͸� ����Ŵ
  QA_MONCLEAR = 24;       //���͸� ��� ���� ��Ų��
  QA_MOV      = 25;
  QA_INC      = 26;
  QA_DEC      = 27;
  QA_SUM      = 28; //SUM P1 P2 //P9 = P1 + P2
  QA_BREAKTIMERECALL = 29;
  QA_TIMERECALLGROUP = 30;  // ������ �ð��� ������ �׷� ��ü�� ���� ��ҷ� ��ȯ �ȴ�.

  QA_MOVRANDOM     = 50;  //MOVR
  QA_EXCHANGEMAP   = 51;  //EXCHANGEMAP R001  //R001�� �ִ� �� ����� �ڸ��� �ٲ۴�.
  QA_RECALLMAP     = 52;  //RECALLMAP R001  //R001�� �ִ� ������� ��� ��ȯ �Ѵ�.
  QA_ADDBATCH      = 53;
  QA_BATCHDELAY    = 54;
  QA_BATCHMOVE     = 55;
  QA_PLAYDICE      = 56;
  //PLAYDICE 2 @diceresult //2���� �ֻ����� ������. ���� @diceresult �������� ����
  //6-11
  QA_ADDNAMELIST   = 57;
  QA_DELETENAMELIST = 58;
  QA_PLAYROCK      = 59;
  //PLAYDICE 2 @diceresult //2���� �ֻ����� ������. ���� @diceresult �������� ����
  //*dq
  QA_RANDOMSETDAILYQUEST = 60;
  //�Ķ����,  �ּ�, �ִ�  ��) 401 450  401���� 450������ �������� ����
  QA_SETDAILYQUEST = 61;

  QA_GIVEEXP = 63; // ����ġ �ֱ�(�̺�Ʈ ������ ��� ����)

  QA_TAKEGRADEITEM = 70;

  QA_GOTOQUEST = 100;
  QA_ENDQUEST  = 101;
  QA_GOTO      = 102;
  QA_SOUND     = 103;
  QA_CHANGEGENDER = 104;
  QA_KICK      = 105;
  QA_MOVEALLMAP = 106;    // ���� �� �������� ��� Ư�� ������ �̵���Ŵ.
  QA_MOVEALLMAPGROUP = 107;
  // �׷� ����� �߿� ���� �ʿ� �ִ� ����鸸 Ư�� ������ �̵���Ŵ.
  QA_RECALLMAPGROUP = 108;
  // �׷� ����� �߿� Ư�� �ʿ� �ִ� ����鸸 ���� ������ �̵���Ŵ.
  QA_WEAPONUPGRADE = 109;    // ��� �ִ� ���⿡ �ɼ��� ���δ�.
  QA_SETALLINMAP = 110;    // ���� �ʿ� �ִ� ��� �������� �÷��׸� SET�Ѵ�.
  QA_INCPKPOINT = 111;    // PK Point�� ������Ų��.
  QA_DECPKPOINT = 112;    // PK Point�� ���ҽ�Ų��.
  //����
  QA_MOVETOLOVER = 113;    // ���ξ����� �̵��Ѵ�.
  QA_BREAKLOVER = 114;    // ���ΰ��踦 �Ϲ������� ������Ų��.
  QA_SOUNDALL  = 115;    // �ֺ�������� ���带 �����

  //�����α�
  QA_DECDONATION = 118;    // ��α� �ܾ��� ���� ��Ų��.
  QA_SHOWEFFECT = 119;    // �������Ʈ�� �����ش�.
  QA_MONGENAROUND = 120;    // ĳ���� ������ ���͸� �� ��Ų��.
  QA_RECALLMOB = 121;    // ���� ���� ��ȯ
  QA_INSTANTPOWERUP = 128; //���� �ɷ�ġ ���
  QA_INSTANTEXPDOUBLE = 129; //���� ����ġ 2��
  QA_HEALING = 130; //����

  VERSION_NUMBER = 20050501;
  VERSION_NUMBER_20030805 = 20030805;
  VERSION_NUMBER_20030715 = 20030715;
  VERSION_NUMBER_20030527 = 20030527;
  VERSION_NUMBER_20030403 = 20030403;
  VERSION_NUMBER_030328 = 20030328;
  VERSION_NUMBER_030317 = 20030317;
  VERSION_NUMBER_030211 = 20030211;
  VERSION_NUMBER_030122 = 20030122;
  VERSION_NUMBER_020819 = 20020819;
  VERSION_NUMBER_0522 = 20020522;
  VERSION_NUMBER_02_0403 = 20020403;
  VERSION_NUMBER_01_1006 = 20011006;
  VERSION_NUMBER_0925 = 20010925;
  VERSION_NUMBER_0704 = 20010704;
  //VERSION_NUMBER_0522 = 20010522;
  VERSION_NUMBER_0419 = 20010419;
  VERSION_NUMBER_0407 = 20010407;
  VERSION_NUMBER_0305 = 20010305;
  VERSION_NUMBER_0216 = 20010216;
  BUFFERSIZE = 10000;

  // �������� ��ȭ�� ����
  EFFTYPE_TWOHAND_WEHIGHT_ADD = 1;
  EFFTYPE_EQUIP_WHEIGHT_ADD = 2;
  EFFTYPE_LUCK_ADD     = 3;
  EFFTYPE_BAG_WHIGHT_ADD = 4;
  EFFTYPE_HP_MP_ADD    = 5;
  EFFTYPE2_EVENT_GRADE = 6;

  // Comand Result Defines... PDS:2003-03-31 ---------------------------------
  CR_SUCCESS   = 0;       // ����
  CR_FAIL      = 1;       // ����
  CR_DONTFINDUSER = 2;       // ������ ã�� �� ����
  CR_DONTADD   = 3;       // �߰��� �� ����
  CR_DONTDELETE = 4;       // ������ �� ����
  CR_DONTUPDATE = 5;       // ������ �� ����
  CR_DONTACCESS = 6;       // ���� �Ұ���
  CR_LISTISMAX = 7;       // ����Ʈ�� �ִ�ġ�̹Ƿ� �Ұ���
  CR_LISTISMIN = 8;       // ����Ʈ�� �ּ�ġ�̹Ƿ� �Ұ���
  CR_DBWAIT    = 9;       // DB���� ��ٸ��� �ִ��� 

  // ���ӻ���  PDS:2003-03-31 ------------------------------------------------
  CONNSTATE_UNKNOWN    = 0;       // �˼� ����
  CONNSTATE_DISCONNECT = 1;       // ������ ����
  CONNSTATE_NOUSE1     = 2;       // ������
  CONNSTATE_NOUSE2     = 3;       // ������
  CONNSTATE_CONNECT_0  = 4;       // 0�������� ������
  CONNSTATE_CONNECT_1  = 5;       // 1�������� ������
  CONNSTATE_CONNECT_2  = 6;       // 2�������� ������
  CONNSTATE_CONNECT_3  = 7;       // 3�������� ������ : ����θ���

  // ����з�  2003/04/15 ģ��, ����
  RT_FRIENDS   = 1;       // ģ��
  RT_LOVERS    = 2;       // ����
  RT_MASTER    = 3;       // ���
  RT_DISCIPLE  = 4;       // ����
  RT_BLACKLIST = 8;       // �ǿ�

  // ��������  PDS:2003-03-31 ------------------------------------------------
  TAGSTATE_NOTREAD = 0;       // ��������
  TAGSTATE_READ    = 1;       // ����
  TAGSTATE_DONTDELETE = 2;       // ��������
  TAGSTATE_DELETED = 3;       // ������

  // �������� ���濡�� ����
  TAGSTATE_WANTDELETABLE = 3;     // ���������ϰ� ����

  // Relationship Request Sequences...
  RsReq_None      = 0;        // �⺻����
  RsReq_WantToJoinOther = 1;        // �������� ������û�� ��
  RsReq_WaitAnser = 2;        // ������ ��ٸ�
  RsReq_WhoWantJoin = 3;        // ������ ������ ����
  RsReq_AloowJoin = 4;        // ������ �����
  RsReq_DenyJoin  = 5;        // ������ ������
  RsReq_Cancel    = 6;        // ���

  RaReq_CancelTime  = 30 * 1000; // �ڵ� ��� �ð� 30�� msec
  MAX_WAITTIME      = 60 * 1000; // �ִ� ��ٸ��� �ð�
  // Relationship State Define...
  RsState_None      = 0;         // �⺻����
  RsState_Lover     = 10;        // ����
  RsState_LoverEnd  = 11;        // ����Ż��
  RsState_Married   = 20;        // ��ȥ
  RsState_MarriedEnd = 21;        // ��ȥŻ��
  RsState_Master    = 30;        // ���
  RsState_MasterEnd = 31;        // ���Ż��
  RsState_Pupil     = 40;        // ����
  RsState_PupilEnd  = 41;        // ����Ż��
  RsState_TempPupil = 50;        // �ӽ�����
  RsState_TempPupilEnd = 51;        // �ӽ�����Ż��

  // RelationShip Error Code...
  RsError_SuccessJoin   = 1;         // ������ �����Ͽ��� ( �����ѻ����)
  RsError_SuccessJoined = 2;         // ������ �����Ǿ����� ( ������ �����)
  RsError_DontJoin      = 3;         // �����Ҽ� ����
  RsError_DontLeave     = 4;         // ������ ����.
  RsError_RejectMe      = 5;         // �źλ����̴�
  RsError_RejectOther   = 6;         // �źλ����̴�
  RsError_LessLevelMe   = 7;         // ���Ƿ����� ����
  RsError_LessLevelOther = 8;         // �����Ƿ����� ����
  RsError_EqualSex      = 9;         // ������ ����
  RsError_FullUser      = 10;        // �����ο��� ����á��
  RsError_CancelJoin    = 11;        // �������
  RsError_DenyJoin      = 12;        // ������ ������
  RsError_DontDelete    = 13;        // Ż���ų�� ����.
  RsError_SuccessDelete = 14;        // Ż�������
  RsError_NotRelationShip = 15;        // �������°� �ƴϴ�.

  // ��ġ��
  MAX_OVERLAPITEM = 1000;

  // ��Ź���� �Ǹ�����
  // ���������۷�
  USERMARKET_TYPE_ALL      = 0;     // ���
  USERMARKET_TYPE_WEAPON   = 1;     // ����
  USERMARKET_TYPE_NECKLACE = 2;     // �����
  USERMARKET_TYPE_RING     = 3;     // ����
  USERMARKET_TYPE_BRACELET = 4;     // ����,�尩
  USERMARKET_TYPE_CHARM    = 5;     // ��ȣ��
  USERMARKET_TYPE_HELMET   = 6;     // ����
  USERMARKET_TYPE_BELT     = 7;     // �㸮��
  USERMARKET_TYPE_SHOES    = 8;     // �Ź�
  USERMARKET_TYPE_ARMOR    = 9;     // ����
  USERMARKET_TYPE_DRINK    = 10;     // �þ�
  USERMARKET_TYPE_JEWEL    = 11;     // ����,����
  USERMARKET_TYPE_BOOK     = 12;     // å
  USERMARKET_TYPE_MINERAL  = 13;     // ����
  USERMARKET_TYPE_QUEST    = 14;     // ����Ʈ������
  USERMARKET_TYPE_ETC      = 15;     // ��Ÿ
  USERMARKET_TYPE_ITEMNAME = 16;     // �������̸�
  // ��Ʈ��
  USERMARKET_TYPE_SET      = 100;     // ��Ʈ ������
  // ������
  USERMARKET_TYPE_MINE     = 200;     // �ڽ����ǹ���
  USERMARKET_TYPE_OTHER    = 300;     // �ٸ������ �ǹ���

  USERMARKET_MODE_NULL    = 0;     // �ʱⰪ
  USERMARKET_MODE_BUY     = 1;     // ��¸��
  USERMARKET_MODE_INQUIRY = 2;     // ��ȸ���
  USERMARKET_MODE_SELL    = 3;     // �ǸŸ��


  MARKET_CHECKTYPE_SELLOK     = 1;    //��Ź ����
  MARKET_CHECKTYPE_SELLFAIL   = 2;    //��Ź ����
  MARKET_CHECKTYPE_BUYOK      = 3;    //���� ����
  MARKET_CHECKTYPE_BUYFAIL    = 4;    //���� ����
  MARKET_CHECKTYPE_CANCELOK   = 5;    //��� ����
  MARKET_CHECKTYPE_CANCELFAIL = 6;    //��� ����
  MARKET_CHECKTYPE_GETPAYOK   = 7;    //�� ȸ�� ����
  MARKET_CHECKTYPE_GETPAYFAIL = 8;    //�� ȸ�� ����

  MARKEY_DBSELLTYPE_SELL     = 1;    //�Ǹ���
  MARKEY_DBSELLTYPE_BUY      = 2;    //����
  MARKEY_DBSELLTYPE_CENCEL   = 3;    //���
  MARKEY_DBSELLTYPE_GETPAY   = 4;    //�ݾ�ȸ��
  MARKEY_DBSELLTYPE_READYSELL = 11;  //�ӽ� �Ǹ���
  MARKEY_DBSELLTYPE_READYBUY = 12;   //�ӽ� �����
  MARKEY_DBSELLTYPE_READYCANCEL = 13;//�ӽ� �����
  MARKEY_DBSELLTYPE_READYGETPAY = 14;//�ӽ� ȸ����
  MARKEY_DBSELLTYPE_DELETE   = 20;   //����

  // ��Ź���� ���ϰ�
  UMResult_Success   = 0;     // ����
  UMResult_Fail      = 1;     // ����
  UMResult_ReadFail  = 2;     // �б� ����
  UMResult_WriteFail = 3;     // ���� ����
  UMResult_ReadyToSell = 4;     // �ǸŰ���
  UMResult_OverSellCount = 5;     // �Ǹ� ������ ���� �ʰ�
  UMResult_LessMoney = 6;     // ��������
  UMResult_LessLevel = 7;     // ��������
  UMResult_MaxBagItemCount = 8;     // ���濡 �����۲���
  UMResult_NoItem    = 9;     // �������� ����
  UMResult_DontSell  = 10;     // �ǸźҰ�
  UMResult_DontBuy   = 11;     // ���ԺҰ�
  UMResult_DontGetMoney = 12;     // �ݾ�ȸ�� �Ұ�
  UMResult_MarketNotReady = 13;     // ��Ź�ý��� ��ü�� �Ұ���
  UMResult_LessTrustMoney = 14;     // ��Ź�ݾ��� ���� 1000 �� ���ٴ� Ŀ�ߵ�
  UMResult_MaxTrustMoney = 15;     // ��Ź�ݾ��� �ʹ� ŭ
  UMResult_CancelFail = 16;     // ��Ź��� ����
  UMResult_OverMoney = 17;     // �����ݾ� �ִ�ġ�� �Ѿ
  UMResult_SellOK    = 18;     // �ǸŰ� �߉���
  UMResult_BuyOK     = 19;     // ������ �߉���
  UMResult_CancelOK  = 20;     // �Ǹ���Ұ� �߉���
  UMResult_GetPayOK  = 21;     // �Ǹű� ȸ���� �߉���

  // �����ִ�ġ
  MAX_MARKETPRICE = 50000000;  //5000����


function RACEfeature(feature: longint): byte;
function DRESSfeature(feature: longint): byte;
function WEAPONfeature(feature: longint): byte;
function HAIRfeature(feature: longint): byte;
function APPRfeature(feature: longint): word;
function MakeFeature(race, dress, weapon, face: byte): longint;
function MakeFeatureAp(race, state: byte; appear: word): longint;
function MakeDefaultMsg(msg: word; soul: integer;
  wparam, atag, nseries: word): TDefaultMessage;
function UpInt(r: real): integer;


implementation


function RACEfeature(feature: longint): byte;
begin
  Result := LOBYTE(LOWORD(feature));
end;

function WEAPONfeature(feature: longint): byte;
begin
  Result := HIBYTE(LOWORD(feature));
end;

function HAIRfeature(feature: longint): byte;
begin
  Result := LOBYTE(HIWORD(feature));
end;

function DRESSfeature(feature: longint): byte;
begin
  Result := HIBYTE(HIWORD(feature));
end;

function APPRfeature(feature: longint): word;
begin
  Result := HIWORD(feature);
end;

function MakeFeature(race, dress, weapon, face: byte): longint;
begin
  Result := MakeLong(MakeWord(race, weapon), MakeWord(face, dress));
end;

function MakeFeatureAp(race, state: byte; appear: word): longint;
begin
  Result := MakeLong(MakeWord(race, state), appear);
end;

function MakeDefaultMsg(msg: word; soul: integer;
  wparam, atag, nseries: word): TDefaultMessage;
begin
  with Result do begin
    Ident  := msg;
    Recog  := soul;
    param  := wparam;
    Tag    := atag;
    Series := nseries;
  end;
end;

function UpInt(r: real): integer;
begin
  if r > int(r) then
    Result := Trunc(r) + 1
  else
    Result := Trunc(r);
end;


end.
