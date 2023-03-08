unit ctl.cadVendedores;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation


uses models.cadVendedores, dat.cadVendedores;

procedure ListaTodosVendedores(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wlista: TJSONArray;
    wval: string;
    wret,werro: TJSONObject;
begin
  try
    wlista := TJSONArray.Create;
    wlista := dat.cadVendedores.RetornaListaVendedores(Req.Query);
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


procedure RetornaVendedor(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wvendedor,werro: TJSONObject;
    wid: integer;
    wval: string;
begin
  try
    wid       := Req.Params['id'].ToInteger; // recupera o id do vendedor
    wvendedor := TJSONObject.Create;
    wvendedor := dat.cadVendedores.RetornaVendedor(wid);
    if wvendedor.TryGetValue('status',wval) then
       Res.Send<TJSONObject>(wvendedor).Status(400)
    else
       Res.Send<TJSONObject>(wvendedor).Status(200);
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
  THorse.Get('/trabinapi/cadastros/vendedores',ListaTodosVendedores);
  THorse.Get('/trabinapi/cadastros/vendedores/:id',RetornaVendedor);

// Método Post
//  THorse.Post('/trabinapi/cadastros/localidades',CriaLocalidade);

  // Método Put
//  THorse.Put('/trabinapi/cadastros/localidades/:id',AlteraLocalidade);

  // Método Delete
//  THorse.Delete('/trabinapi/cadastros/localidades/:id',ExcluiLocalidade);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('cadastros/vendedores')
      .Tag('Vendedores')
      .GET('Listar vendedores')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('codigo', 'Código').&End
        .AddParamQuery('nome', 'Nome').&End
        .AddParamQuery('cpf', 'CPF').&End
        .AddParamQuery('cnpj', 'CNPJ').&End
        .AddParamQuery('inscest', 'Insc Estadual').&End
        .AddParamQuery('endereco', 'Endereço').&End
        .AddParamQuery('bairro', 'Bairro').&End
        .AddParamQuery('complemento', 'Complemento').&End
        .AddParamQuery('cidade', 'Cidade').&End
        .AddParamQuery('uf', 'UF').&End
        .AddParamQuery('cep', 'CEP').&End
        .AddParamQuery('telefone', 'Telefone').&End
        .AddResponse(200, 'Lista de vendedores').Schema(TVendedores).IsArray(True).&End
      .&End
    .&End
    .Path('cadastros/vendedores/{id}')
      .Tag('Vendedores')
      .GET('Obter os dados de um vendedor específico')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('codigo', 'Código').&End
        .AddParamQuery('nome', 'Nome').&End
        .AddParamQuery('cpf', 'CPF').&End
        .AddParamQuery('cnpj', 'CNPJ').&End
        .AddParamQuery('inscest', 'Insc Estadual').&End
        .AddParamQuery('endereco', 'Endereço').&End
        .AddParamQuery('bairro', 'Bairro').&End
        .AddParamQuery('complemento', 'Complemento').&End
        .AddParamQuery('cidade', 'Cidade').&End
        .AddParamQuery('uf', 'UF').&End
        .AddParamQuery('cep', 'CEP').&End
        .AddParamQuery('telefone', 'Telefone').&End
        .AddResponse(200, 'Dados do vendedor').Schema(TVendedores).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
