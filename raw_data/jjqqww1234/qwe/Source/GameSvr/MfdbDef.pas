unit MfdbDef;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, HUtil32, FileCtrl, Grobal2, MudUtil;

const
  IDXTITLE     = 'legend of mir database index file 2001/7';
  SIZEOFTHUMAN = 456;

  SIZEOFFDB   = 4937 + 8 + 40 * 50;
  //   SIZEOFEIFDB = 4128;
  SIZEOFEIFDB = 4937; // gadget (not used in MIR2)

type
  TUseMagicInfo = packed record // gadget (8byte)
    MagicId:  word;  //항상 1보다 크다
    Level:    byte;
    Key:      AnsiChar;
    Curtrain: integer;
  end;

{$ifdef MIR2EI}  //EI 용

   //ei
   THuman = packed record // gadget
      UserName    : array [0..24] of AnsiChar;  //14, 변경
      MapName     : array [0..19] of AnsiChar;  //16, 변경
      CX          : word;
      CY          : word;
      Dir         : byte;
      Hair        : byte;    {* }
      HairColorR  : byte;
      HairColorG  : byte;
      HairColorB  : byte;
      Sex         : byte;
      Job         : byte;
      Gold        : integer;
      Abil        : TAbility;
      StatusArr   : array [0..12] of word;  //남은 시간 기록
      HomeMap     : array [0..19] of AnsiChar;  //16, 변경
      HomeX       : word;
      HomeY       : word;
//      NeckName    : string[20];  //삭제
//      SkillArr    : array[0..7] of TSkillInfo; remark by gadget
      PKPoint     : integer;
      AllowParty  : byte;
      FreeGulityCount: byte; //면죄해준 횟수
      AttackMode: byte;  //대인 공격 방식
      IncHealth   : byte;
      IncSpell    : byte;
      IncHealing  : byte;
      FightZoneDie: byte;  //문파 대련장에서 죽은 카운트
      UserId      : array [0..24] of AnsiChar;
      DBVersion   : byte;  //DB의 일부데이터를 일정한 날을 기준으로 변경했는지 않했는지 알기 위해
      BonusApply  : byte;
//      BonusAbil   : TNakedAbility;  //렙업마다 올린 능력치 remark by gadget
//      CurBonusAbil: TNakedAbility;  //현재 올라가 있는 능력치 remark by gadget
      BonusPoint  : integer;
      DailyQuest : longword;
      HorseRide : byte;  //166
      CGHIUseTime : word;
      BodyLuck    : TDouble;  //8
      BoEnableGRecall: Boolean;
      bytes_1     : array[0..2] of byte;
//      Reserved    : array[0..99] of byte;
      QuestOpenIndex : array[0..MAXQUESTINDEXBYTE-1] of byte;  //24, ei에서 앞으 192개는 Open, 뒤의 192개는 깼는지 여부
      QuestFinIndex : array[0..MAXQUESTINDEXBYTE-1] of byte;   //24, ei에서 앞으 192개는 Open, 뒤의 192개는 깼는지 여부
      Quest       : array[0..MAXQUESTBYTE-1] of byte;  //176
      HorseRace : byte;     // gadget
   end; //EI 용

   //ei
   TBagItem = packed record  //ei 용 가방, 착용창 // gadget
      uDress      : TUserItem;
      uWeapon     : TUserItem;
      uRightHand  : TUserItem;  //초 잡는 자리
      uHelmet     : TUserItem;
      uNecklace   : TUserItem;
      uArmRingL   : TUserItem;
      uArmRingR   : TUserItem;
      uRingL      : TUserItem;
      uRingR      : TUserItem;

      uBelt       : TUserItem;  //벨트 (추가)
      uHandBag    : TUserItem;  //독가루(부적) 자리,  (추가)
      uShoes      : TUserItem;  //신발 (추가)

      Bags        : array[0..MAXBAGITEM-1] of TUserItem;   //1536

//      HorseBags   : array[0..MAXHORSEBAG-1] of TUserItem;  //말 가방,  (추가)
   end; //EI 용

   //ei
   TUseMagic = packed record //gadget
      Magics   : array[0..MAXUSERMAGIC-1] of TUseMagicInfo;
   end;

   //ei
   TSaveItem = packed record // gadget
      Items    : array[0..MAXSAVEITEM-1] of TUserItem;
   end;

   // EI 용

