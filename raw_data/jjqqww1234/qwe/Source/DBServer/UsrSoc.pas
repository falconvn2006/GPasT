unit UsrSoc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp, syncobjs, Grobal2, HUtil32, EdCode, mudutil, MfdbDef, HumDB,
  ExtCtrls, Inifiles;

const
  MAXPLAYSERVER = 20;

type
  TGateInfo = record
    GateSocket: TCustomWinSocket;
    RemoteAddr: string;
    SocData:    string;
    UserList:   TList;             // list of PTUserInfo
    ConnCheckTime: integer;        // ������� äũ �ð�
  end;
  PTGateInfo = ^TGateInfo;

  TUserInfo = record
    UserId:      string[10];
    UserAddr:    string[20];
    UserHandle:  string;
    Certification: integer;
    CSocket:     TCustomWinSocket;
    UserSocData: string;
    SelChrFinished: boolean;
    QueryChrFinished: boolean;
    ConnectTime: longword;        // ó�� ������ �ð�,
    LatestCmdTime: longword;
  end;
  PTUserInfo = ^TUserInfo;

  TServerConnInfo = record
    Remote: string;
    Addr:   string;
    Port:   integer;
    Addr2:  string;
    Port2:  integer;
    Addr3:  string;
    Port3:  integer;
  end;

  TFrmUserSoc = class(TForm)
    UserSocket: TServerSocket;
    Timer1:     TTimer;
    procedure UserSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure UserSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure UserSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure UserSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    sLock:    TCriticalSection;
    Def:      TDefaultMessage;
    //GateLocalAddr, GatePublicAddr: TStringList;
    GateList: TList;    // list of PTGateInfo
    GateConnArr: array[0..MAXPLAYSERVER - 1] of TServerConnInfo;
    WorkGate: PTGateInfo;
    MapServers: TStringList;

    //function  GetPublicAddr (laddr: string): string;
    procedure SendGateSocket(asocket: TCustomWinSocket; shandle, socstr: string);
    procedure ReceiveCheckCode(asocket: TCustomWinSocket);
    procedure ReceiveOpenUser(uhandle, usraddr: string; pg: PTGateInfo);
    procedure ReceiveCloseUser(uhandle: string; pg: PTGateInfo);
    procedure ProcessUserData(pu: PTUserInfo);
    procedure DecodeSocData(pg: PTGateInfo);
    function DecodeMessages(Data: string; pu: PTUserInfo): boolean;
    function GetQueryChr(body: string; pu: PTUserInfo): boolean;
    procedure GetNewChr(body: string; pu: PTUserInfo);
    procedure GetDelChr(body: string; pu: PTUserInfo);
    function GetSelChr(body: string; pu: PTUserInfo): boolean;
    procedure SendOutofConnection(pu: PTUserInfo);
    function GetServerFromMap(map: string): integer;
    function GetRunServerAddr(remote: string): string;
    function GetRunServerPort(remote: string): integer;
  public
    function UserCount: integer;
    procedure LoadAddrTables;
    function CreateNewFDB(uname: string; sex, job, hair: integer): boolean;
  end;

var
  FrmUserSoc: TFrmUserSoc;
  MapFile:    string; //�� ���� �̸�
  ErrorSum:   integer;

implementation

{$R *.DFM}

uses
  DBSMain, IDSocCli, FDBexpl;

procedure TFrmUserSoc.LoadAddrTables;
var
  i, svindex: integer;
  strlist: TStringList;
  str, raddr, laddr, paddr, Data, sport, map, maptitle, servernum: string;
  ini: TIniFile;
