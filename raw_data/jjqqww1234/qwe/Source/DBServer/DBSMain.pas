unit DBSMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ScktComp, Grobal2, Edcode, mudutil, HUtil32, DBTables,
  DB, MfdbDef, IniFiles, HumDb, FeeDb, Buttons, FileCtrl;

const
  BoKoreaVersion = False;
  BoChinaVersion = False; //TRUE;

  FDBDir: string     = '\MirData\FDB\';
  FHumDBDir: string  = '\MirData\FDB\';
  FFeeDBDir: string  = '\MirData\FDB\';
  FDBBackupDir: string = '\MirData\FDB\';
  ConnectDir: string = '\MirData\Connects\';
  LogDir: string     = '\MirData\Log\';
  LogBaseDir: string = 'Log\';

  DEFBLOCKSIZE = 16;
  INC_HEALTH_VALUE = -1000;
  INC_SPELL_VALUE = -1000;
  INC_SPOWER_VALUE = -100000;
  INC_MPOWER_VALUE = -100000;
  INC_SPEED_VALUE = -500000;
  INC_DEFENCE_VALUE = -500000;
  CACHECOUNT = 100;


type
  TFeedHeader = record
    Desc:     string[30];
    RecCount: integer;
    Temp:     string[20];
  end;
  PTFeedHeader = ^TFeedHeader;

  TFeedInfo = record
    Index:  integer;
    FeedId: string[16];  //main key
    ChrName: string[20];
    EntryDate: string[10];
    EntryCount: integer;
    EntryOnce: word; //하나의 IP에서 접속수
    RealName: string[20];
    PersonId: string[15];
    Addr:   string[20];
    FeeDay: string[16];
    FeeMan: string[20];
    Bad:    string[8];
    Etc:    string[10];
  end;
  PTFeedInfo = ^TFeedInfo;

  TUserInfo = record
    SHandle:   integer;
    SocData:   string;
    Connected: boolean;
    ReceiveFinish: boolean;
    USocket:   TCustomWinSocket;
  end;
  PTUserInfo = ^TUserInfo;

  TUserIdInfo = record
    UsrId:      string[12];
    ChrName:    string[12];
    Certification: integer;   // 인증 번호
    ServerSocket: TCustomWinSocket;
    RunConnect: boolean;      // RunServer에 실행중
    ServerIndex: integer;     // 서버 번호
    Connecting: boolean;      // RunServer에 접속중
    OnUseCount: byte;
    OpenTime:   integer;    // 접속 시작 시간     time out 30 sec
    DeathStart: integer;
    DoDeath:    boolean;
  end;
  PTUserIDInfo = ^TUserIDInfo;

  TFrmDBSrv = class(TForm)
    ServerSocket1: TServerSocket;
    Timer1:     TTimer;
    AniTimer:   TTimer;
    StartTimer: TTimer;
    Timer2:     TTimer;
    Memo1:      TMemo;
    Panel1:     TPanel;
    Label1:     TLabel;
    Label3:     TLabel;
    Label4:     TLabel;
    LbAutoClean: TLabel;
    Panel2:     TPanel;
    BtnUserDBTool: TSpeedButton;
    LbTransCount: TLabel;
    Label2:     TLabel;
    Label5:     TLabel;
    Label6:     TLabel;
    LbUserCount: TLabel;
    BtnReloadAddr: TButton;
    BtnEditAddrs: TButton;
    Label8:     TLabel;
    Label9:     TLabel;
    Label10:    TLabel;
    Label11:    TLabel;
    CkViewHackMsg: TCheckBox;
    procedure ServerSocket1ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure ServerSocket1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure AniTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure BtnUserDBToolClick(Sender: TObject);
    procedure BtnReloadAddrClick(Sender: TObject);
    procedure BtnEditAddrsClick(Sender: TObject);
    procedure CkViewHackMsgClick(Sender: TObject);
  private
    AniCount: integer;
    Def:      TDefaultMessage;
    MagicNumber: integer;
    transcount: integer;
    CurCertify: string;
    procedure SendSocket(usock: TCustomWinSocket; str: string);
    function MakeDefaultMsg(msg: word; llong: integer;
      atag, nseries: word): TDefaultMessage;
    procedure DecodeMessagePacket(Data: string; datalen: integer;
      usock: TCustomWinSocket);
    function ConvertDateTime: string;
    function GetCertificationNumber: integer;
    function AddUserId(uid: string): integer;
    procedure EmergencyServerClosed(usock: TCustomWinSocket);
    procedure LoginCloseUserId(uid: string);
    procedure RunCloseUserId(uid: string);
    procedure PrepareRunConnect(uid, chrname: string);
    procedure DecodeSocData(pu: PTUserInfo);
  public
    FDBloading: boolean;
    UserList:   TList;
    UserIdList: TList;
    function LoadHumanRcd(uname: string; var rcd: FDBRecord): boolean;
    //function  CreateNewFDB (uname, usex: string; uface: integer): Boolean;
    procedure GetLoadHumanRcd(body: string; usock: TCustomWinSocket);
    procedure GetSaveHumanRcd(certify: integer; body: string; usock: TCustomWinSocket);
    procedure GetSaveAndChange(certify: integer; body: string; usock: TCustomWinSocket);
    //procedure GetLoginCloseUser (body: string; usock: TCustomWinSocket);
    //procedure GetRunCloseUser (body: string; usock: TCustomWinSocket);
    //procedure GetQueryChr (body: string; usock: TCustomWinSocket);
    //procedure GetNewChr (body: string; usock: TCustomWinSocket);
    procedure GetGetOtherNames(body: string; usock: TCustomWinSocket);
    //procedure GetIsValidUser (body: string; usock: TCustomWinSocket);
    //procedure GetIsValidUserWithId (body: string; usock: TCustomWinSocket);
    //procedure GetDelChr (body: string; usock: TCustomWinSocket);
    function CopyFDB(Source, target: string): boolean;
    function CopyFDB2(Source, target, withid: string): boolean;
    //procedure GetChangeServer (body: string; certify: integer; usock: TCustomWinSocket);
    procedure EraseHumDB(uname: string);
    procedure SaveDBSrvINI;
  end;