{$else}//기존 미르2

  THuman = packed record
    UserName: array [0..19] of AnsiChar;  //14, 변경
    MapName: array [0..19] of AnsiChar;   //16, 변경
    CX:      word;
    CY:      word;
    Dir:     byte;
    Hair:    byte;
    HairColorR: byte;       //TO PDS: INSERT Field
    HairColorG: byte;       //TO PDS: INSERT Field
    HairColorB: byte;       //TO PDS: INSERT Field
    Sex:     byte;
    Job:     byte;
    Gold:    integer;
    //    Abil        : TAbility;
    Abil_Level: byte;
    Abil_HP: word;
    Abil_MP: word;
    Abil_Exp: longword;
    StatusArr: array[0..STATUSARR_SIZE - 1] of word;  //남은 시간 기록
    HomeMap: array [0..19] of AnsiChar;  //16, 변경
    HomeX:   word;
    HomeY:   word;
    //    NeckName    : string[20];
    //    SkillArr    : array[0..7] of TSkillInfo;
    PKPoint: integer;
    AllowParty: byte;
    FreeGulityCount: byte; //면죄해준 횟수
    AttackMode: byte;      //대인 공격 방식
    IncHealth: byte;
    IncSpell: byte;
    IncHealing: byte;
    FightZoneDie: byte;  //문파 대련장에서 죽은 카운트
    UserId:  array [0..19] of AnsiChar;
    DBVersion: byte;
    //DB의 일부데이터를 일정한 날을 기준으로 변경했는지 않했는지 알기 위해
    BonusApply: byte;
    //    BonusAbil   : TNakedAbility;  //렙업마다 올린 능력치
    //    CurBonusAbil: TNakedAbility;  //현재 올라가 있는 능력치
    BonusPoint: integer;
    //    HungryState : longword;
    DailyQuest: longword;   // TO PDS:INSERT Fileld
    HorseRide: byte;
    //    TestServerResetCount: byte;  //166
    CGHIUseTime: word;
    BodyLuck: TDouble;  //8
    BoEnableGRecall: boolean;

    //    DailyQuestNumber: word;
    //    DailyQuestGetDate: word;

    bytes_1:   array[0..2] of byte;
    //    Reserved    : array[0..23] of AnsiChar; //216] of AnsiChar;
    QuestOpenIndex: array[0..MAXQUESTINDEXBYTE - 1] of byte;  //24,
    QuestFinIndex: array[0..MAXQUESTINDEXBYTE - 1] of byte;   //24,
    Quest:     array[0..MAXQUESTBYTE - 1] of byte;  // 176
    HorseRace: byte;
  end;

  //미르2
  TBagItem = packed record
    uDress: TUserItem;
    uWeapon: TUserItem;
    uRightHand: TUserItem;
    uHelmet: TUserItem;
    uNecklace: TUserItem;
    uArmRingL: TUserItem;
    uArmRingR: TUserItem;
    uRingL: TUserItem;
    uRingR: TUserItem;
    uBujuk: TUserItem;  // TO PDS
    uBelt: TUserItem;   // TO PDS
    uBoots: TUserItem;  // TO PDS
    uCharm: TUserItem;  // TO PDS
    Bags: array[0..MAXBAGITEM - 1] of TUserItem;   //1536
  end;

  //미르2
  TUseMagic = packed record                          //546
    Magics: array[0..MAXUSERMAGIC - 1] of TUseMagicInfo;
  end;

  //미르2
  TSaveItem = packed record
    Items: array[0..MAXSAVEITEM - 1] of TUserItem;
  end;

  //기존 미르2                                       //576  //456

{$endif}

  TMirDBBlockData = packed record
    DBHuman:    THuman;
    DBBagItem:  TBagItem;
    DBUseMagic: TUseMagic;
    DBSaveItem: TSaveItem;
  end;
  PTMirDBBlockData = ^TMirDBBlockData;

  FDBHeader = record
    Title:     string[88];
    LastChangeRecordPosition: integer;  //마지막으로 고친 레코드의 인덱스
    LastChangeDateTime: TDouble;  //마지막으로 고친 레코드의 시간
    MaxCount:  integer;           {record count}
    BlockSize: integer;           {record unit size}
    Reserved:  integer;           //FirstSpace: integer; {first space record position}
    UpdateDateTime: TDouble;      //TDateTime;
  end;
  PFDBHeader = ^FDBHeader;

  FDBRecord = packed record // gadget
    Deleted: boolean; {delete mark}
    UpdateDateTime: TDouble; //TDateTime;
    Key:     array [0..14] of AnsiChar;
    Block:   TMirDBBlockData; //NextSpace: integer; {next space record position}
  end;
  PFDBRecord = ^FDBRecord;

  FDBTemp = record
    Deleted: boolean; {delete mark}
    UpdateDateTime: TDouble; //TDateTime;
    Key:     string[20];  //CO19
  end;
  PFDBTemp = ^FDBTemp;

  FDBRecordInfo = record
    Deleted:  boolean; {delete mark}
    UpdateDateTime: TDouble; //TDateTime;
    Key:      string[20];  //CO19
    Reserved: integer; //NextSpace: integer;
  end;
  PFDBRecordInfo = ^FDBRecordInfo;

  //인덱스 저정 파일의 헤더, DB서버를 종료 하는 순간 인덱스를 저장한다.
  //인덱스가 유효하게 저장되지 않았다면 Rebuild한다.

  FDBIndexHeader = record
    Title:      string[96];
    IdxCount:   integer;   //인덱스 수
    MaxCount:   integer;   //FDBHeader의 MaxCount와 일치해야 한다.
    BlankCount: integer;
    LastChangeRecordPosition: integer;  //마지막으로 고친 레코드의 인덱스
    LastChangeDateTime: TDouble;  //마지막으로 고친 레코드의 시간
  end;
  PFDBIndexHeader = ^FDBIndexHeader;

  FIndexRcd = record
    Key:      string[20];  //Key의 크기 주의    //CO19
    Position: integer;
  end;

  TFileDB = class
  private
    CurIndex: integer;
    //FirstSpace: integer;
    fhandle:  integer;
    FRefresh: TNotifyEvent;
    Updated:  boolean;
    LatestRecordIndex: integer;   //마지막으로 기록한 레코드 번호
    LatestUpdateTime: TDateTime;  //마지막으로 기록한 레코드의 시록 시간
    function ReadRecord(index: integer; var rcd: FDBRecord): boolean;
    //function  FindBlankRecord: integer;
    function WriteRecord(index: integer; rcd: FDBRecord; asnew: boolean): boolean;
    function SetRecordDate(index: integer; setdate: TDateTime): boolean; // curtion..
    function DeleteRecord(index: integer): boolean;
    procedure SaveIndexs;
    function LoadIndexs: boolean;
  public
    DBHeader:     FDBHeader;
    MemIndexList: TQuickList; {username + data position}
    BlankList:    TList;
    DBFileName:   string;
    IDXFileName:  string;
    constructor Create(flname: string);
    destructor Destroy; override;
    procedure BuildIndex;
    procedure ReBuild;
    ///procedure ReBuild2;
    procedure LockDB;
    procedure UnlockDB;
    function OpenRd: boolean;
    function OpenWr: boolean;
    procedure Close;
    function First: integer;
    function Next: integer;
    function Prior: integer;
    function Get(var rcd: FDBRecord): integer;
    function Delete(uname: string): boolean;
    function DeleteIndex(idx: integer): boolean;
    procedure GetBlankList(blist: TStrings);
    function GetRecordCount: integer;
    function GetRecord(index: integer; var rcd: FDBRecord): integer;
    function GetRecordDr(index: integer; var rcd: FDBRecord): boolean;
    function SetRecord(index: integer; rcd: FDBRecord): boolean;
    function SetRecordTime(index: integer; settime: TDateTime): boolean;
    function AddRecord(rcd: FDBRecord): boolean;
    function Find(uname: string): integer; {find by name only/find from index table}
    function FindLike(uname: string; flist: TStrings): integer; {found count}
    function FindRecord(uname: string; var rcd: FDBRecord): boolean;
    function GetDBUpdateDateTime(dbname: string): TDateTime;
    procedure UpdateDBTime(dbname: string);
    function DBSaveAs(dbname, targname: string; backuptime: integer): boolean;
    function GetRcdFromFile(dbfile, uname: string; idx: integer;
      var rcd: FDBRecord): boolean;
  published
    property OnRefresh: TNotifyEvent Read FRefresh Write FRefresh;
  end;

