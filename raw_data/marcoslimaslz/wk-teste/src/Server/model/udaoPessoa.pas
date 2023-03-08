unit udaoPessoa;

interface
uses
  System.SysUtils, Data.DB, udtoPessoa, udaoEndereco, udtoEndereco,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DApt, System.TypInfo;

type
  TDAOPessoa = class
  strict private
    const
      cstSelect: System.UnicodeString =
          'SELECT p.idpessoa, p.flnatureza, p.dsdocumento, p.nmprimeiro, ' +
          '  p.nmsegundo, p.dtregistro, e.dscep '+
          ' FROM pessoa p '+
          ' INNER JOIN endereco e on e.idpessoa = p.idpessoa ';
      cstInsert: System.UnicodeString =
          'INSERT INTO pessoa (' +
          '  flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro ) ' +
          'VALUES ('+
          '  :flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, :dtregistro ) ' +
          ' RETURNING idpessoa ';
      cstUpdate: System.UnicodeString =
          'UPDATE pessoa ' +
          'SET flnatureza = :flnatureza, '+
          '    dsdocumento = :dsdocumento, '+
          '    nmprimeiro = :nmprimeiro, '+
          '    nmsegundo = :nmsegundo '+
          ' WHERE idpessoa = :idpessoa ';
      cstDelete: System.UnicodeString =
          'DELETE FROM pessoa WHERE idpessoa = :idpessoa';
  private
    FConnection: TFDConnection;
    class procedure InternalLoad(var AQuery: TFDQuery; const ADTOPessoa: TDTOPessoa); static;
  public
      constructor Create(AConnection: TFDConnection);
      procedure UnsafeSave(const ADTOPessoa: TDTOPessoa);
      procedure SafeEndereco(const AIdPessoa: System.Integer; const ACep: System.String);
      procedure Save(const ADTOPessoa: TDTOPessoa);
      function Load(const ADTOPessoa: TDTOPessoa; const AIdPessoa: System.Integer): Boolean;
      procedure UnSafeDelete(const ACodigo: System.Integer);
      procedure SafeDelete(const ACodigo: System.Integer);
  end;

implementation

{ TDAOPessoa }

constructor TDAOPessoa.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

procedure TDAOPessoa.SafeEndereco(const AIdPessoa: System.Integer;
  const ACep: System.String);
var
  ttyDAOEndereco: TDaoEndereco;
  LDtoEndereco: TDtoEndereco;
begin
  ttyDAOEndereco := TDaoEndereco.Create(FConnection);
  LDtoEndereco := TDtoEndereco.Create;
  try
    ttyDAOEndereco.LoadByPerson(LDtoEndereco, AIdPessoa);
    LDtoEndereco.idpessoa := AIdPessoa;
    LDtoEndereco.dscep := ACep;
    ttyDAOEndereco.Save(LDtoEndereco);
  finally
    ttyDAOEndereco.Free;
    LDtoEndereco.Free;
  end;
end;

class procedure TDAOPessoa.InternalLoad(var AQuery: TFDQuery;const ADTOPessoa: TDTOPessoa);
begin
  ADTOPessoa.idpessoa := AQuery.FieldByName('idpessoa').AsInteger;
  ADTOPessoa.flnatureza := AQuery.FieldByName('flnatureza').AsInteger;
  ADTOPessoa.nmprimeiro := AQuery.FieldByName('nmprimeiro').AsString;
  ADTOPessoa.nmsegundo := AQuery.FieldByName('nmsegundo').AsString;
  ADTOPessoa.dsdocumento := AQuery.FieldByName('dsdocumento').AsString;
  ADTOPessoa.dtregistro := AQuery.FieldByName('dtregistro').AsDateTime;
  ADTOPessoa.dscep := AQuery.FieldByName('dscep').AsString;
end;

function TDAOPessoa.Load(const ADTOPessoa: TDTOPessoa; const AIdPessoa: System.Integer): Boolean;
var
  ttyQuery: TFDQuery;
begin
  Result := False;
  if (AIdPessoa > 0) then
  begin
    ttyQuery := TFDQuery.Create(nil);
    ttyQuery.Connection := FConnection;
    ttyQuery.SQL.Add(cstSelect);
    ttyQuery.SQL.Add('WHERE p.idpessoa = :idpessoa');
    ttyQuery.ParamByName('idpessoa').AsInteger := AIdPessoa;
    ttyQuery.Open;

    Result := not ttyQuery.IsEmpty;

    if not ttyQuery.IsEmpty then
    begin
      InternalLoad(ttyQuery, ADTOPessoa);
    end;
  end;
end;

procedure TDAOPessoa.SafeDelete(const ACodigo: System.Integer);
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

procedure TDAOPessoa.Save(const ADTOPessoa: TDTOPessoa);
begin
   FConnection.StartTransaction;
   try
      UnsafeSave(ADTOPessoa);
      FConnection.Commit;
   except
      FConnection.Rollback;
      raise;
   end;
end;

procedure TDAOPessoa.UnSafeDelete(const ACodigo: System.Integer);
var
  ttyQuery: TFDQuery;
begin
  ttyQuery := TFDQuery.Create(nil);
  ttyQuery.Connection := FConnection;
  ttyQuery.SQL.Add(cstDelete);
  ttyQuery.ParamByName('idpessoa').AsInteger := ACodigo;
  ttyQuery.ExecSQL;
end;

procedure TDAOPessoa.UnsafeSave(const ADTOPessoa: TDTOPessoa);
var
  ttyQuery: TFDQuery;
  LId: System.Integer;
begin
  ttyQuery := TFDQuery.Create(nil);
  ttyQuery.Connection := FConnection;
  try
    if (ADTOPessoa.idpessoa <= 0) then
    begin
      ttyQuery.SQL.Add(cstInsert);
      ttyQuery.ParamByName('dtregistro').AsDate:= ADTOPessoa.dtregistro;
    end
    else
    begin
      LId := ADTOPessoa.idpessoa;
      ttyQuery.SQL.Add(cstUpdate);
      ttyQuery.ParamByName('idpessoa').AsInteger := LId;
    end;

    ttyQuery.ParamByName('flnatureza').AsInteger := ADTOPessoa.flnatureza;
    ttyQuery.ParamByName('nmprimeiro').AsString := ADTOPessoa.nmprimeiro;
    ttyQuery.ParamByName('nmsegundo').AsString := ADTOPessoa.nmsegundo;
    ttyQuery.ParamByName('dsdocumento').AsString := ADTOPessoa.dsdocumento;

    if (ADTOPessoa.idpessoa <= 0) then
    begin
      ttyQuery.OpenOrExecute;
      SafeEndereco(ttyQuery.FieldByName('idpessoa').AsInteger, ADTOPessoa.dscep);
    end
    else
    begin
      ttyQuery.ExecSql;
      SafeEndereco(ADTOPessoa.idpessoa, ADTOPessoa.dscep);
    end;
  finally
    ttyQuery.Free;
  end;
end;
end.
