unit uNetwork;

interface

uses
  SysUtils, Windows, Classes, AccCtrl, Vcl.Forms, Vcl.ComCtrls;

type
  PTOKEN_USER = ^TOKEN_USER;
  TOKEN_USER = record
    User: TSIDAndAttributes;
  end;

type
  NET_API_STATUS = DWORD;

  PServerInfo100 = ^TServerInfo100;

  _SERVER_INFO_100 = record

    sv100_platform_id: DWORD;

    sv100_name: LPWSTR;

  end;

  {$EXTERNALSYM _SERVER_INFO_100}

  TServerInfo100 = _SERVER_INFO_100;

  SERVER_INFO_100 = _SERVER_INFO_100;

  {$EXTERNALSYM SERVER_INFO_100}


const

  NERR_Success = 0;

  MAX_PREFERRED_LENGTH = DWORD(-1);

  SV_TYPE_WORKSTATION = $00000001;
  SV_TYPE_SERVER = $00000002;
  SV_TYPE_SQLSERVER = $00000004;
  SV_TYPE_ALL = $FFFFFFFF;

  function NetApiBufferAllocate(ByteCount: DWORD; var Buffer: Pointer):
    NET_API_STATUS; stdcall; external 'netapi32.dll' name 'NetApiBufferAllocate';

  function NetServerEnum(ServerName: LPCWSTR; Level: DWORD; var BufPtr: Pointer;
    PrefMaxLen: DWORD; var EntriesRead: DWORD; var TotalEntries: DWORD;
    ServerType: DWORD; Domain: LPCWSTR; ResumeHandle: PDWORD): NET_API_STATUS;
    stdcall; external 'netapi32.dll' name 'NetServerEnum';

  function NetApiBufferFree(Buffer: Pointer): NET_API_STATUS; stdcall;
    external 'netapi32.dll' name 'NetApiBufferFree';

  function GetServerList(AList: TStrings; pwcServerName: PWChar = nil;
    pwcDomain: PWChar = nil;ATypeServeur:Integer = SV_TYPE_WORKSTATION): Boolean;

type
  TEnumNetworkProc = procedure(const aNetResource :TNetResource; const aLevel :word; var aContinue :boolean) of object;

procedure EnumNetwork(const aEnumNetworkProc :TEnumNetworkProc; Pb:TProgressBar; const aScope :dword = RESOURCE_GLOBALNET; const aType :dword = RESOURCETYPE_ANY);

implementation

//Procédure récursive
procedure DoEnumNetwork(const aContainer :Pointer;
                        const aEnumNetworkProc :TEnumNetworkProc;
                        const aScope :dword;
                        const aType  :dword;
                        const aLevel :byte;
                        Pb: TProgressBar);
type
  PNetResourceArray = ^TNetResourceArray;
  TNetResourceArray = array [0..0] of TNetResource;
var
  NetHandle    :THandle;
  NetResources :PNetResourceArray;
  NetResult    :dword;
  Size, Count, i :Cardinal;
  Continue     :boolean;
  percentProgress: Integer;
begin
  Continue := TRUE;

  NetResult := WNetOpenEnum(aScope, aType, 0, aContainer, NetHandle);

  if NetResult = NO_ERROR then
  try
    //Taille de base
    Size := 50 *SizeOf(TNetResource);
    GetMem(NetResources, Size);

    try
      while Continue do
      begin
        Count := $FFFFFFFF;
        NetResult := WNetEnumResource(NetHandle, Count, NetResources, Size);

        //Taille insuffisante ?
        if NetResult = ERROR_MORE_DATA
        then ReallocMem(NetResources, Size)
        else Break;
      end;

      //Pb.Max := Count;
      Pb.Position := 0;

      //Enumère
      if NetResult = NO_ERROR then
        for i := 0 to Count - 1 do
        begin
         //Pb.Position := i;
          percentProgress := Round(i*100/ Count);

          if (percentProgress mod 5 = 0) then
          begin
            Pb.Position := percentProgress;
            Application.ProcessMessages;
          end;

          //Callback
          if Assigned(aEnumNetworkProc) then
          begin
            aEnumNetworkProc(NetResources^[i], aLevel, Continue);
            if not Continue then Break;
          end;

          //Appel récursif
          if (NetResources^[i].dwUsage and RESOURCEUSAGE_CONTAINER) > 0 then
            DoEnumNetwork(@NetResources^[i], aEnumNetworkProc, aScope, aType, aLevel +1, Pb);
        end;
    finally
      FreeMem(NetResources, Size);
    end;
  finally
    WNetCloseEnum(NetHandle);
  end;
end;