var
  CSDBLock:  TRTLCriticalSection;
  CurLoading, ValidLoading, DeleteCount, MaxLoading: integer;
  MirLoaded: boolean;

implementation


constructor TFileDB.Create(flname: string);
begin
  CurIndex     := 0;
  MirLoaded    := False;
  DBFileName   := flname;
  IDXFileName  := flname + '.idx';
  MemIndexList := TQuickList.Create;
  BlankList    := TList.Create;
  CurLoading   := 0;
  MaxLoading   := 0;
  LatestRecordIndex := -1;  //갱신 없음 표시(초기화)
  if LoadIndexs then begin
    MirLoaded := True;
  end else
    BuildIndex;
end;

destructor TFileDB.Destroy;
begin
  if MirLoaded then
    SaveIndexs;
  MemIndexList.Free;
  BlankList.Free;
  //   FIndex.Free;
end;

procedure TFileDB.LockDB;
begin
  EnterCriticalSection(CSDBLock);
end;

procedure TFileDB.UnlockDB;
begin
  LeaveCriticalSection(CSDBLock);
end;

function TFileDB.OpenRd: boolean;
var
  header: FDBHeader;
begin
  LockDB;
   {$I-}
  Updated := False;
  fhandle := FileOpen(DBFileName, fmOpenRead or fmShareDenyNone);
  if fhandle > 0 then begin
    Result := True;
    if FileRead(fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then
      DBHeader := header;
    CurIndex := 0;
  end else
    Result := False;
end;

function TFileDB.OpenWr: boolean;
var
  header: FDBHeader;
begin
  LockDB;
   {$I-}
  CurIndex := 0;
  Updated  := False;
  if FileExists(DBFileName) then begin
    fhandle := FileOpen(DBFileName, fmOpenReadWrite or fmShareDenyNone);
    if fhandle > 0 then
      FileRead(fhandle, DBHeader, sizeof(FDBHeader));
  end else begin
    fhandle      := FileCreate(DBFileName);
    header.Title := 'legend of mir database file 1999/1';
    header.MaxCount := 0;
    header.BlockSize := 0;
    //header.FirstSpace:= -1;
    FileWrite(fhandle, header, sizeof(FDBHeader));
  end;
  if fhandle > 0 then
    Result := True
  else
    Result := False;
end;

procedure TFileDB.Close;
begin
  FileClose(fhandle);
   {$I+}
  if Updated then begin
    if Assigned(FRefresh) then
      FRefresh(self);
  end;
  UnlockDB;
end;

procedure TFileDB.BuildIndex;
var
  i, curpos: integer;
  //rcd: FDBRecord;
  header:  FDBHeader;
  //rcdinfo: FDBRecordInfo;
  tmprcd:  FDBTemp;
begin
  CurIndex := 0;
  //FirstSpace := -1;
  MemIndexList.Clear;
  BlankList.Clear;
  CurLoading   := 0;
  ValidLoading := 0;
  DeleteCount  := 0;
  MaxLoading   := 0;
  try
    if OpenWr then begin
      FileSeek(fhandle, 0, 0);
      if FileRead(fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
        MaxLoading := header.MaxCount;
        for i := 0 to header.MaxCount - 1 do begin
          Inc(CurLoading);
          curpos := sizeof(FDBHeader) + i * sizeof(FDBRecord);
          if FileSeek(fhandle, curpos, 0) = -1 then
            break;
          if FileRead(fhandle, tmprcd, sizeof(FDBTemp)) = sizeof(FDBTemp) then
          begin
            if not tmprcd.Deleted then begin
              if tmprcd.Key <> '' then begin
                MemIndexList.AddObject(tmprcd.Key, TObject(i));
                //QAddObject (rcd.Key, TObject(curidx));
                Inc(ValidLoading);
              end else
                BlankList.Add(pointer(i));
            end else begin
              BlankList.Add(pointer(i));
              //oldpos := FileSeek (fhandle, 0, 1);
              //FileSeek (fhandle, curpos, 0);
              //FileRead (fhandle, rcdinfo, sizeof(FDBRecordInfo));
              //rcdinfo.NextSpace := FirstSpace;
              //FirstSpace := i;
              //FileSeek (fhandle, curpos, 0);
              //FileWrite (fhandle, rcdinfo, sizeof(FDBRecordInfo));
              Inc(DeleteCount);
            end;
          end else
            break;
          Application.ProcessMessages;
          if Application.Terminated then begin
            Close;
            exit;
          end;
        end;
      end;
    end;
  finally
    Close;
  end;
  QuickSortStrListNoCase(MemIndexList, 0, MemIndexList.Count - 1);
  LatestRecordIndex := DBHeader.LastChangeRecordPosition;
  LatestUpdateTime := SolveDouble(DBHeader.LastChangeDateTime);
  MirLoaded := True;
end;

(*
procedure TFileDB.BuildIndex;
var
   i, j, curidx, curpos, oldpos: integer;
   rcd: FDBRecord;
   header: FDBHeader;
   rcdinfo: FDBRecordInfo;
begin
   CurIndex := 0;
   FirstSpace := -1;
   MemIndexList.Clear;
   curidx := 0;
   CurLoading := 0;
   ValidLoading := 0;
   MaxLoading := 0;
   try
      if OpenWr then begin
         FileSeek (fhandle, 0, 0);
         if FileRead (fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
            MaxLoading := header.MaxCount;
            for i:=0 to header.MaxCount-1 do begin
               Inc (CurLoading);
               if FileRead (fhandle, rcd, sizeof(FDBRecord)) = sizeof(FDBRecord) then begin
                  if not rcd.Deleted then begin
                     MemIndexList.AddObject (rcd.Key, TObject(curidx)); //QAddObject (rcd.Key, TObject(curidx));
                     Inc (ValidLoading);
                  end else begin
                     oldpos := FileSeek (fhandle, 0, 1);
                     FileSeek (fhandle, - sizeof(FDBRecord), 1);
                     FileRead (fhandle, rcdinfo, sizeof(FDBRecordInfo));
                     FileSeek (fhandle, - sizeof(FDBRecordInfo), 1);
                     rcdinfo.NextSpace := FirstSpace;
                     FirstSpace := curidx;
                     FileWrite (fhandle, rcdinfo, sizeof(FDBRecordInfo));
                     FileSeek (fhandle, oldpos, 0);
                  end;
               end else
                  break;
               Inc (curidx);
               Application.ProcessMessages;
               if Application.Terminated then begin
                  Close;
                  exit;
               end;
            end;
         end;
      end;
   finally
      Close;
   end;
   QuickSortStrListNoCase(MemIndexList, 0, MemIndexList.Count-1);
   LatestRecordIndex := DBHeader.LastChangeRecordPosition;
   LatestUpdateTime := SolveDouble (DBHeader.LastChangeDateTime);
   MirLoaded := TRUE;
end; *)

procedure TFileDB.Rebuild;
var
  tempfile: string;
  fh, total: integer;
  header: FDBHeader;
  rcd: FDBRecord;
begin
  tempfile := 'Mir#$00.DB';
  if FileExists(tempfile) then
    DeleteFile(tempfile);
  fh    := FileCreate(tempfile);
  total := 0;
  if fh > 0 then begin
    try
      if OpenWr then begin
        FileSeek(fhandle, 0, 0);
        if FileRead(fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then
        begin
          FileWrite(fh, header, sizeof(FDBHeader));
          while True do begin
            if FileRead(fhandle, rcd, sizeof(FDBRecord)) = sizeof(FDBRecord) then
            begin
              if not rcd.Deleted then begin
                FileWrite(fh, rcd, sizeof(FDBRecord));
                Inc(total);
              end;
            end else
              break;
          end;
        end;
        header.MaxCount := total;
        //header.FirstSpace := -1;
        header.UpdateDateTime := PackDouble(Now);
        FileSeek(fh, 0, 0);
        FileWrite(fh, header, sizeof(FDBHeader));
      end;
    finally
      Close;
    end;
    FileClose(fh);
    FileCopy(tempfile, DBFileName);
    DeleteFile(tempfile);
  end;
  //BuildIndex;
end;

(**procedure TFileDB.Rebuild2;
var
   tempfile: string;
   fh, total: integer;
   header: FDBHeader;
   rcd: FDBRecord;
   rcd2: FDBRecord2;
begin
   tempfile := 'Mir_Rebuild.DB';
   if FileExists (tempfile) then DeleteFile (tempfile);
   fh := FileCreate (tempfile);
   total := 0;
   if fh > 0 then begin
      try
         if OpenWr then begin
            FileSeek (fhandle, 0, 0);
            if FileRead (fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
               FileWrite (fh, header, sizeof(FDBHeader));
               while TRUE do begin
                  if FileRead (fhandle, rcd, sizeof(FDBRecord)) = sizeof(FDBRecord) then begin
                     FillChar(rcd2, sizeof(FDBRecord2), #0);
                     Move (rcd, rcd2, sizeof(FDBRecord));
                     FileWrite (fh, rcd2, sizeof(FDBRecord2));
                     Inc (total);
                  end else
                     break;
               end;
            end;
            header.MaxCount := total;
            header.FirstSpace := -1;
            header.UpdateDateTime := Now;
            FileSeek (fh, 0, 0);
            FileWrite (fh, header, sizeof(FDBHeader));
         end;
      finally
         Close;
      end;
      FileClose (fh);
      //FileCopy (tempfile, DBFileName);
      //DeleteFile (tempfile);
   end;
   //BuildIndex;
end; **)


procedure TFileDB.SaveIndexs;
var
  IdxFileHeader: FDBIndexHeader;
  f, i, n: integer;
  IdxRcd:  FIndexRcd;
begin
  FillChar(IdxFileHeader, sizeof(FDBIndexHeader), #0);
  with IdxFileHeader do begin
    Title      := IDXTITLE;
    IdxCount   := MemIndexList.Count;
    MaxCount   := DBHeader.MaxCount;
    BlankCount := BlankList.Count;
    LastChangeRecordPosition := LatestRecordIndex;
    LastChangeDateTime := PackDouble(LatestUpdateTime);
  end;
   {$I-}
  if FileExists(IDXFileName) then begin
    f := FileOpen(IDXFileName, fmOpenReadWrite or fmShareDenyNone);
  end else begin
    f := FileCreate(IDXFileName);
  end;
  if f > 0 then begin
    FileWrite(f, IdxFileHeader, sizeof(FDBIndexHeader));
    for i := 0 to MemIndexList.Count - 1 do begin
      IdxRcd.Key      := MemIndexList[i];
      IdxRcd.Position := integer(MemIndexList.Objects[i]);
      FileWrite(f, IdxRcd, sizeof(FIndexRcd));
    end;
    for i := 0 to BlankList.Count - 1 do begin
      n := integer(BlankList[i]);
      FileWrite(f, n, sizeof(integer));
    end;
    FileClose(f);
  end;
   {$I+}
end;

 //저장된 인덱스 파일을 읽어 온다.
 //채크 사항
 //  1) Index->MaxCount = FDB->MaxCount
 //  2) 마지막 억세스한 레코드의 사간이 같은지 여부
function TFileDB.LoadIndexs: boolean;
var
  IdxFileHeader: FDBIndexHeader;
  f, i, n: integer;
  IdxRcd:  FIndexRcd; //인덱스 헤더
  header:  FDBHeader; //데이터 헤더
  rcd:     FDBRecord;
begin
  Result := False;
  f      := 0;
  FillChar(IdxFileHeader, sizeof(FDBIndexHeader), #0);
   {$I-}
  if FileExists(IDXFileName) then begin
    f := FileOpen(IDXFileName, fmOpenReadWrite or fmShareDenyNone);
  end;
  if f > 0 then begin
    Result := True;
    FileRead(f, IdxFileHeader, sizeof(FDBIndexHeader));
    //DB서버의 내용과 같은지 확인을 한다.
    try
      if OpenWr then begin
        FileSeek(fhandle, 0, 0);
        if FileRead(fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then
        begin
          //FDB의 최대 갯수와 인덱스의 최대 갯수를 비교한다.
          if IdxFileHeader.MaxCount <> header.MaxCount then
            Result := False;
          if IdxFileHeader.Title <> IDXTITLE then
            Result := False;
        end;
        //FDB의 마지막으로 변경되 레코드의 포지션과, 인덱스의 마지막으로 변경된 레코드
        //포지션이 같은지도 검사한다.
        if IdxFileHeader.LastChangeRecordPosition <>
          header.LastChangeRecordPosition then begin
          Result := False;
        end;
        //인덱스의 마지막으로 변경된 레코드의 변경 날짜가 FDB의 변경날짜와
        //일치하는지 다시한번 검사한다.
        if IdxFileHeader.LastChangeRecordPosition > -1 then begin
          FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FDBRecord) *
            IdxFileHeader.LastChangeRecordPosition, 0);
          if FileRead(fhandle, rcd, sizeof(FDBRecord)) = sizeof(FDBRecord) then
          begin
            if SolveDouble(IdxFileHeader.LastChangeDateTime) <>
              SolveDouble(rcd.UpdateDateTime) then
              Result := False;
          end;
        end;
      end;
    finally
      Close;
    end;

    if Result then begin
      LatestRecordIndex := IdxFileHeader.LastChangeRecordPosition;
      LatestUpdateTime  := SolveDouble(IdxFileHeader.LastChangeDateTime);
      for i := 0 to IdxFileHeader.IdxCount - 1 do begin
        if FileRead(f, IdxRcd, sizeof(FIndexRcd)) = sizeof(FIndexRcd) then begin
          MemIndexList.AddObject(IdxRcd.Key, TObject(IdxRcd.Position));
        end else begin
          Result := False;
          break;
        end;
      end;
      for i := 0 to IdxFileHeader.BlankCount - 1 do begin
        if FileRead(f, n, sizeof(integer)) = sizeof(integer) then begin
          BlankList.Add(pointer(n));
        end else begin
          Result := False;
          break;
        end;
      end;
    end;
    FileClose(f);
  end;
   {$I+}
  if Result then begin
    CurLoading   := MemIndexList.Count;
    ValidLoading := MemIndexList.Count;
    MaxLoading   := header.MaxCount;
    QuickSortStrListNoCase(MemIndexList, 0, MemIndexList.Count - 1);
  end else
    MemIndexList.Clear;
end;



function TFileDB.First: integer;
begin
  CurIndex := 0;
  Result   := CurIndex;
end;

function TFileDB.Next: integer;
begin
  if CurIndex < GetRecordCount - 1 then
    Inc(CurIndex);
  Result := CurIndex;
end;

function TFileDB.Prior: integer;
begin
  if CurIndex >= 0 then
    Dec(CurIndex);
  Result := CurIndex;
end;

function TFileDB.Get(var rcd: FDBRecord): integer;
begin
  //FileRead (fhandle, rcd, sizeof(FDBRecord));
  //FileSeek (fhandle, - sizeof(FDBRecord), 1);
  Result := -1;
end;

 {private}
 {다음 빈공간 레코드번호 리턴, 없으면 -1}
 {index is must zero or lager then zero}
function TFileDB.DeleteRecord(index: integer): boolean;
var
  rcdinfo: FDBRecordInfo;
  nowtime: TDateTime;
begin
  Result := False; //Error;
  if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FDBRecord) * index, 0) <> -1 then
  begin
    //마지막으로 갱신된 레코드의 번호와 시간(인덱스 저장에 쓰임)
    nowtime := Now;
    LatestRecordIndex := index;
    LatestUpdateTime := nowtime;

    rcdinfo.Deleted := True;
    rcdinfo.UpdateDateTime := PackDouble(nowtime);
    //rcdinfo.NextSpace := FirstSpace;
    //FirstSpace := index;
    FileWrite(fhandle, rcdinfo, sizeof(FDBRecordInfo));
    BlankList.Add(pointer(index));

    DBHeader.LastChangeRecordPosition := LatestRecordIndex;
    DBHeader.LastChangeDateTime := PackDouble(LatestUpdateTime);
    //DBHeader.FirstSpace  := FirstSpace;
    DBHeader.UpdateDateTime     := PackDouble(Now);
    FileSeek(fhandle, 0, 0);
    FileWrite(fhandle, DBHeader, sizeof(FDBHeader));
    Updated := True;

    Result := True;
  end;
end;

function TFileDB.Delete(uname: string): boolean;
var
  n: integer;
begin
  Result := False;
  n      := MemIndexList.FFind(uname);
  if n >= 0 then begin
    if DeleteRecord(integer(MemIndexList.Objects[n])) then begin
      MemIndexList.Delete(n);
      Result := True;
    end;
  end;
end;

function TFileDB.DeleteIndex(idx: integer): boolean;
var
  i:     integer;
  uname: string;
begin
  Result := False;
  for i := 0 to MemIndexList.Count - 1 do begin
    if integer(MemIndexList.Objects[i]) = idx then begin
      uname := MemIndexList[i];
      if DeleteRecord(integer(MemIndexList.Objects[i])) then begin
        MemIndexList.Delete(i);
        Result := True;
      end;
      break;
    end;
  end;
end;

procedure TFileDB.GetBlankList(blist: TStrings);
var
  {fspace,} i: integer;
  //rcdinfo:   FDBRecordInfo;
begin
  for i := 0 to BlankList.Count - 1 do
    blist.Add(IntToStr(integer(BlankList[i])));
   {fspace := FirstSpace;
   for i:=0 to 10000000 do begin
      if fspace = -1 then break;
      blist.Add (IntToStr(fspace));
      FileSeek (fhandle, sizeof(FDBHeader) + sizeof(FDBRecord) * fspace, 0);
      if FileRead (fhandle, rcdinfo, sizeof(FDBRecordInfo)) = sizeof(FDBRecordInfo) then begin
         fspace := rcdinfo.NextSpace;
      end else
         fspace := -1;
   end; }
end;

function TFileDB.GetRecordCount: integer;
begin
  Result := MemIndexList.Count;
end;

function TFileDB.ReadRecord(index: integer; var rcd: FDBRecord): boolean;
begin
  if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FDBRecord) * index, 0) <> -1 then
  begin
    FileRead(fhandle, rcd, sizeof(FDBRecord));
    FileSeek(fhandle, -sizeof(FDBRecord), 1);
    CurIndex := index;
    Result   := True;
  end else
    Result := False;
end;

function TFileDB.SetRecordDate(index: integer; setdate: TDateTime): boolean;
var
  opos:    integer;
  rcdinfo: FDBRecordInfo;
begin
  if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FDBRecord) * index, 0) <> -1 then
  begin
    opos := FileSeek(fhandle, 0, 1);
    if FileRead(fhandle, rcdinfo, sizeof(FDBRecordInfo)) = sizeof(FDBRecordInfo) then
    begin
      rcdinfo.UpdateDateTime := PackDouble(setdate);
      FileSeek(fhandle, opos, 0);
      FileWrite(fhandle, rcdinfo, sizeof(FDBRecordInfo));
    end;
    Updated := True;
    Result  := True;
  end else
    Result := False;
end;

{function  TFileDB.FindBlankRecord: integer;
var
   icount: integer;
   rcdinfo: FDBRecordInfo;
begin
   icount := 0;
   FileSeek (fhandle, sizeof(FDBHeader), 0);
   while TRUE do begin
      if FileRead (fhandle, rcdinfo, sizeof(FDBRecordInfo)) = sizeof(FDBRecordInfo) then begin
         if rcdinfo.Deleted then Result := icount;
      end else begin
         icount := -1;
         Result := icount;
         break;
      end;
      Inc (icount);
   end;
   Result := icount;
end;    }

function TFileDB.WriteRecord(index: integer; rcd: FDBRecord; asnew: boolean): boolean;
var
  opos, rpos: integer;
  rcdinfo: FDBRecordInfo;
  rcd2:    FDBRecord;
  nowtime: TDateTime;
begin
  rpos := sizeof(FDBHeader) + sizeof(FDBRecord) * index;
  if FileSeek(fhandle, rpos, 0) = rpos then begin
    //마지막으로 갱신된 레코드의 번호와 시간(인덱스 저장에 쓰임)
    nowtime := Now;
    LatestRecordIndex := index;
    LatestUpdateTime := nowtime;

    opos := FileSeek(fhandle, 0, 1);
    if asnew then begin //추가
      if FileRead(fhandle, rcd2, sizeof(FDBRecord)) = sizeof(FDBRecord) then begin
        if (not rcd2.Deleted) and (rcd2.Key <> '') then begin
          //지워지지 않은 데이타에 잘못 링크됨
          Result := False;
          exit;
        end;
      end;
    end;
    rcd.Deleted := False;
    rcd.UpdateDateTime := PackDouble(Now);
    DBHeader.LastChangeRecordPosition := LatestRecordIndex;
    DBHeader.LastChangeDateTime := PackDouble(LatestUpdateTime);
    //DBHeader.FirstSpace  := FirstSpace;
    DBHeader.UpdateDateTime := PackDouble(Now);
    FileSeek(fhandle, 0, 0);
    FileWrite(fhandle, DBHeader, sizeof(FDBHeader));
    FileSeek(fhandle, opos, 0);
    FileWrite(fhandle, rcd, sizeof(FDBRecord));
    FileSeek(fhandle, -sizeof(FDBRecord), 1);
    CurIndex := index;
    Updated  := True;
    Result   := True;
  end else
    Result := False;
end;

{ used with 'Find' }
function TFileDB.GetRecord(index: integer; var rcd: FDBRecord): integer;
var
  idx: integer;
begin
  idx := integer(MemIndexList.Objects[index]);
  if ReadRecord(idx, rcd) then
    Result := idx
  else
    Result := -1;
end;

{검증 안됨... 사용시 반드시 확인할 것}
function TFileDB.GetRecordDr(index: integer; var rcd: FDBRecord): boolean;
begin
  if (index >= 0) then ////and (index < MemIndexList.Count) then
    Result := ReadRecord(Index, rcd)
  else
    Result := False;
end;

function TFileDB.SetRecordTime(index: integer; settime: TDateTime): boolean;
begin
  Result := SetRecordDate(integer(MemIndexList.Objects[index]), settime);
end;

 { used with 'Find' }
 { SetRecord는 추가의 의미로는 사용해서는 안된다. }
 { Key는 바뀔 수 없다. }
function TFileDB.SetRecord(index: integer; rcd: FDBRecord): boolean;
begin
  Result := False;
  if (index < 0) or (index >= MemIndexList.Count) then
    exit;
   {**보류 i := MemIndexList.Find (rcd.Key);
   if i >= 0 then begin
      if i <> index then begin
         Result := FALSE;
         exit;
      end;
   end;**}

   {flag := TRUE;
   if ReadRecord (Integer (MemIndexList.Objects[index]), orcd) then begin
      if rcd.Block.DBHuman.Abilitys.Level = orcd.Block.DBHuman.Abilitys.Level then
         flag := FALSE;
   end;}
  if WriteRecord(integer(MemIndexList.Objects[index]), rcd, False) then begin
    Result := True;
    ///MemIndexList[index] := rcd.Key; <= 키는 바뀔 수 없다.
      {if flag then
         with FIndex do begin
            try
               if OpenWr then begin
                  UpdateIndex (rcd.Key, Integer (MemIndexList.Objects[index]), rcd.Block.DBHuman.Abilitys.Level);
               end;
            finally
               Close;
            end;
         end;}
  end else begin
  end;
end;

 { 반드시 추가의 의미로만 사용된다. }
 { 같은 Key로 등록할 수 없다. }
function TFileDB.AddRecord(rcd: FDBRecord): boolean;
var
  i:      integer;
  rcdpos: integer;
  oldheader: FDBHeader;
begin
  if MemIndexList.FFind(rcd.Key) >= 0 then begin
    Result := False;
    exit;
  end;
  oldheader := DBHeader;
   {if FirstSpace = -1 then begin
      rcdpos := DBHeader.MaxCount;
      DBHeader.MaxCount := DBHeader.MaxCount + 1;
   end else begin
      //가장 가까운 빈 공간을 찾는다.
      rcdpos := FirstSpace;
   end; }
  if BlankList.Count > 0 then begin
    rcdpos := integer(BlankList[0]);
    BlankList.Delete(0);
  end else begin
    rcdpos := DBHeader.MaxCount;
    DBHeader.MaxCount := DBHeader.MaxCount + 1;
  end;

  if WriteRecord(rcdpos, rcd, True) then begin
    MemIndexList.QAddObject(rcd.Key, TObject(rcdpos));
      {with FIndex do begin
         try
            if OpenWr then begin
               AddIndex (rcd.Key, rcdpos, rcd.Block.DBHuman.Abilitys.Level);
            end;
         finally
            Close;
         end;
      end;}
    Result := True;
  end else begin
    DBHeader := oldheader;
    Result   := False;
  end;
end;

function TFileDB.Find(uname: string): integer;
  {find by name only/find from index table}
begin
  Result := MemIndexList.FFind(uname);
end;

function TFileDB.FindLike(uname: string; flist: TStrings): integer; {found count}
var
  i: integer;
begin
  Result := -1;
  for i := 0 to MemIndexList.Count - 1 do begin
    if CompareLStr(MemIndexList[i], uname, Length(uname)) then begin
      flist.AddObject(MemIndexList[i], MemIndexList.Objects[i]);
    end;
  end;
  Result := flist.Count;
end;

function TFileDB.FindRecord(uname: string; var rcd: FDBRecord): boolean;
var
  i, index: integer;
begin
  Result := False;
  i      := MemIndexList.FFind(uname);
  if i >= 0 then begin
    index  := integer(MemIndexList.Objects[i]);
    Result := ReadRecord(index, rcd);
  end;
end;

function TFileDB.GetDBUpdateDateTime(dbname: string): TDateTime;
var
  fh:  integer;
  header: FDBHeader;
begin
  Result := 0;
  fh     := FileOpen(dbname, fmOpenRead or fmShareDenyNone);
  try
    if fh > 0 then begin
      if FileRead(fh, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
        Result := SolveDouble(header.UpdateDateTime);
      end;
    end;
  finally
    FileClose(fh);
  end;
end;

procedure TFileDB.UpdateDBTime(dbname: string);
var
  fh:  integer;
  header: FDBHeader;
begin
  fh := FileOpen(dbname, fmOpenReadWrite or fmShareDenyNone);
  try
    if fh > 0 then begin
      if FileRead(fh, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
        header.UpdateDateTime := PackDouble(Now);
        FileSeek(fh, 0, 0);
        FileWrite(fh, header, sizeof(FDBHeader));
      end;
    end;
  finally
    FileClose(fh);
  end;
end;

function TFileDB.DBSaveAs(dbname, targname: string; backuptime: integer): boolean;
var
  utime: TDateTime;
begin
  Result := False;
  if (DBFileName <> targname) and FileExists(dbname) then begin
    if FileExists(targname) then begin
      utime := GetDBUpdateDateTime(targname);
      if TimeIsOut(utime, backuptime, 0) then begin
        //try
        //   LockDB;
        FileCopyEx(dbname, targname);
        //finally
        //   UnlockDB;
        //end;
        UpdateDBTime(targname);
        Result := True;
      end;
    end else begin
      //try
      //   LockDB;
      FileCopyEx(dbname, targname);
      //finally
      //   UnlockDB;
      //end;
      UpdateDBTime(targname);
      Result := True;
    end;
  end;
end;

function TFileDB.GetRcdFromFile(dbfile, uname: string; idx: integer;
  var rcd: FDBRecord): boolean;
var
  i:    integer;
  head: FDBHeader;
  temp: FDBTemp;
begin
  Result := False;
  if dbfile = DBFileName then
    exit;
  fhandle := FileOpen(dbfile, fmOpenRead or fmShareDenyNone);
  if fhandle > 0 then begin
    Result := True;
    if FileRead(fhandle, head, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
      if idx < head.MaxCount then begin
        idx := idx - 1;
        if idx < 0 then
          idx := 0;
      end;
      for i := idx to idx + 2 do begin
        if FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FDBRecord) * i, 0) <>
          -1 then begin
          if FileRead(fhandle, temp, sizeof(FDBTemp)) = sizeof(FDBTemp) then begin
            if temp.Key = uname then begin
              FileSeek(fhandle, sizeof(FDBHeader) + sizeof(FDBRecord) * i, 0);
              FileRead(fhandle, rcd, sizeof(FDBRecord));
              Result := True;
              break;
            end;
          end;
        end;
      end;

    end;
  end;
end;


initialization
  begin
    InitializeCriticalSection(CSDBLock);
  end;

end.
