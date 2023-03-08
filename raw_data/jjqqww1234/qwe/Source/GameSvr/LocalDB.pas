unit LocalDB;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, syncobjs, Grobal2, HUtil32, ObjNpc, ObjBase, M2Share, mudutil,
  FileCtrl;

const
  ZENFILE      = 'MonGen.txt';
  ZENMSGFILE   = 'GenMsg.txt';
  MAPDEFFILE   = 'MapInfo.txt';
  MONBAGDIR    = 'MonItems\';
  ADMINDEFFILE = 'AdminList.txt';
  // 2003/08/28 채팅로그
  CHATLOGFILE  = 'ChatLog.txt';
  MERCHANTFILE = 'Merchant.txt';
  MARKETDEFDIR = 'Market_Def\';
  MARKETSAVEDDIR = 'Market_Saved\';
  MARKETPRICESDIR = 'Market_Prices\';
  MARKETUPGRADEDIR = 'Market_Upg\';
  GUARDLISTFILE = 'GuardList.txt';
  MAKEITEMFILE = 'MakeItem.txt';
  NPCLISTFILE  = 'Npcs.txt';
  NPCDEFDIR    = 'Npc_def\';
  STARTPOINTFILE = 'StartPoint.txt';
  SAFEPOINTFILE = 'SafePoint.txt';
  DECOITEMFILE = 'DecoItem.txt';
  MINIMAPFILE  = 'MiniMap.txt';
  UNBINDFILE   = 'UnbindList.txt';
  MAPQUESTFILE = 'MapQuest.txt';
  MAPQUESTDIR  = 'MapQuest_def\';
  QUESTDIARYDIR = 'QuestDiary\';
  QUESTDEFINEDIR = 'Defines\';
  STARTUPDIR   = 'Startup\';
  STARTUPQUESTFILE = 'StartupQuest';

type
  TGoodsHeader = record
    RecordCount: integer;
    dummy: array[0..251] of integer;
  end;
  PTGoodsHeader = ^TGoodsHeader;

  TFrmDB = class(TForm)
    Query: TQuery;
  private
  public
    function LoadStdItems: integer;
    function LoadMonsters: integer;
    function LoadMagic: integer;
    function LoadZenLists: integer;
    function LoadGenMsgLists: integer;
    function LoadMapFiles: integer;
    function LoadAdminFiles: integer;
    // 2003/08/28 채팅로그
    function LoadChatLogFiles: integer;
    // 2003/09/15 채팅 로그 추가
    function SaveChatLogFiles: integer;
    function LoadMerchants: integer;
    function ReloadMerchants: integer;
    function LoadNpcs: integer;
    function ReloadNpcs: integer;
    function LoadGuards: integer;
    function LoadMakeItemList: integer;
    function LoadStartPoints: integer;
    function LoadSafePoints: integer;
    function LoadDecoItemList: integer;
    function LoadMiniMapInfos: integer;
    function LoadUnbindItemLists: integer;
    function LoadMapQuestInfos: integer;
    function LoadStartupQuest: integer;
    procedure ClearQuestDiary;
    function LoadQuestDiary: integer;

    function LoadMonItems(monname: string; var ilist: TList): integer;
    function LoadMarketDef(npc: TNormNpc; basedir, marketname: string;
      bomarket: boolean): integer;
    //function  LoadMarketDef (merchant: TMerchant; marketname: string): integer;
    function LoadNpcDef(npc: TNormNpc; basedir, npcname: string): integer;
    function LoadMarketSavedGoods(merchant: TMerchant; marketname: string): integer;
    function WriteMarketSavedGoods(merchant: TMerchant; marketname: string): integer;
    function LoadMarketPrices(merchant: TMerchant; marketname: string): integer;
    function WriteMarketPrices(merchant: TMerchant; marketname: string): integer;
    function LoadMarketUpgradeInfos(marketname: string; upglist: TList): integer;
    function WriteMarketUpgradeInfos(marketname: string; upglist: TList): integer;
  end;

var
  FrmDB: TFrmDB;

implementation

{$R *.DFM}

uses
  svMain, Envir, SQLLocalDB;

{$ifdef LOADSQL}
function TFrmDB.LoadStdItems: integer;
begin
  Result := -1;
  gItemMgr := TItemMgr.Create;

  if ( gItemMgr.Load( UserEngine.StdItemList , ltSQL , 0 ) ) then
    Result := 1
  else
    Result := -100;

  gItemMgr.Free;
end;

{$else}

function TFrmDB.LoadStdItems: integer;
var
  i, idx: integer;
  item:   TStdItem;
  pitem:  PTStdItem;
begin
  Result := -1;
  with Query do begin
    SQL.Clear;
    SQL.Add('select * from StdItems');
    try
      Open;
    finally
      Result := -2;
    end;

    for i := 0 to RecordCount - 1 do begin
      idx      := FieldByName('Idx').AsInteger;
      item.Name := FieldByName('NAME').AsString;
      item.StdMode := FieldByName('StdMode').AsInteger;
      item.Shape := FieldByName('Shape').AsInteger;
      item.Weight := FieldByName('Weight').AsInteger;
      item.AniCount := FieldByName('AniCount').AsInteger;
      item.SpecialPwr := FieldByName('Source').AsInteger;
      item.ItemDesc := FieldByName('Reserved').AsInteger;
      item.Looks := FieldByName('Looks').AsInteger;
      item.DuraMax := FieldByName('DuraMax').AsInteger;
      item.Ac  := MakeWord(FieldByName('Ac').AsInteger, FieldByName('Ac2').AsInteger);
      item.Mac := MakeWord(FieldByName('Mac').AsInteger,
        FieldByName('MAc2').AsInteger);
      item.Dc  := MakeWord(FieldByName('Dc').AsInteger, FieldByName('Dc2').AsInteger);
      item.Mc  := MakeWord(FieldByName('Mc').AsInteger, FieldByName('Mc2').AsInteger);
      item.Sc  := MakeWord(FieldByName('Sc').AsInteger, FieldByName('Sc2').AsInteger);
      item.Need := FieldByName('Need').AsInteger;
      item.NeedLevel := FieldByName('NeedLevel').AsInteger;
      item.Price := FieldByName('Price').AsInteger;
      if idx = UserEngine.StdItemList.Count then begin
        //아이템의 DB Index와 리스트의 인덱스가 일치해야한다.
        new(pitem);
        pitem^ := item;     //이름이 없는 아이템은 사라진 아이템임...
        UserEngine.StdItemList.Add(pitem);
        Result := 1;
      end else begin
        Result := -100;
        break;
      end;
      Next;
    end;
    Close;
  end;
end;

{$endif}


function TFrmDB.LoadMonItems(monname: string; var ilist: TList): integer;
var
  i, n, m, cnt: integer;
  flname, str, iname, Data: string;
  strlist: TStringList;
  pmi: PTMonItemInfo;
