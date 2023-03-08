unit ControllerEnderecoIntegracao;

interface

uses
  EnderecoIntegracao, unDm, FireDAC.Comp.Client, System.JSON;

type
  TControleEnderecoIntegracao = class
  private

  public
    function BuscaPorCEP(pCEP : string; pEnderecoIntegracao : TEnderecoIntegracao):boolean;
    procedure DadosEnderecoIntegracao(pEnderecoIntegracao: TEnderecoIntegracao);
    procedure BuscaIdEnderecoIntegracao(
      pEnderecoIntegracao: TEnderecoIntegracao);
    procedure AlterarRegistro(oEnderecoIntegracao: TEnderecoIntegracao);
    procedure InserirRegistro(oEnderecoIntegracao: TEnderecoIntegracao);
    function RegistroExistente(pIdEndereco: longInt): Boolean;
  end;

implementation

function TControleEnderecoIntegracao.BuscaPorCEP(pCEP : string; pEnderecoIntegracao : TEnderecoIntegracao):boolean;
var
  Retorno: TJSONObject;
begin
  DM.RESTClient.BaseURL := 'https://viacep.com.br/ws/'+pCEP+'/json/';
  DM.RESTRequest.Execute;
  Retorno := dm.RESTRequest.Response.JSONValue as TJSONObject;

  Result := Retorno.GetValue('erro') = nil;
  if Result then
  begin
    BuscaIdEnderecoIntegracao(pEnderecoIntegracao);
    pEnderecoIntegracao.DsUF := Retorno.GetValue('uf').value;
    pEnderecoIntegracao.NmCidade := Retorno.GetValue('localidade').value;
    pEnderecoIntegracao.NmBairro  := Retorno.GetValue('bairro').value;
    pEnderecoIntegracao.NmLogradouro  := Retorno.GetValue('logradouro').value;
    pEnderecoIntegracao.DsComplemento  := Retorno.GetValue('complemento').value;
  end;
end;


procedure TControleEnderecoIntegracao.BuscaIdEnderecoIntegracao(pEnderecoIntegracao : TEnderecoIntegracao);
var
  qEnderecoIntegracao : TFDQuery;
begin
  qEnderecoIntegracao := TFDQuery.Create(nil);
  try
    qEnderecoIntegracao.Connection := DM.FDConnection;
    qEnderecoIntegracao.SQL.Add('SELECT nextval(''endereco_idendereco_seq'') as id ; ');
    qEnderecoIntegracao.Open;
    pEnderecoIntegracao.IdEndereco := qEnderecoIntegracao.fieldbyname('id').AsInteger;
  finally
    qEnderecoIntegracao.Free;
  end;
end;

procedure TControleEnderecoIntegracao.DadosEnderecoIntegracao(pEnderecoIntegracao : TEnderecoIntegracao);
var
  qEnderecoIntegracao : TFDQuery;
begin
  qEnderecoIntegracao := TFDQuery.Create(nil);
  try
    qEnderecoIntegracao.Connection := DM.FDConnection;
    qEnderecoIntegracao.SQL.Add('SELECT ');
    qEnderecoIntegracao.SQL.Add('  idendereco,');
    qEnderecoIntegracao.SQL.Add('  dsuf, ');
    qEnderecoIntegracao.SQL.Add('  nmcidade,');
    qEnderecoIntegracao.SQL.Add('  nmbairro,');
    qEnderecoIntegracao.SQL.Add('  nmlogradouro,');
    qEnderecoIntegracao.SQL.Add('  dscomplemento ');
    qEnderecoIntegracao.SQL.Add('FROM  ');
    qEnderecoIntegracao.SQL.Add('  public.endereco_integracao ');
    qEnderecoIntegracao.SQL.Add('WHERE idendereco =:pIdendereco  ');
    qEnderecoIntegracao.Parambyname('pIdendereco').AsInteger := pEnderecoIntegracao.IdEndereco;
    qEnderecoIntegracao.Open;
    pEnderecoIntegracao.DsUF := qEnderecoIntegracao.fieldbyname('dsuf').AsString;
    pEnderecoIntegracao.NmCidade := qEnderecoIntegracao.fieldbyname('nmcidade').AsString;
    pEnderecoIntegracao.NmBairro := qEnderecoIntegracao.fieldbyname('nmbairro').AsString;
    pEnderecoIntegracao.NmLogradouro := qEnderecoIntegracao.fieldbyname('nmlogradouro').AsString;
    pEnderecoIntegracao.DsComplemento := qEnderecoIntegracao.fieldbyname('dscomplemento').AsString;
  finally
    qEnderecoIntegracao.Free;
  end;
end;

procedure TControleEnderecoIntegracao.InserirRegistro(oEnderecoIntegracao : TEnderecoIntegracao);
var
  qEnderecoIntegracao  : TFDQuery;
