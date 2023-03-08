unit EnderecoIntegracaoModel;

interface

type
  TEnderecoIntegracao = class
    private
    FNmCidade: String;
    FNmLogradouro: String;
    FIdEndereco: Integer;
    FNmBairro: String;
    FDsUf: String;
    FDsComplemento: String;
    procedure setDsComplemento(const Value: String);
    procedure setDsUf(const Value: String);
    procedure setIdEndereco(const Value: Integer);
    procedure setNmCidade(const Value: String);
    procedure setNmLogradouro(const Value: String);
    procedure setNmBairro(const Value: String);

    public
      property IdEndereco    : Integer read FIdEndereco    write setIdEndereco;
      property DsUf          : String  read FDsUf          write setDsUf;
      property NmCidade      : String  read FNmCidade      write setNmCidade;
      property NmBairro      : String  read FNmBairro      write setNmBairro;
      property NmLogradouro  : String  read FNmLogradouro  write setNmLogradouro;
      property DsComplemento : String  read FDsComplemento write setDsComplemento;
  end;

implementation

{ TEnderecoIntegracao }

procedure TEnderecoIntegracao.setDsComplemento(const Value: String);
begin
  FDsComplemento := Value;
end;

procedure TEnderecoIntegracao.setDsUf(const Value: String);
begin
  FDsUf := Value;
end;

procedure TEnderecoIntegracao.setIdEndereco(const Value: Integer);
begin
  FIdEndereco := Value;
end;

procedure TEnderecoIntegracao.setNmBairro(const Value: String);
begin
  FNmBairro := Value;
end;

procedure TEnderecoIntegracao.setNmCidade(const Value: String);
begin
  FNmCidade := Value;
end;

procedure TEnderecoIntegracao.setNmLogradouro(const Value: String);
begin
  FNmLogradouro := Value;
end;

end.
