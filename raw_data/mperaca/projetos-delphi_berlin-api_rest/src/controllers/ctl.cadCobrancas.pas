unit ctl.cadCobrancas;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses models.cadCobrancas, dat.cadCobrancas, prv.dataModuleConexao;


procedure ListaTodasCobrancas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
    wlista := dat.cadCobrancas.RetornaListaCobrancas(Req.Query,wlimit,woffset);
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


procedure RetornaCobranca(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wcobranca,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid       := Req.Params['id'].ToInteger; // recupera o id da cobrança
    wcobranca := TJSONObject.Create;
    wcobranca := dat.cadCobrancas.RetornaCobranca(wid);
    if wcobranca.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wcobranca).Status(400)
    else
       Res.Send<TJSONObject>(wcobranca).Status(200);
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

procedure CriaCobranca(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wCobranca,wnewCobranca,wresp,werro: TJSONObject;
    wval: string;
    widempresa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wCobranca    := TJSONObject.Create;
    wnewCobranca := TJSONObject.Create;
    wresp        := TJSONObject.Create;
    wCobranca    := Req.Body<TJSONObject>;
    wconexao     := TProviderDataModuleConexao.Create(nil);
    widempresa   := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadCobrancas.VerificaRequisicao(wCobranca) then
       begin
         wnewCobranca := dat.cadCobrancas.IncluiCobranca(wCobranca);
         if wnewCobranca.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewCobranca).Status(400)
         else
            Res.Send<TJSONObject>(wnewCobranca).Status(201);
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

procedure AlteraCobranca(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wCobranca,wnewCobranca,wresp,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wnewCobranca := TJSONObject.Create;
    wCobranca    := TJSONObject.Create;
    wresp        := TJSONObject.Create;
    wid          := Req.Params['id'].ToInteger; // recupera o id da Cobrança
    wCobranca    := Req.Body<TJSONObject>;
    wnewCobranca := dat.cadCobrancas.AlteraCobranca(wid,wCobranca);
    if wnewCobranca.TryGetValue('nome',wval) then
       begin
         wnewCobranca.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewCobranca).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Cobrança não encontrada');
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

procedure ExcluiCobranca(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid: integer;
    wret,werro: TJSONObject;
begin
  try
    wid := Req.Params['id'].ToInteger; // recupera o id da Categoria
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadCobrancas.ApagaCobranca(wid);
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

procedure RetornaTotalCobrancas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wtotal,werro: TJSONObject;
    wval: string;
begin
  try
    wtotal := TJSONObject.Create;
    wtotal := dat.cadCobrancas.RetornaTotalCobrancas(Req.Query);
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
  THorse.Get('/trabinapi/cadastros/cobrancas',ListaTodasCobrancas);
  THorse.Get('/trabinapi/cadastros/cobrancas/:id',RetornaCobranca);
  THorse.Get('/trabinapi/cadastros/cobrancas/total',RetornaTotalCobrancas);

// Método Post
  THorse.Post('/trabinapi/cadastros/cobrancas',CriaCobranca);

  // Método Put
  THorse.Put('/trabinapi/cadastros/cobrancas/:id',AlteraCobranca);

  // Método Delete
  THorse.Delete('/trabinapi/cadastros/cobrancas/:id',ExcluiCobranca);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('cadastros/cobrancas')
      .Tag('Documentos de Cobranças')
      .GET('Listar cobranças')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('nome', 'Nome').&End
        .AddParamQuery('tipo', 'Tipo').&End
        .AddResponse(200, 'Lista de cobrancas').Schema(TCobrancas).IsArray(True).&End
      .&End
    .&End
    .Path('cadastros/cobrancas/{id}')
      .Tag('Documento de Cobrança')
      .GET('Obter os dados de uma cobrança específica')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('nome', 'Nome').&End
        .AddParamQuery('tipo', 'Tipo').&End
        .AddResponse(200, 'Dados da cobrnaça').Schema(TCobrancas).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
