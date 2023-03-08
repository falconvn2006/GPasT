unit uServerMethods;

interface

uses System.SysUtils, System.Classes, System.Json, DataSnap.DSProviderDataModuleAdapter,
  Datasnap.DSServer, Datasnap.DSAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Phys.PGDef, FireDAC.Phys.PG, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.UI, REST.Json, System.Types, System.StrUtils;

type
  TPessoa = class
  private
    Fnmprimeiro: string;
    Fdtregistro: TDate;
    Fnmsegundo: string;
    Fdscep: string;
    Fdsdocumento: string;
    Fidpessoa: Integer;
    Fflnatureza: Integer;
  public
    property idpessoa: Integer read Fidpessoa write Fidpessoa;
    property flnatureza: Integer read Fflnatureza write Fflnatureza;
    property dsdocumento: string read Fdsdocumento write Fdsdocumento;
    property nmprimeiro: string read Fnmprimeiro write Fnmprimeiro;
    property nmsegundo: string read Fnmsegundo write Fnmsegundo;
    property dtregistro: TDate read Fdtregistro write Fdtregistro;
    property dscep: string read Fdscep write Fdscep;
  end;

  TServerMethods = class(TDSServerModule)
    FDConnection: TFDConnection;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    QryPessoa: TFDQuery;
    QryPessoaidpessoa: TLargeintField;
    QryPessoaflnatureza: TSmallintField;
    QryPessoadsdocumento: TWideStringField;
    QryPessoanmprimeiro: TWideStringField;
    QryPessoanmsegundo: TWideStringField;
    QryPessoadtregistro: TDateField;
    FDUpdateSQLPessoa: TFDUpdateSQL;
    FDUpdateSQLEndereco: TFDUpdateSQL;
    QryEndereco: TFDQuery;
    QryEnderecoidendereco: TLargeintField;
    QryEnderecoidpessoa: TLargeintField;
    QryEnderecodscep: TWideStringField;
    FDTransaction: TFDTransaction;
    FDSchemaAdapter: TFDSchemaAdapter;
    QryPessoadscep: TWideStringField;
  private
    function PessoaExiste(IdPessoa: Integer): Boolean;
    { Private declarations }
  public
    function AcceptPessoa(AJSON: TJSONObject): TJSONObject;
    function UpdatePessoa(AJSON: TJSONObject): TJSONObject;
    function CancelPessoa(IdPessoa: Integer): TJSONObject;

    function AcceptPessoaLote(AArray: TJSONArray): TJSONObject;
  end;

implementation


{$R *.dfm}


{ TServerMethods }


function TServerMethods.AcceptPessoa(AJSON: TJSONObject): TJSONObject;
const
  INSERT =
    'INSERT INTO pessoa (idpessoa, flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) '+
    '            VALUES (:idpessoa, :flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, :dtregistro)'+
    'RETURNING idpessoa {into :id}';

  INSERT_ENDERECO =
    'INSERT INTO endereco (idpessoa, dscep) VALUES (:idpessoa, :dscep)';
begin
  Result := TJSONObject.Create;

  FDConnection.Transaction.StartTransaction;
  try
    QryPessoa.Close;
    QryPessoa.SQL.Text := INSERT;
    QryPessoa.Params.ParamByName('idpessoa').AsInteger := AJSON.GetValue('idpessoa').Value.ToInteger();
    QryPessoa.Params.ParamByName('flnatureza').AsInteger := AJSON.GetValue('flnatureza').Value.ToInteger();
    QryPessoa.Params.ParamByName('dsdocumento').AsString := AJSON.GetValue('dsdocumento').Value;
    QryPessoa.Params.ParamByName('nmprimeiro').AsString := AJSON.GetValue('nmprimeiro').Value;
    QryPessoa.Params.ParamByName('nmsegundo').AsString := AJSON.GetValue('nmsegundo').Value;
    QryPessoa.Params.ParamByName('dtregistro').AsDate := Date;
    QryPessoa.Params.ParamByName('id').DataType := ftInteger;
    QryPessoa.ExecSQL;

    QryEndereco.Close;
    QryEndereco.SQL.Text := INSERT_ENDERECO;
    QryEndereco.Params.ParamByName('idpessoa').AsInteger := AJSON.GetValue('idpessoa').Value.ToInteger();
    QryEndereco.Params.ParamByName('dscep').AsString := AJSON.GetValue('dscep').Value;
    QryEndereco.ExecSQL;

    FDConnection.Transaction.Commit;

    Result.AddPair('Retorno:', 'Pessoa inserida com sucesso!');
    Result.AddPair('Id Pessoa:', QryPessoa.ParamByName('idpessoa').AsString);
  except
    FDConnection.Transaction.Rollback;
    Result.AddPair('Retorno:', 'Erro ao inserir pessoa.');
  end;
