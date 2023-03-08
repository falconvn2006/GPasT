unit Manager.Usuario;

interface

uses
  Manager.Interfaces, DTO.Usuario, FireDAC.Comp.Client, FireDAC.Stan.Param,
  Manager.Types, System.TypInfo, System.SysUtils, Vcl.Dialogs,
  Controle.Caixa.Model.Connection, Controle.Caixa.Model.Connection.Interfaces,
  Data.DB, System.Generics.Collections, Bcrypt;

type
  tpColumn = (ID, NOME, SENHA, ADMIN);

  TManagerUsuario = class(TInterfacedObject, iManager<TUsuario>)
  private
    FSQL: string;
    FUsuario: TUsuario;
    FListUsuario: TObjectList<TUsuario>;
    FDataSet: TFDQuery;
    FDataSource: TDataSource;
    FConnection: iConnection;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iManager<TUsuario>;
    function This: TUsuario;
    procedure Save(aObject: TUsuario);
    procedure Update(aObject: TUsuario);
    procedure Remove(aObject: TUsuario); overload;
    procedure Remove(ID: Integer); overload;
    function DataSource: TDataSource;
    function UniqueResult: TUsuario;
    function ResultLastInsert: TUsuario;
    function List: TObjectList<TUsuario>;
    function FindAll: iManager<TUsuario>;
    function FindByID(ID: Integer): TUsuario;
    function Where(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<TUsuario>;
    function _And(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<TUsuario>;
    function _Or(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<TUsuario>;
    function Sum(Column: string): iManager<TUsuario>;
    function Count: Integer;
    function OrderBy(Column: string; Direction: tpOrderDirection = tpOrderDirection.Asc): iManager<TUsuario>;
  end;

implementation

{ TManagerUsuario }

function TManagerUsuario.Count: Integer;
begin
  Result := FDataSet.RecordCount;
end;

constructor TManagerUsuario.Create;
begin
  FUsuario := TUsuario.Create;
  FConnection := TModelConnection.New;
  FDataSet := TFDQuery.Create(nil);
  FDataSource := TDataSource.Create(nil);
  FDataSet.Connection := FConnection.Connection;
end;

function TManagerUsuario.DataSource: TDataSource;
begin
  FDataSet.Close;
  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.Open;
  FDataSource.DataSet := FDataSet;
  Result := FDataSource;
end;

destructor TManagerUsuario.Destroy;
begin
  FreeAndNil(FUsuario);
  FreeAndNil(FDataSet);
  FreeAndNil(FDataSource);
  inherited;
end;

function TManagerUsuario.List: TObjectList<TUsuario>;
begin
  FSQL := 'SELECT id as ID, nome as NOME, senha as SENHA,' + ' adm as ADMINISTRADOR FROM USUARIOS';
  FDataSet.Close;
  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.Open;
  FListUsuario.Create;

  while not FDataSet.Eof do
  begin
    FUsuario.ID(FDataSet.FieldByName('ID').AsInteger).NOME(FDataSet.FieldByName('NOME').AsString).SENHA(FDataSet.FieldByName('SENHA').AsString).ADMIN(FDataSet.FieldByName('ADMINISTRADOR').AsInteger);

    FListUsuario.Add(FUsuario);
  end;
  Result := FListUsuario;
end;

function TManagerUsuario.FindAll: iManager<TUsuario>;
begin
  FSQL := 'SELECT id as ID, nome as NOME, senha as SENHA,' + ' adm as ADMINISTRADOR FROM USUARIOS';

  Result := Self;
end;

function TManagerUsuario.FindByID(ID: Integer): TUsuario;
begin
  FSQL := 'SELECT id as ID, nome as NOME, senha as SENHA,' + ' adm as ADMINISTRADOR FROM USUARIOS WHERE id = ' + ID.ToString;
  FDataSet.Close;
  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.Open;
  FUsuario.ID(FDataSet.FieldByName('ID').AsInteger).NOME(FDataSet.FieldByName('NOME').AsString).SENHA(FDataSet.FieldByName('SENHA').AsString).ADMIN(FDataSet.FieldByName('ADMINISTRADOR').AsInteger);

  Result := FUsuario;
end;

class function TManagerUsuario.New: iManager<TUsuario>;
begin
  Result := Self.Create;
end;

function TManagerUsuario.OrderBy(Column: string; Direction: tpOrderDirection): iManager<TUsuario>;
begin
  case Direction of
    Asc:
      FSQL := FSQL + ' ORDER BY ' + Column + ' ASC';
    Desc:
      FSQL := FSQL + ' ORDER BY ' + Column + ' DESC';
  end;
  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.Open;
  Result := Self;
end;

procedure TManagerUsuario.Remove(aObject: TUsuario);
begin
  try
    FSQL := 'DELETE FROM usuarios WHERE ID = ' + aObject.ID.ToString;

    FDataSet.Close;
    FDataSet.SQL.Clear;
    FDataSet.SQL.Add(FSQL);
    FDataSet.ExecSQL;
  except
    on E: Exception do
      ShowMessage('Erro ao remover usuario: ' + E.Message);
  end;
end;

procedure TManagerUsuario.Remove(ID: Integer);
begin
  try
    FSQL := 'DELETE FROM usuarios WHERE ID = ' + ID.ToString;

    FDataSet.Close;
    FDataSet.SQL.Clear;
    FDataSet.SQL.Add(FSQL);
    FDataSet.ExecSQL;
  except
    on E: Exception do
      ShowMessage('Erro ao remover usuario: ' + E.Message);
  end;
end;

function TManagerUsuario.ResultLastInsert: TUsuario;
begin
  FDataSet.Close;
  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.Open;
  FDataSet.Last;
  FUsuario.ID(FDataSet.FieldByName('ID').AsInteger).NOME(FDataSet.FieldByName('NOME').AsString).SENHA(FDataSet.FieldByName('SENHA').AsString).ADMIN(FDataSet.FieldByName('ADMINISTRADOR').AsInteger);

  Result := FUsuario;
end;

procedure TManagerUsuario.Save(aObject: TUsuario);
begin
  try
    FSQL := 'insert into usuarios value(null, :nome, :senha,:adm)';
    FDataSet.Close;
    FDataSet.SQL.Clear;
    FDataSet.SQL.Text := FSQL;
    FDataSet.ParamByName('nome').Value := aObject.NOME;
    FDataSet.ParamByName('senha').Value := TBCrypt.HashPassword(aObject.SENHA);
    FDataSet.ParamByName('adm').Value := aObject.ADMIN;
    FDataSet.ExecSQL;
  except
    on E: Exception do
      ShowMessage('Erro ao inserir usuario: ' + E.Message);
  end;
end;

function TManagerUsuario.Sum(Column: string): iManager<TUsuario>;
begin
//
end;

function TManagerUsuario.This: TUsuario;
begin
  Result := FUsuario;
end;

function TManagerUsuario.UniqueResult: TUsuario;
begin
  FDataSet.Close;
  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.Open;
  FDataSet.First;
  FUsuario.ID(FDataSet.FieldByName('ID').AsInteger).NOME(FDataSet.FieldByName('NOME').AsString).SENHA(FDataSet.FieldByName('SENHA').AsString).ADMIN(FDataSet.FieldByName('ADMINISTRADOR').AsInteger);

  Result := FUsuario;
end;

procedure TManagerUsuario.Update(aObject: TUsuario);
begin
  try
    FDataSet.Close;

    if aObject.SENHA <> '' then
      FSQL := 'update usuarios set senha = :senha, nome = :nome, adm = :admin  where id = :id'
    else
      FSQL := 'update usuarios set nome = :nome, adm = :admin  where id = :id';

    FDataSet.SQL.Clear;
    FDataSet.SQL.Text := FSQL;
    FDataSet.ParamByName('id').Value := aObject.ID;
    FDataSet.ParamByName('nome').Value := aObject.NOME;
    if aObject.SENHA <> '' then
      FDataSet.ParamByName('senha').Value := TBCrypt.HashPassword(aObject.SENHA);
    FDataSet.ParamByName('admin').Value := aObject.ADMIN;
    FDataSet.ExecSQL;

  except
    on E: Exception do
      ShowMessage('Erro ao atualizar usuario: ' + E.Message);
  end;
end;

function TManagerUsuario.Where(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<TUsuario>;
var
  aTpColumn: tpColumn;
  vExpression, vOperator: string;
begin
  aTpColumn := tpColumn(GetEnumValue(TypeInfo(tpColumn), Column));

  case FilterOperator of
    Eq:
      vOperator := ' = ';
    GreaterThan:
      vOperator := ' > ';
    GreaterOrEqual:
      vOperator := ' >= ';
    LessThan:
      vOperator := ' < ';
    LessOrEqual:
      vOperator := ' <= ';
    Like:
      vOperator := ' LIKE ';
    Different:
      vOperator := ' != ';
    Between:
      vOperator := ' BETWEEN ';
  end;

  case aTpColumn of
    ID:
      begin
        vExpression := 'ID' + vOperator + QuotedStr(string(aValue));
      end;

    NOME:
      begin
        vExpression := 'nome' + vOperator + QuotedStr(string(aValue));
      end;
    SENHA:
      begin
        vExpression := 'senha' + vOperator + QuotedStr(string(aValue));
      end;
    ADMIN:
      begin
        vExpression := 'adm' + vOperator + QuotedStr(string(aValue));
      end;
  end;

  FSQL := FSQL + ' WHERE ' + vExpression;
  Result := Self;
end;

function TManagerUsuario._And(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<TUsuario>;
var
  aTpColumn: tpColumn;
  vExpression, vOperator: string;
begin
  aTpColumn := tpColumn(GetEnumValue(TypeInfo(tpColumn), Column));

  case FilterOperator of
    Eq:
      vOperator := ' = ';
    GreaterThan:
      vOperator := ' > ';
    GreaterOrEqual:
      vOperator := ' >= ';
    LessThan:
      vOperator := ' < ';
    LessOrEqual:
      vOperator := ' <= ';
    Like:
      vOperator := ' LIKE ';
    Different:
      vOperator := ' != ';
    Between:
      vOperator := ' BETWEEN ';
  end;

  case aTpColumn of
    ID:
      begin
        vExpression := 'ID' + vOperator + string(aValue);
      end;

    NOME:
      begin
        vExpression := 'nome' + vOperator + string(aValue);
      end;
    SENHA:
      begin
        vExpression := 'senha' + vOperator + string(aValue);
      end;
    ADMIN:
      begin
        vExpression := 'adm' + vOperator + string(aValue);
      end;
  end;

  FSQL := FSQL + ' AND ' + vExpression;
  Result := Self;
end;

function TManagerUsuario._Or(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<TUsuario>;
var
  aTpColumn: tpColumn;
  vExpression, vOperator: string;
begin
  aTpColumn := tpColumn(GetEnumValue(TypeInfo(tpColumn), Column));

  case FilterOperator of
    Eq:
      vOperator := ' = ';
    GreaterThan:
      vOperator := ' > ';
    GreaterOrEqual:
      vOperator := ' >= ';
    LessThan:
      vOperator := ' < ';
    LessOrEqual:
      vOperator := ' <= ';
    Like:
      vOperator := ' LIKE ';
    Different:
      vOperator := ' != ';
    Between:
      vOperator := ' BETWEEN ';
  end;

  case aTpColumn of
    ID:
      begin
        vExpression := 'ID' + vOperator + string(aValue);
      end;

    NOME:
      begin
        vExpression := 'nome' + vOperator + string(aValue);
      end;
    SENHA:
      begin
        vExpression := 'senha' + vOperator + string(aValue);
      end;
    ADMIN:
      begin
        vExpression := 'adm' + vOperator + string(aValue);
      end;
  end;

  FSQL := FSQL + ' OR ' + vExpression;
  Result := Self;
end;

end.

