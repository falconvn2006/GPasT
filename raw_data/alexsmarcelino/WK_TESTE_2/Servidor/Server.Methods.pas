unit Server.Methods;

interface

uses
   System.SysUtils, System.Classes, System.Json, Datasnap.DSServer, Data.DBXPlatform,
   Datasnap.DSAuth, DataSnap.DSProviderDataModuleAdapter, Data.DB, REST.JSON,
   REST.Client, REST.Types;

type
  TsmGeral = class(TDSServerModule)
  private
    { Private declarations }
    procedure FormatarJSON(const AIDCode: Integer; const AContent: String);
    function RESTReqHTTP(sBaseURL, sBody, jsParametros: String; rmMetodo: TRESTRequestMethod; var CodHttp: Integer): String;
  public
    { Public declarations }
    function Selecao(Filtro: String): TJSONValue;
    function cancelExcluir(IdPessoa: Integer): TJSONValue;
    function acceptEditar(Dados: TJSONObject): TJSONValue;
    function updateInserir(Dados: TJSONObject): TJSONValue;
    function AtualizarEndereco(IdEndereco: Integer; Cep: String): TJSONValue;
  end;

implementation

{$R *.dfm}

uses System.StrUtils, DAO.Crud, Model.Pessoa, Model.Logradouro;

function TsmGeral.AtualizarEndereco(IdEndereco: Integer;
  Cep: String): TJSONValue;
var
  Retorno: TJSONObject;
  CodHttp: Integer;
  Response: String;
  Logradouro: TLogradouro;
  Sucesso: Boolean;
  Msg: String;
  FCrud: TCrud;
begin
  try
    try
      Response := RESTReqHTTP('http://viacep.com.br/ws/' + Cep + '/json/','','',rmGet,CodHttp);
      Retorno := TJSONObject.Create;
      if CodHttp = 200 then
      begin
        Logradouro := TJson.JsonToObject<TLogradouro>(Response);
        Sucesso := FCrud.AtualizarEndereco(IdEndereco,
                                           Logradouro.Logradouro,
                                           Logradouro.Bairro,
                                           Logradouro.Uf,
                                           Logradouro.Localidade,
                                           Logradouro.Complemento,
                                           Msg);
        if not Sucesso then
        begin
          CodHttp := 400;
          raise Exception.Create(Msg);
        end;
      end
      else
       raise Exception.Create(Response);
      Retorno.AddPair('Sucesso',Msg);
      Result := Retorno;
      FormatarJSON(200,Result.ToString);
    except
      on e:exception do begin
        Retorno.AddPair('error',e.Message);
        FormatarJSON(CodHttp,Retorno.ToString);
      end;
    end;
  finally
    FreeAndNil(Retorno);
  end;
end;

function TsmGeral.cancelExcluir(IdPessoa: Integer): TJSONValue;
var
  Sucesso: Boolean;
  Msg: String;
  Retorno: TJSONObject;
  FCrud: TCrud;
begin
  try
    try
      Retorno := TJSONObject.Create;
      Sucesso := FCrud.Excluir(IdPessoa,Msg);
      if not Sucesso then
        raise Exception.Create(Msg);
      Retorno.AddPair('Sucesso','Pessoa ID ' + IdPessoa.ToString + ' excluída com sucesso!');
      Result := Retorno;
      FormatarJSON(200,Result.ToString);
    except
      on e:exception do begin
        Retorno.AddPair('error',e.Message);
        FormatarJSON(400,Retorno.ToString);
      end;
    end;
  finally
    FreeAndNil(Retorno);
  end;
end;

procedure TsmGeral.FormatarJSON(const AIDCode: Integer; const AContent: String);
begin
  GetInvocationMetadata().ResponseCode    := AIDCode;
  GetInvocationMetadata().ResponseContent := AContent;
end;

function TsmGeral.Selecao(Filtro: String): TJSONValue;
var
  Retorno: TJSONObject;
  Dados: TJSONValue;
  FCrud: TCrud;
begin
  try
    try
      Retorno := TJSONObject.Create;
      Result := FCrud.Selecao('');
      FormatarJSON(200,Result.ToString);
    except
      on e:exception do begin
        Retorno.AddPair('error',e.Message);
        FormatarJSON(400,Retorno.ToString);
      end;
    end;
  finally
    FreeAndNil(Retorno);
  end;
end;

function TsmGeral.acceptEditar(Dados: TJSONObject): TJSONValue;
var
  Pessoa: TPessoa;
  Retorno: TJSONObject;
  Sucesso: Boolean;
  Msg: String;
  FCrud: TCrud;