begin
  Result := 0;
  flname := EnvirDir + MONBAGDIR + monname + '.txt';
  if not FileExists(flname) then
    exit;

  if ilist <> nil then begin  //reload가능, 이전에 것 free 시킴
    for i := 0 to ilist.Count - 1 do
      Dispose(PTMonItemInfo(ilist[i]));
    ilist.Clear;
  end;

  strlist := TStringList.Create;
  strlist.LoadFromFile(flname);
  for i := 0 to strlist.Count - 1 do begin
    str := strlist[i];
    if str <> '' then begin
      if str[1] = ';' then
        continue;
      str := GetValidStr3(str, Data, [' ', '/', #9]);
      n   := Str_ToInt(Data, -1);
      str := GetValidStr3(str, Data, [' ', '/', #9]);
      m   := Str_ToInt(Data, -1);

      str := GetValidStrCap(str, Data, [' ', #9]);  // "  " 으로 묶인 이름 허용
      if Data <> '' then begin
        if Data[1] = '"' then
          ArrestStringEx(Data, '"', '"', Data);
      end;
      iname := Data; //아이템 이름

      str := GetValidStr3(str, Data, [' ', #9]);
      cnt := Str_ToInt(Data, 1);
      if (n > 0) and (m > 0) and (iname <> '') then begin
        if ilist = nil then
          ilist := TList.Create;
        new(pmi);
        pmi.SelPoint := n - 1;
        pmi.MaxPoint := m;
        pmi.ItemName := iname;
        pmi.Count    := cnt;
        ilist.Add(pmi);
        Inc(Result);
      end;
    end;
  end;
  strlist.Free;
end;

{$IfDEF LOADSQL}
function  TFrmDB.LoadMonsters: integer;
var
   pMonInfo : PTMonsterInfo;
   i        : Integer;
begin
  Result := 0;
  gMonsterMgr := TMonsterMgr.Create;

  if gMonsterMgr.Load( UserEngine.MonDefList , ltSQL, -1 ) then begin
    gMonsterMgr.Free;

    gMonsterItemMgr := TMonsterItemMgr.Create;

    for i := 0 to UserEngine.MonDefList.Count -1 do begin
      pMonInfo := UserEngine.MonDefList[i];
      pMonInfo^.ItemList := TList.Create;

      gMonsterItemMgr.SetCompareStr ( pMonInfo^.Name );
      gMonsterItemMgr.Load( pMonInfo^.ItemList , ltSQL, -1 );
    end;

    gMonsterItemMgr.Free;
    Result := 1;
  end else
    gMonsterMgr.Free;
end;

{$ELSE}

function TFrmDB.LoadMonsters: integer;
var
  i:  integer;
  pm: PTMonsterInfo;
begin
  Result := 0;
  with Query do begin
    SQL.Clear;
    SQL.Add('select * from Monster');
    try
      Open;
    finally
      Result := -2;
    end;

    for i := 0 to RecordCount - 1 do begin
      new(pm);
      pm.Name    := FieldByName('NAME').AsString;
      pm.Race    := FieldByName('Race').AsInteger;
      pm.RaceImg := FieldByName('RaceImg').AsInteger;
      pm.Appr    := FieldByName('Appr').AsInteger;
      pm.Level   := FieldByName('Lvl').AsInteger;
      pm.LifeAttrib := FieldByName('Undead').AsInteger;
      pm.CoolEye := FieldByName('CoolEye').AsInteger;
      pm.Exp     := FieldByName('Exp').AsInteger;
      pm.HP      := FieldByName('HP').AsInteger;
      pm.MP      := FieldByName('MP').AsInteger;
      pm.AC      := FieldByName('AC').AsInteger;
      pm.MAC     := FieldByName('MAC').AsInteger;
      pm.DC      := FieldByName('DC').AsInteger;
      pm.MaxDC   := FieldByName('DCMAX').AsInteger;
      pm.MC      := FieldByName('MC').AsInteger;
      pm.SC      := FieldByName('SC').AsInteger;
      pm.Speed   := FieldByName('SPEED').AsInteger;
      pm.Hit     := FieldByName('HIT').AsInteger;
      pm.WalkSpeed := _MAX(200, FieldByName('WALK_SPD').AsInteger);
      pm.WalkStep := _MAX(1, FieldByName('WalkStep').AsInteger);
      pm.WalkWait := FieldByName('WalkWait').AsInteger;
      pm.AttackSpeed := FieldByName('ATTACK_SPD').AsInteger;
      if pm.WalkSpeed < 200 then
        pm.WalkSpeed := 200;
      if pm.AttackSpeed < 200 then
        pm.AttackSpeed := 200;
      // newly added by sonmg.
      pm.Tame := FieldByName('TAME').AsInteger;
      pm.AntiPush   := FieldByName('ANTIPUSH').AsInteger;
      pm.AntiUndead := FieldByName('ANTIUNDEAD').AsInteger;
      pm.SizeRate   := FieldByName('SIZERATE').AsInteger;
      pm.AntiStop   := FieldByName('ANTISTOP').AsInteger;

      pm.Itemlist := nil;
      LoadMonItems(pm.Name, pm.Itemlist);
      UserEngine.MonDefList.Add(pm);
      Result := 1;

      Next;
    end;
    Close;
  end;
end;

{$ENDIF}

{$IfDEF LOADSQL}
function  TFrmDB.LoadMagic: integer;
begin
   Result := 0;
   gMagicMgr := TMagicMgr.Create;

   if gMagicMgr.Load( UserEngine.DefMagicList , ltSQL , 1 ) then
       Result := 1;

   gMagicMgr.Free;
end;
{$ELSE}

function TFrmDB.LoadMagic: integer;
var
  i:  integer;
  pm: PTDefMagic;
begin
  Result := 0;
  with Query do begin
    SQL.Clear;
    SQL.Add('select * from Magic');
    try
      Open;
    finally
      Result := -2;
    end;

    for i := 0 to RecordCount - 1 do begin
      new(pm);
      pm.MagicId  := FieldByName('MagId').AsInteger;
      pm.MagicName := FieldByName('MagName').AsString;
      pm.EffectType := FieldByName('EffectType').AsInteger;
      pm.Effect   := FieldByName('Effect').AsInteger;
      pm.Spell    := FieldByName('Spell').AsInteger;
      pm.MinPower := FieldByName('Power').AsInteger;
      pm.MaxPower := FieldByName('MaxPower').AsInteger;
      pm.Job      := FieldByName('Job').AsInteger;
      pm.NeedLevel[0] := FieldByName('NeedL1').AsInteger;
      pm.NeedLevel[1] := FieldByName('NeedL2').AsInteger;
      pm.NeedLevel[2] := FieldByName('NeedL3').AsInteger;
      pm.NeedLevel[3] := FieldByName('NeedL3').AsInteger;
      pm.MaxTrain[0] := FieldByName('L1Train').AsInteger;
      pm.MaxTrain[1] := FieldByName('L2Train').AsInteger;
      pm.MaxTrain[2] := FieldByName('L3Train').AsInteger;
      pm.MaxTrain[3] := pm.MaxTrain[2];//FieldByName('L2Train').AsInteger;
      pm.MaxTrainLevel := 3; ///FieldByName('TrainLevel').AsInteger;
      pm.DelayTime := FieldByName('Delay').AsInteger * 10;
      pm.DefSpell := FieldByName('DefSpell').AsInteger;
      pm.DefMinPower := FieldByName('DefPower').AsInteger;
      pm.DefMaxPower := FieldByName('DefMaxPower').AsInteger;
      pm.Desc     := FieldByName('Descr').AsString;

      UserEngine.DefMagicList.Add(pm);
      Result := 1;

      Next;
    end;
    Close;
  end;
end;

{$ENDIF}

function TFrmDB.LoadZenLists: integer;
var
  i: integer;
  str, Data, flname: string;
  pz:      PTZenInfo;
  strlist: TStringList;
  ztime:   integer;
begin
  Result := -1;
  flname := EnvirDir + ZENFILE;
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := strlist[i];
      if str = '' then
        continue;
      if str[1] = ';' then
        continue;
      new(pz);
      str  := GetValidStr3(str, Data, [' ', #9]);
      pz.MapName := UpperCase(Data);
      str  := GetValidStr3(str, Data, [' ', #9]);
      pz.X := Str_ToInt(Data, 0);
      str  := GetValidStr3(str, Data, [' ', #9]);
      pz.Y := Str_ToInt(Data, 0);

      str := GetValidStrCap(str, Data, [' ', #9]);
      if Data <> '' then begin
        if Data[1] = '"' then
          ArrestStringEx(Data, '"', '"', Data);
      end;
      pz.MonName := Data;

      str      := GetValidStr3(str, Data, [' ', #9]);
      pz.Area  := Str_ToInt(Data, 0);
      str      := GetValidStr3(str, Data, [' ', #9]);
      pz.Count := Str_ToInt(Data, 0);
      str      := GetValidStr3(str, Data, [' ', #9]);
      //몬스터 젠시간 랜덤 적용
      ztime    := -1;
      if Data <> '' then begin
        ztime := Str_ToInt(Data, -1);
      end;
      pz.MonZenTime := longword(ztime * 60 * 1000);
      str := GetValidStr3(str, Data, [' ', #9]);
      pz.SmallZenRate := Str_ToInt(Data, 0);

      // 2003/06/20 이벤트용 몹 처리
      str   := GetValidStr3(str, Data, [' ', #9]);
      pz.TX := Str_ToInt(Data, 0);
      str   := GetValidStr3(str, Data, [' ', #9]);
      pz.TY := Str_ToInt(Data, 0);
      str   := GetValidStr3(str, Data, [' ', #9]);
      pz.ZenShoutType := Str_ToInt(Data, 0);
      str   := GetValidStr3(str, Data, [' ', #9]);
      pz.ZenShoutMsg := Str_ToInt(Data, 0);

      if (pz.MapName <> '') and (pz.MonName <> '') and (pz.MonZenTime <> 0) then begin
        if GrobalEnvir.ServerGetEnvir(ServerIndex, pz.MapName) <> nil then begin
          pz.StartTime := 0;
          pz.Mons      := TList.Create;

          UserEngine.MonList.Add(pz);
        end else
          Dispose(pz);
      end else
        Dispose(pz);
    end;
    new(pz);
    pz.MapName := '';
    pz.MonName := '';
    pz.Mons    := TList.Create;
    UserEngine.MonList.Add(pz); //마지막은 운영자가 만드는 몬스터...
    strlist.Free;
    Result := 1;
  end;
end;

// 2003/06/20 이벤트 몹용
function TFrmDB.LoadGenMsgLists: integer;
var
  i: integer;
  str, flname: string;
  strlist: TStringList;
begin
  Result := -1;
  flname := EnvirDir + ZENMSGFILE;
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := strlist[i];
      if str = '' then
        continue;
      if str[1] = ';' then
        continue;
      UserEngine.GenMsgList.Add(str);
    end;
    strlist.Free;
    Result := 1;
  end;
end;

{
   2003/01/14 Mine2 추가
}
function TFrmDB.LoadMapFiles: integer;

  function GetMapNpc(mqfile: string): TNormNpc;
  var
    npc: TMerchant;
  begin
    npc    := TMerchant.Create;
    npc.MapName := '0';
    npc.CX := 0;
    npc.CY := 0;
    npc.UserName := mqfile;
    npc.NpcFace := 0;
    npc.Appearance := 0;
    npc.DefineDirectory := MAPQUESTDIR;
    npc.BoInvisible := True;
    npc.BoUseMapFileName := False;

    UserEngine.NpcList.Add(npc);

    Result := npc;
  end;

var
  i, j, xx, yy, ex, ey, svindex: integer;

  str, Data, tmp, flname, map, entermap, maptitle, servernum: string;

  strlist: TStringList;
  npc:     TNormNpc;
  frmcap:  string;
  TempEnvir: TEnvirnoment;

  FirstGuildAgit, LastGuildAgit: integer;
  boGuildAgitGate: boolean;
  PFlag: PTMapFlag;
begin
  frmcap := FrmMain.Caption;
  FirstGuildAgit := -1;
  LastGuildAgit := -1;

  Result := -1;
  flname := EnvirDir + MAPDEFFILE;
  if not FileExists(flname) then
    exit;
  strlist := TStringList.Create;
  strlist.LoadFromFile(flname);
  if strlist.Count < 1 then begin
    strlist.Free;
    exit;
  end;
  Result := 1;
  //맵을 먼저 추가함
  for i := 0 to strlist.Count - 1 do begin
    str := strlist[i];
    if str <> '' then begin
      if str[1] = '[' then begin
        map := '';

        //맵을 추가
        str := ArrestStringEx(str, '[', ']', map);

        maptitle := GetValidStrCap(map, map, [' ', ',', #9]);
        if maptitle <> '' then begin
          if maptitle[1] = '"' then
            ArrestStringEx(maptitle, '"', '"', maptitle);
        end;

        servernum := Trim(GetValidStr3(maptitle, maptitle, [' ', ',', #9]));
        svindex   := Str_ToInt(servernum, 0);
        if map <> '' then begin
          New (PFlag);
          PFlag.LawFull       := False;  //TRUE: 치안이 확실하여 살인하면 바로 수배됨
          PFlag.FightZone     := False;  //TRUE: 대련장
          PFlag.Fight2Zone    := False;  //대련사냥터
          PFlag.Fight3Zone    := False;
          PFlag.Fight4Zone    := False;
          PFlag.Darkness      := False;
          PFlag.Dawn          := False; //새벽추가
          PFlag.DayLight      := False;
          PFlag.QuizZone      := False;
          PFlag.NoReconnect   := False;
          PFlag.BackMap       := '';
          PFlag.NeedLevel     := 1;
          PFlag.NeedHole      := False;
          PFlag.NoRecall      := False;
          PFlag.NoRandomMove  := False;
          PFlag.NoEscapeMove  := False;     //sonmg
          PFlag.NoTeleportMove:= False;   //sonmg
          PFlag.NoDrug        := False;
          PFlag.MineMap       := 0;
          PFlag.NoPositionMove:= False;
          npc                 := nil;
          PFlag.NeedSetNumber := -1;
          PFlag.NeedSetValue  := -1;
          PFlag.AutoAttack    := -1;
          PFlag.GuildAgit     := -1;
          PFlag.NoChat        := False;
          PFlag.NoGroup       := False;
          PFlag.NoThrowItem   := False;
          PFlag.NoDropItem    := False;

          while True do begin
            if str = '' then
              break;
            str := GetValidStr3(str, Data, [' ', ',', #9]);
            if Data <> '' then begin
              if CompareText(Data, 'SAFE') = 0 then begin
                PFlag.LawFull := True;
                Continue;
              end;
              if CompareText(Data, 'DARK') = 0 then begin
                PFlag.Darkness := True;
                Continue;
              end;
              if CompareText(Data, 'DAWN') = 0 then begin
                PFlag.Dawn := True;   //새벽추가
                Continue;
              end;
              if CompareText(Data, 'FIGHT') = 0 then begin
                PFlag.FightZone := True;
                Continue;
              end;
              if CompareText(Data, 'FIGHT2') = 0 then begin
                PFlag.Fight2Zone := True;
                Continue;
              end;
              if CompareText(Data, 'FIGHT3') = 0 then begin
                PFlag.Fight3Zone := True;
                Continue;
              end;
              if CompareText(Data, 'FIGHT4') = 0 then begin
                PFlag.Fight4Zone := True;
                Continue;
              end;
              if CompareText(Data, 'DAY') = 0 then begin
                PFlag.DayLight := True;
                Continue;
              end;
              if CompareText(Data, 'QUIZ') = 0 then begin
                PFlag.QuizZone := True;
                Continue;
              end;
              if CompareLStr(Data, 'NORECONNECT', Length('NORECONNECT')) then begin
                PFlag.NoReconnect := True;
                ArrestStringEx(Data, '(', ')', PFlag.BackMap);
                if PFlag.BackMap = '' then Result := -11;
                Continue;
              end;
              if CompareLStr(Data, 'CHECKQUEST', Length('CHECKQUEST')) then begin  //한 개 조건만
                ArrestStringEx(Data, '(', ')', tmp);
                npc := GetMapNpc(tmp);
                Continue;
              end;
              if CompareLStr(Data, 'NEEDSET_ON', Length('NEEDSET_ON')) then begin
                PFlag.NeedSetValue := 1;
                ArrestStringEx(Data, '(', ')', tmp);
                PFlag.NeedSetNumber := Str_ToInt(tmp, -1);
                Continue;
              end;
              if CompareLStr(Data, 'NEEDSET_OFF', Length('NEEDSET_OFF')) then begin
                PFlag.NeedSetValue := 0;
                ArrestStringEx(Data, '(', ')', tmp);
                PFlag.NeedSetNumber := Str_ToInt(tmp, -1);
                Continue;
              end;
              if CompareLStr(Data, 'NEEDLEVEL', Length('NEEDLEVEL')) then begin
                PFlag.NeedLevel := 1;
                ArrestStringEx(Data, '(', ')', tmp);
                PFlag.NeedLevel := Str_ToInt(tmp, -1);
                Continue;
              end;
              if CompareText(Data, 'NEEDHOLE') = 0 then begin
                PFlag.NeedHole := True;
                Continue;
              end;
              if CompareText(Data, 'NORECALL') = 0 then begin
                PFlag.NoRecall := True;
                Continue;
              end;
              if CompareText(Data, 'NORANDOMMOVE') = 0 then begin
                PFlag.NoRandomMove := True;
                Continue;
              end;
              if CompareText(Data, 'NOESCAPEMOVE') = 0 then begin
                PFlag.NoEscapeMove := True;  //sonmg
                Continue;
              end;
              if CompareText(Data, 'NOTELEPORTMOVE') = 0 then begin
                PFlag.NoTeleportMove := True; //sonmg
                Continue;
              end;
              if CompareText(Data, 'NODRUG') = 0 then begin
                PFlag.NoDrug := True;
                Continue;
              end;
              if CompareText(Data, 'MINE') = 0 then begin
                PFlag.MineMap := 1;
                Continue;
              end;
              if CompareText(Data, 'MINE2') = 0 then begin
                PFlag.MineMap := 2;
                Continue;
              end;
              if CompareText(Data, 'MINE3') = 0 then begin
                PFlag.MineMap := 3;
                Continue;
              end;
              if CompareText(Data, 'NOPOSITIONMOVE') = 0 then begin
                PFlag.NoPositionMove := True;
                Continue;
              end;
              if CompareText(Data, 'THUNDER') = 0 then begin
                PFlag.AutoAttack := 1;
                Continue;
              end;
              if CompareText(Data, 'FIRE') = 0 then begin
                PFlag.AutoAttack := 2;
                Continue;
              end;
              if CompareText(Data, 'NOMAPXY') = 0 then begin
                PFlag.AutoAttack := 3;  //(sonmg 2005/03/14)
                Continue;
              end;
              // 문파장원(sonmg)
              if CompareLStr(Data, 'GUILDAGIT', Length('GUILDAGIT')) then begin
                ArrestStringEx(Data, '(', ')', tmp);
                PFlag.GuildAgit := Str_ToInt(tmp, -1);

                // 처음 장원 번호
                if FirstGuildAgit < 0 then
                  FirstGuildAgit := PFlag.GuildAgit
                else if FirstGuildAgit > PFlag.GuildAgit then
                  FirstGuildAgit := PFlag.GuildAgit;

                // 마지막 장원 번호
                if LastGuildAgit < 0 then
                  LastGuildAgit := PFlag.GuildAgit
                else if LastGuildAgit < PFlag.GuildAgit then
                  LastGuildAgit := PFlag.GuildAgit;

                GuildAgitStartNumber := FirstGuildAgit;
                GuildAgitMaxNumber   := LastGuildAgit;
                Continue;
              end;
              //sonmg 2004/10/12
              if CompareText(Data, 'NOCHAT') = 0 then begin
                PFlag.NoChat := True;
                Continue;
              end;
              if CompareText(Data, 'NOGROUP') = 0 then begin
                PFlag.NoGroup := True;
                Continue;
              end;
              //sonmg 2005/03/14
              if CompareText(Data, 'NOTHROWITEM') = 0 then begin
                PFlag.NoThrowItem := True;
                Continue;
              end;
              if CompareText(Data, 'NODROPITEM') = 0 then begin
                PFlag.NoDropItem := True;
                Continue;
              end;
            end else
              break;
          end;

          // 문파 장원(sonmg)
          if PFlag.GuildAgit > -1 then begin
            TempEnvir := GrobalEnvir.AddEnvir(UpperCase(map + IntToStr(PFlag.GuildAgit)),
              maptitle + IntToStr(PFlag.GuildAgit), svindex, npc, PFlag);

            if TempEnvir = nil then begin // 잘못 만들어졋음
              Result := -10;
            end else begin // 잘 만들어졌음
              // 용시스템에 자동공격설정을 함.
              case TempEnvir.AutoAttack of
                1, 2: gFireDragon.SetAutoAttackMap(
                    TempEnvir, TempEnvir.AutoAttack);
              end;
            end;
          end else begin
            TempEnvir := GrobalEnvir.AddEnvir(UpperCase(map), maptitle,
              svindex, npc, PFlag);

            if TempEnvir = nil then begin // 잘못 만들어졋음
              Result := -10;
            end else begin // 잘 만들어졌음
              // 용시스템에 자동공격설정을 함.
              case TempEnvir.AutoAttack of
                1, 2: gFireDragon.SetAutoAttackMap(
                    TempEnvir, TempEnvir.AutoAttack);
              end;
            end;
          end;
          Dispose(PFlag);
        end;

        FrmMain.Caption :=
          'Map loading.. ' + IntToStr(i + 1) + '/' + IntToStr(strlist.Count);
        FrmMain.RefreshForm;
      end;
    end;
  end;

  FrmMain.Caption := frmcap;

  //입구를 추가함
  for i := 0 to strlist.Count - 1 do begin
    boGuildAgitGate := False;      //줄마다 초기화

    str := strlist[i];
    if str <> '' then begin
      if (str[1] = '[') or (str[1] = ';') then
        continue;
      str := GetValidStr3(str, Data, [' ', ',', #9]);
      // 문파 장원 맵 게이트이면 Flag를 체크하고 한 단어 더 읽는다.
      if CompareStr(Data, 'GUILDAGIT') = 0 then begin
        boGuildAgitGate := True;
        str := GetValidStr3(str, Data, [' ', ',', #9]);
      end;
      map := Data;
      str := GetValidStr3(str, Data, [' ', ',', #9]);
      xx  := Str_ToInt(Data, 0);
      str := GetValidStr3(str, Data, [' ', ',', #9]);
      yy  := Str_ToInt(Data, 0);
      str := GetValidStr3(str, Data, [' ', ',', '-', '>', #9]);
      entermap := Data;
      str := GetValidStr3(str, Data, [' ', ',', #9]);
      ex  := Str_ToInt(Data, 0);
      str := GetValidStr3(str, Data, [' ', ',', ';', #9]);
      ey  := Str_ToInt(Data, 0);

      if boGuildAgitGate then begin
        for j := FirstGuildAgit to LastGuildAgit do begin
          if (False = GrobalEnvir.AddGate(UpperCase(map + IntToStr(j)),
            xx, yy, entermap + IntToStr(j), ex, ey)) then begin
            MainOutMessage('NOT ADD GATE :[' + IntToStr(i + 1) + ']' + strlist[i]);
          end;
        end;
      end else begin
        if (False = GrobalEnvir.AddGate(UpperCase(map), xx, yy,
          entermap, ex, ey))
        then begin
          MainOutMessage('NOT ADD GATE :[' + IntToStr(i + 1) + ']' + strlist[i]);
        end;
      end;
    end;
  end;
  strlist.Free;
end;

function TFrmDB.LoadAdminFiles: integer;
var
  i: integer;
  str, temp, flname: string;
  strlist: TStringList;
begin
  Result := 0;
  flname := EnvirDir + ADMINDEFFILE;
  UserEngine.AdminList.Clear;
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := strlist[i];
      if str <> '' then begin
        if str[1] <> ';' then begin
          if str[1] = '*' then begin //admin
            str := GetValidStrCap(str, temp, [' ', #9]);
            UserEngine.AdminList.AddObject(Trim(str), TObject(UD_ADMIN));
          end else begin
            if str[1] = '1' then begin //sysop
              str := GetValidStrCap(str, temp, [' ', #9]);
              UserEngine.AdminList.AddObject(Trim(str), TObject(UD_SYSOP));
            end else if str[1] = '2' then begin //observer
              str := GetValidStrCap(str, temp, [' ', #9]);
              UserEngine.AdminList.AddObject(Trim(str), TObject(UD_OBSERVER));
            end;
          end;
        end;
      end;
    end;
    strlist.Free;
    Result := 1;
  end;
end;

// 2003/08/28 채팅로그
function TFrmDB.LoadChatLogFiles: integer;
var
  i: integer;
  str, temp, flname: string;
  strlist: TStringList;
begin
  flname := EnvirDir + CHATLOGFILE;
  UserEngine.ChatLogList.Clear;
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := strlist[i];
      if str <> '' then begin
        if str[1] <> ';' then begin
          // str := GetValidStrCap (str, temp, [' ', #9]);
          str := strlist[i];
          UserEngine.ChatLogList.Add(Trim(str));
        end;
      end;
    end;
    strlist.Free;
  end;
  Result := 1;
end;

// 2003/09/15 채팅 로그 추가
function TFrmDB.SaveChatLogFiles: integer;
var
  flname: string;
begin
  flname := EnvirDir + CHATLOGFILE;
  UserEngine.ChatLogList.SaveToFile(flname);
  Result := 1;
end;

function TFrmDB.LoadMerchants: integer;
var
  i: integer;
  str, flname, marketname, map, xstr, ystr, seller, facestr, apprstr, castlestr: string;
  strlist: TStringList;
  merchant: TMerchant;
begin
  flname := EnvirDir + MERCHANTFILE;
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str = '' then
        continue;
      if str[1] = ';' then
        continue;
      str := GetValidStr3(str, marketname, [' ', #9]);
      str := GetValidStr3(str, map, [' ', #9]);
      str := GetValidStr3(str, xstr, [' ', #9]);
      str := GetValidStr3(str, ystr, [' ', #9]);

      str := GetValidStrCap(str, seller, [' ', #9]);
      if seller <> '' then begin
        if seller[1] = '"' then
          ArrestStringEx(seller, '"', '"', seller);
      end;

      str := GetValidStr3(str, facestr, [' ', #9]);
      str := GetValidStr3(str, apprstr, [' ', #9]);
      str := GetValidStr3(str, castlestr, [' ', #9]);
      if (marketname <> '') and (map <> '') and (apprstr <> '') then begin
        merchant    := TMerchant.Create;
        merchant.MarketName := marketname;
        merchant.MapName := UpperCase(map);
        merchant.CX := Str_ToInt(xstr, 0);
        merchant.CY := Str_ToInt(ystr, 0);
        merchant.UserName := seller;
        merchant.NpcFace := Str_ToInt(facestr, 0);
        merchant.Appearance := Str_ToInt(apprstr, 0);
        if Str_ToInt(castlestr, 0) <> 0 then
          merchant.BoCastleManage := True;
        //merchant.StorageItem := Str_ToInt (flagstr, 0);
        //merchant.RepairItem := Str_ToInt (repaire, 0);

        UserEngine.MerchantList.Add(merchant); //나중에 초기화 함
      end;
    end;
    strlist.Free;
  end;
  Result := 1;
end;

function TFrmDB.ReloadMerchants: integer;
var
  i, k, xx, yy: integer;
  str, flname, marketname, map, xstr, ystr, seller, facestr, apprstr, castlestr: string;
  strlist: TStringList;
  merchant: TMerchant;
  newone: boolean;
begin
  flname := EnvirDir + MERCHANTFILE;
  if FileExists(flname) then begin

    //기존에 있는 npc의 npcface를 모두 255로 변경한 후
    //업데이트를 시키고
    //255로 남아 있는 것은 삭제된 것으로 간주
    for i := 0 to UserEngine.MerchantList.Count - 1 do begin
      merchant := TMerchant(UserEngine.MerchantList[i]);
      merchant.NpcFace := 255;
    end;

    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str = '' then
        continue;
      if str[1] = ';' then
        continue;
      str := GetValidStr3(str, marketname, [' ', #9]);
      str := GetValidStr3(str, map, [' ', #9]);
      str := GetValidStr3(str, xstr, [' ', #9]);
      str := GetValidStr3(str, ystr, [' ', #9]);

      str := GetValidStrCap(str, seller, [' ', #9]);
      if seller <> '' then begin
        if seller[1] = '"' then
          ArrestStringEx(seller, '"', '"', seller);
      end;

      str := GetValidStr3(str, facestr, [' ', #9]);
      str := GetValidStr3(str, apprstr, [' ', #9]);
      str := GetValidStr3(str, castlestr, [' ', #9]);

      if (marketname <> '') and (map <> '') and (apprstr <> '') then begin
        xx  := Str_ToInt(xstr, 0);
        yy  := Str_ToInt(ystr, 0);
        map := UpperCase(map);

        newone := True;
        for k := 0 to UserEngine.MerchantList.Count - 1 do begin
          merchant := TMerchant(UserEngine.MerchantList[k]);
          if (map = merchant.MapName) and (xx = merchant.CX) and
            (yy = merchant.CY) then begin
            newone := False;
            merchant.MarketName := marketname;
            merchant.UserName := seller;
            merchant.NpcFace := Str_ToInt(facestr, 0);
            merchant.Appearance := Str_ToInt(apprstr, 0);
            if Str_ToInt(castlestr, 0) <> 0 then
              merchant.BoCastleManage := True;
            break;
          end;
        end;

        if newone then begin
          merchant := TMerchant.Create;
          merchant.MapName := map;
          merchant.Penvir := GrobalEnvir.GetEnvir(merchant.MapName);
          if merchant.Penvir <> nil then begin
            merchant.MarketName := marketname;
            merchant.CX      := xx;
            merchant.CY      := yy;
            merchant.UserName := seller;
            merchant.NpcFace := Str_ToInt(facestr, 0);
            merchant.Appearance := Str_ToInt(apprstr, 0);
            if Str_ToInt(castlestr, 0) <> 0 then
              merchant.BoCastleManage := True;

            UserEngine.MerchantList.Add(merchant); //나중에 초기화 함
            merchant.Initialize;
          end else
            merchant.Free;
        end;
      end;
    end;

    //기존에 있는 npc의 npcface를 모두 255로 변경한 후
    //업데이트를 시키고
    //255로 남아 있는 것은 삭제된 것으로 간주
    for i := UserEngine.MerchantList.Count - 1 downto 0 do begin
      merchant := TMerchant(UserEngine.MerchantList[i]);
      if merchant.NpcFace = 255 then begin
        //npc.Free; free는 시키지 않는다. 메모리에 쌓이게 됨, reloadnpc는 자주 사용 안하는 것이 좋다.
        //여기서 free하게 되면 서버다운의 원인이 생길 수 있음
        //유저에게 npc의 pointer가 전달 되므로,
        //안전하게 처리 되어 있긴 하지만, 그래도 free안하는게 상책
        merchant.BoGhost := True;
        UserEngine.MerchantList.Delete(i);
      end;
    end;

    strlist.Free;
  end;
  Result := 1;
end;

function TFrmDB.LoadNpcs: integer;
var
  strlist: TStringList;
  i, race: integer;
  str, flname, nname, racestr, map, xstr, ystr, facestr, body: string;
  npc:     TNormNpc;
begin
  Result := -1;
  flname := EnvirDir + NPCLISTFILE;
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str = '' then
        continue;
      if str[1] = ';' then
        continue;

      str := GetValidStrCap(str, nname, [' ', #9]);
      if nname <> '' then begin
        if nname[1] = '"' then
          ArrestStringEx(nname, '"', '"', nname);
      end;

      str := GetValidStr3(str, racestr, [' ', #9]);
      str := GetValidStr3(str, map, [' ', #9]);
      str := GetValidStr3(str, xstr, [' ', #9]);
      str := GetValidStr3(str, ystr, [' ', #9]);
      str := GetValidStr3(str, facestr, [' ', #9]);
      str := GetValidStr3(str, body, [' ', #9]);
      if (nname <> '') and (map <> '') and (body <> '') then begin
        race := Str_ToInt(racestr, 0);
        npc  := nil;
        case race of
          0: npc := TMerchant.Create;
          1: npc := TGuildOfficial.Create;
          2: npc := TCastleManager.Create;
          3: npc := THiddenNpc.Create;
        end;
        if npc <> nil then begin
          npc.MapName := UpperCase(map);
          npc.CX      := Str_ToInt(xstr, 0);
          npc.CY      := Str_ToInt(ystr, 0);
          npc.UserName := nname;
          npc.NpcFace := Str_ToInt(facestr, 0);
          npc.Appearance := Str_ToInt(body, 0);

          UserEngine.NpcList.Add(npc);
        end;
      end;
    end;
    strlist.Free;

    Result := 1;
  end;
end;

 //mapname, x, y에 의해서 판가름
 //이미 존재하는 npc인 경우에는 업데이트
 //이미 존재하지만 빠진 npc는 제거
 //새로 추가된 npc는 추가
function TFrmDB.ReloadNpcs: integer;
var
  strlist: TStringList;
  i, k, race, xx, yy: integer;
  str, flname, nname, racestr, map, xstr, ystr, facestr, body: string;
  npc:     TNormNpc;
  newone:  boolean;
begin
  Result := -1;
  flname := EnvirDir + NPCLISTFILE;
  if FileExists(flname) then begin
    //기존에 있는 npc의 npcface를 모두 255로 변경한 후
    //업데이트를 시키고
    //255로 남아 있는 것은 삭제된 것으로 간주
    for i := 0 to UserEngine.NpcList.Count - 1 do begin
      npc := TNormNpc(UserEngine.NpcList[i]);
      npc.NpcFace := 255;
    end;

    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str = '' then
        continue;
      if str[1] = ';' then
        continue;

      str := GetValidStrCap(str, nname, [' ', #9]);
      if nname <> '' then begin
        if nname[1] = '"' then
          ArrestStringEx(nname, '"', '"', nname);
      end;

      str := GetValidStr3(str, racestr, [' ', #9]);
      str := GetValidStr3(str, map, [' ', #9]);
      str := GetValidStr3(str, xstr, [' ', #9]);
      str := GetValidStr3(str, ystr, [' ', #9]);
      str := GetValidStr3(str, facestr, [' ', #9]);
      str := GetValidStr3(str, body, [' ', #9]);
      if (nname <> '') and (map <> '') and (body <> '') then begin
        xx  := Str_ToInt(xstr, 0);
        yy  := Str_ToInt(ystr, 0);
        map := UpperCase(map);

        newone := True;
        for k := 0 to UserEngine.NpcList.Count - 1 do begin
          npc := TNormNpc(UserEngine.NpcList[k]);
          if (map = npc.MapName) and (xx = npc.CX) and (yy = npc.CY) then begin
            newone      := False;
            npc.UserName := nname;
            npc.NpcFace := Str_ToInt(facestr, 0);
            npc.Appearance := Str_ToInt(body, 0);
            break;
          end;
        end;

        if newone then begin
          race := Str_ToInt(racestr, 0);
          npc  := nil;
          case race of
            0: npc := TMerchant.Create;
            1: npc := TGuildOfficial.Create;
            2: npc := TCastleManager.Create;
            3: npc := THiddenNpc.Create;
          end;
          if npc <> nil then begin
            npc.MapName := map;
            npc.Penvir  := GrobalEnvir.GetEnvir(npc.MapName);
            if npc.Penvir <> nil then begin
              npc.CX      := xx; //Str_ToInt (xstr, 0);
              npc.CY      := yy; //Str_ToInt (ystr, 0);
              npc.UserName := nname;
              npc.NpcFace := Str_ToInt(facestr, 0);
              npc.Appearance := Str_ToInt(body, 0);

              UserEngine.NpcList.Add(npc);
              npc.Initialize;
            end else
              npc.Free;
          end;
        end;
      end;
    end;
    strlist.Free;

    //기존에 있는 npc의 npcface를 모두 255로 변경한 후
    //업데이트를 시키고
    //255로 남아 있는 것은 삭제된 것으로 간주
    for i := UserEngine.NpcList.Count - 1 downto 0 do begin
      npc := TNormNpc(UserEngine.NpcList[i]);
      if npc.NpcFace = 255 then begin
        //npc.Free; free는 시키지 않는다. 메모리에 쌓이게 됨, reloadnpc는 자주 사용 안하는 것이 좋다.
        //여기서 free하게 되면 서버다운의 원인이 생길 수 있음
        //유저에게 npc의 pointer가 전달 되므로,
        //안전하게 처리 되어 있긴 하지만, 그래도 free안하는게 상책
        npc.BoGhost := True;
        UserEngine.NpcList.Delete(i);
      end;
    end;
    Result := 1;
  end;
end;




function TFrmDB.LoadGuards: integer;
var
  strlist: TStringList;
  i:    integer;
  str, flname, mname, map, xstr, ystr, dirstr: string;
  cret: TCreature;
begin
  Result := -1;
  flname := EnvirDir + GUARDLISTFILE;
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := strlist[i];
      if str = '' then
        continue;
      if str[1] = ';' then
        continue;

      str := GetValidStrCap(str, mname, [' ']);
      if mname <> '' then begin
        if mname[1] = '"' then
          ArrestStringEx(mname, '"', '"', mname);
      end;

      str := GetValidStr3(str, map, [' ']);
      str := GetValidStr3(str, xstr, [' ', ',']);
      str := GetValidStr3(str, ystr, [' ', ',', ':']);
      str := GetValidStr3(str, dirstr, [' ', ':']);
      if (mname <> '') and (map <> '') and (dirstr <> '') then begin
        cret := UserEngine.AddCreatureSysop(map, Str_ToInt(xstr, 0),
          Str_ToInt(ystr, 0), mname);
        if cret <> nil then
          cret.Dir := Str_ToInt(dirstr, 0);
      end;
    end;
    strlist.Free;
    Result := 1;
  end;
end;

function TFrmDB.LoadMakeItemList: integer;
var
  strlist:  TStringList;
  i, Count: integer;
  str, flname, itemname, makeitemname: string;
  slist:    TStringList;
begin
  Result := -1;
  flname := EnvirDir + MAKEITEMFILE;
  for i := 0 to MakeItemList.Count - 1 do
    TStringList(MakeItemList[i]).Free;
  MakeItemList.Clear;   // 12/12/2008 add reload ability and fix memory leak
  MakeItemIndexList.Clear;

  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    slist := nil;
    makeitemname := '';
    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str <> '' then begin
        if str[1] = ';' then
          continue;
        if str[1] = '[' then begin
          if slist <> nil then
            MakeItemList.AddObject(makeitemname, TObject(slist));
          slist := TStringList.Create;
          ArrestStringEx(str, '[', ']', makeitemname);
        end else if str[1] = '-' then begin // 구분자.
          MakeItemIndexList.AddObject(IntToStr(MakeItemList.Count), nil);
        end else begin
          if slist <> nil then begin
            str := GetValidStr3(str, itemname, [' ', #9]);
            if length(itemname) > 20 then        //item name length
              MainOutMessage('MAKEITEMLIST NAME > 20' + itemname);
            Count := Str_ToInt(Trim(str), 1);
            slist.AddObject(itemname, TObject(Count));
          end;
        end;
      end;
    end;
    if slist <> nil then begin
      MakeItemList.AddObject(makeitemname, TObject(slist));
    end;
    strlist.Free;
    Result := 1;
  end;
end;

function TFrmDB.LoadStartPoints: integer;
var
  i: integer;
  str, flname, smap, xstr, ystr, scopestr: string;
  strlist: TStringList;
  mp: PTMapPoint;
begin
  Result   := 0;
  flname   := EnvirDir + STARTPOINTFILE;
  scopestr := '10'; //안전지대 기본 범위
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str <> '' then begin
        str := GetValidStr3(str, smap, [' ', #9]);
        str := GetValidStr3(str, xstr, [' ', #9]);
        str := GetValidStr3(str, ystr, [' ', #9]);
        //범위 설정
        if str <> '' then
          str := GetValidStr3(str, scopestr, [' ', #9]);
        if (smap <> '') and (xstr <> '') and (ystr <> '') and (scopestr <> '') then begin
          New (mp);
          mp.MapName := smap;
          mp.Scope   := Str_ToInt(scopestr, 10);
          mp.PointX  := Str_ToInt(xstr, 0);
          mp.PointY  := Str_ToInt(ystr, 0);
          StartPoints.Add(mp);
          Result := 1;
        end;
      end;
    end;
    strlist.Free;
  end;
end;

function TFrmDB.LoadSafePoints: integer;
var
  i: integer;
  str, flname, smap, xstr, ystr, scopestr: string;
  strlist: TStringList;
  mp: PTMapPoint;
begin
  Result   := 0;
  flname   := EnvirDir + SAFEPOINTFILE;
  scopestr := '10'; //안전지대 기본 범위
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str <> '' then begin
        str := GetValidStr3(str, smap, [' ', #9]);
        str := GetValidStr3(str, xstr, [' ', #9]);
        str := GetValidStr3(str, ystr, [' ', #9]);
        //범위 설정
        if str <> '' then
          str := GetValidStr3(str, scopestr, [' ', #9]);
        if (smap <> '') and (xstr <> '') and (ystr <> '') and (scopestr <> '') then begin
          New (mp);
          mp.MapName := smap;
          mp.Scope   := Str_ToInt(scopestr, 10);
          mp.PointX  := Str_ToInt(xstr, 0);
          mp.PointY  := Str_ToInt(ystr, 0);
          SafePoints.Add(mp);
          Result := 1;
        end;
      end;
    end;
    strlist.Free;
  end;
end;

function TFrmDB.LoadDecoItemList: integer;
var
  i: integer;
  str, flname: string;
  Num, Name, Kind, Price: string;
  strlist: TStringList;
begin
  Result := -1;
  flname := EnvirDir + DECOITEMFILE;
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str <> '' then begin
        if str[1] = ';' then
          continue;
        str := GetValidStr3(str, Num, [' ', '-', #9]);
        str := GetValidStr3(str, Name, [' ', '-', #9]);
        str := GetValidStr3(str, Kind, [' ', '-', #9]);
        str := GetValidStr3(str, Price, [' ', '-', #9]);
        if (Num <> '') and (Name <> '') and (Kind <> '') then begin
          if Price = '' then
            Price := IntToStr(DEFAULT_DECOITEM_PRICE);   //상현주머니 임시 기본 가격
          DecoItemList.AddObject(Name + '/' + Price, TObject(
            MakeLong(Str_ToInt(Num, 0), Str_ToInt(Kind, 0))));
          Result := 1;
        end;
      end;
    end;
    strlist.Free;
  end;
end;

function TFrmDB.LoadMiniMapInfos: integer;
var
  i, index: integer;
  str, flname, smap, idxstr: string;
  strlist:  TStringList;
begin
  Result := 0;
  flname := EnvirDir + MINIMAPFILE;
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := strlist[i];
      if str <> '' then begin
        if str[1] <> ';' then begin
          str   := GetValidStr3(str, smap, [' ', #9]);
          str   := GetValidStr3(str, idxstr, [' ', #9]);
          index := Str_ToInt(idxstr, 0);
          if index > 0 then begin
            MiniMapList.AddObject(smap, TObject(index));
          end;
        end;
      end;
    end;
    strlist.Free;
  end;
end;

function TFrmDB.LoadUnbindItemLists: integer;
var
  i, shape: integer;
  str, flname, shapestr, itmname: string;
  strlist:  TStringList;
begin
  Result := 0;
  flname := EnvirDir + UNBINDFILE;
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := strlist[i];
      if str <> '' then begin
        if str[1] <> ';' then begin
          str := GetValidStr3(str, shapestr, [' ', #9]);

          str := GetValidStrCap(str, itmname, [' ', #9]);
          if itmname <> '' then begin
            if itmname[1] = '"' then
              ArrestStringEx(itmname, '"', '"', itmname);
          end;

          shape := Str_ToInt(shapestr, 0);
          if shape > 0 then begin
            UnbindItemList.AddObject(itmname, TObject(shape));
          end else begin
            Result := -i;  //에러
            break;
          end;
        end;
      end;
    end;
    strlist.Free;
  end;
end;

function TFrmDB.LoadMapQuestInfos: integer;
var
  i: integer;
  str, flname, mapstr, constr1, constr2, monname, iname, qfile, gflag: string;
  str1:     string;
  set1, val1: integer;
  strlist:  TStringList;
  envir:    TEnvirnoment;
  enablegroup: boolean;
begin
  Result := 1;
  flname := EnvirDir + MAPQUESTFILE;
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := strlist[i];
      if str <> '' then begin
        if str[1] <> ';' then begin
          str := GetValidStr3(str, mapstr, [' ', #9]);
          str := GetValidStr3(str, constr1, [' ', #9]);
          str := GetValidStr3(str, constr2, [' ', #9]);

          str := GetValidStrCap(str, monname, [' ', #9]);
          if monname <> '' then begin
            if monname[1] = '"' then
              ArrestStringEx(monname, '"', '"', monname);
          end;

          str := GetValidStrCap(str, iname, [' ', #9]);
          if iname <> '' then begin
            if iname[1] = '"' then
              ArrestStringEx(iname, '"', '"', iname);
          end;

          str := GetValidStr3(str, qfile, [' ', #9]);
          str := GetValidStr3(str, gflag, [' ', #9]);
          if (mapstr <> '') and (monname <> '') and (qfile <> '') then begin
            envir := GrobalEnvir.GetEnvir(mapstr);
            if envir <> nil then begin
              ArrestStringEx(constr1, '[', ']', str1);
              set1 := Str_ToInt(str1, -1);
              val1 := Str_ToInt(constr2, 0);
              if CompareLStr(gflag, 'GROUP', 2) then
                enablegroup := True
              else
                enablegroup := False;
              if not envir.AddMapQuest(set1, val1, monname,
                iname, qfile, enablegroup) then begin
                Result := -i;  //에러
                break;
              end;
            end else begin
              Result := -i;  //에러
              break;
            end;
          end else begin
            Result := -i;  //에러
            break;
          end;
        end;
      end;
    end;
    strlist.Free;
  end;
end;

function TFrmDB.LoadStartupQuest: integer;
var
  npc: TMerchant;
begin
  Result := -1;

  if not DirectoryExists(EnvirDir + StartupDir) then
    if not CreateDir(EnvirDir + StartupDir) then exit;

  if FileExists(EnvirDir + StartupDir + STARTUPQUESTFILE + '.txt') then begin
    npc    := TMerchant.Create;
    npc.MapName := '0';
    npc.CX := 0;
    npc.CY := 0;
    npc.UserName := STARTUPQUESTFILE;  //의미 없음
    npc.NpcFace := 0;
    npc.Appearance := 0;
    npc.DefineDirectory := STARTUPDIR;
    npc.BoInvisible := True;
    npc.BoUseMapFileName := False;   //naming 방법

    UserEngine.NpcList.Add(npc);
    StartupQuestNpc := npc;
    Result := 1;
  end;
end;



procedure TFrmDB.ClearQuestDiary;
var
  n, i:      integer;
  diarylist: TList;
  pqdd:      PTQDDinfo;
begin
  //Reload인 경우, 기존에 데이타를 날린다.
  for n := 0 to QuestDiaryList.Count - 1 do begin
    diarylist := TList(QuestDiaryList[n]);
    if diarylist = nil then Continue;
    for i := 0 to diarylist.Count - 1 do begin
      pqdd := PTQDDinfo(diarylist[i]);
      pqdd.SList.Free;
      Dispose(pqdd);
    end;
    diarylist.Free;
  end;
  QuestDiaryList.Clear;
end;

//reload 가능함
function TFrmDB.LoadQuestDiary: integer;

  function XXStr(n: integer): string;
  begin
    if n >= 1000 then
      Result := IntToStr(n)
    else if n >= 100 then
      Result := '0' + IntToStr(n)
    else
      Result := '00' + IntToStr(n);
  end;

var
  n, i:      integer;
  flname, title, str, numstr: string;
  strlist:   TStringList;
  diarylist: TList;
  pqdd:      PTQDDinfo;
  bobegin:   boolean;
begin
  Result := 1;

  //Reload인 경우, 기존에 데이타를 날린다.
  ClearQuestDiary;
  bobegin := False;

  for n := 1 to MAXQUESTINDEXBYTE * 8 do begin  //가능한 번호를 모두 검색

    diarylist := nil;

    flname := EnvirDir + QUESTDIARYDIR + XXStr(n) + '.txt';
    if FileExists(flname) then begin
      title := '';
      pqdd  := nil;

      strlist := TStringList.Create;
      strlist.LoadFromFile(flname);
      for i := 0 to strlist.Count - 1 do begin
        str := strlist[i];
        if str <> '' then begin
          if str[1] <> ';' then begin
            if (str[1] = '[') and (Length(str) > 2) then begin
              if title = '' then begin
                ArrestStringEx(str, '[', ']', title);
                diarylist := TList.Create;
                new(pqdd);
                pqdd.Index := n;  //기본
                pqdd.Title := title;
                pqdd.SList := TStringList.Create;
                diarylist.Add(pqdd);
                bobegin := True;
                continue;
              end;

              if str[2] <> '@' then begin
                str := GetValidStr3(str, numstr, [' ', #9]);
                ArrestStringEx(numstr, '[', ']', numstr);
                new(pqdd);
                pqdd.Index := Str_ToInt(numstr, 0);
                pqdd.Title := str;
                pqdd.SList := TStringList.Create;
                diarylist.Add(pqdd);
                bobegin := True;
              end else begin
                bobegin := False;
              end;

            end else begin
              if bobegin then
                pqdd.SList.Add(str);

            end;
          end;
        end;
      end;
      strlist.Free;

    end;

    if diarylist <> nil then begin
      QuestDiaryList.Add(diarylist);
    end else
      QuestDiaryList.Add(nil);  //번호 순서를 맞추기 위해서

  end;

end;


{----------------------------------------------------------------}

function CutAndAddFromFile(flname, tagstr: string; list: TStringList): boolean;
var
  i:   integer;
  str: string;
  strlist: TStringList;
  bobegin: boolean;
begin
  Result := False;
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);

    tagstr  := '[' + tagstr + ']';
    bobegin := False;

    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str <> '' then begin
        if not bobegin then begin
          if str[1] = '[' then begin
            if CompareText(str, tagstr) = 0 then begin
              bobegin := True;
              list.Add(str);  //추가 시작
            end;
          end;
        end else begin
          if str[1] = '{' then
            continue;
          if str[1] = '}' then begin
            bobegin := False;
            Result  := True;
            break;  //종료
          end;
          list.Add(str);
        end;
      end;
    end;

    strlist.Free;
  end;
end;


function TFrmDB.LoadMarketDef(npc: TNormNpc; basedir, marketname: string;
  bomarket: boolean): integer;
type
  TDefineInfo = record
    defname:  string;
    defvalue: string;
  end;
  PTDefineInfo = ^TDefineInfo;
var
  i, j, k, m, n, stdmode, rate, reqidx: integer;
  flname, flname2, str, str2, Data, idxstr, valstr, itmname, scount, shour: string;
  taghomestr, src1, src2: string;
  strlist, strlist2: TStringList;
  deflist: TList;
  pp:      PTMarketProduct;
  step, questnumber: integer;
  stepstr: string;
  //says: TStringList;
  psay:    PTSayingRecord;
  psayproc: PTSayingProcedure;
  pquest:  PTQuestRecord;
  pqcon:   PTQuestConditionInfo;
  pqact:   PTQuestActionInfo;
  pdef:    PTDefineInfo;
  bobegin: boolean;

  procedure AddAvailableCommands(npcsaying: string; cmdlist: TStringList);
  var
    str, capture: string;
  begin
    str := npcsaying;
    while True do begin
      if str = '' then
        break;
      str := ArrestStringEx(str, '@', '>', capture);
      if capture <> '' then
        cmdlist.Add('@' + capture)
      else
        break;
    end;
  end;

  function NewQuest: PTQuestRecord;
  var
    pq: PTQuestRecord;
  begin
    new(pq);
    pq.BoRequire := False;  //기본설정은 퀘스트 없음
    FillChar(pq.QuestRequireArr, sizeof(TQuestRequire) * MAXREQUIRE, #0);
    reqidx := 0;
    pq.SayingList := TList.Create;

    npc.Sayings.Add(pq);
    Result := pq;
  end;

  function DecodeConditionStr(srcstr: string; pqc: PTQuestConditionInfo): boolean;
  var
    cmdstr, ParamStr, tagstr: string;
    ident: integer;
  begin
    Result := False;
    srcstr := GetValidStrCap(srcstr, cmdstr, [' ', #9]);
    srcstr := GetValidStrCap(srcstr, ParamStr, [' ', #9]);
    srcstr := GetValidStrCap(srcstr, tagstr, [' ', #9]);
    cmdstr := UpperCase(cmdstr);
    ident  := 0;

    if cmdstr = 'CHECK' then begin
      ident := QI_CHECK;
      ArrestStringEx(ParamStr, '[', ']', ParamStr);
      if not IsStringNumber(ParamStr) then
        ident := 0;
      if not IsStringNumber(tagstr) then
        ident := 0;
    end;
    if cmdstr = 'CHECKOPEN' then begin
      ident := QI_CHECKOPENUNIT;
      ArrestStringEx(ParamStr, '[', ']', ParamStr);
      if not IsStringNumber(ParamStr) then
        ident := 0;
      if not IsStringNumber(tagstr) then
        ident := 0;
    end;
    if cmdstr = 'CHECKUNIT' then begin
      ident := QI_CHECKUNIT;
      ArrestStringEx(ParamStr, '[', ']', ParamStr);
      if not IsStringNumber(ParamStr) then
        ident := 0;
      if not IsStringNumber(tagstr) then
        ident := 0;
    end;
    if cmdstr = 'RANDOM' then
      ident := QI_RANDOM;
    if cmdstr = 'GENDER' then
      ident := QI_GENDER;
    if cmdstr = 'DAYTIME' then
      ident := QI_DAYTIME;
    if cmdstr = 'CHECKLEVEL' then
      ident := QI_CHECKLEVEL;
    if cmdstr = 'CHECKJOB' then
      ident := QI_CHECKJOB;

    if cmdstr = 'CHECKITEM' then
      ident := QI_CHECKITEM;
    if cmdstr = 'CHECKITEMW' then
      ident := QI_CHECKITEMW;
    if cmdstr = 'CHECKGOLD' then
      ident := QI_CHECKGOLD;
    if cmdstr = 'ISTAKEITEM' then
      ident := QI_ISTAKEITEM;
    if cmdstr = 'CHECKDURA' then
      ident := QI_CHECKDURA;
    if cmdstr = 'CHECKDURAEVA' then
      ident := QI_CHECKDURAEVA;

    if cmdstr = 'DAYOFWEEK' then
      ident := QI_DAYOFWEEK;
    if cmdstr = 'HOUR' then
      ident := QI_TIMEHOUR;
    if cmdstr = 'MIN' then
      ident := QI_TIMEMIN;

    if cmdstr = 'CHECKPKPOINT' then
      ident := QI_CHECKPKPOINT;
    if cmdstr = 'CHECKLUCKYPOINT' then
      ident := QI_CHECKLUCKYPOINT;
    if cmdstr = 'CHECKMONMAP' then
      ident := QI_CHECKMON_MAP;
    if cmdstr = 'CHECKMONMAPNORECALL' then
      ident := QI_CHECKMON_NORECALLMOB_MAP;
    if cmdstr = 'CHECKMONAREA' then
      ident := QI_CHECKMON_AREA;
    if cmdstr = 'CHECKHUM' then
      ident := QI_CHECKHUM;
    if cmdstr = 'CHECKBAGGAGE' then
      ident := QI_CHECKBAGGAGE;
    //6-11
    if cmdstr = 'CHECKNAMELIST' then
      ident := QI_CHECKNAMELIST;
    if cmdstr = 'CHECK_DELETE_NAMELIST' then
      ident := QI_CHECKANDDELETENAMELIST;
    if cmdstr = 'CHECK_DELETE_IDLIST' then
      ident := QI_CHECKANDDELETEIDLIST;
    //*dq
    if cmdstr = 'IFGETDAILYQUEST' then
      ident := QI_IFGETDAILYQUEST;
    if cmdstr = 'RANDOMEX' then
      ident := QI_RANDOMEX;
    if cmdstr = 'CHECKDAILYQUEST' then
      ident := QI_CHECKDAILYQUEST;

    if cmdstr = 'CHECKGRADEITEM' then
      ident := QI_CHECKGRADEITEM;
    if cmdstr = 'CHECKBAGREMAIN' then
      ident := QI_CHECKBAGREMAIN;

    if cmdstr = 'EQUALVAR' then
      ident := QI_EQUALVAR;
    if cmdstr = 'EQUAL' then
      ident := QI_EQUAL;
    if cmdstr = 'LARGE' then
      ident := QI_LARGE;
    if cmdstr = 'SMALL' then
      ident := QI_SMALL;

    // sonmg(2004/08/25)
    if cmdstr = 'ISGROUPOWNER' then
      ident := QI_ISGROUPOWNER;
    if cmdstr = 'ISEXPUSER' then
      ident := QI_ISEXPUSER;
    if cmdstr = 'CHECKLOVERFLAG' then
      ident := QI_CHECKLOVERFLAG;
    if cmdstr = 'CHECKLOVERRANGE' then
      ident := QI_CHECKLOVERRANGE;
    if cmdstr = 'CHECKLOVERDAY' then
      ident := QI_CHECKLOVERDAY;
    // 장원기부금
    if cmdstr = 'CHECKDONATION' then
      ident := QI_CHECKDONATION;
    if cmdstr = 'ISGUILDMASTER' then
      ident := QI_ISGUILDMASTER;
    if cmdstr = 'CHECKWEAPONBADLUCK' then
      ident := QI_CHECKWEAPONBADLUCK;
    if cmdstr = 'CHECKPREMIUMGRADE' then
      ident := QI_CHECKPREMIUMGRADE;
    if cmdstr = 'CHECKCHILDMOB' then
      ident := QI_CHECKCHILDMOB;
    if cmdstr = 'CHECKGROUPJOBBALANCE' then
      ident := QI_CHECKGROUPJOBBALANCE;

    if ident > 0 then begin
      pqc.IfIdent := ident;
      if ParamStr <> '' then begin
        if ParamStr[1] = '"' then
          ArrestStringEx(ParamStr, '"', '"', ParamStr);
      end;
      pqc.IfParam := ParamStr;
      if tagstr <> '' then begin
        if tagstr[1] = '"' then
          ArrestStringEx(tagstr, '"', '"', tagstr);
      end;
      pqc.IfTag := tagstr;
      if IsStringNumber(ParamStr) then
        pqc.IfParamVal := Str_ToInt(ParamStr, 0);
      if IsStringNumber(tagstr) then
        pqc.IfTagVal := Str_ToInt(tagstr, 0);
      Result := True;
    end;
  end;

  function DecodeActionStr(srcstr: string; pqa: PTQuestActioninfo): boolean;
  var
    cmdstr, ParamStr, tagstr, extrastr: string;
    ident: integer;
  begin
    Result := False;
    srcstr := GetValidStrCap(srcstr, cmdstr, [' ', #9]);
    srcstr := GetValidStrCap(srcstr, ParamStr, [' ', #9]);
    srcstr := GetValidStrCap(srcstr, tagstr, [' ', #9]);
    srcstr := GetValidStrCap(srcstr, extrastr, [' ', #9]);
    cmdstr := UpperCase(cmdstr);
    ident  := 0;

    if cmdstr = 'SET' then begin
      ident := QA_SET;
      ArrestStringEx(ParamStr, '[', ']', ParamStr);
      if not IsStringNumber(ParamStr) then
        ident := 0;
      if not IsStringNumber(tagstr) then
        ident := 0;
    end;
    if cmdstr = 'RESET' then begin
      ident := QA_RESET;
      ArrestStringEx(ParamStr, '[', ']', ParamStr);
    end;
    if cmdstr = 'SETOPEN' then begin
      ident := QA_OPENUNIT;
      ArrestStringEx(ParamStr, '[', ']', ParamStr);
      if not IsStringNumber(ParamStr) then
        ident := 0;
      if not IsStringNumber(tagstr) then
        ident := 0;
    end;
    if cmdstr = 'SETUNIT' then begin
      ident := QA_SETUNIT;
      ArrestStringEx(ParamStr, '[', ']', ParamStr);
      if not IsStringNumber(ParamStr) then
        ident := 0;
      if not IsStringNumber(tagstr) then
        ident := 0;
    end;
    if cmdstr = 'RESETUNIT' then begin
      ident := QA_RESETUNIT;
      ArrestStringEx(ParamStr, '[', ']', ParamStr);
    end;
    if cmdstr = 'TAKE' then
      ident := QA_TAKE;
    if cmdstr = 'GIVE' then
      ident := QA_GIVE;
    if cmdstr = 'TAKEW' then
      ident := QA_TAKEW;
    if cmdstr = 'CLOSE' then
      ident := QA_CLOSE;
    if cmdstr = 'MAPMOVE' then
      ident := QA_MAPMOVE;
    if cmdstr = 'MAP' then
      ident := QA_MAPRANDOM;
    if cmdstr = 'BREAK' then
      ident := QA_BREAK;
    if cmdstr = 'TIMERECALL' then
      ident := QA_TIMERECALL;
    if cmdstr = 'TIMERECALLGROUP' then
      ident := QA_TIMERECALLGROUP;
    if cmdstr = 'BREAKTIMERECALL' then
      ident := QA_BREAKTIMERECALL;
    if cmdstr = 'PARAM1' then
      ident := QA_PARAM1;
    if cmdstr = 'PARAM2' then
      ident := QA_PARAM2;
    if cmdstr = 'PARAM3' then
      ident := QA_PARAM3;
    if cmdstr = 'PARAM4' then
      ident := QA_PARAM4;
    if cmdstr = 'TAKECHECKITEM' then
      ident := QA_TAKECHECKITEM;
    if cmdstr = 'MONGEN' then
      ident := QA_MONGEN;
    if cmdstr = 'MONCLEAR' then
      ident := QA_MONCLEAR;
    if cmdstr = 'MOV' then
      ident := QA_MOV;
    if cmdstr = 'INC' then
      ident := QA_INC;
    if cmdstr = 'DEC' then
      ident := QA_DEC;
    if cmdstr = 'SUM' then
      ident := QA_SUM;
    if cmdstr = 'MOVR' then
      ident := QA_MOVRANDOM;

    if cmdstr = 'EXCHANGEMAP' then
      ident := QA_EXCHANGEMAP;
    if cmdstr = 'RECALLMAP' then
      ident := QA_RECALLMAP;
    if cmdstr = 'ADDBATCH' then
      ident := QA_ADDBATCH;
    if cmdstr = 'BATCHDELAY' then
      ident := QA_BATCHDELAY;
    if cmdstr = 'BATCHMOVE' then
      ident := QA_BATCHMOVE;
    if cmdstr = 'PLAYDICE' then
      ident := QA_PLAYDICE;
    if cmdstr = 'PLAYROCK' then
      ident := QA_PLAYROCK;
    //6-11
    if cmdstr = 'ADDNAMELIST' then
      ident := QA_AddNAMELIST;
    if cmdstr = 'DELNAMELIST' then
      ident := QA_DELETENAMELIST;
    //*DQ
    if cmdstr = 'RANDOMSETDAILYQUEST' then
      ident := QA_RANDOMSETDAILYQUEST;
    if cmdstr = 'SETDAILYQUEST' then
      ident := QA_SETDAILYQUEST;

    if cmdstr = 'TAKEGRADEITEM' then
      ident := QA_TAKEGRADEITEM;

    if cmdstr = 'GOQUEST' then
      ident := QA_GOTOQUEST;
    if cmdstr = 'ENDQUEST' then
      ident := QA_ENDQUEST;
    if cmdstr = 'GOTO' then
      ident := QA_GOTO;
    if cmdstr = 'SOUND' then
      ident := QA_SOUND;
    if cmdstr = 'SOUNDALL' then
      ident := QA_SOUNDALL;
    if cmdstr = 'CHANGEGENDER' then
      ident := QA_CHANGEGENDER;
    if cmdstr = 'KICK' then
      ident := QA_KICK;
    if cmdstr = 'MOVEALLMAP' then
      ident := QA_MOVEALLMAP;
    if cmdstr = 'MOVEALLMAPGROUP' then
      ident := QA_MOVEALLMAPGROUP;
    if cmdstr = 'RECALLMAPGROUP' then
      ident := QA_RECALLMAPGROUP;
    if cmdstr = 'WEAPONUPGRADE' then
      ident := QA_WEAPONUPGRADE;
    if cmdstr = 'SETALLINMAP' then begin
      ident := QA_SETALLINMAP;
      ArrestStringEx(ParamStr, '[', ']', ParamStr);
      if not IsStringNumber(ParamStr) then
        ident := 0;
      if not IsStringNumber(tagstr) then
        ident := 0;
    end;
    if cmdstr = 'INCPKPOINT' then
      ident := QA_INCPKPOINT;
    if cmdstr = 'DECPKPOINT' then
      ident := QA_DECPKPOINT;
    if cmdstr = 'MOVETOLOVER' then
      ident := QA_MOVETOLOVER;
    if cmdstr = 'BREAKLOVER' then
      ident := QA_BREAKLOVER;
    // 장원기부금
    if cmdstr = 'DECDONATION' then
      ident := QA_DECDONATION;
    if cmdstr = 'SHOWEFFECT' then
      ident := QA_SHOWEFFECT;
    if cmdstr = 'MONGENAROUND' then
      ident := QA_MONGENAROUND;
    if cmdstr = 'RECALLMOB' then
      ident := QA_RECALLMOB;
    // 2005/12/14
    if cmdstr = 'INSTANTPOWERUP' then
      ident := QA_INSTANTPOWERUP;
    if cmdstr = 'INSTANTEXPDOUBLE' then
      ident := QA_INSTANTEXPDOUBLE;
    if cmdstr = 'HEALING' then
      ident := QA_HEALING;

    if ident > 0 then begin
      pqa.ActIdent := ident;
      if ParamStr <> '' then begin
        if ParamStr[1] = '"' then
          ArrestStringEx(ParamStr, '"', '"', ParamStr);
      end;
      pqa.ActParam := ParamStr;
      if tagstr <> '' then begin
        if tagstr[1] = '"' then
          ArrestStringEx(tagstr, '"', '"', tagstr);
      end;
      pqa.ActTag   := tagstr;
      pqa.ActExtra := extrastr;
      if IsStringNumber(ParamStr) then
        pqa.ActParamVal := Str_ToInt(ParamStr, 0);
      if IsStringNumber(tagstr) then
        pqa.ActTagVal := Str_ToInt(tagstr, 1);
      if IsStringNumber(extrastr) then
        pqa.ActExtraVal := Str_ToInt(extrastr, 1);
      Result := True;
    end;
  end;

  function ApplyCallProcedure(srclist: TStringList): integer;
  var
    i, calls: integer;
    str, str2, Data, flname2: string;
  begin
    calls := 0;
    for i := 0 to srclist.Count - 1 do begin
      str := Trim(srclist[i]);
      if str <> '' then begin
        if str[1] = '#' then begin
          if CompareLStr(str, '#CALL', 5) then begin  //#CALL [010.txt] @xxxxxxx
            str     := ArrestStringEx(str, '[', ']', Data);
            flname2 := Trim(Data);
            str2    := Trim(str);
            if CutAndAddFromFile(EnvirDir + QUESTDIARYDIR +
              flname2, str2, srclist) then begin
              srclist[i] := '#ACT';
              srclist.Insert(i + 1, 'goto ' + str2);
            end else
              MainOutMessage('script error, load fail: ' + flname2 +
                ' - ' + str2);
            Inc(calls);
          end;
        end;
      end;
    end;
    Result := calls;
  end;

  procedure AssortDefines(srclist: TStringList; rlist: TList; var homestr: string);
  var
    i:     integer;
    str, str2, Data, defname, defcontents, newflname: string;
    nlist: TStringList;
    pdef:  PTDefineInfo;
  begin
    for i := 0 to srclist.Count - 1 do begin
      str := Trim(srclist[i]);
      if str <> '' then begin
        if str[1] = '#' then begin
          if CompareLStr(str, '#SETHOME', 8) then begin
            str2    := GetValidStr3(str, Data, [' ', #9]);
            homestr := Trim(str2);
            srclist[i] := '';
          end;
          if CompareLStr(str, '#DEFINE', 7) then begin
            str := GetValidStr3(str, Data, [' ', #9]);
            str := GetValidStr3(str, defname, [' ', #9]);
            str := GetValidStr3(str, defcontents, [' ', #9]);
            //define 된 값은 숫자임

            new(pdef);
            pdef.defname  := UpperCase(defname);
            pdef.defvalue := defcontents;
            rlist.Add(pdef);

            srclist[i] := '';
          end;
          if CompareLStr(str, '#INCLUDE', 8) then begin
            str2      := GetValidStr3(str, Data, [' ', #9]);
            newflname := Trim(str2);
            newflname := EnvirDir + QUESTDEFINEDIR + newflname;
            if FileExists(newflname) then begin
              nlist := TStringList.Create;
              nlist.LoadFromFile(newflname);

              AssortDefines(nlist, rlist, homestr);
              nlist.Free;
            end else begin
              MainOutMessage('script error, load fail: ' + newflname);
            end;

            srclist[i] := '';
          end;

        end;
      end;
    end;
  end;

begin
  Result  := -1;
  step    := 0;
  questnumber := 0;
  stdmode := 0;

  //if bomarket then
  //   flname := EnvirDir + MARKETDEFDIR + marketname + '.txt'
  //else
  //   flname := EnvirDir + NPCDEFDIR + marketname + '.txt';
  flname := EnvirDir + basedir + marketname + '.txt';

  if FileExists(flname) then begin
    strlist := TStringList.Create;
    try
      strlist.LoadFromFile(flname);
    except
      strlist.Free;
      exit;
    end;

    //1단계, 준비 단계 , #CALL을 찾아서 풀어 넣는다.

    for i := 0 to 100 do
      if ApplyCallProcedure(strlist) = 0 then
        break;

    //2단계, 준비 단계,  #DEFINE, #INCLUDE 등...

    deflist := TList.Create;

    AssortDefines(strlist, deflist, taghomestr);

    new(pdef);
    pdef.defname := '@HOME';
    if taghomestr = '' then
      taghomestr := '@main';
    pdef.defvalue := taghomestr;
    deflist.Add(pdef);

    //Define 적용....
    bobegin := False;
    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str <> '' then begin
        if str[1] = '[' then begin
          bobegin := False;
          continue;
        end;
        if str[1] = '#' then begin
          if CompareLStr(str, '#IF', 3) or CompareLStr(str, '#ACT', 4) or
            CompareLStr(str, '#ELSEACT', 8) then begin
            bobegin := True;
            continue;
          end;
        end;

        if bobegin then begin
          for k := 0 to deflist.Count - 1 do begin
            pdef := PTDefineInfo(deflist[k]);

            for j := 0 to 9 do begin
              n := pos(pdef.defname, UpperCase(str));
              if n > 0 then begin
                src1 := Copy(str, 1, n - 1);
                src2 := Copy(str, n + Length(pdef.defname), 256);
                str  := src1 + pdef.defvalue + src2;
                strlist[i] := str;
              end else begin
                break;
              end;
            end;

          end;
        end;
      end;
    end;

    for i := 0 to deflist.Count - 1 do
      Dispose(PTDefineInfo(deflist[i]));
    deflist.Free;

    //3단계 내용을 읽어낸다.

    pquest   := nil;
    psay     := nil;
    psayproc := nil;
    reqidx   := 0;

    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str <> '' then begin
        if str[1] = ';' then
          continue;
        if str[1] = '/' then
          continue;

        //상점의 기본 정보,  물가 취급품 등
        if (step = 0) and (bomarket) then begin
          if str[1] = '%' then begin
            str  := Copy(str, 2, length(str) - 1);
            rate := Str_ToInt(str, -1);
            if rate >= 55 then ///55% 이상이어야 함.
              TMerchant(npc).PriceRate := rate;
            continue;
          end;
          if str[1] = '+' then begin
            str := Copy(str, 2, length(str) - 1);
            // stdmode := Str_ToInt (str, -1);
            if stdmode >= 0 then begin
              //                     TMerchant(npc).DealGoods.Add (pointer (stdmode));
              TMerchant(npc).DealGoods.Add(str);
            end;
            continue;
          end;
        end;

        if str[1] = '{' then begin
          if CompareLStr(str, '{Quest', 6) then begin
            //퀘스트문 시작
            if pquest <> nil then begin

            end;
            str2 := GetValidStr3(str, Data, [' ', '}', #9]);
            GetValidStr3(str2, Data, [' ', '}', #9]);
            questnumber := Str_ToInt(Data, 0);
            pquest      := NewQuest;
            pquest.LocalNumber := questnumber;
            Inc(questnumber);
            psay := nil;
            step := 1;  //퀘스트의 조건
          end;
          if CompareLStr(str, '{~Quest', 6) then begin
            //퀘스트문 종료
            continue;
          end;
        end;
        if (step = 1) and (pquest <> nil) then begin  //퀘스트의 조건문
          if str[1] = '#' then begin
            str2   := GetValidStr3(str, Data, ['=', ' ', #9]);  //#IF[0] = 1
            valstr := Trim(str2);
            pquest.BoRequire := True;
            if CompareLStr(str, '#IF', 3) then begin
              ArrestStringEx(str, '[', ']', idxstr);
              pquest.QuestRequireArr[reqidx].CheckIndex := Str_ToInt(idxstr, 0);
              GetValidStr3(str2, valstr, ['=', ' ', #9]);  //#IF[0] = 1
              n := Str_ToInt(valstr, 0);
              if n <> 0 then
                n := 1;
              pquest.QuestRequireArr[reqidx].CheckValue := n;
            end;
            if CompareLStr(str, '#RAND', 5) then begin
              pquest.QuestRequireArr[reqidx].RandomCount := Str_ToInt(valstr, 0);
            end;
            continue;
          end;
        end;

        if str[1] = '[' then begin
          step := 10;  //새로운 문장의 시작
          if pquest = nil then begin
            pquest := NewQuest;
            pquest.LocalNumber := questnumber;
          end;

          if psayproc <> nil then begin
            AddAvailableCommands(psayproc.Saying, psayproc.AvailableCommands);
            AddAvailableCommands(psayproc.ElseSaying, psayproc.AvailableCommands);
          end;

          if CompareText(str, '[Goods]') = 0 then begin
            step := 20;
            //---------------------------
            TMerchant(npc).CreateIndex := CurrentMerchantIndex;
            // 상품이 있는 Merchant만 생성 Index 부여
            Inc(CurrentMerchantIndex);
            //---------------------------
            continue;
          end;

          ArrestStringEx(str, '[', ']', stepstr);
          new(psay);  //PTSayingRecord
          psay.Procs := TList.Create;
          psay.Title := stepstr;
          new(psayproc); //: PTSayingProcedure;
          psay.Procs.Add(psayproc);

          psayproc.ConditionList := TList.Create;
          psayproc.ActionList := TList.Create; //StringList.Create;
          psayproc.Saying     := '';
          psayproc.ElseActionList := TList.Create; //StringList.Create;
          psayproc.ElseSaying := '';
          psayproc.AvailableCommands := TStringList.Create;

          pquest.SayingList.Add(psay);
          continue;
        end;
        if (pquest <> nil) and (psay <> nil) then begin
          if (step >= 10) and (step < 20) then begin
            if str[1] = '#' then begin
              if CompareText(str, '#IF') = 0 then begin
                if (psayproc.ConditionList.Count > 0) or
                  (psayproc.Saying <> '') then begin
                  //추가적인 if문
                  new(psayproc); //: PTSayingProcedure;
                  psay.Procs.Add(psayproc);

                  psayproc.ConditionList := TList.Create;
                  psayproc.ActionList := TList.Create; //StringList.Create;
                  psayproc.Saying     := '';
                  psayproc.ElseActionList := TList.Create; //StringList.Create;
                  psayproc.ElseSaying := '';
                  psayproc.AvailableCommands := TStringList.Create;
                end;
                step := 11;
              end;
              if CompareText(str, '#ACT') = 0 then begin
                step := 12;
              end;
              if CompareText(str, '#SAY') = 0 then begin
                step := 10;
              end;
              if CompareText(str, '#ELSEACT') = 0 then begin
                step := 13;
              end;
              if CompareText(str, '#ELSESAY') = 0 then begin
                step := 14;
              end;
              continue;
            end;
          end;

          //문장의 대화 내용 (기본 대화)
          if (step = 10) and (psayproc <> nil) then begin
            psayproc.Saying := psayproc.Saying + ReplaceNewLine(str);
            if not TAIWANVERSION then  //대만문자코드는 '\' 를 사용한다.
              psayproc.Saying := ReplaceChar(psayproc.Saying, '\', char($a));
            TMerchant(npc).ActivateNpcUtilitys(psayproc.Saying);
          end;
          //문장의 조건
          if (step = 11) then begin
            new(pqcon);
            if DecodeConditionStr(Trim(str), pqcon) then begin
              psayproc.ConditionList.Add(pqcon);
            end else begin
              Dispose(pqcon);
              MainOutMessage('script error: ' + str + ' line:' +
                IntToStr(i) + ' : ' + flname);
            end;
          end;
          //문장의 (NPC의) 행동
          if (step = 12) then begin
            new(pqact);
            if DecodeActionStr(Trim(str), pqact) then begin
              psayproc.ActionList.Add(pqact);
            end else begin
              Dispose(pqact);
              MainOutMessage('script error: ' + str + ' line:' +
                IntToStr(i) + ' : ' + flname);
            end;
          end;
          //문장의 부정 행동 (조건에 맞지 않은 경우)
          if (step = 13) then begin
            new(pqact);
            if DecodeActionStr(Trim(str), pqact) then begin
              psayproc.ElseActionList.Add(pqact);
            end else begin
              Dispose(pqact);
              MainOutMessage('script error: ' + str + ' line:' +
                IntToStr(i) + ' : ' + flname);
            end;
          end;
          //문장의 부정 대화 (저건에 맞지 않은 경우 대화)
          if (step = 14) then begin
            psayproc.ElseSaying := psayproc.ElseSaying + ReplaceNewLine(str);
            if not TAIWANVERSION then  //대만문자코드는 '\' 를 사용한다.
              psayproc.ElseSaying :=
                ReplaceChar(psayproc.ElseSaying, '\', char($a));
            TMerchant(npc).ActivateNpcUtilitys(psayproc.ElseSaying);
          end;

          //continue;
        end;

        if (step = 20) and bomarket then begin //상품목록
          str := GetValidStrCap(str, itmname, [' ', #9]);
          str := GetValidStrCap(str, scount, [' ', #9]);
          str := GetValidStrCap(str, shour, [' ', #9]);

          if (itmname <> '') and (shour <> '') then begin
            new(pp);
            if itmname <> '' then begin
              if itmname[1] = '"' then
                ArrestStringEx(itmname, '"', '"', itmname);
            end;
            //pds
            if length(itmname) > 20 then    //item name length
              MainOutMessage('ITEM NAME > 20:' + itmname);

            pp.GoodsName := itmname;
            pp.Count     := _MIN(5000, Str_ToInt(scount, 1));
            // 상품 개수 5000개로 제한(sonmg 2005/02/04)
            pp.ZenHour   := Str_ToInt(shour, 1);
            // 2003/03/04 상점 젠 타임 조정 1분 -> 1시간
            pp.ZenTime   := GetTickCount - longword(pp.ZenHour) * 60 * 60 * 1000;
            //GetTickCount - 50 * 60 * 1000;

            TMerchant(Npc).ProductList.Add(pp);
          end;
        end;
      end;
    end;



    strlist.Free;

  end else begin
    MainOutMessage('File open failure : ' + flname);
  end;
  Result := 1;
end;

function TFrmDB.LoadNpcDef(npc: TNormNpc; basedir, npcname: string): integer;
begin
  if basedir = '' then
    basedir := NPCDEFDIR;
  Result := LoadMarketDef(npc, basedir, npcname, False);
end;


function TFrmDB.LoadMarketSavedGoods(merchant: TMerchant; marketname: string): integer;
var
  i, rbyte: integer;
  flname: string;
  header: TGoodsHeader;
  fhandle: integer;
  pu:   PTUserItem;
  list: TList;
begin
  Result  := -1;
  flname  := EnvirDir + MARKETSAVEDDIR + marketname + '.sav';
  fhandle := FileOpen(flname, fmOpenRead or fmShareDenyNone);
  list    := nil;
  if fhandle > 0 then begin
    rbyte := FileRead(fhandle, header, sizeof(TGoodsHeader));
    if rbyte = sizeof(TGoodsHeader) then begin
      for i := 0 to header.RecordCount - 1 do begin
        new(pu);
        rbyte := FileRead(fhandle, pu^, sizeof(TUserItem));
        if rbyte = sizeof(TUserItem) then begin    //잘못된 데이타를 버림
          if list = nil then begin
            list := TList.Create;
            list.Add(pu);
          end else begin
            if PTUserItem(list[0]).Index = pu.Index then begin
              list.Add(pu);
            end else begin
              merchant.GoodsList.Add(list);  //상품 리스트에 추가
              list := TList.Create;
              list.Add(pu);
            end;
          end;
        end else begin
          if pu <> nil then
            Dispose(pu); // Memory Leak sonmg
          break;
        end;
      end;
    end;
    if list <> nil then
      merchant.GoodsList.Add(list);  //상품 리스트에 추가
    FileClose(fhandle);
    Result := 1;
  end;
end;

function TFrmDB.WriteMarketSavedGoods(merchant: TMerchant; marketname: string): integer;
var
  i, k:    integer;
  flname:  string;
  header:  TGoodsHeader;
  fhandle: integer;
  list:    TList;
begin
  Result := -1;
  flname := EnvirDir + MARKETSAVEDDIR + marketname + '.sav';
  if FileExists(flname) then
    fhandle := FileOpen(flname, fmOpenWrite or fmShareDenyNone)
  else
    fhandle := FileCreate(flname);
  if fhandle > 0 then begin
    FillChar(header, sizeof(TGoodsHeader), #0);
    header.RecordCount := 0;
    for i := 0 to merchant.GoodsList.Count - 1 do begin
      list := TList(merchant.GoodsList[i]);
      header.RecordCount := header.RecordCount + list.Count;
    end;
    FileWrite(fhandle, header, sizeof(TGoodsHeader));
    for i := 0 to merchant.GoodsList.Count - 1 do begin
      list := TList(merchant.GoodsList[i]);
      for k := 0 to list.Count - 1 do
        FileWrite(fhandle, PTUserItem(list[k])^, sizeof(TUserItem));
    end;

    FileClose(fhandle);
    Result := 1;
  end;
end;

function TFrmDB.LoadMarketPrices(merchant: TMerchant; marketname: string): integer;
var
  fhandle, i, rbyte: integer;
  flname: string;
  ppi:    PTPricesInfo;
  header: TGoodsHeader;
begin
  Result  := -1;
  flname  := EnvirDir + MARKETPRICESDIR + marketname + '.prc';
  fhandle := FileOpen(flname, fmOpenRead or fmShareDenyNone);
  if fhandle > 0 then begin
    rbyte := FileRead(fhandle, header, sizeof(TGoodsHeader));
    if rbyte = sizeof(TGoodsHeader) then begin
      for i := 0 to header.RecordCount - 1 do begin
        new(ppi);
        rbyte := FileRead(fhandle, ppi^, sizeof(TPricesInfo));
        if rbyte = sizeof(TPricesInfo) then begin    //잘못된 데이타를 버림
          merchant.PriceList.Add(ppi);
        end else begin
          Dispose(ppi);
          break;
        end;
      end;
    end;

    FileClose(fhandle);
    Result := 1;
  end;
end;

function TFrmDB.WriteMarketPrices(merchant: TMerchant; marketname: string): integer;
var
  fhandle, i: integer;
  flname:     string;
  header:     TGoodsHeader;
begin
  Result := -1;
  flname := EnvirDir + MARKETPRICESDIR + marketname + '.prc';
  if FileExists(flname) then
    fhandle := FileOpen(flname, fmOpenWrite or fmShareDenyNone)
  else
    fhandle := FileCreate(flname);
  if fhandle > 0 then begin
    FillChar(header, sizeof(TGoodsHeader), #0);
    header.RecordCount := merchant.PriceList.Count;
    FileWrite(fhandle, header, sizeof(TGoodsHeader));
    for i := 0 to merchant.PriceList.Count - 1 do begin
      FileWrite(fhandle, PTPricesInfo(merchant.PriceList[i])^, sizeof(TPricesInfo));
    end;
    FileClose(fhandle);
    Result := 1;
  end;
end;

function TFrmDB.LoadMarketUpgradeInfos(marketname: string; upglist: TList): integer;
var
  fhandle, i, Count, rbyte: integer;
  flname: string;
  pup:    PTUpgradeInfo;
  up:     TUpgradeInfo;
begin
  Result := -1;
  flname := EnvirDir + MARKETUPGRADEDIR + marketname + '.upg';
  if FileExists(flname) then begin
    fhandle := FileOpen(flname, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then begin
      FileRead(fhandle, Count, sizeof(integer));
      for i := 0 to Count - 1 do begin
        rbyte := FileRead(fhandle, up, sizeof(TUpgradeInfo));
        if rbyte = sizeof(TUpgradeInfo) then begin
          new(pup);
          pup^ := up;
          pup.readycount := 0;
          upglist.Add(pup);
        end else
          break;
      end;
      Result := 1;
      FileClose(fhandle);
    end;
  end;
end;

function TFrmDB.WriteMarketUpgradeInfos(marketname: string; upglist: TList): integer;
var
  fhandle, i, Count: integer;
  flname: string;
begin
  Result := -1;
  flname := EnvirDir + MARKETUPGRADEDIR + marketname + '.upg';
  if FileExists(flname) then
    fhandle := FileOpen(flname, fmOpenWrite or fmShareDenyNone)
  else
    fhandle := FileCreate(flname);
  if fhandle > 0 then begin
    Count := upglist.Count;
    FileWrite(fhandle, Count, sizeof(integer));
    for i := 0 to upglist.Count - 1 do begin
      FileWrite(fhandle, PTUpgradeInfo(upglist[i])^, sizeof(TUpgradeInfo));
    end;
    FileClose(fhandle);
    Result := 1;
  end;
end;


end.
