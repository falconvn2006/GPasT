unit ctl.movOrcamentosItens;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses dat.movOrcamentosItens, models.movOrcamentosItens, prv.dataModuleConexao;


procedure RetornaOrcamentoItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoitem,werro: TJSONObject;
    wid,widorcamento: integer;
    wval: string;
begin
  try
    widorcamento   := Req.Params['orcamento'].ToInteger; // recupera o id da nfe
    wid            := Req.Params['id'].ToInteger; // recupera o id do item
    worcamentoitem := TJSONObject.Create;
    worcamentoitem := dat.movOrcamentosItens.RetornaOrcamentoItem(widorcamento,wid);
    if worcamentoitem.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(worcamentoitem).Status(400)
    else
       Res.Send<TJSONObject>(worcamentoitem).Status(200);
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

procedure RetornaIdOrcamentoItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoitem,werro: TJSONObject;
    widproduto,widorcamento,widitem: integer;
    wval: string;
begin
  try
    worcamentoitem := TJSONObject.Create;
    widorcamento   := Req.Params['orcamento'].ToInteger; // recupera o id do pedido
    widproduto     := Req.Params['idproduto'].ToInteger; // recupera o id do produto
    worcamentoitem := dat.movOrcamentosItens.RetornaIdOrcamentoItem(widorcamento,widproduto);
    Res.Send<TJSONObject>(worcamentoitem).Status(200);
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

procedure RetornaIdOrcamentoItemGrade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoitem,werro: TJSONObject;
    widproduto,widorcamento,widitem,wtamanho,wcor: integer;
    wval: string;
begin
  try
    worcamentoitem := TJSONObject.Create;
    widorcamento   := Req.Params['orcamento'].ToInteger; // recupera o id do pedido
    widproduto     := Req.Params['idproduto'].ToInteger; // recupera o id do produto
    wtamanho       := Req.Params['tamanho'].ToInteger; // recupera o id do produto
    wcor           := Req.Params['cor'].ToInteger; // recupera o id do produto
    worcamentoitem := dat.movOrcamentosItens.RetornaIdOrcamentoItemGrade(widorcamento,widproduto,wtamanho,wcor);
    Res.Send<TJSONObject>(worcamentoitem).Status(200);
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


procedure RetornaOrcamentoItens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoitem: TJSONArray;
    werro: TJSONObject;
    widorcamento: integer;
    wval: string;
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
    widorcamento   := Req.Params['orcamento'].ToInteger; // recupera o id da nfe
    worcamentoitem := TJSONArray.Create;
    worcamentoitem := dat.movOrcamentosItens.RetornaOrcamentoItens(Req.Query,widorcamento,wlimit,woffset);
    werro    := worcamentoitem.Get(0) as TJSONObject;
    if werro.TryGetValue('status',wval) then
       begin
         Res.Send<TJSONArray>(worcamentoitem).Status(400);
       end
    else
       begin
         Res.Send<TJSONArray>(worcamentoitem).Status(200);
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


procedure ExcluiOrcamentoItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoitem,werro: TJSONObject;
    widorcamento,wid: integer;
    wval: string;
begin
  try
    widorcamento     := Req.Params['orcamento'].ToInteger; // recupera o id do orçamento
    wid      := Req.Params['id'].ToInteger; // recupera o id do item
    worcamentoitem := TJSONObject.Create;
    worcamentoitem := Req.Body<TJSONObject>;
    worcamentoitem := dat.movOrcamentosItens.ApagaOrcamentoItem(widorcamento,wid);
    if worcamentoitem.GetValue('status').Value='200' then
       Res.Send<TJSONObject>(worcamentoitem).Status(200)
    else
       Res.Send<TJSONObject>(worcamentoitem).Status(400);
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

procedure CriaOrcamentoItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoItem,wneworcamentoItem,wresp,werro: TJSONObject;
    wval: string;
    widempresa,widorcamento: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    worcamentoItem     := TJSONObject.Create;
    wneworcamentoItem  := TJSONObject.Create;
    wresp              := TJSONObject.Create;
    worcamentoItem     := Req.Body<TJSONObject>;
    widorcamento       := Req.Params['orcamento'].ToInteger; // recupera o id do orçamento
    wconexao           := TProviderDataModuleConexao.Create(nil);
    widempresa         := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

