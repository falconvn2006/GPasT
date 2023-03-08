unit ctl.srvAutorizaNFe;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure registry;

implementation

uses prv.srvAutorizaNFe;

procedure ConsultaNFe(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wchave: string;
    wnfe: TProviderServicoAutorizaNFe;
    wret: TJSONObject;
    wval: string;
begin
  try
    wnfe    := TProviderServicoAutorizaNFe.Create(nil);
    wchave  := Req.Params['chave']; // recupera a chave da NFCe
    wret    := wnfe.ConsultaNFe(wchave);
    wret.TryGetValue('status',wval);
    if wval='500' then
       Res.Send<TJSONObject>(wret).Status(500)
    else
       Res.Send<TJSONObject>(wret).Status(200);
  except
  end;
end;


procedure GeraNFe(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var widnfe: integer;
    wnfe: TProviderServicoAutorizaNFe;
    wret: TJSONObject;
    wval: string;
begin
  try
    wnfe    := TProviderServicoAutorizaNFe.Create(nil);
    widnfe  := Req.Params['id'].ToInteger; // recupera o id da NFCe
    wret    := wnfe.CriaNFe(widnfe);
    wret.TryGetValue('status',wval);
    if wval='500' then
       Res.Send<TJSONObject>(wret).Status(500)
    else
       Res.Send<TJSONObject>(wret).Status(201);
  except
  end;
end;

procedure CancelaNFe(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var widnfe: integer;
    wnfe: TProviderServicoAutorizaNFe;
    wret: TJSONObject;
    wval: string;
begin
  try
    wnfe    := TProviderServicoAutorizaNFe.Create(nil);
    widnfe  := Req.Params['id'].ToInteger; // recupera o id da NFCe
    wret    := wnfe.CancelaNFe(widnfe);
    wret.TryGetValue('status',wval);
    if wval='500' then
       Res.Send<TJSONObject>(wret).Status(201)
    else
       Res.Send<TJSONObject>(wret).Status(200);
  except
  end;
end;


procedure Registry;
begin

// Método Get
  THorse.Get('/trabinapi/servicos/nfe/:chave',ConsultaNFe);
// Método Post
  THorse.Post('/trabinapi/servicos/nfe/:id',GeraNFe);
// Método Delete
  THorse.Delete('/trabinapi/servicos/nfe/:id',CancelaNFe);


end;

end.
