unit ctl.cadGradesTitulos;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.dataModuleConexao, dat.cadGradesTitulos;


procedure ListaTodosTitulos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
    widempresa,widgrade: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    widgrade      := Req.Params['idgrade'].ToInteger; // recupera o id da Grade
    wconexao      := TProviderDataModuleConexao.Create(nil);
    widempresa    := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini
    wlista := TJSONArray.Create;
    wlista := dat.cadGradesTitulos.RetornaListaTitulos(Req.Query,widgrade);
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

procedure CriaTitulo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wTitulo,wnewTitulo,wresp,werro: TJSONObject;
    wval: string;
    widempresa,widgrade: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    widgrade    := Req.Params['idgrade'].ToInteger; // recupera o id da Grade
    wTitulo     := TJSONObject.Create;
    wnewTitulo  := TJSONObject.Create;
    wresp       := TJSONObject.Create;
    wTitulo     := Req.Body<TJSONObject>;
    wconexao    := TProviderDataModuleConexao.Create(nil);
    widempresa  := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.cadGradesTitulos.VerificaRequisicao(wTitulo) then
       begin
         wnewTitulo := dat.cadGradesTitulos.IncluiTitulo(wTitulo,widgrade);
         if wnewTitulo.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewTitulo).Status(400)
         else
            Res.Send<TJSONObject>(wnewTitulo).Status(201);
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

procedure AlteraTitulo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wTitulo,wnewTitulo,wresp,werro: TJSONObject;
    wid,widgrade: integer;
    wval: string;
begin
  try
    wnewTitulo := TJSONObject.Create;
    wTitulo    := TJSONObject.Create;
    wresp      := TJSONObject.Create;
    widgrade   := Req.Params['idgrade'].ToInteger; // recupera o id da Grade
    wid        := Req.Params['id'].ToInteger; // recupera o id do Título
    wTitulo    := Req.Body<TJSONObject>;
    wnewTitulo := dat.cadGradesTitulos.AlteraTitulo(wid,wTitulo);
    if wnewTitulo.TryGetValue('numero',wval) then
       begin
         wnewTitulo.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wnewTitulo).Status(200);
       end
    else
       begin
         wresp.AddPair('status','400');
         wresp.AddPair('description','Título não encontrado');
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

procedure ExcluiTitulo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wid,widgrade: integer;
    wret,werro: TJSONObject;
begin
  try
    wid      := Req.Params['id'].ToInteger; // recupera o id do Título
    widgrade := Req.Params['idgrade'].ToInteger; // recupera o id da Grade
    if wid>0 then
       begin
         wret := TJSONObject.Create;
         wret := dat.cadGradesTitulos.ApagaTitulo(wid);
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

procedure RetornaTitulo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wTitulo,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid     := Req.Params['id'].ToInteger; // recupera o id do Titulo
    wTitulo := TJSONObject.Create;
    wTitulo := Req.Body<TJSONObject>;
    wTitulo := dat.cadGradesTitulos.RetornaTitulo(wid);
    if wTitulo.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wTitulo).Status(400)
    else
       Res.Send<TJSONObject>(wTitulo).Status(200);
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
  THorse.Get('/trabinapi/cadastros/grades/:idgrade/titulos',ListaTodosTitulos);
  THorse.Get('/trabinapi/cadastros/grades/:idgrade/titulos/:id',RetornaTitulo);

// Método Post
  THorse.Post('/trabinapi/cadastros/grades/:idgrade/titulos',CriaTitulo);

  // Método Put
  THorse.Put('/trabinapi/cadastros/grades/:idgrade/titulos/:id',AlteraTitulo);

// Método Delete
  THorse.Delete('/trabinapi/cadastros/grades/:idgrade/titulos/:id',ExcluiTitulo);
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
