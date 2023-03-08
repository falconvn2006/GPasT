unit ctl.cadAgendas;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses dat.cadAgendas, prv.dataModuleConexao;

procedure ListaTodasAgendas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
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
    wlista := TJSONArray.Create;
    wlista := dat.cadAgendas.RetornaListaAgendas(Req.Query,wlimit,woffset);
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

procedure CriaAgenda(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wAgenda,wnewAgenda,wresp,werro: TJSONObject;
    wval: string;
    widempresa: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wAgenda    := TJSONObject.Create;
    wnewAgenda := TJSONObject.Create;
    wresp      := TJSONObject.Create;
    wAgenda    := Req.Body<TJSONObject>;

    wconexao      := TProviderDataModuleConexao.Create(nil);
    widempresa    := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadAgendas.VerificaRequisicao(wAgenda) then
       begin
         wnewAgenda := dat.cadAgendas.IncluiAgenda(wAgenda);
         if wnewAgenda.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewAgenda).Status(400)
         else
            Res.Send<TJSONObject>(wnewAgenda).Status(201);
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

procedure AlteraAgenda(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wAgenda,wnewAgenda,wresp,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wnewAgenda := TJSONObject.Create;
    wAgenda    := TJSONObject.Create;
    wresp      := TJSONObject.Create;
    wid        := Req.Params['id'].ToInteger; // recupera o id da Atividade
    wAgenda    := Req.Body<TJSONObject>;
    wnewAgenda := dat.cadAgendas.AlteraAgenda(wid,wAgenda);
    if wnewAgenda.TryGetValue('descricao',wval) then
       begin
         wnewAgenda.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewAgenda).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Agenda não encontrada');
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

procedure ExcluiAgenda(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid: integer;
    wret,werro: TJSONObject;
begin
  try
    wid := Req.Params['id'].ToInteger; // recupera o id da Agenda
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadAgendas.ApagaAgenda(wid);
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


procedure RetornaAgenda(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wAgenda,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid     := Req.Params['id'].ToInteger; // recupera o id da Agenda
    wAgenda := TJSONObject.Create;
    wAgenda := Req.Body<TJSONObject>;
    wAgenda := dat.cadAgendas.RetornaAgenda(wid);
    if wAgenda.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wAgenda).Status(400)
    else
       Res.Send<TJSONObject>(wAgenda).Status(200);
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

procedure RetornaTotalAgendas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wtotal,werro: TJSONObject;
    wval: string;
begin
  try
    wtotal := TJSONObject.Create;
    wtotal := dat.cadAgendas.RetornaTotalAgendas(Req.Query);
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
//Método Get
  THorse.Get('/trabinapi/cadastros/agendas',ListaTodasAgendas);
  THorse.Get('/trabinapi/cadastros/agendas/:id',RetornaAgenda);
  THorse.Get('/trabinapi/cadastros/agendas/total',RetornaTotalAgendas);

//Método Post
  THorse.Post('/trabinapi/cadastros/agendas',CriaAgenda);

//Método Put
  THorse.Put('/trabinapi/cadastros/agendas/:id',AlteraAgenda);

//Método Delete
  THorse.Delete('/trabinapi/cadastros/agendas/:id',ExcluiAgenda);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('cadastros/atividades')
      .Tag('Atividades')
      .GET('Listar Atividades')
        .AddParamQuery('id', 'Código').&End
        .AddParamQuery('nome', 'Nome').&End
//        .AddResponse(200, 'Lista de Atividades').Schema(TAtividades).IsArray(True).&End
      .&End
      .POST('Criar uma nova Atividade')
//        .AddParamBody('Dados da Atividade').Required(True).Schema(TAtividades).&End
//        .AddResponse(201).Schema(TAtividades).&End
        .AddResponse(400).&End
      .&End
    .&End
    .Path('cadastros/atividades/{id}')
      .Tag('Atividades')
      .GET('Obter os dados de uma Atividade específica')
        .AddParamPath('id', 'Código').&End
//        .AddResponse(200, 'Dados da Atividade').Schema(TAtividades).&End
        .AddResponse(404).&End
      .&End
      .PUT('Alterar os dados de uma Atividade específica')
        .AddParamPath('id', 'Código').&End
  //      .AddParamBody('Dados da Atividade').Required(True).Schema(TAtividades).&End
        .AddResponse(200).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
      .DELETE('Excluir Atividade')
        .AddParamPath('id', 'Código').&End
        .AddResponse(204).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
