unit MasSock;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp, HUtil32, Mudutil, Grobal2;

const
  MAXSERVERADDR  = 100;
  SERVERADDRFILE = '.\!ServerAddr.txt';
  SERVERUSERCOUNTLIMITFILE = '.\!UserLimit.txt';

type
  TMsgServerInfo = record
    SocStr:      string;
    Socket:      TCustomWinSocket;
    ServerName:  string;
    ServerIndex: integer;
    UserCount:   integer;
    CheckTime:   longword;
  end;
  PTMsgServerInfo = ^TMsgServerInfo;

  TLimitServerUserInfo = record
    ServerName:  string;
    ShortName:   string;
    CurrentUser: integer;
    MaxUser:     integer;
  end;

  TFrmMasSoc = class(TForm)
    MSocket: TServerSocket;
    procedure FormCreate(Sender: TObject);
    procedure MSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure MSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure MSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure MSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormDestroy(Sender: TObject);
  private
    procedure RecalcServerUserCount(svname: string);
  public
    ServerList: TList;  //List of server (selchr, game server..)
    procedure SendInterServerMsg(msg: word; body: string);
    procedure SendNamedServerMsg(svname: string; msg: word; body: string);
    procedure SendServerMsg(socket: TCustomWinSocket; msg: word; body: string);
    function ConnectionReadyOk: boolean;
    procedure Finialize;
    procedure LoadServerAddrs;
    function GetTotalUserCount: integer;
    function IsValidServerLimitiation(svname: string): boolean;
    procedure ArrangeNameServerList(index: integer);
    function GetServerShortName(svlongname: string): string;
  end;

var
  FrmMasSoc:   TFrmMasSoc;
  SAddrArr:    array[0..MAXSERVERADDR - 1] of string;
  ServerCount: integer;
  ServerUserCountArr: array[0..MAXSERVERADDR - 1] of TLimitServerUserInfo;

implementation

uses LMain;

{$R *.DFM}


procedure LoadServerLimitiation;
var
  strlist: TStringList;
  str, svname, shortname, scount: string;
  i, sv:   integer;
