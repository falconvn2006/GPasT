unit DAO.Crud;

interface

uses
  System.JSON, DAO.Conexao, Controller, Data.DB;

type
  TCrud = class
  private
    function DataSetToJson(pDataSet: TDataSet): String;
  public
    function Selecao(Filtro: String): TJSONValue;
    function Inserir(PriNome, SegNome, Doc, Cep, Nat: String; var Msg: String): Boolean;
    function Editar(IdPessoa: Integer; PriNome, SegNome, Doc, Cep, Nat, Cidade, Bairro, UF, Logra, Compl: String; var Msg: String): Boolean;
    function Excluir(IdPessoa: Integer; var Msg: String): Boolean;
    function AtualizarEndereco(IdEndereco: Integer; Logradouro, Bairro, Uf, Cidade, Complemento: String; var Msg: String): Boolean;
  end;

implementation

uses
  Controller.Entidades, System.SysUtils;

{ TCrud }

function TCrud.AtualizarEndereco(IdEndereco: Integer; Logradouro, Bairro, Uf,
  Cidade, Complemento: String; var Msg: String): Boolean;
var
  FController: IController;
  SQL: TStringBuilder;
begin
  Result := True;
  try
    try
      SQL := TStringBuilder.Create('DO $$ DECLARE V_IDENDERECO BIGINT; BEGIN BEGIN ').
             Append('SELECT I.IDENDERECO INTO STRICT V_IDENDERECO').Append(' ').
             Append('FROM ENDERECO_INTEGRACAO I WHERE I.IDENDERECO = ').Append(IdEndereco.ToString).Append(';').
             Append('UPDATE ENDERECO_INTEGRACAO SET ').
             Append('DSUF = ').Append(QuotedStr(Uf)).Append(',').
             Append('NMCIDADE = ').Append(QuotedStr(Cidade)).Append(',').
             Append('NMBAIRRO = ').Append(QuotedStr(Bairro)).Append(',').
             Append('NMLOGRADOURO = ').Append(QuotedStr(Logradouro)).Append(',').
             Append('DSCOMPLEMENTO = ').Append(QuotedStr(Complemento)).Append(' ').
             Append('WHERE IDENDERECO = ').Append(IdEndereco.ToString).Append('; ').
             Append('EXCEPTION WHEN NO_DATA_FOUND THEN ').
             Append('INSERT INTO ENDERECO_INTEGRACAO(IDENDERECO, DSUF, NMCIDADE, NMBAIRRO, NMLOGRADOURO, DSCOMPLEMENTO) VALUES(').
             Append(IdEndereco.ToString).Append(',').
             Append(QuotedStr(Uf)).Append(',').
             Append(QuotedStr(Cidade)).Append(',').
             Append(QuotedStr(Bairro)).Append(',').
             Append(QuotedStr(Logradouro)).Append(',').
             Append(QuotedStr(Complemento)).Append('); END; END $$');
      FController := TController.New;
      FController.Entidades.Pessoa.ExecSQL(SQL.ToString);
      Msg := 'Endereço ' + IdEndereco.ToString + ' atualizado com sucesso';
    except
      on e:exception do
      begin
        Msg := e.Message;
        Result := False;
      end;
    end;
  finally
    FreeAndNil(SQL);
  end;
end;

function TCrud.Excluir(IdPessoa: Integer; var Msg: String): Boolean;
var
  FController: IController;
  SQL: TStringBuilder;
begin
  Result := True;
  try
    try
      SQL := TStringBuilder.Create('DO $$ DECLARE V_IDENDERECO BIGINT; BEGIN ').
             Append('SELECT IDENDERECO INTO V_IDENDERECO FROM ENDERECO E WHERE E.IDPESSOA = ').
             Append(IdPessoa.ToString).
             Append(';').
             Append('DELETE FROM ENDERECO_INTEGRACAO I WHERE I.IDENDERECO = V_IDENDERECO; ').
             Append('DELETE FROM ENDERECO WHERE ENDERECO.IDPESSOA = ').
             Append(IdPessoa.ToString).
             Append(';').
             Append('DELETE FROM PESSOA P WHERE P.IDPESSOA = ').
             Append(IdPessoa.ToString).
             Append(';').
             Append(' END $$');
      FController := TController.New;
      FController.Entidades.Pessoa.ExecSQL(SQL.ToString);
      Msg := 'Pessoa ID '+ IdPessoa.ToString + ' excluída com sucesso.';
    except
      on e:exception do
      begin
        Msg := e.Message;
        Result := False;
      end;
    end;
  finally
    FreeAndNil(SQL);
  end;
end;

function TCrud.Selecao(Filtro: String): TJSONValue;
var
  FController: IController;
  FDataSet: TDataSource;
  Retorno: TJSONObject;
begin
  try
    Retorno := TJSONObject.Create;
    FDataSet := TDataSource.Create(Nil);
    FController := TController.New;
    FController.Entidades.Pessoa.DataSet(FDataSet).Open;
    Result := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(DataSetToJson(FDataSet.DataSet)),0) as TJSONArray;
  finally
    FreeAndNil(FDataSet);
    FreeAndNil(Retorno);
  end;
end;