end;

function TServerMethods.AcceptPessoaLote(AArray: TJSONArray): TJSONObject;
const
  INDEX_ID = 0;
  INDEX_NATUREZA = 1;
  INDEX_DOCUMENTO = 2;
  INDEX_PRIMEIRO_NOME = 3;
  INDEX_SEGUNDO_NOME = 4;
  INDEX_CEP = 5;

  INSERT_LOTE_PESSOA =
    'INSERT INTO pessoa (idpessoa, flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) '+
    '            VALUES (:idpessoa, :flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, current_date)';
  INSERT_LOTE_ENDERECO =
    'INSERT INTO endereco (idpessoa, dscep) VALUES (:idpessoa, :dscep)';
var
  LObject: TJSONObject;
  LValue: TJSONValue;
  LPair: TJSONPair;
  LIndex: Integer;
  LQueryPessoa: TFDQuery;
  LQueryEndereco: TFDQuery;
begin
  Result := TJSONObject.Create;

  LIndex := 0;
  LQueryPessoa := TFDQuery.Create(nil);
  LQueryEndereco := TFDQuery.Create(nil);
  try
    FDConnection.Transaction.StartTransaction;
    try
      LQueryPessoa.Connection := FDConnection;
      LQueryPessoa.SQL.Text := INSERT_LOTE_PESSOA;

      LQueryEndereco.Connection := FDConnection;
      LQueryEndereco.SQL.Text := INSERT_LOTE_ENDERECO;

      LQueryPessoa.Params.ArraySize := AArray.Count;
      LQueryEndereco.Params.ArraySize := AArray.Count;
      for LValue in AArray do
      begin
        LObject := TJSONObject.ParseJSONValue(LValue.ToString) as TJSONObject;
        for LPair in LObject do
        begin
          if (LPair.JsonString.Value = 'idpessoa') or (LPair.JsonString.Value = 'flnatureza') then
          begin
            LQueryPessoa.ParamByName(LPair.JsonString.Value).AsIntegers[LIndex] := LPair.JsonValue.Value.ToInteger();
            if LPair.JsonString.Value = 'idpessoa' then
              LQueryEndereco.ParamByName(LPair.JsonString.Value).AsIntegers[LIndex] := LPair.JsonValue.Value.ToInteger();
          end
          else
          begin
            if LPair.JsonString.Value = 'dscep' then
              LQueryEndereco.ParamByName(LPair.JsonString.Value).AsStrings[LIndex] := LPair.JsonValue.Value
            else
              LQueryPessoa.ParamByName(LPair.JsonString.Value).AsStrings[LIndex] := LPair.JsonValue.Value;
          end;
        end;
        Inc(LIndex);
      end;
      LQueryPessoa.Execute(AArray.Count, 0);
      LQueryEndereco.Execute(AArray.Count, 0);

      FDConnection.Transaction.Commit;

      Result.AddPair('Retorno:', 'Pessoas inseridas com sucesso!');
    except
      FDConnection.Transaction.Rollback;
      Result.AddPair('Retorno:', 'Erro ao inserir em lote pessoas.');
    end;
  finally
    FreeAndNil(LQueryPessoa);
    FreeAndNil(LQueryEndereco);
  end;
