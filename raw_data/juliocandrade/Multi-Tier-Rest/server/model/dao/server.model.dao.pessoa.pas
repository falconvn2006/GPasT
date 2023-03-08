unit server.model.dao.pessoa;
interface
uses
  System.Generics.Collections,
  System.Classes,
  server.model.dao.interfaces,
  server.model.entity.pessoa,
  server.model.resource.interfaces;
type
  TDAOPessoa = class(TInterfacedObject, iDAOPessoa)
  private
    FList : TObjectList<TModelPessoa>;
    FResourceFactory : iResourceFactory;
    procedure DatasetToList(aQuery : iQuery);
    procedure DatasetToEntity(APessoa : TModelPessoa; aQuery : iQuery);
    procedure SQLPessoa(SQL : TStrings);
  public
    constructor Create;
    destructor Destroy; override;
    class function New : iDAOPessoa;
    function ListarTodos : iDAOPessoa;
    function ListarPorID(aPessoa : TModelPessoa) : iDAOPessoa;
    function Inserir(aPessoa : TModelPessoa) : iDAOPessoa;
    function Excluir(ID : Int64) : iDaoPessoa;
    function Alterar(aPessoa : TModelPessoa) : iDaoPessoa;
    function List : TObjectList<TModelPessoa>;
    function IsEmpty : Boolean;
  end;
implementation
uses
  REST.Json,
  System.JSON,
  System.SysUtils,
  server.model.resource.factory,
  server.model.dao.endereco,
  server.model.dao.endereco.integracao;
{ TDAOPessoa }
function TDAOPessoa.Alterar(aPessoa : TModelPessoa): iDaoPessoa;
var
  LConexao : iConexao;
  LQueryPessoa : iQuery;
  LDAOEndereco : iDAOEndereco;
  LDAOEnderecoIntegracao : iDAOEnderecoIntegracao;
begin
  Result := Self;
  LConexao := FResourceFactory.Conexao;
  LQueryPessoa := FResourceFactory.Query(LConexao);
  LDAOEndereco := TDAOEndereco.New(aPessoa.Endereco);
  LDAOEnderecoIntegracao := TDAOEnderecoIntegracao.New(aPessoa.EnderecoIntegracao);
  LQueryPessoa.SQL.Add('UPDATE pessoa SET flnatureza = :flnatureza, dsdocumento = :dsdocumento, ');
  LQueryPessoa.SQL.Add('nmprimeiro = :nmprimeiro, nmsegundo = :nmsegundo WHERE idpessoa = :idpessoa ');
  LQueryPessoa.SQL.Add('RETURNING *');
  LQueryPessoa.Params.ParamByName('flnatureza').AsInteger := aPessoa.Natureza;
  LQueryPessoa.Params.ParamByName('dsdocumento').AsString := aPessoa.Documento;
  LQueryPessoa.Params.ParamByName('nmprimeiro').AsString := aPessoa.PrimeiroNome;
  LQueryPessoa.Params.ParamByName('nmsegundo').AsString := aPessoa.SegundoNome;
  LQueryPessoa.Params.ParamByName('idpessoa').AsLargeInt := aPessoa.ID;
  LConexao.StartTransaction;
  try
    LQueryPessoa.Open;
    aPessoa.Endereco.IDPessoa := aPessoa.ID;
    LDAOEndereco.Alterar(LConexao);
    aPessoa.EnderecoIntegracao.IDEndereco := aPessoa.Endereco.IDEndereco;
    LDAOEnderecoIntegracao.Alterar(LConexao);
    LConexao.Commit;
  except
    LConexao.Rollback;
    raise;
  end;
end;
constructor TDAOPessoa.Create;
begin
  FList :=TObjectList<TModelPessoa>.Create;
  FResourceFactory := TResourceFactory.New;
end;
procedure TDAOPessoa.DatasetToEntity(APessoa : TModelPessoa; aQuery : iQuery);
begin
    APessoa.ID := aQuery.Dataset.FieldByName('idpessoa').AsLargeInt;
    APessoa.Natureza := aQuery.Dataset.FieldByName('flnatureza').AsInteger;
    APessoa.Documento := aQuery.Dataset.FieldByName('dsdocumento').AsString;
    APessoa.PrimeiroNome := aQuery.Dataset.FieldByName('nmprimeiro').AsString;
    APessoa.SegundoNome := aQuery.Dataset.FieldByName('nmsegundo').AsString;
    APessoa.DataRegistro := aQuery.Dataset.FieldByName('dtregistro').AsDateTime;
    TDAOEndereco.New(aPessoa.Endereco).DatasetToEntity(aPessoa.Endereco, aQuery);
    TDAOEnderecoIntegracao.New(aPessoa.EnderecoIntegracao).DatasetToEntity(aPessoa.EnderecoIntegracao, aQuery);
end;
procedure TDAOPessoa.DatasetToList(aQuery : iQuery);
var
  I: Integer;
  LPessoa : TModelPessoa;
