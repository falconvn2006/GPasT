unit ctl.arqNFeXML;

interface

uses Horse, Horse.GBSwagger, System.UITypes, XMLDoc, XMLIntf, Horse.OctetStream, System.Classes,
     System.SysUtils, Vcl.Dialogs, System.JSON, DataSet.Serialize, Data.DB;

procedure Registry;

implementation


uses prv.arqNFeXML;


procedure RetornaNFeXML(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var werro: TJSONObject;
    wprovider: TProviderArquivoNFeXML;
    wchave,wval: string;
    warqstream: TFileStream;
    wtam: integer;

begin
  try
    wchave     := Req.Params['chave']; // recupera a chave da NFe
    wprovider  := TProviderArquivoNFeXML.Create(nil);
    warqstream := wprovider.RetornaNFeXML(wchave);
    wtam       := warqstream.Size;
    Res.Send<TStream>(warqstream).Status(200);
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
  THorse.Get('/trabinapi/arquivos/nfe_xml/:chave',RetornaNFeXML);
end;

initialization

// definição da documentação
  Swagger
    .BasePath('trabinapi')
    .Path('arquivos/nfe_xml/{chave}')
      .Tag('Arquivo XML')
      .GET('Obter o xml de uma nfe específica')
        .AddParamPath('chave', 'Chave NFe').&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

end.
