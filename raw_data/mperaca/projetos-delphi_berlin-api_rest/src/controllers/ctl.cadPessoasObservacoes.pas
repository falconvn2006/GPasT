unit ctl.cadPessoasObservacoes;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.dataModuleConexao, dat.cadPessoasObservacoes;


procedure ListaTodasObservacoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
    widempresa,widpessoa: integer;
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
    widpessoa     := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    wconexao      := TProviderDataModuleConexao.Create(nil);
    widempresa    := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini
    wlista := TJSONArray.Create;
    wlista := dat.cadPessoasObservacoes.RetornaListaObservacoes(Req.Query,widpessoa,wlimit,woffset);
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

procedure CriaObservacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wObservacao,wnewObservacao,wresp,werro: TJSONObject;
    wval: string;
    widempresa,widpessoa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    widpessoa      := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    wObservacao    := TJSONObject.Create;
    wnewObservacao := TJSONObject.Create;
    wresp          := TJSONObject.Create;
    wObservacao    := Req.Body<TJSONObject>;
    wconexao       := TProviderDataModuleConexao.Create(nil);
    widempresa     := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadPessoasObservacoes.VerificaRequisicao(wObservacao) then
       begin
         wnewObservacao := dat.cadPessoasObservacoes.IncluiObservacao(wObservacao,widpessoa);
         if wnewObservacao.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewObservacao).Status(400)
         else
            Res.Send<TJSONObject>(wnewObservacao).Status(201);
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

procedure AlteraObservacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wObservacao,wnewObservacao,wresp,werro: TJSONObject;
    wid,widpessoa: integer;
    wval: string;
begin
  try
    wnewObservacao := TJSONObject.Create;
    wObservacao    := TJSONObject.Create;
    wresp          := TJSONObject.Create;
    widpessoa      := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    wid            := Req.Params['id'].ToInteger; // recupera o id da Observação
    wObservacao    := Req.Body<TJSONObject>;
    wnewObservacao := dat.cadPessoasObservacoes.AlteraObservacao(wid,wObservacao);
    if wnewObservacao.TryGetValue('data',wval) then
       begin
         wnewObservacao.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewObservacao).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Observação não encontrada');
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

procedure ExcluiObservacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid,widpessoa: integer;
    wret,werro: TJSONObject;
begin
  try
    wid       := Req.Params['id'].ToInteger; // recupera o id da Observação
    widpessoa := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadPessoasObservacoes.ApagaObservacao(wid);
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

procedure RetornaObservacao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wObservacao,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid         := Req.Params['id'].ToInteger; // recupera o id da Observacao
    wObservacao := TJSONObject.Create;
    wObservacao := Req.Body<TJSONObject>;
    wObservacao := dat.cadPessoasObservacoes.RetornaObservacao(wid);
    if wObservacao.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wObservacao).Status(400)
    else
       Res.Send<TJSONObject>(wObservacao).Status(200);
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

procedure RetornaTotalObservacoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wtotal,werro: TJSONObject;
    wval: string;
    widpessoa: integer;
begin
  try
    widpessoa     := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    wtotal := TJSONObject.Create;
    wtotal := dat.cadPessoasObservacoes.RetornaTotalObservacoes(Req.Query,widpessoa);
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
  THorse.Get('/trabinapi/cadastros/pessoas/:idpessoa/observacoes',ListaTodasObservacoes);
  THorse.Get('/trabinapi/cadastros/pessoas/:idpessoa/observacoes/:id',RetornaObservacao);
  THorse.Get('/trabinapi/cadastros/pessoas/:idpessoa/observacoes/total',RetornaTotalObservacoes);

// Método Post
  THorse.Post('/trabinapi/cadastros/pessoas/:idpessoa/observacoes',CriaObservacao);

  // Método Put
  THorse.Put('/trabinapi/cadastros/pessoas/:idpessoa/observacoes/:id',AlteraObservacao);

// Método Delete
  THorse.Delete('/trabinapi/cadastros/pessoas/:idpessoa/observacoes/:id',ExcluiObservacao);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('cadastros/categorias')
      .Tag('AliquotasICM')
      .GET('Listar Categorias')
//        .AddResponse(200, 'Lista de Alíquotas').Schema(TAliquotas).IsArray(True).&End
      .&End
      .POST('Criar uma nova Categoria')
//        .AddParamBody('Dados da Alíquota').Required(True).Schema(TAliquotas).&End
        .AddParamQuery('codigo', 'Código').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('percentual', 'Percentual').&End
        .AddParamQuery('percentualsc', 'Percentual SC').&End
        .AddParamQuery('percentualsp', 'Percentual SP').&End
        .AddParamQuery('basecalculo', 'Base de Cálculo').&End
        .AddParamQuery('somaoutros', 'Soma Outros').&End
        .AddParamQuery('somaisentos', 'Soma Isentos').&End
//        .AddResponse(201).Schema(TAliquotas).&End
        .AddResponse(400).&End
      .&End
    .&End
    .Path('cadastros/categorias/{id}')
      .Tag('Categorias')
      .GET('Obter os dados de uma Categoria específica')
        .AddParamPath('id', 'Id').&End
//        .AddResponse(200, 'Dados da Alíquota').Schema(TAliquotas).&End
        .AddResponse(404).&End
      .&End
      .PUT('Alterar os dados de uma Categoria específica')
        .AddParamPath('id', 'Id').&End
        .AddParamQuery('codigo', 'Código').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('percentual', 'Percentual').&End
        .AddParamQuery('percentualsc', 'Percentual SC').&End
        .AddParamQuery('percentualsp', 'Percentual SP').&End
        .AddParamQuery('basecalculo', 'Base de Cálculo').&End
        .AddParamQuery('somaoutros', 'Soma Outros').&End
        .AddParamQuery('somaisentos', 'Soma Isentos').&End
//        .AddParamBody('Dados da Alíquota').Required(True).Schema(TAliquotas).&End
        .AddResponse(200).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
      .DELETE('Excluir Categoria')
        .AddParamPath('id', 'Id').&End
        .AddResponse(204).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
