unit ctl.srvDFeTransfereXML;

interface

uses Horse, Horse.GBSwagger, System.UITypes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure registry;

implementation

uses prv.srvAutorizaNFe;

procedure TransfereArquivosXML(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var wultnsu: string;
    wdfe: TProviderServicoAutorizaNFe;
    wret,werro: TJSONObject;
    wval: string;
begin
  try
    wdfe      := TProviderServicoAutorizaNFe.Create(nil);
    wret      := TJSONObject.Create;
//    showmessage('chama');
    wret      := wdfe.TransfereArquivosXML;
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
// Método Post
  THorse.Post('/trabinapi/servicos/dfe/transferexml',TransfereArquivosXML);
//  THorse.Post('/trabinapi/servicos/dfe/darciencia/:chavenfe',DarCiencia);
// Método Delete
//  THorse.Delete('/trabinapi/servicos/nfe/:id',CancelaNFe);

end;

end.
