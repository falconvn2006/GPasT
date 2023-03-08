unit GateMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  syncobjs, StdCtrls, ScktComp, HUtil32, ExtCtrls, Winsock,
  IniFiles;

const
  VER_STR   = 'v040225:';
  MAX_USER  = 1000;
  MAX_CLIENTRECEIVELENGTH = 300; // 100 BYTE PER SEC
  MAX_CHECKSENDLENGTH = 512;
  MAX_RADDR = 4;
  //   SERVERBASEPORT = 5100;
  //   USERBASEPORT = 7100;
  ServerPort: integer = 5100;
  GateBasePort: integer = 7100;

type
  {TSendDataInfo = record
    shandle:  integer;
    RemoteAddr: string;
     Socket: TCustomWinSocket;
    sendlist: TStringList;
  end;}

  TUserInfo = record
    Socket:    TCustomWinSocket;
    Addr:      string;
    SendLength: integer;
    SendLock:  boolean;
    SendLatestTime: longword;
    CheckSendLength: integer;
    SendAvailable: boolean;
    SendCheck: boolean;
    TimeOutTime: longword;
    ReceiveLength: integer;
    ReceiveTime: longword;
    shandle:   integer;
    RemoteAddr: string;
    sendlist:  TStringList;
  end;
  PTUserInfo=^TUserInfo;

  TFrmMain = class(TForm)
    ServerSocket: TServerSocket;
    Memo:      TMemo;
    SendTimer: TTimer;
    ClientSocket: TClientSocket;
    Panel1:    TPanel;
    Label1:    TLabel;
    LbConStatue: TLabel;
    EdUserCount: TEdit;
    Timer1:    TTimer;
    BtnRun:    TButton;
    DecodeTimer: TTimer;
    LbHold:    TLabel;
    LbLack:    TLabel;
    Label2:    TLabel;
    CbAddrs:   TComboBox;
    CbShowMessages: TCheckBox;
    procedure ServerSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure MemoChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure SendTimerTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnRunClick(Sender: TObject);
    procedure DecodeTimerTimer(Sender: TObject);
    procedure MemoDblClick(Sender: TObject);
    procedure CbAddrsChange(Sender: TObject);
  private
    UserCount:   integer;
    lastsendstr: string;
    DisplayMsg:  TStringList;
    chktime:     longword;
    connected:   boolean;
    LackAddrs:   TStringList;
    loopstarttime: longword;
    looptime:    longword;
    tryconntime: longword;
    procedure SetSendAvailable(uindex: integer);
    function DataReceiveOK(uindex, alen: integer): boolean;
    procedure ClearSendDataInfo;
    procedure KickUser(usrhandle: integer);
  public
    function SendServerToClient(UInfo: TUserInfo; str: string): integer;
  end;

var
  FrmMain:     TFrmMain;
  //ServerSocData: string;
  ServerSocList: TStringList;
  //SocLock: TCriticalSection;
  //UsrLock: TCriticalSection;
  //CSSockLock: TRTLCriticalSection;
  //CSUserLock: TRTLCriticalSection;
  ServerAddrList: TStringList;
  ServerIndex: integer;

  ServerConnection: boolean;
  ServerCheckTime: longword;
  ServerBusy:   boolean;
  SendHoldCount: integer;
  ServerSendHolds: integer;
  ActiveConnectionCount: integer;
  UserInfos:    array[0..MAX_USER - 1] of TUserInfo;
  UserHold:     boolean;
  UserHoldTime: longword;


implementation

uses showip;

{$R *.DFM}


procedure TFrmMain.FormCreate(Sender: TObject);
var
  i, onaddr: integer;
  ini: TIniFile;
  saddr, s1, s2, s3, s4, s5: string;
  n, localport: integer;
  remoteport, sidx: integer;
