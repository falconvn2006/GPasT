unit uNetWorkShare;

interface

uses
  Windows, SysUtils, StdCtrls;

const
  NERR_Success = 0; // Succes

type

  // **************** Partie ajout / suppression partages réseau *******************
  SHARE_INFO_2 = record
    shi2_netname: PWideChar;
    shi2_type: Integer;
    shi2_remark: PWideChar;
    shi2_permissions: Integer;
    shi2_max_uses: Integer;
    shi2_current_uses: Integer;
    shi2_path: PWideChar;
    shi2_passwd: PWideChar;
  end;

  // **************** Partie listing des partages réseau *******************
  NET_API_STATUS = DWORD;
  PShare_Info_0 = ^TShare_Info_0;

  TShare_Info_0 = record
    shi0_netname: PWideChar;
  end;

  PShare_Info_0_Arr = ^TShare_Info_0_Arr;
  TShare_Info_0_Arr = array [0 .. MaxInt div SizeOf(TShare_Info_0) - 1] of TShare_Info_0;
  PShare_Info_1 = ^TShare_Info_1;

  TShare_Info_1 = record
    shi1_netname: PWideChar;
    shi1_type: DWORD;
    shi1_remark: PWideChar;
  end;

  PShare_Info_1_Arr = ^TShare_Info_1_Arr;
  TShare_Info_1_Arr = array [0 .. MaxInt div SizeOf(TShare_Info_1) - 1] of TShare_Info_1;
  PShare_Info_2 = ^TShare_Info_2;

  TShare_Info_2 = record
    shi2_netname: PWideChar;
    shi2_type: DWORD;
    shi2_remark: PWideChar;
    shi2_permissions: DWORD;
    shi2_max_uses: DWORD;
    shi2_current_uses: DWORD;
    shi2_path: PWideChar;
    shi2_passwd: PWideChar;
  end;

  PShare_Info_2_Arr = ^TShare_Info_2_Arr;
  TShare_Info_2_Arr = array [0 .. MaxInt div SizeOf(TShare_Info_2) - 1] of TShare_Info_2;
  PShare_Info_502 = ^TShare_Info_502;

  TShare_Info_502 = record
    shi502_netname: PWideChar;
    shi502_type: DWORD;
    shi502_remark: PWideChar;
    shi502_permissions: DWORD;
    shi502_max_uses: DWORD;
    shi502_current_uses: DWORD;
    shi502_path: PWideChar;
    shi502_passwd: PWideChar;
    shi502_reserved: DWORD;
    shi502_security_descriptor: PSECURITY_DESCRIPTOR;
  end;

  PShare_Info_1004 = ^TShare_Info_1004;

  TShare_Info_1004 = record
    shi1004_remark: PWideChar;
  end;

  PShare_Info_1006 = ^TShare_Info_1006;

  TShare_Info_1006 = record
    shi1006_max_uses: DWORD;
  end;

  PShare_Info_1501 = ^TShare_Info_1501;

  TShare_Info_1501 = record
    shi1501_reserved: DWORD;
    shi1501_security_descriptor: PSECURITY_DESCRIPTOR;
  end;

  // *********** class network
  Tnetwork = class
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function isFolderShared(FullFolderPath, networkName: string): Boolean;
    function FolderShareDel(netname: WideString): Boolean;
    function FolderShareAdd(Path, netname, Remark: WideString): Boolean;
  end;

  // **************** Partie listing des partages réseau *******************
function NetShareEnum(servername: PWideChar; level: DWORD; var buf: Pointer; prefmaxlen: DWORD; var entriesread: DWORD; var totalentries: DWORD;
  var resume_handle: DWORD): NET_API_STATUS; stdcall; external 'netapi32.dll';
function NetShareGetInfo(servername: PWideChar; netname: PWideChar; level: DWORD; var buf: Pointer): NET_API_STATUS; stdcall; external 'netapi32.dll';
function NetApiBufferFree(P: Pointer): NET_API_STATUS; stdcall; external 'netapi32.dll';

// **************** Partie ajout / suppression partages réseau *******************
function NetShareAdd(servername: PWideChar; level: DWORD; buf: PChar; var parm_err: DWORD): DWORD; stdcall;
function NetShareDel(servername, netname: PWideChar; reserved: Integer): DWORD; stdcall;

var
  Server: PWideChar;
  Buffer, Loop: PShare_Info_0;
  Buf502: PShare_Info_502;
  NetResult: DWORD;
  entriesread: DWORD;
  totalentries: DWORD;
  resume_handle: DWORD;
  I: Integer;

implementation

{$REGION 'ListingFolders'}

