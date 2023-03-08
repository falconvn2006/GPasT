unit ctl.arqPedidoPDF;

interface

uses Horse, Horse.GBSwagger, System.UITypes, XMLDoc, XMLIntf, Horse.OctetStream, System.Classes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation

uses prv.arqPedidoPDF;

procedure RetornaPedidoPDF(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var werro: TJSONObject;
    wprovider: TProviderArquivoPedidoPDF;
    wval: string;
    warqstream: TFileStream;
    wid,wtam: integer;

begin
  try
    wid        := strtoint(Req.Params['id']); // recupera o id do Pedido
    wprovider  := TProviderArquivoPedidoPDF.Create(nil);
    warqstream := wprovider.RetornaPedidoPDF(wid);
//    wprovider.GeraArquivo;
    wtam       := warqstream.Size;
    Res.Send<TStream>(warqstream).Status(200);
//    Res.Send('gera arquivo').Status(200);
  except
    On E: Exception do
    begin
      werro := TJSONObject.Create;
      werro.AddPair('status','404');
      werro.AddPair('description',E.Message);
      werro.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      Res.Send<TJSONObject>(werro).Status(404);
    end;
  end;
end;

procedure Registry;
begin
// Método Get
  THorse.Get('/trabinapi/arquivos/orcamento/:id',RetornaPedidoPDF);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('arquivos/orcamento/{id}')
      .Tag('Arquivo PDF')
      .GET('Obter o pdf de um pedido específico')
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