begin
  loopstarttime  := GetTickCount;
  ServerAddrList := TStringList.Create;

  ini := TIniFile.Create('.\mirgate.ini');
  with ini do begin
    Panel1.Color := GetDefColorByName(ReadString('server', 'Color', 'LTGRAY'));
    FrmMain.Caption := VER_STR + ReadString('server', 'Title', '');
    ServerPort := ReadInteger('server', 'ServerPort', ServerPort);
    GateBasePort := ReadInteger('server', 'GatePort', GateBasePort);
    sidx := Abs(ReadInteger('server', 'index', 0));
    s1   := ReadString('server', 'Server1', '');
    s2   := ReadString('server', 'Server2', '');
    s3   := ReadString('server', 'Server3', '');
    s4   := ReadString('server', 'Server4', '');
    s5   := ReadString('server', 'Server5', '');
  end;
  n := 0;
  if s1 <> '' then begin
    CbAddrs.Items.Add(s1 + ' (' + IntToStr(n) + ')');
    Inc(n);
  end;
  if s2 <> '' then begin
    CbAddrs.Items.Add(s2 + ' (' + IntToStr(n) + ')');
    Inc(n);
  end;
  if s3 <> '' then begin
    CbAddrs.Items.Add(s3 + ' (' + IntToStr(n) + ')');
    Inc(n);
  end;
  if s4 <> '' then begin
    CbAddrs.Items.Add(s4 + ' (' + IntToStr(n) + ')');
    Inc(n);
  end;
  if s5 <> '' then begin
    CbAddrs.Items.Add(s5 + ' (' + IntToStr(n) + ')');
    Inc(n);
  end;
  if sidx < CbAddrs.Items.Count then begin
    CbAddrs.ItemIndex := sidx;
    ServerIndex := sidx;
  end;

  //   onaddr := 1;
  //   SetSockOpt (ServerSocket.Socket.SocketHandle, SOL_SOCKET, SO_REUSEADDR, @onaddr, sizeof(integer));
  //   ServerSocket.Active := TRUE;
  UserCount := 0;

  ServerSocList := TStringList.Create;
  DisplayMsg    := TStringList.Create;
  LackAddrs     := TStringList.Create;

  ServerBusy := False;
  SendHoldCount := 0;
  ServerSendHolds := 0;
  chktime := GetTickCount;
  //for i:=0 to MAX_USER-1 do begin
  //   SendInfos[i].shandle := -1;
  //   SendInfos[i].Socket := nil;
  //   SendInfos[i].sendlist := TStringList.Create;
  //end;

  UserHold     := False;
  UserHoldTime := GetTickCount;

  for i := 0 to MAX_USER - 1 do begin
    with UserInfos[i] do begin
      Socket    := nil;
      Addr      := '';
      SendLength := 0;
      SendLock  := False;
      SendLatestTime := GetTickCount;
      SendAvailable := True;
      SendCheck := False;
      CheckSendLength := 0;
      ReceiveLength := 0;
      ReceiveTime := GetTickCount;
      shandle   := -1;
      sendlist  := TStringList.Create;
    end;
  end;

  with ClientSocket do begin
    Active := False;
  end;
  tryconntime := GetTickCount - 25 * 1000;

  Connected := False;

  with ServerSocket do begin
    Active := False;
    Port   := GateBasePort + ServerIndex; {사용자의 접속을 받는 port}
    Active := True;
  end;
  ServerConnection  := False;
  SendTimer.Enabled := True;

end;

procedure TFrmMain.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  DisplayMsg.Free;
  ///SocLock.Free;
  ///UsrLock.Free;
  ServerSocList.Free;
  for i := 0 to MAX_USER - 1 do
    UserInfos[i].sendlist.Free;
end;


procedure TFrmMain.ClearSendDataInfo;
var
  i: integer;
begin
  for i := 0 to MAX_USER - 1 do begin
    UserInfos[i].shandle := -1;
    UserInfos[i].Socket  := nil;
    UserInfos[i].sendlist.Clear;
  end;
end;

procedure TFrmMain.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i: integer;
begin
  ServerConnection := True;
  UserCount := 0;
  ServerCheckTime := GetTickCount;
  try
    for i := 0 to MAX_USER - 1 do begin
      UserInfos[i].Socket  := nil;
      UserInfos[i].SHandle := -1;
      UserInfos[i].Addr    := '';
    end;
  finally
  end;
  ClearSendDataInfo;
  Connected := True;
end;

procedure TFrmMain.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i: integer;
begin
  for i := 0 to MAX_USER - 1 do begin
    if UserInfos[i].Socket <> nil then begin
      UserInfos[i].Socket.Close;
      UserInfos[i].Socket  := nil;
      UserInfos[i].SHandle := -1;
      UserInfos[i].Addr    := '';
    end;
  end;
  ClearSendDataInfo;
  ServerSocList.Clear;
  ServerConnection := False;
  UserCount := 0;
  EdUserCount.Text := IntToStr(UserCount);
  Connected := False;
end;

procedure TFrmMain.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin
  ClientSocket.Close;
  ClientSocketDisconnect(Sender, Socket);
  ErrorCode := 0;
  Connected := False;
end;

procedure TFrmMain.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  str: string;
begin
  str := Socket.ReceiveText;
  try
    //EnterCriticalSection (CSSockLock);
    //ServerSocData := ServerSocData + str;
    ServerSocList.Add(str);
  finally
    //LeaveCriticalSection (CSSockLock);
  end;
  /////   Memo.Lines.Add (str);
