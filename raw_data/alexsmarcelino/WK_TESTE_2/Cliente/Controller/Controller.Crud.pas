unit Controller.Crud;

interface

uses
  REST.Types, REST.Response.Adapter, System.JSON, Data.DB, System.SysUtils,
  Dm.Dados;

type
  TControllerCrud = class
  private
    procedure JsonToDataSet(aDataSet: TDataSet; aJson: String);
  public
    function Selecao(aDataSet: TDataSet; var Msg: String): Boolean;
    function Inserir(PriNome, SegNome, Doc, Nat, Cep: String; var Msg: String): Boolean;
    function Excluir(IdPessoa: Integer; var Msg: String): Boolean;
    function Editar(IdPessoa: Integer; PriNome, SegNome, Doc, Nat, Cep: String; var Msg: String): Boolean;
    function AtualizarEndereco(IdEndereco: Integer; Cep: String; var Msg: String): Boolean;
  end;

implementation

const
  UriAPI: String = 'http://localhost:8080/datasnap/rest/TsmGeral/';

{ TControllerCrud }

function TControllerCrud.AtualizarEndereco(IdEndereco: Integer; Cep: String; var Msg: String): Boolean;
var
  CodHttp: Integer;
  Response: String;
begin
  Response := dmDados.RESTReqHTTP(UriAPI + 'AtualizarEndereco' + '/' +
    IdEndereco.ToString + '/' + Cep,'','',rmGET,CodHttp);
  if CodHttp = 200 then
  begin
    Result := True;
    Msg := 'Atualização de endereço realizada com sucesso.';
  end else
  begin
    Result := False;
    Msg := Response;
  end;
end;

function TControllerCrud.Editar(IdPessoa: Integer; PriNome, SegNome, Doc, Nat, Cep: String; var Msg: String): Boolean;
var
  CodHttp: Integer;
  Response: String;
  ObjPessoa: TJSONObject;
begin
  try
    ObjPessoa := TJSONObject.Create;
    ObjPessoa.AddPair('Idpessoa',IdPessoa);
    ObjPessoa.AddPair('Primeironome',PriNome);
    ObjPessoa.AddPair('Segundonome',SegNome);
    ObjPessoa.AddPair('Natureza',Nat);
    ObjPessoa.AddPair('Documento',Doc);
    ObjPessoa.AddPair('Cep',Cep);
    Response := dmDados.RESTReqHTTP(UriAPI + 'Editar',ObjPessoa.ToString,'',rmPUT,CodHttp);
    if CodHttp = 200 then
    begin
      Result := True;
      Msg := 'Edição realizada com sucesso.';
    end else
    begin
      Result := False;
      Msg := Response;
    end;
  finally
    FreeAndNil(ObjPessoa);
  end;
end;

function TControllerCrud.Excluir(IdPessoa: Integer; var Msg: String): Boolean;
var
  CodHttp: Integer;
  Response: String;
begin
  Response := dmDados.RESTReqHTTP(UriAPI + 'Excluir' + '/' + IdPessoa.ToString,'','',rmDELETE,CodHttp);
  if CodHttp = 200 then
  begin
    Result := True;
    Msg := 'Exclusão realizada com sucesso.';
  end else
  begin
    Result := False;
    Msg := Response;
  end;
end;

function TControllerCrud.Inserir(PriNome, SegNome, Doc, Nat, Cep: String; var Msg: String): Boolean;
var
  CodHttp: Integer;
  Response: String;
  ObjPessoa: TJSONObject;
begin
  try
    ObjPessoa := TJSONObject.Create;
    ObjPessoa.AddPair('Idpessoa','0');
    ObjPessoa.AddPair('Primeironome',PriNome);
    ObjPessoa.AddPair('Segundonome',SegNome);
    ObjPessoa.AddPair('Natureza',Nat);
    ObjPessoa.AddPair('Documento',Doc);
    ObjPessoa.AddPair('Cep',Cep);
    Response := dmDados.RESTReqHTTP(UriAPI + 'Inserir',ObjPessoa.ToString,'',rmPOST,CodHttp);
    if CodHttp = 200 then
    begin
      Result := True;
      Msg := 'Inclusão realizada com sucesso.';
    end else
    begin
      Result := False;
      Msg := Response;
    end;
  finally
    FreeAndNil(ObjPessoa);
  end;
end;

procedure TControllerCrud.JsonToDataSet(aDataSet: TDataSet; aJson: String);
var
  JObj: TJSONArray;
  vConv : TCustomJSONDataSetAdapter;
begin
  if (aJSON = EmptyStr) then
  begin
    Exit;
  end;
  JObj := TJSONObject.ParseJSONValue(aJSON) as TJSONArray;
  vConv := TCustomJSONDataSetAdapter.Create(Nil);
  try
    vConv.Dataset := aDataset;
    vConv.UpdateDataSet(JObj);
  finally
    vConv.Free;
    JObj.Free;
  end;
end;

function TControllerCrud.Selecao(aDataSet: TDataSet; var Msg: String): Boolean;
var
  CodHttp: Integer;
  Response: String;
begin
  Result := True;
  Response := dmDados.RESTReqHTTP(UriAPI + 'Selecao','','',rmGEt,CodHttp);
  if CodHttp = 200 then
    JsonToDataSet(aDataSet,Response)
  else begin
    Result := False;
    Msg := 'Servidor não está respondendo ou não está ativo.';
  end;
end;

end.