begin
  Flist.Clear;
  aQuery.DataSet.First;
  for I := 0 to Pred(aQuery.Dataset.RecordCount) do
  begin
    LPessoa := TModelPessoa.Create;
    DatasetToEntity(LPessoa, aQuery);
    FList.Add(LPessoa);
    aQuery.Dataset.Next;
  end;
end;
destructor TDAOPessoa.Destroy;
begin
  Flist.free;
  inherited;
end;

function TDAOPessoa.Excluir(ID : Int64): iDaoPessoa;
var
  LConexao : iConexao;
  LQueryPessoa : iQuery;
begin
  Result := Self;
  LConexao := FResourceFactory.Conexao;
  LQueryPessoa := FResourceFactory.Query(LConexao);
  LQueryPessoa.SQL.Add('DELETE FROM pessoa WHERE idpessoa = :idpessoa');
  LQueryPessoa.Params.ParamByName('idpessoa').AsLargeInt := ID;
  LQueryPessoa.ExecSQL;
end;
function TDAOPessoa.Inserir(aPessoa : TModelPessoa): iDAOPessoa;
var
  LConexao : iConexao;
  LQueryPessoa : iQuery;
  LDAOEndereco : iDAOEndereco;
  LDAOEnderecoIntegracao : iDAOEnderecoIntegracao;
begin
  Result := Self;
  LConexao := FResourceFactory.Conexao;
  LQueryPessoa := FResourceFactory.Query(LConexao);
  LDAOEndereco := TDAOEndereco.New(aPessoa.Endereco);
  LDAOEnderecoIntegracao := TDAOEnderecoIntegracao.New(aPessoa.EnderecoIntegracao);
  LQueryPessoa.SQL.Add('INSERT INTO pessoa (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) ');
  LQueryPessoa.SQL.Add('VALUES (:flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, CURRENT_DATE) ');
  LQueryPessoa.SQL.Add('RETURNING *');
  LQueryPessoa.Params.ParamByName('flnatureza').AsInteger := aPessoa.Natureza;
  LQueryPessoa.Params.ParamByName('dsdocumento').AsString := aPessoa.Documento;
  LQueryPessoa.Params.ParamByName('nmprimeiro').AsString := aPessoa.PrimeiroNome;
  LQueryPessoa.Params.ParamByName('nmsegundo').AsString := aPessoa.SegundoNome;
  LConexao.StartTransaction;
  try
    LQueryPessoa.Open;
    aPessoa.ID := LQueryPessoa.DataSet.FieldByName('idpessoa').AsLargeInt;
    aPessoa.Endereco.IDPessoa := aPessoa.ID;
    LDAOEndereco.Inserir(LConexao);
    aPessoa.EnderecoIntegracao.IDEndereco := aPessoa.Endereco.IDEndereco;
    LDAOEnderecoIntegracao.Inserir(LConexao);
    LConexao.Commit;
  except
    LConexao.Rollback;
    raise;
  end;
  ListarPorID(aPessoa);
end;
function TDAOPessoa.IsEmpty: Boolean;
begin
  Result := FList.Count = 0;
end;
function TDAOPessoa.List: TObjectList<TModelPessoa>;
begin
  Result := FList;
end;

function TDAOPessoa.ListarPorID(aPessoa : TModelPessoa) : iDAOPessoa;
var
  LConexao : iConexao;
  LQuery : iQuery;
begin
  Result := Self;
  LConexao := FResourceFactory.Conexao;
  LQuery := FResourceFactory.Query(LConexao);
  SQLPessoa(LQuery.SQL);
  LQuery.SQL.Add(' WHERE p.idpessoa = :idpessoa');
  LQuery.Params.ParamByName('idpessoa').AsLargeInt := aPessoa.ID;
  LQuery.Open;
  DatasetToEntity(aPessoa, LQuery);
  DatasetToList(LQuery);
end;
function TDAOPessoa.ListarTodos: iDAOPessoa;
var
  LConexao : iConexao;
  LQuery : iQuery;
begin
  Result := Self;
  LConexao := FResourceFactory.Conexao;
  LQuery := FResourceFactory.Query(LConexao);
  SQLPessoa(LQuery.SQL);
  LQuery.SQL.Add(' ORDER BY p.idpessoa');
  LQuery.Open;
  DatasetToList(LQuery);
end;
class function TDAOPessoa.New : iDAOPessoa;
begin
  Result := Self.Create;
end;
procedure TDAOPessoa.SQLPessoa(SQL: TStrings);
begin
  SQL.Add('SELECT p.*, e.idendereco, e.idendereco, e.dscep, ');
  SQL.Add('ei.dsuf, ei.nmcidade, ei.nmbairro, ');
  SQL.Add('ei.nllogradouro, ei.dscomplemento FROM pessoa p ');
  SQL.Add('LEFT JOIN endereco e ON p.idpessoa = e.idpessoa ');
  SQL.Add('LEFT JOIN endereco_integracao ei ON e.idendereco = ei.idendereco');
end;
end.