procedure EnumNetwork(const aEnumNetworkProc: TEnumNetworkProc; Pb:TProgressBar; const aScope, aType: dword);
begin
  DoEnumNetwork(nil, aEnumNetworkProc, aScope, aType, 0, Pb);
end;

function GetCurrentUserAndDomain(var User, Domain: string): boolean;
var
  hToken: THandle;
  ptiUser: PTOKEN_USER;
  cbti: DWORD;
  snu: SID_NAME_USE;
  pcchUser, pcchDomain: DWORD;
begin
  result:= false;
  hToken:= 0;
  ptiUser:= nil;
  cbti:= 0;
  pcchUser:= 0;
  pcchDomain:= 0;

  try
    { Get the calling thread's access token.}
    if not OpenThreadToken(GetCurrentThread, TOKEN_QUERY, true, hToken) then
    begin
      if GetLastError <> ERROR_NO_TOKEN then
        exit;

      { Retry against process token if no thread token exists.}
      if not OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hToken) then
        exit;
    end;

    { Obtain the size of the user information in the token.}
    if GetTokenInformation(hToken, TokenUser, nil, 0, cbti) then
      { Call should have failed due to zero-length buffer.}
      exit
    else
    begin
      { Call should have failed due to zero-length buffer.}
      if GetLastError <> ERROR_INSUFFICIENT_BUFFER then
        exit;
    end;

    { Allocate buffer for user information in the token.}
    ptiUser:= PTOKEN_USER(HeapAlloc(GetProcessHeap, 0, cbti));
    if not Assigned(ptiUser) then
      exit;

    { Retrieve the user information from the token.}
    if not GetTokenInformation(hToken, TokenUser, ptiUser, cbti, cbti) then
      exit;

    { Retrieve user name and domain name based on user's SID.}
    { Delphi adaptation :
      The first call is used to get the length of the two strings }

    LookupAccountSid(nil, ptiUser.User.Sid, nil, pcchUser, nil, pcchDomain, snu);
    Setlength(User, pcchUser);
    Setlength(Domain, pcchDomain);
    if not LookupAccountSid(nil, ptiUser.User.Sid, PChar(User), pcchUser,
      PChar(Domain), pcchDomain, snu) then
      exit;

    result:= true;
  finally
    { Free resources.}
    if hToken <> 0 then
      CloseHandle(hToken);

    if Assigned(ptiUser) then
      HeapFree(GetProcessHeap, 0, ptiUser);
  end;
end;

function GetServerList(AList: TStrings; pwcServerName: PWChar = nil;
  pwcDomain: PWChar = nil; ATypeServeur:Integer = SV_TYPE_WORKSTATION): Boolean;
var
  NetAPIStatus: DWORD;
  dwLevel: DWORD;
  pReturnSvrInfo: Pointer;
  dwPrefMaxLen: DWORD;
  dwEntriesRead: DWORD;
  dwTotalEntries: DWORD;
  dwServerType: DWORD;
  dwResumeHandle: PDWORD;
  pCurSvrInfo: PServerInfo100;
  I, J: Integer;
  sUser,
  sDomain : string;
begin
  Result := True;
  try
    dwLevel := 100;
    pReturnSvrInfo := nil;
    dwPrefMaxLen := MAX_PREFERRED_LENGTH;
    dwEntriesRead := 0;
    dwTotalEntries := 0;
    dwServerType := ATypeServeur;
    dwResumeHandle := nil;
    NetApiBufferAllocate(SizeOf(pReturnSvrInfo), pReturnSvrInfo);
    if pwcDomain = nil then
    begin
      GetCurrentUserAndDomain(sUser, sDomain);
      pwcDomain := PWChar(sDomain);
    end;
    try
      NetAPIStatus := NetServerEnum(pwcServerName, dwLevel, pReturnSvrInfo,
        dwPrefMaxLen, dwEntriesRead, dwTotalEntries, dwServerType, pwcDomain,
        dwResumeHandle);
      if ((NetAPIStatus = NERR_Success) or (NetAPIStatus = ERROR_MORE_DATA)) and
        (pReturnSvrInfo <> nil) then
      begin
        pCurSvrInfo := pReturnSvrInfo;
        I := 0;
        J := dwEntriesRead;
        AList.Clear;
        while I < J do
        begin
          if pCurSvrInfo = nil then
          Break;
          with AList do
            Add(pCurSvrInfo^.sv100_name);
            Inc(I);
            Inc(pCurSvrInfo);
          end;
        end;
      finally
        if Assigned(pReturnSvrInfo) then  NetApiBufferFree(pReturnSvrInfo);
      end;
  except
    Result := False;
  end;
end;

end.