procedure WriteLog(str: string);
procedure AddLog(str: string);


var
  FrmDBSrv: TFrmDBSrv;
  FDB:      TFileDB;
  FHumDB:   TFileHumDB;
  //  FFeeDB: TFileFeeDB;
  CSLocalDB: TRTLCriticalSection;
  ReceiveCount, DecodeCount, SendCount: integer;
  ErrorCount: integer;
  FailCount: integer;
  AutoClean: boolean;
  ServerName: string;
  BoEnableNewChar: boolean;

  HackCountQueryChr:    integer;
  HackCountNewChr:      integer;
  HackCountDelChr:      integer;
  HackCountSelChr:      integer;
  HackCountErrorPacket1: integer;
  HackCountErrorPacket2: integer;
  HackCountErrorPacket3: integer;
  HackCountErrorPacket4: integer;
  HackCountErrorPacket5: integer;
  HackCountHeavyPacket: integer;



implementation

uses FDBexpl, FIDHum, FeeUtil, UsrSoc, IDSocCli, AddrEdit;

{$R *.DFM}


{--------------------------------------------------------------------------}


procedure WriteLog(str: string);

  function IntTo_Str(val: integer): string;
  begin
    if val < 10 then
      Result := '0' + IntToStr(val)
    else
      Result := IntToStr(val);
  end;

var
  ayear, amon, aday, ahour, amin, asec, amsec: word;
  dirname, flname: string;
  dir256: array[0..255] of char;
  f:      TextFile;
  i:      integer;
begin
  if str = '' then
    exit;

  try
    DecodeDate(Date, ayear, amon, aday);
    DecodeTime(Time, ahour, amin, asec, amsec);
    dirname := LogBaseDir + IntToStr(ayear) + '-' + IntTo_Str(amon);
    if not DirectoryExists(LogBaseDir) then begin
      StrPCopy(dir256, LogBaseDir);
      CreateDirectory(@dir256, nil);
    end;
    if not DirectoryExists(dirname) then begin
      StrPCopy(dir256, dirname);
      CreateDirectory(@dir256, nil);
    end;
    flname := dirname + '\' + IntToStr(amon) + '-' + IntTo_Str(aday) + '.txt';

    AssignFile(f, flname);
    if not FileExists(flname) then
      Rewrite(f)
    else
      Append(f);

    WriteLn(f, str);

    CloseFile(f);
  except
  end;
end;

procedure AddLog(str: string);
begin
  str := str + ' ' + TimeToStr(Time);
  WriteLog(str);
  FrmDbSrv.Memo1.Lines.Add(str);
end;

procedure TFrmDBSrv.FormCreate(Sender: TObject);
var
  ini: TIniFile;
  str: string;
begin
  FDBloading := True;
  Label4.Caption := '';
  LbAutoClean.Caption := '-/-';
  FDB    := nil;
  FHumDB := nil;
  //   FFeeDB := nil;

  ini := TIniFile.Create('.\dbsrc.ini');
  if ini <> nil then begin
    FDBDir     := ini.ReadString('DB', 'dir', FDBDir);
    FHumDBDir  := ini.ReadString('DB', 'HumDir', FHumDBDir);
    FFeeDBDir  := ini.ReadString('DB', 'FeeDir', FFeeDBDir);
    FDBBackupDir := ini.ReadString('DB', 'backup', FDBBackupDir);
    ConnectDir := ini.ReadString('DB', 'ConnectDir', ConnectDir);
    LogDir     := ini.ReadString('DB', 'LogDir', LogDir);
    ServerSocket1.Port := ini.ReadInteger('Setup', 'Port', 6000);
    CkViewHackMsg.Checked := ini.ReadBool('Setup', 'ViewHackMsg', False);
    ServerName := ini.ReadString('Setup', 'ServerName', 'DB');

    BoEnableNewChar := ini.ReadBool('Setup', 'EnableNewChar', True);

    ini.Free;
  end;

  InitializeCriticalSection(CSLocalDB);
  UserList     := TList.Create;
  UserIDList   := TList.Create;
  Label5.Caption := 'FDB: ' + FDBDir + 'Mir.DB,  ' + 'Backup: ' + FDBBackupDir;
  AniCount     := 0;
  ServerSocket1.Active := True;
  ReceiveCount := 0;
  DecodeCount  := 0;
  SendCount    := 0;
  ErrorCount   := 0;
  FailCount    := 0;
  MagicNumber  := 2;

  transcount      := 0;
  HackCountQueryChr := 0;
  HackCountNewChr := 0;
  HackCountDelChr := 0;
  HackCountSelChr := 0;
  HackCountErrorPacket1 := 0;
  HackCountErrorPacket2 := 0;
  HackCountErrorPacket3 := 0;
  HackCountErrorPacket4 := 0;
  HackCountErrorPacket5 := 0;

