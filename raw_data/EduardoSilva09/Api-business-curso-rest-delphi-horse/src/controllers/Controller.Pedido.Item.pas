unit Controller.Pedido.Item;

interface

uses
  Horse;

procedure Registry;

implementation

uses Services.Pedido.Item, System.JSON, DataSet.Serialize, Data.DB;

procedure ListarItens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdPedido: string;
  LRetorno: TJSONObject;
  LService: TServicePedidoItem;
begin
  LService := TServicePedidoItem.Create;
  try
    LIdPedido := Req.Params['id_pedido'];
    LRetorno := TJSONObject.Create;

    LRetorno.AddPair('data', LService.ListAllByIdPedido(Req.Query, LIdPedido).ToJSONArray());
    LRetorno.AddPair('records', TJSONNumber.Create(LService.GetRecordCount));

    Res.Send(LRetorno);
  finally
    LService.Free;
  end;
end;

procedure ObterItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdPedido, LIdItem: string;
  LService: TServicePedidoItem;
begin
  LService := TServicePedidoItem.Create;
  try
    LIdItem := Req.Params['id_item'];
    LIdPedido := Req.Params['id_pedido'];

    if LService.GetByPedido(LIdPedido, LIdItem).IsEmpty then
      raise EHorseException.New.Error('Item não cadastrado!')
        .Status(THTTPStatus.NotFound);

    Res.Send(LService.vQryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure CadatrarItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdPedido: string;
  LItem: TJSONObject;
  LService: TServicePedidoItem;
begin
  LService := TServicePedidoItem.Create;
  try
    LItem := Req.Body<TJSONObject>;
    LIdPedido := Req.Params['id_pedido'];
    LItem.RemovePair('idPedido').Free;
    LItem.AddPair('idPedido', TJSONNumber.Create(LIdPedido));
    if LService.Append(LItem) then
      Res.Send(LService.vQryCadastro.ToJSONObject()).Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure AlterarItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdPedido, LIdItem: string;
  LItem: TJSONObject;
  LService: TServicePedidoItem;
begin
  LService := TServicePedidoItem.Create;
  try
    LIdItem := Req.Params['id_item'];
    LIdPedido := Req.Params['id_pedido'];

    if LService.GetByPedido(LIdPedido, LIdItem).IsEmpty then
      raise EHorseException.New.Error('Item não cadastrado!')
        .Status(THTTPStatus.NotFound);

    LItem := Req.Body<TJSONObject>;
    LItem.RemovePair('idPedido').Free;

    if LService.Update(LItem) then
      Res.Send(LService.vQryCadastro.ToJSONObject()).Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DeletarItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdPedido, LIdItem: string;
  LService: TServicePedidoItem;
begin
  LService := TServicePedidoItem.Create;
  try
    LIdItem := Req.Params['id_item'];
    LIdPedido := Req.Params['id_pedido'];

    if LService.GetByPedido(LIdPedido, LIdItem).IsEmpty then
      raise EHorseException.New.Error('Item não cadastrado!')
        .Status(THTTPStatus.NotFound);

    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/pedidos/:id_pedido/itens',          ListarItens);
  THorse.Get('/pedidos/:id_pedido/itens/:id_item', ObterItem);
  THorse.Post('/pedidos/:id_pedido/itens',         CadatrarItem);
  THorse.Put('/pedidos/:id_pedido/itens/:id_item', AlterarItem);
  THorse.Delete('/pedidos/:id_pedido/itens/:id_item',DeletarItem);
end;

end.
