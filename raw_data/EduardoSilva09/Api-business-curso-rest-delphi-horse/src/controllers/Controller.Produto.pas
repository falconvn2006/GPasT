unit Controller.Produto;

interface

uses
  Horse;

procedure Registry;

implementation

uses Services.Produto, System.JSON, DataSet.Serialize, Data.DB;

procedure ListarProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LRetorno: TJSONObject;
  LService: TServiceProduto;
begin
  LService := TServiceProduto.Create;
  try
    LRetorno := TJSONObject.Create;

    LRetorno.AddPair('data', LService.ListAll(Req.Query).ToJSONArray());
    LRetorno.AddPair('records', TJSONNumber.Create(LService.GetRecordCount));

    Res.Send(LRetorno);
  finally
    LService.Free;
  end;
end;

procedure ObterProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdProduto: string;
  LService: TServiceProduto;
begin
  LService := TServiceProduto.Create;
  try
    LIdProduto := Req.Params['id'];

    if LService.GetById(LIdProduto).IsEmpty then
      raise EHorseException.New.Error('Produto não cadastrado!')
        .Status(THTTPStatus.NotFound);

    Res.Send(LService.vQryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure CadatrarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LService: TServiceProduto;
begin
  LService := TServiceProduto.Create;
  try
    LBody := Req.Body<TJSONObject>;
    if LService.Append(LBody) then
      Res.Send(LService.vQryCadastro.ToJSONObject())
        .Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure AlterarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LIdProduto: string;
  LService: TServiceProduto;
begin
  LService := TServiceProduto.Create;
  try
    LIdProduto := Req.Params['id'];

    if LService.GetById(LIdProduto).IsEmpty then
      raise EHorseException.New.Error('Produto não cadastrado!')
        .Status(THTTPStatus.NotFound);

    LBody := Req.Body<TJSONObject>;
    if LService.Update(LBody) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DeletarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdProduto: string;
  LService: TServiceProduto;
begin
  LService := TServiceProduto.Create;
  try
    LIdProduto := Req.Params['id'];

    if LService.GetById(LIdProduto).IsEmpty then
      raise EHorseException.New.Error('Produto não cadastrado!')
        .Status(THTTPStatus.NotFound);

    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);

  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/produtos', ListarProdutos);
  THorse.Get('/produtos/:id', ObterProduto);
  THorse.Post('/produtos', CadatrarProduto);
  THorse.Put('/produtos/:id', AlterarProduto);
  THorse.Delete('/produtos/:id', DeletarProduto);
end;

end.