end;

procedure TFrmDBSrv.SaveDBSrvINI;
var
  ini: TIniFile;
begin
  BoEnableNewChar := FrmFDBExplore.CkEnableMakeNewChar.Checked;
  ini := TIniFile.Create('.\dbsrc.ini');
  if ini <> nil then begin
    ini.WriteBool('Setup', 'EnableNewChar', BoEnableNewChar);
    ini.Free;
  end;
end;


procedure TFrmDBSrv.FormShow(Sender: TObject);
begin
  StartTimer.Enabled := True;
end;

procedure TFrmDBSrv.StartTimerTimer(Sender: TObject);
begin
  StartTimer.Enabled := False;
  FDBloading := True;
  //   FFeeDB := TFileFeeDB.Create (FFeeDBDir + 'Fee.DB');
  FHumDB := TFileHumDB.Create(FHumDBDIR + 'Hum.DB');
  FDB := TFileDB.Create(FDBDIR + 'Mir.DB');
  FDBloading := False;
  AutoClean := True;
  Label4.Caption := '';
  FrmIDSoc.Initialize;
  AddLog('Server started..');
end;

procedure TFrmDBSrv.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  if FDB <> nil then
    FDB.Free;
  if FHumDB <> nil then
    FHumDB.Free;
  //   if FFeeDB <> nil then FFeeDB.Free;
  for i := 0 to UserList.Count - 1 do
    Dispose(UserList[i]);
  UserList.Free;
  for i := 0 to UserIdList.Count - 1 do
    Dispose(UserIdList[i]);
  UserIdList.Free;
end;


procedure TFrmDBSrv.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  uinfo: PTUserInfo;
begin
  if not FDBLoading then begin
    New(uinfo);
    uinfo.Connected := True;
    uinfo.Shandle   := Socket.SocketHandle;
    uinfo.SocData   := '';
    uinfo.USocket   := Socket;
    UserList.Add(uinfo);
  end else begin
    Socket.Close;
  end;
end;

procedure TFrmDBSrv.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: integer;
begin
  for i := 0 to UserList.Count - 1 do
    if PTUserInfo(UserList[i]).SHandle = Socket.SocketHandle then begin
      Dispose(PTUserInfo(UserList[i]));
      UserList.Delete(i);
      EmergencyServerClosed(Socket);
      break;
    end;
end;

procedure TFrmDBSrv.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin
  ErrorCode := 0;
  ServerSocket1ClientDisconnect(self, Socket);
  Socket.Close;
end;

procedure TFrmDBSrv.ServerSocket1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  i:   integer;
  str: string;
  pu:  PTUserInfo;
begin
  for i := 0 to UserList.Count - 1 do
    if PTUserInfo(UserList[i]).SHandle = Socket.SocketHandle then begin
      str := Socket.ReceiveText;
      Inc(ReceiveCount);
      if str <> '' then begin
        pu := PTUserInfo(UserList[i]);
        pu.SocData := pu.SocData + str;
        if pos('!', str) >= 1 then begin
          DecodeSocData(pu);
          Inc(DecodeCount);
          Inc(transcount);
        end else begin //불량 패킷 공격에 대응, 80K 초과는 초기화
          if Length(pu.SocData) > 81920 then begin
            pu.SocData := '';
            Inc(HackCountHeavyPacket);
          end;
        end;
      end;
      break;
    end;
end;

procedure TFrmDBSrv.DecodeSocData(pu: PTUserInfo);
var
  cc:     string;
  w1, w2: word;
  i, len, v: integer;
  str, Data, chkstr, certify: string;
  flag:   boolean;
begin
  if FDBLoading then
    exit;
  try
    flag := False;
    str  := pu.SocData;
    pu.SocData := '';
    Data := '';
    str  := ArrestStringEx(str, '#', '!', Data);
    if Data <> '' then begin
      Data := GetValidStr3(Data, certify, ['/']);
      len  := Length(Data);
      if (len >= DEFBLOCKSIZE) and (certify <> '') then begin
        w1 := Str_ToInt(certify, 0) xor $aa;
        w2 := word(len);
        v  := MakeLong(w1, w2);
        cc := EncodeBuffer(@v, sizeof(integer));
        CurCertify := certify;
        if CompareBackLStr(Data, cc, Length(cc)) then begin
          DecodeMessagePacket(Data, len, pu.USocket);
          flag := True;
        end;
      end;
    end;
    if str <> '' then begin
      Inc(ErrorCount);
      Label4.Caption := 'Error ' + IntToStr(ErrorCount);
    end;
    if not flag then begin
      Def := MakeDefaultMsg(DBR_FAIL, 0, 0, 0);  {Fail}
      SendSocket(pu.USocket, EncodeMessage(Def));
      Inc(ErrorCount);
      Label4.Caption := 'Error ' + IntToStr(ErrorCount);
    end;
  except
  end;
end;

{---------------------------------------------------------}

function TFrmDBSrv.GetCertificationNumber: integer;
begin
  Result := MagicNumber;
  Inc(MagicNumber);
end;

{---------------------------------------------------------}

function TFrmDBSrv.AddUserId(uid: string): integer;
var
  i:    integer;
  puid: PTUserIdInfo;
