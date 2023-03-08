unit ctl.cadProdutos;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses models.cadProdutos, dat.cadProdutos, prv.dataModuleConexao;

procedure ListaTodosProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
    wpagina: integer;
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
    if Req.Query.ContainsKey('pagina') then // número da pagina
       wpagina := Req.Query.Items['pagina'].ToInteger
    else
       wpagina := -1;
    wlista := TJSONArray.Create;
    wlista := dat.cadProdutos.RetornaListaProdutos(Req.Query,wpagina,wlimit,woffset);
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


procedure RetornaProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wproduto,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid      := Req.Params['id'].ToInteger; // recupera o id do produto
    wproduto := TJSONObject.Create;
    wproduto := dat.cadProdutos.RetornaProduto(wid);
    if wproduto.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wproduto).Status(400)
    else
       Res.Send<TJSONObject>(wproduto).Status(200);
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

procedure CriaProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wProduto,wnewProduto,wresp,werro: TJSONObject;
    wval: string;
    widempresa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wProduto     := TJSONObject.Create;
    wnewProduto  := TJSONObject.Create;
    wresp        := TJSONObject.Create;
    wProduto     := Req.Body<TJSONObject>;
    wconexao     := TProviderDataModuleConexao.Create(nil);
    widempresa   := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadProdutos.VerificaRequisicao(wProduto) then
       begin
         wnewProduto := dat.cadProdutos.IncluiProduto(wProduto);
         if wnewProduto.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewProduto).Status(400)
         else
            Res.Send<TJSONObject>(wnewProduto).Status(201);
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

procedure AlteraProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wProduto,wnewProduto,wresp,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wnewProduto  := TJSONObject.Create;
    wProduto     := TJSONObject.Create;
    wresp        := TJSONObject.Create;
    wid          := Req.Params['id'].ToInteger; // recupera o id do Produto
    wProduto     := Req.Body<TJSONObject>;
    wnewProduto  := dat.cadProdutos.AlteraProduto(wid,wProduto);
    if wnewProduto.TryGetValue('codigo',wval) then
       begin
         wnewProduto.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewProduto).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Produto não encontrada');
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

procedure ExcluiProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid: integer;
    wret,werro: TJSONObject;
begin
  try
    wid := Req.Params['id'].ToInteger; // recupera o id do Produto
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadProdutos.ApagaProduto(wid);
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

procedure RetornaTotalProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wtotal,werro: TJSONObject;
    wval: string;
begin
  try
    wtotal := TJSONObject.Create;
    wtotal := dat.cadProdutos.RetornaTotalProdutos(Req.Query);
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
  THorse.Get('/trabinapi/cadastros/produtos',ListaTodosProdutos);
  THorse.Get('/trabinapi/cadastros/produtos/:id',RetornaProduto);
  THorse.Get('/trabinapi/cadastros/produtos/total',RetornaTotalProdutos);

// Método Post
  THorse.Post('/trabinapi/cadastros/produtos',CriaProduto);

  // Método Put
  THorse.Put('/trabinapi/cadastros/produtos/:id',AlteraProduto);

  // Método Delete
  THorse.Delete('/trabinapi/cadastros/produtos/:id',ExcluiProduto);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('cadastros/produtos')
      .Tag('Produtos')
      .GET('Listar produtos')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('codigo', 'Código').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('unidade', 'Unidade').&End
        .AddParamQuery('cean', 'Código de Barras').&End
        .AddParamQuery('marca', 'Marca').&End
        .AddParamQuery('fabricante', 'Fabricante').&End
        .AddParamQuery('preco', 'Preço de Venda').&End
        .AddResponse(200, 'Lista de produtos').Schema(TProdutos).IsArray(True).&End
      .&End
    .&End
    .Path('cadastros/produtos/{id}')
      .Tag('Produtos')
      .GET('Obter os dados de um produto específico')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('codigo', 'Código').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('unidade', 'Unidade').&End
        .AddParamQuery('cean', 'Código de Barras').&End
        .AddParamQuery('marca', 'Marca').&End
        .AddParamQuery('fabricante', 'Fabricante').&End
        .AddParamQuery('preco', 'Preço de Venda').&End
        .AddResponse(200, 'Dados do cliente').Schema(TProdutos).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
