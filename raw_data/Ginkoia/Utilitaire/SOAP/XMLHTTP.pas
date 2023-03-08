
{****************************************************************************}
{                                                                            }
{ XMLComponents Library                                                      }
{                                                                            }
{ Copyright (c) 1999,2002 e-delos.com / XMLComponents. All rights reserved.  }
{ See license before use.                                                    }
{                                                                            }
{ http://xmlcomponents.com                                                   }
{ http://xmlrad.com                                                          }
{                                                                            }
{****************************************************************************}

unit XMLHTTP;

interface

uses
  Windows, Messages, SysUtils, Classes,
  XMLClasses,
  WinInet;

type
  TXMLHTTP = class
  private
    FAccessType: DWORD;
    FAllowRedirect: Boolean; // Requested by ON 20030307
    FBlockSize: Integer;
    FHandleHTTP: HINTERNET;
    FHandleInternet: HINTERNET;
    FHandleRequest: HINTERNET;
    FHeaders: TWideStrings;
    FHostName: WideString;
    FPassword: WideString;
    FProxyBypassList: TWideStrings;
    FProxyName: WideString;
    FReferrer: WideString;
    FPort: Integer;
    FPostData: TWideStrings;
    FRedirectCount: Integer; // Requested by ON 20030307
    FRedirectMax: Integer; // Requested by ON 20030307
    FResponseHeaders: TWideStrings; // Requested by ON 20030307
    FRetries: DWORD;
    FScheme: WideString;
    FTimeOut: DWORD;
    FUserName: WideString;
    FVersion: WideString;
    procedure SetBlockSize(const Value: Integer);
    procedure SetHeaders(const Value: TWideStrings);
    procedure SetPostData(const Value: TWideStrings);
    procedure SetProxyBypassList(const Value: TWideStrings);
  protected
    function CrackURL(var URL: WideString): Boolean;
    function Connect: Boolean;
    function Disconnect: Boolean;
    function GetHeaderInfo(InfoLevel: Cardinal): WideString; // Requested by ON 20030307
		function GetResponse: WideString;
    procedure HandleRedirect(const Method: WideString); // Requested by ON 20030307
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function DoRequest(URL, Method: WideString): WideString; // Requested by ON 20030307
    function Get(const URL: WideString): WideString;
    function GetResponseHeaders: WideString; 
    function Post(const URL: WideString): WideString;
  public
    property AllowRedirect: Boolean read FAllowRedirect write FAllowRedirect; // Requested by ON 20030307
    property AccessType: DWORD read FAccessType write FAccessType;
    property BlockSize: Integer read FBlockSize write SetBlockSize;
    property Headers: TWideStrings read FHeaders write SetHeaders;
    property Password: WideString read FPassword write FPassword;
    property PostData: TWideStrings read FPostData write SetPostData;
    property ProxyName: WideString read FProxyName write FProxyName;
    property ProxyBypassList: TWideStrings read FProxyBypassList write SetProxyBypassList;
    property RedirectCount: Integer read FRedirectCount write FRedirectCount; // Requested by ON 20030307
    property RedirectMax: Integer read FRedirectMax write FRedirectMax; // Requested by ON 20030307
    property Referrer: WideString read FReferrer write FReferrer;
    property ResponseHeaders: TWideStrings read FResponseHeaders;
    property Retries: DWORD read FRetries write FRetries;
    property Timeout: DWORD read FTimeOut write FTimeout;
    property UserName: WideString read FUserName write FUserName;
    property Version: WideString read FVersion write FVersion;
  end;

function SimpleGet(const URL: WideString): WideString;
function HTTPGet(const URL, UserName, Password: WideString): WideString;
function SimplePost(const URL, PostData: WideString): WideString;
function HTTPPost(const URL, UserName, Password, PostData, Headers: WideString): WideString;
function SimpleSOAP(const URL, SoapAction, PostData: WideString): WideString;
function SOAPInvoke(const URL, SoapAction, UserName, Password, PostData: WideString): WideString;
function SOAPInvoke2(const URL, SoapAction, UserName, Password, Header, Body: WideString): WideString;
function SOAPInvokeMessage(const URL, SoapAction, Message, UserName, Password: WideString; HeaderParams, BodyParams: TWideStrings): WideString;

implementation

function LastError: WideString;
var
  nLastError,
  nBufLength:   DWORD;
  pLastError:   PChar;
begin
	Result := '';
  nBufLength := INTERNET_MAX_PATH_LENGTH;
  pLastError := StrAlloc(INTERNET_MAX_PATH_LENGTH);
  try
    if not (InternetGetLastResponseInfo(nLastError, pLastError, nBufLength)) or (StrLen(pLastError) = 0) then
      Exit;
    Result := StrPas(pLastError);
  finally
    StrDispose(pLastError);
  end;
end;

procedure CheckError(const Message: WideString);
var
	ErrorMessage: WideString;
begin
	ErrorMessage := LastError;
  if ErrorMessage = '' then
  	Exit;
  raise Exception.Create(Message+#13#10+ErrorMessage);
end;

function InternalHTTPRequest(const Method, URL, UserName, Password, PostData, Headers: WideString): WideString;
var
	HTTPAgent: TXMLHTTP;
begin
	HTTPAgent := TXMLHTTP.Create;
  try
  	HTTPAgent.Headers.Text := Headers;
    HTTPAgent.UserName := UserName;
    HTTPAgent.Password := Password;
    HTTPAgent.PostData.Text := PostData;
    try
    	if Method = 'POST' then
	      Result := HTTPAgent.Post(URL)
      else if Method = 'GET' then
	      Result := HTTPAgent.Get(URL);
    except on E: Exception do
      raise Exception.CreateFmt('Cannot invoke http action (URL=%s)', [URL]);
    end;
  finally
		HTTPAgent.Free;
  end;                       
end;

function SimpleGet(const URL: WideString): WideString;
begin
	Result := InternalHTTPRequest('GET', URL, '', '', '', '');
end;

function HTTPGet(const URL, UserName, Password: WideString): WideString;
begin
	Result := InternalHTTPRequest('GET', URL, UserName, Password, '', '');
end;

function SimplePost(const URL, PostData: WideString): WideString;
begin
	Result := InternalHTTPRequest('POST', URL, '', '', PostData, '');
end;

function HTTPPost(const URL, UserName, Password, PostData, Headers: WideString): WideString;
begin
	Result := InternalHTTPRequest('POST', URL, UserName, Password, PostData, Headers);
end;

function SimpleSOAP(const URL, SoapAction, PostData: WideString): WideString;
var
	Headers: WideString;
begin
	Headers := 'Content-Type: text/xml'#13#10'SOAPAction: "'+SoapAction+'"';
	Result := InternalHTTPRequest('POST', URL, '', '', PostData, Headers);
end;

function SOAPInvoke(const URL, SoapAction, UserName, Password, PostData: WideString): WideString;
var
	Headers: WideString;
begin
	Headers := 'Content-Type: text/xml'#13#10'SOAPAction: "'+SoapAction+'"';
	Result := InternalHTTPRequest('POST', URL, UserName, Password, PostData, Headers);
end;

function SOAPInvoke2(const URL, SoapAction, UserName, Password, Header, Body: WideString): WideString;
var
	SOAPRequest: WideString;
begin
	SOAPRequest := '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">';
  if Header <> '' then
		SOAPRequest := SOAPRequest + '<SOAP-ENV:Header>' + Header + '</SOAP-ENV:Header>';
  SOAPRequest := SOAPRequest + '<SOAP-ENV:Body>' + Body + '</SOAP-ENV:Body>';
  SOAPRequest := SOAPRequest + '</SOAP-ENV:Envelope>';
  Result := SOAPInvoke(URL, SoapAction, UserName, Password, SOAPRequest);
end;

function SOAPInvokeMessage(const URL, SoapAction, Message, UserName, Password: WideString; HeaderParams, BodyParams: TWideStrings): WideString;
var
	Body: WideString;
	I: Integer;
	Header: WideString;
  ParamName, ParamValue: WideString;
begin
  Header := '';
  for I := 0 to HeaderParams.Count-1 do
  begin
  	ParamName := HeaderParams.Names[I];
    ParamValue := HeaderParams.ValueFromIndex[I];
  	Header := Header+'<'+ParamName+'>'+ParamValue+'</'+ParamName+'>';
  end;
  Body := '';
  for I := 0 to BodyParams.Count-1 do
  begin
  	ParamName := BodyParams.Names[I];
    ParamValue := BodyParams.ValueFromIndex[I];
  	Body := Body+'<'+ParamName+'>'+ParamValue+'</'+ParamName+'>';
  end;
  Result := SOAPInvoke2(URL, SoapAction, UserName, Password, Header, Body);
end;


// -----------------------------------------------------------------------------
// TXMLHTTP
// -----------------------------------------------------------------------------
constructor TXMLHTTP.Create;
const
  BLOCK_SIZE       = $2000;
begin
  inherited;
  FAllowRedirect := False;
  FBlockSize := BLOCK_SIZE;
  FAccessType := INTERNET_OPEN_TYPE_DIRECT;
  FHeaders := TWideStrings.Create;
  FPostData := TWideStrings.Create;
  FProxyBypassList  := TWideStrings.Create;
  FPort := INTERNET_DEFAULT_HTTP_PORT;
  FRedirectMax := 10;
  FRedirectCount := 0;
  FResponseHeaders := TWideStrings.Create;
  FRetries := 3;
  FTimeOut := 300000;
  FVersion := ''; // 'HTTP/1.0'; 
end;

destructor TXMLHTTP.Destroy;
begin
  Disconnect;
  FHeaders.Free;
  FPostData.Free;
  FProxyBypassList.Free;
  FResponseHeaders.Free;
  inherited Destroy;
end;

function TXMLHTTP.Connect: Boolean;
var
  SHostName: string;
  SPassWord: string;
  SProxyName: string;
	PProxyName: PChar;
  SUserName: string;
begin
  Result := False;
  if not Assigned(FHandleInternet) then
  begin
    if FAccessType <> INTERNET_OPEN_TYPE_DIRECT then
    	PProxyName := nil
    else
    begin
      SProxyName := FProxyName;
    	PProxyName := PChar(SProxyName);
    end;
    FHandleInternet := InternetOpen(PChar('XMLHTTP'), FAccessType, PProxyName, PChar(string(FProxyBypassList.Text)), 0);
  end;

  InternetSetOption(FHandleInternet, INTERNET_OPTION_CONNECT_RETRIES, @FRetries, sizeof(DWORD));
  InternetSetOption(FHandleInternet, INTERNET_OPTION_CONNECT_TIMEOUT, @FTimeOut, sizeof(DWORD));

  InternetCloseHandle(FHandleHTTP);
  FHandleHTTP := nil;

  if Assigned(FHandleInternet) then
  begin
    SHostName := FHostName;
    SUserName := FUserName;
    SPassWord := FPassWord;
    FHandleHTTP := InternetConnect(FHandleInternet, PChar(SHostName), FPort, PChar(SUserName), PChar(SPassWord), INTERNET_SERVICE_HTTP, 0, DWORD(Self));
  end;
  CheckError('InternetConnect');

  if Assigned(FHandleHTTP) then
    Result := True
  else begin
    InternetCloseHandle(FHandleInternet);
    FHandleInternet := nil;
  end;
end;

function TXMLHTTP.CrackURL(var URL: WideString): boolean;
const
  SErrURLCrack = 'Error %d (%s) cracking URL %s';
  HTTP_URLSIGNIFIER = '://';
  MAX_BUF_SIZE = 512;
var
  URLComponents:  TURLComponents;

  procedure AllocateURLComponents;
  begin
    with URLComponents do
    begin
      lpszScheme        := StrAlloc(MAX_BUF_SIZE);
      dwSchemeLength    := MAX_BUF_SIZE;
      lpszHostName      := StrAlloc(MAX_BUF_SIZE);
      dwHostNameLength  := MAX_BUF_SIZE;
      lpszUserName      := StrAlloc(MAX_BUF_SIZE);
      dwUserNameLength  := MAX_BUF_SIZE;
      lpszPassWord      := StrAlloc(MAX_BUF_SIZE);
      dwPasswordLength  := MAX_BUF_SIZE;
      lpszURLPath       := StrAlloc(MAX_BUF_SIZE);
      dwURLPathLength   := MAX_BUF_SIZE;
      lpszExtraInfo     := StrAlloc(MAX_BUF_SIZE);
      dwExtraInfoLength := MAX_BUF_SIZE;
    end;
  end;

  procedure DeAllocateURLComponents;
  begin
    StrDispose(URLComponents.lpszScheme);
    StrDispose(URLComponents.lpszHostName);
    StrDispose(URLComponents.lpszUserName);
    StrDispose(URLComponents.lpszPassWord);
    StrDispose(URLComponents.lpszURLPath);
    StrDispose(URLComponents.lpszExtraInfo);
  end;

var
  SURL: string;
begin
  if Pos(HTTP_URLSIGNIFIER, URL) = 0 then begin
    Result := false;
    Exit;
  end;
  FillChar(URLComponents, SizeOf(URLComponents), 0);
  AllocateURLComponents;
  try
    URLComponents.dwStructSize := sizeof(URLComponents);
    SURL := URL; 
    Result := InternetCrackURL(PChar(SURL), 0, 0 {ICU_ESCAPE}, URLComponents);
    URL := SURL;
    if not Result then
    	raise Exception.CreateFmt(SErrURLCrack, [GetLastError, LastError, URL]);
    FPort := URLComponents.nPort;
    if URLComponents.dwHostNameLength <> 0 then
      FHostName := WideString(URLComponents.lpszHostName);
    if URLComponents.dwUserNameLength <> 0 then
      UserName := WideString(URLComponents.lpszUserName);
    if URLComponents.dwPasswordLength <> 0 then
      Password := WideString(URLComponents.lpszPassword);
    if URLComponents.dwSchemeLength <> 0 then
      FScheme := WideString(URLComponents.lpszScheme);
    if URLComponents.dwUrlPathLength <> 0 then
    begin
      URL := WideString(URLComponents.lpszUrlPath);
      if URLComponents.dwExtraInfoLength <> 0 then
        URL := URL + WideString(URLComponents.lpszExtraInfo);
    end;
  finally
    DeAllocateURLComponents;
  end;
end;

function TXMLHTTP.Disconnect: Boolean;
begin
  try
    try
      InternetCloseHandle(FHandleRequest);
      InternetCloseHandle(FHandleHTTP);
      InternetCloseHandle(FHandleInternet);
      Result := True;
		finally
  	  FHandleRequest := nil;
    	FHandleHTTP := nil;
	    FHandleInternet := nil;
    end;
  except
  	Result := False;
  end;
end;

const
  ERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION      = INTERNET_ERROR_BASE + 168;

function TXMLHTTP.DoRequest(URL, Method: WideString): WideString;
resourcestring
  SErrHeaderAdd = 'Error %d (%s) adding post headers';
  SErrRequestSend = 'Unable to send request to %s (%s)';
var
	BResult: BOOL;
  dwFlags: DWORD;
  dwPostDataSize: DWORD;
  pPostData: PChar;
  PostData: WideString;
  PVersion: PChar;
  SPostData: string;
  SMethod: string;
  SURL: string;
  SReferrer: string;
  SVersion: string;
  // Requested by ON 20030307
  LastErrorNo: cardinal;
  ResponseRedirect: boolean;
begin
  InternetCloseHandle(FHandleRequest);
  FHandleRequest := nil;
  CrackURL(URL);
  Connect;
  SMethod := Method;
  SURL := URL;
  SReferrer := FReferrer;
  dwFlags := INTERNET_FLAG_RELOAD;
  if FScheme = 'https' then
    dwFlags := dwFlags or INTERNET_FLAG_SECURE;
  PVersion := nil;
  if FVersion <> '' then
  begin
    SVersion := FVersion;
    PVersion := PChar(SVersion);
  end;
  FHandleRequest := HttpOpenRequest(FHandleHTTP, PChar(SMethod), PChar(SURL), PVersion, PChar(SReferrer), nil, dwFlags, DWORD(Self));
  if Length(FHeaders.Text) > 0 then
  begin
		BResult := HttpAddRequestHeaders(FHandleRequest, PChar(string(FHeaders.Text)), DWORD(-1), 0);
    if not BResult then
      raise Exception.CreateFmt(SErrHeaderAdd, [GetLastError, LastError]);
  end;
  PostData := FPostData.Text;
{
  if (PostData <> '') and ((Method = 'POST') or (Method = 'PUT')) then
  begin
    SPostData := PostData;
    pPostData       := PChar(SPostData);
    dwPostDataSize  := Length(FPostData.Text) - 2; // ??? probably to remove trailing #13#10
  end else begin
    pPostData       := nil;
    dwPostDataSize  := 0;
  end;
}
  // Requested by ON 20030307
  if (PostData = '') or (Method = 'GET') then
  begin
    pPostData       := nil;
    dwPostDataSize  := 0;
  end else begin
    SPostData := PostData;
    pPostData       := PChar(SPostData);
    dwPostDataSize  := Length(FPostData.Text) - 2; // ??? probably to remove trailing #13#10
  end;
  BResult := HttpSendRequest(FHandleRequest, nil, 0, pPostData, dwPostDataSize);
  // Requested by ON 20030307
  // if not BResult then
  //   raise Exception.CreateFmt(SErrRequestSend, [FHostName, LastError]);

  LastErrorNo := GetLastError;
  ResponseRedirect :=  LastErrorNo = ERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION;

  if ResponseRedirect and AllowRedirect then
  begin
    HandleRedirect(Method);
  end else if not BResult then
  begin
    raise Exception.CreateFmt(SErrRequestSend, [FHostName, LastError]);
  end else begin
    ResponseHeaders.Text := GetResponseHeaders;
    RedirectCount := 0;
    Result := GetResponse;
  end;
end;

function TXMLHTTP.GetResponse: WideString;

  function GetMin(Val1, Val2: DWORD): DWORD;
  begin
    if Val1 < Val2 then
      result := Val1
    else
      result := Val2;
  end;

const
	BUFFER_SIZE = $4000;
  SErrFileRead = 'Error %d (%s) reading URL %s';
var
	BResult: Boolean;
  pBuffer: PChar;
  dwFlags: DWORD;
  dwContext: DWORD;
  dwBytesAvail: DWORD;
  dwBytesRead: DWORD;
  Stream: TStringStream;
begin
  dwFlags := 0;
  dwContext:= 0;
  dwBytesAvail := 0;
  pBuffer := StrAlloc(BUFFER_SIZE+1);
  Stream := TStringStream.Create('');
  try
    repeat
      StrCopy(pBuffer, '');
      InternetQueryDataAvailable(FHandleRequest, dwBytesAvail, dwFlags, dwContext);
      BResult := InternetReadFile(FHandleRequest, pBuffer, GetMin(FBlockSize, dwBytesAvail), dwBytesRead);
      if not BResult then
        raise Exception.CreateFmt(SErrFileRead, [GetLastError, LastError]);
      Stream.WriteBuffer(pBuffer^, dwBytesRead);
    until dwBytesRead = 0;
    Result := Stream.DataString;
  finally
    StrDispose(pBuffer);
    Stream.Free;
  end;
end;

function TXMLHTTP.Get(const URL: WideString): WideString;
begin
  Result := DoRequest(URL, 'GET'); // PChar(nil));
end;

// Requested by ON 20030307
function TXMLHTTP.GetHeaderInfo(InfoLevel: Cardinal): WideString;
var
  QueryInfoBool: LongBool;
  pResponseHeaders: PChar;
  dwResponseHeadersBufferLength: DWORD;
  dwResponseHeadersReserved: DWORD;
begin
  if FHandleRequest = nil then
  begin
    FResponseHeaders.Clear;
    Exit;
  end;
  dwResponseHeadersBufferLength := 2048;
  GetMem(pResponseHeaders, dwResponseHeadersBufferLength);
  try
    FillChar(pResponseHeaders^, dwResponseHeadersBufferLength, 0);
    dwResponseHeadersReserved := 0;
    QueryInfoBool := HttpQueryInfo(FHandleRequest, InfoLevel, pResponseHeaders, dwResponseHeadersBufferLength, dwResponseHeadersReserved);
    if not QueryInfoBool then
      raise Exception.Create('HttpQueryInfo ERROR_INSUFFICIENT_BUFFER');
    Result := WideString(pResponseHeaders);
  finally
    FreeMem(pResponseHeaders);
  end;
end;

// Requested by ON 20030307
function TXMLHTTP.GetResponseHeaders: WideString;
begin
  Result := GetHeaderInfo(HTTP_QUERY_RAW_HEADERS_CRLF);
end;

// Requested by ON 20030307
procedure TXMLHTTP.HandleRedirect(const Method: WideString);
var
  URL: WideString;
begin
  if FHandleRequest = nil then
    Exit;
  if RedirectCount >= RedirectMax then
    Exit;
  RedirectCount := RedirectCount + 1;
  URL := GetHeaderInfo(HTTP_QUERY_LOCATION);
  DoRequest(URL, Method);
end;

function TXMLHTTP.Post(const URL: WideString): WideString;
begin
  Result := DoRequest(URL, 'POST');
end;

procedure TXMLHTTP.SetBlockSize(const Value: Integer);
begin
  FBlockSize := Value;
  InternetSetOption(FHandleInternet, INTERNET_OPTION_READ_BUFFER_SIZE, @FBlockSize, SizeOf(FBlockSize));
end;

procedure TXMLHTTP.SetHeaders(const Value: TWideStrings);
begin
  FHeaders.Assign(Value);
end;

procedure TXMLHTTP.SetPostData(const Value: TWideStrings);
begin
  FPostData.Assign(Value);
end;

procedure TXMLHTTP.SetProxyBypassList(const Value: TWideStrings);
begin
  FProxyBypassList.Assign(Value);
end;

end.

