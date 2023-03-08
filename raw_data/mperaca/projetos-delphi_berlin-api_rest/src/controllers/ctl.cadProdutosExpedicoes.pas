unit ctl.cadProdutosExpedicoes;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.dataModuleConexao, dat.cadProdutosExpedicoes;


procedure ListaTodasExpedicoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
    widempresa,widproduto: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    widproduto    := Req.Params['idproduto'].ToInteger; // recupera o id da Pessoa
    wconexao      := TProviderDataModuleConexao.Create(nil);
    widempresa    := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini
    wlista := TJSONArray.Create;
    wlista := dat.cadProdutosExpedicoes.RetornaListaExpedicoes(Req.Query,widproduto);
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

procedure CriaExpedicao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wExpedicao,wnewExpedicao,wresp,werro: TJSONObject;
    wval: string;
    widempresa,widproduto: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    widproduto       := Req.Params['idproduto'].ToInteger; // recupera o id da Pessoa
    wExpedicao       := TJSONObject.Create;
    wnewExpedicao    := TJSONObject.Create;
    wresp            := TJSONObject.Create;
    wExpedicao       := Req.Body<TJSONObject>;
    wconexao         := TProviderDataModuleConexao.Create(nil);
    widempresa       := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadProdutosExpedicoes.VerificaRequisicao(wExpedicao) then
       begin
         wnewExpedicao := dat.cadProdutosExpedicoes.IncluiExpedicao(wExpedicao,widproduto);
         if wnewExpedicao.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewExpedicao).Status(400)
         else
            Res.Send<TJSONObject>(wnewExpedicao).Status(201);
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

procedure AlteraExpedicao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wExpedicao,wnewExpedicao,wresp,werro: TJSONObject;
    wid,widproduto: integer;
    wval: string;
begin
  try
    wnewExpedicao    := TJSONObject.Create;
    wExpedicao       := TJSONObject.Create;
    wresp            := TJSONObject.Create;
    widproduto       := Req.Params['idproduto'].ToInteger; // recupera o id da Pessoa
    wid              := Req.Params['id'].ToInteger; // recupera o id do Contato
    wExpedicao       := Req.Body<TJSONObject>;
    wnewExpedicao    := dat.cadProdutosExpedicoes.AlteraExpedicao(wid,wExpedicao);
    if wnewExpedicao.TryGetValue('idproduto',wval) then
       begin
         wnewExpedicao.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewExpedicao).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Produto Expedição não encontrado');
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

procedure ExcluiExpedicao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid,widproduto: integer;
    wret,werro: TJSONObject;
begin
  try
    wid        := Req.Params['id'].ToInteger; // recupera o id do Contato
    widproduto := Req.Params['idproduto'].ToInteger; // recupera o id da Pessoa
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadProdutosExpedicoes.ApagaExpedicao(wid);
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

procedure RetornaExpedicao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wExpedicao,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid        := Req.Params['id'].ToInteger; // recupera o id do Contato
    wExpedicao  := TJSONObject.Create;
    wExpedicao  := Req.Body<TJSONObject>;
    wExpedicao  := dat.cadProdutosExpedicoes.RetornaExpedicao(wid);
    if wExpedicao.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wExpedicao).Status(400)
    else
       Res.Send<TJSONObject>(wExpedicao).Status(200);
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
  THorse.Get('/trabinapi/cadastros/produtos/:idproduto/expedicoes',ListaTodasExpedicoes);
  THorse.Get('/trabinapi/cadastros/produtos/:idproduto/expedicoes/:id',RetornaExpedicao);

// Método Post
  THorse.Post('/trabinapi/cadastros/produtos/:idproduto/expedicoes',CriaExpedicao);

// Método Put
  THorse.Put('/trabinapi/cadastros/produtos/:idproduto/expedicoes/:id',AlteraExpedicao);

// Método Delete
  THorse.Delete('/trabinapi/cadastros/produtos/:idproduto/expedicoes/:id',ExcluiExpedicao);
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