begin

  qEnderecoIntegracao := TFDQuery.Create(nil);
  try
    qEnderecoIntegracao.Connection := DM.FDConnection;
    qEnderecoIntegracao.SQL.Add('INSERT INTO public.endereco_integracao ( ');
    qEnderecoIntegracao.SQL.Add('  idendereco, ');
    qEnderecoIntegracao.SQL.Add('  dsuf, ');
    qEnderecoIntegracao.SQL.Add('  nmcidade, ');
    qEnderecoIntegracao.SQL.Add('  nmbairro, ');
    qEnderecoIntegracao.SQL.Add('  dscomplemento, ');
    qEnderecoIntegracao.SQL.Add('  nmlogradouro) ');
    qEnderecoIntegracao.SQL.Add('VALUES ( ');
    qEnderecoIntegracao.SQL.Add('  :idendereco, ');
    qEnderecoIntegracao.SQL.Add('  :dsuf, ');
    qEnderecoIntegracao.SQL.Add('  :nmcidade, ');
    qEnderecoIntegracao.SQL.Add('  :nmbairro, ');
    qEnderecoIntegracao.SQL.Add('  :dscomplemento, ');
    qEnderecoIntegracao.SQL.Add('  :nmlogradouro) ');
    qEnderecoIntegracao.ParambyName('idendereco').AsInteger := oEnderecoIntegracao.IdEndereco;
    qEnderecoIntegracao.ParambyName('dsuf').AsString := oEnderecoIntegracao.DsUF;
    qEnderecoIntegracao.ParambyName('nmcidade').AsString := oEnderecoIntegracao.NmCidade;
    qEnderecoIntegracao.ParambyName('nmbairro').AsString := oEnderecoIntegracao.NmBairro;
    qEnderecoIntegracao.ParambyName('dscomplemento').AsString := oEnderecoIntegracao.DsComplemento;
    qEnderecoIntegracao.ParambyName('nmlogradouro').AsString := oEnderecoIntegracao.NmLogradouro;
    qEnderecoIntegracao.ExecSQL;

  finally
    qEnderecoIntegracao.Free;
  end;
end;

procedure TControleEnderecoIntegracao.AlterarRegistro(oEnderecoIntegracao : TEnderecoIntegracao);
var
  qEnderecoIntegracao : TFDQuery;
begin

  qEnderecoIntegracao := TFDQuery.Create(nil);
  try
    qEnderecoIntegracao.Connection := DM.FDConnection;
    qEnderecoIntegracao.SQL.Add('UPDATE ');
    qEnderecoIntegracao.SQL.Add('  public.endereco_integracao ');
    qEnderecoIntegracao.SQL.Add('SET ');
    qEnderecoIntegracao.SQL.Add('  dsuf = :dsuf,');
    qEnderecoIntegracao.SQL.Add('  nmcidade = :nmcidade, ');
    qEnderecoIntegracao.SQL.Add('  nmbairro = :nmbairro, ');
    qEnderecoIntegracao.SQL.Add('  dscomplemento = :dscomplemento, ');
    qEnderecoIntegracao.SQL.Add('  nmlogradouro = :nmlogradouro ');
    qEnderecoIntegracao.SQL.Add('WHERE ');
    qEnderecoIntegracao.SQL.Add('  idendereco = :idendereco ');
    qEnderecoIntegracao.ParambyName('idendereco').AsInteger := oEnderecoIntegracao.IdEndereco;
    qEnderecoIntegracao.ParambyName('dsuf').AsString := oEnderecoIntegracao.DsUF;
    qEnderecoIntegracao.ParambyName('nmcidade').AsString := oEnderecoIntegracao.NmCidade;
    qEnderecoIntegracao.ParambyName('nmbairro').AsString := oEnderecoIntegracao.NmBairro;
    qEnderecoIntegracao.ParambyName('dscomplemento').AsString := oEnderecoIntegracao.DsComplemento;
    qEnderecoIntegracao.ParambyName('nmlogradouro').AsString := oEnderecoIntegracao.NmLogradouro;
    qEnderecoIntegracao.ExecSQL;
  finally
    qEnderecoIntegracao.Free;
  end;
end;

function TControleEnderecoIntegracao.RegistroExistente(pIdEndereco : longInt) : Boolean;
var
  qEnderecoIntegracao: TFDQuery;
begin
  qEnderecoIntegracao := TFDQuery.Create(nil);
  try
    qEnderecoIntegracao.Connection := DM.FDConnection;
    qEnderecoIntegracao.SQL.Add('SELECT count(*) as reg ');
    qEnderecoIntegracao.SQL.Add('FROM endereco_integracao ');
    qEnderecoIntegracao.SQL.Add('WHERE idendereco = :pIdEndereco ');
    qEnderecoIntegracao.ParambyName('pIdEndereco').AsInteger := pIdEndereco;
    qEnderecoIntegracao.Open;

  finally
    Result := qEnderecoIntegracao.FieldByName('reg').AsInteger > 0;
    qEnderecoIntegracao.Free;
  end;
end;

end.
