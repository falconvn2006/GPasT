unit FState;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DWinCtl, StdCtrls, DXDraws, Grids, Grobal2, clFunc, hUtil32, cliUtil,
  MapUnit, SoundUtil, comobj, RelationShip, MaketSystem;

const
  BOTTOMBOARD = 1;
  VIEWCHATLINE = 9;
  MAXSTATEPAGE = 4;
  LISTLINEHEIGHT = 13;
  LISTLINEHEIGHT2 = 14;
  MAKETLINEHEIGHT = 19;
  REPLYIMGPOS = 20;
  MAXMENU     = 10;
  DECOMAXMENU = 12;

  RING_OF_UNKNOWN     = 130;
  BRACELET_OF_UNKNOWN = 131;
  HELMET_OF_UNKNOWN   = 132;
  // 아이템 업그레이드
  UPITEMSUCCESSOFFSET = 633;//3960;

  // 친구 ,쪽지
  MAX_FRIEND_COUNT = 20;
  VIEW_FRIEND = 1;
  VIEW_MAILSEND = 2;
  VIEW_MAILREAD = 3;
  VIEW_MEMO = 4;

  AdjustAbilHints: array[0..8] of string = (
    'Destructive power ',
    'Magic power (for Wizard)',
    'Zen power (for Taoist)',
    'Defense ability ',
    'Magical defense strength',
    'Physical strength ',
    'Magic power',
    'Accuracy ',
    'Evasion ability '
    );

type

  TSpotDlgMode = (dmSell, dmRepair, dmStorage, dmMaketSell);

  TClickPoint = record
    rc:   TRect;
    RStr: string;
  end;
  PTClickPoint = ^TClickPoint;

  TDiceInfo = record
    DiceResult:  integer;
    DiceCurrent: integer;
    DiceLeft, DiceTop: integer;
    DiceCount:   integer;
    DiceLimit:   integer;
    DiceTime:    longword;
  end;

  TFrmDlg = class(TForm)
    DStateWin:  TDWindow;
    DBackground: TDWindow;
    DItemBag:   TDWindow;
    DBottom:    TDWindow;
    DMyState:   TDButton;
    DMyBag:     TDButton;
    DMyMagic:   TDButton;
    DOption:    TDButton;
    DGold:      TDButton;
    DPrevState: TDButton;
    DRepairItem: TDButton;
    DCloseBag:  TDButton;
    DCloseState: TDButton;
    DLogIn:     TDWindow;
    DLoginNew:  TDButton;
    DLoginOk:   TDButton;
    DNewAccount: TDWindow;
    DNewAccountOk: TDButton;
    DLoginClose: TDButton;
    DNewAccountClose: TDButton;
    DSelectChr: TDWindow;
    DscSelect1: TDButton;
    DscSelect2: TDButton;
    DscStart:   TDButton;
    DscNewChr:  TDButton;
    DscEraseChr: TDButton;
    DscCredits: TDButton;
    DscExit:    TDButton;
    DCreateChr: TDWindow;
    DccWarrior: TDButton;
    DccWizzard: TDButton;
    DccMonk:    TDButton;
    DccAssasin: TDButton;
    DccMale:    TDButton;
    DccFemale:  TDButton;
    DccLeftHair: TDButton;
    DccRightHair: TDButton;
    DccOk:      TDButton;
    DccClose:   TDButton;
    DItemGrid:  TDGrid;
    DLoginChgPw: TDButton;
    DMsgDlg:    TDWindow;
    DMsgDlgOk:  TDButton;
    DMsgDlgYes: TDButton;
    DMsgDlgCancel: TDButton;
    DMsgDlgNo:  TDButton;
    DNextState: TDButton;
    DSWNecklace: TDButton;
    DSWLight:   TDButton;
    DSWArmRingR: TDButton;
    DSWArmRingL: TDButton;
    DSWRingR:   TDButton;
    DSWRingL:   TDButton;
    DSWWeapon:  TDButton;
    DSWDress:   TDButton;
    DSWHelmet:  TDButton;
    DBelt1:     TDButton;
    DBelt2:     TDButton;
    DBelt3:     TDButton;
    DBelt4:     TDButton;
    DBelt5:     TDButton;
    DBelt6:     TDButton;
    DChgPw:     TDWindow;
    DChgpwOk:   TDButton;
    DChgpwCancel: TDButton;
    DMerchantDlg: TDWindow;
    DMerchantDlgClose: TDButton;
    DMenuDlg:   TDWindow;
    DMenuPrev:  TDButton;
    DMenuNext:  TDButton;
    DMenuBuy:   TDButton;
    DMenuClose: TDButton;
    DSellDlg:   TDWindow;
    DSellDlgOk: TDButton;
    DSellDlgClose: TDButton;
    DSellDlgSpot: TDButton;
    DStMag1:    TDButton;
    DStMag2:    TDButton;
    DStMag3:    TDButton;
    DStMag4:    TDButton;
    DStMag5:    TDButton;
    DKeySelDlg: TDWindow;
    DKsIcon:    TDButton;
    DKsF1:      TDButton;
    DKsF2:      TDButton;
    DKsF3:      TDButton;
    DKsF4:      TDButton;
    DKsNone:    TDButton;
    DKsOk:      TDButton;
    DBotGroup:  TDButton;
    DBotTrade:  TDButton;
    DBotMiniMap: TDButton;
    DGroupDlg:  TDWindow;
    DGrpAllowGroup: TDButton;
    DGrpDlgClose: TDButton;
    DGrpCreate: TDButton;
    DGrpAddMem: TDButton;
    DGrpDelMem: TDButton;
    DBotLogout: TDButton;
    DBotExit:   TDButton;
    DBotGuild:  TDButton;
    DStPageUp:  TDButton;
    DStPageDown: TDButton;
    DDealRemoteDlg: TDWindow;
    DDealDlg:   TDWindow;
    DDRGrid:    TDGrid;
    DDGrid:     TDGrid;
    DDealOk:    TDButton;
    DDealClose: TDButton;
    DDGold:     TDButton;
    DDRGold:    TDButton;
    DSelServerDlg: TDWindow;
    DSSrvClose: TDButton;
    DSServer1:  TDButton;
    DSServer2:  TDButton;
    DUserState1: TDWindow;
    DCloseUS1:  TDButton;
    DWeaponUS1: TDButton;
    DHelmetUS1: TDButton;
    DNecklaceUS1: TDButton;
    DDressUS1:  TDButton;
    DLightUS1:  TDButton;
    DArmringRUS1: TDButton;
    DRingRUS1:  TDButton;
    DArmringLUS1: TDButton;
    DRingLUS1:  TDButton;
    DSServer3:  TDButton;
    DSServer4:  TDButton;
    DGuildDlg:  TDWindow;
    DGDHome:    TDButton;
    DGDList:    TDButton;
    DGDChat:    TDButton;
    DGDAddMem:  TDButton;
    DGDDelMem:  TDButton;
    DGDEditNotice: TDButton;
    DGDEditGrade: TDButton;
    DGDAlly:    TDButton;
    DGDBreakAlly: TDButton;
    DGDWar:     TDButton;
    DGDCancelWar: TDButton;
    DGDUp:      TDButton;
    DGDDown:    TDButton;
    DGDClose:   TDButton;
    DGuildEditNotice: TDWindow;
    DGEClose:   TDButton;
    DGEOk:      TDButton;
    DSServer5:  TDButton;
    DSServer6:  TDButton;
    DNewAccountCancel: TDButton;
    DAdjustAbility: TDWindow;
    DPlusDC:    TDButton;
    DPlusMC:    TDButton;
    DPlusSC:    TDButton;
    DPlusAC:    TDButton;
    DPlusMAC:   TDButton;
    DPlusHP:    TDButton;
    DPlusMP:    TDButton;
    DPlusHit:   TDButton;
    DPlusSpeed: TDButton;
    DMinusDC:   TDButton;
    DMinusMC:   TDButton;
    DMinusSC:   TDButton;
    DMinusAC:   TDButton;
    DMinusMAC:  TDButton;
    DMinusMP:   TDButton;
    DMinusHP:   TDButton;
    DMinusHit:  TDButton;
    DMinusSpeed: TDButton;
    DAdjustAbilClose: TDButton;
    DAdjustAbilOk: TDButton;
    DBotPlusAbil: TDButton;
    DKsF5:      TDButton;
    DKsF6:      TDButton;
    DKsF7:      TDButton;
    DKsF8:      TDButton;
    DEngServer1: TDButton;
    DSServer8:  TDButton;
    DSServer7:  TDButton;
    DSServer9:  TDButton;
    DSServer10: TDButton;
    DSServer11: TDButton;
    DSServer12: TDButton;
    DSServer13: TDButton;
    DSServer14: TDButton;
    DSServer15: TDButton;
    DSServer16: TDButton;
    DSServer17: TDButton;
    DSServer18: TDButton;
    DSServer19: TDButton;
    DSServer20: TDButton;
    DSServer21: TDButton;
    DSServer22: TDButton;
    DSServer23: TDButton;
    DSServer24: TDButton;
    DSServer25: TDButton;
    DSServer26: TDButton;
    DSServer27: TDButton;
    DSServer28: TDButton;
    DSWBujuk:   TDButton;
    DSWBelt:    TDButton;
    DSWBoots:   TDButton;
    DSWCharm:   TDButton;
    DBujukUS1:  TDButton;
    DBeltUS1:   TDButton;
    DBootsUS1:  TDButton;
    DCharmUS1:  TDButton;
    DKsConF1:   TDButton;
    DKsConF5:   TDButton;
    DKsConF2:   TDButton;
    DKsConF6:   TDButton;
    DKsConF3:   TDButton;
    DKsConF7:   TDButton;
    DKsConF4:   TDButton;
    DKsConF8:   TDButton;
    DCountDlg:  TDWindow;
    DCountDlgMax: TDButton;
    DCountDlgOk: TDButton;
    DCountDlgClose: TDButton;
    DCountDlgCancel: TDButton;
    DMakeitemGrid: TDGrid;
    DMakeItemDlg: TDWindow;
    DMakeItemDlgOk: TDButton;
    DMakeItemDlgCancel: TDButton;
    DMakeItemDlgClose: TDButton;
    DFriendDlg: TDWindow;
    DFrdFriend: TDButton;
    DFrdBlackList: TDButton;
    DFrdClose:  TDButton;
    DFrdPgUp:   TDButton;
    DFrdPgDn:   TDButton;
    DFrdWhisper: TDButton;
    DFrdMail:   TDButton;
    DFrdMemo:   TDButton;
    DFrdDel:    TDButton;
    DFrdAdd:    TDButton;
    DMailListDlg: TDWindow;
    DMLReply:   TDButton;
    DMLRead:    TDButton;
    DMLDel:     TDButton;
    DMLLock:    TDButton;
    DMLBlock:   TDButton;
    DMailListClose: TDButton;
    DMailListPgUp: TDButton;
    DMailListPgDn: TDButton;
    DMailDlg:   TDWindow;
    DMailOK:    TDButton;
    DMailClose: TDButton;
    DBlockListDlg: TDWindow;
    DBlockListClose: TDButton;
    DBLPgUp:    TDButton;
    DBLPgDn:    TDButton;
    DBLDel:     TDButton;
    DBLAdd:     TDButton;
    DMemo:      TDWindow;
    DMemoB1:    TDButton;
    DMemoB2:    TDButton;
    DMemoClose: TDButton;
    DItemMarketDlg: TDWindow;
    DItemBuy:   TDButton;
    DItemSellCancel: TDButton;
    DItemCancel: TDButton;
    DItemFind:  TDButton;
    DItemMarketClose: TDButton;
    DItemListPrev: TDButton;
    DItemListRefresh: TDButton;
    DItemListNext: TDButton;
    DMGold:     TDButton;
    DJangwonListDlg: TDWindow;
    DJangListPrev: TDButton;
    DJangMemo:  TDButton;
    DJangListNext: TDButton;
    DJangwonClose: TDButton;
    DGABoardListDlg: TDWindow;
    DGABoardOk: TDButton;
    DGABoardWrite: TDButton;
    DGABoardNotice: TDButton;
    DGABoardListClose: TDButton;
    DGABoardListPrev: TDButton;
    DGABoardListRefresh: TDButton;
    DGABoardListNext: TDButton;
    DGABoardDlg: TDWindow;
    DGABoardDel: TDButton;
    DGABoardMemo: TDButton;
    DGABoardClose: TDButton;
    DGABoardReply: TDButton;
    DGABoardOk2: TDButton;
    DGABoardCancel: TDButton;
    DGADecorateDlg: TDWindow;
    DGADecorateListPrev: TDButton;
    DGADecorateListNext: TDButton;
    DGADecorateBuy: TDButton;
    DGADecorateCancel: TDButton;
    DGADecorateClose: TDButton;
    DBotFriend: TDButton;
    DBotMemo:   TDButton;
    DDealJangwon: TDWindow;
    DMasterDlg: TDWindow;
    DLover1:    TDButton;
    DLover2:    TDButton;
    DLover3:    TDButton;
    DMaster3:   TDButton;
    DMaster2:   TDButton;
    DMaster1:   TDButton;
    DMasterClose: TDButton;
    DMarketMemo: TDButton;
    DHeartImg:  TDButton;
    DHeartImgUS: TDButton;
    DBotMaster: TDButton;
    DscSelect3: TDButton;
    DscSelect4: TDButton;
    procedure DBottomInRealArea(Sender: TObject; X, Y: integer;
      var IsRealArea: boolean);
    procedure DBottomDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DMyStateDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DOptionClick(Sender: TObject);
    procedure DItemBagDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DRepairItemDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DRepairItemInRealArea(Sender: TObject; X, Y: integer;
      var IsRealArea: boolean);
    procedure DStateWinDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure FormCreate(Sender: TObject);
    procedure DPrevStateDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DLoginNewDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DscSelect1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DccCloseDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DItemGridGridSelect(Sender: TObject; ACol, ARow: integer;
      Shift: TShiftState);
    procedure DItemGridGridPaint(Sender: TObject; ACol, ARow: integer;
      Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
    procedure DItemGridDblClick(Sender: TObject);
    procedure DMsgDlgOkDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DMsgDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DMsgDlgKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure DCloseBagDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DBackgroundBackgroundClick(Sender: TObject);
    procedure DItemGridGridMouseMove(Sender: TObject; ACol, ARow: integer;
      Shift: TShiftState);
    procedure DBelt1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure FormDestroy(Sender: TObject);
    procedure DBelt1DblClick(Sender: TObject);
    procedure DLoginCloseClick(Sender: TObject; X, Y: integer);
    procedure DLoginOkClick(Sender: TObject; X, Y: integer);
    procedure DLoginNewClick(Sender: TObject; X, Y: integer);
    procedure DLoginChgPwClick(Sender: TObject; X, Y: integer);
    procedure DNewAccountOkClick(Sender: TObject; X, Y: integer);
    procedure DNewAccountCloseClick(Sender: TObject; X, Y: integer);
    procedure DccCloseClick(Sender: TObject; X, Y: integer);
    procedure DChgpwOkClick(Sender: TObject; X, Y: integer);
    procedure DscSelect1Click(Sender: TObject; X, Y: integer);
    procedure DCloseStateClick(Sender: TObject; X, Y: integer);
    procedure DPrevStateClick(Sender: TObject; X, Y: integer);
    procedure DNextStateClick(Sender: TObject; X, Y: integer);
    procedure DSWWeaponClick(Sender: TObject; X, Y: integer);
    procedure DMsgDlgOkClick(Sender: TObject; X, Y: integer);
    procedure DCloseBagClick(Sender: TObject; X, Y: integer);
    procedure DBelt1Click(Sender: TObject; X, Y: integer);
    procedure DMyStateClick(Sender: TObject; X, Y: integer);
    procedure DStateWinClick(Sender: TObject; X, Y: integer);
    procedure DSWWeaponMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DBelt1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DMerchantDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DMerchantDlgCloseClick(Sender: TObject; X, Y: integer);
    procedure DMerchantDlgClick(Sender: TObject; X, Y: integer);
    procedure DMerchantDlgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DMerchantDlgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DMenuCloseClick(Sender: TObject; X, Y: integer);
    procedure DMenuDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DMenuDlgClick(Sender: TObject; X, Y: integer);
    procedure DSellDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DSellDlgCloseClick(Sender: TObject; X, Y: integer);
    procedure DSellDlgSpotClick(Sender: TObject; X, Y: integer);
    procedure DSellDlgSpotDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DSellDlgSpotMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DSellDlgOkClick(Sender: TObject; X, Y: integer);
    procedure DMenuBuyClick(Sender: TObject; X, Y: integer);
    procedure DMenuPrevClick(Sender: TObject; X, Y: integer);
    procedure DMenuNextClick(Sender: TObject; X, Y: integer);
    procedure DGoldClick(Sender: TObject; X, Y: integer);
    procedure DSWLightDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DBackgroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DStateWinMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DLoginNewClickSound(Sender: TObject; Clicksound: TClickSound);
    procedure DStMag1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DStMag1Click(Sender: TObject; X, Y: integer);
    procedure DKsIconDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DKsF1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DKsOkClick(Sender: TObject; X, Y: integer);
    procedure DKsF1Click(Sender: TObject; X, Y: integer);
    procedure DKeySelDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DBotGroupDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DGrpAllowGroupDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGrpDlgCloseClick(Sender: TObject; X, Y: integer);
    procedure DBotGroupClick(Sender: TObject; X, Y: integer);
    procedure DGrpAllowGroupClick(Sender: TObject; X, Y: integer);
    procedure DGrpCreateClick(Sender: TObject; X, Y: integer);
    procedure DGroupDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DGrpAddMemClick(Sender: TObject; X, Y: integer);
    procedure DGrpDelMemClick(Sender: TObject; X, Y: integer);
    procedure DBotLogoutClick(Sender: TObject; X, Y: integer);
    procedure DBotExitClick(Sender: TObject; X, Y: integer);
    procedure DStPageUpClick(Sender: TObject; X, Y: integer);
    procedure DBottomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DDealOkClick(Sender: TObject; X, Y: integer);
    procedure DDealCloseClick(Sender: TObject; X, Y: integer);
    procedure DBotTradeClick(Sender: TObject; X, Y: integer);
    procedure DDealRemoteDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DDealDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DDGridGridSelect(Sender: TObject; ACol, ARow: integer;
      Shift: TShiftState);
    procedure DDGridGridPaint(Sender: TObject; ACol, ARow: integer;
      Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
    procedure DDGridGridMouseMove(Sender: TObject; ACol, ARow: integer;
      Shift: TShiftState);
    procedure DDRGridGridPaint(Sender: TObject; ACol, ARow: integer;
      Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
    procedure DDRGridGridMouseMove(Sender: TObject; ACol, ARow: integer;
      Shift: TShiftState);
    procedure DDGoldClick(Sender: TObject; X, Y: integer);
    procedure DSServer1Click(Sender: TObject; X, Y: integer);
    procedure DSSrvCloseClick(Sender: TObject; X, Y: integer);
    procedure DBotMiniMapClick(Sender: TObject; X, Y: integer);
    procedure DMenuDlgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DUserState1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DUserState1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DWeaponUS1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DCloseUS1Click(Sender: TObject; X, Y: integer);
    procedure DNecklaceUS1DirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBotGuildClick(Sender: TObject; X, Y: integer);
    procedure DGuildDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DGDUpClick(Sender: TObject; X, Y: integer);
    procedure DGDDownClick(Sender: TObject; X, Y: integer);
    procedure DGDCloseClick(Sender: TObject; X, Y: integer);
    procedure DGDHomeClick(Sender: TObject; X, Y: integer);
    procedure DGDListClick(Sender: TObject; X, Y: integer);
    procedure DGDAddMemClick(Sender: TObject; X, Y: integer);
    procedure DGDDelMemClick(Sender: TObject; X, Y: integer);
    procedure DGDEditNoticeClick(Sender: TObject; X, Y: integer);
    procedure DGDEditGradeClick(Sender: TObject; X, Y: integer);
    procedure DGECloseClick(Sender: TObject; X, Y: integer);
    procedure DGEOkClick(Sender: TObject; X, Y: integer);
    procedure DGuildEditNoticeDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGDChatClick(Sender: TObject; X, Y: integer);
    procedure DGoldDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DNewAccountDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DAdjustAbilCloseClick(Sender: TObject; X, Y: integer);
    procedure DAdjustAbilityDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBotPlusAbilClick(Sender: TObject; X, Y: integer);
    procedure DPlusDCClick(Sender: TObject; X, Y: integer);
    procedure DMinusDCClick(Sender: TObject; X, Y: integer);
    procedure DAdjustAbilOkClick(Sender: TObject; X, Y: integer);
    procedure DBotPlusAbilDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DAdjustAbilityMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DUserState1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DEngServer1Click(Sender: TObject; X, Y: integer);
    procedure DGDAllyClick(Sender: TObject; X, Y: integer);
    procedure DGDBreakAllyClick(Sender: TObject; X, Y: integer);
    procedure DSelServerDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DSServer1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DBotExitMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DBotGroupMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DBotLogoutMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DBotMiniMapMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DBotTradeMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DBotGuildMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DMyStateMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DMyBagMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DMyMagicMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DOptionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DBottomMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DCountDlgOkDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DCountDlgCloseClick(Sender: TObject; X, Y: integer);
    procedure DMakeItemDlgOkClick(Sender: TObject; X, Y: integer);
    procedure DMakeitemGridGridPaint(Sender: TObject; ACol, ARow: integer;
      Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
    procedure DMakeitemGridGridMouseMove(Sender: TObject; ACol, ARow: integer;
      Shift: TShiftState);
    procedure DMakeitemGridGridSelect(Sender: TObject; ACol, ARow: integer;
      Shift: TShiftState);
    procedure DCountDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DCountDlgKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure DMakeItemDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DCountDlgOkClick(Sender: TObject; X, Y: integer);
    procedure DFriendDlgClick(Sender: TObject; X, Y: integer);
    procedure DFriendDlgDblClick(Sender: TObject);
    procedure DFriendDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DFriendDlgMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DFriendDlgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DFrdFriendClick(Sender: TObject; X, Y: integer);
    procedure DFrdFriendDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DFrdPgUpClick(Sender: TObject; X, Y: integer);
    procedure DFrdBlackListDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DFrdCloseClick(Sender: TObject; X, Y: integer);
    procedure DFrdPgUpDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DFrdPgUpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DFrdPgDnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DFrdAddClick(Sender: TObject; X, Y: integer);
    procedure DFrdAddMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DFrdDelClick(Sender: TObject; X, Y: integer);
    procedure DFrdDelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DFrdMemoClick(Sender: TObject; X, Y: integer);
    procedure DFrdMemoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DFrdMailClick(Sender: TObject; X, Y: integer);
    procedure DFrdMailMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DFrdWhisperClick(Sender: TObject; X, Y: integer);
    procedure DFrdWhisperMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DMailListCloseClick(Sender: TObject; X, Y: integer);
    procedure DMailListPgUpClick(Sender: TObject; X, Y: integer);
    procedure DMailListPgUpMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DMailListPgDnMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DMLReplyClick(Sender: TObject; X, Y: integer);
    procedure DMLReplyMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DMLReadClick(Sender: TObject; X, Y: integer);
    procedure DMLReadMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DMLDelClick(Sender: TObject; X, Y: integer);
    procedure DMLDelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DMLLockClick(Sender: TObject; X, Y: integer);
    procedure DMLLockMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DMLBlockClick(Sender: TObject; X, Y: integer);
    procedure DMLBlockMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DMailListDlgClick(Sender: TObject; X, Y: integer);
    procedure DMailListDlgDblClick(Sender: TObject);
    procedure DMailListDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DMailListDlgMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DMailListDlgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DMailDlgClick(Sender: TObject; X, Y: integer);
    procedure DMailDlgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DBlockListDlgClick(Sender: TObject; X, Y: integer);
    procedure DBlockListDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DBlockListDlgMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DBlockListCloseClick(Sender: TObject; X, Y: integer);
    procedure DBLPgUpClick(Sender: TObject; X, Y: integer);
    procedure DBLPgUpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DBLPgDnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DBLAddClick(Sender: TObject; X, Y: integer);
    procedure DBLAddMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DBLDelClick(Sender: TObject; X, Y: integer);
    procedure DBLDelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DMemoClick(Sender: TObject; X, Y: integer);
    procedure DMemoDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DMemoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DMemoCloseClick(Sender: TObject; X, Y: integer);
    procedure DMemoB1Click(Sender: TObject; X, Y: integer);
    procedure DMemoB1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DMemoB2DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DItemMarketDlgClick(Sender: TObject; X, Y: integer);
    procedure DItemMarketDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DItemMarketDlgKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure DItemMarketDlgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DItemMarketDlgMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DItemBuyClick(Sender: TObject; X, Y: integer);
    procedure DItemMarketCloseClick(Sender: TObject; X, Y: integer);
    procedure DItemFindClick(Sender: TObject; X, Y: integer);
    procedure DItemSellCancelClick(Sender: TObject; X, Y: integer);
    procedure DItemListPrevClick(Sender: TObject; X, Y: integer);
    procedure DItemListRefreshClick(Sender: TObject; X, Y: integer);
    procedure DItemListNextClick(Sender: TObject; X, Y: integer);
    procedure DJangwonListDlgClick(Sender: TObject; X, Y: integer);
    procedure DJangwonListDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DJangwonCloseClick(Sender: TObject; X, Y: integer);
    procedure DJangListPrevClick(Sender: TObject; X, Y: integer);
    procedure DJangMemoClick(Sender: TObject; X, Y: integer);
    procedure DJangListNextClick(Sender: TObject; X, Y: integer);
    procedure DGABoardListDlgDblClick(Sender: TObject);
    procedure DGABoardListDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGABoardListDlgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DGABoardOkClick(Sender: TObject; X, Y: integer);
    procedure DGABoardWriteClick(Sender: TObject; X, Y: integer);
    procedure DGABoardNoticeClick(Sender: TObject; X, Y: integer);
    procedure DGABoardListCloseClick(Sender: TObject; X, Y: integer);
    procedure DGABoardListPrevClick(Sender: TObject; X, Y: integer);
    procedure DGABoardListRefreshClick(Sender: TObject; X, Y: integer);
    procedure DGABoardListNextClick(Sender: TObject; X, Y: integer);
    procedure DGABoardDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DGABoardDlgKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure DGABoardDelClick(Sender: TObject; X, Y: integer);
    procedure DGABoardMemoClick(Sender: TObject; X, Y: integer);
    procedure DGABoardCloseClick(Sender: TObject; X, Y: integer);
    procedure DGABoardReplyClick(Sender: TObject; X, Y: integer);
    procedure DGABoardOk2Click(Sender: TObject; X, Y: integer);
    procedure DGADecorateDlgClick(Sender: TObject; X, Y: integer);
    procedure DGADecorateDlgDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DGADecorateDlgKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure DGADecorateCloseClick(Sender: TObject; X, Y: integer);
    procedure DGADecorateListPrevClick(Sender: TObject; X, Y: integer);
    procedure DGADecorateListNextClick(Sender: TObject; X, Y: integer);
    procedure DGADecorateBuyClick(Sender: TObject; X, Y: integer);
    procedure DGADecorateCancelClick(Sender: TObject; X, Y: integer);
    procedure DBotFriendClick(Sender: TObject; X, Y: integer);
    procedure DBotFriendDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DBotFriendMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DBotMemoClick(Sender: TObject; X, Y: integer);
    procedure DBotMemoDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DBotMemoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DDealJangwonDirectPaint(Sender: TObject;
      dsurface: TDirectDrawSurface);
    procedure DFrdBlackListClick(Sender: TObject; X, Y: integer);
    procedure DMasterDlgClick(Sender: TObject; X, Y: integer);
    procedure DMasterDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DMasterDlgMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DLover1Click(Sender: TObject; X, Y: integer);
    procedure DLover1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DLover2Click(Sender: TObject; X, Y: integer);
    procedure DLover2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DLover3Click(Sender: TObject; X, Y: integer);
    procedure DLover3MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure DMasterCloseClick(Sender: TObject; X, Y: integer);
    procedure DMarketMemoClick(Sender: TObject; X, Y: integer);
    procedure DMemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure DHeartImgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DHeartImgUSDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
    procedure DBotMasterClick(Sender: TObject; X, Y: integer);
    procedure DBotMasterMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    //Added by Lilcooldoode
    procedure DBotMiniMapDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
  private
    DlgTemp:  TList;
    magcur, magtop: integer;
    EdDlgEdit: TEdit;
    EdCountEdit: TEdit;
    ItemSearchEdit: TEdit;
    Memo:     TMemo;
    // 2003/04/15 친구, 쪽지
    edCharID: TEdit;
    memoMail: TMemo;

    ViewDlgEdit:  boolean;
    msglx, msgly: integer;

    MagKeyIcon, MagKeyCurKey: integer;
    MagKeyMagName: string;
    BackupMemoMail: string;
    StrMemoMail:   string;
    MagicPage:     integer;
    // 2003/04/15 친구, 쪽지
    MemoCharID:    string;
    MemoCharID2:   string;
    MemoDate:      string;
    FriendPage:    integer;
    BlackListPage: integer;
    MailPage:      integer;
    BlockPage:     integer;
    CurrentMail:   integer;
    CurrentFriend: integer;
    CurrentBlack:  integer;
    CurrentBlock:  integer;
    ViewFriends:   boolean;
    ViewWindowNo:  integer;
    ViewWindowData: integer;
    FriendDlgDblClicked: boolean;
    MailListDlgDblClicked: boolean;

    BlinkTime:  longword;
    BlinkCount: integer;  //0..9사이를 반복

    procedure RestoreHideControls;
    procedure PageChanged;
    procedure DealItemReturnBag(mitem: TClientItem);
    procedure DealZeroGold;
  public
    MenuTop:    integer;
    StatePage:  integer;
    MsgText:    string;
    DialogSize: integer;
    RunDice:    integer;
    BoDrawDice: boolean;
    DiceArr:    array[0..9] of TDiceInfo;

    MerchantName: string;
    MerchantFace: integer;
    MDlgStr:      string;
    MDlgPoints:   TList;
    RequireAddPoints: boolean;
    SelectMenuStr: string;
    LastestClickTime: longword;
    MsgDlgClickTime: longword;
    SpotDlgMode:  TSpotDlgMode;

    MenuList:      TList;    //list of PTClientGoods
    JangwonList:   TList;    //장원 리스트 PTClientJangwon
    GABoardList:   TList;    //장원 게시판 리스트
    GADecorationList: TList; //장원 꾸미기 리스트
    MenuIndex:     integer;
    CurDetailItem: string;
    MenuTopLine:   integer;

    BoDetailMenu:    boolean;
    BoStorageMenu:   boolean;
    BoNoDisplayMaxDura: boolean;
    BoMakeDrugMenu:  boolean;
    BoFirstShowOnServerSel: boolean;
    // 아이템 업그레이드
    BoUpItemEffect:  boolean;
    CurUpItemEffect: integer;
    UpItemOffset:    integer;
    UpItemMaxFrame:  integer;
    upeffecttime:    longword;

    // 겹치기
    Total: integer;
    NameMakeItem: string[20];           // Item Name Length

    // 제조
    BoMakeItemMenu: boolean;
    // 위탁판매
    MItemSellState: byte;
    BoInRect:      boolean;
    // 장원 쪽지
    BoMemoJangwon: boolean;

    NAHelps: TStringList;
    NewAccountTitle: string;

    DlgEditText: string;
    UserState1:  TUserStateInfo;

    Guild:      string;
    GuildFlag:  string;
    GuildCommanderMode: boolean;
    GuildStrs:  TStringList;
    GuildStrs2: TStringList;
    GuildNotice: TStringList;
    GuildMembers: TStringList;
    GuildTopLine: integer;
    GuildEditHint: string;
    GuildChats: TStringList;
    BoGuildChat: boolean;

    GABoard_GuildName: string;
    GABoard_UserName:  string[14];
    GABoard_TxtBody:   string;
    GABoard_Edit:      string;
    GABoard_Notice:    TStringList;
    GABoard_MaxPage:   integer;
    GABoard_CurPage:   integer;
    GABoard_BoNotice:  integer;
    GABoard_BoWrite:   byte;
    GABoard_BoReply:   byte;
    GABoard_IndexType1: integer;
    GABoard_IndexType2: integer;
    GABoard_IndexType3: integer;
    GABoard_IndexType4: integer;
    GABoard_X, GABoard_Y: integer;


    procedure Initialize;
    procedure OpenMyStatus;
    procedure OpenUserState(ustate: TUserStateInfo);
    procedure OpenItemBag;
    procedure ViewBottomBox(Visible: boolean);
    procedure CancelItemMoving;
    procedure DropMovingItem;
    procedure OpenAdjustAbility;

    procedure HideAllControls;
    procedure ShowSelectServerDlg;
    function DMessageDlg(msgstr: string; DlgButtons: TMsgDlgButtons): TModalResult;
    function OnlyMessageDlg(msgstr: string; DlgButtons: TMsgDlgButtons): TModalResult;
    function DCountMsgDlg(msgstr: string; DlgButtons: TMsgDlgButtons): TModalResult;
    function MakeItemDlgShow(msgstr: string): TModalResult;
    procedure ShowMDlg(face: integer; mname, msgstr: string);
    procedure ShowGuildDlg;
    procedure ShowGuildEditNotice;
    procedure ShowGuildEditGrade;

    procedure ResetMenuDlg;
    procedure ShowShopMenuDlg;
    procedure ShowItemMarketDlg;
    procedure ShowJangwonDlg;
    procedure ShowGADecorateDlg;
    procedure ShowGABoardListDlg;
    procedure ShowGABoardReadDlg;
    procedure SendGABoardOkProg;
    procedure SendGABoardNoticeOk;
    procedure ShowShopSellDlg;
    procedure CloseDSellDlg;
    procedure CloseMDlg;
    procedure CloseItemMarketDlg;
    procedure SafeCloseDlg;

    procedure ToggleShowGroupDlg;
    // 2003/04/15 친구, 쪽지
    procedure ToggleShowFriendsDlg;
    procedure ToggleShowMailListDlg;
    procedure ToggleShowBlockListDlg;
    procedure ToggleShowMemoDlg;
    procedure ToggleShowMasterDlg;
    procedure ShowEditMail;
    procedure AddFriend(FriendName: string; ShowMessage: boolean);

    procedure OpenDealDlg(DealCase: byte);
    procedure CloseDealDlg;
    procedure SetChatFocus;
    function DecoItemDesc(Dura: word; var str: string): string;

    procedure SoldOutGoods(itemserverindex: integer);
    procedure DelStorageItem(itemserverindex: integer; remain: word);
    procedure GetMouseItemInfo(var iname, line1, line2, line3, line4: string;
      var useable: boolean; bowear: boolean);
    procedure SetMagicKeyDlg(icon: integer; magname: string; var curkey: word);
    procedure AddGuildChat(str: string);
    function ConvertEscChar(str: string): string;
    procedure UpgradeItemEffect(wResult: word);
    procedure DGABoardReplyVisibleOk(Index, ReplyCount: integer;
      dsurface: TDirectDrawSurface);
  end;

var
  FrmDlg: TFrmDlg;

implementation

uses
  ClMain;

{$R *.DFM}

{
   ##  MovingItem.Index
      1~n : 가방창의 아이템 순서
      -1~-8 : 장착창에서의 아이템 순서
      -97 : 교환창의 돈
      -98 : 돈
      -99 : 팔기 창에서의 아이템 순서
      -20~29: 교환창에서의 아이템 순서
}

procedure TFrmDlg.FormCreate(Sender: TObject);
begin
  StatePage   := 0;
  DlgTemp     := TList.Create;
  DialogSize  := 1; //기본 크기
  RunDice     := 0;
  BoDrawDice  := False;
  magcur      := 0;
  magtop      := 0;
  MDlgPoints  := TList.Create;
  SelectMenuStr := '';
  MenuList    := TList.Create;
  JangwonList := TList.Create;
  GABoardList := TList.Create;
  GADecorationList := TList.Create;
  MenuIndex   := -1;
  MenuTopLine := 0;
  BoDetailMenu := False;
  BoStorageMenu := False;
  BoNoDisplayMaxDura := False;
  BoMakeDrugMenu := False;
  BoMakeItemMenu := False;
  BoMemoJangwon := False;
  NameMakeItem := '';
  MagicPage   := 0;
  // 2003/04/15 친구, 쪽지
  FriendPage  := 0;
  BlackListPage := 0;
  MailPage    := 0;
  BlockPage   := 0;
  CurrentMail := -1;
  CurrentFriend := -1;
  CurrentBlack := -1;
  CurrentBlock := -1;
  ViewFriends := True;
  ViewWindowNo := 0;
  ViewWindowData := 0;

  NAHelps    := TStringList.Create;
  BlinkTime  := GetTickCount;
  BlinkCount := 0;

  SellDlgItem.S.Name := '';
  Guild      := '';
  GuildFlag  := '';
  GuildCommanderMode := False;
  GuildStrs  := TStringList.Create;
  GuildStrs2 := TStringList.Create; //백업용
  GuildNotice := TStringList.Create;
  GABoard_Notice := TStringList.Create;
  GuildMembers := TStringList.Create;
  GuildChats := TStringList.Create;

  EdDlgEdit := TEdit.Create(FrmMain.Owner);
  with EdDlgEdit do begin
    Parent     := FrmMain;
    Color      := clBlack;
    Font.Color := clWhite;
    Font.Size  := 10;
    MaxLength  := 30;
    Height     := 16;
    Ctl3d      := False;
    BorderStyle := bsSingle;
    {OnKeyPress := EdDlgEditKeyPress;}  Visible := False;
  end;

  EdCountEdit := TEdit.Create(FrmMain.Owner);
  with EdCountEdit do begin
    Parent     := FrmMain;
    Color      := clBlack;
    Font.Color := clWhite;
    Font.Size  := 10;
    MaxLength  := 20;
    Height     := 16;
    Ctl3d      := False;
    BorderStyle := bsSingle;
    Visible    := False;
  end;

  ItemSearchEdit := TEdit.Create(FrmMain.Owner);
  with ItemSearchEdit do begin
    Parent     := FrmMain;
    Color      := clBlack;
    Font.Color := clWhite;
    Font.Size  := 10;
    MaxLength  := 20;
    Height     := 16;
    Ctl3d      := False;
    BorderStyle := bsSingle;
    Visible    := False;
  end;

  Memo := TMemo.Create(FrmMain.Owner);
  with Memo do begin
    Parent     := FrmMain;
    Color      := clBlack;
    Font.Color := clWhite;
    Font.Size  := 10;
    Ctl3d      := False;
    BorderStyle := bsSingle;
    {OnKeyPress := EdDlgEditKeyPress;}  Visible := False;
  end;

  // 2003/04/15 친구, 쪽지
  edCharID := TEdit.Create(FrmMain.Owner);
  with edCharID do begin
    Parent     := FrmMain;
    Color      := clBlack;
    Font.Color := clWhite;
    Font.Size  := 10;
    MaxLength  := 14;
    Height     := 16;
    Ctl3d      := False;
    BorderStyle := bsSingle;
    {OnKeyPress := EdDlgEditKeyPress;}  Visible := False;
  end;

  memoMail := TMemo.Create(FrmMain.Owner);
  with memoMail do begin
    Parent     := FrmMain;
    Color      := clBlack;
    Font.Color := clWhite;
    Font.Size  := 10;
    MaxLength  := 80;
    Ctl3d      := False;
    BorderStyle := bsSingle;
    {OnKeyPress := EdDlgEditKeyPress;}  Visible := False;
  end;
end;

procedure TFrmDlg.FormDestroy(Sender: TObject);
begin
  DlgTemp.Free;
  MDlgPoints.Free;  //간단히..
  MenuList.Free;
  JangwonList.Free;
  GABoardList.Free;
  GADecorationList.Free;
  NAHelps.Free;
  GuildStrs.Free;
  GuildStrs2.Free;
  GuildNotice.Free;
  GABoard_Notice.Free;
  GuildMembers.Free;
  GuildChats.Free;
end;

procedure TFrmDlg.HideAllControls;
var
  i: integer;
  c: TControl;
begin
  DlgTemp.Clear;
  with FrmMain do
    for i := 0 to ControlCount - 1 do begin
      c := Controls[i];
      if c is TEdit then
        if (c.Visible) and (c <> EdDlgEdit) then begin
          DlgTemp.Add(c);
          c.Visible := False;
        end;
    end;
end;

procedure TFrmDlg.RestoreHideControls;
var
  i: integer;
  c: TControl;
begin
  for i := 0 to DlgTemp.Count - 1 do begin
    TControl(DlgTemp[i]).Visible := True;
  end;
end;

procedure TFrmDlg.Initialize;  //게임을 리스토어할때마다 호출됨
var
  i, dsrvtop, dsrvheight: integer;
  lx, ly: integer;
  d:      TDirectDrawSurface;
begin
  FrmMain.DWinMan.ClearAll;

  DBackground.Left   := 0;
  DBackground.Top    := 0;
  DBackground.Width  := SCREENWIDTH;
  DBackground.Height := SCREENHEIGHT;
  DBackground.Background := True;
  FrmMain.DWinMan.AddDControl(DBackground, True);

  {-----------------------------------------------------------}

  //메세지 다이얼로그 창
  d := FrmMain.WProgUse.Images[361];
  if d <> nil then begin
    DMsgDlg.SetImgIndex(FrmMain.WProgUse, 361);
    DMsgDlg.Left := (SCREENWIDTH - d.Width) div 2;
    DMsgDlg.Top  := (SCREENHEIGHT - d.Height) div 2;
  end;
  DMsgDlgOk.SetImgIndex(FrmMain.WProgUse, 350);
  DMsgDlgYes.SetImgIndex(FrmMain.WProgUse, 352);
  DMsgDlgCancel.SetImgIndex(FrmMain.WProgUse, 354);
  DMsgDlgNo.SetImgIndex(FrmMain.WProgUse, 356);
  DMsgDlgOk.Top     := 106;
  DMsgDlgYes.Top    := 106;
  DMsgDlgCancel.Top := 106;
  DMsgDlgNo.Top     := 106;

  {-----------------------------------------------------------}

  // 카운트 다이얼로그 창
  d := FrmMain.WProgUse.Images[660];
  if d <> nil then begin
    DCountDlg.SetImgIndex(FrmMain.WProgUse, 660);
    DCountDlg.Left := (SCREENWIDTH - d.Width) div 2;
    DCountDlg.Top  := (SCREENHEIGHT - d.Height) div 2;
  end;
  DCountDlgMax.SetImgIndex(FrmMain.WProgUse, 662);
  DCountDlgOk.SetImgIndex(FrmMain.WProgUse, 663);
  DCountDlgCancel.SetImgIndex(FrmMain.WProgUse, 664);
  DCountDlgClose.SetImgIndex(FrmMain.WProgUse, 64);

  {-----------------------------------------------------------}
  // 제조 다이얼로그 창
  d := FrmMain.WProgUse.Images[661];
  if d <> nil then begin
    DMakeItemDlg.SetImgIndex(FrmMain.WProgUse, 661);
    DMakeItemDlg.Left := (SCREENWIDTH - d.Width) div 2;
    DMakeItemDlg.Top  := (SCREENHEIGHT - d.Height) div 2;
  end;

  DMakeitemGrid.Left   := 16;
  DMakeitemGrid.Top    := 13;
  DMakeitemGrid.Width  := 240;//286;
  DMakeitemGrid.Height := 40; //80;

  lx := 163;//234;
  ly := 109;//141;

  DMakeItemDlgCancel.SetImgIndex(FrmMain.WProgUse, 664);
  DMakeItemDlgCancel.Left := lx;
  DMakeItemDlgCancel.Top := ly;
  DMakeItemDlgCancel.Visible := True;
  lx := lx - 70;

  DMakeItemDlgOk.SetImgIndex(FrmMain.WProgUse, 663);
  DMakeItemDlgOk.Left    := lx;
  DMakeItemDlgOk.Top     := ly;
  DMakeItemDlgOk.Visible := True;


  DMakeItemDlgClose.SetImgIndex(FrmMain.WProgUse, 64);
  DMakeItemDlgClose.Left    := 246;//319;
  DMakeItemDlgClose.Top     := 0;
  DMakeItemDlgClose.Visible := True;

  DMakeItemDlg.Floating := True;

  {-----------------------------------------------------------}
  //로그인 창
  d := FrmMain.WProgUse.Images[60];
  if d <> nil then begin
    DLogIn.AlphaBlend := True;
    DLogIn.AlphaBlendValue := 150;
    DLogIn.SetImgIndex(FrmMain.WProgUse, 60);
    DLogIn.Left := 230;
    DLogIn.Top := 182;
  end;
  if ChinaVersion then begin
    DLoginOk.SetImgIndex(FrmMain.WProgUse, 62);
    DLoginOk.Left := 169;
    DLoginOk.Top  := 164;
    DLoginNew.SetImgIndex(FrmMain.WProgUse, 61);
    DLoginNew.Left := 25;
    DLoginNew.Top  := 207;
    DLoginChgPw.SetImgIndex(FrmMain.WProgUse, 53);
    DLoginChgPw.Left := 130;
    DLoginChgPw.Top  := 207;
    DLoginClose.SetImgIndex(FrmMain.WProgUse, 64);
    DLoginClose.Left := 252;
    DLoginClose.Top  := 28;
  end else if TaiwanVersion then begin
    DLoginOk.SetImgIndex(FrmMain.WProgUse, 62);
    DLoginOk.Left := 171;
    DLoginOk.Top  := 165;
    DLoginNew.SetImgIndex(FrmMain.WProgUse, 61);
    DLoginNew.Left := 23;
    DLoginNew.Top  := 207;
    DLoginChgPw.SetImgIndex(FrmMain.WProgUse, 53);
    DLoginChgPw.Left := 111;
    DLoginChgPw.Top  := 207;
    DLoginClose.SetImgIndex(FrmMain.WProgUse, 64);
    DLoginClose.Left := 252;
    DLoginClose.Top  := 28;
  end else begin
    DLoginNew.SetImgIndex(FrmMain.WProgUse, 61);
    DLoginNew.Left := 93;
    DLoginNew.Top  := 144;
    DLoginOk.SetImgIndex(FrmMain.WProgUse, 42);
    DLoginOk.Left := 245;
    DLoginOk.Top := 77;
    DLoginChgPw.SetImgIndex(FrmMain.WProgUse, 53);
    DLoginChgPw.Left := 141;
    DLoginChgPw.Top  := 145;
    DLoginClose.SetImgIndex(FrmMain.WProgUse, 48);
    DLoginClose.Left := 141;
    DLoginClose.Top := 171;
  end;

  {-----------------------------------------------------------}


  DEngServer1.Visible := False;

  DSServer1.Visible := False;
  DSServer2.Visible := False;
  DSServer3.Visible := False;
  DSServer4.Visible := False;
  DSServer5.Visible := False;
  DSServer6.Visible := False;
  DSServer7.Visible := False;
  DSServer8.Visible := False;

  DSServer9.Visible  := False;
  DSServer10.Visible := False;
  DSServer11.Visible := False;
  DSServer12.Visible := False;
  DSServer13.Visible := False;
  DSServer14.Visible := False;
  DSServer15.Visible := False;
  DSServer16.Visible := False;

  DSServer17.Visible := False;
  DSServer18.Visible := False;
  DSServer19.Visible := False;
  DSServer20.Visible := False;
  DSServer21.Visible := False;
  DSServer22.Visible := False;
  DSServer23.Visible := False;
  DSServer24.Visible := False;

  DSServer25.Visible := False;
  DSServer26.Visible := False;
  DSServer27.Visible := False;
  DSServer28.Visible := False;

  if ServerCount >= 1 then
    DSServer1.Visible := True;
  if ServerCount >= 2 then
    DSServer2.Visible := True;
  if ServerCount >= 3 then
    DSServer3.Visible := True;
  if ServerCount >= 4 then
    DSServer4.Visible := True;
  if ServerCount >= 5 then
    DSServer5.Visible := True;
  if ServerCount >= 6 then
    DSServer6.Visible := True;
  if ServerCount >= 7 then
    DSServer7.Visible := True;
  if ServerCount >= 8 then
    DSServer8.Visible := True;

  if ServerCount >= 9 then
    DSServer9.Visible := True;
  if ServerCount >= 10 then
    DSServer10.Visible := True;
  if ServerCount >= 11 then
    DSServer11.Visible := True;
  if ServerCount >= 12 then
    DSServer12.Visible := True;
  if ServerCount >= 13 then
    DSServer13.Visible := True;
  if ServerCount >= 14 then
    DSServer14.Visible := True;
  if ServerCount >= 15 then
    DSServer15.Visible := True;
  if ServerCount >= 16 then
    DSServer16.Visible := True;

  if ServerCount >= 17 then
    DSServer17.Visible := True;
  if ServerCount >= 18 then
    DSServer18.Visible := True;
  if ServerCount >= 19 then
    DSServer19.Visible := True;
  if ServerCount >= 20 then
    DSServer20.Visible := True;
  if ServerCount >= 21 then
    DSServer21.Visible := True;
  if ServerCount >= 22 then
    DSServer22.Visible := True;
  if ServerCount >= 23 then
    DSServer23.Visible := True;
  if ServerCount >= 24 then
    DSServer24.Visible := True;

  if ServerCount >= 25 then
    DSServer25.Visible := True;
  if ServerCount >= 26 then
    DSServer26.Visible := True;
  if ServerCount >= 27 then
    DSServer27.Visible := True;
  if ServerCount >= 28 then
    DSServer28.Visible := True;


  if ServerCount <= 8 then begin
    dsrvheight := 42;
    dsrvtop    := 235 - (dsrvheight * ServerCount) div 2;

    d := FrmMain.WProgUse.Images[256];  //2];
    if d <> nil then begin
      DSelServerDlg.SetImgIndex(FrmMain.WProgUse, 256);
      DSelServerDlg.Left := (SCREENWIDTH - d.Width) div 2;
      DSelServerDlg.Top  := (SCREENHEIGHT - d.Height) div 2;
    end;
    DSSrvClose.SetImgIndex(FrmMain.WProgUse, 41);
    DSSrvClose.Left := 100;
    DSSrvClose.Top := 481;

    DSServer1.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer1.Left := 40;
    DSServer1.Top  := 75;

    DSServer2.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer2.Left := 40;
    DSServer2.Top  := 120;

    DSServer3.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer3.Left := 40;
    DSServer3.Top  := 165;

    DSServer4.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer4.Left := 40;
    DSServer4.Top  := 210;

    DSServer5.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer5.Left := 40;
    DSServer5.Top  := 255;

    DSServer6.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer6.Left := 40;
    DSServer6.Top  := 300;

    DSServer7.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer7.Left := 40;
    DSServer7.Top  := 345;

    DSServer8.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer8.Left := 40;
    DSServer8.Top  := 390;
  end;

  if (ServerCount > 8) and (ServerCount <= 16) then begin
    dsrvheight := 42;
    dsrvtop    := 235 - (dsrvheight * 16{ServerCount} div 2) div 2;

    d := FrmMain.WProgUse2.Images[4];
    if d <> nil then begin
      DSelServerDlg.SetImgIndex(FrmMain.WProgUse2, 4);
      DSelServerDlg.Left := (SCREENWIDTH - d.Width) div 2;
      DSelServerDlg.Top  := (SCREENHEIGHT - d.Height) div 2;
    end;
    DSSrvClose.SetImgIndex(FrmMain.WProgUse, 64);
    DSSrvClose.Left := 348;
    DSSrvClose.Top  := 31;

    DSServer1.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer1.Left := 25;
    DSServer1.Top  := dsrvtop + 0 * dsrvheight; //102;

    DSServer2.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer2.Left := 25;
    DSServer2.Top  := dsrvtop + 1 * dsrvheight; //102;

    DSServer3.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer3.Left := 25;
    DSServer3.Top  := dsrvtop + 2 * dsrvheight; //102;

    DSServer4.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer4.Left := 25;
    DSServer4.Top  := dsrvtop + 3 * dsrvheight; //102;

    DSServer5.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer5.Left := 25;
    DSServer5.Top  := dsrvtop + 4 * dsrvheight; //102;

    DSServer6.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer6.Left := 25;
    DSServer6.Top  := dsrvtop + 5 * dsrvheight; //102;

    DSServer7.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer7.Left := 25;
    DSServer7.Top  := dsrvtop + 6 * dsrvheight; //102;

    DSServer8.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer8.Left := 25;
    DSServer8.Top  := dsrvtop + 7 * dsrvheight; //102;

    DSServer9.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer9.Left := 195;
    DSServer9.Top  := dsrvtop + 0 * dsrvheight; //102;

    DSServer10.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer10.Left := 195;
    DSServer10.Top  := dsrvtop + 1 * dsrvheight; //102;

    DSServer11.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer11.Left := 195;
    DSServer11.Top  := dsrvtop + 2 * dsrvheight; //102;

    DSServer12.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer12.Left := 195;
    DSServer12.Top  := dsrvtop + 3 * dsrvheight; //102;

    DSServer13.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer13.Left := 195;
    DSServer13.Top  := dsrvtop + 4 * dsrvheight; //102;

    DSServer14.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer14.Left := 195;
    DSServer14.Top  := dsrvtop + 5 * dsrvheight; //102;

    DSServer15.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer15.Left := 195;
    DSServer15.Top  := dsrvtop + 6 * dsrvheight; //102;

    DSServer16.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer16.Left := 195;
    DSServer16.Top  := dsrvtop + 7 * dsrvheight; //102;

  end;

  if (ServerCount > 16) then begin // and (ServerCount <= 24) then begin
    dsrvheight := 42;
    dsrvtop    := 235 - (dsrvheight * 8) div 2;

    d := FrmMain.WProgUse2.Images[5];
    if d <> nil then begin
      DSelServerDlg.SetImgIndex(FrmMain.WProgUse2, 5);
      DSelServerDlg.Left := (SCREENWIDTH - d.Width) div 2;
      DSelServerDlg.Top  := (SCREENHEIGHT - d.Height) div 2;
    end;
    DSSrvClose.SetImgIndex(FrmMain.WProgUse, 64);
    DSSrvClose.Left := 527;
    DSSrvClose.Top  := 35;

    DSServer1.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer1.Left := 25;
    DSServer1.Top  := dsrvtop + 0 * dsrvheight; //102;

    DSServer2.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer2.Left := 25;
    DSServer2.Top  := dsrvtop + 1 * dsrvheight; //102;

    DSServer3.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer3.Left := 25;
    DSServer3.Top  := dsrvtop + 2 * dsrvheight; //102;

    DSServer4.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer4.Left := 25;
    DSServer4.Top  := dsrvtop + 3 * dsrvheight; //102;

    DSServer5.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer5.Left := 25;
    DSServer5.Top  := dsrvtop + 4 * dsrvheight; //102;

    DSServer6.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer6.Left := 25;
    DSServer6.Top  := dsrvtop + 5 * dsrvheight; //102;

    DSServer7.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer7.Left := 25;
    DSServer7.Top  := dsrvtop + 6 * dsrvheight; //102;

    DSServer8.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer8.Left := 25;
    DSServer8.Top  := dsrvtop + 7 * dsrvheight; //102;

    DSServer9.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer9.Left := 195;
    DSServer9.Top  := dsrvtop + 0 * dsrvheight; //102;

    DSServer10.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer10.Left := 195;
    DSServer10.Top  := dsrvtop + 1 * dsrvheight; //102;

    DSServer11.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer11.Left := 195;
    DSServer11.Top  := dsrvtop + 2 * dsrvheight; //102;

    DSServer12.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer12.Left := 195;
    DSServer12.Top  := dsrvtop + 3 * dsrvheight; //102;

    DSServer13.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer13.Left := 195;
    DSServer13.Top  := dsrvtop + 4 * dsrvheight; //102;

    DSServer14.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer14.Left := 195;
    DSServer14.Top  := dsrvtop + 5 * dsrvheight; //102;

    DSServer15.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer15.Left := 195;
    DSServer15.Top  := dsrvtop + 6 * dsrvheight; //102;

    DSServer16.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer16.Left := 195;
    DSServer16.Top  := dsrvtop + 7 * dsrvheight; //102;

    DSServer17.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer17.Left := 365;
    DSServer17.Top  := dsrvtop + 0 * dsrvheight; //102;

    DSServer18.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer18.Left := 365;
    DSServer18.Top  := dsrvtop + 1 * dsrvheight; //102;

    DSServer19.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer19.Left := 365;
    DSServer19.Top  := dsrvtop + 2 * dsrvheight; //102;

    DSServer20.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer20.Left := 365;
    DSServer20.Top  := dsrvtop + 3 * dsrvheight; //102;

    DSServer21.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer21.Left := 365;
    DSServer21.Top  := dsrvtop + 4 * dsrvheight; //102;

    DSServer22.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer22.Left := 365;
    DSServer22.Top  := dsrvtop + 5 * dsrvheight; //102;

    DSServer23.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer23.Left := 365;
    DSServer23.Top  := dsrvtop + 6 * dsrvheight; //102;

    DSServer24.SetImgIndex(FrmMain.WProgUse2, 2); //82);
    DSServer24.Left := 365;
    DSServer24.Top  := dsrvtop + 7 * dsrvheight; //102;

  end;



  {-----------------------------------------------------------}

  //새 계정 만들기 창
  d := FrmMain.WProgUse.Images[63];
  if d <> nil then begin
    DNewAccount.SetImgIndex(FrmMain.WProgUse, 63);
    DNewAccount.Left := (SCREENWIDTH - d.Width) div 2;
    DNewAccount.Top  := (SCREENHEIGHT - d.Height) div 2;
  end;
  if ChinaVersion then begin
    DNewAccountOk.SetImgIndex(FrmMain.WProgUse, 47);
    DNewAccountOk.Left := 160;
    DNewAccountOk.Top := 417;
    DNewAccountCancel.SetImgIndex(FrmMain.WProgUse, 48);
    DNewAccountCancel.Left := 448;
    DNewAccountCancel.Top := 419;
  end else if TaiwanVersion then begin
    DNewAccountOk.SetImgIndex(FrmMain.WProgUse, 62);
    DNewAccountOk.Left := 160;
    DNewAccountOk.Top  := 417;
    DNewAccountCancel.SetImgIndex(FrmMain.WProgUse, 52);
    DNewAccountCancel.Left := 449;
    DNewAccountCancel.Top  := 419;
  end else begin
    DNewAccountOk.SetImgIndex(FrmMain.WProgUse, 47);
    DNewAccountOk.Left := 160;
    DNewAccountOk.Top := 417;
    DNewAccountCancel.SetImgIndex(FrmMain.WProgUse, 48);
    DNewAccountCancel.Left := 448;
    DNewAccountCancel.Top := 419;
  end;
  DNewAccountClose.SetImgIndex(FrmMain.WProgUse, 86);
  DNewAccountClose.Left := 587;
  DNewAccountClose.Top := 33;

  {-----------------------------------------------------------}

  //비밀번호 변경 창
  d := FrmMain.WProgUse.Images[50];
  if d <> nil then begin
    DChgPw.SetImgIndex(FrmMain.WProgUse, 50);
    DChgPw.Left := (SCREENWIDTH - d.Width) div 2;
    DChgPw.Top  := (SCREENHEIGHT - d.Height) div 2;
  end;
  if ChinaVersion then begin
    DChgpwOk.SetImgIndex(FrmMain.WProgUse, 47);
    DChgPwOk.Left := 182;
    DChgPwOk.Top := 252;
    DChgpwCancel.SetImgIndex(FrmMain.WProgUse, 52);
    DChgPwCancel.Left := 277;
    DChgPwCancel.Top  := 251;
  end else if TaiwanVersion then begin
    DChgpwOk.SetImgIndex(FrmMain.WProgUse, 62);
    DChgPwOk.Left := 182;
    DChgPwOk.Top  := 253;
    DChgpwCancel.SetImgIndex(FrmMain.WProgUse, 52);
    DChgPwCancel.Left := 277;
    DChgPwCancel.Top  := 252;
  end else begin
    DChgpwOk.SetImgIndex(FrmMain.WProgUse, 47);
    DChgPwOk.Left := 182;
    DChgPwOk.Top := 252;
    DChgpwCancel.SetImgIndex(FrmMain.WProgUse, 48);
    DChgPwCancel.Left := 277;
    DChgPwCancel.Top := 251;
  end;

  {-----------------------------------------------------------}

  //캐릭터 선택 창
  DSelectChr.Left   := 0;
  DSelectChr.Top    := 0;
  DSelectChr.Width  := SCREENWIDTH;
  DSelectChr.Height := SCREENHEIGHT;

  DscStart.SetImgIndex(FrmMain.WProgUse, 68);
  DscNewChr.SetImgIndex(FrmMain.WProgUse, 69);
  DscEraseChr.SetImgIndex(FrmMain.WProgUse, 70);
  DscCredits.SetImgIndex(FrmMain.WProgUse, 71);
  DscExit.SetImgIndex(FrmMain.WProgUse, 72);

  if ChinaVersion then begin
    DscSelect1.Left  := 133;
    DscSelect1.Top   := 453;
    DscSelect2.Left  := 685;
    DscSelect2.Top   := 454;
    DscStart.Left    := 385;
    DscStart.Top     := 456;
    DscNewChr.Left   := 348;
    DscNewChr.Top    := 486;
    DscEraseChr.Left := 347;
    DscEraseChr.Top  := 506;
    DscCredits.Left  := 362;
    DscCredits.Top   := 527;
    DscExit.Left     := 379;
    DscExit.Top      := 547;
  end else if TaiwanVersion then begin
    DscSelect1.Left  := 134;
    DscSelect1.Top   := 454;
    DscSelect2.Left  := 685;
    DscSelect2.Top   := 454;
    DscStart.Left    := 376;
    DscStart.Top     := 458;
    DscNewChr.Left   := 340;
    DscNewChr.Top    := 486;
    DscEraseChr.Left := 340;
    DscEraseChr.Top  := 507;
    DscCredits.Left  := 340;
    DscCredits.Top   := 528;
    DscExit.Left     := 377;
    DscExit.Top      := 552;
  end else begin
    DscSelect1.Left := 442;
    DscSelect1.Top := 62;

    DscSelect2.Left := 442;
    DscSelect2.Top := 126;

    DscSelect3.Left := 442;
    DscSelect3.Top := 190;

    DscSelect4.Left := 442;
    DscSelect4.Top := 254;

    DscStart.Left := 439;
    DscStart.Top := 426;

    DscNewChr.Left := 439;
    DscNewChr.Top := 455;

    DscEraseChr.Left := 439;
    DscEraseChr.Top := 484;

    { SEAN - 29/12/08 - No credits button on latest interface
    DscCredits.Left := (SCREENWIDTH - 800) div 2 + 413;
    DscCredits.Top := (SCREENHEIGHT - 600) div 2 + 523;}

    DscExit.Left := 439;
    DscExit.Top := 542
  end;

  {-----------------------------------------------------------}

  //새 캐릭터 만들기 창
  d := FrmMain.WProgUse.Images[73];
  if d <> nil then begin
    DCreateChr.SetImgIndex(FrmMain.WProgUse, 73);
    DCreateChr.Left := (SCREENWIDTH - d.Width) div 2;
    DCreateChr.Top  := (SCREENHEIGHT - d.Height) div 2;
  end;
  DccWarrior.SetImgIndex(FrmMain.WProgUse, 55);
  DccWizzard.SetImgIndex(FrmMain.WProgUse, 56);
  DccMonk.SetImgIndex(FrmMain.WProgUse, 57);
  DccAssasin.SetImgIndex(FrmMain.WProgUse, 75);
  DccMale.SetImgIndex(FrmMain.WProgUse, 58);
  DccFemale.SetImgIndex(FrmMain.WProgUse, 59);
  DccLeftHair.SetImgIndex(FrmMain.WProgUse, 79);
  DccRightHair.SetImgIndex(FrmMain.WProgUse, 80);
  DccOk.SetImgIndex(FrmMain.WProgUse, 47);
  DccClose.SetImgIndex(FrmMain.WProgUse, 48);
  DccWarrior.Left  := 360;
  DccWarrior.Top   := 206;
  DccWizzard.Left  := 407;
  DccWizzard.Top   := 206;
  DccMonk.Left     := 454;
  DccMonk.Top      := 206;
  DccAssasin.Left := 501;
  DccAssasin.Top := 206;
  DccMale.Left     := 407;
  DccMale.Top      := 297;
  DccFemale.Left   := 454;
  DccFemale.Top    := 297;
  DccLeftHair.Left := 76;
  DccLeftHair.Top  := 308;
  DccRightHair.Left := 170;
  DccRightHair.Top := 308;
  DccClose.Left    := 471;
  DccClose.Top     := 399;

  if ChinaVersion then begin
    DccOk.Left := 102;
    DccOk.Top  := 359;
  end else if TaiwanVersion then begin
    DccOk.Left := 103;
    DccOk.Top  := 360;
  end else begin
    DccOk.Left := 359;
    DccOk.Top  := 399;
  end;


  {-----------------------------------------------------------}

  //상태-능력치 창
  d := FrmMain.WProgUse.Images[370];  //상태
  if d <> nil then begin
    DStateWin.SetImgIndex(FrmMain.WProgUse, 370);
    DStateWin.Left := SCREENWIDTH - d.Width;
    DStateWin.Top  := 0;
  end;
  DSWNecklace.Left := 38 + 130;
  DSWNecklace.Top := 59 + 35;
  DSWNecklace.Width := 34;
  DSWNecklace.Height := 31;
  DSWHelmet.Left  := 38 + 77;
  DSWHelmet.Top   := 59 + 41;
  DSWHelmet.Width := 18;
  DSWHelmet.Height := 18;
  DSWLight.Left   := 38 + 130;
  DSWLight.Top    := 59 + 73;
  DSWLight.Width  := 34;
  DSWLight.Height := 31;
  DSWArmRingR.Left := 38 + 4;
  DSWArmRingR.Top := 59 + 124;
  DSWArmRingR.Width := 34;
  DSWArmRingR.Height := 31;
  DSWArmRingL.Left := 38 + 130;
  DSWArmRingL.Top := 59 + 124;
  DSWArmRingL.Width := 34;
  DSWArmRingL.Height := 31;
  DSWRingR.Left   := 38 + 4;
  DSWRingR.Top    := 59 + 163;
  DSWRingR.Width  := 34;
  DSWRingR.Height := 31;
  DSWRingL.Left   := 38 + 130;
  DSWRingL.Top    := 59 + 163;
  DSWRingL.Width  := 34;
  DSWRingL.Height := 31;
  DSWWeapon.Left  := 38 + 9;
  DSWWeapon.Top   := 59 + 28;
  DSWWeapon.Width := 47;
  DSWWeapon.Height := 87;
  DSWDress.Left   := 38 + 58;
  DSWDress.Top    := 59 + 70;
  DSWDress.Width  := 53;
  DSWDress.Height := 112;
  // 2003/03/15 아이템 인벤토리 확장
  DSWBujuk.Left   := 38 + 4;
  DSWBujuk.Top    := 59 + 202;
  DSWBujuk.Width  := 34;
  DSWBujuk.Height := 31;
  DSWBelt.Left    := 38 + 46;
  DSWBelt.Top     := 59 + 202;
  DSWBelt.Width   := 34;
  DSWBelt.Height  := 31;
  DSWBoots.Left   := 38 + 88;
  DSWBoots.Top    := 59 + 202;
  DSWBoots.Width  := 34;
  DSWBoots.Height := 31;
  DSWCharm.Left   := 38 + 130;
  DSWCharm.Top    := 59 + 202;
  DSWCharm.Width  := 34;
  DSWCharm.Height := 31;


  DStMag1.Left   := 38 + 6;
  DStMag1.Top    := 59 + 7+20;
  DStMag1.Width  := 31;
  DStMag1.Height := 33;
  DStMag2.Left   := 38 + 6;
  DStMag2.Top    := 59 + 44+20;
  DStMag2.Width  := 31;
  DStMag2.Height := 33;
  DStMag3.Left   := 38 + 6;
  DStMag3.Top    := 59 + 82+20;
  DStMag3.Width  := 31;
  DStMag3.Height := 33;
  DStMag4.Left   := 38 + 6;
  DStMag4.Top    := 59 + 119+20;
  DStMag4.Width  := 31;
  DStMag4.Height := 33;
  DStMag5.Left   := 38 + 6;
  DStMag5.Top    := 59 + 156+20;
  DStMag5.Width  := 31;
  DStMag5.Height := 33;

  DStPageUp.SetImgIndex(FrmMain.WProgUse, 398);
  DStPageDown.SetImgIndex(FrmMain.WProgUse, 396);
  DStPageUp.Left   := 213+4;
  DStPageUp.Top    := 113+32;
  DStPageDown.Left := 213+4;
  DStPageDown.Top  := 143+33;

  DCloseState.SetImgIndex(FrmMain.WProgUse, 86);
  DCloseState.Left := 208;
  DCloseState.Top := 5;
  DPrevState.SetImgIndex(FrmMain.WProgUse, 373);
  DNextState.SetImgIndex(FrmMain.WProgUse, 372);
  DPrevState.Left := 5;
  DPrevState.Top := 138;
  DNextState.Left := 5;
  DNextState.Top := 197;
  DHeartImg.SetImgIndex(FrmMain.WProgUse, 604);

  {-----------------------------------------------------------}

  //상태창  (다른사람용)
  d := FrmMain.WProgUse.Images[370];  //상태
  if d <> nil then begin
    DUserState1.SetImgIndex(FrmMain.WProgUse, 430);
    DUserState1.Left := SCREENWIDTH - d.Width - d.Width;
    DUserState1.Top  := 0;
  end;
  DNecklaceUS1.Left  := 38 + 130;
  DNecklaceUS1.Top   := 59 + 35;
  DNecklaceUS1.Width := 34;
  DNecklaceUS1.Height := 31;
  DHelmetUS1.Left    := 38 + 77;
  DHelmetUS1.Top     := 59 + 41;
  DHelmetUS1.Width   := 18;
  DHelmetUS1.Height  := 18;
  DLightUS1.Left     := 38 + 130;
  DLightUS1.Top      := 59 + 73;
  DLightUS1.Width    := 34;
  DLightUS1.Height   := 31;
  DArmRingRUS1.Left  := 38 + 4;
  DArmRingRUS1.Top   := 59 + 124;
  DArmRingRUS1.Width := 34;
  DArmRingRUS1.Height := 31;
  DArmRingLUS1.Left  := 38 + 130;
  DArmRingLUS1.Top   := 59 + 124;
  DArmRingLUS1.Width := 34;
  DArmRingLUS1.Height := 31;
  DRingRUS1.Left     := 38 + 4;
  DRingRUS1.Top      := 59 + 163;
  DRingRUS1.Width    := 34;
  DRingRUS1.Height   := 31;
  DRingLUS1.Left     := 38 + 130;
  DRingLUS1.Top      := 59 + 163;
  DRingLUS1.Width    := 34;
  DRingLUS1.Height   := 31;
  DWeaponUS1.Left    := 38 + 9;
  DWeaponUS1.Top     := 59 + 28;
  DWeaponUS1.Width   := 47;
  DWeaponUS1.Height  := 87;
  DDressUS1.Left     := 38 + 58;
  DDressUS1.Top      := 59 + 70;
  DDressUS1.Width    := 53;
  DDressUS1.Height   := 112;

  // 2003/03/15 아이템 인벤토리 확장
  DBujukUS1.Left   := 42;
  DBujukUS1.Top    := 261;
  DBujukUS1.Width  := 34;
  DBujukUS1.Height := 31;
  DBeltUS1.Left    := 84;
  DBeltUS1.Top     := 261;
  DBeltUS1.Width   := 34;
  DBeltUS1.Height  := 31;
  DBootsUS1.Left   := 126;
  DBootsUS1.Top    := 261;
  DBootsUS1.Width  := 34;
  DBootsUS1.Height := 31;
  DCharmUS1.Left   := 168;
  DCharmUS1.Top    := 261;
  DCharmUS1.Width  := 34;
  DCharmUS1.Height := 31;

  DCloseUS1.SetImgIndex(FrmMain.WProgUse, 371);
  DCloseUS1.Left := 8;
  DCloseUS1.Top  := 39;
  DHeartImgUS.SetImgIndex(FrmMain.WProgUse, 604);

  {-------------------------------------------------------------}

  //아이템 창
  DItemBag.SetImgIndex(FrmMain.WProgUse, 3);
  DItemBag.Left    := 0;
  DItemBag.Top     := 0;
  DItemGrid.Left := 28;
  DItemGrid.Top  := 25;
  DItemGrid.Width := 288;
  DItemGrid.Height := 162;

  BoUpItemEffect := False;
  {-----------------------------------------------------------}

  //바닥 창
  d := FrmMain.WProgUse.Images[BOTTOMBOARD];
  if d <> nil then begin
    DBottom.Left   := 0;
    DBottom.Top    := SCREENHEIGHT - d.Height;
    DBottom.Width  := d.Width;
    DBottom.Height := d.Height;
  end;

  {-----------------------------------------------------------}

  //기본창의 4개 버튼들
  DMyState.SetImgIndex(FrmMain.WProgUse, 8);
  DMyState.Left := SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (409 - 244));
  DMyState.Top := 65;
  DMyBag.SetImgIndex(FrmMain.WProgUse, 9);
  DMyBag.Left := SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (407 - 282));
  DMyBag.Top := 49;
  DMyMagic.SetImgIndex(FrmMain.WProgUse, 10);
  DMyMagic.Left := SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (405 - 322));
  DMyMagic.Top := 38;
  DOption.SetImgIndex(FrmMain.WProgUse, 11);
  DOption.Left := SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (405 - 364));
  DOption.Top := 31;

  {-----------------------------------------------------------}

  //작은 버튼  그룹, 교환, 맵
  DBotMiniMap.SetImgIndex(FrmMain.WProgUse, 131);
  DBotMiniMap.Left := 181;
  DBotMiniMap.Top := 85;
  DBotTrade.SetImgIndex(FrmMain.WProgUse, 133);
  DBotTrade.Left := 181;
  DBotTrade.Top := 110;
  DBotGuild.SetImgIndex(FrmMain.WProgUse, 135);
  DBotGuild.Left := 181;
  DBotGuild.Top := 135;
  DBotGroup.SetImgIndex(FrmMain.WProgUse, 129);
  DBotGroup.Left := 181;
  DBotGroup.Top := 160;
  DBotPlusAbil.SetImgIndex(FrmMain.WProgUse, 140);
  DBotPlusAbil.Left := 181;
  DBotPlusAbil.Top := 1;
  // 2003/04/15 친구, 쪽지
  DBotFriend.SetImgIndex(FrmMain.WProgUse, 531);
  DBotFriend.Left := 181;
  DBotFriend.Top := 184;
  DBotMaster.SetImgIndex(FrmMain.WProgUse, 529);
  DBotMaster.Left := 603;
  DBotMaster.Top  := 85;
  DBotMemo.SetImgIndex(FrmMain.WProgUse, 533);
  DBotMemo.Left := 720;
  DBotMemo.Top  := 83;

  DBotExit.SetImgIndex(FrmMain.WProgUse, 139);
  DBotExit.Left := 589;
  DBotExit.Top  := 56;
  DBotLogout.SetImgIndex(FrmMain.WProgUse, 137);
  DBotLogout.Left := 565;
  DBotLogout.Top  := 56;


  {-----------------------------------------------------------}

  //Belt
  DBelt1.Left   := 285;
  DBelt1.Width  := 32;
  DBelt1.Top    := 59;
  DBelt1.Height := 29;
  DBelt2.Left   := 328;
  DBelt2.Width  := 32;
  DBelt2.Top    := 59;
  DBelt2.Height := 29;
  DBelt3.Left   := 371;
  DBelt3.Width  := 32;
  DBelt3.Top    := 59;
  DBelt3.Height := 29;
  DBelt4.Left   := 415;
  DBelt4.Width  := 32;
  DBelt4.Top    := 59;
  DBelt4.Height := 29;
  DBelt5.Left   := 459;
  DBelt5.Width  := 32;
  DBelt5.Top    := 59;
  DBelt5.Height := 29;
  DBelt6.Left   := 503;
  DBelt6.Width  := 32;
  DBelt6.Top    := 59;
  DBelt6.Height := 29;


  {-----------------------------------------------------------}

  //아이템 가방의 버튼들
  DGold.SetImgIndex(FrmMain.WProgUse, 29); //돈크기 3개 같음
  DGold.Left := 13;
  DGold.Top  := 208;
  DRepairItem.SetImgIndex(FrmMain.WProgUse, 26);
  DRepairItem.Left := 254;
  DRepairItem.Top := 183;
  DRepairItem.Width := 48;
  DRepairItem.Height := 22;
  DClosebag.SetImgIndex(FrmMain.WProgUse, 371);
  DCloseBag.Left := 322;
  DCloseBag.Top := 5;
  DCloseBag.Width := 14;
  DCloseBag.Height := 20;

  {-----------------------------------------------------------}

  //상인 대화창
  d := FrmMain.WProgUse.Images[384];
  if d <> nil then begin
    DMerchantDlg.Left := 0;
    DMerchantDlg.Top  := 0;
    DMerchantDlg.SetImgIndex(FrmMain.WProgUse, 384);
  end;
  DMerchantDlgClose.Left := 409;
  DMerchantDlgClose.Top := 5;
  DMerchantDlgClose.SetImgIndex(FrmMain.WProgUse, 64);

  {-----------------------------------------------------------}

  //메뉴창
  d := FrmMain.WProgUse.Images[385];
  if d <> nil then begin
    DMenuDlg.Left := 138;
    DMenuDlg.Top  := 163;
    DMenuDlg.SetImgIndex(FrmMain.WProgUse, 385);
  end;
  DMenuPrev.Left := 43+32;
  DMenuPrev.Top := 175+16;
  DMenuPrev.SetImgIndex(FrmMain.WProgUse, 388);
  DMenuNext.Left := 90+44;
  DMenuNext.Top := 175+16;
  DMenuNext.SetImgIndex(FrmMain.WProgUse, 387);
  DMenuBuy.Left := 210;
  DMenuBuy.Top := 187;
  DMenuBuy.SetImgIndex(FrmMain.WProgUse, 386);
  DMenuClose.Left := 291+14;
  DMenuClose.Top := 0+5;
  DMenuClose.SetImgIndex(FrmMain.WProgUse, 64);

  {-----------------------------------------------------------}

  //위탁판매  //2004/01/15 ItemMarket..
  d := FrmMain.WProgUse.Images[670];
  if d <> nil then begin
    DItemMarketDlg.Left := 0;
    DItemMarketDlg.Top  := 90;
    DItemMarketDlg.SetImgIndex(FrmMain.WProgUse, 670);
  end;

  DItemListPrev.Left := 216;
  DItemListPrev.Top  := 355;
  DItemListPrev.SetImgIndex(FrmMain.WProgUse, 388);
  DItemListNext.Left := 303;
  DItemListNext.Top  := 355;
  DItemListNext.SetImgIndex(FrmMain.WProgUse, 387);
  DItemListRefresh.Left := 259;
  DItemListRefresh.Top  := 356;
  DItemListRefresh.SetImgIndex(FrmMain.WProgUse, 671);

  DItemBuy.Left := 330;
  DItemBuy.Top  := 326;//418;
  DItemBuy.SetImgIndex(FrmMain.WProgUse, 672);
  DItemSellCancel.Left := 330;
  DItemSellCancel.Top  := 326;//418;
  DItemSellCancel.SetImgIndex(FrmMain.WProgUse, 544);
  DItemCancel.Left := 396;
  DItemCancel.Top  := 325;//418;
  DItemCancel.SetImgIndex(FrmMain.WProgUse, 674);
  DItemFind.Left := 145;
  DItemFind.Top  := 327;//417;
  DItemFind.SetImgIndex(FrmMain.WProgUse, 676);
  DMarketMemo.Left := 305;//258;
  DMarketMemo.Top  := 326;
  DMarketMemo.SetImgIndex(FrmMain.WProgUse, 681);

  DMGold.Visible := False;
  //   DMGold.SetImgIndex (FrmMain.WProgUse, 29); //돈크기 3개 같음
  //   DMGold.Left := 465;
  //   DMGold.Top  := 226;

  DItemMarketClose.Left := 447;
  DItemMarketClose.Top  := 7;
  DItemMarketClose.SetImgIndex(FrmMain.WProgUse, 64);
  {-----------------------------------------------------------}

  //장원 꾸미기 //2004/06/18
  d := FrmMain.WProgUse.Images[702];
  if d <> nil then begin
    DGADecorateDlg.Left := 0;
    DGADecorateDlg.Top  := 55;//90;
    DGADecorateDlg.SetImgIndex(FrmMain.WProgUse, 702);
  end;

  DGADecorateListPrev.Left := 150;
  DGADecorateListPrev.Top  := 361;
  DGADecorateListPrev.SetImgIndex(FrmMain.WProgUse, 388);
  DGADecorateListNext.Left := 237;
  DGADecorateListNext.Top  := 361;
  DGADecorateListNext.SetImgIndex(FrmMain.WProgUse, 387);

  DGADecorateBuy.Left := 211;
  DGADecorateBuy.Top  := 304;
  DGADecorateBuy.SetImgIndex(FrmMain.WProgUse, 672);
  DGADecorateCancel.Left := 211;
  DGADecorateCancel.Top  := 328;
  DGADecorateCancel.SetImgIndex(FrmMain.WProgUse, 674);
  DGADecorateClose.Left := 581;//410;
  DGADecorateClose.Top  := 6;
  DGADecorateClose.SetImgIndex(FrmMain.WProgUse, 64);

  {-----------------------------------------------------------}

  //장원창
  d := FrmMain.WProgUse.Images[680];
  if d <> nil then begin
    DJangwonListDlg.Left := 0;
    DJangwonListDlg.Top  := 175;
    DJangwonListDlg.SetImgIndex(FrmMain.WProgUse, 680);
  end;

  DJangListPrev.Left := 208;//152;
  DJangListPrev.Top  := 199;
  DJangListPrev.SetImgIndex(FrmMain.WProgUse, 388);
  DJangListNext.Left := 298;//242;
  DJangListNext.Top  := 199;
  DJangListNext.SetImgIndex(FrmMain.WProgUse, 387);
  DJangMemo.Left := 254;//197;
  DJangMemo.Top  := 193;
  DJangMemo.SetImgIndex(FrmMain.WProgUse, 681);

  DMGold.Visible := False;
  //   DMGold.SetImgIndex (FrmMain.WProgUse, 29); //돈크기 3개 같음
  //   DMGold.Left := 465;
  //   DMGold.Top  := 226;

  DJangwonClose.Left := 522;//410;
  DJangwonClose.Top  := 0;
  DJangwonClose.SetImgIndex(FrmMain.WProgUse, 64);

  {-----------------------------------------------------------}
  //장원 게시판 리스트
  d := FrmMain.WProgUse.Images[688];
  if d <> nil then begin
    DGABoardListDlg.Left := 0;
    DGABoardListDlg.Top  := 175;
    DGABoardListDlg.SetImgIndex(FrmMain.WProgUse, 688);
  end;

  DGABoardOk.Left := 344;
  DGABoardOk.Top  := 262;
  DGABoardOk.SetImgIndex(FrmMain.WProgUse, 691);
  DGABoardWrite.Left := 275;
  DGABoardWrite.Top  := 262;
  DGABoardWrite.SetImgIndex(FrmMain.WProgUse, 693);
  DGABoardNotice.Left := 206;
  DGABoardNotice.Top  := 262;
  DGABoardNotice.SetImgIndex(FrmMain.WProgUse, 695);

  DGABoardListPrev.Left := 61;
  DGABoardListPrev.Top  := 280;
  DGABoardListPrev.SetImgIndex(FrmMain.WProgUse, 388);
  DGABoardListNext.Left := 148;
  DGABoardListNext.Top  := 280;
  DGABoardListNext.SetImgIndex(FrmMain.WProgUse, 387);
  DGABoardListRefresh.Left := 104;
  DGABoardListRefresh.Top  := 281;
  DGABoardListRefresh.SetImgIndex(FrmMain.WProgUse, 671);

  DGABoardListClose.Left := 401;
  DGABoardListClose.Top  := 6;
  DGABoardListClose.SetImgIndex(FrmMain.WProgUse, 64);

  {-----------------------------------------------------------}
  //장원 게시판 읽기창
  d := FrmMain.WProgUse.Images[689];
  if d <> nil then begin
    DGABoardDlg.Left := 0;
    DGABoardDlg.Top  := 175;
    DGABoardDlg.SetImgIndex(FrmMain.WProgUse, 689);
  end;

  DGABoardDel.Left := 19;
  DGABoardDel.Top  := 186;
  DGABoardDel.SetImgIndex(FrmMain.WProgUse, 697);
  DGABoardMemo.Left := 85;
  DGABoardMemo.Top  := 186;
  DGABoardMemo.SetImgIndex(FrmMain.WProgUse, 681);

  DGABoardReply.Left := 109;
  DGABoardReply.Top  := 186;
  DGABoardReply.SetImgIndex(FrmMain.WProgUse, 699);
  DGABoardOk2.Left := 175;
  DGABoardOk2.Top  := 186;
  DGABoardOk2.SetImgIndex(FrmMain.WProgUse, 691);
  DGABoardCancel.Left := 241;
  DGABoardCancel.Top  := 186;
  DGABoardCancel.SetImgIndex(FrmMain.WProgUse, 674);

  DGABoardClose.Left := 291;
  DGABoardClose.Top  := 8;
  DGABoardClose.SetImgIndex(FrmMain.WProgUse, 64);

  {-----------------------------------------------------------}

  //팔기창
  d := FrmMain.WProgUse.Images[392];
  if d <> nil then begin
    DSellDlg.Left := 328;
    DSellDlg.Top  := 163;
    DSellDlg.SetImgIndex(FrmMain.WProgUse, 392);
  end;
  DSellDlgOk.Left := 114;
  DSellDlgOk.Top := 72;
  DSellDlgOk.SetImgIndex(FrmMain.WProgUse, 393);
  DSellDlgClose.Left := 147;
  DSellDlgClose.Top := 16;
  DSellDlgClose.SetImgIndex(FrmMain.WProgUse, 64);
  DSellDlgSpot.Left := 27;
  DSellDlgSpot.Top  := 67;
  DSellDlgSpot.Width  := 61;
  DSellDlgSpot.Height := 52;

  {-----------------------------------------------------------}

  //마법 키 설정 창
  d := FrmMain.WProgUse.Images[710];
  if d <> nil then begin
    DKeySelDlg.Left := (SCREENWIDTH - d.Width) div 2;
    DKeySelDlg.Top  := (SCREENHEIGHT - d.Height) div 2;
    DKeySelDlg.SetImgIndex(FrmMain.WProgUse, 710);
  end;
  DKsIcon.Left := 51;  //DMagIcon...
  DKsIcon.Top  := 31;
  DKsF1.SetImgIndex(FrmMain.WProgUse, 713);
  DKsF1.Left := 25;//34; //-9
  DKsF1.Top  := 78;//83; //-4
  DKsF2.SetImgIndex(FrmMain.WProgUse, 715);
  DKsF2.Left := 57;//66;
  DKsF2.Top  := 78;//83;
  DKsF3.SetImgIndex(FrmMain.WProgUse, 717);
  DKsF3.Left := 89;//98;
  DKsF3.Top  := 78;//83;
  DKsF4.SetImgIndex(FrmMain.WProgUse, 719);
  DKsF4.Left := 121;////130;
  DKsF4.Top  := 78;
  DKsF5.SetImgIndex(FrmMain.WProgUse, 240);
  DKsF5.Left := 160;//171; //-11
  DKsF5.Top  := 78;
  DKsF6.SetImgIndex(FrmMain.WProgUse, 242);
  DKsF6.Left := 192;//203;
  DKsF6.Top  := 78;
  DKsF7.SetImgIndex(FrmMain.WProgUse, 244);
  DKsF7.Left := 224;//235;
  DKsF7.Top  := 78;
  DKsF8.SetImgIndex(FrmMain.WProgUse, 246);
  DKsF8.Left := 256;//267;
  DKsF8.Top  := 78;
  // 2003/08/20 =>마법단축키 추가  // AddMagicKey
  DKsConF1.SetImgIndex(FrmMain.WProgUse, 626);
  DKsConF1.Left := 25;
  DKsConF1.Top  := 120;
  DKsConF2.SetImgIndex(FrmMain.WProgUse, 628);
  DKsConF2.Left := 57;
  DKsConF2.Top  := 120;
  DKsConF3.SetImgIndex(FrmMain.WProgUse, 630);
  DKsConF3.Left := 89;
  DKsConF3.Top  := 120;
  DKsConF4.SetImgIndex(FrmMain.WProgUse, 632);
  DKsConF4.Left := 121;
  DKsConF4.Top  := 120;
  DKsConF5.SetImgIndex(FrmMain.WProgUse, 634);
  DKsConF5.Left := 160;
  DKsConF5.Top  := 120;
  DKsConF6.SetImgIndex(FrmMain.WProgUse, 636);
  DKsConF6.Left := 192;
  DKsConF6.Top  := 120;
  DKsConF7.SetImgIndex(FrmMain.WProgUse, 638);
  DKsConF7.Left := 224;
  DKsConF7.Top  := 120;
  DKsConF8.SetImgIndex(FrmMain.WProgUse, 640);
  DKsConF8.Left := 256;
  DKsConF8.Top  := 120;
  //-------
  DKsNone.SetImgIndex(FrmMain.WProgUse, 624);
  DKsNone.Left := 296;//299;//-2
  DKsNone.Top  := 78; //83;//-4
  DKsOk.SetImgIndex(FrmMain.WProgUse, 650);
  DKsOk.Left := 25;//222;
  DKsOk.Top  := 68;//131;

  {-----------------------------------------------------------}
  //그룹 창
  d := FrmMain.WProgUse.Images[120];
  if d <> nil then begin
    DGroupDlg.Left := (SCREENWIDTH - d.Width) div 2;
    DGroupDlg.Top  := (SCREENHEIGHT - d.Height) div 2;
    DGroupDlg.SetImgIndex(FrmMain.WProgUse, 120);
  end;
  DGrpDlgClose.SetImgIndex(FrmMain.WProgUse, 139);
  DGrpDlgClose.Left := 260;
  DGrpDlgClose.Top := 0+5;
  DGrpAllowGroup.SetImgIndex(FrmMain.WProgUse, 122);
  DGrpAllowGroup.Left := 38;
  DGrpAllowGroup.Top := 37;
  DGrpCreate.SetImgIndex(FrmMain.WProgUse, 123);
  DGrpCreate.Left := 29+1;
  DGrpCreate.Top := 215+1;
  DGrpAddMem.SetImgIndex(FrmMain.WProgUse, 124);
  DGrpAddMem.Left := 107+1;
  DGrpAddMem.Top := 215+1;
  DGrpDelMem.SetImgIndex(FrmMain.WProgUse, 125);
  DGrpDelMem.Left := 183+1;
  DGrpDelMem.Top := 215+1;

  {-----------------------------------------------------------}

  d := FrmMain.WProgUse.Images[389];  //내 교환창
  if d <> nil then begin
    DDealDlg.Left := SCREENWIDTH - d.Width;
    DDealDlg.Top  := 0;
    DDealDlg.SetImgIndex(FrmMain.WProgUse, 389);
  end;
  DDGrid.Left   := 21;
  DDGrid.Top    := 56;
  DDGrid.Width  := 36 * 5;
  DDGrid.Height := 33 * 2;
  DDealOk.SetImgIndex(FrmMain.WProgUse, 391);
  DDealOk.Left := 155;
  DDealOk.Top  := 193 - 65;
  DDealClose.SetImgIndex(FrmMain.WProgUse, 64);
  DDealClose.Left := 220;
  DDealClose.Top  := 42;
  DDGold.SetImgIndex(FrmMain.WProgUse, 28);
  DDGold.Left := 11;
  DDGold.Top  := 202 - 65;

  d := FrmMain.WProgUse.Images[390];  //상대방 교환창
  if d <> nil then begin
    DDealRemoteDlg.Left := DDealDlg.Left - d.Width;
    DDealRemoteDlg.Top  := 0;
    DDealRemoteDlg.SetImgIndex(FrmMain.WProgUse, 390);
  end;
  DDRGrid.Left   := 21;
  DDRGrid.Top    := 56;
  DDRGrid.Width  := 36 * 5;
  DDRGrid.Height := 33 * 2;
  DDRGold.SetImgIndex(FrmMain.WProgUse, 28);
  DDRGold.Left := 11;
  DDRGold.Top  := 202 - 65;

  // 장원 거래 알림판
  d := FrmMain.WProgUse.Images[683];
  if d <> nil then begin
    DDealJangwon.Left := 388;
    DDealJangwon.Top  := 138;
    DDealJangwon.SetImgIndex(FrmMain.WProgUse, 683);
  end;

  {-----------------------------------------------------------}
  //문파창
  d := FrmMain.WProgUse.Images[180];
  if d <> nil then begin
    DGuildDlg.Left := 0;
    DGuildDlg.Top  := 0;
    DGuildDlg.SetImgIndex(FrmMain.WProgUse, 180);
  end;
  DGDClose.Left := 584;
  DGDClose.Top  := 6;
  DGDClose.SetImgIndex(FrmMain.WProgUse, 64);
  DGDHome.Left := 13;
  DGDHome.Top  := 411;
  DGDHome.SetImgIndex(FrmMain.WProgUse, 198);
  DGDList.Left := 13;
  DGDList.Top  := 429;
  DGDList.SetImgIndex(FrmMain.WProgUse, 200);
  DGDChat.Left := 94;
  DGDChat.Top  := 429;
  DGDChat.SetImgIndex(FrmMain.WProgUse, 190);
  DGDAddMem.Left := 243;
  DGDAddMem.Top  := 411;
  DGDAddMem.SetImgIndex(FrmMain.WProgUse, 182);
  DGDDelMem.Left := 243;
  DGDDelMem.Top  := 429;
  DGDDelMem.SetImgIndex(FrmMain.WProgUse, 192);
  DGDEditNotice.Left := 325;
  DGDEditNotice.Top  := 411;
  DGDEditNotice.SetImgIndex(FrmMain.WProgUse, 196);
  DGDEditGrade.Left := 325;
  DGDEditGrade.Top  := 429;
  DGDEditGrade.SetImgIndex(FrmMain.WProgUse, 194);
  DGDAlly.Left := 407;
  DGDAlly.Top  := 411;
  DGDAlly.SetImgIndex(FrmMain.WProgUse, 184);
  DGDBreakAlly.Left := 407;
  DGDBreakAlly.Top  := 429;
  DGDBreakAlly.SetImgIndex(FrmMain.WProgUse, 186);
  DGDWar.Left := 529;
  DGDWar.Top  := 411;
  DGDWar.SetImgIndex(FrmMain.WProgUse, 202);
  DGDCancelWar.Left := 529;
  DGDCancelWar.Top  := 429;
  DGDCancelWar.SetImgIndex(FrmMain.WProgUse, 188);

  DGDUp.Left := 595;
  DGDUp.Top  := 239;
  DGDUp.SetImgIndex(FrmMain.WProgUse, 373);
  DGDDown.Left := 595;
  DGDDown.Top  := 291;
  DGDDown.SetImgIndex(FrmMain.WProgUse, 372);

  //문파 공지사항 에디트
  DGuildEditNotice.SetImgIndex(FrmMain.WProgUse, 204);
  DGEOk.SetImgIndex(FrmMain.WProgUse, 361);
  DGEOk.Left := 514;
  DGEOk.Top  := 287;
  DGEClose.SetImgIndex(FrmMain.WProgUse, 64);
  DGEClose.Left := 584;
  DGEClose.Top  := 6;


  {-----------------------------------------------------------}
  //능력치 조절창
  DAdjustAbility.SetImgIndex(FrmMain.WProgUse, 226);
  DAdjustAbilClose.SetImgIndex(FrmMain.WProgUse, 64);
  DAdjustAbilClose.Left := 316;
  DAdjustAbilClose.Top  := 1;
  DAdjustAbilOk.SetImgIndex(FrmMain.WProgUse, 62);
  DAdjustAbilOk.Left := 220;
  DAdjustAbilOk.Top  := 298;

  DPlusDC.SetImgIndex(FrmMain.WProgUse, 227);
  DPlusDC.Left := 217;
  DPlusDC.Top  := 101;
  DPlusMC.SetImgIndex(FrmMain.WProgUse, 227);
  DPlusMC.Left := 217;
  DPlusMC.Top  := 121;
  DPlusSC.SetImgIndex(FrmMain.WProgUse, 227);
  DPlusSC.Left := 217;
  DPlusSC.Top  := 140;
  DPlusAC.SetImgIndex(FrmMain.WProgUse, 227);
  DPlusAC.Left := 217;
  DPlusAC.Top  := 160;
  DPlusMAC.SetImgIndex(FrmMain.WProgUse, 227);
  DPlusMAC.Left := 217;
  DPlusMAC.Top  := 181;
  DPlusHP.SetImgIndex(FrmMain.WProgUse, 227);
  DPlusHP.Left := 217;
  DPlusHP.Top  := 201;
  DPlusMP.SetImgIndex(FrmMain.WProgUse, 227);
  DPlusMP.Left := 217;
  DPlusMP.Top  := 220;
  DPlusHit.SetImgIndex(FrmMain.WProgUse, 227);
  DPlusHit.Left := 217;
  DPlusHit.Top  := 240;
  DPlusSpeed.SetImgIndex(FrmMain.WProgUse, 227);
  DPlusSpeed.Left := 217;
  DPlusSpeed.Top  := 261;

  DMinusDC.SetImgIndex(FrmMain.WProgUse, 228);
  DMinusDC.Left := 227;
  DMinusDC.Top  := 101;
  DMinusMC.SetImgIndex(FrmMain.WProgUse, 228);
  DMinusMC.Left := 227;
  DMinusMC.Top  := 121;
  DMinusSC.SetImgIndex(FrmMain.WProgUse, 228);
  DMinusSC.Left := 227;
  DMinusSC.Top  := 140;
  DMinusAC.SetImgIndex(FrmMain.WProgUse, 228);
  DMinusAC.Left := 227;
  DMinusAC.Top  := 160;
  DMinusMAC.SetImgIndex(FrmMain.WProgUse, 228);
  DMinusMAC.Left := 227;
  DMinusMAC.Top  := 181;
  DMinusHP.SetImgIndex(FrmMain.WProgUse, 228);
  DMinusHP.Left := 227;
  DMinusHP.Top  := 201;
  DMinusMP.SetImgIndex(FrmMain.WProgUse, 228);
  DMinusMP.Left := 227;
  DMinusMP.Top  := 220;
  DMinusHit.SetImgIndex(FrmMain.WProgUse, 228);
  DMinusHit.Left := 227;
  DMinusHit.Top  := 240;
  DMinusSpeed.SetImgIndex(FrmMain.WProgUse, 228);
  DMinusSpeed.Left := 227;
  DMinusSpeed.Top  := 261;

  {-----------------------------------------------------------}
  // 2003/04/15 친구, 쪽지
  //Friends List
  d := FrmMain.WProgUse.Images[536];
  if d <> nil then begin
    DFriendDlg.SetImgIndex(FrmMain.WProgUse, 536);
    DFriendDlg.Left := 0;//(SCREENWIDTH - d.Width) div 2;
    DFriendDlg.Top  := 0;//(SCREENHEIGHT - d.Height) div 2;
  end;
  DFrdClose.SetImgIndex(FrmMain.WProgUse, 139);
  DFrdClose.Left := 272;
  DFrdClose.Top  := 5;
  DFrdPgUp.SetImgIndex(FrmMain.WProgUse, 373);
  DFrdPgUp.Left := 275;
  DFrdPgUp.Top  := 116;
  DFrdPgDn.SetImgIndex(FrmMain.WProgUse, 372);
  DFrdPgDn.Left := 275;
  DFrdPgDn.Top  := 175;
  DFrdFriend.SetImgIndex(FrmMain.WProgUse, 540);
  DFrdFriend.Left := 30;
  DFrdFriend.Top  := 60;
  DFrdBlackList.SetImgIndex(FrmMain.WProgUse, 573);
  DFrdBlackList.Left := 145;
  DFrdBlackList.Top  := 60;
  DFrdAdd.SetImgIndex(FrmMain.WProgUse, 554);
  DFrdAdd.Left := 90;
  DFrdAdd.Top  := 258;
  DFrdDel.SetImgIndex(FrmMain.WProgUse, 556);
  DFrdDel.Left := 124;
  DFrdDel.Top  := 258;
  DFrdMemo.SetImgIndex(FrmMain.WProgUse, 558);
  DFrdMemo.Left := 158;
  DFrdMemo.Top  := 258;
  DFrdMail.SetImgIndex(FrmMain.WProgUse, 560);
  DFrdMail.Left := 192;
  DFrdMail.Top  := 258;
  DFrdWhisper.SetImgIndex(FrmMain.WProgUse, 562);
  DFrdWhisper.Left := 226;
  DFrdWhisper.Top := 258;
  {-----------------------------------------------------------}
  //쪽지목록창
  d := FrmMain.WProgUse.Images[536];
  if d <> nil then begin
    DMailListDlg.SetImgIndex(FrmMain.WProgUse, 536);
    DMailListDlg.Left := 512;//(SCREENWIDTH - d.Width) div 2;
    DMailListDlg.Top  := 0;  //(SCREENHEIGHT - d.Height) div 2;
  end;
  DMailListClose.SetImgIndex(FrmMain.WProgUse, 371);
  DMailListClose.Left := 247;
  DMailListClose.Top  := 5;
  DMailListPgUp.SetImgIndex(FrmMain.WProgUse, 373);
  DMailListPgUp.Left := 259;
  DMailListPgUp.Top  := 102;
  DMailListPgDn.SetImgIndex(FrmMain.WProgUse, 372);
  DMailListPgDn.Left := 259;
  DMailListPgDn.Top  := 154;
  DMLReply.SetImgIndex(FrmMain.WProgUse, 564);
  DMLReply.Left := 90;
  DMLReply.Top  := 233;
  DMLRead.SetImgIndex(FrmMain.WProgUse, 566);
  DMLRead.Left := 124;
  DMLRead.Top  := 233;
  DMLDel.SetImgIndex(FrmMain.WProgUse, 556);
  DMLDel.Left := 158;
  DMLDel.Top  := 233;
  DMLLock.SetImgIndex(FrmMain.WProgUse, 568);
  DMLLock.Left := 192;
  DMLLock.Top  := 233;
  DMLBlock.SetImgIndex(FrmMain.WProgUse, 570);
  DMLBlock.Left := 226;
  DMLBlock.Top := 233;
  {-----------------------------------------------------------}
  //거부자 리스트
  d := FrmMain.WProgUse.Images[536];
  if d <> nil then begin
    DBlockListDlg.SetImgIndex(FrmMain.WProgUse, 536);
    DBlockListDlg.Left := 512;//(SCREENWIDTH - d.Width) div 2;
    DBlockListDlg.Top  := 265;//(SCREENHEIGHT - d.Height) div 2;
  end;
  DBlockListClose.SetImgIndex(FrmMain.WProgUse, 371);
  DBlockListClose.Left := 247;
  DBlockListClose.Top  := 5;
  DBLPgUp.SetImgIndex(FrmMain.WProgUse, 373);
  DBLPgUp.Left := 259;
  DBLPgUp.Top  := 102;
  DBLPgDn.SetImgIndex(FrmMain.WProgUse, 372);
  DBLPgDn.Left := 259;
  DBLPgDn.Top  := 154;
  DBLAdd.SetImgIndex(FrmMain.WProgUse, 554);
  DBLAdd.Left := 192;
  DBLAdd.Top  := 233;
  DBLDel.SetImgIndex(FrmMain.WProgUse, 556);
  DBLDel.Left := 226;
  DBLDel.Top := 233;
  {-----------------------------------------------------------}
  //쪽지창
  d := FrmMain.WProgUse.Images[537];
  if d <> nil then begin
    DMemo.SetImgIndex(FrmMain.WProgUse, 537);
    DMemo.Left := 290;//(SCREENWIDTH - d.Width) div 2;
    DMemo.Top  := 0;  //(SCREENHEIGHT - d.Height) div 2;
  end;
  DMemoClose.SetImgIndex(FrmMain.WProgUse, 371);
  DMemoClose.Left := 205;
  DMemoClose.Top  := 1;
  DMemoB1.SetImgIndex(FrmMain.WProgUse, 544);
  DMemoB1.Left := 58;
  DMemoB1.Top  := 114;
  DMemoB2.SetImgIndex(FrmMain.WProgUse, 538);
  DMemoB2.Left := 126;
  DMemoB2.Top  := 114;

  {-----------------------------------------------------------}
  //연인사제창
  d := FrmMain.WProgUse.Images[583];
  if d <> nil then begin
    DMasterDlg.SetImgIndex(FrmMain.WProgUse, 583);
    DMasterDlg.Left := 0;//(SCREENWIDTH - d.Width) div 2;
    DMasterDlg.Top  := 0;//(SCREENHEIGHT - d.Height) div 2;
  end;
  DMasterClose.SetImgIndex(FrmMain.WProgUse, 371);
  DMasterClose.Left := 280;
  DMasterClose.Top  := 5;
  DLover1.SetImgIndex(FrmMain.WProgUse, 600);
  DLover1.Left := 32;
  DLover1.Top  := 136;
  DLover2.SetImgIndex(FrmMain.WProgUse, 598);
  DLover2.Left := 66;
  DLover2.Top  := 136;
  DLover3.SetImgIndex(FrmMain.WProgUse, 594);
  DLover3.Left := 100;
  DLover3.Top  := 136;
  DMaster1.SetImgIndex(FrmMain.WProgUse, 590);
  DMaster1.Left := 168;
  DMaster1.Top  := 360;
  DMaster2.SetImgIndex(FrmMain.WProgUse, 596);
  DMaster2.Left := 202;
  DMaster2.Top  := 360;
  DMaster3.SetImgIndex(FrmMain.WProgUse, 592);
  DMaster3.Left := 236;
  DMaster3.Top  := 360;

end;




{------------------------------------------------------------------------}


//상태창 열기
procedure TFrmDlg.OpenMyStatus;
var
  str: string;
begin
  str := Copy(fLover.GetDisplay(0), length(STR_LOVER) + 1, 6);
  if str = '' then
    DHeartImg.Visible := False //@@@@@
  else
    DHeartImg.Visible := True;

  DStateWin.Visible := not DStateWin.Visible;
  PageChanged;
end;

procedure TFrmDlg.OpenUserState(ustate: TUserStateInfo);
begin
  UserState1 := ustate;
  if UserState1.bExistLover then
    DHeartImgUS.Visible := True
  else
    DHeartImgUS.Visible := False;
  DUserState1.Visible := True;
end;

//가방 열기
procedure TFrmDlg.OpenItemBag;
begin
  DItemBag.Visible := not DItemBag.Visible;
  if DItemBag.Visible then
    ArrangeItemBag;
end;

//하단 상태바 보기
procedure TFrmDlg.ViewBottomBox(Visible: boolean);
begin
  DBottom.Visible := Visible;
end;


// 아이템 마우스로 이동중 취소
procedure TFrmDlg.CancelItemMoving;
var
  idx, n: integer;
begin
  if ItemMoving then begin
    ItemMoving := False;
    idx := MovingItem.Index;
    if idx < 0 then begin
      if idx = -99 then begin
        AddItemBag(MovingItem.Item);
        Exit;
      end;
      if (idx <= -20) and (idx > -30) then begin
        AddDealItem(MovingItem.Item);
      end else begin
        n := -(idx + 1);
        // 2003/03/15 아이템 인벤토리 확장
        if n in [0..12] then begin    //8->12
          UseItems[n] := MovingItem.Item;
        end;
      end;
    end else if idx in [0..MAXBAGITEM - 1] then begin
      if (ItemArr[idx].S.Name = '') then begin
        //               (MovingItem.Item.S.StdMode <= 3) then begin // 2004/02/23 포션, 음식, 스크롤 아닌것은 가방창에..
        ItemArr[idx] := MovingItem.Item;
      end else begin
        AddItemBag(MovingItem.Item);
      end;
    end;
    MovingItem.Item.S.Name := '';
  end;
  ArrangeItemBag;
end;

 //이동중인 아이템을 바닥에 떨어 뜨림...
 //가방(벨트)에서 버린것만 호출됨
procedure TFrmDlg.DropMovingItem;
var
  idx, DlopCount: integer;
  valstr:    string;
  MsgResult: integer;
begin

  if ItemMoving then begin
    ItemMoving := False;
    if MovingItem.Item.S.Name <> '' then begin
      if MovingItem.Item.S.OverlapItem > 0 then begin
        if DMakeItemDlg.Visible then begin
          DMessageDlg('While making, repeated items cannot be cast away.', [mbOK]);
          ItemMoving := True;
          CancelItemMoving;
          Exit;
        end;

        DlopCount := 0;
        Total     := MovingItem.Item.Dura;
        if Total = 1 then begin
          DlgEditText := '1';
          MsgResult   := mrOk;
        end else
          MsgResult := DCountMsgDlg('How many out of total ' +
            IntToStr(MovingItem.Item.Dura) + '\would you like to cast away?',
            [mbOK, mbCancel, mbAbort]);
        ItemMoving := True;
        if (MsgResult = mrCancel) then begin
          CancelItemMoving;
          Exit;
        end else if MsgResult = mrOk then begin

          GetValidStrVal(DlgEditText, valstr, [' ']);
          DlopCount := Str_ToInt(valstr, 0);

          if DlopCount <= 0 then
            DlopCount := 0;
          if DlopCount > MovingItem.Item.Dura then
            DlopCount := MovingItem.Item.Dura;
          if DlopCount = MovingItem.Item.Dura then begin
            FrmMain.SendDropItem(MovingItem.Item.S.Name,
              MovingItem.Item.MakeIndex);
            AddDropItem(MovingItem.Item);
            MovingItem.Item.S.Name := '';
            MovingItem.Item.Dura   := 0;
          end else if (DlopCount > 0) then begin
            FrmMain.SendDropCountItem(MovingItem.Item.S.Name,
              MovingItem.Item.MakeIndex, DlopCount);
          end;
          CancelItemMoving;
          Exit;
        end;
      end else begin

        if MovingItem.Item.S.StdMode <> 9 then begin
          if mrOk = DMessageDlg('Are you sure you want to cast away the item?',
            [mbOK, mbCancel]) then
            FrmMain.SendDropItem(MovingItem.Item.S.Name,
              MovingItem.Item.MakeIndex)//2004/01/15 ItemSafeGuard..
          else begin
            ItemMoving := True;
            CancelItemMoving;
            Exit;
          end;
        end else
          FrmMain.SendDropItem(MovingItem.Item.S.Name, MovingItem.Item.MakeIndex);
        //2004/01/15 ItemSafeGuard..
      end;

      AddDropItem(MovingItem.Item);
      MovingItem.Item.S.Name := '';
    end;
  end;

    {
   if ItemMoving then begin
      ItemMoving := FALSE;
      if MovingItem.Item.S.Name <> '' then begin
         FrmMain.SendDropItem (MovingItem.Item.S.Name, MovingItem.Item.MakeIndex);
         AddDropItem (MovingItem.Item);
         MovingItem.Item.S.Name := '';
      end;
   end;
    }
end;

procedure TFrmDlg.OpenAdjustAbility;
begin
  DAdjustAbility.Left := 0;
  DAdjustAbility.Top  := 0;
  SaveBonusPoint      := BonusPoint;
  FillChar(BonusAbilChg, sizeof(TNakedAbility), #0);
  DAdjustAbility.Visible := True;
end;

procedure TFrmDlg.DBackgroundBackgroundClick(Sender: TObject);
var
  dropgold: integer;
  valstr:   string;
begin
  if ItemMoving then begin
    DBackground.WantReturn := True;
    if MovingItem.Item.S.Name = 'Gold' then begin
      ItemMoving := False;
      MovingItem.Item.S.Name := '';
      //얼마를 버릴 건지 물어본다.
      DialogSize := 1;
      DMessageDlg('How much  Gold do you want to drop?', [mbOK, mbAbort]);
      GetValidStrVal(DlgEditText, valstr, [' ']);
      dropgold := Str_ToInt(valstr, 0);

      FrmMain.SendDropGold(dropgold);
    end;
    if MovingItem.Index >= 0 then //아이템 가방에서 버린것만..
      DropMovingItem;
  end;
end;

procedure TFrmDlg.DBackgroundMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if ItemMoving then begin
    DBackground.WantReturn := True;
  end;
end;

procedure TFrmDlg.DBottomMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);

  function ExtractUserName(line: string): string;
  var
    uname: string;
  begin
    GetValidStr3(line, line, ['(', '!', '*', '/', ')']);
    GetValidStr3(line, uname, [' ', '=', ':']);
    if uname <> '' then
      if (uname[1] = '/') or (uname[1] = '(') or (uname[1] = ' ') or
        (uname[1] = '[') then
        uname := '';
    Result := uname;
  end;

var
  n:   integer;
  str: string;
begin
  //채팅창에 클릭하면, '/'귓속말 일때 클릭한 대화를 한사람의 이름이 귓말대상자가 되게 한다.
  if (X >= 208) and (X <= 208 + 374) and (Y >= SCREENHEIGHT - 130) and
    (Y <= SCREENHEIGHT - 130 + 12 * 9) then begin
    n := DScreen.ChatBoardTop + (Y - (SCREENHEIGHT - 130)) div 12;
    if (n < DScreen.ChatStrs.Count) then begin
      if not PlayScene.EdChat.Visible then begin
        PlayScene.EdChat.Visible := True;
        PlayScene.EdChat.SetFocus;
      end;
      PlayScene.EdChat.Text      := '/' + ExtractUserName(DScreen.ChatStrs[n]) + ' ';
      PlayScene.EdChat.SelStart  := Length(PlayScene.EdChat.Text);
      PlayScene.EdChat.SelLength := 0;
    end else
      PlayScene.EdChat.Text := '';
  end;

  if DItemMarketDlg.Visible then begin
    if (X >= 206) and (X <= 208 + 380) and (Y >= SCREENHEIGHT - 51) then
      SetChatFocus;
  end;

end;




{------------------------------------------------------------------------}

////메세지 다이얼로그 박스
function TFrmDlg.DMessageDlg(msgstr: string; DlgButtons: TMsgDlgButtons): TModalResult;

  procedure DoRunDice;
  var
    dr:   TDirectDrawSurface;
    i:    integer;
    flag: boolean;
  begin
    if RunDice = 1 then begin
      if DiceArr[0].DiceCount < 20 then begin
        if GetTickCount - DiceArr[0].DiceTime > 100 then begin
          if DiceArr[0].DiceCount mod 5 = 4 then
            DiceArr[0].DiceCurrent := 1 + Random(6)
          else
            DiceArr[0].DiceCurrent := 8 + DiceArr[0].DiceCount mod 5;
          DiceArr[0].DiceTime := GetTickCount;
          Inc(DiceArr[0].DiceCount);
        end;
      end else begin
        DiceArr[0].DiceCurrent := DiceArr[0].DiceResult;
        if GetTickCount - DiceArr[0].DiceTime > 1500 then
          DMsgDlg.Visible := False;
      end;
    end else begin
      flag := True;
      for i := 0 to RunDice - 1 do begin
        if DiceArr[i].DiceCount < DiceArr[i].DiceLimit then begin
          if GetTickCount - DiceArr[i].DiceTime > 100 then begin
            if DiceArr[i].DiceCount mod 5 = 4 then
              DiceArr[i].DiceCurrent := 1 + Random(6)
            else
              DiceArr[i].DiceCurrent := 8 + DiceArr[i].DiceCount mod 5;
            DiceArr[i].DiceTime := GetTickCount;
            Inc(DiceArr[i].DiceCount);
          end;
          flag := False;
        end else begin
          DiceArr[i].DiceCurrent := DiceArr[i].DiceResult;
          if GetTickCount - DiceArr[i].DiceTime < 2000 then
            flag := False;
        end;
      end;
      if flag then
        DMsgDlg.Visible := False;
    end;
  end;

const
  XBase = 324;
var
  lx, ly, i, k: integer;
  d: TDirectDrawSurface;
begin
  lx := XBase;
  ly := 126;
  case DialogSize of
    0:  //작은거
    begin
      d := FrmMain.WProgUse.Images[381];
      if d <> nil then begin
        DMsgDlg.SetImgIndex(FrmMain.WProgUse, 381);
        DMsgDlg.Left := (SCREENWIDTH - d.Width) div 2;
        DMsgDlg.Top := (SCREENHEIGHT - d.Height) div 2;
        msglx := 39;
        msgly := 38;
        lx    := 90; //d.Width div 2 - 38; //XBase;
        ly    := 36; //56;
      end;
    end;
    1:  //넓고 큰거
    begin
      d := FrmMain.WProgUse.Images[360];
      if d <> nil then begin
        DMsgDlg.SetImgIndex(FrmMain.WProgUse, 360);
        DMsgDlg.Left := (SCREENWIDTH - d.Width) div 2;
        DMsgDlg.Top := (SCREENHEIGHT - d.Height) div 2;
        msglx := 39;
        msgly := 38;
        lx    := XBase;
        ly    := 126;
      end;
    end;
    2:  //길은거
    begin
      d := FrmMain.WProgUse.Images[380];
      if d <> nil then begin
        DMsgDlg.SetImgIndex(FrmMain.WProgUse, 380);
        DMsgDlg.Left := (SCREENWIDTH - d.Width) div 2;
        DMsgDlg.Top := (SCREENHEIGHT - d.Height) div 2;
        msglx := 23;
        msgly := 20;
        lx    := 90;
        ly    := 305;
      end;
    end;
  end;
  MsgText      := msgstr;
  ViewDlgEdit  := False;
  DMsgDlg.Floating := True;   //메세지 박스가 떠다님..
  DMsgDlgOk.Visible := False;
  DMsgDlgYes.Visible := False;
  DMsgDlgCancel.Visible := False;
  DMsgDlgNo.Visible := False;
  DMsgDlg.Left := (SCREENWIDTH - DMsgDlg.Width) div 2;
  DMsgDlg.Top  := (SCREENHEIGHT - DMsgDlg.Height) div 2;

  for i := 0 to RunDice - 1 do begin
    DiceArr[i].DiceCount   := 0;
    DiceArr[i].DiceLimit   := 10 + Random(RunDice + 2) * 5;
    DiceArr[i].DiceCurrent := 1;
    DiceArr[i].DiceTime    := GetTickCount;
  end;

  if mbCancel in DlgButtons then begin
    DMsgDlgCancel.Left := lx;
    DMsgDlgCancel.Top := ly;
    DMsgDlgCancel.Visible := True;
    lx := lx - 110;
  end;
  if mbNo in DlgButtons then begin
    DMsgDlgNo.Left := lx;
    DMsgDlgNo.Top := ly;
    DMsgDlgNo.Visible := True;
    lx := lx - 110;
  end;
  if mbYes in DlgButtons then begin
    DMsgDlgYes.Left := lx;
    DMsgDlgYes.Top := ly;
    DMsgDlgYes.Visible := True;
    lx := lx - 110;
  end;
  if (mbOK in DlgButtons) or (lx = XBase) then begin
    DMsgDlgOk.Left := lx;
    DMsgDlgOk.Top := ly;
    DMsgDlgOk.Visible := True;
    lx := lx - 110;
  end;
  HideAllControls;
  DMsgDlg.ShowModal;

  if mbAbort in DlgButtons then begin
    ViewDlgEdit      := True; //에디트 컨트롤이 보여야 하는 경우.
    DMsgDlg.Floating := False;
    with EdDlgEdit do begin
      Text  := '';
      Width := DMsgDlg.Width - 70;
      Left  := (SCREENWIDTH - EdDlgEdit.Width) div 2;
      Top   := (SCREENHEIGHT - EdDlgEdit.Height) div 2 - 10;
      EdDlgEdit.MaxLength := MsgDlgMaxStr;
    end;
  end;
  Result := mrOk;
  k      := 0;
  while True do begin
    if not DMsgDlg.Visible then
      break;
    FrmMain.DXTimerTimer (self, 0);
    //FrmMain.ProcOnIdle;
    Application.ProcessMessages;
    Inc(k);
    if k = 5 then begin
      FrmMain.MsgProg;
      k := 0;
    end;

    if BoMsgDlgTimeCheck then begin
      if MsgDlgClickTime < GetTickCount then begin
        DMsgDlg.DialogResult := mrNo;
        BoMsgDlgTimeCheck    := False;
        MsgDlgClickTime      := GetTickCount;
        DMsgDlg.Visible      := False;
        break;
      end;
    end;
    if RunDice > 0 then begin
      BoDrawDice := True;
      for i := 0 to RunDice - 1 do begin
        DiceArr[i].DiceLeft :=
          DMsgDlg.Width div 2 + 6 - (33 * RunDice) div 2 + 33 * i; // - 15;  //37
        DiceArr[i].DiceTop  := DMsgDlg.Height div 2 - 14;  //25
      end;
      DoRunDice;
    end;
    if Application.Terminated then
      exit;
  end;

  EdDlgEdit.Visible := False;
  RestoreHideControls;
  DlgEditText := EdDlgEdit.Text;
  if PlayScene.EdChat.Visible then
    PlayScene.EdChat.SetFocus;
  ViewDlgEdit := False;
  Result      := DMsgDlg.DialogResult;
  DialogSize  := 1; //기본상태
  RunDice     := 0;
  BoDrawDice  := False;
end;

function TFrmDlg.OnlyMessageDlg(msgstr: string;
  DlgButtons: TMsgDlgButtons): TModalResult;
const
  XBase = 324;
var
  lx, ly, i: integer;
  d: TDirectDrawSurface;
begin
  lx := XBase;
  ly := 126;
  case DialogSize of
    1:  //넓고 큰거
    begin
      d := FrmMain.WProgUse.Images[360];
      if d <> nil then begin
        DMsgDlg.SetImgIndex(FrmMain.WProgUse, 360);
        DMsgDlg.Left := (SCREENWIDTH - d.Width) div 2;
        DMsgDlg.Top := (SCREENHEIGHT - d.Height) div 2;
        msglx := 39;
        msgly := 38;
        lx    := XBase;
        ly    := 126;
      end;
    end;
  end;
  MsgText      := msgstr;
  ViewDlgEdit  := False;
  DMsgDlg.Floating := True;   //메세지 박스가 떠다님..
  DMsgDlgOk.Visible := False;
  DMsgDlgYes.Visible := False;
  DMsgDlgCancel.Visible := False;
  DMsgDlgNo.Visible := False;
  DMsgDlg.Left := (SCREENWIDTH - DMsgDlg.Width) div 2;
  DMsgDlg.Top  := (SCREENHEIGHT - DMsgDlg.Height) div 2;

  if (mbOK in DlgButtons) or (lx = XBase) then begin
    DMsgDlgOk.Left := lx;
    DMsgDlgOk.Top := ly;
    DMsgDlgOk.Visible := True;
    lx := lx - 110;
  end;
  HideAllControls;
  Result := mrOk;
  DMsgDlg.ShowModal;
  while True do begin
    if not DMsgDlg.Visible then
      break;
    FrmMain.DXTimerTimer (self, 0);
    //FrmMain.ProcOnIdle;
    Application.ProcessMessages;

{      if BoMsgDlgTimeCheck then begin
         if MsgDlgClickTime < GetTickCount then begin
            DMsgDlg.DialogResult := mrNo;
            BoMsgDlgTimeCheck := False;
            MsgDlgClickTime := GetTickCount;
            DMsgDlg.Visible := False;
            break;
         end;
      end;}
    if Application.Terminated then
      exit;
  end;

  EdDlgEdit.Visible := False;
  RestoreHideControls;
  DlgEditText := EdDlgEdit.Text;
  if PlayScene.EdChat.Visible then
    PlayScene.EdChat.SetFocus;
  ViewDlgEdit := False;
  Result      := DMsgDlg.DialogResult;
  DialogSize  := 1; //기본상태
  RunDice     := 0;
  BoDrawDice  := False;
end;

procedure TFrmDlg.DMsgDlgOkClick(Sender: TObject; X, Y: integer);
begin
  if Sender = DMsgDlgOk then
    DMsgDlg.DialogResult := mrOk;
  if Sender = DMsgDlgYes then
    DMsgDlg.DialogResult := mrYes;
  if Sender = DMsgDlgCancel then
    DMsgDlg.DialogResult := mrCancel;
  if Sender = DMsgDlgNo then
    DMsgDlg.DialogResult := mrNo;

  if GameClose then
    FrmMain.Close;

  BoMsgDlgTimeCheck := False;
  MsgDlgClickTime   := GetTickCount;
  DMsgDlg.Visible   := False;
end;

procedure TFrmDlg.DMsgDlgKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = 13 then begin
    //2003/02/11 OK/Cancel에서는 엔터를 OK로...
    if DMsgDlgOk.Visible and not (DMsgDlgYes.Visible {or DMsgDlgCancel.Visible} or
      DMsgDlgNo.Visible) then begin
      DMsgDlg.DialogResult := mrOk;
      DMsgDlg.Visible      := False;
    end;
    if DMsgDlgYes.Visible and not (DMsgDlgOk.Visible or DMsgDlgCancel.Visible) then
    begin
      DMsgDlg.DialogResult := mrYes;
      DMsgDlg.Visible      := False;
    end;
  end;
  if Key = 27 then begin
    if DMsgDlgNo.Visible then begin
      DMsgDlg.DialogResult := mrNo;
      DMsgDlg.Visible      := False;
    end;
    if DMsgDlgCancel.Visible then begin
      DMsgDlg.DialogResult := mrCancel;
      DMsgDlg.Visible      := False;
    end;
  end;
end;

procedure TFrmDlg.DMsgDlgOkDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if not Downed then
      d := WLib.Images[FaceIndex]
    else
      d := WLib.Images[FaceIndex + 1];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
  end;
end;

procedure TFrmDlg.DMsgDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d, dr:     TDirectDrawSurface;
  ly, px, py, i: integer;
  str, Data: string;
begin
  with Sender as TDWindow do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    if BoDrawDice then begin
      for i := 0 to RunDice - 1 do begin
        dr := FrmMain.WBagItem.GetCachedImage(376 +
          DiceArr[i].DiceCurrent - 1, px, py);
        if dr <> nil then begin
          dsurface.Draw(SurfaceX(Left) + DiceArr[i].DiceLeft + px - 14,
            SurfaceY(Top) + DiceArr[i].DiceTop + py + 38,
            dr.ClientRect,
            dr, True);
        end;
      end;
    end;
    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    ly  := msgly;
    str := MsgText;
    while True do begin
      if str = '' then
        break;
      str := GetValidStr3(str, Data, ['\']);
      if Data <> '' then
        BoldTextOut(dsurface, SurfaceX(Left + msglx), SurfaceY(Top + ly),
          clWhite, clBlack, Data);
      ly := ly + 14;
    end;
    dsurface.Canvas.Release;
  end;
  if ViewDlgEdit then begin
    if not EdDlgEdit.Visible then begin
      EdDlgEdit.Visible := True;
      EdDlgEdit.SetFocus;
    end;
  end;
end;

{------------------------------------------------------------------------}

//로그인 창

procedure TFrmDlg.DLoginNewDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if TDButton(Sender).Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DLoginNewClick(Sender: TObject; X, Y: integer);
var
  IE: variant;
begin
  // 2003/02/11 신규계정 생성 막음
  // LoginScene.NewClick;
  // 2003/03/18 신규계정 홈페이지로 연결

  { SEAN - 29/12/08 - Temporarily removed
  IE := CreateOleObject('Internetexplorer.Application');
  IE.Visible := True;
  IE.Navigate('http://www.mir2.com.ph/register.asp');
  FrmMain.Close;
  }

end;

procedure TFrmDlg.DLoginOkClick(Sender: TObject; X, Y: integer);
begin
  LoginScene.OkClick;
end;

procedure TFrmDlg.DLoginCloseClick(Sender: TObject; X, Y: integer);
begin
  FrmMain.Close;
end;

procedure TFrmDlg.DLoginChgPwClick(Sender: TObject; X, Y: integer);
var
  IE: variant;
begin
  // 2003/03/18 비밀번호변경 홈페이지로 연결
  // LoginScene.ChgPwClick;

  { SEAN - 29/12/08 - Temporarily removed
  IE := CreateOleObject('Internetexplorer.Application');
  IE.Visible := True;
  IE.Navigate('http://www.mir2.com.ph/account.asp');
  FrmMain.Close;
  }
  
end;

procedure TFrmDlg.DLoginNewClickSound(Sender: TObject; Clicksound: TClickSound);
begin
  case Clicksound of
    csNorm: PlaySound(s_norm_button_click);
    csStone: PlaySound(s_rock_button_click);
    csGlass: PlaySound(s_glass_button_click);
  end;
end;

 {------------------------------------------------------------------------}
 //서버 선택 창

procedure TFrmDlg.ShowSelectServerDlg;
begin
  DSelServerDlg.Visible  := True;
  BoFirstShowOnServerSel := True;
end;

procedure TFrmDlg.DSelServerDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DSelServerDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
  end;
  if BoFirstShowOnServerSel then begin
    BoFirstShowOnServerSel := False;

    if ServerCount >= 1 then
      DSServer1.Caption := ServerCaptionArr[0];
    if ServerCount >= 2 then
      DSServer2.Caption := ServerCaptionArr[1];
    if ServerCount >= 3 then
      DSServer3.Caption := ServerCaptionArr[2];
    if ServerCount >= 4 then
      DSServer4.Caption := ServerCaptionArr[3];
    if ServerCount >= 5 then
      DSServer5.Caption := ServerCaptionArr[4];
    if ServerCount >= 6 then
      DSServer6.Caption := ServerCaptionArr[5];
    if ServerCount >= 7 then
      DSServer7.Caption := ServerCaptionArr[6];
    if ServerCount >= 8 then
      DSServer8.Caption := ServerCaptionArr[7];

    if ServerCount >= 9 then
      DSServer9.Caption := ServerCaptionArr[8];
    if ServerCount >= 10 then
      DSServer10.Caption := ServerCaptionArr[9];
    if ServerCount >= 11 then
      DSServer11.Caption := ServerCaptionArr[10];
    if ServerCount >= 12 then
      DSServer12.Caption := ServerCaptionArr[11];
    if ServerCount >= 13 then
      DSServer13.Caption := ServerCaptionArr[12];
    if ServerCount >= 14 then
      DSServer14.Caption := ServerCaptionArr[13];
    if ServerCount >= 15 then
      DSServer15.Caption := ServerCaptionArr[14];
    if ServerCount >= 16 then
      DSServer16.Caption := ServerCaptionArr[15];

    if ServerCount >= 17 then
      DSServer17.Caption := ServerCaptionArr[16];
    if ServerCount >= 18 then
      DSServer18.Caption := ServerCaptionArr[17];
    if ServerCount >= 19 then
      DSServer19.Caption := ServerCaptionArr[18];
    if ServerCount >= 20 then
      DSServer20.Caption := ServerCaptionArr[19];
    if ServerCount >= 21 then
      DSServer21.Caption := ServerCaptionArr[20];
    if ServerCount >= 22 then
      DSServer22.Caption := ServerCaptionArr[21];
    if ServerCount >= 23 then
      DSServer23.Caption := ServerCaptionArr[22];
    if ServerCount >= 24 then
      DSServer24.Caption := ServerCaptionArr[23];

    if ServerCount >= 25 then
      DSServer25.Caption := ServerCaptionArr[24];
    if ServerCount >= 26 then
      DSServer26.Caption := ServerCaptionArr[25];
    if ServerCount >= 27 then
      DSServer27.Caption := ServerCaptionArr[26];
    if ServerCount >= 28 then
      DSServer28.Caption := ServerCaptionArr[27];

  end;

end;

procedure TFrmDlg.DSServer1Click(Sender: TObject; X, Y: integer);
var
  svname: string;
begin
  svname := '';
  if TDButton(Sender).Tag = 0 then
    svname := ServerNameArr[0];
  if TDButton(Sender).Tag = 1 then
    svname := ServerNameArr[1];
  if TDButton(Sender).Tag = 2 then
    svname := ServerNameArr[2];
  if TDButton(Sender).Tag = 3 then
    svname := ServerNameArr[3];
  if TDButton(Sender).Tag = 4 then
    svname := ServerNameArr[4];
  if TDButton(Sender).Tag = 5 then
    svname := ServerNameArr[5];
  if TDButton(Sender).Tag = 6 then
    svname := ServerNameArr[6];
  if TDButton(Sender).Tag = 7 then
    svname := ServerNameArr[7];

  if TDButton(Sender).Tag = 8 then
    svname := ServerNameArr[8];
  if TDButton(Sender).Tag = 9 then
    svname := ServerNameArr[9];
  if TDButton(Sender).Tag = 10 then
    svname := ServerNameArr[10];
  if TDButton(Sender).Tag = 11 then
    svname := ServerNameArr[11];
  if TDButton(Sender).Tag = 12 then
    svname := ServerNameArr[12];
  if TDButton(Sender).Tag = 13 then
    svname := ServerNameArr[13];
  if TDButton(Sender).Tag = 14 then
    svname := ServerNameArr[14];
  if TDButton(Sender).Tag = 15 then
    svname := ServerNameArr[15];

  if TDButton(Sender).Tag = 16 then
    svname := ServerNameArr[16];
  if TDButton(Sender).Tag = 17 then
    svname := ServerNameArr[17];
  if TDButton(Sender).Tag = 18 then
    svname := ServerNameArr[18];
  if TDButton(Sender).Tag = 19 then
    svname := ServerNameArr[19];
  if TDButton(Sender).Tag = 20 then
    svname := ServerNameArr[20];
  if TDButton(Sender).Tag = 21 then
    svname := ServerNameArr[21];
  if TDButton(Sender).Tag = 22 then
    svname := ServerNameArr[22];
  if TDButton(Sender).Tag = 23 then
    svname := ServerNameArr[23];

  if TDButton(Sender).Tag = 24 then
    svname := ServerNameArr[24];
  if TDButton(Sender).Tag = 25 then
    svname := ServerNameArr[25];
  if TDButton(Sender).Tag = 26 then
    svname := ServerNameArr[26];
  if TDButton(Sender).Tag = 27 then
    svname := ServerNameArr[27];

  if svname <> '' then begin
    if BO_FOR_TEST then begin
      svname := 'DragonServer';
    end;
    FrmMain.SendSelectServer(svname);
    DSelServerDlg.Visible := False;
    ServerName := svname;
  end;
end;

procedure TFrmDlg.DEngServer1Click(Sender: TObject; X, Y: integer);
var
  svname: string;
begin
  svname := 'DragonServer';

  if svname <> '' then begin
    if BO_FOR_TEST then begin
      svname := 'DragonServer';
    end;
    FrmMain.SendSelectServer(svname);
    DSelServerDlg.Visible := False;
    ServerName := svname;
  end;
end;



procedure TFrmDlg.DSSrvCloseClick(Sender: TObject; X, Y: integer);
begin
  DSelServerDlg.Visible := False;
  FrmMain.Close;
end;


 {------------------------------------------------------------------------}
 //새 계정 만들기 창


procedure TFrmDlg.DNewAccountOkClick(Sender: TObject; X, Y: integer);
begin
  LoginScene.NewAccountOk;
end;

procedure TFrmDlg.DNewAccountCloseClick(Sender: TObject; X, Y: integer);
begin
  LoginScene.NewAccountClose;
end;

procedure TFrmDlg.DNewAccountDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  i: integer;
begin
  with dsurface.Canvas do begin
    with DNewAccount do begin
      d := DMenuDlg.WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;

    SetBkMode(Handle, TRANSPARENT);
    Font.Color := clSilver;
    for i := 0 to NAHelps.Count - 1 do begin
      TextOut(79 + 386 + 10, 64 + 119 + 5 + i * 14, NAHelps[i]);
    end;
    BoldTextOut(dsurface, 79 + 283, 64 + 57, clWhite, clBlack, NewAccountTitle);
    Release;
  end;
end;



 {------------------------------------------------------------------------}
 ////Chg pw 박스


procedure TFrmDlg.DChgpwOkClick(Sender: TObject; X, Y: integer);
begin
  if Sender = DChgpwOk then
    LoginScene.ChgpwOk;
  if Sender = DChgpwCancel then
    LoginScene.ChgpwCancel;
end;




 {------------------------------------------------------------------------}
 //캐릭터 선택


procedure TFrmDlg.DscSelect1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin

    if ((Sender = DscSelect1) OR (Sender = DscSelect2)
        OR (Sender = DscSelect3) OR (Sender = DscSelect4)) then
      exit;

    if Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(Left, Top, d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DscSelect1Click(Sender: TObject; X, Y: integer);
begin
  if Sender = DscSelect1 then
    SelectChrScene.SelChrSelect1Click;
  if Sender = DscSelect2 then
    SelectChrScene.SelChrSelect2Click;
  { SEAN - 29/12/08 - For future
  if Sender = DscSelect3 then
    SelectChrScene.SelChrSelect3Click;
  if Sender = DscSelect4 then
    SelectChrScene.SelChrSelect4Click;}
  if Sender = DscStart then
    SelectChrScene.SelChrStartClick;
  if Sender = DscNewChr then
    SelectChrScene.SelChrNewChrClick;
  if Sender = DscEraseChr then
    SelectChrScene.SelChrEraseChrClick;
  if Sender = DscCredits then
    SelectChrScene.SelChrCreditsClick;
  if Sender = DscExit then
    SelectChrScene.SelChrExitClick;
end;




 {------------------------------------------------------------------------}
 //새 캐릭터 만들기 창


procedure TFrmDlg.DccCloseDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end else begin
      d := nil;
      if Sender = DccWarrior then begin
        with SelectChrScene do
          if ChrArr[NewIndex].UserChr.Job = 0 then
            d := WLib.Images[55];
      end;
      if Sender = DccWizzard then begin
        with SelectChrScene do
          if ChrArr[NewIndex].UserChr.Job = 1 then
            d := WLib.Images[56];
      end;
      if Sender = DccMonk then begin
        with SelectChrScene do
          if ChrArr[NewIndex].UserChr.Job = 2 then
            d := WLib.Images[57];
      end;
      if Sender = DccAssasin then begin
        with SelectChrScene do
          if ChrArr[NewIndex].UserChr.Job = 3 then
            d := WLib.Images[75];
      end;
      if Sender = DccMale then begin
        with SelectChrScene do
          if ChrArr[NewIndex].UserChr.Sex = 0 then
            d := WLib.Images[58];
      end;
      if Sender = DccFemale then begin
        with SelectChrScene do
          if ChrArr[NewIndex].UserChr.Sex = 1 then
            d := WLib.Images[59];
      end;
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DccCloseClick(Sender: TObject; X, Y: integer);
begin
  if Sender = DccClose then
    SelectChrScene.SelChrNewClose;
  if Sender = DccWarrior then
    SelectChrScene.SelChrNewJob(0);
  if Sender = DccWizzard then
    SelectChrScene.SelChrNewJob(1);
  if Sender = DccMonk then
    SelectChrScene.SelChrNewJob(2);
  if Sender = DccAssasin then
    SelectChrScene.SelChrNewJob(3);
  if Sender = DccMale then
    SelectChrScene.SelChrNewSex(0);
  if Sender = DccFemale then
    SelectChrScene.SelChrNewSex(1);
  if Sender = DccLeftHair then
    SelectChrScene.SelChrNewPrevHair;
  if Sender = DccRightHair then
    SelectChrScene.SelChrNewNextHair;
  if Sender = DccOk then
    SelectChrScene.SelChrNewOk;
end;




{------------------------------------------------------------------------}

//상태창...

{------------------------------------------------------------------------}


procedure TFrmDlg.DStateWinDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  i, l, m, pgidx, magline, bbx, bby, mmx, idx, ax, ay, trainlv, tx: integer;
  pm:  PTClientMagic;
  d:   TDirectDrawSurface;
  hcolor, old, keyimg: integer;
  iname, d1, d2, d3, d4: string;
  useable: boolean;
  str: string;
begin
  if Myself = nil then
    exit;
  with DStateWin do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    case StatePage of
      0: begin //착용상태
        pgidx := 376;
        if Myself <> nil then
          if Myself.Sex = 1 then
            pgidx := 377;
        bbx := Left + 38;
        bby := Top + 52;
        d   := FrmMain.WProgUse.Images[pgidx];
        if d <> nil then
          dsurface.Draw(SurfaceX(bbx), SurfaceY(bby), d.ClientRect, d, False);
        bbx := bbx - 7;
        bby := bby + 44;
        if UseItems[U_DRESS].S.Name <> '' then begin
          idx := UseItems[U_DRESS].S.Looks;
          //옷 if Myself.Sex = 1 then idx := 80; //여자옷
          if idx >= 0 then begin
            d := FrmMain.WStateItem.GetCachedImage(idx, ax, ay);
            if d <> nil then
              dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
                d.ClientRect, d, True);
          end;
        end;

        idx := 440 + Myself.Hair div 2; //머리 스타일
        if Myself.Sex = 1 then
          idx := 480 + Myself.Hair div 2;
        if idx > 0 then begin
          d := FrmMain.WProgUse.GetCachedImage(idx, ax, ay);
          if d <> nil then
            dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
              d.ClientRect, d, True);
        end;

        if UseItems[U_WEAPON].S.Name <> '' then begin
          idx := UseItems[U_WEAPON].S.Looks;
          if idx >= 0 then begin
            d := FrmMain.WStateItem.GetCachedImage(idx, ax, ay);
            if d <> nil then
              dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
                d.ClientRect, d, True);
          end;
        end;
        if UseItems[U_HELMET].S.Name <> '' then begin
          idx := UseItems[U_HELMET].S.Looks;
          if idx >= 0 then begin
            d := FrmMain.WStateItem.GetCachedImage(idx, ax, ay);
            if d <> nil then
              dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay),
                d.ClientRect, d, True);
          end;
        end;
      end;
      1: begin //능력치
        l := Left + 112; //66;
        m := Top + 99;
        with dsurface.Canvas do begin
          SetBkMode(Handle, TRANSPARENT);
          Font.Color := clWhite;
          TextOut(SurfaceX(l + 0), SurfaceY(m + 0), IntToStr(Lobyte(Myself.Abil.AC)) +
            '-' + IntToStr(Hibyte(Myself.Abil.AC)));
          TextOut(SurfaceX(l + 0), SurfaceY(m + 20),
            IntToStr(Lobyte(Myself.Abil.MAC)) + '-' + IntToStr(Hibyte(Myself.Abil.MAC)));
          TextOut(SurfaceX(l + 0), SurfaceY(m + 40),
            IntToStr(Lobyte(Myself.Abil.DC)) + '-' + IntToStr(Hibyte(Myself.Abil.DC)));
          TextOut(SurfaceX(l + 0), SurfaceY(m + 60),
            IntToStr(Lobyte(Myself.Abil.MC)) + '-' + IntToStr(Hibyte(Myself.Abil.MC)));
          TextOut(SurfaceX(l + 0), SurfaceY(m + 80),
            IntToStr(Lobyte(Myself.Abil.SC)) + '-' + IntToStr(Hibyte(Myself.Abil.SC)));
          TextOut(SurfaceX(l + 0), SurfaceY(m + 100), IntToStr(Myself.Abil.HP) +
            '/' + IntToStr(Myself.Abil.MaxHP));
          TextOut(SurfaceX(l + 0), SurfaceY(m + 120), IntToStr(Myself.Abil.MP) +
            '/' + IntToStr(Myself.Abil.MaxMP));
          Release;
        end;
      end;
      2: begin //능력치 설명창
        bbx := Left + 38;
        bby := Top + 52;
        d   := FrmMain.WProgUse.Images[382];
        if d <> nil then
          dsurface.Draw(SurfaceX(bbx), SurfaceY(bby), d.ClientRect, d, False);

        bbx := bbx + 20;
        bby := bby + 10;
        with dsurface.Canvas do begin
          SetBkMode(Handle, TRANSPARENT);
          mmx := bbx + 85;
          Font.Color := clSilver;
          TextOut(bbx, bby, 'Exp.');
          TextOut(mmx, bby,
            Format('%2.2f', [Myself.Abil.Exp / Myself.Abil.MaxExp * 100]) + '%');
          //TextOut (bbx, bby+14*1, 'Maximum experience ');
          //TextOut (mmx, bby+14*1, IntToStr(Myself.Abil.MaxExp));

          TextOut(bbx, bby + 14 * 1, 'Bag weight');
          if Myself.Abil.Weight > Myself.Abil.MaxWeight then
            Font.Color := clRed;
          TextOut(mmx, bby + 14 * 1, IntToStr(Myself.Abil.Weight) +
            '/' + IntToStr(Myself.Abil.MaxWeight));

          Font.Color := clSilver;
          TextOut(bbx, bby + 14 * 2, 'C. Weight ');
          if Myself.Abil.WearWeight > Myself.Abil.MaxWearWeight then
            Font.Color := clRed;
          TextOut(mmx, bby + 14 * 2, IntToStr(Myself.Abil.WearWeight) +
            '/' + IntToStr(Myself.Abil.MaxWearWeight));

          Font.Color := clSilver;
          TextOut(bbx, bby + 14 * 3, 'Hands W.');
          if Myself.Abil.HandWeight > Myself.Abil.MaxHandWeight then
            Font.Color := clRed;
          TextOut(mmx, bby + 14 * 3, IntToStr(Myself.Abil.HandWeight) +
            '/' + IntToStr(Myself.Abil.MaxHandWeight));

          Font.Color := clSilver;
          TextOut(bbx, bby + 14 * 4, 'Accuracy ');
          TextOut(mmx, bby + 14 * 4, IntToStr(MyHitPoint));

          TextOut(bbx, bby + 14 * 5, 'Agility ');
          TextOut(mmx, bby + 14 * 5, IntToStr(MySpeedPoint));

          //               TextOut (bbx, bby+14*6, 'M. Evasion');
          TextOut(bbx, bby + 14 * 6, 'M. Resistance');
          TextOut(mmx, bby + 14 * 6, '+' + IntToStr(MyAntiMagic));

          //               TextOut (bbx, bby+14*7, 'P. Evasion');
          TextOut(bbx, bby + 14 * 7, 'P. Resistance');
          TextOut(mmx, bby + 14 * 7, '+' + IntToStr(MyAntiPoison));

          TextOut(bbx, bby + 14 * 8, 'P. Recovery ');
          TextOut(mmx, bby + 14 * 8, '+' + IntToStr(MyPoisonRecover * 10) + '%');

          TextOut(bbx, bby + 14 * 9, 'HP Recovery');
          TextOut(mmx, bby + 14 * 9, '+' + IntToStr(MyHealthRecover * 10) + '%');

          TextOut(bbx, bby + 14 * 10, 'MP Recovery');
          TextOut(mmx, bby + 14 * 10, '+' + IntToStr(MySpellRecover * 10) + '%');

          Release;
        end;
      end;
      3: begin //마법 창
        bbx := Left + 38;
        bby := Top + 52;
        d   := FrmMain.WProgUse.Images[383];
        if d <> nil then
          dsurface.Draw(SurfaceX(bbx), SurfaceY(bby), d.ClientRect, d, False);

        //키 표시, lv, exp
        magtop  := MagicPage * 5;
        magline := _MIN(MagicPage * 5 + 5, MagicList.Count);
        for i := magtop to magline - 1 do begin
          pm     := PTClientMagic(MagicList[i]);
          m      := i - magtop;
          keyimg := 0;
          case byte(pm.Key) of
            byte('1'): keyimg      := 650;//248;
            byte('2'): keyimg      := 651;
            byte('3'): keyimg      := 652;
            byte('4'): keyimg      := 653;
            byte('5'): keyimg      := 654;
            byte('6'): keyimg      := 655;
            byte('7'): keyimg      := 656;
            byte('8'): keyimg      := 657;
            // 2003/08/20 =>마법단축키 추가  // AddMagicKey
            byte('1') + 20: keyimg := 642;
            byte('2') + 20: keyimg := 643;
            byte('3') + 20: keyimg := 644;
            byte('4') + 20: keyimg := 645;
            byte('5') + 20: keyimg := 646;
            byte('6') + 20: keyimg := 647;
            byte('7') + 20: keyimg := 648;
            byte('8') + 20: keyimg := 649;
            //-----------
          end;
          if keyimg > 0 then begin
            d := FrmMain.WProgUse.Images[keyimg];
            if d <> nil then
              dsurface.Draw(bbx + 145, bby + 8 + m * 37, d.ClientRect, d, True);
          end;
          d := FrmMain.WProgUse.Images[112]; //lv
          if d <> nil then
            dsurface.Draw(bbx + 48, bby + 8 + 15 + m * 37, d.ClientRect, d, True);
          d := FrmMain.WProgUse.Images[111]; //exp
          if d <> nil then
            dsurface.Draw(bbx + 48 + 26, bby + 8 + 15 + m * 37, d.ClientRect, d, True);
        end;

        with dsurface.Canvas do begin
          SetBkMode(Handle, TRANSPARENT);
          Font.Color := clSilver;
          for i := magtop to magline - 1 do begin
            pm := PTClientMagic(MagicList[i]);
            m  := i - magtop;
            if not (pm.Level in [0..3]) then
              pm.Level := 0;
            TextOut(bbx + 48, bby + 8 + m * 37,
              pm.Def.MagicName);
            if pm.Level in [0..3] then
              trainlv := pm.Level
            else
              trainlv := 0;
            TextOut(bbx + 48 + 16, bby + 8 + 15 + m * 37, IntToStr(pm.Level));
            if pm.Def.MaxTrain[trainlv] > 0 then begin
              if trainlv < 3 then
                TextOut(bbx + 48 + 46, bby + 8 + 15 + m * 37,
                  IntToStr(pm.CurTrain) + '/' + IntToStr(pm.Def.MaxTrain[trainlv]))
              else
                TextOut(bbx + 48 + 46, bby + 8 + 15 + m * 37, '-');
            end;
          end;
          Release;
        end;
      end;
    end;
    if MouseStateItem.S.Name <> '' then begin
      MouseItem := MouseStateItem;
      GetMouseItemInfo(iname, d1, d2, d3, d4, useable, True);
      if iname <> '' then begin
        if MouseItem.Dura = 0 then
          hcolor := clRed
        //            else if MouseItem.UpgradeOpt > 0 then hcolor := clAqua  //$0C36E9 //@@@@@
        else if MouseItem.UpgradeOpt > 0 then
          hcolor := TColor($cccc33)
        else
          hcolor := clWhite;
        // 2003/03/15 아이템 인벤토리 확장
            {
            with dsurface.Canvas do begin
               SetBkMode (Handle, TRANSPARENT);
               old := Font.Size;
               Font.Size := 8;
               Font.Color := clYellow;
               TextOut (SurfaceX(Left+37), SurfaceY(Top+272), iname);
               Font.Color := hcolor;
               TextOut (SurfaceX(Left+37+TextWidth(iname)), SurfaceY(Top+272), d1);
               TextOut (SurfaceX(Left+37), SurfaceY(Top+272+TextHeight('A')+2), d2);
               TextOut (SurfaceX(Left+37), SurfaceY(Top+272+(TextHeight('A')+2)*2), d3);
               Font.Size := old;
               Release;
            end;
            }
        // 2003/03/15 아이템 인벤토리 확장
        Str := iname + d1 + '\' + d2 + '\' + d3 + d4;
        DScreen.ShowHint(MouseX, MouseY, Str, hcolor, False);

      end;
      MouseItem.S.Name := '';
    end;

    //이름
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := Myself.NameColor;
      TextOut(SurfaceX(Left + 122 - TextWidth(FrmMain.CharName) div 2),
        SurfaceY(Top + 23), Myself.UserName);
      if StatePage = 0 then begin
        Font.Color := clSilver;
        TextOut(SurfaceX(Left + 45), SurfaceY(Top + 55),
          GuildName + ' ' + GuildRankName);
      end;
      tx := 122 - TextWidth(Myself.UserName) div 2; // tx assign fix 27/04/2008
      Release;
    end;
  end;
  DHeartImg.Left := tx - 14;
  DHeartImg.Top  := 24;
end;

procedure TFrmDlg.DSWLightDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  idx: integer;
  d:   TDirectDrawSurface;
begin
  if StatePage = 0 then begin
    if Sender = DSWNecklace then begin
      if UseItems[U_NECKLACE].S.Name <> '' then begin
        idx := UseItems[U_NECKLACE].S.Looks;
        if idx >= 0 then begin
          d := FrmMain.WStateItem.Images[idx];
          if d <> nil then
            dsurface.Draw(DSWNecklace.SurfaceX(DSWNecklace.Left +
              (DSWNecklace.Width - d.Width) div 2),
              DSWNecklace.SurfaceY(DSWNecklace.Top +
              (DSWNecklace.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    if Sender = DSWLight then begin
      if UseItems[U_RIGHTHAND].S.Name <> '' then begin
        idx := UseItems[U_RIGHTHAND].S.Looks;
        if idx >= 0 then begin
          d := FrmMain.WStateItem.Images[idx];
          if d <> nil then
            dsurface.Draw(DSWLight.SurfaceX(DSWLight.Left +
              (DSWLight.Width - d.Width) div 2),
              DSWLight.SurfaceY(DSWLight.Top +
              (DSWLight.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    if Sender = DSWArmRingR then begin
      if UseItems[U_ARMRINGR].S.Name <> '' then begin
        idx := UseItems[U_ARMRINGR].S.Looks;
        if idx >= 0 then begin
          d := FrmMain.WStateItem.Images[idx];
          if d <> nil then
            dsurface.Draw(DSWArmRingR.SurfaceX(DSWArmRingR.Left +
              (DSWArmRingR.Width - d.Width) div 2),
              DSWArmRingR.SurfaceY(DSWArmRingR.Top +
              (DSWArmRingR.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    if Sender = DSWArmRingL then begin
      if UseItems[U_ARMRINGL].S.Name <> '' then begin
        idx := UseItems[U_ARMRINGL].S.Looks;
        if idx >= 0 then begin
          d := FrmMain.WStateItem.Images[idx];
          if d <> nil then
            dsurface.Draw(DSWArmRingL.SurfaceX(DSWArmRingL.Left +
              (DSWArmRingL.Width - d.Width) div 2),
              DSWArmRingL.SurfaceY(DSWArmRingL.Top +
              (DSWArmRingL.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    if Sender = DSWRingR then begin
      if UseItems[U_RINGR].S.Name <> '' then begin
        idx := UseItems[U_RINGR].S.Looks;
        if idx >= 0 then begin
          d := FrmMain.WStateItem.Images[idx];
          if d <> nil then
            dsurface.Draw(DSWRingR.SurfaceX(DSWRingR.Left +
              (DSWRingR.Width - d.Width) div 2),
              DSWRingR.SurfaceY(DSWRingR.Top +
              (DSWRingR.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    if Sender = DSWRingL then begin
      if UseItems[U_RINGL].S.Name <> '' then begin
        idx := UseItems[U_RINGL].S.Looks;
        if idx >= 0 then begin
          d := FrmMain.WStateItem.Images[idx];
          if d <> nil then
            dsurface.Draw(DSWRingL.SurfaceX(DSWRingL.Left +
              (DSWRingL.Width - d.Width) div 2),
              DSWRingL.SurfaceY(DSWRingL.Top +
              (DSWRingL.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    // 2003/03/15 아이템 인벤토리 확장
    if Sender = DSWBujuk then begin
      if UseItems[U_BUJUK].S.Name <> '' then begin
        idx := UseItems[U_BUJUK].S.Looks;
        if idx >= 0 then begin
          d := FrmMain.WStateItem.Images[idx];
          if d <> nil then
            dsurface.Draw(DSWBujuk.SurfaceX(DSWBujuk.Left +
              (DSWBujuk.Width - d.Width) div 2) + 1,
              DSWBujuk.SurfaceY(DSWBujuk.Top +
              (DSWBujuk.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    if Sender = DSWBelt then begin
      if UseItems[U_BELT].S.Name <> '' then begin
        idx := UseItems[U_BELT].S.Looks;
        if idx >= 0 then begin
          d := FrmMain.WStateItem.Images[idx];
          if d <> nil then
            dsurface.Draw(DSWBelt.SurfaceX(DSWBelt.Left +
              (DSWBelt.Width - d.Width) div 2) + 1,
              DSWBelt.SurfaceY(DSWBelt.Top + (DSWBelt.Height -
              d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    if Sender = DSWBoots then begin
      if UseItems[U_BOOTS].S.Name <> '' then begin
        idx := UseItems[U_BOOTS].S.Looks;
        if idx >= 0 then begin
          d := FrmMain.WStateItem.Images[idx];
          if d <> nil then
            dsurface.Draw(DSWBoots.SurfaceX(DSWBoots.Left +
              (DSWBoots.Width - d.Width) div 2 + 1),
              DSWBoots.SurfaceY(DSWBoots.Top +
              (DSWBoots.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;
    if Sender = DSWCharm then begin
      if UseItems[U_CHARM].S.Name <> '' then begin
        idx := UseItems[U_CHARM].S.Looks;
        if idx >= 0 then begin
          d := FrmMain.WStateItem.Images[idx];
          if d <> nil then
            dsurface.Draw(DSWCharm.SurfaceX(DSWCharm.Left +
              (DSWCharm.Width - d.Width) div 2 + 1),
              DSWCharm.SurfaceY(DSWCharm.Top +
              (DSWCharm.Height - d.Height) div 2),
              d.ClientRect, d, True);
        end;
      end;
    end;

  end;
end;

procedure TFrmDlg.DStateWinClick(Sender: TObject; X, Y: integer);
begin
  if StatePage = 3 then begin
    X := DStateWin.LocalX(X) - DStateWin.Left;
    Y := DStateWin.LocalY(Y) - DStateWin.Top;
    if (X >= 33) and (X <= 33 + 166) and (Y >= 55) and (Y <= 55 + 37 * 5) then begin
      magcur := (Y - 55) div 37;
      if (magcur + magtop) >= MagicList.Count then
        magcur := (MagicList.Count - 1) - magtop;
    end;
  end;
end;

procedure TFrmDlg.DCloseStateClick(Sender: TObject; X, Y: integer);
begin
  DStateWin.Visible := False;
end;

procedure TFrmDlg.DPrevStateDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if TDButton(Sender).Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.PageChanged;
begin
  case StatePage of
    3: begin //마법 상태창
      DStMag1.Visible := True;
      DStMag2.Visible := True;
      DStMag3.Visible := True;
      DStMag4.Visible := True;
      DStMag5.Visible := True;
      DStPageUp.Visible := True;
      DStPageDown.Visible := True;
      MagicPage := 0;
    end;
    else begin
      DStMag1.Visible     := False;
      DStMag2.Visible     := False;
      DStMag3.Visible     := False;
      DStMag4.Visible     := False;
      DStMag5.Visible     := False;
      DStPageUp.Visible   := False;
      DStPageDown.Visible := False;
    end;
  end;
  DScreen.ClearHint;
end;

procedure TFrmDlg.DPrevStateClick(Sender: TObject; X, Y: integer);
begin
  Dec(StatePage);
  if StatePage < 0 then
    StatePage := MAXSTATEPAGE - 1;
  PageChanged;
end;

procedure TFrmDlg.DNextStateClick(Sender: TObject; X, Y: integer);
begin
  Inc(StatePage);
  if StatePage > MAXSTATEPAGE - 1 then
    StatePage := 0;
  PageChanged;
end;

procedure TFrmDlg.DSWWeaponClick(Sender: TObject; X, Y: integer);
var
  where, n, sel:   integer;
  flag, movcancel: boolean;
begin
  if Myself = nil then
    exit;
  if StatePage <> 0 then
    exit;
  if ItemMoving then begin
    flag      := False;
    movcancel := False;
    if (MovingItem.Index = -97) or (MovingItem.Index = -98) then
      exit;
    if (MovingItem.Item.S.Name = '') or (WaitingUseItem.Item.S.Name <> '') then
      exit;
    where := GetTakeOnPosition(MovingItem.Item.S.StdMode);
    if MovingItem.Index >= 0 then begin
      case where of
        U_DRESS: begin
          if Sender = DSWDress then begin
            if Myself.Sex = 0 then //남자
              if MovingItem.Item.S.StdMode <> 10 then //남자옷
                exit;
            if Myself.Sex = 1 then //여자
              if MovingItem.Item.S.StdMode <> 11 then //여자옷
                exit;
            flag := True;
          end;
        end;
        U_WEAPON: begin
          if Sender = DSWWEAPON then begin;
            flag := True;
          end;
        end;
        U_NECKLACE: begin
          if Sender = DSWNecklace then
            flag := True;
        end;
        U_RIGHTHAND: begin
          if Sender = DSWLight then
            flag := True;
        end;
        U_HELMET: begin
          if Sender = DSWHelmet then
            flag := True;
        end;
        U_RINGR, U_RINGL: begin
          if Sender = DSWRingL then begin
            where := U_RINGL;
            flag  := True;
          end;
          if Sender = DSWRingR then begin
            where := U_RINGR;
            flag  := True;
          end;
        end;
        U_ARMRINGR: begin  //팔찌
          if Sender = DSWArmRingL then begin
            where := U_ARMRINGL;
            flag  := True;
          end;
          if Sender = DSWArmRingR then begin
            where := U_ARMRINGR;
            flag  := True;
          end;
        end;
        U_ARMRINGL: begin  //  팔찌
          if Sender = DSWArmRingL then begin
            where := U_ARMRINGL;
            flag  := True;
          end;
        end;
        // 2003/03/15 COPARK 아이템 인벤토리 확장
        U_BUJUK: begin       //부적, 독가루
          if Sender = DSWBujuk then begin
            where := U_BUJUK;
            flag  := True;
          end;
          if Sender = DSWArmRingL then begin
            where := U_ARMRINGL;
            flag  := True;
          end;
        end;
        U_BELT: begin  //벨트
          if Sender = DSWBelt then begin
            where := U_BELT;
            flag  := True;
          end;
        end;
        U_BOOTS: begin  //신발
          if Sender = DSWBoots then begin
            where := U_BOOTS;
            flag  := True;
          end;
        end;
        U_CHARM: begin  //수호석
          if Sender = DSWCharm then begin
            where := U_CHARM;
            flag  := True;
          end;
        end;

      end;
    end else begin
      n := -(MovingItem.Index + 1);
      // 2003/03/15 COPARK 아이템 인벤토리 확장
      if n in [0..12] then begin            // 8->12
        ItemClickSound(MovingItem.Item.S);
        UseItems[n] := MovingItem.Item;
        MovingItem.Item.S.Name := '';
        ItemMoving  := False;
      end;
    end;
    if flag then begin
      ItemClickSound(MovingItem.Item.S);
      WaitingUseItem := MovingItem;
      WaitingUseItem.Index := where;

      FrmMain.SendTakeOnItem(where, MovingItem.Item.MakeIndex,
        MovingItem.Item.S.Name);
      MovingItem.Item.S.Name := '';
      ItemMoving := False;
    end;
  end else begin
    flag := False;
    if (MovingItem.Item.S.Name <> '') or (WaitingUseItem.Item.S.Name <> '') then
      exit;
    sel := -1;
    if Sender = DSWDress then
      sel := U_DRESS;
    if Sender = DSWWeapon then
      sel := U_WEAPON;
    if Sender = DSWHelmet then
      sel := U_HELMET;
    if Sender = DSWNecklace then
      sel := U_NECKLACE;
    if Sender = DSWLight then
      sel := U_RIGHTHAND;
    if Sender = DSWRingL then
      sel := U_RINGL;
    if Sender = DSWRingR then
      sel := U_RINGR;
    if Sender = DSWArmRingL then
      sel := U_ARMRINGL;
    if Sender = DSWArmRingR then
      sel := U_ARMRINGR;
    // 2003/03/15 아이템 인벤토리 확장
    if Sender = DSWBujuk then
      sel := U_BUJUK;
    if Sender = DSWBelt then
      sel := U_BELT;
    if Sender = DSWBoots then
      sel := U_BOOTS;
    if Sender = DSWCharm then
      sel := U_CHARM;

    if sel >= 0 then begin
      if UseItems[sel].S.Name <> '' then begin
        ItemClickSound(UseItems[sel].S);
        MovingItem.Index := -(sel + 1);
        MovingItem.Item := UseItems[sel];
        UseItems[sel].S.Name := '';
        ItemMoving := True;
      end;
    end;
  end;
end;

procedure TFrmDlg.DSWWeaponMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  sel:     integer;
  iname, d1, d2, d3: string;
  useable: boolean;
  hcolor:  TColor;
begin
  if StatePage <> 0 then
    exit;
  //DScreen.ClearHint;
  sel := -1;
  if Sender = DSWDress then
    sel := U_DRESS;
  if Sender = DSWWeapon then
    sel := U_WEAPON;
  if Sender = DSWHelmet then
    sel := U_HELMET;
  if Sender = DSWNecklace then
    sel := U_NECKLACE;
  if Sender = DSWLight then
    sel := U_RIGHTHAND;
  if Sender = DSWRingL then
    sel := U_RINGL;
  if Sender = DSWRingR then
    sel := U_RINGR;
  if Sender = DSWArmRingL then
    sel := U_ARMRINGL;
  if Sender = DSWArmRingR then
    sel := U_ARMRINGR;
  // 2003/03/15 아이템 인벤토리 확장
  if Sender = DSWBujuk then
    sel := U_BUJUK;
  if Sender = DSWBelt then
    sel := U_BELT;
  if Sender = DSWBoots then
    sel := U_BOOTS;
  if Sender = DSWCharm then
    sel := U_CHARM;

  if sel >= 0 then begin
    MouseStateItem := UseItems[sel];
    // 2003/03/15 아이템 인벤토리 확장
    MouseX := DStateWin.Left + X;
    MouseY := DStateWin.Top + Y;
      {MouseItem := UseItems[sel];
      GetMouseItemInfo (iname, d1, d2, d3, useable);
      if iname <> '' then begin
         if UseItems[sel].Dura = 0 then hcolor := clRed
         else hcolor := clSilver;
         with Sender as TDButton do
            DScreen.ShowHint (SurfaceX(Left - 30),
                              SurfaceY(Top + 50),
                              iname + d1 + '\' + d2 + '\' + d3 + d4, hcolor, FALSE);
      end;
      MouseItem.S.Name := '';}
  end;
end;

procedure TFrmDlg.DStateWinMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  //DScreen.ClearHint;
  MouseStateItem.S.Name := '';
end;


//상태창 : 마법 페이지

procedure TFrmDlg.DStMag1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  idx, icon: integer;
  d:  TDirectDrawSurface;
  pm: PTClientMagic;
begin
  with Sender as TDButton do begin
    idx := _Max(Tag + MagicPage * 5, 0);
    if idx < MagicList.Count then begin
      pm   := PTClientMagic(MagicList[idx]);
      icon := pm.Def.Effect * 2;
      if icon >= 0 then begin //아이콘이 없는거..
        if not Downed then begin
          d := FrmMain.WMagIcon.Images[icon];
          if d <> nil then
            dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
        end else begin
          d := FrmMain.WMagIcon.Images[icon + 1];
          if d <> nil then
            dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DStMag1Click(Sender: TObject; X, Y: integer);
var
  i, idx: integer;
  selkey: word;
  keych:  char;
  pm:     PTClientMagic;
begin
  if StatePage = 3 then begin
    idx := TDButton(Sender).Tag + magtop;
    if (idx >= 0) and (idx < MagicList.Count) then begin

      pm     := PTClientMagic(MagicList[idx]);
      selkey := word(pm.Key);
      SetMagicKeyDlg(pm.Def.Effect * 2, pm.Def.MagicName, selkey);
      keych := char(selkey);

      for i := 0 to MagicList.Count - 1 do begin
        pm := PTClientMagic(MagicList[i]);
        if pm.Key = keych then begin
          pm.Key := #0;
          FrmMain.SendMagicKeyChange(pm.Def.MagicId, #0);
        end;
      end;
      pm     := PTClientMagic(MagicList[idx]);
      //if pm.Def.EffectType <> 0 then begin //검법은 키설정을 못함.
      pm.Key := keych;
      FrmMain.SendMagicKeyChange(pm.Def.MagicId, keych);
      //end;
    end;
  end;
end;

procedure TFrmDlg.DStPageUpClick(Sender: TObject; X, Y: integer);
begin
  if Sender = DStPageUp then begin
    if MagicPage > 0 then
      Dec(MagicPage);
  end else begin
    if MagicPage < (MagicList.Count + 4) div 5 - 1 then
      Inc(MagicPage);
  end;
end;




{------------------------------------------------------------------------}

//바닥 상태

{------------------------------------------------------------------------}


procedure TFrmDlg.DBottomDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d:  TDirectDrawSurface;
  rc: TRect;
  btop, sx, sy, i, fcolor, bcolor: integer;
  r:  real;
  s:  string;
begin
  d := FrmMain.WProgUse.Images[BOTTOMBOARD];
  if d <> nil then
    dsurface.Draw(DBottom.Left, DBottom.Top, d.ClientRect, d, True);
  btop := 0;
  if d <> nil then begin
    with d.ClientRect do
      rc := Rect(Left, Top, Right, Top + 120);
    btop := SCREENHEIGHT - d.Height;
    dsurface.Draw(0,
      btop,
      rc,
      d, True);
    with d.ClientRect do
      rc := Rect(Left, Top + 120, Right, Bottom);
    dsurface.Draw(0,
      btop + 120,
      rc,
      d, False);
  end;
  //시간(새벽,낮,저녁,밤)
  d := nil;
  case DayBright of
    0: d := FrmMain.WProgUse.Images[15];  //새벽
    1: d := FrmMain.WProgUse.Images[12];  //낮
    2: d := FrmMain.WProgUse.Images[13];  //저녁
    3: d := FrmMain.WProgUse.Images[14];  //밤
  end;
  if d <> nil then
    dsurface.Draw (SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (380 - 346)){748}, 97+DBottom.Top, d.ClientRect, d, TRUE);

  if Myself <> nil then begin
    //체력 마력 표시
    if (Myself.Abil.MaxHP > 0) and (Myself.Abil.MaxMP > 0) then begin
      if (Myself.Job = 0) and (Myself.Abil.Level < 26) then begin //전사
        d := FrmMain.WProgUse.Images[5];
        if d <> nil then begin
          rc := d.ClientRect;
          rc.Right := d.ClientRect.Right - 2;
          dsurface.Draw(45, btop + 62, rc, d, False);
        end;
        d := FrmMain.WProgUse.Images[6];
        if d <> nil then begin
          rc     := d.ClientRect;
          rc.Right := d.ClientRect.Right - 2;
          rc.Top := Round(rc.Bottom / Myself.Abil.MaxHP *
            (Myself.Abil.MaxHP - Myself.Abil.HP));
          dsurface.Draw(45, btop + 62 + rc.Top, rc, d, False);
        end;
      end else begin
        d := FrmMain.WProgUse.Images[4];
        if d <> nil then begin
          //체력 표시 -술도사
          rc     := d.ClientRect;
          rc.Right := d.ClientRect.Right div 2 - 1;
          rc.Top := Round(rc.Bottom / Myself.Abil.MaxHP *
            (Myself.Abil.MaxHP - Myself.Abil.HP));
          dsurface.Draw(45, btop + 62 + rc.Top, rc, d, False);
          //마력 표시 -술도사
          rc      := d.ClientRect;
          rc.Left := d.ClientRect.Right div 2 + 1;
          rc.Right := d.ClientRect.Right - 1;
          rc.Top  := Round(rc.Bottom / Myself.Abil.MaxMP *
            (Myself.Abil.MaxMP - Myself.Abil.MP));
          dsurface.Draw(45 + rc.Left, btop + 62 + rc.Top, rc, d, False);
        end;
      end;
    end;

    //레벨 표시
    with dsurface.Canvas do begin
      PomiTextOut (dsurface, SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (382 - 260)){660}, SCREENHEIGHT - 88, IntToStr(Myself.Abil.Level));
    end;
    //경험치, 무게 표시
    if (Myself.Abil.MaxExp > 0) and (Myself.Abil.MaxWeight > 0) then begin
      d := FrmMain.WProgUse.Images[7];
      if d <> nil then begin
        //경험치
        rc := d.ClientRect;
        if Myself.Abil.Exp > 0 then
          r := Myself.Abil.MaxExp / Myself.Abil.Exp
        else
          r := 0;
        if r > 0 then
          rc.Right := Round(rc.Right / r)
        else
          rc.Right := 0;
        dsurface.Draw (SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (402 - 266)){666}, SCREENHEIGHT - 54, rc, d, FALSE);
        //PomiTextOut (dsurface, 660, 528, IntToStr(Myself.Abil.Exp));
        //무게
        rc := d.ClientRect;
        if Myself.Abil.Weight > 0 then
          r := Myself.Abil.MaxWeight / Myself.Abil.Weight
        else
          r := 0;
        if r > 0 then
          rc.Right := Round(rc.Right / r)
        else
          rc.Right := 0;
        dsurface.Draw (SCREENWIDTH div 2 + (SCREENWIDTH div 2 - (379 - 266)){666}, SCREENHEIGHT - 23, rc, d, FALSE);
        //PomiTextOut (dsurface, 660, 561, IntToStr(Myself.Abil.Weight));
      end;
    end;
    //배고품 표시
      { 2003/04/15 쪽지로 대체
      if MyHungryState in [1..4] then begin
         d := FrmMain.WProgUse.Images[16 + MyHungryState-1];
         if d <> nil then begin
            dsurface.Draw (754, 553, d.ClientRect, d, TRUE);
         end;
      end;
      }

  end;
  //@@@@@
  SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
  s := 'HP(' + IntToStr(Myself.Abil.HP) + '/' + IntToStr(Myself.Abil.MaxHP) + ')';

  dsurface.Canvas.Font.Color := clBlack;
  dsurface.Canvas.TextOut(48 - 1, 473 + 10, s);
  dsurface.Canvas.TextOut(48 + 1, 473 + 10, s);
  dsurface.Canvas.TextOut(48, 473 - 1 + 10, s);
  dsurface.Canvas.TextOut(48, 473 + 1 + 10, s);

  dsurface.Canvas.Font.Color := clWhite;
  dsurface.Canvas.TextOut(48, 473 + 10, s);
  if (Myself.Job <> 0) or (Myself.Abil.Level >= 26) then begin
    s := 'MP(' + IntToStr(Myself.Abil.MP) + '/' + IntToStr(Myself.Abil.MaxMP) + ')';

    dsurface.Canvas.Font.Color := clBlack;
    dsurface.Canvas.TextOut(48 - 1, 487 + 10, s);
    dsurface.Canvas.TextOut(48 + 1, 487 + 10, s);
    dsurface.Canvas.TextOut(48, 487 - 1 + 10, s);
    dsurface.Canvas.TextOut(48, 487 + 1 + 10, s);

    dsurface.Canvas.Font.Color := clWhite;
    dsurface.Canvas.TextOut(48, 487 + 10, s);
  end;

  //   DScreen.ShowHint(48, 473, s, clYellow, FALSE);

  sx := 208;
  sy := SCREENHEIGHT - 130;
  with DScreen do begin
    SetBkMode(dsurface.Canvas.Handle, OPAQUE);
    for i := ChatBoardTop to ChatBoardTop + VIEWCHATLINE - 1 do begin
      if i > ChatStrs.Count - 1 then
        break;
      fcolor := integer(ChatStrs.Objects[i]);
      bcolor := integer(ChatBks[i]);
      dsurface.Canvas.Font.Color := fcolor;
      dsurface.Canvas.Brush.Color := bcolor;
      dsurface.Canvas.TextOut(sx, sy + (i - ChatBoardTop) * 12, ChatStrs.Strings[i]);
    end;
  end;
  dsurface.Canvas.Release;

end;




 {--------------------------------------------------------------}
 //바닥 상태바의 4개 버튼


procedure TFrmDlg.DBottomInRealArea(Sender: TObject; X, Y: integer;
  var IsRealArea: boolean);
var
  d: TDirectDrawSurface;
begin
  d := FrmMain.WProgUse.Images[BOTTOMBOARD];
  if d <> nil then begin
    if d.Pixels[X, Y] > 0 then
      IsRealArea := True
    else
      IsRealArea := False;
  end;
end;

procedure TFrmDlg.DMyStateDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d:  TDButton;
  dd: TDirectDrawSurface;
begin
  if Sender is TDButton then begin
    d := TDButton(Sender);
    if d.Downed then begin
      dd := d.WLib.Images[d.FaceIndex];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top),
          dd.ClientRect, dd, True);
    end;
  end;
end;

//그룹, 교환, 맵 버튼
procedure TFrmDlg.DBotGroupDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d:  TDButton;
  dd: TDirectDrawSurface;
begin
  if Sender is TDButton then begin
    d := TDButton(Sender);
    if not d.Downed then begin
      dd := d.WLib.Images[d.FaceIndex];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top),
          dd.ClientRect, dd, True);
    end else begin
      dd := d.WLib.Images[d.FaceIndex + 1];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top),
          dd.ClientRect, dd, True);
    end;
  end;
end;

procedure TFrmDlg.DBotPlusAbilDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d:  TDButton;
  dd: TDirectDrawSurface;
begin
  if Sender is TDButton then begin
    d := TDButton(Sender);
    if not d.Downed then begin
      if (BlinkCount mod 2 = 0) and (not DAdjustAbility.Visible) then
        dd := d.WLib.Images[d.FaceIndex]
      else
        dd := d.WLib.Images[d.FaceIndex + 2];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top),
          dd.ClientRect, dd, True);
    end else begin
      dd := d.WLib.Images[d.FaceIndex + 1];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top),
          dd.ClientRect, dd, True);
    end;

    if GetTickCount - BlinkTime >= 500 then begin
      BlinkTime := GetTickCount;
      Inc(BlinkCount);
      if BlinkCount >= 10 then
        BlinkCount := 0;
    end;
  end;
end;



procedure TFrmDlg.DMyStateClick(Sender: TObject; X, Y: integer);
begin
  if Sender = DMyState then begin
    StatePage := 0;
    OpenMyStatus;
  end;
  if Sender = DMyBag then
    OpenItemBag;
  if Sender = DMyMagic then begin
    StatePage := 3;
    OpenMyStatus;
  end;
  if Sender = DOption then begin
    TogglePlaySoundEffect;
  end;
end;

procedure TFrmDlg.DOptionClick(Sender: TObject);
begin
end;




{------------------------------------------------------------------------}

// 벨트

{------------------------------------------------------------------------}


procedure TFrmDlg.DBelt1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  idx: integer;
  d:   TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    idx := Tag;
    if idx in [0..5] then begin
      if ItemArr[idx].S.Name <> '' then begin
        d := FrmMain.WBagItem.Images[ItemArr[idx].S.Looks];
        if d <> nil then
          dsurface.Draw(SurfaceX(Left + (Width - d.Width) div 2),
            SurfaceY(Top + (Height - d.Height) div 2), d.ClientRect, d, True);
      end;
    end;
    PomiTextOut(dsurface, SurfaceX(Left + 13), SurfaceY(Top + 19), IntToStr(idx + 1));
  end;
end;

procedure TFrmDlg.DBelt1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  idx: integer;
begin
  idx := TDButton(Sender).Tag;
  if idx in [0..5] then begin
    if ItemArr[idx].S.Name <> '' then begin
      MouseItem := ItemArr[idx];
    end;
  end;
end;

procedure TFrmDlg.DBelt1Click(Sender: TObject; X, Y: integer);
var
  idx:  integer;
  temp: TClientItem;
begin
  idx := TDButton(Sender).Tag;
  if idx in [0..5] then begin
    if not ItemMoving then begin
      if ItemArr[idx].S.Name <> '' then begin
        ItemClickSound(ItemArr[idx].S);
        ItemMoving      := True;
        MovingItem.Index := idx;
        MovingItem.Item := ItemArr[idx];
        ItemArr[idx].S.Name := '';
      end;
    end else begin
      if (MovingItem.Index = -97) or (MovingItem.Index = -98) then
        exit;
      if MovingItem.Item.S.StdMode <= 3 then begin //포션,음식,스크롤
        //ItemClickSound (MovingItem.Item.S.StdMode);
        if ItemArr[idx].S.Name <> '' then begin
          temp := ItemArr[idx];
          ItemArr[idx] := MovingItem.Item;
          MovingItem.Index := idx;
          MovingItem.Item := temp;
        end else begin
          ItemArr[idx] := MovingItem.Item;
          MovingItem.Item.S.Name := '';
          ItemMoving   := False;
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.DBelt1DblClick(Sender: TObject);
var
  idx: integer;
begin
  idx := TDButton(Sender).Tag;
  if idx in [0..5] then begin
    if ItemArr[idx].S.Name <> '' then begin
      if (ItemArr[idx].S.StdMode <= 4) or (ItemArr[idx].S.StdMode = 31) then
      begin //사용할 수 있는 아이템
        FrmMain.EatItem(idx);
      end;
    end else begin
      if ItemMoving and (MovingItem.Index = idx) and
        (MovingItem.Item.S.StdMode <= 4) or (MovingItem.Item.S.StdMode = 31) then
      begin
        FrmMain.EatItem(-1);
      end;
    end;
  end;
end;




{----------------------------------------------------------}

//아이템 가방

{----------------------------------------------------------}



procedure TFrmDlg.GetMouseItemInfo(var iname, line1, line2, line3, line4: string;
  var useable: boolean; bowear: boolean);

  function GetDuraStr(dura, maxdura: integer): string;
  begin
    if not BoNoDisplayMaxDura then
      Result := IntToStr(Round(dura / 1000)) + '/' + IntToStr(Round(maxdura / 1000))
    else
      Result := IntToStr(Round(dura / 1000));
  end;

  function GetDura100Str(dura, maxdura: integer): string;
  begin
    if not BoNoDisplayMaxDura then
      Result := IntToStr(Round(dura / 100)) + '/' + IntToStr(Round(maxdura / 100))
    else
      Result := IntToStr(Round(dura / 100));
  end;

begin
  if Myself = nil then
    exit;
  iname   := '';
  line1   := '';
  line2   := '';
  line3   := '';
  useable := True;

  if MouseItem.S.Name <> '' then begin
    iname := MouseItem.S.Name + ' ';
    case MouseItem.S.StdMode of
      0: begin //시약
        if MouseItem.S.AC > 0 then
          line1 := '+' + IntToStr(MouseItem.S.AC) + 'HP ';
        if MouseItem.S.MAC > 0 then
          line1 := line1 + '+' + IntToStr(MouseItem.S.MAC) + 'MP';
        line1 := line1 + ' W.' + IntToStr(MouseItem.S.Weight);
      end;
      1..3: begin
        if MouseItem.S.OverlapItem = 1 then
          line1 := line1 + 'W.' + IntToStr(MouseItem.Dura div 10) +
            ' Count' + IntToStr(MouseItem.Dura)
        else if MouseItem.S.OverlapItem = 2 then
          line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight *
            MouseItem.Dura) + ' Count' + IntToStr(MouseItem.Dura)
        else
          line1 := line1 + 'W. ' + IntToStr(MouseItem.S.Weight);
      end;
      4: begin
        line1   := line1 + 'W. ' + IntToStr(MouseItem.S.Weight);
        useable := False;
        case MouseItem.S.Shape of
          0: begin
            line2 := 'Secret martial art skill of Warrior ';
            line4 := 'Necessary level  ' + IntToStr(MouseItem.S.DuraMax);
            if (Myself.Job = 0) and (Myself.Abil.Level >=
              MouseItem.S.DuraMax) then
              useable := True;
          end;
          1: begin
            line2 := 'Spellbook of wizard';
            line4 := 'Necessary level  ' + IntToStr(MouseItem.S.DuraMax);
            if (Myself.Job = 1) and (Myself.Abil.Level >=
              MouseItem.S.DuraMax) then
              useable := True;
          end;
          2: begin
            line2 := 'Secret martial art skill of Taoist';
            line4 := 'Necessary level  ' + IntToStr(MouseItem.S.DuraMax);
            if (Myself.Job = 2) and (Myself.Abil.Level >=
              MouseItem.S.DuraMax) then
              useable := True;
          end;
          3: begin
            line2 := 'Secret martial art skill of Assassin';
            line4 := 'Necessary level  ' + IntToStr(MouseItem.S.DuraMax);
            if (Myself.Job = 3) and (Myself.Abil.Level >=
              MouseItem.S.DuraMax) then
              useable := True;
          end;
        end;
      end;
      5..6: //무기
      begin
        useable := False;
        if MouseItem.S.ItemDesc and $01 <> 0 then  //아이덴티피아 안 된 것임
          iname := '(*)' + iname;

        line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight) +
          ' Dura' + GetDuraStr(MouseItem.Dura, MouseItem.DuraMax);
        if MouseItem.S.DC > 0 then
          line2 := 'DC' + IntToStr(Lobyte(MouseItem.S.DC)) + '-' +
            IntToStr(Hibyte(MouseItem.S.DC)) + ' ';
        if MouseItem.S.MC > 0 then
          line2 := line2 + 'MC' + IntToStr(Lobyte(MouseItem.S.MC)) +
            '-' + IntToStr(Hibyte(MouseItem.S.MC)) + ' ';
        if MouseItem.S.SC > 0 then
          line2 := line2 + 'SC' + IntToStr(Lobyte(MouseItem.S.SC)) +
            '-' + IntToStr(Hibyte(MouseItem.S.SC)) + ' ';
        if MouseItem.S.SpecialPwr in [1..10] then  //무기의 강도
          line2 := line2 + 'Inten+' + IntToStr(MouseItem.S.SpecialPwr) + ' ';
        if (MouseItem.S.SpecialPwr <= -1) and (MouseItem.S.SpecialPwr >= -50) then
          line2 := line2 + 'Holy+' + IntToStr(-MouseItem.S.SpecialPwr) + ' ';
        if (MouseItem.S.SpecialPwr <= -51) and
          (MouseItem.S.SpecialPwr >= -100) then
          line2 := line2 + 'Holy-' + IntToStr(
            (-MouseItem.S.SpecialPwr) - 50) + ' ';
        if Hibyte(MouseItem.S.AC) > 0 then
          line2 := line2 + 'Acc+' + IntToStr(Hibyte(MouseItem.S.AC)) + ' ';
        if MouseItem.S.Slowdown > 0 then
          line3 := line3 + 'Slow+' + IntToStr(MouseItem.S.Slowdown) + ' ';
        //==Upgradeitem==
        if MouseItem.S.Tox > 0 then
          line3 := line3 + 'PA+' + IntToStr(MouseItem.S.Tox) + ' ';
        //==Upgradeitem==
        if Hibyte(MouseItem.S.MAC) > 0 then begin
          if Hibyte(MouseItem.S.MAC) > 10 then
            line3 := line3 + 'A.speed+' + IntToStr(
              Hibyte(MouseItem.S.MAC) - 10) + ' '
          else
            line3 := line3 + 'A.speed -' + IntToStr(
              Hibyte(MouseItem.S.MAC)) + ' ';
        end;
        if (MouseItem.S.AC and $80) <> 0 then begin
          line3 := line3 + 'Luck ';
        end;
        if Lobyte(MouseItem.S.AC and $7F) > 0 then
          line3 := line3 + 'Luck+' +
            IntToStr(Lobyte(MouseItem.S.AC and $7F)) + ' ';
        if Lobyte(MouseItem.S.MAC) > 0 then
          line3 := line3 + 'Curse+' + IntToStr(Lobyte(MouseItem.S.MAC)) + ' ';
        if MouseItem.S.Shape in [200, 201, 202, 203, 204, 205, 206, 207, 208, 209] then
        line4 := line4 + 'Assassin ';

        case MouseItem.S.Need of
          0: begin
            if Myself.Abil.Level >= MouseItem.S.NeedLevel then
              useable := True;
            line4 :=
              line4 + 'Necessary Level ' + IntToStr(MouseItem.S.NeedLevel);
          end;
          1: begin
            if hibyte(Myself.Abil.DC) >= MouseItem.S.NeedLevel then
              useable := True;
            line4 :=
              line4 + 'Necessay DC ' + IntToStr(MouseItem.S.NeedLevel);
          end;
          2: begin
            if hibyte(Myself.Abil.MC) >= MouseItem.S.NeedLevel then
              useable := True;
            line4 :=
              line4 + 'Necessary MC ' + IntToStr(MouseItem.S.NeedLevel);
          end;
          3: begin
            if hibyte(Myself.Abil.SC) >= MouseItem.S.NeedLevel then
              useable := True;
            line4 :=
              line4 + 'Necessary SC ' + IntToStr(MouseItem.S.NeedLevel);
          end;
        end;
      end;
      7: begin //노끈
        if MouseItem.S.OverlapItem = 1 then
          line1 := line1 + 'W.' + IntToStr(MouseItem.Dura div 10) +
            ' Count' + IntToStr(MouseItem.Dura)
        else if MouseItem.S.OverlapItem = 2 then
          line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight *
            MouseItem.Dura) + ' Count' + IntToStr(MouseItem.Dura)
        else
          line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight);
        line2 := 'Press Ctrl key to choose items to bind.';
      end;
      8: begin
        case MouseItem.S.Shape of
          0: begin //초대장
            line1 :=
              line1 + 'Guild Territory No.' + IntToStr(MouseItem.Dura) +
              ' W.' + IntToStr(MouseItem.S.Weight);
            line2 := 'The ticket is valid for 24 hours';
          end;
          1: begin //왕방이동 마패
            line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight);
            line2 := 'You feel the force that will move you around';
            line3 := 'beyond the space and time.';
          end;
          else   //선물상자 황금달걀
            line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight);
            //선물상자 황금달걀
        end;
      end;
      9: begin //상현주머니
        //               line1 := DecoItemDesc( MouseItem.Dura);
        //               line1 := line1 + ' W.' +  IntToStr(MouseItem.S.Weight)
        //                                        + ' Dura'+ IntToStr(Round(MouseItem.DuraMax/1000));
        line1 := 'W.' + IntToStr(MouseItem.S.Weight) + ' Dura' +
          IntToStr(Round(MouseItem.DuraMax / 1000));
        //                                + ' Dura'+ IntToStr(Trunc(MouseItem.DuraMax/1000));
        line2 := DecoItemDesc(MouseItem.Dura, line3);
      end;
      10, 11:  //남자옷, 여자옷
      begin
        useable := False;
        line1   := line1 + 'W.' + IntToStr(MouseItem.S.Weight) +
          ' Dura' + GetDuraStr(MouseItem.Dura, MouseItem.DuraMax);
        //line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight) +
        //      ' Dura'+ IntToStr(Round(MouseItem.Dura/1000)) + '/' + IntToStr(Round(MouseItem.DuraMax/1000));
        if MouseItem.S.AC > 0 then
          line2 := 'AC' + IntToStr(Lobyte(MouseItem.S.AC)) + '-' +
            IntToStr(Hibyte(MouseItem.S.AC)) + ' ';
        if MouseItem.S.MAC > 0 then
          line2 := line2 + 'AMC' + IntToStr(Lobyte(MouseItem.S.MAC)) +
            '-' + IntToStr(Hibyte(MouseItem.S.MAC)) + ' ';
        if MouseItem.S.DC > 0 then
          line2 := line2 + 'DC' + IntToStr(Lobyte(MouseItem.S.DC)) +
            '-' + IntToStr(Hibyte(MouseItem.S.DC)) + ' ';
        if MouseItem.S.MC > 0 then
          line2 := line2 + 'MC' + IntToStr(Lobyte(MouseItem.S.MC)) +
            '-' + IntToStr(Hibyte(MouseItem.S.MC)) + ' ';
        if MouseItem.S.Agility > 0 then
          line2 := line2 + 'Agil+' + IntToStr(MouseItem.S.Agility) + ' ';
        // ==Upgradeitem==
        if MouseItem.S.SC > 0 then
          line2 := line2 + 'SC' + IntToStr(Lobyte(MouseItem.S.SC)) +
            '-' + IntToStr(Hibyte(MouseItem.S.SC)) + ' ';

        if MouseItem.S.HpAdd > 0 then
          line3 := line3 + 'HP+' + IntToStr(MouseItem.S.HpAdd) + ' ';
        if MouseItem.S.MpAdd > 0 then
          line3 := line3 + 'MP+' + IntToStr(MouseItem.S.MpAdd) + ' ';
        if MouseItem.S.EffType1 = 3 then
          line3 := line3 + 'luck+' + IntToStr(MouseItem.S.EffValue1) + ' ';
        if MouseItem.S.MgAvoid > 0 then
          line3 := line3 + 'MR+' + IntToStr(MouseItem.S.MgAvoid) + ' ';
        //==Upgradeitem==
        if MouseItem.S.ToxAvoid > 0 then
          line3 := line3 + 'PR+' + IntToStr(MouseItem.S.ToxAvoid) + ' ';
        //==Upgradeitem==
        if MouseItem.S.Shape in [206, 207, 208, 209, 210, 211] then
        line4 := 'Assassin ';

        case MouseItem.S.EffType1 of
          5: begin
            line3 :=
              line3 + 'HPR+' + IntToStr(MouseItem.S.EffRate1 * 10) + '% ';
            line3 :=
              line3 + 'MPR+' + IntToStr(MouseItem.S.EffValue1 * 10) + '% ';
          end;
        end;
        case MouseItem.S.EffType2 of
          5: begin
            line3 :=
              line3 + 'HPR+' + IntToStr(MouseItem.S.EffRate2 * 10) + '% ';
            line3 :=
              line3 + 'MPR+' + IntToStr(MouseItem.S.EffValue2 * 10) + '% ';
          end;
        end;

        case MouseItem.S.Need of
          0: begin
            if Myself.Abil.Level >= MouseItem.S.NeedLevel then
              useable := True;
            line4 := line4 + 'Necessary level ' + IntToStr(MouseItem.S.NeedLevel);
          end;
          1: begin
            if hibyte(Myself.Abil.DC) >= MouseItem.S.NeedLevel then
              useable := True;
            line4 := line4 + 'Necessay DC ' + IntToStr(MouseItem.S.NeedLevel);
          end;
          2: begin
            if hibyte(Myself.Abil.MC) >= MouseItem.S.NeedLevel then
              useable := True;
            line4 := line4 + 'Necessary MC ' + IntToStr(MouseItem.S.NeedLevel);
          end;
          3: begin
            if hibyte(Myself.Abil.SC) >= MouseItem.S.NeedLevel then
              useable := True;
            line4 := line4 + 'Necessary SC ' + IntToStr(MouseItem.S.NeedLevel);
          end;
        end;
      end;
      15,     //모자,투구
      19, 20, 21,  //목걸이
      22, 23,  //반지
      // 2003/03/15 아이템 인벤토리 확장
      52, 53, 54,
      24, 26:  //팔찌
      begin
        useable := False;
        line1   := line1 + 'W.' + IntToStr(MouseItem.S.Weight);
        if (MouseItem.S.StdMode <> 53) then
          line1 := line1 + ' Dura' + GetDuraStr(MouseItem.Dura,
            MouseItem.DuraMax);
        // 2003/08/25 팔찌 아이템, 신성속성 풍선 도움말 추가.  // AddHolyMent
        if MouseItem.S.StdMode = 15 then begin
          if (MouseItem.S.Accurate > 0) then
            line2 := line2 + 'Acc+' + IntToStr(MouseItem.S.Accurate) + ' ';
          // ==Upgradeitem==
          if MouseItem.S.MgAvoid > 0 then
            line3 := line3 + 'MR+' + IntToStr(MouseItem.S.MgAvoid) + ' ';
          //==Upgradeitem==
          if MouseItem.S.ToxAvoid > 0 then
            line3 := line3 + 'PR+' + IntToStr(MouseItem.S.ToxAvoid) + ' ';
          //==Upgradeitem==
        end;
        if MouseItem.S.StdMode = 26 then begin
          if (MouseItem.S.Accurate > 0) then
            line2 := line2 + 'Acc+' + IntToStr(MouseItem.S.Accurate) + ' ';
          // ==Upgradeitem==
          if MouseItem.S.Agility > 0 then
            line2 := line2 + 'Agil+' + IntToStr(MouseItem.S.Agility) + ' ';
          // ==Upgradeitem==
        end;
        if (MouseItem.S.StdMode = 52) or (MouseItem.S.StdMode = 54) then begin
          //                  if MouseItem.S.AC > 0 then
          //                     line2 := 'AC' + IntToStr(Lobyte(MouseItem.S.AC)) + '-' + IntToStr(Hibyte(MouseItem.S.AC)) + ' ';// ==Upgradeitem==
          //                  if MouseItem.S.MAC > 0 then
          //                     line2 := line2 + 'AMC' + IntToStr(Lobyte(MouseItem.S.MAC)) + '-' + IntToStr(Hibyte(MouseItem.S.MAC)) + ' ';// ==Upgradeitem==
          if MouseItem.S.Agility > 0 then
            line2 := line2 + 'Agil+' + IntToStr(MouseItem.S.Agility) + ' ';
          // ==Upgradeitem==
          if (MouseItem.S.Accurate > 0) then   //2004/01/08
            line2 := line2 + 'Acc+' + IntToStr(MouseItem.S.Accurate) + ' ';
          // ==Upgradeitem==

          if MouseItem.S.StdMode = 54 then begin
            if MouseItem.S.ToxAvoid > 0 then
              line3 := line3 + 'PR+' + IntToStr(MouseItem.S.ToxAvoid) + ' ';
            //==Upgradeitem==
          end;
        end;
        if (MouseItem.S.SpecialPwr <= -1) and (MouseItem.S.SpecialPwr >= -50) then
          line2 := line2 + 'Holy+' + IntToStr(-MouseItem.S.SpecialPwr) + ' ';
        if (MouseItem.S.SpecialPwr <= -51) and
          (MouseItem.S.SpecialPwr >= -100) then
          line2 := line2 + 'Holy-' + IntToStr(
            (-MouseItem.S.SpecialPwr) - 50) + ' ';
        //-----------------

        if ((MouseItem.S.Shape = RING_OF_UNKNOWN) or
          (MouseItem.S.Shape = BRACELET_OF_UNKNOWN) or
          (MouseItem.S.Shape = HELMET_OF_UNKNOWN)) and (not bowear) then begin
          line2 := '????????';
        end else begin
          case MouseItem.S.StdMode of
            19: //목걸이
            begin
              if MouseItem.S.AtkSpd > 0 then
                line2 :=
                  line2 + 'A.speed+' + IntToStr(MouseItem.S.AtkSpd) + ' ';
              if (MouseItem.S.Accurate > 0) then
                line2 :=
                  line2 + 'Acc+' + IntToStr(MouseItem.S.Accurate) + ' ';
              // ==Upgradeitem==
              if MouseItem.S.Slowdown > 0 then
                line2 :=
                  line2 + 'Slow+' + IntToStr(MouseItem.S.Slowdown) + ' ';
              //==Upgradeitem==
              if MouseItem.S.Tox > 0 then
                line2 := line2 + 'PA+' + IntToStr(MouseItem.S.Tox) + ' ';
              //==Upgradeitem==
              //                           if MouseItem.S.MgAvoid > 0 then
              //                              line3 := line3 + 'MR' + IntToStr(MouseItem.S.MgAvoid)+ ' '; //==Upgradeitem==
              if MouseItem.S.AC > 0 then begin
                line3 :=
                  line3 + 'MR+' + IntToStr(Hibyte(MouseItem.S.AC)) + ' ';
              end;
              if Lobyte(MouseItem.S.MAC) > 0 then
                line2 := line2 + '저주+' + IntToStr(Lobyte(MouseItem.S.MAC)) + ' ';
              if Hibyte(MouseItem.S.MAC) > 0 then
                line2 := line2 + 'luck+' + IntToStr(Hibyte(MouseItem.S.MAC)) + ' ';
              //숫자 표시안됨 + IntToStr(Hibyte(MouseItem.S.MAC)) + ' ';
            end;
            20: begin
              if MouseItem.S.AC > 0 then
                line2 :=
                  line2 + 'Acc+' + IntToStr(Hibyte(MouseItem.S.AC)) + ' ';
              if MouseItem.S.MAC > 0 then
                line2 :=
                  line2 + 'Agil+' + IntToStr(Hibyte(MouseItem.S.MAC)) + ' ';
              if MouseItem.S.AtkSpd > 0 then
                line2 :=
                  line2 + 'A.speed+' + IntToStr(MouseItem.S.AtkSpd) + ' ';
              if MouseItem.S.Slowdown > 0 then
                line2 :=
                  line2 + 'Slow+' + IntToStr(MouseItem.S.Slowdown) + ' ';
              //==Upgradeitem==
              if MouseItem.S.Tox > 0 then
                line2 := line2 + 'PA+' + IntToStr(MouseItem.S.Tox) + ' ';
              //==Upgradeitem==
              if MouseItem.S.MgAvoid > 0 then
                line3 :=
                  line3 + 'MR+' + IntToStr(MouseItem.S.MgAvoid) + ' '; //==Upgradeitem==
            end;
            21:  //목걸이
            begin
              if Hibyte(MouseItem.S.AC) > 0 then
                line2 :=
                  line2 + 'HPR+' + IntToStr(Hibyte(MouseItem.S.AC)) + '0% ';
              if Hibyte(MouseItem.S.MAC) > 0 then
                line2 :=
                  line2 + 'MPR+' + IntToStr(Hibyte(MouseItem.S.MAC)) + '0% ';
              if MouseItem.S.Accurate > 0 then
                line2 :=
                  line2 + 'Acc+' + IntToStr(MouseItem.S.Accurate) + ' ';
              //==Upgradeitem==
              if MouseItem.S.Slowdown > 0 then
                line2 :=
                  line2 + 'Slow+' + IntToStr(MouseItem.S.Slowdown) + ' ';
              //==Upgradeitem==
              if MouseItem.S.Tox > 0 then
                line2 := line2 + 'PA+' + IntToStr(MouseItem.S.Tox) + ' ';
              //==Upgradeitem==
              //                           if MouseItem.S.AtkSpd > 0 then
              //                              line3 := line3 + 'A.speed+' + IntToStr(MouseItem.S.AtkSpd ) + ' ';
              if Lobyte(MouseItem.S.AC) + MouseItem.S.AtkSpd > 0 then
                line3 :=
                  line3 + 'A.speed+' + IntToStr(Lobyte(MouseItem.S.AC) +
                  MouseItem.S.AtkSpd) + ' ';
              if Lobyte(MouseItem.S.MAC) > 0 then
                line3 :=
                  line3 + 'A.speed-' + IntToStr(Lobyte(MouseItem.S.MAC)) + ' ';
              if MouseItem.S.MgAvoid > 0 then
                line3 :=
                  line3 + 'MR+' + IntToStr(MouseItem.S.MgAvoid) + ' '; //==Upgradeitem==
            end;
            22: begin
              if MouseItem.S.AC > 0 then
                line2 :=
                  line2 + 'AC' + IntToStr(Lobyte(MouseItem.S.AC)) +
                  '-' + IntToStr(Hibyte(MouseItem.S.AC)) + ' ';
              if MouseItem.S.MAC > 0 then
                line2 :=
                  line2 + 'AMC' + IntToStr(Lobyte(MouseItem.S.MAC)) +
                  '-' + IntToStr(Hibyte(MouseItem.S.MAC)) + ' ';
              if MouseItem.S.AtkSpd > 0 then
                line2 :=
                  line2 + 'A.speed+' + IntToStr(MouseItem.S.AtkSpd) + ' ';
              if MouseItem.S.Slowdown > 0 then
                line2 :=
                  line2 + 'Slow+' + IntToStr(MouseItem.S.Slowdown) + ' ';
              //==Upgradeitem==
              if MouseItem.S.Tox > 0 then
                line2 := line2 + 'PA+' + IntToStr(MouseItem.S.Tox) + ' ';
              //==Upgradeitem==
            end;
            23:  //반지
            begin
              if MouseItem.S.Slowdown > 0 then
                line2 :=
                  line2 + 'Slow+' + IntToStr(MouseItem.S.Slowdown) + ' ';
              //==Upgradeitem==
              if MouseItem.S.Tox > 0 then
                line2 := line2 + 'PA+' + IntToStr(MouseItem.S.Tox) + ' ';
              //==Upgradeitem==
              if Hibyte(MouseItem.S.AC) > 0 then
                line2 :=
                  line2 + 'PR+' + IntToStr(Hibyte(MouseItem.S.AC)) + ' ';
              if Hibyte(MouseItem.S.MAC) > 0 then
                line2 :=
                  line2 + 'PN+' + IntToStr(Hibyte(MouseItem.S.MAC)) + '0% ';
              //                           if MouseItem.S.AtkSpd > 0 then
              //                              line3 := line3 + 'A.speed+' + IntToStr(MouseItem.S.AtkSpd ) + ' ';
              if Lobyte(MouseItem.S.AC) + MouseItem.S.AtkSpd > 0 then
                line3 :=
                  line3 + 'A.speed+' + IntToStr(Lobyte(MouseItem.S.AC) +
                  MouseItem.S.AtkSpd) + ' ';
              if Lobyte(MouseItem.S.MAC) > 0 then
                line3 :=
                  line3 + 'A.speed-' + IntToStr(Lobyte(MouseItem.S.MAC)) + ' ';
            end;
            24: //팔찌
            begin
              if MouseItem.S.AC > 0 then
                line2 :=
                  line2 + 'Acc+' + IntToStr(Hibyte(MouseItem.S.AC)) + ' ';
              if MouseItem.S.MAC > 0 then
                line2 :=
                  line2 + 'Agil+' + IntToStr(Hibyte(MouseItem.S.MAC)) + ' ';
{                           if (MouseItem.S.Accurate > 0) then
                              line2 := line2 + 'Acc+'+ IntToStr(MouseItem.S.Accurate)+ ' '; // ==Upgradeitem==
                           if MouseItem.S.Agility > 0 then
                              line2 := line2 + '민Agil+' + IntToStr(MouseItem.S.Agility) + ' '; // ==Upgradeitem==}
            end;
            else begin
              if MouseItem.S.AC > 0 then
                line2 :=
                  line2 + 'AC' + IntToStr(Lobyte(MouseItem.S.AC)) +
                  '-' + IntToStr(Hibyte(MouseItem.S.AC)) + ' ';
              if MouseItem.S.MAC > 0 then
                line2 :=
                  line2 + 'AMC' + IntToStr(Lobyte(MouseItem.S.MAC)) +
                  '-' + IntToStr(Hibyte(MouseItem.S.MAC)) + ' ';
            end;
          end;
          if MouseItem.S.DC > 0 then
            line2 := line2 + 'DC' + IntToStr(Lobyte(MouseItem.S.DC)) +
              '-' + IntToStr(Hibyte(MouseItem.S.DC)) + ' ';
          if MouseItem.S.MC > 0 then
            line2 := line2 + 'MC' + IntToStr(Lobyte(MouseItem.S.MC)) +
              '-' + IntToStr(Hibyte(MouseItem.S.MC)) + ' ';
          if MouseItem.S.SC > 0 then
            line2 := line2 + 'SC' + IntToStr(Lobyte(MouseItem.S.SC)) +
              '-' + IntToStr(Hibyte(MouseItem.S.SC)) + ' ';
          // 2003/03/15 아이템 인벤토리 확장
          if MouseItem.S.HpAdd > 0 then
            line2 := line2 + 'HP+' + IntToStr(MouseItem.S.HpAdd) + ' ';
          if MouseItem.S.MpAdd > 0 then begin
            if MouseItem.S.StdMode = 26 then
              line3 := line3 + 'MP+' + IntToStr(MouseItem.S.MpAdd) + ' '
            else
              line2 := line2 + 'MP+' + IntToStr(MouseItem.S.MpAdd) + ' ';
          end;
          if MouseItem.S.ExpAdd > 0 then
            line2 := line2 + '경험치+' + IntToStr(MouseItem.S.ExpAdd) + ' ';
          case MouseItem.S.EffType1 of
            1: begin
              line2 :=
                line2 + 'Hands WL+' + IntToStr(MouseItem.S.EffValue1) + ' ';
            end;
            2: begin
              line2 :=
                line2 + 'Body WL+' + IntToStr(MouseItem.S.EffValue1) + ' ';
            end;
            4: begin
              line2 :=
                line2 + 'Bag WL+' + IntToStr(MouseItem.S.EffValue1) + ' ';
            end;
            //                     5: begin
            //                           line2 := line2 + 'HPR+' + IntToStr(MouseItem.S.EffRate1) + '% ';
            //                           line2 := line2 + 'MPR+' + IntToStr(MouseItem.S.EffValue1) + '% ';
            //                        end;

          end;
          case MouseItem.S.EffType2 of
            1: begin
              line2 :=
                line2 + 'Hands WL+' + IntToStr(MouseItem.S.EffValue2) + ' ';
            end;
            2: begin
              line2 :=
                line2 + 'Body WL+' + IntToStr(MouseItem.S.EffValue2) + ' ';
            end;
            4: begin
              line2 :=
                line2 + 'Bag WL+' + IntToStr(MouseItem.S.EffValue2) + ' ';
            end;
            //                     5: begin
            //                           line2 := line2 + 'HPR+' + IntToStr(MouseItem.S.EffRate2) + '% ';
            //                           line2 := line2 + 'MPR+' + IntToStr(MouseItem.S.EffValue2) + '% ';
            //                        end;
          end;

          case MouseItem.S.Need of
            0: begin
              if Myself.Abil.Level >= MouseItem.S.NeedLevel then
                useable := True;
              line4 :=
                line4 + 'Necessary level ' + IntToStr(MouseItem.S.NeedLevel);
            end;
            1: begin
              if hibyte(Myself.Abil.DC) >= MouseItem.S.NeedLevel then
                useable := True;
              line4 :=
                line4 + 'Necessary DC ' + IntToStr(MouseItem.S.NeedLevel);
            end;
            2: begin
              if hibyte(Myself.Abil.MC) >= MouseItem.S.NeedLevel then
                useable := True;
              line4 :=
                line4 + 'Necessary MC ' + IntToStr(MouseItem.S.NeedLevel);
            end;
            3: begin
              if hibyte(Myself.Abil.SC) >= MouseItem.S.NeedLevel then
                useable := True;
              line4 :=
                line4 + 'Necessary SC ' + IntToStr(MouseItem.S.NeedLevel);
            end;
          end;
        end;
      end;
      25: //뿌리는 독가루
      begin
        line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight);
        line2 := 'Usage' + GetDura100Str(MouseItem.Dura, MouseItem.DuraMax);
      end;
      30: //초,횟불
      begin
        line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight) +
          ' Dura' + GetDuraStr(MouseItem.Dura, MouseItem.DuraMax);
        if MouseItem.S.Shape = 2 then begin
          if MouseItem.S.DC > 0 then
            line2 := line2 + 'DC' + IntToStr(Lobyte(MouseItem.S.DC)) +
              '-' + IntToStr(Hibyte(MouseItem.S.DC)) + ' ';
          if MouseItem.S.MC > 0 then
            line2 := line2 + 'MC' + IntToStr(Lobyte(MouseItem.S.MC)) +
              '-' + IntToStr(Hibyte(MouseItem.S.MC)) + ' ';
          if MouseItem.S.SC > 0 then
            line2 := line2 + 'SC' + IntToStr(Lobyte(MouseItem.S.SC)) +
              '-' + IntToStr(Hibyte(MouseItem.S.SC)) + ' ';
        end;
      end;
      40: //고기덩어리
      begin
        line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight) +
          ' Quality' + GetDuraStr(MouseItem.Dura, MouseItem.DuraMax);
      end;
      42: //약 재료
      begin
        if MouseItem.S.OverlapItem = 1 then
          line1 := line1 + 'W.' + IntToStr(MouseItem.Dura div 10) +
            ' Count' + IntToStr(MouseItem.Dura) + ' PoisonIngredient'
        else if MouseItem.S.OverlapItem = 2 then
          line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight *
            MouseItem.Dura) + ' Count' + IntToStr(MouseItem.Dura) +
            ' PoisonIngredient'
        else
          line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight) +
            ' PoisonIngredient';
      end;
      43: //광석
      begin
        line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight) +
          ' Purity' + IntToStr(Round(MouseItem.Dura / 1000));
      end;
      44: //주옥
      begin
        if MouseItem.S.Shape = 10 then begin
          if MouseItem.S.OverlapItem = 1 then
            line1 := line1 + 'W.' + IntToStr(MouseItem.Dura div 10) +
              ' Count' + IntToStr(MouseItem.Dura)
          else if MouseItem.S.OverlapItem = 2 then
            line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight *
              MouseItem.Dura) + ' Count' + IntToStr(
              MouseItem.Dura)// + ' 주옥'
          else
            line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight);// + ' 주옥';
        end else begin
          line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight);
        end;
      end;

      60, 61: begin
        if MouseItem.S.Shape in [20, 21] then begin
          if MouseItem.S.Shape = 20 then begin
            line2 :=
              'Press Ctrl key and choose defensive equipment to be repaired.';
            line3 := 'Repairable : armor, helmet, belt, shoes.';
          end else if MouseItem.S.Shape = 21 then begin
            line2 := 'Press Ctrl and choose accessory to be repaired';
            line3 := 'Repairable : necklace, ring, bracelet';
          end;
        end else
          line2 := 'Press Ctrl and choose item to be reinforced.';

        case MouseItem.S.Shape of
          1: begin
            line1 := 'W.' + IntToStr(MouseItem.S.Weight) + ' DC Increased';
            line3 := 'Reinforceable: weapon,necklace,ring,bracelet';
          end;
          2: begin
            line1 := 'W.' + IntToStr(MouseItem.S.Weight) + ' MC Increased';
            line3 := 'Reinforceable: weapon,necklace,ring,bracelet';
          end;
          3: begin
            line1 := 'W.' + IntToStr(MouseItem.S.Weight) + ' SC Increased';
            line3 := 'Reinforceable: weapon,necklace,ring,bracelet';
          end;
          4: begin
            line1 := 'W.' + IntToStr(MouseItem.S.Weight) + ' AC Increased';
            line3 :=
              'Reinforceable: ring,bracelet,garments,helmet,belt,shoes';
          end;
          5: begin
            line1 := 'W.' + IntToStr(MouseItem.S.Weight) + ' MAC Increased';
            line3 :=
              'Reinforceable: ring,bracelet,garments,helmet,belt,shoes';
          end;
          6: begin
            line1 :=
              'W.' + IntToStr(MouseItem.S.Weight) + ' Max Dura Increased';
            line3 := 'Reinforceable: all equipment';
          end;
          7: begin
            line1 := 'W.' + IntToStr(MouseItem.S.Weight) + ' Acc Increased';
            line3 := 'Reinforceable: necklace,bracelet,helmet,belt';
          end;
          8: begin
            line1 := 'W.' + IntToStr(MouseItem.S.Weight) + ' Agil Increased';
            line3 := 'Reinforceable: bracelet,garments,belt,shoes';
          end;
          9: begin
            line1 :=
              'W.' + IntToStr(MouseItem.S.Weight) + ' Increase attack speed';
            line3 := 'Reinforceable: weapon, necklace, ring';
          end;
          10: begin
            line1 := 'W.' + IntToStr(MouseItem.S.Weight) + ' Add slowdown';
            line3 := 'Reinforceable: weapon, necklace, ring';
          end;
          11: begin
            line1 := 'W.' + IntToStr(MouseItem.S.Weight) + ' Add poisoning';
            line3 := 'Reinforceable: weapon, necklace, ring';
          end;
          12: begin
            line1 :=
              'W.' + IntToStr(MouseItem.S.Weight) + ' Increase magic resistance';
            line3 := 'Reinforceable: necklace, garments, helmet';
          end;
          13: begin
            line1 :=
              'W.' + IntToStr(MouseItem.S.Weight) + ' Increase poison resistance';
            line3 := 'Reinforceable: garments, helmet, belt';
          end;
        end;
      end;
      else begin
        line1 := line1 + 'W.' + IntToStr(MouseItem.S.Weight);
      end;
    end;
  end;
end;


procedure TFrmDlg.DItemBagDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  iname, d0, d1, d2, d3: string;
  n: integer;
  useable: boolean;
  d: TDirectDrawSurface;
begin
  if Myself = nil then
    exit;
  with DItemBag do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    GetMouseItemInfo(iname, d0, d1, d2, d3, useable, False);
    //      GetMouseItemInfo (d0, d1, d2, d3, useable, FALSE);
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clWhite;
      TextOut(SurfaceX(Left + 64), SurfaceY(Top + 185+16), GetGoldStr(Myself.Gold));

      if iname <> '' then begin
        Font.Color := clYellow;
        TextOut(SurfaceX(Left + 60), SurfaceY(Top + 227), iname);
        n := TextWidth(iname);

        //            if MouseItem.UpgradeOpt > 0 then Font.Color := clAqua //@@@@@
        if MouseItem.UpgradeOpt > 0 then
          Font.Color := TColor($cccc33)
        else
          Font.Color := clWhite;
        TextOut(SurfaceX(Left + 60) + n, SurfaceY(Top + 227), d0);
        TextOut(SurfaceX(Left + 60), SurfaceY(Top + 227), d1);
        TextOut(SurfaceX(Left + 60), SurfaceY(Top + 255), d2);
        if not useable then
          Font.Color := clRed;
        n := TextWidth(d2);
        TextOut(SurfaceX(Left + 60) + n, SurfaceY(Top + 255), d3);
      end;
      Release;
    end;
  end;
end;

procedure TFrmDlg.DRepairItemInRealArea(Sender: TObject; X, Y: integer;
  var IsRealArea: boolean);
begin
{   if (X >= 0) and (Y >= 0) and (X <= DRepairItem.Width) and
      (Y <= DRepairItem.Height) then
         IsRealArea := TRUE
   else IsRealArea := FALSE;}
end;

procedure TFrmDlg.DRepairItemDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
 //var
 //   d: TDirectDrawSurface;
begin
{   with DRepairItem do begin
      d := WLib.Images[FaceIndex];
      if DRepairItem.Downed and (d <> nil) then
         dsurface.Draw (SurfaceX(254), SurfaceY(183), d.ClientRect, d, TRUE);
   end;}
end;

procedure TFrmDlg.DCloseBagDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DCloseBag do begin
    if DCloseBag.Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DCloseBagClick(Sender: TObject; X, Y: integer);
begin
  DItemBag.Visible := False;
end;

procedure TFrmDlg.DItemGridGridMouseMove(Sender: TObject; ACol, ARow: integer;
  Shift: TShiftState);
var
  idx:     integer;
  temp:    TClientItem;
  iname, d1, d2, d3: string;
  useable: boolean;
  hcolor:  TColor;
begin

  //   if ssRight in Shift then begin
  //      if ItemMoving then
  //         DItemGridGridSelect (self, ACol, ARow, Shift);
  //   end else begin
  idx := ACol + ARow * DItemGrid.ColCount + 6{벨트공간};

  if idx in [6..MAXBAGITEM - 1] then begin
    MouseItem := ItemArr[idx];
         {GetMouseItemInfo (iname, d1, d2, d3, d4, useable);
         if iname <> '' then begin
            if useable then hcolor := clWhite
            else hcolor := clRed;
            with DItemGrid do
               DScreen.ShowHint (SurfaceX(Left + ACol*ColWidth),
                                 SurfaceY(Top + (ARow+1)*RowHeight),
                                 iname + d1 + '\' + d2 + d3, hcolor, FALSE);
         end;
         MouseItem.S.Name := '';}
  end;
  //   end;
end;

procedure TFrmDlg.DItemGridGridSelect(Sender: TObject; ACol, ARow: integer;
  Shift: TShiftState);
var
  idx, mi, n: integer;
  temp: TClientItem;
begin
  idx := ACol + ARow * DItemGrid.ColCount + 6{벨트공간};

  if (not ItemMoving) and (ItemArr[idx].S.Name <> '') then begin
    if ssRight in Shift then begin
      if (EatTime + 300 < GetTickCount) and (ItemArr[idx].S.StdMode < 4) then begin
        if (ItemArr[idx].S.StdMode = 3) and (ItemArr[idx].S.Shape in
          [1, 2, 3, 4, 5, 6, 9, 10, 11]) then
        else begin
          FrmMain.EatItem(idx);
          Exit;
        end;
      end;
    end;
  end;

  if idx in [6..MAXBAGITEM - 1] then begin
    if not ItemMoving then begin
      if ItemArr[idx].S.Name <> '' then begin
        ItemMoving      := True;
        MovingItem.Index := idx;
        MovingItem.Item := ItemArr[idx];
        ItemArr[idx].S.Name := '';
        ItemClickSound(ItemArr[idx].S);
      end;
    end else begin
      //아이템 이동중
      //ItemClickSound (MovingItem.Item.S.StdMode);
      mi := MovingItem.Index;
      if (DMakeItemDlg.Visible) or (DDealDlg.Visible) then begin
        // 2004/02/23 아이템 교환,제조시 벨트창에서 가방창으로 아이템을 이동 할 수 없도록 수정..
        if (mi >= 0) and (mi < 6) then begin
          CancelItemMoving;
          if DMakeItemDlg.Visible then
            DMessageDlg(
              'When items is in making,\items cannot be moved from belt window to bag window.',
              [mbOK])
          else if DDealDlg.Visible then
            DMessageDlg(
              'When exchanging items,\items cannot be moved from belt window to bag window.',
              [mbOK]);
          Exit;
        end;
      end;
      if (mi = -97) or (mi = -98) then
        exit; //돈...
      // 2003/03/15 아이템 인벤토리 확장
      if (mi < 0) and (mi >= -13) then begin  //-99: Sell창에서 가방으로....-9->-13
        //상태창에서 가방으로
        WaitingUseItem := MovingItem;
        FrmMain.SendTakeOffItem(-(MovingItem.Index + 1),
          MovingItem.Item.MakeIndex, MovingItem.Item.S.Name);
        MovingItem.Item.S.Name := '';
        ItemMoving := False;
      end else begin
        if (mi <= -20) and (mi > -30) then begin //교환창에서
          DealItemReturnBag(MovingItem.Item); //send only
          //2004/01/06 아이템 갯수 제한 때문에 바뀜 --------
          if MovingItem.Item.S.OverlapItem > 0 then begin
            MovingItem.Item.S.Name := '';
            ItemMoving := False;
            Exit;
          end;//--------------------------------------------
        end;
        if ItemArr[idx].S.Name <> '' then begin

          if ssCtrl in Shift then begin
            UpItemItem := ItemArr[idx];
            FrmMain.UpGradeItem(ItemArr[idx].MakeIndex, MovingItem.Item.MakeIndex,
              ItemArr[idx].S.Name, MovingItem.Item.S.Name);
            if AddItemBag(MovingItem.Item) then begin
              MovingItem.Item.S.Name := '';
              ItemMoving := False;
            end;
          end else begin
            if (ItemArr[idx].S.OverlapItem > 0) and
              (ItemArr[idx].S.Name = MovingItem.Item.S.Name) and
              (not DMakeItemDlg.Visible) then begin

              FrmMain.SendItemSumCount(ItemArr[idx].MakeIndex,
                MovingItem.Item.MakeIndex,
                ItemArr[idx].S.Name,
                MovingItem.Item.S.Name);

              //2004/01/06 아이템 갯수 제한 때문에 바뀜 -----------
              if (mi > 0) and (mi < 100) then
                CancelItemMoving
              else begin
                MovingItem.Item.S.Name := '';
                ItemMoving := False;
              end;//-----------------------------------------------
            end else begin
              temp := ItemArr[idx];
              ItemArr[idx] := MovingItem.Item;
              MovingItem.Index := idx;
              MovingItem.Item := temp;
            end;
          end;
        end else begin
          ItemArr[idx] := MovingItem.Item;
          MovingItem.Item.S.Name := '';
          ItemMoving   := False;
        end;
      end;
    end;
  end;
  ArrangeItemBag;
end;

procedure TFrmDlg.DItemGridDblClick(Sender: TObject);
var
  idx, i: integer;
  keyvalue: TKeyBoardState;
  cu: TClientItem;
begin
  idx := DItemGrid.Col + DItemGrid.Row * DItemGrid.ColCount + 6;
  if idx in [6..MAXBAGITEM - 1] then begin
    if ItemArr[idx].S.Name <> '' then begin
         {FillChar(keyvalue, sizeof(TKeyboardState), #0);
         GetKeyboardState (keyvalue);
         if keyvalue[VK_CONTROL] = $80 then begin
            //시약류인경우 벨트창으로 옮기고, 기타인 경우 적절한 자리 찾음
            cu := ItemArr[idx];
            ItemArr[idx].S.Name := '';
            AddItemBag (cu);
         end else
            if (ItemArr[idx].S.StdMode <= 4) or (ItemArr[idx].S.StdMode = 31) then begin //사용할 수 있는 아이템
               FrmMain.EatItem (idx);
            end; }
    end else begin
      if ItemMoving and (MovingItem.Item.S.Name <> '') then begin
        FillChar(keyvalue, sizeof(TKeyboardState), #0);
        GetKeyboardState(keyvalue);
        if keyvalue[VK_CONTROL] = $80 then begin
          //벨트창으로 옮김
          cu := MovingItem.Item;
          MovingItem.Item.S.Name := '';
          ItemMoving := False;
          AddItemBag(cu);
        end else if (MovingItem.Index = idx) and
          (MovingItem.Item.S.StdMode <= 4) or
          (ItemArr[idx].S.StdMode in [7, 8, 31]) then begin
          FrmMain.EatItem(-1);
        end;
      end;
    end;
  end;
end;

procedure TFrmDlg.UpgradeItemEffect(wResult: word);
begin
  UpItemOffset   := UPITEMSUCCESSOFFSET;
  UpItemMaxFrame := 8;

  BoUpItemEffect  := True;
  CurUpItemEffect := 0;
end;

procedure TFrmDlg.DItemGridGridPaint(Sender: TObject; ACol, ARow: integer;
  Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  idx, ax, ay: integer;
begin
  idx := ACol + ARow * DItemGrid.ColCount + 6;
  if idx in [6..MAXBAGITEM - 1] then begin
    if ItemArr[idx].S.Name <> '' then begin
      d := FrmMain.WBagItem.Images[ItemArr[idx].S.Looks];
      if (ItemArr[idx].S.OverlapItem < 1) or
        ((ItemArr[idx].S.OverlapItem > 0) and (ItemArr[idx].Dura > 0)) then begin
        if d <> nil then
          with DItemGrid do
            dsurface.Draw(SurfaceX(Rect.Left + (ColWidth - d.Width) div 2 - 1),
              SurfaceY(Rect.Top + (RowHeight - d.Height) div 2 + 1),
              d.ClientRect,
              d, True);

        // 아이템 겹치기
        if ItemArr[idx].S.OverlapItem > 0 then begin
          SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
          dsurface.Canvas.Font.Color := clYellow;

          dsurface.Canvas.TextOut(DItemGrid.SurfaceX(Rect.Left + 20),
            DItemGrid.SurfaceY(Rect.Top + 20),
            IntToStr(ItemArr[idx].Dura));
          dsurface.Canvas.Release;
        end;
      end;

    end;
  end;

  if BoUpItemEffect then begin  // 아이템 업그레이드 효과
    if GetTickCount - upeffecttime > 120 then begin
      upeffecttime := GetTickCount;
      Inc(CurUpItemEffect);
      if CurUpItemEffect >= UpItemMaxFrame then begin
        FrmMain.DelitemProg;
        BoUpItemEffect    := False;
        UpItemItem.S.Name := '';
      end;
    end;
  end;

  if BoUpItemEffect then begin

    d := FrmMain.WMagic2.GetCachedImage(UpItemOffset + CurUpItemEffect, ax, ay);

    if d <> nil then
      if idx in [6..MAXBAGITEM - 1] then
        if (UpItemItem.MakeIndex = ItemArr[idx].MakeIndex) and
          (Trim(UpItemItem.S.Name) = Trim(ItemArr[idx].S.Name)) then
          DrawBlend(dsurface,
            DItemGrid.SurfaceX(Rect.Left) - 9 + ax,
            DItemGrid.SurfaceY(Rect.Top) + 41 + ay,
            d, 1);
  end;
end;

procedure TFrmDlg.DGoldClick(Sender: TObject; X, Y: integer);
begin
  if Myself = nil then
    exit;
  if not ItemMoving then begin
    if Myself.Gold > 0 then begin
      PlaySound(s_money);
      ItemMoving := True;
      MovingItem.Index := -98; //돈
      MovingItem.Item.S.Name := 'Gold';
    end;
  end else begin
    if (MovingItem.Index = -97) or (MovingItem.Index = -98) then begin //돈만..
      ItemMoving := False;
      MovingItem.Item.S.Name := '';
      if MovingItem.Index = -97 then begin //교환창에서 옮
        DealZeroGold;
      end;
    end;
  end;
  ;
end;




{------------------------------------------------------------------------}

//상인 대화 창

{------------------------------------------------------------------------}


procedure TFrmDlg.ShowMDlg(face: integer; mname, msgstr: string);
var
  i: integer;
begin
  DMerchantDlg.Left := 0;  //기본 위치
  DMerchantDlg.Top := 0;
  MerchantFace := face;
  MerchantName := mname;
  MDlgStr      := msgstr;
  DMerchantDlg.Visible := True;
  DItemBag.Left := 455;  //가방위치 변경
  DItemBag.Top := 0;
  for i := 0 to MDlgPoints.Count - 1 do
    Dispose(PTClickPoint(MDlgPoints[i]));
  MDlgPoints.Clear;
  RequireAddPoints := True;
  LastestClickTime := GetTickCount;
end;


procedure TFrmDlg.ResetMenuDlg;
var
  i: integer;
begin
  CloseDSellDlg;
  for i := 0 to MenuItemList.Count - 1 do  //세부 메뉴도 클리어 함.
    Dispose(PTClientItem(MenuItemList[i]));
  MenuItemList.Clear;

  for i := 0 to MenuList.Count - 1 do
    Dispose(PTClientGoods(MenuList[i]));
  MenuList.Clear;

  for i := 0 to JangwonList.Count - 1 do
    Dispose(PTClientJangwon(JangwonList[i]));
  JangwonList.Clear;

  for i := 0 to GABoardList.Count - 1 do
    Dispose(PTClientGABoard(GABoardList[i]));
  GABoardList.Clear;

  //CurDetailItem := '';
  MenuIndex      := -1;
  MenuTopLine    := 0;
  BoDetailMenu   := False;
  BoStorageMenu  := False;
  BoMakeDrugMenu := False;
  BoMakeItemMenu := False;
  NameMakeItem   := '';

  DSellDlg.Visible := False;
  DMenuDlg.Visible := False;
end;

procedure TFrmDlg.ShowShopMenuDlg;
begin
  MenuIndex := -1;

  DMerchantDlg.Left    := 0;  //기본 위치
  DMerchantDlg.Top     := 0;
  DMerchantDlg.Visible := True;

  DSellDlg.Visible := False;

  DMenuDlg.Left := 0;
  DMenuDlg.Top := 208;
  DMenuDlg.Visible := True;
  MenuTop := 0;

  DItemBag.Left    := 455;
  DItemBag.Top     := 0;
  DItemBag.Visible := True;

  LastestClickTime := GetTickCount;
end;

procedure TFrmDlg.CloseItemMarketDlg;
begin
  DItemMarketCloseClick(DItemMarketClose, 0, 0);
end;

procedure TFrmDlg.ShowShopSellDlg;
begin
  DSellDlg.Left    := 289;
  DSellDlg.Top     := 208;
  DSellDlg.Visible := True;

  DMenuDlg.Visible := False;

  DItemBag.Left    := 455;
  DItemBag.Top     := 0;
  DItemBag.Visible := True;

  LastestClickTime := GetTickCount;
  SellPriceStr     := '';
end;

procedure TFrmDlg.CloseMDlg;
var
  i: integer;
begin
  MDlgStr := '';
  DMerchantDlg.Visible := False;
  for i := 0 to MDlgPoints.Count - 1 do
    Dispose(PTClickPoint(MDlgPoints[i]));
  MDlgPoints.Clear;
  //메뉴창도 닫음
  DItemBag.Left    := 0;
  DItemBag.Top     := 0;
  DMenuDlg.Visible := False;
  CloseDSellDlg;
end;

procedure TFrmDlg.CloseDSellDlg;
begin
  DSellDlg.Visible := False;
  if SellDlgItem.S.Name <> '' then
    AddItemBag(SellDlgItem);
  SellDlgItem.S.Name := '';
end;


//상인 대화창

procedure TFrmDlg.DMerchantDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d:   TDirectDrawSurface;
  str, Data, fdata, cmdstr, cmdmsg, cmdparam: string;
  lx, ly, sx: integer;
  drawcenter: boolean;
  pcp: PTClickPoint;
begin
  with Sender as TDWindow do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    lx  := 30;
    ly  := 30;
    str := MDlgStr;
    drawcenter := False;
    while True do begin
      if str = '' then
        break;
      str := GetValidStr3(str, Data, [char($a)]);
      if Data <> '' then begin
        sx    := 0;
        fdata := '';
        while (pos('<', Data) > 0) and (pos('>', Data) > 0) and (Data <> '') do begin
          if Data[1] <> '<' then begin
            Data := '<' + GetValidStr3(Data, fdata, ['<']);
          end;
          Data := ArrestStringEx(Data, '<', '>', cmdstr);

          //fdata + cmdstr + data
          if cmdstr <> '' then begin
            if Uppercase(cmdstr) = 'C' then begin
              drawcenter := True;
              continue;
            end;
            if UpperCase(cmdstr) = '/C' then begin
              drawcenter := False;
              continue;
            end;
            cmdparam := GetValidStr3(cmdstr, cmdstr, ['/']);
            //cmdparam : 클릭 되었을 때 쓰임
          end else begin
            DMenuDlg.Visible := False;
            DSellDlg.Visible := False;
          end;

          if fdata <> '' then begin
            BoldTextOut(dsurface, SurfaceX(Left + lx + sx),
              SurfaceY(Top + ly), clWhite, clBlack, fdata);
            sx := sx + dsurface.Canvas.TextWidth(fdata);
          end;
          if cmdstr <> '' then begin
            if RequireAddPoints then begin //한번만...
              new(pcp);
              pcp.rc   :=
                Rect(lx + sx, ly, lx + sx + dsurface.Canvas.TextWidth(cmdstr), ly + 14);
              pcp.RStr := cmdparam;
              MDlgPoints.Add(pcp);
            end;
            dsurface.Canvas.Font.Style :=
              dsurface.Canvas.Font.Style + [fsUnderline];
            if SelectMenuStr = cmdparam then
              BoldTextOut(dsurface, SurfaceX(Left + lx + sx),
                SurfaceY(Top + ly), clRed, clBlack, cmdstr)
            else
              BoldTextOut(dsurface, SurfaceX(Left + lx + sx),
                SurfaceY(Top + ly), clYellow,
                clBlack, cmdstr);
            sx := sx + dsurface.Canvas.TextWidth(cmdstr);
            dsurface.Canvas.Font.Style :=
              dsurface.Canvas.Font.Style - [fsUnderline];
          end;
        end;
        if Data <> '' then
          BoldTextOut(dsurface, SurfaceX(Left + lx + sx), SurfaceY(Top + ly),
            clWhite, clBlack, Data);
      end;
      ly := ly + 16;
    end;
    dsurface.Canvas.Release;
    RequireAddPoints := False;
  end;

end;

procedure TFrmDlg.DMerchantDlgCloseClick(Sender: TObject; X, Y: integer);
begin
  CloseMDlg;
end;

procedure TFrmDlg.DMenuDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);

  function SX(x: integer): integer;
  begin
    Result := DMenuDlg.SurfaceX(DMenuDlg.Left + x);
  end;

  function SY(y: integer): integer;
  begin
    Result := DMenuDlg.SurfaceY(DMenuDlg.Top + y);
  end;

var
  i, lh, k, m, menuline: integer;
  d:   TDirectDrawSurface;
  pg:  PTClientGoods;
  str: string;
begin
  with dsurface.Canvas do begin
    with DMenuDlg do begin
      d := DMenuDlg.WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;

    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    SetBkMode(Handle, TRANSPARENT);
    //title
    Font.Color := clWhite;
    if not BoStorageMenu then begin
      TextOut(SX(36), SY(30), 'Item list');
      TextOut(SX(175), SY(30), 'Price');
      if not BoMakeItemMenu then
        TextOut(SX(263), SY(30), 'Dura.');
      lh := LISTLINEHEIGHT;
      menuline := _MIN(MAXMENU, MenuList.Count - MenuTop);
      //상품 리스트
      for i := MenuTop to MenuTop + menuline - 1 do begin
        m := i - MenuTop;
        if i = MenuIndex then begin
          Font.Color := clRed;
          TextOut(SX(29), SY(51 + m * lh), char(7));
        end else
          Font.Color := clWhite;
        pg := PTClientGoods(MenuList[i]);
        TextOut(SX(36), SY(51 + m * lh), pg.Name);
        if (pg.SubMenu >= 1) and (pg.SubMenu <> 2) then
          TextOut(SX(137), SY(51 + m * lh), #31);
        TextOut(SX(175), SY(51 + m * lh), IntToStr(pg.Price) + 'Gold');
        str := '';
        if pg.Grade = -1 then
          str := '-'
        else
          TextOut(SX(263), SY(51 + m * lh), IntToStr(pg.Grade));
            {else for k:=0 to pg.Grade-1 do
               str := str + '*';
            if Length(str) >= 4 then begin
               Font.Color := clYellow;
               TextOut (SX(245), SY(32 + m*lh), str);
            end else
               TextOut (SX(245), SY(32 + m*lh), str);}
      end;
    end else begin
      TextOut(SX(36), SY(30), 'Custody list');
      TextOut(SX(175), SY(30), 'Dura.');
      TextOut(SX(263), SY(30), '');
      lh := LISTLINEHEIGHT;
      menuline := _MIN(MAXMENU, MenuList.Count - MenuTop);
      //상품 리스트
      for i := MenuTop to MenuTop + menuline - 1 do begin
        m := i - MenuTop;
        if i = MenuIndex then begin
          Font.Color := clRed;
          TextOut(SX(29), SY(51 + m * lh), char(7));
        end else
          Font.Color := clWhite;
        pg := PTClientGoods(MenuList[i]);
        TextOut(SX(36), SY(51 + m * lh), pg.Name);
        if (pg.SubMenu >= 1) and (pg.SubMenu <> 2) then
          TextOut(SX(137), SY(51 + m * lh), #31);
        TextOut(SX(175), SY(51 + m * lh), IntToStr(pg.Stock) +
          '/' + IntToStr(pg.Grade));
      end;
    end;
    //TextOut (0, 0, IntToStr(MenuTopLine));

    Release;
  end;
end;

procedure TFrmDlg.DMenuDlgClick(Sender: TObject; X, Y: integer);
var
  lx, ly, idx: integer;
  iname, d1, d2, d3, d4: string;
  useable:     boolean;
begin
  DScreen.ClearHint;
  lx := DMenuDlg.LocalX(X) - DMenuDlg.Left;
  ly := DMenuDlg.LocalY(Y) - DMenuDlg.Top;
  if (lx >= 14) and (lx <= 279) and (ly >= 50) then begin
    idx := (ly - 32-20) div LISTLINEHEIGHT + MenuTop;
    if idx < MenuList.Count then begin
      PlaySound(s_glass_button_click);
      MenuIndex := idx;
      if DMakeItemDlg.Visible then
        DMakeItemDlgOkClick(DMakeItemDlgCancel, 0, 0);
    end;
  end;

  if BoStorageMenu then begin
    if (MenuIndex >= 0) and (MenuIndex < SaveItemList.Count) then begin
      MouseItem := PTClientItem(SaveItemList[MenuIndex])^;
      GetMouseItemInfo(iname, d1, d2, d3, d4, useable, False);
      if iname <> '' then begin
        lx := 240;
        ly := 32 + (MenuIndex - MenuTop) * LISTLINEHEIGHT;
        with Sender as TDButton do
          DScreen.ShowHint(DMenuDlg.SurfaceX(Left + lx),
            DMenuDlg.SurfaceY(Top + ly),
            iname + d1 + '\' + d2 + '\' + d3 + d4, clYellow, False);
      end;
      MouseItem.S.Name := '';
    end;
  end else begin
    if (MenuIndex >= 0) and (MenuIndex < MenuItemList.Count) and
      ((PTClientGoods(MenuList[MenuIndex]).SubMenu = 0) or
      (PTClientGoods(MenuList[MenuIndex]).SubMenu = 2)) then begin
      MouseItem := PTClientItem(MenuItemList[MenuIndex])^;
      BoNoDisplayMaxDura := True;
      GetMouseItemInfo(iname, d1, d2, d3, d4, useable, False);
      BoNoDisplayMaxDura := False;
      if iname <> '' then begin
        lx := 240;
        ly := 32 + (MenuIndex - MenuTop) * LISTLINEHEIGHT;
        with Sender as TDButton do
          DScreen.ShowHint(DMenuDlg.SurfaceX(Left + lx),
            DMenuDlg.SurfaceY(Top + ly),
            iname + d1 + '\' + d2 + '\' + d3 + d4, clYellow, False);
      end;
      MouseItem.S.Name := '';
    end;
  end;
end;

procedure TFrmDlg.DMenuDlgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  with DMenuDlg do
    if (X < SurfaceX(Left + 10)) or (X > SurfaceX(Left + Width - 20)) or
      (Y < SurfaceY(Top + 30)) or (Y > SurfaceY(Top + Height - 50)) then begin
      DScreen.ClearHint;
    end;
end;

procedure TFrmDlg.DMenuBuyClick(Sender: TObject; X, Y: integer);
var
  pg:     PTClientGoods;
  MsgResult, Count: integer;
  valstr: string;
begin
  Count := 0;
  if GetTickCount < LastestClickTime then
    exit; //클릭을 자주 못하게 제한
  if (MenuIndex >= 0) and (MenuIndex < MenuList.Count) then begin
    pg := PTClientGoods(MenuList[MenuIndex]);
    LastestClickTime := GetTickCount + 5000;
    if (pg.SubMenu > 0) and (pg.SubMenu <> 2) then begin
      FrmMain.SendGetDetailItem(CurMerchant, 0, pg.Name);
      MenuTopLine   := 0;
      CurDetailItem := pg.Name;
    end else begin
      if BoStorageMenu then begin
        try
          MouseItem := PTClientItem(SaveItemList[MenuIndex])^;
        except
        end;
        if MouseItem.S.OverlapItem > 0 then begin
          Total := MouseItem.Dura;
          if Total = 1 then begin
            DlgEditText := '1';
            MsgResult   := mrOk;
          end else
            MsgResult := DCountMsgDlg('How many out of total ' +
              IntToStr(MouseItem.Dura) + '\would you like to redeem', [mbAbort]);
          GetValidStrVal(DlgEditText, valstr, [' ']);
          Count := Str_ToInt(valstr, 0);

          if Count > MouseItem.Dura then
            Count := MouseItem.Dura;
          if (MsgResult = mrCancel) or (Count <= 0) then
          begin// or (Count < 1) or(Count > MAX_OVERLAPITEM ) then begin
            Count := 0;
            Exit;
          end;
          FrmMain.SendTakeBackStorageItem(CurMerchant,
            pg.Price{MakeIndex}, pg.Name, word(Count));
        end else
          FrmMain.SendTakeBackStorageItem(CurMerchant, pg.Price{MakeIndex},
            pg.Name, word(Count));
        exit;
      end;
      if BoMakeItemMenu then begin
        NameMakeItem := pg.Name;
        FrmMain.SendMakeItemSel(CurMerchant, pg.Name);
        MakeItemDlgShow('');
        exit;
      end;
      if BoMakeDrugMenu then begin
        FrmMain.SendMakeDrugItem(CurMerchant, pg.Name);
        exit;
      end;

      if pg.SubMenu = 2 then begin // pg.SubMenu = 2 이면 겹치기 아이템..
        Total     := 100;
        MsgResult := DCountMsgDlg('How many would you like to buy?',
          [mbOK, mbCancel, mbAbort]);
        GetValidStrVal(DlgEditText, valstr, [' ']);
        Count := Str_ToInt(valstr, 0);
        if (MsgResult = mrCancel) or (Count <= 0) or (Count > MAX_OVERLAPITEM) then
        begin
          Exit;
        end;
      end;
      FrmMain.SendBuyItem(CurMerchant, pg.Stock, pg.Name, word(Count));
    end;
  end;
end;

procedure TFrmDlg.DMenuPrevClick(Sender: TObject; X, Y: integer);
begin
  if not BoDetailMenu then begin
    if MenuTop > 0 then
      Dec(MenuTop, MAXMENU - 1);
    if MenuTop < 0 then
      MenuTop := 0;
  end else begin
    if MenuTopLine > 0 then begin
      MenuTopLine := _MAX(0, MenuTopLine - 10);
      FrmMain.SendGetDetailItem(CurMerchant, MenuTopLine, CurDetailItem);
    end;
  end;
end;

procedure TFrmDlg.DMenuNextClick(Sender: TObject; X, Y: integer);
begin
  if not BoDetailMenu then begin
    if MenuTop + MAXMENU < MenuList.Count then
      Inc(MenuTop, MAXMENU - 1);
  end else begin
    MenuTopLine := MenuTopLine + 10;
    FrmMain.SendGetDetailItem(CurMerchant, MenuTopLine, CurDetailItem);
  end;
end;

procedure TFrmDlg.SoldOutGoods(itemserverindex: integer);
var
  i:  integer;
  pg: PTClientGoods;
begin
  for i := 0 to MenuList.Count - 1 do begin
    pg := PTClientGoods(MenuList[i]);
    if (pg.Grade >= 0) and (pg.Stock = itemserverindex) then begin
      Dispose(pg);
      MenuList.Delete(i);
      if i < MenuItemList.Count then
        MenuItemList.Delete(i);
      if MenuIndex > MenuList.Count - 1 then
        MenuIndex := MenuList.Count - 1;
      break;
    end;
  end;
end;

procedure TFrmDlg.DelStorageItem(itemserverindex: integer; remain: word);
var
  i:  integer;
  pg: PTClientGoods;
begin
  for i := 0 to MenuList.Count - 1 do begin
    pg := PTClientGoods(MenuList[i]);
    if (pg.Price = itemserverindex) then begin
      //보관목록인경운 Price = ItemServerIndex임.
      if (remain > 0) and (PTClientItem(SaveItemList[i])^.S.OverlapItem > 0) then
      begin
        PTClientItem(SaveItemList[i])^.Dura := remain;
        Exit;
      end;
      Dispose(pg);
      MenuList.Delete(i);
      if i < SaveItemList.Count then
        SaveItemList.Delete(i);
      if MenuIndex > MenuList.Count - 1 then
        MenuIndex := MenuList.Count - 1;
      break;
    end;
  end;
end;

procedure TFrmDlg.DMenuCloseClick(Sender: TObject; X, Y: integer);
begin
  DMenuDlg.Visible := False;
end;

procedure TFrmDlg.DMerchantDlgClick(Sender: TObject; X, Y: integer);
var
  i, L, T: integer;
  p: PTClickPoint;
begin
  if GetTickCount < LastestClickTime then
    exit; //클릭을 자주 못하게 제한
  L := DMerchantDlg.Left;
  T := DMerchantDlg.Top;
  with DMerchantDlg do
    for i := 0 to MDlgPoints.Count - 1 do begin
      p := PTClickPoint(MDlgPoints[i]);
      if (X >= SurfaceX(L + p.rc.Left)) and (X <= SurfaceX(L + p.rc.Right)) and
        (Y >= SurfaceY(T + p.rc.Top)) and (Y <= SurfaceY(T + p.rc.Bottom)) then begin
        PlaySound(s_glass_button_click);
        if DMakeItemDlg.Visible then
          DMakeItemDlgOkClick(DMakeItemDlgCancel, 0, 0);
        if DSellDlg.Visible then
          CloseDSellDlg;
        SafeCloseDlg;
{            if DItemMarketDlg.Visible then CloseItemMarketDlg;
            if DJangwonListDlg.Visible then DJangwonCloseClick(DJangwonClose, 0, 0);
            if DGABoardListDlg.Visible then DGABoardListCloseClick(FrmDlg.DGABoardListClose, 0, 0);
            if DGABoardDlg.Visible then DGABoardCloseClick(FrmDlg.DGABoardClose, 0, 0);
            if DGADecorateDlg.Visible then DGADecorateCloseClick(FrmDlg.DGADecorateClose, 0, 0);}

        FrmMain.SendMerchantDlgSelect(CurMerchant, p.RStr);
        LastestClickTime := GetTickCount + 5000; //5초후에 사용 가능
        break;
      end;
    end;
end;

procedure TFrmDlg.DMerchantDlgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  i, L, T: integer;
  p: PTClickPoint;
begin
  if GetTickCount < LastestClickTime then
    exit; //클릭을 자주 못하게 제한
  SelectMenuStr := '';
  L := DMerchantDlg.Left;
  T := DMerchantDlg.Top;
  with DMerchantDlg do
    for i := 0 to MDlgPoints.Count - 1 do begin
      p := PTClickPoint(MDlgPoints[i]);
      if (X >= SurfaceX(L + p.rc.Left)) and (X <= SurfaceX(L + p.rc.Right)) and
        (Y >= SurfaceY(T + p.rc.Top)) and (Y <= SurfaceY(T + p.rc.Bottom)) then begin
        SelectMenuStr := p.RStr;
        break;
      end;
    end;
end;

procedure TFrmDlg.DMerchantDlgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  SelectMenuStr := '';
end;

procedure TFrmDlg.DSellDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  actionname: string;
begin
  with DSellDlg do begin
    d := DMenuDlg.WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clWhite;
      actionname := '';
      case SpotDlgMode of
        dmSell: actionname      := 'Sale: ';
        dmRepair: actionname    := 'Repair: ';
        dmStorage: actionname   := ' Custody of Item';
        dmMaketSell: actionname := '   Consignment';
      end;
      TextOut(SurfaceX(Left + 8), SurfaceY(Top + 6), actionname + SellPriceStr);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DSellDlgCloseClick(Sender: TObject; X, Y: integer);
begin
  CloseDSellDlg;
end;

procedure TFrmDlg.DSellDlgSpotClick(Sender: TObject; X, Y: integer);
var
  temp:   TClientItem;
  MsgResult, Count: integer;
  valstr: string;
begin
  SellPriceStr := '';
  if not ItemMoving then begin
    if SellDlgItem.S.Name <> '' then begin
      ItemClickSound(SellDlgItem.S);
      ItemMoving      := True;
      MovingItem.Index := -99; //sell 창에서 나옴..
      MovingItem.Item := SellDlgItem;
      SellDlgItem.S.Name := '';
    end;
  end else begin
    if (MovingItem.Index = -97) or (MovingItem.Index = -98) then
      exit;
    if (MovingItem.Index >= 0) or (MovingItem.Index = -99) then begin
      ItemClickSound(MovingItem.Item.S);
      if SellDlgItem.S.Name <> '' then begin //자리에 있으면
        temp := SellDlgItem;
        SellDlgItem := MovingItem.Item;
        MovingItem.Index := -99; //sell 창에서 나옴..
        MovingItem.Item := temp;
      end else if MovingItem.Item.S.OverlapItem = 0 then begin
        SellDlgItem := MovingItem.Item;
        MovingItem.Item.S.Name := '';
        ItemMoving  := False;
      end else if MovingItem.Item.S.OverlapItem > 0 then begin
        SellDlgItem := MovingItem.Item;
        ItemMoving := False;
        Total := MovingItem.Item.Dura;
        if Total = 1 then begin
          DlgEditText := '1';
          MsgResult   := mrOk;
        end else
          MsgResult := DCountMsgDlg('How many out of total ' +
            IntToStr(MovingItem.Item.Dura) + ' will you put on',
            [mbOK, mbCancel, mbAbort]);
        ItemMoving := True;
        GetValidStrVal(DlgEditText, valstr, [' ']);
        Count := Str_ToInt(valstr, 0);
        if Count <= 0 then begin
          Count := 0;
          AddItemBag(SellDlgItem);
          SellDlgItem.S.Name := '';
          SellDlgItem.Dura   := 0;
          MovingItem.Item.S.Name := '';
          CancelItemMoving;
          Exit;
        end;
        if Count >= SellDlgItem.Dura then begin
          Count := SellDlgItem.Dura;
          MovingItem.Item.Dura := 0;
        end;
        if MsgResult = mrOk then begin
          SellDlgItem.Dura := word(Count);
          if MovingItem.Item.Dura > 0 then begin
            MovingItem.Item.Dura := MovingItem.Item.Dura - word(Count);
          end;
          if MovingItem.Item.Dura <= 0 then begin
            MovingItem.Item.Dura := 0;
            MovingItem.Item.S.Name := '';
            ItemMoving := False;
          end;
          //               MovingItem.Index := 0;
          CancelItemMoving;
        end;
        if MsgResult = mrCancel then begin
          AddItemBag(SellDlgItem);
          SellDlgItem.S.Name := '';
          SellDlgItem.Dura   := 0;
          MovingItem.Item.S.Name := '';
          //               MovingItem.Index := 0;
          CancelItemMoving;
          Exit;
        end;
      end;

      BoQueryPrice   := True;
      QueryPriceTime := GetTickCount;
    end;
  end;

end;

procedure TFrmDlg.DSellDlgSpotDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  if SellDlgItem.S.Name <> '' then begin
    d := FrmMain.WBagItem.Images[SellDlgItem.S.Looks];
    if d <> nil then begin
      with DSellDlgSpot do
        dsurface.Draw(SurfaceX(Left + (Width - d.Width) div 2),
          SurfaceY(Top + (Height - d.Height) div 2),
          d.ClientRect,
          d, True);

      if SellDlgItem.S.OverlapItem > 0 then begin
        SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
        dsurface.Canvas.Font.Color := clYellow;
        with DSellDlgSpot do
          dsurface.Canvas.TextOut(SurfaceX(Left + (Width - d.Width) div 2) + 21,
            SurfaceY(Top + (Height - d.Height) div 2) + 15,
            IntToStr(SellDlgItem.Dura));
        dsurface.Canvas.Release;
      end;
    end;
  end;
end;

procedure TFrmDlg.DSellDlgSpotMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  MouseItem := SellDlgItem;
end;

procedure TFrmDlg.DSellDlgOkClick(Sender: TObject; X, Y: integer);
var
  dropgold:  integer;
  valstr:    string;
  MsgResult: integer;
begin
  if (SellDlgItem.S.Name = '') and (SellDlgItemSellWait.S.Name = '') then
    exit;
  if GetTickCount < LastestClickTime then
    exit; //클릭을 자주 못하게 제한
  case SpotDlgMode of
    dmSell: FrmMain.SendSellItem(CurMerchant, SellDlgItem.MakeIndex,
        SellDlgItem.S.Name, SellDlgItem.Dura);
    dmRepair: FrmMain.SendRepairItem(CurMerchant, SellDlgItem.MakeIndex,
        SellDlgItem.S.Name);
    dmStorage: FrmMain.SendStorageItem(CurMerchant, SellDlgItem.MakeIndex,
        SellDlgItem.S.Name, SellDlgItem.Dura);
    dmMaketSell: begin
      DMessageDlg('How much do you want to put on the trade offer?',
        [mbOK, mbAbort]);
      GetValidStrVal(DlgEditText, valstr, [' ']);

      try
        dropgold := Str_ToInt(valstr, 0);
      except
        DMessageDlg('Wrong input.', [mbOK]);
        Exit;
      end;
      if (dropgold > 0) and (dropgold <= MAX_MARKETPRICE) then begin
        MsgResult := DMessageDlg('Do you want to place ' +
          SellDlgItem.S.Name + ' at the price of ' + GetGoldStr(dropgold) +
          'gold?', [mbOK, mbCancel]);
        if MsgResult = mrOk then
          FrmMain.SendMaketSellItem(CurMerchant, SellDlgItem.MakeIndex,
            valstr, SellDlgItem.Dura)
        else if MsgResult = mrCancel then
          Exit;
      end else begin
        DMessageDlg(
          'You need to put reasonable amount.\The maximum price you can put is ' +
          GetGoldStr(MAX_MARKETPRICE) + 'gold.', [mbOK]);
        Exit;
      end;
    end;
  end;

  SellDlgItemSellWait := SellDlgItem;
  SellDlgItem.S.Name := '';
  LastestClickTime := GetTickCount + 5000;
  SellPriceStr := '';
end;




{------------------------------------------------------------------------}

//마법 키 설정 창 (다이얼 로그)

{------------------------------------------------------------------------}


procedure TFrmDlg.SetMagicKeyDlg(icon: integer; magname: string; var curkey: word);
begin
  MagKeyIcon    := icon;
  MagKeyMagName := magname;
  MagKeyCurKey  := curkey;


  DKeySelDlg.Left := (SCREENWIDTH - DKeySelDlg.Width) div 2;
  DKeySelDlg.Top  := (SCREENHEIGHT - DKeySelDlg.Height) div 2;
  HideAllControls;
  DKeySelDlg.ShowModal;

  while True do begin
    if not DKeySelDlg.Visible then
      break;
    FrmMain.DXTimerTimer (self, 0);
    //FrmMain.ProcOnIdle;
    Application.ProcessMessages;
    if Application.Terminated then
      exit;
  end;

  RestoreHideControls;
  curkey := MagKeyCurKey;
end;

procedure TFrmDlg.DKeySelDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DKeySelDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    //마법 이름
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clSilver;
      TextOut(SurfaceX(Left + 95), SurfaceY(Top + 38), MagKeyMagName + ' key is.');
      Release;
    end;
  end;
end;

procedure TFrmDlg.DKsIconDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DksIcon do begin
    d := FrmMain.WMagIcon.Images[MagKeyIcon];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
  end;
end;

procedure TFrmDlg.DKsF1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  b: TDButton;
  d: TDirectDrawSurface;
begin
  b := nil;
  case MagKeyCurKey of
    word('1'): b      := DKsF1;
    word('2'): b      := DKsF2;
    word('3'): b      := DKsF3;
    word('4'): b      := DKsF4;
    word('5'): b      := DKsF5;
    word('6'): b      := DKsF6;
    word('7'): b      := DKsF7;
    word('8'): b      := DKsF8;
    // 2003/08/20 =>마법단축키 추가  // AddMagicKey
    word('1') + 20: b := DKsConF1;
    word('2') + 20: b := DKsConF2;
    word('3') + 20: b := DKsConF3;
    word('4') + 20: b := DKsConF4;
    word('5') + 20: b := DKsConF5;
    word('6') + 20: b := DKsConF6;
    word('7') + 20: b := DKsConF7;
    word('8') + 20: b := DKsConF8;
      //-------
    else
      b := DKsNone;
  end;
  if b = Sender then begin
    with b do begin
      d := WLib.Images[FaceIndex + 1];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
  with Sender as TDButton do begin
    if Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DKsOkClick(Sender: TObject; X, Y: integer);
begin
  DKeySelDlg.Visible := False;
end;

procedure TFrmDlg.DKsF1Click(Sender: TObject; X, Y: integer);
begin
  if Sender = DKsF1 then
    MagKeyCurKey := integer('1');
  if Sender = DKsF2 then
    MagKeyCurKey := integer('2');
  if Sender = DKsF3 then
    MagKeyCurKey := integer('3');
  if Sender = DKsF4 then
    MagKeyCurKey := integer('4');
  if Sender = DKsF5 then
    MagKeyCurKey := integer('5');
  if Sender = DKsF6 then
    MagKeyCurKey := integer('6');
  if Sender = DKsF7 then
    MagKeyCurKey := integer('7');
  if Sender = DKsF8 then
    MagKeyCurKey := integer('8');
  // 2003/08/20 =>마법단축키 추가  // AddMagicKey
  if Sender = DKsConF1 then
    MagKeyCurKey := integer('1') + 20;
  if Sender = DKsConF2 then
    MagKeyCurKey := integer('2') + 20;
  if Sender = DKsConF3 then
    MagKeyCurKey := integer('3') + 20;
  if Sender = DKsConF4 then
    MagKeyCurKey := integer('4') + 20;
  if Sender = DKsConF5 then
    MagKeyCurKey := integer('5') + 20;
  if Sender = DKsConF6 then
    MagKeyCurKey := integer('6') + 20;
  if Sender = DKsConF7 then
    MagKeyCurKey := integer('7') + 20;
  if Sender = DKsConF8 then
    MagKeyCurKey := integer('8') + 20;
  //------
  if Sender = DKsNone then
    MagKeyCurKey := 0;
end;



{------------------------------------------------------------------------}

//기본창의 미니 버튼

{------------------------------------------------------------------------}


procedure TFrmDlg.DBotMiniMapClick(Sender: TObject; X, Y: integer);
begin
  if ViewMiniMapStyle = 0 then begin
    if GetTickCount > querymsgtime then begin
      querymsgtime := GetTickCount + 3000;
      FrmMain.SendWantMiniMap;
      BoWantMiniMap := True;
    end;
  end else begin
    Inc(ViewMiniMapStyle);
    if ViewMiniMapStyle > 2 then begin
      ViewMiniMapStyle := 0;
      PrevVMMStyle     := 1;  //초기 값
      BoWantMiniMap    := False;
    end;
  end;
end;

procedure TFrmDlg.DBotTradeClick(Sender: TObject; X, Y: integer);
begin
  if GetTickCount > querymsgtime then begin
    querymsgtime := GetTickCount + 3000;
    FrmMain.SendDealTry;
  end;
end;

procedure TFrmDlg.DBotGuildClick(Sender: TObject; X, Y: integer);
begin
  if DGuildDlg.Visible then begin
    DGuildDlg.Visible := False;
  end else if GetTickCount > querymsgtime then begin
    querymsgtime := GetTickCount + 3000;
    FrmMain.SendGuildDlg;
  end;
end;

procedure TFrmDlg.DBotGroupClick(Sender: TObject; X, Y: integer);
begin
  ToggleShowGroupDlg;
end;


{------------------------------------------------------------------------}

//그룹 다이얼로그

{------------------------------------------------------------------------}

procedure TFrmDlg.ToggleShowGroupDlg;
begin
  DGroupDlg.Visible := not DGroupDlg.Visible;
end;

procedure TFrmDlg.DGroupDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  lx, ly, n: integer;
begin
  with DGroupDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    if GroupMembers.Count > 0 then begin
      with dsurface.Canvas do begin
        SetBkMode(Handle, TRANSPARENT);
        Font.Color := clSilver;
        lx := SurfaceX(28) + Left;
        ly := SurfaceY(80) + Top;
        TextOut(lx, ly, GroupMembers[0]);
        for n := 1 to GroupMembers.Count - 1 do begin
          lx := SurfaceX(28) + Left + ((n - 1) mod 2) * 100;
          ly := SurfaceY(80 + 16) + Top + ((n - 1) div 2) * 16;
          TextOut(lx, ly, GroupMembers[n]);
        end;
        Release;
      end;
    end;
  end;
end;

procedure TFrmDlg.DGrpDlgCloseClick(Sender: TObject; X, Y: integer);
begin
  DGroupDlg.Visible := False;
end;

procedure TFrmDlg.DGrpAllowGroupDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if Downed then begin
      d := WLib.Images[FaceIndex - 1];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end else begin
      if AllowGroup then begin
        d := WLib.Images[FaceIndex];
        if d <> nil then
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
      end;
    end;
  end;
end;

procedure TFrmDlg.DGrpAllowGroupClick(Sender: TObject; X, Y: integer);
begin
  if GetTickCount > changegroupmodetime then begin
    AllowGroup := not AllowGroup;
    changegroupmodetime := GetTickCount + 2000;
    //timeout 5초 //DelayTime 5초에서 2초로수정 //2004/11/18
    FrmMain.SendGroupMode(AllowGroup);
  end;
end;

procedure TFrmDlg.DGrpCreateClick(Sender: TObject; X, Y: integer);
var
  who: string;
begin
  if (GetTickCount > changegroupmodetime) and (GroupMembers.Count = 0) then begin
    DialogSize := 1;
    DMessageDlg('Type the name you want to join Group.', [mbOK, mbAbort]);
    who := Trim(DlgEditText);
    if who <> '' then begin
      changegroupmodetime := GetTickCount + 2000;
      //timeout 5초 //@@@@@5 DelayTime 5초에서 2초로수정 //2004/11/18
      FrmMain.SendCreateGroup(Trim(DlgEditText));
    end;
  end;
end;

procedure TFrmDlg.DGrpAddMemClick(Sender: TObject; X, Y: integer);
var
  who: string;
begin
  if (GetTickCount > changegroupmodetime) and (GroupMembers.Count > 0) then begin
    DialogSize := 1;
    DMessageDlg('Type the name you want to join Group.', [mbOK, mbAbort]);
    who := Trim(DlgEditText);
    if who <> '' then begin
      changegroupmodetime := GetTickCount + 2000;
      //timeout 5초 //DelayTime 5초에서 2초로수정 //2004/11/18
      FrmMain.SendAddGroupMember(Trim(DlgEditText));
    end;
  end;
end;

procedure TFrmDlg.DGrpDelMemClick(Sender: TObject; X, Y: integer);
var
  who: string;
begin
  if (GetTickCount > changegroupmodetime) and (GroupMembers.Count > 0) then begin
    DialogSize := 1;
    DMessageDlg('Type the name you want to be deleted from Group.', [mbOK, mbAbort]);
    who := Trim(DlgEditText);
    if who <> '' then begin
      changegroupmodetime := GetTickCount + 2000;
      //timeout 5초 //DelayTime 5초에서 2초로수정 //2004/11/18
      FrmMain.SendDelGroupMember(Trim(DlgEditText));
    end;
  end;
end;

procedure TFrmDlg.DBotLogoutClick(Sender: TObject; X, Y: integer);
begin
  FrmMain.SendClientMessage(CM_CANCLOSE, 0, 0, 0, 0);
{
   if (GetTickCount - LatestStruckTime > 10000) and
      (GetTickCount - LatestMagicTime > 10000) and
      (GetTickCount - LatestHitTime > 10000) or
      (Myself.Death) then begin
      FrmMain.AppLogOut;
   end else
      DScreen.AddChatBoardString ('You cannot terminate connection during fight.', clYellow, clRed);
}
end;

procedure TFrmDlg.DBotExitClick(Sender: TObject; X, Y: integer);
begin
  if (GetTickCount - LatestStruckTime > 10000) and
    (GetTickCount - LatestMagicTime > 10000) and (GetTickCount -
    LatestHitTime > 10000) or (Myself.Death) then begin
    FrmMain.AppExit;
  end else
    DScreen.AddChatBoardString('You cannot terminate connection during fight.',
      clYellow, clRed);
end;

procedure TFrmDlg.DBotPlusAbilClick(Sender: TObject; X, Y: integer);
begin
  FrmDlg.OpenAdjustAbility;
end;


{------------------------------------------------------------------------}

//교환 다이얼로그

{------------------------------------------------------------------------}


procedure TFrmDlg.OpenDealDlg(DealCase: byte);
var
  d: TDirectDrawSurface;
begin
  if DealCase = 1 then begin
    DDealDlg.Floating := True;
    DDealRemoteDlg.Floating := True;
    DDealRemoteDlg.Left := SCREENWIDTH - 236 - 100;
    DDealRemoteDlg.Top := 0;
    DDealDlg.Left := SCREENWIDTH - 236 - 100;
    DDealDlg.Top  := DDealRemoteDlg.Height - 15;
    DDealJangwon.Visible := False;
  end else if DealCase = 2 then begin
    DDealJangwon.Floating := False;
    DDealJangwon.Visible := True;
    DDealDlg.Floating := False;
    DDealRemoteDlg.Floating := False;
    DDealRemoteDlg.Left := 548;
    DDealRemoteDlg.Top := 202;
    DDealDlg.Left := 312;
    DDealDlg.Top  := 202;
  end;
  DItemBag.Left    := 0; //475;
  DItemBag.Top     := 0;
  DItemBag.Visible := True;
  DDealDlg.Visible := True;
  DDealRemoteDlg.Visible := True;

  FillCHar(DealItems, sizeof(TClientItem) * 10, #0);
  FillCHar(DealRemoteItems, sizeof(TClientItem) * 20, #0);
  DealGold  := 0;
  DealRemoteGold := 0;
  BoDealEnd := False;

  //아이템 가방에 잔상이 있는지 검사
  ArrangeItembag;
end;

procedure TFrmDlg.CloseDealDlg;
begin
  DDealDlg.Visible := False;
  DDealRemoteDlg.Visible := False;
  if DDealJangwon.Visible then
    DDealJangwon.Visible := False;

  //아이템 가방에 잔상이 있는지 검사
  ArrangeItembag;
end;

procedure TFrmDlg.DDealOkClick(Sender: TObject; X, Y: integer);
var
  mi: integer;
begin
  if GetTickCount > dealactiontime then begin
    //CloseDealDlg;
    FrmMain.SendDealEnd;
    dealactiontime := GetTickCount + 4000;
    BoDealEnd      := True;
    //딜 창에서 마우스로 끌고 있는 것을 딜창으로 넣는다. 마우스에 남는 잔상(복사)을 없앤다.
    if ItemMoving then begin
      mi := MovingItem.Index;
      if (mi <= -20) and (mi > -30) then begin //딜 창에서 온것만
        AddDealItem(MovingItem.Item);  // 교환=>겹치기
        ItemMoving := False;
        MovingItem.Item.S.Name := '';
        MovingItem.Item.Dura := 0; // 10/29
      end;
    end;
  end;
end;

procedure TFrmDlg.DDealCloseClick(Sender: TObject; X, Y: integer);
begin
  if GetTickCount > dealactiontime then begin
    CloseDealDlg;
    FrmMain.SendCancelDeal;
  end;
end;

procedure TFrmDlg.DDealRemoteDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DDealRemoteDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clWhite;
      TextOut(SurfaceX(Left + 64), SurfaceY(Top + 196 - 65), GetGoldStr(DealRemoteGold));
      TextOut(SurfaceX(Left + 59 + (106 - TextWidth(DealWho)) div 2),
        SurfaceY(Top + 3) + 3, DealWho);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DDealDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DDealDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clWhite;
      TextOut(SurfaceX(Left + 64), SurfaceY(Top + 196-65-20), GetGoldStr(DealGold));
      TextOut(SurfaceX(Left + 59 + (106 - TextWidth(FrmMain.CharName)) div 2),
        SurfaceY(Top + 3) + 3, FrmMain.CharName);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DealItemReturnBag(mitem: TClientItem);
begin
  if not BoDealEnd then begin
    DealDlgItem := mitem;
    FrmMain.SendDelDealItem(DealDlgItem);
    dealactiontime := GetTickCount + 4000;
  end;
end;

procedure TFrmDlg.DDGridGridSelect(Sender: TObject; ACol, ARow: integer;
  Shift: TShiftState);
var
  temp:    TClientItem;
  mi, idx: integer;
  MsgResult, Count: integer;
  valstr:  string;
begin
  if not BoDealEnd and (GetTickCount > dealactiontime) then begin
    //2004/01/15 ItemSafeGuard..
    if not ItemMoving then begin
      //         idx := ACol + ARow * DDGrid.ColCount;
      //         if idx in [0..9] then begin
      //            if DealItems[idx].S.Name <> '' then begin
      //               ItemMoving := TRUE;
      //               MovingItem.Index := -idx - 20;
      //               MovingItem.Item := DealItems[idx];
      //               DealItems[idx].S.Name := '';
      //               ItemClickSound (MovingItem.Item.S);
      //            end;
      //         end;
    end else begin
      mi := MovingItem.Index;
      if (mi >= 0) or (mi <= -20) and (mi > -30) then begin //가방,에서 온것만
        ItemClickSound(MovingItem.Item.S);
        ItemMoving := False;
        if mi >= 0 then begin
          if MovingItem.Item.S.OverlapItem > 0 then begin

            Total := MovingItem.Item.Dura;
            if Total = 1 then begin
              DlgEditText := '1';
              MsgResult   := mrOk;
            end else
              MsgResult := DCountMsgDlg('How many out of total ' +
                IntToStr(MovingItem.Item.Dura) + ' will you put on?',
                [mbOK, mbCancel, mbAbort]);
            GetValidStrVal(DlgEditText, valstr, [' ']);
            Count := Str_ToInt(valstr, 0);
            if Count <= 0 then
              Count := 0;
            if Count > MovingItem.Item.Dura then begin
              Count := MovingItem.Item.Dura;
            end;
            ItemMoving := True;
            if MsgResult = mrOk then begin
              //and (Count > 0) and (Count < MAX_OVERLAPITEM+1 ) then begin
              DealDlgItem      := MovingItem.Item; //서버에 결과를 기다리는동안 보관
              DealDlgItem.Dura := word(Count);
              MovingItem.Item.Dura := MovingItem.Item.Dura - Count;
              if MovingItem.Item.Dura = 0 then begin
                MovingItem.Item.S.Name := '';
                ItemMoving := False;
              end;
              CancelItemMoving;
              FrmMain.SendAddDealItem(DealDlgItem);
              dealactiontime := GetTickCount + 4000;
            end else if MsgResult = mrCancel then begin
              CancelItemMoving;
              dealactiontime := GetTickCount;
            end;
          end else begin
            DealDlgItem := MovingItem.Item;
            FrmMain.SendAddDealItem(DealDlgItem);
            dealactiontime := GetTickCount + 4000;
          end;
        end else
          AddDealItem(MovingItem.Item);
        MovingItem.Item.S.Name := '';
      end;
      if mi = -98 then
        DDGoldClick(self, 0, 0);
    end;
    ArrangeItemBag;
  end;
end;

procedure TFrmDlg.DDGridGridPaint(Sender: TObject; ACol, ARow: integer;
  Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
var
  idx: integer;
  d:   TDirectDrawSurface;
begin
  idx := ACol + ARow * DDGrid.ColCount;
  if idx in [0..9] then begin
    if DealItems[idx].S.Name <> '' then begin
      d := FrmMain.WBagItem.Images[DealItems[idx].S.Looks];
      if d <> nil then
        with DDGrid do
          dsurface.Draw(SurfaceX(Rect.Left + (ColWidth - d.Width) div 2 - 1),
            SurfaceY(Rect.Top + (RowHeight - d.Height) div 2 + 1),
            d.ClientRect,
            d, True);
      // 아이템 겹치기
      if DealItems[idx].S.OverlapItem > 0 then begin
        SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
        dsurface.Canvas.Font.Color := clYellow;

        dsurface.Canvas.TextOut(DDGrid.SurfaceX(Rect.Left + 20),
          DDGrid.SurfaceY(Rect.Top + 20),
          IntToStr(DealItems[idx].Dura));
        dsurface.Canvas.Release;
      end;
    end;
  end;
end;

procedure TFrmDlg.DDGridGridMouseMove(Sender: TObject; ACol, ARow: integer;
  Shift: TShiftState);
var
  idx: integer;
begin
  idx := ACol + ARow * DDGrid.ColCount;
  if idx in [0..9] then begin
    MouseItem := DealItems[idx];
  end;
end;

procedure TFrmDlg.DDRGridGridPaint(Sender: TObject; ACol, ARow: integer;
  Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
var
  idx:  integer;
  i, k: integer;
  d:    TDirectDrawSurface;
begin

  //중복된 아이템이 있으면 없앤다.
  for i := 0 to 19 do begin
    if DealRemoteItems[i].S.Name <> '' then begin
      for k := i + 1 to 19 do begin
        if DealRemoteItems[i].S.OverlapItem > 0 then begin
          if (DealRemoteItems[i].S.Name = DealRemoteItems[k].S.Name) then
          begin //(ItemArr[i].MakeIndex <> ItemArr[k].MakeIndex) and
            DealRemoteItems[i].Dura :=
              DealRemoteItems[i].Dura + DealRemoteItems[k].Dura;
            FillChar(DealRemoteItems[k], sizeof(TClientItem), #0);
          end;
        end else if (DealRemoteItems[i].S.Name = DealRemoteItems[k].S.Name) and
          (DealRemoteItems[i].MakeIndex = DealRemoteItems[k].MakeIndex) then begin
          FillChar(DealRemoteItems[k], sizeof(TClientItem), #0);
        end;
      end;
    end;
  end;

  idx := ACol + ARow * DDRGrid.ColCount;
  if idx in [0..19] then begin
    if DealRemoteItems[idx].S.Name <> '' then begin
      d := FrmMain.WBagItem.Images[DealRemoteItems[idx].S.Looks];
      if d <> nil then
        with DDRGrid do
          dsurface.Draw(SurfaceX(Rect.Left + (ColWidth - d.Width) div 2 - 1),
            SurfaceY(Rect.Top + (RowHeight - d.Height) div 2 + 1),
            d.ClientRect,
            d, True);
      // 아이템 겹치기
      if DealRemoteItems[idx].S.OverlapItem > 0 then begin
        SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
        dsurface.Canvas.Font.Color := clYellow;

        dsurface.Canvas.TextOut(DDRGrid.SurfaceX(Rect.Left + 20),
          DDRGrid.SurfaceY(Rect.Top + 20),
          IntToStr(DealRemoteItems[idx].Dura));
        dsurface.Canvas.Release;
      end;

    end;
  end;
end;

procedure TFrmDlg.DDRGridGridMouseMove(Sender: TObject; ACol, ARow: integer;
  Shift: TShiftState);
var
  idx: integer;
begin
  idx := ACol + ARow * DDRGrid.ColCount;
  if idx in [0..19] then begin
    MouseItem := DealRemoteItems[idx];
  end;
end;

procedure TFrmDlg.DealZeroGold;
begin
  if not BoDealEnd and (DealGold > 0) then begin
    dealactiontime := GetTickCount + 4000;
    FrmMain.SendChangeDealGold(0);
  end;
end;

procedure TFrmDlg.DDGoldClick(Sender: TObject; X, Y: integer);
var
  dgold:  integer;
  valstr: string;
begin
  if Myself = nil then
    exit;
  if not BoDealEnd and (GetTickCount > dealactiontime) then begin
    if not ItemMoving then begin
      if DealGold > 0 then begin
        PlaySound(s_money);
        ItemMoving := True;
        MovingItem.Index := -97; //교환 창에서의 돈
        MovingItem.Item.S.Name := 'Gold';
      end;
    end else begin
      if (MovingItem.Index = -97) or (MovingItem.Index = -98) then begin //돈만..
        if (MovingItem.Index = -98) then begin //가방창에서 온 돈
          if MovingItem.Item.S.Name = 'Gold' then begin
            //얼마를 버릴 건지 물어본다.
            DialogSize := 1;
            ItemMoving := False;
            MovingItem.Item.S.Name := '';
            DMessageDlg('How much Gold do you want to move?', [mbOK, mbAbort]);
            GetValidStrVal(DlgEditText, valstr, [' ']);
            dgold := Str_ToInt(valstr, 0);
            if (dgold <= (DealGold + Myself.Gold)) and (dgold > 0) then begin
              FrmMain.SendChangeDealGold(dgold);
              dealactiontime := GetTickCount + 4000;
            end else
              dgold := 0;
          end;
        end;
        ItemMoving := False;
        MovingItem.Item.S.Name := '';
      end;
    end;
  end;
end;



{--------------------------------------------------------------}


procedure TFrmDlg.DUserState1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  i, l, m, pgidx, bbx, bby, idx, ax, ay, sex, hair, tx: integer;
  d: TDirectDrawSurface;
  hcolor, keyimg: integer;
  iname, d1, d2, d3, d4, str: string;
  useable: boolean;
begin
  with DUserState1 do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    //착용상태
    sex  := DRESSfeature(UserState1.Feature) mod 2;
    hair := HAIRfeature(UserState1.Feature);
    if sex = 1 then
      pgidx := 377   //여자
    else
      pgidx := 376;     //남자
    bbx := Left + 38;
    bby := Top + 52;
    d   := FrmMain.WProgUse.Images[pgidx];
    if d <> nil then
      dsurface.Draw(SurfaceX(bbx), SurfaceY(bby), d.ClientRect, d, False);
    bbx := bbx - 7;
    bby := bby + 44;

    if UserState1.UseItems[U_DRESS].S.Name <> '' then begin
      idx := UserState1.UseItems[U_DRESS].S.Looks;
      //옷 if Sex = 1 then idx := 80; //여자옷
      if idx >= 0 then begin
        d := FrmMain.WStateItem.GetCachedImage(idx, ax, ay);
        if d <> nil then
          dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay), d.ClientRect, d, True);
      end;
    end;

    //옷, 무기, 머리 스타일
    idx := 440 + hair div 2; //머리 스타일
    if sex = 1 then
      idx := 480 + hair div 2;
    if idx > 0 then begin
      d := FrmMain.WProgUse.GetCachedImage(idx, ax, ay);
      if d <> nil then
        dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay), d.ClientRect, d, True);
    end;

    if UserState1.UseItems[U_WEAPON].S.Name <> '' then begin
      idx := UserState1.UseItems[U_WEAPON].S.Looks;
      if idx >= 0 then begin
        d := FrmMain.WStateItem.GetCachedImage(idx, ax, ay);
        if d <> nil then
          dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay), d.ClientRect, d, True);
      end;
    end;
    if UserState1.UseItems[U_HELMET].S.Name <> '' then begin
      idx := UserState1.UseItems[U_HELMET].S.Looks;
      if idx >= 0 then begin
        d := FrmMain.WStateItem.GetCachedImage(idx, ax, ay);
        if d <> nil then
          dsurface.Draw(SurfaceX(bbx + ax), SurfaceY(bby + ay), d.ClientRect, d, True);
      end;
    end;


    if MouseUserStateItem.S.Name <> '' then begin
      MouseItem := MouseUserStateItem;
      GetMouseItemInfo(iname, d1, d2, d3, d4, useable, False);
      if iname <> '' then begin
        if MouseItem.Dura = 0 then
          hcolor := clRed
        //            else if MouseItem.UpgradeOpt > 0 then hcolor := clAqua //@@@@@
        else if MouseItem.UpgradeOpt > 0 then
          hcolor := TColor($cccc33)
        else
          hcolor := clWhite;
            {
            with dsurface.Canvas do begin
               SetBkMode (Handle, TRANSPARENT);
               Font.Color := clYellow;
               TextOut (SurfaceX(Left+37), SurfaceY(Top+272), iname);
               Font.Color := hcolor;
               TextOut (SurfaceX(Left+37+TextWidth(iname)), SurfaceY(Top+272), d1);
               TextOut (SurfaceX(Left+37), SurfaceY(Top+272+TextHeight('A')+2), d2);
               TextOut (SurfaceX(Left+37), SurfaceY(Top+272+(TextHeight('A')+2)*2), d3);
               Release;
            end;
            }
        // 2003/03/15 아이템 인벤토리 확장
        Str := iname + d1 + '\' + d2 + '\' + d3 + d4;
        DScreen.ShowHint(MouseX, MouseY, Str, hcolor, False);
      end;
      MouseItem.S.Name := '';
    end else if not UserState1.bExistLover then
      DScreen.ClearHint; //@@@@@

    //이름
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := UserState1.NameColor;
      TextOut(SurfaceX(Left + 122 - TextWidth(UserState1.UserName) div 2),
        SurfaceY(Top + 23), UserState1.UserName);
      Font.Color := clSilver;
      TextOut(SurfaceX(Left + 45), SurfaceY(Top + 58),
        UserState1.GuildName + ' ' + UserState1.GuildRankName);
      tx := 122 - TextWidth(UserState1.UserName) div 2;
      Release;
    end;

  end;
  DHeartImgUS.Left := tx - 14;
  DHeartImgUS.Top  := 24; //@@@@@

end;

procedure TFrmDlg.DUserState1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  X := DUserState1.LocalX(X) - DUserState1.Left;
  Y := DUserState1.LocalY(Y) - DUserState1.Top;
  if (X > 42) and (X < 201) and (Y > 54) and (Y < 71) then begin
    //DScreen.AddSysMsg (IntToStr(X) + ' ' + IntToStr(Y) + ' ' + UserState1.GuildName);
    if UserState1.GuildName <> '' then begin
      PlayScene.EdChat.Visible := True;
      PlayScene.EdChat.SetFocus;
      SetImeMode(PlayScene.EdChat.Handle, LocalLanguage);
      PlayScene.EdChat.Text      := UserState1.GuildName;
      PlayScene.EdChat.SelStart  := Length(PlayScene.EdChat.Text);
      PlayScene.EdChat.SelLength := 0;
    end;
  end else if (X > 80) and (X < 160) and (Y > 18) and (Y < 38) then begin
    if UserState1.UserName <> '' then begin
      PlayScene.EdChat.Visible := True;
      PlayScene.EdChat.SetFocus;
      SetImeMode(PlayScene.EdChat.Handle, LocalLanguage);
      PlayScene.EdChat.Text      := '/' + UserState1.UserName + ' ';
      PlayScene.EdChat.SelStart  := Length(PlayScene.EdChat.Text);
      PlayScene.EdChat.SelLength := 0;
    end;
  end;

end;

procedure TFrmDlg.DUserState1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  MouseUserStateItem.S.Name := '';
  if UserState1.bExistLover then begin //@@@@@
    X := DUserState1.LocalX(X) - DUserState1.Left;
    Y := DUserState1.LocalY(Y) - DUserState1.Top;
    if (X > 80) and (X < 160) and (Y > 18) and (Y < 38) then
      DScreen.ShowHint(DUserState1.Left + DHeartImgUS.Left + 10,
        DUserState1.Top + DHeartImgUS.Top + 14,
        UserState1.LoverName + '''s lover', clYellow, False)
    else
      DScreen.ClearHint;
  end;

end;


procedure TFrmDlg.DWeaponUS1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  sel: integer;
begin
  sel := -1;
  if Sender = DDressUS1 then
    sel := U_DRESS;
  if Sender = DWeaponUS1 then
    sel := U_WEAPON;
  if Sender = DHelmetUS1 then
    sel := U_HELMET;
  if Sender = DNecklaceUS1 then
    sel := U_NECKLACE;
  if Sender = DLightUS1 then
    sel := U_RIGHTHAND;
  if Sender = DRingLUS1 then
    sel := U_RINGL;
  if Sender = DRingRUS1 then
    sel := U_RINGR;
  if Sender = DArmRingLUS1 then
    sel := U_ARMRINGL;
  if Sender = DArmRingRUS1 then
    sel := U_ARMRINGR;
  // 2003/03/15 아이템 인벤토리 확장
  if Sender = DBujukUS1 then
    sel := U_BUJUK;
  if Sender = DBeltUS1 then
    sel := U_BELT;
  if Sender = DBootsUS1 then
    sel := U_BOOTS;
  if Sender = DCharmUS1 then
    sel := U_CHARM;

  if sel >= 0 then begin
    MouseUserStateItem := UserState1.UseItems[sel];
    // 2003/03/15 아이템 인벤토리 확장
    MouseX := DUserState1.Left + X;
    MouseY := DUserState1.Top + Y;
  end;

end;

procedure TFrmDlg.DCloseUS1Click(Sender: TObject; X, Y: integer);
begin
  DUserState1.Visible := False;
end;

procedure TFrmDlg.DNecklaceUS1DirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  idx: integer;
  d:   TDirectDrawSurface;
begin
  if Sender = DNecklaceUS1 then begin
    if UserState1.UseItems[U_NECKLACE].S.Name <> '' then begin
      idx := UserState1.UseItems[U_NECKLACE].S.Looks;
      if idx >= 0 then begin
        d := FrmMain.WStateItem.Images[idx];
        if d <> nil then
          dsurface.Draw(DNecklaceUS1.SurfaceX(DNecklaceUS1.Left +
            (DNecklaceUS1.Width - d.Width) div 2),
            DNecklaceUS1.SurfaceY(DNecklaceUS1.Top +
            (DNecklaceUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  if Sender = DLightUS1 then begin
    if UserState1.UseItems[U_RIGHTHAND].S.Name <> '' then begin
      idx := UserState1.UseItems[U_RIGHTHAND].S.Looks;
      if idx >= 0 then begin
        d := FrmMain.WStateItem.Images[idx];
        if d <> nil then
          dsurface.Draw(DLightUS1.SurfaceX(DLightUS1.Left +
            (DLightUS1.Width - d.Width) div 2),
            DLightUS1.SurfaceY(DLightUS1.Top +
            (DLightUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  if Sender = DArmRingRUS1 then begin
    if UserState1.UseItems[U_ARMRINGR].S.Name <> '' then begin
      idx := UserState1.UseItems[U_ARMRINGR].S.Looks;
      if idx >= 0 then begin
        d := FrmMain.WStateItem.Images[idx];
        if d <> nil then
          dsurface.Draw(DArmRingRUS1.SurfaceX(DArmRingRUS1.Left +
            (DArmRingRUS1.Width - d.Width) div 2),
            DArmRingRUS1.SurfaceY(DArmRingRUS1.Top +
            (DArmRingRUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  if Sender = DArmRingLUS1 then begin
    if UserState1.UseItems[U_ARMRINGL].S.Name <> '' then begin
      idx := UserState1.UseItems[U_ARMRINGL].S.Looks;
      if idx >= 0 then begin
        d := FrmMain.WStateItem.Images[idx];
        if d <> nil then
          dsurface.Draw(DArmRingLUS1.SurfaceX(DArmRingLUS1.Left +
            (DArmRingLUS1.Width - d.Width) div 2),
            DArmRingLUS1.SurfaceY(DArmRingLUS1.Top +
            (DArmRingLUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  if Sender = DRingRUS1 then begin
    if UserState1.UseItems[U_RINGR].S.Name <> '' then begin
      idx := UserState1.UseItems[U_RINGR].S.Looks;
      if idx >= 0 then begin
        d := FrmMain.WStateItem.Images[idx];
        if d <> nil then
          dsurface.Draw(DRingRUS1.SurfaceX(DRingRUS1.Left +
            (DRingRUS1.Width - d.Width) div 2),
            DRingRUS1.SurfaceY(DRingRUS1.Top +
            (DRingRUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  if Sender = DRingLUS1 then begin
    if UserState1.UseItems[U_RINGL].S.Name <> '' then begin
      idx := UserState1.UseItems[U_RINGL].S.Looks;
      if idx >= 0 then begin
        d := FrmMain.WStateItem.Images[idx];
        if d <> nil then
          dsurface.Draw(DRingLUS1.SurfaceX(DRingLUS1.Left +
            (DRingLUS1.Width - d.Width) div 2),
            DRingLUS1.SurfaceY(DRingLUS1.Top +
            (DRingLUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  // 2003/03/15 아이템 인벤토리 확장
  if Sender = DBujukUS1 then begin
    if UserState1.UseItems[U_BUJUK].S.Name <> '' then begin
      idx := UserState1.UseItems[U_BUJUK].S.Looks;
      if idx >= 0 then begin
        d := FrmMain.WStateItem.Images[idx];
        if d <> nil then
          dsurface.Draw(DBujukUS1.SurfaceX(DBujukUS1.Left +
            (DBujukUS1.Width - d.Width) div 2),
            DBujukUS1.SurfaceY(DBujukUS1.Top +
            (DBujukUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  if Sender = DBeltUS1 then begin
    if UserState1.UseItems[U_BELT].S.Name <> '' then begin
      idx := UserState1.UseItems[U_BELT].S.Looks;
      if idx >= 0 then begin
        d := FrmMain.WStateItem.Images[idx];
        if d <> nil then
          dsurface.Draw(DBeltUS1.SurfaceX(DBeltUS1.Left +
            (DBeltUS1.Width - d.Width) div 2),
            DBeltUS1.SurfaceY(DBeltUS1.Top + (DBeltUS1.Height -
            d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  if Sender = DBootsUS1 then begin
    if UserState1.UseItems[U_BOOTS].S.Name <> '' then begin
      idx := UserState1.UseItems[U_BOOTS].S.Looks;
      if idx >= 0 then begin
        d := FrmMain.WStateItem.Images[idx];
        if d <> nil then
          dsurface.Draw(DBootsUS1.SurfaceX(DBootsUS1.Left +
            (DBootsUS1.Width - d.Width) div 2),
            DBootsUS1.SurfaceY(DBootsUS1.Top +
            (DBootsUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;
  if Sender = DCharmUS1 then begin
    if UserState1.UseItems[U_CHARM].S.Name <> '' then begin
      idx := UserState1.UseItems[U_CHARM].S.Looks;
      if idx >= 0 then begin
        d := FrmMain.WStateItem.Images[idx];
        if d <> nil then
          dsurface.Draw(DCharmUS1.SurfaceX(DCharmUS1.Left +
            (DCharmUS1.Width - d.Width) div 2),
            DCharmUS1.SurfaceY(DCharmUS1.Top +
            (DCharmUS1.Height - d.Height) div 2),
            d.ClientRect, d, True);
      end;
    end;
  end;

end;


procedure TFrmDlg.ShowGuildDlg;
begin
  DGuildDlg.Visible := True;  //not DGuildDlg.Visible;
  DGuildDlg.Top     := -3;
  DGuildDlg.Left    := 0;
  if DGuildDlg.Visible then begin
    if GuildCommanderMode then begin
      DGDAddMem.Visible := True;
      DGDDelMem.Visible := True;
      DGDEditNotice.Visible := True;
      DGDEditGrade.Visible := True;
      DGDAlly.Visible := True;
      DGDBreakAlly.Visible := True;
      DGDWar.Visible := True;
      DGDCancelWar.Visible := True;
    end else begin
      DGDAddMem.Visible := False;
      DGDDelMem.Visible := False;
      DGDEditNotice.Visible := False;
      DGDEditGrade.Visible := False;
      DGDAlly.Visible := False;
      DGDBreakAlly.Visible := False;
      DGDWar.Visible := False;
      DGDCancelWar.Visible := False;
    end;

  end;
  GuildTopLine := 0;
end;

procedure TFrmDlg.ShowGuildEditNotice;
var
  d:    TDirectDrawSurface;
  i:    integer;
  Data: string;
begin
  with DGuildEditNotice do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then begin
      Left := (SCREENWIDTH - d.Width) div 2;
      Top  := (SCREENHEIGHT - d.Height) div 2;
    end;
    HideAllControls;
    DGuildEditNotice.ShowModal;

    Memo.Left   := SurfaceX(Left + 16);
    Memo.Top    := SurfaceY(Top + 36);
    Memo.Width  := 571;
    Memo.Height := 246;
    Memo.Lines.Assign(GuildNotice);
    Memo.ReadOnly := False;
    Memo.Visible  := True;

    while True do begin
      if not DGuildEditNotice.Visible then
        break;
      FrmMain.DXTimerTimer (self, 0);
      //FrmMain.ProcOnIdle;
      Application.ProcessMessages;
      if Application.Terminated then
        exit;
    end;

    DGuildEditNotice.Visible := False;
    RestoreHideControls;

    if DMsgDlg.DialogResult = mrOk then begin
      //결과... 문파공지사항을 업데이트 한다.
      Data := '';
      for i := 0 to Memo.Lines.Count - 1 do begin
        if Memo.Lines[i] = '' then
          Data := Data + Memo.Lines[i] + ' '#13
        else
          Data := Data + Memo.Lines[i] + #13;
      end;
      if Length(Data) > 4000 then begin
        Data := Copy(Data, 1, 4000);
        DMessageDlg('Last part was removed due to long length of sentence.',
          [mbOK]);
      end;
      FrmMain.SendGuildUpdateNotice(Data);
    end;
  end;
end;

procedure TFrmDlg.ShowGuildEditGrade;
var
  d:    TDirectDrawSurface;
  Data: string;
  i:    integer;
begin
  if GuildMembers.Count <= 0 then begin
    DMessageDlg('Press button [LIST] to call up information on Guild members.',
      [mbOK]);
    exit;
  end;

  with DGuildEditNotice do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then begin
      Left := (SCREENWIDTH - d.Width) div 2;
      Top  := (SCREENHEIGHT - d.Height) div 2;
    end;
    HideAllControls;
    DGuildEditNotice.ShowModal;

    Memo.Left   := SurfaceX(Left + 16);
    Memo.Top    := SurfaceY(Top + 36);
    Memo.Width  := 571;
    Memo.Height := 246;
    Memo.Lines.Assign(GuildMembers);
    Memo.Visible := True;

    while True do begin
      if not DGuildEditNotice.Visible then
        break;
      FrmMain.DXTimerTimer (self, 0);
      //FrmMain.ProcOnIdle;
      Application.ProcessMessages;
      if Application.Terminated then
        exit;
    end;

    DGuildEditNotice.Visible := False;
    RestoreHideControls;

    if DMsgDlg.DialogResult = mrOk then begin
      //GuildMembers.Assign (Memo.Lines);
      //결과... 문파등급을 업데이트 한다.
      Data := '';
      for i := 0 to Memo.Lines.Count - 1 do begin
        Data := Data + Memo.Lines[i] + #13;  //서버에서 파싱함.
      end;
      if Length(Data) > 5000 then begin
        Data := Copy(Data, 1, 5000);
        DMessageDlg('Last part was removed due to long length of sentence.',
          [mbOK]);
      end;
      FrmMain.SendGuildUpdateGrade(Data);
    end;
  end;
end;

procedure TFrmDlg.DGuildDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  i, n, bx, by: integer;
begin
  with DGuildDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clWhite;
      TextOut(Left + 320, Top + 13, Guild);

      bx := Left + 24;
      by := Top + 41;
      for i := GuildTopLine to GuildStrs.Count - 1 do begin
        n := i - GuildTopLine;
        if n * 14 > 356 then
          break;
        if integer(GuildStrs.Objects[i]) <> 0 then
          Font.Color := TColor(GuildStrs.Objects[i])
        else begin
          if BoGuildChat then
            Font.Color := GetRGB(2)
          else
            Font.Color := clSilver;
        end;
        TextOut(bx, by + n * 14, GuildStrs[i]);
      end;

      Release;
    end;

  end;
end;

procedure TFrmDlg.DGDUpClick(Sender: TObject; X, Y: integer);
begin
  if GuildTopLine > 0 then
    Dec(GuildTopLine, 3);
  if GuildTopLine < 0 then
    GuildTopLine := 0;
end;

procedure TFrmDlg.DGDDownClick(Sender: TObject; X, Y: integer);
begin
  if GuildTopLine + 12 < GuildStrs.Count then
    Inc(GuildTopLine, 3);
end;

procedure TFrmDlg.DGDCloseClick(Sender: TObject; X, Y: integer);
begin
  DGuildDlg.Visible := False;
  BoGuildChat := False;
end;

procedure TFrmDlg.DGDHomeClick(Sender: TObject; X, Y: integer);
begin
  if GetTickCount > querymsgtime then begin
    querymsgtime := GetTickCount + 3000;
    FrmMain.SendGuildHome;
    BoGuildChat := False;
  end;
end;

procedure TFrmDlg.DGDListClick(Sender: TObject; X, Y: integer);
begin
  if GetTickCount > querymsgtime then begin
    querymsgtime := GetTickCount + 3000;
    FrmMain.SendGuildMemberList;
    BoGuildChat := False;
  end;
end;

procedure TFrmDlg.DGDAddMemClick(Sender: TObject; X, Y: integer);
begin
  DMessageDlg(Guild + 'Type character name you want to add as Guild Member.',
    [mbOK, mbAbort]);
  if DlgEditText <> '' then
    FrmMain.SendGuildAddMem(DlgEditText);
end;

procedure TFrmDlg.DGDDelMemClick(Sender: TObject; X, Y: integer);
begin
  DMessageDlg(Guild + 'Type character name you want to delete from Guild',
    [mbOK, mbAbort]);
  if DlgEditText <> '' then
    FrmMain.SendGuildDelMem(DlgEditText);
end;

procedure TFrmDlg.DGDEditNoticeClick(Sender: TObject; X, Y: integer);
begin
  GuildEditHint := '[amend Notice contents of Guild.]';
  ShowGuildEditNotice;
end;

procedure TFrmDlg.DGDEditGradeClick(Sender: TObject; X, Y: integer);
begin
  GuildEditHint :=
    '[amend rank and position of Guild Member . # caution : unable to AddGuildMem/DelGuilMem]';
  ShowGuildEditGrade;
end;

procedure TFrmDlg.DGDAllyClick(Sender: TObject; X, Y: integer);
begin
  if mrOk = DMessageDlg(
    'To make alliance opponent Guild should be under the state of [AbleToAlly]\' +
    'and you should face with opponent Guild chief.\' +
    'Would you like to make alliance?', [mbOK, mbCancel]) then
    FrmMain.SendSay('@Alliance');
end;

procedure TFrmDlg.DGDBreakAllyClick(Sender: TObject; X, Y: integer);
begin
  DMessageDlg('Please type the name of Guild you want to cancel alliance.',
    [mbOK, mbAbort]);
  if DlgEditText <> '' then
    FrmMain.SendSay('@CancelAlliance ' + DlgEditText);
end;



procedure TFrmDlg.DGuildEditNoticeDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DGuildEditNotice do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clSilver;

      TextOut(Left + 18, Top + 291, GuildEditHint);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DGECloseClick(Sender: TObject; X, Y: integer);
begin
  DGuildEditNotice.Visible := False;
  Memo.Visible := False;
  DMsgDlg.DialogResult := mrCancel;
end;

procedure TFrmDlg.DGEOkClick(Sender: TObject; X, Y: integer);
begin
  DGECloseClick(self, 0, 0);
  DMsgDlg.DialogResult := mrOk;
end;

procedure TFrmDlg.AddGuildChat(str: string);
var
  i: integer;
begin
  GuildChats.Add(str);
  if GuildChats.Count > 500 then begin
    for i := 0 to 100 do
      GuildChats.Delete(0);
  end;
  if BoGuildChat then
    GuildStrs.Assign(GuildChats);
end;

procedure TFrmDlg.DGDChatClick(Sender: TObject; X, Y: integer);
begin
  BoGuildChat := not BoGuildChat;
  if BoGuildChat then begin
    GuildStrs2.Assign(GuildStrs);
    GuildStrs.Assign(GuildChats);
  end else
    GuildStrs.Assign(GuildStrs2);
end;

procedure TFrmDlg.DGoldDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  if Myself = nil then
    exit;
  with DGold do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
  end;
end;


 {--------------------------------------------------------------}
 //능력치 조정 창

procedure TFrmDlg.DAdjustAbilCloseClick(Sender: TObject; X, Y: integer);
begin
  DAdjustAbility.Visible := False;
  BonusPoint := SaveBonusPoint;
end;

procedure TFrmDlg.DAdjustAbilityDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);

  procedure AdjustAb(abil: byte; val: word; var lov, hiv: byte);
  var
    lo, hi: byte;
    i:      integer;
  begin
    lo  := Lobyte(abil);
    hi  := Hibyte(abil);
    lov := 0;
    hiv := 0;
    for i := 1 to val do begin
      if lo + 1 < hi then begin
        Inc(lo);
        Inc(lov);
      end else begin
        Inc(hi);
        Inc(hiv);
      end;
    end;
  end;

var
  d: TDirectDrawSurface;
  l, m, adc, amc, asc, aac, amac: integer;
  ldc, lmc, lsc, lac, lmac, hdc, hmc, hsc, hac, hmac: byte;
begin
  if Myself = nil then
    exit;
  with dsurface.Canvas do begin
    with DAdjustAbility do begin
      d := DMenuDlg.WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;

    SetBkMode(Handle, TRANSPARENT);
    Font.Color := clSilver;

    l := DAdjustAbility.SurfaceX(DAdjustAbility.Left) + 36;
    m := DAdjustAbility.SurfaceY(DAdjustAbility.Top) + 22;

    TextOut(l, m, 'Congratulations: you are moved up to the next level!.');
    TextOut(l, m + 14, 'Choose the ability you want to raise');
    TextOut(l, m + 14 * 2, 'You can choose only one time so');
    TextOut(l, m + 14 * 3, 'It is better to choose very carefully.');

    Font.Color := clWhite;
    //현재의 능력치
    l := DAdjustAbility.SurfaceX(DAdjustAbility.Left) + 100; //66;
    m := DAdjustAbility.SurfaceY(DAdjustAbility.Top) + 101;

    adc  := (BonusAbil.DC + BonusAbilChg.DC) div BonusTick.DC;
    amc  := (BonusAbil.MC + BonusAbilChg.MC) div BonusTick.MC;
    asc  := (BonusAbil.SC + BonusAbilChg.SC) div BonusTick.SC;
    aac  := (BonusAbil.AC + BonusAbilChg.AC) div BonusTick.AC;
    amac := (BonusAbil.MAC + BonusAbilChg.MAC) div BonusTick.MAC;

    AdjustAb(NakedAbil.DC, adc, ldc, hdc);
    AdjustAb(NakedAbil.MC, amc, lmc, hmc);
    AdjustAb(NakedAbil.SC, asc, lsc, hsc);
    //AdjustAb (NakedAbil.AC, aac, lac, hac);
    //AdjustAb (NakedAbil.MAC, amac, lmac, hmac);
    lac  := 0;
    hac  := aac;
    lmac := 0;
    hmac := amac;

    TextOut(l + 0, m + 0, IntToStr(Lobyte(Myself.Abil.DC) + ldc) +
      '-' + IntToStr(Hibyte(Myself.Abil.DC) + hdc));
    TextOut(l + 0, m + 20, IntToStr(Lobyte(Myself.Abil.MC) + lmc) +
      '-' + IntToStr(Hibyte(Myself.Abil.MC) + hmc));
    TextOut(l + 0, m + 40, IntToStr(Lobyte(Myself.Abil.SC) + lsc) +
      '-' + IntToStr(Hibyte(Myself.Abil.SC) + hsc));
    TextOut(l + 0, m + 60, IntToStr(Lobyte(Myself.Abil.AC) + lac) +
      '-' + IntToStr(Hibyte(Myself.Abil.AC) + hac));
    TextOut(l + 0, m + 80, IntToStr(Lobyte(Myself.Abil.MAC) + lmac) +
      '-' + IntToStr(Hibyte(Myself.Abil.MAC) + hmac));
    TextOut(l + 0, m + 100, IntToStr(Myself.Abil.MaxHP +
      (BonusAbil.HP + BonusAbilChg.HP) div BonusTick.HP));
    TextOut(l + 0, m + 120, IntToStr(Myself.Abil.MaxMP +
      (BonusAbil.MP + BonusAbilChg.MP) div BonusTick.MP));
    TextOut(l + 0, m + 140, IntToStr(MyHitPoint + (BonusAbil.Hit + BonusAbilChg.Hit) div
      BonusTick.Hit));
    TextOut(l + 0, m + 160, IntToStr(MySpeedPoint +
      (BonusAbil.Speed + BonusAbilChg.Speed) div BonusTick.Speed));

    Font.Color := clYellow;
    TextOut(l + 0, m + 180, IntToStr(BonusPoint));

    Font.Color := clWhite;
    l := DAdjustAbility.SurfaceX(DAdjustAbility.Left) + 155; //66;
    m := DAdjustAbility.SurfaceY(DAdjustAbility.Top) + 101;

    if BonusAbilChg.DC > 0 then
      Font.Color := clWhite
    else
      Font.Color := clSilver;
    TextOut(l + 0, m + 0, IntToStr(BonusAbilChg.DC + BonusAbil.DC) +
      '/' + IntToStr(BonusTick.DC));

    if BonusAbilChg.MC > 0 then
      Font.Color := clWhite
    else
      Font.Color := clSilver;
    TextOut(l + 0, m + 20, IntToStr(BonusAbilChg.MC + BonusAbil.MC) +
      '/' + IntToStr(BonusTick.MC));

    if BonusAbilChg.SC > 0 then
      Font.Color := clWhite
    else
      Font.Color := clSilver;
    TextOut(l + 0, m + 40, IntToStr(BonusAbilChg.SC + BonusAbil.SC) +
      '/' + IntToStr(BonusTick.SC));

    if BonusAbilChg.AC > 0 then
      Font.Color := clWhite
    else
      Font.Color := clSilver;
    TextOut(l + 0, m + 60, IntToStr(BonusAbilChg.AC + BonusAbil.AC) +
      '/' + IntToStr(BonusTick.AC));

    if BonusAbilChg.MAC > 0 then
      Font.Color := clWhite
    else
      Font.Color := clSilver;
    TextOut(l + 0, m + 80, IntToStr(BonusAbilChg.MAC + BonusAbil.MAC) +
      '/' + IntToStr(BonusTick.MAC));

    if BonusAbilChg.HP > 0 then
      Font.Color := clWhite
    else
      Font.Color := clSilver;
    TextOut(l + 0, m + 100, IntToStr(BonusAbilChg.HP + BonusAbil.HP) +
      '/' + IntToStr(BonusTick.HP));

    if BonusAbilChg.MP > 0 then
      Font.Color := clWhite
    else
      Font.Color := clSilver;
    TextOut(l + 0, m + 120, IntToStr(BonusAbilChg.MP + BonusAbil.MP) +
      '/' + IntToStr(BonusTick.MP));

    if BonusAbilChg.Hit > 0 then
      Font.Color := clWhite
    else
      Font.Color := clSilver;
    TextOut(l + 0, m + 140, IntToStr(BonusAbilChg.Hit + BonusAbil.Hit) +
      '/' + IntToStr(BonusTick.Hit));

    if BonusAbilChg.Speed > 0 then
      Font.Color := clWhite
    else
      Font.Color := clSilver;
    TextOut(l + 0, m + 160, IntToStr(BonusAbilChg.Speed + BonusAbil.Speed) +
      '/' + IntToStr(BonusTick.Speed));

    Release;
  end;

end;

procedure TFrmDlg.DPlusDCClick(Sender: TObject; X, Y: integer);
var
  incp: integer;
begin
  if BonusPoint > 0 then begin
    if IsKeyPressed(VK_CONTROL) and (BonusPoint > 10) then
      incp := 10
    else
      incp := 1;
    Dec(BonusPoint, incp);
    if Sender = DPlusDC then
      Inc(BonusAbilChg.DC, incp);
    if Sender = DPlusMC then
      Inc(BonusAbilChg.MC, incp);
    if Sender = DPlusSC then
      Inc(BonusAbilChg.SC, incp);
    if Sender = DPlusAC then
      Inc(BonusAbilChg.AC, incp);
    if Sender = DPlusMAC then
      Inc(BonusAbilChg.MAC, incp);
    if Sender = DPlusHP then
      Inc(BonusAbilChg.HP, incp);
    if Sender = DPlusMP then
      Inc(BonusAbilChg.MP, incp);
    if Sender = DPlusHit then
      Inc(BonusAbilChg.Hit, incp);
    if Sender = DPlusSpeed then
      Inc(BonusAbilChg.Speed, incp);
  end;
end;

procedure TFrmDlg.DMinusDCClick(Sender: TObject; X, Y: integer);
var
  decp: integer;
begin
  if IsKeyPressed(VK_CONTROL) and (BonusPoint - 10 > 0) then
    decp := 10
  else
    decp := 1;
  if Sender = DMinusDC then
    if BonusAbilChg.DC >= decp then begin
      Dec(BonusAbilChg.DC, decp);
      Inc(BonusPoint, decp);
    end;
  if Sender = DMinusMC then
    if BonusAbilChg.MC >= decp then begin
      Dec(BonusAbilChg.MC, decp);
      Inc(BonusPoint, decp);
    end;
  if Sender = DMinusSC then
    if BonusAbilChg.SC >= decp then begin
      Dec(BonusAbilChg.SC, decp);
      Inc(BonusPoint, decp);
    end;
  if Sender = DMinusAC then
    if BonusAbilChg.AC >= decp then begin
      Dec(BonusAbilChg.AC, decp);
      Inc(BonusPoint, decp);
    end;
  if Sender = DMinusMAC then
    if BonusAbilChg.MAC >= decp then begin
      Dec(BonusAbilChg.MAC, decp);
      Inc(BonusPoint, decp);
    end;
  if Sender = DMinusHP then
    if BonusAbilChg.HP >= decp then begin
      Dec(BonusAbilChg.HP, decp);
      Inc(BonusPoint, decp);
    end;
  if Sender = DMinusMP then
    if BonusAbilChg.MP >= decp then begin
      Dec(BonusAbilChg.MP, decp);
      Inc(BonusPoint, decp);
    end;
  if Sender = DMinusHit then
    if BonusAbilChg.Hit >= decp then begin
      Dec(BonusAbilChg.Hit, decp);
      Inc(BonusPoint, decp);
    end;
  if Sender = DMinusSpeed then
    if BonusAbilChg.Speed >= decp then begin
      Dec(BonusAbilChg.Speed, decp);
      Inc(BonusPoint, decp);
    end;
end;

procedure TFrmDlg.DAdjustAbilOkClick(Sender: TObject; X, Y: integer);
begin
  FrmMain.SendAdjustBonus(BonusPoint, BonusAbilChg);
  DAdjustAbility.Visible := False;
end;

procedure TFrmDlg.DAdjustAbilityMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  i, lx, ly: integer;
  flag:      boolean;
begin
  with DAdjustAbility do begin
    lx   := LocalX(X - Left);
    ly   := LocalY(Y - Top);
    flag := False;
    if (lx >= 50) and (lx < 150) then
      for i := 0 to 8 do begin  //DC,MC,SC..의 힌트가 나오게 한다.
        if (ly >= 98 + i * 20) and (ly < 98 + (i + 1) * 20) then begin
          DScreen.ShowHint(SurfaceX(Left) + lx + 10,
            SurfaceY(Top) + ly + 5,
            AdjustAbilHints[i],
            clWhite,
            False);
          flag := True;
          break;
        end;
      end;
    if not flag then
      DScreen.ClearHint;
  end;
end;

procedure TFrmDlg.DSServer1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  oldsize, down: integer;
begin
  with Sender as TDButton do begin
    if not Downed then begin
      d    := WLib.Images[FaceIndex];
      down := 0;
    end else begin
      d    := WLib.Images[FaceIndex + 1];
      down := 1;
    end;
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);


    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    oldsize := dsurface.Canvas.Font.Size;
    dsurface.Canvas.Font.Size := 12;
    dsurface.Canvas.Font.Style := [fsBold];

    BoldTextOut(dsurface,
      SurfaceX(Left) + (TDButton(Sender).Width -
      dsurface.Canvas.TextWidth(TDButton(Sender).Caption)) div 2 + down,
      SurfaceY(Top) + (TDButton(Sender).Height -
      dsurface.Canvas.TextHeight(TDButton(Sender).Caption)) div 2 + down,
      GetRGB(150), //RGB(253, 192, 75),
      clBlack,
      TDButton(Sender).Caption);

    dsurface.Canvas.Font.Size  := oldsize;
    dsurface.Canvas.Font.Style := [];
    dsurface.Canvas.Release;

  end;

end;

procedure TFrmDlg.DBotExitMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DBotExit do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    //      if (X < SurfaceX(Left)) or (X > SurfaceX(Left+Width)) or (Y < SurfaceY(Top)) or (Y > SurfaceY(Top+Height)) then begin
    //         DScreen.ClearHint;
    //      end
    //      else begin
    sx := SurfaceX(Left) + DBottom.SurfaceX(DBottom.Left) + lx + 8;
    sy := SurfaceY(Top) + DBottom.SurfaceX(DBottom.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Exit\Alt-Q', clYellow, False);
    //      end;
  end;
end;

procedure TFrmDlg.DBotGroupMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DBotGroup do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    //      if (X < SurfaceX(Left)) or (X > SurfaceX(Left+Width)) or (Y < SurfaceY(Top)) or (Y > SurfaceY(Top+Height)) then begin
    //         DScreen.ClearHint;
    //      end
    //      else begin
    sx := SurfaceX(Left) + DBottom.SurfaceX(DBottom.Left) + lx + 8;
    sy := SurfaceY(Top) + DBottom.SurfaceX(DBottom.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Party(P)', clYellow, False);
    //      end;
  end;
end;

procedure TFrmDlg.DBotLogoutMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DBotLogout do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    //      if (X < SurfaceX(Left)) or (X > SurfaceX(Left+Width)) or (Y < SurfaceY(Top)) or (Y > SurfaceY(Top+Height)) then begin
    //         DScreen.ClearHint;
    //      end
    //      else begin
    sx := SurfaceX(Left) + DBottom.SurfaceX(DBottom.Left) + lx + 8;
    sy := SurfaceY(Top) + DBottom.SurfaceX(DBottom.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'LogOut\Alt-X', clYellow, False);
    //      end;
  end;
end;

procedure TFrmDlg.DBotMiniMapMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DBotMiniMap do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    //      if (X < SurfaceX(Left)) or (X > SurfaceX(Left+Width)) or (Y < SurfaceY(Top)) or (Y > SurfaceY(Top+Height)) then begin
    //         DScreen.ClearHint;
    //      end
    //      else begin
    sx := SurfaceX(Left) + DBottom.SurfaceX(DBottom.Left) + lx + 8;
    sy := SurfaceY(Top) + DBottom.SurfaceX(DBottom.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'View(V)', clYellow, False);
    //      end;
  end;
end;

procedure TFrmDlg.DBotTradeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DBotTrade do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    //      if (X < SurfaceX(Left)) or (X > SurfaceX(Left+Width)) or (Y < SurfaceY(Top)) or (Y > SurfaceY(Top+Height)) then begin
    //         DScreen.ClearHint;
    //      end
    //      else begin
    sx := SurfaceX(Left) + DBottom.SurfaceX(DBottom.Left) + lx + 8;
    sy := SurfaceY(Top) + DBottom.SurfaceX(DBottom.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Trade(T)', clYellow, False);
    //      end;
  end;
end;

procedure TFrmDlg.DBotGuildMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DBotGuild do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    //      if (X < SurfaceX(Left)) or (X > SurfaceX(Left+Width)) or (Y < SurfaceY(Top)) or (Y > SurfaceY(Top+Height)) then begin
    //         DScreen.ClearHint;
    //      end
    //      else begin
    sx := SurfaceX(Left) + DBottom.SurfaceX(DBottom.Left) + lx + 8;
    sy := SurfaceY(Top) + DBottom.SurfaceX(DBottom.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Guild(G)', clYellow, False);
    //      end;
  end;
end;

procedure TFrmDlg.DMyStateMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DMyState do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    //      if (X < SurfaceX(Left)) or (X > SurfaceX(Left+Width)) or (Y < SurfaceY(Top)) or (Y > SurfaceY(Top+Height)) then begin
    //         DScreen.ClearHint;
    //      end
    //      else begin
    sx := SurfaceX(Left) + DBottom.SurfaceX(DBottom.Left) + lx + 8;
    sy := SurfaceY(Top) + DBottom.SurfaceX(DBottom.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'CharacterStatus(F10,C)', clYellow, False);
    //      end;
  end;
end;

procedure TFrmDlg.DMyBagMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DMyBag do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    //      if (X < SurfaceX(Left)) or (X > SurfaceX(Left+Width)) or (Y < SurfaceY(Top)) or (Y > SurfaceY(Top+Height)) then begin
    //         DScreen.ClearHint;
    //      end
    //      else begin
    sx := SurfaceX(Left) + DBottom.SurfaceX(DBottom.Left) + lx + 8;
    sy := SurfaceY(Top) + DBottom.SurfaceX(DBottom.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Inventory(F9,I)', clYellow, False);
    //      end;
  end;
end;

procedure TFrmDlg.DMyMagicMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DMyMagic do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    //      if (X < SurfaceX(Left)) or (X > SurfaceX(Left+Width)) or (Y < SurfaceY(Top)) or (Y > SurfaceY(Top+Height)) then begin
    //         DScreen.ClearHint;
    //      end
    //      else begin
    sx := SurfaceX(Left) + DBottom.SurfaceX(DBottom.Left) + lx + 8;
    sy := SurfaceY(Top) + DBottom.SurfaceX(DBottom.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Skill(F11,S)', clYellow, False);
    //      end;
  end;
end;

procedure TFrmDlg.DOptionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DOption do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    //      if (X < SurfaceX(Left)) or (X > SurfaceX(Left+Width)) or (Y < SurfaceY(Top)) or (Y > SurfaceY(Top+Height)) then begin
    //         DScreen.ClearHint;
    //      end
    //      else begin
    sx := SurfaceX(Left) + DBottom.SurfaceX(DBottom.Left) + lx + 8;
    sy := SurfaceY(Top) + DBottom.SurfaceX(DBottom.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'SoundEffect', clYellow, False);
    //      end;
  end;
end;

procedure TFrmDlg.DBottomMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
  flag:   boolean;
  s:      string;
begin
  flag := False;
  with DBottom do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + lx;
    sy := SurfaceY(Top) + ly;

    //    DScreen.AddSysMsg(IntToStr(lx)+'/'+IntToStr(ly));

{      if (lx>39) and (lx<39+90) and (ly>90) and (ly<180) then begin
         flag := TRUE;
         sx := SurfaceX(Left)+lx;
         sy := SurfaceY(Top) +ly;
         s  := 'HP('+IntToStr(Myself.Abil.HP)+'/'+IntToStr(Myself.Abil.MaxHP)+')';
         if (Myself.Job <> 0) or (Myself.Abil.Level >= 26) then begin
             s := s+ '\MP('+IntToStr(Myself.Abil.MP)+'/'+IntToStr(Myself.Abil.MaxMP)+')';
         end;
         DScreen.ShowHint(sx, sy, s, clYellow, FALSE);
      end;}
    if (lx > 666) and (lx < 666 + 40) and (ly > 145) and (ly < 145 + 10) then begin
      flag := True;
      sx   := 666;
      sy   := 496;
      DScreen.ShowHint(sx, sy, 'Level', clYellow, False);
    end;
    if (lx > 666) and (lx < 666 + 40) and (ly > 180) and (ly < 180 + 10) then begin
      flag := True;
      sx   := 666;
      sy   := 526;
      //         s  := Format('%2.2f',[Myself.Abil.Exp/Myself.Abil.MaxExp*100]);
      s    := IntToStr(Myself.Abil.Exp) + '/' + IntToStr(Myself.Abil.MaxExp); //@@@@
      DScreen.ShowHint(sx, sy, s, clYellow, False);
    end;
    if (lx > 666) and (lx < 666 + 40) and (ly > 210) and (ly < 210 + 10) then begin
      flag := True;
      sx   := 666;
      sy   := 560;
      s    := IntToStr(Myself.Abil.Weight) + '/' + IntToStr(Myself.Abil.MaxWeight);
      DScreen.ShowHint(sx, sy, s, clYellow, False);
    end;
    if not flag then begin
      //       DScreen.ClearHint;
    end;
  end;
end;

function TFrmDlg.DCountMsgDlg(msgstr: string; DlgButtons: TMsgDlgButtons): TModalResult;
var
  lx, ly, i: integer;
  d: TDirectDrawSurface;
begin

  msglx := 31;
  msgly := 34;
  lx    := 205;
  ly    := 136;

  d := FrmMain.WProgUse.Images[660];
  if d <> nil then begin
    DCountDlg.SetImgIndex(FrmMain.WProgUse, 660);
    DCountDlg.Left    := (SCREENWIDTH - d.Width) div 2;
    DCountDlg.Top     := (SCREENHEIGHT - d.Height) div 2;
    DCountDlg.Visible := True;
  end;


  MsgText := msgstr;
  DCountDlg.Floating := False;   //메세지 박스가 떠다님..
  DCountDlg.Left := (SCREENWIDTH - DCountDlg.Width) div 2;
  DCountDlg.Top := (SCREENHEIGHT - DCountDlg.Height) div 2;
  DCountDlg.Visible := True;

  DCountDlgCancel.Left := lx;
  DCountDlgCancel.Top := ly;
  DCountDlgCancel.Visible := True;
  lx := lx - 69;

  DCountDlgOk.Left := lx;
  DCountDlgOk.Top := ly;
  DCountDlgOk.Visible := True;
  lx := lx - 69;

  DCountDlgMax.Left    := lx;
  DCountDlgMax.Top     := ly;
  DCountDlgMax.Visible := True;

  DCountDlgClose.Left    := 287;
  DCountDlgClose.Top     := 0;
  DCountDlgClose.Visible := True;

  HideAllControls;
  DCountDlg.ShowModal;

  with EdCountEdit do begin
    Text  := '';
    Width := DCountDlg.Width - 80;
    Left  := (SCREENWIDTH - EdCountEdit.Width) div 2 - 8;
    Top   := (SCREENHEIGHT - EdCountEdit.Height) div 2 + 13;
  end;

  Result := mrOk;

  while True do begin
    if not DCountDlg.Visible then
      break;
    FrmMain.DXTimerTimer (self, 0);
    //FrmMain.ProcOnIdle;
    Application.ProcessMessages;
    if Application.Terminated then
      exit;
  end;

  EdCountEdit.Visible := True;
  RestoreHideControls;
  DlgEditText := EdCountEdit.Text;
  if PlayScene.EdChat.Visible then
    PlayScene.EdChat.SetFocus;

  EdCountEdit.Visible := False;
  Result := DCountDlg.DialogResult;
end;

procedure TFrmDlg.DCountDlgOkDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DCountDlgCloseClick(Sender: TObject; X, Y: integer);
begin
  DCountDlg.DialogResult := mrCancel;
  DCountDlg.Visible      := False;
  DCountDlgClose.Downed  := False;
end;

procedure TFrmDlg.DMakeItemDlgOkClick(Sender: TObject; X, Y: integer);
var
  Data: string;
begin
  if Sender = DMakeItemDlgOk then begin
    DMakeItemDlg.DialogResult := mrOk;
    Data := NameMakeItem;
    Data := Data + '/' + MakeStrMakeItem();
    FrmMain.SendMakeItem(CurMerchant, Data);
  end;
  if (Sender = DMakeItemDlgCancel) or (Sender = DMakeItemDlgClose) then begin
    DMakeItemDlg.DialogResult := mrCancel;
  end;
  MoveMakeItemToBag;

  DMakeItemDlg.Visible     := False;
  DMakeItemDlgClose.Downed := False;
end;


function TFrmDlg.MakeItemDlgShow(msgstr: string): TModalResult;
var
  i: integer;
begin
  DMakeItemDlg.Left := 212;//140;//291;
  DMakeItemDlg.Top  := 176;//176;

  DMakeItemDlg.Visible := True;

  //아이템 가방에 잔상이 있는지 검사
  ArrangeItembag;

  Result := mrOk;
end;

procedure TFrmDlg.DMakeitemGridGridPaint(Sender: TObject; ACol, ARow: integer;
  Rect: TRect; State: TGridDrawState; dsurface: TDirectDrawSurface);
var
  idx: integer;
  d:   TDirectDrawSurface;
begin
  idx := ACol + ARow * DMakeitemGrid.ColCount;
  if idx in [0..5] then begin
    if MakeItemArr[idx].S.Name <> '' then begin
      d := FrmMain.WBagItem.Images[MakeItemArr[idx].S.Looks];
      if d <> nil then
        with DMakeitemGrid do
          dsurface.Draw(SurfaceX(Rect.Left + (ColWidth - d.Width) div 2 - 1),
            SurfaceY(Rect.Top + (RowHeight - d.Height) div 2 + 1),
            d.ClientRect,
            d, True);
      // 아이템 겹치기
      if MakeItemArr[idx].S.OverlapItem > 0 then begin
        SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
        dsurface.Canvas.Font.Color := clYellow;

        dsurface.Canvas.TextOut(DMakeitemGrid.SurfaceX(Rect.Left + 20),
          DMakeitemGrid.SurfaceY(Rect.Top + 20),
          IntToStr(MakeItemArr[idx].Dura));
        dsurface.Canvas.Release;
      end;
    end;
  end;

end;

procedure TFrmDlg.DMakeitemGridGridMouseMove(Sender: TObject;
  ACol, ARow: integer; Shift: TShiftState);
var
  idx: integer;
begin
  idx := ACol + ARow * DMakeitemGrid.ColCount;
  if idx in [0..5] then begin
    MouseItem := MakeItemArr[idx];
  end;
end;

procedure TFrmDlg.DMakeitemGridGridSelect(Sender: TObject; ACol, ARow: integer;
  Shift: TShiftState);
var
  temp:    TClientItem;
  mi, idx: integer;
  MsgResult, Count, OrgCount: integer;
  valstr:  string;
begin
  MsgResult := mrCancel;
  if not ItemMoving then begin
    idx := ACol + ARow * DMakeitemGrid.ColCount;
    if idx in [0..5] then begin
      if MakeItemArr[idx].S.Name <> '' then begin
        ItemMoving      := True;
        MovingItem.Item := MakeItemArr[idx];
        MakeItemArr[idx].S.Name := '';
        ItemClickSound(MovingItem.Item.S);
      end;
    end;
  end else begin
    mi := MovingItem.Index;
    if mi >= 6 then begin //가방,에서 온것만

      if SearchOverlapItem(MovingItem.Item) then begin
        CancelItemMoving;
        DMessageDlg('Same kinds of items that repeat can only be deposited once.',
          [mbOK]);
        Exit;
      end;

      ItemClickSound(MovingItem.Item.S);
      OrgCount      := MovingItem.Item.Dura;
      MakingDlgItem := MovingItem.Item; //서버에 결과를 기다리는동안 보관
      if MakingDlgItem.S.OverlapItem > 0 then begin
        Total      := MovingItem.Item.Dura;
        ItemMoving := False;
        if Total = 1 then begin
          DlgEditText := '1';
          MsgResult   := mrOk;
        end else
          MsgResult := DCountMsgDlg('How many out of total ' +
            IntToStr(MovingItem.Item.Dura) + ' will you put on?',
            [mbOK, mbCancel, mbAbort]);

        ItemMoving := True;
        GetValidStrVal(DlgEditText, valstr, [' ']);
        Count := Str_ToInt(valstr, 0);
        if Count <= 0 then begin
          Count := 0;
          MakingDlgItem.S.Name := '';
        end;
        if Count > MovingItem.Item.Dura then begin
          Count := MovingItem.Item.Dura;
          //                  MovingItem.Item.Dura := 0;
        end;
        if MsgResult = mrOk then begin
          //and (Count > 0) and (Count < MAX_OVERLAPITEM+1 ) then begin
          MakingDlgItem.Dura   := word(Count);
          MovingItem.Item.Dura := MovingItem.Item.Dura - Count;
          if MovingItem.Item.Dura = 0 then begin
            MovingItem.Item.S.Name := '';
            ItemMoving := False;
          end;
        end else if MsgResult = mrCancel then begin
          CancelItemMoving;
          Exit;
        end;
      end;
      if (not AddMakeItem(MakingDlgItem)) and (MakingDlgItem.S.OverlapItem > 0) then
      begin
        MovingItem.Item.Dura := OrgCount;
      end;
      if ItemMoving then
        CancelItemMoving;
    end;
  end;
  ArrangeItemBag;

end;

procedure TFrmDlg.DCountDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d, dr:     TDirectDrawSurface;
  ly, px, py, i: integer;
  str, Data: string;
begin
  with Sender as TDWindow do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    ly  := msgly;
    str := MsgText;
    while True do begin
      if str = '' then
        break;
      str := GetValidStr3(str, Data, ['\']);
      if Data <> '' then
        BoldTextOut(dsurface, SurfaceX(Left + msglx), SurfaceY(Top + ly),
          clWhite, clBlack, Data);
      ly := ly + 14;
    end;
    dsurface.Canvas.Release;
  end;
  if not EdCountEdit.Visible then begin
    EdCountEdit.Visible := True;
    EdCountEdit.SetFocus;
  end;
end;

procedure TFrmDlg.DCountDlgKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = 13 then begin
    if DCountDlgOk.Visible then begin
      DCountDlg.DialogResult := mrOk;
      DCountDlg.Visible      := False;
    end;
  end;
  if Key = 27 then begin
    if DCountDlgCancel.Visible then begin
      DCountDlg.DialogResult := mrCancel;
      DCountDlg.Visible      := False;
    end;
  end;
end;

procedure TFrmDlg.DMakeItemDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  if Myself = nil then
    exit;
  with DMakeItemDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    //      GetMouseItemInfo (d0, d1, d2, d3, useable, FALSE);
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clWhite;
      TextOut(SurfaceX(Left + 19), SurfaceY(Top + 60), 'Deposit stuff item');
      Release;
    end;
  end;

end;

procedure TFrmDlg.DCountDlgOkClick(Sender: TObject; X, Y: integer);
begin
  if Sender = DCountDlgMax then begin
    EdCountEdit.Text := IntToStr(Total);
    DlgEditText      := EdCountEdit.Text;
    DCountDlg.DialogResult := mrAll;
  end;
  if Sender = DCountDlgOk then
    DCountDlg.DialogResult := mrOk;
  if Sender = DCountDlgCancel then
    DCountDlg.DialogResult := mrCancel;
  if Sender <> DCountDlgMax then begin
    EdCountEdit.Visible := False;
    DCountDlg.Visible   := False;
  end;

end;

procedure TFrmDlg.DFriendDlgClick(Sender: TObject; X, Y: integer);
var
  lx, ly, pos, sx, sy: integer;
begin
  ItemSearchEdit.Visible := False;

  lx := x - DFriendDlg.Left;
  ly := y - DFriendDlg.Top;
  (Sender as TDWindow).hint := '';
  if (lx > 30) and (lx < 240) and (ly > 70) and (ly < 225) then begin

    pos := (lx div 140) + ((ly - 70) div 15) * 2 + FriendPage * 20;
    if ViewFriends then begin
      if FriendMembers.Count > pos then begin
        CurrentFriend := pos;

        if CurrentFriend >= 0 then begin
          (Sender as TDWindow).hint :=
            StrToHint(SqlSafeToStr(PTFriend(FriendMembers[CurrentFriend]).Memo));
        end;
      end;
    end else begin
      if BlackMembers.Count > pos then begin
        CurrentBlack := pos;
        if CurrentBlack >= 0 then begin
          (Sender as TDWindow).hint :=
            StrToHint(SqlSafeToStr(PTFriend(BlackMembers[CurrentBlack]).Memo));
        end;
      end;
    end;

  end;


  //    DScreen.AddSysMsg (IntToStr(lx) + ' ' + IntToStr(ly) + ' ' + IntToStr(pos));
end;

procedure TFrmDlg.DFriendDlgDblClick(Sender: TObject);
begin
  FriendDlgDblClicked := True;
end;

procedure TFrmDlg.DFriendDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  b: TDirectDrawSurface;
  lx, ly, n, t, l, ax, ay: integer;
  CurrentPage, maxPage, UpPage, DownPage: integer;
begin

  if ViewFriends then begin
    CurrentPage := FriendPage + 1;
    MaxPage     := FriendMembers.Count div 10 + 1;
  end else begin
    CurrentPage := BlackListPage + 1;
    MaxPage     := BlackMembers.Count div 10 + 1;
  end;

  if CurrentPage > 1 then
    UpPage := CurrentPage - 1
  else
    UpPage := CurrentPage;
  if CurrentPage < MaxPage then
    DownPage := CurrentPage + 1
  else
    DownPage := CurrentPage;

  DFrdpgUp.hint := IntToStr(UpPage) + '/' + IntToStr(MaxPage);
  DFrdpgDn.hint := IntToStr(DownPage) + '/' + IntToStr(MaxPage);

  b := FrmMain.WProgUse.GetCachedImage(534, ax, ay);
  with DFriendDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    if ViewFriends then begin
      if FriendMembers.Count > 0 then begin
        //            SetBkMode (dsurface.Canvas.Handle, TRANSPARENT);
        t := FriendPage * 20;
        l := _MIN(FriendPage * 20 + 20, FriendMembers.Count);
        for n := t to l - 1 do begin
          if PTFriend(FriendMembers[n]).Status >= 4 then
            dsurface.Canvas.Font.Color := clWhite
          else
            dsurface.Canvas.Font.Color := clSilver;

          if n = CurrentFriend then begin
            dsurface.Canvas.Font.Color  := clBlack;
            dsurface.Canvas.Brush.Color := clSilver;
            dsurface.Canvas.Brush.Style := bsSolid;
          end else begin
            dsurface.Canvas.Brush.Color := clBlack;
            dsurface.Canvas.Brush.Style := bsClear;
          end;

          lx := SurfaceX(30) + Left + ((n - t) mod 2) * 120;
          ly := SurfaceY(70) + Top + ((n - t) div 2) * 15;

          if fLover.Find(PTFriend(FriendMembers[n]).CharID) then
            //                  dsurface.Canvas.TextOut (lx, ly, '♡'+PTFriend(FriendMembers[n]).CharID)
            dsurface.Canvas.TextOut(lx, ly,
              ':)' + PTFriend(FriendMembers[n]).CharID)
          else
            dsurface.Canvas.TextOut(lx, ly, PTFriend(FriendMembers[n]).CharID);
          //             DScreen.AddSysMsg (IntToStr(lx+ax-5) + ' ' + IntToStr(ly+ay+5));
          //             dsurface.Draw (SurfaceX(lx+ax-5), SurfaceY(ly+ay+5), b.ClientRect, b, TRUE);

          dsurface.Canvas.Font.Color := clWhite;
          dsurface.Canvas.Brush.Style := bsClear;
          lx := SurfaceX(25) + Left;
          ly := SurfaceY(240) + Top;
          dsurface.Canvas.TextOut(lx, ly,
            IntToStr(ConnectFriend) + '/' + IntToStr(FriendMembers.Count));

        end;
        dsurface.Canvas.Release;
      end;
    end else begin
      if BlackMembers.Count > 0 then begin
        with dsurface.Canvas do begin
          SetBkMode(Handle, TRANSPARENT);
          Font.Color := clSilver;
          t := BlackListPage * 20;
          l := _MIN(BlackListPage * 20 + 20, BlackMembers.Count);
          for n := t to l - 1 do begin

            if PTFriend(BlackMembers[n]).Status >= 4 then
              dsurface.Canvas.Font.Color := clWhite
            else
              dsurface.Canvas.Font.Color := clSilver;

            if n = CurrentBlack then begin
              dsurface.Canvas.Font.Color  := clBlack;
              dsurface.Canvas.Brush.Color := clSilver;
              dsurface.Canvas.Brush.Style := bsSolid;
            end else begin
              dsurface.Canvas.Brush.Color := clBlack;
              dsurface.Canvas.Brush.Style := bsClear;
            end;

            lx := SurfaceX(30) + Left + ((n - t) mod 2) * 120;
            ly := SurfaceY(70) + Top + ((n - t) div 2) * 15;
            TextOut(lx, ly, PTFriend(BlackMembers[n]).CharID);
            dsurface.Draw(lx + ax - 5, ly + ay + 5, b.ClientRect, b, True);
          end;

          dsurface.Canvas.Font.Color := clWhite;
          dsurface.Canvas.Brush.Style := bsClear;
          lx := SurfaceX(25) + Left;
          ly := SurfaceY(240) + Top;
          dsurface.Canvas.TextOut(lx, ly,
            IntToStr(ConnectBlack) + '/' + IntToStr(BlackMembers.Count));

          Release;
        end;
      end;
    end;
    //이름
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := MySelf.NameColor;
      TextOut(SurfaceX(Left + 134 - TextWidth(MySelf.UserName) div 2),
        SurfaceY(Top + 38), MySelf.UserName);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DFriendDlgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  if (Sender as TDWindow).hint = '' then
    DScreen.ClearHint
  else begin
    with (Sender as TDWindow) do begin
      if ViewFriends then begin
        lx := 30 + (CurrentFriend mod 2) * 120;
        ly := 82 + ((CurrentFriend mod 20) div 2) * 15;
      end else begin
        lx := 30 + (CurrentBlack mod 2) * 120;
        ly := 82 + ((CurrentBlack mod 20) div 2) * 15;
      end;

      sx := SurfaceX(Left) + lx;
      sy := SurfaceY(Top) + ly;
      DScreen.ShowHint(sx, sy, (Sender as TDWindow).Hint, clWhite, False);
    end;
  end;
end;

procedure TFrmDlg.DFriendDlgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if not FriendDlgDblClicked then
    Exit;

  FriendDlgDblClicked := False;

  if ViewFriends then begin
    if (PTFriend(FriendMembers[CurrentFriend]).Status >= 4) then
      DFrdWhisperClick(nil, 0, 0)
    else
      DFrdMailClick(nil, 0, 0);
  end else begin
    if (PTFriend(BlackMembers[CurrentBlack]).Status >= 4) then
      DFrdWhisperClick(nil, 0, 0)
    else
      DFrdMailClick(nil, 0, 0);
  end;

end;

procedure TFrmDlg.DFrdFriendClick(Sender: TObject; X, Y: integer);
begin
  ViewFriends     := True;
  DFriendDlg.hint := '';
end;

procedure TFrmDlg.DFrdFriendDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if ViewFriends then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end else begin
      d := WLib.Images[FaceIndex + 1];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DFrdPgUpClick(Sender: TObject; X, Y: integer);
begin
  if Sender = DFrdPgUp then begin
    if ViewFriends then begin
      if FriendPage > 0 then
        Dec(FriendPage);
    end else begin
      if BlackListPage > 0 then
        Dec(BlackListPage);
    end;
  end else begin
    if ViewFriends then begin
      if FriendPage < (FriendMembers.Count + 19) div 20 - 1 then
        Inc(FriendPage);
    end else begin
      if BlackListPage < (BlackMembers.Count + 19) div 20 - 1 then
        Inc(BlackListPage);
    end;
  end;
end;

procedure TFrmDlg.DFrdBlackListDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if ViewFriends then begin
      d := WLib.Images[FaceIndex + 1];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end else begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DFrdCloseClick(Sender: TObject; X, Y: integer);
begin
  ToggleShowFriendsDlg;
end;

procedure TFrmDlg.DFrdPgUpDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin
    if TDButton(Sender).Downed then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;
  end;
end;

procedure TFrmDlg.DFrdPgUpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with (Sender as TDbutton) do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DFriendDlg.SurfaceX(DFriendDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DFriendDlg.SurfaceX(DFriendDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, (Sender as TDbutton).Hint, clYellow, False);
  end;

end;

procedure TFrmDlg.DFrdPgDnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with (Sender as TDbutton) do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DFriendDlg.SurfaceX(DFriendDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DFriendDlg.SurfaceX(DFriendDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, (Sender as TDbutton).Hint, clYellow, False);
  end;

end;

procedure TFrmDlg.DFrdAddClick(Sender: TObject; X, Y: integer);
var
  frdtype: integer;
begin
   { 2003/04/15
   if (not DMemo.Visible) then begin
      ViewWindowNo := 1;
      DMemoB1.SetImgIndex(FrmMain.WProgUse, 544);
      ShowEditMail;
   end;
   }
  // 등록할 친구 또는 악연의 개수를 설정한다.
  if ViewFriends then begin
    if Friendmembers.Count >= MAX_FRIEND_COUNT then begin
      DMessageDlg('No more slots are available to register your buddy.', [mbOK]);
      Exit;
    end;

  end else begin
    if Blackmembers.Count >= MAX_FRIEND_COUNT then begin
      DMessageDlg('No more slots are available to register your foe.', [mbOK]);
      Exit;
    end;

  end;


  DMessageDlg('Please insert the name you want to register as your buddy',
    [mbOK, mbAbort]);
  if DlgEditText <> '' then begin
    // 자신은 등록할 수 없다
    if DlgEditText = MySelf.UserName then begin
      DMessageDlg('You can not register yourself.', [mbOK]);
      Exit;
    end;

    if FrmMain.IsMyMember(DlgEditText) then begin
      DMessageDlg(DlgEditText + 'is already registered.', [mbOK]);
      Exit;
    end;

    if ViewFriends then
      frdtype := 1
    else
      frdtype := 8;
    FrmMain.SendAddFriend(DlgEditText, frdtype);
  end;
end;

procedure TFrmDlg.DFrdAddMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DFrdAdd do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DFriendDlg.SurfaceX(DFriendDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DFriendDlg.SurfaceX(DFriendDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Registration', clYellow, False);
    DFriendDlg.hint := '';
  end;
end;

procedure TFrmDlg.DFrdDelClick(Sender: TObject; X, Y: integer);
var
  delchar: string;
begin
  if ViewFriends then
    delchar := PTFriend(FriendMembers[CurrentFriend]).CharID
  else
    delchar := PTFriend(BlackMembers[CurrentBlack]).CharID;

  if delchar <> '' then begin
    if mrOk = FrmDlg.DMessageDlg('Are you sure to delete ' + delchar +
      ' from your buddy list?', [mbOK, mbCancel]) then begin
      FrmMain.sendDelFriend(delchar);
    end;
  end;

end;

procedure TFrmDlg.DFrdDelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DFrdDel do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DFriendDlg.SurfaceX(DFriendDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DFriendDlg.SurfaceX(DFriendDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Delete', clYellow, False);
    DFriendDlg.hint := '';
  end;
end;

procedure TFrmDlg.DFrdMemoClick(Sender: TObject; X, Y: integer);
begin
  //   if (not DMemo.Visible) then
  begin
    if ViewFriends then begin
      if (CurrentFriend >= 0) then begin
        ViewWindowData := CurrentFriend;
        MemoCharID     := PTFriend(FriendMembers[ViewWindowData]).CharID;
        ViewWindowNo   := VIEW_MEMO;
        memoMail.Text  :=
          SqlSafeToStr(PTFriend(FriendMembers[CurrentFriend]).Memo);
        DMemoB1.SetImgIndex(FrmMain.WProgUse, 544);
        DMemoB2.SetImgIndex(FrmMain.WProgUse, 538);
        DMemoB1.Visible := True;

        ShowEditMail;
      end;
    end else begin
      if (CurrentBlack >= 0) then begin
        ViewWindowData := CurrentBlack;
        MemoCharID     := PTFriend(BlackMembers[ViewWindowData]).CharID;
        ViewWindowNo   := VIEW_MEMO;
        memoMail.Text  := SqlSafeToStr(PTFriend(BlackMembers[CurrentBlack]).Memo);
        DMemoB1.SetImgIndex(FrmMain.WProgUse, 544);
        DMemoB2.SetImgIndex(FrmMain.WProgUse, 538);
        DMemoB1.Visible := True;

        ShowEditMail;
      end;

    end;

  end;
end;

procedure TFrmDlg.DFrdMemoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DFrdMemo do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DFriendDlg.SurfaceX(DFriendDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DFriendDlg.SurfaceX(DFriendDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Memo', clYellow, False);
    DFriendDlg.hint := '';
  end;
end;

procedure TFrmDlg.DFrdMailClick(Sender: TObject; X, Y: integer);
begin

  //   if (not DMemo.Visible)then
  begin
    if ViewFriends then begin
      if (CurrentFriend < 0) then
        Exit;
      ViewWindowData := CurrentFriend;
      MemoCharID     := PTFriend(FriendMembers[ViewWindowData]).CharID;
    end else begin
      if (CurrentBlack < 0) then
        Exit;
      ViewWindowData := CurrentBlack;
      MemoCharID     := PTFriend(BlackMembers[ViewWindowData]).CharID;
    end;

    ViewWindowNo := VIEW_MAILSEND;
    DMemoB1.SetImgIndex(FrmMain.WProgUse, 546);
    DMemoB2.SetImgIndex(FrmMain.WProgUse, 538);
    DMemoB1.Visible := True;
    memoMail.Clear;

    ShowEditMail;
  end;
end;

procedure TFrmDlg.DFrdMailMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DFrdMail do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DFriendDlg.SurfaceX(DFriendDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DFriendDlg.SurfaceX(DFriendDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Mail', clYellow, False);
    DFriendDlg.hint := '';
  end;
end;

procedure TFrmDlg.DFrdWhisperClick(Sender: TObject; X, Y: integer);
var
  wisname:    string;
  actionchar: char;
begin

  if ViewFriends then
    wisname := PTFriend(FriendMembers[CurrentFriend]).CharID
  else
    wisname := PTFriend(BlackMembers[CurrentBlack]).CharID;

  PlayScene.EdChat.Visible := False;
  FrmMain.WhisperName := wisname;
  actionchar := '/';
  FrmMain.FormKeyPress(Sender, actionchar);
end;

procedure TFrmDlg.DFrdWhisperMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DFrdWhisper do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DFriendDlg.SurfaceX(DFriendDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DFriendDlg.SurfaceX(DFriendDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Whisper', clYellow, False);
    DFriendDlg.hint := '';
  end;
end;

procedure TFrmDlg.DMailListCloseClick(Sender: TObject; X, Y: integer);
begin
  ToggleShowMailListDlg;
end;

procedure TFrmDlg.DMailListPgUpClick(Sender: TObject; X, Y: integer);
begin
  if Sender = DMailListPgUp then begin
    if MailPage > 0 then
      Dec(MailPage);
  end else begin
    if MailPage < (MailLists.Count + 10) div 11 - 1 then
      Inc(MailPage);
  end;
end;

procedure TFrmDlg.DMailListPgUpMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with (Sender as TDbutton) do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DMailListDlg.SurfaceX(DMailListDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DMailListDlg.SurfaceX(DMailListDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, (Sender as TDbutton).Hint, clYellow, False);
  end;

end;

procedure TFrmDlg.DMailListPgDnMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with (Sender as TDbutton) do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DMailListDlg.SurfaceX(DMailListDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DMailListDlg.SurfaceX(DMailListDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, (Sender as TDbutton).Hint, clYellow, False);
  end;

end;

procedure TFrmDlg.DMLReplyClick(Sender: TObject; X, Y: integer);
begin
  //   if (not DMemo.Visible) then
  begin
    ViewWindowNo   := VIEW_MAILSEND;
    ViewWindowData := CurrentMail;
    DMemoB1.SetImgIndex(FrmMain.WProgUse, 548);
    DMemoB2.SetImgIndex(FrmMain.WProgUse, 538);
    DMemoB1.Visible := True;
    MemoMail.Clear;
    MemoMail.ReadOnly := False;
    MemoCharID := PTMail(MailLists[CurrentMail]).Sender;
    ShowEditMail;
  end;

end;

procedure TFrmDlg.DMLReplyMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DMLReply do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DMailListDlg.SurfaceX(DMailListDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DMailListDlg.SurfaceX(DMailListDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Reply', clYellow, False);
  end;
end;

procedure TFrmDlg.DMLReadClick(Sender: TObject; X, Y: integer);
var
  str: string;
begin
  //   if (not DMemo.Visible) and (CurrentMail >= 0) then begin
  if (CurrentMail >= 0) then begin

    ViewWindowNo    := VIEW_MAILREAD;
    ViewWindowData  := CurrentMail;
    DMemoB1.Visible := False;//.SetImgIndex(FrmMain.WProgUse, 544);
    DMemoB2.SetImgIndex(FrmMain.WProgUse, 544);
    MemoMail.Text := SQlSafeToStr(pTMail(MailLists[CurrentMail]).Mail);
    MemoMail.ReadOnly := True;
    MemoCharID := PTMail(MailLists[ViewWindowData]).Sender;
    str      := PTMail(MailLists[ViewWindowData]).Date;
    MemoDate := '20' + str[1] + str[2] + '/' + str[3] + str[4] + '/' +
      str[5] + str[6] + ' ' + str[7] + str[8] + ':' + str[9] + str[10];
    // 읽었음을 전송
    if (pTMail(MailLists[CurrentMail]).Status = 0) then
      FrmMain.SendReadingMail(pTMail(MailLists[CurrentMail]).Date);

    ShowEditMail;

  end;
end;

procedure TFrmDlg.DMLReadMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DMLRead do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DMailListDlg.SurfaceX(DMailListDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DMailListDlg.SurfaceX(DMailListDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Read', clYellow, False);
  end;
end;

procedure TFrmDlg.DMLDelClick(Sender: TObject; X, Y: integer);
begin
  if pTMail(MailLists[CurrentMail]).Status = 2 then begin
    FrmDlg.DMessageDlg(
      'Note storage protection is set as "ON". It can not be deleted.',
      [mbOK]);
    exit;
  end;

  if pTMail(MailLists[CurrentMail]).Status = 3 then begin
    FrmDlg.DMessageDlg('It is already deleted.', [mbOK]);
    exit;
  end;

  if mrOk = FrmDlg.DMessageDlg('Would you like to delete ?', [mbOK, mbCancel]) then
  begin
    FrmMain.SendDelMail(pTMail(MailLists[CurrentMail]).Date);
  end;

end;

procedure TFrmDlg.DMLDelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DMLDel do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DMailListDlg.SurfaceX(DMailListDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DMailListDlg.SurfaceX(DMailListDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Delete', clYellow, False);
  end;
end;

procedure TFrmDlg.DMLLockClick(Sender: TObject; X, Y: integer);
var
  IsLock: boolean;
  mstate: byte;
begin
  mstate := pTMail(MailLists[CurrentMail]).Status;

  // 삭제된 넘이면 잠글수 없음
  if (mstate = 3) then
    exit;

  if (mstate = 2) then
    IsLock := True
  else
    IsLock := False;

  if IsLock then
    FrmMain.SendUnLockMail(pTMail(MailLists[CurrentMail]).Date)
  else
    FrmMain.SendLockMail(pTMail(MailLists[CurrentMail]).Date);
end;

procedure TFrmDlg.DMLLockMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DMLLock do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DMailListDlg.SurfaceX(DMailListDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DMailListDlg.SurfaceX(DMailListDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Note storage protection', clYellow, False);
  end;
end;

procedure TFrmDlg.DMLBlockClick(Sender: TObject; X, Y: integer);
begin
  ToggleShowBlockListDlg;
end;

procedure TFrmDlg.DMLBlockMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DMLBlock do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DMailListDlg.SurfaceX(DMailListDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DMailListDlg.SurfaceX(DMailListDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Blacklist', clYellow, False);
  end;
end;

procedure TFrmDlg.DMailListDlgClick(Sender: TObject; X, Y: integer);
var
  lx, ly: integer;
  pos:    integer;
begin
  ItemSearchEdit.Visible := False;
  lx := x - DMailListDlg.Left;
  ly := y - DMailListDlg.Top;
  if (lx > 20) and (lx < 250) and (ly > 60) and (ly < 225) then begin
    pos := (ly - 60) div 15 + MailPage * 11;
    if MailLists.Count > pos then
      CurrentMail := pos;
  end;
end;

procedure TFrmDlg.DMailListDlgDblClick(Sender: TObject);
begin
  MailListDlgDblClicked := True;
end;

procedure TFrmDlg.DMailListDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d:    TDirectDrawSurface;
  b:    TDirectDrawSurface;
  lx, ly, n, t, l, ax, ay: integer;
  Rect: TRect;
  CurrentPage, maxPage, UpPage, DownPage: integer;
  LockStr: string;
begin
  CurrentPage := MailPage + 1;
  MaxPage     := MailLists.Count div 10 + 1;
  if CurrentPage > 1 then
    UpPage := CurrentPage - 1
  else
    UpPage := CurrentPage;
  if CurrentPage < MaxPage then
    DownPage := CurrentPage + 1
  else
    DownPage := CurrentPage;

  DMailListPgUp.hint := IntToStr(UpPage) + '/' + IntToStr(MaxPage);
  DMailListpgDn.hint := IntToStr(DownPage) + '/' + IntToStr(MaxPage);

  b := FrmMain.WProgUse.GetCachedImage(543, ax, ay);
  with DMailListDlg do begin
    d := WLib.Images[FaceIndex];

    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    dsurface.Draw(SurfaceX(Left + 15), SurfaceY(Top + 35), b.ClientRect, b, True);

    if MailLists.Count > 0 then begin
      t := MailPage * 11;
      l := _MIN(MailPage * 11 + 11, MailLists.Count);

      for n := t to l - 1 do begin

        if n = CurrentMail then begin
          dsurface.Canvas.Brush.Color := clDkGray;
          dsurface.Canvas.Brush.Style := bsSolid;
        end else begin
          dsurface.Canvas.Brush.Color := clBlack;
          dsurface.Canvas.Brush.Style := bsClear;
        end;

        LockStr := '';

        case PTMail(MailLists[n]).Status of
          0: dsurface.Canvas.Font.Color := clWhite;
          1: dsurface.Canvas.Font.Color := clSilver;
          2: begin
            dsurface.Canvas.Font.Color := clWhite;
            LockStr := '[*]';
          end;
          3: dsurface.Canvas.Font.Color := clBlue;
        end;

        lx := SurfaceX(30) + Left;
        ly := SurfaceY(60) + Top + (n - t) * 15;
        Rect.Left := lx - 10;
        Rect.Top := ly;
        Rect.Right := lx + 215;
        Rect.Bottom := ly + 15;
        dsurface.Canvas.FillRect(Rect);
        dsurface.Canvas.TextOut(lx, ly + 2, PTMail(MailLists[n]).Sender);


        lx := SurfaceX(145) + Left;
        ly := SurfaceY(60) + Top + (n - t) * 15;
        Rect.Left := lx;
        Rect.Top := ly;
        Rect.Right := lx + 100;
        Rect.Bottom := ly + 15;
        dsurface.Canvas.TextRect(Rect, lx, ly + 2, LockStr +
          StrToVisibleOnly(SqlSafeToStr(PTMail(MailLists[n]).Mail)));

        dsurface.Canvas.Font.Color := clWhite;
        dsurface.Canvas.Brush.Style := bsClear;
        lx := SurfaceX(25) + Left;
        ly := SurfaceY(240) + Top;
        dsurface.Canvas.TextOut(lx, ly,
          IntToStr(NotReadMailCount) + '/' + IntToStr(MailLists.Count));

      end;
      dsurface.Canvas.Release;
    end;

    //이름
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := MySelf.NameColor;
      TextOut(SurfaceX(Left + 134 - TextWidth(MySelf.UserName) div 2),
        SurfaceY(Top + 13), MySelf.UserName);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DMailListDlgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DMailListDlgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if not MailListDlgDblClicked then
    Exit;

  MailListDlgDblClicked := False;
  DMLReadClick(nil, 0, 0);
end;

procedure TFrmDlg.DMailDlgClick(Sender: TObject; X, Y: integer);
begin
  ItemSearchEdit.Visible := False;
end;

procedure TFrmDlg.DMailDlgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DBlockListDlgClick(Sender: TObject; X, Y: integer);
var
  lx, ly: integer;
  pos:    integer;
begin
  ItemSearchEdit.Visible := False;

  lx := x - DBlockListDlg.Left;
  ly := y - DBlockListDlg.Top;
  if (lx > 20) and (lx < 250) and (ly > 60) and (ly < 225) then begin
    pos := (lx div 140) + ((ly - 70) div 15) * 2 + FriendPage * 20;
    //       pos := (ly - 60) div 15 + BlockPage * 11;
    if BlockLists.Count > pos then
      CurrentBlock := pos;
  end;
end;

procedure TFrmDlg.DBlockListDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d:    TDirectDrawSurface;
  b:    TDirectDrawSurface;
  lx, ly, n, t, l, ax, ay: integer;
  Rect: TRect;
  CurrentPage, maxPage, UpPage, DownPage: integer;
begin
  CurrentPage := BlockPage + 1;
  MaxPage     := BlockLists.Count div 10 + 1;
  if CurrentPage > 1 then
    UpPage := CurrentPage - 1
  else
    UpPage := CurrentPage;
  if CurrentPage < MaxPage then
    DownPage := CurrentPage + 1
  else
    DownPage := CurrentPage;

  DBLpgUp.hint := IntToStr(UpPage) + '/' + IntToStr(MaxPage);
  DBLpgDn.hint := IntToStr(DownPage) + '/' + IntToStr(MaxPage);

  b := FrmMain.WProgUse.GetCachedImage(542, ax, ay);
  with DBlockListDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    dsurface.Draw(SurfaceX(Left + 15), SurfaceY(Top + 35), b.ClientRect, b, True);
    if BlockLists.Count > 0 then begin
      //         SetBkMode (dsurface.Canvas.Handle, TRANSPARENT);
      t := BlockPage * 11;
      l := _MIN(BlockPage * 11 + 11, BlockLists.Count);
      for n := t to l - 1 do begin
        if n = CurrentBlock then begin
          dsurface.Canvas.Font.Color  := clBlack;
          dsurface.Canvas.Brush.Color := clGray;
          dsurface.Canvas.Brush.Style := bsSolid;
        end else begin
          dsurface.Canvas.Font.Color  := clSilver;
          dsurface.Canvas.Brush.Color := clBlack;
          dsurface.Canvas.Brush.Style := bsClear;
        end;

        lx := SurfaceX(30) + Left + ((n - t) mod 2) * 120;
        ly := SurfaceY(70) + Top + ((n - t) div 2) * 15;
        dsurface.Canvas.TextOut(lx, ly, BlockLists[n]);

        //            lx := SurfaceX(30) + Left;
        //            ly := SurfaceY(60) + Top  + (n-t) * 15;
        //            Rect.Left  := lx - 10;    Rect.Top    := ly;
        //            Rect.Right := lx + 215;   Rect.Bottom := ly + 14;
        //            dsurface.Canvas.FillRect(Rect);
        //            dsurface.Canvas.TextOut (lx, ly, BlockLists[n]);

      end;
      dsurface.Canvas.Release;
    end;
    //이름
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := MySelf.NameColor;
      TextOut(SurfaceX(Left + 134 - TextWidth(MySelf.UserName) div 2),
        SurfaceY(Top + 13), MySelf.UserName);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DBlockListDlgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DBlockListCloseClick(Sender: TObject; X, Y: integer);
begin
  ToggleShowBlockListDlg;
end;

procedure TFrmDlg.DBLPgUpClick(Sender: TObject; X, Y: integer);
begin
  if Sender = DBLPgUp then begin
    if BlockPage > 0 then
      Dec(BlockPage);
  end else begin
    if BlockPage < (BlockLists.Count + 10) div 11 - 1 then
      Inc(BlockPage);
  end;
end;

procedure TFrmDlg.DBLPgUpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with (Sender as TDbutton) do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DBlockListDlg.SurfaceX(DBlockListDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DBlockListDlg.SurfaceX(DBlockListDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, (Sender as TDbutton).Hint, clYellow, False);
  end;

end;

procedure TFrmDlg.DBLPgDnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with (Sender as TDbutton) do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DBlockListDlg.SurfaceX(DBlockListDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DBlockListDlg.SurfaceX(DBlockListDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, (Sender as TDbutton).Hint, clYellow, False);
  end;

end;

procedure TFrmDlg.DBLAddClick(Sender: TObject; X, Y: integer);
begin
  DMessageDlg('Please insert the name you want to add into the note block list',
    [mbOK, mbAbort]);
  if DlgEditText <> '' then begin
    FrmMain.SendAddReject(DlgEditText);
  end;

end;

procedure TFrmDlg.DBLAddMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DBLAdd do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DBlockListDlg.SurfaceX(DBlockListDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DBlockListDlg.SurfaceX(DBlockListDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Add Blacklist', clYellow, False);
  end;
end;

procedure TFrmDlg.DBLDelClick(Sender: TObject; X, Y: integer);
begin
  if mrOk = FrmDlg.DMessageDlg('Would you like to delete ?', [mbOK, mbCancel]) then
  begin
    FrmMain.SendDelReject(BlockLists[CurrentBlock]);
  end;
end;

procedure TFrmDlg.DBLDelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DBLDel do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DBlockListDlg.SurfaceX(DBlockListDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DBlockListDlg.SurfaceX(DBlockListDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Delete', clYellow, False);
  end;
end;

procedure TFrmDlg.DMemoClick(Sender: TObject; X, Y: integer);
begin
  ItemSearchEdit.Visible := False;
end;

procedure TFrmDlg.DMemoDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d:    TDirectDrawSurface;
  b:    TDirectDrawSurface;
  lx, ly, n, t, l, ax, ay: integer;
  Rect: TRect;
begin
  //     if not (Sender As TDWindow).CanFocus then MemoMail.Visible := false
  //     else MemoMail.Visible := true;

  case ViewWindowNo of
    VIEW_MAILREAD: begin
      memoMail.Left   := DMemo.Left + 28;
      memoMail.Top    := DMemo.Top + 36 + 14;
      memoMail.Width  := 148;
      memoMail.Height := 72 - 14;
    end;
    else begin
      memoMail.Left   := DMemo.Left + 28;
      memoMail.Top    := DMemo.Top + 36;
      memoMail.Width  := 148;
      memoMail.Height := 72;
    end;
  end;

  b := nil;
  with DMemo do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    //이름...쪽지보기, 쪽지보내기시에만 출력, 친구등록시는 입력박스
    case ViewWindowNo of
      VIEW_FRIEND:  // 친구등록    위: 친구아이디 입력, 아래: 메모 입력
      begin
        b := FrmMain.WProgUse.GetCachedImage(549 + 1, ax, ay);
      end;
      VIEW_MAILSEND:  // 쪽지보내기  위: 받는사람 출력, 아래: 쪽지 내용 입력
      begin
        b := FrmMain.WProgUse.GetCachedImage(549 + 2, ax, ay);

        with dsurface.Canvas do begin
          SetBkMode(Handle, TRANSPARENT);
          Font.Color := clSilver;
          //             MemoCharID := PTFriend(FriendMembers[ViewWindowData]).CharID;
          TextOut(SurfaceX(Left + 140 - TextWidth(MemoCharID) div 2),
            SurfaceY(Top + 13), MemoCharID);
          Release;
        end;
      end;
      VIEW_MAILREAD:  // 쪽지보기    위: 보낸사람 출력, 아래: 쪽지 내용 출력
      begin
        b := FrmMain.WProgUse.GetCachedImage(549 + 3, ax, ay);

        with dsurface.Canvas do begin
          //             SetBkMode (Handle, TRANSPARENT);
          Brush.Style := bsSolid;
          Brush.Color := clGray;
          Font.Color  := clWhite;
          TextOut(SurfaceX(Left + 28),
            SurfaceY(Top + 36), MemoDate);

          Brush.Style := bsClear;
          Font.Color  := clSilver;
          //             MemoCharID := PTMail(MailLists[ViewWindowData]).Sender;
          TextOut(SurfaceX(Left + 140 - TextWidth(MemoCharID) div 2),
            SurfaceY(Top + 13), MemoCharID);
          Release;
        end;

      end;
      VIEW_MEMO:  // 친구정보    위: 친구아이디 출력. 아래: 메모 입력
      begin
        b := FrmMain.WProgUse.GetCachedImage(549 + 1, ax, ay);

        with dsurface.Canvas do begin
          SetBkMode(Handle, TRANSPARENT);
          Font.Color := clSilver;
          //             MemoCharID := PTFriend(FriendMembers[ViewWindowData]).CharID;
          TextOut(SurfaceX(Left + 140 - TextWidth(MemoCharID) div 2),
            SurfaceY(Top + 13), MemoCharID);
          Release;
        end;
      end;
    end;

    if b <> nil then
      dsurface.Draw(SurfaceX(Left + 9), SurfaceY(Top + 7), b.ClientRect, b, True);

    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    dsurface.Canvas.Font.Color := clSilver;
    if n = CurrentBlock then
      dsurface.Canvas.Brush.Color := clGray
    else
      dsurface.Canvas.Brush.Color := clBlack;

    dsurface.Canvas.Release;
  end;
end;

procedure TFrmDlg.DMemoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DMemoCloseClick(Sender: TObject; X, Y: integer);
begin
  DMemo.Visible := False;
  case ViewWindowNo of
    VIEW_FRIEND: begin
      edCharID.Visible  := False;
      memoMail.Visible  := False;
      memoMail.ReadOnly := False;
    end;
    VIEW_MAILSEND: begin
      edCharID.Visible  := False;
      memoMail.Visible  := False;
      memoMail.ReadOnly := False;
    end;
    VIEW_MAILREAD: begin
      memoMail.Visible  := False;
      memoMail.ReadOnly := False;
    end;
    VIEW_MEMO: begin
      memoMail.Visible  := False;
      memoMail.ReadOnly := False;
    end;
  end;
  DMsgDlg.DialogResult := mrCancel;

  SetImeMode(PlayScene.EdChat.Handle, LocalLanguage);
end;

procedure TFrmDlg.DMemoB1Click(Sender: TObject; X, Y: integer);
begin

  // 각가의 상황일떄 OK 동작 정의
  case ViewWindowNo of
    VIEW_FRIEND: begin

    end;
    VIEW_MAILSEND: begin
      if MemoMail.Text <> '' then begin
        if frmDlg.BoMemoJangwon then
          FrmMain.SendMail(MemoCharID + '/' + MemoCharID2 + '/' +
            StrToSqlSafe(MemoMail.Text))
        else
          FrmMain.SendMail(MemoCharID + '/' + StrToSqlSafe(MemoMail.Text));
      end else
        frmDlg.BoMemoJangwon := False;

    end;
    VIEW_MAILREAD: begin

    end;
    VIEW_MEMO: begin
      if BackupMemoMail <> MemoMail.Text then
        FrmMain.SendUpdateFriend(MemoCharID + '/' +
          StrToSqlSafe(MemoMail.Text));
    end;
  end;

  edCharID.Visible  := False;
  MemoMail.Visible  := False;
  DMemo.Visible     := False;
  MemoMail.ReadOnly := False;

  DMsgDlg.DialogResult := mrOk;

  SetImeMode(PlayScene.EdChat.Handle, LocalLanguage);

end;

procedure TFrmDlg.DMemoB1DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin

    if TDButton(Sender).Downed then
      d := WLib.Images[FaceIndex + 1]
    else
      d := WLib.Images[FaceIndex];

    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

  end;

end;

procedure TFrmDlg.DMemoB2DirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with Sender as TDButton do begin

    if TDButton(Sender).Downed then
      d := WLib.Images[FaceIndex + 1]
    else
      d := WLib.Images[FaceIndex];

    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

  end;

end;

procedure TFrmDlg.DItemMarketDlgClick(Sender: TObject; X, Y: integer);
var
  lx, ly, idx: integer;
  pg: PTMarketITem;
begin

  pg := nil;
  lx := DItemMarketDlg.LocalX(X) - DItemMarketDlg.Left;
  ly := DItemMarketDlg.LocalY(Y) - DItemMarketDlg.Top;
  if (lx >= 10) and (lx <= 459) and (ly >= 65) and (ly <= 256) then begin
    idx := (ly - 70) div MAKETLINEHEIGHT + MenuTop;
    if idx < g_Market.Count then begin
      PlaySound(s_glass_button_click);
      MenuIndex := idx;
    end;
  end;

  if (MenuIndex >= 0) and (MenuIndex < g_Market.Count) then begin
    pg := g_Market.GetItem(MenuIndex);
    if pg.SellState = 1 then
      MItemSellState := 1 // 판매중
    else if pg.SellState = 2 then
      MItemSellState := 2; // 판매완료
  end;

end;

procedure TFrmDlg.DItemMarketDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);

  function SX(x: integer): integer;
  begin
    Result := DItemMarketDlg.SurfaceX(DItemMarketDlg.Left + x);
  end;

  function SY(y: integer): integer;
  begin
    Result := DItemMarketDlg.SurfaceY(DItemMarketDlg.Top + y);
  end;

var
  i, lh, k, m, n, menuline: integer;
  d, TempSurface: TDirectDrawSurface;
  pg:      PTMarketITem;
  year, mon, day, hour, min, datestr: string;
  targdate: TDateTime;
  iname, d0, d1, d2, d3, pagestr: string;
  useable: boolean;
  MouseItemTemp: TClientItem;
begin
  i  := 0;
  pg := nil;

  with dsurface.Canvas do begin
    with DItemMarketDlg do begin
      d := DItemMarketDlg.WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;

    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    SetBkMode(Handle, TRANSPARENT);
    Font.Color := clWhite;

    lh := MAKETLINEHEIGHT;
    menuline := _MIN(MAXMENU, g_Market.Count - MenuTop);

    if g_Market.GetUserMode = 1 then
      TextOut(SX(186), SY(16), 'Item Buy')
    else if g_Market.GetUserMode = 2 then
      TextOut(SX(186), SY(16), 'Item Sale');

    TextOut(SX(373), SY(16), format('%4d', [(MenuTop + 10) div 10]));
    if g_Market.RecvMaxPage < 1 then
      TextOut(SX(403), SY(16), '/ ' + '1')
    else
      TextOut(SX(403), SY(16), '/ ' + IntToStr(g_Market.RecvMaxPage));
    //      TextOut (SX(504), SY(16), GetGoldStr(Myself.Gold));

    TextOut(SX(41), SY(46), 'Item');
    TextOut(SX(200), SY(46), 'Price');
    if g_Market.GetUserMode = 2 then
      TextOut(SX(360), SY(46), 'Status')
    else
      TextOut(SX(360), SY(46), 'Seller');

    for i := MenuTop to MenuTop + menuline - 1 do begin
      m  := i - MenuTop;
      pg := g_Market.GetItem(i);

      if i = MenuIndex then begin
        Font.Color := clRed;
        TextOut(SX(34), SY(70 + m * lh), char(7));
        MemoCharID := pg.SellWho;
      end else if pg.SellState = 2 then
        Font.Color := clYellow
      else if pg.UpgCount > 0 then
        Font.Color := clAqua
      else
        Font.Color := clWhite;

      if pg <> nil then begin
        TextOut(SX(41), SY(70 + MAKETLINEHEIGHT * m), pg.Item.S.Name);
        TextOut(SX(170), SY(70 + MAKETLINEHEIGHT * m),
          format('%15s', [GetGoldStr(pg.SellPrice)]));
        if g_Market.GetUserMode = 2 then begin
          if pg.SellState = 1 then
            TextOut(SX(360), SY(70 + MAKETLINEHEIGHT * m), 'Now Sale')
          else if pg.SellState = 2 then
            TextOut(SX(360), SY(70 + MAKETLINEHEIGHT * m), 'Complete Sale');
        end else
          TextOut(SX(360), SY(70 + MAKETLINEHEIGHT * m), pg.SellWho);
      end;
    end;
    Font.Color := clWhite;
    if (MenuIndex >= 0) and (MenuIndex < g_Market.Count) then begin
      pg      := g_Market.GetItem(MenuIndex);
      year    := Copy(pg.Selldate, 1, 2);
      mon     := Copy(pg.Selldate, 3, 2);
      day     := Copy(pg.Selldate, 5, 2);
      hour    := Copy(pg.Selldate, 7, 2);
      min     := Copy(pg.Selldate, 9, 2);
      datestr := '20' + year + '-' + mon + '-' + day + ' ' + hour + ':' + min;
      TextOut(SX(21), SY(275), 'RegistryDay: ' + datestr);
      targdate := EncodeDate(StrToInt(year) + 2000, StrToInt(mon), StrToInt(day)) +
        EncodeTime(StrToInt(hour), StrToInt(min), 0, 0);
      targdate := targdate + 100;
      TextOut(SX(21), SY(292), 'DeleteDay: ' +
        FormatDateTime('YYYY-MM-DD', targdate));
    end;

    if (MenuIndex >= 0) and (MenuIndex < g_Market.Count) then begin
      MouseItemTemp := MouseItem;
      MouseItem     := pg.item;
      with DItemMarketDlg do begin
        GetMouseItemInfo(iname, d0, d1, d2, d3, useable, False);
        MouseItem := MouseItemTemp;
        SetBkMode(Handle, TRANSPARENT);

        if iname <> '' then begin
          Font.Color := clYellow;
          TextOut(SX(228), SY(268), iname);
          n := TextWidth(iname);
          Font.Color := clWhite;
          TextOut(SX(228) + n, SY(268), d0);
          TextOut(SX(228), SY(268 + 14), d1);
          TextOut(SX(228), SY(268 + 14 * 2), d2);
          if not useable then
            Font.Color := clRed;
          n := TextWidth(d2);
          TextOut(SX(228) + n, SY(268 + 14 * 2), d3);
        end;
      end;
    end;

    Release;
  end;

  if (MenuIndex >= 0) and (MenuIndex < g_Market.Count) then begin
    pg := g_Market.GetItem(MenuIndex);
    TempSurface := FrmMain.WBagItem.Images[pg.Item.S.Looks];
    if TempSurface <> nil then
      dsurface.Draw(SX(172) + (36 - TempSurface.Width) div 2,
        SY(274) + (32 - TempSurface.Height) div 2,
        TempSurface.ClientRect, TempSurface, True);
    //         dsurface.Draw (SX(173), SY(275), TempSurface.ClientRect, TempSurface, TRUE);
  end;

  if (ItemSearchEdit.Left <> SX(13)) or (ItemSearchEdit.Top <> SY(328)) then begin
    ItemSearchEdit.Left := SX(13);
    ItemSearchEdit.Top  := SY(328);
  end;

  //   DScreen.ClearHint;
  //   MouseStateItem.S.Name := '';

end;

procedure TFrmDlg.DItemMarketDlgKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if Key = 27 then
    if DItemMarketDlg.Visible then
      CloseItemMarketDlg;

  if Key = 13 then
    DItemFindClick(DItemFind, 0, 0);

  DScreen.ClearHint;
  case key of
    VK_UP: begin
      if (MenuTop <= (MenuIndex - 1)) and (MenuIndex <> -1) then begin
        Dec(MenuIndex, 1);
        DItemMarketDlgClick(DItemMarketDlg, 0, 0);
      end;
    end;
    VK_DOWN: begin
      if (MenuTop + MAXMENU > (MenuIndex + 1)) and (MenuIndex <> -1) and
        ((MenuIndex + 1) < g_Market.Count) then begin
        Inc(MenuIndex, 1);
        DItemMarketDlgClick(DItemMarketDlg, 0, 0);
      end;
    end;
    VK_LEFT: begin
      DItemListPrevClick(DItemListPrev, 0, 0);
    end;
    VK_RIGHT: begin
      DItemListNextClick(DItemListNext, 0, 0);
    end;
    else
  end;

end;

procedure TFrmDlg.DItemMarketDlgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  with DItemMarketDlg do
    //      if (X < SurfaceX(Left+9)) or (X > SurfaceX(Left+Width-3)) or (Y < SurfaceY(Top+155)) or (Y > SurfaceY(Top+Height-125)) then begin
    if (X < SurfaceX(Left + 9)) or (X > SurfaceX(Left + Width - 3)) or
      (Y < SurfaceY(Top + 65)) or (Y > SurfaceY(Top + Height - 131)) then begin
      BoInRect := False;
    end else begin
      BoInRect := True;
    end;
  //   DScreen.ClearHint;
  //   MouseStateItem.S.Name := '';
  if g_Market.GetUserMode = 1 then begin
    with DItemMarketDlg do
      if (X > SurfaceX(Left + 10)) and
        (X < SurfaceX(Left + 16 + ItemSearchEdit.Width)) and
        (Y > SurfaceY(Top + 323)) and (Y < SurfaceY(Top + 347)) then begin
        DItemMarketDlg.EnableFocus := True;
        ItemSearchEdit.Visible     := True;
        ItemSearchEdit.SetFocus;
      end else
        ItemSearchEdit.Visible := False;
  end;

end;

procedure TFrmDlg.DItemMarketDlgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if BoInRect then begin
    DItemMarketDlg.SpotX := X;
    DItemMarketDlg.SpotY := Y;
  end;
  //   DScreen.ClearHint;
end;

procedure TFrmDlg.DItemBuyClick(Sender: TObject; X, Y: integer);
var
  pg: PTMarketITem;
  MsgResult: integer;
begin
  if GetTickCount < LastestClickTime then
    exit; //클릭을 자주 못하게 제한
  DScreen.ClearHint;
  if (MenuIndex >= 0) and (MenuIndex < g_Market.Count) then begin
    ItemSearchEdit.Visible := False;
    pg := g_Market.GetItem(MenuIndex);
    if Myself.Gold < pg.SellPrice then begin
      MsgResult := DMessageDlg('Money is insufficient.', [mbOK, mbCancel]);
      Exit;
    end;
    MsgResult := DMessageDlg('Do you want to purchase ' + pg.Item.S.Name +
      ' for ' + IntToStr(pg.SellPrice) + ' gold?', [mbOK, mbCancel]);

    if MsgResult = mrOk then begin
      FrmMain.SendBuyMarket(CurMerchant, pg.Index);
      DItemBag.Show;
    end else if MsgResult = mrCancel then begin
    end;
  end;
end;

procedure TFrmDlg.DItemMarketCloseClick(Sender: TObject; X, Y: integer);
begin
  // 위탁목록창이 닫히면.. 아이템 클리어 및 닫혔다고 서버에 알린다.
  g_Market.Clear;
  FrmMain.SendMarketClose;

  ItemSearchEdit.Visible  := False;
  DItemMarketDlg.Visible  := False;
  DItemMarketClose.Downed := False;

  //   PlayScene.EdChat.SetFocus;
  LocalLanguage := imSAlpha;
  SetImeMode(PlayScene.EdChat.Handle, LocalLanguage);
  LastestClickTime := GetTickCount;

  MemoCharID := '';

end;

procedure TFrmDlg.DItemFindClick(Sender: TObject; X, Y: integer);
var
  findstr: string;
begin

  if GetTickCount < LastestClickTime then
    exit; //클릭을 자주 못하게 제한

  //   DMessageDlg ('검색할 아이템 이름을 입력하세요.', [mbOk, mbAbort]);
  //   GetValidStrVal (DlgEditText, findstr, [' ']);
  //   findstr := trim(findstr);
  findstr := trim(ItemSearchEdit.Text);
  findstr := Copy(findstr, 1, 20);  //Item Name Length
  ItemSearchEdit.Visible := False;
  if findstr <> '' then
    FrmMain.SendGetMarketPageList(CurMerchant, 2, findstr);
  LastestClickTime := GetTickCount + 5000;
  //   DScreen.AddChatBoardString ('SendGetMarketPageList (CurMerchant, 2, ' +findstr + ')',  clYellow, clRed);

end;

procedure TFrmDlg.DItemSellCancelClick(Sender: TObject; X, Y: integer);
var
  pg: PTMarketITem;
  MsgResult: integer;
begin
  if GetTickCount < LastestClickTime then
    exit; //클릭을 자주 못하게 제한

  DScreen.ClearHint;
  if (MenuIndex >= 0) and (MenuIndex < g_Market.Count) then begin
    ItemSearchEdit.Visible := False;
    pg := g_Market.GetItem(MenuIndex);
    DMessageDlg('DItemSellCancelClick: ' + IntToStr(pg.SellState), [mbOK, mbCancel]);
    if pg.SellState = 1 then begin
      MsgResult := DMessageDlg('Cancel the trade offer of ' +
        pg.Item.S.Name, [mbOK, mbCancel]);
      if MsgResult = mrOk then begin
        FrmMain.SendCancelMarket(CurMerchant, pg.Index);
        DItemBag.Show;
      end;
    end else if pg.SellState = 2 then begin
      MsgResult := DMessageDlg(
        'Do you want to receive the earnings?\If you take the earnings, certain amount of commission\will be automatically deducted from the total earnings.', [mbOK, mbCancel]);
      if MsgResult = mrOk then
        FrmMain.SendGetPayMarket(CurMerchant, pg.Index);
    end;
    MItemSellState := 0;
  end;
end;

procedure TFrmDlg.DItemListPrevClick(Sender: TObject; X, Y: integer);
begin

  MenuIndex := -1;
  if MenuTop > 0 then begin
    Dec(MenuTop, MAXMENU);
    if MenuTop < 0 then
      MenuTop := 0;
  end;
  MenuIndex := MenuTop;
  DItemMarketDlgClick(DItemMarketDlg, 0, 0);
end;

procedure TFrmDlg.DItemListRefreshClick(Sender: TObject; X, Y: integer);
begin
  if GetTickCount < LastestClickTime then begin
    DScreen.AddChatBoardString('Please press the button few seconds later.',
      clYellow, clRed);
    exit; //클릭을 자주 못하게 제한
  end;
  DScreen.ClearHint;
  MenuIndex   := -1;
  MenuTop     := 0;
  MenuTopLine := 0;
  FrmMain.SendGetMarketPageList(CurMerchant, 0, '');
  LastestClickTime := GetTickCount + 5000;

end;

procedure TFrmDlg.DItemListNextClick(Sender: TObject; X, Y: integer);
var
  MaxNum: integer;
begin

  MenuIndex := -1;
  MaxNum    := (g_Market.RecvMaxPage) * 10;
  if (MaxNum >= g_Market.Count) and (MaxNum >= (MenuTop + 19)) then begin
    Inc(MenuTop, MAXMENU);
    if g_Market.Count <= MenuTop then
      FrmMain.SendGetMarketPageList(CurMerchant, 1, '');
  end;
  MenuIndex := MenuTop;
  DItemMarketDlgClick(DItemMarketDlg, 0, 0);
end;

procedure TFrmDlg.DJangwonListDlgClick(Sender: TObject; X, Y: integer);
var
  lx, ly, idx: integer;
  pj: PTClientJangwon;
begin

  pj := nil;
  lx := DJangwonListDlg.LocalX(X) - DJangwonListDlg.Left;
  ly := DJangwonListDlg.LocalY(Y) - DJangwonListDlg.Top;
  if (lx >= 9) and (lx <= 511) and (ly >= 48) and (ly <= 190) then begin
    //      idx := (ly-51) div LISTLINEHEIGHT2 + MenuTop;
    idx := (ly - 51) div LISTLINEHEIGHT2;
    if idx < JangwonList.Count then begin
      PlaySound(s_glass_button_click);
      MenuIndex := idx;
    end;
  end;

  if (MenuIndex >= 0) and (MenuIndex < JangwonList.Count) then begin
    pj := PTClientJangwon(JangwonList[MenuIndex]);
  end;

end;

procedure TFrmDlg.SetChatFocus;
begin
  ItemSearchEdit.Visible   := False;
  PlayScene.EdChat.Visible := True;
  PlayScene.EdChat.SetFocus;
end;

procedure TFrmDlg.DJangwonListDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);

  function SX(x: integer): integer;
  begin
    Result := DJangwonListDlg.SurfaceX(DJangwonListDlg.Left + x);
  end;

  function SY(y: integer): integer;
  begin
    Result := DJangwonListDlg.SurfaceY(DJangwonListDlg.Top + y);
  end;

var
  i, menuline: integer;
  d:  TDirectDrawSurface;
  pj: PTClientJangwon;
begin
  i  := 0;
  pj := nil;

  with dsurface.Canvas do begin
    with DJangwonListDlg do begin
      d := DJangwonListDlg.WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;

    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    SetBkMode(Handle, TRANSPARENT);
    Font.Color := clWhite;
    menuline   := _MIN(MAXMENU, JangwonList.Count);

    TextOut(SX(15), SY(32), 'Num');
    TextOut(SX(68), SY(32), 'Guild Name');
    TextOut(SX(223), SY(32), 'Guild Masters'); //(SX(191)
    TextOut(SX(383), SY(32), 'Sale Price');    //SX(271)
    TextOut(SX(463), SY(32), 'Status');        //SX(355)

    //      for i:=MenuTop to MenuTop+menuline-1 do begin
    for i := 0 to menuline - 1 do begin
      //         m := i-MenuTop;
      pj := PTClientJangwon(JangwonList[i]);

      if i = MenuIndex then
        Font.Color := clRed
      else
        Font.Color := clWhite;

      if pj <> nil then begin
        TextOut(SX(19), SY(51 + LISTLINEHEIGHT2 * i),
          format('%2s', [IntToStr(pj.Num)]));
        TextOut(SX(58), SY(51 + LISTLINEHEIGHT2 * i), pj.GuildName);
        TextOut(SX(160), SY(51 + LISTLINEHEIGHT2 * i), pj.CaptaineName1);
        TextOut(SX(260), SY(51 + LISTLINEHEIGHT2 * i), ', ' + pj.CaptaineName2);
        TextOut(SX(355), SY(51 + LISTLINEHEIGHT2 * i),
          format('%14s', [GetGoldStr(pj.SellPrice)])); //SX(249)
        TextOut(SX(461), SY(51 + LISTLINEHEIGHT2 * i), pj.SellState); //SX(348)
      end;
    end;

    Font.Color := clWhite;
    Release;
  end;
end;

procedure TFrmDlg.DJangwonCloseClick(Sender: TObject; X, Y: integer);
begin
  DJangwonListDlg.Visible := False;
  BoMemoJangwon := False;
end;

procedure TFrmDlg.DJangListPrevClick(Sender: TObject; X, Y: integer);
begin
  MenuIndex := -1;
  if MenuTop = 10 then
    FrmMain.SendGetJangwonList(1);
end;

procedure TFrmDlg.DJangMemoClick(Sender: TObject; X, Y: integer);
var
  pj: PTClientJangwon;
begin
  if MenuIndex < 0 then
    Exit;
  pj := nil;

  ViewWindowNo   := VIEW_MAILSEND;
  ViewWindowData := CurrentMail;
  DMemoB1.SetImgIndex(FrmMain.WProgUse, 546);
  DMemoB2.SetImgIndex(FrmMain.WProgUse, 538);
  DMemoB1.Visible := True;
  MemoMail.Clear;
  //   MemoMail.ReadOnly := false;

  pj := PTClientJangwon(JangwonList[MenuIndex]);
  MemoCharID := pj.CaptaineName1;
  MemoCharID2 := pj.CaptaineName2;

  DMemo.Left := 410;
  DMemo.Top  := 198;
  Memo.Clear;
  BoMemoJangwon := True;
  ShowEditMail;

end;

procedure TFrmDlg.DJangListNextClick(Sender: TObject; X, Y: integer);
begin
  MenuIndex := -1;
  if MenuTop = 0 then
    FrmMain.SendGetJangwonList(2);
end;

procedure TFrmDlg.DGABoardReplyVisibleOk(Index, ReplyCount: integer;
  dsurface: TDirectDrawSurface);

  function SX(x: integer): integer;
  begin
    Result := DGABoardListDlg.SurfaceX(DGABoardListDlg.Left + x);
  end;

  function SY(y: integer): integer;
  begin
    Result := DGABoardListDlg.SurfaceY(DGABoardListDlg.Top + y);
  end;

var
  d: TDirectDrawSurface;
begin
  d := FrmMain.WProgUse.Images[690];
  if d <> nil then
    dsurface.Draw(SX(109 + (ReplyCount * REPLYIMGPOS)),
      SY(65 + MAKETLINEHEIGHT * Index), d.ClientRect, d, True);
end;


procedure TFrmDlg.DGABoardListDlgDblClick(Sender: TObject);
var
  lx, ly, idx: integer;
  pb:      PTClientGABoard;
  SendStr: string;
begin

  GABoard_BoWrite := 0;
  GABoard_BoReply := 0;
  pb := nil;
  lx := DGABoardListDlg.LocalX(GABoard_X) - DGABoardListDlg.Left;
  ly := DGABoardListDlg.LocalY(GABoard_Y) - DGABoardListDlg.Top;
  if (lx >= 13) and (lx <= 411) and (ly >= 65) and (ly <= 253) then begin
    idx := (ly - 65) div MAKETLINEHEIGHT;
    if idx < GABoardList.Count then begin
      PlaySound(s_glass_button_click);
      MenuIndex := idx;
    end;

    if (MenuIndex >= 0) and (MenuIndex < GABoardList.Count) then begin
      pb      := PTClientGABoard(GABoardList[MenuIndex]);
      SendStr := IntToStr(pb.IndexType1) + '/' + IntToStr(pb.IndexType2) +
        '/' + IntToStr(pb.IndexType3) + '/' + IntToStr(pb.IndexType4);
      if (Trim(pb.WrigteUser) = Trim(Myself.UserName)) then
        Memo.ReadOnly := False
      else
        Memo.ReadOnly := True;
      FrmMain.SendGABoardRead(SendStr);
    end;
  end;

end;

procedure TFrmDlg.DGABoardListDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);

  function SX(x: integer): integer;
  begin
    Result := DGABoardListDlg.SurfaceX(DGABoardListDlg.Left + x);
  end;

  function SY(y: integer): integer;
  begin
    Result := DGABoardListDlg.SurfaceY(DGABoardListDlg.Top + y);
  end;

var
  i, menuline: integer;
  d, TempSurface: TDirectDrawSurface;
  pb: PTClientGABoard;
  TempTitleMsg: string[36];
begin
  i  := 0;
  pb := nil;

  with dsurface.Canvas do begin
    with DGABoardListDlg do begin
      d := DGABoardListDlg.WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;

    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    SetBkMode(Handle, TRANSPARENT);
    Font.Color := clWhite;
    menuline   := _MIN(MAXMENU, GABoardList.Count);

    i := (142 - TextWidth(GABoard_GuildName)) div 2;
    TextOut(SX(118 + i), SY(15), GABoard_GuildName);
    TextOut(SX(45), SY(46), 'Writer');
    TextOut(SX(234), SY(46), 'Substance');

    TextOut(SX(343), SY(15), format('%2d', [GABoard_CurPage]));
    if GABoard_MaxPage < 1 then
      TextOut(SX(360), SY(15), '/ ' + '1')
    else
      TextOut(SX(360), SY(15), '/ ' + IntToStr(GABoard_MaxPage));

    for i := 0 to menuline - 1 do begin
      pb := PTClientGABoard(GABoardList[i]);

      if i in [0, 1, 2] then
        Font.Color := clYellow
      else
        Font.Color := clWhite;

      if i in [0, 1, 2] then
        pb.ReplyCount := 0;
      if pb <> nil then begin
        if pb.ReplyCount > 0 then begin
          TextOut(SX(20), SY(68 + MAKETLINEHEIGHT * i), pb.WrigteUser);
          if pb.ReplyCount > 2 then begin
            TempTitleMsg := pb.TitleMsg;
            TextOut(SX(124 + (pb.ReplyCount * REPLYIMGPOS)),
              SY(68 + MAKETLINEHEIGHT * i), TempTitleMsg);
          end else
            TextOut(SX(124 + (pb.ReplyCount * REPLYIMGPOS)),
              SY(68 + MAKETLINEHEIGHT * i), pb.TitleMsg);
        end else begin
          TextOut(SX(20), SY(68 + MAKETLINEHEIGHT * i), pb.WrigteUser);
          TextOut(SX(124), SY(68 + MAKETLINEHEIGHT * i), pb.TitleMsg);
        end;
      end;

    end;

    Font.Color := clWhite;
    Release;
  end;

  for i := 0 to menuline - 1 do begin
    pb := PTClientGABoard(GABoardList[i]);

    if i in [0, 1, 2] then
      pb.ReplyCount := 0;
    if pb <> nil then begin
      if pb.ReplyCount > 0 then
        DGABoardReplyVisibleOk(i, pb.ReplyCount, dsurface);
    end;
  end;

end;

procedure TFrmDlg.DGABoardListDlgMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  GABoard_X := X;
  GABoard_Y := Y;
end;

procedure TFrmDlg.DGABoardOkClick(Sender: TObject; X, Y: integer);
begin
  DGABoardListDlg.Visible := False;
end;

procedure TFrmDlg.DGABoardWriteClick(Sender: TObject; X, Y: integer);
begin
  GABoard_BoWrite  := 1;
  GABoard_BoNotice := 1;
  GABoard_BoReply  := 0;
  Memo.ReadOnly    := False;
  GABoard_UserName := Myself.UserName;
  GABoard_Notice.Clear;
  if DGABoardDlg.Visible then
    DGABoardCloseClick(DGABoardClose, 0, 0);
  ShowGABoardReadDlg;
end;

procedure TFrmDlg.DGABoardNoticeClick(Sender: TObject; X, Y: integer);
begin
  if GetTickCount < LastestClickTime then
    Exit;
  FrmMain.SendGABoardNoticeCheck;
  LastestClickTime := GetTickCount + 3000;
end;

procedure TFrmDlg.DGABoardListCloseClick(Sender: TObject; X, Y: integer);
begin
  GABoardList.Clear;
  DGABoardListDlg.Visible := False;
end;

procedure TFrmDlg.DGABoardListPrevClick(Sender: TObject; X, Y: integer);
begin
  if 1 < GABoard_CurPage then
    FrmMain.SendGetGABoardList(GABoard_CurPage - 1);
end;

procedure TFrmDlg.DGABoardListRefreshClick(Sender: TObject; X, Y: integer);
begin
  FrmMain.SendGetGABoardList(1);
end;

procedure TFrmDlg.DGABoardListNextClick(Sender: TObject; X, Y: integer);
begin
  if GABoard_MaxPage > GABoard_CurPage then
    FrmMain.SendGetGABoardList(GABoard_CurPage + 1);
end;

procedure TFrmDlg.DGABoardDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DGABoardDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clWhite;//clSilver;

      TextOut(Left + 16, Top + 13, GABoard_UserName);
      TextOut(Left + 18, Top + 291, GABoard_Edit);
      Release;
    end;
  end;
end;

procedure TFrmDlg.DGABoardDlgKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if Key = 27 then begin
    if DGABoardDlg.Visible then
      DGABoardCloseClick(DGABoardClose, 0, 0);
  end;
end;

procedure TFrmDlg.DGABoardDelClick(Sender: TObject; X, Y: integer);
var
  SendStr:   string;
  MsgResult: integer;
begin

  if (Trim(GABoard_UserName) = Trim(Myself.UserName)) and
    (GABoard_BoWrite = 0) and (GABoard_BoReply = 0) then begin
    Memo.Visible := False;
    MsgResult    := DMessageDlg('Are you sure to delete the writing?', [mbOK, mbCancel]);
    DGABoardDlg.ShowModal;
    Memo.Visible := True;
    if MsgResult = mrCancel then
      Exit
    else if MsgResult = mrOk then begin
      if DGABoardDlg.Visible then
        DGABoardCloseClick(DGABoardClose, 0, 0);
      SendStr := IntToStr(GABoard_IndexType1) + '/' +
        IntToStr(GABoard_IndexType2) + '/' + IntToStr(GABoard_IndexType3) +
        '/' + IntToStr(GABoard_IndexType4);
      //      DScreen.AddChatBoardString ('SendGABoardDel=> ' + SendStr, clYellow, clRed);
      FrmMain.SendGABoardDel(GABoard_CurPage, SendStr);
    end;
  end;
  //   else if DGABoardDel.Visible then DGABoardDel.Visible   := False;
end;

procedure TFrmDlg.DGABoardMemoClick(Sender: TObject; X, Y: integer);
begin

  if (MenuIndex < 0) or (MenuIndex > 10) or (GABoard_UserName = '') or
    (GABoard_UserName = MySelf.UserName) then
    Exit;
  if DGABoardDlg.Visible then
    DGABoardCloseClick(DGABoardClose, 0, 0);
  ViewWindowNo   := VIEW_MAILSEND;
  ViewWindowData := CurrentMail;
  DMemoB1.SetImgIndex(FrmMain.WProgUse, 546);
  DMemoB2.SetImgIndex(FrmMain.WProgUse, 538);
  DMemoB1.Visible := True;
  MemoMail.Clear;

  MemoCharID := GABoard_UserName;

  DMemo.Left    := 410;
  DMemo.Top     := 198;
  BoMemoJangwon := False;
  Memo.Clear;
  ShowEditMail;

end;

procedure TFrmDlg.DGABoardCloseClick(Sender: TObject; X, Y: integer);
begin
  GABoard_Notice.Clear;
  DGABoardDlg.Visible := False;
  Memo.ReadOnly := False;
  Memo.Visible  := False;
  //   DMsgDlg.DialogResult := mrCancel;
end;

procedure TFrmDlg.DGABoardReplyClick(Sender: TObject; X, Y: integer);
begin
  if MenuIndex in [0, 1, 2] then begin
    GABoard_BoReply := 0;
    DScreen.AddChatBoardString('You can not post a reply on the announcement.',
      clYellow, clRed);
    Exit;
  end else
    GABoard_BoReply := 1;

  if DGABoardDlg.Visible then
    DGABoardCloseClick(DGABoardClose, 0, 0);
  ShowGABoardReadDlg;
end;

procedure TFrmDlg.DGABoardOk2Click(Sender: TObject; X, Y: integer);
var
  Data: string;
  i:    integer;
begin
  for i := 0 to Memo.Lines.Count - 1 do begin
    if Memo.Lines[i] = '' then
      Data := Data + Memo.Lines[i] + ' '#13
    else
      Data := Data + Memo.Lines[i] + #13;
  end;
  if Length(StrToSqlSafe(Data)) >= 500 then begin
    Memo.Visible := False;
    DMessageDlg('The total number of letters exceeded the limit.\Please edit it again.',
      [mbOK]);
    DGABoardDlg.ShowModal;
    Memo.Visible := True;
    Exit;
  end;

  DGABoardCloseClick(self, 0, 0);
  //   DScreen.AddChatBoardString ('====SendGABoardOkProg====;', clYellow, clRed);
  //   DMsgDlg.DialogResult := mrOk;
  SendGABoardOkProg;
end;

procedure TFrmDlg.DGADecorateDlgClick(Sender: TObject; X, Y: integer);
var
  lx, ly, idx: integer;
  pd: PTClientGADecoration;
begin

  pd := nil;
  lx := DGADecorateDlg.LocalX(X) - DGADecorateDlg.Left;
  ly := DGADecorateDlg.LocalY(Y) - DGADecorateDlg.Top;
  if (lx >= 11) and (lx <= 275) and (ly >= 64) and (ly <= 294) then begin
    idx := (ly - 70) div MAKETLINEHEIGHT + MenuTop;
    if idx < GADecorationList.Count then begin
      PlaySound(s_glass_button_click);
      MenuIndex := idx;
    end;
  end;

  if (MenuIndex >= 0) and (MenuIndex < GADecorationList.Count) then begin
    pd := PTClientGADecoration(GADecorationList[MenuIndex]);
  end;
end;

procedure TFrmDlg.DGADecorateDlgDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);

  function SX(x: integer): integer;
  begin
    Result := DGADecorateDlg.SurfaceX(DGADecorateDlg.Left + x);
  end;

  function SY(y: integer): integer;
  begin
    Result := DGADecorateDlg.SurfaceY(DGADecorateDlg.Top + y);
  end;

var
  i, m, menuline, ImgX, ImgY: integer;
  d, TempSurface: TDirectDrawSurface;
  pd: PTClientGADecoration;
begin
  i  := 0;
  pd := nil;

  with dsurface.Canvas do begin
    with DGADecorateDlg do begin
      d := DGADecorateDlg.WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    end;

    SetBkMode(dsurface.Canvas.Handle, TRANSPARENT);
    SetBkMode(Handle, TRANSPARENT);
    Font.Color := clWhite;
    menuline   := _MIN(DECOMAXMENU, GADecorationList.Count - MenuTop);
    //      DScreen.AddChatBoardString ('GADecorationList.Count=> ' +IntToStr(GADecorationList.Count), clYellow, clRed);

    TextOut(SX(93), SY(15), 'Decoration List');
    TextOut(SX(513), SY(16), format('%3d', [(MenuTop + 12) div 12]));
    if GADecorationList.Count < 13 then
      TextOut(SX(538), SY(16), '/ ' + '1')
    else
      TextOut(SX(538), SY(16), '/ ' + IntToStr((GADecorationList.Count div 12) + 1));

    //      TextOut (SX(513), SY(16), format('%3d',[DecoCurPage);
    //      TextOut (SX(538), SY(16), '/ ' + IntToStr((GADecorationList.Count div 12)+1 ));

    //      TextOut (SX(15),  SY(32), '번호');
    TextOut(SX(61), SY(47), 'Name');
    TextOut(SX(183), SY(47), 'Price'); //SX(271)

    for i := MenuTop to MenuTop + menuline - 1 do begin
      //      for i:=0 to menuline-1 do begin
      m  := i - MenuTop;
      pd := PTClientGADecoration(GADecorationList[i]);

      if i = MenuIndex then
        Font.Color := clRed
      else
        Font.Color := clWhite;

      if pd <> nil then begin
        //            TextOut (SX(19),  SY(70 + MAKETLINEHEIGHT * i), format('%2s',[IntToStr(pd.Num)]));
        TextOut(SX(26), SY(70 + MAKETLINEHEIGHT * m), pd.Name);
        TextOut(SX(158), SY(70 + MAKETLINEHEIGHT * m),
          format('%14s', [GetGoldStr(pd.Price)])); //SX(249)
      end;
    end;

    Font.Color := clWhite;
    if (MenuIndex >= 0) and (MenuIndex < GADecorationList.Count) then begin
      pd := PTClientGADecoration(GADecorationList[MenuIndex]);
      if pd.CaseNum = 1 then
        TextOut(SX(17), SY(306), 'Can Set Inside')
      else if pd.CaseNum = 2 then
        TextOut(SX(17), SY(306), 'Can Set Outside')
      else if pd.CaseNum = 3 then
        TextOut(SX(17), SY(306), 'Can Set Inside, Outside');
    end;
    Release;
  end;

  if (MenuIndex >= 0) and (MenuIndex < GADecorationList.Count) then begin
    pd := PTClientGADecoration(GADecorationList[MenuIndex]);

    if pd.Num = 140 then
      pd.ImgIndex := 300
    else if pd.Num = 141 then
      pd.ImgIndex := 301
    else if pd.Num = 156 then
      pd.ImgIndex := 302
    else if pd.Num = 157 then
      pd.ImgIndex := 303
    else if pd.Num = 163 then
      pd.ImgIndex := 304
    else if pd.Num = 165 then
      pd.ImgIndex := 305
    else if pd.Num = 185 then
      pd.ImgIndex := 306;

    TempSurface := FrmMain.WDecoImg.Images[pd.ImgIndex];
    if TempSurface <> nil then begin
      ImgX := 285 + ((312 - TempSurface.Width) div 2);
      ImgY := 72 + ((285 - TempSurface.Height) div 2);

      dsurface.Draw(SX(ImgX), SY(ImgY),
        TempSurface.ClientRect, TempSurface, True);
    end;
  end;

end;

procedure TFrmDlg.DGADecorateDlgKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if Key = 27 then
    if DGADecorateDlg.Visible then
      DGADecorateDlg.Visible := False;

  //   DScreen.ClearHint;
  case key of
    VK_UP: begin
      if (MenuTop <= (MenuIndex - 1)) and (MenuIndex <> -1) then begin
        Dec(MenuIndex, 1);
        DGADecorateDlgClick(DGADecorateDlg, 0, 0);
      end;
    end;
    VK_DOWN: begin
      if (MenuTop + DECOMAXMENU > (MenuIndex + 1)) and (MenuIndex <> -1) and
        ((MenuIndex + 1) < GADecorationList.Count) then begin
        Inc(MenuIndex, 1);
        DGADecorateDlgClick(DGADecorateDlg, 0, 0);
      end;
    end;
    VK_LEFT: begin
      DGADecorateListPrevClick(DGADecorateListPrev, 0, 0);
    end;
    VK_RIGHT: begin
      DGADecorateListNextClick(DGADecorateListNext, 0, 0);
    end;
    else
  end;

end;

procedure TFrmDlg.DGADecorateCloseClick(Sender: TObject; X, Y: integer);
begin
  DGADecorateDlg.Visible := False;
end;

procedure TFrmDlg.DGADecorateListPrevClick(Sender: TObject; X, Y: integer);
begin
  MenuIndex := -1;
  if MenuTop > 0 then begin
    Dec(MenuTop, DECOMAXMENU);
    if MenuTop < 0 then
      MenuTop := 0;
  end;
  MenuIndex := MenuTop;
  DGADecorateDlgClick(DGADecorateDlg, 0, 0);
end;

procedure TFrmDlg.SafeCloseDlg;
begin
  if DMakeItemDlg.Visible then
    DMakeItemDlgOkClick(DMakeItemDlgCancel, 0, 0);
  if DItemMarketDlg.Visible then
    CloseItemMarketDlg;
  if DJangwonListDlg.Visible then
    DJangwonCloseClick(DJangwonClose, 0, 0);
  if DGABoardListDlg.Visible then
    DGABoardListCloseClick(FrmDlg.DGABoardListClose, 0, 0);
  if DGABoardDlg.Visible then
    DGABoardCloseClick(FrmDlg.DGABoardClose, 0, 0);
  if DGADecorateDlg.Visible then
    DGADecorateCloseClick(DGADecorateClose, 0, 0);
end;

function TFrmDlg.DecoItemDesc(Dura: word; var str: string): string;
var
  pd: PTClientGADecoration;
begin
  if (Dura >= 0) and (Dura < GADecorationList.Count) then begin
    pd := PTClientGADecoration(GADecorationList[Dura]);
    if pd.CaseNum = 1 then
      str := 'Can Set Inside'
    else if pd.CaseNum = 2 then
      str := 'Can Set Outside'
    else if pd.CaseNum = 3 then
      str := 'Can Set Inside, Outside';
    Result := 'Image: ' + pd.Name;
  end;
end;

procedure TFrmDlg.DGADecorateListNextClick(Sender: TObject; X, Y: integer);
var
  MaxNum: integer;
begin
  MenuIndex := -1;
  MaxNum    := ((GADecorationList.Count div 12) + 1) * 12;
  if (MaxNum >= GADecorationList.Count) and (MaxNum >= (MenuTop + 23)) then begin
    Inc(MenuTop, DECOMAXMENU);
  end;
  MenuIndex := MenuTop;
  DGADecorateDlgClick(DGADecorateDlg, 0, 0);

end;

procedure TFrmDlg.DGADecorateBuyClick(Sender: TObject; X, Y: integer);
var
  pd: PTClientGADecoration;
begin
  if (MenuIndex >= 0) and (MenuIndex < GADecorationList.Count) then begin
    pd := PTClientGADecoration(GADecorationList[MenuIndex]);
    FrmMain.SendBuyDecoItem(CurMerchant, pd.Num);
    if not DItemBag.Visible then begin
      DItemBag.Left    := 475;
      DItemBag.Top     := 0;
      DItemBag.Visible := True;
    end;
  end;
end;

procedure TFrmDlg.DGADecorateCancelClick(Sender: TObject; X, Y: integer);
begin
  DGADecorateDlg.Visible := False;
end;

procedure TFrmDlg.DBotFriendClick(Sender: TObject; X, Y: integer);
begin
  ToggleShowFriendsDlg;
end;

procedure TFrmDlg.DBotFriendDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d:  TDButton;
  dd: TDirectDrawSurface;
begin
  if Sender is TDButton then begin
    d := TDButton(Sender);
    if not d.Downed then begin
      dd := d.WLib.Images[d.FaceIndex];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top),
          dd.ClientRect, dd, True);
    end else begin
      dd := d.WLib.Images[d.FaceIndex + 1];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top),
          dd.ClientRect, dd, True);
    end;
  end;
end;

procedure TFrmDlg.DBotFriendMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DBotFriend do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DBottom.SurfaceX(DBottom.Left) + lx + 8;
    sy := SurfaceY(Top) + DBottom.SurfaceX(DBottom.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Friend(W)', clYellow, False);
  end;
end;

procedure TFrmDlg.DBotMemoClick(Sender: TObject; X, Y: integer);
begin
  ToggleShowMailListDlg;

  if WantMailList = False then begin
    FrmMain.SendMailList;
    FrmMain.SendRejectLIst;
    WantMailList := True;
  end;

  MailAlarm := False;

end;

procedure TFrmDlg.DBotMemoDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d:  TDButton;
  dd: TDirectDrawSurface;
begin
  DMyStateDirectPaint(Sender, dsurface);

  if Sender is TDButton then begin
    d := TDButton(Sender);
    // 깜박임 표시 ??
    if not TDButton(Sender).Downed and MailAlarm then begin
      if (GetTickCount mod 1000) > 500 then
        dd := d.WLib.Images[d.FaceIndex]
      else
        dd := d.WLib.Images[d.FaceIndex + 1];

      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top), dd.ClientRect, dd, True);

    end;
  end;
end;

procedure TFrmDlg.DBotMemoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DBotMemo do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DBottom.SurfaceX(DBottom.Left) + lx + 8;
    sy := SurfaceY(Top) + DBottom.SurfaceX(DBottom.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Note(M)', clYellow, False);
  end;

end;

procedure TFrmDlg.ToggleShowFriendsDlg;
begin
  DFriendDlg.Visible := not DFriendDlg.Visible;
end;

procedure TFrmDlg.ToggleShowMailListDlg;
begin
  DMailListDlg.Visible := not DMailListDlg.Visible;
  MailAlarm := False;
end;

procedure TFrmDlg.ToggleShowBlockListDlg;
begin
  DBlockListDlg.Visible := not DBlockListDlg.Visible;
end;

procedure TFrmDlg.ToggleShowMemoDlg;
begin
  DMemo.Visible    := not DMemo.Visible;
  MemoMail.Visible := DMemo.Visible;
end;

procedure TFrmDlg.ShowEditMail;
var
  d:    TDirectDrawSurface;
  i:    integer;
  Data: string;
begin
  with DMemo do begin

    d := WLib.Images[FaceIndex];
    if d <> nil then begin
      //         Left := (SCREENWIDTH - d.Width) div 2;
      //         Top := (SCREENHEIGHT - d.Height) div 2;
    end;
    HideAllControls;

    //메모창 크기 설정
{
      case ViewWindowNo of
      VIEW_MAILREAD:
            begin
            memoMail.Left  := SurfaceX(Left+21);
            memoMail.Top   := SurfaceY(Top+36+14);
            memoMail.Width := 146;
            memoMail.Height:= 72 - 14;
            end;
      else
            begin
            memoMail.Left := SurfaceX(Left+21);
            memoMail.Top  := SurfaceY(Top+36);
            memoMail.Width := 146;
            memoMail.Height := 72;
            end;
      end;
}
    // 메모 변경인 경우 기존 메모를 대입
    if ViewWindowNo = VIEW_MEMO then begin
      BackupMemoMail := memoMail.Text;
    end;
    memomail.MaxLength := 80;
    if not memoMail.Visible then
      memoMail.Visible := True;


    SetImeMode(MemoMail.Handle, imSHanguel);
    DMemo.Show;


    while True do begin
      if not DMemo.Visible then
        break;
      FrmMain.DXTimerTimer (self, 0);
      //FrmMain.ProcOnIdle;
      Application.ProcessMessages;
      if Application.Terminated then
        exit;
    end;

    DMemo.Visible := False;
    RestoreHideControls;

    if DMsgDlg.DialogResult = mrOk then begin
      //결과... 문파공지사항을 업데이트 한다.
      Data := '';
      for i := 0 to Memo.Lines.Count - 1 do begin
        if Memo.Lines[i] = '' then
          Data := Data + Memo.Lines[i] + ' '#13
        else
          Data := Data + Memo.Lines[i] + #13;
      end;
      Data := ConvertEscChar(Data);
      if Length(Data) > 70 then begin
        Data := Copy(Data, 1, 70);
        DMessageDlg(
          'The number of letters in the note has exceeded the limit\so the exceeded part won''t be displayed.',
          [mbOK]);
      end;
      //case ViewWindowNo of
      //1: FrmMain.SendAddFriend (data);
      //2: FrmMain.SendMail (data);
      //3: begin end;
      //4: FrmMain.SendUpdateFriend (data);
      //end;
    end;
  end;
end;

function TFrmDlg.ConvertEscChar(str: string): string;
begin
  // Convert...
  Result := str;
end;

procedure TFrmDlg.AddFriend(FriendName: string; ShowMessage: boolean);
var
  frdtype: integer;
begin
  if FriendName <> '' then begin
    // 자신은 등록할 수 없다
    if FriendName = MySelf.UserName then begin
      if ShowMessage then
        DMessageDlg('You can not register yourself.', [mbOK]);
      Exit;
    end;

    if FrmMain.IsMyMember(FriendName) then begin
      if ShowMessage then
        DMessageDlg(FriendName + 'is already registered.', [mbOK]);
      Exit;
    end;

    if ViewFriends then
      frdtype := 1
    else
      frdtype := 8;
    FrmMain.SendAddFriend(FriendName, frdtype);
  end;

end;

procedure TFrmDlg.ShowItemMarketDlg; //2004/01/15 ItemMarket..
var
  i: integer;
begin

  DSellDlg.Visible := False;
  BoInRect := False;

  if not DItemBag.Visible then begin
    DItemBag.Left    := 475;
    DItemBag.Top     := 0;
    DItemBag.Visible := True;
  end;
  if not DItemMarketDlg.Visible then begin
    DItemMarketDlg.Left    := 0; //10;
    DItemMarketDlg.Top     := 90;//20;
    DItemMarketDlg.Visible := True;
  end;

  if g_Market.GetFirst = 1 then begin
    MenuTop   := 0;
    MenuIndex := -1;
  end;

  //   HideAllControls;
  //   DItemMarketDlg.ShowModal;
  DItemMarketDlg.Show;

  with ItemSearchEdit do begin
    Text  := '';
    Width := 124;
    Left  := DItemMarketDlg.Left + 13;
    Top   := DItemMarketDlg.Top + 328;
  end;

  if g_Market.GetUserMode = 1 then begin
    DItemBuy.Visible  := True;
    DItemSellCancel.Visible := False;
    DItemFind.Visible := True;
    DItemMarketDlg.EnableFocus := True;
    ItemSearchEdit.Visible := True;
    ItemSearchEdit.SetFocus;
    DlgEditText := ItemSearchEdit.Text;
  end else if g_Market.GetUserMode = 2 then begin
    DItemBuy.Visible  := False;
    DItemSellCancel.Visible := True;
    DItemFind.Visible := False;
    ItemSearchEdit.Visible := False;
  end;
  DItemCancel.Visible := True;

  SetImeMode(PlayScene.EdChat.Handle, imSHanguel);//@@@@
  //   RestoreHideControls;
  if PlayScene.EdChat.Visible then
    PlayScene.EdChat.SetFocus;

  LastestClickTime := GetTickCount;

end;

procedure TFrmDlg.ShowJangwonDlg; //2004/01/15 ItemMarket..
var
  i: integer;
begin

  BoMemoJangwon    := False;
  DSellDlg.Visible := False;

  if not DJangwonListDlg.Visible then begin
    DJangwonListDlg.Left    := 0;  //10;
    DJangwonListDlg.Top     := 175;//20;
    DJangwonListDlg.Visible := True;
  end;

  MenuIndex := -1;
  DJangwonListDlg.Show;
  LastestClickTime := GetTickCount;

end;

procedure TFrmDlg.ShowGADecorateDlg; //2004/06/18 장원 꾸미기
var
  i: integer;
begin

  if not DItemBag.Visible then begin
    DItemBag.Left := 475;
    DItemBag.Top  := 0;
    //      DItemBag.Visible := TRUE;
  end;
  if not DGADecorateDlg.Visible then begin
    DGADecorateDlg.Left    := 0; //10;
    DGADecorateDlg.Top     := 55;//90;//20;
    DGADecorateDlg.Visible := True;
  end;

  MenuTop   := 0;
  MenuIndex := 0;

  DGADecorateDlg.Show;
  LastestClickTime := GetTickCount;

end;

procedure TFrmDlg.ShowGABoardListDlg;
var
  i: integer;
begin

  //   BoMemoJangwon := False;
  DSellDlg.Visible := False;
  GABoard_BoWrite  := 0;
  GABoard_BoNotice := 1;

  if not DGABoardListDlg.Visible then begin
    DGABoardListDlg.Left    := 0;  //10;
    DGABoardListDlg.Top     := 175;//20;
    DGABoardListDlg.Visible := True;
  end;

  MenuIndex := -1;
  DGABoardListDlg.Show;
  LastestClickTime := GetTickCount;

end;

procedure TFrmDlg.ShowGABoardReadDlg;
var
  d:    TDirectDrawSurface;
  i:    integer;
  Data: string;
begin
  with DGABoardDlg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then begin
      Left := 240;
      Top  := 175;
    end;

    DGABoardDlg.ShowModal;
    if (GABoard_BoReply = 1) or (GABoard_BoWrite = 1) then begin
      DGABoardReply.Visible := False;
      DGABoardDel.Visible   := False;
      DGABoardMemo.Visible  := False;
    end else begin
      DGABoardReply.Visible := True;
      DGABoardDel.Visible   := True;
      DGABoardMemo.Visible  := True;
    end;
    DGABoardOk2.Visible := True;

    if Memo.ReadOnly then begin
      DGABoardDel.Visible := False;
    end;

    Memo.Left   := SurfaceX(Left + 11);
    Memo.Top    := SurfaceY(Top + 37);
    Memo.Width  := d.Width - 22;
    Memo.Height := 142;
    Memo.Lines.Assign(GABoard_Notice);
    Memo.Visible := True;
  end;

end;

procedure TFrmDlg.SendGABoardOkProg;
var
  Data: string;
  i:    integer;
begin
  if (Trim(GABoard_UserName) <> Trim(Myself.UserName)) and
    (GABoard_BoWrite = 0) and (GABoard_BoReply = 0) then begin
    DGABoardOk2.Visible := False;
    //      DScreen.AddChatBoardString ('읽기 상태 !!!!', clYellow, clRed);
  end else begin //if DMsgDlg.DialogResult = mrOk then begin

    Data := '';
    for i := 0 to Memo.Lines.Count - 1 do begin
      if Memo.Lines[i] = '' then
        Data := Data + Memo.Lines[i] + ' '#13
      else
        Data := Data + Memo.Lines[i] + #13;
    end;
    if Length(StrToSqlSafe(Data)) > 500 then begin
      //            data := Copy (data, 1, 500);
      DMessageDlg('The total number of letters exceeded the limit.', [mbOK]);
      Exit;
    end;

    if (Trim(GABoard_UserName) = Trim(Myself.UserName)) and
      (GABoard_BoWrite = 0) and (GABoard_BoReply = 0) then begin
      Data := IntToStr(GABoard_IndexType1) + '/' + IntToStr(GABoard_IndexType2) +
        '/' + IntToStr(GABoard_IndexType3) + '/' + IntToStr(GABoard_IndexType4) +
        '/' + StrToSqlSafe(Data);
      FrmMain.SendGABoardModify(GABoard_CurPage, Data);
      //   DScreen.AddChatBoardString ('수정보냄!!', clYellow, clRed);
      Memo.Clear;
      Exit;
    end else if GABoard_BoReply = 1 then begin
      Data := IntToStr(GABoard_IndexType1) + '/' + IntToStr(GABoard_IndexType2) +
        '/' + IntToStr(GABoard_IndexType3) + '/' + IntToStr(GABoard_IndexType4) +
        '/' + StrToSqlSafe(Data);
      //      DScreen.AddChatBoardString ('답글보냄!!', clYellow, clRed);
    end else begin
      //      DScreen.AddChatBoardString ('글쓰기보냄!!', clYellow, clRed);
      Data := '0/0/0/0/' + StrToSqlSafe(Data);
    end;

    //     DScreen.AddChatBoardString (data, clYellow, clRed);
    FrmMain.SendGABoardUpdateNotice(GABoard_BoNotice, GABoard_CurPage, Data);
    Memo.Clear;
    DMsgDlg.DialogResult := mrCancel;
  end;

end;

procedure TFrmDlg.SendGABoardNoticeOk;
begin
  GABoard_BoWrite  := 1;
  GABoard_BoNotice := 0;
  GABoard_BoReply  := 0;
  Memo.ReadOnly    := False;
  GABoard_UserName := Myself.UserName;
  GABoard_Notice.Clear;
  if DGABoardDlg.Visible then
    DGABoardCloseClick(DGABoardClose, 0, 0);
  ShowGABoardReadDlg;
end;

procedure TFrmDlg.DDealJangwonDirectPaint(Sender: TObject;
  dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DDealJangwon do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
    with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      Font.Color := clWhite;
      Font.Size  := 12;
      Font.Style := [fsBold];
      //         TextOut (SurfaceX(Left+93), SurfaceY(Top+9), 'Guild Territory Trade');
      TextOut(SurfaceX(Left + 50), SurfaceY(Top + 9), 'Guild Territory Trade');
      Font.Size  := 9;
      Font.Style := [];
      Release;
    end;
  end;
end;

procedure TFrmDlg.DFrdBlackListClick(Sender: TObject; X, Y: integer);
begin
  ViewFriends     := False;
  DFriendDlg.hint := '';
end;

procedure TFrmDlg.DMasterDlgClick(Sender: TObject; X, Y: integer);
begin
  ItemSearchEdit.Visible := False;
end;

procedure TFrmDlg.DMasterDlgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d:    TDirectDrawSurface;
  b:    TDirectDrawSurface;
  lx, ly, n, t, l, ax, ay: integer;
  Rect: TRect;
  CurrentPage, maxPage, UpPage, DownPage: integer;
begin

  with (Sender as TDWindow) do begin
    if fLover.GetEnable(RsState_Lover) = 1 then
      DLover1.SetImgIndex(FrmMain.WProgUse, 602)
    else
      DLover1.SetImgIndex(FrmMain.WProgUse, 600);

    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);

    b := FrmMain.WProgUse.GetCachedImage(582, ax, ay);
    dsurface.Draw(SurfaceX(Left + 5), SurfaceY(Top + 5), b.ClientRect, b, True);
    b := FrmMain.WProgUse.GetCachedImage(580, ax, ay);
    dsurface.Draw(SurfaceX(Left + 168), SurfaceY(Top + 136), b.ClientRect, b, True);
    b := FrmMain.WProgUse.GetCachedImage(581, ax, ay);
    dsurface.Draw(SurfaceX(Left + 32), SurfaceY(Top + 360), b.ClientRect, b, True);

    dsurface.Canvas.Font.Color  := clSilver;
    dsurface.Canvas.Brush.Color := clBlack;
    dsurface.Canvas.Brush.Style := bsClear;

    lx := SurfaceX(30) + Left;
    ly := SurfaceY(32) + Top + (1 * 15);
    dsurface.Canvas.TextOut(lx, ly, fLover.GetDisplay(0));
    ly := SurfaceY(32) + Top + (3 * 15);
    dsurface.Canvas.TextOut(lx, ly, fLover.GetDisplay(1));
    ly := SurfaceY(32) + Top + (5 * 15);
    dsurface.Canvas.TextOut(lx, ly, fLover.GetDisplay(2));

    dsurface.Canvas.Release;

  end;

end;

procedure TFrmDlg.DMasterDlgMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  DScreen.ClearHint;
end;

procedure TFrmDlg.DLover1Click(Sender: TObject; X, Y: integer);
var
  sendenable: integer;
begin
  if fLover.GetEnable(RsState_Lover) = 1 then
    sendenable := 0
  else
    sendenable := 1;

  FrmMain.SendLMOptionChange(1, sendenable);

end;

procedure TFrmDlg.DLover1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DFrdAdd do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DMasterDlg.SurfaceX(DMasterDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DMasterDlg.SurfaceX(DMasterDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Select Availability', clYellow, False);
    DFriendDlg.hint := '';
  end;
end;

procedure TFrmDlg.DLover2Click(Sender: TObject; X, Y: integer);
begin
  FrmMain.SendLMRequest(RsState_Lover, RsReq_WantToJoinOther);
end;

procedure TFrmDlg.DLover2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DFrdAdd do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DMasterDlg.SurfaceX(DMasterDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DMasterDlg.SurfaceX(DMasterDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Invite to a relationship', clYellow, False);
    DFriendDlg.hint := '';
  end;

end;

procedure TFrmDlg.DLover3Click(Sender: TObject; X, Y: integer);
var
  Name: string;
begin
  Name := fLover.GetName(RsState_Lover);
  //     DScreen.AddSysMsg ( 'LOVER3_CLCIK:'+Name );
  if mrCancel = DMessageDlg(
    'Will you break the relationship?\If the relationship is broken,\100,000 Gold is automatically paid to compensate for the breach.',
    [mbYes, mbCancel]) then
    Exit;
  if Name <> '' then
    FrmMain.SendLMSeparate(RsState_Lover, Name);

end;

procedure TFrmDlg.DLover3MouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DFrdAdd do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DMasterDlg.SurfaceX(DMasterDlg.Left) + lx + 8;
    sy := SurfaceY(Top) + DMasterDlg.SurfaceX(DMasterDlg.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Break the relationship', clYellow, False);
    DFriendDlg.hint := '';
  end;

end;

procedure TFrmDlg.ToggleShowMasterDlg;
begin
  DMasterDlg.Visible := not DMasterDlg.Visible;
  // 화면을 열때마다 디스플레이 정보를 갱신해준다.
  if DMasterDlg.Visible then
    flover.MakeDisplay;
end;

procedure TFrmDlg.DMasterCloseClick(Sender: TObject; X, Y: integer);
begin
  ToggleShowMasterDlg;
end;

procedure TFrmDlg.DMarketMemoClick(Sender: TObject; X, Y: integer);
begin
  if trim(MemoCharID) <> '' then begin
    ViewWindowNo := VIEW_MAILSEND;
    DMemoB1.SetImgIndex(FrmMain.WProgUse, 546);
    DMemoB2.SetImgIndex(FrmMain.WProgUse, 538);
    DMemoB1.Visible := True;
    memoMail.Clear;
    ShowEditMail;
  end else
    DMessageDlg('No target has been selected.', [mbOK]);
end;

procedure TFrmDlg.DMemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = 27 then
    if DMemo.Visible then
      DMemoCloseClick(DMemoClose, 0, 0);
end;

procedure TFrmDlg.DHeartImgDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DHeartImg do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
  end;
end;

procedure TFrmDlg.DHeartImgUSDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  with DHeartImgUS do begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
  end;
end;

procedure TFrmDlg.DBotMasterClick(Sender: TObject; X, Y: integer);
begin
  ToggleShowMasterDlg;
end;

procedure TFrmDlg.DBotMasterMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  lx, ly: integer;
  sx, sy: integer;
begin
  with DBotFriend do begin
    lx := LocalX(X - Left);
    ly := LocalY(Y - Top);
    sx := SurfaceX(Left) + DBottom.SurfaceX(DBottom.Left) + lx + 8;
    sy := SurfaceY(Top) + DBottom.SurfaceX(DBottom.Top) + ly + 6;
    DScreen.ShowHint(sx, sy, 'Relationship Window (L)', clYellow, False);
  end;

end;


//Added by Lilcooldoode

procedure TFrmDlg.DBotMiniMapDirectPaint(Sender: TObject; dsurface: TDirectDrawSurface);
var
  d:  TDButton;
  dd: TDirectDrawSurface;
begin
  if Sender is TDButton then begin
    d := TDButton(Sender);
    if d.Downed then begin
      dd := d.WLib.Images[d.FaceIndex];
      if dd <> nil then
        dsurface.Draw(d.SurfaceX(d.Left), d.SurfaceY(d.Top),
          dd.ClientRect, dd, True);
    end;
  end;
end;

end.
