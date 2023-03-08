unit uThreadViaCep;

interface

uses
  System.Classes, FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Intf, System.SysUtils,
  System.JSON, REST.Client, IPPeerClient;

type
  TEndereco = record
    erro: Boolean;
    dsuf: string;
    nmcidade: string;
    nmbairro: string;
    nmlogradouro: string;
    dscomplemento: string;
    procedure Inicializar;
  end;

  TThreadViaCep = class(TThread)
  private
    FConexao: TFDConnection;
    FQryEnderecoPendente: TFDQuery;
    FQryEnderecoIntegracao: TFDQuery;
    procedure CarregarEnderecoPendente;
    procedure InserirEnderecoIntegracao(ACep: string);
    function BuscarCEP(ACep: string): TEndereco;
  protected
    procedure Execute; override;
  public
    constructor Create(AConexao: TFDConnection); reintroduce;
    destructor Destroy;
  end;

implementation

{ ThreadViaCep }

function TThreadViaCep.BuscarCEP(ACep: string): TEndereco;
var
  LObject: TJSONObject;
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LRESTResponse: TRESTResponse;
begin
  if ACep.IsEmpty then
    Exit;

  LRESTClient := TRESTClient.Create(nil);
  LRESTRequest := TRESTRequest.Create(nil);
  LRESTResponse := TRESTResponse.Create(nil);
  LRESTRequest.Client := LRESTClient;
  LRESTRequest.Response := LRESTResponse;
  LRESTClient.BaseURL := Format('viacep.com.br/ws/%s/json/', [ACep]);
  LRESTRequest.Execute;

  LObject := LRestResponse.JSONValue as TJSONObject;
  try
    Result.Inicializar;
    if Assigned(LObject) then
    begin
      try
        if LObject.Values['erro'] <> nil then
        begin
          if LObject.Values['erro'].Value = 'true' then
          begin
            Result.erro := True;
            Exit;
          end;
        end;
      except
      end;

      try
        Result.dsuf := LObject.Values['uf'].Value;
      except
      end;

      try
        Result.nmcidade := LObject.Values['localidade'].Value;
      except
      end;

      try
        Result.nmbairro := LObject.Values['bairro'].Value;
      except
      end;

      try
        Result.nmlogradouro := LObject.Values['logradouro'].Value;
      except
      end;

      try
        Result.dscomplemento := LObject.Values['complemento'].Value;
      except
      end;
    end;
  finally
    LObject.Free;
  end;
end;

procedure TThreadViaCep.CarregarEnderecoPendente;
const
  SQL =
    'select e.idendereco, e.idpessoa, e.dscep '+
    '  from endereco e '+
    ' where not exists (select * from endereco_integracao ei where ei.idendereco = e.idendereco)';
begin
  if not Assigned(FQryEnderecoPendente) then
  begin
    FQryEnderecoPendente := TFDQuery.Create(nil);
    FQryEnderecoPendente.Connection := FConexao;
    FQryEnderecoPendente.CachedUpdates := True;
  end;

  FQryEnderecoPendente.Open(SQL);
end;

constructor TThreadViaCep.Create(AConexao: TFDConnection);
begin
  inherited Create(True);
  FConexao := AConexao;

  FQryEnderecoIntegracao := TFDQuery.Create(nil);
  FQryEnderecoIntegracao.Connection := FConexao;

  FreeOnTerminate := True;
  Priority := tpLower;
  Resume;
end;

destructor TThreadViaCep.Destroy;
begin
  FreeAndNil(FQryEnderecoPendente);
end;

procedure TThreadViaCep.Execute;
begin
  while not Terminated do
  begin
    CarregarEnderecoPendente;

    FQryEnderecoPendente.First;
    while not FQryEnderecoPendente.Eof do
    begin
      InserirEnderecoIntegracao(FQryEnderecoPendente.FieldByName('dscep').AsString);
      FQryEnderecoPendente.Next;
    end;

    Sleep(5000);
  end;
end;

procedure TThreadViaCep.InserirEnderecoIntegracao(ACep: string);
const
  INSERT =
    'insert into endereco_integracao (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) '+
    '                         values (%d, %s, %s, %s, %s, %s)';
var
  LEndereco: TEndereco;
begin
  LEndereco := BuscarCEP(ACep);

  if LEndereco.erro then
    Exit;

  FQryEnderecoIntegracao.SQL.Text :=
    Format(INSERT, [FQryEnderecoPendente.FieldByName('idendereco').AsInteger,
                    LEndereco.dsuf.QuotedString, LEndereco.nmcidade.QuotedString, LEndereco.nmbairro.QuotedString,
                    LEndereco.nmlogradouro.QuotedString, LEndereco.dscomplemento.QuotedString]);
  FQryEnderecoIntegracao.ExecSQL;
end;

{ TCep }

procedure TEndereco.Inicializar;
begin
  erro := False;
  dsuf := EmptyStr;
  nmcidade := EmptyStr;
  nmbairro := EmptyStr;
  nmlogradouro := EmptyStr;
  dscomplemento := EmptyStr;
end;

end.
