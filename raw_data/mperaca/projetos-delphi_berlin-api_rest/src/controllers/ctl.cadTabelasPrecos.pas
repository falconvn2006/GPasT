unit ctl.cadTabelasPrecos;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.dataModuleConexao, dat.cadTabelasPrecos;


procedure ListaTodosPrecos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
    widempresa: integer;
    wconexao: TProviderDataModuleConexao;
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
    wconexao      := TProviderDataModuleConexao.Create(nil);
    widempresa    := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini
    wlista := TJSONArray.Create;
    wlista := dat.cadTabelasPrecos.RetornaListaPrecos(Req.Query,wlimit,woffset);
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

procedure CriaPreco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wPreco,wnewPreco,wresp,werro: TJSONObject;
    wval: string;
    widempresa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wPreco      := TJSONObject.Create;
    wnewPreco   := TJSONObject.Create;
    wresp       := TJSONObject.Create;
    wPreco      := Req.Body<TJSONObject>;
    wconexao    := TProviderDataModuleConexao.Create(nil);
    widempresa  := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadTabelasPrecos.VerificaRequisicao(wPreco) then
       begin
         wnewPreco := dat.cadTabelasPrecos.IncluiPreco(wPreco);
         if wnewPreco.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewPreco).Status(400)
         else
            Res.Send<TJSONObject>(wnewPreco).Status(201);
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

procedure AlteraPreco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wPreco,wnewPreco,wresp,werro: TJSONObject;
    wid: integer;
    wval,wdescerro: string;
begin
  try
    wnewPreco := TJSONObject.Create;
    wPreco    := TJSONObject.Create;
    wresp     := TJSONObject.Create;
    wid       := Req.Params['id'].ToInteger; // recupera o id do Fabricante
    wPreco    := Req.Body<TJSONObject>;
    wnewPreco := dat.cadTabelasPrecos.AlteraPreco(wid,wPreco);
    if wnewPreco.TryGetValue('id',wval) then
       begin
         wnewPreco.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewPreco).Status(200);
       end
    else if (wnewPreco.TryGetValue('status',wval)) and (wval='500') then
       begin
         wnewPreco.TryGetValue('description',wdescerro);
         wresp.AddPair('status',wval);
         wresp.AddPair('description',wdescerro);
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(strtoint(wval));
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Tabela Grupo não encontrada');
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

procedure ExcluiPreco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid: integer;
    wret,werro: TJSONObject;
begin
  try
    wid := Req.Params['id'].ToInteger; // recupera o id do Fabricante
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadTabelasPrecos.ApagaPreco(wid);
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

procedure RetornaPreco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wPreco,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid    := Req.Params['id'].ToInteger; // recupera o id do Fabricante
    wPreco := TJSONObject.Create;
    wPreco := Req.Body<TJSONObject>;
    wPreco := dat.cadTabelasPrecos.RetornaPreco(wid);
    if wPreco.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wPreco).Status(400)
    else
       Res.Send<TJSONObject>(wPreco).Status(200);
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

procedure RetornaTotalTabelas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wtotal,werro: TJSONObject;
    wval: string;
begin
  try
    wtotal := TJSONObject.Create;
    wtotal := dat.cadTabelasPrecos.RetornaTotalTabelas(Req.Query);
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
  THorse.Get('/trabinapi/cadastros/tabelasprecos',ListaTodosPrecos);
  THorse.Get('/trabinapi/cadastros/tabelasprecos/:id',RetornaPreco);
  THorse.Get('/trabinapi/cadastros/tabelasprecos/total',RetornaTotalTabelas);

// Método Post
  THorse.Post('/trabinapi/cadastros/tabelasprecos',CriaPreco);

  // Método Put
  THorse.Put('/trabinapi/cadastros/tabelasprecos/:id',AlteraPreco);

  // Método Delete
  THorse.Delete('/trabinapi/cadastros/tabelasprecos/:id',ExcluiPreco);
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