begin
  if FileExists(SERVERUSERCOUNTLIMITFILE) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(SERVERUSERCOUNTLIMITFILE);

    sv := 0;
    for i := 0 to strlist.Count - 1 do begin
      str := strlist[i];
      str := GetValidStr3(str, svname, [' ', #9]);
      str := GetValidStr3(str, shortname, [' ', #9]);
      str := GetValidStr3(str, scount, [' ', #9]);
      if svname <> '' then begin
        ServerUserCountArr[sv].ServerName  := svname;
        ServerUserCountArr[sv].ShortName   := shortname;
        ServerUserCountArr[sv].MaxUser     := Str_ToInt(scount, 3000);
        ServerUserCountArr[sv].CurrentUser := 0;
        Inc(sv);
      end;
    end;
    ServerCount := sv;

    strlist.Free;
  end else begin
    ShowMessage('[Critical Failure] file not found. ' + SERVERUSERCOUNTLIMITFILE);
  end;
end;

procedure TFrmMasSoc.FormCreate(Sender: TObject);
begin
  ServerList := TList.Create;
  with MSocket do begin
    Port   := 5600;
    Active := True;
  end;
  LoadServerAddrs;
  LoadServerLimitiation;
end;

procedure TFrmMasSoc.FormDestroy(Sender: TObject);
begin
  ServerList.Free;
end;

procedure TFrmMasSoc.Finialize;
var
  i: integer;
begin
   {for i:=0 to ServerList.Count-1 do
      PTMsgServerInfo(ServerList[i]).Socket.Close;}
end;

procedure TFrmMasSoc.LoadServerAddrs;
var
  i, n:    integer;
  str:     string;
  strlist: TStringList;
begin
  n := 0;
  FillChar(SAddrArr, sizeof(SAddrArr), #0);
  if FileExists(SERVERADDRFILE) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(SERVERADDRFILE);
    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str <> '' then begin
        if str[1] <> ';' then begin
          if CharCount(str, '.') = 3 then begin
            SAddrArr[n] := str;
            Inc(n);
            if n >= MAXSERVERADDR then
              break;
          end;
        end;
      end;
    end;
  end;
end;

function TFrmMasSoc.ConnectionReadyOk: boolean;
var
  i, n: integer;
begin
  Result := False;
  if ServerList.Count >= ReadyServerCount then
    Result := True;
end;

procedure TFrmMasSoc.MSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i:    integer;
  p:    PTMsgServerInfo;
  flag: boolean;
begin
  flag := False;
  for i := 0 to MAXSERVERADDR - 1 do begin
    if SAddrArr[i] = Socket.RemoteAddress then begin
      flag := True;  //������ ���� �ּҸ� ���� ���
      break;
    end;
  end;
  if flag then begin
    new(p);
    FillChar(p^, sizeof(TMsgServerInfo), #0);
    p.SocStr := '';
    p.Socket := Socket;
    ServerList.Add(p);
  end else begin
    FrmMain.Memo1.Lines.Add('Invalid address connection tried.. [MasSoc] ' +
      Socket.RemoteAddress);
    Socket.Close;
  end;
end;

procedure TFrmMasSoc.MSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i: integer;
begin
  for i := 0 to ServerList.Count - 1 do
    if PTMsgServerInfo(ServerList[i]).Socket = Socket then begin
      Dispose(PTMsgServerInfo(ServerList[i]));
      ServerList.Delete(i);
      break;
    end;
end;

procedure TFrmMasSoc.MSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMasSoc.RecalcServerUserCount(svname: string);
var
  i, Count: integer;
begin
  Count := 0;
  for i := 0 to ServerList.Count - 1 do begin
    if PTMsgServerInfo(ServerList[i]).ServerName = svname then begin
      Count := Count + PTMsgServerInfo(ServerList[i]).UserCount;
    end;
  end;
  for i := 0 to ServerCount - 1 do begin
    if ServerUserCountArr[i].ShortName = svname then begin
      ServerUserCountArr[i].CurrentUser := Count;
      break;
    end;
  end;
end;

function TFrmMasSoc.GetServerShortName(svlongname: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to ServerCount - 1 do begin
    if ServerUserCountArr[i].ServerName = svlongname then begin
      Result := ServerUserCountArr[i].ShortName;
      break;
    end;
  end;
end;

function TFrmMasSoc.IsValidServerLimitiation(svname: string): boolean;
var
  i: integer;
begin
  Result := True;
  for i := 0 to ServerCount - 1 do begin
    if ServerUserCountArr[i].ServerName = svname then begin
      if ServerUserCountArr[i].CurrentUser > ServerUserCountArr[i].MaxUser then
        Result := False;
      break;
    end;
  end;
end;

procedure TFrmMasSoc.ArrangeNameServerList(index: integer);
var
  i, k, j, n: integer;
  ms: PTMsgServerInfo;
begin
  if index >= ServerList.Count then
    exit;
  ms := PTMsgServerInfo(ServerList[index]);
  ServerList.Delete(index);

  for i := 0 to ServerList.Count - 1 do begin
    if PTMsgServerInfo(ServerList[i]).ServerName = ms.ServerName then begin
      //���� �̸��� �����鳢�� ������� ����
      if ms.ServerIndex > PTMsgServerInfo(ServerList[i]).ServerIndex then
        ServerList.Insert(i, ms)
      else begin
        n := i + 1;
        for k := n to ServerList.Count - 1 do begin
          if PTMsgServerInfo(ServerList[k]).ServerName = ms.ServerName then begin
            if ms.ServerIndex > PTMsgServerInfo(ServerList[k]).ServerIndex then
            begin
              ServerList.Insert(k, ms);
              for j := k + 1 to ServerList.Count - 1 do begin
                if (PTMsgServerInfo(ServerList[j]).ServerName =
                  ms.ServerName) and (PTMsgServerInfo(
                  ServerList[j]).ServerIndex = ms.ServerIndex) then begin
                  ServerList.Delete(j);
                  break;
                end;
              end;
              exit;
            end;
            n := k + 1; //ServerList.Insert (k+1, ms);
          end;
        end;
        ServerList.Insert(n, ms);
      end;
      exit;
    end;
  end;
  ServerList.Add(ms);
end;

procedure TFrmMasSoc.MSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  i, ident: integer;
  bufstr, str, Data, uid, uaddr, svname: string;
begin
  for i := 0 to ServerList.Count - 1 do
    if PTMsgServerInfo(ServerList[i]).Socket = Socket then begin
      PTMsgServerInfo(ServerList[i]).SocStr :=
        PTMsgServerInfo(ServerList[i]).SocStr + Socket.ReceiveText;
      BufStr := PTMsgServerInfo(ServerList[i]).SocStr;
      while Pos(')', BufStr) > 0 do begin
        BufStr := ArrestStringEx(BufStr, '(', ')', str);
        if str <> '' then begin
          str   := GetValidStr3(str, Data, ['/']);
          ident := Str_ToInt(Data, -1);
          case ident of
            ISM_USERCLOSED: begin
              str := GetValidStr3(str, uid, ['/']);
              FrmMain.CertifyCloseUser(uid, Str_ToInt(str, 0));
            end;
            ISM_SHIFTVENTURESERVER: begin
              SendInterServerMsg(ISM_SHIFTVENTURESERVER, str);
            end;
            ISM_USERCOUNT: begin
              str := GetValidStr3(str, svname, ['/']);
              str := GetValidStr3(str, Data, ['/']);
              PTMsgServerInfo(ServerList[i]).ServerName := svname;
              PTMsgServerInfo(ServerList[i]).ServerIndex := Str_ToInt(Data, 0);
              PTMsgServerInfo(ServerList[i]).UserCount := Str_ToInt(str, 0);
              PTMsgServerInfo(ServerList[i]).CheckTime := GetTickCount;
              ArrangeNameServerList(i);
              TotalUserCount := GetTotalUserCount;
              if TotalUserCount > MaxTotalUserCount then
                MaxTotalUserCount := TotalUserCount;
              SendInterServerMsg(ISM_TOTALUSERCOUNT,
                IntToStr(TotalUserCount));
              RecalcServerUserCount(svname);
            end;
          end;
        end;
      end;
      PTMsgServerInfo(ServerList[i]).SocStr := BufStr;
    end;
end;

function TFrmMasSoc.GetTotalUserCount: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to ServerList.Count - 1 do
    Result := Result + PTMsgServerInfo(ServerList[i]).UserCount;
end;

procedure TFrmMasSoc.SendInterServerMsg(msg: word; body: string);
var
  str: string;
  i:   integer;
begin
  str := '(' + IntToStr(msg) + '/' + body + ')';
  for i := 0 to ServerList.Count - 1 do begin
    if PTMsgServerInfo(ServerList[i]).Socket.Connected then
      PTMsgServerInfo(ServerList[i]).Socket.SendText(str);
  end;
end;

procedure TFrmMasSoc.SendNamedServerMsg(svname: string; msg: word; body: string);
var
  i: integer;
  str, shrname: string;
begin
  shrname := GetServerShortName(svname);
  str     := '(' + IntToStr(msg) + '/' + body + ')';
  for i := 0 to ServerList.Count - 1 do begin
    if (PTMsgServerInfo(ServerList[i]).Socket.Connected) and
      ((PTMsgServerInfo(ServerList[i]).ServerName = shrname) or (shrname = ''))
    then begin
      if PTMsgServerInfo(ServerList[i]).Socket.Connected then
        PTMsgServerInfo(ServerList[i]).Socket.SendText(str);
    end;
  end;
end;

procedure TFrmMasSoc.SendServerMsg(socket: TCustomWinSocket; msg: word; body: string);
var
  str: string;
  i:   integer;
begin
  str := '(' + IntToStr(msg) + '/' + body + ')';
  socket.SendText(str);
end;

end.
