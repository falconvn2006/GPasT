unit LMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp, ExtCtrls, StdCtrls, mudutil, HUtil32, EdCode, Grobal2, IniFiles,
  syncobjs, IDDb, Buttons, Grids, Parse;

const
  KoreanVersion = False; //TRUE;
  ChinaVersion  = False;

  FIdDBDir: string = '\MirData\FDB\';
  WebLogDir: string = 'D:\Share\';
  FeedIDListFile: string = '.\FeedIDList.txt';
  FeedIPListFile: string = '.\FeedIPList.txt';
  DEFBLOCKSIZE = 16;
  ADDRTABLE    = '.\!addrtable.txt';
  SETUPFILE    = '.\Logsrv.ini';
  CountLogDir: string = '.\CountLog\';
  MAX_PUBADDR  = 60;
  GATEBASEPORT = 5100;
  BoFreeGameMode: boolean = False;
  BoTestMode: boolean = False;
  BoEnableMakeID: boolean = True; //�⺻�����δ� ���̵� ��������

type
  TConnInfo = record
    UId:      string;
    UAddr:    string;
    ServerName: string;
    Certify:  integer;
    CertifyIP: boolean;
    FreeMode: boolean;
    OpenTime: longword;
    AccountCheckTime: longword;
    Closing:  boolean; //true�̸� �ߺ��������� ������. 30���� ��������
  end;
  PTConnInfo = ^TConnInfo;

  TRunGateInfo = record
    Addr:    string;
    Port:    integer;
    Enabled: boolean;
  end;

  TRAddr = record
    ServerName: string;
    Title:      string;
    RemoteAddr: string;
    PublicAddr: string;
    GIndex:     integer;
    PubGates:   array[0..9] of TRunGateInfo;
  end;

  TGateInfo = record
    GateSocket: TCustomWinSocket;
    RemotePublicAddr: string;
    SocData:    string;
    UserList:   TList;             // list of PTUserInfo
    ConnCheckTime: integer;        // ������� äũ �ð�
  end;
  PTGateInfo = ^TGateInfo;

  TConnState = (csIdPasswd, csTrySelChr, csSelChr, csTryRun, csRun);

  TUserInfo = record
    UserId:     string[10];
    UserAddr:   string[20];
    UserHandle: string;
    ClientVersion: integer;
    VersionAccept: boolean;
    Certification: integer;
    PayMode:    byte;           //���ݸ��  0:ü����, 1:����  2:�����̿���
    IDDay:      integer;
    IDHour:     integer;
    IPDay:      integer;
    IPHour:     integer;
    AccountMakeDate: TDateTime;
    SelServerOk: boolean;
    ConnState:  TConnState;
    CSocket:    TCustomWinSocket;
    SocData:    string;
    ConnectTime: longword;
    // ó�� ������ �ð�, �ٸ� ������ �Ű����� �ű� ó�� �ð�
    BoServerRun: boolean;        // ������ ������ ���� ����
    LatestCmdTime: longword;
  end;
  PTUserInfo = ^TUserInfo;


  TFrmMain = class(TForm)
    GSocket:    TServerSocket;
    ExecTimer:  TTimer;
    Panel1:     TPanel;
    Memo1:      TMemo;
    Timer1:     TTimer;
    DebugTimer: TTimer;
    StartTimer: TTimer;
    WebLogTimer: TTimer;
    BtnDump:    TSpeedButton;
    LogTimer:   TTimer;
    MonitorGrid: TStringGrid;
    Panel2:     TPanel;
    Label1:     TLabel;
    SpeedButton1: TSpeedButton;
    LbMasCount: TLabel;
    CkLogin:    TCheckBox;
    CbViewLog:  TCheckBox;
    BtnView:    TSpeedButton;
    CountLogTimer: TTimer;
    BtnShowServerUsers: TSpeedButton;
    MonitorTimer: TTimer;
    SpeedButton2: TSpeedButton;
    procedure GSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure GSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ExecTimerTimer(Sender: TObject);
    procedure Memo1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure DebugTimerTimer(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure WebLogTimerTimer(Sender: TObject);
    procedure BtnDumpClick(Sender: TObject);
    procedure LogTimerTimer(Sender: TObject);
    procedure ReloadFeedTimerTimer(Sender: TObject);
    procedure BtnViewClick(Sender: TObject);
    procedure CountLogTimerTimer(Sender: TObject);
    procedure BtnShowServerUsersClick(Sender: TObject);
    procedure MonitorTimerTimer(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    Def: TDefaultMessage;
    CurrentRemotePublicAddr: string;
    procedure LoadFeedList(bofast: boolean);
    procedure DecodeGateData(ginfo: PTGateInfo);
    procedure ReceiveCheckCode(asocket: TCustomWinSocket);
    procedure ReceiveOpenUser(uhandle, usraddr: string; ginfo: PTGateInfo);
    procedure ReceiveCloseUser(uhandle: string; ginfo: PTGateInfo);
    procedure ReceiveSendData(uhandle: string; ginfo: PTGateInfo; Data: string);
    function IsLockIP(ip: string): boolean;
    procedure LockIP(ip: string);
    function KickOffSocket(puser: PTUserInfo): boolean;
    procedure SendKickUser(Socket: TCustomWinSocket; uhandle: string);
    procedure DecodeUserData(puser: PTUserInfo);
    function DecodeLogMessages(Data: string; puser: PTUserInfo): boolean;
    procedure LoginGetIdPasswd(puser: PTUserInfo; body: string);
    procedure LoginGetSelectServer(puser: PTUserInfo; body: string);
    procedure LoginGetNewUser(puser: PTUserInfo; body: string);
    procedure LoginGetUpdateUser(puser: PTUserInfo; body: string);
    procedure LoginChangePasswd(puser: PTUserInfo; body: string);

    function IsDoubbleConnection(uid: string): boolean;
    procedure MarkCertListClose(uid: string);
    procedure CheckCertListTimeOuts;
    procedure CheckAccountExpire;
    procedure ApplyUserPrivateInfo(str: string);
    //procedure UpdateWebLogFile (flname: string);
    procedure AddCertify(uid, uaddr: string; cert: integer; ipmode, freemode: boolean);
    procedure ModifyCertify(cert: integer; svname: string; freemode: boolean);
    procedure DelCertify(cert: integer);
    function IsValidCertification(cert: integer): boolean;
  public
    GateList:   TList;    // list of PTGateInfo
    CertList:   TList;
    ServerNameList: TStringList;
    ClogList:   TStringList;
    FeedIDList: TQuickList;
    FeedIPList: TQuickList;
    LoadIPIDThread: TThreadParseList;

    function AlreadyUsing(uid: string): boolean;
    function CheckAccountAvailable(uid, uaddr: string): boolean;
    procedure CertifyCloseUser(uid: string; cert: integer);
    procedure WriteLog(cmd: string; ue: TUserEntryInfo; ua: TUserEntryAddInfo);
    procedure WriteConLog(cmd, uid, addr: string);
    procedure LoadServerNames;
    procedure MakeApply_ID_List(idlist: TQuickList);
    procedure MakeApply_IP_List(iplist: TQuickList);
  end;

var
  FrmMain:    TFrmMain;
  FIDDB:      TFileIDDB;
  MagicNumber: integer;
  MaxPubAddr: integer;
  FCertification: integer;
  PubAddrTable: array[0..MAX_PUBADDR - 1] of TRAddr;
  DBServerAddr: string;
  FeeServerAddr: string;
  LogServerAddr: string;
  DBSPort, FeePort, LogPort: integer;
  ExecTime, ExecRunTime: integer;
  ReadyServerCount: integer;
  PasswdLockList: TStringList;
  TotalUserCount: integer;
  MaxTotalUserCount: integer;
  OldMemoHeight: integer;
  MsgList:    TStringList;
  sLock:      TCriticalSection;

procedure ShowMsg(msgstr: string);
procedure MakeDefMsg(var DMsg: TDefaultMessage; msg: word; llong: integer;
  atag, nseries: word);
procedure SendSocket(Socket: TCustomWinSocket; uhandle, Data: string);
procedure LoadAddressTable;
procedure SaveAddressTable;
function IsValidGateAddr(addr: string): boolean;
function GetPublicAddr(raddr: string): string;
function GetUserGateAddr(svname, addr: string; var port: integer): string;


implementation

uses GateSet, MasSock, FrmFindId, FAccountView;

{$R *.DFM}

function GetCertification: integer;
begin
  Inc(FCertification);
  if FCertification >= $7FFFFFFF then
    FCertification := 2;
  Result := FCertification;
end;

procedure MakeDefMsg(var DMsg: TDefaultMessage; msg: word; llong: integer;
  atag, nseries: word);
begin
  with DMsg do begin
    Ident  := msg;
    Recog  := llong;
    Tag    := atag;
    Series := nseries;
  end;
end;

procedure WriteUserCountLog(str: string);

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
  f:      TextFile;
  i:      integer;
begin
  if str = '' then
    exit;

  DecodeDate(Date, ayear, amon, aday);
  DecodeTime(Time, ahour, amin, asec, amsec);
  dirname := CountLogDir + IntToStr(ayear) + '-' + IntTo_Str(amon);
  if not DirectoryExists(dirname) then begin
    if not CreateDir(dirname) then exit;
  end;
  flname := dirname + '\' + IntToStr(ayear) + '-' + IntTo_Str(amon) +
    '-' + IntTo_Str(aday) + '.txt';

  AssignFile(f, flname);
  if not FileExists(flname) then
    Rewrite(f)
  else
    Append(f);

  WriteLn(f, str + ''#9 + TimeToStr(Time));

  CloseFile(f);
end;

procedure ShowMsg(msgstr: string);
begin
  try
    sLock.Enter;
    MsgList.Add(msgstr);
  finally
    sLock.Leave;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  ini: TIniFile;
  str: string;
begin
  FIDDB   := nil;
  MsgList := TStringList.Create;
  sLock   := TCriticalSection.Create;
  ini     := TIniFile.Create(SETUPFILE);
  if ini <> nil then begin
    DBServerAddr := ini.ReadString('server', 'DBServer', '5.5.1.3');
    FeeServerAddr := ini.ReadString('server', 'FeeServer', '5.5.1.3');
    LogServerAddr := ini.ReadString('server', 'LogServer', '5.5.1.3');
    DBSPort     := Ini.ReadInteger('server', 'DBSPort', 16300);
    FeePort     := Ini.ReadInteger('server', 'FeePort', 16301);
    LogPort     := Ini.ReadInteger('server', 'LogPort', 16302);
    FIdDBDir    := ini.ReadString('DB', 'IdDir', FIdDBDir);
    ReadyServerCount := ini.ReadInteger('server', 'ReadyServers', 0);
    WebLogDir   := ini.ReadString('server', 'WebLogDir', WebLogDir);
    CountLogDir := ini.ReadString('server', 'CountLogDir', CountLogDir);
    FeedIDListFile := ini.ReadString('server', 'FeedIDList', FeedIDListFile);
    FeedIPListFile := ini.ReadString('server', 'FeedIPList', FeedIPListFile);

    str := ini.ReadString('Server', 'FreeMode', 'FALSE');
    BoFreeGameMode := (CompareText(str, 'TRUE') = 0);

    str := ini.ReadString('Server', 'TestServer', 'FALSE');
    BoTestMode := (CompareText(str, 'TRUE') = 0);

    str := ini.ReadString('Server', 'EnableMakingID', 'TRUE');
    BoEnableMakeID := (CompareText(str, 'TRUE') = 0);

    ini.Free;
  end else begin
    ShowMessage('Fatal error expected.');
  end;
  PasswdLockList := TStringList.Create;
  with GSocket do begin
    Active := False;
    Port   := 5500;
    Active := True;
  end;
  FCertification := 1;
  MagicNumber    := 1;
  OldMemoHeight  := Memo1.ClientHeight;

  GateList   := TList.Create;
  CertList   := TList.Create;
  ServerNameList := TStringList.Create;
  ClogList   := TStringList.Create;
  FeedIDList := TQuickList.Create;
  FeedIPList := TQuickList.Create;

  LoadIPIDThread := TThreadParseList.Create;

  LoadAddressTable;
  //LoadFeedList (TRUE);

  with MonitorGrid do begin
    Cells[0, 0] := 'ServerName';
    Cells[1, 0] := 'UserCount';
    Cells[2, 0] := 'Status';
    Cells[3, 0] := 'ServerName';
    Cells[4, 0] := 'UserCount';
    Cells[5, 0] := 'Status';
  end;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
var
  i, j:  integer;
  ginfo: PTGateInfo;
begin
  if FIDDB <> nil then
    FIDDB.Free;
  FrmMasSoc.Finialize;
  for i := 0 to GateList.Count - 1 do begin
    ginfo := PTGateInfo(GateList[i]);
    for j := 0 to ginfo.UserList.Count - 1 do
      Dispose(PTUserInfo(ginfo.UserList[j]));
    Dispose(ginfo);
  end;

  GateList.Free;
  CertList.Free;
  ServerNameList.Free;
  CLogList.Free;
  PasswdLockList.Free;
  sLock.Free;
  //LoadIPIDThread.Free;
end;

procedure TFrmMain.LoadFeedList(bofast: boolean);
begin
   {if not LoadIPIDThread.WorkingID and not LoadIPIDThread.WorkingIP then begin
      LoadIPIDThread.Suspend;
      LoadIPIDThread.BoFastLoading := bofast;
      try
         if FileExists (FeedIDListFile) then begin
            LoadIPIDThread.IDStrList.Clear;
            SafeLoadFromFile (FeedIDListFile, LoadIPIDThread.IDStrList);
         end;
         if FileExists (FeedIPListFile) then begin
            LoadIPIDThread.IPStrList.Clear;
            SafeLoadFromFile (FeedIPListFile, LoadIPIDThread.IPStrList);
            //LoadIPIDThread.IPStrList.LoadFromFile (FeedIPListFile);
         end;
         LoadIPIDThread.WorkingID := TRUE;
         LoadIPIDThread.WorkingIP := TRUE;
         LoadIPIDThread.Resume;
      except
         Memo1.Lines.Add ('Exception at LoadFeedList');
      end;
   end else
      Memo1.Lines.Add ('LoadFeedList busy...');
      }
end;

procedure TFrmMain.LoadServerNames;
var
  i, j: integer;
  flag: boolean;
begin
  ServerNameList.Clear;
  for i := 0 to MaxPubAddr - 1 do begin
    flag := True;
    for j := 0 to ServerNameList.Count - 1 do begin
      if ServerNameList[j] = PubAddrTable[i].ServerName then
        flag := False;
    end;
    if flag then
      ServerNameList.Add(PubAddrTable[i].ServerName);
  end;
end;


procedure TFrmMain.GSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  ginfo: PTGateInfo;
begin
  if not ExecTimer.Enabled then begin
    Socket.Close;
    exit;
  end;
  //if IsValidGateAddr (Socket.RemoteAddress) then begin
  new(ginfo);
  with ginfo^ do begin
    GateSocket := Socket;
    RemotePublicAddr := GetPublicAddr(Socket.RemoteAddress);
    SocData    := '';
    UserList   := TList.Create;
    ConnCheckTime := GetCurrentTime;
  end;
  try
    sLock.Enter;
    GateList.Add(ginfo);
  finally
    sLock.Leave;
  end;
  //end else begin
  //   Memo1.Lines.Add ('not authorized connection tryed..');
  //   Socket.Close;
  //end;
end;

procedure TFrmMain.GSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i, j:  integer;
  ginfo: PTGateInfo;
begin
  try
    sLock.Enter;
    for i := 0 to GAteList.Count - 1 do begin
      if PTGateInfo(GateList[i]).GateSocket = socket then begin
        ginfo := PTGateInfo(GateList[i]);
        for j := 0 to ginfo.UserList.Count - 1 do begin
          if CbViewLog.Checked then
            Memo1.Lines.Add('Close : ' + PTUserInfo(ginfo.UserList[j]).UserAddr);
          Dispose(PTUserInfo(ginfo.UserList[j]));
        end;
        Dispose(ginfo);
        GateList.Delete(i);
        break;
      end;
    end;
  finally
    sLock.Leave;
  end;
end;

procedure TFrmMain.GSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.GSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  i: integer;
begin
  try
    sLock.Enter;
    for i := 0 to GateList.Count - 1 do begin
      if PTGateInfo(GateList[i]).GateSocket = Socket then begin
        PTGateInfo(GateList[i]).SocData :=
          PTGateInfo(GateList[i]).SocData + Socket.ReceiveText;
        break;
      end;
    end;
  finally
    sLock.Leave;
  end;
end;

function TFrmMain.IsDoubbleConnection(uid: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to CertList.Count - 1 do begin
    if PTConnInfo(CertList[i]).Uid = uid then begin
      Result := True;
      break;
    end;
  end;
end;

procedure TFrmMain.MarkCertListClose(uid: string);
var
  i:  integer;
  pc: PTConnInfo;
begin
  for i := 0 to CertList.Count - 1 do begin
    pc := PTConnInfo(CertList[i]);
    if (PTConnInfo(CertList[i]).Uid = uid) and
      (not PTConnInfo(CertList[i]).Closing) then begin
      FrmMasSoc.SendNamedServerMsg(pc.ServerName, ISM_CANCELADMISSION,
        pc.Uid + '/' + IntToStr(pc.Certify));
      PTConnInfo(CertList[i]).OpenTime := GetTickCount; //������ ������ ����
      PTConnInfo(CertList[i]).Closing  := True;
    end;
  end;
end;

procedure TFrmMain.CheckCertListTimeOuts;
var
  i:  integer;
  pc: PTConnInfo;
begin
  for i := CertList.Count - 1 downto 0 do begin
    pc := PTConnInfo(CertList[i]);
    if pc.Closing then begin
      if GetTickCount - pc.OpenTime > 5{10} * 1000 then begin
        Dispose(pc);
        CertList.Delete(i);
      end;
    end;
  end;
end;

procedure TFrmMain.CheckAccountExpire;
var
  i:  integer;
  pc: PTConnInfo;
begin
  for i := CertList.Count - 1 downto 0 do begin
    pc := PTConnInfo(CertList[i]);
    if not pc.Closing and not BoTestMode then begin
      //�������� ��ϵ� ���� �� 1 �ð� ���� ��ȿ�� �˻�
      if not pc.FreeMode then
        if GetTickCount - pc.AccountCheckTime > 60 * 60 * 1000 then begin
          pc.AccountCheckTime := GetTickCount;
          if not CheckAccountAvailable(pc.UId, pc.UAddr) then begin
            FrmMasSoc.SendNamedServerMsg(pc.ServerName,
              ISM_ACCOUNTEXPIRED, pc.Uid + '/' + IntToStr(pc.Certify));
            Dispose(pc);  //���� ����
            CertList.Delete(i);
          end;
        end;
    end;
  end;
end;

procedure TFrmMain.AddCertify(uid, uaddr: string; cert: integer;
  ipmode, freemode: boolean);
var
  pci: PTConnInfo;
begin
  new(pci);
  pci.Uid      := uid;
  pci.UAddr    := uaddr;
  pci.Certify  := cert;
  pci.CertifyIP := ipmode;
  pci.FreeMode := freemode;
  pci.OpenTime := GetTickCount;
  pci.AccountCheckTime := GetTickCount;
  pci.Closing  := False;
  CertList.Add(pci);
end;

procedure TFrmMain.ModifyCertify(cert: integer; svname: string; freemode: boolean);
var
  i: integer;
begin
  for i := 0 to CertList.Count - 1 do begin
    if PTConnInfo(CertList[i]).Certify = cert then begin
      PTConnInfo(CertList[i]).ServerName := svname;
      PTConnInfo(CertList[i]).FreeMode   := freemode;
      break;
    end;
  end;
end;

procedure TFrmMain.DelCertify(cert: integer);
var
  i: integer;
begin
  for i := 0 to CertList.Count - 1 do begin
    if PTConnInfo(CertList[i]).Certify = cert then begin
      Dispose(PTConnInfo(CertList[i]));
      CertList.Delete(i);
      break;
    end;
  end;
end;

function TFrmMain.IsValidCertification(cert: integer): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to CertList.Count - 1 do begin
    if PTConnInfo(CertList[i]).Certify = cert then begin
      if not PTConnInfo(CertList[i]).Closing then //���������� ���� �͸�
        Result := True;
      break;
    end;
  end;
end;


{-----------------------------------------------------------------}


function TFrmMain.CheckAccountAvailable(uid, uaddr: string): boolean;
begin
  try
    slock.Enter;
    if (FeedIDList.FFind(uid) >= 0) or (FeedIPList.FFind(uaddr) >= 0) then begin
      Result := True;
    end else
      Result := False;
  finally
    slock.Leave;
  end;
end;

procedure TFrmMain.CertifyCloseUser(uid: string; cert: integer);
var
  i:  integer;
  pc: PTConnInfo;
begin
  for i := CertList.Count - 1 downto 0 do begin
    pc := PTConnInfo(CertList[i]);
    if (pc.UId = uid) or (pc.Certify = cert) then begin
      FrmMasSoc.SendNamedServerMsg(pc.ServerName, ISM_CANCELADMISSION,
        pc.Uid + '/' + IntToStr(pc.Certify));
      Dispose(PTConnInfo(CertList[i]));
      CertList.Delete(i);
    end;
  end;
end;


{-----------------------------------------------------------------}


function TFrmMain.KickOffSocket(puser: PTUserInfo): boolean;
var
  i, j:   integer;
  ginfo:  PTGateInfo;
  puinfo: PTUserInfo;
begin
  Result := False;
  try
    sLock.Enter;
    for i := 0 to GateList.Count - 1 do begin
      ginfo := PTGateInfo(GateList[i]);
      for j := 0 to ginfo.UserList.Count - 1 do begin
        if puser = PTUserInfo(ginfo.UserList[j]) then begin
          if CbViewLog.Checked then
            Memo1.Lines.Add('Kick  : ' + puser.UserAddr);
          SendKickUser(ginfo.GateSocket, puser.UserHandle);
          Dispose(puser);
          ginfo.UserList.Delete(j);
          Result := True;
          exit;
        end;
      end;
    end;
  finally
    sLock.Leave;
  end;
end;

procedure SendSocket(Socket: TCustomWinSocket; uhandle, Data: string);
begin
  Socket.SendText('%' + uhandle + '/#' + Data + '!$');
end;

procedure TFrmMain.SendKickUser(Socket: TCustomWinSocket; uhandle: string);
begin
  Socket.SendText('%+-' + uhandle + '$');
end;

procedure TFrmMain.ReceiveCheckCode(asocket: TCustomWinSocket);
begin
  if asocket.Connected then begin
    asocket.SendText('%++$');
  end;
end;


{--------------------------------------------------------}

function TFrmMain.AlreadyUsing(uid: string): boolean;
var
  i, j:   integer;
  ginfo:  PTGateInfo;
  puinfo: PTUserInfo;
begin
  Result := False;
  try
    sLock.Enter;
    for i := 0 to GateList.Count - 1 do begin
      ginfo := PTGateInfo(GateList[i]);
      for j := 0 to ginfo.UserList.Count - 1 do begin
        puinfo := PTUserInfo(ginfo.UserList[j]);
        if puinfo.Certification <> 0 then begin
          if puinfo.UserId = uid then begin
            Result := True; //�̹� �����
            exit;
          end;
        end;
      end;
    end;
  finally
    sLock.Leave;
  end;
end;


{=================== Execute Timer ======================}


procedure TFrmMain.StartTimerTimer(Sender: TObject);
begin
  StartTimer.Enabled := False;
  Memo1.Lines.Add('1) Loading...');
  Application.ProcessMessages;
  FIdDB := TFileIdDB.Create(FIdDBDir + 'Id.DB');
  //FIdDB.ConvertBuildIndex;

  Memo1.Lines.Add('2) Waiting Server Connections..');
  while True do begin
    Application.ProcessMessages;
    if Application.Terminated then
      exit;
    if FrmMasSoc.ConnectionReadyOk then
      break;
    sleep(1);
  end;
  Memo1.Lines.Add('3) Well Started..');
  ExecTimer.Enabled := True;
end;


procedure TFrmMain.ExecTimerTimer(Sender: TObject);
var
  i, n:      integer;
  str, Data: string;
  ginfo:     PTGateInfo;
  puinfo:    PTUserInfo;
const
  busy: boolean = False;
begin
  if busy or (not IdLoaded) then
    exit;
  try
    try
      ExecTime := GetCurrentTime;
      busy := True;
      n := 0;
      while True do begin
        if n >= GateList.Count then
          break;
        ginfo := PTGateInfo(GateList[n]);
        if ginfo.SocData <> '' then begin
          DecodeGateData(ginfo);
          CurrentRemotePublicAddr := ginfo.RemotePublicAddr;
          i := 0;
          while True do begin
            if i >= ginfo.UserList.Count then
              break;
            puinfo := PTUserInfo(ginfo.UserList[i]);
            if puinfo.SocData <> '' then begin
              DecodeUserData(puinfo);
            end;
            Inc(i);
          end;
        end;
        Inc(n);
      end;
      if ExecRunTime < ExecTime then
        ExecRunTime := GetCurrentTime - ExecTime;
      if ExecRunTime > 100 then
        Dec(ExecRunTime, 100);
    except
      Memo1.Lines.Add('Exception !!!!!!!!!!!!!');
    end;
  finally
    busy := False;
  end;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  i: integer;
begin
  Label1.Caption     := IntToStr(ExecRunTime);
  CkLogin.Checked    := GSocket.Socket.Connected;
  CkLogin.Caption    := 'Login (' + IntToStr(GSocket.Socket.ActiveConnections) + ')';
  LbMasCount.Caption := IntToStr(TotalUserCount) + '/' + IntToStr(MaxTotalUserCount);
  //CkLogServer.Checked := FrmLogSoc.LogCSocket.Socket.Connected;
  if Memo1.Lines.Count > 2000 then begin
    Memo1.Clear;
  end;

  try
    sLock.Enter;
    for i := 0 to MsgList.Count - 1 do begin
      Memo1.Lines.Add(MsgList[i]);
    end;
    MsgList.Clear;
  finally
    sLock.Leave;
  end;

  i := 0;
  while True do begin
    if i >= PasswdLockList.Count then
      break;
    if GetCurrentTime - integer(PasswdLockList.Objects[i]) > 60 * 1000 then begin
      PasswdLockList.Delete(i);
    end else
      Inc(i);
  end;

  CheckCertListTimeOuts;

  CheckAccountExpire;

end;

function TFrmMain.IsLockIP(ip: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to PasswdLockList.Count - 1 do begin
    if passwdLockList[i] = ip then begin
      Result := True;
      break;
    end;
  end;
end;

procedure TFrmMain.LockIP(ip: string);
begin
  PasswdLockList.AddObject(ip, TObject(GetCurrentTime));
end;


{----------------------------------------------------------------------------}


procedure TFrmMain.DecodeGateData(ginfo: PTGateInfo);
var
  tag:      char;
  errcount: integer;
  msg, str, Data, shandle, addr: string;
begin
  try
    errcount := 0;
    while True do begin
      if CharCount(ginfo.SocData, '$') <= 0 then
        break;
      gInfo.SocData := ArrestStringEx(ginfo.SocData, '%', '$', msg);
      if msg <> '' then begin
        tag := msg[1];
        msg := Copy(msg, 2, Length(msg) - 1);
        case word(tag) of
          word('-'): begin
            ReceiveCheckCode(ginfo.GateSocket);
            ginfo.ConnCheckTime := GetCurrentTime;
          end;

          word('O'): begin
            Data    := GetValidStr3(msg, str, ['/']);
            //str : user handle
            //data : user remote address
            shandle := str;
            addr    := Data;
            ReceiveOpenUser(shandle, addr, ginfo);
          end;

          word('X'): begin
            shandle := msg;
            ReceiveCloseUser(shandle, ginfo);
          end;

          word('A'): begin
            Data := GetValidStr3(msg, shandle, ['/']);
            ReceiveSendData(shandle, ginfo, Data);
          end;
        end;
      end else begin
        if errcount >= 1 then
          gInfo.SocData := '';
        Inc(errcount);
        //break;
      end;
    end;
  except
    Memo1.Lines.Add('Exception DecodeGateData !!!!!!!!!!!!!');
  end;
end;

procedure TFrmMain.ReceiveOpenUser(uhandle, usraddr: string; ginfo: PTGateInfo);
var
  i:      integer;
  puinfo: PTUserInfo;
begin
  for i := 0 to ginfo.UserList.Count - 1 do begin
    puinfo := PTUserInfo(ginfo.UserList[i]);
    if puinfo.UserHandle = uhandle then begin
      puinfo.UserAddr    := usraddr;
      puinfo.UserId      := '';
      puinfo.Certification := 0;
      puinfo.SocData     := '';
      puinfo.ConnectTime := GetTickCount;
      puinfo.LatestCmdTime := GetTickCount;
      exit;
    end;
  end;
  new(puinfo);
  with puinfo^ do begin
    UserId      := '';
    UserAddr    := usraddr;
    UserHandle  := uhandle;
    ClientVersion := 0;
    VersionAccept := False;
    Certification := 0;    // not certificated..
    ConnState   := csIdPasswd;
    CSocket     := ginfo.GateSocket;
    SocData     := '';
    ConnectTime := GetTickCount;
    LatestCmdTime := GetTickCount;
    BoServerRun := False;
  end;
  ginfo.UserList.Add(puinfo);
  if CbViewLog.Checked then
    Memo1.Lines.Add('Open  : ' + usraddr);
end;

procedure TFrmMain.ReceiveCloseUser(uhandle: string; ginfo: PTGateInfo);
var
  i: integer;
  p: PTUserInfo;
begin
  for i := 0 to ginfo.UserList.Count - 1 do begin
    if PTUserInfo(ginfo.UserList[i]).UserHandle = uhandle then begin
      if CbViewLog.Checked then
        Memo1.Lines.Add('Close : ' + PTUserInfo(ginfo.UserList[i]).UserAddr);
      p := PTUserInfo(ginfo.UserList[i]);
      if not p.SelServerOk then  //���������� �������� ä�� ��������� ���
        DelCertify(p.Certification);
      Dispose(p);
      ginfo.UserList.Delete(i);
      //p := PTUserInfo (ginfo.UserList[i]);
      //if p.ConnState = csIdPasswd then
      //   p.ConnState := csTrySelChr;
      break;
    end;
  end;
end;

procedure TFrmMain.ReceiveSendData(uhandle: string; ginfo: PTGateInfo; Data: string);
var
  i: integer;
begin
  for i := 0 to ginfo.UserList.Count - 1 do begin
    if PTUserInfo(ginfo.UserList[i]).UserHandle = uhandle then begin
      if Length(PTUserInfo(ginfo.UserList[i]).SocData) < 4096 then begin
        //�ҷ� ��Ŷ ���� ����
        //�������� ��Ŷ�� 4K�� ���� ����
        PTUserInfo(ginfo.UserList[i]).SocData :=
          PTUserInfo(ginfo.UserList[i]).SocData + Data;
      end;
      break;
    end;
  end;
end;


{----------------------------------------------------------------------------}


procedure TFrmMain.DecodeUserData(puser: PTUserInfo);
var
  errcount: integer;
  msg:      string;
begin
  try
    errcount := 0;
    while puser.SocData <> '' do begin  // #FDSAFDJSAFDSA!
      if CharCount(puser.SocData, '!') <= 0 then
        break;
      puser.SocData := ArrestStringEx(puser.SocData, '#', '!', msg);
      if msg <> '' then begin
        if Length(msg) >= DEFBLOCKSIZE + 1 then begin
          msg := Copy(msg, 2, Length(msg) - 1);
          DecodeLogMessages(msg, puser);
          //break;
        end;
      end else begin
        if errcount >= 1 then
          puser.SocData := '';
        Inc(errcount);
        //break;
      end;
    end;
  except
    Memo1.Lines.Add('Exception DecodeUserData !!!!!!!!!!!!!');
  end;
end;


{----------------------------------------------------------------------------}

 // 1 : ����
 // -1 : ��й�ȣ Ʋ��
 // -2 : ��й�ȣ 3ȸ �̻� Ʋ��
 // -3 : ���� �����, ���
 // -4 : ���� ������ �ƴ�
 // -5 : ������ �����Ǿ���
procedure TFrmMain.LoginGetIdPasswd(puser: PTUserInfo; body: string);
var
  idx, runport, ididx, ipidx, idaval, ipaval: integer;
  str, uid, passwd, runaddr: string;
  success: integer;
  ircd:    FIdRcd;
  msg:     TDefaultMessage;
  boneededitaccount, ipmode: boolean;
  ue:      TUserEntryInfo;
begin
  str     := DecodeString(body);
  passwd  := GetValidStr3(str, uid, ['/']);
  success := 0;
  boneededitaccount := False;

  with FIdDb do begin
    try
      if OpenWr then begin
        idx := Find(uid);
        if idx >= 0 then begin
          if GetRecord(idx, ircd) >= 0 then begin
            if (ircd.Block.PassWdFail < 5) or
              (GetTickCount - ircd.Block.PassWdFailTime > 60 * 1000) then
            begin //1�е��� ������.
              if passwd = ircd.Block.Uinfo.Password then begin
                ircd.Block.PassWdFail := 0;
                if (ircd.Block.UInfo.UserName = '') or
                  (ircd.Block.UAdd.Quiz2 = '') then begin
                  ue := ircd.Block.UInfo;
                  boneededitaccount := True;
                end;
                puser.AccountMakeDate := SolveDouble(ircd.MakeRcdDateTime);
                success := 1; //����
              end else begin
                ircd.Block.PassWdFail := ircd.Block.PassWdFail + 1;
                ircd.Block.PasswdFailTime := GetTickCount;
                success := -1; //Ʋ��
              end;
              SetRecord(idx, ircd);
            end else begin
              success := -2; //5ȸ ���� Ʋ��, 1�а� ����
              ircd.Block.PasswdFailTime := GetTickCount;
              SetRecord(idx, ircd);
            end;
          end;
        end;
      end;
    finally
      Close;
    end;
  end;

  if success = 1 then begin
    if IsDoubbleConnection(uid) then begin
      MarkCertListClose(uid);

      success := -3;
    end;
  end;
  //success = -4  : ���� ��� �̽ǽ� ����
  //          -5  : ����ŷ�� ����

  if boneededitaccount then begin
    msg := MakeDefaultMsg(SM_NEEDUPDATE_ACCOUNT, 0, 0, 0, 0);
    SendSocket(puser.CSocket, puser.UserHandle, EncodeMessage(msg) +
      EncodeBuffer(@ue, sizeof(TUserEntryInfo)));
  end;

  if success = 1 then begin
    puser.UserId      := uid;
    puser.Certification := GetCertification;
    puser.SelServerOk := False; //���� ������ ������ ������ �� ����.

    try
      slock.Enter;
      ididx  := FeedIDList.FFind(puser.UserId);
      ipidx  := FeedIPList.FFind(puser.UserAddr);
      idaval := 0;
      ipaval := 0;
      ipmode := False;
      if ididx >= 0 then
        idaval := integer(FeedIDList.Objects[ididx]);
      if ipidx >= 0 then begin
        ipaval := integer(FeedIPList.Objects[ipidx]);
        ipmode := True;
      end;
    finally
      slock.Leave;
    end;


    if (ididx >= 0) or (ipidx >= 0) then begin
      puser.PayMode := 1;  //���� �����..
    end else
      puser.PayMode := 0;

    puser.IDDay  := Loword(idaval);
    puser.IDHour := Hiword(idaval);
    puser.IPDay  := Loword(ipaval);
    puser.IPHour := Hiword(ipaval);

    //recog : day or hour
    //param : 0(day), 1(hour)
    if puser.PayMode = 0 then
      msg := MakeDefaultMsg(SM_PASSOK_SELECTSERVER, 0, 0, 0, 0)
    else
      msg := MakeDefaultMsg(SM_PASSOK_SELECTSERVER, idaval,
        Loword(ipaval), Hiword(ipaval), 0);


    SendSocket(puser.CSocket, puser.UserHandle, EncodeMessage(msg));

    AddCertify(uid, puser.UserAddr, puser.Certification, ipmode, False);

    WriteConLog('LOGIN', uid, puser.UserAddr);
  end else begin
    msg := MakeDefaultMsg(SM_PASSWD_FAIL, success, 0, 0, 0);
    SendSocket(puser.CSocket, puser.UserHandle, EncodeMessage(msg));
    //if success = -3 then begin
    //   KickOffSocket (puser);
    //end;
  end;

end;

procedure TFrmMain.LoginGetSelectServer(puser: PTUserInfo; body: string);
var
  svname, runaddr: string;
  runport, availabletype: integer;
  msg:      TDefaultMessage;
  freemode: boolean;
begin
  svname := DecodeString(body);
  if (puser.UserId <> '') and (svname <> '') and
    IsValidCertification(puser.Certification) then begin //Passwd�� ����߾����.

    if CbViewLog.Checked then
      Memo1.Lines.Add('Server : ' + svname + ' ' + CurrentRemotePublicAddr);
    runaddr := GetUserGateAddr(svname, CurrentRemotePublicAddr, runport);
    if (runaddr <> '') and (runport > 0) then begin

      puser.SelServerOk := True; //���� ������ ��������.
      freemode := False;

      //SelChr����(DBServer)���� id+certificaion�� ������ �Ѵ�.
      //...+ uid + '/' +
      //PayMode : 0(����ü����) 1(���Ļ����)
      availabletype := 5;
      if puser.IDHour > 0 then
        availabletype := 2;
      if puser.IPHour > 0 then
        availabletype := 4;  //pc���� -�ð��� �ش�.
      if puser.IPDay > 0 then
        availabletype := 3;
      if puser.IDDay > 0 then
        availabletype := 1;

      if KoreanVersion then begin
        //����, ��Ȳ, ���� ���� ����� ����
        if (svname = '���ۼ���') or (svname = 'BongWangServer') or
          (svname = '���¼���') then begin
          if Now < CalcDay(puser.AccountMakeDate, 20) then begin
            puser.PayMode := 2;     //��������
            freemode      := True;  //������ �ʰ� �Ϸ���
          end;
        end;
      end;

      if BoFreeGameMode then begin
        puser.PayMode := 2;
        freemode      := True;
      end;

      if FrmMasSoc.IsValidServerLimitiation(svname) then begin
        ModifyCertify(puser.Certification, svname, freemode);
        FrmMasSoc.SendNamedServerMsg(svname,
          ISM_PASSWDSUCCESS,
          puser.UserId + '/' + IntToStr(puser.Certification) +
          '/' + IntToStr(puser.PayMode) + '/' + IntToStr(availabletype) +
          '/' + puser.UserAddr + '/' + IntToStr(puser.ClientVersion));

        msg := MakeDefaultMsg(SM_SELECTSERVER_OK, puser.Certification, 0, 0, 0);
        SendSocket(puser.CSocket, puser.UserHandle,
          EncodeMessage(msg) + EncodeString(runaddr + '/' +
          IntToStr(runport) + '/' + IntToStr(puser.Certification)));
      end else begin
        DelCertify(puser.Certification);
        msg := MakeDefaultMsg(SM_STARTFAIL, 0, 0, 0, 0);
        SendSocket(puser.CSocket, puser.UserHandle, EncodeMessage(msg));
      end;

    end;
  end;
end;



procedure TFrmMain.WriteLog(cmd: string; ue: TUserEntryInfo; ua: TUserEntryAddInfo);
var
  ayear, amon, aday: word;
  monstr, flname: string;
  f: TextFile;
  dirname: array[0..255] of char;
begin
  DecodeDate(Date, ayear, amon, aday);
  monstr := '.\ChrLog\' + IntToStr(ayear) + '-' + IntToStr(amon);
  if not FileExists(monstr) then begin
    StrPCopy(dirname, monstr);
    CreateDirectory(@dirname, nil);
  end;
  if aday < 10 then
    flname := monstr + '\Id_0' + IntToStr(aday) + '.log'
  else
    flname := monstr + '\Id_' + IntToStr(aday) + '.log';
  AssignFile(f, flname);
  if not FileExists(flname) then
    Rewrite(f)
  else
    Append(f);
  WriteLn(f, '*' + cmd + '* ' + FmStr2(ue.LoginId, 11) +
    FmStr2('"' + ue.Password + '"', 13) + FmStr2(ue.UserName, 21) +
    FmStr2(ue.SSNo, 15) + FmStr2(ue.Phone, 15) + FmStr2(ue.Quiz, 21) +
    FmStr2(ue.Answer, 13) + FmStr2(ue.EMail, 41) + FmStr2(ua.Quiz2, 21) +
    FmStr2(ua.Answer2, 13) + FmStr2(ua.Birthday, 11) + FmStr2(ua.MobilePhone, 14) +
    '[' + TimeToStr(Time));
  //Flush (f);
  CloseFile(f);
end;

procedure TFrmMain.WriteConLog(cmd, uid, addr: string);
begin
  CLogList.Add(FmStr2(cmd, 6) + FmStr2(uid, 11) + FmStr2(addr, 16) +
    '[' + TimeToStr(Time));
end;

procedure TFrmMain.LoginGetNewUser(puser: PTUserInfo; body: string);
var
  ue:      TUserEntryInfo;
  ua:      TUserEntryAddInfo;
  idx, size1, success: integer;
  uestr, uastr: string;
  rcd:     FIdRcd;
  msg:     TDefaultMessage;
  bovalid: boolean;
begin
  success := -1;
  FillChar(ue, sizeof(TUserEntryInfo), #0);
  FillChar(ua, sizeof(TUserEntryAddInfo), #0);
  size1   := UpInt(sizeof(TUserEntryInfo) * 4 / 3);
  bovalid := False;
  uestr   := Copy(body, 1, size1);
  uastr   := Copy(body, size1 + 1, Length(body));
  if (uestr <> '') and (uastr <> '') then begin
    DecodeBuffer(uestr, @ue, sizeof(TUserEntryInfo));
    DecodeBuffer(uastr, @ua, sizeof(TUserEntryAddInfo));
    if ChinaVersion then begin
      if IsValidFileName(ue.LoginId) then
        bovalid := True;
    end else begin
      if IsValidUserName(ue.LoginId) then
        bovalid := True;
    end;
    if bovalid then begin
      with FIdDb do begin
        try
          if OpenWr then begin
            idx := Find(ue.LoginId);
            if idx < 0 then begin
              FillChar(rcd, sizeof(FIdRcd), #0);
              rcd.Block.UInfo := ue;
              rcd.Block.UAdd := ua;  //���� �߰��ؾ� ��
              rcd.Key := ue.LoginId;
              if rcd.Key <> '' then
                if AddRecord(rcd) then
                  success := 1; //����
            end else begin
              success := 0; //�̹� ������
            end;
          end;
        finally
          Close;
        end;
      end;
    end;// else
        //Memo1.Lines.Add ('[AddNewUser Fail] ue.LoginId = nil');
  end else
    Memo1.Lines.Add('[AddNewUser Fail] ' + uestr + '/' + uastr);

  if success = 1 then begin
    WriteLog('new', ue, ua);
    msg := MakeDefaultMsg(SM_NEWID_SUCCESS, 0, 0, 0, 0);
  end else begin
    msg := MakeDefaultMsg(SM_NEWID_FAIL, success, 0, 0, 0);
  end;
  SendSocket(puser.CSocket, puser.UserHandle, EncodeMessage(msg));
end;

procedure TFrmMain.LoginGetUpdateUser(puser: PTUserInfo; body: string);
var
  ue:  TUserEntryInfo;
  ua:  TUserEntryAddInfo;
  idx, size1, success: integer;
  uestr, uastr: string;
  rcd: FIdRcd;
  msg: TDefaultMessage;
begin
  FillChar(ue, sizeof(TUserEntryInfo), #0);
  FillChar(ua, sizeof(TUserEntryAddInfo), #0);
  size1 := UpInt(sizeof(TUserEntryInfo) * 4 / 3);
  uestr := Copy(body, 1, size1);
  uastr := Copy(body, size1 + 1, Length(body));
  DecodeBuffer(uestr, @ue, sizeof(TUserEntryInfo));
  DecodeBuffer(uastr, @ua, sizeof(TUserEntryAddInfo));
  success := -1;
  if (puser.UserId = ue.LoginId) and IsValidUserName(ue.LoginId) then begin
    with FIdDb do begin
      try
        if OpenWr then begin
          idx := Find(ue.LoginId);
          if idx >= 0 then begin
            if GetRecord(idx, rcd) >= 0 then begin
              rcd.Block.UInfo := ue;
              rcd.Block.UAdd  := ua;  //���� �߰��ؾ� ��
              SetRecord(idx, rcd);
              success := 1; //����
            end;
          end else begin
            success := 0; //����
          end;
        end;
      finally
        Close;
      end;
    end;
  end;
  if success = 1 then begin
    WriteLog('upg', ue, ua);
    msg := MakeDefaultMsg(SM_UPDATEID_SUCCESS, 0, 0, 0, 0);
  end else begin
    msg := MakeDefaultMsg(SM_UPDATEID_FAIL, success, 0, 0, 0);
  end;
  SendSocket(puser.CSocket, puser.UserHandle, EncodeMessage(msg));
end;

 // usrid / passwd / new passwd
 // Result
procedure TFrmMain.LoginChangePasswd(puser: PTUserInfo; body: string);
var
  idx:     integer;
  str, uid, passwd, newpass: string;
  success: integer;
  ircd:    FIdRcd;
  ue:      TUserEntryInfo;
  ua:      TUserEntryAddInfo;
  msg:     TDefaultMessage;
begin
  str     := DecodeString(body);
  str     := GetValidStr3(str, uid, [#9]);
  newpass := GetValidStr3(str, passwd, [#9]);
  success := 0;
  with FIdDb do begin
    try
      if OpenWr and (Length(newpass) >= 3) then begin
        idx := Find(uid);
        if idx >= 0 then begin
          if GetRecord(idx, ircd) >= 0 then begin
            if (ircd.Block.PassWdFail >= 5) or
              (GetTickCount - ircd.Block.PassWdFailTime > 3 * 60 * 1000) then
            begin //3�е��� ������.
              if passwd = ircd.Block.Uinfo.Password then begin
                ircd.Block.PassWdFail := 0;
                ircd.Block.Uinfo.Password := newpass; //����й�ȣ�� ����
                success := 1; //����
              end else begin
                ircd.Block.PasswdFail := ircd.Block.PassWdFail + 1;
                ircd.Block.PasswdFailTime := GetTickCount;
                success := -1; //Ʋ��
              end;
              SetRecord(idx, ircd);
            end else begin
              success := -2; //5ȸ ���� Ʋ��, 3�а� ����
              if GetTickCount < ircd.Block.PassWdFailTime then begin
                ircd.Block.PasswdFailTime := GetTickCount;
                SetRecord(idx, ircd);
              end;
            end;
          end;
        end;
      end;
    finally
      Close;
    end;
  end;
  if success = 1 then begin
    msg := MakeDefaultMsg(SM_CHGPASSWD_SUCCESS, 0, 0, 0, 0);
    FillChar(ue, sizeof(TUserEntryInfo), #0);
    FillChar(ua, sizeof(TUserEntryAddInfo), #0);
    ue.LoginId  := uid;
    ue.Password := passwd;
    ue.UserName := '-> "' + newpass + '"';
    ue.SSNo     := puser.UserAddr;
    WriteLog('chg', ue, ua);
  end else
    msg := MakeDefaultMsg(SM_CHGPASSWD_FAIL, success, 0, 0, 0);
  SendSocket(puser.CSocket, puser.UserHandle, EncodeMessage(msg));
end;

function TFrmMain.DecodeLogMessages(Data: string; puser: PTUserInfo): boolean;

  procedure SendVersionFail;
  var
    msg: TDefaultMessage;
  begin
    msg := MakeDefaultMsg(SM_VERSION_FAIL, 0, 0, 0, 0);
    SendSocket(puser.CSocket, puser.UserHandle, EncodeMessage(msg));
  end;

var
  msg: TDefaultMessage;
  cport, serverindex, certify: integer;
  head, body, idstr, newaddress: string;
  //logobj: TObject;
begin
  try
    head := Copy(Data, 1, DEFBLOCKSIZE);
    body := Copy(Data, DEFBLOCKSIZE + 1, Length(Data) - DEFBLOCKSIZE);
    msg  := DecodeMessage(head);

    case msg.Ident of
      CM_PROTOCOL: begin
               {Version := msg.Recog;
                UpdateDate := msg.Series; }
        if msg.Recog < VERSION_NUMBER then begin
          SendVersionFail;
        end else begin
          msg := MakeDefaultMsg(SM_VERSION_AVAILABLE, 0, 0, 0, 0);
          SendSocket(puser.CSocket, puser.UserHandle, EncodeMessage(msg));
          puser.ClientVersion := msg.Recog;
          puser.VersionAccept := True;
        end;
      end;

      CM_IDPASSWORD: begin
        if puser.UserId = '' then begin
          if msg.Recog < VERSION_NUMBER then begin
            SendVersionFail;
          end else begin
            puser.ClientVersion := msg.Recog;
            puser.VersionAccept := True;
            LoginGetIdPasswd(puser, body);
          end;

          //puser -> Free�� �� ����
        end else begin
          //�ߺ� ����
          //puser.UserId := '';
          KickOffSocket(puser);
          //puser -> Free�� �� ����
        end;
        //msg := MakeDefaultMsg (SM_STARTFAIL, 0, 0, 0, 0);
        //SendSocket (puser.CSocket, puser.UserHandle, EncodeMessage (msg));

      end;

      CM_SELECTSERVER: begin
        if not puser.SelServerOk then  //�ѹ��� ����, (��Ŀ���ݹ���)
          LoginGetSelectServer(puser, body);
      end;

      CM_ADDNEWUSER: if BoEnableMakeID then begin
          if GetTickCount - puser.LatestCmdTime > 5 * 1000 then begin
            puser.LatestCmdTime := GetTickCount;
            LoginGetNewUser(puser, body);
          end else
            Memo1.Lines.Add('[Hacker Attack] ADDNEWACCOUNT ' +
              puser.UserId + '/' + puser.UserAddr);
        end;

      CM_UPDATEUSER: begin
        if GetTickCount - puser.LatestCmdTime > 5 * 1000 then begin
          puser.LatestCmdTime := GetTickCount;
          LoginGetUpdateUser(puser, body);
        end else
          Memo1.Lines.Add('[Hacker Attack] UPDATEUSER ' + puser.UserId +
            '/' + puser.UserAddr);
      end;

      CM_CHANGEPASSWORD: begin
        if puser.UserId = '' then begin
          if GetTickCount - puser.LatestCmdTime > 5 * 1000 then begin
            puser.LatestCmdTime := GetTickCount;
            LoginChangePasswd(puser, body);
          end else
            Memo1.Lines.Add('[Hacker Attack] CHANGEPASSWORD ' +
              puser.UserId + '/' + puser.UserAddr);
        end else begin
          //�ߺ� ����
          puser.UserId := '';
        end;
      end;

    end;
  except
    Memo1.Lines.Add('Exception DecodeLogMessages ' + IntToStr(msg.Ident));
  end;

  Result := True;

end;


procedure TFrmMain.Memo1DblClick(Sender: TObject);
begin
  FrmGateSetting.Execute;
  LoadServerNames;
end;


{------------------------------------------------------}


procedure LoadAddressTable;
var
  i, n, maxg: integer;
  strlist:    TStringList;
  str, Data, serverstr, enstr, privateaddr, publicaddr, portstr: string;
begin
  FillChar(PubAddrTable, sizeof(PubAddrTable), #0);
  strlist := TStringList.Create;
  if FileExists(ADDRTABLE) then begin
    strlist.LoadFromFile(ADDRTABLE);
    n := 0;
    for i := 0 to strlist.Count - 1 do begin
      str := strlist[i];
      if str = '' then
        continue;
      if str[1] = ';' then
        continue;
      str := GetValidStr3(str, serverstr, [' ']);
      str := GetValidStr3(str, Data, [' ']);
      str := GetValidStr3(str, privateaddr, [' ']);
      str := GetValidStr3(str, publicaddr, [' ']);
      str := Trim(str);
      if (Data <> '') and (privateaddr <> '') and (publicaddr <> '') and
        (n < MAX_PUBADDR) then begin
        PubAddrTable[n].ServerName := serverstr;
        PubAddrTable[n].Title := Data;
        PubAddrTable[n].RemoteAddr := privateaddr;
        PubAddrTable[n].PublicAddr := publicaddr;
        maxg := 0;
        while (str <> '') do begin
          if maxg > 9 then
            break;
          str := GetValidStr3(str, Data, [' ']);
          if Data <> '' then begin
            if Data[1] = '*' then begin
              Data := Copy(Data, 2, Length(Data) - 1);
              PubAddrTable[n].PubGates[maxg].Enabled := False;
            end else
              PubAddrTable[n].PubGates[maxg].Enabled := True;
            portstr := GetValidStr3(Data, Data, [':']);
            PubAddrTable[n].PubGates[maxg].Addr := Data;
            PubAddrTable[n].PubGates[maxg].Port := Str_ToInt(portstr, 0);
            PubAddrTable[n].GIndex := 0;
            Inc(maxg);
          end;
          str := Trim(str);
        end;
        Inc(n);
      end;
    end;
    MaxPubAddr := n;
  end;
  strlist.Free;

  FrmMain.LoadServerNames;
end;

procedure SaveAddressTable;
var
  i, j:      integer;
  str, str2: string;
  strlist:   TStringList;
begin
  strlist := TStringList.Create;
  strlist.Add(';No space allowed');
  strlist.Add(fmStr(';Server', 15) + fmStr('Title', 15) + fmStr('Remote', 17) +
    fmStr('Public', 17) + 'Gates...');
  for i := 0 to MaxPubAddr - 1 do begin
    str := fmStr(PubAddrTable[i].ServerName, 15) +
      fmStr(PubAddrTable[i].Title, 15) + fmStr(PubAddrTable[i].RemoteAddr, 17) +
      fmStr(PubAddrTable[i].PublicAddr, 17);
    for j := 0 to 9 do begin
      if PubAddrTable[i].PubGates[j].Addr <> '' then begin
        str2 := PubAddrTable[i].PubGates[j].Addr;
        if not PubAddrTable[i].PubGates[j].Enabled then
          str2 := '*' + str2;
        str2 := str2 + ':' + IntToStr(PubAddrTable[i].PubGates[j].Port);
        str := str + fmStr(str2, 17);
      end else
        break;
    end;
    strlist.Add(str);
  end;
  strlist.SaveToFile(ADDRTABLE);
  strlist.Free;
end;


function IsValidGateAddr(addr: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to MaxPubAddr - 1 do begin
    if PubAddrTable[i].RemoteAddr = addr then begin
      Result := True;
      break;
    end;
  end;
end;

function GetPublicAddr(raddr: string): string;
var
  i: integer;
begin
  Result := raddr;
  for i := 0 to MaxPubAddr - 1 do begin
    if PubAddrTable[i].RemoteAddr = raddr then begin
      Result := PubAddrTable[i].PublicAddr;
      break;
    end;
  end;
end;

// remote public address�� �Է��ϸ�, Gate �� �Ѱ��� ���ϵȴ�.
function GetUserGateAddr(svname, addr: string; var port: integer): string;
var
  i, j, mg, n: integer;
  //garr: array[0..9] of integer;
  flag: boolean;
begin
  Result := '';
  for i := 0 to MaxPubAddr - 1 do begin
    if (PubAddrTable[i].ServerName = svname) and
      (PubAddrTable[i].PublicAddr = addr) then begin
      mg := 0;
      for j := 0 to 9 do begin
        if (PubAddrTable[i].PubGates[j].Addr <> '') and
          (PubAddrTable[i].PubGates[j].Enabled) then begin
          //garr[mg] := j;
          Inc(mg);
        end;
      end;
      if mg > 0 then begin
        n    := PubAddrTable[i].GIndex;
        flag := False;
        for j := n + 1 to 9 do
          if (PubAddrTable[i].PubGates[j].Addr <> '') and
            (PubAddrTable[i].PubGates[j].Enabled) then begin
            PubAddrTable[i].GIndex := j;
            flag := True;
            break;
          end;
        if not flag then
          for j := 0 to n do
            if (PubAddrTable[i].PubGates[j].Addr <> '') and
              (PubAddrTable[i].PubGates[j].Enabled) then begin
              PubAddrTable[i].GIndex := j;
              break;
            end;
        n      := PubAddrTable[i].GIndex;
        port   := PubAddrTable[i].PubGates[n].Port;
        Result := PubAddrTable[i].PubGates[n].Addr;
      end;
      break;
    end;
  end;
end;


{------------------------------------------------------}


procedure TFrmMain.DebugTimerTimer(Sender: TObject);
var
  uid, passwd, body: string;
const
  busy: boolean = False;
begin
  exit;
  if busy then
    exit;
  busy := True;

  while True do begin
      {uid := 'zura' + IntToStr(Random(1000));
      passwd := 'paringa'; //'efkdkekf';
      FrmDBSoc.CheckIdPasswd (uid, passwd, body);}

    //LogonQueryCharacter (nil, EncodeString('zura'));

    Application.ProcessMessages;
    if Application.Terminated then
      exit;
  end;
  busy := False;
end;

procedure TFrmMain.SpeedButton1Click(Sender: TObject);
begin
  FrmFindUserId.Show;
end;

procedure TFrmMain.BtnViewClick(Sender: TObject);
begin
  try
    slock.Enter;
    FrmAccountView.ListBox1.Items.Assign(FeedIDList);
    FrmAccountView.ListBox2.Items.Assign(FeedIPList);
  finally
    slock.Leave;
  end;
  FrmAccountView.Show;
end;

procedure TFrmMain.BtnShowServerUsersClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ServerCount - 1 do begin
    Memo1.Lines.Add(ServerUserCountArr[i].ServerName + ' ' +
      IntToStr(ServerUserCountArr[i].CurrentUser) + '/' +
      IntToStr(ServerUserCountArr[i].MaxUser));
  end;
end;


procedure TFrmMain.MakeApply_ID_List(idlist: TQuickList);
begin
  try
    slock.Enter;
    FeedIDList.Clear;
    FeedIDList.Assign(idlist);
  finally
    slock.Leave;
  end;
end;

procedure TFrmMain.MakeApply_IP_List(iplist: TQuickList);
begin
  try
    slock.Enter;
    FeedIPList.Clear;
    FeedIPList.Assign(iplist);
  finally
    slock.Leave;
  end;
end;

procedure TFrmMain.ReloadFeedTimerTimer(Sender: TObject);
begin
  //LoadFeedList (FALSE);
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if MessageDlg('Would you terminate Login-Server ?', mtWarning,
    mbOkCancel, 0) = mrOk then
    CanClose := True
  else
    CanClose := False;
end;


procedure TFrmMain.ApplyUserPrivateInfo(str: string);
var
  tag, uid, quiz, answer, quiz2, answer2, uname, birthday, phone, email: string;
  passwd: string;
  Data:   string;
  idx:    integer;
  ue:     TUserEntryInfo;
  ua:     TUserEntryAddInfo;
  rcd:    FIdRcd;
  flag:   boolean;
begin
  tag := Trim(Copy(str, 1, 5));
  str := Copy(str, 6, Length(str));

  if CompareText(tag, '*ch1*') = 0 then begin

    uid      := Trim(Copy(str, 1, 11));
    str      := Copy(str, 12, Length(str));
    quiz     := Trim(Copy(str, 1, 21));
    str      := Copy(str, 22, Length(str));
    answer   := Trim(Copy(str, 1, 13));
    str      := Copy(str, 14, Length(str));
    quiz2    := Trim(Copy(str, 1, 21));
    str      := Copy(str, 22, Length(str));
    answer2  := Trim(Copy(str, 1, 13));
    str      := Copy(str, 14, Length(str));
    uname    := Trim(Copy(str, 1, 21));
    str      := Copy(str, 22, Length(str));
    birthday := Trim(Copy(str, 1, 15));
    str      := Copy(str, 16, Length(str));
    phone    := Trim(Copy(str, 1, 15));
    str      := Copy(str, 16, Length(str));
    email    := Trim(Copy(str, 1, 26));

    flag := False;
    with FIdDb do begin
      try
        if OpenWr then begin
          idx := Find(uid);
          if idx >= 0 then begin
            if GetRecord(idx, rcd) >= 0 then begin
              ue      := rcd.Block.UInfo;
              ua      := rcd.Block.UAdd;
              //ue.Password :=
              ue.UserName := uname;
              //ue.SSNo     := birthday;
              ue.Phone := phone;
              ue.Quiz := quiz;
              ue.Answer := answer;
              ue.EMail := email;

              ua.Quiz2   := quiz2;
              ua.Answer2 := answer2;

              rcd.Block.UInfo := ue;
              rcd.Block.UAdd  := ua;

              SetRecord(idx, rcd);
              flag := True;
            end;
          end;
        end;
      finally
        Close;
      end;
    end;

    if not flag then
      Memo1.Lines.Add(uid + 'Record not found..  update fail');
  end;

  if CompareText(tag, '*chg*') = 0 then begin

    uid := Trim(Copy(str, 1, 11));
    str := Copy(str, 12, Length(str));
    CaptureString(str, passwd);

    flag := False;
    with FIdDb do begin
      try
        if OpenWr then begin
          idx := Find(uid);
          if idx >= 0 then begin
            if GetRecord(idx, rcd) >= 0 then begin
              ue := rcd.Block.UInfo;
              ue.Password := passwd;
              rcd.Block.UInfo := ue;
              SetRecord(idx, rcd);
              flag := True;
            end;
          end;
        end;
      finally
        Close;
      end;
    end;

    if not flag then
      Memo1.Lines.Add(uid + 'Record not found..  update fail');

  end;

end;

{procedure TFrmMain.UpdateWebLogFile (flname: string);
var
   i: integer;
   str: string;
   strlist: TStringList;
begin
   try
      if not FileExists (flname) then begin
         Memo1.Lines.Add ('[WebLog] File not found.. ' + flname);
         exit;
      end;
      strlist := TStringList.Create;
      strlist.LoadFromFile (flname);
      for i:=0 to strlist.Count-1 do begin
         str := Trim(strlist[i]);
         if str <> '' then begin
            ApplyUserPrivateInfo (str);
         end;
      end;
      strlist.Free;
   except
      Memo1.Lines.Add ('[WebLog] Update Error !!');
   end;
end; }

procedure TFrmMain.WebLogTimerTimer(Sender: TObject);
var
  i: integer;
  flname, logfile, str: string;
  fhandle: TextFile;
  strlist: TStringList;
begin
  flname := WebLogDir + 'InfoChg.txt'; //FILE.LOG';
  if FileExists(flname) then begin
    try
      strlist := TStringList.Create;
      strlist.LoadFromFile(flname);
      for i := 0 to strlist.Count - 1 do begin
        str := Trim(strlist[i]);
        if str <> '' then begin
          ApplyUserPrivateInfo(str);
        end;
      end;
      strlist.Free;
    except
      Memo1.Lines.Add(flname + ' Update failure.');
    end;

      (*  {$I-}
      AssignFile (fhandle, flname);
      Reset (fhandle);
      if IOResult <> 0 then exit;
      while not EOF(fhandle) do begin
         ReadLn (fhandle, logfile);
         if IOResult <> 0 then
            break;
         if logfile <> '' then
            UpdateWebLogFile (WebLogDir + logfile);
      end;
      CloseFile (fhandle);
      {$I+} *)

    DeleteFile(flname);
  end;
end;

procedure TFrmMain.BtnDumpClick(Sender: TObject);
var
  i, j, fhandle, curidx, oldpos: integer;
  rcd:     FIdRcd;
  header:  FDBHeader;
  rcdinfo: FIdRcdInfo;
  ue:      TUserEntryInfo;
  strlist: TStringList;
begin
  strlist := TStringList.Create;
  with FIdDb do begin
    fhandle := FileOpen(DBFileName, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then begin
      FileSeek(fhandle, 0, 0);
      if FileRead(fhandle, header, sizeof(FDBHeader)) = sizeof(FDBHeader) then begin
        for i := 0 to header.MaxCount - 1 do begin
          if FileRead(fhandle, rcd, sizeof(FIdRcd)) = sizeof(FIdRcd) then begin
            if not rcd.Deleted then begin
              ue := rcd.Block.UInfo;
              strlist.Add('*new* ' + FmStr2(ue.LoginId, 11) +
                FmStr2('"' + ue.Password + '"', 13) +
                FmStr2(ue.UserName, 21) + FmStr2(ue.SSno, 15) +
                FmStr2(ue.Phone, 15) + FmStr2(ue.Quiz, 21) +
                FmStr2(ue.Answer, 13) + FmStr2(ue.EMail, 26) +
                '[' + TimeToStr(Time));

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
      FileClose(fhandle);
    end;
  end;
  strlist.SaveToFile('IDDump.txt');
  strlist.Free;
end;

procedure TFrmMain.LogTimerTimer(Sender: TObject);
var
  ayear, amon, aday: word;
  monstr, flname: string;
  f: TextFile;
  dirname: array[0..255] of char;
  i: integer;
begin
  if CLogList.Count > 0 then begin
    DecodeDate(Date, ayear, amon, aday);
    monstr := '.\ConLog\' + IntToStr(ayear) + '-' + IntToStr(amon);
    if not FileExists(monstr) then begin
      StrPCopy(dirname, monstr);
      CreateDirectory(@dirname, nil);
    end;
    if aday < 10 then
      flname := monstr + '\Con_0' + IntToStr(aday) + '.log'
    else
      flname := monstr + '\Con_' + IntToStr(aday) + '.log';
    AssignFile(f, flname);
    if not FileExists(flname) then
      Rewrite(f)
    else
      Append(f);

    for i := 0 to CLogList.Count - 1 do begin
      WriteLn(f, CLogList[i]);
    end;
    CLogList.Clear;

    //Flush (f);
    CloseFile(f);
  end;

end;

procedure TFrmMain.MonitorTimerTimer(Sender: TObject);
var
  i, jump: integer;
  svname:  string;
begin
  with MonitorGrid do begin
    if (FrmMasSoc.ServerList.Count div 2) < 2 then
      RowCount := 2
    else
      RowCount := (FrmMasSoc.ServerList.Count div 2) + 1 +
        (FrmMasSoc.ServerList.Count mod 2);

    for i := 0 to FrmMasSoc.ServerList.Count - 1 do begin
      jump   := (i mod 2) * 3;
      svname := PTMsgServerInfo(FrmMasSoc.ServerList[i]).ServerName;
      if svname <> '' then begin
        if PTMsgServerInfo(FrmMasSoc.ServerList[i]).ServerIndex = 99 then
          Cells[jump, 1 + i div 2] := svname + ' [DB]'
        else
          Cells[jump, 1 + i div 2] :=
            svname + ' ' + IntToStr(
            PTMsgServerInfo(FrmMasSoc.ServerList[i]).ServerIndex);
        Cells[jump + 1, 1 + i div 2] :=
          IntToStr(PTMsgServerInfo(FrmMasSoc.ServerList[i]).UserCount);
        if GetTickCount - PTMsgServerInfo(FrmMasSoc.ServerList[i]).CheckTime <
          30 * 1000 then begin
          Cells[jump + 2, 1 + i div 2] := 'Good';
        end else
          Cells[jump + 2, 1 + i div 2] := 'Timeout';
      end else begin
        Cells[jump, 1 + i div 2]     := '-';
        Cells[jump + 1, 1 + i div 2] := '-';
        Cells[jump + 2, 1 + i div 2] := '-';
      end;
    end;
  end;

end;

procedure TFrmMain.CountLogTimerTimer(Sender: TObject);
begin
  WriteUserCountLog(IntToStr(TotalUserCount) + '/' + IntToStr(MaxTotalUserCount));
  MaxTotalUserCount := 0;
end;

procedure TFrmMain.SpeedButton2Click(Sender: TObject);
begin
  if Memo1.ClientHeight = OldMemoHeight then
    Memo1.ClientHeight := OldMemoHeight * 4
  else
    Memo1.ClientHeight := OldMemoHeight;
end;

end.