//    widempresa      := strtointdef(Req.Headers['idempresa'],0);

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.movOrcamentosItens.VerificaRequisicao(worcamentoitem) then
       begin
         wneworcamentoItem := dat.movOrcamentosItens.IncluiOrcamentoItem(worcamentoItem,widorcamento,widempresa);
         if wneworcamentoItem.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wneworcamentoItem).Status(400)
         else
            Res.Send<TJSONObject>(wneworcamentoItem).Status(201);
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

procedure AlteraOrcamentoItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var worcamentoItem,wneworcamentoItem,wresp,werro: TJSONObject;
    wval: string;
    widempresa,widorcamento,widitem: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    worcamentoItem     := TJSONObject.Create;
    wneworcamentoItem  := TJSONObject.Create;
    wresp              := TJSONObject.Create;
    worcamentoItem     := Req.Body<TJSONObject>;
    widorcamento       := Req.Params['orcamento'].ToInteger; // recupera o id do orçamento
    widitem            := Req.Params['id'].ToInteger; // recupera o id do item
    wconexao           := TProviderDataModuleConexao.Create(nil);
    widempresa         := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

//    widempresa      := strtointdef(Req.Headers['idempresa'],0);

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
         exit;
       end;

    wneworcamentoItem := dat.movOrcamentosItens.AlteraOrcamentoItem(widitem,worcamentoitem);
    if wneworcamentoItem.TryGetValue('idproduto',wval) then
       begin
         wneworcamentoItem.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wneworcamentoItem).Status(200)
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

procedure RetornaTotalItens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wtotal,werro: TJSONObject;
    wval: string;
    widorcamento: integer;
begin
  try
    widorcamento     := Req.Params['orcamento'].ToInteger; // recupera o id da Pessoa
    wtotal := TJSONObject.Create;
    wtotal := dat.movOrcamentosItens.RetornaTotalItens(Req.Query,widorcamento);
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
  THorse.Get('/trabinapi/movimentos/orcamentos/:orcamento/itens',RetornaOrcamentoItens);
  THorse.Get('/trabinapi/movimentos/orcamentos/:orcamento/itens/:id',RetornaOrcamentoItem);
  THorse.Get('/trabinapi/movimentos/orcamentos/:orcamento/itens/total',RetornaTotalItens);
  THorse.Get('/trabinapi/movimentos/orcamentos/:orcamento/itens/produto/:idproduto',RetornaIdOrcamentoItem);
  THorse.Get('/trabinapi/movimentos/orcamentos/:orcamento/itens/produto/:idproduto/tamanho/:tamanho/cor/:cor',RetornaIdOrcamentoItemGrade);

// Método Post
  THorse.Post('/trabinapi/movimentos/orcamentos/:orcamento/itens',CriaOrcamentoItem);

// Método Put
  THorse.Put('/trabinapi/movimentos/orcamentos/:orcamento/itens/:id',AlteraOrcamentoItem);


// Método Delete
  THorse.Delete('/trabinapi/movimentos/orcamentos/:orcamento/itens/:id',ExcluiOrcamentoItem);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('movimentos/orcamentos/{orcamento}/itens')
      .Tag('Orçamento Ítens')
      .GET('Listar orçamentos ítens')
        .AddParamQuery('id', 'Id').&End
        .AddParamQuery('codproduto', 'Código Produto').&End
        .AddParamQuery('descproduto', 'Descrição Produto').&End
        .AddResponse(200, 'Lista de ítens de orçamento').Schema(TOrcamentosItens).IsArray(True).&End
      .&End
      .POST('Criar um novo ítem de orçamento')
        .AddParamBody('Dados do ítem de orçamento').Required(True).Schema(TOrcamentosItensCria).&End
        .AddResponse(201).Schema(TOrcamentosItens).&End
        .AddResponse(400).&End
      .&End
    .&End
    .Path('movimentos/orcamentos/{orcamento}/itens/{id}')
      .Tag('Orçamento Ítens')
      .GET('Obter os dados de um ítem de orçamento específico')
        .AddParamPath('id', 'Id').&End
        .AddResponse(200, 'Dados da orçamento').Schema(TOrcamentosItens).&End
        .AddResponse(404).&End
      .&End
      .PUT('Alterar os dados de um orçamento ítem')
        .AddParamPath('id', 'Código').&End
        .AddParamBody('Dados do Ítem').Required(True).Schema(TOrcamentosItensCria).&End
        .AddResponse(201).Schema(TOrcamentosItens).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
      .DELETE('Excluir orçamento ítem')
        .AddParamPath('id', 'Id').&End
        .AddResponse(204).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
