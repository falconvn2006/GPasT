unit server.model.dao.pessoa.lote;
interface
uses
  System.Generics.Collections,
  server.model.dao.interfaces,
  server.model.entity.pessoa,
  server.model.resource.interfaces,
  Data.DB;
type
  TDAOPessoaLote = class(TInterfacedObject, iDAOPessoaLote)
  private
    FList : TObjectList<TModelPessoa>;
    FResourceFactory : iResourceFactory;
    FConexao : iConexao;
    FQueryPessoa : iQuery;
    FQueryEndereco : iQuery;
    FQueryEnderecoIntegracao : iQuery;
    FParamsPessoa : TArray<TParams>;
    FParamsEndereco : TArray<TParams>;
    FParamsEnderecoIntegracao : TArray<TParams>;
    procedure GetIDs(aRange : Integer; var IDPessoa, IDEndereco : int64);
    procedure DimensionarArray(aCount : Integer);
    procedure AtribuirPessoa(aParam : TParams; aPessoa : TModelPessoa);
    procedure AtribuirEndereco(aParam : TParams; aPessoa : TModelPessoa);
    procedure AtribuirEnderecoIntegracao(aParam : TParams; aPessoa : TModelPessoa);
    procedure PrepareSQL;
    procedure ExecSQL;
  public
    constructor Create(aList : TObjectList<TModelPessoa>);
    destructor Destroy; override;
    class function New(aList : TObjectList<TModelPessoa>) : iDAOPessoaLote;
    function Inserir : iDAOPessoaLote;
  end;
implementation
uses
  server.model.resource.factory,
  System.SysUtils;
{ TDAOPessoaLote }
procedure TDAOPessoaLote.AtribuirEndereco(aParam: TParams;
  aPessoa: TModelPessoa);
begin
  aParam.Assign(FQueryEndereco.Params);
  aParam.ParamByName('idendereco').AsLargeInt := aPessoa.Endereco.IDEndereco;
  aParam.ParamByName('idpessoa').AsLargeInt := aPessoa.Endereco.idPessoa;
  aParam.ParamByName('dscep').AsString := aPessoa.Endereco.CEP;
end;

procedure TDAOPessoaLote.AtribuirEnderecoIntegracao(aParam: TParams;
  aPessoa: TModelPessoa);
begin
  aParam.Assign(FQueryEnderecoIntegracao.Params);
  aParam.ParamByName('idendereco').AsLargeInt := aPessoa.EnderecoIntegracao.IDEndereco;
  aParam.ParamByName('dsuf').AsString := aPessoa.EnderecoIntegracao.UF;
  aParam.ParamByName('nmcidade').AsString := aPessoa.EnderecoIntegracao.Cidade;
  aParam.ParamByName('nmbairro').AsString := aPessoa.EnderecoIntegracao.Bairro;
  aParam.ParamByName('nllogradouro').AsString := aPessoa.EnderecoIntegracao.Logradouro;
  aParam.ParamByName('dscomplemento').AsString := aPessoa.EnderecoIntegracao.Complemento;
end;

procedure TDAOPessoaLote.AtribuirPessoa(aParam: TParams; aPessoa: TModelPessoa);
begin
  aParam.Assign(FQueryPessoa.Params);
  aParam.ParamByName('idpessoa').AsLargeInt := aPessoa.ID;
  aParam.ParamByName('flnatureza').AsInteger := aPessoa.Natureza;
  aParam.ParamByName('dsdocumento').AsString := aPessoa.Documento;
  aParam.ParamByName('nmprimeiro').AsString := aPessoa.PrimeiroNome;
  aParam.ParamByName('nmsegundo').AsString := aPessoa.SegundoNome;
end;

constructor TDAOPessoaLote.Create(aList: TObjectList<TModelPessoa>);
begin
  FList := aList;
  FResourceFactory := TResourceFactory.New;
  FConexao := FResourceFactory.Conexao;
  FQueryPessoa := FResourceFactory.Query(FConexao);
  FQueryEndereco := FResourceFactory.Query(FConexao);
  FQueryEnderecoIntegracao := FResourceFactory.Query(FConexao);
end;
destructor TDAOPessoaLote.Destroy;
var
  I : Integer;
