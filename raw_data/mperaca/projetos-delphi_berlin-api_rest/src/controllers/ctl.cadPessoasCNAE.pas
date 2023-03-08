unit ctl.cadPessoasCNAE;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.dataModuleConexao, dat.cadPessoasCNAES;


procedure ListaTodosCNAES(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
    wlista := dat.cadPessoasCNAES.RetornaListaCNAES(Req.Query,widpessoa);
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

procedure CriaCNAE(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wCNAE,wnewCNAE,wresp,werro: TJSONObject;
    wval: string;
    widempresa,widpessoa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    widpessoa   := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    wCNAE       := TJSONObject.Create;
    wnewCNAE    := TJSONObject.Create;
    wresp       := TJSONObject.Create;
    wCNAE       := Req.Body<TJSONObject>;
    wconexao    := TProviderDataModuleConexao.Create(nil);
    widempresa  := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadPessoasCNAES.VerificaRequisicao(wCNAE) then
       begin
         wnewCNAE := dat.cadPessoasCNAES.IncluiCNAE(wCNAE,widpessoa);
         if wnewCNAE.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewCNAE).Status(400)
         else
            Res.Send<TJSONObject>(wnewCNAE).Status(201);
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

procedure AlteraCNAE(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wCNAE,wnewCNAE,wresp,werro: TJSONObject;
    wid,widpessoa: integer;
    wval: string;
begin
  try
    wnewCNAE    := TJSONObject.Create;
    wCNAE       := TJSONObject.Create;
    wresp       := TJSONObject.Create;
    widpessoa   := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    wid         := Req.Params['id'].ToInteger; // recupera o id do CNAE
    wCNAE       := Req.Body<TJSONObject>;
    wnewCNAE    := dat.cadPessoasCNAES.AlteraCNAE(wid,wCNAE);
    if wnewCNAE.TryGetValue('data',wval) then
       begin
         wnewCNAE.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewCNAE).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','CNAE não encontrado');
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

procedure ExcluiCNAE(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid,widpessoa: integer;
    wret,werro: TJSONObject;
begin
  try
    wid       := Req.Params['id'].ToInteger; // recupera o id do CNAE
    widpessoa := Req.Params['idpessoa'].ToInteger; // recupera o id da Pessoa
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadPessoasCNAES.ApagaCNAE(wid);
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

procedure RetornaCNAE(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wCNAE,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid   := Req.Params['id'].ToInteger; // recupera o id do CNAE
    wCNAE := TJSONObject.Create;
    wCNAE := Req.Body<TJSONObject>;
    wCNAE := dat.cadPessoasCNAES.RetornaCNAE(wid);
    if wCNAE.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wCNAE).Status(400)
    else
       Res.Send<TJSONObject>(wCNAE).Status(200);
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
  THorse.Get('/trabinapi/cadastros/pessoas/:idpessoa/cnaes',ListaTodosCNAES);
  THorse.Get('/trabinapi/cadastros/pessoas/:idpessoa/cnaes/:id',RetornaCNAE);

// Método Post
  THorse.Post('/trabinapi/cadastros/pessoas/:idpessoa/cnaes',CriaCNAE);

  // Método Put
  THorse.Put('/trabinapi/cadastros/pessoas/:idpessoa/cnaes/:id',AlteraCNAE);

// Método Delete
  THorse.Delete('/trabinapi/cadastros/pessoas/:idpessoa/cnaes/:id',ExcluiCNAE);
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
