unit client.model.dao.pessoa;

interface

uses
  client.model.dao.Interfaces,
  client.model.entity.pessoa,
  System.Generics.Collections,
  System.JSON;
type
  TDAOPessoa = class(TInterfacedObject, iDAOPessoa)
  private
    function ObjectToJSONString(aPessoa : TModelPessoa) : string;
    function ListAsJSONArrayString(aList: TList<TModelPessoa>) : String;
    procedure RemoverCamposNaoUtilizados(aJSONPessoa : TJSONObject);
  public
    class function New : iDAOPessoa;
    function Inserir(aPessoa :TModelPessoa) : iDAOPessoa;
    function Excluir(aID : Int64) : iDaoPessoa;
    function Alterar(aPessoa :TModelPessoa) : iDaoPessoa;
    function InserirLote(aList: TList<TModelPessoa>) : iDAOPessoa;
  end;
implementation

uses
  client.model.resource.interfaces,
  client.model.resource.factory,
  System.SysUtils,
  REST.JSON;

{ TDAOPessoa }

function TDAOPessoa.Alterar(aPessoa :TModelPessoa) : iDaoPessoa;
begin
  Result := Self;
  TResourceFactory.New.Rest
    .Params
      .EndPoint(Format('pessoas/%d', [aPessoa.ID]))
      .Body(ObjectToJSONString(aPessoa))
    .&End
  .Put;
end;

function TDAOPessoa.Excluir(aID : Int64) : iDaoPessoa;
begin
  Result := Self;
  TResourceFactory.New.Rest
    .Params
      .EndPoint(Format('pessoas/%d', [aID]))
    .&End
  .Delete;
end;

function TDAOPessoa.Inserir(aPessoa :TModelPessoa) : iDAOPessoa;
begin
  Result := Self;
  TResourceFactory.New.Rest
    .Params
      .EndPoint('pessoas')
      .Body(ObjectToJSONString(aPessoa))
    .&End
  .Post;
end;

function TDAOPessoa.InserirLote(aList: TList<TModelPessoa>): iDAOPessoa;
begin
  Result := Self;
  TResourceFactory.New.Rest
    .Params
      .EndPoint('pessoas/lote')
      .Body(ListAsJSONArrayString(aList))
    .&End
  .Post;
end;

function TDAOPessoa.ListAsJSONArrayString(aList: TList<TModelPessoa>): String;
var
  LJSONArray : TJSONArray;
  LJSONPessoa : TJSONObject;
  LPessoa : TModelPessoa;
begin
  Result := '[]';
  LJSONArray := TJSONArray.Create;
  try
    for LPessoa in aList do
    begin
      LJSONPessoa := TJSON.ObjectToJsonObject(LPessoa,[joIndentCaseLower]);
      RemoverCamposNaoUtilizados(LJSONPessoa);
      LJSONArray.AddElement(LJSONPessoa);
    end;
    Result := TJSON.JsonEncode(LJSONArray);
  finally
    LJSONArray.Free;
  end;
end;

class function TDAOPessoa.New: iDAOPessoa;
begin
  Result := Self.Create;
end;

function TDAOPessoa.ObjectToJSONString(aPessoa : TModelPessoa): string;
var
  LJSONPessoa : TJSONObject;
begin
  LJSONPessoa := TJSON.ObjectToJsonObject(aPessoa, [joIndentCaseLower]);
  try
    RemoverCamposNaoUtilizados(LJSONPessoa);
    Result := TJSON.JsonEncode(LJSONPessoa);
  finally
    LJSONPessoa.Free;
  end;
end;

procedure TDAOPessoa.RemoverCamposNaoUtilizados(aJSONPessoa: TJSONObject);
var
  LJSONEndereco : TJSONObject;
  LJSONEnderecoIntegracao : TJSONObject;
begin
  aJSONPessoa.RemovePair('id').Free;
  aJSONPessoa.RemovePair('dataregistro').Free;
  LJSONEndereco := aJSONPessoa.GetValue<TJSONObject>('endereco');
  LJSONEndereco.RemovePair('idpessoa').Free;
  LJSONEndereco.RemovePair('idendereco').Free;
  LJSONEnderecoIntegracao := aJSONPessoa.GetValue<TJSONObject>('enderecointegracao');
  LJSONEnderecoIntegracao.RemovePair('idendereco').Free;
end;

end.
