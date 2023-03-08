unit Funcoes.client;

interface

uses
  System.Classes, DBXJSON, DBXJSONReflect,
  REST.Json.Types, REST.Json, REST.Types, System.JSON,
  System.IniFiles, Datasnap.DBClient,System.StrUtils,
  REST.Client, Data.DB;

type
  TRetornos = record
    rDatasource: TDataSource;
    rClientDataSet: TClientDataSet;
    rJsonEnvio : String;
    rUrlEnvio  : string;
    rJsonRetorno: string;
    rDatasourceCabecalho: TDataSource;
    rDatasourceItens    : TDataSource;
    rClientDataSetCabecalho    : TClientDataSet;
    rClientDataSetItens        : TClientDataSet;
    rClientDataSetItens2       : TClientDataSet;
  end;

type
  TPosicaoCaractereTexto = record
    inicio: integer;
    fim: integer;
  end;

type
  TAdapterJSONValue =  class(TInterfacedObject, IRESTResponseJSON)
  private
    FJSONValue: TJSONValue;
  protected
    { IRESTResponseJSON }
    procedure AddJSONChangedEvent(const ANotify: TNotifyEvent);
    procedure RemoveJSONChangedEvent(const ANotify: TNotifyEvent);
    procedure GetJSONResponse(out AJSONValue: TJSONValue; out AHasOwner: Boolean);
    function HasJSONResponse: Boolean;
    function HasResponseContent: Boolean;
  public
    constructor Create(const AJSONValue: TJSONValue);
    destructor Destroy; override;
  end;

type
  TFuncoesClient = class
  private

  public
    function ConverteStringToStrinList(ListaOrdenada: String): TStringList;
    function RetornaJson(classe: TObject;
                                    ObjetoSubstituto1: String  = '';
                                    ObjetoSubstituido1: string = '';
                                    ObjetoSubstituto2: string  = '';
                                    ObjetoSubstituido2: string = '';
                                    ObjetoSubstituto3: string  = '';
                                    ObjetoSubstituido3: string = ''): String;
    function RetiraAspaSimples(Texto: String): String;
    function Ler_StrListPar(Lista: TStringList;
                                       Nome: String;
                                       RetornaNome: Boolean = True): String;
    function RetornaIndexStringList(Lista: TStringList; Nome: String): Integer;
    function ConverterDataSet(Texto: string;
      Cds: TClientDataSet): TClientDataSet;
    procedure Add_StrListPar(Lista: TStringList; Nome, Valor: string);
    function RetornaStringList(Lista: TStringList;
                                          Nome: String;
                                          RetornaNome: Boolean = True): String;
    function RetiraEnterFinalFrase(Texto: string): String;
 end;

 var
  FuncoesClient: TFuncoesClient;


implementation

uses
  System.AnsiStrings, System.SysUtils, REST.Response.Adapter;

{ TFuncoesClient }

function TFuncoesClient.ConverteStringToStrinList(
  ListaOrdenada: String): TStringList;
var
  ConvertStringList: TStringList;
begin
  ConvertStringList := TStringList.Create;
  ConvertStringList.Values['strlist'] := ListaOrdenada;
  Result := ConvertStringList;
end;

// Converta o objeto da classe para json
function TFuncoesClient.RetornaJson(classe: TObject;
                                    ObjetoSubstituto1: String  = '';
                                    ObjetoSubstituido1: string = '';
                                    ObjetoSubstituto2: string  = '';
                                    ObjetoSubstituido2: string = '';
                                    ObjetoSubstituto3: string  = '';
                                    ObjetoSubstituido3: string = ''): String;
var
  TextoJson: string;
begin
  TextoJson := TJson.ObjectToJsonString(Classe);
  // Substituindo parametro 1
  if ObjetoSubstituto1 <> '' then
    // Substituindo o objetos do delphi
    TextoJson := StringReplace(TextoJson, ObjetoSubstituto1, ObjetoSubstituido1, [rfReplaceAll]);

  // Substituindo parametro 2
  if ObjetoSubstituto2 <> '' then
    TextoJson := StringReplace(TextoJson, ObjetoSubstituto2, ObjetoSubstituido2, [rfReplaceAll]);

  // Substituindo parametro 3
  if ObjetoSubstituto3 <> '' then
    TextoJson := StringReplace(TextoJson, ObjetoSubstituto3, ObjetoSubstituido3, [rfReplaceAll]);

  Result := TextoJson;
end;

Function TFuncoesClient.RetiraAspaSimples(Texto:String):String;
var
  n : Integer;
  NovoTexto : String;
