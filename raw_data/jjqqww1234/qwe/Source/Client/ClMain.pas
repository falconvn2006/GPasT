unit ClMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DirectX, DXClass, DrawScrn, IntroScn, PlayScn, MapUnit, WIL, Grobal2,
  Actor, DIB, StdCtrls, CliUtil, ScktComp, ExtCtrls, HUtil32, EdCode,
  DWinCtl, ClFunc, magiceff, SoundUtil, DXSounds, clEvent, {Wave,} IniFiles,
  MaketSystem, RelationShip, NPGameDLL;

const
  BO_FOR_TEST    = False;
  KoreanVersion  = False;  //TRUE;
  EnglishVersion = True;   //FALSE;
  ChinaVersion   = False;
  TaiwanVersion  = False;
  BoUseFindHack  = False;
  BoNeedPatch    = True;
  // 2003/02/11
  BoDebugModeScreen = False;
  BoCompileMode  = True;

  //   VERSION_YEAR = 2004;
  //   VERSION_MON  = 8;  //4;  //1;
  //   VERSION_DAY  = 19;  //3;  //28;

  VERSION_YEAR = 2005;
  VERSION_MON  = 5;  //4;  //1;
  VERSION_DAY  = 1;  //3;  //28;

  LocalLanguage: TImeMode = imOpen;
  SERVERADDR: string = '211.174.174.130';  //'194.153.73.54'; //'210.121.143.205';
  TESTSERVERADDR     = '218.144.170.250';  //211.174.174.250';
  kornetworldaddress = '211.48.62.250';    //코넷월드
  NEARESTPALETTEINDEXFILE = 'Data\npal.idx';

  ScreenMode: Boolean    = False;
  LogoText = 'Ver. 2.2';

  SCREENWIDTH  = 800;
  SCREENHEIGHT = 600;
  MAXBAGITEMCL = 52;
  ENEMYCOLOR   = 69;

  MAXFONT = 4;
  // 2003/02/11 그룹원 표시
  MAXVIEWOBJECT = 20;

  FontKorArr: array[0..MAXFONT - 1] of string = (
    'Batang',
    'Gulrym',
    'Gungseo',
    'Dodum'
    );

  FontEngArr: array[0..MAXFONT - 1] of string = (
    'Courier New',
    'Arial',
    'MS Sans Serif',
    'Microsoft Sans Serif'
    );

  CurFont: integer    = 0;
  //   CurFontName: string = 'Gulrym';
  CurFontName: string = 'Courier New';

  //HIT
  HIT_INCLEVEL = 14;
  HIT_INCSPEED = 60;
  HIT_BASE     = 1400;
  //   RUN_STRUCK_DELAY: integer = 3 * 1000;
  RUN_STRUCK_DELAY: integer = 0;

 // SAT DELAY
 //   SAY_DELAY_TIME = 500;
type
  TKornetWorld = record
    CPIPcode: string;
    SVCcode:  string;
    LoginID:  string;
    CheckSum: string;
  end;

  TOneClickMode   = (toNone, toKornetWorld);
  TTimerCommand   = (tcSoftClose, tcReSelConnect, tcFastQueryChr, tcQueryItemPrice);
  TChrAction      = (caWalk, caRun, caHit, caSpell, caSitdown);
  TConnectionStep = (cnsLogin, cnsSelChr, cnsReSelChr, cnsPlay);

  TMovingItem = record
    Index: integer; //ItemArr의 Index
    Item:  TClientItem;
  end;
  PTMovingItem    = ^TMovingItem;
  // 2003/02/11 ViewObject...미니맵상에 그룹원 표시
  TMiniViewObject = record
    Index:    integer;
    x, y:     integer;
    LastTick: longword;
  end;
  PTMiniViewObject = ^TMiniViewObject;

  TFrmMain = class(TDxForm)
    DXDraw1:    TDXDraw;
    WTiles:     TWMImages;
    WObjects1:  TWMImages;
    WSmTiles:   TWMImages;
    WHumImg:    TWMImages;
    WProgUse:   TWMImages;
    CSocket:    TClientSocket;
    Timer1:     TTimer;
    MouseTimer: TTimer;
    WMonImg:    TWMImages;
    DWinMan:    TDWinManager;
    WHairImg:   TWMImages;
    WBagItem:   TWMImages;
    WWeapon:    TWMImages;
    WStateItem: TWMImages;
    WDnItem:    TWMImages;
    WaitMsgTimer: TTimer;
    SelChrWaitTimer: TTimer;
    WMagic:     TWMImages;
    CmdTimer:   TTimer;
    WNpcImg:    TWMImages;
    WMagIcon:   TWMImages;
    WChrSel:    TWMImages;
    MinTimer:   TTimer;
    WMon2Img:   TWMImages;
    WMon3Img:   TWMImages;
    WMMap:      TWMImages;
    WMon4Img:   TWMImages;
    DXSound:    TDXSound;
    WMon5Img:   TWMImages;
    WMon6Img:   TWMImages;
    WEffectImg: TWMImages;
    WObjects2:  TWMImages;
    WObjects3:  TWMImages;
    WObjects4:  TWMImages;
    WObjects5:  TWMImages;
    WObjects6:  TWMImages;
    WObjects7:  TWMImages;
    WMon7Img:   TWMImages;
    WMon8Img:   TWMImages;
    WMon9Img:   TWMImages;
    WMon10Img:  TWMImages;
    WMon11Img:  TWMImages;
    WMon12Img:  TWMImages;
    WMon13Img:  TWMImages;
    WMon14Img:  TWMImages;
    WMon15Img:  TWMImages;
    WMon16Img:  TWMImages;
    WMon17Img:  TWMImages;
    WMon18Img:  TWMImages;
    WMagic2:    TWMImages;
    WProgUse2:  TWMImages;
    WMon19Img:  TWMImages;
    WMon20Img:  TWMImages;
    WMon21Img:  TWMImages;
    WMon22Img:  TWMImages;
    WObjects8:  TWMImages;
    WObjects9:  TWMImages;
    WObjects10: TWMImages;
    WHumWing:   TWMImages;
    WDragonImg: TWMImages;
    WMon23Img:  TWMImages;
    WDecoImg:   TWMImages;
    DXTimer: TDXTimer;
    WMon24Img: TWMImages;
    WMon25Img: TWMImages;
    WKillerWeaponL: TWMImages;
    WKillerWeaponR: TWMImages;
    WKillerHumImg: TWMImages;
    WKillerHairImg: TWMImages;
    WKillerWing: TWMImages;
    WHumImg2: TWMImages;
    WKillerHumImg2: TWMImages;
    procedure DXDraw1Initialize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DXDraw1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure DXDraw1Finalize(Sender: TObject);
    procedure CSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer1Timer(Sender: TObject);
    procedure MsgProg;
    procedure DXDraw1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure MouseTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DXDraw1DblClick(Sender: TObject);
    procedure WaitMsgTimerTimer(Sender: TObject);
    procedure SelChrWaitTimerTimer(Sender: TObject);
    procedure DXDraw1Click(Sender: TObject);
    procedure CmdTimerTimer(Sender: TObject);
    procedure MinTimerTimer(Sender: TObject);
    procedure CheckHackTimerTimer(Sender: TObject);
    procedure SendTimeTimerTimer(Sender: TObject);
    procedure DelitemProg;
    procedure MainCancelItemMoving;
    procedure FormKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure DXDraw1FinalizeSurface(Sender: TObject);
    procedure DXDraw1RestoreSurface(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
  private
    SocStr, BufferStr: string;
    WarningLevel: integer;
    TimerCmd:  TTimerCommand;
    MakeNewId: string; //지금만들려고하는 아이디

    ActionLockTime: longword;
    LastHitTime:    longword;
    ActionFailLock: boolean;
    FailAction, FailDir: integer;
    FailActionTime: longword;
    ActionKey:      word;

    CursorSurface: TDirectDrawSurface;
    mousedowntime: longword;
    WaitingMsg:    TDefaultMessage;
    WaitingStr:    string;
    //    FSayTime    : LongWord; // 체팅창의 내용을 전송한 시간

    procedure SpeedHackTimerTimer(Sender: TObject);
    procedure FindWHHackTimerTimer(Sender: TObject);
    procedure RunEffectTimerTimer(Sender: TObject); // FireDragon

    procedure ProcessKeyMessages;
    procedure ProcessActionMessages;
    procedure CheckSpeedHack(rtime: longword);
    procedure CheckSpeedHackChina(stime: longword);
    procedure DecodeMessagePacket(datablock: string);
    procedure ActionFailed;
    function GetMagicByKey(Key: char): PTClientMagic;
    procedure UseMagic(tx, ty: integer; pcm: PTClientMagic);
    procedure UseMagicSpell(who, effnum, targetx, targety, magic_id: integer);
    procedure UseMagicFire(who, efftype, effnum, targetx, targety, target: integer);
    procedure UseMagicFireFail(who: integer);
    procedure CloseAllWindows;
    procedure ClearDropItems;
    procedure ResetGameVariables;
    procedure ChangeServerClearGameVariables;
    procedure _DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);

    function CheckDoorAction(dx, dy: integer): boolean;
    procedure ClientGetPasswdSuccess(body: string);
    procedure ClientGetNeedUpdateAccount(body: string);
    procedure ClientGetSelectServer;
    procedure ClientGetReceiveChrs(body: string);
    procedure ClientGetStartPlay(body: string);
    procedure ClientGetReconnect(body: string);
    procedure ClientGetMapDescription(body: string);
    procedure ClientGetAdjustBonus(bonus: integer; body: string);
    procedure ClientGetAddItem(body: string);
    procedure ClientGetUpdateItem(body: string);
    procedure ClientGetDelItem(body: string; flag: integer);
    procedure ClientGetDelItems(body: string);
    procedure ClientGetBagItmes(body: string);
    procedure ClientGetDropItemFail(iname: string; sindex: integer);
    procedure ClientGetShowItem(itemid, x, y, looks: integer; body: string);
    procedure ClientGetHideItem(itemid, x, y: integer);
    procedure ClientGetSenduseItems(body: string);
    procedure ClientGetAddMagic(body: string);
    procedure ClientGetDelMagic(magid: integer);
    procedure ClientGetMyMagics(checksum: integer; body: string);
    procedure ClientGetMagicLvExp(magid, maglv, magtrain: integer);
    procedure ClientGetSound(soundid: integer);
    procedure ClientGetDuraChange(uidx, newdura, newduramax: integer);
    procedure ClientGetMerchantSay(merchant, face: integer; saying: string);
    procedure ClientGetSendGoodsList(merchant, Count: integer; body: string);
    procedure ClientGetDecorationList(merchant, Count: integer; body: string);
    procedure ClientGetJangwonList(Page, Count: integer; body: string);
    procedure ClientGetGABoardList(ListNum, Page, MaxPage: integer; body: string);
    procedure ClientGetGABoardRead(body: string);
    procedure ClientGetSendMakeDrugList(merchant: integer; body: string);
    procedure ClientGetSendMakeItemList(merchant: integer; body: string);
    procedure ClientGetSendUserSell(merchant: integer);
    procedure ClientGetSendUserRepair(merchant: integer);
    procedure ClientGetSendUserStorage(merchant: integer);
    procedure ClientGetSendUserMaketSell(merchant: integer);
    procedure ClientGetSaveItemList(merchant, currentpage, maxpage: integer;
      bodystr: string);
    procedure ClientGetSendDetailGoodsList(merchant, Count, topline: integer;
      bodystr: string);
    procedure ClientGetSendNotice(body: string);
    procedure ClientGetGroupMembers(bodystr: string);
    procedure ClientGetOpenGuildDlg(bodystr: string);
    procedure ClientGetSendGuildMemberList(body: string);
    procedure ClientGetDealRemoteAddItem(body: string);
    procedure ClientGetDealRemoteDelItem(body: string);
    procedure ClientGetReadMiniMap(mapindex: integer);
    procedure ClientGetChangeGuildName(body: string);
    procedure ClientGetSendUserState(body: string);
    // 2003/04/15 친구, 쪽지
    procedure ClientGetUserInfo(msg: TDefaultMessage; body: string);
    procedure ClientGetDelFriend(msg: TDefaultMessage; body: string);
    procedure ClientGetFriendInfo(msg: TDefaultMessage; body: string);
    procedure ClientGetFriendResult(msg: TDefaultMessage; body: string);
    procedure ClientGetTagAlarm(msg: TDefaultMessage; body: string);
    procedure ClientGetTagList(msg: TDefaultMessage; body: string);
    procedure ClientGetTagInfo(msg: TDefaultMessage; body: string);
    procedure ClientGetTagRejectList(msg: TDefaultMessage; body: string);
    procedure ClientGetTagRejectAdd(msg: TDefaultMessage; body: string);
    procedure ClientGetTagRejectDelete(msg: TDefaultMessage; body: string);
    procedure ClientGetTagResult(msg: TDefaultMessage; body: string);
    procedure ClientFriendSort(var datalist: TList; firstname: string);

    //2003/007/08 연인사제
    procedure ClientGetLMList(msg: TDefaultMessage; body: string);
    procedure ClientGetLMOptionChange(msg: TDefaultMessage);
    procedure ClientGetLMRequest(msg: TDefaultMessage; body: string);
    procedure ClientGetLMResult(msg: TDefaultMessage; body: string);
    procedure ClientGetLMDelete(msg: TDefaultMessage; body: string);

    procedure RecalcNotReadCount;
    procedure RecalcOnlinUserCount;

    // 20003-09-05 Encrypt LoginId,PasswordmCharName
    function GetLoginId: string;
    procedure SetLogId(id: string);
    function GetLoginPasswd: string;
    procedure SetLoginPasswd(pw: string);
    function GetCharName: string;
    procedure SetCharName(Name: string);

  public
    Certification:   integer;
    ActionLock:      boolean;
    SpeedHackTimer:  TTimer;
    FindWHHackTimer: TTimer;
    RunEffectTimer:  TTimer;
    WhisperName:     string;

    // 20003-09-05 Encrypt LoginId,PasswordmCharName
    EncLoginId, EncLoginPasswd, EncCharName: string;
    EncEncLoginID: string;
    FLoginIDLock:  boolean;

    property LoginId: string Read GetLoginId Write SetLogId;
    property LoginPasswd: string Read GetLoginPasswd Write SetLoginPasswd;
    property CharName: string Read GetCharName Write SetCharName;

    //MainSurface: TDirectDrawSurface;
    function GetObjs(wunit, idx: integer): TDirectDrawSurface;
    function GetObjsEx(wunit, idx: integer; var px, py: integer): TDirectDrawSurface;

    procedure InitializeClient;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;

    procedure AppLogout;
    procedure AppExit;
    procedure PrintScreenNow;
    procedure EatItem(idx: integer);

    procedure SendClientMessage(msg, Recog, param, tag, series: integer);
    procedure SendClientMessage2(msg, Recog, param, tag, series: integer; str: string);
    procedure SendVersionNumber;
    procedure SendLogin(uid, passwd: string);
    procedure SendNewAccount(ue: TUserEntryInfo; ua: TUserEntryAddInfo);
    procedure SendUpdateAccount(ue: TUserEntryInfo; ua: TUserEntryAddInfo);
    procedure SendSelectServer(svname: string);
    procedure SendChgPw(id, passwd, newpasswd: string);
    procedure SendNewChr(uid, uname, shair, sjob, ssex: string);
    procedure SendQueryChr;
    procedure SendDelChr(chrname: string);
    procedure SendSelChr(chrname: string);
    procedure SendRunLogin;
    procedure SendSay(str: string);
    procedure SendActMsg(ident, x, y, dir: integer);
    procedure SendSpellMsg(ident, x, y, dir, target: integer);
    procedure SendQueryUserName(targetid, x, y: integer);
    procedure SendDropItem(Name: string; itemserverindex: integer);
    procedure SendDropCountItem(iname: string; mindex, icount: integer);// 겹치기
    procedure SendPickup;
    procedure SendTakeOnItem(where: byte; itmindex: integer; itmname: string);
    procedure SendTakeOffItem(where: byte; itmindex: integer; itmname: string);
    procedure SendEat(itmindex: integer; itmname: string);
    procedure UpgradeItem(ItemIndex, jewelIndex: integer; StrItem, StrJewel: string);
    procedure SendItemSumCount(OrgItemIndex, ExItemIndex: integer;
      StrOrgItem, StrExItem: string);
    procedure UpgradeItemResult(ItemIndex: integer; wResult: word; str: string);
    procedure SendButchAnimal(x, y, dir, actorid: integer);
    procedure SendMagicKeyChange(magid: integer; keych: char);
    procedure SendMerchantDlgSelect(merchant: integer; rstr: string);
    procedure SendQueryPrice(merchant, ItemIndex: integer; itemname: string);
    procedure SendQueryRepairCost(merchant, ItemIndex: integer; itemname: string);
    procedure SendSellItem(merchant, ItemIndex: integer; itemname: string; Count: word);
    procedure SendRepairItem(merchant, ItemIndex: integer; itemname: string);
    procedure SendStorageItem(merchant, ItemIndex: integer; itemname: string;
      Count: word);
    procedure SendMaketSellItem(merchant, ItemIndex: integer;
      price: string; Count: word);
    procedure SendGetDetailItem(merchant, menuindex: integer; itemname: string);
    procedure SendGetJangwonList(Page: integer);
    procedure SendGABoardRead(Body: string);
    procedure SendGetMarketPageList(merchant, pagetype: integer; itemname: string);
    procedure SendBuyMarket(merchant, sellindex: integer);
    procedure SendCancelMarket(merchant, sellindex: integer);
    procedure SendGetPayMarket(merchant, sellindex: integer);
    procedure SendMarketClose;
    procedure SendBuyItem(merchant, itemserverindex: integer;
      itemname: string; Count: word);
    procedure SendBuyDecoItem(merchant, DecoItemNum: integer);
    procedure SendTakeBackStorageItem(merchant, itemserverindex: integer;
      itemname: string; Count: word);
    procedure SendMakeDrugItem(merchant: integer; itemname: string);
    procedure SendMakeItemSel(merchant: integer; itemname: string);
    procedure SendMakeItem(merchant: integer; Data: string);
    procedure SendDropGold(dropgold: integer);
    procedure SendGroupMode(onoff: boolean);
    procedure SendCreateGroup(withwho: string);
    procedure SendWantMiniMap;
    procedure SendDealTry; //앞에 사람이 있는지 검사
    procedure SendGuildDlg;
    procedure SendCancelDeal;
    procedure SendAddDealItem(ci: TClientItem);
    procedure SendDelDealItem(ci: TClientItem);
    procedure SendChangeDealGold(gold: integer);
    procedure SendDealEnd;
    procedure SendAddGroupMember(withwho: string);
    procedure SendDelGroupMember(withwho: string);
    procedure SendGuildHome;
    procedure SendGuildMemberList;
    procedure SendGuildAddMem(who: string);
    procedure SendGuildDelMem(who: string);
    procedure SendGuildUpdateNotice(notices: string);
    procedure SendGABoardUpdateNotice(notice, CurPage: integer; bodyText: string);
    procedure SendGABoardModify(CurPage: integer; bodyText: string);
    procedure SendGABoardDel(CurPage: integer; bodyText: string);
    procedure SendGABoardNoticeCheck;
    procedure SendGetGABoardList(Page: integer);
    procedure SendGuildUpdateGrade(rankinfo: string);
    procedure SendSpeedHackUser(code: integer); //SpeedHaker 사용자를 서버에 통보한다.
    procedure SendAdjustBonus(remain: integer; babil: TNakedAbility);
    procedure UseNormalEffect(effnum, effx, effy: integer);
    procedure UseLoopNormalEffect(ActorID: integer; EffectIndex, LoopTime: word);
    procedure AttackTarget(target: TActor);
    // 2003/04/15 친구, 쪽지
    procedure SendAddFriend(Data: string; FriendType: integer);
    procedure SendDelFriend(Data: string);
    procedure SendMail(Data: string);
    procedure SendReadingMail(Data: string);
    procedure SendDelMail(Data: string);
    procedure SendLockMail(Data: string);
    procedure SendUnLockMail(Data: string);
    procedure SendMailList;
    procedure SendRejectList;
    procedure SendUpdateFriend(Data: string);
    procedure SendAddReject(Data: string);
    procedure SendDelREject(Data: string);

    // 연인사제
    procedure SendLMOPtionChange(OptionType: integer; Enable: integer);
    procedure SendLMRequest(ReqType: integer; ReqSeq: integer);
    procedure SendLMSeparate(ReqType: integer; Data: string);
    // 내가 등록하고 있는 친구인가 검사
    function IsMyMember(Name: string): boolean;

    function TargetInSwordLongAttackRange(ndir: integer): boolean;
    function TargetInSwordWideAttackRange(ndir: integer): boolean;
    // 2003/03/15 신규무공
    function TargetInSwordCrossAttackRange(ndir: integer): boolean;
    procedure OnProgramException(Sender: TObject; E: Exception);
    procedure SendSocket(sendstr: string);
    function ServerAcceptNextAction: boolean;
    function CanNextAction: boolean;
    function CanNextHit: boolean;
    function IsUnLockAction(action, adir: integer): boolean;
    procedure ActiveCmdTimer(cmd: TTimerCommand);
    function IsGroupMember(uname: string): boolean;
  end;

procedure DecodeLicenseStrings(strlist: TStringList);
function CheckMirProgram: boolean;
procedure PomiTextOut(dsurface: TDirectDrawSurface; x, y: integer; str: string);
procedure WaitAndPass(msec: longword);
function GetRGB(c256: byte): integer;
procedure DebugOutStr(msg: string);
procedure ChangeWalkHitValues(level, speed, weightsum, rundelay: integer);
procedure TogglePlaySoundEffect;

function NPGameMonCallback(dwMsg: DWORD; dwArg: DWORD): boolean cdecl;

var
  FrmMain:    TFrmMain;
  DScreen:    TDrawScreen;
  IntroScene: TIntroScene;
  LoginScene: TLoginScene;
  SelectChrScene: TSelectChrScene;
  PlayScene:  TPlayScene;
  LoginNoticeScene: TLoginNotice;
  DropedItemList: TList;
  Sound:      TSoundEngine;
  ChangeFaceReadyList: TList;
  TerminateNow: boolean;
  // 2003/02/11 미니맵상에 출력될 케릭들, 화면상에 열린 윈도우들 리스트 추가
  ViewList:   array[1..MAXVIEWOBJECT] of TMiniViewObject;
  ViewListCount: integer;

  MainParam1, MainParam2, MainParam3, MainParam4, MainParam5, MainParam6: string;

  SoundList:     TStringList;
  //DObjList: TList;  //바닥에 변경된 지형의 표현
  EventMan:      TClEventManager;
  ServerCount:   integer;
  ServerCaptionArr: array[0..31] of string;
  ServerNameArr: array[0..31] of string;

  KornetWorld: TKornetWorld;

  ServerName: string;
  MapTitle: string;
  GuildName: string;      //소속문파의 이름
  GuildRankName: string;  //문파에서의 직책이름
  Map:      TMap;
  MySelf:   THumActor;
  MyDrawActor: THumActor;
  // 2003/03/15 아이템 인벤토리 확장
  UseItems: array[0..12] of TClientItem;       //8->12
  ItemArr:  array[0..MAXBAGITEMCL - 1] of TClientItem;
  DealItems: array[0..9] of TClientItem;
  MakeItemArr: array[0..5] of TClientItem;
  DealRemoteItems: array[0..19] of TClientItem;
  SaveItemList: TList;
  MenuItemList: TList;
  DealGold, DealRemoteGold: integer;
  BoDealEnd: boolean;
  DealWho:  string; //거래하는 상대편
  MagicList: TList;
  MouseItem, MouseStateItem, MouseUserStateItem: TClientItem;
  //현재 마우스가 가리키고 있는 아이템
  FreeActorList: TList;
  BoServerChanging: boolean;
  BoBagLoaded: boolean;
  BoOneTimePassword: boolean;

  FirstServerTime: longword;
  FirstClientTime: longword;
  //ServerTimeGap: int64;
  TimeFakeDetectCount: integer;
  MainAniCount:  integer;
  ClientVersion: integer;

  FirstServerTimeChina: longword;
  FirstClientTimeChina: longword;
  TimeFakeDetectCountChina: integer;
  checkfaketime:     longword;
  checkchecksumtime: longword;

  SHGetTime:   longword;
  SHTimerTime: longword;
  SHFakeCount: integer;
  SHHitSpeedCount: integer;

  LatestClientTime2:     longword;
  FirstClientTimerTime:  longword; //timer 시간
  LatestClientTimerTime: longword;
  FirstClientGetTime:    longword; //gettickcount 시간
  LatestClientGetTime:   longword;
  TimeFakeDetectSum:     integer;
  TimeFakeDetectTimer:   integer;

  BonusPoint, SaveBonusPoint: integer;
  BonusTick:    TNakedAbility;
  BonusAbil:    TNakedAbility;
  NakedAbil:    TNakedAbility;
  BonusAbilChg: TNakedAbility;

  SellDlgItem:    TClientItem;
  SellDlgItemSellWait: TClientItem;
  DealDlgItem:    TClientItem;
  MakingDlgItem:  TClientItem;
  BoQueryPrice:   boolean;
  QueryPriceTime: longword;
  SellPriceStr:   string;

  BoOneClick:   boolean;
  OneClickMode: TOneClickMode;

  BoFirstTime: boolean;
  ConnectionStep: TConnectionStep;
  BoWellLogin: boolean;
  ServerConnected: boolean;
  ViewFog:   boolean;
  DayBright: integer;
  AreaStateValue: integer;
  MyHungryState: integer;
  BoPlaySoundEffect: boolean;


  LastAttackTime: longword;  //최근의공격 시간, 공격도중 클릭실수로 이동하는 것을 막음
  LastMoveTime: longword;
  ItemMoving: boolean;
  MovingItem: TMovingItem;
  DelTempItem: TClientItem;
  UpItemItem: TClientItem;
  WaitingUseItem: TMovingItem;
  EatingItem: TClientItem;
  EatTime: longword; //timeout...

  LatestStruckTime:   longword;
  LatestSpellTime:    longword;
  LatestFireHitTime:  longword;
  LatestRushRushTime: longword;
  LatestHitTime:      longword;   //남을 공격하고 접속을 종료 못하게
  LatestMagicTime:    longword;   //마법을 사용하고 접속을 종료 못하게
  DizzyDelayStart:    longword;
  DizzyDelayTime:     integer;

  DoFadeOut:     boolean;
  DoFadeIn:      boolean;
  FadeIndex:     integer;
  DoFastFadeOut: boolean;

  // 2003/07/15 신규무공 추가
  BoStopAfterAttack: boolean;
  BoAttackSlow:  boolean; //무게 초과로 공격을 느리게 한다.
  BoMoveSlow, BoMoveSlow2: boolean;
  //너무 많이 들었거나, 무거운 옷을 입어서 움직임이 둔해진다.
  MoveSlowLevel: integer;
  MoveSlowValue: integer;
  MapMoving:     boolean; //맵 이동중, 풀릴때까지 이동 안됨
  MapMovingWait: boolean;
  //  CheckBadMapMode: Boolean;
  BoCheckSpeedHackDisplay: boolean;
  BoWantMiniMap: boolean;
  ViewMiniMapStyle: integer; //0:안보임  1: 반투명  2: 직접
  PrevVMMStyle:  integer;
  MiniMapIndex:  integer;

  MCX: integer; //마우스가 가리키는 cell 위치
  MCY: integer;
  MouseX, MouseY: integer; //마우스가 가리키는 스크린 좌표

  TargetX:    integer;  //가고자 하는 목적지
  TargetY:    integer;
  TargetCret, FocusCret: TActor;
  MagicTarget, AutoTarget: TActor;
  TargetCase: byte;
  BoAutoDig:  boolean;
  BoSelectMyself: boolean;
  FocusItem:  PTDropItem;
  MagicDelayTime: longword;
  MagicPKDelayTime: longword;
  ChrAction:  TChrAction;
  NoDarkness: boolean;
  RunReadyCount: integer; //3발 이상 걷다가 뛴다.

  SoftClosed:     boolean;
  SelChrAddr:     string;
  SelChrPort:     integer;
  ImgMixSurface:  TDirectDrawSurface;
  ImgLargeMixSurface: TDirectDrawSurface;
  MiniMapSurface: TDirectDrawSurface;

  CurMerchant:    integer;   //최근에 메뉴를 보낸 상인
  MDlgX, MDlgY:   integer;   //메뉴를 받은 곳
  changegroupmodetime: longword;
  dealactiontime: longword;
  querymsgtime:   longword;
  DupSelection:   integer;

  MsgYesIagree: string;
  MsgNoImnot:   string;

  AllowGroup:    boolean;
  GroupMembers:  TStringList;
  GroupIdList:   TList; // MonOpenHp
  // 2003/04/15 친구, 쪽지
  FriendMembers: TList;
  BlackMembers:  TList;
  MailLists:     TList;
  BlockLists:    TStringList;
  MailAlarm:     boolean;
  WantMailList:  boolean;
  ConnectFriend: integer;
  ConnectBlack:  integer;
  NotReadMailCount: integer;

  // 2003/07/08 연인사제
  fLover: TRelationShipMgr;

  MySpeedPoint, MyHitPoint, MyAntiPoison, MyPoisonRecover, MyHealthRecover,
  MySpellRecover, MyAntiMagic: integer;

  AvailIDDay, AvailIDHour: word;
  AvailIPDay, AvailIPHour: word;


  CaptureSerial: integer;
  SendCount, ReceiveCount: integer;
  TestSendCount, TestReceiveCount: integer;
  SpellCount, SpellFailCount, FireCount: integer;
  DebugCount, DebugCount1, DebugCount2: integer;

  LastestClientGetTime: longword;
  ToolMenuHook:    HHOOK;
  LastHookKey:     integer;
  LastHookKeyTime: longword;

  BoNextTimePowerHit: boolean;
  BoCanLongHit:      boolean;
  BoCanWideHit:      boolean;
  // 2003/03/15 신규무공
  BoCanCrossHit:     boolean;
  BoCanTwinHit:      boolean;
  BoNextTimeFireHit: boolean;
  BoCanStoneHit:     boolean;

  //Assassin Magics
  BoNextTimeslashhit: boolean; //Slash
  BoCanWideHit2:      boolean; //Skill 2


  WalkCheckSum_fake1: integer;
  WalkCheckSum_fake2: integer;
  WalkCheckSum_fake3: integer;

  WalkCheckSum1: integer;
  HitCheckSum1:  integer;

  HitCheckSum_fake1: integer;
  HitCheckSum_fake2: integer;
  HitCheckSum_fake3: integer;

  pWalkCheckSum2: ^integer;
  pHitCheckSum2:  ^integer;

  pWalkCheckSum3: ^integer;
  pHitCheckSum3:  ^integer;

  DayBright_fake: integer;
  DarkLevel_fake: integer;

  pDayBrightCheck: ^integer;
  pDarkLevelCheck: ^integer;

  pLocalFileCheckSum: ^integer;
  pClientCheckSum1:   ^integer;
  pClientCheckSum2:   ^integer;
  pClientCheckSum3:   ^integer;

  BoSendFileCheckSum: boolean;

  EffectNum: byte;

  BoMsgDlgTimeCheck: boolean;
  MsgDlgMaxStr:      byte;
  SpeedHackUse:      boolean;

  TabClickTime: longword;

  GameClose: boolean;

 //DebugColor1, DebugColor2, DebugColor3, DebugColor4: byte;
 //BoDebugColorChanged: Boolean;

implementation

uses FState;

{$R *.DFM}


procedure DecodeLicenseStrings(strlist: TStringList);
var
  i:   integer;
  str: string;
begin
  for i := 0 to strlist.Count - 1 do begin
    str := strlist[i];
    strlist[i] := DecodeString(str);
  end;
end;


procedure ChangeWalkHitValues(level, speed, weightsum, rundelay: integer);
begin
  WalkCheckSum_fake1 := 10 + Random(1000);
  WalkCheckSum_fake2 := 100 + Random(1000);
  WalkCheckSum_fake3 := 1000 + Random(1000);
  WalkCheckSum1      := Random(100);
  pWalkCheckSum2^    := Random(10000);
  pWalkCheckSum3^    := Random(10000);



  HitCheckSum_fake1 := 10 + Random(1000);
  HitCheckSum_fake2 := 100 + Random(1000);
  HitCheckSum_fake3 := 1000 + Random(1000);

  HitCheckSum1 := level * HIT_INCLEVEL + abs(speed) * HIT_INCSPEED +
    weightsum + rundelay;

  pHitCheckSum2^ := (HitCheckSum1 * 4) xor $FFFFFFFF;
  pHitCheckSum3^ := (HitCheckSum1 * 20) xor $FFFFFFFF;
end;

function CheckMirProgram: boolean;
var
  pstr, cstr:   array[0..255] of char;
  mirapphandle: HWnd;
begin
  Result := False;
  StrPCopy(pstr, 'legend of mir2');
  mirapphandle := FindWindow(nil, pstr);
  if (mirapphandle <> 0) and (mirapphandle <> Application.Handle) then begin
    if not BoCompileMode then begin
      SetActiveWindow(mirapphandle);
      Result := True;
    end;
    exit;
  end;
end;

procedure PomiTextOut(dsurface: TDirectDrawSurface; x, y: integer; str: string);
var
  i, n: integer;
  d:    TDirectDrawSurface;
begin
  for i := 1 to Length(str) do begin
    n := byte(str[i]) - byte('0');
    if n in [0..9] then begin //숫자만 됨
      d := FrmMain.WProgUse.Images[30 + n];
      if d <> nil then
        dsurface.Draw(x + i * 8, y, d.ClientRect, d, True);
    end else begin
      if str[i] = '-' then begin
        d := FrmMain.WProgUse.Images[40];
        if d <> nil then
          dsurface.Draw(x + i * 8, y, d.ClientRect, d, True);
      end;
    end;
  end;
end;

procedure WaitAndPass(msec: longword);
var
  start: longword;
begin
  start := GetTickCount;
  while GetTickCount - start < msec do begin
    Application.ProcessMessages;
  end;
end;

function GetRGB(c256: byte): integer;
var
  i: integer;
begin
  Result := RGB(FrmMain.DxDraw1.DefColorTable[c256].rgbRed,
    FrmMain.DxDraw1.DefColorTable[c256].rgbGreen,
    FrmMain.DxDraw1.DefColorTable[c256].rgbBlue);
end;

procedure DebugOutStr(msg: string);
var
  flname:  string;
  fhandle: TextFile;
begin
  exit;
  flname := '.\!debug.txt';
  if FileExists(flname) then begin
    AssignFile(fhandle, flname);
    Append(fhandle);
  end else begin
    AssignFile(fhandle, flname);
    Rewrite(fhandle);
  end;
  WriteLn(fhandle, TimeToStr(Time) + ' ' + msg);
  CloseFile(fhandle);
end;

function KeyboardHookProc(Code: integer; WParam: longint; var Msg: TMsg): longint;
  stdcall;
begin
  Result := 0;
  if ((WParam = 9){ or (WParam = 13)}) and (LastHookKey = 18) and
    (GetTickCount - LastHookKeyTime < 500) then begin
    if FrmMain.WindowState <> wsMinimized then begin
      FrmMain.WindowState := wsMinimized;
    end else
      Result := CallNextHookEx(ToolMenuHook, Code, WParam, longint(@Msg));
    exit;
  end;
  LastHookKey     := WParam;
  LastHookKeyTime := GetTickCount;

  Result := CallNextHookEx(ToolMenuHook, Code, WParam, longint(@Msg));
end;

procedure TogglePlaySoundEffect;
begin
  BoPlaySoundEffect := not BoPlaySoundEffect;
  if BoPlaySoundEffect then
    DScreen.AddChatBoardString('[SoundEffect On]', clWhite, clBlack)
  else
    DScreen.AddChatBoardString('[SoundEffect Off]', clWhite, clBlack);
end;


//--------------------------------------------------------------------------------------

// 20003-09-05 Encrypt LoginId,PasswordmCharName
function TFrmMain.GetLoginId: string;
begin
  Result := DecodeString(EncLoginId);
end;

procedure TFrmMain.SetLogId(id: string);
begin
  if FLoginIDLock = False then begin
    EncLoginId    := EncodeString(id);
    EncEncLoginId := EncodeString(EncLoginId);
  end;
end;

function TFrmMain.GetLoginPasswd: string;
begin
  Result := DecodeString(EncLoginPasswd);
end;

procedure TFrmMain.SetLoginPasswd(pw: string);
begin
  if FLoginIDLock = False then begin
    EncLoginPasswd := EncodeString(pw);
  end;
end;

function TFrmMain.GetCharName: string;
begin
  Result := DecodeString(EncCharName);
end;

procedure TFrmMain.SetCharName(Name: string);
begin
  EncCharName := EncodeString(Name);
end;


procedure TFrmMain.FormCreate(Sender: TObject);
var
  flname, str: string;
  ini:   TIniFile;
  i:     integer;
  compo: TComponent;
  // 2003/04/15
  fr:    PTFriend;
  ma:    PTMail;
begin
  Randomize;

  new(pWalkCheckSum2);
  new(pHitCheckSum2);
  new(pWalkCheckSum3);
  new(pHitCheckSum3);

  new(pDayBrightCheck);
  new(pDarkLevelCheck);
  new(pLocalFileCheckSum);
  new(pClientCheckSum1);
  new(pClientCheckSum2);
  new(pClientCheckSum3);

  ini := TIniFile.Create('.\Mir2.ini');
  if ini <> nil then begin
    SERVERADDR := ini.ReadString('Setup', 'ServerAddr', SERVERADDR);
    if not KoreanVersion then begin
      LocalLanguage := imOpen;
    end;
    ScreenMode   := ini.ReadBool('Setup', 'ScreenMode', ScreenMode);
    CurFontName  := ini.ReadString('Setup', 'FontName', CurFontName);
    MsgYesIagree := ini.ReadString('Setup', 'Message1', '');
    MsgNoImnot   := ini.ReadString('Setup', 'Message2', '');

    ServerCount := _MIN(32, ini.ReadInteger('Server', 'ServerCount', 1));
    for i := 0 to ServerCount - 1 do begin
      str := 'Server' + IntToStr(i + 1) + 'Caption';
      ServerCaptionArr[i] := ini.ReadString('Server', str, '');
      str := 'Server' + IntToStr(i + 1) + 'Name';
      ServerNameArr[i] := ini.ReadString('Server', str, '');
    end;
    ini.Free;
  end;

{
   //사운드 관련 초기화
   if DxSound.Initialized then begin
      Sound := TSoundEngine.Create (DxSound.DSound);
   end else begin
      Sound := nil;
   end;

}

  for i := 0 to ComponentCount - 1 do begin  //Wil 파일의 나라별 버전 정보 입력
    compo := Components[i];
    if compo is TWMImages then begin
      if KoreanVersion then
        TWMImages(compo).InternationalVersion := ivKorean;
      if EnglishVersion then
        TWMImages(compo).InternationalVersion := ivEnglish;
      if ChinaVersion then
        TWMImages(compo).InternationalVersion := ivChinesse;
      if TaiwanVersion then
        TWMImages(compo).InternationalVersion := ivTaiwan;

    end;
  end;


  ToolMenuHook := SetWindowsHookEx(WH_KEYBOARD, @KeyboardHookProc,
    0, GetCurrentThreadID);

  ClientVersion := VERSION_YEAR * 10000 + VERSION_MON * 100 + VERSION_DAY;

  SoundList := TStringList.Create;
  flname    := '.\wav\mirsound.lst';
  LoadSoundList(flname);
  //if FileExists (flname) then
  //   SoundList.LoadFromFile (flname);

  DScreen    := TDrawScreen.Create;
  IntroScene := TIntroScene.Create;
  LoginScene := TLoginScene.Create;
  SelectChrScene := TSelectChrScene.Create;
  PlayScene  := TPlayScene.Create;
  LoginNoticeScene := TLoginNotice.Create;

  Map      := TMap.Create;
  DropedItemList := TList.Create;
  MagicList := TList.Create;
  FreeActorList := TList.Create;
  //DObjList := TList.Create;
  EventMan := TClEventManager.Create;
  ChangeFaceReadyList := TList.Create;
  // 2003/02/11
  ViewListCount := 0;
  FillChar(ViewList, sizeof(TMiniViewObject) * MAXVIEWOBJECT, #0);


  Myself := nil;
  // 2003/03/15 아이템 인벤토리 확장
  FillChar(UseItems, sizeof(TClientItem) * 13, #0);            //9->13
  FillChar(ItemArr, sizeof(TClientItem) * MAXBAGITEMCL, #0);
  FillChar(DealItems, sizeof(TClientItem) * 10, #0);
  FillChar(DealRemoteItems, sizeof(TClientItem) * 20, #0);
  SaveItemList      := TList.Create;
  MenuItemList      := TList.Create;
  WaitingUseItem.Item.S.Name := '';  //착용창 서버와 통신간에 임시저장
  EatingItem.S.Name := '';

  TargetX     := -1;
  TargetY     := -1;
  TargetCret  := nil;
  FocusCret   := nil;
  FocusItem   := nil;
  MagicTarget := nil;
  AutoTarget  := nil;
  TargetCase  := 1; // AutoTarget

  DebugCount    := 0;
  DebugCount1   := 0;
  DebugCount2   := 0;
  TestSendCount := 0;
  TestReceiveCount := 0;
  BoServerChanging := False;
  BoBagLoaded   := False;
  BoAutoDig     := False;

  LatestClientTime2    := 0;
  FirstClientTime      := 0;
  FirstServerTime      := 0;
  FirstClientTimerTime := 0;
  LatestClientTimerTime := 0;
  FirstClientGetTime   := 0;
  LatestClientGetTime  := 0;

  TimeFakeDetectCount := 0;
  TimeFakeDetectTimer := 0;
  TimeFakeDetectSum   := 0;
  TimeFakeDetectCountChina := 0;

  SHGetTime   := 0;
  SHTimerTime := 0;
  SHFakeCount := 0;
  SHHitSpeedCount := 0;

  DayBright := 3; //밤
  DayBright_fake := DayBright;
  pDayBrightCheck^ := DayBright;
  ViewFog   := True;
  DarkLevel := 0;
  DarkLevel_fake := DarkLevel;
  pDarkLevelCheck^ := DarkLevel;

  AreaStateValue := 0;
  ConnectionStep := cnsLogin;
  BoWellLogin := False;
  ServerConnected := False;
  SocStr     := '';
  WarningLevel := 0;  //불량패킷 수신 횟수 (패킷복사 가능성 있음)
  ActionFailLock := False;
  MapMoving  := False;
  MapMovingWait := False;
  //   CheckBadMapMode := FALSE;
  BoCheckSpeedHackDisplay := False;
  //BoViewMiniMap := FALSE;
  BoWantMiniMap := False;
  ViewMiniMapStyle := 0;  //0: 안보임, 1: 반투명, 2: 직접
  PrevVMMStyle := 1;
  FailDir    := 0;
  FailAction := 0;
  FailActionTime := GetTickCount;
  DupSelection := 0;

  LastAttackTime  := GetTickCount;
  LastMoveTime    := GetTickCount;
  LatestSpellTime := GetTickCount;
  TabClickTime    := GetTickCount;

  BoFirstTime   := True;
  ItemMoving    := False;
  DoFadeIn      := False;
  DoFadeOut     := False;
  DoFastFadeOut := False;
  BoAttackSlow  := False;
  // 2003/07/15 신규무공 추가
  BoStopAfterAttack := False;

  BoMoveSlow  := False;
  BoMoveSlow2 := False;
  BoNextTimePowerHit := False;
  BoNextTimeslashhit := False;

  BoCanLongHit  := False;
  BoCanWideHit  := False;
  BoCanWideHit2 := False;
  BoCanCrossHit := False;
  BoCanTwinHit  := False;

  BoNextTimeFireHit := False;

  BoPlaySoundEffect := True;

  NoDarkness   := False;
  SoftClosed   := False;
  BoQueryPrice := False;
  SellPriceStr := '';

  AllowGroup    := False;
  GroupMembers  := TStringList.Create;
  GroupIdList   := TList.Create; // MonOpenHp
  // 2003/04/15 친구, 쪽지
  FriendMembers := TList.Create;
  BlackMembers  := TList.Create;
  MailLists     := TList.Create;
  BlockLists    := TStringList.Create;
  MailAlarm     := False;
  WantMailList  := False;

  // 2003/07/08 연인사제
  fLover := TRelationShipMgr.Create;

  MainWinHandle := DxDraw1.Handle;

  //원클릭, 코넷월드 등..
  BoOneClick   := False;
  OneClickMode := toNone;

  CSocket.Active := False;
  CSocket.Port   := 7000;
  if MainParam1 = '' then
    CSocket.Address := SERVERADDR
  else begin
    if (MainParam1 <> '') and (MainParam2 = '') then  //파라메터 1개
      CSocket.Address := MainParam1;
    if (MainParam2 <> '') and (MainParam3 = '') then begin  //파라메터 2개 인경우
      CSocket.Address := MainParam1;
      CSocket.Port    := Str_ToInt(MainParam2, 0);
    end;
    if (MainParam3 <> '') then begin  //파라메터 3개인경우, 통합 접속
      if CompareText(MainParam1, '/KWG') = 0 then begin
        //코넷 월드 용
        CSocket.Address := kornetworldaddress;  //game.megapass.net';
        CSocket.Port    := 9000;
        BoOneClick      := True;
        OneClickMode    := toKornetWorld;
        with KornetWorld do begin
          CPIPcode := MainParam2;
          SVCcode  := MainParam3;
          LoginID  := MainParam4;
          CheckSum := MainParam5; //'dkskxhdkslxlkdkdsaaaasa';
        end;
      end else begin
        //일반 원클릭 통합 게이트용
        CSocket.Address := MainParam2;
        CSocket.Port    := Str_ToInt(MainParam3, 0);
        BoOneClick      := True;
      end;
    end;
  end;
  if BO_FOR_TEST then
    CSocket.Address := TESTSERVERADDR;

  SpeedHackTimer := TTimer.Create(self);
  SpeedHackTimer.Interval := 250;
  SpeedHackTimer.Enabled := True;
  SpeedHackTimer.OnTimer := SpeedHackTimerTimer;

  FindWHHackTimer := TTimer.Create(self);
  FindWHHackTimer.Interval := 5000;
  FindWHHackTimer.Enabled := True;
  FindWHHackTimer.OnTimer := FindWHHackTimerTimer;

  RunEffectTimer     := TTimer.Create(self); // 용던젼 낙뢰의길, 용암의길
  RunEffectTimer.Interval := 400;
  RunEffectTimer.Enabled := False;
  RunEffectTimer.OnTimer := RunEffectTimerTimer;
  RunEffectTimer.Tag := 555;

  // MainSurface := nil;
  pLocalFileCheckSum^ := CalcFileCheckSum(ParamStr(0));
  BoSendFileCheckSum  := False;

  // 말입력이 된시간 
  //   FSayTime := 0;
  //DebugColor1 := 0;
  //DebugColor2 := 0;
  //DebugColor3 := 0;
  //DebugColor4 := 0;
  EffectNum := 0; // FireDragon

  EncLoginId     := '';
  EncLoginPasswd := '';
  EncCharName    := '';
  FLoginIDLock   := False;

  //위탁상점
  g_Market := TMarketItemManager.Create;

  BoMsgDlgTimeCheck := False;
  MsgDlgMaxStr := 30;
  SpeedHackUse := False;
  GameClose := False;
end;

procedure TFrmMain.InitializeClient;
begin
  if TerminateNow then begin
    FrmMain.Close;
    exit;
  end;

  if not BoDebugModeScreen then begin
    if not (doFullScreen in DxDraw1.Options) then
      DxDraw1.Options := DxDraw1.Options + [doFullScreen];
  end;

  if ScreenMode then begin
    FrmMain.BorderIcons := FrmMain.BorderIcons - [biMaximize];
    FrmMain.BorderStyle := bsSingle;
    
    DxDraw1.Options := DxDraw1.Options - [doFullScreen];
    //DxDraw1.Options := DxDraw1.Options + [doNoWindowChange];
  end;
{
   else
       DxDraw1.Options := DxDraw1.Options - [doFullScreen];
}

  DxDraw1.AutoInitialize := True;  //Initialize;
  //   DxDraw1.Initialize;

  //사운드 관련 초기화
  if DxSound.Initialized then begin
    Sound := TSoundEngine.Create(DxSound.DSound);
  end else begin
    Sound := nil;
  end;

  cSocket.Active := True;

  DebugOutStr('----------------------- started ------------------------');

  Application.OnException := OnProgramException;
end;

procedure TFrmMain.OnProgramException(Sender: TObject; E: Exception);
begin
  DebugOutStr(E.Message);
end;

procedure TFrmMain.WMSysCommand(var Message: TWMSysCommand);
begin
{   with Message do begin
      if (CmdType and $FFF0) = SC_KEYMENU then begin
         if (Key = VK_TAB) or (Key = VK_RETURN) then begin
            FrmMain.WindowState := wsMinimized;
         end else
            inherited;
      end else
         inherited;
   end;
}
  inherited;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  if ToolMenuHook <> 0 then
    UnhookWindowsHookEx(ToolMenuHook);
  //SoundCloseProc;
  //DXTimer.Enabled := FALSE;
  Timer1.Enabled   := False;
  MinTimer.Enabled := False;

  WTiles.Finalize;
  WObjects1.Finalize;
  WObjects2.Finalize;
  WObjects3.Finalize;
  WObjects4.Finalize;
  WObjects5.Finalize;
  WObjects6.Finalize;
  WObjects7.Finalize;
  WObjects8.Finalize;
  WObjects9.Finalize;
  WObjects10.Finalize;
  WSmTiles.Finalize;
  WHumImg.Finalize;
  WHairImg.Finalize;
  WHumWing.Finalize;
  WKillerWing.Finalize;
  WWeapon.Finalize;
  WKillerWeaponL.Finalize;
  WKillerWeaponR.Finalize;
  WKillerHumImg.Finalize;
  WKillerHairImg.Finalize;
  WKillerHumImg2.Finalize;
  WHumImg2.Finalize;
  WMagic.Finalize;
  WMagic2.Finalize;
  WMagIcon.Finalize;
  WMonImg.Finalize;
  WMon2Img.Finalize;
  WMon3Img.Finalize;
  WMon4Img.Finalize;
  WMon5Img.Finalize;
  WMon6Img.Finalize;
  WMon7Img.Finalize;
  WMon8Img.Finalize;
  WMon9Img.Finalize;
  WMon10Img.Finalize;
  WMon11Img.Finalize;
  WMon12Img.Finalize;
  WMon13Img.Finalize;
  WMon14Img.Finalize;
  WMon15Img.Finalize;
  WMon16Img.Finalize;
  WMon17Img.Finalize;
  WMon18Img.Finalize;
  WMon19Img.Finalize;
  WMon20Img.Finalize;
  WMon21Img.Finalize;
  // 2003/07/15 과거 비천 추가몹
  WMon22Img.Finalize;
  // 2004/03/23 신규몬스터 추가
  WMon23Img.Finalize;
  WMon24Img.Finalize;
  WMon25Img.Finalize;
  WDragonImg.Finalize;
  WNpcImg.Finalize;
  WDecoImg.Finalize;
  WEffectImg.Finalize;
  WProgUse.Finalize;
  WProgUse2.Finalize;
  WChrSel.Finalize;
  WMMap.Finalize;
  WBagItem.Finalize;
  WStateItem.Finalize;
  WDnItem.Finalize;
  DScreen.Finalize;
  PlayScene.Finalize;
  LoginNoticeScene.Finalize;

  DScreen.Free;
  IntroScene.Free;
  LoginScene.Free;
  SelectChrScene.Free;
  PlayScene.Free;
  LoginNoticeScene.Free;
  SaveItemList.Free;
  MenuItemList.Free;

  DebugOutStr('----------------------- closed -------------------------');
  Map.Free;
  DropedItemList.Free;
  MagicList.Free;
  FreeActorList.Free;
  ChangeFaceReadyList.Free;
  //if MainSurface <> nil then MainSurface.Free;

  Sound.Free;
  SoundList.Free;
  //DObjList.Free;
  EventMan.Free;

  if RunEffectTimer <> nil then
    RunEffectTimer.Free;
  if FindWHHackTimer <> nil then
    FindWHHackTimer.Free;
  if SpeedHackTimer <> nil then
    SpeedHackTimer.Free;

  Dispose(pWalkCheckSum2);
  Dispose(pHitCheckSum2);
  Dispose(pWalkCheckSum3);
  Dispose(pHitCheckSum3);

  Dispose(pDayBrightCheck);
  Dispose(pDarkLevelCheck);
  Dispose(pLocalFileCheckSum);
  Dispose(pClientCheckSum1);
  Dispose(pClientCheckSum2);
  Dispose(pClientCheckSum3);

  GroupMembers.Free;
  GroupIdList.Free;

  FriendMembers.Free;
  BlackMembers.Free;
  MailLists.Free;
  BlockLists.Free;

  fLover.Free;

  //위탁상점
  g_Market.Free;
end;

function ComposeColor(Dest, Src: TRGBQuad; Percent: integer): TRGBQuad;
begin
  with Result do begin
    rgbRed      := Src.rgbRed + ((Dest.rgbRed - Src.rgbRed) * Percent div 256);
    rgbGreen    := Src.rgbGreen + ((Dest.rgbGreen - Src.rgbGreen) * Percent div 256);
    rgbBlue     := Src.rgbBlue + ((Dest.rgbBlue - Src.rgbBlue) * Percent div 256);
    rgbReserved := 0;
  end;
end;

procedure TFrmMain.DXDraw1Initialize(Sender: TObject);
begin
  if BoFirstTime then begin
    BoFirstTime := False;
    DxDraw1.AutoSize := True;
    DxDraw1.SurfaceWidth  := SCREENWIDTH;
    DxDraw1.SurfaceHeight := SCREENHEIGHT;

    FrmMain.Font.Name := CurFontName;
    FrmMain.Canvas.Font.Name := CurFontName;
    DxDraw1.Surface.Canvas.Font.Name := CurFontName;
    PlayScene.EdChat.Font.Name := CurFontName;
    FrmDlg.Font.Name  := CurFontName;
    FrmDlg.Canvas.Font.Name := CurFontName;

    FrmMain.Font.Size := 9;
    FrmMain.Canvas.Font.Size := 9;
    DxDraw1.Surface.Canvas.Font.Size := 9;
    PlayScene.EdChat.Font.Size := 9;
    FrmDlg.Font.Size  := 9;
    FrmDlg.Canvas.Font.Size := 9;

    //MainSurface := TDirectDrawSurface.Create (FrmMain.DXDraw1.DDraw);
    //MainSurface.SystemMemory := TRUE;
    //MainSurface.SetSize (SCREENWIDTH, SCREENHEIGHT);

    if doFullScreen in DxDraw1.Options then begin
      //Screen.Cursor := crNone;
    end else begin
      Left   := 0;
      Top    := 0;
      Width  := SCREENWIDTH;
      Height := SCREENHEIGHT;
      NoDarkness := True;
      UseDIBSurface := True;
    end;

    WTiles.DDraw     := DxDraw1.DDraw;
    WObjects1.DDraw  := DxDraw1.DDraw;
    WObjects2.DDraw  := DxDraw1.DDraw;
    WObjects3.DDraw  := DxDraw1.DDraw;
    WObjects4.DDraw  := DxDraw1.DDraw;
    WObjects5.DDraw  := DxDraw1.DDraw;
    WObjects6.DDraw  := DxDraw1.DDraw;
    WObjects7.DDraw  := DxDraw1.DDraw;
    WObjects8.DDraw  := DxDraw1.DDraw;
    WObjects9.DDraw  := DxDraw1.DDraw;
    WObjects10.DDraw := DxDraw1.DDraw;
    WSmTiles.DDraw   := DxDraw1.DDraw;
    WProgUse.DDraw   := DxDraw1.DDraw;
    WProgUse2.DDraw  := DxDraw1.DDraw;
    WChrSel.DDraw    := DxDraw1.DDraw;
    WMMap.DDraw      := DxDraw1.DDraw;
    WBagItem.DDraw   := DxDraw1.DDraw;
    WStateItem.DDraw := DxDraw1.DDraw;
    WDnItem.DDraw    := DxDraw1.DDraw;
    WHumImg.DDraw    := DxDraw1.DDraw;
    WHairImg.DDraw   := DxDraw1.DDraw;
    WHumWing.DDraw   := DxDraw1.DDraw;
    WKillerWing.DDraw   := DxDraw1.DDraw;
    WWeapon.DDraw    := DxDraw1.DDraw;
    WKillerWeaponL.DDraw    := DxDraw1.DDraw;
    WKillerWeaponR.DDraw    := DxDraw1.DDraw;
    WKillerHumImg.DDraw    := DxDraw1.DDraw;
    WKillerHairImg.DDraw    := DxDraw1.DDraw;
    WKillerHumImg2.DDraw    := DxDraw1.DDraw;
    WHumImg2.DDraw    := DxDraw1.DDraw;
    WMagic.DDraw     := DxDraw1.DDraw;
    WMagic2.DDraw    := DxDraw1.DDraw;
    WMagIcon.DDraw   := DxDraw1.DDraw;
    WMonImg.DDraw    := DxDraw1.DDraw;
    WMon2Img.DDraw   := DxDraw1.DDraw;
    WMon3Img.DDraw   := DxDraw1.DDraw;
    WMon4Img.DDraw   := DxDraw1.DDraw;
    WMon5Img.DDraw   := DxDraw1.DDraw;
    WMon6Img.DDraw   := DxDraw1.DDraw;
    WMon7Img.DDraw   := DxDraw1.DDraw;
    WMon8Img.DDraw   := DxDraw1.DDraw;
    WMon9Img.DDraw   := DxDraw1.DDraw;
    WMon10Img.DDraw  := DxDraw1.DDraw;
    WMon11Img.DDraw  := DxDraw1.DDraw;
    WMon12Img.DDraw  := DxDraw1.DDraw;
    WMon13Img.DDraw  := DxDraw1.DDraw;
    WMon14Img.DDraw  := DxDraw1.DDraw;
    WMon15Img.DDraw  := DxDraw1.DDraw;
    WMon16Img.DDraw  := DxDraw1.DDraw;
    WMon17Img.DDraw  := DxDraw1.DDraw;
    WMon18Img.DDraw  := DxDraw1.DDraw;
    WMon19Img.DDraw  := DxDraw1.DDraw;
    WMon20Img.DDraw  := DxDraw1.DDraw;
    WMon21Img.DDraw  := DxDraw1.DDraw;
    // 2003/07/15 과거 비천 추가몹
    WMon22Img.DDraw  := DxDraw1.DDraw;
    WMon23Img.DDraw  := DxDraw1.DDraw;
    WMon24Img.DDraw  := DxDraw1.DDraw;
    WMon25Img.DDraw  := DxDraw1.DDraw;
    WDragonImg.DDraw := DxDraw1.DDraw; //FireDragon
    WNpcImg.DDraw    := DxDraw1.DDraw;
    WDecoImg.DDraw   := DxDraw1.DDraw;
    WEffectImg.DDraw := DxDraw1.DDraw;
    WTiles.Initialize;
    WObjects1.Initialize;
    WObjects2.Initialize;
    WObjects3.Initialize;
    WObjects4.Initialize;
    WObjects5.Initialize;
    WObjects6.Initialize;
    WObjects7.Initialize;
    WObjects8.Initialize;
    WObjects9.Initialize;
    WObjects10.Initialize;
    WSmTiles.Initialize;
    WProgUse.Initialize;
    WProgUse2.Initialize;
    WChrSel.Initialize;
    WMMap.Initialize;
    WBagItem.Initialize(3);
    WStateItem.Initialize(3);
    WDnItem.Initialize(3);
    WHumImg.Initialize(3);
    WHairImg.Initialize;
    WHumWing.Initialize;
    WKillerWing.Initialize(3);
    WWeapon.Initialize(3);
    WKillerWeaponL.Initialize(3);
    WKillerWeaponR.Initialize(3);
    WKillerHumImg.Initialize(3);
    WKillerHairImg.Initialize;
    WKillerHumImg2.Initialize(3);
    WHumImg2.Initialize(3);
    WMagic.Initialize(3);
    WMagic2.Initialize(3);
    WMagIcon.Initialize(3);
    WMonImg.Initialize;
    WMon2Img.Initialize;
    WMon3Img.Initialize;
    WMon4Img.Initialize;
    WMon5Img.Initialize;
    WMon6Img.Initialize;
    WMon7Img.Initialize;
    WMon8Img.Initialize;
    WMon9Img.Initialize;
    WMon10Img.Initialize;
    WMon11Img.Initialize;
    WMon12Img.Initialize;
    WMon13Img.Initialize;
    WMon14Img.Initialize;
    WMon15Img.Initialize;
    WMon16Img.Initialize;
    WMon17Img.Initialize;
    WMon18Img.Initialize;
    WMon19Img.Initialize;
    WMon20Img.Initialize;
    WMon21Img.Initialize;
    // 2003/07/15 과거 비천 추가몹
    WMon22Img.Initialize;
    WMon23Img.Initialize;
    WMon24Img.Initialize;
    WMon25Img.Initialize;
    WDragonImg.Initialize;
    WNpcImg.Initialize;
    WDecoImg.Initialize;
    WEffectImg.Initialize;

    DXDraw1.DefColorTable := WProgUse.MainPalette;
    DXDraw1.ColorTable    := DXDraw1.DefColorTable;
    DXDraw1.UpdatePalette;

    //256 Blend utility
    if not LoadNearestIndex(NEARESTPALETTEINDEXFILE) then begin
      BuildNearestIndex(DXDraw1.ColorTable);
      SaveNearestIndex(NEARESTPALETTEINDEXFILE);
    end;
    BuildColorLevels(DXDraw1.ColorTable);

    DScreen.Initialize;
    PlayScene.Initialize;
    LoginNoticeScene.Initialize;
    FrmDlg.Initialize;

    ImgMixSurface := TDirectDrawSurface.Create(FrmMain.DXDraw1.DDraw);
    ImgMixSurface.SystemMemory := True;
    // 2003/07/15 오마패왕, 시공석을 위해 확장
    ImgMixSurface.SetSize(500, 400);     //(300, 350);

    //2004/08/06 장원꾸미기 (은행나무 사이즈가 너무커서 은행나무만 별도 처리)
    ImgLargeMixSurface := TDirectDrawSurface.Create(FrmMain.DXDraw1.DDraw);
    ImgLargeMixSurface.SystemMemory := True;
    ImgLargeMixSurface.SetSize(800, 700);

    MiniMapSurface := TDirectDrawSurface.Create(FrmMain.DXDraw1.DDraw);
    MiniMapSurface.SystemMemory := True;
    MiniMapSurface.SetSize(540, 360);

    //DXDraw1.Surface.SystemMemory := TRUE;

    if BoCompileMode then
      DScreen.AddSysMsg('Compile Mode.');
  end;
end;

procedure TFrmMain.DXDraw1Finalize(Sender: TObject);
begin
  //DXTimer.Enabled := FALSE;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not BoCompileMode then begin
    CloseNPGameMon; //@@@@
  end;
  //Savebags ('.\Data\' + ServerName + '.' + CharName + '.itm', @ItemArr);
  //DxTimer.Enabled := FALSE;
end;


{------------------------------------------------------------}


function TFrmMain.GetObjs(wunit, idx: integer): TDirectDrawSurface;
begin
  case wunit of
    0: Result := WObjects1.Images[idx];
    1: Result := WObjects2.Images[idx];
    2: Result := WObjects3.Images[idx];
    3: Result := WObjects4.Images[idx];
    4: Result := WObjects5.Images[idx];
    5: Result := WObjects6.Images[idx];
    6: Result := WObjects7.Images[idx];
    7: Result := WObjects8.Images[idx];
    8: Result := WObjects9.Images[idx];
    9: Result := WObjects10.Images[idx];
    else
      Result := WObjects1.Images[idx];
  end;
end;

function TFrmMain.GetObjsEx(wunit, idx: integer;
  var px, py: integer): TDirectDrawSurface;
begin
  case wunit of
    0: Result := WObjects1.GetCachedImage(idx, px, py);
    1: Result := WObjects2.GetCachedImage(idx, px, py);
    2: Result := WObjects3.GetCachedImage(idx, px, py);
    3: Result := WObjects4.GetCachedImage(idx, px, py);
    4: Result := WObjects5.GetCachedImage(idx, px, py);
    5: Result := WObjects6.GetCachedImage(idx, px, py);
    6: Result := WObjects7.GetCachedImage(idx, px, py);
    7: Result := WObjects8.GetCachedImage(idx, px, py);
    8: Result := WObjects9.GetCachedImage(idx, px, py);
    9: Result := WObjects10.GetCachedImage(idx, px, py);
    else
      Result := WObjects1.GetCachedImage(idx, px, py);
  end;
end;

procedure TFrmMain.DXTimerTimer(Sender: TObject; LagCount: Integer);
var
  i, j, n: integer;
  p:    TPoint;
  DF:   TDDBltFX;
  d:    TDirectDrawSurface;
begin
  if not DXDraw1.CanDraw then exit;

  // DXDraw1.Surface.Fill(0);
  // BoldTextOut (DxDraw1.Surface, 0, 0, clBlack, clBlack, 'test test ' + TimeToStr(Time));
  // DxDraw1.Surface.Canvas.Release;

  ProcessKeyMessages;
  ProcessActionMessages;
  DScreen.DrawScreen(DxDraw1.Surface);
  DWinMan.DirectPaint(DxDraw1.Surface);
  DScreen.DrawScreenTop(DxDraw1.Surface);
  DScreen.DrawHint(DxDraw1.Surface);

  if TabClickTime + 5000 > GetTickCount then begin
    PlayScene.DropItemsShow; //@@@@
  end;

  {Draw cursor}
{   CursorSurface := FrmMain.WProgUse.Images[0];
   if CursorSurface <> nil then begin
      GetCursorPos (p);
      DxDraw1.Surface.Draw (p.x, p.y, CursorSurface.ClientRect, CursorSurface, TRUE);
   end;}

  if ItemMoving then begin
    if (MovingItem.Item.S.Name <> 'Gold') then
      d := FrmMain.WBagItem.Images[MovingItem.Item.S.Looks]
    else
      d := FrmMain.WBagItem.Images[115]; //돈 모양
    if d <> nil then begin
      GetCursorPos(p);
      DxDraw1.Surface.Draw(p.x - (d.ClientRect.Right div 2), p.y -
        (d.ClientRect.Bottom div 2), d.ClientRect, d, True);
      // 겹치기
      if (MovingItem.Item.S.OverlapItem > 0) and
        (MovingItem.Item.S.Name <> 'Gold') then begin
        SetBkMode(DxDraw1.Surface.Canvas.Handle, TRANSPARENT);
        DxDraw1.Surface.Canvas.Font.Color := clYellow;
        DxDraw1.Surface.Canvas.TextOut(p.x + 9, p.y + 3,
          IntToStr(MovingItem.Item.Dura));
        DxDraw1.Surface.Canvas.Release;
      end;
    end;
  end;
  if DoFadeOut then begin
    if FadeIndex < 1 then
      FadeIndex := 1;
    MakeDark(DxDraw1.Surface, FadeIndex);
    if FadeIndex <= 1 then
      DoFadeOut := False
    else
      Dec(FadeIndex, 2);
  end else if DoFadeIn then begin
    if FadeIndex > 29 then
      FadeIndex := 29;
    MakeDark(DxDraw1.Surface, FadeIndex);
    if FadeIndex >= 29 then
      DoFadeIn := False
    else
      Inc(FadeIndex, 2);
  end else if DoFastFadeOut then begin
    if FadeIndex < 1 then
      FadeIndex := 1;
    MakeDark(DxDraw1.Surface, FadeIndex);
    if FadeIndex <= 1 then
      DoFastFadeOut := False;
    if FadeIndex > 1 then
      Dec(FadeIndex, 4);
  end;

   {for i:=0 to 15 do
      for j:=0 to 15 do begin
         DxDraw1.Surface.FillRect(Rect (j*16, i*16, (j+1)*16, (i+1)*16), i*16 + j);
      end;

   for i:=0 to 15 do
      DxDraw1.Surface.Canvas.TextOut (600, i*14,
                                    IntToStr(i) + ' ' +
                                    IntToStr(DXDraw1.ColorTable[i].rgbRed) + ' ' +
                                    IntToStr(DXDraw1.ColorTable[i].rgbGreen) + ' ' +
                                    IntToStr(DXDraw1.ColorTable[i].rgbBlue));
   DxDraw1.Surface.Canvas.Release;}

  if Myself <> nil then begin
    if not BoDebugModeScreen and not Myself.Death then begin
      if GetTickCount - checkfaketime > 1000 then begin
        checkfaketime := GetTickCount;
        if not ((DayBright = DayBright_fake) and (DayBright = pDayBrightCheck^) and
          (DarkLevel = DarkLevel_fake) and (DarkLevel = pDarkLevelCheck^)) then
          DScreen.AddSysMsg(IntToStr(DayBright) + '=' +
            IntToStr(DayBright_fake) + '=' + IntToStr(pDayBrightCheck^) +
            ', ' + IntToStr(DarkLevel) + '=' + IntToStr(DarkLevel) +
            '=' + IntToStr(pDarkLevelCheck^));
        //FrmMain.Close;

        if DarkLevel <> 0 then
          if ViewFog = False then
            FrmMain.Close;

      end;
    end;
    if (GetTickCount - checkchecksumtime > 5000) and not BoDebugModeScreen then begin
      checkchecksumtime := GetTickCount;

      //compile 모드에서는 검사를 하지 않는다.
      if not BoCompileMode then begin   
        //클라이언트를 고쳤는지 검사..
        if (pLocalFileCheckSum^ <> pClientCheckSum1^) and
          (pLocalFileCheckSum^ <> pClientCheckSum2^) and
          (pLocalFileCheckSum^ <> pClientCheckSum3^) then
          FrmMain.Close;
      end;
    end;
  end;

  if ConnectionStep = cnsLogin then begin
    with DxDraw1.Surface.Canvas do begin
      Brush.Color := clBlack;
      n := 64;
      RoundRect(SCREENWIDTH - n, 0, SCREENWIDTH, n, n, n);
      Font.Color := clRed;
      SetBkMode(Handle, TRANSPARENT);
      BoldTextOut(DxDraw1.Surface, (SCREENWIDTH - n) + ((n - TextWidth(LogoText)) div 2),
        (n - TextHeight('W')) div 2, clRed, clNavy, LogoText);
      Release;
    end;
  end;
  DxDraw1.Flip;
  //DxDraw1.Primary.Draw(0, 0, DxDraw1.Surface.ClientRect, DxDraw1.Surface, False);
end;

procedure TFrmMain.AppLogout;
begin
  if mrOk = FrmDlg.DMessageDlg('Would you like to logout ?', [mbOK, mbCancel]) then
  begin
    SendClientMessage(CM_SOFTCLOSE, 0, 0, 0, 0);
    PlayScene.ClearActors;
    CloseAllWindows;
    if not BoOneClick then begin
      SoftClosed := True;
      ActiveCmdTimer(tcSoftClose);
    end else begin
      ActiveCmdTimer(tcReSelConnect);
    end;
    if BoBagLoaded then
      Savebags('.\Data\' + ServerName + '.' + CharName + '.itm', @ItemArr);
    BoBagLoaded := False;
  end;
end;

procedure TFrmMain.AppExit;
begin
  if mrOk = FrmDlg.DMessageDlg('Would you like to quit Legend of Mir?',
    [mbOK, mbCancel]) then begin
    if BoBagLoaded then
      Savebags('.\Data\' + ServerName + '.' + CharName + '.itm', @ItemArr);
    BoBagLoaded := False;
    FrmMain.Close;
  end;
end;

procedure TFrmMain.PrintScreenNow;

  function IntToStr2(n: integer): string;
  begin
    if n < 10 then
      Result := '0' + IntToStr(n)
    else
      Result := IntToStr(n);
  end;

var
  i, k, n, checksum: integer;
  flname: string;
  dib:    TDIB;
  ddsd:   TDDSurfaceDesc;
  sptr, dptr: PByte;
begin
  if not DXDraw1.CanDraw then
    exit;
  while True do begin
    flname := 'Images' + IntToStr2(CaptureSerial) + '.bmp';
    if not FileExists(flname) then
      break;
    Inc(CaptureSerial);
  end;
  dib := TDIB.Create;
  dib.BitCount := 8;
  dib.Width := SCREENWIDTH;
  dib.Height := SCREENHEIGHT;
  dib.ColorTable := WProgUse.MainPalette;
  dib.UpdatePalette;

  ddsd.dwSize := SizeOf(ddsd);
  checksum    := 0;   //채크썸을만든다.
  try
    DXDraw1.Primary.Lock(TRect(nil^), ddsd);
    for i := (600 - 120) to SCREENHEIGHT - 10 do begin
      sptr := PBYTE(integer(ddsd.lpSurface) + (SCREENHEIGHT - 1 - i) *
        ddsd.lPitch + 200);
      for k := 0 to 400 - 1 do begin
        checksum := checksum + byte(pbyte(integer(sptr) + k)^);
      end;
    end;
  finally
    DXDraw1.Primary.Unlock();
  end;

  try
    SetBkMode(DXDraw1.Primary.Canvas.Handle, TRANSPARENT);
    DXDraw1.Primary.Canvas.Font.Color := clWhite;
    n := 0;
    if Myself <> nil then begin
      DXDraw1.Primary.Canvas.TextOut(0, 0, ServerName + ' ' + Myself.UserName);
      Inc(n, 1);
    end;
    DXDraw1.Primary.Canvas.TextOut(0, (n) * 12, 'CheckSum=' + IntToStr(checksum));
    DXDraw1.Primary.Canvas.TextOut(0, (n + 1) * 12, DateToStr(Date));
    DXDraw1.Primary.Canvas.TextOut(0, (n + 2) * 12, TimeToStr(Time));
    DXDraw1.Primary.Canvas.Release;
    DXDraw1.Primary.Lock(TRect(nil^), ddsd);
    for i := 0 to dib.Height - 1 do begin
      sptr := PBYTE(integer(ddsd.lpSurface) + (dib.Height - 1 - i) * ddsd.lPitch);
      dptr := PBYTE(integer(dib.PBits) + i * 800);
      Move(sptr^, dptr^, 800);
    end;
  finally
    DXDraw1.Primary.Unlock();
  end;
  dib.SaveToFile(flname);
  dib.Clear;
  dib.Free;
end;


{------------------------------------------------------------}

procedure TFrmMain.ProcessKeyMessages;
begin
  case ActionKey of
    VK_F1, VK_F2, VK_F3, VK_F4, VK_F5, VK_F6, VK_F7, VK_F8: begin
      UseMagic(MouseX, MouseY, GetMagicByKey(char(
        (ActionKey - VK_F1) + byte('1'))));
      //스크린 좌표
      //DScreen.AddSysMsg ('KEY' + IntToStr(Random(10000)));
      ActionKey := 0;
      TargetX   := -1;
      exit;
    end;
    // 2003/08/20 =>마법단축키 추가  // AddMagicKey
    VK_F1 - 100, VK_F2 - 100, VK_F3 - 100, VK_F4 - 100, VK_F5 - 100, VK_F6 - 100,
    VK_F7 - 100, VK_F8 - 100: begin
      UseMagic(MouseX, MouseY, GetMagicByKey(char(
        (ActionKey - (VK_F1 - 100)) + byte('1') + 20))); //스크린 좌표
      ActionKey := 0;
      TargetX   := -1;
      exit;
    end;
    //-----------
  end;
end;

procedure TFrmMain.ProcessActionMessages;
var
  mx, my, dx, dy, crun: integer;
  ndir, adir, mdir: byte;
  bowalk, bostop: boolean;
  stdcount: integer;
label
  LB_WALK;
begin
  if Myself = nil then
    exit;

  //Move
  if (TargetX >= 0) and CanNextAction and ServerAcceptNextAction then
  begin //ActionLock이 풀리면, ActionLock은 동작이 끝나기 전에 풀린다.
    if (TargetX <> Myself.XX) or (TargetY <> Myself.YY) then begin
      mx   := Myself.XX;
      my   := Myself.YY;
      dx   := TargetX;
      dy   := TargetY;
      ndir := GetNextDirection(mx, my, dx, dy);
      case ChrAction of
        caWalk: begin
          LB_WALK:            //DScreen.AddSysMsg ('caWalk ' + IntToStr(Myself.XX) + ' ' +
            //                               IntToStr(Myself.YY) + ' ' +
            //                               IntToStr(TargetX) + ' ' +
            //                               IntToStr(TargetY));
            crun := Myself.CanWalk;
          if IsUnLockAction(CM_WALK, ndir) and (crun > 0) then begin
            GetNextPosXY(ndir, mx, my);
            bowalk := True;
            bostop := False;
            if not PlayScene.CanWalk(mx, my) then begin
              bowalk := False;
              adir   := 0;
              if not bowalk then begin  //입구 검사
                mx := Myself.XX;
                my := Myself.YY;
                GetNextPosXY(ndir, mx, my);
                if CheckDoorAction(mx, my) then
                  bostop := True;
              end;
              if not bostop and not PlayScene.CrashMan(mx, my) then
              begin //사람은 자동으로 피하지 않음..
                mx   := Myself.XX;
                my   := Myself.YY;
                adir := PrivDir(ndir);
                GetNextPosXY(adir, mx, my);
                if not Map.CanMove(mx, my) then begin
                  mx   := Myself.XX;
                  my   := Myself.YY;
                  adir := NextDir(ndir);
                  GetNextPosXY(adir, mx, my);
                  if Map.CanMove(mx, my) then
                    bowalk := True;
                end else
                  bowalk := True;
              end;
              if bowalk then begin
                Myself.UpdateMsg(CM_WALK, mx, my, adir, 0, 0, '', 0);
                LastMoveTime := GetTickCount;
              end else begin
                mdir := GetNextDirection(Myself.XX, Myself.YY, dx, dy);
                if mdir <> Myself.Dir then
                  Myself.SendMsg(CM_TURN, Myself.XX, Myself.YY,
                    mdir, 0, 0, '', 0);
                TargetX := -1;
              end;
            end else begin
              Myself.UpdateMsg(CM_WALK, mx, my, ndir, 0, 0, '', 0);
              //항상 마지막 명령만 기억
              LastMoveTime := GetTickCount;
            end;
          end else begin
            TargetX := -1;
          end;
        end;
        caRun: begin
          stdcount := 1;
          if (MySelf.State and $01000000) <> 0 then
            stdcount := 0;
          if RunReadyCount >= stdcount {1} then begin
            crun := Myself.CanRun;
            if (GetDistance(mx, my, dx, dy) >= 2) and (crun > 0) then begin
              if IsUnLockAction(CM_RUN, ndir) then begin
                GetNextRunXY(ndir, mx, my);
                if PlayScene.CanRun(Myself.XX, Myself.YY, mx, my) then begin
                  Myself.UpdateMsg(CM_RUN, mx, my, ndir, 0, 0, '', 0);
                  LastMoveTime := GetTickCount;
                end else begin
                  mx := Myself.XX;
                  my := Myself.YY;
                  goto LB_WALK;
                end;
              end else
                TargetX := -1;
            end else begin
              //if crun = -1 then begin
              //DScreen.AddSysMsg ('Can not run right now.');
              //TargetX := -1;
              //end;
              goto LB_WALK;     //체력이 없는경우.
                     {if crun = -2 then begin
                        DScreen.AddSysMsg ('You can run for a few second.');
                        TargetX := -1;
                     end; }
            end;
          end else begin
            Inc(RunReadyCount);
            goto LB_WALK;
          end;
        end;
      end;
    end;
  end;
  TargetX := -1; //한번에 한칸씩..
  if Myself.RealActionMsg.Ident > 0 then begin
    FailAction := Myself.RealActionMsg.Ident; //실패할때 대비
    FailDir    := Myself.RealActionMsg.Dir;
    FailActionTime := GetTickCount;
    if Myself.RealActionMsg.Ident = CM_SPELL then begin
      SendSpellMsg(Myself.RealActionMsg.Ident,
        Myself.RealActionMsg.X,
        Myself.RealActionMsg.Y,
        Myself.RealActionMsg.Dir,
        Myself.RealActionMsg.State);
    end else
      SendActMsg(Myself.RealActionMsg.Ident,
        Myself.RealActionMsg.X,
        Myself.RealActionMsg.Y,
        Myself.RealActionMsg.Dir);
    Myself.RealActionMsg.Ident := 0;

    //메뉴를 받은후 10발자국 이상 걸으면 자동으로 사라짐
    if MDlgX <> -1 then
      if (abs(MDlgX - Myself.XX) >= 8) or (abs(MDlgY - Myself.YY) >= 8) then begin
        FrmDlg.CloseMDlg;
        FrmDlg.SafeCloseDlg;

{            if(FrmDlg.DMakeItemDlg.Visible) then
               FrmDlg.DMakeItemDlgOkClick(FrmDlg.DMakeItemDlgCancel, 0, 0);
            if FrmDlg.DItemMarketDlg.Visible then FrmDlg.CloseItemMarketDlg;
            if(FrmDlg.DJangwonListDlg.Visible) then
               FrmDlg.DJangwonCloseClick(FrmDlg.DJangwonClose, 0, 0);
            if(FrmDlg.DGABoardListDlg.Visible) then
               FrmDlg.DGABoardListCloseClick(FrmDlg.DGABoardListClose, 0, 0);
            if(FrmDlg.DGABoardDlg.Visible) then
               FrmDlg.DGABoardCloseClick(FrmDlg.DGABoardClose, 0, 0);}

        MDlgX := -1;
      end;
  end;
end;

procedure TFrmMain.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  msg, wc, dir, mx, my: integer;
  ini: TIniFile;
begin
  case Key of
    VK_PAUSE:   // 프린트 스크린 키
    begin
      Key := 0;
      PrintScreenNow;
    end;

      {VK_F1:
         begin
            if ssShift in Shift then Dec(DebugColor1)
            else Inc(DebugColor1);
            BoDebugColorChanged := TRUE;
         end;
      VK_F2:
         begin
            if ssShift in Shift then Dec(DebugColor2)
            else Inc(DebugColor2);
            BoDebugColorChanged := TRUE;
         end;
      VK_F3:
         begin
            if ssShift in Shift then Dec(DebugColor3)
            else Inc(DebugColor3);
            BoDebugColorChanged := TRUE;
         end;
      VK_F4:
         begin
            if ssShift in Shift then Dec(DebugColor4)
            else Inc(DebugColor4);
            BoDebugColorChanged := TRUE;
         end; }

  end;

  if DWinMan.KeyDown(Key, Shift) then
    exit;

  if (Myself = nil) or (DScreen.CurrentScene <> PlayScene) then
    exit;
  mx := Myself.XX;
  my := Myself.YY;
  case Key of
    VK_F1, VK_F2, VK_F3, VK_F4,
    VK_F5, VK_F6, VK_F7, VK_F8:         // 2003/08/20 =>마법단축키 추가  // AddMagicKey
      if ssCtrl in Shift then begin
        if (GetTickCount - LatestSpellTime > (500 + MagicDelayTime)) then begin
          ActionKey := Key - 100;
        end;
        Key := 0;
      end else begin //-----
        if (GetTickCount - LatestSpellTime > (500 + MagicDelayTime)) then begin
          ActionKey := Key;
        end;
        Key := 0;
      end;

    VK_F9: begin
      FrmDlg.OpenItemBag;
    end;
    VK_F10: begin
      FrmDlg.StatePage := 0;
      FrmDlg.OpenMyStatus;
    end;
    VK_F11: begin
      FrmDlg.StatePage := 3;
      FrmDlg.OpenMyStatus;
    end;
    word('H'):  //대인공격 방법
    begin
      if ssCtrl in Shift then begin
        SendSay('@AttackMode');
      end;
    end;
    word('A'): begin
      if ssCtrl in Shift then begin
        SendSay('@Rest');
      end;
    end;
    word('F'): begin
      if ssCtrl in Shift then begin
        if CurFont < MAXFONT - 1 then
          Inc(CurFont)
        else
          CurFont := 0;
        if KoreanVersion then
          CurFontName := FontKorArr[CurFont]
        else
          CurFontName := FontEngArr[CurFont];

        FrmMain.Font.Name := CurFontName;
        FrmMain.Canvas.Font.Name := CurFontName;
        DxDraw1.Surface.Canvas.Font.Name := CurFontName;
        PlayScene.EdChat.Font.Name := CurFontName;
        FrmDlg.Font.Name  := CurFontName;
        FrmDlg.Canvas.Font.Name := CurFontName;

        ini := TIniFile.Create('.\Mir2.ini');
        if ini <> nil then begin
          ini.WriteString('Setup', 'FontName', CurFontName);
          ini.Free;
        end;

      end;
    end;
    word('X'): begin
      if Myself = nil then
        exit;
      if ssAlt in Shift then begin

        FrmMain.SendClientMessage(CM_CANCLOSE, 0, 0, 0, 0);

{               if (GetTickCount - LatestStruckTime > 10000) and
                  (GetTickCount - LatestMagicTime > 10000) and
                  (GetTickCount - LatestHitTime > 10000) or
                  (Myself.Death) then
               begin
                  AppLogOut;
               end else
                  DScreen.AddChatBoardString ('전투중에는 접속을 끊을 수 없습니다.', clYellow, clRed);}
      end;
    end;
    word('Q'): begin
      if Myself = nil then
        exit;
      if ssAlt in Shift then begin
        if (GetTickCount - LatestStruckTime > 10000) and
          (GetTickCount - LatestMagicTime > 10000) and
          (GetTickCount - LatestHitTime > 10000) or (Myself.Death) then begin
          AppExit;
        end else
          DScreen.AddChatBoardString(
            'You cannot terminate connection during fight.', clYellow, clRed);
      end;
    end;
  end;
  //채팅창 조정
  case Key of
    VK_UP: with DScreen do begin
        if ChatBoardTop > 0 then
          Dec(ChatBoardTop);
      end;
    VK_DOWN: with DScreen do begin
        if ChatBoardTop < ChatStrs.Count - 1 then
          Inc(ChatBoardTop);
      end;
    VK_PRIOR: with DScreen do begin
        if ChatBoardTop > VIEWCHATLINE then
          ChatBoardTop := ChatBoardTop - VIEWCHATLINE
        else
          ChatBoardTop := 0;
      end;
    VK_NEXT: with DScreen do begin
        if ChatBoardTop + VIEWCHATLINE < ChatStrs.Count - 1 then
          ChatBoardTop := ChatBoardTop + VIEWCHATLINE
        else
          ChatBoardTop := ChatStrs.Count - 1;
        if ChatBoardTop < 0 then
          ChatBoardTop := 0;
      end;
  end;
end;

procedure TFrmMain.FormKeyPress(Sender: TObject; var Key: char);
var
  i: integer;
begin
  if DWinMan.KeyPress(Key) then
    exit;
  if DScreen.CurrentScene = PlayScene then begin
    if PlayScene.EdChat.Visible then begin
      //공통으로 처리해야 하는 경우만 아래로 넘어감
      exit;
    end;
    case byte(key) of
      // 2003/01/13 .. 단축키 추가
      byte('I'), byte('i'): begin
        FrmDlg.OpenItemBag;
      end;
      byte('C'), byte('c'): begin
        FrmDlg.StatePage := 0;
        FrmDlg.OpenMyStatus;
      end;
      byte('S'), byte('s'): begin
        FrmDlg.StatePage := 3;
        FrmDlg.OpenMyStatus;
      end;
      byte('H'), byte('h'):  //대인공격 방법
      begin
        SendSay('@AttackMode');
      end;
      byte('A'), byte('a'): begin
        SendSay('@Rest');
      end;
      byte('V'), byte('v'): begin
        FrmDlg.DBotMiniMapClick(nil, 0, 0);
      end;
      byte('P'), byte('p'): begin
        FrmDlg.DBotGroupClick(nil, 0, 0);
      end;
      byte('T'), byte('t'): begin
        FrmDlg.DBotTradeClick(nil, 0, 0);
      end;
      byte('G'), byte('g'): begin
        FrmDlg.DBotGuildClick(nil, 0, 0);
      end;
      // 2003/01/13 .. 단축키 추가 ======================== 끝
      // 2003/04/15 친구, 쪽지
      byte('W'), byte('w'): begin
        FrmDlg.DBotFriendClick(nil, 0, 0);
      end;
      byte('M'), byte('m'): begin
        FrmDlg.DBotMemoClick(nil, 0, 0);
      end;
      // 연인 사제창
      byte('L'), byte('l'): begin
        FrmDlg.DBotMasterClick(nil, 0, 0);
      end;


      byte('1')..byte('6'): begin
        EatItem(byte(key) - byte('1')); //벨트 아이템을 사용한다.
      end;
      27: //ESC
      begin
        // 2003/03/04 ESC 키로 열린 창을 닫음
        CloseAllWindows;
      end;
      byte(' '), 13: //채팅 박스
      begin
        PlayScene.EdChat.Visible := True;
        PlayScene.EdChat.SetFocus;
        SetImeMode(PlayScene.EdChat.Handle, LocalLanguage);
        if FrmDlg.BoGuildChat then begin
          PlayScene.EdChat.Text      := '!~';
          PlayScene.EdChat.SelStart  := Length(PlayScene.EdChat.Text);
          PlayScene.EdChat.SelLength := 0;
        end else begin
          PlayScene.EdChat.Text := '';
        end;
      end;
      byte('@'),
      byte('!'),
      byte(','),
      byte('/'): begin
        PlayScene.EdChat.Visible := True;
        PlayScene.EdChat.SetFocus;
        SetImeMode(PlayScene.EdChat.Handle, LocalLanguage);
        if key = '/' then begin
          if WhisperName = '' then
            PlayScene.EdChat.Text := key
          else if Length(WhisperName) > 2 then
            PlayScene.EdChat.Text := '/' + WhisperName + ' '
          else
            PlayScene.EdChat.Text := key;
          PlayScene.EdChat.SelStart := Length(PlayScene.EdChat.Text);
          PlayScene.EdChat.SelLength := 0;
        end else if key = ',' then begin
          if Copy(fLover.GetDisplay(0), length(STR_LOVER) + 1, 6) <> '' then
            //                     PlayScene.EdChat.Text := '♡'
            PlayScene.EdChat.Text := ':)'
          else
            PlayScene.EdChat.Text := key;
          PlayScene.EdChat.SelStart := Length(PlayScene.EdChat.Text);
          PlayScene.EdChat.SelLength := 0;
        end else begin
          PlayScene.EdChat.Text      := key;
          PlayScene.EdChat.SelStart  := 1;
          PlayScene.EdChat.SelLength := 0;
        end;
      end;
    end;
    key := #0;
  end;
end;

function TFrmMain.GetMagicByKey(Key: char): PTClientMagic;
var
  i:  integer;
  pm: PTClientMagic;
begin
  Result := nil;
  for i := 0 to MagicList.Count - 1 do begin
    pm := PTClientMagic(MagicList[i]);
    if pm.Key = Key then begin
      Result := pm;
      break;
    end;
  end;
end;

procedure TFrmMain.UseMagic(tx, ty: integer; pcm: PTClientMagic);
//tx, ty: 스크린 좌표임.
var
  tdir, targx, targy, targid: integer;
  pmag: PTUseMagicInfo;
  meff: TMagicEff;
  TempTarget: TActor;
  SpellSpend: word;
begin
  if pcm = nil then
    exit;

  // 2003/03/15 신규무공 추가

  //   if (pcm.Def.Spell + pcm.Def.DefSpell <= Myself.Abil.MP) or (pcm.Def.EffectType = 0) then begin
  SpellSpend := Round(pcm.Def.Spell / (pcm.Def.MaxTrainLevel + 1) * (pcm.Level + 1)) +
    pcm.Def.DefSpell;

  if (SpellSpend <= Myself.Abil.MP) or (pcm.Def.EffectType = 0) then begin

    if pcm.Def.EffectType = 0 then begin //검법,효과없음
      //검법 키는 행동을 따로 하지 않는다.
      //서버에 직접 전달한다.
      //if CanNextAction and ServerAcceptNextAction then begin

      //염화결은 한번 사용후 9초까지는 다시 눌려지지 않게 한다.
      if pcm.Def.MagicId = SWD_FIREHIT then begin //염화결
        if GetTickCount - LatestFireHitTime < 10 * 1000 then begin
          exit;
        end;
      end;
      //무태보는 한번 사용후 3초까지는 다시 눌려지지 않는다.
      if pcm.Def.MagicId = SWD_RUSHRUSH then begin //무태보
        if GetTickCount - LatestRushRushTime < 3 * 1000 then begin
          exit;
        end;
      end;
      // 2003/07/15 신규무공 추가
      // 쌍룡참은 한번 사용후 공격을 중지한다
      if (pcm.Def.MagicId = SWD_TWINHIT) then begin
        BoStopAfterAttack := True;
        meff := TCharEffect.Create(210, 6, MySelf);
        meff.NextFrameTime := 120;
        meff.ImgLib := FrmMain.WMagic2;
        PlayScene.EffectList.Add(meff);
      end;

      //검법은 딜레이(500ms) 없이 눌려진다.
      if GetTickCount - LatestSpellTime > 500 then begin
        LatestSpellTime := GetTickCount;
        MagicDelayTime  := 0; //pcm.Def.DelayTime;
        SendSpellMsg(CM_SPELL, Myself.Dir{x}, 0, pcm.Def.MagicId, 0);
      end;
    end else begin

      tdir := GetFlyDirection(390, 175, tx, ty);

      //         if (pcm.Def.Effect in [2,14,17,18,26,40]) or (pcm.Def.Effect in [7,8,11,12,15,20,21,27,28,31,41,44,46,47]) or
      //            (pcm.Def.Effect in [6,22,29,35,36]) then begin
      if (pcm.Def.Effect in [2, 6, 7, 8, 11, 12, 14, 15, 17, 18, 20,
        21, 22, 26, 27, 28, 29, 31, 35, 36, 40, 41, 44, 46, 47, 50]) then begin
        TargetCase  := 1; // 오토타겟이 아닌것
        MagicTarget := FocusCret;
      end else begin
        TargetCase := 2;
        if (FocusCret <> nil) and (not FocusCret.Death) then begin
          if FocusCret.Race = 0 then begin
            TargetCase  := 1;
            MagicTarget := FocusCret;
          end else
            AutoTarget := FocusCret;
        end;
        if (AutoTarget <> nil) and AutoTarget.Death then
          AutoTarget := nil;
      end;

      if TargetCase = 2 then
        TempTarget := AutoTarget
      else
        TempTarget := MagicTarget;
      if (TempTarget = nil) or (TempTarget <> FocusCret) then begin
        //오토타겟 AutoTarget
        if (FocusCret <> nil) and (not FocusCret.Death) then
          TempTarget := FocusCret;
      end;
      if (not PlayScene.IsValidActor(TempTarget)) and (TempTarget <> nil) and
        (not TempTarget.Death) then
        TempTarget := nil;

      if TargetCase = 1 then
        MagicTarget := TempTarget
      else if TargetCase = 2 then
        AutoTarget := TempTarget;

      if pcm.Def.MagicId in [52, 53, 55] then
        AutoTarget := nil;

      if TempTarget = nil then begin
        PlayScene.CXYfromMouseXYMid(tx, ty, targx, targy);
        // 마우스 지정 마법 위치 수정
        //            PlayScene.CXYfromMouseXY(tx, ty, targx, targy);
        targid := 0;
      end else begin
        targx  := TempTarget.XX;
        targy  := TempTarget.YY;
        targid := TempTarget.RecogId;
      end;
      if CanNextAction and ServerAcceptNextAction then begin
        LatestSpellTime := GetTickCount;  //마법 사용
        new(pmag);
        FillChar(pmag^, sizeof(TUseMagicInfo), #0);
        pmag.EffectNumber := pcm.Def.Effect;
        pmag.MagicSerial := pcm.Def.MagicId;
        pmag.ServerMagicCode := 0;
        MagicDelayTime := 200 + pcm.Def.DelayTime;
        //다음 마법을 사용할때까지 쉬는 시간

        // 2003/03/15 신규무공 추가
        case pmag.MagicSerial of
          //0, 2, 11, 12, 15, 16, 17, 13, 23, 24, 26, 27, 28, 29: ;
          2, 14, 15, 16, 17, 18, 19, 21,  //비공격 마법 제외
          12, 25, 26, 28, 29, 30, 31, 40, 41, 42, 43: ; //월령,분신 추가
          else
            LatestMagicTime := GetTickCount;
        end;

        //사람을 공격하는 경우의 딜레이
        MagicPKDelayTime := 0;
        if MagicTarget <> nil then
          if MagicTarget.Race = 0 then
            MagicPKDelayTime := 300 + Random(1100);
        //(600+200 + MagicDelayTime div 5);

        Myself.SendMsg(CM_SPELL, targx, targy, tdir, integer(pmag), targid, '', 0);
      end;// else
          //Dscreen.AddSysMsg ('You can use it after for a while.');
          //Inc (SpellCount);
    end;
  end else
    Dscreen.AddSysMsg('Not enough magic points.');
  //   Dscreen.AddSysMsg ('UseMagic');
end;

procedure TFrmMain.UseMagicSpell(who, effnum, targetx, targety, magic_id: integer);
var
  actor: TActor;
  adir:  integer;
  pmag:  PTUseMagicInfo;
begin
  actor := PlayScene.FindActor(who);
  if actor <> nil then begin
    adir := GetFlyDirection(actor.XX, actor.YY, targetx, targety);
    new(pmag);
    FillChar(pmag^, sizeof(TUseMagicInfo), #0);
    pmag.EffectNumber    := effnum; //magnum;
    pmag.ServerMagicCode := 0;      //임시
    pmag.MagicSerial     := magic_id;
    actor.SendMsg(SM_SPELL, 0, 0, adir, integer(pmag), 0, '', 0);
    Inc(SpellCount);
  end else
    Inc(SpellFailCount);
end;

procedure TFrmMain.UseMagicFire(who, efftype, effnum, targetx, targety,
  target: integer);
var
  actor: TActor;
  adir, sound: integer;
  pmag:  PTUseMagicInfo;
begin
  actor := PlayScene.FindActor(who);
  if actor <> nil then begin
    sound := 0;
    actor.SendMsg(SM_MAGICFIRE, target{111magid}, efftype, effnum,
      targetx, targety, '', sound);
    //if actor = Myself then Dec (SpellCount);
    if FireCount < SpellCount then
      Inc(FireCount);
  end;
end;

procedure TFrmMain.UseMagicFireFail(who: integer);
var
  actor: TActor;
begin
  actor := PlayScene.FindActor(who);
  if actor <> nil then begin
    actor.SendMsg(SM_MAGICFIRE_FAIL, 0, 0, 0, 0, 0, '', 0);
  end;
  MagicTarget := nil;
end;

procedure TFrmMain.UseNormalEffect(effnum, effx, effy: integer);
var
  meff, meff2: TMagicEff;
  k:     integer;
  bofly: boolean;
begin
  meff  := nil;
  meff2 := nil;
  case effnum of
    NE_HEARTPALP: meff :=
        TNormalDrawEffect.Create(effx, effy, WMon14Img, 410,  //시작 위치
        6,    //프래임
        120,  //딜레이
        False);
    NE_CLONESHOW: // 분신술
      meff := TNormalDrawEffect.Create(effx, effy, WMagic2, 670,   //시작 위치
        10,       //프래임
        150,      //딜레이
        True);
{      NE_CLONEHIDE: begin
         meff := TNormalDrawEffect.Create (effx, effy,
                                       WMagic2,
                                       690,  //시작 위치
                                       10,    //프래임
                                       150,  //딜레이
                                       True);
            PlaySound (48);
         end;}
    NE_THUNDER: begin
      PlayScene.NewMagic(nil, MAGIC_DUN_THUNDER, MAGIC_DUN_THUNDER,
        effx, effy, effx, effy, 0, mtThunder, False, 30, bofly);
      PlaySound(8301);
    end;
    NE_FIRE: begin
      PlayScene.NewMagic(nil, MAGIC_DUN_FIRE1, MAGIC_DUN_FIRE1,
        effx, effy, effx, effy, 0, mtThunder, False, 30, bofly);
      PlayScene.NewMagic(nil, MAGIC_DUN_FIRE2, MAGIC_DUN_FIRE2,
        effx, effy, effx, effy, 0, mtThunder, False, 30, bofly);
      PlaySound(8302);
    end;
    NE_DRAGONFIRE: begin
      PlayScene.NewMagic(nil, MAGIC_DRAGONFIRE, MAGIC_DRAGONFIRE,
        effx, effy, effx, effy, 0, mtThunder, False, 30, bofly);
      PlaySound(8207);
    end;

    NE_FIREBURN: begin
      PlayScene.NewMagic(nil, MAGIC_FIREBURN, MAGIC_FIREBURN,
        effx, effy, effx, effy, 0, mtThunder, False, 30, bofly);
      PlaySound(8226);
    end;

    NE_FIRECIRCLE: begin// 화룡기염
      meff := TNormalDrawEffect.Create(effx, effy, WMagic2, 910,  //시작 위치
        23,   //프래임
        100,  //딜레이
        True);
    end;
    NE_POISONFOG: begin//이무기 독안개 임펙트 //####
      meff := TNormalDrawEffect.Create(effx, effy, WMagic2, 1280, //시작 위치
        10,   //프래임
        100,  //딜레이
        True);
      PlaySound(2446);//8102
    end;
    NE_SN_MOVEHIDE: begin//이무기 워프 사라지는임펙트
      meff := TNormalDrawEffect.Create(effx, effy, WMagic2, 1300, //시작 위치
        10,   //프래임
        80,   //딜레이
        True);
      PlaySound(2447);//8103
    end;
    NE_SN_MOVESHOW: begin//이무기 워프 나타나는임펙트
      meff := TNormalDrawEffect.Create(effx, effy, WMagic2, 1310, //시작 위치
        10,   //프래임
        80,   //딜레이
        True);
      PlaySound(2447);//8103
    end;
    FOX_SN_MOVEHIDE: begin//Redfoxman Teleport
      meff := TNormalDrawEffect.Create(effx, effy, WMon24Img, 800, //시작 위치
        10,   //프래임
        80,   //딜레이
        True);
      PlaySound(2447);//8103
    end;
    FOX_SN_MOVESHOW: begin//Redfoxman Teleport
      meff := TNormalDrawEffect.Create(effx, effy, WMon24Img, 810, //시작 위치
        10,   //프래임
        80,   //딜레이
        True);
      PlaySound(2447);//8103
    end;
    FOX_SN_SUMMON: begin//Whitefoxman Summon
      meff := TNormalDrawEffect.Create(effx, effy, WMagic2, 0, //시작 위치
        10,   //프래임
        80,   //딜레이
        True);
      PlaySound(2447);//8103
    end;
    ROCK_SN_POISON: begin//TrapRock Attack
      meff := TNormalDrawEffect.Create(effx, effy, WMon24Img, 1410, //시작 위치
        10,   //프래임
        80,   //딜레이
        True);
      PlaySound(157);//8103
    end;
    ROCK_SN_PULL: begin//GuardianRock Attack
      meff := TNormalDrawEffect.Create(effx, effy, WMon24Img, 1440, //시작 위치
        10,   //프래임
        120,   //딜레이
        True);
      PlaySound(2546);//8103
    end;
    SPIRIT_SN_THUNDER: begin//GreatFoxSpirit Attack 1
      meff := TNormalDrawEffect.Create(effx, effy, WMon24Img, 2140, //시작 위치
        20,   //프래임
        120,   //딜레이
        True);
      PlaySound(2576);
    end;
    SPIRIT_SN_MASS1S: begin//GreatFoxSpirit Mass Effect
      meff := TNormalDrawEffect.Create(effx, effy, WMon24Img, 2160, //시작 위치
        20,   //프래임
        120,   //딜레이
        True);
      PlaySound(2579);
    end;
    SPIRIT_SN_MASS1: begin//GreatFoxSpirit  Mass Effect
      meff := TNormalDrawEffect.Create(effx, effy, WMon24Img, 2160, //시작 위치
        20,   //프래임
        120,   //딜레이
        True);
    end;
    SPIRIT_SN_MASS2: begin//GreatFoxSpirit  Mass Effect
      meff := TNormalDrawEffect.Create(effx, effy, WMon24Img, 2180, //시작 위치
        20,   //프래임
        120,   //딜레이
        True);
    end;
    SPIRIT_SN_MASS3: begin//GreatFoxSpirit  Mass Effect
      meff := TNormalDrawEffect.Create(effx, effy, WMon24Img, 2200, //시작 위치
        20,   //프래임
        120,   //딜레이
        True);
    end;
    SPIRIT_SN_MASS4: begin//GreatFoxSpirit  Mass Effect
      meff := TNormalDrawEffect.Create(effx, effy, WMon24Img, 2220, //시작 위치
        20,   //프래임
        120,   //딜레이
        True);
    end;
    SPIRIT_SN_MASS5: begin//GreatFoxSpirit  Mass Effect
      meff := TNormalDrawEffect.Create(effx, effy, WMon24Img, 2240, //시작 위치
        20,   //프래임
        120,   //딜레이
        True);
    end;
    NE_SN_RELIVE: begin//이무기 부활 임펙트
      meff := TNormalDrawEffect.Create(effx, effy, WMagic2, 1330, //시작 위치
        10,   //프래임
        100,  //딜레이
        True);
      PlaySound(2448);//8104
    end;
    NE_USERHEALING: begin//초보자지역 NPC힐 이펙트
      meff := TNormalDrawEffect.Create(effx, effy, WMagic, 200,
        //시작 위치
        10,   //프래임
        100,  //딜레이
        True);
      PlaySound(10020);
    end;

  end;
  if meff <> nil then begin
    meff.MagOwner := Myself;  //내 기준으로
    PlayScene.EffectList.Add(meff);
  end;
  if meff2 <> nil then begin
    meff2.MagOwner := Myself;  //내 기준으로
    PlayScene.EffectList.Add(meff2);
  end;

end;

procedure TFrmMain.UseLoopNormalEffect(ActorID: integer; EffectIndex, LoopTime: word);
var
  actor: TActor;
  meff:  TMagicEff;
begin
  meff  := nil;
  actor := PlayScene.FindActor(ActorID);

  case EffectIndex of
    NE_CLONEHIDE: //분신술-분신 사라지는 임펙트
    begin
      meff := TCharEffect.Create(690, 10, actor);
      meff.NextFrameTime := 150;
      meff.RepeatUntil := 0;
      PlaySound(48);
    end;
    NE_MONCAPTURE: //포승검-포획 임펙트
    begin
      meff := TCharEffect.Create(1020, 8, actor);
      meff.NextFrameTime := 110;
      meff.RepeatUntil := GetTickCount + LoopTime;
      PlaySound(10475);
    end;
    NE_BLOODSUCK: //흡혈술-흡입 임펙트
    begin
      meff := TCharEffect.Create(1090, 10, actor);
      meff.NextFrameTime := 100;
      meff.RepeatUntil := 0;
      PlaySound(10485);
    end;
    NE_REVIVALCHARGE: //Reincarnation
    begin
      meff := TCharEffect.Create(1680, 10, actor);
      meff.NextFrameTime := 100;
      meff.RepeatUntil := GetTickCount + 5000;
      PlayBGM(bmg_revival);
    end;
    NE_FLOWERSEFFECT: //꽃다발 임펙트(연인)
    begin
      meff := TCharEffect.Create(1160, 20, actor);
      meff.NextFrameTime := 120;
      meff.RepeatUntil := GetTickCount + LoopTime;
      meff.Blend := False;
    end;
    NE_LEVELUP: begin
      PlaySound(156);
      meff := TCharEffect.Create(1200, 20, actor);
      meff.NextFrameTime := 80;
      meff.RepeatUntil := GetTickCount + LoopTime;
    end;
    NE_ROCKPULLEFFECT: begin
      PlaySound(2547);
      meff := TCharEffect.Create(1410, 10, actor);
      meff.NextFrameTime := 100;
      meff.RepeatUntil := GetTickCount + LoopTime;
    end;
    NE_SPIRITEFFECT: begin
      PlaySound(2577);
      meff := TCharEffect.Create(2120, 20, actor);
      meff.NextFrameTime := 120;
      meff.RepeatUntil := GetTickCount + LoopTime;
     end;
    NE_SPIRITMASS: begin
      meff := TCharEffect.Create(2160, 20, actor);
      meff.NextFrameTime := 120;
      meff.RepeatUntil := GetTickCount + LoopTime;
     end;
    NE_RELIVE: begin
         meff := TCharEffect.Create (1220, 20, actor);
         meff.NextFrameTime := 100;
         meff.RepeatUntil := 0;
        PlaySound(10543);
    end;
  end;

  if meff <> nil then begin
  if EffectIndex = NE_SPIRITEFFECT then
    meff.ImgLib := FrmMain.WMon24Img
    else
  if EffectIndex = NE_SPIRITMASS then
    meff.ImgLib := FrmMain.WMon24Img
    else
    meff.ImgLib := FrmMain.WMagic2;
    PlayScene.EffectList.Add(meff);
  end;

end;

procedure TFrmMain.EatItem(idx: integer);
begin

  // 2004/03/23 노끈일때 별도 처리
  if (MovingItem.Item.S.StdMode = 7) and ItemMoving then begin
    EatingItem := MovingItem.Item;
    FrmDlg.CancelItemMoving;
    EatTime := GetTickCount;
    SendEat(EatingItem.MakeIndex, EatingItem.S.Name);
    //      DScreen.AddChatBoardString ('SendEat-after', clYellow, clRed);
    ItemUseSound(EatingItem.S.StdMode);
    Exit;
  end;

  if idx in [0..MAXBAGITEMCL - 1] then begin
    if (EatingItem.S.Name <> '') and (GetTickCount - EatTime > 5 * 1000) then begin
      EatingItem.S.Name := '';
    end;
    if (EatingItem.S.Name = '') and (ItemArr[idx].S.Name <> '') and
      (ItemArr[idx].S.StdMode <= 3) then begin
      EatingItem := ItemArr[idx];
      ItemArr[idx].S.Name := '';
      //책을 읽는 것... 익힐 것인 지 물어본다.
      if (ItemArr[idx].S.StdMode = 4) and (ItemArr[idx].S.Shape < 100) then begin
        //shape > 100이면 묶음 아이템 임..
        if ItemArr[idx].S.Shape < 50 then begin
          if mrYes <> FrmDlg.DMessageDlg(ItemArr[idx].S.Name +
            ' : Would you like to start training?', [mbYes, mbNo]) then begin
            ItemArr[idx] := EatingItem;
            exit;
          end;
        end else begin
          //shape > 50이면 주문 서 종류...
          if mrYes <> FrmDlg.DMessageDlg(ItemArr[idx].S.Name +
            'Would you use?', [mbYes, mbNo]) then begin
            ItemArr[idx] := EatingItem;
            exit;
          end;
        end;
      end;
      EatTime := GetTickCount;
      SendEat(ItemArr[idx].MakeIndex, ItemArr[idx].S.Name);
      ItemUseSound(ItemArr[idx].S.StdMode);
    end;
  end else begin
    if (idx = -1) and ItemMoving then begin
      ItemMoving := False;
      EatingItem := MovingItem.Item;
      MovingItem.Item.S.Name := '';
      //책을 읽는 것... 익힐 것인 지 물어본다.
      if (EatingItem.S.StdMode = 4) and (EatingItem.S.Shape < 100) then begin
        //shape > 100이면 묶음 아이템 임..
        if EatingItem.S.Shape < 50 then begin
          if mrYes <> FrmDlg.DMessageDlg('"' + EatingItem.S.Name +
            '" : Would you like to start training?', [mbYes, mbNo]) then begin
            AddItemBag(EatingItem);
            exit;
          end;
        end else begin
          //shape > 50이면 주문 서 종류...
          if mrYes <> FrmDlg.DMessageDlg('"' + EatingItem.S.Name +
            '"Would you use?', [mbYes, mbNo]) then begin
            AddItemBag(EatingItem);
            exit;
          end;
        end;
      end;
      EatTime := GetTickCount;
      SendEat(EatingItem.MakeIndex, EatingItem.S.Name);
      ItemUseSound(EatingItem.S.StdMode);
    end;
  end;
end;

function TFrmMain.TargetInSwordLongAttackRange(ndir: integer): boolean;
var
  nx, ny: integer;
  actor:  TActor;
begin
  Result := False;
  GetFrontPosition(Myself.XX, Myself.YY, ndir, nx, ny);
  GetFrontPosition(nx, ny, ndir, nx, ny);
  if (abs(Myself.XX - nx) = 2) or (abs(Myself.YY - ny) = 2) then begin
    actor := PlayScene.FindActorXY(nx, ny);
    if actor <> nil then
      if not actor.Death then
        Result := True;
  end;
end;

function TFrmMain.TargetInSwordWideAttackRange(ndir: integer): boolean;
var
  nx, ny, rx, ry, mdir: integer;
  actor, ractor: TActor;
begin
  Result := False;
  GetFrontPosition(Myself.XX, Myself.YY, ndir, nx, ny);
  actor := PlayScene.FindActorXY(nx, ny);

  mdir := (ndir + 1) mod 8;
  GetFrontPosition(Myself.XX, Myself.YY, mdir, rx, ry);
  ractor := PlayScene.FindActorXY(rx, ry);
  if ractor = nil then begin
    mdir := (ndir + 2) mod 8;
    GetFrontPosition(Myself.XX, Myself.YY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;
  if ractor = nil then begin
    mdir := (ndir + 7) mod 8;
    GetFrontPosition(Myself.XX, Myself.YY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;

  if (actor <> nil) and (ractor <> nil) then
    if not actor.Death and not ractor.Death then
      Result := True;
end;

// 2003/03/15 신규무공
function TFrmMain.TargetInSwordCrossAttackRange(ndir: integer): boolean;
var
  nx, ny, rx, ry, mdir: integer;
  actor, ractor: TActor;
begin
  Result := False;
  GetFrontPosition(Myself.XX, Myself.YY, ndir, nx, ny);
  actor := PlayScene.FindActorXY(nx, ny);

  mdir := (ndir + 1) mod 8;
  GetFrontPosition(Myself.XX, Myself.YY, mdir, rx, ry);
  ractor := PlayScene.FindActorXY(rx, ry);
  if ractor = nil then begin
    mdir := (ndir + 2) mod 8;
    GetFrontPosition(Myself.XX, Myself.YY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;
  if ractor = nil then begin
    mdir := (ndir + 3) mod 8;
    GetFrontPosition(Myself.XX, Myself.YY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;
  if ractor = nil then begin
    mdir := (ndir + 4) mod 8;
    GetFrontPosition(Myself.XX, Myself.YY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;
  if ractor = nil then begin
    mdir := (ndir + 5) mod 8;
    GetFrontPosition(Myself.XX, Myself.YY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;
  if ractor = nil then begin
    mdir := (ndir + 6) mod 8;
    GetFrontPosition(Myself.XX, Myself.YY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;
  if ractor = nil then begin
    mdir := (ndir + 7) mod 8;
    GetFrontPosition(Myself.XX, Myself.YY, mdir, rx, ry);
    ractor := PlayScene.FindActorXY(rx, ry);
  end;

  if (actor <> nil) and (ractor <> nil) then
    if not actor.Death and not ractor.Death then
      Result := True;
end;


{--------------------- Mouse Interface ----------------------}

procedure TFrmMain.DXDraw1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  i, mx, my, msx, msy, sel: integer;
  target:    TActor;
  itemnames: string;
begin
  if DWinMan.MouseMove(Shift, X, Y) then
    exit;
  if (Myself = nil) or (DScreen.CurrentScene <> PlayScene) then
    exit;
  BoSelectMyself := PlayScene.IsSelectMyself(X, Y);

  target := PlayScene.GetAttackFocusCharacter(X, Y, DupSelection, sel, False);
  if DupSelection <> sel then
    DupSelection := 0;
  if target <> nil then begin
    if (target.UserName = '') and (GetTickCount - target.SendQueryUserNameTime >
      10 * 1000) then begin
      target.SendQueryUserNameTime := GetTickCount;
      SendQueryUserName(target.RecogId, target.XX, target.YY);
    end;
    FocusCret := target;
  end else
    FocusCret := nil;

  FocusItem := PlayScene.GetDropItems(X, Y, itemnames); //@@@@
  if FocusItem <> nil then begin
    PlayScene.ScreenXYfromMCXY(FocusItem.X, FocusItem.Y, mx, my);
    //      DScreen.AddChatBoardString ('Pos=> '+ IntToStr(((Length(FocusItem.Name) div 2)*6)), clYellow, clRed);
    DScreen.ShowHint(mx + 2 - ((Length(FocusItem.Name) div 2) * 6),
      my - 10,
      itemnames, //PTDropItem(ilist[i]).Name,
      clWhite,
      True);
  end else
    DScreen.ClearHint;

  PlayScene.CXYfromMouseXY(X, Y, MCX, MCY);
  MouseX := X;
  MouseY := Y;
  MouseItem.S.Name := '';
  MouseStateItem.S.Name := '';
  MouseUserStateItem.S.Name := '';
  if ((ssLeft in Shift) or (ssRight in Shift)) and
    (GetTickCount - mousedowntime > 300) then
    _DXDrawMouseDown(self, mbLeft, Shift, X, Y);

end;

procedure TFrmMain.DXDraw1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  mousedowntime := GetTickCount;
  RunReadyCount := 0;     //도움닫기 취소(뛰기 인경우)
  _DXDrawMouseDown(Sender, Button, Shift, X, Y);
end;

procedure TFrmMain.AttackTarget(target: TActor);
var
  tdir, dx, dy, hitmsg: integer;
begin
  hitmsg := CM_HIT;
  if UseItems[U_WEAPON].S.StdMode = 6 then
    hitmsg := CM_HEAVYHIT;

  tdir := GetNextDirection(Myself.XX, Myself.YY, target.XX, target.YY);
  if (abs(Myself.XX - target.XX) <= 1) and (abs(Myself.YY - target.YY) <= 1) and
    (not target.Death) then begin
    if CanNextAction and ServerAcceptNextAction and CanNextHit then begin

      if BoNextTimeFireHit and (Myself.Abil.MP >= 7) then begin
        BoNextTimeFireHit := False;
        hitmsg := CM_FIREHIT;
      end else if BoNextTimePowerHit then begin  //파워 아텍인 경우, 예도검법
        BoNextTimePowerHit := False;
        hitmsg := CM_POWERHIT;
      end else if BoNextTimeslashhit then begin  //Slash
        BoNextTimeslashhit := False;
        hitmsg := CM_slashhit;
      end else if BoCanTwinHit and (Myself.Abil.MP >= 10) then begin
        hitmsg := CM_TWINHIT;
      end else if BoCanWideHit and (Myself.Abil.MP >= 3) then begin
        //and (TargetInSwordWideAttackRange (tdir)) then begin  //롱 아텍인 경우, 반월검법
        hitmsg := CM_WIDEHIT;
      end else if BoCanWideHit2 and (Myself.Abil.MP >= 3) then begin  //Assassin Skill 2
        hitmsg := CM_WIDEHIT2;
      end else         // 2003/03/15 신규무공
      if BoCanCrossHit and (Myself.Abil.MP >= 6) then begin
        hitmsg := CM_CROSSHIT;
      end else         //필리핀코드 05/12/22 전사무공무조건 발동
      //         if BoCanLongHit and (TargetInSwordLongAttackRange (tdir)) then begin  //롱 아텍인 경우, 어검술
      if BoCanLongHit then begin
        hitmsg := CM_LONGHIT;
      end;

      //if ((target.Race <> 0) and (target.Race <> RCC_GUARD)) or (ssShift in Shift) then //사람을 실수로 공격하는 것을 막음
      Myself.SendMsg(hitmsg, Myself.XX, Myself.YY, tdir, 0, 0, '', 0);
      LatestHitTime := GetTickCount;
    end;
    LastAttackTime := GetTickCount;
  end else begin
    //비도를 들고 있으면
    //if (UseItems[U_WEAPON].S.Shape = 6) and (target <> nil) then begin
    //   Myself.SendMsg (CM_THROW, Myself.XX, Myself.YY, tdir, integer(target), 0, '', 0);
    //   TargetCret := nil;  //한번만 공격
    //end else begin
    ChrAction := caWalk;
    GetBackPosition(target.XX, target.YY, tdir, dx, dy);
    TargetX := dx;
    TargetY := dy;
    //end;
  end;
end;

procedure TFrmMain._DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  tdir, nx, ny, hitmsg, sel: integer;
  target: TActor;
begin
  ActionKey := 0;
  MouseX    := X;
  MouseY    := Y;
  BoAutoDig := False;

  if (Button = mbRight) and ItemMoving then begin
    FrmDlg.CancelItemMoving;
    exit;
  end;
  if DWinMan.MouseDown(Button, Shift, X, Y) then
    exit;
  if (Myself = nil) or (DScreen.CurrentScene <> PlayScene) then
    exit;

  if ssRight in Shift then begin
    if Shift = [ssRight] then
      Inc(DupSelection);  //겹쳤을 경우 선택
    target := PlayScene.GetAttackFocusCharacter(X, Y, DupSelection, sel, False);
    //모두..
    if DupSelection <> sel then
      DupSelection := 0;
    if target <> nil then begin
      if ssCtrl in Shift then begin //컨트롤+오른쪽클릭 = 상대 정보 보기
        //뛰다가 상대방 정보가 안나오게 하려고
        if GetTickCount - LastMoveTime > 1000 then begin
          if (target.Race = 0) and (not target.Death) then begin
            //상대방 정보 보기
            SendClientMessage(CM_QUERYUSERSTATE, target.RecogId,
              target.XX, target.YY, 0);
            exit;
          end;
        end;
      end;
    end else
      DupSelection := 0;

    PlayScene.CXYfromMouseXY(X, Y, MCX, MCY);
    if (abs(Myself.XX - MCX) <= 2) and (abs(Myself.YY - MCY) <= 2) then begin //방향턴
      tdir := GetNextDirection(Myself.XX, Myself.YY, MCX, MCY);
      if CanNextAction and ServerAcceptNextAction then begin
        Myself.SendMsg(CM_TURN, Myself.XX, Myself.YY, tdir, 0, 0, '', 0);
      end;
    end else begin //뛰기
      ChrAction := caRun;
      TargetX   := MCX;
      TargetY   := MCY;
      exit;
    end;
  end;

  if ssLeft in Shift {Button = mbLeft} then begin
    //공격... 넓은 범위로 선택됨
    target := PlayScene.GetAttackFocusCharacter(X, Y, DupSelection, sel, True);
    //살아있는 놈만..
    PlayScene.CXYfromMouseXY(X, Y, MCX, MCY);
    TargetCret := nil;

    if (UseItems[U_WEAPON].S.Name <> '') and (target = nil) then begin
      //곡괭이인지 검사
      if UseItems[U_WEAPON].S.Shape = 19 then begin //곡괭이
        tdir := GetNextDirection(Myself.XX, Myself.YY, MCX, MCY);
        GetFrontPosition(Myself.XX, Myself.YY, tdir, nx, ny);
        if not Map.CanMove(nx, ny) or (ssShift in Shift) then
        begin  //못 가는 곳은 곡괭이질 한다.
          if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
            Myself.SendMsg(CM_HIT + 1, Myself.XX, Myself.YY, tdir, 0, 0, '', 0);
          end;
          BoAutoDig := True;
          exit;
        end;
      end;
    end;

    if ssAlt in Shift then begin
      //고기 자르기
      tdir := GetNextDirection(Myself.XX, Myself.YY, MCX, MCY);
      if CanNextAction and ServerAcceptNextAction then begin
        //앞에 뭐가 있느냐에 따라서 동작이 달라짐

        //앞에 동물 시체가 있는 경우
        target := PlayScene.ButchAnimal(MCX, MCY);
        if target <> nil then begin
          SendButchAnimal(MCX, MCY, tdir, target.RecogId);
          Myself.SendMsg(CM_SITDOWN, Myself.XX, Myself.YY, tdir, 0, 0, '', 0);
          //자세는 같음
          exit;
        end;
        Myself.SendMsg(CM_SITDOWN, Myself.XX, Myself.YY, tdir, 0, 0, '', 0);
      end;
      TargetX := -1;
    end else begin
      if (target <> nil) or (ssShift in Shift) then begin

        //왼쪽마우스 클릭 또는 타겟이 있음.
        TargetX := -1;
        if target <> nil then begin
          //타겟이 있음.

          //걷다가 상인 메뉴가 나오는 것을 방지.
          if GetTickCount - LastMoveTime > 1500 then begin
            //상인인 경우,
            if target.Race = RCC_MERCHANT then begin
              SendClientMessage(CM_CLICKNPC, target.RecogId, 0, 0, 0);
              exit;
            end;
          end;

          if (not target.Death) then begin
            TargetCret := target;
            if ((target.Race <> 0) and (target.Race <> RCC_GUARD) and
              (target.Race <> RCC_GUARD2) and
              (target.Race <> RCC_MERCHANT) and
              (pos('(', target.UserName) =
              0) //주인없는 몹(있는 몹은 강제공격 해야함)
              ) or (ssShift in Shift) //사람을 실수로 공격하는 것을 막음
              or (target.NameColor = ENEMYCOLOR)   //적은 자동 공격이 됨
            then begin
              MagicTarget := target; // AutoTarget
              AutoTarget  := target; // AutoTarget
              AttackTarget(target);
              LatestHitTime := GetTickCount;
              // 2003/07/15 신규무공 추가
              if BoStopAfterAttack then begin
                BoStopAfterAttack := False;
                TargetCret := nil;
                AutoTarget := nil;
              end;
              if (target <> nil) and (ssShift in Shift) then
                AutoTarget := nil;
            end;
          end;
        end else begin
          tdir := GetNextDirection(Myself.XX, Myself.YY, MCX, MCY);
          if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
            hitmsg := CM_HIT + Random(3);
            if BoCanLongHit and (TargetInSwordLongAttackRange(tdir)) then
            begin  //롱 아텍인 경우
              hitmsg := CM_LONGHIT;
            end;
            if BoCanWideHit and (Myself.Abil.MP >= 3) and
              (TargetInSwordWideAttackRange(tdir)) then begin  //롱 아텍인 경우
              hitmsg := CM_WIDEHIT;
            end;
            if BoCanWideHit2 and (Myself.Abil.MP >= 3) and
              (TargetInSwordWideAttackRange(tdir)) then begin  //Assassin Skill 2
              hitmsg := CM_WIDEHIT2;
            end;
            if BoCanCrossHit and (Myself.Abil.MP >= 6) and
              (TargetInSwordCrossAttackRange(tdir)) then begin  //롱 아텍인 경우
              hitmsg := CM_CROSSHIT;
            end;
            Myself.SendMsg(hitmsg, Myself.XX, Myself.YY, tdir, 0, 0, '', 0);
          end;
          LastAttackTime := GetTickCount;
        end;
      end else begin
        if (MCX = Myself.XX) and (MCY = Myself.YY) then begin
          tdir := GetNextDirection(Myself.XX, Myself.YY, MCX, MCY);
          if CanNextAction and ServerAcceptNextAction then begin
            SendPickup; //줍기
          end;
        end else if GetTickCount - LastAttackTime > 1000 then
        begin //공격하는 클릭 실수이동을 방지
          if ssCtrl in Shift then begin
            ChrAction := caRun;
          end else begin
            ChrAction := caWalk;
          end;
          TargetX := MCX;
          TargetY := MCY;
        end;
      end;
    end;
  end;
end;

procedure TFrmMain.DXDraw1DblClick(Sender: TObject);
var
  pt: TPoint;
begin
  GetCursorPos(pt);
  if DWinMan.DblClick(pt.X, pt.Y) then
    exit;
end;

function TFrmmain.CheckDoorAction(dx, dy: integer): boolean;
var
  nx, ny, ndir, door: integer;
begin
  Result := False;
  //if not Map.CanMove (dx, dy) then begin
  //if (Abs(dx-Myself.XX) <= 2) and (Abs(dy-Myself.YY) <= 2) then begin
  door   := Map.GetDoor(dx, dy);
  if door > 0 then begin
    if not Map.IsDoorOpen(dx, dy) then begin
      SendClientMessage(CM_OPENDOOR, door, dx, dy, 0);
      Result := True;
    end;
  end;
  //end;
  //end;
end;

procedure TFrmMain.DXDraw1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if DWinMan.MouseUp(Button, Shift, X, Y) then
    exit;
  TargetX := -1;
end;

procedure TFrmMain.DXDraw1Click(Sender: TObject);
var
  pt: TPoint;
begin
  GetCursorPos(pt);
  if DWinMan.Click(pt.X, pt.Y) then
    exit;
end;

procedure TFrmMain.MouseTimerTimer(Sender: TObject);
var
  pt:    TPoint;
  keyvalue: TKeyBoardState;
  shift: TShiftState;
begin
  GetCursorPos(pt);
  SetCursorPos(pt.X, pt.Y);

  if TargetCret <> nil then begin
    if ActionKey > 0 then begin
      ProcessKeyMessages;
    end else begin
      if not TargetCret.Death and PlayScene.IsValidActor(TargetCret) then begin
        FillChar(keyvalue, sizeof(TKeyboardState), #0);
        if GetKeyboardState(keyvalue) then begin
          shift := [];
          if ((keyvalue[VK_SHIFT] and $80) <> 0) then
            shift := shift + [ssShift];
          if ((TargetCret.Race <> 0) and (TargetCret.Race <> RCC_GUARD) and
            (TargetCret.Race <> RCC_GUARD2) and
            (TargetCret.Race <> RCC_MERCHANT) and
            (pos('(', TargetCret.UserName) = 0) //주인있는 몹(강제공격 해야함)
            ) or (TargetCret.NameColor = ENEMYCOLOR)   //적은 자동 공격이 됨
            or ((ssShift in Shift) and (not PlayScene.EdChat.Visible)) then
          begin //사람을 실수로 공격하는 것을 막음
            AttackTarget(TargetCret);
          end; //else begin
               //TargetCret := nil;
               //end
        end;
      end else
        TargetCret := nil;
    end;
  end;
  if BoAutoDig then begin
    if CanNextAction and ServerAcceptNextAction and CanNextHit then begin
      Myself.SendMsg(CM_HIT + 1, Myself.XX, Myself.YY, Myself.Dir, 0, 0, '', 0);
    end;
  end;
end;

procedure TFrmMain.WaitMsgTimerTimer(Sender: TObject);
begin
  if Myself = nil then
    exit;
  if Myself.ActionFinished then begin
    WaitMsgTimer.Enabled := False;
    case WaitingMsg.Ident of
      SM_CHANGEMAP: begin
        FrmDlg.SafeCloseDlg;
        MapMovingWait := False;
        MapMoving     := False;
        //맵이 바뀌면 상점 메뉴를 닫는다.
        if MDlgX <> -1 then begin
          FrmDlg.CloseMDlg;
          MDlgX := -1;
        end;
        ClearDropItems;
        PlayScene.CleanObjects;
        MapTitle := '';
        PlayScene.SendMsg(SM_CHANGEMAP, 0,
          WaitingMsg.Param{x},
          WaitingMsg.tag{y},
          LOBYTE(WaitingMsg.Series){darkness}, // 용던젼
          0, 0, 0,
          WaitingStr{mapname});

        EffectNum := HIBYTE(WaitingMsg.Series);
        if EffectNum < 0 then
          EffectNum := 0;
        if (EffectNum = 1) or (EffectNum = 2) then
          RunEffectTimer.Enabled := True
        else
          RunEffectTimer.Enabled := False;

        Myself.CleanCharMapSetting(WaitingMsg.Param, WaitingMsg.Tag);
        //DScreen.AddSysMsg (IntToStr(WaitingMsg.Param) + ' ' +
        //                   IntToStr(WaitingMsg.Tag) + ' : My ' +
        //                   IntToStr(Myself.XX) + ' ' +
        //                   IntToStr(Myself.YY) + ' ' +
        //                   IntToStr(Myself.RX) + ' ' +
        //                   IntToStr(Myself.RY) + ' '
        //                  );
        TargetX    := -1;
        TargetCret := nil;
        FocusCret  := nil;

      end;
    end;
  end;
end;



{----------------------- Socket -----------------------}

procedure TFrmMain.SelChrWaitTimerTimer(Sender: TObject);
begin
  SelChrWaitTimer.Enabled := False;
  SendQueryChr;
end;

procedure TFrmMain.ActiveCmdTimer(cmd: TTimerCommand);
begin
  CmdTimer.Enabled := True;
  TimerCmd := cmd;
end;

procedure TFrmMain.CmdTimerTimer(Sender: TObject);
begin
  CmdTimer.Enabled  := False;
  CmdTimer.Interval := 1000;
  case TimerCmd of
    tcSoftClose: begin
      CmdTimer.Enabled := False;
      CSocket.Socket.Close;
    end;
    tcReSelConnect: begin
      //게임 변수 초기화...
      ResetGameVariables;

      DScreen.ChangeScene(stSelectChr);

      ConnectionStep := cnsReSelChr;
      if not BoOneClick then begin
        with CSocket do begin
          Active  := False;
          Address := SelChrAddr;
          Port    := SelChrPort;
          Active  := True;
        end;
      end else begin
        if CSocket.Socket.Connected then
          CSocket.Socket.SendText('$S' + SelChrAddr + '/' +
            IntToStr(SelChrPort) + '%');
        CmdTimer.Interval := 1;
        ActiveCmdTimer(tcFastQueryChr);
      end;
    end;
    tcFastQueryChr: begin
      SendQueryChr;
    end;
  end;
end;

procedure TFrmMain.CloseAllWindows;
begin
  with FrmDlg do begin
{      DItemBag.Visible := FALSE;
      DMsgDlg.Visible := FALSE;
      DStateWin.Visible := FALSE;
      DMerchantDlg.Visible := FALSE;
      DSellDlg.Visible := FALSE;
      DMenuDlg.Visible := FALSE;
      DKeySelDlg.Visible := FALSE;
      DGroupDlg.Visible := FALSE;
      DDealDlg.Visible := FALSE;
      DDealRemoteDlg.Visible := FALSE;
      DGuildDlg.Visible := FALSE;
      DGuildEditNotice.Visible := FALSE;
      DUserState1.Visible := FALSE;
      DAdjustAbility.Visible := FALSE;
      DFriendDlg.Visible := FALSE;
      DMailListDlg.Visible := FALSE;
      DMailDlg.Visible := FALSE;
      DBlockListDlg.Visible := FALSE;
      DMemo.Visible := FALSE;
      DMakeItemDlg.Visible := FALSE;
      DItemMarketDlg.Visible := FALSE;
      DJangwonListDlg.Visible := FALSE;
      DGABoardListDlg.Visible := FALSE;}

    CancelItemMoving;
    if DStateWin.Visible then
      DStateWin.Visible := False;
    if DUserState1.Visible then
      DUserState1.Visible := False;
    if DItemBag.Visible then
      DItemBag.Visible := False;
    if DMerchantDlg.Visible then
      CloseMDlg;
    if DSellDlg.Visible then
      CloseDSellDlg;
    if DGuildDlg.Visible then
      DGDCloseClick(nil, 0, 0);
    if DDealDlg.Visible then
      DDealCloseClick(nil, 0, 0);
    if DGroupDlg.Visible then
      DGrpDlgCloseClick(nil, 0, 0);
    if DMailListDlg.Visible then
      ToggleShowMailListDlg;
    if DFriendDlg.Visible then
      ToggleShowFriendsDlg;
    if DBlockListDlg.Visible then
      ToggleShowBlockListDlg;
    if DMemo.Visible then
      ToggleShowMemoDlg;
    if DMakeItemDlg.Visible then
      DMakeItemDlgOkClick(DMakeItemDlgCancel, 0, 0);
    if DItemMarketDlg.Visible then
      DItemMarketDlg.Visible := False;
    if DJangwonListDlg.Visible then
      DJangwonCloseClick(DJangwonClose, 0, 0);
    if DGABoardListDlg.Visible then
      DGABoardListCloseClick(DGABoardListClose, 0, 0);
    if DGABoardDlg.Visible then
      DGABoardCloseClick(DGABoardClose, 0, 0);
    if DGADecorateDlg.Visible then
      DGADecorateCloseClick(DGADecorateClose, 0, 0);
    if DMasterDlg.Visible then
      ToggleShowMasterDlg;
    DMsgDlg.Visible    := False;
    DMenuDlg.Visible   := False;
    DKeySelDlg.Visible := False;
    DDealRemoteDlg.Visible := False;
    DGuildEditNotice.Visible := False;
    DAdjustAbility.Visible := False;
    DMailDlg.Visible   := False;
  end;
  if MDlgX <> -1 then begin
    FrmDlg.CloseMDlg;
    MDlgX := -1;
  end;
  ItemMoving := False;

  BoMsgDlgTimeCheck      := False;
  FrmDlg.MsgDlgClickTime := GetTickCount;
end;

procedure TFrmMain.ClearDropItems;
var
  i: integer;
begin
  for i := 0 to DropedItemList.Count - 1 do
    Dispose(PTDropItem(DropedItemList[i]));
  DropedItemList.Clear;
end;

procedure TFrmMain.ResetGameVariables;
var
  i: integer;
begin
  CloseAllWindows;
  ClearDropItems;
  for i := 0 to MagicList.Count - 1 do
    Dispose(PTClientMagic(MagicList[i]));
  MagicList.Clear;
  ItemMoving := False;
  WaitingUseItem.Item.S.Name := '';
  EatingItem.S.Name := '';
  MovingItem.Item.S.Name := '';

  TargetX     := -1;
  TargetCret  := nil;
  FocusCret   := nil;
  MagicTarget := nil;
  ActionLock  := False;
  GroupMembers.Clear;
  GroupIdList.Clear;
  // 2003/04/15 친구, 쪽지
  for i := 0 to FriendMembers.Count - 1 do
    Dispose(PTFriend(FriendMembers[i]));
  FriendMembers.Clear;

  for i := 0 to BlackMembers.Count - 1 do
    Dispose(PTFriend(BlackMembers[i]));
  BlackMembers.Clear;

  BlockLists.Clear;
  for i := 0 to MailLists.Count - 1 do
    Dispose(PTMail(MailLists[i]));
  MailLists.Clear;
  WantMailList := False;

  //2003/07/08 연인사제
  fLover.Clear;

  GuildRankName := '';
  GuildName     := '';

  MapMoving     := False;
  WaitMsgTimer.Enabled := False;
  MapMovingWait := False;
  DScreen.ChatBoardTop := 0;
  BoNextTimePowerHit := False;
  BoNextTimeslashhit := False;
  BoCanLongHit  := False;
  BoCanWideHit  := False;
  BoCanWideHit2  := False;
  // 2003/03/15 신규무공
  BoCanCrosshit := False;
  BoCanTwinhit  := False;
  BoNextTimeFireHit := False;

  // 2003/03/15 인벤토리 확장
  FillChar(UseItems, sizeof(TClientItem) * 13, #0);        // 9->13
  FillChar(ItemArr, sizeof(TClientItem) * MAXBAGITEMCL, #0);

  with SelectChrScene do begin
    FillChar(ChrArr, sizeof(TSelChar) * 2, #0);
  //  ChrArr[0].FreezeState := True; //기본이 얼어 있는 상태
  //  ChrArr[1].FreezeState := True;
  end;
  PlayScene.ClearActors;
  ClearDropItems;
  EventMan.ClearEvents;
  PlayScene.CleanObjects;
  //DXDraw1RestoreSurface (self);
  Myself := nil;

  //위탁상점 초기화;
  g_Market.Clear;
end;

procedure TFrmMain.ChangeServerClearGameVariables;
var
  i: integer;
begin
  CloseAllWindows;
  ClearDropItems;
  for i := 0 to MagicList.Count - 1 do
    Dispose(PTClientMagic(MagicList[i]));
  MagicList.Clear;
  ItemMoving  := False;
  WaitingUseItem.Item.S.Name := '';
  EatingItem.S.Name := '';
  TargetX     := -1;
  TargetCret  := nil;
  FocusCret   := nil;
  MagicTarget := nil;
  ActionLock  := False;
  GroupMembers.Clear;
  GroupIdList.Clear;
  // 2003/04/15 친구, 쪽지
  for i := 0 to FriendMembers.Count - 1 do
    Dispose(PTFriend(FriendMembers[i]));
  FriendMembers.Clear;

  for i := 0 to BlackMembers.Count - 1 do
    Dispose(PTFriend(BlackMembers[i]));
  BlackMembers.Clear;

  BlockLists.Clear;
  for i := 0 to MailLists.Count - 1 do
    Dispose(PTMail(MailLists[i]));
  MailLists.Clear;
  WantMailList := False;

  //2003/07/08 연인사제
  fLover.Clear;

  GuildRankName := '';
  GuildName     := '';

  MapMoving     := False;
  WaitMsgTimer.Enabled := False;
  MapMovingWait := False;
  BoNextTimePowerHit := False;
  BoNextTimeslashhit := False;
  BoCanLongHit  := False;
  BoCanWideHit  := False;
  BoCanWideHit2  := False;
  // 2003/03/15 신규무공
  BoCanCrosshit := False;
  BoCanTwinhit  := False;

  ClearDropItems;
  EventMan.ClearEvents;
  PlayScene.CleanObjects;
end;

procedure TFrmMain.CSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  packet: array[0..255] of char;
  strbuf: array[0..255] of char;
  str:    string;
begin
  ServerConnected := True;
  if ConnectionStep = cnsLogin then begin
    if OneClickMode = toKornetWorld then begin  //코넷월드를 경유해서 게임에 접속
      FillChar(packet, 256, #0);
      str := 'KwGwMGS';
      StrPCopy(strbuf, str);
      Move(strbuf, (@packet[0])^, Length(str));
      str := 'CONNECT';
      StrPCopy(strbuf, str);
      Move(strbuf, (@packet[8])^, Length(str));
      str := KornetWorld.CPIPcode;
      StrPCopy(strbuf, str);
      Move(strbuf, (@packet[16])^, Length(str));
      str := KornetWorld.SVCcode;
      StrPCopy(strbuf, str);
      Move(strbuf, (@packet[32])^, Length(str));
      str := KornetWorld.LoginID;
      StrPCopy(strbuf, str);
      Move(strbuf, (@packet[48])^, Length(str));
      str := KornetWorld.CheckSum;
      StrPCopy(strbuf, str);
      Move(strbuf, (@packet[64])^, Length(str));
      Socket.SendBuf(packet, 256);
    end;
    DScreen.ChangeScene(stLogin);
    //SendVersionNumber;
  end;
  if ConnectionStep = cnsSelChr then begin
    LoginScene.OpenLoginDoor;
    SelChrWaitTimer.Enabled := True;
  end;
  if ConnectionStep = cnsReSelChr then begin
    CmdTimer.Interval := 1;
    ActiveCmdTimer(tcFastQueryChr);
  end;
  if ConnectionStep = cnsPlay then begin
    if not BoServerChanging then begin
      ClearBag;  //가방 초기화
      DScreen.ClearChatBoard; //채팅창 초기화
      DScreen.ChangeScene(stLoginNotice);
    end else begin
      ChangeServerClearGameVariables;
    end;
    SendRunLogin;
  end;
  SocStr    := '';
  BufferStr := '';
end;

procedure TFrmMain.CSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  ServerConnected := False;
  if (ConnectionStep = cnsLogin) and not BoWellLogin then begin
    FrmDlg.DMessageDlg('Connection closed...', [mbOK]);
    Close;
  end;
  if SoftClosed then begin
    SoftClosed := False;
    ActiveCmdTimer(tcReSelConnect);
  end;
end;

procedure TFrmMain.CSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.CSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  n: integer;
  Data, data2: string;
begin
  Data := Socket.ReceiveText;

  //DebugOutStr (data);
  //if pos('GOOD', data) > 0 then DScreen.AddSysMsg (data);

  n := pos('*', Data);
  if n > 0 then begin
    data2 := Copy(Data, 1, n - 1);
    Data  := data2 + Copy(Data, n + 1, Length(Data));
    //SendSocket ('*');
    CSocket.Socket.SendText('*');
  end;
  SocStr := SocStr + Data;
end;

{-------------------------------------------------------------}

procedure TFrmMain.SendSocket(sendstr: string);
const
  code: byte = 1;
begin
  //DebugOutStr (sendstr);
  if CSocket.Socket.Connected then begin
    CSocket.Socket.SendText('#' + IntToStr(code) + sendstr + '!');
    Inc(code);
    if code >= 10 then
      code := 1;
  end;
end;

procedure TFrmMain.SendClientMessage(msg, Recog, param, tag, series: integer);
var
  dmsg: TDefaultMessage;
begin
  dmsg := MakeDefaultMsg(msg, Recog, param, tag, series);
  SendSocket(EncodeMessage(dmsg));
end;

procedure TFrmMain.SendClientMessage2(msg, Recog, param, tag, series: integer;
  str: string);
var
  dmsg: TDefaultMessage;
begin
  dmsg := MakeDefaultMsg(msg, Recog, param, tag, series);
  SendSocket(EncodeMessage(dmsg) + EncodeString(str));
end;

procedure TFrmMain.SendVersionNumber;
var
  msg: TDefaultMessage;
begin
{   msg := MakeDefaultMsg (CM_PROTOCOL, ClientVersion, 0, 0, 0);
   SendSocket (EncodeMessage (msg));}
end;

procedure TFrmMain.SendLogin(uid, passwd: string);
var
  msg: TDefaultMessage;
begin
  LoginId := uid;
  LoginPasswd := passwd;
  msg := MakeDefaultMsg(CM_IDPASSWORD, ClientVersion, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(uid + '/' + passwd));
  BoWellLogin := True;
end;

procedure TFrmMain.SendNewAccount(ue: TUserEntryInfo; ua: TUserEntryAddInfo);
var
  msg: TDefaultMessage;
begin
  MakeNewId := ue.LoginId;
  msg := MakeDefaultMsg(CM_ADDNEWUSER, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeBuffer(@ue, sizeof(TUserEntryInfo)) +
    EncodeBuffer(@ua, sizeof(TUserEntryAddInfo)));
end;

procedure TFrmMain.SendUpdateAccount(ue: TUserEntryInfo; ua: TUserEntryAddInfo);
var
  msg: TDefaultMessage;
begin
  MakeNewId := ue.LoginId;
  msg := MakeDefaultMsg(CM_UPDATEUSER, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeBuffer(@ue, sizeof(TUserEntryInfo)) +
    EncodeBuffer(@ua, sizeof(TUserEntryAddInfo)));
end;

procedure TFrmMain.SendSelectServer(svname: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_SELECTSERVER, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(svname));
end;

procedure TFrmMain.SendChgPw(id, passwd, newpasswd: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_CHANGEPASSWORD, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(id + #9 + passwd + #9 + newpasswd));
end;

procedure TFrmMain.SendNewChr(uid, uname, shair, sjob, ssex: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_NEWCHR, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(uid + '/' + uname +
    '/' + shair + '/' + sjob + '/' + ssex));
end;

procedure TFrmMain.SendQueryChr;
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_QUERYCHR, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(LoginId + '/' +
    IntToStr(Certification)));
end;

procedure TFrmMain.SendDelChr(chrname: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_DELCHR, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(DecodeString(chrname)));
end;

procedure TFrmMain.SendSelChr(chrname: string);
var
  msg: TDefaultMessage;
begin
  CharName := DecodeString(chrname);
  msg      := MakeDefaultMsg(CM_SELCHR, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(LoginId + '/' +
    DecodeString(chrname)));
end;

procedure TFrmMain.SendRunLogin;
var
  msg: TDefaultMessage;
  str: string;
begin
  str := '**' + LoginId + '/' + CharName + '/' + IntToStr(Certification) +
    '/' + IntToStr(ClientVersion) + '/' + IntToStr(Certification xor $F2E44FFF) +
    '/' + IntToStr(pLocalFileCheckSum^) + '/' +
    IntToStr(Certification xor $a4a5b277) + '/' + '0';
  //if NewGameStart then begin
  //   str := str + '0';
  //   NewGameStart := FALSE;
  //end else str := str + '1';
  SendSocket(EncodeString(str));
end;

procedure TFrmMain.SendSay(str: string);
var
  msg: TDefaultMessage;
begin
  if str <> '' then begin
    // 너무 빨리 입력했다면
{      if (str[1] <> '@') and (( FSayTime + SAY_DELAY_TIME + length(str)*50 ) > GetTickCount ) then
      begin
        DScreen.AddChatBoardString ('Please type slowly.', clWhite, clRed);
        Exit;
      end;
      // 말한시간 입력
      FSayTime := GetTickCount;

      if str = '/check debug screen' then begin
         CheckBadMapMode := not CheckBadMapMode;
         if CheckBadMapMode then DScreen.AddSysMsg ('On')
         else DScreen.AddSysMsg ('Off');
         exit;
      end;}
    if str = '/check speedhack' then begin
      BoCheckSpeedHackDisplay := not BoCheckSpeedHackDisplay;
      exit;
    end;
    if str = '@password' then begin
      if PlayScene.EdChat.PasswordChar = #0 then
        PlayScene.EdChat.PasswordChar := '*'
      else
        PlayScene.EdChat.PasswordChar := #0;
      exit;
    end;
    msg := MakeDefaultMsg(CM_SAY, 0, 0, 0, 0);
    SendSocket(EncodeMessage(msg) + EncodeString(str));

    if str[1] = '/' then begin
      DScreen.AddChatBoardString(str, GetRGB(180), clWhite);
      GetValidStr3(Copy(str, 2, Length(str) - 1), WhisperName, [' ']);
    end //      else if (Copy(str,1,2) = '♡') then
    else if (Copy(str, 1, 2) = ':)') then
      if Copy(fLover.GetDisplay(0), length(STR_LOVER) + 1, 6) <> '' then
        DScreen.AddChatBoardString(MySelf.UserName + ': ' +
          Copy(str, 3, Length(str) - 2), GetRGB(253), clWhite);

    if BoOneTimePassword then begin
      BoOneTimePassword := False;
      PlayScene.EdChat.PasswordChar := #0;
    end;
  end;
end;

procedure TFrmMain.SendActMsg(ident, x, y, dir: integer);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(ident, MakeLong(x, y), 0, dir, 0);
  SendSocket(EncodeMessage(msg));
  ActionLock     := True; //서버에서 #+FAIL! 이나 #+GOOD!이 올때까지 기다림
  ActionLockTime := GetTickCount;
  Inc(SendCount);
end;

procedure TFrmMain.SendSpellMsg(ident, x, y, dir, target: integer);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(ident, MakeLong(x, y), Loword(target), dir, Hiword(target));
  SendSocket(EncodeMessage(msg));
  ActionLock     := True; //서버에서 #+FAIL! 이나 #+GOOD!이 올때까지 기다림
  ActionLockTime := GetTickCount;
  Inc(SendCount);
end;

procedure TFrmMain.SendQueryUserName(targetid, x, y: integer);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_QUERYUSERNAME, targetid, x, y, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendDropItem(Name: string; itemserverindex: integer);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_DROPITEM, itemserverindex, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Name));
end;

procedure TFrmMain.SendDropCountItem(iname: string; mindex, icount: integer);
var
  msg: TDefaultMessage;
begin

  msg := MakeDefaultMsg(CM_DROPCOUNTITEM, mindex, icount, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(iname));

end;

procedure TFrmMain.SendPickup;
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_PICKUP, 0, Myself.XX, Myself.YY, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendTakeOnItem(where: byte; itmindex: integer; itmname: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_TAKEONITEM, itmindex, where, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(itmname));
end;

procedure TFrmMain.SendTakeOffItem(where: byte; itmindex: integer; itmname: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_TAKEOFFITEM, itmindex, where, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(itmname));
end;

procedure TFrmMain.SendEat(itmindex: integer; itmname: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_EAT, itmindex, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(itmname));
end;

procedure TFrmMain.UpgradeItem(ItemIndex, jewelIndex: integer;
  StrItem, StrJewel: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_UPGRADEITEM, ItemIndex, Loword(jewelIndex),
    Hiword(jewelIndex), 0);
  SendSocket(EncodeMessage(msg) + EncodeString(StrItem + '/' + StrJewel));
end;

// 겹치기
procedure TFrmMain.SendItemSumCount(OrgItemIndex, ExItemIndex: integer;
  StrOrgItem, StrExItem: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_ITEMSUMCOUNT, OrgItemIndex, Loword(ExItemIndex),
    Hiword(ExItemIndex), 0);
  SendSocket(EncodeMessage(msg) + EncodeString(StrOrgItem + '/' + StrExItem));
end;

procedure TFrmMain.UpgradeItemResult(ItemIndex: integer; wResult: word; str: string);
begin
  FrmDlg.UpgradeItemEffect(wResult);
  PlaySound(10310);  // s_deal_additem

end;

procedure TFrmMain.SendButchAnimal(x, y, dir, actorid: integer);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_BUTCH, actorid, x, y, dir);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendMagicKeyChange(magid: integer; keych: char);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_MAGICKEYCHANGE, magid, byte(keych), 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendMerchantDlgSelect(merchant: integer; rstr: string);
var
  msg:   TDefaultMessage;
  param: string;
begin
  if Length(rstr) >= 2 then begin  //파라메타가 필요한 경우가 있음.
    if (rstr[1] = '@') and (rstr[2] = '@') then begin
      if rstr = '@@AgitForSale' then
        FrmDlg.DMessageDlg(
          'Please insert the desired sale price for the guild territory.',
          [mbOK, mbAbort])
      else if rstr = '@@AgitOneRecall' then
        FrmDlg.DMessageDlg(
          'Please insert the name of the guild member you want to summon.',
          [mbOK, mbAbort])
      else if rstr = '@@buildguildnow' then begin
        MsgDlgMaxStr := 20;
        FrmDlg.DMessageDlg('Please type the name for your new Guild.',
          [mbOK, mbAbort]);
        MsgDlgMaxStr := 30;
      end else
        FrmDlg.DMessageDlg('Please input.', [mbOK, mbAbort]);
      param := Trim(FrmDlg.DlgEditText);
      rstr  := rstr + #13 + param;
    end;
  end;
  msg := MakeDefaultMsg(CM_MERCHANTDLGSELECT, merchant, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(rstr));
end;

procedure TFrmMain.SendQueryPrice(merchant, ItemIndex: integer; itemname: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_MERCHANTQUERYSELLPRICE, merchant,
    Loword(ItemIndex), Hiword(ItemIndex), 0);
  SendSocket(EncodeMessage(msg) + EncodeString(itemname));
end;

procedure TFrmMain.SendQueryRepairCost(merchant, ItemIndex: integer; itemname: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_MERCHANTQUERYREPAIRCOST, merchant,
    Loword(ItemIndex), Hiword(ItemIndex), 0);
  SendSocket(EncodeMessage(msg) + EncodeString(itemname));
end;

procedure TFrmMain.SendSellItem(merchant, ItemIndex: integer;
  itemname: string; Count: word);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_USERSELLITEM, merchant, Loword(ItemIndex),
    Hiword(ItemIndex), Count);
  SendSocket(EncodeMessage(msg) + EncodeString(itemname));
end;

procedure TFrmMain.SendRepairItem(merchant, ItemIndex: integer; itemname: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_USERREPAIRITEM, merchant, Loword(ItemIndex),
    Hiword(ItemIndex), 0);
  SendSocket(EncodeMessage(msg) + EncodeString(itemname));
end;

procedure TFrmMain.SendStorageItem(merchant, ItemIndex: integer;
  itemname: string; Count: word);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_USERSTORAGEITEM, merchant, Loword(ItemIndex),
    Hiword(ItemIndex), Count);
  SendSocket(EncodeMessage(msg) + EncodeString(itemname));
end;

procedure TFrmMain.SendMaketSellItem(merchant, ItemIndex: integer;
  price: string; Count: word);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_MARKET_SELL, merchant, Loword(ItemIndex),
    Hiword(ItemIndex), Count);
  SendSocket(EncodeMessage(msg) + EncodeString(price));
end;

procedure TFrmMain.SendGetDetailItem(merchant, menuindex: integer; itemname: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_USERGETDETAILITEM, merchant, menuindex, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(itemname));
end;

procedure TFrmMain.SendGetJangwonList(Page: integer);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_GUILDAGITLIST, Page, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendGABoardRead(Body: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_GABOARD_READ, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Body));
end;

procedure TFrmMain.SendGetMarketPageList(merchant, pagetype: integer; itemname: string);
var // Market System..
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_MARKET_LIST, merchant, pagetype, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(itemname));
end;

procedure TFrmMain.SendBuyMarket(merchant, sellindex: integer);
var // Market System..
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_MARKET_BUY, merchant, Loword(sellindex),
    Hiword(sellindex), 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendCancelMarket(merchant, sellindex: integer);
var // Market System..
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_MARKET_CANCEL, merchant, Loword(sellindex),
    Hiword(sellindex), 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendGetPayMarket(merchant, sellindex: integer);
var // Market System..
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_MARKET_GETPAY, merchant, Loword(sellindex),
    Hiword(sellindex), 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendMarketClose;
var // Market System..
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_MARKET_CLOSE, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendBuyItem(merchant, itemserverindex: integer;
  itemname: string; Count: word);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_USERBUYITEM, merchant, Loword(itemserverindex),
    Hiword(itemserverindex), Count);
  SendSocket(EncodeMessage(msg) + EncodeString(itemname));
end;

procedure TFrmMain.SendBuyDecoItem(merchant, DecoItemNum: integer);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_DECOITEM_BUY, merchant, Loword(DecoItemNum),
    Hiword(DecoItemNum), 1);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendTakeBackStorageItem(merchant, itemserverindex: integer;
  itemname: string; Count: word);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_USERTAKEBACKSTORAGEITEM, merchant,
    Loword(itemserverindex), Hiword(itemserverindex), Count);
  SendSocket(EncodeMessage(msg) + EncodeString(itemname));
end;

procedure TFrmMain.SendMakeDrugItem(merchant: integer; itemname: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_USERMAKEDRUGITEM, merchant, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(itemname));
end;

procedure TFrmMain.SendMakeItemSel(merchant: integer; itemname: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_USERMAKEITEMSEL, merchant, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(itemname));
end;
// 제조
procedure TFrmMain.SendMakeItem(merchant: integer; Data: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_USERMAKEITEM, merchant, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Data));
end;

procedure TFrmMain.SendDropGold(dropgold: integer);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_DROPGOLD, dropgold, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendGroupMode(onoff: boolean);
var
  msg: TDefaultMessage;
begin
  if onoff then
    msg := MakeDefaultMsg(CM_GROUPMODE, 0, 1, 0, 0)   //on
  else
    msg := MakeDefaultMsg(CM_GROUPMODE, 0, 0, 0, 0);  //off
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendCreateGroup(withwho: string);
var
  msg: TDefaultMessage;
begin
  if withwho <> '' then begin
    msg := MakeDefaultMsg(CM_CREATEGROUP, 0, 0, 0, 0);
    SendSocket(EncodeMessage(msg) + EncodeString(withwho));
    DScreen.AddChatBoardString('You asked ' + withwho + ' to join my group',
      TColor($BB840F), clWhite);
  end;
end;

procedure TFrmMain.SendWantMiniMap;
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_WANTMINIMAP, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendDealTry;
var
  msg:    TDefaultMessage;
  i, fx, fy: integer;
  actor:  TActor;
  who:    string;
  proper: boolean;
begin
   (*proper := FALSE;
   GetFrontPosition (Myself.XX, Myself.YY, Myself.Dir, fx, fy);
   with PlayScene do
      for i:=0 to ActorList.Count-1 do begin
         actor := TActor (ActorList[i]);
         if {(actor.Race = 0) and} (actor.XX = fx) and (actor.YY = fy) then begin
            proper := TRUE;
            who := actor.UserName;
            break;
         end;
      end;
   if proper then begin*)
  msg := MakeDefaultMsg(CM_DEALTRY, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(who));
  //end;
end;

procedure TFrmMain.SendGuildDlg;
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_OPENGUILDDLG, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendCancelDeal;
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_DEALCANCEL, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendAddDealItem(ci: TClientItem);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_DEALADDITEM, ci.MakeIndex, 0, 0, ci.Dura);
  SendSocket(EncodeMessage(msg) + EncodeString(ci.S.Name));
end;

procedure TFrmMain.SendDelDealItem(ci: TClientItem);
var
  msg: TDefaultMessage;
begin

  msg := MakeDefaultMsg(CM_DEALDELITEM, ci.MakeIndex, 0, 0, ci.Dura);
  SendSocket(EncodeMessage(msg) + EncodeString(ci.S.Name));
end;

procedure TFrmMain.SendChangeDealGold(gold: integer);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_DEALCHGGOLD, gold, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendDealEnd;
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_DEALEND, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendAddGroupMember(withwho: string);
var
  msg: TDefaultMessage;
begin
  if withwho <> '' then begin
    msg := MakeDefaultMsg(CM_ADDGROUPMEMBER, 0, 0, 0, 0);
    SendSocket(EncodeMessage(msg) + EncodeString(withwho));
    DScreen.AddChatBoardString('You asked ' + withwho + ' to join my group',
      TColor($BB840F), clWhite);
  end;
end;

procedure TFrmMain.SendDelGroupMember(withwho: string);
var
  msg: TDefaultMessage;
begin
  if withwho <> '' then begin
    msg := MakeDefaultMsg(CM_DELGROUPMEMBER, 0, 0, 0, 0);
    SendSocket(EncodeMessage(msg) + EncodeString(withwho));
  end;
end;

procedure TFrmMain.SendGuildHome;
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_GUILDHOME, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendGuildMemberList;
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_GUILDMEMBERLIST, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendGuildAddMem(who: string);
var
  msg: TDefaultMessage;
begin
  if Trim(who) <> '' then begin
    msg := MakeDefaultMsg(CM_GUILDADDMEMBER, 0, 0, 0, 0);
    SendSocket(EncodeMessage(msg) + EncodeString(who));
  end;
end;

procedure TFrmMain.SendGuildDelMem(who: string);
var
  msg: TDefaultMessage;
begin
  if Trim(who) <> '' then begin
    msg := MakeDefaultMsg(CM_GUILDDELMEMBER, 0, 0, 0, 0);
    SendSocket(EncodeMessage(msg) + EncodeString(who));
  end;
end;

//문자열의 길이가 너무길지 않도록 짤려서 온다.
procedure TFrmMain.SendGuildUpdateNotice(notices: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_GUILDUPDATENOTICE, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(notices));
end;

procedure TFrmMain.SendGABoardUpdateNotice(notice, CurPage: integer; bodyText: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_GABOARD_ADD, notice, CurPage, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(bodyText));
end;

procedure TFrmMain.SendGABoardModify(CurPage: integer; bodyText: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_GABOARD_EDIT, 0, CurPage, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(bodyText));
end;

procedure TFrmMain.SendGetGABoardList(Page: integer);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_GABOARD_LIST, Page, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendGABoardNoticeCheck;
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_GABOARD_NOTICE_CHECK, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendGABoardDel(CurPage: integer; bodyText: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_GABOARD_DEL, 0, CurPage, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(bodyText));
end;

procedure TFrmMain.SendGuildUpdateGrade(rankinfo: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_GUILDUPDATERANKINFO, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(rankinfo));
end;

procedure TFrmMain.SendSpeedHackUser(code: integer);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_SPEEDHACKUSER, code, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendAdjustBonus(remain: integer; babil: TNakedAbility);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_ADJUST_BONUS, remain, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeBuffer(@babil, sizeof(TNakedAbility)));
end;


{---------------------------------------------------------------}


function TFrmMain.ServerAcceptNextAction: boolean;
begin
  Result := True;
  //이전 행동이 서버에서 인정되었는지
  if ActionLock then begin
    if GetTickCount - ActionLockTime > 10 * 1000 then begin
      ActionLock := False;
      //Dec (WarningLevel);
    end;
    Result := False;
  end;
end;

function TFrmMain.CanNextAction: boolean;
begin
  if (Myself.IsIdle) and (Myself.State and $04000000 = 0) and
    // 2003/07/15 신규무공, 상태이상 추가...결빙
    (Myself.State and $20000000 = 0) and (GetTickCount - DizzyDelayStart >
    DizzyDelayTime) then begin
    Result := True;
  end else
    Result := False;
end;

function TFrmMain.CanNextHit: boolean;  //꼭 사용하기 직전에 호출해야 함.
var
  nexthit, levelfast: integer;
begin
  levelfast := _MIN(370, (Myself.Abil.Level * 14));
  levelfast := _MIN(800, levelfast + Myself.HitSpeed * 60);
  if BoAttackSlow then
    nexthit := 1400 - levelfast + 1500 //너무 많이 들었거나, 옷이 너무 무거움.
  else
    nexthit := 1400 - levelfast;
  if nexthit < 0 then
    nexthit := 0;
  if GetTickCount - LastHitTime > longword(nexthit) then begin
    LastHitTime := GetTickCount;
    Result      := True;
  end else
    Result := False;
end;

procedure TFrmMain.ActionFailed;
begin
  TargetX := -1;
  TargetY := -1;
  ActionFailLock := True; //같은 방향으로 연속이동실패를 막기위해서, FailDir과 함께 사용
  Myself.MoveFail;
end;

function TFrmMain.IsUnLockAction(action, adir: integer): boolean;
begin
  if (ActionFailLock and (action = FailAction) and (adir = FailDir) and
    (GetTickCount - FailActionTime < 1000)) or (MapMoving) or (BoServerChanging) then
  begin
    Result := False;
  end else begin
    ActionFailLock := False;
    Result := True;
  end;
end;

function TFrmMain.IsGroupMember(uname: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to GroupMembers.Count - 1 do
    if GroupMembers[i] = uname then begin
      Result := True;
      break;
    end;
end;

{-------------------------------------------------------------}

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  str, Data: string;
  len, i, n, mcnt: integer;
const
  busy: boolean = False;
begin
  if busy then
    exit;
  //if ServerConnected then
  //   DxTimer.Enabled := TRUE
  //else
  //   DxTimer.Enabled := FALSE;

  busy := True;
  try
    BufferStr := BufferStr + SocStr;
    SocStr    := '';
    if BufferStr <> '' then begin
      mcnt := 0;
      while Length(BufferStr) >= 2 do begin
        if MapMovingWait then
          break; // 대기..
        if Pos('!', BufferStr) <= 0 then
          break;
        BufferStr := ArrestStringEx(BufferStr, '#', '!', Data);
        if Data <> '' then begin
          DecodeMessagePacket(Data);
        end else if Pos('!', BufferStr) = 0 then
          break;
      end;
    end;
  finally
    busy := False;
  end;

  if WarningLevel > 30 then begin
    FrmMain.Close;
  end;

  if BoQueryPrice then begin
    if GetTickCount - QueryPriceTime > 500 then begin
      BoQueryPrice := False;
      case FrmDlg.SpotDlgMode of
        dmSell: SendQueryPrice(CurMerchant, SellDlgItem.MakeIndex,
            SellDlgItem.S.Name);
        dmRepair: SendQueryRepairCost(CurMerchant, SellDlgItem.MakeIndex,
            SellDlgItem.S.Name);
      end;
    end;
  end;

  if BonusPoint > 0 then begin
    FrmDlg.DBotPlusAbil.Visible := True;
  end else begin
    FrmDlg.DBotPlusAbil.Visible := False;
  end;

end;

procedure TFrmMain.MsgProg;
var
  str, Data: string;
  len, i, n, mcnt: integer;
const
  busy: boolean = False;
begin
  if busy then
    exit;
  //if ServerConnected then
  //   DxTimer.Enabled := TRUE
  //else
  //   DxTimer.Enabled := FALSE;

  busy := True;
  try
    BufferStr := BufferStr + SocStr;
    SocStr    := '';
    if BufferStr <> '' then begin
      mcnt := 0;
      while Length(BufferStr) >= 2 do begin
        if MapMovingWait then
          break; // 대기..
        if Pos('!', BufferStr) <= 0 then
          break;
        BufferStr := ArrestStringEx(BufferStr, '#', '!', Data);
        if Data <> '' then begin
          DecodeMessagePacket(Data);
        end else if Pos('!', BufferStr) = 0 then
          break;
      end;
    end;
  finally
    busy := False;
  end;

  if WarningLevel > 30 then begin
    FrmMain.Close;
  end;

  if BoQueryPrice then begin
    if GetTickCount - QueryPriceTime > 500 then begin
      BoQueryPrice := False;
      case FrmDlg.SpotDlgMode of
        dmSell: SendQueryPrice(CurMerchant, SellDlgItem.MakeIndex,
            SellDlgItem.S.Name);
        dmRepair: SendQueryRepairCost(CurMerchant, SellDlgItem.MakeIndex,
            SellDlgItem.S.Name);
      end;
    end;
  end;

  if BonusPoint > 0 then begin
    FrmDlg.DBotPlusAbil.Visible := True;
  end else begin
    FrmDlg.DBotPlusAbil.Visible := False;
  end;

end;

procedure TFrmMain.SpeedHackTimerTimer(Sender: TObject);
var
  gcount, timer: longword;
  ahour, amin, asec, amsec: word;
begin
  DecodeTime(Time, ahour, amin, asec, amsec);
  timer  := ahour * 1000 * 60 * 60 + amin * 1000 * 60 + asec * 1000 + amsec;
  gcount := GetTickCount;
  if SHGetTime > 0 then begin
    if abs((gcount - SHGetTime) - (timer - SHTimerTime)) > 70 then begin
      Inc(SHFakeCount);
    end else
      SHFakeCount := 0;

    if SHFakeCount > 2 then begin
      if not SpeedHackUse then begin
        SendSpeedHackUser(10001);
        SpeedHackUse := True;
      end;
      FrmDlg.DMessageDlg('Terminate the program. CODE=10001\' +
        'Please contact game master.',
        [mbOK]);
      FrmMain.Close;
    end;
    if BoCheckSpeedHackDisplay then begin
      DScreen.AddSysMsg('->' + IntToStr(gcount - SHGetTime) +
        ' - ' + IntToStr(timer - SHTimerTime) + ' = ' +
        IntToStr(abs((gcount - SHGetTime) - (timer - SHTimerTime))) +
        ' (' + IntToStr(SHFakeCount) + ')');
    end;
  end;
  SHGetTime   := gcount;
  SHTimerTime := timer;
end;

procedure TFrmMain.FindWHHackTimerTimer(Sender: TObject);
var
  v0, v1, v2, v3: integer;
begin
  if Myself <> nil then begin
    // 해킹 회피 검사
    v0 := Myself.Abil.Level * HIT_INCLEVEL + abs(Myself.HitSpeed) *
      HIT_INCSPEED + Myself.Abil.Weight + Myself.Abil.MaxWeight +
      Myself.Abil.WearWeight + Myself.Abil.MaxWearWeight +
      Myself.Abil.HandWeight + Myself.Abil.MaxHandWeight + RUN_STRUCK_DELAY;

    v1 := HitCheckSum1;
    v2 := (longword(pHitCheckSum2^) xor $FFFFFFFF) div 4;
    v3 := (longword(pHitCheckSum3^) xor $FFFFFFFF) div 20;
    ////
    if (v0 = v1) and (v0 = v2) and (v0 = v3) then begin
      ;
    end else begin
      //메모리를 해킹했음...
      FrmMain.Close;
      exit;
    end;
  end;
end;


procedure TFrmMain.CheckSpeedHack(rtime: longword);
var
  cltime, svtime: integer;
  str: string;
begin
  if FirstServerTime > 0 then begin
    if (GetTickCount - FirstClientTime) > 10 * 60 * 1000 then begin  //30분 마다 초기화
      FirstServerTime := rtime; //초기화
      FirstClientTime := GetTickCount;
      //ServerTimeGap := rtime - int64(GetTickCount);
    end;
    cltime := GetTickCount - FirstClientTime;
    svtime := rtime - FirstServerTime;// + 3000;

    if cltime > (svtime + 5000) then begin  //렉을 감안함
      Inc(TimeFakeDetectCount);
      if TimeFakeDetectCount > 5 then begin
        //시간조작...
        str := 'Bad';
        if not SpeedHackUse then begin
          SendSpeedHackUser(10000);
          SpeedHackUse := True;
        end;
        FrmDlg.DMessageDlg('terminate the program. CODE=10000\' +
          'Connection is bad or system is unstable.\' +
          'Please contact game master.',
          [mbOK]);
        FrmMain.Close;
      end;
    end else begin
      str := 'Good';
      TimeFakeDetectCount := 0;
    end;
    if BoCheckSpeedHackDisplay then begin
      DScreen.AddSysMsg(IntToStr(svtime) + ' - ' + IntToStr(cltime) +
        ' = ' + IntToStr(svtime - cltime) + ' ' + str);
    end;
  end else begin
    FirstServerTime := rtime;
    FirstClientTime := GetTickCount;
    //ServerTimeGap := int64(GetTickCount) - longword(msg.Recog);
  end;
end;

procedure TFrmMain.CheckSpeedHackChina(stime: longword);
begin

end;

procedure TFrmMain.DecodeMessagePacket(datablock: string); //@@@@
var
  head, body, body2, tagstr, Data, rdstr, str: string;
  msg:   TDefaultMessage;
  smsg:  TShortMessage;
  mbw:   TMessageBodyW;
  desc:  TCharDesc;
  wl:    TMessageBodyWL;
  featureEx, wd: word;
  L, i, j, n, BLKSize, param, sound, cltime, svtime, idx: integer;
  tempb, AddCheck: boolean;
  actor: TActor;
  event: TClEvent;
begin
  if datablock[1] = '+' then begin  //checkcode
    Data := Copy(datablock, 2, Length(datablock) - 1);
    Data := GetValidStr3(Data, tagstr, ['/']);
    if tagstr = 'PWR' then
      BoNextTimePowerHit := True;  //다음번에 powerhit을 때릴 수 있음...
    if tagstr = 'SLS' then
      BoNextTimeslashhit := True; //Slash
    if tagstr = 'LNG' then
      BoCanLongHit := True;
    if tagstr = 'ULNG' then
      BoCanLongHit := False;
    if tagstr = 'WID' then
      BoCanWideHit := True;
    if tagstr = 'WID2' then
      BoCanWideHit2 := True; //Assassin Skill 2  ON
    if tagstr = 'UWID' then
      BoCanWideHit := False;
    if tagstr = 'UWID2' then
      BoCanWideHit2 := False;  //Assassin Skill 2  OFF
    if tagstr = 'CRS' then
      BoCanCrossHit := True;
    if tagstr = 'UCRS' then
      BoCanCrossHit := False;
    // 2003/07/15 신규무공 추가
    if tagstr = 'TWN' then
      BoCanTwinHit := True;
    if tagstr = 'UTWN' then
      BoCanTwinHit := False;
    if tagstr = 'FIR' then begin
      BoNextTimeFireHit := True;  //염화결이 세팅된 상태
      LatestFireHitTime := GetTickCount;
      //Myself.SendMsg (SM_READYFIREHIT, Myself.XX, Myself.YY, Myself.Dir, 0, 0, '', 0);
    end;
    if tagstr = 'STN' then
      BoCanStoneHit := True;
    if tagstr = 'USTN' then
      BoCanStoneHit := False;

    if tagstr = 'UFIR' then
      BoNextTimeFireHit := False;
    if tagstr = 'GOOD' then begin
      ActionLock := False;
      Inc(ReceiveCount);
    end;
    if tagstr = 'FAIL' then begin
      ActionFailed;
      ActionLock := False;
      Inc(ReceiveCount);
    end;
    //DScreen.AddSysmsg (data);
    if Data <> '' then begin
      Data := GetValidStr3(Data, tagstr, ['/']);
      CheckSpeedHack(Str_ToInt(tagstr, 0));
      if Data <> '' then begin
        if Myself.HitSpeed <> Str_ToInt(Data, 0) then begin
          Inc(SHHitSpeedCount);
          if SHHitSpeedCount > 3 then begin
            DScreen.AddChatBoardString(
              'You are currently using Hacking Tool. Please stop using.',
              clYellow, clRed);
          end;
          Myself.HitSpeed := Str_ToInt(Data, 0);

          if SHHitSpeedCount > 6 then begin
            if not SpeedHackUse then begin
              SendSpeedHackUser(10002);
              SpeedHackUse := True;
            end;
            FrmDlg.DMessageDlg('Terminate the program. CODE=10002\' +
              'Please contact game master.',
              [mbOK]);
            FrmMain.Close;
          end;
        end else begin
          if SHHitSpeedCount > 0 then
            Dec(SHHitSpeedCount);
        end;
      end;
    end;
    exit;
  end;
  if Length(datablock) < DEFBLOCKSIZE then begin
    if datablock[1] = '=' then begin
      Data := Copy(datablock, 2, Length(datablock) - 1);
      if Data = 'DIG' then begin
        Myself.BoDigFragment := True;
      end;
    end;
    exit;
  end;

  head := Copy(datablock, 1, DEFBLOCKSIZE);
  body := Copy(datablock, DEFBLOCKSIZE + 1, Length(datablock) - DEFBLOCKSIZE);
  msg  := DecodeMessage(head);

  //DScreen.AddSysMsg (IntToStr(msg.Ident));

  if msg.Ident = SM_DAYCHANGING then begin
    DayBright_fake := msg.Param;
    DarkLevel_fake := msg.Tag;
  end;

  if Myself = nil then begin
    case msg.Ident of
      SM_NEWID_SUCCESS: begin
        FrmDlg.DMessageDlg(
          'Your account is now created.\ Please store your account and password in a safe place\'
          + 'and do not reveal them to anyone for any reason.\ If you forget your password,\'
          + 'you can retrieve it through our home page.\' +
          '(http://www.mir2.com.ph)', [mbOK]);
      end;
      SM_NEWID_FAIL: begin
        case msg.Recog of
          0: begin
            FrmDlg.DMessageDlg('"' + MakeNewId +
              '"is already used by another player.\' +
              'Please use a defferent name.',
              [mbOK]);
            LoginScene.NewIdRetry(False);  //다시 시도
          end;
          -2: FrmDlg.DMessageDlg(
              'On this server, this new ID is not permitted.\Please contact us.',
              [mbOK]);
          else
            FrmDlg.DMessageDlg(
              'ID creation Faliled. Please check it does not contain space,\ special characters, or an illegible letter.',
              [mbOK]);
        end;
      end;
      SM_PASSWD_FAIL: begin
        case msg.Recog of
          -1: FrmDlg.DMessageDlg('Wrong Password.', [mbOK]);
          -2: FrmDlg.DMessageDlg(
              'Wrong Password 3 times in a row.\You will not be able to connect for a while.',
              [mbOK]);
          -3: FrmDlg.DMessageDlg(
              'This account is actually in use or locked by abnormal terminaion.\Please try again later.',
              [mbOK]);
          -4: FrmDlg.DMessageDlg(
              'This account has no access rights.\please change account,\or apply for paid registration.',
              [mbOK]);
          -5: FrmDlg.DMessageDlg('Your account has expired or it may have been suspended',
              [mbOK]);
          else
            FrmDlg.DMessageDlg('ID does not exist or unknown error.', [mbOK]);
        end;
        LoginScene.PassWdFail;
      end;
      SM_NEEDUPDATE_ACCOUNT: //계정 정보를 다시 입력하라.
      begin
        ClientGetNeedUpdateAccount(body);
      end;
      SM_UPDATEID_SUCCESS: begin
        FrmDlg.DMessageDlg(
          'Your account is now updated.\Please store your account and password in a safe place\and do not reveal them to anyone for any reason.\if you forget your password, you can retrieve it through our home page.\(http://www.mir2.com.ph)' + 'and do not reveal them to anyone for any reason.\ If you forget your password,\' + 'you can retrieve it through our home page.\' + '(http://www.mir2.com.ph)', [mbOK]);
        ClientGetSelectServer;
      end;
      SM_UPDATEID_FAIL: begin
        FrmDlg.DMessageDlg('Updating account failed.', [mbOK]);
        ClientGetSelectServer;
      end;
      SM_PASSOK_SELECTSERVER: begin
        AvailIDDay  := Loword(msg.Recog);
        AvailIDHour := Hiword(msg.Recog);
        AvailIPDay  := msg.Param;
        AvailIPHour := msg.Tag;

        if AvailIDDay > 0 then begin
          if AvailIDDay = 1 then
            FrmDlg.DMessageDlg(
              'Your personal account will be ended Today.', [mbOK])
          else if AvailIDDay <= 3 then
            FrmDlg.DMessageDlg('the period of your personal account' +
              IntToStr(AvailIDDay) + 'remain days.', [mbOK]);
        end else if AvailIPDay > 0 then begin
          if AvailIPDay = 1 then
            FrmDlg.DMessageDlg(
              'the remained period of using IP will be ended today.', [mbOK])
          else if AvailIPDay <= 3 then
            FrmDlg.DMessageDlg('the period of using IP  ' +
              IntToStr(AvailIPDay) + 'remain days.', [mbOK]);
        end else if AvailIPHour > 0 then begin
          if AvailIPHour <= 100 then
            FrmDlg.DMessageDlg('the period of IP ' +
              IntToStr(AvailIPHour) + ' remain hours.', [mbOK]);
        end else if AvailIDHour > 0 then begin
          FrmDlg.DMessageDlg('the period of personal account' +
            IntToStr(AvailIDHour) + ' remain hours.', [mbOK]);
          ;
        end;

        if not LoginScene.BoUpdateAccountMode then
          ClientGetSelectServer;
      end;
      SM_SELECTSERVER_OK: begin
        ClientGetPasswdSuccess(body);
      end;

      SM_QUERYCHR: begin
        ClientGetReceiveChrs(body);
      end;
      SM_QUERYCHR_FAIL: begin
        DoFastFadeOut := False;
        DoFadeIn      := False;
        DoFadeOut     := False;
        FrmDlg.DMessageDlg('Fatal error! Server verification failed.', [mbOK]);
        Close;
      end;
      SM_NEWCHR_SUCCESS: begin
        SendQueryChr;
      end;
      SM_NEWCHR_FAIL: begin
        case msg.Recog of
          2: FrmDlg.DMessageDlg('[failure] This name already exists', [mbOK]);
          3: FrmDlg.DMessageDlg(
              '[Failure] You cannot make two character for one account.\Please contact to game master.',
              [mbOK]);
          4: FrmDlg.DMessageDlg(
              '[failure] Character creating failure. Error=4', [mbOK]);
          else
            FrmDlg.DMessageDlg(
              '[Failure] Unknow error. Please Email: mir2support@okeydokey.com.ph',
              [mbOK]);
        end;
      end;
      SM_CHGPASSWD_SUCCESS: begin
        FrmDlg.DMessageDlg('Password changed successfully.', [mbOK]);
      end;
      SM_CHGPASSWD_FAIL: begin
        case msg.Recog of
          -1: FrmDlg.DMessageDlg('Wrong password. Password cannot be changed.', [mbOK]);
          -2: FrmDlg.DMessageDlg('Account is locked . Try again in a while.', [mbOK]);
          else
            FrmDlg.DMessageDlg(
              'Password is less than four digits, you cannot change it.', [mbOK]);
        end;
      end;
      SM_DELCHR_SUCCESS: begin
        SendQueryChr;
      end;
      SM_DELCHR_FAIL: begin
        FrmDlg.DMessageDlg(
          '[Failure] Erasing character failure, Email: mir2support@okeydokey.com.ph',
          [mbOK]);
      end;
      SM_STARTPLAY: begin
        ClientGetStartPlay(body);
        exit;
      end;
      SM_STARTFAIL: begin
        LoginScene.HideLoginBox;
        FrmDlg.DMessageDlg(
          '접속량의 폭주로 인하여 연결이 끊어졌습니다.', [mbOK]);
        //'Connection cancelled by unexpected problem in server.', 
        FrmMain.Close;
        exit;
      end;
      SM_VERSION_FAIL: begin
        LoginScene.HideLoginBox;
        FrmDlg.DMessageDlg(
          'Wrong version. Please download latest version. (http://www.mir2.com.ph)',
          [mbOK]);
        FrmMain.Close;
        exit;
      end;
      SM_OUTOFCONNECTION,
      SM_NEWMAP,
      SM_LOGON,
      SM_RECONNECT,
      SM_SENDNOTICE,
      SM_DLGMSG: ;  //아래에서 처리
      else
        exit;
    end;
  end;
  if MapMoving then begin
    if msg.Ident = SM_CHANGEMAP then begin
      WaitingMsg    := msg;
      WaitingStr    := DecodeString(body);
      MapMovingWait := True;
      WaitMsgTimer.Enabled := True;
    end;
    exit;
  end;

  if msg.Ident = SM_DAYCHANGING then begin
    pDayBrightCheck^ := msg.Param;
    pDarkLevelCheck^ := msg.Tag;
  end;

  case msg.Ident of
    SM_NEWMAP:  // 새로운 맵에 들어감
    begin
      FrmDlg.SafeCloseDlg;
      MapTitle := '';
      str      := DecodeString(body); //mapname
      PlayScene.SendMsg(SM_NEWMAP, 0,
        msg.Param{x},
        msg.tag{y},
        LOBYTE(msg.Series){darkness}, // 용던젼 FireDragon
        0, 0, 0,
        str{mapname});
      EffectNum := HIBYTE(msg.Series);
      if EffectNum < 0 then
        EffectNum := 0;
      if (EffectNum = 1) or (EffectNum = 2) then
        RunEffectTimer.Enabled := True
      else
        RunEffectTimer.Enabled := False;
    end;

    SM_LOGON: begin
      FirstServerTime := 0;
      FirstClientTime := 0;
      with msg do begin
        DecodeBuffer(body, @wl, sizeof(TMessageBodyWL));
        PlayScene.SendMsg(SM_LOGON, msg.Recog,
          msg.Param{x},
          msg.tag{y},
          msg.Series{dir},
          wl.lParam1, //desc.Feature,
          wl.lParam2, //desc.Status,
          0,
          '');
        DScreen.ChangeScene(stPlayGame);
        SendClientMessage(CM_QUERYBAGITEMS, 0, 0, 0, 0);
        if Lobyte(Loword(wl.lTag1)) = 1 then
          AllowGroup := True
        else
          AllowGroup := False;
        BoServerChanging := False;
        // 2003/04/15 친구, 쪽지
        SendClientMessage(CM_FRIEND_LIST, 0, 0, 0, 0);
      end;
      if AvailIDDay > 0 then begin
        DScreen.AddChatBoardString('You are connected through personal account.',
          clGreen, clWhite);
      end else if AvailIPDay > 0 then begin
        DScreen.AddChatBoardString('you are connected through fixed amount IP.',
          clGreen, clWhite);
      end else if AvailIPHour > 0 then begin
        DScreen.AddChatBoardString('You are connected through fixed time IP.',
          clGreen, clWhite);
      end else if AvailIDHour > 0 then begin
        DScreen.AddChatBoardString(
          'your are connected through fixed time account.', clGreen, clWhite);
      end;
    end;

    SM_CHECK_CLIENTVALID: begin

      DecodeBuffer(body, @smsg, sizeof(TShortMessage));
      pClientCheckSum1^ := msg.Recog;
      pClientCheckSum2^ := MakeLong(msg.Param, msg.Tag);
      pClientCheckSum3^ := MakeLong(smsg.Ident, smsg.Msg);

    end;

    SM_RECONNECT: begin
      ClientGetReconnect(body);
    end;

    SM_TIMECHECK_MSG: begin
      CheckSpeedHack(msg.Recog);
    end;

    SM_AREASTATE: begin
      AreaStateValue := msg.Recog;
    end;

    SM_MAPDESCRIPTION: begin
      ClientGetMapDescription(body);
    end;

    SM_ADJUST_BONUS: begin
      ClientGetAdjustBonus(msg.Recog, body);
    end;

    SM_MYSTATUS: begin
      MyHungryState := msg.Param;  //배고품 상태
    end;

    SM_TURN: begin
      if Length(body) > UpInt(sizeof(TCharDesc) * 4 / 3) then begin
        Body2 := Copy(Body, UpInt(sizeof(TCharDesc) * 4 / 3) + 1, Length(body));
        Data  := DecodeString(body2); //캐릭 이름
        str   := GetValidStr3(Data, Data, ['/']);
        //data = 이름
        //str = 색갈
      end else
        Data := '';
      DecodeBuffer(body, @desc, sizeof(TCharDesc));
      PlayScene.SendMsg(SM_TURN, msg.Recog,
        msg.Param{x},
        msg.tag{y},
        msg.Series{dir + light},
        desc.Feature,
        desc.Status,
        0,
        ''); //이름
      if Data <> '' then begin
        actor := PlayScene.FindActor(msg.Recog);
        if actor <> nil then begin
          actor.DescUserName := GetValidStr3(Data, actor.UserName, ['\']);
          //actor.UserName := data;
          actor.NameColor    := GetRGB(Str_ToInt(str, 0));
        end;
      end;
    end;

    SM_BACKSTEP: begin
      if Length(body) > UpInt(sizeof(TCharDesc) * 4 / 3) then begin
        Body2 := Copy(Body, UpInt(sizeof(TCharDesc) * 4 / 3) + 1, Length(body));
        Data  := DecodeString(body2); //캐릭 이름
        str   := GetValidStr3(Data, Data, ['/']);
        //data = 이름
        //str = 색갈
      end else
        Data := '';
      DecodeBuffer(body, @desc, sizeof(TCharDesc));
      PlayScene.SendMsg(SM_BACKSTEP, msg.Recog,
        msg.Param{x},
        msg.tag{y},
        msg.Series{dir + light},
        desc.Feature,
        desc.Status,
        0,
        ''); //이름
      if Data <> '' then begin
        actor := PlayScene.FindActor(msg.Recog);
        if actor <> nil then begin
          actor.DescUserName := GetValidStr3(Data, actor.UserName, ['\']);
          //actor.UserName := data;
          actor.NameColor    := GetRGB(Str_ToInt(str, 0));
        end;
      end;
    end;

    SM_SPACEMOVE_HIDE,
    SM_SPACEMOVE_HIDE2: begin
      if msg.Recog = Myself.RecogId then begin
        FrmDlg.SafeCloseDlg;
      end else
        PlayScene.SendMsg(msg.Ident, msg.Recog, msg.Param{x},
          msg.tag{y}, 0, 0, 0, 0, '');
    end;

    SM_SPACEMOVE_SHOW,
    SM_SPACEMOVE_SHOW2: begin
      if Length(body) > UpInt(sizeof(TCharDesc) * 4 / 3) then begin
        Body2 := Copy(Body, UpInt(sizeof(TCharDesc) * 4 / 3) + 1, Length(body));
        Data  := DecodeString(body2); //캐릭 이름
        str   := GetValidStr3(Data, Data, ['/']);
        //data = 이름
        //str = 색갈
      end else
        Data := '';
      DecodeBuffer(body, @desc, sizeof(TCharDesc));
      if msg.Recog <> Myself.RecogId then begin //다른 캐릭터인 경우
        PlayScene.NewActor(msg.Recog, msg.Param, msg.tag,
          msg.Series, desc.feature, desc.Status);
      end;
      PlayScene.SendMsg(msg.Ident, msg.Recog,
        msg.Param{x},
        msg.tag{y},
        msg.Series{dir + light},
        desc.Feature,
        desc.Status,
        0,
        ''); //이름
      if Data <> '' then begin
        actor := PlayScene.FindActor(msg.Recog);
        if actor <> nil then begin
          actor.DescUserName := GetValidStr3(Data, actor.UserName, ['\']);
          //actor.UserName := data;
          actor.NameColor    := GetRGB(Str_ToInt(str, 0));
        end;
      end;
    end;

    SM_WALK, SM_RUSH, SM_RUSHKUNG: begin
      //DScreen.AddSysMsg ('WALK ' + IntToStr(msg.Param) + ':' + IntToStr(msg.Tag));
      DecodeBuffer(body, @desc, sizeof(TCharDesc));

      if (msg.Recog <> Myself.RecogId) or (msg.Ident = SM_RUSH) or
        (msg.Ident = SM_RUSHKUNG) then
        PlayScene.SendMsg(msg.Ident, msg.Recog,
          msg.Param{x},
          msg.tag{y},
          msg.Series{dir+light},
          desc.Feature,
          desc.Status,
          0,
          '');
      if msg.Ident = SM_RUSH then
        LatestRushRushTime := GetTickCount;
    end;

    SM_RUN: begin
      //DScreen.AddSysMsg ('RUN ' + IntToStr(msg.Param) + ':' + IntToStr(msg.Tag));
      DecodeBuffer(body, @desc, sizeof(TCharDesc));
      if msg.Recog <> Myself.RecogId then
        PlayScene.SendMsg(SM_RUN, msg.Recog,
          msg.Param{x},
          msg.tag{y},
          msg.Series{dir+light},
          desc.Feature,
          desc.Status,
          0,
          '');
    end;

    SM_CHANGELIGHT: begin
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        actor.ChrLight := msg.Param;
      end;
    end;

    SM_LAMPCHANGEDURA: begin
      if UseItems[U_RIGHTHAND].S.Name <> '' then begin
        UseItems[U_RIGHTHAND].Dura := msg.Recog;
      end;
    end;

    SM_MOVEFAIL:      //사용 안함...
    begin
      ActionFailed;
      DecodeBuffer(body, @desc, sizeof(TCharDesc));
      PlayScene.SendMsg(SM_TURN, msg.Recog,
        msg.Param{x},
        msg.tag{y},
        msg.Series{dir},
        desc.Feature,
        desc.Status,
        0,
        '');
    end;

    SM_BUTCH: begin
      DecodeBuffer(body, @desc, sizeof(TCharDesc));
      if msg.Recog <> Myself.RecogId then begin
        actor := PlayScene.FindActor(msg.Recog);
        if actor <> nil then
          actor.SendMsg(SM_SITDOWN,
            msg.Param{x},
            msg.tag{y},
            msg.Series{dir},
            0, 0, '', 0);
      end;
    end;
    SM_SITDOWN: begin
      DecodeBuffer(body, @desc, sizeof(TCharDesc));
      if msg.Recog <> Myself.RecogId then begin
        actor := PlayScene.FindActor(msg.Recog);
        if actor <> nil then
          actor.SendMsg(SM_SITDOWN,
            msg.Param{x},
            msg.tag{y},
            msg.Series{dir},
            0, 0, '', 0);
      end;
    end;

    SM_HIT,
    SM_HEAVYHIT,
    SM_POWERHIT,
    SM_slashhit,
    SM_LONGHIT,
    SM_WIDEHIT,
    SM_WIDEHIT2,
    // 2003/03/15 신규무공
    SM_CROSSHIT,
    SM_TWINHIT,
    SM_STONEHIT,
    SM_BIGHIT,
    SM_FIREHIT: begin
      if msg.Recog <> Myself.RecogId then begin
        actor := PlayScene.FindActor(msg.Recog);
        if actor <> nil then begin
          actor.SendMsg(msg.Ident,
            msg.Param{x},
            msg.tag{y},
            msg.Series{dir},
            0, 0, '',
            0);
          if msg.ident = SM_HEAVYHIT then begin
            if body <> '' then
              actor.BoDigFragment := True;
          end;
        end;
      end;
    end;
    SM_FLYAXE: begin
      DecodeBuffer(body, @mbw, sizeof(TMessageBodyW));
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        actor.SendMsg(msg.Ident,
          msg.Param{x},
          msg.tag{y},
          msg.Series{dir},
          0, 0, '',
          0);
        actor.TargetX     := mbw.Param1;    //x 던지는 목표
        actor.TargetY     := mbw.Param2;    //y
        actor.TargetRecog := MakeLong(mbw.Tag1, mbw.Tag2);
      end;
    end;

    SM_LIGHTING, SM_DRAGON_FIRE1, SM_DRAGON_FIRE2, SM_DRAGON_FIRE3,
    SM_LIGHTING_1: begin
      DecodeBuffer(body, @wl, sizeof(TMessageBodyWL));
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        actor.SendMsg(msg.Ident,
          msg.Param{x},
          msg.tag{y},
          msg.Series{dir},
          0, 0, '',
          0);
        actor.TargetX     := wl.lParam1;    //x 던지는 목표
        actor.TargetY     := wl.lParam2;    //y
        actor.TargetRecog := wl.lTag1;
        actor.MagicNum    := wl.lTag2;   //마법 번호
      end;
    end;

    // 2003/02/11 그룹원의 위치 정보
    SM_GROUPPOS: begin
      DecodeBuffer(body, @mbw, sizeof(TMessageBodyW));
      // 2003/03/04 그룹원 탐기파연 설정
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        //               if not actor.BoOpenHealth then
        AddCheck := True;
        if GroupIdList.Count > 0 then
          for i := 0 to GroupIdList.Count - 1 do begin
            if integer(GroupIdList[i]) = actor.RecogId then begin
              AddCheck := False;
              Break;
            end;
          end;
        if AddCheck then
          GroupIdList.Add(pointer(actor.RecogId)); // MonOpenHp
        actor.BoOpenHealth := True;
      end;
      if (msg.Recog <> MySelf.RecogId) then begin
        idx := -1;
        for i := 1 to MAXVIEWOBJECT do begin
          if (ViewList[i].Index = msg.Recog) then
            idx := i;
        end;
        if (idx = -1) then begin
          Inc(ViewListCount);
          if (ViewListCount > MAXVIEWOBJECT) then
            ViewListCount := MAXVIEWOBJECT;
          idx := ViewListCount;
        end;
        ViewList[idx].Index := msg.Recog;
        ViewList[idx].x     := msg.Param;  {x}
        ViewList[idx].y     := msg.tag;    {y}
        ViewList[idx].LastTick := GetTickCount;
      end;
    end;

    SM_SPELL: //다른 이가 주문을 외움
    begin
      UseMagicSpell(msg.Recog{who}, msg.Series{effectnum},
        msg.Param{tx}, msg.Tag{y}, Str_ToInt(body, 0));
    end;
    SM_MAGICFIRE: begin
      DecodeBuffer(body, @param, sizeof(integer));
      UseMagicFire(msg.Recog{who}, Lobyte(msg.Series){efftype},
        Hibyte(msg.Series){effnum}, msg.Param{tx}, msg.Tag{y}, param);
    end;
    SM_MAGICFIRE_FAIL: begin
      UseMagicFireFail(msg.Recog{who});
    end;

    SM_NORMALEFFECT: begin
      //msg.Recog{who},
      UseNormalEffect(msg.Series{종류}, msg.Param{X}, msg.Tag{Y});
    end;
    SM_LOOPNORMALEFFECT: begin
      UseLoopNormalEffect(msg.Recog{RecogID}, msg.Series{종류}, msg.Param{시간});
    end;

    SM_OUTOFCONNECTION: begin
      DoFastFadeOut := False;
      DoFadeIn      := False;
      DoFadeOut     := False;
      FrmDlg.DMessageDlg(
        'Server connection was forcefully terminated.\Connection time probably exceed limit or\a reconnection was requested from user.',
        [mbOK]);
      Close;
    end;

    SM_DEATH,
    SM_NOWDEATH: begin
      DecodeBuffer(body, @desc, sizeof(TCharDesc));
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        actor.SendMsg(msg.Ident,
          msg.param{x}, msg.Tag{y}, msg.Series{damage},
          desc.Feature, desc.Status, '',
          0);
        actor.Abil.HP := 0;
      end else begin
        PlayScene.SendMsg(SM_DEATH, msg.Recog, msg.param{x},
          msg.Tag{y}, msg.Series{damage}, desc.Feature, desc.Status, 0, '');
      end;
    end;
    SM_SKELETON: begin
      DecodeBuffer(body, @desc, sizeof(TCharDesc));
      PlayScene.SendMsg(SM_SKELETON, msg.Recog, msg.param{HP},
        msg.Tag{maxHP}, msg.Series{damage}, desc.Feature, desc.Status, 0, '');
    end;
    SM_ALIVE: begin
      DecodeBuffer(body, @desc, sizeof(TCharDesc));
      PlayScene.SendMsg(SM_ALIVE, msg.Recog, msg.param{HP},
        msg.Tag{maxHP}, msg.Series{damage}, desc.Feature, desc.Status, 0, '');
    end;

    SM_ABILITY: begin
      Myself.Gold := msg.Recog;
      Myself.Job  := msg.Param;
      DecodeBuffer(body, @Myself.Abil, sizeof(TAbility));
      ChangeWalkHitValues(Myself.Abil.Level
        , Myself.HitSpeed
        , Myself.Abil.Weight + Myself.Abil.MaxWeight +
        Myself.Abil.WearWeight + Myself.Abil.MaxWearWeight +
        Myself.Abil.HandWeight + Myself.Abil.MaxHandWeight
        , RUN_STRUCK_DELAY
        );
    end;

    SM_SUBABILITY: begin
      MyHitPoint      := Lobyte(msg.Param);
      MySpeedPoint    := Hibyte(msg.Param);
      MyAntiPoison    := Lobyte(msg.Tag);
      MyPoisonRecover := Hibyte(msg.Tag);
      MyHealthRecover := Lobyte(msg.Series);
      MySpellRecover  := Hibyte(msg.Series);
      MyAntiMagic     := lobyte(loword(msg.Recog));
    end;

    SM_DAYCHANGING: begin
      DayBright := msg.Param;
      DarkLevel := msg.Tag;
      if DarkLevel = 0 then
        ViewFog := False
      else
        ViewFog := True;
    end;

    SM_WINEXP: begin
      Myself.Abil.Exp := msg.Recog; //오른 경험치
      //DScreen.AddSysMsg ('' + IntToStr(msg.Param) + ' Experience points gained.');
      DScreen.AddChatBoardString('' + IntToStr(msg.Param) +
        ' Experience points gained.',
        clWhite, clRed);
    end;

    SM_LEVELUP: begin
      DScreen.AddSysMsg('Level up!');
      DScreen.AddChatBoardString(
        'Congratulation! Your level is up. Your HP, MP are all recovered.',
        TColor($A21C06), TColor($F6B9DE));
    end;

    SM_HEALTHSPELLCHANGED: begin
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        actor.Abil.HP    := msg.Param;
        actor.Abil.MP    := msg.Tag;
        actor.Abil.MaxHP := msg.Series;
        //actor.BoEatEffect := TRUE;
        //actor.EatEffectFrame := 0;
        //actor.EatEffectTime := GetTickCount;
      end;
    end;

    SM_STRUCK: begin
      //wl: TMessageBodyWL;
      DecodeBuffer(body, @wl, sizeof(TMessageBodyWL));
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        if actor = Myself then begin
          if Myself.NameColor = 249 then //빨갱이는 맞으면 접속을 못 끊는다.
            LatestStruckTime := GetTickCount;
        end else begin
          if actor.CanCancelAction then //@@@@
            actor.CancelAction;
        end;
        actor.UpdateMsg(SM_STRUCK, wl.lTag2, 0,
          msg.Series{damage}, wl.lParam1, wl.lParam2,
          '', wl.lTag1{때린놈아이디});
        actor.Abil.HP    := msg.param;
        actor.Abil.MaxHP := msg.Tag;
      end;
    end;

    SM_CHANGEFACE: begin
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        DecodeBuffer(body, @desc, sizeof(TCharDesc));
        actor.WaitForRecogId := MakeLong(msg.Param, msg.Tag);
        actor.WaitForFeature := desc.Feature;
        actor.WaitForStatus  := desc.Status;
        AddChangeFace(actor.WaitForRecogId);
      end;
    end;

    SM_OPENHEALTH: begin
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        if actor <> Myself then begin
          actor.Abil.HP    := msg.Param;
          actor.Abil.MaxHP := msg.Tag;
        end;
        actor.BoOpenHealth := True;
        //actor.OpenHealthTime := 999999999;
        //actor.OpenHealthStart := GetTickCount;
      end;
    end;
    SM_CLOSEHEALTH: begin
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        actor.BoOpenHealth := False;
      end;
    end;
    SM_INSTANCEHEALGUAGE: begin
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        actor.Abil.HP    := msg.param;
        actor.Abil.MaxHP := msg.Tag;
        actor.BoInstanceOpenHealth := True;
        actor.OpenHealthTime := 2 * 1000;
        actor.OpenHealthStart := GetTickCount;
      end;
    end;

    SM_BREAKWEAPON: begin
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        if actor is THumActor then
          THumActor(actor).DoWeaponBreakEffect;
      end;
    end;

    SM_CRY,
    SM_GROUPMESSAGE,//   그룹 메세지
    SM_GUILDMESSAGE,
    SM_WHISPER,
    SM_SYSMSG_REMARK,
    SM_SYSMESSAGE: begin
      str := DecodeString(body);
      DScreen.AddChatBoardString(str, GetRGB(Lobyte(msg.Param)),
        GetRGB(Hibyte(msg.Param)));
      if msg.Ident = SM_GUILDMESSAGE then
        FrmDlg.AddGuildChat(str)
      else if msg.Ident = SM_SYSMSG_REMARK then
        DScreen.AddSysMsg('clYellow' + str);
    end;

    SM_HEAR: begin
      str := DecodeString(body);
      DScreen.AddChatBoardString(str, GetRGB(Lobyte(msg.Param)),
        GetRGB(Hibyte(msg.Param)));
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then
        actor.Say(str);
    end;

    SM_USERNAME: begin
      str   := DecodeString(body);
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        actor.DescUserName := GetValidStr3(str, actor.UserName, ['\']);
        //actor.UserName := str;
        actor.NameColor    := GetRGB(msg.Param);
      end;
    end;
    SM_CHANGENAMECOLOR: begin
      actor := PlayScene.FindActor(msg.Recog);
      if actor <> nil then begin
        actor.NameColor := GetRGB(msg.Param);
      end;
    end;

    SM_HIDE,
    SM_GHOST,  //잔상..
    SM_DISAPPEAR: begin
      if Myself.RecogId <> msg.Recog then
        PlayScene.SendMsg(SM_HIDE, msg.Recog, msg.Param{x},
          msg.tag{y}, 0, 0, 0, 0, '');
    end;

    SM_DIGUP: begin
      DecodeBuffer(body, @wl, sizeof(TMessageBodyWL));
      actor := PlayScene.FindActor(msg.Recog);
      if actor = nil then
        actor := PlayScene.NewActor(msg.Recog, msg.Param, msg.tag,
          msg.Series, wl.lParam1, wl.lParam2);
      actor.CurrentEvent := wl.lTag1;
      actor.SendMsg(SM_DIGUP,
        msg.Param{x},
        msg.tag{y},
        msg.Series{dir + light},
        wl.lParam1,
        wl.lParam2, '', 0);
    end;
    SM_DIGDOWN: begin //환영한호 msg.Series(방향)받음
      PlayScene.SendMsg(SM_DIGDOWN, msg.Recog, msg.Param{x},
        msg.tag{y}, msg.Series, 0, 0, 0, '');
    end;
    SM_SHOWEVENT: begin
      DecodeBuffer(body, @smsg, sizeof(TShortMessage));
      event     := TClEvent.Create(msg.Recog, Loword(msg.Tag){x},
        msg.Series{y}, msg.Param{e-type});
      event.Dir := 0;
      event.EventParam := smsg.Ident;
      EventMan.AddEvent(event);  //clvent가 Free될 수 있음
    end;
    SM_HIDEEVENT: begin
      EventMan.DelEventById(msg.Recog);
    end;

    //Item ??
    SM_ADDITEM: begin
      ClientGetAddItem(body);
    end;
    SM_COUNTERITEMCHANGE: begin
      if not BoDealEnd then
        dealactiontime := GetTickCount;  // 교환할때 - 겹치기 아이템의 경우 메세지 날라옴
      ChangeItemCount(msg.Recog, msg.Param, msg.Tag, DecodeString(body));
    end;
    SM_UPGRADEITEM_RESULT: begin
      UpgradeItemResult(msg.Recog, msg.Param, DecodeString(body));
    end;
    SM_BAGITEMS: begin
      ClientGetBagItmes(body);
    end;
    SM_UPDATEITEM: begin
      ClientGetUpdateItem(body);
    end;
    SM_DELITEM: begin
      ClientGetDelItem(body, msg.Tag);
    end;
    SM_DELITEMS: begin
      ClientGetDelItems(body);
    end;

    SM_DROPITEM_SUCCESS: begin
      DelDropItem(DecodeString(body), msg.Recog);
    end;
    SM_DROPITEM_FAIL: begin
      ClientGetDropItemFail(DecodeString(body), msg.Recog);
    end;

    SM_ITEMSHOW: begin
      ClientGetShowItem(msg.Recog, msg.param{x}, msg.Tag{y},
        msg.Series{looks}, DecodeString(body));
    end;
    SM_ITEMHIDE: begin
      ClientGetHideItem(msg.Recog, msg.param, msg.Tag);
    end;

    SM_OPENDOOR_OK: //누군가에 의해 문이 열림
    begin
      Map.OpenDoor(msg.param, msg.tag);
      //문여는 소리...
    end;

    SM_OPENDOOR_LOCK: //내가 열려고 한 문이 잠겨있음
    begin
      DScreen.AddSysMsg('Door is locked.');
    end;
    SM_CLOSEDOOR: begin
      Map.CloseDoor(msg.param, msg.tag);
    end;

    SM_CANCLOSE_OK: begin
      //               DScreen.AddChatBoardString ('Receive=> SM_CANCLOSE_OK:', clYellow, clRed);
      if (GetTickCount - LatestStruckTime > 10000) and
        (GetTickCount - LatestMagicTime > 10000) and
        (GetTickCount - LatestHitTime > 10000) or (Myself.Death) then begin
        AppLogOut;
      end else
        DScreen.AddChatBoardString(
          'You cannot terminate connection during fight.', clYellow, clRed);
    end;

    SM_CANCLOSE_FAIL: begin
      //               DScreen.AddChatBoardString ('Receive=> SM_CANCLOSE_FAIL:', clYellow, clRed);
      DScreen.AddChatBoardString(
        'Your summoned monster is still engaged. You can not log out now.',
        clYellow, clRed);
    end;

    SM_TAKEON_OK: begin
      Myself.Feature := msg.Recog;
      Myself.FeatureChanged;
      // 2003/03/15 아이템 인벤토리 확장
      if WaitingUseItem.Index in [0..12] then      //8->12
        UseItems[WaitingUseItem.Index] := WaitingUseItem.Item;
      WaitingUseItem.Item.S.Name := '';
    end;
    SM_CREATEGROUPREQ: begin
      str := DecodeString(body);
      //        DScreen.AddChatBoardString ('SM_CREATEGROUPREQ: SendUderID=> '+str, clYellow, clRed);
      if not BoMsgDlgTimeCheck then begin
        BoMsgDlgTimeCheck      := True;
        FrmDlg.MsgDlgClickTime := GetTickCount + 30000;
        if mrYes = FrmDlg.DMessageDlg('Do you want to group with ' +
          str + '?', [mbYes, mbNo]) then begin
          FrmMain.SendClientMessage2(CM_CREATEGROUPREQ_OK, 0, 0, 0, 0, str);
          //        DScreen.AddChatBoardString ('CM_CREATEGROUPREQ_OK', clYellow, clRed);
        end else begin
          FrmMain.SendClientMessage2(CM_CREATEGROUPREQ_FAIL, 0, 0, 0, 0, str);
          //        DScreen.AddChatBoardString ('CM_CREATEGROUPREQ_FAIL', clYellow, clRed);
        end;
        BoMsgDlgTimeCheck      := False;
        FrmDlg.MsgDlgClickTime := GetTickCount;
      end;
    end;

    SM_ADDGROUPMEMBERREQ: begin
      str := DecodeString(body);
      //        DScreen.AddChatBoardString ('SM_ADDGROUPMEMBERREQ: SendUderID=> '+str, clYellow, clRed);
      if not BoMsgDlgTimeCheck then begin
        BoMsgDlgTimeCheck      := True;
        FrmDlg.MsgDlgClickTime := GetTickCount + 30000;
        if mrYes = FrmDlg.DMessageDlg('Do you want to group with ' +
          str + '?', [mbYes, mbNo]) then begin
          FrmMain.SendClientMessage2(CM_ADDGROUPMEMBERREQ_OK, 0, 0, 0, 0, str);
          //        DScreen.AddChatBoardString ('CM_ADDGROUPMEMBERREQ_OK', clYellow, clRed);
        end else begin
          FrmMain.SendClientMessage2(CM_ADDGROUPMEMBERREQ_FAIL, 0,
            0, 0, 0, str);
          //        DScreen.AddChatBoardString ('CM_ADDGROUPMEMBERREQ_FAIL', clYellow, clRed);
        end;
        BoMsgDlgTimeCheck      := False;
        FrmDlg.MsgDlgClickTime := GetTickCount;
      end;
    end;

    SM_LM_DELETE_REQ: begin
      str := DecodeString(body);
      //        DScreen.AddChatBoardString ('SM_LM_DELETE_REQ: SendUderID=> '+str, clYellow, clRed);
      if not BoMsgDlgTimeCheck then begin
        BoMsgDlgTimeCheck      := True;
        FrmDlg.MsgDlgClickTime := GetTickCount + 30000;
        //               if mrYes = FrmDlg.DMessageDlg (str+'님과 연인관계를 해제하시겠습니까?\교제를 중단할 경우 위약금으로 10만전이 자동지불됩니다.', [mbYes, mbNo]) then begin
        if mrYes = FrmDlg.DMessageDlg(
          'Will you break the lovers'' relationship with ' + str +
          '?\If the relationship is broken,\100,000 Gold is automatically paid to compensate for the breach.',
          [mbYes, mbNo]) then begin
          FrmMain.SendClientMessage2(CM_LM_DELETE_REQ_OK,
            RsState_Lover, 0, 0, 0, str);
          //        DScreen.AddChatBoardString ('CM_LM_DELETE_REQ_OK', clYellow, clRed);
        end else begin
          FrmMain.SendClientMessage2(CM_LM_DELETE_REQ_FAIL,
            RsState_Lover, 0, 0, 0, str);
          //        DScreen.AddChatBoardString ('CM_LM_DELETE_REQ_FAIL', clYellow, clRed);
        end;
        BoMsgDlgTimeCheck      := False;
        FrmDlg.MsgDlgClickTime := GetTickCount;
      end;
    end;

    SM_TAKEON_FAIL: begin
      AddItemBag(WaitingUseItem.Item);
      WaitingUseItem.Item.S.Name := '';
    end;
    SM_TAKEOFF_OK: begin
      Myself.Feature := msg.Recog;
      Myself.FeatureChanged;
      WaitingUseItem.Item.S.Name := '';
    end;
    SM_TAKEOFF_FAIL: begin
      if WaitingUseItem.Index < 0 then begin
        n := -(WaitingUseItem.Index + 1);
        UseItems[n] := WaitingUseItem.Item;
      end;
      WaitingUseItem.Item.S.Name := '';
    end;
    SM_EXCHGTAKEON_OK: ;
    SM_EXCHGTAKEON_FAIL: ;

    SM_SENDUSEITEMS: begin
      ClientGetSenduseItems(body);
    end;
    SM_WEIGHTCHANGED: begin
      if (msg.Recog + msg.Param + msg.Tag) =
        (((msg.Series xor $aa21) xor $1F35) xor $3A5F) then begin
        Myself.Abil.Weight     := msg.Recog;
        Myself.Abil.WearWeight := msg.Param;
        Myself.Abil.HandWeight := msg.Tag;
      end else begin
        Myself.Abil.Weight     := 127;
        Myself.Abil.WearWeight := 127;
        Myself.Abil.HandWeight := 127;
      end;
      ChangeWalkHitValues(Myself.Abil.Level
        , Myself.HitSpeed
        , Myself.Abil.Weight + Myself.Abil.MaxWeight +
        Myself.Abil.WearWeight + Myself.Abil.MaxWearWeight +
        Myself.Abil.HandWeight + Myself.Abil.MaxHandWeight
        , RUN_STRUCK_DELAY
        );
    end;
    SM_GOLDCHANGED: begin
      SoundUtil.PlaySound(s_money);
      if msg.Recog > Myself.Gold then begin
        DScreen.AddSysMsg(IntToStr(msg.Recog - Myself.Gold) + ' Gold gained.');
      end;
      Myself.Gold := msg.Recog;
    end;
    SM_FEATURECHANGED: begin
      PlayScene.SendMsg(msg.Ident, msg.Recog, 0, 0, 0,
        MakeLong(msg.Param, msg.Tag), 0, 0, '');
    end;
    SM_CHARSTATUSCHANGED: begin
      PlayScene.SendMsg(msg.Ident, msg.Recog, 0, 0, 0,
        MakeLong(msg.Param, msg.Tag), msg.Series, 0, '');
    end;
    SM_CLEAROBJECTS: begin
      //PlayScene.CleanObjects;
      MapMoving := True; //맵 이동중
    end;

    SM_EAT_OK: begin
      //      DScreen.AddChatBoardString ('SM_EAT_OK: EatingItem.S.Name=> '+ EatingItem.S.Name, clYellow, clRed);
      if EatingItem.S.StdMode <> 7 then
        EatingItem.S.Name := ''; // 노끈이 아니면
      if (EatingItem.S.StdMode = 7) and (EatingItem.Dura = 1) then begin
        EatingItem.S.Name := '';
      end;
      if (MovingItem.Item.S.StdMode = 7) and (MovingItem.Item.Dura = 1) then begin
        MovingItem.Item.S.Name := '';
        ItemMoving := False;
        //               FrmDlg.CancelItemMoving;
      end;
      ArrangeItembag;
    end;
    SM_EAT_FAIL: begin
      if EatingItem.S.StdMode <> 7 then
        AddItemBag(EatingItem); // 노끈이 아니면
      EatingItem.S.Name := '';
    end;

    SM_ADDMAGIC: begin
      if body <> '' then
        ClientGetAddMagic(body);
    end;
    SM_SENDMYMAGIC: begin
      if body <> '' then
        ClientGetMyMagics(msg.Recog, body);
    end;
    SM_DELMAGIC: begin
      ClientGetDelMagic(msg.Recog);
    end;
    SM_MAGIC_LVEXP: begin
      ClientGetMagicLvExp(msg.Recog{magid}, msg.Param{lv},
        MakeLong(msg.Tag, msg.Series));
    end;
    SM_SOUND: begin
      ClientGetSound(msg.Param);
    end;
    SM_DURACHANGE: begin
      ClientGetDuraChange(msg.Param{useitem index}, msg.Recog,
        MakeLong(msg.Tag, msg.Series));
    end;

    SM_MERCHANTSAY: begin
      ClientGetMerchantSay(msg.Recog, msg.Param, DecodeString(body));
    end;
    SM_MERCHANTDLGCLOSE: begin
      FrmDlg.CloseMDlg;
    end;
    SM_SENDGOODSLIST: begin
      ClientGetSendGoodsList(msg.Recog, msg.Param, body);
    end;
    SM_DECOITEM_LIST: begin
      //      DScreen.AddChatBoardString ('SM_DECOITEM_LIST: msg.Recog=> '+IntToStr(msg.Recog), clYellow, clRed);
      //      DScreen.AddChatBoardString ('SM_DECOITEM_LIST: msg.Param=> '+IntToStr(msg.Param), clYellow, clRed);
      ClientGetDecorationList(msg.Recog, msg.Param, body);
    end;
    SM_DECOITEM_LISTSHOW: //2004/08/05 장원꾸미기
    begin
      //      DScreen.AddChatBoardString ('SM_DECOITEM_LISTSHOW: msg.Recog=> '+IntToStr(msg.Recog), clYellow, clRed);
      //      DScreen.AddChatBoardString ('SM_DECOITEM_LISTSHOW: msg.Param=> '+IntToStr(msg.Param), clYellow, clRed);
      CurMerchant := msg.Recog;
      FrmDlg.ShowGADecorateDlg;
    end;
    SM_SENDUSERMAKEDRUGITEMLIST: begin
      ClientGetSendMakeDrugList(msg.Recog, body);
    end;
    SM_SENDUSERMAKEITEMLIST: begin
      ClientGetSendMakeItemList(msg.Recog, body);
    end;
    SM_SENDUSERSELL: begin
      ClientGetSendUserSell(msg.Recog);
    end;
    SM_SENDUSERREPAIR: begin
      ClientGetSendUserRepair(msg.Recog);
    end;
    SM_SENDBUYPRICE: begin
      if SellDlgItem.S.Name <> '' then begin
        if msg.Recog > 0 then begin
          if SellDlgItem.S.OverlapItem > 0 then
            SellPriceStr := IntToStr(msg.Recog * SellDlgItem.Dura) + 'Gold'
          else
            SellPriceStr := IntToStr(msg.Recog) + 'Gold';
        end else
          SellPriceStr := '????Gold';
      end;
    end;
    SM_USERSELLITEM_OK: begin
      FrmDlg.LastestClickTime := GetTickCount;
      Myself.Gold := msg.Recog;
      SellDlgItemSellWait.S.Name := '';
    end;

    SM_USERSELLITEM_FAIL: begin
      FrmDlg.LastestClickTime := GetTickCount;
      AddItemBag(SellDlgItemSellWait);
      SellDlgItemSellWait.S.Name := '';
      FrmDlg.DMessageDlg('You cannot sell this item', [mbOK]);
    end;

    SM_USERSELLCOUNTITEM_OK: begin
      FrmDlg.LastestClickTime := GetTickCount;
      Myself.Gold := msg.Recog;
      SellItemProg(msg.Param, msg.Tag);
      SellDlgItemSellWait.S.Name := '';
    end;

    SM_USERSELLCOUNTITEM_FAIL: begin
      FrmDlg.LastestClickTime := GetTickCount;
      AddItemBag(SellDlgItemSellWait);
      SellDlgItemSellWait.S.Name := '';
      FrmDlg.DMessageDlg('This item can not be sold.', [mbOK]);
    end;
    SM_SENDREPAIRCOST: begin
      if SellDlgItem.S.Name <> '' then begin
        if msg.Recog >= 0 then
          SellPriceStr := IntToStr(msg.Recog) + 'Gold'
        else
          SellPriceStr := '????Gold';
      end;
    end;
    SM_USERREPAIRITEM_OK: begin
      if SellDlgItemSellWait.S.Name <> '' then begin
        FrmDlg.LastestClickTime := GetTickCount;
        Myself.Gold := msg.Recog;
        SellDlgItemSellWait.Dura := msg.Param;
        SellDlgItemSellWait.DuraMax := msg.Tag;
        AddItemBag(SellDlgItemSellWait);
        SellDlgItemSellWait.S.Name := '';
      end;
    end;
    SM_USERREPAIRITEM_FAIL: begin
      FrmDlg.LastestClickTime := GetTickCount;
      AddItemBag(SellDlgItemSellWait);
      SellDlgItemSellWait.S.Name := '';
      FrmDlg.DMessageDlg('You cannot repair this item .', [mbOK]);
    end;
    SM_STORAGE_OK,
    SM_STORAGE_FULL,
    SM_STORAGE_FAIL: begin
      FrmDlg.LastestClickTime := GetTickCount;
      if msg.Ident <> SM_STORAGE_OK then begin
        if msg.Ident = SM_STORAGE_FULL then
          FrmDlg.DMessageDlg(
            'Your personal warehouse is full. You cannot store any more.', [mbOK])
        else
          FrmDlg.DMessageDlg('You cannot store.', [mbOK]);
        AddItemBag(SellDlgItemSellWait);
      end;
      SellDlgItemSellWait.S.Name := '';
    end;
    SM_SAVEITEMLIST: begin
      ClientGetSaveItemList(msg.Recog, msg.tag, msg.series, body);
    end;
    SM_TAKEBACKSTORAGEITEM_OK,
    SM_TAKEBACKSTORAGEITEM_FAIL,
    SM_TAKEBACKSTORAGEITEM_FULLBAG: begin
      FrmDlg.LastestClickTime := GetTickCount;
      if msg.Ident <> SM_TAKEBACKSTORAGEITEM_OK then begin
        if msg.Ident = SM_TAKEBACKSTORAGEITEM_FULLBAG then
          FrmDlg.DMessageDlg('You cannot carry any more.', [mbOK])
        else
          FrmDlg.DMessageDlg('You cannot get back.', [mbOK]);
      end else
        FrmDlg.DelStorageItem(msg.Recog, msg.Param); //itemserverindex
    end;

    SM_BUYITEM_SUCCESS: begin
      FrmDlg.LastestClickTime := GetTickCount;
      Myself.Gold := msg.Recog;
      FrmDlg.SoldOutGoods(MakeLong(msg.Param, msg.Tag)); //팔린 아이템 메뉴에서 뺌
    end;
    SM_BUYITEM_FAIL: begin
      FrmDlg.LastestClickTime := GetTickCount;
      case msg.Recog of
        1: FrmDlg.DMessageDlg('Item is sold out.', [mbOK]);
        2: FrmDlg.DMessageDlg('No more items can be carried.', [mbOK]);
        3: FrmDlg.DMessageDlg(
            'You have not enough Gold to purchase item.', [mbOK]);
      end;
    end;
    SM_MAKEDRUG_SUCCESS: begin
      FrmDlg.LastestClickTime := GetTickCount;
      Myself.Gold := msg.Recog;
      FrmDlg.DMessageDlg('Item has been created correctly', [mbOK]);
    end;
    SM_MAKEDRUG_FAIL: begin
      FrmDlg.LastestClickTime := GetTickCount;
      case msg.Recog of
        1: FrmDlg.DMessageDlg('An error occurred.', [mbOK]);
        2: FrmDlg.DMessageDlg('No more items can be carried.', [mbOK]);
        3: FrmDlg.DMessageDlg('Money is insufficient.', [mbOK]);
        4: FrmDlg.DMessageDlg('You lack necessary items.', [mbOK]);
        5: FrmDlg.DMessageDlg('Failed to make Gem.', [mbOK]);
        6: FrmDlg.DMessageDlg(
            'The mineral ore has low degree of purity.', [mbOK]);
      end;
    end;

    SM_SENDDETAILGOODSLIST: begin
      ClientGetSendDetailGoodsList(msg.Recog, msg.Param, msg.Tag, body);
    end;

    SM_TEST: begin
      Inc(TestReceiveCount);
    end;

    SM_SENDNOTICE: begin
      ClientGetSendNotice(body);
    end;

    SM_GROUPMODECHANGED: //서버에서 나의 그룹 설정이 변경되었음.
    begin
      if msg.Param > 0 then
        AllowGroup := True
      else
        AllowGroup := False;
      changegroupmodetime := GetTickCount;
    end;
    SM_CREATEGROUP_OK: begin
      changegroupmodetime := GetTickCount;
      AllowGroup := True;
      // 2003/03/04 그룹을 맺는 경우 자기 자신의 HP를 보여줌
      MySelf.BoOpenHealth := True;
            {GroupMembers.Add (Myself.UserName);
            GroupMembers.Add (DecodeString(body));}
    end;
    SM_CREATEGROUP_FAIL: begin
      changegroupmodetime := GetTickCount;
      case msg.Recog of
        -1: FrmDlg.DMessageDlg('Already added in group.', [mbOK]);
        -2: FrmDlg.DMessageDlg('The name to be added in group is not correct.', [mbOK]);
        -3: FrmDlg.DMessageDlg(
            'The user you want to invite in group is already in another group.',
            [mbOK]);
        -4: FrmDlg.DMessageDlg('The opponent is not on Allow Group.', [mbOK]);
        -5: FrmDlg.DMessageDlg(
            'The person you want to group is already considering to join other group.',
            [mbOK]);
      end;
    end;
    SM_GROUPADDMEM_OK: begin
      changegroupmodetime := GetTickCount;
      //GroupMembers.Add (DecodeString(body));
    end;
    SM_GROUPADDMEM_FAIL: begin
      changegroupmodetime := GetTickCount;
      case msg.Recog of
        -1: FrmDlg.DMessageDlg('Group is not organized yet or you have no access.', [mbOK]);
        -2: FrmDlg.DMessageDlg('The name to be added in group is not correct.', [mbOK]);
        -3: FrmDlg.DMessageDlg('Already joined a Group.', [mbOK]);
        -4: FrmDlg.DMessageDlg('The opponent is not on Allow Group.', [mbOK]);
        -5: FrmDlg.DMessageDlg('Members limit already reached.', [mbOK]);
      end;
    end;
    SM_GROUPDELMEM_OK: begin
      changegroupmodetime := GetTickCount;
            {data := DecodeString (body);
            for i:=0 to GroupMembers.Count-1 do begin
               if GroupMembers[i] = data then begin
                  GroupMembers.Delete (i);
                  break;
               end;
            end; }
    end;
    SM_GROUPDELMEM_FAIL: begin
      changegroupmodetime := GetTickCount;
      case msg.Recog of
        -1: FrmDlg.DMessageDlg('Group is not organized yet or you have no access.', [mbOK]);
        -2: FrmDlg.DMessageDlg('The name to be added in group is not correct.', [mbOK]);
        -3: FrmDlg.DMessageDlg('You are not in a Group yet.', [mbOK]);
      end;
    end;
    SM_GROUPCANCEL: begin
      // 2003/03/04 그룹이 해제되는 경우 HP출력하지 않음
      MySelf.BoOpenHealth := False;
      GroupMembers.Clear;
      try
        for i := 0 to GroupIdList.Count - 1 do begin
          actor := PlayScene.FindActor(integer(GroupIdList[i]));
          if actor <> nil then
            actor.BoOpenHealth := False;
        end;
        GroupIdList.Clear;  // MonOpenHp
      except
      end;
    end;
    SM_GROUPMEMBERS: begin
      // 2003/03/04 그룹이 해제되는 경우 HP출력하지 않음
      MySelf.BoOpenHealth := True;
      ClientGetGroupMembers(DecodeString(Body));
    end;

    SM_OPENGUILDDLG: begin
      querymsgtime := GetTickCount;
      ClientGetOpenGuildDlg(body);
    end;

    SM_SENDGUILDMEMBERLIST: begin
      querymsgtime := GetTickCount;
      ClientGetSendGuildMemberList(body);
    end;

    SM_OPENGUILDDLG_FAIL: begin
      querymsgtime := GetTickCount;
      FrmDlg.DMessageDlg('You are not in a Guild yet.', [mbOK]);
    end;

    SM_DEALTRY_FAIL: begin
      querymsgtime := GetTickCount;
      FrmDlg.DMessageDlg(
        'Deal was cancelled .\To deal correctly you must face the other party.', [mbOK]);
    end;
    SM_DEALMENU: begin
      querymsgtime := GetTickCount;
      DealWho      := DecodeString(body);
      FrmDlg.OpenDealDlg(1);
    end;
    SM_GUILDAGITDEALMENU: begin
      querymsgtime := GetTickCount;
      DealWho      := DecodeString(body);
      FrmDlg.OpenDealDlg(2);
    end;
    SM_DEALCANCEL: begin
      FrmDlg.CancelItemMoving;
      MoveDealItemToBag;

      if DealGold > 0 then begin
        Myself.Gold := Myself.GOld + DealGold;
        DealGold    := 0;
      end;
      FrmDlg.CloseDealDlg;

      //            if DealDlgItem.S.OverlapItem > 0 then FrmDlg.CancelItemMoving;
      FrmDlg.CancelItemMoving;
      if FrmDlg.DCountDlgCancel.Visible then begin
        FrmDlg.DCountDlg.DialogResult := mrCancel;
        FrmDlg.DCountDlg.Visible      := False;
      end;
    end;

    SM_DEALADDITEM_OK: begin
      dealactiontime := GetTickCount;
      if DealDlgItem.S.Name <> '' then begin
        ResultDealItem(DealDlgItem, msg.Recog, msg.Param);  //Deal Dlg에 추가
        DealDlgItem.S.Name := '';
      end;
    end;
    SM_DEALADDITEM_FAIL: begin
      dealactiontime := GetTickCount;
      if DealDlgItem.S.Name <> '' then begin
        AddItemBag(DealDlgItem);  //가방에 추가
        DealDlgItem.S.Name := '';
      end;
    end;
    SM_DEALDELITEM_OK: begin
      dealactiontime := GetTickCount;
      if DealDlgItem.S.Name <> '' then begin
        //AddItemBag (DealDlgItem);  //가방에 추가
        DealDlgItem.S.Name := '';
      end;
    end;
    SM_DEALDELITEM_FAIL: begin
      dealactiontime := GetTickCount;
      if DealDlgItem.S.Name <> '' then begin
        DelCountItemBag(DealDlgItem.S.Name, DealDlgItem.MakeIndex,
          DealDlgItem.Dura);
        AddDealItem(DealDlgItem);
        if (MovingItem.Item.MakeIndex = DealDlgItem.MakeIndex) and
          (MovingItem.Item.S.Name = DealDlgItem.S.Name) then begin
          ItemMoving := False;
          MovingItem.Item.S.Name := '';
        end;
        DealDlgItem.S.Name := '';
      end;
      FrmDlg.CancelItemMoving;
    end;
    SM_DEALREMOTEADDITEM: begin
      ClientGetDealRemoteAddItem(body);
      SoundUtil.PlaySound(s_deal_additem);
    end;
    SM_DEALREMOTEDELITEM: begin
      ClientGetDealRemoteDelItem(body);
      SoundUtil.PlaySound(s_deal_delitem);
    end;

    SM_DEALCHGGOLD_OK: begin
      DealGold    := msg.Recog;
      Myself.Gold := MakeLong(msg.param, msg.tag);
      dealactiontime := GetTickCount;
    end;
    SM_DEALCHGGOLD_FAIL: begin
      DealGold    := msg.Recog;
      Myself.Gold := MakeLong(msg.param, msg.tag);
      dealactiontime := GetTickCount;
    end;
    SM_DEALREMOTECHGGOLD: begin
      DealRemoteGold := msg.Recog;
      SoundUtil.PlaySound(s_money);  //상대방이 돈을 변경한 경우 소리가 난다.
    end;
    SM_DEALSUCCESS: begin
      FrmDlg.CloseDealDlg;
    end;

    SM_SENDUSERSTORAGEITEM:  //보관하는 창을 띄움.
    begin
      ClientGetSendUserStorage(msg.Recog);
    end;

    SM_READMINIMAP_OK: begin
      querymsgtime := GetTickCount;
      ClientGetReadMiniMap(msg.Param);
    end;

    SM_READMINIMAP_FAIL: begin
      querymsgtime := GetTickCount;
      DScreen.AddChatBoardString('No map available.', clWhite, clRed);
    end;

    SM_CHANGEGUILDNAME: begin
      ClientGetChangeGuildName(DecodeString(body));
    end;

    SM_SENDUSERSTATE: begin
      ClientGetSendUserState(body);
    end;

    SM_GUILDADDMEMBER_OK: begin
      SendGuildMemberList;
    end;
    SM_GUILDADDMEMBER_FAIL: begin
      case msg.Recog of
        1: FrmDlg.DMessageDlg('You have no right of command order.', [mbOK]);
        2: FrmDlg.DMessageDlg(
            'Members who want to enter should face you.', [mbOK]);
        3: FrmDlg.DMessageDlg('He already joined our Guild.', [mbOK]);
        4: FrmDlg.DMessageDlg('Already joined another Guild.', [mbOK]);
        5: FrmDlg.DMessageDlg(
            'Opponent is not allowed to enter the Guild.', [mbOK]);
      end;
    end;
    SM_GUILDDELMEMBER_OK: begin
      SendGuildMemberList;
    end;
    SM_GUILDDELMEMBER_FAIL: begin
      case msg.Recog of
        1: FrmDlg.DMessageDlg('You have no right of command order.', [mbOK]);
        2: FrmDlg.DMessageDlg(' is not our Guild member.', [mbOK]);
        3: FrmDlg.DMessageDlg('Guild chief cannot withdraw himself.', [mbOK]);
        4: FrmDlg.DMessageDlg('Cannot use command.', [mbOK]);
      end;
    end;

    SM_GUILDRANKUPDATE_FAIL: begin
      case msg.Recog of
        -2: FrmDlg.DMessageDlg('[ChangeError]  Chief place is empty.', [mbOK]);
        -3: FrmDlg.DMessageDlg('[ChangeError] Position of chief is empty.', [mbOK]);
        -4: FrmDlg.DMessageDlg('[ChangeError] Guild chief cannot be more than 2 people.',
            [mbOK]);
        -5: FrmDlg.DMessageDlg('[ChangeError] New Guild chief has to be connected.', [mbOK]);
        -6: FrmDlg.DMessageDlg('[ChangeError] Cannot AddMember/DelMember.', [mbOK]);
        -7: FrmDlg.DMessageDlg('[ChangeError] position duplicated or wrong.', [mbOK]);
      end;
    end;

    SM_GUILDMAKEALLY_OK,
    SM_GUILDMAKEALLY_FAIL: begin
      case msg.Recog of
        -1: FrmDlg.DMessageDlg('You have no access.', [mbOK]);
        -2: FrmDlg.DMessageDlg('Failure in alliance.', [mbOK]);
        -3: FrmDlg.DMessageDlg('You should face with Guild chief with whom you want to ally.',
            [mbOK]);
        -4: FrmDlg.DMessageDlg('Opponent Guild chief do not allow alliance.', [mbOK]);
      end;
    end;
    SM_GUILDBREAKALLY_OK,
    SM_GUILDBREAKALLY_FAIL: begin
      case msg.Recog of
        -1: FrmDlg.DMessageDlg('You have no access.', [mbOK]);
        -2: FrmDlg.DMessageDlg('You are not in alliance with that Guild.', [mbOK]);
        -3: FrmDlg.DMessageDlg('This is not an existing Guild.', [mbOK]);
      end;
    end;


    SM_BUILDGUILD_OK: begin
      FrmDlg.LastestClickTime := GetTickCount;
      FrmDlg.DMessageDlg('Guild created correctly.', [mbOK]);
    end;

    SM_BUILDGUILD_FAIL: begin
      FrmDlg.LastestClickTime := GetTickCount;
      case msg.Recog of
        -1: FrmDlg.DMessageDlg('already joined Guild.', [mbOK]);
        -2: FrmDlg.DMessageDlg('Lack of registration fee.', [mbOK]);
        -3: FrmDlg.DMessageDlg('You do not have all the necessary items.', [mbOK]);
      end;
    end;
    SM_MENU_OK: begin
      FrmDlg.LastestClickTime := GetTickCount;
      if body <> '' then
        FrmDlg.DMessageDlg(DecodeString(body), [mbOK]);
    end;
    SM_DLGMSG: begin
      if body <> '' then
        FrmDlg.DMessageDlg(DecodeString(body), [mbOK]);
    end;

    // 2003/04/15 친구, 쪽지
    SM_USER_INFO: begin
      if body <> '' then
        ClientGetUserInfo(msg, body);
    end;

    SM_FRIEND_INFO: begin
      if body <> '' then
        ClientGetFriendInfo(msg, body);
    end;
    SM_FRIEND_DELETE: begin
      if body <> '' then
        ClientGetDelFriend(msg, body);
    end;
    SM_FRIEND_RESULT: begin
      if body <> '' then
        ClientGetFriendResult(msg, body);
    end;
    // 2003/04/15 친구, 쪽지
    SM_TAG_ALARM: // 신규 메세지 도착
    begin
      // if body <> '' then ClientGetTagAlarm (msg ,body);
      ClientGetTagAlarm(msg, body);
    end;
    SM_TAG_LIST:  // 쪽지 리스트
    begin
      if body <> '' then
        ClientGetTagList(msg, body);
    end;
    SM_TAG_INFO:  // 쪽지 정보
    begin
      if body <> '' then
        ClientGetTagInfo(msg, body);
    end;
    SM_TAG_REJECT_LIST:   // 거부자 리스트
    begin
      if body <> '' then
        ClientGetTagRejectList(msg, body);
    end;
    SM_TAG_REJECT_ADD:    // 거부자 등록
    begin
      if body <> '' then
        ClientGetTagRejectAdd(msg, body);
    end;
    SM_TAG_REJECT_DELETE: // 거부자 삭제
    begin
      if body <> '' then
        ClientGetTagRejectDelete(msg, body);
    end;
    SM_TAG_RESULT:        // 쪽지 결과
    begin
      if body <> '' then
        ClientGetTagResult(msg, body);
    end;
    SM_LM_OPTION:       // 연인사제 옵션변경
    begin
      ClientGetLMOptionChange(msg);
    end;
    SM_LM_REQUEST:      // 연인사제 등록요구
    begin
      ClientGetLMRequest(msg, body);
    end;
    SM_LM_LIST:       // 연인사제 리스트
    begin
      ClientGetLMList(msg, body);
    end;
    SM_LM_RESULT:      // 연인사제 결과
    begin
      ClientGetLMREsult(msg, body);
    end;
    SM_LM_DELETE:     // 연인 사제 삭제
    begin
      ClientGetLMDelete(msg, body);
    end;

    SM_MARKET_LIST:  //위탁판매 리스트
    begin
      g_Market.OnMsgWriteData(msg, body);
      FrmDlg.ShowItemMarketDlg; // 위탁판매 ItemMarket
    end;
    SM_MARKET_RESULT: // 위탁판매 결과
    begin
      //            DScreen.AddSysMsg ('SM_MARKET_RESULT R:'+ intToStr(msg.Recog));
      //            DScreen.AddSysMsg ('SM_MARKET_RESULT P:'+ intToStr(msg.param));
      //            DScreen.AddSysMsg ('SM_MARKET_RESULT T:'+ intToStr(msg.Tag));

      case msg.Param of            // Market System..
        UMResult_Success: ;        // 0   ;     // 성공
        UMResult_Fail: ;           // 1   ;     // 실패
        UMResult_ReadFail: ;       // 2   ;     // 일기 실패
        UMResult_WriteFail: ;      // 3   ;     // 저장 실패
        UMResult_ReadyToSell:      // 4   ;     // 판매가능
        begin
          ClientGetSendUserMaketSell(msg.Recog);
        end;
        UMResult_OverSellCount:   // 5   ;     // 판매 아이템 개수 초과
          FrmDlg.DMessageDlg(
            'The number of items for the trade offer is exceeded.', [mbOK]);
        UMResult_LessMoney:       // 6   ;     // 금전부족
        begin
          FrmDlg.LastestClickTime := GetTickCount;
          if SellDlgItemSellWait.S.Name <> '' then begin
            AddItemBag(SellDlgItemSellWait);
          end;
          SellDlgItemSellWait.S.Name := '';
        end;
        UMResult_LessLevel: ;      // 7   ;     // 레벨부족
        UMResult_MaxBagItemCount: ;// 8   ;     // 가방에 아이템꽉참
        UMResult_NoItem: ;         // 9   ;     // 아이템이 없음
        UMResult_DontSell:         // 10  ;     // 판매불가
        begin
          FrmDlg.LastestClickTime := GetTickCount;
          AddItemBag(SellDlgItemSellWait);
          SellDlgItemSellWait.S.Name := '';
          FrmDlg.DMessageDlg('This item can not be sold.', [mbOK]);
        end;
        UMResult_DontBuy: ;        // 11  ;     // 구입불가
        UMResult_DontGetMoney: ;   // 12  ;     // 금액회수 불가
        UMResult_MarketNotReady: ; // 13  ;     // 위탁시스템 자체가 불가능
        UMResult_LessTrustMoney:
          // 14  ;     // 위탁금액이 부족 1000 전 보다는 커야됨
        begin
          FrmDlg.LastestClickTime := GetTickCount;
          if SellDlgItemSellWait.S.Name <> '' then begin
            AddItemBag(SellDlgItemSellWait);
          end;
          SellDlgItemSellWait.S.Name := '';
        end;

        UMResult_MaxTrustMoney: ;  // 15  ;     // 위탁금액이 너무 큼
        UMResult_CancelFail: ;     // 16  ;     // 위탁취소 실패
        UMResult_OverMoney: ;      // 17  ;     // 소유금액 최대치가 넘어감
        UMResult_SellOK:           // 18  ;     // 판매가 잘됬음
        begin
          //      DScreen.AddChatBoardString ('UMResult_SellOK:', clYellow, clRed);
          FrmDlg.DSellDlg.Visible    := False;
          FrmDlg.LastestClickTime    := GetTickCount;
          //                     Myself.Gold := msg.Recog;
          //                     SellItemProg ( msg.Param, msg.Tag );
          SellDlgItemSellWait.S.Name := '';
        end;
        UMResult_BuyOK: ;    // 19  ;     // 구입이 잘됬음
        UMResult_CancelOK: ; // 20  ;     // 판매취소가 잘됬음
        UMResult_GetPayOK: ; // 21  ;     // 판매금 회수가 잘됬음
        else
      end;
    end;

    SM_GUILDAGITLIST: begin
      ClientGetJangwonList(msg.Recog, msg.Param, body);
    end;
    SM_GABOARD_LIST: //장원 게시판
    begin
      ClientGetGABoardList(msg.Param, msg.Recog, msg.Tag, body);
    end;
    SM_GABOARD_READ: //장원 게시판
    begin
      ClientGetGABoardRead(body);
    end;
    SM_GABOARD_NOTICE_OK: begin
      FrmDlg.SendGABoardNoticeOk;
    end;
    SM_GABOARD_NOTICE_FAIL: begin
      DScreen.AddChatBoardString('Only guild masters are authorized to write.',
        clWhite, clRed);
    end;

    SM_DONATE_OK: begin
      FrmDlg.LastestClickTime := GetTickCount;
    end;

    SM_DONATE_FAIL: begin
      FrmDlg.LastestClickTime := GetTickCount;
    end;

    SM_NEXTTIME_PASSWORD: begin
      if PlayScene.EdChat.PasswordChar = #0 then
        PlayScene.EdChat.PasswordChar := '*';
      BoOneTimePassword := True;
    end;

    SM_PLAYDICE: begin
      Body2 := Copy(Body, UpInt(sizeof(TMessageBodyWL) * 4 / 3) + 1, Length(body));
      DecodeBuffer(body, @wl, sizeof(TMessageBodyWL));
      str := DecodeString(body2);

      FrmDlg.RunDice    := msg.Param;
      FrmDlg.DiceArr[0].DiceResult := lobyte(loword(wl.lparam1));
      FrmDlg.DiceArr[1].DiceResult := hibyte(loword(wl.lparam1));
      FrmDlg.DiceArr[2].DiceResult := lobyte(hiword(wl.lparam1));
      FrmDlg.DiceArr[3].DiceResult := hibyte(hiword(wl.lparam1));
      FrmDlg.DiceArr[4].DiceResult := lobyte(loword(wl.lparam2));
      FrmDlg.DiceArr[5].DiceResult := hibyte(loword(wl.lparam2));
      FrmDlg.DiceArr[6].DiceResult := lobyte(hiword(wl.lparam2));
      FrmDlg.DiceArr[7].DiceResult := hibyte(hiword(wl.lparam2));
      FrmDlg.DiceArr[8].DiceResult := lobyte(loword(wl.lTag1));
      FrmDlg.DiceArr[9].DiceResult := hibyte(loword(wl.lTag1));
      FrmDlg.DialogSize := 0;

      FrmDlg.DMessageDlg('', []);

      FrmMain.SendMerchantDlgSelect(msg.Recog, str);
    end;

    else begin
      DScreen.AddSysMsg(IntToStr(msg.Ident) + ' : ' + body);
    end;

  end;

  if Pos('#', datablock) > 0 then
    DScreen.AddSysMsg(datablock);
end;

procedure TFrmMain.ClientGetPasswdSuccess(body: string);
var
  str, runaddr, runport, uid, certifystr: string;
begin
  str := DecodeString(body);
  str := GetValidStr3(str, runaddr, ['/']);
  str := GetValidStr3(str, runport, ['/']);
  str := GetValidStr3(str, certifystr, ['/']);
  Certification := Str_ToInt(certifystr, 0);

  if not BoOneClick then begin
    CSocket.Active := False;  //로그인에 연결된 소켓 닫음
    FrmDlg.DSelServerDlg.Visible := False;
    WaitAndPass(500); //0.5초동안 기다림
    ConnectionStep := cnsSelChr;
    with CSocket do begin
      SelChrAddr := runaddr;
      SelChrPort := Str_ToInt(runport, 0);
      Address := SelChrAddr;
      Port   := SelChrPort;
      Active := True;
    end;
  end else begin
    FrmDlg.DSelServerDlg.Visible := False;
    SelChrAddr := runaddr;
    SelChrPort := Str_ToInt(runport, 0);
    if CSocket.Socket.Connected then
      CSocket.Socket.SendText('$S' + runaddr + '/' + runport + '%');
    WaitAndPass(500); //0.5초동안 기다림
    ConnectionStep := cnsSelChr;
    LoginScene.OpenLoginDoor;
    SelChrWaitTimer.Enabled := True;
  end;
end;

procedure TFrmMain.ClientGetSelectServer;
var
  sname: string;
begin
  LoginScene.HideLoginBox;

  FrmDlg.ShowSelectServerDlg;
end;

procedure TFrmMain.ClientGetNeedUpdateAccount(body: string);
var
  ue: TUserEntryInfo;
begin
  DecodeBuffer(body, @ue, sizeof(TUserEntryInfo));
  LoginScene.UpdateAccountInfos(ue);
end;

procedure TFrmMain.ClientGetReceiveChrs(body: string);
var
  i, select: integer;
  str, uname, sjob, shair, slevel, ssex: string;
begin
  SelectChrScene.ClearChrs;
  str := DecodeString(body);
  for i := 0 to 1 do begin
    str    := GetValidStr3(str, uname, ['/']);
    str    := GetValidStr3(str, sjob, ['/']);
    str    := GetValidStr3(str, shair, ['/']);
    str    := GetValidStr3(str, slevel, ['/']);
    str    := GetValidStr3(str, ssex, ['/']);
    select := 0;
    if (uname <> '') and (slevel <> '') and (ssex <> '') then begin
      if uname[1] = '*' then begin
        select := i;
        uname  := Copy(uname, 2, Length(uname) - 1);
      end;
      SelectChrScene.AddChr(uname, Str_ToInt(sjob, 0), Str_ToInt(shair, 0),
        Str_ToInt(slevel, 0), Str_ToInt(ssex, 0));
    end;
    with SelectChrScene do begin
      if select = 0 then begin
       // ChrArr[0].FreezeState := False;
        ChrArr[0].Selected    := True;
       // ChrArr[1].FreezeState := True;
        ChrArr[1].Selected    := False;
      end else begin
       // ChrArr[0].FreezeState := True;
        ChrArr[0].Selected    := False;
      //  ChrArr[1].FreezeState := False;
        ChrArr[1].Selected    := True;
      end;
    end;
  end;
end;

procedure TFrmMain.ClientGetStartPlay(body: string);
var
  str, addr, sport: string;
begin
  str   := DecodeString(body);
  sport := GetValidStr3(str, addr, ['/']);

  if not BoOneClick then begin
    CSocket.Active := False;  //로그인에 연결된 소켓 닫음
    WaitAndPass(500); //0.5초동안 기다림

    ConnectionStep := cnsPlay;
    with CSocket do begin
      Address := addr;
      Port    := Str_ToInt(sport, 0);
      Active  := True;
    end;
  end else begin
    SocStr    := '';
    BufferStr := '';
    if CSocket.Socket.Connected then
      CSocket.Socket.SendText('$R' + addr + '/' + sport + '%');

    ConnectionStep := cnsPlay;
    ClearBag;  //가방 초기화
    DScreen.ClearChatBoard; //채팅창 초기화
    DScreen.ChangeScene(stLoginNotice);

    WaitAndPass(500); //0.5초동안 기다림
    SendRunLogin;
  end;
end;

procedure TFrmMain.ClientGetReconnect(body: string);
var
  str, addr, sport: string;
begin
  str   := DecodeString(body);
  sport := GetValidStr3(str, addr, ['/']);

  if not BoOneClick then begin
    if BoBagLoaded then
      Savebags('.\Data\' + ServerName + '.' + CharName + '.itm', @ItemArr);
    BoBagLoaded := False;

    BoServerChanging := True;
    CSocket.Active   := False;  //로그인에 연결된 소켓 닫음

    WaitAndPass(500); //0.5초동안 기다림

    ConnectionStep := cnsPlay;
    with CSocket do begin
      Address := addr;
      Port    := Str_ToInt(sport, 0);
      Active  := True;
    end;

  end else begin
    if BoBagLoaded then
      Savebags('.\Data\' + ServerName + '.' + CharName + '.itm', @ItemArr);
    BoBagLoaded := False;

    SocStr    := '';
    BufferStr := '';
    BoServerChanging := True;

    if CSocket.Socket.Connected then   //접속 종료 신호 보낸다.
      CSocket.Socket.SendText('$C' + addr + '/' + sport + '%');

    WaitAndPass(500); //0.5초동안 기다림
    if CSocket.Socket.Connected then   //재접..
      CSocket.Socket.SendText('$R' + addr + '/' + sport + '%');

    ConnectionStep := cnsPlay;
    ClearBag;  //가방 초기화
    DScreen.ClearChatBoard; //채팅창 초기화
    DScreen.ChangeScene(stLoginNotice);

    WaitAndPass(300); //0.5초동안 기다림
    ChangeServerClearGameVariables;

    SendRunLogin;
  end;
end;

procedure TFrmMain.ClientGetMapDescription(body: string);
var
  Data: string;
begin
  body     := DecodeString(body);
  body     := GetValidStr3(body, Data, [#13]);
  MapTitle := Data; //맵 이름....
end;

procedure TFrmMain.ClientGetAdjustBonus(bonus: integer; body: string);
var
  str1, str2, str3: string;
begin
  BonusPoint := bonus;
  body := GetValidStr3(body, str1, ['/']);
  str3 := GetValidStr3(body, str2, ['/']);
  DecodeBuffer(str1, @BonusTick, sizeof(TNakedAbility));
  DecodeBuffer(str2, @BonusAbil, sizeof(TNakedAbility));
  DecodeBuffer(str3, @NakedAbil, sizeof(TNakedAbility));
  FillChar(BonusAbilChg, sizeof(TNakedAbility), #0);
end;

procedure TFrmMain.ClientGetAddItem(body: string);
var
  cu: TClientItem;
begin
  if body <> '' then begin
    DecodeBuffer(body, @cu, sizeof(TClientItem));
    AddItemBag(cu);
    DScreen.AddSysMsg(cu.S.Name + ' found.');
  end;
end;

procedure TFrmMain.ClientGetUpdateItem(body: string);
var
  i:  integer;
  cu: TClientItem;
begin
  if body <> '' then begin
    DecodeBuffer(body, @cu, sizeof(TClientItem));
    UpdateItemBag(cu);
    // 2003/03/15 인벤토리 확장
    for i := 0 to 12 do begin    // 8 -> 12
      if (UseItems[i].S.Name = cu.S.Name) and
        (UseItems[i].MakeIndex = cu.MakeIndex) then begin
        UseItems[i] := cu;
      end;
    end;
  end;
end;

procedure TFrmMain.ClientGetDelItem(body: string; flag: integer);
var
  i:  integer;
  cu: TClientItem;
begin
  if body <> '' then begin
    if flag = 1 then begin
      DecodeBuffer(body, @DelTempItem, sizeof(TClientItem));
    end else begin
      DecodeBuffer(body, @cu, sizeof(TClientItem));
      DelItemBag(cu.S.Name, cu.MakeIndex);
      // 2003/03/15 인벤토리 확장
      for i := 0 to 12 do begin   // 8 -> 12
        if (UseItems[i].S.Name = cu.S.Name) and
          (UseItems[i].MakeIndex = cu.MakeIndex) then begin
          UseItems[i].S.Name := '';
        end;
      end;
    end;
  end;
end;

procedure TFrmMain.ClientGetDelItems(body: string);
var
  i, iindex: integer;
  str, iname: string;
  cu: TClientItem;
begin
  body := DecodeString(body);
  while body <> '' do begin
    body := GetValidStr3(body, iname, ['/']);
    body := GetValidStr3(body, str, ['/']);
    if (iname <> '') and (str <> '') then begin
      iindex := Str_ToInt(str, 0);
      DelItemBag(iname, iindex);
      // 2003/03/15 인벤토리 확장
      for i := 0 to 12 do begin   // 8->12
        if (UseItems[i].S.Name = iname) and (UseItems[i].MakeIndex = iindex) then
        begin
          UseItems[i].S.Name := '';
        end;
      end;
    end else
      break;
  end;
end;

procedure TFrmMain.ClientGetBagItmes(body: string);
var
  str: string;
  cu:  TClientItem;
  ItemSaveArr: array[0..MAXBAGITEMCL - 1] of TClientItem;

  function CompareItemArr: boolean;
  var
    i, j: integer;
    flag: boolean;
  begin
    flag := True;
    for i := 0 to MAXBAGITEMCL - 1 do begin
      if ItemSaveArr[i].S.Name <> '' then begin
        flag := False;
        for j := 0 to MAXBAGITEMCL - 1 do begin
          if (ItemArr[j].S.Name = ItemSaveArr[i].S.Name) and
            (ItemArr[j].MakeIndex = ItemSaveArr[i].MakeIndex) then begin
            if (ItemArr[j].Dura = ItemSaveArr[i].Dura) and
              (ItemArr[j].DuraMax = ItemSaveArr[i].DuraMax) then begin
              flag := True;
            end;
            break;
          end;
        end;
        if not flag then
          break;
      end;
    end;
    if flag then begin
      for i := 0 to MAXBAGITEMCL - 1 do begin
        if ItemArr[i].S.Name <> '' then begin
          flag := False;
          for j := 0 to MAXBAGITEMCL - 1 do begin
            if (ItemArr[i].S.Name = ItemSaveArr[j].S.Name) and
              (ItemArr[i].MakeIndex = ItemSaveArr[j].MakeIndex) then begin
              if (ItemArr[i].Dura = ItemSaveArr[j].Dura) and
                (ItemArr[i].DuraMax = ItemSaveArr[j].DuraMax) then begin
                flag := True;
              end;
              break;
            end;
          end;
          if not flag then
            break;
        end;
      end;
    end;
    Result := flag;
  end;

begin
  //ClearBag;
  FillChar(ItemArr, sizeof(TClientItem) * MAXBAGITEMCL, #0);
  while True do begin
    if body = '' then
      break;
    body := GetValidStr3(body, str, ['/']);
    DecodeBuffer(str, @cu, sizeof(TClientItem));
    AddItemBag(cu);
  end;
  FillChar(ItemSaveArr, sizeof(TClientItem) * MAXBAGITEMCL, #0);
  Loadbags('.\Data\' + ServerName + '.' + CharName + '.itm', @ItemSaveArr);
  if CompareItemArr then begin
    Move(ItemSaveArr, ItemArr, sizeof(TClientItem) * MAXBAGITEMCL);
  end;
  ArrangeItembag;
  BoBagLoaded := True;
end;

procedure TFrmMain.ClientGetDropItemFail(iname: string; sindex: integer);
var
  pc: PTClientItem;
begin
  pc := GetDropItem(iname, sindex);
  if pc <> nil then begin
    AddItemBag(pc^);
    DelDropItem(iname, sindex);
  end;
end;

procedure TFrmMain.ClientGetShowItem(itemid, x, y, looks: integer; body: string);
var
  i:  integer;
  pd: PTDropItem;
  itmname, sDeco: string;
begin
  for i := 0 to DropedItemList.Count - 1 do begin
    if PTDropItem(DropedItemList[i]).Id = itemid then
      exit;
  end;
  new(pd);
  pd.Id    := itemid;
  pd.X     := x;
  pd.Y     := y;
  pd.Looks := looks;
  sDeco    := '0';
  if body <> '' then begin
    body := GetValidStr3(body, itmname, ['/']);
    body := GetValidStr3(body, sDeco, ['/']);
  end;
  pd.Name := itmname;
  if Str_ToInt(sDeco, 0) = 0 then
    pd.BoDeco := False
  else
    pd.BoDeco := True;

  pd.FlashTime := GetTickCount - Random(3000);
  pd.BoFlash   := False;
  DropedItemList.Add(pd);
end;

procedure TFrmMain.ClientGetHideItem(itemid, x, y: integer);
var
  i:  integer;
  pd: PTDropItem;
begin
  for i := 0 to DropedItemList.Count - 1 do begin
    if PTDropItem(DropedItemList[i]).Id = itemid then begin
      Dispose(PTDropItem(DropedItemList[i]));
      DropedItemlist.Delete(i);
      break;
    end;
  end;
end;

procedure TFrmMain.ClientGetSenduseItems(body: string);
var
  index: integer;
  str, Data: string;
  cu: TClientItem;
begin
  // 2003/03/15 신규무공
  FillChar(UseItems, sizeof(TClientItem) * 13, #0);      // 9->13
  while True do begin
    if body = '' then
      break;
    body  := GetValidStr3(body, str, ['/']);
    body  := GetValidStr3(body, Data, ['/']);
    index := Str_ToInt(str, -1);
    // 2003/03/15 아이템 인벤토리 확장
    if index in [0..12] then begin    // 8->12
      DecodeBuffer(Data, @cu, sizeof(TClientItem));
      UseItems[index] := cu;
    end;
  end;
end;

procedure TFrmMain.ClientGetAddMagic(body: string);
var
  pcm: PTClientMagic;
begin
  new(pcm);
  DecodeBuffer(body, @(pcm^), sizeof(TClientMagic));
  MagicList.Add(pcm);
end;

procedure TFrmMain.ClientGetDelMagic(magid: integer);
var
  i: integer;
begin
  for i := MagicList.Count - 1 downto 0 do begin
    if PTClientMagic(MagicList[i]).Def.MagicId = magid then begin
      Dispose(PTClientMagic(MagicList[i]));
      MagicList.Delete(i);
      break;
    end;
  end;
end;

procedure TFrmMain.ClientGetMyMagics(checksum: integer; body: string);
var
  i, mdelay: integer;
  Data: string;
  pcm: PTClientMagic;
begin
  for i := 0 to MagicList.Count - 1 do
    Dispose(PTClientMagic(MagicList[i]));
  MagicList.Clear;
  mdelay := 0;
  while True do begin
    if body = '' then
      break;
    body := GetValidStr3(body, Data, ['/']);
    if Data <> '' then begin
      new(pcm);
      DecodeBuffer(Data, @(pcm^), sizeof(TClientMagic));
      MagicList.Add(pcm);
      mdelay := mdelay + pcm.Def.DelayTime;
    end else
      break;
  end;

  if (checksum xor $4BBC2255) xor $773F1A34 <> mdelay then begin
    for i := 0 to MagicList.Count - 1 do
      PTClientMagic(MagicList[i]).Def.DelayTime := 1000;
  end;

end;

procedure TFrmMain.ClientGetMagicLvExp(magid, maglv, magtrain: integer);
var
  i: integer;
begin
  for i := MagicList.Count - 1 downto 0 do begin
    if PTClientMagic(MagicList[i]).Def.MagicId = magid then begin
      PTClientMagic(MagicList[i]).Level    := maglv;
      PTClientMagic(MagicList[i]).CurTrain := magtrain;
      break;
    end;
  end;
end;

procedure TFrmMain.ClientGetSound(soundid: integer);
begin
  SilenceSound;
  if soundid <> 0 then begin
    PlaySound(soundid);
  end;
end;

procedure TFrmMain.ClientGetDuraChange(uidx, newdura, newduramax: integer);
begin
  // 2003/03/15 아이템 인벤토리 확장
  if uidx in [0..12] then begin     // 8->12
    if UseItems[uidx].S.Name <> '' then begin
      UseItems[uidx].Dura    := newdura;
      UseItems[uidx].DuraMax := newduramax;
    end;
  end;
end;

procedure TFrmMain.ClientGetMerchantSay(merchant, face: integer; saying: string);
var
  npcname: string;
begin
  MDlgX := Myself.XX;
  MDlgY := Myself.YY;
  if CurMerchant <> merchant then begin
    CurMerchant := merchant;
    FrmDlg.ResetMenuDlg;
    FrmDlg.CloseMDlg;
  end;

  saying := GetValidStr3(saying, npcname, ['/']);
  FrmDlg.ShowMDlg(face, npcname, saying);
end;

procedure TFrmMain.ClientGetSendGoodsList(merchant, Count: integer; body: string);
var
  i:   integer;
  Data, gname, gsub, gprice, gstock: string;
  pcg: PTClientGoods;
begin
  FrmDlg.ResetMenuDlg;

  CurMerchant := merchant;
  with FrmDlg do begin
    //deocde body received from server
    body := DecodeString(body);
    while body <> '' do begin
      body := GetValidStr3(body, gname, ['/']);
      body := GetValidStr3(body, gsub, ['/']);
      body := GetValidStr3(body, gprice, ['/']);
      body := GetValidStr3(body, gstock, ['/']);
      if (gname <> '') and (gprice <> '') and (gstock <> '') then begin
        new(pcg);
        pcg.Name    := gname;
        pcg.SubMenu := Str_ToInt(gsub, 0);
        pcg.Price   := Str_ToInt(gprice, 0);
        pcg.Stock   := Str_ToInt(gstock, 0);
        pcg.Grade   := -1;
        MenuList.Add(pcg);
      end else
        break;
    end;
    FrmDlg.ShowShopMenuDlg;
    FrmDlg.CurDetailItem := '';
  end;
end;

procedure TFrmMain.ClientGetDecorationList(merchant, Count: integer; body: string);
var
  i:   integer;
  Data, sname, simgindex, sprice, scase: string;
  pcd: PTClientGADecoration;
begin

  with FrmDlg do begin
    for i := 0 to GADecorationList.Count - 1 do
      Dispose(PTClientGADecoration(GADecorationList[i]));
    GADecorationList.Clear;
  end;

  //   CurMerchant := merchant;
  //이름/번호/가격/종류
  with FrmDlg do begin
    //deocde body received from server
    body := DecodeString(body);
    while body <> '' do begin
      body := GetValidStr3(body, sname, ['/']);
      body := GetValidStr3(body, simgindex, ['/']);
      body := GetValidStr3(body, sprice, ['/']);
      body := GetValidStr3(body, scase, ['/']);
      //         body := GetValidStr3 (body, sprice, ['/']);
      //      DScreen.AddChatBoardString (sname+'/'+stemp1+'/'+simgindex+'/'+stemp2, clYellow, clRed);
      //         if (sname <> '') and (sprice <> '') and (simgindex <> '') then begin
      if (sname <> '') and (simgindex <> '') then begin
        new(pcd);
        pcd.Num      := Str_ToInt(simgindex, 0);
        pcd.Name     := sname;
        pcd.Price    := Str_ToInt(sprice, 0);
        pcd.ImgIndex := Str_ToInt(simgindex, 0);
        pcd.CaseNum  := Str_ToInt(scase, 0);

        GADecorationList.Add(pcd);
      end else
        break;
    end;
    //      FrmDlg.ShowGADecorateDlg;
  end;
end;

procedure TFrmMain.ClientGetJangwonList(Page, Count: integer; body: string);
var //장원리스트 받음
    //   i: integer;
  SNum, SGuildname, SCaptainname1, SCaptainname2, SSellprice, SSellstate: string;
  pcj: PTClientJangwon;
begin
  FrmDlg.ResetMenuDlg;

  //deocde body received from server
  body := DecodeString(body);
  while body <> '' do begin
    body := GetValidStr3(body, SNum, ['/']);
    body := GetValidStr3(body, SGuildname, ['/']);
    body := GetValidStr3(body, SCaptainname1, ['/']);
    body := GetValidStr3(body, SCaptainname2, ['/']);
    body := GetValidStr3(body, SSellprice, ['/']);
    body := GetValidStr3(body, SSellstate, ['/']);
    if (SCaptainname1 <> '') and (SSellprice <> '') and (SSellstate <> '') then begin
      new(pcj);
      pcj.Num := Str_ToInt(SNum, 0);
      pcj.GuildName := SGuildname;
      pcj.CaptaineName1 := SCaptainname1;
      pcj.CaptaineName2 := SCaptainname2;
      pcj.SellPrice := Str_ToInt(SSellprice, 0);
      pcj.SellState := SSellstate;
      FrmDlg.JangwonList.Add(pcj);
      //  DScreen.AddChatBoardString (SNum +'/'+ SGuildname +'/'+ SCaptainname +'/'+ SSellprice +'/'+ SSellstate, clYellow, clRed);
    end else
      break;
  end;
  if Page = 1 then
    FrmDlg.MenuTop := 0
  else if Page = 2 then
    FrmDlg.MenuTop := 10;
  FrmDlg.ShowJangwonDlg; // 위탁판매 ItemMarket

end;

procedure TFrmMain.ClientGetGABoardList(ListNum, Page, MaxPage: integer; body: string);
var //장원 게시판 리스트 받음
  i:   integer;
  SGuildname, SWriteUser, SIndexType1, SIndexType2, SIndexType3,
  SIndexType4, STitleMsg, LineData: string;
  pcb: PTClientGABoard;
begin
  //deocde body received from server
  body := DecodeString(body);

  body := GetValidStr3(body, SGuildname, ['/']);
  body := GetValidStr3(body, SWriteUser, ['/']);
  body := GetValidStr3(body, SIndexType1, ['/']);
  body := GetValidStr3(body, SIndexType2, ['/']);
  body := GetValidStr3(body, SIndexType3, ['/']);
  body := GetValidStr3(body, SIndexType4, ['/']);
  body := GetValidStr3(body, STitleMsg, ['/']);

  FrmDlg.GABoard_MaxPage := MaxPage;
  FrmDlg.GABoard_CurPage := Page;

  if ListNum = 1 then begin
    FrmDlg.ResetMenuDlg;
    FrmDlg.GABoard_GuildName := SGuildname;
  end;

  if STitleMsg <> '' then begin
    new(pcb);
    pcb.WrigteUser := SWriteUser;
    pcb.IndexType1 := StrToInt(SIndexType1);
    pcb.IndexType2 := StrToInt(SIndexType2);
    pcb.IndexType3 := StrToInt(SIndexType3);
    pcb.IndexType4 := StrToInt(SIndexType4);

    STitleMsg := GetValidStr3(SQLSafeToStr(STitleMsg), LineData, [#13]);
    FrmDlg.GABoard_Notice.Add(LineData);
    pcb.TitleMsg   := LineData;
    pcb.ReplyCount := 0;
    if pcb.IndexType2 > 0 then
      Inc(pcb.ReplyCount);
    if pcb.IndexType3 > 0 then
      Inc(pcb.ReplyCount);
    if pcb.IndexType4 > 0 then
      Inc(pcb.ReplyCount);

    FrmDlg.GABoardList.Add(pcb);
  end;

  //   if FrmDlg.DGABoardListDlg.Visible then FrmDlg.DGABoardListDlg.Visible := False;
  if ListNum = 100 then
    FrmDlg.ShowGABoardListDlg;

end;

procedure TFrmMain.ClientGetGABoardRead(body: string);
var
  SWriteUser, STitleMsg, SIndexType1, SIndexType2, SIndexType3,
  SIndexType4, LineData: string;
begin

  body := DecodeString(body);

  body := GetValidStr3(body, SIndexType1, ['/']);
  body := GetValidStr3(body, SIndexType2, ['/']);
  body := GetValidStr3(body, SIndexType3, ['/']);
  body := GetValidStr3(body, SIndexType4, ['/']);
  body := GetValidStr3(body, SWriteUser, ['/']);
  body := GetValidStr3(body, STitleMsg, ['/']);

  FrmDlg.GABoard_IndexType1 := StrToInt(SIndexType1);
  FrmDlg.GABoard_IndexType2 := StrToInt(SIndexType2);
  FrmDlg.GABoard_IndexType3 := StrToInt(SIndexType3);
  FrmDlg.GABoard_IndexType4 := StrToInt(SIndexType4);

  FrmDlg.GABoard_UserName := SWriteUser;
  FrmDlg.GABoard_TxtBody  := STitleMsg;

  //DScreen.AddChatBoardString (SIndexType1 +'/'+ SIndexType2 +'/'+ SIndexType3 +'/'+ SIndexType4 +'/'+
  //                            SWriteUser +'/'+ STitleMsg , clYellow, clRed);

  FrmDlg.GABoard_Notice.Clear;
  //   STitleMsg := GetValidStr3 (SQLSafeToStr(STitleMsg), LineData, [#13]);
  //   FrmDlg.GABoard_Notice.Add (SQLSafeToStr(STitleMsg));

  while True do begin
    if STitleMsg = '' then begin
      //    DScreen.AddChatBoardString ('STitleMsg=> '+STitleMsg, clYellow, clRed);
      //    DScreen.AddChatBoardString ('LineData=> '+LineData, clYellow, clRed);
      break;
    end;
    STitleMsg := GetValidStr3(SQLSafeToStr(STitleMsg), LineData, [#13]);
    FrmDlg.GABoard_Notice.Add(LineData);
  end;

  FrmDlg.ShowGABoardReadDlg;

end;

procedure TFrmMain.ClientGetSendMakeDrugList(merchant: integer; body: string);
var
  i:   integer;
  Data, gname, gsub, gprice, gstock: string;
  pcg: PTClientGoods;
begin
  FrmDlg.ResetMenuDlg;

  CurMerchant := merchant;
  with FrmDlg do begin
    //clear shop menu list
    //deocde body received from server
    body := DecodeString(body);
    while body <> '' do begin
      body := GetValidStr3(body, gname, ['/']);
      body := GetValidStr3(body, gsub, ['/']);
      body := GetValidStr3(body, gprice, ['/']);
      body := GetValidStr3(body, gstock, ['/']);
      if (gname <> '') and (gprice <> '') and (gstock <> '') then begin
        new(pcg);
        pcg.Name    := gname;
        pcg.SubMenu := Str_ToInt(gsub, 0);
        pcg.Price   := Str_ToInt(gprice, 0);
        pcg.Stock   := Str_ToInt(gstock, 0);
        pcg.Grade   := -1;
        MenuList.Add(pcg);
      end else
        break;
    end;
    FrmDlg.ShowShopMenuDlg;
    FrmDlg.CurDetailItem  := '';
    FrmDlg.BoMakeDrugMenu := True;
  end;
end;

procedure TFrmMain.ClientGetSendMakeItemList(merchant: integer; body: string);
var
  i:   integer;
  Data, gname, gsub, gprice, gstock: string;
  pcg: PTClientGoods;
begin
  FrmDlg.ResetMenuDlg;

  CurMerchant := merchant;
  with FrmDlg do begin
    //clear shop menu list
    //deocde body received from server
    body := DecodeString(body);
    while body <> '' do begin
      body := GetValidStr3(body, gname, ['/']);
      body := GetValidStr3(body, gsub, ['/']);
      body := GetValidStr3(body, gprice, ['/']);
      body := GetValidStr3(body, gstock, ['/']);
      if (gname <> '') and (gprice <> '') and (gstock <> '') then begin
        new(pcg);
        pcg.Name    := gname;
        pcg.SubMenu := Str_ToInt(gsub, 0);
        pcg.Price   := Str_ToInt(gprice, 0);
        pcg.Stock   := Str_ToInt(gstock, 0);
        pcg.Grade   := -1;
        MenuList.Add(pcg);
      end else
        break;
    end;
    FrmDlg.ShowShopMenuDlg;
    FrmDlg.CurDetailItem  := '';
    FrmDlg.BoMakeItemMenu := True;
  end;
end;

procedure TFrmMain.ClientGetSendUserSell(merchant: integer);
begin
  FrmDlg.CloseDSellDlg;
  CurMerchant := merchant;
  FrmDlg.SpotDlgMode := dmSell;
  FrmDlg.ShowShopSellDlg;
end;

procedure TFrmMain.ClientGetSendUserRepair(merchant: integer);
begin
  FrmDlg.CloseDSellDlg;
  CurMerchant := merchant;
  FrmDlg.SpotDlgMode := dmRepair;
  FrmDlg.ShowShopSellDlg;
end;

procedure TFrmMain.ClientGetSendUserStorage(merchant: integer);
begin
  FrmDlg.CloseDSellDlg;
  CurMerchant := merchant;
  FrmDlg.SpotDlgMode := dmStorage;
  FrmDlg.ShowShopSellDlg;
end;

procedure TFrmMain.ClientGetSendUserMaketSell(merchant: integer);
begin
  FrmDlg.CloseDSellDlg;
  CurMerchant := merchant;
  FrmDlg.SpotDlgMode := dmMaketSell;
  FrmDlg.ShowShopSellDlg;
end;


procedure TFrmMain.ClientGetSaveItemList(merchant, Currentpage, maxpage: integer;
  bodystr: string);
var
  i:    integer;
  Data: string;
  pc:   PTClientItem;
  pcg:  PTClientGoods;
begin
  FrmDlg.ResetMenuDlg;

  //   DScreen.AddSysMsg (IntToStr(CurrentPage) + ' , ' + IntToStr(maxpage) );

  if CurrentPage = 0 then begin
    for i := 0 to SaveItemList.Count - 1 do
      Dispose(PTClientItem(SaveItemList[i]));
    SaveItemList.Clear;
  end;

  while True do begin
    if bodystr = '' then
      break;
    bodystr := GetValidStr3(bodystr, Data, ['/']);
    if Data <> '' then begin
      new(pc);
      DecodeBuffer(Data, @(pc^), sizeof(TClientItem));
      SaveItemList.Add(pc);
    end else
      break;
  end;

  CurMerchant := merchant;
  with FrmDlg do begin
    //deocde body received from server
    for i := 0 to SaveItemList.Count - 1 do begin
      new(pcg);
      pcg.Name    := PTClientItem(SaveItemList[i]).S.Name;
      pcg.SubMenu := 0;
      pcg.Price   := PTClientItem(SaveItemList[i]).MakeIndex;
      pcg.Stock   := Round(PTClientItem(SaveItemList[i]).Dura / 1000);
      pcg.Grade   := Round(PTClientItem(SaveItemList[i]).DuraMax / 1000);
      MenuList.Add(pcg);
    end;
    if Currentpage = MaxPage then begin
      FrmDlg.ShowShopMenuDlg;
      FrmDlg.BoStorageMenu := True;
    end;
  end;
end;

procedure TFrmMain.ClientGetSendDetailGoodsList(merchant, Count, topline: integer;
  bodystr: string);
var
  i:   integer;
  body, Data, gname, gprice, gstock, ggrade: string;
  pcg: PTClientGoods;
  pc:  PTClientItem;
begin
  FrmDlg.ResetMenuDlg;

  CurMerchant := merchant;

  bodystr := DecodeString(bodystr);
  while True do begin
    if bodystr = '' then
      break;
    bodystr := GetValidStr3(bodystr, Data, ['/']);
    if Data <> '' then begin
      new(pc);
      DecodeBuffer(Data, @(pc^), sizeof(TClientItem));
      MenuItemList.Add(pc);
    end else
      break;
  end;

  with FrmDlg do begin
    //clear shop menu list
    for i := 0 to MenuItemList.Count - 1 do begin
      new(pcg);
      pcg.Name    := PTClientItem(MenuItemList[i]).S.Name;
      pcg.SubMenu := 0;
      pcg.Price   := PTClientItem(MenuItemList[i]).DuraMax;
      pcg.Stock   := PTClientItem(MenuItemList[i]).MakeIndex;
      pcg.Grade   := Round(PTClientItem(MenuItemList[i]).Dura / 1000);
      MenuList.Add(pcg);
    end;
    FrmDlg.ShowShopMenuDlg;
    FrmDlg.BoDetailMenu := True;
    FrmDlg.MenuTopLine  := topline;
  end;
end;

procedure TFrmMain.ClientGetSendNotice(body: string);
var
  Data, msgstr: string;
begin
  DoFastFadeOut := False;
  msgstr := '';
  body   := DecodeString(body);
  while True do begin
    if body = '' then
      break;
    body   := GetValidStr3(body, Data, [#27]);
    msgstr := msgstr + Data + '\';
  end;
  FrmDlg.DialogSize := 2;
  if FrmDlg.DMessageDlg(msgstr, [mbOK]) = mrOk then begin
    SendClientMessage(CM_LOGINNOTICEOK, 0, 0, 0, 0);
  end;
end;

procedure TFrmMain.ClientGetGroupMembers(bodystr: string);
var
  memb:  string;
  actor: TActor;
  i:     integer;
begin
  GroupMembers.Clear;

  try
    for i := 0 to GroupIdList.Count - 1 do begin
      actor := PlayScene.FindActor(integer(GroupIdList[i]));
      if actor <> nil then
        actor.BoOpenHealth := False;
    end;
    GroupIdList.Clear; // MonOpenHp
  except
  end;

  while True do begin
    if bodystr = '' then
      break;
    bodystr := GetValidStr3(bodystr, memb, ['/']);
    if memb <> '' then
      GroupMembers.Add(memb)
    else
      break;
  end;
end;

procedure TFrmMain.ClientGetOpenGuildDlg(bodystr: string);
var
  str, Data, linestr, s1: string;
  pstep: integer;
begin
  str := DecodeString(bodystr);
  str := GetValidStr3(str, FrmDlg.Guild, [#13]);
  str := GetValidStr3(str, FrmDlg.GuildFlag, [#13]);
  str := GetValidStr3(str, Data, [#13]);
  if Data = '1' then
    FrmDlg.GuildCommanderMode := True
  else
    FrmDlg.GuildCommanderMode := False;

  FrmDlg.GuildStrs.Clear;
  FrmDlg.GuildNotice.Clear;
  pstep := 0;
  while True do begin
    if str = '' then
      break;
    str := GetValidStr3(str, Data, [#13]);
    if Data = '<Notice>' then begin
      FrmDlg.GuildStrs.AddObject(char(7) + 'Notice', TObject(clWhite));
      FrmDlg.GuildStrs.Add(' ');
      pstep := 1;
      continue;
    end;
    if Data = '<KillGuilds>' then begin
      FrmDlg.GuildStrs.Add(' ');
      FrmDlg.GuildStrs.AddObject(char(7) + 'EnemyGuild', TObject(clWhite));
      FrmDlg.GuildStrs.Add(' ');
      pstep   := 2;
      linestr := '';
      continue;
    end;
    if Data = '<AllyGuilds>' then begin
      if linestr <> '' then
        FrmDlg.GuildStrs.Add(linestr);
      linestr := '';
      FrmDlg.GuildStrs.Add(' ');
      FrmDlg.GuildStrs.AddObject(char(7) + 'AlliedGuild', TObject(clWhite));
      FrmDlg.GuildStrs.Add(' ');
      pstep := 3;
      continue;
    end;

    if pstep = 1 then
      FrmDlg.GuildNotice.Add(Data);

    if Data <> '' then begin
      if Data[1] = '<' then begin
        ArrestStringEx(Data, '<', '>', s1);
        if s1 <> '' then begin
          FrmDlg.GuildStrs.Add(' ');
          FrmDlg.GuildStrs.AddObject(char(7) + s1, TObject(clWhite));
          FrmDlg.GuildStrs.Add(' ');
          continue;
        end;
      end;
    end;
    if (pstep = 2) or (pstep = 3) then begin
      if Length(linestr) > 80 then begin
        FrmDlg.GuildStrs.Add(linestr);
        linestr := '';
        linestr := linestr + fmstr(Data, 18);
      end else begin
        linestr := linestr + fmstr(Data, 18);
      end;
      continue;
    end;

    FrmDlg.GuildStrs.Add(Data);
  end;

  if linestr <> '' then
    FrmDlg.GuildStrs.Add(linestr);

  FrmDlg.ShowGuildDlg;
end;

procedure TFrmMain.ClientGetSendGuildMemberList(body: string);
var
  str, Data, rankname, members: string;
  rank: integer;
begin
  str := DecodeString(body);
  FrmDlg.GuildStrs.Clear;
  FrmDlg.GuildMembers.Clear;
  rank := 0;
  while True do begin
    if str = '' then
      break;
    str := GetValidStr3(str, Data, ['/']);
    if Data <> '' then begin
      if Data[1] = '#' then begin
        rank := Str_ToInt(Copy(Data, 2, Length(Data) - 1), 0);
        continue;
      end;
      if Data[1] = '*' then begin
        if members <> '' then
          FrmDlg.GuildStrs.Add(members);
        rankname := Copy(Data, 2, Length(Data) - 1);
        members  := '';
        FrmDlg.GuildStrs.Add(' ');
        if FrmDlg.GuildCommanderMode then
          FrmDlg.GuildStrs.AddObject(fmStr('(' + IntToStr(rank) + ')', 3) +
            '<' + rankname + '>', TObject(clWhite))
        else
          FrmDlg.GuildStrs.AddObject('<' + rankname + '>', TObject(clWhite));
        FrmDlg.GuildMembers.Add('#' + IntToStr(rank) + ' <' + rankname + '>');
        continue;
      end;
      if Length(members) > 80 then begin
        FrmDlg.GuildStrs.Add(members);
        members := '';
      end;
      members := members + FmStr(Data, 18);
      FrmDlg.GuildMembers.Add(Data);
    end;
  end;
  if members <> '' then
    FrmDlg.GuildStrs.Add(members);
end;

procedure TFrmMain.MinTimerTimer(Sender: TObject);
var
  i: integer;
  timertime: longword;
begin
  with PlayScene do
    for i := 0 to ActorList.Count - 1 do begin
      if IsGroupMember(TActor(ActorList[i]).UserName) then begin
        TActor(ActorList[i]).Grouped := True;
      end else
        TActor(ActorList[i]).Grouped := False;
    end;
  for i := FreeActorList.Count - 1 downto 0 do begin
    if GetTickCount - TActor(FreeActorList[i]).DeleteTime > 60000 then begin
      TActor(FreeActorList[i]).Free;
      FreeActorList.Delete(i);
    end;
  end;
end;

procedure TFrmMain.CheckHackTimerTimer(Sender: TObject);
const
  busy: boolean = False;
var
  ahour, amin, asec, amsec: word;
  tcount, timertime: longword;
begin
(*   if busy then exit;
   busy := TRUE;
   DecodeTime (Time, ahour, amin, asec, amsec);
   timertime := amin * 1000 * 60 + asec * 1000 + amsec;
   tcount := GetTickCount;

   if BoCheckSpeedHackDisplay then begin
      DScreen.AddSysMsg (IntToStr(tcount - LatestClientTime2) + ' ' +
                         IntToStr(timertime - LatestClientTimerTime) + ' ' +
                         IntToStr(abs(tcount - LatestClientTime2) - abs(timertime - LatestClientTimerTime)));
                         // + ',  ' +
                         //IntToStr(tcount - FirstClientGetTime) + ' ' +
                         //IntToStr(timertime - FirstClientTimerTime) + ' ' +
                         //IntToStr(abs(tcount - FirstClientGetTime) - abs(timertime - FirstClientTimerTime)));
   end;

   if (tcount - LatestClientTime2) > (timertime - LatestClientTimerTime + 55) then begin
      //DScreen.AddSysMsg ('**' + IntToStr(tcount - LatestClientTime2) + ' ' + IntToStr(timertime - LatestClientTimerTime));
      Inc (TimeFakeDetectTimer);
      if TimeFakeDetectTimer > 3 then begin
         //시간 조작...
         SendSpeedHackUser;
         FrmDlg.DMessageDlg ('recorded as hacking program user.\' +
                             'It is illegal for you to use this kind of program,\' +
                             'and  please be noted that you may have penalty such as account seizure .\' +
                             '[inquiry] mir2support@okeydokey.com.ph\' +
                             'Program will be terminated.', [mbOk]);
         FrmMain.Close;
      end;
   end else
      TimeFakeDetectTimer := 0;


   if FirstClientTimerTime = 0 then begin
      FirstClientTimerTime := timertime;
      FirstClientGetTime := tcount;
   end else begin
      if (abs(timertime - LatestClientTimerTime) > 500) or
         (timertime < LatestClientTimerTime)
      then begin
         FirstClientTimerTime := timertime;
         FirstClientGetTime := tcount;
      end;
      if abs(abs(tcount - FirstClientGetTime) - abs(timertime - FirstClientTimerTime)) > 5000 then begin
         Inc (TimeFakeDetectSum);
         if TimeFakeDetectSum > 25 then begin
            //시간 조작...
            SendSpeedHackUser;
            FrmDlg.DMessageDlg ('recorded as hacking program user.\' +
                                'It is illegal for you to use this kind of program,\' +
                                'and  please be noted that you may have penalty such as account seizure .\' +
                                '[inquiry] mir2support@okeydokey.com.ph\' +
                                'Program will be terminated.', [mbOk]);
            FrmMain.Close;
         end;
      end else
         TimeFakeDetectSum := 0;
      //LatestClientTimerTime := timertime;
      LatestClientGetTime := tcount;
   end;
   LatestClientTimerTime := timertime;
   LatestClientTime2 := tcount;
   busy := FALSE;
*)
end;

(**
const
   busy: boolean = FALSE;
var
   ahour, amin, asec, amsec: word;
   timertime, tcount: longword;
begin
   if busy then exit;
   busy := TRUE;
   DecodeTime (Time, ahour, amin, asec, amsec);
   timertime := amin * 1000 * 60 + asec * 1000 + amsec;
   tcount := GetTickCount;

   //DScreen.AddSysMsg (IntToStr(tcount - FirstClientGetTime) + ' ' +
   //                   IntToStr(timertime - FirstClientTimerTime) + ' ' +
   //                   IntToStr(abs(tcount - FirstClientGetTime) - abs(timertime - FirstClientTimerTime)));

   if FirstClientTimerTime = 0 then begin
      FirstClientTimerTime := timertime;
      FirstClientGetTime := tcount;
   end else begin
      if (abs(timertime - LatestClientTimerTime) > 2000) or
         (timertime < LatestClientGetTime)
      then begin
         FirstClientTimerTime := timertime;
         FirstClientGetTime := tcount;
      end;
      if abs(abs(tcount - FirstClientGetTime) - abs(timertime - FirstClientTimerTime)) > 2000 then begin
         Inc (TimeFakeDetectSum);
         if TimeFakeDetectSum > 10 then begin
            //시간 조작...
            SendSpeedHackUser;
            FrmDlg.DMessageDlg ('recorded as hacking program user.\' +
                                'It is illegal for you to use this kind of program,\' +
                                'and  please be noted that you may have penalty such as account seizure .\' +
                                '[inquiry] mir2support@okeydokey.com.ph\' +
                                'Program will be terminated.', [mbOk]);
            FrmMain.Close;
         end;
      end else
         TimeFakeDetectSum := 0;
      LatestClientTimerTime := timertime;
      LatestClientGetTime := tcount;
   end;
   busy := FALSE;
end;
//**)

procedure TFrmMain.ClientGetDealRemoteAddItem(body: string);
var
  ci: TClientItem;
begin
  if body <> '' then begin
    DecodeBuffer(body, @ci, sizeof(TClientItem));
    AddDealRemoteItem(ci);
  end;
end;

procedure TFrmMain.ClientGetDealRemoteDelItem(body: string);
var
  ci: TClientItem;
begin
  if body <> '' then begin
    DecodeBuffer(body, @ci, sizeof(TClientItem));
    DelDealRemoteItem(ci);
  end;
end;

procedure TFrmMain.ClientGetReadMiniMap(mapindex: integer);
begin
  if mapindex >= 1 then begin
    if PrevVMMStyle < 1 then
      PrevVMMStyle := 1;
    ViewMiniMapStyle := PrevVMMStyle;
    MiniMapIndex := mapindex - 1;
  end;
end;

procedure TFrmMain.ClientGetChangeGuildName(body: string);
var
  str: string;
begin
  str := GetValidStr3(body, GuildName, ['/']);
  GuildRankName := Trim(str);
end;

procedure TFrmMain.ClientGetSendUserState(body: string);
var
  ustate: TUserStateInfo;
begin
  DecodeBuffer(body, @ustate, sizeof(TUserStateInfo));
  ustate.NameColor := GetRGB(ustate.NameColor);
  FrmDlg.OpenUserState(ustate);
end;

procedure TFrmMain.SendTimeTimerTimer(Sender: TObject);
var
  tcount: longword;
begin
  //   tcount := GetTickCount;
  //   SendClientMessage (CM_CLIENT_CHECKTIME, tcount, Loword(LatestClientGetTime), Hiword(LatestClientGetTime), 0);
  //   LastestClientGetTime := tcount;
end;

function TFrmMain.IsMyMember(Name: string): boolean;
var
  i: integer;
begin
  Result := False;
  // 친구에서 검색
  for i := FriendMembers.Count - 1 downto 0 do begin
    if PTFriend(FriendMembers[i]).CharID = Name then begin
      Result := True;
      Exit;
    end;
  end;

  // Black List에서 검색
  for i := BlackMembers.Count - 1 downto 0 do begin
    if PTFriend(BlackMembers[i]).CharID = Name then begin
      Result := True;
      Exit;
    end;
  end;

end;

// 2003/04/15 친구, 쪽지
procedure TFrmMain.ClientGetDelFriend(msg: TDefaultMessage; body: string);
var
  i:    integer;
  str:  string;
  keep: boolean;
begin
  str  := DecodeString(body);
  keep := True;
  // 친구에서 검색
  for i := FriendMembers.Count - 1 downto 0 do begin
    if PTFriend(FriendMembers[i]).CharID = str then begin
      Dispose(PTFriend(FriendMembers[i]));
      FriendMembers.Delete(i);
      keep := False;
      break;
    end;
  end;

  // 친구에서 검색
  // Black List에서 검색
  for i := BlackMembers.Count - 1 downto 0 do begin
    if PTFriend(BlackMembers[i]).CharID = str then begin
      Dispose(PTFriend(BlackMembers[i]));
      BlackMembers.Delete(i);
      keep := False;
      break;
    end;
  end;


  // Block List에서 검색
  if keep then begin
    for i := BlockLists.Count - 1 downto 0 do begin
      if BlockLists[i] = str then begin
        BlockLists.Delete(i);
        keep := False;
        break;
      end;
    end;
  end;

  RecalcOnlinUserCount;

end;

procedure TFrmMain.RecalcOnlinUserCount;
var
  i: integer;
begin
  ConnectFriend := 0;
  for i := 0 to FriendMembers.Count - 1 do begin
    if PTFriend(FriendMembers[i]).Status >= 4 then
      Inc(ConnectFriend);
  end;

  ConnectBlack := 0;
  for i := 0 to BlackMembers.Count - 1 do begin
    if PTFriend(BlackMembers[i]).Status >= 4 then
      Inc(ConnectBlack);
  end;

end;

procedure TFrmMain.ClientGetUserInfo(msg: TDefaultMessage; body: string);
var
  i, j:    integer;
  str, fname, fmapinfo: string;
  fstatus: integer;
  keep:    boolean;
  fr:      PTFriend;
begin
  //   DScreen.AddSysMsg('SM_USER_INFO(BODY):'+body);
  str := DecodeString(body);
  //   DScreen.AddSysMsg('SM_USER_INFO:'+str);

  fstatus  := msg.param;
  fmapinfo := GetValidStr3(str, fname, ['/']);

  // 친구에서 검사
  for i := FriendMembers.Count - 1 downto 0 do begin
    if PTFriend(FriendMembers[i]).CharID = fname then begin
      PTFriend(FriendMembers[i]).Status := fstatus;
      break;
    end;
  end;

  // 악연에서 검사
  for i := BlackMembers.Count - 1 downto 0 do begin
    if PTFriend(BlackMembers[i]).CharID = fname then begin
      PTFriend(BlackMembers[i]).Status := fstatus;
      break;
    end;
  end;

  RecalcOnlinUserCount;
end;

procedure TFrmMain.ClientFriendSort(var datalist: TList; firstname: string);
var
  i, j: integer;
  firstpt, temppt: pointer;
begin
  // 2개이상이 되야 소트가 된다.
  if (datalist = nil) or (datalist.Count < 2) then
    Exit;

  firstpt := nil;

  // 처음으로 넣어야 되는것을 뺸다.
  if (firstname <> '') then begin
    for i := 0 to datalist.Count - 1 do begin
      if (PTFriend(datalist[i]).CharID = firstname) then begin
        firstpt := datalist[i];
        datalist.Delete(i);
        break;
      end;
    end;
  end;

  // 개수가 2보다 클경우에
  if datalist.Count >= 2 then begin
    for i := 0 to datalist.Count - 2 do begin
      for j := i + 1 to datalist.Count - 1 do begin
        if PTFriend(datalist[i]).CharID > PTFriend(datalist[j]).CharID then begin
          temppt      := datalist[i];
          datalist[i] := datalist[j];
          datalist[j] := temppt;
        end;
      end;
    end;
  end;

  // 처음에다 넣어준다.
  if firstpt <> nil then begin
    datalist.Insert(0, firstpt);
  end;

end;

procedure TFrmMain.ClientGetFriendInfo(msg: TDefaultMessage; body: string);
var
  i, j: integer;
  str, fname, fmemo: string;
  ftype, fstatus: integer;
  keep: boolean;
  fr:   PTFriend;
begin
  //   DScreen.AddSysMsg('SM_FRIEND_INFO(BODY):'+body);
  str := DecodeString(body);
  //   DScreen.AddSysMsg('SM_FRIEND_INFO:'+str);

  //str := GetValidStr3 (str, ftype, [' ']);
  //str := GetValidStr3 (str, fstatus, [' ']);
  ftype   := msg.param;
  fstatus := msg.tag;
  fmemo   := GetValidStr3(str, fname, ['/']);

  i := ftype;
  case i of
    RT_FRIENDS: begin
      keep := True;
      // 친구에서 검색
      for i := FriendMembers.Count - 1 downto 0 do begin
        if PTFriend(FriendMembers[i]).CharID = fname then begin
          PTFriend(FriendMembers[i]).Status := fstatus;
          PTFriend(FriendMembers[i]).Memo := fmemo;
          keep := False;
          break;
        end;
      end;
      if Keep then begin
        new(fr);
        fr.CharID := fname;
        fr.Status := fstatus;
        fr.Memo   := fmemo;
        FriendMembers.Add(fr);
      end;

      ClientFriendSort(FriendMembers, flover.GetName(RsState_Lover));
    end;
    RT_BLACKLIST: begin
      keep := True;
      // 친구에서 검색
      for i := BlackMembers.Count - 1 downto 0 do begin
        if PTFriend(BlackMembers[i]).CharID = fname then begin
          PTFriend(BlackMembers[i]).Status := fstatus;
          PTFriend(BlackMembers[i]).Memo := fmemo;
          keep := False;
          break;
        end;
      end;
      if Keep then begin
        new(fr);
        fr.CharID := fname;
        fr.Status := fstatus;
        fr.Memo   := fmemo;
        BlackMembers.Add(fr);
      end;

      ClientFriendSort(BlackMembers, '');
    end;
    RT_LOVERS: begin
    end;
    RT_MASTER: begin
    end;
    RT_DISCIPLE: begin
    end;
  end;

  RecalcOnlinUserCount;
end;

procedure TFrmMain.ClientGetFriendResult(msg: TDefaultMessage; body: string);
var
  i:    integer;
  str, fcmd, ferr, fname: string;
  keep: boolean;
  fr:   PTFriend;
begin
  str  := DecodeString(body);
  ferr := GetValidStr3(str, fcmd, [' ']);
  i    := StrToInt(ferr);
  case i of
    CR_FAIL: DScreen.AddChatBoardString(
        'Requested operation failed due to unknown error.', clWhite, clRed);
    CR_DONTFINDUSER: DScreen.AddChatBoardString(
        'The character name can not be found.', clWhite, clRed);
    CR_DONTADD: DScreen.AddChatBoardString('Buddy registration failed.',
        clWhite, clRed);
    CR_DONTDELETE: DScreen.AddChatBoardString('Buddy deletion failed.',
        clWhite, clRed);
    CR_DONTUPDATE: DScreen.AddChatBoardString('Buddy modification failed.',
        clWhite, clRed);
    CR_DONTACCESS: DScreen.AddChatBoardString(
        'Buddy information is not accessible.', clWhite, clRed);
    CR_LISTISMAX: DScreen.AddChatBoardString(
        'Maximum number of people allowed has exceeded.', clWhite, clRed);
    CR_LISTISMIN: DScreen.AddChatBoardString(
        'Minimum number of people allowed has reached.', clWhite, clRed);
  end;
end;

procedure TFrmMain.ClientGetTagAlarm(msg: TDefaultMessage; body: string);
var
  notreadcount: integer;
begin
  //     DScreen.AddSysMsg('SM_TAG_ARLARM:');
  notreadcount := msg.Param;
  if (notreadcount > 0) then begin
    DScreen.AddChatBoardString('You''ve got a note.', clWhite, clRed);
    MailAlarm := True;
  end;

end;

procedure TFrmMain.RecalcNotReadCount;
var
  i: integer;
begin
  // 읽지 않은개수를 갱신한다.
  NotReadMailCount := 0;
  for i := 0 to MailLists.Count - 1 do begin
    if (pTMail(MailLists[i]).Status = 0) then
      Inc(NotReadMailCount);
  end;

end;

procedure TFrmMain.ClientGetTagList(msg: TDefaultMessage; body: string);
var
  i:     integer;
  str:   string;
  MailStr: string;
  StateStr: string;
  DateStr: string;
  SenderStr: string;
  TotalCount: integer;
  PageCount: integer;
  pMail: pTMail;
begin
  str := DecodeString(body);
  //   DScreen.AddSysMsg('SM_TAG_LIST:'+str);

  PageCount  := msg.Param;
  TotalCount := msg.Tag;


  pMail := nil;
  for i := 0 to TotalCount - 1 do begin
    str     := GetValidStr3(str, MailStr, ['/']);
    MailStr := GetValidStr3(MailStr, StateStr, [':']);
    MailStr := GetValidStr3(MailStr, DateStr, [':']);
    MailStr := GetValidStr3(MailStr, SenderStr, [':']);

    new(pMail);

    pMail^.Sender := SenderStr;
    pMail^.Date   := DateStr;
    pMail^.Mail   := MailStr;
    pMail^.Status := Str_ToInt(StateStr, 0);

    MailLists.Insert(0, pMail);
  end;

  RecalcNotReadCount;
end;

procedure TFrmMain.ClientGetTagInfo(msg: TDefaultMessage; body: string);
var
  str:    string;
  i:      integer;
  Status: integer;
begin
  str    := DecodeString(body);
  Status := msg.Param;

  //   DScreen.AddSysMsg('SM_TAG_INFO:'+str + IntToStr(Status));


  for i := 0 to MailLists.Count - 1 do begin
    if pTMail(MailLists[i]).Date = str then begin
      // 삭제인경우에는 삭제하자
      if Status = 3 then begin
        dispose(MailLists[i]);
        MailLists.Delete(i);
      end else
        pTMail(MailLists[i]).Status := Status;

      break;
    end;
  end;

  RecalcNotReadCount;

end;

procedure TFrmMain.ClientGetTagRejectList(msg: TDefaultMessage; body: string);
var
  i:   integer;
  str: string;
  RejectStr: string;
  RejectCount: integer;
begin

  str := DecodeString(body);
  //   DScreen.AddSysMsg('SM_TAG_REJECT_LIST:'+str);

  RejectCount := msg.Param;

  for i := 0 to RejectCount - 1 do begin
    Str := GetValidStr3(str, RejectStr, ['/']);
    BlockLists.Add(RejectStr);
  end;

end;

procedure TFrmMain.ClientGetTagRejectAdd(msg: TDefaultMessage; body: string);
var
  str: string;
begin
  str := DecodeString(body);
  //   DScreen.AddSysMsg('SM_TAG_REJECT_ADD:'+str);

  BlockLists.Add(str);

end;

procedure TFrmMain.ClientGetTagRejectDelete(msg: TDefaultMessage; body: string);
var
  str: string;
  i:   integer;
begin
  str := DecodeString(body);
  //   DScreen.AddSysMsg('SM_TAG_REJECT_DELETE:'+str);

  for i := 0 to BlockLists.Count - 1 do begin
    if (BlockLists[i] = str) then begin
      BlockLists.Delete(i);
      break;
    end;
  end;
end;

procedure TFrmMain.ClientGetTagResult(msg: TDefaultMessage; body: string);
begin
end;

procedure TFrmMain.ClientGetLMList(msg: TDefaultMessage; body: string);
var
  _state:   integer;
  _level:   integer;
  _Sex:     integer;
  _Date:    string;
  _ServerDate: string;
  _Name:    string;
  _MapInfo: string;
  Count, i: integer;
  str:      string;
  infostr:  string;
  temp:     string;
begin
  str   := DecodeString(body);
  Count := msg.Param;

  //     DScreen.AddSysmsg ('SM_LM_LIST:'+intToStr(count)+','+str);

  for i := 0 to Count - 1 do begin
    str := GetValidStr3(str, infostr, ['/']);

    if infostr <> '' then begin
      infostr := GetValidStr3(InfoStr, temp, [':']);
      _State  := Str_ToInt(temp, 0);
      infostr := GetValidStr3(InfoStr, _Name, [':']);
      infostr := GetValidStr3(InfoStr, temp, [':']);
      _Level  := Str_ToInt(temp, 1);
      infostr := GetValidStr3(InfoStr, temp, [':']);
      _Sex    := Str_ToInt(temp, 0);
      infostr := GetValidStr3(InfoStr, _Date, [':']);
      infostr := GetValidStr3(InfoStr, _ServerDate, [':']);
      infostr := GetValidStr3(InfoStr, _MapInfo, [':']);

      fLover.Add(MySelf.UserName, _Name, _State, _Level, _Sex,
        _Date, _ServerDate, _MapInfo);

      ClientFriendSort(FriendMembers, flover.GetName(RsState_Lover));
      //            if _MapInfo <> '' then
      //            begin
      //                DScreen.AddChatBoardString (_Name+'님이 '+_MapInfo+'에 계십니다.', clWhite, clGreen);
      //            end;
    end;

  end;

end;

procedure TFrmMain.ClientGetLMOptionChange(msg: TDefaultMessage);
var
  optiontype, enable: integer;
begin
  optiontype := msg.Param;
  enable     := msg.Tag;
  case optiontype of
    1: begin
      fLover.SetEnable(rsState_Lover, enable);
      if enable = 1 then
        DScreen.AddChatBoardString('Available for relationship', clRed, clWhite)
      else
        DScreen.AddChatBoardString('Unavailable for relationship',
          clRed, clWhite);
    end;
  end;
  // DScreen.AddSysmsg ('SM_LM_OPTION:'+IntToStr( optiontype) + ','+ IntToStr( enable));

end;

procedure TFrmMain.ClientGetLMRequest(msg: TDefaultMessage; body: string);
var
  str:     string;
  ReqType: integer;
  ReqSeq:  integer;
begin
  str     := DecodeString(body);
  ReqType := msg.Param;
  ReqSeq  := msg.Tag;

  case ReqType of
    RsState_Lover: begin
      case ReqSeq of
        RsReq_WhoWantJoin: begin
          //                    if mrYes = FrmDlg.DMessageDlg (str+'님이 교제를 신청하였습니다.\교제성립후 교제를 중단할 경우 위약금으로 10만전이 자동지불됩니다.\교제하시겠습니까?', [mbYes, mbNo]) then
          if mrYes = FrmDlg.DMessageDlg(str +
            ' has invited you to a relationship.\Once the relationship is established, breaking the relationship\will result in '
            +
            'payment of 100,000 Gold in compensation for breach.\Will you engage in the relationship?',
            [mbYes, mbNo]) then
            SendLMRequest(ReqType, RsReq_AloowJoin)
          else
            SendLMRequest(ReqType, RsReq_DenyJoin);

        end;
      end;
    end;

  end;

  //   DScreen.AddSysmsg ('SM_LM_REQUEST:'+IntToStr( msg.param) + ','+IntToStr( msg.Tag) + ','+ str);
end;

procedure TFrmMain.ClientGetLMResult(msg: TDefaultMessage; body: string);
var
  str:     string;
  reqtype: integer;
  errcode: integer;
begin
  str     := DecodeString(body);
  reqtype := msg.Param;
  errcode := msg.Tag;

  case reqtype of
    RsState_Lover: begin
      case errcode of
        RsError_SuccessJoin://= 1;         // 참가에 성공하였다 ( 참가한사람쪽)
        begin
          //                FrmDlg.DMessageDlg (str+'님과 연인이 되었습니다.', [mbYes]);
          FrmDlg.AddFriend(str, False);
          PlaySound(154);
        end;
        RsError_SuccessJoined://= 2;         // 참가에 성공되어졌다 ( 참가된 사람쪽)
        begin
          //                FrmDlg.DMessageDlg (str+'님이 교제를 허락하여 연인이 되었습니다.', [mbYes]);
          FrmDlg.AddFriend(str, False);
          PlaySound(154);
        end;
        RsError_DontJoin://= 3;         // 참가할 수 없다
          //            FrmDlg.DMessageDlg (str+'님이 교제 승낙 여부를 결정중입니다.', [mbOK]);
          FrmDlg.DMessageDlg(
            str + ' is deciding on whether to engage in the relationship.', [mbOK]);

        RsError_DontLeave://= 4;         // 떠날수 없다.
          FrmDlg.DMessageDlg('Cannot break the relationship with ' + 'str.', [mbOK]);
        RsError_RejectMe://= 5;         // 거부상태이다
          //            FrmDlg.DMessageDlg ('당신은 현재 교제상태가 아닙니다. \교제가능상태로 전환하기 위해서는 교제선택 버튼을 클릭하여 주십시오.', [mbOK]);
          FrmDlg.DMessageDlg(
            'You are currently not engaged in a relationship.\To transfer to ''Available,'' click the ''Select Availability'' button.',
            [mbOK]);
        RsError_RejectOther://= 6;         // 거부상태이다
          FrmDlg.DMessageDlg(str + ' is currently unavailable.', [mbOK]);
        RsError_LessLevelMe://= 7;         // 나의레벨이 낮다
          FrmDlg.DMessageDlg(
            'Only levels of 22 or higher can invite others to a relationship.', [mbOK]);
        RsError_LessLevelOther://= 8;         // 상대방의레벨이 낮다
          FrmDlg.DMessageDlg(
            str + ' must be level 22 or above to start a relationship.', [mbOK]);
        RsError_EqualSex://= 9;         // 성별이 같다
          FrmDlg.DMessageDlg(
            'Two of the same gender cannot start a relationship.', [mbOK]);
        RsError_FullUser://= 10;        // 참여인원이 가득찼다
          FrmDlg.DMessageDlg(
            str +
            ' is already engaged in a relationship,\ and therefore unavailable for another relationship.',
            [mbOK]);
        RsError_CancelJoin://= 11;        // 참가취소
          DScreen.AddChatBoardString('Invitation to the relationship canceled.',
            clGreen, clWhite);
        RsError_DenyJoin://= 12;        // 참가를 거절함
          FrmDlg.DMessageDlg(
            str + ' has refused your invitation to a relationship.', [mbOK]);
        RsError_DontDelete://= 13;        // 탈퇴시킬수 없다.
          FrmDlg.DMessageDlg('Cannot break the relationship with ' + str + '.', [mbOK]);
        RsError_SuccessDelete://= 14;        // 탈퇴시켰음
        begin
          PlaySound(155);
          FrmDlg.DMessageDlg('The relationship with ' + str +
            ' has been broken.', [mbOK]);
        end;
        RsError_NotRelationShip://= 15;        // 교제상태가 아니다.
          FrmDlg.DMessageDlg('You are currently not engaged in a relationship.',
            [mbOK]);
      end;
    end;
  end;

  // DScreen.AddSysmsg ('SM_LM_RESULT:'+IntToStr( msg.param) + ','+IntToStr( msg.Tag) + ','+ str);
end;

procedure TFrmMain.ClientGetLMDelete(msg: TDefaultMessage; body: string);
var
  str:     string;
  ReqType: integer;
begin
  str     := DecodeString(body);
  ReqType := msg.Param;
  fLover.Delete(str);
end;


procedure TFrmMain.SendAddFriend(Data: string; FriendType: integer);
var
  msg: TDefaultMessage;
begin
  //   DScreen.AddSysMsg('CM_FRIEND_ADD:'+data);
  // TO DO , FRIEND = 1 (wparam ) , BLACKLIST = 8
  msg := MakeDefaultMsg(CM_FRIEND_ADD, 0, FriendType, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Data));
end;

procedure TFrmMain.SendAddReject(Data: string);
var
  msg: TDefaultMessage;
begin
  //   DScreen.AddSysMsg('CM_TAG_REJECT_ADD:'+data);
  msg := MakeDefaultMsg(CM_TAG_REJECT_ADD, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Data));
end;

procedure TFrmMain.SendDelReject(Data: string);
var
  msg: TDefaultMessage;
begin
  //   DScreen.AddSysMsg('CM_TAG_REJECT_DELETE:'+data);
  msg := MakeDefaultMsg(CM_TAG_REJECT_DELETE, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Data));
end;

procedure TFrmMain.SendLMOptionChange(OptionType: integer; Enable: integer);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_LM_OPTION, OptionType, Enable, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendLMRequest(ReqType: integer; ReqSeq: integer);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_LM_REQUEST, ReqType, ReqSeq, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendLMSeparate(ReqType: integer; Data: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_LM_DELETE, ReqType, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Data));
end;

procedure TFrmMain.SendDelFriend(Data: string);
var
  msg: TDefaultMessage;
begin
  //   DScreen.AddSysMsg('CM_FRIEND_DELETE:'+data);
  msg := MakeDefaultMsg(CM_FRIEND_DELETE, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Data));
end;

procedure TFrmMain.SendMail(Data: string);
var
  msg: TDefaultMessage;
begin
  if frmDlg.BoMemoJangwon then begin
    msg := MakeDefaultMsg(CM_GUILDAGIT_TAG_ADD, 0, 0, 0, 0);
    frmDlg.BoMemoJangwon := False;
  end else
    msg := MakeDefaultMsg(CM_TAG_ADD, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Data));
end;

procedure TFrmMain.SendReadingMail(Data: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_TAG_SETINFO, 0, 1, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Data));
end;

procedure TFrmMain.SendDelMail(Data: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_TAG_DELETE, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Data));
end;

procedure TFrmMain.SendLockMail(Data: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_TAG_SETINFO, 0, 2, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Data));
end;

procedure TFrmMain.SendUnLockMail(Data: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_TAG_SETINFO, 0, 3, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Data));
end;


procedure TFrmMain.SendMailList;
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_TAG_LIST, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendRejectList;
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_TAG_REJECT_LIST, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg));
end;

procedure TFrmMain.SendUpdateFriend(Data: string);
var
  msg: TDefaultMessage;
begin
  msg := MakeDefaultMsg(CM_FRIEND_EDIT, 0, 0, 0, 0);
  SendSocket(EncodeMessage(msg) + EncodeString(Data));
end;

procedure TFrmMain.DelitemProg;
begin
  DelItemBag(DelTempItem.S.Name, DelTempItem.MakeIndex);
end;

procedure TFrmMain.RunEffectTimerTimer(Sender: TObject);
var
  tx, ty, n, kx, ky, i: integer;
  bofly: boolean;
begin

  tx := Myself.XX;
  ty := Myself.YY;

  Randomize;
  RunEffectTimer.Tag := RunEffectTimer.Tag + 1;
  n  := random(4);
  kx := random(5) + 1;
  ky := random(4) + 1;
  if RunEffectTimer.Tag > 1000000 then
    RunEffectTimer.Tag := 1000;

  if EffectNum = 1 then begin
    case random(5) of
      0: RunEffectTimer.Interval := 400;
      1: RunEffectTimer.Interval := 600;
      2: RunEffectTimer.Interval := 800;
      3: RunEffectTimer.Interval := 1000;
      4: RunEffectTimer.Interval := 1500;
    end;

    case n of
      0: if Map.CanMove(tx + kx, ty - ky) then
          PlayScene.NewMagic(nil, MAGIC_DUN_THUNDER, MAGIC_DUN_THUNDER,
            tx + kx, ty - ky, tx + kx, ty - ky, 0, mtThunder, False, 30, bofly);
      1: if Map.CanMove(tx - kx, ty + ky) then
          PlayScene.NewMagic(nil, MAGIC_DUN_THUNDER, MAGIC_DUN_THUNDER,
            tx - kx, ty + ky, tx - kx, ty + ky, 0, mtThunder, False, 30, bofly);
      2: if Map.CanMove(tx - kx, ty - ky) then
          PlayScene.NewMagic(nil, MAGIC_DUN_THUNDER, MAGIC_DUN_THUNDER,
            tx - kx, ty - ky, tx - kx, ty - ky, 0, mtThunder, False, 30, bofly);
      3: if Map.CanMove(tx + kx, ty + ky) then
          PlayScene.NewMagic(nil, MAGIC_DUN_THUNDER, MAGIC_DUN_THUNDER,
            tx + kx, ty + ky, tx + kx, ty + ky, 0, mtThunder, False, 30, bofly);
    end;
    PlaySound(8301);

  end else if EffectNum = 2 then begin
    case random(RunEffectTimer.Tag) mod 5 of
      0: RunEffectTimer.Interval := 1000;
      1: RunEffectTimer.Interval := 1500;
      2: RunEffectTimer.Interval := 2000;
      3: RunEffectTimer.Interval := 2500;
      4: RunEffectTimer.Interval := 3000;
    end;

    case n of
      0: if Map.CanMove(tx + kx, ty - ky) then begin
          PlayScene.NewMagic(nil, MAGIC_DUN_FIRE1, MAGIC_DUN_FIRE1,
            tx + kx, ty - ky, tx + kx, ty - ky, 0, mtThunder, False, 30, bofly);
          PlayScene.NewMagic(nil, MAGIC_DUN_FIRE2, MAGIC_DUN_FIRE2,
            tx + kx, ty - ky, tx + kx, ty - ky, 0, mtThunder, False, 30, bofly);
        end;
      1: if Map.CanMove(tx - kx, ty + ky) then begin
          PlayScene.NewMagic(nil, MAGIC_DUN_FIRE1, MAGIC_DUN_FIRE1,
            tx - kx, ty + ky, tx - kx, ty + ky, 0, mtThunder, False, 30, bofly);
          PlayScene.NewMagic(nil, MAGIC_DUN_FIRE2, MAGIC_DUN_FIRE2,
            tx - kx, ty + ky, tx - kx, ty + ky, 0, mtThunder, False, 30, bofly);
        end;
      2: if Map.CanMove(tx - kx, ty - ky) then begin
          PlayScene.NewMagic(nil, MAGIC_DUN_FIRE1, MAGIC_DUN_FIRE1,
            tx - kx, ty - ky, tx - kx, ty - ky, 0, mtThunder, False, 30, bofly);
          PlayScene.NewMagic(nil, MAGIC_DUN_FIRE2, MAGIC_DUN_FIRE2,
            tx - kx, ty - ky, tx - kx, ty - ky, 0, mtThunder, False, 30, bofly);
        end;
      3: if Map.CanMove(tx + kx, ty + ky) then begin
          PlayScene.NewMagic(nil, MAGIC_DUN_FIRE1, MAGIC_DUN_FIRE1,
            tx + kx, ty + ky, tx + kx, ty + ky, 0, mtThunder, False, 30, bofly);
          PlayScene.NewMagic(nil, MAGIC_DUN_FIRE2, MAGIC_DUN_FIRE2,
            tx + kx, ty + ky, tx + kx, ty + ky, 0, mtThunder, False, 30, bofly);
        end;
    end;
    PlaySound(8302);
  end;

end;

procedure TFrmMain.MainCancelItemMoving;
begin
  FrmDlg.CancelItemMoving;
end;

procedure TFrmMain.FormKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Myself = nil) or (DScreen.CurrentScene <> PlayScene) then
    exit;
  case Key of
    VK_TAB: begin
      SendPickup; //2004/06/16 Tab키로 줍기
      TabClickTime := GetTickCount;
    end;
  end;

end;

function NPGameMonCallback(dwMsg: DWORD; dwArg: DWORD): boolean cdecl;
begin
  case dwMsg of
    NPGAMEMON_COMM_ERROR,
    NPGAMEMON_COMM_CLOSE: begin
      GameClose := True;
      //         FrmDlg.OnlyMessageDlg ('핵킹 프로그램 사용을 중지해 주십시요. Code='+IntToStr(dwMsg),[mbOk]);
      Result    := False;
    end;
    NPGAMEMON_INIT_ERROR: begin
      GameClose := True;
      FrmDlg.OnlyMessageDlg('GameGuard initialization error : ' +
        IntToStr(dwArg), [mbOK]);
      Result := False;
    end;
    NPGAMEMON_SPEEDHACK: begin
      GameClose := True;
      FrmDlg.OnlyMessageDlg('Speedhack detected. Code=' + IntToStr(dwMsg), [mbOK]);
      Result := False;
    end;
    NPGAMEMON_GAMEHACK_KILLED: begin
      GameClose := True;
      FrmDlg.OnlyMessageDlg('Gamehack detected. Code=' + IntToStr(dwMsg), [mbOK]);
      Result := False;
    end;
    NPGAMEMON_GAMEHACK_DETECT: begin
      GameClose := True;
      //         FrmDlg.DMessageDlg ('게임핵이 발견되었습니다. Code='+IntToStr(dwMsg),[mbOk]);
      FrmDlg.OnlyMessageDlg('Gamehack detected. Code=' + IntToStr(dwMsg), [mbOK]);
      Result := False;
    end;
    NPGAMEMON_GAMEHACK_DOUBT: begin
      GameClose := True;
      FrmDlg.OnlyMessageDlg('game or GameGuard file corrupted. Code=' +
        IntToStr(dwMsg), [mbOK]);
      Result := False;
      //         CloseNPGameMon;
      //         FrmMain.Close;
    end;
    else
      Result := True;
  end;
  //      FrmDlg.DMessageDlg ('메세지 검사 Code='+IntToStr(dwMsg),[mbOk]);
end;


procedure TFrmMain.DXDraw1FinalizeSurface(Sender: TObject);
begin
{  WTiles.ClearCache;
  WObjects1.ClearCache;
  WObjects2.ClearCache;
  WObjects3.ClearCache;
  WObjects4.ClearCache;
  WObjects5.ClearCache;
  WObjects6.ClearCache;
  WObjects7.ClearCache;
  WObjects8.ClearCache;
  WObjects9.ClearCache;
  WObjects10.ClearCache;
  WSmTiles.ClearCache;
  WProgUse.ClearCache;
  WProgUse2.ClearCache;
  WChrSel.ClearCache;
  WMMap.ClearCache;
  WBagItem.ClearCache;
  WStateItem.ClearCache;
  WDnItem.ClearCache;
  WHumImg.ClearCache;
  WHairImg.ClearCache;
  WHumWing.ClearCache;
  WWeapon.ClearCache;
  WMagic.ClearCache;
  WMagic2.ClearCache;
  WMagIcon.ClearCache;
  WMonImg.ClearCache;
  WMon2Img.ClearCache;
  WMon3Img.ClearCache;
  WMon4Img.ClearCache;
  WMon5Img.ClearCache;
  WMon6Img.ClearCache;
  WMon7Img.ClearCache;
  WMon8Img.ClearCache;
  WMon9Img.ClearCache;
  WMon10Img.ClearCache;
  WMon11Img.ClearCache;
  WMon12Img.ClearCache;
  WMon13Img.ClearCache;
  WMon14Img.ClearCache;
  WMon15Img.ClearCache;
  WMon16Img.ClearCache;
  WMon17Img.ClearCache;
  WMon18Img.ClearCache;
  WMon19Img.ClearCache;
  WMon20Img.ClearCache;
  WMon21Img.ClearCache;
  WMon22Img.ClearCache;
  WMon23Img.ClearCache;
  WMon24Img.ClearCache;
  WKillerWeaponL.ClearCache;
  WKillerWeaponR.ClearCache;
  WKillerHumImg.ClearCache;
  WKillerHairImg.ClearCache;
  WMon25Img.ClearCache;
  WDragonImg.ClearCache;
  WNpcImg.ClearCache;
  WDecoImg.ClearCache;
  WEffectImg.ClearCache;}
end;

procedure TFrmMain.DXDraw1RestoreSurface(Sender: TObject);
begin
{  WTiles.DDraw     := DxDraw1.DDraw;
  WObjects1.DDraw  := DxDraw1.DDraw;
  WObjects2.DDraw  := DxDraw1.DDraw;
  WObjects3.DDraw  := DxDraw1.DDraw;
  WObjects4.DDraw  := DxDraw1.DDraw;
  WObjects5.DDraw  := DxDraw1.DDraw;
  WObjects6.DDraw  := DxDraw1.DDraw;
  WObjects7.DDraw  := DxDraw1.DDraw;
  WObjects8.DDraw  := DxDraw1.DDraw;
  WObjects9.DDraw  := DxDraw1.DDraw;
  WObjects10.DDraw := DxDraw1.DDraw;
  WSmTiles.DDraw   := DxDraw1.DDraw;
  WProgUse.DDraw   := DxDraw1.DDraw;
  WProgUse2.DDraw  := DxDraw1.DDraw;
  WChrSel.DDraw    := DxDraw1.DDraw;
  WMMap.DDraw      := DxDraw1.DDraw;
  WBagItem.DDraw   := DxDraw1.DDraw;
  WStateItem.DDraw := DxDraw1.DDraw;
  WDnItem.DDraw    := DxDraw1.DDraw;
  WHumImg.DDraw    := DxDraw1.DDraw;
  WHairImg.DDraw   := DxDraw1.DDraw;
  WHumWing.DDraw   := DxDraw1.DDraw;
  WWeapon.DDraw    := DxDraw1.DDraw;
  WMagic.DDraw     := DxDraw1.DDraw;
  WMagic2.DDraw    := DxDraw1.DDraw;
  WMagIcon.DDraw   := DxDraw1.DDraw;
  WMonImg.DDraw    := DxDraw1.DDraw;
  WMon2Img.DDraw   := DxDraw1.DDraw;
  WMon3Img.DDraw   := DxDraw1.DDraw;
  WMon4Img.DDraw   := DxDraw1.DDraw;
  WMon5Img.DDraw   := DxDraw1.DDraw;
  WMon6Img.DDraw   := DxDraw1.DDraw;
  WMon7Img.DDraw   := DxDraw1.DDraw;
  WMon8Img.DDraw   := DxDraw1.DDraw;
  WMon9Img.DDraw   := DxDraw1.DDraw;
  WMon10Img.DDraw  := DxDraw1.DDraw;
  WMon11Img.DDraw  := DxDraw1.DDraw;
  WMon12Img.DDraw  := DxDraw1.DDraw;
  WMon13Img.DDraw  := DxDraw1.DDraw;
  WMon14Img.DDraw  := DxDraw1.DDraw;
  WMon15Img.DDraw  := DxDraw1.DDraw;
  WMon16Img.DDraw  := DxDraw1.DDraw;
  WMon17Img.DDraw  := DxDraw1.DDraw;
  WMon18Img.DDraw  := DxDraw1.DDraw;
  WMon19Img.DDraw  := DxDraw1.DDraw;
  WMon20Img.DDraw  := DxDraw1.DDraw;
  WMon21Img.DDraw  := DxDraw1.DDraw;
  WMon22Img.DDraw  := DxDraw1.DDraw;
  WMon23Img.DDraw  := DxDraw1.DDraw;
  WMon24Img.DDraw  := DxDraw1.DDraw;
  WKillerWeaponL.DDraw    := DxDraw1.DDraw;
  WKillerWeaponR.DDraw    := DxDraw1.DDraw;
  WKillerHumImg.DDraw    := DxDraw1.DDraw;
  WKillerHairImg.DDraw    := DxDraw1.DDraw;
  WMon25Img.DDraw  := DxDraw1.DDraw;
  WDragonImg.DDraw := DxDraw1.DDraw;
  WNpcImg.DDraw    := DxDraw1.DDraw;
  WDecoImg.DDraw   := DxDraw1.DDraw;
  WEffectImg.DDraw := DxDraw1.DDraw;}

{  WProgUse.DxDraw  := DxDraw1;
  WProgUse.DDraw   := DxDraw1.DDraw;
  //WProgUse.Initialize;

  WProgUse2.DxDraw  := DxDraw1;
  WProgUse2.DDraw   := DxDraw1.DDraw;
  //WProgUse.Initialize;

  WChrSel.DxDraw  := DxDraw1;
  WChrSel.DDraw   := DxDraw1.DDraw;
  //WChrSel.Initialize;}
end;

end.
