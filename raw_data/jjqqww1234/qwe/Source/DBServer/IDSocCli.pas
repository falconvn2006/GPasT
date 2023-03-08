unit IDSocCli;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ScktComp, IniFiles, EdCode, HUtil32, Grobal2;

type
  TAdmission = record
    usrid:    string[14];
    ipaddr:   string[15];
    Certification: integer;
    PayMode:  integer; //0:ü�� 1:����
    Selected: boolean;
  end;
  PTAdmission = ^TAdmission;

  TFrmIDSoc = class(TForm)
    IDSocket: TClientSocket;
    Timer1:   TTimer;
    Timer2:   TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure IDSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure IDSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure IDSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure IDSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Timer2Timer(Sender: TObject);
  private
    AdmissionList: TList;
  public
    ServerAddress: string;
    ServerPort:    integer;
    IDSocStr:      string;
    procedure Initialize;
    procedure DecodeSocStr;
    procedure AddAdmission(uid, ipaddr: string; certify, paymode: integer);
    procedure DelAdmission(uid: string; certify: integer);
    procedure GetPasswdSuccess(body: string);
    procedure GetCancelAdmission(body: string);
    function GetAdmission(uid, uaddr: string; cert: integer): boolean;
    procedure ClearSelectedAdmission(cert: integer);
    procedure CheckSelectedAdmission(cert: integer);
    function IsSelectedAdmision(cert: integer): boolean;
    procedure SendIDSMsg(msg: word; body: string);
    procedure SendUserCount;
  end;

var
  FrmIDSoc: TFrmIDSoc;

implementation

uses
  DBSMain;

{$R *.DFM}


procedure TFrmIDSoc.FormCreate(Sender: TObject);
var
  ini: TIniFile;
begin
  IDSocket.Address := '';
  ini := TIniFile.Create('.\dbsrc.ini');
  if ini <> nil then begin
    ServerAddress := ini.ReadString('Server', 'IDSAddr', '210.121.143.204');
    ServerPort    := ini.ReadInteger('Server', 'IDSPort', 5600);
    ini.Free;
  end;
  AdmissionList := TList.Create;
  IDSocStr      := '';
end;

procedure TFrmIDSoc.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to AdmissionList.Count - 1 do
    Dispose(PTAdmission(AdmissionList[i]));
  AdmissionList.Free;
end;

procedure TFrmIDSoc.AddAdmission(uid, ipaddr: string; certify, paymode: integer);
var
  pa: PTAdmission;
begin
  new(pa);
  pa.usrid    := uid;
  pa.ipaddr   := ipaddr;
  pa.Certification := certify;
  pa.PayMode  := paymode;
  pa.Selected := False;
  AdmissionList.Add(pa);
end;

procedure TFrmIDSoc.DelAdmission(uid: string; certify: integer);
var
  i: integer;
begin
  for i := AdmissionList.Count - 1 downto 0 do begin
    if (PTAdmission(AdmissionList[i]).Certification = certify) or
      (PTAdmission(AdmissionList[i]).UsrId = uid) then begin
      Dispose(PTAdmission(AdmissionList[i]));
      AdmissionList.Delete(i);
    end;
  end;
end;

procedure TFrmIDSoc.ClearSelectedAdmission(cert: integer);
var
  i: integer;
begin
  for i := 0 to AdmissionList.Count - 1 do begin
    if PTAdmission(AdmissionList[i]).Certification = cert then begin
      PTAdmission(AdmissionList[i]).Selected := False;
      break;
    end;
  end;
end;

procedure TFrmIDSoc.CheckSelectedAdmission(cert: integer);
var
  i: integer;
begin
  for i := 0 to AdmissionList.Count - 1 do begin
    if PTAdmission(AdmissionList[i]).Certification = cert then begin
      PTAdmission(AdmissionList[i]).Selected := True;
      break;
    end;
  end;
end;

function TFrmIDSoc.IsSelectedAdmision(cert: integer): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to AdmissionList.Count - 1 do begin
    if PTAdmission(AdmissionList[i]).Certification = cert then begin
      Result := PTAdmission(AdmissionList[i]).Selected;
      break;
    end;
  end;
end;

function TFrmIDSoc.GetAdmission(uid, uaddr: string; cert: integer): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to AdmissionList.Count - 1 do begin
    if (PTAdmission(AdmissionList[i]).usrid = uid) and
      //(PTAdmission(AdmissionList[i]).ipaddr = uaddr) and
      (PTAdmission(AdmissionList[i]).Certification = cert) then begin
      Result := True;
      break;
    end;
  end;
end;

procedure TFrmIDSoc.IDSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  ;
end;

procedure TFrmIDSoc.IDSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  ;
end;

procedure TFrmIDSoc.IDSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFrmIDSoc.IDSocketRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  IdSocStr := IdSocStr + Socket.ReceiveText;
  if Pos(')', IdSocStr) > 0 then
    DecodeSocStr;
end;

procedure TFrmIDSoc.Timer1Timer(Sender: TObject);
begin
  if IDSocket.Address <> '' then
    if not IDSocket.Active then
      IDSocket.Active := True;
end;

procedure TFrmIDSoc.Initialize;
begin
  with IDSocket do begin
    Active  := False;
    Address := ServerAddress;
    Port    := ServerPort;
    Active  := True;
  end;
end;

procedure TFrmIDSoc.DecodeSocStr;
var
  BufStr, str, head, body: string;
  ident: integer;
begin
  BufStr   := IDSocStr;
  IDSocStr := '';
  while Pos(')', BufStr) > 0 do begin
    BufStr := ArrestStringEx(BufStr, '(', ')', str);
    if str <> '' then begin
      body  := GetValidStr3(str, head, ['/']);
      ident := Str_ToInt(head, 0);
      case ident of
        ISM_PASSWDSUCCESS: begin
          GetPasswdSuccess(body);
        end;
        ISM_CANCELADMISSION: begin
          GetCancelAdmission(body);
        end;
        ISM_USERCLOSED: begin
        end;
      end;
    end else
      break;
  end;
  IdSocStr := BufStr + IdSocStr;
end;

procedure TFrmIDSoc.GetPasswdSuccess(body: string);
var
  uid, certstr, paystr, ipaddr: string;
begin
  body := GetValidStr3(body, uid, ['/']);
  body := GetValidStr3(body, certstr, ['/']);
  body := GetValidStr3(body, paystr, ['/']);
  //GetValidStr3 (body, ipaddr, ['/']);
  AddAdmission(uid, ipaddr, Str_ToInt(certstr, 0), Str_ToInt(paystr, 0));
end;

procedure TFrmIDSoc.GetCancelAdmission(body: string);
var
  cert: integer;
  uid:  string;
begin
  body := GetValidStr3(body, uid, ['/']);
  cert := Str_ToInt(body, 0);
  DelAdmission(uid, cert);
end;

procedure TFrmIDSoc.SendIDSMsg(msg: word; body: string);
var
  str: string;
begin
  str := '(' + IntToStr(msg) + '/' + body + ')';
  if IDSocket.Socket.Connected then
    IDSocket.Socket.SendText(str);
end;

procedure TFrmIDSoc.SendUserCount;
begin
  if IDSocket.Socket.Connected then
    IDSocket.Socket.SendText('(' + IntToStr(ISM_USERCOUNT) + '/' +
      ServerName + '/99/0)');
end;


procedure TFrmIDSoc.Timer2Timer(Sender: TObject);
begin
  SendUserCount;
end;

end.
