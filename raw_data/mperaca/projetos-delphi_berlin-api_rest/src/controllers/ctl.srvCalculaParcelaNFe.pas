unit ctl.srvCalculaParcelaNFe;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure registry;

implementation


uses dat.srvCalculaParcelaNFe;

procedure CalculaParcelaNFe(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var widnfe: integer;
    wret: TJSONArray;
    wval: string;
begin
  try
    widnfe  := Req.Params['nfe'].ToInteger; // recupera o id da NFCe
    wret    := dat.srvCalculaParcelaNFe.CalculaParcela(widnfe);
    wret.TryGetValue('status',wval);
    if wval='500' then
       Res.Send<TJSONArray>(wret).Status(500)
    else
       Res.Send<TJSONArray>(wret).Status(201);
  except
  end;
end;

procedure Registry;
begin

// Método Get
//  THorse.Get('/trabinapi/servicos/nfe/:chave',ConsultaNFe);
// Método Post
  THorse.Post('/trabinapi/servicos/nfe/:nfe/parcelas',CalculaParcelaNFe);
// Método Delete
//  THorse.Delete('/trabinapi/servicos/nfe/:id',CancelaNFe);


end;

end.
