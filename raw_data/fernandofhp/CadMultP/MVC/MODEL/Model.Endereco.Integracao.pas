unit Model.Endereco.Integracao;

interface

type
  TEnderecoIntegracao = class(TObject)
  private
    FNmCidade: string;
    FNmLogradouro: string;
    FIdEndereco: Integer;
    FNmBairro: string;
    FDsUF: string;
    FDsComplemento: string;
    procedure SetDsComplemento(const Value: string);
    procedure SetDsUF(const Value: string);
    procedure SetIdEndereco(const Value: Integer);
    procedure SetNmBairro(const Value: string);
    procedure SetNmCidade(const Value: string);
    procedure SetNmLogradouro(const Value: string);

  public
    property IdEndereco: Integer read FIdEndereco write SetIdEndereco;
    property DsUF: string read FDsUF write SetDsUF;
    property NmCidade: string read FNmCidade write SetNmCidade;
    property NmBairro: string read FNmBairro write SetNmBairro;
    property NmLogradouro: string read FNmLogradouro write SetNmLogradouro;
    property DsComplemento: string read FDsComplemento write SetDsComplemento;
  end;

implementation

{ TEnderecoIntegracao }

procedure TEnderecoIntegracao.SetDsComplemento(const Value: string);
begin
  FDsComplemento := Value;
end;

procedure TEnderecoIntegracao.SetDsUF(const Value: string);
begin
  FDsUF := Value;
end;

procedure TEnderecoIntegracao.SetIdEndereco(const Value: Integer);
begin
  FIdEndereco := Value;
end;

procedure TEnderecoIntegracao.SetNmBairro(const Value: string);
begin
  FNmBairro := Value;
end;

procedure TEnderecoIntegracao.SetNmCidade(const Value: string);
begin
  FNmCidade := Value;
end;

procedure TEnderecoIntegracao.SetNmLogradouro(const Value: string);
begin
  FNmLogradouro := Value;
end;

end.
