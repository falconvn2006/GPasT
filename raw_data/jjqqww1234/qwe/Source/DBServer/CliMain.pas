unit CliMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp, ExtCtrls, MudUtil, EdCode, HUtil32, Grobal2, FeeDB;

const
  IDFILE = '!idlist.txt';
  CHECKBUFSIZE = 4096;

type
  TUserInfo = record
    Socket:     TCustomWinSocket;
    UserId:     string[10];
    SocData:    string;
    Degree:     byte;         //0: admin,
    OpenTime:   integer;
    SendData:   string;
    SendTime:   integer;
    SendLength: integer;
  end;
  PTUserInfo = ^TUserInfo;

  TFrmAccServer = class(TForm)
    SServer:      TServerSocket;
    DecodeTimer:  TTimer;
    TimeOutTimer: TTimer;
    CheckTimeoutTimer: TTimer;
    procedure SServerClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SServerClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure SServerClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure SServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure DecodeTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimeOutTimerTimer(Sender: TObject);
    procedure CheckTimeoutTimerTimer(Sender: TObject);
  private
    UserList:   TList; //list of PTUserInfo
    IDList:     TStringList;
    PasswdList: TStringList;
    Finder:     PTUserInfo;
    LimitDate:  TDateTime;
    procedure SendSocket(Socket: TCustomWinSocket; soc: string);
    procedure SendSendContinue(Socket: TCustomWinSocket);
    procedure DecodePacket(puser: PTUserInfo);
    procedure SendPacket(puser: PTUserInfo);
    procedure ExtractMessage(puser: PTUserInfo; Data: string);
    procedure GetLogin(puser: PTUserInfo; body: string);
    procedure GetGetUserKey(puser: PTUserInfo; body: string);
    procedure GetSelectUserKey(puser: PTUserInfo; body: string);
    procedure GetGetGroupKey(puser: PTUserInfo; body: string);
    procedure GetSelectGroupKey(puser: PTUserInfo; body: string);
    function OnUse(uid: string): boolean;
    procedure GetUpdateRcd(puser: PTUserInfo; body: string);
    procedure GetAddRcd(puser: PTUserInfo; body: string);
    procedure GetDeleteRcd(puser: PTUserInfo; body: string);
    procedure GetGetTimeoutList(puser: PTUserInfo; body: string);
  public
    procedure LoadIDPasswd;
  end;

var
  FrmAccServer: TFrmAccServer;

implementation

{$R *.DFM}

uses
  DBSMain;

procedure TFrmAccServer.FormCreate(Sender: TObject);
begin
  UserList   := TList.Create;
  IDList     := TStringList.Create;
  PasswdList := TStringList.Create;
  SServer.Active := True;
  Finder     := nil;
  LoadIDPasswd;

end;

procedure TFrmAccServer.FormDestroy(Sender: TObject);
begin
  UserList.Free;
  IDList.Free;
  PasswdList.Free;
end;

procedure TFrmAccServer.LoadIDPasswd;
var
  strlist: TStringList;
  str, id, passwd, degree: string;
  i: integer;
