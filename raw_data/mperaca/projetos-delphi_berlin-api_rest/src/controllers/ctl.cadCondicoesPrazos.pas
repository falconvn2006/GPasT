unit ctl.cadCondicoesPrazos;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation


uses prv.dataModuleConexao, dat.cadCondicoesPrazos;

procedure ListaTodasCondicoesPrazos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
    widcondicao: integer;
begin
  try
    widcondicao := Req.Params['idcondicao'].ToInteger; // recupera o id da condicao
    wlista := TJSONArray.Create;
    wlista := dat.cadCondicoesPrazos.RetornaListaCondicoesPrazos(Req.Query,widcondicao);
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


procedure RetornaCondicaoPrazo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wcondicaoprazo,werro: TJSONObject;
    wid,widcondicao: integer;
    wval: string;
begin
  try
    wid            := Req.Params['id'].ToInteger; // recupera o id da condicao prazo
    widcondicao    := Req.Params['idcondicao'].ToInteger; // recupera o id da condicao
    wcondicaoprazo := TJSONObject.Create;
    wcondicaoprazo := dat.cadCondicoesPrazos.RetornaCondicaoPrazo(wid);
    if wcondicaoprazo.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wcondicaoprazo).Status(400)
    else
       Res.Send<TJSONObject>(wcondicaoprazo).Status(200);
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

procedure CriaCondicaoPrazo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wCondicaoPrazo,wnewCondicaoPrazo,wresp,werro: TJSONObject;
    wval: string;
    widempresa: integer;
    wconexao: TProviderDataModuleConexao;
    widcondicao: integer;
begin
  try
    widcondicao       := Req.Params['idcondicao'].ToInteger; // recupera o id da condicao
    wCondicaoPrazo    := TJSONObject.Create;
    wnewCondicaoPrazo := TJSONObject.Create;
    wresp             := TJSONObject.Create;
    wCondicaoPrazo    := Req.Body<TJSONObject>;
    wconexao          := TProviderDataModuleConexao.Create(nil);
    widempresa        := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadCondicoesPrazos.VerificaRequisicao(wCondicaoPrazo) then
       begin
         wnewCondicaoPrazo := dat.cadCondicoesPrazos.IncluiCondicaoPrazo(wCondicaoPrazo,widcondicao);
         if wnewCondicaoPrazo.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewCondicaoPrazo).Status(400)
         else
            Res.Send<TJSONObject>(wnewCondicaoPrazo).Status(201);
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

procedure AlteraCondicaoPrazo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wCondicaoPrazo,wnewCondicaoPrazo,wresp,werro: TJSONObject;
    wid,widcondicao: integer;
    wval: string;
begin
  try
    wnewCondicaoPrazo := TJSONObject.Create;
    wCondicaoPrazo    := TJSONObject.Create;
    wresp             := TJSONObject.Create;
    wid               := Req.Params['id'].ToInteger; // recupera o id da Condição Prazo
    widcondicao       := Req.Params['idcondicao'].ToInteger; // recupera o id da Condição
    wCondicaoPrazo    := Req.Body<TJSONObject>;
    wnewCondicaoPrazo := dat.cadCondicoesPrazos.AlteraCondicaoPrazo(wid,wCondicaoPrazo);
    if wnewCondicaoPrazo.TryGetValue('idcondicao',wval) then
       begin
         wnewCondicaoPrazo.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewCondicaoPrazo).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Prazo não encontrado');
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

procedure ExcluiCondicaoPrazo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid,widcondicao: integer;
    wret,werro: TJSONObject;
begin
  try
    wid         := Req.Params['id'].ToInteger; // recupera o id da Condição Prazo
    widcondicao := Req.Params['idcondicao'].ToInteger; // recupera o id da Condição
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadCondicoesPrazos.ApagaCondicaoPrazo(wid);
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


procedure Registry;
begin
// Método Get
  THorse.Get('/trabinapi/cadastros/condicoes/:idcondicao/prazos',ListaTodasCondicoesPrazos);
  THorse.Get('/trabinapi/cadastros/condicoes/:idcondicao/prazos/:id',RetornaCondicaoPrazo);

// Método Post
  THorse.Post('/trabinapi/cadastros/condicoes/:idcondicao/prazos',CriaCondicaoPrazo);

  // Método Put
  THorse.Put('/trabinapi/cadastros/condicoes/:idcondicao/prazos/:id',AlteraCondicaoPrazo);

  // Método Delete
  THorse.Delete('/trabinapi/cadastros/condicoes/:idcondicao/prazos/:id',ExcluiCondicaoPrazo);
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
//        .AddResponse(200, 'Lista de condições').Schema(TCondicoes).IsArray(True).&End
      .&End
    .&End
    .Path('cadastros/condicoes/{id}')
      .Tag('Condições de Pagamento')
      .GET('Obter os dados de uma condição específica')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('tipo', 'Tipo').&End
        .AddParamQuery('numpag', 'Número Pagamentos').&End
//        .AddResponse(200, 'Dados da condicção').Schema(TCondicoes).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
