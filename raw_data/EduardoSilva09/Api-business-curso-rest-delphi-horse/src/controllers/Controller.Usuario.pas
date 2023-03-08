unit Controller.Usuario;

interface

uses
  Horse;

procedure Registry;

implementation

uses Services.Usuario, System.JSON, DataSet.Serialize, Data.DB, System.Classes;

procedure ListarUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LRetorno: TJSONObject;
  LService: TServiceUsuario;
begin
  LService := TServiceUsuario.Create;
  try
    LRetorno := TJSONObject.Create;

    LRetorno.AddPair('data', LService.ListAll(Req.Query).ToJSONArray());
    LRetorno.AddPair('records', TJSONNumber.Create(LService.GetRecordCount));

    Res.Send(LRetorno);
  finally
    LService.Free;
  end;
end;

procedure ObterUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdUsuario: string;
  LService: TServiceUsuario;
begin
  LService := TServiceUsuario.Create;
  try
    LIdUsuario := Req.Params['id'];

    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.New.Error('Usuário não cadastrado!')
        .Status(THTTPStatus.NotFound);

    Res.Send(LService.vQryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure CadatrarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LService: TServiceUsuario;
begin
  LService := TServiceUsuario.Create;
  try
    LBody := Req.Body<TJSONObject>;
    if LService.Append(LBody) then
      Res.Send(LService.vQryCadastro.ToJSONObject())
        .Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure AlterarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LIdUsuario: string;
  LService: TServiceUsuario;
begin
  LService := TServiceUsuario.Create;
  try
    LIdUsuario := Req.Params['id'];

    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.New.Error('Usuário não cadastrado!')
        .Status(THTTPStatus.NotFound);

    LBody := Req.Body<TJSONObject>;
    if LService.Update(LBody) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DeletarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdUsuario: string;
  LService: TServiceUsuario;
begin
  LService := TServiceUsuario.Create;
  try
    LIdUsuario := Req.Params['id'];

    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.New.Error('Usuário não cadastrado!')
        .Status(THTTPStatus.NotFound);

    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);

  finally
    LService.Free;
  end;
end;

procedure CadatrarFotoUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdUsuario: string;
  LFoto: TMemoryStream;
  LService: TServiceUsuario;
begin
  LService := TServiceUsuario.Create;
  try
    LIdUsuario := Req.Params['id'];

    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.New.Error('Usuário não cadastrado!')
        .Status(THTTPStatus.NotFound);

    LFoto := Req.Body<TMemoryStream>;

    if not Assigned(LFoto) then
      raise EHorseException.New.Error('Foto inválida!')
        .Status(THTTPStatus.BadRequest);

    if LService.SalvarFotoUsuario(LFoto) then
      Res.Send(LService.vQryCadastro.ToJSONObject())
        .Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure ObterFotoUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LFoto: TStream;
  LIdUsuario: string;
  LService: TServiceUsuario;
begin
  LService := TServiceUsuario.Create;
  try
    LIdUsuario := Req.Params['id'];

    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.New.Error('Usuário não cadastrado!')
        .Status(THTTPStatus.NotFound);

    LFoto := LService.ObterFotoUsuario;
    if not Assigned(LFoto) then
      raise EHorseException.New.Error('Foto não cadastrada!')
        .Status(THTTPStatus.BadRequest);

    Res.Send(LFoto);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/usuarios', ListarUsuarios);
  THorse.Get('/usuarios/:id', ObterUsuario);
  THorse.Post('/usuarios', CadatrarUsuario);
  THorse.Put('/usuarios/:id', AlterarUsuario);
  THorse.Delete('/usuarios/:id', DeletarUsuario);
  THorse.Get('/usuarios/:id/foto', ObterFotoUsuario);
  THorse.Post('/usuarios/:id/foto', CadatrarFotoUsuario);
end;

end.
