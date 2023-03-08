unit uGetSQLServer;

interface

uses
  SysUtils, Windows, Classes;

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

  SV_TYPE_SQLSERVER = $00000004;

function NetApiBufferAllocate(ByteCount: DWORD; var Buffer: Pointer):
                              NET_API_STATUS; stdcall; external 'netapi32.dll' name 'NetApiBufferAllocate';

function NetServerEnum(ServerName: LPCWSTR; Level: DWORD; var BufPtr: Pointer;
                       PrefMaxLen: DWORD; var EntriesRead: DWORD; var TotalEntries: DWORD;
                       ServerType: DWORD; Domain: LPCWSTR; ResumeHandle: PDWORD): NET_API_STATUS;
                       stdcall; external 'netapi32.dll' name 'NetServerEnum';

function NetApiBufferFree(Buffer: Pointer): NET_API_STATUS; stdcall; external 'netapi32.dll' name 'NetApiBufferFree';

function GetSQLServerList(AList: TStrings; pwcServerName: PWChar = nil; pwcDomain: PWChar = nil): Boolean;

implementation

function GetSQLServerList(AList: TStrings; pwcServerName: PWChar = nil;
  pwcDomain: PWChar = nil): Boolean;
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
begin
  Result := True;
  try
    dwLevel := 100;
    pReturnSvrInfo := nil;
    dwPrefMaxLen := MAX_PREFERRED_LENGTH;
    dwEntriesRead := 0;
    dwTotalEntries := 0;
    dwServerType := SV_TYPE_SQLSERVER;
    dwResumeHandle := nil;
    NetApiBufferAllocate(SizeOf(pReturnSvrInfo), pReturnSvrInfo);
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
      if Assigned(pReturnSvrInfo) then
        NetApiBufferFree(pReturnSvrInfo);
    end;
  except
    Result := False;
  end;
end;

end.
