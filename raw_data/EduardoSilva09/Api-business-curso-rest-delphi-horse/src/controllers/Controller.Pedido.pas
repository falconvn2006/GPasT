unit Controller.Pedido;

interface

uses
  Horse;

procedure Registry;

implementation

uses Services.Pedido, System.JSON, DataSet.Serialize, Data.DB;

procedure ListarPedidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LRetorno: TJSONObject;
  LService: TServicePedido;
begin
  LService := TServicePedido.Create;
  try
    LRetorno := TJSONObject.Create;

    LRetorno.AddPair('data', LService.ListAll(Req.Query).ToJSONArray());
    LRetorno.AddPair('records', TJSONNumber.Create(LService.GetRecordCount));

    Res.Send(LRetorno);
  finally
    LService.Free;
  end;
end;

procedure ObterPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdPedido: string;
  LService: TServicePedido;
begin
  LService := TServicePedido.Create;
  try
    LIdPedido := Req.Params['id'];

    if LService.GetById(LIdPedido).IsEmpty then
      raise EHorseException.New.Error('Pedido não cadastrado!')
        .Status(THTTPStatus.NotFound);

    Res.Send(LService.vQryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure CadatrarPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LService: TServicePedido;
begin
  LService := TServicePedido.Create;
  try
    LBody := Req.Body<TJSONObject>;
    if LService.Append(LBody) then
      Res.Send(LService.vQryCadastro.ToJSONObject())
        .Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure AlterarPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LIdPedido: string;
  LService: TServicePedido;
begin
  LService := TServicePedido.Create;
  try
    LIdPedido := Req.Params['id'];

    if LService.GetById(LIdPedido).IsEmpty then
      raise EHorseException.New.Error('Pedido não cadastrado!')
        .Status(THTTPStatus.NotFound);

    LBody := Req.Body<TJSONObject>;
    if LService.Update(LBody) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DeletarPedido(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdPedido: string;
  LService: TServicePedido;
begin
  LService := TServicePedido.Create;
  try
    LIdPedido := Req.Params['id'];

    if LService.GetById(LIdPedido).IsEmpty then
      raise EHorseException.New.Error('Pedido não cadastrado!')
        .Status(THTTPStatus.NotFound);

    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);

  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/pedidos', ListarPedidos);
  THorse.Get('/pedidos/:id', ObterPedido);
  THorse.Post('/pedidos', CadatrarPedido);
  THorse.Put('/pedidos/:id', AlterarPedido);
  THorse.Delete('/pedidos/:id', DeletarPedido);
end;

end.
