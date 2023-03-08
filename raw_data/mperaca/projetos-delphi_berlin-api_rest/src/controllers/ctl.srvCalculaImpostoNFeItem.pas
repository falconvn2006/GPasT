unit ctl.srvCalculaImpostoNFeItem;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure registry;

implementation

uses dat.srvCalculaImpostoNFeItem;


procedure CalculaImpostoNFeItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var widnfe,widitem: integer;
    wret: TJSONObject;
    wval: string;
begin
  try
    widnfe  := Req.Params['nfe'].ToInteger; // recupera o id da NFCe
    widitem := Req.Params['id'].ToInteger; // recupera o id do Ítem
    wret    := dat.srvCalculaImpostoNFeItem.CalculaImpostoItem(widnfe,widitem);
    wret.TryGetValue('status',wval);
    if wval='500' then
       Res.Send<TJSONObject>(wret).Status(500)
    else
       Res.Send<TJSONObject>(wret).Status(201);
  except
  end;
end;

procedure Registry;
begin

// Método Get
//  THorse.Get('/trabinapi/servicos/nfe/:chave',ConsultaNFe);
// Método Post
  THorse.Post('/trabinapi/servicos/nfe/:nfe/itens/:id/impostos',CalculaImpostoNFeItem);
// Método Delete
//  THorse.Delete('/trabinapi/servicos/nfe/:id',CancelaNFe);


end;

end.
