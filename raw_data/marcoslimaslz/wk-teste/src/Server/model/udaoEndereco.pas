unit udaoEndereco;

interface

uses
  System.SysUtils, Data.DB, udtoEndereco,  FireDAC.Comp.Client,
  FireDAC.Stan.Param, System.TypInfo;

type
  TDAOEndereco = class
  strict private
    const
      cstSelect: System.UnicodeString =
          'SELECT idendereco, idpessoa, dscep FROM Endereco';
      cstInsert: System.UnicodeString =
          'INSERT INTO Endereco ( idpessoa, dscep ) VALUES ( :idpessoa, :dscep )';
      cstUpdate: System.UnicodeString =
          'UPDATE endereco ' +
          'SET idendereco = :idendereco, '+
          '    idpessoa = :idpessoa, '+
          '    dscep = :dscep '+
          ' WHERE idendereco = :idendereco ';
      cstDelete: System.UnicodeString =
          'DELETE FROM endereco WHERE idendereco = :idendereco';
  private
    FConnection: TFDConnection;
    class procedure InternalLoad(var AQuery: TFDQuery; const AObject: TDTOEndereco); static;
    class procedure InternalLoadAll(var AQuery: TFDQuery; const ADTOListaEnderecos: TDTOListaEnderecos); static;
  public
      constructor Create(AConnection: TFDConnection);
      procedure UnsafeSave(const ADTOEndereco: TDTOEndereco);
      procedure Save(const ADTOEndereco: TDTOEndereco);
      function Load(const ADTOEndereco: TDTOEndereco; const AIdEndereco: System.Integer): Boolean;
      function LoadByPerson(const ADTOEndereco: TDTOEndereco; const AIdPessoa: System.Integer): Boolean;
      function LoadAll(const ADTOListaEnderecos: TDTOListaEnderecos): Boolean;
      procedure UnSafeDelete(const ACodigo: System.Integer);
      procedure SafeDelete(const ACodigo: System.Integer);
  end;

implementation

{ TDAOEndereco }

constructor TDAOEndereco.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

class procedure TDAOEndereco.InternalLoad(var AQuery: TFDQuery;const AObject: TDTOEndereco);
begin
  AObject.idendereco := AQuery.FieldByName('idendereco').AsInteger;
  AObject.idpessoa := AQuery.FieldByName('idpessoa').AsInteger;
  AObject.dscep := AQuery.FieldByName('dscep').AsString;
end;

class procedure TDAOEndereco.InternalLoadAll(var AQuery: TFDQuery;
  const ADTOListaEnderecos: TDTOListaEnderecos);
var
  ttyDTOEndereco: TDTOEndereco;
begin
  AQuery.First;
  while not(AQuery.Eof) do
  begin
    ttyDTOEndereco := TDTOEndereco.Create;
    ttyDTOEndereco.idendereco := AQuery.FieldByName('idendereco').AsInteger;
    ttyDTOEndereco.idpessoa := AQuery.FieldByName('idpessoa').AsInteger;
    ttyDTOEndereco.dscep := AQuery.FieldByName('dscep').AsString;
    ADTOListaEnderecos.Add(ttyDtoEndereco);
    AQuery.Next;
  end;
end;

function TDAOEndereco.Load(const ADTOEndereco: TDTOEndereco; const AIdEndereco: System.Integer): Boolean;
var
  ttyQuery: TFDQuery;
begin
  Result := False;
  if (AIdEndereco > 0) then
  begin
    ttyQuery := TFDQuery.Create(nil);
    ttyQuery.Connection := FConnection;
    ttyQuery.SQL.Add(cstSelect);
    ttyQuery.SQL.Add(' WHERE idendereco = :idendereco');
    ttyQuery.ParamByName('idendereco').AsInteger := AIdEndereco;
    ttyQuery.Open;

    Result := not ttyQuery.IsEmpty;

    if not ttyQuery.IsEmpty then
    begin
      InternalLoad(ttyQuery, ADTOEndereco);
    end;
  end;
end;

function TDAOEndereco.LoadAll(const ADTOListaEnderecos: TDTOListaEnderecos): Boolean;
var
  ttyQuery: TFDQuery;
begin
  Result := False;
  ttyQuery := TFDQuery.Create(nil);
  ttyQuery.Connection := FConnection;
  ttyQuery.SQL.Add(cstSelect);
  ttyQuery.Open;

  Result := not ttyQuery.IsEmpty;

  if not ttyQuery.IsEmpty then
  begin
    InternalLoadAll(ttyQuery, ADTOListaEnderecos);
  end;
end;

function TDAOEndereco.LoadByPerson(const ADTOEndereco: TDTOEndereco;
  const AIdPessoa: System.Integer): Boolean;
var
  ttyQuery: TFDQuery;
begin
  Result := False;
  if (AIdPessoa > 0) then
  begin
    ttyQuery := TFDQuery.Create(nil);
    ttyQuery.Connection := FConnection;
    ttyQuery.SQL.Add(cstSelect);
    ttyQuery.SQL.Add(' WHERE idpessoa = :idpessoa');
    ttyQuery.ParamByName('idpessoa').AsInteger := AIdPessoa;
    ttyQuery.Open;

    Result := not ttyQuery.IsEmpty;

    if not ttyQuery.IsEmpty then
    begin
      InternalLoad(ttyQuery, ADTOEndereco);
    end;
  end;
end;

procedure TDAOEndereco.SafeDelete(const ACodigo: System.Integer);
begin
  FConnection.StartTransaction;
  try
    UnSafeDelete(ACodigo);
    FConnection.Commit;
  except
    FConnection.Rollback;
    raise
  end;
end;

procedure TDAOEndereco.Save(const ADTOEndereco: TDTOEndereco);
begin
   FConnection.StartTransaction;
   try
      UnsafeSave(ADTOEndereco);
      FConnection.Commit;
   except
      FConnection.Rollback;
      raise;
   end;
end;

procedure TDAOEndereco.UnSafeDelete(const ACodigo: System.Integer);
var
  ttyQuery: TFDQuery;
begin
  ttyQuery := TFDQuery.Create(nil);
  ttyQuery.Connection := FConnection;
  ttyQuery.SQL.Add(cstDelete);
  ttyQuery.ParamByName('idedereco').AsInteger := ACodigo;
  ttyQuery.ExecSQL;
end;

procedure TDAOEndereco.UnsafeSave(const ADTOEndereco: TDTOEndereco);
var
  ttyQuery: TFDQuery;
  LId: System.Integer;
begin
  ttyQuery := TFDQuery.Create(nil);
  ttyQuery.Connection := FConnection;
  try
    if (ADTOEndereco.idendereco <= 0) then
    begin
      ttyQuery.SQL.Add(cstInsert);
    end else
    begin
      LId := ADTOEndereco.idEndereco;
      ttyQuery.SQL.Add(cstUpdate);
      ttyQuery.ParamByName('idendereco').AsInteger := LId;
    end;
    ttyQuery.ParamByName('idpessoa').AsInteger := ADTOEndereco.idpessoa;
    ttyQuery.ParamByName('dscep').AsString := ADTOEndereco.dscep;
    ttyQuery.ExecSQL;
  finally
    ttyQuery.Free;
  end;
end;
end.
