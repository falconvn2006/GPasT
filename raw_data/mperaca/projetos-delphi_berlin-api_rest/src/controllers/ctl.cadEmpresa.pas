unit ctl.cadEmpresa;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.dataModuleConexao, dat.cadEmpresa;

procedure RetornaEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wEmpresa,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wEmpresa := TJSONObject.Create;
    wEmpresa := dat.cadEmpresa.RetornaEmpresa;
    if wEmpresa.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wEmpresa).Status(400)
    else
       Res.Send<TJSONObject>(wEmpresa).Status(200);
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

procedure RetornaListaEmpresas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
begin
  try
    wlista := TJSONArray.Create;
    wlista := dat.cadEmpresa.RetornaListaEmpresas(Req.Query);
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


procedure Registry;
begin
// Método Get
  THorse.Get('/trabinapi/cadastros/empresas/:id',RetornaEmpresa);
  THorse.Get('/trabinapi/cadastros/empresas',RetornaListaEmpresas);
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
//        .AddParamBody('Dados da Atividade').Required(True).Schema(TAtividades).&End
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
