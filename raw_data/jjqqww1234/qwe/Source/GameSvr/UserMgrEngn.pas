unit UserMgrEngn;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  UserMgr, CmdMgr, UserSystem, Grobal2;

type

  TUserMgrEngine = class(TThread)
  private
    FUserMgr: TUserMgr;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;

    function InterGetUserInfo(UserName_: string; var UserInfo_: TUserInfo): boolean;

    procedure AddUser(UserName_: string; Recog_: integer; ConnState_: integer;
      GateIdx_: integer; UserGateIdx_: integer; UserHandle_: integer);

    procedure DeleteUser(UserName_: string);

    procedure InterSendMsg(SendTarget: TSendTarget; TargetSvrIdx: integer;
      GateIdx: integer; UserGateIdx: integer; UserHandle: integer;
      UserName: string; Recog: integer; Ident: word; Param: word;
      Tag: word; Series: word; Body: string);

    procedure ExternSendMsg(SendTarget: TSendTarget; TargetSvrIdx: integer;
      GateIdx: integer; UserGateIdx: integer; UserHandle: integer;
      UserName: string; msg: TDefaultMessage; body: string);


    procedure OnDBRead(Data: string);

    procedure OnExternInterMsg(snum: integer; Ident: integer;
      UserName: string; Data: string);
  end;

implementation

uses
  svMain;
 //------------------------------------------------------------------------------
 // Creator ...
 //------------------------------------------------------------------------------
constructor TUserMgrEngine.Create;
begin
  inherited Create(True);
  //FreeOnTerminate := True;

  FUserMgr := TUserMgr.Create;
end;

 //------------------------------------------------------------------------------
 // Destructor ...
 //------------------------------------------------------------------------------
destructor TUserMgrEngine.Destroy;
begin

  FUserMgr.Free;

  inherited Destroy;
end;

 //------------------------------------------------------------------------------
 // Tread Execute ...
 //------------------------------------------------------------------------------
procedure TUserMgrEngine.Execute;
begin
  while True do begin
    if Terminated then exit;

    try
      FUserMgr.RunMsg;
    except
      MainOutMessage('[UserMgrEngine] raise exception..');
    end;
    sleep(1);
  end;
end;

 //------------------------------------------------------------------------------
 // Add User...
 //------------------------------------------------------------------------------
procedure TUserMgrEngine.AddUser(UserName_: string; Recog_: integer;
  ConnState_: integer; GateIdx_: integer; UserGateIdx_: integer; UserHandle_: integer);
begin
  umLock.Enter;
  try
    InterSendMsg(stInterServer, 0, GateIdx_, UserGateIdx_,
      UserHandle_, UserName_,
      Recog_, ISM_FUNC_USEROPEN, ConnState_, 0, 0, '');
  finally
    umLock.Leave;
  end;
end;
 //------------------------------------------------------------------------------
 // DelUser...
 //------------------------------------------------------------------------------
procedure TUserMgrEngine.DeleteUser(UserName_: string);
begin
  umLock.Enter;
  try
    InterSendMsg(stInterServer, 0, 0, 0, 0, UserName_, 0,
      ISM_FUNC_USERCLOSE, 0, 0, 0, '');
  finally
    umLock.Leave;
  end;
end;
 //------------------------------------------------------------------------------
 // Internal SendMsg... Don't Use Lock...
 //------------------------------------------------------------------------------
procedure TUserMgrEngine.InterSendMsg(SendTarget: TSendTarget;
  TargetSvrIdx: integer; GateIdx: integer; UserGateIdx: integer;
  UserHandle: integer; UserName: string; Recog: integer; Ident: word;
  Param: word; Tag: word; Series: word; Body: string);
var
  userinfo: TUserInfo;
begin

  if (SendTarget = stClient) then begin
    if not InterGetUserInfo(UserName, userinfo) then begin
      umLock.Enter;
      try
        FUserMgr.ErrMsg('[USERMGR_ENGINE]Not Exist Object ' + UserName);
      finally
        umLock.Leave;
      end;

      Exit;
    end;
  end;


  umLock.Enter;
  try
    FUserMgr.SendMsgQueue1(
      SendTarget,
      TargetSvrIdx,
      GateIdx,
      UserGateIdx,
      UserHandle,
      UserName,
      Recog,
      Ident,
      Param,
      Tag,
      Series,
      Body
      );
  finally
    umLock.Leave;
  end;

end;

function TUserMgrEngine.InterGetUserInfo(UserName_: string;
  var UserInfo_: TUserInfo): boolean;
begin
  Result := FUserMgr.GetuserInfo(UserName_, UserInfo_);
end;

 //------------------------------------------------------------------------------
 // External SendMsg... use Lock
 //------------------------------------------------------------------------------
procedure TUserMgrEngine.ExternSendMsg(SendTarget: TSendTarget;
  TargetSvrIdx: integer; GateIdx: integer; UserGateIdx: integer;
  UserHandle: integer; UserName: string; msg: TDefaultMessage; body: string);

begin
  umLock.Enter;

  try
    FUserMgr.SendMsgQueue(
      SendTarget,
      TargetSvrIdx,
      GateIdx,
      UserGateIdx,
      UserHandle,
      UserName,
      msg,
      Body
      );
  finally
    umLock.Leave;
  end;
end;

procedure TUserMgrEngine.OnDBRead(Data: string);
begin
  //    umLock.Enter;
  //    try
  FUserMgr.OnDBRead(Data);
  //    finally
  //        umLock.Leave;
  //    end;
end;

procedure TUserMgrEngine.OnExternInterMsg(snum: integer; Ident: integer;
  UserName: string; Data: string);
var
  userinfo: TUserInfo;

begin
  umLock.Enter;
  try

    InterSendMsg(stInterServer, snum,
      0, 0, 0, UserName, 0,
      Ident, 0, 0, 0, Data);
  finally
    umLock.Leave;
  end;
end;


end.
