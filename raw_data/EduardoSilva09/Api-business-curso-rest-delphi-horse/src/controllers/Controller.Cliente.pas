unit Controller.Cliente;

interface

procedure Registry;

implementation

uses
  Horse, Services.Cliente, System.JSON, DataSet.Serialize, Data.DB;

procedure ListarClientes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LRetorno: TJSONObject;
  LService: TServiceCliente;
begin
  LService := TServiceCliente.Create;
  try
    LRetorno := TJSONObject.Create;

    LRetorno.AddPair('data',    LService.ListAll(Req.Query).ToJSONArray());
    LRetorno.AddPair('records', TJSONNumber.Create(LService.GetRecordCount));

    Res.Send(LRetorno);
  finally
    LService.Free;
  end;
end;

procedure ObterCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdCliente: string;
  LService: TServiceCliente;
begin
  LService := TServiceCliente.Create;
  try
    LIdCliente := Req.Params['id'];

    if LService.GetById(LIdCliente).IsEmpty then
      raise EHorseException.New.Error('Cliente não cadastrado!')
        .Status(THTTPStatus.NotFound);

    Res.Send(LService.vQryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure CadatrarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LService: TServiceCliente;
begin
  LService := TServiceCliente.Create;
  try
    LBody := Req.Body<TJSONObject>;
    if LService.Append(LBody) then
      Res.Send(LService.vQryCadastro.ToJSONObject())
        .Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure AlterarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LIdCliente: string;
  LService: TServiceCliente;
begin
  LService := TServiceCliente.Create;
  try
    LIdCliente := Req.Params['id'];

    if LService.GetById(LIdCliente).IsEmpty then
      raise EHorseException.New.Error('Cliente não cadastrado!')
        .Status(THTTPStatus.NotFound);

    LBody := Req.Body<TJSONObject>;
    if LService.Update(LBody) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DeletarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdCliente: string;
  LService: TServiceCliente;
begin
  LService := TServiceCliente.Create;
  try
    LIdCliente := Req.Params['id'];

    if LService.GetById(LIdCliente).IsEmpty then
      raise EHorseException.New.Error('Cliente não cadastrado!')
        .Status(THTTPStatus.NotFound);

    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);

  finally
    LService.Free;
  end;
end;


procedure Registry;
begin
  THorse.Get('/clientes',        ListarClientes);
  THorse.Get('/clientes/:id',    ObterCliente);
  THorse.Post('/clientes',       CadatrarCliente);
  THorse.Put('/clientes/:id',    AlterarCliente);
  THorse.Delete('/clientes/:id', DeletarCliente);
end;

end.
