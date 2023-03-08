unit ctl.cadTabelasDescontosFaixas;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.dataModuleConexao, dat.cadTabelasDescontosFaixas;


procedure ListaTodasFaixas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
    widtabela,widempresa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    widtabela     := Req.Params['idtabela'].ToInteger; // recupera o id da Tabela
    wconexao      := TProviderDataModuleConexao.Create(nil);
    widempresa    := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini
    wlista := TJSONArray.Create;
    wlista := dat.cadTabelasDescontosFaixas.RetornaListaFaixas(Req.Query,widtabela);
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

procedure CriaFaixa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wFaixa,wnewFaixa,wresp,werro: TJSONObject;
    wval: string;
    widtabela,widempresa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    widtabela    := Req.Params['idtabela'].ToInteger; // recupera o id da Tabela
    wFaixa       := TJSONObject.Create;
    wnewFaixa    := TJSONObject.Create;
    wresp        := TJSONObject.Create;
    wFaixa       := Req.Body<TJSONObject>;
    wconexao     := TProviderDataModuleConexao.Create(nil);
    widempresa   := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadTabelasDescontosFaixas.VerificaRequisicao(wFaixa) then
       begin
         wnewFaixa := dat.cadTabelasDescontosFaixas.IncluiFaixa(wFaixa,widtabela);
         if wnewFaixa.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewFaixa).Status(400)
         else
            Res.Send<TJSONObject>(wnewFaixa).Status(201);
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

procedure AlteraFaixa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wFaixa,wnewFaixa,wresp,werro: TJSONObject;
    wid,widtabela: integer;
    wval,wdescerro: string;
begin
  try
    wnewFaixa := TJSONObject.Create;
    wFaixa    := TJSONObject.Create;
    wresp     := TJSONObject.Create;
    widtabela := Req.Params['idtabela'].ToInteger; // recupera o id do Fabricante
    wid       := Req.Params['id'].ToInteger; // recupera o id do Fabricante
    wFaixa    := Req.Body<TJSONObject>;
    wnewFaixa := dat.cadTabelasDescontosFaixas.AlteraFaixa(wid,wFaixa);
    if wnewFaixa.TryGetValue('id',wval) then
       begin
         wnewFaixa.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewFaixa).Status(200);
       end
    else if (wnewFaixa.TryGetValue('status',wval)) and (wval='500') then
       begin
         wnewFaixa.TryGetValue('description',wdescerro);
         wresp.AddPair('status',wval);
         wresp.AddPair('description',wdescerro);
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(strtoint(wval));
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Faixa Desconto não encontrada');
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

procedure ExcluiFaixa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid,widtabela: integer;
    wret,werro: TJSONObject;
begin
  try
    widtabela := Req.Params['idtabela'].ToInteger; // recupera o id da Tabela
    wid       := Req.Params['id'].ToInteger; // recupera o id do Fabricante
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadTabelasDescontosFaixas.ApagaFaixa(wid);
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

procedure RetornaFaixa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wFaixa,werro: TJSONObject;
    wid,widtabela: integer;
    wval: string;
begin
  try
    widtabela  := Req.Params['idtabela'].ToInteger; // recupera o id da Tabela
    wid        := Req.Params['id'].ToInteger; // recupera o id do Fabricante
    wFaixa     := TJSONObject.Create;
    wFaixa     := Req.Body<TJSONObject>;
    wFaixa     := dat.cadTabelasDescontosFaixas.RetornaFaixa(wid);
    if wFaixa.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wFaixa).Status(400)
    else
       Res.Send<TJSONObject>(wFaixa).Status(200);
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
  THorse.Get('/trabinapi/cadastros/tabelasdescontos/:idtabela/faixas',ListaTodasFaixas);
  THorse.Get('/trabinapi/cadastros/tabelasdescontos/:idtabela/faixas/:id',RetornaFaixa);

// Método Post
  THorse.Post('/trabinapi/cadastros/tabelasdescontos/:idtabela/faixas',CriaFaixa);

  // Método Put
  THorse.Put('/trabinapi/cadastros/tabelasdescontos/:idtabela/faixas/:id',AlteraFaixa);

  // Método Delete
  THorse.Delete('/trabinapi/cadastros/tabelasdescontos/:idtabela/faixas/:id',ExcluiFaixa);
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