end;

function CharCount(str: string; chr: char): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 1 to Length(str) do
    if str[i] = chr then
      Inc(Result);
end;

//=====================================================

procedure TFrmMain.DecodeTimerTimer(Sender: TObject);
const
  busy: boolean = False;
var
  socstr, Data, temp, shandle: string;
  i, j, k, ident, sh: integer;
  ll: longword;
begin
  if busy then
    exit;
  try
    busy   := True;
    socstr := '';
    while True do begin
      if ServerSocList.Count > 0 then begin
        socstr := socstr + ServerSocList[0];
        ServerSocList.Delete(0);
      end;
      while True do begin
        if CharCount(socstr, '$') >= 1 then begin
          socstr := ArrestStringEx(socstr, '%', '$', Data);
          if Data <> '' then begin
            if Data[1] = '+' then begin {check code}
              if Data[2] = '-' then begin {kick user}
                KickUser(Str_ToInt(Copy(Data, 3, Length(Data) - 2), 0));
              end else begin
                ServerCheckTime := GetTickCount;
                ServerBusy      := False;
              end;
            end else begin
              Data := GetValidStr3(Data, shandle, ['/']);
              sh   := Str_ToInt(shandle, -1);
              if sh > -1 then begin
                for i := 0 to MAX_USER - 1 do begin
                  if UserInfos[i].shandle = sh then begin
                    UserInfos[i].sendlist.Add(Data);
                    break;
                  end;
                end;
              end;
            end;
          end else
            break;
        end else
          break;
      end;
      if ServerSocList.Count = 0 then begin
        if socstr <> '' then
          ServerSocList.Add(socstr);
        break;
      end;
    end;

    SendHoldCount   := 0;
    ServerSendHolds := 0;
    LackAddrs.Clear;
    for i := 0 to MAX_USER - 1 do begin
      if UserInfos[i].shandle > -1 then begin
        while True do begin
          if UserInfos[i].SendList.Count <= 0 then
            break;
          ident := SendServerToClient(UserInfos[i], UserInfos[i].SendList[0]);
          if ident >= 0 then begin
            if ident = 1 then begin
              {send ok}
              UserInfos[i].SendList.Delete(0);
            end else begin
              {send wait}
              if UserInfos[i].SendList.Count > 100 then begin
                for j := 0 to 50 do
                  UserInfos[i].SendList.Delete(0);
              end;
              ServerSendHolds := ServerSendHolds + UserInfos[i].SendList.Count;
              LackAddrs.Add(UserInfos[i].RemoteAddr + ' : ' +
                IntToStr(UserInfos[i].SendList.Count));
              Inc(SendHoldCount);
              break;
            end;
          end else begin
            {invalid socket}
            UserInfos[i].shandle := -1;
            UserInfos[i].Socket  := nil;
            UserInfos[i].sendlist.Clear;
            break;
          end;
        end;
      end;
    end;

    { 2초에 한번 채크 코드를 보낸다 }
    if (GetTickCount - chktime > 2000) then begin
      chktime := GetTickCount;
      if ServerConnection then begin
        ClientSocket.Socket.SendText('%--$');
      end;
      if GetTickCount - ServerCheckTime > 60 * 1000 then begin {server busy}
        ServerBusy := True;
        ClientSocket.Close;
      end;
    end;
    busy := False;
  except
    busy := False;
    //ShowMessage ('Exception... DecodeTimer');
  end;
  ll := GetTickCount - loopstarttime;
  loopstarttime := GetTickCount;
  if ll > looptime then
    looptime := ll;
  Label2.Caption := IntToStr(looptime);
  if looptime > 50 then
    Dec(looptime, 50);
end;



//======================================================


{1 : success,  0: wait send,  -1: invalid socket}
function TFrmMain.SendServerToClient(UInfo: TUserInfo; str: string): integer;
var
  i, j:   integer;
  sendok: boolean;
begin
  Result := -1; {invalid socket}
  if UInfo.Socket <> nil then begin
    if not UInfo.SendLock then begin
      with UInfo do begin
        if not SendAvailAble then begin
          if TimeOutTime < GetTickCount then begin
            SendAvailAble := True;
            CheckSendLength := 0;
            UserHold     := True;
            UserHoldTime := GetTickCount;
          end;
        end;
        if SendAvailAble then begin
          if CheckSendLength >= 250 then begin
            if not SendCheck then begin
              SendCheck := True;
              str := '*' + str; //send verify code..
            end;
            if CheckSendLength >= MAX_CHECKSENDLENGTH then begin
              SendAvailAble := False;
              TimeOutTime   := GetTickCount + 5000;
            end;
          end;
          Socket.SendText(str);
          SendLength := SendLength + Length(str);
          CheckSendLength := CheckSendLength + Length(str);
          Result := 1; {send success}
        end else
          Result := 0;
      end;
    end else
      Result := 0;
  end;