function Tnetwork.isFolderShared(FullFolderPath, networkName: string): Boolean;
var
  Server: PWideChar;
  Buffer, Loop: PShare_Info_0;
  Buf502: PShare_Info_502;
  NetResult: DWORD;
  entriesread: DWORD;
  totalentries: DWORD;
  resume_handle: DWORD;
  I: Integer;
begin
  FullFolderPath := ExcludeTrailingPathDelimiter(FullFolderPath);
  networkName := StringReplace(StringReplace(networkName, '\', '', [rfReplaceAll, rfIgnoreCase]), '/', '', [rfReplaceAll, rfIgnoreCase]);
  Result := false;

  if (ParamCount = 0) then
  begin
    Server := nil;
  end
  else
  begin
    Server := PWideChar(WideString(ParamStr(1)));
  end;
  entriesread := 0;
  totalentries := 0;
  resume_handle := 0;
  NetResult := NetShareEnum(Server, 0, Pointer(Buffer), DWORD(-1), entriesread, totalentries, resume_handle);
  if (NetResult = NERR_Success) then
  begin
    Loop := Buffer;
    // WriteLn('Entries read: ', entriesread);
    for I := 1 to entriesread do
    begin
      // WriteLn('Name: ', string(Loop.shi0_netname));
      try
        NetResult := NetShareGetInfo(Server, Loop.shi0_netname, 502, Pointer(Buf502));
        if (NetResult = NERR_Success) then
        begin
          // les infos dispo sont dans le record TShare_Info_502;

          /// on vérifie que le chemin correspond au nom réseau passé, si on trouve le dossier est bien partagé
          if (LowerCase(Buf502.shi502_path) = LowerCase(FullFolderPath)) and (LowerCase(Buf502.shi502_netname) = LowerCase(networkName)) then
          begin
            Result := true;
          end;

        end
        else
        begin
          // WriteLn('* Error: ', SysErrorMessage(NetResult));
        end;
        NetApiBufferFree(Buf502);
      except
        on E: Exception do
          // WriteLn('* Error: ', E.Message);
      end;

      Inc(Loop);
    end;
    NetApiBufferFree(Buffer);
  end;
end;
{$ENDREGION}
{$REGION 'Share/Unshare Folder'}

const
  STYPE_DISKTREE = 0;
  netapi32 = 'NETAPI32.DLL';

function NetShareAdd; external netapi32 name 'NetShareAdd';
function NetShareDel; external netapi32 name 'NetShareDel';

function Tnetwork.FolderShareAdd(Path, netname, Remark: WideString): Boolean;
var
  ParamErr: DWORD;
  ShareInfo: SHARE_INFO_2;
  // NetName, remark, path: string;
  Res: DWORD;
  buf: PChar;
  Str: string;
begin

  Path := ExcludeTrailingPathDelimiter(Path);
  netname := StringReplace(StringReplace(netname, '\', '', [rfReplaceAll, rfIgnoreCase]), '/', '', [rfReplaceAll, rfIgnoreCase]);

  FillChar(ShareInfo, SizeOf(ShareInfo), 0);
  with ShareInfo do
  begin
    // NetName := 'Testing';
    shi2_netname := PWideChar(netname);
    shi2_type := STYPE_DISKTREE;
    // Remark := 'No Remarks';
    shi2_remark := PWideChar(Remark);
    shi2_permissions := 0;
    shi2_max_uses := -1;
    shi2_current_uses := 0;
    // Path := 'C:\Temp';
    shi2_path := PWideChar(Path);
    shi2_passwd := nil;
  end;
  ParamErr := 0;
  // Res := NetShareAdd(PWideChar(''), 2, @ShareInfo, ParamErr);
  Res := NetShareAdd(nil, 2, @ShareInfo, ParamErr);
  Result := Res = 0;
  if Res <> 0 then
  begin
    buf := StrAlloc(255);
    FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, Res, 0, buf, 255, nil);
    Str := buf;
    StrDispose(buf);
    // ShowMessage(Str);
    raise Exception.Create(Str);
  end;
end;

function Tnetwork.FolderShareDel(netname: WideString): Boolean;
var
  Res: DWORD;
  buf: PChar;
  Str: string;
begin
  netname := StringReplace(StringReplace(netname, '\', '', [rfReplaceAll, rfIgnoreCase]), '/', '', [rfReplaceAll, rfIgnoreCase]);

  Res := NetShareDel(nil, PWideChar(netname), 0);
  Result := Res = 0;
  if Res <> 0 then
  begin
    buf := StrAlloc(255);
    FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, Res, 0, buf, 255, nil);
    Str := buf;
    StrDispose(buf);
    // ShowMessage(Str);
  end;
end;
{$ENDREGION}

end.
