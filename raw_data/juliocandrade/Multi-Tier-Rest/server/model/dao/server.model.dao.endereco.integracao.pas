unit server.model.dao.endereco.integracao;

interface
uses
  server.model.dao.interfaces,
  server.model.entity.endereco.Integracao,
  server.model.resource.interfaces;
type
  TDAOEnderecoIntegracao = class(TInterfacedObject, iDAOEnderecoIntegracao)
  private
    FParent : TModelEnderecoIntegracao;
    FResourceFactory : iResourceFactory;
  public
    constructor Create(aParent : TModelEnderecoIntegracao);
    class function New(aParent : TModelEnderecoIntegracao) : iDAOEnderecoIntegracao;
    function Inserir : iDAOEnderecoIntegracao; overload;
    function Inserir(aConexao : iConexao) : iDAOEnderecoIntegracao; overload;
    function Alterar : iDAOEnderecoIntegracao; overload;
    function Alterar(aConexao : iConexao) : iDAOEnderecoIntegracao; overload;
    function DatasetToEntity(AEnderecoIntegracao : TModelEnderecoIntegracao; aQuery : iQuery) : iDAOEnderecoIntegracao;
  end;

implementation

uses
  server.model.resource.factory,
  server.utils;

{ TDAOEnderecoIntegracao }

function TDAOEnderecoIntegracao.Alterar(aConexao: iConexao): iDAOEnderecoIntegracao;
var
  LQueryEnderecoIntegracao : iQuery;
begin
  Result := Self;
  LQueryEnderecoIntegracao := FResourceFactory.Query(aConexao);
  LQueryEnderecoIntegracao.SQL.Add('UPDATE endereco_integracao SET dsuf = :dsuf, ');
  LQueryEnderecoIntegracao.SQL.Add('nmcidade = :nmcidade, nmbairro = :nmbairro, ');
  LQueryEnderecoIntegracao.SQL.Add('nllogradouro = :nllogradouro, dscomplemento = :dscomplemento ');
  LQueryEnderecoIntegracao.SQL.Add('WHERE idendereco = :idendereco ');
  LQueryEnderecoIntegracao.SQL.Add('RETURNING *');

  LQueryEnderecoIntegracao.Params.ParamByName('idendereco').AsLargeInt := FParent.IDEndereco;
  LQueryEnderecoIntegracao.Params.ParamByName('dsuf').AsString := FParent.UF;
  LQueryEnderecoIntegracao.Params.ParamByName('nmcidade').AsString := FParent.Cidade;
  LQueryEnderecoIntegracao.Params.ParamByName('nmbairro').AsString := FParent.Bairro;
  LQueryEnderecoIntegracao.Params.ParamByName('nllogradouro').AsString := FParent.Logradouro;
  LQueryEnderecoIntegracao.Params.ParamByName('dscomplemento').AsString := FParent.Complemento;
  LQueryEnderecoIntegracao.Open;
  DatasetToEntity(FParent, LQueryEnderecoIntegracao);
end;

constructor TDAOEnderecoIntegracao.Create(aParent: TModelEnderecoIntegracao);
begin
  FParent := aParent;
  FResourceFactory := TResourceFactory.New;
end;

function  TDAOEnderecoIntegracao.DatasetToEntity(
  AEnderecoIntegracao: TModelEnderecoIntegracao; aQuery: iQuery) : iDAOEnderecoIntegracao;
begin
  AEnderecoIntegracao.IDEndereco := aQuery.DataSet.FieldByName('idendereco').AsLargeInt;
  AEnderecoIntegracao.UF := aQuery.DataSet.FieldByName('dsuf').AsString;
  AEnderecoIntegracao.Cidade := aQuery.DataSet.FieldByName('nmcidade').AsString;
  AEnderecoIntegracao.Bairro := aQuery.DataSet.FieldByName('nmbairro').AsString;
  AEnderecoIntegracao.Logradouro := aQuery.DataSet.FieldByName('nllogradouro').AsString;
  AEnderecoIntegracao.Complemento := aQuery.DataSet.FieldByName('dscomplemento').AsString;
end;

function TDAOEnderecoIntegracao.Inserir: iDAOEnderecoIntegracao;
var
  LConexao : iConexao;
  LQueryEnderecoIntegracao : iQuery;
begin
  Result := Self;
  LConexao := FResourceFactory.Conexao;
  LQueryEnderecoIntegracao := FResourceFactory.Query(LConexao);
  Inserir(LConexao);
end;

function TDAOEnderecoIntegracao.Inserir(aConexao: iConexao): iDAOEnderecoIntegracao;
var
  LQueryEnderecoIntegracao : iQuery;
begin
  LQueryEnderecoIntegracao := FResourceFactory.Query(aConexao);
  LQueryEnderecoIntegracao.SQL.Add('INSERT INTO endereco_integracao (idendereco, dsuf, nmcidade, nmbairro, nllogradouro, dscomplemento) ');
  LQueryEnderecoIntegracao.SQL.Add('VALUES (:idendereco, :dsuf, :nmcidade, :nmbairro, :nllogradouro, :dscomplemento) ');
  LQueryEnderecoIntegracao.SQL.Add('RETURNING *');
  LQueryEnderecoIntegracao.Params.ParamByName('idendereco').AsInteger := FParent.IDEndereco;
  LQueryEnderecoIntegracao.Params.ParamByName('dsuf').AsString := FParent.UF;
  LQueryEnderecoIntegracao.Params.ParamByName('nmcidade').AsString := FParent.Cidade;
  LQueryEnderecoIntegracao.Params.ParamByName('nmbairro').AsString := FParent.Bairro;
  LQueryEnderecoIntegracao.Params.ParamByName('nllogradouro').AsString := FParent.Logradouro;
  LQueryEnderecoIntegracao.Params.ParamByName('dscomplemento').AsString := FParent.Complemento;
  LQueryEnderecoIntegracao.Open;
  DatasetToEntity(FParent, LQueryEnderecoIntegracao);
end;

function TDAOEnderecoIntegracao.Alterar: iDAOEnderecoIntegracao;
var
  LConexao : iConexao;
  LQueryEnderecoIntegracao : iQuery;
begin
  Result := Self;
  LConexao := FResourceFactory.Conexao;
  LQueryEnderecoIntegracao := FResourceFactory.Query(LConexao);
  Alterar(LConexao);
end;

class function TDAOEnderecoIntegracao.New(
  aParent: TModelEnderecoIntegracao): iDAOEnderecoIntegracao;
begin
  Result := Self.Create(aParent);
end;

end.