end;

function TServerMethods.CancelPessoa(IdPessoa: Integer): TJSONObject;
const
  DELETE = 'DELETE FROM pessoa WHERE idpessoa = :idpessoa';
begin
  Result := TJSONObject.Create;

  if not PessoaExiste(IdPessoa) then
  begin
    Result.AddPair('Retorno:', 'Pessoa informada não encontrada.');
    Exit;
  end;

  QryPessoa.Transaction.StartTransaction;
  try
    QryPessoa.Close;
    QryPessoa.SQL.Text := DELETE;
    QryPessoa.Params.ParamByName('idpessoa').AsInteger := IdPessoa;
    QryPessoa.ExecSQL;
    QryPessoa.Transaction.Commit;

    Result.AddPair('Retorno:', 'Pessoa deletada com sucesso!')
  except
    QryPessoa.Transaction.Rollback;
    Result.AddPair('Retorno:', 'Erro ao deletar pessoa!');
  end;
end;

function TServerMethods.UpdatePessoa(AJSON: TJSONObject): TJSONObject;
const
  UPDATE_PESSOA =
    'UPDATE pessoa '+
    '   SET flnatureza = :flnatureza, dsdocumento = :dsdocumento, nmprimeiro = :nmprimeiro, '+
    '       nmsegundo = :nmsegundo, dtregistro = :dtregistro '+
    ' WHERE idpessoa = :idpessoa';

  UPDATE_ENDERECO =
    'UPDATE endereco '+
    '   SET dscep = :dscep '+
    ' WHERE idpessoa = :idpessoa';
begin
  Result := TJSONObject.Create;

  if not PessoaExiste(AJSON.GetValue('idpessoa').Value.ToInteger()) then
  begin
    Result.AddPair('Retorno:', 'Pessoa informada não encontrada.');
    Exit;
  end;

  FDConnection.Transaction.StartTransaction;
  try
    QryPessoa.Close;
    QryPessoa.SQL.Text := UPDATE_PESSOA;
    QryPessoa.Params.ParamByName('flnatureza').AsInteger := AJSON.GetValue('flnatureza').Value.ToInteger();
    QryPessoa.Params.ParamByName('dsdocumento').AsString := AJSON.GetValue('dsdocumento').Value;
    QryPessoa.Params.ParamByName('nmprimeiro').AsString := AJSON.GetValue('nmprimeiro').Value;
    QryPessoa.Params.ParamByName('nmsegundo').AsString := AJSON.GetValue('nmsegundo').Value;
    QryPessoa.Params.ParamByName('dtregistro').AsDate := Date;
    QryPessoa.Params.ParamByName('idpessoa').AsInteger := AJSON.GetValue('idpessoa').Value.ToInteger();
    QryPessoa.ExecSQL;

    QryEndereco.Close;
    QryEndereco.SQL.Text := UPDATE_ENDERECO;
    QryEndereco.Params.ParamByName('dscep').AsString := AJSON.GetValue('dscep').Value;
    QryEndereco.Params.ParamByName('idpessoa').AsInteger := AJSON.GetValue('idpessoa').Value.ToInteger();
    QryEndereco.ExecSQL;

    FDConnection.Transaction.Commit;

    Result.AddPair('Retorno:', 'Realizado UPDATE com sucesso!');
  except
    FDConnection.Transaction.Rollback;
    Result.AddPair('Retorno:', 'Erro ao realizar UPDATE.');
  end;
end;

function TServerMethods.PessoaExiste(IdPessoa: Integer): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FDConnection;
    LQuery.Close;
    LQuery.SQL.Text := 'SELECT idpessoa FROM pessoa WHERE idpessoa = :idpessoa';
    LQuery.Params.Add('idpessoa', ftInteger, ptInput);
    LQuery.Params[0].AsInteger := IdPessoa;
    LQuery.Open;

    Result := (not LQuery.IsEmpty);
  finally
    FreeAndNil(LQuery);
  end;
end;

end.

