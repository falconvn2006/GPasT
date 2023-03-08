unit Manager.Caixa;

interface

uses
  Data.DB, DTO.Caixa, Manager.Types, Manager.Interfaces,
  System.Generics.Collections, FireDAC.Comp.Client, FireDAC.Stan.Param,
  Vcl.Dialogs, System.TypInfo, System.Variants, System.SysUtils,
  Controle.Caixa.Model.Connection.Interfaces, Controle.Caixa.Model.Connection,
  DTO.Usuario;

type
  tpColumn = (ID, TITULO, VALOR, DESCRICAO, DTENTRADA, DTATUALIZACAO, ENTRADA, USUARIO);

  TManagerCaixa = class(TInterfacedObject, iManager<TCaixa>)
  private
    FSQL: string;
    FCaixa: TCaixa;
    FUsuario: TUsuario;
    FListCaixa: TObjectList<TCaixa>;
    FDataSet: TFDQuery;
    FDataSource: TDataSource;
    FConnection: iConnection;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iManager<TCaixa>;
    function This: TCaixa;
    procedure Save(aObject: TCaixa);
    procedure Update(aObject: TCaixa);
    procedure Remove(aObject: TCaixa); overload;
    procedure Remove(ID: Integer); overload;
    function List: TObjectList<TCaixa>;
    function FindAll: iManager<TCaixa>;
    function FindByID(ID: Integer): TCaixa;
    function DataSource: TDataSource;
    function UniqueResult: TCaixa;
    function ResultLastInsert: TCaixa;
    function Where(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<TCaixa>;
    function _And(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<TCaixa>;
    function _Or(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<TCaixa>;
    function Sum(Column: string): iManager<TCaixa>;
    function Count: Integer;
    function OrderBy(Column: string; Direction: tpOrderDirection = tpOrderDirection.Asc): iManager<TCaixa>;
  end;

implementation

{ TManagerCaixa }

function TManagerCaixa.This: TCaixa;
begin
  Result := FCaixa;
end;

function TManagerCaixa.Count: Integer;
begin
  Result := FDataSet.RecordCount;
end;

constructor TManagerCaixa.Create;
begin
  FCaixa := TCaixa.Create;
  FUsuario := TUsuario.Create;
  FConnection := TModelConnection.New;
  FDataSet := TFDQuery.Create(nil);
  FDataSource := TDataSource.Create(nil);
  FDataSet.Connection := FConnection.Connection;
end;

function TManagerCaixa.DataSource: TDataSource;
begin
  FDataSet.Close;
  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.Open;
  TFloatField(FDataSet.FieldByName('VALOR')).currency := True;
  FDataSource.DataSet := FDataSet;
  Result := FDataSource;
end;

destructor TManagerCaixa.Destroy;
begin
  FreeAndNil(FCaixa);
  FreeAndNil(FUsuario);
  FreeAndNil(FDataSet);
  FreeAndNil(FDataSource);
  inherited;
end;

function TManagerCaixa.FindByID(ID: Integer): TCaixa;
begin
  FSQL := 'SELECT C.id as ID, C.titulo as TITULO, C.valor as VALOR, ' + 'C.descricao as DESCRICAO, C.dtentrada as DTENTRADA, C.dtatualizacao ' + 'as DTATUALIZACAO, C.entrada as ENTRADA, U.id as USUARIO_ID, U.nome ' + 'as USUARIO, U.adm as USUARIO_ADMINISTRADOR FROM caixa C inner join ' + 'usuarios U on C.id_usuario = U.id where C.id = :ID';

  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.ParamByName('ID').Value := ID;
  FDataSet.Open;

  FUsuario.ID(FDataSet.FieldByName('USUARIO_ID').AsInteger).NOME(FDataSet.FieldByName('USUARIO').AsString).SENHA('').ADMIN(FDataSet.FieldByName('USUARIO_ADMINISTRADOR').AsInteger);

  FCaixa.ID(FDataSet.FieldByName('ID').AsInteger).TITULO(FDataSet.FieldByName('TITULO').AsString).DESCRICAO(FDataSet.FieldByName('DESCRICAO').AsString).VALOR(FDataSet.FieldByName('VALOR').AsCurrency).DTENTRADA(FDataSet.FieldByName('DTENTRADA').AsDateTime).DTATUALIZACAO(FDataSet.FieldByName('DTATUALIZACAO').AsDateTime).ENTRADA(FDataSet.FieldByName('ENTRADA').AsBoolean).Usuario(FUsuario);

  Result := FCaixa;
end;

function TManagerCaixa.FindAll: iManager<TCaixa>;
begin
  FSQL := 'SELECT ' + 'C.id as ID, ' + 'C.titulo as TITULO, ' + 'C.valor as VALOR, ' + 'C.descricao as DESCRICAO, ' + 'C.dtentrada as DTENTRADA, ' + 'C.dtatualizacao as DTATUALIZACAO, ' + 'C.entrada as ENTRADA, ' + 'U.id as USUARIO_ID, ' + 'U.nome as USUARIO, ' + ' U.adm as USUARIO_ADMINISTRADOR ' + 'FROM caixa C' + ' inner join usuarios U ' + 'on C.id_usuario = U.id ';

  Result := Self;
end;

function TManagerCaixa.List: TObjectList<TCaixa>;
begin
  FSQL := 'SELECT ' + 'C.id as ID, ' + 'C.titulo as TITULO, ' + 'C.valor as VALOR, ' + 'C.descricao as DESCRICAO, ' + 'C.dtentrada as DTENTRADA, ' + 'C.dtatualizacao as DTATUALIZACAO, ' + 'C.entrada as ENTRADA, ' + 'U.id as USUARIO_ID, ' + 'U.nome as USUARIO, ' + ' U.adm as USUARIO_ADMINISTRADOR ' + 'FROM caixa C' + ' inner join usuarios U ' + 'on C.id_usuario = U.id ';
  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.Open;
  FListCaixa.Create;

  while not FDataSet.Eof do
  begin
    FCaixa.ID(FDataSet.FieldByName('ID').AsInteger).TITULO(FDataSet.FieldByName('TITULO').AsString).DESCRICAO(FDataSet.FieldByName('DESCRICAO').AsString).VALOR(FDataSet.FieldByName('VALOR').AsCurrency).DTENTRADA(FDataSet.FieldByName('DTENTRADA').AsDateTime).DTATUALIZACAO(FDataSet.FieldByName('DTATUALIZACAO').AsDateTime).ENTRADA(FDataSet.FieldByName('ENTRADA').AsBoolean).USUARIO.ID(FDataSet.FieldByName('USUARIO').AsInteger).NOME(FDataSet.FieldByName('USUARIO_NOME').AsString).SENHA('').ADMIN(FDataSet.FieldByName('USUARIO_ADMINISTRADOR').AsInteger);

    FListCaixa.Add(FCaixa);
  end;

  Result := FListCaixa;
end;

class function TManagerCaixa.New: iManager<TCaixa>;
begin
  Result := Self.Create;
end;

function TManagerCaixa.OrderBy(Column: string; Direction: tpOrderDirection = tpOrderDirection.Asc): iManager<TCaixa>;
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

procedure TManagerCaixa.Remove(aObject: TCaixa);
begin
  try
    FSQL := 'DELETE FROM caixa WHERE id=:id';
    FDataSet.Close;
    FDataSet.SQL.Clear;
    FDataSet.SQL.Add(FSQL);
    FDataSet.ParamByName('id').Value := aObject.ID;
    FDataSet.ExecSQL;
  except
    on E: Exception do
      ShowMessage('Erro ao remover registro: ' + E.Message);
  end;
end;

procedure TManagerCaixa.Remove(ID: Integer);
begin
  try
    FSQL := 'DELETE FROM caixa WHERE id=:id';
    FDataSet.Close;
    FDataSet.SQL.Clear;
    FDataSet.SQL.Add(FSQL);
    FDataSet.ParamByName('id').Value := ID;
    FDataSet.ExecSQL;
  except
    on E: Exception do
      ShowMessage('Erro ao remover registro: ' + E.Message);
  end;
end;

function TManagerCaixa.ResultLastInsert: TCaixa;
begin
  FDataSet.Close;
  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.Open;
  FDataSet.Last;
  FCaixa.ID(FDataSet.FieldByName('ID').AsInteger).TITULO(FDataSet.FieldByName('TITULO').AsString).DESCRICAO(FDataSet.FieldByName('DESCRICAO').AsString).VALOR(FDataSet.FieldByName('VALOR').AsCurrency).DTENTRADA(FDataSet.FieldByName('DTENTRADA').AsDateTime).DTATUALIZACAO(FDataSet.FieldByName('DTATUALIZACAO').AsDateTime).ENTRADA(FDataSet.FieldByName('ENTRADA').AsBoolean).USUARIO.ID(FDataSet.FieldByName('USUARIO_ID').AsInteger).NOME(FDataSet.FieldByName('USUARIO').AsString).SENHA('').ADMIN(FDataSet.FieldByName('USUARIO_ADMINISTRADOR').AsInteger);

  Result := FCaixa;
end;

procedure TManagerCaixa.Save(aObject: TCaixa);
begin
  try
    FSQL := 'INSERT INTO caixa ' + '(titulo, valor, descricao, dtentrada, dtatualizacao, entrada, id_usuario) ' + 'VALUES(:titulo, :valor, :descricao, current_timestamp(), current_timestamp(), :entrada, :usuario)';
    FDataSet.Close;
    FDataSet.SQL.Clear;
    FDataSet.SQL.Add(FSQL);
    FDataSet.ParamByName('titulo').Value := aObject.TITULO;
    FDataSet.ParamByName('valor').Value := aObject.VALOR;
    FDataSet.ParamByName('descricao').Value := aObject.DESCRICAO;
    FDataSet.ParamByName('entrada').Value := aObject.ENTRADA;
    FDataSet.ParamByName('usuario').Value := aObject.USUARIO.ID;
    FDataSet.ExecSQL;
  except
    on E: Exception do
      ShowMessage('Erro ao inserir registro: ' + E.Message);
  end;
end;

function TManagerCaixa.Sum(Column: string): iManager<TCaixa>;
begin
  Result := Self;
  FSQL := 'Select sum(c.' + Column + ') as VALOR from caixa c';
end;

function TManagerCaixa.UniqueResult: TCaixa;
begin
  FDataSet.Close;
  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.Open;
  FDataSet.First;
  FCaixa.ID(FDataSet.FieldByName('ID').AsInteger).TITULO(FDataSet.FieldByName('TITULO').AsString).DESCRICAO(FDataSet.FieldByName('DESCRICAO').AsString).VALOR(FDataSet.FieldByName('VALOR').AsCurrency).DTENTRADA(FDataSet.FieldByName('DTENTRADA').AsDateTime).DTATUALIZACAO(FDataSet.FieldByName('DTATUALIZACAO').AsDateTime).ENTRADA(FDataSet.FieldByName('ENTRADA').AsBoolean).USUARIO.ID(FDataSet.FieldByName('USUARIO_ID').AsInteger).NOME(FDataSet.FieldByName('USUARIO').AsString).SENHA('').ADMIN(FDataSet.FieldByName('USUARIO_ADMINISTRADOR').AsInteger);

  Result := FCaixa;
end;

procedure TManagerCaixa.Update(aObject: TCaixa);
begin
  FSQL := 'UPDATE caixa SET ' + 'titulo=:titulo, valor=:valor, ' + 'descricao=:descricao, dtatualizacao=current_timestamp(), ' + 'entrada=:entrada, id_usuario=:usuario  where id = :id';

  try
    FDataSet.Close;
    FDataSet.SQL.Clear;
    FDataSet.SQL.Text := FSQL;
    FDataSet.ParamByName('id').Value := aObject.ID;
    FDataSet.ParamByName('titulo').Value := aObject.TITULO;
    FDataSet.ParamByName('valor').Value := aObject.VALOR;
    FDataSet.ParamByName('descricao').Value := aObject.DESCRICAO;
    FDataSet.ParamByName('entrada').Value := aObject.ENTRADA;
    FDataSet.ParamByName('usuario').Value := aObject.USUARIO.ID;
    FDataSet.ExecSQL;

  except
    on E: Exception do
      ShowMessage('Erro ao atualizar registro: ' + E.Message);
  end;
end;

function TManagerCaixa.Where(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<TCaixa>;
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
        vExpression := ' ID ' + vOperator + QuotedStr(string(aValue));
      end;
    TITULO:
      begin
        vExpression := ' TITULO ' + vOperator + QuotedStr(string(aValue));
      end;
    VALOR:
      begin
        if FilterOperator = tpFilterOperator.Between then
          vExpression := ' VALOR ' + vOperator + ' "' + string(aValue) + '" ' + ' AND ' + ' "' + string(aValue2) + '" '
        else
          vExpression := ' VALOR ' + vOperator + QuotedStr(string(aValue));
      end;
    DESCRICAO:
      begin
        vExpression := ' DESCRICAO ' + vOperator + QuotedStr(string(aValue));
      end;
    DTENTRADA:
      begin
        if FilterOperator = tpFilterOperator.Between then
          vExpression := ' DTENTRADA ' + vOperator + ' "' + string(aValue) + '" ' + ' AND ' + ' "' + string(aValue2) + '" '
        else
          vExpression := ' DTENTRADA ' + vOperator + string(aValue);
      end;
    DTATUALIZACAO:
      begin
        if FilterOperator = tpFilterOperator.Between then
          vExpression := ' DTATUALIZACAO ' + vOperator + ' "' + string(aValue) + '" ' + ' AND ' + ' "' + string(aValue2) + '" '
        else
          vExpression := ' DTATUALIZACAO ' + vOperator + QuotedStr(string(aValue));
      end;
    ENTRADA:
      begin
        vExpression := ' ENTRADA ' + vOperator + QuotedStr(string(aValue));
      end;
    USUARIO:
      begin
        vExpression := ' USUARIO ' + vOperator + QuotedStr(string(aValue));
      end;
  end;

  Result := Self;

  FSQL := FSQL + ' WHERE ' + vExpression;
  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.Open;
end;

function TManagerCaixa._And(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<TCaixa>;
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
        vExpression := ' ID ' + vOperator + QuotedStr(string(aValue));
      end;
    TITULO:
      begin
        vExpression := ' TITULO ' + vOperator + QuotedStr(string(aValue));
      end;
    VALOR:
      begin
        if FilterOperator = tpFilterOperator.Between then
          vExpression := ' VALOR ' + vOperator + QuotedStr(string(aValue)) + ' AND ' + QuotedStr(string(aValue2))
        else
          vExpression := ' VALOR ' + vOperator + QuotedStr(string(aValue));
      end;
    DESCRICAO:
      begin
        vExpression := ' DESCRICAO ' + vOperator + QuotedStr(string(aValue));
      end;
    DTENTRADA:
      begin
        if FilterOperator = tpFilterOperator.Between then
          vExpression := ' DTENTRADA ' + vOperator + QuotedStr(string(aValue)) + ' AND ' + QuotedStr(string(aValue2))
        else
          vExpression := ' DTENTRADA ' + vOperator + QuotedStr(string(aValue));
      end;
    DTATUALIZACAO:
      begin
        if FilterOperator = tpFilterOperator.Between then
          vExpression := ' DTATUALIZACAO ' + vOperator + QuotedStr(string(aValue)) + ' AND ' + QuotedStr(string(aValue2))
        else
          vExpression := ' DTATUALIZACAO ' + vOperator + QuotedStr(string(aValue));
      end;
    ENTRADA:
      begin
        vExpression := ' ENTRADA ' + vOperator + QuotedStr(string(aValue));
      end;
    USUARIO:
      begin
        vExpression := ' USUARIO ' + vOperator + QuotedStr(string(aValue));
      end;
  end;

  Result := Self;

  FSQL := FSQL + ' AND ' + vExpression;
  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.Open;
end;

function TManagerCaixa._Or(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<TCaixa>;
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
        vExpression := ' ID ' + vOperator + QuotedStr(string(aValue));
      end;
    TITULO:
      begin
        vExpression := ' TITULO ' + vOperator + QuotedStr(string(aValue));
      end;
    VALOR:
      begin
        if FilterOperator = tpFilterOperator.Between then
          vExpression := ' VALOR ' + vOperator + QuotedStr(string(aValue)) + ' AND ' + QuotedStr(string(aValue2))
        else
          vExpression := ' VALOR ' + vOperator + QuotedStr(string(aValue));
      end;
    DESCRICAO:
      begin
        vExpression := ' DESCRICAO ' + vOperator + QuotedStr(string(aValue));
      end;
    DTENTRADA:
      begin
        if FilterOperator = tpFilterOperator.Between then
          vExpression := ' DTENTRADA ' + vOperator + QuotedStr(string(aValue)) + ' AND ' + QuotedStr(string(aValue2))
        else
          vExpression := ' DTENTRADA ' + vOperator + QuotedStr(string(aValue));
      end;
    DTATUALIZACAO:
      begin
        if FilterOperator = tpFilterOperator.Between then
          vExpression := ' DTATUALIZACAO ' + vOperator + QuotedStr(string(aValue)) + ' AND ' + QuotedStr(string(aValue2))
        else
          vExpression := ' DTATUALIZACAO ' + vOperator + QuotedStr(string(aValue));
      end;
    ENTRADA:
      begin
        vExpression := ' ENTRADA ' + vOperator + QuotedStr(string(aValue));
      end;
    USUARIO:
      begin
        vExpression := ' USUARIO ' + vOperator + QuotedStr(string(aValue));
      end;
  end;

  Result := Self;

  FSQL := FSQL + ' OR ' + vExpression;
  FDataSet.SQL.Clear;
  FDataSet.SQL.Add(FSQL);
  FDataSet.Open;
end;

end.

