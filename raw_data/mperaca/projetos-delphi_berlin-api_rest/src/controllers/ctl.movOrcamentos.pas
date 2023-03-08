unit ctl.movOrcamentos;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses dat.movOrcamentos, models.movOrcamentos, prv.dataModuleConexao;


procedure ListaTodosOrcamentos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
    widempresa: integer;
    wconexao: TProviderDataModuleConexao;
    wlimit,woffset: integer;
begin
  try
    if Req.Query.ContainsKey('limit') then // limite de registros retornados
       wlimit := Req.Query.Items['limit'].ToInteger
    else
       wlimit := -1;
    if Req.Query.ContainsKey('offset') then // offset do registro
       woffset := Req.Query.Items['offset'].ToInteger
    else
       woffset := -1;
    wconexao      := TProviderDataModuleConexao.Create(nil);
    widempresa    := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini
    wlista := TJSONArray.Create;
    wlista := dat.movOrcamentos.RetornaListaOrcamentos(Req.Query,widempresa,wlimit,woffset);
    wret   := wlista.Items[0] as TJSONObject;
    if wret.TryGetValue('status',wval) then
       Res.Send<TJSONArray>(wlista).Status(400)
    else
       Res.Send<TJSONArray>(wlista).Status(200);
  except
    On E: Exception do
    begin
      werro := TJSONObject.Create;
      werro.AddPair('status','500');
      werro.AddPair('description',E.Message);
      werro.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
end;


procedure RetornaOrcamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamento,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid          := Req.Params['id'].ToInteger; // recupera o id do orçamento
    worcamento := TJSONObject.Create;
    worcamento := Req.Body<TJSONObject>;
    worcamento := dat.movOrcamentos.RetornaOrcamento(wid);
    if worcamento.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(worcamento).Status(400)
    else
       Res.Send<TJSONObject>(worcamento).Status(200);
  except
    On E: Exception do
    begin
      werro := TJSONObject.Create;
      werro.AddPair('status','500');
      werro.AddPair('description',E.Message);
      werro.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
end;

procedure ExcluiOrcamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamento,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid          := Req.Params['id'].ToInteger; // recupera o id do orçamento
    worcamento := TJSONObject.Create;
    worcamento := dat.movOrcamentos.ApagaOrcamento(wid);
    if worcamento.GetValue('status').Value='200' then
       Res.Send<TJSONObject>(worcamento).Status(200)
    else
       Res.Send<TJSONObject>(worcamento).Status(400);
  except
    On E: Exception do
    begin
      werro := TJSONObject.Create;
      werro.AddPair('status','500');
      werro.AddPair('description',E.Message);
      werro.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
end;

procedure AlteraOrcamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wneworcamento,worcamento,werro,wresp: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid           := Req.Params['id'].ToInteger; // recupera o id do orçamento
    wneworcamento := TJSONObject.Create;
    worcamento    := TJSONObject.Create;
    wresp         := TJSONObject.Create;
    worcamento    := Req.Body<TJSONObject>;
    wneworcamento := dat.movOrcamentos.AlteraOrcamento(wid,worcamento);
    if wneworcamento.TryGetValue('numero',wval) then
       begin
         wneworcamento.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wneworcamento).Status(200)
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Orçamento não encontrado');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(400);
       end;
  except
    On E: Exception do
    begin
      werro := TJSONObject.Create;
      werro.AddPair('status','500');
      werro.AddPair('description',E.Message);
      werro.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
end;

procedure CriaOrcamento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamento,wneworcamento,wresp,werro: TJSONObject;
    wval: string;
    widempresa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    worcamento    := TJSONObject.Create;
    wneworcamento := TJSONObject.Create;
    wresp         := TJSONObject.Create;
    worcamento    := Req.Body<TJSONObject>;
    wconexao      := TProviderDataModuleConexao.Create(nil);
    widempresa    := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

//    widempresa      := strtointdef(Req.Headers['idempresa'],0);

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.movOrcamentos.VerificaRequisicao(worcamento) then
       begin
         wneworcamento := dat.movOrcamentos.IncluiOrcamento(worcamento,widempresa);
         if wneworcamento.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wneworcamento).Status(400)
         else
            Res.Send<TJSONObject>(wneworcamento).Status(201);
       end
    else
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','JSON preenchido incorretamente');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end;
  except
    On E: Exception do
    begin
      werro := TJSONObject.Create;
      werro.AddPair('status','500');
      werro.AddPair('description',E.Message);
      werro.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
end;

procedure RetornaTotalOrcamentos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wtotal,werro: TJSONObject;
    wval: string;
begin
  try
    wtotal := TJSONObject.Create;
    wtotal := dat.movOrcamentos.RetornaTotalOrcamentos(Req.Query);
    if wtotal.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wtotal).Status(400)
    else
       Res.Send<TJSONObject>(wtotal).Status(200);
  except
    On E: Exception do
    begin
      werro := TJSONObject.Create;
      werro.AddPair('status','500');
      werro.AddPair('description',E.Message);
      werro.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
    end;
  end;
end;

procedure Registry;
begin
// Método Get
  THorse.Get('/trabinapi/movimentos/orcamentos',ListaTodosOrcamentos);
  THorse.Get('/trabinapi/movimentos/orcamentos/:id',RetornaOrcamento);
  THorse.Get('/trabinapi/movimentos/orcamentos/total',RetornaTotalOrcamentos);

// Método Post
  THorse.Post('/trabinapi/movimentos/orcamentos',CriaOrcamento);


// Método Put
  THorse.Put('/trabinapi/movimentos/orcamentos/:id',AlteraOrcamento);

  // Método Delete
  THorse.Delete('/trabinapi/movimentos/orcamentos/:id',ExcluiOrcamento);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('movimentos/orcamentos')
      .Tag('Orçamentos')
      .GET('Listar orçamentos')
        .AddParamQuery('id', 'Id').&End
        .AddParamQuery('numero', 'Número').&End
        .AddParamQuery('datavalidade', 'Data Validade').&End
        .AddParamQuery('cliente', 'Cliente').&End
        .AddParamQuery('vendedor', 'Vendedor').&End
        .AddParamQuery('total', 'Total').&End
        .AddParamQuery('condicao', 'Condição').&End
        .AddParamQuery('cobranca', 'Cobrança').&End
        .AddResponse(200, 'Lista de orçamentos').Schema(TOrcamentos).IsArray(True).&End
      .&End
      .POST('Criar um novo orçamento')
        .AddParamBody('Dados do orçamento').Required(True).Schema(TOrcamentos).&End
        .AddResponse(201).Schema(TOrcamentos).&End
        .AddResponse(400).&End
      .&End
    .&End
    .Path('movimentos/orcamentos/{id}')
      .Tag('Orçamentos')
      .GET('Obter os dados de um orçamento específico')
        .AddParamPath('id', 'Id').&End
        .AddResponse(200, 'Dados da orçamento').Schema(TOrcamentos).&End
        .AddResponse(404).&End
      .&End
      .PUT('Alterar os dados de um orçamento')
        .AddParamPath('id', 'Código').&End
        .AddParamBody('Dados do Orçamento').Required(True).Schema(TOrcamentosAltera).&End
        .AddResponse(201).Schema(TOrcamentos).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
      .DELETE('Excluir orçamento')
        .AddParamPath('id', 'Id').&End
        .AddResponse(204).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;
end.