end;

procedure TFrmMain.SetSendAvailable(uindex: integer);
begin
  UserInfos[uindex].SendAvailable := True;
  UserInfos[uindex].SendCheck     := False;
  UserInfos[uindex].CheckSendLength := 0;
end;

function TFrmMain.DataReceiveOK(uindex, alen: integer): boolean;
var
  i: integer;
begin
  Result := False;

  if GetTickCount - UserInfos[uindex].ReceiveTime < 1000 then begin
    UserInfos[uindex].ReceiveLength := UserInfos[uindex].ReceiveLength + alen;
    if UserInfos[uindex].ReceiveLength <= MAX_CLIENTRECEIVELENGTH then
      Result := True;
  end else begin
    UserInfos[uindex].ReceiveLength := alen;
    UserInfos[uindex].ReceiveTime := GetTickCount;
    Result := True;
  end;
end;

procedure TFrmMain.ServerSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i, uindex: integer;
begin
  Socket.Data := pointer(-1);
  
  if ServerConnection then begin
    try
      for i := 0 to MAX_USER - 1 do begin
        if UserInfos[i].Socket = nil then begin {빈곳}
          Socket.Data := @UserInfos[i];
          UserInfos[i].Socket    := Socket;
          UserInfos[i].Addr      := Socket.RemoteAddress;
          UserInfos[i].SendLength := 0;
          UserInfos[i].SendLock  := False;
          UserInfos[i].SendLatestTime := GetTickCount;
          UserInfos[i].SendAvailable := True;
          UserInfos[i].SendCheck := False;
          UserInfos[i].CheckSendLength := 0;
          UserInfos[i].ReceiveLength := 0;
          UserInfos[i].ReceiveTime := GetTickCount;
          UserInfos[i].shandle   := Socket.SocketHandle;
          UserInfos[i].RemoteAddr := Socket.RemoteAddress;
          UserInfos[i].sendlist.Clear;
          uindex := i;
          Inc(UserCount);
          break;
        end;
      end;
    finally
    end;
    
    if uindex >= 0 then begin
      {send connection}
      ClientSocket.Socket.SendText('%O' + IntToStr(Socket.SocketHandle) +
        '/' + Socket.RemoteAddress + '$');
      Socket.Data      := pointer(uindex);
      EdUserCount.Text := IntToStr(UserCount);
      DisplayMsg.Add('Connect ' + Socket.RemoteAddress);
    end else begin
      Socket.Close;
      DisplayMsg.Add('Kick off ' + Socket.RemoteAddress);
    end;
  end else begin
    Socket.Close;
    DisplayMsg.Add('Kick off ' + Socket.RemoteAddress);
  end;
end;

procedure TFrmMain.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  remote: string;
  uindex: integer;
begin
  remote := Socket.RemoteAddress;

  uindex := integer(Socket.Data);
  if (uindex >= 0) and (uindex < MAX_USER) then begin
    UserInfos[uindex].Socket  := nil;
    UserInfos[uindex].Addr    := '';
    UserInfos[uindex].shandle := -1;
    UserInfos[uindex].sendlist.Clear;
    Dec(UserCount);

    {send disconnect..}
    if ServerConnection then begin
      ClientSocket.Socket.SendText('%X' + IntToStr(Socket.SocketHandle) + '$');
      EdUserCount.Text := IntToStr(UserCount);
      DisplayMsg.Add('Disconnect ' + Socket.RemoteAddress);
    end;
    ///shutdown (Socket.SocketHandle, 0);  //WINSOCK closesocket.......
  end;
end;

procedure TFrmMain.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin
  DisplayMsg.Add('Error ' + IntToStr(ErrorCode) + ': ' + Socket.RemoteAddress);
  //ServerSocketClientDisconnect (Sender, Socket);
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFrmMain.ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  n, uindex: integer;
  temp, Data: string;