begin
  for i := 0 to UserIdList.Count - 1 do begin
    if PTUserIDInfo(UserIdList[i]).UsrId = uid then begin
      puid := PTUserIDInfo(UserIdList[i]);
      if puid.OnUseCount < 4 then begin                     //11-10 고스트 제거루틴
        puid.OnUseCount := puid.OnUseCount + 1;
        Result := 0; // fail
        exit;
      end else begin
        UserIdList.Delete(i);
        Dispose(puid);
        break;
      end;
      //PTUserIDInfo (UserIdList[i]).DoDeath := TRUE;
      //PTUserIDInfo (UserIdList[i]).DeathStart := GetCurrentTime;
    end;
  end;
  new(puid);
  puid.UsrId      := uid;
  puid.ChrName    := '';
  puid.Certification := GetCertificationNumber;
  puid.ServerSocket := nil;
  puid.RunConnect := False;
  puid.ServerIndex := -1;
  puid.Connecting := False;
  puid.OpenTime   := GetCurrentTime;
  puid.OnUseCount := 0;
  puid.DoDeath    := False;
  UserIdList.Add(puid);
  Result := puid.Certification;
end;

procedure TFrmDBSrv.EmergencyServerClosed(usock: TCustomWinSocket);
var
  i:   integer;
  pid: PTUserIDInfo;
begin
  i := 0;
  while True do begin
    if i >= UserIdList.Count then
      break;
    pid := PTUserIDInfo(UserIdList[i]);
    if pid.ServerSocket = usock then begin
      Dispose(pid);
      UserIdList.Delete(i);
    end else
      Inc(i);
  end;
end;

procedure TFrmDBSrv.LoginCloseUserId(uid: string);
var
  i:    integer;
  puid: PTUserIDInfo;
begin
  for i := 0 to UserIdList.Count - 1 do begin
    if PTUserIDInfo(UserIdList[i]).UsrId = uid then begin
      puid := PTUserIDInfo(UserIdList[i]);
      if (not puid.RunConnect) and (not puid.Connecting) then begin
        Dispose(puid);
        UserIdList.Delete(i);
      end;
      break;
    end;
  end;
end;

procedure TFrmDBSrv.RunCloseUserId(uid: string);
var
  i:    integer;
  puid: PTUserIDInfo;
begin
  for i := 0 to UserIdList.Count - 1 do begin
    if PTUserIDInfo(UserIdList[i]).UsrId = uid then begin
      if not PTUserIDInfo(UserIdList[i]).Connecting then begin
        puid := PTUserIDInfo(UserIdList[i]); //서버 이동중이 아니면..
        Dispose(puid);
        UserIdList.Delete(i);
      end;
      break;
    end;
  end;
end;

procedure TFrmDBSrv.PrepareRunConnect(uid, chrname: string);
var
  i:    integer;
  puid: PTUserIDInfo;
begin
  for i := 0 to UserIdList.Count - 1 do begin
    if PTUserIDInfo(UserIdList[i]).UsrId = uid then begin
      puid := PTUserIDInfo(UserIdList[i]);
      puid.ChrName := chrname;
      puid.Connecting := True;
      puid.OpenTime := GetCurrentTime;
      break;
    end;
  end;
end;


{---------------------------------------------------------}

procedure TFrmDBSrv.Timer1Timer(Sender: TObject);
var
  i: integer;
begin
  LbTransCount.Caption := IntToStr(transcount);
  transcount := 0;
  if UserList.Count > 0 then
    Label1.Caption := 'Connected...'
  else
    Label1.Caption := 'Disconnected !!';
  Label2.Caption := 'Connections ' + IntToStr(UserList.Count);
  LbUserCount.Caption := IntToStr(FrmUserSoc.UserCount);
  if FDBLoading then begin
    if (MaxFeeLoading > 0) and (not FeeLoaded) then begin
      Label4.Caption := '[1/4] ' + IntToStr(
        Round(CurFeeLoading / MaxFeeLoading * 100)) + '% ' +
        IntToStr(ValidFeeLoading) + '/' + IntToStr(MaxFeeLoading);
    end;
    if (MaxHumLoading > 0) and (not HumLoaded) then begin
      Label4.Caption := '[3/4] ' + IntToStr(
        Round(CurHumLoading / MaxHumLoading * 100)) + '% ' +
        IntToStr(ValidHumLoading) + '/' + IntToStr(MaxHumLoading);
    end;
    if (MaxLoading > 0) and (not MirLoaded) then begin
      Label4.Caption := '[4/4] ' + IntToStr(
        Round(CurLoading / MaxLoading * 100)) + '% ' +
        IntToStr(ValidLoading) + '/' + IntToStr(DeleteCount) + '/' +
        IntToStr(MaxLoading);
    end;
  end;
  //   Label7.Caption := 'R' + IntToStr(ReceiveCount) + ' D' + IntToStr(DecodeCount) + ' S' + IntToStr(SendCount);

  Label8.Caption  := 'H-QyChr=' + IntToStr(HackCountQueryChr);
  Label9.Caption  := 'H-NwChr=' + IntToStr(HackCountNewChr);
  Label10.Caption := 'H-DlChr=' + IntToStr(HackCountDelChr);
  Label11.Caption := 'Dubb-Sl=' + IntToStr(HackCountSelChr);

  if Memo1.Lines.Count > 5000 then begin
    Memo1.Lines.Clear;
  end;

end;

procedure TFrmDBSrv.Timer2Timer(Sender: TObject);
var
  i:    integer;
  puid: PTUserIdInfo;
