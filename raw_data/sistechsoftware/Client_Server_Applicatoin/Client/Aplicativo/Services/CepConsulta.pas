unit CepConsulta;

interface

uses
  ClienteModel, System.Json, REST.Client, EnderecoIntegracaoModel;

type
  TCepConsulta = class

  private

  public
    procedure ConsultarCEP(cep : String);
  end;

implementation

uses
  System.Classes, System.SysUtils, Vcl.Dialogs, System.Variants, frmCadPessoa;

procedure TCepConsulta.ConsultarCEP(cep : String);
var
  jsonObj : TJsonObject;
  json : String;
  request : TRESTRequest;
  restClient : TRESTClient;
  enderecoIntegracao : TEnderecoIntegracao;
begin
  TThread.CreateAnonymousThread(procedure
  begin
    try
      restClient := TRESTClient.Create('viacep.com.br/ws/' + cep + '/json');

      request := TRESTRequest.Create(Nil);
      request.Client := restClient;
      request.Params.Clear;
      request.Execute;

      if request.Response.JSONValue = nil then
      begin
        raise Exception.Create('Erro ao consultar API cep');
      end
      else
      begin
        json    := request.Response.JSONValue.ToString;
        jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

        if jsonObj <> Nil then
        begin
          try
            enderecoIntegracao := TEnderecoIntegracao.Create;
            enderecoIntegracao.DsUf         := jsonObj.GetValue('uf').Value;
            enderecoIntegracao.NmCidade     := jsonObj.GetValue('localidade').Value;
            enderecoIntegracao.NmBairro     := jsonObj.GetValue('bairro').Value;
            enderecoIntegracao.NmLogradouro := jsonObj.GetValue('logradouro').Value;

            fCadPessoa.EnderecoIntegracao := enderecoIntegracao;
          finally
            FreeAndNil(enderecoIntegracao);
          end;
        end;
      end;

      jsonObj.DisposeOf;
    except on e : exception do
      begin
        ShowMessage(e.message);
      end;
    end;
  end).Start;
end;
end.
