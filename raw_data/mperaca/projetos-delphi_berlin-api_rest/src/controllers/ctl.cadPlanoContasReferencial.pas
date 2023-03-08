unit ctl.cadPlanoContasReferencial;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.dataModuleConexao, dat.cadPlanoContasReferencial;


procedure ListaTodosPlanosReferenciais(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
    wlista := dat.cadPlanoContasReferencial.RetornaListaPlanosReferenciais(Req.Query);
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

procedure CriaPlanoReferencial(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wPlano,wnewPlano,wresp,werro: TJSONObject;
    wval: string;
    widempresa,widpessoa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wPlano      := TJSONObject.Create;
    wnewPlano   := TJSONObject.Create;
    wresp       := TJSONObject.Create;
    wPlano      := Req.Body<TJSONObject>;
    wconexao    := TProviderDataModuleConexao.Create(nil);
    widempresa  := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadPlanoContasReferencial.VerificaRequisicao(wPlano) then
       begin
         wnewPlano := dat.cadPlanoContasReferencial.IncluiPlanoReferencial(wPlano);
         if wnewPlano.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewPlano).Status(400)
         else
            Res.Send<TJSONObject>(wnewPlano).Status(201);
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

procedure AlteraPlanoReferencial(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wPlano,wnewPlano,wresp,werro: TJSONObject;
    wid,widpessoa: integer;
    wval: string;
begin
  try
    wnewPlano   := TJSONObject.Create;
    wPlano      := TJSONObject.Create;
    wresp       := TJSONObject.Create;
    wid         := Req.Params['id'].ToInteger; // recupera o id do Contato
    wPlano      := Req.Body<TJSONObject>;
    wnewPlano   := dat.cadPlanoContasReferencial.AlteraPlanoReferencial(wid,wPlano);
    if wnewPlano.TryGetValue('estrutural',wval) then
       begin
         wnewPlano.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewPlano).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Plano de Conta Referencial não encontrado');
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

procedure ExcluiPlanoReferencial(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid: integer;
    wret,werro: TJSONObject;
begin
  try
    wid       := Req.Params['id'].ToInteger; // recupera o id do Contato
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadPlanoContasReferencial.ApagaPlanoReferencial(wid);
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

procedure RetornaPlanoReferencial(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wPlano,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid      := Req.Params['id'].ToInteger; // recupera o id do Contato
    wPlano := TJSONObject.Create;
    wPlano := Req.Body<TJSONObject>;
    wPlano := dat.cadPlanoContasReferencial.RetornaPlanoReferencial(wid);
    if wPlano.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wPlano).Status(400)
    else
       Res.Send<TJSONObject>(wPlano).Status(200);
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
  THorse.Get('/trabinapi/cadastros/planocontasreferencial',ListaTodosPlanosReferenciais);
  THorse.Get('/trabinapi/cadastros/planocontasreferencial/:id',RetornaPlanoReferencial);

// Método Post
  THorse.Post('/trabinapi/cadastros/planocontasreferencial',CriaPlanoReferencial);

  // Método Put
  THorse.Put('/trabinapi/cadastros/planocontasreferencial/:id',AlteraPlanoReferencial);

// Método Delete
  THorse.Delete('/trabinapi/cadastros/planocontasreferencial/:id',ExcluiPlanoReferencial);
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