begin
  for I := 0 to pred(FList.Count) do
  begin
    FreeAndNil(FParamsPessoa[I]);
    FreeAndNil(FParamsEndereco[I]);
    FreeAndNil(FParamsEnderecoIntegracao[I]);
  end;
  finalize(FParamsPessoa);
  finalize(FParamsEndereco);
  finalize(FParamsEnderecoIntegracao);
  inherited;
end;

procedure TDAOPessoaLote.DimensionarArray(aCount: Integer);
begin
  SetLength(FParamsPessoa, aCount);
  SetLength(FParamsEndereco, aCount);
  SetLength(FParamsEnderecoIntegracao, aCount);
end;

procedure TDAOPessoaLote.ExecSQL;
begin
  FConexao.StartTransaction;
  try
    FQueryPessoa.ExecSQLArray(FParamsPessoa);
    FQueryEndereco.ExecSQLArray(FParamsEndereco);
    FQueryEnderecoIntegracao.ExecSQLArray(FParamsEnderecoIntegracao);
    FConexao.Commit;
  except
    FConexao.Rollback;
  end;
end;

procedure TDAOPessoaLote.GetIDs(aRange: Integer; var IDPessoa,
  IDEndereco: int64);
var
  LConexao : iConexao;
  LQueryID : iQuery;
begin
  LConexao := FResourceFactory.Conexao;
  LQueryID := FResourceFactory.Query(LConexao);
  LQueryID.SQL.Add(Format('SELECT setval(pg_get_serial_sequence(''pessoa'',''idpessoa''), Nextval(pg_get_serial_sequence(''pessoa'',''idpessoa'')) + %d, false) as idpessoa, ', [aRange]));
  LQueryID.SQL.Add(Format('setval(pg_get_serial_sequence(''pessoa'',''idpessoa''), Nextval(pg_get_serial_sequence(''pessoa'',''idpessoa'')) + %d, false) as idendereco', [aRange]));
  LQueryID.Open;
  IDPessoa := LQueryID.DataSet.FieldByName('idpessoa').AsLargeInt - aRange;
  IDEndereco := LQueryID.DataSet.FieldByName('idendereco').AsLargeInt - aRange;
end;

function TDAOPessoaLote.Inserir: iDaoPessoaLote;
var
  LIDPessoa : int64;
  LIDEndereco : int64;
  I : Integer;
begin
  Result := Self;
  PrepareSQL;
  DimensionarArray(FList.Count);
  GetIDs(FList.Count, LIDPessoa, LIDEndereco);
  for I := 0 to Pred(FList.Count) do
  begin
    FList[I].ID := LIDPessoa;
    FParamsPessoa[I] := TParams.Create(nil);
    AtribuirPessoa(FParamsPessoa[I], FList[I]);
    FList[I].Endereco.IDEndereco := LIDEndereco;
    FList[I].Endereco.idPessoa := LIDPessoa;
    FParamsEndereco[I] := TParams.Create(nil);
    AtribuirEndereco(FParamsEndereco[I], FList[I]);
    FList[I].EnderecoIntegracao.IDEndereco := LIDEndereco;
    FParamsEnderecoIntegracao[I] := TParams.Create(nil);
    AtribuirEnderecoIntegracao(FParamsEnderecoIntegracao[I], FList[I]);
    Inc(LIDPessoa);
    Inc(LIDEndereco);
  end;
  ExecSQL;
end;
class function TDAOPessoaLote.New(
  aList: TObjectList<TModelPessoa>): iDAOPessoaLote;
begin
  Result := Self.Create(aList);
end;
procedure TDAOPessoaLote.PrepareSQL;
begin
  FQueryPessoa.SQL.Add('INSERT INTO pessoa (idpessoa, flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro)');
  FQueryPessoa.SQL.Add('VALUES (:idpessoa, :flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, CURRENT_DATE) ');
  FQueryEndereco.SQL.Add('INSERT INTO endereco (idendereco, idpessoa , dscep) ');
  FQueryEndereco.SQL.Add('VALUES (:idendereco, :idpessoa, :dscep) ');
  FQueryEnderecoIntegracao.SQL.Add('INSERT INTO endereco_integracao (idendereco, dsuf, nmcidade, nmbairro, nllogradouro, dscomplemento) ');
  FQueryEnderecoIntegracao.SQL.Add('VALUES (:idendereco, :dsuf, :nmcidade, :nmbairro, :nllogradouro, :dscomplemento) ');
end;

end.
