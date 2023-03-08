unit server.model.service.cep.viacep;

interface
uses
  System.SysUtils,
  server.model.service.interfaces,
  server.model.entity.consultacep,
  server.model.resource.interfaces;

type
  TServiceCEPViaCEP = class(TInterfacedObject, iServiceCEP)
    private
      FRestClient : iRest;
      FCode : String;
      FResult : String;
      procedure ConverterRetorno(aValue : TModelConsultaCEP);
    public
      constructor Create;
      class function New : iServiceCEP;
      function Code(aValue : String) : iServiceCEP;
      function Execute : iServiceCEP; overload;
      function Execute(aValue : TModelConsultaCEP) : iServiceCEP; overload;
      function Return : String;
  end;
implementation

uses
  server.model.resource.factory,
  System.JSON,
  REST.Json;

{ TServiceCEPViaCEP }

function TServiceCEPViaCEP.Code(aValue: String): iServiceCEP;
begin
  Result := Self;
  FCode := aValue;
end;

procedure TServiceCEPViaCEP.ConverterRetorno(aValue: TModelConsultaCEP);
var
  LJSONCEP : TJSONObject;
begin
  LJSONCEP := TJSONObject.ParseJSONValue(FResult) as TJSONOBject;
  try
    TJSON.JsonToObject(aValue, LJSONCEP);
  finally
    LJSONCEP.Free;
  end;
end;

constructor TServiceCEPViaCEP.Create;
begin
  FRestClient := TResourceFactory.New.Rest;
  FRestClient.Params.BaseURL('https://viacep.com.br');
end;

function TServiceCEPViaCEP.Execute(aValue: TModelConsultaCEP): iServiceCEP;
begin
  Result := Self;
  Execute;
  if FRestClient.StatusCode <> 200 then
    raise Exception.Create('Erro ao realizar a consulta do CEP');
  ConverterRetorno(aValue);
end;

function TServiceCEPViaCEP.Execute: iServiceCEP;
begin
  Result := Self;
  if FCode.IsEmpty then
    exit;
  FRestClient
    .Params
      .EndPoint(Format('ws/%s/json', [FCode]))
    .&End
    .Get;
  FResult := FRestClient.Content;
end;

class function TServiceCEPViaCEP.New: iServiceCEP;
begin
  Result := Self.Create;
end;

function TServiceCEPViaCEP.Return: String;
begin
  Result := FCode;
end;

end.