function TCrud.Editar(IdPessoa: Integer; PriNome, SegNome, Doc, Cep, Nat, Cidade, Bairro, UF, Logra, Compl: String; var Msg: String): Boolean;
var
  FController: IController;
  SQL: TStringBuilder;
begin
  Result := True;
  try
    try
      SQL := TStringBuilder.Create('DO $$ DECLARE V_IDENDERECO BIGINT; BEGIN ').
             Append('SELECT IDENDERECO INTO V_IDENDERECO FROM ENDERECO E WHERE E.IDPESSOA = ').
             Append(IdPessoa.ToString).Append(';').
             Append('UPDATE ENDERECO_INTEGRACAO SET DSUF = ').Append(QuotedStr(Doc)).Append(',').
             Append('NMCIDADE = ').Append(QuotedStr(Cidade)).Append(',').
             Append('NMBAIRRO = ').Append(QuotedStr(Bairro)).Append(',').
             Append('NMLOGRADOURO = ').Append(QuotedStr(Logra)).Append(',').
             Append('DSCOMPLEMENTO = ').Append(QuotedStr(Cidade)).Append(' ').
             Append('WHERE IDENDERECO = V_IDENDERECO; ').
             Append('UPDATE ENDERECO SET DSCEP = ').Append(QuotedStr(Cep)).Append(' ').
             Append('WHERE IDENDERECO = V_IDENDERECO; ').
             Append('UPDATE PESSOA SET FLNATUREZA = ').Append(Nat).Append(',').
             Append('DSDOCUMENTO = ').Append(QuotedStr(Doc)).Append(',').
             Append('NMPRIMEIRO = ').Append(QuotedStr(PriNome)).Append(',').
             Append('NMSEGUNDO = ').Append(QuotedStr(SegNome)).Append(' ').
             Append('WHERE IDPESSOA = ').Append(IdPessoa.ToString).Append('; END $$');
      FController := TController.New;
      FController.Entidades.Pessoa.ExecSQL(SQL.ToString);
      Msg := PriNome + ' ' + SegNome + ' editado(a) com sucesso.';
    except
      on e:exception do
      begin
        Msg := e.Message;
        Result := False;
      end;
    end;
  finally
    FreeAndNil(SQL);
  end;
end;

function TCrud.Inserir(PriNome, SegNome, Doc, Cep, Nat: String; var Msg: String): Boolean;
var
  FController: IController;
  SQL: TStringBuilder;
begin
  Result := True;
  try
    try
      SQL := TStringBuilder.Create('DO $$ DECLARE V_IDPESSOA BIGINT; BEGIN ').
             Append('INSERT INTO PESSOA (FLNATUREZA, DSDOCUMENTO, NMPRIMEIRO, NMSEGUNDO, DTREGISTRO) ').
             Append('	VALUES( ').
             Append(Nat).
             Append(',').
             Append(QuotedStr(Doc)).
             Append(',').
             Append(QuotedStr(PriNome)).
             Append(',').
             Append(QuotedStr(SegNome)).
             Append(',').
             Append('CURRENT_DATE) RETURNING IDPESSOA INTO V_IDPESSOA; ').
             Append('INSERT INTO ENDERECO (IDPESSOA, DSCEP) VALUES(V_IDPESSOA,').
             Append(QuotedStr(Cep)).
             Append('); END $$');
      FController := TController.New;
      FController.Entidades.Pessoa.ExecSQL(SQL.ToString);
      Msg := PriNome + ' ' + SegNome + ' incluído(a) com sucesso.';
    except
      on e:exception do
      begin
        Msg := e.Message;
        Result := False;
      end;
    end;
  finally
    FreeAndNil(SQL);
  end;
end;

function TCrud.DataSetToJson(pDataSet: TDataSet): String;
var
  ArrayJSon: TJSONArray;
  ObjJSon: TJSONObject;
  strJSon: TJSONString;
  intJSon: TJSONNumber;
  numJSon: TJSONNumber;
  pField:TField;
begin
  ArrayJSon := TJSONArray.Create;
  try
    pDataSet.First;
    while not pDataSet.Eof do
    begin
      ObjJSon := TJSONObject.Create;
      for pField in pDataSet.Fields do
      begin
        if pField.DataType in [ftString,ftWideString]then begin
          strJSon := TJSONString.Create(pField.AsString);
          ObjJSon.AddPair(pField.FieldName,strJSon);
        end else
        if pField.DataType in [ftInteger,ftShortint,ftSmallint]then begin
          numJSon := TJSONNumber.Create(pField.AsInteger);
          ObjJSon.AddPair(pField.FieldName,numJSon);
        end else
        if pField.DataType in [ftFloat,ftBCD,ftFMTBcd,ftCurrency,ftWord]then begin
          numJSon := TJSONNumber.Create(pField.AsFloat);
          ObjJSon.AddPair(pField.FieldName,numJSon);
        end else
        begin
          strJSon := TJSONString.Create(pField.AsString);
          ObjJSon.AddPair(pField.FieldName,strJSon);
        end;
      end;
      ArrayJSon.AddElement(ObjJSon);
      pDataSet.next;
    end;
    Result := ArrayJSon.ToString;
  finally
    FreeAndNil(ArrayJSon);
  end;
end;


end.
