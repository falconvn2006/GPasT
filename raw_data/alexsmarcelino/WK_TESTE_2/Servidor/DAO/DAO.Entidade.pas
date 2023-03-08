unit DAO.Entidade;

interface

uses
  Data.DB, DAO.Conexao, DAO.ConexaoFactory;

type
  TEntidadePessoa = class(TInterfacedObject,IEntidade)
  private
    FQuery: IQuery;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IEntidade;
    function DataSet(aValue: TDataSource): IEntidade;
    procedure Open;
    procedure ExecSQL(aSQL: String);
  end;

implementation

uses
  System.Classes, System.SysUtils;

{ TEntidadeProduto }

constructor TEntidadePessoa.Create;
begin
  FQuery := TConexaoFactory.New.Query;
end;

function TEntidadePessoa.DataSet(aValue: TDataSource): IEntidade;
begin
  Result := Self;
  aValue.DataSet := TDataSet(FQuery.Query);
end;

destructor TEntidadePessoa.Destroy;
begin
  inherited;
end;

procedure TEntidadePessoa.ExecSQL(aSQL: String);
begin
  FQuery.ExecSQL(aSQL);
end;

class function TEntidadePessoa.New: IEntidade;
begin
  Result := Self.Create;
end;

procedure TEntidadePessoa.Open;
var
  SQL: TStringBuilder;
begin
  SQL := TStringBuilder.Create('SELECT').
         Append('  P.IDPESSOA,').
         Append('  P.NMPRIMEIRO,').
         Append('  P.NMSEGUNDO,').
         Append('  P.FLNATUREZA,').
         Append('  P.DSDOCUMENTO,').
         Append('  P.DTREGISTRO,').
         Append('  E.IDENDERECO,').
         Append('  E.DSCEP,').
         Append('  I.NMLOGRADOURO,').
         Append('  I.NMBAIRRO,').
         Append('  I.NMCIDADE,').
         Append('  I.DSUF,').
         Append('  I.DSCOMPLEMENTO ').
         Append('FROM PESSOA P ').
         Append('LEFT JOIN ENDERECO E ON (E.IDPESSOA = P.IDPESSOA) ').
         Append('LEFT JOIN ENDERECO_INTEGRACAO I ON (I.IDENDERECO = E.IDENDERECO) ').
         Append('ORDER BY P.IDPESSOA');
  FQuery.Open(SQL.ToString);
end;

end.
