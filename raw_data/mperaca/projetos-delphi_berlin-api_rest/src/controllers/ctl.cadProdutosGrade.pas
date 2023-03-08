unit ctl.cadProdutosGrade;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses dat.cadProdutosGrade;

procedure RetornaProdutoGrade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wproduto,werro: TJSONArray;
    wid: integer;
    wval: string;
    wobj: TJSONObject;
begin
  try
    wid      := Req.Params['id'].ToInteger; // recupera o id do produto
    wproduto := TJSONArray.Create;
    wproduto := dat.cadProdutosGrade.RetornaProdutoGrade(wid);
    if wproduto.TryGetValue('status',wval) then
       Res.Send<TJSONArray>(wproduto).Status(400)
    else
       Res.Send<TJSONArray>(wproduto).Status(200);
  except
    On E: Exception do
    begin
      wobj := TJSONObject.Create;
      wobj.AddPair('status','500');
      wobj.AddPair('description',E.Message);
      wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      werro := TJSONArray.Create;
      werro.AddElement(wobj);
    end;
  end;
end;

procedure Registry;
begin
// Método Get
  THorse.Get('/trabinapi/cadastros/produtos/:id/grade',RetornaProdutoGrade);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('cadastros/produtos')
      .Tag('Produtos')
      .GET('Listar produtos')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('codigo', 'Código').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('unidade', 'Unidade').&End
        .AddParamQuery('cean', 'Código de Barras').&End
        .AddParamQuery('marca', 'Marca').&End
        .AddParamQuery('fabricante', 'Fabricante').&End
        .AddParamQuery('preco', 'Preço de Venda').&End
//        .AddResponse(200, 'Lista de produtos').Schema(TProdutos).IsArray(True).&End
      .&End
    .&End
    .Path('cadastros/produtos/{id}')
      .Tag('Produtos')
      .GET('Obter os dados de um produto específico')
        .AddParamQuery('id', 'Interno').&End
        .AddParamQuery('codigo', 'Código').&End
        .AddParamQuery('descricao', 'Descrição').&End
        .AddParamQuery('unidade', 'Unidade').&End
        .AddParamQuery('cean', 'Código de Barras').&End
        .AddParamQuery('marca', 'Marca').&End
        .AddParamQuery('fabricante', 'Fabricante').&End
        .AddParamQuery('preco', 'Preço de Venda').&End
//        .AddResponse(200, 'Dados do cliente').Schema(TProdutos).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
