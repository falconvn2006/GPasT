unit Controllers.Global;

interface

uses Horse,
     DataModule.Global,
     System.JSON,
     System.SysUtils;

procedure RegistrarRotas;
procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure CriarConta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EditarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EditarSenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListarTreinos(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarRotas;
begin
  THorse.Post('/usuarios/login', Login);
  THorse.Post('/usuarios/registro', CriarConta);
  THorse.Put('/usuarios', EditarUsuario);
  THorse.Put('/usuarios/senha', EditarSenha);
  THorse.Get('/treinos', ListarTreinos);

end;

procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dmGlobal: TDmGlobal;
  email, senha: string;
  body, jsonRet: TJSONObject;
begin
  try
    try
      dmGlobal := TDmGlobal.Create(nil);

      body := Req.Body<TJSONObject>;
      email := body.GetValue<string>('email', EmptyStr);
      senha := body.GetValue<string>('senha', EmptyStr);

      jsonRet := dmGlobal.Login(email, senha);

      if(jsonRet.Size = 0)then
        Res.Send('E-mail ou senha inválida').Status(401)
      else
        Res.Send<TJSONObject>(jsonRet).Status(200);

    except
      on E:Exception do
        Res.Send(E.Message).Status(500);
    end;
  finally
    FreeAndNil(dmGlobal);
  end;
end;

procedure CriarConta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dmGlobal: TDmGlobal;
  nome, email, senha: string;
  body, jsonRet: TJSONObject;
begin
  try
    try
      dmGlobal := TDmGlobal.Create(nil);

      body := Req.Body<TJSONObject>;
      nome  := body.GetValue<string>('nome', EmptyStr);
      email := body.GetValue<string>('email', EmptyStr);
      senha := body.GetValue<string>('senha', EmptyStr);

      jsonRet := dmGlobal.CriarConta(nome, email, senha);

      Res.Send<TJSONObject>(jsonRet).Status(201);

    except
      on E:Exception do
        Res.Send(E.Message).Status(500);
    end;
  finally
    FreeAndNil(dmGlobal);
  end;
end;

procedure EditarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dmGlobal: TDmGlobal;
  idUsuario: Integer;
  nome, email: string;
  body, jsonRet: TJSONObject;
begin
  try
    try
      dmGlobal := TDmGlobal.Create(nil);

      body := Req.Body<TJSONObject>;
      nome  := body.GetValue<string>('nome', EmptyStr);
      email := body.GetValue<string>('email', EmptyStr);
      idUsuario := body.GetValue<integer>('id_usuario', 0);

      jsonRet := dmGlobal.EditarUsuario(idUsuario, nome, email);

      Res.Send<TJSONObject>(jsonRet).Status(200);

    except
      on E:Exception do
        Res.Send(E.Message).Status(500);
    end;
  finally
    FreeAndNil(dmGlobal);
  end;
end;

procedure EditarSenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dmGlobal: TDmGlobal;
  idUsuario: Integer;
  senha: string;
  body, jsonRet: TJSONObject;
begin
  try
    try
      dmGlobal := TDmGlobal.Create(nil);

      body := Req.Body<TJSONObject>;
      idUsuario := body.GetValue<integer>('id_usuario', 0);
      senha     := body.GetValue<string>('senha', EmptyStr);

      jsonRet := dmGlobal.EditarSenha(idUsuario, senha);

      Res.Send<TJSONObject>(jsonRet).Status(200);

    except
      on E:Exception do
        Res.Send(E.Message).Status(500);
    end;
  finally
    FreeAndNil(dmGlobal);
  end;
end;

procedure ListarTreinos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dmGlobal: TDmGlobal;
  idUsuario: Integer;
begin
  try
    try
      dmGlobal := TDmGlobal.Create(nil);
      try
        idUsuario := Req.Query['id_usuario'].ToInteger;
      except
        idUsuario := 0;
      end;

      Res.Send<TJSONArray>(dmGlobal.ListarTreinos(idUsuario)).Status(200);
    except
      on E:Exception do
        Res.Send(E.Message).Status(500);
    end;
  finally
    FreeAndNil(dmGlobal);
  end;
end;
end.
