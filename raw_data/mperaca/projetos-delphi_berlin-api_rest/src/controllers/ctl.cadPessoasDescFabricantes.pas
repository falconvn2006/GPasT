unit ctl.cadPessoasDescFabricantes;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.dataModuleConexao, dat.cadPessoasDescFabricantes;


procedure ListaTodosDescFabricantes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
    wlista := dat.cadPessoasDescFabricantes.RetornaListaDescFabricantes(Req.Query,widpessoa);
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

procedure CriaDescFabricante(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wDescFabricante,wnewDescFabricante,wresp,werro: TJSONObject;
    wval: string;
    widempresa,widpessoa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    widpessoa          := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    wDescFabricante    := TJSONObject.Create;
    wnewDescFabricante := TJSONObject.Create;
    wresp              := TJSONObject.Create;
    wDescFabricante    := Req.Body<TJSONObject>;
    wconexao           := TProviderDataModuleConexao.Create(nil);
    widempresa         := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadPessoasDescFabricantes.VerificaRequisicao(wDescFabricante) then
       begin
         wnewDescFabricante := dat.cadPessoasDescFabricantes.IncluiDescFabricante(wDescFabricante,widpessoa);
         if wnewDescFabricante.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewDescFabricante).Status(400)
         else
            Res.Send<TJSONObject>(wnewDescFabricante).Status(201);
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

procedure AlteraDescFabricante(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wDescFabricante,wnewDescFabricante,wresp,werro: TJSONObject;
    wid,widpessoa: integer;
    wval: string;
begin
  try
    wnewDescFabricante := TJSONObject.Create;
    wDescFabricante    := TJSONObject.Create;
    wresp              := TJSONObject.Create;
    widpessoa          := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    wid                := Req.Params['id'].ToInteger; // recupera o id do Dependente
    wDescFabricante    := Req.Body<TJSONObject>;
    wnewDescFabricante := dat.cadPessoasDescFabricantes.AlteraDescFabricante(wid,wDescFabricante);
    if wnewDescFabricante.TryGetValue('idfabricante',wval) then
       begin
         wnewDescFabricante.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewDescFabricante).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Desc Fabricante não encontrado');
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

procedure ExcluiDescFabricante(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid,widpessoa: integer;
    wret,werro: TJSONObject;
begin
  try
    wid       := Req.Params['id'].ToInteger; // recupera o id do Dependente
    widpessoa := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadPessoasDescFabricantes.ApagaDescFabricante(wid);
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

procedure RetornaDescFabricante(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wDescFabricante,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid             := Req.Params['id'].ToInteger; // recupera o id do Contato
    wDescFabricante := TJSONObject.Create;
    wDescFabricante := Req.Body<TJSONObject>;
    wDescFabricante := dat.cadPessoasDescFabricantes.RetornaDescFabricante(wid);
    if wDescFabricante.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wDescFabricante).Status(400)
    else
       Res.Send<TJSONObject>(wDescFabricante).Status(200);
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
  THorse.Get('/trabinapi/cadastros/pessoas/:idpessoa/descfabricantes',ListaTodosDescFabricantes);
  THorse.Get('/trabinapi/cadastros/pessoas/:idpessoa/descfabricantes/:id',RetornaDescFabricante);

// Método Post
  THorse.Post('/trabinapi/cadastros/pessoas/:idpessoa/descfabricantes',CriaDescFabricante);

  // Método Put
  THorse.Put('/trabinapi/cadastros/pessoas/:idpessoa/descfabricantes/:id',AlteraDescFabricante);

// Método Delete
  THorse.Delete('/trabinapi/cadastros/pessoas/:idpessoa/descfabricantes/:id',ExcluiDescFabricante);
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
