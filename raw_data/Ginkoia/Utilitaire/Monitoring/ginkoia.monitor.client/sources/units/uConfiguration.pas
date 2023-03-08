unit uConfiguration;

interface

uses
  System.SysUtils,
  uAuthentication, uSubscription, uTypes;

type
  TConfiguration = class
  private const
    cDefaultFilename = 'monitor.json';
  private type
    TInfo = class
      FServer: TServer;
      FAccount: TAuthenticationAccount;
      FSubscriptions: TSubscriptions;
      FColors: TTileColors;
      constructor Create(const Server: TServer;
        const Account: TAuthenticationAccount;
        const Subscriptions: TSubscriptions;
        const Colors: TTileColors); reintroduce;
    end;
  private class var
    FServer: TServer;
    FAccount: TAuthenticationAccount;
    FSubscriptions: TSubscriptions;
    FColors: TTileColors;
    class function GetJson: String; static;
    class procedure SetJson(const Value: String); static;
    class function GetHasAccount: Boolean; static;
    class function GetHasServerAddress: Boolean; static;
    class function GetHasSubscriptions: Boolean; static;
    class procedure Clear;
  public
    { methods }
    class procedure ClearAccount; static;
    class procedure ClearSubscriptions; static;
    class procedure ClearColors; static;
    class function ParseParameters: Boolean;
    class function Load(const Filename: TFilename = cDefaultFilename): Boolean;
    class function Save(const Filename: TFilename = cDefaultFilename): Boolean;
    class procedure Add(const Subscription: TSubscription);
    class procedure Insert(const Subscription: TSubscription;
      const Index: Integer);
    class procedure Delete(const Index: Integer);
    class procedure DeleteAll;
    class function IndexOf(const Subscription: TSubscription): Integer;
    { properties }
    class property Account: TAuthenticationAccount read FAccount write FAccount;
    class property Server: TServer read FServer write FServer;
    class property Subscriptions: TSubscriptions read FSubscriptions
      write FSubscriptions;
    class property Colors: TTileColors read FColors write FColors;
    class property HasServerAddress: Boolean read GetHasServerAddress;
    class property HasAccount: Boolean read GetHasAccount;
    class property HasSubscriptions: Boolean read GetHasSubscriptions;
  end;

  ESubscriptionsError = class( Exception );

resourcestring
  SSubscriptionIndexOutOfBounds = 'Index hors limites (%d)';

implementation

uses
  System.Classes,
  REST.Json;

{ TConfiguration }

class procedure TConfiguration.Add(const Subscription: TSubscription);
begin
  Insert( Subscription, Length( FSubscriptions ) );
end;

class procedure TConfiguration.Clear;
begin
  ClearSubscriptions;
  ClearColors;
  ClearAccount;
end;

class procedure TConfiguration.ClearAccount;
begin
  FreeAndNil( FAccount );
end;

class procedure TConfiguration.ClearColors;
begin
  FreeAndNil( FColors );
end;

class procedure TConfiguration.ClearSubscriptions;
var
  Subscription: TSubscription;
  ALength: Integer;
begin
  ALength := Length( FSubscriptions );
  for Subscription in FSubscriptions do
    Subscription.Free;
  SetLength( FSubscriptions, 0 );
  Initialize( FSubscriptions[ 0 ] );
end;

class procedure TConfiguration.Delete(const Index: Integer);
var
  ALength: Integer;
  TailElements: Integer;
begin
  ALength := Length( FSubscriptions );
  if ( Index < 0 ) or ( Index > Length( FSubscriptions ) ) then
    raise ESubscriptionsError.CreateResFmt( @SSubscriptionIndexOutOfBounds,
      [ Index ] );
  Finalize( FSubscriptions[ Index ] );
  { TODO : memory leak => dispose TSubscription }
  FSubscriptions[ Index ].Free;
  TailElements := ALength - Index;
  if TailElements > 0 then
    Move( FSubscriptions[ Index + 1], FSubscriptions[ Index ],
      SizeOf( TSubscription ) * TailElements );
  Initialize( FSubscriptions[ ALength - 1 ] );
  SetLength( FSubscriptions, ALength - 1 );
end;

class procedure TConfiguration.DeleteAll;
begin
  { TODO : debug leak }
  SetLength( FSubscriptions, 0 );
end;

class function TConfiguration.GetHasAccount: Boolean;
begin
  Exit( Assigned( TConfiguration.FAccount ) );
end;

class function TConfiguration.GetHasServerAddress: Boolean;
begin
  Exit( not SameText( Trim( TConfiguration.FServer ), '' ) );
end;

class function TConfiguration.GetHasSubscriptions: Boolean;
begin
  Exit( Length( TConfiguration.FSubscriptions ) > 0 );
end;

