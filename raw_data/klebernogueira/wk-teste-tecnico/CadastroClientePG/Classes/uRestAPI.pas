unit uRestAPI;

interface

uses
   REST.Types, REST.Client, REST.Json, Data.Bind.Components,
   Data.Bind.ObjectScope,
   CEPModel;

procedure Executar(sURL: string; var oCEPModel: TCEPModel);

implementation

var
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;


procedure Executar(sURL: string; var oCEPModel: TCEPModel);
var
   oJSON: TJson;
   sJSON: string;
begin
   oCEPModel := nil;
   RESTClient := TRESTClient.Create(nil);
   oJSON := TJson.Create();
   try
      RESTClient.BaseURL := sURL;
      RESTClient.ContentType := 'application/json';

      RESTRequest := TRESTRequest.Create(nil);
      RESTResponse := TRESTResponse.Create(nil);

      RESTRequest.Client := RESTClient;
      RESTRequest.Response := RESTResponse;

      RESTRequest.Execute;
      sJSON := RESTResponse.Content;
      if (sJSON <> '') then begin
         //oCEPModel := TCEPModel.Create();

         oCEPModel := oJSON.JsonToObject<TCEPModel>(sJSON);
         if (oCEPModel.cep = '') then
            oCEPModel := nil;

      end;

   except

   end;

end;

end.