begin
  i := 0;
  while True do begin
    if i >= UserIdList.Count then
      break;
    puid := PTUserIdInfo(UserIdList[i]);
      {if puid.DoDeath then begin
         if GetCurrentTime - puid.DeathStart > 5 * 1000 then begin
            Dispose (PTUserIdInfo (UserIdList[i]));
            UserIdList.Delete (i);
            continue;
         end;
      end;}
    if not puid.RunConnect then begin
      if puid.Connecting then begin  //서버 접속 지연/실패
        if GetCurrentTime - puid.OpenTime > 20 * 1000 then begin
          Dispose(PTUserIdInfo(UserIdList[i]));
          UserIdList.Delete(i);
          continue;
        end;
      end else begin  //비정상적 종료
        if GetCurrentTime - puid.OpenTime > 2 * 60 * 1000 then begin
          Dispose(PTUserIdInfo(UserIdList[i]));
          UserIdList.Delete(i);
          continue;
        end;
      end;
    end else if GetCurrentTime - puid.OpenTime > 60 * 40 * 1000 then begin
      Dispose(PTUserIdInfo(UserIdList[i]));
      UserIdList.Delete(i);
      continue;
    end;
    Inc(i);
  end;
end;


function TFrmDBSrv.ConvertDateTime: string;
var
  ayear, amonth, aday, ahour, amin, asec, amsec: word;
begin
  DecodeDate(Date, ayear, amonth, aday);
  DecodeTime(Time, ahour, amin, asec, amsec);
  Result := IntToStr(ayear) + '.' + IntToStr(amonth) + '.' +
    IntToStr(aday) + '.' + IntToStr(ahour);
end;


function TFrmDBSrv.MakeDefaultMsg(msg: word; llong: integer;
  atag, nseries: word): TDefaultMessage;
begin
  with Result do begin
    Ident  := msg;
    Recog  := llong;
    Tag    := atag;
    Series := nseries;
  end;
end;

procedure TFrmDBSrv.SendSocket(usock: TCustomWinSocket; str: string);
var
  cert: integer;
  len:  word;
  cc:   string;
begin
  Inc(SendCount);
  len  := Length(str) + 6;
  cert := MakeLong(Str_ToInt(CurCertify, 0) xor $aa, len);
  cc   := EncodeBuffer(@cert, sizeof(integer));
  usock.SendText('#' + CurCertify + '/' + str + cc + '!');
end;


function TFrmDBSrv.LoadHumanRcd(uname: string; var rcd: FDBRecord): boolean;
var
  idx: integer;
begin
  Result := False;
  with FDB do begin
    try
      if OpenRd then begin
        idx := Find(uname);
        if idx >= 0 then begin
          if GetRecord(idx, rcd) >= 0 then
            Result := True;
        end;
      end;
    finally
      Close;
    end;
  end;
end;

function TFrmDBSrv.CopyFDB(Source, target: string): boolean;
begin
  Result := CopyFDB2(Source, target, '');
end;

function TFrmDBSrv.CopyFDB2(Source, target, withid: string): boolean;
var
  idx:  integer;
  flag: boolean;
  rcd:  FDBRecord;
begin
  Result := False;
  flag   := False;
  with FDB do begin
    try
      if OpenWr then begin
        idx := Find(Source);
        if idx >= 0 then begin
          if GetRecord(idx, rcd) >= 0 then begin
            flag := True;
          end;
        end;
        if flag then begin
          idx := Find(target);
          if idx >= 0 then begin
            rcd.Key := target;
            rcd.Block.DBHuman.UserName := target;
            rcd.Block.DBHuman.UserId := withid;
            SetRecord(idx, rcd);
            Result := True;
          end;
        end;
      end;
    finally
      Close;
    end;
  end;
end;

