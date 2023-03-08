unit ctl.cadClassificacoesFiscais;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.dataModuleConexao, dat.cadClassificacoesFiscais;


procedure ListaTodasClassificacoesFiscais(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
    widempresa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wconexao      := TProviderDataModuleConexao.Create(nil);
    widempresa    := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini
    wlista := TJSONArray.Create;
    wlista := dat.cadClassificacoesFiscais.RetornaListaClassificacoesFiscais(Req.Query,widempresa);
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

procedure CriaClassificacaoFiscal(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wClassificacao,wnewClassificacao,wresp,werro: TJSONObject;
    wval: string;
    widempresa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wClassificacao    := TJSONObject.Create;
    wnewClassificacao := TJSONObject.Create;
    wresp             := TJSONObject.Create;
    wClassificacao    := Req.Body<TJSONObject>;
    wconexao          := TProviderDataModuleConexao.Create(nil);
    widempresa        := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadClassificacoesFiscais.VerificaRequisicao(wClassificacao) then
       begin
         wnewClassificacao := dat.cadClassificacoesFiscais.IncluiClassificacaoFiscal(wClassificacao);
         if wnewClassificacao.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewClassificacao).Status(400)
         else
            Res.Send<TJSONObject>(wnewClassificacao).Status(201);
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

procedure ExcluiClassificacaoFiscal(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid: integer;
    wret,werro: TJSONObject;
begin
  try
    wid := Req.Params['id'].ToInteger; // recupera o id da Classificação
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadClassificacoesFiscais.ApagaClassificacaoFiscal(wid);
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

procedure RetornaClassificacaoFiscal(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wClassificacao,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid            := Req.Params['id'].ToInteger; // recupera o id da Classificação
    wClassificacao := TJSONObject.Create;
    wClassificacao := Req.Body<TJSONObject>;
    wClassificacao := dat.cadClassificacoesFiscais.RetornaClassificacaoFiscal(wid);
    if wClassificacao.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wClassificacao).Status(400)
    else
       Res.Send<TJSONObject>(wClassificacao).Status(200);
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

procedure AlteraClassificacaoFiscal(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wClassificacao,wnewClassificacao,wresp,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wnewClassificacao := TJSONObject.Create;
    wClassificacao    := TJSONObject.Create;
    wresp             := TJSONObject.Create;
    wid               := Req.Params['id'].ToInteger; // recupera o id da Classificação
    wClassificacao    := Req.Body<TJSONObject>;
    wnewClassificacao := dat.cadClassificacoesFiscais.AlteraClassificacaoFiscal(wid,wClassificacao);
    if wnewClassificacao.TryGetValue('descricao',wval) then
       begin
         wnewClassificacao.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewClassificacao).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Classificação Fiscal não encontrada');
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

procedure Registry;
begin
// Método Get
  THorse.Get('/trabinapi/cadastros/classificacoesfiscais',ListaTodasClassificacoesFiscais);
  THorse.Get('/trabinapi/cadastros/classificacoesfiscais/:id',RetornaClassificacaoFiscal);

// Método Post
  THorse.Post('/trabinapi/cadastros/classificacoesfiscais',CriaClassificacaoFiscal);

  // Método Put
  THorse.Put('/trabinapi/cadastros/classificacoesfiscais/:id',AlteraClassificacaoFiscal);

  // Método Delete
  THorse.Delete('/trabinapi/cadastros/classificacoesfiscais/:id',ExcluiClassificacaoFiscal);
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
