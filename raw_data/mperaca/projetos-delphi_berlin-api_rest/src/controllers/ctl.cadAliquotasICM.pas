unit ctl.cadAliquotasICM;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses dat.cadAliquotasICM, prv.dataModuleConexao, models.cadAliquotasICM;


procedure ListaTodasAliquotas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
    wlista := dat.cadAliquotasICM.RetornaListaAliquotas(Req.Query,widempresa);
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

procedure CriaAliquota(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wAliquota,wnewAliquota,wresp,werro: TJSONObject;
    wval: string;
    widempresa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wAliquota    := TJSONObject.Create;
    wnewAliquota := TJSONObject.Create;
    wresp        := TJSONObject.Create;
    wAliquota    := Req.Body<TJSONObject>;
    wconexao      := TProviderDataModuleConexao.Create(nil);
    widempresa    := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadAliquotasICM.VerificaRequisicao(wAliquota) then
       begin
         wnewAliquota := dat.cadAliquotasICM.IncluiAliquota(wAliquota,widempresa);
         if wnewAliquota.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewAliquota).Status(400)
         else
            Res.Send<TJSONObject>(wnewAliquota).Status(201);
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

procedure AlteraAliquota(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wAliquota,wnewAliquota,wresp,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wnewAliquota := TJSONObject.Create;
    wAliquota    := TJSONObject.Create;
    wresp        := TJSONObject.Create;
    wid          := Req.Params['id'].ToInteger; // recupera o id da Aliquota
    wAliquota    := Req.Body<TJSONObject>;
    wnewAliquota := dat.cadAliquotasICM.AlteraAliquota(wid,wAliquota);
    if wnewAliquota.TryGetValue('codigo',wval) then
       begin
         wnewAliquota.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewAliquota).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Alíquota não encontrada');
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

procedure ExcluiAliquota(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid: integer;
    wret,werro: TJSONObject;
begin
  try
    wid := Req.Params['id'].ToInteger; // recupera o id da Aliquota
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadAliquotasICM.ApagaAliquota(wid);
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


procedure RetornaAliquota(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wAliquota,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid       := Req.Params['id'].ToInteger; // recupera o id da Aliquota
    wAliquota := TJSONObject.Create;
    wAliquota := Req.Body<TJSONObject>;
    wAliquota := dat.cadAliquotasICM.RetornaAliquota(wid);
    if wAliquota.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wAliquota).Status(400)
    else
       Res.Send<TJSONObject>(wAliquota).Status(200);
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
  THorse.Get('/trabinapi/cadastros/aliquotas',ListaTodasAliquotas);
  THorse.Get('/trabinapi/cadastros/aliquotas/:id',RetornaAliquota);

// Método Post
  THorse.Post('/trabinapi/cadastros/aliquotas',CriaAliquota);

  // Método Put
  THorse.Put('/trabinapi/cadastros/aliquotas/:id',AlteraAliquota);

  // Método Delete
  THorse.Delete('/trabinapi/cadastros/aliquotas/:id',ExcluiAliquota);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('cadastros/aliquotas')
      .Tag('AliquotasICM')
      .GET('Listar Alíquotas ICM')
        .AddResponse(200, 'Lista de Alíquotas').Schema(TAliquotas).IsArray(True).&End
      .&End
      .POST('Criar uma nova Alíquota')
        .AddParamBody('Dados da Alíquota').Required(True).Schema(TAliquotas).&End
        .AddParamQuery('codigo', 'Código').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('percentual', 'Percentual').&End
        .AddParamQuery('percentualsc', 'Percentual SC').&End
        .AddParamQuery('percentualsp', 'Percentual SP').&End
        .AddParamQuery('basecalculo', 'Base de Cálculo').&End
        .AddParamQuery('somaoutros', 'Soma Outros').&End
        .AddParamQuery('somaisentos', 'Soma Isentos').&End
        .AddResponse(201).Schema(TAliquotas).&End
        .AddResponse(400).&End
      .&End
    .&End
    .Path('cadastros/aliquotas/{id}')
      .Tag('AliquotasICM')
      .GET('Obter os dados de uma Alíquota específica')
        .AddParamPath('id', 'Id').&End
        .AddResponse(200, 'Dados da Alíquota').Schema(TAliquotas).&End
        .AddResponse(404).&End
      .&End
      .PUT('Alterar os dados de uma Alíquota específica')
        .AddParamPath('id', 'Id').&End
        .AddParamQuery('codigo', 'Código').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('percentual', 'Percentual').&End
        .AddParamQuery('percentualsc', 'Percentual SC').&End
        .AddParamQuery('percentualsp', 'Percentual SP').&End
        .AddParamQuery('basecalculo', 'Base de Cálculo').&End
        .AddParamQuery('somaoutros', 'Soma Outros').&End
        .AddParamQuery('somaisentos', 'Soma Isentos').&End
        .AddParamBody('Dados da Alíquota').Required(True).Schema(TAliquotas).&End
        .AddResponse(200).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
      .DELETE('Excluir Alíquota')
        .AddParamPath('id', 'Id').&End
        .AddResponse(204).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