begin
  NovoTexto := '';
  for n := 1 to length(texto) do
  begin
    if copy(texto, n,1) <> Chr(39) then
      NovoTexto := NovoTexto + copy(Texto, n,1)
    else
      NovoTexto := NovoTexto + ' ';
  end;
  Result:=NovoTexto;
end;

function TFuncoesClient.Ler_StrListPar(Lista: TStringList;
                                       Nome: String;
                                       RetornaNome: Boolean = True): String;
begin
  if RetornaNome = True then
    Result :=  Lista.Names[RetornaIndexStringList(Lista, Nome)] + '=' +  Lista.Values[Nome]
  else
    Result :=  Lista.Values[Nome];
end;

function TFuncoesClient.RetornaIndexStringList(Lista: TStringList;
                                               Nome: String): Integer;
var
  I: Integer;
begin
  for I := Lista.count - 1 downto 0 do
  begin
    if Trim(Lista.Names[I]) = Nome then
      Result := I;
  end;
end;

// Adicionando o name e value em uma stringlist
procedure TFuncoesClient.Add_StrListPar(Lista: TStringList;
                                         Nome : string;
                                         Valor: string);
begin
  With Lista do
  begin
    Values[Nome] := Valor;
  end;
end;

function TFuncoesClient.RetornaStringList(Lista: TStringList;
                                          Nome: String;
                                          RetornaNome: Boolean = True): String;
begin
  if RetornaNome = True then
    Result :=  Lista.Names[RetornaIndexStringList(Lista, Nome)] + '=' +  Lista.Values[Nome]
  else
    Result :=  Lista.Values[Nome];
end;

function TFuncoesClient.ConverterDataSet(Texto: string;
                                         Cds: TClientDataSet): TClientDataSet;
var
  LJSON: TJSONValue;
  LIntf: IRESTResponseJSON;
  RESTResponseDataSetAdapter1 : TRESTResponseDataSetAdapter;
begin
  Try
    RESTResponseDataSetAdapter1 := TRESTResponseDataSetAdapter.Create(nil);
    RESTResponseDataSetAdapter1.Dataset := Cds;

    // Clear last value
    RESTResponseDataSetAdapter1.ResponseJSON := nil;

    // Parse the JSON in our memo
    LJSON := TJSONObject.ParseJSONValue(Texto);
    if LJSON = nil then
    begin
      Result := nil;
      RESTResponseDataSetAdapter1.Free;
      Exit;
    end;

    // Provide the JSON value to the adapter
    LIntf := TAdapterJSONValue.Create(LJSON);
    RESTResponseDataSetAdapter1.ResponseJSON := LIntf;
    RESTResponseDataSetAdapter1.Active := True;

    Cds.Open;
    Result := Cds;
    RESTResponseDataSetAdapter1.Free;
  Except
    Result := nil;
  End;
end;

function TFuncoesClient.RetiraEnterFinalFrase(Texto: string): String;
var
  stringListLinha : TStringList;
  novaLinha: string;
  i: Integer;
begin
  // Retirando os ENTERs do final das linhas
  Try
    stringListLinha := TStringList.Create;

    // Carrega o arquivo em um stringlist
    stringListLinha.Text := Texto;

    // Varrendo todo o stringlist para retirar as quebras de linhas
    for i := 0 to (stringListLinha.Count -1) do
      novaLinha := novaLinha + stringListLinha.Strings[i];
  finally
    Result := novaLinha;
    stringListLinha.Free;
  end;
end;

{ TAdapterJSONValue }
procedure TAdapterJSONValue.AddJSONChangedEvent(const ANotify: TNotifyEvent);
begin

end;

constructor TAdapterJSONValue.Create(const AJSONValue: TJSONValue);
begin
  FJSONValue := AJSONValue;
end;

destructor TAdapterJSONValue.Destroy;
begin
  FJSONValue.Free;
  inherited;
end;

procedure TAdapterJSONValue.GetJSONResponse(out AJSONValue: TJSONValue;
  out AHasOwner: Boolean);
begin
  AJSONValue := FJSONValue;
  AHasOwner := True;
end;

function TAdapterJSONValue.HasJSONResponse: Boolean;
begin
  Result := FJSONValue <> nil;
end;

function TAdapterJSONValue.HasResponseContent: Boolean;
begin
  Result := FJSONValue <> nil;
end;

procedure TAdapterJSONValue.RemoveJSONChangedEvent(const ANotify: TNotifyEvent);
begin

end;


end.
