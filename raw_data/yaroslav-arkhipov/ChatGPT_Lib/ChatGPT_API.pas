unit ChatGPT_API;

interface

uses System.Classes, Winapi.Windows, Winapi.Messages, System.SysUtils, System.JSON,
     System.Variants, Generics.Collections, IdBaseComponent, IdComponent, Vcl.Dialogs,
     IdTCPConnection, IdTCPClient, IdHTTP, IdGlobal, IdGlobalProtocols, IdCoderMIME,
     IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdMultipartFormData;

const
  cModelName   = 'text-davinci-003';
  cMaxTokens   = 2048;
  cTemperature = 0;

type
  TChatGPT = class(TPersistent)
  strict private
    FHTTPConnection: TIdHTTP;
    FSSLSocketHandler: TIdSSLIOHandlerSocketOpenSSL;
    FAPIKey: String;
    FModelName: String;
    FMaxTokens: Cardinal;
    FTemperature: Single;
  public
    constructor Create(APIKey: String);
    destructor Destroy; override;
    function SendMessage(AMessage: String): String;
    property ModelName: String write FModelName;
    property MaxTokens: Cardinal write FMaxTokens;
    property Temperature: Single write FTemperature;
  end;

implementation

function UrlEncode(const AStr: AnsiString): String;
var
  I: integer;
begin
  Result := '';
  for I := 1 to Length(AStr) do
    case AStr[I] of
      '%', ' ', '&', '=', '@', '.', #13, #10, #128..#255: Result := Result + '%' + IntToHex(Ord(AStr[I]), 2);
    else
      Result := Result + String(AStr[I]);
    end;
end;

function ConvertAnsiToUTF8(const ASource: String): String;
var
  Iterator, SourceLength, LChar, NChar: Integer;
begin
  Result := '';
  Iterator := 0;
  SourceLength := Length(ASource);
  while Iterator < SourceLength do
  begin
    Inc(Iterator);
    LChar := Ord(ASource[Iterator]);
    if LChar >= $80 then
    begin
      Inc(Iterator);
      if Iterator > SourceLength then break;
      LChar := LChar and $3F;
      if (LChar and $20) <> 0 then
      begin
        LChar := LChar and $1F;
        NChar := Ord(ASource[Iterator]);
        if (NChar and $C0) <> $80 then break;
        LChar := (LChar shl 6) or (NChar and $3F);
        Inc(Iterator);
        if Iterator > SourceLength then break;
      end;
      NChar := Ord(ASource[Iterator]);
      if (NChar and $C0) <> $80 then
        Break;
      Result := Result + WideChar((LChar shl 6) or (NChar and $3F));
    end
    else
      Result := Result + WideChar(LChar);
  end;
end;

{ TChatGPT }

constructor TChatGPT.Create(APIKey: String);
begin
  FAPIKey := APIKey.Trim;
  FModelName := cModelName;
  FMaxTokens := cMaxTokens;
  FTemperature := cTemperature;

  FHTTPConnection := TIdHTTP.Create;
  FHTTPConnection.HTTPOptions := FHTTPConnection.HTTPOptions + [hoNoProtocolErrorException];
  FHTTPConnection.Request.BasicAuthentication := False;
  FHTTPConnection.Request.CharSet := 'utf-8';
  FHTTPConnection.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';

  FSSLSocketHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FSSLSocketHandler.SSLOptions.Method := sslvTLSv1_2;
  FSSLSocketHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
  FSSLSocketHandler.SSLOptions.Mode := sslmUnassigned;
  FSSLSocketHandler.SSLOptions.VerifyMode := [];
  FSSLSocketHandler.SSLOptions.VerifyDepth := 0;

  FHTTPConnection.IOHandler := FSSLSocketHandler;
  FHTTPConnection.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + FAPIKey);
  FHTTPConnection.Request.ContentType := 'application/json';
end;

destructor TChatGPT.Destroy;
begin
  if Assigned(FSSLSocketHandler) then
    FreeAndNil(FSSLSocketHandler);

  if Assigned(FHTTPConnection) then
    FreeAndNil(FHTTPConnection);
  inherited;
end;

function TChatGPT.SendMessage(AMessage: String): String;
var
  LPostData, LResponse: String;
  LPostDataStream: TStringStream;
  LJsonParser: TJsonObject;
begin
  Result := '';

  LPostData := '{' +
    '"model": "text-davinci-003",'+
    '"prompt": "' + AMessage + '",'+
    '"max_tokens": 2048,'+
    '"temperature": 0'+
    '}';

  LPostDataStream := TStringStream.Create(LPostData, TEncoding.UTF8);
  try
    LPostDataStream.Position := 0;
    LResponse := FHTTPConnection.Post('https://api.openai.com/v1/completions', LPostDataStream);
    if FHTTPConnection.ResponseCode = 200 then
    begin
      LJsonParser := TJSONObject.ParseJSONValue(LResponse) as TJSONObject;
      try
        Result := ConvertAnsiToUTF8(LJsonParser.GetValue('choices').A[0].FindValue('text').Value);
      finally
        LJsonParser.Free;
      end;
    end
    else
      Result := 'HTTP response code: ' + FHTTPConnection.ResponseCode.ToString;
  finally
    LPostDataStream.Free;
  end;
end;

end.
