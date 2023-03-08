unit ctl.srvNFCe;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure registry;

implementation

uses prv.srvNFCe;

procedure GeraNFCe(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var widnfce: integer;
    wnfce: TProviderServicoNFCe;
    wret: TJSONObject;
    wval: string;
begin
  try
    wret    := TJSONObject.Create;
    wnfce   := TProviderServicoNFCe.Create(nil);
    widnfce := Req.Params['id'].ToInteger; // recupera o id da NFCe
    wret    := wnfce.CriaNFCe(widnfce);
    wret.TryGetValue('status',wval);
    if wval='200' then
       Res.Send<TJSONObject>(wret).Status(200)
    else
       Res.Send<TJSONObject>(wret).Status(strtoint(wval));
  except
  end;
end;

procedure Registry;
begin

// Método Post
  THorse.Post('/trabinapi/servicos/nfce/:id',GeraNFCe);

end;

end.
