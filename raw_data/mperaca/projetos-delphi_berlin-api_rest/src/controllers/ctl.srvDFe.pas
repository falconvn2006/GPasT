unit ctl.srvDFe;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure registry;

implementation

uses prv.srvAutorizaNFe;

procedure ConsultaDFeUltimoNSU(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wultnsu: string;
    wdfe: TProviderServicoAutorizaNFe;
    wlista: TJSONArray;
    wret,werro: TJSONObject;
    wval: string;
begin
  try
    wdfe      := TProviderServicoAutorizaNFe.Create(nil);
    wultnsu   := Req.Params['ultnsu']; // recupera a chave da NFCe
    wlista    := TJSONArray.Create;
    wlista    := wdfe.ConsultaDFeUltimoNSU(wultnsu);
    wret      := wlista.Get(0) as TJSONObject;
  //  if wret.TryGetValue('status',wval) then
//       Res.Send<TJSONArray>(wlista).Status(400)
//    else
       Res.Send<TJSONArray>(wlista).Status(200);
  except
  end;
end;


procedure DarCiencia(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wchavenfe: string;
    wdfe: TProviderServicoAutorizaNFe;
    wret: TJSONObject;
    wval: string;
begin
  try
    wdfe      := TProviderServicoAutorizaNFe.Create(nil);
    wchavenfe := Req.Params['chavenfe']; // recupera o id da NFCe
    wret      := wdfe.DarCienciaDFe(wchavenfe);
    wret.TryGetValue('status',wval);
    if wval='500' then
       Res.Send<TJSONObject>(wret).Status(500)
    else
       Res.Send<TJSONObject>(wret).Status(201);
  except
  end;
end;

{procedure CancelaNFe(Req: THorseRequest; Res: THorseResponse; Next: TProc);
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
end;}

procedure Registry;
begin

// Método Get
  THorse.Get('/trabinapi/servicos/dfe/consulta/:ultnsu',ConsultaDFeUltimoNSU);
// Método Post
  THorse.Post('/trabinapi/servicos/dfe/darciencia/:chavenfe',DarCiencia);
// Método Delete
//  THorse.Delete('/trabinapi/servicos/nfe/:id',CancelaNFe);

end;

end.