begin
  strlist := TStringList.Create;
  FillChar(GateConnArr, sizeof(TServerConnInfo) * MAXPLAYSERVER, #0);
  strlist.LoadFromFile('!serverinfo.txt');
  for i := 0 to MAXPLAYSERVER - 1 do begin
    if i >= strlist.Count then
      break;
    str := strlist[i];
    if str <> '' then begin
      Data := GetValidStr3(str, raddr, [' ', #9]);
      Data := GetValidStr3(Data, laddr, [' ', #9]);
      Data := GetValidStr3(Data, sport, [' ', #9]);
      GateConnArr[i].Remote := Trim(raddr);
      GateConnArr[i].Addr := Trim(laddr);
      GateConnArr[i].Port := Str_ToInt(sport, 0);
      if Data <> '' then begin
        Data := GetValidStr3(Data, laddr, [' ', #9]);
        Data := GetValidStr3(Data, sport, [' ', #9]);
        GateConnArr[i].Addr2 := Trim(laddr);
        GateConnArr[i].Port2 := Str_ToInt(sport, 0);
      end;
      if Data <> '' then begin
        Data := GetValidStr3(Data, laddr, [' ', #9]);
        Data := GetValidStr3(Data, sport, [' ', #9]);
        GateConnArr[i].Addr3 := Trim(laddr);
        GateConnArr[i].Port3 := Str_ToInt(sport, 0);
      end;
    end;
  end;

  ini := TIniFile.Create('.\dbsrc.ini');
  if ini <> nil then begin
    MapFile := ini.ReadString('Setup', 'MapFile', 'mapinfo.txt');
    ini.Free;
  end;
  MapServers.Clear;

  if FileExists(MapFile) then begin
    strlist.Clear;
    strlist.LoadFromFile(MapFile);

    //�������� �ٽ� �д´�.
    for i := 0 to strlist.Count - 1 do begin
      str := strlist[i];
      if str <> '' then begin
        if str[1] = '[' then begin
          str      := ArrestStringEx(str, '[', ']', map);
          maptitle := GetValidStr3(map, map, [' ', ',', #9]);
          servernum := Trim(GetValidStr3(maptitle, maptitle, [' ', ',', #9]));
          svindex  := Str_ToInt(servernum, 0);
          MapServers.AddObject(map, TObject(svindex));
        end;
      end;
    end;
  end;
  strlist.Free;
end;

function TFrmUserSoc.GetServerFromMap(map: string): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to MapServers.Count - 1 do begin
    if map = MapServers[i] then begin
      Result := integer(MapServers.Objects[i]);
      break;
    end;
  end;
end;

{function  TFrmUserSoc.GetPublicAddr (laddr: string): string;
var
   i: integer;
begin
   Result := laddr;
   for i:=0 to GateLocalAddr.Count-1 do
      if GateLocalAddr[i] = laddr then begin
         Result := GatePublicAddr[i];
         break;
      end;
end;}

function TFrmUserSoc.GetRunServerAddr(remote: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to MAXPLAYSERVER - 1 do begin
    if GateConnArr[i].Remote = remote then begin
      if GateConnArr[i].Addr2 <> '' then begin
        if GateConnArr[i].Addr3 <> '' then begin
          case Random(3) of
            0: Result := GateConnArr[i].Addr;
            1: Result := GateConnArr[i].Addr2;
            2: Result := GateConnArr[i].Addr3;
          end;
        end else begin
          if Random(2) = 0 then
            Result := GateConnArr[i].Addr
          else
            Result := GateConnArr[i].Addr2;
        end;
      end else
        Result := GateConnArr[i].Addr;
      break;
    end;
  end;
end;

function TFrmUserSoc.GetRunServerPort(remote: string): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to MAXPLAYSERVER - 1 do begin
    if GateConnArr[i].Remote = remote then begin
      if GateConnArr[i].Addr2 <> '' then begin
        if GateConnArr[i].Addr3 <> '' then begin
          case Random(3) of
            0: Result := GateConnArr[i].Port;
            1: Result := GateConnArr[i].Port2;
            2: Result := GateConnArr[i].Port3;
          end;
        end else begin
          if Random(2) = 0 then
            Result := GateConnArr[i].Port
          else
            Result := GateConnArr[i].Port2;
        end;
      end else
        Result := GateConnArr[i].Port;
      break;
    end;
  end;
end;

procedure TFrmUserSoc.FormCreate(Sender: TObject);
begin
  ErrorSum   := -1;
  sLock      := TCriticalSection.Create;
  GateList   := TList.Create;
  MapServers := TStringList.Create;
  with UserSocket do begin
    Port   := 5100;
    Active := True;
  end;
  FillChar(GateConnArr, sizeof(TServerConnInfo) * MAXPLAYSERVER, #0);

  //GateLocalAddr := TStringList.Create;
  //GatePublicAddr := TStringList.Create;
  LoadAddrTables;
  LoadAbusiveList('!Abuse.txt');
end;

procedure TFrmUserSoc.FormDestroy(Sender: TObject);
var
  i, j:  integer;
  ginfo: PTGateInfo;
begin
  for i := 0 to GateList.Count - 1 do begin
    ginfo := PTGateInfo(GateList[i]);
    for j := 0 to ginfo.UserList.Count - 1 do
      Dispose(PTUserInfo(ginfo.UserList[j]));
    Dispose(ginfo);
  end;
  GateList.Free;
  MapServers.Free;
  sLock.Free;
end;

procedure TFrmUserSoc.UserSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  ginfo: PTGateInfo;
begin
  new(ginfo);
  with ginfo^ do begin
    GateSocket := Socket;
    RemoteAddr := Socket.RemoteAddress;
    //Trim (GetPublicAddr (Socket.RemoteAddress));
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
end;

procedure TFrmUserSoc.UserSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i, j:  integer;
  ginfo: PTGateInfo;
begin
  try
    sLock.Enter;
    for i := 0 to GateList.Count - 1 do begin
      if PTGateInfo(GateList[i]).GateSocket = socket then begin
        ginfo := PTGateInfo(GateList[i]);
        for j := 0 to ginfo.UserList.Count - 1 do begin
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

procedure TFrmUserSoc.UserSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmUserSoc.UserSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  i:  integer;
  pg: PTGateInfo;
begin
  try
    sLock.Enter;
    for i := 0 to GateList.Count - 1 do begin
      if PTGateInfo(GateList[i]).GateSocket = Socket then begin
        pg := PTGateInfo(GateList[i]);
        WorkGate := pg;
        pg.SocData := pg.SocData + Socket.ReceiveText;
        if Length(pg.SocData) < 8192 then begin
          if pos('$', pg.SocData) >= 1 then begin  //%....$
            DecodeSocData(pg);
          end;
        end else begin
          //ó�� ���� �����Ͱ� 80K�̻��̸� �ʱ�ȭ �Ѵ�.
          pg.SocData := '';
        end;
        break;
      end;
    end;
  finally
    sLock.Leave;
  end;
end;

function TFrmUserSoc.UserCount: integer;
var
  i, Count: integer;
begin
  Count := 0;
  try
    sLock.Enter;
    for i := 0 to GateList.Count - 1 do begin
      Count := Count + PTGateInfo(GateList[i]).UserList.Count;
    end;
  finally
    sLock.Leave;
  end;
  Result := Count;
end;

procedure TFrmUserSoc.SendGateSocket(asocket: TCustomWinSocket;
  shandle, socstr: string);
begin
  asocket.SendText('%' + shandle + '/#' + socstr + '!$');
end;

procedure TFrmUserSoc.ReceiveCheckCode(asocket: TCustomWinSocket);
begin
  if asocket.Connected then begin
    asocket.SendText('%++$');
  end;
end;

procedure TFrmUserSoc.ReceiveOpenUser(uhandle, usraddr: string; pg: PTGateInfo);
var
  i:      integer;
  puinfo: PTUserInfo;
begin
  for i := 0 to pg.UserList.Count - 1 do begin
    puinfo := PTUserInfo(pg.UserList[i]);
    if puinfo.UserHandle = uhandle then begin
      puinfo.UserAddr    := usraddr;
      puinfo.UserId      := '';
      puinfo.Certification := 0;
      puinfo.UserSocData := '';
      puinfo.ConnectTime := GetTickCount;
      puinfo.LatestCmdTime := GetTickCount;
      puinfo.SelChrFinished := False;
      puinfo.QueryChrFinished := False;
      exit;
    end;
  end;
  new(puinfo);
  with puinfo^ do begin
    UserId      := '';
    UserAddr    := usraddr;
    UserHandle  := uhandle;
    Certification := 0;    // not certificated..
    CSocket     := pg.GateSocket;
    UserSocData := '';
    ConnectTime := GetTickCount;
    LatestCmdTime := GetTickCount;
    SelChrFinished := False;
    QueryChrFinished := False;
  end;
  pg.UserList.Add(puinfo);
end;

procedure TFrmUserSoc.ReceiveCloseUser(uhandle: string; pg: PTGateInfo);
var
  i:  integer;
  pu: PTUserInfo;
begin
  for i := 0 to pg.UserList.Count - 1 do begin
    if PTUserInfo(pg.UserList[i]).UserHandle = uhandle then begin
      pu := PTUserInfo(pg.UserList[i]);
      //���� �����̸� Certification ���� ����
      if not FrmIDSoc.IsSelectedAdmision(pu.Certification) then begin
        //Select���� ���� ���� ����
        FrmIDSoc.SendIDSMsg(ISM_USERCLOSED, pu.UserId + '/' +
          IntToStr(pu.Certification));
        FrmIDSoc.DelAdmission(pu.Userid, pu.Certification);
      end;
      Dispose(PTUserInfo(pg.UserList[i]));
      pg.UserList.Delete(i);
      break;
    end;
  end;
end;

procedure TFrmUserSoc.ProcessUserData(pu: PTUserInfo);
var
  errcount: integer;
  msg:      string;
begin
  errcount := 0;
  while pu.UserSocData <> '' do begin  // #FDSAFDJSAFDSA!
    if CharCount(pu.UserSocData, '!') <= 0 then
      break;
    pu.UserSocData := ArrestStringEx(pu.UserSocData, '#', '!', msg);
    if msg <> '' then begin
      msg := Copy(msg, 2, Length(msg) - 1);
      if Length(msg) >= DEFBLOCKSIZE then begin
        if Length(msg) > DEFBLOCKSIZE + 50 then begin
          Inc(HackCountErrorPacket5);
        end else begin
          DecodeMessages(msg, pu);
        end;
      end else
        Inc(HackCountErrorPacket2);
    end else begin
      Inc(HackCountErrorPacket1);
      if errcount >= 1 then begin
        pu.UserSocData := '';
      end;
      Inc(errcount);
      //break;
    end;
  end;
end;

procedure TFrmUserSoc.DecodeSocData(pg: PTGateInfo);
var
  str, Data, shandle, addr: string;
  tag: char;
  i, errcount: integer;
  pu:  PTUserInfo;
begin
  try
    errcount := 0;
    while True do begin
      if pos('$', pg.SocData) <= 0 then
        break;
      pg.SocData := ArrestStringEx(pg.SocData, '%', '$', Data);
      if Data <> '' then begin
        tag  := Data[1];
        Data := Copy(Data, 2, Length(Data) - 1);
        case word(tag) of
          word('-'): begin
            ReceiveCheckCode(pg.GateSocket);
            pg.ConnCheckTime := GetCurrentTime;
          end;

          word('O'): begin
            Data    := GetValidStr3(Data, str, ['/']);
            //str : user handle
            //data : user remote address
            shandle := str;
            addr    := Data;
            ReceiveOpenUser(shandle, addr, pg);
          end;

          word('X'): begin
            shandle := Data;
            ReceiveCloseUser(shandle, pg);
          end;

          word('A'): begin
            Data := GetValidStr3(Data, shandle, ['/']);
            for i := 0 to pg.UserList.Count - 1 do begin
              if PTUserInfo(pg.UserList[i]).UserHandle = shandle then begin
                pu := PTUserInfo(pg.UserList[i]);
                pu.UserSocData := pu.UserSocData + Data;

                if pos('!', pu.UserSocData) >= 1 then begin
                  ProcessUserData(pu);
                end;

                //�ҷ� ��Ŷ ���� ����
                if Length(pu.UserSocData) > 512 then
                  pu.UserSocData := '';
                break;
              end;
            end;
          end;
          else begin
            if errcount >= 1 then
              pg.SocData := '';
            Inc(HackCountErrorPacket4);
            Inc(errcount);
          end;
        end;

      end else begin
        if errcount >= 1 then
          pg.SocData := '';
        Inc(HackCountErrorPacket4);
        Inc(errcount);
      end;

    end;
  except
  end;
end;

function TFrmUserSoc.GetQueryChr(body: string; pu: PTUserInfo): boolean;
var
  uid, certifystr: string;
  strlist: TStringList;
  i, idx, humidx, certify: integer;
  rstr, uname, sface, sjob, slevel, sdata, sexname: string;
  sex:     byte;
  fail:    boolean;
  rcd:     FDBRecord;
  humrcd:  FHumRcd;
  Count:   integer;
begin
  Result     := False;
  certifystr := GetValidStr3(DecodeString(body), uid, ['/']);
  certify    := Str_ToInt(certifystr, -2);
  pu.Certification := certify;
  Count      := 0;

  //certifystr�� �α��μ����� ���� ���� ������Ͽ� �ִ��� �˻��Ѵ�.
  if FrmIDSoc.GetAdmission(uid, pu.UserAddr, certify) then begin //�����̵� ��������

    FrmIDSoc.ClearSelectedAdmission(certify); //�������ΰ�� <ĳ����������> �ʱ�ȭ

    pu.UserId := uid;
    strlist   := TStringList.Create;
    with FHumDB do begin
      try
        if OpenWr then begin
          if FindUserId(uid, strlist) > 0 then begin
            try
              if FDB.OpenRd then begin
                for i := 0 to strlist.Count - 1 do begin
                  humidx := PTIdInfo(strlist.Objects[i]).ridx;
                  if FHumDb.GetRecordDr(humidx, humrcd) then begin
                    if not humrcd.Block.Delete then begin
                      uname := PTIdInfo(strlist.Objects[i]).uname;
                      idx   := FDB.Find(uname);
                      if (idx >= 0) and (Count < 2) then begin
                        if FDB.GetRecord(idx, rcd) >= 0 then begin
                          sex    := rcd.Block.DBHuman.Sex;
                          sjob   := IntToStr(rcd.Block.DBHuman.Job);
                          sface  := IntToStr(rcd.Block.DBHuman.Hair);
                          slevel := IntToStr(rcd.Block.DBHuman.Abil.Level);
                          if humrcd.Block.Selected then
                            sdata := sdata + '*';
                          sdata :=
                            sdata + uname + '/' + sjob + '/' + sface +
                            '/' + slevel + '/' + IntToStr(sex) + '/';
                          Inc(Count);
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
    Def := MakeDefaultMsg(SM_QUERYCHR, Count, 0, 0, 1);  {OK}
    SendGateSocket(pu.CSocket, pu.UserHandle, EncodeMessage(Def) +
      EncodeString(sdata));
    Result := True;
  end else begin
    Def := MakeDefaultMsg(SM_QUERYCHR_FAIL, Count, 0, 0, 1);  {FAIL}
    SendGateSocket(pu.CSocket, pu.UserHandle, EncodeMessage(Def));
    ReceiveCloseUser(pu.UserHandle, WorkGate);
  end;
end;

function TFrmUserSoc.CreateNewFDB(uname: string; sex, job, hair: integer): boolean;
var
  idx: integer;
  rcd: FDBRecord;
begin
  Result := False;
  FillChar(rcd, sizeof(FDBRecord), #0);
  with FDB do begin
    try
      if OpenWr then begin
        idx := Find(uname);
        if idx = -1 then begin
          rcd.Key := uname;
          rcd.Block.DBHuman.UserName := uname;
          rcd.Block.DBHuman.Sex := sex;
          rcd.Block.DBHuman.Job := job;
          rcd.Block.DBHuman.Hair := hair;
          AddRecord(rcd);
          Result := True;
        end;
      end;
    finally
      Close;
    end;
  end;
end;

procedure TFrmUserSoc.GetNewChr(body: string; pu: PTUserInfo);
var
  str, uid, uname, shair, sjob, ssex: string;
  i, error: integer;
  fhum:     FHumRcd;
begin
  error := -1;
  if BoEnableNewChar then begin
    str := DecodeString(body);
    str := GetValidStr3(str, uid, ['/']);
    str := GetValidStr3(str, uname, ['/']);
    str := GetValidStr3(str, shair, ['/']);
    str := GetValidStr3(str, sjob, ['/']);
    str := GetValidStr3(str, ssex, ['/']);
    if Trim(str) <> '' then
      error := 0;

    uname := Trim(uname);
    if Length(uname) < 3 then
      error := 0;
    ChangeAbusiveText(uname);

    if BoKoreaVersion then begin
      if not CheckValidUserName(uname) then
        error := 0;
    end;

    for i := 1 to Length(uname) do begin
      if (uname[i] = ' ') or (uname[i] = '/') or (uname[i] = '@') or
        (uname[i] = '?') or (uname[i] = '''') or (uname[i] = '"') or
        (uname[i] = '\') or (uname[i] = '.') or (uname[i] = ',') or
        (uname[i] = ':') or (uname[i] = ';') or (uname[i] = '`') or
        (uname[i] = '~') or (uname[i] = '!') or (uname[i] = '#') or
        (uname[i] = '$') or (uname[i] = '%') or (uname[i] = '^') or
        (uname[i] = '&') or (uname[i] = '*') or (uname[i] = '(') or
        (uname[i] = ')') or (uname[i] = '-') or (uname[i] = '_') or
        (uname[i] = '+') or (uname[i] = '=') or (uname[i] = '|') or
        (uname[i] = '[') or (uname[i] = '{') or (uname[i] = ']') or (uname[i] = '}') then
        error := 0; //invalid name
    end;

    try
      FDB.LockDB;
      if FDB.Find(uname) >= 0 then
        error := 2; // already exists
    finally
      FDB.UnlockDB;
    end;
    FillChar(fhum, sizeof(FHumRcd), #0);
    if error = -1 then begin
      with FHumDB do begin
        try
          if OpenWr then begin
            if FindUserIdCount(uid) < 2 then begin
              fhum.Block.ChrName := uname;
              fhum.Block.UserId := uid;
              fhum.Block.Delete := False;
              fhum.Block.Mark := 0;
              fhum.Key := uname;
              if fhum.Key <> '' then begin
                if not AddRecord(fhum) then
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
        if CreateNewFDB(uname, Str_ToInt(ssex, 0), Str_ToInt(sjob, 0),
          Str_ToInt(shair, 0)) then
          error := 1 // success
        else begin
          FrmDbSrv.EraseHumDb(uname);   //fail
          error := 4;
        end;
      end;
    end;
  end;

  if error = 1 then
    Def := MakeDefaultMsg(SM_NEWCHR_SUCCESS, error, 0, 0, 0)  {OK}
  else
    Def := MakeDefaultMsg(SM_NEWCHR_FAIL, error, 0, 0, 0);
  SendGateSocket(pu.CSocket, pu.UserHandle, EncodeMessage(Def));
end;

procedure TFrmUserSoc.GetDelChr(body: string; pu: PTUserInfo);
var
  idx:    integer;
  uname:  string;
  humrcd: FHumRcd;
  fail:   boolean;
begin
  uname := DecodeString(body);
  fail  := True;
  with FHumDB do begin
    try
      if OpenWr then begin
        idx := Find(uname);
        if idx >= 0 then begin
          GetRecord(idx, humrcd);
          if humrcd.Block.UserId = pu.UserId then begin
            humrcd.Block.Delete     := True;
            humrcd.Block.DeleteDate := PackDouble(Date);
            SetRecord(idx, humrcd);
            fail := False;
          end;
        end;
      end;
    finally
      Close;
    end;
  end;
  if not fail then
    Def := MakeDefaultMsg(SM_DELCHR_SUCCESS, 1, 0, 0, 0)  {OK}
  else
    Def := MakeDefaultMsg(SM_DELCHR_FAIL, 0, 0, 0, 0);  {Fail}
  SendGateSocket(pu.CSocket, pu.UserHandle, EncodeMessage(Def));
end;

function TFrmUserSoc.GetSelChr(body: string; pu: PTUserInfo): boolean;
var
  i, idx, ServerIndex, humidx: integer;
  chrname, uid, map, serveraddr, serverport: string;
  rcd:     FDBRecord;
  humrcd:  FHumRcd;
  ok:      boolean;
  strlist: TStringList;
begin
  Result  := False;
  chrname := GetValidStr3(DecodeString(body), uid, ['/']);
  ok      := False;
  if uid = pu.UserId then begin
    with FHumDB do begin
      try
        if OpenWr then begin
          strlist := TStringList.Create;
          if FindUserId(uid, strlist) > 0 then begin
            for i := 0 to strlist.Count - 1 do begin
              humidx := PTIdInfo(strlist.Objects[i]).ridx;
              if FHumDb.GetRecordDr(humidx, humrcd) then begin
                if humrcd.Block.ChrName = chrname then begin
                  humrcd.Block.Selected := True;
                  SetRecordDr(humidx, humrcd);
                end else if humrcd.Block.Selected then begin
                  humrcd.Block.Selected := False;
                  SetRecordDr(humidx, humrcd);
                end;
              end;
            end;
          end;
          strlist.Free;
        end;
      finally
        Close;
      end;
    end;
    with FDB do begin
      try
        if OpenRd then begin
          idx := Find(chrname);
          if idx >= 0 then begin
            GetRecord(idx, rcd);
            map := rcd.Block.DBHuman.MapName;
            ok  := True;
          end;
        end;
      finally
        Close;
      end;
    end;
  end;
  if ok then begin
    ServerIndex := GetServerFromMap(map);  //��Ƽ�����ΰ�� ������Ʈ+1�� �ȴ�.
    //if ServerIndex in [0..MAXPLAYSERVER-1] then begin
    Def := MakeDefaultMsg(SM_STARTPLAY, 0, 0, 0, 0);  {OK}
    SendGateSocket(pu.CSocket, pu.UserHandle,
      EncodeMessage(Def) + EncodeString(GetRunServerAddr(WorkGate.RemoteAddr) +
      '/' + IntToStr(GetRunServerPort(WorkGate.RemoteAddr) + ServerIndex))
      );
    //Admission������ ���õǾ����� ǥ��, �׷��� socket.close�Ǿ����� ��������� �������� ����
    FrmIDSoc.CheckSelectedAdmission(pu.Certification);
    Result := True;
    //end else begin
    //   Def := MakeDefaultMsg (SM_STARTFAIL, 0, 0, 0, 0);  {Fail}
    //   SendGateSocket (pu.CSocket, pu.UserHandle, EncodeMessage (Def));
    //end;
  end else begin
    Def := MakeDefaultMsg(SM_STARTFAIL, 0, 0, 0, 0);  {Fail}
    SendGateSocket(pu.CSocket, pu.UserHandle, EncodeMessage(Def));
  end;
end;

procedure TFrmUserSoc.SendOutofConnection(pu: PTUserInfo);
begin
  Def := MakeDefaultMsg(SM_OUTOFCONNECTION, 0, 0, 0, 0);  {Fail}
  SendGateSocket(pu.CSocket, pu.UserHandle, EncodeMessage(Def));
end;

function TFrmUserSoc.DecodeMessages(Data: string; pu: PTUserInfo): boolean;
var
  msg: TDefaultMessage;
  cport, serverindex, certify: integer;
  head, body, idstr, newaddress: string;
  //logobj: TObject;
begin
  Result := False;
  head   := Copy(Data, 1, DEFBLOCKSIZE);
  body   := Copy(Data, DEFBLOCKSIZE + 1, Length(Data) - DEFBLOCKSIZE);
  msg    := DecodeMessage(head);

  case msg.Ident of
    CM_QUERYCHR: begin
      if (not pu.QueryChrFinished) or (GetTickCount - pu.LatestCmdTime > 200) then
      begin
        pu.LatestCmdTime := GetTickCount;
        if GetQueryChr(body, pu) then
          pu.QueryChrFinished := True;
      end else begin
        Inc(HackCountQueryChr);
        if FrmDBSrv.CkViewHackMsg.Checked then
          AddLog('[Hacker Attack] _QUERYCHR ' + pu.UserId + '/' + pu.UserAddr);
      end;
    end;
    CM_NEWCHR: begin
      if GetTickCount - pu.LatestCmdTime > 1000 then begin
        pu.LatestCmdTime := GetTickCount;
        if (pu.UserId <> '') and FrmIDSoc.GetAdmission(pu.UserId,
          pu.UserAddr, pu.Certification) then begin
          GetNewChr(body, pu);
          pu.QueryChrFinished := False;
        end else
          SendOutofConnection(pu);
      end else begin
        Inc(HackCountNewChr);
        if FrmDBSrv.CkViewHackMsg.Checked then
          AddLog('[Hacker Attack] _NEWCHR ' + pu.UserId + '/' + pu.UserAddr);
      end;
    end;
    CM_DELCHR: begin
      if GetTickCount - pu.LatestCmdTime > 1000 then begin
        pu.LatestCmdTime := GetTickCount;
        if (pu.UserId <> '') and FrmIDSoc.GetAdmission(pu.UserId,
          pu.UserAddr, pu.Certification) then begin
          GetDelChr(body, pu);
          pu.QueryChrFinished := False;
        end else
          SendOutofConnection(pu);
      end else begin
        Inc(HackCountDelChr);
        if FrmDBSrv.CkViewHackMsg.Checked then
          AddLog('[Hacker Attack] _DELCHR ' + pu.UserId + '/' + pu.UserAddr);
      end;
    end;
    CM_SELCHR: begin
      if not pu.SelChrFinished then begin
        if (pu.UserId <> '') and FrmIDSoc.GetAdmission(pu.UserId,
          pu.UserAddr, pu.Certification) then begin
          if GetSelChr(body, pu) then
            pu.SelChrFinished := True;
        end else
          SendOutofConnection(pu);
      end else begin
        Inc(HackCountSelChr);
        if FrmDBSrv.CkViewHackMsg.Checked then
          AddLog('Double send _SELCHR ' + pu.UserId + '/' + pu.UserAddr);
      end;
    end;
    else begin
      //pu.CSocket.Close;
      Inc(HackCountErrorPacket3);
    end;
  end;
end;


procedure TFrmUserSoc.Timer1Timer(Sender: TObject);
var
  sum: integer;
begin
  sum := HackCountQueryChr + HackCountNewChr + HackCountDelChr +
    HackCountSelChr + HackCountErrorPacket1 + HackCountErrorPacket2 +
    HackCountErrorPacket3 + HackCountErrorPacket4 + HackCountErrorPacket5;

  if ErrorSum <> sum then begin
    ErrorSum := sum;
    AddLog('H-QyChr=' + IntToStr(HackCountQueryChr) + ' ' + 'H-NwChr=' +
      IntToStr(HackCountNewChr) + ' ' + 'H-DlChr=' + IntToStr(HackCountDelChr) +
      ' ' + 'Dubl-Sl=' + IntToStr(HackCountSelChr) + ' ' + 'P1=' +
      IntToStr(HackCountErrorPacket1) + ' ' + 'P2=' + IntToStr(HackCountErrorPacket2) +
      ' ' + 'P3=' + IntToStr(HackCountErrorPacket3) + ' ' + 'P4=' +
      IntToStr(HackCountErrorPacket4) + ' ' + 'P5=' + IntToStr(HackCountErrorPacket5)
      );
  end;
end;

end.