begin
  strlist := TStringList.Create;
  if FileExists(IDFILE) then begin
    IDList.Clear;
    PasswdList.Clear;
    strlist.LoadFromFile(IDFILE);
    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      str := GetValidStr3(str, id, [' ', #9]);
      str := GetValidStr3(str, passwd, [' ', #9]);
      str := GetValidStr3(str, degree, [' ', #9]);
      IdList.AddObject(id, TObject(Str_ToInt(degree, 1)));
      PasswdList.Add(passwd);
    end;
  end;
end;

procedure TFrmAccServer.SServerClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  puser: PTUserInfo;
begin
  new(puser);
  puser.Socket     := Socket;
  puser.UserId     := '';
  puser.SocData    := '';
  puser.SendData   := '';
  puser.SendLength := 0;
  puser.OpenTime   := GetCurrentTime;
  UserList.Add(puser);
end;

procedure TFrmAccServer.SServerClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i:     integer;
  puser: PTUserInfo;
begin
  for i := 0 to UserList.Count - 1 do begin
    if PTUserInfo(UserList[i]).Socket = Socket then begin
      puser := PTUserInfo(UserList[i]);
      Dispose(puser);
      UserList.Delete(i);
      break;
    end;
  end;
end;

procedure TFrmAccServer.SServerClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmAccServer.SServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  i, n:      integer;
  puser:     PTUserInfo;
  str, temp: string;
begin
  for i := 0 to UserList.Count - 1 do begin
    puser := PTUserInfo(UserList[i]);
    if puser.Socket = Socket then begin
      puser.OpenTime := GetCurrentTime;
      str := Socket.ReceiveText;
      n   := Pos('*', str);                // ������ ���� äũ�� Ŭ���̾�Ʈ�� ����
      if n > 0 then begin
        temp := Copy(str, 1, n - 1);
        str  := temp + Copy(str, n + 1, Length(str));
        puser.SendLength := 0;
      end;
      n := Pos('$', str);                // Ŭ���̾�Ʈ�� ������ ������ ����
      if n > 0 then begin
        temp := Copy(str, 1, n - 1);
        str  := temp + Copy(str, n + 1, Length(str));
        SendSendContinue(Socket);
      end;
      puser.SocData := puser.SocData + str;
      break;
    end;
  end;
end;

procedure TFrmAccServer.SendSocket(Socket: TCustomWinSocket; soc: string);
begin
  if Socket.Connected then
    Socket.SendText(soc);
end;

procedure TFrmAccServer.SendSendContinue(Socket: TCustomWinSocket);
begin
  SendSocket(Socket, '$');  //Ŭ���̾�Ʈ�� ������ äũ�� ���
end;

procedure TFrmAccServer.DecodeTimerTimer(Sender: TObject);
var
  i:     integer;
  puser: PTUserInfo;
const
  busy: boolean = False;
begin
  if busy then
    exit;
  busy := True;
  try
    for i := 0 to UserList.Count - 1 do begin
      puser := PTUserInfo(UserList[i]);
      if Pos('!', puser.SocData) > 0 then begin
        DecodePacket(puser);
      end;
      SendPacket(puser);
    end;
  except
  end;
  busy := False;
end;

procedure TFrmAccServer.TimeOutTimerTimer(Sender: TObject);
var
  i:     integer;
  puser: PTUserInfo;
begin
  for i := 0 to UserList.Count - 1 do begin
    puser := PTUserInfo(UserList[i]);
    if GetCurrentTime - puser.OpenTime > 30 * 60 * 1000 then begin
      if puser.Socket <> nil then begin
        puser.Socket.Close;
      end else begin
        UserList.Delete(i);
        Dispose(puser);
      end;
      break;
    end;
  end;
end;


procedure TFrmAccServer.DecodePacket(puser: PTUserInfo);
var
  str, Data: string;
begin
  str := puser.SocData;
  puser.SocData := '';
  while True do begin
    str := ArrestStringEx(str, '#', '!', Data);
    if Data <> '' then begin
      ExtractMessage(puser, Data);
    end;
    if Pos('!', str) <= 0 then
      break;
  end;
  if str <> '' then
    puser.SocData := str + puser.SocData;
end;

procedure TFrmAccServer.SendPacket(puser: PTUserInfo);
var
  sendstr: string;
begin
  if puser.SendData <> '' then begin
    if puser.SendLength < CHECKBUFSIZE then begin
      if Length(puser.SendData) >= 511 then begin
        sendstr := Copy(puser.SendData, 1, 511);
        puser.SendData := Copy(puser.SendData, 512, Length(puser.SendData));
      end else begin
        sendstr := puser.SendData;
        puser.SendData := '';
      end;
      puser.SendLength := puser.SendLength + Length(sendstr);
      puser.SendTime   := GetCurrentTime;
      if puser.SendLength >= CHECKBUFSIZE then
        sendstr := sendstr + '*';
      SendSocket(puser.Socket, sendstr);
    end else begin
      if GetCurrentTime - puser.SendTime >= 3000 then
        puser.SendLength := 0; //time out
    end;
  end;
end;


procedure TFrmAccServer.ExtractMessage(puser: PTUserInfo; Data: string);
var
  head, body: string;
  msg: TDefaultMessage;
begin
  if Length(Data) = DEFBLOCKSIZE then begin
    head := Data;
    body := '';
  end else begin
    head := Copy(Data, 1, DEFBLOCKSIZE);
    body := Copy(Data, DEFBLOCKSIZE + 1, Length(Data) - DEFBLOCKSIZE);
  end;
  msg := DecodeMessage(head);
  case msg.Ident of
    MSM_LOGIN: begin
      GetLogin(puser, body);
    end;

    MSM_GETUSERKEY: begin
      GetGetUserKey(puser, body);
    end;
    MSM_SELECTUSERKEY: begin
      GetSelectUserKey(puser, body);
    end;
    MSM_GETGROUPKEY: begin
      GetGetGroupKey(puser, body);
    end;
    MSM_SELECTGROUPKEY: begin
      GetSelectGroupKey(puser, body);
    end;
    MSM_UPDATEFEERCD: begin
      GetUpdateRcd(puser, body);
    end;
    MSM_DELETEFEERCD: begin
      GetDeleteRcd(puser, body);
    end;
    MSM_ADDFEERCD: begin
      GetAddRcd(puser, body);
    end;
    MSM_GETTIMEOUTLIST: begin
      GetGetTimeoutList(puser, body);
    end;
  end;
end;

function TFrmAccServer.OnUse(uid: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to UserList.Count - 1 do begin
    if PTUserInfo(UserList[i]).UserId = uid then begin
      Result := True;
      break;
    end;
  end;
end;

procedure TFrmAccServer.GetLogin(puser: PTUserInfo; body: string);

  function CheckPasswd(uid, passwd: string; var deg: byte): boolean;
  var
    i: integer;
  begin
    Result := False;
    for i := 0 to IdList.Count - 1 do begin
      if uid = IdList[i] then begin
        if i >= PasswdList.Count then
          break;
        if PasswdList[i] = passwd then begin
          deg    := integer(IdList.Objects[i]);
          Result := True;
        end;
        break;
      end;
    end;
  end;

var
  i:   integer;
  uid, passwd: string;
  msg: TDefaultMessage;
begin
  passwd := GetValidStr3(DecodeString(body), uid, ['/']);
  if (uid <> '') and (passwd <> '') then begin
    if OnUse(uid) then begin
      msg := MakeDefaultMsg(MCM_IDONUSE, 0, 0, 0, 0);
    end else begin
      if CheckPasswd(uid, passwd, puser.Degree) then begin
        puser.UserId := uid;
        msg := MakeDefaultMsg(MCM_PASSWDSUCCESS, 0, 0, 0, 0);
      end else
        msg := MakeDefaultMsg(MCM_PASSWDFAIL, 0, 0, 0, 0);
    end;
  end else
    msg := MakeDefaultMsg(MCM_PASSWDFAIL, 0, 0, 0, 0);
  puser.SendData := puser.SendData + '#' + EncodeMessage(msg) + '!';
end;

procedure TFrmAccServer.GetGetUserKey(puser: PTUserInfo; body: string);
var
  idx: integer;
  ukey, rstr: string;
  rcd: FFeeRcd;
  msg: TDefaultMessage;
begin  (*
   ukey := DecodeString (body);
   rstr := '';
   with FFeeDB do begin
      try
         if OpenRd then begin
            idx := Find (ukey);
            if idx >= 0 then begin
               if GetRecord (idx, rcd) >= 0 then begin
                  CheckValidDate (rcd);
                  rstr := rstr + EncodeBuffer(@rcd, sizeof(FFeeRcd));
               end;
            end;
         end;
      finally
         Close;
      end;
   end;
   if rstr <> '' then msg := MakeDefaultMsg (MCM_GETFEERCD, 0, 0, 0, 1)
   else msg := MakeDefaultMsg (MCM_GETFEERCD, 0, 0, 0, 0);
   puser.SendData := puser.SendData + '#' + EncodeMessage (msg) + rstr + '!';  *)
end;

procedure TFrmAccServer.GetSelectUserKey(puser: PTUserInfo; body: string);
var
  i, idx, rcount: integer;
  ukey, rstr: string;
  rcd:     FFeeRcd;
  strlist: TStringList;
  msg:     TDefaultMessage;
begin        (*
   ukey := DecodeString (body);
   rstr := '';
   rcount := 0;
   strlist := TStringList.Create;
   with FFeeDB do begin
      try
         if OpenRd then begin
            if FindLike (ukey, strlist) > 0 then begin
               if strlist.Count > 300 then begin
                  FillChar (rcd, sizeof(FFeeRcd), #0);
                  rcd.Block.UserKey := 'Fail';
                  rcd.Block.GroupKey := 'Its over 300 record';
                  rcd.Block.OwnerName := IntToStr(strlist.Count);
                  rstr := EncodeBuffer(@rcd, sizeof(FFeeRcd));
                  rcount := 1;
               end else begin
                  for i:=0 to strlist.Count-1 do begin
                     idx := Integer(strlist.Objects[i]);
                     if GetRecordDr (idx, rcd) then begin
                        CheckValidDate (rcd);
                        rstr := rstr + EncodeBuffer(@rcd, sizeof(FFeeRcd));
                        Inc (rcount);
                     end;
                  end;
               end;
            end;
         end;
      finally
         Close;
      end;
   end;
   strlist.Free;
   msg := MakeDefaultMsg (MCM_GETFEERCD, 0, 0, 0, rcount);
   puser.SendData := puser.SendData + '#' + EncodeMessage (msg) + rstr + '!'; *)
end;

procedure TFrmAccServer.GetGetGroupKey(puser: PTUserInfo; body: string);
var
  gkey, rstr: string;
  i, idx, rcount: integer;
  strlist: TStringList;
  rcd:     FFeeRcd;
  msg:     TDefaultMessage;
begin (*
   gkey := DecodeString (body);
   rstr := '';
   rcount := 0;
   strlist := TStringList.Create;
   with FFeeDB do begin
      try
         if OpenRd then begin
            if FindByGroupKey (gkey, strlist) > 0 then begin
               for i:=0 to strlist.Count-1 do begin
                  idx := PTIdInfo (strlist.Objects[i]).ridx;
                  if GetRecordDr (idx, rcd) then begin
                     CheckValidDate (rcd);
                     rstr := rstr + EncodeBuffer(@rcd, sizeof(FFeeRcd));
                     Inc (rcount);
                  end;
               end;
            end;
         end;
      finally
         Close;
      end;
   end;
   strlist.Free;
   msg := MakeDefaultMsg (MCM_GETFEERCD, 0, 0, 0, rcount);
   puser.SendData := puser.SendData + '#' + EncodeMessage (msg) + rstr + '!'; *)
end;

procedure TFrmAccServer.GetSelectGroupKey(puser: PTUserInfo; body: string);
var
  i, idx, rcount, valid: integer;
  gkey, rstr: string;
  strlist: TStringList;
  rcd: FFeeRcd;
  msg: TDefaultMessage;
  checkcount: boolean;
begin       (*
   gkey := DecodeString (body);
   checkcount := FALSE;
   if gkey = '*' then checkcount := TRUE;
   strlist := TStringList.Create;
   rstr := '';
   rcount := 0;
   with FFeeDB do begin
      try
         if OpenRd then begin
            if FindLikeByGroupKey (gkey, strlist) > 0 then begin
               if checkcount then begin
                  valid := 0;
                  for i:=0 to strlist.Count-1 do begin
                     idx := PTIdInfo (strlist.Objects[i]).ridx;
                     if GetRecordDr (idx, rcd) then begin
                        if CheckValidDate (rcd) then
                           Inc (valid);
                        Inc (rcount);
                     end;
                  end;
                  FillChar (rcd, sizeof(FFeeRcd), #0);
                  rcd.Block.UserKey := 'COUNT';
                  rcd.Block.GroupKey := IntToStr(valid) + '/' + IntToStr(rcount);
                  rcount := 1;
                  rstr := EncodeBuffer(@rcd, sizeof(FFeeRcd));
               end else begin
                  if strlist.Count > 300 then begin
                     FillChar (rcd, sizeof(FFeeRcd), #0);
                     rcd.Block.UserKey := 'Fail';
                     rcd.Block.GroupKey := 'Its over 300 record';
                     rcd.Block.OwnerName := IntToStr(strlist.Count);
                     rstr := EncodeBuffer(@rcd, sizeof(FFeeRcd));
                     rcount := 1;
                  end else begin
                     for i:=0 to strlist.Count-1 do begin
                        idx := PTIdInfo (strlist.Objects[i]).ridx;
                        if GetRecordDr (idx, rcd) then begin
                           CheckValidDate (rcd);
                           rstr := rstr + EncodeBuffer(@rcd, sizeof(FFeeRcd));
                           Inc (rcount);
                        end;
                     end;
                  end;
               end;
            end;
         end;
      finally
         Close;
      end;
   end;
   strlist.Free;
   msg := MakeDefaultMsg (MCM_GETFEERCD, 0, 0, 0, rcount);
   puser.SendData := puser.SendData + '#' + EncodeMessage (msg) + rstr + '!'; *)
end;

// UserKey, GroupKey�� ����
procedure TFrmAccServer.GetUpdateRcd(puser: PTUserInfo; body: string);
var
  rcd, feercd: FFeeRcd;
  idx:  integer;
  ukey: string;
begin (*
   DecodeBuffer (body, @rcd, sizeof(FFeeRcd));
   ukey := rcd.Block.UserKey;
   with FFeeDB do begin
      try
         if OpenWr then begin
            idx := Find (ukey);
            if idx >= 0 then begin
               if GetRecord (idx, feercd) >= 0 then begin
                  feercd.Block := rcd.Block;
                  SetRecord (idx, feercd);
               end;
            end;
         end;
      finally
         Close;
      end;
   end;  *)
end;

procedure TFrmAccServer.GetAddRcd(puser: PTUserInfo; body: string);
var
  rcd: FFeeRcd;
  idx: integer;
begin      (*
   DecodeBuffer (body, @rcd, sizeof(FFeeRcd));
   rcd.Key := rcd.Block.UserKey;
   with FFeeDB do begin
      try
         if OpenWr then begin
            AddRecord (rcd)
         end;
      finally
         Close;
      end;
   end;      *)
end;

procedure TFrmAccServer.GetDeleteRcd(puser: PTUserInfo; body: string);
var
  rcd:  FFeeRcd;
  idx:  integer;
  ukey: string;
begin          (*
   DecodeBuffer (body, @rcd, sizeof(FFeeRcd));
   ukey := rcd.Block.UserKey;
   with FFeeDB do begin
      try
         if OpenWr then begin
            Delete (ukey);
         end;
      finally
         Close;
      end;
   end;          *)
end;

procedure TFrmAccServer.GetGetTimeoutList(puser: PTUserInfo; body: string);
var
  msg: TDefaultMessage;
begin
  if Finder = nil then begin
    Finder := puser;
    if body <> '' then begin
      DecodeBuffer(body, @LimitDate, sizeof(TDateTime));
    end else
      LimitDate := Date;
    CheckTimeoutTimer.Enabled := True;
  end else begin
    msg := MakeDefaultMsg(MCM_ONUSETIMEOUT, 0, 0, 0, 0);
    puser.SendData := puser.SendData + '#' + EncodeMessage(msg) + '!';
  end;
end;


procedure TFrmAccServer.CheckTimeoutTimerTimer(Sender: TObject);
var
  i, idx, findtime: integer;
  fin, valid: boolean;
  rcd: FFeeRcd;
  rstr, mstr: string;
  msg: TDefaultMessage;
begin               (*
   CheckTimeoutTimer.Enabled := FALSE;
   findtime := GetCurrentTime;
   fin := FALSE;
   idx := 0;
   msg := MakeDefaultMsg (MCM_ADDFEERCD, 0, 0, 0, 1);
   mstr := EncodeMessage (msg);
   while not fin do begin
      rstr := '';
      if GetCurrentTime - findtime <= 200 then begin
         with FFeeDB do begin
            try
               if OpenRd then begin
                  while TRUE do begin
                     if idx < FeeIndex.Count then begin
                        if GetRecord (idx, rcd) >= 0 then begin
                           if CheckValidDate (rcd) then //������ �����߿���
                              if (rcd.Block.AccountMode <> 2) and (rcd.Block.EnableDate <= LimitDate) then begin //�����Ϻ��� ������
                                 rstr := rstr + '#' + mstr + EncodeBuffer (@rcd,sizeof(FFeeRcd)) + '!';
                              end;
                        end;
                        Inc (idx);
                     end else begin
                        fin := TRUE;
                        break;
                     end;
                     if GetCurrentTime - findtime > 200 then
                        break;
                  end;
               end;
            finally
               Close;
            end;
         end;
      end;
      if GetCurrentTime - findtime > 1000 then
         findtime := GetCurrentTime;
      Application.ProcessMessages;
      valid := FALSE;
      for i := 0 to UserList.Count-1 do begin
         if PTUserInfo(UserList[i]) = Finder then begin
            Finder.SendData := Finder.SendData + rstr;
            valid := TRUE;
         end;
      end;
      rstr := '';
      if not valid then break;
   end;
   msg := MakeDefaultMsg (MCM_ENDTIMEOUT, 0, 0, 0, 0);
   for i := 0 to UserList.Count-1 do begin
      if PTUserInfo(UserList[i]) = Finder then begin
         Finder.SendData := Finder.SendData + '#' + EncodeMessage (msg) + '!';
      end;
   end;
   Finder := nil;     *)
end;

end.