begin
  if Dados <> Nil then
    Pessoa := TJson.JsonToObject<TPessoa>(Dados);
  try
    Retorno := TJSONObject.Create;
    try
      Sucesso := FCrud.Editar(Pessoa.Idpessoa,
                              Pessoa.Primeironome,
                              Pessoa.Segundonome,
                              Pessoa.Documento,
                              Pessoa.Cep,
                              FloatToStr(Pessoa.Natureza),
                              Pessoa.Cidade,
                              Pessoa.Bairro,
                              Pessoa.Uf,
                              Pessoa.Logradouro,
                              Pessoa.Complemento,
                              Msg);
      if not Sucesso then
        raise Exception.Create(Msg);
      Retorno.AddPair('result',Msg);
      FormatarJSON(200,Retorno.ToString);
    except
      on e:exception do begin
        Retorno.AddPair('error',e.Message);
        FormatarJSON(400,Retorno.ToString);
      end;
    end;
  finally
    FreeAndNil(Pessoa);
    FreeAndNil(Retorno);
  end;
end;

function TsmGeral.updateInserir(Dados: TJSONObject): TJSONValue;
var
  Pessoa: TPessoa;
  Retorno: TJSONObject;
  Sucesso: Boolean;
  Msg: String;
  FCrud: TCrud;
begin
  if Dados <> Nil then
    Pessoa := TJson.JsonToObject<TPessoa>(Dados);
  try
    Retorno := TJSONObject.Create;
    try
      Sucesso := FCrud.Inserir(Pessoa.Primeironome,Pessoa.Segundonome,Pessoa.Documento,Pessoa.Cep,FloatToStr(Pessoa.Natureza),Msg);
      if not Sucesso then
        raise Exception.Create(Msg);
      Retorno.AddPair('result',Msg);
      FormatarJSON(200,Retorno.ToString);
    except
      on e:exception do begin
        Retorno.AddPair('error',e.Message);
        FormatarJSON(400,Retorno.ToString);
      end;
    end;
  finally
    FreeAndNil(Pessoa);
    FreeAndNil(Retorno);
  end;
end;

function TsmGeral.RESTReqHTTP(sBaseURL, sBody, jsParametros: String;
  rmMetodo: TRESTRequestMethod; var CodHttp: Integer): String;
var
  RestClient: TRESTClient;
  RestRequest: TRESTRequest;
  RestResponse: TRESTResponse;
  i: Smallint;
  Valor: String;
  Chave: String;
  Tipo: String;
  Encode: String;
  ArrayJS: TJSONArray;
begin
  Result  := '';
  CodHttp := 0;
  try
    try
      RestClient                     := TRESTClient.Create(nil);
      RestRequest                    := TRESTRequest.Create(nil);
      RestResponse                   := TRESTResponse.Create(nil);
      RestRequest.Client             := RestClient;
      RestRequest.Response           := RestResponse;
      RestRequest.SynchronizedEvents := False;
      RestRequest.Body.ClearBody;
      RestClient.FallbackCharsetEncoding := 'raw';
      RestRequest.Params.Clear;
      RestRequest.Method := rmMetodo;
      RestClient.BaseURL := sBaseURL;
      if jsParametros <> '' then
      begin
        //Tipo HEADER fixado (implementar tratativa se preciso)
        //Encode fixado (implementar tratativa se preciso)
        ArrayJS := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(jsParametros),0) as TJSONArray;
        for i := 0 to Pred(ArrayJS.Size) do begin
          Encode := TJSONObject(ArrayJS.Get(i)).Get('encode').JsonValue.Value;
          Tipo   := TJSONObject(ArrayJS.Get(i)).Get('tipo').JsonValue.Value;
          Chave  := TJSONObject(ArrayJS.Get(i)).Get('chave').JsonValue.Value;
          Valor  := TJSONObject(ArrayJS.Get(i)).Get('valor').JsonValue.Value;
          if Chave <> '' then begin
            if Tipo = 'GET/POST' then
              RestClient.Params.AddItem(Chave, Valor, TRESTRequestParameterKind.pkGETorPOST, [poDoNotEncode])
            else
              RestClient.Params.AddItem(Chave, Valor, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
            end;
        end;
        FreeAndNil(ArrayJs);
      end;
      if sBody <> '' then RestRequest.Body.Add(sBody, TRESTContentType.ctAPPLICATION_JSON);
      RestRequest.Execute;
      CodHttp := RestResponse.StatusCode;
      if not RestResponse.Status.Success then
      begin
        Result := '[FALHA]: ' + RestResponse.ErrorMessage;
      end;
    except
      on e:Exception do
      begin
        CodHttp := RestResponse.StatusCode;
        Result := '[FALHA]: ' + e.Message;
      end;
    end;
    Result := RestResponse.Content;
  finally
    FreeAndNil(RestClient);
    FreeAndNil(RestResponse);
    FreeAndNil(RestRequest);
  end;
end;

end.

