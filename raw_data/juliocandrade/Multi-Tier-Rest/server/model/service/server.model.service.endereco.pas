unit server.model.service.endereco;

interface

uses
  server.model.service.interfaces,
  server.model.dao.interfaces,
  server.model.entity.endereco.integracao, server.model.entity.endereco;
type
  TServiceEndereco = class(TInterfacedObject, iServiceEndereco)
  private
    FDAOEndereco : IDAOEndereco;
    procedure AtualizarEndereco(aEndereco : TModelEndereco);
  public
    constructor Create;
    class function New : iServiceEndereco;
    procedure AtualizarEnderecos;

  end;
implementation

uses
  server.model.dao.endereco,
  server.model.service.factory,
  server.model.entity.consultacep,
  server.model.dao.factory;

{ TServiceEndereco }

procedure TServiceEndereco.AtualizarEndereco(aEndereco : TModelEndereco);
var
  LConsultaCEP : TModelConsultaCEP;
  LEnderecoIntegracao : TModelEnderecoIntegracao;
begin
  LConsultaCEP := TModelConsultaCEP.Create;
  try
    TServiceFactory.New.CEP.Code(aEndereco.CEP).Execute(LConsultaCEP);
    if not LConsultaCEp.Erro then
    begin
      LenderecoIntegracao := TModelEnderecoIntegracao.Create;
      try
       LenderecoIntegracao.IDEndereco := aEndereco.IDEndereco;
       LenderecoIntegracao.UF := LConsultaCEP.Uf;
       LenderecoIntegracao.Cidade := LConsultaCEP.Localidade;
       LenderecoIntegracao.Bairro := LConsultaCEP.Bairro;
       LenderecoIntegracao.Logradouro := LConsultaCEP.Logradouro;
       LenderecoIntegracao.Complemento := LConsultaCEP.Complemento;
       TDAOFactory.New.EnderecoIntegracao(LEnderecoIntegracao).Alterar;
      finally
        LEnderecoIntegracao.Free;
      end;
    end;
  finally
    LConsultaCEP.Free;
  end;
end;

procedure TServiceEndereco.AtualizarEnderecos;
var
  LEndereco : TModelEndereco;
begin
  FDAOEndereco.ListarNaoAtualizados;
  while FDAOEndereco.List.HasNext do
  begin
    LEndereco := FDAOEndereco.List.Next;
    try
      AtualizarEndereco(LEndereco);
    except
      Continue;
    end;
  end;

end;

constructor TServiceEndereco.Create;
begin
  FDAOEndereco := TDAOFactory.New.Endereco(nil);
end;

class function TServiceEndereco.New: iServiceEndereco;
begin
  Result := Self.Create;
end;

end.
