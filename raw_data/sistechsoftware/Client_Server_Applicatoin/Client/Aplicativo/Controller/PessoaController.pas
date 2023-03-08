unit PessoaController;

interface

uses
  ClienteModel, System.Json, REST.Client;

type
  TPessoaController = class

  private
    FPessoa : TPessoa;
    FPessoaController : TPessoaController;
    procedure EnviarServidor(pessoa : TPessoa);

  public
    procedure Insert(pessoa: TPessoa; pessoaController : TPessoaController);
  end;

implementation

uses
  System.Classes, System.SysUtils, Vcl.Dialogs, frmCadPessoa;

procedure TPessoaController.Insert(pessoa : TPessoa; pessoaController : TPessoaController);
begin
  FPessoa := pessoa;
  FPessoaController := pessoaController;
  EnviarServidor(pessoa);
end;

procedure TPessoaController.EnviarServidor(pessoa : TPessoa);
var
  jsonObj : TJsonObject;
  json : String;
  request : TRESTRequest;
  restClient : TRESTClient;
begin
   TThread.CreateAnonymousThread(procedure
   begin
     try
       try
         restClient := TRESTClient.Create('http://localhost:8084');

         request          := TRESTRequest.Create(Nil);
         request.Client   := restClient;
         request.Resource := 'NovoCliente';
         request.Params.Clear;
         request.AddParameter('nmprimeiro', pessoa.NmPrimeiro);
         request.AddParameter('nmsegundo', pessoa.NmSegundo);
         request.AddParameter('flnatureza', pessoa.FlNatureza.ToString);
         request.AddParameter('dsdocumento', pessoa.DsDocumento);
         request.AddParameter('dtregistro', DateToStr(pessoa.DtRegistro));

         request.AddParameter('dsCep', pessoa.Endereco.DsCep);
         request.AddParameter('dsUf', pessoa.EnderecoIntegracao.DsUf);
         request.AddParameter('nmCidade', pessoa.EnderecoIntegracao.NmCidade);
         request.AddParameter('nmBairro', pessoa.EnderecoIntegracao.NmBairro);
         request.AddParameter('nmLogradouro', pessoa.EnderecoIntegracao.NmLogradouro);
         request.Execute;

         if request.Response.JSONValue = nil then
         begin
           raise Exception.Create('Erro ao salvar o cliente: ' + jsonObj.GetValue('erro').Value);
         end
         else
         begin
           json    := request.Response.JSONValue.ToString;
           jsonObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json), 0) as TJSONObject;

           if jsonObj.GetValue('sucesso').Value <> 'S' then
           begin
             raise Exception.Create('Erro ao salvar o cliente: ' + jsonObj.GetValue('erro').Value);
           end;

           fCadPessoa.LimparCampos;
         end;
       except on e : exception do
         ShowMessage('Erro ao salvar o novo cliente: ' + e.Message);
       end;
     finally
       FPessoa.DisposeOf;;
       FPessoaController.DisposeOf;
       jsonObj.DisposeOf;
     end;
   end).Start;
end;

end.
