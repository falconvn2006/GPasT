unit DAO.Query;

interface

uses
  DAO.Conexao, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client;

type
  TFireDacQuery = class(TInterfacedObject,IQuery)
  private
    FQuery: TFDQuery;
    FConexao: IConexao;
  public
    constructor Create(aValue: IConexao);
    destructor Destroy; override;
    class function New(aValue: IConexao): IQuery;
    function Query: TObject;
    function Open(aSQL: String): IQuery;
    function ExecSQL(aSQL: String): IQuery;
  end;

implementation

uses
  System.SysUtils;

{ IFireDacQuery }

constructor TFireDacQuery.Create(aValue: IConexao);
begin
  FConexao := aValue;
  FQuery := TFDQuery.Create(Nil);
  FQuery.Connection := TFDConnection(FConexao.Connection);
end;

destructor TFireDacQuery.Destroy;
begin
  FreeAndNil(FQuery);
  inherited;
end;

function TFireDacQuery.ExecSQL(aSQL: String): IQuery;
begin
  Result := Self;
  FQuery.ExecSQL(aSQL);
end;

class function TFireDacQuery.New(aValue: IConexao): IQuery;
begin
  Result := Self.Create(aValue);
end;

function TFireDacQuery.Open(aSQL: String): IQuery;
begin
  Result := Self;
  FQuery.Open(aSQL);
end;

function TFireDacQuery.Query: TObject;
begin
  Result := FQuery;
end;

end.
