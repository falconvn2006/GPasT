unit ctl.cadPessoasGrupos;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.dataModuleConexao, dat.cadPessoasGrupos;


procedure ListaTodosGrupos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
    widempresa,widpessoa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    widpessoa     := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    wconexao      := TProviderDataModuleConexao.Create(nil);
    widempresa    := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini
    wlista := TJSONArray.Create;
    wlista := dat.cadPessoasGrupos.RetornaListaGrupos(Req.Query,widpessoa);
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

procedure CriaGrupo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wGrupo,wnewGrupo,wresp,werro: TJSONObject;
    wval: string;
    widempresa,widpessoa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    widpessoa     := Req.Params['idpessoa'].ToInteger; // recupera o id da Fidelidade
    wGrupo        := TJSONObject.Create;
    wnewGrupo     := TJSONObject.Create;
    wresp         := TJSONObject.Create;
    wGrupo        := Req.Body<TJSONObject>;
    wconexao      := TProviderDataModuleConexao.Create(nil);
    widempresa    := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadPessoasGrupos.VerificaRequisicao(wGrupo) then
       begin
         wnewGrupo := dat.cadPessoasGrupos.IncluiGrupo(wGrupo,widpessoa);
         if wnewGrupo.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewGrupo).Status(400)
         else
            Res.Send<TJSONObject>(wnewGrupo).Status(201);
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

procedure AlteraGrupo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wGrupo,wnewGrupo,wresp,werro: TJSONObject;
    wid,widpessoa: integer;
    wval: string;
begin
  try
    wnewGrupo  := TJSONObject.Create;
    wGrupo     := TJSONObject.Create;
    wresp      := TJSONObject.Create;
    widpessoa  := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    wid        := Req.Params['id'].ToInteger; // recupera o id da Devolução
    wGrupo     := Req.Body<TJSONObject>;
    wnewGrupo  := dat.cadPessoasGrupos.AlteraGrupo(wid,wGrupo);
    if wnewGrupo.TryGetValue('idgrupo',wval) then
       begin
         wnewGrupo.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewGrupo).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Grupo não encontrado');
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

procedure ExcluiGrupo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid,widpessoa: integer;
    wret,werro: TJSONObject;
begin
  try
    wid       := Req.Params['id'].ToInteger; // recupera o id do Dependente
    widpessoa := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadPessoasGrupos.ApagaGrupo(wid);
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

procedure RetornaGrupo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wGrupo,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid      := Req.Params['id'].ToInteger; // recupera o id da Fidelidade
    wGrupo   := TJSONObject.Create;
    wGrupo   := Req.Body<TJSONObject>;
    wGrupo   := dat.cadPessoasGrupos.RetornaGrupo(wid);
    if wGrupo.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wGrupo).Status(400)
    else
       Res.Send<TJSONObject>(wGrupo).Status(200);
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
  THorse.Get('/trabinapi/cadastros/pessoas/:idpessoa/grupos',ListaTodosGrupos);
  THorse.Get('/trabinapi/cadastros/pessoas/:idpessoa/grupos/:id',RetornaGrupo);

// Método Post
  THorse.Post('/trabinapi/cadastros/pessoas/:idpessoa/grupos',CriaGrupo);

  // Método Put
  THorse.Put('/trabinapi/cadastros/pessoas/:idpessoa/grupos/:id',AlteraGrupo);

// Método Delete
  THorse.Delete('/trabinapi/cadastros/pessoas/:idpessoa/grupos/:id',ExcluiGrupo);
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
