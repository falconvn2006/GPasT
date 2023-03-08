unit ctl.cadCondicoes;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation


uses dat.cadCondicoes, models.cadCondicoes, prv.dataModuleConexao;

procedure ListaTodasCondicoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
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
    wlista := TJSONArray.Create;
    wlista := dat.cadCondicoes.RetornaListaCondicoes(Req.Query,wlimit,woffset);
    wret   := wlista.Get(0) as TJSONObject;
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


procedure RetornaCondicao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wcondicao,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid       := Req.Params['id'].ToInteger; // recupera o id do cliente
    wcondicao := TJSONObject.Create;
    wcondicao := dat.cadCondicoes.RetornaCondicao(wid);
    if wcondicao.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wcondicao).Status(400)
    else
       Res.Send<TJSONObject>(wcondicao).Status(200);
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

procedure CriaCondicao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wCondicao,wnewCondicao,wresp,werro: TJSONObject;
    wval: string;
    widempresa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wCondicao    := TJSONObject.Create;
    wnewCondicao := TJSONObject.Create;
    wresp        := TJSONObject.Create;
    wCondicao    := Req.Body<TJSONObject>;
    wconexao     := TProviderDataModuleConexao.Create(nil);
    widempresa   := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadCondicoes.VerificaRequisicao(wCondicao) then
       begin
         wnewCondicao := dat.cadCondicoes.IncluiCondicao(wCondicao);
         if wnewCondicao.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewCondicao).Status(400)
         else
            Res.Send<TJSONObject>(wnewCondicao).Status(201);
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

procedure AlteraCondicao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wCondicao,wnewCondicao,wresp,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wnewCondicao := TJSONObject.Create;
    wCondicao    := TJSONObject.Create;
    wresp        := TJSONObject.Create;
    wid          := Req.Params['id'].ToInteger; // recupera o id da Condição
    wCondicao    := Req.Body<TJSONObject>;
    wnewCondicao := dat.cadCondicoes.AlteraCondicao(wid,wCondicao);
    if wnewCondicao.TryGetValue('descricao',wval) then
       begin
         wnewCondicao.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewCondicao).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Condição não encontrada');
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

procedure ExcluiCondicao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid: integer;
    wret,werro: TJSONObject;
begin
  try
    wid := Req.Params['id'].ToInteger; // recupera o id da Condição
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadCondicoes.ApagaCondicao(wid);
         if wret.GetValue('status').Value='200' then
            Res.Send<TJSONObject>(wret).Status(200)
         else
            Res.Send<TJSONObject>(wret).Status(400);
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

procedure RetornaTotalCondicoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wtotal,werro: TJSONObject;
    wval: string;
begin
  try
    wtotal := TJSONObject.Create;
    wtotal := dat.cadCondicoes.RetornaTotalCondicoes(Req.Query);
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
  THorse.Get('/trabinapi/cadastros/condicoes',ListaTodasCondicoes);
  THorse.Get('/trabinapi/cadastros/condicoes/:id',RetornaCondicao);
  THorse.Get('/trabinapi/cadastros/condicoes/total',RetornaTotalCondicoes);

// Método Post
  THorse.Post('/trabinapi/cadastros/condicoes',CriaCondicao);

  // Método Put
  THorse.Put('/trabinapi/cadastros/condicoes/:id',AlteraCondicao);

  // Método Delete
  THorse.Delete('/trabinapi/cadastros/condicoes/:id',ExcluiCondicao);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('cadastros/condicoes')
      .Tag('Condições de Pagamento')
      .GET('Listar condições')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('tipo', 'Tipo').&End
        .AddParamQuery('numpag', 'Número Pagamentos').&End
        .AddResponse(200, 'Lista de condições').Schema(TCondicoes).IsArray(True).&End
      .&End
    .&End
    .Path('cadastros/condicoes/{id}')
      .Tag('Condições de Pagamento')
      .GET('Obter os dados de uma condição específica')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('tipo', 'Tipo').&End
        .AddParamQuery('numpag', 'Número Pagamentos').&End
        .AddResponse(200, 'Dados da condicção').Schema(TCondicoes).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
