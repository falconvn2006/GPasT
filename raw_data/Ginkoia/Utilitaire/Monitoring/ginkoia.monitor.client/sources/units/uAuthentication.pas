unit uAuthentication;

interface

uses
  uHttp, uTypes;

type
  TAuthenticationAccount = class
  private
    FLogin: TLogin;
    FPassword: TPassword;
  public
    constructor Create(const Login: TLogin;
      const Password: TPassword); reintroduce;
    property Login: TLogin read FLogin write FLogin;
    property Password: TPassword read FPassword write FPassword;
  end;

  TAuthentication = class
  private const
    cUrl = '/login.php';
  private type
    TRequest = class
      FLogin: TLogin;
      FPassword: TPassword;
      constructor Create(const Login: TLogin;
        const Password: TPassword); reintroduce;
    end;
    TResponse = class
      FUid: TUid;
    end;
  private
    FAccount: TAuthenticationAccount;
    FUid: TUid;
    function GetHasAccount: Boolean;
    function GetHasUid: Boolean;
    { TODO : remove useless stuffs }
  public
    { constructor/destructor }
    constructor Create(const Account: TAuthenticationAccount;
      const Uid: TUid); overload;
    constructor Create(const Login: TLogin; const Password: TPassword;
      const Uid: TUid); overload;
    destructor Destroy; override;
    { events }
    class function Get(const Login: TLogin;
      const Password: TPassword): TAuthentication; overload;
    class function Get(const Account: TAuthenticationAccount): TAuthentication; overload;
    { properties }
    property Account: TAuthenticationAccount read FAccount write FAccount;
    property Uid: TUid read FUid write FUid;
    property HasAccount: Boolean read GetHasAccount;
    property HasUid: Boolean read GetHasUid;
  end;

implementation

uses
  System.SysUtils;

{ TAuthentication.TRequest }

constructor TAuthentication.TRequest.Create(const Login: TLogin;
  const Password: TPassword);
begin
  FLogin := Login;
  FPassword := Password;
end;

{ TAuthentication }

constructor TAuthentication.Create(const Login: TLogin;
  const Password: TPassword; const Uid: TUid);
begin
  Create( TAuthenticationAccount.Create( Login, Password), Uid );
end;

constructor TAuthentication.Create(const Account: TAuthenticationAccount;
  const Uid: TUid);
begin
  FAccount := Account;
  FUid := Uid;
end;

destructor TAuthentication.Destroy;
begin
  FAccount.Free;
  inherited;
end;

class function TAuthentication.Get(
  const Account: TAuthenticationAccount): TAuthentication;
begin
  Exit( Get( Account.FLogin, Account.FPassword ) );
end;

function TAuthentication.GetHasAccount: Boolean;
begin
  Exit( Assigned( FAccount ) );
end;

function TAuthentication.GetHasUid: Boolean;
begin
  Exit( not SameText( Trim( FUid ), '' ) );
end;

class function TAuthentication.Get(const Login: TLogin;
  const Password: TPassword): TAuthentication;
var
  Response: TResponse;
  Request: TRequest;
begin
  try
    Request := TRequest.Create( Login, Password );
    try
      try
        Response := THttp.Query< TResponse, TRequest >( Request, cUrl );
        if Assigned( Response ) then
          Exit( TAuthentication.Create( Login, Password, Response.FUid ) )
        else
          Exit( TAuthentication.Create( Login, Password, '' ) );
      finally
        Response.Free;
      end;
    finally
      Request.Free;
    end;
  except
    Exit( nil );
  end;
end;

{ TAuthenticationAccount }

constructor TAuthenticationAccount.Create(const Login: TLogin;
  const Password: TPassword);
begin
  FLogin := Login;
  FPassword := Password;
end;

end.
