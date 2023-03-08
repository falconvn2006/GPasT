unit ctl.movNFePendentesItens;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses dat.movNFePendentesItens, prv.dataModuleConexao;

procedure RetornaNFePendenteItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wnfeitem,werro: TJSONObject;
    wid,wnfe: integer;
    wval: string;
begin
  try
    wnfe     := Req.Params['nfe'].ToInteger; // recupera o id da nfe
    wid      := Req.Params['id'].ToInteger; // recupera o id do item
    wnfeitem := TJSONObject.Create;
    wnfeitem := dat.movNFePendentesItens.RetornaNFePendenteItem(wnfe,wid);
    if wnfeitem.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wnfeitem).Status(400)
    else
       Res.Send<TJSONObject>(wnfeitem).Status(200);
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

procedure RetornaNFePendenteItens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wnfeitem: TJSONArray;
    werro: TJSONObject;
    wnfe: integer;
    wval: string;
begin
  try
    wnfe     := Req.Params['nfe'].ToInteger; // recupera o id da nfe
    wnfeitem := TJSONArray.Create;
    wnfeitem := dat.movNFePendentesItens.RetornaNFePendenteItens(wnfe);
    werro    := wnfeitem.Get(0) as TJSONObject;
    if werro.TryGetValue('status',wval) then
       Res.Send<TJSONArray>(wnfeitem).Status(400)
    else
       Res.Send<TJSONArray>(wnfeitem).Status(200);
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


procedure ExcluiNFePendenteItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wnfeitem,werro: TJSONObject;
    wnfe,wid: integer;
    wval: string;
begin
  try
    wnfe     := Req.Params['nfe'].ToInteger; // recupera o id da nfe
    wid      := Req.Params['id'].ToInteger; // recupera o id do item
    wnfeitem := TJSONObject.Create;
    wnfeitem := Req.Body<TJSONObject>;
    wnfeitem := dat.movNFePendentesItens.ApagaNFePendenteItem(wnfe,wid);
    if wnfeitem.GetValue('status').Value='200' then
       Res.Send<TJSONObject>(wnfeitem).Status(200)
    else
       Res.Send<TJSONObject>(wnfeitem).Status(400);
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

procedure CriaNFePendenteItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wNFeItem,wnewNFeItem,wresp,werro: TJSONObject;
    wval: string;
    widempresa,wnfe: integer;
    wconexao: TProviderDataModuleConexao;
begin
  try
    wNFeItem       := TJSONObject.Create;
    wnewNFeItem    := TJSONObject.Create;
    wresp          := TJSONObject.Create;
    wNFeItem       := Req.Body<TJSONObject>;
    wnfe           := Req.Params['nfe'].ToInteger; // recupera o id da nfe
    wconexao       := TProviderDataModuleConexao.Create(nil);
    widempresa     := wconexao.FIdEmpresa; //id empresa do arquivo TrabinApi.ini

//    widempresa      := strtointdef(Req.Headers['idempresa'],0);

    if widempresa=0 then
       begin
         wresp.AddPair('status','405');
         wresp.AddPair('description','idempresa não definido');
         wresp.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         Res.Send<TJSONObject>(wresp).Status(405);
       end
    else if dat.movNFePendentesItens.VerificaRequisicao(wNFeItem) then
       begin
         wnewNFeItem := dat.movNFePendentesItens.IncluiNFePendenteItem(wNFeItem,wnfe,widempresa);
         if wnewNFeItem.TryGetValue('status',wval) then
            Res.Send<TJSONObject>(wnewNFeItem).Status(400)
         else
            Res.Send<TJSONObject>(wnewNFeItem).Status(201);
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

procedure Registry;
begin
// Método Get
  THorse.Get('/trabinapi/movimentos/nfe_pendentes/:nfe/itens',RetornaNFePendenteItens);
  THorse.Get('/trabinapi/movimentos/nfe_pendentes/:nfe/itens/:id',RetornaNFePendenteItem);

// Método Post
  THorse.Post('/trabinapi/movimentos/nfe_pendentes/:nfe/itens',CriaNFePendenteItem);


// Método Delete
  THorse.Delete('/trabinapi/movimentos/nfe_pendentes/:nfe/itens/:id',ExcluiNFePendenteItem);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('movimentos/nfe_pendentes/{nfe}/itens/{id}')
      .Tag('NFe pendentes')
      .GET('Obter os dados de uma nfe específica')
        .AddParamPath('id', 'Código').&End
//        .AddResponse(200, 'Dados da localidade').Schema(TLocalidades).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
