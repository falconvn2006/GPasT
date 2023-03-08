unit Controllers.Auth;

interface

procedure Registry;

implementation

uses
  Horse,
  Horse.JWT,
  System.JSON,
  Services.Auth,
  JOSE.Core.JWT,
  System.SysUtils,
  System.DateUtils,
  JOSE.Core.Builder;

const
  JWT_KEY = 'curso-rest-horse';

function GetToken(const AIdUsuario: string; const AExpiration: TDate): string;
var
  LJWT :TJWT;
begin
  LJWT := TJWT.Create;
  try
    LJWT.Claims.IssuedAt := Now;
    LJWT.Claims.Expiration := AExpiration;
    LJWT.Claims.Subject := AIdUsuario;

    Result := TJOSE.SHA256CompactToken(JWT_KEY, LJWT);
  finally
    LJWT.Free;
  end;
end;

procedure EfetuarLogin(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LContent, LToken: TJSONObject;
  LUsuario, LSenha: string;
  LService: TServiceAuth;
begin
  LContent := Req.Body<TJSONObject>;
  if not LContent.TryGetValue<string>('username', LUsuario) then
    raise EHorseException.New.Error('Usuário não informado')
      .Status(THTTPStatus.BadRequest);
  if not LContent.TryGetValue<string>('password', LSenha) then
    raise EHorseException.New.Error('Senha não informada')
      .Status(THTTPStatus.BadRequest);

  LService := TServiceAuth.Create(nil);
  try
    if not LService.PermitirAcesso(LUsuario, LSenha) then
      raise EHorseException.New.Error('Usuário não autorizado')
        .Status(THTTPStatus.Unauthorized);

    LToken := TJSONObject.Create;
    LToken.AddPair('access', GetToken(LService.vQryLoginid.AsString, IncHour(Now)));
    LToken.AddPair('refresh', GetToken(LService.vQryLoginid.AsString, IncMonth(Now)));
    Res.Send(LToken)

  finally
    LService.Free;
  end;

end;

procedure RenovarToken(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LSub, LToken : string;
begin
  LSub := Req.Session<TJSONObject>.GetValue('sub').Value;
  LToken := GetToken(LSub, IncHour(Now));
  Res.Send(TJSONObject.Create(TJSONPair.Create('access', LToken)));
end;

procedure Registry;
begin
  THorse.Post('/login', EfetuarLogin);
  THorse.AddCallback(HorseJWT(JWT_KEY)).Get('/refresh', RenovarToken)
end;

end.
