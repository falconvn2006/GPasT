unit ctl.movNFeAutorizadas;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation


uses dat.movNFeAutorizadas;

procedure ListaTodasNFeAutorizadas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
begin
  try
    wlista := TJSONArray.Create;
    wlista := dat.movNFeAutorizadas.RetornaListaNFeAutorizadas(Req.Query);
    wret   := wlista.Items[0] as TJSONObject;
    if wret.TryGetValue('status',wval) then
       Res.Send<TJSONArray>(wlista).Status(404)
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


procedure RetornaNFeAutorizada(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wnfeautorizada,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid          := Req.Params['id'].ToInteger; // recupera o id da nfe
    wnfeautorizada := TJSONObject.Create;
    wnfeautorizada := Req.Body<TJSONObject>;
    wnfeautorizada := dat.movNFeAutorizadas.RetornaNFeAutorizada(wid);
    if wnfeautorizada.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wnfeautorizada).Status(404)
    else
       Res.Send<TJSONObject>(wnfeautorizada).Status(200);
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
  THorse.Get('/trabinapi/movimentos/nfe_autorizadas',ListaTodasNFeAutorizadas);
  THorse.Get('/trabinapi/movimentos/nfe_autorizadas/:id',RetornaNFeAutorizada);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('movimentos/nfe_autorizadas')
      .Tag('NFe autorizadas')
      .GET('Listar nfe autorizdas')
        .AddParamQuery('id', 'Código').&End
        .AddParamQuery('nome', 'Nome').&End
        .AddParamQuery('uf', 'UF').&End
        .AddParamQuery('regiao', 'Região').&End
        .AddParamQuery('codibge', 'Código IBGE').&End
//        .AddResponse(200, 'Lista de localidades').Schema(TLocalidades).IsArray(True).&End
      .&End
    .&End
    .Path('movimentos/nfe_autorizadas/{id}')
      .Tag('NFe pendentes')
      .GET('Obter os dados de uma nfe específica')
        .AddParamPath('id', 'Código').&End
//        .AddResponse(200, 'Dados da localidade').Schema(TLocalidades).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
