unit udaoEnderecoIntegracao;

interface

uses
  System.SysUtils, Data.DB, udtoEnderecoIntegracao, FireDAC.Comp.Client,
  FireDAC.Stan.Param, System.TypInfo;

type
  TDAOEnderecoIntegracao = class
  strict private
    const
      cstSelect: System.UnicodeString = 'SELECT idendereco, dsuf, nmcidade, '+
          ' nmbairro, nmlogradouro, dscomplemento ' +
          ' FROM endereco_integracao';
      cstInsert: System.UnicodeString =
          'INSERT INTO endereco_integracao (' +
          '  idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento ) '+
          'VALUES('+
          '  :idendereco, :dsuf, :nmcidade, :nmbairro, :nmlogradouro, :dscomplemento )';
      cstUpdate: System.UnicodeString =
          'UPDATE endereco_integracao ' +
          'SET dsuf = :dsuf, '+
          '  nmcidade = :nmcidade, '+
          '  nmbairro = :nmbairro, '+
          '  nmlogradouro = :nmlogradouro, '+
          '  dscomplemento = :dscomplemento '+
          ' WHERE idendereco = :idendereco ';
      cstDelete: System.UnicodeString =
          'DELETE FROM endereco_integracao WHERE idendereco = :idendereco';
  private
    FConnection: TFDConnection;
    class procedure InternalLoad(var AQuery: TFDQuery; const ADTOEnderecoIntegracao: TDTOEnderecoIntegracao); static;
  public
      constructor Create(AConnection: TFDConnection);
      procedure UnsafeSave(const ADTOEnderecoIntegracao: TDTOEnderecoIntegracao);
      procedure Save(const ADTOEnderecoIntegracao: TDTOEnderecoIntegracao);
      function Load(const ADTOEnderecoIntegracao: TDTOEnderecoIntegracao; const AIdEndereco: System.Integer): Boolean;
      procedure UnSafeDelete(const ACodigo: System.Integer);
      procedure SafeDelete(const ACodigo: System.Integer);
  end;

implementation

{ TDAOEnderecoIntegracao }

constructor TDAOEnderecoIntegracao.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

class procedure TDAOEnderecoIntegracao.InternalLoad(var AQuery: TFDQuery; const ADTOEnderecoIntegracao: TDTOEnderecoIntegracao);
begin
  ADTOEnderecoIntegracao.idendereco := AQuery.FieldByName('idendereco').AsInteger;
  ADTOEnderecoIntegracao.dsuf := AQuery.FieldByName('dsuf').AsString;
  ADTOEnderecoIntegracao.nmcidade:= AQuery.FieldByName('nmcidade').AsString;
  ADTOEnderecoIntegracao.nmbairro := AQuery.FieldByName('nmbairro').AsString;
  ADTOEnderecoIntegracao.nmlogradouro:= AQuery.FieldByName('nmlogradouro').AsString;
  ADTOEnderecoIntegracao.dscomplemento := AQuery.FieldByName('dscomplemento').AsString;
end;

function TDAOEnderecoIntegracao.Load(const ADTOEnderecoIntegracao: TDTOEnderecoIntegracao; const AIdEndereco: System.Integer): Boolean;
var
  ttyQuery: TFDQuery;
begin
  Result := False;
  if (AIdEndereco > 0) then
  begin
    ttyQuery := TFDQuery.Create(nil);
    ttyQuery.Connection := FConnection;
    ttyQuery.SQL.Add(cstSelect);
    ttyQuery.SQL.Add(' WHERE idenderecointegracao = :idenderecointegracao');
    ttyQuery.ParamByName('idenderecointegracao').AsInteger := AIdEndereco;
    ttyQuery.Open;

    Result := not(ttyQuery.IsEmpty);

    if not(ttyQuery.IsEmpty) then
      InternalLoad(ttyQuery, ADTOEnderecoIntegracao);
  end;
end;

procedure TDAOEnderecoIntegracao.SafeDelete(const ACodigo: System.Integer);
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

procedure TDAOEnderecoIntegracao.Save(const ADTOEnderecoIntegracao: TDTOEnderecoIntegracao);
begin
   FConnection.StartTransaction;
   try
      UnsafeSave(ADTOEnderecoIntegracao);
      FConnection.Commit;
   except
      FConnection.Rollback;
      raise;
   end;
end;

procedure TDAOEnderecoIntegracao.UnSafeDelete(const ACodigo: System.Integer);
var
  ttyQuery: TFDQuery;
begin
  ttyQuery := TFDQuery.Create(nil);
  ttyQuery.Connection := FConnection;
  ttyQuery.SQL.Add(cstDelete);
  ttyQuery.ParamByName('idenderecointegracao').AsInteger := ACodigo;
  ttyQuery.ExecSQL;
end;

procedure TDAOEnderecoIntegracao.UnsafeSave(const ADTOEnderecoIntegracao: TDTOEnderecoIntegracao);
var
  ttyQuery: TFDQuery;
begin
  ttyQuery := TFDQuery.Create(nil);
  ttyQuery.Connection := FConnection;
  try
    if(ADTOEnderecoIntegracao.idendereco <> 0) then
    begin
      ttyQuery.SQL.Add(cstUpdate);
    end else
    begin
      ttyQuery.SQL.Add(cstInsert);
    end;
    ttyQuery.ParamByName('idendereco').AsInteger := ADTOEnderecoIntegracao.idendereco;
    ttyQuery.ParamByName('dsuf').AsString := ADTOEnderecoIntegracao.dsuf;
    ttyQuery.ParamByName('nmcidade').AsString := ADTOEnderecoIntegracao.nmcidade;
    ttyQuery.ParamByName('nmbairro').AsString := ADTOEnderecoIntegracao.nmbairro;
    ttyQuery.ParamByName('nmlogradouro').AsString := ADTOEnderecoIntegracao.nmlogradouro;
    ttyQuery.ParamByName('dscomplemento').AsString := ADTOEnderecoIntegracao.dscomplemento;
    ttyQuery.ExecSQL;
  finally
    ttyQuery.Free;
  end;
end;
end.