begin
  Data := Socket.ReceiveText;
  uindex := integer(Socket.Data);

  if (uindex >= 0) and (uindex < MAX_USER) and (Data <> '') and Connected then begin
    n := pos('*', Data);
    if n > 0 then begin
      SetSendAvailable(uindex);
      temp := Copy(Data, 1, n - 1);
      Data := temp + Copy(Data, n + 1, Length(Data));
    end;
    if Data <> '' then begin
      if ServerConnection and (not ServerBusy) then {서버와 연결상태 확인}
        if DataReceiveOK(uindex, Length(Data)) then begin
          {초당 수신량 조절}
          ClientSocket.Socket.SendText('%A' + IntToStr(Socket.SocketHandle) +
            '/' + Data + '$');
        end;
    end;
  end;
end;

procedure TFrmMain.KickUser(usrhandle: integer);
var
  i: integer;
begin
  if usrhandle <> 0 then begin
    try
      for i := 0 to MAX_USER - 1 do begin
        if UserInfos[i].Socket <> nil then begin
          if UserInfos[i].Socket.SocketHandle = usrhandle then begin
            UserInfos[i].Socket.Close;
            break;
          end;
        end;
      end;
    finally
    end;
  end;
end;



//======================================================


procedure TFrmMain.MemoChange(Sender: TObject);
begin
  if Memo.Lines.Count > 200 then begin
    Memo.Lines.Clear;
  end;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  i: integer;
begin
  if CbShowMessages.Checked then begin
    for i := 0 to DisplayMsg.Count - 1 do
      Memo.Lines.Add(DisplayMsg[i]);
  end;
  DisplayMsg.Clear;
end;


//=================================================


procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  i: integer;
begin
  if mrYes = MessageDlg('Do you want to close the SelGate program?',
    mtWarning, mbYesNoCancel, 0) then begin
    CanClose := True;
    ClientSocket.Close;
    ServerSocket.Close;
    for i := 0 to MAX_USER - 1 do begin
      if UserInfos[i].Socket <> nil then begin
        UserInfos[i].Socket.Close;
        UserInfos[i].Socket := nil;
        UserInfos[i].Addr   := '';
      end;
    end;
    ClientSocket.Active := False;
    ServerSocket.Active := False;
  end else
    CanClose := False;
end;

procedure TFrmMain.SendTimerTimer(Sender: TObject);
var
  i: integer;
begin
  if ServerSocket.Socket <> nil then
    ActiveConnectionCount := ServerSocket.Socket.ActiveConnections;
  if UserHold then begin
    LbHold.Caption := IntToStr(ActiveConnectionCount) + '#';
    if GetTickCount - UserHoldTime > 3000 then begin
      UserHold := False;
    end;
  end else
    LbHold.Caption := IntToStr(ActiveConnectionCount);

  {일정시간 동안 신호가 없는 소켓 접속 종료}
  if ServerConnection and (not ServerBusy) then begin
    for i := 0 to MAX_USER - 1 do begin
      if UserInfos[i].Socket <> nil then begin
        if GetTickCount - UserInfos[i].ReceiveTime > 60 * 60 * 1000 then begin
          UserInfos[i].Socket.Close;
          UserInfos[i].Socket  := nil;
          UserInfos[i].SHandle := -1;
          UserInfos[i].Sendlist.Clear;
          UserInfos[i].Addr := '';
        end;
      end;
    end;
  end;

  if not ServerConnection then begin
    LbConStatue.Caption := '---]   [---';
    if GetTickCount - tryconntime > 30 * 1000 then begin
      tryconntime := GetTickCount;
      with ClientSocket do begin
        Active  := False;
        Port    := ServerPort + ServerIndex;
        Address := cbAddrs.Items[ServerIndex];
        if Address <> '' then
          Active := True;
      end;
    end;
  end else begin
    if ServerBusy then
      LbConStatue.Caption := '---]$$[---'
    else begin
      LbConStatue.Caption := '-----][-----';
      LbLack.Caption      := IntToStr(ServerSendHolds) + '/' + IntToStr(SendHoldCount);
    end;
  end;
end;


procedure TFrmMain.BtnRunClick(Sender: TObject);
begin
  if not ServerConnection then begin
    SendTimer.Enabled := True;
    with ServerSocket do begin
      Active := False;
      Port   := GateBasePort + ServerIndex; {사용자의 접속을 받는 port}
      Active := True;
    end;
  end;
end;

procedure TFrmMain.MemoDblClick(Sender: TObject);
var
  i: integer;
begin
  with FrmShowIp do begin
    Memo.Lines.Clear;
    for i := 0 to LackAddrs.Count - 1 do
      Memo.Lines.Add(LackAddrs[i]);
    Show;
  end;
end;

procedure TFrmMain.CbAddrsChange(Sender: TObject);
begin
  ServerIndex := CbAddrs.ItemIndex;
end;

end.
