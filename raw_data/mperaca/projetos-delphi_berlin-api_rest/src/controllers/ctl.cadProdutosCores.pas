unit ctl.cadProdutosCores;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.dataModuleConexao, dat.cadProdutosCores;


procedure ListaTodasCores(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
    wlista := dat.cadProdutosCores.RetornaListaCores(Req.Query,widproduto);
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

procedure CriaCor(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wCor,wnewCor,wresp,werro: TJSONObject;
    wval: string;
    widempresa,widproduto: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    widproduto := Req.Params['idproduto'].ToInteger; // recupera o id da Pessoa
    wCor       := TJSONObject.Create;
    wnewCor    := TJSONObject.Create;
    wresp      := TJSONObject.Create;
    wCor       := Req.Body<TJSONObject>;
    wconexao   := TProviderDataModuleConexao.Create(nil);
    widempresa := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadProdutosCores.VerificaRequisicao(wCor) then
       begin
         wnewCor := dat.cadProdutosCores.IncluiCor(wCor,widproduto);
         if wnewCor.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewCor).Status(400)
         else
            Res.Send<TJSONObject>(wnewCor).Status(201);
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

procedure AlteraCor(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wCor,wnewCor,wresp,werro: TJSONObject;
    wid,widproduto: integer;
    wval: string;
begin
  try
    wnewCor    := TJSONObject.Create;
    wCor       := TJSONObject.Create;
    wresp      := TJSONObject.Create;
    widproduto := Req.Params['idproduto'].ToInteger; // recupera o id da Pessoa
    wid        := Req.Params['id'].ToInteger; // recupera o id do Contato
    wCor       := Req.Body<TJSONObject>;
    wnewCor    := dat.cadProdutosCores.AlteraCor(wid,wCor);
    if wnewCor.TryGetValue('idcor',wval) then
       begin
         wnewCor.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewCor).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Produto Cor não encontrado');
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

procedure ExcluiCor(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid,widproduto: integer;
    wret,werro: TJSONObject;
begin
  try
    wid        := Req.Params['id'].ToInteger; // recupera o id do Contato
    widproduto := Req.Params['idproduto'].ToInteger; // recupera o id da Pessoa
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadProdutosCores.ApagaCor(wid);
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

procedure RetornaCor(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wCor,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid   := Req.Params['id'].ToInteger; // recupera o id do Contato
    wCor  := TJSONObject.Create;
    wCor  := Req.Body<TJSONObject>;
    wCor  := dat.cadProdutosCores.RetornaCor(wid);
    if wCor.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wCor).Status(400)
    else
       Res.Send<TJSONObject>(wCor).Status(200);
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
  THorse.Get('/trabinapi/cadastros/produtos/:idproduto/cores',ListaTodasCores);
  THorse.Get('/trabinapi/cadastros/produtos/:idproduto/cores/:id',RetornaCor);

// Método Post
  THorse.Post('/trabinapi/cadastros/produtos/:idproduto/cores',CriaCor);

// Método Put
  THorse.Put('/trabinapi/cadastros/produtos/:idproduto/cores/:id',AlteraCor);

// Método Delete
  THorse.Delete('/trabinapi/cadastros/produtos/:idproduto/cores/:id',ExcluiCor);
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