(*
function TFrmDBSrv.CreateNewFDB (uname, usex: string; uface: integer): Boolean;
var
   idx: integer;
   rcd: FDBRecord;
begin
   Result := FALSE;
   FillChar (rcd, sizeof(FDBRecord), #0);
   with FDB do begin
      try
         if OpenWr then begin
            idx := Find (uname);
            if idx = -1 then begin
               rcd.Key := uname;
               AddRecord (rcd);
               Result := TRUE;
            end;
         end;
      finally
         Close;
      end;
   end;
end;   *)

procedure TFrmDBSrv.EraseHumDB(uname: string);
begin
  try
    if FHumDB.OpenWr then
      FHumDb.Delete(uname);
  finally
    FHumDb.Close;
  end;
end;

procedure TFrmDBSrv.GetLoadHumanRcd(body: string; usock: TCustomWinSocket);
var
  str, uid, uname, uip: string;
  rcd:    FDBRecord;
  i, idx, certify, rr: integer;
  puid:   PTUserIdInfo;
  lhuman: TLoadHuman;
begin
  DecodeBuffer(body, @lhuman, sizeof(TLoadHuman));
  uid     := lhuman.UsrId;
  uname   := lhuman.ChrName;
  uip     := lhuman.UsrAddr;
  certify := lhuman.CertifyCode;
  rr      := -1;
  if (uid <> '') and (uname <> '') then begin //and (certify <> 0) then begin
      {for i:=0 to UserIdList.Count-1 do begin
         puid := PTUserIdInfo (UserIdList[i]);
         if (puid.UsrId = uid) and (puid.Certification = certify) and (puid.Connecting) and (not puid.DoDeath) then begin
            puid.RunConnect := TRUE;
            puid.ServerSocket := usock;
            puid.Connecting := FALSE;
            rr := 1;
            break;
         end;
      end; }
    rr := 1;
  end;
  if rr = 1 then begin
    with FDB do begin
      try
        if OpenRd then begin
          idx := Find(uname);
          if idx >= 0 then begin
            if GetRecord(idx, rcd) < 0 then
              rr := -2;
          end else
            rr := -3;
        end else
          rr := -4;
      finally
        Close;
      end;
    end;
  end;

  if rr = 1 then begin
    Def := MakeDefaultMsg(DBR_LOADHUMANRCD, 1, 0, 1);
    SendSocket(usock, EncodeMessage(Def) + EncodeString(uname) +
      '/' + EncodeBuffer(@rcd, sizeof(FDBRecord)));
  end else begin
    Def := MakeDefaultMsg(DBR_LOADHUMANRCD, rr, 0, 0);
    SendSocket(usock, EncodeMessage(Def));
  end;
end;

procedure TFrmDBSrv.GetSaveHumanRcd(certify: integer; body: string;
  usock: TCustomWinSocket);
var
  i, idx: integer;
  str, uid, uname, scert: string;
  fail:   boolean;
  rcd:    FDBRecord;
  puser:  PTUserIdInfo;
begin
  str   := GetValidStr3(body, uid, ['/']);
  str   := GetValidStr3(str, uname, ['/']);
  uid   := DecodeString(uid);
  uname := DecodeString(uname);
  fail  := False;

  FillChar(rcd.Block, sizeof(rcd.Block), #0);
  if Length(str) = UpInt(sizeof(FDBRecord) * 4 / 3) then
    DecodeBuffer(str, @rcd, sizeof(FDBRecord))
  else
    fail := True;
  if uname = '' then
    fail := True;

  if not fail then begin
    fail := True;
    with FDB do begin
      try
        if OpenWr then begin
          idx := Find(uname);
          if idx < 0 then begin
            rcd.Key := uname;
            AddRecord(rcd);
            idx := Find(uname);
          end;
          if idx >= 0 then begin
            rcd.Key := uname;
            SetRecord(idx, rcd);
            fail := False;
          end;
        end;
      finally
        Close;
      end;
    end;
  end;
  if not fail then begin
    for i := 0 to UserIdList.Count - 1 do begin
      puser := PTUserIdInfo(UserIdList[i]);
      if (puser.ChrName = uname) and (puser.Certification = certify) then begin
        puser.OpenTime := GetCurrentTime; //Timeout 연장
      end;
    end;
    Def := MakeDefaultMsg(DBR_SAVEHUMANRCD, 1, 0, 0); {SUCCESS}
    SendSocket(usock, EncodeMessage(Def));
  end else begin
    Def := MakeDefaultMsg(DBR_SAVEHUMANRCD, 0, 0, 0); {ABORT}
    SendSocket(usock, EncodeMessage(Def));
  end;
end;

procedure TFrmDBSrv.GetSaveAndChange(certify: integer; body: string;
  usock: TCustomWinSocket);
var
  i:    integer;
  str, uid, uname: string;
  puid: PTUserIdInfo;
begin
  str   := GetValidStr3(body, uid, ['/']);
  str   := GetValidStr3(str, uname, ['/']);
  uname := DecodeString(uname);
  uid   := DecodeString(uid);
  for i := 0 to UserIdList.Count - 1 do begin
    puid := PTUserIdInfo(UserIdList[i]);
    if (puid.UsrId = uid) and (puid.Certification = certify) then begin
      puid.RunConnect   := False;
      puid.ServerSocket := usock;
      puid.Connecting   := True;
      puid.OpenTime     := GetCurrentTime;
      break;
    end;
  end;
  GetSaveHumanRcd(certify, body, usock);
end;


{procedure TFrmDBSrv.GetLoginCloseUser (body: string; usock: TCustomWinSocket);
var
   uid: string;
begin
   uid := DecodeString (body);
   LoginCloseUserId (uid);
   Def := MakeDefaultMsg (DBR_NONE, 0, 0, 0);
   SendSocket (usock, EncodeMessage (Def));
end;}

{procedure TFrmDBSrv.GetRunCloseUser (body: string; usock: TCustomWinSocket);
var
   str, uid, scert: string;
   i, certify: integer;
   puid: PTUserIdInfo;
begin
   str := DecodeString (body);
   if pos ('/', str) > 0 then begin
      scert := GetValidStr3 (str, uid, ['/']);
      certify := Str_ToInt (scert, 0);
   end else begin
      uid := str;
      certify := 0;
   end;
   if certify > 0 then begin // 다른 서버로 이동중...
      for i:=0 to UserIdList.Count-1 do begin
         puid := PTUserIdInfo (UserIdList[i]);
         if (puid.UsrId = uid) and (puid.Certification = certify) then begin
            puid.RunConnect := FALSE;
            puid.ServerSocket := usock;
            puid.Connecting := TRUE;
            puid.OpenTime := GetCurrentTime;
            break;
         end;
      end;
   end;
   RunCloseUserId (uid);
   Def := MakeDefaultMsg (DBR_NONE, 0, 0, 0);
   SendSocket (usock, EncodeMessage (Def));
end; }

{procedure TFrmDBSrv.GetQueryChr (body: string; usock: TCustomWinSocket);
var
   i, idx: integer;
   usrid, rstr, uname, sface, slevel, sdata, sexname: string;
   sex: byte;
   fail: Boolean;
   rcd: FDBRecord;
   humrcd: FHumRcd;
   count: integer;
   strlist: TStringList;
begin
   usrid := DecodeString (body);
   fail := FALSE;
   sdata := '';
   count := 0;
   strlist := TStringList.Create;
   with FHumDb do begin
      try
         if OpenRd then begin
            if FindUserId (usrid, strlist) > 0 then begin
               try
                  if FDB.OpenRd then begin
                     for i:=0 to strlist.Count-1 do begin
                        idx := PTIdInfo (strlist.Objects[i]).ridx;
                        if FHumDb.GetRecordDr (idx, humrcd) then begin
                           if not humrcd.Block.Delete then begin
                              uname := PTIdInfo (strlist.Objects[i]).uname;
                              idx := FDB.Find (uname);
                              if (idx >= 0) and (count < 3) then begin
                                 if FDB.GetRecord (idx, rcd) >= 0 then begin
                                    sex  := rcd.Block.DBHuman.Sex;
                                    sface := IntToStr(rcd.Block.DBHuman.Hair);
                                    slevel := IntToStr(rcd.Block.DBHuman.Abil.Level);
                                    sdata := sdata + uname + '/' + sface + '/' + slevel + '/' + IntToStr(sex) + '/';
                                    Inc (count);
                                 end;
                              end;
                           end;
                        end;
                     end;
                  end;
               finally
                  FDB.Close;
               end;
            end;
         end;
      finally
         Close;
      end;
   end;
   strlist.Free;

   Def := MakeDefaultMsg (DBR_QUERYCHR, count, 0, 1);  //OK
   SendSocket (usock, EncodeMessage (Def) + EncodeString(sdata));
end; }
        (*
procedure TFrmDBSrv.GetNewChr (body: string; usock: TCustomWinSocket);
var
   str, uid, uname, sface, sex: string;
   i, error : integer;
   fhum: FHumRcd;
begin
   error := -1;
   str := DecodeString (body);
   str := GetValidStr3 (str, uid, ['/']);
   str := GetValidStr3 (str, uname, ['/']);
   sex := GetValidStr3 (str, sface, ['/']);
   uname := Trim (uname);
   if Length (uname) < 4 then error := 0;
   if not CheckValidUserName (uname) then error := 0;
   for i:=1 to Length(uname) do
      if (uname[i] = '/') or (uname[i] = '@') or (uname[i] = '?') or
         (uname[i] = '''') or (uname[i] = '"') or (uname[i] = '\') or
         (uname[i] = '.') or (uname[i] = ',') or (uname[i] = ':') or
         (uname[i] = ';') or (uname[i] = '`') or (uname[i] = '~') or
         (uname[i] = '!') or (uname[i] = '#') or (uname[i] = '$') or
         (uname[i] = '%') or (uname[i] = '^') or (uname[i] = '&') or
         (uname[i] = '*') or (uname[i] = '(') or (uname[i] = ')') or
         (uname[i] = '-') or (uname[i] = '_') or (uname[i] = '+') or
         (uname[i] = '=') or (uname[i] = '|') or (uname[i] = '[') or
         (uname[i] = '{') or (uname[i] = ']') or (uname[i] = '}') then
         error := 0; //invalid name

   try
      FDB.LockDB;
      if FDB.Find (uname) >= 0 then error := 2; // already exists
   finally
      FDB.UnlockDB;
   end;
   FillChar (fhum, sizeof(FHumRcd), #0);
   if error = -1 then begin
      with FHumDB do begin
         try
            if OpenWr then begin
               if FindUserIdCount (uid) < 3 then begin
                  fhum.Block.ChrName := uname;
                  fhum.Block.UserId := uid;
                  fhum.Block.Delete := FALSE;
                  fhum.Block.Mark := 0;
                  fhum.Key := fhum.Block.ChrName;
                  if fhum.Key <> '' then begin
                     if not AddRecord (fhum) then
                        error := 2; //already exists
                  end;
               end else
                  error := 3;
            end;
         finally
            Close;
         end;
      end;
      if error = -1 then begin
         if CreateNewFDB (uname, sex, Str_ToInt(sface, 0)) then
            error := 1 // success
         else begin
            FrmDbSrv.EraseHumDb (uname);   //fail
            error := 4;
         end;
      end;
   end;

   Def := MakeDefaultMsg (DBR_NEWCHR, error, 0, 0);  {OK}
   SendSocket (usock, EncodeMessage (Def));
end; *)

procedure TFrmDBSrv.GetGetOtherNames(body: string; usock: TCustomWinSocket);
begin
  ;
end;

{procedure TFrmDBSrv.GetIsValidUser (body: string; usock: TCustomWinSocket);
var
   uname: string;
   fail: Boolean;
   idx: integer;
begin
   fail := TRUE;
   uname := DecodeString (body);
   with FHumDB do begin
      try
         LockDB;
         idx := Find (uname);
         if idx >= 0 then begin
            fail := FALSE;
         end;
      finally
         UnlockDB;
      end;
   end;
   if not fail then
      Def := MakeDefaultMsg (DBR_ISVALIDUSER, 1, 0, 0)  //OK
   else Def := MakeDefaultMsg (DBR_ISVALIDUSER, 0, 0, 0);  //Fail
   SendSocket (usock, EncodeMessage (Def));
end; }

{procedure TFrmDBSrv.GetIsValidUserWithId (body: string; usock: TCustomWinSocket);
begin
   ;
end;
}
{procedure TFrmDBSrv.GetDelChr (body: string; usock: TCustomWinSocket);
var
   str, usrid, usrname: string;
   year, mon, day: word;
   idx: integer;
   fail: Boolean;
   humrcd: FHumRcd;
begin
   fail := TRUE;
   str := DecodeString (body);
   usrname := GetValidStr3 (str, usrid, ['/']);
   with FHumDB do begin
      try
         if OpenWr then begin
            idx := Find(usrname);
            if idx >= 0 then begin
               GetRecord (idx, humrcd);
               humrcd.Block.Delete := TRUE;
               humrcd.Block.DeleteDate := PackDouble(Date);
               SetRecord (idx, humrcd);
               fail := FALSE;
            end;
         end;
      finally
         Close;
      end;
   end;
   if not fail then
      Def := MakeDefaultMsg (DBR_DELCHR, 1, 0, 0)  //OK
   else Def := MakeDefaultMsg (DBR_DELCHR, 0, 0, 0);  //Fail
   SendSocket (usock, EncodeMessage (Def));
end; }

{procedure TFrmDBSrv.GetChangeServer (body: string; certify: integer; usock: TCustomWinSocket);
var
   i: integer;
   uid, chrname, str, data: string;
   puid: PTUserIdInfo;
begin
   data := DecodeString (body);
   data := GetValidStr3 (data, uid, ['/']);
   chrname := data;
   for i:=0 to UserIdList.Count-1 do begin
      puid := PTUserIdInfo (UserIdList[i]);
      if (puid.UsrId = uid) and (puid.Certification = certify) then begin
         puid.RunConnect := FALSE;
         puid.ServerSocket := usock;
         puid.Connecting := TRUE;
         puid.OpenTime := GetCurrentTime;
         break;
      end;
   end;
   Def := MakeDefaultMsg (DBR_NONE, 0, 0, 0);
   SendSocket (usock, EncodeMessage (Def));
end;}

{--------------------------------------------------------------------------}


procedure TFrmDBSrv.DecodeMessagePacket(Data: string; datalen: integer;
  usock: TCustomWinSocket);
var
  msg: TDefaultMessage;
  head, body, desc: string;
begin
  if datalen = DEFBLOCKSIZE then begin
    head := Data;
    body := '';
  end else begin
    head := Copy(Data, 1, DEFBLOCKSIZE);
    body := Copy(Data, DEFBLOCKSIZE + 1, Length(Data) - DEFBLOCKSIZE - 6);
  end;
  msg := DecodeMessage(head);

  case msg.Ident of
    DB_LOADHUMANRCD:  // certification code 를 함께 보낸다.
    begin
      GetLoadHumanRcd(body, usock);
    end;

    DB_SAVEHUMANRCD: begin
      GetSaveHumanRcd(msg.Recog, body, usock);
    end;

    DB_SAVEANDCHANGE: begin
      GetSaveAndChange(msg.Recog, body, usock);
    end;
     {
      DB_LOGINCLOSEUSER:
         begin
            GetLoginCloseUser (body, usock);
         end;

      DB_RUNCLOSEUSER:
         begin
            GetRunCloseUser (body, usock);
         end;

      DB_QUERYCHR:
         begin
            GetQueryChr (body, usock);
         end;

      DB_NEWCHR:
         begin
            GetNewChr (body, usock);
         end;

      DB_ISVALIDUSER:
         begin
            GetIsValidUser (body, usock);
         end;

      DB_DELCHR:
         begin
            GetDelChr (body, usock);
         end;

      DB_GETSERVER:
         begin
         end;

      DB_CHANGESERVER:
         begin
            GetChangeServer (body, msg.recog, usock);
         end;   }

    else begin
      Def := MakeDefaultMsg(DBR_FAIL, 0, 0, 0);  {Fail}
      SendSocket(usock, EncodeMessage(Def));
      Inc(FailCount);
      Memo1.Lines.Add('Fail ' + IntToStr(FailCount));
    end;
  end;
end;



procedure TFrmDBSrv.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if Sender <> nil then begin
    if mrYes = MessageDlg('Do you want to close DBServer?', mtWarning,
      mbYesNoCancel, 0) then begin
      CanClose := True;
      ServerSocket1.Active := False;
      AddLog('Server closed...');
    end else
      CanClose := False;
  end;
end;

procedure TFrmDBSrv.AniTimerTimer(Sender: TObject);
begin
  if AniCount > 7 then
    AniCount := 0
  else
    Inc(AniCount);
  case AniCount of
    0: Label3.Caption := ' |';
    1: Label3.Caption := '/';
    2: Label3.Caption := '--';
    3: Label3.Caption := '\';
    4: Label3.Caption := ' |';
    5: Label3.Caption := '/';
    6: Label3.Caption := '--';
    7: Label3.Caption := '\';
  end;
end;


procedure TFrmDBSrv.BtnUserDBToolClick(Sender: TObject);
begin
  if not HumLoaded or not MirLoaded then
    exit;
  FrmIdHum.Show;
end;

procedure TFrmDBSrv.BtnReloadAddrClick(Sender: TObject);
begin
  FrmUserSoc.LoadAddrTables;
end;

procedure TFrmDBSrv.BtnEditAddrsClick(Sender: TObject);
begin
  FrmEditAddr.Execute;
end;

procedure TFrmDBSrv.CkViewHackMsgClick(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create('.\dbsrc.ini');
  if ini <> nil then begin
    ini.WriteBool('Setup', 'ViewHackMsg', CkViewHackMsg.Checked);
    ini.Free;
  end;
end;

end.
