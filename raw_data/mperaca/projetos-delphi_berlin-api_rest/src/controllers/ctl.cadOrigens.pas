unit ctl.cadOrigens;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.dataModuleConexao, dat.cadOrigens;


procedure ListaTodasOrigens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
    wlista := dat.cadOrigens.RetornaListaOrigens(Req.Query);
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

procedure CriaOrigem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wOrigem,wnewOrigem,wresp,werro: TJSONObject;
    wval: string;
    widempresa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wOrigem      := TJSONObject.Create;
    wnewOrigem   := TJSONObject.Create;
    wresp        := TJSONObject.Create;
    wOrigem      := Req.Body<TJSONObject>;
    wconexao     := TProviderDataModuleConexao.Create(nil);
    widempresa   := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadOrigens.VerificaRequisicao(wOrigem) then
       begin
         wnewOrigem := dat.cadOrigens.IncluiOrigem(wOrigem,widempresa);
         if wnewOrigem.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewOrigem).Status(400)
         else
            Res.Send<TJSONObject>(wnewOrigem).Status(201);
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

procedure AlteraOrigem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wOrigem,wnewOrigem,wresp,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wnewOrigem := TJSONObject.Create;
    wOrigem    := TJSONObject.Create;
    wresp      := TJSONObject.Create;
    wid        := Req.Params['id'].ToInteger; // recupera o id da Origem
    wOrigem    := Req.Body<TJSONObject>;
    wnewOrigem := dat.cadOrigens.AlteraOrigem(wid,wOrigem);
    if wnewOrigem.TryGetValue('id',wval) then
       begin
         wnewOrigem.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewOrigem).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Origem não encontrada');
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

procedure ExcluiOrigem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid: integer;
    wret,werro: TJSONObject;
begin
  try
    wid := Req.Params['id'].ToInteger; // recupera o id da Origem
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadOrigens.ApagaOrigem(wid);
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

procedure RetornaOrigem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wOrigem,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid       := Req.Params['id'].ToInteger; // recupera o id da Origem
    wOrigem := TJSONObject.Create;
    wOrigem := Req.Body<TJSONObject>;
    wOrigem := dat.cadOrigens.RetornaOrigem(wid);
    if wOrigem.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wOrigem).Status(400)
    else
       Res.Send<TJSONObject>(wOrigem).Status(200);
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
  THorse.Get('/trabinapi/cadastros/origens',ListaTodasOrigens);
  THorse.Get('/trabinapi/cadastros/origens/:id',RetornaOrigem);

// Método Post
  THorse.Post('/trabinapi/cadastros/origens',CriaOrigem);

  // Método Put
  THorse.Put('/trabinapi/cadastros/origens/:id',AlteraOrigem);

// Método Delete
  THorse.Delete('/trabinapi/cadastros/origens/:id',ExcluiOrigem);
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
