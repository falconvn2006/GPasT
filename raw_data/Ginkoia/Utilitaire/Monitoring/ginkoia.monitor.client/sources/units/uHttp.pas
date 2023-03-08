unit uHttp;

interface

uses
  System.SysUtils, System.Classes;

type
  TUrl = type String;
  TJsonString = type String;

  EHttpUriException = class( Exception );
  EHttpProtocolException = class( Exception );
  EHttpConnectTimeout = class( Exception );
  EHttpUnknownError = class( Exception );

  THttpMethod = (Get, Post);
  THttpAsync<T> = procedure(const Response: T);

function HttpResponse(const Url: TUrl; const Json: TJsonString;
  const Method: THttpMethod): TJsonString;

function ExcludeTrailingSlash(const S: string): string; inline;

type
  THttp = class
    { methods }
    class function Query(const Json: TJsonString; const Url: TUrl = ''): TJsonString; overload;
    class function Query< T: class, constructor >(const Json: TJsonString; const Url: TUrl = ''): T; overload;
    class function Query< T: class >(const Obj: T; const Url: TUrl = ''): TJsonString; overload;
    class function Query< T: class, constructor; S: class >(const Obj: S; const Url: TUrl = ''): T; overload;
    { members }
    class var ServerAddress: TUrl;
    class var Method: THttpMethod;
  end;

implementation

uses
  IdHTTP, IdURI, IdExceptionCore,
  REST.Json, uIso8601;

function ExcludeTrailingSlash(const S: string): string; {cf. ExcludeTrailingPathDelimiter @ System.SysUtils}
begin
  if not S.IsEmpty and S.EndsWith( '/' ) then
    Exit( S.Remove( S.Length - 1 ) )
  else
    Exit( S );
end;

function HttpResponse(const Url: TUrl; const Json: TJsonString;
  const Method: THttpMethod): TJsonString;
{$IFDEF DEBUG}
const
  cDebugFilename: TFilename = 'http.log';
{$ENDIF}
var
  IdHTTP: TIdHTTP;
  Parameters: TStringList;
  Response: TStringStream;
  {$IFDEF DEBUG}
  {log}Log: TStringList;
  {$ENDIF}
begin
  {$IFDEF DEBUG}
  {log}Log := TStringList.Create;
  {log}if FileExists( cDebugFilename ) Then
  {log}  Log.LoadFromFile( cDebugFilename );
  {$ENDIF}
  IdHTTP := TIdHTTP.Create( nil );
  Response := TStringStream.Create( '', TEncoding.ANSI );
  Parameters := TStringList.Create;
  try
    Parameters.Add( 'json=' + Json );
    try
      IdHTTP.Request.ContentType := 'text/html';
      IdHTTP.Request.Charset := 'utf-8';
      IdHTTP.ConnectTimeout := 3000;
      case Method of
        Get: begin
          {$IFDEF DEBUG}
          {log}Log.Add( TIso8601.DateTimeToIso8601( TUtc.UtcNow ) + ':' + trim(  'GET > ' + TIdURI.URLEncode( URL + '?' + Parameters.Text ) ) );
          {$ENDIF}
          IdHTTP.Get( TIdURI.URLEncode( URL + '?' + Parameters.Text ), Response );
        end;
        Post: begin
          {$IFDEF DEBUG}
          {log}Log.Add( TIso8601.DateTimeToIso8601( TUtc.UtcNow ) + ':' + Trim( 'POST > ' + TIdURI.URLEncode( URL ) + '?' + Parameters.Text ) );
          {$ENDIF}
          IdHTTP.Post( TIdURI.URLEncode( URL ), Parameters, Response );
        end;
      end;
      Result := Response.DataString;
      {$IFDEF DEBUG}
      {log}Log.Add( TIso8601.DateTimeToIso8601( TUtc.UtcNow ) + ':' + Trim( 'RESPONSE < ' + Result ) );
      {log}Log.SaveToFile( cDebugFilename );
      {$ENDIF}
    except
      on E: EIdURIException do
        raise EHttpUriException.Create( E.Message );
      on E: EIdConnectTimeout do
        raise EHttpConnectTimeout.Create( E.Message );
      on E: EIdHTTPProtocolException do
        raise EHttpProtocolException.Create( E.Message );
      on E: Exception do
        raise EHttpUnknownError.Create( E.Message );
    end;
  finally
    FreeAndNil( Response );
    FreeAndNil( Parameters );
    FreeAndNil( IdHTTP );
    {$IFDEF DEBUG}
    {log}Log.Free;
    {$ENDIF}
  end;
end;

{ THttpQuery }

class function THttp.Query(const Json: TJsonString; const Url: TUrl): TJsonString;
begin
  Exit( HttpResponse( Concat( ExcludeTrailingSlash( ServerAddress ), Url ), Json, Method ) );
end;

class function THttp.Query<T, S>(const Obj: S; const Url: TUrl): T;
begin
{ TODO : verifier/optimiser }
  try
    Result := TJson.JsonToObject< T >( Query( TJson.ObjectToJsonString( Obj ), Url ) );
  except
    Exit( nil );
  end;
//  Exit( TJson.JsonToObject< T >( Query( TJson.ObjectToJsonString( Obj ), Url ) ) );
end;

class function THttp.Query<T>(const Json: TJsonString; const Url: TUrl): T;
begin
  Exit( TJson.JsonToObject< T >( Query( Json, Url ) ) );
end;

class function THttp.Query<T>(const Obj: T; const Url: TUrl): TJsonString;
begin
  Exit( Query( TJson.ObjectToJsonString( Obj ), Url ) );
end;

initialization
  THttp.ServerAddress := 'localhost';
  THttp.Method := THttpMethod.Post;

finalization

end.