class function TConfiguration.GetJson: String;
  { TODO : Clear \/ }
  function Fix(const Json: string; const Chars: array of Char): String;
  var
    i: Integer;
  begin
    Result := Json;
    for i := Low( Chars ) to High( Chars ) do
      Result := StringReplace( Result, Concat( '\', Chars[ i ] ), Chars[ i ],
        [ System.SysUtils.rfReplaceAll ] );
  end;
var
  Info: TInfo;
begin
  Info := TInfo.Create( TConfiguration.FServer, TConfiguration.FAccount,
    TConfiguration.FSubscriptions, TConfiguration.FColors );
  try
    Exit( Fix( TJson.ObjectToJsonString( Info ), [ '/' ] ) );
  finally
    Info.Free;
  end;
end;

class function TConfiguration.IndexOf(
  const Subscription: TSubscription): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := Low( FSubscriptions ) to High( FSubscriptions ) do
    { TODO : case sensitive comparison ? }
    if SameText( TJson.ObjectToJsonString( FSubscriptions[ i ] ),
      TJson.ObjectToJsonString( Subscription ) ) then
      Exit( i );
end;

class procedure TConfiguration.Insert(const Subscription: TSubscription;
  const Index: Integer);
var
  ALength: Integer;
  TailElements: Integer;
begin
  ALength := Length( FSubscriptions );
  if ( Index < 0 ) or ( Index > Length( FSubscriptions ) ) then
    raise ESubscriptionsError.CreateResFmt( @SSubscriptionIndexOutOfBounds,
      [ Index ] );
  SetLength( FSubscriptions , ALength + 1 );
  Finalize( FSubscriptions [ ALength ] );
  TailElements := ALength - Index;
  if TailElements > 0 then
    Move( FSubscriptions[ Index ], FSubscriptions[ Index + 1 ],
      SizeOf( TSubscription ) * TailElements );
  Initialize( FSubscriptions[ Index ] );
  FSubscriptions[ Index ] := Subscription;
end;

class function TConfiguration.Load(const Filename: TFilename): Boolean;
var
  FileStream: TFileStream;
  StreamReader: TStreamReader;
  Subscription: TSubscription;
  {$IFDEF DEBUG}
  Json: String;
  {$ENDIF}
begin
  if not FileExists( Filename ) then
    Exit( False );

  try
    FileStream := TFileStream.Create( Filename, fmOpenRead or
      fmShareDenyWrite );
    StreamReader := TStreamReader.Create( FileStream );
    try
      {$IFDEF DEBUG}
      Json := StreamReader.ReadToEnd;
      SetJson( Json );
      {$ELSE}
      SetJson( StreamReader.ReadToEnd );
      {$ENDIF}
      Exit( True );
    finally
      StreamReader.Free;
      FileStream.Free;
    end;
  except
    Exit( False );
  end;
end;

class function TConfiguration.ParseParameters: Boolean;
var
  bServer, bLogin, bPassword: Boolean;
  sServer, sLogin, sPassword: String;
begin
  { guard clause }
  if ParamCount < 2 then
    Exit( False );

  { initialization }
  sServer := '';
  sLogin := '';
  sPassword := '';

  { retreive }
  bServer := FindCmdLineSwitch( 's', sServer ) or FindCmdLineSwitch( 'server', sServer );
  bLogin := FindCmdLineSwitch( 'l', sLogin ) or FindCmdLineSwitch( 'login', sLogin );
  bPassword := FindCmdLineSwitch( 'p', sPassword ) or FindCmdLineSwitch( 'password', sPassword );

  { assignation }
  if bServer then
    FServer := sServer;

  if bLogin or bPassword then begin
    if not Assigned( FAccount ) then
      FAccount := TAuthenticationAccount.Create( sLogin, sPassword )
    else begin
      if bLogin then
        FAccount.Login := sLogin;
      if bPassword then
        FAccount.Password := sPassword;
    end;
  end;
end;

class function TConfiguration.Save(const Filename: TFilename): Boolean;
var
  FileStream: TFileStream;
  StreamWriter: TStreamWriter;
  Json: String;
begin
  try
    FileStream := TFileStream.Create( Filename, fmCreate or fmShareDenyWrite );
    StreamWriter := TStreamWriter.Create( FileStream );
    try
      Json := TConfiguration.GetJson;
      StreamWriter.Write( Json );
      Exit( True );
    finally
      StreamWriter.Free;
      FileStream.Free;
    end;
  except
    Exit( False );
  end;
end;

class procedure TConfiguration.SetJson(const Value: String);
var
  Info: TInfo;
begin
  Info := TJson.JsonToObject< TInfo >( Value );
  try
    TConfiguration.Server:= Info.FServer;
    ClearAccount;
    TConfiguration.Account := Info.FAccount;
    ClearSubscriptions;
    TConfiguration.Subscriptions := Info.FSubscriptions;
    ClearColors;
    TConfiguration.Colors := Info.FColors;
    { override with parameters }
    TConfiguration.ParseParameters;
  finally
    Info.Free;
  end;
end;

{ TConfiguration.TInfo }

constructor TConfiguration.TInfo.Create(const Server: TServer;
  const Account: TAuthenticationAccount; const Subscriptions: TSubscriptions;
  const Colors: TTileColors);
begin
  FServer := Server;
  FAccount := Account;
  FSubscriptions := Subscriptions;
  FColors := Colors;
end;

initialization

finalization
  TConfiguration.Clear;

end.
