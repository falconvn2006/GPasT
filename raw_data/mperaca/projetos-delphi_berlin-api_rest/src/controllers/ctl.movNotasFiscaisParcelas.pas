unit ctl.movNotasFiscaisParcelas;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation


uses models.movOrcamentosParcelas, dat.movNotasFiscaisParcelas;

procedure RetornaNotaFiscalParcela(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wparcela,werro: TJSONObject;
    wid,wnota: integer;
    wval: string;
begin
  try
    wnota       := Req.Params['nota'].ToInteger; // recupera o id do orçamento
    wid         := Req.Params['id'].ToInteger; // recupera o id da parcela
    wparcela    := TJSONObject.Create;
    wparcela    := dat.movNotasFiscaisParcelas.RetornaNotaFiscalParcela(wnota,wid);
    if wparcela.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wparcela).Status(400)
    else
       Res.Send<TJSONObject>(wparcela).Status(200);
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

procedure RetornaNotaFiscalListaParcelas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wparcela: TJSONArray;
    werro: TJSONObject;
    wnota: integer;
    wval: string;
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
    wnota    := Req.Params['nota'].ToInteger; // recupera o id do orcamento
    wparcela := TJSONArray.Create;
    wparcela := dat.movNotasFiscaisParcelas.RetornaNotaFiscalParcelas(Req.Query,wnota,wlimit,woffset);
    werro       := wparcela.Get(0) as TJSONObject;
    if werro.TryGetValue('status',wval) then
       Res.Send<TJSONArray>(wparcela).Status(400)
    else
       Res.Send<TJSONArray>(wparcela).Status(200);
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


{procedure ExcluiNFePendenteItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
begin
  try
    wNFeItem     := TJSONObject.Create;
    wnewNFeItem  := TJSONObject.Create;
    wresp        := TJSONObject.Create;
    wNFeItem     := Req.Body<TJSONObject>;
    wnfe         := Req.Params['nfe'].ToInteger; // recupera o id da nfe

    widempresa      := strtointdef(Req.Headers['idempresa'],0);

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
end;}

procedure RetornaTotalParcelas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wtotal,werro: TJSONObject;
    wval: string;
    widnota: integer;
begin
  try
    widnota := Req.Params['nota'].ToInteger; // recupera o id da Pessoa
    wtotal  := TJSONObject.Create;
    wtotal  := dat.movNotasFiscaisParcelas.RetornaTotalParcelas(Req.Query,widnota);
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
  THorse.Get('/trabinapi/movimentos/notasfiscais/:nota/parcelas',RetornaNotaFiscalListaParcelas);
  THorse.Get('/trabinapi/movimentos/notasfiscais/:nota/parcelas/total',RetornaTotalParcelas);
  THorse.Get('/trabinapi/movimentos/notasfiscais/:nota/parcelas/:id',RetornaNotaFiscalParcela);

// Método Post
//  THorse.Post('/trabinapi/movimentos/nfe_pendentes/:nfe/itens',CriaNFePendenteItem);


// Método Delete
//  THorse.Delete('/trabinapi/movimentos/nfe_pendentes/:nfe/itens/:id',ExcluiNFePendenteItem);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('movimentos/orcamentos/{orcamento}/parcelas')
      .Tag('Parcelas')
      .GET('Obter a lista de parcelas de um Orçamento')
        .AddParamPath('numero', 'Número Parcela').&End
        .AddParamPath('valor', 'Valor Parcela').&End
        .AddParamPath('emissao', 'Data Emissão Parcela').&End
        .AddParamPath('vencimento', 'Data Vencimento Parcela').&End
        .AddParamPath('operacao', 'Data Operação Parcela').&End
        .AddResponse(200, 'Dados da parcela').Schema(TOrcamentosParcelas).&End
        .AddResponse(404).&End
      .&End
    .&End
    .Path('movimentos/orcamentos/{orcamento}/parcelas/{id}')
      .Tag('Parcela')
      .GET('Obter os dados de uma parcela específica')
        .AddParamPath('numero', 'Número Parcela').&End
        .AddParamPath('valor', 'Valor Parcela').&End
        .AddParamPath('emissao', 'Data Emissão Parcela').&End
        .AddParamPath('vencimento', 'Data Vencimento Parcela').&End
        .AddParamPath('operacao', 'Data Operação Parcela').&End
        .AddResponse(200, 'Dados da parcela').Schema(TOrcamentosParcelas).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
