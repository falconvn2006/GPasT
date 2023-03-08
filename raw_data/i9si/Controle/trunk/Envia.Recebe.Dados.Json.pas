unit Envia.Recebe.Dados.Json;

interface

uses
  REST.Types, Data.DB, System.JSON, REST.Json.Types, REST.Json, REST.Client,
  REST.Response.Adapter, Datasnap.DBClient, Datasnap.Provider, Funcoes.client,
  System.Classes;

type
  TEnviaRecebeDadosJson = class
  private
    function RetornaTotalJsonClientDataSet(TextoPadrao: string): TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
    RestClient   : TRestClient;
    RestRequest  : TRestRequest;
    RestResponse : TRestResponse;
    RESTResponseDataSetAdapter : TRESTResponseDataSetAdapter;
    ClientDataSet : TClientDataSet;
    DataSource   : TDataSource;
    DataSetProvider : TDataSetProvider;

    // Lista com os parametros que serão passados para o Request
    StrListPar : TStringList;

    // Record de retorno padrao para todas as funções
    FRetornos :  TRetornos;

    Function EnviaRequisicaoAPI(Json: String;
                                strlist: string;
                                Metodo: TRESTRequestMethod;
                                FileJson: String;
                                DividirJson: Boolean = False;
                                rootElement: string = '';// só funciona para um nível
                                AtribuiMimeTypeJson: Boolean = False): TRetornos;
    function CriaRestClient(pRestRequest_URL: string;
                            pRestRequest_Resource : String;
                            pRestRequest_Body: string;
                            pRestRequest_Method   : TRESTRequestMethod;
                            pRootElement: string = ''): TJSONValue;
  end;


var
  EnviaRecebeDadosJson: TEnviaRecebeDadosJson;

implementation

uses
  System.SysUtils;

{$R *.dfm}

function TEnviaRecebeDadosJson.CriaRestClient(pRestRequest_URL: string;
                                                       pRestRequest_Resource : String;
                                                       pRestRequest_Body: string;
                                                       pRestRequest_Method   : TRESTRequestMethod;
                                                       pRootElement: string = ''): TJSONValue;
begin
  Try
    // Criando os componentes
    RestClient   := TRestClient.Create(pRestRequest_URL);
    RestRequest  := TRestRequest.Create(nil);
    RestResponse := TRestResponse.Create(nil);
    RESTResponseDataSetAdapter := TRESTResponseDataSetAdapter.Create(nil);
    ClientDataSet := TClientDataSet.Create(nil);
    DataSource := TDataSource.Create(nil);

    // Parametros do RestClient
    With RestClient do
    begin
      Accept        := 'application/json, text/plain; q=0.9, text/html;q=0.8, multipart/form-data';
      ContentType   := 'application/json';
      AcceptCharset := 'utf-8, *;q=0.8';
    end;

    with RESTResponseDataSetAdapter do
    begin
      Response := RestResponse;
      Dataset  := ClientDataSet;
    end;

    // Parametros do RestRequest
    With RestRequest do
    begin
      // Ligando os componentes
      Client   := RestClient;
      Response := RestResponse;

      Resource        := pRestRequest_Resource;
      Method          := pRestRequest_Method;

      if pRestRequest_Body <> '' then
        AddBody(pRestRequest_body, ContentTypeFromString('application/json'));

      Execute;
    end;

    with RestResponse do
    begin
      RootElement := pRootElement; // só funciona para o nivel principal
    end;

    // ** Preenche o datasource e nao retorna pelo result, o que pode confundir
    with DataSource do
    begin
      DataSet := ClientDataSet;
    end;

    // ** Preenche o clientdataset e nao retorna pelo result, o que pode confundir
    with ClientDataSet do
    begin
      SetProvider(DataSetProvider);
      Open;
    end;
  Finally
    // Retorna apenas o JSON e retorno em clientdataset e datasource estao sendo preenchido logo acima e destacados com **
    Result := RESTResponse.JSONValue;

    { FIX-ME falta destruir os componentes, mas se destruo da excessão, estudar mais para futuramente corrigir esse codigo
    RestRequest.Free;
    RestResponse.Free;
    RESTResponseDataSetAdapter.Free;
    ClientDataSet.Free;
    DataSource.Free;}
  End;
end;

Function TEnviaRecebeDadosJson.EnviaRequisicaoAPI(Json: String;
                                                           strlist: string;
                                                           Metodo: TRESTRequestMethod;
                                                           FileJson: String;
                                                           DividirJson: Boolean = False;
                                                           rootElement: string = '';// só funciona para um nível
                                                           AtribuiMimeTypeJson: Boolean = False): TRetornos;// usado para trazer um root elemento dentro, em um terceiro nivel, ele trata manualmente, qualquer duvida acesse a função
var
  nJson, nJson64: string;
begin
  // Substituindo barras dulicadas // por /
  nJson := StringReplace(Json,'\\','\',[rfReplaceAll, rfIgnoreCase]);
  nJson := StringReplace(Json,'\/','/',[rfReplaceAll, rfIgnoreCase]);

  if FileJson <> '' then
  begin
    if AtribuiMimeTypeJson = True then
      nJson64 := StringReplace(nJson,'json_base64', 'data:application/pdf;base64,' + FileJson,[rfReplaceAll, rfIgnoreCase])
    else
      nJson64 := StringReplace(nJson,'json_base64', FileJson,[rfReplaceAll, rfIgnoreCase])
  end
  else
    nJson64 := nJson;

  FRetornos.rJsonEnvio := nJson;

  // Grava no TRetonos.rJsonEnvio a Url completa do envio
  FRetornos.rUrlEnvio  := FuncoesClient.Ler_StrListPar(StrListPar,'url',False) + // Extraindo a url da stringlist
                          strlist;// Recebendo o retorno da classe, devidamente organizada
                                  // Qualquer duvida olhar em resource_base.folders


  // Grava no TRetonos.rJsonRetorno a Url completa do retorno
  FRetornos.rJsonRetorno := CriaRestClient(FuncoesClient.Ler_StrListPar(StrListPar,'url',False), // extraindo a url da stringlist
                                           strlist, // Recebendo o retorno da classe, devidamente organizada
                                           nJson64, // Passando o Json devidamente tratado para o Body, caso nao haja Body, passar campo vazio ''
                                           Metodo,
                                           rootElement).ToString; // Define o metodo

  // Grava no TRetonos.rDataSource
  FRetornos.rDatasource := DataSource;
  // Grava no TRetonos.rClientDataSet
  FRetornos.rClientDataSet := ClientDataSet;

  // Se dividir Json for igual a true então vamos retirar o registro 0 porque é a soma
  // e repartir separar o que for > 1 em outro dataset.
  if DividirJson = True then
  begin
    FRetornos.rClientDataSetCabecalho := RetornaTotalJsonClientDataSet(FRetornos.rJsonRetorno);
  end;

  // Retornando o record prenchido
  Result := FRetornos;
end;

function TEnviaRecebeDadosJson.RetornaTotalJsonClientDataSet(TextoPadrao: string): TClientDataSet;
var
  vRetorno: TPosicaoCaractereTexto;
  ClientDataSetPadrao : TClientDataSet;
begin
  // Validando Json
  ClientDataSetPadrao := TClientDataSet.Create(nil);
  if FuncoesClient.ConverterDataSet(Copy(TextoPadrao,vRetorno.inicio, vRetorno.fim-1),
                                    ClientDataSetPadrao) <> nil then
  begin
    Result := ClientDataSetPadrao;
  End
  else
  begin
    Result := nil;
  end;
end;

end.
